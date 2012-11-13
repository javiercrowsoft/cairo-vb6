VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cDataBaseAccess"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cDataBaseAccess
' 27-11-2004

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cDataBaseAccess"
' estructuras
' variables privadas
' eventos
' propiedades publicas
' propiedades friend
' propiedades privadas
' funciones publicas
' Proposito devuelve si existe o no un Register con field = value
Public Function Exists(ByRef db As cDataBase, _
                       ByRef retValue As Boolean, _
                       ByVal Table As String, _
                       ByVal Condition As String, _
                       Optional ByVal Field As String = "*", _
                       Optional ByVal FunctionName As String = "", _
                       Optional ByVal Module As String = "", _
                       Optional ByVal Title As String = "Error", _
                       Optional ByVal Level As csErrorLevel = csErrorInformation) As Boolean
                       
    Dim sqlstmt As String
    Dim Rs As ADODB.Recordset
    
    sqlstmt = "SELECT " + Field + " FROM " + Table + " WHERE " + Condition
                         
    If Not db.OpenRs(sqlstmt, Rs, adOpenForwardOnly, adLockOptimistic, adCmdText, FunctionName, Module, Title, Level) Then GoTo ExitProc
                             
    retValue = Not Rs.EOF
    
    Exists = True
ExitProc:
    On Error Resume Next
    Rs.Close
    Set Rs = Nothing
End Function

Public Function ExistsDatabase(ByVal Name As String) As Boolean
  ExistsDatabase = ExistsFile(Name)
End Function

Public Function ClearDataBase() As Boolean
  ClearDataBase = True
End Function

Public Function AccessFieldToString(Field As ADODB.Field) As String
  Dim retval As String, Value As String
  If IsNull(Field.Value) Then
    retval = "NULL"
  Else
    Select Case Field.Type
    Case adBoolean, adBinary, adSmallInt, adInteger, adSingle, adDouble, adCurrency, adNumeric, adLongVarBinary
      retval = Trim(Field.Value)
    Case adDate, adDBTime, adDBDate, adDBTimeStamp
      retval = "#" + Format$(Field.Value, "mm/dd/yyyy HH:nn:ss") + "#"
    Case adChar, adVarChar, adWChar, adVarWChar, adLongVarChar, adLongVarWChar
      Value = Replace(Field.Value, "|", "")
      Value = Replace(Value, "'", "''")
      retval = "'" + Value + "'"
    End Select
  End If
  AccessFieldToString = retval
End Function

Public Function AccessTextForType(ByVal VarType As csDataType, ByVal Width As Long)
  'los Texts correspondientes para Access
  Dim retval As String
  Select Case VarType
  Case adChar, adVarChar, adLongVarChar, adLongVarWChar, adWChar, adVarWChar
    If Width > 255 Then
      retval = "MEMO"
    Else
      retval = "STRING(" + Trim(Width) + ")"
    End If
  Case adDecimal, adNumeric, adDouble, adSingle, adCurrency
    retval = "DOUBLE"
  Case adInteger, adBigInt
    retval = "LONG"
  Case adSmallInt, adTinyInt
    retval = "INTEGER"
  Case adDBTime, adDBTimeStamp, adDBDate, adDate
    retval = "DATETIME"
  Case adBoolean
    retval = "BIT"
  Case adBinary, adLongVarBinary
    retval = "LONGBINARY"
  Case Else
    Debug.Print "No esta previsto el Type " + Trim(VarType)
    retval = "STRING(50)"
  End Select
  AccessTextForType = retval
End Function

' Esta FunctionName crea una base si la conexion es sql
' si la conexion es access, copia el File plantilla.mdb y lo renombra
Public Function CreateDataBase(ByVal Name As String, ByVal VarType As crServerType) As Boolean
  If VarType = SERVER_ACCESS Then
    If ExistsDatabase(Name) Then Kill Name
    Dim ofile As cFile
    Set ofile = New cFile
    If Not ofile.CopyFile(ofile.GetPath(Name) + "\Plantilla.mdb", Name) Then Exit Function
    Set ofile = Nothing
  Else
    Dim sqlstmt As String
    sqlstmt = "CREATE DATABASE " + Name '.... Y SIGO OTRO DIA
  End If
  CreateDataBase = True
End Function

Public Function UpdateFromRs(ByRef db As cDataBase, _
                             ByRef ds As ADODB.Recordset, _
                             ByVal TableName As String, _
                             ByVal IdFieldName As String, _
                             ByVal nOption As Integer) As Boolean
                             
  Dim IdFieldExtended As String
  Dim ValueFieldExtended As Long
  
  UpdateFromRs = UpdateFromRsExt(db, ds, TableName, IdFieldName, nOption, IdFieldExtended, ValueFieldExtended)
End Function

Private Function UpdateFromRsExt(ByRef db As cDataBase, _
                                 ByRef Rs As ADODB.Recordset, _
                                 ByVal TableName As String, _
                                 ByVal IdFieldName As String, _
                                 ByVal nOption As Integer, _
                                 ByVal IdFieldExtended As String, _
                                 ByVal ValueFieldExtended As Long)
                                 
  ' Con los datos del dynaset tengo que armar la
  ' sentencia SQL para ejecutar

  Dim Condition As String
  Dim CantFields As Integer, i As Integer
  Dim IsNew As Boolean
  
  Dim Register As cRegister
  
  Set Register = New cRegister

  CantFields = Rs.fields.Count
  
  Register.Table = TableName
  
  If Not Trim(IdFieldName) = "" Then
    Register.fieldId = IdFieldName
    Register.ID = ValField_(Rs.fields, IdFieldName)
  End If
  
  For i = 0 To CantFields - 1
    If UCase(Trim(Rs.fields(i).Name)) <> UCase(IdFieldName) Then
      Register.fields.Add2 Rs.fields(i).Name, FieldToString(Rs.fields(i)), GetFieldType_(Rs.fields(i))
    End If
  Next

  If Not Trim(IdFieldExtended) = "" Then
    Register.fields.Add2 IdFieldExtended, ValueFieldExtended, csId
  End If

  Select Case nOption
  Case OPTION_UPDATE_IS_NEW
    IsNew = True
  Case OPTION_UPDATE_CHECK_IS_NEW
    Condition = IdFieldName + " = " + Trim(ValField_(Rs.fields, IdFieldName))
    If Not Exists(db, IsNew, TableName, Condition, , "UpdateFromRsExt", "cDataBase") Then Exit Function
    IsNew = Not IsNew
  Case Else
    IsNew = False
  End Select
    
  UpdateFromRsExt = db.Save(Register, "UpdateFromRsExt", "cDataBase")
End Function

' funciones friend
' funciones privadas
' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
  On Error GoTo ControlError

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Terminate", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

'//////////////////////////////
'  Codigo estandar de errores
'  On Error GoTo ControlError
'
'  GoTo ExitProc
'ControlError:
'  MngError err,"", C_Module, ""
'  If Err.Number Then Resume ExitProc
'ExitProc:
'  On Error Resume Next



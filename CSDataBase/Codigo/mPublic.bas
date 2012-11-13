Attribute VB_Name = "mPublic"
Option Explicit

'--------------------------------------------------------------------------------
' mPublic
' 29-07-2003

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones
'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "mPublic"

Public Const c_K_MainIniConfig = "DATABASE-CONFIG"
Public Const c_MainIniFile = "CSDatabase.ini"
Public Const c_DB_USESQLOLEDB = "USE_SQL_OLEDB"
Public Const c_DB_USENTSECURITY = "USE_NTSECURITY"
' estructuras
' variables privadas
' eventos
' propiedades publicas
Public gbSilent             As Boolean
' propiedades friend
' propiedades privadas
' funciones publicas
Public Function ValField_(ByRef fields As ADODB.fields, ByVal FieldName As String, Optional ByRef FieldType As csFieldType) As Variant
  On Error GoTo ControlError
  
  Dim Field As ADODB.Field
  
  If IsNumeric(FieldName) Then
    Set Field = fields(CInt(FieldName))
  Else
    Set Field = fields(FieldName)
  End If
  
  If Field Is Nothing Then
    Err.Raise vbObjectError + csErrorVal, "VAL function CSOAPI", "No se paso un campo. Error interno"
  End If
  
  If IsNull(Field.Value) Then
    Select Case Field.Type
      Case adLongVarChar, adLongVarWChar, adChar, adVarChar, adVarWChar, adWChar
        ValField_ = ""
      Case adBigInt, adBinary, adInteger, adLongVarBinary, adNumeric, adSmallInt, adTinyInt, adUnsignedBigInt, adUnsignedInt, adUnsignedSmallInt, adUnsignedTinyInt
        ValField_ = 0
      Case adBoolean
        ValField_ = False
      Case adCurrency, adSingle, adDecimal, adDouble
        ValField_ = 0
      Case adDBTime, adDate, adDBDate
        ValField_ = csNoDate
      Case adDBTimeStamp
        ValField_ = csNoDate
    End Select
  Else
    ValField_ = Field.Value
  End If
  
  ' Comprobacion especial para el field activo
  If LCase(Field.Name) = cscActivo Then
    FieldType = csFieldBoolean
  End If

  Exit Function
ControlError:
  If Err.Number = 3265 Then Err.Description = "Falto el campo " & FieldName & vbCrLf & "Descripción original:" & Err.Description
  Err.Raise Err.Number, Err.Source, Err.Description, Err.HelpFile, Err.HelpContext
End Function

'----------------------------------------------------------------------------------------------
Public Function FieldToString(ByVal f As ADODB.Field) As String
  If f Is Nothing Then
    Err.Raise vbObjectError + csErrorVal, "VAL function CSOAPI", "No se paso un field. Error interno"
  End If
  If IsNull(f.Value) Then
    FieldToString = "null"
  Else
    FieldToString = Trim(f.Value)
  End If
End Function

Public Function GetFieldType_(Field As ADODB.Field) As csFieldType
  If LCase(Field.Name) = cscActivo Then
    GetFieldType_ = csFieldBoolean
  Else
    Select Case Field.Type
      Case adVarChar, adChar
        GetFieldType_ = csFieldChar
      Case adDate, adDBDate, adDBTime
        GetFieldType_ = csFieldDate
      Case Else
        GetFieldType_ = csFieldNumeric
    End Select
  End If
End Function

' funciones friend
' funciones privadas
' construccion - destruccion
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


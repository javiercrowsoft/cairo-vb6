VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cObjetoProceso"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cObjetoProceso
' 16-07-2003

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cObjetoProceso"
' estructuras
' variables privadas
' eventos
' propiedades publicas
Public Function ProcessRecord(Parametros As cIAFIPParametros, Fields As ADODB.Fields, Campos As cIAFIPCampos, ByVal IsLastRecord As Boolean, IsEmptyRecord As Boolean, ByVal lIndexRecord As Long, Esquema As cIAFIPEsquema) As Boolean
  Dim Campo        As cIAFIPCampo
  Dim fld          As ADODB.Field
  Dim Found        As Boolean
  Dim msg          As String
  Dim Columns      As String
  
  For Each Campo In Campos
    
    If Campo.Columna <> C_ID Then
    
      If Campo.Columna = "" Then
        msg = "Error en la definición del campo [" & Campo.Nombre & "]: no se indico una columna" & vbCrLf
        msg = msg & "Si el campo no posee columna se debe indicar un #"
        Esquema.Log C_Module, msg, LogSevError
        Exit Function
      
      ElseIf Campo.Columna <> "#" Then
        Found = False
        
        For Each fld In Fields
          If LCase(Campo.Columna) = LCase(fld.Name) Then
          
            Campo.Valor = ValField(Fields, fld.Name)
  
            ' Si es una fecha, tengo que pasarla al formato de la
            ' pc por que en stradivarius la guardan en formato
            ' japones y sin separadores ej. 20030101
            If Campo.FormatoFecha <> "" Then
              With Campo
                .Valor = DateSerial(Val(Mid$(.Valor, 1, 4)), Val(Mid$(.Valor, 5, 2)), Val(Mid$(.Valor, 7, 2)))
              End With
            End If
            
            Found = True
            Exit For
          End If
        Next
        
        If Not Found Then
          For Each fld In Fields
            Columns = Columns & fld.Name & ","
          Next
          
          msg = "Error: No se encontro la columna [" & Campo.Columna & "]"
          msg = msg & " del campo [" & Campo.Nombre & "]" & vbCrLf
          msg = msg & "Columnas en Fields: " & RemoveLastColon(Columns)
          
          Esquema.Log C_Module, msg, LogSevError
          Exit Function
        End If
      End If
    End If
  Next
  
  ProcessRecord = True
End Function
' propiedades friend
' propiedades privadas
' funciones publicas
' funciones friend
' funciones privadas
' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
  On Error GoTo ControlError

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Terminate", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
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
'  If Err.Number <> 0 Then Resume ExitProc
'ExitProc:
'  On Error Resume Next



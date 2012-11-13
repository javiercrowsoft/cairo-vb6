VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cUtil"
Attribute VB_GlobalNameSpace = True
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cUtil
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
Private Const C_Module = "cUtil"
' estructuras
' variables privadas
' eventos
' propiedades publicas
' propiedades friend
' propiedades privadas
' funciones publicas
Public Function GetParamValue(ByVal ParamName As String, ByRef Parametros As cIAFIPParametros) As String
  Dim Param As cIAFIPParametro

  ParamName = LCase(ParamName)
  
  For Each Param In Parametros
    If LCase(Param.Nombre) = ParamName Then
      GetParamValue = Param.Valor
      Exit Function
    End If
  Next
End Function

Public Function GetParamId(ByVal ParamName As String, ByRef Parametros As cIAFIPParametros) As String
  Dim Param As cIAFIPParametro

  ParamName = LCase(ParamName)
  
  For Each Param In Parametros
    If LCase(Param.Nombre) = ParamName Then
      GetParamId = Param.ID
      Exit Function
    End If
  Next
End Function

Public Function GetParamValueProcess(ByVal ParamName As String, ByRef Parametros As cIAFIPParametros) As String
  Dim Param As cIAFIPParametro

  ParamName = LCase(ParamName)
  
  For Each Param In Parametros
    If LCase(Param.Nombre) = ParamName Then
      ' En el campo descrip ponemos el value process
      ' para no modificar la interfaz de este objeto
      '
      GetParamValueProcess = Param.Descrip
      Exit Function
    End If
  Next
End Function

Public Function GetDate(ByVal ParamName As String, ByRef Parametros As cIAFIPParametros, Optional ByVal strFormat As String = "YYYYMMDD") As String
  Dim strDate As String
  
  strDate = GetParamValue(ParamName, Parametros)
  If Not IsDate(strDate) Then
    strDate = VDGetDate(strDate)
  End If
  strDate = Format(DateValue(strDate), strFormat)

  GetDate = strDate
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
'  If Err.Number <> 0 Then Resume ExitProc
'ExitProc:
'  On Error Resume Next



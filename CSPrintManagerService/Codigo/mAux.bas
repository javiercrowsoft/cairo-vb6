Attribute VB_Name = "mAux"
Option Explicit

Public Const C_LoadFunction = "Load"
Public Const csSqlDateString   As String = "\'yyyy-mm-dd HH:nn:ss\'"   'Access
Public Const csNoDate          As Date = #1/1/1900#

Public Const C_PSqlFechaHora                    As String = "\'yyyymmdd HH:nn:ss\'"   'MS SQLServer
Public Const C_PSqlFecha                        As String = "\'yyyymmdd\'"

Public Const csNO_ID As Long = 0

Public gLogTrafic As Boolean

Public gDb As cDataBaseBridge
Public User As cUser

Public EmpId As Long

' Configuracion
Public Const csTConfiguracion                         As String = "Configuracion"
Public Const cscCfgGrupo                              As String = "cfg_grupo"
Public Const cscCfgAspecto                            As String = "cfg_aspecto"
Public Const cscCfgValor                              As String = "cfg_valor"

Public Sub MngError(ByRef ErrObj As Object, ByVal FunctionName As String, ByVal Module As String, ByVal InfoAdd As String)
  Dim msg As String
  
  msg = "Error-module: " & Module
  fMain.lsEvents.AddItem msg
  msg = "Error-function: " & FunctionName
  fMain.lsEvents.AddItem msg
  msg = "Error-description: " & ErrObj.Description
  fMain.lsEvents.AddItem msg
  msg = "Error-infoadd: " & InfoAdd
  fMain.lsEvents.AddItem msg
End Sub

Public Sub SaveLog(ByVal msg As String, Optional ByVal dummy As Boolean)
  fMain.addMessage msg
End Sub

Public Function LNGGetText(ByVal codigo As String, ByVal default As String, ParamArray params() As Variant) As String

End Function

Public Sub MsgWarning(ByVal msg As String, Optional ByVal Title As String)
  fMain.addMessage Title & " - " & msg
End Sub

VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 3  'UsesTransaction
END
Attribute VB_Name = "cWebReport"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cWebReport
' 21-04-2004

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cWebReport"
' estructuras
' variables privadas
' eventos
' propiedades publicas
Public Function GetSectionMenu(ByVal Section As String, ByVal UsId As Long) As Recordset
  On Error GoTo errorHandler

  Dim rs      As ADODB.Recordset
  Dim objDB   As CSWebDataBase.cWebReport

  Set objDB = New CSWebDataBase.cWebReport

  Set rs = objDB.GetReport(Section, UsId)

  Set objDB = Nothing
  
  Set GetSectionMenu = rs
  
  GetObjectContext.SetComplete
  Exit Function

errorHandler:
  
  Set objDB = Nothing
  CtxRaiseError C_Module, "GetSectionMenu (" & Section & "," & UsId & ")"
End Function

Public Function GetObjRpt(ByVal RptId As Long, ByVal us_id As Long) As CSWebReport.cWebReport
  On Error GoTo errorHandler

  Dim RptObj As CSWebReport.cWebReport
  Set RptObj = CreateObject("CSWebReport.cWebReport")

  If Not RptObj.Load(RptId, us_id) Then Exit Function
  Set GetObjRpt = RptObj
  
  GetObjectContext.SetComplete
  Exit Function

errorHandler:
  
  CtxRaiseError C_Module, "GetObjRpt(" & RptId & ")"
End Function
' propiedades friend
' propiedades privadas
' funciones publicas
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

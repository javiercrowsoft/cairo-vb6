Attribute VB_Name = "mPublic"
Option Explicit

'--------------------------------------------------------------------------------
' mPublic
' 23-03-02

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
' estructuras
' variables privadas
Private m_NextKey As Long

' variables publicas

' Base de datos
Public gDB          As cDataBase

' nombre de la Aplication
Public gAppName     As String

Public gColRptManager As Collection
Public gColObjManager As Collection

' funciones publicas
'Public Function GetRptManager(ByRef RptManager As cRptManager, _
                              ByVal RptName As String, _
                              ByVal Path As String, _
                              ByVal Report As CSReportDll2.cReport, _
                              ByRef Preview As Object) As Boolean
Public Function GetRptManager(ByRef RptManager As cRptManager, _
                              ByVal rptName As String, _
                              ByVal Path As String, _
                              ByVal Report As cReport, _
                              ByRef Preview As Object) As Boolean
  On Error GoTo ControlError
  
  If Not ExistsObjectInColl(gColRptManager, rptName) Then
    Set RptManager = New cRptManager
    RptManager.CountReference = RptManager.CountReference + 1
    RptManager.Load rptName, Path, Report
    gColRptManager.Add RptManager, rptName
  Else
    Set RptManager = gColRptManager(rptName)
  End If
  
  GoTo ExitProc
ControlError:
  MngError Err, "GetRptManager", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Public Function GetRptManagerForGrid(ByRef RptManager As cRptManager, _
                                     ByVal rptName As String, _
                                     ByVal Path As String, _
                                     ByVal Grid As cGrid, _
                                     ByRef Preview As Object) As Boolean
  On Error GoTo ControlError
  
  If Not ExistsObjectInColl(gColRptManager, rptName) Then
    Set RptManager = New cRptManager
    RptManager.CountReference = RptManager.CountReference + 1
    RptManager.LoadForGrid rptName, Path, Grid
    gColRptManager.Add RptManager, rptName
  Else
    Set RptManager = gColRptManager(rptName)
  End If
  
  GoTo ExitProc
ControlError:
  MngError Err, "GetRptManagerForGrid", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Public Function DestroyRptManager(ByVal rptName As String)
  On Error GoTo ControlError

  If ExistsObjectInColl(gColRptManager, rptName) Then
    Dim RptManager As cRptManager
    Set RptManager = gColRptManager(rptName)
    RptManager.CountReference = RptManager.CountReference = -1
    If RptManager.CountReference < 1 Then
      gColRptManager.Remove rptName
    End If
  End If

  GoTo ExitProc
ControlError:
  MngError Err, "GetRptManager", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Public Function GetObjManager(ByVal ObjName As String) As Object
  On Error GoTo ControlError
  
  Dim ObjManager As Object
  
  If Not ExistsObjectInColl(gColObjManager, ObjName) Then
    Set ObjManager = CSKernelClient2.CreateObject(ObjName)
    ObjManager.CountReference = ObjManager.CountReference + 1
    gColObjManager.Add ObjManager, ObjName
  Else
    Set ObjManager = gColObjManager(ObjName)
  End If
  
  Set GetObjManager = ObjManager
  
  GoTo ExitProc
ControlError:
  MngError Err, "GetObjManager", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Public Function DestroyObjManager(ByVal ObjName As String)
  On Error GoTo ControlError

  If ExistsObjectInColl(gColObjManager, ObjName) Then
    Dim ObjManager As Object
    Set ObjManager = gColObjManager(ObjName)
    ObjManager.CountReference = ObjManager.CountReference = -1
    If ObjManager.CountReference < 1 Then
      gColObjManager.Remove ObjName
    End If
  End If

  GoTo ExitProc
ControlError:
  MngError Err, "GetObjManager", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Public Function GetNextKey() As Long
  m_NextKey = m_NextKey + 1
  GetNextKey = m_NextKey
End Function
' funciones privadas
' construccion - destruccion

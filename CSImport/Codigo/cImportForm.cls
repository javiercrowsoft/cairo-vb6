VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cImportForm"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cImportForm
' 27-06-2004

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cImportForm"
' estructuras
' variables privadas
Private m_Cancel                        As Boolean
#If Not PREPROC_UNATTENDED Then
  Private WithEvents m_fImport            As fImport
Attribute m_fImport.VB_VarHelpID = -1
#End If
Private m_impp_id                       As Long
' eventos
' propiedades publicas
Public Property Get Cancel() As Boolean
#If Not PREPROC_UNATTENDED Then
  Cancel = m_fImport.Cancel
#End If
End Property

Public Property Let Title(ByVal rhs As String)
#If Not PREPROC_UNATTENDED Then
  m_fImport.lbTitle = rhs
#End If
End Property

Public Property Let Descript(ByVal rhs As String)
#If Not PREPROC_UNATTENDED Then
  m_fImport.lbDescrip = rhs
#End If
End Property
' propiedades friend
' propiedades privadas
' funciones publicas
Public Function ShowProgress(ByVal Progress As Double)
  On Error Resume Next
#If Not PREPROC_UNATTENDED Then
  UpdateStatus m_fImport.picStatus, Progress / 100
#End If
End Function
' funciones friend
#If Not PREPROC_UNATTENDED Then
  Friend Function RunImport(ByVal impp_id As Long)
#Else
  Public Function RunImport(ByVal impp_id As Long)
#End If

  m_impp_id = impp_id

#If Not PREPROC_UNATTENDED Then
  
  Set m_fImport = New fImport
  m_fImport.Show vbModal

#Else

  On Error Resume Next
  pExecuteImport

#End If
End Function

Public Sub SaveLogToDb(ByVal msg As String, ByVal Severity As csLogSeverity, _
                       ByVal impp_id As Long, ByVal Module As String)
  pSaveLogToDb msg, Severity, impp_id, Module
End Sub
' funciones privadas
#If Not PREPROC_UNATTENDED Then
  Private Sub m_fImport_Execute()
    On Error Resume Next
    
    pExecuteImport
  
    On Error Resume Next
    Unload m_fImport
  End Sub
#End If

Private Sub pExecuteImport()
  Dim rs        As Recordset
  Dim sqlstmt   As String
  
  sqlstmt = "select imppi_id, imppi_objeto, imppi_params from ImportacionProcesoItem where impp_id = " & m_impp_id
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  gDB.DisconnectRecordset rs
  
  While Not rs.EOF
    If Not pExecuteImportAux(gDB.ValField(rs.Fields, cscImppiObjeto), _
                             gDB.ValField(rs.Fields, cscImppiParams), _
                             gDB.ValField(rs.Fields, cscImppiId)) Then Exit Sub
  
    rs.MoveNext
  Wend
End Sub

Private Function pExecuteImportAux(ByVal strImportObj As String, ByVal Params As String, ByVal imppi_id As Long) As Boolean
  On Error GoTo ControlError
  
  Dim ObjImport As cIImport
  Set ObjImport = CSKernelClient2.CreateObject(strImportObj)
  
  pExecuteImportAux = ObjImport.Import(Me, Params, imppi_id, gDB)

  GoTo ExitProc
ControlError:
  MngError Err, "pExecuteImportAux", C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function
' construccion - destruccion
#If Not PREPROC_UNATTENDED Then
  Private Sub Class_Terminate()
    On Error GoTo ControlError
  
    On Error Resume Next
    Unload m_fImport
  
    GoTo ExitProc
ControlError:
    MngError Err, "Class_Terminate", C_Module, vbNullString
    If Err.Number <> 0 Then Resume ExitProc
ExitProc:
    On Error Resume Next
  End Sub
#End If
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

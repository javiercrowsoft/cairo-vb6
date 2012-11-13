VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cBancoConciliacionPrint"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cBancoConciliacionPrint
' 20-02-2008

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cBancoConciliacionPrint"

Public Enum csRptLaunchAction
  csRptLaunchPrinter = 0
  csRptLaunchFile = 1
  csRptLaunchPreview = 2
End Enum

' estructuras
' variables privadas
Private m_ac_id                        As Long
Private m_acNroDoc                     As String

'OJO HASTA ACA

Private m_rptName           As String
Private m_rptFile           As String
Private m_Action            As csRptLaunchAction
Private m_Copies            As Long
Private m_Path              As String

Private m_ConnectionTimeout             As Long
Private m_CommandTimeout                As Long

' eventos
' Properties publicas
' propiedades friend
' propiedades privadas
' funciones publicas
Public Function DoPrint(ByVal rptName As String, _
                        ByVal rptFile As String, _
                        ByVal Action As csRptLaunchAction, _
                        ByVal Copies As Long, _
                        ByVal strId As String, _
                        ByVal Path As String, _
                        ByVal CommandTimeout As Long, _
                        ByVal ConnectionTimeout As Long) As Boolean
                        
  Dim Id As Long
  
  Id = Val(strId)
  m_ac_id = Id
  m_rptName = rptName
  m_rptFile = rptFile
  m_Action = Action
  m_Copies = Copies
  m_Path = Path
  m_ConnectionTimeout = ConnectionTimeout
  m_CommandTimeout = CommandTimeout
  
  DoPrint = pPrint(vbNullString, rptFile, Action, Copies)
End Function

' funciones friend
' Implementacion de cIEditGeneric
' funciones privadas

Private Function pPrint(ByVal rptName As String, _
                        ByVal rptFile As String, _
                        ByVal Action As csRptLaunchAction, _
                        ByVal Copies As Long)
                   
  On Error GoTo ControlError

  Dim c_OpenRpt As String
  c_OpenRpt = LNGGetText(2888, vbNullString) 'Abrir Reporte

  Dim rpt      As cReport
  'Dim RptPrint As CSReportPaint2.cReportPrint
  Dim RptPrint As cReportPrint

  Dim Mouse As cMouseWait
  Set Mouse = New cMouseWait

  Set rpt = New cReport

  If Not rpt.Init(New cReportLaunchInfo) Then Exit Function

  'Set RptPrint = New CSReportPaint2.cReportPrint
  Set RptPrint = New cReportPrint
  Set rpt.LaunchInfo.ObjPaint = RptPrint

  rptFile = GetValidPath(m_Path) & rptFile

  Dim FileEx As CSKernelFile.cFileEx
  Set FileEx = New CSKernelFile.cFileEx
  
  If Not FileEx.FileExists(rptFile) Then
    MsgWarning LNGGetText(2889, vbNullString, rptFile), c_OpenRpt
                'El archivo;;" & rptFile & ";;no existe.;;Verifique la ubicación de los reportes.
    Exit Function
  End If

  If Not rpt.LoadSilent(rptFile) Then
    MsgWarning LNGGetText(3105, vbNullString, rptFile, CSKernelClient2.LastErrorDescription), c_OpenRpt
              'No se pudo cargar el reporte  & rptFile & ;( & CSKernelClient2.LastErrorDescription & )
    Exit Function
  End If

  rpt.Connect.StrConnect = gDB.StrConnect
  
  Dim ConnectAux As cReportConnect
  For Each ConnectAux In rpt.ConnectsAux
    ConnectAux.StrConnect = gDB.StrConnect
  Next
  
  With rpt.LaunchInfo
    With .Printer.PaperInfo
      .PaperSize = rpt.PaperInfo.PaperSize
      .Orientation = rpt.PaperInfo.Orientation
      .CustomHeight = rpt.PaperInfo.CustomHeight
      .CustomWidth = rpt.PaperInfo.CustomWidth
    End With
    .Copies = Copies
    .Action = Action
    .ShowPrintersDialog = True
  End With

  rpt.DescripUser = rptName

  pSetParams rpt

  If m_CommandTimeout > 0 Then rpt.Connect.CommandTimeout = m_CommandTimeout
  If m_ConnectionTimeout > 0 Then rpt.Connect.ConnectionTimeout = m_ConnectionTimeout

  rpt.LaunchInfo.InternalPreview = True

  rpt.Launch

  pPrint = True
  GoTo ExitProc
ControlError:
  MngError Err, "pPrint", C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Sub pSetParams(ByRef rpt As cReport)
  On Error Resume Next
  With rpt.Connect.Parameters
    .Item(1).Value = g_conciliacion_cue_id
    .Item(2).Value = g_conciliacion_desde
    .Item(3).Value = g_conciliacion_hasta
    .Item(4).Value = IIf(g_fecha_cobro_cheque, 1, 0)
  End With
End Sub

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

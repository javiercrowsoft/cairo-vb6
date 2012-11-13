VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cNewWizard"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
'--------------------------------------------------------------------------------
' cNewWizard
' 02-02-2002

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
  ' constantes
  ' estructuras
  ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cNewWizard"

Private Enum csDirection
  ToNext = 1
  ToBack = 2
End Enum
' estructuras
' variables privadas
Private WithEvents m_fWizard As fNewWizard
Attribute m_fWizard.VB_VarHelpID = -1

Private m_CurrStep As csStepsWizardNew

Private m_ChoiceDb As CSReportEditor.csNewWizardChoiceDb
Private m_Choice As CSReportEditor.csNewWizardChoice
Private m_cn As ADODB.Connection

Private m_FileName As String
Private m_strConnect As String

Private m_Connect As CSConnect2.cConnect

Private m_NextNameCtrl As Long ' Nombres
' eventos
Public Event NewReport(ByVal Report As CSReportDll2.cReport)
Public Event Cancel()
' propiedades publicas
' propiedades privadas

Private Property Get Connect() As CSConnect2.cConnect
  If m_Connect Is Nothing Then Set m_Connect = New CSConnect2.cConnect
  Set Connect = m_Connect
End Property

Private Property Get cn() As ADODB.Connection
  If m_cn Is Nothing Then Set m_cn = New ADODB.Connection
  Set cn = m_cn
End Property

Private Property Get fWizard() As fNewWizard
  If m_fWizard Is Nothing Then Set m_fWizard = New fNewWizard
  Set fWizard = m_fWizard
End Property

Private Property Set fWizard(ByRef rhs As fNewWizard)
  Set m_fWizard = rhs
End Property

' funciones publicas
Public Sub Show()
  m_CurrStep = csStepsWizardNew.step_welcom
  Move (csDirection.ToNext)
  
  fWizard.Show vbModal
End Sub
' funciones friend
' funciones privadas
Private Sub Nextstep()
  m_CurrStep = m_CurrStep + 1
  If Not Move(csDirection.ToNext) Then m_CurrStep = m_CurrStep - 1
End Sub

Private Sub Prevstep()
  m_CurrStep = m_CurrStep - 1
  If Not Move(csDirection.ToBack) Then m_CurrStep = m_CurrStep + 1
End Sub

Private Function Move(ByVal Direction As csDirection) As Boolean

  Select Case m_CurrStep
    Case csStepsWizardNew.step_welcom
      fWizard.ShowControls m_CurrStep

    Case csStepsWizardNew.step_choice_db
      If Direction = csDirection.ToNext Then
        If fWizard.Choice = csNewWizardChoice.csChoiceBlankReport Then
          Unload fWizard
          Finish Nothing
        Else
          fWizard.ShowControls m_CurrStep
        End If
      Else
        fWizard.ShowControls m_CurrStep
      End If

    Case csStepsWizardNew.step_open_db
      fWizard.ShowControls m_CurrStep

    Case csStepsWizardNew.step_choice_source
      If Direction = csDirection.ToNext Then
        Select Case fWizard.ChoiceDb
          Case csNewWizardChoiceDb.csChoiceAccess
            m_strConnect = "PROVIDER=Microsoft.Jet.OLEDB.4.0;Data Source=" + fWizard.FileName

            If Not OpenConnection(m_strConnect) Then Exit Function
            CloseConnection

            m_FileName = fWizard.FileName
          Case csNewWizardChoiceDb.csChoiceSQL, csNewWizardChoiceDb.csChoiceOLEDB
            m_strConnect = fWizard.strConnect

            If Not OpenConnection(m_strConnect) Then Exit Function
            CloseConnection
        End Select
        fWizard.ShowSchema m_strConnect
      End If

      fWizard.ShowControls m_CurrStep

    Case csStepsWizardNew.step_set_parameters
      If Direction = csDirection.ToNext Then
        Connect.DataSource = fWizard.DataSource
        Connect.DataSourceType = fWizard.DataSourceType

        ' Si es una consulta
        If Connect.DataSourceType = CSConnect2.csDataSourceType.cdDTProcedure Then
          If Not LoadParameters(Connect.DataSource) Then Exit Function

          ' Si no recibe parametros sigo con la proxima
          If Connect.Parameters.Count = 0 Then
            m_CurrStep = m_CurrStep + 1
          End If
        ElseIf Connect.DataSourceType = CSConnect2.csDataSourceType.csDTTable Then
          Connect.Parameters.Clear
          If Not LoadColumnsInfo("select * from [" & Connect.DataSource & "]") Then Exit Function
          SetParametersAux Connect, fWizard.Report.Connect
          fWizard.FillLists csWizarTypeFill.FillWithFields

          m_CurrStep = m_CurrStep + 1
        Else ' Sentencia sql
          Connect.Parameters.Clear
          If Not LoadColumnsInfo(Connect.DataSource) Then Exit Function
          SetParametersAux Connect, fWizard.Report.Connect
          fWizard.FillLists csWizarTypeFill.FillWithFields

          m_CurrStep = m_CurrStep + 1
        End If

        Set fWizard.Parameters = Connect.Parameters
      Else
        If Connect.Parameters.Count = 0 Then
          m_CurrStep = m_CurrStep - 1
        End If
      End If
      fWizard.ShowControls m_CurrStep

    Case csStepsWizardNew.step_add_fields
      If Direction = csDirection.ToNext Then

        If Connect.Parameters.Count > 0 Then
          Connect.Parameters = fWizard.Parameters
          If Not LoadColumnsInfo("[" & Connect.DataSource & "] " & fWizard.sqlParameters) Then Exit Function

          SetParametersAux Connect, fWizard.Report.Connect
        End If
      End If

      fWizard.FillLists csWizarTypeFill.FillWithFields
      fWizard.ShowControls m_CurrStep

    Case csStepsWizardNew.step_add_formulas

      fWizard.FillLists csWizarTypeFill.FillWithFormulas
      fWizard.ShowControls m_CurrStep

    Case csStepsWizardNew.step_finish
      fWizard.ShowControls m_CurrStep

  End Select
  Move = True
End Function

Private Sub Finish(ByRef Report As CSReportDll2.cReport)
  On Error GoTo ControlError

  MakeReport Report

  If Not m_fWizard Is Nothing Then
    Unload m_fWizard
    Set m_fWizard = Nothing
  End If

  RaiseEvent NewReport(Report)

  GoTo ExitProc
ControlError:
  MngError Err(), "Finish", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub nCancel()
  If Not m_fWizard Is Nothing Then
    Unload m_fWizard
    Set m_fWizard = Nothing
  End If

  RaiseEvent Cancel
End Sub


Private Sub m_fWizard_GoToBack()
  Prevstep
End Sub

Private Sub m_fWizard_GoToNext()
  Nextstep
End Sub

Private Sub m_fWizard_Cancel()
  nCancel
End Sub

Private Sub m_fWizard_FinalizeWizard(ByRef Report As CSReportDll2.cReport)
  Finish Report
End Sub

Private Function OpenConnection(ByVal strConnect As String) As Boolean
  On Error GoTo ControlError

  CloseConnection

  cn.Open (strConnect)

  OpenConnection = True

  GoTo ExitProc
ControlError:
  MngError Err(), "OpenConnection", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Sub CloseConnection()
  On Error Resume Next
  If cn.State <> ADODB.ObjectStateEnum.adStateClosed Then
    cn.Close
  End If
End Sub

Private Function LoadParameters(ByVal DataSource As String) As Boolean
  On Error GoTo ControlError

  Connect.Parameters.Clear
  Connect.strConnect = m_strConnect

  If Not Connect.FillParameters(DataSource) Then GoTo ExitProc

  LoadParameters = True

  GoTo ExitProc
ControlError:
  MngError Err(), "LoadParameters", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function LoadColumnsInfo(ByVal DataSource As String)
  On Error GoTo ControlError

  Dim Mouse As New CSKernelClient2.cMouseWait

  Connect.strConnect = m_strConnect
  If Not Connect.FillColumns(DataSource) Then GoTo ExitProc

  LoadColumnsInfo = True

  GoTo ExitProc
ControlError:
  MngError Err(), "LoadColumnsInfo", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

' Recibe el reporte con las secciones
' y los controles que se agregaron en
' el asistente. Reparte las secciones
' y los controles sobre la superficie
' del reporte.
Private Sub MakeReport(ByRef Report As CSReportDll2.cReport)
  Const SizeHeaderMain = 2000
  Const SizeFooterMain = 600
  Const SizeHeader = 450
  Const SizeFooter = 450
  Const SizeSection = 450
  Const SizeHeightTitle = 525
  Const SizeWidthTitle = 6750
  Const SizeFontTitle = 14
  Const FontNameTitle = "Tahoma"

  Dim HeightReport As Long
  Dim HeightHeaders As Long
  Dim HeightFooters As Long
  Dim WidthReport As Long
  Dim i As Long
  Dim Sec As CSReportDll2.cReportSection

  If Report Is Nothing Then Exit Sub

  m_NextNameCtrl = fWizard.NextNameCtrl

  HeightReport = Report.LaunchInfo.Printer.PaperInfo.Height
  WidthReport = Report.LaunchInfo.Printer.PaperInfo.Width

  ' Defino el alto del primer Header
  Set Sec = Report.Headers.Item(1)
  Sec.Aspect.Height = SizeHeaderMain
  Sec.Aspect.Width = WidthReport
  SetPositionControl Sec
  HeightHeaders = SizeHeaderMain

  ' Agrego el Titulo principal del reporte
  Dim Ctrl As CSReportDll2.cReportControl
  Set Ctrl = AddControl(Sec)

  With Ctrl.Label.Aspect
    .Width = SizeWidthTitle
    .Height = SizeHeightTitle
    .Font.Size = SizeFontTitle
    .Font.Bold = True
    .Font.Name = FontNameTitle
    .Top = SizeHeaderMain - SizeHeightTitle - 100
  End With
  Ctrl.Label.Text = "Ingrese aqui el titulo principal del reporte"

  ' Agrego un header para los titulos
  Report.Headers.Add().Name = "Encabezado Titulos"

  ' Por cada seccion Header
  For i = 2 To Report.Headers.Count
    Set Sec = Report.Headers.Item(i)
    Sec.Aspect.Top = HeightHeaders
    Sec.Aspect.Height = SizeHeader
    Sec.Aspect.Width = WidthReport
    SetPositionControl Sec
    HeightHeaders = HeightHeaders + SizeHeader
  Next

  ' Defino el alto del primer Footer
  Set Sec = Report.Footers.Item(1)
  Sec.Aspect.Height = SizeFooterMain
  Sec.Aspect.Width = WidthReport
  HeightFooters = SizeFooterMain
  Sec.Aspect.Top = HeightReport - HeightFooters
  SetPositionControl Sec

  ' Por cada seccion Footer
  For i = 2 To Report.Footers.Count
    Sec = Report.Footers.Item(i)
    Sec.Aspect.Height = SizeFooter
    Sec.Aspect.Width = WidthReport
    HeightFooters = HeightFooters + SizeFooter
    Sec.Aspect.Top = HeightReport - HeightFooters
    SetPositionControl Sec
  Next

  For Each Sec In Report.GroupsHeaders
    Sec.Aspect.Top = HeightHeaders
    Sec.Aspect.Height = SizeSection
    Sec.Aspect.Width = WidthReport
    SetPositionControl Sec
    HeightHeaders = HeightHeaders + SizeSection
  Next

  Set Sec = Report.Details.Item(1)
  Sec.Aspect.Height = C_Height_New_Section
  Sec.Aspect.Width = WidthReport
  Sec.Aspect.Top = HeightHeaders
  SetPositionControl Sec
  HeightHeaders = HeightHeaders + C_Height_New_Section

  ' Por cada control en el detail agrego un control
  ' en el header de titulos
  CreateSectionColumnTitle Report.Headers.Item(Report.Headers.Count), Sec

  For Each Sec In Report.GroupsFooters
    Sec.Aspect.Height = SizeSection
    Sec.Aspect.Width = WidthReport
    HeightFooters = HeightFooters + SizeSection
    Sec.Aspect.Top = HeightHeaders
    SetPositionControl Sec
  Next
End Sub

Private Function AddControl(ByRef Sec As CSReportDll2.cReportSection) As CSReportDll2.cReportControl
  Dim Ctrl As CSReportDll2.cReportControl
  Set Ctrl = Sec.SectionLines.Item(1).Controls.Add
  Ctrl.ControlType = CSReportDll2.csRptControlType.csRptCtLabel
  m_NextNameCtrl = m_NextNameCtrl + 1
  Ctrl.Name = C_Control_Name & m_NextNameCtrl
  Ctrl.Label.Aspect.Align = vbLeftJustify
  Set AddControl = Ctrl
End Function

Private Sub CreateSectionColumnTitle(ByRef SecTitle As CSReportDll2.cReportSection, ByRef SecDetail As CSReportDll2.cReportSection)
  Dim Ctrl As CSReportDll2.cReportControl
  Dim CtrlTitle As CSReportDll2.cReportControl
  Dim AspectTitle As CSReportDll2.cReportAspect
  Dim SecL As CSReportDll2.cReportSectionLine

  For Each SecL In SecDetail.SectionLines
    For Each Ctrl In SecL.Controls
      Set CtrlTitle = AddControl(SecTitle)

      Set AspectTitle = CtrlTitle.Label.Aspect
      With Ctrl.Label.Aspect
        AspectTitle.Width = .Width
        AspectTitle.Left = .Left
        AspectTitle.Height = .Height
        AspectTitle.Font.Name = .Font.Name
        AspectTitle.Font.Size = .Font.Size
        AspectTitle.Font.Bold = True
        AspectTitle.Top = SecTitle.Aspect.Top + C_Height_Bar_Section
      End With
      CtrlTitle.Label.Text = Ctrl.Label.Text
    Next
  Next
End Sub

Private Sub SetPositionControl(ByRef Sec As CSReportDll2.cReportSection)
  Const SizeFontControl = 8
  Const FontNameControl = "Tahoma"
  Const SizeHeightControl = 285

  Dim Ctrl As CSReportDll2.cReportControl
  Dim SecL As CSReportDll2.cReportSectionLine
  Dim WidthControl As Long
  Dim LeftControl As Long
  Dim CountControls As Long
  Dim HeightLines   As Long
  
  If Sec.SectionLines.Item(1).Controls.Count = 0 Then Exit Sub

  CountControls = Sec.SectionLines.Item(1).Controls.Count
  If CountControls < 4 Then CountControls = 4

  WidthControl = ((Sec.Aspect.Width - 100) / CountControls) - 50
  LeftControl = 50

  For Each SecL In Sec.SectionLines
    
    SecL.Aspect.Top = Sec.Aspect.Top + HeightLines
    HeightLines = HeightLines + SecL.Aspect.Height
    
    For Each Ctrl In SecL.Controls
      With Ctrl.Label.Aspect
        .Top = Sec.Aspect.Top + C_Height_Bar_Section
        .Width = WidthControl
        .Left = LeftControl
        .Height = SizeHeightControl
        .Font.Name = FontNameControl
        .Font.Size = SizeFontControl
        LeftControl = LeftControl + WidthControl + 75
      End With
    Next
  Next
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

' construccion - destruccion
Private Sub Class_Initialize()
  m_CurrStep = 0
End Sub

Private Sub Class_Terminate()
  Set m_fWizard = Nothing
End Sub


Attribute VB_Name = "mPublic"
Option Explicit

'--------------------------------------------------------------------------------
' mPublic
' 15-09-2001

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
  ' constantes
  Private Const C_Module As String = "mPublic"
  
  Private Const HWND_TOPMOST = -1
  Private Const HWND_NOTOPMOST = -2
  Private Const SWP_NOACTIVATE = &H10
  Private Const SWP_SHOWWINDOW = &H40
  
  Public Enum SpecialFolderIDs
      sfidDESKTOP = &H0
      sfidPROGRAMS = &H2
      sfidPERSONAL = &H5
      sfidFAVORITES = &H6
      sfidSTARTUP = &H7
      sfidRECENT = &H8
      sfidSENDTO = &H9
      sfidSTARTMENU = &HB
      sfidDESKTOPDIRECTORY = &H10
      sfidNETHOOD = &H13
      sfidFONTS = &H14
      sfidTEMPLATES = &H15
      sfidCOMMON_STARTMENU = &H16
      sfidCOMMON_PROGRAMS = &H17
      sfidCOMMON_STARTUP = &H18
      sfidCOMMON_DESKTOPDIRECTORY = &H19
      sfidAPPDATA = &H1A
      sfidPRINTHOOD = &H1B
      sfidPROGRAMS_FILES = &H26
      sfidProgramFiles = &H10000
      sfidCommonFiles = &H10001
  End Enum
  
  Private Const NOERROR = 0
  
  ' estructuras
  ' funciones
  Private Declare Function SetWindowPos Lib "user32" (ByVal hwnd As Long, ByVal hWndInsertAfter As Long, ByVal x As Long, ByVal y As Long, ByVal cx As Long, ByVal cy As Long, ByVal wFlags As Long) As Long
  Private Declare Function SHGetSpecialFolderLocation Lib "shell32" (ByVal hwndOwner As Long, ByVal nFolder As SpecialFolderIDs, ByRef pIdl As Long) As Long
  Private Declare Function SHGetPathFromIDListA Lib "shell32" (ByVal pIdl As Long, ByVal pszPath As String) As Long
  
'--------------------------------------------------------------------------------

' constantes
Public Const csNoFecha = #1/1/1900#
Public Const C_KEY_HEADER As String = "RH"
Public Const C_KEY_FOOTER As String = "RF"
Public Const C_KEY_DETAIL As String = "RD"
Public Const C_KEY_GROUPH As String = "GH"
Public Const C_KEY_GROUPF As String = "GF"

Public Const c_BTN_PRINT        As String = "PRINT"
Public Const c_BTN_PROPERTIES   As String = "PROPERTIES"
Public Const c_BTN_DB           As String = "DB"
Public Const c_BTN_SAVE         As String = "SAVE"
Public Const c_BTN_OPEN         As String = "OPEN"
Public Const c_BTN_TOOL         As String = "TOOL"
Public Const c_BTN_NEW          As String = "NEW"
Public Const c_BTN_PREV         As String = "PREV"

Public Const c_BTN_ALIGN_LEFT   As String = "ALIGN_LEFT"
Public Const c_BTN_ALIGN_CENTER As String = "ALIGN_CENTER"
Public Const c_BTN_ALIGN_RIGHT  As String = "ALIGN_RIGHT"

Public Const c_BTN_CTL_ALIGN_TOP        As String = "CTL_ALIGN_TOP"
Public Const c_BTN_CTL_ALIGN_BOTTOM     As String = "CTL_ALIGN_BOTTOM"
Public Const c_BTN_CTL_ALIGN_VERTICAL   As String = "CTL_ALIGN_VERTICAL"
Public Const c_BTN_CTL_ALIGN_HORIZONTAL As String = "CTL_ALIGN_HORIZONTAL"
Public Const c_BTN_CTL_ALIGN_LEFT       As String = "CTL_ALIGN_LEFT"
Public Const c_BTN_CTL_ALIGN_RIGHT      As String = "CTL_ALIGN_RIGHT"

Public Const c_BTN_CTL_WIDTH        As String = "CTL_WIDTH"
Public Const c_BTN_CTL_HEIGHT       As String = "CTL_HEIGHT"

Public Enum csEAlignConst
  csEAlignTextLeft = 1
  csEAlignTextRight
  csEAlignTextCenter

  csEAlignCtlLeft
  csEAlignCtlHorizontal
  csEAlignCtlRight
  csEAlignCtlVertical
  csEAlignCtlTop
  csEAlignCtlBottom
  
  csEAlignCtlWidth
  csEAlignCtlHeight
End Enum

Public Enum csECtlAlignConst
  csECtlAlignLeft = csEAlignCtlLeft
  csECtlAlignHorizontal = csEAlignCtlHorizontal
  csECtlAlignRight = csEAlignCtlRight
  csECtlAlignVertical = csEAlignCtlVertical
  csECtlAlignTop = csEAlignCtlTop
  csECtlAlignBottom = csEAlignCtlBottom
  csECtlAlignWidth = csEAlignCtlWidth
  csECtlAlignHeight = csEAlignCtlHeight
End Enum


Public Const c_BTN_FONT_BOLD    As String = "FONT_BOLD"
Public Const c_BTN_SEARCH       As String = "SEARCH"

Public Enum csESectionLineTypes
  C_KEY_SECLN_HEADER = 1000
  C_KEY_SECLN_DETAIL = 1001
  C_KEY_SECLN_FOOTER = 1002
  C_KEY_SECLN_GROUPH = 1003
  C_KEY_SECLN_GROUPF = 1004
End Enum

Public Const C_Control_Name As String = "Control"

Public Const C_Height_Bar_Section = 120

Public Const C_Height_New_Section = 350

Public Enum CSRptEditroMoveType
  csRptEdMovTHorizontal
  csRptEdMovTVertical
  csRptEdMovTAll
  csRptEdMovLeft
  csRptEdMovRight
  csRptEdMovUp
  csRptEdMovDown
  csRptEdMovLeftDown
  csRptEdMovLeftUp
  csRptEdMovRightDown
  csRptEdMovRightUp
  csRptEdMovTNone
End Enum

Public Enum csRptEditCtrlType
  csRptEditNone
  csRptEditLabel
  csRptEditField
  csRptEditFormula
  csRptEditImage
  csRptEditChart
End Enum

Private Const c_TotInRecentList = 7
Private Const c_KeyRecentList As String = "Recent"

Private Const c_config = "Interfaz"
Private Const c_LeftBarcolor = "LeftBarColor"
Private Const c_HideLeftBar = "HideLeftBar"
Private Const c_BackColor = "BackColor"
Private Const c_WorkFolder = "WorkFolder"

' estructuras
Public Type Rectangle
  Height As Long
  Width  As Long
End Type
' variables privadas
' variables publicas
Public gNextReport As Long
Private m_fReporte As fReporte
Private m_fToolBoxOwner As fReporte
Private m_fCtrlBoxOwner As fReporte
Private m_fCtrlTreeBoxOwner As fReporte
' eventos
' propiedades publicas
Public gBackColor     As Long
Public gLeftBarColor  As Long
Public gHideLeftBar   As Boolean
Public gWorkFolder    As String
Public gbFirstOpen    As Boolean

' propiedades privadas
' funciones publicas
' funciones privadas
' construccion - destruccion

Public Function GetDocActive() As fReporte
  Set GetDocActive = m_fReporte
End Function

Public Sub SetDocActive(ByRef f As fReporte)
  Set m_fReporte = f
  SetMenu
End Sub

Public Sub SetDocInacActive(ByRef f As fReporte)
  If Not m_fReporte Is f Then Exit Sub
  Set m_fReporte = Nothing
  SetMenu
  SetEditAlignTextState False
End Sub

Public Sub SetStatus()
  On Error GoTo ControlError
  
  If m_fReporte Is Nothing Then
    fMain.lbStatus.Caption = ""
  Else
    fMain.lbStatus.Caption = pGetStatus
  End If
  
  GoTo ExitProc
ControlError:

  MngError Err(), "SetStatus", C_Module, ""
ExitProc:
End Sub

Public Sub SetEditFontBoldValue(ByVal bBold As Integer)
  With fMain.tbMain
    .Buttons.Item(c_BTN_FONT_BOLD).Value = IIf(bBold = -1, tbrPressed, tbrUnpressed)
    .Refresh
  End With
  DoEvents
End Sub

Public Sub SetEditAlignValue(ByVal Align As AlignmentConstants)
  With fMain.tbMain.Buttons
    
    .Item(c_BTN_ALIGN_CENTER).Value = tbrUnpressed
    .Item(c_BTN_ALIGN_LEFT).Value = tbrUnpressed
    .Item(c_BTN_ALIGN_RIGHT).Value = tbrUnpressed
  
    Select Case Align
      Case AlignmentConstants.vbCenter
        .Item(c_BTN_ALIGN_CENTER).Value = tbrPressed
      Case AlignmentConstants.vbLeftJustify
        .Item(c_BTN_ALIGN_LEFT).Value = tbrPressed
      Case AlignmentConstants.vbRightJustify
        .Item(c_BTN_ALIGN_RIGHT).Value = tbrPressed
    End Select
  End With
  
  fMain.tbMain.Refresh
  DoEvents
End Sub

Public Sub SetEditAlignTextState(ByVal status As Boolean)
  With fMain.tbMain.Buttons
    
    .Item(c_BTN_ALIGN_CENTER).Enabled = status
    .Item(c_BTN_ALIGN_LEFT).Enabled = status
    .Item(c_BTN_ALIGN_RIGHT).Enabled = status
    
    .Item(c_BTN_FONT_BOLD).Enabled = status
  End With
End Sub

Public Sub SetEditAlignCtlState(ByVal status As Boolean)
  With fMain.tbMain.Buttons
    .Item(c_BTN_CTL_ALIGN_BOTTOM).Enabled = status
    .Item(c_BTN_CTL_ALIGN_TOP).Enabled = status
    
    .Item(c_BTN_CTL_ALIGN_VERTICAL).Enabled = status
    .Item(c_BTN_CTL_ALIGN_HORIZONTAL).Enabled = status
    .Item(c_BTN_CTL_ALIGN_LEFT).Enabled = status
    .Item(c_BTN_CTL_ALIGN_RIGHT).Enabled = status
    
    .Item(c_BTN_CTL_HEIGHT).Enabled = status
    .Item(c_BTN_CTL_WIDTH).Enabled = status
  End With
End Sub

Private Sub SetMenu()
  On Error GoTo ControlError
  
  If m_fReporte Is Nothing Then
    SetMenuAux False
    fMain.lbBar.Caption = ""
    fMain.lbStatus.Caption = ""
  Else
    SetMenuAux True
    fMain.mnuDataBaseSetDisconnected.Checked = m_fReporte.Report.ReportDisconnected
    fMain.lbBar.Caption = m_fReporte.Report.Name
    fMain.lbStatus.Caption = pGetStatus
  End If

  GoTo ExitProc
ControlError:

  MngError Err(), "SetMenu", C_Module, ""
ExitProc:
End Sub

Private Function pGetStatus() As String
  Dim rtn As String
  
  If m_fReporte.bMoveNoMove Then
    rtn = "Mover bloqueado"
  
  ElseIf m_fReporte.bMoveHorizontal Then
    rtn = "Mover solo en horizontal"
  
  ElseIf m_fReporte.bMoveVertical Then
    rtn = "Mover solo en vertical"
  End If
  
  pGetStatus = rtn
End Function

Public Sub SetMenuAux(ByVal Enabled As Boolean)
  With fMain
    .mnuEditAddControl.Enabled = Enabled
    .mnuEditAddHeader.Enabled = Enabled
    .mnuEditAddLabel.Enabled = Enabled
    .mnuEditAddGroup.Enabled = Enabled
    .mnuEditAddFooter.Enabled = Enabled
    .mnuEditAddLine.Enabled = Enabled
    .mnuEditAddSec.Enabled = Enabled
    .mnuEditMove.Enabled = Enabled
    .mnuDataBaseConnectConfig.Enabled = Enabled
    .mnuReportPreview.Enabled = Enabled
    .mnuReportPrint.Enabled = Enabled
    .mnuFileSave.Enabled = Enabled
    .mnuFileSaveAs.Enabled = Enabled
    .mnuDataBaseSetDisconnected.Enabled = Enabled
    .mnuEditKeyboardStepMove.Enabled = Enabled
    .mnuEditSearch.Enabled = Enabled
    .mnuDataBaseEditStrConnect.Enabled = Enabled
    .mnuDataBaseSetToMainConnect.Enabled = Enabled
    .mnuDataBaseEditEx.Enabled = Enabled
    .mnuDataBaseSetParameters.Enabled = Enabled
    .mnuDataBaseConnectsAuxCfg.Enabled = Enabled
    .mnuViewGridMain.Enabled = Enabled
    .mnuViewToolbar.Enabled = Enabled
    .mnuViewControls.Enabled = Enabled
    .mnuViewTreeViewCtrls.Enabled = Enabled
    .mnuViewSumary.Enabled = Enabled
    
    .tbMain.Buttons(c_BTN_PRINT).Enabled = Enabled
    .tbMain.Buttons(c_BTN_PROPERTIES).Enabled = Enabled
    .tbMain.Buttons(c_BTN_DB).Enabled = Enabled
    .tbMain.Buttons(c_BTN_SAVE).Enabled = Enabled
    .tbMain.Buttons(c_BTN_TOOL).Enabled = Enabled
    .tbMain.Buttons(c_BTN_PREV).Enabled = Enabled
    .tbMain.Buttons(c_BTN_SEARCH).Enabled = Enabled
  End With
End Sub

Public Sub AlwaysOnTop(ByRef myfrm As Form, ByRef SetOnTop As Boolean)
  Dim lFlag As Long

  If SetOnTop Then
    lFlag = HWND_TOPMOST
  Else
    lFlag = HWND_NOTOPMOST
  End If

  SetWindowPos myfrm.hwnd, lFlag, myfrm.Left / Screen.TwipsPerPixelX, myfrm.Top / Screen.TwipsPerPixelY, _
                                  myfrm.Width / Screen.TwipsPerPixelX, myfrm.Height / Screen.TwipsPerPixelY, _
                                  SWP_NOACTIVATE Or SWP_SHOWWINDOW
End Sub

Public Sub AddToRecentList(ByVal FileName As String)
  Dim i As Long
  Dim n As Long
  Dim j As Long
  Dim Found As Boolean

  Found = False
  n = fMain.mnuFileRecentList.Count - 1

  For i = 1 To n
    If FileName = fMain.mnuFileRecentList(i).Caption Then
      j = i
      Found = True
      Exit For
    End If
  Next i

  If n < c_TotInRecentList And Found = False Then
    n = n + 1
    Load fMain.mnuFileRecentList(n)
    fMain.mnuFileRecentList(n).Visible = True
  End If

  If Not Found Then j = n

  For i = j To 2 Step -1
    fMain.mnuFileRecentList(i).Caption = fMain.mnuFileRecentList(i - 1).Caption
  Next

  fMain.mnuFileSepRecentList.Visible = True
  fMain.mnuFileRecentList(1).Caption = FileName
End Sub

Public Sub LoadRecentList()
  Dim i As Long
  Dim Recent As String

  For i = 1 To c_TotInRecentList
    Recent = GetSetting(App.EXEName(), c_KeyRecentList, CStr(i), "")
    If Recent = "" Then Exit For
    Load fMain.mnuFileRecentList(i)
    fMain.mnuFileRecentList(i).Visible = True
    fMain.mnuFileRecentList(i).Caption = Recent
  Next

  If fMain.mnuFileRecentList.Count > 1 Then
    fMain.mnuFileSepRecentList.Visible = True
  End If
End Sub

Public Sub SaveRecentList()
  Dim i As Long

  For i = 1 To fMain.mnuFileRecentList.Count - 1
    SaveSetting App.EXEName(), c_KeyRecentList, CStr(i), fMain.mnuFileRecentList(i).Caption
  Next i
End Sub

Public Function GetRectFromPrinter(ByRef oPrinter As Object) As Rectangle
  Dim rtn As Rectangle
  
  rtn.Height = oPrinter.Height
  rtn.Width = oPrinter.Width
  
  GetRectFromPrinter = rtn
End Function

Public Sub CreateStandarSections(ByRef Report As CSReportDll2.cReport, ByRef RECT As Rectangle)
  With Report
    .Headers.Add Nothing, C_KEY_HEADER
    .Footers.Add Nothing, C_KEY_FOOTER
    .Details.Add Nothing, C_KEY_DETAIL

    With .Headers.Item(C_KEY_HEADER)
      .Name = "Encabezado principal"
      With .Aspect
        .Top = 0
        .Height = RECT.Height * 0.25
        .Width = RECT.Width
      End With
      With .SectionLines.Item(1)
        .SectionName = "Encabezado principal"
        With .Aspect
          .Top = 0
          .Height = RECT.Height * 0.25
          .Width = RECT.Width
        End With
      End With
    End With

    With .Details.Item(C_KEY_DETAIL)
      .Name = "Detalle"
      With .Aspect
        .Top = RECT.Height * 0.25
        .Height = C_Height_New_Section 'Rect.Height * 0.5
        .Width = RECT.Width
      End With
      With .SectionLines.Item(1)
        .SectionName = "Detalle"
        With .Aspect
          .Top = RECT.Height * 0.25
          .Height = C_Height_New_Section 'Rect.Height * 0.5
          .Width = RECT.Width
        End With
      End With
    End With

    With .Footers.Item(C_KEY_FOOTER)
      .Name = "Píe de página principal"
      With .Aspect
        .Top = RECT.Height * 0.75
        .Height = RECT.Height - .Top
        .Width = RECT.Width
      End With
      With .SectionLines.Item(1)
        .SectionName = "Píe de página principal"
        With .Aspect
          .Top = RECT.Height * 0.75
          .Height = RECT.Height - .Top
          .Width = RECT.Width
        End With
      End With
    End With
  End With
End Sub

Public Function ShowGroupProperties(ByRef Group As CSReportDll2.cReportGroup, ByRef f As Object) As Boolean
  On Error GoTo ControlError

  Dim IsNew As Boolean

  f.ShowingProperties = True

  If f.fGroup Is Nothing Then Set f.fGroup = New fGroup

  If Group Is Nothing Then IsNew = True

  Dim TxControl As CSMaskEdit2.cMaskEdit

  If IsNew Then
    Set TxControl = f.fGroup.TxName
    TxControl.Text = "Grupo" & f.Report.Groups.Count + 1
  Else

    With Group
      Set TxControl = f.fGroup.TxName
      TxControl.Text = .Name
      Set TxControl = f.fGroup.TxDbField
      TxControl.Text = .FieldName

      If .OderType = CSReportDll2.csRptGrpOrderType.csRptGrpAsc Then
        f.fGroup.opAsc.Value = True
      Else
        f.fGroup.opDesc.Value = True
      End If

      f.fGroup.chkPrintInNewPage.Value = IIf(.PrintInNewPage, vbChecked, vbUnchecked)
      f.fGroup.chkReprintGroup.Value = IIf(.RePrintInNewPage, vbChecked, vbUnchecked)
      f.fGroup.chkGrandTotal.Value = IIf(.GrandTotalGroup, vbChecked, vbUnchecked)

      Select Case .ComparisonType
        Case CSReportDll2.csRptGrpComparisonType.csRptGrpDate
          f.fGroup.opDate.Value = True
        Case CSReportDll2.csRptGrpComparisonType.csRptGrpNumber
          f.fGroup.opNumber.Value = True
        Case CSReportDll2.csRptGrpComparisonType.csRptGrpText
          f.fGroup.opText.Value = True
      End Select
    End With
  End If

  f.fGroup.Show vbModal

  If f.fGroup Is Nothing Then GoTo ExitProc
  If Not f.fGroup.Ok Then GoTo ExitProc

  If IsNew Then
    Set Group = f.Report.Groups.Add()
  End If

  With Group

    Set TxControl = f.fGroup.TxName
    .Name = TxControl.Text
    Set TxControl = f.fGroup.TxDbField
    .FieldName = TxControl.Text

    .Indice = f.Report.Groups.Count
    .OderType = IIf(f.fGroup.opAsc.Value, CSReportDll2.csRptGrpOrderType.csRptGrpAsc, CSReportDll2.csRptGrpOrderType.csRptGrpDesc)

    .PrintInNewPage = f.fGroup.chkPrintInNewPage.Value = vbChecked
    .RePrintInNewPage = f.fGroup.chkReprintGroup.Value = vbChecked
    .GrandTotalGroup = f.fGroup.chkGrandTotal.Value = vbChecked

    If f.fGroup.opDate.Value Then
      .ComparisonType = CSReportDll2.csRptGrpComparisonType.csRptGrpDate
    ElseIf f.fGroup.opNumber.Value Then
      .ComparisonType = CSReportDll2.csRptGrpComparisonType.csRptGrpNumber
    ElseIf f.fGroup.opText.Value Then
      .ComparisonType = CSReportDll2.csRptGrpComparisonType.csRptGrpText
    End If
  End With

  f.ShowingProperties = False

  If IsNew Then
    f.AddSection CSReportDll2.csRptTypeSection.csRptTpGroupHeader
    f.AddSection CSReportDll2.csRptTypeSection.csRptTpGroupFooter
  End If

  f.DataHasChanged = True

  ShowGroupProperties = True

  GoTo ExitProc
ControlError:

  MngError Err(), "ShowGroupProperties", C_Module, ""
ExitProc:
  On Error Resume Next
  If Not f.fGroup Is Nothing Then
    Unload f.fGroup
  End If
  Set f.fGroup = Nothing
  f.ShowingProperties = False
End Function

Public Function MoveGroup(ByRef Group As CSReportDll2.cReportGroup, _
                          ByRef f As Object) As Boolean
                          
  On Error GoTo ControlError

  Dim sIndex  As String
  Dim nGroups As Long
  
  nGroups = f.Report.Groups.Count
  
  If Not GetInput(sIndex, "Indique el nuevo indice del grupo;;Valores posibles: 1 a " & nGroups) Then Exit Function

  If Val(sIndex) < 1 Or Val(sIndex) > nGroups Then
  
    MsgError "El indice no es valido"
    Exit Function
  End If
  
  If Not f.Report.MoveGroup(Group.Indice, Val(sIndex)) Then Exit Function
  
  f.DataHasChanged = True

  MoveGroup = True

  GoTo ExitProc
ControlError:

  MngError Err(), "MoveGroup", C_Module, ""
ExitProc:
  On Error Resume Next
End Function

Public Function GetDataSourceStr(ByVal DataSource As String) As String
  GetDataSourceStr = "{" & DataSource & "}."
End Function

Public Function ShowDbFields(ByRef sField As String, ByRef nFieldType As Long, ByRef nIndex As Long, ByVal f As Object) As Boolean
  On Error GoTo ControlError
  Dim fc As fColumns
  
  Set fc = New fColumns
  
  fc.ClearColumns

  Dim Connect As CSReportDll2.cReportConnect
  fc.FillColumns f.Report.Connect.DataSource, f.Report.Connect.Columns
  For Each Connect In f.Report.ConnectsAux
    fc.FillColumns Connect.DataSource, Connect.Columns
  Next
  
  fc.Field = sField
  fc.Show vbModal

  If Not fc.Ok Then GoTo ExitProc

  sField = fc.Field
  nFieldType = fc.FieldType
  nIndex = fc.Index

  ShowDbFields = True

  GoTo ExitProc
ControlError:

  MngError Err(), "ShowDbFields", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
  Unload fc
End Function

Public Sub SetParametersAux(ByRef Connect As CSConnect2.cConnect, ByRef RptConnect As CSReportDll2.cReportConnect)
  RptConnect.Columns.Clear

  Dim ColInfo As CSConnect2.cColumnInfo
  
  For Each ColInfo In Connect.ColumnsInfo
    With RptConnect.Columns.Add()
      .Name = ColInfo.Name
      .Position = ColInfo.Position
      .TypeColumn = ColInfo.TypeColumn
      .Value = ColInfo.Value
    End With
  Next ColInfo

  RptConnect.Parameters.Clear

  With RptConnect
    .DataSource = Connect.DataSource
    .strConnect = Connect.strConnect
    .DataSourceType = Connect.DataSourceType
  End With

  Dim param As CSConnect2.cParameter
  For Each param In Connect.Parameters
    With RptConnect.Parameters.Add()
      .Name = param.Name
      .Position = param.Position
      .TypeColumn = param.TypeColumn
      .Value = param.Value
      .DefaultValue = param.DefaultValue
      .HasDefault = param.HasDefault
      .IsNullable = param.IsNullable
      .MaxLength = param.MaxLength
    End With
  Next param
End Sub

Public Function IsNumberField(ByVal nType As Long) As Boolean
  Select Case nType
    Case ADODB.DataTypeEnum.adDecimal, ADODB.DataTypeEnum.adDouble, ADODB.DataTypeEnum.adInteger, _
         ADODB.DataTypeEnum.adCurrency, ADODB.DataTypeEnum.adBigInt, ADODB.DataTypeEnum.adNumeric, _
         ADODB.DataTypeEnum.adSingle, ADODB.DataTypeEnum.adSmallInt, ADODB.DataTypeEnum.adTinyInt, _
         ADODB.DataTypeEnum.adUnsignedBigInt, ADODB.DataTypeEnum.adUnsignedInt, ADODB.DataTypeEnum.adUnsignedSmallInt, _
         ADODB.DataTypeEnum.adUnsignedTinyInt, ADODB.DataTypeEnum.adVarNumeric
      IsNumberField = True
  End Select
End Function

Public Function GetCtrlBox(ByRef f As fReporte) As fControls
  If fControls Is Nothing Then Set fControls = New fControls
  If Not fControls.Loaded Then Load fControls
  Set m_fCtrlBoxOwner = f
  Set GetCtrlBox = fControls
End Function

Public Sub ClearCtrlBox(ByRef f As fReporte)
  If m_fCtrlBoxOwner Is f Then
    If fControls.Loaded Then fControls.Clear
  End If
End Sub

Public Sub ClearCtrlTreeBox(ByRef f As fReporte)
  If m_fCtrlBoxOwner Is f Then
    If fTreeViewCtrls.Loaded Then fTreeViewCtrls.Clear
  End If
End Sub

Public Function GetCtrlTreeBox(ByRef f As fReporte) As fTreeViewCtrls
  If fTreeViewCtrls Is Nothing Then Set fTreeViewCtrls = New fTreeViewCtrls
  If Not fTreeViewCtrls.Loaded Then Load fTreeViewCtrls
  Set m_fCtrlTreeBoxOwner = f
  Set GetCtrlTreeBox = fTreeViewCtrls
End Function

Public Function GetToolBox(ByRef f As fReporte) As fToolbox
  If fToolbox Is Nothing Then Set fToolbox = New fToolbox
  If Not fToolbox.Loaded Then Load fToolbox
  Set m_fToolBoxOwner = f
  Set GetToolBox = fToolbox
End Function

Public Sub ClearToolBox(ByRef f As fReporte)
  If m_fToolBoxOwner Is f Then
    If fToolbox.Loaded Then fToolbox.Clear
  End If
End Sub

Public Sub SaveToolOptions()
  SaveSetting App.EXEName, c_config, c_BackColor, fToolsOptions.shBackColor.BackColor
  SaveSetting App.EXEName, c_config, c_LeftBarcolor, fToolsOptions.shLeftBarColor.BackColor
  SaveSetting App.EXEName, c_config, c_HideLeftBar, fToolsOptions.chkHideLeftBar.Value = vbChecked
  SaveSetting App.EXEName, c_config, c_WorkFolder, fToolsOptions.txWorkFolder.Text
End Sub

Public Sub LoadToolOptions()
  gBackColor = GetSetting(App.EXEName, c_config, c_BackColor, vbWindowFrame)
  gLeftBarColor = GetSetting(App.EXEName, c_config, c_LeftBarcolor, vbButtonFace)
  gHideLeftBar = GetSetting(App.EXEName, c_config, c_HideLeftBar, 0)
  gWorkFolder = GetSetting(App.EXEName, c_config, c_WorkFolder, GetEspecialFolders(sfidPERSONAL))
End Sub

Public Function GetEspecialFolders(ByVal nFolder As SpecialFolderIDs) As String
  Dim sPath   As String
  Dim strPath As String
  Dim lngPos  As Long
  Dim IDL     As Long
  
  ' Fill the item id list with the pointer of each folder item, rtns 0 on success
  If SHGetSpecialFolderLocation(0, nFolder, IDL) = NOERROR Then
      sPath = String$(255, 0)
      SHGetPathFromIDListA IDL, sPath

      lngPos = InStr(sPath, Chr(0))
      If lngPos > 0 Then
          strPath = Left$(sPath, lngPos - 1)
      End If
  End If
  
  GetEspecialFolders = strPath
End Function


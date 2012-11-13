VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Begin VB.Form fReporte 
   BackColor       =   &H00000000&
   ClientHeight    =   6615
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   7320
   Icon            =   "fReporte.frx":0000
   KeyPreview      =   -1  'True
   LinkTopic       =   "Form1"
   MDIChild        =   -1  'True
   ScaleHeight     =   6615
   ScaleWidth      =   7320
   WindowState     =   2  'Maximized
   Begin VB.PictureBox picTop 
      BackColor       =   &H00000000&
      BorderStyle     =   0  'None
      Height          =   915
      Left            =   3600
      ScaleHeight     =   915
      ScaleWidth      =   960
      TabIndex        =   6
      Top             =   120
      Width           =   960
   End
   Begin VB.PictureBox PicBody 
      BackColor       =   &H00FFFFFF&
      BorderStyle     =   0  'None
      ClipControls    =   0   'False
      Height          =   6675
      Left            =   2400
      ScaleHeight     =   6675
      ScaleWidth      =   1095
      TabIndex        =   4
      Top             =   -60
      Width           =   1095
      Begin VB.TextBox TxEdit 
         BorderStyle     =   0  'None
         Height          =   285
         Left            =   0
         MultiLine       =   -1  'True
         TabIndex        =   5
         Top             =   0
         Visible         =   0   'False
         Width           =   1005
      End
   End
   Begin MSComDlg.CommonDialog cmDialog 
      Left            =   3645
      Top             =   1125
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.PictureBox PicRightCorner 
      BorderStyle     =   0  'None
      Height          =   285
      Left            =   4410
      ScaleHeight     =   285
      ScaleWidth      =   240
      TabIndex        =   3
      Top             =   2925
      Width           =   240
   End
   Begin VB.HScrollBar ScrHorizontal 
      Height          =   240
      Left            =   4770
      TabIndex        =   2
      TabStop         =   0   'False
      Top             =   2700
      Width           =   1005
   End
   Begin VB.VScrollBar ScrVertical 
      Height          =   780
      Left            =   4635
      Max             =   5
      TabIndex        =   1
      TabStop         =   0   'False
      Top             =   765
      Width           =   240
   End
   Begin VB.PictureBox PicRule 
      BorderStyle     =   0  'None
      Height          =   3195
      Left            =   0
      ScaleHeight     =   3195
      ScaleWidth      =   1920
      TabIndex        =   0
      Top             =   0
      Width           =   1920
      Begin VB.Line lnLeft 
         BorderColor     =   &H00000000&
         BorderWidth     =   10
         X1              =   1800
         X2              =   1800
         Y1              =   0
         Y2              =   2565
      End
   End
   Begin VB.Image imAddControl 
      Height          =   480
      Left            =   3555
      Picture         =   "fReporte.frx":08CA
      Top             =   2250
      Visible         =   0   'False
      Width           =   480
   End
End
Attribute VB_Name = "fReporte"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
'--------------------------------------------------------------------------------
' fReporte
' 15-09-2001

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
' constantes
' estructuras
' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module As String = "fReporte"
Private Const C_TopBody = 150
Private Const C_LeftBody = 0
Private Const C_Min_Height_Section = 50
Private Const C_SectionLine = "Renglón "

Private Const c_NoMove = -1111111

Private Enum csAskEditResult
  csAskRsltYes = 1
  csAskRsltNo = 2
  csAskRsltCancel = 3
End Enum

' estructuras
Private Type Point
  x As Long
  y As Long
End Type
' variables privadas
Private WithEvents m_Report       As CSReportDll2.cReport
Attribute m_Report.VB_VarHelpID = -1
Private m_Paint                   As CSReportPaint2.cReportPaint
Private m_KeyMoving               As String
Private m_MoveType                As CSRptEditroMoveType
Private m_KeySizing               As String
Private m_MouseButtonPress        As Boolean
Private m_offX                    As Single
Private m_offY                    As Single
Private m_KeyObj                  As String
Private m_KeyFocus                As String
Private m_moving                  As Boolean
Private m_Opening                 As Boolean
Private m_OffSet                  As Single

Private m_IndexSecLnMoved         As Long    ' Esta es otra de mis inefables globales
                                             ' que me permiten saver cual es la SectionLine
                                             ' a partir de la cual debo modificar el top de los
                                             ' controles al moverlas. Esto solo se usa en
                                             ' Footers.
                                             
Private m_NewSecLineOffSet        As Single  ' Variable auxiliar para el calculo
                                             ' en MoveSection al agregar nuevas
                                             ' SectionLines.

Private m_bMoveVertical           As Boolean
Private m_bMoveHorizontal         As Boolean
Private m_bNoMove                 As Boolean

Private m_vSelectedKeys()         As String
Private m_vCopyKeys()             As String

Private WithEvents m_fProgress    As fProgress
Attribute m_fProgress.VB_VarHelpID = -1
Private m_CancelPrinting          As Boolean

Private m_FormIndex               As Long

Private WithEvents m_fProperties    As fProperties
Attribute m_fProperties.VB_VarHelpID = -1
Private WithEvents m_fSecProperties As fSecProperties
Attribute m_fSecProperties.VB_VarHelpID = -1
Private WithEvents m_fFormula       As fFormula
Attribute m_fFormula.VB_VarHelpID = -1
Private WithEvents m_fGroup         As fGroup
Attribute m_fGroup.VB_VarHelpID = -1
Private WithEvents m_fToolBox       As fToolbox
Attribute m_fToolBox.VB_VarHelpID = -1
Private WithEvents m_fControls      As fControls
Attribute m_fControls.VB_VarHelpID = -1
Private WithEvents m_fTreeCtrls     As fTreeViewCtrls
Attribute m_fTreeCtrls.VB_VarHelpID = -1
Private WithEvents m_fConnectsAux   As fConnectsAux
Attribute m_fConnectsAux.VB_VarHelpID = -1
Private WithEvents m_fSearch        As fSearch
Attribute m_fSearch.VB_VarHelpID = -1

' Nombres
Private m_NextNameCtrl        As Long
Private m_ShowingProperties   As Boolean
Private m_DataHasChanged      As Boolean

' Para agregar controles
Private m_CopyControls                  As Boolean
Private m_CopyControlsFromOtherReport   As Boolean
Private m_bCopyWithoutMoving            As Boolean

Private m_Draging           As Boolean
Private m_ControlName       As String
Private m_ControlType       As csRptEditCtrlType
Private m_FieldName         As String
Private m_FieldType         As Long
Private m_FieldIndex        As Long
Private m_FormulaText       As String

Private m_X             As Single
Private m_Y             As Single
Private m_KeyboardMove  As Boolean

Private m_KeyboardMoveStep As Integer

Private m_InMouseDown     As Boolean

Private m_TypeGrid As CSReportPaint2.csETypeGrid
' eventos
' propiedades publicas

Public Property Get vCopyKeys(ByVal Idx As Long) As String
  vCopyKeys = m_vCopyKeys(Idx)
End Property

Public Property Get vCopyKeysCount() As Long
  vCopyKeysCount = UBound(m_vCopyKeys)
End Property

Public Property Get Paint() As cReportPaint
  Set Paint = m_Paint
End Property

Public Property Let KeyboardMoveStep(ByVal rhs As Integer)
  m_KeyboardMoveStep = rhs
End Property
Public Property Get bMoveNoMove() As Boolean
  bMoveNoMove = m_bNoMove
End Property
Public Property Get bMoveVertical() As Boolean
  bMoveVertical = m_bMoveVertical
End Property
Public Property Get bMoveHorizontal() As Boolean
  bMoveHorizontal = m_bMoveHorizontal
End Property

Public Property Get PaperSize() As Long
  If m_Report Is Nothing Then Exit Property
  PaperSize = m_Report.PaperInfo.PaperSize
End Property

Public Property Get Orientation() As Long
  If m_Report Is Nothing Then Exit Property
  Orientation = m_Report.PaperInfo.Orientation
End Property

Public Property Get Copies() As Long
  If m_Report Is Nothing Then Exit Property
  Copies = m_Report.LaunchInfo.Copies
End Property

Public Property Let PaperSize(ByVal rhs As Long)
  If m_Report Is Nothing Then Exit Property
  m_Report.PaperInfo.PaperSize = rhs
End Property

Public Property Let Orientation(ByVal rhs As Long)
  If m_Report Is Nothing Then Exit Property
  m_Report.PaperInfo.Orientation = rhs
End Property

Public Property Let Copies(ByVal rhs As Long)
  If m_Report Is Nothing Then Exit Property
  m_Report.LaunchInfo.Copies = rhs
End Property

Public Property Let CustomHeight(ByVal rhs As Long)
  If m_Report Is Nothing Then Exit Property
  m_Report.PaperInfo.CustomHeight = rhs
End Property

Public Property Let CustomWidth(ByVal rhs As Long)
  If m_Report Is Nothing Then Exit Property
  m_Report.PaperInfo.CustomWidth = rhs
End Property

Public Property Get CustomHeight() As Long
  If m_Report Is Nothing Then Exit Property
  CustomHeight = m_Report.PaperInfo.CustomHeight
End Property

Public Property Get CustomWidth() As Long
  If m_Report Is Nothing Then Exit Property
  CustomWidth = m_Report.PaperInfo.CustomWidth
End Property

Public Property Get FileName() As String
   FileName = m_Report.Path & m_Report.Name
End Property

Public Property Get ShowingProperties() As Boolean
  ShowingProperties = m_ShowingProperties
End Property

Public Property Let ShowingProperties(ByVal rhs As Boolean)
  m_ShowingProperties = rhs
End Property

Public Property Get fGroup() As fGroup
  Set fGroup = m_fGroup
End Property

Public Property Set fGroup(ByRef rhs As fGroup)
  Set m_fGroup = rhs
End Property

Public Property Get Report() As CSReportDll2.cReport
  Set Report = m_Report
End Property

Public Property Get DataHasChanged() As Boolean
  DataHasChanged = m_DataHasChanged
End Property

Public Property Let DataHasChanged(ByVal rhs As Boolean)
  m_DataHasChanged = rhs
End Property

' propiedades privadas
' funciones publicas

Public Sub Search()
  Set fSearch.fReport = Me
  Set m_fSearch = fSearch
  fSearch.Show vbModeless, fMain
End Sub

Public Sub MoveVertical()
  Form_KeyUp vbKeyF11, 0
End Sub

Public Sub MoveHorizontal()
  Form_KeyUp vbKeyF12, 0
End Sub

Public Sub MoveNoMove()
  Form_KeyUp vbKeyF9, 0
End Sub

Public Sub MoveAll()
  Form_KeyUp vbKeyF8, 0
End Sub

' funciones privadas
Public Sub ShowGrid(ByVal TypeGrid As CSReportPaint2.csETypeGrid)
  m_TypeGrid = TypeGrid
  m_Paint.InitGrid PicBody, TypeGrid
End Sub

Public Sub ShowConnectsAux()
  On Error GoTo ControlError
  Dim Connect As CSReportDll2.cReportConnect
  
  Set m_fConnectsAux = New fConnectsAux
  Load m_fConnectsAux
  
  With m_fConnectsAux.lvColumns
    .ListItems.Clear
    .ColumnHeaders.Clear
    .ColumnHeaders.Add , , "DataSource", 2500
    .ColumnHeaders.Add , , "StrConnect", 5000
  
    For Each Connect In m_Report.ConnectsAux
      pAddConnectAuxToListView Connect
    Next
  End With

  m_fConnectsAux.Show vbModal

  GoTo ExitProc
ControlError:
  MngError Err, "ShowConnectsAux", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
  Unload m_fConnectsAux
  Set m_fConnectsAux = Nothing
End Sub

Private Sub pAddConnectAuxToListView(ByRef Connect As CSReportDll2.cReportConnect)
  Dim li As ListItem
  
  With m_fConnectsAux.lvColumns
    Set li = .ListItems.Add(, , Connect.DataSource)
    li.SubItems(1) = Connect.strConnect
  End With
End Sub

Private Sub Form_KeyUp(KeyCode As Integer, Shift As Integer)
  ' Si esta editando no hago nada
  If TxEdit.Visible Then Exit Sub

  Select Case KeyCode
    
    Case vbKeyF2
      EditText
    
    Case vbKeyDelete
      DeleteObj
    
    Case vbKeyEscape
      EndDraging
    
    Case vbKeyF11
      m_bMoveVertical = True
      m_bMoveHorizontal = False
      SetStatus
      
    Case vbKeyF12
      m_bMoveHorizontal = True
      m_bMoveVertical = False
      SetStatus
      
    Case vbKeyF8
      m_bMoveHorizontal = False
      m_bMoveVertical = False
      SetStatus
  
    Case vbKeyF9
      m_bNoMove = Not m_bNoMove
      SetStatus
      
    Case vbKeyF4
      ShowProperties
      
    Case vbKeyC
      If Shift And vbCtrlMask Then
        Copy
      End If
      
    Case vbKeyV
      If Shift And vbCtrlMask Then
        Paste False
      End If
      
  End Select
  
  DoEvents: DoEvents: DoEvents: DoEvents
End Sub

Private Sub Form_Resize()
  On Error Resume Next
  SizeControls
End Sub

Private Sub m_fConnectsAux_AddConnect()
  On Error GoTo ControlError
  
  Dim RptConnect As CSReportDll2.cReportConnect
  Set RptConnect = New CSReportDll2.cReportConnect
  
  If Not ConfigConnection(RptConnect) Then Exit Sub
  
  m_Report.ConnectsAux.Add RptConnect
  
  pAddConnectAuxToListView RptConnect

  GoTo ExitProc
ControlError:
  MngError Err, "m_fConnectsAux_AddConnect", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub m_fConnectsAux_DeleteConnect()
  On Error GoTo ControlError
  Dim Index As Long
  
  If m_fConnectsAux.lvColumns.SelectedItem Is Nothing Then
    MsgWarning "Seleccione una conexión", "Conexiones adicionales"
    Exit Sub
  End If
  
  Index = m_fConnectsAux.lvColumns.SelectedItem.Index

  m_Report.ConnectsAux.Remove Index
  
  m_fConnectsAux.lvColumns.ListItems.Remove Index

  GoTo ExitProc
ControlError:
  MngError Err, "m_fConnectsAux_DeleteConnect", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub m_fConnectsAux_EditConnect()
  On Error GoTo ControlError
  Dim Index As Long
  
  If m_fConnectsAux.lvColumns.SelectedItem Is Nothing Then
    MsgWarning "Seleccione una conexión", "Conexiones adicionales"
    Exit Sub
  End If
  
  Index = m_fConnectsAux.lvColumns.SelectedItem.Index
  
  If Not ConfigConnection(m_Report.ConnectsAux(Index)) Then Exit Sub
  
  With m_fConnectsAux.lvColumns.SelectedItem
    .Text = m_Report.ConnectsAux(Index).DataSource
    .SubItems(1) = m_Report.ConnectsAux(Index).strConnect
  End With

  GoTo ExitProc
ControlError:
  MngError Err, "m_fConnectsAux_EditConnect", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub m_fControls_EditCtrl(ByVal CtrlKey As String)
  On Error GoTo ControlError
  
  pSelectCtrl CtrlKey
  ShowProperties
  m_fControls.Clear
  m_fControls.AddCtrls m_Report

  GoTo ExitProc
ControlError:
  MngError Err, "m_fControls_EditCtrl", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub m_fSearch_EditCtrl(ByVal CtrlKey As String)
  On Error GoTo ControlError
  
  pSelectCtrl CtrlKey
  ShowProperties

  GoTo ExitProc
ControlError:
  MngError Err, "m_fSearch_EditCtrl", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub m_fSearch_EditSection(ByVal SecKey As String)
  On Error GoTo ControlError
  
  Dim bIsSecLn As Boolean
  
  pSelectSection SecKey, bIsSecLn
  
  If bIsSecLn Then
    ShowSecLnProperties
  Else
    ShowProperties
  End If

  GoTo ExitProc
ControlError:
  MngError Err, "m_fSearch_EditSection", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub m_fSearch_SetFocusCtrl(ByVal CtrlKey As String)
  On Error GoTo ControlError
  
  pSelectCtrl CtrlKey

  GoTo ExitProc
ControlError:
  MngError Err, "m_fSearch_SetFocusCtrl", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub m_fSearch_SetFocusSec(ByVal SecKey As String)
  On Error GoTo ControlError
  
  pSelectSection SecKey, False

  GoTo ExitProc
ControlError:
  MngError Err, "m_fSearch_SetFocusSec", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub m_fTreeCtrls_EditCtrl(ByVal CtrlKey As String)
  On Error GoTo ControlError
  
  pSelectCtrl CtrlKey
  ShowProperties
  m_fTreeCtrls.Clear
  m_fTreeCtrls.AddCtrls m_Report

  GoTo ExitProc
ControlError:
  MngError Err, "m_fTreeCtrls_EditCtrl", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub m_fControls_SetFocusCtrl(ByVal CtrlKey As String)
  On Error GoTo ControlError
  
  pSelectCtrl CtrlKey

  GoTo ExitProc
ControlError:
  MngError Err, "m_fControls_SetFocusCtrl", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub m_fTreeCtrls_EditSection(ByVal SecKey As String)
  On Error GoTo ControlError
  
  Dim bIsSecLn As Boolean
  
  pSelectSection SecKey, bIsSecLn
  
  If bIsSecLn Then
    ShowSecLnProperties
  Else
    ShowProperties
  End If
  m_fTreeCtrls.Clear
  m_fTreeCtrls.AddCtrls m_Report

  GoTo ExitProc
ControlError:
  MngError Err, "m_fTreeCtrls_EditCtrl", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub m_fTreeCtrls_SetFocusCtrl(ByVal CtrlKey As String)
  On Error GoTo ControlError
  
  pSelectCtrl CtrlKey

  GoTo ExitProc
ControlError:
  MngError Err, "m_fTreeCtrls_SetFocusCtrl", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub m_fTreeCtrls_SetFocusSec(ByVal SecKey As String)
  On Error GoTo ControlError
  
  pSelectSection SecKey, False

  GoTo ExitProc
ControlError:
  MngError Err, "m_fTreeCtrls_SetFocusSec", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub pSelectCtrl(ByVal CtrlKey As String)
  Dim bWasRemoved As Boolean
  Dim sKey        As String
  
  ReDim m_vSelectedKeys(0)
  sKey = Report.Controls.Item(CtrlKey).KeyPaint
  pAddToSelected sKey, vbLeftButton, 0, bWasRemoved
  
  If bWasRemoved Then sKey = vbNullString
  
  m_KeyFocus = sKey
  m_KeyObj = sKey
  m_Paint.SetFocus m_KeyFocus, PicBody, True
End Sub

Private Sub pSelectSection(ByVal SecKey As String, _
                           ByRef bIsSecLn As Boolean)
  Dim bWasRemoved As Boolean
  Dim sKey        As String
  
  bIsSecLn = False
  
  ReDim m_vSelectedKeys(0)
  
  If Not m_Report.Headers.Item(SecKey) Is Nothing Then
    sKey = m_Report.Headers.Item(SecKey).KeyPaint
  ElseIf Not m_Report.GroupsHeaders.Item(SecKey) Is Nothing Then
    sKey = m_Report.GroupsHeaders.Item(SecKey).KeyPaint
  ElseIf Not m_Report.Details.Item(SecKey) Is Nothing Then
    sKey = m_Report.Details.Item(SecKey).KeyPaint
  ElseIf Not m_Report.GroupsFooters.Item(SecKey) Is Nothing Then
    sKey = m_Report.GroupsFooters.Item(SecKey).KeyPaint
  ElseIf Not m_Report.Footers.Item(SecKey) Is Nothing Then
    sKey = m_Report.Footers.Item(SecKey).KeyPaint
  Else
    Dim SecLn As cReportSectionLine
    Dim Sec   As cReportSection
    
    bIsSecLn = True
    
    Set SecLn = pGetSecLnFromKey(SecKey, m_Report.Headers, Sec)
    If Not SecLn Is Nothing Then
      sKey = SecLn.KeyPaint
      If sKey = vbNullString Then
        sKey = Sec.KeyPaint
      End If
    Else
      Set SecLn = pGetSecLnFromKey(SecKey, m_Report.GroupsHeaders, Sec)
      If Not SecLn Is Nothing Then
        sKey = SecLn.KeyPaint
        If sKey = vbNullString Then
          sKey = Sec.KeyPaint
        End If
      Else
        Set SecLn = pGetSecLnFromKey(SecKey, m_Report.Details, Sec)
        If Not SecLn Is Nothing Then
          sKey = SecLn.KeyPaint
          If sKey = vbNullString Then
            sKey = Sec.KeyPaint
          End If
        Else
          Set SecLn = pGetSecLnFromKey(SecKey, m_Report.GroupsFooters, Sec)
          If Not SecLn Is Nothing Then
            sKey = SecLn.KeyPaint
            If sKey = vbNullString Then
              sKey = Sec.KeyPaint
            End If
          Else
            Set SecLn = pGetSecLnFromKey(SecKey, m_Report.Footers, Sec)
            If Not SecLn Is Nothing Then
              sKey = SecLn.KeyPaint
              If sKey = vbNullString Then
                sKey = Sec.KeyPaint
              End If
            End If
          End If
        End If
      End If
    End If
  End If
  
  If sKey = vbNullString Then Exit Sub
  
  pAddToSelected sKey, vbLeftButton, 0, bWasRemoved
  If bWasRemoved Then sKey = vbNullString
  
  m_KeyFocus = sKey
  m_KeyObj = sKey
  m_Paint.SetFocus m_KeyFocus, PicBody, True
End Sub

Private Function pGetSecLnFromKey(ByVal SecKey As String, _
                                  ByRef Sections As cReportSections, _
                                  ByRef rtnSec As cReportSection) As cReportSectionLine
  Dim Sec As cReportSection
  For Each Sec In Sections
    If Not Sec.SectionLines.Item(SecKey) Is Nothing Then
      Set rtnSec = Sec
      Set pGetSecLnFromKey = Sec.SectionLines.Item(SecKey)
      Exit Function
    End If
  Next
End Function

Private Sub m_fFormula_CheckSintaxis(ByRef Cancel As Boolean, ByVal code As String)
  Dim f As CSReportDll2.cReportFormula
  Set f = New CSReportDll2.cReportFormula
  If Not m_fProperties Is Nothing Then
    f.Name = m_fProperties.FormulaName
  Else
    f.Name = m_fSecProperties.FormulaName
  End If
  f.Text = code
  Cancel = Not m_Report.Compiler.CheckSintax(f)
End Sub

Private Sub m_fGroup_ShowHelpDbField()
  Dim nIndex As Long
  Dim nFieldType As Long
  Dim sField As String

  With m_fGroup
    sField = .TxDbField.Text
    nFieldType = .FieldType
    nIndex = .Index

    If Not ShowDbFields(sField, nFieldType, nIndex, Me) Then Exit Sub

    .TxDbField.Text = sField
    .FieldType = nFieldType
    .Index = nIndex

  End With
End Sub

Private Sub m_fProperties_ShowEditFormula(ByRef Formula As String, ByRef Cancel As Boolean)
  pShowEditFormula Formula, Cancel
End Sub

Private Sub m_fProperties_ShowHelpChartField(Cancel As Boolean, Ctrl As Object, ByVal Idx As Long)
  Dim nIndex As Long
  Dim nFieldType As Long
  Dim sField As String

  With m_fProperties
    sField = Ctrl.Text
    nFieldType = .ChartFieldType(Idx)
    nIndex = .ChartIndex(Idx)
    
    Cancel = Not ShowDbFields(sField, nFieldType, nIndex, Me)
    If Cancel Then Exit Sub

    Ctrl.Text = sField
    .ChartFieldType(Idx) = nFieldType
    .ChartIndex(Idx) = nIndex
  End With
End Sub

Private Sub m_fProperties_ShowHelpChartGroupField(Cancel As Boolean)
  Dim nIndex As Long
  Dim nFieldType As Long
  Dim sField As String

  With m_fProperties
    sField = .TxDbFieldGroupValue.Text
    nFieldType = .ChartGroupFieldType
    nIndex = .ChartGroupIndex
    
    Cancel = Not ShowDbFields(sField, nFieldType, nIndex, Me)
    If Cancel Then Exit Sub

    .TxDbFieldGroupValue.Text = sField
    .ChartGroupFieldType = nFieldType
    .ChartGroupIndex = nIndex
  End With
End Sub

Private Sub m_fSecProperties_ShowEditFormula(Formula As String, Cancel As Boolean)
  pShowEditFormula Formula, Cancel
End Sub

Private Sub pShowEditFormula(ByRef Formula As String, ByRef Cancel As Boolean)
  On Error GoTo ControlError

  Dim f As CSReportDll2.cReportFormulaType
  Dim c As CSReportDll2.cReportControl

  If m_fFormula Is Nothing Then Set m_fFormula = New fFormula

  With m_fFormula

    ' Cargo el arbol de formulas
    .CreateArbol

    For Each f In m_Report.FormulaTypes
      .AddFormula f.Id, f.Name, f.NameUser, f.Decrip, f.HelpContextId
    Next f

    For Each c In m_Report.Controls
      If c.ControlType = CSReportDll2.csRptControlType.csRptCtField Then
        .AddDBField c.Name, c.Field.Name
      ElseIf c.ControlType = CSReportDll2.csRptControlType.csRptCtLabel Then
        .AddLabel c.Name
      End If
    Next c

    .ctxFormula.Text = Formula

    .ExpandTree

    CenterForm m_fFormula

    .Show vbModal
    
    Cancel = Not .Ok
    
    If Not Cancel Then
      Formula = .ctxFormula.Text
    End If
  End With

  GoTo ExitProc
ControlError:
  MngError Err(), "m_fProperties_ShowEditFormula", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
  Unload m_fFormula
End Sub

Private Sub m_fSecProperties_UnloadForm()
  Set m_fSecProperties = Nothing
End Sub

Private Sub m_fToolBox_AddControl(ByVal ControlName As String, ByVal ControlType As csRptEditCtrlType, _
                                  ByVal FieldName As String, ByVal FormulaText As String, ByVal FieldType As Long, _
                                  ByVal FieldIndex As Long)

  BeginDraging
  m_ControlName = ControlName
  m_ControlType = ControlType
  m_FieldName = FieldName
  m_FormulaText = FormulaText
  m_FieldIndex = FieldIndex
  m_FieldType = FieldType
End Sub

Private Sub m_fTreeCtrls_UpdateFormulaHide(ByVal CtrlKey As String, ByVal Formula As String)
  m_Report.Controls.Item(CtrlKey).FormulaHide.Text = Formula
End Sub

Private Sub m_fTreeCtrls_UpdateFormulaValue(ByVal CtrlKey As String, ByVal Formula As String)
  m_Report.Controls.Item(CtrlKey).FormulaValue.Text = Formula
End Sub

Private Sub m_fTreeCtrls_UpdateSectionFormulaHide(ByVal SecKey As String, ByVal Formula As String)
    
  If Not m_Report.Headers.Item(SecKey) Is Nothing Then
    m_Report.Headers.Item(SecKey).FormulaHide.Text = Formula
  ElseIf Not m_Report.GroupsHeaders.Item(SecKey) Is Nothing Then
    m_Report.GroupsHeaders.Item(SecKey).FormulaHide.Text = Formula
  ElseIf Not m_Report.Details.Item(SecKey) Is Nothing Then
    m_Report.Details.Item(SecKey).FormulaHide.Text = Formula
  ElseIf Not m_Report.GroupsFooters.Item(SecKey) Is Nothing Then
    m_Report.GroupsFooters.Item(SecKey).FormulaHide.Text = Formula
  ElseIf Not m_Report.Footers.Item(SecKey) Is Nothing Then
    m_Report.Footers.Item(SecKey).FormulaHide.Text = Formula
  Else
    Dim SecLn As cReportSectionLine
    Dim Sec   As cReportSection
        
    Set SecLn = pGetSecLnFromKey(SecKey, m_Report.Headers, Sec)
    If Not SecLn Is Nothing Then
      SecLn.FormulaHide.Text = Formula
    Else
      Set SecLn = pGetSecLnFromKey(SecKey, m_Report.GroupsHeaders, Sec)
      If Not SecLn Is Nothing Then
        SecLn.FormulaHide.Text = Formula
      Else
        Set SecLn = pGetSecLnFromKey(SecKey, m_Report.Details, Sec)
        If Not SecLn Is Nothing Then
          SecLn.FormulaHide.Text = Formula
        Else
          Set SecLn = pGetSecLnFromKey(SecKey, m_Report.GroupsFooters, Sec)
          If Not SecLn Is Nothing Then
            SecLn.FormulaHide.Text = Formula
          Else
            Set SecLn = pGetSecLnFromKey(SecKey, m_Report.Footers, Sec)
            If Not SecLn Is Nothing Then
              SecLn.FormulaHide.Text = Formula
            End If
          End If
        End If
      End If
    End If
  End If
  
End Sub

Private Sub PicBody_KeyDown(KeyCode As Integer, Shift As Integer)
  On Error GoTo ControlError

  Select Case KeyCode
    Case vbKeyUp, vbKeyDown, vbKeyLeft, vbKeyRight
      ' Solo si son teclas de posicion
    Case Else
      Exit Sub
  End Select

  Dim x As Single
  Dim y As Single

  If UBound(m_vSelectedKeys) < 1 Then Exit Sub

  If Not m_KeyboardMove Then
    With m_Paint.GetPaintObject(m_vSelectedKeys(1)).Aspect
      y = .Top
      x = .Left
    End With
  Else
    y = m_Y
    x = m_X
  End If

  ' Resize
  '
  If Shift And vbShiftMask Then
    
    If m_KeySizing = vbNullString Then
      m_KeySizing = m_Paint.GetPaintObject(m_vSelectedKeys(1)).Key
    End If
    
    If Not m_KeyboardMove Then
  
      With m_Paint.GetPaintObject(m_vSelectedKeys(1)).Aspect
        y = y + .Height
        x = x + .Width
      End With
      
      pSetMovingFromKeyboard x, y
  
      If m_KeySizing = vbNullString Then
        m_KeySizing = m_Paint.GetPaintObject(m_vSelectedKeys(1)).Key
      End If
      
      Select Case KeyCode
        
        Case vbKeyDown, vbKeyUp
          m_KeyMoving = vbNullString
          m_MoveType = CSRptEditroMoveType.csRptEdMovDown
  
        Case vbKeyRight, vbKeyLeft
          m_KeyMoving = vbNullString
          m_MoveType = CSRptEditroMoveType.csRptEdMovRight
      End Select
    End If
    
    Select Case KeyCode
      Case vbKeyUp
        y = y - m_KeyboardMoveStep
      Case vbKeyDown
        y = y + m_KeyboardMoveStep
      Case vbKeyLeft
        x = x - m_KeyboardMoveStep
      Case vbKeyRight
        x = x + m_KeyboardMoveStep
    End Select
    
  ' Move
  '
  Else
    
    If Not m_KeyboardMove Then
      pSetMovingFromKeyboard x, y
    End If
    
    If m_KeyMoving = vbNullString Then
      m_KeyMoving = m_Paint.GetPaintObject(m_vSelectedKeys(1)).Key
    End If
    
    Select Case KeyCode
      Case vbKeyUp
        y = y - m_KeyboardMoveStep
      Case vbKeyDown
        y = y + m_KeyboardMoveStep
      Case vbKeyLeft
        x = x - m_KeyboardMoveStep
      Case vbKeyRight
        x = x + m_KeyboardMoveStep
    End Select
  End If
  
  PicBody_MouseMove vbLeftButton, 0, x, y
  m_X = x
  m_Y = y
  
  m_KeyboardMove = True
  
  GoTo ExitProc
ControlError:
  MngError Err(), "PicBody_KeyDown", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
End Sub

Private Sub pSetMovingFromKeyboard(ByVal x As Single, _
                                   ByVal y As Single)
        
  m_KeyMoving = m_KeyFocus

  With m_Paint.GetPaintObject(m_KeyMoving)
  
    Select Case .Tag
      Case C_KEY_DETAIL, C_KEY_FOOTER, C_KEY_HEADER
        m_MoveType = CSRptEditroMoveType.csRptEdMovTVertical
        PicBody.MousePointer = vbSizeNS
      
      Case Else
        If .RptType = CSReportPaint2.csRptPaintRptType.csRptPaintRptTypeSectionDetail Or _
           .RptType = CSReportPaint2.csRptPaintRptType.csRptPaintRptTypeSectionHeader Or _
           .RptType = CSReportPaint2.csRptPaintRptType.csRptPaintRptTypeGroupSectionHeader Or _
           .RptType = CSReportPaint2.csRptPaintRptType.csRptPaintRptTypeGroupSectionFooter Or _
           .RptType = CSReportPaint2.csRptPaintRptType.csRptPaintRptTypeSectionFooter Then
           
          PicBody.MousePointer = vbSizeNS
          m_MoveType = CSRptEditroMoveType.csRptEdMovTVertical
        
        ElseIf .RptType = C_KEY_SECLN_HEADER Or _
               .RptType = C_KEY_SECLN_DETAIL Or _
               .RptType = C_KEY_SECLN_FOOTER Or _
               .RptType = C_KEY_SECLN_GROUPH Or _
               .RptType = C_KEY_SECLN_GROUPF Then
          
          PicBody.MousePointer = vbSizeNS
          m_MoveType = CSRptEditroMoveType.csRptEdMovTVertical
        
        Else
          m_MoveType = CSRptEditroMoveType.csRptEdMovTAll
          PicBody.MousePointer = vbSizeAll
        End If
    End Select
  End With
  
  With m_Paint.GetPaintObject(m_KeyMoving).Aspect
    m_offX = x - .Left
    m_offY = y - (.Top - .OffSet)
  End With
    
  m_KeyObj = m_KeyMoving

  SetEditAlignTextState UBound(m_vSelectedKeys)
  SetEditAlignCtlState UBound(m_vSelectedKeys) > 1
  pSetEditAlignValue
  pSetFontBoldValue

End Sub

Private Sub PicBody_KeyUp(KeyCode As Integer, Shift As Integer)
  If m_KeyboardMove Then
    m_KeyboardMove = False
    PicBody_MouseUp vbLeftButton, 0, m_X, m_Y
  End If
End Sub

Private Sub PicBody_MouseDown(Button As Integer, Shift As Integer, x As Single, y As Single)
  On Error GoTo ControlError
  
  Dim sKey            As String
  Dim bClearSelected  As Boolean
  Dim lastKeyMoving   As String
  Dim lastKeyObj      As String
  
  ' Para evitar rebotes
  If m_Opening Then Exit Sub

  m_InMouseDown = True

  If m_Draging Then
    AddControlEnd x, y
    EndDraging
  End If

  EndEditText False

  bClearSelected = pClearSelected(Button, Shift, x, y)
  
  If Button = vbLeftButton Then
  
    lastKeyObj = m_KeyObj
    m_KeyObj = vbNullString

    sKey = IIf(m_KeyMoving <> vbNullString, m_KeyMoving, m_KeySizing)
    
    ' Esto es para que el header tome el foco
    If sKey = vbNullString Then
      m_Paint.PointIsInObject x, y, sKey
    
      If sKey <> vbNullString Then
        With m_Paint.GetPaintObject(sKey)
        
          lastKeyMoving = m_KeyMoving
          m_KeyMoving = sKey
          
          Select Case .Tag
            Case C_KEY_DETAIL, C_KEY_FOOTER, C_KEY_HEADER
              
              ' Solo si no hay controles seleccionados
              '
              If Shift And vbCtrlMask Then
                
                If UBound(m_vSelectedKeys) Then Exit Sub
                If LenB(m_vSelectedKeys(0)) Then Exit Sub
                m_KeyMoving = lastKeyMoving
                m_KeyObj = lastKeyObj
                Exit Sub
              End If
            
              m_MoveType = CSRptEditroMoveType.csRptEdMovTVertical
              PicBody.MousePointer = vbSizeNS
            
            Case Else
              If .RptType = CSReportPaint2.csRptPaintRptType.csRptPaintRptTypeSectionDetail Or _
                 .RptType = CSReportPaint2.csRptPaintRptType.csRptPaintRptTypeSectionHeader Or _
                 .RptType = CSReportPaint2.csRptPaintRptType.csRptPaintRptTypeGroupSectionHeader Or _
                 .RptType = CSReportPaint2.csRptPaintRptType.csRptPaintRptTypeGroupSectionFooter Or _
                 .RptType = CSReportPaint2.csRptPaintRptType.csRptPaintRptTypeSectionFooter Then
                 
                ' Solo si no hay controles seleccionados
                '
                If Shift And vbCtrlMask Then
                  
                  If UBound(m_vSelectedKeys) Then Exit Sub
                  If LenB(m_vSelectedKeys(0)) Then Exit Sub
                  m_KeyMoving = lastKeyMoving
                  m_KeyObj = lastKeyObj
                  Exit Sub
                End If
                 
                PicBody.MousePointer = vbSizeNS
                m_MoveType = CSRptEditroMoveType.csRptEdMovTVertical
                
              ElseIf .RptType = C_KEY_SECLN_HEADER Or _
                     .RptType = C_KEY_SECLN_DETAIL Or _
                     .RptType = C_KEY_SECLN_FOOTER Or _
                     .RptType = C_KEY_SECLN_GROUPH Or _
                     .RptType = C_KEY_SECLN_GROUPF Then
                
                ' Solo si no hay controles seleccionados
                '
                If Shift And vbCtrlMask Then
                  
                  If UBound(m_vSelectedKeys) Then Exit Sub
                  If LenB(m_vSelectedKeys(0)) Then Exit Sub
                  m_KeyMoving = lastKeyMoving
                  m_KeyObj = lastKeyObj
                  Exit Sub
                End If
                
                PicBody.MousePointer = vbSizeNS
                m_MoveType = CSRptEditroMoveType.csRptEdMovTVertical
              
              Else
                m_MoveType = CSRptEditroMoveType.csRptEdMovTAll
                PicBody.MousePointer = vbSizeAll
              End If
          End Select
        End With
      End If
    End If
    
    Dim bWasRemoved As Boolean
    pAddToSelected m_KeyMoving, Button, Shift, bWasRemoved
    
    If bWasRemoved Then sKey = vbNullString
    
    If sKey <> vbNullString Then
      With m_Paint.GetPaintObject(sKey).Aspect
        m_offX = x - .Left
        m_offY = y - (.Top - .OffSet)
      End With
    End If
    
    m_KeyFocus = sKey
    m_KeyObj = sKey
    m_Paint.SetFocus m_KeyFocus, PicBody, bClearSelected
    
  ElseIf Button = vbRightButton Then
    
    m_KeySizing = vbNullString
    m_KeyMoving = vbNullString
    m_KeyObj = vbNullString

    If m_Paint.PointIsInObject(x, y, sKey) Then
      m_KeyObj = sKey

      bClearSelected = pSetSelectForRightBttn

      ' Esto esta aca para que se pinte
      ' antes que aparezca el menu
      m_KeyFocus = sKey
      m_Paint.SetFocus m_KeyFocus, PicBody, bClearSelected

      With m_Paint.GetPaintObject(sKey)

        If m_Paint.PaintObjIsSection(sKey) Then

          Dim NoDelete As Boolean

          Select Case .Tag
            ' El Header no se puede mover
            Case C_KEY_HEADER, C_KEY_DETAIL, C_KEY_FOOTER
              NoDelete = True

            Case Else
              NoDelete = False

           End Select
           
           Dim IsGroup As Boolean
           Dim IsSecLn As Boolean
           
           pGetSection IsGroup, IsSecLn
           
           If IsSecLn Then NoDelete = True

           ShowPopMenuSection NoDelete, IsGroup
        Else
          ShowPopMenuControl True
        End If
      End With
    Else
      ShowPopMenuControl False
    End If
  End If
  
  SetEditAlignTextState UBound(m_vSelectedKeys)
  SetEditAlignCtlState UBound(m_vSelectedKeys) > 1
  pSetEditAlignValue
  pSetFontBoldValue

  GoTo ExitProc
ControlError:
  MngError Err(), "PicBody_MouseDown", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  m_InMouseDown = False
End Sub

Public Sub SetFontBold()
  Dim bBold       As Integer
  Dim bBoldValue  As Boolean
  Dim i           As Long
  
  bBold = -2
  
  For i = 1 To UBound(m_vSelectedKeys)
    With m_Paint.GetPaintObject(m_vSelectedKeys(i)).Aspect.Font
    
      If bBold = -2 Then
    
        bBold = .Bold
        
      ElseIf bBold <> .Bold Then
        
        bBold = -2
        Exit For
      End If
    End With
  Next
  
  If bBold = -2 Then
    bBoldValue = True
  Else
    bBoldValue = Not CBool(bBold)
  End If
  
  Dim PaintObject   As CSReportPaint2.cReportPaintObject
  Dim RptCtrl       As CSReportDll2.cReportControl
  
  For i = 1 To UBound(m_vSelectedKeys)

    Set PaintObject = m_Paint.GetPaintObject(m_vSelectedKeys(i))
    Set RptCtrl = m_Report.Controls.Item(PaintObject.Tag)

    RptCtrl.Label.Aspect.Font.Bold = bBoldValue
  
    '////////////////////////////////////////////////////////'
    ' esto sera removido cuando agreguemos una interface     '
    '////////////////////////////////////////////////////////'
    PaintObject.Aspect.Font.Bold = bBoldValue
  Next
  
  m_DataHasChanged = True
  RefreshAll
  pSetFontBoldValue
End Sub

Public Sub pSetFontBoldValue()
  Dim bBold  As Integer
  Dim i      As Long
  
  bBold = -2
  
  For i = 1 To UBound(m_vSelectedKeys)
    With m_Paint.GetPaintObject(m_vSelectedKeys(i)).Aspect.Font
    
      If bBold = -2 Then
    
        bBold = .Bold
        
      ElseIf bBold <> .Bold Then
        
        bBold = -2
        Exit For
      End If
    End With
  Next
  
  SetEditFontBoldValue bBold
End Sub

Public Sub ControlsAlign(ByVal Align As csECtlAlignConst)
  Dim i             As Long
  Dim PaintObject   As CSReportPaint2.cReportPaintObject
  Dim RptCtrl       As CSReportDll2.cReportControl
  
  Dim Top  As Long
  Dim Left As Long
  
  Dim NewTop  As Long
  Dim NewLeft As Long
  Dim Height  As Long
  Dim Width   As Long
  
  Select Case Align
    
    Case csECtlAlignHeight, csECtlAlignWidth
    
      With m_Paint.GetPaintObject(m_vSelectedKeys(1)).Aspect
        Height = .Height
        Width = .Width
      End With
    
    Case csECtlAlignVertical, csECtlAlignHorizontal
      
      With m_Paint.GetPaintObject(m_vSelectedKeys(1)).Aspect
        NewTop = .Top
        NewLeft = .Left
      End With
    
    Case Else
      
      Select Case Align
        Case csECtlAlignLeft
          NewLeft = 100000
        Case csECtlAlignRight
          NewLeft = 0
        Case csECtlAlignTop
          NewTop = 100000
        Case csECtlAlignBottom
          NewTop = 0
      End Select
      
      For i = 1 To UBound(m_vSelectedKeys)
        
        With m_Paint.GetPaintObject(m_vSelectedKeys(i)).Aspect
          Top = .Top
          Left = .Left
        End With
        
        Select Case Align
          Case csECtlAlignLeft
            If Left < NewLeft Then NewLeft = Left
          Case csECtlAlignRight
            If Left > NewLeft Then NewLeft = Left
          Case csECtlAlignTop
            If Top < NewTop Then NewTop = Top
          Case csECtlAlignBottom
            If Top > NewTop Then NewTop = Top
        End Select
      Next
  
  End Select
  
  For i = 1 To UBound(m_vSelectedKeys)

    Set PaintObject = m_Paint.GetPaintObject(m_vSelectedKeys(i))
    Set RptCtrl = m_Report.Controls.Item(PaintObject.Tag)

    Select Case Align
    
      Case csECtlAlignHeight
        RptCtrl.Label.Aspect.Height = Height
        
        ' esto sera removido cuando agreguemos una interface
        '
        PaintObject.Aspect.Height = Height
    
      Case csECtlAlignWidth
        RptCtrl.Label.Aspect.Width = Width
        
        ' esto sera removido cuando agreguemos una interface
        '
        PaintObject.Aspect.Width = Width
    
      Case csECtlAlignLeft, csECtlAlignRight, csECtlAlignHorizontal
        RptCtrl.Label.Aspect.Left = NewLeft
        
        ' esto sera removido cuando agreguemos una interface
        '
        PaintObject.Aspect.Left = NewLeft
        
      Case csECtlAlignTop, csECtlAlignBottom, csECtlAlignVertical
        RptCtrl.Label.Aspect.Top = NewTop
        
        ' esto sera removido cuando agreguemos una interface
        '
        PaintObject.Aspect.Top = NewTop
    End Select
  Next

  m_DataHasChanged = True
  RefreshAll
End Sub

Public Sub TextAlign(ByVal Align As AlignmentConstants)
  Dim i             As Long
  Dim PaintObject   As CSReportPaint2.cReportPaintObject
  Dim RptCtrl       As CSReportDll2.cReportControl
  
  For i = 1 To UBound(m_vSelectedKeys)

    Set PaintObject = m_Paint.GetPaintObject(m_vSelectedKeys(i))
    Set RptCtrl = m_Report.Controls.Item(PaintObject.Tag)

    RptCtrl.Label.Aspect.Align = Align
  
    '////////////////////////////////////////////////////////'
    ' esto sera removido cuando agreguemos una interface     '
    '////////////////////////////////////////////////////////'
    PaintObject.Aspect.Align = Align
  Next
  
  m_DataHasChanged = True
  RefreshAll
  pSetEditAlignValue
End Sub

Private Sub pSetEditAlignValue()
  Dim Align  As AlignmentConstants
  Dim i      As Long
  
  Align = -1
  
  For i = 1 To UBound(m_vSelectedKeys)
    With m_Paint.GetPaintObject(m_vSelectedKeys(i)).Aspect
    
      If Align = -1 Then
    
        Align = .Align
        
      ElseIf Align <> .Align Then
        
        Align = -2
        Exit For
      End If
    End With
  Next
  
  SetEditAlignValue Align
End Sub

Private Sub pAddToSelected(ByVal sKey As String, _
                           ByVal Button As Integer, _
                           ByVal Shift As Integer, _
                           ByRef bWasRemoved As Boolean)
                           
  Dim i As Long
  If sKey = vbNullString Then Exit Sub
  
  bWasRemoved = False
  
  If Shift And vbCtrlMask Then

    For i = 1 To UBound(m_vSelectedKeys)
      
      If m_vSelectedKeys(i) = sKey Then
        pRemoveFromSelected sKey
        bWasRemoved = True
        Exit Sub
      End If
    Next
  Else
    If pAllreadySelected(sKey) Then Exit Sub
  End If
  
  ReDim Preserve m_vSelectedKeys(UBound(m_vSelectedKeys) + 1)
  m_vSelectedKeys(UBound(m_vSelectedKeys)) = sKey
End Sub

Private Function pAllreadySelected(ByVal sKey As String) As Boolean
  Dim i As Long
  
  If sKey = vbNullString Then
    pAllreadySelected = True
    Exit Function
  End If
  
  For i = 1 To UBound(m_vSelectedKeys)
    If m_vSelectedKeys(i) = sKey Then
      pAllreadySelected = True
      Exit Function
    End If
  Next
End Function

Private Sub pRemoveFromSelected(ByVal sKey As String)
  Dim i As Long
  
  For i = 1 To UBound(m_vSelectedKeys)
    If m_vSelectedKeys(i) = sKey Then
      Exit For
    End If
  Next
  
  If i > UBound(m_vSelectedKeys) Then Exit Sub
  For i = i + 1 To UBound(m_vSelectedKeys)
    m_vSelectedKeys(i - 1) = m_vSelectedKeys(i)
  Next
  If UBound(m_vSelectedKeys) > 0 Then
    ReDim Preserve m_vSelectedKeys(UBound(m_vSelectedKeys) - 1)
  Else
    ReDim m_vSelectedKeys(0)
  End If
  
  m_Paint.RemoveFromSelected sKey, PicBody
End Sub

Private Function pClearSelected(Button As Integer, Shift As Integer, x As Single, y As Single) As Boolean
  Dim sKey As String
  Dim i    As Long
  
  If (Not Shift And vbCtrlMask) And Not Button = vbRightButton Then
    m_Paint.PointIsInObject x, y, sKey
    For i = 1 To UBound(m_vSelectedKeys)
      If m_vSelectedKeys(i) = sKey Then
        Exit Function
      End If
    Next
    ReDim m_vSelectedKeys(0)
    pClearSelected = True
  End If
End Function

Private Sub pShowMoveAll(ByVal x As Single, ByVal y As Single)
  Dim i           As Long
  Dim OffsetTop   As Long
  Dim OffsetLeft  As Long
  Dim FirstLeft   As Long
  Dim FirstTop    As Long
  Dim Clear       As Boolean
  Dim OffSet2     As Long
  
  If UBound(m_vSelectedKeys) = 0 Then Exit Sub
  
  With m_Paint.GetPaintObject(m_KeyMoving).Aspect
    FirstLeft = .Left
    FirstTop = .Top
  End With
  
  Clear = True
  
  For i = UBound(m_vSelectedKeys) To 1 Step -1
    
    With m_Paint.GetPaintObject(m_vSelectedKeys(i)).Aspect
      OffsetLeft = pGetOffsetLeftFromControls(FirstLeft, .Left)
      OffsetTop = pGetOffsetTopFromControls(FirstTop, .Top)
      OffSet2 = .OffSet
    End With
  
    If m_bMoveHorizontal Then
      m_Paint.MoveObjToXYEx m_KeyMoving, _
                            x - m_offX + OffsetLeft, _
                            FirstTop - OffSet2 + OffsetTop, _
                            PicBody, Clear
    
    ElseIf m_bMoveVertical Then
      m_Paint.MoveObjToXYEx m_KeyMoving, _
                            FirstLeft + OffsetLeft, _
                            y - m_offY + OffsetTop, _
                            PicBody, Clear
    Else
      m_Paint.MoveObjToXYEx m_KeyMoving, _
                            x - m_offX + OffsetLeft, _
                            y - m_offY + OffsetTop, _
                            PicBody, Clear
    End If
    
    If Clear Then Clear = False
    
  Next
End Sub

Private Sub PicBody_MouseMove(Button As Integer, Shift As Integer, x As Single, y As Single)
  Dim sKey As String
  Dim RgnTp As CSReportPaint2.cRptPaintRegionType

  If m_Draging Then Exit Sub

  If m_InMouseDown Then Exit Sub

  If Button = vbLeftButton Then
  
    m_Paint.BeginMove
  
    If m_KeyMoving <> vbNullString Then

      Select Case m_MoveType
        Case CSRptEditroMoveType.csRptEdMovTAll
          pShowMoveAll x, y
        Case CSRptEditroMoveType.csRptEdMovTHorizontal
          m_Paint.MoveHorizontal m_KeyMoving, x, PicBody
        Case CSRptEditroMoveType.csRptEdMovTVertical
          m_Paint.MoveVertical m_KeyMoving, y, PicBody
      End Select

      m_moving = True

    ElseIf m_KeySizing <> vbNullString Then
      Select Case m_MoveType
        Case CSRptEditroMoveType.csRptEdMovDown
          m_Paint.Resize PicBody, m_KeySizing, , , , y
        Case CSRptEditroMoveType.csRptEdMovLeft
          m_Paint.Resize PicBody, m_KeySizing, x
        Case CSRptEditroMoveType.csRptEdMovRight
          m_Paint.Resize PicBody, m_KeySizing, , , x
        Case CSRptEditroMoveType.csRptEdMovUp
          m_Paint.Resize PicBody, m_KeySizing, , y
        Case CSRptEditroMoveType.csRptEdMovLeftDown
          m_Paint.Resize PicBody, m_KeySizing, x, , , y
        Case CSRptEditroMoveType.csRptEdMovLeftUp
          m_Paint.Resize PicBody, m_KeySizing, x, y
        Case CSRptEditroMoveType.csRptEdMovRightDown
          m_Paint.Resize PicBody, m_KeySizing, , , x, y
        Case CSRptEditroMoveType.csRptEdMovRightUp
          m_Paint.Resize PicBody, m_KeySizing, , y, x
      End Select

      m_moving = True

    Else
      m_moving = False
    End If
  Else
    If m_KeyFocus <> vbNullString Then
      sKey = m_KeyFocus
      If m_Paint.PointIsInThisObject(x, y, m_KeyFocus, RgnTp) Then
        With m_Paint.GetPaintObject(sKey)
          
          With m_Report.Controls.Item(.Tag)
            pSetSbPnlCtrl .Name, .ControlType, .FormulaHide.Text, .FormulaValue.Text, .HasFormulaHide, .HasFormulaValue, .Field.Name
          End With
          
          If .PaintType = CSReportPaint2.cRptPaintObjType.csRptPaintObjLine Then
            m_KeyMoving = sKey
            m_KeySizing = vbNullString
            PicBody.MousePointer = vbSizeNS
          Else
            Select Case .Tag
              Case C_KEY_DETAIL, C_KEY_FOOTER, C_KEY_HEADER
                m_KeyMoving = sKey
                m_KeySizing = vbNullString
                PicBody.MousePointer = vbSizeNS
                m_MoveType = CSRptEditroMoveType.csRptEdMovTVertical
  
              Case Else
  
                If .RptType = CSReportPaint2.csRptPaintRptType.csRptPaintRptTypeSectionDetail Or .RptType = CSReportPaint2.csRptPaintRptType.csRptPaintRptTypeSectionHeader Or .RptType = CSReportPaint2.csRptPaintRptType.csRptPaintRptTypeGroupSectionHeader Or .RptType = CSReportPaint2.csRptPaintRptType.csRptPaintRptTypeGroupSectionFooter Or .RptType = CSReportPaint2.csRptPaintRptType.csRptPaintRptTypeSectionFooter Then
  
                  m_KeyMoving = sKey
                  m_KeySizing = vbNullString
                  PicBody.MousePointer = vbSizeNS
                  m_MoveType = CSRptEditroMoveType.csRptEdMovTVertical
                Else
  
                  Select Case RgnTp
                    Case CSReportPaint2.cRptPaintRegionType.cRptPntRgnTypeBody
                      PicBody.MousePointer = vbSizeAll
                      m_KeyMoving = sKey
                      m_KeySizing = vbNullString
                      m_MoveType = CSRptEditroMoveType.csRptEdMovTAll
  
                    Case CSReportPaint2.cRptPaintRegionType.cRptPntRgnTypeDown
                      PicBody.MousePointer = vbSizeNS
                      m_KeySizing = sKey
                      m_KeyMoving = vbNullString
                      m_MoveType = CSRptEditroMoveType.csRptEdMovDown
  
                    Case CSReportPaint2.cRptPaintRegionType.cRptPntRgnTypeUp
                      PicBody.MousePointer = vbSizeNS
                      m_KeySizing = sKey
                      m_KeyMoving = vbNullString
                      m_MoveType = CSRptEditroMoveType.csRptEdMovUp
  
                    Case CSReportPaint2.cRptPaintRegionType.cRptPntRgnTypeLeft
                      PicBody.MousePointer = vbSizeWE
                      m_KeySizing = sKey
                      m_KeyMoving = vbNullString
                      m_MoveType = CSRptEditroMoveType.csRptEdMovLeft
  
                    Case CSReportPaint2.cRptPaintRegionType.cRptPntRgnTypeRight
                      PicBody.MousePointer = vbSizeWE
                      m_KeySizing = sKey
                      m_KeyMoving = vbNullString
                      m_MoveType = CSRptEditroMoveType.csRptEdMovRight
  
                    Case CSReportPaint2.cRptPaintRegionType.cRptPntRgnTypeLeftDown
                      PicBody.MousePointer = vbSizeNESW
                      m_KeySizing = sKey
                      m_KeyMoving = vbNullString
                      m_MoveType = CSRptEditroMoveType.csRptEdMovLeftDown
  
                    Case CSReportPaint2.cRptPaintRegionType.cRptPntRgnTypeRightUp
                      PicBody.MousePointer = vbSizeNESW
                      m_KeySizing = sKey
                      m_KeyMoving = vbNullString
                      m_MoveType = CSRptEditroMoveType.csRptEdMovRightUp
  
                    Case CSReportPaint2.cRptPaintRegionType.cRptPntRgnTypeRightDown
                      PicBody.MousePointer = vbSizeNWSE
                      m_KeySizing = sKey
                      m_KeyMoving = vbNullString
                      m_MoveType = CSRptEditroMoveType.csRptEdMovRightDown
  
                    Case CSReportPaint2.cRptPaintRegionType.cRptPntRgnTypeLeftUp
                      PicBody.MousePointer = vbSizeNWSE
                      m_KeySizing = sKey
                      m_KeyMoving = vbNullString
                      m_MoveType = CSRptEditroMoveType.csRptEdMovLeftUp
  
                    Case Else
                      m_KeySizing = vbNullString
                      m_KeyMoving = vbNullString
                  End Select
                End If
            End Select
          End If
        End With
      Else
        pSetSbPnlCtrl vbNullString
        PicBody.MousePointer = vbDefault
        m_KeySizing = vbNullString
        m_KeyMoving = vbNullString
      End If
    End If
  
    If m_Paint.PointIsInObject(x, y, sKey, RgnTp) Then
      With m_Paint.GetPaintObject(sKey)
        If .RptType = csRptPaintRptTypeControl Then
          Dim RptCtrl As CSReportDll2.cReportControl
          Set RptCtrl = m_Report.Controls.Item(.Tag)
          If Not RptCtrl Is Nothing Then
            With RptCtrl
              pSetSbPnlCtrl .Name, .ControlType, .FormulaHide.Text, .FormulaValue.Text, .HasFormulaHide, .HasFormulaValue, .Field.Name
            End With
          End If
        Else
          pSetSbPnlCtrl vbNullString
        End If
      End With
    Else
      pSetSbPnlCtrl vbNullString
    End If
  End If
End Sub

Private Sub pSetSbPnlCtrl(ByVal ctrlName As String, _
                          Optional ByVal CtrlType As csRptControlType, _
                          Optional ByVal FormulaHide As String, _
                          Optional ByVal FormulaValue As String, _
                          Optional ByVal HasFormulaHide As Boolean, _
                          Optional ByVal HasFormulaValue As Boolean, _
                          Optional ByVal FieldName As String)
                          
  Dim msg         As String
  Dim strCtlType  As String
  
  Select Case CtrlType
    Case CSReportDll2.csRptControlType.csRptCtDbImage
      strCtlType = "DbImage"
    Case CSReportDll2.csRptControlType.csRptCtField
      strCtlType = "Field"
    Case CSReportDll2.csRptControlType.csRptCtImage
      strCtlType = "Image"
    Case CSReportDll2.csRptControlType.csRptCtLabel
      strCtlType = "Label"
  End Select
  
  If ctrlName <> vbNullString Then
    msg = "Ctl:[" & ctrlName & _
          "]Tipo:[" & strCtlType & _
          "]F.Hide:[" & Mid(FormulaHide, 1, 100) & "]Activa[" & HasFormulaHide & _
          "]F.Value:[" & Mid(FormulaValue, 1, 100) & "]Activa[" & HasFormulaValue & _
          "]Field:[" & FieldName & "]"
  End If
  fMain.SetsbPnlCtrl msg
End Sub

Private Sub PicBody_MouseUp(Button As Integer, Shift As Integer, x As Single, y As Single)
  ' Para evitar rebotes
  If m_Opening Then Exit Sub

  '----------------------------------------------------
  ' MOVING
  '----------------------------------------------------
  Dim sKeySection As String
  Dim RptType As CSReportPaint2.csRptPaintRptType
  
  If m_moving Then
    If m_KeyMoving <> vbNullString Then
      Select Case m_MoveType
        Case CSRptEditroMoveType.csRptEdMovTAll
  
          If m_bMoveVertical Then
            pMoveAll c_NoMove, y
          
          ElseIf m_bMoveHorizontal Then
            pMoveAll x, c_NoMove
          
          Else
            pMoveAll x, y
          End If
          
        Case CSRptEditroMoveType.csRptEdMovTHorizontal
          
          pMoveHorizontal x
  
        Case CSRptEditroMoveType.csRptEdMovTVertical
          
          pMoveVertical x, y
          
      End Select
  
      '----------------------------------------------------
      ' SIZING
      '----------------------------------------------------
    ElseIf m_KeySizing <> vbNullString Then
      pSizingControl x, y
    End If
  
    RefreshBody
    m_moving = False
    PicRule.Refresh
  End If

  m_KeySizing = vbNullString
  m_KeyMoving = vbNullString
End Sub

Private Sub PicBody_Paint()
  On Error Resume Next

  m_Paint.PaintPicture PicBody
End Sub

Private Sub PicRule_Paint()
  On Error Resume Next
  
  Dim i As Long

  With m_Paint.PaintSections

    For i = 1 To .Count

      m_Paint.DrawRule .GetNextKeyForZOrder(i), PicRule
    Next
  End With
End Sub

Private Sub ScrHorizontal_Change()
  On Error Resume Next
  PicBody.Left = pGetLeftBody - ScrHorizontal.Value
End Sub

Private Sub ScrHorizontal_Scroll()
  On Error Resume Next
  PicBody.Left = pGetLeftBody - ScrHorizontal.Value
End Sub

Private Sub ScrVertical_Change()
  On Error Resume Next
  PicBody.Top = (ScrVertical.Value * -1) + C_TopBody
  PicRule.Top = ScrVertical.Value * -1
End Sub

Private Sub ScrVertical_Scroll()
  On Error Resume Next
  PicBody.Top = (ScrVertical.Value * -1) + C_TopBody
  PicRule.Top = ScrVertical.Value * -1
End Sub

'----------------------------------------------------------------------------------
Public Sub SetParameters()
  Dim Connect As CSConnect2.cConnect
  Set Connect = New CSConnect2.cConnect

  Dim param As CSReportDll2.cParameter

  For Each param In m_Report.Connect.Parameters

    With Connect.Parameters.Add()
      .Name = param.Name
      .Value = param.Value
    End With
  Next param

  If m_Report.Connect.DataSource = vbNullString Then

    MsgWarning ("Antes de poder configurar los parametros debe configurar la conexión")
    Exit Sub

  End If

  Connect.strConnect = m_Report.Connect.strConnect
  Connect.DataSource = m_Report.Connect.DataSource
  Connect.DataSourceType = m_Report.Connect.DataSourceType

  If Not Connect.GetDataSourceColumnsInfo(m_Report.Connect.DataSource, m_Report.Connect.DataSourceType) Then Exit Sub

  SetParametersAux Connect, m_Report.Connect
End Sub

Public Sub SetSimpleConnection()
  On Error GoTo ControlError
  
  Dim strConnect    As String
  
  Dim f As fSimpleConnect
  Set f = New fSimpleConnect
  Load f
  strConnect = m_Report.Connect.strConnect
  f.txServer.Text = GetToken("Data Source", strConnect)
  f.txDataBase.Text = GetToken("Initial Catalog", strConnect)
  f.txUser.Text = GetToken("User ID", strConnect)
  f.txPassword.Text = GetToken("Password", strConnect)
  If f.txUser.Text = vbNullString Then
    f.opNT.Value = True
  Else
    f.opSQL.Value = True
  End If
  f.Show vbModal
  
  If Not f.Ok Then GoTo ExitProc

  m_Report.Connect.strConnect = f.strConnect

  GoTo ExitProc
ControlError:
  MngError Err(), "ConfigConnection", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  Unload f
End Sub

Public Function ConfigConnection(Optional ByRef RptConnect As CSReportDll2.cReportConnect) As Boolean
  On Error GoTo ControlError

  Dim Connect As CSConnect2.cConnect
  
  Set Connect = New CSConnect2.cConnect

  If Not Connect.ShowOpenConnection() Then Exit Function

  RefreshAll

  If Not Connect.GetDataSourceColumnsInfo(Connect.DataSource, _
                                          Connect.DataSourceType) Then
    Exit Function
  End If
  
  If RptConnect Is Nothing Then
    SetParametersAux Connect, m_Report.Connect
  Else
    SetParametersAux Connect, RptConnect
  End If

  If Not GetToolBox(Me) Is Nothing Then ShowToolBox
  
  ConfigConnection = True

  GoTo ExitProc
ControlError:
  MngError Err(), "ConfigConnection", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
End Function

Public Sub SetAllConnectToMainConnect()
  On Error GoTo ControlError

  Dim Connect As CSReportDll2.cReportConnect

  With m_Report.Connect
    For Each Connect In m_Report.ConnectsAux
      Connect.strConnect = .strConnect
    Next
  End With
  
  GoTo ExitProc
ControlError:
  MngError Err(), "SetAllConnectToMainConnect", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
End Sub

Public Sub DeleteObj(Optional ByVal bDelSectionLine As Boolean)
  Dim i As Long
  Dim Sec As CSReportDll2.cReportSection
  Dim Secs As CSReportDll2.cReportSections
  Dim SecLn As CSReportDll2.cReportSectionLine
  Dim Ctrl As CSReportDll2.cReportControl
  Dim PaintObj As CSReportPaint2.cReportPaintObject

  Dim IsGroupFooter As Boolean
  Dim IsGroupHeader As Boolean
  Dim IsSecLn       As Boolean
  
  If m_KeyFocus = vbNullString Then GoTo ExitProc

  Dim Group As CSReportDll2.cReportGroup
  Dim SecG As CSReportDll2.cReportSection
  If m_Paint.PaintObjIsSection(m_KeyFocus) Then
    If m_Paint.PaintSections.Item(m_KeyFocus) Is Nothing Then GoTo ExitProc

    With m_Paint.PaintSections.Item(m_KeyFocus)
      
      ' Primero me aseguro que no sea un SectionLine
      '
      Set Sec = pGetSection(, IsSecLn, SecLn, , , IsGroupHeader, IsGroupFooter)
      
      If Not IsSecLn Then
      
        ' Me aseguro que no este en el ultimo renglon de la seccion
        '
        If bDelSectionLine Then
          
          Set Sec = pGetSection(, IsSecLn, SecLn, , True, IsGroupHeader, IsGroupFooter)
        End If
        
        If Not pCanDeleteSection(Secs, Sec, .Tag) Then GoTo ExitProc
        
      End If
    End With

    Dim what As String
    
    If IsSecLn Then
      what = "el renglón"
    Else
      what = "la seccion"
    End If

    If Not Ask("¿Confirma que desea borrar " & what & " y todos sus controles? ", vbNo) Then
      GoTo ExitProc
    End If
    
    If IsSecLn Then
    
      For Each Ctrl In SecLn.Controls
        For i = 1 To m_Paint.PaintObjects.Count
          Set PaintObj = m_Paint.PaintObjects.Item(i)
          If PaintObj.Tag = Ctrl.Key Then
            m_Paint.PaintObjects.Remove PaintObj.Key
            Exit For
          End If
        Next
      Next Ctrl
      
      SecLn.Controls.Clear
      
      ' Solo si no es el unico SectionLine
      '
      If Sec.SectionLines.Count > 1 Then
        Sec.SectionLines.Remove SecLn.Key
      End If
    
    Else

      For Each SecLn In Sec.SectionLines
        For Each Ctrl In SecLn.Controls
          For i = 1 To m_Paint.PaintObjects.Count
            Set PaintObj = m_Paint.PaintObjects.Item(i)
            If PaintObj.Tag = Ctrl.Key Then
              m_Paint.PaintObjects.Remove PaintObj.Key
              Exit For
            End If
          Next
        Next Ctrl
      Next SecLn
  
      ' Si se trata de un grupo tengo
      ' que borrar ambas secciones
  
      If IsGroupFooter Or IsGroupHeader Then
        If IsGroupHeader Then
          For Each Group In m_Report.Groups
            If Group.Header.Key = Sec.Key Then Exit For
          Next Group
          Set SecG = Group.Footer
        ElseIf IsGroupFooter Then
          For Each Group In m_Report.Groups
            If Group.Footer.Key = Sec.Key Then Exit For
          Next Group
          Set SecG = Group.Header
        End If
  
        For Each SecLn In SecG.SectionLines
          For Each Ctrl In SecLn.Controls
            For i = 1 To m_Paint.PaintObjects.Count
              Set PaintObj = m_Paint.PaintObjects.Item(i)
              If PaintObj.Tag = Ctrl.Key Then
                m_Paint.PaintObjects.Remove PaintObj.Key
                Exit For
              End If
            Next
          Next Ctrl
        Next SecLn
  
        For i = 1 To m_Paint.PaintSections.Count
          Set PaintObj = m_Paint.PaintSections.Item(i)
          If PaintObj.Tag = SecG.Key Then
            m_Paint.PaintSections.Remove PaintObj.Key
            Exit For
          End If
        Next
  
        m_Report.Groups.Remove Group.Indice
  
      Else
        Secs.Remove Sec.Key
      End If
      
    End If
    
    Dim bDeletePaintObj As Boolean
    
    bDeletePaintObj = True
    If IsSecLn Then
      bDeletePaintObj = Sec.KeyPaint <> m_KeyFocus
    End If
  
    If bDeletePaintObj Then
  
      m_Paint.PaintSections.Remove m_KeyFocus
    
    ' Si borre el ultimo SectionLine de esta seccion
    ' voy a borrar el objeto paint del ahora nuevo
    ' ultimo SectionLine y asociarle el objeto paint
    ' de la seccion
    Else
      With Sec.SectionLines
        m_Paint.PaintSections.Remove .Item(.Count).KeyPaint
        .Item(.Count).KeyPaint = Sec.KeyPaint
      End With
    End If
    
    pResetKeysFocus
    ReDim m_vSelectedKeys(0)

  Else
    Set PaintObj = m_Paint.PaintObjects.Item(m_KeyFocus)
    If PaintObj Is Nothing Then GoTo ExitProc

    If Not Ask("¿Confirma que desea borrar el control? ", vbNo) Then GoTo ExitProc
    
    For i = 1 To UBound(m_vSelectedKeys)
      Set PaintObj = m_Paint.PaintObjects.Item(m_vSelectedKeys(i))
      Set Ctrl = m_Report.Controls.Item(PaintObj.Tag)

      m_Paint.PaintObjects.Remove PaintObj.Key
      If Ctrl Is Nothing Then GoTo ExitProc
      Ctrl.SectionLine.Controls.Remove Ctrl.Key
    Next
    
    pResetKeysFocus
    ReDim m_vSelectedKeys(0)
  End If

  RefreshAll

ExitProc:
End Sub

Private Function pCanDeleteSection(ByRef Secs As CSReportDll2.cReportSections, _
                                   ByRef Sec As CSReportDll2.cReportSection, _
                                   ByVal Tag As String) As Boolean
                                   
  Dim SecAux As CSReportDll2.cReportSection
    
  Set SecAux = m_Report.Headers.Item(Tag)
  If (SecAux Is Sec Or Sec Is Nothing) And Not SecAux Is Nothing Then
    If SecAux.TypeSection = CSReportDll2.csRptTypeSection.csRptTpMainSectionHeader Then
      MsgInfo ("No se puede borrar el encabezado principal")
      GoTo ExitProc
    End If

    Set Secs = m_Report.Headers
  Else
    Set SecAux = m_Report.Footers.Item(Tag)
    If (SecAux Is Sec Or Sec Is Nothing) And Not SecAux Is Nothing Then
      If SecAux.TypeSection = CSReportDll2.csRptTypeSection.csRptTpMainSectionFooter Then
        MsgInfo ("No se puede borrar el píe de página principal")
        GoTo ExitProc
      End If

      Set Secs = m_Report.Footers
    Else

      ' Veo si es un grupo
      Set SecAux = m_Report.GroupsHeaders.Item(Tag)
      If Not ((SecAux Is Sec Or Sec Is Nothing) And Not SecAux Is Nothing) Then

        Set SecAux = m_Report.GroupsFooters.Item(Tag)
        If Not ((SecAux Is Sec Or Sec Is Nothing) And Not SecAux Is Nothing) Then
              
          ' Finalmente no se puede borrar el detalle
          MsgInfo ("No se puede borrar el detalle")
          GoTo ExitProc
        End If
      End If
    End If
  End If
  
  pCanDeleteSection = True
  
ExitProc:
  
End Function

Private Sub pResetKeysFocus()
  m_KeyFocus = vbNullString
  m_KeyMoving = vbNullString
  m_KeySizing = vbNullString
  PicBody.MousePointer = vbDefault
End Sub

Public Sub AddDBField()
  Dim sField As String
  Dim nIndex As Long
  Dim nFieldType As Long

  If Not ShowDbFields(sField, nFieldType, nIndex, Me) Then Exit Sub

  BeginDraging
  m_ControlName = vbNullString
  m_ControlType = csRptEditCtrlType.csRptEditField
  m_FieldName = sField
  m_FormulaText = vbNullString
  m_FieldIndex = nIndex
  m_FieldType = nFieldType
End Sub

Public Sub AddLabel()
  pAddLabelAux csRptEditCtrlType.csRptEditLabel
End Sub

Public Sub AddImage()
  pAddLabelAux csRptEditCtrlType.csRptEditImage
End Sub

Public Sub AddChart()
  pAddLabelAux csRptEditCtrlType.csRptEditChart
End Sub

Public Sub pAddLabelAux(ByVal ctlType As csRptEditCtrlType)
  BeginDraging
  m_ControlName = vbNullString
  m_ControlType = ctlType
  m_FieldName = vbNullString
  m_FormulaText = vbNullString
  m_FieldIndex = 0
  m_FieldType = 0
End Sub

Private Function AddControlEnd(ByVal Left As Long, ByVal Top As Long) As Boolean
  Dim Ctrl As CSReportDll2.cReportControl

  m_Draging = False

  If m_ControlType = csRptEditCtrlType.csRptEditNone Then
    AddControlEnd = True
    Exit Function
  End If

  m_DataHasChanged = True

  Dim i              As Long
  Dim OriginalLeft   As Long
  Dim OriginalTop    As Long
  Dim CopyCtrl       As CSReportDll2.cReportControl
  Dim MovedCtrl      As CSReportDll2.cReportControl
  Dim FirstCtrlLeft  As Long
  Dim OffSet         As Long
  
  If m_CopyControls Then
    
    If UBound(m_vCopyKeys) = 0 Then Exit Function
        
    OriginalLeft = Left
    OriginalTop = Top
        
    Set MovedCtrl = m_Report.Controls(m_Paint.PaintObjects(m_vCopyKeys(UBound(m_vCopyKeys))).Tag)
    FirstCtrlLeft = MovedCtrl.Label.Aspect.Left
        
    For i = UBound(m_vCopyKeys) To 1 Step -1
      
      Set CopyCtrl = m_Report.Controls(m_Paint.PaintObjects(m_vCopyKeys(i)).Tag)
                
      ' Tomo a partir del primer control y voy moviendo el left
      ' si llego al final de la pagina bajo un renglon y empiezo
      ' otra vez
      OffSet = pGetOffsetLeftFromControls(FirstCtrlLeft, CopyCtrl.Label.Aspect.Left)
      Left = OriginalLeft + OffSet
      
      If m_bCopyWithoutMoving Then
      
        Top = CopyCtrl.Label.Aspect.Top
        Left = CopyCtrl.Label.Aspect.Left
      
      End If
      
      If Left - 400 > PicBody.Width Then
        Left = OriginalLeft + (OffSet Mod OriginalLeft)
        Top = Top + 100
      End If
      
      If Top > PicBody.Height Then
        Top = PicBody.Height - 100
      End If
    
      pAddControlEndAux Left, Top, CopyCtrl
    
    Next
    m_CopyControls = False
  
  ElseIf m_CopyControlsFromOtherReport Then
  
    If fMain.ReportCopySource Is Nothing Then Exit Function
        
    OriginalLeft = Left
    OriginalTop = Top
        
    With fMain.ReportCopySource
    
      Set MovedCtrl = .Report.Controls(.Paint.PaintObjects(.vCopyKeys(.vCopyKeysCount)).Tag)
      FirstCtrlLeft = MovedCtrl.Label.Aspect.Left
      
      For i = .vCopyKeysCount To 1 Step -1
        
        Set CopyCtrl = .Report.Controls(.Paint.PaintObjects(.vCopyKeys(i)).Tag)
                      
        ' Tomo a partir del primer control y voy moviendo el left
        ' si llego al final de la pagina bajo un renglon y empiezo
        ' otra vez
        OffSet = pGetOffsetLeftFromControls(FirstCtrlLeft, CopyCtrl.Label.Aspect.Left)
        Left = OriginalLeft + OffSet
        
        If m_bCopyWithoutMoving Then
        
          Top = CopyCtrl.Label.Aspect.Top
          Left = CopyCtrl.Label.Aspect.Left
        
        End If
        
        If Left - 400 > PicBody.Width Then
          Left = OriginalLeft + (OffSet Mod OriginalLeft)
          Top = Top + 100
        End If
        
        If Top > PicBody.Height Then
          Top = PicBody.Height - 100
        End If
              
        pAddControlEndAux Left, Top, CopyCtrl
      
      Next
      
    End With
    
    m_CopyControlsFromOtherReport = False
  
  Else
    pAddControlEndAux Left, Top, Nothing
  End If

  RefreshBody

  AddControlEnd = True
End Function

Private Function pGetOffsetLeftFromControls(ByVal LeftCtrl1 As Long, ByVal LeftCtrl2 As Long)
  pGetOffsetLeftFromControls = LeftCtrl2 - LeftCtrl1
End Function

Private Function pGetOffsetTopFromControls(ByVal TopCtrl1 As Long, ByVal TopCtrl2 As Long)
  pGetOffsetTopFromControls = TopCtrl2 - TopCtrl1
End Function

Private Sub pAddControlEndAux(ByVal Left As Long, ByVal Top As Long, ByRef BaseControl As CSReportDll2.cReportControl)
  Dim Ctrl As CSReportDll2.cReportControl
  
  ' Primero agrego un control a cualquier seccion
  ' luego lo voy a ubicar donde el usuario lo deje
  With m_Report.Headers.Item(C_KEY_HEADER).SectionLines.Item(1)
    Set Ctrl = .Controls.Add
  End With

  ' Luego defino que es y le cargo la info
  m_NextNameCtrl = m_NextNameCtrl + 1
  Ctrl.Name = C_Control_Name & m_NextNameCtrl
  
  If BaseControl Is Nothing Then
    pSetNewControlProperties Ctrl
  Else
    pCopyControl BaseControl, Ctrl
  End If
  
  pSetNewControlPosition Ctrl, Left, Top
End Sub

Private Sub pCopyFont(ByRef FromFont As CSReportDll2.cReportFont, ByRef ToFont As CSReportDll2.cReportFont)
  With ToFont
    .Bold = FromFont.Bold
    .ForeColor = FromFont.ForeColor
    .Italic = FromFont.Italic
    .Name = FromFont.Name
    .Size = FromFont.Size
    .Strike = FromFont.Strike
    .Underline = FromFont.Underline
  End With
End Sub

Private Sub pCopyFontPaint(ByRef FromFont As CSReportDll2.cReportFont, _
                           ByRef ToFont As CSReportPaint2.cReportFont)
  With ToFont
    .Bold = FromFont.Bold
    .ForeColor = FromFont.ForeColor
    .Italic = FromFont.Italic
    .Name = FromFont.Name
    .Size = FromFont.Size
    .Strike = FromFont.Strike
    .Underline = FromFont.Underline
  End With
End Sub

Private Sub pCopyChart(ByRef FromChart As CSReportDll2.cReportChart, ByRef ToChart As CSReportDll2.cReportChart)
  With ToChart
    .ChartTitle = FromChart.ChartTitle
    .ChartType = FromChart.ChartType
    .Diameter = FromChart.Diameter
    .Format = FromChart.Format
    .GridLines = FromChart.GridLines
    .OutlineBars = FromChart.OutlineBars
    .ShowValues = FromChart.ShowValues
    .Thickness = FromChart.Thickness
    .Top = FromChart.Top
    .GroupFieldName = FromChart.GroupFieldName
    .GroupFieldIndex = FromChart.GroupFieldIndex
    .GroupValue = FromChart.GroupValue
    .Sort = FromChart.Sort
    
    Dim FromSerie As CSReportDll2.cReportChartSerie
    
    For Each FromSerie In FromChart.Series
      With .Series.Add(Nothing)
        .Color = FromSerie.Color
        .LabelFieldName = FromSerie.LabelFieldName
        .Color = FromSerie.LabelIndex
        .ValueFieldName = FromSerie.ValueFieldName
        .ValueIndex = FromSerie.ValueIndex
      End With
    Next
  End With
End Sub

Private Sub pCopyAspect(ByRef FromAspect As CSReportDll2.cReportAspect, ByRef ToAspect As CSReportDll2.cReportAspect)
  With ToAspect
    .Align = FromAspect.Align
    .BackColor = FromAspect.BackColor
    .BorderColor = FromAspect.BorderColor
    .BorderColor3d = FromAspect.BorderColor3d
    .BorderColor3dShadow = FromAspect.BorderColor3dShadow
    .BorderType = FromAspect.BorderType
    .BorderWidth = FromAspect.BorderWidth
    .CanGrow = FromAspect.CanGrow
    .Format = FromAspect.Format
    .Height = FromAspect.Height
    .IsAccounting = FromAspect.IsAccounting
    .Left = FromAspect.Left
    .nZOrder = FromAspect.nZOrder
    .SelectColor = FromAspect.SelectColor
    .Symbol = FromAspect.Symbol
    .Top = FromAspect.Top
    .Transparent = FromAspect.Transparent
    .Width = FromAspect.Width
    .WordWrap = FromAspect.WordWrap
    
    pCopyFont FromAspect.Font, .Font
  End With
End Sub

Private Sub pCopyAspectToPaint(ByRef FromAspect As CSReportDll2.cReportAspect, _
                               ByRef ToAspect As CSReportPaint2.cReportAspect)
  With ToAspect
    .Align = FromAspect.Align
    .BackColor = FromAspect.BackColor
    .BorderColor = FromAspect.BorderColor
    .BorderColor3d = FromAspect.BorderColor3d
    .BorderColor3dShadow = FromAspect.BorderColor3dShadow
    .BorderType = FromAspect.BorderType
    .BorderWidth = FromAspect.BorderWidth
    .CanGrow = FromAspect.CanGrow
    .Format = FromAspect.Format
    .Height = FromAspect.Height
    .IsAccounting = FromAspect.IsAccounting
    .Left = FromAspect.Left
    .nZOrder = FromAspect.nZOrder
    .SelectColor = FromAspect.SelectColor
    .Symbol = FromAspect.Symbol
    .Top = FromAspect.Top
    .Transparent = FromAspect.Transparent
    .Width = FromAspect.Width
    .WordWrap = FromAspect.WordWrap
    
    pCopyFontPaint FromAspect.Font, .Font
  End With
End Sub

Private Sub pCopyControl(ByRef FromCtrl As CSReportDll2.cReportControl, ByRef ToCtrl As CSReportDll2.cReportControl)
  With ToCtrl
    .ControlType = FromCtrl.ControlType
    
    With .Field
      .FieldType = FromCtrl.Field.FieldType
      .Index = FromCtrl.Field.Index
      .Name = FromCtrl.Field.Name
    End With
    
    .FormulaHide.Name = FromCtrl.FormulaHide.Name
    .FormulaHide.Text = FromCtrl.FormulaHide.Text
    .FormulaValue.Name = FromCtrl.FormulaValue.Name
    .FormulaValue.Text = FromCtrl.FormulaValue.Text
    
    .HasFormulaHide = FromCtrl.HasFormulaHide
    .HasFormulaValue = FromCtrl.HasFormulaValue
    
    pCopyAspect FromCtrl.Image.Aspect, .Image.Aspect
    
    With .Label
      pCopyAspect FromCtrl.Label.Aspect, .Aspect
      .CanGrow = FromCtrl.Label.CanGrow
      .Text = FromCtrl.Label.Text
    End With
    
    pCopyAspect FromCtrl.Line.Aspect, .Line.Aspect
    
    pCopyChart FromCtrl.Chart, .Chart
  End With
End Sub

Private Sub pSetNewControlProperties(ByRef Ctrl As CSReportDll2.cReportControl)
  Ctrl.Label.Aspect.Align = vbLeftJustify

  Select Case m_ControlType
    Case csRptEditCtrlType.csRptEditField
      Ctrl.ControlType = CSReportDll2.csRptControlType.csRptCtField
      Ctrl.Label.Text = m_FieldName
      With Ctrl.Field
        .Index = m_FieldIndex
        .Name = m_FieldName
        .FieldType = m_FieldType
      End With

      If IsNumberField(m_FieldType) Then
        With Ctrl.Label.Aspect
          .Align = vbRightJustify
          .Format = "#0.00;-#0.00"
        End With
      End If

    Case csRptEditCtrlType.csRptEditFormula
      With Ctrl
        .ControlType = CSReportDll2.csRptControlType.csRptCtLabel
        .FormulaValue.Text = m_FormulaText & "(" & m_ControlName & ")"
        .HasFormulaValue = True
        .Label.Aspect.Format = "0.00;-0.00"
        .Label.Aspect.Font.Bold = True
        .Label.Text = .FormulaValue.Text
        .Label.Aspect.Align = vbRightJustify
      End With

    Case csRptEditCtrlType.csRptEditLabel
      Ctrl.ControlType = CSReportDll2.csRptControlType.csRptCtLabel
      Ctrl.Label.Text = m_FieldName
      Ctrl.Label.Aspect.Font.Bold = True
  
    Case csRptEditCtrlType.csRptEditImage
      Ctrl.ControlType = CSReportDll2.csRptControlType.csRptCtImage
      Ctrl.Label.Text = m_FieldName
  
    Case csRptEditCtrlType.csRptEditChart
      Ctrl.ControlType = CSReportDll2.csRptControlType.csRptCtChart
      Ctrl.Label.Text = m_FieldName
  End Select

  Const ctrl_height As Long = 285
  Const ctrl_width As Long = 2000
  
  With Ctrl.Label.Aspect
    .Width = ctrl_width
    .Height = ctrl_height
    .Transparent = True
  End With
End Sub

Private Sub pSetNewControlPosition(ByRef Ctrl As CSReportDll2.cReportControl, ByVal Left As Long, ByVal Top As Long)
  With Ctrl.Label.Aspect
    .Left = Left
    .Top = Top
  End With

  Dim PaintObj As CSReportPaint2.cReportPaintObject
  Dim PaintType As CSReportPaint2.cRptPaintObjType
  
  If Ctrl.ControlType = CSReportDll2.csRptCtImage Or _
     Ctrl.ControlType = CSReportDll2.csRptCtChart Then
    PaintType = CSReportPaint2.csRptPaintObjImage
  Else
    PaintType = CSReportPaint2.csRptPaintObjBox
  End If
  
  Set PaintObj = m_Paint.GetNewObject(PaintType)

  Dim Aspect As CSReportDll2.cReportAspect
  Set Aspect = Ctrl.Label.Aspect

  With PaintObj
    
    pCopyAspectToPaint Aspect, .Aspect
    
    With .Aspect
      .Left = Left
      .Top = Top
    End With

    .Text = Ctrl.Label.Text
    
    .RptType = CSReportPaint2.csRptPaintRptType.csRptPaintRptTypeControl
    
    .Tag = Ctrl.Key
    Ctrl.KeyPaint = .Key

    ' Ubico el control en la seccion
    MoveControl .Key

    m_Paint.DrawObject .Key, PicBody.hDC, PicBody

  End With
End Sub


Public Sub AddGroup()
  mPublic.ShowGroupProperties Nothing, Me
  RefreshAll
End Sub

Private Function pGetGroup(ByVal Key As String) As CSReportDll2.cReportGroup
  Dim Group As CSReportDll2.cReportGroup
  
  For Each Group In m_Report.Groups
    If Group.Header.Key = Key Then Exit For
    If Group.Footer.Key = Key Then Exit For
  Next
  
  Set pGetGroup = Group
End Function

Public Sub AddSectionLine()
  Dim Sec      As CSReportDll2.cReportSection
  Dim IsGroup  As Boolean
  Dim PaintObj As CSReportPaint2.cReportPaintObject

  Set Sec = pGetSection(IsGroup, , , PaintObj)
  
  If Sec Is Nothing Then Exit Sub
  
  Select Case Sec.TypeSection
  
    ' En los Footers se agrega arriba, es decir
    ' que el primer section lines es el ultimo
    '
    Case CSReportDll2.csRptTypeSection.csRptTpScFooter, _
         CSReportDll2.csRptTypeSection.csRptTpMainSectionFooter
  
      With Sec.SectionLines.Add(, , 1).Aspect
        .Height = C_Height_New_Section
        .Width = Sec.Aspect.Width
        
        ' Cuando agrego una seccion le indico que su top es igual
        ' a la seccion anterior menos su alto
        '
        .Top = Sec.SectionLines.Item(2).Aspect.Top - C_Height_New_Section
      End With
    
    Case Else
  
      ' Debido a que el alto de las secciones es calculado
      ' en pChangeHeightSection que es llamada por MoveSection
      ' que a su vez es llamada por pAddSectionLinesAux,
      ' y en dicho calculo, se asigna a la ultima SectionLine
      ' lo que queda de restar al alto de la Seccion la suma de
      ' todas las SectionLines menos la ultima, es decir que si estoy
      ' agregando una SectionLine nueva, si no modifico el alto de
      ' la seccion, la ultima SectionLine se va a quedar sin espacio
      ' y tendra un alto de cero (en realidad de 20 ya que la
      ' propiedad Height de los Aspect no acepta menos de 20).
      '
      ' Entonces para evitar esto, es que agrando el alto de
      ' la seccion, pero al hacer esto, me falla la funcion
      ' MoveSection que calcula cual es la diferencia entre
      ' el alto de la seccion y el nuevo alto que resulta de
      ' mover la seccion (esto es por que en realidad no estamos
      ' moviendo nada, sino que simulamos un mover hacia abajo
      ' cuando agregamos la seccion).
      '
      ' Para evitar este quilombo, es que le agregamos esta variable
      ' que indica que al OffSet resultante del alto original
      ' de la seccion, se le debe adicionar el alto del nuevo renglon
      '
      m_NewSecLineOffSet = C_Height_New_Section
  
      With Sec.SectionLines.Add().Aspect
        .Height = C_Height_New_Section
        .Width = Sec.Aspect.Width
      End With
  
  End Select
  
  With Sec.Aspect
    .Height = .Height + C_Height_New_Section
  End With
  
  pAddSectionLinesAux Sec, PaintObj

  ' Siempre reseteamos esta variable auxiliar
  '
  m_NewSecLineOffSet = 0
End Sub

Private Sub pAddSectionLinesAux(ByRef Sec As CSReportDll2.cReportSection, _
                                ByRef PaintObj As CSReportPaint2.cReportPaintObject)
  Dim MaxBottom As Long
  Dim MinBottom As Long
  Dim TypeSecLn As csESectionLineTypes
  Dim Index     As Long
  
  Dim y As Long
  
  Select Case Sec.TypeSection
    Case CSReportDll2.csRptTypeSection.csRptTpScHeader, _
         CSReportDll2.csRptTypeSection.csRptTpMainSectionHeader
         
      pMoveHeader Sec.Key, MinBottom, MaxBottom, False
      With Sec.Aspect
        y = .Height + .Top
      End With
      TypeSecLn = C_KEY_SECLN_HEADER
      
      Index = Sec.SectionLines.Count - 1
      
    Case CSReportDll2.csRptTypeSection.csRptTpScDetail, _
         CSReportDll2.csRptTypeSection.csRptTpMainSectionDetail
         
      pMoveDetails Sec.Key, MinBottom, MaxBottom, False
      With Sec.Aspect
        y = .Height + .Top
      End With
      TypeSecLn = C_KEY_SECLN_DETAIL
      
      Index = Sec.SectionLines.Count - 1
      
    Case CSReportDll2.csRptTypeSection.csRptTpGroupHeader
    
      pMoveGroupHeader Sec.Key, MinBottom, MaxBottom, False
      With Sec.Aspect
        y = .Height + .Top
      End With
      TypeSecLn = C_KEY_SECLN_GROUPH
      
      Index = Sec.SectionLines.Count - 1
      
    Case CSReportDll2.csRptTypeSection.csRptTpGroupFooter
    
      pMoveGroupFooter Sec.Key, MinBottom, MaxBottom, False
      With Sec.Aspect
        y = .Height + .Top
      End With
      TypeSecLn = C_KEY_SECLN_GROUPF
      
      Index = Sec.SectionLines.Count - 1
      
    Case CSReportDll2.csRptTypeSection.csRptTpScFooter, _
         CSReportDll2.csRptTypeSection.csRptTpMainSectionFooter
         
      With Sec.Aspect
        .Top = .Top - C_Height_New_Section
      End With
      
      pMoveFooter Sec.Key, MinBottom, MaxBottom, False
      m_offY = 0
      With Sec.Aspect
        y = .Height + .Top - m_OffSet - C_Height_Bar_Section
      End With
      TypeSecLn = C_KEY_SECLN_FOOTER
      
      Index = 1
      
  End Select
  
  ' Le agrego un objeto de dibujo al sectionline anteultimo
  ' esto es asi por que el ultimo sectionline usa el objeto
  ' de dibujo de la seccion
  With Sec.SectionLines(Index)
    .KeyPaint = PaintSection(.Aspect, .Key, _
                             Sec.TypeSection, _
                             C_SectionLine & Sec.SectionLines.Count - 1, _
                             True)
    With m_Paint.PaintSections.Item(.KeyPaint)
      .RptType = TypeSecLn
      .RptKeySec = Sec.Key
    End With
  End With
  
  With m_Paint.PaintSections.Item(Sec.KeyPaint)
    .TextLine = C_SectionLine & Sec.SectionLines.Count
  End With
  
  MoveSection PaintObj, _
              0, _
              y, _
              MinBottom, _
              MaxBottom, _
              Sec, False

  RefreshBody
  PicRule.Refresh
End Sub

Public Sub AddSection(ByVal TypeSection As CSReportDll2.csRptTypeSection)

  If Visible = False Then Exit Sub

  Dim RptSection As CSReportDll2.cReportSection
  Dim TopSec As CSReportDll2.cReportSection
  
  Dim MaxBottom As Long
  Dim MinBottom As Long
  Dim PaintObj  As CSReportPaint2.cReportPaintObject
  Dim y         As Single
  
  Select Case TypeSection
    Case CSReportDll2.csRptTypeSection.csRptTpScHeader
      With m_Report.Headers
        Set RptSection = .Add()

        RptSection.Name = "H_" & RptSection.Indice

        With .Item(.Count - 1).Aspect
          RptSection.Aspect.Width = .Width
          RptSection.Aspect.Height = 0
          RptSection.Aspect.Top = .Top + .Height
        End With
      End With

      RptSection.KeyPaint = PaintSection(RptSection.Aspect, _
                                         RptSection.Key, _
                                         CSReportPaint2.csRptPaintRptType.csRptPaintRptTypeSectionHeader, _
                                         RptSection.Name, _
                                         False)

      With RptSection.Aspect
        MoveSection m_Paint.GetPaintObject(RptSection.KeyPaint), _
                    0, _
                    .Top, _
                    .Top + C_Height_New_Section, _
                    .Top + RptSection.Aspect.Height, _
                    RptSection, True
      End With

    Case CSReportDll2.csRptTypeSection.csRptTpScDetail

    Case CSReportDll2.csRptTypeSection.csRptTpGroupHeader

      With m_Report.GroupsHeaders
        Set RptSection = .Item(.Count)

        RptSection.Name = "GH_" & RptSection.Indice

        ' Si es el primer grupo linda con
        ' el ultimo header
        If .Count = 1 Then

          Set TopSec = m_Report.Headers.Item(m_Report.Headers.Count)

          ' Sino linda con el count -1
        Else
          Set TopSec = .Item(.Count - 1)
        End If

        With TopSec.Aspect
          RptSection.Aspect.Width = .Width
          RptSection.Aspect.Height = 0
          RptSection.Aspect.Top = .Top + .Height
        End With
        
        
        RptSection.KeyPaint = PaintSection(RptSection.Aspect, _
                                           RptSection.Key, _
                                           CSReportPaint2.csRptPaintRptType.csRptPaintRptTypeGroupSectionHeader, _
                                           RptSection.Name, _
                                           False)

        With RptSection.Aspect
          MoveSection m_Paint.GetPaintObject(RptSection.KeyPaint), _
                      0, _
                      .Top + C_Height_New_Section, _
                      .Top, _
                      .Top + C_Height_New_Section, _
                      RptSection, True
        End With
      End With


    Case CSReportDll2.csRptTypeSection.csRptTpGroupFooter

      With m_Report.GroupsFooters
        Set RptSection = .Item(1)

        RptSection.Name = "GF_" & RptSection.Indice

        ' Todos los Footers de los grupos lindan con
        ' el detail al ser agregados

        Set TopSec = m_Report.Details.Item(m_Report.Details.Count)

        With TopSec.Aspect
          RptSection.Aspect.Width = .Width
          RptSection.Aspect.Height = C_Height_New_Section
          RptSection.Aspect.Top = .Top + .Height
        End With
        
        RptSection.KeyPaint = PaintSection(RptSection.Aspect, _
                                           RptSection.Key, _
                                           CSReportPaint2.csRptPaintRptType.csRptPaintRptTypeGroupSectionFooter, _
                                           RptSection.Name, _
                                           False)
        
        Set PaintObj = m_Paint.GetPaintObject(RptSection.KeyPaint)
        
        pMoveGroupFooter RptSection.Key, MinBottom, MaxBottom, False
        m_offY = 0

        With RptSection.Aspect
          y = .Height + .Top - C_Height_Bar_Section
        End With

        MoveSection PaintObj, _
                    0, _
                    y, _
                    MinBottom, _
                    MaxBottom, _
                    RptSection, True
      End With


    Case CSReportDll2.csRptTypeSection.csRptTpScFooter
      With m_Report.Footers
        
        ' Los footers se agregan al principio de la coleccion
        ' asi queda uno sobre el otro
        Set RptSection = .Add(, , 1)

        RptSection.Name = "F_" & RptSection.Indice

        With .Item(2).Aspect
          RptSection.Aspect.Width = .Width
          RptSection.Aspect.Height = C_Height_New_Section
          RptSection.Aspect.Top = .Top
        End With
      End With

      RptSection.KeyPaint = PaintSection(RptSection.Aspect, _
                                         RptSection.Key, _
                                         CSReportPaint2.csRptPaintRptType.csRptPaintRptTypeSectionFooter, _
                                         RptSection.Name, _
                                         False)
      
      Set PaintObj = m_Paint.GetPaintObject(RptSection.KeyPaint)

      pMoveFooter RptSection.Key, MinBottom, MaxBottom, False
      m_offY = 0
      
      With RptSection.Aspect
        y = .Height + .Top - m_OffSet - C_Height_Bar_Section
      End With
      
      MoveSection PaintObj, _
                  0, _
                  y, _
                  MinBottom, _
                  MaxBottom, _
                  RptSection, True
  End Select

  ' Cuando agrego una seccion siempre tiene
  ' un SectionLine y debo actualizar su ancho
  '
  With RptSection.SectionLines(1).Aspect
    .Width = RptSection.Aspect.Width
  End With

  RefreshBody
  PicRule.Refresh
End Sub

Public Sub BringToFront()
  m_Paint.PaintObjects.ZOrder m_KeyObj
  RefreshBody
  m_DataHasChanged = True
End Sub

Public Sub SendToBack()
  m_Paint.PaintObjects.SendToBack m_KeyObj
  RefreshBody
  m_DataHasChanged = True
End Sub

Public Sub Preview()
  m_Report.LaunchInfo.Action = CSReportDll2.csRptLaunchAction.csRptLaunchPreview
  LaunchReport
End Sub

Public Sub PrintReport()
  m_Report.LaunchInfo.Action = CSReportDll2.csRptLaunchAction.csRptLaunchPrinter
  LaunchReport
End Sub

Private Sub LaunchReport()
  On Error GoTo ControlError

  Dim Mouse As New CSKernelClient2.cMouseWait
  SetZOrder
  ShowProgressDlg
  
  Set m_Report.LaunchInfo.Printer.PaperInfo = m_Report.PaperInfo
  Set m_Report.LaunchInfo.ObjPaint = New CSReportPaint2.cReportPrint
  m_Report.LaunchInfo.hwnd = Me.hwnd
  m_Report.LaunchInfo.ShowPrintersDialog = True
  m_Report.Launch

  GoTo ExitProc
ControlError:
  MngError Err(), "LaunchReport", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
  CloseProgressDlg
End Sub

Public Function SaveDocument(Optional ByVal SaveAs As Boolean = False) As Boolean
  On Error GoTo ControlError

  Dim Mouse As New CSKernelClient2.cMouseWait
  Dim IsNew As Boolean

  IsNew = m_Report.Name = vbNullString

  If IsNew Then
    m_Report.Name = Me.Caption
  End If

  If SaveAs Then
    IsNew = True
  End If

  SetZOrder
  
  pValidateSectionAspect

  If Not m_Report.Save(fMain.cmDialog, IsNew) Then GoTo ExitProc
  ReLoadReport
  SaveDocument = True

  GoTo ExitProc
ControlError:
  MngError Err, "SaveDocument", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Sub SetZOrder()
  Dim Ctrl As CSReportDll2.cReportControl

  For Each Ctrl In m_Report.Controls
    Ctrl.Label.Aspect.nZOrder = m_Paint.PaintObjects.GetZOrderForKey(Ctrl.KeyPaint)
  Next Ctrl
End Sub

Public Sub NewReport(ByRef Report As CSReportDll2.cReport)
  
  If Not Report Is Nothing Then
    
    Set m_Report = Report
    ReLoadReport
    pValidateSectionAspect
    ReLoadReport
    
  Else
    
    m_Paint.CreatePicture PicBody
    PicRule.Refresh
  
  End If

  Me.Show

  DoEvents

  SetDocActive Me
End Sub

Public Function OpenDocument(Optional ByVal FileName As String = vbNullString) As Boolean
  Dim Mouse As New CSKernelClient2.cMouseWait

  ' Para evitar rebotes del mouse
  m_Opening = True

  If FileName = vbNullString Then

    pSetInitDir
    
    If Not m_Report.Load(fMain.cmDialog) Then

      If m_Report.Name <> vbNullString Then GoTo Done

      Unload Me
      Exit Function
    End If

  Else

    If Not m_Report.LoadSilent(FileName) Then

      Unload Me
      Exit Function
    End If
  End If

  ReLoadReport

Done:
  
  With fMain.cmDialog
    Dim FileEx As CSKernelFile.cFileEx
    Set FileEx = New CSKernelFile.cFileEx
    .InitDir = FileEx.FileGetPath(.FileName)
  End With

  Me.Show

  OpenDocument = True

  DoEvents

  SetDocActive Me

  m_Opening = False
End Function

Public Function SaveChanges() As Boolean
  Dim Rslt As csAskEditResult

  If m_DataHasChanged Then

    Rslt = AskEdit("¿Desea guardar los cambios a " & Me.Caption & "?", "CSReportEditor")

    Select Case Rslt
      Case csAskEditResult.csAskRsltYes
        If Not SaveDocument() Then Exit Function
      Case csAskEditResult.csAskRsltCancel
        Exit Function
    End Select
  End If

  SaveChanges = True
  m_DataHasChanged = False
End Function

Private Function AskEdit(ByVal msg As String, Optional ByVal Title As String = vbNullString) As csAskEditResult
  Dim Rslt As Long
  Rslt = MsgBox(msg, vbYesNoCancel + vbDefaultButton3 + vbQuestion, Title)

  Select Case Rslt
    Case vbYes
      AskEdit = csAskEditResult.csAskRsltYes
    Case vbNo
      AskEdit = csAskEditResult.csAskRsltNo
    Case Else
      AskEdit = csAskEditResult.csAskRsltCancel
  End Select
End Function

Private Sub m_fProperties_ShowHelpDbField(ByRef Cancel As Boolean)
  Dim nIndex As Long
  Dim nFieldType As Long
  Dim sField As String

  With m_fProperties
    sField = .TxDbField.Text
    nFieldType = .FieldType
    nIndex = .Index
    
    Cancel = Not ShowDbFields(sField, nFieldType, nIndex, Me)
    If Cancel Then Exit Sub

    .TxDbField.Text = sField
    .FieldType = nFieldType
    .Index = nIndex
    .txText.Text = sField
  End With
End Sub

Public Sub ShowGroupProperties()
  Dim Sec     As CSReportDll2.cReportSection
  Dim IsGroup As Boolean
  Dim Group   As CSReportDll2.cReportGroup
  
  Set Sec = pGetSection(IsGroup)
  
  If Sec Is Nothing Then Exit Sub
  
  If Not IsGroup Then Exit Sub
    
  For Each Group In m_Report.Groups
    If Group.Header.Key = Sec.Key Then Exit For
    If Group.Footer.Key = Sec.Key Then Exit For
  Next Group
  
  mPublic.ShowGroupProperties Group, Me

  RefreshAll
End Sub

Public Sub MoveGroup()
  Dim Sec     As CSReportDll2.cReportSection
  Dim IsGroup As Boolean
  Dim Group   As CSReportDll2.cReportGroup
  
  Set Sec = pGetSection(IsGroup)
  
  If Sec Is Nothing Then Exit Sub
  
  If Not IsGroup Then Exit Sub
    
  For Each Group In m_Report.Groups
    If Group.Header.Key = Sec.Key Then Exit For
    If Group.Footer.Key = Sec.Key Then Exit For
  Next Group
  
  mPublic.MoveGroup Group, Me
  
  ReDim m_vSelectedKeys(0)
  RefreshReport
End Sub

Public Sub ShowSectionProperties()
  Dim Sec As CSReportDll2.cReportSection
  Dim IsGroup As Boolean
  
  Set Sec = pGetSection(IsGroup)
  
  If Sec Is Nothing Then Exit Sub

  pShowSecProperties Sec

  RefreshAll
End Sub

Public Sub ShowSecLnProperties()
  Dim Sec        As CSReportDll2.cReportSection
  Dim IsSecLn    As Boolean
  Dim SecLn      As CSReportDll2.cReportSectionLine
  
  Set Sec = pGetSection(, IsSecLn, SecLn, , True)
  
  If Sec Is Nothing Then Exit Sub
  If SecLn Is Nothing Then Exit Sub
  If Not IsSecLn Then Exit Sub

  pShowSecProperties SecLn, Sec.Name & ": renglón " & SecLn.Indice

  RefreshAll
End Sub

Private Sub pShowSecProperties(ByRef Sec As Object, Optional ByVal SecLnName As String)
  On Error GoTo ControlError
  
  m_ShowingProperties = True
  
  If m_fSecProperties Is Nothing Then Set m_fSecProperties = New fSecProperties
  
  With Sec
    m_fSecProperties.chkFormulaHide.Value = IIf(.HasFormulaHide, vbChecked, vbUnchecked)
    m_fSecProperties.FormulaHide = .FormulaHide.Text
    If TypeOf Sec Is CSReportDll2.cReportSection Then m_fSecProperties.TxName.Text = .Name
  End With
  
  With m_fSecProperties
    If TypeOf Sec Is CSReportDll2.cReportSectionLine Then
      .LbControl.Caption = SecLnName
      .lbSecLn.Caption = "Propiedades del renglón:"
    Else
      .LbControl.Caption = Sec.Name
    End If
  End With
  
  m_fSecProperties.Show vbModal
  
  If m_fSecProperties.Ok Then
    With Sec
      If m_fSecProperties.SetFormulaHideChanged Then .HasFormulaHide = m_fSecProperties.chkFormulaHide.Value = vbChecked
      If m_fSecProperties.FormulaHideChanged Then .FormulaHide.Text = m_fSecProperties.FormulaHide
      If TypeOf Sec Is CSReportDll2.cReportSection Then .Name = m_fSecProperties.TxName.Text
    End With
  End If
  
  GoTo ExitProc
ControlError:
  MngError Err(), "pShowSecProperties", C_Module, vbNullString
ExitProc:
  Unload m_fSecProperties
  m_ShowingProperties = False
  Set m_fSecProperties = Nothing
End Sub

' ReturnSecLn indica que el que llama quiere obtener la
' sectionline asociada con el separador de seccion, recuerden
' que el ultimo sectionline de cada seccion no tiene su propio
' separador de seccion sino que lo comparte con la seccion.
Private Function pGetSection(Optional ByRef IsGroup As Boolean, _
                             Optional ByRef IsSecLn As Boolean, _
                             Optional ByRef SecLn As CSReportDll2.cReportSectionLine, _
                             Optional ByRef PaintObj As CSReportPaint2.cReportPaintObject, _
                             Optional ByVal ReturnSecLn As Boolean, _
                             Optional ByRef IsGroupHeader As Boolean, _
                             Optional ByRef IsGroupFooter As Boolean) As CSReportDll2.cReportSection
                             
  Dim Sec As CSReportDll2.cReportSection
  
  IsGroup = False
  IsGroupFooter = False
  IsGroupHeader = False
  IsSecLn = False
  Set SecLn = Nothing
  
  If m_KeyFocus = vbNullString Then Exit Function

  ' Obtengo la seccion y muestro sus propiedades
  If Not m_Paint.PaintObjIsSection(m_KeyFocus) Then Exit Function

  Set PaintObj = m_Paint.PaintSections.Item(m_KeyFocus)

  ' Nada que hacer
  If PaintObj Is Nothing Then Exit Function

  With PaintObj
    Set Sec = m_Report.Headers.Item(.Tag)
    If Not Sec Is Nothing Then

      ' Es un Header
    Else
      Set Sec = m_Report.Footers.Item(.Tag)
      If Not Sec Is Nothing Then

        ' Es un Footer
      Else

        ' Veo si es un grupo
        Set Sec = m_Report.GroupsHeaders.Item(.Tag)
        If Not Sec Is Nothing Then

          ' Es un grupo
          IsGroup = True
          IsGroupHeader = True

        Else
          Set Sec = m_Report.GroupsFooters.Item(.Tag)
          If Not Sec Is Nothing Then

            ' Es un grupo
            IsGroup = True
            IsGroupFooter = True

          Else
            ' Veo si es el detalle
            Set Sec = m_Report.Details.Item(.Tag)
            If Not Sec Is Nothing Then
              
              ' Es el detalle
              
            ' Es un Renglon
            Else
              IsSecLn = True
              Select Case .RptType
                Case C_KEY_SECLN_HEADER
                  Set Sec = m_Report.Headers.Item(.RptKeySec)
                Case C_KEY_SECLN_DETAIL
                  Set Sec = m_Report.Details.Item(.RptKeySec)
                Case C_KEY_SECLN_FOOTER
                  Set Sec = m_Report.Footers.Item(.RptKeySec)
                Case C_KEY_SECLN_GROUPH
                  Set Sec = m_Report.GroupsHeaders.Item(.RptKeySec)
                Case C_KEY_SECLN_GROUPF
                  Set Sec = m_Report.GroupsFooters.Item(.RptKeySec)
              End Select
              Set SecLn = Sec.SectionLines(.Tag)
            End If
          End If
        End If
      End If
    End If
  End With
  
  ' Si quieren un sectionline y el separador le pertenece
  ' a una seccion (IsSecLn = false), entonces devuelvo el
  ' ultimo sectionline de la seccion vinculada al separador
  If ReturnSecLn And Not IsSecLn Then
    Set SecLn = Sec.SectionLines(Sec.SectionLines.Count)
    IsSecLn = True
  End If
  
  Set pGetSection = Sec
End Function

Public Sub ShowProperties()
  If m_KeyFocus = vbNullString Then Exit Sub
  
  Dim Mouse As cMouseWait
  Set Mouse = New cMouseWait
  
  If m_Paint.PaintObjIsSection(m_KeyFocus) Then
    ShowSectionProperties
  Else
    m_KeyObj = m_KeyFocus
    pShowCtrlProperties
  End If

  RefreshAll
End Sub

Private Sub pShowCtrlProperties()
  On Error GoTo ControlError

  Dim sText         As String
  Dim PaintObject   As CSReportPaint2.cReportPaintObject
  Dim RptCtrl       As CSReportDll2.cReportControl
  Dim bMultiSelect  As Boolean
  Dim i             As Long
  Dim Image         As CSReportDll2.cReportImage
  
  m_ShowingProperties = True

  If m_fProperties Is Nothing Then Set m_fProperties = New fProperties

  Set PaintObject = m_Paint.GetPaintObject(m_KeyObj)
  If PaintObject Is Nothing Then GoTo ExitProc

  With PaintObject
    m_fProperties.txText.Text = .Text
    Set RptCtrl = m_Report.Controls.Item(.Tag)
  End With

  With RptCtrl

    If .ControlType <> CSReportDll2.csRptControlType.csRptCtImage Then
      m_fProperties.HideTabImage
    End If
    
    If .ControlType <> CSReportDll2.csRptControlType.csRptCtChart Then
      m_fProperties.HideTabChart
    Else
    
      ListSetListIndexForId m_fProperties.cbType, .Chart.ChartType
      ListSetListIndexForId m_fProperties.cbFormatType, .Chart.Format
      ListSetListIndexForId m_fProperties.cbChartSize, .Chart.Diameter
      ListSetListIndexForId m_fProperties.cbChartThickness, .Chart.Thickness
      ListSetListIndexForId m_fProperties.cbLinesType, .Chart.GridLines
      
      m_fProperties.txChartTop.Text = .Chart.Top
      
      m_fProperties.TxDbFieldGroupValue.Text = .Chart.GroupFieldName
      m_fProperties.ChartGroupIndex = .Chart.GroupFieldIndex
      m_fProperties.txChartGroupValue.Text = .Chart.GroupValue
      
      If .Chart.OutlineBars Then
        m_fProperties.opLinesYes.Value = True
      Else
        m_fProperties.opLinesNo.Value = True
      End If
      
      If .Chart.ShowValues Then
        m_fProperties.opValuesYes.Value = True
      Else
        m_fProperties.opValuesNo.Value = True
      End If
      
      m_fProperties.chkSort.Value = IIf(.Chart.Sort, vbChecked, vbUnchecked)
      
      m_fProperties.txText.Text = .Chart.ChartTitle
    
      If .Chart.Series.Count Then
        m_fProperties.TxDbFieldLbl1.Text = .Chart.Series(1).LabelFieldName
        m_fProperties.TxDbFieldVal1.Text = .Chart.Series(1).ValueFieldName
      
        ' Decidi no implementarlo ya que no lo encontre util
        '
        'm_fProperties.ChartFieldType(1) =
        'm_fProperties.ChartFieldType(2) =
        m_fProperties.ChartIndex(0) = .Chart.Series(1).LabelIndex
        m_fProperties.ChartIndex(1) = .Chart.Series(1).ValueIndex
        
        ListSetListIndexForId m_fProperties.cbColorSerie1, .Chart.Series(1).Color
      
        If .Chart.Series.Count > 1 Then
          m_fProperties.TxDbFieldLbl2.Text = .Chart.Series(2).LabelFieldName
          m_fProperties.TxDbFieldVal2.Text = .Chart.Series(2).ValueFieldName
        
          ' Decidi no implementarlo ya que no lo encontre util
          '
          'm_fProperties.ChartFieldType(2) =
          'm_fProperties.ChartFieldType(3) =
          m_fProperties.ChartIndex(2) = .Chart.Series(2).LabelIndex
          m_fProperties.ChartIndex(3) = .Chart.Series(2).ValueIndex
          
          ListSetListIndexForId m_fProperties.cbColorSerie2, .Chart.Series(2).Color
        End If
      End If
    End If
    
    If .ControlType = CSReportDll2.csRptControlType.csRptCtField _
       Or .ControlType = CSReportDll2.csRptControlType.csRptCtDbImage Then
      m_fProperties.txText.Enabled = False
      With .Field
        m_fProperties.txText.Text = .Name
        m_fProperties.TxDbField.Text = .Name
        m_fProperties.FieldType = .FieldType
        m_fProperties.Index = .Index
      End With
    Else
      m_fProperties.HideTabField
      m_fProperties.txText.Enabled = True
    End If

    m_fProperties.TxName.Text = .Name
    m_fProperties.LbControl.Caption = .Name
    m_fProperties.chkFormulaHide.Value = IIf(.HasFormulaHide, vbChecked, vbUnchecked)
    m_fProperties.chkFormulaValue.Value = IIf(.HasFormulaValue, vbChecked, vbUnchecked)
    
    m_fProperties.txExportColIdx.Text = .ExportColIdx
    m_fProperties.chkIsFreeCtrl = IIf(.IsFreeCtrl, vbChecked, vbUnchecked)

    m_fProperties.txTag.Text = .Tag
    m_fProperties.FormulaHide = .FormulaHide.Text
    m_fProperties.FormulaValue = .FormulaValue.Text
    m_fProperties.txIdxGroup.csValue = .FormulaValue.idxGroup
    m_fProperties.opBeforePrint.Value = .FormulaValue.WhenEval = csRptEvalPre
    m_fProperties.opAfterPrint.Value = .FormulaValue.WhenEval = csRptEvalPost

    With .Label.Aspect
      m_fProperties.chkCanGrow.Value = IIf(.CanGrow, vbChecked, vbUnchecked)
      m_fProperties.TxFormat.Text = .Format
      m_fProperties.txSymbol.Text = .Symbol
      m_fProperties.IsAccounting = .IsAccounting
      m_fProperties.chkWordWrap.Value = IIf(.WordWrap, vbChecked, vbUnchecked)
      
      ListSetListIndexForId m_fProperties.cbAlign, .Align
      
      m_fProperties.txBorderColor.Text = .BorderColor
      m_fProperties.txBorder3D.Text = .BorderColor3d
      m_fProperties.txBorderShadow.Text = .BorderColor3dShadow
      m_fProperties.chkBorderRounded.Value = IIf(.BorderRounded, vbChecked, vbUnchecked)
      m_fProperties.txBorderWidth.Text = .BorderWidth
      
      ListSetListIndexForId m_fProperties.cbBorderType, .BorderType

      With .Font
        m_fProperties.txFont.Text = .Name
        m_fProperties.TxForeColor.Text = .ForeColor
        m_fProperties.TxFontSize.Text = .Size
        m_fProperties.chkFontBold.Value = IIf(.Bold, vbChecked, vbUnchecked)
        m_fProperties.chkFontItalic.Value = IIf(.Italic, vbChecked, vbUnchecked)
        m_fProperties.chkFontUnderline.Value = IIf(.Underline, vbChecked, vbUnchecked)
        m_fProperties.chkFontStrike.Value = IIf(.Strike, vbChecked, vbUnchecked)
      End With
    End With
  End With

  With PaintObject.Aspect
    m_fProperties.txLeft.Text = .Left
    m_fProperties.txTop.Text = .Top
    m_fProperties.txWidth.Text = .Width
    m_fProperties.txHeight.Text = .Height
    m_fProperties.TxBackColor.Text = .BackColor
    m_fProperties.chkTransparent.Value = IIf(.Transparent, vbChecked, vbUnchecked)
  End With
  
  bMultiSelect = UBound(m_vSelectedKeys) > 1
  
  m_fProperties.ResetChangedFlags

  m_fProperties.Show vbModal

  If Not m_fProperties.Ok Then GoTo ExitProc
  
  For i = 1 To UBound(m_vSelectedKeys)

    Set PaintObject = m_Paint.GetPaintObject(m_vSelectedKeys(i))
    Set RptCtrl = m_Report.Controls.Item(PaintObject.Tag)

    With RptCtrl
      
      If Not bMultiSelect Then
        If .Name <> m_fProperties.TxName.Text Then
          If .Name <> vbNullString Then
            If Ask("Ha modificado el nombre del control.;;¿Desea actualizar las formulas que mencionan este control?", vbYes) Then
              pUpdateFormulas .Name, m_fProperties.TxName.Text
            End If
          End If
        End If
        .Name = m_fProperties.TxName.Text
      End If
      
      If m_fProperties.TextChanged Then .Label.Text = m_fProperties.txText.Text
      If m_fProperties.TagChanged Then .Tag = m_fProperties.txTag.Text
      If m_fProperties.SetFormulaHideChanged Then .HasFormulaHide = m_fProperties.chkFormulaHide.Value = vbChecked
      If m_fProperties.SetFormulaValueChanged Then .HasFormulaValue = m_fProperties.chkFormulaValue.Value = vbChecked
      If m_fProperties.FormulaHideChanged Then .FormulaHide.Text = m_fProperties.FormulaHide
      If m_fProperties.FormulaValueChanged Then .FormulaValue.Text = m_fProperties.FormulaValue
      If m_fProperties.IdxGroupChanged Then .FormulaValue.idxGroup = m_fProperties.txIdxGroup.csValue
      If m_fProperties.WhenEvalChanged Then .FormulaValue.WhenEval = IIf(m_fProperties.opAfterPrint.Value, csRptEvalPost, csRptEvalPre)
      
      If m_fProperties.ExportColIdxChanged Then .ExportColIdx = m_fProperties.txExportColIdx.Text
      If m_fProperties.IsFreeCtrlChanged Then .IsFreeCtrl = m_fProperties.chkIsFreeCtrl.Value = vbChecked
      
      If .ControlType = CSReportDll2.csRptControlType.csRptCtField _
          Or .ControlType = CSReportDll2.csRptControlType.csRptCtDbImage Then
          
        With .Field
          If m_fProperties.DbFieldChanged Then
            .FieldType = m_fProperties.FieldType
            .Index = m_fProperties.Index
            .Name = m_fProperties.TxDbField.Text
          End If
        End With
      End If
      
      If m_fProperties.PictureChanged Then
        Set Image = .Image
        With m_fProperties.picImage
          Dim Width  As Long
          Dim Height As Long
          
          Width = .ScaleX(.Picture.Width, vbHimetric, vbTwips)
          Height = .ScaleY(.Picture.Height, vbHimetric, vbTwips)
          
          Image.hImage = m_Paint.CopyBitmap(.hDC, Width, Height, Image.hImage)
        End With
      End If
      
      If .ControlType = CSReportDll2.csRptControlType.csRptCtChart Then
      
        If .Chart.Series.Count < 1 Then .Chart.Series.Add Nothing
      
        If m_fProperties.ChartTypeChanged Then
          .Chart.ChartType = ListID(m_fProperties.cbType)
        End If
        If m_fProperties.ChartFormatTypeChanged Then
          .Chart.Format = ListID(m_fProperties.cbFormatType)
        End If
        If m_fProperties.ChartSizeChanged Then
          .Chart.Diameter = ListID(m_fProperties.cbChartSize)
        End If
        If m_fProperties.ChartThicknessChanged Then
          .Chart.Thickness = ListID(m_fProperties.cbChartThickness)
        End If
        If m_fProperties.ChartLinesTypeChanged Then
          .Chart.GridLines = ListID(m_fProperties.cbLinesType)
        End If
        
        If m_fProperties.ChartShowLinesChanged Then
          .Chart.OutlineBars = m_fProperties.opLinesYes.Value
        End If
        If m_fProperties.ChartShowValuesChanged Then
          .Chart.ShowValues = m_fProperties.opValuesYes.Value
        End If
        
        If m_fProperties.TextChanged Then
          .Chart.ChartTitle = m_fProperties.txText.Text
        End If
        
        If m_fProperties.ChartTopChanged Then
          .Chart.Top = m_fProperties.txChartTop.csValue
        End If
        
        If m_fProperties.ChartSortChanged Then
          .Chart.Sort = m_fProperties.chkSort.Value = vbChecked
        End If
        
        If m_fProperties.ChartGroupValueChanged Then
          .Chart.GroupValue = m_fProperties.txChartGroupValue.csValue
        End If
      
        If m_fProperties.ChartFieldGroupChanged Then
          .Chart.GroupFieldName = m_fProperties.TxDbFieldGroupValue.Text
          .Chart.GroupFieldIndex = m_fProperties.ChartGroupIndex
        End If
      
        If m_fProperties.ChartFieldLbl1Changed Then
          .Chart.Series(1).LabelFieldName = m_fProperties.TxDbFieldLbl1.Text
          .Chart.Series(1).LabelIndex = m_fProperties.ChartIndex(0)
        
          ' Decidi no implementarlo ya que no lo encontre util
          '
          'm_fProperties.ChartFieldType(1) =
        End If
        If m_fProperties.ChartFieldVal1Changed Then
          .Chart.Series(1).ValueFieldName = m_fProperties.TxDbFieldVal1.Text
          .Chart.Series(1).ValueIndex = m_fProperties.ChartIndex(1)

          ' Decidi no implementarlo ya que no lo encontre util
          '
          'm_fProperties.ChartFieldType(1) =
        End If
        
        If m_fProperties.ChartColorSerie1Changed Then
          .Chart.Series(1).Color = ListID(m_fProperties.cbColorSerie1)
        End If
      
        If m_fProperties.ChartFieldLbl2Changed Or m_fProperties.ChartFieldVal2Changed Then
          If .Chart.Series.Count < 2 Then .Chart.Series.Add Nothing
        End If
      
        If m_fProperties.TxDbFieldLbl2.Text = vbNullString Or m_fProperties.TxDbFieldVal2.Text = vbNullString Then
          If .Chart.Series.Count > 1 Then .Chart.Series.Remove 2
        End If
        
        If .Chart.Series.Count > 1 Then
        
          If m_fProperties.ChartFieldLbl2Changed Then
            .Chart.Series(2).LabelFieldName = m_fProperties.TxDbFieldLbl2.Text
            .Chart.Series(2).LabelIndex = m_fProperties.ChartIndex(2)
            
            ' Decidi no implementarlo ya que no lo encontre util
            '
            'm_fProperties.ChartFieldType(2) =
          End If
          If m_fProperties.ChartFieldVal2Changed Then
            .Chart.Series(2).ValueFieldName = m_fProperties.TxDbFieldVal2.Text
            .Chart.Series(2).ValueIndex = m_fProperties.ChartIndex(3)
          
            ' Decidi no implementarlo ya que no lo encontre util
            '
            'm_fProperties.ChartFieldType(3) =
          End If
          
          If m_fProperties.ChartColorSerie2Changed Then
            .Chart.Series(2).Color = ListID(m_fProperties.cbColorSerie2)
          End If
        End If
      End If
      
    End With
  
    If m_fProperties.TextChanged Then PaintObject.Text = m_fProperties.txText.Text
  
    With RptCtrl.Label.Aspect
      If m_fProperties.LeftChanged Then .Left = CSng(m_fProperties.txLeft.Text)
      If m_fProperties.TopChanged Then .Top = CSng(m_fProperties.txTop.Text)
      If m_fProperties.WidthChanged Then .Width = CSng(m_fProperties.txWidth.Text)
      If m_fProperties.HeightChanged Then .Height = CSng(m_fProperties.txHeight.Text)
      If m_fProperties.BackColorChanged Then .BackColor = CLng(m_fProperties.TxBackColor.Text)
      If m_fProperties.TransparentChanged Then .Transparent = m_fProperties.chkTransparent.Value = vbChecked
      If m_fProperties.AlignChanged Then .Align = ListID(m_fProperties.cbAlign)
      If m_fProperties.FormatChanged Then .Format = m_fProperties.TxFormat.Text
      If m_fProperties.SymbolChanged Then
        .Symbol = m_fProperties.txSymbol.Text
        .IsAccounting = m_fProperties.IsAccounting
      End If
      If m_fProperties.WordWrapChanged Then .WordWrap = m_fProperties.chkWordWrap.Value = vbChecked
      If m_fProperties.CanGrowChanged Then .CanGrow = m_fProperties.chkCanGrow.Value = vbChecked
      
      If m_fProperties.BorderColorChanged Then .BorderColor = CLng(m_fProperties.txBorderColor.Text)
      If m_fProperties.Border3DChanged Then .BorderColor3d = CLng(m_fProperties.txBorder3D.Text)
      If m_fProperties.Border3DShadowChanged Then .BorderColor3dShadow = CLng(m_fProperties.txBorderShadow.Text)
      If m_fProperties.BorderRoundedChanged Then .BorderRounded = m_fProperties.chkBorderRounded.Value = vbChecked
      If m_fProperties.BorderWidthChanged Then .BorderWidth = CLng(m_fProperties.txBorderWidth.Text)
      If m_fProperties.BorderTypeChanged Then .BorderType = ListID(m_fProperties.cbBorderType)
      
      With .Font
        If m_fProperties.FontChanged Then .Name = m_fProperties.txFont.Text
        If m_fProperties.ForeColorChanged Then .ForeColor = CLng(m_fProperties.TxForeColor.Text)
        If m_fProperties.FontSizeChanged Then .Size = CSng(m_fProperties.TxFontSize.Text)
        If m_fProperties.BoldChanged Then .Bold = m_fProperties.chkFontBold.Value = vbChecked
        If m_fProperties.ItalicChanged Then .Italic = m_fProperties.chkFontItalic.Value = vbChecked
        If m_fProperties.UnderlineChanged Then .Underline = m_fProperties.chkFontUnderline.Value = vbChecked
        If m_fProperties.StrikeChanged Then .Strike = m_fProperties.chkFontStrike.Value = vbChecked
      End With
    End With
  
    If m_fProperties.PictureChanged Then
      PaintObject.hImage = RptCtrl.Image.hImage
    End If
  
    '////////////////////////////////////////////////////////'
    ' esto sera removido cuando agreguemos una interface     '
    '////////////////////////////////////////////////////////'
    With PaintObject.Aspect
      If m_fProperties.LeftChanged Then .Left = CSng(m_fProperties.txLeft.Text)
      If m_fProperties.TopChanged Then .Top = CSng(m_fProperties.txTop.Text)
      If m_fProperties.WidthChanged Then .Width = CSng(m_fProperties.txWidth.Text)
      If m_fProperties.HeightChanged Then .Height = CSng(m_fProperties.txHeight.Text)
      If m_fProperties.BackColorChanged Then .BackColor = CLng(m_fProperties.TxBackColor.Text)
      If m_fProperties.TransparentChanged Then .Transparent = m_fProperties.chkTransparent.Value = vbChecked
      If m_fProperties.AlignChanged Then .Align = ListID(m_fProperties.cbAlign)
      If m_fProperties.FormatChanged Then .Format = m_fProperties.TxFormat.Text
      If m_fProperties.SymbolChanged Then .Symbol = m_fProperties.txSymbol.Text
      If m_fProperties.WordWrapChanged Then .WordWrap = m_fProperties.chkWordWrap.Value = vbChecked
      
      If m_fProperties.BorderTypeChanged Then .BorderType = ListID(m_fProperties.cbBorderType)
      
      If .BorderType = CSReportDll2.csRptBSNone Then
        .BorderColor = vbBlack
        .BorderWidth = 1
        .BorderRounded = False
        .BorderType = CSReportDll2.csRptBSFixed
      Else
        If m_fProperties.BorderColorChanged Then .BorderColor = CLng(m_fProperties.txBorderColor.Text)
        If m_fProperties.Border3DChanged Then .BorderColor3d = CLng(m_fProperties.txBorder3D.Text)
        If m_fProperties.Border3DShadowChanged Then .BorderColor3dShadow = CLng(m_fProperties.txBorderShadow.Text)
        If m_fProperties.BorderRoundedChanged Then .BorderRounded = m_fProperties.chkBorderRounded.Value = vbChecked
        If m_fProperties.BorderWidthChanged Then .BorderWidth = CLng(m_fProperties.txBorderWidth.Text)
      End If
      
      With .Font
        If m_fProperties.FontChanged Then .Name = m_fProperties.txFont.Text
        If m_fProperties.ForeColorChanged Then .ForeColor = CLng(m_fProperties.TxForeColor.Text)
        If m_fProperties.FontSizeChanged Then .Size = CSng(m_fProperties.TxFontSize.Text)
        If m_fProperties.BoldChanged Then .Bold = m_fProperties.chkFontBold.Value = vbChecked
        If m_fProperties.ItalicChanged Then .Italic = m_fProperties.chkFontItalic.Value = vbChecked
        If m_fProperties.UnderlineChanged Then .Underline = m_fProperties.chkFontUnderline.Value = vbChecked
        If m_fProperties.StrikeChanged Then .Strike = m_fProperties.chkFontStrike.Value = vbChecked
      End With
    End With
  Next
  
  m_DataHasChanged = True

  GoTo ExitProc
ControlError:
  MngError Err(), "pShowCtrlProperties", C_Module, vbNullString
ExitProc:
  Unload m_fProperties
  m_ShowingProperties = False
  Set m_fProperties = Nothing
  m_Paint.EndMove PicBody
End Sub

Private Sub BeginDraging()
  PicBody.SetFocus
  m_Draging = True
  PicBody.MousePointer = vbCustom
  PicBody.MouseIcon = LoadPicture(App.Path & "\move32x32.cur")
End Sub

Private Sub EndDraging()
  m_Draging = False
  m_ControlType = csRptEditCtrlType.csRptEditNone
  PicBody.MousePointer = vbDefault
End Sub

Public Sub ShowToolBox()
  DoEvents

  Set m_fToolBox = GetToolBox(Me)

  ClearToolBox Me

  pAddColumnsToToolbox m_Report.Connect.DataSource, m_Report.Connect.Columns
  Dim Connect As CSReportDll2.cReportConnect
  
  For Each Connect In m_Report.ConnectsAux
    pAddColumnsToToolbox Connect.DataSource, Connect.Columns
  Next

  Dim Ctrl As CSReportDll2.cReportControl

  For Each Ctrl In m_Report.Controls
    With Ctrl
      If IsNumberField(.Field.FieldType) Then
          m_fToolBox.AddLbFormula (.Field.Name)

          ' Esto no es lo mas prolijo pero
          ' tomando en cuenta los tiempos
          ' por ahora queda asi. Lo correcto
          ' seria establecer algun mecanismo
          ' para indicar en la definicion de la
          ' formula que puede ser propuesta en
          ' el toolbox.
          m_fToolBox.AddFormula "Suma", .Name, "_Sum"
          m_fToolBox.AddFormula "Máximo", .Name, "_Max"
          m_fToolBox.AddFormula "Minimo", .Name, "_Min"
          m_fToolBox.AddFormula "Promedio", .Name, "_Average"
      End If
    End With
  Next Ctrl

  m_fToolBox.Init

  On Error Resume Next
  m_fToolBox.Show vbModeless, fMain
End Sub

Public Sub pAddColumnsToToolbox(ByVal DataSource As String, ByRef Columns As CSReportDll2.cColumnsInfo)
  Dim Col As CSReportDll2.cColumnInfo
  
  For Each Col In Columns
    With Col
      m_fToolBox.AddField GetDataSourceStr(DataSource) & .Name, CInt(.TypeColumn), .Position
      m_fToolBox.AddLabels .Name
    End With
  Next Col
End Sub

Public Sub Copy()
  On Error GoTo ControlError
  Dim i As Long
  
  If UBound(m_vSelectedKeys) = 0 Then Exit Sub
  
  ReDim m_vCopyKeys(UBound(m_vSelectedKeys))
  
  For i = 1 To UBound(m_vSelectedKeys)
    m_vCopyKeys(i) = m_vSelectedKeys(i)
  Next
  
  Set fMain.ReportCopySource = Me

  GoTo ExitProc
ControlError:
  MngError Err(), "Copy", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Public Sub Paste(ByVal bDontMove As Boolean)
  On Error GoTo ControlError
  
  m_bCopyWithoutMoving = bDontMove
  
  If UBound(m_vCopyKeys) = 0 Then
  
    If fMain.ReportCopySource Is Nothing Then Exit Sub
      
    m_CopyControlsFromOtherReport = True
      
  Else
    
    m_CopyControls = True
  
  End If
  
  AddLabel

  GoTo ExitProc
ControlError:
  MngError Err(), "Paste", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Public Sub EditText()
  On Error GoTo ControlError
  
  Const c_margen As Long = 20
  
  Dim sText As String
  Dim PaintObjAspect As CSReportPaint2.cReportAspect
  Dim Ctrl As CSReportDll2.cReportControl

  If m_KeyObj = vbNullString Then Exit Sub

  With m_Paint.GetPaintObject(m_KeyObj)
    Set PaintObjAspect = .Aspect
    sText = .Text
    Set Ctrl = m_Report.Controls.Item(.Tag)
    If Ctrl.ControlType = CSReportDll2.csRptControlType.csRptCtLabel Then
    End If
  End With
  If PaintObjAspect Is Nothing Then Exit Sub

  With PaintObjAspect
    TxEdit.Text = sText
    TxEdit.Left = .Left + c_margen
    TxEdit.Top = .Top + c_margen - .OffSet
    TxEdit.Width = .Width - c_margen * 2
    TxEdit.Height = .Height - c_margen * 2
    TxEdit.Visible = True
    TxEdit.ZOrder
    TxEdit.SetFocus
    TxEdit.FontName = .Font.Name
    TxEdit.FontSize = .Font.Size
    TxEdit.FontBold = .Font.Bold
    TxEdit.ForeColor = .Font.ForeColor
    TxEdit.BackColor = .BackColor
  End With
  
  

  GoTo ExitProc
ControlError:
  MngError Err(), "EditText", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub EndEditText(ByVal Descartar As Boolean)
  If Not TxEdit.Visible Then Exit Sub

  TxEdit.Visible = False

  If Descartar Then Exit Sub

  m_DataHasChanged = True

  Dim PaintObjAspect As CSReportPaint2.cReportPaintObject
  Set PaintObjAspect = m_Paint.GetPaintObject(m_KeyObj)
  If PaintObjAspect Is Nothing Then Exit Sub

  Dim sKeyRpt As String
  sKeyRpt = PaintObjAspect.Tag

  PaintObjAspect.Text = TxEdit.Text

  m_Report.Controls.Item(sKeyRpt).Label.Text = PaintObjAspect.Text
  RefreshBody
End Sub

Private Function PaintStandarSections()
  Dim PaintSec As cReportPaintObject
  
  With m_Report.Headers
    With .Item(C_KEY_HEADER)
      .KeyPaint = PaintSection(m_Report.Headers.Item(C_KEY_HEADER).Aspect, _
                               C_KEY_HEADER, _
                               CSReportPaint2.csRptPaintRptType.csRptPaintRptTypeMainSectionHeader, _
                               "Encabezado 1", False)
      Set PaintSec = m_Paint.PaintSections(.KeyPaint)
      PaintSec.HeightSec = .Aspect.Height
    End With
    pAddPaintSetcionForSecLn .Item(C_KEY_HEADER), C_KEY_SECLN_HEADER
  End With
  
  With m_Report.Details
    With .Item(C_KEY_DETAIL)
      .KeyPaint = PaintSection(m_Report.Details.Item(C_KEY_DETAIL).Aspect, _
                               C_KEY_DETAIL, _
                               CSReportPaint2.csRptPaintRptType.csRptPaintRptTypeMainSectionDetail, _
                               "Detalle", False)
      Set PaintSec = m_Paint.PaintSections(.KeyPaint)
      PaintSec.HeightSec = .Aspect.Height
    End With
    pAddPaintSetcionForSecLn .Item(C_KEY_DETAIL), C_KEY_SECLN_DETAIL
  End With
  
  With m_Report.Footers
    With .Item(C_KEY_FOOTER)
      .KeyPaint = PaintSection(m_Report.Footers.Item(C_KEY_FOOTER).Aspect, _
                               C_KEY_FOOTER, _
                               CSReportPaint2.csRptPaintRptType.csRptPaintRptTypeMainSectionFooter, _
                               "Píe 1", False)
      Set PaintSec = m_Paint.PaintSections(.KeyPaint)
      PaintSec.HeightSec = .Aspect.Height
    End With
    pAddPaintSetcionForSecLn .Item(C_KEY_FOOTER), C_KEY_SECLN_FOOTER
  End With
End Function

Private Function PaintSection(ByRef Aspect As CSReportDll2.cReportAspect, _
                              ByVal sKey As String, _
                              ByVal RptType As CSReportPaint2.csRptPaintRptType, _
                              ByVal Text As String, _
                              ByVal IsSectionLine As Boolean) As String
                              
  Dim PaintObj As CSReportPaint2.cReportPaintObject
  Set PaintObj = m_Paint.GetNewSection(CSReportPaint2.cRptPaintObjType.csRptPaintObjBox)

  With PaintObj
    With .Aspect
      ' Solo dibujo la linea inferior de las secciones
      .Left = 0
      .Top = Aspect.Top + Aspect.Height - C_Height_Bar_Section
      .Width = Aspect.Width
      .Height = C_Height_Bar_Section

      Dim InnerColor As Long
      InnerColor = &HAEAEAE
      
      If IsSectionLine Then
        .BackColor = InnerColor
        .BorderColor = vbRed
      Else
        If RptType = CSReportPaint2.csRptPaintRptType.csRptPaintRptTypeGroupSectionFooter Or _
           RptType = CSReportPaint2.csRptPaintRptType.csRptPaintRptTypeGroupSectionHeader Then
          .BackColor = InnerColor
          .BorderColor = &HC0C000
        Else
          .BackColor = InnerColor
          .BorderColor = &H5A7FB
        End If
      End If
      
      If RptType = CSReportPaint2.csRptPaintRptType.csRptPaintRptTypeMainSectionFooter Or _
         RptType = CSReportPaint2.csRptPaintRptType.csRptPaintRptTypeSectionFooter Then
        .OffSet = m_OffSet
      End If
      
      '.BorderColor3d = vb3DLight
      '.BorderColor3dShadow = vb3DShadow
      '.BorderType = CSReportDll2.csReportBorderType.csRptBS3d
    End With

    .IsSection = Not IsSectionLine

    .RptType = RptType
    .Tag = sKey

    .Text = Text

    PaintSection = .Key
  End With
End Function

Private Function GetLineRegionForControl(ByVal sKeyPaintObj As String, _
                                         ByRef RptSecLine As cReportSectionLine, _
                                         ByVal IsFreeCtrl As Boolean) As Boolean

  Dim RptSection As CSReportDll2.cReportSection

  If Not GetRegionForControl(sKeyPaintObj, RptSection, IsFreeCtrl) Then Exit Function

  Dim w1 As Single
  Dim w2 As Single

  Dim y As Single
  
  Dim rtnSecLine As cReportSectionLine

  With m_Paint.GetPaintObject(sKeyPaintObj).Aspect
    If IsFreeCtrl Then
      y = .Top + .OffSet
    Else
      y = .Top + .Height / 2 + .OffSet
    End If
  End With

  GetLineRegionForControl = True

  For Each RptSecLine In RptSection.SectionLines
    With RptSecLine.Aspect
      w1 = .Top
      w2 = .Top + .Height
      If IsFreeCtrl Then
        If w1 <= y Then
          Set rtnSecLine = RptSecLine
        End If
      Else
        If w1 <= y And w2 >= y Then Exit Function
      End If
    End With
  Next RptSecLine
  
  If Not rtnSecLine Is Nothing Then
    Set RptSecLine = rtnSecLine
    Exit Function
  End If

  GetLineRegionForControl = False
End Function

Private Function GetRegionForControl(ByVal sKeyPaintObj As String, _
                                     ByRef RptSection As cReportSection, _
                                     ByVal IsFreeCtrl As Boolean) As Boolean

  GetRegionForControl = True

  Dim x As Single
  Dim y As Single

  With m_Paint.GetPaintObject(sKeyPaintObj).Aspect
    ' Headers

    x = .Left
    If IsFreeCtrl Then
      y = .Top
    Else
      y = .Top + .Height / 2
    End If

    If GetRegionForControlAux(m_Report.Headers, x, y, _
                              RptSection, IsFreeCtrl) Then
      .OffSet = 0
      Exit Function
    End If
    
    ' Groups Headers
    If GetRegionForControlAux(m_Report.GroupsHeaders, x, y, _
                              RptSection, IsFreeCtrl) Then
      .OffSet = 0
      Exit Function
    End If
    
    ' Details
    If GetRegionForControlAux(m_Report.Details, x, y, _
                              RptSection, IsFreeCtrl) Then
      .OffSet = 0
      Exit Function
    End If

    ' Groups Footers
    If GetRegionForControlAux(m_Report.GroupsFooters, x, y, _
                              RptSection, IsFreeCtrl) Then
      .OffSet = 0
      Exit Function
    End If
    
    y = y + m_OffSet
    
    ' Footers
    If GetRegionForControlAux(m_Report.Footers, x, y, _
                              RptSection, IsFreeCtrl) Then
      .OffSet = m_OffSet
      Exit Function
    End If
  End With

  GetRegionForControl = False
End Function

Private Function GetRegionForControlAux(ByRef RptSections As Object, _
                                        ByVal x As Single, _
                                        ByVal y As Single, _
                                        ByRef RptSection As cReportSection, _
                                        ByVal IsFreeCtrl As Boolean) As Boolean
  Dim y1 As Single
  Dim Y2 As Single
  Dim rtnSec As cReportSection

  GetRegionForControlAux = True

  For Each RptSection In RptSections

    With RptSection.Aspect
      y1 = .Top
      Y2 = .Top + .Height

      If IsFreeCtrl Then
        If y1 <= y Then
          Set rtnSec = RptSection
        End If
      Else
        If y1 <= y And Y2 >= y Then Exit Function
      End If
    End With
  Next RptSection

  If Not rtnSec Is Nothing Then
    Set RptSection = rtnSec
    Exit Function
  End If

  GetRegionForControlAux = False
End Function

Private Sub pChangeTopSection(ByRef RptSec As CSReportDll2.cReportSection, _
                              ByVal OffSetTopSection As Single, _
                              ByVal bChangeTop As Boolean, _
                              ByVal bZeroOffset As Boolean)
  
  Dim RptSecLine  As CSReportDll2.cReportSectionLine
  Dim RptCtrl     As CSReportDll2.cReportControl
  Dim NewTopCtrl  As Long
  Dim OffSet      As Long
  Dim Bottom      As Long
  
  Dim PaintSec    As cReportPaintObject
  
  Dim SecTop      As Long
  Dim SecLnHeigt  As Long
  
  Dim OffSecLn    As Single
  
  With RptSec.Aspect
    .Top = .Top + OffSetTopSection
    
    OffSet = RptSec.SectionLines(1).Aspect.Top - .Top
    
    SecTop = .Top
  End With
  
  For Each RptSecLine In RptSec.SectionLines
    
    With RptSecLine.Aspect
    
      ' Los Footers crecen hacia arriba
      '
      If RptSec.TypeSection = csRptTpMainSectionFooter Or _
         RptSec.TypeSection = csRptTpScFooter Then
    
        ' Seguir buscando el bug para cuando se agregan renglones a un footer
        '
        If bChangeTop Then
              
          If bZeroOffset Then
            OffSet = 0
          End If
          
        Else
          
          If RptSecLine.RealIndice >= m_IndexSecLnMoved And _
             m_IndexSecLnMoved > 0 Then
          
            bChangeTop = True
          End If
          
        End If
    
      ' Todas las demas secciones crecen hacia abajo
      '
      Else
        OffSecLn = (SecTop + SecLnHeigt) - .Top
        
        If OffSetTopSection Then
          OffSecLn = 0
        End If
      End If
      
      .Top = SecTop + SecLnHeigt
      SecLnHeigt = SecLnHeigt + .Height
      
      If RptSecLine.KeyPaint <> vbNullString Then
        Set PaintSec = m_Paint.PaintSections(RptSecLine.KeyPaint)
        PaintSec.Aspect.Top = .Top _
                            + .Height _
                            - C_Height_Bar_Section
      Else
        Set PaintSec = m_Paint.PaintSections(RptSec.KeyPaint)
      End If
      If Not PaintSec Is Nothing Then
        PaintSec.HeightSecLine = .Height
      End If
    End With
    
    For Each RptCtrl In RptSecLine.Controls
      With RptCtrl.Label.Aspect

        If RptCtrl.IsFreeCtrl Then
          NewTopCtrl = (.Top - OffSet) + OffSecLn
        Else
          NewTopCtrl = (.Top + .Height - OffSet) + OffSecLn
        End If

        With RptSecLine.Aspect
          Bottom = .Top + .Height
        End With

        If NewTopCtrl > Bottom Then
          NewTopCtrl = Bottom - .Height
        Else
          NewTopCtrl = (.Top - OffSet) + OffSecLn
        End If

        With RptSecLine.Aspect
          If NewTopCtrl < .Top Then NewTopCtrl = .Top
        End With

        Debug.Print NewTopCtrl

        .Top = NewTopCtrl
        If Not m_Paint.GetPaintObject(RptCtrl.KeyPaint) Is Nothing Then
          m_Paint.GetPaintObject(RptCtrl.KeyPaint).Aspect.Top = .Top
        End If
      End With
    Next
  Next
  
  ' Cuando agrego un grupo el primero en llegar aca es el header
  ' y el footer aun no tiene asignada una seccion
  If RptSec.KeyPaint = vbNullString Then Exit Sub
  
  With RptSec.Aspect
    ' Solo dibujo la linea inferior de las secciones
    Set PaintSec = m_Paint.PaintSections(RptSec.KeyPaint)
    If Not PaintSec Is Nothing Then
      PaintSec.Aspect.Top = .Top + .Height - C_Height_Bar_Section
      PaintSec.HeightSec = .Height
    End If
  End With
End Sub

Private Sub MoveSection(ByRef PaintObj As CSReportPaint2.cReportPaintObject, _
                        ByVal x As Single, ByVal y As Single, _
                        ByVal MinBottom As Single, ByVal MaxBottom As Single, _
                        ByRef SecToMove As CSReportDll2.cReportSection, _
                        ByVal IsNew As Boolean)

  Dim oldHeight   As Single
  Dim i           As Long
  
  m_DataHasChanged = True
  
  With PaintObj.Aspect
    
    ' Si Y esta dentro del rango permitido todo bien
    If y >= MinBottom And y <= MaxBottom Then
      .Top = y - m_offY

      ' Como el top lo acabo de setear a dimensiones reales
      ' de la pantalla ahora lo tengo que desplazar al offset
      ' correspondiente a su seccion
      .Top = .Top + .OffSet

    ' Sino
    Else
      ' Si se fue para arriba
      If y < MinBottom Then
        .Top = MinBottom

      ' Como el top lo acabo de setear a dimensiones reales
      ' de la pantalla ahora lo tengo que desplazar al offset
      ' correspondiente a su seccion
      .Top = .Top + .OffSet

      ' Si se fue para abajo
      Else
        .Top = MaxBottom
      End If
    End If

    m_Paint.AlingToGrid PaintObj.Key

    If IsNew Then
      oldHeight = 0
    Else
      oldHeight = SecToMove.Aspect.Height
    End If

    ' Para las secciones que estan sobre el detalle y para las secciones de detalle
    ' solo cambia el heigth, para las que estan debajo del detalle cambia el height
    ' y el top, ya que cuando las achico lo que pasa es que las estoy mandando mas
    ' hacia abajo
    SecToMove.Aspect.Height = .Top + C_Height_Bar_Section - SecToMove.Aspect.Top
  End With
  
  ' Ademas cambia el top de todas las secciones que estan debajo
  Dim OffsetTop       As Single
  
  With SecToMove.Aspect
  
    OffsetTop = oldHeight - (.Height + m_NewSecLineOffSet)
    
    Select Case SecToMove.TypeSection
    
      ' Si la seccion es un footer vamos para abajo
      ' (Ojo secciones de tipo Footer, no Group Footer)
      Case CSReportDll2.csRptTpScFooter, CSReportDll2.csRptTpMainSectionFooter

        .Top = .Top + OffsetTop
        
        ' OJO: Esto tiene que ir despues de cambiar el top de la seccion
        '      para que lo refleje el objeto de dibujo
        ' Muevo los controles de esta seccion
        pChangeHeightSection SecToMove, oldHeight
        
        pChangeBottomSections SecToMove, OffsetTop
        
      ' Si la seccion es un header o un grupo (headers o Footers) o un detail vamos para arriba
      Case Else
      
        ' Muevo los controles de esta seccion
        pChangeHeightSection SecToMove, oldHeight

        OffsetTop = OffsetTop * -1
        
        pChangeTopSections SecToMove, OffsetTop
    End Select
  End With
  
  ' Finalmente tengo que recalcular el offset para todas las secciones
  ' refrescarlo en los objetos de m_Paint, ademas de modificar
  ' la grilla al nuevo tamaño de edicion
  Dim PageHeight As Single
  With m_Report.PaperInfo
    pGetOffSet GetRectFromPaperSize(m_Report.PaperInfo, _
                                    .PaperSize, _
                                    .Orientation).Height, _
               PageHeight
  End With
  pRefreshOffSetInPaintObjs
  m_Paint.GridHeight = PageHeight
  
End Sub

Private Sub pChangeBottomSections(ByRef SecToMove As CSReportDll2.cReportSection, _
                                  ByVal OffsetTop As Single)
                                  
  Dim Sec          As CSReportDll2.cReportSection
  Dim bChangeTop   As Boolean
  Dim i            As Long
  
  If SecToMove.TypeSection = CSReportDll2.csRptTpScFooter Or _
     SecToMove.TypeSection = CSReportDll2.csRptTpMainSectionFooter Or _
     bChangeTop Then
    
    For i = m_Report.Footers.Count To 1 Step -1
      Set Sec = m_Report.Footers(i)
      
      If bChangeTop Then
        pChangeTopSection Sec, OffsetTop, bChangeTop, False
      End If
      
      If Sec Is SecToMove Then
        bChangeTop = True
      End If
    Next
  End If
End Sub

Private Sub pChangeTopSections(ByRef SecToMove As CSReportDll2.cReportSection, _
                               ByVal OffsetTop As Single)
                               
  Dim Sec          As CSReportDll2.cReportSection
  Dim bChangeTop   As Boolean
  Dim i            As Long
  
  If SecToMove.TypeSection = CSReportDll2.csRptTpScHeader Or _
     SecToMove.TypeSection = CSReportDll2.csRptTpMainSectionHeader Then

    For Each Sec In m_Report.Headers
      If bChangeTop Then
        pChangeTopSection Sec, OffsetTop, bChangeTop, False
      End If
    
      If Sec Is SecToMove Then
        bChangeTop = True
      End If
    Next
  End If

  If SecToMove.TypeSection = CSReportDll2.csRptTpGroupHeader Or _
     bChangeTop Then
     
    For Each Sec In m_Report.GroupsHeaders
      If bChangeTop Then
        pChangeTopSection Sec, OffsetTop, bChangeTop, False
      End If
      
      If Sec Is SecToMove Then
        bChangeTop = True
      End If
    Next
  End If
  
  If SecToMove.TypeSection = CSReportDll2.csRptTpMainSectionDetail Or _
     SecToMove.TypeSection = CSReportDll2.csRptTpScDetail Or _
     bChangeTop Then
     
    For Each Sec In m_Report.Details
      If bChangeTop Then
        pChangeTopSection Sec, OffsetTop, bChangeTop, False
      End If
    
      If Sec Is SecToMove Then
        bChangeTop = True
      End If
    Next
  End If

  If SecToMove.TypeSection = CSReportDll2.csRptTpGroupFooter Or _
     bChangeTop Then
    
    For Each Sec In m_Report.GroupsFooters
      If bChangeTop Then
        pChangeTopSection Sec, OffsetTop, bChangeTop, False
      End If
      
      If Sec Is SecToMove Then
        bChangeTop = True
      End If
    Next
  End If
End Sub

Private Sub pChangeHeightSection(ByRef Sec As CSReportDll2.cReportSection, _
                                 ByVal OldSecHeight As Single)
  Dim i             As Long
  Dim HeightLines   As Single
  
  ' Modifico el SectionLine
  For i = 1 To Sec.SectionLines.Count - 1
    With Sec.SectionLines.Item(i).Aspect
      HeightLines = HeightLines + .Height
    End With
  Next i

  ' Para el ultimo el Height es igual a lo que queda
  With Sec.SectionLines
    With .Item(.Count).Aspect
      .Height = Sec.Aspect.Height - HeightLines
    End With
  End With
  
  pChangeTopSection Sec, 0, False, True
End Sub

Private Sub ReLoadReport()
  
  Dim PaintSec    As cReportPaintObject
  
  Set m_Paint = Nothing

  m_KeyMoving = vbNullString
  m_KeySizing = vbNullString
  m_KeyObj = vbNullString
  m_KeyFocus = vbNullString
  m_MoveType = CSRptEditroMoveType.csRptEdMovTNone
  
  Set m_Paint = New CSReportPaint2.cReportPaint

  With m_Report.PaperInfo
    m_Paint.GridHeight = pSetSizePics(GetRectFromPaperSize(m_Report.PaperInfo, .PaperSize, .Orientation).Height)
  End With
  
  m_Paint.InitGrid PicBody, m_TypeGrid

  If Not m_Report.Name = vbNullString Then
    Me.Caption = m_Report.Path & m_Report.Name
  End If

  Dim Sec As CSReportDll2.cReportSection

  For Each Sec In m_Report.Headers
    Sec.KeyPaint = PaintSection(Sec.Aspect, Sec.Key, Sec.TypeSection, Sec.Name, False)
    Set PaintSec = m_Paint.PaintSections(Sec.KeyPaint)
    PaintSec.HeightSec = Sec.Aspect.Height
    pAddPaintSetcionForSecLn Sec, C_KEY_SECLN_HEADER
  Next Sec

  For Each Sec In m_Report.GroupsHeaders
    Sec.KeyPaint = PaintSection(Sec.Aspect, Sec.Key, Sec.TypeSection, Sec.Name, False)
    Set PaintSec = m_Paint.PaintSections(Sec.KeyPaint)
    PaintSec.HeightSec = Sec.Aspect.Height
    pAddPaintSetcionForSecLn Sec, C_KEY_SECLN_GROUPH
  Next Sec

  For Each Sec In m_Report.Details
    Sec.KeyPaint = PaintSection(Sec.Aspect, Sec.Key, Sec.TypeSection, Sec.Name, False)
    Set PaintSec = m_Paint.PaintSections(Sec.KeyPaint)
    PaintSec.HeightSec = Sec.Aspect.Height
    pAddPaintSetcionForSecLn Sec, C_KEY_SECLN_DETAIL
  Next Sec

  For Each Sec In m_Report.GroupsFooters
    Sec.KeyPaint = PaintSection(Sec.Aspect, Sec.Key, Sec.TypeSection, Sec.Name, False)
    Set PaintSec = m_Paint.PaintSections(Sec.KeyPaint)
    PaintSec.HeightSec = Sec.Aspect.Height
    pAddPaintSetcionForSecLn Sec, C_KEY_SECLN_GROUPF
  Next Sec

  For Each Sec In m_Report.Footers
    Sec.KeyPaint = PaintSection(Sec.Aspect, Sec.Key, Sec.TypeSection, Sec.Name, False)
    Set PaintSec = m_Paint.PaintSections(Sec.KeyPaint)
    PaintSec.HeightSec = Sec.Aspect.Height
    pAddPaintSetcionForSecLn Sec, C_KEY_SECLN_FOOTER
  Next Sec

  Dim PaintObj As CSReportPaint2.cReportPaintObject
  Dim RptCtrl As CSReportDll2.cReportControl
  Dim CtrlAspect As CSReportDll2.cReportAspect

  Dim PaintType As CSReportPaint2.cRptPaintObjType
  
  For Each RptCtrl In m_Report.Controls
    RefreshNextNameCtrl (RptCtrl.Name)
    Set CtrlAspect = RptCtrl.Label.Aspect
    
    If RptCtrl.ControlType = CSReportDll2.csRptCtImage Or _
       RptCtrl.ControlType = CSReportDll2.csRptCtChart Then
      PaintType = CSReportPaint2.csRptPaintObjImage
    Else
      PaintType = CSReportPaint2.csRptPaintObjBox
    End If
    
    Set PaintObj = m_Paint.GetNewObject(PaintType)
    
    ' Codigo especial para corregir la propiedad
    ' transparent de los reportes viejos
    ' una ves que todos esten bien borrar estas lineas
    CtrlAspect.Transparent = CtrlAspect.BackColor = vbWhite
    ' fin codigo especial
    
    With PaintObj

      PaintObj.hImage = RptCtrl.Image.hImage

      With .Aspect
        .Left = CtrlAspect.Left
        .Top = CtrlAspect.Top
        .Width = CtrlAspect.Width
        .Height = CtrlAspect.Height
        .BackColor = CtrlAspect.BackColor
        .Transparent = CtrlAspect.Transparent
        .Align = CtrlAspect.Align
        .WordWrap = CtrlAspect.WordWrap
        
        If CtrlAspect.BorderType = CSReportDll2.csRptBSNone Then
          .BorderColor = vbBlack
          .BorderWidth = 1
          .BorderRounded = False
          .BorderType = CSReportDll2.csRptBSFixed
        Else
          .BorderType = CtrlAspect.BorderType
          .BorderColor = CtrlAspect.BorderColor
          .BorderColor3d = CtrlAspect.BorderColor3d
          .BorderColor3dShadow = CtrlAspect.BorderColor3dShadow
          .BorderRounded = CtrlAspect.BorderRounded
          .BorderWidth = CtrlAspect.BorderWidth
        End If
        
        Select Case RptCtrl.SectionLine.TypeSection
          Case CSReportDll2.csRptTypeSection.csRptTpScFooter, CSReportDll2.csRptTypeSection.csRptTpMainSectionFooter
            .OffSet = m_OffSet
        End Select
        
        With .Font
          .Name = CtrlAspect.Font.Name
          .ForeColor = CtrlAspect.Font.ForeColor
          .Size = CtrlAspect.Font.Size
          .Bold = CtrlAspect.Font.Bold
          .Italic = CtrlAspect.Font.Italic
          .Underline = CtrlAspect.Font.Underline
          .Strike = CtrlAspect.Font.Strike
        End With
      End With

      .Text = RptCtrl.Label.Text
      .RptType = CSReportPaint2.csRptPaintRptType.csRptPaintRptTypeControl
      .Tag = RptCtrl.Key
      RptCtrl.KeyPaint = .Key
    End With
  Next RptCtrl

  m_DataHasChanged = False

  m_Paint.CreatePicture PicBody

  PicRule.Refresh
End Sub

Private Sub pAddPaintSetcionForSecLn(ByRef Sec As CSReportDll2.cReportSection, _
                                     ByVal TypeSecLn As csESectionLineTypes)
  Dim i           As Long
  Dim PaintSec    As cReportPaintObject

  If Sec.SectionLines.Count > 1 Then
  
    For i = 1 To Sec.SectionLines.Count - 1
      With Sec.SectionLines(i)
        .KeyPaint = PaintSection(.Aspect, _
                                 .Key, _
                                 Sec.TypeSection, _
                                 C_SectionLine & i, _
                                 True)
        
        ' Indicamos el alto de cada Section Line
        '
        Set PaintSec = m_Paint.PaintSections.Item(.KeyPaint)
        PaintSec.HeightSecLine = .Aspect.Height
        PaintSec.RptType = TypeSecLn
        PaintSec.RptKeySec = Sec.Key
      End With
    Next
  
    ' Si hay mas de una seccion usamos
    ' TextLine para que la barra de la regla
    ' indique el nombre del ultimo renglon
    '
    With m_Paint.PaintSections.Item(Sec.KeyPaint)
      .TextLine = C_SectionLine & Sec.SectionLines.Count
    End With
  
  End If
  
  ' Indicamos el alto de la ultima Section Line
  '
  Set PaintSec = m_Paint.PaintSections.Item(Sec.KeyPaint)
  
  With Sec.SectionLines
    PaintSec.HeightSecLine = .Item(.Count).Aspect.Height
  End With
End Sub

Private Sub RefreshNextNameCtrl(ByVal NameCtrl As String)
  Dim x As Long
  If UCase(Mid(NameCtrl, 1, Len(C_Control_Name))) = UCase(C_Control_Name) Then
    x = Val(Mid(NameCtrl, Len(C_Control_Name) + 1))
    If x > m_NextNameCtrl Then
      m_NextNameCtrl = x + 1
    End If
  End If
End Sub

Public Sub SizeControls()
  On Error Resume Next

  DoEvents

  ' Posicion del area de dibujo
  '
  ' Ancho
  '
  picTop.Width = Me.ScaleWidth
  
  ' Borde de la barra izquierda
  '
  lnLeft.Y2 = PicRule.ScaleHeight + 100
  
  ' Posicion de la barra horizontal
  '
  ScrHorizontal.Left = pGetLeftBody
  ScrHorizontal.Top = ScaleHeight - ScrHorizontal.Height
  
  ' Tamaño - Ancho
  '
  ScrHorizontal.Width = ScaleWidth - ScrHorizontal.Left - ScrVertical.Width
  
  ' Posicion de la barra vertical
  '
  ScrVertical.Top = C_TopBody
  ScrVertical.Left = ScaleWidth - ScrVertical.Width
  
  ' Tamaño - Alto
  '
  ScrVertical.Height = ScaleHeight - ScrHorizontal.Height - ScrVertical.Top
  
  ' Maximo desplazamiento vertical
  '
  If ScaleHeight > 1 Then
    ScrVertical.Max = PicBody.Height - (Me.ScaleHeight - ScrHorizontal.Height - 10)
  End If
  
  ' Maximo desplazamiento horizontal
  '
  If ScaleWidth > 1 Then
    ScrHorizontal.Max = PicBody.Width - (Me.ScaleWidth - pGetLeftBody - ScrVertical.Width - 10)
  End If

  ' Tamaño de los desplazamientos maximo y minimo
  '
  ScrVertical.LargeChange = ScrVertical.Max / 2
  ScrVertical.SmallChange = ScrVertical.Max / 100

  ' Tamaño de los desplazamientos maximo y minimo
  '
  ScrHorizontal.LargeChange = ScrHorizontal.Max / 2
  ScrHorizontal.SmallChange = ScrHorizontal.Max / 100

  If ScrVertical.Max <= 0 Then
    ScrVertical.Max = ScrVertical.LargeChange - 1
    ScrVertical.Visible = False
    ScrVertical_Change
    ScrHorizontal.Width = ScaleWidth - ScrHorizontal.Left
  Else
    ScrVertical.Visible = True
  End If

  If ScrHorizontal.Max <= 0 Then
    ScrHorizontal.Max = ScrHorizontal.LargeChange - 1
    ScrHorizontal.Visible = False
    ScrHorizontal_Change
    ScrVertical.Height = ScaleHeight - ScrVertical.Top
    PicRightCorner.Visible = False
  Else
    ScrHorizontal.Visible = True
    PicRightCorner.Visible = True
  End If

  PicRightCorner.Left = ScaleWidth - ScrVertical.Width
  PicRightCorner.Top = ScaleHeight - ScrHorizontal.Height
End Sub

Private Sub MoveControl(ByVal sKeyPaintObj As String)
  Dim RptSecLine       As CSReportDll2.cReportSectionLine
  Dim RptCtrl          As CSReportDll2.cReportControl
  Dim RptSecLineAspect As CSReportDll2.cReportAspect
  Dim ObjPaintAspect   As CSReportPaint2.cReportAspect
  
  m_Paint.AlingToGrid sKeyPaintObj

  Set RptCtrl = m_Report.Controls.Item(m_Paint.GetPaintObject(sKeyPaintObj).Tag)

  Set ObjPaintAspect = m_Paint.GetPaintObject(sKeyPaintObj).Aspect

  If RptCtrl Is Nothing Then Exit Sub

  With RptCtrl.Label.Aspect
    .Top = ObjPaintAspect.Top + ObjPaintAspect.OffSet
    .Height = ObjPaintAspect.Height
    .Width = ObjPaintAspect.Width
    .Left = ObjPaintAspect.Left
  End With

  If GetLineRegionForControl(sKeyPaintObj, _
                             RptSecLine, _
                             RptCtrl.IsFreeCtrl) Then

    With RptCtrl
      If Not RptSecLine Is .SectionLine Then
        .SectionLine.Controls.Remove .Key
        RptSecLine.Controls.Add RptCtrl, RptCtrl.Key
      End If
      
      ' Tengo que validar que el control este dentro de los limites de la seccion en la que se encuentra
      Set RptSecLineAspect = .SectionLine.Aspect

      With .Label.Aspect
      
        .Top = ObjPaintAspect.Top + ObjPaintAspect.OffSet

        If Not RptCtrl.IsFreeCtrl Then
          If .Top + .Height > RptSecLineAspect.Top + RptSecLineAspect.Height Then
            .Top = RptSecLineAspect.Top + RptSecLineAspect.Height - .Height
          End If
        End If

        If .Top < RptSecLineAspect.Top Then
          .Top = RptSecLineAspect.Top
        End If
        
        ObjPaintAspect.Top = .Top

      End With
    End With
  End If
End Sub

Private Sub ShowPopMenuSection(ByVal NoDelete As Boolean, _
                               ByVal ShowGroups As Boolean)
  fMain.popSecDelete.Enabled = Not NoDelete
  fMain.popSecPropGroup.Visible = ShowGroups
  fMain.PopupMenu fMain.popSec
End Sub

Private Sub ShowPopMenuControl(ByVal ClickInCtrl As Boolean)
  With fMain
    If Not ClickInCtrl Then
      .popObjCopy.Enabled = False
      .popObjCut.Enabled = False
      .popObjDelete.Enabled = False
      .popObjEditText.Enabled = False
      .popObjSendToBack.Enabled = False
      .popObjBringToFront.Enabled = False
      .popObjSendToBack.Enabled = False
      .popObjProperties.Enabled = False
    Else
      .popObjCopy.Enabled = True
      .popObjCut.Enabled = True
      .popObjDelete.Enabled = True
      .popObjEditText.Enabled = True
      .popObjSendToBack.Enabled = True
      .popObjBringToFront.Enabled = True
      .popObjSendToBack.Enabled = True
      .popObjProperties.Enabled = True
    End If
    
    Dim bPasteEnabled As Boolean
    
    If UBound(m_vCopyKeys) > 0 Then
      bPasteEnabled = True
    ElseIf Not (fMain.ReportCopySource Is Nothing) Then
      bPasteEnabled = fMain.ReportCopySource.vCopyKeysCount > 0
    End If
    
    .popObjPaste.Enabled = bPasteEnabled
    .popObjPasteEx.Enabled = bPasteEnabled
    .PopupMenu .popObj
  End With
End Sub

Private Sub m_fGroup_UnloadForm()
  Set m_fGroup = Nothing
End Sub

Private Sub m_fProperties_UnloadForm()
  Set m_fProperties = Nothing
End Sub

Private Sub RefreshBody()
  On Error GoTo ControlError
  
  m_Paint.EndMove PicBody
  
  GoTo ExitProc
ControlError:
  MngError Err, "ShowConnectsAux", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub RefreshRule()
  PicRule.Refresh
End Sub

Public Sub RefreshReport()
  
  With m_Report.PaperInfo
    m_Paint.GridHeight = pSetSizePics(GetRectFromPaperSize(m_Report.PaperInfo, .PaperSize, .Orientation).Height)
  End With
  
  SizeControls

  pValidateSectionAspect
  ReLoadReport
End Sub

Public Sub RefreshPostion()
  ScrHorizontal_Change
  ScrVertical_Change
End Sub

Public Sub RefreshAll()
  RefreshBody
  RefreshRule
End Sub

Private Sub m_Report_Done()
  CloseProgressDlg
End Sub

Private Sub m_Report_Progress(ByVal Task As String, ByVal Page As Long, ByVal CurrRecord As Long, ByVal RecordCount As Long, ByRef Cancel As Boolean)

  DoEvents

  If m_CancelPrinting Then
    If Ask("Confirma que desea cancelar la ejecución del reporte", vbNo) Then
      Cancel = True
      CloseProgressDlg
      Exit Sub
    Else
      m_CancelPrinting = False
    End If
  End If

  If m_fProgress Is Nothing Then Exit Sub

  If Page > 0 Then m_fProgress.lbCurrPage.Caption = Page
  If Task <> vbNullString Then m_fProgress.lbTask.Caption = Task
  If CurrRecord > 0 Then m_fProgress.lbCurrRecord.Caption = CurrRecord
  If RecordCount > 0 And Val(m_fProgress.lbRecordCount.Caption) <> RecordCount Then m_fProgress.lbRecordCount.Caption = RecordCount

  Dim Percent As Double
  If RecordCount > 0 And CurrRecord > 0 Then
    Percent = CurrRecord / RecordCount
    On Error Resume Next
    m_fProgress.prgVar.Value = Percent * 100
  End If
End Sub

Private Sub CloseProgressDlg()
  On Error Resume Next
  Unload m_fProgress
  Set m_fProgress = Nothing
End Sub

Private Sub ShowProgressDlg()
  m_CancelPrinting = False
  If m_fProgress Is Nothing Then Set m_fProgress = New fProgress
  m_fProgress.Show
  m_fProgress.ZOrder
End Sub

Private Sub m_fProgress_Cancel()
  m_CancelPrinting = True
End Sub

Private Sub m_Report_FindFileAccess(ByRef Answer As Boolean, ByRef CommDialog As Object, ByVal File As String)
  Dim msg As String
  msg = "No se ha encontrado el archivo " & File & ". ¿Desea tratar de ubicarlo?"
  If Not Ask(msg, vbYes) Then Exit Sub

  CommDialog = fMain.cmDialog
  Answer = True
  m_fProgress.ZOrder
  m_DataHasChanged = True
End Sub

Private Sub TxEdit_KeyPress(KeyAscii As Integer)
  If KeyAscii = vbKeyEscape Then
    EndEditText (KeyAscii = vbKeyEscape)
    KeyAscii = 0
  End If
End Sub

Private Function pGetLeftBody()
  If gHideLeftBar Then
    pGetLeftBody = C_LeftBody
  Else
    pGetLeftBody = PicRule.Width + C_LeftBody
  End If
End Function
  
Private Function pSetSizePics(ByVal RealPageHeight As Single) As Single
  Dim PageHeight As Single
  
  With m_Report.PaperInfo
    PicBody.Width = GetRectFromPaperSize(m_Report.PaperInfo, .PaperSize, .Orientation).Width
  End With
  
  pGetOffSet RealPageHeight, PageHeight
  
  If PageHeight > RealPageHeight Then RealPageHeight = PageHeight
  
  PicBody.Height = RealPageHeight
  PicRule.Height = RealPageHeight + C_TopBody * 2 + ScrVertical.Height
  
  pSetSizePics = PageHeight
End Function

Private Sub pMoveAll(ByVal x As Single, ByVal y As Single)
  Dim RptCtrlAspect As CSReportDll2.cReportAspect
  Dim PaintObj      As CSReportPaint2.cReportPaintObject
  
  m_DataHasChanged = True

  If m_bNoMove Then Exit Sub

  Dim i As Long
  Dim OffsetTop   As Long
  Dim OffsetLeft  As Long
  Dim FirstLeft   As Long
  Dim FirstTop    As Long
  Dim FirstOffSet As Long
  
  If UBound(m_vSelectedKeys) = 0 Then Exit Sub
  
  Set PaintObj = m_Paint.GetPaintObject(m_KeyMoving)
  
  With PaintObj.Aspect
    FirstLeft = .Left
    FirstTop = .Top
    FirstOffSet = .OffSet
  End With
  
  For i = UBound(m_vSelectedKeys) To 1 Step -1
    
    Set PaintObj = m_Paint.GetPaintObject(m_vSelectedKeys(i))
    
    OffsetLeft = pGetOffsetLeftFromControls(FirstLeft, PaintObj.Aspect.Left)
    OffsetTop = pGetOffsetTopFromControls(FirstTop - FirstOffSet, PaintObj.Aspect.Top - PaintObj.Aspect.OffSet)
  
    With PaintObj.Aspect
    
      If x <> c_NoMove Then
        .Left = x - m_offX + OffsetLeft
      End If
      
      If y <> c_NoMove Then
        .Top = y - m_offY + OffsetTop
      Else
      
        ' Le saco el offset ya que la primitiva
        ' se lo va a agregar, y como no permito
        ' que se mueva verticlamente, no tomo la
        ' coordenada de la pantalla, sino que mantengo
        ' la posicion del control sobre el eje Y
        '
        .Top = .Top - PaintObj.Aspect.OffSet
      End If
  
      ' Solo los controles se mueven en todas direcciones
      ' Refresco en el reporte
      If PaintObj.RptType = CSReportPaint2.csRptPaintRptType.csRptPaintRptTypeControl Then
        Set RptCtrlAspect = m_Report.Controls.Item(PaintObj.Tag).Label.Aspect
        RptCtrlAspect.Left = .Left
        RptCtrlAspect.Top = .Top
        RptCtrlAspect.Width = .Width
        RptCtrlAspect.Height = .Height
      End If
  
    End With
  
    MoveControl m_vSelectedKeys(i)
  Next
End Sub

Private Sub pMoveHorizontal(ByVal x As Single)
  m_DataHasChanged = True
  m_Paint.GetPaintObject(m_KeyMoving).Aspect.Left = x - m_offX
End Sub

Private Sub pMoveVertical(ByVal x As Single, ByVal y As Single)
  Dim sKeySection     As String
  Dim RptType         As CSReportPaint2.csRptPaintRptType
  
  Dim MaxBottom As Long
  Dim MinBottom As Long
  
  Dim RptSec    As CSReportDll2.cReportSection
  Dim PaintObj  As CSReportPaint2.cReportPaintObject
  Dim IsSecLn   As Boolean

  m_IndexSecLnMoved = -1

  Set PaintObj = m_Paint.GetPaintObject(m_KeyMoving)
  With PaintObj.Aspect


    sKeySection = PaintObj.Tag

    ' Las secciones solo pueden moverse verticalmente
    ' Siempre se mueve el tope inferior de las secciones
    ' y cuando se mueven se modifica su alto

    RptType = PaintObj.RptType


    Select Case RptType

      '---------------------
      ' HEADER
      '---------------------

      Case CSReportPaint2.csRptPaintRptType.csRptPaintRptTypeMainSectionHeader, _
           CSReportPaint2.csRptPaintRptType.csRptPaintRptTypeSectionHeader

        Set RptSec = pMoveHeader(sKeySection, MinBottom, MaxBottom, False)
        
      '---------------------
      ' GROUP HEADER
      '---------------------
      
      Case CSReportPaint2.csRptPaintRptType.csRptPaintRptTypeGroupSectionHeader

        Set RptSec = pMoveGroupHeader(sKeySection, MinBottom, MaxBottom, False)
        
      '---------------------
      ' DETAIL
      '---------------------

      Case CSReportPaint2.csRptPaintRptType.csRptPaintRptTypeMainSectionDetail, _
           CSReportPaint2.csRptPaintRptType.csRptPaintRptTypeSectionDetail

        Set RptSec = pMoveDetails(sKeySection, MinBottom, MaxBottom, False)
        
      '---------------------
      ' GROUP FOOTER
      '---------------------

      Case CSReportPaint2.csRptPaintRptType.csRptPaintRptTypeGroupSectionFooter
      
        Set RptSec = pMoveGroupFooter(sKeySection, MinBottom, MaxBottom, False)

      '---------------------
      ' FOOTER
      '---------------------
      
      Case CSReportPaint2.csRptPaintRptType.csRptPaintRptTypeMainSectionFooter, _
           CSReportPaint2.csRptPaintRptType.csRptPaintRptTypeSectionFooter
        
        Set RptSec = pMoveFooter(sKeySection, MinBottom, MaxBottom, False)
      
      '---------------------
      ' Section Lines
      '---------------------
      Case C_KEY_SECLN_HEADER
        sKeySection = PaintObj.RptKeySec
        Set RptSec = pMoveHeader(sKeySection, MinBottom, MaxBottom, True)
        IsSecLn = True
        
      Case C_KEY_SECLN_GROUPH
        sKeySection = PaintObj.RptKeySec
        Set RptSec = pMoveGroupHeader(sKeySection, MinBottom, MaxBottom, True)
        IsSecLn = True
      
      Case C_KEY_SECLN_DETAIL
        sKeySection = PaintObj.RptKeySec
        Set RptSec = pMoveDetails(sKeySection, MinBottom, MaxBottom, True)
        IsSecLn = True
        
      Case C_KEY_SECLN_GROUPF
        sKeySection = PaintObj.RptKeySec
        Set RptSec = pMoveGroupFooter(sKeySection, MinBottom, MaxBottom, True)
        IsSecLn = True
        
      Case C_KEY_SECLN_FOOTER
        sKeySection = PaintObj.RptKeySec
        Set RptSec = pMoveFooter(sKeySection, MinBottom, MaxBottom, True)
        IsSecLn = True
        m_IndexSecLnMoved = RptSec.SectionLines(PaintObj.Tag).RealIndice
        
    End Select
    
    If IsSecLn Then
      MinBottom = pGetMinBottomForSecLn(RptSec, _
                                        PaintObj.Tag, _
                                        MinBottom)
      pChangeSecLnHeight PaintObj, y, _
                         MinBottom, MaxBottom, _
                         RptSec.SectionLines(PaintObj.Tag)
      
      y = RptSec.Aspect.Top _
          - PaintObj.Aspect.OffSet _
          + pGetSecHeigthFromSecLines(RptSec) _
          - C_Height_Bar_Section
          
      m_offY = 0
      Set PaintObj = m_Paint.PaintSections(RptSec.KeyPaint)
    End If

  End With

  MoveSection PaintObj, _
              x, _
              y, _
              MinBottom, _
              MaxBottom, _
              RptSec, False
End Sub

Private Function pGetSecHeigthFromSecLines(ByRef Sec As CSReportDll2.cReportSection) As Long
  Dim SecLn As CSReportDll2.cReportSectionLine
  Dim rtn   As Long
  
  For Each SecLn In Sec.SectionLines
    rtn = rtn + SecLn.Aspect.Height
  Next
  
  pGetSecHeigthFromSecLines = rtn
End Function

Private Function pGetMinBottomForSecLn(ByRef Sec As CSReportDll2.cReportSection, _
                                       ByVal SecLnKey As String, _
                                       ByVal MinBottom As Long) As Long
                                       
  Dim SecLn As CSReportDll2.cReportSectionLine
  
  For Each SecLn In Sec.SectionLines
    If SecLn.Key = SecLnKey Then Exit For
    MinBottom = MinBottom + SecLn.Aspect.Height
  Next
  pGetMinBottomForSecLn = MinBottom
End Function

Private Sub pChangeSecLnHeight(ByRef PaintObj As CSReportPaint2.cReportPaintObject, _
                               ByVal y As Single, _
                               ByVal MinBottom As Long, ByVal MaxBottom As Long, _
                               ByRef SecLn As CSReportDll2.cReportSectionLine)
  
  With PaintObj.Aspect
    
    ' Si Y esta dentro del rango permitido todo bien
    If y >= MinBottom And y <= MaxBottom Then
      .Top = y - m_offY

    ' Sino
    Else
      ' Si se fue para arriba
      If y < MinBottom Then
        .Top = MinBottom

      ' Si se fue para abajo
      Else
        .Top = MaxBottom
      End If
    End If
    
    ' Como el top lo acabo de setear a dimensiones reales
    ' de la pantalla ahora lo tengo que desplazar al offset
    ' correspondiente a su seccion
    .Top = .Top + .OffSet

    m_Paint.AlingToGrid PaintObj.Key

    ' Cambio el Height de la SectionLine
    SecLn.Aspect.Height = .Top + C_Height_Bar_Section - SecLn.Aspect.Top
  End With
End Sub

Private Sub pSizingControl(ByVal x As Single, ByVal y As Single)
  Dim i           As Long
  Dim Height      As Long
  Dim Width       As Long
  Dim Left        As Long
  Dim Top         As Long
  
  If UBound(m_vSelectedKeys) = 0 Then Exit Sub
  
  m_DataHasChanged = True
  
  ' Primero modifico el control que sufrio cambios en su tamaño
  '
  With m_Paint.GetPaintObject(m_KeySizing)
    With .Aspect
  
      ' Guardo los tamaños originales
      ' para saber cuanto cambio
      '
      Height = .Height
      Width = .Width
      Left = .Left
      Top = .Top
    
      Select Case m_MoveType
        Case CSRptEditroMoveType.csRptEdMovDown
          .Height = y - (.Top - .OffSet)
        Case CSRptEditroMoveType.csRptEdMovLeft
          .Width = .Width + .Left - x
          .Left = x
        Case CSRptEditroMoveType.csRptEdMovRight
          .Width = x - .Left
        Case CSRptEditroMoveType.csRptEdMovUp
          .Height = .Height + (.Top - .OffSet) - y
          .Top = y + .OffSet
        Case CSRptEditroMoveType.csRptEdMovLeftDown
          .Height = y - (.Top - .OffSet)
          .Width = .Width + .Left - x
          .Left = x
        Case CSRptEditroMoveType.csRptEdMovLeftUp
          .Height = .Height + (.Top - .OffSet) - y
          .Top = y + .OffSet
          .Width = .Width + .Left - x
          .Left = x
        Case CSRptEditroMoveType.csRptEdMovRightDown
          .Width = x - .Left
          .Height = y - (.Top - .OffSet)
        Case CSRptEditroMoveType.csRptEdMovRightUp
          .Height = .Height + (.Top - .OffSet) - y
          .Top = y + .OffSet
          .Width = x - .Left
      End Select
      
      Top = .Top - Top
      Left = .Left - Left
      Width = .Width - Width
      Height = .Height - Height
    End With
    
    pMoveControl .Aspect, True
  End With
  
  For i = 1 To UBound(m_vSelectedKeys)
    
    If m_KeySizing <> m_vSelectedKeys(i) Then
    
      With m_Paint.GetPaintObject(m_vSelectedKeys(i))
        With .Aspect
        
          .Height = .Height + Height
          .Top = .Top + Top
          .Width = .Width + Width
          .Left = .Left + Left
        End With
      
        pMoveControl .Aspect, False
      End With
    End If
  Next
End Sub

Private Sub pMoveControl(ByRef Aspect As CSReportPaint2.cReportAspect, _
                         ByVal bSizing As Boolean)
  Const c_min_width As Long = 10
  Const C_MIN_HEIGHT As Long = 10
  
  Dim RptCtrlAspect As CSReportDll2.cReportAspect
  
  With Aspect
  
    If m_Paint.GetPaintObject(m_KeySizing).RptType = CSReportPaint2.csRptPaintRptTypeControl Then
      Set RptCtrlAspect = m_Report.Controls.Item(m_Paint.GetPaintObject(m_KeySizing).Tag).Label.Aspect
      RptCtrlAspect.Left = .Left
      If Not bSizing Then
        RptCtrlAspect.Top = .Top + .OffSet
      Else
        RptCtrlAspect.Top = .Top
      End If
      RptCtrlAspect.Width = .Width
      RptCtrlAspect.Height = .Height
    End If
  
    Select Case m_MoveType
      Case CSRptEditroMoveType.csRptEdMovDown
        m_Paint.AlingObjBottomToGrid m_KeySizing
      Case CSRptEditroMoveType.csRptEdMovLeft
        m_Paint.AlingObjLeftToGrid m_KeySizing
      Case CSRptEditroMoveType.csRptEdMovRight
        m_Paint.AlingObjRightToGrid m_KeySizing
      Case CSRptEditroMoveType.csRptEdMovUp
        m_Paint.AlingObjTopToGrid m_KeySizing
      Case CSRptEditroMoveType.csRptEdMovLeftDown
        m_Paint.AlingObjLeftBottomToGrid m_KeySizing
      Case CSRptEditroMoveType.csRptEdMovLeftUp
        m_Paint.AlingObjLeftTopToGrid m_KeySizing
      Case CSRptEditroMoveType.csRptEdMovRightDown
        m_Paint.AlingObjRightBottomToGrid m_KeySizing
      Case CSRptEditroMoveType.csRptEdMovRightUp
        m_Paint.AlingObjRightTopToGrid m_KeySizing
    End Select
  
    ' Validaciones :
  
    ' Width no puede ser menor a C_MIN_WIDTH
    If .Width < c_min_width Then .Width = c_min_width
    ' Height no puede ser menor a C_MIN_HEIGHT
    If .Height < C_MIN_HEIGHT Then .Height = C_MIN_HEIGHT
  End With
End Sub

Private Function pMoveHeader(ByVal sKeySection As String, _
                        ByRef MinBottom As Long, _
                        ByRef MaxBottom As Long, _
                        ByVal IsForSectionLine As Boolean) As CSReportDll2.cReportSection
                        
  Dim Indice          As Long
  Dim RptSec          As CSReportDll2.cReportSection
    
  Set RptSec = m_Report.Headers.Item(sKeySection)

  Indice = RptSec.RealIndice

  '-----------
  ' MinBottom
  '-----------
  If Indice = 1 Then
    MinBottom = C_Min_Height_Section
  Else
    ' Bottom del Header anterior + C_Min_Height_Section
    With m_Report.Headers.Item(Indice - 1).Aspect
      MinBottom = .Top + .Height + C_Min_Height_Section
    End With
  End If
  
  If Not IsForSectionLine Then
    MinBottom = pGetMinBottomWithSecLn(RptSec.SectionLines, MinBottom)
  End If
  
  MaxBottom = PicBody.Height
  
  Set pMoveHeader = RptSec
End Function

Private Function pMoveGroupHeader(ByVal sKeySection As String, _
                        ByRef MinBottom As Long, _
                        ByRef MaxBottom As Long, _
                        ByVal IsForSectionLine As Boolean) As CSReportDll2.cReportSection
                        
  Dim Indice          As Long
  Dim RptSec          As CSReportDll2.cReportSection
  
  Set RptSec = m_Report.GroupsHeaders.Item(sKeySection)
  
  Indice = RptSec.RealIndice

  '-----------
  ' MinBottom
  '-----------
  If Indice = 1 Then
    ' Bottom del ultimo Header + C_Min_Height_Section
    With m_Report.Headers
      With .Item(.Count).Aspect
        MinBottom = .Height + .Top + C_Min_Height_Section
      End With
    End With
  Else
    ' Bottom del GroupHeader anterior + C_Min_Height_Section
    With m_Report.GroupsHeaders.Item(Indice - 1).Aspect
      MinBottom = .Height + .Top + C_Min_Height_Section
    End With
  End If
  
  If Not IsForSectionLine Then
    MinBottom = pGetMinBottomWithSecLn(RptSec.SectionLines, MinBottom)
  End If

  MaxBottom = PicBody.Height
  
  Set pMoveGroupHeader = RptSec
End Function

Private Function pMoveDetails(ByVal sKeySection As String, _
                        ByRef MinBottom As Long, _
                        ByRef MaxBottom As Long, _
                        ByVal IsForSectionLine As Boolean) As CSReportDll2.cReportSection
                        
  Dim Indice          As Long
  Dim RptSec          As CSReportDll2.cReportSection
  
  Set RptSec = m_Report.Details.Item(sKeySection)

  Indice = RptSec.RealIndice

  '-----------
  ' MinBottom
  '-----------

  If Indice = 1 Then
    ' Si hay grupos
    If m_Report.GroupsHeaders.Count > 0 Then
      ' Top del ultimo GroupHeader + C_Min_Height_Section
      With m_Report.GroupsHeaders
        With .Item(.Count).Aspect
          MinBottom = .Height + .Top + C_Min_Height_Section
        End With
      End With
    Else
      ' Top del ultimo Header + C_Min_Height_Section
      With m_Report.Headers
        With .Item(.Count).Aspect
          MinBottom = .Height + .Top + C_Min_Height_Section
        End With
      End With
    End If
  Else
    ' Top del Detail anterior + C_Min_Height_Section
    With m_Report.Details.Item(Indice - 1).Aspect
      MinBottom = .Height + .Top + C_Min_Height_Section
    End With
  End If
    
  If Not IsForSectionLine Then
    MinBottom = pGetMinBottomWithSecLn(RptSec.SectionLines, MinBottom)
  End If
  
  MaxBottom = PicBody.Height
  
  Set pMoveDetails = RptSec
End Function

Private Function pMoveGroupFooter(ByVal sKeySection As String, _
                        ByRef MinBottom As Long, _
                        ByRef MaxBottom As Long, _
                        ByVal IsForSectionLine As Boolean) As CSReportDll2.cReportSection
                        
  Dim Indice          As Long
  Dim RptSec          As CSReportDll2.cReportSection
  
  Set RptSec = m_Report.GroupsFooters.Item(sKeySection)

  Indice = RptSec.RealIndice

  '-----------
  ' MinBottom
  '-----------
  If Indice = 1 Then
    ' Bottom del ultimo Detail + C_Min_Height_Section
    With m_Report.Details
      With .Item(.Count).Aspect
        MinBottom = .Height + .Top + C_Min_Height_Section
      End With
    End With
  Else
    ' Bottom del GroupFooter anterior + C_Min_Height_Section
    With m_Report.GroupsFooters.Item(Indice - 1).Aspect
      MinBottom = .Height + .Top + C_Min_Height_Section
    End With
  End If
  
  If Not IsForSectionLine Then
    MinBottom = pGetMinBottomWithSecLn(RptSec.SectionLines, MinBottom)
  End If
  MaxBottom = PicBody.Height
  
  Set pMoveGroupFooter = RptSec
End Function

' El parametro IsForSectionLine indica que solo se debe dar el top
' de la seccion + C_Min_Height_Section, ya que a dicho valor
' se le agregara el alto de las SectionLines que corresponda
' en la invocante
Private Function pMoveFooter(ByVal sKeySection As String, _
                        ByRef MinBottom As Long, _
                        ByRef MaxBottom As Long, _
                        ByVal IsForSectionLine As Boolean) As CSReportDll2.cReportSection
                        
  Dim Indice    As Long
  Dim RptSec    As CSReportDll2.cReportSection
  
  Set RptSec = m_Report.Footers.Item(sKeySection)

  Indice = RptSec.RealIndice
  
  '-----------
  ' MinBottom
  '-----------
  If Indice = 1 Then
    ' Si hay grupos
    If m_Report.GroupsFooters.Count > 0 Then
      ' El bottom del ultimo GroupFooter
      With m_Report.GroupsFooters
        With .Item(.Count).Aspect
          MinBottom = .Height + .Top + C_Min_Height_Section
        End With
      End With
    Else
      ' Bottom del ultimo Detail
      With m_Report.Details
        With .Item(.Count).Aspect
          MinBottom = .Height + .Top + C_Min_Height_Section
        End With
      End With
    End If
  Else
    ' Bottom del anterior Footer
    With m_Report.Footers.Item(Indice - 1).Aspect
      MinBottom = .Height + .Top - m_OffSet + C_Min_Height_Section
    End With
  End If
  
  If Not IsForSectionLine Then
    MinBottom = pGetMinBottomWithSecLn(RptSec.SectionLines, MinBottom)
  End If
  
  MaxBottom = PicBody.Height
  
  Set pMoveFooter = RptSec
End Function

Private Function pGetMinBottomWithSecLn(ByRef SecLns As CSReportDll2.cReportSectionLines, ByVal MinBottom As Long) As Long
  Dim i As Long
  
  For i = 1 To SecLns.Count - 1
    MinBottom = MinBottom + SecLns(i).Aspect.Height
  Next
  
  pGetMinBottomWithSecLn = MinBottom
End Function

Private Sub pGetOffSet(ByVal RealPageHeight As Single, Optional ByRef rtnPageHeight As Single)
  Dim Sec As CSReportDll2.cReportSection
  
  rtnPageHeight = 0
  
  For Each Sec In m_Report.Headers
    rtnPageHeight = rtnPageHeight + Sec.Aspect.Height
  Next
  
  For Each Sec In m_Report.GroupsHeaders
    rtnPageHeight = rtnPageHeight + Sec.Aspect.Height
  Next
  
  For Each Sec In m_Report.Details
    rtnPageHeight = rtnPageHeight + Sec.Aspect.Height
  Next
  
  For Each Sec In m_Report.GroupsFooters
    rtnPageHeight = rtnPageHeight + Sec.Aspect.Height
  Next
  
  For Each Sec In m_Report.Footers
    rtnPageHeight = rtnPageHeight + Sec.Aspect.Height
  Next
  
  m_OffSet = RealPageHeight - rtnPageHeight
  
  If m_OffSet < 0 Then m_OffSet = 0
End Sub

Private Sub pRefreshOffSetInPaintObjs()
  Dim Sec       As CSReportDll2.cReportSection
  Dim SecLines  As CSReportDll2.cReportSectionLine
  Dim Ctl       As CSReportDll2.cReportControl
  
  With m_Paint.PaintSections
    For Each Sec In m_Report.Footers
      .Item(Sec.KeyPaint).Aspect.OffSet = m_OffSet
      For Each SecLines In Sec.SectionLines
        If SecLines.KeyPaint <> vbNullString Then
          .Item(SecLines.KeyPaint).Aspect.OffSet = m_OffSet
        End If
        For Each Ctl In SecLines.Controls
          With m_Paint.PaintObjects.Item(Ctl.KeyPaint)
            .Aspect.OffSet = m_OffSet
          End With
        Next
      Next
    Next
  End With
End Sub

' Si hizo click con el boton derecho sobre un control
' que no pertenece al grupo de los seleccionados
' vacio la lista de seleccionados y pongo como unico
' elemento de la lista al control sobre el que se hizo click
Private Function pSetSelectForRightBttn() As Boolean
  Dim i As Long
  For i = 1 To UBound(m_vSelectedKeys)
    If m_vSelectedKeys(i) = m_KeyObj Then Exit Function
  Next
  
  ReDim m_vSelectedKeys(1)
  m_vSelectedKeys(1) = m_KeyObj
  
  pSetSelectForRightBttn = True
End Function

Private Sub pValidateSectionAspect()
  Dim Sec     As CSReportDll2.cReportSection
  Dim Top     As Long
  Dim i       As Long
  
  
  For Each Sec In m_Report.Headers
    Top = pValidateSectionAspecAux(Top, Sec)
  Next

  For Each Sec In m_Report.GroupsHeaders
    Top = pValidateSectionAspecAux(Top, Sec)
  Next

  For Each Sec In m_Report.Details
    Top = pValidateSectionAspecAux(Top, Sec)
  Next

  For Each Sec In m_Report.GroupsFooters
    Top = pValidateSectionAspecAux(Top, Sec)
  Next
  
  With m_Report.PaperInfo
    Top = GetRectFromPaperSize(m_Report.PaperInfo, .PaperSize, .Orientation).Height
  End With
  
  For i = m_Report.Footers.Count To 1 Step -1
    Set Sec = m_Report.Footers(i)
    Top = Top - Sec.Aspect.Height
    pValidateSectionAspecAux Top, Sec
  Next
End Sub

Private Function pValidateSectionAspecAux(ByVal Top As Long, _
                                          ByRef Sec As CSReportDll2.cReportSection) As Long
                                          
  Dim SecLn   As CSReportDll2.cReportSectionLine
  Dim TopLn   As Long
  Dim i       As Long
  Dim SecLnHeight  As Long
  Dim Width   As Long
  
  With m_Report.PaperInfo
    Width = GetRectFromPaperSize(m_Report.PaperInfo, .PaperSize, .Orientation).Width
  End With
  
  TopLn = Top
  
  For i = 1 To Sec.SectionLines.Count - 1
    Set SecLn = Sec.SectionLines(i)
    With SecLn.Aspect
      .Top = TopLn
      .Width = Width
      If .Height < C_Min_Height_Section Then
        .Height = C_Min_Height_Section
      End If
      TopLn = TopLn + .Height
      SecLnHeight = SecLnHeight + .Height
    End With
  Next
  
  With Sec.SectionLines
    Set SecLn = .Item(.Count)
  End With
  
  With SecLn.Aspect
    .Top = TopLn
    .Height = Sec.Aspect.Height - SecLnHeight
    If .Height < C_Min_Height_Section Then
      .Height = C_Min_Height_Section
    End If
    SecLnHeight = SecLnHeight + .Height
  End With
  
  With Sec.Aspect
    .Height = SecLnHeight
    If .Height < C_Min_Height_Section Then
      .Height = C_Min_Height_Section
    End If
    .Width = Width
    .Top = Top
    TopLn = Top
    Top = Top + .Height
  End With
  
  pValidateSectionAspecAux = Top
  
  pChangeTopSection Sec, 0, False, False
End Function

Public Sub ShowControls()
  On Error GoTo ControlError
  
  DoEvents

  Set m_fControls = GetCtrlBox(Me)
  
  ClearCtrlBox Me

  Dim Ctrl As CSReportDll2.cReportControl

  m_fControls.AddCtrls m_Report
  
  m_fControls.Show vbModeless, fMain
  
  GoTo ExitProc
ControlError:

  MngError Err(), "ShowControls", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Public Sub ShowControlsTree()
  On Error GoTo ControlError
  
  DoEvents

  Set m_fTreeCtrls = GetCtrlTreeBox(Me)
  
  ClearCtrlTreeBox Me

  Dim Ctrl As CSReportDll2.cReportControl

  m_fTreeCtrls.AddCtrls m_Report
  
  m_fTreeCtrls.Show vbModeless
  
  GoTo ExitProc
ControlError:

  MngError Err(), "ShowControlsTree", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub pSetInitDir()
  On Error Resume Next
  If gbFirstOpen Then
    gbFirstOpen = False
    fMain.cmDialog.InitDir = gWorkFolder
  End If
End Sub

' construccion - destruccion

'///////////////////////////////////////////////////////////////////////////////////////////////
'
'
'
' Carga y Descarga
'
'
'
'

Private Sub Form_Load()
  On Error Resume Next
  
  picTop.Top = 0
  picTop.Left = 0
  picTop.Height = C_TopBody
  lnLeft.y1 = -50
  lnLeft.X1 = PicRule.Width - 80
  lnLeft.X2 = lnLeft.X1
  ReDim m_vSelectedKeys(0)
  ReDim m_vCopyKeys(0)
  m_CopyControls = False
  m_CopyControlsFromOtherReport = False
  m_TypeGrid = CSReportPaint2.csEGridPoints
  m_KeyboardMoveStep = 50
  
  Me.lnLeft.BorderColor = gBackColor
  Me.BackColor = gBackColor
  Me.picTop.BackColor = gBackColor
  Me.PicRule.BackColor = gLeftBarColor
  Me.PicRule.Visible = Not gHideLeftBar

End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
  Cancel = Not SaveChanges()
  If Cancel Then SetDocActive Me
End Sub

Private Sub Form_Unload(Cancel As Integer)
  On Error Resume Next

  ' Destruyo los objetos que poseeo
  
  If fMain.ReportCopySource Is Me Then
    Set fMain.ReportCopySource = Nothing
  End If
  
  Set m_Report = Nothing
  Set m_Paint = Nothing
  Set m_fToolBox = Nothing
  Set m_fControls = Nothing
  Set m_fTreeCtrls = Nothing
  Set m_fConnectsAux = Nothing
  Set m_fProperties = Nothing
  Set m_fFormula = Nothing
  Set m_fGroup = Nothing
  Unload m_fProgress
  Set m_fProgress = Nothing
  SetDocInacActive Me
  If fSearch.fReport Is Me Then
    Set fSearch.fReport = Nothing
  End If
  ReDim m_vSelectedKeys(0)
  ReDim m_vCopyKeys(0)

End Sub

Public Sub Init()
  m_ShowingProperties = False

  Dim oLaunchInfo As CSReportDll2.cReportLaunchInfo
  Set m_Report = New CSReportDll2.cReport
  Set oLaunchInfo = New CSReportDll2.cReportLaunchInfo

  m_Report.PaperInfo.PaperSize = fMain.PaperSize
  m_Report.PaperInfo.Orientation = fMain.Orientation

  Set oLaunchInfo.Printer = GetcPrinterFromDefaultPrinter
  Set oLaunchInfo.ObjPaint = New CSReportPaint2.cReportPrint
  If Not m_Report.Init(oLaunchInfo) Then Exit Sub

  Dim File As New CSKernelFile.cFile

  m_Report.PathDefault = File.GetPath(App.Path)
  Set File = Nothing

  PicBody.Top = C_TopBody
  PicRule.Left = 0
  PicBody.Left = pGetLeftBody

  m_KeyMoving = vbNullString
  m_KeySizing = vbNullString
  m_KeyObj = vbNullString
  m_KeyFocus = vbNullString
  m_NextNameCtrl = 0

  Title = "CSReportEditor"

  Set m_Paint = New CSReportPaint2.cReportPaint
  
  Dim tR As Rectangle
  With m_Report.PaperInfo
    tR = GetRectFromPaperSize(m_Report.PaperInfo, .PaperSize, .Orientation)
  End With
  CreateStandarSections m_Report, tR ' GetRectFromPrinter(Printer)
  m_Paint.GridHeight = pSetSizePics(tR.Height)
  m_Paint.InitGrid PicBody, m_TypeGrid
  
  PaintStandarSections

  m_DataHasChanged = False

  ScrHorizontal.Min = -4
  ScrVertical.Min = -4

  PicBody.ZOrder
  PicRule.ZOrder
  PicRightCorner.ZOrder
  ScrHorizontal.ZOrder
  ScrVertical.ZOrder

  SizeControls
  ScrVertical_Change
  ScrHorizontal_Change
End Sub

Private Sub pUpdateFormulas(ByVal CurrentName As String, _
                            ByVal NewName As String)
  Dim i         As Long
  Dim RptCtrl   As CSReportDll2.cReportControl

  For i = 1 To m_Report.Controls.Count

    Set RptCtrl = m_Report.Controls.Item(i)

    With RptCtrl
      With .FormulaHide
        If .Text <> vbNullString Then
          If InStr(1, .Text, CurrentName) Then
            .Text = pReplaceInFormula(.Text, _
                                      CurrentName, _
                                      NewName)
          End If
        End If
      End With
      With .FormulaValue
        If .Text <> vbNullString Then
          If InStr(1, .Text, CurrentName) Then
            .Text = pReplaceInFormula(.Text, _
                                      CurrentName, _
                                      NewName)
          End If
        End If
      End With
    End With
  Next
End Sub

Private Function pReplaceInFormula(ByVal FormulaText As String, _
                                   ByVal CurrentName As String, _
                                   ByVal NewName As String) As String
  
  ' Si no se trata de una funcion interna
  ' le permitimos al usuario aceptar o cancelar
  ' nuestra edicion
  '
  If Left$(Trim$(FormulaText), 1) <> "_" Then
    Dim fReplace As fFormulaReplace
    Set fReplace = New fFormulaReplace
    fReplace.ctxCurrFormula.Text = FormulaText
    fReplace.ctxNewFormula.Text = Replace(FormulaText, _
                                           CurrentName, _
                                           NewName)
    fReplace.Show vbModal
    If fReplace.Ok Then
      pReplaceInFormula = fReplace.ctxNewFormula.Text
    Else
      pReplaceInFormula = FormulaText
    End If
    Unload fReplace
  
  Else
  
    pReplaceInFormula = Replace(FormulaText, _
                                CurrentName, _
                                NewName)
  End If
End Function

Private Sub Form_Activate()
  SetDocActive Me
  If fToolbox.Loaded Then
    If Not GetToolBox(Me) Is Nothing Then ShowToolBox
  End If
  If fControls.Loaded Then
    If Not GetCtrlBox(Me) Is Nothing Then ShowControls
  End If
End Sub

Private Sub Form_Deactivate()
  SetDocInacActive Me
  ClearToolBox Me
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

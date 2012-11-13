VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Object = "{AAE806BF-0AA4-415D-8EAA-4F0A32FF6B71}#1.7#0"; "CSControls2.ocx"
Begin VB.Form fListDoc 
   Caption         =   "Listado"
   ClientHeight    =   7845
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   8850
   ControlBox      =   0   'False
   Icon            =   "fListDoc.frx":0000
   KeyPreview      =   -1  'True
   LinkTopic       =   "Form1"
   MDIChild        =   -1  'True
   ScaleHeight     =   7845
   ScaleWidth      =   8850
   Begin VB.Timer tmSearch 
      Enabled         =   0   'False
      Interval        =   1000
      Left            =   2640
      Top             =   7080
   End
   Begin VB.PictureBox picSearchResult 
      BorderStyle     =   0  'None
      Height          =   4755
      Left            =   2220
      ScaleHeight     =   4755
      ScaleWidth      =   5475
      TabIndex        =   5
      Top             =   960
      Width           =   5475
      Begin MSComctlLib.ListView lvSearchResult 
         Height          =   2595
         Left            =   660
         TabIndex        =   6
         Top             =   1500
         Width           =   3795
         _ExtentX        =   6694
         _ExtentY        =   4577
         LabelWrap       =   -1  'True
         HideSelection   =   -1  'True
         _Version        =   393217
         ForeColor       =   -2147483640
         BackColor       =   -2147483643
         Appearance      =   0
         NumItems        =   0
      End
      Begin VB.Shape shSearchResult 
         BackColor       =   &H000080FF&
         BackStyle       =   1  'Opaque
         BorderStyle     =   0  'Transparent
         Height          =   3495
         Left            =   360
         Top             =   900
         Width           =   4575
      End
   End
   Begin VB.Timer tmResize 
      Left            =   3120
      Top             =   7080
   End
   Begin MSComctlLib.Toolbar tbrTool 
      Align           =   1  'Align Top
      Height          =   420
      Left            =   0
      TabIndex        =   1
      Top             =   0
      Width           =   8850
      _ExtentX        =   15610
      _ExtentY        =   741
      ButtonWidth     =   609
      ButtonHeight    =   582
      Appearance      =   1
      _Version        =   393216
      Begin VB.PictureBox picSearch 
         BorderStyle     =   0  'None
         Height          =   2955
         Left            =   2220
         ScaleHeight     =   2955
         ScaleWidth      =   6495
         TabIndex        =   2
         Top             =   0
         Visible         =   0   'False
         Width           =   6495
         Begin VB.ComboBox cbFilter 
            Height          =   315
            Left            =   3480
            Style           =   2  'Dropdown List
            TabIndex        =   7
            Top             =   0
            Width           =   1755
         End
         Begin VB.TextBox txSearch 
            BorderStyle     =   0  'None
            Height          =   285
            Left            =   600
            TabIndex        =   4
            Top             =   0
            Width           =   2835
         End
         Begin VB.CommandButton cmdSearch 
            Caption         =   "Buscar"
            Height          =   435
            Left            =   5280
            TabIndex        =   3
            Top             =   0
            Width           =   855
         End
         Begin VB.Shape shSearch 
            BackColor       =   &H000080FF&
            BackStyle       =   1  'Opaque
            BorderStyle     =   0  'Transparent
            Height          =   435
            Left            =   540
            Top             =   0
            Width           =   2955
         End
      End
   End
   Begin CSControls2.cListDoc cListDoc1 
      Height          =   5415
      Left            =   360
      TabIndex        =   0
      Top             =   1320
      Width           =   7575
      _ExtentX        =   13361
      _ExtentY        =   9551
      HelpType        =   2
   End
   Begin MSComctlLib.ImageList ImgTree 
      Left            =   3600
      Top             =   6960
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483643
      ImageWidth      =   16
      ImageHeight     =   16
      MaskColor       =   12632256
      _Version        =   393216
      BeginProperty Images {2C247F25-8591-11D1-B16A-00C0F0283628} 
         NumListImages   =   2
         BeginProperty ListImage1 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fListDoc.frx":0A02
            Key             =   ""
         EndProperty
         BeginProperty ListImage2 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fListDoc.frx":0F9C
            Key             =   ""
         EndProperty
      EndProperty
   End
End
Attribute VB_Name = "fListDoc"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
'--------------------------------------------------------------------------------
' fListDoc
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
Private Const C_Module = "fListDoc"

Private Const IMG_Active_TRUE = 3
Private Const IMG_Active_FALSE = 4

Private Const c_HelpFilterBeginLike = 1
Private Const c_HelpFilterHaveTo = 2
Private Const c_HelpFilterWildcard = 3
Private Const c_HelpFilterEndLike = 4
Private Const c_HelpFilterIsLike = 5

' estructuras
' variables privadas
Private m_Name              As String
Private m_Buttons1          As Long
Private m_Buttons2          As Long
Private m_Buttons3          As Long
Private m_IconText          As Integer

Private m_ObjEditName       As String
Private m_ObjABMName        As String

Private m_ObjListNombre     As String
Private m_ObjListABMNombre  As String

'
' Referencias al objeto ListDoc
' (las dos variables apuntan al mismo objeto.
'  se necesitan para acceder a las distintas interfaces)
'
  ' Interfaz publica
  '
  Private m_listObj           As Object
  ' Interfaz cIEditGenericListDoc
  '
  Private m_ListObject        As cIEditGenericListDoc

Private m_done              As Boolean

Private m_AuxParam          As String

Private m_Initiated         As Boolean

' Preferencias del Usuario
'
Private m_UserCfg           As cUsuarioConfig

'
' Search
'
Private m_searchId          As String
Private m_searchName        As String
Private m_searchCode        As String
Private m_searchOk          As Boolean
Private m_bDontClick        As Boolean
Private m_Grid              As cListView
Private m_rs                As ADODB.Recordset
Private m_haveTop           As Boolean
Private m_LastChange        As Single
Private m_FilterType        As Long
Private m_Searched          As String
Private m_bDontHideResults  As Boolean

Private m_helpLD            As cHelpLD

' propiedades privadas
Private Property Get ObjEdit() As cIEditGeneric
  On Error GoTo ControlError
  
  Set ObjEdit = GetObjectEdit
  Exit Property
ControlError:
  MngError Err, "ObjEdit", "fListDoc", ""
End Property

' propiedades publicas
Public Property Let AuxParam(ByVal rhs As String)
  m_AuxParam = rhs
End Property

Public Property Get ObjEditName() As String
  ObjEditName = m_ObjEditName
End Property
Public Property Let ObjEditName(ByVal rhs As String)
  m_ObjEditName = rhs
End Property

Public Property Get ObjListNombre() As String
  ObjListNombre = m_ObjListNombre
End Property
Public Property Let ObjListNombre(ByVal rhs As String)
  m_ObjListNombre = rhs
End Property

Public Property Get ObjListABMNombre() As String
  ObjListABMNombre = m_ObjListABMNombre
End Property
Public Property Let ObjListABMNombre(ByVal rhs As String)
  m_ObjListABMNombre = rhs
End Property

Public Property Get ObjABMName() As String
  ObjABMName = m_ObjABMName
End Property
Public Property Let ObjABMName(ByVal rhs As String)
  m_ObjABMName = rhs
End Property

Public Property Get NameEdit() As String
  NameEdit = m_Name
End Property
Public Property Let NameEdit(ByVal rhs As String)
  m_Name = rhs
End Property
Public Property Get Buttons1() As Long
  Buttons1 = m_Buttons1
End Property
Public Property Let Buttons1(ByVal rhs As Long)
  m_Buttons1 = rhs
End Property
Public Property Get Buttons2() As Long
  Buttons2 = m_Buttons2
End Property
Public Property Let Buttons2(ByVal rhs As Long)
  m_Buttons2 = rhs
End Property
Public Property Get Buttons3() As Long
  Buttons3 = m_Buttons3
End Property
Public Property Let Buttons3(ByVal rhs As Long)
  m_Buttons3 = rhs
End Property
Public Property Get IconPersona() As Integer
  IconPersona = csIMG_PERSON
End Property
Public Property Get IconRoles() As Integer
  IconRoles = csIMG_ROLS
End Property
Public Property Get IconCubo() As Integer
  IconCubo = csIMG_REDCUBE
End Property
Public Property Get IconText() As Integer
  IconText = m_IconText
End Property
Public Property Let IconText(ByVal rhs As Integer)
  m_IconText = rhs
End Property
' propiedades privadas
' funciones publicas
Public Function Init() As Boolean
  
  Caption = m_Name
  cListDoc1.NameClient = m_Name
  
  If Not m_Initiated Then
  
    cListDoc1.Buttons1 = m_Buttons1
    cListDoc1.Buttons2 = m_Buttons2
    cListDoc1.Buttons3 = m_Buttons3
    pSetToolBar
    cListDoc1.SetToolBar
    cListDoc1.IconText = m_IconText
    
  End If
  
  InitSearch
  
  pSetBackgroundColor
  
  m_Initiated = True
  Init = True
End Function

Public Sub ShowParameters()
  On Error Resume Next
  
  Me.cListDoc1.ShowParameters
  pShowParams
  
End Sub

Private Sub pShowParams()
  CSKernelClient2.ShowToolBarButton BUTTON_WITH_PARAMS, tbrTool, False
  CSKernelClient2.ShowToolBarButton BUTTON_WITHOUT_PARAMS, tbrTool, True
End Sub

Private Sub pHideParams()
  CSKernelClient2.ShowToolBarButton BUTTON_WITH_PARAMS, tbrTool, True
  CSKernelClient2.ShowToolBarButton BUTTON_WITHOUT_PARAMS, tbrTool, False
End Sub

Public Sub HideParameters()
  On Error Resume Next
  
  Me.cListDoc1.HideParameters
  pHideParams
  
End Sub

' funciones privadas
Private Sub pSetToolBar()
  Buttons1 = Buttons1 + BUTTON_WITHOUT_PARAMS
  Buttons1 = Buttons1 + BUTTON_WITH_PARAMS
  Buttons1 = Buttons1 + BUTTON_UPDATE
  
  Buttons2 = Buttons2 + BUTTON_SAVE_PARAMS
  Buttons2 = Buttons2 + BUTTON_RELOAD_PARAMS
  
  CSKernelClient2.SetToolBar24 tbrTool, Buttons1, Buttons2, Buttons3, m_UserCfg.ViewNamesInToolbar, True
  
  pSetPositionSearchLD
  
  DoEvents
  
  Form_Resize
End Sub

Private Function GetObjectEdit() As cIEditGeneric
  Dim obj As Object
  Dim o   As cIEditGeneric

  Set obj = CSKernelClient2.CreateObject(m_ObjEditName)
  
  If LenB(m_AuxParam) Then
    obj.AuxParam = m_AuxParam
  End If
  
  Set o = obj
  Set o.ObjTree = cListDoc1
  
  Dim Editor As cIABMGeneric
  Set Editor = CSKernelClient2.CreateObject(m_ObjABMName)
  Set o.ObjAbm = Editor

  pSetGenericDoc o

  Set GetObjectEdit = o
End Function

Private Sub pSetGenericDoc(ByRef o As Object)
  Dim oDoc As cIEditGenericDoc
  If TypeOf o Is cIEditGenericDoc Then
    Set oDoc = o
    Set oDoc.Footer = CSKernelClient2.CreateObject(m_ObjABMName)
    Set oDoc.Items = CSKernelClient2.CreateObject(m_ObjABMName)
  End If
End Sub

Private Sub cbFilter_Click()
  On Error Resume Next
  If m_bDontClick Then
    m_bDontClick = False
  Else
    pSearch
  End If
End Sub

Private Sub cListDoc1_DblClick()
  On Error GoTo ControlError
  
  With cListDoc1
    If .RowIsGroup(.SelectedRow) Then Exit Sub
  End With
  
  Dim Mouse As cMouseWait
  Dim o As cIEditGeneric

  Set Mouse = New cMouseWait
  Set o = ObjEdit
  o.Edit cListDoc1.Id

  Exit Sub
ControlError:
  MngError Err, "cListDoc1_ToolBarClick", "fListDoc", ""
End Sub

Private Sub cListDoc1_GotFocus()
  On Error Resume Next
  picSearchResult.Visible = False
End Sub

Private Sub cListDoc1_HideParams()
  On Error Resume Next
  HideParameters
End Sub

Private Sub cmdSearch_Click()
  lvSearchResult_DblClick
End Sub

Private Sub Form_KeyDown(KeyCode As Integer, Shift As Integer)
  On Error GoTo ControlError

  If KeyCode = vbKeyF5 Then
    CtrlKeyRefresh
  
  ElseIf KeyCode = vbKeyF6 Then
    Dim ctl As Control
    For Each ctl In Me.cListDoc1.Controls
      If ctl.Name = "ctlHL" Then
        Dim ctlHelp As Object
        Set ctlHelp = ctl
        If ctlHelp.Table = csCliente Then
          ctlHelp.ShowHelp
          Exit For
        End If
      End If
    Next
  ElseIf KeyCode = vbKeyF7 Then
    On Error Resume Next
    If txSearch.Visible Then
      txSearch.Text = vbNullString
      txSearch.SetFocus
    End If
  Else
    ProcessVirtualKey KeyCode, Shift, Me
  End If
  
  Err.Clear
  
  Exit Sub
ControlError:
  Err.Clear
End Sub

Private Sub Form_Activate()
  ActiveBar Me
  
  If m_done Then Exit Sub
  m_done = True
  
  If cListDoc1.ParamVisible Then
    pShowParams
  Else
    pHideParams
  End If
End Sub

Private Sub Form_Deactivate()
  DeactiveBar Me
End Sub

Private Sub Form_Load()
  On Error GoTo ControlError

  Dim Editor As cIABMGenericListDoc
  Dim o As cIEditGenericListDoc
  
  Set m_listObj = CSKernelClient2.CreateObject(m_ObjListNombre)
  Set o = m_listObj
  Set Editor = CSKernelClient2.CreateObject(m_ObjListABMNombre)
  Set o.ObjAbm = Editor
  Set o.ObjList = cListDoc1
  o.ShowParams User.Id
  
  Set m_ListObject = o
  
  Set o = Nothing
  Set Editor = Nothing
  
  m_done = False
  
  On Error Resume Next
  Me.WindowState = vbMaximized
  
  ' Preferencias del Usuario
  '
  Set m_UserCfg = New cUsuarioConfig
  m_UserCfg.Load
  
  Exit Sub
ControlError:
  MngError Err, "Form_Load", "fListDoc", ""
End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
  On Error Resume Next
  tmSearch.Enabled = False
End Sub

Private Sub lvSearchResult_GotFocus()
  On Error Resume Next
  m_bDontHideResults = True
End Sub

Private Sub lvSearchResult_KeyDown(KeyCode As Integer, Shift As Integer)
  On Error Resume Next
  If KeyCode = vbKeyUp Then
    If lvSearchResult.SelectedItem Is Nothing Then Exit Sub
    If lvSearchResult.SelectedItem.Index = 1 Then
      m_bDontHideResults = True
      txSearch.SelStart = 0
      txSearch.SelLength = Len(txSearch.Text)
      txSearch.SetFocus
    End If
  End If
End Sub

Private Sub lvSearchResult_KeyUp(KeyCode As Integer, Shift As Integer)
  On Error Resume Next
  If KeyCode = vbKeyReturn Then
    lvSearchResult_DblClick
  End If
End Sub

Private Sub lvSearchResult_LostFocus()
  On Error Resume Next
  If m_bDontHideResults Then
    m_bDontHideResults = False
  Else
    picSearchResult.Visible = False
  End If
End Sub

Private Sub tbrTool_ButtonClick(ByVal Button As MSComctlLib.Button)
  On Error Resume Next
  CSKernelClient2.PresButtonToolbar Button.key, Me
End Sub

Private Sub Form_Resize()
  On Error Resume Next
  
  Dim tbHeight As Integer
  tbHeight = tbrTool.Height + 60
  
  If tbHeight > 900 Then
    tmResize.Interval = 1000
  Else
    pResize
  End If
End Sub

Private Sub pResize()
  Dim tbHeight As Integer
  tbHeight = tbrTool.Height + 60
  
  cListDoc1.Move 0, tbHeight, ScaleWidth, ScaleHeight - tbHeight
  
  pSetPositionSearchLD
End Sub

Private Function pAskDelete(ByVal msg As String) As Boolean
  pAskDelete = Ask(msg, vbYes, "Borrar")
End Function

' construccion - destruccion
Private Sub Form_Unload(Cancel As Integer)
  On Error Resume Next
  
  Set m_ListObject.ObjAbm = Nothing
  Set m_ListObject = Nothing
  
  ' Preferencias del Usuario
  '
  Set m_UserCfg = Nothing
  
  cListDoc1.SavePreference WindowState
  CSKernelClient2.UnloadForm Me, m_Name
  DeactiveBar Me
  fMain.RefreshTabs

  m_Initiated = False

End Sub

'---------------------------------------------------------------
' Manejo de la barra de herramientas
'---------------------------------------------------------------
Public Sub Edit()
  Dim Mouse As cMouseWait
  Set Mouse = New cMouseWait
  ObjEdit.Edit cListDoc1.Id
End Sub

Public Sub PrintObj()
  Dim PrintManager As CSPrintManager2.cPrintManager
  Dim iDoc         As CSIDocumento.cIDocumento
  
  Set PrintManager = New CSPrintManager2.cPrintManager
  
  If cListDoc1.Id = csNO_ID Then Exit Sub
  
  Dim ObjGeneric As cIEditGeneric
  Set ObjGeneric = ObjEdit()
  
  If Not TypeOf ObjGeneric Is CSIDocumento.cIDocumento Then Exit Sub
  Set iDoc = ObjGeneric
  
  If Not iDoc.LoadForPrint(cListDoc1.Id) Then Exit Sub
    
  PrintManager.Path = GetRptPath
  PrintManager.CommandTimeout = GetRptCommandTimeOut
  PrintManager.ConnectionTimeout = GetRptConnectionTimeOut

  PrintManager.EmailAddress = pGetEmailAddress(ObjGeneric)
  PrintManager.DescripUser = pGetDescripUser(ObjGeneric)
  PrintManager.Title = pGetPrintTitle(ObjGeneric)

  If iDoc.DocTId = 0 Then
    PrintManager.ShowPrint iDoc.Id, iDoc.DocId * -1, 0
  Else
    PrintManager.ShowPrint iDoc.Id, csNO_ID, iDoc.DocId
  End If
End Sub

Private Function pGetEmailAddress(ByRef objDoc As Object) As String
  On Error Resume Next
    
  Dim EmailAddress As String
  Dim obj As cIABMClient
  
  If TypeOf objDoc Is cIABMClient Then
  
    Set obj = objDoc
    EmailAddress = Trim$(obj.MessageEx(MSG_EXPORT_GET_EMAIL, Nothing))
  
  End If
  
  pGetEmailAddress = EmailAddress
End Function

Private Function pGetDescripUser(ByRef objDoc As Object) As String
  On Error Resume Next
  
  Dim rtn As String
  Dim obj As cIABMClient
  
  If TypeOf objDoc Is cIABMClient Then
  
    Set obj = objDoc
    rtn = obj.MessageEx(MSG_EXPORT_GET_FILE_NAME_POSTFIX, Nothing)
    
  End If
  
  pGetDescripUser = rtn
End Function

Private Function pGetPrintTitle(ByRef objDoc As Object) As String
  On Error Resume Next
  
  Dim rtn As String
  Dim obj As cIABMClient
  
  If TypeOf objDoc Is cIABMClient Then
  
    Set obj = objDoc
    rtn = obj.MessageEx(MSG_PRINT_GET_TITLE, Nothing)
  
  End If
  
  pGetPrintTitle = rtn
End Function


Public Sub NewObj()
  Dim Mouse As cMouseWait
  Set Mouse = New cMouseWait
  
  ObjEdit.Edit 0
End Sub

Public Sub Delete()
  On Error GoTo ControlError
  
  Dim i         As Long
  Dim vIds()    As Long
  Dim msgDelete As String
  Dim ObjEdit   As cIEditGeneric
  
  vIds = cListDoc1.SelectedItems
  
  If vIds(0) <> csNO_ID Then
    
    If UBound(vIds) > 0 Then
      msgDelete = "los items"
    Else
      msgDelete = "el item"
    End If
    
    If pAskDelete("Confirma que desea borrar " & msgDelete) Then
    
      Dim Mouse As cMouseWait
      Set Mouse = New cMouseWait
    
      Set ObjEdit = CSKernelClient2.CreateObject(m_ObjEditName)
    
      For i = 0 To UBound(vIds)
        If ObjEdit.Delete(vIds(i)) Then cListDoc1.Remove vIds(i)
      Next
      
      Set ObjEdit = Nothing
    End If
  End If

  GoTo ExitProc
ControlError:
  MngError Err, "Delete", "fListDoc", ""
  If Err.Number Then Resume ExitProc
ExitProc:
  Set ObjEdit = Nothing
End Sub

'--------------------------------------------------
' Para implementar en el futuro
'
    'Public Sub ShowDocAux()
    '  Dim iAbm As cIABMClient
    '  Set iAbm = ObjEdit
    '  iAbm.MessageEx MSG_DOC_DOC_AUX, Nothing
    '  cListDoc1.Id
    'End Sub
'
'--------------------------------------------------

Public Sub CloseForm()
  Unload Me
End Sub
Public Sub Update()
  On Error Resume Next
  cListDoc1.Update
End Sub
Public Sub Search()
  Dim iAbm As cIABMClient
  Set iAbm = ObjEdit
  iAbm.MessageEx MSG_DOC_SEARCH, True
End Sub
Public Sub ReloadParams()
  On Error Resume Next
  cListDoc1.ReloadParams
End Sub
Public Sub SaveParams()
  On Error Resume Next
  cListDoc1.SaveParams
End Sub

'---------------------------------------------------------------
' Manejo de key stroke
'---------------------------------------------------------------
Public Function CtrlKeyNew() As Boolean
  NewObj
  CtrlKeyNew = True
End Function

Public Function CtrlKeyRefresh() As Boolean
  Update
  CtrlKeyRefresh = True
End Function

Public Function CtrlKeyClose() As Boolean
  CloseForm
  CtrlKeyClose = True
End Function

Public Function CtrlKeyPrint() As Boolean
  PrintObj
  CtrlKeyPrint = True
End Function

Public Function CtrlKeyDelete() As Boolean
  Delete
  CtrlKeyDelete = True
End Function

Public Function CtrlKeySearch() As Boolean
  Search
  CtrlKeySearch = True
End Function

'---------------------------------------------------------------

#If PREPROC_DEBUG Then
Private Sub Form_Initialize()
  gdbInitInstance C_Module
End Sub

Private Sub Form_Terminate()
  gdbTerminateInstance C_Module
End Sub
#End If

Private Sub tbrTool_Click()
  On Error Resume Next
  picSearchResult.Visible = False
End Sub

Private Sub tmResize_Timer()
  On Error Resume Next
  tmResize.Interval = 0
  pResize
End Sub

'////////////////////////////////////////////////////////////////////////
'
' SEARCH
'
'////////////////////////////////////////////////////////////////////////

Private Sub pSetPositionSearchLD()
  On Error Resume Next
  DoEvents
  picSearch.Left = Me.Width - picSearch.Width - 200
  
  Dim rightSearch As Long
  rightSearch = picSearch.Left + txSearch.Width + txSearch.Left + 40
  picSearchResult.Width = rightSearch - 3000
  picSearchResult.Left = rightSearch - picSearchResult.Width
  lvSearchResult.Width = picSearchResult.Width - 40
  shSearchResult.Width = lvSearchResult.Width + 60
End Sub

Private Sub pInitPositionSearchLD()
  On Error Resume Next
  
  If pSearchIsEnabled() Then
  
    picSearch.Height = tbrTool.Height - 20
    picSearch.Top = 10
    picSearch.Width = 6000
    picSearch.Left = tbrTool.Width - picSearch.Width
    txSearch.Top = 80
    txSearch.Left = 10
    txSearch.Width = picSearch.Width _
                     - cmdSearch.Width - 80 _
                     - cbFilter.Width - 80
    cbFilter.Left = txSearch.Left + txSearch.Width + 60
    cbFilter.Top = txSearch.Top
    shSearch.Top = txSearch.Top - 20
    shSearch.Left = txSearch.Left - 10
    shSearch.Height = txSearch.Height + 40
    shSearch.Width = txSearch.Width + 40
    cmdSearch.Left = cbFilter.Left + cbFilter.Width + 60
    cmdSearch.Top = 60
    cmdSearch.Height = 315
    picSearch.Visible = True
    
    picSearchResult.Top = tbrTool.Top + picSearch.Top + txSearch.Top + txSearch.Height + 40
    lvSearchResult.Top = 20
    lvSearchResult.Left = 20
    lvSearchResult.Width = picSearchResult.Width - 30
    lvSearchResult.Height = picSearchResult.Height - 30
    shSearchResult.Left = 0
    shSearchResult.Top = 0
    shSearchResult.Width = lvSearchResult.Width + 60
    shSearchResult.Height = lvSearchResult.Height + 60

  Else
  
    picSearch.Visible = False
    picSearchResult.Visible = False
  
  End If
End Sub

Private Sub InitSearch()
  On Error GoTo ControlError
  
  If pSearchIsEnabled() Then
  
    m_done = False
    m_searchOk = False
    m_Searched = vbNullString
      
    picSearchResult.Visible = False
  
    Set lvSearchResult.SmallIcons = ImgTree
    Set lvSearchResult.ColumnHeaderIcons = ImgTree
      
    cbFilter.Clear
    ListAdd cbFilter, "Contiene a ...", c_HelpFilterHaveTo
    ListAdd cbFilter, "Comienza con ...", c_HelpFilterBeginLike
    ListAdd cbFilter, "Termina con ...", c_HelpFilterEndLike
    ListAdd cbFilter, "Usar comodines (*)", c_HelpFilterWildcard
    ListAdd cbFilter, "Igual a ...", c_HelpFilterIsLike
      
    m_bDontClick = True
  
    ListSetListIndexForId cbFilter, c_HelpFilterHaveTo
    
    pInitPositionSearchLD
    
    Set m_helpLD = New cHelpLD
    m_helpLD.Show Me, pGetSearchTable(), csNO_ID, vbNullString, vbNullString
  
  End If
  
  GoTo ExitProc
ControlError:
  MngError Err, "InitSearch", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Function pGetSearchTable() As Long
  On Error Resume Next
  pGetSearchTable = m_listObj.SearchParamTable
  Err.Clear
End Function

Private Function pSearchIsEnabled() As Boolean
  On Error Resume Next
  pSearchIsEnabled = m_listObj.EnabledSearchParam
  Err.Clear
End Function

Private Function pSetBackgroundColor() As Boolean
  On Error Resume Next
  Dim color As Long
  Err.Clear
  color = m_listObj.BackgroundColor
  If Err.Number = 0 Then
    Me.BackColor = color
    Me.shSearch.BackColor = color
    Me.shSearchResult.BackColor = color
  End If
  Err.Clear
End Function

Public Function LoadItems() As Boolean
  On Error GoTo ControlError
  
  Set m_Grid = New cListView
  m_Grid.SetPropertys lvSearchResult
  lvSearchResult.MultiSelect = False
  m_Grid.IMG_Active_FALSE = IMG_Active_FALSE
  m_Grid.IMG_Active_TRUE = IMG_Active_TRUE
  m_Grid.LoadFromRecordSet lvSearchResult, m_rs
  m_Grid.GetColumnWidth lvSearchResult, Caption & "_LD"
  pHideAuxCols
  LoadItems = True

  GoTo ExitProc
ControlError:
  MngError Err, "LoadItems", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Sub pHideAuxCols()
  Dim i As Long
  
  For i = 1 To lvSearchResult.ColumnHeaders.Count
    If lvSearchResult.ColumnHeaders(i).Text = "_col_fore_color_" Then
      lvSearchResult.ColumnHeaders(i).Width = 0
    End If
    If lvSearchResult.ColumnHeaders(i).Text = "_col_back_color_" Then
      lvSearchResult.ColumnHeaders(i).Width = 0
    End If
    If lvSearchResult.ColumnHeaders(i).Text = "_col_descrip_" Then
      lvSearchResult.ColumnHeaders(i).Width = 0
    End If
  Next
End Sub

Public Property Get Ok() As Boolean
  Ok = m_searchOk
End Property

Public Property Get Id() As String
  Id = m_searchId
End Property

Public Property Get FormName() As String
  FormName = m_searchName
End Property

Public Property Get Code() As String
  Code = m_searchCode
End Property

Public Property Let HaveTop(ByRef rhs As Boolean)
  m_haveTop = rhs
End Property

Public Property Set rs(ByVal rhs As Recordset)
  Set m_rs = rhs
End Property

Private Sub txSearch_Change()
  On Error GoTo ControlError
  
  tmSearch.Enabled = False
  
  If Timer - m_LastChange > 0.2 And Timer - m_LastChange < 0.3 Then
    tmSearch.Interval = 500
  ElseIf Timer - m_LastChange > 0.3 Then
    tmSearch.Interval = 1500
  End If
  
  GoTo ExitProc
ControlError:
  MngError Err, "txSearch_Change", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next

  m_LastChange = Timer
  
  tmSearch.Enabled = True

End Sub

Private Sub txSearch_GotFocus()
  On Error Resume Next
  m_bDontHideResults = True
  If LenB(txSearch.Text) Then
    picSearchResult.Visible = True
    picSearchResult.ZOrder
  End If
End Sub

Private Sub txSearch_KeyUp(KeyCode As Integer, Shift As Integer)
  On Error Resume Next
  If KeyCode = vbKeyDown Then
    m_bDontHideResults = True
    lvSearchResult.SetFocus
  ElseIf KeyCode = vbKeyReturn Then
    lvSearchResult_DblClick
  End If
End Sub

Private Sub pSearch()
  On Error GoTo ControlError
  
  Dim iTimer As Single
  
  m_searchOk = False

  iTimer = Timer
  
  tmSearch.Enabled = False

  If m_FilterType <> ListID(cbFilter) Then
    
    m_FilterType = ListID(cbFilter)
  
  Else
    
    If iTimer - m_LastChange < 1 And m_Searched = txSearch.Text Then
      GoTo ExitProc
    End If
    
    If m_Searched = txSearch.Text Then
      If LenB(txSearch.Text) Then
        picSearchResult.Visible = True
      End If
      GoTo ExitProc
    End If
  End If
  
  Dim toSearch As String
  
  toSearch = txSearch.Text
  
  If LenB(toSearch) Then
  
    If m_haveTop Then
      m_helpLD.ReloadRs
    End If
    
    Dim Filter As String
    
    If m_haveTop Then
      Filter = vbNullString
    Else
      Filter = txSearch.Text
    End If
    
    shSearchResult.Visible = False
    If m_Grid.LoadFromRecordSetEx( _
                  lvSearchResult, _
                  m_rs, _
                  m_FilterType = c_HelpFilterHaveTo, _
                  Filter) Then
                  
      m_Grid.GetColumnWidth lvSearchResult, Caption & "_LD"
      m_Searched = toSearch
    End If
    shSearchResult.Visible = True
      
    picSearchResult.Visible = True
    
  Else
  
    picSearchResult.Visible = False
    
  End If
  
  GoTo ExitProc
ControlError:
  MngError Err, "Search", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
  
End Sub

Private Sub tmSearch_Timer()
  On Error Resume Next
  pSearch
End Sub

Private Sub txSearch_LostFocus()
  On Error Resume Next
  If m_bDontHideResults Then
    m_bDontHideResults = False
  Else
    picSearchResult.Visible = False
  End If
End Sub

Private Sub lvSearchResult_DblClick()
  On Error GoTo ControlError
  
  If lvSearchResult.SelectedItem Is Nothing Then Exit Sub
  If picSearchResult.Visible = False Then Exit Sub
  
  m_searchId = vbNullString
  
  m_searchId = m_Grid.GetSelectedId(lvSearchResult)
  m_searchName = m_Grid.GetSelectedName(lvSearchResult)
  m_searchCode = m_Grid.GetSelectedCode(lvSearchResult)
  m_searchOk = True

  Dim result As cHelpResult
  
  Set result = m_helpLD.ShowResult()
  If result.Id <> csNO_ID Then
    m_listObj.SetSearchParam result.Id, result.Value
    picSearchResult.Visible = False
    cListDoc1.Update
  End If

  GoTo ExitProc
ControlError:
  MngError Err, "lvSearchResult_DblClick", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

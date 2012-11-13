VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cABMGenericDocEx"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIABMGeneric
Implements CSIABMForm.cIABMDocEvent
'--------------------------------------------------------------------------------
' cABMGenericDocEx
' 07-01-01

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cABMGenericDocEx"

Private Const csDocumento = 4001

Private Const K_W_CANCEL = -10

' estructuras
' variables privadas
Private m_Client                As cIABMClient
Private m_Properties            As cABMProperties
Private m_FormDoc               As Object
Attribute m_FormDoc.VB_VarHelpID = -1

Private m_Tabs                  As cABMTabs
Private m_currtab               As Long

Private m_MngGrid              As cABMCSGrid

Private m_ShowingForm          As Boolean
Private m_MinHeight            As Long
Private m_ImplementsClientGrid As Boolean

Private m_IsDocument           As Boolean
Private m_IsItems              As Boolean
Private m_IsFooter             As Boolean

Private m_IsWizard             As Boolean

Private m_Title2               As String

Private m_Unloading            As Boolean

Private m_HideTabButtons       As Boolean
Private m_InModalWindow        As Boolean

Private m_LoadForm             As Boolean

Private m_FormShowed           As Boolean

Private m_FirstTab             As Long

Private m_FactoryObject        As String
Private m_ObjForm              As String

' eventos
' propiedades publicas
Public Property Let IsWizard(ByVal rhs As Boolean)
  m_IsWizard = rhs
End Property

Public Property Let HideTabButtons(ByVal rhs As Boolean)
  m_HideTabButtons = rhs
End Property

Public Property Let FactoryObject(ByVal rhs As String)
  m_FactoryObject = rhs
End Property

Public Property Let ObjForm(ByVal rhs As String)
  m_ObjForm = rhs
End Property

Public Property Get Frm() As Object
  
  If m_FormDoc Is Nothing Then
    
    Dim o As CSIABMForm.cIFactory
    Set o = CSKernelClient.CreateObject(m_FactoryObject)
    
    Set m_FormDoc = o.GetForm(m_ObjForm, Me)
    Load m_FormDoc
    m_LoadForm = True
  End If
  
  Set Frm = m_FormDoc
End Property

Public Property Get frm2() As CSIABMForm.cIABMDocForm
  Set frm2 = Frm
End Property

Public Property Let MinHeight(ByVal rhs As Long)
  m_MinHeight = rhs
End Property

Public Property Set Tabs(ByRef rhs As cIABMTabs)
  Set m_Tabs = rhs
End Property

Public Sub CloseWizard()
  WasChanged = False
  Unload m_FormDoc
End Sub

' propiedades friend
' propiedades privadas
Private Property Get MngGrid() As cABMCSGrid
  If m_MngGrid Is Nothing Then Set m_MngGrid = New cABMCSGrid
  Set MngGrid = m_MngGrid
End Property

Private Property Get WasChanged() As Boolean
  If Frm Is Nothing Then Exit Property
  WasChanged = frm2.WasChanged
End Property

Private Property Let WasChanged(ByVal rhs As Boolean)
  If Frm Is Nothing Then Exit Property
  DoEvents: DoEvents: DoEvents
  frm2.WasChanged = rhs
End Property

' funciones publicas
Public Function RefreshColumnProperties(ByRef iProperty As cIABMProperty, ByVal KeyCol As String)
  Dim Column      As cABMGridColumn
  Dim oProperty   As cABMProperty
  Dim oGrid       As cGridAdvanced
  
  Set oProperty = iProperty
  Set Column = iProperty.Grid.Columns(KeyCol)
  Set oGrid = Frm.GR(oProperty.Index)
  
  MngGrid.SetColumnPropertys oGrid, Column, oGrid.Columns(Column.Index)
End Function

Public Sub RefreshEnabledState(ByRef iProperties As cIABMProperties)
  Dim iProperty  As cIABMProperty
  
  For Each iProperty In iProperties
    SetEnabled iProperty
  Next
  
  pSetTabIndexDescrip
End Sub

Public Sub ShowValues(ByRef iProperties As cIABMProperties)
  Dim iProperty  As cIABMProperty
  
  If m_IsDocument Then
    For Each iProperty In iProperties
      If m_IsFooter Then
        ShowValue iProperty, True, c_Footer
      ElseIf m_IsItems Then
        ShowValue iProperty, True, c_Items
      Else
        ShowValue iProperty, True, c_Header
      End If
    Next
  Else
    For Each iProperty In iProperties
      ShowValue iProperty, True
    Next
  End If
End Sub

Public Sub ResetLayoutMembers()
End Sub

Public Sub ResetTabLeftTop(ByVal TabIndex As Integer)
End Sub

Public Function ShowCellValue(ByRef iProperty As cIABMProperty, ByVal lRow As Long, ByVal lCol As Long) As Boolean
  Dim oProperty As cABMProperty
  Set oProperty = iProperty
  MngGrid.ShowCellValue Frm.GR(oProperty.Index), iProperty.Grid, lRow, lCol
End Function

Public Function ShowValue(ByRef oProperty As cABMProperty, Optional ByVal NoChangeColumns As Boolean, Optional ByVal strTag As String) As Boolean
  Dim iProperty       As cIABMProperty
  Dim Item            As cIABMListItem
  Dim c               As Control
  Dim lbl             As Label
  
  Set iProperty = oProperty
  
  With Frm
  
    Select Case iProperty.PropertyType
        
        Case csTypeABMProperty.cspAdHock
            Set c = .CBhock(oProperty.Index)
            c.Clear
            For Each Item In iProperty.List
              c.AddItem Item.Value
              ListSetListIndexForId_ c, Item.Id
            Next
            c.ListIndex = iProperty.Value
            c.Enabled = iProperty.Enabled
            ' Esto es por que necesito una propiedad para el ItemData
            ' y uso el HelpId para ello. Cuando el usuario no
            ' modifica este control se devuelve el mismo ItemData que
            ' se mostro.
            iProperty.HelpId = iProperty.Value
            
            If oProperty.LabelIndex <> 0 Then Set lbl = .LB(oProperty.LabelIndex)
            
        Case csTypeABMProperty.cspList
            Set c = .CB(oProperty.Index)
            c.Clear
            For Each Item In iProperty.List
              With c
                .AddItem Item.Value
                .ItemData(.NewIndex) = Item.Id
              End With
            Next
            Select Case iProperty.ListWhoSetItem
              Case csListWhoSetItem.csListItemData
                ListSetListIndexForId_ c, iProperty.ListItemData
              Case csListWhoSetItem.csListListIndex
                ListSetListIndex_ c, iProperty.ListListIndex
              Case csListWhoSetItem.csListText
                ListSetListIndexForText_ c, iProperty.ListText
            End Select
            
            If c.ListIndex = -1 And c.ListCount > 0 Then c.ListIndex = 0
            c.Enabled = iProperty.Enabled
            
            If oProperty.LabelIndex <> 0 Then Set lbl = .LB(oProperty.LabelIndex)
            
        Case csTypeABMProperty.cspHelp
            Set c = .HL(oProperty.Index)
            With c
              .Id = iProperty.HelpId
              .ValueUser = iProperty.Value
              .ValueProcess = iProperty.HelpValueProcess
              .ColumnValueProcess = iProperty.HelpFieldValueProcess
              .Filter = iProperty.HelpFilter
              .Enabled = iProperty.Enabled
              '.Validate
            End With
            
            If oProperty.LabelIndex <> 0 Then Set lbl = .LB(oProperty.LabelIndex)
                      
        Case csTypeABMProperty.cspNumeric
            Set c = .ME(oProperty.Index)
            With c
              .csValue = iProperty.Value
              .Enabled = iProperty.Enabled
            End With
            
            If oProperty.LabelIndex <> 0 Then Set lbl = .LB(oProperty.LabelIndex)
            
        Case csTypeABMProperty.cspDate, csTypeABMProperty.cspTime
            Set c = .MEFE(oProperty.Index)
            With c
              .csValue = iProperty.Value
              .Enabled = iProperty.Enabled
            End With
            
            If oProperty.LabelIndex <> 0 Then Set lbl = .LB(oProperty.LabelIndex)
            
        Case csTypeABMProperty.cspOption
            Set c = .OP(oProperty.Index)
            With c
              .Value = iProperty.Value
              .Enabled = iProperty.Enabled
            End With
            
        Case csTypeABMProperty.cspText, csTypeABMProperty.cspFile, csTypeABMProperty.cspFolder
            Set c = .TX(oProperty.Index)
            With c
              .Mask = iProperty.TextMask
              .Text = iProperty.Value
              .Enabled = iProperty.Enabled
            End With
            
            If oProperty.LabelIndex <> 0 Then Set lbl = .LB(oProperty.LabelIndex)
            
        Case csTypeABMProperty.cspPassword
            Set c = .txPassword(oProperty.Index)
            With c
              .Text = iProperty.Value
              .Enabled = iProperty.Enabled
            End With
            
            If oProperty.LabelIndex <> 0 Then Set lbl = .LB(oProperty.LabelIndex)
            
        Case csTypeABMProperty.cspCheck
            Set c = .CHK(oProperty.Index)
            With c
              .Value = IIf(Val(iProperty.Value) <> 0, vbChecked, vbUnchecked)
              .Enabled = iProperty.Enabled
            End With
            
            If oProperty.LabelIndex <> 0 Then Set lbl = .LB(oProperty.LabelIndex)
            
        Case csTypeABMProperty.cspButton
            Set c = .CMD(oProperty.Index)
            With c
              .Caption = iProperty.Name
              .Enabled = iProperty.Enabled
            End With
            
        Case csTypeABMProperty.cspLabel
            Set c = .LB2(oProperty.Index)
            c.Caption = iProperty.Value
            
        Case csTypeABMProperty.cspImage
            Set c = .Img(oProperty.Index)
            With c
              .Picture = iProperty.Picture
              .ZOrder
            End With
            
        Case csTypeABMProperty.cspTitle
            Set c = .lbTitle2(oProperty.Index)
            c.Caption = iProperty.Value
            
        Case csTypeABMProperty.cspDescription
            Set c = .LBDescrip(oProperty.Index)
            c.Caption = iProperty.Value
            
        Case csTypeABMProperty.cspGrid
            Dim Grid As Object
            Set Grid = .GR(oProperty.Index)
            Set c = Grid
            Grid.Enabled = iProperty.Enabled
            MngGrid.AllowAddNew(Grid) = iProperty.GridAdd
            MngGrid.AllowEdit(Grid) = iProperty.GridEdit
            MngGrid.AllowDelete(Grid) = iProperty.GridRemove
            If Not MngGrid.LoadFromRows(Grid, iProperty.Grid, NoChangeColumns, m_Client.Title & "_" & iProperty.Name) Then Exit Function
            If iProperty.GridAdd Then
              pSetDefaults iProperty, Grid.Rows
            End If
    End Select
  
  End With
  
  If Not c Is Nothing Then
    
    Dim bInCurrenTag As Boolean
    
    With c
    
      If m_IsDocument Then
        bInCurrenTag = Left$(.Tag, Len(strTag)) = strTag And .Tag <> "" And .Name <> "cbTab" And Val(Mid(.Tag, Len(strTag) + 1)) = m_currtab
      Else
        bInCurrenTag = (Val(.Tag) = m_currtab) Or (Val(.Tag) = csETabIdxT_All)
      End If
      
      If bInCurrenTag Then
        .Visible = iProperty.Visible
        If Not lbl Is Nothing Then
          If Val(lbl.Tag) <> -1 Then
            lbl.Visible = iProperty.Visible
          End If
        End If
      Else
        If Not (oProperty.KeyCol = csNumberID _
                Or oProperty.KeyCol = csStateID _
                Or iProperty.Table = csDocumento) Then
          .Visible = False
          If Not lbl Is Nothing Then
            lbl.Visible = False
          End If
        Else
          .Visible = True
        End If
      End If
    End With
  End If
  
  DoEvents

  ShowValue = True
End Function

Public Sub SetEnabled(ByRef oProperty As cABMProperty)
  Dim iProperty      As cIABMProperty
  Dim Item            As cIABMListItem
  
  Set iProperty = oProperty
  
  With Frm
  
    Select Case iProperty.PropertyType
      Case csTypeABMProperty.cspAdHock
        .CBhock(oProperty.Index).Enabled = iProperty.Enabled
      Case csTypeABMProperty.cspList
        .CB(oProperty.Index).Enabled = iProperty.Enabled
      Case csTypeABMProperty.cspHelp
        .HL(oProperty.Index).Enabled = iProperty.Enabled
      Case csTypeABMProperty.cspNumeric
        .ME(oProperty.Index).Enabled = iProperty.Enabled
      Case csTypeABMProperty.cspDate, csTypeABMProperty.cspTime
        .MEFE(oProperty.Index).Enabled = iProperty.Enabled
      Case csTypeABMProperty.cspOption
        .OP(oProperty.Index).Enabled = iProperty.Enabled
      Case csTypeABMProperty.cspText, csTypeABMProperty.cspFile, csTypeABMProperty.cspFolder
        .TX(oProperty.Index).Enabled = iProperty.Enabled
      Case csTypeABMProperty.cspPassword
        .txPassword(oProperty.Index).Enabled = iProperty.Enabled
      Case csTypeABMProperty.cspCheck
        .CHK(oProperty.Index).Enabled = iProperty.Enabled
      Case csTypeABMProperty.cspButton
        .CMD(oProperty.Index).Enabled = iProperty.Enabled
      Case csTypeABMProperty.cspGrid
        Dim Grid As Object
        Set Grid = .GR(oProperty.Index)
        Grid.Enabled = iProperty.Enabled
    End Select
  End With
  
  DoEvents
End Sub

Public Function LoadControlEx(ByRef oProperty As cABMProperty, Optional ByVal NoGrids As Boolean) As Boolean
  Dim iProperty  As cIABMProperty
  
  If Not oProperty.ControlLoaded Then
    If Not LoadControl(oProperty) Then Exit Function
    oProperty.ControlLoaded = True
  End If
  
  Set iProperty = oProperty
  
  If iProperty.PropertyType <> cspGrid Or Not NoGrids Then
    ShowValue oProperty
  End If
  
  pSetTabIndexDescrip
  
  LoadControlEx = True
End Function

Public Sub UnloadControl(ByRef oProperty As cABMProperty)
End Sub

Public Function RemoveProperty(ByVal Index As Integer)
  Dim oProp As cABMProperty
  Dim iProperties As cIABMProperties
  Set iProperties = m_Properties
  Set oProp = iProperties(Index)
End Function

Public Function TabClick(ByVal Index As Integer)
  Dim c           As Control
  Dim ChildIndex  As Long
  Dim FatherIndex As Long
  Dim oLock       As cLockUpdateWindow
  Dim FirstTab    As Object
  Dim bVisible    As Boolean
  
  With Frm
  
    Set oLock = New cLockUpdateWindow
    oLock.LockW .hwnd
    
    If InStr(1, .cbTab(Index).Tag, c_InerTab) Then
      ChildIndex = pGetTagChildIndex(.cbTab(Index).Tag)
      FatherIndex = pGetTagFatherIndex(.cbTab(Index).Tag)
    
      For Each c In .Controls
        If Not CBool(TypeOf c Is cButton And InStr(1, c.Name, "cbTab")) Then
          If Trim(c.Tag) <> "" Then
            If Val(c.Tag) <> FatherIndex Then
              pSetVisible c, ChildIndex
            End If
          End If
        End If
      Next
    
    Else
      m_currtab = Index
      
      For Each c In .Controls
        If TypeOf c Is cButton And InStr(1, c.Name, "cbTab") Then
          If InStr(1, c.Tag, c_InerTab) Then
            bVisible = pGetTagFatherIndex(c.Tag) = Index
            c.Visible = bVisible
            If bVisible Then
              If FirstTab Is Nothing Then Set FirstTab = c
            End If
          End If
        ElseIf Trim(c.Tag) <> "" Then
          pSetVisible c, Index
        End If
      Next
    End If
    
    If Not FirstTab Is Nothing Then
      TabClick FirstTab.Index
      FirstTab.TabSelected = True
    End If
    
    oLock.UnLockW
  End With
End Function

Public Function DocTabClick(ByVal Index As Integer, ByVal Tag As String)
  Dim oLock As cLockUpdateWindow
  Set oLock = New cLockUpdateWindow
  oLock.LockW Frm.hwnd
  
  Select Case Tag
    
    ' Para documentos los tag de los controles tienen
    ' la palabra Items o Footers o Header
    ' para identificar a que grupo pertenecen
    Case c_Items
      If m_IsItems Then
        pDocTabClickEx c_Items, Index
      End If
    Case c_Footer
      If m_IsFooter Then
        pDocTabClickEx c_Footer, Index
      End If
    Case Else
      If m_IsItems Or m_IsFooter Then Exit Function
      pDocTabClickEx c_Header, Index
  End Select
  
  oLock.UnLockW
End Function

Private Sub pDocTabClickEx(ByVal strTag As String, ByVal Index As Integer)
  Dim c As Control
  
  m_currtab = Index
  
  With Frm
  
    For Each c In .Controls
      If Left$(c.Tag, Len(strTag)) = strTag And c.Tag <> "" And c.Name <> "cbTab" Then
        c.Visible = Val(Mid(c.Tag, Len(strTag) + 1)) + m_FirstTab = Index
        If TypeOf c Is Label Then
          If c.BackColor = vbButtonFace Then
            c.BackColor = .ShTab.BackColor
          End If
          c.ZOrder
          If LCase(c.Name) = "lb" Then
            If Trim(c.Caption) = "" Then
              c.Visible = False
            End If
          End If
        ElseIf TypeOf c Is CheckBox Then
          c.BackColor = .ShTab.BackColor
        End If
        If TypeOf c Is Toolbar And c.Visible Then
          .SetToolbar c
        End If
      End If
    Next
  End With
End Sub

Private Sub pSetVisible(ByRef c As Object, ByVal Index As Long)
    
  With Frm
  
    c.Visible = Val(c.Tag) = Index Or Val(c.Tag) = csETabIdxT_All
    If TypeOf c Is Label Then
      If c.BackColor = vbButtonFace Then
        c.BackColor = .ShTab.BackColor
      End If
      c.ZOrder
      If LCase(c.Name) = "lb" Then
        If Trim(c.Caption) = "" Then
          c.Visible = False
        End If
      End If
    ElseIf TypeOf c Is CheckBox Then
      c.BackColor = .ShTab.BackColor
    End If
    If TypeOf c Is Toolbar And c.Visible Then
      .SetToolbar c
    End If
  End With
End Sub

Public Function Show(Obj As CSInterfacesABM.cIABMClient, ByVal IndexTag As Integer) As Boolean
  Dim mouse  As cMouse
  Dim tmpObj As cIABMClientGrid
  
  If Obj Is Nothing Then Exit Function
  
  Set m_Client = Obj
  
  With Frm
  
    m_ImplementsClientGrid = ImplementsInterface(m_Client, tmpObj)
    .ShTab.BackColor = vb3DHighlight
    
    If m_LoadForm Then
      m_LoadForm = False
      
      If m_MinHeight < .Height Then m_MinHeight = .Height
      
      CSKernelClient.LoadForm Frm, "ABM_" & m_Client.Title
      If TypeOf Frm Is fABM Or TypeOf Frm Is fWizard Then
        If .Height < m_MinHeight Then .Height = m_MinHeight
      End If
    End If
    
    If Not ShowForm(IndexTag) Then Exit Function
    
    .Caption = m_Client.Title
        
    If TypeOf Frm Is fABM Then
      .cmdDocs.Visible = m_Client.CanAddDocDigital
      .cmdNew.Visible = m_Client.CanNew
      .cmdCopy.Visible = m_Client.CanCopy
    End If
    
    If Not ValEmpty(m_Title2, csText) Then
      .lbTitleEx2.Caption = " - " & m_Title2
      .lbTitleEx2.Left = .lbTitle.Left + .lbTitle.Width + 50
    End If
    
    If .Visible Then
      .ZOrder
    Else
      If m_IsDocument Then
        If m_IsFooter Then
          frm2.Loading = False
          If m_InModalWindow Then
            If Not m_FormShowed Then
              m_FormShowed = True
              Set mouse = New cMouse
              mouse.MouseDefault
              .Show vbModal
            End If
          Else
            .Show
          End If
        End If
      Else
        frm2.Loading = False
        If m_InModalWindow Then
          If Not m_FormShowed Then
            m_FormShowed = True
            Set mouse = New cMouse
            mouse.MouseDefault
            If TypeOf Frm Is fABM Then .ShowForm
            .Show vbModal
          End If
        Else
          If TypeOf Frm Is fABM Then .ShowForm
          .Show
        End If
      End If
    End If
    
    Show = True
  End With
End Function

Private Sub cIABMDocEvent_cmdBackClick()
  MoveBack
End Sub

Private Sub cIABMDocEvent_cmdNextClick()
  MoveNext
End Sub

Private Sub cIABMDocEvent_GRColumnButtonClick(ByVal Index As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer, bCancel As Boolean)
  pGRColumnButtonClick Index, lRow, lCol, iKeyAscii, bCancel
End Sub

Private Sub cIABMDocEvent_GRSelectionChange(Index As Integer, ByVal lRow As Long, ByVal lCol As Long)
  pGRSelectionChange Index, lRow, lCol
End Sub

Private Sub cIABMDocEvent_ToolBarButtonClick(ByVal Button As Object)
  pToolBarButtonClik Button
End Sub

' funciones privadas
Private Property Let cIABMGeneric_HideTitle(ByVal rhs As Boolean)
End Property

Private Property Let cIABMGeneric_InModalWindow(ByVal rhs As Boolean)
  m_InModalWindow = rhs
End Property

Private Property Get cIABMGeneric_InModalWindow() As Boolean
  cIABMGeneric_InModalWindow = m_InModalWindow
End Property

Private Property Let cIABMGeneric_IsDocument(ByVal rhs As Boolean)
  m_IsDocument = rhs
End Property

Private Property Let cIABMGeneric_IsFooter(ByVal rhs As Boolean)
  m_IsFooter = rhs
End Property

Private Property Let cIABMGeneric_IsItems(ByVal rhs As Boolean)
  m_IsItems = rhs
End Property

Private Property Let cIABMGeneric_Left(ByVal rhs As Single)
  Frm.Left = rhs
End Property

Private Property Get cIABMGeneric_Left() As Single
  cIABMGeneric_Left = Frm.Left
End Property

Private Property Set cIABMGeneric_ObjForm(ByVal rhs As Object)
  Set m_FormDoc = rhs
End Property

Private Property Get cIABMGeneric_ObjForm() As Object
  Set cIABMGeneric_ObjForm = Frm
End Property

Private Property Get cIABMGeneric_PicMain() As Object
  Set cIABMGeneric_PicMain = Frm.Image1
End Property

' Implementacion de Interface
Private Property Get cIABMGeneric_Properties() As CSInterfacesABM.cIABMProperties
  Set cIABMGeneric_Properties = m_Properties
End Property

Private Sub cIABMGeneric_RefreshControls(Optional ByVal NoGrids = True)
  If m_Unloading Then Exit Sub
  ShowForm -1, NoGrids, False
End Sub

Private Property Get cIABMGeneric_ShapeMain() As Object
  Set cIABMGeneric_ShapeMain = Frm.ShTab
End Property

Private Function cIABMGeneric_Show(Obj As CSInterfacesABM.cIABMClient) As Boolean
  Dim mouse As cMouseWait
  Set mouse = New cMouseWait
  
  If m_IsItems Then
    Set Frm.ObjItems = Me
  ElseIf m_IsFooter Then
    Set Frm.ObjFooter = Me
  End If
  
  cIABMGeneric_Show = Show(Obj, 0)
End Function

Private Sub cIABMGeneric_ShowValue(iProp As CSInterfacesABM.cIABMProperty)
  Dim strTag As String
  If m_IsDocument Then
    strTag = pGetStrTag(iProp)
  End If
  ShowValue iProp, , strTag
End Sub

Private Function pGetStrTag(ByRef oProp As cABMProperty) As String
  On Error Resume Next
  If oProp.ctl Is Nothing Then Exit Function
  With oProp.ctl
    pGetStrTag = Mid(.Tag, 1, Len(.Tag) - 1)
  End With
End Function

Private Property Get cIABMGeneric_Tabs() As CSInterfacesABM.cIABMTabs
  If m_Tabs Is Nothing Then Set m_Tabs = New cABMTabs
  Set cIABMGeneric_Tabs = m_Tabs
End Property

Private Function cIABMGeneric_Terminate() As Boolean

End Function

Private Property Let cIABMGeneric_Title2(ByVal rhs As String)
  m_Title2 = rhs
End Property

Private Property Let cIABMGeneric_Top(ByVal rhs As Single)
  Frm.Top = rhs
End Property

Private Property Get cIABMGeneric_Top() As Single
  cIABMGeneric_Top = Frm.Top
End Property

'/////////////////////////////////////////////////////////////////////////////////////////
' Eventos de la interfaz
Private Sub cIABMDocEvent_CMDClick(ByVal Index As Integer)
  ChangeProperty cspButton, Index, Frm.CMD(Index)
End Sub

Private Sub cIABMDocEvent_GRClick(ByVal Index As Integer)

End Sub

Private Sub cIABMDocEvent_GRDblClick(ByVal Index As Integer, ByVal RowIndex As Long, ByVal ColIndex As Long)

End Sub

Private Sub cIABMDocEvent_cbTabClick(ByVal Index As Integer, ByVal Tag As String)
  If m_IsDocument Then
    DocTabClick Index, Tag
  Else
    TabClick Index
  End If
End Sub

Private Sub cIABMDocEvent_FormLoad()
  pResetChanged
End Sub

Private Sub cIABMDocEvent_ToolBarClick(ByVal Button As Object)
  On Error GoTo ControlError

  If m_IsItems Then Exit Sub
  If m_IsFooter Then Exit Sub

  Select Case Button.Key
    Case c_KeyTbNew
      doNew m_FormDoc
    
    Case c_KeyTbSave
      Save
    
    Case c_KeyTbAnular
      m_Client.MessageEx MSG_DOC_ANULAR, Nothing
    
    Case c_KeyTbReload
      frm2.InitMembers
      DiscardChanges
    
    Case c_KeyTbCopy
      m_Client.Copy
    
    Case c_KeyTbEditState
      m_Client.MessageEx MSG_DOC_EDIT_STATE, Nothing
      
    Case c_KeyTbDelete
      If pAskDelete("Confirma que desea borrar el documento") Then
        If VarToBool(m_Client.MessageEx(MSG_DOC_DELETE, Nothing)) Then
          pResetChanged
        End If
      End If
      
    Case c_KeyTbSearch
    
    Case c_KeyTbPrint
      pPrint
    Case c_KeyTbSignature
      m_Client.MessageEx MSG_DOC_SIGNATURE, Nothing
      
    Case c_KeyTbApply
      m_Client.MessageEx MSG_DOC_APPLY, Nothing
      
    Case c_KeyTbAttach
      m_Client.ShowDocDigital
    
    Case c_KeyTbHistory
    
    Case c_KeyTbFirst
      pMove MSG_DOC_FIRST
      
    Case c_KeyTbPrevious
      pMove MSG_DOC_PREVIOUS
      
    Case c_KeyTbNext
      pMove MSG_DOC_NEXT
      
    Case c_KeyTbLast
      pMove MSG_DOC_LAST
    
    Case c_KeyTbHelp
    Case c_KeyTbClose
      cIABMDocEvent_cmdCloseClick
  End Select

  GoTo ExitProc
ControlError:
  MngError Err, "cIABMDocEvent_ToolBarClick", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub pMove(ByVal MoveTo As ABM_MSG)
  If Not m_Client Is Nothing Then
    
    If Not pSaveChanges(False) Then Exit Sub
    
    m_Client.MessageEx MoveTo, Nothing
  End If
End Sub

'------------
' Documentos
Private Sub cIABMDocEvent_CBChange(ByVal Index As Integer)
  pCBChange Index
End Sub

Private Sub cIABMDocEvent_CBhockChange(ByVal Index As Integer)
  pCBHockChange Index
End Sub

Private Sub cIABMDocEvent_CHKClick(ByVal Index As Integer)
  pCHKClick Index
End Sub

Private Sub cIABMDocEvent_cmdCancelClick()
  If m_IsWizard Then
    If Not m_Client.PropertyChange(K_W_CANCEL) Then Exit Sub
    WasChanged = False
    Unload m_FormDoc
  Else
    DiscardChanges
  End If
End Sub

Private Sub cIABMDocEvent_cmdCloseClick()
  If m_FormDoc Is Nothing Then Exit Sub
  Unload m_FormDoc
End Sub

Private Sub cIABMDocEvent_cmdSaveClick()
  If Not Save Then Exit Sub
  Unload m_FormDoc
End Sub

Private Sub cIABMDocEvent_FormQueryUnload(Cancel As Integer, ByVal UnloadMode As Integer)
  If m_IsFooter Or m_IsItems Then Exit Sub
  
  If Not m_Client Is Nothing Then
    
    With Frm
    
      frm2.CancelUnload = False
      If Not pSaveChanges(Cancel) Then
        frm2.CancelUnload = True
      End If
    End With
  End If
End Sub

Private Sub cIABMDocEvent_FormUnload(Cancel As Integer)
    
  With Frm
  
    If m_IsFooter Or m_IsItems Then
      
      ' Solo si el usuario no desidio cancelar el cierre del form
      If .CancelUnload Then Exit Sub
      
      SaveColumnsGrids
      m_Unloading = True
      
      Set m_FormDoc = Nothing
      Set m_Client = Nothing
      Exit Sub
    End If
    
    If Not m_Client Is Nothing Then
      
      frm2.CancelUnload = False
      
      SaveColumnsGrids
      m_Unloading = True
      
      m_Client.Terminate
      Set m_Client = Nothing
    End If
    Set m_FormDoc = Nothing
  End With
End Sub

Private Sub cIABMDocEvent_GRColumnAfterEdit(ByVal Index As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long, bCancel As Boolean)
  pGRColumnEdit True, Index, lRow, lCol, 0, NewValue, NewValueID, bCancel
End Sub

Private Sub cIABMDocEvent_GRColumnAfterUpdate(ByVal Index As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long)
  pGRColumnAfterUpdate Index, lRow, lCol, 0, NewValue, NewValueID
End Sub

Private Sub cIABMDocEvent_GRColumnBeforeEdit(ByVal Index As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer, bCancel As Boolean)
  pGRColumnBeforeEdit Index, lRow, lCol, iKeyAscii, bCancel
  If bCancel Then Exit Sub
  pGRColumnEdit False, Index, lRow, lCol, iKeyAscii, 0, 0, bCancel
End Sub

Private Sub cIABMDocEvent_GRDeleteRow(Index As Integer, ByVal lRow As Long, bCancel As Boolean)
  pGRDeleteRow Index, lRow, bCancel
End Sub

Private Sub cIABMDocEvent_GRNewRow(ByVal Index As Integer, ByVal RowIndex As Long)
  pGRNewRow Index, RowIndex
End Sub

Private Sub cIABMDocEvent_GRValidateRow(ByVal Index As Integer, ByVal RowIndex As Long, bCancel As Boolean)
  pGRValidateRow Index, RowIndex, bCancel, True, False
End Sub

Private Sub cIABMDocEvent_HLChange(ByVal Index As Integer)
  pHLChange Index
End Sub

Private Sub cIABMDocEvent_MEChange(ByVal Index As Integer)
  pMEChange Index
End Sub

Private Sub cIABMDocEvent_MEDateChange(ByVal Index As Integer)
  pMEDateChange Index
End Sub

Private Sub cIABMDocEvent_OPClick(ByVal Index As Integer)
  pOPClick Index
End Sub

Private Sub cIABMDocEvent_TXChange(ByVal Index As Integer)
  pTXChange Index
End Sub

Private Sub cIABMDocEvent_TXPasswordChange(ByVal Index As Integer)
  pTXPasswordChange Index
End Sub

' funciones del objeto
Private Sub doNew(ByVal Frm As Form)
  Dim LockWnd As cLockUpdateWindow
  Set LockWnd = New cLockUpdateWindow
  
  ' Solo en footers y en abm's
  If m_IsDocument Then
    If m_IsItems Then Exit Sub
    If m_IsFooter Then Exit Sub
  End If
  
  If Not pSaveChanges(False) Then Exit Sub
  
  With Frm
  
    LockWnd.LockW .hwnd
    
    If Not m_IsDocument Then
      DiscardChanges True
    End If
    
    m_Client.EditNew
    
    If m_IsDocument Then
      If Not pNewWithWizard() Then
        frm2.SetFocusFirstControl
      End If
    End If
  End With
End Sub

Private Function pSaveChanges(ByRef Cancel As Integer) As Boolean
  If m_IsDocument Then
    If m_IsFooter Or m_IsItems Then
      pSaveChanges = True
      Exit Function
    End If
  End If
  
  If WasChanged Then
    Dim rslt As VbMsgBoxResult
    
    Frm.ZOrder
    rslt = MsgBox("Ud. ha realizado cambios que no ha guardado." & vbCrLf & vbCrLf & "¿Desea guardarlos?", vbQuestion + vbYesNoCancel, "Guardar")
    
    If rslt = vbYes Then
    
      If Not Save() Then
        Cancel = True
        Exit Function
      End If
      WasChanged = False
    
    ElseIf rslt = vbNo Then
      WasChanged = False
    
    ElseIf rslt = vbCancel Then
      Cancel = True
      Exit Function
    End If
  End If
  
  pSaveChanges = True
End Function

Private Sub pCBChange(ByVal Index As Integer)
  ChangeProperty cspList, Index, Frm.CB(Index)
  ReLoadListAdHock
End Sub

Private Sub pCBHockChange(ByVal Index As Integer)
  ChangeProperty cspAdHock, Index, Frm.CBhock(Index)
  ReLoadListAdHock
End Sub

Private Sub pCHKClick(ByVal Index As Integer)
  ChangeProperty cspCheck, Index, Frm.CHK(Index)
  ReLoadListAdHock
End Sub

Private Sub pGRDeleteRow(Index As Integer, ByVal lRow As Long, bCancel As Boolean)
  If Not m_ImplementsClientGrid Then Exit Sub
  
  Dim oProperty   As cABMProperty
  Set oProperty = GetProperty(cspGrid, Index)
  
  If oProperty Is Nothing Then Exit Sub
  
  Dim ClientGrid As cIABMClientGrid
  Set ClientGrid = m_Client
  
  If ClientGrid.DeleteRow(pGetPropertyKey(oProperty), pCreateRow(Index, oProperty, lRow), lRow) Then
    Dim iProperty As cIABMProperty
    Set iProperty = oProperty
    iProperty.Grid.Rows.Remove lRow
    bCancel = False
    m_Client.MessageEx MSG_GRID_ROW_DELETED, iProperty.Key
    
    On Error Resume Next
    Dim Grid As Object
    Set Grid = Frm.GR(oProperty.Index)
    If Grid.Rows <= 1 Then
      Grid.Rows = 2
    End If
  Else
    bCancel = True
  End If
End Sub

Private Sub pGRSelectionChange(Index As Integer, ByVal lRow As Long, ByVal lCol As Long)
  Dim iProperty   As cIABMProperty
  Set iProperty = GetProperty(cspGrid, Index)
  
  If Not iProperty Is Nothing Then
    iProperty.SelectedIndex = lRow
  End If
  
  If m_Client Is Nothing Then Exit Sub
  m_Client.MessageEx MSG_GRID_ROW_CHANGE, iProperty
End Sub

Private Sub pGRNewRow(ByVal Index As Integer, ByVal RowIndex As Long)
  If m_ImplementsClientGrid Then
    
    Dim oProperty   As cABMProperty
    Set oProperty = GetProperty(cspGrid, Index)
    
    If Not oProperty Is Nothing Then
    
      Dim ClientGrid As cIABMClientGrid
      Set ClientGrid = m_Client
      
      ClientGrid.NewRow pGetPropertyKey(oProperty), RowIndex
      
      pSetDefaults oProperty, RowIndex
    End If
  End If
End Sub

Private Sub pSetDefaults(ByRef oProperty As cABMProperty, ByVal RowIndex As Long)
  Dim Grid      As Object
  Dim iProp     As cIABMProperty
  Dim iRow      As cIABMGridRow
  Dim Col       As cIABMGridColumn
  Dim ColIndex  As Long
  
  Set iProp = oProperty
  For Each Col In iProp.Grid.Columns
    ColIndex = ColIndex + 1
    If Not Col.DefaultValue Is Nothing Then
      If iRow Is Nothing Then
        Set iRow = pCreateRow(oProperty.Index, oProperty, RowIndex)
      End If
      With iRow.Item(ColIndex)
        .Id = Col.DefaultValue.Id
        .Value = Col.DefaultValue.Value
      End With
    End If
  Next
  
  If iRow Is Nothing Then Exit Sub
  
  Set Grid = Frm.GR(oProperty.Index)
  MngGrid.LoadFromRow Grid, iRow, RowIndex, iProp.Grid.Columns
End Sub

Private Sub pGRColumnAfterUpdate(ByVal Index As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer, ByVal NewValue As Variant, ByVal NewValueID As Long)
  On Error GoTo ControlError
  
  If m_ImplementsClientGrid Then
    
    Dim oProperty   As cABMProperty
    Dim iProperty   As cIABMProperty
    
    Set oProperty = GetProperty(cspGrid, Index)
    
    If Not oProperty Is Nothing Then
    
      Dim ClientGrid As cIABMClientGrid
      
      Set ClientGrid = m_Client
    
      ' If the row not exists we have to create it because the client need it to hold
      ' calculated data
      pCreateRowIfNotExists oProperty, Index, lRow
    
      pSetColumnValueInProperty oProperty, Index, lRow, lCol, NewValue, NewValueID
      ' Let client one chance to calculate columns
      ClientGrid.ColumnAfterUpdate pGetPropertyKey(oProperty), lRow, lCol
      
      Set iProperty = oProperty
      pSetRowValueInGrid Index, oProperty, lRow, iProperty.Grid.Rows(lRow)
      
      WasChanged = True
    End If
  End If
  
  Exit Sub
ControlError:
  MngError Err, "pGRColumnAfterUpdate", C_Module, ""
End Sub

Private Sub pGRColumnBeforeEdit(ByVal Index As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer, ByRef bCancel As Boolean)
  On Error GoTo ControlError
  
  If Not m_ImplementsClientGrid Then Exit Sub
  
  bCancel = False
    
  Dim oProperty   As cABMProperty
  Dim iProperty   As cIABMProperty
  Dim oGrid       As cGridAdvanced
  Dim Column      As cIABMGridColumn
  Dim c           As cGridColumn
  
  Set iProperty = GetProperty(cspGrid, Index)
  
  If iProperty Is Nothing Then Exit Sub
  If lRow > iProperty.Grid.Rows.Count Then Exit Sub

  Set oProperty = iProperty
      
  Set oGrid = Frm.GR(oProperty.Index)
  Set Column = iProperty.Grid.Columns(lCol)
  Set c = oGrid.Columns(lCol)
  
  With iProperty.Grid.Rows.Item(lRow).Item(lCol)
    If .Format Is Nothing Then
      
      With c
      
        .EditType = Column.PropertyType
        .EditSubType = Column.SubType
        .Table = Column.Table
        .AllowEdit = Column.Enabled
        .Enabled = Column.Enabled
        bCancel = Not Column.Enabled
        .HelpFilter = Column.HelpFilter
        .Size = Column.Size
        .Format = Column.Format
        
        If Column.PropertyType = cspList Then
          .List = Column.List
        Else
          .List = Nothing
        End If
        
        If Column.SubType = cspPercent Then
          If Column.Format = "" Then
            .Format = "0.00 %"
          End If
        End If
      End With
      
    Else
      
      c.EditType = .Format.PropertyType
      c.EditSubType = .Format.SubType
      c.Table = .Format.Table
      c.AllowEdit = .Format.Enabled
      c.Enabled = .Format.Enabled
      bCancel = Not .Format.Enabled
      c.HelpFilter = .Format.HelpFilter
      c.Size = .Format.Size
      c.Format = .Format.Format
      
      If .Format.PropertyType = cspList Then
        c.List = .Format.List
      Else
        c.List = Nothing
      End If
      
      If .Format.SubType = cspPercent Then
        If .Format.Format = "" Then
          c.Format = "0.00 %"
        End If
      End If
    End If
  End With

  Exit Sub
ControlError:
  MngError Err, "pGRColumnBeforeEdit", C_Module, ""
End Sub

Private Sub pGRColumnEdit(ByVal After As Boolean, ByVal Index As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer, ByVal NewValue As Variant, ByVal NewValueID As Long, bCancel As Boolean)
  On Error GoTo ControlError
  
  If m_ImplementsClientGrid Then
    
    Dim oProperty   As cABMProperty
    Dim iProperty   As cIABMProperty
    Dim KeyProp     As Integer
    Dim ClientGrid  As cIABMClientGrid

    Set oProperty = GetProperty(cspGrid, Index)
    bCancel = False
    
    If Not oProperty Is Nothing Then
    
      KeyProp = pGetPropertyKey(oProperty)
      Set ClientGrid = m_Client
      
      If After Then
      
        ' If the row not exists we have to create it because the client need it to hold
        ' calculated data
        pCreateRowIfNotExists oProperty, Index, lRow
      
        If Not ClientGrid.ColumnAfterEdit(KeyProp, lRow, lCol, NewValue, NewValueID) Then
          bCancel = True
        End If
      
      Else
      
        If Not ClientGrid.ColumnBeforeEdit(KeyProp, lRow, lCol, iKeyAscii) Then
          bCancel = True
        End If
      End If
      
    Else
      bCancel = True
    End If
  Else
    bCancel = True
  End If
  
  Exit Sub
ControlError:
  MngError Err, "pGRColumnEdit", C_Module, ""
End Sub

Private Sub pGRColumnButtonClick(Index As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer, bCancel As Boolean)
  On Error GoTo ControlError
  
  If m_ImplementsClientGrid Then
    
    Dim oProperty   As cABMProperty
    Dim iProperty   As cIABMProperty
    Dim KeyProp     As Integer
    Dim ClientGrid  As cIABMClientGrid

    Set oProperty = GetProperty(cspGrid, Index)
    bCancel = False
    
    If Not oProperty Is Nothing Then
    
      KeyProp = pGetPropertyKey(oProperty)
      Set ClientGrid = m_Client
      
      
      ' If the row not exists we have to create it because the client need it to hold
      ' calculated data
      pCreateRowIfNotExists oProperty, Index, lRow
    
      If Not ClientGrid.ColumnButtonClick(KeyProp, lRow, lCol, iKeyAscii) Then
        bCancel = True
      End If
      '
      ' bCancel es para informarle a la grilla que el button click se manejo por la clase
      ' ya sea true o false el codigo que sigue siempre se ejecuta
      '
      Set iProperty = oProperty
      pSetRowValueInGrid Index, oProperty, lRow, iProperty.Grid.Rows(lRow)
      
      WasChanged = True
    
    Else
      bCancel = True
    End If
  Else
    bCancel = True
  End If
  
  Exit Sub
ControlError:
  MngError Err, "pGRColumnEdit", C_Module, ""
End Sub

Private Sub pCreateRowIfNotExists(ByRef iProperty As cIABMProperty, ByVal Index As Integer, ByVal lRow As Long)
  Dim Row        As cIABMGridRow

  With iProperty.Grid.Rows
    Set Row = .Item(lRow)
    If Row Is Nothing Then
      Set Row = pCreateRow(Index, iProperty, lRow)
      .Add Row
    End If
  End With
End Sub

Private Sub pSetColumnValueInProperty(ByRef iProperty As cIABMProperty, ByVal Index As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long)
  Dim Row        As cIABMGridRow

  With iProperty.Grid.Rows

    Set Row = .Item(lRow)
    If Row Is Nothing Then
      Set Row = pCreateRow(Index, iProperty, lRow)
      .Add Row
    End If
    
    With .Item(lRow).Item(lCol)
      .Id = NewValueID
      .Value = NewValue
    End With
  End With
End Sub

Private Function pGRValidateRow(ByVal Index As Integer, ByVal RowIndex As Long, ByRef bCancel As Boolean, ByVal bAddRow As Boolean, ByRef bIsEmpty As Boolean) As Boolean
  Dim rtn As Boolean
  
  If m_ImplementsClientGrid Then
    
    Dim iProperty   As cIABMProperty
    Dim oProperty   As cABMProperty
    
    Set oProperty = GetProperty(cspGrid, Index)
    bCancel = False
    
    If Not oProperty Is Nothing Then
    
      Dim ClientGrid  As cIABMClientGrid
      Dim iRow        As cIABMGridRow
      Dim oRow        As cABMGridRow
      Dim KeyProp     As String
      
      Set ClientGrid = m_Client
      KeyProp = pGetPropertyKey(oProperty)
      
      Set iRow = pCreateRow(Index, oProperty, RowIndex)
      
      If ClientGrid.IsEmptyRow(KeyProp, iRow, RowIndex) Then
        SendKeys "{TAB}"
        bCancel = True
        bIsEmpty = True
        
        ' La fila esta vacia asi que es valida
        rtn = True
        
      ' Let Client one chance to validate and modify row values
      ElseIf Not ClientGrid.ValidateRow(KeyProp, iRow, RowIndex) Then
        bCancel = True
        
        ' El cliente no valido la fila
        rtn = False
      Else
      
        ' La fila es valida
        rtn = True
        
        ' Put Client's values to Grid
        pSetRowValueInGrid Index, oProperty, RowIndex, iRow
        
        If bAddRow Then
          ' Keep updated the rows collection
          Set iProperty = oProperty
          
          With iProperty.Grid.Rows
            .Remove RowIndex
            
            Set oRow = iRow
            oRow.Index = RowIndex
            
            .Add iRow
          End With
          
          bCancel = Not iProperty.GridAdd
        Else
          bCancel = True
        End If
      End If
    
    Else
      bCancel = True
    End If
  Else
    bCancel = True
  End If
  
  pGRValidateRow = rtn
End Function

Private Sub pHLChange(ByVal Index As Integer)
  ChangeProperty cspHelp, Index, Frm.HL(Index)
  ReLoadListAdHock
End Sub

Private Sub pMEChange(ByVal Index As Integer)
  ChangeProperty cspNumeric, Index, Frm.ME(Index)
  ReLoadListAdHock
End Sub

Private Sub pMEDateChange(ByVal Index As Integer)
  Dim c As cMaskEdit
  
  Set c = Frm.MEFE(Index)

  If c.csType = csMkTime Then
    ChangeProperty cspTime, Index, c
  Else
    ChangeProperty cspDate, Index, c
  End If
  
  ReLoadListAdHock
End Sub

Private Sub pOPClick(ByVal Index As Integer)
  ChangeProperty cspOption, Index, Frm.OP(Index)
  ReLoadListAdHock
End Sub

Private Sub pTXButtonClick(Index As Integer, Cancel As Boolean)
  Dim iProp As cIABMProperty
  Set iProp = GetProperty(cspText, Index)
  m_Client.MessageEx MSG_BUTTON_TEXT_CLICK, iProp
End Sub

Private Sub pToolBarButtonClik(ByVal Button As MSComctlLib.Button)
  ChangeProperty cspToolBar, 0, Button
End Sub

Private Sub pTXChange(ByVal Index As Integer)
  ChangeProperty cspText, Index, Frm.TX(Index)
  ReLoadListAdHock
End Sub

Private Sub pTXPasswordChange(ByVal Index As Integer)
  ChangeProperty cspPassword, Index, Frm.txPassword(Index)
  ReLoadListAdHock
End Sub

Private Function pGetPropertyKey(ByVal oProperty As cABMProperty) As Integer
  Dim iProperty As cIABMProperty
  Set iProperty = oProperty
  pGetPropertyKey = iProperty.Key
End Function

Private Function pCreateRow(ByVal Index As Integer, ByVal iProperty As cIABMProperty, ByVal RowIndex As Long) As cIABMGridRow
  Dim Row       As cIABMGridRow
  Dim Col       As cIABMGridColumn
  Dim Cell      As cIABMGridCellValue
  Dim ColIndex  As Long
  
  Set Row = New cABMGridRow
  
  For Each Col In iProperty.Grid.Columns
    ColIndex = ColIndex + 1
    Set Cell = Row.Add(Nothing)
    
    With Frm.GR(Index).Cell(RowIndex, ColIndex)
      Cell.Id = .ItemData
      
      If Col.PropertyType = cspDate Then
        Cell.Value = GetDateValueForGridClient(.Text)
      
      ElseIf Col.SubType = cspPercent Then
        Cell.Value = Val(.Text) * 100
      
      Else
        Cell.Value = .Text
      End If
      
      Cell.Key = Col.Key
    End With
  Next
  
  Set pCreateRow = Row
End Function

Private Sub pSetRowValueInGrid(ByVal Index As Integer, ByVal iProperty As cIABMProperty, ByVal RowIndex As Long, ByRef Row As cIABMGridRow)
  Dim Col       As cIABMGridColumn
  Dim Cell      As cIABMGridCellValue
  Dim ColIndex  As Long
  
  For Each Col In iProperty.Grid.Columns
    ColIndex = ColIndex + 1
    Set Cell = Row.Item(ColIndex)
    
    With Frm.GR(Index).Cell(RowIndex, ColIndex)
      .ItemData = Cell.Id
      
      If Col.PropertyType = cspDate Then
        .Text = GetDateValueForGrid(Cell.Value)
      
      ElseIf Col.SubType = cspPercent Then
        .Text = Val(Cell.Value) / 100
        
      Else
        .Text = Cell.Value
      End If
    End With
  Next
End Sub

Private Function ShowForm(ByVal TabIndex As Integer, Optional ByVal NoGrids As Boolean, Optional ByVal bSetFocus As Boolean = True) As Boolean
  Dim oProperty      As cABMProperty
  Dim iProperties    As cIABMProperties
  Dim iProperty      As cIABMProperty
  Dim Tabs           As Integer
  Dim Count          As Integer
  
  Set iProperties = m_Properties
  
  For Each iProperty In iProperties
    If pGetTabIndex(iProperty) > Tabs Then Tabs = pGetTabIndex(iProperty)
  Next
  
  m_ShowingForm = True
  
  For Each oProperty In iProperties
    LoadControlEx oProperty, NoGrids
  Next
  
  m_ShowingForm = False
  
  With Frm
  
    Count = .Controls.Count
  
    If Not m_IsDocument Then
      If m_IsWizard Then
        .cmdNext.TabIndex = Count
        .cmdCancel.TabIndex = Count
        .cmdBack.TabIndex = Count
      Else
        .cmdSave.TabIndex = Count
        .cmdCancel.TabIndex = Count
        .cmdClose.TabIndex = Count
      End If
    End If
    
    If TabIndex <> -1 Then
      If m_IsDocument Then
        pDocTabClickEx c_Items, TabIndex
        pDocTabClickEx c_Footer, TabIndex
        pDocTabClickEx c_Header, TabIndex
        .cbTab(TabIndex).TabSelected = True
      Else
        TabClick TabIndex
      End If
    End If
    
    If bSetFocus Then frm2.SetFocusFirstControl
  End With
  
  ShowForm = True
End Function

Private Function LoadControl(ByRef oProperty As cABMProperty) As Boolean
  Dim c As Control
  Dim f As Control
  Dim iProperty As cIABMProperty
  
  Dim iProperties    As cIABMProperties
  Dim oProp          As cABMProperty
  
  Set iProperty = oProperty
  
  Dim nTabIndex As Long
  nTabIndex = pGetTabIndex(iProperty)
  
  With Frm
    Select Case iProperty.PropertyType
      Case csTypeABMProperty.cspAdHock
        .CBhockUbound = .CBhockUbound + 1
        Set c = .CBhock(.CBhockUbound)
        pSetFont c, iProperty
        
      Case csTypeABMProperty.cspList
        .CBUbound = .CBUbound + 1
        Set c = .CB(.CBUbound)
        pSetFont c, iProperty
        
      Case csTypeABMProperty.cspHelp
        .HLUbound = .HLUbound + 1
        Set c = .HL(.HLUbound)
        c.Table = iProperty.Table
        c.ButtonStyle = CSControls.cHelpButtonSingle
        pSetFont c, iProperty
        
      Case csTypeABMProperty.cspNumeric
        .MEUbound = .MEUbound + 1
        Set c = .ME(.MEUbound)
        c.csType = iProperty.SubType
        If iProperty.SubType = 0 Then
          Err.Raise csErrorABMLoadControlSubTypeNotDefined, "CSABMInterface.LoadControl", "Error al cargar controles en ABM Generico. No se ha indicado un subnType para la propiedad numerica: " & iProperty.Name
        End If
        
        If m_IsFooter Then
          c.Width = 1100
          c.BackColor = .shTabFooter.BackColor
          c.EnabledNoChngBkColor = True
        End If
        pSetFont c, iProperty
        c.FormatNumber = iProperty.Format
        
      Case csTypeABMProperty.cspDate, csTypeABMProperty.cspTime
        .MEFEUbound = .MEFEUbound + 1
        Set c = .MEFE(.MEFEUbound)
        If iProperty.PropertyType = csTypeABMProperty.cspDate Then
          c.csType = csMkDate
        Else 'csTypeABMProperty.cspTime
          c.csType = csMkTime
        End If
        pSetFont c, iProperty

'
' Ya veremos por ahora no se usa
'
'      Case csTypeABMProperty.cspOption
'        Set f = .FR(iProperty.OptionGroup)
'
'        With f
'          If Not .Tag <> "" Then
'            .Top = m_NextTop(nTabIndex)
'            .Left = m_Left(nTabIndex)
'            .Visible = True
'            .Tag = iProperty.TabIndex
'          End If
'        End With
'
'        Load .OP(.OP.UBound + 1)
'        Set c = .OP(.OP.UBound)
      
      Case csTypeABMProperty.cspLabel
        .LB2Ubound = .LB2Ubound + 1
        Set c = .LB2(.LB2Ubound)
        pSetFont c, iProperty
        If iProperty.BackColor <> -1 Then
          c.BackStyle = 1
        Else
          c.BackStyle = 0
        End If
        
      Case csTypeABMProperty.cspTitle
        .LbTitle2Ubound = .LbTitle2Ubound + 1
        Set c = .lbTitle2(.LbTitle2Ubound)
        pSetFont c, iProperty
        
      Case csTypeABMProperty.cspProgressBar
        .PrgBarUbound = .PrgBarUbound + 1
        Set c = .prgBar(.PrgBarUbound)
      
      Case csTypeABMProperty.cspDescription
        .LBDescripUbound = .LBDescripUbound + 1
        Set c = .LBDescrip(.LBDescripUbound)
        pSetFont c, iProperty
        
      Case csTypeABMProperty.cspImage
        .ImgUbound = .ImgUbound + 1
        Set c = .Img(.ImgUbound)
      
      Case csTypeABMProperty.cspText
        .TXUbound = .TXUbound + 1
        Set c = .TX(.TXUbound)
        c.MaxLength = iProperty.Size
        c.ButtonStyle = IIf(iProperty.SubType = cspTextButton, cButtonSingle, cButtonNone)
        c.Alignment = iProperty.TextAlign
        c.Mask = iProperty.TextMask
        c.PasswordChar = ""
        c.MultiLine = iProperty.SubType = CSConstantes.cspMemo
        pSetFont c, iProperty
        
      Case csTypeABMProperty.cspFile
        .TXUbound = .TXUbound + 1
        Set c = .TX(.TXUbound)
        With c
          .MaxLength = iProperty.Size
          .csType = CSMaskEdit.csMkFile
          .FileFilter = iProperty.HelpFilter
          .PasswordChar = ""
        End With
        pSetFont c, iProperty
        
      Case csTypeABMProperty.cspFolder
        .TXUbound = .TXUbound + 1
        Set c = .TX(.TXUbound)
        With c
          .MaxLength = iProperty.Size
          .csType = CSMaskEdit.csMkFolder
          .PasswordChar = ""
        End With
        pSetFont c, iProperty
        
'      Case csTypeABMProperty.cspPassword
'        Load .txPassword(.txPassword.UBound + 1)
'        Set c = .txPassword(.txPassword.UBound)
'        c.ButtonStyle = cButtonNone
'        c.PasswordChar = "*"
'        pSetFont c, iProperty
        
      Case csTypeABMProperty.cspCheck
        .CHKUbound = .CHKUbound + 1
        Set c = .CHK(.CHKUbound)
        c.Caption = "  "
        c.Width = 400
        
      Case csTypeABMProperty.cspGrid
        .GRUbound = .GRUbound + 1
        Set c = .GR(.GRUbound)
        c.Editable = iProperty.GridEdit
        MngGrid.SetPropertys c
        
        ' Formatos adicionales a la interfaz cIABMGrid
        Dim oGrd As cABMGrid
        Set oGrd = iProperty.Grid
        c.RowMode = oGrd.RowSelect
        
      Case csTypeABMProperty.cspButton
        .CMDUbound = .CMDUbound + 1
        Set c = .CMD(.CMDUbound)
        pSetFont c, iProperty
        
    End Select
    
    oProperty.Index = c.Index
  End With
  
  Set oProperty.ctl = c
  
  With c
    If m_IsDocument Then
      If m_IsItems Then
        .Tag = c_Items & iProperty.TabIndex
      ElseIf m_IsFooter Then
        .Tag = c_Footer & iProperty.TabIndex
      Else
        .Tag = c_Header & iProperty.TabIndex
      End If
    Else
      If oProperty.TabIndex Then
        .Tag = oProperty.TabIndex
      Else
        .Tag = iProperty.TabIndex
      End If
    End If
    
    .Enabled = iProperty.Enabled
    pSetBackColor c, iProperty
    pSetButton c
  End With
  
  With iProperty
    If .PropertyType = cspOption Then
    
    ElseIf .PropertyType = cspLabel Or .PropertyType = cspTitle Or .PropertyType = cspDescription Then
    
    Else
        
        Dim LB As Label
        
        With Frm
          .LBUbound = .LBUbound + 1
          Set LB = .LB(.LBUbound)
        End With
        
        With LB
          oProperty.LabelIndex = .Index
          .Tag = c.Tag
          .ZOrder
          If iProperty.PropertyType = cspButton Then
            .Visible = False
          End If
        End With
    
        ' Formateo especial para Grids
        If .PropertyType = cspGrid Then
          
          If m_IsItems Then
            With LB
              .Visible = False
              .Tag = ""
            End With
          End If
        
        ElseIf m_IsDocument And .Table = csDocumento Then
          
          With c
            .Left = 3600
            .Top = 80
            .Width = 3500
            .FontSize = 11
            .FontBold = True
            .Height = 330
            .Tag = ""
          End With
          
          With LB
            .Visible = False
            .Tag = -1
          End With
          
        ElseIf m_IsDocument _
               And (oProperty.KeyCol = csNumberID _
                    Or oProperty.KeyCol = csStateID) Then
          
          If oProperty.KeyCol = csNumberID Then
            c.Left = 7300
            c.Width = 1200
          Else
            c.Left = 8700
            c.Width = 3000
          End If
          c.Top = 80
          c.FontSize = 11
          c.FontBold = True
          c.Height = 330
          c.EnabledNoChngBkColor = True
          c.BackColor = vbButtonShadow
          c.BorderColor = vbButtonFace
          c.ForeColor = vbWhite
          LB.Visible = False
          LB.Tag = -1
          c.Tag = ""
        End If
    End If
    
    ' Me guardo el Top y el Left de esta propiedad
    With oProperty
      .Top = c.Top
      .Left = c.Left
      .Width = c.Width
      .Height = c.Height
    End With
  End With
  
  LoadControl = True
End Function

Private Sub SetNewTopAndLeft(ByRef iProperty As cIABMProperty)
End Sub

Private Sub SetNewWidthForm(ByRef oProp As cABMProperty, ByVal FrameSize As Integer)
End Sub

Private Function ReLoadListAdHock() As Boolean
  Dim iProperty       As cIABMProperty
  Dim iProperties     As cIABMProperties
  
  Set iProperties = m_Properties
  
  For Each iProperty In iProperties
    If iProperty.PropertyType = cspAdHock Then
      If m_Client.ListAdHock(iProperty.List) Then ShowValue iProperty
    End If
  Next
  ReLoadListAdHock = True
End Function

Private Function GetProperty(ByVal nType As csTypeABMProperty, ByVal Index As Integer) As cABMProperty
  Dim iProperty   As cIABMProperty
  Dim oProperty   As cABMProperty
  Dim iProperties As cIABMProperties
  Dim Found       As Boolean
  
  Set iProperties = m_Properties
  
  ' Para Toolbars no hay indice
  If nType = cspToolBar Then
    Dim Tbl As Toolbar
    
    Set Tbl = Frm.GetToolBar
    For Each iProperty In iProperties
      Set oProperty = iProperty
      If iProperty.PropertyType = nType Then
        If oProperty.Toolbar Is Tbl Then
          Set GetProperty = oProperty
          Exit For
        End If
      End If
    Next
  
  Else
    For Each iProperty In iProperties
    
      With iProperty
    
        Found = False
        
        ' Tratamiento especial para textos que
        ' tambien pueden ser carpetas o archivos
        If nType = cspText Then
          If .PropertyType = cspText Or .PropertyType = cspFile Or .PropertyType = cspFolder Then
            Found = True
          End If
        
        Else
          If .PropertyType = nType Then
            Found = True
          End If
        End If
        
        If Found Then
          Set oProperty = iProperty
        
          If oProperty.Index = Index Then
            Set GetProperty = oProperty
            Exit For
          End If
        End If
      End With
    Next
  End If
End Function

Private Function ChangeProperty(ByVal nType As csTypeABMProperty, ByVal Index As Integer, ByRef c As Object, Optional ByVal bNoRefresh As Boolean) As Boolean
  Dim iProperty   As cIABMProperty
  Dim iProperty2  As cIABMProperty
  Dim oProperty   As cABMProperty
  Dim iProperties As cIABMProperties
  
  Static Refreshing As Boolean
  
  If Refreshing Or m_ShowingForm Then
    Refreshing = False
    ChangeProperty = True
    Exit Function
  End If
                
  Set oProperty = GetProperty(nType, Index)
  
  Set iProperties = m_Properties
                
  If Not oProperty Is Nothing Then
    
    Set iProperty = oProperty
    
    With iProperty
      Select Case nType
        Case csTypeABMProperty.cspAdHock, csTypeABMProperty.cspList
          .ListListIndex = c.ListIndex
          .ListText = c.Text
          If c.ListIndex >= 0 Then
            .ListItemData = c.ItemData(c.ListIndex)
          Else
            .ListItemData = 0
          End If
        Case csTypeABMProperty.cspText, csTypeABMProperty.cspPassword, csTypeABMProperty.cspFile, csTypeABMProperty.cspFolder
          .Value = c.Text
        Case csTypeABMProperty.cspNumeric
          .Value = c.csValue
        Case csTypeABMProperty.cspDate, csTypeABMProperty.cspTime
          .Value = c.csValue
        Case csTypeABMProperty.cspOption
          
          If c.Value Then
            ' Aca hay que cambiar al resto de las Properties de este Group de
            ' option buttons
            For Each iProperty2 In iProperties
              If Not iProperty2 Is iProperty Then
                If iProperty2.PropertyType = cspOption And iProperty2.OptionGroup = .OptionGroup Then
                  iProperty2.Value = 0
                End If
              End If
            Next
          End If
          
          .Value = c.Value
        Case csTypeABMProperty.cspHelp
          .Value = c.ValueUser
          .HelpId = Val(c.Id)
        Case csTypeABMProperty.cspCheck
          .Value = c.Value
        Case csTypeABMProperty.cspToolBar
          .Value = c.Key
      End Select
      
      If m_Client.PropertyChange(.Key) And Not bNoRefresh Then
        Refreshing = True
        For Each iProperty In iProperties
          ShowValue iProperty
        Next
      End If
    End With
  End If
  
  If m_IsDocument Then
    If Not iProperty Is Nothing Then
      If iProperty.Table <> csDocumento Then
        WasChanged = True
      End If
    End If
  Else
    WasChanged = True
  End If
  
  Refreshing = False
  ChangeProperty = True
End Function

Public Function ValidateEx() As Boolean
  If Not pFillGrids() Then Exit Function
  If Not pValidate() Then Exit Function
  ValidateEx = True
End Function

Private Function pValidateItemsAndFooter()
  Dim GenDocEx As cABMGenericDocEx
  
  Set GenDocEx = m_Client.MessageEx(MSG_DOC_EX_GET_ITEMS, Nothing)
  If Not GenDocEx.ValidateEx() Then Exit Function
  
  Set GenDocEx = m_Client.MessageEx(MSG_DOC_EX_GET_FOOTERS, Nothing)
  pValidateItemsAndFooter = GenDocEx.ValidateEx()
End Function

Private Function Save() As Boolean
  On Error GoTo ControlError
  
  If m_IsItems Then Exit Function
  If m_IsFooter Then Exit Function
  
  Dim mouse As cMouseWait
  Set mouse = New cMouseWait
  
  pRefreshAux
  pFillList
  
  If Not pFillGrids() Then Exit Function
  If Not pValidate() Then Exit Function
  
  If Not pValidateItemsAndFooter() Then Exit Function
  
  If Not m_Client.Save() Then Exit Function
  
  If Not m_IsDocument Then
    DiscardChanges False
  Else
    m_Client.MessageEx MSG_DOC_REFRESH, Nothing
    frm2.SetFocusFirstControl
  End If
  
  WasChanged = False
  Save = True
  
  Exit Function
ControlError:
End Function

Private Sub pFillList()
  Dim iProperty   As cIABMProperty
  Dim oProperty   As cABMProperty
  Dim iProperties As cIABMProperties
  Dim Index       As Integer
  
  Set iProperties = m_Properties
  
  For Index = 1 To Frm.CBUbound
    For Each iProperty In iProperties
      If iProperty.PropertyType = cspList Then
        Set oProperty = iProperty
        If oProperty.Index = Index Then
          
          With Frm
            iProperty.ListItemData = ListID(.CB(Index))
            iProperty.ListListIndex = .CB(Index).ListIndex
            iProperty.ListText = .CB(Index).Text
          End With
        End If
      End If
    Next
  Next

  For Index = 1 To Frm.CBhockUbound
    For Each iProperty In iProperties
      If iProperty.PropertyType = cspList Then
        Set oProperty = iProperty
        If oProperty.Index = Index Then
          
          With Frm
            iProperty.ListItemData = ListID(.CBhock(Index))
            iProperty.ListListIndex = .CBhock(Index).ListIndex
            iProperty.ListText = .CBhock(Index).Text
          End With
        End If
      End If
    Next
  Next
End Sub

Private Function pFillGrids() As Boolean
  Dim iProperty   As cIABMProperty
  Dim oProperty   As cABMProperty
  Dim iProperties As cIABMProperties
  Dim Index       As Integer
  
  Set iProperties = m_Properties
  
  With Frm
  
    For Index = 1 To Frm.GRUbound
      For Each iProperty In iProperties
        If iProperty.PropertyType = cspGrid Then
          Set oProperty = iProperty
          If oProperty.Index = Index Then
            
            If Not pFillRows(iProperty.Grid, .GR(Index)) Then Exit Function
            
          End If
        End If
      Next
    Next
  End With
  
  pFillGrids = True
End Function

Private Function pFillRows(ByRef Grid As cIABMGrid, ByRef grCtrl As cGridAdvanced) As Boolean
  Dim Col        As cIABMGridColumn
  Dim ColIndex   As Integer
  Dim RowIndex   As Integer
  Dim Cell       As cIABMGridCellValue
  Dim Row        As cIABMGridRow
  Dim bIsEmpty   As Boolean
  
  Grid.Rows.Clear
  
  With grCtrl
    For RowIndex = 1 To .Rows
    
      ' The last row can be empty because it is for new items
      ' so if no columns with values exists don't add to grid.rows
      If RowIndex = .Rows Then
        
        ' Only for grid that allow add new rows
        Dim iProperty   As cIABMProperty
        Set iProperty = GetProperty(cspGrid, .Index)
        If iProperty.GridAdd Then
          If Not pGRValidateRow(.Index, RowIndex, False, False, bIsEmpty) Then Exit Function
        End If
      End If
      
      If Not bIsEmpty Then
        Set Row = Grid.Rows.Add(Nothing)
        ColIndex = 1
      
        For Each Col In Grid.Columns
          
          With .Cell(RowIndex, ColIndex)
          
            Set Cell = Row.Add(Nothing)
            Cell.Id = .ItemData
            
            If Col.PropertyType = cspCheck Then
              Cell.Value = .ItemData
            
            ElseIf Col.PropertyType = cspDate Then
              Cell.Value = GetDateValueForGridClient(.Text)
              
            ElseIf Col.SubType = cspPercent Then
              Cell.Value = Val(.Text) * 100
              
            Else
              Cell.Value = .Text
            End If
          End With
          
          Cell.Key = Col.Key
          ColIndex = ColIndex + 1
        Next
      End If
    Next
  End With
  
  pFillRows = True
End Function

Private Sub SaveColumnsGrids()
  Dim i           As Integer
  Dim iProperty   As cIABMProperty

  With Frm

    For i = 1 To Frm.GRUbound
      
      Set iProperty = GetProperty(cspGrid, i)
      
      If Not iProperty Is Nothing Then
        MngGrid.SaveColumnWidth .GR(i), m_Client.Title & "_" & iProperty.Name
        MngGrid.SaveColumnOrder .GR(i), m_Client.Title & "_" & iProperty.Name
      End If
    Next
  End With
End Sub

Private Sub DiscardChanges(Optional ByVal DontCallClient As Boolean)
  On Error GoTo ControlError
  
  Dim oLock As cLockUpdateWindow
  Dim mouse As cMouseWait
  
  Set mouse = New cMouseWait
  Set oLock = New cLockUpdateWindow
  
  oLock.LockW Frm.hwnd
  
  SaveColumnsGrids
  
  If Not DontCallClient Then m_Client.DiscardChanges

  Exit Sub
ControlError:
  MngError Err, "DiscardChanges", C_Module, ""
End Sub

Private Function pValidate() As Boolean
  If Not m_Client.Validate() Then Exit Function
  
  If m_ImplementsClientGrid Then
    Dim oProp     As cABMProperty
    Dim RowIndex  As Long
    Dim iProp     As cIABMProperty
    Dim iProperties    As cIABMProperties
  
    Set iProperties = m_Properties
    
    For Each iProp In iProperties
      Set oProp = iProp
      
      If iProp.PropertyType = cspGrid Then
        For RowIndex = 1 To iProp.Grid.Rows.Count
          If Not pGRValidateRow(oProp.Index, RowIndex, False, True, False) Then
            Exit Function
          End If
        Next
      End If
    Next
  End If
  
  pValidate = True
End Function

Private Sub pSetButton(ByRef Control As Control)
  If TypeOf Control Is cMaskEdit Then
    With Control
      If .csType <> csMkText And .csType <> csMkTime Then
        If .Enabled Then
          .ButtonStyle = cButtonSingle
        Else
          .ButtonStyle = cButtonNone
        End If
      End If
    End With
  End If
End Sub

Private Sub MoveNext()
  On Error GoTo ControlError
  
  Dim WizardClient As cWizardGenericDocEx
  Set WizardClient = m_Client
  WizardClient.MoveNext
  
  Exit Sub
ControlError:
  MngError Err, "MoveNext", C_Module, ""
End Sub

Private Sub MoveBack()
  Dim WizardClient As cWizardGenericDocEx
  Set WizardClient = m_Client
  WizardClient.MoveBack
End Sub

Private Sub pSetFont(ByRef c As Control, ByRef iProperty As cIABMProperty)
  On Error Resume Next
  
  With iProperty
    If .FontName <> "" Then
      c.FontName = .FontName
    End If
    If .FontSize > 0 Then
      c.FontSize = .FontSize
    End If
    c.FontUnderline = .FontUnderline
    c.FontBold = .FontBold
    c.FontItalic = .FontItalic
    If .ForeColor <> -1 Then
      c.ForeColor = .ForeColor
    End If
  End With
End Sub

Private Sub pSetBackColor(ByRef c As Control, ByRef iProperty As cIABMProperty)
  On Error Resume Next
  With iProperty
    If .BackColor <> -1 Then
      c.BackColor = .BackColor
    End If
  End With
End Sub

Private Sub pSetTabIndexDescrip()
  Dim iProperty   As cIABMProperty
  Dim oProperty   As cABMProperty
  Dim iProperties As cIABMProperties
  
  If m_IsDocument Then
  
    Set iProperties = m_Properties
  
    With Frm
  
      For Each iProperty In iProperties
        If iProperty.SubType = cspMemo Then
          Set oProperty = iProperty
          If oProperty.Index > 0 Then
            .TX(oProperty.Index).TabIndex = .Controls.Count
          End If
        End If
      Next
    End With
  End If
End Sub

Private Sub pRefreshAux()
  Dim Index       As Integer
  Dim oProperty   As cABMProperty
  Dim iProperties As cIABMProperties
  Dim i           As Integer
  
  Set iProperties = m_Properties
  
  With Frm
  
    For i = 1 To iProperties.Count
      
      Set oProperty = iProperties(i)
      Index = oProperty.Index
      
      Select Case iProperties(i).PropertyType
        Case csTypeABMProperty.cspAdHock
          ChangeProperty cspAdHock, Index, .CBhock.Item(Index), True
          
        Case csTypeABMProperty.cspCheck
          ChangeProperty cspCheck, Index, .CHK.Item(Index), True
          
        Case csTypeABMProperty.cspDate, csTypeABMProperty.cspTime
          ChangeProperty cspDate, Index, .MEFE.Item(Index), True
        
        Case csTypeABMProperty.cspHelp
          ChangeProperty cspHelp, Index, .HL.Item(Index), True
        
        Case csTypeABMProperty.cspList
          ChangeProperty cspList, Index, .CB.Item(Index), True
          
        Case csTypeABMProperty.cspNumeric
          ChangeProperty cspNumeric, Index, .ME.Item(Index), True
          
        Case csTypeABMProperty.cspOption
          ChangeProperty cspOption, Index, .OP.Item(Index), True
          
        Case csTypeABMProperty.cspPassword
          ChangeProperty cspPassword, Index, .txPassword.Item(Index), True
          
        Case csTypeABMProperty.cspText, csTypeABMProperty.cspFile, csTypeABMProperty.cspFolder
          ChangeProperty cspText, Index, .TX.Item(Index), True
          
      End Select
    Next
  End With
End Sub

Private Sub pResetChanged()
  WasChanged = False
  m_Unloading = False
End Sub

Private Function pAskDelete(ByVal msg As String) As Boolean
  pAskDelete = Ask(msg, vbYes, "Borrar")
End Function

Private Sub pPrint()

  Const c_RPT_KEY = "RPT-CONFIG"
  Const c_RPT_PathReportes = "RPT_PATH_REPORTES"
  Const c_RPT_CommandTimeOut = "RPT_COMMAND_TIMEOUT"
  Const c_RPT_ConnectionTimeOut = "RPT_CONNECTION_TIMEOUT"

  Dim PrintManager As Object 'CSPrintManager.cPrintManager
  Dim iDoc         As CSIDocumento.cIDocumento
  
  If Not TypeOf m_Client Is CSIDocumento.cIDocumento Then Exit Sub
  Set iDoc = m_Client
  
  If iDoc.Id = csNO_ID Then Exit Sub
  
  Set PrintManager = CSKernelClient.CreateObject("CSPrintManager.cPrintManager")
  
  With PrintManager
    .Path = GetValidPath(IniGetEx(c_RPT_KEY, c_RPT_PathReportes, gAppPath))
    .CommandTimeOut = Val(IniGetEx(c_RPT_KEY, c_RPT_CommandTimeOut, 0))
    .ConnectionTimeout = Val(IniGetEx(c_RPT_KEY, c_RPT_ConnectionTimeOut, 0))

    .ShowPrint iDoc.Id, csNO_ID, iDoc.DocId
  End With
End Sub

Private Function pGetTagFatherIndex(ByVal Tag As String) As Long
  Dim i As Long
  i = InStr(1, Tag, c_InerTab)
  If i > 0 Then
    pGetTagFatherIndex = Abs(Fix(Val(Mid(Tag, i + Len(c_InerTab))) / 100))
  End If
End Function

Private Function pGetTagChildIndex(ByVal Tag As String) As Long
  Dim i As Long
  Dim n As Long
  Dim q As Long
  
  i = InStr(1, Tag, c_InerTab)
  If i > 0 Then
    n = Val(Mid(Tag, i + Len(c_InerTab)))
    q = Abs(Fix(n / 100))
    pGetTagChildIndex = (n - q * 100) * -1
  End If
End Function

Private Function pNewWithWizard() As Boolean
  On Error Resume Next
  pNewWithWizard = VarToBool(m_Client.MessageEx(MSG_DOC_NEW_WITH_WIZARD, Nothing))
End Function

Private Function pGetTabIndex(ByRef iProperty As cIABMProperty) As Long
  With iProperty
    If .TabIndex = csETabIdxT_All Then
      pGetTabIndex = 0
    Else
      pGetTabIndex = .TabIndex
    End If
  End With
End Function

' construccion - destruccion
Private Sub Class_Initialize()
  On Error Resume Next
  
  m_IsDocument = False
  m_IsFooter = False
  m_IsItems = False
  m_FormShowed = False
  m_MinHeight = 5310
  
  Set m_Properties = New cABMProperties
End Sub

Private Sub Class_Terminate()
  On Error Resume Next
  
  Set m_Properties = Nothing
  Set m_Client = Nothing
  Set m_Tabs = Nothing
  Set m_MngGrid = Nothing
End Sub

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

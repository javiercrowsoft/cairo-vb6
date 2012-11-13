VERSION 5.00
Object = "{E3029087-6983-4DF6-A07F-E770EFB12BC0}#1.1#0"; "CSToolBar.ocx"
Object = "{E82A759A-7510-4F56-B239-9C0B78CF437B}#1.0#0"; "CSImageList.ocx"
Object = "{757F6B6F-8057-4D0A-85C2-0A1807E33D34}#1.7#0"; "CSGrid2.ocx"
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Begin VB.Form fPreviewGrid 
   Caption         =   "Grilla"
   ClientHeight    =   4920
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   6705
   Icon            =   "fPreviewGrid.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   4920
   ScaleWidth      =   6705
   StartUpPosition =   3  'Windows Default
   Begin MSComDlg.CommonDialog cd 
      Left            =   4620
      Top             =   2100
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin CSToolBar.cToolbar tbrTool 
      Height          =   555
      Left            =   2400
      Top             =   3600
      Width           =   3855
      _ExtentX        =   6800
      _ExtentY        =   979
   End
   Begin CSToolBar.cReBar rbMain 
      Left            =   0
      Top             =   0
      _ExtentX        =   8705
      _ExtentY        =   873
   End
   Begin CSImageList.cImageList ilToolbar 
      Left            =   1740
      Top             =   3720
      _ExtentX        =   953
      _ExtentY        =   953
      Size            =   7520
      Images          =   "fPreviewGrid.frx":0442
      KeyCount        =   8
      Keys            =   "ÿÿÿÿÿÿÿ"
   End
   Begin CSGrid2.cGrid grItems 
      Height          =   2595
      Left            =   60
      TabIndex        =   0
      Top             =   720
      Width           =   4095
      _ExtentX        =   7223
      _ExtentY        =   4577
      AutomaticSort   =   -1  'True
      BackgroundPictureHeight=   0
      BackgroundPictureWidth=   0
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      DisableIcons    =   -1  'True
   End
   Begin VB.Menu mnuPopMain 
      Caption         =   "pop"
      Visible         =   0   'False
      Begin VB.Menu mnuGroup 
         Caption         =   "&Grupos..."
      End
      Begin VB.Menu mnuGroupExpand 
         Caption         =   "E&xpandir Grupos"
      End
      Begin VB.Menu mnuGroupCollapse 
         Caption         =   "&Contraer Grupos"
      End
      Begin VB.Menu mnuSep1 
         Caption         =   "-"
      End
      Begin VB.Menu mnuFormulas 
         Caption         =   "&Formulas..."
      End
      Begin VB.Menu mnuFormats 
         Caption         =   "F&ormatos Condicionales..."
      End
      Begin VB.Menu mnuFilters 
         Caption         =   "F&iltros..."
      End
      Begin VB.Menu mnuHideCols 
         Caption         =   "Ocultar/Mostrar &Columnas..."
      End
      Begin VB.Menu mnuSep 
         Caption         =   "-"
      End
      Begin VB.Menu mnuAutoWidthCol 
         Caption         =   "&Ajustar el Ancho de las Columnas"
      End
      Begin VB.Menu mnuSep2 
         Caption         =   "-"
      End
      Begin VB.Menu mnuViews 
         Caption         =   "&Vistas"
         Begin VB.Menu mnuViewSave 
            Caption         =   "&Guardar Vista..."
         End
         Begin VB.Menu mnuViewSaveAs 
            Caption         =   "Guardar Vista &Como..."
         End
         Begin VB.Menu mnuViewSep1 
            Caption         =   "-"
         End
         Begin VB.Menu mnuViewEdit 
            Caption         =   "&Editar Vista..."
         End
         Begin VB.Menu mnuViewSep2 
            Caption         =   "-"
         End
         Begin VB.Menu mnuViewDelete 
            Caption         =   "&Borrar Vista"
         End
         Begin VB.Menu mnuViewSepItem 
            Caption         =   "-"
            Visible         =   0   'False
         End
         Begin VB.Menu mnuViewItem 
            Caption         =   "Item"
            Index           =   0
            Visible         =   0   'False
         End
      End
      Begin VB.Menu mnuSep4 
         Caption         =   "-"
      End
      Begin VB.Menu mnuExportToExel 
         Caption         =   "&Exportar a Excel..."
      End
      Begin VB.Menu mnuExportToXml 
         Caption         =   "&Exportar a XML..."
      End
   End
End
Attribute VB_Name = "fPreviewGrid"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' fPreviewGrid
' -11-2003

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "fPreviewGrid"

Private Const c_TblKeyGroup = "GROUPS"
Private Const c_TblKeyTotals = "TOTALS"
Private Const c_TblKeyFilters = "FILTERS"
Private Const c_TblKeyFormats = "FORMATS"
Private Const c_TblKeyExcel = "EXCEL"
Private Const c_TblKeyRefresh = "REFRESH"
Private Const c_TblKeyParams = "PARAMS"
Private Const c_TblKeyXml = "XML"

' estructuras
Private Type t_Params
  Name          As String
  Value         As String
  Id            As Long
  ValueProcess  As String
  Text          As String
End Type

' variables privadas
Private m_Grid           As CSOAPI2.cGridManager
Private m_grdv_id        As Long
Private m_ViewLoaded     As Boolean
Private m_rpt_id         As Long
Private m_Sqlstmt        As String
Private m_CommandTimeout As Long
Private m_vParams()      As t_Params
Private m_ParamDescrip   As String
Private m_RptManager     As cRptManager
Private m_RptPath        As String
Private m_inf_codigo     As String

' eventos
' propiedades publicas
Public Property Let RptPath(ByVal rhs As String)
  m_RptPath = rhs
End Property

Public Property Let inf_codigo(ByVal rhs As String)
  m_inf_codigo = rhs
End Property
' propiedades friend
' propiedades privadas
' funciones publicas
Public Sub InitParams()
  ReDim m_vParams(0)
End Sub

Public Sub AddParam(ByVal Name As String, _
                    ByVal Value As String, _
                    ByVal Text As String, _
                    ByVal ValueProcess As String, _
                    ByVal Id As Long)
  ReDim Preserve m_vParams(UBound(m_vParams) + 1)
  With m_vParams(UBound(m_vParams))
    .Name = Name
    .Value = Value
    .Text = Text
    .ValueProcess = ValueProcess
    .Id = Id
  End With
End Sub

Public Sub LaunchGrid(ByRef Grid As cGridManager, _
                      ByVal sqlstmt As String, _
                      ByVal rpt_id As Long, _
                      ByVal rptName As String, _
                      ByVal RptPath As String, _
                      ByVal CommandTimeout As Long, _
                      ByVal Nombre As String, _
                      ByVal ParamDescrip As String)
  
  Dim bSetView  As Boolean
  Dim grdv_id   As Long
  
  m_ParamDescrip = ParamDescrip
  
  Set m_Grid = Grid
  m_rpt_id = rpt_id
  m_Sqlstmt = sqlstmt
  m_CommandTimeout = CommandTimeout

  bSetView = pLoadViews()
  Grid.LoadFromSqlstmtExView Me.grItems, _
                             sqlstmt, _
                             Nothing, _
                             True, _
                             bSetView, _
                             grdv_id

  If bSetView Then
    SetActiveView grdv_id
  End If
  
  GetRptManagerForGrid m_RptManager, _
                       rptName, _
                       RptPath, _
                       Me.grItems, _
                       Me
  Me.Caption = "Grilla - " & Nombre
End Sub

Private Sub SetActiveView(ByVal grdv_id As Long)
  Dim i As Long
  
  pSetUncheckedViewItems
  
  With mnuViewItem
    For i = 1 To .Count - 1
      With .Item(i)
        If grdv_id = Abs(Val(.Tag)) Then
          m_grdv_id = grdv_id
          .Checked = True
        End If
      End With
    Next
  End With
  
  pSetViewEditDelete

End Sub

Public Function AddView(ByVal MenuName As String, _
                        ByVal Id As Long) As Long
  AddView = pAddView(MenuName, Id, False)
End Function

Private Function pAddView(ByVal MenuName As String, _
                          ByVal Id As Long, _
                          ByVal bPublica As Boolean) As Long
  On Error Resume Next
  Err.Clear
  With mnuViewItem
    Load .Item(.UBound + 1)
    If Err.Number Then
      MngError Err, "AddMenu", C_Module, "Error al agregar un menu. Menu: " & MenuName
      Exit Function
    End If
    
    With .Item(.UBound)
      If bPublica Then
        .Caption = MenuName & " (Publica)"
        .Tag = -Id
      Else
        .Caption = MenuName
        .Tag = Id
      End If
      .Visible = True
    End With
    pAddView = .UBound
  End With
End Function

Private Function pLoadViews() As Boolean
  If m_ViewLoaded Then Exit Function
  m_ViewLoaded = True
  m_Grid.LoadViews , m_rpt_id
  pCreateMenuViews
  pSetViewEditDelete
  pLoadViews = True
End Function

' funciones friend
' funciones privadas
Private Sub Form_Resize()
  On Error Resume Next
  
  Dim lOffSet As Long
  
  lOffSet = rbMain.RebarHeight * Screen.TwipsPerPixelY + 60
  rbMain.RebarSize
  
  grItems.Move 0, lOffSet, Me.ScaleWidth, Me.ScaleHeight - lOffSet
End Sub

Private Sub Form_Unload(Cancel As Integer)
  On Error Resume Next
  
  ReDim m_vParams(0)
  
  Set m_RptManager = Nothing
  Set m_Grid = Nothing
  CSKernelClient2.UnloadForm Me, Me.Name
End Sub

Private Sub grItems_DblClick(ByVal lRow As Long, ByVal lCol As Long)
  On Error GoTo ControlError
  
  If m_RptManager Is Nothing Then Exit Sub
  m_RptManager.DblClickOnFieldForGrid Me, lRow
  
  GoTo ExitProc
ControlError:
  MngError Err, "grItems_DblClick", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub grItems_ShowPopMenu(Cancel As Boolean)
  On Error Resume Next
  Me.PopupMenu mnuPopMain
  Cancel = True
End Sub

Private Sub mnuAutoWidthCol_Click()
  On Error Resume Next
  grItems.AutoWidthColumns
End Sub

Private Sub mnuExportToExel_Click()
  On Error Resume Next
  pExportExcel
End Sub

Private Sub mnuExportToXml_Click()
  On Error Resume Next
  pExportXml
End Sub

Private Sub mnuFilters_Click()
  On Error Resume Next
  grItems.ShowFilters
End Sub

Private Sub mnuFormats_Click()
  On Error Resume Next
  grItems.ShowFormats
End Sub

Private Sub mnuFormulas_Click()
  On Error Resume Next
  grItems.ShowFormulas
End Sub

Private Sub mnuGroup_Click()
  On Error Resume Next
  grItems.GroupColumns
End Sub

Private Sub mnuGroupCollapse_Click()
  On Error Resume Next
  grItems.CollapseAllGroups
End Sub

Private Sub mnuGroupExpand_Click()
  On Error Resume Next
  grItems.ExpandAllGroups
End Sub

Private Sub mnuHideCols_Click()
  On Error Resume Next
  grItems.HideColumns
End Sub

Private Sub mnuViewDelete_Click()
  On Error GoTo ControlError
  
  If m_grdv_id <> csNO_ID And m_grdv_id > 0 Then
    If m_Grid.DeleteView(m_grdv_id) Then
    
      pSetDeleteViewItem
      m_grdv_id = csNO_ID
      pSetViewEditDelete
    End If
  End If
  
  GoTo ExitProc
ControlError:
  MngError Err, "mnuViewDelete_Click", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub mnuViewEdit_Click()
  On Error GoTo ControlError

  pEditView m_grdv_id

  GoTo ExitProc
ControlError:
  MngError Err, "mnuViewEdit_Click", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub mnuViewItem_Click(Index As Integer)
  On Error GoTo ControlError
  
  Dim grdv_id As Long
  
  pSetUncheckedViewItems
  
  grdv_id = Val(mnuViewItem.Item(Index).Tag)
  If m_Grid.SelectView(grItems, Abs(grdv_id)) Then
    m_grdv_id = grdv_id
    mnuViewItem.Item(Index).Checked = True
  End If
  
  pSetViewEditDelete
  
  GoTo ExitProc
ControlError:
  MngError Err, "mnuViewItem_Click", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub mnuViewSave_Click()
  On Error GoTo ControlError

  If m_grdv_id = csNO_ID Or m_grdv_id < 0 Then

    pEditView csNO_ID
  
  Else
  
    pSaveView m_grdv_id
  End If

  GoTo ExitProc
ControlError:
  MngError Err, "mnuViewSave_Click", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub mnuViewSaveAs_Click()
  On Error GoTo ControlError

  pEditView csNO_ID

  GoTo ExitProc
ControlError:
  MngError Err, "mnuViewSaveAs_Click", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub pCreateMenuViews()
  Dim View As cGridView
  
  For Each View In m_Grid.Views
    If Not (View.Publica And View.us_id <> User.Id) Then
      AddView View.Nombre, View.Id
    End If
  Next
  
  For Each View In m_Grid.Views
    If (View.Publica And View.us_id <> User.Id) Then
      pAddView View.Nombre, View.Id, True
    End If
  Next
  
  pSetVisiblePopGridView
End Sub

Private Sub pSetVisiblePopGridView()
  On Error Resume Next
  mnuViewSepItem.Visible = pExistsViewItemsVisible()
End Sub

Private Function pExistsViewItemsVisible() As Boolean
  On Error Resume Next
  
  Dim i         As Long
  Dim bVisible  As Boolean
  
  With mnuViewItem
    
    For i = .LBound + 1 To .UBound
      If .Item(i).Visible Then
        pExistsViewItemsVisible = True
        Err.Clear
        Exit Function
      End If
    Next
  End With
End Function

Private Function pEditView(ByVal grdv_id As Long) As Boolean
  On Error GoTo ControlError

  Dim objEdit As Object
  Dim IsNew   As Boolean
  Dim View    As cGridView
  
  Set objEdit = CSKernelClient2.CreateObject("CSGeneralEx2.cGridViewEdit")
  
  IsNew = grdv_id = csNO_ID
  
  objEdit.us_id = User.Id
  objEdit.rpt_id = m_rpt_id
  
  If objEdit.EditView(grdv_id) Then
  
    If IsNew Then
      
      pEditView = pSaveView(objEdit.Id)
      
      If m_Grid.LoadView(objEdit.Id, View) Then
      
        If Not View Is Nothing Then
          AddView View.Nombre, View.Id
          pSetVisiblePopGridView
        End If
      End If
    Else
      If Not View Is Nothing Then
        pUpdateViewItem View.Nombre
      End If
    End If
  End If
  
  GoTo ExitProc
ControlError:
  MngError Err, "pSaveView", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pSaveView(ByVal grdv_id As Long) As Boolean
  On Error GoTo ControlError
  
  Dim Mouse As cMouseWait
  Set Mouse = New cMouseWait
  
  If Not m_Grid.SaveView(grItems, grdv_id) Then
    Exit Function
  End If

  pSaveView = True

  GoTo ExitProc
ControlError:
  MngError Err, "pSaveView", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Sub pSetViewEditDelete()
  If m_grdv_id = csNO_ID Or m_grdv_id < 0 Then
    mnuViewDelete.Caption = "&Borrar Vista"
    mnuViewDelete.Enabled = False
    mnuViewEdit.Caption = "&Editar Vista..."
    pSetVisiblePopGridView
  Else
    Dim ViewName As String
    ViewName = pGetSelectedView()
    mnuViewDelete.Caption = "&Borrar Vista " & ViewName
    mnuViewDelete.Enabled = True
    mnuViewEdit.Caption = "&Editar Vista " & ViewName & "..."
  End If
End Sub

Private Function pGetSelectedView() As String
  On Error Resume Next
  Dim i   As Long
  Dim Id  As Long
  
  For i = 1 To mnuViewItem.Count
    Id = 0
    Id = Val(mnuViewItem.Item(i).Tag)
    If Err.Number Then
      Err.Clear
    Else
      If Id = m_grdv_id Then
        pGetSelectedView = mnuViewItem.Item(i).Caption
        Exit Function
      End If
    End If
  Next
  Err.Clear
End Function

Private Sub pUpdateViewItem(ByVal ViewName As String)
  On Error Resume Next
  Dim i   As Long
  Dim Id  As Long
  
  For i = 1 To mnuViewItem.Count
    Id = 0
    Id = Val(mnuViewItem.Item(i).Tag)
    If Err.Number Then
      Err.Clear
    Else
      If Id = m_grdv_id Then
        mnuViewItem.Item(i).Caption = ViewName
        Exit Sub
      End If
    End If
  Next
  Err.Clear
End Sub

Private Sub pSetDeleteViewItem()
  On Error Resume Next
  Dim i   As Long
  Dim Id  As Long
  
  For i = 1 To mnuViewItem.Count
    Id = 0
    Id = Val(mnuViewItem.Item(i).Tag)
    If Err.Number Then
      Err.Clear
    Else
      If Id = m_grdv_id Then
        mnuViewItem.Item(i).Visible = False
        Exit Sub
      End If
    End If
  Next
  Err.Clear
End Sub

Private Sub pSetUncheckedViewItems()
  On Error Resume Next
  Dim i As Long
  For i = 1 To mnuViewItem.Count
    mnuViewItem.Item(i).Checked = False
  Next
  Err.Clear
End Sub

Private Sub tbrTool_ButtonClick(ByVal lButton As Long)
  Select Case tbrTool.ButtonKey(lButton)
    Case c_TblKeyExcel
      pExportExcel
    Case c_TblKeyXml
      pExportXml
    Case c_TblKeyFilters
      grItems.ShowFilters
    Case c_TblKeyFormats
      grItems.ShowFormats
    Case c_TblKeyGroup
      grItems.GroupColumns
    Case c_TblKeyTotals
      grItems.ShowFormulas
    Case c_TblKeyRefresh
      pRefresh
    Case c_TblKeyParams
      pShowParams
  End Select
End Sub

Private Sub pShowParams()
  MsgInfo m_ParamDescrip
End Sub

Private Sub pExportExcel()
  On Error Resume Next
  Dim Export As cExporToExcel
  Set Export = New cExporToExcel
  
  Export.ShowDialog = True
  Export.Export dblExGrid, "", grItems
End Sub

Private Sub pExportXml()
  On Error Resume Next
  
  Dim Export As cExportToXML
  Set Export = New cExportToXML
  
  Dim File As CSKernelFile.cFile
  Set File = New CSKernelFile.cFile
  
  Dim FullFile As String
  
  FullFile = GetEspecialFolders(sfidDESKTOP) & "\" & m_inf_codigo & ".xml"
  
  File.Init "pExportXml", C_Module, Me.cd
  File.Filter = "XML Files|*.xml"
  Me.cd.InitDir = File.GetPath(FullFile)
  If Not File.FSave(FullFile, False, False) Then Exit Sub
  
  FullFile = GetValidPath(File.Path) & File.Name
  
  Dim xmlHeader   As String
  Dim xmlFooter   As String
  Dim def_xmlRow  As String
  
  xmlHeader = pGetXmlHeader()
  xmlFooter = pGetXmlFooter()
  def_xmlRow = pGetDefXmlRow()
  
  Export.ShowDialog = True
  If Export.Export(dblExGrid, _
                FullFile, _
                xmlHeader, _
                xmlFooter, _
                def_xmlRow, _
                grItems) Then
    MsgInfo LNGGetText(3586, vbNullString)
  End If
End Sub

Private Function pGetXmlHeader() As String

  Const c_start_xml_header = ";--start xml header--"
  Const c_end_xml_header = ";--end xml header--"

  pGetXmlHeader = pGetXmlDefAux(c_start_xml_header, c_end_xml_header)

End Function

Private Function pGetXmlFooter() As String

  Const c_start_xml_footer = ";--start xml footer--"
  Const c_end_xml_footer = ";--end xml footer--"

  pGetXmlFooter = pGetXmlDefAux(c_start_xml_footer, c_end_xml_footer)

End Function

Private Function pGetDefXmlRow() As String

  Const c_start_xml_def_row = ";--start xml def row--"
  Const c_end_xml_def_row = ";--end xml def row--"

  pGetDefXmlRow = pGetXmlDefAux(c_start_xml_def_row, c_end_xml_def_row)

End Function

Private Function pGetXmlDefAux(ByVal TagStart As String, _
                               ByVal TagEnd As String) As String
  Dim xmlDefFile As String
  
  xmlDefFile = GetValidPath(m_RptPath) & _
               m_inf_codigo & _
               "_exp.xml"
                
  If ExistsFile(xmlDefFile) Then
    
    Dim iFile As Long
    iFile = FreeFile
    
    Open xmlDefFile For Input As #iFile
    
    Dim scriptLen As Long
    scriptLen = FileLen(xmlDefFile)
    
    If scriptLen Then
      
      Dim strXmlDef  As String
      strXmlDef = Input$(LOF(iFile), iFile)
          
      Close iFile
      
      Dim i As Long
      i = InStr(1, LCase$(strXmlDef), TagStart)
      
      If i Then
        Dim end_tag As Long
        
        end_tag = InStr(i + 1, LCase$(strXmlDef), TagEnd)
        i = i + Len(TagStart) + 2
        end_tag = end_tag - i - 1
        If end_tag > 0 Then
          pGetXmlDefAux = pReplaceMacros(Mid$(strXmlDef, i, end_tag))
        End If
      End If
    
    Else
        
      Close iFile
  
    End If
    
  End If

End Function

Private Function pReplaceMacros(ByVal Text As String) As String

  Dim i As Long
  
  Const c_param_text = "@@param_text("
  Const c_param = "@@param("
  Const c_param_id = "@@param_id("
  
  Dim param As String
  
  For i = 1 To 100
    param = c_param_text & i & ")"
    If InStr(1, Text, param) Then
      Text = Replace(Text, param, pGetParam(i).Text)
    End If
  
    param = c_param & i & ")"
    If InStr(1, Text, param) Then
      Text = Replace(Text, param, pGetParam(i).Value)
    End If
  
    param = c_param_id & i & ")"
    If InStr(1, Text, param) Then
      Text = Replace(Text, param, pGetParam(i).Id)
    End If
  Next
  
  pReplaceMacros = Text
  
End Function

Private Function pGetParam(ByVal i As Long) As t_Params
  If i > UBound(m_vParams) Then Exit Function
  LSet pGetParam = m_vParams(i)
End Function

Private Sub pRefresh()
  On Error GoTo ControlError
  Dim oldCommandTimeOut As Long
  
  oldCommandTimeOut = gDB.CommandTimeout
  If m_CommandTimeout > 0 Then gDB.CommandTimeout = m_CommandTimeout
  
  m_Grid.LoadFromSqlstmtEx grItems, m_Sqlstmt, Nothing, True

  GoTo ExitProc
ControlError:
  MngError Err, "pRefresh", C_Module, "SP: " & m_Sqlstmt
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
  gDB.CommandTimeout = oldCommandTimeOut
End Sub

' construccion - destruccion
Private Sub Form_Load()
  On Error GoTo ControlError
        
  With tbrTool
    .ImageSource = CTBExternalImageList
    .DrawStyle = CTBDrawOfficeXPStyle
  
    .CreateToolbar 16, , , True
  
    .SetImageList Me.ilToolbar.hIml 'm_cIls.hIml
    
    .AddButton , 1, , , , , c_TblKeyGroup
    .ButtonToolTip(c_TblKeyGroup) = "Grupos"
  
    .AddButton , 4, , , , , c_TblKeyTotals
    .ButtonToolTip(c_TblKeyTotals) = "Totales"
  
    .AddButton , 3, , , , , c_TblKeyFilters
    .ButtonToolTip(c_TblKeyFilters) = "Filtros"
  
    .AddButton , 2, , , , , c_TblKeyFormats
    .ButtonToolTip(c_TblKeyFormats) = "Formatos"
  
    .AddButton , , , , , CTBSeparator
  
    .AddButton , 0, , , , , c_TblKeyExcel
    .ButtonToolTip(c_TblKeyExcel) = "Exportar a Excel"
  
    .AddButton , 7, , , , , c_TblKeyXml
    .ButtonToolTip(c_TblKeyXml) = "Exportar a Xml"
  
    .AddButton , 5, , , , , c_TblKeyRefresh
    .ButtonToolTip(c_TblKeyRefresh) = "Refrescar"
  
    .AddButton , 6, , , , , c_TblKeyParams
    .ButtonToolTip(c_TblKeyRefresh) = "Ver Parametros"
  
  End With

  With rbMain
    .DestroyRebar
    .CreateRebar Me.hWnd
    .AddBandByHwnd tbrTool.hWnd, , , , "MainToolBar"
    .BandChildMinWidth(.BandCount - 1) = 24
  End With

  On Error Resume Next
  CSKernelClient2.LoadForm Me, Me.Name

  GoTo ExitProc
ControlError:
  MngError Err, "", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
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



VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Object = "{353A8433-36B8-422E-ABBD-36CEE8BE628E}#1.0#0"; "CSButton.ocx"
Begin VB.Form fHelpTree 
   BackColor       =   &H00FFFFFF&
   Caption         =   "Form1"
   ClientHeight    =   6180
   ClientLeft      =   165
   ClientTop       =   555
   ClientWidth     =   8025
   Icon            =   "fHelpTree.frx":0000
   KeyPreview      =   -1  'True
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   ScaleHeight     =   6180
   ScaleWidth      =   8025
   StartUpPosition =   3  'Windows Default
   Begin VB.ComboBox cbTrees 
      Height          =   315
      Left            =   60
      Style           =   2  'Dropdown List
      TabIndex        =   13
      Top             =   840
      Width           =   2355
   End
   Begin VB.OptionButton opStartWith 
      BackColor       =   &H00FFFFFF&
      Caption         =   "Comi&enza con ..."
      Height          =   240
      Left            =   6435
      TabIndex        =   3
      Top             =   5310
      Width           =   1545
   End
   Begin VB.OptionButton opContains 
      BackColor       =   &H00FFFFFF&
      Caption         =   "C&ontiene a ..."
      Height          =   240
      Left            =   4995
      TabIndex        =   2
      Top             =   5310
      Width           =   1275
   End
   Begin VB.PictureBox picSplitterBar 
      BackColor       =   &H8000000D&
      BorderStyle     =   0  'None
      Height          =   4290
      Left            =   4860
      ScaleHeight     =   4290
      ScaleWidth      =   105
      TabIndex        =   10
      Top             =   795
      Width           =   105
   End
   Begin VB.PictureBox picSplitter 
      BackColor       =   &H80000005&
      BorderStyle     =   0  'None
      Height          =   4290
      Left            =   2430
      ScaleHeight     =   4290
      ScaleWidth      =   105
      TabIndex        =   9
      Top             =   840
      Width           =   105
   End
   Begin VB.Timer tmSearch 
      Enabled         =   0   'False
      Interval        =   1000
      Left            =   4365
      Top             =   180
   End
   Begin VB.TextBox txSearch 
      BorderStyle     =   0  'None
      Height          =   255
      Left            =   735
      TabIndex        =   1
      Top             =   5310
      Width           =   4125
   End
   Begin CSButton.cButtonLigth cmdCancel 
      Cancel          =   -1  'True
      Height          =   330
      Left            =   6795
      TabIndex        =   5
      Top             =   5805
      Width           =   1140
      _ExtentX        =   2011
      _ExtentY        =   582
      Caption         =   "&Cancelar"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      FontName        =   "MS Sans Serif"
      FontSize        =   8.25
   End
   Begin CSButton.cButtonLigth cmdOk 
      Height          =   330
      Left            =   5310
      TabIndex        =   4
      Top             =   5805
      Width           =   1320
      _ExtentX        =   2328
      _ExtentY        =   582
      Caption         =   "&Seleccionar   "
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      FontName        =   "MS Sans Serif"
      FontSize        =   8.25
      Picture         =   "fHelpTree.frx":000C
   End
   Begin CSButton.cButtonLigth cmdViewAll 
      Height          =   330
      Left            =   3960
      TabIndex        =   8
      Top             =   5805
      Width           =   1185
      _ExtentX        =   2090
      _ExtentY        =   582
      Caption         =   "&Ver todos  "
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      FontName        =   "MS Sans Serif"
      FontSize        =   8.25
      Picture         =   "fHelpTree.frx":05A6
   End
   Begin MSComctlLib.ImageList ImgTree 
      Left            =   3240
      Top             =   90
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483643
      ImageWidth      =   16
      ImageHeight     =   16
      MaskColor       =   12632256
      _Version        =   393216
      BeginProperty Images {2C247F25-8591-11D1-B16A-00C0F0283628} 
         NumListImages   =   6
         BeginProperty ListImage1 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fHelpTree.frx":0B40
            Key             =   ""
         EndProperty
         BeginProperty ListImage2 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fHelpTree.frx":10DA
            Key             =   ""
         EndProperty
         BeginProperty ListImage3 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fHelpTree.frx":1674
            Key             =   ""
         EndProperty
         BeginProperty ListImage4 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fHelpTree.frx":1C0E
            Key             =   ""
         EndProperty
         BeginProperty ListImage5 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fHelpTree.frx":21A8
            Key             =   ""
         EndProperty
         BeginProperty ListImage6 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fHelpTree.frx":2742
            Key             =   ""
         EndProperty
      EndProperty
   End
   Begin MSComctlLib.ListView grData 
      Height          =   1455
      Left            =   2610
      TabIndex        =   7
      Top             =   855
      Width           =   1995
      _ExtentX        =   3519
      _ExtentY        =   2566
      LabelEdit       =   1
      MultiSelect     =   -1  'True
      LabelWrap       =   -1  'True
      HideSelection   =   0   'False
      _Version        =   393217
      Icons           =   "ImgTree"
      SmallIcons      =   "ImgTree"
      ForeColor       =   -2147483640
      BackColor       =   -2147483643
      Appearance      =   0
      NumItems        =   0
   End
   Begin MSComctlLib.TreeView twTree 
      Height          =   3885
      Left            =   90
      TabIndex        =   6
      Top             =   1260
      Width           =   2265
      _ExtentX        =   3995
      _ExtentY        =   6853
      _Version        =   393217
      Indentation     =   353
      LabelEdit       =   1
      LineStyle       =   1
      Style           =   7
      ImageList       =   "ImgTree"
      Appearance      =   0
   End
   Begin CSButton.cButtonLigth cmdDocs 
      Height          =   330
      Left            =   45
      TabIndex        =   12
      Top             =   5805
      Width           =   1890
      _ExtentX        =   3334
      _ExtentY        =   582
      Caption         =   "&Archivos Asociados"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      FontName        =   "MS Sans Serif"
      FontSize        =   8.25
      Picture         =   "fHelpTree.frx":2CDC
   End
   Begin VB.Image ImgDragListVarios 
      Height          =   480
      Left            =   5220
      Picture         =   "fHelpTree.frx":2E36
      Top             =   0
      Visible         =   0   'False
      Width           =   480
   End
   Begin VB.Image ImgDragList 
      Height          =   480
      Left            =   6840
      Picture         =   "fHelpTree.frx":3140
      Top             =   120
      Visible         =   0   'False
      Width           =   480
   End
   Begin VB.Image ImgDrag 
      Height          =   480
      Left            =   5940
      Picture         =   "fHelpTree.frx":344A
      Top             =   180
      Visible         =   0   'False
      Width           =   480
   End
   Begin VB.Label Label1 
      BackStyle       =   0  'Transparent
      Caption         =   "&Buscar:"
      ForeColor       =   &H80000008&
      Height          =   195
      Left            =   60
      TabIndex        =   0
      Top             =   5340
      Width           =   750
   End
   Begin VB.Shape shSearch 
      BorderColor     =   &H80000010&
      Height          =   285
      Left            =   705
      Top             =   5295
      Width           =   4185
   End
   Begin VB.Shape shTree 
      BorderColor     =   &H80000010&
      Height          =   3930
      Left            =   75
      Top             =   1245
      Width           =   2340
   End
   Begin VB.Shape shGrid 
      BorderColor     =   &H80000010&
      Height          =   4335
      Left            =   2580
      Top             =   840
      Width           =   5400
   End
   Begin VB.Label lbCaption 
      BackStyle       =   0  'Transparent
      Caption         =   "Seleccionar"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   13.5
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H8000000E&
      Height          =   420
      Left            =   720
      TabIndex        =   11
      Top             =   180
      Width           =   4110
   End
   Begin VB.Image Image1 
      Height          =   480
      Left            =   135
      Picture         =   "fHelpTree.frx":3754
      Top             =   90
      Width           =   480
   End
   Begin VB.Shape shBottom 
      BackColor       =   &H8000000F&
      BackStyle       =   1  'Opaque
      BorderStyle     =   0  'Transparent
      Height          =   555
      Left            =   0
      Top             =   5640
      Width           =   8130
   End
   Begin VB.Shape shTop 
      BackColor       =   &H80000010&
      BackStyle       =   1  'Opaque
      BorderStyle     =   0  'Transparent
      Height          =   780
      Left            =   -45
      Top             =   0
      Width           =   8070
   End
   Begin VB.Menu popTree 
      Caption         =   "popArbol"
      Visible         =   0   'False
      Begin VB.Menu mnuEdit 
         Caption         =   "Edición"
         Begin VB.Menu mnuEditEx 
            Caption         =   ""
            Index           =   0
         End
      End
      Begin VB.Menu popSep5 
         Caption         =   "-"
      End
      Begin VB.Menu popNewTree 
         Caption         =   "Nuevo &Arbol"
      End
      Begin VB.Menu popSep1 
         Caption         =   "-"
      End
      Begin VB.Menu popNewFolder 
         Caption         =   "&Nueva carpeta"
      End
      Begin VB.Menu popDeleteFolder 
         Caption         =   "&Borrar"
      End
      Begin VB.Menu popRenameFolder 
         Caption         =   "&Renombrar"
      End
      Begin VB.Menu popSep2 
         Caption         =   "-"
      End
      Begin VB.Menu popCutFolder 
         Caption         =   "&Cortar"
      End
      Begin VB.Menu popCopyFolder 
         Caption         =   "&Copiar"
      End
      Begin VB.Menu popPasteInFolder 
         Caption         =   "&Pegar"
      End
      Begin VB.Menu popSep3 
         Caption         =   "-"
      End
      Begin VB.Menu popCopyOnlyChilds 
         Caption         =   "Copiar solo los &Hijos"
      End
      Begin VB.Menu popCutOnlyChilds 
         Caption         =   "Cortar solo los Hijos"
      End
      Begin VB.Menu popSep4 
         Caption         =   "-"
      End
      Begin VB.Menu popUp 
         Caption         =   "&Subir"
      End
      Begin VB.Menu popDown 
         Caption         =   "&Bajar"
      End
      Begin VB.Menu popSep6 
         Caption         =   "-"
      End
      Begin VB.Menu popSort 
         Caption         =   "&Ordenar Carpetas"
      End
      Begin VB.Menu popSep7 
         Caption         =   "-"
      End
      Begin VB.Menu popExportToExcel 
         Caption         =   "&Exportar a Excel"
      End
   End
   Begin VB.Menu popGrid 
      Caption         =   "popGrilla"
      Visible         =   0   'False
      Begin VB.Menu popCopyItem 
         Caption         =   "&Copiar"
      End
      Begin VB.Menu popCutItem 
         Caption         =   "Cor&tar"
      End
      Begin VB.Menu popPasteInFolder2 
         Caption         =   "&Pegar"
      End
      Begin VB.Menu popSep8 
         Caption         =   "-"
      End
      Begin VB.Menu popExportToExcel2 
         Caption         =   "&Exportar a Excel"
      End
   End
End
Attribute VB_Name = "fHelpTree"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' FrmHelptwTree
' 17-01-00

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
  ' constantes
  ' estructuras
  ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "fHelpTree"

Const sglSplitLimit = 500

Private Const IMG_Active_TRUE = 3
Private Const IMG_Active_FALSE = 4

Private Const KEY_NODO = "N"

Const KEY_FATHER = "FATHER"
Const KEY_BRANCH_Key = "BRANCHC"
Private Const TREE_CLIENT_ID = "LEAVE_ID"   ' Es el id del Client no de la Leave

Private Const C_Ctrl_Tree = 1
Private Const C_Ctrl_Grid = 2

' eventos
Public Event ReloadRs()

' estructuras
' variables privadas
Private m_Id        As String
Private m_Code      As String
Private m_Name      As String
Private m_OK        As Boolean
Private m_rs        As Recordset
Private m_Grid      As cListView

Private m_ObjEditName     As String
Private m_ObjABMName      As String
Private m_ClientTable     As String
Private m_TableNameLogic  As String

Private m_LastChange    As Single
Private m_HaveTop       As Boolean
Private m_Searched      As String
Private m_FilterType    As Long
Private m_bDontClick    As Boolean

' for splitt
Private m_Moving    As Boolean

Private m_Trees     As cTrees
'Private m_OldTree   As Long
'Private m_OldBranch As Long
Private m_TableId   As Long
Private m_OldKey    As String

Private m_LastActiveCtrl      As Long

Private m_bSecondKeyPress     As Boolean

Private m_Done                As Boolean

'------------------------------------------------
' Nuevo manejo del arbol
'
Const MIN_TIME_DRAG_DROP = 0.2

Private Enum csWhatCopied
  csCopyedItems
  csCopyedBranchs
End Enum

Private Enum csToDo
  csDiscard
  csPaste
End Enum

Const MOUSE_UP = 1
Const MOUSE_NODE = 2

Private Const csDragCut = 1
Private Const csDragCopy = 2

Private m_CollapseBug     As Single ' El treeview tiene un bug cuando se colapsa
                                    ' envia por error un evento check, con este flag
                                    ' corregimos el bug

' Drag operation
Private m_InDrag      As Boolean
Private m_NodeToDrag  As MSComctlLib.Node
Private m_DragFolder  As Boolean
Private m_DragOperation As Integer

Private m_ListLeftButton   As Boolean

Private m_BeginClick As Single        ' Timer al momento del click
'
Private m_WasButtonRigth  As Boolean    ' Flag que indica que se presiono el Button derecho del
'                      ' mouse se prende en MouseDown y se apaga en MosueUp
'                      ' del control twTree
'
Private m_PopUpMenuShowed As Boolean    ' Flag que indica que no hay que mostrar el popup menu
'                      ' en el evento MouseUp del twTree, por que ya se mostro
'                      ' en el evento NodeClick del mismo control
'
Private m_vCopy()   As Long ' Contiene los Ids copiados y cortados
Private m_vDrag()   As Long ' Contiene los Ids dragueados
'
Private m_csWhatCopied  As csWhatCopied
Private m_Copying     As Boolean  ' Indica si hay algo que Paste
Private m_Copied      As Boolean  ' Indican la operacion de copia realizada
Private m_Cut         As Boolean
Private m_TreeCut     As Long     ' guarda el id del Tree desde el que se corto
Private m_CopiedCutOnlyChilds   As Boolean  ' Solo para Folders: indica si se copian o cortan solo las Folders
'                                            ' que dependen de esta rama
Private m_BranchIdCopyed As Long

' variables privadas
'Private m_Name        As String
'Private m_Moving      As Boolean
'Private m_Trees       As CSOAPI2.cTrees
Private m_CurrTree    As Long
Private m_CurrBranch  As Long
'Private m_Buttons1    As Long
'Private m_Buttons2    As Long
'Private m_Buttons3    As Long
'Private m_Grid        As CSOAPI2.cListView
'Private m_OldKey      As String
'Private m_TableId     As Long
'Private m_Selected    As cSelectedItems

Private m_TimerDrag   As Single   ' lo uso para saber si esta dragueando (o como carajo se diga)

Private m_NoLoadItemsSelected As Boolean

'------------------------------------------------

' Properties publicas
Public Property Get Id() As String
  Id = m_Id
End Property

Public Property Get Code() As String
  Code = m_Code
End Property

Public Property Get Ok() As Boolean
  Ok = m_OK
End Property

Public Property Get FormName() As String
  FormName = m_Name
End Property

Public Property Set rs(ByVal rhs As Recordset)
  Set m_rs = rhs
End Property

Public Property Get ObjEditName() As String
  ObjEditName = m_ObjEditName
End Property
Public Property Let ObjEditName(ByVal rhs As String)
  m_ObjEditName = rhs
End Property

Public Property Get ObjABMName() As String
  ObjABMName = m_ObjABMName
End Property
Public Property Let ObjABMName(ByVal rhs As String)
  m_ObjABMName = rhs
End Property

Public Property Let TableNameLogic(ByVal rhs As String)
  m_TableNameLogic = rhs
End Property

Public Property Let ClientTable(ByVal rhs As String)
  m_ClientTable = rhs
End Property

Public Property Let TableId(ByVal rhs As Long)
  m_TableId = rhs
End Property

Public Property Let HaveTop(ByRef rhs As Boolean)
  m_HaveTop = rhs
End Property

Public Property Get FilterType() As Integer
  FilterType = m_FilterType
End Property

' Properties privadas
' funciones publicas
Public Function LoadItems() As Boolean
  Set m_Grid = New cListView
  grData.Appearance = ccFlat
  m_Grid.SetPropertys grData
  
  ' Por ahora dejamos de usar el icono
  '
  'm_Grid.IMG_Active_FALSE =IMG_Active_FALSE
  'm_Grid.IMG_Active_TRUE = IMG_Active_TRUE
  '
  m_Grid.LoadFromRecordSet grData, m_rs
  m_Grid.GetColumnWidth grData, pGetFormName
  LoadTree m_TableId
  LoadItems = True

  With picSplitterBar
    .Left = GetRegistry(csInterface, pGetFormName & "_SPLITTER_LEFT", 3000)
    .Width = 40
  End With
  SizeControls
End Function

' funciones privadas
Private Sub cmdDocs_Click()
  On Error GoTo ControlError
  
  Dim Id As Long
  Id = m_Grid.GetSelectedId(grData)
  If Id = 0 Then Exit Sub
  
  Dim Doc As cDocDigital
  Set Doc = New cDocDigital

  Doc.ClientTable = m_ClientTable
  Doc.ClientTableID = Id

  Doc.ShowDocs gDB

  GoTo ExitProc
ControlError:
  MngError Err, "cmdDocs_Click", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub cbTrees_Click()
  If m_CurrTree = ListID(cbTrees) Then Exit Sub
  m_CurrTree = ListID(cbTrees)
  
  LoadBranchs m_CurrTree
  
  m_Grid.Clear grData
End Sub

Private Sub cmdCancel_Click()
  G_FormResult = False
  m_OK = False
  Me.Hide
End Sub

Private Sub cmdOk_Click()
  
  If m_LastActiveCtrl = C_Ctrl_Tree Then
    
    twTree_DblClick
  
  Else
    
    With grData.ListItems
      
      If .Count = 1 Then
        .Item(1).Selected = True
        grData_DblClick
      Else

        If Not (grData.SelectedItem Is Nothing) Then
          
          Dim Selecteds    As Long
          Dim i            As Long
          Dim vSelecteds() As Long
          
          ReDim vSelecteds(0)
          
          For i = 1 To .Count
            If .Item(i).Selected Then
              Selecteds = Selecteds + 1
              ReDim Preserve vSelecteds(Selecteds)
              vSelecteds(Selecteds) = m_Grid.IdFromItem(.Item(i)) * -1
            End If
          Next
          
          If Selecteds = 1 Then
            grData_DblClick
          
          Else
            Dim BranchId    As Long
            Dim BranchName  As String
            Dim TreeId      As Long
            
            ' Tengo que crear un arbol
            If cbTrees.ListCount = 0 Then
              If Not m_Trees.Add2(m_TableNameLogic, m_TableId, TreeId) Then Exit Sub
            Else
              TreeId = ListItemData(cbTrees, 0)
            End If
            
            ' Uso el primer arbol por las dudas que no halla un arbol activo
            With m_Trees(TreeId).Branchs
            
              BranchName = "Selección múltiple"
              
              If Not .Add2(BranchName, TreeId, csTEMP_BRANCH, BranchId) Then Exit Sub
              
              ' Ahora agrego las hojas a esta nueva rama
              Dim Branch As cBranch
              Set Branch = New cBranch
              
              Branch.Leaves.Paste vSelecteds, BranchId, False
              
              m_Id = KEY_NODO & BranchId
              m_Name = BranchName
              m_Code = BranchName
              m_OK = True
              Wait 0.25
              Me.Hide
            End With
            
          End If
        End If
      End If
    End With
  End If
End Sub

Private Sub cmdViewAll_Click()
  txSearch.Text = ""
  m_LastChange = 0
  m_Searched = "#"
  Search
End Sub

Private Sub Form_KeyDown(KeyCode As Integer, Shift As Integer)
  
  If Shift And vbCtrlMask And UCase(Chr(KeyCode)) = "T" Then
    cmdViewAll_Click
    
  ElseIf KeyCode = vbKeyEscape Then
    cmdCancel_Click
  
  ElseIf KeyCode = vbKeyReturn Then
    
    ' Si el enter se produce en la caja de busqueda
    '
    If Not Me.ActiveControl Is Nothing Then
      If Me.ActiveControl Is txSearch Then
      
        ' Si aun no busque lo que escribio lo hago ahora
        '
        If tmSearch.Enabled Then
          m_LastChange = 0
          Search
        End If
        
        ' Si no hay nada seleccionado y hay al
        ' menos uno en la grilla lo selecciono
        '
        If grData.SelectedItem Is Nothing Then
          If grData.ListItems.Count Then
            grData.ListItems(1).Selected = True
          End If
        End If
      End If
    End If
    
    ' Finalmente si presionaron enter llamo a Ok
    '
    cmdOk_Click
  End If
End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
  tmSearch.Enabled = False
End Sub

Private Sub grData_GotFocus()
  m_LastActiveCtrl = C_Ctrl_Grid
End Sub

Private Sub grData_KeyUp(KeyCode As Integer, Shift As Integer)
  On Error Resume Next
  If KeyCode = vbKeyDown Then
    If grData.SelectedItem Is Nothing Then
      If grData.ListItems.Count = 0 Then
        txSearch.SetFocus
      End If
    Else
      If grData.SelectedItem.Index = grData.ListItems.Count Then
        If m_bSecondKeyPress Then
          m_bSecondKeyPress = False
          txSearch.SetFocus
        Else
          m_bSecondKeyPress = True
        End If
      End If
    End If
  ElseIf KeyCode = vbKeyUp Then
    If grData.SelectedItem Is Nothing Then
      If grData.ListItems.Count = 0 Then
        txSearch.SetFocus
      End If
    Else
      If grData.SelectedItem.Index = 1 Then
        If m_bSecondKeyPress Then
          m_bSecondKeyPress = False
          txSearch.SetFocus
        Else
          m_bSecondKeyPress = True
        End If
      End If
    End If
  Else
    m_bSecondKeyPress = False
  End If
End Sub

Private Sub grData_LostFocus()
  m_bSecondKeyPress = False
End Sub

Private Sub opContains_Click()
  If m_bDontClick Then
    m_bDontClick = False
  Else
    Search
  End If
End Sub

Private Sub opStartWith_Click()
  Search
End Sub

Private Sub twTree_DblClick()
  
  If twTree.SelectedItem Is Nothing Then Exit Sub
  
  m_Id = KEY_NODO & GetIdFromKey(twTree.SelectedItem.Key)
  m_Name = twTree.SelectedItem.Text
  m_Code = ""
  m_OK = True
  Wait 0.25
  Me.Hide
End Sub

Private Sub twTree_GotFocus()
  m_LastActiveCtrl = C_Ctrl_Tree
End Sub

' Nuevo manejo del arbol
'
'Private Sub twTree_NodeClick(ByVal Node As MSComctlLib.Node)
'  LoadBranch GetIdFromKey(Node.Key)
'End Sub

Private Function LoadTree(ByVal Id As Long) As Boolean
  
  Dim MouseWait As New cMouseWait
  MouseWait.Wait
  
  Dim Tree As CSOAPI2.cTree
  
  If Not m_Trees.Load(Id) Then Exit Function
  
  For Each Tree In m_Trees
    AddTree Tree.Name, Tree.Id
  Next
  
  m_TableId = Id
  
  ' el clik carga el Tree
  ListSetListIndexForId cbTrees, GetRegistry(csInterface, pGetFormName & "_LAST_TREE", m_CurrTree)
  
  m_CurrBranch = GetRegistry(csInterface, pGetFormName & "_LAST_FOLDER", m_CurrBranch)
  SetNodeForId twTree, m_CurrBranch
  
  ' para que la cargue en la grilla cuando
  ' el usuario la seleccione
  m_CurrBranch = 0
  
  On Error Resume Next
  twTree.Nodes.Item(1).Expanded = True
  
  LoadTree = True
End Function

Private Sub AddTree(ByVal Name As String, ByVal Id As Long)
  Dim i As Integer
  For i = 0 To cbTrees.ListCount - 1
    If cbTrees.ItemData(i) = Id Then Exit Sub
  Next
  ListAdd cbTrees, Name, Id
End Sub

Private Function LoadBranchs(ByVal Id As Long) As Boolean
  
  Dim MouseWait As New cMouseWait
  MouseWait.Wait
  
  Dim Branch As cBranch
  
  m_CurrBranch = 0
  
  m_Trees(Id).Load
  
  twTree.Nodes.Clear
  
  For Each Branch In m_Trees(Id).Branchs
    AddBranch Branch.Name, Branch.Father, Branch.Id, 1, 2
  Next
  
  'Order
  LoadBranchs = True
End Function

Private Function AddBranch(ByVal Text As String, ByVal Father As String, Optional ByVal Key As Variant, Optional Image As Variant, Optional SelectedImage As Variant) As Boolean
  Dim Nodo As Node
  
  If IsMissing(Key) Then
    If Not ExistsFather(Father) Then
      Set Nodo = twTree.Nodes.Add(, , , Text)
    Else
      Set Nodo = twTree.Nodes.Add(GetKey(Father), tvwChild, , Text)
    End If
  Else
    If Not ExistsFather(Father) Then
      Set Nodo = twTree.Nodes.Add(, , GetKey(Key), Text)
    Else
      Set Nodo = twTree.Nodes.Add(GetKey(Father), tvwChild, GetKey(Key), Text)
    End If
  End If
  If Not IsMissing(Image) Then
    Nodo.Image = Image
  End If
  If Not IsMissing(SelectedImage) Then
    Nodo.SelectedImage = SelectedImage
  End If
  Nodo.Tag = SetInfoString(Nodo.Tag, KEY_FATHER, Father)
End Function

Private Function ExistsFather(ByVal Father As String) As Boolean
  On Error GoTo ControlError
  
  Dim s As String
  
  s = twTree.Nodes(GetKey(Father)).Key
  
  ExistsFather = True
ControlError:
End Function

Private Sub LoadBranch(ByVal BranchId As Long)
  
  Dim MouseWait As New cMouseWait
  MouseWait.Wait
  
  If m_CurrBranch = BranchId Then Exit Sub
  m_CurrBranch = BranchId
  
  LoadLeavesRs m_Trees(m_CurrTree).Branchs(m_CurrBranch).Leaves, m_CurrBranch
  'pLoadGridRs m_Trees(m_CurrTree).Branchs(m_CurrBranch)
  LoadGridRs grData, m_Trees(m_CurrTree).Branchs(m_CurrBranch)
End Sub

'Private Function pLoadGridRs(ByRef Branch As cBranch) As Boolean
'
'  Dim MouseWait As New cMouseWait
'  MouseWait.Wait
'
'  Dim cLock As cLockUpdateWindow
'  Set cLock = New cLockUpdateWindow
'  cLock.LockW grData.hwnd
'
'  m_Grid.SaveColumnWidth grData, m_Name + "_" + m_OldKey
'
'  If Not m_Grid.LoadLeavesFromRsEx(grData, Branch.Leaves.rsLeaves, True) Then Exit Function
'
'  If GetInfoString(twTree.SelectedItem.Tag, KEY_BRANCH_Key) = "" Then
'    twTree.SelectedItem.Tag = SetInfoString(twTree.SelectedItem.Tag, KEY_BRANCH_Key, m_Grid.GetKeyFromColumns(Branch))
'  End If
'
'  m_OldKey = GetInfoString(twTree.SelectedItem.Tag, KEY_BRANCH_Key)
'  m_Grid.GetColumnWidth grData, m_Name & "_" & m_OldKey, 2
'
'  pLoadGridRs = True
'End Function

Private Function LoadLeavesRs(ByRef Leaves As cLeaves, ByVal BranchId As Long, Optional ByVal Refresh As Boolean = False) As Boolean
  Dim MouseWait As New cMouseWait
  MouseWait.Wait
  
  Dim LeavesLoaded As Boolean
  
  ' Puede pasar que BranchId se lea del registry (ultima Branch seleccionada para este form en esta maquina),
  ' y ya no exista en la base de datos, con lo que se genera un error
  On Error GoTo ControlError
  
  If Refresh Then Leaves.IsLoaded = False
  
  LeavesLoaded = Leaves.IsLoaded
  LoadLeavesRs = Leaves.LoadRs(BranchId, 300)

ControlError:
End Function

Private Sub grData_ColumnClick(ByVal ColumnHeader As MSComctlLib.ColumnHeader)
  ListViewSortColumns grData, ColumnHeader
End Sub

Private Sub grData_DblClick()
  m_Id = m_Grid.GetSelectedId(grData)
  m_Name = m_Grid.GetSelectedName(grData)
  m_Code = m_Grid.GetSelectedCode(grData)
  m_OK = True
  Wait 0.25
  Me.Hide
End Sub
'------------------------------------------------------------------------------------------------------------------------------------------
Private Sub PicSplitter_MouseDown(Button As Integer, Shift As Integer, x As Single, y As Single)
  With picSplitter
    picSplitterBar.Move .Left, .Top, .Width \ 2, .Height - 20
  End With
  picSplitterBar.ZOrder
  picSplitterBar.Visible = True
  m_Moving = True
End Sub

Private Sub PicSplitter_MouseMove(Button As Integer, Shift As Integer, x As Single, y As Single)
  Dim sglPos As Single

  If m_Moving Then
    sglPos = x + picSplitter.Left
    If sglPos < sglSplitLimit Then
      picSplitterBar.Left = sglSplitLimit
    ElseIf sglPos > Me.Width - sglSplitLimit Then
      picSplitterBar.Left = Me.Width - sglSplitLimit
    Else
      picSplitterBar.Left = sglPos
    End If
  End If
End Sub

Private Sub PicSplitter_MouseUp(Button As Integer, Shift As Integer, x As Single, y As Single)
  SizeControls
  picSplitterBar.Visible = False
  m_Moving = False
End Sub

Private Sub SizeControls()
  Dim i As Integer

  'SetPosControls
  If WindowState = vbMinimized Then Exit Sub

  On Error Resume Next
  
  Dim iHeight As Long

  iHeight = Me.ScaleHeight - shBottom.Height - txSearch.Height - 150

  ' Splitter
  With picSplitter
    .Left = picSplitterBar.Left
    .Height = iHeight - .Top - 50
  End With
  
  With picSplitterBar
    .Height = picSplitter.Height
  End With
  
  With shTree
    .Width = picSplitter.Left - 10 - .Left
    .Height = iHeight - .Top - 50
  End With
  
  With twTree
    .Width = picSplitter.Left - 50 - .Left
    .Height = iHeight - .Top - 80
  End With
  
  cbTrees.Width = shTree.Width
  
  With shGrid
    .Height = iHeight - .Top - 50
    .Left = picSplitter.Left + picSplitter.Width + 20
    .Width = ScaleWidth - .Left - 50
  End With
  
  With grData
    .Height = iHeight - .Top - 80
    .Left = shGrid.Left + 20
    .Width = ScaleWidth - .Left - 100
  End With
  
  With txSearch
    .Top = iHeight + 50
    .Width = ScaleWidth - 100 - .Left - opContains.Width - opStartWith.Width - 120
  End With
  
  With opContains
    .Top = iHeight + 20
    .Left = ScaleWidth - .Width - 60 - opStartWith.Width
  End With
  
  With opStartWith
    .Top = iHeight + 20
    .Left = ScaleWidth - .Width - 60
  End With
  
  With shSearch
    .Top = txSearch.Top - 20
    .Width = txSearch.Width + 50
  End With
  
  With shTop
    .Width = Me.ScaleWidth + 100
  End With
  
  With Label1
    .Top = txSearch.Top
  End With
  
  With shBottom
    .Top = Me.ScaleHeight - .Height + 20
    .Width = Me.ScaleWidth + 100
    cmdViewAll.Top = .Top + 120
    cmdCancel.Top = cmdViewAll.Top
    cmdOk.Top = cmdViewAll.Top
    cmdCancel.Left = Me.ScaleWidth - cmdCancel.Width - 100
    cmdOk.Left = cmdCancel.Left - cmdOk.Width - 100
    cmdViewAll.Left = cmdOk.Left - cmdViewAll.Width - 100
    cmdDocs.Top = cmdViewAll.Top
  End With
End Sub

Private Sub tmSearch_Timer()
  Search
End Sub

Private Function pGetFilterType() As Long
  If opStartWith.Value Then
    pGetFilterType = c_HelpFilterBeginLike
  Else
    pGetFilterType = c_HelpFilterHaveTo
  End If
End Function

Private Sub Search()
  On Error GoTo ControlError
  
  Dim iTimer As Single
  
  iTimer = Timer
  
  tmSearch.Enabled = False
  
  If m_FilterType <> pGetFilterType() Then
    
    m_FilterType = pGetFilterType()
  
  Else
    
    If iTimer - m_LastChange < 1 And m_Searched = txSearch.Text Then
      GoTo ExitProc
    End If
    
    If m_Searched = txSearch.Text Then GoTo ExitProc
  
  End If
  
  Dim toSearch As String
  
  toSearch = txSearch.Text
  
  If m_HaveTop Then
    RaiseEvent ReloadRs
  End If
  
  Dim Filter As String
  
  If m_HaveTop Then
    Filter = vbNullString
  Else
    Filter = txSearch.Text
  End If
  
  If m_Grid.LoadFromRecordSetEx( _
                grData, _
                m_rs, _
                m_FilterType = c_HelpFilterHaveTo, _
                Filter) Then
                       
    m_Grid.GetColumnWidth grData, pGetFormName
    m_Searched = toSearch
  End If
  
  GoTo ExitProc
ControlError:
  MngError Err, "Search", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

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

Private Sub Wait(ByVal t As Single)
  Dim Init As Single
  
  Init = Timer
  Do While Timer - Init < t
  Loop
End Sub

Private Function pGetFormName()
  pGetFormName = "T_" & Me.Caption
End Function

Private Sub Form_Resize()
  SizeControls
End Sub

'------------------------------------------------------------------------------------------------------------------------------------------
' construccion - destruccion

Private Sub Form_Activate()
  On Error Resume Next
  If m_Done Then Exit Sub
  m_Done = True
  
  lbCaption.Caption = Me.Caption
  txSearch.SetFocus
  grData.Refresh
End Sub

Private Sub Form_Load()
  On Error GoTo ControlError
  
  '-------------------------------
  ' Nuevo manejo del arbol
  '
  m_InDrag = False
  Set m_NodeToDrag = Nothing
  
  '-------------------------------
  
  m_Done = False
  G_FormResult = True
  m_OK = False
  
  With picSplitter
    .ZOrder
    .MousePointer = vbSizeWE
    picSplitterBar.Top = .Top
  End With
  
  m_bDontClick = True
  opContains.Value = True

  Set m_Trees = New cTrees

  GoTo ExitProc
ControlError:
  MngError Err, "Form_Load", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Form_Unload(Cancel As Integer)
  On Error Resume Next
  
  If WindowState <> vbMinimized Then
    SetRegistry csInterface, pGetFormName & "_SPLITTER_LEFT", picSplitter.Left
  End If
  
  m_Grid.SaveColumnWidth grData, pGetFormName
  Set m_Grid = Nothing
  CSKernelClient2.UnloadForm Me, pGetFormName
  Set m_Trees = Nothing
  SetRegistry csInterface, pGetFormName & "_LAST_TREE", m_CurrTree
  SetRegistry csInterface, pGetFormName & "_LAST_FOLDER", m_CurrBranch
End Sub

Private Sub txSearch_GotFocus()
  m_LastActiveCtrl = C_Ctrl_Grid
End Sub

Private Sub txSearch_KeyUp(KeyCode As Integer, Shift As Integer)
  On Error Resume Next
  If KeyCode = vbKeyUp Or KeyCode = vbKeyDown Then
    grData.SetFocus
  End If
End Sub

' ----------------------------------------------------------------------
' Nuevo manejo del arbol
'
Private Sub twTree_KeyDown(KeyCode As Integer, Shift As Integer)
  On Error Resume Next
  If KeyCode = vbKeyF2 Then twTree.StartLabelEdit
End Sub

Private Sub twTree_AfterLabelEdit(Cancel As Integer, NewString As String)
  On Error Resume Next
  Cancel = Not RenameFolder(NewString)
End Sub

Private Sub twTree_Collapse(ByVal Node As MSComctlLib.Node)
  m_CollapseBug = Timer
End Sub

Private Sub twTree_DragDrop(Source As Control, x As Single, y As Single)
  On Error GoTo ControlError
  If twTree.DropHighlight Is Nothing Then
    Set m_NodeToDrag = Nothing
    m_InDrag = False
    m_DragFolder = False
    Exit Sub
  Else
    If m_DragFolder Then
      If m_NodeToDrag.Key <> twTree.DropHighlight.Key Then
      
        ' Realizo la operacion
        DragDropFolder GetIdFromKey(twTree.DropHighlight.Key)
      End If
    Else
      
      ' Realizo la operacion
      DragDropItems GetIdFromKey(twTree.DropHighlight.Key)
    End If
    
    Set twTree.DropHighlight = Nothing
    ReDim m_vDrag(0)
    Set m_NodeToDrag = Nothing
    m_InDrag = False
    m_DragFolder = False
  End If
ControlError:
End Sub

Private Sub twTree_DragOver(Source As Control, x As Single, y As Single, State As Integer)
  On Error Resume Next
  
  If m_InDrag = True Then
    ' Set DropHighlight to the mouse's coordinates.
    Set twTree.DropHighlight = twTree.HitTest(x, y)
  End If
End Sub

Private Sub twTree_MouseMove(Button As Integer, Shift As Integer, x As Single, y As Single)
  On Error Resume Next
  
  If Button = vbLeftButton Then ' Signal a Drag operation.
    
    If Timer - m_BeginClick < MIN_TIME_DRAG_DROP And m_BeginClick <> 0 Then Exit Sub
    
    If m_InDrag Then Exit Sub
    
    If twTree.SelectedItem Is Nothing Then Exit Sub
    m_InDrag = True ' Set the flag to true.
    m_DragFolder = True
    ' Set the drag icon with the CreateDragImage method.
    twTree.DragIcon = ImgDrag.Picture
    twTree.Drag vbBeginDrag ' Drag operation.
  
    ' si tiene presionado el shift entonces esta cortando
    If Shift And 1 Then
      m_DragOperation = csDragCopy
    Else
      m_DragOperation = csDragCut
    End If
  Else
    m_InDrag = False
  End If
End Sub

Private Sub twTree_NodeClick(ByVal Node As MSComctlLib.Node)
  On Error Resume Next
  
  LoadBranch GetIdFromKey(Node.Key)
  If m_WasButtonRigth Then
    m_PopUpMenuShowed = True
    ShowMenu MOUSE_NODE
  End If
End Sub

Private Sub twTree_MouseDown(Button As Integer, Shift As Integer, x As Single, y As Single)
  On Error Resume Next
  
  m_BeginClick = Timer
  m_WasButtonRigth = Button = vbRightButton
  If Not m_WasButtonRigth Then
    ' para que en el click se seleccione la carpeta
    Set twTree.SelectedItem = twTree.HitTest(x, y)
    Set m_NodeToDrag = twTree.SelectedItem ' Obtengo una referencia al item a ser dragueado
  End If
End Sub

Private Sub twTree_MouseUp(Button As Integer, Shift As Integer, x As Single, y As Single)
  On Error Resume Next
  
  m_BeginClick = 0
  If Not m_PopUpMenuShowed And m_WasButtonRigth Then
    ShowMenu MOUSE_UP
  End If
  m_WasButtonRigth = False
  m_PopUpMenuShowed = False
End Sub

'--------------------------------------------------------------------------------
'
Private Function RenameFolder(ByVal NewName As String) As Boolean
  
  Dim MouseWait As New cMouseWait
  MouseWait.Wait
  
  If ValEmpty(NewName, csText) Then Exit Function
  RenameFolder = m_Trees(m_CurrTree).Branchs(GetIdFromKey(twTree.SelectedItem.Key)).Rename(NewName)
  
  ' si se trata de la raiz tengo que cambiar en el combo el nombre del arbol
  If Val(GetInfoString(twTree.SelectedItem.Tag, KEY_FATHER)) = csNO_ID Then
    ListChangeTextForSelected cbTrees, NewName
    ListSetListIndex cbTrees, cbTrees.ListCount - 1
    m_Trees(m_CurrTree).Name = NewName
  End If
End Function

Private Sub DragDropFolder(ByVal BranchIdToPaste As Long)
  Dim MouseWait As New cMouseWait
  MouseWait.Wait
  
  Dim IdOfCopy As Long
  Dim IsCut As Boolean
  
  Dim cLock As cLockUpdateWindow
  Set cLock = New cLockUpdateWindow
  cLock.LockW twTree.hwnd
  
  ' si movio a la misma rama no hay que hacer nada
  If BranchIdToPaste = GetIdFromKey(twTree.SelectedItem.Key) Then Exit Sub
  
  Select Case m_DragOperation
    Case csDragCopy
      IsCut = False
      
    Case csDragCut
      IsCut = True
  
      If m_Trees(m_CurrTree).Branchs.IsChildOf(BranchIdToPaste, GetIdFromKey(twTree.SelectedItem.Key)) Then
        MsgWarning LNGGetText(3227, vbNullString)
                    'No se puede mover a esta carpeta.;El destino es _
                    una subcarpeta del origen.
        Exit Sub
      End If
  End Select
  
  If Not m_Trees(m_CurrTree).Branchs.Paste(GetIdFromKey(twTree.SelectedItem.Key), BranchIdToPaste, False, IsCut) Then Exit Sub
  
  If Not m_Trees(m_CurrTree).Branchs.LoadBranch(BranchIdToPaste, IdOfCopy) Then Exit Sub
  
  If IsCut Then
    DelFolder twTree.SelectedItem
  End If
  
  LoadBranchsFromCopy IdOfCopy
End Sub

Private Sub DragDropItems(ByVal BranchIdToPaste As Long)
  Dim MouseWait As New cMouseWait
  MouseWait.Wait
  
  If twTree.SelectedItem Is Nothing Then Exit Sub
  
  ' si movio a la misma Branch no hay que hacer nada
  If BranchIdToPaste = GetIdFromKey(twTree.SelectedItem.Key) Then Exit Sub
  
  Select Case m_DragOperation
    Case csDragCopy
      If Not m_Trees(m_CurrTree).Branchs(BranchIdToPaste).Leaves.Paste(m_vDrag(), BranchIdToPaste, False) Then Exit Sub
    Case csDragCut
      If Not m_Trees(m_CurrTree).Branchs(BranchIdToPaste).Leaves.Paste(m_vDrag(), BranchIdToPaste, True) Then Exit Sub
  
      Dim BranchIdCopyed As Long
      BranchIdCopyed = GetIdFromKey(twTree.SelectedItem.Key)
      m_Trees(m_CurrTree).Branchs(BranchIdCopyed).Leaves.IsLoaded = False
      
      If Not LoadLeavesRs(m_Trees(m_CurrTree).Branchs(BranchIdCopyed).Leaves, BranchIdCopyed) Then Exit Sub
  
      m_CurrBranch = 0
      
      LoadGridRs grData, m_Trees(m_CurrTree).Branchs(BranchIdCopyed)
      m_CurrBranch = BranchIdCopyed
  
  End Select
  
  ' ya sea que copie o corte, tengo que recargar la rama destino
  m_Trees(m_CurrTree).Branchs(BranchIdToPaste).Leaves.IsLoaded = False
  If Not LoadLeavesRs(m_Trees(m_CurrTree).Branchs(BranchIdToPaste).Leaves, BranchIdToPaste) Then Exit Sub
End Sub

Private Sub ShowMenu(ByVal Quien As Integer)
  On Error Resume Next
  
  popNewFolder.Visible = True
  popDeleteFolder.Visible = True
  popCutFolder.Visible = True
  popCopyFolder.Visible = True
  popRenameFolder.Visible = True
  popCopyOnlyChilds.Visible = True
  popCutOnlyChilds.Visible = True
  popSep1.Visible = True
  popSep2.Visible = True
  popSep3.Visible = True
  popSep4.Visible = True
  popUp.Visible = True
  popDown.Visible = True
  popPasteInFolder.Visible = True
  If m_Copying Then
    popPasteInFolder.Enabled = True
  Else
    popPasteInFolder.Enabled = False
  End If
  
  popNewTree.Visible = True
  
  Select Case Quien
    Case MOUSE_NODE
    Case MOUSE_UP
      popNewFolder.Visible = False
      popDeleteFolder.Visible = False
      popCutFolder.Visible = False
      popCopyFolder.Visible = False
      popRenameFolder.Visible = False
      popPasteInFolder.Visible = False
      popCopyOnlyChilds.Visible = False
      popCutOnlyChilds.Visible = False
      popSep1.Visible = False
      popSep2.Visible = False
      popSep3.Visible = False
      popSep4.Visible = False
      popUp.Visible = False
      popDown.Visible = False
  End Select
  
  If mnuEditEx.UBound > 0 Then
    mnuEditEx.Item(0).Visible = False
    mnuEdit.Visible = True
    popSep5.Visible = True
  Else
    mnuEdit.Visible = False
    popSep5.Visible = False
  End If
  
  PopupMenu popTree
End Sub

Private Sub DelFolder(ByRef Nodo As Node)
  
  If Nodo Is Nothing Then Exit Sub
  
  twTree.Nodes.Remove Nodo.Index
  m_Grid.Clear grData
End Sub

Public Function LoadBranchsFromCopy(ByVal IdOfCopy As Long) As Boolean
  
  Dim MouseWait As New cMouseWait
  MouseWait.Wait
  
  Dim Branch As cBranch
  
  For Each Branch In m_Trees(m_CurrTree).Branchs
    If Branch.IdOfCopy = IdOfCopy Then
      AddBranch Branch.Name, Branch.Father, Branch.Id, 1, 2
    End If
  Next
  
  'Order
  LoadBranchsFromCopy = True
End Function

Private Function LoadGridRs(ByRef Grid As ListView, ByRef Branch As cBranch) As Boolean
  
  Dim MouseWait As New cMouseWait
  MouseWait.Wait
  
  Dim cLock As cLockUpdateWindow
  Set cLock = New cLockUpdateWindow
  cLock.LockW grData.hwnd
    
  m_Grid.SaveColumnWidth grData, m_Name + "_" + m_OldKey

  If Not m_Grid.LoadLeavesFromRs(grData, Branch.Leaves.rsLeaves) Then Exit Function
  
  ' Ahora seteo el Value check de cada item
  '
  SetChecks
  
  If twTree.SelectedItem Is Nothing Then
    pSelectNode Branch.Id
    If twTree.SelectedItem Is Nothing Then Exit Function
  End If
  
  If GetInfoString(twTree.SelectedItem.Tag, KEY_BRANCH_Key) = "" Then
    twTree.SelectedItem.Tag = SetInfoString(twTree.SelectedItem.Tag, KEY_BRANCH_Key, m_Grid.GetKeyFromColumns(Branch))
  End If
  
  m_OldKey = GetInfoString(twTree.SelectedItem.Tag, KEY_BRANCH_Key)
  m_Grid.GetColumnWidth grData, m_Name & "_" & m_OldKey, 2
  
  LoadGridRs = True
End Function

' Por ahora no soportamos checks
'
Private Sub SetChecks()

End Sub

Private Sub pSelectNode(ByVal branch_id As Long)
  Dim Node As Node
  For Each Node In twTree.Nodes
    If GetIdFromKey(Node.Key) = branch_id Then
      Node.Selected = True
      Node.EnsureVisible
      Exit For
    End If
  Next
End Sub

Private Sub grData_MouseDown(Button As Integer, Shift As Integer, x As Single, y As Single)
  On Error Resume Next
  
  m_ListLeftButton = Button <> vbRightButton
  If m_ListLeftButton Then
    
    m_InDrag = False
    
    If grData.HitTest(x, y) Is Nothing Then Exit Sub
    
    m_TimerDrag = Timer
    
    m_NoLoadItemsSelected = False
    
    ' 2 es control
    If (m_Grid.GetSelectedCount(grData) > 1) And ((Shift And 2) = 0) Then
      m_NoLoadItemsSelected = True
    End If
    
  End If
End Sub

Private Sub grData_MouseMove(Button As Integer, Shift As Integer, x As Single, y As Single)
  On Error Resume Next
  
  If Button = vbLeftButton Then ' Signal a Drag operation.

    If m_InDrag Then Exit Sub

    If Not (Timer - m_TimerDrag > 0.1) Then Exit Sub
    
    If grData.SelectedItem Is Nothing Then Exit Sub
    
    m_Grid.GetSelected grData, m_vDrag()
    
    If m_Grid.GetSelectedCount(grData) = 1 Then
      ' Set the drag icon with the CreateDragImage method.
      grData.DragIcon = ImgDragList.Picture
    Else
      grData.DragIcon = ImgDragListVarios.Picture
    End If
    
    m_InDrag = True ' Set the flag to true.
    m_DragFolder = False
    grData.Drag vbBeginDrag ' Drag operation.
    
    ' si tiene presionado el shift entonces esta cortando
    If Shift And 1 Then
      m_DragOperation = csDragCopy
    Else
      m_DragOperation = csDragCut
    End If
  End If
End Sub

Private Sub grData_MouseUp(Button As Integer, Shift As Integer, x As Single, y As Single)
  On Error Resume Next
  
  If Button = vbRightButton Then
    If m_Copying Then
      popPasteInFolder2.Enabled = True
    Else
      popPasteInFolder2.Enabled = False
    End If
    PopupMenu popGrid
  End If
  m_TimerDrag = 0
End Sub

'----------------------------------------------------------------------------------

Private Sub BeginCopy()
  On Error Resume Next
  
  Select Case m_csWhatCopied
    Case csCopyedItems
      m_Grid.GetSelected grData, m_vCopy()
    Case csCopyedBranchs
      TreeGetSelected m_vCopy
  End Select
  m_BranchIdCopyed = m_CurrBranch
End Sub

Private Sub EndCopy(ByVal csToDo As csToDo, Optional ByVal BranchId As Long)
  On Error Resume Next
  
  Dim MouseWait As New cMouseWait
  MouseWait.Wait
  
  If csToDo = csDiscard Then
    m_Copying = False
    ReDim m_vCopy(0)
    Exit Sub
  End If
  
  Select Case m_csWhatCopied
    Case csCopyedItems
      PasteItems
    Case csCopyedBranchs
      PasteBranch
  End Select
  
  ' Si corto, una vez que pego listo
  If m_Cut Then
    m_Copying = False
    m_Cut = False
    ReDim m_vCopy(0)
  End If
  
  ' En cambio si Copied, le dejo seguir pegando
End Sub

Private Sub PasteBranch()
  On Error Resume Next
  
  Dim IdOfCopy As Long
  Dim IsCut As Boolean
  
  Dim cLock As cLockUpdateWindow
  Set cLock = New cLockUpdateWindow
  cLock.LockW twTree.hwnd
  
  If twTree.SelectedItem Is Nothing Then Exit Sub
  
  If m_Copied Then
    IsCut = False
  ElseIf m_Cut Then
    IsCut = True
    
    If m_Trees(m_CurrTree).Branchs.IsChildOf(GetIdFromKey(twTree.SelectedItem.Key), m_vCopy(0)) Then
      MsgWarning LNGGetText(3227, vbNullString)
                 'No se puede mover a esta carpeta.; _
                  El destino es una subcarpeta del origen.
      Exit Sub
    End If
  End If
  
  If Not m_Trees(m_CurrTree).Branchs.Paste(m_vCopy(0), GetIdFromKey(twTree.SelectedItem.Key), m_CopiedCutOnlyChilds, IsCut) Then Exit Sub
  
  If Not m_Trees(m_CurrTree).Branchs.LoadBranch(GetIdFromKey(twTree.SelectedItem.Key), IdOfCopy) Then Exit Sub
  
  ' si corto tengo que borrar la rama
  If IsCut Then
    Dim Nodo As Node
    On Error Resume Next
    Err = 0
    Set Nodo = twTree.Nodes(GetKey(m_vCopy(0)))
    
    ' si error es distinto de cero, entonces se cambio de arbol.
    If Err = 0 Then
      DelFolder Nodo
      
    ' si cambio de arbol y corto la raiz tengo que borrar el arbol
    Else
      If m_Trees(m_TreeCut).Branchs(m_vCopy(0)).Father = csNO_ID Then
         
        If m_Trees.Delete(m_TreeCut) Then
          cbTrees.RemoveItem ListGetIndexFromItemData(cbTrees, m_TreeCut)
        End If
      
      ' Tengo que borrar la carpeta de la coleccion
      Else
        m_Trees(m_TreeCut).Branchs.Remove m_vCopy(0)
      End If
    End If
  End If
  
  LoadBranchsFromCopy IdOfCopy
End Sub

Public Function AddLeave(ByVal Id As Long, ByVal BranchId As Long, ByVal TreeId As Long) As Boolean
  On Error GoTo ControlError
  
  If BranchId = 0 Then Exit Function
  
  With m_Trees(m_CurrTree).Branchs(BranchId).Leaves
  
    If Not .rsLeaves Is Nothing Then
      If Not (.rsLeaves.BOF And .rsLeaves.EOF) Then
        .rsLeaves.MoveFirst
        
        While Not .rsLeaves.EOF
        
          If ValField(.rsLeaves.Fields, "ID") = Id Then
            AddLeave = True
            Exit Function
          End If
          .rsLeaves.MoveNext
        Wend
      End If
    End If
  End With
  
  ' Primero termino con la operacion anterior
  EndCopy csDiscard
  
  m_BranchIdCopyed = BranchId
  
  m_csWhatCopied = csCopyedItems
  ReDim m_vCopy(0)
  
  ' Los ids nuevos se multiplican por menos uno
  m_vCopy(0) = Id * -1
  
  m_Copied = True
  m_Cut = False
  m_Copying = True
  
  AddLeave = PasteItems(BranchId, TreeId)
  
  ' Por cada arbol tengo que indicar que la raiz debe ser recargada
  Dim o As cTree
  
  For Each o In m_Trees
    If o.Id <> TreeId Then
      If Not o.Branchs.Root Is Nothing Then
        o.Branchs.Root.Leaves.IsLoaded = False
      End If
    End If
  Next
  
  Exit Function
ControlError:
  
  ' 91 or 3704 = Object variable or With block variable not set
  If Err.Number = 3704 Then Exit Function
  If Err.Number = 91 Then Exit Function
  
  MngError Err, "AddLeave", "cTreeCtrl", vbNullString
End Function

' La funcion AddLeave es la unica que llama a PasteItems pasandole los parametros. Cuando los parametros tienen Valuees, se
' pega en la carpeta indicada por ellos, de lo contrario se pega en la carpeta activa.
Private Function PasteItems(Optional ByVal BranchId As Long = csNO_ID, Optional ByVal TreeId As Long = csNO_ID) As Boolean
  Dim BranchIdToPaste As Long
  
  
  If BranchId = csNO_ID Then
  
    If twTree.SelectedItem Is Nothing Then
      MsgWarning LNGGetText(3228, vbNullString), "Paste"
                  'Seleccione una carpeta
      Exit Function
    End If
    
    BranchIdToPaste = GetIdFromKey(twTree.SelectedItem.Key)
  Else
    BranchIdToPaste = BranchId
  End If
  
  If m_Copied Then
  
    ' El unico caso en que TreeId es <> de csNO_ID es cuando copie hojas por medio de la funcion AddLeave
    ' por esto solo se utiliza en esta parte del If (en Paste no se le da bola)
    If TreeId = csNO_ID Then TreeId = m_CurrTree
  
    If Not m_Trees(TreeId).Branchs(BranchIdToPaste).Leaves.Paste(m_vCopy(), BranchIdToPaste, False) Then Exit Function
  End If
  
  If m_Cut Then
    
    ' Para recargar la rama mas abajo
    TreeId = m_CurrTree
    
    If Not m_Trees(m_CurrTree).Branchs(BranchIdToPaste).Leaves.Paste(m_vCopy(), BranchIdToPaste, True) Then Exit Function
    
    ' si corte, tengo que sacar de la rama origen
    ' solo si no se trata de la misma Branch, sino se hace mas abajo
    If m_BranchIdCopyed <> BranchIdToPaste Then
      m_Trees(m_CurrTree).Branchs(m_BranchIdCopyed).Leaves.IsLoaded = False
      'If Not LoadLeaves(m_Trees(m_CurrTree).Branchs(m_BranchIdCopyed).Leaves, m_BranchIdCopyed) Then Exit Function
      If Not LoadLeavesRs(m_Trees(m_CurrTree).Branchs(m_BranchIdCopyed).Leaves, m_BranchIdCopyed) Then Exit Function
    End If
    
    ' si aun estoy en la rama origen vuelvo a Load la Grid
    ' solo si no se trata de la misma Branch, sino se hace mas abajo
    If m_BranchIdCopyed = m_CurrBranch And m_BranchIdCopyed <> BranchIdToPaste Then
      m_CurrBranch = 0
      LoadGridRs grData, m_Trees(m_CurrTree).Branchs(m_BranchIdCopyed)
      m_CurrBranch = m_BranchIdCopyed
    End If
  End If
  
  ' ya sea que copie o corte, tengo que recargar la rama destino
  m_Trees(TreeId).Branchs(BranchIdToPaste).Leaves.IsLoaded = False

  If Not LoadLeavesRs(m_Trees(TreeId).Branchs(BranchIdToPaste).Leaves, BranchIdToPaste) Then Exit Function
  
  ' si la rama origen es la misma que el destino vuelvo a Load la Grid
  If m_CurrBranch = BranchIdToPaste Then
    m_CurrBranch = 0
    LoadGridRs grData, m_Trees(TreeId).Branchs(BranchIdToPaste)
    m_CurrBranch = BranchIdToPaste
  End If
End Function

'--------------------------------------------------------------------------------
Private Sub TreeGetSelected(ByRef v() As Long)
  ReDim v(0)
  If twTree.SelectedItem Is Nothing Then Exit Sub
  v(0) = GetIdFromKey(twTree.SelectedItem.Key)
End Sub

Private Function NewTree() As Boolean
  Dim Name As String
  
  If Not GetInput(Name, LNGGetText(3229, vbNullString)) Then Exit Function
                        'Ingrese el nombre del árbol ...
  If ValEmpty(Name, csText) Then Exit Function
  
  Dim TreeId As Long
  
  If Not m_Trees.Add2(Name, m_TableId, TreeId) Then Exit Function
  
  ListAdd cbTrees, Name, TreeId
  
  ListSetListIndexForId cbTrees, TreeId
  
  NewTree = True
End Function

Private Function NewFolder() As Boolean
  
  If twTree.SelectedItem Is Nothing Then Exit Function
  
  Dim Name As String
  
  If Not GetInput(Name, LNGGetText(3230, vbNullString)) Then Exit Function
                        'Ingrese el nombre de la rama ...
  If ValEmpty(Name, csText) Then Exit Function
  
  Dim BranchId As Long
  
  If Not m_Trees(ListID(cbTrees)).Branchs.Add2(Name, ListID(cbTrees), GetIdFromKey(twTree.SelectedItem.Key), BranchId) Then Exit Function
  
  AddBranch Name, GetIdFromKey(twTree.SelectedItem.Key), BranchId, 1, 2
  
  Dim Nodo As Node
  
  Set Nodo = twTree.Nodes(GetKey(BranchId))
  
  Nodo.Selected = True
  
  LoadBranch BranchId
  
  NewFolder = True
  
End Function

Private Sub SortTree()
  Dim MouseWait As New cMouseWait
  MouseWait.Wait
  
  Dim IdOfCopy As Long
  Dim cLock As cLockUpdateWindow
  Set cLock = New cLockUpdateWindow
  cLock.LockW twTree.hwnd
  
  With m_Trees(GetKey(m_CurrTree))
  
    .SortTree
  
    .Branchs.ReLoadBranch .Branchs.Root.Id, IdOfCopy
  
  End With
  
  Dim Nodo As Node
  
  Set Nodo = twTree.Nodes.Item(1).Root
  
  While Nodo.Children > 0
    DelFolder Nodo.Child
  Wend
   
  LoadBranchsFromCopy IdOfCopy

End Sub

'------------------------------------------------------------
Private Sub popNewTree_Click()
  On Error Resume Next
  NewTree
End Sub

Private Sub popNewFolder_Click()
  On Error Resume Next
  NewFolder
End Sub

Private Sub popRenameFolder_Click()
  On Error Resume Next
  twTree.StartLabelEdit
End Sub

Private Sub popDeleteFolder_Click()
  On Error Resume Next
  DeleteFolder twTree.SelectedItem
End Sub

Private Sub popCopyFolder_Click()
  On Error Resume Next
  
  ' Primero termino con la operacion anterior
  EndCopy csDiscard
  
  m_csWhatCopied = csCopyedBranchs
  
  BeginCopy
  
  m_CopiedCutOnlyChilds = False
  m_Copied = True
  m_Cut = False
  m_Copying = True
End Sub

Private Sub popCutFolder_Click()
  On Error Resume Next
  
  ' Primero termino con la operacion anterior
  EndCopy csDiscard
  
  m_csWhatCopied = csCopyedBranchs
  
  BeginCopy
  
  m_CopiedCutOnlyChilds = False
  m_Copied = False
  m_Cut = True
  m_Copying = True
  m_TreeCut = ListID(cbTrees)
End Sub

Private Sub popCopyOnlyChilds_Click()
  On Error Resume Next
  
  ' Primero termino con la operacion anterior
  EndCopy csDiscard
  
  m_csWhatCopied = csCopyedBranchs
  
  BeginCopy
  
  m_CopiedCutOnlyChilds = True
  m_Copied = True
  m_Cut = False
  m_Copying = True
End Sub

Private Sub popCutOnlyChilds_Click()
  On Error Resume Next
  
  ' Primero termino con la operacion anterior
  EndCopy csDiscard
  
  m_csWhatCopied = csCopyedBranchs
  
  BeginCopy
  
  m_CopiedCutOnlyChilds = True
  m_Copied = False
  m_Cut = True
  m_Copying = True
End Sub

Private Sub popCopyItem_Click()
  On Error Resume Next
  
  ' Primero termino con la operacion anterior
  EndCopy csDiscard
  
  m_csWhatCopied = csCopyedItems
  BeginCopy
  
  m_Copied = True
  m_Cut = False
  m_Copying = True
End Sub

Private Sub popCutItem_Click()
  On Error Resume Next
  
  ' Primero termino con la operacion anterior
  EndCopy csDiscard
  
  BeginCopy
  
  m_Copied = False
  m_Cut = True
  m_csWhatCopied = csCopyedItems
  m_Copying = True
End Sub

Private Sub popPasteInFolder_Click()
  On Error Resume Next
  EndCopy csPaste
End Sub

Private Sub popPasteInFolder2_Click()
  On Error Resume Next
  EndCopy csPaste
End Sub

Private Sub popDown_Click()
  On Error Resume Next
  DownFolder
End Sub

Private Sub popSort_Click()
  On Error Resume Next
  SortTree
End Sub

Private Sub popUp_Click()
  On Error Resume Next
  UpFolder
End Sub

Private Sub DeleteFolder(ByRef Nodo As Node)
  
  If Nodo Is Nothing Then Exit Sub
  
  ' si borra la Root borra el Tree
  If Val(GetInfoString(Nodo.Tag, KEY_FATHER)) = csNO_ID Then
    If m_Trees.Delete(ListID(cbTrees)) Then
      cbTrees.RemoveItem cbTrees.ListIndex
      twTree.Nodes.Clear
      
      ' Aunque el click de cbTrees ya lo hace, cuando no ya no hay
      ' Trees no se ejecuta el evento
      m_Grid.Clear grData
      
      ListSetListIndex cbTrees
      DoEvents
    End If
  
  ' Tengo que borrar la carpeta de la coleccion
  Else
    
    If Not m_Trees(ListID(cbTrees)).Branchs.Delete(GetIdFromKey(Nodo.Key)) Then Exit Sub
  
    ' Tengo que borrar el nodo
    If Not (Nodo Is Nothing) Then DelFolder Nodo
    
    ' vuelvo a Load la Root pues pueden quedar Leaves sin asignar
    With m_Trees(ListID(cbTrees)).Branchs
      .Root.Leaves.IsLoaded = False
      .Root.Leaves.Load .Root.Id
      If Nodo Is Nothing Then
        twTree.Nodes(GetKey(.Root.Id)).Selected = True
        LoadGridRs grData, .Root
      Else
        If GetIdFromKey(Nodo.Key) = .Root.Id Then
          LoadGridRs grData, .Root
        End If
      End If
    End With
  End If
End Sub

Private Sub UpFolder()
  Dim MouseWait As New cMouseWait
  MouseWait.Wait
  
  Dim IdOfCopy As Long
  Dim cLock As cLockUpdateWindow
  Set cLock = New cLockUpdateWindow
  cLock.LockW twTree.hwnd
    
  With m_Trees(GetKey(m_CurrTree))
    
    If .Branchs(GetKey(m_CurrBranch)).Id = .Branchs.Root.Id Then Exit Sub
    
    .Branchs(GetKey(m_CurrBranch)).UpBranch
  
    .Branchs.ReLoadBranch GetInfoString(twTree.SelectedItem.Tag, KEY_FATHER), IdOfCopy
  
  End With
  
  Dim Nodo As Node
  
  Set Nodo = twTree.SelectedItem.Parent
  
  While Nodo.Children > 0
    DelFolder Nodo.Child
  Wend
   
  LoadBranchsFromCopy IdOfCopy
End Sub

Private Sub DownFolder()
  Dim MouseWait As New cMouseWait
  MouseWait.Wait
  
  Dim IdOfCopy As Long
  Dim cLock As cLockUpdateWindow
  Set cLock = New cLockUpdateWindow
  cLock.LockW twTree.hwnd
    
  With m_Trees(GetKey(m_CurrTree))
    
    If .Branchs(GetKey(m_CurrBranch)).Id = .Branchs.Root.Id Then Exit Sub
    
    .Branchs(GetKey(m_CurrBranch)).DownBranch
  
    .Branchs.ReLoadBranch GetInfoString(twTree.SelectedItem.Tag, KEY_FATHER), IdOfCopy
  
  End With
  
  Dim Nodo As Node
  
  Set Nodo = twTree.SelectedItem.Parent
  
  While Nodo.Children > 0
    DelFolder Nodo.Child
  Wend
  
  LoadBranchsFromCopy IdOfCopy
End Sub


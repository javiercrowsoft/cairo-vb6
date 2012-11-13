VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Object = "{532123E7-BCE7-43D6-94ED-AEA94949D5E6}#1.0#0"; "CSComboBox.ocx"
Begin VB.UserControl cTreeCtrl 
   BackColor       =   &H00C00000&
   ClientHeight    =   4770
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   5445
   ScaleHeight     =   4770
   ScaleWidth      =   5445
   ToolboxBitmap   =   "cTreeCtrl.ctx":0000
   Begin CSComboBox.cComboBox cbTrees 
      Height          =   315
      Left            =   80
      TabIndex        =   4
      Top             =   855
      Width           =   1590
      _ExtentX        =   2805
      _ExtentY        =   556
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ListIndex       =   -1
      Text            =   ""
   End
   Begin MSComctlLib.ImageList ImgTree 
      Left            =   4005
      Top             =   2925
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483643
      ImageWidth      =   16
      ImageHeight     =   16
      MaskColor       =   12632256
      _Version        =   393216
      BeginProperty Images {2C247F25-8591-11D1-B16A-00C0F0283628} 
         NumListImages   =   11
         BeginProperty ListImage1 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "cTreeCtrl.ctx":0312
            Key             =   ""
         EndProperty
         BeginProperty ListImage2 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "cTreeCtrl.ctx":06AC
            Key             =   ""
         EndProperty
         BeginProperty ListImage3 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "cTreeCtrl.ctx":0A46
            Key             =   ""
         EndProperty
         BeginProperty ListImage4 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "cTreeCtrl.ctx":0FE0
            Key             =   ""
         EndProperty
         BeginProperty ListImage5 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "cTreeCtrl.ctx":157A
            Key             =   ""
         EndProperty
         BeginProperty ListImage6 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "cTreeCtrl.ctx":16D4
            Key             =   ""
         EndProperty
         BeginProperty ListImage7 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "cTreeCtrl.ctx":1C6E
            Key             =   ""
         EndProperty
         BeginProperty ListImage8 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "cTreeCtrl.ctx":1F88
            Key             =   ""
         EndProperty
         BeginProperty ListImage9 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "cTreeCtrl.ctx":2522
            Key             =   ""
         EndProperty
         BeginProperty ListImage10 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "cTreeCtrl.ctx":2ABC
            Key             =   ""
         EndProperty
         BeginProperty ListImage11 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "cTreeCtrl.ctx":2E56
            Key             =   ""
         EndProperty
      EndProperty
   End
   Begin MSComctlLib.ListView grItems 
      Height          =   1455
      Left            =   2400
      TabIndex        =   3
      Top             =   1275
      Width           =   1995
      _ExtentX        =   3519
      _ExtentY        =   2566
      LabelWrap       =   -1  'True
      HideSelection   =   -1  'True
      _Version        =   393217
      ForeColor       =   -2147483640
      BackColor       =   -2147483643
      Appearance      =   0
      NumItems        =   0
   End
   Begin VB.PictureBox PicSplitter 
      BorderStyle     =   0  'None
      Height          =   4290
      Left            =   1980
      MousePointer    =   9  'Size W E
      ScaleHeight     =   4290
      ScaleWidth      =   45
      TabIndex        =   2
      Top             =   45
      Width           =   50
   End
   Begin VB.PictureBox PicSplitterBar 
      BackColor       =   &H8000000D&
      BorderStyle     =   0  'None
      Height          =   4290
      Left            =   4680
      ScaleHeight     =   4290
      ScaleWidth      =   105
      TabIndex        =   1
      Top             =   0
      Width           =   105
   End
   Begin MSComctlLib.TreeView twTree 
      Height          =   3255
      Left            =   110
      TabIndex        =   0
      Top             =   1235
      Width           =   1455
      _ExtentX        =   2566
      _ExtentY        =   5741
      _Version        =   393217
      Indentation     =   353
      LineStyle       =   1
      Style           =   7
      Appearance      =   0
   End
   Begin VB.Shape shTree 
      BorderColor     =   &H80000010&
      Height          =   3345
      Left            =   90
      Top             =   1215
      Width           =   1575
   End
   Begin VB.Shape shGrid 
      BorderColor     =   &H80000010&
      Height          =   1545
      Left            =   2385
      Top             =   1260
      Width           =   2790
   End
   Begin VB.Image ImgDragListVarios 
      Height          =   480
      Left            =   4140
      Picture         =   "cTreeCtrl.ctx":31F0
      Top             =   3735
      Width           =   480
   End
   Begin VB.Image ImgDragList 
      Height          =   480
      Left            =   3330
      Picture         =   "cTreeCtrl.ctx":34FA
      Top             =   3600
      Width           =   480
   End
   Begin VB.Image ImgDrag 
      Height          =   480
      Left            =   2520
      Picture         =   "cTreeCtrl.ctx":3804
      Top             =   3690
      Width           =   480
   End
   Begin VB.Menu popTree 
      Caption         =   "popArbol"
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
      Begin VB.Menu popViewColapse 
         Caption         =   "Presentar la rama colapsada"
         Checked         =   -1  'True
      End
   End
End
Attribute VB_Name = "cTreeCtrl"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
'--------------------------------------------------------------------------------
' cTreeCtrl
' 26-03-00

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
  ' constantes
  ' estructuras
  ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cTreeCtrl"


Const sglSplitLimit = 500
Const KEY_FATHER = "FATHER"
Const KEY_BRANCH_KEY = "BRANCHC"
Private Const TREE_CLIENT_ID = "LEAVE_ID"   ' Es el id del Client no de la Leave

' Ojo estas constantes no pueden cambiar por que se usan en la logica
' de fTreeViewEdit en cairo
'
Const IMG_FOLDER_OPEN = 2
Const IMG_FOLDER_CLOSE = 1
Const IMG_Active_TRUE = 3
Const IMG_Active_FALSE = 4
Const IMG_FOLDER_COLLAPSED_OPEN = 11
Const IMG_FOLDER_COLLAPSED_CLOSE = 10

Private Enum csTvImage
  c_img_down = 8
  c_img_up
End Enum

Const MIN_TIME_DRAG_DROP = 0.2

Public Enum IconList
  csIMG_PERSON = 5
  csIMG_REDCUBE = 6
  csIMG_ROLS = 7
End Enum

Const MOUSE_UP = 1
Const MOUSE_NODE = 2
' estructuras
' enums
Private Enum csWhatCopied
  csCopyedItems
  csCopyedBranchs
End Enum
Private Enum csToDo
  csDiscard
  csPaste
End Enum

Private Const csDragCut = 1
Private Const csDragCopy = 2

' variables privadas
Private m_Name        As String
Private m_Moving      As Boolean
Private m_Trees       As CSOAPI2.cTrees
Private m_CurrTree    As Long
Private m_CurrBranch  As Long
Private m_Buttons1    As Long
Private m_Buttons2    As Long
Private m_Buttons3    As Long
Private m_Grid        As CSOAPI2.cListView
Private m_OldKey      As String
Private m_TableId     As Long
Private m_Selected    As cSelectedItems


'----------------------------------------------------
' Para manejar los checkbox en el Tree y en la List
Private m_Checked         As cCheckedItems     ' List de trabajo
Private m_ObjChkList      As cICheckedList     ' List de checkeados
Private m_BranchsChecked  As Collection
'----------------------------------------------------

Private m_ToolBarVisible As Boolean

Private m_CollIdEdited  As Collection     ' Contiene una coleccion con todos los ids editados, cuando una Branch se carga, y contiene
                      ' este id, si ya estaba carga se vuelve a leer de la base de datos para refrescar.

Private m_BeginClick As Single        ' Timer al momento del click

Private m_WasButtonRigth  As Boolean    ' Flag que indica que se presiono el Button derecho del
                      ' mouse se prende en MouseDown y se apaga en MosueUp
                      ' del control twTree

Private m_PopUpMenuShowed As Boolean    ' Flag que indica que no hay que mostrar el popup menu
                      ' en el evento MouseUp del twTree, por que ya se mostro
                      ' en el evento NodeClick del mismo control

Private m_vCopy()   As Long ' Contiene los Ids copiados y cortados
Private m_vDrag()   As Long ' Contiene los Ids dragueados

Private m_csWhatCopied  As csWhatCopied
Private m_Copying     As Boolean ' Indica si hay algo que Paste
Private m_Copied    As Boolean ' Indican la operacion de copia realizada
Private m_Cut       As Boolean
Private m_TreeCut     As Long   ' guarda el id del Tree desde el que se corto
Private m_CopiedCutOnlyChilds   As Boolean  ' Solo para Folders: indica si se copian o cortan solo las Folders
                      ' que dependen de esta rama
Private m_BranchIdCopyed As Long

Private m_LasKeyPress As Single       ' Busca por teclado
Private m_FindString  As String       ' Texto a buscar

Private m_IconText    As Integer

' Drag operation
Private m_InDrag    As Boolean
Private m_NodeToDrag  As MSComctlLib.Node
Private m_DragFolder  As Boolean
Private m_DragOperation As Integer

Private m_ListLeftButton   As Boolean

Private m_TimerDrag   As Single   ' lo uso para saber si esta dragueando (o como carajo se diga)

Private m_NoLoadItemsSelected As Boolean

Private m_SpGetHojas      As String
Private m_SpGetArboles    As String


Private m_CollapseBug     As Single ' El treeview tiene un bug cuando se colapsa
                                    ' envia por error un evento check, con este flag
                                    ' corregimos el bug

Private m_InViewMode      As Boolean
Private m_CollapseChanged As Boolean

' eventos
Public Event ToolBarClick(ByVal Button As Object)
Public Event ToolBarClickEx(ByVal ToolBar As Object, ByVal lButton As Long)
Public Event DblClick()
Public Event MenuClick(ByVal MenuId As Long)

' propiedades publicas
Public Property Get CollapseChanged() As Boolean
  CollapseChanged = m_CollapseChanged
End Property

Public Property Let CollapseChanged(ByVal rhs As Boolean)
  m_CollapseChanged = rhs
End Property

Public Property Let InViewMode(ByVal rhs As Boolean)
  m_InViewMode = rhs
End Property

Public Property Get TreeCtrl() As Object
  Set TreeCtrl = twTree
End Property

Public Property Let SpGetHojas(ByVal rhs As String)
  m_SpGetHojas = rhs
End Property

Public Property Let SpGetArboles(ByVal rhs As String)
  m_SpGetArboles = rhs
End Property

Public Property Get Id() As Long
  Id = m_Grid.Id(grItems)
End Property

Public Property Get SelectedItems() As Long()
  Dim rtn() As Long
  
  If Not m_Grid.Ids(grItems, rtn) Then
    ReDim rtn(0)
  End If
  
  SelectedItems = rtn
End Property

Public Property Get BranchId() As Long
  BranchId = m_CurrBranch
End Property

Public Property Get TreeId() As Long
  TreeId = m_CurrTree
End Property

Public Property Get NameClient() As String
Attribute NameClient.VB_Description = "Esta propiedad se usa para identificar el uso del control. Las funciones SavePreference y GetPreference graban y leen desde el registry el estado del control al momento del cierre del form bajo varias claves que usan este nombre como parte de la identifi"
  NameClient = m_Name
End Property

Public Property Let NameClient(ByVal rhs As String)
  m_Name = rhs
End Property

Public Property Get Buttons1() As Long
Attribute Buttons1.VB_Description = "Es una mascara de bits donde cada bit indica un boton. En CSOAPI estan declaradas las constantes para cada boton. Permite hasta 32 botones."
  Buttons1 = m_Buttons1
End Property

Public Property Let Buttons1(ByVal rhs As Long)
  m_Buttons1 = rhs
End Property

Public Property Get Buttons2() As Long
Attribute Buttons2.VB_Description = "Es una mascara de bits donde cada bit indica un boton. En CSOAPI estan declaradas las constantes para cada boton. Permite hasta 32 botones."
  Buttons2 = m_Buttons2
End Property

Public Property Let Buttons2(ByVal rhs As Long)
  m_Buttons2 = rhs
End Property

Public Property Get Buttons3() As Long
Attribute Buttons3.VB_Description = "Es una mascara de bits donde cada bit indica un boton. En CSOAPI estan declaradas las constantes para cada boton. Permite hasta 32 botones."
  Buttons3 = m_Buttons3
End Property

Public Property Get CheckedItems() As cCheckedItems
Attribute CheckedItems.VB_Description = "Coleccion de CheckedItem. Son todos los items Checked cuando el control tiene a True la propiedad ArbolCheckBox."
  Set CheckedItems = m_Checked
End Property

Public Property Get BranchsChecked() As Collection
  Set BranchsChecked = m_BranchsChecked
End Property

Public Property Set ListChecked(ByRef rhs As cICheckedList)
  Set m_ObjChkList = rhs
End Property

Public Property Let Buttons3(ByVal rhs As Long)
  m_Buttons3 = rhs
End Property

Public Property Let IconText(ByVal rhs As IconList)
Attribute IconText.VB_Description = "Es un valor entero que sale del enum IconList que esta declarado en la misma clase. Se utiliza para ponerle un icono a todas las filas de la grilla"
  m_IconText = rhs
  m_Grid.IMG_Item = m_IconText
End Property

Public Property Get IconText() As IconList
  IconText = m_IconText
End Property

Public Property Get ToolBarVisible() As Boolean
Attribute ToolBarVisible.VB_Description = "Define si se ve la barra de herramientas."
  ToolBarVisible = False
End Property

Public Property Let ToolBarVisible(ByVal rhs As Boolean)
  m_ToolBarVisible = False
End Property

Public Property Get ListCheckBox() As Boolean
  ListCheckBox = grItems.Checkboxes
End Property

Public Property Let ListCheckBox(ByVal rhs As Boolean)
  grItems.Checkboxes = rhs
End Property

Public Property Get TreeCheckBox() As Boolean
Attribute TreeCheckBox.VB_Description = "Indica si las carpertas del arbol tienen la opcion de Check"
  TreeCheckBox = twTree.Checkboxes
End Property

Public Property Let TreeCheckBox(ByVal rhs As Boolean)
  twTree.Checkboxes = rhs
End Property

' propiedades privadas
' funciones publicas
Public Sub SetTree(ByVal TreeId As Long)
  
  ListSetListIndexForId cbTrees, TreeId
  
  If m_CurrTree = ListID(cbTrees) Then Exit Sub
  m_CurrTree = ListID(cbTrees)
  
  LoadBranchs m_CurrTree
  
  m_Grid.Clear grItems
End Sub

Public Sub HideTreeComobo()
  cbTrees.Enabled = False
  cbTrees.Visible = False
End Sub

Public Sub showCollpased()
  On Error Resume Next
  If twTree.SelectedItem Is Nothing Then Exit Sub
  twTree.SelectedItem.Image = IMG_FOLDER_COLLAPSED_CLOSE
  twTree.SelectedItem.SelectedImage = IMG_FOLDER_COLLAPSED_OPEN
End Sub

Public Sub showExpanded()
  On Error Resume Next
  If twTree.SelectedItem Is Nothing Then Exit Sub
  twTree.SelectedItem.Image = IMG_FOLDER_CLOSE
  twTree.SelectedItem.SelectedImage = IMG_FOLDER_OPEN
End Sub

Public Function AddMenu(ByVal MenuName As String, ByVal MenuId As Long) As Boolean
  On Error GoTo ControlError
  
  VB.Load mnuEditEx.item(mnuEditEx.UBound + 1)
  With mnuEditEx.item(mnuEditEx.UBound)
    .Caption = MenuName
    .Tag = MenuId
    .Visible = True
  End With

  mnuEditEx.item(0).Visible = False

  AddMenu = True
  
  Exit Function
ControlError:
  MngError Err, "AddMenu", "cTreeCtrl", vbNullString
End Function

Public Function ClearMenu()
  On Error Resume Next
  Dim i As Integer
  mnuEditEx.item(0).Visible = True
  For i = 1 To mnuEditEx.UBound
    Unload mnuEditEx.item(1)
  Next
End Function

Public Function Load(ByVal Id As Long) As Boolean
  
  Dim MouseWait As New cMouseWait
  MouseWait.Wait
  
  Dim Tree As CSOAPI2.cTree
  
  If LenB(m_SpGetArboles) Then m_Trees.SpGetArboles = m_SpGetArboles
  
  If Not m_Trees.Load(Id) Then Exit Function
  
  For Each Tree In m_Trees
    AddTree Tree.Name, Tree.Id
  Next
  
  GetPreference
  
  m_TableId = Id
  
  Load = True
End Function

Public Function LoadBranchs(ByVal Id As Long) As Boolean
  
  Dim MouseWait As New cMouseWait
  MouseWait.Wait
  
  Dim Branch As cBranch
  
  m_CurrBranch = 0
  
  m_Trees(Id).Load
  
  Dim Lockw As cLockUpdateWindow
  Set Lockw = New cLockUpdateWindow
  
  Lockw.Lockw twTree.hWnd
  
  twTree.Nodes.Clear
  
  For Each Branch In m_Trees(Id).Branchs
    AddBranch Branch.Name, Branch.Father, Branch.Id, 1, 2
  Next
  
  'Order
  LoadBranchs = True
End Function

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

Public Function AddEditedId(ByVal Id As Long) As Boolean
  m_CollIdEdited.Add Id
End Function

' Refresca una rama usada despues de la edicion
Public Function RefreshActiveBranch() As Boolean
  On Error GoTo ControlError
  
  If m_CurrBranch = 0 Then Exit Function
  
  If m_Trees(m_CurrTree) Is Nothing Then Exit Function
  If m_Trees(m_CurrTree).Branchs(m_CurrBranch) Is Nothing Then Exit Function
  
  Dim SelectedId As Long
  
  SelectedId = Id
  
  RefreshActiveBranch = LoadLeavesRs(m_Trees(m_CurrTree).Branchs(m_CurrBranch).Leaves, m_CurrBranch, True)
  
  Dim OldBranch As Long
  
  OldBranch = m_CurrBranch
  m_CurrBranch = 0

  LoadGridRs grItems, m_Trees(m_CurrTree).Branchs(OldBranch)
  m_CurrBranch = OldBranch
  
  Search SelectedId
  
  Exit Function
ControlError:
  MngError Err, "RefreshActiveBranch", "cTreeCtrl", vbNullString
End Function

Public Function LoadLeaves(ByRef Leaves As cLeaves, ByVal BranchId As Long, Optional ByVal Refresh As Boolean = False) As Boolean
  
  Dim MouseWait As New cMouseWait
  MouseWait.Wait
  
  Dim LeavesLoaded As Boolean
  ' Puede pasar que BranchId se lea del registry (ultima Branch seleccionada para este form en esta maquina),
  ' y ya no exista en la base de datos, con lo que se genera un error
  On Error GoTo ControlError
  If Refresh Then Leaves.IsLoaded = False
  LeavesLoaded = Leaves.IsLoaded
  LoadLeaves = Leaves.Load(BranchId)
  
  ' Si las Leaves ya estaban cargadas, recorro la coleccion de Items editados
  ' para ver si alguno esta en esta rama, si encuentro al menos uno, cargo Newmente
  ' la rama desde la base de datos.
  ' ESTO ES PESIMO EN PERFORMANCE, PERO MUY SEGURO. VOY A PROBAR QUE TAL ANDA Y LUEGO DECIDO SI SE CAMBIA O NO
  If LeavesLoaded Then
    Dim i As Integer
    Dim o As cLeave
    For Each o In Leaves
      For i = 1 To m_CollIdEdited.Count
        If m_CollIdEdited(i) = o.ClientId Then
          Leaves.IsLoaded = False
          LoadLeaves = Leaves.Load(BranchId)
          Exit For
        End If
      Next i
    Next
  End If
ControlError:
End Function

Public Function LoadLeavesRs(ByRef Leaves As cLeaves, ByVal BranchId As Long, Optional ByVal Refresh As Boolean = False) As Boolean
  Dim MouseWait As New cMouseWait
  MouseWait.Wait
  
  Dim LeavesLoaded As Boolean
  
  ' Puede pasar que BranchId se lea del registry (ultima rama seleccionada para este form en esta maquina),
  ' y ya no exista en la base de datos, con lo que se genera un error
  On Error GoTo ControlError
  
  If Refresh Then Leaves.IsLoaded = False
  
  If LenB(m_SpGetHojas) Then Leaves.SpGetHojas = m_SpGetHojas
  
  LeavesLoaded = Leaves.IsLoaded
  LoadLeavesRs = Leaves.LoadRs(BranchId)
  
  ' Si las ramas ya estaban cargadas, recorro la coleccion de Items editados
  ' para ver si alguno esta en esta rama, si encuentro al menos uno, cargo nuevamente
  ' la rama desde la base de datos.
  ' ESTO ES PESIMO EN PERFORMANCE, PERO MUY SEGURO. VOY A PROBAR QUE TAL ANDA
  ' Y LUEGO DECIDO SI SE CAMBIA O NO
  If LeavesLoaded Then
    Dim i As Integer
    Dim o As cLeave
    With Leaves.rsLeaves
      While Not .EOF
        For i = 1 To m_CollIdEdited.Count
          If m_CollIdEdited(i) = ValField(.fields, 1) Then
            Leaves.IsLoaded = False
            LoadLeavesRs = Leaves.LoadRs(BranchId)
            Exit For
          End If
        Next i
        
        .MoveNext
      Wend
    End With
  End If
ControlError:
End Function

Public Function AddBranch(ByVal Text As String, ByVal Father As String, Optional ByVal Key As Variant, Optional Image As Variant, Optional SelectedImage As Variant) As Boolean
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

Public Sub AddTree(ByVal Name As String, ByVal Id As Long)
  Dim i As Integer
  For i = 0 To cbTrees.ListCount - 1
    If cbTrees.ItemData(i) = Id Then Exit Sub
  Next
  ListAdd cbTrees, Name, Id
End Sub

' Remover esta funcion si no se presentan bugs 11/04/01
Public Function Order() As Boolean
  
  Dim MouseWait As New cMouseWait
  MouseWait.Wait
  
  Dim Nodo As Node
  On Error Resume Next
  
  For Each Nodo In twTree.Nodes
  
    If Val(GetInfoString(Nodo.Tag, KEY_FATHER)) <> csNO_ID Then
      Set Nodo.Parent = twTree.Nodes(GetKey(GetInfoString(Nodo.Tag, KEY_FATHER)))
    End If
  Next
End Function

Public Function SetToolBar()
End Function

Public Sub SavePreference(ByVal WinState As Integer)
  
  If WinState = vbMinimized Then Exit Sub

  SetRegistry csInterface, m_Name + "_SPLITTER_LEFT", PicSplitter.Left
  SetRegistry csInterface, m_Name + "_LAST_TREE", m_CurrTree
  SetRegistry csInterface, m_Name + "_LAST_FOLDER", m_CurrBranch
  
  If Not twTree.SelectedItem Is Nothing Then
    m_Grid.SaveColumnWidth grItems, m_Name + "_" + GetInfoString(twTree.SelectedItem.Tag, KEY_BRANCH_KEY)
  End If
End Sub

Public Sub Search(ByVal Id As Long)
  Dim branch_id As Long
  
  If m_CurrTree = 0 Then
    If cbTrees.ListCount = 0 Then Exit Sub
    ListSetListIndex cbTrees, 0
    
    If m_CurrTree = 0 Then Exit Sub
  End If
  
  branch_id = m_Trees(m_CurrTree).Search(Id)
  
  pSelectNode branch_id
  
  LoadBranch branch_id
  
  Dim item As ListItem
  
  For Each item In grItems.ListItems
    If Val(item.SubItems(2)) = Id Then
      item.Selected = True
      item.EnsureVisible
    Else
      item.Selected = False
    End If
  Next
  
  SetFocusControl grItems
End Sub

'------------------------------------------------------------------------------------------------------------------------------------------
' funciones privadas

' eventos
Private Sub cbTrees_Click()
  On Error Resume Next
  
  If m_InViewMode Then Exit Sub
  
  If m_CurrTree = ListID(cbTrees) Then Exit Sub
  m_CurrTree = ListID(cbTrees)
  
  LoadBranchs m_CurrTree
  
  m_Grid.Clear grItems
End Sub

Private Sub grItems_ColumnClick(ByVal ColumnHeader As MSComctlLib.ColumnHeader)
  On Error GoTo ControlError

  Dim i As Integer
  
  For i = 1 To grItems.ColumnHeaders.Count
    grItems.ColumnHeaders(i).Icon = 0
  Next
  
  grItems.SortKey = ColumnHeader.Index - 1
  If grItems.SortOrder = lvwAscending Then
    grItems.SortOrder = lvwDescending
    ColumnHeader.Icon = c_img_down
  Else
    grItems.SortOrder = lvwAscending
    ColumnHeader.Icon = c_img_up
    ColumnHeader.Alignment = lvwColumnLeft
  End If
  grItems.Sorted = True

  GoTo ExitProc
ControlError:
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub grItems_DblClick()
  On Error Resume Next
  RaiseEvent DblClick
End Sub

Private Sub grItems_ItemCheck(ByVal item As MSComctlLib.ListItem)
  On Error Resume Next
  Dim Key   As Long
  Dim p     As cICheckedListItem
  Dim Id    As Long
  
  Key = GetInfoString(item.Tag, TREE_CLIENT_ID)
  
  If item.Checked Then
    m_Checked.Add2 Key, Key
  Else

    Id = Val(Key)
    For Each p In m_ObjChkList
      If Id = p.Id Then
        If Not p.Enabled Then
          item.Checked = True
          Exit Sub
        End If
        Exit For
      End If
    Next
    m_Checked.Remove GetInfoString(item.Tag, TREE_CLIENT_ID)
  End If
End Sub

Private Sub grItems_KeyDown(KeyCode As Integer, Shift As Integer)
  On Error Resume Next
  If KeyCode = vbKeyReturn Then
    grItems_DblClick
  End If
End Sub

Private Sub grItems_KeyPress(KeyAscii As Integer)
  On Error Resume Next
  
  FindText KeyAscii
End Sub

Private Sub grItems_MouseDown(Button As Integer, Shift As Integer, x As Single, Y As Single)
  On Error Resume Next
  
  m_ListLeftButton = Button <> vbRightButton
  If m_ListLeftButton Then
    
    m_InDrag = False
    
    If grItems.HitTest(x, Y) Is Nothing Then Exit Sub
    
    m_TimerDrag = Timer
    
    m_NoLoadItemsSelected = False
    
    ' 2 es control
    If (m_Grid.GetSelectedCount(grItems) > 1) And ((Shift And 2) = 0) Then
      m_NoLoadItemsSelected = True
    End If
    
  End If
End Sub

Private Sub grItems_MouseMove(Button As Integer, Shift As Integer, x As Single, Y As Single)
  On Error Resume Next
  
  If Button = vbLeftButton Then ' Signal a Drag operation.

    If m_InDrag Then Exit Sub

    If Not (Timer - m_TimerDrag > 0.1) Then Exit Sub
    
    If grItems.SelectedItem Is Nothing Then Exit Sub
    
    m_Grid.GetSelected grItems, m_vDrag()
    
    If m_Grid.GetSelectedCount(grItems) = 1 Then
      ' Set the drag icon with the CreateDragImage method.
      grItems.DragIcon = ImgDragList.Picture
    Else
      grItems.DragIcon = ImgDragListVarios.Picture
    End If
    
    m_InDrag = True ' Set the flag to true.
    m_DragFolder = False
    grItems.Drag vbBeginDrag ' Drag operation.
    
    ' si tiene presionado el shift entonces esta cortando
    If Shift And 1 Then
      m_DragOperation = csDragCopy
    Else
      m_DragOperation = csDragCut
    End If
  End If
End Sub

Private Sub grItems_MouseUp(Button As Integer, Shift As Integer, x As Single, Y As Single)
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

Private Sub mnuEditEx_Click(Index As Integer)
  On Error Resume Next
  RaiseEvent MenuClick(Val(mnuEditEx.item(Index).Tag))
End Sub

' Up y Down Folders
Private Sub popDown_Click()
  On Error Resume Next
  DownFolder
End Sub

Private Sub popExportToExcel_Click()
  On Error Resume Next
  ExportToExcel
End Sub

Private Sub popExportToExcel2_Click()
  On Error Resume Next
  ExportToExcel
End Sub

Private Sub popSort_Click()
  On Error Resume Next
  SortTree
End Sub

Private Sub popUp_Click()
  On Error Resume Next
  UpFolder
End Sub

Private Sub twTree_Collapse(ByVal Node As MSComctlLib.Node)
  m_CollapseBug = Timer
  m_CollapseChanged = True
End Sub

Private Sub twTree_Expand(ByVal Node As MSComctlLib.Node)
  m_CollapseChanged = True
End Sub

Private Sub UserControl_Resize()
  On Error Resume Next
  SizeControls
End Sub

Private Sub LoadBranch(ByVal BranchId As Long)
  On Error Resume Next
  
  Dim MouseWait As New cMouseWait
  MouseWait.Wait
  
  If m_CurrBranch = BranchId Then Exit Sub
  m_CurrBranch = BranchId
  
  LoadLeavesRs m_Trees(m_CurrTree).Branchs(m_CurrBranch).Leaves, m_CurrBranch
  LoadGridRs grItems, m_Trees(m_CurrTree).Branchs(m_CurrBranch)
End Sub

' Nombre de la carpeta
Private Sub twTree_KeyDown(KeyCode As Integer, Shift As Integer)
  On Error Resume Next
  If KeyCode = vbKeyF2 Then twTree.StartLabelEdit
End Sub

Private Sub twTree_AfterLabelEdit(Cancel As Integer, NewString As String)
  On Error Resume Next
  Cancel = Not RenameFolder(NewString)
End Sub

' Menu
Private Sub twTree_DragDrop(Source As Control, x As Single, Y As Single)
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

Private Sub twTree_DragOver(Source As Control, x As Single, Y As Single, State As Integer)
  On Error Resume Next
  
  If m_InDrag = True Then
    ' Set DropHighlight to the mouse's coordinates.
    Set twTree.DropHighlight = twTree.HitTest(x, Y)
  End If
End Sub

Private Sub twTree_MouseMove(Button As Integer, Shift As Integer, x As Single, Y As Single)
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

Private Sub twTree_MouseDown(Button As Integer, Shift As Integer, x As Single, Y As Single)
  On Error Resume Next
  
  m_BeginClick = Timer
  m_WasButtonRigth = Button = vbRightButton
  If Not m_WasButtonRigth Then
    ' para que en el click se seleccione la carpeta
    Set twTree.SelectedItem = twTree.HitTest(x, Y)
    Set m_NodeToDrag = twTree.SelectedItem ' Obtengo una referencia al item a ser dragueado
  End If
    
End Sub

Private Sub twTree_MouseUp(Button As Integer, Shift As Integer, x As Single, Y As Single)
  On Error Resume Next
  
  m_BeginClick = 0
  If Not m_PopUpMenuShowed And m_WasButtonRigth Then
    ShowMenu MOUSE_UP
  End If
  m_WasButtonRigth = False
  m_PopUpMenuShowed = False
End Sub

Private Sub ShowMenu(ByVal Quien As Integer)
  On Error Resume Next
  
  If m_InViewMode Then Exit Sub
  
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
    mnuEditEx.item(0).Visible = False
    mnuEdit.Visible = True
    popSep5.Visible = True
  Else
    mnuEdit.Visible = False
    popSep5.Visible = False
  End If
  
  PopupMenu popTree
End Sub

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

Private Sub BeginCopy()
  On Error Resume Next
  
  Select Case m_csWhatCopied
    Case csCopyedItems
      m_Grid.GetSelected grItems, m_vCopy()
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
  cLock.Lockw twTree.hWnd
  
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
        
          If ValField(.rsLeaves.fields, "ID") = Id Then
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
      LoadGridRs grItems, m_Trees(m_CurrTree).Branchs(m_BranchIdCopyed)
      m_CurrBranch = m_BranchIdCopyed
    End If
  End If
  
  ' ya sea que copie o corte, tengo que recargar la rama destino
  m_Trees(TreeId).Branchs(BranchIdToPaste).Leaves.IsLoaded = False

  If Not LoadLeavesRs(m_Trees(TreeId).Branchs(BranchIdToPaste).Leaves, BranchIdToPaste) Then Exit Function
  
  ' si la rama origen es la misma que el destino vuelvo a Load la Grid
  If m_CurrBranch = BranchIdToPaste Then
    m_CurrBranch = 0
    LoadGridRs grItems, m_Trees(TreeId).Branchs(BranchIdToPaste)
    m_CurrBranch = BranchIdToPaste
  End If
End Function

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
      
      LoadGridRs grItems, m_Trees(m_CurrTree).Branchs(BranchIdCopyed)
      m_CurrBranch = BranchIdCopyed
  
  End Select
  
  ' ya sea que copie o corte, tengo que recargar la rama destino
  m_Trees(m_CurrTree).Branchs(BranchIdToPaste).Leaves.IsLoaded = False
  If Not LoadLeavesRs(m_Trees(m_CurrTree).Branchs(BranchIdToPaste).Leaves, BranchIdToPaste) Then Exit Sub
End Sub

Private Sub DragDropFolder(ByVal BranchIdToPaste As Long)
  Dim MouseWait As New cMouseWait
  MouseWait.Wait
  
  Dim IdOfCopy As Long
  Dim IsCut As Boolean
  
  Dim cLock As cLockUpdateWindow
  Set cLock = New cLockUpdateWindow
  cLock.Lockw twTree.hWnd
  
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

Private Sub DeleteFolder(ByRef Nodo As Node)
  
  If Nodo Is Nothing Then Exit Sub
  
  ' si borra la Root borra el Tree
  If Val(GetInfoString(Nodo.Tag, KEY_FATHER)) = csNO_ID Then
    If m_Trees.Delete(ListID(cbTrees)) Then
      cbTrees.RemoveItem cbTrees.ListIndex
      twTree.Nodes.Clear
      
      ' Aunque el click de cbTrees ya lo hace, cuando no ya no hay
      ' Trees no se ejecuta el evento
      m_Grid.Clear grItems
      
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
        LoadGridRs grItems, .Root
      Else
        If GetIdFromKey(Nodo.Key) = .Root.Id Then
          LoadGridRs grItems, .Root
        End If
      End If
    End With
  End If
End Sub

Private Sub DelFolder(ByRef Nodo As Node)
  
  If Nodo Is Nothing Then Exit Sub
  
  twTree.Nodes.Remove Nodo.Index
  m_Grid.Clear grItems
End Sub

Private Function GetSSel(ByRef v() As Long) As String
  Dim i As Integer
  Dim s As String
  For i = 0 To UBound(v())
    s = s & " | " & v(i)
  Next i
  GetSSel = s
End Function

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

Private Sub SortTree()
  Dim MouseWait As New cMouseWait
  MouseWait.Wait
  
  Dim IdOfCopy As Long
  Dim cLock As cLockUpdateWindow
  Set cLock = New cLockUpdateWindow
  cLock.Lockw twTree.hWnd
  
  With m_Trees(GetKey(m_CurrTree))
  
    .SortTree
  
    .Branchs.ReLoadBranch .Branchs.Root.Id, IdOfCopy
  
  End With
  
  Dim Nodo As Node
  
  Set Nodo = twTree.Nodes.item(1).Root
  
  While Nodo.Children > 0
    DelFolder Nodo.Child
  Wend
   
  LoadBranchsFromCopy IdOfCopy

End Sub

Private Sub ExportToExcel()
  On Error GoTo ControlError
  
  If m_Trees(GetKey(m_CurrTree)) Is Nothing Then
    MsgInfo LNGGetText(3231, vbNullString) 'Debe seleccionar una Carpeta
    Exit Sub
  End If
  
  If m_Trees(GetKey(m_CurrTree)).Branchs(GetKey(m_CurrBranch)) Is Nothing Then
    MsgInfo LNGGetText(3231, vbNullString) 'Debe seleccionar una carpeta
    Exit Sub
  End If
  
  Dim Excel As CSKernelClient2.cExporToExcel
  Set Excel = New CSKernelClient2.cExporToExcel
  
  With m_Trees(GetKey(m_CurrTree)).Branchs(GetKey(m_CurrBranch)).Leaves
    .rsLeaves.MoveFirst
    Excel.Export dblExRecordsetAdo, vbNullString, .rsLeaves
  End With
  
  Exit Sub
ControlError:
  MngError Err, "ExportToExcel", "cTreeCtrl", vbNullString
End Sub

Private Sub UpFolder()
  Dim MouseWait As New cMouseWait
  MouseWait.Wait
  
  Dim IdOfCopy As Long
  Dim cLock As cLockUpdateWindow
  Set cLock = New cLockUpdateWindow
  cLock.Lockw twTree.hWnd
    
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
  cLock.Lockw twTree.hWnd
    
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

'------------------------------------------------------------------------------------------------------------------------------------------
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

Private Function LoadGridRs(ByRef Grid As ListView, ByRef Branch As cBranch) As Boolean
  
  Dim MouseWait As New cMouseWait
  MouseWait.Wait
  
  Dim cLock As cLockUpdateWindow
  Set cLock = New cLockUpdateWindow
  cLock.Lockw grItems.hWnd
    
  m_Grid.SaveColumnWidth grItems, m_Name + "_" + m_OldKey

  If Not m_Grid.LoadLeavesFromRs(grItems, Branch.Leaves.rsLeaves) Then Exit Function
  
  ' Ahora seteo el Value check de cada item
  '
  SetChecks
  
  If twTree.SelectedItem Is Nothing Then
    pSelectNode Branch.Id
    If twTree.SelectedItem Is Nothing Then Exit Function
  End If
  
  If GetInfoString(twTree.SelectedItem.Tag, KEY_BRANCH_KEY) = "" Then
    twTree.SelectedItem.Tag = SetInfoString(twTree.SelectedItem.Tag, KEY_BRANCH_KEY, m_Grid.GetKeyFromColumns(Branch))
  End If
  
  m_OldKey = GetInfoString(twTree.SelectedItem.Tag, KEY_BRANCH_KEY)
  m_Grid.GetColumnWidth grItems, m_Name & "_" & m_OldKey, 2
  
  LoadGridRs = True
End Function

Private Sub PicSplitter_MouseDown(Button As Integer, Shift As Integer, x As Single, Y As Single)
  On Error Resume Next
  
  With PicSplitter
    PicSplitterBar.Move .Left, .Top, .Width \ 2, .Height - 20
  End With
  PicSplitterBar.Visible = True
  m_Moving = True
End Sub

Private Sub PicSplitter_MouseMove(Button As Integer, Shift As Integer, x As Single, Y As Single)
  On Error Resume Next
  
  Dim sglPos As Single

  If m_Moving Then
    sglPos = x + PicSplitter.Left
    If sglPos < sglSplitLimit Then
      PicSplitterBar.Left = sglSplitLimit
    ElseIf sglPos > Width - sglSplitLimit Then
      PicSplitterBar.Left = Width - sglSplitLimit
    Else
      PicSplitterBar.Left = sglPos
    End If
  End If
End Sub
Private Sub PicSplitter_MouseUp(Button As Integer, Shift As Integer, x As Single, Y As Single)
  On Error Resume Next
  
  SizeControls
  PicSplitterBar.Visible = False
  m_Moving = False
End Sub

Private Sub SizeControls()
  On Error Resume Next
  
  Dim i As Integer
  Dim WinState  As Integer
  Dim offTop    As Integer
  Dim iHeight   As Integer
  
  On Error GoTo ControlError
  
  DoEvents: DoEvents: DoEvents: DoEvents
  
  If Not GetWindowState(WinState, Parent) Then Exit Sub
  If WinState = vbMinimized Then Exit Sub
  
  If PicSplitterBar.Left > ScaleWidth Then
    PicSplitterBar.Left = ScaleWidth - 50
  End If
  
  offTop = 0
  
  iHeight = ScaleHeight
  
  With PicSplitter
    .Left = PicSplitterBar.Left
    .Height = iHeight
    .Top = offTop
  End With
  
  With PicSplitterBar
    .Height = iHeight
    .Top = offTop
  End With
  
  If cbTrees.Visible Then
  
    With shTree
      .Top = offTop + cbTrees.Height + 80
      .Width = PicSplitter.Left - 20 - .Left
      .Height = iHeight - .Top - 50
    End With
    
    With cbTrees
      .Top = offTop
      .Width = shTree.Width
    End With
    
    With twTree
      .Top = shTree.Top + 20
      .Width = PicSplitter.Left - 60 - .Left
      .Height = iHeight - .Top - 80
    End With
  
  Else
  
    With shTree
      .Top = offTop + 80
      .Width = PicSplitter.Left - 20 - .Left
      .Height = iHeight - .Top - 50
    End With
        
    With twTree
      .Top = shTree.Top + 20
      .Width = PicSplitter.Left - 60 - .Left
      .Height = iHeight - .Top - 80
    End With
  
  End If
  
  With shGrid
    .Top = offTop
    .Height = iHeight - .Top - 50
    .Left = PicSplitter.Left + PicSplitter.Width + 20
    .Width = ScaleWidth - .Left - 50
  End With
  
  With grItems
    .Top = shGrid.Top + 20
    .Height = iHeight - .Top - 80
    .Left = shGrid.Left + 20
    .Width = ScaleWidth - .Left - 100
  End With

ControlError:
End Sub

Private Sub GetPreference()
  On Error Resume Next
  
  Dim MouseWait As New cMouseWait
  MouseWait.Wait
  
  PicSplitterBar.Left = GetRegistry(csInterface, m_Name + "_SPLITTER_LEFT", PicSplitter.Left)
  
  ' el clik carga el Tree
  ListSetListIndexForId cbTrees, GetRegistry(csInterface, m_Name + "_LAST_TREE", m_CurrTree)
  
  ' si no se cargo ningun Tree, cargo el primero de la List
  If cbTrees.ListIndex = -1 Then
    ListSetListIndex cbTrees, 0
  End If
  
  m_CurrBranch = GetRegistry(csInterface, m_Name + "_LAST_FOLDER", m_CurrBranch)
  SetNodeForId twTree, m_CurrBranch
  
  If Not m_Trees(m_CurrTree) Is Nothing Then
    If Not m_Trees(m_CurrTree).Branchs(m_CurrBranch) Is Nothing Then
      If LoadLeavesRs(m_Trees(m_CurrTree).Branchs(m_CurrBranch).Leaves, m_CurrBranch) Then
        LoadGridRs grItems, m_Trees(m_CurrTree).Branchs(m_CurrBranch)
      End If
    End If
  End If
  
  SizeControls
End Sub

Private Function FindText(ByVal KeyAscii As Integer)
  Dim item As MSComctlLib.ListItem
  
  If Timer - m_LasKeyPress > 0.15 Then
    m_FindString = ""
  End If
  
  m_LasKeyPress = Timer
  
  m_FindString = m_FindString & Chr(KeyAscii)
  
  Set item = grItems.FindItem(m_FindString, lvwText, , lvwPartial)
  
  If Not item Is Nothing Then item.EnsureVisible
End Function

' construccion - destruccion
Private Sub UserControl_Initialize()
  On Error Resume Next
  
  m_CurrTree = 0
  BackColor = vbWindowBackground
  
  With PicSplitter
    .BackColor = BackColor
    .Move ScaleWidth * 0.33, 0, .Width, ScaleHeight
  End With
  With PicSplitterBar
    .Move ScaleWidth * 0.33, 0, PicSplitter.Width, ScaleHeight
    .Visible = False
    .ZOrder
  End With
  
  Set m_BranchsChecked = New Collection
  Set m_CollIdEdited = New Collection
  Set m_Trees = New cTrees
  Set m_Grid = New cListView
  Set twTree.ImageList = ImgTree
  Set grItems.SmallIcons = ImgTree
  Set grItems.ColumnHeaderIcons = ImgTree
  Set m_Selected = New cSelectedItems
  Set m_Checked = New cCheckedItems
  m_Grid.SetPropertys grItems
  'm_Grid.IMG_Active_FALSE = IMG_Active_FALSE
  'm_Grid.IMG_Active_TRUE = IMG_Active_TRUE
  ImgDrag.Visible = False
  ImgDragList.Visible = False
  ImgDragListVarios.Visible = False
  m_LasKeyPress = Timer
  m_FindString = vbNullString
  m_InDrag = False
  Set m_NodeToDrag = Nothing
  twTree.LabelEdit = tvwManual
End Sub

Private Sub UserControl_Terminate()
  On Error Resume Next
  
  Set m_Trees = Nothing
  Set m_Grid = Nothing
  Set m_Selected = Nothing
  Set m_Checked = Nothing
  CollClear m_BranchsChecked
  Set m_BranchsChecked = Nothing
  CollClear m_CollIdEdited
  Set m_CollIdEdited = Nothing
End Sub

'------------------------------------------------------------------------------------------------------------------------------------------
' Manejo de los checkbox en Tree y en Grid

' Actualiza la List de checkeados con las modificaciones hechas por el User
' a la List de trabajo.
' List de checkeados   m_ObjChkList
' List de trabajo    m_Checked
Public Function MoveCheckedToListChecked() As Boolean
  On Error GoTo ControlError
  
  Dim p   As cICheckedListItem
      
  For Each p In m_ObjChkList
    p.Checked = False
  Next

  Dim c As cCheckedItem
  
  Dim Encontrado As Boolean
  
  For Each c In m_Checked
    Encontrado = False
    For Each p In m_ObjChkList
      If c.Id = p.Id Then
        p.Checked = True
        Encontrado = True
        Exit For
      End If
    Next
    If Not Encontrado Then
      m_ObjChkList.Add p, c.Id
    End If
  Next

  MoveCheckedToListChecked = True
  Exit Function
ControlError:
  MngError Err, "MoveCheckedToListChecked", "cTreeCtrl", vbNullString
End Function
Public Sub RefreshListChecked()
  m_Checked.Clear
  
  Dim p   As cICheckedListItem
      
  For Each p In m_ObjChkList
  
    If p.Checked Then
      m_Checked.Add2 p.Id, p.Id
    End If
  Next
  
  SetChecks
  
  ' No controlamos errores por que vamos a buscar
  ' las ramas por su clave en la coleccion y si no
  ' estan va a ocurrir un error queremos atrapar
  ' ya que este error significa que la rama no esta
  ' seleccionada
  '
  On Error Resume Next
  
  Dim Node        As Node
  Dim branch_id   As Long
  Dim Count       As Long
  
  Count = m_BranchsChecked.Count
  
  For Each Node In twTree.Nodes
    If Count Then
      branch_id = 0
      branch_id = m_BranchsChecked(Node.Key)
      Node.Checked = branch_id
    Else
      Node.Checked = False
    End If
  Next
End Sub

Private Sub pAddColRol()
  On Error Resume Next
  
  Const c_key_rol = "key_rol"
  
  Err.Clear
  grItems.ColumnHeaders.item(c_key_rol).Text = LNGGetText(2219, vbNullString) 'Info
  
  If Err.Number <> 0 Then
    grItems.ColumnHeaders.Add , c_key_rol, LNGGetText(2219, vbNullString) 'Info
  End If
End Sub

Private Sub SetChecks()

  Dim iItemChk As cICheckedListItem
  Dim ItemChk  As cCheckedItem
  Dim bEnabled As Boolean
  Dim idxTag   As Long
  
  ' Si hay items
  '
  If grItems.ListItems.Count And grItems.Checkboxes Then
  
    Dim item As MSComctlLib.ListItem
    
    If m_ObjChkList.HaveToShowTag Then
      pAddColRol
      idxTag = grItems.ColumnHeaders.Count
    End If
    
    For Each item In grItems.ListItems
      
      If idxTag Then
        If idxTag - 1 > item.ListSubItems.Count Then item.ListSubItems.Add
        item.SubItems(idxTag - 1) = ""
      End If
      
      Set ItemChk = m_Checked.item(GetInfoString(item.Tag, TREE_CLIENT_ID))
      
      If Not ItemChk Is Nothing Then
        item.Checked = True
        
        bEnabled = True
        
        If idxTag Then
          
          For Each iItemChk In m_ObjChkList
            If ItemChk.Id = iItemChk.Id Then
              bEnabled = iItemChk.Enabled
              item.SubItems(idxTag - 1) = iItemChk.Tag
              Exit For
            End If
          Next
        End If
        
        If bEnabled Then
          item.ForeColor = vbWindowText
        Else
          item.ForeColor = vbRed
        End If
      Else
        item.Checked = False
        item.ForeColor = vbWindowText
      End If
    Next
  End If
End Sub

Private Sub twTree_NodeCheck(ByVal Node As MSComctlLib.Node)
  On Error GoTo ControlError

  If Timer - m_CollapseBug < 0.05 Then Exit Sub

  ' Para que se produsca el NodeClick
  twTree_NodeClick Node

  Dim mouse As cMouseWait
  Set mouse = New cMouseWait
  
  DoEvents: DoEvents: DoEvents: DoEvents

  LoadDescent m_Trees(m_CurrTree).Branchs, m_Trees(m_CurrTree).Branchs(GetIdFromKey(Node.Key)), Node.Checked

  SetChecksInTreeView Node.Child, Node.Checked

  SetChecks
  
  GoTo ExitProc
ControlError:
  MngError Err, "twTree_NodeCheck", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub SetChecksInTreeView(ByRef Node As MSComctlLib.Node, ByVal Checked As Boolean)
  Dim n As MSComctlLib.Node
  
  Set n = Node
  
  If n Is Nothing Then Exit Sub
  
  Do
    If Not n.Child Is Nothing Then
      SetChecksInTreeView n.Child, Checked
    End If
    n.Checked = Checked
    Set n = n.Next
    If n Is Nothing Then Exit Sub
  Loop
End Sub

Private Function LoadDescent(ByRef Branchs As cBranchs, ByRef Branch As cBranch, ByVal Checked As Boolean) As Boolean
  Dim i As Integer
  If Not Branch.ChildsLoaded Then
    Branchs.LoadChilds Branch.Id
  End If
  
  i = 0
  While Branch.Childs.Count > i
    i = i + 1
    If Not LoadDescent(Branchs, Branchs.item(Branch.Childs(i)), Checked) Then Exit Function
    If Not SetCheckInChecked(Branchs.item(Branch.Childs(i)), Checked) Then Exit Function
  Wend
  If Not SetCheckInChecked(Branch, Checked) Then Exit Function
  
  LoadDescent = True
End Function

Private Function SetCheckInChecked(ByRef Branch As cBranch, ByVal Checked As Boolean) As Boolean
  Dim i As Integer
  Dim Found As Boolean
  
  If Not Branch.Leaves.Load(Branch.Id) Then Exit Function
  
  Dim Leave As cLeave
  
  For Each Leave In Branch.Leaves
    i = 1
    Found = False
    ' Lo busco en m_Checked
    Do While i <= m_Checked.Count
      ' Si lo encontre
      If Leave.ClientId = m_Checked.ItemAt(i).Id Then
      
        ' Si esta Checkeado
        If Checked Then
          ' Prendo el flag para indicar que ya lo encontre
          Found = True
          
        ' Si no esta Checkeado
        Else
          ' Lo remuevo de la coleccion
          m_Checked.Remove Leave.ClientId
        End If
        
        ' No lo busco mas
        Exit Do
      
      ' Si no lo encontre sigo con el siguiente
      Else
        i = i + 1
      End If
      DoEvents
    Loop
    
    ' Si no lo encontre y esta checkeando lo agrego
    If Checked Then
      m_Checked.Add2 Leave.ClientId, Leave.ClientId
    End If
  Next
  
  SetCheckInChecked = True
End Function
'------------------------------------------------------------------------

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


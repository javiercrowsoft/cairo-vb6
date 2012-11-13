VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Begin VB.UserControl csTree 
   ClientHeight    =   4590
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   4800
   ScaleHeight     =   4590
   ScaleWidth      =   4800
   ToolboxBitmap   =   "csArbol.ctx":0000
   Begin MSComctlLib.ImageList ImgTree 
      Left            =   540
      Top             =   3960
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483643
      ImageWidth      =   16
      ImageHeight     =   16
      MaskColor       =   12632256
      _Version        =   393216
      BeginProperty Images {2C247F25-8591-11D1-B16A-00C0F0283628} 
         NumListImages   =   9
         BeginProperty ListImage1 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "csArbol.ctx":0312
            Key             =   ""
         EndProperty
         BeginProperty ListImage2 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "csArbol.ctx":08AC
            Key             =   ""
         EndProperty
         BeginProperty ListImage3 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "csArbol.ctx":0E46
            Key             =   ""
         EndProperty
         BeginProperty ListImage4 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "csArbol.ctx":13E0
            Key             =   ""
         EndProperty
         BeginProperty ListImage5 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "csArbol.ctx":197A
            Key             =   ""
         EndProperty
         BeginProperty ListImage6 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "csArbol.ctx":1AD4
            Key             =   ""
         EndProperty
         BeginProperty ListImage7 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "csArbol.ctx":206E
            Key             =   ""
         EndProperty
         BeginProperty ListImage8 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "csArbol.ctx":2388
            Key             =   ""
         EndProperty
         BeginProperty ListImage9 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "csArbol.ctx":2922
            Key             =   ""
         EndProperty
      EndProperty
   End
   Begin MSComctlLib.ListView grItems 
      Height          =   870
      Left            =   1845
      TabIndex        =   5
      Top             =   1575
      Width           =   1995
      _ExtentX        =   3519
      _ExtentY        =   1535
      LabelWrap       =   -1  'True
      HideSelection   =   -1  'True
      _Version        =   393217
      ForeColor       =   -2147483640
      BackColor       =   -2147483643
      BorderStyle     =   1
      Appearance      =   1
      NumItems        =   0
   End
   Begin MSComctlLib.Toolbar tbBar 
      Align           =   1  'Align Top
      Height          =   630
      Left            =   0
      TabIndex        =   4
      Top             =   0
      Width           =   4800
      _ExtentX        =   8467
      _ExtentY        =   1111
      ButtonWidth     =   609
      ButtonHeight    =   953
      Appearance      =   1
      _Version        =   393216
   End
   Begin VB.PictureBox PicSplitter 
      BorderStyle     =   0  'None
      Height          =   4290
      Left            =   1665
      MousePointer    =   9  'Size W E
      ScaleHeight     =   4290
      ScaleWidth      =   45
      TabIndex        =   3
      Top             =   45
      Width           =   50
   End
   Begin VB.PictureBox PicSplitterBar 
      BackColor       =   &H8000000D&
      BorderStyle     =   0  'None
      Height          =   4290
      Left            =   4095
      ScaleHeight     =   4290
      ScaleWidth      =   105
      TabIndex        =   2
      Top             =   0
      Width           =   105
   End
   Begin VB.ComboBox cbTrees 
      Height          =   315
      Left            =   180
      Style           =   2  'Dropdown List
      TabIndex        =   0
      Top             =   855
      Width           =   1320
   End
   Begin MSComctlLib.TreeView twTree 
      Height          =   2490
      Left            =   90
      TabIndex        =   1
      Top             =   1305
      Width           =   1455
      _ExtentX        =   2566
      _ExtentY        =   4392
      _Version        =   393217
      Indentation     =   353
      LineStyle       =   1
      Style           =   7
      Appearance      =   1
   End
   Begin VB.Image ImgDragListVarios 
      Height          =   480
      Left            =   3555
      Picture         =   "csArbol.ctx":2EBC
      Top             =   3735
      Width           =   480
   End
   Begin VB.Image ImgDragList 
      Height          =   480
      Left            =   2745
      Picture         =   "csArbol.ctx":31C6
      Top             =   3600
      Width           =   480
   End
   Begin VB.Image ImgDrag 
      Height          =   480
      Left            =   1935
      Picture         =   "csArbol.ctx":34D0
      Top             =   3690
      Width           =   480
   End
   Begin VB.Menu popTree 
      Caption         =   "popArbol"
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
   End
End
Attribute VB_Name = "csTree"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
'--------------------------------------------------------------------------------
' csTree
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
Private Const C_Module = "csTree"


Const sglSplitLimit = 500
Const KEY_FATHER = "FATHER"
Const KEY_BRANCH_Key = "BRANCHC"
Private Const TREE_CLIENT_ID = "LEAVE_ID"   ' Es el id del Client no de la Leave

Const IMG_FOLDER_OPEN = 2
Const IMG_FOLDER_CLOSE = 1
Const IMG_ACTIVE_TRUE = 3
Const IMG_ACTIVE_FALSE = 4

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
Private m_Name      As String
Private m_Moving    As Boolean
Private m_Trees     As CSOAPI.cTrees
Private m_OldTree   As Long
Private m_OldBranch As Long
Private m_Buttons1  As Long
Private m_Buttons2  As Long
Private m_Buttons3  As Long
Private m_Grid      As CSOAPI.cListView
Private m_OldKey    As String
Private m_TableId   As Long
Private m_Selected  As cSelectedItems

'----------------------------------------------------
' Para manejar los checkbox en el Tree y en la List
Private m_Checked    As cCheckedItems       ' List de trabajo
Private m_ObjChkList As cICheckedList       ' List de checkeados
'----------------------------------------------------

Private m_ToolBarVisible As Boolean

Private m_CollIdEdited  As Collection       ' Contiene una coleccion con todos los ids editados, cuando una Branch se carga, y contiene
                                            ' este id, si ya estaba carga se vuelve a leer de la base de datos para refrescar.

Private m_BeginClick As Single              ' Timer al momento del click

Private m_WasButtonRigth    As Boolean      ' Flag que indica que se presiono el Button derecho del
                                            ' mouse se prende en MouseDown y se apaga en MosueUp
                                            ' del control twTree

Private m_PopUpMenuShowed As Boolean        ' Flag que indica que no hay que mostrar el popup menu
                                            ' en el evento MouseUp del twTree, por que ya se mostro
                                            ' en el evento NodeClick del mismo control

Private m_vCopy()   As Long ' Contiene los Ids copiados y cortados
Private m_vDrag()   As Long ' Contiene los Ids dragueados

Private m_csWhatCopied  As csWhatCopied
Private m_Copying       As Boolean ' Indica si hay algo que Paste
Private m_Copied        As Boolean ' Indican la operacion de copia realizada
Private m_Cut           As Boolean
Private m_TreeCut       As Long     ' guarda el id del Tree desde el que se corto
Private m_CopiedCutOnlyChilds   As Boolean  ' Solo para Folders: indica si se copian o cortan solo las Folders
                                            ' que dependen de esta rama
Private m_BranchIdCopyed As Long

Private m_LasKeyPress As Single             ' Busca por teclado
Private m_FindString  As String             ' Texto a buscar

Private m_IconText      As Integer

' Drag operation
Private m_InDrag        As Boolean
Private m_NodeToDrag    As MSComctlLib.Node
Private m_DragFolder    As Boolean
Private m_DragOperation As Integer

Private m_ListLeftButton   As Boolean

Private m_TimerDrag     As Single   ' lo uso para saber si esta dragueando (o como carajo se diga)

Private m_NoLoadItemsSelected As Boolean

' eventos
Public Event ToolBarClick(ByVal Button As Object)
Public Event DblClick()

' propiedades publicas
Public Property Get Id() As Long
    Id = m_Grid.Id
End Property

Public Property Get BranchId() As Long
    BranchId = m_OldBranch
End Property

Public Property Get TreeId() As Long
    TreeId = m_OldTree
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
    ToolBarVisible = tbBar.Visible
End Property

Public Property Let ToolBarVisible(ByVal rhs As Boolean)
    m_ToolBarVisible = rhs
    tbBar.Visible = rhs
    SizeControls
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
Public Function Load(ByVal Id As Long) As Boolean
    
    Dim MouseWait As New cMouseWait
    MouseWait.Wait
    
    Dim Tree As CSOAPI.cTree
    
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
    
    m_OldBranch = 0
    
    m_Trees(Id).Load
    
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
    
    For Each Branch In m_Trees(m_OldTree).Branchs
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

' Refresca una Branch usada despues de la edicion
Public Function RefreshActiveBranch() As Boolean
    On Error GoTo ControlError
    RefreshActiveBranch = LoadLeaves(m_Trees(m_OldTree).Branchs(m_OldBranch).Leaves, m_OldBranch, True)
    
    Dim OldBranch As Long
    
    OldBranch = m_OldBranch
    m_OldBranch = 0
    LoadGrid m_Trees(m_OldTree).Branchs(OldBranch)
    m_OldBranch = OldBranch
    
    Exit Function
ControlError:
    MngError Err, "RefreshActiveBranch", "csTree", ""
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
    CSKernelClient.SetToolBar tbBar, Buttons1 + BUTTON_COPY + BUTTON_CUT + BUTTON_PASTE, Buttons2, Buttons3
    DoEvents
End Function

Public Sub SavePreference(ByVal WinState As Integer)
    
    If WinState = vbMinimized Then Exit Sub

    SetRegistry csInterface, m_Name + "_SPLITTER_LEFT", PicSplitter.Left
    SetRegistry csInterface, m_Name + "_LAST_TREE", m_OldTree
    SetRegistry csInterface, m_Name + "_LAST_FOLDER", m_OldBranch
    
    If Not twTree.SelectedItem Is Nothing Then
        m_Grid.SaveColumnWidth m_Name + "_" + GetInfoString(twTree.SelectedItem.Tag, KEY_BRANCH_Key)
    End If
End Sub
'------------------------------------------------------------------------------------------------------------------------------------------
' funciones privadas

' eventos
Private Sub cbTrees_Click()
    If m_OldTree = ListID(cbTrees) Then Exit Sub
    m_OldTree = ListID(cbTrees)
    
    LoadBranchs m_OldTree
    
    m_Grid.Clear
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
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub grItems_DblClick()
  RaiseEvent DblClick
End Sub

Private Sub grItems_ItemCheck(ByVal item As MSComctlLib.ListItem)
    If item.Checked Then
        Dim Key As Long
        Key = GetInfoString(item.Tag, TREE_CLIENT_ID)
        m_Checked.Add2 Key, Key
    Else
        m_Checked.Remove GetInfoString(item.Tag, TREE_CLIENT_ID)
    End If
End Sub

Private Sub grItems_ItemClick(ByVal item As MSComctlLib.ListItem)

    If m_NoLoadItemsSelected Then Exit Sub
    
    ' Obtengo una referencia a los items a ser dragueados
    m_Grid.GetSelected m_vDrag()
    
End Sub

Private Sub grItems_KeyPress(KeyAscii As Integer)
    FindText KeyAscii
End Sub

Private Sub grItems_MouseDown(Button As Integer, Shift As Integer, x As Single, y As Single)
    m_ListLeftButton = Button <> vbRightButton
    If m_ListLeftButton Then
        
        m_InDrag = False
        
        If grItems.HitTest(x, y) Is Nothing Then Exit Sub
        
        m_TimerDrag = Timer
        
        m_NoLoadItemsSelected = False
        
        ' 2 es control
        If (m_Grid.GetSelectedCount > 1) And ((Shift And 2) = 0) Then
            m_NoLoadItemsSelected = True
        End If
        
    End If
End Sub

Private Sub grItems_MouseMove(Button As Integer, Shift As Integer, x As Single, y As Single)
    If Button = vbLeftButton Then ' Signal a Drag operation.

        If m_InDrag Then Exit Sub

        If Not (Timer - m_TimerDrag > 0.1) Then Exit Sub
        
        If grItems.SelectedItem Is Nothing Then Exit Sub
        
        If m_Grid.GetSelectedCount = 1 Then
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

Private Sub grItems_MouseUp(Button As Integer, Shift As Integer, x As Single, y As Single)
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

' Up y Down Folders
Private Sub popDown_Click()
    DownFolder
End Sub

Private Sub popUp_Click()
    UpFolder
End Sub

Private Sub tbBar_ButtonClick(ByVal Button As MSComctlLib.Button)
  RaiseEvent ToolBarClick(Button)
End Sub

Private Sub UserControl_Resize()
    On Error Resume Next
    SizeControls
End Sub

Private Sub LoadBranch(ByVal BranchId As Long)
    
    Dim MouseWait As New cMouseWait
    MouseWait.Wait
    
    If m_OldBranch = BranchId Then Exit Sub
    m_OldBranch = BranchId
    
    LoadLeaves m_Trees(m_OldTree).Branchs(m_OldBranch).Leaves, m_OldBranch
    LoadGrid m_Trees(m_OldTree).Branchs(m_OldBranch)
End Sub

' Name de la Folder
Private Sub twTree_KeyDown(KeyCode As Integer, Shift As Integer)
    If KeyCode = vbKeyF2 Then twTree.StartLabelEdit
End Sub

Private Sub twTree_AfterLabelEdit(Cancel As Integer, NewString As String)
    Cancel = Not RenameFolder(NewString)
End Sub

' Menu
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
   If m_InDrag = True Then
      ' Set DropHighlight to the mouse's coordinates.
      Set twTree.DropHighlight = twTree.HitTest(x, y)
   End If
End Sub

Private Sub twTree_MouseMove(Button As Integer, Shift As Integer, x As Single, y As Single)
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
    LoadBranch GetIdFromKey(Node.Key)
    If m_WasButtonRigth Then
        m_PopUpMenuShowed = True
        ShowMenu MOUSE_NODE
    End If
End Sub

Private Sub twTree_MouseDown(Button As Integer, Shift As Integer, x As Single, y As Single)
    m_BeginClick = Timer
    m_WasButtonRigth = Button = vbRightButton
    If Not m_WasButtonRigth Then
        ' para que en el click se seleccione la Folder
        Set twTree.SelectedItem = twTree.HitTest(x, y)
        Set m_NodeToDrag = twTree.SelectedItem ' Obtengo una referencia al item a ser dragueado
    End If
End Sub

Private Sub twTree_MouseUp(Button As Integer, Shift As Integer, x As Single, y As Single)
    m_BeginClick = 0
    If Not m_PopUpMenuShowed And m_WasButtonRigth Then
        ShowMenu MOUSE_UP
    End If
    m_WasButtonRigth = False
    m_PopUpMenuShowed = False
End Sub

Private Sub ShowMenu(ByVal Quien As Integer)
    
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
    PopupMenu popTree
End Sub

Private Sub popNewTree_Click()
    NewTree
End Sub

Private Sub popNewFolder_Click()
    NewFolder
End Sub

Private Sub popRenameFolder_Click()
    twTree.StartLabelEdit
End Sub

Private Sub popDeleteFolder_Click()
    DeleteFolder twTree.SelectedItem
End Sub

Private Sub popCopyFolder_Click()
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
    ' Primero termino con la operacion anterior
    EndCopy csDiscard
    
    m_csWhatCopied = csCopyedItems
    BeginCopy
    
    m_Copied = True
    m_Cut = False
    m_Copying = True
End Sub

Private Sub popCutItem_Click()
    ' Primero termino con la operacion anterior
    EndCopy csDiscard
    
    BeginCopy
    
    m_Copied = False
    m_Cut = True
    m_csWhatCopied = csCopyedItems
    m_Copying = True
End Sub

Private Sub popPasteInFolder_Click()
    EndCopy csPaste
End Sub

Private Sub popPasteInFolder2_Click()
    EndCopy csPaste
End Sub

Private Sub BeginCopy()
    Select Case m_csWhatCopied
        Case csCopyedItems
            m_Grid.GetSelected m_vCopy()
        Case csCopyedBranchs
            TreeGetSelected m_vCopy
    End Select
    m_BranchIdCopyed = m_OldBranch
End Sub

Private Sub EndCopy(ByVal csToDo As csToDo, Optional ByVal BranchId As Long)
    
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
    Dim IdOfCopy As Long
    Dim IsCut As Boolean
    
    
    Dim cLock As cLockUpdateWindow
    Set cLock = New cLockUpdateWindow
    cLock.LockW twTree.hWnd
    
    If twTree.SelectedItem Is Nothing Then Exit Sub
    
    If m_Copied Then
        IsCut = False
    ElseIf m_Cut Then
        IsCut = True
        
        If m_Trees(m_OldTree).Branchs.IsChildOf(GetIdFromKey(twTree.SelectedItem.Key), m_vCopy(0)) Then
            MsgWarning "No se puede mover a esta carpeta.; El destino es una subcarpeta del origen."
            Exit Sub
        End If
    End If
    
    If Not m_Trees(m_OldTree).Branchs.Paste(m_vCopy(0), GetIdFromKey(twTree.SelectedItem.Key), m_CopiedCutOnlyChilds, IsCut) Then Exit Sub
    
    If Not m_Trees(m_OldTree).Branchs.LoadBranch(GetIdFromKey(twTree.SelectedItem.Key), IdOfCopy) Then Exit Sub
    
    ' si corto tengo que borrar la rama
    If IsCut Then
        Dim Nodo As Node
        On Error Resume Next
        Err = 0
        Set Nodo = twTree.Nodes(GetKey(m_vCopy(0)))
        
        ' si error es distinto de cero, entonces se cambio de Tree.
        If Err = 0 Then
            DelFolder Nodo
            
        ' si cambio de Tree y corto la Root tengo que borrar el Tree
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
    
    ' Primero termino con la operacion anterior
    EndCopy csDiscard
    
    m_BranchIdCopyed = BranchId
    
    m_csWhatCopied = csCopyedItems
    ReDim m_vCopy(0)
    
    ' Los ids News se multiplican por menos uno
    m_vCopy(0) = Id * -1
    
    m_Copied = True
    m_Cut = False
    m_Copying = True
    
    AddLeave = PasteItems(BranchId, TreeId)
    
    ' Por cada Tree tengo que indicar que la Root debe ser recargada
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
    MngError Err, "AddLeave", "csTree", ""
End Function

' La funcion AddLeave es la unica que llama a PasteItems pasandole los parametros. Cuando los parametros tienen Valuees, se
' pega en la carpeta indicada por ellos, de lo contrario se pega en la carpeta activa.
Private Function PasteItems(Optional ByVal BranchId As Long = csNO_ID, Optional ByVal TreeId As Long = csNO_ID) As Boolean
    Dim BranchIdToPaste As Long
    
    
    If BranchId = csNO_ID Then
    
        If twTree.SelectedItem Is Nothing Then
            MsgWarning "Seleccione una carpeta", "Paste"
            Exit Function
        End If
        
        BranchIdToPaste = GetIdFromKey(twTree.SelectedItem.Key)
    Else
        BranchIdToPaste = BranchId
    End If
    
    If m_Copied Then
    
        ' El unico caso en que TreeId es <> de csNO_ID es cuando Copied Leaves por medio de la function AddLeave
        ' por esto solo se utiliza en esta parte del If (en Paste no se le da bola)
        If TreeId = csNO_ID Then TreeId = m_OldTree
    
        If Not m_Trees(TreeId).Branchs(BranchIdToPaste).Leaves.Paste(m_vCopy(), BranchIdToPaste, False) Then Exit Function
    End If
    
    If m_Cut Then
        
        ' Para reLoad la rama mas abajo
        TreeId = m_OldTree
        
        If Not m_Trees(m_OldTree).Branchs(BranchIdToPaste).Leaves.Paste(m_vCopy(), BranchIdToPaste, True) Then Exit Function
        
        ' si corte, tengo que sacar de la rama origen
        ' solo si no se trata de la misma Branch, sino se hace mas abajo
        If m_BranchIdCopyed <> BranchIdToPaste Then
            m_Trees(m_OldTree).Branchs(m_BranchIdCopyed).Leaves.IsLoaded = False
            If Not LoadLeaves(m_Trees(m_OldTree).Branchs(m_BranchIdCopyed).Leaves, m_BranchIdCopyed) Then Exit Function
        End If
        
        ' si aun estoy en la rama origen vuelvo a Load la Grid
        ' solo si no se trata de la misma Branch, sino se hace mas abajo
        If m_BranchIdCopyed = m_OldBranch And m_BranchIdCopyed <> BranchIdToPaste Then
            m_OldBranch = 0
            LoadGrid m_Trees(m_OldTree).Branchs(m_BranchIdCopyed)
            m_OldBranch = m_BranchIdCopyed
        End If
    End If
    
    ' ya sea que copie o corte, tengo que reLoad la rama destino
    m_Trees(TreeId).Branchs(BranchIdToPaste).Leaves.IsLoaded = False
    If Not LoadLeaves(m_Trees(TreeId).Branchs(BranchIdToPaste).Leaves, BranchIdToPaste) Then Exit Function
    
    ' si la rama origen es la misma que el destino vuelvo a Load la Grid
    If m_OldBranch = BranchIdToPaste Then
        m_OldBranch = 0
        LoadGrid m_Trees(TreeId).Branchs(BranchIdToPaste)
        m_OldBranch = BranchIdToPaste
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
            If Not m_Trees(m_OldTree).Branchs(BranchIdToPaste).Leaves.Paste(m_vDrag(), BranchIdToPaste, False) Then Exit Sub
        Case csDragCut
            If Not m_Trees(m_OldTree).Branchs(BranchIdToPaste).Leaves.Paste(m_vDrag(), BranchIdToPaste, True) Then Exit Sub
    
            Dim ramIdCopyed As Long
            ramIdCopyed = GetIdFromKey(twTree.SelectedItem.Key)
            m_Trees(m_OldTree).Branchs(ramIdCopyed).Leaves.IsLoaded = False
            If Not LoadLeaves(m_Trees(m_OldTree).Branchs(ramIdCopyed).Leaves, ramIdCopyed) Then Exit Sub
    
            m_OldBranch = 0
            LoadGrid m_Trees(m_OldTree).Branchs(ramIdCopyed)
            m_OldBranch = ramIdCopyed
    
    End Select
    
    ' ya sea que copie o corte, tengo que reLoad la rama destino
    m_Trees(m_OldTree).Branchs(BranchIdToPaste).Leaves.IsLoaded = False
    If Not LoadLeaves(m_Trees(m_OldTree).Branchs(BranchIdToPaste).Leaves, BranchIdToPaste) Then Exit Sub
End Sub

Private Sub DragDropFolder(ByVal BranchIdToPaste As Long)
    
    Dim MouseWait As New cMouseWait
    MouseWait.Wait
    
    Dim IdOfCopy As Long
    Dim IsCut As Boolean
    
    Dim cLock As cLockUpdateWindow
    Set cLock = New cLockUpdateWindow
    cLock.LockW twTree.hWnd
    
    ' si movio a la misma Branch no hay que hacer nada
    If BranchIdToPaste = GetIdFromKey(twTree.SelectedItem.Key) Then Exit Sub
    
    Select Case m_DragOperation
        Case csDragCopy
            IsCut = False
            
        Case csDragCut
            IsCut = True
    
            If m_Trees(m_OldTree).Branchs.IsChildOf(BranchIdToPaste, GetIdFromKey(twTree.SelectedItem.Key)) Then
                MsgWarning "No se puede mover a esta carpeta.;El destino es una subcarpeta del origen."
                Exit Sub
            End If
    End Select
    
    If Not m_Trees(m_OldTree).Branchs.Paste(GetIdFromKey(twTree.SelectedItem.Key), BranchIdToPaste, False, IsCut) Then Exit Sub
    
    If Not m_Trees(m_OldTree).Branchs.LoadBranch(BranchIdToPaste, IdOfCopy) Then Exit Sub
    
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
            m_Grid.Clear
            
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
                LoadGrid .Root
            Else
                If GetIdFromKey(Nodo.Key) = .Root.Id Then
                    LoadGrid .Root
                End If
            End If
        End With
    End If
End Sub

Private Sub DelFolder(ByRef Nodo As Node)
    
    If Nodo Is Nothing Then Exit Sub
    
    twTree.Nodes.Remove Nodo.Index
    m_Grid.Clear
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
    
    If Not GetInput(Name, "Ingrese el nombre del árbol ...") Then Exit Function
    
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
    
    If Not GetInput(Name, "Ingrese el nombre de la rama ...") Then Exit Function
    
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
    RenameFolder = m_Trees(m_OldTree).Branchs(GetIdFromKey(twTree.SelectedItem.Key)).Rename(NewName)
    
    ' si se trata de la Root tengo que cambiar en el combo el nombre Tree
    If Val(GetInfoString(twTree.SelectedItem.Tag, KEY_FATHER)) = csNO_ID Then
        ListChangeTextForSelected cbTrees, NewName
        ListSetListIndex cbTrees, cbTrees.ListCount - 1
        m_Trees(m_OldTree).Name = NewName
    End If
End Function

Private Sub UpFolder()
    Dim MouseWait As New cMouseWait
    MouseWait.Wait
    
    
    Dim IdOfCopy As Long
    Dim cLock As cLockUpdateWindow
    Set cLock = New cLockUpdateWindow
    cLock.LockW twTree.hWnd
        
    With m_Trees(GetKey(m_OldTree))
        
        If .Branchs(GetKey(m_OldBranch)).Id = .Branchs.Root.Id Then Exit Sub
        
        .Branchs(GetKey(m_OldBranch)).UpBranch
    
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
    cLock.LockW twTree.hWnd
        
    With m_Trees(GetKey(m_OldTree))
        
        If .Branchs(GetKey(m_OldBranch)).Id = .Branchs.Root.Id Then Exit Sub
        
        .Branchs(GetKey(m_OldBranch)).DownBranch
    
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
Private Function LoadGrid(ByRef Branch As cBranch) As Boolean
    
    Dim MouseWait As New cMouseWait
    MouseWait.Wait
    
    Dim cLock As cLockUpdateWindow
    Set cLock = New cLockUpdateWindow
    cLock.LockW grItems.hWnd
        
    m_Grid.SaveColumnWidth m_Name + "_" + m_OldKey

    If Not m_Grid.LoadFromBranch(Branch) Then Exit Function
    
    ' ahora seteo el Value check de cada item
    SetChecks
    
    If GetInfoString(twTree.SelectedItem.Tag, KEY_BRANCH_Key) = "" Then
        twTree.SelectedItem.Tag = SetInfoString(twTree.SelectedItem.Tag, KEY_BRANCH_Key, m_Grid.GetKeyFromColumns(Branch))
    End If
    
    m_OldKey = GetInfoString(twTree.SelectedItem.Tag, KEY_BRANCH_Key)
    m_Grid.GetColumnWidth m_Name & "_" & m_OldKey, 2
    
    LoadGrid = True
End Function

Private Sub PicSplitter_MouseDown(Button As Integer, Shift As Integer, x As Single, y As Single)
    With PicSplitter
        PicSplitterBar.Move .Left, .Top, .Width \ 2, .Height - 20
    End With
    PicSplitterBar.Visible = True
    m_Moving = True
End Sub

Private Sub PicSplitter_MouseMove(Button As Integer, Shift As Integer, x As Single, y As Single)
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
Private Sub PicSplitter_MouseUp(Button As Integer, Shift As Integer, x As Single, y As Single)
    SizeControls
    PicSplitterBar.Visible = False
    m_Moving = False
End Sub

Private Sub SizeControls()
    Dim i As Integer
    Dim WinState    As Integer
    Dim offTop      As Integer
    Dim iHeigth     As Integer
    'SetPosControls
    
    On Error GoTo ControlError
    
    DoEvents: DoEvents: DoEvents: DoEvents
    
    If Not GetWindowState(WinState, Parent) Then Exit Sub
    If WinState = vbMinimized Then Exit Sub
    
    If PicSplitterBar.Left > ScaleWidth Then
        PicSplitterBar.Left = ScaleWidth - 50
    End If
    
    If m_ToolBarVisible Then
        offTop = tbBar.Height
    Else
        offTop = 0
    End If
    iHeigth = ScaleHeight - offTop
    
    PicSplitter.Left = PicSplitterBar.Left
    PicSplitter.Height = iHeigth
    PicSplitter.Top = offTop
    PicSplitterBar.Height = iHeigth
    PicSplitterBar.Top = offTop
    cbTrees.Left = 0
    cbTrees.Top = offTop
    cbTrees.Width = PicSplitter.Left
    twTree.Move 0, cbTrees.Height + offTop, PicSplitter.Left, iHeigth - cbTrees.Height
    grItems.Move PicSplitter.Left + PicSplitter.Width, offTop, ScaleWidth - PicSplitter.Left + PicSplitter.Width - 60, iHeigth
ControlError:
End Sub

Private Sub GetPreference()
    
    Dim MouseWait As New cMouseWait
    MouseWait.Wait
    
    PicSplitterBar.Left = GetRegistry(csInterface, m_Name + "_SPLITTER_LEFT", PicSplitter.Left)
    
    ' el clik carga el Tree
    ListSetListIndexForId cbTrees, GetRegistry(csInterface, m_Name + "_LAST_TREE", m_OldTree)
    
    ' si no se cargo ningun Tree, cargo el primero de la List
    If cbTrees.ListIndex = 0 Then
        ListSetListIndex cbTrees
    End If
    
    m_OldBranch = GetRegistry(csInterface, m_Name + "_LAST_FOLDER", m_OldBranch)
    SetNodeForId twTree, m_OldBranch
    
    If Not m_Trees(m_OldTree) Is Nothing Then
        If Not m_Trees(m_OldTree).Branchs(m_OldBranch) Is Nothing Then
            If LoadLeaves(m_Trees(m_OldTree).Branchs(m_OldBranch).Leaves, m_OldBranch) Then
                LoadGrid m_Trees(m_OldTree).Branchs(m_OldBranch)
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
    m_OldTree = 0
    PicSplitter.Move ScaleWidth * 0.33, 0, PicSplitter.Width, ScaleHeight
    PicSplitterBar.Move ScaleWidth * 0.33, 0, PicSplitter.Width, ScaleHeight
    PicSplitterBar.Visible = False
    PicSplitterBar.ZOrder
    Set m_CollIdEdited = New Collection
    Set m_Trees = New cTrees
    Set m_Grid = New cListView
    Set m_Grid.Grid = grItems
    Set twTree.ImageList = ImgTree
    Set grItems.SmallIcons = ImgTree
    Set grItems.ColumnHeaderIcons = ImgTree
    Set m_Selected = New cSelectedItems
    Set m_Checked = New cCheckedItems
    m_Grid.SetPropertys
    m_Grid.IMG_ACTIVE_FALSE = IMG_ACTIVE_FALSE
    m_Grid.IMG_ACTIVE_TRUE = IMG_ACTIVE_TRUE
    ImgDrag.Visible = False
    m_LasKeyPress = Timer
    m_FindString = ""
    m_InDrag = False
    Set m_NodeToDrag = Nothing
    twTree.LabelEdit = tvwManual
End Sub

Private Sub UserControl_Terminate()
    Set m_Trees = Nothing
    Set m_Grid = Nothing
    Set m_Selected = Nothing
    Set m_Checked = Nothing
    CollClear m_CollIdEdited
    Set m_CollIdEdited = Nothing
End Sub

Private Sub UserControl_WriteProperties(PropBag As PropertyBag)
    PropBag.WriteProperty "ToolBarVisible", tbBar.Visible
End Sub
Private Sub UserControl_ReadProperties(PropBag As PropertyBag)
    tbBar.Visible = PropBag.ReadProperty("ToolBarVisible", True)
End Sub

'------------------------------------------------------------------------------------------------------------------------------------------
' Manejo de los checkbox en Tree y en Grid

' Actualiza la List de checkeados con las modificaciones hechas por el User
' a la List de trabajo.
' List de checkeados   m_ObjChkList
' List de trabajo      m_Checked
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
    MngError Err, "MoveCheckedToListChecked", "csTree", ""
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
End Sub
Private Sub SetChecks()
    If grItems.Checkboxes Then
        Dim item As MSComctlLib.ListItem
        
        For Each item In grItems.ListItems
            item.Checked = Not (m_Checked(GetInfoString(item.Tag, TREE_CLIENT_ID)) Is Nothing)
        Next
    End If
End Sub

Private Sub twTree_NodeCheck(ByVal Node As MSComctlLib.Node)
  On Error GoTo ControlError

  ' Para que se produsca el NodeClick
  twTree_NodeClick Node

  Dim Mouse As cMouseWait
  Set Mouse = New cMouseWait
  DoEvents

  LoadDescent m_Trees(m_OldTree).Branchs, m_Trees(m_OldTree).Branchs(GetIdFromKey(Node.Key)), Node.Checked

  SetChecksInTreeView Node.Child, Node.Checked

  SetChecks
  
  GoTo ExitProc
ControlError:
  MngError Err, "", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
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
'  If Err.Number <> 0 Then Resume ExitProc
'ExitProc:
'  On Error Resume Next


VERSION 5.00
Object = "{353A8433-36B8-422E-ABBD-36CEE8BE628E}#1.0#0"; "CSButton.ocx"
Object = "{EBA71138-C194-4F8F-8A43-4781BBB517F8}#1.0#0"; "CSTree2.ocx"
Object = "{AB350268-0AA3-445C-8F38-C22EB727290F}#1.0#0"; "CSHelp2.ocx"
Begin VB.Form fPermisos 
   BackColor       =   &H80000005&
   Caption         =   "Configuración de Permisos"
   ClientHeight    =   5730
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   10980
   Icon            =   "fPermisos.frx":0000
   LinkTopic       =   "Form2"
   MDIChild        =   -1  'True
   ScaleHeight     =   5730
   ScaleWidth      =   10980
   Begin CSButton.cButtonLigth cmdCreateTree 
      Height          =   330
      Left            =   8580
      TabIndex        =   8
      Top             =   240
      Width           =   1515
      _ExtentX        =   2672
      _ExtentY        =   582
      Caption         =   "Generar Arbol"
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
      ForeColor       =   0
      Picture         =   "fPermisos.frx":014A
   End
   Begin CSButton.cButtonLigth cmdSearch 
      Height          =   330
      Left            =   7440
      TabIndex        =   7
      Top             =   240
      Width           =   1035
      _ExtentX        =   1826
      _ExtentY        =   582
      Caption         =   "Buscar"
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
      ForeColor       =   0
      Picture         =   "fPermisos.frx":06E4
   End
   Begin CSTree2.cTreeCtrl Tree2 
      Height          =   4605
      Left            =   450
      TabIndex        =   6
      Top             =   945
      Width           =   4785
      _ExtentX        =   8440
      _ExtentY        =   8123
   End
   Begin CSTree2.cTreeCtrl Tree1 
      Height          =   4605
      Left            =   3420
      TabIndex        =   5
      Top             =   1170
      Width           =   4785
      _ExtentX        =   8440
      _ExtentY        =   8123
   End
   Begin VB.ComboBox cbView 
      Height          =   315
      Left            =   5235
      Style           =   2  'Dropdown List
      TabIndex        =   3
      Top             =   240
      Width           =   2055
   End
   Begin CSButton.cButton cmdSave 
      Height          =   330
      Left            =   3690
      TabIndex        =   2
      Top             =   240
      Width           =   1095
      _ExtentX        =   1931
      _ExtentY        =   582
      Caption         =   "Guardar"
      Style           =   3
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
   Begin CSHelp2.cHelp cHelp1 
      Height          =   300
      Left            =   1455
      TabIndex        =   1
      Top             =   240
      Width           =   2055
      _ExtentX        =   3625
      _ExtentY        =   529
      BorderColor     =   12164479
      BorderType      =   1
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      FontName        =   "MS Sans Serif"
      FontSize        =   9.75
      ButtonStyle     =   0
   End
   Begin VB.Label LbObjeto 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Usuarios"
      Height          =   375
      Left            =   495
      TabIndex        =   0
      Top             =   240
      Width           =   735
   End
   Begin VB.Label Label1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Ver"
      Height          =   315
      Left            =   4935
      TabIndex        =   4
      Top             =   270
      Width           =   255
   End
   Begin VB.Image ImgIcon 
      Height          =   480
      Left            =   120
      Picture         =   "fPermisos.frx":0C7E
      Top             =   120
      Width           =   480
   End
   Begin VB.Shape ShHeader 
      BackColor       =   &H8000000A&
      BorderStyle     =   0  'Transparent
      FillColor       =   &H80000014&
      FillStyle       =   0  'Solid
      Height          =   1050
      Left            =   0
      Top             =   0
      Width           =   10710
   End
End
Attribute VB_Name = "fPermisos"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' fPermisos
' 22-06-00

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes

Private Const C_Module = "fPermisos"

Private Const c_PrestacionesUsRol = 1
Private Const c_UsuariosRoles = 2
Private Const c_Prestaciones = 3
' estructuras
' variables privadas
Private m_What                 As csPermissionType
Private m_Name                As String
Private m_MngPermisos         As cPermisoManager
Private WithEvents m_Menu     As cPopupMenu
Attribute m_Menu.VB_VarHelpID = -1
' propiedades publicas
Public Property Let Que(ByVal rhs As csPermissionType)
  m_What = rhs
End Property
Public Property Let NameEdit(ByVal rhs As String)
  m_Name = rhs
End Property
Public Property Get NameEdit() As String
  NameEdit = m_Name
End Property
' propiedades privadas
' funciones publicas
Public Function Init() As Boolean
  Tree1.IconText = csIMG_REDCUBE
  Tree1.TreeCheckBox = True
  Tree1.ListCheckBox = True
  
  Tree2.IconText = csIMG_REDCUBE
  Tree2.TreeCheckBox = True
  Tree2.ListCheckBox = True

  Set m_MngPermisos = New cPermisoManager
  Set Tree1.ListChecked = m_MngPermisos.Permisos
  Set Tree2.ListChecked = m_MngPermisos.UsuarioRol
  
  Select Case m_What
    Case csTPRol
      cHelp1.Table = csRol
      Tree1.NameClient = "PERMISOS_ROL1"
      Tree2.NameClient = "PERMISOS_ROL2"
      LbObjeto.Caption = "Rol"
      If Not Tree1.Load(csTables.csPrestacion) Then Exit Function
      Init = Tree2.Load(csTables.csUsuario)
      
    Case csTPUser
      cHelp1.Table = csUsuario
      LbObjeto.Caption = "Usuario"
      Tree1.NameClient = "PERMISOS_USUARIO1"
      Tree2.NameClient = "PERMISOS_USUARIO2"
      If Not Tree1.Load(csTables.csPrestacion) Then Exit Function
      Init = Tree2.Load(csTables.csRol)
  
      ' Por ultimo abro con los permisos del usuario logueado
      ' para que no este tan vacio
      'cHelp1.Id = CSOAPI2.User.Id
      'cHelp1.ValueUser = CSOAPI2.User.Name
      'cHelp1_Change
  End Select
  cHelp1.ButtonStyle = cHelpButtonSingle
End Function

Private Sub cbView_Click()
  Form_Resize
End Sub

Private Sub cHelp1_Change()
  On Error GoTo ControlError
  
  m_MngPermisos.Load Val(cHelp1.Id), m_What
  If m_What = csTPRol Then
    m_MngPermisos.SetBranchChecked Tree1.BranchsChecked, csNO_ID, Val(cHelp1.Id), Tree1.TreeId, True
    m_MngPermisos.SetBranchChecked Tree2.BranchsChecked, csNO_ID, Val(cHelp1.Id), Tree2.TreeId, False
  Else
    m_MngPermisos.SetBranchChecked Tree1.BranchsChecked, Val(cHelp1.Id), csNO_ID, Tree1.TreeId, True
    m_MngPermisos.SetBranchChecked Tree2.BranchsChecked, Val(cHelp1.Id), csNO_ID, Tree2.TreeId, False
  End If
  Tree1.RefreshListChecked
  Tree2.RefreshListChecked
  
  Exit Sub
ControlError:
  MngError Err, "cHelp1_Change", C_Module, ""
End Sub

Private Sub cmdCreateTree_Click()
  On Error GoTo ControlError
  
  If m_What = csTPRol Then
    pCreateMenuTree
    pShowCreateTreeMenu
  Else
    If Not pCreateTreePrestacion() Then Exit Sub
    pCloseAndOpen
  End If
  
  Exit Sub
ControlError:
  MngError Err, "cmdCreateTree_Click", C_Module, ""
End Sub
  
Private Function pCreateTreePrestacion() As Boolean
  On Error GoTo ControlError
  
  If Not pAskTree() Then Exit Function
  
  Dim Mouse As cMouseWait
  Set Mouse = New cMouseWait

  ' Aunque falle vuelvo a abrir y cerrar la ventana
  pCreateTreePrestacion = True

  m_MngPermisos.CreateTree

  Exit Function
ControlError:
  MngError Err, "pCreateTreePrestacion", C_Module, ""
End Function

Private Function pCreateTreeUsuario() As Boolean
  On Error GoTo ControlError
  
  If Not pAskTree() Then Exit Function
  
  Dim Mouse As cMouseWait
  Dim sqlstmt As String
  
  Set Mouse = New cMouseWait
  
  ' Aunque falle vuelvo a abrir y cerrar la ventana
  pCreateTreeUsuario = True

  sqlstmt = "sp_ArbUsuariosCrear"
  OAPI.Database.Execute sqlstmt

  Exit Function
ControlError:
  MngError Err, "pCreateTreeUsuario", C_Module, ""
End Function

Private Sub pCreateMenuSearch()
  Dim iPTop   As Long
  Dim iP      As Long
  Dim iP2     As Long
  Dim iP3     As Long
  
  If m_Menu Is Nothing Then
    Set m_Menu = New cPopupMenu
  End If
  
  m_Menu.Clear

  ' Creating a Menu:
  With m_Menu
    ' Initial set up:
    .hWndOwner = Me.hWnd
    .OfficeXpStyle = True
    
    iP = .AddItem("&Prestaciones", , , iPTop, , , , "popSearchPrestacion")
    
    If m_What = csTPRol Then
      iP = .AddItem("&Usuarios", , , iPTop, , , , "popSearchUsRol")
    Else
      iP = .AddItem("&Roles", , , iPTop, , , , "popSearchUsRol")
    End If
  End With
End Sub

Private Sub pCreateMenuTree()
  Dim iPTop   As Long
  Dim iP      As Long
  Dim iP2     As Long
  Dim iP3     As Long
  
  If m_Menu Is Nothing Then
    Set m_Menu = New cPopupMenu
  End If
  
  m_Menu.Clear

  ' Creating a Menu:
  With m_Menu
    ' Initial set up:
    .hWndOwner = Me.hWnd
    .OfficeXpStyle = True
    
    iP = .AddItem("&Prestaciones", , , iPTop, , , , "popCreateTreePrestacion")
    iP = .AddItem("&Usuarios", , , iPTop, , , , "popCreateTreeUsuario")
  End With
End Sub

Private Sub pShowSearchMenu()
  m_Menu.ShowPopupMenu cmdSearch.Left, cmdSearch.Top + cmdSearch.Height
End Sub

Private Sub pShowCreateTreeMenu()
  m_Menu.ShowPopupMenu cmdCreateTree.Left, cmdCreateTree.Top + cmdCreateTree.Height
End Sub

Private Sub cmdSave_Click()
  On Error GoTo ControlError
  
  Dim Mouse As cMouseWait
  Set Mouse = New cMouseWait

  If Not Tree1.MoveCheckedToListChecked() Then Exit Sub
  If Not Tree2.MoveCheckedToListChecked() Then Exit Sub
  If Not m_MngPermisos.Permisos.Save(fMain.Client, ClientProcessId, m_What = csTPUser) Then Exit Sub
  If Not m_MngPermisos.UsuarioRol.Save() Then Exit Sub
  cHelp1_Change

  Exit Sub
ControlError:
  MngError Err, "cmdSave_Click", C_Module, ""
End Sub

Private Sub cmdSearch_Click()
  On Error Resume Next
  pCreateMenuSearch
  pShowSearchMenu
End Sub

Private Sub pSearchPrestacion()
  On Error Resume Next
  Dim Id As Long
  
  Id = pSearchAux(csPrestacion)
  Tree1.Search Id
End Sub

Private Sub pSearchUsuarioRol()
  On Error Resume Next
  Dim Id As Long
  
  If m_What = csTPRol Then
    Id = pSearchAux(csUsuario)
  Else
    Id = pSearchAux(csRol)
  End If
  Tree2.Search Id
End Sub

Private Function pSearchAux(ByVal Table As Long) As Long
  Dim Help As CSOAPI2.cHelp
  Dim hr As cHelpResult
  
  Set Help = New CSOAPI2.cHelp
  
  Set hr = Help.Show(Nothing, Table, "", "", "")
  
  If hr.Cancel Then Exit Function
  
  pSearchAux = hr.Id
End Function

Private Sub Form_Activate()
  On Error Resume Next
  fMain.RefreshTabs
End Sub

Private Sub Form_Load()
  On Error GoTo ControlError

  If m_What = csTPRol Then
    cbView.AddItem "Prestaciones y Usuarios"
    cbView.ItemData(cbView.NewIndex) = c_PrestacionesUsRol
    cbView.AddItem "Usuarios"
    cbView.ItemData(cbView.NewIndex) = c_UsuariosRoles
  Else
    cbView.AddItem "Prestaciones y Roles"
    cbView.ItemData(cbView.NewIndex) = c_PrestacionesUsRol
    cbView.AddItem "Roles"
    cbView.ItemData(cbView.NewIndex) = c_UsuariosRoles
  End If
  
  cbView.AddItem "Prestaciones"
  cbView.ItemData(cbView.NewIndex) = c_Prestaciones
  cbView.ListIndex = 0
  
  If m_What = csTPRol Then
    Me.Caption = Me.Caption & " (Roles)"
  Else
    Me.Caption = Me.Caption & " (Usuarios)"
  End If

  On Error Resume Next
  Me.WindowState = vbMaximized

  Exit Sub
ControlError:
  MngError Err, "Form_Load", C_Module, ""
End Sub

' funciones privadas
Private Sub Form_Resize()
  On Error Resume Next
  
  Select Case cbView.ItemData(cbView.ListIndex)
    Case c_Prestaciones
      CSKernelClient2.SetStyleHeaderEditCombo Me, Tree1.Name
      Tree2.Visible = False
      Tree1.Visible = True
    Case c_PrestacionesUsRol
      CSKernelClient2.SetStyleHeaderEditCombo Me, Tree1.Name, Tree2.Name
      Tree1.Visible = True
      Tree2.Visible = True
    Case c_UsuariosRoles
      CSKernelClient2.SetStyleHeaderEditCombo Me, Tree2.Name
      Tree2.Visible = True
  End Select
End Sub

Private Sub m_Menu_Click(ItemNumber As Long)
  On Error GoTo ControlError
  
  Select Case m_Menu.ItemKey(ItemNumber)
    Case "popCreateTreePrestacion"
      If Not pCreateTreePrestacion() Then Exit Sub
    Case "popCreateTreeUsuario"
      If Not pCreateTreeUsuario() Then Exit Sub
    Case "popSearchPrestacion"
      pSearchPrestacion
      Exit Sub
    Case "popSearchUsRol"
      pSearchUsuarioRol
      Exit Sub
  End Select
  
  pCloseAndOpen
  
  GoTo ExitProc
ControlError:
  MngError Err, "m_Menu_Click", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub pCloseAndOpen()
  Unload Me
  fMain.RefreshTabs
  
  If m_What = csTPRol Then
    fMain.mnuRolPermiso_Click
  Else
    fMain.mnuUsuarioPermiso_Click
  End If
End Sub

Private Function pAskTree() As Boolean
  pAskTree = Ask("Al generar el árbol se cerrará y abrirá automaticamente esta ventana.;;Si tiene cambios que no ha guardado y no desea perderlos conteste NO, guarde los cambios, y vuelva intentar.;;¿Desea continuar?.", vbNo)
End Function

' construccion - destruccion
Private Sub Form_Unload(Cancel As Integer)
  On Error GoTo ControlError
  
  Set m_Menu = Nothing
  Tree1.SavePreference WindowState
  Tree2.SavePreference WindowState
  Set Tree1.ListChecked = Nothing
  Set m_MngPermisos = Nothing
  CSKernelClient2.UnloadForm Me, m_Name
  
  Exit Sub
ControlError:
  MngError Err, "Form_Unload", C_Module, ""
End Sub

#If PREPROC_DEBUG Then
Private Sub Form_Initialize()
  gdbInitInstance C_Module
End Sub

Private Sub Form_Terminate()
  gdbTerminateInstance C_Module
End Sub
#End If


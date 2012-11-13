VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Object = "{57EC5E1A-9098-47A9-A8E3-EF352F97282B}#2.2#0"; "CSButton.ocx"
Object = "{E3029087-6983-4DF6-A07F-E770EFB12BC0}#1.1#0"; "CSToolBar.ocx"
Begin VB.MDIForm fMain 
   AutoShowChildren=   0   'False
   BackColor       =   &H00FFFFFF&
   Caption         =   "Cairo"
   ClientHeight    =   7440
   ClientLeft      =   165
   ClientTop       =   450
   ClientWidth     =   11295
   Icon            =   "fMain2.frx":0000
   LinkTopic       =   "MDIForm1"
   StartUpPosition =   3  'Windows Default
   Begin VB.Timer tmUtils 
      Interval        =   10
      Left            =   1920
      Top             =   1800
   End
   Begin MSComctlLib.ImageList ilMenu 
      Left            =   1080
      Top             =   1680
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483643
      ImageWidth      =   16
      ImageHeight     =   16
      MaskColor       =   12632256
      _Version        =   393216
      BeginProperty Images {2C247F25-8591-11D1-B16A-00C0F0283628} 
         NumListImages   =   3
         BeginProperty ListImage1 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain2.frx":030A
            Key             =   ""
         EndProperty
         BeginProperty ListImage2 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain2.frx":08A4
            Key             =   ""
         EndProperty
         BeginProperty ListImage3 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMain2.frx":0E3E
            Key             =   ""
         EndProperty
      EndProperty
   End
   Begin VB.PictureBox picMenuHolder 
      Align           =   1  'Align Top
      BorderStyle     =   0  'None
      Height          =   375
      Left            =   0
      ScaleHeight     =   375
      ScaleWidth      =   11295
      TabIndex        =   3
      Top             =   0
      Width           =   11295
   End
   Begin VB.PictureBox picBar 
      Align           =   1  'Align Top
      Appearance      =   0  'Flat
      BackColor       =   &H80000004&
      BorderStyle     =   0  'None
      ForeColor       =   &H80000008&
      Height          =   510
      Left            =   0
      ScaleHeight     =   510
      ScaleWidth      =   11295
      TabIndex        =   0
      Top             =   375
      Width           =   11295
      Begin CSButton.cButtonLigth cmdShowDesktop 
         Height          =   315
         Left            =   7320
         TabIndex        =   2
         Top             =   120
         Width           =   1275
         _ExtentX        =   2249
         _ExtentY        =   556
         Caption         =   "&Escritorio   "
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
         FontSize        =   8,25
         Picture         =   "fMain2.frx":13D8
      End
      Begin VB.Label lbBar 
         BackStyle       =   0  'Transparent
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   12
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H8000000E&
         Height          =   285
         Left            =   270
         TabIndex        =   1
         Top             =   90
         Width           =   1635
      End
      Begin VB.Shape shBar 
         BackColor       =   &H80000010&
         BackStyle       =   1  'Opaque
         BorderStyle     =   0  'Transparent
         Height          =   375
         Left            =   45
         Shape           =   4  'Rounded Rectangle
         Top             =   90
         Width           =   3255
      End
   End
   Begin CSToolBar.cReBar rbMain 
      Left            =   840
      Top             =   1080
      _ExtentX        =   7117
      _ExtentY        =   873
   End
End
Attribute VB_Name = "fMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' fMain
' 13-02-00

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' Interfaces
Implements cIMenuHost
' constantes
Private Const C_Module = "fMain"

Private Const C_ExBarPosition = "ExBarPosition"

Private Const csPreOListPermiso = 18

' estructuras
' variables privadas
Private m_EditObj       As Collection
Private m_ListDocObj    As Collection
Private m_MenuServer    As cMenu

Private m_bMenuReady    As Boolean

Private m_tbhMenu       As cToolbarHost

Private WithEvents m_Menu As cPopupMenu
Attribute m_Menu.VB_VarHelpID = -1

Private WithEvents m_cMDITabs As cMDITabs
Attribute m_cMDITabs.VB_VarHelpID = -1

Private WithEvents m_Client As cTCPIPClient
Attribute m_Client.VB_VarHelpID = -1

Private m_bTabs       As Boolean
Private m_bUnload     As Boolean

Private m_CollTCPObjects    As Collection
' propiedades publicas
Public Property Get Client() As cTCPIPClient
  Set Client = m_Client
End Property
Public Property Set Client(ByRef rhs As cTCPIPClient)
  Set m_Client = rhs
End Property
' propiedades privadas
' funciones publicas
Public Sub RefreshTabs()
  m_bTabs = True
  tmUtils.Enabled = True
End Sub
' Interfaces

Private Function cIMenuHost_AddIcon(iPicIcon As stdole.Picture) As Long
  On Error Resume Next
  
  cIMenuHost_AddIcon = (ilMenu.ListImages.Add(, , iPicIcon).Index) - 1
  
  If Err.Number <> 0 Then
    cIMenuHost_AddIcon = -1
  Else
    m_Menu.ImageList = ilMenu
  End If
End Function

' Recibe el click de un menu y crea un
' form Tree de edicion de abm para ese menu
Private Sub cIMenuHost_MenuABMClick(ByVal ObjEdit As String, Obj As Object, ByVal NameABM As String, ByVal Buttons As String, ByVal Tabla As Long)
  On Error GoTo ControlError
  
  Dim ObjfAbm As fTree
  
  ' Si el objeto no esta cargado
  If Not ExistsObjectInColl(m_EditObj, ObjEdit) Then
    ' Creo uno nuevo
    m_EditObj.Add New fTree, ObjEdit
  End If
  
  Set ObjfAbm = m_EditObj(ObjEdit)
  
  ' Me aseguro que tenga permiso de edicion
  Dim o As cIEditGeneric
  Set o = Obj
  
  ' Si no puede editar chau
  If Not o.ShowList Then Exit Sub
  
  ObjfAbm.ObjABMName = "CSABMInterface.cABMGeneric"
  ObjfAbm.ObjEditName = ObjEdit
  
  ' Configuro el form para este abm
  With ObjfAbm
      .NameEdit = NameABM
      If Buttons = 0 Then
        .Buttons1 = BUTTON_DELETE + BUTTON_SEARCH + BUTTON_EDIT + BUTTON_PRINTOBJ + BUTTON_NEW + BUTTON_EXIT
      Else
        .Buttons1 = Buttons
      End If
      .Table = Tabla
      .csTree1.ToolBarVisible = True
  End With
  CSKernelClient.ShowFormWithInit ObjfAbm, NameABM
  
  RefreshTabs
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIMenuHost_MenuABMClick", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub cIMenuHost_MenuListDocClick(ByVal ObjAbm As String, ByVal ObjEdit As String, ByVal ObjListABM As String, ByVal ObjList As String, Obj As Object, ByVal NameABM As String, ByVal Buttons As String)
  On Error GoTo ControlError
   
  Dim ObjListDoc As fListDoc
  
  ' Si el objeto no esta cargado
  If Not ExistsObjectInColl(m_ListDocObj, ObjEdit) Then
    ' Creo uno nuevo
    m_ListDocObj.Add New fListDoc, ObjEdit
  End If
  
  Set ObjListDoc = m_ListDocObj(ObjEdit)
  
  ' Me aseguro que tenga permiso de edicion
  Dim o As cIEditGeneric
  Set o = Obj
  
  ' Si no puede editar chau
  If Not o.ShowList Then Exit Sub
  
  ObjListDoc.ObjABMName = ObjAbm
  ObjListDoc.ObjEditName = ObjEdit
  ObjListDoc.ObjListABMNombre = ObjListABM
  ObjListDoc.ObjListNombre = ObjList
  
  ' Configuro el form para este abm
  With ObjListDoc
    .NameEdit = NameABM
    If Buttons <> 0 Then
      .Buttons1 = Buttons
    Else
      .Buttons1 = BUTTON_DELETE + BUTTON_SEARCH + BUTTON_EDIT + BUTTON_PRINTOBJ + BUTTON_NEW + BUTTON_EXIT
    End If
  End With
  
  CSKernelClient.ShowFormWithInit ObjListDoc, NameABM

  RefreshTabs
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIMenuHost_MenuListDocClick", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub cIMenuHost_MenuWizardClick(ByVal ClientName As String)
  On Error GoTo ControlError
  
  Dim ObjWizard As cIWizardGeneric
  Set ObjWizard = CSKernelClient.CreateObject("CSABMInterface.cWizardGeneric")
  
  ObjWizard.Show ClientName
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIMenuHost_MenuABMClick", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Property Get cIMenuHost_Server() As CSMenu.cMenu
  On Error GoTo ControlError
   
  Set cIMenuHost_Server = m_MenuServer

  GoTo ExitProc
ControlError:
  MngError Err, "cIMenuHost_Server", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Property

#If Not PREPROC_SFS2 Then
Private Sub cmdShowDesktop_Click()
  On Error Resume Next
  
  fDesktop.Show
  fDesktop.ZOrder
End Sub
#End If

Private Sub m_Client_ReciveText(ByVal Buffer As String)
  On Error GoTo ControlError
   
  Dim IDInstance As Long
  Dim iModule    As cITCPModule
  
  If Buffer = "" Then Exit Sub
  
  IDInstance = TCPGetDllID(Buffer)
  
  If IDInstance = 0 Then Exit Sub
  
  If m_CollTCPObjects Is Nothing Then Exit Sub
  
  Dim IDTcp      As Long
  IDTcp = TCPGetDllProgID(Buffer)
  If IDTcp = 0 Then Exit Sub
  
  For Each iModule In m_CollTCPObjects
    If (iModule.IDInstance = IDInstance) Or _
       (IDInstance = c_AnyComponentTCP And iModule.ProgId = IDTcp) _
       Then Exit For
  Next
  
  If iModule Is Nothing Then
    
    Dim SysTCP     As CSOAPI.cSysModuloTCP
    
    Set SysTCP = New CSOAPI.cSysModuloTCP
    If Not SysTCP.Load(IDTcp) Then Exit Sub
    
    If SysTCP.ObjetoEdicion = "" Then Exit Sub
    
    Set iModule = CSKernelClient.CreateObject(SysTCP.ObjetoEdicion)
    
    m_CollTCPObjects.Add iModule
    iModule.IDInstance = m_CollTCPObjects.Count
  End If
  
  iModule.ProcessMessage TCPGetSrvToClientMsg(Buffer)

  GoTo ExitProc
ControlError:
  MngError Err, "m_Client_ReciveText", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub MDIForm_QueryUnload(Cancel As Integer, UnloadMode As Integer)
  On Error GoTo ControlError

  Cancel = Not CSABMInterface.CloseDll()

  GoTo ExitProc
ControlError:
  MngError Err, "MDIForm_QueryUnload", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub MDIForm_Resize()
  On Error GoTo ControlError
   
  picBar_Resize

  GoTo ExitProc
ControlError:
  MngError Err, "MDIForm_Resize", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

' funciones privadas
Private Sub mnuAbout_Click()
  On Error GoTo ControlError
   
  fAbout.Show vbModal

  GoTo ExitProc
ControlError:
  MngError Err, "mnuAbout_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub mnuAyudaIndex_Click()
  On Error Resume Next
  CSKernelClient.EditFile CSKernelClient.GetValidPath(App.Path) & "CSInfoAFIP.chm", Me.hWnd
End Sub

Private Sub mnuChangeCompany_Click()
  On Error GoTo ControlError

  Dim ConnectString As String
  Dim UserName      As String
  Dim db_id         As Long
  Dim Password      As String
  Dim Client        As cTCPIPClient
  
  Set Client = New cTCPIPClient

  If LoginToCompany(ConnectString, UserName, Client, db_id, Password, True) Then
  
    Client.TerminateSession
    Set Client = Nothing
  
    Dim cmdLine As String
    cmdLine = GetValidPath(App.Path) & App.EXEName & ".exe " & GetStartupLine(UserName, Password, db_id)
    Shell cmdLine
  
    mnuExit_Click
  End If

  GoTo ExitProc
ControlError:
  MngError Err, "mnuChangeCompany_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
  
  Client.TerminateSession
  Set Client = Nothing
End Sub

Private Sub mnuOrganizarVentanas_Click()
  Me.Arrange vbArrangeIcons
End Sub

Private Sub mnuMosaicoVertical_Click()
  Me.Arrange vbTileVertical
End Sub

Private Sub mnuMosaicoHorizontal_Click()
  Me.Arrange vbTileHorizontal
End Sub

Private Sub mnuCascada_Click()
  Me.Arrange vbCascade
End Sub

Private Sub mnuExit_Click()
  On Error GoTo ControlError
   
  m_bUnload = True
  tmUtils.Enabled = True

  GoTo ExitProc
ControlError:
  MngError Err, "mnuSalir_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub mnuUsuarioPermiso_Click()
  On Error GoTo ControlError
   
  ' Administrator
  If User.Id <> 1 Then
    If Not SecurityCanAccess(csPreOListPermiso) Then Exit Sub
  End If
   
  If fPermisosUsuarios Is Nothing Then
    Set fPermisosUsuarios = New fPermisos
  End If
  fPermisosUsuarios.NameEdit = "PERMISOS_USUARIO"
  fPermisosUsuarios.Que = csTPUser
  CSKernelClient.ShowFormWithInit fPermisosUsuarios, fPermisosUsuarios.Name

  GoTo ExitProc
ControlError:
  MngError Err, "mnuUsuarioPermiso_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub mnuRolPermiso_Click()
  On Error GoTo ControlError
  
  ' Administrator
  If User.Id <> 1 Then
    If Not SecurityCanAccess(csPreOListPermiso) Then Exit Sub
  End If
  
  If fPermisosRoles Is Nothing Then
    Set fPermisosRoles = New fPermisos
  End If
  fPermisosRoles.NameEdit = "PERMISOS_ROL"
  fPermisosRoles.Que = csTPRol
  CSKernelClient.ShowFormWithInit fPermisosRoles, fPermisosRoles.Name

  GoTo ExitProc
ControlError:
  MngError Err, "mnuRolPermiso_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub mnuUsuarioDefinicion_Click()
  On Error GoTo ControlError
   
  Dim o As cIEditGeneric
  Set o = CSKernelClient.CreateObject("CSOAPI.cUsuario")
  If Not o.ShowList Then Exit Sub
  If fListUsuarios Is Nothing Then
      Set fListUsuarios = New fTree
      fListUsuarios.ObjABMName = "CSABMInterface.cABMGeneric"
      fListUsuarios.ObjEditName = "CSOAPI.cUsuario"
  End If
  
  CSOAPI.User.ShowUsers fListUsuarios
  fListUsuarios.ZOrder

  GoTo ExitProc
ControlError:
  MngError Err, "mnuUsuarioDefinicion_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub mnuRolDefinicion_Click()
  On Error GoTo ControlError
   
  Dim o As cIEditGeneric
  Set o = CSKernelClient.CreateObject("CSOAPI.cRol")
  If Not o.ShowList Then Exit Sub
  If fListRoles Is Nothing Then
      Set fListRoles = New fTree
      fListRoles.ObjABMName = "CSABMInterface.cABMGeneric"
      fListRoles.ObjEditName = "CSOAPI.cRol"
  End If
  With fListRoles
      .NameEdit = "Roles"
      .Buttons1 = BUTTON_DELETE + BUTTON_SEARCH + BUTTON_EDIT + BUTTON_PRINTOBJ + BUTTON_NEW + BUTTON_PREVIEW + BUTTON_EXIT
      .Table = csRol
      .csTree1.ToolBarVisible = True
  End With
  
  CSKernelClient.ShowFormWithInit fListRoles, "Roles"
  fListRoles.ZOrder

  GoTo ExitProc
ControlError:
  MngError Err, "mnuRolDefinicion_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

' construccion - destruccion
Private Sub MDIForm_Load()
  On Error GoTo ControlError
   
  Set m_EditObj = New Collection
  Set m_ListDocObj = New Collection
  Set m_MenuServer = New cMenu
  
  pCreateMenu
  m_MenuServer.Initialize Me.hWnd, m_Menu
  CSKernelClient.LoadForm Me, "MAIN"

  Set m_cMDITabs = New cMDITabs
  m_cMDITabs.Attach Me.hWnd

  Set m_CollTCPObjects = New Collection

  pShowAviso

#If PREPROC_SFS2 Then
  cmdShowDesktop.Visible = False
#End If

  GoTo ExitProc
ControlError:
  MngError Err, "MDIForm_Load", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub MDIForm_Unload(Cancel As Integer)
  On Error GoTo ControlError
   
  UnloadApp

  Set m_Menu = Nothing
  Set m_MenuServer = Nothing
  
  CollClear m_EditObj
  CollClear m_ListDocObj
  CollClear m_CollTCPObjects
  
  Set m_EditObj = Nothing
  Set m_ListDocObj = Nothing
  Set m_CollTCPObjects = Nothing
  
  CSKernelClient.UnloadForm Me, "MAIN"
  CloseApp

  GoTo ExitProc
ControlError:
  MngError Err, "MDIForm_Unload", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub picBar_Resize()
  On Error Resume Next
  shBar.Width = picBar.ScaleWidth - shBar.Left * 2
  lbBar.Width = picBar.ScaleWidth - lbBar.Left * 2
  cmdShowDesktop.Left = picBar.ScaleWidth - cmdShowDesktop.Width - 200
End Sub

Private Sub picMenuHolder_Resize()
  If m_bMenuReady Then
    rbMain.RebarSize
    If picMenuHolder.Align = 1 Or picMenuHolder.Align = 2 Then
      picMenuHolder.Height = rbMain.RebarHeight * Screen.TwipsPerPixelY
    Else
      picMenuHolder.Width = rbMain.RebarHeight * Screen.TwipsPerPixelY
    End If
  End If
End Sub

' Menus
Private Sub m_Menu_Click(ItemNumber As Long)
  Select Case m_Menu.ItemKey(ItemNumber)
    Case "mnuChangeCompany", "mnuChangeUser"
      mnuChangeCompany_Click
    Case "mnuChangePassword"
      pChangePassword
    Case "mnuExit"
      mnuExit_Click
    Case "mnuDefinición"
    Case "mnuUsuarioDefinicion"
      mnuUsuarioDefinicion_Click
    Case "mnuUsuarioPermiso"
      mnuUsuarioPermiso_Click
    Case "mnuRolDefinicion"
      mnuRolDefinicion_Click
    Case "mnuRolPermiso"
      mnuRolPermiso_Click
  
    Case "mnuCascada"
      mnuCascada_Click
    Case "mnuMosaicoHorizontal"
      mnuMosaicoHorizontal_Click
    Case "mnuMosaicoVertical"
      mnuMosaicoVertical_Click
    Case "mnuOrganizarVentanas"
      mnuOrganizarVentanas_Click
      
    Case "mnuAyudaIndex"
      mnuAyudaIndex_Click
    Case "mnuAbout"
      mnuAbout_Click
      
#If Not PREPROC_SFS2 Then
    Case "mnuAvisosOcultar"
      exbrMain.Visible = False
      ' Explorer Bar Position
      CSKernelClient.SetRegistry csInterface, C_ExBarPosition, 0
    Case "mnuAvisosDerecha"
      exbrMain.Align = 4
      exbrMain.Visible = True
      ' Explorer Bar Position
      CSKernelClient.SetRegistry csInterface, C_ExBarPosition, 4
    Case "mnuAvisosIzquierda"
      exbrMain.Align = 3
      exbrMain.Visible = True
      ' Explorer Bar Position
      CSKernelClient.SetRegistry csInterface, C_ExBarPosition, 3
#End If
  End Select
End Sub

Private Sub pCreateMenu()
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
    
    .ImageList = ilMenu
    
    ' File menu:
    iP = .AddItem("&Archivo", , , iPTop, , , , "mnuArchivo")
      .AddItem "&Cambiar de Empresa", , , iP, , , , "mnuChangeCompany"
      .AddItem "Cambiar de &Usuario", , , iP, , , , "mnuChangeUser"
      .AddItem "-", , , iP, , , , "mnuFileSep1"
      .AddItem "Cambiar Contraseña", , , iP, , , , "mnuChangePassword"
      .AddItem "-", , , iP, , , , "mnuFileSep2"
      .AddItem "&Salir", , , iP, , , , "mnuExit"
    
    ' Config Menu:
    iP = .AddItem("Co&nfiguración", , , iPTop, , , , "mnuConfiguracion")
      iP2 = .AddItem("&Empresa", , , iP, , , , "mnuEmpresa")
        .AddItem "&Definición", , , iP2, , , , "mnuDefinición"
        .AddItem "-", , , iP2, , , , "sep2"
        iP3 = .AddItem("&Usuarios", , , iP2, 0, , , "mnuUsuarios")
          .AddItem "&Definición", , , iP3, , , , "mnuUsuarioDefinicion"
          .AddItem "&Permisos", , , iP3, 2, , , "mnuUsuarioPermiso"
        iP3 = .AddItem("&Roles", , , iP2, 1, , , "mnuRoles")
          .AddItem "&Definición", , , iP3, , , , "mnuRolDefinicion"
          .AddItem "&Permisos", , , iP3, 2, , , "mnuRolPermiso"
  End With
End Sub

Public Sub ShowMenu()
  Dim iPTop   As Long
  Dim iP      As Long
  Dim iP2     As Long
  Dim iP3     As Long
  
  Const c_TblName = "tbrMenu"
  Const c_TblHoldName = "tbhMenu"
  
  With m_Menu
    ' Ventana
    iP = .AddItem("&Ventana", , , iPTop, , , , "mnuVentana")
      .AddItem "&Cascada", , , iP, , , , "mnuCascada"
      .AddItem "Mosaico Horizontal", , , iP, , , , "mnuMosaicoHorizontal"
      .AddItem "&Mosaico Vertical", , , iP, , , , "mnuMosaicoVertical"
      .AddItem "&Organizar Ventanas", , , iP, , , , "mnuOrganizarVentanas"
      iP = .AddItem("Barra de Avisos", , , iP, , , , "mnuAvisos")
        .AddItem "Ocultar", , , iP, , , , "mnuAvisosOcultar"
        .AddItem "Ver a la derecha", , , iP, , , , "mnuAvisosDerecha"
        .AddItem "Ver a la izquierda", , , iP, , , , "mnuAvisosIzquierda"
    ' Ayuda
    iP = .AddItem("A&yuda", , , iPTop, , , , "mnuAyuda")
      .AddItem "&Indice...", , , iP, , , , "mnuAyudaIndex"
      .AddItem "Acerca de Cairo", , , iP, , , , "mnuAbout"
  End With
  
  Dim tbrMenu As cToolbar
  
  pRemoveCtrls c_TblName
  
  Set tbrMenu = Me.Controls.Add("CSToolBar.cToolbar", c_TblName, picBar)
  tbrMenu.DestroyToolBar
  
  ' ------------------------------------------------------------------------------------
  ' Create the Menu for the form:
  tbrMenu.DrawStyle = CTBDrawOfficeXPStyle
  ' Note that there is also a CreateFromMenu2 option
  ' which allows you to create menus from a specified sub-menu
  ' within a cPopupMenu object.
  tbrMenu.CreateFromMenu m_Menu
  
  pRemoveCtrls c_TblHoldName
  
  Set m_tbhMenu = Me.Controls.Add("CSToolBar.cToolbarHost", c_TblHoldName, picBar)
  
  With m_tbhMenu
    .ImageSource = CTBLoadFromFile
    .MDIToolbarHideButtons = True
    .MDIToolbar = True
    .ReleaseCaptures
    .ClearPicture
    .Capture tbrMenu
    .Width = m_tbhMenu.MDIToolbarMinWidth * Screen.TwipsPerPixelX
    .Refresh
  End With
End Sub

Private Sub pRemoveCtrls(ByVal ctlName As String)
  On Error Resume Next
  Me.Controls.Remove ctlName
End Sub

Public Sub CreateReBar()
  With rbMain
  
    .DestroyRebar
  
    ' a) Create the rebar:
    .ImageSource = CRBLoadFromFile
    .CreateReBar picMenuHolder.hWnd
    
    .AddBandByHwnd m_tbhMenu.hWnd, , , , "MenuBar"
    
    .Position = erbPositionBottom
  End With
  
  m_bMenuReady = True
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


Private Sub m_cMDITabs_CloseWindow(ByVal hWnd As Long)
Dim Frm As Form
   Set Frm = formForHwnd(hWnd)
   If Not Frm Is Nothing Then Unload Frm
   RefreshTabs
End Sub

'Private Sub m_cMDITabs_TabBarClick(ByVal iButton As MouseButtonConstants, ByVal screenX As Long, ByVal screenY As Long)
'   Dim sMsg As String
'   sMsg = "Bar Click, button: "
'   If (iButton = vbLeftButton) Then
'      sMsg = sMsg & "Left"
'   Else
'      sMsg = sMsg & "Right"
'   End If
'   sMsg = sMsg & " at (" & screenX & "," & screenY & ")"
'   showEvent sMsg
'End Sub

'Private Sub m_cMDITabs_TabClick(ByVal iButton As MouseButtonConstants, ByVal hWnd As Long, ByVal screenX As Long, ByVal screenY As Long)
'   Dim sMsg As String
'   sMsg = "Tab Click, button: "
'   If (iButton = vbLeftButton) Then
'      sMsg = sMsg & "Left"
'   Else
'      sMsg = sMsg & "Right"
'   End If
'   sMsg = sMsg & " for form: " & formForHwnd(hWnd).Name
'   sMsg = sMsg & " at (" & screenX & "," & screenY & ")"
'   showEvent sMsg
'   If (iButton = vbRightButton) Then
'      Me.PopupMenu mnuViewTOP, , screenX * Screen.TwipsPerPixelX, screenY * Screen.TwipsPerPixelY
'      'Me.PopupMenu mnuViewTOP, , 0, 0
'   End If
'End Sub

'Private Sub m_cMDITabs_WindowChanged(ByVal hWnd As Long)
'   Dim frm As Form
'   Set frm = formForHwnd(hWnd)
'   Dim bEnable As Boolean
'   If Not frm Is Nothing Then
'      bEnable = (TypeName(frm) = "frmTest")
'   End If
'   mnuFile(2).Enabled = bEnable
'   mnuFile(4).Enabled = bEnable
'   mnuFile(5).Enabled = bEnable
'
'   ' would do 7,8,9,11 here as well
'End Sub

Private Function formForHwnd(ByVal hWnd As Long) As Form
   Dim frmChild As Form
   For Each frmChild In Forms
      If (frmChild.hWnd = hWnd) Then
         Set formForHwnd = frmChild
         Exit For
      End If
   Next
End Function

Private Sub tmUtils_Timer()
  On Error Resume Next
  
  tmUtils.Enabled = False
  
  If m_bTabs Then
    m_bTabs = False
    Sleep 10
    DoEvents
    m_cMDITabs.ForceRefresh
  End If
  
  If m_bUnload Then
    m_bUnload = False
    Unload Me
  End If
End Sub

Private Sub pShowAviso()
#If Not PREPROC_SFS2 Then
  Dim cBar As cExplorerBar
  Dim cItem As cExplorerBarItem
  Dim Position As Long
  
  Position = Val(CSKernelClient.GetRegistry(csInterface, C_ExBarPosition, 4))
  
  If Position = 0 Then
    exbrMain.Visible = False
  Else
    exbrMain.Align = Position
  End If
#End If
End Sub

Private Sub pChangePassword()
  fChangePassword.Show vbModal
End Sub

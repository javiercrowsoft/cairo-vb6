VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Object = "{353A8433-36B8-422E-ABBD-36CEE8BE628E}#1.0#0"; "CSButton.ocx"
Object = "{E3029087-6983-4DF6-A07F-E770EFB12BC0}#1.1#0"; "CSToolBar.ocx"
Begin VB.MDIForm fMain 
   AutoShowChildren=   0   'False
   BackColor       =   &H00FFFFFF&
   Caption         =   "Cairo"
   ClientHeight    =   7440
   ClientLeft      =   165
   ClientTop       =   450
   ClientWidth     =   11295
   Icon            =   "fMain.frx":0000
   LinkTopic       =   "MDIForm1"
   StartUpPosition =   3  'Windows Default
   Begin VB.Timer tmUtils 
      Interval        =   10
      Left            =   5880
      Top             =   5460
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
         FontSize        =   8.25
         Picture         =   "fMain.frx":000C
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
      Left            =   1380
      Top             =   5400
      _ExtentX        =   7117
      _ExtentY        =   873
   End
   Begin VB.PictureBox picInit 
      Align           =   1  'Align Top
      BackColor       =   &H00FFFFFF&
      BorderStyle     =   0  'None
      Height          =   6555
      Left            =   0
      ScaleHeight     =   6555
      ScaleWidth      =   11295
      TabIndex        =   4
      Top             =   885
      Width           =   11295
      Begin MSComctlLib.ProgressBar prgInit 
         Height          =   315
         Left            =   720
         TabIndex        =   6
         Top             =   3540
         Width           =   7035
         _ExtentX        =   12409
         _ExtentY        =   556
         _Version        =   393216
         Appearance      =   1
         Max             =   1
         Scrolling       =   1
      End
      Begin VB.ListBox lsInit 
         Height          =   2205
         Left            =   720
         TabIndex        =   5
         Top             =   1020
         Width           =   7035
      End
      Begin VB.Line Line1 
         BorderColor     =   &H00C0C0C0&
         X1              =   360
         X2              =   8040
         Y1              =   840
         Y2              =   840
      End
      Begin VB.Label Label1 
         BackStyle       =   0  'Transparent
         Caption         =   "Inicializando ..."
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   12
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Left            =   360
         TabIndex        =   7
         Top             =   480
         Width           =   6615
      End
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

' Para Lenguaje
Private m_hMenuFile            As Long
Private m_hMenuFileCompany     As Long
Private m_hMenuFileUser        As Long
Private m_hMenuFilePassword    As Long
Private m_hMenuFileExit        As Long

Private m_ClientChat           As Object

' propiedades publicas
Public Property Get Client() As cTCPIPClient
  Set Client = m_Client
End Property
Public Property Set Client(ByRef rhs As cTCPIPClient)
  Set m_Client = rhs
End Property
' propiedades privadas
' funciones publicas
Public Sub MenuClickBySysmId(ByVal sysm_id As Long)
  On Error Resume Next
'  m_MenuServer.ClickMenuByItemData sysm_id
End Sub

Public Sub RefreshTabs()
  m_bTabs = True
  tmUtils.Enabled = True
End Sub

Public Sub ShowInitProgressDialog()
  Me.picInit.Height = Me.ScaleHeight
  Me.picInit.Visible = True
  DoEvents
End Sub

Public Sub ShowInitProgress(ByVal msg As String, ByVal nIndex As Long, ByVal nCount As Long)
  On Error Resume Next
  
  Me.lsInit.AddItem msg, 0
  Me.prgInit.Value = nIndex / nCount
  DoEvents

End Sub

Public Sub HideInitProgressDialog()
  Me.picInit.Visible = False
  DoEvents
End Sub

' Interfaces

Public Sub SetLenguage()
  
  m_Menu.Caption(m_hMenuFile) = LNGGetText(2450, vbNullString) ' &Archivo
  
  If Not LoginToEmpresa Then
    m_Menu.Caption(m_hMenuFileCompany) = LNGGetText(2451, vbNullString) ' &Cambiar de Empresa
    m_Menu.Caption(m_hMenuFileUser) = LNGGetText(2452, vbNullString) 'Cambiar de &Usuario
  End If

  m_Menu.Caption(m_hMenuFilePassword) = LNGGetText(2453, vbNullString) 'Cambiar Contraseña
  m_Menu.Caption(m_hMenuFileExit) = LNGGetText(2454, vbNullString) '&Salir

End Sub

#If Not PREPROC_NO_MENU_ICON Then
Private Function cIMenuHost_AddIcon(iPicIcon As stdole.Picture) As Long
  On Error Resume Next
  
  cIMenuHost_AddIcon = (ilMenu.ListImages.Add(, , iPicIcon).Index) - 1
  
  If Err.Number <> 0 Then
    cIMenuHost_AddIcon = -1
  Else
    m_Menu.ImageList = ilMenu
  End If
End Function
#End If

' Recibe el click de un menu y crea un
' form Tree de edicion de abm para ese menu
Private Sub cIMenuHost_MenuABMClick(ByVal ObjEdit As String, obj As Object, ByVal NameABM As String, ByVal Buttons As String, ByVal Tabla As Long)
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
  Set o = obj
  
  ' Si no puede editar chau
  If Not o.ShowList Then Exit Sub
  
  ObjfAbm.ObjABMName = "CSABMInterface2.cABMGeneric"
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
  
  If Not pSetTreeEx(ObjfAbm, obj) Then
    Unload ObjfAbm
    If TypeOf Me.ActiveForm Is fDesktop Then
      fDesktop.Hide
      fDesktop.Show
    End If
  Else
    CSKernelClient2.ShowFormWithInit ObjfAbm, NameABM
    RefreshTabs
  End If
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIMenuHost_MenuABMClick", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Function pSetTreeEx(ByRef f As fTree, ByRef obj As Object) As Boolean
  On Error Resume Next
  
  Dim rtn As Boolean
  
  Err.Clear
  
  rtn = obj.SetTree(f.csTree1)
  
  ' Si hay errores no le doy valor al
  ' valor devuelto por SetTree
  '
  If Err.Number Then
    pSetTreeEx = True
  Else
    pSetTreeEx = rtn
  End If
End Function

Private Sub cIMenuHost_MenuListDocClick(ByVal ObjAbm As String, _
                                        ByVal ObjEdit As String, _
                                        ByVal ObjListABM As String, _
                                        ByVal ObjList As String, _
                                        obj As Object, _
                                        ByVal NameABM As String, _
                                        ByVal Buttons As String)
  On Error GoTo ControlError
  
  Dim Mouse As cMouseWait
  Set Mouse = New cMouseWait
  
  Dim ObjListDoc As fListDoc
  
  ' Si el objeto no esta cargado
  If Not ExistsObjectInColl(m_ListDocObj, ObjEdit) Then
    ' Creo uno nuevo
    m_ListDocObj.Add New fListDoc, ObjEdit
  End If
  
  Set ObjListDoc = m_ListDocObj(ObjEdit)
  
  ' Me aseguro que tenga permiso de edicion
  Dim o As cIEditGeneric
  Set o = obj
  
  ' Si no puede editar chau
  If Not o.ShowList Then Exit Sub
  
  Dim AuxParam As String
  
  ObjListDoc.ObjABMName = ObjAbm
  ObjListDoc.ObjEditName = pGetRealObjEditName(ObjEdit, AuxParam)
  ObjListDoc.AuxParam = AuxParam
  ObjListDoc.ObjListABMNombre = ObjListABM
  ObjListDoc.ObjListNombre = ObjList
  
  ' Configuro el form para este abm
  With ObjListDoc
    .NameEdit = NameABM
    .Buttons2 = 0
    If Buttons <> 0 Then
      .Buttons1 = Buttons
    Else
      .Buttons1 = BUTTON_DELETE + BUTTON_SEARCH + BUTTON_EDIT + BUTTON_PRINTOBJ + BUTTON_NEW + BUTTON_EXIT
    End If
  End With
  
  CSKernelClient2.ShowFormWithInit ObjListDoc, NameABM

  RefreshTabs
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIMenuHost_MenuListDocClick", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Function pGetRealObjEditName(ByVal ObjEdit As String, _
                                     ByRef AuxParam As String) As String
  Dim i As Long
  
  i = InStr(1, ObjEdit, "_@aux")
  If i Then
    AuxParam = Mid$(ObjEdit, i + 1)
    ObjEdit = Left$(ObjEdit, i - 1)
  End If
  pGetRealObjEditName = ObjEdit
End Function

Private Sub cIMenuHost_MenuWizardClick(ByVal ClientName As String)
  On Error GoTo ControlError
  
  Dim ObjWizard As cIWizardGeneric
  Set ObjWizard = CSKernelClient2.CreateObject("CSABMInterface2.cWizardGeneric")
  
  ObjWizard.Show ClientName
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIMenuHost_MenuABMClick", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Property Get cIMenuHost_Server() As CSMenu.cMenu
  On Error GoTo ControlError
   
  Set cIMenuHost_Server = m_MenuServer

  GoTo ExitProc
ControlError:
  MngError Err, "cIMenuHost_Server", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Property

Private Sub cmdShowDesktop_Click()
  On Error Resume Next
  fDesktop.Show
  fDesktop.ZOrder
End Sub

' Recibe todos los mensajes enviados por el server TCP-IP
'
Private Sub m_Client_ReciveText(ByVal Buffer As String)
  On Error GoTo ControlError
   
100  Dim IDInstance As Long
110  Dim iModule    As cITCPModule
  
120  If Buffer = "" Then Exit Sub
  
130  IDInstance = TCPGetDllID(Buffer)
  
140  If IDInstance = 0 Then Exit Sub
  
150  If m_CollTCPObjects Is Nothing Then Exit Sub
  
  ' El IDTcp me indica cual es el modulo
  ' encargado de manejar este mensaje
  '
160  Dim IDTcp As Long
170  IDTcp = TCPGetDllProgID(Buffer)
180  If IDTcp = 0 Then Exit Sub
  
     Dim SrvToClientMsg As String
     
     SrvToClientMsg = TCPGetSrvToClientIDMsg(Buffer)
     
     If SrvToClientMsg = "OPEN_CHAT_CLIENT___:" Then

      If m_ClientChat Is Nothing Then
        Set m_ClientChat = CSKernelClient2.CreateObject("CSChatClient.cCSChatClientInit")
      End If
      
      ' Si el cliente de chat falla
      ' libero la referencia
      '
      If Not m_ClientChat.Connect(BdId, _
                                  EmpId, _
                                  User.Name, _
                                  User.Password, _
                                  Val(TCPGetSrvToClientMsgValue(Buffer)), _
                                  TCPGetSrvToClientMsgValueEx(Buffer), _
                                  m_Client.ClientId, _
                                  m_Client.ServerName, _
                                  m_Client.ServerPort) Then
        Set m_ClientChat = Nothing
      End If
     
     Else
     
      SrvToClientMsg = TCPGetSrvToClientMsg(Buffer)
  
    ' Recorro todos los objetos TCP cargados en memoria
    ' para encontrar el destinatario del mensaje
    '
190    For Each iModule In m_CollTCPObjects
200      If (iModule.IDInstance = IDInstance) Or _
            (IDInstance = c_AnyComponentTCP And iModule.ProgId = IDTcp) _
            Then Exit For
210    Next
    
    ' Si no encontre un modulo
    ' instancio un nuevo objeto en memoria
    '
220    If iModule Is Nothing Then
      
230      Dim SysTCP     As CSOAPI2.cSysModuloTCP
      
      ' Instancio un Manejador de modulos
      '
240      Set SysTCP = New CSOAPI2.cSysModuloTCP
250      If Not SysTCP.Load(IDTcp) Then Exit Sub
      
      ' Si no existe un objeto
      ' para administrar este mensaje termine
      '
260      If SysTCP.ObjetoEdicion = "" Then Exit Sub
      
      ' Instancio el objeto
      '
270      Set iModule = CSKernelClient2.CreateObject(SysTCP.ObjetoEdicion)
      
      ' Agrego el objeto a la lista de modulos
      ' cargados en memoria
      '
280      m_CollTCPObjects.Add iModule
290      iModule.IDInstance = m_CollTCPObjects.Count
300    End If
    
310    If iModule Is Nothing Then Exit Sub
    
    ' Proceso el mensaje
    '
320    iModule.ProcessMessage SrvToClientMsg
    End If
  
  GoTo ExitProc
ControlError:
  MngError Err, "m_Client_ReciveText", C_Module, Erl
  
  Set m_ClientChat = Nothing
  
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub MDIForm_QueryUnload(Cancel As Integer, UnloadMode As Integer)
  On Error GoTo ControlError

  Cancel = Not CSABMInterface2.CloseDll()

  GoTo ExitProc
ControlError:
  MngError Err, "MDIForm_QueryUnload", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub MDIForm_Resize()
  On Error GoTo ControlError
   
  picBar_Resize

  GoTo ExitProc
ControlError:
  MngError Err, "MDIForm_Resize", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

' funciones privadas
Private Sub mnuAbout_Click()
  On Error GoTo ControlError
   
  fSplash.IsSplash = False
  fSplash.Show vbModal

  GoTo ExitProc
ControlError:
  MngError Err, "mnuAbout_Click", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub mnuAyudaIndex_Click()
  On Error Resume Next
  
#If PREPROC_QBPOINT Then

  CSKernelClient2.EditFile CSKernelClient2.GetValidPath(App.Path) & "qbonix.chm", Me.hWnd
  
#Else

  CSKernelClient2.EditFile CSKernelClient2.GetValidPath(App.Path) & "cairo.chm", Me.hWnd
  
#End If

End Sub

Private Sub mnuChangeCompany_Click()
  On Error GoTo ControlError

  Dim ConnectString As String
  Dim UserName      As String
  Dim db_id         As Long
  Dim emp_id        As Long
  Dim Password      As String
  Dim Client        As cTCPIPClient
  
  Set Client = New cTCPIPClient

  If LoginToCompany(ConnectString, UserName, Client, db_id, emp_id, Password, True) Then
  
    Client.TerminateSession
    Set Client = Nothing
  
    Dim cmdLine As String
    cmdLine = GetValidPath(App.Path) & App.EXEName & ".exe " & _
              GetStartupLine(UserName, Password, db_id, emp_id)
              
    Shell cmdLine
  
    mnuExit_Click
  End If

  GoTo ExitProc
ControlError:
  MngError Err, "mnuChangeCompany_Click", C_Module, ""
  If Err.Number Then Resume ExitProc
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
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Public Sub mnuUsuarioPermiso_Click()
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
  CSKernelClient2.ShowFormWithInit fPermisosUsuarios, fPermisosUsuarios.Name

  GoTo ExitProc
ControlError:
  MngError Err, "mnuUsuarioPermiso_Click", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Public Sub mnuRolPermiso_Click()
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
  CSKernelClient2.ShowFormWithInit fPermisosRoles, fPermisosRoles.Name

  GoTo ExitProc
ControlError:
  MngError Err, "mnuRolPermiso_Click", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

' construccion - destruccion
Private Sub MDIForm_Load()
  On Error GoTo ControlError
   
  Me.picInit.Visible = False

#If PREPROC_QBPOINT Then
  Me.Caption = "QBOnix"
#End If

  Set m_EditObj = New Collection
  Set m_ListDocObj = New Collection
  Set m_MenuServer = New cMenu
  
  pCreateMenu
  m_MenuServer.Initialize Me.hWnd, m_Menu
  CSKernelClient2.LoadForm Me, "MAIN"

  Set m_cMDITabs = New cMDITabs
  m_cMDITabs.Attach Me.hWnd

  Set m_CollTCPObjects = New Collection

#If Not PREPROC_NO_EXBAR Then
  pShowAviso
#End If

  GoTo ExitProc
ControlError:
  MngError Err, "MDIForm_Load", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub MDIForm_Unload(Cancel As Integer)
  On Error GoTo ControlError
   
  Set m_ClientChat = Nothing
  Set m_Menu = Nothing
  Set m_MenuServer = Nothing
  
  CollClear m_EditObj
  CollClear m_ListDocObj
  CollClear m_CollTCPObjects
  
  Set m_EditObj = Nothing
  Set m_ListDocObj = Nothing
  Set m_CollTCPObjects = Nothing

  Set m_tbhMenu = Nothing
  Set m_cMDITabs = Nothing
  
  CSKernelClient2.UnloadForm Me, "MAIN"
  CloseApp

  GoTo ExitProc
ControlError:
  MngError Err, "MDIForm_Unload", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub picBar_Paint()
  On Error Resume Next
  RefreshTabs
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
    Case "K8" 'mnuUsuarioPermiso
      mnuUsuarioPermiso_Click
    Case "K-8" 'mnuRolPermiso
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
      
#If Not PREPROC_NO_EXBAR Then
    Case "mnuAvisosOcultar"
      exbrMain.Visible = False
      ' Explorer Bar Position
      CSKernelClient2.SetRegistry csInterface, C_ExBarPosition, 0
    Case "mnuAvisosDerecha"
      exbrMain.Align = 4
      exbrMain.Visible = True
      ' Explorer Bar Position
      CSKernelClient2.SetRegistry csInterface, C_ExBarPosition, 4
    Case "mnuAvisosIzquierda"
      exbrMain.Align = 3
      exbrMain.Visible = True
      ' Explorer Bar Position
      CSKernelClient2.SetRegistry csInterface, C_ExBarPosition, 3
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
    
    #If Not PREPROC_NO_MENU_ICON Then
      .ImageList = ilMenu
    #End If
    
    ' File menu:
    iP = .AddItem("&Archivo", , , iPTop, , , , "mnuArchivo")
      m_hMenuFile = iP
      
      If Not LoginToEmpresa Then
        m_hMenuFileCompany = .AddItem("&Cambiar de Empresa", , , iP, , , , "mnuChangeCompany")
        m_hMenuFileUser = .AddItem("Cambiar de &Usuario", , , iP, , , , "mnuChangeUser")
        .AddItem "-", , , iP, , , , "mnuFileSep1"
      End If
      
      m_hMenuFilePassword = .AddItem("Cambiar Contraseña", , , iP, , , , "mnuChangePassword")
      .AddItem "-", , , iP, , , , "mnuFileSep2"
      m_hMenuFileExit = .AddItem("&Salir", , , iP, , , , "mnuExit")
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
'    ' Ventana
'                      '"&Ventana"
'    iP = .AddItem(LNGGetText(2461, vbNullString), , , iPTop, , , , "mnuVentana")
'                      '"&Cascada"
'      .AddItem LNGGetText(2462, vbNullString), , , iP, , , , "mnuCascada"
'                      '"Mosaico Horizontal"
'      .AddItem LNGGetText(2463, vbNullString), , , iP, , , , "mnuMosaicoHorizontal"
'                      '"&Mosaico Vertical"
'      .AddItem LNGGetText(2464, vbNullString), , , iP, , , , "mnuMosaicoVertical"
'                      '"&Organizar Ventanas"
'      .AddItem LNGGetText(2465, vbNullString), , , iP, , , , "mnuOrganizarVentanas"
'                      '"Barra de Avisos"
'      iP = .AddItem(LNGGetText(2466, vbNullString), , , iP, , , , "mnuAvisos")
'                      '"Ocultar"
'        .AddItem LNGGetText(2467, vbNullString), , , iP, , , , "mnuAvisosOcultar"
'                      '"Ver a la derecha"
'        .AddItem LNGGetText(2468, vbNullString), , , iP, , , , "mnuAvisosDerecha"
'                      '"Ver a la izquierda"
'        .AddItem LNGGetText(2469, vbNullString), , , iP, , , , "mnuAvisosIzquierda"
    ' Ayuda
                      '"A&yuda"
    iP = .AddItem(LNGGetText(2470, vbNullString), , , iPTop, , , , "mnuAyuda")
                      '"&Indice..."
      .AddItem LNGGetText(2471, vbNullString), , , iP, , , , "mnuAyudaIndex"
      
      
#If PREPROC_QBPOINT Then
                      
                      '"Acerca de QBOnix"
      .AddItem LNGGetText(3934, vbNullString), , , iP, , , , "mnuAbout"

#Else

                      '"Acerca de Cairo"
      .AddItem LNGGetText(2472, vbNullString), , , iP, , , , "mnuAbout"

#End If

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
  Dim i As Integer
  For i = 0 To Me.Controls.Count - 1
    If Me.Controls(i).Name = ctlName Then
      Me.Controls.Remove ctlName
    End If
  Next
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

Public Function ShowChatClient() As Boolean
  On Error GoTo ControlError
  
  If m_ClientChat Is Nothing Then
    Set m_ClientChat = CSKernelClient2.CreateObject("CSChatClient.cCSChatClientInit")
  End If
  
  If Not m_ClientChat.IsConnected Then
  
    ' Si el cliente de chat falla
    ' libero la referencia
    '
    If Not m_ClientChat.Connect(BdId, _
                                EmpId, _
                                User.Name, _
                                User.Password, _
                                0, _
                                vbNullString, _
                                m_Client.ClientId, _
                                m_Client.ServerName, _
                                m_Client.ServerPort) Then
      Set m_ClientChat = Nothing
      Exit Function
    End If

  End If
  
  ShowChatClient = True

  GoTo ExitProc
ControlError:
  MngError Err, "ShowChatClient", C_Module, ""
  
  Set m_ClientChat = Nothing
  
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
  
End Function
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
  
  If Not m_cMDITabs Is Nothing Then
    If m_bTabs Then
      m_bTabs = False
      Sleep 10
      DoEvents
      m_cMDITabs.ForceRefresh
    End If
  End If
  
  If m_bUnload Then
    m_bUnload = False
    Unload Me
  End If
End Sub

#If Not PREPROC_NO_EXBAR Then
Private Sub pShowAviso()
  Dim cBar As cExplorerBar
  Dim cItem As cExplorerBarItem
  Dim Position As Long
  
  Position = Val(CSKernelClient2.GetRegistry(csInterface, C_ExBarPosition, 4))
  
  If Position = 0 Then
    exbrMain.Visible = False
  Else
    exbrMain.Align = Position
  End If
End Sub
#End If

Private Sub pChangePassword()
  fChangePassword.Show vbModal
End Sub

#If PREPROC_DEBUG Then
Private Sub MDIForm_Initialize()
  gdbInitInstance C_Module
End Sub

Private Sub MDIForm_Terminate()
  gdbTerminateInstance C_Module
End Sub
#End If


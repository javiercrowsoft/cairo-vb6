VERSION 5.00
Object = "{5E9E78A0-531B-11CF-91F6-C2863C385E30}#1.0#0"; "msflxgrd.ocx"
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Begin VB.Form fUsuarios 
   Caption         =   "Usuarios"
   ClientHeight    =   5550
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   7620
   Icon            =   "fUsuarios.frx":0000
   LinkTopic       =   "Form1"
   MDIChild        =   -1  'True
   ScaleHeight     =   5550
   ScaleWidth      =   7620
   Begin MSComctlLib.Toolbar TBBarra 
      Align           =   1  'Align Top
      Height          =   645
      Left            =   0
      TabIndex        =   1
      Top             =   0
      Width           =   7620
      _ExtentX        =   13441
      _ExtentY        =   1138
      ButtonWidth     =   609
      ButtonHeight    =   979
      Appearance      =   1
      _Version        =   393216
   End
   Begin MSFlexGridLib.MSFlexGrid GrUsuario 
      Height          =   2535
      Left            =   45
      TabIndex        =   0
      Top             =   675
      Width           =   4605
      _ExtentX        =   8123
      _ExtentY        =   4471
      _Version        =   393216
      GridColor       =   -2147483643
      GridColorFixed  =   -2147483643
      AllowBigSelection=   0   'False
      FocusRect       =   2
      SelectionMode   =   1
   End
End
Attribute VB_Name = "fUsuarios"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
'--------------------------------------------------------------------------------
' fUsuarios
' 13-02-00

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
' estructuras
' variables privadas
Private m_cargado As Boolean
Private m_grilla  As CSOAPI.cGrilla
Private m_usuario As CSOAPI.cUser
' propiedades publicas
' propiedades privadas
' funciones publicas
Public Function Init() As Boolean
    Dim rs As cregistros
    
    If m_cargado Then GoTo Listo
    
    If Not CSOAPI.Usuario.GetUsuarios(rs) Then Exit Function
    
    Set m_grilla = New cGrilla
    Set m_grilla.Grilla = GrUsuario
    m_grilla.SetPropertys
    If Not m_grilla.LoadFromRecordSet(rs) Then GoTo ExitProc
    
    m_grilla.GetColumnWidth "USUARIO"
    
    Set m_usuario = New CSOAPI.cUser
Listo:
    m_cargado = True
    Init = True
ExitProc:
    On Error Resume Next
    rs.cerrar
    Set rs = Nothing
End Function
' funciones privadas
Private Sub Form_Resize()
    If WindowState = vbMinimized Then Exit Sub
    GrUsuario.Top = TBBarra.Height
    GrUsuario.Width = ScaleWidth
    GrUsuario.Height = ScaleHeight - GrUsuario.Top
End Sub

Private Sub GrUsuario_DblClick()
    Editar
End Sub

Private Sub GrUsuario_KeyPress(KeyAscii As Integer)
    If KeyAscii = vbKeyReturn Then Editar
End Sub

Private Sub TBBarra_ButtonClick(ByVal Button As MSComctlLib.Button)
    CSOAPI.PresButtonToolbar Button.Key, Me
End Sub
Public Function Editar() As Boolean
    Dim rs As cregistros
    GrUsuario.Col = 0
    If Not m_usuario.Edit(GrUsuario.Text) Then Exit Function
    If Not m_usuario.GetUsuarioForLine(rs, GrUsuario.Text) Then Exit Function
    Set m_grilla.Grilla = GrUsuario
    If Not m_grilla.SetLineFromRecordSet(rs, (GrUsuario.Text)) Then Exit Function
    Editar = True
End Function
Public Function Borrar() As Boolean

End Function
Public Function Imprimir() As Boolean

End Function
Public Function Desactivar() As Boolean

End Function
Public Function VistaPreliminar() As Boolean

End Function
Public Function Buscar() As Boolean

End Function
Public Function Nuevo() As Boolean
    If Not m_usuario.Nuevo() Then Exit Function
    m_cargado = False
    Init
End Function
Public Function salir()
    Unload Me
End Function
' construccion - destruccion
Private Sub Form_Load()
    CSOAPI.SetToolBar TBBarra, BOTON_DESACTIVAR + BOTON_BORRAR + BOTON_BUSCAR + BOTON_EDITAR + BOTON_IMPRIMIR + BOTON_NUEVO + BOTON_VISTA_PRELIMINAR + BOTON_SALIR

    ' sizing
    GrUsuario.Left = 0
End Sub

Private Sub Form_Unload(Cancel As Integer)
    m_cargado = False

    CSKernelClient.UnloadForm Me, "USUARIO"

    m_grilla.SaveColumnWidth "USUARIO"
    Set m_grilla = Nothing
    Set m_usuario = Nothing
End Sub



VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Begin VB.Form fUsuario 
   Appearance      =   0  'Flat
   BackColor       =   &H80000005&
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Usuario"
   ClientHeight    =   2520
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   4890
   FillColor       =   &H00FFFFFF&
   ForeColor       =   &H00FFFFFF&
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2520
   ScaleWidth      =   4890
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox TxConfirmacion 
      Appearance      =   0  'Flat
      Height          =   285
      IMEMode         =   3  'DISABLE
      Left            =   2295
      PasswordChar    =   "*"
      TabIndex        =   7
      Top             =   2115
      Width           =   1815
   End
   Begin VB.TextBox TxClave 
      Appearance      =   0  'Flat
      Height          =   285
      IMEMode         =   3  'DISABLE
      Left            =   2295
      PasswordChar    =   "*"
      TabIndex        =   5
      Top             =   1665
      Width           =   1815
   End
   Begin MSComctlLib.Toolbar TBBarra 
      Align           =   1  'Align Top
      Height          =   630
      Left            =   0
      TabIndex        =   8
      Top             =   0
      Width           =   4890
      _ExtentX        =   8625
      _ExtentY        =   1111
      ButtonWidth     =   609
      ButtonHeight    =   953
      Appearance      =   1
      _Version        =   393216
   End
   Begin VB.CheckBox ChkActivo 
      BackColor       =   &H80000005&
      Height          =   195
      Left            =   2295
      TabIndex        =   3
      Top             =   1260
      Width           =   1770
   End
   Begin VB.TextBox TxNombre 
      Appearance      =   0  'Flat
      Height          =   285
      Left            =   2295
      TabIndex        =   1
      Top             =   765
      Width           =   1815
   End
   Begin VB.Label Label4 
      BackStyle       =   0  'Transparent
      Caption         =   "C&onfirmación:"
      Height          =   240
      Left            =   1035
      TabIndex        =   6
      Top             =   2160
      Width           =   960
   End
   Begin VB.Label Label3 
      BackStyle       =   0  'Transparent
      Caption         =   "&Clave:"
      Height          =   240
      Left            =   1035
      TabIndex        =   4
      Top             =   1710
      Width           =   735
   End
   Begin VB.Image Image1 
      Height          =   480
      Left            =   180
      Picture         =   "fUsuario.frx":0000
      Top             =   765
      Width           =   480
   End
   Begin VB.Label Label2 
      BackStyle       =   0  'Transparent
      Caption         =   "&Activo:"
      Height          =   240
      Left            =   1035
      TabIndex        =   2
      Top             =   1260
      Width           =   735
   End
   Begin VB.Label Label1 
      BackStyle       =   0  'Transparent
      Caption         =   "&Nombre:"
      Height          =   240
      Left            =   1035
      TabIndex        =   0
      Top             =   810
      Width           =   735
   End
End
Attribute VB_Name = "fUsuario"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' fUsuario
' 16-02-00

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
Private m_User As cUser
' propiedades publicas
Public Property Set Usuario(ByRef rhs As cUser)
    Set m_User = rhs
End Property
' propiedades privadas
' funciones publicas
Public Function Salir()
    Unload Me
End Function
Public Function Roles()
    
End Function
Public Function Guardar() As Boolean
    Dim registro As cRegister
    
    If Not m_User.Validate(Me) Then Exit Function
    
    Set registro = New cRegister
    
    If m_User.Collectdata(registro, Me) Then
        G_FormResult = m_User.Save(registro)
        If G_FormResult Then
            If m_User.GetUsuario(registro.ID) Then
                m_User.ShowData Me
            End If
        End If
    End If
    
    Set registro = Nothing
End Function
' funciones privadas
Private Sub TBBarra_ButtonClick(ByVal Button As MSComctlLib.Button)
    PresButtonToolbar_ Button.Key, Me
End Sub

' construccion - destruccion
Private Sub Form_Load()
    SetToolBar_ TBBarra, BOTON_BORRAR + BOTON_IMPRIMIR + BOTON_VISTA_PRELIMINAR + BOTON_SALIR + BOTON_ROLES + BOTON_GUARDAR
End Sub

Private Sub Form_Unload(Cancel As Integer)
    CSKernelClient.UnloadForm Me, "EDIT_USUARIO"
    On Error Resume Next
    Set m_User = Nothing
End Sub


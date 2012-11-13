VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cLogin"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cLogin
' 10-01-00

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
Private m_DB        As cDataBase
Private m_User      As cUser
' propiedades publicas
Public Property Get DB() As cDataBase
    Set DB = m_DB
End Property
Public Property Get user() As cUser
    Set user = m_User
End Property
' propiedades privadas
' funciones publicas
Public Function Login(ByVal AppNombre As String) As Boolean
    Load fLogin
    fLogin.Init AppNombre
    Set fLogin.DB = m_DB
    fLogin.Show vbModal
    If Not G_FormResult Then Exit Function
    If Not fLogin.Ok Then
        Unload fLogin
        Exit Function
    End If
    Set m_User = fLogin.user
    Set gUser = fLogin.user
    Set gDB = m_DB
    Unload fLogin
    gAppName = AppNombre
    Login = True
End Function
' funciones privadas
' construccion - destruccion
Private Sub Class_Initialize()
    Set m_DB = New cDataBase
End Sub

Private Sub Class_Terminate()
    Set m_DB = Nothing
End Sub



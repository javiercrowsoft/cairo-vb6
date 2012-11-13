VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cIConfig"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cIConfig
' 04-06-00

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
' propiedades publicas
Public Property Get User() As String
End Property
Public Property Let User(ByVal rhs As String)
End Property
Public Property Get Password() As String
End Property
Public Property Let Password(ByVal rhs As String)
End Property
Public Property Get Computer() As String
End Property
Public Property Let Computer(ByVal rhs As String)
End Property
Public Property Get SesionId() As Long
End Property
Public Property Let SesionId(ByVal rhs As Long)
End Property
Public Property Get ConectString() As String
End Property
Public Property Let ConectString(ByVal rhs As String)
End Property
Public Property Get TableIsLoaded() As Boolean
End Property
Public Property Let TableIsLoaded(ByVal rhs As Boolean)
End Property
Public Property Get TableSecurity() As cITableSecurity
End Property
Public Property Let TableSecurity(ByVal rhs As cITableSecurity)
End Property
Public Property Get ErrorMsg() As String
End Property
Public Property Let ErrorMsg(ByVal rhs As String)
End Property
Public Property Get Logins() As CSInterfaces.cICollClients
End Property
Public Property Get StartConection() As Date
End Property
Public Property Let StartConection(ByVal rhs As Date)
End Property
Public Property Get UserId() As Long
End Property
Public Property Let UserId(ByVal rhs As Long)
End Property

' propiedades privadas
' funciones publicas
Public Sub LoadLogins()
End Sub
' funciones privadas
' construccion - destruccion



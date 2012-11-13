VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cSecurity"
Attribute VB_GlobalNameSpace = True
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

' Implemento la interfaz Modulo TCP para recibir
' mensajes del server
'
Implements CSITCPModule.cITCPModule
'--------------------------------------------------------------------------------
' cSecurity
' 11-07-00

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
Private m_IDInstance      As Long
' Properties publicas
Public Property Get SecurityShowMessages() As Boolean
  SecurityShowMessages = gSecurity.ShowMessages
End Property
Public Property Let SecurityShowMessages(ByVal rhs As Boolean)
  gSecurity.ShowMessages = rhs
End Property
' Properties privadas
' funciones publicas
Private Property Let cITCPModule_IDInstance(ByVal rhs As Long)
  m_IDInstance = rhs
End Property

Private Property Get cITCPModule_IDInstance() As Long
  cITCPModule_IDInstance = m_IDInstance
End Property

Private Function cITCPModule_ProcessMessage(ByVal Message As String) As Boolean
  Select Case Message
    Case c_REFRESH_SECURITY
      cITCPModule_ProcessMessage = Refresh
    Case c_REFRESH_LOGINON
      pRefresLoginOn
  End Select
End Function

Public Function SecurityCanAccess(ByVal PRE_ID As Long) As Boolean
  SecurityCanAccess = gSecurity.CanAccess(PRE_ID)
End Function

Public Function SecurityCanAccessSilent(ByVal PRE_ID As Long) As Boolean
  SecurityCanAccessSilent = gSecurity.CanAccessSilent(PRE_ID)
End Function

Public Function SecurityAdd(ByVal PRE_ID As Long, ByVal Name As String, ByVal Group As String) As Boolean
  SecurityAdd = gSecurity.Add2(PRE_ID, Name, Group)
End Function

Public Function Refresh() As Boolean
  Refresh = gSecurity.Refresh()
End Function
' funciones privadas
Private Function pRefresLoginOn()
  Dim Buffer    As String
  
  Buffer = TCPGetMessage(cTCPCommandSetClientActive, gTCPClient.ClientId)
  If Not gTCPClient.SendAndReciveText(Buffer, SRV_ID_SERVER) Then Exit Function
  
  If TCPError(gTCPClient.DataReceived) Then
  
    ' Si falla al validar que no moleste no es importante
    '
  
    ' MsgError LNGGetText(3448, vbNullString, TCPGetResponse(gTCPClient.DataReceived))
              'Ha ocurrido un error al verificar sus credenciales de usuario.;; _
              Descripción técnica:  & TCPGetResponse(gTCPClient.DataReceived)
    Exit Function
  End If
  
  Buffer = TCPGetResponse(gTCPClient.DataReceived)
  
  If TCPGetFail(gTCPClient.DataReceived) Then
    MsgError Buffer
    Exit Function
  End If
  
  pRefresLoginOn = True
End Function

' construccion - destruccion
Private Property Get cITCPModule_ProgID() As Long
  cITCPModule_ProgID = csSecPermisos
End Property

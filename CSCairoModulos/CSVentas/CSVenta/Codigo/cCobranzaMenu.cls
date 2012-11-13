VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cCobranzaMenu"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSMenu.cIMenuClient
'--------------------------------------------------------------------------------
' cFacturaVenta
' 27-01-2004

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cCobranzaMenu"

' estructuras
' variables privadas
Private m_cobranzaCdo       As cCobranzaContado

Private m_Host              As CSMenu.cIMenuHost
' eventos
' propiedades publicas
' propiedades friend
' propiedades privadas
' funciones publicas
' funciones friend
' funciones privadas
' construccion - destruccion

Private Function cIMenuClient_Initialize(f As Object, Host As CSMenu.cIMenuHost) As Boolean
  On Error GoTo ControlError
  
  Dim str_1589 As String
    
  str_1589 = LNGGetText(1589, vbNullString) '&Ventas
  
  Set m_Host = Host
  
  m_Host.Server.AddMenu str_1589, csMenuEnum.csMenuVentas, vbNullString, 1, False, False, False, True, False, Nothing
  
  m_Host.Server.AddMenu LNGGetText(5111, vbNullString), csPreVtaCobranzasCajero, str_1589, 0, True, False, False, False, False, Me
                          'Caja &Cobranzas
  cIMenuClient_Initialize = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIMenuClient_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal id As Long) As Variant
  If m_cobranzaCdo Is Nothing Then
    Set m_cobranzaCdo = New cCobranzaContado
    m_cobranzaCdo.ShowCobranzaCajero
  ElseIf m_cobranzaCdo.wasClosed Then
    Set m_cobranzaCdo = New cCobranzaContado
    m_cobranzaCdo.ShowCobranzaCajero
  Else
    m_cobranzaCdo.ShowWindow
  End If
End Function


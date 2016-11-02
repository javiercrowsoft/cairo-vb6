Option Strict Off
Option Explicit On

Imports System
Imports System.Collections.Generic
Imports System.Text
Imports System.Xml
Imports System.Net
Imports System.Security
Imports System.Security.Cryptography
Imports System.Security.Cryptography.Pkcs
Imports System.Security.Cryptography.X509Certificates
Imports System.IO
Imports CSLog

Public Class cFEWSAA

  Private Const c_module As String = "cFEWSAA"

  Private m_expirationTime As DateTime
  Private m_token As String
  Private m_sign As String

  Public ReadOnly Property expirationTime() As String
    Get
      Return m_expirationTime
    End Get
  End Property

  Public ReadOnly Property token() As String
    Get
      Return m_token
    End Get
  End Property

  Public ReadOnly Property sign() As String
    Get
      Return m_sign
    End Get
  End Property

  Public Function getTA( _
                        ByVal strUrlWsaaWsdl As String, _
                        ByVal strIdServicioNegocio As String, _
                        ByVal strRutaCertSigner As String, _
                        ByVal strProxy As String, _
                        ByVal strProxyUser As String, _
                        ByVal strProxyPassword As String, _
                        ByVal blnVerboseMode As Boolean _
                        ) As String

    Dim strPasswordSecureString As New SecureString

    Dim objTicketRespuesta As cLoginTicket
    Dim strTicketRespuesta As String

    Try

      If blnVerboseMode Then
        cLog.write("***Servicio a acceder: " & strIdServicioNegocio, "getTA", c_module)
        cLog.write("***URL del WSAA: " & strUrlWsaaWsdl, "getTA", c_module)
        cLog.write("***Ruta del certificado: " & strRutaCertSigner, "getTA", c_module)
        cLog.write("***Modo verbose: " & blnVerboseMode, "getTA", c_module)
      End If

      objTicketRespuesta = New cLoginTicket

      If blnVerboseMode Then
        cLog.write("***Accediendo a " & strUrlWsaaWsdl, "getTA", c_module)
      End If

      strTicketRespuesta = objTicketRespuesta.ObtenerLoginTicketResponse(strIdServicioNegocio, strUrlWsaaWsdl, strRutaCertSigner, strPasswordSecureString, strProxy, strProxyUser, strProxyPassword, blnVerboseMode)

      m_expirationTime = objTicketRespuesta.ExpirationTime

      m_token = objTicketRespuesta.Token
      m_sign = objTicketRespuesta.Sign

      If blnVerboseMode Then
        cLog.write("   Token: " & objTicketRespuesta.Token & vbCrLf & _
                      "   Sign: " & objTicketRespuesta.Sign & vbCrLf & _
                      "   GenerationTime: " & CStr(objTicketRespuesta.GenerationTime) & vbCrLf & _
                      "   ExpirationTime: " & CStr(objTicketRespuesta.ExpirationTime) & vbCrLf & _
                      "   Service: " & objTicketRespuesta.Service & vbCrLf & _
                      "   UniqueID: " & CStr(objTicketRespuesta.UniqueId) & vbCrLf, _
                   "getTA ***CONTENIDO DEL TICKET RESPUESTA:", c_module)
      End If

    Catch excepcionAlObtenerTicket As Exception

      cLog.write(excepcionAlObtenerTicket.Message, "getTA ***EXCEPCION AL OBTENER TICKET:", c_module)
      Throw New Exception("***Error ANALIZANDO el LoginTicketResponse : " + excepcionAlObtenerTicket.Message)

    End Try

    Return strTicketRespuesta

  End Function

End Class

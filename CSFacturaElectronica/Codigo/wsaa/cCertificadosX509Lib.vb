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

Public Class cCertificadosX509Lib

  Private Const c_module As String = "cCertificadosX509Lib"

  Public Shared VerboseMode As Boolean = False

  ''' <summary>
  ''' Firma mensaje
  ''' </summary>
  ''' <param name="argBytesMsg">Bytes del mensaje</param>
  ''' <param name="argCertFirmante">Certificado usado para firmar</param>
  ''' <returns>Bytes del mensaje firmado</returns>
  ''' <remarks></remarks>
  Public Shared Function FirmaBytesMensaje( _
                                            ByVal argBytesMsg As Byte(), _
                                            ByVal argCertFirmante As X509Certificate2 _
                                            ) As Byte()
    Try
      ' Pongo el mensaje en un objeto ContentInfo (requerido para construir el obj SignedCms)
      Dim infoContenido As New ContentInfo(argBytesMsg)
      Dim cmsFirmado As New SignedCms(infoContenido)

      ' Creo objeto CmsSigner que tiene las caracteristicas del firmante
      Dim cmsFirmante As New CmsSigner(argCertFirmante)
      cmsFirmante.IncludeOption = X509IncludeOption.EndCertOnly

      If VerboseMode Then
        cLog.write("***Firmando bytes del mensaje...", "FirmaBytesMensaje", c_module)
      End If
      ' Firmo el mensaje PKCS #7
      cmsFirmado.ComputeSignature(cmsFirmante)

      If VerboseMode Then
        cLog.write("***OK mensaje firmado", "FirmaBytesMensaje", c_module)
      End If

      ' Encodeo el mensaje PKCS #7.
      Return cmsFirmado.Encode()
    Catch excepcionAlFirmar As Exception
      Throw New Exception("***Error al firmar: " & excepcionAlFirmar.Message)
      Return Nothing
    End Try
  End Function

  ''' <summary>
  ''' Lee certificado de disco
  ''' </summary>
  ''' <param name="argArchivo">Ruta del certificado a leer.</param>
  ''' <returns>Un objeto certificado X509</returns>
  ''' <remarks></remarks>
  Public Shared Function ObtieneCertificadoDesdeArchivo( _
                                                        ByVal argArchivo As String, _
                                                        ByVal argPassword As SecureString _
                                                        ) As X509Certificate2
    Dim objCert As New X509Certificate2
    Try
      If argPassword.IsReadOnly Then
        objCert.Import(My.Computer.FileSystem.ReadAllBytes(argArchivo), argPassword, X509KeyStorageFlags.PersistKeySet)
      Else
        objCert.Import(My.Computer.FileSystem.ReadAllBytes(argArchivo))
      End If
      Return objCert
    Catch excepcionAlImportarCertificado As Exception
      Throw New Exception(excepcionAlImportarCertificado.Message & " " & excepcionAlImportarCertificado.StackTrace)
      Return Nothing
    End Try
  End Function

End Class

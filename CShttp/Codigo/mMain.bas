Attribute VB_Name = "mMain"
Option Explicit

Private m_logFile        As String

Sub Main()
  On Error GoTo ControlError
  
  Dim url         As String
  Dim format      As Integer
  Dim logfile     As String
  Dim file        As String
  Dim port        As String
  Dim proxy       As String
  Dim protocol    As Integer
  
  m_logFile = pGetPath(App.path) & "csdownload.log"
  
  pSaveLog "Parametros: " & Command$()
  
  If Not pGetParams(url, format, port, proxy, protocol, file, logfile) Then
    pSaveLog "Los parametros no son validos"
    Exit Sub
  End If
  
  pSaveLog "Parametros: " & Command$()
  
  If logfile <> "" Then m_logFile = logfile

  pSaveLog "Creando objeto cDownLoad"
  
  Dim dload As cDownLoad
  Set dload = New cDownLoad
  
  pSaveLog "Objeto cDownLoad creado con exito"
  
  dload.ProxyAddress = proxy
  dload.RemotePort = port
  dload.DataType = format
  dload.protocol = protocol
  
  pSaveLog "Llamando a dload con:"
  pSaveLog "url: " & url
  pSaveLog "file: " & file
  
  dload.dload url, file
  
  pSaveLog "dload.Status: " & dload.Status
  pSaveLog "error: " & dload.ErrorDescrip
  
  Exit Sub
ControlError:
  pSaveLog Err.Number & " - " & Err.Description & " - " & Err.Source
End Sub

Private Function pGetParams(ByRef url As String, _
                            ByRef format As Integer, _
                            ByRef port As String, _
                            ByRef proxy As String, _
                            ByRef protocol As Integer, _
                            ByRef file As String, _
                            ByRef logfile As String) As Boolean
  Dim params    As String
  Dim vParams() As String
  
  params = Command$()
  vParams = Split(params, " ")
                        
  url = pGetParam(vParams, "-U")
  format = pGetParam(vParams, "-F")
  port = pGetParam(vParams, "-P")
  proxy = pGetParam(vParams, "-X")
  protocol = pGetParam(vParams, "-T")
  file = pGetParam(vParams, "-f")
  logfile = pGetParam(vParams, "-l")
                        
  pGetParams = True
End Function

Private Function pGetParam(ByRef vParams() As String, ByVal paramName As String) As String
  Dim rtn As String
  Dim i   As Integer
  
  For i = 0 To UBound(vParams)
    If vParams(i) = paramName Then
    
      If Not isParam(vParams(i + 1)) Then
        rtn = vParams(i + 1)
      End If
      Exit For
    End If
  Next
  pGetParam = rtn
End Function

Private Function pGetPath(ByVal path As String) As String
  If Right(path, 1) <> "\" Then path = path & "\"
  pGetPath = path
End Function

Private Function isParam(ByVal value As String) As Boolean
  isParam = InStr(1, "-U -P -X -T -F -f -l", value)
End Function

Private Sub pSaveLog(ByVal msg As String)
  On Error Resume Next
  Dim f As Integer
  f = FreeFile
  Open m_logFile For Append As f
  Print #f, Now & " " & msg
  Close f
End Sub


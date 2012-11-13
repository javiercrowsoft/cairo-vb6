Attribute VB_Name = "mUploadFile"
Option Explicit

'******************* upload - begin
'Upload file using input type=file

'read binary file As a string value
Function GetFile(FileName As String) As String
  Dim FileContents() As Byte, FileNumber As Integer
  ReDim FileContents(FileLen(FileName) - 1)
  FileNumber = FreeFile
  Open FileName For Binary As FileNumber
    Get FileNumber, , FileContents
  Close FileNumber
  GetFile = StrConv(FileContents, vbUnicode)
End Function
'******************* upload - end

'---------------------------------------------------------------------------------
Function UploadXML(ByVal DestURL As String, _
                   ByVal strFileName As String, _
                   Optional strUserName As String, _
                   Optional strPassword As String) As String
    Const HTTPREQUEST_SETCREDENTIALS_FOR_SERVER = 0
    Const HTTPREQUEST_SETCREDENTIALS_FOR_PROXY = 1
    
    Dim WinHttpReq As WinHttp.WinHttpRequest
    Dim strBody As String
    Dim strFile As String
    Dim aPostBody() As Byte
    
    Dim bound As String
    Dim boundSeparator As String
    Dim boundFooter As String
    
    bound = "AaB03x"
    boundSeparator = "--" & bound & vbCrLf
    boundFooter = "--" & bound & "--" & vbCrLf
    
    Set WinHttpReq = New WinHttpRequest
    WinHttpReq.Open "POST", DestURL, False
    'If strUserName <> "" And strPassword <> "" Then
    '    WinHttpReq.SetCredentials strUserName, strPassword, HTTPREQUEST_SETCREDENTIALS_FOR_SERVER
    'End If
    
    WinHttpReq.setRequestHeader "Content-Type", "multipart/form-data; boundary=" & bound
    strBody = boundSeparator

    strBody = strBody & "Content-Disposition: form-data; name=""" & "user" & """" & vbCrLf & vbCrLf & strUserName
    strBody = strBody & vbCrLf & boundSeparator

    strBody = strBody & "Content-Disposition: form-data; name=""" & "password" & """" & vbCrLf & vbCrLf & strPassword
    strBody = strBody & vbCrLf & boundSeparator
    
    strFile = GetFile(strFileName)

    strBody = strBody & "Content-Disposition: form-data; name=""" & "userfile" & """; filename=""" & strFileName & """" & vbCrLf & _
        "Content-Type: text/xml" & vbCrLf & vbCrLf & strFile & vbCrLf

    strBody = strBody & boundFooter
    
    'convert to byte array
    aPostBody = StrConv(strBody, vbFromUnicode)

    WinHttpReq.send aPostBody
    
    Do Until WinHttpReq.Status = 200
        DoEvents
    Loop
    
    UploadXML = WinHttpReq.responseText
    Set WinHttpReq = Nothing
End Function

'---------------------------------------------------------------------------
'Private Sub UploadFile(DestURL As String, _
'                      FileName As String, _
'                      ByVal fieldName As String, _
'                      ByVal user As String, _
'                      ByVal pwd As String)
'
'  Dim sFormData As String, d As String
'
'  'Boundary of fields.
'  'Be sure this string is Not In the source file
'  Const Boundary As String = "---------------------------0123456789012"
'
'  'Get source file As a string.
'  sFormData = GetFile(FileName)
'
'  'Build source form with file contents
'  d = "--" + Boundary + vbCrLf
'
'  d = d + "Content-Disposition: form-data; name=""user""" + vbCrLf
'  d = d + user
'  d = d + vbCrLf + "--" + Boundary + vbCrLf
'
'  d = d + "Content-Disposition: form-data; name=""password""" + vbCrLf
'  d = d + pwd
''  d = d + vbCrLf + "--" + Boundary + vbCrLf
'
''  d = d + "Content-Disposition: form-data; name=""" + fieldName + """;"
''  d = d + " filename=""" + FileName + """" + vbCrLf
''  d = d + "Content-Type: application/upload" + vbCrLf + vbCrLf
''  d = d + sFormData
'  d = d + vbCrLf + "--" + Boundary + "--" + vbCrLf
'
'  'Post the data To the destination URL
'  IEPostStringRequest DestURL, d, Boundary
'End Sub
'
''sends URL encoded form data To the URL using IE
'Sub IEPostStringRequest(URL As String, FormData As String, Boundary As String)
'  'Create InternetExplorer
'  Dim WebBrowser: Set WebBrowser = CreateObject("InternetExplorer.Application")
'
'  'You can uncoment Next line To see form results
'  WebBrowser.Visible = True
'
'  'Send the form data To URL As POST request
'  Dim bFormData() As Byte
'  ReDim bFormData(Len(FormData) - 1)
'  bFormData = StrConv(FormData, vbFromUnicode)
'
'  WebBrowser.Navigate URL, , , bFormData, _
'    "Content-Type: multipart/form-data; boundary=" + Boundary + vbCrLf
'
'  Do While WebBrowser.Busy
''    Sleep 100
'    DoEvents
'  Loop
'  WebBrowser.Quit
'End Sub


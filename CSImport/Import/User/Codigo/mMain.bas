Attribute VB_Name = "mMain"
Option Explicit

' OJO: Esta constante esta declarada dos veces
'      Una vez aqui y otra en mServiceDeclaration de CSOAPI
'      Si la cambian recuerden cambiar tambien en dicha dll
Private Const c_LoginSignature   As String = "Virginia Said-Neron-Catalina-la belleza"

Private m_logFile   As String

Sub Main()
  On Error GoTo ControlError
  
  Dim strconnect As String
  
  Dim cn As ADODB.Connection
  Set cn = New ADODB.Connection
  
  strconnect = pGetConnect()
  m_logFile = App.Path & "\CSImportUser.log"
  
  If Trim(strconnect) = "" Then Exit Sub
  
  cn.Open strconnect
  
  Dim rs As ADODB.Recordset
  Dim sqlstmt As String
  
  sqlstmt = "select us_id, us_nombre, us_claveaux from usuario where us_claveaux <> '@@noclave@@'"
  Set rs = New ADODB.Recordset
  rs.CursorLocation = adUseClient
  rs.Open sqlstmt, cn, adOpenStatic, adLockReadOnly
  
  If Not rs.EOF Then
    rs.MoveLast
    rs.MoveFirst
  End If
  
  Set rs.ActiveConnection = Nothing
  
  While Not rs.EOF
    sqlstmt = "update usuario set us_clave = " & pGetClave(rs.Fields("us_claveaux").Value) & " where us_id = " & rs.Fields("us_id").Value
    cn.Execute sqlstmt
    rs.MoveNext
  Wend
  
  sqlstmt = "update usuario set us_claveaux = '@@noclave@@'"
  cn.Execute sqlstmt
  
  cn.Close
  rs.Close
  Set cn = Nothing
  Set rs = Nothing
  GoTo ExitProc
ControlError:
  pSaveLog Err.Description
ExitProc:
End Sub

Private Function pGetClave(ByVal clave As String) As String
  Dim Encrypt As cEncrypt
  Set Encrypt = New cEncrypt
  
  pGetClave = "'" & Replace(Encrypt.Encript(LCase(clave), c_LoginSignature), "'", "''") & "'"
End Function

Private Function pGetConnect() As String
  pGetConnect = Command$
End Function

Private Sub pSaveLog(ByVal msg As String)
  On Error Resume Next
  Dim f As Integer
  f = FreeFile
  Open m_logFile For Append As f
  Print #f, Now & " " & msg
  Close f
End Sub


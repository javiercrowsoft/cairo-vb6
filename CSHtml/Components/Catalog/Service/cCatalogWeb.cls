VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cCatalogWeb"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Private Declare Sub SubSleep Lib "kernel32" Alias "Sleep" (ByVal dwMilliseconds As Long)

Private Const C_Module = "cCatalogWeb"

Private WithEvents m_fw As fWebCtrl
Attribute m_fw.VB_VarHelpID = -1
Private m_NavComplete   As Boolean

Private Sub Class_Terminate()
  On Error Resume Next
  DestroyFormWeb
  Err.Clear
End Sub

Private Sub m_fw_NavigateComplete(ByVal pDisp As Object, URL As Variant)
  On Error Resume Next
  
  m_NavComplete = True
  DoEvents: DoEvents: DoEvents: DoEvents
  SubSleep 100
  DoEvents: DoEvents: DoEvents: DoEvents

  If Err.Number = 0 Then Exit Sub
  If Err.Description = "Automation error" Then Exit Sub

ControlError:
  MngError Err, "m_fw_NavigateComplete", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Public Sub DestroyFormWeb()
  On Error Resume Next
  If Not m_fw Is Nothing Then
    Unload m_fw
    Set m_fw = Nothing
  End If
End Sub

Public Function UpdateImage(ByVal htmlpage As String, _
                            ByVal bDontDestroyFormWeb As Boolean, _
                            ByVal User As String, _
                            ByVal pwd As String, _
                            ByRef imageFile As String) As Boolean

  'UploadFile htmlpage, imageFile, "userfile", user, pwd
  
  ' Elmino cualquier doble barra que pueda haber en el path
  '
  imageFile = Mid(imageFile, 1, 2) & Replace(Mid(imageFile, 3), "\\", "\")
  
  If FileExists(imageFile) Then
  
    If FileLen(imageFile) > 0 Then
  
      UploadXML htmlpage, imageFile, User, pwd

    End If

  End If

End Function

Public Function GetVersion(ByVal htmlpage As String, _
                           ByVal bDontDestroyFormWeb As Boolean, _
                           ByVal User As String, _
                           ByVal pwd As String) As String
  On Error GoTo ControlError
  
  Dim f As fWebCtrl
  
  If m_fw Is Nothing Then
    Set f = New fWebCtrl
    Load f
    Set m_fw = f

#If PREPROC_DEBUG Then
    f.Show
    If IniGet(c_k_WindowVisible, "(Local)") <> "0" Then
      f.WindowState = vbMaximized
      f.Visible = True
    Else
      f.Visible = False
      f.WindowState = vbMinimized
    End If
#End If
    
  Else
    Set f = m_fw
  End If
  
  'SaveLog "Direccion del Catálogo a Actualizar: " & HtmlPage
  
  f.wb.Navigate2 htmlpage
  
  Dim startTime As Single
  startTime = Timer
  
#If PREPROC_DEBUG Then
  Const c_web_timeout = 20
#Else
  Const c_web_timeout = 120
#End If
  
  m_NavComplete = False
  Do
    DoEvents
    
    If Timer - startTime > c_web_timeout Then GoTo ExitProc
    
    ' WARNING:
    '
    ' Si se esta cerrando el servicio
    ' salimos del bucle y la funcion que
    ' llamo tambien debe salir de su propio bucle
    '
    If gClose Then GoTo ExitProc
    
  Loop Until m_NavComplete
  
  DoEvents: DoEvents: DoEvents: DoEvents: DoEvents
  
  GetVersion = f.wb.Document.Forms("fversion").All("version").Value
  
  GoTo ExitProc

ControlError:
  
  If Err.Description = "Automation error" Then
    Resume ExitProc
  End If
  
  Dim ErrNumber As Long
  Dim ErrDescrip As String
  
  ErrNumber = Err.Number
  ErrDescrip = Err.Description
  
  Unload f
  Set f = Nothing
  Set m_fw = Nothing
  
  On Error GoTo 0
  Err.Raise ErrNumber, , ErrDescrip

ExitProc:
  On Error Resume Next
  
  If Not bDontDestroyFormWeb Then
    Unload f
    Set f = Nothing
    Set m_fw = Nothing
  End If
End Function

Public Function UpdateProducto(ByVal htmlpage As String, _
                               ByVal bDontDestroyFormWeb As Boolean, _
                               ByVal User As String, _
                               ByVal pwd As String, _
                               ByRef sqlstmt_if() As String, _
                               ByRef sqlstmt_update() As String, _
                               ByRef sqlstmt_insert() As String) As Boolean
  On Error GoTo ControlError
  
  Dim f As fWebCtrl
  
  If m_fw Is Nothing Then
    Set f = New fWebCtrl
    Load f
    Set m_fw = f

#If PREPROC_DEBUG Then
    f.Show
    f.WindowState = vbMaximized
    'f.Visible = False
#End If
    
  Else
    Set f = m_fw
  End If
  
  'SaveLog "Direccion del Catálogo a Actualizar: " & HtmlPage
  
  f.wb.Navigate2 htmlpage
  
  Dim startTime As Single
  startTime = Timer
  
#If PREPROC_DEBUG Then
  Const c_web_timeout = 20
#Else
  Const c_web_timeout = 120
#End If
  
  m_NavComplete = False
  Do
    DoEvents
    
    If Timer - startTime > c_web_timeout Then GoTo ExitProc
    
    ' WARNING:
    '
    ' Si se esta cerrando el servicio
    ' salimos del bucle y la funcion que
    ' llamo tambien debe salir de su propio bucle
    '
    If gClose Then GoTo ExitProc
    
  Loop Until m_NavComplete
  
  DoEvents: DoEvents: DoEvents: DoEvents: DoEvents
  
  UpdateProducto = pSendProducto(f, User, pwd, sqlstmt_if(), sqlstmt_update(), sqlstmt_insert())
  
  GoTo ExitProc

ControlError:
  
  If Err.Description = "Automation error" Then
    Resume ExitProc
  End If
  
  Dim ErrNumber As Long
  Dim ErrDescrip As String
  
  ErrNumber = Err.Number
  ErrDescrip = Err.Description
  
  Unload f
  Set f = Nothing
  Set m_fw = Nothing
  
  On Error GoTo 0
  Err.Raise ErrNumber, , ErrDescrip

ExitProc:
  On Error Resume Next
  
  If Not bDontDestroyFormWeb Then
    Unload f
    Set f = Nothing
    Set m_fw = Nothing
  End If
End Function

Private Function pSendProducto(ByRef f As fWebCtrl, _
                               ByVal User As String, _
                               ByVal pwd As String, _
                               ByRef sqlstmt_if() As String, _
                               ByRef sqlstmt_update() As String, _
                               ByRef sqlstmt_insert() As String) As Boolean
  Dim i As Long
  
  With f.wb.Document.Forms("fquery")
  
    .All("query_type").Value = c_query_type_if_no_result
    .All("user").Value = User
    .All("pwd").Value = pwd
    For i = 1 To UBound(sqlstmt_if)
      
      sqlstmt_if(i) = Replace(sqlstmt_if(i), "select", "#elect")
      sqlstmt_if(i) = Replace(sqlstmt_if(i), "insert", "#nsert")
      sqlstmt_if(i) = Replace(sqlstmt_if(i), "update", "#pdate")
      sqlstmt_if(i) = Replace(sqlstmt_if(i), "delete", "#elete")
    
      sqlstmt_update(i) = Replace(sqlstmt_update(i), "select", "#elect")
      sqlstmt_update(i) = Replace(sqlstmt_update(i), "insert", "#nsert")
      sqlstmt_update(i) = Replace(sqlstmt_update(i), "update", "#pdate")
      sqlstmt_update(i) = Replace(sqlstmt_update(i), "delete", "#elete")
    
      sqlstmt_insert(i) = Replace(sqlstmt_insert(i), "select", "#elect")
      sqlstmt_insert(i) = Replace(sqlstmt_insert(i), "insert", "#nsert")
      sqlstmt_insert(i) = Replace(sqlstmt_insert(i), "update", "#pdate")
      sqlstmt_insert(i) = Replace(sqlstmt_insert(i), "delete", "#elete")
      
      .All("query_if[]")(i - 1).Value = sqlstmt_if(i)
      .All("query_true[]")(i - 1).Value = sqlstmt_update(i)
      .All("query_false[]")(i - 1).Value = sqlstmt_insert(i)
    Next
    .submit
  End With
  
  Erase sqlstmt_if
  Erase sqlstmt_update
  Erase sqlstmt_insert
  
  m_NavComplete = False
  Do
    DoEvents
  Loop Until m_NavComplete

  pSendProducto = True

End Function

Private Function pSendImage(ByRef f As fWebCtrl, _
                            ByVal User As String, _
                            ByVal pwd As String, _
                            ByRef imageFile As String) As Boolean
  
  With f.wb.Document.Forms("uploadform")
    .All("user").Value = User
    .All("pwd").Value = pwd
    .All("userfile").Value = imageFile
    .submit
  End With

  m_NavComplete = False
  Do
    DoEvents
  Loop Until m_NavComplete

  pSendImage = True

End Function


VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 3  'UsesTransaction
END
Attribute VB_Name = "cDocumento"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cDocumento
' 24-08-2004

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

Private m_PathDocument          As String
Private m_LinkPathDocument      As String

' constantes
Private Const C_Module = "CSWebBusiness.Documento"
Private Const C_PathDocument = "PathDocument"
Private Const C_LinkPathDocument = "LinkPathDocument"

' estructuras
' variables privadas
' eventos
' propiedades publicas
' propiedades friend
' propiedades privadas
' funciones publicas
Public Function CanEdit(ByVal us_id As Long, ByVal dpto_id As Long) As Boolean
  On Error GoTo errorHandler
  Dim obj As CSWebDataBase.cDocumento
  Set obj = New CSWebDataBase.cDocumento
  
  CanEdit = obj.CanEdit(us_id, dpto_id)
  Set obj = Nothing
  
  GetObjectContext.SetComplete
  Exit Function
  
errorHandler:
  Set obj = Nothing
  CtxRaiseError C_Module, "CanEdit"
End Function

Public Function GetDepartamentos(ByVal us_id As Long) As Recordset
  On Error GoTo errorHandler
  Dim obj As CSWebDataBase.cDocumento
  Set obj = New CSWebDataBase.cDocumento
  
  Set GetDepartamentos = obj.GetDepartamentos(us_id)
  Set obj = Nothing
  
  GetObjectContext.SetComplete
  Exit Function
  
errorHandler:
  Set obj = Nothing
  CtxRaiseError C_Module, "GetDepartamentos"
End Function

Public Function GetDocsXUser(ByVal us_id As Long, _
                             ByVal Folder As String) As Recordset
  On Error GoTo errorHandler
  
  If Not MakeFolderUser(us_id, "") Then Exit Function
  
  If Folder <> vbNullString Then
    Folder = Replace(Folder, "/", "\")
    If Left$(Folder, 1) <> "\" Then
      Folder = "\" & Folder
    End If
  End If
  
  Set GetDocsXUser = pGetFilesForFolder(pGetPathForUser(us_id), _
                                        GetPathForUserEx(us_id), _
                                        Folder, "\*.*")
  
  GetObjectContext.SetComplete
  Exit Function
  
errorHandler:
  CtxRaiseError C_Module, "GetDocsXUser"
End Function

Public Function GetDocsXDpto(ByVal dpto_id As Long, _
                             ByVal us_id As Long, _
                             ByVal Folder As String) As Recordset
  On Error GoTo errorHandler
  
  ' TODO: Validar que el usuario tenga acceso al departamento
  
  If Not MakeFolderDpto(dpto_id, Folder) Then Exit Function
  
  If Folder <> vbNullString Then
    Folder = Replace(Folder, "/", "\")
    If Left$(Folder, 1) <> "\" Then
      Folder = "\" & Folder
    End If
  End If
  
  Set GetDocsXDpto = pGetFilesForFolder(pGetPathForDpto(dpto_id), _
                                        GetPathForDptoEx(dpto_id), _
                                        Folder, "\*.*")
  
  GetObjectContext.SetComplete
  Exit Function
  
errorHandler:
  CtxRaiseError C_Module, "GetDocsXDpto"
End Function

Public Function MakeFolderUser(ByVal us_id As Long, _
                               ByVal Folder As String) As Boolean
  On Error GoTo errorHandler
  
  Folder = pGetPathForUser(us_id) & pGetValidSubFolder(Folder)
  
  pMakeFolder Folder
  
  MakeFolderUser = True
  
  GetObjectContext.SetComplete
  Exit Function
  
errorHandler:
  CtxRaiseError C_Module, "MakeFolderUser - " & Folder
End Function

Public Function MakeFolderDpto(ByVal dpto_id As Long, _
                               ByVal Folder As String) As Boolean
  On Error GoTo errorHandler
  
  pMakeFolder pGetPathForDpto(dpto_id) & pGetValidSubFolder(Folder)
  
  MakeFolderDpto = True
  
  GetObjectContext.SetComplete
  Exit Function
  
errorHandler:
  CtxRaiseError C_Module, "MakeFolderDpto"
End Function

Public Function UploadToDpto(ByVal dpto_id As Long, _
                             ByVal us_id As Long, _
                             ByVal Folder As String) As Boolean
  On Error GoTo errorHandler
  
  GetObjectContext.SetComplete
  Exit Function
  
errorHandler:
  CtxRaiseError C_Module, "UploadToDpto"
End Function

Public Function UploadToUser(ByVal us_id As Long, _
                             ByVal Folder As String) As Boolean
  On Error GoTo errorHandler
  
  GetObjectContext.SetComplete
  Exit Function
  
errorHandler:
  CtxRaiseError C_Module, "UploadToUser"
End Function

Public Function GetPathForUserEx(ByVal us_id As Long) As String
  On Error GoTo errorHandler
  
  GetPathForUserEx = "U" & Format(us_id, "000000000000")
  
  GetObjectContext.SetComplete
  Exit Function
  
errorHandler:
  CtxRaiseError C_Module, "GetPathForUserEx"
End Function

Public Function GetPathForDptoEx(ByVal dpto_id As Long) As String
  On Error GoTo errorHandler
  
  GetPathForDptoEx = "D" & Format(dpto_id, "000000000000")
  
  GetObjectContext.SetComplete
  Exit Function
  
errorHandler:
  CtxRaiseError C_Module, "GetPathForDptoEx"
End Function

Public Function Delete(ByVal File As String, ByVal us_id As Long) As Boolean
  On Error GoTo errorHandler
  
  Dim Path As String
  
  Path = m_PathDocument & "\" & Replace(Replace(File, m_LinkPathDocument, ""), "/", "\")
  
  If ExistsFile(Path) Then
    If ExistsFolder(Path) Then
      DeleteFolder Path
    Else
      Kill Path
    End If
  Else
    If ExistsFolder(Path) Then
      DeleteFolder Path
    End If
  End If
  
  Delete = True
  
  GetObjectContext.SetComplete
  Exit Function
  
errorHandler:
  CtxRaiseError C_Module, "Delete"
End Function

Public Function DeleteFolder(ByVal Path As String) As Boolean
  Dim vSubFolders() As String
  Dim Item As String
  Dim i As Long
  
  ReDim vSubFolders(0)
  Item = Dir(Path & "\*.*", vbDirectory)
  While Len(Item)
  
    If Item <> "." And Item <> ".." Then
      If GetAttr(Path & "\" & Item) And vbDirectory Then
        ReDim Preserve vSubFolders(UBound(vSubFolders) + 1)
        vSubFolders(UBound(vSubFolders)) = Path & "\" & Item
      End If
    End If
    Item = Dir()
  Wend
  
  For i = 1 To UBound(vSubFolders)
    DeleteFolder vSubFolders(i)
  Next
  
  Dim vItems() As String
  ReDim vItems(0)
  Item = Dir(Path & "\*.*")
  While Len(Item)
  
    If Item <> "." And Item <> ".." Then
      ReDim Preserve vItems(UBound(vItems) + 1)
      vItems(UBound(vItems)) = Path & "\" & Item
    End If
    Item = Dir()
  Wend
  
  For i = 1 To UBound(vItems)
    Kill vItems(i)
  Next
  
  RmDir Path
  
End Function

Public Function ExistsFile(ByVal File As String) As Boolean
  On Error Resume Next
  Err.Clear
  ExistsFile = Dir(File) <> ""
  If Err.Number Then ExistsFile = False
End Function

Public Function GetPathForUser(ByVal us_id As Long) As String
  GetPathForUser = pGetPathForUser(us_id)
End Function

Public Function GetPathForDpto(ByVal dpto_id As Long) As String
  GetPathForDpto = pGetPathForDpto(dpto_id)
End Function

' funciones friend
' funciones privadas
Private Sub pMakeFolder(ByVal Folder As String)
  If Not ExistsFolder(Folder) Then
    MkDir Folder
  End If
End Sub

Private Function pGetPathForUser(ByVal us_id As Long) As String
  pGetPathForUser = m_PathDocument & "\" & GetPathForUserEx(us_id)
End Function

Private Function pGetPathForDpto(ByVal dpto_id As Long) As String
  pGetPathForDpto = m_PathDocument & "\" & GetPathForDptoEx(dpto_id)
End Function

Private Function pGetFilesForFolder(ByVal Folder As String, _
                                    ByVal LinkFolder As String, _
                                    ByVal SubFolder As String, _
                                    ByVal filter As String) As Recordset
  Dim vFiles()  As String
  Dim i         As Long
  Dim Path      As String
  
  InitLoadFiles vFiles()
  LoadFiles Folder & SubFolder & filter, vFiles()
  
  Dim rs As Recordset
  Set rs = New ADODB.Recordset
  
  rs.Fields.Append "FilePath", adVarChar, 300
  rs.Fields.Append "FileName", adVarChar, 300
  rs.Fields.Append "FileExt", adVarChar, 50
  rs.Fields.Append "FileType", adInteger
  rs.Open
  
  If SubFolder <> vbNullString Then
  
    If Right$(SubFolder, 3) = "\.." Then
      Dim n As Integer
      Dim c As String
      
      n = Len(SubFolder) - 3
      Do
        c = Mid$(SubFolder, n, 1)
        n = n - 1
      Loop While n > 0 And c <> "\"
      SubFolder = Mid$(SubFolder, 1, n)
    End If
    
    Path = Trim(Replace(SubFolder, "\", "/"))
    
    If Path <> vbNullString Then
      
      rs.AddNew
      rs.Fields(0).Value = Path
      rs.Fields(1).Value = Path & "/.."
      rs.Fields(2).Value = ""
      rs.Fields(3).Value = 2
      
      rs.Update
    End If
  End If
  
  
  For i = 1 To UBound(vFiles)
    If vFiles(i) = "" Then Exit For
    If vFiles(i) <> "." And vFiles(i) <> ".." Then
      rs.AddNew
      rs.Fields(0).Value = m_LinkPathDocument & "/" & LinkFolder & Path & "/" & GetFileName(vFiles(i))
      rs.Fields(1).Value = GetFileName(vFiles(i))
      rs.Fields(2).Value = GetFileExt(vFiles(i))
      If GetAttr(vFiles(i)) = vbDirectory Then
        rs.Fields(3).Value = 1
        With rs.Fields(1)
          .Value = Path & "/" & .Value
        End With
      Else
        rs.Fields(3).Value = 0
      End If
      
      rs.Update
    End If
  Next
  
  If Not (rs.EOF And rs.BOF) Then rs.MoveFirst
  
  Set pGetFilesForFolder = rs
End Function

Private Function pGetValidSubFolder(ByVal Folder As String)
  pGetValidSubFolder = "\" & Folder
End Function

' construccion - destruccion
Private Sub Class_Initialize()
  On Error Resume Next
  
  m_PathDocument = IniGet(C_PathDocument, "")
  m_LinkPathDocument = IniGet(C_LinkPathDocument, "")
End Sub

'//////////////////////////////
'  Codigo estandar de errores
'  On Error GoTo ControlError
'
'  GoTo ExitProc
'ControlError:
'  MngError err,"", C_Module, ""
'  If Err.Number <> 0 Then Resume ExitProc
'ExitProc:
'  On Error Resume Next

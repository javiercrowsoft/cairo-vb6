VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cDocDigital"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cDocDigital
' 17-10-2003

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    Private Const SW_SHOWNORMAL = 1
    Private Const ERROR_PATH_NOT_FOUND = 3&
    Private Const ERROR_BAD_FORMAT = 11&
    Private Const SE_ERR_ACCESSDENIED = 5            '  access denied
    Private Const SE_ERR_ASSOCINCOMPLETE = 27
    Private Const SE_ERR_DDEBUSY = 30
    Private Const SE_ERR_DDEFAIL = 29
    Private Const SE_ERR_DDETIMEOUT = 28
    Private Const SE_ERR_DLLNOTFOUND = 32
    Private Const SE_ERR_FNF = 2                     '  file not found
    Private Const SE_ERR_NOASSOC = 31
    Private Const SE_ERR_OOM = 8                     '  out of memory
    Private Const SE_ERR_PNF = 3                     '  path not found
    Private Const SE_ERR_SHARE = 26
    
    ' estructuras
    ' funciones
    Private Declare Function ShellExecute Lib "shell32.dll" Alias "ShellExecuteA" (ByVal hwnd As Long, ByVal lpOperation As String, ByVal lpFile As String, ByVal lpParameters As String, ByVal lpDirectory As String, ByVal nShowCmd As Long) As Long

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cDocDigital"

Private Const K_NOMBRE                         As Integer = 1
Private Const K_CODIGO                         As Integer = 2
Private Const K_FORMATO                        As Integer = 3
Private Const K_FILENAME                       As Integer = 4
Private Const K_PATH                           As Integer = 5
Private Const K_FILE                           As Integer = 6
Private Const K_CLIENTTABLE                    As Integer = 7
Private Const K_CLIENTTABLEID                  As Integer = 8

' Seudo constantes
Private Enum E_Cols
  c_colID = 1
  c_colICO
  c_colNombre
  c_colCodigo
  c_colFileName
  c_colPath
  c_colFormato
  c_colModificado
  c_colModifico
  c_colMaxAux
End Enum

Private Enum E_Images
  c_ImgAccess = 1
  c_ImgExcel
  c_ImgPowerPoint
  c_ImgWord
  c_ImgPdf
  c_ImgExplorer
  c_ImgJpg
  c_ImgTxt
  c_ImgUnknow
  c_ImgZip
End Enum

Private Const c_colMax = c_colMaxAux - 1
' estructuras

' variables privadas
Private m_ID                            As Long
Private m_ClientTable                   As String
Private m_ClientTableID                 As Long
Private m_Nombre                        As String
Private m_Codigo                        As String
Private m_Formato                       As String
Private m_Descrip                       As String
Private m_FileName                      As String
Private m_ArchivoModificado             As String
Private m_Path                          As String
Private m_ClientDescrip                 As String
Private m_Creado                        As Date
Private m_Modificado                    As Date
Private m_Modifico                      As Long

Private WithEvents m_fDocsDigital       As fDocsDigital
Attribute m_fDocsDigital.VB_VarHelpID = -1
Private WithEvents m_fDocDigital        As fDocDigital
Attribute m_fDocDigital.VB_VarHelpID = -1

Private m_db As cDataBase
' eventos
' propiedades publicas
Public Property Get ID() As Long
  ID = m_ID
End Property

Public Property Let ID(ByVal rhs As Long)
  m_ID = rhs
End Property

Public Property Get ClientTable() As String
   ClientTable = m_ClientTable
End Property

Public Property Let ClientTable(ByVal rhs As String)
   m_ClientTable = rhs
End Property

Public Property Get ClientTableID() As Long
   ClientTableID = m_ClientTableID
End Property

Public Property Let ClientTableID(ByVal rhs As Long)
   m_ClientTableID = rhs
End Property

Public Property Get Nombre() As String
   Nombre = m_Nombre
End Property

Public Property Let Nombre(ByVal rhs As String)
   m_Nombre = rhs
End Property

Public Property Get Codigo() As String
   Codigo = m_Codigo
End Property

Public Property Let Codigo(ByVal rhs As String)
   m_Codigo = rhs
End Property

Public Property Get Formato() As String
   Formato = m_Formato
End Property

Public Property Let Formato(ByVal rhs As String)
   m_Formato = rhs
End Property

Public Property Get Descrip() As String
   Descrip = m_Descrip
End Property

Public Property Let Descrip(ByVal rhs As String)
   m_Descrip = rhs
End Property

Public Property Get FileName() As String
   FileName = m_FileName
End Property

Public Property Let FileName(ByVal rhs As String)
   m_FileName = rhs
End Property

Public Property Get ArchivoModificado() As String
   ArchivoModificado = m_ArchivoModificado
End Property

Public Property Let ArchivoModificado(ByVal rhs As String)
   m_ArchivoModificado = rhs
End Property

Public Property Get Path() As String
   Path = m_Path
End Property

Public Property Let Path(ByVal rhs As String)
   m_Path = rhs
End Property

Public Property Get ClientDescrip() As String
   ClientDescrip = m_ClientDescrip
End Property

Public Property Let ClientDescrip(ByVal rhs As String)
   m_ClientDescrip = rhs
End Property

Public Property Get Creado() As Date
  Creado = m_Creado
End Property

Public Property Let Creado(ByVal rhs As Date)
  m_Creado = rhs
End Property

Public Property Get Modificado() As Date
  Modificado = m_Modificado
End Property

Public Property Let Modificado(ByVal rhs As Date)
  m_Modificado = rhs
End Property

Public Property Get Modifico() As Long
  Modifico = m_Modifico
End Property

Public Property Let Modifico(ByVal rhs As Long)
  m_Modifico = rhs
End Property
' propiedades friend
' propiedades privadas
' funciones publicas
Public Function ShowDocs(ByRef db As cDataBase) As Boolean
  On Error GoTo ControlError

  Dim fDocs As fDocsDigital
  Set fDocs = New fDocsDigital
  
  Dim sqlstmt As String
  Dim Rs      As ADODB.Recordset
  
  sqlstmt = "select dd_id, dd_nombre, dd_codigo, dd_formato, dd_fileName, dd_path, dd_modificado, us_nombre"
  sqlstmt = sqlstmt & " from documentodigital, usuario where dd_clientTable = '" & m_ClientTable & "' and dd_clientTableID = " & m_ClientTableID
  sqlstmt = sqlstmt & " and usuario.us_id = documentodigital.modifico"
  
  If Not db.OpenRs(sqlstmt, Rs) Then Exit Function
  
  VB.Load fDocs
  
  With fDocs
  
    .lbOwner.Caption = "Documentos asociados a " & m_ClientDescrip
    
    With .grFiles
      
      .Redraw = False
      
      Dim i As Long
      For i = 1 To c_colMax
        .AddColumn
      Next
      
      .ColumnVisible(c_colID) = False
      .ColumnWidth(c_colICO) = 30
      .ColumnHeader(c_colNombre) = "Nombre"
      .ColumnWidth(c_colNombre) = 180
      .ColumnHeader(c_colCodigo) = "Codigo"
      .ColumnHeader(c_colFileName) = "Archivo"
      .ColumnHeader(c_colPath) = "Carpeta"
      .ColumnHeader(c_colFormato) = "Formato"
      .ColumnHeader(c_colModificado) = "Modificado"
      .ColumnHeader(c_colModifico) = "Modifico"
      
      .HeaderDragReOrderColumns = True
      .Header = True
      
      .ImageList = fDocs.imList
      
      Set m_fDocsDigital = fDocs
    
      While Not Rs.EOF
        .AddRow
        .Cell(.Rows, c_colID).Text = db.ValField(Rs.fields, "dd_id")
        .Cell(.Rows, c_colNombre).Text = db.ValField(Rs.fields, "dd_nombre")
        .Cell(.Rows, c_colCodigo).Text = db.ValField(Rs.fields, "dd_codigo")
        .Cell(.Rows, c_colFileName).Text = db.ValField(Rs.fields, "dd_fileName")
        .Cell(.Rows, c_colPath).Text = db.ValField(Rs.fields, "dd_path")
        .Cell(.Rows, c_colFormato).Text = db.ValField(Rs.fields, "dd_formato")
        .Cell(.Rows, c_colModificado).Text = db.ValField(Rs.fields, "dd_modificado")
        .Cell(.Rows, c_colModifico).Text = db.ValField(Rs.fields, "us_nombre")
        
        pSetIconFormato .Rows, db.ValField(Rs.fields, "dd_formato")
        Rs.MoveNext
      Wend
      
      .Redraw = True
    End With
    
    Set m_db = db
    

    .Show vbModal
  End With
  
  ShowDocs = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "Show", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
  Unload fDocs
  Set m_fDocsDigital = Nothing
  Set m_db = Nothing
End Function

Public Function ShowDoc(ByRef db As cDataBase) As Boolean
  On Error GoTo ControlError

  Dim fDoc As fDocDigital
  Set fDoc = New fDocDigital
  
  With fDoc
    .txClientTable.Text = m_ClientTable
    .txClientTableId.Text = m_ClientTableID
    .txCodigo.Text = m_Codigo
    .txDescrip.Text = m_Descrip
    .txFile.Text = m_FileName
    .txFormato.Text = m_Formato
    .txModificado.Text = m_ArchivoModificado
    .txNombre.Text = m_Nombre
    .txPath.Text = m_Path
    
    Set m_fDocDigital = fDoc
    
    .Init
    
    .Show vbModal
    
    ShowDoc = .ID <> csNO_ID
  End With
  
  GoTo ExitProc
ControlError:
  MngError Err, "Show", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
  Unload fDoc
  Set m_fDocDigital = Nothing
End Function

Public Function Save(ByRef db As cDataBase) As Boolean
  Dim Register As cRegister
  Set Register = New cRegister
  Register.fieldId = cscDdId
  Register.Table = csTDocumentoDigital
  Register.ID = m_ID
          
  Register.fields.Add2 cscDdNombre, m_Nombre, csText
  Register.fields.Add2 cscDdCodigo, m_Codigo, csText
  Register.fields.Add2 cscDdFormato, m_Formato, csText
  Register.fields.Add2 cscDdFileName, m_FileName, csText
  Register.fields.Add2 cscDdPath, m_Path, csText
  Register.fields.Add2 cscDdClientTable, m_ClientTable, csText
  Register.fields.Add2 cscDdClientTableId, m_ClientTableID, csLong
  
  Register.fields.HaveLastUpdate = True
  Register.fields.HaveWhoModify = True
  If Not db.Save(Register, , "Save", "cDocDigital", "Error al grabar DocumentoDigital") Then Exit Function
  Save = Load(Register.ID, db)
End Function

Public Function Load(ByVal ID As Long, ByRef db As cDataBase) As Boolean

  Dim sqlstmt As String

  sqlstmt = "select dd_id,dd_nombre,dd_codigo,dd_formato,dd_fileName,dd_path,dd_clientTable,dd_clientTableId,dd_modificado,Creado,Modificado,Modifico"
  sqlstmt = sqlstmt & " from documentodigital where dd_id = " & ID

  Dim Rs As Recordset

  If Not db.OpenRs(sqlstmt, Rs, csRsStatic, csLockReadOnly, csCmdText, "Load", "cDocumentoDigital") Then Exit Function

  If Not Rs.EOF Then

    m_ID = db.ValField(Rs.fields, cscDdId)
    m_Nombre = db.ValField(Rs.fields, cscDdNombre)
    m_Codigo = db.ValField(Rs.fields, cscDdCodigo)
    m_Formato = db.ValField(Rs.fields, cscDdFormato)
    m_FileName = db.ValField(Rs.fields, cscDdFileName)
    m_Path = db.ValField(Rs.fields, cscDdPath)
    m_ClientTable = db.ValField(Rs.fields, cscDdClientTable)
    m_ClientTableID = db.ValField(Rs.fields, cscDdClientTableId)
    m_Modificado = db.ValField(Rs.fields, cscDdModificado)
    m_Creado = db.ValField(Rs.fields, cscCreado)
    m_Modificado = db.ValField(Rs.fields, cscModificado)
    m_Modifico = db.ValField(Rs.fields, cscModifico)

  Else
    m_ID = csNO_ID
    m_Nombre = ""
    m_Codigo = ""
    m_Formato = ""
    m_FileName = ""
    m_Path = ""
    m_ClientTable = ""
    m_ClientTableID = 0
    m_Modificado = csNoDate
    m_Creado = csNoDate
    m_Modificado = csNoDate
    m_Modifico = 0
  End If

  Load = True
End Function

Public Function ExtractDoc(ByRef db As cDataBase, ByRef FullFileName As String, Optional ByVal ExtractToTemp As Boolean = True) As Boolean
  On Error GoTo ControlError
  
  Dim File              As cFile
  Dim fileSize          As Long
  Dim offset            As Long
  Dim v()               As Byte
  Dim Rs                As ADODB.Recordset
  Dim sqlstmt           As String
  Dim Path              As String
  Dim FileName          As String
  
  Static nextNumber     As Integer
  
  Set File = New cFile
  
  Set Rs = New ADODB.Recordset
  
  sqlstmt = "select dd_file from documentodigital where dd_id = " & m_ID
  
  If Not db.OpenRs(sqlstmt, Rs) Then Exit Function
  
  Path = m_Path
  
  If ExtractToTemp Then Path = ""
  
  If ValEmpty(Path, csText) Then
      
      FileName = IIf(ValEmpty(m_FileName, csText), "~Cairo_" & nextNumber, m_FileName)
      
      If Not ValEmpty(m_Formato, csText) Then FileName = FileName & "." & m_Formato
      
      nextNumber = nextNumber + 1
      
      FileName = GetValidPath(Environ$("TEMP")) & FileName
      
      If Not CSKernelClient.FileDelete(FileName) Then Exit Function
      
  Else
      FileName = m_FileName
      
      If Not ValEmpty(m_Formato, csText) Then FileName = FileName & "." & m_Formato
      
      FileName = GetValidPath(m_Path) & FileName
  End If
  
  If Not File.FOpen(FileName, csBinaryWrite, True, True, csLockWrite, False, False) Then Exit Function

  fileSize = Rs(0).ActualSize
  offset = 0
  
  Do While offset < fileSize
    If Not db.GetChunk(Rs.fields(0), 100, v) Then Exit Function
    If Not File.FBinaryWrite(v) Then Exit Function
    offset = offset + 100
  Loop
  
  FullFileName = FileName
  
  File.FClose
  
  ExtractDoc = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "ExtractDoc", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Public Function Delete(ByRef db As cDataBase) As Boolean
  On Error GoTo ControlError
  
  Dim sqlstmt As String
  
  sqlstmt = "delete documentodigital where dd_id = " & m_ID
  
  Delete = db.Execute(sqlstmt)
  
  GoTo ExitProc
ControlError:
  MngError Err, "Delete", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Public Function AddFile(ByRef db As cDataBase) As Boolean
  On Error GoTo ControlError
  
  Dim Rs        As ADODB.Recordset
  Dim File      As cFile
  Dim v()       As Byte
  Dim sqlstmt   As String
  Dim FullFile  As String
  
  Set File = New cFile
  
  sqlstmt = "select dd_file from documentodigital where dd_id = " & m_ID
  
  If Not db.OpenRs(sqlstmt, Rs, csRsDynamic, csLockPessimistic) Then Exit Function
  
  FullFile = GetValidPath(m_Path) & m_FileName
  
  If Not ValEmpty(m_Formato, csText) Then FullFile = FullFile & "." & m_Formato
  
  If Not File.FOpen(FullFile, csBinaryRead, False, True, csLockRead, False, False) Then Exit Function
    
  ReDim v(100)
  
  Do While Not File.IsEOF
    If Not File.FBinaryRead(v, False) Then Exit Function
    If Not db.AppendChunk(Rs.fields(0), v) Then Exit Function
  Loop
    
  Rs.Update
  
  File.FClose
  
  AddFile = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "AddFile", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Public Function EditDoc() As Boolean
  Dim FullFile  As String
  Dim Hresult   As Long
  Dim MouseWait As cMouseWait
  
  Set MouseWait = New cMouseWait
  
  FullFile = GetValidPath(m_Path) & m_FileName
  If Not ValEmpty(m_Formato, csText) Then FullFile = FullFile & "." & m_Formato
  
  Hresult = ShellExecute(0&, "open", FullFile & Chr(0), 0, FullFile & Chr(0), SW_SHOWNORMAL)
  
  Select Case Hresult
    Case ERROR_PATH_NOT_FOUND '= 3&
        MsgBox "La ruta de acceso no se encuentra"
    Case ERROR_BAD_FORMAT '= 11&
        MsgBox "Formato no reconocido"
    Case SE_ERR_ACCESSDENIED '= 5 '  access denied
        MsgBox "Error a intentar acceder al archivo. Acceso Denegado."
    Case SE_ERR_ASSOCINCOMPLETE '= 27
        MsgBox "Acceso Incompleto"
    Case SE_ERR_DDEBUSY '= 30
        
    Case SE_ERR_DDEFAIL '= 29
        MsgBox "Falla al intentar editar el archivo"
    Case SE_ERR_DDETIMEOUT '= 28
        
    Case SE_ERR_DLLNOTFOUND '= 32
        MsgBox "El archivo no se encuentra"
    Case SE_ERR_FNF '= 2                     '  file not found
        MsgBox "Archivo no encontrado"
    Case SE_ERR_NOASSOC '= 31
    Case SE_ERR_OOM '= 8                     '  out of memory
        MsgBox "Error de Memoria "
    Case SE_ERR_PNF '= 3                     '  path not found
        MsgBox "La ruta de acceso no se encuentra"
    Case SE_ERR_SHARE '= 26
        
  End Select
End Function

' funciones friend
' funciones privadas
Private Sub m_fDocDigital_ReLoad()
  With m_fDocDigital
    
    .txClientTable.Text = m_ClientTable
    .txClientTableId.Text = m_ClientTableID
    .txCodigo.Text = m_Codigo
    .txDescrip.Text = m_Descrip
    .txFile.Text = m_FileName
    .txFormato.Text = m_Formato
    .txModificado.Text = m_ArchivoModificado
    .txNombre.Text = m_Nombre
    .txPath.Text = m_Path
    
    .Init
  End With
End Sub

Private Sub m_fDocDigital_Save()
  On Error GoTo ControlError

  Dim Mouse As cMouseWait
  Set Mouse = New cMouseWait

  With m_fDocDigital
    m_ClientTable = .txClientTable.Text
    m_ClientTableID = .txClientTableId.Text
    m_Codigo = .txCodigo.Text
    m_Descrip = .txDescrip.Text
    m_FileName = .txFile.Text
    m_Formato = .txFormato.Text
    m_ArchivoModificado = .txModificado.Text
    m_Nombre = .txNombre.Text
    m_Path = .txPath.Text
    
    If m_Codigo = "" Then
      m_Codigo = Format(pGetNextCode(), String(10, "0"))
    End If
  
    If Not Save(m_db) Then Exit Sub
    
    .ID = m_ID
    .txCodigo.Text = m_Codigo
    
    If .FileChanged Then
      .FileChanged = Not AddFile(m_db)
    End If
  End With
  
  GoTo ExitProc
ControlError:
  MngError Err, "m_fDocDigital_Save", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Function pGetNextCode() As Long
  Dim ID As Long
  If Not m_db.GetNewId(csTDocumentoDigital, cscDdCodigo, ID) Then Exit Function
  pGetNextCode = ID
End Function

Private Sub m_fDocsDigital_Add()
  On Error GoTo ControlError

  If Not pEditDoc(0) Then Exit Sub

  With m_fDocsDigital.grFiles
  
    .AddRow
    
    pRefreshGrid .Rows
  End With

  GoTo ExitProc
ControlError:
  MngError Err, "m_fDocsDigital_Add", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub m_fDocsDigital_Delete()
  On Error GoTo ControlError

  Dim ID As Long
  With m_fDocsDigital.grFiles
    If .SelectedRow <= 0 Then Exit Sub
    
    m_ID = Val(.Cell(.SelectedRow, 1).Text)
    
    If Not Delete(m_db) Then Exit Sub
    
    .RemoveRow .SelectedRow
  
  End With

  GoTo ExitProc
ControlError:
  MngError Err, "", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub m_fDocsDigital_Edit()
  On Error GoTo ControlError

  Dim ID As Long
  With m_fDocsDigital.grFiles
    If .SelectedRow <= 0 Then Exit Sub
    ID = Val(.Cell(.SelectedRow, 1).Text)
  
    If Not pEditDoc(ID) Then Exit Sub
    
    pRefreshGrid .SelectedRow
  
  End With
  GoTo ExitProc
ControlError:
  MngError Err, "", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub m_fDocsDigital_View()
  On Error GoTo ControlError

  Dim ID As Long
  Dim FullFile As String
  
  With m_fDocsDigital.grFiles
    If .SelectedRow <= 0 Then Exit Sub
    ID = Val(.Cell(.SelectedRow, 1).Text)
  
    If Not Load(ID, m_db) Then Exit Sub
    If Not ExtractDoc(m_db, FullFile) Then Exit Sub
    
    m_FileName = FileGetNameWithoutExt(FullFile)
    m_Path = FileGetPath(FullFile)
    m_Formato = FileGetFileExt(FullFile)
    
    If Not EditDoc() Then Exit Sub
  
  End With

  GoTo ExitProc
ControlError:
  MngError Err, "m_fDocsDigital_View", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub pRefreshGrid(ByRef Row As Long)
  With m_fDocsDigital.grFiles
    
    .Cell(Row, c_colID).Text = m_ID
    .Cell(Row, c_colNombre).Text = m_Nombre
    .Cell(Row, c_colCodigo).Text = m_Codigo
    .Cell(Row, c_colFileName).Text = m_FileName
    .Cell(Row, c_colPath).Text = m_Path
    .Cell(Row, c_colFormato).Text = m_Formato
    .Cell(Row, c_colModificado).Text = m_Modificado
    .Cell(Row, c_colModifico).Text = m_db.UserName
    
    pSetIconFormato Row, m_Formato
  End With
End Sub

Private Sub pSetIconFormato(ByVal Row As Long, ByVal Formato As String)
  Dim IconIndex As Long
  
  With m_fDocsDigital.grFiles
    Select Case LCase(Formato)
      Case "jpg", "gif", "bmp"
        IconIndex = c_ImgJpg
      Case "doc", "dot"
        IconIndex = c_ImgWord
      Case "pps", "ppt"
        IconIndex = c_ImgPowerPoint
      Case "xls"
        IconIndex = c_ImgExcel
      Case "mdb"
        IconIndex = c_ImgAccess
      Case "txt"
        IconIndex = c_ImgTxt
      Case "pdf"
        IconIndex = c_ImgPdf
      Case "zip"
        IconIndex = c_ImgZip
      Case Else
        IconIndex = c_ImgUnknow
    End Select
    
    .Cell(Row, c_colICO).IconIndex = IconIndex - 1
  End With
End Sub

Private Function pEditDoc(ByVal ID As Long) As Boolean
  On Error GoTo ControlError
  
  Dim ClientTable     As String
  Dim ClientTableID   As String
  
  ClientTable = m_ClientTable
  ClientTableID = m_ClientTableID

  If Not Load(ID, m_db) Then Exit Function
  
  m_ClientTable = ClientTable
  m_ClientTableID = ClientTableID
  
  ShowDoc m_db

  pEditDoc = True

  GoTo ExitProc
ControlError:
  MngError Err, "pEditDoc", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function
' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
  On Error GoTo ControlError

  Set m_fDocsDigital = Nothing
  Set m_fDocDigital = Nothing
  Set m_db = Nothing
  
  GoTo ExitProc
ControlError:
  MngError Err, "Class_Terminate", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
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


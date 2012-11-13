VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cCDRom"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGeneric
Implements CSInterfacesABM.cIABMClient
Implements CSMenu.cIMenuClient
'--------------------------------------------------------------------------------
' cCDRom
' 12-06-03

'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cCDRom"

Private Const K_NOMBRE      As Integer = 1
Private Const K_CODIGO      As Integer = 2
Private Const K_ACTIVO      As Integer = 3
Private Const K_DESCRIP     As Integer = 4
Private Const K_SCANCD      As Integer = 5
Private Const K_VAN         As Integer = 6
Private Const K_GUARDARCDS  As Integer = 7
' estructuras
' Seudo - Variables
Private c_ErrorSave

' variables privadas
Private m_Id                As Long
Private m_Nombre            As String
Private m_Codigo            As String
Private m_Activo            As Boolean
Private m_Modificado        As Date
Private m_Creado            As Date
Private m_Modifico          As Long
Private m_Descrip           As String
Private m_Host              As CSMenu.cIMenuHost

Private m_Cancel  As Boolean
Private m_Procesing As Boolean

Private m_Van   As Integer
Private m_Son   As Integer

Private m_Root  As Collection

Private WithEvents m_fProgress As fProgress
Attribute m_fProgress.VB_VarHelpID = -1

'OJO HASTA ACA
Private m_Editing           As Boolean

Private m_ObjAbm            As cIABMGeneric
Private m_ObjTree           As Object

Private m_IsNew             As Boolean

Private m_BranchId          As Long
Private m_TreeId            As Long
Private m_Copy              As Boolean

' Properties publicas
' Properties privadas
' funciones publicas

' Implementacion de cIMenuClient
Private Function cIMenuClient_Initialize(F As Object, Host As CSMenu.cIMenuHost) As Boolean
  On Error GoTo ControlError
  Dim str_2955  As String
  
  str_2955 = LNGGetText(2955, vbNullString) 'CDTe&ka
  Set m_Host = Host
                                                    'Co&nfiguración
  m_Host.Server.AddMenu str_2955, csCDMenuConfig, LNGGetText(1028, vbNullString), 0, True, False, True, False, True, Nothing
  m_Host.Server.AddMenu LNGGetText(2956, vbNullString), csPreCDListCDRom, str_2955, 0, True, False, False, False, False, Me
                        'CD&Rom
  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, "cIMenuClient_Initialize", C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal ID As Long) As Variant
  m_Host.MenuABMClick "CSCDTeka2.cCDRom", Me, LNGGetText(2957, vbNullString), 0, csETablesCDTeka.csCDRom
                                              'CDRoms
End Function

' Implementacion de cIABMClient
Private Function cIABMClient_Copy() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True
  
  With m_ObjAbm.Properties(cscCDANombre)
    .Value = "Copia de " & .Value
  End With
    
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscCDANombre)
  
  m_Copy = True
End Function

Private Function cIABMClient_EditNew() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True

  cIEditGeneric_Edit csNO_ID
End Function

Private Property Get cIABMClient_Aplication() As String
    cIABMClient_Aplication = gAppName
End Property

Private Property Get cIABMClient_CanAddDocDigital() As Boolean
  cIABMClient_CanAddDocDigital = m_Id <> csNO_ID
End Property

Private Property Get cIABMClient_CanCopy() As Boolean
  cIABMClient_CanCopy = True
End Property

Private Property Get cIABMClient_CanNew() As Boolean
  cIABMClient_CanNew = True
End Property

Private Function cIABMClient_ShowDocDigital() As Boolean
  On Error GoTo ControlError
  
  If m_Id = csNO_ID Then Exit Function
  
  Dim Doc As cDocDigital
  Set Doc = New cDocDigital

  Doc.ClientTable = csTCDRom
  Doc.ClientTableID = m_Id

  cIABMClient_ShowDocDigital = Doc.ShowDocs(gDB)

  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClient_ShowDocDigital", C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIABMClient_MessageEx(ByVal MessageID As Long, ByVal Info As Variant) As Variant
  cIABMClient_MessageEx = True
End Function

Private Sub cIABMClient_DiscardChanges()
    LoadCollection
End Sub

Private Function cIABMClient_ListAdHock(List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClient_Load()

End Sub

Private Function cIABMClient_PropertyChange(ByVal Key As Integer) As Boolean
  Select Case Key
    Case K_SCANCD
      If m_Procesing Then
        If Ask(LNGGetText(1665, vbNullString), vbYes) Then
                'Desea cancelar el proceso
          m_ObjAbm.Properties("scancd").Name = LNGGetText(2958, vbNullString) 'Scan CD
          m_Procesing = False
          m_Cancel = True
        End If
      Else
        m_Cancel = False
        m_Procesing = True
        m_ObjAbm.Properties("scancd").Name = LNGGetText(2959, vbNullString) 'Cancelar
        m_ObjAbm.Properties("van").Value = 0
        m_ObjAbm.RefreshControls
        pScanCD
        m_ObjAbm.Properties("scancd").Name = LNGGetText(2958, vbNullString) 'Scan CD
        cIABMClient_PropertyChange = True
        m_Procesing = False
      End If
    
    Case K_GUARDARCDS
      Set m_fProgress = fProgress
      fProgress.Show vbModal
  End Select
End Function

Private Function cIABMClient_Save() As Boolean
  Dim register   As cRegister
  Dim fields     As cFields
  
  Set register = New cRegister
  Set fields = register.fields
  
  With register
    .fieldId = cscCDId
    .Table = csTCDRom
  
    If m_Copy Then
      .ID = csNew
    Else
      .ID = m_Id
    End If
  End With

  Dim IProperty As cIABMProperty
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_CODIGO
          fields.Add2 cscCDCodigo, .Value, csText
        Case K_NOMBRE
          fields.Add2 cscCDNombre, .Value, csText
        Case K_DESCRIP
          fields.Add2 cscCDDescrip, .Value, csText
        Case K_ACTIVO
          fields.Add2 cscActivo, .Value, csBoolean

      End Select
    End With
  Next
  fields.HaveLastUpdate = True
  fields.HaveWhoModify = True
  If Not gDB.Save(register, , "cIABMClient_Save", "cCDRom", "Error al grabar CDRom") Then Exit Function
  
  m_Copy = False
  cIABMClient_Save = Load(register.ID)
End Function


Private Function cIABMClient_Terminate() As Boolean
    m_Editing = False
    
    cIABMClient_Terminate = True
    ' Este objeto puede no cumplir con la interfaz esperada, asi que si hay un error no
    ' le doy bola
    On Error GoTo ControlError
    If m_Id = csNO_ID Then Exit Function
    If m_ObjTree Is Nothing Then Exit Function
    
    If m_IsNew Then
        m_ObjTree.AddLeave m_Id, m_BranchId, m_TreeId
    Else
        m_ObjTree.AddEditedId m_Id
        m_ObjTree.RefreshActiveBranch
    End If
ControlError:
End Function

Private Property Get cIABMClient_Title() As String
    cIABMClient_Title = LNGGetText(2957, vbNullString) 'CDRoms
End Property

Private Function cIABMClient_Validate() As Boolean

  Dim IProperty As cIABMProperty

  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_CODIGO
          If ValEmpty(.Value, csText) Then
            MsgInfo LNGGetText(1008, vbNullString) 'Debe indicar un codigo
            Exit Function
          End If
        Case K_NOMBRE
          If ValEmpty(.Value, csText) Then
            MsgInfo LNGGetText(1007, vbNullString) 'Debe indicar un nombre
            Exit Function
          End If
        Case K_DESCRIP
          If ValEmpty(.Value, csText) Then
            MsgInfo LNGGetText(2960, vbNullString) 'Debe indicar una Descripción
            Exit Function
          End If

      End Select
    End With
  Next

  cIABMClient_Validate = True
End Function

' Implementacion de cIEditGeneric
Private Property Get cIEditGeneric_ObjABM() As CSInterfacesABM.cIABMGeneric
  Set cIEditGeneric_ObjABM = m_ObjAbm
End Property

Private Function cIEditGeneric_TabClick(ByVal Index As Integer) As Boolean

End Function

Private Property Let cIEditGeneric_TreeId(ByVal RHS As Long)
    m_TreeId = RHS
End Property

Private Property Get cIEditGeneric_TreeId() As Long
    cIEditGeneric_TreeId = m_TreeId
End Property

Private Function cIEditGeneric_GridAdd(ByVal ClavePropiedad As Integer) As Boolean

End Function

Private Function cIEditGeneric_GridEdit(ByVal ClavePropiedad As Integer) As Boolean

End Function

Private Function cIEditGeneric_GridRemove(ByVal ClavePropiedad As Integer) As Boolean

End Function

Private Function cIEditGeneric_ShowList() As Boolean
    cIEditGeneric_ShowList = SecurityCanAccess(csPreCDListCDRom)
End Function

Private Property Set cIEditGeneric_ObjABM(RHS As CSInterfacesABM.cIABMGeneric)
    Set m_ObjAbm = RHS
End Property

Private Property Get cIEditGeneric_Editing() As Boolean
    cIEditGeneric_Editing = m_Editing
End Property

Private Function cIEditGeneric_Delete(ID As Long) As Boolean
    If Not SecurityCanAccess(csPreCDDeleteCDRom) Then Exit Function

    Dim sqlstmt As String
    
    sqlstmt = "Delete CDRom where cd_id = " & ID
    
    cIEditGeneric_Delete = gDB.Execute(sqlstmt, "cIEditGeneric_Delete", "cCDRom")
End Function

Private Function cIEditGeneric_Search(ID As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(ID As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If ID = csNO_ID Then
    m_IsNew = True
    If Not SecurityCanAccess(csPreCDNewCDRom) Then Exit Function
  Else
    m_IsNew = False
    If Not SecurityCanAccess(csPreCDEditCDRom) Then Exit Function
  End If
  
  ' JMA I
  m_ObjAbm.InModalWindow = InModalWindow
' JMA F
  
  If Not Load(ID) Then Exit Function
  
  If Not LoadCollection() Then Exit Function
  
  m_Editing = True
  m_Copy = False
  
  If InModalWindow Then
    cIEditGeneric_Edit = m_Id <> csNO_ID
  Else
    cIEditGeneric_Edit = True
  End If

  Exit Function
ControlError:
  MngError Err, "cIEditGeneric_Edit", "cCDRom", vbNullString
End Function

Private Function cIEditGeneric_PrintObj(ByVal ID As Long) As Boolean

End Function

Private Property Set cIEditGeneric_ObjTree(RHS As Object)
    Set m_ObjTree = RHS
End Property

Private Property Let cIEditGeneric_BranchId(ByVal RHS As Long)
    m_BranchId = RHS
End Property

Private Property Get cIEditGeneric_BranchId() As Long
    cIEditGeneric_BranchId = m_BranchId
End Property

Private Function cIEditGeneric_Preview(ByVal ID As Long) As Boolean

End Function

Private Function cIEditGeneric_PropertyChange(ByVal Key As Integer) As Boolean

End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  m_ObjAbm.Properties.Clear
  
  Dim c As cIABMProperty
  
  Set c = m_ObjAbm.Properties.Add(c, cscCDNombre)
  c.PropertyType = cspText
  c.Name = C_strNombre
  c.Size = 50
  c.Key = K_NOMBRE
  c.Value = m_Nombre
  Set c = Nothing
  Set c = m_ObjAbm.Properties.Add(c, cscCDCodigo)
  c.PropertyType = cspText
  c.Name = C_strCodigo
  c.Size = 10
  c.Key = K_CODIGO
  c.Value = m_Codigo
  Set c = Nothing
  Set c = m_ObjAbm.Properties.Add(c, cscActivo)
  c.PropertyType = cspCheck
  c.TopFromProperty = cscCDCodigo
  c.Left = 5500
  c.Name = C_strActivo
  c.LeftNotChange = True
  c.TopNotChange = True
  c.Key = K_ACTIVO
  c.Value = CInt(m_Activo)
  Set c = Nothing
  Set c = m_ObjAbm.Properties.Add(c, cscCDDescrip)
  c.PropertyType = cspText
  c.SubType = cspMemo
  c.Height = 660
  c.Width = 5600
  c.Name = C_strDescrip
  c.Size = 255
  c.Key = K_DESCRIP
  c.Value = m_Descrip
  Set c = Nothing
  Set c = m_ObjAbm.Properties.Add(c, "scancd")
  c.PropertyType = cspButton
  c.Name = LNGGetText(2958, vbNullString) 'Scan CD
  c.Width = 1200
  c.Key = K_SCANCD
  Set c = Nothing
  Set c = m_ObjAbm.Properties.Add(c, "van")
  c.PropertyType = cspNumeric
  c.SubType = cspInteger
  c.Enabled = False
  c.Name = LNGGetText(2043, vbNullString) 'Van
  c.Width = 800
  c.Key = K_VAN
  Set c = Nothing
  Set c = m_ObjAbm.Properties.Add(c, "guardarcd")
  c.PropertyType = cspButton
  c.Name = LNGGetText(2961, vbNullString) 'Guardar CD
  c.Width = 1200
  c.Enabled = m_Id <> csNO_ID
  c.Key = K_GUARDARCDS
  Set c = Nothing
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

Private Function Load(ByVal ID As Long) As Boolean
  Dim sqlstmt As String
  
  sqlstmt = "select * from CDRom where CD_Id = " & ID
  
  Dim rs As Recordset

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "Load", "cCDRom") Then Exit Function
 
  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.fields, cscCDId)
    m_Codigo = gDB.ValField(rs.fields, cscCDCodigo)
    m_Nombre = gDB.ValField(rs.fields, cscCDNombre)
    m_Descrip = gDB.ValField(rs.fields, cscCDDescrip)
    m_Creado = gDB.ValField(rs.fields, cscCreado)
    m_Modificado = gDB.ValField(rs.fields, cscModificado)
    m_Modifico = gDB.ValField(rs.fields, cscModifico)
    m_Activo = gDB.ValField(rs.fields, cscActivo)

  Else
    m_Id = csNO_ID
    m_Codigo = vbNullString
    m_Nombre = vbNullString
    m_Descrip = vbNullString
    m_Creado = csNoDate
    m_Modificado = csNoDate
    m_Modifico = 0
    m_Activo = False
  End If
  
  Load = True
End Function

Private Sub m_fProgress_Cancel()
  m_Cancel = True
End Sub

Private Sub m_fProgress_StartProcess()
  pSaveCD
  Unload fProgress
  Set m_fProgress = Nothing
End Sub

Private Sub pSaveCD()
  
  Dim sqlstmt As String
  
  m_Cancel = False
  
  sqlstmt = "delete CDRomArchivo where cd_id = " & m_Id
  If Not gDB.Execute(sqlstmt, "pSaveCD", C_Module) Then Exit Sub
  
  sqlstmt = "delete CDRomCarpeta where cd_id = " & m_Id
  If Not gDB.Execute(sqlstmt, "pSaveCD", C_Module) Then Exit Sub
  
  DoEvents
  
  If m_Cancel Then Exit Sub
  
  fProgress.lbCDName.Caption = m_ObjAbm.Properties(cscCDNombre).Value
  fProgress.lbSon.Caption = m_Son
  m_Van = 0
  
  If pSaveCDAux(m_Root, csNO_ID) Then
    MsgInfo LNGGetText(2962, vbNullString), LNGGetText(2961, vbNullString)
            'El CD se guardo con éxito, Guardar CD
  End If
End Sub

Private Function pSaveCDAux(ByRef v As Variant, ByVal IdFather As Long) As Boolean
  Dim IsFolder   As Boolean
  Dim IdFolder   As Long
  Dim v2         As Variant
  Dim Percent    As Integer
  
  IsFolder = True
  For Each v2 In v
     
    DoEvents
    If m_Cancel Then Exit Function
     
    If VarType(v2) = vbObject Then
      If Not pSaveCDAux(v2, IdFolder) Then Exit Function
      
    ElseIf IsFolder Then
      IsFolder = False
      If Not pSaveFolder(v2, IdFather, IdFolder) Then Exit Function
      
      pAddFolder v2, IdFather, IdFolder
      m_Van = m_Van + 1
    
    Else
      If Not pSaveFile(v2, IdFolder) Then Exit Function
      
      pAddFile v2, IdFolder
      m_Van = m_Van + 1
    End If
    

    fProgress.lbVan.Caption = m_Van
    Percent = (m_Van / m_Son) * 100
    fProgress.prg.Value = IIf(Percent > 100, 100, Percent)
  Next
  
  pSaveCDAux = True
End Function

Private Sub pAddFolder(ByVal Folder As String, ByVal Father As Long, ByVal IdFolder As Long)
  pAddLeave pGetFolder(Folder), Father, True, IdFolder
End Sub

Private Sub pAddFile(ByVal File As String, ByVal Father As Long)
  pAddLeave pGetFile(File), Father, False, 0
End Sub

Private Sub pAddLeave(ByVal Leave As String, ByVal Father As Long, ByVal IsFoolder As Boolean, ByVal Key As Long)
  Dim Node As Node
  
  If Father <> 0 Then
    Set Node = fProgress.Tv.Nodes.Add(GetKey(Father), tvwChild, , Leave)
  Else
    Set Node = fProgress.Tv.Nodes.Add(, tvwChild, , Leave)
  End If
  
  If Key <> 0 Then
    Node.Key = GetKey(Key)
  End If
  
  If IsFoolder Then
    Node.Image = 1
    Node.SelectedImage = 2
  Else
    Node.Image = 3
    Node.SelectedImage = 3
  End If
  
  Node.EnsureVisible
  
  DoEvents
End Sub


Private Function pSaveFile(ByVal File As String, ByVal IdFolder As Long) As Boolean
  Dim register As cRegister
  
  Set register = New cRegister
  With register
    .fieldId = cscCDAId
    .Table = csTCDRomArchivo
    .ID = csNO_ID
    
    With .fields
      .Add2 cscCDANombre, pGetFile(File), csText
      .Add2 cscCDATipo, pGetFileType(File), csText
      .Add2 cscCDAPath, pGetPath(File), csText
      .Add2 cscCDCId, IdFolder, csId
      .Add2 cscCDId, m_Id, csId
    
      .HaveLastUpdate = True
      .HaveWhoModify = True
    End With
  End With
  
  pSaveFile = gDB.Save(register, , "pSaveFile", "cCDRom", "Error al grabar un archivo")
End Function

Private Function pSaveFolder(ByVal Folder As String, ByVal IdFather As Long, ByRef IdFolder As Long) As Boolean
  Dim register As cRegister
  
  Set register = New cRegister
  With register
    .fieldId = cscCDCId
    .Table = csTCDRomCarpeta
    .ID = csNO_ID
    
    With .fields
      .Add2 cscCDCId_padre, IdFather, csId
      .Add2 cscCDCNombre, pGetFolder(Folder), csText
      .Add2 cscCDCPath, pGetPath(Folder), csText
      .Add2 cscCDId, m_Id, csId
    
      .HaveLastUpdate = True
      .HaveWhoModify = True
    End With
  End With
  
  pSaveFolder = gDB.Save(register, , "pSaveFolder", "cCDRom", "Error al grabar una carpeta")
  
  IdFolder = register.ID
End Function

Private Function pGetFileType(ByVal Path As String) As String
  Dim i As Integer
  Dim Found As Boolean
  
  For i = Len(Path) To 1 Step -1
    If Mid(Path, i, 1) = "." Then
      Path = Mid(Path, i + 1)
      Found = True
      Exit For
    End If
    If Mid(Path, i, 1) = "\" Then Exit Function
  Next
  
  If Not Found Then Exit Function
  
  pGetFileType = Path
End Function

Private Function pGetFile(ByVal Path As String) As String
  pGetFile = pGetFolder(Path)
End Function

Private Function pGetFolder(ByVal Path As String) As String
  Dim i As Integer
  If Right$(Path, 1) = "\" Then Path = Mid$(Path, 1, Len(Path) - 1)
  For i = Len(Path) To 1 Step -1
    If Mid$(Path, i, 1) = "\" Then
      Path = Mid$(Path, i + 1)
      Exit For
    End If
  Next
  pGetFolder = Path
End Function

Private Function pGetPath(ByVal Path As String) As String
  Dim i As Integer
  If Right$(Path, 1) = "\" Then Path = Mid$(Path, 1, Len(Path) - 1)
  For i = Len(Path) To 1 Step -1
    If Mid$(Path, i, 1) = "\" Then
      Path = Mid$(Path, 1, i - 1)
      Exit For
    End If
  Next
  pGetPath = Path
End Function

Private Sub pScanCD()
  Dim Drive As String
  
  If Not GetInput(Drive, LNGGetText(2963, vbNullString)) Then Exit Sub
                        'Ingrese la unidad a leer
  
  LoadDrive Drive
  
End Sub

Private Sub LoadDrive(ByVal Drive As String)
  On Error Resume Next

  m_Van = 1
  CollClear m_Root
  m_Cancel = False
  
  LoadFiles GetValidPath(Drive), m_Root
  
  m_Son = m_Van
  m_Van = 0

  m_ObjAbm.Properties("van").Value = m_Son
  m_ObjAbm.RefreshControls
End Sub

Private Sub LoadFiles(ByVal Path As String, ByRef Folder As Collection)
  On Error Resume Next
  
  Dim s As String
  Dim vDirs() As String
  
  ReDim vDirs(0)
  
  Folder.Add Path
  s = Dir(Path & "*.*")
  Do
    If s = "" Then Exit Do
    Folder.Add Path & s
    m_ObjAbm.Properties("van").Value = m_Van
    m_ObjAbm.RefreshControls
    m_Van = m_Van + 1
    s = Dir
    DoEvents
    If m_Cancel Then Exit Sub
  Loop Until s = ""

  s = Dir(Path, vbDirectory)
  Do
    If s = "" Then Exit Do
    If (GetAttr(Path & s) And vbDirectory) And s <> ".." And s <> "." Then
      ReDim Preserve vDirs(UBound(vDirs) + 1)
      vDirs(UBound(vDirs)) = Path & s
    
      m_ObjAbm.Properties("van").Value = m_Van
      m_ObjAbm.RefreshControls
      m_Van = m_Van + 1
    End If
    s = Dir
  Loop
  
  Dim i As Integer
  Dim ChildFolder As Collection
  
  For i = 1 To UBound(vDirs)
    Set ChildFolder = New Collection
    Folder.Add ChildFolder
    LoadFiles vDirs(i) & "\", ChildFolder
  Next
End Sub

' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError
  Set m_Root = New Collection
    
  c_ErrorSave = LNGGetText(2964, vbNullString) 'Error al grabar CDRom
   
  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
    Set m_ObjAbm = Nothing
    Set m_ObjTree = Nothing
    Set m_fProgress = Nothing
End Sub


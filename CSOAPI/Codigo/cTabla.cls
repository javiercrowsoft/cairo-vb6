VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cTabla"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGeneric
Implements CSInterfacesABM.cIABMClient
Implements CSMenu.cIMenuClient
Implements CSInterfacesABM.cIABMClientGrid
'--------------------------------------------------------------------------------
' cTabla
' 13-07-03

'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cTabla"

Private Const c_reportes = "reportes"
Private Const c_campos_add = "CamposAdd"

Private Const K_NOMBRE                         As Integer = 1
Private Const K_NOMBREFISICO                   As Integer = 2
Private Const K_CAMPOID                        As Integer = 3
Private Const K_CAMPOCODIGO                    As Integer = 4
Private Const K_SQLHELP                        As Integer = 5
Private Const K_SQLSEARCH                      As Integer = 500
Private Const K_TIENEARBOL                     As Integer = 6
Private Const K_TIENEACTIVO                    As Integer = 7
Private Const K_CAMPONOMBRE                    As Integer = 8
Private Const K_CAMPOSINVIEW                   As Integer = 9
Private Const K_CAMPOSINVIEWCLIENTE            As Integer = 100
Private Const K_SQLHELPCLIENTE                 As Integer = 101
Private Const K_WHERE                          As Integer = 10
Private Const K_OBJECTEDIT                     As Integer = 11
Private Const K_OBJECTABM                      As Integer = 12
Private Const K_TBL_ID                         As Integer = 13
Private Const K_REPORTES                       As Integer = 14
Private Const K_CAMPOS_ADD                     As Integer = 102
Private Const K_SPINFO                         As Integer = 15
Private Const K_SQLHELPWEB                     As Integer = 16
Private Const K_HELP_TOP                       As Integer = 17

Private Const KI_RPTF_ID                        As Integer = 1
Private Const KI_NOMBRE                         As Integer = 2
Private Const KI_CSRFILE                        As Integer = 3
Private Const KI_SUGERIDO                       As Integer = 5
Private Const KI_RPT_OBJ                        As Integer = 6

Private Const KI_TBLI_ID                        As Integer = 3
Private Const KI_NOMBREFISICO                   As Integer = 4
Private Const KI_TIPO                           As Integer = 5
Private Const KI_SUBTIPO                        As Integer = 6
Private Const KI_ORDEN                          As Integer = 7
Private Const KI_TBL_ID_HELP                    As Integer = 8
Private Const KI_HELPTYPE                       As Integer = 9
Private Const KI_FILTRO                         As Integer = 10
Private Const KI_DEFAULTVALUE                   As Integer = 11
Private Const KI_MINVALUE                       As Integer = 12
Private Const KI_MAXVALUE                       As Integer = 13
Private Const KI_TEXTALIGN                      As Integer = 14
Private Const KI_TEXTMASK                       As Integer = 15
Private Const KI_FORMAT                         As Integer = 16
Private Const KI_WIDTH                          As Integer = 17
Private Const KI_HEIGHT                         As Integer = 18
Private Const KI_TOP                            As Integer = 19
Private Const KI_LEFT                           As Integer = 20
Private Const KI_NOSHOWBUTTON                   As Integer = 21
Private Const KI_SQLSTMT                        As Integer = 22

' estructuras
' Seudo - Variables
Private c_ErrorSave                    As String

' variables privadas
Private m_Id                           As Long
Private m_Nombre                       As String
Private m_NombreFisico                 As String
Private m_CampoId                      As String
Private m_CampoCodigo                  As String
Private m_SqlHelp                      As String
Private m_SqlHelpCliente               As String
Private m_SqlSearch                    As String
Private m_SqlHelpWeb                   As String
Private m_TieneArbol                   As Boolean
Private m_TieneActivo                  As Boolean
Private m_CampoNombre                  As String
Private m_CamposInView                 As String
Private m_CamposInViewCliente          As String
Private m_Where                        As String
Private m_ObjectEdit                   As String
Private m_ObjectABM                    As String
Private m_SpInfo                       As String
Private m_HelpTop                      As Integer

'OJO HASTA ACA

Private m_Editing           As Boolean

Private m_ObjAbm            As cIABMGeneric
Private m_ObjTree           As Object

Private m_IsNew             As Boolean

Private m_BranchId          As Long
Private m_TreeId            As Long
Private m_Host              As CSMenu.cIMenuHost

Private m_Copy                            As Boolean

Private m_ItemsDeletedReportes            As String
Private m_ItemsDeleted                    As String

' Properties publicas
Public Property Get Id() As Long
  Id = m_Id
End Property

Public Property Let Id(ByVal rhs As Long)
  m_Id = rhs
End Property

Public Property Get Nombre() As String
  Nombre = m_Nombre
End Property

Public Property Let Nombre(ByVal rhs As String)
  m_Nombre = rhs
End Property

Public Property Get Nombrefisico() As String
  Nombrefisico = m_NombreFisico
End Property

Public Property Let Nombrefisico(ByVal rhs As String)
  m_NombreFisico = rhs
End Property

Public Property Get Campoid() As String
  Campoid = m_CampoId
End Property

Public Property Let Campoid(ByVal rhs As String)
  m_CampoId = rhs
End Property

Public Property Get Campocodigo() As String
  Campocodigo = m_CampoCodigo
End Property

Public Property Let Campocodigo(ByVal rhs As String)
  m_CampoCodigo = rhs
End Property

Public Property Get SqlHelp() As String
  SqlHelp = m_SqlHelp
End Property

Public Property Let SqlHelp(ByVal rhs As String)
  m_SqlHelp = rhs
End Property

Public Property Get SqlSearch() As String
  SqlSearch = m_SqlSearch
End Property

Public Property Let SqlSearch(ByVal rhs As String)
  m_SqlSearch = rhs
End Property

Public Property Get SqlHelpWeb() As String
  SqlHelpWeb = m_SqlHelpWeb
End Property

Public Property Let SqlHelpWeb(ByVal rhs As String)
  m_SqlHelpWeb = rhs
End Property

Public Property Get TieneArbol() As Integer
  TieneArbol = m_TieneArbol
End Property

Public Property Let TieneArbol(ByVal rhs As Integer)
  m_TieneArbol = rhs
End Property

Public Property Get TieneActivo() As Integer
  TieneActivo = m_TieneActivo
End Property

Public Property Let TieneActivo(ByVal rhs As Integer)
  m_TieneActivo = rhs
End Property

Public Property Get Camponombre() As String
  Camponombre = m_CampoNombre
End Property

Public Property Let Camponombre(ByVal rhs As String)
  m_CampoNombre = rhs
End Property

Public Property Get Camposinview() As String
  Camposinview = m_CamposInView
End Property

Public Property Let Camposinview(ByVal rhs As String)
  m_CamposInView = rhs
End Property

Public Property Get Where() As String
  Where = m_Where
End Property

Public Property Let Where(ByVal rhs As String)
  m_Where = rhs
End Property

Public Property Get HelpTop() As Integer
  HelpTop = m_HelpTop
End Property

Public Property Let HelpTop(ByVal rhs As Integer)
  m_HelpTop = rhs
End Property

Public Property Get ObjectEdit() As String
   ObjectEdit = m_ObjectEdit
End Property

Public Property Let ObjectEdit(ByVal rhs As String)
   m_ObjectEdit = rhs
End Property

Public Property Get ObjectABM() As String
   ObjectABM = m_ObjectABM
End Property

Public Property Let ObjectABM(ByVal rhs As String)
   m_ObjectABM = rhs
End Property

' Properties privadas
' funciones publicas

' Implementacion de cIABMClient
Private Function cIABMClient_Copy() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True
  
  With m_ObjAbm.Properties(cscTblNombre)
    .Value = C_CopiaDe & .Value
  End With
  
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscTblNombre)
 
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

  Doc.ClientTable = csTTabla
  Doc.ClientTableID = m_Id

  cIABMClient_ShowDocDigital = Doc.ShowDocs(gDB)

  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClient_ShowDocDigital", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
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

Private Function cIABMClient_PropertyChange(ByVal Clave As Integer) As Boolean

End Function

Private Function cIABMClient_Save() As Boolean
  Dim register As cRegister
  Set register = New cRegister
  register.fieldId = cscTblId
  register.Table = csTTabla
  
  If m_Copy Then m_IsNew = True
  
  Dim IProperty As cIABMProperty
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_NOMBRE
          register.Fields.Add2 cscTblNombre, .Value, csText
        Case K_NOMBREFISICO
          register.Fields.Add2 cscTblNombreFisico, .Value, csText
        Case K_CAMPOID
          register.Fields.Add2 cscTblCampoId, .Value, csText
        Case K_CAMPOCODIGO
          register.Fields.Add2 cscTblCampoCodigo, .Value, csText
        Case K_SQLHELP
          register.Fields.Add2 cscTblSqlHelp, .Value, csText
        Case K_SQLHELPCLIENTE
          register.Fields.Add2 cscTblSqlHelpCliente, .Value, csText
        Case K_SQLSEARCH
          register.Fields.Add2 cscTblSqlSearch, .Value, csText
        Case K_SQLHELPWEB
          register.Fields.Add2 cscTblSqlHelpWeb, .Value, csText
        Case K_TIENEARBOL
          register.Fields.Add2 cscTblTieneArbol, .Value, csBoolean
        Case K_TIENEACTIVO
          register.Fields.Add2 cscTblTieneActivo, .Value, csBoolean
        Case K_CAMPONOMBRE
          register.Fields.Add2 cscTblCampoNombre, .Value, csText
        Case K_CAMPOSINVIEW
          register.Fields.Add2 cscTblCamposInView, .Value, csText
        Case K_CAMPOSINVIEWCLIENTE
          register.Fields.Add2 cscTblCamposInViewCliente, .Value, csText
        Case K_WHERE
          register.Fields.Add2 cscTblWhere, .Value, csText
        Case K_HELP_TOP
          register.Fields.Add2 cscTblHelpTop, Val(.Value), csInteger
        Case K_OBJECTEDIT
          register.Fields.Add2 cscTblobjectEdit, .Value, csText
        Case K_OBJECTABM
          register.Fields.Add2 cscTblobjectABM, .Value, csText
        Case K_SPINFO
          register.Fields.Add2 cscTblSPInfo, .Value, csText
        Case K_TBL_ID
          register.Id = Val(.Value)
      End Select
    End With
  Next

  register.Fields.HaveLastUpdate = False
  register.Fields.HaveWhoModify = False
  
  If Not register.BeginTrans(gDB) Then Exit Function
  
  If Not gDB.Save(register, m_IsNew, "cIABMClient_Save", "cTabla", c_ErrorSave) Then Exit Function
  
  m_Id = register.Id
  
  If Not pSaveItemsReportes() Then Exit Function
  If Not pSaveItems() Then Exit Function

  If Not register.CommitTrans() Then Exit Function
  
  m_Copy = False
  m_IsNew = False
  cIABMClient_Save = Load(register.Id)
End Function

Private Function pSaveItemsReportes() As Boolean
  Dim register  As cRegister
  Dim IProperty As cIABMProperty
  Dim FileEx    As CSKernelFile.cFileEx
  
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_REPORTES
        
          Dim Row  As cIABMGridRow
          Dim Cell As cIABMGridCellValue
          
          For Each Row In IProperty.Grid.Rows
          
            Set register = New cRegister
            register.fieldId = cscrptfId
            register.Table = csTReporteFormulario
            register.Id = csNew
            
            For Each Cell In Row
              Select Case Cell.Key
                
                Case KI_RPTF_ID
                  If Not m_Copy Then
                    register.Id = Val(Cell.Value)
                  End If
                Case KI_NOMBRE
                  register.Fields.Add2 cscrptfNombre, Cell.Value, csText
                Case KI_CSRFILE
                  Set FileEx = New CSKernelFile.cFileEx
                  register.Fields.Add2 cscrptfCsrfile, FileEx.FileGetName(Cell.Value), csText
                Case KI_SUGERIDO
                  register.Fields.Add2 cscrptfSugerido, Cell.Id, csBoolean
                Case KI_RPT_OBJ
                  register.Fields.Add2 cscrptfObject, Cell.Value, csText
              End Select
            Next
            
            register.Fields.Add2 cscrptfTipo, csRptFMaestro, csInteger
            register.Fields.Add2 cscrptfCopias, 1, csInteger
            register.Fields.Add2 cscrptfDocImprimirEnAlta, 0, csBoolean
            register.Fields.Add2 cscActivo, -1, csBoolean
            register.Fields.Add2 cscTblId, m_Id, csId
            
            register.Fields.HaveLastUpdate = True
            register.Fields.HaveWhoModify = True
            
            If Not gDB.Save(register, , "pSaveItemsReportes", C_Module, c_ErrorSave) Then Exit Function
          Next
      End Select
    End With
  Next
  
  Dim sqlstmt As String
  
  If LenB(m_ItemsDeletedReportes) And Not m_Copy Then
    m_ItemsDeletedReportes = RemoveLastColon(m_ItemsDeletedReportes)
    sqlstmt = "delete reporteFormulario where rptf_id in (" & m_ItemsDeletedReportes & ")"
  
    If Not gDB.Execute(sqlstmt, "pSaveItemsReportes", C_Module) Then Exit Function
  End If
  
  pSaveItemsReportes = True
End Function

Private Function pSaveItems() As Boolean
  Dim register As cRegister
  Dim IProperty As cIABMProperty
  
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_CAMPOS_ADD
        
          Dim Row  As cIABMGridRow
          Dim Cell As cIABMGridCellValue
          
          For Each Row In IProperty.Grid.Rows
          
            Set register = New cRegister
            register.fieldId = cscTbliId
            register.Table = csTTablaItem
            register.Id = csNew
            
            For Each Cell In Row
              Select Case Cell.Key
                
                Case KI_TBLI_ID
                  register.Id = Val(Cell.Value)
                Case KI_NOMBRE
                  register.Fields.Add2 cscTbliNombre, Cell.Value, csText
                Case KI_NOMBREFISICO
                  register.Fields.Add2 cscTbliNombrefisico, Cell.Value, csText
                Case KI_TIPO
                  register.Fields.Add2 cscTbliTipo, Cell.Id, csInteger
                Case KI_SUBTIPO
                  register.Fields.Add2 cscTbliSubtipo, Cell.Id, csInteger
                Case KI_ORDEN
                  register.Fields.Add2 cscTbliOrden, Cell.Value, csInteger
                Case KI_TBL_ID_HELP
                  register.Fields.Add2 cscTblIdHelp, Cell.Id, csId
                Case KI_HELPTYPE
                  register.Fields.Add2 cscTbliHelptype, Cell.Id, csInteger
                Case KI_FILTRO
                  register.Fields.Add2 cscTbliFiltro, Cell.Value, csText
                Case KI_DEFAULTVALUE
                  register.Fields.Add2 cscTbliDefaultvalue, Cell.Value, csText
                Case KI_MINVALUE
                  register.Fields.Add2 cscTbliMinvalue, Cell.Value, csText
                Case KI_MAXVALUE
                  register.Fields.Add2 cscTbliMaxvalue, Cell.Value, csText
                Case KI_TEXTALIGN
                  register.Fields.Add2 cscTbliTextalign, Cell.Id, csInteger
                Case KI_TEXTMASK
                  register.Fields.Add2 cscTbliTextmask, Cell.Value, csText
                Case KI_FORMAT
                  register.Fields.Add2 cscTbliFormat, Cell.Value, csText
                Case KI_WIDTH
                  register.Fields.Add2 cscTbliWidth, Cell.Value, csInteger
                Case KI_HEIGHT
                  register.Fields.Add2 cscTbliHeight, Cell.Value, csInteger
                Case KI_TOP
                  register.Fields.Add2 cscTbliTop, Cell.Value, csInteger
                Case KI_LEFT
                  register.Fields.Add2 cscTbliLeft, Cell.Value, csInteger
                Case KI_NOSHOWBUTTON
                  register.Fields.Add2 cscTbliNoshowbutton, Cell.Id, csBoolean
                Case KI_SQLSTMT
                  register.Fields.Add2 cscTbliSqlstmt, Cell.Value, csText
                
              End Select
            Next
            
            register.Fields.Add2 cscTblId, m_Id, csId
            
            register.Fields.HaveLastUpdate = False
            register.Fields.HaveWhoModify = False
            
            If Not gDB.Save(register, , "pSaveItems", C_Module, c_ErrorSave) Then Exit Function
          Next
      End Select
    End With
  Next
  
  Dim sqlstmt As String
  
  If m_ItemsDeleted <> "" Then
    m_ItemsDeleted = RemoveLastColon(m_ItemsDeleted)
    sqlstmt = "delete " & csTTablaItem & " where tbli_id in (" & m_ItemsDeleted & ")"
  
    If Not gDB.Execute(sqlstmt, "pSaveItems", C_Module) Then Exit Function
  End If
  
  pSaveItems = True
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
    cIABMClient_Title = LNGGetText(1430, vbNullString) 'Tablas
End Property

Private Function cIABMClient_Validate() As Boolean

  Dim IProperty As cIABMProperty

  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_TBL_ID
          If ValEmpty(.Value, csInteger) Then
            MsgInfo LNGGetText(2767, vbNullString) 'Debe indicar un ID
            Exit Function
          End If
        Case K_NOMBRE
          If ValEmpty(.Value, csText) Then
            MsgInfo LNGGetText(1007, vbNullString) 'Debe indicar un nombre
            Exit Function
          End If
        Case K_NOMBREFISICO
          If ValEmpty(.Value, csText) Then
            MsgInfo LNGGetText(2781, vbNullString) 'Debe indicar un nombre físico
            Exit Function
          End If
        Case K_CAMPOID
          If ValEmpty(.Value, csText) Then
            MsgInfo LNGGetText(2782, vbNullString) 'Debe indicar un campo Id
            Exit Function
          End If
        Case K_CAMPOCODIGO
          If ValEmpty(.Value, csText) Then
            MsgInfo LNGGetText(2783, vbNullString) 'Debe indicar un campo código
            Exit Function
          End If
'        Case K_SQLHELP
'          If ValEmpty(.Value, csText) Then
'            MsgInfo "Debe indicar un sqlhelp"
'            Exit Function
'          End If
'        Case K_TIENEARBOL
'          If ValEmpty(.Value, csInteger) Then
'            MsgInfo "Debe indicar un tienearbol"
'            Exit Function
'          End If
        Case K_CAMPONOMBRE
          If ValEmpty(.Value, csText) Then
            MsgInfo LNGGetText(2784, vbNullString) 'Debe indicar un campo Nombre
            Exit Function
          End If
'        Case K_CAMPOSINVIEW
'          If ValEmpty(.Value, csText) Then
'            MsgInfo "Debe indicar un camposinview"
'            Exit Function
'          End If
'        Case K_WHERE
'          If ValEmpty(.Value, csText) Then
'            MsgInfo "Debe indicar un where"
'            Exit Function
'          End If

      End Select
    End With
  Next

  cIABMClient_Validate = True
End Function

Private Function cIABMClientGrid_ColumnAfterEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long) As Boolean
  cIABMClientGrid_ColumnAfterEdit = True
End Function

Private Function cIABMClientGrid_ColumnAfterUpdate(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long) As Boolean
  cIABMClientGrid_ColumnAfterUpdate = True
End Function

Private Function cIABMClientGrid_ColumnBeforeEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean
  cIABMClientGrid_ColumnBeforeEdit = True
End Function

Private Function cIABMClientGrid_ColumnButtonClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean
  cIABMClientGrid_ColumnButtonClick = True
End Function

Private Sub cIABMClientGrid_ColumnCancelEdit(ByVal Key As Integer)

End Sub

Private Sub cIABMClientGrid_ColumnClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Sub cIABMClientGrid_DblClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Function cIABMClientGrid_DeleteRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal lRow As Long) As Boolean
  Dim Id As Long
  
  Select Case Key
    
    Case K_REPORTES
      Id = Val(pCell(Row, KI_RPTF_ID).Value)
      If Id <> csNO_ID Then m_ItemsDeletedReportes = m_ItemsDeletedReportes & Id & ","
    
    Case K_CAMPOS_ADD
      Id = Val(pCell(Row, KI_TBLI_ID).Value)
      If Id <> csNO_ID Then m_ItemsDeleted = m_ItemsDeleted & Id & ","
  
  End Select
  
  cIABMClientGrid_DeleteRow = True
End Function

Private Function cIABMClientGrid_IsEmptyRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_REPORTES
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowReportes(Row, RowIndex)
    Case K_CAMPOS_ADD
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowItems(Row, RowIndex)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ValidateRow", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIABMClientGrid_ListAdHock(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal ColIndex As Long, List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClientGrid_NewRow(ByVal Key As Integer, ByVal Rows As Integer)

End Sub

Private Function cIABMClientGrid_ValidateRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_REPORTES
      cIABMClientGrid_ValidateRow = pValidateRowReportes(Row, RowIndex)
    Case K_CAMPOS_ADD
      cIABMClientGrid_ValidateRow = pValidateRowItems(Row, RowIndex)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ValidateRow", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

' Implementacion de cIEditGeneric

Private Property Get cIEditGeneric_ObjAbm() As CSInterfacesABM.cIABMGeneric
  Set cIEditGeneric_ObjAbm = m_ObjAbm
End Property

Private Function cIEditGeneric_TabClick(ByVal Index As Integer) As Boolean

End Function

Private Property Let cIEditGeneric_TreeId(ByVal rhs As Long)
    m_TreeId = rhs
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
    cIEditGeneric_ShowList = CSOAPI2.SecurityCanAccess(csPreOListTabla)
End Function

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
    Set m_ObjAbm = rhs
End Property

Private Property Get cIEditGeneric_Editing() As Boolean
    cIEditGeneric_Editing = m_Editing
End Property

Private Function cIEditGeneric_Delete(Id As Long) As Boolean
    If Not CSOAPI2.SecurityCanAccess(csPreODeleteTabla) Then Exit Function

    Dim sqlstmt As String
    
    sqlstmt = "Delete ReporteFormulario where tbl_id = " & Id & vbCrLf _
              & "Delete Tabla where tbl_id = " & Id
    
    cIEditGeneric_Delete = gDB.Execute(sqlstmt, "cIEditGeneric_Delete", "cTabla")
End Function

Private Function cIEditGeneric_Search(Id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Id = csNO_ID Then
    m_IsNew = True
    If Not CSOAPI2.SecurityCanAccess(csPreONewTabla) Then Exit Function
  Else
    m_IsNew = False
    If Not CSOAPI2.SecurityCanAccess(csPreOEditTabla) Then Exit Function
  End If
  
  m_ObjAbm.InModalWindow = InModalWindow
  
  If Not Load(Id) Then Exit Function
  
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
  MngError Err, "cIEditGeneric_Edit", "cTabla", vbNullString
End Function

Private Function cIEditGeneric_PrintObj(ByVal Id As Long) As Boolean

End Function

Private Property Set cIEditGeneric_ObjTree(rhs As Object)
    Set m_ObjTree = rhs
End Property

Private Property Let cIEditGeneric_BranchId(ByVal rhs As Long)
    m_BranchId = rhs
End Property

Private Property Get cIEditGeneric_BranchId() As Long
    cIEditGeneric_BranchId = m_BranchId
End Property

Private Function cIEditGeneric_Preview(ByVal Id As Long) As Boolean

End Function

Private Function cIEditGeneric_PropertyChange(ByVal Key As Integer) As Boolean

End Function
Private Function cIMenuClient_Initialize(f As Object, Host As CSMenu.cIMenuHost) As Boolean
  On Error GoTo ControlError
  Set m_Host = Host
                        '&Tablas
  m_Host.Server.AddMenu LNGGetText(2785, vbNullString), csPreOListTabla + 500, LNGGetText(2703, vbNullString), 0, True, False, False, False, False, Me
                                                                                'S&istema
  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, "cIMenuClient_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal Id As Long) As Variant
  m_Host.MenuABMClick "CSOAPIEdit.cTabla", Me, LNGGetText(1430, vbNullString), 0, csETablesOAPI.csTabla
                                                'Tablas
End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  
  Dim c As cIABMProperty
     
  With m_ObjAbm.Tabs
    
    .Clear
  
    With .Add(Nothing)
      .Index = 0
      .Name = C_strGeneral
    End With
      
    With .Add(Nothing)
      .Index = 1
      .Name = LNGGetText(2272, vbNullString)  'Help
    End With
            
    With .Add(Nothing)
      .Index = 2
      .Name = LNGGetText(2786, vbNullString)  'Vista
    End With
            
    With .Add(Nothing)
      .Index = 3
      .Name = LNGGetText(4747, vbNullString)  'Vista Usuario
    End With
      
    With .Add(Nothing)
      .Index = 4
      .Name = LNGGetText(4746, vbNullString)  'Help Usuario
    End With
            
    With .Add(Nothing)
      .Index = 5
      .Name = LNGGetText(4748, vbNullString)  'Campos Adicionales
    End With
            
    With .Add(Nothing)
      .Index = 6
      .Name = LNGGetText(2577, vbNullString)  'Reportes
    End With
  
  End With
  
  With m_ObjAbm.Properties
    
    .Clear
  
    With .Add(Nothing, cscTblId)
      .PropertyType = cspNumeric
      .SubType = cspInteger
      .Name = LNGGetText(2773, vbNullString)  'ID
      .Key = K_TBL_ID
      .Width = 800
      .Value = Id
    End With
    
    With .Add(Nothing, cscTblNombre)
      .PropertyType = cspText
      .Name = C_strNombre
      .Size = 50
      .Key = K_NOMBRE
      .Value = Nombre
    End With
      
    With .Add(Nothing, cscTblNombreFisico)
      .PropertyType = cspText
      .Name = LNGGetText(2787, vbNullString)  'Nombre Físico
      .Size = 50
      .Key = K_NOMBREFISICO
      .Value = Nombrefisico
    End With
      
    With .Add(Nothing, cscTblCampoId)
      .PropertyType = cspText
      .Name = LNGGetText(2788, vbNullString)  'Campo Id
      .Size = 50
      .Key = K_CAMPOID
      .Value = Campoid
    End With
      
    With .Add(Nothing, cscTblCampoCodigo)
      .PropertyType = cspText
      .Name = LNGGetText(2789, vbNullString)  'Campo Código
      .Size = 50
      .Key = K_CAMPOCODIGO
      .Value = Campocodigo
    End With
    
    With .Add(Nothing, cscTblCampoNombre)
      .PropertyType = cspText
      .Name = LNGGetText(2790, vbNullString)  'Campo Nombre
      .Size = 50
      .Key = K_CAMPONOMBRE
      .Value = Camponombre
    End With
      
    With .Add(Nothing, cscTblobjectEdit)
      .PropertyType = cspText
      .TopFromProperty = cscTblId
      .Left = 6000
      .Name = LNGGetText(2775, vbNullString)  'Objeto Edición
      .Size = 255
      .Key = K_OBJECTEDIT
      .Value = ObjectEdit
      .Width = 3000
    End With
      
    With .Add(Nothing, cscTblobjectABM)
      .PropertyType = cspText
      .Name = LNGGetText(2791, vbNullString)  'Objeto ABM
      .Size = 255
      .Key = K_OBJECTABM
      .Value = ObjectABM
      .Width = 3000
    End With
      
    With .Add(Nothing, cscTblSPInfo)
      .PropertyType = cspText
      .Name = LNGGetText(2792, vbNullString)  'SP Info
      .Size = 255
      .Key = K_SPINFO
      .Value = m_SpInfo
    End With
      
    With .Add(Nothing, cscTblTieneArbol)
      .PropertyType = cspCheck
      .Width = 500
      .Name = LNGGetText(2793, vbNullString)  'Tiene Arbol
      .Key = K_TIENEARBOL
      .Value = TieneArbol
    End With
    
    With .Add(Nothing, cscTblTieneActivo)
      .PropertyType = cspCheck
      .Width = 500
      .Name = LNGGetText(2794, vbNullString)  'Tiene Activo
      .Key = K_TIENEACTIVO
      .Value = TieneActivo
    End With
      
    With .Add(Nothing)
      .PropertyType = cspLabel
      .Value = LNGGetText(2795, vbNullString)
                'Debe indicarse un sp o una sentencia select completa.  & _
                Importante: Si se indica un valor para sqlHelp, no se utiliza el campo & _
                where para componer la sentencia de help.
      .Width = 9100
      .Height = 600
      .TabIndex = 1
    End With
    
    With .Add(Nothing, cscTblSqlHelp)
      .PropertyType = cspText
      .Name = LNGGetText(2796, vbNullString) 'sqlHelp
      .FontName = "Courier New"
      .SubType = cspMemo
      .Width = 9100
      .Height = 700
      .TabIndex = 1
      .Key = K_SQLHELP
      .Value = SqlHelp
    End With
    
    With .Add(Nothing, cscTblSqlSearch)
      .PropertyType = cspText
      .Name = LNGGetText(3483, vbNullString) 'sqlSearch
      .FontName = "Courier New"
      .SubType = cspMemo
      .Width = 9100
      .Height = 700
      .TabIndex = 1
      .Key = K_SQLSEARCH
      .Value = SqlSearch
    End With
    
    With .Add(Nothing, cscTblSqlHelpWeb)
      .PropertyType = cspText
      .Name = LNGGetText(2797, vbNullString) 'sqlHelpWeb
      .FontName = "Courier New"
      .SubType = cspMemo
      .Width = 9100
      .Height = 500
      .TabIndex = 1
      .Key = K_SQLHELPWEB
      .Value = SqlHelpWeb
    End With
    
    With .Add(Nothing)
      .PropertyType = cspLabel
      .Value = LNGGetText(2798, vbNullString)
                'Se utiliza para componer la sentencia select de los helps. & _
                El codigo formará: select {campo id}, {campo nombre}, {campo código} from {nombre físico} where {where}
      .Width = 9100
      .Height = 600
      .TabIndex = 1
    End With
    
    With .Add(Nothing, cscTblWhere)
      .PropertyType = cspText
      .Name = LNGGetText(2799, vbNullString) 'Where
      .FontName = "Courier New"
      .SubType = cspMemo
      .Width = 9100
      .Height = 1000
      .Key = K_WHERE
      .TabIndex = 1
      .Value = Where
    End With
    
    With .Add(Nothing, cscTblHelpTop)
      .PropertyType = cspNumeric
      .Name = LNGGetText(2800, vbNullString) 'Top
      .SubType = cspInteger
      .Key = K_HELP_TOP
      .TabIndex = 1
      .TopFromProperty = cscTblWhere
      .TopToPrevious = -440
      .LeftLabel = -600
      .Left = 9500
      .Value = HelpTop
    End With
      
    With .Add(Nothing, cscTblCamposInView)
      .PropertyType = cspText
      .Name = LNGGetText(2801, vbNullString) 'Campos Vista
      .FontName = "Courier New"
      .SubType = cspMemo
      .Width = 9100
      .Height = 4000
      .Key = K_CAMPOSINVIEW
      .TabIndex = 2
      .Value = Camposinview
    End With
      
    With .Add(Nothing, cscTblCamposInViewCliente)
      .PropertyType = cspText
      .Name = LNGGetText(2801, vbNullString) 'Campos Vista
      .FontName = "Courier New"
      .SubType = cspMemo
      .Width = 9100
      .Height = 4000
      .Key = K_CAMPOSINVIEWCLIENTE
      .TabIndex = 3
      .Value = m_CamposInViewCliente
    End With
      
    With .Add(Nothing)
      .PropertyType = cspLabel
      .Value = LNGGetText(2795, vbNullString)
                'Debe indicarse un sp o una sentencia select completa.  & _
                Importante: Si se indica un valor para sqlHelp, no se utiliza el campo & _
                where para componer la sentencia de help.
      .Width = 9100
      .Height = 600
      .TabIndex = 4
    End With
    
    With .Add(Nothing, cscTblSqlHelpCliente)
      .PropertyType = cspText
      .Name = LNGGetText(2796, vbNullString) 'sqlHelp
      .FontName = "Courier New"
      .SubType = cspMemo
      .Width = 9100
      .Height = 700
      .TabIndex = 4
      .Key = K_SQLHELPCLIENTE
      .Value = m_SqlHelpCliente
    End With
      
    Set c = .Add(Nothing, c_campos_add)
    With c
        .PropertyType = cspGrid
        .LeftLabel = -1
        If Not pLoadItems(c) Then Exit Function
        .Name = c_campos_add
        .Key = K_CAMPOS_ADD
        .TabIndex = 5
        .GridAdd = True
        .GridEdit = True
        .GridRemove = True
    End With
      
    m_ItemsDeleted = vbNullString
      
    Set c = .Add(Nothing, c_reportes)
    With c
        .PropertyType = cspGrid
        .LeftLabel = -1
        If Not pLoadReportes(c) Then Exit Function
        .Name = c_reportes
        .Key = K_REPORTES
        .TabIndex = 6
        .GridAdd = True
        .GridEdit = True
        .GridRemove = True
    End With
    
    m_ItemsDeletedReportes = vbNullString
    
  End With

  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  AbmObj.MinHeight = 7500
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

Private Function Load(ByVal Id As Long) As Boolean

  Dim sqlstmt As String

  sqlstmt = "select * from tabla where tbl_id = " & Id

  Dim rs As Recordset

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "Load", "cTabla") Then Exit Function

  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.Fields, cscTblId)
    m_Nombre = gDB.ValField(rs.Fields, cscTblNombre)
    m_NombreFisico = gDB.ValField(rs.Fields, cscTblNombreFisico)
    m_CampoId = gDB.ValField(rs.Fields, cscTblCampoId)
    m_CampoCodigo = gDB.ValField(rs.Fields, cscTblCampoCodigo)
    m_SqlHelp = gDB.ValField(rs.Fields, cscTblSqlHelp)
    m_SqlHelpCliente = gDB.ValField(rs.Fields, cscTblSqlHelpCliente)
    m_SqlSearch = gDB.ValField(rs.Fields, cscTblSqlSearch)
    m_SqlHelpWeb = gDB.ValField(rs.Fields, cscTblSqlHelpWeb)
    m_TieneArbol = gDB.ValField(rs.Fields, cscTblTieneArbol)
    m_TieneActivo = gDB.ValField(rs.Fields, cscTblTieneActivo)
    m_CampoNombre = gDB.ValField(rs.Fields, cscTblCampoNombre)
    m_CamposInView = gDB.ValField(rs.Fields, cscTblCamposInView)
    m_CamposInViewCliente = gDB.ValField(rs.Fields, cscTblCamposInViewCliente)
    m_Where = gDB.ValField(rs.Fields, cscTblWhere)
    m_ObjectABM = gDB.ValField(rs.Fields, cscTblobjectABM)
    m_ObjectEdit = gDB.ValField(rs.Fields, cscTblobjectEdit)
    m_SpInfo = gDB.ValField(rs.Fields, cscTblSPInfo)
    m_HelpTop = gDB.ValField(rs.Fields, cscTblHelpTop)

  Else
    m_Id = csNO_ID
    m_Nombre = vbNullString
    m_NombreFisico = vbNullString
    m_CampoId = vbNullString
    m_CampoCodigo = vbNullString
    m_SqlHelp = vbNullString
    m_SqlHelpCliente = vbNullString
    m_SqlSearch = vbNullString
    m_SqlHelpWeb = vbNullString
    m_TieneArbol = False
    m_TieneActivo = False
    m_CampoNombre = vbNullString
    m_CamposInView = vbNullString
    m_CamposInViewCliente = vbNullString
    m_Where = vbNullString
    m_ObjectABM = vbNullString
    m_ObjectEdit = vbNullString
    m_SpInfo = vbNullString
    m_HelpTop = 0
  End If

  Load = True
End Function

Private Function pLoadReportes(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  
  Dim rs As ADODB.Recordset
  
  sqlstmt = "select ReporteFormulario.* from ReporteFormulario " & _
              " where tbl_id = " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadReportes", C_Module) Then Exit Function
  
  Dim o As cIABMGridColumn
  
  Propiedad.Grid.Columns.Clear
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = "rptf_id"
  o.Visible = False
  o.Key = KI_RPTF_ID
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = C_strNombre
  o.PropertyType = cspText
  o.Width = 2000
  o.Key = KI_NOMBRE
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = LNGGetText(2572, vbNullString) 'Archivo CSR
  o.PropertyType = cspFile
  o.Width = 2000
  o.HelpFilter = LNGGetText(2802, vbNullString) 'Reportes|*.csr
  o.Key = KI_CSRFILE
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = LNGGetText(2573, vbNullString) 'Sugerido
  o.PropertyType = cspCheck
  o.Width = 800
  o.Key = KI_SUGERIDO
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = LNGGetText(2576, vbNullString) 'Objeto ActiveX
  o.PropertyType = cspText
  o.Width = 2000
  o.Key = KI_RPT_OBJ
  
  Dim f  As cIABMGridRow
  Dim fv As cIABMGridCellValue
  
  Propiedad.Grid.Rows.Clear
  
  While Not rs.EOF
  
    Set f = Propiedad.Grid.Rows.Add(Nothing, rs(cscrptfId).Value)
    
    Set fv = f.Add(Nothing)
    fv.Value = rs(cscrptfId).Value
    fv.Key = KI_RPTF_ID
    
    Set fv = f.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscrptfNombre)
    fv.Key = KI_NOMBRE
    
    Set fv = f.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscrptfCsrfile)
    fv.Key = KI_CSRFILE
    
    Set fv = f.Add(Nothing)
    fv.Id = gDB.ValField(rs.Fields, cscrptfSugerido)
    fv.Key = KI_SUGERIDO
    
    Set fv = f.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscrptfObject)
    fv.Key = KI_RPT_OBJ
    
    rs.MoveNext
  Wend
  
  pLoadReportes = True
End Function

Private Function pLoadItems(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  
  Dim rs As ADODB.Recordset
  
  sqlstmt = "select tbli.*, tbl_nombre "
  sqlstmt = sqlstmt & " from TablaItem tbli left join Tabla tbl on tbli.tbl_id_help = tbl.tbl_id"
  sqlstmt = sqlstmt & " where tbli.tbl_id = " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadItems", C_Module) Then Exit Function
  
  
  With Propiedad.Grid.Columns
  
    With .Add(Nothing)
      .Visible = False
      .Key = KI_TBLI_ID
    End With
    
    With .Add(Nothing)
      .Name = C_strNombre
      .PropertyType = cspText
      .Width = 1200
      .Key = KI_NOMBRE
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(4750, vbNullString) ' "Nombre Fisico"
      .PropertyType = cspText
      .Width = 1200
      .Key = KI_NOMBREFISICO
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(4751, vbNullString) ' "Tipo"
      .PropertyType = cspList
  
      With .List.Add(Nothing)
        .Id = cspCheck
        .Value = LNGGetText(2271, vbNullString)  'CheckBox
      End With
      
      With .List.Add(Nothing)
        .Id = cspDate
        .Value = LNGGetText(1569, vbNullString)  'Fecha
      End With
      
      With .List.Add(Nothing)
        .Id = cspHelp
        .Value = LNGGetText(2272, vbNullString)  'Help
      End With
      
      With .List.Add(Nothing)
        .Id = cspList
        .Value = LNGGetText(2273, vbNullString)  'Lista
      End With
      
      With .List.Add(Nothing)
        .Id = cspNumeric
        .Value = LNGGetText(2274, vbNullString)  'Numerico
      End With
      
      With .List.Add(Nothing)
        .Id = cspText
        .Value = LNGGetText(1005, vbNullString)  'Texto
      End With
    
      With .List.Add(Nothing)
        .Id = cspSqlstmt
        .Value = LNGGetText(2276, vbNullString)  'sqlstmt
      End With
        
      With .List.Add(Nothing)
        .Id = cspFile
        .Value = LNGGetText(4768, vbNullString)  'File
      End With
        
      With .List.Add(Nothing)
        .Id = cspFolder
        .Value = LNGGetText(4769, vbNullString)  'Folder
      End With
        
      With .List.Add(Nothing)
        .Id = cspImage
        .Value = LNGGetText(4770, vbNullString)  'Image
      End With
        
      With .List.Add(Nothing)
        .Id = cspLabel
        .Value = LNGGetText(4771, vbNullString)  'Label
      End With
        
      .Width = 1200
      .Key = KI_TIPO
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(4752, vbNullString) ' "Sub Tipo"
      .PropertyType = cspList
      
      With .List.Add(Nothing)
        .Id = cspCuit
        .Value = LNGGetText(1179, vbNullString)  'CUIT
      End With
      With .List.Add(Nothing)
        .Id = cspDouble
        .Value = LNGGetText(4772, vbNullString)  'Double
      End With
      With .List.Add(Nothing)
        .Id = cspInteger
        .Value = LNGGetText(4773, vbNullString)  'Integer
      End With
      With .List.Add(Nothing)
        .Id = cspMask
        .Value = LNGGetText(4774, vbNullString)  'Mask
      End With
      With .List.Add(Nothing)
        .Id = cspMemo
        .Value = LNGGetText(4775, vbNullString)  'Memo
      End With
      With .List.Add(Nothing)
        .Id = cspMoney
        .Value = LNGGetText(4776, vbNullString)  'Money
      End With
      With .List.Add(Nothing)
        .Id = cspPercent
        .Value = LNGGetText(4777, vbNullString)  'Percent
      End With
      With .List.Add(Nothing)
        .Id = cspTextButton
        .Value = LNGGetText(4778, vbNullString)  'TextButton
      End With
      With .List.Add(Nothing)
        .Id = cspTextButtonEx
        .Value = LNGGetText(4779, vbNullString)  'TextButtonEx
      End With
      
      .Width = 1200
      .Key = KI_SUBTIPO
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(4753, vbNullString) ' "Orden"
      .PropertyType = cspNumeric
      .SubType = cspInteger
      .Width = 1200
      .Key = KI_ORDEN
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(4754, vbNullString) ' "Tabla"
      .PropertyType = cspHelp
      .Table = csTabla
      .Width = 3500
      .Key = KI_TBL_ID_HELP
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(4755, vbNullString) ' "Tipo Help"
      .PropertyType = cspList
      
      With .List.Add(Nothing)
        .Id = csNormal
        .Value = LNGGetText(4781, vbNullString)  'Normal
      End With
      With .List.Add(Nothing)
        .Id = csMultiSelect
        .Value = LNGGetText(4780, vbNullString)  'Multi Select
      End With
      With .List.Add(Nothing)
        .Id = csTree
        .Value = LNGGetText(4782, vbNullString)  'Tree
      End With
      
      .Width = 1200
      .Key = KI_HELPTYPE
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(4756, vbNullString) ' "Filtro"
      .PropertyType = cspText
      .Width = 1200
      .Key = KI_FILTRO
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(4757, vbNullString) ' "Valor por Defecto"
      .PropertyType = cspText
      .Width = 1200
      .Key = KI_DEFAULTVALUE
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(4758, vbNullString) ' "Valor Minimo"
      .PropertyType = cspText
      .Width = 1200
      .Key = KI_MINVALUE
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(4759, vbNullString) ' "Valor Maximo"
      .PropertyType = cspText
      .Width = 1200
      .Key = KI_MAXVALUE
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(4760, vbNullString) ' "Alineacion"
      .PropertyType = cspList
      With .List.Add(Nothing)
        .Id = vbLeftJustify
        .Value = LNGGetText(4783, vbNullString)  'Izquierda
      End With
      With .List.Add(Nothing)
        .Id = vbCenter
        .Value = LNGGetText(4784, vbNullString)  'Centrado
      End With
      With .List.Add(Nothing)
        .Id = vbRightJustify
        .Value = LNGGetText(4785, vbNullString)  'Derecha
      End With
      .Width = 1200
      .Key = KI_TEXTALIGN
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(4761, vbNullString) ' "Mascara"
      .PropertyType = cspText
      .Width = 1200
      .Key = KI_TEXTMASK
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(4762, vbNullString) ' "Formato"
      .PropertyType = cspText
      .Width = 1200
      .Key = KI_FORMAT
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(4763, vbNullString) ' "Ancho"
      .PropertyType = cspNumeric
      .SubType = cspInteger
      .Width = 1200
      .Key = KI_WIDTH
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(4764, vbNullString) ' "Alto"
      .PropertyType = cspNumeric
      .SubType = cspInteger
      .Width = 1200
      .Key = KI_HEIGHT
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(4765, vbNullString) ' "Top"
      .PropertyType = cspNumeric
      .SubType = cspInteger
      .Width = 1200
      .Key = KI_TOP
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(4766, vbNullString) ' "Left"
      .PropertyType = cspNumeric
      .SubType = cspInteger
      .Width = 1200
      .Key = KI_LEFT
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(4767, vbNullString) ' "No mostrar botón"
      .PropertyType = cspCheck
      .Width = 1200
      .Key = KI_NOSHOWBUTTON
    End With
  
    With .Add(Nothing)
      .Name = LNGGetText(2276, vbNullString) ' "sqlstmt"
      .PropertyType = cspText
      .SubType = cspTextButtonEx
      .Width = 1200
      .Key = KI_SQLSTMT
    End With
  
  End With
  
  Dim f  As cIABMGridRow
  Dim fv As cIABMGridCellValue
  
  While Not rs.EOF
  
    Set f = Propiedad.Grid.Rows.Add(Nothing, rs(cscTbliId).Value)
    
    Set fv = f.Add(Nothing)
    fv.Value = rs(cscTbliId).Value
    fv.Key = KI_TBLI_ID
            
    Set fv = f.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscTbliNombre)
    fv.Key = KI_NOMBRE
    
    Set fv = f.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscTbliNombrefisico)
    fv.Key = KI_NOMBREFISICO
    
    Set fv = f.Add(Nothing)
    fv.Id = gDB.ValField(rs.Fields, cscTbliTipo)
    fv.Key = KI_TIPO
    
    Set fv = f.Add(Nothing)
    fv.Id = gDB.ValField(rs.Fields, cscTbliSubtipo)
    fv.Key = KI_SUBTIPO
    
    Set fv = f.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscTbliOrden)
    fv.Key = KI_ORDEN
    
    Set fv = f.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscTblNombre)
    fv.Id = gDB.ValField(rs.Fields, cscTblIdHelp)
    fv.Key = KI_TBL_ID_HELP
    
    Set fv = f.Add(Nothing)
    fv.Id = gDB.ValField(rs.Fields, cscTbliHelptype)
    fv.Key = KI_HELPTYPE
    
    Set fv = f.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscTbliFiltro)
    fv.Key = KI_FILTRO
    
    Set fv = f.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscTbliDefaultvalue)
    fv.Key = KI_DEFAULTVALUE
    
    Set fv = f.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscTbliMinvalue)
    fv.Key = KI_MINVALUE
    
    Set fv = f.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscTbliMaxvalue)
    fv.Key = KI_MAXVALUE
    
    Set fv = f.Add(Nothing)
    fv.Id = gDB.ValField(rs.Fields, cscTbliTextalign)
    fv.Key = KI_TEXTALIGN
    
    Set fv = f.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscTbliTextmask)
    fv.Key = KI_TEXTMASK
    
    Set fv = f.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscTbliFormat)
    fv.Key = KI_FORMAT
    
    Set fv = f.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscTbliWidth)
    fv.Key = KI_WIDTH
    
    Set fv = f.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscTbliHeight)
    fv.Key = KI_HEIGHT
    
    Set fv = f.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscTbliTop)
    fv.Key = KI_TOP
    
    Set fv = f.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscTbliLeft)
    fv.Key = KI_LEFT
    
    Set fv = f.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscTbliNoshowbutton)
    fv.Key = KI_NOSHOWBUTTON
    
    Set fv = f.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscTbliSqlstmt)
    fv.Key = KI_SQLSTMT
    
    rs.MoveNext
  Wend
  
  pLoadItems = True
End Function

Private Function pValidateRowReportes(Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_NOMBRE
        If ValEmpty(Cell.Value, csText) Then
          MsgInfo LNGGetText(1811, vbNullString, strRow) 'Debe indicar un nombre (1)
          Exit Function
        End If
      Case KI_CSRFILE
        If ValEmpty(Cell.Value, csText) Then
          MsgInfo LNGGetText(2579, vbNullString, strRow) 'Debe indicar un archivo CSR (1)
          Exit Function
        End If
    End Select
  Next
  
  pValidateRowReportes = True
End Function

Private Function pValidateRowItems(Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_NOMBRE
        If ValEmpty(Cell.Value, csText) Then
          MsgInfo LNGGetText(1811, vbNullString, strRow) 'Debe indicar un nombre (1)
          Exit Function
        End If
      Case KI_NOMBREFISICO
        If ValEmpty(Cell.Value, csText) Then
          MsgInfo LNGGetText(4749, vbNullString, strRow) 'Debe indicar un nombre fisico (1)
          Exit Function
        End If
    End Select
  Next
  
  pValidateRowItems = True
End Function

Private Function pIsEmptyRowReportes(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  Dim bRowIsEmpty           As Boolean
  
  strRow = " (Fila " & RowIndex & ")"
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_NOMBRE
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KI_CSRFILE
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowReportes = bRowIsEmpty
End Function

Private Function pIsEmptyRowItems(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  Dim bRowIsEmpty           As Boolean
  
  strRow = " (Fila " & RowIndex & ")"
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_NOMBRE
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowItems = bRowIsEmpty
End Function

Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  c_ErrorSave = LNGGetText(2803, vbNullString) 'Error al grabar Tabla
  
  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

' construccion - destruccion

Private Sub Class_Terminate()
    Set m_ObjAbm = Nothing
    Set m_ObjTree = Nothing
End Sub



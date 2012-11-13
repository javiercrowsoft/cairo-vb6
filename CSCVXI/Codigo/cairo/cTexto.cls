VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cTexto"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGeneric
Implements CSInterfacesABM.cIABMClient
Implements csMenu.cIMenuClient
Implements CSInterfacesABM.cIABMClientGrid
'--------------------------------------------------------------------------------
' cTexto
' 20-11-2009

'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes

Private Const C_Module = "cTexto"
Private Const c_items = "Items"
Private Const key_col_padre = "col_padre"

Private Const K_NOMBRE         As Integer = 1
Private Const K_CODIGO         As Integer = 2
Private Const K_ACTIVO         As Integer = 3

Private Const K_CMIA_ID        As Integer = 4
Private Const K_CMI_ID         As Integer = 5
Private Const K_CMIEA_ID       As Integer = 6
Private Const K_IDM_ID         As Integer = 7
Private Const K_DESCRIP        As Integer = 8

Private Const K_ITEMS          As Integer = 9

Private Const KI_CMITI_ID         As Integer = 1
Private Const KI_NOMBRE           As Integer = 2
Private Const KI_CODIGO           As Integer = 3
Private Const KI_TEXTO            As Integer = 4
Private Const KI_TIENEVALOR       As Integer = 5
Private Const KI_DELIMITADOR      As Integer = 6
Private Const KI_CODIGOMACRO      As Integer = 7
Private Const KI_BOOLEANO         As Integer = 8
Private Const KI_PADRE            As Integer = 9
Private Const KI_ORDEN            As Integer = 10

' estructuras
' Seudo - Variables
Private c_ErrorSave         As String

' variables privadas
Private m_Id                           As Long
Private m_Nombre                       As String
Private m_Codigo                       As String
Private m_Activo                       As Boolean
Private m_Aplicacion                   As String
Private m_cmia_id                      As Long
Private m_ComunidadInternet            As String
Private m_cmi_id                       As Long
Private m_Account                      As String
Private m_cmiea_id                     As Long
Private m_Idioma                       As String
Private m_Idm_id                       As Long
Private m_Descrip                      As String

Private m_Editing          As Boolean

Private m_ObjAbm           As cIABMGeneric
Private m_ObjTree          As Object

Private m_IsNew            As Boolean

Private m_BranchId         As Long
Private m_TreeId           As Long

Private m_Host              As cIMenuHost
Private m_Copy              As Boolean

Private m_GeneralConfig     As cGeneralConfig

Private m_ItemsDeletedItems            As String
' propiedades publicas

' JMA I
Public Property Get id() As Long
  id = m_Id
End Property

Public Property Get Nombre() As String
  Nombre = m_Nombre
End Property

Public Property Get Codigo() As String
  Codigo = m_Codigo
End Property
' JMA F

' propiedades privadas
' funciones publicas
' Implementacion de cIABMClient
Private Function cIABMClient_Copy() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True
  
  With m_ObjAbm.Properties(cscCmitCodigo)
    .Value = C_C & .Value
  End With
  
  With m_ObjAbm.Properties(cscCmitNombre)
    .Value = C_CopiaDe & .Value
  End With
  
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscCmitCodigo)
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscCmitNombre)
  
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

  Doc.ClientTable = csTComunidadInternetTexto
  Doc.ClientTableID = m_Id

  cIABMClient_ShowDocDigital = Doc.ShowDocs(gDB)

  GoTo ExitProc
ControlError:
  MngError Err, C_ShowDocDigital, C_Module, vbNullString
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

Private Function cIABMClient_ListAdHock(Lista As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClient_Load()

End Sub

Private Function cIABMClient_PropertyChange(ByVal Clave As Integer) As Boolean

End Function

Private Function cIABMClient_Save() As Boolean
  Dim LastId   As Long
  Dim bLegal   As Boolean
  Dim register As cRegister
  Dim fields   As cFields
  
  Set register = New cRegister
  
  With register
    Set fields = .fields
    .fieldId = cscCmitId
    .Table = csTComunidadInternetTexto
  
    If m_Copy Then
      .id = csNew
    Else
      .id = m_Id
    End If
  End With
  
  Dim IProperty As cIABMProperty
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_NOMBRE
          fields.Add2 cscCmitNombre, .Value, csText
        Case K_CODIGO
          fields.Add2 cscCmitCodigo, .Value, csText
        Case K_ACTIVO
          fields.Add2 cscActivo, Val(.Value), csBoolean
        Case K_DESCRIP
          register.fields.Add2 cscCmitDescrip, .Value, csText
        Case K_CMIA_ID
          register.fields.Add2 cscCmiaId, .HelpId, csId
        Case K_CMI_ID
          register.fields.Add2 cscCmiId, .HelpId, csId
        Case K_CMIEA_ID
          register.fields.Add2 cscCmieaId, .HelpId, csId
        Case K_IDM_ID
          register.fields.Add2 cscIdmId, .HelpId, csId
      End Select
    End With
  Next
  fields.HaveLastUpdate = True
  fields.HaveWhoModify = True
  
  If Not register.BeginTrans(gDB) Then Exit Function
  
  If Not gDB.SaveEx(register, , _
                    cscCmitCodigo, _
                    C_ABMClientSave, _
                    C_Module, _
                    c_ErrorSave) Then Exit Function
  
  LastId = m_Id
  m_Id = register.id
  
  If Not pSaveItems() Then GoTo SaveError
  
  If Not register.CommitTrans() Then GoTo SaveError
  
  m_Copy = False
  cIABMClient_Save = Load(register.id)

  Exit Function
SaveError:
  m_Id = LastId
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
  cIABMClient_Title = LNGGetText(5013, vbNullString) 'Textos
End Property

Private Function cIABMClient_Validate() As Boolean
  Dim IProperty As cIABMProperty
  
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_NOMBRE
          If ValEmpty(.Value, csText) Then
            MsgInfo C_DebeIndicarNombre
            Exit Function
          End If
        Case K_CODIGO
          If ValEmpty(.Value, csText) Then
            .Value = c_get_codigo_from_id
          End If
      End Select
    End With
  Next
  
  cIABMClient_Validate = True
End Function

' Implementacion de cIEditGeneric
Private Property Get cIEditGeneric_ObjAbm() As CSInterfacesABM.cIABMGeneric
  Set cIEditGeneric_ObjAbm = m_ObjAbm
End Property

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
  cIEditGeneric_ShowList = SecurityCanAccess(csPreCVXIListTexto)
End Function

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
  Set m_ObjAbm = rhs
End Property

Private Property Get cIEditGeneric_Editing() As Boolean
  cIEditGeneric_Editing = m_Editing
End Property

Private Function cIEditGeneric_Delete(id As Long) As Boolean
  If Not SecurityCanAccess(csPreCVXIDeleteTexto) Then Exit Function

  Dim sqlstmt As String
  
  sqlstmt = "sp_ComunidadInternetTextoDelete " & id
  
  cIEditGeneric_Delete = gDB.Execute(sqlstmt, C_EditGenericDelete, C_Module)
End Function

Private Function cIEditGeneric_Search(id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If id = csNO_ID Then
  m_IsNew = True
  If Not SecurityCanAccess(csPreCVXINewTexto) Then Exit Function
  Else
  m_IsNew = False
  If Not SecurityCanAccess(csPreCVXIEditTexto) Then Exit Function
  End If

  m_ObjAbm.InModalWindow = InModalWindow
  
  If Not Load(id) Then Exit Function
  
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
  MngError Err, C_EditGenericEdit, C_Module, vbNullString
End Function

Private Function cIEditGeneric_PrintObj(ByVal id As Long) As Boolean

End Function

Private Property Set cIEditGeneric_ObjTree(rhs As Object)
  Set m_ObjTree = rhs
End Property

Private Function cIEditGeneric_PropertyChange(ByVal Clave As Integer) As Boolean

End Function

Private Property Let cIEditGeneric_BranchId(ByVal rhs As Long)
  m_BranchId = rhs
End Property

Private Property Get cIEditGeneric_BranchId() As Long
  cIEditGeneric_BranchId = m_BranchId
End Property

Private Function cIEditGeneric_TabClick(ByVal Index As Integer) As Boolean

End Function

Private Function cIEditGeneric_Preview(ByVal id As Long) As Boolean

End Function

Private Function cIMenuClient_Initialize(f As Object, Host As csMenu.cIMenuHost) As Boolean
  On Error GoTo ControlError

  Dim str_4999 As String

  str_4999 = LNGGetText(4999, vbNullString)

  Set m_Host = Host
  m_Host.Server.AddMenu str_4999, csMenuConfig, C_MenuConfig, 0, True, False, True, False, True, Nothing
  m_Host.Server.AddMenu LNGGetText(5014, vbNullString), csPreCVXIListTexto, str_4999, 0, True, False, False, False, False, Me
                        '&Textos
                        
  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, "cIMenuClient_Initialize", C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal id As Long) As Variant
  m_Host.MenuABMClick "CSCVXI.cTexto", Me, LNGGetText(5013, vbNullString), 0, csETablesCVXI.csComunidadInternetTexto
                                                        'Textos
End Function

Private Function cIABMClientGrid_ColumnAfterEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long) As Boolean
  cIABMClientGrid_ColumnAfterEdit = True
End Function

Private Function cIABMClientGrid_ColumnBeforeEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean
  If Key = K_ITEMS Then
    With m_ObjAbm.Properties.Item(c_items).Grid
      If .Columns.Item(lCol).Key = KI_PADRE Then
        
        .Columns.Item(lCol).HelpFilter = "(cmiti_id <> " & Val(.Rows.Item(lRow).Item(2).Value) & ") and cmit_id = " & m_Id
        
        Dim abmgen As cABMGeneric
        Set abmgen = m_ObjAbm
        abmgen.RefreshColumnProperties m_ObjAbm.Properties.Item(c_items), key_col_padre
      End If
    End With
  End If
  cIABMClientGrid_ColumnBeforeEdit = True
End Function

Private Function cIABMClientGrid_ColumnButtonClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean

End Function

Private Sub cIABMClientGrid_ColumnCancelEdit(ByVal Key As Integer)

End Sub

Private Function cIABMClientGrid_DeleteRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal lRow As Long) As Boolean
  Dim id As Long
  
  id = Val(pCell(Row, KI_CMITI_ID).Value)
  
  If id <> csNO_ID Then m_ItemsDeletedItems = m_ItemsDeletedItems & id & C_StrColon
  
  cIABMClientGrid_DeleteRow = True
End Function

Private Function cIABMClientGrid_ListAdHock(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal ColIndex As Long, List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClientGrid_NewRow(ByVal Key As Integer, ByVal Rows As Integer)

End Sub

Private Sub cIABMClientGrid_ColumnClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Sub cIABMClientGrid_DblClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Function cIABMClientGrid_ValidateRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_ITEMS
      cIABMClientGrid_ValidateRow = pValidateRowItems(Row, RowIndex)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, C_ValidateRow, C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIABMClientGrid_ColumnAfterUpdate(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long) As Boolean

End Function

Private Function cIABMClientGrid_IsEmptyRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_ITEMS
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowItems(Row, RowIndex)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, C_IsEmptyRow, C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pIsEmptyRowItems(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim bRowIsEmpty           As Boolean
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_NOMBRE
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KI_CODIGO
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowItems = bRowIsEmpty
End Function

Private Function pValidateRowItems(Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.Key
        Case KI_NOMBRE
          If ValEmpty(Cell.Value, csText) Then
            MsgInfo C_DebeIndicarNombre
            Exit Function
          End If
        Case KI_CODIGO
          If ValEmpty(Cell.Value, csText) Then
            MsgInfo C_DebeIndicarCodigo
            Exit Function
          End If
    End Select
  Next
  
  pValidateRowItems = True
  
End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  Dim abmgen As cABMGeneric
  Set abmgen = m_ObjAbm
  abmgen.MinHeight = 8000
  
  Dim c As cIABMProperty
      
  With m_ObjAbm.Tabs
  
    .Clear
      
    With .Add(Nothing)
      .Name = C_strGeneral
    End With
    
    With .Add(Nothing)
      .Index = 1
      .Name = LNGGetText(5013, vbNullString) 'Textos
    End With
    
  End With

  m_ObjAbm.Title2 = m_Nombre
  
  With m_ObjAbm.Properties
  
    .Clear
  
    With .Add(Nothing, cscCmitNombre)
      .PropertyType = cspText
      .Name = C_strNombre
      .Size = 100
      .Key = K_NOMBRE
      .Value = m_Nombre
      .Width = 5000
    End With
      
    With .Add(Nothing, cscCmitCodigo)
      .PropertyType = cspText
      .Name = C_strCodigo
      .Size = 15
      .Value = m_Codigo
      .Key = K_CODIGO
    End With
      
    With .Add(Nothing, cscActivo)
      .PropertyType = cspCheck
      .Name = C_strActivo
      .Key = K_ACTIVO
      .Value = CInt(m_Activo)
      .TopFromProperty = cscCmitCodigo
      .LeftNotChange = True
      .LeftLabel = -800
      .Left = 5000
    End With
                  
    With .Add(Nothing, cscCmiId)
      .PropertyType = cspHelp
      .Table = csComunidadInternet
      .Name = LNGGetText(5004, vbNullString) ' Comunidad Internet
      .Key = K_CMI_ID
      .Value = m_ComunidadInternet
      .HelpId = m_cmi_id
      .Width = 5000
    End With
      
    With .Add(Nothing, cscCmiaId)
      .PropertyType = cspHelp
      .Table = csComunidadInternetAplicacion
      .Name = LNGGetText(5005, vbNullString) ' Aplicación
      .Key = K_CMIA_ID
      .Value = m_Aplicacion
      .HelpId = m_cmia_id
      .Width = 5000
    End With
      
    With .Add(Nothing, cscCmieaId)
      .PropertyType = cspHelp
      .Table = csComunidadInternetEmailAccount
      .Name = LNGGetText(5019, vbNullString) ' Cuenta de Correo
      .Key = K_CMIEA_ID
      .Value = m_Account
      .HelpId = m_cmiea_id
      .Width = 5000
    End With
      
    With .Add(Nothing, cscIdmId)
      .PropertyType = cspHelp
      .Table = csIdioma
      .Name = LNGGetText(1239, vbNullString) ' Idioma
      .Key = K_IDM_ID
      .Value = m_Idioma
      .HelpId = m_Idm_id
      .Width = 5000
    End With
                  
    With .Add(Nothing, cscCmitDescrip)
      .PropertyType = cspText
      .SubType = cspMemo
      .Name = C_strDescrip
      .Size = 255
      .Width = 5000
      .Height = 880
      .Key = K_DESCRIP
      .Value = m_Descrip
    End With
                  
    Set c = .Add(Nothing, c_items)
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      If Not pLoadItems(c) Then Exit Function
      .Name = "Items"
      .Key = K_ITEMS
      .TabIndex = 1
      .GridAdd = True
      .GridEdit = True
      .GridRemove = True
    End With
  End With
  m_ItemsDeletedItems = vbNullString

  If Not m_ObjAbm.Show(Me) Then Exit Function

  LoadCollection = True
End Function

Private Function Load(ByVal id As Long) As Boolean
  Dim sqlstmt As String
  
  sqlstmt = "sp_ComunidadInternetTextoGet " & id
  
  Dim rs As ADODB.Recordset
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function
  
  If rs.EOF Then
    m_Activo = True
    m_Nombre = vbNullString
    m_Codigo = vbNullString
    m_Id = csNO_ID
    m_cmi_id = csNO_ID
    m_ComunidadInternet = vbNullString
    m_cmia_id = csNO_ID
    m_Aplicacion = vbNullString
    m_cmiea_id = csNO_ID
    m_Account = vbNullString
    m_Idm_id = csNO_ID
    m_Idioma = vbNullString
    m_Descrip = vbNullString
  Else
    m_Activo = gDB.ValField(rs.fields, cscActivo)
    m_Nombre = gDB.ValField(rs.fields, cscCmitNombre)
    m_Codigo = gDB.ValField(rs.fields, cscCmitCodigo)
    m_Id = gDB.ValField(rs.fields, cscCmitId)
    m_ComunidadInternet = gDB.ValField(rs.fields, cscCmiNombre)
    m_cmia_id = gDB.ValField(rs.fields, cscCmiaId)
    m_Aplicacion = gDB.ValField(rs.fields, cscCmiaNombre)
    m_cmiea_id = gDB.ValField(rs.fields, cscCmieaId)
    m_Account = gDB.ValField(rs.fields, cscCmieaNombre)
    m_Idm_id = gDB.ValField(rs.fields, cscIdmId)
    m_Idioma = gDB.ValField(rs.fields, cscIdmNombre)
    m_Descrip = gDB.ValField(rs.fields, cscCmitDescrip)
  End If
  Load = True
End Function

Private Function pSaveItems() As Boolean
  Dim register As cRegister
  Dim Row  As cIABMGridRow
  Dim Cell As cIABMGridCellValue
  
  With m_ObjAbm.Properties.Item("Items").Grid
          
    For Each Row In .Rows
    
      Set register = New cRegister
      With register
        .fieldId = cscCmitiId
        .Table = csTComunidadInternetTextoItem
        .id = csNew
        
        For Each Cell In Row
          Select Case Cell.Key
            
            Case KI_CMITI_ID
              If Not m_Copy Then
                .id = Val(Cell.Value)
              End If
  
            Case KI_ORDEN
              .fields.Add2 cscCmitiOrden, Cell.Value, csInteger
            Case KI_NOMBRE
              .fields.Add2 cscCmitiNombre, Cell.Value, csText
            Case KI_CODIGO
              .fields.Add2 cscCmitiCodigo, Cell.Value, csText
            Case KI_TEXTO
              .fields.Add2 cscCmitiTexto, Cell.Value, csText
            Case KI_TIENEVALOR
              .fields.Add2 cscCmitiTienevalor, Cell.id, csBoolean
            Case KI_DELIMITADOR
              .fields.Add2 cscCmitiDelimitador, Cell.Value, csText
            Case KI_CODIGOMACRO
              .fields.Add2 cscCmitiCodigomacro, Cell.Value, csText
            Case KI_BOOLEANO
              .fields.Add2 cscCmitiBooleano, Cell.id, csBoolean
            Case KI_PADRE
              .fields.Add2 cscCmitiIdPadre, Cell.id, csId
            
          End Select
        Next
        
        .fields.Add2 cscCmitId, m_Id, csId
        
        .fields.HaveLastUpdate = False
        .fields.HaveWhoModify = False
      End With
      
      If Not gDB.Save(register, , C_pSaveItemsFunc, C_Module, c_ErrorSave) Then Exit Function
    Next
  End With
  
  Dim sqlstmt As String
  
  If LenB(m_ItemsDeletedItems) And Not m_Copy Then
    m_ItemsDeletedItems = RemoveLastColon(m_ItemsDeletedItems)
    sqlstmt = "delete ComunidadInternetTextoItem where cmiti_id in (" & m_ItemsDeletedItems & ")"
  
    If Not gDB.Execute(sqlstmt, C_pSaveItemsFunc, C_Module) Then Exit Function
  End If
  
  If m_Copy Then
    sqlstmt = "sp_ComunidadInternetTextoItemsCopy " & m_Id
    If Not gDB.Execute(sqlstmt, C_pSaveItemsFunc, C_Module) Then Exit Function
  End If
  
  pSaveItems = True
End Function

Private Function pLoadItems(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_ComunidadInternetTextoItemsGet " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadItems", C_Module) Then Exit Function
  
  With Propiedad.Grid
    
    With .Columns
      
      .Clear
      
      With .Add(Nothing)
        .Visible = False
        .Key = KI_CMITI_ID
      End With
      
      With .Add(Nothing)
        .Name = C_strNombre
        .PropertyType = cspText
        .Width = 2500
        .Key = KI_NOMBRE
      End With
          
      With .Add(Nothing)
        .Name = C_strCodigo
        .PropertyType = cspText
        .Width = 1500
        .Key = KI_CODIGO
      End With
          
      With .Add(Nothing)
        .Name = LNGGetText(5016, vbNullString) 'Orden
        .PropertyType = cspNumeric
        .Width = 2500
        .Key = KI_ORDEN
      End With
          
      With .Add(Nothing)
        .Name = LNGGetText(5003, vbNullString) 'Texto
        .PropertyType = cspText
        .Width = 3500
        .Key = KI_TEXTO
      End With
          
      With .Add(Nothing)
        .Name = LNGGetText(5008, vbNullString) 'Tiene Valor
        .PropertyType = cspCheck
        .Width = 1000
        .Key = KI_TIENEVALOR
      End With
          
      With .Add(Nothing)
        .Name = LNGGetText(5009, vbNullString) 'Delimitador
        .PropertyType = cspText
        .Width = 1000
        .Key = KI_DELIMITADOR
      End With
                              
      With .Add(Nothing)
        .Name = LNGGetText(5010, vbNullString) 'Codigo Macro
        .PropertyType = cspText
        .Width = 1000
        .Key = KI_CODIGOMACRO
      End With
          
      With .Add(Nothing)
        .Name = LNGGetText(5011, vbNullString) 'Es Verdadero/Falso
        .PropertyType = cspCheck
        .Width = 1000
        .Key = KI_BOOLEANO
      End With
          
      With .Add(Nothing, key_col_padre)
        .Name = LNGGetText(5012, vbNullString) 'Padre
        .PropertyType = cspHelp
        .Table = csComunidadInternetTextoItem
        .Width = 2500
        .Key = KI_PADRE
      End With
          
    End With
    
    With .Rows
      
      .Clear
      
      While Not rs.EOF
      
        With .Add(Nothing, rs(cscCmitiId).Value)
        
          With .Add(Nothing)
            .Value = rs(cscCmitiId).Value
            .Key = KI_CMITI_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCmitiNombre)
            .Key = KI_NOMBRE
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCmitiCodigo)
            .Key = KI_CODIGO
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCmitiOrden)
            .Key = KI_ORDEN
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCmitiTexto)
            .Key = KI_TEXTO
          End With
          
          With .Add(Nothing)
            .id = gDB.ValField(rs.fields, cscCmitiTienevalor)
            .Key = KI_TIENEVALOR
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCmitiDelimitador)
            .Key = KI_DELIMITADOR
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCmitiCodigomacro)
            .Key = KI_CODIGOMACRO
          End With
          
          With .Add(Nothing)
            .id = gDB.ValField(rs.fields, cscCmitiBooleano)
            .Key = KI_BOOLEANO
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, "padre")
            .id = gDB.ValField(rs.fields, cscCmitiIdPadre)
            .Key = KI_PADRE
          End With
          
        End With
        
        rs.MoveNext
      Wend
    End With
  End With
  
  pLoadItems = True
End Function

' construccion - destruccion

Private Sub Class_Initialize()
  On Error GoTo ControlError

  c_ErrorSave = LNGGetText(5015, vbNullString) 'Error al grabar textos

  Set m_GeneralConfig = New cGeneralConfig
  m_GeneralConfig.Load
  
  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
  On Error Resume Next
  Set m_GeneralConfig = Nothing
  Set m_ObjAbm = Nothing
  Set m_ObjTree = Nothing
End Sub



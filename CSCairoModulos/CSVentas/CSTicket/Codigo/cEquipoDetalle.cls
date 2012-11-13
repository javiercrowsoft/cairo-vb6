VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cEquipoDetalle"
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
' cEquipoDetalle
' 00-06-03

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cEquipoDetalle"

Private Const c_Items = "Items"

Private Const K_NOMBRE                          As Integer = 1
Private Const K_CODIGO                          As Integer = 2
Private Const K_DESCRIP                         As Integer = 3
Private Const K_RUB_ID                          As Integer = 4
Private Const K_ACTIVO                          As Integer = 5

Private Const K_ITEMS                           As Integer = 15

Private Const KI_EDI_ID                         As Integer = 1
Private Const KI_NOMBRE                         As Integer = 2
Private Const KI_ORDEN                          As Integer = 3
Private Const KI_TIPO                           As Integer = 4
Private Const KI_DEFAULT                        As Integer = 5
Private Const KI_SQLSTMT                        As Integer = 7
Private Const KI_TBL_ID                         As Integer = 9

' pseudo-constantes
Private c_ErrorSave As String

' estructuras
' variables privadas
Private m_Id                           As Long
Private m_Nombre                       As String
Private m_Codigo                       As String
Private m_Descrip                      As String
Private m_Rub_id                       As Long
Private m_Rubro                        As String
Private m_Activo                       As Boolean

'OJO HASTA ACA

Private m_Editing           As Boolean

Private m_ObjAbm            As cIABMGeneric
Private m_ObjTree           As Object

Private m_IsNew             As Boolean

Private m_BranchId          As Long
Private m_TreeId            As Long
Private m_Host              As CSMenu.cIMenuHost
Private m_Copy              As Boolean

Private m_ItemsDeleted      As String

' Properties privadas
' funciones publicas

' Implementacion de cIABMClientGrid
Private Function cIABMClientGrid_ColumnAfterEdit(ByVal key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long) As Boolean
  cIABMClientGrid_ColumnAfterEdit = True
End Function

Private Function cIABMClientGrid_ColumnAfterUpdate(ByVal key As Integer, ByVal lRow As Long, ByVal lCol As Long) As Boolean
  cIABMClientGrid_ColumnAfterUpdate = True
End Function

Private Function cIABMClientGrid_ColumnBeforeEdit(ByVal key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean
  cIABMClientGrid_ColumnBeforeEdit = True
End Function

Private Function cIABMClientGrid_ColumnButtonClick(ByVal key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean

End Function

Private Sub cIABMClientGrid_ColumnCancelEdit(ByVal key As Integer)

End Sub

Private Sub cIABMClientGrid_ColumnClick(ByVal key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Sub cIABMClientGrid_DblClick(ByVal key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Function cIABMClientGrid_DeleteRow(ByVal key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal lRow As Long) As Boolean
  Dim Id As Long
  
  Select Case key
    Case K_ITEMS
      Id = Val(pCell(Row, KI_EDI_ID).Value)
      If Id <> csNO_ID Then m_ItemsDeleted = m_ItemsDeleted & Id & ","
  End Select
  
  cIABMClientGrid_DeleteRow = True
End Function

Private Function cIABMClientGrid_IsEmptyRow(ByVal key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case key
    Case K_ITEMS
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowItems(Row, RowIndex)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ValidateRow", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIABMClientGrid_ListAdHock(ByVal key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal ColIndex As Long, List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClientGrid_NewRow(ByVal key As Integer, ByVal Rows As Integer)

End Sub

Private Function cIABMClientGrid_ValidateRow(ByVal key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case key
    Case K_ITEMS
      cIABMClientGrid_ValidateRow = pValidateRowItems(Row, RowIndex)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ValidateRow", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

' Implementacion de cIABMClient
Private Function cIABMClient_Copy() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True
  
  With m_ObjAbm.Properties(cscEdCodigo)
    .Value = C_C & .Value
  End With
  
  With m_ObjAbm.Properties(cscEdNombre)
    .Value = C_CopiaDe & .Value
  End With
  
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscEdCodigo)
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscEdNombre)
  
  m_Copy = True
End Function

Private Function cIABMClient_EditNew() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True
  
  If Not pValidateAccessNewEdit(csNO_ID) Then Exit Function
  
  Load csNO_ID
  pRefreshProperties
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

  Doc.ClientTable = csTEquipoDetalle
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
  
  Select Case MessageID
  
    Case MSG_DOC_INFO
    
      Dim AbmGen As cABMGeneric
      Set AbmGen = m_ObjAbm
      
      CSKernelClient2.ShowHelp AbmGen.hWnd, _
                               vbNullString, _
                               vbNullString, _
                               csPreTickNewEquipoDetalle
      cIABMClient_MessageEx = MSG_DOC_INFO_HANDLED
    
    Case MSG_DOC_REFRESH
      pRefreshProperties
  
    Case Else
      cIABMClient_MessageEx = True
  
  End Select
End Function

Private Sub cIABMClient_DiscardChanges()
    LoadCollection
End Sub

Private Function cIABMClient_ListAdHock(List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClient_Load()

End Sub

Private Function cIABMClient_PropertyChange(ByVal key As Integer) As Boolean

End Function

Private Function cIABMClient_Save() As Boolean
  Dim register        As cRegister
  Dim LastId          As Long
  Dim Codigo          As String
  Dim Nombre          As String
  
  Set register = New cRegister
  register.fieldId = cscEdId
  register.table = csTEquipoDetalle

  If m_Copy Then
    register.Id = csNew
  Else
    register.Id = m_Id
  End If

  Dim IProperty As cIABMProperty
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .key
        Case K_NOMBRE
          Nombre = .Value
          register.Fields.Add2 cscEdNombre, Nombre, csText
        Case K_CODIGO
          Codigo = UCase(.Value)
          register.Fields.Add2 cscEdCodigo, Codigo, csText
        Case K_DESCRIP
          register.Fields.Add2 cscEdDescrip, .Value, csText
        Case K_RUB_ID
          register.Fields.Add2 cscRubId, .HelpId, csId
        Case K_ACTIVO
          register.Fields.Add2 cscActivo, .Value, csBoolean
      End Select
    End With
  Next
  
  register.Fields.HaveLastUpdate = True
  register.Fields.HaveWhoModify = True
  
  If Not register.BeginTrans(gDB) Then Exit Function
  
  LastId = m_Id
                                                                   
  If Not gDB.Save(register, , "cIABMClient_Save", C_Module, LNGGetText(1803, vbNullString)) Then GoTo SaveError
  
  m_Id = register.Id
  
  If Not pSaveItems() Then GoTo SaveError
  
  If Not register.CommitTrans() Then GoTo SaveError
  
  m_Copy = False
  cIABMClient_Save = Load(register.Id)
  
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
    cIABMClient_Title = LNGGetText(1804, vbNullString)  'EquipoDetalles
End Property

Private Function cIABMClient_Validate() As Boolean
  Dim IProperty As cIABMProperty

  CSKernelClient2.title = LNGGetText(1805, vbNullString)  'EquipoDetalle

  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .key
        Case K_NOMBRE
          If ValEmpty(.Value, csText) Then
            MsgInfo C_DebeIndicarNombre  'Debe indicar un nombre
            Exit Function
          End If
        Case K_CODIGO
          If ValEmpty(.Value, csText) Then
            MsgInfo LNGGetText(1005, vbNullString)  'Debe indicar un código
            Exit Function
          End If
        Case K_RUB_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(1806, vbNullString)  'Debe indicar un rubro
            Exit Function
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
    cIEditGeneric_ShowList = SecurityCanAccess(csPreTickListEquipoDetalle)
End Function

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
    Set m_ObjAbm = rhs
End Property

Private Property Get cIEditGeneric_Editing() As Boolean
    cIEditGeneric_Editing = m_Editing
End Property

Private Function cIEditGeneric_Delete(Id As Long) As Boolean
    If Not SecurityCanAccess(csPreTickDeleteEquipoDetalle) Then Exit Function

    Dim sqlstmt As String
    sqlstmt = "sp_EquipoDetalleDelete " & Id
    
    cIEditGeneric_Delete = gDB.Execute(sqlstmt, "cIEditGeneric_Delete", C_Module)
End Function

Private Function cIEditGeneric_Search(Id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Not pValidateAccessNewEdit(Id) Then Exit Function
  
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
  MngError Err, "cIEditGeneric_Edit", C_Module, vbNullString
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

Private Function cIEditGeneric_PropertyChange(ByVal key As Integer) As Boolean

End Function

Private Function cIMenuClient_Initialize(F As Object, Host As CSMenu.cIMenuHost) As Boolean
  On Error GoTo ControlError
  
  Dim str_1851    As String
  
  str_1851 = LNGGetText(1851, vbNullString)   '&Servicios

  Set m_Host = Host
                                                'Co&nfiguración
  m_Host.Server.AddMenu str_1851, csMenuConfig, LNGGetText(1028, vbNullString), 0, True, False, True, False, True, Nothing
  m_Host.Server.AddMenu LNGGetText(1807, vbNullString), csPreTickListEquipoDetalle, str_1851, 0, True, False, False, False, False, Me
                        '&Detalle de Equipos
  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, "cIMenuClient_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal Id As Long) As Variant
  m_Host.MenuABMClick "CSTicket.cEquipoDetalle", Me, LNGGetText(1808, vbNullString), 0, csEquipoDetalle 'Detalle de Equipo
End Function

' funciones privadas

Private Function pValidateAccessNewEdit(ByVal Id As Long) As Boolean
  If Id = csNO_ID Then
    m_IsNew = True
    If Not SecurityCanAccess(csPreTickNewEquipoDetalle) Then Exit Function
  Else
    m_IsNew = False
    If Not SecurityCanAccess(csPreTickEditEquipoDetalle) Then Exit Function
  End If
  pValidateAccessNewEdit = True
End Function

Private Function LoadCollection() As Boolean
  Dim c As cIABMProperty
  
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  AbmObj.bSendRefresh = True
  
  Const c_TabItems = 1
  
  With m_ObjAbm
    
    .Properties.Clear
    
    With .Tabs
    
      .Clear
  
      With .Add(Nothing)
        .Name = C_strGeneral
      End With
      
      With .Add(Nothing)
        .Index = c_TabItems
        .Name = c_Items
      End With
    
    End With
    
    .Title2 = m_Nombre
  
    With .Properties
  
      With .Add(Nothing, cscEdNombre)
        .PropertyType = cspText
        .Name = C_strNombre
        .Size = 50
        .Width = 6800
        .key = K_NOMBRE
        .Value = m_Nombre
      End With
      
      With .Add(Nothing, cscEdCodigo)
        .PropertyType = cspText
        .Name = C_strCodigo
        .Size = 50
        .key = K_CODIGO
        .Value = m_Codigo
      End With
      
      With .Add(Nothing, cscActivo)
        .PropertyType = cspCheck
        .Name = C_strActivo
        .key = K_ACTIVO
        .Value = CInt(m_Activo)
      End With
      
      With .Add(Nothing, cscRubId)
        .PropertyType = cspHelp
        .table = csRubro
        .Name = LNGGetText(1299, vbNullString)    'Rubro
        .key = K_RUB_ID
        .Value = m_Rubro
        .HelpId = m_Rub_id
      End With
      
      With .Add(Nothing, cscEdDescrip)
        .PropertyType = cspText
        .SubType = cspMemo
        .Name = C_strDescrip
        .Size = 1000
        .LeftFromProperty = cscEdNombre
        .Width = 6800
        .Height = 700
        .key = K_DESCRIP
        .Value = m_Descrip
      End With
      
      Set c = .Add(Nothing, c_Items)
      With c
        .PropertyType = cspGrid
        .LeftLabel = -1
        If Not pLoadItems(c) Then Exit Function
        .Name = c_Items
        .key = K_ITEMS
        .TabIndex = c_TabItems
        .GridAdd = True
        .GridEdit = True
        .GridRemove = True
      End With
      
      m_ItemsDeleted = vbNullString
    
    End With
    
    If Not .Show(Me) Then Exit Function
    
  End With
  
  LoadCollection = True
End Function

Public Function Load(ByVal Id As Long) As Boolean
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  sqlstmt = "select ed.*, rub_nombre" & _
            " from EquipoDetalle ed left join Rubro rub" & _
                   " on ed.rub_id = rub.rub_id" & _
            " where ed_id = " & Id
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.Fields, cscEdId)
    m_Nombre = gDB.ValField(rs.Fields, cscEdNombre)
    m_Codigo = gDB.ValField(rs.Fields, cscEdCodigo)
    m_Descrip = gDB.ValField(rs.Fields, cscEdDescrip)
    m_Activo = gDB.ValField(rs.Fields, cscActivo)
    m_Rub_id = gDB.ValField(rs.Fields, cscRubId)
    m_Rubro = gDB.ValField(rs.Fields, cscRubNombre)

  Else
    m_Id = csNO_ID
    m_Nombre = vbNullString
    m_Codigo = vbNullString
    m_Descrip = vbNullString
    m_Activo = True
    m_Rub_id = csNO_ID
    m_Rubro = vbNullString

  End If

  Load = True
End Function

Private Sub pRefreshProperties()
  Dim c      As cIABMProperty
  Dim AbmGen As cABMGeneric
  Dim Filter As String

  With m_ObjAbm
    
    .Title2 = m_Nombre
    
    With .Properties

      With .Item(cscEdNombre)
        .Value = m_Nombre
      End With
      
      With .Item(cscEdCodigo)
        .Value = m_Codigo
      End With
      
      With .Item(cscActivo)
        .Value = CInt(m_Activo)
      End With
      
      With .Item(cscEdDescrip)
        .Value = m_Descrip
      End With
      
      Set c = .Item(c_Items)
      If Not pLoadItems(c) Then Exit Sub
      m_ItemsDeleted = vbNullString
      
    End With
  End With
  
  Set AbmGen = m_ObjAbm
  AbmGen.ShowValues m_ObjAbm.Properties
  AbmGen.ResetChanged
  
End Sub
'/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
'
' PARAMETROS
'
'/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Private Function pLoadItems(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "select EquipoDetalleItem.*, tbl_nombre" & _
            " from EquipoDetalleItem, Tabla" & _
            " where ed_id = " & m_Id & _
              " and EquipoDetalleItem.tbl_id *= Tabla.tbl_id" & _
            " order by edi_orden"
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadItems", C_Module) Then Exit Function
  
  With Propiedad.Grid
    
    .Rows.Clear
    
    With .Columns
    
      .Clear
      
      With .Add(Nothing)
        .Name = "edi_id"
        .Visible = False
        .key = KI_EDI_ID
      End With
      
      With .Add(Nothing)
        .Name = C_strNombre
        .PropertyType = cspText
        .Width = 2000
        .key = KI_NOMBRE
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1809, vbNullString)   'Orden
        .PropertyType = cspNumeric
        .SubType = cspInteger
        .Width = 1200
        .key = KI_ORDEN
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1223, vbNullString)   'Tipo
        .PropertyType = cspList
      
        With .List.Add(Nothing)
          .Id = csEdItemCheck
          .Value = LNGGetText(2271, vbNullString)   'CheckBox
        End With
        
        With .List.Add(Nothing)
          .Id = csEdItemDate
          .Value = LNGGetText(1569, vbNullString)   'Fecha
        End With
        
        With .List.Add(Nothing)
          .Id = csEdItemHelp
          .Value = LNGGetText(2271, vbNullString)   'Help
        End With
        
        With .List.Add(Nothing)
          .Id = csEdItemList
          .Value = LNGGetText(2273, vbNullString)   'Lista
        End With
        
        With .List.Add(Nothing)
          .Id = csEdItemNumeric
          .Value = LNGGetText(2274, vbNullString)   'Numérico
        End With
        
        With .List.Add(Nothing)
          .Id = csEdItemSqlstmt
          .Value = LNGGetText(2276, vbNullString)   'Sqlstmt
        End With
        
        With .List.Add(Nothing)
          .Id = csEdItemText
          .Value = LNGGetText(1005, vbNullString)   'Texto
        End With
        .Width = 1200
        .key = KI_TIPO
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1810, vbNullString)   'Tabla
        .PropertyType = cspHelp
        .table = csTabla
        .Width = 2500
        .key = KI_TBL_ID
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(2276, vbNullString)   'Sqlstmt
        .PropertyType = cspText
        .Width = 4000
        .key = KI_SQLSTMT
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(2277, vbNullString)   'Default
        .PropertyType = cspText
        .Width = 4000
        .key = KI_DEFAULT
      End With
      
    End With
    
    With .Rows
  
      While Not rs.EOF
      
        With .Add(Nothing, rs(cscEdiId).Value)
        
          With .Add(Nothing)
            .Value = rs(cscEdiId).Value
            .key = KI_EDI_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscEdiNombre)
            .key = KI_NOMBRE
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscEdiOrden)
            .key = KI_ORDEN
          End With
          
          With .Add(Nothing)
            .Id = gDB.ValField(rs.Fields, cscEdiTipo)
            .key = KI_TIPO
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscTblNombre)
            .Id = gDB.ValField(rs.Fields, cscTblId)
            .key = KI_TBL_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscEdiSqlstmt)
            .key = KI_SQLSTMT
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscEdiDefault)
            .key = KI_DEFAULT
          End With
          
        End With
        
        rs.MoveNext
      Wend
      
    End With
  End With
  
  pLoadItems = True
End Function

Private Function pValidateRowItems(Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  Dim TablaIsPresent    As Boolean
  Dim Tipo              As csEEdItemType
  Dim SqlstmtIsPresent  As Boolean
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.key
      Case KI_NOMBRE
        If ValEmpty(Cell.Value, csText) Then
          MsgInfo LNGGetText(1811, vbNullString, strRow)  'Debe indicar un nombre (1)
          Exit Function
        End If
      Case KI_ORDEN
        If ValEmpty(Cell.Value, csInteger) Then
          MsgInfo LNGGetText(1812, vbNullString, strRow)  'Debe indicar un orden (1)
          Exit Function
        End If
      Case KI_TIPO
        If ValEmpty(Cell.Id, csInteger) Then
          MsgInfo LNGGetText(1813, vbNullString, strRow)  'Debe indicar un tipo (1)
          Exit Function
        End If
        Tipo = Cell.Id
      Case KI_SQLSTMT
        If Not ValEmpty(Cell.Value, csText) Then SqlstmtIsPresent = True
      Case KI_TBL_ID
        If Not ValEmpty(Cell.Id, csId) Then TablaIsPresent = True
    End Select
  Next
  
  If Tipo = csEdItemHelp And Not TablaIsPresent Then
    MsgInfo LNGGetText(1814, vbNullString, strRow)  'Debe indicar una tabla (1)
    Exit Function
  End If
  
  If Tipo = csEdItemSqlstmt And Not SqlstmtIsPresent Then
    MsgInfo LNGGetText(1815, vbNullString, strRow)  'Debe indicar una sentencia sql (1)
    Exit Function
  End If
  
  If Tipo = csEdItemList And Not SqlstmtIsPresent Then
    MsgInfo LNGGetText(1816, vbNullString, strRow)
            'Debe indicar una lista separada por "|" o una sentencia sql (1)
    Exit Function
  End If
  
  
  pValidateRowItems = True
  
End Function
  
Private Function pIsEmptyRowItems(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  Dim bRowIsEmpty           As Boolean
  
  strRow = " (Fila " & RowIndex & ")"
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.key
      Case KI_NOMBRE
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KI_ORDEN
        If Not ValEmpty(Cell.Value, csInteger) Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KI_TIPO
        If Not ValEmpty(Cell.Id, csInteger) Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KI_SQLSTMT
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KI_TBL_ID
        If Not ValEmpty(Cell.Id, csId) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowItems = bRowIsEmpty
End Function

Private Function pSaveItems() As Boolean
  Dim register As cRegister
  Dim IProperty As cIABMProperty
  
  Set IProperty = m_ObjAbm.Properties(c_Items)
  With IProperty
        
    Dim Row  As cIABMGridRow
    Dim Cell As cIABMGridCellValue
    
    For Each Row In IProperty.Grid.Rows
    
      Set register = New cRegister
      register.fieldId = cscEdiId
      register.table = csTEquipoDetalleItem
      register.Id = csNew
      
      For Each Cell In Row
        Select Case Cell.key
          
          Case KI_EDI_ID
            If Not m_Copy Then
              register.Id = Val(Cell.Value)
            End If
          Case KI_NOMBRE
            register.Fields.Add2 cscEdiNombre, Cell.Value, csText
          Case KI_ORDEN
            register.Fields.Add2 cscEdiOrden, Cell.Value, csInteger
          Case KI_TIPO
            register.Fields.Add2 cscEdiTipo, Cell.Id, csInteger
          Case KI_DEFAULT
            register.Fields.Add2 cscEdiDefault, Cell.Value, csText
          Case KI_SQLSTMT
            register.Fields.Add2 cscEdiSqlstmt, Cell.Value, csText
          Case KI_TBL_ID
            register.Fields.Add2 cscTblId, Cell.Id, csId
        End Select
      Next
      
      register.Fields.Add2 cscEdId, m_Id, csId
      
      register.Fields.HaveLastUpdate = False
      register.Fields.HaveWhoModify = False
                                                                   
      If Not gDB.Save(register, , "pSaveItems", C_Module, c_ErrorSave) Then Exit Function
    Next
  End With
  
  Dim sqlstmt As String
  
  If LenB(m_ItemsDeleted) And Not m_Copy Then
    m_ItemsDeleted = RemoveLastColon(m_ItemsDeleted)
    
    sqlstmt = "delete EquipoDetalleItem where edi_id in (" & m_ItemsDeleted & ")"
    If Not gDB.Execute(sqlstmt, "pSaveItems", C_Module) Then Exit Function
  End If
  
  pSaveItems = True
End Function

Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  c_ErrorSave = LNGGetText(1803, vbNullString)  'Error al grabar EquipoDetalle
  
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

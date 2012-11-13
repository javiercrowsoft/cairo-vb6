VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cExpoGrupoPrecio"
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
' cExpoGrupoPrecio
' 13-09-04
'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cExpoGrupoPrecio"

Private Const c_Idiomas = "Idiomas"
Private Const c_PosAran = "PosAran"
Private Const c_Producto = "Producto"

Private Const K_NOMBRE                         As Integer = 1
Private Const K_CODIGO                         As Integer = 2
Private Const K_ACTIVO                         As Integer = 3
Private Const K_POSARANCEL                     As Integer = 4

Private Const K_IDIOMAS                        As Integer = 9
Private Const KI_EGPIDM_ID                     As Integer = 5
Private Const KI_TEXTO                         As Integer = 6
Private Const KI_IDM_ID                        As Integer = 7

Private Const K_POSARAN                        As Integer = 10
Private Const KI_EGPPA_ID                      As Integer = 1
Private Const KI_PA_ID                         As Integer = 2
Private Const KI_POSARAN                       As Integer = 3

Private Const K_PRODUCTO                       As Integer = 11
Private Const KI_PR_ID                         As Integer = 1

' estructuras
' Seudo - Variables
Private c_ErrorSave                    As String

' variables privadas
Private m_Id                           As Long
Private m_Nombre                       As String
Private m_Codigo                       As String
Private m_PosArancel                   As String
Private m_Creado                       As Date
Private m_Modificado                   As Date
Private m_Modifico                     As Long
Private m_Activo                       As Boolean

Private m_ItemsDeleted                 As String
Private m_ItemsPosAranDeleted          As String
Private m_ItemsProductoDeleted         As String

'OJO HASTA ACA

Private m_Editing           As Boolean

Private m_ObjAbm            As cIABMGeneric
Private m_ObjTree           As Object

Private m_IsNew             As Boolean

Private m_Host              As cIMenuHost

Private m_BranchId          As Long
Private m_TreeId            As Long
Private m_Copy              As Boolean

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

Public Property Get Codigo() As String
  Codigo = m_Codigo
End Property

Public Property Let Codigo(ByVal rhs As String)
  m_Codigo = rhs
End Property
' Properties privadas
' funciones publicas

' Implementacion de cIABMClient
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

Private Function cIABMClient_MessageEx(ByVal MessageID As Long, ByVal Info As Variant) As Variant
  cIABMClient_MessageEx = True
End Function

Private Function cIABMClient_ShowDocDigital() As Boolean
  On Error GoTo ControlError
  
  If m_Id = csNO_ID Then Exit Function
  
  Dim Doc As cDocDigital
  Set Doc = New cDocDigital

  Doc.ClientTable = csTExpoFamilia
  Doc.ClientTableID = m_Id

  cIABMClient_ShowDocDigital = Doc.ShowDocs(gDB)

  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClient_ShowDocDigital", C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIABMClient_EditNew() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True
  cIEditGeneric_Edit csNO_ID
End Function

Private Sub cIABMClient_DiscardChanges()
    LoadCollection
End Sub

Private Function cIABMClient_Copy() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True

  With m_ObjAbm.Properties(cscEgpCodigo)
    .Value = "C-" & .Value
  End With
  
  With m_ObjAbm.Properties(cscEgpNombre)
    .Value = "Copia de " & .Value
  End With
  
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscEgpCodigo)
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscEgpNombre)
  
  m_Copy = True
End Function

Private Function cIABMClient_ListAdHock(List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClient_Load()

End Sub

Private Function pLoadIdioma(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  
  Dim rs As ADODB.Recordset
  
  sqlstmt = "select ExpoGrupoPrecioIdioma.*, idm_nombre " & _
            " from ExpoGrupoPrecioIdioma, Idioma" & _
              " where egp_id = " & m_Id & _
                " and ExpoGrupoPrecioIdioma.idm_id = Idioma.idm_id"
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadIdioma", C_Module) Then Exit Function
  
  Dim o As cIABMGridColumn
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Visible = False
  o.Key = KI_EGPIDM_ID
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = LNGGetText(1239, vbNullString) 'Idioma
  o.PropertyType = cspHelp
  o.Table = csIdioma
  o.Width = 3500
  o.Key = KI_IDM_ID
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = LNGGetText(1005, vbNullString) 'Texto
  o.PropertyType = cspText
  o.SubType = cspTextButtonEx
  o.Width = 3000
  o.Key = KI_TEXTO
  
  Dim F  As cIABMGridRow
  Dim fv As cIABMGridCellValue
  
  While Not rs.EOF
  
    Set F = Propiedad.Grid.Rows.Add(Nothing, rs(cscEgpidmId).Value)
    
    Set fv = F.Add(Nothing)
    fv.Value = rs(cscEgpidmId).Value
    fv.Key = KI_EGPIDM_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscIdmNombre)
    fv.Id = gDB.ValField(rs.Fields, cscIdmId)
    fv.Key = KI_IDM_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscEgpidmTexto)
    fv.Key = KI_TEXTO
    
    rs.MoveNext
  Wend
  
  pLoadIdioma = True
End Function

Private Function pLoadProducto(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  
  Dim rs As ADODB.Recordset
  
  sqlstmt = "select pr_id, pr_nombreventa from Producto " & _
              " where egp_id = " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadPosAran", C_Module) Then Exit Function
  
  Dim o As cIABMGridColumn
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = LNGGetText(1367, vbNullString) 'Articulo
  o.PropertyType = cspHelp
  o.Table = csProducto
  o.Width = 3500
  o.Key = KI_PR_ID
  
  Dim F  As cIABMGridRow
  Dim fv As cIABMGridCellValue
  
  While Not rs.EOF
  
    Set F = Propiedad.Grid.Rows.Add(Nothing, rs(cscPrId).Value)
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscPrNombreVenta)
    fv.Id = gDB.ValField(rs.Fields, cscPrId)
    fv.Key = KI_PR_ID
    
    rs.MoveNext
  Wend
  
  pLoadProducto = True
End Function

Private Function pLoadPosAran(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  
  Dim rs As ADODB.Recordset
  
  sqlstmt = "select ExpoGrupoPrecioPosAran.*, pa_nombre " & _
            " from ExpoGrupoPrecioPosAran, Pais" & _
              " where egp_id = " & m_Id & _
                " and ExpoGrupoPrecioPosAran.pa_id = Pais.pa_id"
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadPosAran", C_Module) Then Exit Function
  
  Dim o As cIABMGridColumn
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Visible = False
  o.Key = KI_EGPPA_ID
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = LNGGetText(1212, vbNullString) 'País
  o.PropertyType = cspHelp
  o.Table = csPais
  o.Width = 3500
  o.Key = KI_PA_ID
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = LNGGetText(3268, vbNullString) 'Posición
  o.PropertyType = cspText
  o.Width = 3000
  o.Key = KI_POSARAN
  
  Dim F  As cIABMGridRow
  Dim fv As cIABMGridCellValue
  
  While Not rs.EOF
  
    Set F = Propiedad.Grid.Rows.Add(Nothing, rs(cscEgppaId).Value)
    
    Set fv = F.Add(Nothing)
    fv.Value = rs(cscEgppaId).Value
    fv.Key = KI_EGPPA_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscPaNombre)
    fv.Id = gDB.ValField(rs.Fields, cscPaId)
    fv.Key = KI_PA_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscEgppaPosicion)
    fv.Key = KI_POSARAN
    
    rs.MoveNext
  Wend
  
  pLoadPosAran = True
End Function

Private Function cIABMClient_PropertyChange(ByVal Key As Integer) As Boolean

End Function

Private Function cIABMClient_Save() As Boolean
  Dim LastId   As Long
  Dim register As cRegister
  Dim IProperty As cIABMProperty
  
  Set register = New cRegister
  register.fieldId = cscEgpId
  register.Table = csTExpoGrupoPrecio
  
  If m_Copy Then
    register.Id = csNew
  Else
    register.Id = m_Id
  End If

  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_NOMBRE
          register.Fields.Add2 cscEgpNombre, .Value, csText
        Case K_CODIGO
          register.Fields.Add2 cscEgpCodigo, .Value, csText
        Case K_ACTIVO
          register.Fields.Add2 cscActivo, .Value, csBoolean
        Case K_POSARANCEL
          register.Fields.Add2 cscEgpPosArancel, .Value, csText
      End Select
    End With
  Next
  
  register.Fields.HaveLastUpdate = True
  register.Fields.HaveWhoModify = True

  If Not register.BeginTrans(gDB) Then Exit Function

  If Not gDB.Save(register, , "cIABMClient_Save", C_Module, "Error al grabar ExpoGrupoPrecio") Then Exit Function

  LastId = m_Id
  m_Id = register.Id

  If Not pSaveItems() Then GoTo SaveError
  If Not pSaveItemsPosAran() Then GoTo SaveError
  If Not pSaveItemsProducto() Then GoTo SaveError
  
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
    cIABMClient_Title = LNGGetText(3269, vbNullString) 'Grupos de Precios
End Property

Private Function cIABMClient_Validate() As Boolean

  Dim IProperty As cIABMProperty

  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_NOMBRE
          If ValEmpty(.Value, csText) Then
            MsgInfo LNGGetText(1007, vbNullString) 'Debe indicar un nombre
            Exit Function
          End If
        Case K_CODIGO
          If ValEmpty(.Value, csText) Then
            MsgInfo LNGGetText(1008, vbNullString) 'Debe indicar un código
            Exit Function
          End If
        Case K_POSARANCEL
          If ValEmpty(.Value, csText) Then
            MsgInfo LNGGetText(3270, vbNullString) 'Debe indicar una Posición Arancelaria
            Exit Function
          End If
      End Select
    End With
  Next

  cIABMClient_Validate = True
End Function

Private Function cIABMClientGrid_ColumnAfterEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long) As Boolean
  cIABMClientGrid_ColumnAfterEdit = True
End Function

Private Function cIABMClientGrid_ColumnAfterUpdate(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long) As Boolean

End Function

Private Function cIABMClientGrid_ColumnBeforeEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean
  cIABMClientGrid_ColumnBeforeEdit = True
End Function

Private Function cIABMClientGrid_ColumnButtonClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean

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
  
    Case K_IDIOMAS
    
      Id = Val(pCell(Row, KI_EGPIDM_ID).Value)
      
      If Id <> csNO_ID Then m_ItemsDeleted = m_ItemsDeleted & Id & ","
    
    Case K_POSARAN
  
      Id = Val(pCell(Row, KI_EGPPA_ID).Value)
      
      If Id <> csNO_ID Then m_ItemsPosAranDeleted = m_ItemsPosAranDeleted & Id & ","
    
    Case K_PRODUCTO
    
      Id = pCell(Row, KI_PR_ID).Id
      
      If Id <> csNO_ID Then m_ItemsProductoDeleted = m_ItemsProductoDeleted & Id & ","
      
  End Select
  
  cIABMClientGrid_DeleteRow = True
End Function

Private Function cIABMClientGrid_IsEmptyRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_IDIOMAS
      cIABMClientGrid_IsEmptyRow = pIsEmptyRow(Row, RowIndex)
    Case K_POSARAN
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowPosAran(Row, RowIndex)
    Case K_PRODUCTO
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowProducto(Row, RowIndex)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, C_ValidateRow, C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pIsEmptyRowProducto(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim bRowIsEmpty           As Boolean
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_PR_ID
        If Not ValEmpty(Cell.Id, csId) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowProducto = bRowIsEmpty
End Function

Private Function pIsEmptyRowPosAran(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim bRowIsEmpty           As Boolean
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_PA_ID
        If Not ValEmpty(Cell.Id, csId) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowPosAran = bRowIsEmpty
End Function

Private Function pIsEmptyRow(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim bRowIsEmpty           As Boolean
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_IDM_ID
        If Not ValEmpty(Cell.Id, csId) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRow = bRowIsEmpty
End Function

Private Function cIABMClientGrid_ListAdHock(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal ColIndex As Long, List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClientGrid_NewRow(ByVal Key As Integer, ByVal Rows As Integer)

End Sub

Private Function cIABMClientGrid_ValidateRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    
    Case K_IDIOMAS
      cIABMClientGrid_ValidateRow = pValidateRow(Row, RowIndex)
    Case K_POSARAN
      cIABMClientGrid_ValidateRow = pValidateRowPosAran(Row, RowIndex)
    Case K_PRODUCTO
      cIABMClientGrid_ValidateRow = pValidateRowProducto(Row, RowIndex)
  
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ValidateRow", C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next

End Function

Private Function pValidateRowProducto(Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_PR_ID
        If ValEmpty(Cell.Id, csId) Then
          MsgInfo LNGGetText(1364, vbNullString, strRow) 'Debe indicar un árticulo (1)
          Exit Function
        End If
    End Select
  Next
  
  pValidateRowProducto = True
End Function

Private Function pValidateRowPosAran(Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_POSARAN
        If ValEmpty(Cell.Value, csText) Then
          MsgInfo LNGGetText(3271, vbNullString, strRow)
                  'Debe indicar una posición arancelaria (1)
          Exit Function
        End If
      Case KI_PA_ID
        If ValEmpty(Cell.Id, csId) Then
          MsgInfo LNGGetText(3272, vbNullString, strRow)
                    'Debe indicar un País (1)
          Exit Function
        End If
    End Select
  Next
  
  pValidateRowPosAran = True
End Function

Private Function pValidateRow(Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_TEXTO
        If ValEmpty(Cell.Value, csText) Then
          MsgInfo LNGGetText(1004, vbNullString, strRow)
                  'Debe indicar un texto (1)
          Exit Function
        End If
      Case KI_IDM_ID
        If ValEmpty(Cell.Id, csId) Then
          MsgInfo LNGGetText(3273, vbNullString, strRow)
                    'Debe indicar un idioma (1)
          Exit Function
        End If
    End Select
  Next
  
  pValidateRow = True
End Function

' Implementacion de cIEditGeneric

Private Function cIEditGeneric_TabClick(ByVal Index As Integer) As Boolean

End Function

Private Property Let cIEditGeneric_TreeId(ByVal rhs As Long)
    m_TreeId = rhs
End Property

Private Property Get cIEditGeneric_TreeId() As Long
    cIEditGeneric_TreeId = m_TreeId
End Property

Private Function cIEditGeneric_GridAdd(ByVal KeyProperty As Integer) As Boolean

End Function

Private Function cIEditGeneric_GridEdit(ByVal KeyProperty As Integer) As Boolean

End Function

Private Function cIEditGeneric_GridRemove(ByVal KeyProperty As Integer) As Boolean

End Function

Private Function cIEditGeneric_ShowList() As Boolean
    cIEditGeneric_ShowList = SecurityCanAccess(csPreExpListExpoGrupoPrecio)
End Function

Private Property Get cIEditGeneric_ObjAbm() As CSInterfacesABM.cIABMGeneric
  Set cIEditGeneric_ObjAbm = m_ObjAbm
End Property

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
    Set m_ObjAbm = rhs
End Property

Private Property Get cIEditGeneric_Editing() As Boolean
    cIEditGeneric_Editing = m_Editing
End Property

Private Function cIEditGeneric_Delete(Id As Long) As Boolean
    If Not SecurityCanAccess(csPreExpDeleteExpoGrupoPrecio) Then Exit Function

    Dim sqlstmt As String
    
    sqlstmt = "sp_ExpoGrupoPrecioDelete " & Id
    
    cIEditGeneric_Delete = gDB.Execute(sqlstmt, "cIEditGeneric_Delete", C_Module)
End Function

Private Function cIEditGeneric_Search(Id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Id = csNO_ID Then
    m_IsNew = True
    If Not SecurityCanAccess(csPreExpNewExpoGrupoPrecio) Then Exit Function
  Else
    m_IsNew = False
    If Not SecurityCanAccess(csPreExpEditExpoGrupoPrecio) Then Exit Function
  End If

  m_ObjAbm.InModalWindow = InModalWindow

  If Not Load(Id) Then Exit Function
  
  If Not LoadCollection() Then Exit Function
  
  m_Editing = True
  m_Copy = False

  m_ObjAbm.InModalWindow = InModalWindow

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

Private Function cIEditGeneric_PropertyChange(ByVal Key As Integer) As Boolean

End Function

' Menu
Private Function cIMenuClient_Initialize(F As Object, Host As CSMenu.cIMenuHost) As Boolean
  On Error GoTo ControlError

  Set m_Host = Host
                                                                                    '&Exportación
  m_Host.Server.AddMenu LNGGetText(3274, vbNullString), csPreExpListExpoGrupoPrecio, LNGGetText(2418, vbNullString), 0, True, False, False, False, False, Me
                        '&Grupos de Precios
  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, C_MenuClientInit, C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal Id As Long) As Variant
  m_Host.MenuABMClick "CSExportPrint.cExpoGrupoPrecio", Me, LNGGetText(3269, vbNullString), 0, csETablesExportPrint.csExpoGrupoPrecio
                                                            'Grupos de precios
End Function

' funciones privadas
Private Function pSaveItems() As Boolean
  Dim register As cRegister
  
  Dim Row  As cIABMGridRow
  Dim Cell As cIABMGridCellValue
    
  With m_ObjAbm.Properties.Item(c_Idiomas).Grid
          
    For Each Row In .Rows
    
      Set register = New cRegister
      register.fieldId = cscEgpidmId
      register.Table = csTExpoGrupoPrecioIdioma
      register.Id = csNew
      
      For Each Cell In Row
        Select Case Cell.Key
          
          Case KI_EGPIDM_ID
            If Not m_Copy Then
              register.Id = Val(Cell.Value)
            End If
            
          Case KI_TEXTO
            register.Fields.Add2 cscEgpidmTexto, Cell.Value, csText
          Case KI_IDM_ID
            register.Fields.Add2 cscIdmId, Cell.Id, csId
        End Select
      Next
      
      register.Fields.Add2 cscEgpId, m_Id, csId
      
      register.Fields.HaveLastUpdate = True
      register.Fields.HaveWhoModify = True
      
      If Not gDB.Save(register, , "pSaveItems", C_Module, "Error al grabar Idiomas para grupos de precio") Then Exit Function
    Next
  End With
  
  Dim sqlstmt As String
  
  If LenB(m_ItemsDeleted) Then
    m_ItemsDeleted = RemoveLastColon(m_ItemsDeleted)
    sqlstmt = "delete ExpoGrupoPrecioIdioma where egpidm_id in (" & m_ItemsDeleted & ")"
  
    If Not gDB.Execute(sqlstmt, "pSaveItems", C_Module) Then Exit Function
  End If
  
  pSaveItems = True
End Function

Private Function pSaveItemsPosAran() As Boolean
  Dim register As cRegister
  
  Dim Row  As cIABMGridRow
  Dim Cell As cIABMGridCellValue
    
  With m_ObjAbm.Properties.Item(c_PosAran).Grid
          
    For Each Row In .Rows
    
      Set register = New cRegister
      register.fieldId = cscEgppaId
      register.Table = csTExpoGrupoPrecioPosAran
      register.Id = csNew
      
      For Each Cell In Row
        Select Case Cell.Key
          
          Case KI_EGPPA_ID
            If Not m_Copy Then
              register.Id = Val(Cell.Value)
            End If
            
          Case KI_POSARAN
            register.Fields.Add2 cscEgppaPosicion, Cell.Value, csText
          Case KI_PA_ID
            register.Fields.Add2 cscPaId, Cell.Id, csId
        End Select
      Next
      
      register.Fields.Add2 cscEgpId, m_Id, csId
      
      register.Fields.HaveLastUpdate = False
      register.Fields.HaveWhoModify = False
      
      If Not gDB.Save(register, , "pSaveItems", C_Module, "Error al grabar Idiomas para grupos de precio") Then Exit Function
    Next
  End With
  
  Dim sqlstmt As String
  
  If LenB(m_ItemsPosAranDeleted) Then
    m_ItemsPosAranDeleted = RemoveLastColon(m_ItemsPosAranDeleted)
    sqlstmt = "delete ExpoGrupoPrecioPosAran where egppa_id in (" & m_ItemsPosAranDeleted & ")"
  
    If Not gDB.Execute(sqlstmt, "pSaveItems", C_Module) Then Exit Function
  End If
  
  pSaveItemsPosAran = True
End Function

Private Function pSaveItemsProducto() As Boolean
  Dim register As cRegister
  
  Dim Row       As cIABMGridRow
  Dim sqlstmt   As String
    
  With m_ObjAbm.Properties.Item(c_Producto).Grid
          
    For Each Row In .Rows
    
      sqlstmt = "Update Producto set egp_id = " & m_Id & _
                " where pr_id = " & pCell(Row, KI_PR_ID).Id
      
      If Not gDB.Execute(sqlstmt) Then Exit Function
    Next
  End With
  
  If LenB(m_ItemsProductoDeleted) Then
    m_ItemsProductoDeleted = RemoveLastColon(m_ItemsProductoDeleted)
    sqlstmt = "update Producto set egp_id = null where pr_id in (" & m_ItemsProductoDeleted & ")"
  
    If Not gDB.Execute(sqlstmt, "pSaveItemsProducto", C_Module) Then Exit Function
  End If
  
  pSaveItemsProducto = True
End Function

Private Function LoadCollection() As Boolean
  Dim c As cIABMProperty
  
  With m_ObjAbm.Tabs
    
    .Clear
  
    With .Add(Nothing)
      .Name = C_strGeneral
    End With
    
    With .Add(Nothing)
      .Index = 1
      .Name = c_Idiomas
    End With
    
    With .Add(Nothing)
      .Index = 2
      .Name = LNGGetText(3275, vbNullString) 'Posición Arancelaria
    End With
    
    With .Add(Nothing)
      .Index = 3
      .Name = LNGGetText(1283, vbNullString) 'Articulos
    End With
  
  End With
  
  m_ObjAbm.Properties.Clear
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscEgpNombre)
  c.PropertyType = cspText
  c.Name = C_strNombre
  c.Width = 5500
  c.Size = 100
  c.Key = K_NOMBRE
  c.Value = Nombre

  Set c = m_ObjAbm.Properties.Add(Nothing, cscEgpCodigo)
  c.PropertyType = cspText
  c.Name = C_strCodigo
  c.Size = 15
  c.Key = K_CODIGO
  c.Value = Codigo

  Set c = m_ObjAbm.Properties.Add(Nothing, cscEgpPosArancel)
  c.PropertyType = cspText
  c.Name = LNGGetText(3275, vbNullString) 'Posición Arancelaria
  c.Size = 100
  c.Key = K_POSARANCEL
  c.Value = m_PosArancel

  Set c = m_ObjAbm.Properties.Add(Nothing, cscActivo)
  c.PropertyType = cspCheck
  c.Name = C_strActivo
  c.Key = K_ACTIVO
  c.Value = CInt(m_Activo)
  
  Set c = m_ObjAbm.Properties.Add(Nothing, c_Idiomas)
  c.PropertyType = cspGrid
  c.LeftLabel = -1
  If Not pLoadIdioma(c) Then Exit Function
  c.Name = c_Idiomas
  c.Key = K_IDIOMAS
  c.TabIndex = 1
  c.GridAdd = True
  c.GridEdit = True
  c.GridRemove = True
  
  m_ItemsDeleted = vbNullString

  Set c = m_ObjAbm.Properties.Add(Nothing, c_PosAran)
  c.PropertyType = cspGrid
  c.LeftLabel = -1
  If Not pLoadPosAran(c) Then Exit Function
  c.Name = "Posiciones Arancelarias"
  c.Key = K_POSARAN
  c.TabIndex = 2
  c.GridAdd = True
  c.GridEdit = True
  c.GridRemove = True
  
  m_ItemsPosAranDeleted = vbNullString

  Set c = m_ObjAbm.Properties.Add(Nothing, c_Producto)
  c.PropertyType = cspGrid
  c.LeftLabel = -1
  If Not pLoadProducto(c) Then Exit Function
  c.Name = "Articulos"
  c.Key = K_PRODUCTO
  c.TabIndex = 3
  c.GridAdd = True
  c.GridEdit = True
  c.GridRemove = True
  
  m_ItemsProductoDeleted = vbNullString

  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

Private Function Load(ByVal Id As Long) As Boolean

  Dim sqlstmt As String

  sqlstmt = "select * from ExpoGrupoPrecio where egp_id = " & Id

  Dim rs As Recordset

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "Load", C_Module) Then Exit Function

  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.Fields, cscEgpId)
    m_Nombre = gDB.ValField(rs.Fields, cscEgpNombre)
    m_Codigo = gDB.ValField(rs.Fields, cscEgpCodigo)
    m_PosArancel = gDB.ValField(rs.Fields, cscEgpPosArancel)
    m_Creado = gDB.ValField(rs.Fields, cscCreado)
    m_Modificado = gDB.ValField(rs.Fields, cscModificado)
    m_Modifico = gDB.ValField(rs.Fields, cscModifico)
    m_Activo = gDB.ValField(rs.Fields, cscActivo)

  Else
    m_Id = csNO_ID
    m_Nombre = vbNullString
    m_Codigo = vbNullString
    m_PosArancel = vbNullString
    m_Creado = csNoDate
    m_Modificado = csNoDate
    m_Modifico = 0
    m_Activo = True

  End If

  Load = True
End Function
' construccion - destruccion

Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  c_ErrorSave = LNGGetText(3276, vbNullString)  'Error al grabar ExpoGrupoPrecio
  
  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
    Set m_ObjAbm = Nothing
    Set m_ObjTree = Nothing
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




VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cMoneda"
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
' cMonedaEdit
' 04-12-2004

'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes

Private Const C_Module = "cMonedaEdit"

Private Const K_NOMBRE         As Integer = 1
Private Const K_CODIGO         As Integer = 2
Private Const K_ACTIVO         As Integer = 3
Private Const K_SIGNO          As Integer = 4
Private Const K_CODIGODGI1     As Integer = 5
Private Const K_CODIGODGI2     As Integer = 6
Private Const K_ITEMS          As Integer = 7
Private Const K_LEGAL          As Integer = 8

Private Const KI_MONI_ID       As Integer = 1
Private Const KI_PRECIO        As Integer = 2
Private Const KI_FECHA         As Integer = 3

' estructuras
' Seudo - Variables
Private c_ErrorSave         As String

' variables privadas
Private m_Id                As Long
Private m_Nombre            As String
Private m_Codigo            As String
Private m_Legal             As Boolean
Private m_Activo            As Boolean
Private m_Signo             As String
Private m_CodigoDGI1        As String
Private m_CodigoDGI2        As String


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
Public Property Get ID() As Long
  ID = m_Id
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
  
  With m_ObjAbm.Properties(cscMonCodigo)
    .Value = C_C & .Value
  End With
  
  With m_ObjAbm.Properties(cscMonNombre)
    .Value = C_CopiaDe & .Value
  End With
  
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscMonCodigo)
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscMonNombre)
  
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

  Doc.ClientTable = csTMoneda
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
    .fieldId = cscMonId
    .Table = csTMoneda
  
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
        Case K_NOMBRE
          fields.Add2 cscMonNombre, .Value, csText
        Case K_CODIGO
          fields.Add2 cscMonCodigo, .Value, csText
        Case K_ACTIVO
          fields.Add2 cscActivo, Val(.Value), csBoolean
        Case K_SIGNO
          fields.Add2 cscMonSigno, .Value, csText
        Case K_LEGAL
          bLegal = Val(.Value)
          fields.Add2 cscMonLegal, bLegal, csBoolean
        Case K_CODIGODGI1
          fields.Add2 cscMonCodigoDGI1, .Value, csText
        Case K_CODIGODGI2
          fields.Add2 cscMonCodigoDGI2, .Value, csText
      End Select
    End With
  Next
  fields.HaveLastUpdate = True
  fields.HaveWhoModify = True
  
  If Not register.BeginTrans(gDB) Then Exit Function
  
  If Not gDB.SaveEx(register, , _
                    cscMonCodigo, _
                    C_ABMClientSave, _
                    C_Module, _
                    c_ErrorSave) Then Exit Function
  
  LastId = m_Id
  m_Id = register.ID
  
  If Not pSaveLegal(bLegal) Then GoTo SaveError
  
  If Not pSaveItems() Then GoTo SaveError
  
  If Not register.CommitTrans() Then GoTo SaveError
  
  m_Copy = False
  cIABMClient_Save = Load(register.ID)

  Exit Function
SaveError:
  m_Id = LastId
End Function

Private Function pSaveLegal(ByVal Legal As Boolean) As Boolean
  Dim sqlstmt As String
  
  If Legal Then
    sqlstmt = "update Moneda set mon_legal = 0 where mon_id <> " & m_Id
    If Not gDB.Execute(sqlstmt) Then Exit Function
  End If
  
  pSaveLegal = True
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
  cIABMClient_Title = LNGGetText(3118, vbNullString) 'Monedas
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
        Case K_SIGNO
          If ValEmpty(.Value, csText) Then
            MsgInfo LNGGetText(3119, vbNullString) 'Debe indicar un Signo
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
  cIEditGeneric_ShowList = SecurityCanAccess(csPreGListMoneda)
End Function

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
  Set m_ObjAbm = rhs
End Property

Private Property Get cIEditGeneric_Editing() As Boolean
  cIEditGeneric_Editing = m_Editing
End Property

Private Function cIEditGeneric_Delete(ID As Long) As Boolean
  If Not SecurityCanAccess(csPreGDeleteMoneda) Then Exit Function

  Dim sqlstmt As String
  
  sqlstmt = "Delete MonedaItem where mon_id = " & ID & _
            " Delete Moneda where mon_Id  = " & ID
  
  cIEditGeneric_Delete = gDB.Execute(sqlstmt, C_EditGenericDelete, C_Module)
End Function

Private Function cIEditGeneric_Search(ID As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(ID As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If ID = csNO_ID Then
  m_IsNew = True
  If Not SecurityCanAccess(csPreGNewMoneda) Then Exit Function
  Else
  m_IsNew = False
  If Not SecurityCanAccess(csPreGEditMoneda) Then Exit Function
  End If

  m_ObjAbm.InModalWindow = InModalWindow
  
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
  MngError Err, C_EditGenericEdit, C_Module, vbNullString
End Function

Private Function cIEditGeneric_PrintObj(ByVal ID As Long) As Boolean

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

Private Function cIEditGeneric_Preview(ByVal ID As Long) As Boolean

End Function

Private Function cIMenuClient_Initialize(F As Object, Host As CSMenu.cIMenuHost) As Boolean
  On Error GoTo ControlError

  Set m_Host = Host
  
  m_Host.Server.AddMenu C_MenuTesoreria, csMenuConfigTesoreria, C_MenuConfig, 0, True, False, False, False, True, Nothing
  m_Host.Server.AddMenu LNGGetText(3120, vbNullString), csPreGListMoneda, C_MenuTesoreria, 0, True, False, False, False, False, Me
                        '&Moneda
  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, C_MenuClientInit, C_Module, vbNullString
  If Err.Number Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal ID As Long) As Variant
  m_Host.MenuABMClick "CSTesoreriaConfig.cMoneda", Me, LNGGetText(3118, vbNullString), 0, csETablasGeneral.csMoneda
                                                        'Monedas
End Function

Private Function cIABMClientGrid_ColumnAfterEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long) As Boolean
  cIABMClientGrid_ColumnAfterEdit = True
End Function

Private Function cIABMClientGrid_ColumnBeforeEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean
  cIABMClientGrid_ColumnBeforeEdit = True
End Function

Private Function cIABMClientGrid_ColumnButtonClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean

End Function

Private Sub cIABMClientGrid_ColumnCancelEdit(ByVal Key As Integer)

End Sub

Private Function cIABMClientGrid_DeleteRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal lRow As Long) As Boolean
  Dim ID As Long
  
  ID = Val(pCell(Row, KI_MONI_ID).Value)
  
  If ID <> csNO_ID Then m_ItemsDeletedItems = m_ItemsDeletedItems & ID & C_StrColon
  
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
      Case KI_PRECIO
        If Not ValEmpty(Cell.Value, csCurrency) Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KI_FECHA
        If Not ValEmpty(Cell.Value, csDate) Then
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
        Case KI_PRECIO
          If ValEmpty(Cell.Value, csCurrency) Then
            MsgInfo LNGGetText(1631, vbNullString, strRow) 'Debe indicar un precio (1)
            Exit Function
          End If
        Case KI_FECHA
          If ValEmpty(Cell.Value, csDate) Then
            MsgInfo LNGGetText(1787, vbNullString, strRow) 'Debe indicar una fecha (1)
            Exit Function
          End If
    End Select
  Next
  
  pValidateRowItems = True
  
End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  Dim c As cIABMProperty
      
  With m_ObjAbm.Tabs
  
    .Clear
      
    With .Add(Nothing)
      .Name = C_strGeneral
    End With
    
    With .Add(Nothing)
      .Index = 1
      .Name = LNGGetText(3121, vbNullString) 'Cotizaciones
    End With
    
  End With

  m_ObjAbm.Title2 = m_Nombre
  
  With m_ObjAbm.Properties
  
    .Clear
  
    With .Add(Nothing, cscMonNombre)
      .PropertyType = cspText
      .Name = C_strNombre
      .Size = 100
      .Key = K_NOMBRE
      .Value = m_Nombre
    End With
      
    With .Add(Nothing, cscMonCodigo)
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
    End With
      
    With .Add(Nothing, cscMonSigno)
      .PropertyType = cspText
      .Name = LNGGetText(3122, vbNullString) 'Signo
      .Size = 5
      .Key = K_SIGNO
      .Value = m_Signo
    End With
      
    With .Add(Nothing, cscMonLegal)
      .PropertyType = cspCheck
      .Name = LNGGetText(3123, vbNullString) 'Moneda de curso legal
      .Key = K_LEGAL
      .Value = CInt(m_Legal)
    End With
      
    With .Add(Nothing, cscMonCodigoDGI1)
      .PropertyType = cspText
      .Name = LNGGetText(1486, vbNullString) 'Código DGI 1
      .Size = 5
      .Key = K_CODIGODGI1
      .Value = m_CodigoDGI1
    End With
      
    With .Add(Nothing, cscMonCodigoDGI2)
      .PropertyType = cspText
      .Name = LNGGetText(1487, vbNullString) 'Código DGI 2
      .Size = 5
      .Key = K_CODIGODGI2
      .Value = m_CodigoDGI2
    End With
    
    Set c = .Add(Nothing, "Items")
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

Private Function Load(ByVal ID As Long) As Boolean
  Dim sqlstmt As String
  
  sqlstmt = "select * from moneda where mon_id = " & ID
  
  Dim rs As ADODB.Recordset
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function
  
  If rs.EOF Then
    m_Activo = True
    m_Nombre = vbNullString
    m_Codigo = vbNullString
    m_Id = csNO_ID
    m_Signo = vbNullString
    m_CodigoDGI1 = vbNullString
    m_CodigoDGI2 = vbNullString
    m_Legal = False
  Else
    m_Activo = gDB.ValField(rs.fields, cscActivo)
    m_Nombre = gDB.ValField(rs.fields, cscMonNombre)
    m_Codigo = gDB.ValField(rs.fields, cscMonCodigo)
    m_Id = gDB.ValField(rs.fields, cscMonId)
    m_Signo = gDB.ValField(rs.fields, cscMonSigno)
    m_CodigoDGI1 = gDB.ValField(rs.fields, cscMonCodigoDGI1)
    m_CodigoDGI2 = gDB.ValField(rs.fields, cscMonCodigoDGI2)
    m_Legal = gDB.ValField(rs.fields, cscMonLegal)
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
        .fieldId = cscMoniId
        .Table = csTMonedaItem
        .ID = csNew
        
        For Each Cell In Row
          Select Case Cell.Key
            
            Case KI_MONI_ID
              If Not m_Copy Then
                .ID = Val(Cell.Value)
              End If
  
            Case KI_PRECIO
              .fields.Add2 cscMoniPrecio, Cell.Value, csCurrency
            Case KI_FECHA
              .fields.Add2 cscMoniFecha, Cell.Value, csDate
          End Select
        Next
        
        .fields.Add2 cscMonId, m_Id, csId
        
        .fields.HaveLastUpdate = True
        .fields.HaveWhoModify = True
      End With
      
      If Not gDB.Save(register, , C_pSaveItemsFunc, C_Module, c_ErrorSave) Then Exit Function
    Next
  End With
  
  Dim sqlstmt As String
  
  If LenB(m_ItemsDeletedItems) And Not m_Copy Then
    m_ItemsDeletedItems = RemoveLastColon(m_ItemsDeletedItems)
    sqlstmt = "delete monedaItem where moni_id in (" & m_ItemsDeletedItems & ")"
  
    If Not gDB.Execute(sqlstmt, C_pSaveItemsFunc, C_Module) Then Exit Function
  End If
  
  pSaveItems = True
End Function

Private Function pLoadItems(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  
  Dim rs As ADODB.Recordset
  
  sqlstmt = "select * from MonedaItem where mon_id = " & m_Id & " order by moni_fecha desc"
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadItems", C_Module) Then Exit Function
  
  Dim o As cIABMGridColumn
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = "moni_id"
  o.Visible = False
  o.Key = KI_MONI_ID
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = LNGGetText(1569, vbNullString) 'Fecha
  o.PropertyType = cspDate
  o.Width = 1200
  o.Key = KI_FECHA
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = LNGGetText(1228, vbNullString) 'Importe
  o.PropertyType = cspNumeric
  o.SubType = cspMoney
  o.Width = 1200
  o.Key = KI_PRECIO
  o.Format = m_GeneralConfig.FormatDecCotizacion
  
  Dim F  As cIABMGridRow
  Dim fv As cIABMGridCellValue
  
  While Not rs.EOF
  
    Set F = Propiedad.Grid.Rows.Add(Nothing, rs(cscMoniId).Value)
    
    Set fv = F.Add(Nothing)
    fv.Value = rs(cscMoniId).Value
    fv.Key = KI_MONI_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscMoniFecha)
    fv.Key = KI_FECHA
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscMoniPrecio)
    fv.Key = KI_PRECIO
    
    rs.MoveNext
  Wend
  
  pLoadItems = True
End Function

' construccion - destruccion

Private Sub Class_Initialize()
  On Error GoTo ControlError

  c_ErrorSave = LNGGetText(1357, vbNullString) 'Error al grabar Monedas

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

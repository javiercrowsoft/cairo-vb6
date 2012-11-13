VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cTarifa"
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
' cTarifa
' 29-12-03

'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cTarifa"

Private Const c_Items = "Items"
Private Const c_Gastos = "Gastos"

Private Const K_NOMBRE                         As Integer = 1
Private Const K_CODIGO                         As Integer = 2
Private Const K_FECHADESDE                     As Integer = 3
Private Const K_FECHAHASTA                     As Integer = 4
Private Const K_DESCRIP                        As Integer = 5
Private Const K_TRANS_ID                       As Integer = 6
Private Const K_ACTIVO                         As Integer = 7
Private Const K_TIPO                           As Integer = 8
Private Const K_MONEDA                         As Integer = 9

Private Const K_ITEMS                          As Integer = 10
Private Const K_GASTOS                         As Integer = 11

Private Const KI_TRFI_ID                        As Integer = 1
Private Const KI_MINIMO                         As Integer = 2
Private Const KI_MENOS45                        As Integer = 3
Private Const KI_MAS45                          As Integer = 4
Private Const KI_MAS100                         As Integer = 5
Private Const KI_MAS300                         As Integer = 6
Private Const KI_MAS500                         As Integer = 7
Private Const KI_MAS1000                        As Integer = 8
Private Const KI_PUE_ID_DESTINO                 As Integer = 9
Private Const KI_CODIGO_DESTINO                 As Integer = 10
Private Const KI_PUE_ID_ORIGEN                  As Integer = 11
Private Const KI_ACTIVO                         As Integer = 12

Private Const KI_LUNES                          As Integer = 13
Private Const KI_MARTES                         As Integer = 14
Private Const KI_MIERCOLES                      As Integer = 15
Private Const KI_JUEVES                         As Integer = 16
Private Const KI_VIERNES                        As Integer = 17
Private Const KI_SABADO                         As Integer = 18
Private Const KI_DOMINGO                        As Integer = 19


Private Const KI_TRFG_ID                        As Integer = 1
Private Const KI_FIJO                           As Integer = 2
Private Const KI_IMPORTE                        As Integer = 4
Private Const KI_GTO_ID                         As Integer = 5

Public Enum csE_TarifaTipo
  csEtrfTAerea = 1
  csEtrfTMartima = 2
End Enum
' Seudo - Variables
Private c_ErrorSave   As String
Private c_strTitle    As String

' estructuras
' variables privadas
Private m_Id                           As Long
Private m_Nombre                       As String
Private m_Codigo                       As String
Private m_FechaDesde                   As Date
Private m_FechaHasta                   As Date
Private m_Tipo                         As csE_TarifaTipo
Private m_Descrip                      As String
Private m_trans_id                     As Long
Private m_Transporte                   As String
Private m_mon_id                       As Long
Private m_Moneda                       As String
Private m_Creado                       As Date
Private m_Modificado                   As Date
Private m_Modifico                     As Long
Private m_Activo                       As Boolean

'OJO HASTA ACA

Private m_Editing           As Boolean

Private m_ObjAbm            As cIABMGeneric
Private m_ObjTree           As Object

Private m_IsNew             As Boolean

Private m_BranchId          As Long
Private m_TreeId            As Long
Private m_Copy              As Boolean

Private m_ItemsDeletedItems            As String

Private m_Host                          As CSMenu.cIMenuHost
Private m_ItemsDeletedGastos            As String

Private m_GeneralConfig     As cGeneralConfig

' Properties publicas
'Public Property Get Id() As Long
'  Id = m_Id
'End Property
'
'Public Property Let Id(ByVal rhs As Long)
'  m_Id = rhs
'End Property
'
'Public Property Get Nombre() As String
'  Nombre = m_Nombre
'End Property
'
'Public Property Let Nombre(ByVal rhs As String)
'  m_Nombre = rhs
'End Property
'
'Public Property Get Codigo() As String
'  Codigo = m_Codigo
'End Property
'
'Public Property Let Codigo(ByVal rhs As String)
'  m_Codigo = rhs
'End Property
'
'Public Property Get FechaDesde() As Date
'  FechaDesde = m_FechaDesde
'End Property
'
'Public Property Let FechaDesde(ByVal rhs As Date)
'  m_FechaDesde = rhs
'End Property
'
'Public Property Get FechaHasta() As Date
'  FechaHasta = m_FechaHasta
'End Property
'
'Public Property Let FechaHasta(ByVal rhs As Date)
'  m_FechaHasta = rhs
'End Property
'
'Public Property Get Descrip() As String
'  Descrip = m_Descrip
'End Property
'
'Public Property Let Descrip(ByVal rhs As String)
'  m_Descrip = rhs
'End Property
'
'Public Property Get Trans_id() As Long
'  Trans_id = m_Trans_id
'End Property
'
'Public Property Let Trans_id(ByVal rhs As Long)
'  m_Trans_id = rhs
'End Property
'
'Public Property Get Transporte() As String
'  Transporte = m_Transporte
'End Property
'
'Public Property Let Transporte(ByVal rhs As String)
'  m_Transporte = rhs
'End Property
'
'Public Property Get Creado() As Date
'  Creado = m_Creado
'End Property
'
'Public Property Let Creado(ByVal rhs As Date)
'  m_Creado = rhs
'End Property
'
'Public Property Get Modificado() As Date
'  Modificado = m_Modificado
'End Property
'
'Public Property Let Modificado(ByVal rhs As Date)
'  m_Modificado = rhs
'End Property
'
'Public Property Get Modifico() As Long
'  Modifico = m_Modifico
'End Property
'
'Public Property Let Modifico(ByVal rhs As Long)
'  m_Modifico = rhs
'End Property
'
'Public Property Get Activo() As Boolean
'  Activo = m_Activo
'End Property
'
'Public Property Let Activo(ByVal rhs As Boolean)
'  m_Activo = rhs
'End Property

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

Private Function cIABMClient_ShowDocDigital() As Boolean
  On Error GoTo ControlError
  
  If m_Id = csNO_ID Then Exit Function
  
  Dim Doc As cDocDigital
  Set Doc = New cDocDigital

  Doc.ClientTable = csTTarifa
  Doc.ClientTableID = m_Id

  cIABMClient_ShowDocDigital = Doc.ShowDocs(gDB)

  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClient_ShowDocDigital", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIABMClient_EditNew() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True
  
  cIEditGeneric_Edit csNO_ID
End Function

Private Function cIABMClient_MessageEx(ByVal MessageID As Long, ByVal Info As Variant) As Variant
  cIABMClient_MessageEx = True
End Function

Private Sub cIABMClient_DiscardChanges()
  LoadCollection
End Sub

Private Function cIABMClient_Copy() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True
  
  With m_ObjAbm.Properties(cscTrfCodigo)
    .Value = C_C & .Value
  End With
  
  With m_ObjAbm.Properties(cscTrfNombre)
    .Value = C_CopiaDe & .Value
  End With
  
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscTrfCodigo)
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscTrfNombre)
  
  m_Copy = True
End Function

Private Function cIABMClient_ListAdHock(List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClient_Load()

End Sub

Private Function cIABMClient_PropertyChange(ByVal Key As Integer) As Boolean

End Function

Private Function pSaveItemsGastos() As Boolean
  Dim register  As cRegister
  Dim fields    As cFields
  Dim IProperty As cIABMProperty
  
  Dim Row  As cIABMGridRow
  Dim Cell As cIABMGridCellValue
          
  Set register = New cRegister
  
  With register
  
    .fieldId = csctrfgId
    .Table = csTTarifaGasto
            
    .fields.HaveLastUpdate = True
    .fields.HaveWhoModify = True
            
    For Each Row In m_ObjAbm.Properties.Item(c_Gastos).Grid.Rows
      
      .ID = csNew
      
      With .fields
        
        .Clear
        
        For Each Cell In Row
          Select Case Cell.Key
            
            Case KI_TRFG_ID
              If Not m_Copy Then
                register.ID = Val(Cell.Value)
              End If
            Case KI_FIJO
              .Add2 csctrfgFijo, Cell.Value, csCurrency
            Case KI_MINIMO
              .Add2 csctrfgMinimo, Cell.Value, csCurrency
            Case KI_IMPORTE
              .Add2 csctrfgImporte, Cell.Value, csDouble
            Case KI_GTO_ID
              .Add2 cscGtoId, Cell.ID, csId
            Case KI_ACTIVO
              .Add2 cscActivo, Cell.ID, csBoolean
          End Select
        Next
        
        .Add2 cscTrfId, m_Id, csId
        
        If Not gDB.Save(register, , _
                        "pSaveItemsGastos", _
                        C_Module, _
                        c_ErrorSave) Then Exit Function
      End With
    Next
  End With
  
  Dim sqlstmt As String
  
  If LenB(m_ItemsDeletedGastos) And Not m_Copy Then
    m_ItemsDeletedGastos = RemoveLastColon(m_ItemsDeletedGastos)
    sqlstmt = "delete tarifaGasto where trfg_id in (" & m_ItemsDeletedGastos & ")"
  
    If Not gDB.Execute(sqlstmt, "pSaveItemsGastos", C_Module) Then Exit Function
  End If
  
  pSaveItemsGastos = True
End Function

Private Function pSaveItemsItems() As Boolean
  Dim register  As cRegister
  Dim IProperty As cIABMProperty
  
  Dim Row  As cIABMGridRow
  Dim Cell As cIABMGridCellValue
  
  Set register = New cRegister
  
  With register
  
    .fieldId = cscTrfiId
    .Table = csTTarifaItem
  
    .fields.HaveLastUpdate = True
    .fields.HaveWhoModify = True

    For Each Row In m_ObjAbm.Properties.Item(c_Items).Grid.Rows

      .ID = csNew
    
      With .fields
      
        .Clear
        
        For Each Cell In Row
          Select Case Cell.Key
            
            Case KI_TRFI_ID
              If Not m_Copy Then
                register.ID = Val(Cell.Value)
              End If
            Case KI_MINIMO
              .Add2 cscTrfiMinimo, Cell.Value, csLong
            Case KI_MENOS45
              .Add2 cscTrfiMenos45, Cell.Value, csCurrency
            Case KI_MAS45
              .Add2 cscTrfiMas45, Cell.Value, csCurrency
            Case KI_MAS100
              .Add2 cscTrfiMas100, Cell.Value, csCurrency
            Case KI_MAS300
              .Add2 cscTrfiMas300, Cell.Value, csCurrency
            Case KI_MAS500
              .Add2 cscTrfiMas500, Cell.Value, csCurrency
            Case KI_MAS1000
              .Add2 cscTrfiMas1000, Cell.Value, csCurrency
            Case KI_LUNES
              .Add2 cscTrfiLunes, Cell.ID, csBoolean
            Case KI_MARTES
              .Add2 cscTrfiMartes, Cell.ID, csBoolean
            Case KI_MIERCOLES
              .Add2 cscTrfiMiercoles, Cell.ID, csBoolean
            Case KI_JUEVES
              .Add2 cscTrfiJueves, Cell.ID, csBoolean
            Case KI_VIERNES
              .Add2 cscTrfiViernes, Cell.ID, csBoolean
            Case KI_SABADO
              .Add2 cscTrfiSabado, Cell.ID, csBoolean
            Case KI_DOMINGO
              .Add2 cscTrfiDomingo, Cell.ID, csBoolean
            Case KI_PUE_ID_DESTINO
              .Add2 cscPueIdDestino, Cell.ID, csId
            Case KI_PUE_ID_ORIGEN
              .Add2 cscPueIdOrigen, Cell.ID, csId
            Case KI_ACTIVO
              .Add2 cscActivo, Cell.ID, csBoolean
          End Select
        Next
      
        .Add2 cscTrfId, m_Id, csId
        
      End With
      
      If Not gDB.Save(register, , _
                      "pSaveItemsItems", _
                      C_Module, _
                      c_ErrorSave) Then Exit Function
    Next
  End With
  
  Dim sqlstmt As String
  
  If LenB(m_ItemsDeletedItems) And Not m_Copy Then
    m_ItemsDeletedItems = RemoveLastColon(m_ItemsDeletedItems)
    sqlstmt = "delete tarifaItem where trfi_id in (" & m_ItemsDeletedItems & ")"
  
    If Not gDB.Execute(sqlstmt, "pSaveItemsItems", C_Module) Then Exit Function
  End If
  
  pSaveItemsItems = True
End Function


Private Function cIABMClient_Save() As Boolean
  Dim LastId   As Long
  Dim register As cRegister
  Dim fields   As cFields
  
  Set register = New cRegister
  
  With register
    .fieldId = cscTrfId
    .Table = csTTarifa
    
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
          fields.Add2 cscTrfNombre, .Value, csText
        Case K_CODIGO
          fields.Add2 cscTrfCodigo, .Value, csText
        Case K_FECHADESDE
          fields.Add2 cscTrfFechaDesde, .Value, csDate
        Case K_FECHAHASTA
          fields.Add2 cscTrfFechaHasta, .Value, csDate
        Case K_DESCRIP
          fields.Add2 cscTrfDescrip, .Value, csText
        Case K_MONEDA
          fields.Add2 cscMonId, .HelpId, csId
        Case K_TIPO
          fields.Add2 cscTrfTipo, .ListItemData, csInteger
        Case K_TRANS_ID
          fields.Add2 cscTransId, .HelpId, csId
        Case K_ACTIVO
          fields.Add2 cscActivo, .Value, csBoolean
      End Select
    End With
  Next
  
  fields.HaveLastUpdate = True
  fields.HaveWhoModify = True
  
  If Not register.BeginTrans(gDB) Then Exit Function
   
  If Not gDB.Save(register, , "cIABMClient_Save", C_Module, c_ErrorSave) Then Exit Function
  
  LastId = m_Id
  m_Id = register.ID
  
  If Not pSaveItemsItems() Then GoTo SaveError
  If Not pSaveItemsGastos() Then GoTo SaveError
  
  If Not register.CommitTrans() Then GoTo SaveError
  
  m_Copy = False
  cIABMClient_Save = Load(register.ID)

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
    cIABMClient_Title = c_strTitle
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
        Case K_FECHADESDE
          If ValEmpty(.Value, csDate) Then
            MsgInfo LNGGetText(2393, vbNullString) 'Debe indicar un Fecha Desde
            Exit Function
          End If
        Case K_FECHAHASTA
          If ValEmpty(.Value, csDate) Then
            MsgInfo LNGGetText(2394, vbNullString) 'Debe indicar un fecha hasta
            Exit Function
          End If
        Case K_TRANS_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(2395, vbNullString) 'Debe indicar una empresa de Transporte
            Exit Function
          End If
        Case K_MONEDA
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(1108, vbNullString) 'Debe indicar una moneda
            Exit Function
          End If
        Case K_TIPO
          If ValEmpty(.ListItemData, csInteger) Then
            MsgInfo LNGGetText(1222, vbNullString) 'Debe indicar un tipo
            Exit Function
          End If
        
      End Select
    End With
  Next

  cIABMClient_Validate = True
End Function

Private Function cIABMClientGrid_ColumnAfterUpdate(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long) As Boolean
  Select Case Key
    Case K_ITEMS
      With m_ObjAbm.Properties(c_Items).Grid.Columns(lCol)
        If .Key = KI_PUE_ID_DESTINO Then
          Dim AbmObj As cABMGeneric
          Dim Codigo As String
          
          With m_ObjAbm.Properties(c_Items).Grid.Rows(lRow).Item(lCol)
            gDB.GetData csTPuerto, cscPueId, .ID, cscPueCodigo, Codigo
          End With
          
          Set AbmObj = m_ObjAbm
          
          m_ObjAbm.Properties(c_Items).Grid.Rows(lRow).Item(4).Value = Codigo
          AbmObj.ShowCellValue m_ObjAbm.Properties(c_Items), lRow, 4
        End If
      End With
  End Select
  cIABMClientGrid_ColumnAfterUpdate = True
End Function

Private Sub cIABMClientGrid_ColumnClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Sub cIABMClientGrid_DblClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Function cIABMClientGrid_IsEmptyRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_ITEMS
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowItems(Row, RowIndex)
    Case K_GASTOS
      cIABMClientGrid_IsEmptyRow = False
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

Private Function cIABMClientGrid_ValidateRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError
  
  Select Case Key
    Case K_ITEMS
      cIABMClientGrid_ValidateRow = pValidateRowItems(Row, RowIndex)
    Case K_GASTOS
      cIABMClientGrid_ValidateRow = pValidateRowGastos(Row, RowIndex)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ValidateRow", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pIsEmptyRowItems(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  Dim bRowIsEmpty           As Boolean
  
  strRow = " (Fila " & RowIndex & ")"
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_PUE_ID_DESTINO
        If Not ValEmpty(Cell.ID, csId) Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KI_PUE_ID_ORIGEN
        If Not ValEmpty(Cell.ID, csId) Then
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
'        Case KI_MINIMO
'          If ValEmpty(Cell.Value, csLong) Then
'            MsgInfo "Debe indicar un minimo" & strRow
'            Exit Function
'          End If
'        Case KI_MENOS45
'          If ValEmpty(Cell.Value, csCurrency) Then
'            MsgInfo "Debe indicar un menos45" & strRow
'            Exit Function
'          End If
'        Case KI_MAS45
'          If ValEmpty(Cell.Value, csCurrency) Then
'            MsgInfo "Debe indicar un mas45" & strRow
'            Exit Function
'          End If
'        Case KI_MAS100
'          If ValEmpty(Cell.Value, csCurrency) Then
'            MsgInfo "Debe indicar un mas100" & strRow
'            Exit Function
'          End If
'        Case KI_MAS300
'          If ValEmpty(Cell.Value, csCurrency) Then
'            MsgInfo "Debe indicar un mas300" & strRow
'            Exit Function
'          End If
'        Case KI_MAS500
'          If ValEmpty(Cell.Value, csCurrency) Then
'            MsgInfo "Debe indicar un mas500" & strRow
'            Exit Function
'          End If
'        Case KI_MAS1000
'          If ValEmpty(Cell.Value, csCurrency) Then
'            MsgInfo "Debe indicar un mas1000" & strRow
'            Exit Function
'          End If
        Case KI_PUE_ID_DESTINO
          If ValEmpty(Cell.ID, csId) Then
            MsgInfo LNGGetText(2396, vbNullString, strRow) 'Debe indicar un destino (1)
            Exit Function
          End If
        Case KI_PUE_ID_ORIGEN
          If ValEmpty(Cell.ID, csId) Then
            MsgInfo LNGGetText(2397, vbNullString, strRow) 'Debe indicar un origen (1)
            Exit Function
          End If
    End Select
  Next
  
  pValidateRowItems = True
  
End Function
  
Private Function pValidateRowGastos(Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.Key
'        Case KI_FIJO
'          If ValEmpty(Cell.Value, csCurrency) Then
'            MsgInfo "Debe indicar un fijo" & strRow
'            Exit Function
'          End If
'        Case KI_MINIMO
'          If ValEmpty(Cell.Value, csCurrency) Then
'            MsgInfo "Debe indicar un minimo" & strRow
'            Exit Function
'          End If
'        Case KI_IMPORTE
'          If ValEmpty(Cell.Value, csCurrency) Then
'            MsgInfo "Debe indicar un porcentaje" & strRow
'            Exit Function
'          End If
        Case KI_GTO_ID
          If ValEmpty(Cell.ID, csId) Then
            MsgInfo LNGGetText(2375, vbNullString, strRow) 'Debe indicar un gasto (1)
            Exit Function
          End If
    End Select
  Next
  
  pValidateRowGastos = True
  
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
    cIEditGeneric_ShowList = SecurityCanAccess(csPreEnvListTarifa)
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

Private Function cIEditGeneric_Delete(ID As Long) As Boolean
    If Not SecurityCanAccess(csPreEnvDeleteTarifa) Then Exit Function

    Dim sqlstmt As String
    
    sqlstmt = "Delete TarifaGasto where trf_id = " & ID & vbCrLf
    sqlstmt = "Delete TarifaItem  where trf_id = " & ID & vbCrLf
    sqlstmt = "Delete Tarifa  where trf_id  = " & ID
    
    cIEditGeneric_Delete = gDB.Execute(sqlstmt, "cIEditGeneric_Delete", C_Module)
End Function

Private Function cIEditGeneric_Search(ID As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(ID As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If ID = csNO_ID Then
    m_IsNew = True
    If Not SecurityCanAccess(csPreEnvNewTarifa) Then Exit Function
  Else
    m_IsNew = False
    If Not SecurityCanAccess(csPreEnvEditTarifa) Then Exit Function
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
  MngError Err, "cIEditGeneric_Edit", C_Module, vbNullString
End Function

Private Function cIEditGeneric_PrintObj(ByVal ID As Long) As Boolean

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

Private Function cIEditGeneric_Preview(ByVal ID As Long) As Boolean

End Function

Private Function cIEditGeneric_PropertyChange(ByVal Key As Integer) As Boolean

End Function

' funciones privadas

Private Function LoadCollection() As Boolean
  Dim iTab As cIABMTabItem
  Dim c As cIABMProperty
    
  m_ObjAbm.Properties.Clear
  m_ObjAbm.Tabs.Clear
    
  If m_Id <> csNO_ID Then
    
    Set iTab = m_ObjAbm.Tabs.Add(Nothing)
    iTab.Index = 0
    iTab.Name = C_strGeneral
    
      
    Set iTab = m_ObjAbm.Tabs.Add(Nothing)
    iTab.Index = 1
    iTab.Name = LNGGetText(1371, vbNullString) 'Items
    
  
    Set iTab = m_ObjAbm.Tabs.Add(Nothing)
    iTab.Index = 2
    iTab.Name = c_Gastos
    
  End If
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscTrfNombre)
  c.PropertyType = cspText
  c.Name = C_strNombre
  c.Size = 100
  c.Key = K_NOMBRE
  c.Value = m_Nombre
  

  Set c = m_ObjAbm.Properties.Add(Nothing, cscTrfCodigo)
  c.PropertyType = cspText
  c.Name = C_strCodigo
  c.Size = 15
  c.Key = K_CODIGO
  c.Value = m_Codigo
  

  Set c = m_ObjAbm.Properties.Add(Nothing, cscActivo)
  c.PropertyType = cspCheck
  c.Name = C_strCodigo
  c.LeftNotChange = True
  c.TopFromProperty = cscTrfCodigo
  c.Left = 4800
  c.LeftLabel = -600
  c.Key = K_ACTIVO
  c.Value = CInt(m_Activo)
  

  Set c = m_ObjAbm.Properties.Add(Nothing, cscTrfFechaDesde)
  c.PropertyType = cspDate
  c.Name = LNGGetText(1203, vbNullString) 'Fecha Desde
  c.Key = K_FECHADESDE
  c.Value = m_FechaDesde
  

  Set c = m_ObjAbm.Properties.Add(Nothing, cscTrfFechaHasta)
  c.PropertyType = cspDate
  c.Name = LNGGetText(1204, vbNullString) 'Fecha Hasta
  c.Key = K_FECHAHASTA
  c.Value = m_FechaHasta
  

  Set c = m_ObjAbm.Properties.Add(Nothing, cscMonId)
  c.PropertyType = cspHelp
  c.Table = csMoneda
  c.Name = LNGGetText(1113, vbNullString) 'Moneda
  c.Key = K_MONEDA
  c.Value = m_Moneda
  c.HelpId = m_Id
  

  Set c = m_ObjAbm.Properties.Add(Nothing, cscTransId)
  c.PropertyType = cspHelp
  c.Table = csTransporte
  c.Name = LNGGetText(1050, vbNullString) 'Transporte
  c.Key = K_TRANS_ID
  c.Value = m_Transporte
  c.HelpId = m_trans_id
  

  Set c = m_ObjAbm.Properties.Add(Nothing, cscTrfTipo)
  c.PropertyType = cspList
  c.Name = LNGGetText(1223, vbNullString) 'Tipo
  c.Key = K_TIPO
  c.ListWhoSetItem = csListItemData
  c.ListItemData = m_Tipo
    With c.List.Add(Nothing)
      .ID = csE_TarifaTipo.csEtrfTAerea
      .Value = LNGGetText(2398, vbNullString) 'Aerea
    End With
    With c.List.Add(Nothing)
      .ID = csE_TarifaTipo.csEtrfTMartima
      .Value = LNGGetText(2399, vbNullString) 'Maritima
    End With
  c.Enabled = m_Id = csNO_ID
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscTrfDescrip)
  c.PropertyType = cspText
  c.SubType = cspMemo
  c.Name = C_strDescrip
  c.Width = 6200
  c.Height = 660
  c.Size = 255
  c.Key = K_DESCRIP
  c.Value = m_Descrip
  
  
  If m_Id <> csNO_ID Then
  
    Set c = m_ObjAbm.Properties.Add(Nothing, c_Items)
    c.PropertyType = cspGrid
    c.LeftLabel = -1
    If Not pLoadItems(c) Then Exit Function
    c.Name = c_strTitle
    c.Key = K_ITEMS
    c.TabIndex = 1
    c.GridAdd = True
    c.GridEdit = True
    c.GridRemove = True
    
  
    Set c = m_ObjAbm.Properties.Add(Nothing, c_Gastos)
    c.PropertyType = cspGrid
    c.LeftLabel = -1
    If Not pLoadGastos(c) Then Exit Function
    c.Name = c_Gastos
    c.Key = K_GASTOS
    c.TabIndex = 2
    c.GridEdit = True
    
  
  End If
  
  m_ItemsDeletedItems = ""
  m_ItemsDeletedGastos = ""
  
  m_ObjAbm.ObjForm.Height = 6120
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

Private Function Load(ByVal ID As Long) As Boolean

  Dim sqlstmt As String

  sqlstmt = "select tarifa.*, transporte.trans_nombre,mon_nombre" & _
            " from tarifa left join transporte on tarifa.trans_id = transporte.trans_id" & _
                        " left join moneda on tarifa.mon_id = moneda.mon_id" & _
            " where tarifa.trf_id =" & ID

  Dim rs As Recordset

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.fields, cscTrfId)
    m_Nombre = gDB.ValField(rs.fields, cscTrfNombre)
    m_Codigo = gDB.ValField(rs.fields, cscTrfCodigo)
    m_FechaDesde = gDB.ValField(rs.fields, cscTrfFechaDesde)
    m_FechaHasta = gDB.ValField(rs.fields, cscTrfFechaHasta)
    m_Descrip = gDB.ValField(rs.fields, cscTrfDescrip)
    m_Tipo = gDB.ValField(rs.fields, cscTrfTipo)
    m_trans_id = gDB.ValField(rs.fields, cscTransId)
    m_Transporte = gDB.ValField(rs.fields, cscTransNombre)
    m_mon_id = gDB.ValField(rs.fields, cscMonId)
    m_Moneda = gDB.ValField(rs.fields, cscMonNombre)
    m_Creado = gDB.ValField(rs.fields, cscCreado)
    m_Modificado = gDB.ValField(rs.fields, cscModificado)
    m_Modifico = gDB.ValField(rs.fields, cscModifico)
    m_Activo = gDB.ValField(rs.fields, cscActivo)
  Else
    m_Id = csNO_ID
    m_Nombre = vbNullString
    m_Codigo = vbNullString
    m_FechaDesde = Date
    m_FechaHasta = DateAdd("YYYY", 1, m_FechaDesde)
    m_Tipo = csEtrfTAerea
    m_Descrip = vbNullString
    m_trans_id = csNO_ID
    m_Transporte = vbNullString
    m_mon_id = csNO_ID
    m_Moneda = vbNullString
    m_Creado = csNoDate
    m_Modificado = csNoDate
    m_Modifico = 0
    m_Activo = True
  End If

  Load = True
End Function

Private Function pLoadItems(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  
  Dim rs As ADODB.Recordset
  
  sqlstmt = "select tarifaitem.*, PO.pue_nombre as Origen, PD.pue_nombre as Destino, PD.pue_codigo as codigo" & _
            " from tarifaitem left join puerto as PO on tarifaitem.pue_id_origen  = PO.pue_id" & _
                            " left join puerto as PD on tarifaitem.pue_id_destino = PD.pue_id" & _
            " where tarifaitem.trf_id = " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadItems", C_Module) Then Exit Function
  
  Dim o As cIABMGridColumn
  Dim Default As cIABMGridCellValue
  
  Set Default = New cABMGridRowValue
  
  Default.Value = 0
  
  With Propiedad.Grid.Columns
    Set o = .Add(Nothing)
    o.Visible = False
    o.Key = KI_TRFI_ID
    
    Set o = .Add(Nothing, cscPueIdOrigen)
    o.Name = LNGGetText(2400, vbNullString)   'Puerto origen
    o.PropertyType = cspHelp
    o.Table = csPuerto
    o.Width = 2000
    o.Key = KI_PUE_ID_ORIGEN
    
    Set o = .Add(Nothing, cscPueIdDestino)
    o.Name = LNGGetText(2401, vbNullString)   'Puerto Destino
    o.PropertyType = cspHelp
    o.Table = csPuerto
    o.Width = 2000
    o.Key = KI_PUE_ID_DESTINO
    
    Set o = .Add(Nothing, cscPueCodigo)
    o.Name = C_strCodigo
    o.PropertyType = cspText
    o.Enabled = False
    o.Width = 800
    o.Key = KI_CODIGO_DESTINO
    
    Set o = .Add(Nothing, cscActivo)
    o.Name = C_strActivo
    o.PropertyType = cspCheck
    o.Width = 800
    Set o.DefaultValue = New cABMGridRowValue
    o.DefaultValue.Value = 1
    o.Key = KI_ACTIVO
    
    Set o = .Add(Nothing, cscTrfiMinimo)
    o.Name = LNGGetText(1227, vbNullString)   'Mínimo
    o.PropertyType = cspNumeric
    o.SubType = cspMoney
    o.Width = 800
    o.Format = m_GeneralConfig.FormatDecImporte
    Set o.DefaultValue = Default
    o.Key = KI_MINIMO
    
    Set o = .Add(Nothing, cscTrfiMenos45)
    o.Name = "-45"
    o.PropertyType = cspNumeric
    o.SubType = cspMoney
    o.Width = 600
    o.Format = m_GeneralConfig.FormatDecImporte
    Set o.DefaultValue = Default
    o.Key = KI_MENOS45
    
    Set o = .Add(Nothing, cscTrfiMas45)
    o.Name = "+45"
    o.PropertyType = cspNumeric
    o.SubType = cspMoney
    o.Width = 600
    o.Format = m_GeneralConfig.FormatDecImporte
    Set o.DefaultValue = Default
    o.Key = KI_MAS45
    
    Set o = .Add(Nothing, cscTrfiMas100)
    o.Name = "+100"
    o.PropertyType = cspNumeric
    o.SubType = cspMoney
    o.Width = 600
    o.Format = m_GeneralConfig.FormatDecImporte
    Set o.DefaultValue = Default
    o.Key = KI_MAS100
    
    Set o = .Add(Nothing, cscTrfiMas300)
    o.Name = "+300"
    o.PropertyType = cspNumeric
    o.SubType = cspMoney
    o.Width = 600
    o.Format = m_GeneralConfig.FormatDecImporte
    Set o.DefaultValue = Default
    o.Key = KI_MAS300
    
    Set o = .Add(Nothing, cscTrfiMas500)
    o.Name = "+500"
    o.PropertyType = cspNumeric
    o.SubType = cspMoney
    o.Width = 600
    o.Format = m_GeneralConfig.FormatDecImporte
    Set o.DefaultValue = Default
    o.Key = KI_MAS500
    
    Set o = .Add(Nothing, cscTrfiMas1000)
    o.Name = "+1000"
    o.PropertyType = cspNumeric
    o.SubType = cspMoney
    o.Width = 800
    o.Format = m_GeneralConfig.FormatDecImporte
    Set o.DefaultValue = Default
    o.Key = KI_MAS1000
    
    Set o = .Add(Nothing, cscTrfiLunes)
    o.Name = LNGGetText(2402, vbNullString)   'Lun
    o.PropertyType = cspCheck
    o.Width = 500
    o.Key = KI_LUNES
    
    Set o = .Add(Nothing, cscTrfiMartes)
    o.Name = LNGGetText(2403, vbNullString)   'Mar
    o.PropertyType = cspCheck
    o.Width = 500
    o.Key = KI_MARTES
    
    Set o = .Add(Nothing, cscTrfiMiercoles)
    o.Name = LNGGetText(2404, vbNullString)   'Mie
    o.PropertyType = cspCheck
    o.Width = 500
    o.Key = KI_MIERCOLES
    
    Set o = .Add(Nothing, cscTrfiJueves)
    o.Name = LNGGetText(2405, vbNullString)   'Jue
    o.PropertyType = cspCheck
    o.Width = 500
    o.Key = KI_JUEVES
    
    Set o = .Add(Nothing, cscTrfiViernes)
    o.Name = LNGGetText(2406, vbNullString)   'Vie
    o.PropertyType = cspCheck
    o.Width = 500
    o.Key = KI_VIERNES
    
    Set o = .Add(Nothing, cscTrfiSabado)
    o.Name = LNGGetText(2407, vbNullString)   'Sab
    o.PropertyType = cspCheck
    o.Width = 500
    o.Key = KI_SABADO
    
    Set o = .Add(Nothing, cscTrfiDomingo)
    o.Name = LNGGetText(2408, vbNullString)   'Dom
    o.PropertyType = cspCheck
    o.Width = 600
    o.Key = KI_DOMINGO
  End With
  
  Dim F  As cIABMGridRow
  Dim fv As cIABMGridCellValue
  
  While Not rs.EOF
  
    Set F = Propiedad.Grid.Rows.Add(Nothing, rs(cscTrfiId).Value)
    
    Set fv = F.Add(Nothing)
    fv.Value = rs(cscTrfiId).Value
    fv.Key = KI_TRFI_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, "Origen")
    fv.ID = gDB.ValField(rs.fields, cscPueIdOrigen)
    fv.Key = KI_PUE_ID_ORIGEN
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, "Destino")
    fv.ID = gDB.ValField(rs.fields, cscPueIdDestino)
    fv.Key = KI_PUE_ID_DESTINO
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, "Codigo")
    fv.Key = KI_CODIGO_DESTINO
    
    Set fv = F.Add(Nothing)
    fv.ID = gDB.ValField(rs.fields, cscActivo)
    fv.Key = KI_ACTIVO
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscTrfiMinimo)
    fv.Key = KI_MINIMO
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscTrfiMenos45)
    fv.Key = KI_MENOS45
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscTrfiMas45)
    fv.Key = KI_MAS45
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscTrfiMas100)
    fv.Key = KI_MAS100
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscTrfiMas300)
    fv.Key = KI_MAS300
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscTrfiMas500)
    fv.Key = KI_MAS500
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscTrfiMas1000)
    fv.Key = KI_MAS1000
    
    Set fv = F.Add(Nothing)
    fv.ID = gDB.ValField(rs.fields, cscTrfiLunes)
    fv.Key = KI_LUNES
    
    Set fv = F.Add(Nothing)
    fv.ID = gDB.ValField(rs.fields, cscTrfiMartes)
    fv.Key = KI_MARTES
    
    Set fv = F.Add(Nothing)
    fv.ID = gDB.ValField(rs.fields, cscTrfiMiercoles)
    fv.Key = KI_MIERCOLES
    
    Set fv = F.Add(Nothing)
    fv.ID = gDB.ValField(rs.fields, cscTrfiJueves)
    fv.Key = KI_JUEVES
    
    Set fv = F.Add(Nothing)
    fv.ID = gDB.ValField(rs.fields, cscTrfiViernes)
    fv.Key = KI_VIERNES
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscTrfiSabado)
    fv.ID = KI_SABADO
    
    Set fv = F.Add(Nothing)
    fv.ID = gDB.ValField(rs.fields, cscTrfiDomingo)
    fv.Key = KI_DOMINGO
    
    rs.MoveNext
  Wend
  
  pLoadItems = True
End Function

Private Function pLoadGastos(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  
  Dim rs As ADODB.Recordset
  
  sqlstmt = "select trfg_id, Gasto.*, trfg_minimo, trfg_importe, trfg_fijo " & _
            " from Gasto, TarifaGasto" & _
            " where trf_id = " & m_Id & _
              " and Gasto.gto_id *= TarifaGasto.gto_id"
  
  If m_Tipo = csEtrfTAerea Then
    sqlstmt = sqlstmt & " and gto_tipo = " & csE_GastoTipo.csEGtoTAereo
  Else
    sqlstmt = sqlstmt & " and gto_tipo = " & csE_GastoTipo.csEGtoTMaritimo
  End If
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadGastos", C_Module) Then Exit Function
  
  Dim o As cIABMGridColumn
  
  With Propiedad.Grid.Columns
    Set o = .Add(Nothing)
    o.Visible = False
    o.Key = KI_TRFG_ID
    
    Set o = .Add(Nothing)
    o.Name = LNGGetText(1231, vbNullString)   'Gasto
    o.PropertyType = cspHelp
    o.Table = csGasto
    o.Width = 1200
    o.Key = KI_GTO_ID
    
    Set o = .Add(Nothing)
    o.Name = LNGGetText(1226, vbNullString)   'Fijo
    o.PropertyType = cspNumeric
    o.SubType = cspMoney
    o.Width = 1200
    o.Format = m_GeneralConfig.FormatDecImporte
    o.Key = KI_FIJO
    
    Set o = .Add(Nothing)
    o.Name = LNGGetText(1227, vbNullString)   'Minimo
    o.PropertyType = cspNumeric
    o.SubType = cspMoney
    o.Width = 1200
    o.Format = m_GeneralConfig.FormatDecImporte
    o.Key = KI_MINIMO
    
    Set o = .Add(Nothing)
    o.Name = LNGGetText(1228, vbNullString)   'Importe
    o.PropertyType = cspNumeric
    o.SubType = cspMoney
    o.Width = 1200
    o.Format = "0.0000"
    o.Key = KI_IMPORTE
  End With
  
  Dim F  As cIABMGridRow
  Dim fv As cIABMGridCellValue
  
  While Not rs.EOF
  
    Set F = Propiedad.Grid.Rows.Add(Nothing, rs(cscGtoId).Value)
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, csctrfgId)
    fv.Key = KI_TRFG_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscGtoNombre)
    fv.ID = gDB.ValField(rs.fields, cscGtoId)
    fv.Key = KI_GTO_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, csctrfgFijo)
    fv.Key = KI_FIJO
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, csctrfgMinimo)
    fv.Key = KI_MINIMO
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, csctrfgImporte)
    fv.Key = KI_IMPORTE
    
    rs.MoveNext
  Wend
  
  pLoadGastos = True
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
  
  Select Case Key
    Case K_ITEMS
      ID = Val(pCell(Row, KI_TRFI_ID).Value)
      If ID <> csNO_ID Then m_ItemsDeletedItems = m_ItemsDeletedItems & ID & ","
    
    Case K_GASTOS
      ID = Val(pCell(Row, KI_TRFG_ID).Value)
      If ID <> csNO_ID Then m_ItemsDeletedGastos = m_ItemsDeletedGastos & ID & ","
  End Select
  
  cIABMClientGrid_DeleteRow = True
End Function

Private Sub cIABMClientGrid_NewRow(ByVal Key As Integer, ByVal Rows As Integer)
  On Error GoTo ControlError

  Select Case Key
    Case K_ITEMS
      ' Pongo como default al origen que se puso en la primera fila
      With m_ObjAbm.Properties(c_Items).Grid.Rows(Rows - 1)
        Set m_ObjAbm.Properties(c_Items).Grid.Columns(cscPueIdOrigen).DefaultValue = .Item(2)
      End With
  End Select

  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_NewRow", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub


Private Function cIMenuClient_Initialize(F As Object, Host As CSMenu.cIMenuHost) As Boolean
  On Error GoTo ControlError

  Set m_Host = Host
                        '&Tarifas
  m_Host.Server.AddMenu LNGGetText(2409, vbNullString), csPreEnvListTarifa, LNGGetText(2312, vbNullString), 0, True, False, False, False, False, Me
                                                                            'En&vios
  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, "cIMenuClient_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal ID As Long) As Variant
  m_Host.MenuABMClick "CSEnvio2.cTarifa", Me, c_strTitle, 0, csETablesEnvio.csTarifa
End Function

' construccion - destruccion

Private Sub Class_Initialize()
On Error GoTo ControlError
  c_ErrorSave = LNGGetText(2389, vbNullString) ' Error al grabar Tarifa
  c_strTitle = LNGGetText(2390, vbNullString) ' Tarifas
  
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
'  If Err.Number Then Resume ExitProc
'ExitProc:
'  On Error Resume Next

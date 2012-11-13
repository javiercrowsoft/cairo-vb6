VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cCaja"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGeneric
Implements CSInterfacesABM.cIABMClient
Implements CSInterfacesABM.cIABMClientGrid
Implements CSMenu.cIMenuClient

'--------------------------------------------------------------------------------
' cCaja
' 30-10-08

'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cCaja"

Private Const c_Items = "ITEMS"
Private Const c_Movimientos = "Movimientos"
Private Const c_total = "total"
Private Const c_accion = "accion"
Private Const c_cmd_confirmar = "confirmar"
Private Const c_cmd_ver_asiento = "ver_asiento"

Private Const cscCobzId As String = "cobz_id"

Private Const K_NUMERO                         As Integer = 1
Private Const K_NRODOC                         As Integer = 3
Private Const K_DESCRIP                        As Integer = 4
Private Const K_FECHA                          As Integer = 5
Private Const K_HORA                           As Integer = 6
Private Const K_CJ_ID                          As Integer = 26
Private Const K_US_ID_CAJERO                   As Integer = 29

Private Const K_ITEMS                          As Integer = 30
Private Const K_MOVIMIENTOS                    As Integer = 31
Private Const K_TOTAL                          As Integer = 32
Private Const K_EST_ID                         As Integer = 33
Private Const K_ACCION                         As Integer = 34
Private Const K_CMD_CONFIRMAR                  As Integer = 35
Private Const K_CMD_VER_ASIENTO                As Integer = 36

Private Const KI_MCJI_ID                       As Integer = 1
Private Const KI_CUE_ID_TRABAJO                As Integer = 2
Private Const KI_CUE_ID_FONDOS                 As Integer = 3
Private Const KI_IMPORTE                       As Integer = 4
Private Const KI_DESCRIP                       As Integer = 5
Private Const KI_MON_ID                        As Integer = 6
Private Const KI_COTIZACION                    As Integer = 7

Private Const KI_MCJM_ID                       As Integer = 1
Private Const KI_AS_ID                         As Integer = 100
Private Const KI_COMPROBANTE                   As Integer = 101
Private Const KI_FECHA                         As Integer = 102

' pseudo-constantes
Private c_ErrorSave As String

' estructuras
' variables privadas
Private m_Id                           As Long
Private m_Numero                       As String
Private m_Nrodoc                       As String
Private m_Descrip                      As String
Private m_cj_id                        As Long
Private m_Caja                         As String
Private m_us_id_cajero                 As Long
Private m_Cajero                       As String
Private m_Fecha                        As Date
Private m_Hora                         As Date
Private m_Tipo                         As Integer
Private m_Estado                       As String
Private m_Accion                       As String
Private m_as_id                        As Long
Private m_cerrada                      As Boolean

Private m_last_cj_id                   As Long

Private m_bItemsEditable               As Boolean

' HOJO HASTA ACA

Private m_Editing           As Boolean

Private m_ObjAbm            As cIABMGeneric
Private m_ObjTree           As Object

Private m_IsNew             As Boolean

Private m_BranchId          As Long
Private m_TreeId            As Long

Private m_Host              As CSMenu.cIMenuHost

Private m_GeneralConfig     As cGeneralConfig

' Properties publicas

Public Property Get id() As Long
  id = m_Id
End Property

Public Property Get nombre() As String
  nombre = m_Numero
End Property

Public Property Get Codigo() As String
  Codigo = m_Nrodoc
End Property
' Properties privadas
' funciones publicas

' Implementacion de cIABMClient
Private Function cIABMClient_Copy() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True
  
  With m_ObjAbm.Properties(cscMcjNrodoc)
    .Value = C_C & .Value
  End With
    
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscMcjNrodoc)
  
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
  cIABMClient_CanCopy = False
End Property

Private Property Get cIABMClient_CanNew() As Boolean
  cIABMClient_CanNew = True
End Property

Private Function cIABMClient_ShowDocDigital() As Boolean
  On Error GoTo ControlError
  
  If m_Id = csNO_ID Then Exit Function
  
  Dim Doc As cDocDigital
  Set Doc = New cDocDigital

  Doc.ClientTable = csTMovimientoCaja
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
  Select Case MessageID
  
    Case MSG_ABM_PRINT
      
      If m_Id = csNO_ID Then
                ' "Debe grabar el movimiento de caja para poder imprimirlo"
        MsgInfo LNGGetText(4744, vbNullString), LNGGetText(1853, vbNullString)
              
      Else
        Dim AbmObj As cABMGeneric
        Set AbmObj = m_ObjAbm
        AbmObj.PrintABM m_Id, -csMovimientoCaja ' El menos es para que pase Id y no NODO Id en PrintManager
      End If
      
      cIABMClient_MessageEx = True
    
    Case MSG_ABM_CAN_PRINT
      
      cIABMClient_MessageEx = MSG_ABM_CAN_PRINT
    
    Case MSG_DOC_INFO
    
      Dim AbmGen As cABMGeneric
      Set AbmGen = m_ObjAbm
      
      CSKernelClient2.ShowHelp AbmGen.hWnd, _
                               vbNullString, _
                               vbNullString, _
                               csPreVtaNewCaja
      cIABMClient_MessageEx = MSG_DOC_INFO_HANDLED
    Case Else
      cIABMClient_MessageEx = True
  End Select
End Function

Private Sub cIABMClient_DiscardChanges()
  If m_Id = csNO_ID Then
    m_last_cj_id = csNO_ID
  End If
  LoadCollection
End Sub

Private Function cIABMClient_ListAdHock(List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClient_Load()

End Sub

Private Function cIABMClient_PropertyChange(ByVal Key As Integer) As Boolean
  Select Case Key
    Case K_CJ_ID
      If m_last_cj_id <> pGetCaja().HelpId Then
        pLoadItemsXCjId pGetItems()
        pLoadMovimientosXCjId pGetMovimientos(), False
        pShowCmdConfirmar
      End If
      
    Case K_CMD_CONFIRMAR
      pSaveAsiento
      
    Case K_CMD_VER_ASIENTO
      pVerAsiento
      
  End Select
End Function

Private Function cIABMClient_Save() As Boolean
  
  If m_Tipo = 1 Then
  
    If Not SecurityCanAccessSilent(csPreVtaAbrirCaja) Then
    
      MsgWarning LNGGetText(4742, vbNullString) 'Ud. no tiene permiso para abrir una caja
    
      Exit Function
    End If
  
  ' Si esta cerrando la caja veo que no existan
  ' nuevos movimientos que se hicieron mientras
  ' esta ventana estaba abierta y con la caja
  ' cargada
  '
  Else
  
    pLoadItemsXCjId pGetItems()
    pLoadMovimientosXCjId pGetMovimientos(), False
  
  End If
  
  Dim register    As cRegister
  Dim fields      As cFields
  Dim File        As String
  Dim prs_id      As Long
  
  Set register = New cRegister
  Set fields = register.fields
  
  With register
    .fieldId = cscMcjId
    .Table = csTMovimientoCaja
    .id = m_Id
  End With
  
  Dim IProperty As cIABMProperty
  
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
      
        Case K_FECHA
          fields.Add2 cscMcjFecha, .Value, csDate
        Case K_HORA
          fields.Add2 cscMcjHora, .Value, csDate
        Case K_DESCRIP
          fields.Add2 cscMcjDescrip, .Value, csText
        Case K_US_ID_CAJERO
          fields.Add2 cscUsIdCajero, .HelpId, csId
        Case K_CJ_ID
          fields.Add2 cscCjId, .HelpId, csId
      End Select
    End With
  Next
  
  fields.Add2 cscMcjTipo, m_Tipo, csInteger
  
  fields.HaveLastUpdate = True
  fields.HaveWhoModify = True
                    
  If Not register.BeginTrans(gDB) Then Exit Function
                    
  If Not gDB.SaveEx(register, , _
                    cscMcjNrodoc, _
                    C_ABMClientSave, _
                    C_Module, _
                    c_ErrorSave) Then Exit Function
  
  If Not pSaveItems(register.id) Then Exit Function
  If Not pSaveMovimientos(register.id) Then Exit Function
  
  If Not pSaveCaja(register.id) Then Exit Function
  
  register.CommitTrans
  
  cIABMClient_Save = Load(register.id)
  
End Function

Private Function cIABMClient_Terminate() As Boolean
  m_Editing = False
  
  cIABMClient_Terminate = True
  ' Este objeto puede no cumplir con la interfaz esperada, asi que si hay un error no
  ' le doy bola
  On Error GoTo ControlError
  If m_Id = csNO_ID Then Exit Function
  If m_ObjTree Is Nothing Then Exit Function
  
  m_ObjTree.sqlstmt = "sp_lsdoc_Caja"
  
  If m_IsNew Then
    m_ObjTree.AddLine m_Id
  Else
    m_ObjTree.RefreshLine m_Id
  End If
ControlError:
End Function

Private Property Get cIABMClient_Title() As String
  If m_Id Then
                        ' Operacion
    cIABMClient_Title = LNGGetText(2108, vbNullString)
  Else
                        ' Apertura y Cierre de Cajas
    cIABMClient_Title = LNGGetText(4727, vbNullString)
  End If
End Property

Private Function cIABMClient_Validate() As Boolean

  Dim IProperty As cIABMProperty

  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_CJ_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(4729, vbNullString)  'Debe indicar un cliente
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
    cIEditGeneric_ShowList = SecurityCanAccess(csPreVtaListCaja)
End Function

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
    Set m_ObjAbm = rhs
End Property

Private Property Get cIEditGeneric_Editing() As Boolean
    cIEditGeneric_Editing = m_Editing
End Property

Private Function cIEditGeneric_Delete(id As Long) As Boolean
    If Not SecurityCanAccess(csPreVtaDeleteCaja) Then Exit Function

    Dim sqlstmt As String
    
    sqlstmt = "sp_MovimientoCajaDelete " & id & ", " & EmpId & ", " & User.id
    
    cIEditGeneric_Delete = gDB.Execute(sqlstmt, C_EditGenericDelete, C_Module)
End Function

Private Function cIEditGeneric_Search(id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If id = csNO_ID Then
    m_IsNew = True
    If Not SecurityCanAccess(csPreVtaNewCaja) Then Exit Function
  Else
    m_IsNew = False
    If Not SecurityCanAccess(csPreVtaEditCaja) Then Exit Function
  End If

  m_ObjAbm.InModalWindow = InModalWindow
  
  If Not Load(id) Then Exit Function
  
  If Not LoadCollection() Then Exit Function
  
  m_Editing = True

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

Private Property Let cIEditGeneric_BranchId(ByVal rhs As Long)
    m_BranchId = rhs
End Property

Private Property Get cIEditGeneric_BranchId() As Long
    cIEditGeneric_BranchId = m_BranchId
End Property

Private Function cIEditGeneric_Preview(ByVal id As Long) As Boolean

End Function

Private Function cIEditGeneric_PropertyChange(ByVal Key As Integer) As Boolean

End Function

Private Function cIMenuClient_Initialize(f As Object, Host As CSMenu.cIMenuHost) As Boolean
  On Error GoTo ControlError

  Dim str_1589 As String
    
  str_1589 = LNGGetText(1589, vbNullString) '&Ventas
  
  Set m_Host = Host

  m_Host.Server.AddMenu str_1589, csMenuEnum.csMenuVentas, vbNullString, 1, False, False, False, True, False, Nothing
                         '&Apertura/Cierre de Cajas
  m_Host.Server.AddMenu LNGGetText(4725, vbNullString), csPreVtaListCaja, str_1589, 0, True, False, False, False, False, Me
  
  cIMenuClient_Initialize = True
  
  GoTo ExitProc
ControlError:
  MngError Err, C_MenuClientInit, C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal id As Long) As Variant
  m_Host.MenuListDocClick "CSABMInterface2.CABMGeneric", "CSVenta2.cCaja", "CSABMInterface2.CABMGenericListDoc", "CSVenta2.cCajaListDoc", Me, LNGGetText(4727, vbNullString), 0
                                                                                                                                                        'Apertura y Cierre de Cajas
End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  
  Dim c As cIABMProperty
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  
  AbmObj.MinHeight = 8000
  AbmObj.MinWidth = 11000
  
  Const c_tab_general = 0
  Const c_tab_movimientos = 1
  
  With m_ObjAbm.Tabs
    .Clear
    
      .Clear
    
      With .Add(Nothing)
        .name = C_strGeneral
      End With
      
      With .Add(Nothing)
        .Index = c_tab_movimientos
        .name = LNGGetText(4728, vbNullString) 'Movimientos
      End With

  End With
  
  If m_Id Then
    If m_Tipo = 1 Then
      m_ObjAbm.Title2 = LNGGetText(4738, vbNullString, m_Caja, m_Nrodoc)
    Else
      m_ObjAbm.Title2 = LNGGetText(4739, vbNullString, m_Caja, m_Nrodoc)
    End If
  Else
    m_ObjAbm.Title2 = vbNullString
  End If

  With m_ObjAbm.Properties
    
    .Clear
  
    With .Add(Nothing, cscMcjNumero)
      .PropertyType = cspText
      .name = LNGGetText(1065, vbNullString)  'Número
      .Size = 100
      .Key = K_NUMERO
      .Value = m_Numero
      .Width = 1000
      .Enabled = False
    End With
      
    With .Add(Nothing, cscMcjNrodoc)
      .PropertyType = cspText
      .name = LNGGetText(1610, vbNullString)  'Comprobante
      .Size = 15
      .Key = K_NRODOC
      .Value = m_Nrodoc
      .Width = 2000
      .Enabled = False
      .TopFromProperty = cscMcjNumero
      .left = 4000
      .TopNotChange = True
      .LeftNotChange = True
    End With
            
    With .Add(Nothing, cscMcjFecha)
      .PropertyType = cspText
      .name = LNGGetText(1569, vbNullString)  'Fecha
      .Key = K_FECHA
      .Value = m_Fecha
      .Width = 1400
      .Enabled = False
      .TopFromProperty = cscMcjNumero
      .left = 7000
      .LeftLabel = -700
      .TopNotChange = True
      .LeftNotChange = True
    End With
                              
    With .Add(Nothing, cscMcjHora)
      .PropertyType = cspText
      .name = LNGGetText(1832, vbNullString)  'Hora
      .Key = K_HORA
      .Value = Format(m_Hora, "HH:NN")
      .Width = 800
      .Enabled = False
      .TopFromProperty = cscMcjNumero
      .left = 9100
      .LeftLabel = -500
      .TopNotChange = True
      .LeftNotChange = True
    End With
                              
    With .Add(Nothing, cscCjId)
      .PropertyType = cspHelp
      .Table = csCaja
      .name = LNGGetText(3497, vbNullString) 'Caja
      .Key = K_CJ_ID
      .Value = m_Caja
      .HelpId = m_cj_id
      .HelpFilter = "exists(select * from CajaCajero where cj_id = caja.cj_id and us_id = " & User.id & ")" & _
                    " and emp_id = " & EmpId
      .Width = 4450
      .Enabled = m_Id = csNO_ID
    End With
            
    With .Add(Nothing, cscUsIdCajero)
      .PropertyType = cspHelp
      .Table = csUsuario
      .name = LNGGetText(4716, vbNullString) 'Cajero
      .Key = K_US_ID_CAJERO
      .Value = m_Cajero
      .HelpId = m_us_id_cajero
      .Enabled = False
      .Width = 2900
      .TopFromProperty = cscCjId
      .LeftFromProperty = cscMcjFecha
      .LeftLabel = -700
    End With
            
    With .Add(Nothing, cscMcjDescrip)
      .PropertyType = cspText
      .LeftFromProperty = cscMcjNumero
      .name = C_strDescrip
      .SubType = cspMemo
      .Height = 880
      .Width = 8350
      .Size = 255
      .Key = K_DESCRIP
      .Value = m_Descrip
    End With
  
    With .Add(Nothing, c_total)
      .PropertyType = cspNumeric
      .SubType = cspDouble
      .name = LNGGetText(1584, vbNullString) 'Total
      .Key = K_TOTAL
      .Width = 1500
      .Enabled = False
    End With
  
    With .Add(Nothing, cscEstId)
      .PropertyType = cspText
      .name = LNGGetText(1568, vbNullString) 'Estado
      .Key = K_EST_ID
      .Width = 2700
      .Enabled = False
      .Value = m_Estado
      .TopFromProperty = c_total
      .left = 3800
      .LeftLabel = -600
      .Visible = m_Id = csNO_ID Or (m_as_id = csNO_ID And Not m_cerrada)
    End With
  
    With .Add(Nothing, c_accion)
      .PropertyType = cspText
      .name = LNGGetText(4735, vbNullString) 'Acción
      .Key = K_ACCION
      .Width = 1300
      .Enabled = False
      .Value = m_Accion
      .TopFromProperty = c_total
      .left = 7400
      .LeftLabel = -700
      .Visible = m_Id = csNO_ID Or (m_as_id = csNO_ID And Not m_cerrada)
    End With
    
    With .Add(Nothing, c_cmd_confirmar)
      .PropertyType = cspButton
      .name = LNGGetText(4737, vbNullString) 'Aceptar Cierre
      .Key = K_CMD_CONFIRMAR
      .Width = 1800
      .Enabled = False
      .TopFromProperty = c_total
      .left = 9000
      .LeftLabel = -1
      .Visible = False
    End With
    
    With .Add(Nothing, c_cmd_ver_asiento)
      .PropertyType = cspButton
      .name = LNGGetText(4740, vbNullString) 'Ver el Asiento Contable
      .Key = K_CMD_VER_ASIENTO
      .Width = 1800
      .Enabled = m_as_id
      .TopFromProperty = c_total
      .left = 9000
      .LeftLabel = -1
      .Visible = m_as_id
    End With
    
    
    Set c = .Add(Nothing, c_Items)
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      If Not pLoadItems(c) Then Exit Function
      .name = c_Items
      .Key = K_ITEMS
      .TabIndex = 0
      .GridAdd = False
      .GridEdit = True
      .GridRemove = False
      .Top = 3500
      .left = 200
    End With
      
    Set c = .Add(Nothing, c_Movimientos)
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      If Not pLoadMovimientos(c) Then Exit Function
      .name = c_Movimientos
      .Key = K_MOVIMIENTOS
      .TabIndex = c_tab_movimientos
      .Top = 1100
      .GridAdd = False
      .GridEdit = False
      .GridRemove = False
    End With
    
    If m_Id <> 0 Then pLoadMovimientosXCjId pGetMovimientos(), True
      
  End With
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  pShowTotales pGetItems().Grid.Rows
  
  pShowCmdConfirmar
  
  LoadCollection = True
End Function

Private Function Load(ByVal id As Long) As Boolean
  
  Dim sqlstmt As String
  Dim rs      As Recordset

  sqlstmt = "sp_MovimientoCajaGet " & id

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.fields, cscMcjId)
    m_Fecha = gDB.ValField(rs.fields, cscMcjFecha)
    m_Hora = gDB.ValField(rs.fields, cscMcjHora)
    m_Descrip = gDB.ValField(rs.fields, cscMcjDescrip)
    m_Numero = gDB.ValField(rs.fields, cscMcjNumero)
    m_Nrodoc = gDB.ValField(rs.fields, cscMcjNrodoc)
    m_us_id_cajero = gDB.ValField(rs.fields, cscUsIdCajero)
    m_Cajero = gDB.ValField(rs.fields, cscUsNombre)
    m_cj_id = gDB.ValField(rs.fields, cscCjId)
    m_Caja = gDB.ValField(rs.fields, cscCjNombre)
    m_cerrada = gDB.ValField(rs.fields, cscMcjCerrada)
    m_Tipo = gDB.ValField(rs.fields, cscMcjTipo)
    m_as_id = gDB.ValField(rs.fields, cscAsId)
    
    m_bItemsEditable = gDB.ValField(rs.fields, "items_editable")
    
    pGetEstadoFromTipo
    
  Else
    
    m_Id = csNO_ID
    m_Fecha = Date
    m_Hora = Now
    m_Descrip = vbNullString
    m_Numero = vbNullString
    m_Nrodoc = vbNullString
    m_us_id_cajero = User.id
    m_Cajero = User.name
    m_cj_id = csNO_ID
    m_Caja = vbNullString
    m_Tipo = 0
    m_as_id = csNO_ID
    m_Estado = vbNullString
    m_Accion = vbNullString
    m_cerrada = False
    
    m_bItemsEditable = True
    
  End If

  m_last_cj_id = m_cj_id

  Load = True
End Function

Private Function pSaveCaja(ByVal mcj_id As Long) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_MovimientoCajaSave " & mcj_id
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  If rs.EOF Then Exit Function
  If gDB.ValField(rs.fields, "success") = 0 Then
    MsgWarning gDB.ValField(rs.fields, "info")
    Exit Function
  End If
  pSaveCaja = True
End Function

Private Function pGetTipo() As Integer
  Dim sqlstmt As String
  Dim rs As ADODB.Recordset
  
  sqlstmt = "sp_MovimientoCajaGetTipo " & pGetCaja().HelpId
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  If rs.EOF Then Exit Function
  
  pGetTipo = rs.fields(0).Value
  
End Function

Private Function pGetCaja() As cIABMProperty
  Set pGetCaja = m_ObjAbm.Properties(cscCjId)
End Function

Private Function pGetItems() As cIABMProperty
  Set pGetItems = m_ObjAbm.Properties(c_Items)
End Function

Private Function pGetFecha() As cIABMProperty
  Set pGetFecha = m_ObjAbm.Properties(cscMcjFecha)
End Function

Private Function pGetMovimientos() As cIABMProperty
  Set pGetMovimientos = m_ObjAbm.Properties(c_Movimientos)
End Function

'-------------------------------------------------------------------------
Private Function pLoadItems(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
    
  sqlstmt = "sp_MovimientoCajaGetItems " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadItems", C_Module) Then Exit Function
  
  Dim mon_id_default  As Long
  Dim mon_id          As Long
  
  mon_id_default = GetMonedaDefault()
  
  With Propiedad.Grid
  
    .Columns.Clear
    .Rows.Clear
    
    With .Columns
  
      With .Add(Nothing)
        .Visible = False
        .Key = KI_MCJI_ID
      End With
      
      With .Add(Nothing)
        .Visible = False
        .Key = KI_CUE_ID_FONDOS
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(1267, vbNullString)  'Cuenta
        .Key = KI_CUE_ID_TRABAJO
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(1113, vbNullString) 'Moneda
        .Key = KI_MON_ID
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(1635, vbNullString)
        .Key = KI_COTIZACION
        .PropertyType = cspNumeric
        .SubType = cspMoney
        .Format = m_GeneralConfig.FormatDecCotizacion
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(1228, vbNullString)  'Importe
        .PropertyType = cspNumeric
        .SubType = cspMoney
        .Format = m_GeneralConfig.FormatDecImporte
        .Width = 1200
        .Key = KI_IMPORTE
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(1861, vbNullString)  'Observaciones
        .PropertyType = cspText
        .SubType = cspTextButtonEx
        .Key = KI_DESCRIP
      End With
      
    End With
  
    With .Rows
    
      While Not rs.EOF
      
        With .Add(Nothing, rs(cscMcjiId).Value)
        
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscMcjiId)
            .Key = KI_MCJI_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCueIdFondos)
            .Key = KI_CUE_ID_FONDOS
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCueNombre)
            .id = gDB.ValField(rs.fields, cscCueIdTrabajo)
            .Key = KI_CUE_ID_TRABAJO
          End With
          
          With .Add(Nothing)
            mon_id = gDB.ValField(rs.fields, cscMonId)
            .Value = gDB.ValField(rs.fields, cscMonNombre)
            .id = mon_id
            .Key = KI_MON_ID
          End With
          
          With .Add(Nothing)
            If mon_id_default <> mon_id Then
              .Value = gDB.ValField(rs.fields, cscMcjiCotizacion)
            End If
            .Key = KI_COTIZACION
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscMcjiImporte)
            .Key = KI_IMPORTE
          End With
                    
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscMcjiDescrip)
            .Key = KI_DESCRIP
          End With
                    
        End With
        
        rs.MoveNext
      Wend
    End With
  End With
  
  pLoadItems = True
End Function

Private Function pLoadMovimientos(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
    
  sqlstmt = "sp_MovimientoCajaGetMovimientos " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadMovimientos", C_Module) Then Exit Function
  
  With Propiedad.Grid
  
    .Columns.Clear
    .Rows.Clear
    
    With .Columns
  
      With .Add(Nothing)
        .Visible = False
        .Key = KI_MCJM_ID
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(4730, vbNullString)  'Asiento
        .Key = KI_AS_ID
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(1610, vbNullString)  'Comprobante
        .Key = KI_COMPROBANTE
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(1569, vbNullString)  'Fecha
        .Key = KI_FECHA
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(1228, vbNullString)  'Importe
        .PropertyType = cspNumeric
        .Format = m_GeneralConfig.FormatDecImporte
        .SubType = cspMoney
        .Width = 1200
        .Key = KI_IMPORTE
      End With
      
      With .Add(Nothing)
        .name = LNGGetText(1861, vbNullString)  'Observaciones
        .Key = KI_DESCRIP
      End With
      
    End With
  
    With .Rows
    
      While Not rs.EOF
      
        With .Add(Nothing, rs(cscMcjmId).Value)
        
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscMcjmId)
            .Key = KI_MCJM_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscAsNrodoc)
            .id = gDB.ValField(rs.fields, cscAsId)
            .Key = KI_AS_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscAsDocCliente)
            .id = gDB.ValField(rs.fields, cscCobzId)
            .Key = KI_COMPROBANTE
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscAsFecha)
            .Key = KI_FECHA
          End With
                    
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscMcjmImporte)
            .Key = KI_IMPORTE
          End With
                    
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscMcjmDescrip)
            .Key = KI_DESCRIP
          End With
                    
        End With
        
        rs.MoveNext
      Wend
    End With
  End With
  
  pLoadMovimientos = True
End Function

Private Function pLoadItemsXCjId(ByRef iProp As cIABMProperty) As Boolean
  
  ' Solo cargo si estamos en nuevo
  '
  If m_Id Then Exit Function
  
  m_Tipo = pGetTipo()
  
  pGetEstadoFromTipo

  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  Dim mon_id_default  As Long
  Dim mon_id          As Long
  
  mon_id_default = GetMonedaDefault()
    
  sqlstmt = "sp_MovimientoCajaGetItemsXCjId " & pGetCaja().HelpId
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadItemsXCjId", C_Module) Then Exit Function
  
  With iProp.Grid
  
    .Rows.Clear
  
    With .Rows
    
      While Not rs.EOF
      
        With .Add(Nothing)
        
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscMcjiId)
            .Key = KI_MCJI_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCueIdFondos)
            .Key = KI_CUE_ID_FONDOS
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCueNombre)
            .id = gDB.ValField(rs.fields, cscCueIdTrabajo)
            .Key = KI_CUE_ID_TRABAJO
          End With
          
          With .Add(Nothing)
            mon_id = gDB.ValField(rs.fields, "mon_id_cuenta")
            .Value = gDB.ValField(rs.fields, cscMonNombre)
            .id = mon_id
            .Key = KI_MON_ID
          End With
          
          With .Add(Nothing)
            If mon_id_default <> mon_id Then
              .Value = GetCotizacion(mon_id, pGetFecha().Value)
            End If
            .Key = KI_COTIZACION
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, "saldo")
            .Key = KI_IMPORTE
          End With
                    
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscMcjiDescrip)
            .Key = KI_DESCRIP
          End With
                    
        End With
        
        rs.MoveNext
      Wend
    End With
  End With
  
  Dim AbmGen As cABMGeneric
  Set AbmGen = m_ObjAbm
  
  AbmGen.ShowValue iProp, True
  
  Set iProp = m_ObjAbm.Properties.Item(cscEstId)
  iProp.Value = m_Estado
  AbmGen.ShowValue iProp
  
  Set iProp = m_ObjAbm.Properties.Item(c_accion)
  iProp.Value = m_Accion
  AbmGen.ShowValue iProp
  
  m_last_cj_id = pGetCaja().HelpId
  
  pLoadItemsXCjId = True
End Function

Private Function pSaveItems(ByVal id As Long) As Boolean
  Dim register    As cRegister
  Dim iOrden      As Long
  Dim Origen      As Double
  Dim Importe     As Double
  Dim Cotizacion  As Double
  
  Dim Row  As cIABMGridRow
  Dim Cell As cIABMGridCellValue
  
  Dim mon_id_default  As Long
  Dim mon_id          As Long
  
  mon_id_default = GetMonedaDefault()
  
  For Each Row In pGetItems().Grid.Rows
  
    Set register = New cRegister
    register.fieldId = cscMcjiId
    register.Table = csTMovimientoCajaItem
    
    For Each Cell In Row
      Select Case Cell.Key
        
        Case KI_MCJI_ID
          register.id = Val(Cell.Value)
        Case KI_CUE_ID_FONDOS
          register.fields.Add2 cscCueIdFondos, Val(Cell.Value), csId
        Case KI_CUE_ID_TRABAJO
          register.fields.Add2 cscCueIdTrabajo, Cell.id, csId
        Case KI_MON_ID
          mon_id = Cell.id
          register.fields.Add2 cscMonId, Cell.id, csId
        Case KI_COTIZACION
          Cotizacion = Val(Cell.Value)
          register.fields.Add2 cscMcjiCotizacion, Cotizacion, csDouble
        Case KI_IMPORTE
          Importe = Val(Cell.Value)
          If mon_id_default = mon_id Then
            register.fields.Add2 cscMcjiImporte, Importe, csCurrency
          Else
            register.fields.Add2 cscMcjiImporte, Importe * Cotizacion, csCurrency
          End If
        
        Case KI_DESCRIP
          register.fields.Add2 cscMcjiDescrip, Cell.Value, csText
          
      End Select
    Next
    
    ' Por seguridad
    Origen = Importe
    
    If mon_id_default = mon_id Then
      register.fields.Add2 cscMcjiOrigen, Importe, csCurrency
    Else
      register.fields.Add2 cscMcjiOrigen, 0, csCurrency
    End If
    
    iOrden = iOrden + 1
    register.fields.Add2 cscMcjiOrden, iOrden, csInteger
    register.fields.Add2 cscMcjId, id, csId
    
    register.fields.HaveLastUpdate = False
    register.fields.HaveWhoModify = False
    
    If Not gDB.Save(register, , "pSaveItems", C_Module, c_ErrorSave) Then Exit Function
  
  Next
  
  pSaveItems = True
End Function

Private Function pSaveMovimientos(ByVal id As Long) As Boolean
  
  If m_Tipo = 2 Then

    Dim register    As cRegister
    Dim iOrden      As Long
    
    Dim Row  As cIABMGridRow
    Dim Cell As cIABMGridCellValue
    
    For Each Row In pGetMovimientos().Grid.Rows
    
      Set register = New cRegister
      register.fieldId = cscMcjmId
      register.Table = csTMovimientoCajaMovimiento
      
      For Each Cell In Row
        
        Select Case Cell.Key
          Case KI_MCJM_ID
            register.id = Val(Cell.Value)
          Case KI_IMPORTE
            register.fields.Add2 cscMcjmImporte, Cell.Value, csCurrency
          Case KI_AS_ID
            register.fields.Add2 cscAsId, Cell.id, csId
          Case KI_DESCRIP
            register.fields.Add2 cscMcjmDescrip, Cell.Value, csText
        End Select
        
      Next
      
      iOrden = iOrden + 1
      register.fields.Add2 cscMcjmOrden, iOrden, csInteger
      register.fields.Add2 cscMcjId, id, csId
      
      register.fields.HaveLastUpdate = False
      register.fields.HaveWhoModify = False
      
      If Not gDB.Save(register, , "pSaveMovimientos", C_Module, c_ErrorSave) Then Exit Function
    
    Next
  
  End If
  
  pSaveMovimientos = True
End Function

'-------------------------------------------------------------------------

' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  c_ErrorSave = LNGGetText(4726, vbNullString) ' Error al grabar el movimiento de caja

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
  Set m_ObjAbm = Nothing
  Set m_ObjTree = Nothing
  Set m_GeneralConfig = Nothing
End Sub

'------------------------------------------------------------------------
Private Function cIABMClientGrid_IsEmptyRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_ITEMS
      cIABMClientGrid_IsEmptyRow = False
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ValidateRow", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIABMClientGrid_ColumnAfterUpdate(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long) As Boolean
  On Error GoTo ControlError
  
  Select Case Key
    Case K_ITEMS
      With pGetItems()
        pShowTotales .Grid.Rows
      End With
      cIABMClientGrid_ColumnAfterUpdate = True
  End Select

  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ColumnAfterUpdate", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIABMClientGrid_ColumnAfterEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long) As Boolean
  cIABMClientGrid_ColumnAfterEdit = True
End Function

Private Function cIABMClientGrid_ColumnBeforeEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean
  Select Case Key
    Case K_ITEMS
      If pGetItems().Grid.Rows.Item(lRow).Item(lCol).Key = KI_COTIZACION Then
        cIABMClientGrid_ColumnBeforeEdit = False
      ElseIf pGetItems().Grid.Rows.Item(lRow).Item(lCol).Key = KI_DESCRIP Then
        cIABMClientGrid_ColumnBeforeEdit = True
      Else
        cIABMClientGrid_ColumnBeforeEdit = m_Tipo = 1 And m_bItemsEditable
      End If
    Case Else
      cIABMClientGrid_ColumnBeforeEdit = True
  End Select
End Function

Private Function cIABMClientGrid_ColumnButtonClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean

End Function

Private Sub cIABMClientGrid_ColumnCancelEdit(ByVal Key As Integer)

End Sub

Private Sub cIABMClientGrid_ColumnClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Sub cIABMClientGrid_DblClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)
  On Error GoTo ControlError
  
  Select Case Key
    Case K_MOVIMIENTOS
      pShowDoc pGetMovimientos.Grid.Rows(lRow)
  End Select

  Exit Sub
ControlError:
  MngError Err, "cIABMClientGrid_DblClick", C_Module, vbNullString
End Sub

Private Sub pShowDoc(ByRef Row As cIABMGridRow)
  If pCell(Row, KI_COMPROBANTE).id Then
  
    ShowDocAux pCell(Row, KI_COMPROBANTE).id, _
               "CSTesoreria2.cCobranza", _
               "CSABMInterface2.cABMGeneric"

  Else
  
    ShowDocAux pCell(Row, KI_AS_ID).id, _
               "CSContabilidad2.cAsiento", _
               "CSABMInterface2.cABMGeneric"

  End If
End Sub

Private Function cIABMClientGrid_DeleteRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal lRow As Long) As Boolean
  cIABMClientGrid_DeleteRow = False
End Function

Private Function cIABMClientGrid_ListAdHock(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal ColIndex As Long, List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClientGrid_NewRow(ByVal Key As Integer, ByVal Rows As Integer)

End Sub

Private Function cIABMClientGrid_ValidateRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  cIABMClientGrid_ValidateRow = True
End Function

Private Sub pShowTotales(ByRef Rows As CSInterfacesABM.cIABMGridRows)
  Dim Total     As Double
  Dim Cotiz     As Double
  Dim Row       As CSInterfacesABM.cIABMGridRow

  For Each Row In Rows
  
    Cotiz = Val(pCell(Row, KI_COTIZACION).Value)
    Total = Total + Val(pCell(Row, KI_IMPORTE).Value) * IIf(Cotiz, Cotiz, 1)
  
  Next
  
  m_ObjAbm.Properties.Item(c_total).Value = Total
  m_ObjAbm.ShowValue m_ObjAbm.Properties.Item(c_total)
  
End Sub

Private Sub pGetEstadoFromTipo()
  
  If m_Tipo = 1 Then
    
    m_Estado = LNGGetText(4733, vbNullString)
    m_Accion = LNGGetText(4732, vbNullString)
  
  Else
    
    If m_Id = csNO_ID Then
      
      m_Estado = LNGGetText(4731, vbNullString)
      m_Accion = LNGGetText(4734, vbNullString)
    
    Else
    
      m_Estado = LNGGetText(4741, vbNullString)
      m_Accion = LNGGetText(4737, vbNullString)
    
    End If
    
  End If

End Sub

Private Function pLoadMovimientosXCjId(ByRef iProp As cIABMProperty, ByVal inLoadCollection As Boolean) As Boolean
  
  ' Solo cargo si estamos en nuevo
  '
  If m_Id <> 0 And m_Tipo <> 1 Then Exit Function
  
  If m_Id = 0 And m_Tipo <> 2 Then Exit Function
      
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
      
  sqlstmt = "sp_MovimientoCajaGetMovimientosXCjId " & pGetCaja().HelpId
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadMovimientosXCjId", C_Module) Then Exit Function
  
  With iProp.Grid
  
    .Rows.Clear
  
    With .Rows
    
      If Not rs.EOF Then
        rs.Sort = "sort_column desc"
      End If
    
      While Not rs.EOF
      
        With .Add(Nothing)
        
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscMcjmId)
            .Key = KI_MCJM_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscAsNrodoc)
            .id = gDB.ValField(rs.fields, "as_id_movimiento")
            .Key = KI_AS_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscAsDocCliente)
            .id = gDB.ValField(rs.fields, cscCobzId)
            .Key = KI_COMPROBANTE
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscAsFecha)
            .Key = KI_FECHA
          End With
                    
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, "importe")
            .Key = KI_IMPORTE
          End With
                    
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscMcjmDescrip)
            .Key = KI_DESCRIP
          End With
                    
        End With
        
        rs.MoveNext
      Wend
    End With
  End With
  
  If Not inLoadCollection Then
  
    Dim AbmGen As cABMGeneric
    Set AbmGen = m_ObjAbm
  
    AbmGen.ShowValue iProp, True
  
  End If
  
  pLoadMovimientosXCjId = True
End Function

Private Sub pShowCmdConfirmar()
  
  If m_Id = csNO_ID Then Exit Sub
  
  Dim iProp As cIABMProperty
  
  If m_Tipo = 2 And m_as_id = csNO_ID Then
    
    Set iProp = m_ObjAbm.Properties.Item(c_cmd_confirmar)
    iProp.Visible = True
    iProp.Enabled = True
  
    Dim AbmGen As cABMGeneric
    Set AbmGen = m_ObjAbm
    
    AbmGen.ShowValue iProp
  
  End If

End Sub

Private Function pSaveAsiento() As Boolean
  
  If Not SecurityCanAccess(csPreVtaAceptarCierre) Then Exit Function
  
  Dim sqlstmt As String
  Dim rs As ADODB.Recordset
  
  sqlstmt = "sp_MovimientoCajaSaveAsiento " & m_Id & ",-1,0,'',1"
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  Dim id As Long
  If Not GetDocIDFromRecordset(rs, id) Then Exit Function
  
  m_as_id = id
  
  sqlstmt = "update MovimientoCaja set mcj_cerrada = 1 where mcj_id = " & m_Id
  If Not gDB.Execute(sqlstmt) Then Exit Function
  
  pSaveAsiento = True
  
  Dim iProp As cIABMProperty
  Dim AbmGen As cABMGeneric
  Set AbmGen = m_ObjAbm
  
  Set iProp = m_ObjAbm.Properties.Item(c_cmd_confirmar)
  iProp.Visible = False
  iProp.Enabled = False
  
  AbmGen.ShowValue iProp
  
  If m_as_id Then
  
    Set iProp = m_ObjAbm.Properties.Item(c_cmd_ver_asiento)
    iProp.Visible = True
    iProp.Enabled = True
    
    AbmGen.ShowValue iProp
  
  End If
  
  Set iProp = m_ObjAbm.Properties.Item(cscEstId)
  iProp.Visible = False
  iProp.Enabled = False
  
  AbmGen.ShowValue iProp
  
  Set iProp = m_ObjAbm.Properties.Item(c_accion)
  iProp.Visible = False
  iProp.Enabled = False
  
  AbmGen.ShowValue iProp
  
End Function

Private Function pVerAsiento()
    
  ShowDocAux m_as_id, _
             "CSContabilidad2.cAsiento", _
             "CSABMInterface2.cABMGeneric"

End Function

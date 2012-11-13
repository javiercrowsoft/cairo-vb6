VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cPickingList"
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
' cPickingList
' 15-12-2007

'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cPickingList"

Private Const c_Todos = "Todos"
Private Const c_Facturas = "Facturas"
Private Const c_cmd_selectAll = "SelectAll"
Private Const c_cmd_replacePr = "ReplacePr"
Private Const c_cmd_facturar = "Facturar"
Private Const c_cmd_hojaruta = "HojaRuta"
Private Const c_cmd_printfactura = "PrintFactura"

Private Const c_select_key = "kselect"

Private Const c_Tipo_Pedido = 1

Private Const c_key_col_cliente = "col_cli"
Private Const c_key_col_pedido = "col_pedido"

' Totales en la solapa de items
'
Private Const c_t_total_os = "t_total_os"

' Totales en la solapa general
Private Const c_t_total_os2 = "t_total_os2"

Private Const csTareaEstado = 2004

Private Const c_T_FECHA_DESDE                 As String = "c_T_FECHA_DESDE"
Private Const c_T_FECHA_HASTA                 As String = "c_T_FECHA_HASTA"
Private Const c_T_CLI_ID                      As String = "c_T_CLI_ID"
Private Const c_T_ESTADO                      As String = "c_T_ESTADO"
Private Const c_T_CMD_LOAD                    As String = "c_T_CMD_LOAD"
Private Const c_T_VENDEDOR                    As String = "c_T_VENDEDOR"
Private Const c_T_ZONA                        As String = "c_T_ZONA"

Private Const K_NRODOC                         As Integer = 1
Private Const K_FECHA                          As Integer = 2
Private Const K_NUMERO                         As Integer = 3
Private Const K_DESCRIP                        As Integer = 4
Private Const K_FECHAENTREGA                   As Integer = 5
Private Const K_TOTAL                          As Integer = 9
Private Const K_SUC_ID                         As Integer = 11
Private Const K_CUMPLIDO                       As Integer = 24
Private Const K_TODOS                          As Integer = 17
Private Const K_FACTURAS                       As Integer = 18

Private Const K_T_FECHA_DESDE                 As Integer = 700
Private Const K_T_FECHA_HASTA                 As Integer = 701
Private Const K_T_CLI_ID                      As Integer = 702
Private Const K_T_ESTADO                      As Integer = 703
Private Const K_T_CMD_LOAD                    As Integer = 704

Private Const K_T_VENDEDOR                    As Integer = 705
Private Const K_T_ZONA                        As Integer = 706

Private Const K_TOTAL_OS                       As Integer = 501

Private Const K_TOTAL_OS2                      As Integer = 511
Private Const K_CMD_SELECT_ALL                 As Integer = 515
Private Const K_CMD_REPLACE_PR                 As Integer = 516
Private Const K_CMD_FACTURAR                   As Integer = 517
Private Const K_CMD_HOJARUTA                   As Integer = 518
Private Const K_CMD_PRINTFACTURA               As Integer = 519

Private Const KI_PKLPV_ID                      As Integer = 1
Private Const KI_TIPO                          As Integer = 1001
Private Const KI_PV_ID                         As Integer = 2
Private Const KI_SELECT                        As Integer = 3

' Esto es un desastre ya lo se, pero por ahora es asi
' el valor de esta constante afecta al agrupamiento de columnas
' asi que no se puede cambiar
'
Private Const KI_CLIENTE                       As Integer = 4

' Esto es un desastre ya lo se, pero por ahora es asi
' el valor de esta constante afecta al agrupamiento de columnas
' asi que no se puede cambiar
'
Private Const KI_NRODOC                        As Integer = 5

Private Const KI_FECHA                         As Integer = 6
Private Const KI_PVI_ID                        As Integer = 7
Private Const KI_IMPORTE                       As Integer = 8
Private Const KI_PENDIENTE                     As Integer = 307
Private Const KI_ORDEN                         As Integer = 1000
Private Const KI_DESCRIP                       As Integer = 2001
Private Const KI_CANTIDAD_PV                   As Integer = 2005
Private Const KI_CANTIDAD_ST                   As Integer = 2006
Private Const KI_PRODUCTO                      As Integer = 2007
Private Const KI_PKLPVI_ID                     As Integer = 2008
Private Const KI_CANTIDAD_PV_REAL              As Integer = 2009
Private Const KI_CCOS_ID                       As Integer = 2010

Private Const KI_FV_ID                         As Integer = 1
Private Const KI_FV_SELECT                     As Integer = 2
Private Const KI_FV_CLIENTE                    As Integer = 3
Private Const KI_FV_NRODOC                     As Integer = 4
Private Const KI_FV_DOC                        As Integer = 5
Private Const KI_FV_IMPORTE                    As Integer = 6
Private Const KI_FV_DESCRIP                    As Integer = 7
Private Const KI_FV_ZONA                       As Integer = 8
Private Const KI_FV_VENDEDOR                   As Integer = 9

' Seudo - Variables
Private c_ErrorSave                   As String

' estructuras

' variables privadas
Private m_Id                           As Long
Private m_Numero                       As Long
Private m_Nrodoc                       As String
Private m_Descrip                      As String
Private m_Fecha                        As Date
Private m_Fechaentrega                 As Date
Private m_Total                        As Double
Private m_pendiente                    As Double
Private m_Firmado                      As Long

Private m_est_id                       As Long
Private m_Estado                       As String
Private m_suc_id                       As Long
Private m_Sucursal                     As String

Private m_emp_id                       As Long
Private m_Empresa                      As String
Private m_cumplida                     As Boolean

Private m_GeneralConfig     As cGeneralConfig

'OJO HASTA ACA

Private m_Editing           As Boolean

Private m_ObjAbm            As cIABMGeneric
Private m_ObjTree           As Object

Private m_IsNew             As Boolean

Private m_BranchId          As Long
Private m_TreeId            As Long

Private m_Host              As CSMenu.cIMenuHost
Private m_Copy              As Boolean

Private m_FechaDesde        As Date
Private m_FechaHasta        As Date

Private m_RamaCliente       As String
Private m_RamaEstado        As String
Private m_RamaVendedor      As String
Private m_RamaZona          As String

Private m_ram_id_cliente    As String
Private m_ram_id_estado     As String
Private m_ram_id_vendedor   As String
Private m_ram_id_zona       As String

' Preferencias del Usuario
'
Private m_UserCfg           As cUsuarioConfig

' Properties publicas
' Properties privadas
' funciones publicas

' Implementacion de cIABMClient
Private Function cIABMClient_Copy() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True
  
  With m_ObjAbm.Properties(cscPklNrodoc)
    .Value = C_CopiaDe & .Value
  End With
    
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscPklNrodoc)
  
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

  Doc.ClientTable = csTPickingList
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
  
    Case MSG_GRID_ROW_DELETED
      cIABMClient_MessageEx = True
    
    Case MSG_ABM_PRINT
      
      If m_Id = csNO_ID Then
        MsgInfo LNGGetText(4859, vbNullString), LNGGetText(1853, vbNullString)
              'Debe grabar la lista de despacho para poder imprimirla, Imprimir
      Else
        Dim AbmObj As cABMGeneric
        Set AbmObj = m_ObjAbm
        AbmObj.PrintABM m_Id, -csPickingList ' El menos es para que pase Id y no NODO Id en PrintManager
      End If
      
      cIABMClient_MessageEx = True
    
    Case MSG_ABM_CAN_PRINT
      
      cIABMClient_MessageEx = MSG_ABM_CAN_PRINT
  
    Case MSG_DOC_REFRESH
      pRefreshProperties
  
  End Select

End Function

Private Sub cIABMClient_DiscardChanges()
  LoadCollection
End Sub

Private Function cIABMClient_ListAdHock(List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClient_Load()

End Sub

Private Function cIABMClient_PropertyChange(ByVal Key As Integer) As Boolean
  
  Dim AbmObj As cABMGeneric
  
  Select Case Key
    
    Case K_T_CMD_LOAD
    
      If Not pSaveChanges() Then Exit Function
      
      pLoadTodos pGetTodos(), True
      
      Set AbmObj = m_ObjAbm
      
      AbmObj.GroupGridEx pGetTodos(), _
                         c_key_col_cliente, _
                         c_key_col_pedido, _
                         4
              
    Case K_T_FECHA_DESDE
      m_FechaDesde = m_ObjAbm.Properties.Item(c_T_FECHA_DESDE).Value
    
    Case K_T_FECHA_HASTA
      m_FechaHasta = m_ObjAbm.Properties.Item(c_T_FECHA_HASTA).Value
    
    Case K_T_CLI_ID
      
      With m_ObjAbm.Properties.Item(c_T_CLI_ID)
        m_ram_id_cliente = .HelpValueProcess
        m_RamaCliente = .Value
      End With
    
    Case K_T_ESTADO
    
      With m_ObjAbm.Properties.Item(c_T_ESTADO)
        m_ram_id_estado = .HelpValueProcess
        m_RamaEstado = .Value
      End With
        
    Case K_T_VENDEDOR
      
      With m_ObjAbm.Properties.Item(c_T_VENDEDOR)
        m_ram_id_vendedor = .HelpValueProcess
        m_RamaVendedor = .Value
      End With
        
    Case K_T_ZONA
      
      With m_ObjAbm.Properties.Item(c_T_ZONA)
        m_ram_id_zona = .HelpValueProcess
        m_RamaZona = .Value
      End With
        
    Case K_CMD_SELECT_ALL
      
      If pGetCMDSelectAll.Name = c_selectall2 Then
        pSelectAll True
        pGetCMDSelectAll.Name = c_unselectall2
      Else
        pSelectAll False
        pGetCMDSelectAll.Name = c_selectall2
      End If
      
      Set AbmObj = m_ObjAbm
      AbmObj.ShowValue pGetCMDSelectAll
      
      pShowTotal
        
    Case K_CMD_REPLACE_PR
    
      pShowReplace
      
    Case K_CMD_FACTURAR
      
      pShowFacturar
      
    Case K_CMD_HOJARUTA
    
      pShowHojaRuta
      
    Case K_CMD_PRINTFACTURA
    
      pPrintFactura
        
  End Select

End Function

Private Function cIABMClient_Save() As Boolean
  
  '--/////////////////////////////////////////////
  
    With m_ObjAbm.Properties
      
      m_FechaDesde = .Item(c_T_FECHA_DESDE).Value
      m_FechaHasta = .Item(c_T_FECHA_HASTA).Value
      
      With .Item(c_T_CLI_ID)
        m_ram_id_cliente = .HelpValueProcess
        m_RamaCliente = .Value
      End With
      
      With .Item(c_T_ESTADO)
        m_ram_id_estado = .HelpValueProcess
        m_RamaEstado = .Value
      End With
      
      With .Item(c_T_VENDEDOR)
        m_ram_id_vendedor = .HelpValueProcess
        m_RamaVendedor = .Value
      End With
      
      With .Item(c_T_ZONA)
        m_ram_id_zona = .HelpValueProcess
        m_RamaZona = .Value
      End With
      
    End With
  
  '--/////////////////////////////////////////////
  
  Dim register   As cRegister
  Dim fields     As cFields
  Dim Alarma     As Date
  
  Set register = New cRegister
  
  With register
  
    Set fields = .fields
    
    .fieldId = cscPklId
    .Table = csTPickingList
  
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

        Case K_NRODOC
          fields.Add2 cscPklNrodoc, .Value, csText
        Case K_FECHA
          fields.Add2 cscPklFecha, .Value, csDate
        Case K_SUC_ID
          register.fields.Add2 cscSucId, .HelpId, csId
        Case K_FECHAENTREGA
          register.fields.Add2 cscPklFechaentrega, .Value, csDate
        Case K_DESCRIP
          register.fields.Add2 cscPklDescrip, .Value, csText
        Case K_TOTAL
          register.fields.Add2 cscPklTotal, .Value, csDouble
        Case K_CUMPLIDO
          register.fields.Add2 cscPklCumplido, .Value, csBoolean
        Case K_T_VENDEDOR
          register.fields.Add2 cscVenId, .HelpValueProcess, csText
        Case K_T_ZONA
          register.fields.Add2 cscZonId, .HelpValueProcess, csText
        Case K_T_FECHA_DESDE
          register.fields.Add2 cscPklFechadesde, .Value, csDate
        Case K_T_FECHA_HASTA
          register.fields.Add2 cscPklFechahasta, .Value, csDate
      End Select
    End With
  Next
  
  fields.Add2 cscEstId, 1, csId ' pendiente
  
  fields.HaveLastUpdate = True
  fields.HaveWhoModify = True
  
  If Not register.BeginTrans(gDB) Then Exit Function
  
  If Not gDB.Save(register, , _
                  "cIABMClient_Save", _
                  C_Module, _
                  c_ErrorSave) Then Exit Function

  pSaveNroPickingList register.id
  
  ' Si voy a guardar desde la grilla de documentos
  ' borro todos y los vuelvo a generar
  '
  
  Dim sqlstmt As String
  sqlstmt = "delete PickingListPedidoItem where pkl_id = " & register.id _
          & " delete PickingListPedido where pkl_id = " & register.id
  
  If Not gDB.Execute(sqlstmt) Then Exit Function
  
  If Not pSaveItemsTodos(register.id) Then Exit Function
  If Not pSaveFacturas() Then Exit Function
  
  If Not register.CommitTrans() Then Exit Function
  
  m_Copy = False
  
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
  
  m_ObjTree.sqlstmt = "sp_lsdoc_PickingList"
  
  If m_IsNew Then
    m_ObjTree.AddLine m_Id
  Else
    m_ObjTree.RefreshLine m_Id
  End If
ControlError:
End Function

Private Property Get cIABMClient_Title() As String
    cIABMClient_Title = LNGGetText(4860, vbNullString) 'Listas de Despacho
End Property

Private Function cIABMClient_Validate() As Boolean

  Dim IProperty As cIABMProperty

  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_FECHA
          If ValEmpty(.Value, csDate) Then
            MsgInfo LNGGetText(1558, vbNullString) 'Debe indicar una fecha
            Exit Function
          End If
        Case K_SUC_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(1560, vbNullString)
                    'Debe indicar una Sucursal
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
    cIEditGeneric_ShowList = SecurityCanAccess(csPreVtaListPickingList)
End Function

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
    Set m_ObjAbm = rhs
End Property

Private Property Get cIEditGeneric_Editing() As Boolean
    cIEditGeneric_Editing = m_Editing
End Property

Private Function cIEditGeneric_Delete(id As Long) As Boolean
    If Not SecurityCanAccess(csPreVtaDeletePickingList) Then Exit Function

    Dim sqlstmt As String
  
    sqlstmt = "sp_PickingListDelete " & id
    
    cIEditGeneric_Delete = gDB.Execute(sqlstmt, "cIEditGeneric_Delete", C_Module)
End Function

Private Function cIEditGeneric_Search(id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If id = csNO_ID Then
    m_IsNew = True
    If Not SecurityCanAccess(csPreVtaNewPickingList) Then Exit Function
  Else
    m_IsNew = False
    If Not SecurityCanAccess(csPreVtaEditPickingList) Then Exit Function
  End If
  
  m_ObjAbm.InModalWindow = InModalWindow
  
  m_ram_id_estado = m_UserCfg.est_id_pickinglist
  m_RamaEstado = m_UserCfg.EstadoPickingList
  
  m_ram_id_vendedor = csNO_ID
  m_RamaVendedor = vbNullString
  
  m_ram_id_zona = csNO_ID
  m_RamaZona = vbNullString
  
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
  MngError Err, "cIEditGeneric_Edit ", C_Module, vbNullString
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

' Menu Client
Private Function cIMenuClient_Initialize(f As Object, Host As CSMenu.cIMenuHost) As Boolean
  On Error GoTo ControlError
  
  Dim str_1589 As String
  
  str_1589 = LNGGetText(1589, vbNullString)  '&Ventas
  
  Set m_Host = Host
  m_Host.Server.AddMenu str_1589, csMenuEnum.csMenuVentas, vbNullString, 1, False, False, False, True, False, Nothing
  m_Host.Server.AddMenu LNGGetText(4862, vbNullString), csPreVtaListPickingList, str_1589, 0, True, False, False, False, False, Me
                        '&Listas de Despacho
  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, "cIMenuClient_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal id As Long) As Variant
  m_Host.MenuListDocClick "CSABMInterface2.CABMGeneric", _
                          "CSVenta2.cPickingList", _
                          "CSABMInterface2.CABMGenericListDoc", _
                          "CSVenta2.cPickingListListDoc", _
                          Me, _
                          LNGGetText(4863, vbNullString), _
                          0
                          'Listas de Despacho
End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  Dim oGrid   As cABMGrid
  Dim c       As cIABMProperty
  Dim AbmObj  As cABMGeneric
  Dim oProp   As cABMProperty
  
  Set AbmObj = m_ObjAbm
  AbmObj.bSendRefresh = True
  AbmObj.MinHeight = 9500
  AbmObj.MinWidth = 10000
  AbmObj.UseHelpValueProcess = True
  
  m_ObjAbm.Title2 = m_Nrodoc

  With m_ObjAbm.Tabs
    
    .Clear
    
    With .Add(Nothing)
      .Name = C_strGeneral
    End With
    
    With .Add(Nothing)
      .Index = 1
      .Name = LNGGetText(3817, vbNullString)  'Comprobantes
    End With
            
    With .Add(Nothing)
      .Index = 2
      .Name = LNGGetText(1607, vbNullString)  'Facturas
    End With
            
  End With

  With m_ObjAbm.Properties
    
    .Clear

    With .Add(Nothing, cscPklFecha)
      .PropertyType = cspDate
      .Name = LNGGetText(1569, vbNullString) 'Fecha
      .Key = K_FECHA
      .Value = m_Fecha
    End With
    
    With .Add(Nothing, cscPklFechaentrega)
      .PropertyType = cspDate
      .Name = LNGGetText(3807, vbNullString) 'Fecha de Salida
      .Key = K_FECHAENTREGA
      .Value = m_Fechaentrega
    End With
    
    With .Add(Nothing, cscPklNumero)
      .PropertyType = cspText
      .Name = LNGGetText(1065, vbNullString) 'Numero
      .Key = K_NUMERO
      .Value = m_Numero
      .Width = 1000
      .Enabled = False
      .TopFromProperty = cscPklFecha
      .Left = 6000
    End With
    
    With .Add(Nothing, cscPklNrodoc)
      .PropertyType = cspText
      .Name = LNGGetText(1610, vbNullString) 'Comprobante
      .Key = K_NRODOC
      .Value = m_Nrodoc
      .Width = 1000
      .Enabled = False
    End With
    
    With .Add(Nothing, cscSucId)
      .PropertyType = cspHelp
      .Table = csSucursal
      .Name = LNGGetText(1281, vbNullString) 'Sucursal
      .LeftFromProperty = cscPklFecha
      .Key = K_SUC_ID
      .HelpId = m_suc_id
      .Value = m_Sucursal
    End With
   
    With .Add(Nothing, cscPklCumplido)
      .PropertyType = cspCheck
      .Name = LNGGetText(4864, vbNullString) 'Lista Cumplida
      .Key = K_CUMPLIDO
      .Value = CInt(m_cumplida)
      .Left = 8700
      .TopFromProperty = cscPklFecha
      .LeftNotChange = True
      .TopNotChange = True
    End With
    

    With .Add(Nothing, cscPklDescrip)
      .PropertyType = cspText
      .SubType = cspMemo
      .Height = 780
      .Width = 7000
      .Name = C_strDescrip      'Descripcion
      .Size = 255
      .LeftFromProperty = cscPklFecha
      .Key = K_DESCRIP
      .Value = m_Descrip
    End With
    
    With .Add(Nothing, c_t_total_os2)
      .PropertyType = cspNumeric
      .SubType = cspDouble
      .Name = LNGGetText(3822, vbNullString) ' Total
      .Enabled = False
      .Key = K_TOTAL_OS2
      .TopToPrevious = 440
      .Left = 6000
      .Width = 1400
      .LeftLabel = -650
      .Format = m_GeneralConfig.FormatDecImporte
    End With
                                
  '/////////////////////////////////////////////////////////////////////
  '
  ' TODOS
  '
  '
  '/////////////////////////////////////////////////////////////////////
  
    Set c = .Add(Nothing, c_T_FECHA_DESDE)
    With c
      .PropertyType = cspDate
      .Name = LNGGetText(2532, vbNullString) 'Desde
      .Left = 1000
      .LeftLabel = -550
      .Key = K_T_FECHA_DESDE
      .Value = m_FechaDesde
      .TabIndex = 1
      Set oProp = c
      oProp.IsEditProperty = False
      Set oProp = Nothing
    End With

    Set c = .Add(Nothing, c_T_FECHA_HASTA)
    With c
      .PropertyType = cspDate
      .Name = LNGGetText(2533, vbNullString) 'Hasta
      .Key = K_T_FECHA_HASTA
      .Value = m_FechaHasta
      .TabIndex = 1
      .TopFromProperty = c_T_FECHA_DESDE
      .LeftLabel = -550
      .Left = 3100
      Set oProp = c
      oProp.IsEditProperty = False
      Set oProp = Nothing
    End With

    Set c = .Add(Nothing, c_T_CLI_ID)
    With c
      .PropertyType = cspHelp
      .Table = csCliente
      .Name = LNGGetText(1150, vbNullString) 'Cliente
      .Key = K_T_CLI_ID
      .TabIndex = 1
      .TopFromProperty = c_T_FECHA_DESDE
      .Left = 5400
      .LeftLabel = -600
      .Width = 2700
    
      .HelpId = Val(m_ram_id_cliente)
      .HelpValueProcess = m_ram_id_cliente
      .Value = m_RamaCliente
    
      Set oProp = c
      oProp.HelpType = csTree
      oProp.IsEditProperty = False
      Set oProp = Nothing
    
    End With

    Set c = .Add(Nothing, c_T_ESTADO)
    With c
      .PropertyType = cspHelp
      .Table = csEstado
      .Name = LNGGetText(1568, vbNullString) 'Estado
      .Key = K_T_ESTADO
      .TabIndex = 1
      .TopFromProperty = c_T_FECHA_DESDE
      .Left = 8900
      .LeftLabel = -600
    
      .HelpId = Val(m_ram_id_estado)
      .HelpValueProcess = m_ram_id_estado
      .Value = m_RamaEstado
    
      Set oProp = c
      oProp.HelpType = csTree
      oProp.IsEditProperty = False
      Set oProp = Nothing
    
    End With

    Set c = .Add(Nothing, c_T_VENDEDOR)
    With c
      .PropertyType = cspHelp
      .Table = csVendedores
      .Name = LNGGetText(1510, vbNullString) 'Vendedor
      .Key = K_T_VENDEDOR
      .TabIndex = 1
      .TopFromProperty = c_T_FECHA_DESDE
      .TopToPrevious = 380
      .LeftFromProperty = c_T_CLI_ID
      .LeftLabel = -800
      .Width = 2700
    
      .HelpId = Val(m_ram_id_vendedor)
      .HelpValueProcess = m_ram_id_vendedor
      .Value = m_RamaVendedor
    
      Set oProp = c
      oProp.HelpType = csTree
      oProp.IsEditProperty = False
      Set oProp = Nothing
    
    End With

    Set c = .Add(Nothing, c_T_ZONA)
    With c
      .PropertyType = cspHelp
      .Table = csZona
      .Name = LNGGetText(1402, vbNullString) 'Zona
      .Key = K_T_ZONA
      .TabIndex = 1
    
      .TopFromProperty = c_T_FECHA_DESDE
      .TopToPrevious = 380
      .LeftFromProperty = c_T_ESTADO
      .LeftLabel = -500
    
      .HelpId = Val(m_ram_id_zona)
      .HelpValueProcess = m_ram_id_zona
      .Value = m_RamaZona
    
      Set oProp = c
      oProp.HelpType = csTree
      oProp.IsEditProperty = False
      Set oProp = Nothing
    
    End With

    With .Add(Nothing)
      .PropertyType = cspLabel
      .Width = 11500
      .Height = 10
      .BackColor = &HCCCCCC
      .Left = 300
      .TopToPrevious = 400
      .TabIndex = 1
    End With

    With .Add(Nothing, c_T_CMD_LOAD)
      .PropertyType = cspButton
      .Name = LNGGetText(3820, vbNullString) 'Cargar Comprobantes
      .Key = K_T_CMD_LOAD
      .TabIndex = 1
      .TopFromProperty = c_T_FECHA_DESDE
      .TopToPrevious = 880
      .Left = 800
      .LeftLabel = -1
    End With
    
    With .Add(Nothing, c_cmd_selectAll)
      .PropertyType = cspButton
      .Name = c_selectall2
      .Key = K_CMD_SELECT_ALL
      .TabIndex = 1
      .TopFromProperty = c_T_CMD_LOAD
      .Left = 3200
      .LeftLabel = -1
    End With
  
    With .Add(Nothing, c_cmd_replacePr)
      .PropertyType = cspButton
      .Name = LNGGetText(4869, vbNullString)
      .Key = K_CMD_REPLACE_PR
      .TabIndex = 1
      .TopFromProperty = c_T_CMD_LOAD
      .Left = 5600
      .LeftLabel = -1
    End With
  
    With .Add(Nothing, c_cmd_facturar)
      .PropertyType = cspButton
      .Name = LNGGetText(1613, vbNullString) ' Facturar
      .Key = K_CMD_FACTURAR
      .TabIndex = 1
      .TopFromProperty = c_T_CMD_LOAD
      .Left = 8000
      .LeftLabel = -1
    End With
  
    '-----------------------------------------------
   
    With .Add(Nothing, c_t_total_os)
      .PropertyType = cspNumeric
      .SubType = cspDouble
      .Name = LNGGetText(1584, vbNullString) ' Total
      .Enabled = False
      .Key = K_TOTAL_OS
      .TabIndex = 1
      .LeftFromProperty = c_T_FECHA_DESDE
      .Width = 1400
      .LeftLabel = -550
      .Format = m_GeneralConfig.FormatDecImporte
      
      .TopFromProperty = c_T_FECHA_DESDE
      .TopToPrevious = 380
    
    End With
    
    '-----------------------------------------------
  
    Set c = .Add(Nothing, c_Todos)
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      .Left = 200
      .Top = 2400
      If Not pLoadTodos(c, False) Then Exit Function
      .Name = c_Todos
      .Key = K_TODOS
      .TabIndex = 1
      .GridAdd = False
      .GridEdit = True
      .GridRemove = False
      Set oGrid = c.Grid
      oGrid.MultiSelect = True
    End With
  
    '-----------------------------------------------
  
    With .Add(Nothing, c_cmd_hojaruta)
      .PropertyType = cspButton
      .Name = LNGGetText(4889, vbNullString) ' Generar Hoja de Ruta
      .Key = K_CMD_HOJARUTA
      .TabIndex = 2
      .LeftLabel = -1
    End With
  
    With .Add(Nothing, c_cmd_printfactura)
      .PropertyType = cspButton
      .Name = LNGGetText(4891, vbNullString) ' Imprimir Facturas
      .Key = K_CMD_PRINTFACTURA
      .TopFromProperty = c_cmd_hojaruta
      .Left = 3000
      .TabIndex = 2
      .LeftLabel = -1
    End With
  
    Set c = .Add(Nothing, c_Facturas)
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      .Left = 200
      .Top = 1600
      If Not pLoadFacturas(c) Then Exit Function
      .Name = c_Facturas
      .Key = K_FACTURAS
      .TabIndex = 2
      .GridAdd = False
      .GridEdit = True
      .GridRemove = False
    End With
  
  End With
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  Set AbmObj = m_ObjAbm
  
  AbmObj.GroupGridEx pGetTodos(), _
                     c_key_col_cliente, _
                     c_key_col_pedido, _
                     4
    
  pShowTotal
    
  LoadCollection = True
End Function

Private Function Load(ByVal id As Long) As Boolean

  Dim sqlstmt As String
  Dim rs      As Recordset

  sqlstmt = "sp_PickingListGet " & id

  If Not gDB.OpenRs(sqlstmt, _
                    rs, _
                    csRsStatic, _
                    csLockReadOnly, _
                    csCmdText, _
                    C_LoadFunction, _
                    C_Module) Then Exit Function

  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.fields, cscPklId)
    m_Nrodoc = gDB.ValField(rs.fields, cscPklNrodoc)
    m_Numero = gDB.ValField(rs.fields, cscPklNumero)
    m_Fecha = gDB.ValField(rs.fields, cscPklFecha)
    m_Fechaentrega = gDB.ValField(rs.fields, cscPklFechaentrega)
    m_Descrip = gDB.ValField(rs.fields, cscPklDescrip)
    m_Total = gDB.ValField(rs.fields, cscPklTotal)
    m_pendiente = gDB.ValField(rs.fields, cscPklPendiente)
    m_suc_id = gDB.ValField(rs.fields, cscSucId)
    m_Sucursal = gDB.ValField(rs.fields, cscSucNombre)
    
    m_cumplida = gDB.ValField(rs.fields, cscPklCumplido)
    
    m_FechaDesde = gDB.ValField(rs.fields, cscPklFechadesde)
    m_FechaHasta = gDB.ValField(rs.fields, cscPklFechahasta)
    
    m_ram_id_vendedor = gDB.ValField(rs.fields, cscVenId)
  
    Dim bExists As Boolean
  
    If UCase(Left$(m_ram_id_vendedor, 1)) = KEY_NODO Then
      m_RamaVendedor = pGetNombreRama(csVendedores, Val(Mid(m_ram_id_vendedor, 2)), bExists)
      If Not bExists Then m_RamaVendedor = "0"
    Else
      If Not gDB.GetData(csTVendedor, cscVenId, Val(m_ram_id_vendedor), cscVenNombre, m_RamaVendedor) Then Exit Function
    End If
    
    m_ram_id_zona = gDB.ValField(rs.fields, cscZonId)
  
    If UCase(Left$(m_ram_id_zona, 1)) = KEY_NODO Then
      m_RamaZona = pGetNombreRama(csZona, Val(Mid(m_ram_id_zona, 2)), bExists)
      If Not bExists Then m_RamaZona = "0"
    Else
      If Not gDB.GetData(csTZona, cscZonId, Val(m_ram_id_zona), cscZonNombre, m_RamaZona) Then Exit Function
    End If
    
  Else
    
    m_Id = csNO_ID
    m_Nrodoc = vbNullString
    m_Numero = 0
    m_Fecha = Date
    m_Fechaentrega = Date
    m_Descrip = vbNullString
    m_Total = 0
    m_pendiente = 0
    m_suc_id = User.suc_id
    m_Sucursal = User.Sucursal

    m_cumplida = False

    If Weekday(Date) = vbMonday Then
  
      m_FechaDesde = DateAdd("d", -3, Date)
    Else
    
      m_FechaDesde = DateAdd("d", -1, Date)
    End If
    
    m_FechaHasta = Date

  End If

  Load = True
  
End Function

Private Function pSaveNroPickingList(ByVal pkl_id As Long)
  Dim sqlstmt As String
  sqlstmt = "update PickingList set pkl_nrodoc = right('00000000'+convert(varchar,pkl_id),8), pkl_numero = pkl_id where pkl_id = " & pkl_id
  pSaveNroPickingList = gDB.Execute(sqlstmt)
  m_Nrodoc = Right$("0000000" & pkl_id, 8)
End Function

' construccion - destruccion

Private Sub Class_Initialize()
  On Error GoTo ControlError

  c_ErrorSave = LNGGetText(4865, vbNullString) 'Error al grabar la lista de despacho

  Set m_GeneralConfig = New cGeneralConfig
  m_GeneralConfig.Load

  ' Preferencias del Usuario
  '
  Set m_UserCfg = New cUsuarioConfig
  m_UserCfg.Load

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
  On Error GoTo ControlError
  
  Set m_ObjAbm = Nothing
  Set m_ObjTree = Nothing
  Set m_GeneralConfig = Nothing
  Set m_UserCfg = Nothing
  
  GoTo ExitProc
ControlError:
  MngError Err, "Class_Terminate", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

'////////////////////////////////////////////////////////////////////////////////////////////////////////
'
' Implementacion de cIABMClientGrid

Private Function cIABMClientGrid_IsEmptyRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_TODOS
      cIABMClientGrid_IsEmptyRow = False
    Case K_FACTURAS
      cIABMClientGrid_IsEmptyRow = False
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ValidateRow", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIABMClientGrid_ColumnAfterUpdate(ByVal Key As Integer, _
                                                   ByVal lRow As Long, _
                                                   ByVal lCol As Long) As Boolean
  On Error GoTo ControlError
  
  Select Case Key
    Case K_TODOS
      cIABMClientGrid_ColumnAfterUpdate = pColAUpdateTodos( _
                                              pGetTodos(), _
                                              lRow, _
                                              lCol)
    Case K_FACTURAS
      cIABMClientGrid_ColumnAfterUpdate = True
      
  End Select

  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ColumnAfterUpdate", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pColAUpdateTodos(ByRef IProperty As cIABMProperty, _
                                    ByVal lRow As Long, _
                                    ByVal lCol As Long)
  Dim Row As cIABMGridRow
  
  With IProperty.Grid
    Select Case .Columns(lCol).Key
      
      Case KI_SELECT
        
        Set Row = .Rows(lRow)
        pShowTotal
    
    End Select
  End With
  
  pColAUpdateTodos = True
End Function

Private Function cIABMClientGrid_ColumnAfterEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_TODOS
      cIABMClientGrid_ColumnAfterEdit = pColumnAfterEditTodos(pGetTodos(), lRow, lCol, NewValue, NewValueID)
    Case K_FACTURAS
      cIABMClientGrid_ColumnAfterEdit = True
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ColumnAfterEdit", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pColumnAfterEditTodos(ByRef IProperty As cIABMProperty, _
                                       ByVal lRow As Long, _
                                       ByVal lCol As Long, _
                                       ByVal NewValue As Variant, _
                                       ByVal NewValueID As Long) As Boolean
  Dim Row As cIABMGridRow
  
  Select Case IProperty.Grid.Columns(lCol).Key
    
    Case KI_CANTIDAD_PV
      Set Row = IProperty.Grid.Rows(lRow)
      
      If Val(NewValue) = 0 Then
        
        pCell(Row, KI_SELECT).id = 0
        
      Else
      
        If Val(NewValue) < 0 Then
          Exit Function
        End If
        
        If Val(NewValue) > Val(pCell(Row, KI_CANTIDAD_PV_REAL).Value) Then
          Exit Function
        End If
      
      End If
      
  End Select
  
  pColumnAfterEditTodos = True
End Function

Private Function cIABMClientGrid_ColumnBeforeEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_TODOS
      cIABMClientGrid_ColumnBeforeEdit = pColumnBeforeEditTodos(m_ObjAbm.Properties(c_Todos), lRow, lCol, iKeyAscii)
    Case K_FACTURAS
      cIABMClientGrid_ColumnBeforeEdit = pColumnBeforeEditFacturas(m_ObjAbm.Properties(c_Facturas), lRow, lCol, iKeyAscii)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ColumnBeforeEdit", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIABMClientGrid_ColumnButtonClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean

End Function

Private Sub cIABMClientGrid_ColumnCancelEdit(ByVal Key As Integer)

End Sub

Private Sub cIABMClientGrid_ColumnClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Sub cIABMClientGrid_DblClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)
  On Error GoTo ControlError
  
  Dim id          As Long
  Dim ObjEditName As String
  Dim tipo        As Long
  Dim iProp       As cIABMProperty
  
  Select Case Key

    Case K_TODOS
      
      Set iProp = pGetTodos()
      
      With iProp.Grid.Rows
        
        id = Val(pCell(.Item(lRow), KI_PV_ID).Value)
        
        If id <> csNO_ID Then
          
          tipo = pCell(.Item(lRow), KI_TIPO).id
          
          Select Case tipo
                        
            Case c_Tipo_Pedido
                          
              Dim PklPedidoEdit As cPickingListPedidoEdit
              Set PklPedidoEdit = New cPickingListPedidoEdit
              
              PklPedidoEdit.Edit id, Me
              Exit Sub
            
          End Select

          If id > 0 Then
            
            ShowDocAux id, _
                       ObjEditName, _
                       "CSABMInterface2.cABMGeneric"
          
          Else
          
            pEditParteDiario id * -1
          
          End If
        End If
      End With
    
    Case K_FACTURAS
  
      Set iProp = pGetFacturas()
      
      If iProp.Grid.Columns(lCol).Key <> KI_FV_DESCRIP Then
        
        With iProp.Grid.Rows
          
          id = Val(pCell(.Item(lRow), KI_FV_ID).Value)
          
          If id <> csNO_ID Then
            
            ShowDocAux id, _
                       "CSVenta2.cFacturaVenta", _
                       "CSABMInterface2.cABMGeneric"
          End If
        End With
      End If
  End Select

  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_DblClick", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Function cIABMClientGrid_DeleteRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal lRow As Long) As Boolean

End Function

Private Function cIABMClientGrid_ListAdHock(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal ColIndex As Long, List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClientGrid_NewRow(ByVal Key As Integer, ByVal Rows As Integer)

End Sub

Private Function cIABMClientGrid_ValidateRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_TODOS
      cIABMClientGrid_ValidateRow = True
    Case K_FACTURAS
      cIABMClientGrid_ValidateRow = True
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ValidateRow", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pColumnBeforeEditTodos(ByRef IProperty As cIABMProperty, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer)
  Dim Key As Long
  Dim Row As cIABMGridRow
  
  Key = IProperty.Grid.Columns(lCol).Key
  
  Select Case Key
    Case KI_SELECT, KI_ORDEN, KI_DESCRIP, KI_CCOS_ID
    
      pColumnBeforeEditTodos = True
          
    Case KI_CANTIDAD_PV
    
      Set Row = IProperty.Grid.Rows(lRow)
      If pCell(Row, KI_SELECT).id Then
    
        pColumnBeforeEditTodos = True
        
      End If
    
  End Select
  
End Function

Private Function pColumnBeforeEditFacturas(ByRef IProperty As cIABMProperty, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer)
  Dim Key As Long
  
  Key = IProperty.Grid.Columns(lCol).Key
  
  Select Case Key
    Case KI_FV_DESCRIP
    
      pColumnBeforeEditFacturas = True
          
  End Select
  
End Function

Private Function pLoadFacturas(ByRef iProp As cIABMProperty) As Boolean

  With iProp.Grid
  
    With .Columns
    
      .Clear
                
      With .Add(Nothing)
        .Visible = False
        .Key = KI_FV_ID
      End With
                        
      With .Add(Nothing, c_select_key)
        .PropertyType = cspCheck
        .Width = 320
        .Key = KI_FV_SELECT
      End With
            
      With .Add(Nothing)
        .PropertyType = cspText
        .Name = LNGGetText(1402, vbNullString) 'Zona
        .Key = KI_FV_ZONA
      End With
      
      With .Add(Nothing)
        .PropertyType = cspText
        .Name = LNGGetText(1510, vbNullString) 'Vendedor
        .Key = KI_FV_VENDEDOR
      End With
                  
      With .Add(Nothing, c_key_col_cliente)
        .Name = LNGGetText(1150, vbNullString) 'Cliente
        .Key = KI_FV_CLIENTE
      End With
                              
      With .Add(Nothing)
        .PropertyType = cspText
        .Name = LNGGetText(1065, vbNullString) 'Numero
        .Key = KI_FV_NRODOC
      End With
            
      With .Add(Nothing)
        .PropertyType = cspText
        .Name = LNGGetText(1567, vbNullString) 'Documento
        .Key = KI_FV_DOC
      End With
            
      With .Add(Nothing)
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Name = LNGGetText(1228, vbNullString) 'Importe
        .Key = KI_FV_IMPORTE
        .Format = m_GeneralConfig.FormatDecImporte
      End With
                                                                        
      With .Add(Nothing)
        .PropertyType = cspText
        .SubType = cspTextButtonEx
        .Name = LNGGetText(1861, vbNullString) 'Observaciones
        .Key = KI_FV_DESCRIP
      End With
                                                
    End With
  
    .Rows.Clear
    
  End With

  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  ' Facturas
  '
  sqlstmt = "sp_PickingListGetFacturas " & m_Id
  If Not gDB.OpenRs(sqlstmt, _
                    rs, _
                    csRsStatic, _
                    csLockReadOnly, _
                    csCmdText, _
                    "pLoadFacturas", _
                    C_Module) Then Exit Function
  
  Dim Row As cIABMGridRow
  
  With iProp.Grid.Rows
      
    While Not rs.EOF
    
      Set Row = .Add(Nothing)
    
      With Row
              
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscFvId)
          .Key = KI_FV_ID
        End With
                                
        With .Add(Nothing)
          .id = 1
          .Key = KI_FV_SELECT
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscZonNombre)
          .Key = KI_FV_ZONA
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscVenNombre)
          .Key = KI_FV_VENDEDOR
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscCliNombre)
          .id = gDB.ValField(rs.fields, cscCliId)
          .Key = KI_FV_CLIENTE
        End With
                        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscFvNrodoc)
          .Key = KI_FV_NRODOC
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscDocNombre)
          .id = gDB.ValField(rs.fields, cscDocId)
          .Key = KI_FV_DOC
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscFvTotal)
          .Key = KI_FV_IMPORTE
        End With
                        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscFvDescrip)
          .Key = KI_FV_DESCRIP
        End With
                                
      End With
      
      rs.MoveNext
    Wend
  End With

  pLoadFacturas = True

End Function

Private Function pLoadTodos(ByRef iProp As cIABMProperty, _
                            ByVal bLoadAll As Boolean) As Boolean
  With iProp.Grid
  
    With .Columns
    
      .Clear
    
      With .Add(Nothing)
        .Visible = False
        .Key = KI_PKLPV_ID
      End With
            
      With .Add(Nothing)
        .Visible = False
        .Key = KI_PV_ID
      End With

      With .Add(Nothing, c_key_col_cliente)
        .Visible = False
        .Name = cscCliId
        .Key = KI_CLIENTE
      End With
            
      With .Add(Nothing)
        .Name = LNGGetText(1223, vbNullString) 'Tipo
        .PropertyType = cspText
        .Visible = True
        .Key = KI_TIPO
      End With
            
      With .Add(Nothing, c_select_key)
        .PropertyType = cspCheck
        .Width = 320
        .Key = KI_SELECT
      End With
            
      With .Add(Nothing, c_key_col_pedido)
        .PropertyType = cspText
        .Name = LNGGetText(1065, vbNullString) 'Numero
        .Key = KI_NRODOC
      End With
            
      With .Add(Nothing)
        .PropertyType = cspDate
        .Name = LNGGetText(1569, vbNullString) 'Fecha
        .Key = KI_FECHA
      End With
      
      With .Add(Nothing)
        .PropertyType = cspNumeric
        .Width = 320
        .Name = LNGGetText(1809, vbNullString) 'Orden
        .Key = KI_ORDEN
      End With
                  
      With .Add(Nothing)
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Name = LNGGetText(1228, vbNullString) 'Importe
        .Key = KI_IMPORTE
        .Format = m_GeneralConfig.FormatDecImporte
      End With
                  
      With .Add(Nothing)
        .PropertyType = cspText
        .Name = LNGGetText(1619, vbNullString) 'Producto
        .Key = KI_PRODUCTO
      End With
      With .Add(Nothing)
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Name = LNGGetText(4866, vbNullString) 'Cantidad Pedido
        .Key = KI_CANTIDAD_PV
        .Format = m_GeneralConfig.FormatDecCantidad
      End With
      With .Add(Nothing)
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Name = LNGGetText(4867, vbNullString) 'Cantidad Stock
        .Key = KI_CANTIDAD_ST
        .Format = m_GeneralConfig.FormatDecCantidad
      End With
                  
      With .Add(Nothing)
        .Key = KI_PENDIENTE
        .Visible = False
      End With
                  
      With .Add(Nothing)
        .Visible = False
        .Key = KI_PVI_ID
      End With
                  
      With .Add(Nothing)
        .Visible = False
        .Key = KI_PKLPVI_ID
      End With
      
      With .Add(Nothing)
        .PropertyType = cspHelp
        .Table = csCentroCosto
        .Name = LNGGetText(1057, vbNullString)    'Centro de Costo
        .Key = KI_CCOS_ID
      End With
                  
      With .Add(Nothing)
        .PropertyType = cspText
        .SubType = cspTextButtonEx
        .Name = LNGGetText(1861, vbNullString) 'Observaciones
        .Key = KI_DESCRIP
      End With
      
      With .Add(Nothing)
        .Visible = False
        .Key = KI_CANTIDAD_PV_REAL
      End With
                                                
    End With
  
    .Rows.Clear
    
  End With

  Dim sqlstmt       As String
  Dim rsPedidos     As ADODB.Recordset
  
  ' Pedidos
  '
  sqlstmt = "sp_PickingListGetItems " & m_Id
  If Not gDB.OpenRs(sqlstmt, _
                    rsPedidos, _
                    csRsStatic, _
                    csLockReadOnly, _
                    csCmdText, _
                    "pLoadTodos", _
                    C_Module) Then Exit Function
  
  pLoadTodosIngrid rsPedidos, iProp.Grid.Rows, 1
  
  If bLoadAll Then
  
    Dim strFechaDesde As String
    Dim strFechaHasta As String
    Dim strClienteId  As String
    Dim strEstadoId   As String
    Dim strVendedorId As String
    Dim strZonaId     As String
    
    With m_ObjAbm.Properties
      
      m_FechaDesde = .Item(c_T_FECHA_DESDE).Value
      m_FechaHasta = .Item(c_T_FECHA_HASTA).Value
      
      strFechaDesde = gDB.sqlDate(m_FechaDesde)
      strFechaHasta = gDB.sqlDate(m_FechaHasta)
      
      With .Item(c_T_CLI_ID)
        m_ram_id_cliente = .HelpValueProcess
        m_RamaCliente = .Value
      End With
      
      With .Item(c_T_ESTADO)
        m_ram_id_estado = .HelpValueProcess
        m_RamaEstado = .Value
      End With
      
      With .Item(c_T_VENDEDOR)
        m_ram_id_vendedor = .HelpValueProcess
        m_RamaVendedor = .Value
      End With
      
      With .Item(c_T_ZONA)
        m_ram_id_zona = .HelpValueProcess
        m_RamaZona = .Value
      End With
      
    End With
    
    strClienteId = gDB.sqlString(m_ram_id_cliente)
    strEstadoId = gDB.sqlString(m_ram_id_estado)
    strVendedorId = gDB.sqlString(m_ram_id_vendedor)
    strZonaId = gDB.sqlString(m_ram_id_zona)
        
    ' Pedidos
    '
    sqlstmt = "sp_PickingListGetPedidos " _
                  & strFechaDesde & "," _
                  & strFechaHasta & "," _
                  & strClienteId & "," _
                  & strEstadoId & "," _
                  & strVendedorId & "," _
                  & strZonaId & "," _
                  & m_Id
    
    If Not gDB.OpenRs(sqlstmt, _
                      rsPedidos, _
                      csRsStatic, _
                      csLockReadOnly, _
                      csCmdText, _
                      "pLoadTodos", _
                      C_Module) Then Exit Function
    
    ' Carga
    '
    pLoadTodosIngrid rsPedidos, iProp.Grid.Rows, 0
    
  End If

  pLoadTodos = True

End Function

Private Sub pLoadTodosIngrid(ByRef rsPedidos As ADODB.Recordset, _
                             ByRef Rows As cIABMGridRows, _
                             ByVal iSelected As Long)

  pLoadPedidosTIngrid rsPedidos, Rows, iSelected
  
End Sub

Private Sub pLoadPedidosTIngrid(ByRef rs As ADODB.Recordset, _
                                ByRef Rows As cIABMGridRows, _
                                ByVal iSelected As Long)
  Dim Row As cIABMGridRow
  
  With Rows
      
    While Not rs.EOF
    
      Set Row = .Add(Nothing)
    
      With Row
      
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscPklpvId)
          .Key = KI_PKLPV_ID
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscPvId)
          .Key = KI_PV_ID
        End With
                
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscCliNombre)
          .id = gDB.ValField(rs.fields, cscCliId)
          .Key = KI_CLIENTE
        End With
        
        With .Add(Nothing)
          .Value = "PV"
          .id = c_Tipo_Pedido
          .Key = KI_TIPO
        End With
        
        With .Add(Nothing)
          .id = CInt(gDB.ValField(rs.fields, cscPklpviId) <> csNO_ID)
          .Key = KI_SELECT
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscPvNrodoc)
          .Key = KI_NRODOC
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscPvFecha)
          .Key = KI_FECHA
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscPklpvOrden)
          .Key = KI_ORDEN
        End With
                        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscPvTotal)
          .Key = KI_IMPORTE
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscPrNombreVenta)
          .Key = KI_PRODUCTO
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscPklpviCantidadaremitir)
          .Key = KI_CANTIDAD_PV
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, "cantidad_stock")
          .Key = KI_CANTIDAD_ST
        End With
                
        .Add(Nothing).Key = KI_PENDIENTE
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscPviId)
          .Key = KI_PVI_ID
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscPklpviId)
          .Key = KI_PKLPVI_ID
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscCcosNombre)
          .id = gDB.ValField(rs.fields, cscCcosId)
          .Key = KI_CCOS_ID
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscPklpvDescrip)
          .Key = KI_DESCRIP
        End With
                                
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscPviCantidadaremitir)
          .Key = KI_CANTIDAD_PV_REAL
        End With
                                
      End With
      
      rs.MoveNext
    Wend
  End With
End Sub

Private Function pSaveFacturas() As Boolean
  Dim sqlstmt   As String
  
  With pGetFacturas()
    
    Dim Row  As cIABMGridRow
    Dim Cell As cIABMGridCellValue
    
    For Each Row In .Grid.Rows
    
      sqlstmt = "update FacturaVenta set fv_descrip = " & gDB.sqlString(pCell(Row, KI_FV_DESCRIP).Value) & " where fv_id = " & Val(pCell(Row, KI_FV_ID).Value)
      If Not gDB.Execute(sqlstmt) Then Exit Function
    
    Next
  End With
    
  pSaveFacturas = True

End Function

Private Function pSaveItemsTodos(ByVal id As Long) As Boolean
  Dim register  As cRegister
  Dim fields    As cFields
  Dim sqlstmt   As String
  Dim LastPvId  As Long
  Dim PvId      As Long
  Dim PklPvId   As Long
  
  With pGetTodos()
    
    Dim Row  As cIABMGridRow
    Dim Cell As cIABMGridCellValue
    
    For Each Row In .Grid.Rows
    
      If pCell(Row, KI_SELECT).id Then
    
        Set register = New cRegister
        
        With register
          
          Set fields = .fields
          .fieldId = cscPklpvId
          .Table = csTPickingListPedido
          .id = csNew
          
          For Each Cell In Row
            
            Select Case Cell.Key
                              
              Case KI_PV_ID
                PvId = Val(Cell.Value)
                fields.Add2 cscPvId, PvId, csId
                                              
              Case KI_ORDEN
                fields.Add2 cscPklpvOrden, Cell.Value, csInteger
                
              Case KI_DESCRIP
                fields.Add2 cscPklpvDescrip, Cell.Value, csText
                              
            End Select
          Next
          
          fields.Add2 cscEstId, 1, csId 'pendiente
          fields.Add2 cscPklId, id, csId
          
          fields.HaveLastUpdate = False
          fields.HaveWhoModify = False
        
        End With
        
        If LastPvId <> PvId Then
                                                                      
          If Not gDB.Save(register, , "pSaveItemsTodos", C_Module, c_ErrorSave) Then Exit Function
          LastPvId = PvId
          PklPvId = register.id
          
          If Not pSaveSubItems(id, PklPvId) Then Exit Function
        
        End If
        
      End If
    Next
  End With
    
  pSaveItemsTodos = True

End Function

Private Function pSaveSubItems(ByVal pkl_id As Long, ByVal pklpv_id) As Boolean
  Dim register  As cRegister
  Dim fields    As cFields
  Dim sqlstmt   As String
  Dim pvi_id    As Long
  
  With pGetTodos()
    
    Dim Row  As cIABMGridRow
    Dim Cell As cIABMGridCellValue
    
    For Each Row In .Grid.Rows
    
      If pCell(Row, KI_SELECT).id Then
    
        Set register = New cRegister
        
        With register
          
          Set fields = .fields
          .fieldId = cscPklpviId
          .Table = csTPickingListPedidoItem
          .id = csNew
          
          For Each Cell In Row
            
            Select Case Cell.Key
                              
              Case KI_PV_ID
                fields.Add2 cscPvId, Val(Cell.Value), csId
                                                              
              Case KI_PVI_ID
                pvi_id = Val(Cell.Value)
                fields.Add2 cscPviId, pvi_id, csId
              
              Case KI_ORDEN
                fields.Add2 cscPklpviOrden, Cell.Value, csInteger
                
              Case KI_CANTIDAD_PV
                fields.Add2 cscPklpviCantidadaremitir, Cell.Value, csDouble
                              
              Case KI_CANTIDAD_ST
                fields.Add2 cscPklpviCantidad, Cell.Value, csDouble
                                                                                          
            End Select
          Next
          
          fields.Add2 cscPklId, pkl_id, csId
          fields.Add2 cscPklpvId, pklpv_id, csId
          
          fields.HaveLastUpdate = False
          fields.HaveWhoModify = False
        
        End With
        
        If Not gDB.Save(register, , "pSaveSubItems", C_Module, c_ErrorSave) Then Exit Function
        
        Dim ccos_id As Long
        ccos_id = pCell(Row, KI_CCOS_ID).id
        sqlstmt = "update PedidoVentaItem set ccos_id = " & IIf(ccos_id, ccos_id, "null") _
                  & " where pvi_id = " & pvi_id
        If Not gDB.Execute(sqlstmt) Then Exit Function
        
      End If
    Next
  End With
    
  pSaveSubItems = True

End Function

Private Sub pShowTotal()
  Dim Row           As cIABMGridRow
  Dim oRow          As cABMGridRow
  Dim TotalOs       As Double
  Dim Cobrar        As Double
  
  For Each Row In pGetTodos().Grid.Rows

    Set oRow = Row
    If Not oRow.IsGroup Then

      If pCell(Row, KI_SELECT).id Then
      
        Select Case pCell(Row, KI_TIPO).id
      
          Case c_Tipo_Pedido
            TotalOs = TotalOs + Val(pCell(Row, KI_IMPORTE).Value)
            
        End Select
      End If
    End If
  Next
  
  pGetTotal2().Value = TotalOs
  pGetTotal().Value = TotalOs
    
  m_ObjAbm.ShowValue pGetTotal()
  m_ObjAbm.ShowValue pGetTotal2()
End Sub

Private Function pGetTodos() As cIABMProperty
  Set pGetTodos = m_ObjAbm.Properties.Item(c_Todos)
End Function

Private Function pGetFacturas() As cIABMProperty
  Set pGetFacturas = m_ObjAbm.Properties.Item(c_Facturas)
End Function

Private Function pGetTotal() As cIABMProperty
  Set pGetTotal = m_ObjAbm.Properties.Item(c_t_total_os)
End Function

Private Function pGetTotal2() As cIABMProperty
  Set pGetTotal2 = m_ObjAbm.Properties.Item(c_t_total_os2)
End Function

Private Function pSaveChanges() As Boolean
  Dim rslt As VbMsgBoxResult
  
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  
  If AbmObj.bWasChanged Then
  
    rslt = MsgBox("Ud. ha realizado cambios que no ha guardado." & vbCrLf & vbCrLf & "¿Desea guardarlos?", vbQuestion + vbYesNoCancel, "Guardar")
    
    If rslt = vbCancel Then Exit Function
    
    If rslt = vbYes Then
      
      If Not AbmObj.Save() Then
        Exit Function
      End If
    
    Else
      
      AbmObj.ResetChanged
      
    End If
  
  End If
  
  pSaveChanges = True

End Function

'---------------------------------------------------------------
Private Sub pRefreshProperties()
  Dim c      As cIABMProperty
  Dim AbmGen As cABMGeneric
  Dim Filter As String

  With m_ObjAbm
    
    .Title2 = m_Nrodoc
    
    With .Properties
  
'-------------------------------------------------------------------
      With .Item(cscPklFecha)
        .Value = m_Fecha
      End With
      
      With .Item(cscPklFechaentrega)
        .Value = m_Fechaentrega
      End With
      
      With .Item(cscPklNumero)
        .Value = m_Numero
      End With
      
      With .Item(cscPklNrodoc)
        .Value = m_Nrodoc
      End With
      
      With .Item(cscSucId)
        .Value = m_Sucursal
        .HelpId = m_suc_id
      End With
            
      With .Item(cscPklDescrip)
        .Value = m_Descrip
      End With
      
    '/////////////////////////////////////////////////////////////////////
    '
    ' TODOS
    '
    '
    '/////////////////////////////////////////////////////////////////////
    
      With .Item(c_T_FECHA_DESDE)
        .Value = m_FechaDesde
      End With
  
      With .Item(c_T_FECHA_HASTA)
        .Value = m_FechaHasta
      End With
                      
      Set c = .Item(c_Todos)
      pLoadTodos c, False
        
      Set c = .Item(c_Facturas)
      pLoadFacturas c
        
      With .Item(c_T_CLI_ID)
        .HelpId = Val(m_ram_id_cliente)
        .HelpValueProcess = m_ram_id_cliente
        .Value = m_RamaCliente
      End With
    
      With .Item(c_T_ESTADO)
        .HelpId = Val(m_ram_id_estado)
        .HelpValueProcess = m_ram_id_estado
        .Value = m_RamaEstado
      End With
    
      With .Item(c_T_VENDEDOR)
        .HelpId = Val(m_ram_id_vendedor)
        .HelpValueProcess = m_ram_id_vendedor
        .Value = m_RamaVendedor
      End With
    
      With .Item(c_T_ZONA)
        .HelpId = Val(m_ram_id_zona)
        .HelpValueProcess = m_ram_id_zona
        .Value = m_RamaZona
      End With
    
'-------------------------------------------------------------------
    End With
  End With
  
  Set AbmGen = m_ObjAbm
  
  AbmGen.ShowValues m_ObjAbm.Properties
  
  AbmGen.GroupGridEx pGetTodos(), _
                     c_key_col_cliente, _
                     c_key_col_pedido, _
                     4
    
  pShowTotal
  
End Sub

Private Sub pEditParteDiario(ByVal ptd_id As Long)
  Dim Parte   As Object
  Dim iParte  As cIEditGeneric
  
  Set Parte = CSKernelClient2.CreateObject("CSEnvio2.cParteDiario")
  Set iParte = Parte
  
  Set iParte.ObjAbm = CSKernelClient2.CreateObject("CSABMInterface2.cABMGeneric")
  iParte.Edit ptd_id, False

End Sub

Private Function pGetCMDSelectAll() As cIABMProperty
  Set pGetCMDSelectAll = m_ObjAbm.Properties.Item(c_cmd_selectAll)
End Function

Private Sub pSelectAll(ByVal bSelect As Boolean)
  Dim Row   As cIABMGridRow
  Dim oRow  As cABMGridRow
  Dim oCol  As cABMGridColumn
  Dim iRow  As Long
  Dim iCol  As Long
  
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  
  Set oCol = pGetTodos().Grid.Columns.Item(c_select_key)
  iCol = oCol.Index + 2
  
  For Each Row In pGetTodos().Grid.Rows
  
    Set oRow = Row
    
    iRow = iRow + 1
    
    If Not oRow.IsGroup Then
  
      pCell(Row, KI_SELECT).id = CInt(bSelect)
  
      AbmObj.ShowCellValue pGetTodos(), _
                           iRow, _
                           iCol
  
    End If
  Next
  
End Sub

Private Function pGetNombreRama(ByVal tbl_id As Long, ByVal Ram_ID As Long, ByRef bExists As Boolean) As String
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  sqlstmt = "select ram_nombre from rama,arbol " & _
              " where rama.arb_id = arbol.arb_id " & _
                " and ram_id = " & Ram_ID & _
                " and tbl_id = " & tbl_id
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  If rs.EOF Then Exit Function
  
  bExists = True
  
  pGetNombreRama = gDB.ValField(rs.fields, cscRamNombre)
End Function

Private Sub pShowReplace()

  If Not pSaveChanges() Then Exit Sub
  

  Dim EditPr As cPickingListEditAux
  Set EditPr = New cPickingListEditAux
  
  Dim vPviIds() As Long
  
  vPviIds = pGetPviIds()
  
  If EditPr.Edit() Then
  
    Dim sqlstmt As String
    
    sqlstmt = "sp_PickingListReplacePr " _
                         & m_Id _
                   & "," & EditPr.pr_id_to_find _
                   & "," & EditPr.pr_id_new _
                   & "," & CInt(EditPr.no_update_precios) _
                   & ",'" & pArrayLongToString(vPviIds) & "'"
  
    If Not gDB.Execute(sqlstmt) Then Exit Sub
    
    RefreshItems
  End If

End Sub

Public Sub RefreshItems()

  pLoadTodos pGetTodos(), False
  
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  
  AbmObj.GroupGridEx pGetTodos(), _
                     c_key_col_cliente, _
                     c_key_col_pedido, _
                     4

End Sub

Private Function pArrayLongToString(ByRef vLongValues() As Long) As String
  Dim i As Long
  Dim rtn As String
  
  For i = 1 To UBound(vLongValues)
    rtn = rtn & vLongValues(i) & ","
  Next
  
  rtn = RemoveLastColon(rtn)
  
  pArrayLongToString = rtn
End Function

Private Function pGetPviIds() As Long()
  Dim rtn()       As Long
  Dim iRow        As cIABMGridRow
  Dim oRow        As cABMGridRow
  Dim i           As Long
  
  ReDim rtn(0)
  
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  
  AbmObj.RefreshSelectedInGrid2 pGetTodos()
  
  For Each iRow In pGetTodos().Grid.Rows
    
    Set oRow = iRow
    
    If oRow.IsSelected Then
    
      i = i + 1
      ReDim Preserve rtn(i)
    
      rtn(i) = Val(pCell(iRow, KI_PVI_ID).Value)
    
    End If
  Next
  
  pGetPviIds = rtn
  
End Function

Private Function pGetCliPviIds(ByVal cli_id As Long) As Long()
  Dim rtn()       As Long
  Dim iRow        As cIABMGridRow
  Dim oRow        As cABMGridRow
  Dim i           As Long
  
  ReDim rtn(0)
    
  For Each iRow In pGetTodos().Grid.Rows
        
    Set oRow = iRow
    If Not oRow.IsGroup Then
        
      If pCell(iRow, KI_SELECT).id Then
      
        If pCell(iRow, KI_CLIENTE).id = cli_id Then
      
          i = i + 1
          ReDim Preserve rtn(i)
        
          rtn(i) = Val(pCell(iRow, KI_PVI_ID).Value)
          
        End If
      End If
    End If
  Next
  
  pGetCliPviIds = rtn
  
End Function

Private Function pGetCliPviCantidades(ByVal cli_id As Long) As Double()
  Dim rtn()       As Double
  Dim iRow        As cIABMGridRow
  Dim oRow        As cABMGridRow
  Dim i           As Long
  
  ReDim rtn(0)
    
  For Each iRow In pGetTodos().Grid.Rows
        
    Set oRow = iRow
    If Not oRow.IsGroup Then
        
      If pCell(iRow, KI_SELECT).id Then
      
        If pCell(iRow, KI_CLIENTE).id = cli_id Then
      
          i = i + 1
          ReDim Preserve rtn(i)
        
          rtn(i) = Val(pCell(iRow, KI_CANTIDAD_PV).Value)
          
        End If
      End If
    End If
  Next
  
  pGetCliPviCantidades = rtn
  
End Function

Private Sub pShowFacturar()

  If Not pSaveChanges() Then Exit Sub

  Dim PickingListPedido As cPickingListPedido
  Set PickingListPedido = New cPickingListPedido
  
  If PickingListPedido.Edit(m_Id) Then
  
    If Not pShowFactura(PickingListPedido.PvIdsFactura, _
                        PickingListPedido.doc_id_factura, _
                        PickingListPedido.DocFactura) Then
      
      If Not Ask(LNGGetText(4887, vbNullString), vbNo) Then
        pShowFacturas
        Exit Sub
      End If
    
    End If
  
    If Not pShowFactura(PickingListPedido.PvIdsInterno, _
                        PickingListPedido.doc_id_interno, _
                        PickingListPedido.DocInterno) Then
      
      If Ask(LNGGetText(4887, vbNullString), vbNo) Then
        pShowFacturas
        Exit Sub
      End If
    
    End If
    
    MsgInfo LNGGetText(4888, vbNullString) ' Las facturas se generaron con éxito
    
    pShowFacturas
    
  End If
    
End Sub

Private Sub pShowFacturas()
  Dim AbmGen As cABMGeneric
  
  pLoadFacturas pGetFacturas()
  Set AbmGen = m_ObjAbm
  AbmGen.ShowValue pGetFacturas, True

End Sub

Private Function pShowFactura(ByRef pedidos As Collection, _
                              ByVal doc_id As Long, _
                              ByVal doc_name As String) As Boolean
                         
  On Error GoTo ControlError

  Dim vPvIds()    As Long
  Dim Item        As cPickingListPedidoItem
  Dim last_cli_id As Long
  
  For Each Item In pedidos
  
    If Item.cli_id <> last_cli_id Then
      
      If last_cli_id <> csNO_ID Then
  
        If Not pShowFacturaAux( _
                      vPvIds, _
                      pGetCliPviIds(last_cli_id), _
                      pGetCliPviCantidades(last_cli_id), _
                      last_cli_id, _
                      doc_id, _
                      doc_name) Then
          Exit Function
        End If
  
      End If
      
      last_cli_id = Item.cli_id
      ReDim vPvIds(0)
      
    End If
    
    ReDim Preserve vPvIds(UBound(vPvIds) + 1)
    vPvIds(UBound(vPvIds)) = Item.pv_id

  Next

  ' El ultimo cliente
  '
  If last_cli_id <> csNO_ID Then

    If Not pShowFacturaAux( _
                  vPvIds, _
                  pGetCliPviIds(last_cli_id), _
                  pGetCliPviCantidades(last_cli_id), _
                  last_cli_id, _
                  doc_id, _
                  doc_name) Then
      Exit Function
    End If

  End If
  
  pShowFactura = True

  GoTo ExitProc
ControlError:
  MngError Err, "pShowFactura", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pShowFacturaAux(ByRef vPvIds() As Long, _
                                 ByRef vPviIds() As Long, _
                                 ByRef vPviCantidad() As Double, _
                                 ByVal cli_id As Long, _
                                 ByVal doc_id As Long, _
                                 ByVal doc_name As String) As Boolean
                            
  Dim o As CSVenta2.cFacturaVenta
  Set o = New CSVenta2.cFacturaVenta
  o.PushVirtualNext = True
  o.doc_id = doc_id
  o.doc_name = doc_name
  o.CloseWizardAfterSave = True
  o.ShowFacturaPedidoAuto cli_id, vPvIds(), vPviIds(), vPviCantidad()
  
  pShowFacturaAux = o.WizardCompleteSuccess
                            
End Function

Private Function pShowHojaRuta() As Boolean
  
  If m_Id = csNO_ID Then
    MsgWarning LNGGetText(4892, vbNullString) ' Debe grabar la lista de despacho
    Exit Function
  End If
  
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  Dim FvIds   As String
  
  FvIds = pGetFvIds()
  
  If LenB(FvIds) = 0 Then
    MsgWarning LNGGetText(4892, vbNullString) ' Debe grabar la lista de despacho
    Exit Function
  End If
  
  sqlstmt = "sp_PickingListSaveHojaRuta " _
                  & gDB.UserId & "," _
                  & m_Id & "," _
                  & gDB.sqlString(FvIds)
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  If rs.EOF Then Exit Function
  
  Dim HojaRuta As cHojaRuta
  Set HojaRuta = New cHojaRuta
  
  pShowHojaRuta = HojaRuta.Edit(rs.fields.Item(0).Value)
  
End Function

Private Function pGetFvIds() As String
  Dim rtn         As String
  Dim iRow        As cIABMGridRow
  Dim oRow        As cABMGridRow
  
  For Each iRow In pGetFacturas().Grid.Rows
        
    Set oRow = iRow
    If Not oRow.IsGroup Then
        
      If pCell(iRow, KI_SELECT).id Then
      
        rtn = rtn & Val(pCell(iRow, KI_FV_ID).Value) & ","
          
      End If
    End If
  Next
  
  pGetFvIds = RemoveLastColon(rtn)
  
End Function

Private Function pPrintFactura() As Boolean
  
  If m_Id = csNO_ID Then
    MsgWarning LNGGetText(4893, vbNullString) ' Debe grabar la lista de despacho
    Exit Function
  End If
  
  Dim iRow          As cIABMGridRow
  Dim oRow          As cABMGridRow
  Dim fv_id         As Long
  Dim doc_id        As Long
  Dim FacturaVenta  As cFacturaVenta
  Dim iEditObj      As cIEditGeneric
  Dim NroDoc        As String
  Dim Cliente       As String
  Dim cli_id        As Long
  
  Set FacturaVenta = New cFacturaVenta
  Set iEditObj = FacturaVenta
  Set iEditObj.ObjAbm = New CSABMInterface2.cABMGeneric
  
  For Each iRow In pGetFacturas().Grid.Rows
        
    Set oRow = iRow
    If Not oRow.IsGroup Then
        
      If pCell(iRow, KI_SELECT).id Then
      
        fv_id = Val(pCell(iRow, KI_FV_ID).Value)
        doc_id = pCell(iRow, KI_FV_DOC).id
        NroDoc = pCell(iRow, KI_FV_NRODOC).Value
        Cliente = pCell(iRow, KI_FV_CLIENTE).Value
        cli_id = pCell(iRow, KI_FV_CLIENTE).id
        
        If Not FacturaVenta.PrintDoc(fv_id, doc_id, cli_id, NroDoc, Cliente) Then
        
          ' ¿Desea continuar imprimiendo?
          '
          If Not Ask(LNGGetText(4890, vbNullString), vbNo) Then
            
            Exit Function
            
          End If
        
        End If
          
      End If
    End If
  Next
  
  pPrintFactura = True
End Function

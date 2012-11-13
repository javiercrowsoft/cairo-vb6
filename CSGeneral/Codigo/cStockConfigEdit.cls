VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cStockConfig"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIABMClient
Implements CSMenu.cIMenuClient
'--------------------------------------------------------------------------------
' cStockConfigEdit
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
Private Const C_Module = "cStockConfigEdit"

Private Const K_NO_CONTROLA_STOCK = 1
Private Const K_STOCK_X_LOGICO = 2
Private Const K_STOCK_X_FISICO = 3
Private Const K_PERMITE_STOCK_NEGATIVO = 4
Private Const K_SP_STOCK = 5
Private Const K_STOCK_PEDIDO_VTA = 6
Private Const K_STOCK_COD_BARRA_SUBIR = 7
Private Const K_STOCK_COD_BARRA_BAJAR = 8
Private Const K_STOCK_COD_BARRA_TIPO = 9
Private Const K_STOCK_COD_BARRA_LONGITUD = 10
Private Const K_STOCK_COD_BARRA_CARACTER = 11

Private Enum csE_ControlStock
  csENoControlaStock = 2
  csEStockLogico = 3
  csEStockFisico = 4
  csEStockNegativo = 5
End Enum

Private Enum csE_StockCodigoBarraTipo
  csESCB_Fijo
  csESCB_Caracter
End Enum

Private Const c_GrupoGeneral = "Stock-General"
Private Const c_TipoControlStock = "Tipo Control Stock"
Private Const c_NoControlaStock = "No Controla Stock"
Private Const c_StockLogico = "Stock Por Deposito Logico"
Private Const c_StockFisico = "Stock Por Deposito Fisico"
Private Const c_StockNegativo = "Stock Negativo"
Private Const c_SpStock = "SP Stock"
Private Const c_StockPedidoVta = "Stock en Pedido de Venta"

Private Const c_StockCodBarraSubir = "Código de barra para subir"
Private Const c_StockCodBarraBajar = "Código de barra para bajar"
Private Const c_StockCodBarraTipo = "Tipo de prefijo del código de barra"
Private Const c_StockCodBarraLongitud = "Longitud del prefijo del código de barra"
Private Const c_StockCodBarraCaracter = "Caracter separador del código de barra"

' estructuras
' Seudo - Variables
Private c_ErrorSave                 As String

' variables privadas
Private m_NoControlaStock           As Boolean
Private m_StockXLogico              As Boolean
Private m_StockXFisico              As Boolean
Private m_PermiteStockNegativo      As Boolean
Private m_SPStock                   As String
Private m_StockPedidoVta            As String

Private m_StockCodigoBarraSubir     As String
Private m_StockCodigoBarraBajar     As String
Private m_StockCodigoBarraTipo      As Long
Private m_StockCodigoBarraLongitud  As Long
Private m_StockCodigoBarraCaracter  As String

Private m_Editing           As Boolean
Private m_Host              As CSMenu.cIMenuHost
Private m_ObjAbm            As cIABMGeneric
' eventos
' propiedades publicas
' propiedades friend
' propiedades privadas
' funciones publicas
Private Function cIABMClient_Copy() As Boolean
End Function

Private Function cIABMClient_EditNew() As Boolean
End Function

Private Property Get cIABMClient_Aplication() As String
  cIABMClient_Aplication = gAppName
End Property

Private Property Get cIABMClient_CanAddDocDigital() As Boolean
  cIABMClient_CanAddDocDigital = False
End Property

Private Property Get cIABMClient_CanCopy() As Boolean
  cIABMClient_CanCopy = False
End Property

Private Property Get cIABMClient_CanNew() As Boolean
  cIABMClient_CanNew = False
End Property

Private Function cIABMClient_ShowDocDigital() As Boolean
  cIABMClient_ShowDocDigital = False
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
  On Error GoTo ControlError
  
  Dim iProp As cIABMProperty

  Select Case Key
    Case K_PERMITE_STOCK_NEGATIVO
      With m_ObjAbm.Properties
        Set iProp = .Item(c_SpStock)
        iProp.Enabled = Val(.Item(c_StockNegativo).Value)
      End With
      m_ObjAbm.ShowValue iProp
      cIABMClient_PropertyChange = True
    Case K_NO_CONTROLA_STOCK, K_STOCK_X_LOGICO, K_STOCK_X_FISICO
      With m_ObjAbm.Properties
        Set iProp = .Item(c_SpStock)
        iProp.Enabled = Val(.Item(c_StockNegativo).Value)
      End With
      m_ObjAbm.ShowValue iProp
      cIABMClient_PropertyChange = True
  End Select

  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClient_PropertyChange", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIABMClient_Save() As Boolean
  Dim IProperty As cIABMProperty
  Dim IsNew     As Boolean
  Dim register  As cRegister
  Dim Value     As csE_ControlStock
  
  Set register = New cRegister
  
  With register
    .Table = csTConfiguracion
    .Fields.HaveLastUpdate = True
    .Fields.HaveWhoModify = True
    .UtilizaIdentity = True
  
    ' Esto es para que el codigo en cDataBase no
    ' interprete que es un registro nuevo
    .ID = -1
  End With
  
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_NO_CONTROLA_STOCK
          If Val(.Value) Then Value = csENoControlaStock
          
        Case K_STOCK_X_LOGICO
          If Val(.Value) Then Value = csEStockLogico
          
        Case K_STOCK_X_FISICO
          If Val(.Value) Then Value = csEStockFisico
          
        Case K_PERMITE_STOCK_NEGATIVO
          If Val(.Value) Then Value = csEStockNegativo
        
        Case K_STOCK_PEDIDO_VTA
        
          With register
            .Fields.Clear
            
            .Filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                      " and cfg_aspecto = " & gDB.sqlString(c_StockPedidoVta)
            
            If Not .Exists(gDB, IsNew) Then Exit Function
            IsNew = Not IsNew
            
            With .Fields
              .Add2 cscCfgGrupo, c_GrupoGeneral, csText
              .Add2 cscCfgAspecto, c_StockPedidoVta, csText
              .Add2 cscCfgValor, Val(IProperty.Value), csText
            End With
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
        
        Case K_SP_STOCK
          With register
            .Fields.Clear
            
            .Filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                      " and cfg_aspecto = " & gDB.sqlString(c_SpStock)
            
            If Not .Exists(gDB, IsNew) Then Exit Function
            IsNew = Not IsNew
            
            With .Fields
              .Add2 cscCfgGrupo, c_GrupoGeneral, csText
              .Add2 cscCfgAspecto, c_SpStock, csText
              .Add2 cscCfgValor, IProperty.Value, csText
            End With
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function

        Case K_STOCK_COD_BARRA_SUBIR
          With register
            .Fields.Clear
            
            .Filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                      " and cfg_aspecto = " & gDB.sqlString(c_StockCodBarraSubir)
            
            If Not .Exists(gDB, IsNew) Then Exit Function
            IsNew = Not IsNew
            
            With .Fields
              .Add2 cscCfgGrupo, c_GrupoGeneral, csText
              .Add2 cscCfgAspecto, c_StockCodBarraSubir, csText
              .Add2 cscCfgValor, IProperty.Value, csText
            End With
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function

        Case K_STOCK_COD_BARRA_BAJAR
          With register
            .Fields.Clear
            
            .Filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                      " and cfg_aspecto = " & gDB.sqlString(c_StockCodBarraBajar)
            
            If Not .Exists(gDB, IsNew) Then Exit Function
            IsNew = Not IsNew
            
            With .Fields
              .Add2 cscCfgGrupo, c_GrupoGeneral, csText
              .Add2 cscCfgAspecto, c_StockCodBarraBajar, csText
              .Add2 cscCfgValor, IProperty.Value, csText
            End With
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function

        Case K_STOCK_COD_BARRA_TIPO
          With register
            .Fields.Clear
            
            .Filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                      " and cfg_aspecto = " & gDB.sqlString(c_StockCodBarraTipo)
            
            If Not .Exists(gDB, IsNew) Then Exit Function
            IsNew = Not IsNew
            
            With .Fields
              .Add2 cscCfgGrupo, c_GrupoGeneral, csText
              .Add2 cscCfgAspecto, c_StockCodBarraTipo, csText
              .Add2 cscCfgValor, IProperty.ListItemData, csText
            End With
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function

        Case K_STOCK_COD_BARRA_LONGITUD
          With register
            .Fields.Clear
            
            .Filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                      " and cfg_aspecto = " & gDB.sqlString(c_StockCodBarraLongitud)
            
            If Not .Exists(gDB, IsNew) Then Exit Function
            IsNew = Not IsNew
            
            With .Fields
              .Add2 cscCfgGrupo, c_GrupoGeneral, csText
              .Add2 cscCfgAspecto, c_StockCodBarraLongitud, csText
              .Add2 cscCfgValor, Val(IProperty.Value), csText
            End With
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function

        Case K_STOCK_COD_BARRA_CARACTER
          With register
            .Fields.Clear
            
            .Filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                      " and cfg_aspecto = " & gDB.sqlString(c_StockCodBarraCaracter)
            
            If Not .Exists(gDB, IsNew) Then Exit Function
            IsNew = Not IsNew
            
            With .Fields
              .Add2 cscCfgGrupo, c_GrupoGeneral, csText
              .Add2 cscCfgAspecto, c_StockCodBarraCaracter, csText
              .Add2 cscCfgValor, IProperty.Value, csText
            End With
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function

      End Select
    End With
  Next
  
  With register
    .Fields.Clear
    
    .Filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                      " and cfg_aspecto = " & gDB.sqlString(c_TipoControlStock)
    
    If Not .Exists(gDB, IsNew) Then Exit Function
    IsNew = Not IsNew
    
    With .Fields
      .Add2 cscCfgGrupo, c_GrupoGeneral, csText
      .Add2 cscCfgAspecto, c_TipoControlStock, csText
      .Add2 cscCfgValor, Value, csText
    End With
  End With
  
  If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
         c_ErrorSave) Then Exit Function
  
  cIABMClient_Save = Load()
End Function

Private Function cIABMClient_Terminate() As Boolean
  m_Editing = False
  cIABMClient_Terminate = True
End Function

Private Property Get cIABMClient_Title() As String
  cIABMClient_Title = LNGGetText(2862, vbNullString) 'Configuración General
End Property

Private Function cIABMClient_Validate() As Boolean
  Dim IProperty As cIABMProperty
  
  With m_ObjAbm.Properties
    If Val(.Item(c_StockNegativo).Value) Then
      If ValEmpty(.Item(c_SpStock).Value, csText) Then
        MsgWarning LNGGetText(3106, vbNullString)
                    'Debe indicar un stored procedure para controlar el stock
        Exit Function
      End If
    End If
  End With
  
  cIABMClient_Validate = True
End Function

' ////////////////////////////////
' ////////////////////////////////
' ////////////////////////////////
' ////////////////////////////////
' ////////////////////////////////
' ////////////////////////////////

' Menu
Private Function cIMenuClient_Initialize(F As Object, Host As CSMenu.cIMenuHost) As Boolean
  On Error GoTo ControlError

  Set m_Host = Host
  
  m_Host.Server.AddMenu C_MenuStock, csMenuConfigStock, C_MenuConfig, 0, True, False, False, False, True, Nothing
  m_Host.Server.AddMenu LNGGetText(2431, vbNullString), csPreGModifyConfigStock, C_MenuStock, 0, True, False, False, False, False, Me
                        'Gen&eral
  m_Host.Server.AddMenu vbNullString, csPreGModifyConfigStock * -1, C_MenuStock, 0, True, True, False, False, False, Nothing

  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, C_MenuClientInit, C_Module, vbNullString
  If Err.Number Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal ID As Long) As Variant
  pEdit
End Function

Private Function Load() As Boolean
  Dim sqlstmt As String

  sqlstmt = "select * from configuracion where cfg_grupo = " & gDB.sqlString(c_GrupoGeneral)

  Dim rs As Recordset

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  m_StockXLogico = False
  m_NoControlaStock = False
  m_StockXFisico = False
  m_PermiteStockNegativo = False
  m_SPStock = vbNullString
  m_StockPedidoVta = False
  
  m_StockCodigoBarraSubir = "**SUBIRRENGLON"
  m_StockCodigoBarraBajar = "**BAJARRENGLON"
  m_StockCodigoBarraTipo = csE_StockCodigoBarraTipo.csESCB_Fijo
  m_StockCodigoBarraLongitud = 5
  m_StockCodigoBarraCaracter = vbNullString
  
  While Not rs.EOF
    Select Case gDB.ValField(rs.Fields, cscCfgAspecto)
      Case c_TipoControlStock
        Select Case Val(gDB.ValField(rs.Fields, cscCfgValor))
          Case csE_ControlStock.csENoControlaStock
            m_NoControlaStock = True
          Case csE_ControlStock.csEStockFisico
            m_StockXFisico = True
          Case csE_ControlStock.csEStockLogico
            m_StockXLogico = True
          Case csE_ControlStock.csEStockNegativo
            m_PermiteStockNegativo = True
        End Select
      Case c_SpStock
        m_SPStock = gDB.ValField(rs.Fields, cscCfgValor)
      Case c_StockPedidoVta
        m_StockPedidoVta = Val(gDB.ValField(rs.Fields, cscCfgValor))
      
      Case c_StockCodBarraSubir
        m_StockCodigoBarraSubir = gDB.ValField(rs.Fields, cscCfgValor)
      
      Case c_StockCodBarraBajar
        m_StockCodigoBarraBajar = gDB.ValField(rs.Fields, cscCfgValor)
      
      Case c_StockCodBarraTipo
        m_StockCodigoBarraTipo = Val(gDB.ValField(rs.Fields, cscCfgValor))
      
      Case c_StockCodBarraLongitud
        m_StockCodigoBarraLongitud = Val(gDB.ValField(rs.Fields, cscCfgValor))
      
      Case c_StockCodBarraCaracter
        m_StockCodigoBarraCaracter = gDB.ValField(rs.Fields, cscCfgValor)
    End Select
    rs.MoveNext
  Wend

  Load = True
End Function

Private Sub pEdit()
  On Error GoTo ControlError
  
  Set m_ObjAbm = New cABMGeneric
  
  If Not SecurityCanAccess(csPreGModifyConfigStock) Then Exit Sub

  If Not Load() Then Exit Sub
  
  If Not LoadCollection() Then Exit Sub
  
  m_Editing = True
  
  Exit Sub
ControlError:
  MngError Err, "pEdit", C_Module, vbNullString
End Sub

Private Function LoadCollection() As Boolean
  Dim c       As cIABMProperty
  Dim AbmObj  As cABMGeneric
  
  m_ObjAbm.Properties.Clear
  
  With m_ObjAbm.Tabs
    .Clear
    With .Add(Nothing)
      .Name = C_strGeneral
    End With
    With .Add(Nothing)
      .Name = LNGGetText(1177, vbNullString) 'Código de Barras
      .Index = 1
    End With
  End With

  Set AbmObj = m_ObjAbm
  AbmObj.MinHeight = 6500

  Set c = m_ObjAbm.Properties.Add(Nothing, c_NoControlaStock)
  c.PropertyType = cspOption
  c.OptionGroup = 0
  c.Width = 2320
  c.Name = c_NoControlaStock
  c.Value = CInt(m_NoControlaStock)
  c.Key = K_NO_CONTROLA_STOCK
  c.TopFrame = 1100
  
  Set c = m_ObjAbm.Properties.Add(Nothing, c_StockLogico)
  c.PropertyType = cspOption
  c.OptionGroup = 0
  c.Width = 2320
  c.Name = c_StockLogico
  c.Value = CInt(m_StockXLogico)
  c.Key = K_STOCK_X_LOGICO
  
  Set c = m_ObjAbm.Properties.Add(Nothing, c_StockFisico)
  c.PropertyType = cspOption
  c.OptionGroup = 0
  c.Width = 2320
  c.Name = c_StockFisico
  c.Value = CInt(m_StockXFisico)
  c.Key = K_STOCK_X_FISICO
  
  Set c = m_ObjAbm.Properties.Add(Nothing, c_StockNegativo)
  c.PropertyType = cspOption
  c.OptionGroup = 0
  c.Width = 2320
  c.Name = c_StockNegativo
  c.Value = CInt(m_PermiteStockNegativo)
  c.Key = K_PERMITE_STOCK_NEGATIVO
  
  Set c = m_ObjAbm.Properties.Add(Nothing, c_SpStock)
  c.PropertyType = cspText
  c.TopNotChange = True
  c.LeftNotChange = True
  c.Top = 2630
  c.Left = 3800
  c.Width = 4000
  c.LeftLabel = -800
  c.Name = c_SpStock
  c.Value = m_SPStock
  c.Enabled = m_PermiteStockNegativo
  c.Key = K_SP_STOCK
  
  Set c = m_ObjAbm.Properties.Add(Nothing, c_StockPedidoVta)
  c.PropertyType = cspCheck
  c.LeftLabel = -2100
  c.TopToPrevious = 200
  c.Left = 2530
  c.Name = c_StockPedidoVta
  c.Value = m_StockPedidoVta
  c.Key = K_STOCK_PEDIDO_VTA
  
  Set c = m_ObjAbm.Properties.Add(Nothing, c_StockCodBarraSubir)
  c.PropertyType = cspText
  c.LeftLabel = -2100
  c.Left = 2530
  c.Name = c_StockCodBarraSubir
  c.Value = m_StockCodigoBarraSubir
  c.Key = K_STOCK_COD_BARRA_SUBIR
  c.TabIndex = 1

  Set c = m_ObjAbm.Properties.Add(Nothing, c_StockCodBarraBajar)
  c.PropertyType = cspText
  c.LeftLabel = -2100
  c.Name = c_StockCodBarraBajar
  c.Value = m_StockCodigoBarraBajar
  c.Key = K_STOCK_COD_BARRA_BAJAR
  c.TabIndex = 1

  Set c = m_ObjAbm.Properties.Add(Nothing, c_StockCodBarraTipo)
  c.PropertyType = cspList
  With c.List
    With .Add(Nothing)
      .ID = csESCB_Fijo
      .Value = LNGGetText(3107, vbNullString) 'Longitud Fija
    End With
    With .Add(Nothing)
      .ID = csESCB_Caracter
      .Value = LNGGetText(3108, vbNullString) 'Variable separado por un caracter
    End With
  End With
  c.LeftLabel = -2100
  c.Name = c_StockCodBarraTipo
  c.ListWhoSetItem = csListItemData
  c.ListItemData = m_StockCodigoBarraTipo
  c.Key = K_STOCK_COD_BARRA_TIPO
  c.TabIndex = 1
  
  Set c = m_ObjAbm.Properties.Add(Nothing, c_StockCodBarraLongitud)
  c.PropertyType = cspNumeric
  c.SubType = cspInteger
  c.LeftLabel = -2100
  c.Name = c_StockCodBarraLongitud
  c.Value = m_StockCodigoBarraLongitud
  c.Key = K_STOCK_COD_BARRA_LONGITUD
  c.Width = 800
  c.TabIndex = 1

  Set c = m_ObjAbm.Properties.Add(Nothing, c_StockCodBarraCaracter)
  c.PropertyType = cspText
  c.LeftLabel = -2100
  c.Name = c_StockCodBarraCaracter
  c.Value = m_StockCodigoBarraCaracter
  c.Key = K_STOCK_COD_BARRA_CARACTER
  c.Width = 800
  c.TabIndex = 1
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

Private Sub Class_Initialize()
  On Error GoTo ControlError

  c_ErrorSave = LNGGetText(2301, vbNullString) 'Error al grabar la Configuración General

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

' funciones friend
' funciones privadas
' construccion - destruccion
Private Sub Class_Terminate()
  On Error Resume Next
  Set m_ObjAbm = Nothing
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


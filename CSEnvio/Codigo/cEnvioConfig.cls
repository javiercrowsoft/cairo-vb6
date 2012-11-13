VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cEnvioConfig"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIABMClient
Implements CSMenu.cIMenuClient
'--------------------------------------------------------------------------------
' cEnvioConfig
' 28-12-2003

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cEnvioConfig"

Private Const K_TALONARIO_PARTE_DIARIO = 1
Private Const K_TALONARIO_LEGAJO = 2
Private Const K_PRODUCTO_ENVIO = 3
Private Const K_PRODUCTO_GASTO = 4

Private Const c_GrupoEnvio = "Envio"
Private Const c_TalonarioParteDiario = "Talonario Parte Diario"
Private Const c_TalonarioLegajo = "Talonario Legajo"

Private Const c_ProductoGasto = "Producto Gasto"
Private Const c_ProductoEnvio = "Producto Envio"

' pseudo-constantes
Private c_ErrorSave As String

' estructuras
' variables privadas
Private m_Tal_id_ParteDiario     As Long
Private m_TalonarioParteDiario   As String

Private m_Tal_id_Legajo     As Long
Private m_TalonarioLegajo   As String

Private m_pr_id_Gastos      As Long
Private m_ProductoGastos    As String

Private m_pr_id_Envios      As Long
Private m_ProductoEnvios    As String

Private m_Editing           As Boolean
Private m_Host              As CSMenu.cIMenuHost
Private m_ObjAbm            As cIABMGeneric
' eventos
' propiedades publicas

Public Property Get Tal_Id_ParteDiario() As Long
  Tal_Id_ParteDiario = m_Tal_id_ParteDiario
End Property

Public Property Get TalonarioParteDiario() As String
  TalonarioParteDiario = m_TalonarioParteDiario
End Property

Public Property Get Tal_Id_Legajo() As Long
  Tal_Id_Legajo = m_Tal_id_Legajo
End Property

Public Property Get TalonarioLegajo() As String
  TalonarioLegajo = m_TalonarioLegajo
End Property

Public Property Get Pr_id_Envio() As Long
  Pr_id_Envio = m_pr_id_Envios
End Property

Public Property Get ProductoEnvio() As String
  ProductoEnvio = m_ProductoEnvios
End Property

Public Property Get Pr_id_Gasto() As Long
  Pr_id_Gasto = m_pr_id_Gastos
End Property

Public Property Get ProductoGasto() As String
  ProductoGasto = m_ProductoGastos
End Property


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
End Function

Private Function cIABMClient_Save() As Boolean
  Dim IProperty As cIABMProperty
  Dim IsNew     As Boolean
  Dim register  As cRegister
  Dim fields    As cFields
  
  Set register = New cRegister
  
  With register
    Set fields = .fields
    .Table = csTConfiguracion
    .fields.HaveLastUpdate = True
    .fields.HaveWhoModify = True
    .UtilizaIdentity = True
    
    ' Esto es para que el codigo en cDataBase no
    ' interprete que es un registro nuevo
    .ID = -1
  End With
  
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_TALONARIO_LEGAJO
          fields.Clear
          
          register.Filter = "cfg_grupo = " & gDB.sqlString(c_GrupoEnvio) & _
                            " and cfg_aspecto = " & gDB.sqlString(c_TalonarioLegajo)
          
          If Not register.Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          fields.Add2 cscCfgGrupo, c_GrupoEnvio, csText
          fields.Add2 cscCfgAspecto, c_TalonarioLegajo, csText
          fields.Add2 cscCfgValor, Val(.HelpId), csText
          
          If Not gDB.Save(register, IsNew, "cIABMClient_Save", C_Module, _
                 c_ErrorSave) Then Exit Function
      
        
        Case K_PRODUCTO_ENVIO
          fields.Clear
          
          register.Filter = "cfg_grupo = " & gDB.sqlString(c_GrupoEnvio) & _
                            " and cfg_aspecto = " & gDB.sqlString(c_ProductoEnvio)
          
          If Not register.Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          fields.Add2 cscCfgGrupo, c_GrupoEnvio, csText
          fields.Add2 cscCfgAspecto, c_ProductoEnvio, csText
          fields.Add2 cscCfgValor, Val(.HelpId), csText
          
          If Not gDB.Save(register, IsNew, "cIABMClient_Save", C_Module, _
                 c_ErrorSave) Then Exit Function
        
        Case K_PRODUCTO_GASTO
          fields.Clear
          
          register.Filter = "cfg_grupo = " & gDB.sqlString(c_GrupoEnvio) & _
                            " and cfg_aspecto = " & gDB.sqlString(c_ProductoGasto)
          
          If Not register.Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          fields.Add2 cscCfgGrupo, c_GrupoEnvio, csText
          fields.Add2 cscCfgAspecto, c_ProductoGasto, csText
          fields.Add2 cscCfgValor, Val(.HelpId), csText
          
          If Not gDB.Save(register, IsNew, "cIABMClient_Save", C_Module, _
                 c_ErrorSave) Then Exit Function
        
        Case K_TALONARIO_PARTE_DIARIO
          fields.Clear
          
          register.Filter = "cfg_grupo = " & gDB.sqlString(c_GrupoEnvio) & _
                            " and cfg_aspecto = " & gDB.sqlString(c_TalonarioParteDiario)
          
          If Not register.Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          fields.Add2 cscCfgGrupo, c_GrupoEnvio, csText
          fields.Add2 cscCfgAspecto, c_TalonarioParteDiario, csText
          fields.Add2 cscCfgValor, Val(.HelpId), csText
          
          If Not gDB.Save(register, IsNew, "cIABMClient_Save", C_Module, _
                 c_ErrorSave) Then Exit Function
      
      End Select
    End With
  Next
  cIABMClient_Save = Load()
End Function

Private Function cIABMClient_Terminate() As Boolean
  m_Editing = False
  cIABMClient_Terminate = True
End Function

Private Property Get cIABMClient_Title() As String
  cIABMClient_Title = LNGGetText(2307, vbNullString) 'Configuración General de Envíos
End Property

Private Function cIABMClient_Validate() As Boolean

  Dim IProperty As cIABMProperty

  CSKernelClient2.Title = LNGGetText(2307, vbNullString) 'Configuración General de Envíos

  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_TALONARIO_PARTE_DIARIO
          If .HelpId = csNO_ID Then
            MsgWarning LNGGetText(2308, vbNullString)
                      'Debe indicar un talonario para los Partes Diarios
            Exit Function
          End If
        Case K_TALONARIO_LEGAJO
          If .HelpId = csNO_ID Then
            MsgWarning LNGGetText(2309, vbNullString)
                      'Debe indicar un talonario para los Legajos
            Exit Function
          End If
        Case K_PRODUCTO_ENVIO
          If .HelpId = csNO_ID Then
            MsgWarning LNGGetText(2310, vbNullString) 'Debe indicar un producto para Envíos
            Exit Function
          End If
        Case K_PRODUCTO_GASTO
          If .HelpId = csNO_ID Then
            MsgWarning LNGGetText(2311, vbNullString) 'Debe indicar un producto para Gastos
            Exit Function
          End If
      End Select
    End With
  Next

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
  Dim str_2383
  
  str_2383 = LNGGetText(2383, vbNullString) 'En&vios
  
  Set m_Host = Host
                                                'Co&nfiguración
  m_Host.Server.AddMenu str_2383, csMenuConfig, LNGGetText(1028, vbNullString), 0, True, False, True, False, True, Nothing
  m_Host.Server.AddMenu LNGGetText(2313, vbNullString), csPreEnvModifyConfig, str_2383, 0, True, False, False, False, False, Me
                        'Ge&neral
  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, "cIMenuClient_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal ID As Long) As Variant
  pEdit
End Function

Public Function Load() As Boolean
  Dim sqlstmt As String

  sqlstmt = "select * from configuracion where cfg_grupo = " & gDB.sqlString(c_GrupoEnvio)

  Dim rs As Recordset

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  m_TalonarioParteDiario = vbNullString
  m_Tal_id_ParteDiario = csNO_ID

  m_TalonarioLegajo = vbNullString
  m_Tal_id_Legajo = csNO_ID

  While Not rs.EOF
    Select Case gDB.ValField(rs.fields, cscCfgAspecto)
      Case c_TalonarioParteDiario
        m_Tal_id_ParteDiario = Val(gDB.ValField(rs.fields, cscCfgValor))
        If Not gDB.GetData(csTTalonario, cscTaId, m_Tal_id_ParteDiario, cscTaNombre, m_TalonarioParteDiario) Then Exit Function
    
      Case c_TalonarioLegajo
        m_Tal_id_Legajo = Val(gDB.ValField(rs.fields, cscCfgValor))
        If Not gDB.GetData(csTTalonario, cscTaId, m_Tal_id_Legajo, cscTaNombre, m_TalonarioLegajo) Then Exit Function
    
      Case c_ProductoEnvio
        m_pr_id_Envios = Val(gDB.ValField(rs.fields, cscCfgValor))
        If Not gDB.GetData(csTProducto, cscPrId, m_pr_id_Envios, cscPrNombreventa, m_ProductoEnvios) Then Exit Function
    
      Case c_ProductoGasto
        m_pr_id_Gastos = Val(gDB.ValField(rs.fields, cscCfgValor))
        If Not gDB.GetData(csTProducto, cscPrId, m_pr_id_Gastos, cscPrNombreventa, m_ProductoGastos) Then Exit Function
    End Select
    rs.MoveNext
  Wend

  Load = True
End Function

Private Sub pEdit()
  On Error GoTo ControlError
  
  Set m_ObjAbm = New cABMGeneric
  
  If Not SecurityCanAccess(csPreEnvModifyConfig) Then Exit Sub

  If Not Load() Then Exit Sub
  
  If Not LoadCollection() Then Exit Sub
  
  m_Editing = True
  
  Exit Sub
ControlError:
  MngError Err, "pEdit", C_Module, vbNullString
End Sub

Private Function LoadCollection() As Boolean
  
  With m_ObjAbm.Properties
    
    .Clear

    With .Add(Nothing, c_TalonarioLegajo)
      .PropertyType = cspHelp
      .Table = csTalonario
      .Left = 2000
      .LeftLabel = -1700
      .Name = LNGGetText(2314, vbNullString) 'Talonarios de Legajo
      .Key = K_TALONARIO_LEGAJO
      .Value = m_TalonarioLegajo
      .HelpId = m_Tal_id_Legajo
    End With
      
    With .Add(Nothing, c_TalonarioParteDiario)
      .PropertyType = cspHelp
      .Table = csTalonario
      .Name = LNGGetText(2315, vbNullString) 'Talonarios de Partes Diario
      .Key = K_TALONARIO_PARTE_DIARIO
      .Value = m_TalonarioParteDiario
      .HelpId = m_Tal_id_ParteDiario
    End With
      
    With .Add(Nothing, c_ProductoEnvio)
      .PropertyType = cspHelp
      .Table = csProductoVenta
      .Left = 2000
      .LeftLabel = -1700
      .Name = LNGGetText(2316, vbNullString) 'Producto Envío
      .Key = K_PRODUCTO_ENVIO
      .Value = m_ProductoEnvios
      .HelpId = m_pr_id_Envios
    End With
      
    With .Add(Nothing, c_ProductoGasto)
      .PropertyType = cspHelp
      .Table = csProductoVenta
      .Left = 2000
      .LeftLabel = -1700
      .Name = LNGGetText(2317, vbNullString) 'Producto Gasto
      .Key = K_PRODUCTO_GASTO
      .Value = m_ProductoGastos
      .HelpId = m_pr_id_Gastos
    End With
    
  End With
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function
' funciones friend
' funciones privadas
' construccion - destruccion

Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  c_ErrorSave = LNGGetText(2306, vbNullString)
              'Error al grabar la configuración general de Envíos
  
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

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Terminate", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
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



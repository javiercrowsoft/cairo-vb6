VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cContConfig"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIABMClient
Implements CSMenu.cIMenuClient
'--------------------------------------------------------------------------------
' cContabilidadConfigEdit
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
Private Const C_Module = "cContabilidadConfigEdit"

Private Const csTalonario As Integer = 4004

Private Const K_CLAVE_FISCAL = 1
Private Const K_FACTURA_ELECTRONICA = 2
Private Const K_FE_PUNTO_VENTA = 3
Private Const K_TA_ID_PREFACTURA = 4

Private Const c_GrupoGeneral = "Contabilidad-General"
Private Const c_ClaveFiscal = "Clave Fiscal"
Private Const c_FacturaElectronica = "Factura Electronica Asincronica"
Private Const c_PuntoVentaFE = "Punto Venta FE"
Private Const c_TaIdPreFactura = "Talonario Pre-Factura - Factura Electronica"

' estructuras
' Seudo - Variables
Private c_ErrorSave         As String

' variables privadas
Private m_claveFiscal         As Long
Private m_facturaElectronica  As Boolean
Private m_puntoVentaFe        As Long
Private m_talonario           As String
Private m_ta_id               As Long

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
End Function

Private Function cIABMClient_Save() As Boolean
  Dim IProperty As cIABMProperty
  Dim IsNew     As Boolean
  Dim register  As cRegister
  
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
    With register
      Select Case IProperty.Key
        Case K_CLAVE_FISCAL
          .Fields.Clear
          
          .filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                    " and cfg_aspecto = " & gDB.sqlString(c_ClaveFiscal)
          
          If Not register.Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .Fields
            .Add2 cscCfgGrupo, c_GrupoGeneral, csText
            .Add2 cscCfgAspecto, c_ClaveFiscal, csText
            .Add2 cscCfgValor, IProperty.ListItemData, csText
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
      
      
        Case K_FACTURA_ELECTRONICA
          .Fields.Clear
          
          .filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                    " and cfg_aspecto = " & gDB.sqlString(c_FacturaElectronica)
          
          If Not register.Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .Fields
            .Add2 cscCfgGrupo, c_GrupoGeneral, csText
            .Add2 cscCfgAspecto, c_FacturaElectronica, csText
            .Add2 cscCfgValor, IProperty.Value, csText
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
      
        Case K_FE_PUNTO_VENTA
          .Fields.Clear
          
          .filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                    " and cfg_aspecto = " & gDB.sqlString(c_PuntoVentaFE) & _
                    " and emp_id = " & EmpId
          
          If Not register.Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .Fields
            .Add2 cscCfgGrupo, c_GrupoGeneral, csText
            .Add2 cscCfgAspecto, c_PuntoVentaFE, csText
            .Add2 cscCfgValor, IProperty.Value, csText
            .Add2 cscEmpId, EmpId, csId
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
      
        Case K_TA_ID_PREFACTURA
          .Fields.Clear
          
          .filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                    " and cfg_aspecto = " & gDB.sqlString(c_TaIdPreFactura) & _
                    " and emp_id = " & EmpId
          
          If Not register.Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .Fields
            .Add2 cscCfgGrupo, c_GrupoGeneral, csText
            .Add2 cscCfgAspecto, c_TaIdPreFactura, csText
            .Add2 cscCfgValor, IProperty.HelpId, csText
            .Add2 cscEmpId, EmpId, csId
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
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
  cIABMClient_Title = LNGGetText(2682, vbNullString) 'Configuración General
End Property

Private Function cIABMClient_Validate() As Boolean

  Dim IProperty As cIABMProperty

  CSKernelClient2.Title = LNGGetText(2682, vbNullString) 'Configuración General

  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_CLAVE_FISCAL
          If .ListItemData = csNO_ID Then
            MsgInfo LNGGetText(3096, vbNullString) 'Debe indicar con que tipo de clave fiscal trabaja Cairo.
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
  Dim str_1032    As String
  

  str_1032 = LNGGetText(1032, vbNullString) '&Contabilidad
  Set m_Host = Host
  m_Host.Server.AddMenu str_1032, csMenuConfigContabilidad, C_MenuConfig, 0, True, False, False, False, True, Nothing
  m_Host.Server.AddMenu LNGGetText(2431, vbNullString), csPreGModifyConfigContabilidad, str_1032, 0, True, False, False, False, False, Me
                        'Gen&eral
  m_Host.Server.AddMenu "", csPreGModifyConfigContabilidad * -1, str_1032, 0, True, True, False, False, False, Nothing

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

  m_claveFiscal = csNO_ID
  m_facturaElectronica = False

  While Not rs.EOF
    Select Case gDB.ValField(rs.Fields, cscCfgAspecto)
      Case c_ClaveFiscal
        m_claveFiscal = Val(gDB.ValField(rs.Fields, cscCfgValor))
      Case c_FacturaElectronica
        m_facturaElectronica = Val(gDB.ValField(rs.Fields, cscCfgValor))
      End Select
    rs.MoveNext
  Wend

  sqlstmt = "select * from configuracion where emp_id = " & EmpId & " and cfg_grupo = " & _
                 gDB.sqlString(c_GrupoGeneral)

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  m_puntoVentaFe = 0

  While Not rs.EOF
    Select Case gDB.ValField(rs.Fields, cscCfgAspecto)
      Case c_PuntoVentaFE
        m_puntoVentaFe = Val(gDB.ValField(rs.Fields, cscCfgValor))
      
      Case c_TaIdPreFactura
        m_ta_id = Val(gDB.ValField(rs.Fields, cscCfgValor))
        If Not gDB.GetData(csTTalonario, cscTaId, m_ta_id, cscTaNombre, m_talonario) Then Exit Function
      
      End Select
    rs.MoveNext
  Wend

  Load = True
End Function

Private Sub pEdit()
  On Error GoTo ControlError
  
  Set m_ObjAbm = New cABMGeneric
  
  If Not SecurityCanAccess(csPreGModifyConfigContabilidad) Then Exit Sub

  If Not Load() Then Exit Sub
  
  If Not LoadCollection() Then Exit Sub
  
  m_Editing = True
  
  Exit Sub
ControlError:
  MngError Err, "pEdit", C_Module, vbNullString
End Sub

Private Function LoadCollection() As Boolean

  m_ObjAbm.Properties.Clear

  With m_ObjAbm.Properties
    With .Add(Nothing, c_ClaveFiscal)
      .PropertyType = cspList
      .Left = 2200
      .Width = 3000
      .LeftLabel = -1900
      .Name = LNGGetText(3097, vbNullString)  'Tipo de Clave Fiscal
      .Key = K_CLAVE_FISCAL
      With .List
        With .Add(Nothing)
          .ID = csEClaveFiscalCuit
          .Value = LNGGetText(3098, vbNullString)  'C.U.I.T.
        End With
        With .Add(Nothing)
          .ID = csEClaveFiscalRut
          .Value = LNGGetText(3099, vbNullString)  'R.U.T.
        End With
      End With
      .ListWhoSetItem = csListItemData
      .ListItemData = m_claveFiscal
    End With
        
    Dim c As cIABMProperty
    Set c = .Add(Nothing, c_PuntoVentaFE)
    With c
      .PropertyType = cspNumeric
      .SubType = cspInteger
      .Left = 3800
      .Width = 800
      .LeftLabel = -3500
      .Name = LNGGetText(5126, vbNullString) 'Punto de Venta Factura Electronica
      .Key = K_FE_PUNTO_VENTA
      .Value = m_puntoVentaFe
      Dim o As cABMProperty
      Set o = c
      o.NoShowButton = True
    End With
    
    With .Add(Nothing, c_TaIdPreFactura)
      .PropertyType = cspHelp
      .Table = csTalonario
      .Left = 3800
      .LeftLabel = -3500
      .Width = 3500
      .Name = LNGGetText(5127, vbNullString) 'Talonario pre-facturas Factura Electronica
      .Key = K_TA_ID_PREFACTURA
      .Value = m_talonario
      .HelpId = m_ta_id
    End With
    
    With .Add(Nothing, c_FacturaElectronica)
      .PropertyType = cspCheck
      .Left = 5800
      .LeftLabel = -5500
      .Name = LNGGetText(5124, vbNullString) 'Infomar al servicio web AFIP de factura electronica asincronicamente
      .Key = K_FACTURA_ELECTRONICA
      .Value = CInt(m_facturaElectronica)
    End With
    
  End With
  
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

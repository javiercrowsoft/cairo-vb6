VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cAsientosEdit"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIABMClient
Implements CSMenu.cIMenuClient
'--------------------------------------------------------------------------------
' cAsientosEdit
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
Private Const C_Module = "cAsientosEdit"

Private Const K_EMP_ID              As Integer = 1
Private Const K_CICO_ID             As Integer = 2
Private Const K_EJC_ID              As Integer = 3

Private Const K_TIPO_RESUMEN_FC     As Integer = 4
Private Const K_TIPO_RESUMEN_FV     As Integer = 5

Private Const c_GrupoGeneral = "Contabilidad-General"
Private Const c_TipoResumenFC = "Tipo Resumen Libro Diario Compras"
Private Const c_TipoResumenFV = "Tipo Resumen Libro Diario Ventas"

Public Enum csE_LibroDiarioTipoResumen
  csELDTR_Semanal = 1
  csELDTR_Mensual = 2
  csELDTR_SinResumir = 3
End Enum

' estructuras
' variables privadas
Private m_tipo_resumen_fc               As csE_LibroDiarioTipoResumen
Private m_tipo_resumen_fv               As csE_LibroDiarioTipoResumen

Private m_emp_id        As Long
Private m_empresa       As String
Private m_cico_id       As Long
Private m_circuito      As String
Private m_ejc_id        As Long
Private m_ejercicio     As String

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

  Select Case Key
  
    Case K_EMP_ID, K_CICO_ID
      
      With m_ObjAbm.Properties
        .Item(cscEjcId).HelpFilter = pGetEjcFilter()
        m_ObjAbm.ShowValue .Item(cscEjcId)
      End With
  
  End Select
  
End Function

Private Function cIABMClient_Save() As Boolean
  Dim IProperty As cIABMProperty
  Dim IsNew     As Boolean
  Dim register  As cRegister
  
  Set register = New cRegister
  
  With register
    .Table = csTConfiguracion
    .fields.HaveLastUpdate = True
    .fields.HaveWhoModify = True
    .UtilizaIdentity = True
    
    ' Esto es para que el codigo en cDataBase no
    ' interprete que es un registro nuevo
    .ID = -1
  End With
  
  Dim c_ErrorSave As String
  
  c_ErrorSave = LNGGetText(2301, vbNullString) 'Error al grabar la configuración general
  
  For Each IProperty In m_ObjAbm.Properties
    With register
      Select Case IProperty.Key
        Case K_TIPO_RESUMEN_FC
          .fields.Clear
          
          .Filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                    " and cfg_aspecto = " & gDB.sqlString(c_TipoResumenFC)
          
          If Not register.Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoGeneral, csText
            .Add2 cscCfgAspecto, c_TipoResumenFC, csText
            .Add2 cscCfgValor, IProperty.ListItemData, csText
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
                 
        Case K_TIPO_RESUMEN_FV
          .fields.Clear
          
          .Filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                    " and cfg_aspecto = " & gDB.sqlString(c_TipoResumenFV)
          
          If Not register.Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoGeneral, csText
            .Add2 cscCfgAspecto, c_TipoResumenFV, csText
            .Add2 cscCfgValor, IProperty.ListItemData, csText
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
      End Select
    End With
  Next
  
  With m_ObjAbm.Properties
    With .Item(cscEmpId)
      m_empresa = .Value
      m_emp_id = .HelpId
    End With
    With .Item(cscCicoId)
      m_circuito = .Value
      m_cico_id = .HelpId
    End With
    With .Item(cscEjcId)
      m_ejercicio = .Value
      m_ejc_id = .HelpId
    End With
  End With
  
  If Not pRenumerar() Then Exit Function
  
  cIABMClient_Save = Load()
End Function

Private Function cIABMClient_Terminate() As Boolean
  m_Editing = False
  cIABMClient_Terminate = True
End Function

Private Property Get cIABMClient_Title() As String
  cIABMClient_Title = LNGGetText(1967, vbNullString)  'Renumerar Asientos
End Property

Private Function cIABMClient_Validate() As Boolean

  Dim IProperty As cIABMProperty

  CSKernelClient2.Title = LNGGetText(1967, vbNullString)  'Renumerar Asientos

  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_TIPO_RESUMEN_FC
          If .ListItemData = csNO_ID Then
            MsgInfo LNGGetText(1968, vbNullString)  'Debe indicar un tipo de resumen para compras.
            Exit Function
          End If
        Case K_TIPO_RESUMEN_FV
          If .ListItemData = csNO_ID Then
            MsgInfo LNGGetText(1969, vbNullString)  'Debe indicar un tipo de resumen para ventas.
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
  
  Dim str_1742 As String ' Con&tabilidad
  
  str_1742 = LNGGetText(1742, vbNullString)
  
  Set m_Host = Host
  
  m_Host.Server.AddMenu str_1742, csMenuEnum.csMenuContabilidad, vbNullString, 1, False, False, False, True, False, Nothing
  m_Host.Server.AddMenu LNGGetText(1970, vbNullString), csPreConRenumerarAsientos, str_1742, 0, True, False, False, False, False, Me
                        '&Renumerar Asiento
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

  m_tipo_resumen_fc = csNO_ID

  While Not rs.EOF
    Select Case gDB.ValField(rs.fields, cscCfgAspecto)
      
      Case c_TipoResumenFC
        m_tipo_resumen_fc = Val(gDB.ValField(rs.fields, cscCfgValor))
      
      Case c_TipoResumenFV
        m_tipo_resumen_fv = Val(gDB.ValField(rs.fields, cscCfgValor))
        
    End Select
    rs.MoveNext
  Wend

  Load = True
End Function

Private Sub pEdit()
  On Error GoTo ControlError
  
  Set m_ObjAbm = New cABMGeneric
  
  If Not SecurityCanAccess(csPreConRenumerarAsientos) Then Exit Sub

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
    
    With .Add(Nothing, cscEmpId)
      .PropertyType = cspHelp
      .Table = csEmpresa
      .Name = LENGGetText(1114, vbNullString)
      .Key = K_EMP_ID
      .Left = 1700
      .LeftLabel = -1400
      .Value = m_empresa
      .HelpId = m_emp_id
    End With
    
    Dim oProp As cABMProperty
    Dim iProp As cIABMProperty
    Set iProp = .Add(Nothing, cscCicoId)
    Set oProp = iProp
    With iProp
      .PropertyType = cspHelp
      .Table = csCircuitoContable
      oProp.HelpType = csTree
      .Name = LENGGetText(1073, vbNullString)
      .LeftLabel = -1400
      .Key = K_CICO_ID
      .Value = m_circuito
      .HelpId = m_cico_id
    End With
    
    With .Add(Nothing, cscEjcId)
      .PropertyType = cspHelp
      .Table = csEjercicioContable
      .Name = LNGGetText(1971, vbNullString)  'Ejercicio
      .Key = K_EJC_ID
      .LeftLabel = -1400
      .HelpFilter = pGetEjcFilter()
      .Value = m_ejercicio
      .HelpId = m_ejc_id
    End With
    
    With .Add(Nothing, c_TipoResumenFC)
      .PropertyType = cspList
      .Left = 2800
      .Width = 3000
      .LeftLabel = -2500
      .Name = LNGGetText(1972, vbNullString)  'Tipo de Resumen de Compras
      .Key = K_TIPO_RESUMEN_FC
      .TopToPrevious = 880
      With .List
        With .Add(Nothing)
          .ID = csE_LibroDiarioTipoResumen.csELDTR_SinResumir
          .Value = "Sin Resumir"
        End With
        With .Add(Nothing)
          .ID = csE_LibroDiarioTipoResumen.csELDTR_Semanal
          .Value = "Semanal"
        End With
        With .Add(Nothing)
          .ID = csE_LibroDiarioTipoResumen.csELDTR_Mensual
          .Value = "Mensual"
        End With
      End With
      .ListWhoSetItem = csListItemData
      .ListItemData = m_tipo_resumen_fc
    End With
    
    With .Add(Nothing, c_TipoResumenFV)
      .PropertyType = cspList
      .Left = 2800
      .Width = 3000
      .LeftLabel = -2500
      .Name = LNGGetText(1973, vbNullString)  'Tipo de Resumen de Ventas
      .Key = K_TIPO_RESUMEN_FV
      With .List
        With .Add(Nothing)
          .ID = csE_LibroDiarioTipoResumen.csELDTR_SinResumir
          .Value = "Sin Resumir"
        End With
        With .Add(Nothing)
          .ID = csE_LibroDiarioTipoResumen.csELDTR_Semanal
          .Value = "Semanal"
        End With
        With .Add(Nothing)
          .ID = csE_LibroDiarioTipoResumen.csELDTR_Mensual
          .Value = "Mensual"
        End With
      End With
      .ListWhoSetItem = csListItemData
      .ListItemData = m_tipo_resumen_fv
    End With
    
  End With
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

' funciones friend
' funciones privadas

Private Function pRenumerar() As Boolean
  On Error GoTo ControlError
  
  Dim sqlstmt           As String
  Dim oldCommandTimeout As Long
  
  oldCommandTimeout = gDB.CommandTimeout
  gDB.CommandTimeout = 2400
  
  sqlstmt = "sp_DocAsientosRenumerar " _
                 & pGetEjcId() & _
                 "," & gDB.sqlString(pGetCicoId())

  If Not gDB.Execute(sqlstmt) Then Exit Function
  
  pRenumerar = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "pRenumerar", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  gDB.CommandTimeout = oldCommandTimeout
End Function

Private Function pGetEjcFilter() As String
  With m_ObjAbm.Properties
    pGetEjcFilter = "emp_id = " & .Item(cscEmpId).HelpId & _
                    " and (cico_id = " & .Item(cscCicoId).HelpId & _
                          " or cico_id is null)"
  End With
End Function

Private Function pGetEjcId() As Long
  pGetEjcId = m_ObjAbm.Properties.Item(cscEjcId).HelpId
End Function

Private Function pGetCicoId() As String
  pGetCicoId = m_ObjAbm.Properties.Item(cscCicoId).HelpValueProcess
End Function

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

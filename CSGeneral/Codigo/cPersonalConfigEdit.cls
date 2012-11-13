VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cPersonalConfig"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIABMClient
Implements CSMenu.cIMenuClient
'--------------------------------------------------------------------------------
' cPersonalConfigEdit
' 07-09-2008

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cPersonalConfigEdit"

Private Const c_GrabarAsientoLiquidacion = "Liquidacion-Grabar Asiento"

Private Const K_CARGA_HORARIO_1_CCOS = 1
Private Const K_CARGA_HORARIO_N_CCOS = 2
Private Const K_GRABAR_ASIENTO_LIQUIDACION = 3

Private Enum csE_CargaHorarioTipo
  csEUnCentroCostoXPeriodo = 1
  csEVariosCentroCostoXPeriodo = 2
End Enum

Private Const c_GrupoGeneral = "Personal-General"
Private Const c_CargaHorariaTipo = "Carga Horaria Tipo"

Private Const c_UnCentroCostoXPeriodo = "1ccosXPeriodo"
Private Const c_NCentroCostoXPeriodo = "NccosXPeriodo"

' estructuras
' Seudo - Variables
Private c_ErrorSave                 As String

' variables privadas
Private m_CargaHorariaTipo          As csE_CargaHorarioTipo
Private m_GrabarAsientoLiquidacion  As Boolean

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
  cIABMClient_PropertyChange = True
End Function

Private Function cIABMClient_Save() As Boolean
  Dim IProperty As cIABMProperty
  Dim IsNew     As Boolean
  Dim register  As cRegister
  Dim Value     As csE_CargaHorarioTipo
  
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
        Case K_CARGA_HORARIO_1_CCOS
          If Val(.Value) Then Value = csE_CargaHorarioTipo.csEUnCentroCostoXPeriodo
          
        Case K_CARGA_HORARIO_N_CCOS
          If Val(.Value) Then Value = csE_CargaHorarioTipo.csEVariosCentroCostoXPeriodo

        Case K_GRABAR_ASIENTO_LIQUIDACION
          With register
          
            .Fields.Clear
            
            .filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                              " and cfg_aspecto = " & gDB.sqlString(c_GrabarAsientoLiquidacion)
            
            If Not .Exists(gDB, IsNew) Then Exit Function
            IsNew = Not IsNew
            
            With .Fields
              .Add2 cscCfgGrupo, c_GrupoGeneral, csText
              .Add2 cscCfgAspecto, c_GrabarAsientoLiquidacion, csText
              .Add2 cscCfgValor, Val(IProperty.Value), csText
            End With
            
            If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                   c_ErrorSave) Then Exit Function

          End With
          
      End Select
    End With
  Next
  
  With register
    .Fields.Clear
    
    .filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                      " and cfg_aspecto = " & gDB.sqlString(c_CargaHorariaTipo)
    
    If Not .Exists(gDB, IsNew) Then Exit Function
    IsNew = Not IsNew
    
    With .Fields
      .Add2 cscCfgGrupo, c_GrupoGeneral, csText
      .Add2 cscCfgAspecto, c_CargaHorariaTipo, csText
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
  
  m_Host.Server.AddMenu C_MenuManejoPersonal, csMenuConfigMPersonal, C_MenuConfig, 0, True, False, False, False, True, Nothing
  m_Host.Server.AddMenu C_MenuSueldos, csMenuConfigSueldos, C_MenuManejoPersonal, 0, True, False, False, False, True, Nothing
  m_Host.Server.AddMenu LNGGetText(2431, vbNullString), csPreGModifyConfigPersonal, C_MenuSueldos, 0, True, False, False, False, False, Me
                        'Gen&eral
  m_Host.Server.AddMenu vbNullString, csPreGModifyConfigPersonal * -1, C_MenuSueldos, 0, True, True, False, False, False, Nothing

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

  m_CargaHorariaTipo = csEUnCentroCostoXPeriodo
  m_GrabarAsientoLiquidacion = False
  
  While Not rs.EOF
    Select Case gDB.ValField(rs.Fields, cscCfgAspecto)
    
      Case c_CargaHorariaTipo
        m_CargaHorariaTipo = gDB.ValField(rs.Fields, cscCfgValor)
      Case c_GrabarAsientoLiquidacion
        m_GrabarAsientoLiquidacion = Val(gDB.ValField(rs.Fields, cscCfgValor))
    
    End Select
    rs.MoveNext
  Wend

  Load = True
End Function

Private Sub pEdit()
  On Error GoTo ControlError
  
  Set m_ObjAbm = New cABMGeneric
  
  If Not SecurityCanAccess(csPreGModifyConfigPersonal) Then Exit Sub

  If Not Load() Then Exit Sub
  
  If Not LoadCollection() Then Exit Sub
  
  m_Editing = True
  
  Exit Sub
ControlError:
  MngError Err, "pEdit", C_Module, vbNullString
End Sub

Private Function LoadCollection() As Boolean
  Dim AbmObj  As cABMGeneric
  
  m_ObjAbm.Properties.Clear
  
  Set AbmObj = m_ObjAbm
  AbmObj.MinHeight = 6500

  With m_ObjAbm.Properties
  
    With .Add(Nothing, c_GrabarAsientoLiquidacion)
      .PropertyType = cspCheck
      .Width = 3000
      .Left = 4450
      .LeftLabel = -4000
      .Name = LNGGetText(4614, vbNullString)  'Grabar asiento al grabar la Liquidación de Haberes
      .Key = K_GRABAR_ASIENTO_LIQUIDACION
      .Value = m_GrabarAsientoLiquidacion
    End With
  
    With .Add(Nothing, c_UnCentroCostoXPeriodo)
      .PropertyType = cspOption
      .OptionGroup = 0
      .Width = 3320
      .Name = LNGGetText(4517, vbNullString) ' Un centro de costo por periodo
      .Value = CInt(m_CargaHorariaTipo = csEUnCentroCostoXPeriodo)
      .Key = K_CARGA_HORARIO_1_CCOS
      .TopFrame = 1400
    End With
  
    With .Add(Nothing, c_NCentroCostoXPeriodo)
      .PropertyType = cspOption
      .OptionGroup = 0
      .Width = 3320
      .Name = LNGGetText(4516, vbNullString) ' Varios centros de costo por periodo
      .Value = CInt(m_CargaHorariaTipo = csEVariosCentroCostoXPeriodo)
      .Key = K_CARGA_HORARIO_N_CCOS
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


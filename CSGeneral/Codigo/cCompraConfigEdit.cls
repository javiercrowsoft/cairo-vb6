VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cCompraConfig"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIABMClient
Implements CSMenu.cIMenuClient
'--------------------------------------------------------------------------------
' cCompraConfig
' 09-04-2004

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cCompraConfig"

Private Const K_CUE_ID_DESCUENTO = 1
Private Const K_GRABAR_ASIENTO = 2
Private Const K_EXIGIR_CENTROCOSTO = 3

Private Const c_GrupoGeneral = "Compras-General"
Private Const c_CueIdDescGlobal = "Cuenta Descuento Global"
Private Const c_GrabarAsiento = "Grabar Asiento"
Private Const c_ExigirCentroCosto = "Exigir Centro Costo"

' estructuras
' Seudo - Variables
Private c_ErrorSave                   As String
' variables privadas
Private m_cue_id_descGlobal           As Long
Private m_CuentaDescGlobal            As String
Private m_GrabarAsiento               As Boolean
Private m_ExigirCentroCosto           As Boolean

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
        Case K_CUE_ID_DESCUENTO
          .Fields.Clear
          
          .filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                    " and cfg_aspecto = " & gDB.sqlString(c_CueIdDescGlobal)
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .Fields
            .Add2 cscCfgGrupo, c_GrupoGeneral, csText
            .Add2 cscCfgAspecto, c_CueIdDescGlobal, csText
            .Add2 cscCfgValor, IProperty.HelpId, csText
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
        Case K_GRABAR_ASIENTO
          .Fields.Clear
          
          .filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                    " and cfg_aspecto = " & gDB.sqlString(c_GrabarAsiento)
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .Fields
            .Add2 cscCfgGrupo, c_GrupoGeneral, csText
            .Add2 cscCfgAspecto, c_GrabarAsiento, csText
            .Add2 cscCfgValor, Val(IProperty.Value), csText
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
        
        Case K_EXIGIR_CENTROCOSTO
          .Fields.Clear
          
          .filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                    " and cfg_aspecto = " & gDB.sqlString(c_ExigirCentroCosto)
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .Fields
            .Add2 cscCfgGrupo, c_GrupoGeneral, csText
            .Add2 cscCfgAspecto, c_ExigirCentroCosto, csText
            .Add2 cscCfgValor, IProperty.Value, csText
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
  cIABMClient_Title = LNGGetText(2862, vbNullString) 'Configuración General
End Property

Private Function cIABMClient_Validate() As Boolean

  Dim IProperty As cIABMProperty

  CSKernelClient2.Title = LNGGetText(2862, vbNullString) 'Configuración General

  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_CUE_ID_DESCUENTO
          If .HelpId = csNO_ID Then
            MsgWarning LNGGetText(3093, vbNullString) 'Debe indicar una Cuenta para descuentos
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
  Dim str_1381  As String
  
  str_1381 = LNGGetText(1381, vbNullString) '&Compras
  Set m_Host = Host
  
  m_Host.Server.AddMenu str_1381, csMenuConfigCompras, C_MenuConfig, 0, True, False, False, False, True, Nothing
  m_Host.Server.AddMenu LNGGetText(2431, vbNullString), csPreGModifyConfigCompras, str_1381, 0, True, False, False, False, False, Me
                        'Gen&eral
  m_Host.Server.AddMenu "", csPreGModifyConfigCompras * -1, str_1381, 0, True, True, False, False, False, Nothing

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

  m_cue_id_descGlobal = csNO_ID
  m_CuentaDescGlobal = vbNullString
  m_GrabarAsiento = False
  m_ExigirCentroCosto = False
  
  While Not rs.EOF
    Select Case gDB.ValField(rs.Fields, cscCfgAspecto)
      Case c_CueIdDescGlobal
        m_cue_id_descGlobal = Val(gDB.ValField(rs.Fields, cscCfgValor))
        If Not gDB.GetData(csTCuenta, cscCueId, m_cue_id_descGlobal, cscCueNombre, m_CuentaDescGlobal) Then Exit Function
      Case c_GrabarAsiento
        m_GrabarAsiento = Val(gDB.ValField(rs.Fields, cscCfgValor))
      Case c_ExigirCentroCosto
        m_ExigirCentroCosto = gDB.ValField(rs.Fields, cscCfgValor)
    End Select
    rs.MoveNext
  Wend

  Load = True
End Function

Private Sub pEdit()
  On Error GoTo ControlError
  
  Set m_ObjAbm = New cABMGeneric
  
  If Not SecurityCanAccess(csPreGModifyConfigCompras) Then Exit Sub

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
  
    With .Add(Nothing, c_CueIdDescGlobal)
      .PropertyType = cspHelp
      .Table = csCuenta
      .Left = 3200
      .Width = 3500
      .LeftLabel = -2900
      .Name = LNGGetText(3094, vbNullString) 'Cuenta de descuento global
      .Key = K_CUE_ID_DESCUENTO
      .HelpId = m_cue_id_descGlobal
      .Value = m_CuentaDescGlobal
    End With
  
    With .Add(Nothing, c_GrabarAsiento)
      .PropertyType = cspCheck
      .Left = 3200
      .LeftLabel = -2900
      .Name = LNGGetText(3095, vbNullString) 'Grabar asiento al grabar la Factura
      .Key = K_GRABAR_ASIENTO
      .Value = m_GrabarAsiento
    End With
  
    With .Add(Nothing, c_ExigirCentroCosto)
      .PropertyType = cspCheck
      .Left = 3200
      .LeftLabel = -2900
      .Name = c_ExigirCentroCosto
      .Value = CInt(m_ExigirCentroCosto)
      .Key = K_EXIGIR_CENTROCOSTO
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

VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cExportConfig"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIABMClient
Implements CSMenu.cIMenuClient
'--------------------------------------------------------------------------------
' cExportConfig
' 16-10-2003

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cExportConfig"

Private Const K_HAVE_PRICE_IN_PACKING = 1
Private Const K_HAVE_SOURCE_DEST_IN_PACKING = 2
Private Const K_HAVE_SHIP_IN_PACKING = 3

Private Const c_GrupoExport = "Export-General"
Private Const c_EditPricePk = "Packing List - lleva precio"
Private Const c_SourceDestPk = "Packing List - lleva origen y destino"
Private Const c_ShipPk = "Packing List - lleva barco / vuelo"

' pseudo-constantes
Private c_ErrorSave As String

' estructuras
' variables privadas
Private m_EditPricePk                 As Boolean
Private m_SourceDestPk                As Boolean
Private m_ShipPk                      As Boolean

Private m_Editing           As Boolean
Private m_Host              As CSMenu.cIMenuHost
Private m_ObjAbm            As cIABMGeneric
' eventos
' propiedades publicas
Public Property Get EditPricePk() As Boolean
  EditPricePk = m_EditPricePk
End Property

Public Property Get SourceDestPk() As Boolean
  SourceDestPk = m_SourceDestPk
End Property

Public Property Get ShipPk() As Boolean
  ShipPk = m_ShipPk
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
  
  Set register = New cRegister
  
  register.Table = csTConfiguracion
  register.Fields.HaveLastUpdate = True
  register.Fields.HaveWhoModify = True
  register.UtilizaIdentity = True
  
  ' Esto es para que el codigo en cDataBase no
  ' interprete que es un registro nuevo
  register.ID = -1
  
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        
        Case K_HAVE_PRICE_IN_PACKING
          register.Fields.Clear
          
          register.Filter = "cfg_grupo = " & gDB.sqlString(c_GrupoExport) & _
                            " and cfg_aspecto = " & gDB.sqlString(c_EditPricePk)
          
          If Not register.Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          register.Fields.Add2 cscCfgGrupo, c_GrupoExport, csText
          register.Fields.Add2 cscCfgAspecto, c_EditPricePk, csText
          register.Fields.Add2 cscCfgValor, .Value, csText
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
        
        Case K_HAVE_SHIP_IN_PACKING
          register.Fields.Clear
          
          register.Filter = "cfg_grupo = " & gDB.sqlString(c_GrupoExport) & _
                            " and cfg_aspecto = " & gDB.sqlString(c_ShipPk)
          
          If Not register.Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          register.Fields.Add2 cscCfgGrupo, c_GrupoExport, csText
          register.Fields.Add2 cscCfgAspecto, c_ShipPk, csText
          register.Fields.Add2 cscCfgValor, .Value, csText
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
        
        Case K_HAVE_SOURCE_DEST_IN_PACKING
          register.Fields.Clear
          
          register.Filter = "cfg_grupo = " & gDB.sqlString(c_GrupoExport) & _
                            " and cfg_aspecto = " & gDB.sqlString(c_SourceDestPk)
          
          If Not register.Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          register.Fields.Add2 cscCfgGrupo, c_GrupoExport, csText
          register.Fields.Add2 cscCfgAspecto, c_SourceDestPk, csText
          register.Fields.Add2 cscCfgValor, .Value, csText
          
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
  cIABMClient_Title = "Configuración General"
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
  Dim str_2418 As String
  
  str_2418 = LNGGetText(2418, vbNullString)   '&Exportación
  Set m_Host = Host
                                                                  'Co&nfiguración
  m_Host.Server.AddMenu str_2418, csMenuExportacionConfig, LNGGetText(1028, vbNullString), 0, True, False, True, False, True, Nothing
                        'Gen&eral
  m_Host.Server.AddMenu LNGGetText(2431, vbNullString), csPreGModifyConfigExport, str_2418, 0, True, False, False, False, False, Me
                        
  m_Host.Server.AddMenu vbNullString, csPreGModifyConfigExport * -1, str_2418, 0, True, True, False, False, False, Nothing

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

Public Function Load() As Boolean
  Dim sqlstmt As String

  sqlstmt = "select * from configuracion where cfg_grupo = " & gDB.sqlString(c_GrupoExport)

  Dim rs As Recordset

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  m_EditPricePk = False
  m_SourceDestPk = False
  m_ShipPk = False
  
  While Not rs.EOF
    Select Case gDB.ValField(rs.Fields, cscCfgAspecto)
      Case c_EditPricePk
        m_EditPricePk = Val(gDB.ValField(rs.Fields, cscCfgValor))
      Case c_ShipPk
        m_ShipPk = Val(gDB.ValField(rs.Fields, cscCfgValor))
      Case c_SourceDestPk
        m_SourceDestPk = Val(gDB.ValField(rs.Fields, cscCfgValor))
    End Select
    rs.MoveNext
  Wend

  Load = True
End Function

Private Sub pEdit()
  On Error GoTo ControlError
  
  Set m_ObjAbm = New cABMGeneric
  
  If Not SecurityCanAccess(csPreGModifyConfigExport) Then Exit Sub

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
  
    With .Add(Nothing, c_EditPricePk)
      .PropertyType = cspCheck
      .Name = LNGGetText(2432, vbNullString) 'Lleva precio en Packing List
      .Key = K_HAVE_PRICE_IN_PACKING
      .Left = 4000
      .LeftLabel = -3000
      .Value = m_EditPricePk
    End With
    
    With .Add(Nothing, c_ShipPk)
      .PropertyType = cspCheck
      .Name = LNGGetText(2433, vbNullString) 'Lleva barco en Packing List
      .Key = K_HAVE_SHIP_IN_PACKING
      .LeftLabel = -3000
      .Value = m_ShipPk
    End With
    
    With .Add(Nothing, c_SourceDestPk)
      .PropertyType = cspCheck
      .Name = LNGGetText(2434, vbNullString) 'Lleva Origen y Destino en Packing List
      .Key = K_HAVE_SOURCE_DEST_IN_PACKING
      .LeftLabel = -3000
      .Value = m_SourceDestPk
    End With
  End With
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

' funciones friend
' funciones privadas
' construccion - destruccion
Private Sub Class_Initialize()
  c_ErrorSave = LNGGetText(2435, vbNullString) 'Error al grabar la Configuración General de ComEx
End Sub

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



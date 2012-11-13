VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cTicketConfig"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIABMClient
Implements CSMenu.cIMenuClient
'--------------------------------------------------------------------------------
' cTicketConfigEdit
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
Private Const C_Module = "cTicketConfigEdit"

Private Const csMenuConfig = 2999
Private Const csProyecto = 2005

Private Const K_CONTROLA_TAREAS = 1
Private Const K_EQUIPO_PRECIO_CERO = 2
Private Const K_COPIAR_OS_SERIE2 = 3
Private Const K_COPIAR_SERIE2_PRP_NRODOC = 4
Private Const K_SHOW_SERIE23_PRP = 5
Private Const K_PROYECTO_GENERICO = 6
Private Const K_USE_AUTONUMBER = 7
Private Const K_PR_ID_SERVICIO = 8

Private Const c_GrupoGeneral = "Ticket-General"
Private Const c_ControlaTareas = "Controla Tareas"
Private Const c_EquipoPrecioCero = "Remitir Equipo Reparado con Precio en Cero"
Private Const c_CopiarOsNroDocEnSerie2 = "Copiar el Comprobante de la OS en el Campo prns_serie2"
Private Const c_CopiarPrns2EnPrpNroDoc = "Copiar el Campo Serie 2 en NroDoc del Parte Reparacion"
Private Const c_ShowSerie23Prp = "Mostrar Serie 2 y Serie 3 en Parte de Reparacion"
Private Const c_ProyectoGenerico = "Proyecto Generico"
Private Const c_UseAutoNumber = "Usar Autonumero"
Private Const c_PrIdServicio = "Articulo para Ordenes de Servicio"

' estructuras
' variables privadas
Private m_ControlaTareas              As Boolean
Private m_EquipoPrecioCero            As Boolean
Private m_CopiarOsNroDocEnSerie2      As Boolean
Private m_CopiarPrns2EnPrpNroDoc      As Boolean
Private m_ShowSerie23Prp              As Boolean
Private m_proy_id                     As Long
Private m_proyecto                    As String
Private m_pr_id                       As Long
Private m_producto                    As String
Private m_UseAutoNumber               As Boolean

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
        Case K_CONTROLA_TAREAS
          .Fields.Clear
          
          .filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                    " and cfg_aspecto = " & gDB.sqlString(c_ControlaTareas)
          
          If Not register.Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .Fields
            .Add2 cscCfgGrupo, c_GrupoGeneral, csText
            .Add2 cscCfgAspecto, c_ControlaTareas, csText
            .Add2 cscCfgValor, Val(IProperty.Value), csText
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 "Error al grabar la configuración general") Then Exit Function
        
        Case K_EQUIPO_PRECIO_CERO
          .Fields.Clear
          
          .filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                    " and cfg_aspecto = " & gDB.sqlString(c_EquipoPrecioCero)
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .Fields
            .Add2 cscCfgGrupo, c_GrupoGeneral, csText
            .Add2 cscCfgAspecto, c_EquipoPrecioCero, csText
            .Add2 cscCfgValor, Val(IProperty.Value), csText
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 "Error al grabar la configuración general") Then Exit Function
        
        Case K_COPIAR_OS_SERIE2
          .Fields.Clear
          
          .filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                    " and cfg_aspecto = " & gDB.sqlString(c_CopiarOsNroDocEnSerie2)
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .Fields
            .Add2 cscCfgGrupo, c_GrupoGeneral, csText
            .Add2 cscCfgAspecto, c_CopiarOsNroDocEnSerie2, csText
            .Add2 cscCfgValor, Val(IProperty.Value), csText
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 "Error al grabar la configuración general") Then Exit Function
      
        Case K_COPIAR_SERIE2_PRP_NRODOC
          .Fields.Clear
          
          .filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                    " and cfg_aspecto = " & gDB.sqlString(c_CopiarPrns2EnPrpNroDoc)
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .Fields
            .Add2 cscCfgGrupo, c_GrupoGeneral, csText
            .Add2 cscCfgAspecto, c_CopiarPrns2EnPrpNroDoc, csText
            .Add2 cscCfgValor, Val(IProperty.Value), csText
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 "Error al grabar la configuración general") Then Exit Function
      
        Case K_SHOW_SERIE23_PRP
          .Fields.Clear
          
          .filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                    " and cfg_aspecto = " & gDB.sqlString(c_ShowSerie23Prp)
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .Fields
            .Add2 cscCfgGrupo, c_GrupoGeneral, csText
            .Add2 cscCfgAspecto, c_ShowSerie23Prp, csText
            .Add2 cscCfgValor, Val(IProperty.Value), csText
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 "Error al grabar la configuración general") Then Exit Function
      
        Case K_PROYECTO_GENERICO
          .Fields.Clear
          
          .filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                    " and cfg_aspecto = " & gDB.sqlString(c_ProyectoGenerico)
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .Fields
            .Add2 cscCfgGrupo, c_GrupoGeneral, csText
            .Add2 cscCfgAspecto, c_ProyectoGenerico, csText
            .Add2 cscCfgValor, IProperty.HelpId, csText
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 "Error al grabar la configuración general") Then Exit Function
      
        Case K_PR_ID_SERVICIO
          .Fields.Clear
          
          .filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                    " and cfg_aspecto = " & gDB.sqlString(c_PrIdServicio)
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .Fields
            .Add2 cscCfgGrupo, c_GrupoGeneral, csText
            .Add2 cscCfgAspecto, c_PrIdServicio, csText
            .Add2 cscCfgValor, IProperty.HelpId, csText
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 "Error al grabar la configuración general") Then Exit Function
      
        Case K_USE_AUTONUMBER
          .Fields.Clear
          
          .filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                    " and cfg_aspecto = " & gDB.sqlString(c_UseAutoNumber)
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .Fields
            .Add2 cscCfgGrupo, c_GrupoGeneral, csText
            .Add2 cscCfgAspecto, c_UseAutoNumber, csText
            .Add2 cscCfgValor, Val(IProperty.Value), csText
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 "Error al grabar la configuración general") Then Exit Function
      
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

  Set m_Host = Host
  m_Host.Server.AddMenu "&Servicios", csMenuConfig, C_MenuConfig, 0, True, False, False, False, True, Nothing
  m_Host.Server.AddMenu "Gen&eral", csPreGModifyConfigTicket, "&Servicios", 0, True, False, False, False, False, Me
  m_Host.Server.AddMenu "", csPreGModifyConfigTicket * -1, "&Servicios", 0, True, True, False, False, False, Nothing

  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, C_MenuClientInit, C_Module, ""
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

  m_ControlaTareas = False
  m_EquipoPrecioCero = False
  m_CopiarOsNroDocEnSerie2 = False
  m_CopiarPrns2EnPrpNroDoc = False
  m_ShowSerie23Prp = False
  m_UseAutoNumber = True
  
  While Not rs.EOF
    Select Case gDB.ValField(rs.Fields, cscCfgAspecto)
      Case c_ControlaTareas
        m_ControlaTareas = Val(gDB.ValField(rs.Fields, cscCfgValor))
      Case c_EquipoPrecioCero
        m_EquipoPrecioCero = Val(gDB.ValField(rs.Fields, cscCfgValor))
      Case c_CopiarOsNroDocEnSerie2
        m_CopiarOsNroDocEnSerie2 = Val(gDB.ValField(rs.Fields, cscCfgValor))
      Case c_CopiarPrns2EnPrpNroDoc
        m_CopiarPrns2EnPrpNroDoc = Val(gDB.ValField(rs.Fields, cscCfgValor))
      Case c_ShowSerie23Prp
        m_ShowSerie23Prp = Val(gDB.ValField(rs.Fields, cscCfgValor))
      Case c_UseAutoNumber
        m_UseAutoNumber = Val(gDB.ValField(rs.Fields, cscCfgValor))
      Case c_ProyectoGenerico
        m_proy_id = Val(gDB.ValField(rs.Fields, cscCfgValor))
        If Not gDB.GetData(csTProyecto, cscProyId, m_proy_id, cscProyNombre, m_proyecto) Then Exit Function
      Case c_PrIdServicio
        m_pr_id = Val(gDB.ValField(rs.Fields, cscCfgValor))
        If Not gDB.GetData(csTProducto, cscPrId, m_pr_id, cscPrNombreventa, m_producto) Then Exit Function
      End Select
    rs.MoveNext
  Wend

  Load = True
End Function

Private Sub pEdit()
  On Error GoTo ControlError
  
  Set m_ObjAbm = New cABMGeneric
  
  If Not SecurityCanAccess(csPreGModifyConfigTicket) Then Exit Sub

  If Not Load() Then Exit Sub
  
  If Not LoadCollection() Then Exit Sub
  
  m_Editing = True
  
  Exit Sub
ControlError:
  MngError Err, "pEdit", C_Module, ""
End Sub

Private Function LoadCollection() As Boolean

  m_ObjAbm.Properties.Clear

  With m_ObjAbm.Properties
    With .Add(Nothing, c_ControlaTareas)
      .PropertyType = cspCheck
      .Left = 5800
      .Width = 3000
      .LeftLabel = -5000
      .Name = LNGGetText(3588, vbNullString) 'Controla Tareas
      .Key = K_CONTROLA_TAREAS
      .Value = CInt(m_ControlaTareas)
    End With
  
    With .Add(Nothing, c_EquipoPrecioCero)
      .PropertyType = cspCheck
      .Left = 5800
      .Width = 3000
      .LeftLabel = -5000
      .Name = LNGGetText(3589, vbNullString) 'Remitir Equipo Reparado con Precio en Cero
      .Key = K_EQUIPO_PRECIO_CERO
      .Value = CInt(m_EquipoPrecioCero)
    End With
    
    With .Add(Nothing, c_CopiarOsNroDocEnSerie2)
      .PropertyType = cspCheck
      .Left = 5800
      .Width = 3000
      .LeftLabel = -5000
      .Name = LNGGetText(3590, vbNullString) 'Copiar el Comprobante de la OS en el Campo prns_serie2
      .Key = K_COPIAR_OS_SERIE2
      .Value = CInt(m_CopiarOsNroDocEnSerie2)
    End With
    
    With .Add(Nothing, c_CopiarPrns2EnPrpNroDoc)
      .PropertyType = cspCheck
      .Left = 5800
      .Width = 3000
      .LeftLabel = -5000
      .Name = LNGGetText(3591, vbNullString) 'Copiar el Campo Serie 2 en el Comprobante del Parte de reparacion
      .Key = K_COPIAR_SERIE2_PRP_NRODOC
      .Value = CInt(m_CopiarPrns2EnPrpNroDoc)
    End With
    
    With .Add(Nothing, c_ShowSerie23Prp)
      .PropertyType = cspCheck
      .Left = 5800
      .Width = 3000
      .LeftLabel = -5000
      .Name = LNGGetText(3592, vbNullString) 'Mostrar Serie 2 y Serie 3 en Parte de Reparacion
      .Key = K_SHOW_SERIE23_PRP
      .Value = CInt(m_ShowSerie23Prp)
    End With
    
    With .Add(Nothing, c_UseAutoNumber)
      .PropertyType = cspCheck
      .Left = 5800
      .Width = 3000
      .LeftLabel = -5000
      .Name = LNGGetText(3593, vbNullString) 'Usar Autonumerico en orden de servicio
      .Key = K_USE_AUTONUMBER
      .Value = CInt(m_UseAutoNumber)
    End With
    
    With .Add(Nothing, c_ProyectoGenerico)
      .PropertyType = cspHelp
      .Table = csProyecto
      .Left = 5800
      .Width = 3000
      .LeftLabel = -5000
      .Name = LNGGetText(3594, vbNullString) 'Proyecto Generico
      .Key = K_PROYECTO_GENERICO
      .HelpId = m_proy_id
      .Value = m_proyecto
    End With
    
    With .Add(Nothing, c_PrIdServicio)
      .PropertyType = cspHelp
      .Table = csProductoVenta
      .Left = 5800
      .Width = 3000
      .LeftLabel = -5000
      .Name = LNGGetText(3932, vbNullString) 'Articulo para Ordenes de Servicio
      .Key = K_PR_ID_SERVICIO
      .HelpId = m_pr_id
      .Value = m_producto
    End With
    
  End With
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function
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


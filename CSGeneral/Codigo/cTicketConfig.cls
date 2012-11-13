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

'--------------------------------------------------------------------------------
' cTicketConfig
' 13-03-2007

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cTicketConfig"

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
Private m_UseAutoNumber               As Boolean
Private m_pr_id                       As Long
Private m_producto                    As String

' eventos
' propiedades publicas
Public Property Get ControlaTareas() As Boolean
   ControlaTareas = m_ControlaTareas
End Property

Public Property Get EquipoPrecioCero() As Boolean
   EquipoPrecioCero = m_EquipoPrecioCero
End Property

Public Property Get CopiarOsNroDocEnSerie2() As Boolean
   CopiarOsNroDocEnSerie2 = m_CopiarOsNroDocEnSerie2
End Property

Public Property Get CopiarPrns2EnPrpNroDoc() As Boolean
   CopiarPrns2EnPrpNroDoc = m_CopiarPrns2EnPrpNroDoc
End Property

Public Property Get ShowSerie23Prp() As Boolean
   ShowSerie23Prp = m_ShowSerie23Prp
End Property

Public Property Get Proy_id() As Long
   Proy_id = m_proy_id
End Property

Public Property Get Proyecto() As String
   Proyecto = m_proyecto
End Property

Public Property Get UseAutoNumber() As String
   UseAutoNumber = m_UseAutoNumber
End Property

Public Property Get PrIdServicio() As Long
   PrIdServicio = m_pr_id
End Property

Public Property Get PrServicio() As String
   PrServicio = m_producto
End Property

' propiedades friend
' propiedades privadas
' funciones publicas
Public Function Load() As Boolean
  Dim sqlstmt As String

  sqlstmt = "select * from configuracion where cfg_grupo = " & gDB.sqlString(c_GrupoGeneral)

  Dim rs As Recordset

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  m_ControlaTareas = False
  m_EquipoPrecioCero = False
  m_CopiarOsNroDocEnSerie2 = False
  m_CopiarPrns2EnPrpNroDoc = False
  m_ShowSerie23Prp = False
  
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
' funciones friend
' funciones privadas
' construccion - destruccion

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

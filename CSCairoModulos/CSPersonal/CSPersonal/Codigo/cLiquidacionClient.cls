VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cLiquidacionClient"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cLiquidacionClient
' 12-10-2008

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cLiquidacionClient"
' estructuras
' variables privadas
Private m_rsLiqItem     As ADODB.Recordset
Private m_Asistencias   As Collection
Private m_Variables     As Collection

Private m_liqcTMP_id    As Long
Private m_liq_id        As Long
Private m_liqi_id       As Long
Private m_liqfi_id      As Long
Private m_liqf_id       As Long

' eventos
' propiedades publicas
Public Property Get em_nombre() As String
  em_nombre = m_rsLiqItem.fields.Item(cscEmNombre).Value
End Property

Public Property Get em_id() As Long
  em_id = m_rsLiqItem.fields.Item(cscEmId).Value
End Property

Public Property Get Asistencias() As Collection
  Set Asistencias = m_Asistencias
End Property

Public Property Get liq_id() As Long
  liq_id = m_liq_id
End Property

Public Property Get liqf_id() As Long
  liqf_id = m_liqf_id
End Property

' propiedades friend
Friend Property Let liqfi_id(ByVal rhs As Long)
  m_liqfi_id = rhs
End Property

Friend Property Let liqf_id(ByVal rhs As Long)
  m_liqf_id = rhs
End Property

' propiedades privadas
' funciones publicas
Public Function init_vars() As Boolean
  Set m_Variables = New Collection
  init_vars = True
End Function

Public Sub def_var(ByVal VarName As String)
  m_Variables.Add Empty, VarName
End Sub

Public Sub set_var(ByVal VarName As String, ByVal VarValue As Variant)
  m_Variables.Item(VarName) = VarValue
End Sub

Public Function get_var(ByVal VarName As String) As Variant
  get_var = m_Variables.Item(VarName)
End Function

Public Function rtn(ByVal Value As Double, _
                    Optional ByVal Units As Double = 1) As Boolean
  
  Dim sqlstmt As String
    
  sqlstmt = "sp_LiquidacionItemCodigoTMPSave " & _
                 m_liqcTMP_id & "," & _
                 m_liqi_id & "," & _
                 m_liqfi_id & "," & _
                 gDB.sqlNumber(Value) & "," & _
                 gDB.sqlNumber(Units)

  If Not gDB.Execute(sqlstmt) Then
    Err.Raise c_ErrorInRtn
  End If
  
  rtn = True
End Function

Public Function get_tipo_liquidacion(ByVal em_id As Long) As Long
  Dim tipo_liq As Long
  
  If Not gDB.GetData(csTEmpleado, cscEmId, em_id, cscEmTipoLiquidacion, tipo_liq) Then
    Err.Raise c_ErrorInRtn
  End If
  
  get_tipo_liquidacion = tipo_liq
End Function

' NOTA: Se recibe la fecha ya que debo saber cual es el importe de hora segun el convenio,
'       y estos estan vigentes en un rango de fechas.
'
'       el em_id me da la categoria.
'
Public Function get_valor_hora(ByVal em_id As Long, _
                               Optional ByVal fecha As Date = csNoDate) As Double
  Dim sqlstmt    As String
  Dim rs         As ADODB.Recordset
  
  sqlstmt = "sp_LiquidacionEmpleadoGetValorHora " & em_id & "," & gDB.sqlDate(fecha)
  
  If Not gDB.OpenRs(sqlstmt, rs) Then
    Err.Raise c_ErrorInRtn
    Exit Function
  End If
  
  If rs.EOF Then
    MsgWarning LNGGetText(4639, vbNullString, em_nombre)
                        ' No se pudo determinar el valor de hora _
                          para el empleado #1#. _
                          Verifique que en la definicion del convenio _
                          sindical al que pertence el empleado que la _
                          categoria este valorizada.
    Err.Raise c_ErrorInRtn
  End If
    
  get_valor_hora = rs.fields.Item(0).Value
End Function

Public Function get_hora_jornal_x_ccos(ByVal ccos_id As Long, _
                                       ByVal fecha As Date) As Double
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_EmpleadoPeriodoGetHorasXJornal " _
                    & ccos_id & "," _
                    & gDB.sqlDate(fecha)
                    
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  If Not rs.EOF Then
  
    get_hora_jornal_x_ccos = gDB.ValField(rs.fields, 0)
    
  End If

End Function

Public Function IIf(condition, valTrue, valFalse)
  If condition Then
    IIf = valTrue
  Else
    IIf = valFalse
  End If
End Function

Public Function existe_liquidacion_x_codigo(ByVal liq_id As Long, _
                                            ByVal liqf_id As Long, _
                                            ByVal em_id As Long, _
                                            ByVal asistencia_tipo_codigo As String, _
                                            ByVal dias As Long, _
                                            ByVal meses As Long) As Boolean
  Dim sqlstmt As String
  Dim rs As ADODB.Recordset
  
  sqlstmt = "sp_LiquidacionExistsLiquidacionXCodigo " _
                             & liq_id _
                       & "," & liqf_id _
                       & "," & em_id _
                       & "," & gDB.sqlString(asistencia_tipo_codigo) _
                       & "," & dias _
                       & "," & meses
                       
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
                       
  existe_liquidacion_x_codigo = gDB.ValField(rs.fields, 0)
End Function

' funciones friend
Friend Function Init(ByVal LiqId As Long, _
                     ByRef rsLiqItem As ADODB.Recordset, _
                     ByVal liqcTMP_id As Long) As Boolean
                     
  ' Lo primero que hay que hacer
  '
  Set m_rsLiqItem = rsLiqItem
  m_liqcTMP_id = liqcTMP_id
  m_liqi_id = rsLiqItem.fields.Item(cscLiqiId).Value
  m_liq_id = LiqId
  
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
    
  sqlstmt = "sp_LiquidacionGetEmpleadoAsistencia " _
                 & LiqId & "," & em_id
                 
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function

  Dim Asistencia As cAsistencia

  Set m_Asistencias = New Collection

  While Not rs.EOF
  
    Set Asistencia = New cAsistencia
    
    Asistencia.fecha = gDB.ValField(rs.fields, cscEmhFecha)
    Asistencia.horas = gDB.ValField(rs.fields, cscEmhHoras)
    
    Asistencia.ccos_id = gDB.ValField(rs.fields, cscCcosId)
    Asistencia.centro_costo = gDB.ValField(rs.fields, cscCcosNombre)
    Asistencia.centro_costo_codigo = gDB.ValField(rs.fields, cscCcosCodigo)
  
    Asistencia.ccos_id_padre = gDB.ValField(rs.fields, cscCcosIdPadre)
    Asistencia.centro_costo_padre = gDB.ValField(rs.fields, cscCcosNombrePadre)
    Asistencia.centro_costo_padre_codigo = gDB.ValField(rs.fields, cscCcosCodigoPadre)
  
    Asistencia.east_id = gDB.ValField(rs.fields, cscEastId)
    Asistencia.asistencia_tipo = gDB.ValField(rs.fields, cscEastNombre)
    Asistencia.asistencia_tipo_codigo = gDB.ValField(rs.fields, cscEastCodigo)
  
    m_Asistencias.Add Asistencia
    
    rs.MoveNext
  Wend
  
  Set m_Variables = New Collection

  Init = True
  
End Function
' funciones privadas
' construccion - destruccion
Private Sub Class_Terminate()
  On Error Resume Next
  Set m_rsLiqItem = Nothing
  Err.Clear
End Sub

'//////////////////////////////
'  Codigo estandar de errores
'  On Error GoTo ControlError
'
'  GoTo ExitProc
'ControlError:
'  MngError err,"", C_Module, ""
'  If Err.Number <> 0 Then Resume ExitProc
'ExitProc:
'  On Error Resume Next

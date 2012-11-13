VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cAsistencia"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cAsistencia
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
Private Const C_Module = "cAsistencia"
' estructuras
' variables privadas
Private m_fecha                         As Date
Private m_horas                         As Double
Private m_ccos_id                       As Long
Private m_centro_costo                  As String
Private m_centro_costo_codigo           As String

Private m_ccos_id_padre                 As Long
Private m_centro_costo_padre            As String
Private m_centro_costo_padre_codigo     As String

Private m_east_id                       As Long
Private m_asistencia_tipo               As String
Private m_asistencia_tipo_codigo        As String

' eventos
' propiedades publicas
Public Property Get fecha() As Date
  fecha = m_fecha
End Property

Public Property Let fecha(ByVal rhs As Date)
  m_fecha = rhs
End Property

Public Property Get dia_semana() As Long
  dia_semana = Weekday(m_fecha, vbMonday)
End Property

Public Property Get horas() As Double
  horas = m_horas
End Property

Public Property Let horas(ByVal rhs As Double)
  m_horas = rhs
End Property

Public Property Get ccos_id() As Long
  ccos_id = m_ccos_id
End Property

Public Property Let ccos_id(ByVal rhs As Long)
  m_ccos_id = rhs
End Property

Public Property Get centro_costo() As String
  centro_costo = m_centro_costo
End Property

Public Property Let centro_costo(ByVal rhs As String)
  m_centro_costo = rhs
End Property

Public Property Get centro_costo_codigo() As String
  centro_costo_codigo = m_centro_costo_codigo
End Property

Public Property Let centro_costo_codigo(ByVal rhs As String)
  m_centro_costo_codigo = rhs
End Property

Public Property Get ccos_id_padre() As Long
  ccos_id_padre = m_ccos_id_padre
End Property

Public Property Let ccos_id_padre(ByVal rhs As Long)
  m_ccos_id_padre = rhs
End Property

Public Property Get centro_costo_padre() As String
  centro_costo_padre = m_centro_costo_padre
End Property

Public Property Let centro_costo_padre(ByVal rhs As String)
  m_centro_costo_padre = rhs
End Property

Public Property Get centro_costo_padre_codigo() As String
  centro_costo_padre_codigo = m_centro_costo_padre_codigo
End Property

Public Property Let centro_costo_padre_codigo(ByVal rhs As String)
  m_centro_costo_padre_codigo = rhs
End Property

Public Property Get east_id() As Long
   east_id = m_east_id
End Property

Public Property Let east_id(ByVal rhs As Long)
   m_east_id = rhs
End Property

Public Property Get asistencia_tipo() As String
   asistencia_tipo = m_asistencia_tipo
End Property

Public Property Let asistencia_tipo(ByVal rhs As String)
   m_asistencia_tipo = rhs
End Property

Public Property Get asistencia_tipo_codigo() As String
   asistencia_tipo_codigo = m_asistencia_tipo_codigo
End Property

Public Property Let asistencia_tipo_codigo(ByVal rhs As String)
   m_asistencia_tipo_codigo = rhs
End Property

' propiedades friend
' propiedades privadas
' funciones publicas
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
'  If Err.Number <> 0 Then Resume ExitProc
'ExitProc:
'  On Error Resume Next

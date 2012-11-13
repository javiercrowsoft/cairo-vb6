VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cInformeParametro"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cInformeParametro
' 06-10-2003

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cInformeParametro"
' estructuras
' variables privadas
Private m_Id                           As Long
Private m_Nombre                       As String
Private m_Orden                        As Integer
Private m_Tipo                         As csEInfParamType
Private m_Default                      As String
Private m_Visible                      As Boolean
Private m_Sqlstmt                      As String
Private m_Inf_id                       As Long
Private m_Informe                      As String
Private m_Tbl_id                       As Long
Private m_Tabla                        As String
Private m_Creado                       As Date
Private m_Modificado                   As Date
Private m_Modifico                     As Long
Private m_Rptp_id                      As Long

' eventos
' propiedades publicas
Public Property Get Id() As Long
  Id = m_Id
End Property

Public Property Let Id(ByVal rhs As Long)
  m_Id = rhs
End Property

Public Property Get Nombre() As String
  Nombre = m_Nombre
End Property

Public Property Let Nombre(ByVal rhs As String)
  m_Nombre = rhs
End Property

Public Property Get Orden() As Integer
  Orden = m_Orden
End Property

Public Property Let Orden(ByVal rhs As Integer)
  m_Orden = rhs
End Property

Public Property Get Tipo() As csEInfParamType
  Tipo = m_Tipo
End Property

Public Property Let Tipo(ByVal rhs As csEInfParamType)
  m_Tipo = rhs
End Property

Public Property Get default() As String
  default = m_Default
End Property

Public Property Let default(ByVal rhs As String)
  m_Default = rhs
End Property

Public Property Get Visible() As Boolean
  Visible = m_Visible
End Property

Public Property Let Visible(ByVal rhs As Boolean)
  m_Visible = rhs
End Property

Public Property Get sqlstmt() As String
  sqlstmt = m_Sqlstmt
End Property

Public Property Let sqlstmt(ByVal rhs As String)
  m_Sqlstmt = rhs
End Property

Public Property Get inf_id() As Long
  inf_id = m_Inf_id
End Property

Public Property Let inf_id(ByVal rhs As Long)
  m_Inf_id = rhs
End Property

Public Property Get Informe() As String
  Informe = m_Informe
End Property

Public Property Let Informe(ByVal rhs As String)
  m_Informe = rhs
End Property

Public Property Get Tbl_id() As Long
  Tbl_id = m_Tbl_id
End Property

Public Property Let Tbl_id(ByVal rhs As Long)
  m_Tbl_id = rhs
End Property

Public Property Get Tabla() As String
  Tabla = m_Tabla
End Property

Public Property Let Tabla(ByVal rhs As String)
  m_Tabla = rhs
End Property

Public Property Get Creado() As Date
  Creado = m_Creado
End Property

Public Property Let Creado(ByVal rhs As Date)
  m_Creado = rhs
End Property

Public Property Get Modificado() As Date
  Modificado = m_Modificado
End Property

Public Property Let Modificado(ByVal rhs As Date)
  m_Modificado = rhs
End Property

Public Property Get Modifico() As Long
  Modifico = m_Modifico
End Property

Public Property Let Modifico(ByVal rhs As Long)
  m_Modifico = rhs
End Property

Public Property Get Rptp_id() As Long
   Rptp_id = m_Rptp_id
End Property

Public Property Let Rptp_id(ByVal rhs As Long)
   m_Rptp_id = rhs
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
'  If Err.Number Then Resume ExitProc
'ExitProc:
'  On Error Resume Next

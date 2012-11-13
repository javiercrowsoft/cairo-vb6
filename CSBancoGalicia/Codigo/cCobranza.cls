VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cCobranza"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Private m_RegistroTipo                  As String
Private m_IdCliente                     As String
Private m_Cbu                           As String
Private m_IdRegistro                    As String
Private m_Fecha1erVto                   As Date
Private m_Importe1erVto                 As Double
Private m_Fecha2doVto                   As Date
Private m_Importe2doVto                 As Double
Private m_Fecha3erVto                   As Date
Private m_Importe3erVto                 As Double
Private m_Moneda                        As Integer
Private m_Rechazo                       As String
Private m_Tipodoc                       As Integer
Private m_Nrodoc                        As Long
Private m_NewIdCliente                  As String
Private m_NewCbu                        As String
Private m_ImporteMinimo                 As Double
Private m_FechaProximoVto               As Date
Private m_IdClienteAnterior             As String
Private m_MensajeATM                    As String
Private m_Concepto                      As String
Private m_FechaCobro                    As Date
Private m_ImporteCobrado                As Double
Private m_FechaAcreditacion             As Date
Private m_Inscripcion                   As cInscripcion

Public Property Get RegistroTipo() As String
  RegistroTipo = m_RegistroTipo
End Property

Public Property Let RegistroTipo(ByVal rhs As String)
  m_RegistroTipo = rhs
End Property

Public Property Get IdCliente() As String
  IdCliente = m_IdCliente
End Property

Public Property Let IdCliente(ByVal rhs As String)
  m_IdCliente = rhs
End Property

Public Property Get Cbu() As String
  Cbu = m_Cbu
End Property

Public Property Let Cbu(ByVal rhs As String)
  m_Cbu = rhs
End Property

Public Property Get IdRegistro() As String
  IdRegistro = m_IdRegistro
End Property

Public Property Let IdRegistro(ByVal rhs As String)
  m_IdRegistro = rhs
End Property

Public Property Get Fecha1erVto() As Date
  Fecha1erVto = m_Fecha1erVto
End Property

Public Property Let Fecha1erVto(ByVal rhs As Date)
  m_Fecha1erVto = rhs
End Property

Public Property Get Importe1erVto() As Double
  Importe1erVto = m_Importe1erVto
End Property

Public Property Let Importe1erVto(ByVal rhs As Double)
  m_Importe1erVto = rhs
End Property

Public Property Get Fecha2doVto() As Date
  Fecha2doVto = m_Fecha2doVto
End Property

Public Property Let Fecha2doVto(ByVal rhs As Date)
  m_Fecha2doVto = rhs
End Property

Public Property Get Importe2doVto() As Double
  Importe2doVto = m_Importe2doVto
End Property

Public Property Let Importe2doVto(ByVal rhs As Double)
  m_Importe2doVto = rhs
End Property

Public Property Get Fecha3erVto() As Date
  Fecha3erVto = m_Fecha3erVto
End Property

Public Property Let Fecha3erVto(ByVal rhs As Date)
  m_Fecha3erVto = rhs
End Property

Public Property Get Importe3erVto() As Double
  Importe3erVto = m_Importe3erVto
End Property

Public Property Let Importe3erVto(ByVal rhs As Double)
  m_Importe3erVto = rhs
End Property

Public Property Get Moneda() As Integer
  Moneda = m_Moneda
End Property

Public Property Let Moneda(ByVal rhs As Integer)
  m_Moneda = rhs
End Property

Public Property Get Rechazo() As String
  Rechazo = m_Rechazo
End Property

Public Property Let Rechazo(ByVal rhs As String)
  m_Rechazo = rhs
End Property

Public Property Get Tipodoc() As Integer
  Tipodoc = m_Tipodoc
End Property

Public Property Let Tipodoc(ByVal rhs As Integer)
  m_Tipodoc = rhs
End Property

Public Property Get Nrodoc() As Long
  Nrodoc = m_Nrodoc
End Property

Public Property Let Nrodoc(ByVal rhs As Long)
  m_Nrodoc = rhs
End Property

Public Property Get NewIdCliente() As String
  NewIdCliente = m_NewIdCliente
End Property

Public Property Let NewIdCliente(ByVal rhs As String)
  m_NewIdCliente = rhs
End Property

Public Property Get NewCbu() As String
  NewCbu = m_NewCbu
End Property

Public Property Let NewCbu(ByVal rhs As String)
  m_NewCbu = rhs
End Property


Public Property Get ImporteMinimo() As Double
  ImporteMinimo = m_ImporteMinimo
End Property

Public Property Let ImporteMinimo(ByVal rhs As Double)
  m_ImporteMinimo = rhs
End Property

Public Property Get FechaProximoVto() As Date
  FechaProximoVto = m_FechaProximoVto
End Property

Public Property Let FechaProximoVto(ByVal rhs As Date)
  m_FechaProximoVto = rhs
End Property

Public Property Get IdClienteAnterior() As String
  IdClienteAnterior = m_IdClienteAnterior
End Property

Public Property Let IdClienteAnterior(ByVal rhs As String)
  m_IdClienteAnterior = rhs
End Property

Public Property Get MensajeATM() As String
  MensajeATM = m_MensajeATM
End Property

Public Property Let MensajeATM(ByVal rhs As String)
  m_MensajeATM = rhs
End Property

Public Property Get Concepto() As String
  Concepto = m_Concepto
End Property

Public Property Let Concepto(ByVal rhs As String)
  m_Concepto = rhs
End Property

Public Property Get FechaCobro() As Date
  FechaCobro = m_FechaCobro
End Property

Public Property Let FechaCobro(ByVal rhs As Date)
  m_FechaCobro = rhs
End Property

Public Property Get ImporteCobrado() As Double
  ImporteCobrado = m_ImporteCobrado
End Property

Public Property Let ImporteCobrado(ByVal rhs As Double)
  m_ImporteCobrado = rhs
End Property

Public Property Get FechaAcreditacion() As Date
  FechaAcreditacion = m_FechaAcreditacion
End Property

Public Property Let FechaAcreditacion(ByVal rhs As Date)
  m_FechaAcreditacion = rhs
End Property

Public Property Get Inscripcion() As cInscripcion
  Set Inscripcion = m_Inscripcion
End Property

Public Property Set Inscripcion(ByRef rhs As cInscripcion)
  Set m_Inscripcion = rhs
End Property

Private Sub Class_Initialize()
  Set m_Inscripcion = New cInscripcion
End Sub

Private Sub Class_Terminate()
  Set m_Inscripcion = Nothing
End Sub

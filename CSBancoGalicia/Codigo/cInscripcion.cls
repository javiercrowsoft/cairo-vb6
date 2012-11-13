VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cInscripcion"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Private m_insc_id                       As Long
Private m_Numero                        As String
Private m_Apellido                      As String
Private m_Nombre                        As String
Private m_Socio                         As String
Private m_SocioLASFAR                   As String
Private m_Doctipo                       As Integer
Private m_Nrodoc                        As Long
Private m_Cbu                           As String
Private m_Importe                       As Double
Private m_Fecha                         As Date

Public Property Get insc_id() As Long
  insc_id = m_insc_id
End Property

Public Property Let insc_id(ByVal rhs As Long)
  m_insc_id = rhs
End Property

Public Property Get Numero() As String
  Numero = m_Numero
End Property

Public Property Let Numero(ByVal rhs As String)
  m_Numero = rhs
End Property

Public Property Get Apellido() As String
  Apellido = m_Apellido
End Property

Public Property Let Apellido(ByVal rhs As String)
  m_Apellido = rhs
End Property

Public Property Get Nombre() As String
  Nombre = m_Nombre
End Property

Public Property Let Nombre(ByVal rhs As String)
  m_Nombre = rhs
End Property

Public Property Get Socio() As String
  Socio = m_Socio
End Property

Public Property Let Socio(ByVal rhs As String)
  m_Socio = rhs
End Property

Public Property Get SocioLASFAR() As String
  SocioLASFAR = m_SocioLASFAR
End Property

Public Property Let SocioLASFAR(ByVal rhs As String)
  m_SocioLASFAR = rhs
End Property

Public Property Get Doctipo() As Integer
  Doctipo = m_Doctipo
End Property

Public Property Let Doctipo(ByVal rhs As Integer)
  m_Doctipo = rhs
End Property

Public Property Get Nrodoc() As Long
  Nrodoc = m_Nrodoc
End Property

Public Property Let Nrodoc(ByVal rhs As Long)
  m_Nrodoc = rhs
End Property

Public Property Get Cbu() As String
  Cbu = m_Cbu
End Property

Public Property Let Cbu(ByVal rhs As String)
  m_Cbu = rhs
End Property

Public Property Get Importe() As Double
  Importe = m_Importe
End Property

Public Property Let Importe(ByVal rhs As Double)
  m_Importe = rhs
End Property

Public Property Get Fecha() As Date
  Fecha = m_Fecha
End Property

Public Property Let Fecha(ByVal rhs As Date)
  m_Fecha = rhs
End Property


VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cHeader"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Private m_RegistroTipo                  As String
Private m_NroPrestacion                 As Long
Private m_Servicio                      As String
Private m_FechaGeneracion               As Date
Private m_IdArchivo                     As String
Private m_Origen                        As String
Private m_Total                         As Double
Private m_CantReg                       As Long

Public Property Get RegistroTipo() As String
  RegistroTipo = m_RegistroTipo
End Property

Public Property Let RegistroTipo(ByVal rhs As String)
  m_RegistroTipo = rhs
End Property

Public Property Get NroPrestacion() As Long
  NroPrestacion = m_NroPrestacion
End Property

Public Property Let NroPrestacion(ByVal rhs As Long)
  m_NroPrestacion = rhs
End Property

Public Property Get Servicio() As String
  Servicio = m_Servicio
End Property

Public Property Let Servicio(ByVal rhs As String)
  m_Servicio = rhs
End Property

Public Property Get FechaGeneracion() As Date
  FechaGeneracion = m_FechaGeneracion
End Property

Public Property Let FechaGeneracion(ByVal rhs As Date)
  m_FechaGeneracion = rhs
End Property

Public Property Get IdArchivo() As String
  IdArchivo = m_IdArchivo
End Property

Public Property Let IdArchivo(ByVal rhs As String)
  m_IdArchivo = rhs
End Property

Public Property Get Origen() As String
  Origen = m_Origen
End Property

Public Property Let Origen(ByVal rhs As String)
  m_Origen = rhs
End Property

Public Property Get Total() As Double
  Total = m_Total
End Property

Public Property Let Total(ByVal rhs As Double)
  m_Total = rhs
End Property

Public Property Get CantReg() As Long
  CantReg = m_CantReg
End Property

Public Property Let CantReg(ByVal rhs As Long)
  m_CantReg = rhs
End Property



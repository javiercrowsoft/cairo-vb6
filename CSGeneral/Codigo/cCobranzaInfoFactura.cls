VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cCobranzaInfoFactura"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Private m_CliId                         As Long
Private m_FvId                          As Long
Private m_ImporteCobrado                As Double
Private m_FormaDePago                   As Long

Public Property Get CliId() As Long
   CliId = m_CliId
End Property

Public Property Let CliId(ByVal rhs As Long)
   m_CliId = rhs
End Property

Public Property Get FvId() As Long
   FvId = m_FvId
End Property

Public Property Let FvId(ByVal rhs As Long)
   m_FvId = rhs
End Property

Public Property Get ImporteCobrado() As Double
   ImporteCobrado = m_ImporteCobrado
End Property

Public Property Let ImporteCobrado(ByVal rhs As Double)
   m_ImporteCobrado = rhs
End Property

Public Property Get FormaDePago() As Long
   FormaDePago = m_FormaDePago
End Property

Public Property Let FormaDePago(ByVal rhs As Long)
   m_FormaDePago = rhs
End Property



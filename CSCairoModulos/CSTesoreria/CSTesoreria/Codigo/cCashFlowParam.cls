VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cCashFlowParam"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Private m_Cli_id                        As Long
Private m_Prov_id                       As Long
Private m_Bco_id                        As Long
Private m_Cue_id                        As Long
Private m_Cliente                       As String
Private m_Proveedor                     As String
Private m_Banco                         As String
Private m_Cuenta                        As String

Public Property Get Cliente() As String
   Cliente = m_Cliente
End Property

Public Property Let Cliente(ByVal rhs As String)
   m_Cliente = rhs
End Property

Public Property Get Proveedor() As String
   Proveedor = m_Proveedor
End Property

Public Property Let Proveedor(ByVal rhs As String)
   m_Proveedor = rhs
End Property

Public Property Get Banco() As String
   Banco = m_Banco
End Property

Public Property Let Banco(ByVal rhs As String)
   m_Banco = rhs
End Property

Public Property Get Cuenta() As String
   Cuenta = m_Cuenta
End Property

Public Property Let Cuenta(ByVal rhs As String)
   m_Cuenta = rhs
End Property

Public Property Get cli_id() As Long
   cli_id = m_Cli_id
End Property

Public Property Let cli_id(ByVal rhs As Long)
   m_Cli_id = rhs
End Property

Public Property Get prov_id() As Long
   prov_id = m_Prov_id
End Property

Public Property Let prov_id(ByVal rhs As Long)
   m_Prov_id = rhs
End Property

Public Property Get bco_id() As Long
   bco_id = m_Bco_id
End Property

Public Property Let bco_id(ByVal rhs As Long)
   m_Bco_id = rhs
End Property

Public Property Get cue_id() As Long
   cue_id = m_Cue_id
End Property

Public Property Let cue_id(ByVal rhs As Long)
   m_Cue_id = rhs
End Property


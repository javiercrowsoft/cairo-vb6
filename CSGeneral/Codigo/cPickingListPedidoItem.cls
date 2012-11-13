VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cPickingListPedidoItem"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Private m_pv_id                         As Long
Private m_cli_id                        As Long

Public Property Get pv_id() As Long
   pv_id = m_pv_id
End Property

Public Property Let pv_id(ByVal rhs As Long)
   m_pv_id = rhs
End Property

Public Property Get cli_id() As Long
   cli_id = m_cli_id
End Property

Public Property Let cli_id(ByVal rhs As Long)
   m_cli_id = rhs
End Property



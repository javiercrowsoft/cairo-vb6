VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cTexto"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Private m_coll                          As Collection
Private m_nombre                        As String
Private m_codigo                        As String
Private m_id                            As Long
Private m_cmia_id                       As Long
Private m_cmiea_id                      As Long
Private m_cmi_id                        As Long
Private m_idm_id                        As Long

Public Property Get cmi_id() As Long
   cmi_id = m_cmi_id
End Property

Public Property Let cmi_id(ByVal rhs As Long)
   m_cmi_id = rhs
End Property

Public Property Get cmia_id() As Long
   cmia_id = m_cmia_id
End Property

Public Property Let cmia_id(ByVal rhs As Long)
   m_cmia_id = rhs
End Property

Public Property Get cmiea_id() As Long
   cmiea_id = m_cmiea_id
End Property

Public Property Let cmiea_id(ByVal rhs As Long)
   m_cmiea_id = rhs
End Property

Public Property Get idm_id() As Long
   idm_id = m_idm_id
End Property

Public Property Let idm_id(ByVal rhs As Long)
   m_idm_id = rhs
End Property

Public Property Get nombre() As String
  nombre = m_nombre
End Property

Public Property Let nombre(ByVal rhs As String)
  m_nombre = rhs
End Property

Public Property Get codigo() As String
  codigo = m_codigo
End Property

Public Property Let codigo(ByVal rhs As String)
  m_codigo = rhs
End Property

Public Property Get id() As Long
  id = m_id
End Property

Public Property Let id(ByVal rhs As Long)
  m_id = rhs
End Property

Public Property Get Items() As Collection
  Set Items = m_coll
End Property

Private Sub Class_Initialize()
  On Error Resume Next
  Set m_coll = New Collection
  Err.Clear
End Sub

Private Sub Class_Terminate()
  On Error Resume Next
  Set m_coll = Nothing
  Err.Clear
End Sub

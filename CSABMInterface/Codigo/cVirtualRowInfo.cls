VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cVirtualRowInfo"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Private m_bAddRows                      As Boolean
Private m_lRow                          As Long
Private m_lCol                          As Long
Private m_Key                           As Long
Private m_iAddRows                      As Long

Private m_NewId                         As Collection
Private m_NewValue                      As Collection

Public Property Get bAddRows() As Boolean
  bAddRows = m_bAddRows
End Property

Public Property Let bAddRows(ByVal rhs As Boolean)
  m_bAddRows = rhs
End Property

Public Property Get NewId() As Collection
   Set NewId = m_NewId
End Property

Public Property Get NewValue() As Collection
   Set NewValue = m_NewValue
End Property

Public Property Get lRow() As Long
   lRow = m_lRow
End Property

Public Property Let lRow(ByVal rhs As Long)
   m_lRow = rhs
End Property

Public Property Get lCol() As Long
   lCol = m_lCol
End Property

Public Property Let lCol(ByVal rhs As Long)
   m_lCol = rhs
End Property

Public Property Get Key() As Long
   Key = m_Key
End Property

Public Property Let Key(ByVal rhs As Long)
   m_Key = rhs
End Property

Public Property Get iAddRows() As Long
   iAddRows = m_iAddRows
End Property

Public Property Let iAddRows(ByVal rhs As Long)
   m_iAddRows = rhs
End Property

Private Sub Class_Initialize()
  Set m_NewId = New Collection
  Set m_NewValue = New Collection
End Sub

Private Sub Class_Terminate()
  Set m_NewId = Nothing
  Set m_NewValue = Nothing
End Sub

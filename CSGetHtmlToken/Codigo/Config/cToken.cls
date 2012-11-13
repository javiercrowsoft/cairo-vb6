VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cToken"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Private m_Name        As String
Private m_Url         As String
Private m_Tag         As String
Private m_TagEnd      As String
Private m_RunAt       As String
Private m_RunBetween  As String

Public Property Get Name() As String
  Name = m_Name
End Property

Public Property Let Name(ByVal rhs As String)
  m_Name = rhs
End Property

Public Property Get Url() As String
  Url = m_Url
End Property

Public Property Let Url(ByVal rhs As String)
  m_Url = rhs
End Property

Public Property Get Tag() As String
  Tag = m_Tag
End Property

Public Property Let Tag(ByVal rhs As String)
  m_Tag = rhs
End Property

Public Property Get TagEnd() As String
  TagEnd = m_TagEnd
End Property

Public Property Let TagEnd(ByVal rhs As String)
  m_TagEnd = rhs
End Property

Public Property Get RunAt() As String
  RunAt = m_RunAt
End Property

Public Property Let RunAt(ByVal rhs As String)
  m_RunAt = rhs
End Property

Public Property Get RunBetween() As String
  RunBetween = m_RunBetween
End Property

Public Property Let RunBetween(ByVal rhs As String)
  m_RunBetween = rhs
End Property


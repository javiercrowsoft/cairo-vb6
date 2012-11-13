VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cTaskItem"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Public Enum csEItemTypes
  csEIT_Folder = 1
  csEIT_File = 2
End Enum

Private m_Name      As String
Private m_Children  As Collection
Private m_Type      As csEItemTypes
Private m_Checked   As Boolean
Private m_FullPath  As String

Public Property Get Name() As String
  Name = m_Name
End Property

Public Property Let Name(ByVal rhs As String)
  m_Name = rhs
End Property

Public Property Get FullPath() As String
  FullPath = m_FullPath
End Property

Public Property Let FullPath(ByVal rhs As String)
  m_FullPath = rhs
End Property

Public Property Get Children() As Collection
  Set Children = m_Children
End Property

Public Property Get ItemType() As csEItemTypes
  ItemType = m_Type
End Property

Public Property Let ItemType(ByVal rhs As csEItemTypes)
  m_Type = rhs
End Property

Public Property Get Checked() As Boolean
  Checked = m_Checked
End Property

Public Property Let Checked(ByVal rhs As Boolean)
  m_Checked = rhs
End Property

Private Sub Class_Initialize()
  Set m_Children = New Collection
End Sub

Private Sub Class_Terminate()
  Set m_Children = Nothing
End Sub

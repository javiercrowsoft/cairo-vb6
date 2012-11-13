VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cGridView"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Private m_grid_name                     As String
Private m_Rpt_id                        As Long
Private m_Id                            As Long
Private m_Nombre                        As String
Private m_Default                       As Boolean
Private m_Publica                       As Boolean
Private m_Autowidth                     As Boolean
Private m_us_id                         As Long

Public Property Get grid_name() As String
   grid_name = m_grid_name
End Property

Public Property Let grid_name(ByVal rhs As String)
   m_grid_name = rhs
End Property

Public Property Get Rpt_id() As Long
   Rpt_id = m_Rpt_id
End Property

Public Property Let Rpt_id(ByVal rhs As Long)
   m_Rpt_id = rhs
End Property

Public Property Get Id() As Long
   Id = m_Id
End Property

Public Property Let Id(ByVal rhs As Long)
   m_Id = rhs
End Property

Public Property Get Nombre() As String
   Nombre = m_Nombre
End Property

Public Property Let Nombre(ByVal rhs As String)
   m_Nombre = rhs
End Property

Public Property Get Default() As Boolean
   Default = m_Default
End Property

Public Property Let Default(ByVal rhs As Boolean)
   m_Default = rhs
End Property

Public Property Get Publica() As Boolean
   Publica = m_Publica
End Property

Public Property Let Publica(ByVal rhs As Boolean)
   m_Publica = rhs
End Property

Public Property Get Autowidth() As Boolean
   Autowidth = m_Autowidth
End Property

Public Property Let Autowidth(ByVal rhs As Boolean)
   m_Autowidth = rhs
End Property

Public Property Get us_id() As Long
   us_id = m_us_id
End Property

Public Property Let us_id(ByVal rhs As Long)
   m_us_id = rhs
End Property


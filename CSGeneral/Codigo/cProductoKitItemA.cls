VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cProductoKitItemA"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Private m_Id                            As Long
Private m_Pr_id                         As Long
Private m_Nombre                        As String
Private m_Activo                        As Boolean

Public Property Get Id() As Long
   Id = m_Id
End Property

Public Property Let Id(ByVal rhs As Long)
   m_Id = rhs
End Property

Public Property Get Pr_id() As Long
   Pr_id = m_Pr_id
End Property

Public Property Let Pr_id(ByVal rhs As Long)
   m_Pr_id = rhs
End Property

Public Property Get Nombre() As String
   Nombre = m_Nombre
End Property

Public Property Let Nombre(ByVal rhs As String)
   m_Nombre = rhs
End Property

Public Property Get Activo() As Boolean
   Activo = m_Activo
End Property

Public Property Let Activo(ByVal rhs As Boolean)
   m_Activo = rhs
End Property



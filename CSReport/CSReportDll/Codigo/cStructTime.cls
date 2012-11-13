VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cStructTime"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Private m_Hour                          As Integer
Private m_Minute                        As Integer
Private m_Second                        As Integer

Public Property Get Hour() As Integer
   Hour = m_Hour
End Property

Public Property Let Hour(ByVal rhs As Integer)
   m_Hour = rhs
End Property

Public Property Get Minute() As Integer
   Minute = m_Minute
End Property

Public Property Let Minute(ByVal rhs As Integer)
   m_Minute = rhs
End Property

Public Property Get Second() As Integer
   Second = m_Second
End Property

Public Property Let Second(ByVal rhs As Integer)
   m_Second = rhs
End Property



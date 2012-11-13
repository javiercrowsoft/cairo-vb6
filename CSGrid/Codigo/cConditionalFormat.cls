VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cConditionalFormat"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Private m_OBackColor                    As OLE_COLOR
Private m_OForeColor                    As OLE_COLOR
Private m_IFntIndex                     As Long

Public Property Get OBackColor() As OLE_COLOR
   OBackColor = m_OBackColor
End Property

Public Property Let OBackColor(ByVal rhs As OLE_COLOR)
   m_OBackColor = rhs
End Property

Public Property Get OForeColor() As OLE_COLOR
   OForeColor = m_OForeColor
End Property

Public Property Let OForeColor(ByVal rhs As OLE_COLOR)
   m_OForeColor = rhs
End Property

Public Property Get IFntIndex() As Long
   IFntIndex = m_IFntIndex
End Property

Public Property Let IFntIndex(ByVal rhs As Long)
   m_IFntIndex = rhs
End Property



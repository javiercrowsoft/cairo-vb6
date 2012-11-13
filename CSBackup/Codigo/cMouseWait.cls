VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cMouseWait"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Private m_OldMouse As Long


Private Sub Class_Initialize()
  m_OldMouse = Screen.MousePointer
  Screen.MousePointer = vbHourglass
  DoEvents
End Sub

Private Sub Class_Terminate()
  Screen.MousePointer = m_OldMouse
End Sub

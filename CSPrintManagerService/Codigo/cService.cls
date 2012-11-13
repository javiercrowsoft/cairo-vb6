VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cService"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Public Sub run(ByVal owner As Object)
  fMain.OwnerTop = owner.top
  fMain.OwnerLeft = owner.left + owner.width
  fMain.Show vbModeless, owner
End Sub

Public Sub resize(ByVal left As Long, _
                  ByVal top As Long, _
                  ByVal height As Long, _
                  ByVal width As Long)
  fMain.Move left, top, width, height
End Sub

VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cEncrypt"
Attribute VB_GlobalNameSpace = True
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

' cEncrypt

' Exposicion de las rutinas de encriptacion
Public Function Encript(ByVal ToEncript As String, ByVal Signature As String) As String
  Encript = mEncrypt.Encript(ToEncript, Signature)
End Function
Public Function Decript(ByVal ToDecript As String, ByVal Signature As String) As String
  Decript = mEncrypt.Decript(ToDecript, Signature)
End Function

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

' Exposicion de las rutinas de Encryptacion
Public Function Encrypt(ByVal ToEncrypt As String, ByVal Signature As String) As String
  Encrypt = mEncrypt.Encrypt(ToEncrypt, Signature)
End Function
Public Function Decrypt(ByVal ToDecrypt As String, ByVal Signature As String) As String
  Decrypt = mEncrypt.Decrypt(ToDecrypt, Signature)
End Function

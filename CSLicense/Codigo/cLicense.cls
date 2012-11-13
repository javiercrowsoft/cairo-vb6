VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cLicense"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Public Function GetCodigo(ByVal strCode As String, _
                          ByVal Empresas As Long, _
                          ByVal Usuarios As Long, _
                          ByVal Vto As Date) As String
  GetCodigo = mGetActivacion.GetCodigo(strCode, Empresas, Usuarios, Vto)
End Function

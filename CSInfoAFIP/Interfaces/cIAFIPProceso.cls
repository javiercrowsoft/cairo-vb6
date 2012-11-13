VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cIAFIPProceso"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Public Function ProcessRecord(ByRef Parametros As cIAFIPParametros, _
                              ByRef Fields As ADODB.Fields, _
                              ByRef Campos As cIAFIPCampos, _
                              ByVal IsLastRecord As Boolean, _
                              ByRef IsEmptyRecord As Boolean, _
                              ByVal lIndexRecord As Long, _
                              ByRef Esquema As cIAFIPEsquema) As Boolean
End Function

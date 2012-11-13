VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cCSAFIP1361Prestaciones"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cCSAFIPRes1361Prestaciones
' 09-05-2003

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
' estructuras
' enumeraciones

Public Enum csAFIP1361Prestacion
  csPreR1361ImportProv = 8001
  csPreR1361ListCais = 8002
End Enum

Public Enum csMenuEnum
  csMenuConfigInformes = 8001
End Enum

' variables privadas
' propiedades publicas
' propiedades privadas
' funciones publicas
Public Sub Init()

    SecurityAdd csPreR1361ImportProv, "Importar Proveedores", "AFIP Resolución 1361"
    SecurityAdd csPreR1361ListCais, "Listar CAIS vencidos", "AFIP Resolución 1361"
End Sub

' funciones privadas
' construccion - destruccion


VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cReportLink"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cReportLink
' 04-07-01

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' Interfaces
Implements cIReportLinkServer
' constantes
' estructuras
' variables privadas
' eventos
Public Event PercentComplet(ByVal Percent As Single, ByRef Cancel As Boolean)

' Este evento se dispara cuando el usuario hace doble click sobre un renglon del
' detalle
Public Event ShowDetails(ByVal Id As String)
' propiedades publicas
' propiedades privadas
' funciones publicas
' funciones friend
' funciones privadas
' construccion - destruccion


Private Sub cIReportLinkServer_PercentComplet(ByVal Percent As Single, Cancel As Boolean)
    RaiseEvent PercentComplet(Percent, Cancel)
End Sub

Private Sub cIReportLinkServer_ShowDetails(ByVal Id As String)
    RaiseEvent ShowDetails(Id)
End Sub

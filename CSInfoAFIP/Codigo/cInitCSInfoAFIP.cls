VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cInitCSInfoAFIP"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cInitCSInfoAFIP
' 23-03-02

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
' variables privadas
' propiedades publicas
Public Property Let AppName(ByVal RHS As String)
  gAppName = RHS
End Property
' propiedades privadas
' funciones publicas
Public Function Init(ByRef db As cDataBase) As Boolean
  Set gDB = db
  
  Dim Prestaciones As cCSInfoAFIPPrestaciones
  
  Set Prestaciones = New cCSInfoAFIPPrestaciones
  
  Prestaciones.Init
  
  LNGLoadLenguaje
  
  Init = True
End Function
' funciones privadas
' construccion - destruccion
Private Sub Class_Terminate()
  On Error Resume Next

  Set gDB = Nothing
  CSABMInterface2.CloseDll

  Set CSKernelClient2.OForms = Forms
  CSKernelClient2.FreeResource
End Sub


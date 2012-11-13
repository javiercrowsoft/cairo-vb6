VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cInitCSOAPIAvisos"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cInitCSOAPIAvisos
' 10-06-00

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cInitCSOAPIAvisos"
' estructuras
' variables privadas
' propiedades publicas
Public Property Let AppName(ByVal rhs As String)
  gAppName = rhs
End Property
' propiedades privadas
' funciones publicas
Public Function Init(ByRef db As cDataBase, ByVal Client As cTCPIPClient, ByVal ClientProcessId As Long) As Boolean
  
  Set gDB = db
  Set gTCPClient = Client
  
  gClientProcessId = ClientProcessId
  
  Init = True
End Function
' funciones privadas
' construccion - destruccion
Private Sub Class_Terminate()
  On Error Resume Next
      
  Set gDB = Nothing
End Sub



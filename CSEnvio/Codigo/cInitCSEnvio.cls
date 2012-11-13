VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cInitCSEnvio"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cInitCSEnvio
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
Private Const C_Module = "cInitCSEnvio"
' estructuras
' variables privadas
' propiedades publicas
Public Property Let AppName(ByVal rhs As String)
    gAppName = rhs
End Property
' propiedades privadas
' funciones publicas
Public Function Init(ByRef db As cDataBase) As Boolean
    Set gDB = db
    
    Dim Prestaciones As cCSEnvioPrestaciones
    
    Set Prestaciones = New cCSEnvioPrestaciones
    
    Prestaciones.Init
    
    'pAddAvisos
    
    LNGLoadLenguaje
    
    Init = True
End Function
' funciones privadas
'Private Sub pAddAvisos()
'  On Error GoTo ControlError
'
'  'CSOAPIAvisos.AvisoAddBar c_PTD_AVISO, "Partes Diarios", "", True, "", Nothing
'
'  GoTo ExitProc
'ControlError:
'  MngError Err, "pAddAvisos", C_Module, ""
'  If Err.Number Then Resume ExitProc
'ExitProc:
'  On Error Resume Next
'End Sub
' construccion - destruccion
Private Sub Class_Terminate()
        On Error Resume Next

  Set gDB = Nothing
  CSABMInterface2.CloseDll

  Set CSKernelClient2.OForms = Forms
  CSKernelClient2.FreeResource
End Sub

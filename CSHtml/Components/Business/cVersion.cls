VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 1  'NoTransaction
END
Attribute VB_Name = "cVersion"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cVersion
' 21-04-2004

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "CSWebBusiness.cVersion"
' estructuras
' variables privadas
Private m_dbVer As CSWebDataBase.cVersion
' eventos
' propiedades publicas
' propiedades friend
' propiedades privadas
' funciones publicas
Public Function Version() As String
  Version = GetVersionNumber()
End Function

Public Function ComputerName() As String
  ComputerName = GetComputerName()
End Function

Public Function DALVersion() As String
  DALVersion = m_dbVer.Version()
End Function

Public Function DALConnectionString() As String
  DALConnectionString = m_dbVer.ConnectionString()
End Function

Public Function ConnectionString() As String
  ConnectionString = DALConnectionString()
End Function

Public Function DALComputerName() As String
  DALComputerName = m_dbVer.ComputerName()
End Function
' funciones friend
' funciones privadas
' construccion - destruccion
Private Sub Class_Initialize()
  Set m_dbVer = New CSWebDataBase.cVersion
End Sub

Private Sub Class_Terminate()
  Set m_dbVer = Nothing
End Sub
'//////////////////////////////
'  Codigo estandar de errores
'  On Error GoTo ControlError
'
'  GoTo ExitProc
'ControlError:
'  MngError err,"", C_Module, ""
'  If Err.Number <> 0 Then Resume ExitProc
'ExitProc:
'  On Error Resume Next

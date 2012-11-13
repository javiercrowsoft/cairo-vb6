VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 3  'UsesTransaction
END
Attribute VB_Name = "cParteDiarioTipo"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
'--------------------------------------------------------------------------------
' cParteDiarioTipo
' 13-05-2004

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "CSWebDataBase.ParteDiarioTipo"
' estructuras
' variables privadas
Private m_dbh As cDBHelper
' eventos
' propiedades publicas
' propiedades friend
' propiedades privadas
' funciones publicas
Public Function GetToEdit() As ADODB.Recordset
  On Error GoTo ControlError
  
  Set GetToEdit = m_dbh.RunSPReturnRS("sp_web_ParteDiarioTipoGetToEdit")
     
  GetObjectContext.SetComplete
  Exit Function
      
ControlError:
  CtxRaiseError C_Module, "GetToEdit"
End Function

Public Function GetParteDiarioTipo() As ADODB.Recordset
  On Error GoTo ControlError
  
  Set GetParteDiarioTipo = m_dbh.RunSPReturnRS("sp_web_ParteDiarioTipoGet")
     
  GetObjectContext.SetComplete
  Exit Function
      
ControlError:
  CtxRaiseError C_Module, "GetParteDiarioTipo"
End Function
' funciones friend
' funciones privadas
' construccion - destruccion
Private Sub Class_Initialize()
  Set m_dbh = CreateObject("CSWebDataBase.cDBHelper")
End Sub

Private Sub Class_Terminate()
  Set m_dbh = Nothing
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

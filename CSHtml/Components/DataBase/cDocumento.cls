VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cDocumento"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cDocumento
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
Private Const C_Module = "CSWebDataBase.Documento"

Private m_dbh As cDBHelper
' estructuras
' variables privadas
' eventos
' propiedades publicas
' propiedades friend
' propiedades privadas
' funciones publicas
Public Function CanEdit(ByVal us_id As Long, ByVal dpto_id As Long) As Boolean
  On Error GoTo ControlError
  Dim rs As Recordset
  Set rs = m_dbh.RunSPReturnRS("sp_web_DepartamentoCanEdit", _
                                mp("@@us_id", adInteger, 4, us_id), _
                                mp("@@dpto_id", adInteger, 4, dpto_id))
  If rs.EOF Then
    CanEdit = False
  Else
    CanEdit = rs.Fields.Item(0).Value
  End If
     
  GetObjectContext.SetComplete
  Exit Function
      
ControlError:
  CtxRaiseError C_Module, "GetDepartamentos"
End Function

Public Function GetDepartamentos(ByVal us_id As Long) As ADODB.Recordset
  On Error GoTo ControlError
  
  Set GetDepartamentos = m_dbh.RunSPReturnRS("sp_web_DepartamentosXUsuario", _
                                              mp("@@us_id", adInteger, 4, us_id))
     
  GetObjectContext.SetComplete
  Exit Function
      
ControlError:
  CtxRaiseError C_Module, "GetDepartamentos"
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

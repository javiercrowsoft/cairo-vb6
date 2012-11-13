VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 3  'UsesTransaction
END
Attribute VB_Name = "cUsuario"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cUsuario
' -01-2004

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "CSWebDataBase.Usuario"
' estructuras
' variables privadas
Private m_dbh As cDBHelper
' eventos
' propiedades publicas
' propiedades friend
' propiedades privadas
' funciones publicas
Public Function GetUsuariosXIndice(ByVal us_nombre As String, _
                                   ByVal dpto_id As Long, _
                                   ByVal us_id As Long) As ADODB.Recordset
  On Error GoTo ControlError
  
  Set GetUsuariosXIndice = m_dbh.RunSPReturnRS("sp_web_UsuariosGetXIndice", _
                                               mp("@@us_nombre", adVarChar, 100, us_nombre), _
                                               mp("@@dpto_id", adInteger, 4, dpto_id), _
                                               mp("@@us_id", adInteger, 4, us_id))
     
  GetObjectContext.SetComplete
  Exit Function
      
ControlError:
  CtxRaiseError C_Module, "GetUsuariosXIndice"
End Function

Public Function GetUsuarioXIndice(ByVal us_id As Long, ByVal us_id_login As Long) As ADODB.Recordset
  On Error GoTo ControlError
  
  Set GetUsuarioXIndice = m_dbh.RunSPReturnRS("sp_web_UsuarioGetXIndice", _
                                              mp("@@us_id", adInteger, 4, us_id), _
                                              mp("@@us_id_login", adInteger, 4, us_id_login))
     
  GetObjectContext.SetComplete
  Exit Function
      
ControlError:
  CtxRaiseError C_Module, "GetUsuarioXIndice"
End Function

Public Function GetUsuarios(ByVal us_id As Long) As ADODB.Recordset
  On Error GoTo ControlError
  
  Set GetUsuarios = m_dbh.RunSPReturnRS("sp_web_UsuariosGet", _
                                         mp("@@us_id", adInteger, 4, us_id))
     
  GetObjectContext.SetComplete
  Exit Function
      
ControlError:
  CtxRaiseError C_Module, "GetUsuarios"
End Function

Public Function GetDepartamento(ByVal us_id As Long) As ADODB.Recordset
  On Error GoTo ControlError
  
  Set GetDepartamento = m_dbh.RunSPReturnRS("sp_web_DepartamentoGetXUsId", _
                                         mp("@@us_id", adInteger, 4, us_id))
     
  GetObjectContext.SetComplete
  Exit Function
      
ControlError:
  CtxRaiseError C_Module, "GetDepartamento"
End Function

Public Function Delete(ByVal us_id As Long) As Long
  On Error GoTo ControlError
      
  Delete = m_dbh.RunSPReturnInteger("sp_web_UsuarioDelete", _
                                    mp("@@us_id", adInteger, 4, us_id))
      
  GetObjectContext.SetComplete
  Exit Function
  
ControlError:
  CtxRaiseError C_Module, "Delete"
End Function

Public Function Add(ByVal us_nombre As String, _
                    ByVal us_clave As String, _
                    ByVal us_email As String) As Long
      
  On Error GoTo ControlError
    
  Add = m_dbh.RunSPReturnInteger("sp_Web_UsuarioUpdate", _
                                  mp("@@us_id", adInteger, 4, 0), _
                                  mp("@@us_nombre", adVarChar, 50, us_nombre), _
                                  mp("@@us_clave", adVarChar, 16, us_clave), _
                                  mp("@@us_email", adVarChar, 255, us_email))
    
  GetObjectContext.SetComplete
  Exit Function
  
ControlError:
  CtxRaiseError C_Module, "Add"
End Function

Public Function VerifyUser(ByVal us_nombre As String, _
                           ByVal us_clave As String, _
                           ByRef us_id As Variant) As Boolean
  
  On Error GoTo ControlError
  Dim strUserInfo As String
        
  ' We couldn't use the generic RunSP* functions because this stored proc has 2 output parameters
  ' The following code is a modified version of RunSPWithString to support 2 outputs and 1 return value

  Dim cmd As ADODB.Command
  Set cmd = New ADODB.Command
  
  'Run the procedure
  With cmd
    .ActiveConnection = m_dbh.GetConnectionString()
    
    .CommandText = "sp_Web_UsuarioLogin"
    .CommandType = adCmdStoredProc

    'set Params
    .Parameters.Append .CreateParameter("@@rtn", adTinyInt, adParamOutput, 1)
    .Parameters.Append .CreateParameter("@@us_nombre", adVarChar, adParamInput, 50, us_nombre)
    .Parameters.Append .CreateParameter("@@us_clave", adVarChar, adParamInput, 50, us_clave)
    .Parameters.Append .CreateParameter("@@us_id", adInteger, adParamOutput, 4)
  
    'execute Stored Proc
    .Execute , , ADODB.adExecuteNoRecords
    
    If .Parameters("@@rtn").Value = 0 Then
      us_id = 0
      VerifyUser = False
    Else
      us_id = .Parameters(3).Value
      VerifyUser = True
    End If
  End With
   
  Set cmd = Nothing
  GetObjectContext.SetComplete
  
  Exit Function

ControlError:
  Set cmd = Nothing
  CtxRaiseError C_Module, "VerifyUser"
End Function

Public Function ChangePwd(ByVal us_id As Long, _
                          ByVal us_clave As String) As Boolean
  
  On Error GoTo ControlError
  Dim strUserInfo As String
        
  ' We couldn't use the generic RunSP* functions because this stored proc has 2 output parameters
  ' The following code is a modified version of RunSPWithString to support 2 outputs and 1 return value

  Dim cmd As ADODB.Command
  Set cmd = New ADODB.Command
  
  'Run the procedure
  With cmd
    .ActiveConnection = m_dbh.GetConnectionString()
    
    .CommandText = "sp_Web_UsuarioUpdatePwd"
    .CommandType = adCmdStoredProc

    'set Params
    .Parameters.Append .CreateParameter("@@rtn", adTinyInt, adParamOutput, 1)
    .Parameters.Append .CreateParameter("@@us_id", adInteger, adParamInput, 50, us_id)
    .Parameters.Append .CreateParameter("@@us_clave", adVarChar, adParamInput, 50, us_clave)

  
    'execute Stored Proc
    .Execute , , ADODB.adExecuteNoRecords
    
    If .Parameters("@@rtn").Value = 0 Then
      ChangePwd = False
    Else
      ChangePwd = True
    End If
  End With
   
  Set cmd = Nothing
  GetObjectContext.SetComplete
  
  Exit Function

ControlError:
  Set cmd = Nothing
  CtxRaiseError C_Module, "ChangePwd"
End Function

Public Function GetByID(ByVal us_id As Long) As ADODB.Recordset
  On Error GoTo ControlError

  Set GetByID = m_dbh.RunSPReturnRS("sp_web_UsuarioGetByID", mp("@@us_id", adInteger, 4, us_id))
  GetObjectContext.SetComplete
  Exit Function

ControlError:
  CtxRaiseError C_Module, "GetByID"
End Function

Public Function CanAccess(ByVal us_id As Long, ByVal pre_id As Long) As Boolean
  On Error GoTo ControlError
  Dim Rs As ADODB.Recordset
  
  Set Rs = m_dbh.RunSPReturnRS("sp_web_UsuarioCanAccess", mp("@@us_id", adInteger, 4, us_id), mp("@@pre_id", adInteger, 4, pre_id))
  If Not Rs.EOF Then
    CanAccess = NullsToZero(Rs("CanAccess"))
  End If
  
  GetObjectContext.SetComplete
  Exit Function

ControlError:
  CtxRaiseError C_Module, "CanAccess"
End Function

Public Function GetClienteID(ByVal us_id As Long) As Long
  On Error GoTo ControlError
  Dim Rs As ADODB.Recordset
  
  Set Rs = GetByID(us_id)
  If Not Rs.EOF Then
    GetClienteID = NullsToZero(Rs("ClienteID"))
  End If
  Set Rs = Nothing
  
  GetObjectContext.SetComplete
  Exit Function

ControlError:
  CtxRaiseError C_Module, "GetClienteID"
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

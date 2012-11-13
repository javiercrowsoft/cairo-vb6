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
Private Const C_Module = "CSWebBusiness.Usuario"
Private Const c_LoginSignature = "Virginia Said-Neron-Catalina-la belleza"
' estructuras
' variables privadas
' eventos
' propiedades publicas
' propiedades friend
' propiedades privadas
' funciones publicas
Public Function GetUsuariosXIndice(ByVal us_nombre As String, _
                                   ByVal dpto_id As Long, _
                                   ByVal us_id As Long) As ADODB.Recordset
  On Error GoTo errorHandler

  Dim objDB As CSWebDataBase.cUsuario
  Set objDB = New CSWebDataBase.cUsuario

  Set GetUsuariosXIndice = objDB.GetUsuariosXIndice(us_nombre, dpto_id, us_id)

  Set objDB = Nothing

  GetObjectContext.SetComplete
  Exit Function

errorHandler:
  
  Set objDB = Nothing
  CtxRaiseError C_Module, "GetUsuariosXIndice(" & us_nombre & "," & dpto_id & ")"
End Function

Public Function GetUsuarioXIndice(ByVal us_id As Long, us_id_login) As ADODB.Recordset
  On Error GoTo errorHandler

  Dim objDB As CSWebDataBase.cUsuario
  Set objDB = New CSWebDataBase.cUsuario

  Set GetUsuarioXIndice = objDB.GetUsuarioXIndice(us_id, us_id_login)

  Set objDB = Nothing

  GetObjectContext.SetComplete
  Exit Function

errorHandler:
  
  Set objDB = Nothing
  CtxRaiseError C_Module, "GetUsuarioXIndice(" & us_id & ")"
End Function

Public Function GetUsuarios(ByVal us_id As Long) As ADODB.Recordset
  On Error GoTo errorHandler

  Dim objDB As CSWebDataBase.cUsuario
  Set objDB = New CSWebDataBase.cUsuario

  Set GetUsuarios = objDB.GetUsuarios(us_id)

  Set objDB = Nothing

  GetObjectContext.SetComplete
  Exit Function

errorHandler:
  
  Set objDB = Nothing
  CtxRaiseError C_Module, "GetUsuarios(" & us_id & ")"
End Function

Public Function GetDepartamento(ByVal us_id As Long) As ADODB.Recordset
  On Error GoTo errorHandler

  Dim objDB As CSWebDataBase.cUsuario
  Set objDB = New CSWebDataBase.cUsuario

  Set GetDepartamento = objDB.GetDepartamento(us_id)

  Set objDB = Nothing

  GetObjectContext.SetComplete
  Exit Function

errorHandler:
  
  Set objDB = Nothing
  CtxRaiseError C_Module, "GetDepartamento(" & us_id & ")"
End Function

Public Function Delete(ByVal us_id As Long) As Long
  On Error GoTo errorHandler
  Delete = False

  Dim objDB As CSWebDataBase.cUsuario
  Set objDB = New CSWebDataBase.cUsuario

  Delete = objDB.Delete(us_id)

  Set objDB = Nothing

  GetObjectContext.SetComplete
  Exit Function

errorHandler:
  
  Set objDB = Nothing
  CtxRaiseError C_Module, "Delete(" & us_id & ")"
End Function

Public Function VerifyLogin(ByVal us_nombre As String, _
                            ByVal us_clave As String, _
                            ByRef us_id As Variant) As Boolean

  On Error GoTo errorHandler
  VerifyLogin = False

  Dim objDB As CSWebDataBase.cUsuario
  Set objDB = New CSWebDataBase.cUsuario
  
  Dim Encrypt As Object
  Set Encrypt = CreateObject("CSEncrypt.cEncrypt")
  
  us_clave = Encrypt.Encript(us_clave, c_LoginSignature)

  VerifyLogin = objDB.VerifyUser(us_nombre, us_clave, us_id)

  Set objDB = Nothing

  GetObjectContext.SetComplete
  Exit Function

errorHandler:
  
  Set objDB = Nothing
  CtxRaiseError C_Module, "VerifyLogin(" & us_nombre & "," & us_clave & ")"
End Function

Public Function ChangePwd(ByVal us_id As Long, _
                          ByVal us_clave As String) As Boolean

  On Error GoTo errorHandler
  ChangePwd = False

  Dim objDB As CSWebDataBase.cUsuario
  Set objDB = New CSWebDataBase.cUsuario
  
  Dim Encrypt As Object
  Set Encrypt = CreateObject("CSEncrypt.cEncrypt")
  
  us_clave = Encrypt.Encript(us_clave, c_LoginSignature)

  ChangePwd = objDB.ChangePwd(us_id, us_clave)

  Set objDB = Nothing

  GetObjectContext.SetComplete
  Exit Function

errorHandler:
  
  Set objDB = Nothing
  CtxRaiseError C_Module, "ChangePwd(" & us_id & "," & us_clave & ")"
End Function

Public Function CanAccess(ByVal us_id As Long, ByVal pre_id As Long) As Boolean
  On Error GoTo errorHandler
  CanAccess = False

  Dim objDB As CSWebDataBase.cUsuario
  Set objDB = New CSWebDataBase.cUsuario

  CanAccess = objDB.CanAccess(us_id, pre_id)

  Set objDB = Nothing

  GetObjectContext.SetComplete
  Exit Function

errorHandler:
  
  Set objDB = Nothing
  CtxRaiseError C_Module, "CanAccess"
End Function


Public Function Add(ByVal us_nombre As String, _
                    ByVal us_clave As String, _
                    ByVal us_email As String) As Long
      
  On Error GoTo errorHandler
  
  Dim db As CSWebDataBase.cUsuario
  Set db = New CSWebDataBase.cUsuario
    
  Dim Newus_id As Long
    
  Newus_id = db.Add(us_nombre, us_clave, us_email)
  
  'set return value
  Add = Newus_id
  
  Set db = Nothing
  GetObjectContext.SetComplete
  Exit Function
  
errorHandler:
  
  Set db = Nothing
  CtxRaiseError C_Module, "Add"
End Function

Public Function Encrypt(ByVal toEncrypt As String) As String
  
  Dim oEncrypt As Object
  Set oEncrypt = CreateObject("CSEncrypt.cEncrypt")
  
  Encrypt = oEncrypt.Encript(toEncrypt, c_LoginSignature)

End Function

Public Function Decript(ByVal toDecript As String) As String
  
  Dim oEncrypt As Object
  Set oEncrypt = CreateObject("CSEncrypt.cEncrypt")
  
  Decript = oEncrypt.Decript(toDecript, c_LoginSignature)

End Function
' funciones friend
' funciones privadas
' construccion - destruccion

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

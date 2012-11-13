VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 3  'UsesTransaction
END
Attribute VB_Name = "cContacto"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cContacto
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
Private Const C_Module = "CSWebBusiness.Contacto"
' estructuras
' variables privadas
' eventos
' propiedades publicas
' propiedades friend
' propiedades privadas
' funciones publicas

'Nos devuelve varios datos utiles para administrar los Contactos
Public Function GetContactosEx(ByVal cli_id As Long, _
                               ByVal prov_id As Long, _
                               ByVal cont_nombre As String, _
                               ByVal filter As String, _
                               ByVal us_id As Long, _
                               ByVal cont_tipo As Long) As ADODB.Recordset
  On Error GoTo errorHandler
  Dim obj As CSWebDataBase.cContacto
  Set obj = New CSWebDataBase.cContacto
  
  Set GetContactosEx = obj.GetContactosEx(cli_id, _
                                          prov_id, _
                                          cont_nombre, _
                                          filter, _
                                          us_id, _
                                          cont_tipo)
  Set obj = Nothing
  
  GetObjectContext.SetComplete
  Exit Function
  
errorHandler:
  Set obj = Nothing
  CtxRaiseError C_Module, "GetContactosEx"
End Function

Public Function GetContactosByUser(ByVal us_id As Long) As ADODB.Recordset
  On Error GoTo errorHandler
  Dim obj As CSWebDataBase.cContacto
  Set obj = New CSWebDataBase.cContacto
  
  Set GetContactosByUser = obj.GetContactosByUser(us_id)
  Set obj = Nothing
  
  GetObjectContext.SetComplete
  Exit Function
  
errorHandler:
  Set obj = Nothing
  CtxRaiseError C_Module, "GetContactosByUser"
End Function

Public Function Delete(ByVal cont_id As Long, ByVal us_id As Long) As Boolean
  On Error GoTo errorHandler
  Dim obj As CSWebDataBase.cContacto
  Set obj = New CSWebDataBase.cContacto
  
  Delete = obj.Delete(cont_id, us_id)
  Set obj = Nothing
  
  GetObjectContext.SetComplete
  Exit Function
  
errorHandler:
  Set obj = Nothing
  CtxRaiseError C_Module, "Delete"
End Function

Public Function Add(ByVal agn_id As Long, _
                    ByVal cont_apellido As String, _
                    ByVal cont_nombre As String, _
                    ByVal cont_codigo As String, _
                    ByVal cont_tratamiento As String, _
                    ByVal cont_telefono As String, _
                    ByVal cont_fax As String, _
                    ByVal cont_celular As String, _
                    ByVal cont_email As String, _
                    ByVal cont_direccion As String, _
                    ByVal cont_descripcion As String, _
                    ByVal cont_cargo As String, _
                    ByVal cont_tipo As Integer, _
                    ByVal cont_categoria As String, _
                    ByVal cont_cliente As String, _
                    ByVal cont_proveedor As String, _
                    ByVal cont_fechanac As String, _
                    ByVal cont_codpostal As String, ByVal cont_ciudad As String, _
                    ByVal cont_provincia As String, ByVal pa_id As Long, _
                    ByVal cli_id As Long, ByVal prov_id As Long, _
                    ByVal pro_id As Long, ByVal ciu_id As Long, _
                    ByVal activo As Integer, ByVal us_id As Long, _
                    ByVal modifico As Long) As Long
                    
  On Error GoTo errorHandler
  
  Dim obj As CSWebBusiness.cContactoTran
  Set obj = New CSWebBusiness.cContactoTran
  
  Add = obj.Add(agn_id, _
                cont_apellido, _
                cont_nombre, _
                cont_codigo, _
                cont_tratamiento, _
                cont_telefono, _
                cont_fax, _
                cont_celular, _
                cont_email, _
                cont_direccion, _
                cont_descripcion, _
                cont_cargo, _
                cont_tipo, _
                cont_categoria, _
                cont_cliente, _
                cont_proveedor, _
                cont_fechanac, _
                cont_codpostal, cont_ciudad, cont_provincia, pa_id, _
                cli_id, prov_id, _
                pro_id, ciu_id, _
                activo, us_id, _
                modifico)
  Set obj = Nothing
  
  GetObjectContext.SetComplete
  Exit Function
  
errorHandler:
  Set obj = Nothing
  CtxRaiseError C_Module, "Add"
End Function

Public Function Update(ByVal agn_id As Long, _
                       ByVal cont_id As Long, _
                       ByVal cont_apellido As String, _
                       ByVal cont_nombre As String, _
                       ByVal cont_codigo As String, _
                       ByVal cont_tratamiento As String, _
                       ByVal cont_telefono As String, _
                       ByVal cont_fax As String, _
                       ByVal cont_celular As String, _
                       ByVal cont_email As String, _
                       ByVal cont_direccion As String, _
                       ByVal cont_descripcion As String, _
                       ByVal cont_cargo As String, _
                       ByVal cont_tipo As Integer, _
                       ByVal cont_categoria As String, _
                       ByVal cont_cliente As String, ByVal cont_proveedor As String, _
                       ByVal cont_fechanac As String, _
                       ByVal cont_codpostal As String, ByVal cont_ciudad As String, _
                       ByVal cont_provincia As String, ByVal pa_id As Long, _
                       ByVal cli_id As Long, ByVal prov_id As Long, _
                       ByVal pro_id As Long, ByVal ciu_id As Long, _
                       ByVal activo As Integer, ByVal us_id As Long, _
                       ByVal modifico As Long) As Long
                       
  On Error GoTo errorHandler
  Dim obj As CSWebBusiness.cContactoTran
  Set obj = New CSWebBusiness.cContactoTran
  
  Update = obj.Update(agn_id, _
                      cont_id, _
                      cont_apellido, _
                      cont_nombre, _
                      cont_codigo, _
                      cont_tratamiento, _
                      cont_telefono, _
                      cont_fax, _
                      cont_celular, _
                      cont_email, _
                      cont_direccion, _
                      cont_descripcion, _
                      cont_cargo, _
                      cont_tipo, _
                      cont_categoria, _
                      cont_cliente, _
                      cont_proveedor, _
                      cont_fechanac, _
                      cont_codpostal, cont_ciudad, cont_provincia, pa_id, _
                      cli_id, prov_id, _
                      pro_id, ciu_id, _
                      activo, us_id, _
                      modifico)
  Set obj = Nothing
  
  GetObjectContext.SetComplete
  Exit Function
  
errorHandler:
  Set obj = Nothing
  CtxRaiseError C_Module, "Update"
End Function

'Obtiene todos los datos de un Contacto
Public Function GetById(ByVal cont_id As Long, ByVal us_id As Long) As ADODB.Recordset

  On Error GoTo errorHandler
  Dim obj As CSWebDataBase.cContacto
  Set obj = New CSWebDataBase.cContacto
  
  Set GetById = obj.GetById(cont_id, us_id)
  Set obj = Nothing
  
  GetObjectContext.SetComplete
  Exit Function
  
errorHandler:
  Set obj = Nothing
  CtxRaiseError C_Module, "GetById"
End Function

'Nos devuelve los contactos para mostrar en la pagina de contactos
Public Function GetContactos(ByVal us_id As Long) As ADODB.Recordset
  On Error GoTo errorHandler
  Dim obj As CSWebDataBase.cContacto
  Set obj = New CSWebDataBase.cContacto
  
  Set GetContactos = obj.GetContactos(us_id)
  Set obj = Nothing
  
  GetObjectContext.SetComplete
  Exit Function
  
errorHandler:
  Set obj = Nothing
  CtxRaiseError C_Module, "GetContactos"
End Function

'/////////////////////////////////////////
Public Function GetCliente(ByVal us_id As Long) As ADODB.Recordset
  On Error GoTo errorHandler
  Dim obj As CSWebDataBase.cContacto
  Set obj = New CSWebDataBase.cContacto
  
  Set GetCliente = obj.GetCliente(us_id)
  Set obj = Nothing
  
  GetObjectContext.SetComplete
  Exit Function
  
errorHandler:
  Set obj = Nothing
  CtxRaiseError C_Module, "GetCliente"
End Function

Public Function GetProveedor(ByVal us_id As Long) As ADODB.Recordset
  On Error GoTo errorHandler
  Dim obj As CSWebDataBase.cContacto
  Set obj = New CSWebDataBase.cContacto
  
  Set GetProveedor = obj.GetProveedor(us_id)
  Set obj = Nothing
  
  GetObjectContext.SetComplete
  Exit Function
  
errorHandler:
  Set obj = Nothing
  CtxRaiseError C_Module, "GetProveedor"
End Function

Public Sub GetAgendaForUsId(ByRef agn_id As Variant, ByRef agn_nombre As Variant, ByVal us_id As Long)
  On Error GoTo errorHandler
  Dim obj As CSWebDataBase.cContacto
  Set obj = New CSWebDataBase.cContacto
  
  obj.GetAgendaForUsId agn_id, agn_nombre, us_id
  Set obj = Nothing
  
  GetObjectContext.SetComplete
  Exit Sub
  
errorHandler:
  Set obj = Nothing
  CtxRaiseError C_Module, "GetAgendaForUsId"
End Sub
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



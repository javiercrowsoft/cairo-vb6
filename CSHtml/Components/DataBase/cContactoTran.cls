VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 2  'RequiresTransaction
END
Attribute VB_Name = "cContactoTran"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cContactoTran
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
Private Const C_Module = "CSWebBusiness.ContactoTran"
' estructuras
' variables privadas
' eventos
' propiedades publicas
' propiedades friend
' propiedades privadas
' funciones publicas
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
    Dim obj As CSWebDataBase.cContacto
    Set obj = New CSWebDataBase.cContacto
    
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
    Dim obj As CSWebDataBase.cContacto
    Set obj = New CSWebDataBase.cContacto
    
    Add = obj.Update(agn_id, _
                     0, _
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


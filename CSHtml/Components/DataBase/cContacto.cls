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
Private Const C_Module = "CSWebDataBase.Contacto"

Private m_dbh As cDBHelper
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
          
  On Error GoTo ControlError
      
  Update = m_dbh.RunSPReturnInteger("sp_web_ContactoUpdate", _
                                    mp("@@agn_id", adInteger, 4, agn_id), _
                                    mp("@@cont_id", adInteger, 4, cont_id), _
                                    mp("@@cont_apellido", adVarChar, 100, cont_apellido), _
                                    mp("@@cont_nombre", adVarChar, 255, cont_nombre), _
                                    mp("@@cont_codigo", adVarChar, 255, cont_codigo), _
                                    mp("@@cont_tratamiento", adVarChar, 10, cont_tratamiento), _
                                    mp("@@cont_telefono", adVarChar, 100, cont_telefono), _
                                    mp("@@cont_fax", adVarChar, 100, cont_fax), _
                                    mp("@@cont_celular", adVarChar, 100, cont_celular), _
                                    mp("@@cont_email", adVarChar, 255, cont_email), _
                                    mp("@@cont_direccion", adVarChar, 255, cont_direccion), _
                                    mp("@@cont_descripcion", adVarChar, 5000, cont_descripcion), _
                                    mp("@@cont_cargo", adVarChar, 100, cont_cargo), _
                                    mp("@@cont_categoria", adVarChar, 150, cont_categoria), _
                                    mp("@@cont_cliente", adVarChar, 255, cont_cliente), _
                                    mp("@@cont_proveedor", adVarChar, 255, cont_proveedor), _
                                    mp("@@cont_fechanac", adDBTimeStamp, 4, cont_fechanac), _
                                    mp("@@cont_codpostal", adVarChar, 255, cont_codpostal), mp("@@cont_ciudad", adVarChar, 255, cont_ciudad), _
                                    mp("@@cont_provincia", adVarChar, 255, cont_provincia), mp("@@pa_id", adVarChar, adInteger, pa_id), _
                                    mp("@@tipo_id", adInteger, , cont_tipo), _
                                    mp("@@cli_id", adInteger, 4, cli_id), mp("@@prov_id", adInteger, 4, prov_id), _
                                    mp("@@pro_id", adInteger, 4, pro_id), mp("@@ciu_id", adInteger, 4, ciu_id), _
                                    mp("@@activo", adInteger, 4, activo), mp("@@us_id", adInteger, 4, us_id), _
                                    mp("@@modifico", adInteger, 4, modifico))
  GetObjectContext.SetComplete
  Exit Function
  
ControlError:
  CtxRaiseError C_Module, "Update"
End Function

Public Function GetByID(ByVal cont_id As Long, ByVal us_id As Long) As ADODB.Recordset
  On Error GoTo ControlError
  
  Set GetByID = m_dbh.RunSPReturnRS("sp_web_ContactoGetByID", _
                                    mp("@@cont_id", adInteger, 4, cont_id), _
                                    mp("@@us_id", adInteger, 4, us_id))
     
  GetObjectContext.SetComplete
  Exit Function
      
ControlError:
  CtxRaiseError C_Module, "GetByID"
End Function

Public Function GetContactos(ByVal us_id As Long) As ADODB.Recordset
  On Error GoTo ControlError
  
  Set GetContactos = m_dbh.RunSPReturnRS("sp_web_ContactoGet", _
                                         mp("@@us_id", adInteger, 4, us_id))
     
  GetObjectContext.SetComplete
  Exit Function
      
ControlError:
  CtxRaiseError C_Module, "GetContactos"
End Function

Public Function GetContactosByUser(ByVal us_id As Long) As ADODB.Recordset
  On Error GoTo ControlError
  
  Set GetContactosByUser = m_dbh.RunSPReturnRS("sp_web_ContactoGetByUser", _
                                                  mp("@@us_id", adInteger, , us_id))
      
  GetObjectContext.SetComplete
  Exit Function
      
ControlError:
  CtxRaiseError C_Module, "GetContactosByUser"
End Function

Public Function GetContactosEx(ByVal cli_id As Long, _
                               ByVal prov_id As Long, _
                               ByVal cont_nombre As String, _
                               ByVal Filter As String, _
                               ByVal us_id As Long, _
                               ByVal cont_tipo As Long) As ADODB.Recordset
  On Error GoTo ControlError
  
  Set GetContactosEx = m_dbh.RunSPReturnRS("sp_web_ContactoGetEx", _
                                              mp("@@cli_id", adInteger, , cli_id), _
                                              mp("@@prov_id", adInteger, , prov_id), _
                                              mp("@@cont_nombre", adVarChar, 100, cont_nombre), _
                                              mp("@@us_id", adInteger, , us_id), _
                                              mp("@@cont_id", adInteger, , 0), _
                                              mp("@@filter", adVarChar, 100, Filter), _
                                              mp("@@cont_tipo", adInteger, , cont_tipo))
      
  GetObjectContext.SetComplete
  Exit Function
      
ControlError:
  CtxRaiseError C_Module, "GetContactosEx"
End Function

Public Function Delete(ByVal cont_id As Long, ByVal us_id As Long) As Long
  On Error GoTo ControlError
      
  Delete = m_dbh.RunSPReturnInteger("sp_web_ContactoDelete", _
                                    mp("@@us_id", adInteger, 4, us_id), _
                                    mp("@@cont_id", adInteger, 4, cont_id))
      
  GetObjectContext.SetComplete
  Exit Function
  
ControlError:
  CtxRaiseError C_Module, "Delete"
End Function

'///////////////////////////////////////////////////////////////////////////
Public Function GetCliente(ByVal us_id As Long) As ADODB.Recordset
  On Error GoTo ControlError
  
  Set GetCliente = m_dbh.RunSPReturnRS("sp_web_ClienteGet", _
                                         mp("@@us_id", adInteger, 4, us_id))
     
  GetObjectContext.SetComplete
  Exit Function
      
ControlError:
  CtxRaiseError C_Module, "GetCliente"
End Function

Public Function GetProveedor(ByVal us_id As Long) As ADODB.Recordset
  On Error GoTo ControlError
  
  Set GetProveedor = m_dbh.RunSPReturnRS("sp_web_ProveedorGet", _
                                         mp("@@us_id", adInteger, 4, us_id))
     
  GetObjectContext.SetComplete
  Exit Function
      
ControlError:
  CtxRaiseError C_Module, "GetCliente"
End Function

Public Sub GetAgendaForUsId(ByRef agn_id As Variant, ByRef agn_nombre As Variant, ByVal us_id As Long)
  On Error GoTo ControlError
  Dim rs As Recordset
  
  Set rs = m_dbh.RunSPReturnRS("sp_web_UsuarioGetAgenda", _
                              mp("@@us_id", adInteger, 4, us_id))
     
  If rs.EOF Then
    agn_id = 0
    agn_nombre = ""
  Else
    agn_id = rs.Fields.Item("agn_id").Value
    agn_nombre = rs.Fields.Item("agn_nombre").Value
  End If
     
  GetObjectContext.SetComplete
  Exit Sub
      
ControlError:
  CtxRaiseError C_Module, "GetCliente"
End Sub
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



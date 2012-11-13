VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 3  'UsesTransaction
END
Attribute VB_Name = "cParteDiario"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cParteDiario
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
Private Const C_Module = "CSWebBusiness.ParteDiario"
' estructuras
' variables privadas
' eventos
' propiedades publicas
' propiedades friend
' propiedades privadas
' funciones publicas

'Nos devuelve varios datos utiles para administrar los ParteDiarios
Public Function CanAccessAtUser(ByVal us_id As Long, ByVal us_id_login As Long) As Boolean
  On Error GoTo errorHandler
  Dim obj As CSWebDataBase.cParteDiario
  Set obj = New CSWebDataBase.cParteDiario
  
  CanAccessAtUser = obj.CanAccessAtUser(us_id, us_id_login)
  Set obj = Nothing
  
  GetObjectContext.SetComplete
  Exit Function
  
errorHandler:
  Set obj = Nothing
  CtxRaiseError C_Module, "CanAccessAtUser"
End Function

Public Function GetParteDiariosEx(ByVal ptdt_id As Long, _
                                  ByVal ptd_cumplida As Integer, _
                                  ByVal cont_id As Long, _
                                  ByVal tarest_id As Long, _
                                  ByVal prio_id As Long, _
                                  ByVal lgj_id As Long, _
                                  ByVal cli_id As Long, _
                                  ByVal us_id_resp As Long, _
                                  ByVal us_id_asig As Long, _
                                  ByVal fechaDesde As Date, _
                                  ByVal fechaHasta As Date, _
                                  ByVal us_id As Long, _
                                  Optional ByVal dpto_id As Long = 0) As ADODB.Recordset
  On Error GoTo errorHandler
  Dim obj As CSWebDataBase.cParteDiario
  Set obj = New CSWebDataBase.cParteDiario
  
  Set GetParteDiariosEx = obj.GetParteDiariosEx(ptdt_id, _
                                                ptd_cumplida, _
                                                cont_id, _
                                                tarest_id, _
                                                prio_id, _
                                                lgj_id, _
                                                cli_id, _
                                                us_id_resp, _
                                                us_id_asig, _
                                                fechaDesde, _
                                                fechaHasta, _
                                                us_id, _
                                                dpto_id)
  Set obj = Nothing
  
  GetObjectContext.SetComplete
  Exit Function
  
errorHandler:
  Set obj = Nothing
  CtxRaiseError C_Module, "GetParteDiariosEx"
End Function

Public Function GetParteDiariosEx2(ByVal ptdt_id As Long, _
                                   ByVal ptd_titulo As String, _
                                   ByVal ptd_descrip As String, _
                                   ByVal ptd_cumplida As Integer, _
                                   ByVal cont_id As Long, _
                                   ByVal tarest_id As Long, _
                                   ByVal prio_id As Long, _
                                   ByVal lgj_id As Long, _
                                   ByVal cli_id As Long, _
                                   ByVal prov_id As Long, _
                                   ByVal us_id_resp As Long, _
                                   ByVal us_id_asig As Long, _
                                   ByVal fechaDesde As Date, _
                                   ByVal fechaHasta As Date, _
                                   ByVal us_id As Long, _
                                   ByVal dpto_id As Long) As ADODB.Recordset
  On Error GoTo errorHandler
  Dim obj As CSWebDataBase.cParteDiario
  Set obj = New CSWebDataBase.cParteDiario
  
  Set GetParteDiariosEx2 = obj.GetParteDiariosEx2(ptdt_id, _
                                                  ptd_titulo, _
                                                  ptd_descrip, _
                                                  ptd_cumplida, _
                                                  cont_id, _
                                                  tarest_id, _
                                                  prio_id, _
                                                  lgj_id, _
                                                  cli_id, _
                                                  prov_id, _
                                                  us_id_resp, _
                                                  us_id_asig, _
                                                  fechaDesde, _
                                                  fechaHasta, _
                                                  us_id, _
                                                  dpto_id)
  Set obj = Nothing
  
  GetObjectContext.SetComplete
  Exit Function
  
errorHandler:
  Set obj = Nothing
  CtxRaiseError C_Module, "GetParteDiariosEx2"
End Function

Public Function GetParteDiariosByUser(ByVal us_id As Long) As ADODB.Recordset
  On Error GoTo errorHandler
  Dim obj As CSWebDataBase.cParteDiario
  Set obj = New CSWebDataBase.cParteDiario
  
  Set GetParteDiariosByUser = obj.GetParteDiariosByUser(us_id)
  Set obj = Nothing
  
  GetObjectContext.SetComplete
  Exit Function
  
errorHandler:
  Set obj = Nothing
  CtxRaiseError C_Module, "GetParteDiariosByUser"
End Function

Public Function ChangeEstado(ByVal ptd_id As Long, ByVal ptd_cumplida As Long, ByVal tarest_id As Long, ByVal us_id As Long) As Boolean
  On Error GoTo errorHandler
  Dim obj As CSWebDataBase.cParteDiario
  Set obj = New CSWebDataBase.cParteDiario
  
  ChangeEstado = obj.ChangeEstado(ptd_id, ptd_cumplida, tarest_id, us_id)
  Set obj = Nothing
  
  GetObjectContext.SetComplete
  Exit Function
  
errorHandler:
  Set obj = Nothing
  CtxRaiseError C_Module, "ChangeEstado"
End Function

Public Function Delete(ByVal ptd_id As Long, ByVal us_id As Long) As Boolean
  On Error GoTo errorHandler
  Dim obj As CSWebDataBase.cParteDiario
  Set obj = New CSWebDataBase.cParteDiario
  
  Delete = obj.Delete(ptd_id, us_id)
  Set obj = Nothing
  
  GetObjectContext.SetComplete
  Exit Function
  
errorHandler:
  Set obj = Nothing
  CtxRaiseError C_Module, "Delete"
End Function

Public Function DeleteAviso(ByVal ptd_id As Long, ByVal us_id As Long) As Long
  On Error GoTo errorHandler
  Dim obj As CSWebDataBase.cParteDiario
  Set obj = New CSWebDataBase.cParteDiario
  
  DeleteAviso = obj.DeleteAviso(ptd_id, us_id)
  Set obj = Nothing
  
  GetObjectContext.SetComplete
  Exit Function
  
errorHandler:
  Set obj = Nothing
  CtxRaiseError C_Module, "DeleteAviso"
End Function

Public Function Add(ByVal ptd_titulo As String, _
                    ByVal ptd_descrip As String, _
                    ByVal ptd_fechaini As Date, _
                    ByVal ptd_fechafin As Date, _
                    ByVal ptd_alarma As Date, _
                    ByVal ptd_cumplida As Integer, _
                    ByVal ptd_recurrente As Integer, _
                    ByVal ptd_listausuariosId As String, _
                    ByVal ptd_publico As Integer, _
                    ByVal ptd_horaini As String, _
                    ByVal ptd_horafin As String, _
                    ByVal ptd_id_padre As Long, _
                    ByVal ptdt_id As Long, _
                    ByVal us_id_responsable As Long, _
                    ByVal us_id_asignador As Long, _
                    ByVal cont_id As Long, _
                    ByVal tarest_id As Long, _
                    ByVal prio_id As Long, _
                    ByVal lgj_id As Long, _
                    ByVal cli_id As Long, _
                    ByVal prov_id As Long, _
                    ByVal dpto_id As Long, _
                    ByVal modifico As Long) As Long
  On Error GoTo errorHandler
  Dim obj As CSWebBusiness.cParteDiarioTran
  Set obj = New CSWebBusiness.cParteDiarioTran
  
  Add = obj.Add(ptd_titulo, _
                ptd_descrip, _
                ptd_fechaini, _
                ptd_fechafin, _
                ptd_alarma, _
                ptd_cumplida, _
                ptd_recurrente, _
                ptd_listausuariosId, _
                ptd_publico, _
                ptd_horaini, _
                ptd_horafin, _
                ptd_id_padre, _
                ptdt_id, _
                us_id_responsable, _
                us_id_asignador, _
                cont_id, _
                tarest_id, _
                prio_id, _
                lgj_id, _
                cli_id, _
                prov_id, _
                dpto_id, _
                modifico)
  Set obj = Nothing
  
  GetObjectContext.SetComplete
  Exit Function
  
errorHandler:
  Set obj = Nothing
  CtxRaiseError C_Module, "Add"
End Function

Public Function Update(ByVal ptd_id As Long, _
                       ByVal ptd_titulo As String, _
                       ByVal ptd_descrip As String, _
                       ByVal ptd_fechaini As Date, _
                       ByVal ptd_fechafin As Date, _
                       ByVal ptd_alarma As Date, _
                       ByVal ptd_cumplida As Integer, _
                       ByVal ptd_recurrente As Integer, _
                       ByVal ptd_listausuariosId As String, _
                       ByVal ptd_publico As Integer, _
                       ByVal ptd_horaini As String, _
                       ByVal ptd_horafin As String, _
                       ByVal ptd_id_padre As Long, _
                       ByVal ptdt_id As Long, _
                       ByVal us_id_responsable As Long, _
                       ByVal us_id_asignador As Long, _
                       ByVal cont_id As Long, _
                       ByVal tarest_id As Long, _
                       ByVal prio_id As Long, _
                       ByVal lgj_id As Long, _
                       ByVal cli_id As Long, _
                       ByVal prov_id As Long, _
                       ByVal dpto_id As Long, _
                       ByVal modifico As Long) As Long
  On Error GoTo errorHandler
  Dim obj As CSWebBusiness.cParteDiarioTran
  Set obj = New CSWebBusiness.cParteDiarioTran
  
  Update = obj.Update(ptd_id, _
                      ptd_titulo, _
                      ptd_descrip, _
                      ptd_fechaini, _
                      ptd_fechafin, _
                      ptd_alarma, _
                      ptd_cumplida, _
                      ptd_recurrente, _
                      ptd_listausuariosId, _
                      ptd_publico, _
                      ptd_horaini, _
                      ptd_horafin, _
                      ptd_id_padre, _
                      ptdt_id, _
                      us_id_responsable, _
                      us_id_asignador, _
                      cont_id, _
                      tarest_id, _
                      prio_id, _
                      lgj_id, _
                      cli_id, _
                      prov_id, _
                      dpto_id, _
                      modifico)
  Set obj = Nothing
  
  GetObjectContext.SetComplete
  Exit Function
  
errorHandler:
  Set obj = Nothing
  CtxRaiseError C_Module, "Update"
End Function

Public Function UpdateAlarma(ByVal ptd_id As Long, _
                             ByVal ptd_cumplida As Integer, _
                             ByVal ptd_horaini As String, _
                             ByVal ptd_alarma As String, _
                             ByVal us_id As Long)
  On Error GoTo errorHandler
  Dim obj As CSWebBusiness.cParteDiarioTran
  Set obj = New CSWebBusiness.cParteDiarioTran
  
  UpdateAlarma = obj.UpdateAlarma(ptd_id, _
                                  ptd_cumplida, _
                                  ptd_horaini, _
                                  ptd_alarma, _
                                  us_id)
  Set obj = Nothing
  
  GetObjectContext.SetComplete
  Exit Function
  
errorHandler:
  Set obj = Nothing
  CtxRaiseError C_Module, "UpdateAlarma"
End Function
'Obtiene todos los datos de un ParteDiario
Public Function GetById(ByVal ptd_id As Long, ByVal us_id As Long) As ADODB.Recordset

  On Error GoTo errorHandler
  Dim obj As CSWebDataBase.cParteDiario
  Set obj = New CSWebDataBase.cParteDiario
  
  Set GetById = obj.GetById(ptd_id, us_id)
  Set obj = Nothing
  
  GetObjectContext.SetComplete
  Exit Function
  
errorHandler:
  Set obj = Nothing
  CtxRaiseError C_Module, "GetById"
End Function

'Nos devuelve un popurri de noticias para mostrar en la pagina de noticias
'Por ahora pasamos el usuario, por si mas adelante queremos devolver algo
'customizado para ese usuario
Public Function GetParteDiarios(ByVal us_id As Long) As ADODB.Recordset
  On Error GoTo errorHandler
  Dim obj As CSWebDataBase.cParteDiario
  Set obj = New CSWebDataBase.cParteDiario
  
  Set GetParteDiarios = obj.GetParteDiarios(us_id)
  Set obj = Nothing
  
  GetObjectContext.SetComplete
  Exit Function
  
errorHandler:
  Set obj = Nothing
  CtxRaiseError C_Module, "GetParteDiarios"
End Function

'Nos devuelve los tipos de ParteDiarios que pueden ser cargados por personas en la base de datos
Public Function GetToEdit() As ADODB.Recordset
  On Error GoTo errorHandler
  Dim obj As CSWebDataBase.cParteDiarioTipo
  Set obj = New CSWebDataBase.cParteDiarioTipo
    
  Set GetToEdit = obj.GetToEdit()
  Set obj = Nothing
  
  GetObjectContext.SetComplete
  Exit Function
  
errorHandler:
  Set obj = Nothing
  CtxRaiseError C_Module, "GetToEdit"
End Function

'Nos devuelve los tipos de ParteDiarios
Public Function GetParteDiarioTipo() As ADODB.Recordset
  On Error GoTo errorHandler
  Dim obj As CSWebDataBase.cParteDiarioTipo
  Set obj = New CSWebDataBase.cParteDiarioTipo
  
  Set GetParteDiarioTipo = obj.GetParteDiarioTipo()
  Set obj = Nothing
  
  GetObjectContext.SetComplete
  Exit Function
  
errorHandler:
  Set obj = Nothing
  CtxRaiseError C_Module, "GetParteDiarioTipo"
End Function

'Nos devuelve los tipos de ParteDiarios
Public Function GetParteDiarioEstado() As ADODB.Recordset
  On Error GoTo errorHandler
  Dim obj As CSWebDataBase.cParteDiarioEstado
  Set obj = New CSWebDataBase.cParteDiarioEstado
  
  Set GetParteDiarioEstado = obj.GetParteDiarioEstado()
  Set obj = Nothing
  
  GetObjectContext.SetComplete
  Exit Function
  
errorHandler:
  Set obj = Nothing
  CtxRaiseError C_Module, "GetParteDiarioEstado"
End Function


'/////////////////////////////////////////
Public Function GetUsuario(ByVal us_id As Long) As ADODB.Recordset
  On Error GoTo errorHandler
  Dim obj As CSWebDataBase.cUsuario
  Set obj = New CSWebDataBase.cUsuario
  
  Set GetUsuario = obj.GetUsuarios(us_id)
  Set obj = Nothing
  
  GetObjectContext.SetComplete
  Exit Function
  
errorHandler:
  Set obj = Nothing
  CtxRaiseError C_Module, "GetUsuario"
End Function

Public Function GetContacto(ByVal us_id As Long) As ADODB.Recordset
  On Error GoTo errorHandler
  Dim obj As CSWebDataBase.cParteDiario
  Set obj = New CSWebDataBase.cParteDiario
  
  Set GetContacto = obj.GetContacto(us_id)
  Set obj = Nothing
  
  GetObjectContext.SetComplete
  Exit Function
  
errorHandler:
  Set obj = Nothing
  CtxRaiseError C_Module, "GetContacto"
End Function

Public Function GetTareaEstado(ByVal us_id As Long) As ADODB.Recordset
  On Error GoTo errorHandler
  Dim obj As CSWebDataBase.cParteDiario
  Set obj = New CSWebDataBase.cParteDiario
  
  Set GetTareaEstado = obj.GetTareaEstado(us_id)
  Set obj = Nothing
  
  GetObjectContext.SetComplete
  Exit Function
  
errorHandler:
  Set obj = Nothing
  CtxRaiseError C_Module, "GetTareaEstado"
End Function

Public Function GetPrioridad(ByVal us_id As Long) As ADODB.Recordset
  On Error GoTo errorHandler
  Dim obj As CSWebDataBase.cParteDiario
  Set obj = New CSWebDataBase.cParteDiario
  
  Set GetPrioridad = obj.GetPrioridad(us_id)
  Set obj = Nothing
  
  GetObjectContext.SetComplete
  Exit Function
  
errorHandler:
  Set obj = Nothing
  CtxRaiseError C_Module, "GetPrioridad"
End Function

Public Function GetLegajo(ByVal us_id As Long) As ADODB.Recordset
  On Error GoTo errorHandler
  Dim obj As CSWebDataBase.cParteDiario
  Set obj = New CSWebDataBase.cParteDiario
  
  Set GetLegajo = obj.GetLegajo(us_id)
  Set obj = Nothing
  
  GetObjectContext.SetComplete
  Exit Function
  
errorHandler:
  Set obj = Nothing
  CtxRaiseError C_Module, "GetLegajo"
End Function

Public Function GetCliente(ByVal us_id As Long) As ADODB.Recordset
  On Error GoTo errorHandler
  Dim obj As CSWebDataBase.cParteDiario
  Set obj = New CSWebDataBase.cParteDiario
  
  Set GetCliente = obj.GetCliente(us_id)
  Set obj = Nothing
  
  GetObjectContext.SetComplete
  Exit Function
  
errorHandler:
  Set obj = Nothing
  CtxRaiseError C_Module, "GetCliente"
End Function

Public Function GetDepartamento(ByVal us_id As Long) As ADODB.Recordset
  On Error GoTo errorHandler
  Dim obj As CSWebDataBase.cParteDiario
  Set obj = New CSWebDataBase.cParteDiario
  
  Set GetDepartamento = obj.GetDepartamento(us_id)
  Set obj = Nothing
  
  GetObjectContext.SetComplete
  Exit Function
  
errorHandler:
  Set obj = Nothing
  CtxRaiseError C_Module, "GetDepartamento"
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

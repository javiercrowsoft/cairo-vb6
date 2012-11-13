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
Private Const C_Module = "CSWebDataBase.ParteDiario"

Private m_dbh As cDBHelper
' estructuras
' variables privadas
' eventos
' propiedades publicas
' propiedades friend
' propiedades privadas
' funciones publicas
Public Function Update(ByVal ptd_id As Long, _
                       ByVal ptd_titulo As String, _
                       ByVal ptd_descrip As String, _
                       ByVal ptd_fechaini As String, _
                       ByVal ptd_fechafin As String, _
                       ByVal ptd_alarma As String, _
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
          
  On Error GoTo ControlError
      
  Update = m_dbh.RunSPReturnInteger("sp_web_ParteDiarioUpdate", _
                                    mp("@@ptd_id", adInteger, 4, ptd_id), _
                                    mp("@@ptd_titulo", adVarChar, 100, ptd_titulo), _
                                    mp("@@ptd_descrip", adVarChar, 5000, ptd_descrip), _
                                    mp("@@ptd_fechaini", adDBTimeStamp, 4, ptd_fechaini), _
                                    mp("@@ptd_fechafin", adDBTimeStamp, 4, ptd_fechafin), _
                                    mp("@@ptd_alarma", adDBTimeStamp, 4, ptd_alarma), _
                                    mp("@@ptd_cumplida", adInteger, 4, ptd_cumplida), _
                                    mp("@@ptd_recurrente", adInteger, 4, ptd_recurrente), _
                                    mp("@@ptd_listausuariosId", adVarChar, 1000, ptd_listausuariosId), _
                                    mp("@@ptd_publico", adInteger, , ptd_publico), _
                                    mp("@@ptd_horaini", adDBTimeStamp, 4, ptd_horaini), _
                                    mp("@@ptd_horafin", adDBTimeStamp, 4, ptd_horafin), _
                                    mp("@@ptd_id_padre", adInteger, 4, ptd_id_padre), _
                                    mp("@@ptdt_id", adInteger, 4, ptdt_id), _
                                    mp("@@us_id_responsable", adInteger, 4, us_id_responsable), _
                                    mp("@@us_id_asignador", adInteger, 4, us_id_asignador), _
                                    mp("@@cont_id", adInteger, 4, cont_id), _
                                    mp("@@tarest_id", adInteger, 4, tarest_id), _
                                    mp("@@prio_id", adInteger, 4, prio_id), _
                                    mp("@@lgj_id", adInteger, 4, lgj_id), _
                                    mp("@@cli_id", adInteger, 4, cli_id), _
                                    mp("@@prov_id", adInteger, 4, prov_id), _
                                    mp("@@dpto_id", adInteger, 4, dpto_id), _
                                    mp("@@modifico", adInteger, 4, modifico))
  GetObjectContext.SetComplete
  Exit Function
  
ControlError:
  CtxRaiseError C_Module, "Update"
End Function

Public Function GetByID(ByVal ptd_id As Long, ByVal us_id As Long) As ADODB.Recordset
  On Error GoTo ControlError
  
  Set GetByID = m_dbh.RunSPReturnRS("sp_web_ParteDiarioGetByID", _
                                    mp("@@ptd_id", adInteger, 4, ptd_id), _
                                    mp("@@us_id", adInteger, 4, us_id))
     
  GetObjectContext.SetComplete
  Exit Function
      
ControlError:
  CtxRaiseError C_Module, "GetByID"
End Function

Public Function CanAccessAtUser(ByVal us_id As Long, ByVal us_id_login As Long) As Boolean
  On Error GoTo ControlError
  Dim rs As ADODB.Recordset
  
  Set rs = m_dbh.RunSPReturnRS("sp_web_CanAccessAtUser", _
                               mp("@@us_id", adInteger, 4, us_id), _
                               mp("@@us_id_login", adInteger, 4, us_id_login))
  If rs.EOF Then
    CanAccessAtUser = False
  Else
    CanAccessAtUser = rs.Fields.Item(0).Value
  End If
     
  GetObjectContext.SetComplete
  Exit Function
      
ControlError:
  CtxRaiseError C_Module, "GetByID"
End Function

Public Function GetParteDiarios(ByVal us_id As Long) As ADODB.Recordset
  On Error GoTo ControlError
  
  Set GetParteDiarios = m_dbh.RunSPReturnRS("sp_web_ParteDiarioGet", _
                                         mp("@@us_id", adInteger, 4, us_id))
     
  GetObjectContext.SetComplete
  Exit Function
      
ControlError:
  CtxRaiseError C_Module, "GetParteDiarios"
End Function

Public Function GetParteDiariosByUser(ByVal us_id As Long) As ADODB.Recordset
  On Error GoTo ControlError
  
  Set GetParteDiariosByUser = m_dbh.RunSPReturnRS("sp_web_ParteDiarioGetByUser", _
                                                  mp("@@us_id", adInteger, , us_id))
      
  GetObjectContext.SetComplete
  Exit Function
      
ControlError:
  CtxRaiseError C_Module, "GetParteDiariosByUser"
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
  On Error GoTo ControlError
  
  Set GetParteDiariosEx = m_dbh.RunSPReturnRS("sp_web_ParteDiarioGetEx", _
                                              mp("@@ptdt_id", adInteger, , ptdt_id), _
                                              mp("@@ptd_cumplida", adInteger, , ptd_cumplida), _
                                              mp("@@dpto_id", adInteger, , dpto_id), _
                                              mp("@@cont_id", adInteger, , cont_id), _
                                              mp("@@tarest_id", adInteger, , tarest_id), _
                                              mp("@@prio_id", adInteger, , prio_id), _
                                              mp("@@lgj_id", adInteger, , lgj_id), _
                                              mp("@@cli_id", adInteger, , cli_id), _
                                              mp("@@us_id_responsable", adInteger, , us_id_resp), _
                                              mp("@@us_id_asignador", adInteger, , us_id_asig), _
                                              mp("@@fechaDesde", adDBTime, , fechaDesde), _
                                              mp("@@fechaHasta", adDBTime, , fechaHasta), _
                                              mp("@@us_id", adInteger, , us_id), _
                                              mp("@@ptd_id", adInteger, , 0))
      
  GetObjectContext.SetComplete
  Exit Function
      
ControlError:
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
  On Error GoTo ControlError
  
  Set GetParteDiariosEx2 = m_dbh.RunSPReturnRS("sp_web_ParteDiarioGetEx2", _
                                              mp("@@ptdt_id", adInteger, , ptdt_id), _
                                              mp("@@ptd_titulo", adVarChar, 100, ptd_titulo), _
                                              mp("@@ptd_descrip", adVarChar, 1000, ptd_descrip), _
                                              mp("@@ptd_cumplida", adInteger, , ptd_cumplida), _
                                              mp("@@dpto_id", adInteger, , dpto_id), _
                                              mp("@@cont_id", adInteger, , cont_id), _
                                              mp("@@tarest_id", adInteger, , tarest_id), _
                                              mp("@@prio_id", adInteger, , prio_id), _
                                              mp("@@lgj_id", adInteger, , lgj_id), _
                                              mp("@@cli_id", adInteger, , cli_id), _
                                              mp("@@prov_id", adInteger, , prov_id), _
                                              mp("@@us_id_responsable", adInteger, , us_id_resp), _
                                              mp("@@us_id_asignador", adInteger, , us_id_asig), _
                                              mp("@@fechaDesde", adDBTime, , fechaDesde), _
                                              mp("@@fechaHasta", adDBTime, , fechaHasta), _
                                              mp("@@us_id", adInteger, , us_id))
      
  GetObjectContext.SetComplete
  Exit Function
      
ControlError:
  CtxRaiseError C_Module, "GetParteDiariosEx2"
End Function

Public Function ChangeEstado(ByVal ptd_id As Long, ByVal ptd_cumplida As Long, ByVal tarest_id As Long, ByVal us_id As Long) As Long
  On Error GoTo ControlError
      
  ChangeEstado = m_dbh.RunSPReturnInteger("sp_web_ParteDiarioChangeEstado", _
                                          mp("@@us_id", adInteger, 4, us_id), _
                                          mp("@@ptd_id", adInteger, 4, ptd_id), _
                                          mp("@@ptd_cumplida", adInteger, 4, ptd_cumplida), _
                                          mp("@@tarest_id", adInteger, 4, tarest_id))
      
  GetObjectContext.SetComplete
  Exit Function
  
ControlError:
  CtxRaiseError C_Module, "ChangeEstado"
End Function

Public Function Delete(ByVal ptd_id As Long, ByVal us_id As Long) As Long
  On Error GoTo ControlError
      
  Delete = m_dbh.RunSPReturnInteger("sp_web_ParteDiarioDelete", _
                                    mp("@@us_id", adInteger, 4, us_id), _
                                    mp("@@ptd_id", adInteger, 4, ptd_id))
      
  GetObjectContext.SetComplete
  Exit Function
  
ControlError:
  CtxRaiseError C_Module, "Delete"
End Function

Public Function DeleteAviso(ByVal ptd_id As Long, ByVal us_id As Long) As Long
  On Error GoTo ControlError
      
  DeleteAviso = m_dbh.RunSPReturnInteger("sp_web_AvisoDelete", _
                                        mp("@@us_id", adInteger, 4, us_id), _
                                        mp("@@ptd_id", adInteger, 4, ptd_id))
      
  GetObjectContext.SetComplete
  Exit Function
  
ControlError:
  CtxRaiseError C_Module, "DeleteAviso"
End Function

Public Function UpdateAlarma(ByVal ptd_id As Long, _
                             ByVal ptd_cumplida As Integer, _
                             ByVal ptd_horaini As String, _
                             ByVal ptd_alarma As String, _
                             ByVal us_id As Long)
                             
          
  On Error GoTo ControlError
      
  UpdateAlarma = m_dbh.RunSPReturnInteger("sp_web_ParteDiarioUpdateAlarma", _
                                          mp("@@us_id", adInteger, 4, us_id), _
                                          mp("@@ptd_id", adInteger, 4, ptd_id), _
                                          mp("@@ptd_alarma", adDBTimeStamp, 4, ptd_alarma), _
                                          mp("@@ptd_cumplida", adInteger, 4, ptd_cumplida), _
                                          mp("@@ptd_horaini", adDBTimeStamp, 4, ptd_horaini))
  GetObjectContext.SetComplete
  Exit Function
  
ControlError:
  CtxRaiseError C_Module, "UpdateAlarma"
End Function

'///////////////////////////////////////////////////////////////////////////
Public Function GetContacto(ByVal us_id As Long) As ADODB.Recordset
  On Error GoTo ControlError
  
  Set GetContacto = m_dbh.RunSPReturnRS("sp_web_ContactosGet", _
                                         mp("@@us_id", adInteger, 4, us_id))
     
  GetObjectContext.SetComplete
  Exit Function
      
ControlError:
  CtxRaiseError C_Module, "GetContacto"
End Function

Public Function GetTareaEstado(ByVal us_id As Long) As ADODB.Recordset
  On Error GoTo ControlError
  
  Set GetTareaEstado = m_dbh.RunSPReturnRS("sp_web_TareaEstadoGet", _
                                           mp("@@us_id", adInteger, 4, us_id))
     
  GetObjectContext.SetComplete
  Exit Function
      
ControlError:
  CtxRaiseError C_Module, "GetTareaEstado"
End Function

Public Function GetPrioridad(ByVal us_id As Long) As ADODB.Recordset
  On Error GoTo ControlError
  
  Set GetPrioridad = m_dbh.RunSPReturnRS("sp_web_PrioridadGet", _
                                         mp("@@us_id", adInteger, 4, us_id))
     
  GetObjectContext.SetComplete
  Exit Function
      
ControlError:
  CtxRaiseError C_Module, "GetPrioridad"
End Function

Public Function GetLegajo(ByVal us_id As Long) As ADODB.Recordset
  On Error GoTo ControlError
  
  Set GetLegajo = m_dbh.RunSPReturnRS("sp_web_LegajoGet", _
                                         mp("@@us_id", adInteger, 4, us_id))
     
  GetObjectContext.SetComplete
  Exit Function
      
ControlError:
  CtxRaiseError C_Module, "GetLegajo"
End Function

Public Function GetCliente(ByVal us_id As Long) As ADODB.Recordset
  On Error GoTo ControlError
  
  Set GetCliente = m_dbh.RunSPReturnRS("sp_web_ClienteGet", _
                                         mp("@@us_id", adInteger, 4, us_id))
     
  GetObjectContext.SetComplete
  Exit Function
      
ControlError:
  CtxRaiseError C_Module, "GetCliente"
End Function

Public Function GetDepartamento(ByVal us_id As Long) As ADODB.Recordset
  On Error GoTo ControlError
  
  Set GetDepartamento = m_dbh.RunSPReturnRS("sp_web_DepartamentoGet", _
                                         mp("@@us_id", adInteger, 4, us_id))
     
  GetObjectContext.SetComplete
  Exit Function
      
ControlError:
  CtxRaiseError C_Module, "GetDepartamento"
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

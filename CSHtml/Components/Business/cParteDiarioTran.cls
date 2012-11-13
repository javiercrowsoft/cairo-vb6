VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 2  'RequiresTransaction
END
Attribute VB_Name = "cParteDiarioTran"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cParteDiarioTran
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
Private Const C_Module = "CSWebBusiness.ParteDiarioTran"
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
    Dim obj As CSWebDataBase.cParteDiario
    Set obj = New CSWebDataBase.cParteDiario
    
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
    Dim obj As CSWebDataBase.cParteDiario
    Set obj = New CSWebDataBase.cParteDiario
    
    Add = obj.Update(0, _
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
    CtxRaiseError C_Module, "Add"
End Function

Public Function UpdateAlarma(ByVal ptd_id As Long, _
                             ByVal ptd_cumplida As Integer, _
                             ByVal ptd_horaini As String, _
                             ByVal ptd_alarma As String, _
                             ByVal us_id As Long)
                             
    On Error GoTo errorHandler
    Dim obj As CSWebDataBase.cParteDiario
    Set obj = New CSWebDataBase.cParteDiario
    
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

VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 3  'UsesTransaction
END
Attribute VB_Name = "cEncuesta"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cEncuesta
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
Private Const C_Module = "CSWebDataBase.Encuesta"

Private m_dbh As cDBHelper
' estructuras
' variables privadas
' eventos
' propiedades publicas
' propiedades friend
' propiedades privadas
' funciones publicas
Public Function Update(ByVal ec_id As Long, _
                       ByVal ec_nombre As String, _
                       ByVal ec_descrip As String, _
                       ByVal ec_fecha As Date, _
                       ByVal ec_fechaHasta As Date, _
                       ByVal ec_anonimo As Boolean, _
                       ByVal activo As Boolean, _
                       ByVal us_id As Long) As Long
          
  On Error GoTo ControlError
      
  Update = m_dbh.RunSPReturnInteger("sp_web_EncuestaUpdate", _
                                    mp("@@ec_id", adInteger, 4, ec_id), _
                                    mp("@@ec_nombre", adVarChar, 100, ec_nombre), _
                                    mp("@@ec_descrip", adVarChar, 1000, ec_descrip), _
                                    mp("@@ec_fecha", adDBTimeStamp, 4, ec_fecha), _
                                    mp("@@ec_fechaHasta", adDBTimeStamp, 4, ec_fechaHasta), _
                                    mp("@@ec_anonimo", adInteger, 4, ec_anonimo), _
                                    mp("@@activo", adInteger, 4, activo), _
                                    mp("@@us_id", adInteger, 4, us_id))
  
  GetObjectContext.SetComplete
  Exit Function
  
ControlError:
  CtxRaiseError C_Module, "Update"
End Function

Public Function UpdateVoto(ByVal ecpi_id As Long, _
                           ByVal ecr_infoAdicional As String, _
                           ByVal us_id As Long)
          
  On Error GoTo ControlError
      
  m_dbh.RunSP "sp_web_EncuestaUpdateVoto", _
                mp("@@ecpi_id", adInteger, 4, ecpi_id), _
                mp("@@ecr_infoAdicional", adVarChar, 255, ecr_infoAdicional), _
                mp("@@us_id", adInteger, 4, us_id)
  
  GetObjectContext.SetComplete
  Exit Function
  
ControlError:
  CtxRaiseError C_Module, "UpdateVoto"
End Function

Public Function GetByID(ByVal ec_id As Long) As ADODB.Recordset
  On Error GoTo ControlError
  
  Set GetByID = m_dbh.RunSPReturnRS("sp_web_EncuestaGetByID", _
                                    mp("@@ec_id", adInteger, 4, ec_id))
     
  GetObjectContext.SetComplete
  Exit Function
      
ControlError:
  CtxRaiseError C_Module, "GetByID"
End Function

Public Function GetEncuestas(ByVal us_id As Long) As ADODB.Recordset
  On Error GoTo ControlError
  
  Set GetEncuestas = m_dbh.RunSPReturnRS("sp_web_EncuestaGet", _
                                         mp("@@us_id", adInteger, 4, us_id))
     
  GetObjectContext.SetComplete
  Exit Function
      
ControlError:
  CtxRaiseError C_Module, "GetEncuestas"
End Function

Public Function GetEncuestasByUser(ByVal us_id As Long) As ADODB.Recordset
  On Error GoTo ControlError
  
  Set GetEncuestasByUser = m_dbh.RunSPReturnRS("sp_web_EncuestaGetByUser", _
                                              mp("@@us_id", adInteger, , us_id))
      
  GetObjectContext.SetComplete
  Exit Function
      
ControlError:
  CtxRaiseError C_Module, "GetEncuestasByUser"
End Function

Public Function GetEncuestasEx(ByVal ws_id As Long, _
                             ByVal ec_fechaDesde As Date, _
                             ByVal ec_fechaHasta As Date, _
                             ByVal us_id As Long) As ADODB.Recordset
  On Error GoTo ControlError
  
  Set GetEncuestasEx = m_dbh.RunSPReturnRS("sp_web_EncuestaGetEx", _
                                           mp("@@ws_id", adInteger, , ws_id), _
                                           mp("@@ec_fechaDesde", adDBTimeStamp, , ec_fechaDesde), _
                                           mp("@@ec_fechaHasta", adDBTimeStamp, , ec_fechaHasta), _
                                           mp("@@us_id", adInteger, , us_id))
      
  GetObjectContext.SetComplete
  Exit Function
      
ControlError:
  CtxRaiseError C_Module, "GetEncuestasEx"
End Function

Public Function GetEncuestasForEdit(ByVal ws_id As Long, _
                                    ByVal ec_fechaDesde As Date, _
                                    ByVal ec_fechaHasta As Date, _
                                    ByVal ec_nombre As String, _
                                    ByVal ec_descrip As String, _
                                    ByVal us_id As Long) As ADODB.Recordset
  On Error GoTo ControlError
  
  Set GetEncuestasForEdit = m_dbh.RunSPReturnRS("sp_web_EncuestaGetForEdit", _
                                           mp("@@ws_id", adInteger, , ws_id), _
                                           mp("@@ec_fechaDesde", adDBTimeStamp, , ec_fechaDesde), _
                                           mp("@@ec_fechaHasta", adDBTimeStamp, , ec_fechaHasta), _
                                           mp("@@ec_nombre", adVarChar, 255, ec_nombre), _
                                           mp("@@ec_descrip", adVarChar, 255, ec_descrip), _
                                           mp("@@us_id", adInteger, , us_id))
  GetObjectContext.SetComplete
  Exit Function
      
ControlError:
  CtxRaiseError C_Module, "GetEncuestasForEdit"
End Function

Public Function Delete(ByVal ec_id As Long, ByVal us_id As Long) As Long
  On Error GoTo ControlError
      
  Delete = m_dbh.RunSPReturnInteger("sp_web_EncuestaDelete", _
                                    mp("@@us_id", adInteger, 4, us_id), _
                                    mp("@@ec_id", adInteger, 4, ec_id))
      
  GetObjectContext.SetComplete
  Exit Function
  
ControlError:
  CtxRaiseError C_Module, "Delete"
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



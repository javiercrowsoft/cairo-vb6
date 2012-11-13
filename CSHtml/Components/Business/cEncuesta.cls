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
Private Const C_Module = "CSWebBusiness.Encuesta"
' estructuras
' variables privadas
' eventos
' propiedades publicas
' propiedades friend
' propiedades privadas
' funciones publicas

'Nos devuelve varios datos utiles para administrar los Encuestas
Public Function GetEncuestasEx(ByVal ws_id As Long, _
                               ByVal ec_fechaDesdeDesde As Date, _
                               ByVal ec_fechaDesdeHasta As Date, _
                               ByVal us_id As Long) As ADODB.Recordset
  On Error GoTo errorHandler
  Dim obj As CSWebDataBase.cEncuesta
  Set obj = New CSWebDataBase.cEncuesta
  
  Set GetEncuestasEx = obj.GetEncuestasEx(ws_id, ec_fechaDesdeDesde, ec_fechaDesdeHasta, us_id)
  Set obj = Nothing
  
  GetObjectContext.SetComplete
  Exit Function
  
errorHandler:
  Set obj = Nothing
  CtxRaiseError C_Module, "GetEncuestasEx"
End Function

Public Function GetEncuestasForEdit(ByVal ws_id As Long, _
                                    ByVal ec_fechaDesdeDesde As Date, _
                                    ByVal ec_fechaDesdeHasta As Date, _
                                    ByVal ec_nombre As String, _
                                    ByVal ec_descrip As String, _
                                    ByVal us_id As Long) As ADODB.Recordset
  On Error GoTo errorHandler
  Dim obj As CSWebDataBase.cEncuesta
  Set obj = New CSWebDataBase.cEncuesta
  
  If ec_nombre <> "" Then ec_nombre = "%" & ec_nombre & "%"
  If ec_descrip <> "" Then ec_descrip = "%" & ec_descrip & "%"
  
  Set GetEncuestasForEdit = obj.GetEncuestasForEdit(ws_id, ec_fechaDesdeDesde, ec_fechaDesdeHasta, ec_nombre, ec_descrip, us_id)
  Set obj = Nothing
  
  GetObjectContext.SetComplete
  Exit Function
  
errorHandler:
  Set obj = Nothing
  CtxRaiseError C_Module, "GetEncuestasForEdit"
End Function

Public Function GetEncuestasByUser(ByVal us_id As Long) As ADODB.Recordset
  On Error GoTo errorHandler
  Dim obj As CSWebDataBase.cEncuesta
  Set obj = New CSWebDataBase.cEncuesta
  
  Set GetEncuestasByUser = obj.GetEncuestasByUser(us_id)
  Set obj = Nothing
  
  GetObjectContext.SetComplete
  Exit Function
  
errorHandler:
  Set obj = Nothing
  CtxRaiseError C_Module, "GetEncuestasByUser"
End Function

Public Function Delete(ByVal ec_id As Long, ByVal us_id As Long) As Boolean
  On Error GoTo errorHandler
  Dim obj As CSWebDataBase.cEncuesta
  Set obj = New CSWebDataBase.cEncuesta
  
  Delete = obj.Delete(ec_id, us_id)
  Set obj = Nothing
  
  GetObjectContext.SetComplete
  Exit Function
  
errorHandler:
  Set obj = Nothing
  CtxRaiseError C_Module, "Delete"
End Function

Public Function Add(ByVal ec_nombre As String, _
                    ByVal ec_descrip As String, _
                    ByVal ec_fechaDesde As Date, _
                    ByVal ec_fechaHasta As Date, _
                    ByVal ec_anonimo As Boolean, _
                    ByVal activo As Boolean, _
                    ByVal us_id As Long) As Long


  On Error GoTo errorHandler
  Dim obj As CSWebBusiness.cEncuestaTran
  Set obj = New CSWebBusiness.cEncuestaTran
  
  Add = obj.Add(ec_nombre, ec_descrip, ec_fechaDesde, ec_fechaHasta, ec_anonimo, activo, us_id)
  Set obj = Nothing
  
  GetObjectContext.SetComplete
  Exit Function
  
errorHandler:
  Set obj = Nothing
  CtxRaiseError C_Module, "Add"
            

End Function

Public Function Update(ByVal ec_id As Long, _
                       ByVal ec_nombre As String, _
                       ByVal ec_descrip As String, _
                       ByVal ec_fechaDesde As Date, _
                       ByVal ec_fechaHasta As Date, _
                       ByVal ec_anonimo As Boolean, _
                       ByVal activo As Boolean, _
                       ByVal us_id As Long) As Long

  On Error GoTo errorHandler
  Dim obj As CSWebBusiness.cEncuestaTran
  Set obj = New CSWebBusiness.cEncuestaTran
  
  Update = obj.Update(ec_id, ec_nombre, ec_descrip, ec_fechaDesde, ec_fechaHasta, ec_anonimo, activo, us_id)
  Set obj = Nothing
  
  GetObjectContext.SetComplete
  Exit Function
  
errorHandler:
  Set obj = Nothing
  CtxRaiseError C_Module, "Update"
End Function

Public Function UpdateVoto(ByVal ecpi_id As Long, _
                           ByVal ecr_infoAdicional As String, _
                           ByVal us_id As Long) As Long

  On Error GoTo errorHandler
  Dim obj As CSWebBusiness.cEncuestaTran
  Set obj = New CSWebBusiness.cEncuestaTran
  
  UpdateVoto = obj.UpdateVoto(ecpi_id, ecr_infoAdicional, us_id)
  Set obj = Nothing
  
  GetObjectContext.SetComplete
  Exit Function
  
errorHandler:
  Set obj = Nothing
  CtxRaiseError C_Module, "UpdateVoto"
End Function

'Obtiene todos los datos de un Encuesta
Public Function GetById(ByVal ec_id As Long) As ADODB.Recordset

  On Error GoTo errorHandler
  Dim obj As CSWebDataBase.cEncuesta
  Set obj = New CSWebDataBase.cEncuesta
  
  Set GetById = obj.GetById(ec_id)
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
Public Function GetEncuestas(ByVal us_id As Long) As ADODB.Recordset
  On Error GoTo errorHandler
  Dim obj As CSWebDataBase.cEncuesta
  Set obj = New CSWebDataBase.cEncuesta
  
  Set GetEncuestas = obj.GetEncuestas(us_id)
  Set obj = Nothing
  
  GetObjectContext.SetComplete
  Exit Function
  
errorHandler:
  Set obj = Nothing
  CtxRaiseError C_Module, "GetEncuestas"
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



VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 3  'UsesTransaction
END
Attribute VB_Name = "cArticulo"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cArticulo
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
Private Const C_Module = "CSWebBusiness.Articulo"
' estructuras
' variables privadas
' eventos
' propiedades publicas
' propiedades friend
' propiedades privadas
' funciones publicas

'Nos devuelve varios datos utiles para administrar los articulos
Public Function GetArticulosEx(ByVal wartt_id As Long, _
                               ByVal warte_id As Long, _
                               ByVal wart_fechaDesde As Date, _
                               ByVal wart_fechaHasta As Date, _
                               ByVal us_id As Long) As ADODB.Recordset
  On Error GoTo errorHandler
  Dim obj As CSWebDataBase.cArticulo
  Set obj = New CSWebDataBase.cArticulo
  
  Set GetArticulosEx = obj.GetArticulosEx(wartt_id, warte_id, wart_fechaDesde, wart_fechaHasta, us_id)
  Set obj = Nothing
  
  GetObjectContext.SetComplete
  Exit Function
  
errorHandler:
  Set obj = Nothing
  CtxRaiseError C_Module, "GetArticulosEx"
End Function

Public Function GetArticulosForEdit(ByVal wartt_id As Long, _
                                    ByVal warte_id As Long, _
                                    ByVal wart_fechaDesde As Date, _
                                    ByVal wart_fechaHasta As Date, _
                                    ByVal wart_titulo As String, _
                                    ByVal wart_copete As String, _
                                    ByVal wart_texto As String, _
                                    ByVal us_id As Long) As ADODB.Recordset
  On Error GoTo errorHandler
  Dim obj As CSWebDataBase.cArticulo
  Set obj = New CSWebDataBase.cArticulo
  
  If wart_titulo <> "" Then wart_titulo = "%" & wart_titulo & "%"
  If wart_copete <> "" Then wart_copete = "%" & wart_copete & "%"
  If wart_texto <> "" Then wart_texto = "%" & wart_texto & "%"
  
  Set GetArticulosForEdit = obj.GetArticulosForEdit(wartt_id, warte_id, wart_fechaDesde, wart_fechaHasta, wart_titulo, wart_copete, wart_texto, us_id)
  Set obj = Nothing
  
  GetObjectContext.SetComplete
  Exit Function
  
errorHandler:
  Set obj = Nothing
  CtxRaiseError C_Module, "GetArticulosForEdit"
End Function

Public Function GetArticulosByUser(ByVal us_id As Long) As ADODB.Recordset
  On Error GoTo errorHandler
  Dim obj As CSWebDataBase.cArticulo
  Set obj = New CSWebDataBase.cArticulo
  
  Set GetArticulosByUser = obj.GetArticulosByUser(us_id)
  Set obj = Nothing
  
  GetObjectContext.SetComplete
  Exit Function
  
errorHandler:
  Set obj = Nothing
  CtxRaiseError C_Module, "GetArticulosByUser"
End Function

Public Function ChangeEstado(ByVal wart_id As Long, ByVal warte_id As Long) As Boolean
  On Error GoTo errorHandler
  Dim obj As CSWebDataBase.cArticulo
  Set obj = New CSWebDataBase.cArticulo
  
  ChangeEstado = obj.ChangeEstado(wart_id, warte_id)
  Set obj = Nothing
  
  GetObjectContext.SetComplete
  Exit Function
  
errorHandler:
  Set obj = Nothing
  CtxRaiseError C_Module, "ChangeEstado"
End Function

Public Function Delete(ByVal wart_id As Long, ByVal us_id As Long) As Boolean
  On Error GoTo errorHandler
  Dim obj As CSWebDataBase.cArticulo
  Set obj = New CSWebDataBase.cArticulo
  
  Delete = obj.Delete(wart_id, us_id)
  Set obj = Nothing
  
  GetObjectContext.SetComplete
  Exit Function
  
errorHandler:
  Set obj = Nothing
  CtxRaiseError C_Module, "Delete"
End Function

Public Function Add(ByVal wart_titulo As String, _
                    ByVal wart_copete As String, _
                    ByVal wart_texto As String, _
                    ByVal wart_origen As String, _
                    ByVal wart_origenURL As String, _
                    ByVal wart_fecha As Date, _
                    ByVal wart_fechavto As Date, _
                    ByVal wart_imagen As String, _
                    ByVal wartt_id As Long, _
                    ByVal us_id As Long) As Long


  On Error GoTo errorHandler
  Dim obj As CSWebBusiness.cArticuloTran
  Set obj = New CSWebBusiness.cArticuloTran
  
  Add = obj.Add(wart_titulo, wart_copete, wart_texto, wart_origen, wart_origenURL, wart_fecha, wart_fechavto, wart_imagen, wartt_id, us_id)
  Set obj = Nothing
  
  GetObjectContext.SetComplete
  Exit Function
  
errorHandler:
  Set obj = Nothing
  CtxRaiseError C_Module, "Add"
            

End Function

Public Function Update(ByVal wart_id As Long, _
                       ByVal wart_titulo As String, _
                       ByVal wart_copete As String, _
                       ByVal wart_texto As String, _
                       ByVal wart_origen As String, _
                       ByVal wart_origenURL As String, _
                       ByVal wart_fecha As Date, _
                       ByVal wart_fechavto As Date, _
                       ByVal wart_imagen As String, _
                       ByVal wartt_id As Long, _
                       ByVal us_id As Long) As Long

  On Error GoTo errorHandler
  Dim obj As CSWebBusiness.cArticuloTran
  Set obj = New CSWebBusiness.cArticuloTran
  
  Update = obj.Update(wart_id, wart_titulo, wart_copete, wart_texto, wart_origen, wart_origenURL, wart_fecha, wart_fechavto, wart_imagen, wartt_id, us_id)
  Set obj = Nothing
  
  GetObjectContext.SetComplete
  Exit Function
  
errorHandler:
  Set obj = Nothing
  CtxRaiseError C_Module, "Update"
End Function

'Obtiene todos los datos de un articulo
Public Function GetById(ByVal wart_id As Long) As ADODB.Recordset

  On Error GoTo errorHandler
  Dim obj As CSWebDataBase.cArticulo
  Set obj = New CSWebDataBase.cArticulo
  
  Set GetById = obj.GetById(wart_id)
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
Public Function GetArticulos(ByVal us_id As Long) As ADODB.Recordset
  On Error GoTo errorHandler
  Dim obj As CSWebDataBase.cArticulo
  Set obj = New CSWebDataBase.cArticulo
  
  Set GetArticulos = obj.GetArticulos(us_id)
  Set obj = Nothing
  
  GetObjectContext.SetComplete
  Exit Function
  
errorHandler:
  Set obj = Nothing
  CtxRaiseError C_Module, "GetArticulos"
End Function

'Nos devuelve los tipos de articulos que pueden ser cargados por personas en la base de datos
Public Function GetToEdit() As ADODB.Recordset
  On Error GoTo errorHandler
  Dim obj As CSWebDataBase.cArticuloTipo
  Set obj = New CSWebDataBase.cArticuloTipo
    
  Set GetToEdit = obj.GetToEdit()
  Set obj = Nothing
  
  GetObjectContext.SetComplete
  Exit Function
  
errorHandler:
  Set obj = Nothing
  CtxRaiseError C_Module, "GetToEdit"
End Function

'Nos devuelve los tipos de articulos
Public Function GetArticuloTipo() As ADODB.Recordset
  On Error GoTo errorHandler
  Dim obj As CSWebDataBase.cArticuloTipo
  Set obj = New CSWebDataBase.cArticuloTipo
  
  Set GetArticuloTipo = obj.GetArticuloTipo()
  Set obj = Nothing
  
  GetObjectContext.SetComplete
  Exit Function
  
errorHandler:
  Set obj = Nothing
  CtxRaiseError C_Module, "GetArticuloTipo"
End Function

'Nos devuelve los tipos de articulos
Public Function GetArticuloEstado() As ADODB.Recordset
  On Error GoTo errorHandler
  Dim obj As CSWebDataBase.cArticuloEstado
  Set obj = New CSWebDataBase.cArticuloEstado
  
  Set GetArticuloEstado = obj.GetArticuloEstado()
  Set obj = Nothing
  
  GetObjectContext.SetComplete
  Exit Function
  
errorHandler:
  Set obj = Nothing
  CtxRaiseError C_Module, "GetArticuloEstado"
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

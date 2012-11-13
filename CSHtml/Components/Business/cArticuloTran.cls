VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 2  'RequiresTransaction
END
Attribute VB_Name = "cArticuloTran"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cArticuloTran
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
Private Const C_Module = "CSWebBusiness.ArticuloTran"
' estructuras
' variables privadas
' eventos
' propiedades publicas
' propiedades friend
' propiedades privadas
' funciones publicas
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
    Dim obj As CSWebDataBase.cArticulo
    Set obj = New CSWebDataBase.cArticulo
    
    Update = obj.Update(wart_id, wart_titulo, wart_copete, wart_texto, wart_origen, wart_origenURL, wart_fecha, wart_fechavto, wart_imagen, wartt_id, us_id)
    Set obj = Nothing
    
    GetObjectContext.SetComplete
    Exit Function
    
errorHandler:
    Set obj = Nothing
    CtxRaiseError C_Module, "Update"
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
    Dim obj As CSWebDataBase.cArticulo
    Set obj = New CSWebDataBase.cArticulo
    
    'Siempre lo mando los nuevos al estado "en edicion"
    Dim warte_id As Long
    warte_id = csEArticuloEstado.EnEdicion
    
    Add = obj.Update(0, wart_titulo, wart_copete, wart_texto, wart_origen, wart_origenURL, wart_fecha, wart_fechavto, wart_imagen, wartt_id, us_id)
        
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

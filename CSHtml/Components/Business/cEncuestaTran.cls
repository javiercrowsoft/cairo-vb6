VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 2  'RequiresTransaction
END
Attribute VB_Name = "cEncuestaTran"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cEncuestaTran
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
Private Const C_Module = "CSWebBusiness.EncuestaTran"
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
                       ByVal ec_fechaDesde As Date, _
                       ByVal ec_fechaHata As Date, _
                       ByVal ec_anonimo As Boolean, _
                       ByVal activo As Boolean, _
                       ByVal us_id As Long) As Long

    On Error GoTo errorHandler
    Dim obj As CSWebDataBase.cEncuesta
    Set obj = New CSWebDataBase.cEncuesta
    
    Update = obj.Update(ec_id, ec_nombre, ec_descrip, ec_fechaDesde, ec_fechaHata, ec_anonimo, activo, us_id)
    Set obj = Nothing
    
    GetObjectContext.SetComplete
    Exit Function
    
errorHandler:
    Set obj = Nothing
    CtxRaiseError C_Module, "Update"
End Function

Public Function Add(ByVal ec_nombre As String, _
                    ByVal ec_descrip As String, _
                    ByVal ec_fechaDesde As Date, _
                    ByVal ec_fechaHata As Date, _
                    ByVal ec_anonimo As Boolean, _
                    ByVal activo As Boolean, _
                    ByVal us_id As Long) As Long

    On Error GoTo errorHandler
    Dim obj As CSWebDataBase.cEncuesta
    Set obj = New CSWebDataBase.cEncuesta
    
    Add = obj.Update(0, ec_nombre, ec_descrip, ec_fechaDesde, ec_fechaHata, ec_anonimo, activo, us_id)
        
    Set obj = Nothing
    
    GetObjectContext.SetComplete
    Exit Function
    
errorHandler:
    Set obj = Nothing
    CtxRaiseError C_Module, "Add"
End Function

Public Function UpdateVoto(ByVal ecpi_id As Long, _
                           ByVal ecr_infoAdicional As String, _
                           ByVal us_id As Long) As Long

    On Error GoTo errorHandler
    Dim obj As CSWebDataBase.cEncuesta
    Set obj = New CSWebDataBase.cEncuesta
    
    UpdateVoto = obj.UpdateVoto(ecpi_id, ecr_infoAdicional, us_id)
    Set obj = Nothing
    
    GetObjectContext.SetComplete
    Exit Function
    
errorHandler:
    Set obj = Nothing
    CtxRaiseError C_Module, "UpdateVoto"
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



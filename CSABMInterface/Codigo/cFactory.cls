VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cFactory"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSIABMForm.cIFactory
'--------------------------------------------------------------------------------
' cFactory
' 16-05-2004

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cFactory"

' estructuras
' variables privadas
' eventos
' propiedades publicas
' propiedades friend
' propiedades privadas
' funciones publicas
Private Function cIFactory_GetForm(ByVal FormName As String, ObjClient As CSIABMForm.cIABMDocEvent) As Object
  Dim rtn As cIABMDocForm
  Dim Obj As Object
  
  Select Case FormName
  
    Case "CSABMInterface.fFacturaVenta"
  
      Set Obj = New fFacturaVenta
      
    Case "CSABMInterface.fRemitoVenta"
      
      Set Obj = New fRemitoVenta
    
    Case "CSABMInterface.fCobranza"
    
      Set Obj = New fCobranza
      
    Case "CSABMInterface.fPedidoVenta"
    
      Set Obj = New fPedidoVenta
  
    Case "CSABMInterface.fOrdenPago"
    
      Set Obj = New fOrdenPago
      
    Case "CSABMInterface.fMovimientoFondo"
    
      Set Obj = New fMovimientoFondo
    
    Case "CSABMInterface.fAsiento"
    
      Set Obj = New fAsiento
      
    Case "CSABMInterface.fRemitoCompra"
    
      Set Obj = New fRemitoCompra
  
    Case "CSABMInterface.fFacturaCompra"
    
      Set Obj = New fFacturaCompra
  
    Case "CSABMInterface.fPedidoCompra"
    
      Set Obj = New fPedidoCompra
  
    Case "CSABMInterface.fPresupuestoEnvio"
    
      Set Obj = New fPresupuestoEnvio
  
    Case "CSABMInterface.fPermisoEmbarque"
    
      Set Obj = New fPermisoEmbarque
  
    Case "CSABMInterface.fManifiestoCarga"
    
      Set Obj = New fManifiestoCarga
  
    Case "CSABMInterface.fPackingList"
    
      Set Obj = New fPackingList
  
    Case "CSABMInterface.fwCobranza"
    
      Set Obj = New fwCobranza
  
    Case "CSABMInterface.fwOrdenPago"
    
      Set Obj = New fwOrdenPago
  End Select
  
  Set rtn = Obj
  Set Obj.ObjHeader = ObjClient
  Set cIFactory_GetForm = Obj
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


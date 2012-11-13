VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cIComprobanteImpuesto"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cWindow
' 00-11-2002

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cWindow"
' estructuras
' variables privadas
Private m_Tipo                          As csTypeImpuesto
Private m_TasaIva                       As Long
Private m_Importe                       As Double
Private m_Porcentaje                    As Double
Private m_IngresosBrutoCategoria        As Long
' eventos
' propiedadades publicas
Public Property Get Tipo() As csTypeImpuesto
   Tipo = m_Tipo
End Property

Public Property Let Tipo(ByVal rhs As csTypeImpuesto)
   m_Tipo = rhs
End Property

Public Property Get TasaIva() As Long
   TasaIva = m_TasaIva
End Property

Public Property Let TasaIva(ByVal rhs As Long)
   m_TasaIva = rhs
End Property

Public Property Get Importe() As Double
   Importe = m_Importe
End Property

Public Property Let Importe(ByVal rhs As Double)
   m_Importe = rhs
End Property

Public Property Get Porcentaje() As Double
   Porcentaje = m_Porcentaje
End Property

Public Property Let Porcentaje(ByVal rhs As Double)
   m_Porcentaje = rhs
End Property

Public Property Get IngresosBrutoCategoria() As Long
   IngresosBrutoCategoria = m_IngresosBrutoCategoria
End Property

Public Property Let IngresosBrutoCategoria(ByVal rhs As Long)
   m_IngresosBrutoCategoria = rhs
End Property


' propiedadades friend
' propiedades privadas
' funciones publicas
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


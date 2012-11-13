VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cDeclarations"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cDeclarations
' 01-12-2007

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Public Enum csETablasSGR
  csAFIPCodigoActividad = 33001
  csActividadComercialTipo = 33002
  csSocio = 33003
  csSocioForm = 33004
End Enum

Public Enum csE_SGR_FacturaTipo
  csE_SGR_FV_Credito = 1
  csE_SGR_FV_AccionParticipe = 2
  csE_SGR_FV_AccionProtector = 3
  csE_SGR_FV_Cheque = 4
  csE_SGR_FV_OrdenCompra = 5
End Enum

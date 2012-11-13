VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cCSImplePrestaciones"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cCSImplementacionPrestaciones
' 14-02-2004

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
' estructuras
' enumeraciones

Public Enum csImplementacionPrestacion
  csPreImpleNewImportacion = 21001
  csPreImpleDeleteImportacion = 21002
  csPreImpleEditImportacion = 21003
  csPreImpleListImportacion = 21004
End Enum

Public Enum csMenuEnum
  csMenuMainImplementacion = 21999
End Enum

' variables privadas
' propiedades publicas
' propiedades privadas
' funciones publicas
Public Sub Init()
  SecurityAdd csPreImpleNewImportacion, "Agregar Importacion", "Implementacion"
  SecurityAdd csPreImpleDeleteImportacion, "Borrar Importacion", "Implementacion"
  SecurityAdd csPreImpleEditImportacion, "Editar Importacion", "Implementacion"
  SecurityAdd csPreImpleListImportacion, "Listar Importacion", "Implementacion"
End Sub

' funciones privadas
' construccion - destruccion






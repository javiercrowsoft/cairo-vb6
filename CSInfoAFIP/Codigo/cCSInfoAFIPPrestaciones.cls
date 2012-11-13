VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cCSInfoAFIPPrestaciones"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cCSInfoAFIPPrestaciones
' 09-05-2003

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

Public Enum csInfoAFIPPrestacion
  csInfoAFIPNewAFIPEsquema = 6001
  csInfoAFIPEditAFIPEsquema = 6002
  csInfoAFIPDeleteAFIPEsquema = 6003
  csInfoAFIPListAFIPEsquema = 6004

  csInfoAFIPNewAFIPArchivo = 6005
  csInfoAFIPEditAFIPArchivo = 6006
  csInfoAFIPDeleteAFIPArchivo = 6007
  csInfoAFIPListAFIPArchivo = 6008

  csInfoAFIPNewAFIPParametro = 6009
  csInfoAFIPEditAFIPParametro = 6010
  csInfoAFIPDeleteAFIPParametro = 6011
  csInfoAFIPListAFIPParametro = 6012

  csInfoAFIPNewAFIPRegistro = 6013
  csInfoAFIPEditAFIPRegistro = 6014
  csInfoAFIPDeleteAFIPRegistro = 6015
  csInfoAFIPListAFIPRegistro = 6016

  csInfoAFIPMakeAFIPEsquema = 6017
End Enum

Public Enum csMenuEnum
  csMenuInformes = 6001
End Enum

' variables privadas
' propiedades publicas
' propiedades privadas
' funciones publicas
Public Sub Init()
  SecurityAdd csInfoAFIPNewAFIPEsquema, "Agregar Esquema AFIP", "AFIP Esquema"
  SecurityAdd csInfoAFIPDeleteAFIPEsquema, "Borrar Esquema AFIP", "AFIP Esquema"
  SecurityAdd csInfoAFIPEditAFIPEsquema, "Editar Esquema AFIP", "AFIP Esquema"
  SecurityAdd csInfoAFIPListAFIPEsquema, "Listar Esquema AFIP", "AFIP Esquema"

  SecurityAdd csInfoAFIPNewAFIPArchivo, "Agregar Archivo AFIP", "AFIP Archivo"
  SecurityAdd csInfoAFIPDeleteAFIPArchivo, "Borrar Archivo AFIP", "AFIP Archivo"
  SecurityAdd csInfoAFIPEditAFIPArchivo, "Editar Archivo AFIP", "AFIP Archivo"
  SecurityAdd csInfoAFIPListAFIPArchivo, "Listar Archivo AFIP", "AFIP Archivo"

  SecurityAdd csInfoAFIPNewAFIPParametro, "Agregar Parametro AFIP", "AFIP Parametro"
  SecurityAdd csInfoAFIPDeleteAFIPParametro, "Borrar Parametro AFIP", "AFIP Parametro"
  SecurityAdd csInfoAFIPEditAFIPParametro, "Editar Parametro AFIP", "AFIP Parametro"
  SecurityAdd csInfoAFIPListAFIPParametro, "Listar Parametro AFIP", "AFIP Parametro"

  SecurityAdd csInfoAFIPNewAFIPRegistro, "Agregar Registro AFIP", "AFIP Registro"
  SecurityAdd csInfoAFIPDeleteAFIPRegistro, "Borrar Registro AFIP", "AFIP Registro"
  SecurityAdd csInfoAFIPEditAFIPRegistro, "Editar Registro AFIP", "AFIP Registro"
  SecurityAdd csInfoAFIPListAFIPRegistro, "Listar Registro AFIP", "AFIP Registro"

  SecurityAdd csInfoAFIPMakeAFIPEsquema, "Procesar Informe AFIP", "AFIP Informe"
End Sub

' funciones privadas
' construccion - destruccion






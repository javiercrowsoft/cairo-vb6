VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cCSProduccionPrestaciones"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cCSProduccionPrestaciones
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

Public Enum csProduccionPrestacion
  csPreProdNewMaquina = 13002
  csPreProdEditMaquina = 13003
  csPreProdDeleteMaquina = 13004
  csPreProdListMaquina = 13005
  
  csPreProdNewProductoBOM = 13006
  csPreProdEditProductoBOM = 13007
  csPreProdDeleteProductoBOM = 13008
  csPreProdListProductoBOM = 13009

End Enum

Public Enum csMenuEnum
 csMenuConfig = 13999
End Enum

' variables privadas
' propiedades publicas
' propiedades privadas
' funciones publicas
Public Sub Init()
  SecurityAdd csPreProdNewMaquina, "Agregar Maquina", "Producción"
  SecurityAdd csPreProdDeleteMaquina, "Borrar Maquina", "Producción"
  SecurityAdd csPreProdEditMaquina, "Editar Maquina", "Producción"
  SecurityAdd csPreProdListMaquina, "Listar Maquina", "Producción"
  
  SecurityAdd csPreProdNewProductoBOM, "Agregar B.O.M.", "Producción"
  SecurityAdd csPreProdDeleteProductoBOM, "Borrar B.O.M.", "Producción"
  SecurityAdd csPreProdEditProductoBOM, "Editar B.O.M.", "Producción"
  SecurityAdd csPreProdListProductoBOM, "Listar B.O.M.", "Producción"
End Sub

' funciones privadas
' construccion - destruccion






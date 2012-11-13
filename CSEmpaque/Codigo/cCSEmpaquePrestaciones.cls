VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cCSEmpaquePrestaciones"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cCSEmpaquePrestaciones
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

Public Enum cCSEmpaquePrestacion
  csPreEmpqNewCfgCalibradora = 1000033
  csPreEmpqEditCfgCalibradora = 1000034
  csPreEmpqDeleteCfgCalibradora = 1000035
  csPreEmpqListCfgCalibradora = 1000036

  csPreEmpqNewCalibradora = 1000037
  csPreEmpqEditCalibradora = 1000038
  csPreEmpqDeleteCalibradora = 1000039
  csPreEmpqListCalibradora = 1000040
  
  csPreEmpqNewEspecie = 1000045
  csPreEmpqEditEspecie = 1000046
  csPreEmpqDeleteEspecie = 1000047
  csPreEmpqListEspecie = 1000048

  csPreEmpqNewBarco = 1000049
  csPreEmpqEditBarco = 1000050
  csPreEmpqDeleteBarco = 1000051
  csPreEmpqListBarco = 1000052
  
  csPreEmpqNewPuerto = 1000053
  csPreEmpqEditPuerto = 1000054
  csPreEmpqDeletePuerto = 1000055
  csPreEmpqListPuerto = 1000056

  csPreEmpqNewContraMarca = 1000057
  csPreEmpqEditContraMarca = 1000058
  csPreEmpqDeleteContraMarca = 1000059
  csPreEmpqListContraMarca = 1000060
End Enum

Public Enum csMenuEnum
  csMenuConfig = 12999
End Enum

' variables privadas
' propiedades publicas
' propiedades privadas
' funciones publicas
Public Sub Init()
  SecurityAdd csPreEmpqNewCfgCalibradora, "Agregar Configuracion Calibradora", "Empaque"
  SecurityAdd csPreEmpqDeleteCfgCalibradora, "Borrar Configuracion Calibradora", "Empaque"
  SecurityAdd csPreEmpqEditCfgCalibradora, "Editar Configuracion Calibradora", "Empaque"
  SecurityAdd csPreEmpqListCfgCalibradora, "Listar Configuracion Calibradora", "Empaque"
  
  SecurityAdd csPreEmpqNewCalibradora, "Agregar Calibradora", "Empaque"
  SecurityAdd csPreEmpqDeleteCalibradora, "Borrar Calibradora", "Empaque"
  SecurityAdd csPreEmpqEditCalibradora, "Editar Calibradora", "Empaque"
  SecurityAdd csPreEmpqListCalibradora, "Listar Calibradora", "Empaque"
  
  SecurityAdd csPreEmpqNewEspecie, "Agregar Especie", "Empaque"
  SecurityAdd csPreEmpqDeleteEspecie, "Borrar Especie", "Empaque"
  SecurityAdd csPreEmpqEditEspecie, "Editar Especie", "Empaque"
  SecurityAdd csPreEmpqListEspecie, "Listar Especie", "Empaque"
  
  SecurityAdd csPreEmpqNewBarco, "Agregar Barco", "Empaque"
  SecurityAdd csPreEmpqDeleteBarco, "Borrar Barco", "Empaque"
  SecurityAdd csPreEmpqEditBarco, "Editar Barco", "Empaque"
  SecurityAdd csPreEmpqListBarco, "Listar Barco", "Empaque"
  
  SecurityAdd csPreEmpqNewPuerto, "Agregar Puerto", "Empaque"
  SecurityAdd csPreEmpqDeletePuerto, "Borrar Puerto", "Empaque"
  SecurityAdd csPreEmpqEditPuerto, "Editar Puerto", "Empaque"
  SecurityAdd csPreEmpqListPuerto, "Listar Puerto", "Empaque"

  SecurityAdd csPreEmpqNewContraMarca, "Agregar Contra Marcas", "Empaque"
  SecurityAdd csPreEmpqDeleteContraMarca, "Borrar Contra Marcas", "Empaque"
  SecurityAdd csPreEmpqEditContraMarca, "Editar Contra Marcas", "Empaque"
  SecurityAdd csPreEmpqListContraMarca, "Listar Contra Marcas", "Empaque"
End Sub

' funciones privadas
' construccion - destruccion

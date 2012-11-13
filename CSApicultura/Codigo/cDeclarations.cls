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
' 24-03-02

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Public Enum csETablesApicultura
  csAlsa = 11000
  csMedicamento = 11001
  csReina = 11002
  csColmena = 11003
End Enum

Public Enum csEAlsaTipoMadera
  csTMAlsaPino = 1
  csTMAlsaCalden = 2
  csTMAlsaSaligna = 3
End Enum

Public Enum csEAlsaTipoCamara
  csTCAlsaCria = 1
  csTCAlsaMelaria = 2
End Enum

Public Enum csEAlsaTipoAlsa
  csTAAlsaMediaAlsa = 1
  csTAAlsaAlsa = 2
End Enum

Public Enum csRCcalidad
  csRCBuena = 1
  csRCRegular = 2
  csRCMala = 3
End Enum

' estructuras
' variables privadas
' eventos
' propiedades publicas
' propiedades privadas
' funciones publicas
' funciones privadas
' construccion - destruccion




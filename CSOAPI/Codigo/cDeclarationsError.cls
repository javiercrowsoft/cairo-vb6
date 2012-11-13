VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cDeclarationsError"
Attribute VB_GlobalNameSpace = True
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cDeclarationsError
' 14-01-01

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' Funciones

'--------------------------------------------------------------------------------

' constantes
Public Enum csErrorType
    csErrorAdo = 1
    csErrorVba = 2
End Enum

Public Enum csErrorLevel
    csErrorWarning = 1
    csErrorFatal = 2
    csErrorInformation = 3
End Enum

Public Enum csErrores
    csErrorUserInvalido = vbObjectError + 1
    csErrorSepDecimal = vbObjectError + 2
    csErrorSepDecimalConfig = vbObjectError + 3
    csErrorFieldnTypeInvalido = vbObjectError + 4
    csErrorVal = vbObjectError + 5
    csErrorSetInfoString = vbObjectError + 6
    csErrorABMLoadControl = vbObjectError + 7
    csErrorUsoPropIdEnPermission = vbObjectError + 8
    csErrorUsoSubClearEnPermissions = vbObjectError + 9
    csErrorUsoSubRemoveEnPermissions = vbObjectError + 10
    csErrorUsoPropIdEnRol = vbObjectError + 11
    csErrorUsoSubClearEnUsuarioRol = vbObjectError + 12
    csErrorUsoSubRemoveEnUsuarioRol = vbObjectError + 13
    csErrorABMLoadControlSubTypeNotDefined = vbObjectError + 14
    csErrorInvalidPropertyValue = vbObjectError + 15
End Enum
' estructuras
' variables privadas
' eventos
' propiedades publicas
' propiedades privadas
' Funciones publicas
' Funciones privadas
' construccion - destruccion


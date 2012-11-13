VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cConstantes"
Attribute VB_GlobalNameSpace = True
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cConstantes
' 03-01-01

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Public Enum csTypeABMProperty
    cspHelp = 1
    cspText = 2
    cspAdHock = 3
    cspNumeric = 4
    cspOption = 5
    cspList = 6
    cspCheck = 7
    cspPassword = 8
    cspGrid = 9
    cspDate = 10
    cspButton = 11
    cspToolBar = 12
    cspImage = 13
    cspTime = 14
    cspProgressBar = 15
    cspLabel = 16
    cspTitle = 17
    cspDescription = 18
    cspFile = 19
    cspFolder = 20
End Enum

Public Enum csSubTypeABMProperty
    cspMoney = 1
    cspInteger = 2
    cspDouble = 3
    cspPercent = 4
    cspMask = 5
    cspCuit = 6
    cspMemo = 7
    cspTextButton = 8
    cspTextButtonEx = 9
End Enum

' Id's de las Tablas en Tabla
Public Enum csTables
    csPrestacion = 1
    csRol = 2
    csUsuario = 3
    csPermiso = 4
End Enum

Public Enum csListWhoSetItem
  csListItemData = 1
  csListListIndex = 2
  csListText = 3
End Enum
' estructuras
' variables privadas
' eventos
' Propertyes publicas
' Propertyes privadas
' funciones publicas
' funciones privadas
' construccion - destruccion



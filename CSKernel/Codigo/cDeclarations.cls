VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cDeclarations"
Attribute VB_GlobalNameSpace = True
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cDeclarations
' 02-01-00

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' Funciones

'--------------------------------------------------------------------------------

' constantes
Public Enum dblDataTypeExport
  dblExGrid
  dblExGridAdvanced
  dblExMatrix
  dblArray
  dblExRecordsetDao
  dblExRecordsetAdo
End Enum

Public Enum csConstIds
  csNO_ID = 0
  csNew = 0
  csAll = -1
End Enum

Public Enum csTypes
  csInteger = 2
  csDouble = 5
  csCurrency = 6
  csText = 200
  csId = -1
  csCuit = -100
  csBoolean = -200
  csSingle = -300
  csVariant = -400
  csLong = -500
  csDate = -600
  csDateOrNull = -700
End Enum

' Types de datos de fields
Public Enum csFieldType
  csFieldBoolean = csBoolean
  csFieldNumeric = csDouble
  csFieldChar = csText
  csFieldDate = csDate
End Enum

'//////////////////////
' Files
Public Enum csFile
  csRead = 1
  csWrite
  csAppend
  csBinaryRead
  csBinaryWrite
End Enum

Public Enum csFileAcces
  csShared = 1
  csLockRead
  csLockWrite
  csLockReadWrite
End Enum

Public Enum csSeccionSetting
  CSConfig
  csInterface
  csLogin
End Enum

Public Enum csButtons
  
  ' Grupo 1
  
  BUTTON_NEW = 1
  BUTTON_EDIT = 2
  BUTTON_REVOKE = 4
  BUTTON_DELETE = 8
  BUTTON_CUT = 16
  BUTTON_COPY = 32
  BUTTON_PASTE = 64
  BUTTON_SEARCH = 128
  BUTTON_PRINTOBJ = 256
  BUTTON_PREVIEW = 512
  BUTTON_DEACTIVE = 1024
  BUTTON_EXIT = 2048
  BUTTON_ROLS = 4096
  BUTTON_PERMISSIONS = 8192
  BUTTON_SAVE = 16384
  BUTTON_WITH_PARAMS = 32768
  BUTTON_WITHOUT_PARAMS = 65536
  BUTTON_UPDATE = 131072
  BUTTON_GRID = 262144
  
  BUTTON_ANULAR = 524288
  BUTTON_EDIT_STATE = 1048576
  BUTTON_RELOAD = 2097152
  BUTTON_ATTACH = 4194304
  BUTTON_DOC_APLIC = 8388608
  BUTTON_DOC_FIRST = 16777216
  BUTTON_DOC_PREVIOUS = 33554432
  BUTTON_DOC_NEXT = 67108864
  BUTTON_DOC_LAST = 134217728
  BUTTON_DOC_SIGNATURE = 268435456
  BUTTON_DOC_HELP = 536870912
  BUTTON_DOC_MODIFY = 1073741824
  
  ' Grupo 2
  
  BUTTON_DOC_AUX = 1
  BUTTON_DOC_EDIT = 2
  BUTTON_DOC_TIP = 4
  BUTTON_DOC_MERGE = 8
  BUTTON_DOC_ALERT = 16
  BUTTON_DOC_ACTION = 32
  BUTTON_DOC_MAIL = 64
  BUTTON_SAVE_PARAMS = 128
  BUTTON_RELOAD_PARAMS = 256
  BUTTON_SAVE_AS = 512
  BUTTON_SEARCH_LISTDOC = 1024
  
  ' Grupo 3
  
End Enum

Public Enum csSortType
' Text sorting:
 csSrtTNumeric = 100
 csSrtTString = 102
 csSrtTStringNoCase = 103
 
 ' Date sorting
 csSrtTDate = 200
 
 csSrtTDateYearAccuracy = 250
 csSrtTDateMonthAccuracy = 251
 csSrtTDateDayAccuracy = 252
 csSrtTDateHourAccuracy = 253
 csSrtTDateMinuteAccuracy = 254
 
 ' Icon sorting:
 csSrtTIcon = 300
 csSrtTExtraIcon = 301
 
 ' Colour sorting:
 csSrtTForeColor = 400
 csSrtTBackColor = 401
 ' Font sorting:
 csSrtTFontIndex = 500
 ' Selection sorting
 csSrtTSelected = 600
 ' Indentation sorting
 csSrtTIndentation = 700
End Enum

Public Enum csSortOrderType
  csSrtOrTNone = 0
  csSrtOrTAscending = 1
  csSrtOrTDescending = 2
End Enum

Public Enum csEditType
  csEditTText = 1
  csEditTCombo = 2
  csEditTCustom = 3
  csEditTButton = 4
  csEditTChecBox = 5
End Enum

Public Enum csConditionType
  csCondTNone = 0
  csCondTEqual = 1
  csCondTNotEqual = 2
  csCondTbetween = 3
  csCondTMoreThan = 4
  csCondTMinusThan = 5
  csCondTMoreThanOrEqual = 6
  csCondTMinusThanOrEqual = 7
End Enum

' estructuras
' variables privadas
' propiedades publicas
' propiedades privadas
' Funciones publicas
' Funciones privadas

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
'Public Enum dblDataTypeExport
'  dblExGrid
'  dblExGridAdvanced
'  dblExMatrix
'  dblArray
'  dblExRecordsetDao
'  dblExRecordsetAdo
'End Enum


'Public Enum csConstIds
'    csNO_ID = 0
'    csNew = 0
'    csAll = -1
'End Enum

'Public Enum csTypes
'    csInteger = 2
'    csDouble = 5
'    csCurrency = 6
'    csText = 200
'    csId = -1
'    csCuit = -100
'    csBoolean = -200
'    csSingle = -300
'    csVariant = -400
'    csLong = -500
'    csDate = -600
'    csDateOrNull = -700
'End Enum

'' Types de datos de fields
'Public Enum csFieldType
'    csFieldBoolean = csBoolean
'    csFieldNumeric = csDouble
'    csFieldChar = csText
'    csFieldDate = csDate
'End Enum

'Public Enum csSortType
'  ' Text sorting:
'   csSrtTNumeric = 100
'   csSrtTString = 102
'   csSrtTStringNoCase = 103
'
'   ' Date sorting
'   csSrtTDate = 200
'
'   csSrtTDateYearAccuracy = 250
'   csSrtTDateMonthAccuracy = 251
'   csSrtTDateDayAccuracy = 252
'   csSrtTDateHourAccuracy = 253
'   csSrtTDateMinuteAccuracy = 254
'
'   ' Icon sorting:
'   csSrtTIcon = 300
'   csSrtTExtraIcon = 301
'
'   ' Colour sorting:
'   csSrtTForeColor = 400
'   csSrtTBackColor = 401
'   ' Font sorting:
'   csSrtTFontIndex = 500
'   ' Selection sorting
'   csSrtTSelected = 600
'   ' Indentation sorting
'   csSrtTIndentation = 700
'End Enum

'Public Enum csSeccionSetting
'  CSConfig
'  csInterface
'  csLogin
'End Enum

#If PREPROC_CSOAPI Then
Public Enum csRptFTypes
  csRptFMaestro = 1
  csRptFDocumento = 2
End Enum
Public Enum csPermissionType
    csTPUser = 1
    csTPRol = 2
End Enum
Public Enum csETablesOAPI
  csSysModulo = 41
  csTabla = 42
  csSysModuloTCP = 43
End Enum
Public Enum csHelpType
  csNormal = 1
  csTree = 2
  csMultiSelect = 3
End Enum
#End If

'Public Enum csSortOrderType
'   csSrtOrTNone = 0
'   csSrtOrTAscending = 1
'   csSrtOrTDescending = 2
'End Enum

'Public Enum csEditType
'  csEditTText = 1
'  csEditTCombo = 2
'  csEditTCustom = 3
'  csEditTButton = 4
'  csEditTChecBox = 5
'End Enum

'Public Enum csConditionType
'  csCondTNone = 0
'  csCondTEqual = 1
'  csCondTNotEqual = 2
'  csCondTbetween = 3
'  csCondTMoreThan = 4
'  csCondTMinusThan = 5
'  csCondTMoreThanOrEqual = 6
'  csCondTMinusThanOrEqual = 7
'End Enum

#If PREPROC_CSDATABASE_CLIENT Or PREPROC_CSDATABASE Then

Public Enum crTaskType
  TYPE_IMPORT = 1
  TYPE_EXPORT = 2
  TYPE_TRANSFER = 3
End Enum

Public Enum crUpdateType
  ART_UPDATE_ALWAYS = 1
  ART_UPDATE_LUPDATE_IS_DIFERENT = 2
  ART_UPDATE_WHEN_LUPDATE_IS_MAJOR = 3
End Enum

Public Enum crTypeVariable
  RVAR_TYPE_TEXT = 1
  RVAR_TYPE_BOOLEAN = 2
  RVAR_TYPE_NUMERIC = 3
  RVAR_TYPE_DATE = 4
End Enum

Public Enum crMODEVariable
  RVAR_MODE_EDIT = 1
  RVAR_MODE_STATIC = 2
  RVAR_MODE_GET_FROM_INI = 3
  RVAR_MODE_GET_FROM_CONFIG = 4
End Enum

Public Enum crLogType
  REPLIC_LOG_INFO = 1
  REPLIC_LOG_WARNING = 2
  REPLIC_LOG_ERROR = 3
End Enum

Public Enum crServerType
  SERVER_ACCESS = 1
  SERVER_SQL = 2
End Enum

Public Enum crUpdateOption
  OPTION_UPDATE_IS_NEW = 2
  OPTION_UPDATE_NOT_IS_NEW = 4
  OPTION_UPDATE_CHECK_IS_NEW = 8
End Enum

Public Enum csRegistersState
  csOpen = adStateOpen
  csClose = adStateClosed
  csExecuting = adStateExecuting
  csFetching = adStateFetching
End Enum

Public Enum csTypeCursor
  csRsDynamic = CursorTypeEnum.adOpenDynamic
  csRsFast = CursorTypeEnum.adOpenForwardOnly
  csRsKeySet = CursorTypeEnum.adOpenKeyset
  csRsStatic = CursorTypeEnum.adOpenStatic
End Enum

Public Enum csTypeLock
  csLockOptimistic = LockTypeEnum.adLockOptimistic
  csLockGrpOptimistic = LockTypeEnum.adLockBatchOptimistic
  csLockPessimistic = LockTypeEnum.adLockPessimistic
  csLockReadOnly = LockTypeEnum.adLockReadOnly
End Enum

Public Enum csCommandType
  csCmdFile = CommandTypeEnum.adCmdFile
  csCmdSp = CommandTypeEnum.adCmdStoredProc
  csCmdTable = CommandTypeEnum.adCmdTable
  csCmdTableDirect = CommandTypeEnum.adCmdTableDirect
  csCmdText = CommandTypeEnum.adCmdText
  csCmdUnknown = CommandTypeEnum.adCmdUnknown
End Enum

Public Enum csDataType
  csTDChar = adChar
  csTDVarChar = adVarChar
  csTDLongVarChar = adLongVarChar
  csTDLongVarWChar = adLongVarWChar
  csTDWChar = adWChar
  csTDVarWChar = adVarWChar
  csTDDecimal = adDecimal
  csTDNumeric = adNumeric
  csTDDouble = adDouble
  csTDSingle = adSingle
  csTDCurrency = adCurrency
  csTDInteger = adInteger
  csTDBigInt = adBigInt
  csTDSmallInt = adSmallInt
  csTDTinyInt = adTinyInt
  csTDUnsignedTinyInt = adUnsignedTinyInt
  csTDDBTime = adDBTime
  csTDDBTimeStamp = adDBTimeStamp
  csTDDBDate = adDBDate
  csTDDate = adDate
  csTDBoolean = adBoolean
  csTDBinary = adBinary
  csTDLongVarBinary = adLongVarBinary
End Enum
  
Public Enum csServerVersion
  csVSql65 = 0
  csVSql70 = 1
  csVSAccess = 2
End Enum
 
#End If
' estructuras
' variables privadas
' propiedades publicas
#If PREPROC_ABMGENERIC Then
  Public Property Get csDocNumberID() As String
    csDocNumberID = csNumberID
  End Property
  Public Property Get csDocEstateID() As String
    csDocEstateID = csStateID
  End Property
#End If
' propiedades privadas
' Funciones publicas
' Funciones privadas

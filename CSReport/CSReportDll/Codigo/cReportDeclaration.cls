VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cReportDeclaration"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
'--------------------------------------------------------------------------------
' cReportDeclaration
' 30-06-01

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
' constantes
' estructuras
' funciones

'--------------------------------------------------------------------------------

' constantes
Public Enum csReportBorderType
  csRptBSNone = 0
  csRptBSFixed = 1
  csRptBS3d = 2
End Enum

Public Enum csRptLaunchAction
  csRptLaunchPrinter = 0
  csRptLaunchFile = 1
  csRptLaunchPreview = 2
End Enum

Public Enum csRptFileFormat
  csRptExportHtml = 0
  csRptExportExcel = 1
  csRptExportWord = 2
  csRptExportTxt = 3
  csRptExportTxtTab = 4
  csRptExportXmL = 5
End Enum

Public Enum csRptGetLineResult
  csRptGLDetail = 1
  csRptGLGroupHeader = 2
  csRptGLGroupFooter = 3
  csRptGLEnd = 4
  csRptGLNewPage = 5
  csRptGLVirtualH = 6
  csRptGLVirtualF = 7
End Enum

Public Enum csRptNewPageResult
  csRptNPError = 1
  csRptNPSuccess = 2
  csRptNPEnd = 3
End Enum

Public Enum csRptEndPageResult
  csRptEPError = csRptNewPageResult.csRptNPError
  csRptEPSuccess = csRptNewPageResult.csRptNPSuccess
End Enum

Public Enum csReportPaperType
  csRptPaperTypeA4 = 9
  csRptPaperTypeLetter = 1
  csRptPaperLegal = 5
  csRptPaperNotSuported = 0
End Enum

Public Enum csRptTypeSection
  csRptTpScHeader = 0
  csRptTpScDetail = 1
  csRptTpScFooter = 2
  csRptTpGroupHeader = 3
  csRptTpGroupFooter = 4
  csRptTpMainSectionHeader = 100
  csRptTpMainSectionDetail = 101
  csRptTpMainSectionFooter = 102
End Enum

Public Enum csRptErrors
  csRptErrLaunchInfoIndefined = Constants.vbObjectError + 1
  csRptErrSintaxErrorMissingBrakets = Constants.vbObjectError + 2
  csRptErrIndefinedFunction = Constants.vbObjectError + 3
  csRptErrMissingParam = Constants.vbObjectError + 4
  csRptErrControlNotFound = Constants.vbObjectError + 5
  csRptErrGroupNotFound = Constants.vbObjectError + 6
  csRptErrFieldNotFound = Constants.vbObjectError + 7
  csRptErrVarNotDefined = Constants.vbObjectError + 8
  csRptErrPrinterNotDefined = Constants.vbObjectError + 9
  csRptErrGroupNotInMainRS = Constants.vbObjectError + 10
  csRptErrParamNotDefined = Constants.vbObjectError + 11
End Enum

Public Enum csRptControlType
  csRptCtLabel = 1
  csRptCtField = 2
  csRptCtImage = 3
  csRptCtDbImage = 4
  csRptCtChart = 5
End Enum

Public Enum csRptGrpOrderType
  csRptGrpAsc = 1
  csRptGrpDesc = 2
End Enum

Public Enum csRptGrpComparisonType
  csRptGrpText = 1
  csRptGrpNumber = 2
  csRptGrpDate = 3
End Enum

Public Enum csRptWhenEval
  csRptEvalPre = 0
  csRptEvalPost = 1
End Enum

' estructuras
' variables privadas
' eventos
' propiedades publicas
' propiedades privadas
' funciones publicas
' funciones privadas
' construccion - destruccion


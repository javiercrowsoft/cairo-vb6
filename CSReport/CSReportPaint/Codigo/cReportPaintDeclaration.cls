VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cReportPaintDeclaration"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
'--------------------------------------------------------------------------------
' cReportPaintDeclaration
' 15-09-2001

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
' constantes
' estructuras
' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module As String = "cReportPaintDeclaration"
' estructuras
' variables privadas
' eventos
' propiedades publicas
' propiedades privadas
' funciones publicas
' funciones privadas
' construccion - destruccion

Public Enum cRptPaintObjType
  csRptPaintObjBox
  csRptPaintObjLine
  csRptPaintObjCircle
  csRptPaintObjImage
End Enum

Public Enum csRptPaintErrors
  csRptPatintErrObjClient = Constants.vbObjectError + 1000
  csRptPatintErrObjClientInvalid = Constants.vbObjectError + 1001
End Enum

Public Enum cRptPaintRegionType
  cRptPntRgnTypeBody
  cRptPntRgnTypeLeftUp
  cRptPntRgnTypeLeftDown
  cRptPntRgnTypeRightUp
  cRptPntRgnTypeRightDown
  cRptPntRgnTypeUp
  cRptPntRgnTypeDown
  cRptPntRgnTypeLeft
  cRptPntRgnTypeRight
End Enum

Public Enum csRptPaintRptType
  csRptPaintRptTypeSectionHeader = 0
  csRptPaintRptTypeSectionDetail = 1
  csRptPaintRptTypeSectionFooter = 2
  csRptPaintRptTypeMainSectionHeader = 100
  csRptPaintRptTypeMainSectionDetail = 101
  csRptPaintRptTypeMainSectionFooter = 102
  csRptPaintRptTypeGroupSectionHeader = 3
  csRptPaintRptTypeGroupSectionFooter = 4
  csRptPaintRptTypeControl = 50
End Enum


VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cDeclaration"
Attribute VB_GlobalNameSpace = True
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cCheckedItem
' 03-10-00

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Public Enum csBorderType
  cNone = 0
  cSingle = 1
End Enum

Public Enum csEIcons
  csECheck = 0
  csEUncheck
End Enum

Public Enum csGridAlignEnum
   csALignLeft = ECGHdrTextAlignFlags.ecgHdrTextALignLeft
   csALignCentre = ECGHdrTextAlignFlags.ecgHdrTextALignCentre
   csALignRight = ECGHdrTextAlignFlags.ecgHdrTextALignRight
End Enum

Public Enum csGridSortTypeEnum
  ' Text sorting:
  csGridSortNumeric = cShellSortTypeConstants.CCLSortNumeric
  csGridSortString = cShellSortTypeConstants.CCLSortString
  csGridSortStringNoCase = cShellSortTypeConstants.CCLSortStringNoCase
    
  ' Date sorting
  csGridSortDate = cShellSortTypeConstants.CCLSortDate
    
  csGridSortDateYearAccuracy = cShellSortTypeConstants.CCLSortDateYearAccuracy
  csGridSortDateMonthAccuracy = cShellSortTypeConstants.CCLSortDateMonthAccuracy
  csGridSortDateDayAccuracy = cShellSortTypeConstants.CCLSortDateDayAccuracy
  csGridSortDateHourAccuracy = cShellSortTypeConstants.CCLSortDateHourAccuracy
  csGridSortDateMinuteAccuracy = cShellSortTypeConstants.CCLSortDateMinuteAccuracy
    
  ' Icon sorting:
  csGridSortIcon = cShellSortTypeConstants.CCLSortIcon
  csGridSortExtraIcon = cShellSortTypeConstants.CCLSortExtraIcon
    
  ' Colour sorting:
  csGridSortForeColor = cShellSortTypeConstants.CCLSortForeColor
  csGridSortBackColor = cShellSortTypeConstants.CCLSortBackColor
  ' Font sorting:
  csGridSortFontIndex = cShellSortTypeConstants.CCLSortFontIndex
  ' Selection sorting
  csGridSortSelected = cShellSortTypeConstants.CCLSortSelected
  ' Indentation sorting
  csGridSortIndentation = cShellSortTypeConstants.CCLSortIndentation
End Enum

Public Enum csGridBorderStyleEnum
  csBorderStyle3d = ECGBorderStyle.ecgBorderStyle3d
  csBorderStyle3dThin = ECGBorderStyle.ecgBorderStyle3dThin
  csBorderStyleNone = ECGBorderStyle.ecgBorderStyleNone
End Enum
' estructuras
' variables privadas
' propiedades publicas
' propiedades privadas
' funciones publicas
' funciones privadas
' construccion - destruccion






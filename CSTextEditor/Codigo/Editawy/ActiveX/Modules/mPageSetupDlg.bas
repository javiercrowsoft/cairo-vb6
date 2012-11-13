Attribute VB_Name = "MPageSetupDlg"
Option Explicit

Public Type POINTAPI
        x As Long
        y As Long
End Type

Public Type RECT
        Left As Long
        Top As Long
        Right As Long
        Bottom As Long
End Type

Public Type PageSetupDlg
        lStructSize As Long
        hwndOwner As Long
        hDevMode As Long
        hDevNames As Long
        flags As Long
        ptPaperSize As POINTAPI
        rtMinMargin As RECT
        rtMargin As RECT
        hInstance As Long
        lCustData As Long
        lpfnPageSetupHook As Long
        lpfnPagePaintHook As Long
        lpPageSetupTemplateName As String
        hPageSetupTemplate As Long
End Type

Public Declare Function PageSetupDlg Lib "comdlg32.dll" Alias "PageSetupDlgA" (PPageSetupDlg As PageSetupDlg) As Long

Public Const PSD_MINMARGINS = &H1
Public Const PSD_MARGINS = &H2

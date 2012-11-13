VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "pcExplorerBarItem"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Private Declare Function GetWindowRect Lib "user32" (ByVal hWnd As Long, lpRect As RECT) As Long
Private Declare Function IsWindow Lib "user32" (ByVal hWnd As Long) As Long

Public ID As Long
Public BarID As Long
Public Text As String
Public Key As String
Public Tag As String
Public ItemData As Long
Public IconIndex As Long
Public pic As IPicture
Public TextColor As OLE_COLOR
Public TextColorOver As OLE_COLOR
Public CanClick As Boolean
Public ItemType As EExplorerBarItemTypes
Public ToolTipText As String
Public lPtrPanel As Long
Public Font As IFont
Public Bold As Boolean
Public SpacingAfter As Long

Public HeightWithScroll As Long
Public HeightWithoutScroll As Long
Public Top As Long
Public MouseDown As Boolean
Public MouseOver As Boolean

Public HasFocus As Boolean

Public Function HasMnemonic(ByVal sMnemonic As String) As Boolean
   HasMnemonic = (InStr(LCase(Text), "&" & LCase(sMnemonic)) > 0)
End Function

Public Function ControlHeight() As Long
Dim o As Object
Dim lHeight As Long
Dim lhWnd As Long
Dim tR As RECT

   If Not (lPtrPanel = 0) Then
      Set o = ObjectFromPtr(lPtrPanel)
      On Error Resume Next
      lhWnd = o.hWnd
      If (Err.Number = 0) Then
         If IsWindow(lhWnd) Then
            GetWindowRect lhWnd, tR
            lHeight = tR.bottom - tR.Top
         End If
      End If
      If (lHeight = 0) Then
         lHeight = o.ScaleHeight
      End If
      ControlHeight = lHeight
   End If
End Function


Private Sub Class_Initialize()
   ' Set defaults:
   TextColor = CLR_NONE
   TextColorOver = CLR_NONE
   CanClick = True
   ItemType = eItemLink
   IconIndex = -1
End Sub
 

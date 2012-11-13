Attribute VB_Name = "mDebug"
Option Explicit

'---------------------------------------------------------------------------------------
' Module    : GVB
' DateTime  : 12/05/2006 16:11
' Author    : Fernando
' Purpose   : Funciones del propio Visual Basic
' Copyright © 2001-2007 AGBO Business Architecture S.L.
'---------------------------------------------------------------------------------------
Private Declare Function GetModuleFileName Lib "kernel32" Alias _
                              "GetModuleFileNameA" (ByVal hModule As Long, ByVal lpFileName As _
                              String, ByVal nSize As Long) As Long
Private Declare Function GetClassLong Lib "user32" Alias _
                              "GetClassLongA" (ByVal hwnd As Long, ByVal nIndex As Long) As Long
Private Const GCL_HMODULE = -16

'---------------------------------------------------------------------------------------
' Procedure : inIDE
' DateTime  : 12/05/2006 16:11
' Author    : Fernando
' Purpose   : Devuelve True si estamos dentro del IDE
' Copyright © 2001-2007 AGBO Business Architecture S.L.
'---------------------------------------------------------------------------------------
'
Public Function inIDE() As Boolean

  Dim sBuff As String
  Dim lpString As String
  Dim rForm As Form    'any form will do
  
  Set rForm = fProgress
  
  lpString = Space$(128)
  sBuff = UCase$(Left$(lpString, _
          GetModuleFileName(GetClassLong(rForm.hwnd, GCL_HMODULE), lpString, _
          Len(lpString))))
  sBuff = GetFileName(sBuff)
  
  inIDE = (sBuff = "VB.EXE" Or sBuff = "VB5.EXE" Or sBuff = "VB6.EXE" Or _
           sBuff = "VB32.EXE")   'True = VB is running, and we are in design-time
  
End Function

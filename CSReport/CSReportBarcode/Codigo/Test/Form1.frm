VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   3090
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   4680
   LinkTopic       =   "Form1"
   ScaleHeight     =   3090
   ScaleWidth      =   4680
   StartUpPosition =   3  'Windows Default
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Form_Load()

  x

End Sub

Function x()

  Dim obj
  Set obj = CreateObject("CSReportBarcode.cBarcode")

  Dim pad_codigo
  pad_codigo = "3041094"
  pad_codigo = Trim("612" & Right("0000000000" & pad_codigo, 10))
  pad_codigo = dive(pad_codigo) & pad_codigo
  
  Debug.Print obj.Code128c(Trim(pad_codigo), 0)
  Debug.Print obj.Code128c(Trim(pad_codigo), 1)
  Debug.Print obj.Code128c(Trim(pad_codigo), 2)
  
  Debug.Print obj.EncodeTo128(Trim(pad_codigo))
  Debug.Print obj.Code128b(Trim(pad_codigo))

End Function

Function dive(pcodi)

  Dim wd01, wd02, wd03, wd04, wd05, wd06, wd07, wd08, wd09, wd10, wd11, wd12, wd13
  Dim wsuma, wdrsuma, wdigito
  wd01 = Right(Trim(CInt(Mid(pcodi, 13, 1)) * 3), 1)
  wd02 = Right(Trim(CInt(Mid(pcodi, 12, 1)) * 1), 1)
  wd03 = Right(Trim(CInt(Mid(pcodi, 11, 1)) * 7), 1)
  wd04 = Right(Trim(CInt(Mid(pcodi, 10, 1)) * 9), 1)
  wd05 = Right(Trim(CInt(Mid(pcodi, 9, 1)) * 3), 1)
  wd06 = Right(Trim(CInt(Mid(pcodi, 8, 1)) * 1), 1)
  wd07 = Right(Trim(CInt(Mid(pcodi, 7, 1)) * 7), 1)
  wd08 = Right(Trim(CInt(Mid(pcodi, 6, 1)) * 9), 1)
  wd09 = Right(Trim(CInt(Mid(pcodi, 5, 1)) * 3), 1)
  wd10 = Right(Trim(CInt(Mid(pcodi, 4, 1)) * 1), 1)
  wd11 = Right(Trim(CInt(Mid(pcodi, 3, 1)) * 7), 1)
  wd12 = Right(Trim(CInt(Mid(pcodi, 2, 1)) * 9), 1)
  wd13 = Right(Trim(CInt(Mid(pcodi, 1, 1)) * 3), 1)
  wsuma = CInt(wd01) + CInt(wd02) + CInt(wd03) + CInt(wd04) + CInt(wd05) + CInt(wd06) + CInt(wd07) + CInt(wd08) + CInt(wd09) + CInt(wd10) + CInt(wd11) + CInt(wd12) + CInt(wd13)
  wdrsuma = CInt(Right(Trim(wsuma), 1))
  wdigito = 10 - wdrsuma
  If wdigito = 10 Then
     wdigito = 0
  End If
  dive = Mid(wdigito, 1)
End Function


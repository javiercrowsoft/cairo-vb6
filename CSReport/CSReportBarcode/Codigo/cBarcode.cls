VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cBarcode"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Public Function EncodeTo128(DataToEncode As String) As String
  EncodeTo128 = Code128b(DataToEncode)
End Function

Public Function Code128a(DataToEncode As String) As String

  Dim i As Integer
  Dim PrintableString As String
  Dim WeightedTotal As Long
  Dim CurrentValue As Long
  Dim CheckDigitValue As Integer
  Dim CurrentCharNum As Integer
  Dim C128CheckDigit As String
  Dim StringLength As Integer

  PrintableString = ""
  WeightedTotal = 103
  PrintableString = ChrW(203)
  StringLength = Len(DataToEncode)
  For i = 1 To StringLength
    CurrentCharNum = AscW(Mid(DataToEncode, i, 1))
    If CurrentCharNum < 135 Then CurrentValue = CurrentCharNum - 32
    If CurrentCharNum > 134 Then CurrentValue = CurrentCharNum - 100
    CurrentValue = CurrentValue * i
    WeightedTotal = WeightedTotal + CurrentValue
    If CurrentCharNum = 32 Then CurrentCharNum = 194
    PrintableString = PrintableString & ChrW(CurrentCharNum)
  Next i
  CheckDigitValue = (WeightedTotal Mod 103)
  If CheckDigitValue < 95 And CheckDigitValue > 0 Then C128CheckDigit = ChrW(CheckDigitValue + 32)
  If CheckDigitValue > 94 Then C128CheckDigit = ChrW(CheckDigitValue + 100)
  If CheckDigitValue = 0 Then C128CheckDigit = ChrW(194)
  PrintableString = PrintableString & C128CheckDigit & ChrW(206)
   
  Code128a = PrintableString

End Function

Public Function Code128c(DataToEncode As String, Optional ReturnType As Integer = 0) As String
    
  Dim i As Integer
  Dim PrintableString As String
  Dim WeightedTotal As Long
  Dim CurrentValue As Long
  Dim CheckDigitValue As Integer
  Dim C128CheckDigit As String
  Dim StringLength As Integer
  Dim OnlyCorrectData As String
  Dim WeightValue As Long
    
    'Additional logic needed in case ReturnType is not entered
     If ReturnType <> 0 And ReturnType <> 1 And ReturnType <> 2 Then ReturnType = 0
     PrintableString = ""
     OnlyCorrectData = ""
     StringLength = Len(DataToEncode)
     For i = 1 To StringLength
          If IsNumeric(Mid(DataToEncode, i, 1)) Then OnlyCorrectData = OnlyCorrectData & Mid(DataToEncode, i, 1)
     Next i
     DataToEncode = OnlyCorrectData
     If (Len(DataToEncode) Mod 2) = 1 Then DataToEncode = "0" & DataToEncode
     PrintableString = ChrW(205)
     WeightedTotal = 105
     WeightValue = 1
     StringLength = Len(DataToEncode)
     For i = 1 To StringLength Step 2
          CurrentValue = CInt(Mid(DataToEncode, i, 2))
          If CurrentValue < 95 And CurrentValue > 0 Then PrintableString = PrintableString & ChrW(CurrentValue + 32)
          If CurrentValue > 94 Then PrintableString = PrintableString & ChrW(CurrentValue + 100)
          If CurrentValue = 0 Then PrintableString = PrintableString & ChrW(194)
          CurrentValue = CurrentValue * WeightValue
          WeightedTotal = WeightedTotal + CurrentValue
          WeightValue = WeightValue + 1
     Next i
     CheckDigitValue = (WeightedTotal Mod 103)
     If CheckDigitValue < 95 And CheckDigitValue > 0 Then C128CheckDigit = ChrW(CheckDigitValue + 32)
     If CheckDigitValue > 94 Then C128CheckDigit = ChrW(CheckDigitValue + 100)
     If CheckDigitValue = 0 Then C128CheckDigit = ChrW(194)
     If ReturnType = 0 Then Code128c = PrintableString & C128CheckDigit & ChrW(206)
     If ReturnType = 1 Then Code128c = DataToEncode & CheckDigitValue
     If ReturnType = 2 Then Code128c = Str(CheckDigitValue)
End Function

Public Function Code128b(DataToEncode As String) As String
  Dim i As Integer
  Dim PrintableString As String
  Dim WeightedTotal As Long
  Dim CurrentValue As Long
  Dim CurrentCharNum As Long
  Dim CheckDigitValue As Integer
  Dim C128CheckDigit As String
  Dim StringLength As Integer
     
     PrintableString = ""
     WeightedTotal = 104
     PrintableString = ChrW(204)
     StringLength = Len(DataToEncode)
     For i = 1 To StringLength
          CurrentCharNum = AscW(Mid(DataToEncode, i, 1))
          If CurrentCharNum < 135 Then CurrentValue = CurrentCharNum - 32
          If CurrentCharNum > 134 Then CurrentValue = CurrentCharNum - 100
          CurrentValue = CurrentValue * i
          WeightedTotal = WeightedTotal + CurrentValue
          If CurrentCharNum = 32 Then CurrentCharNum = 194
          PrintableString = PrintableString & ChrW(CurrentCharNum)
     Next i
     CheckDigitValue = (WeightedTotal Mod 103)
     If CheckDigitValue < 95 And CheckDigitValue > 0 Then C128CheckDigit = ChrW(CheckDigitValue + 32)
     If CheckDigitValue > 94 Then C128CheckDigit = ChrW(CheckDigitValue + 100)
     If CheckDigitValue = 0 Then C128CheckDigit = ChrW(194)
     PrintableString = PrintableString & C128CheckDigit & ChrW(206)
     Code128b = PrintableString
End Function


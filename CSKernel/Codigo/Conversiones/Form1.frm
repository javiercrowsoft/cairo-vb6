VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   3090
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   9480
   LinkTopic       =   "Form1"
   ScaleHeight     =   3090
   ScaleWidth      =   9480
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton Command3 
      Caption         =   "Ingles"
      Height          =   375
      Left            =   5880
      TabIndex        =   4
      Top             =   420
      Width           =   1275
   End
   Begin VB.CommandButton Command2 
      Caption         =   "Frances"
      Height          =   375
      Left            =   4380
      TabIndex        =   3
      Top             =   420
      Width           =   1275
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Español"
      Height          =   375
      Left            =   2880
      TabIndex        =   2
      Top             =   420
      Width           =   1275
   End
   Begin VB.TextBox Text2 
      Height          =   1155
      Left            =   240
      TabIndex        =   1
      Text            =   "Text2"
      Top             =   1440
      Width           =   9075
   End
   Begin VB.TextBox Text1 
      Height          =   375
      Left            =   300
      TabIndex        =   0
      Text            =   "123569784.365"
      Top             =   420
      Width           =   2115
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Public Function SecondsToString(ByVal count As Single) As String
  Dim hours  As Long
  Dim minutes As Long
  Dim second  As Long
  
  hours = count \ 3600
  minutes = (count Mod 3600) \ 60
  second = (count Mod 3600) Mod 60
  
  SecondsToString = Trim(hours) & ":" & Trim(minutes) & ":" & Trim(second)
End Function

Public Function SpanishNumberToString(ByVal iNumber As Double) As String
  Dim iDecimal    As Double
  Dim iMillion    As Double
  Dim iThousand   As Double
  Dim rtn         As String
 
  iNumber = Round(iNumber, 2)
  
  If iNumber >= 1000000 Then
    iMillion = pGetValue(iNumber, 1000000)
    If iNumber >= 2000000 Then
      rtn = pSpanishGetNumber(iMillion, True) & " Millones "
    Else
      rtn = pSpanishGetNumber(iMillion, True) & " Millon "
    End If
    iNumber = iNumber - (iMillion * 1000000)
  End If

  If iNumber >= 1000 Then
    iThousand = pGetValue(iNumber, 1000)
    rtn = rtn & pSpanishGetNumber(iThousand, True) & " Mil "
    iNumber = iNumber - (iThousand * 1000)
  End If

  rtn = rtn & pSpanishGetNumber(Int(iNumber), False)
  rtn = rtn & pSpanishGetDecimal(iNumber)
  
  SpanishNumberToString = UCase(Left$(rtn, 1)) & LCase(Mid$(rtn, 2))
End Function

Public Function FrenchNumberToString(ByVal iNumber As Double) As String
  Dim iDecimal    As Double
  Dim iMillion    As Double
  Dim iThousand   As Double
  Dim rtn         As String

  iNumber = Round(iNumber, 2)

  If iNumber >= 1000000 Then
    iMillion = pGetValue(iNumber, 1000000)
    If iNumber >= 2000000 Then
      rtn = pFrenchGetNumber(iMillion, True) & " Millions "
    Else
      rtn = pFrenchGetNumber(iMillion, True) & " Million "
    End If
    iNumber = iNumber - (iMillion * 1000000)
  End If

  If iNumber >= 1000 Then
    iThousand = pGetValue(iNumber, 1000)
    If iThousand = 1 Then
      rtn = " Mil "
    Else
      rtn = rtn & pFrenchGetNumber(iThousand, False) & " Mil "
    End If
    iNumber = iNumber - (iThousand * 1000)
  End If

  rtn = rtn & pFrenchGetNumber(Int(iNumber), False)
  rtn = rtn & pFrenchGetDecimal(iNumber)
  
  FrenchNumberToString = UCase(Left$(rtn, 1)) & LCase(Mid$(rtn, 2))
End Function

Public Function EnglishNumberToString(ByVal iNumber As Double) As String
  Dim iDecimal    As Double
  Dim iMillion    As Double
  Dim iThousand   As Double
  Dim rtn         As String
 
  iNumber = Round(iNumber, 2)
  
  If iNumber >= 1000000 Then
    iMillion = pGetValue(iNumber, 1000000)
    rtn = pEnglishGetNumber(iMillion, True) & " Million "
    iNumber = iNumber - (iMillion * 1000000)
  End If

  If iNumber >= 1000 Then
    iThousand = pGetValue(iNumber, 1000)
    rtn = rtn & pEnglishGetNumber(iThousand, True) & " Thousand "
    iNumber = iNumber - (iThousand * 1000)
  End If

  rtn = rtn & pEnglishGetNumber(Int(iNumber), False)
  rtn = rtn & pEnglishGetDecimal(iNumber)
  
  EnglishNumberToString = UCase(Left$(rtn, 1)) & LCase(Mid$(rtn, 2))
End Function

'///////////////////////////////////////////////////////////////////////////////////
' Español

Private Function pSpanishGetNumber(ByVal iNumber As Double, ByRef bPutOne As Boolean) As String
  Dim rtn         As String
  Dim iTens       As Double
  Dim iUnit       As Double
  Dim iNumAux     As Double
  Dim bPutOneAux  As Boolean
  
  If iNumber = 100 Then
    rtn = "Cien "
  Else
    If iNumber > 100 Then
      iNumAux = iNumber
      rtn = pSpanishGetNameHundred(iNumAux) & " "
      iTens = pGetHundred(iNumAux)
      bPutOne = False
    Else
      iTens = iNumber
    End If
  End If

  If iTens <> 0 Then
    If iTens >= 1 And iTens <= 15 Then
      bPutOneAux = bPutOne
      rtn = rtn & pSpanishGetNameNumber(iTens, bPutOneAux)
    Else
      If iTens >= 16 And iTens <= 19 Then
        rtn = rtn & "Dieci" & pSpanishGetNameNumber(Int(iTens - 10), bPutOne)
      Else
        If iTens = 20 Then
          rtn = rtn & "Veinte"
        Else
          If iTens >= 21 And iTens <= 29 Then
            rtn = rtn & "Venti" & pSpanishGetNameNumber(Int(iTens - 20), bPutOne)
          Else
            If iTens >= 30 Then
              rtn = rtn & pSpanishGetNameTens(iTens)
              iUnit = pGetUnit(iTens)
              rtn = rtn & IIf(iUnit = 0, "", " y ")
              rtn = rtn & pSpanishGetNameNumber(iUnit, bPutOne)
            End If
          End If
        End If
      End If
    End If
  End If
 
  pSpanishGetNumber = rtn
End Function

Private Function pSpanishGetNameNumber(ByVal iNumber As Double, ByRef bPutOne As Boolean) As String
  Select Case iNumber
    Case 1
      If bPutOne Then
        pSpanishGetNameNumber = "Un"
      Else
        pSpanishGetNameNumber = "Uno"
      End If
    Case 2
      pSpanishGetNameNumber = "Dos"
    Case 3
      pSpanishGetNameNumber = "Tres"
    Case 4
      pSpanishGetNameNumber = "Cuatro"
    Case 5
      pSpanishGetNameNumber = "Cinco"
    Case 6
      pSpanishGetNameNumber = "Seis"
    Case 7
      pSpanishGetNameNumber = "Siete"
    Case 8
      pSpanishGetNameNumber = "Ocho"
    Case 9
      pSpanishGetNameNumber = "Nueve"
    Case 10
      pSpanishGetNameNumber = "Diez"
    Case 11
      pSpanishGetNameNumber = "Once"
    Case 12
      pSpanishGetNameNumber = "Doce"
    Case 13
      pSpanishGetNameNumber = "Trece"
    Case 14
      pSpanishGetNameNumber = "Catorce"
    Case 15
      pSpanishGetNameNumber = "Quince"
  End Select
End Function
 
Private Function pSpanishGetNameHundred(ByVal iNumber As Double) As String
  Select Case iNumber
    Case Is >= 900
      pSpanishGetNameHundred = "Novecientos"
    Case Is >= 800
      pSpanishGetNameHundred = "Ochocientos"
    Case Is >= 700
      pSpanishGetNameHundred = "Setecientos"
    Case Is >= 600
      pSpanishGetNameHundred = "Seiscientos"
    Case Is >= 500
      pSpanishGetNameHundred = "Quinientos"
    Case Is >= 400
      pSpanishGetNameHundred = "Cuatrocientos"
    Case Is >= 300
      pSpanishGetNameHundred = "trescientos"
    Case Is >= 200
      pSpanishGetNameHundred = "Doscientos"
    Case Is >= 100
      pSpanishGetNameHundred = "Ciento"
  End Select
End Function
 
Private Function pSpanishGetNameTens(ByVal iNumber As Double) As String
  Select Case iNumber
    Case Is >= 90
      pSpanishGetNameTens = "Noventa"
    Case Is >= 80
      pSpanishGetNameTens = "Ochenta"
    Case Is >= 70
      pSpanishGetNameTens = "Setenta"
    Case Is >= 60
      pSpanishGetNameTens = "Sesenta"
    Case Is >= 50
      pSpanishGetNameTens = "Cincuenta"
    Case Is >= 40
      pSpanishGetNameTens = "Cuarenta"
    Case Is >= 30
      pSpanishGetNameTens = "Treinta"
  End Select
End Function

Private Function pSpanishGetDecimal(ByVal iNumber As Double) As String
  pSpanishGetDecimal = pGetDecimalAux(iNumber, "con")
End Function
 
'///////////////////////////////////////////////////////////////////////////////////
' Frances

Private Function pFrenchGetNumber(ByVal iNumber As Double, ByRef bPutOne As Boolean) As String
  Dim rtn         As String
  Dim iTens       As Double
  Dim iUnit       As Double
  Dim iNumAux     As Double
  Dim bPutOneAux  As Boolean
  
  If iNumber = 100 Then
    rtn = "Cent "
  Else
    If iNumber > 100 Then
      iNumAux = iNumber
      rtn = pFrenchGetNameHundred(iNumAux) & " "
      iTens = pGetHundred(iNumAux)
      bPutOne = False
    Else
      iTens = iNumber
    End If
  End If

  If iTens <> 0 Then
    If iTens >= 1 And iTens <= 16 Then
      bPutOneAux = bPutOne
      rtn = rtn & pFrenchGetNameNumber(iTens, bPutOneAux)
    Else
      If iTens >= 17 And iTens <= 19 Then
        rtn = rtn & "Dix " & pFrenchGetNameNumber(Int(iTens - 10), bPutOne)
      Else
        If iTens = 20 Then
          rtn = rtn & "Vingt"
        Else
          If iTens >= 21 And iTens <= 29 Then
            If iTens = 21 Then
              rtn = rtn & "Vingt et un"
            Else
              rtn = rtn & "Vingt " & pFrenchGetNameNumber(Int(iTens - 20), bPutOne)
            End If
          Else
            iUnit = pGetUnit(iTens)
            If Not (iTens >= 70 And iTens < 80) And Not (iTens >= 90) Then
              rtn = rtn & pFrenchGetNameTens(iTens)
              If iUnit = 1 Then
                rtn = rtn & " et "
              End If
              If iUnit > 1 Then
                rtn = rtn & " "
              End If
              rtn = rtn & pFrenchGetNameNumber(iUnit, bPutOne)
            Else
              rtn = rtn & pFrenchGetNameTens(iTens) + pFrenchGetNameNumber(iUnit + 10, True)
            End If
          End If
        End If
      End If
    End If
  End If
 
  pFrenchGetNumber = rtn
End Function

Private Function pFrenchGetNameNumber(ByVal iNumber As Double, bPutOne As Boolean) As String
  Select Case iNumber
    Case 1
      If bPutOne Then
        pFrenchGetNameNumber = "Un"
      Else
        pFrenchGetNameNumber = "Un"
      End If
    Case 2
      pFrenchGetNameNumber = "Deux"
    Case 3
      pFrenchGetNameNumber = "Trois"
    Case 4
      pFrenchGetNameNumber = "Quatre"
    Case 5
      pFrenchGetNameNumber = "Cinq"
    Case 6
      pFrenchGetNameNumber = "Six"
    Case 7
      pFrenchGetNameNumber = "Sept"
    Case 8
      pFrenchGetNameNumber = "Huit"
    Case 9
      pFrenchGetNameNumber = "Neuf"
    Case 10
      pFrenchGetNameNumber = "Dix"
    Case 11
      pFrenchGetNameNumber = "Onze"
    Case 12
      pFrenchGetNameNumber = "Douze"
    Case 13
      pFrenchGetNameNumber = "Treize"
    Case 14
      pFrenchGetNameNumber = "Quatorze"
    Case 15
      pFrenchGetNameNumber = "Quinze"
    Case 16
      pFrenchGetNameNumber = "Seize"
    Case 17, 18, 19
      pFrenchGetNameNumber = "Dix " & pFrenchGetNameNumber(Int(iNumber - 10), bPutOne)
  End Select
End Function

Private Function pFrenchGetNameHundred(ByVal iNumber As Double) As String
  Dim rtn As String
  
  Select Case iNumber
    Case Is >= 900
      rtn = "Neuf "
    Case Is >= 800
      rtn = "Huit "
    Case Is >= 700
      rtn = "Sept "
    Case Is >= 600
      rtn = "Six "
    Case Is >= 500
      rtn = "Cinq "
    Case Is >= 400
      rtn = "Quatre "
    Case Is >= 300
      rtn = "Trois "
    Case Is >= 200
      rtn = "Deux "
    Case Is >= 100
      rtn = ""
  End Select
  
  If iNumber >= 200 Then
    rtn = rtn & "Cents"
  Else
    rtn = rtn & "Cent"
  End If
  
  pFrenchGetNameHundred = rtn
End Function

Private Function pFrenchGetNameTens(ByVal iNumber As Double) As String
  Select Case iNumber
    Case Is >= 90
      pFrenchGetNameTens = "Quatre Vingt "
    Case Is >= 80
      pFrenchGetNameTens = "Quatre Vingt"
    Case Is >= 70
      pFrenchGetNameTens = "Soixante "
    Case Is >= 60
      pFrenchGetNameTens = "Soixante"
    Case Is >= 50
      pFrenchGetNameTens = "Cinquante"
    Case Is >= 40
      pFrenchGetNameTens = "Quarante"
    Case Is >= 30
      pFrenchGetNameTens = "Treinte"
  End Select
End Function

Private Function pFrenchGetDecimal(ByVal iNumber As Double) As String
  pFrenchGetDecimal = pGetDecimalAux(iNumber, "Avec")
End Function
    
'///////////////////////////////////////////////////////////////////////////////////
' Ingles
    
Private Function pEnglishGetNumber(ByVal iNumber As Double, ByRef bPutOne As Boolean) As String
  Dim rtn         As String
  Dim iTens       As Double
  Dim iUnit       As Double
  Dim iNumAux     As Double
  Dim bPutOneAux  As Boolean
  
  If iNumber = 100 Then
    rtn = "Hundred "
  Else
    If iNumber > 100 Then
      iNumAux = iNumber
      rtn = pEnglishGetNameHundred(iNumAux) & " "
      iTens = pGetHundred(iNumAux)
      bPutOne = False
    Else
      iTens = iNumber
    End If
  End If

  If iTens <> 0 Then
    If iTens >= 1 And iTens <= 15 Then
      bPutOneAux = bPutOne
      rtn = rtn & pEnglishGetNameNumber(iTens)
    Else
      If iTens >= 16 And iTens <= 19 Then
        rtn = rtn & pEnglishGetNameNumber(Int(iTens - 10)) & "teen"
      Else
        If iTens = 20 Then
          rtn = rtn & "twenty"
        Else
          rtn = rtn & pEnglishGetNameTens(iTens)
          iUnit = pGetUnit(iTens)
          'rtn = rtn & IIf(iUnit = 0, "", " and ")
          rtn = rtn & " "
          rtn = rtn & pEnglishGetNameNumber(iUnit)
        End If
      End If
    End If
  End If
 
  pEnglishGetNumber = rtn
End Function

Private Function pEnglishGetNameNumber(ByVal iNumber As Double) As String
  Select Case iNumber
    Case 1
      pEnglishGetNameNumber = "One"
    Case 2
      pEnglishGetNameNumber = "Two"
    Case 3
      pEnglishGetNameNumber = "Three"
    Case 4
      pEnglishGetNameNumber = "Four"
    Case 5
      pEnglishGetNameNumber = "Five"
    Case 6
      pEnglishGetNameNumber = "Six"
    Case 7
      pEnglishGetNameNumber = "Seven"
    Case 8
      pEnglishGetNameNumber = "Eight"
    Case 9
      pEnglishGetNameNumber = "Nine"
    Case 10
      pEnglishGetNameNumber = "Ten"
    Case 11
      pEnglishGetNameNumber = "Eleven"
    Case 12
      pEnglishGetNameNumber = "Twelve"
    Case 13
      pEnglishGetNameNumber = "Thirteen"
    Case 14
      pEnglishGetNameNumber = "Fourteen"
    Case 15
      pEnglishGetNameNumber = "Fifteen"
  End Select
End Function
 
Private Function pEnglishGetNameHundred(ByVal iNumber As Double) As String
  pEnglishGetNameHundred = pEnglishGetNameNumber(Fix(iNumber / 100)) & " Hundred"
End Function
 
Private Function pEnglishGetNameTens(ByVal iNumber As Double) As String
  Select Case iNumber
    Case Is >= 90
      pEnglishGetNameTens = "Ninety"
    Case Is >= 80
      pEnglishGetNameTens = "Eighty"
    Case Is >= 70
      pEnglishGetNameTens = "Seventy"
    Case Is >= 60
      pEnglishGetNameTens = "Sixty"
    Case Is >= 50
      pEnglishGetNameTens = "Fifty"
    Case Is >= 40
      pEnglishGetNameTens = "Forty"
    Case Is >= 30
      pEnglishGetNameTens = "Thirty"
    Case Is >= 20
      pEnglishGetNameTens = "Twenty"
  End Select
End Function

Private Function pEnglishGetDecimal(ByVal iNumber As Double) As String
  pEnglishGetDecimal = pGetDecimalAux(iNumber, "with")
End Function
    
' Primitivas sin lenguaje
Private Function pGetDecimalAux(ByVal iNumber As Double, ByVal Word As String) As String
  Dim iDecimal As Double
  
  iNumber = Round(iNumber, 2)
  iDecimal = Round((iNumber - Int(iNumber)) * 100, 2)
  If iDecimal <> 0 Then
    pGetDecimalAux = " " & Word & " " & Trim(CStr(iDecimal)) & "/100"
  End If
End Function

Private Function pGetUnit(ByVal iTens As Double) As Double
  pGetUnit = iTens - (Int(iTens / 10) * 10)
End Function
 
Private Function pGetHundred(ByVal iHundred As Double) As Double
  pGetHundred = iHundred - (Int(iHundred / 100) * 100)
End Function
 
Private Function pGetValue(ByVal iNumber As Double, ByVal iDividing As Double) As Double
  pGetValue = Int(Int(iNumber) / iDividing)
End Function

Private Sub Command1_Click()
  If Not IsNumeric(Text1.Text) Then Exit Sub
  Text2.Text = SpanishNumberToString(CDbl(Text1.Text))
End Sub

Private Sub Command2_Click()
  If Not IsNumeric(Text1.Text) Then Exit Sub
  Text2.Text = FrenchNumberToString(CDbl(Text1.Text))
End Sub

Private Sub Command3_Click()
  If Not IsNumeric(Text1.Text) Then Exit Sub
  Text2.Text = EnglishNumberToString(CDbl(Text1.Text))
End Sub

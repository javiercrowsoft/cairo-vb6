Attribute VB_Name = "mColouriseGlyph"
Option Explicit

Private Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" ( _
    lpvDest As Any, lpvSource As Any, ByVal cbCopy As Long)

Private Type SAFEARRAYBOUND
    cElements As Long
    lLbound As Long
End Type
Private Type SAFEARRAY2D
    cDims As Integer
    fFeatures As Integer
    cbElements As Long
    cLocks As Long
    pvData As Long
    Bounds(0 To 1) As SAFEARRAYBOUND
End Type
Private Declare Function VarPtrArray Lib "msvbvm60.dll" Alias "VarPtr" (Ptr() As Any) As Long
Private Declare Function GetPixelAPI Lib "gdi32" Alias "GetPixel" (ByVal hdc As Long, ByVal x As Long, ByVal y As Long) As Long

Public Sub ColouriseWatermark( _
      cWatermark As pcAlphaDibSection, _
      ByVal lBackColor As OLE_COLOR _
   )
Dim lRefColor As Long
Dim hueRef As Single, satRef As Single, lumRef As Single
Dim redRef As Long, greenRef As Long, blueRef As Long
Dim hueTo As Single, satTo As Single, lumTo As Single
Dim redTo As Long, greenTo As Long, blueTo As Long

   ' Get the reference colour & its luminance value:
   lRefColor = GetPixelAPI(cWatermark.hdc, 0, 0)
   redRef = (lRefColor And &HFF&)
   greenRef = (lRefColor And &HFF00&) \ &H100&
   blueRef = (lRefColor And &HFF0000) \ &H10000
   RGBToHSL redRef, greenRef, blueRef, _
      hueRef, satRef, lumRef

   ' Now get the back colour we're colourising to:
   lBackColor = TranslateColor(lBackColor)
   redTo = (lBackColor And &HFF&)
   greenTo = (lBackColor And &HFF00&) \ &H100&
   blueTo = (lBackColor And &HFF0000) \ &H10000
   RGBToHSL redTo, greenTo, blueTo, _
      hueTo, satTo, lumTo
   
   ' Now loop through everything in the watermark,
   ' adjusting the hue, saturation and lumination
   ' according to the desired background colour:
Dim bDib() As Byte
Dim x As Long, y As Long
Dim tSA As SAFEARRAY2D
Dim huePixel As Single, satPixel As Single, lumPixel As Single
Dim redPixel As Long, greenPixel As Long, bluePixel As Long
Dim lBytesPerScanLine As Long
Dim fLumOffset As Single
   
   ' Get the bits in the from DIB section:
   With tSA
      .cbElements = 1
      .cDims = 2
      .Bounds(0).lLbound = 0
      .Bounds(0).cElements = cWatermark.Height
      .Bounds(1).lLbound = 0
      .Bounds(1).cElements = cWatermark.BytesPerScanLine()
      .pvData = cWatermark.DIBSectionBitsPtr
   End With
   CopyMemory ByVal VarPtrArray(bDib()), VarPtr(tSA), 4

   lBytesPerScanLine = cWatermark.BytesPerScanLine
   For y = 0 To cWatermark.Height - 1
      For x = 0 To lBytesPerScanLine - 1 Step 4
         
         ' Get H,S, L of pixel:
         RGBToHSL bDib(x + 2, y), bDib(x + 1, y), bDib(x, y), _
            huePixel, satPixel, lumPixel
         ' Determine the offset of lumPixel from the reference
         ' lumPixel
         fLumOffset = lumPixel / lumRef
         ' Apply the luminance offset to the reference luminance:
         lumPixel = lumTo * fLumOffset
         
         ' Calculate the new colour:
         HLSToRGB hueTo, satTo, lumPixel, redPixel, greenPixel, bluePixel
         
         ' Set it:
         bDib(x + 3, y) = 255
         bDib(x + 2, y) = redPixel
         bDib(x + 1, y) = greenPixel
         bDib(x, y) = bluePixel
   
      Next x
   Next y
   
    ' Clear the temporary array descriptor
    ' (This does not appear to be necessary, but
    ' for safety do it anyway)
    CopyMemory ByVal VarPtrArray(bDib), 0&, 4

End Sub

Public Sub ColouriseGlyph( _
      cGlyph As pcAlphaDibSection, _
      ByVal lBackColor As OLE_COLOR _
   )
Dim lTransColor As Long
Dim hueTrans As Single, satTrans As Single, lumTrans As Single
Dim redTrans As Long, greenTrans As Long, blueTrans As Long
Dim hueBack As Single, satBack As Single, lumBack As Single
Dim redBack As Long, greenBack As Long, blueBack As Long

   ' Get transparent colour & its luminance value:
   lTransColor = GetPixelAPI(cGlyph.hdc, 1, 1)
   redTrans = (lTransColor And &HFF&)
   greenTrans = (lTransColor And &HFF00&) \ &H100&
   blueTrans = (lTransColor And &HFF0000) \ &H10000
   RGBToHSL redTrans, greenTrans, blueTrans, _
      hueTrans, satTrans, lumTrans
   
   ' Get base luminance value of the background colour:
   lBackColor = TranslateColor(lBackColor)
   redBack = (lBackColor And &HFF&)
   greenBack = (lBackColor And &HFF00&) \ &H100&
   blueBack = (lBackColor And &HFF0000) \ &H10000
   RGBToHSL redBack, greenBack, blueBack, _
      hueBack, satBack, lumBack
      
   ' Now loop through everything in the glyph,
   ' adjusting the hue, saturation and lumination
   ' according to the desired background colour:
Dim bDib() As Byte
Dim x As Long, y As Long
Dim tSA As SAFEARRAY2D
Dim huePixel As Single, satPixel As Single, lumPixel As Single
Dim redPixel As Long, greenPixel As Long, bluePixel As Long
Dim lBytesPerScanLine As Long
Dim fLumOffset As Single
    
   ' Get the bits in the from DIB section:
   With tSA
      .cbElements = 1
      .cDims = 2
      .Bounds(0).lLbound = 0
      .Bounds(0).cElements = cGlyph.Height
      .Bounds(1).lLbound = 0
      .Bounds(1).cElements = cGlyph.BytesPerScanLine()
      .pvData = cGlyph.DIBSectionBitsPtr
   End With
   CopyMemory ByVal VarPtrArray(bDib()), VarPtr(tSA), 4

   lBytesPerScanLine = cGlyph.BytesPerScanLine
   For y = 0 To cGlyph.Height - 1
      For x = 0 To lBytesPerScanLine - 1 Step 4
         ' Check whether transparent:
         If (redTrans = bDib(x + 2, y) And _
            greenTrans = bDib(x + 1, y) And _
            blueTrans = bDib(x + 2, y)) Then
            bDib(x + 3, y) = 255
            bDib(x + 2, y) = redBack
            bDib(x + 1, y) = greenBack
            bDib(x, y) = blueBack
         Else
            ' Get HSL of pixel:
            RGBToHSL bDib(x + 2, y), bDib(x + 1, y), bDib(x, y), _
               huePixel, satPixel, lumPixel
            ' Determine luminance offset from trans colour:
            fLumOffset = lumPixel / lumTrans
            If (lumPixel > 0.9) Then
               ' here you really want a function which
               ' maps items to lumBack at lumPixel = 0.9
               ' through to 1.0 luminance at lumPixel = 1.0
               ' but we don't need it here.
            Else
               lumPixel = lumBack * fLumOffset
               If (lumPixel > 1#) Then lumPixel = 1#
            End If
            
            ' Create a version of the back colour with
            ' this luminance offset:
            HLSToRGB hueBack, satBack, lumPixel, _
               redPixel, greenPixel, bluePixel
            bDib(x + 3, y) = 255
            bDib(x + 2, y) = redPixel
            bDib(x + 1, y) = greenPixel
            bDib(x, y) = bluePixel
         End If
      Next x
   Next y
   
    ' Clear the temporary array descriptor
    ' (This does not appear to be necessary, but
    ' for safety do it anyway)
    CopyMemory ByVal VarPtrArray(bDib), 0&, 4
   
End Sub


Private Sub RGBToHSL( _
      ByVal r As Long, ByVal g As Long, ByVal b As Long, _
      h As Single, s As Single, l As Single _
   )
Dim Max As Single
Dim Min As Single
Dim delta As Single
Dim rR As Single, rG As Single, rB As Single

   rR = r / 255: rG = g / 255: rB = b / 255

'{Given: rgb each in [0,1].
' Desired: h in [0,360] and s in [0,1], except if s=0, then h=UNDEFINED.}
        Max = Maximum(rR, rG, rB)
        Min = Minimum(rR, rG, rB)
        l = (Max + Min) / 2    '{This is the lightness}
        '{Next calculate saturation}
        If Max = Min Then
            'begin {Acrhomatic case}
            s = 0
            h = 0
           'end {Acrhomatic case}
        Else
           'begin {Chromatic case}
                '{First calculate the saturation.}
           If l <= 0.5 Then
               s = (Max - Min) / (Max + Min)
           Else
               s = (Max - Min) / (2 - Max - Min)
            End If
            '{Next calculate the hue.}
            delta = Max - Min
           If rR = Max Then
                h = (rG - rB) / delta    '{Resulting color is between yellow and magenta}
           ElseIf rG = Max Then
                h = 2 + (rB - rR) / delta '{Resulting color is between cyan and yellow}
           ElseIf rB = Max Then
                h = 4 + (rR - rG) / delta '{Resulting color is between magenta and cyan}
            End If
            'Debug.Print h
            'h = h * 60
           'If h < 0# Then
           '     h = h + 360            '{Make degrees be nonnegative}
           'End If
        'end {Chromatic Case}
      End If
'end {RGB_to_HLS}
End Sub

Private Sub HLSToRGB( _
      ByVal h As Single, ByVal s As Single, ByVal l As Single, _
      r As Long, g As Long, b As Long _
   )
Dim rR As Single, rG As Single, rB As Single
Dim Min As Single, Max As Single

   If s = 0 Then
      ' Achromatic case:
      rR = l: rG = l: rB = l
   Else
      ' Chromatic case:
      ' delta = Max-Min
      If l <= 0.5 Then
         's = (Max - Min) / (Max + Min)
         ' Get Min value:
         Min = l * (1 - s)
      Else
         's = (Max - Min) / (2 - Max - Min)
         ' Get Min value:
         Min = l - s * (1 - l)
      End If
      ' Get the Max value:
      Max = 2 * l - Min
      
      ' Now depending on sector we can evaluate the h,l,s:
      If (h < 1) Then
         rR = Max
         If (h < 0) Then
            rG = Min
            rB = rG - h * (Max - Min)
         Else
            rB = Min
            rG = h * (Max - Min) + rB
         End If
      ElseIf (h < 3) Then
         rG = Max
         If (h < 2) Then
            rB = Min
            rR = rB - (h - 2) * (Max - Min)
         Else
            rR = Min
            rB = (h - 2) * (Max - Min) + rR
         End If
      Else
         rB = Max
         If (h < 4) Then
            rR = Min
            rG = rR - (h - 4) * (Max - Min)
         Else
            rG = Min
            rR = (h - 4) * (Max - Min) + rG
         End If
         
      End If
            
   End If
   r = rR * 255: g = rG * 255: b = rB * 255
End Sub
Private Function Maximum(rR As Single, rG As Single, rB As Single) As Single
   If (rR > rG) Then
      If (rR > rB) Then
         Maximum = rR
      Else
         Maximum = rB
      End If
   Else
      If (rB > rG) Then
         Maximum = rB
      Else
         Maximum = rG
      End If
   End If
End Function
Private Function Minimum(rR As Single, rG As Single, rB As Single) As Single
   If (rR < rG) Then
      If (rR < rB) Then
         Minimum = rR
      Else
         Minimum = rB
      End If
   Else
      If (rB < rG) Then
         Minimum = rB
      Else
         Minimum = rG
      End If
   End If
End Function





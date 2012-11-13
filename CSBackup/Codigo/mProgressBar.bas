Attribute VB_Name = "mProgressBar"
Option Explicit

'-----------------------------------------------------------
' SUB: UpdateStatus
'
' "Fill" (by percentage) inside the PictureBox and also
' display the percentage filled
'
' IN: [pic] - PictureBox used to bound "fill" region
'   [sngPercent] - Percentage of the shape to fill
'   [fBorderCase] - Indicates whether the percentage
'    specified is a "border case", i.e. exactly 0%
'    or exactly 100%.  Unless fBorderCase is True,
'    the values 0% and 100% will be assumed to be
'    "close" to these values, and 1% and 99% will
'    be used instead.
'
' Notes: Set AutoRedraw property of the PictureBox to True
'    so that the status bar and percentage can be auto-
'    matically repainted if necessary
'-----------------------------------------------------------
'
Sub UpdateStatus(pic As PictureBox, ByVal sngPercent As Single, Optional ByVal fBorderCase As Boolean = False)
  On Error Resume Next
  
  Dim strPercent As String
  Dim intX As Integer
  Dim intY As Integer
  Dim intWidth As Integer
  Dim intHeight As Integer

  'For this to work well, we need a white background and any color foreground (blue)
  Const colBackground = &HFFFFFF ' white
  Const colForeground = &H80C0FF ' orange

  pic.ForeColor = colForeground
  pic.BackColor = colBackground
  
  '
  'Format percentage and get attributes of text
  '
  Dim intPercent
  intPercent = Int(100 * sngPercent + 0.5)
  
  'Never allow the percentage to be 0 or 100 unless it is exactly that value.  This
  'prevents, for instance, the status bar from reaching 100% until we are entirely done.
  If intPercent = 0 Then
    If Not fBorderCase Then
      intPercent = 1
    End If
  ElseIf intPercent = 100 Then
    If Not fBorderCase Then
      intPercent = 99
    End If
  End If
  
  strPercent = Format$(intPercent) & "%"
  intWidth = pic.TextWidth(strPercent)
  intHeight = pic.TextHeight(strPercent)

  '
  'Now set intX and intY to the starting location for printing the percentage
  '
  intX = pic.Width / 2 - intWidth / 2
  intY = pic.Height / 2 - intHeight / 2

  '
  'Need to draw a filled box with the pics background color to wipe out previous
  'percentage display (if any)
  '
  pic.DrawMode = 13 ' Copy Pen
  pic.Line (intX, intY)-Step(intWidth, intHeight), pic.BackColor, BF

  '
  'Back to the center print position and print the text
  '
  pic.CurrentX = intX
  pic.CurrentY = intY
  pic.Print strPercent

  '
  'Now fill in the box with the ribbon color to the desired percentage
  'If percentage is 0, fill the whole box with the background color to clear it
  'Use the "Not XOR" pen so that we change the color of the text to white
  'wherever we touch it, and change the color of the background to blue
  'wherever we touch it.
  '
  
  pic.DrawMode = 10 ' Not XOR Pen
  If sngPercent > 0 Then
    pic.Line (0, 0)-(pic.Width * sngPercent, pic.Height), pic.ForeColor, BF
  Else
    pic.Line (0, 0)-(pic.Width, pic.Height), pic.BackColor, BF
  End If

  pic.Refresh
  
  Err.Clear
End Sub

VERSION 5.00
Begin VB.Form Form1 
   BackColor       =   &H00FFFFFF&
   Caption         =   "Test"
   ClientHeight    =   7050
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   6930
   LinkTopic       =   "Form1"
   ScaleHeight     =   7050
   ScaleWidth      =   6930
   StartUpPosition =   3  'Windows Default
   Begin VB.PictureBox picHand 
      Height          =   495
      Left            =   2880
      Picture         =   "Form1.frx":0000
      ScaleHeight     =   435
      ScaleWidth      =   1155
      TabIndex        =   26
      Top             =   3300
      Visible         =   0   'False
      Width           =   1215
   End
   Begin VB.Frame Frame2 
      BackColor       =   &H00FFFFFF&
      BorderStyle     =   0  'None
      Height          =   315
      Left            =   4620
      TabIndex        =   22
      Top             =   1320
      Width           =   1515
      Begin VB.OptionButton opLinesNo 
         BackColor       =   &H00FFFFFF&
         Caption         =   "No"
         Height          =   315
         Left            =   660
         TabIndex        =   24
         Top             =   0
         Width           =   615
      End
      Begin VB.OptionButton opLinesYes 
         BackColor       =   &H00FFFFFF&
         Caption         =   "Yes"
         Height          =   315
         Left            =   0
         TabIndex        =   23
         Top             =   0
         Width           =   615
      End
   End
   Begin VB.Frame Frame1 
      BackColor       =   &H00FFFFFF&
      BorderStyle     =   0  'None
      Height          =   315
      Left            =   4620
      TabIndex        =   18
      Top             =   900
      Width           =   1515
      Begin VB.OptionButton opValuesYes 
         BackColor       =   &H00FFFFFF&
         Caption         =   "Yes"
         Height          =   315
         Left            =   0
         TabIndex        =   20
         Top             =   0
         Width           =   615
      End
      Begin VB.OptionButton opValuesNo 
         BackColor       =   &H00FFFFFF&
         Caption         =   "No"
         Height          =   315
         Left            =   660
         TabIndex        =   19
         Top             =   0
         Width           =   615
      End
   End
   Begin VB.ComboBox cbChartSize 
      Height          =   315
      Left            =   4740
      Style           =   2  'Dropdown List
      TabIndex        =   15
      Top             =   1740
      Width           =   1515
   End
   Begin VB.ComboBox cbChartThickness 
      Height          =   315
      Left            =   4740
      Style           =   2  'Dropdown List
      TabIndex        =   14
      Top             =   2160
      Width           =   1515
   End
   Begin VB.ComboBox cbLinesType 
      Height          =   315
      Left            =   1620
      Style           =   2  'Dropdown List
      TabIndex        =   11
      Top             =   2160
      Width           =   1515
   End
   Begin VB.ComboBox cbAlternateColor 
      Height          =   315
      Left            =   1620
      Style           =   2  'Dropdown List
      TabIndex        =   9
      Top             =   1740
      Width           =   1515
   End
   Begin VB.ComboBox cbPrimaryColor 
      Height          =   315
      Left            =   1620
      Style           =   2  'Dropdown List
      TabIndex        =   7
      Top             =   1320
      Width           =   1515
   End
   Begin VB.ComboBox cbType 
      Height          =   315
      Left            =   1620
      Style           =   2  'Dropdown List
      TabIndex        =   3
      Top             =   900
      Width           =   1515
   End
   Begin VB.ComboBox cbFormatType 
      Height          =   315
      Left            =   1620
      Style           =   2  'Dropdown List
      TabIndex        =   2
      Top             =   480
      Width           =   3435
   End
   Begin VB.TextBox txFile 
      Height          =   285
      Left            =   1620
      TabIndex        =   1
      Text            =   "d:\proyectos\cschart\codigo\test\prueba.jpg"
      Top             =   120
      Width           =   4575
   End
   Begin VB.CommandButton cmdMake 
      Caption         =   "Crear"
      Height          =   315
      Left            =   120
      TabIndex        =   0
      Top             =   2760
      Width           =   975
   End
   Begin VB.Label lbLink 
      BackStyle       =   0  'Transparent
      Caption         =   "http://www.crowsoft.com.ar"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00C00000&
      Height          =   315
      Left            =   1980
      TabIndex        =   25
      Top             =   2760
      Width           =   4695
   End
   Begin VB.Label Label10 
      Alignment       =   1  'Right Justify
      BackColor       =   &H00FFFFFF&
      BackStyle       =   0  'Transparent
      Caption         =   "Show Outlines"
      Height          =   315
      Left            =   3300
      TabIndex        =   21
      Top             =   1320
      Width           =   1215
   End
   Begin VB.Label Label9 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Pie Chart Size"
      Height          =   255
      Left            =   3300
      TabIndex        =   17
      Top             =   1800
      Width           =   1335
   End
   Begin VB.Label Label8 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Pie Chart Thickness"
      Height          =   255
      Left            =   3180
      TabIndex        =   16
      Top             =   2220
      Width           =   1455
   End
   Begin VB.Line Line2 
      BorderColor     =   &H80000003&
      X1              =   0
      X2              =   15000
      Y1              =   3180
      Y2              =   3180
   End
   Begin VB.Label Label7 
      Alignment       =   1  'Right Justify
      BackColor       =   &H00FFFFFF&
      BackStyle       =   0  'Transparent
      Caption         =   "Bar Values"
      Height          =   315
      Left            =   3300
      TabIndex        =   13
      Top             =   900
      Width           =   1215
   End
   Begin VB.Label Label6 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Bar Grid Lines"
      Height          =   255
      Left            =   120
      TabIndex        =   12
      Top             =   2220
      Width           =   1335
   End
   Begin VB.Label Label5 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Bar Alternate Color"
      Height          =   255
      Left            =   120
      TabIndex        =   10
      Top             =   1800
      Width           =   1335
   End
   Begin VB.Label Label4 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Bar Primary Color"
      Height          =   255
      Left            =   120
      TabIndex        =   8
      Top             =   1380
      Width           =   1335
   End
   Begin VB.Image imgChart 
      Height          =   2475
      Left            =   960
      Top             =   3420
      Width           =   1875
   End
   Begin VB.Line Line1 
      BorderColor     =   &H80000003&
      X1              =   0
      X2              =   15000
      Y1              =   2640
      Y2              =   2640
   End
   Begin VB.Label Label3 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Type"
      Height          =   255
      Left            =   720
      TabIndex        =   6
      Top             =   960
      Width           =   735
   End
   Begin VB.Label Label2 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Format"
      Height          =   255
      Left            =   720
      TabIndex        =   5
      Top             =   540
      Width           =   735
   End
   Begin VB.Label Label1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "File"
      Height          =   255
      Left            =   720
      TabIndex        =   4
      Top             =   180
      Width           =   735
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'/////////////////////////////////////////////////////////////////////////////////////////
' CopyRight © 2003-2005 Javier Alvarez (javier@crowsoft.com.ar)

' This library is free software; you can redistribute it and/or modify
' it under the terms of the GNU Lesser Gereral Public Licence as published
' by the Free Software Foundation; either version 2 of the Licence,
' or (at your opinion) any later version.

' This library is distributed in the hope that it will be usefull,
' but WITHOUT ANY WARRANTY; without even the implied warranty of merchantability
' or fitness for a particular purpose. See the GNU Lesser General Public Licence
' for more details.

' You should have received a copy of the GNU Lesser General Public Licence
' along with this library; if not, write to the Free Software Foundation, Inc.,
' 59 Temple Place, Suite 330, Boston, Ma 02111-1307 USA.

' Visit CrowSoft.
'    http://www.crowsoft.com.ar
'/////////////////////////////////////////////////////////////////////////////////////////
    
    Private Const SW_SHOWNORMAL = 1
    
    Private Const ERROR_PATH_NOT_FOUND = 3&
    Private Const ERROR_BAD_FORMAT = 11&
    Private Const SE_ERR_ACCESSDENIED = 5            '  access denied
    Private Const SE_ERR_ASSOCINCOMPLETE = 27
    Private Const SE_ERR_DDEBUSY = 30
    Private Const SE_ERR_DDEFAIL = 29
    Private Const SE_ERR_DDETIMEOUT = 28
    Private Const SE_ERR_DLLNOTFOUND = 32
    Private Const SE_ERR_FNF = 2                     '  file not found
    Private Const SE_ERR_NOASSOC = 31
    Private Const SE_ERR_OOM = 8                     '  out of memory
    Private Const SE_ERR_PNF = 3                     '  path not found
    Private Const SE_ERR_SHARE = 26

Private Declare Function ShellExecute2 Lib "shell32.dll" Alias "ShellExecuteA" (ByVal hwnd As Long, ByVal lpOperation As String, ByVal lpFile As String, ByVal lpParameters As String, ByVal lpDirectory As String, ByVal nShowCmd As Long) As Long

Private Function pGetFormat() As eChartFormat
  Select Case cbFormatType.ListIndex
    Case eImageFormat.Bmp
      pGetFormat = eChartFormat.Bmp
    Case eImageFormat.Jpeg
      pGetFormat = eChartFormat.Jpeg
    Case eImageFormat.Gif
      pGetFormat = eChartFormat.Png
    Case eImageFormat.Png
      pGetFormat = eChartFormat.Png
    Case eImageFormat.Tiff
      pGetFormat = eChartFormat.Bmp
  End Select
End Function

Private Function pGetExt() As String
  Select Case cbFormatType.ListIndex
    Case eImageFormat.Bmp
      pGetExt = ".bmp"
    Case eImageFormat.Jpeg
      pGetExt = ".jpg"
    Case eImageFormat.Gif
      pGetExt = ".gif"
    Case eImageFormat.Png
      pGetExt = ".png"
    Case eImageFormat.Tiff
      pGetExt = ".tif"
  End Select
End Function

Private Sub cmdMake_Click()
  On Error GoTo ControlError
  Dim chart As cWebChart
  Set chart = New cWebChart
  
  Screen.MousePointer = vbHourglass
  Me.Caption = "Test - Creando el grafico"
  
  chart.NewChartType cbType.ListIndex, "Chart sample"
  
  pFill chart
  
  chart.ColorAlternate = cbAlternateColor.ItemData(cbAlternateColor.ListIndex)
  chart.ColorPrimary = cbPrimaryColor.ItemData(cbPrimaryColor.ListIndex)
  
  chart.GridLines = cbLinesType.ListIndex
  chart.OutlineBars = IIf(opLinesYes.Value, True, False)
  chart.ShowValues = IIf(opValuesYes.Value, True, False)
  
  chart.Thickness = cbChartThickness.ItemData(cbChartThickness.ListIndex)
  chart.Diameter = cbChartSize.ItemData(cbChartSize.ListIndex)
  
  chart.Format = pGetFormat()
  chart.SaveTo = SaveToFile
  chart.FileName = txFile.Text & pGetExt()
  
  pKillFile
  
  chart.CopyRight = "© CrowSoft 2005"
  chart.RenderWebChartImage
  
  ShowChart
  
  GoTo ExitProc
ControlError:
  If Err.Number Then
    MsgBox Err.Description
    Resume ExitProc
  End If
ExitProc:
  On Error Resume Next
  chart.Dispose
  Set chart = Nothing
  Screen.MousePointer = vbDefault
  Me.Caption = "Test"
End Sub

Private Sub Form_Load()
  txFile.Text = App.Path & "\prueba"
  cbFormatType.AddItem "BMP"
  cbFormatType.AddItem "JPG"
  cbFormatType.AddItem "GIF"
  cbFormatType.AddItem "PNG"
  cbFormatType.AddItem "TIFF"
  cbFormatType.ListIndex = 1
  
  cbType.AddItem "Pie"
  cbType.AddItem "Bar"
  cbType.ListIndex = 0
  
  opLinesYes.Value = True
  opValuesYes.Value = True
  
  pFillColors cbPrimaryColor
  cbPrimaryColor.ListIndex = 11
  
  pFillColors cbAlternateColor
  cbAlternateColor.ListIndex = 70

  cbChartSize.AddItem "Smallest"

  cbChartSize.AddItem "Smallest": cbChartSize.ItemData(cbChartSize.NewIndex) = 50
  cbChartSize.AddItem "Smaller": cbChartSize.ItemData(cbChartSize.NewIndex) = 100
  cbChartSize.AddItem "Small": cbChartSize.ItemData(cbChartSize.NewIndex) = 150
  cbChartSize.AddItem "Medium": cbChartSize.ItemData(cbChartSize.NewIndex) = 200
  cbChartSize.AddItem "Large": cbChartSize.ItemData(cbChartSize.NewIndex) = 250
  cbChartSize.AddItem "Larger": cbChartSize.ItemData(cbChartSize.NewIndex) = 350
  cbChartSize.ListIndex = 4
  
  cbChartThickness.AddItem "None": cbChartThickness.ItemData(cbChartThickness.NewIndex) = 0
  cbChartThickness.AddItem "Wafer": cbChartThickness.ItemData(cbChartThickness.NewIndex) = 2
  cbChartThickness.AddItem "Thin": cbChartThickness.ItemData(cbChartThickness.NewIndex) = 4
  cbChartThickness.AddItem "Medium": cbChartThickness.ItemData(cbChartThickness.NewIndex) = 8
  cbChartThickness.AddItem "Thick": cbChartThickness.ItemData(cbChartThickness.NewIndex) = 16
  cbChartThickness.AddItem "Thickest": cbChartThickness.ItemData(cbChartThickness.NewIndex) = 32
  cbChartThickness.ListIndex = 3
  
  cbLinesType.AddItem "None"
  cbLinesType.AddItem "Horizontal"
  cbLinesType.AddItem "Numbered"
  cbLinesType.AddItem "Both"
  cbLinesType.ListIndex = 3
End Sub


Private Sub pFill(ByRef chart As cWebChart)
  With chart.WebChartItems.Item(chart.WebChartItems.Add(Nothing))
    .AlternateValue = 10
    .PrimaryValue = 100
  End With

  With chart.WebChartItems.Item(chart.WebChartItems.Add(Nothing))
    .AlternateValue = 20
    .PrimaryValue = 90
  End With

  With chart.WebChartItems.Item(chart.WebChartItems.Add(Nothing))
    .AlternateValue = 30
    .PrimaryValue = 80
    .Explode = True
  End With

  With chart.WebChartItems.Item(chart.WebChartItems.Add(Nothing))
    .AlternateValue = 40
    .PrimaryValue = 70
  End With

  With chart.WebChartItems.Item(chart.WebChartItems.Add(Nothing))
    .AlternateValue = 50
    .PrimaryValue = 60
  End With

  With chart.WebChartItems.Item(chart.WebChartItems.Add(Nothing))
    .AlternateValue = 60
    .PrimaryValue = 50
  End With

  With chart.WebChartItems.Item(chart.WebChartItems.Add(Nothing))
    .AlternateValue = 70
    .PrimaryValue = 40
  End With

  With chart.WebChartItems.Item(chart.WebChartItems.Add(Nothing))
    .AlternateValue = 80
    .PrimaryValue = 30
  End With

  With chart.WebChartItems.Item(chart.WebChartItems.Add(Nothing))
    .AlternateValue = 90
    .PrimaryValue = 110
  End With

  With chart.WebChartItems.Item(chart.WebChartItems.Add(Nothing))
    .AlternateValue = 100
    .PrimaryValue = 10
  End With

End Sub

Private Sub pKillFile()
  On Error Resume Next
  Kill txFile.Text
End Sub

Private Sub ShowChart()
  On Error Resume Next
  
  Set imgChart.Picture = LoadPicture(txFile.Text & pGetExt())
End Sub

Private Sub pFillColors(ByVal cbList As ComboBox)
  cbList.AddItem "AliceBlue": cbList.ItemData(cbList.NewIndex) = &HFFF0F8FF
  cbList.AddItem "AntiqueWhite ": cbList.ItemData(cbList.NewIndex) = &HFFFAEBD7
  cbList.AddItem "Aqua ": cbList.ItemData(cbList.NewIndex) = &HFF00FFFF
  cbList.AddItem "Aquamarine ": cbList.ItemData(cbList.NewIndex) = &HFF7FFFD4
  cbList.AddItem "Azure ": cbList.ItemData(cbList.NewIndex) = &HFFF0FFFF
  cbList.AddItem "Beige ": cbList.ItemData(cbList.NewIndex) = &HFFF5F5DC
  cbList.AddItem "Bisque ": cbList.ItemData(cbList.NewIndex) = &HFFFFE4C4
  cbList.AddItem "Black ": cbList.ItemData(cbList.NewIndex) = &HFF000000
  cbList.AddItem "BlanchedAlmond ": cbList.ItemData(cbList.NewIndex) = &HFFFFEBCD
  cbList.AddItem "Blue ": cbList.ItemData(cbList.NewIndex) = &HFF0000FF
  cbList.AddItem "BlueViolet ": cbList.ItemData(cbList.NewIndex) = &HFF8A2BE2
  cbList.AddItem "Brown ": cbList.ItemData(cbList.NewIndex) = &HFFA52A2A
  cbList.AddItem "BurlyWood ": cbList.ItemData(cbList.NewIndex) = &HFFDEB887
  cbList.AddItem "CadetBlue ": cbList.ItemData(cbList.NewIndex) = &HFF5F9EA0
  cbList.AddItem "Chartreuse ": cbList.ItemData(cbList.NewIndex) = &HFF7FFF00
  cbList.AddItem "Chocolate ": cbList.ItemData(cbList.NewIndex) = &HFFD2691E
  cbList.AddItem "Coral ": cbList.ItemData(cbList.NewIndex) = &HFFFF7F50
  cbList.AddItem "CornflowerBlue ": cbList.ItemData(cbList.NewIndex) = &HFF6495ED
  cbList.AddItem "Cornsilk ": cbList.ItemData(cbList.NewIndex) = &HFFFFF8DC
  cbList.AddItem "Crimson ": cbList.ItemData(cbList.NewIndex) = &HFFDC143C
  cbList.AddItem "Cyan ": cbList.ItemData(cbList.NewIndex) = &HFF00FFFF
  cbList.AddItem "DarkBlue ": cbList.ItemData(cbList.NewIndex) = &HFF00008B
  cbList.AddItem "DarkCyan ": cbList.ItemData(cbList.NewIndex) = &HFF008B8B
  cbList.AddItem "DarkGoldenrod ": cbList.ItemData(cbList.NewIndex) = &HFFB8860B
  cbList.AddItem "DarkGray ": cbList.ItemData(cbList.NewIndex) = &HFFA9A9A9
  cbList.AddItem "DarkGreen ": cbList.ItemData(cbList.NewIndex) = &HFF006400
  cbList.AddItem "DarkKhaki ": cbList.ItemData(cbList.NewIndex) = &HFFBDB76B
  cbList.AddItem "DarkMagenta ": cbList.ItemData(cbList.NewIndex) = &HFF8B008B
  cbList.AddItem "DarkOliveGreen ": cbList.ItemData(cbList.NewIndex) = &HFF556B2F
  cbList.AddItem "DarkOrange ": cbList.ItemData(cbList.NewIndex) = &HFFFF8C00
  cbList.AddItem "DarkOrchid ": cbList.ItemData(cbList.NewIndex) = &HFF9932CC
  cbList.AddItem "DarkRed ": cbList.ItemData(cbList.NewIndex) = &HFF8B0000
  cbList.AddItem "DarkSalmon ": cbList.ItemData(cbList.NewIndex) = &HFFE9967A
  cbList.AddItem "DarkSeaGreen ": cbList.ItemData(cbList.NewIndex) = &HFF8FBC8B
  cbList.AddItem "DarkSlateBlue ": cbList.ItemData(cbList.NewIndex) = &HFF483D8B
  cbList.AddItem "DarkSlateGray ": cbList.ItemData(cbList.NewIndex) = &HFF2F4F4F
  cbList.AddItem "DarkTurquoise ": cbList.ItemData(cbList.NewIndex) = &HFF00CED1
  cbList.AddItem "DarkViolet ": cbList.ItemData(cbList.NewIndex) = &HFF9400D3
  cbList.AddItem "DeepPink ": cbList.ItemData(cbList.NewIndex) = &HFFFF1493
  cbList.AddItem "DeepSkyBlue ": cbList.ItemData(cbList.NewIndex) = &HFF00BFFF
  cbList.AddItem "DimGray ": cbList.ItemData(cbList.NewIndex) = &HFF696969
  cbList.AddItem "DodgerBlue ": cbList.ItemData(cbList.NewIndex) = &HFF1E90FF
  cbList.AddItem "Firebrick ": cbList.ItemData(cbList.NewIndex) = &HFFB22222
  cbList.AddItem "FloralWhite ": cbList.ItemData(cbList.NewIndex) = &HFFFFFAF0
  cbList.AddItem "ForestGreen ": cbList.ItemData(cbList.NewIndex) = &HFF228B22
  cbList.AddItem "Fuchsia ": cbList.ItemData(cbList.NewIndex) = &HFFFF00FF
  cbList.AddItem "Gainsboro ": cbList.ItemData(cbList.NewIndex) = &HFFDCDCDC
  cbList.AddItem "GhostWhite ": cbList.ItemData(cbList.NewIndex) = &HFFF8F8FF
  cbList.AddItem "Gold ": cbList.ItemData(cbList.NewIndex) = &HFFFFD700
  cbList.AddItem "Goldenrod ": cbList.ItemData(cbList.NewIndex) = &HFFDAA520
  cbList.AddItem "Gray ": cbList.ItemData(cbList.NewIndex) = &HFF808080
  cbList.AddItem "Green ": cbList.ItemData(cbList.NewIndex) = &HFF008000
  cbList.AddItem "GreenYellow ": cbList.ItemData(cbList.NewIndex) = &HFFADFF2F
  cbList.AddItem "Honeydew ": cbList.ItemData(cbList.NewIndex) = &HFFF0FFF0
  cbList.AddItem "HotPink ": cbList.ItemData(cbList.NewIndex) = &HFFFF69B4
  cbList.AddItem "IndianRed ": cbList.ItemData(cbList.NewIndex) = &HFFCD5C5C
  cbList.AddItem "Indigo ": cbList.ItemData(cbList.NewIndex) = &HFF4B0082
  cbList.AddItem "Ivory ": cbList.ItemData(cbList.NewIndex) = &HFFFFFFF0
  cbList.AddItem "Khaki ": cbList.ItemData(cbList.NewIndex) = &HFFF0E68C
  cbList.AddItem "Lavender ": cbList.ItemData(cbList.NewIndex) = &HFFE6E6FA
  cbList.AddItem "LavenderBlush ": cbList.ItemData(cbList.NewIndex) = &HFFFFF0F5
  cbList.AddItem "LawnGreen ": cbList.ItemData(cbList.NewIndex) = &HFF7CFC00
  cbList.AddItem "LemonChiffon ": cbList.ItemData(cbList.NewIndex) = &HFFFFFACD
  cbList.AddItem "LightBlue ": cbList.ItemData(cbList.NewIndex) = &HFFADD8E6
  cbList.AddItem "LightCoral ": cbList.ItemData(cbList.NewIndex) = &HFFF08080
  cbList.AddItem "LightCyan ": cbList.ItemData(cbList.NewIndex) = &HFFE0FFFF
  cbList.AddItem "LightGoldenrodYellow ": cbList.ItemData(cbList.NewIndex) = &HFFFAFAD2
  cbList.AddItem "LightGray ": cbList.ItemData(cbList.NewIndex) = &HFFD3D3D3
  cbList.AddItem "LightGreen ": cbList.ItemData(cbList.NewIndex) = &HFF90EE90
  cbList.AddItem "LightPink ": cbList.ItemData(cbList.NewIndex) = &HFFFFB6C1
  cbList.AddItem "LightSalmon ": cbList.ItemData(cbList.NewIndex) = &HFFFFA07A
  cbList.AddItem "LightSeaGreen ": cbList.ItemData(cbList.NewIndex) = &HFF20B2AA
  cbList.AddItem "LightSkyBlue ": cbList.ItemData(cbList.NewIndex) = &HFF87CEFA
  cbList.AddItem "LightSlateGray ": cbList.ItemData(cbList.NewIndex) = &HFF778899
  cbList.AddItem "LightSteelBlue ": cbList.ItemData(cbList.NewIndex) = &HFFB0C4DE
  cbList.AddItem "LightYellow ": cbList.ItemData(cbList.NewIndex) = &HFFFFFFE0
  cbList.AddItem "Lime ": cbList.ItemData(cbList.NewIndex) = &HFF00FF00
  cbList.AddItem "LimeGreen ": cbList.ItemData(cbList.NewIndex) = &HFF32CD32
  cbList.AddItem "Linen ": cbList.ItemData(cbList.NewIndex) = &HFFFAF0E6
  cbList.AddItem "Magenta ": cbList.ItemData(cbList.NewIndex) = &HFFFF00FF
  cbList.AddItem "Maroon ": cbList.ItemData(cbList.NewIndex) = &HFF800000
  cbList.AddItem "MediumAquamarine ": cbList.ItemData(cbList.NewIndex) = &HFF66CDAA
  cbList.AddItem "MediumBlue ": cbList.ItemData(cbList.NewIndex) = &HFF0000CD
  cbList.AddItem "MediumOrchid ": cbList.ItemData(cbList.NewIndex) = &HFFBA55D3
  cbList.AddItem "MediumPurple ": cbList.ItemData(cbList.NewIndex) = &HFF9370DB
  cbList.AddItem "MediumSeaGreen ": cbList.ItemData(cbList.NewIndex) = &HFF3CB371
  cbList.AddItem "MediumSlateBlue ": cbList.ItemData(cbList.NewIndex) = &HFF7B68EE
  cbList.AddItem "MediumSpringGreen ": cbList.ItemData(cbList.NewIndex) = &HFF00FA9A
  cbList.AddItem "MediumTurquoise ": cbList.ItemData(cbList.NewIndex) = &HFF48D1CC
  cbList.AddItem "MediumVioletRed ": cbList.ItemData(cbList.NewIndex) = &HFFC71585
  cbList.AddItem "MidnightBlue ": cbList.ItemData(cbList.NewIndex) = &HFF191970
  cbList.AddItem "MintCream ": cbList.ItemData(cbList.NewIndex) = &HFFF5FFFA
  cbList.AddItem "MistyRose ": cbList.ItemData(cbList.NewIndex) = &HFFFFE4E1
  cbList.AddItem "Moccasin ": cbList.ItemData(cbList.NewIndex) = &HFFFFE4B5
  cbList.AddItem "NavajoWhite ": cbList.ItemData(cbList.NewIndex) = &HFFFFDEAD
  cbList.AddItem "Navy ": cbList.ItemData(cbList.NewIndex) = &HFF000080
  cbList.AddItem "OldLace ": cbList.ItemData(cbList.NewIndex) = &HFFFDF5E6
  cbList.AddItem "Olive ": cbList.ItemData(cbList.NewIndex) = &HFF808000
  cbList.AddItem "OliveDrab ": cbList.ItemData(cbList.NewIndex) = &HFF6B8E23
  cbList.AddItem "Orange ": cbList.ItemData(cbList.NewIndex) = &HFFFFA500
  cbList.AddItem "OrangeRed ": cbList.ItemData(cbList.NewIndex) = &HFFFF4500
  cbList.AddItem "Orchid ": cbList.ItemData(cbList.NewIndex) = &HFFDA70D6
  cbList.AddItem "PaleGoldenrod ": cbList.ItemData(cbList.NewIndex) = &HFFEEE8AA
  cbList.AddItem "PaleGreen ": cbList.ItemData(cbList.NewIndex) = &HFF98FB98
  cbList.AddItem "PaleTurquoise ": cbList.ItemData(cbList.NewIndex) = &HFFAFEEEE
  cbList.AddItem "PaleVioletRed ": cbList.ItemData(cbList.NewIndex) = &HFFDB7093
  cbList.AddItem "PapayaWhip ": cbList.ItemData(cbList.NewIndex) = &HFFFFEFD5
  cbList.AddItem "PeachPuff ": cbList.ItemData(cbList.NewIndex) = &HFFFFDAB9
  cbList.AddItem "Peru ": cbList.ItemData(cbList.NewIndex) = &HFFCD853F
  cbList.AddItem "Pink ": cbList.ItemData(cbList.NewIndex) = &HFFFFC0CB
  cbList.AddItem "Plum ": cbList.ItemData(cbList.NewIndex) = &HFFDDA0DD
  cbList.AddItem "PowderBlue ": cbList.ItemData(cbList.NewIndex) = &HFFB0E0E6
  cbList.AddItem "Purple ": cbList.ItemData(cbList.NewIndex) = &HFF800080
  cbList.AddItem "Red ": cbList.ItemData(cbList.NewIndex) = &HFFFF0000
  cbList.AddItem "RosyBrown ": cbList.ItemData(cbList.NewIndex) = &HFFBC8F8F
  cbList.AddItem "RoyalBlue ": cbList.ItemData(cbList.NewIndex) = &HFF4169E1
  cbList.AddItem "SaddleBrown ": cbList.ItemData(cbList.NewIndex) = &HFF8B4513
  cbList.AddItem "Salmon ": cbList.ItemData(cbList.NewIndex) = &HFFFA8072
  cbList.AddItem "SandyBrown ": cbList.ItemData(cbList.NewIndex) = &HFFF4A460
  cbList.AddItem "SeaGreen ": cbList.ItemData(cbList.NewIndex) = &HFF2E8B57
  cbList.AddItem "SeaShell ": cbList.ItemData(cbList.NewIndex) = &HFFFFF5EE
  cbList.AddItem "Sienna ": cbList.ItemData(cbList.NewIndex) = &HFFA0522D
  cbList.AddItem "Silver ": cbList.ItemData(cbList.NewIndex) = &HFFC0C0C0
  cbList.AddItem "SkyBlue ": cbList.ItemData(cbList.NewIndex) = &HFF87CEEB
  cbList.AddItem "SlateBlue ": cbList.ItemData(cbList.NewIndex) = &HFF6A5ACD
  cbList.AddItem "SlateGray ": cbList.ItemData(cbList.NewIndex) = &HFF708090
  cbList.AddItem "Snow ": cbList.ItemData(cbList.NewIndex) = &HFFFFFAFA
  cbList.AddItem "SpringGreen ": cbList.ItemData(cbList.NewIndex) = &HFF00FF7F
  cbList.AddItem "SteelBlue ": cbList.ItemData(cbList.NewIndex) = &HFF4682B4
  cbList.AddItem "Tan ": cbList.ItemData(cbList.NewIndex) = &HFFD2B48C
  cbList.AddItem "Teal ": cbList.ItemData(cbList.NewIndex) = &HFF008080
  cbList.AddItem "Thistle ": cbList.ItemData(cbList.NewIndex) = &HFFD8BFD8
  cbList.AddItem "Tomato ": cbList.ItemData(cbList.NewIndex) = &HFFFF6347
  cbList.AddItem "Transparent ": cbList.ItemData(cbList.NewIndex) = &HFFFFFF
  cbList.AddItem "Turquoise ": cbList.ItemData(cbList.NewIndex) = &HFF40E0D0
  cbList.AddItem "Violet ": cbList.ItemData(cbList.NewIndex) = &HFFEE82EE
  cbList.AddItem "Wheat ": cbList.ItemData(cbList.NewIndex) = &HFFF5DEB3
  cbList.AddItem "White ": cbList.ItemData(cbList.NewIndex) = &HFFFFFFFF
  cbList.AddItem "WhiteSmoke ": cbList.ItemData(cbList.NewIndex) = &HFFF5F5F5
  cbList.AddItem "Yellow ": cbList.ItemData(cbList.NewIndex) = &HFFFFFF00
  cbList.AddItem "YellowGreen ": cbList.ItemData(cbList.NewIndex) = &HFF9ACD32
End Sub

Private Sub Form_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
  Screen.MousePointer = vbDefault
End Sub

Private Sub lbLink_Click()
  'StartIExplorer
  SwhowPage lbLink.Caption, Me.hwnd
End Sub

Public Sub StartIExplorer()
  
  'Internet-Explorer starten und Homepage aufrufen
  Dim IeAppli As Object
  Dim DoM As Object
  Set IeAppli = CreateObject("InternetExplorer.Application")
  
  IeAppli.Visible = True
End Sub

Private Sub lbLink_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
  Screen.MousePointer = vbCustom
  Screen.MouseIcon = picHand.Picture
End Sub

Private Sub SwhowPage(ByVal strFile As String, ByVal hwnd As Long)
  Dim Hresult As Long
  
  
  Hresult = ShellExecute2(hwnd, "open", strFile + Chr(0), 0, strFile + Chr(0), SW_SHOWNORMAL)
  
  Select Case Hresult
    Case ERROR_PATH_NOT_FOUND '= 3&
        MsgBox "La ruta de acceso no se encuentra"
    Case ERROR_BAD_FORMAT '= 11&
        MsgBox "Formato no reconocido"
    Case SE_ERR_ACCESSDENIED '= 5 '  access denied
        MsgBox "Error a intentar acceder al archivo. Acceso Denegado."
    Case SE_ERR_ASSOCINCOMPLETE '= 27
        MsgBox "Acceso Incompleto"
    Case SE_ERR_DDEBUSY '= 30
        
    Case SE_ERR_DDEFAIL '= 29
        MsgBox "Falla al intentar editar el archivo"
    Case SE_ERR_DDETIMEOUT '= 28
        
    Case SE_ERR_DLLNOTFOUND '= 32
        MsgBox "El archivo no se encuentra"
    Case SE_ERR_FNF '= 2                     '  file not found
        MsgBox "Archivo no encontrado"
    Case SE_ERR_NOASSOC '= 31
    Case SE_ERR_OOM '= 8                     '  out of memory
        MsgBox "Error de Memoria "
    Case SE_ERR_PNF '= 3                     '  path not found
        MsgBox "La ruta de acceso no se encuentra"
    Case SE_ERR_SHARE '= 26
        
  End Select
End Sub

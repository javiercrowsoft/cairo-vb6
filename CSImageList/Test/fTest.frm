VERSION 5.00
Object = "{E82A759A-7510-4F56-B239-9C0B78CF437B}#1.0#0"; "CSImageList.ocx"
Begin VB.Form frmIlsTest 
   Caption         =   "vbAccelerator Image List Tester"
   ClientHeight    =   6300
   ClientLeft      =   2790
   ClientTop       =   1740
   ClientWidth     =   6465
   BeginProperty Font 
      Name            =   "Tahoma"
      Size            =   8.25
      Charset         =   0
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "fTest.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   6300
   ScaleWidth      =   6465
   Begin CSImageList.cImageList vbalImageList2 
      Left            =   5670
      Top             =   1170
      _ExtentX        =   953
      _ExtentY        =   953
   End
   Begin CSImageList.cImageList ilsTest 
      Left            =   5670
      Top             =   1980
      _ExtentX        =   953
      _ExtentY        =   953
   End
   Begin VB.CommandButton cmdSave 
      Caption         =   "&Save"
      Height          =   315
      Left            =   120
      TabIndex        =   23
      Top             =   840
      Width           =   1575
   End
   Begin VB.CommandButton cmdLoad 
      Caption         =   "&Load"
      Height          =   315
      Left            =   120
      TabIndex        =   22
      Top             =   480
      Width           =   1575
   End
   Begin VB.PictureBox picStrip 
      AutoSize        =   -1  'True
      Height          =   615
      Left            =   1800
      ScaleHeight     =   555
      ScaleWidth      =   3615
      TabIndex        =   20
      Top             =   5640
      Width           =   3675
   End
   Begin VB.CommandButton cmdStrip 
      Caption         =   "Get Picture Strip->"
      Height          =   375
      Left            =   60
      TabIndex        =   19
      Top             =   5640
      Width           =   1515
   End
   Begin VB.CommandButton cmdSaveIcon 
      Caption         =   "&Save Icon"
      Height          =   315
      Left            =   120
      TabIndex        =   15
      Top             =   4200
      Width           =   1455
   End
   Begin VB.CommandButton cmdClear 
      Caption         =   "Clear"
      Height          =   315
      Left            =   120
      TabIndex        =   14
      Top             =   1260
      Width           =   1575
   End
   Begin VB.OptionButton optStyle 
      Appearance      =   0  'Flat
      Caption         =   "Cu&t"
      ForeColor       =   &H80000008&
      Height          =   195
      Index           =   3
      Left            =   120
      TabIndex        =   7
      Top             =   2940
      Width           =   1575
   End
   Begin VB.OptionButton optStyle 
      Appearance      =   0  'Flat
      Caption         =   "&Disabled"
      ForeColor       =   &H80000008&
      Height          =   195
      Index           =   2
      Left            =   120
      TabIndex        =   6
      Top             =   2700
      Width           =   1575
   End
   Begin VB.OptionButton optStyle 
      Appearance      =   0  'Flat
      Caption         =   "&Selected"
      ForeColor       =   &H80000008&
      Height          =   195
      Index           =   1
      Left            =   120
      TabIndex        =   5
      Top             =   2460
      Width           =   1575
   End
   Begin VB.OptionButton optStyle 
      Appearance      =   0  'Flat
      Caption         =   "&Normal"
      ForeColor       =   &H80000008&
      Height          =   195
      Index           =   0
      Left            =   120
      TabIndex        =   4
      Top             =   2220
      Value           =   -1  'True
      Width           =   1575
   End
   Begin VB.PictureBox picIcon 
      Height          =   555
      Left            =   120
      ScaleHeight     =   495
      ScaleWidth      =   615
      TabIndex        =   3
      Top             =   3540
      Width           =   675
   End
   Begin VB.CommandButton cmdGetPic 
      Caption         =   "Get Picture"
      Height          =   315
      Left            =   120
      TabIndex        =   2
      Top             =   3180
      Width           =   1515
   End
   Begin VB.CommandButton cmdGet 
      Caption         =   "Get Resource"
      Height          =   315
      Left            =   120
      TabIndex        =   1
      Top             =   60
      Width           =   1575
   End
   Begin VB.CommandButton cmdShow 
      Caption         =   "Show"
      Height          =   315
      Left            =   120
      TabIndex        =   0
      Top             =   1860
      Width           =   1575
   End
   Begin VB.Label lblAddress 
      Caption         =   "http://vbaccelerator.com"
      Height          =   195
      Left            =   4620
      TabIndex        =   21
      Top             =   420
      Width           =   1875
   End
   Begin VB.Label lblCount 
      Caption         =   "Image Count:"
      Height          =   255
      Left            =   1860
      TabIndex        =   18
      Top             =   780
      Width           =   1095
   End
   Begin VB.Label lblImageCount 
      Height          =   255
      Left            =   2940
      TabIndex        =   17
      Top             =   780
      Width           =   1095
   End
   Begin VB.Image imgVBAccelerator 
      Height          =   360
      Left            =   5100
      Picture         =   "fTest.frx":014A
      Top             =   60
      Width           =   1290
   End
   Begin VB.Label lblWarning 
      Caption         =   "Warning - the SavePicture method crashes VB for icons which aren't 16x16 or 32x32"
      Height          =   1035
      Left            =   120
      TabIndex        =   16
      Top             =   4560
      Width           =   1515
   End
   Begin VB.Label lblY 
      Height          =   255
      Left            =   2940
      TabIndex        =   13
      Top             =   540
      Width           =   1095
   End
   Begin VB.Label lblHeight 
      Caption         =   "Height"
      Height          =   255
      Left            =   1860
      TabIndex        =   12
      Top             =   540
      Width           =   1095
   End
   Begin VB.Label lblX 
      Height          =   255
      Left            =   2940
      TabIndex        =   11
      Top             =   300
      Width           =   1095
   End
   Begin VB.Label lblWidth 
      Caption         =   "Width:"
      Height          =   255
      Left            =   1860
      TabIndex        =   10
      Top             =   300
      Width           =   1095
   End
   Begin VB.Label lblDepth 
      Height          =   255
      Left            =   2940
      TabIndex        =   9
      Top             =   60
      Width           =   1095
   End
   Begin VB.Label lblColour 
      Caption         =   "Colour Depth:"
      Height          =   255
      Left            =   1860
      TabIndex        =   8
      Top             =   60
      Width           =   1095
   End
End
Attribute VB_Name = "frmIlsTest"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

' =========================================================================
' vbAccelerator Image List Control Demonstrator
' Copyright © 1998 Steve McMahon (steve@dogma.demon.co.uk)
'
' Demonstrates the vbAccelerator Image List. Try out the
' ImageList properties at design time to check out the
' implementation.
'
' Visit vbAccelerator at www.dogma.demon.co.uk
' =========================================================================

Private m_bInDev As Boolean

Private Property Get InDev() As Boolean
   ' This function is called from a debug.assert call
   ' so m_bIndev is only ever set in DesignTime -
   ' debug.assert is not compiled into executables.
   m_bInDev = True
   InDev = m_bInDev
End Property

Private Sub cmdLoad_Click()
On Error GoTo ErrHandler
   ' Loads a data file created by the ImageList:
    ilsTest.LoadFromFile App.Path & "\Test2.dat"
    cmdShow_Click
    Exit Sub
ErrHandler:
   MsgBox "Error Loading: " & Err.Description, vbExclamation
   Exit Sub
End Sub

Private Sub cmdSave_Click()
On Error GoTo ErrHandler
   ' Saves the image list pictures to a data file:
    ilsTest.SaveToFile App.Path & "\Test2.dat"
    Exit Sub
ErrHandler:
   MsgBox "Error Loading: " & Err.Description, vbExclamation
   Exit Sub
End Sub

Private Sub cmdClear_Click()
Dim i As Long
   ' Remove all the icons in the image list.
   For i = ilsTest.ImageCount To 1 Step -1
      ilsTest.RemoveImage i
   Next i
   cmdShow_Click
   
   ' Note an alternative method, and quicker if you
   ' have a lot of icons, is to create a new ImageList:
   '    ilsTest.Create
   ' This will change the ilsTest.hIml handle value.
   
End Sub

Private Sub cmdGet_Click()
Dim idRes As Long

   ' This button loads either a 16 or 256 colour icon resource
   ' depending on the system colour depth.
   ' All the images are loaded from a single resource bitmap.

   ' A note on using Resources in VB.
   ' If you are running in EXE, the single AddFromResourceID call
   ' can be made.
   ' In the IDE, just use the LoadResPicture function.  Note that
   ' LoadResPicture does not work correctly with icons that are not
   ' 32x32 or 16x16 and 16 colours - it returns a distorted or dithered
   ' icon.
   
   ilsTest.ColourDepth = ilsTest.SystemColourDepth
   Form_Load
   If (ilsTest.ColourDepth >= ILC_COLOR16) Then
      ' We can handle 256 colours
      idRes = 101
   Else
      ' If we were ILC_COLOR8, we could handle 256 colours in
      ' theory, but palette issues in practice make it too tricky.
      idRes = 102
   End If
   
   Debug.Assert (InDev() = True)
   If (m_bInDev) Then
      Dim stdPic As New StdPicture
      Set stdPic = LoadResPicture(idRes, vbResBitmap)
      ilsTest.AddFromHandle stdPic.Handle, IMAGE_BITMAP, , &HFFFF00
      Set stdPic = Nothing
   Else
      ilsTest.AddFromResourceID idRes, App.hInstance, IMAGE_BITMAP, , False, &HFFFF00
   End If
   cmdShow_Click
   
End Sub

Private Sub cmdGetPic_Click()
   ' Transfer an image to a VB picture object. StdPicture sucks
   ' for icons!
   Set picIcon.Picture = ilsTest.ItemPicture(1)
   
End Sub


Private Sub cmdSaveIcon_Click()
   ' This will crash VB unless the icon is 16x16 or 32x32.  Why?
   SavePicture picIcon, App.Path & "\Test.ico"
End Sub

Private Sub cmdShow_Click()
Dim i As Long
Dim iIdx As Long
Dim x As Long, y As Long
Dim bSel As Boolean, bDis As Boolean, bCut As Boolean
Dim sKey As String
   
   lblImageCount.Caption = ilsTest.ImageCount

   ' Display all the icons in the ImageList in the style
   ' specified by the options:
   bSel = optStyle(1).Value
   bDis = optStyle(2).Value
   bCut = optStyle(3).Value
   Me.Cls
   x = cmdShow.Left + cmdShow.Width
   x = x \ Screen.TwipsPerPixelX
   y = cmdClear.Top \ Screen.TwipsPerPixelY
   For i = 1 To ilsTest.ImageCount
         ilsTest.DrawImage i, Me.hDC, x, y, bSel, bCut, bDis, Me.BackColor
         y = y + ilsTest.IconSizeY + 2
         If (y + ilsTest.IconSizeY + 2 > cmdStrip.Top \ Screen.TwipsPerPixelY) Then
         y = cmdClear.Top \ Screen.TwipsPerPixelY
         x = x + ilsTest.IconSizeX + 2
      End If
      sKey = ilsTest.ItemKey(i)
      iIdx = ilsTest.ItemIndex(sKey)
      Debug.Print iIdx, sKey
   Next i
End Sub

Private Sub cmdStrip_Click()
   Set picStrip.Picture = ilsTest.ImagePictureStrip(, , &H80FF00)
End Sub

Private Sub Form_Activate()
   
   cmdShow_Click
End Sub

Private Sub Form_Load()
   
   ' Display info about the image list:
   Select Case ilsTest.ColourDepth
   Case ILC_COLOR8
      lblDepth.Caption = "256 colours"
   Case ILC_COLOR4
      lblDepth.Caption = "16 colours"
   Case ILC_COLOR32
      lblDepth.Caption = "32 bit"
   Case ILC_COLOR24
      lblDepth.Caption = "24 bit"
   Case ILC_COLOR16
      lblDepth.Caption = "16 bit"
   Case ILC_COLOR
      lblDepth.Caption = "Default"
   End Select
   lblX.Caption = ilsTest.IconSizeX
   lblY.Caption = ilsTest.IconSizeY
   lblImageCount.Caption = ilsTest.ImageCount
   
End Sub

Private Sub optStyle_Click(Index As Integer)
   cmdShow_Click
End Sub

VERSION 5.00
Begin VB.Form frmTest 
   Caption         =   "Form1"
   ClientHeight    =   4785
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   7845
   LinkTopic       =   "Form1"
   ScaleHeight     =   4785
   ScaleWidth      =   7845
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton Command1 
      Caption         =   "Command1"
      Height          =   735
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   1695
   End
End
Attribute VB_Name = "frmTest"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Command1_Click()
    Dim clsBitmap As New GpGDIPlus.cBitmap
    Dim clsSaveP As New cImageSaveParameters
    Dim clsC As GpGDIPlus.cBitmap
    
    clsSaveP.ImageSaveFormat = GpSaveJPEG
    clsSaveP.JPEGQuality = 65
    With clsBitmap
         .FromFile "d:\1.jpg"
'         Set cRect = New cRect
'         cRect.Create 200, 200, 200, 200
         Set clsC = .GetThumbnailBitmap(200, 200)
         If Not clsC Is Nothing Then
            clsC.Image.SaveImageToFile "d:\2.jpg", clsSaveP
         End If
    End With
    
    Set clsBitmap = Nothing
    Set clsSaveP = Nothing
    Set clsC = Nothing
End Sub

Private Sub Form_Load()
    If Not (GDIPlusInitialize()) Then
       MsgBox "not GDI+"
       Unload Me
       Exit Sub
    End If
End Sub

Private Sub Form_Unload(Cancel As Integer)
    Call GDIPlusTerminate
End Sub

VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Begin VB.Form frmPreview 
   Caption         =   "Form1"
   ClientHeight    =   8730
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   10080
   LinkTopic       =   "Form1"
   ScaleHeight     =   8730
   ScaleWidth      =   10080
   Begin MSComctlLib.StatusBar StatusBar1 
      Align           =   2  'Align Bottom
      Height          =   375
      Left            =   0
      TabIndex        =   11
      Top             =   8355
      Width           =   10080
      _ExtentX        =   17780
      _ExtentY        =   661
      _Version        =   393216
      BeginProperty Panels {8E3867A5-8586-11D1-B16A-00C0F0283628} 
         NumPanels       =   2
         BeginProperty Panel1 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
            AutoSize        =   1
            Object.Width           =   13732
            Key             =   "Status"
         EndProperty
         BeginProperty Panel2 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
            Object.Width           =   3528
            MinWidth        =   3528
            Key             =   "Zoom"
         EndProperty
      EndProperty
   End
   Begin VB.PictureBox picPage 
      Height          =   5055
      Left            =   120
      ScaleHeight     =   4995
      ScaleWidth      =   7335
      TabIndex        =   8
      Top             =   540
      Width           =   7395
      Begin VB.VScrollBar VScroll1 
         Height          =   4875
         Left            =   7020
         Max             =   100
         TabIndex        =   10
         Top             =   60
         Width           =   255
      End
      Begin VB.PictureBox picPreview 
         AutoRedraw      =   -1  'True
         Height          =   2655
         Left            =   480
         ScaleHeight     =   2595
         ScaleWidth      =   2415
         TabIndex        =   9
         Top             =   120
         Width           =   2475
      End
   End
   Begin VB.PictureBox picToolbar 
      Align           =   1  'Align Top
      BorderStyle     =   0  'None
      Height          =   375
      Left            =   0
      ScaleHeight     =   375
      ScaleWidth      =   10080
      TabIndex        =   0
      Top             =   0
      Width           =   10080
      Begin VB.CommandButton cmdClose 
         Caption         =   "&Close"
         Height          =   315
         Left            =   6900
         TabIndex        =   7
         Top             =   0
         Width           =   1095
      End
      Begin VB.CommandButton cmdZoomOut 
         Caption         =   "Zoom &Out"
         Height          =   315
         Left            =   5760
         TabIndex        =   6
         Top             =   0
         Width           =   1095
      End
      Begin VB.CommandButton cmdZoomIn 
         Caption         =   "Zoom &In"
         Height          =   315
         Left            =   4620
         TabIndex        =   5
         Top             =   0
         Width           =   1095
      End
      Begin VB.CommandButton cmdTwoPage 
         Caption         =   "&Two Page"
         Height          =   315
         Left            =   3480
         TabIndex        =   4
         Top             =   0
         Width           =   1095
      End
      Begin VB.CommandButton cmdPrevPage 
         Caption         =   "Pre&v Page"
         Height          =   315
         Left            =   2340
         TabIndex        =   3
         Top             =   0
         Width           =   1095
      End
      Begin VB.CommandButton cmdNextPage 
         Caption         =   "&Next Page"
         Height          =   315
         Left            =   1200
         TabIndex        =   2
         Top             =   0
         Width           =   1095
      End
      Begin VB.CommandButton cmdPrint 
         Caption         =   "&Print"
         Height          =   315
         Left            =   60
         TabIndex        =   1
         Top             =   0
         Width           =   1095
      End
   End
End
Attribute VB_Name = "frmPreview"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'==========================================================
'           Copyright Information
'==========================================================
'Program Name: Mewsoft Editawy
'Program Author   : Elsheshtawy, A. A.
'Home Page        : http://www.mewsoft.com
'Copyrights © 2006 Mewsoft Corporation. All rights reserved.
'==========================================================
'==========================================================
Option Explicit

Private PreviewZoomFactor As Single
Private PreviewStartCharPos As Long
Private PreviewEndCharPos As Long
Private PreviewTotalPages As Long
Private PreviewNextCharPos As Long
Private PreviewCurrentPage As Long
Private PreviewPagesInfo() As String

Private PreviewPageImage As StdPicture
'====================================================================

Private Sub Form_Load()
    
   
    Form_Resize
       
    PreviewZoomFactor = 1
    
    'frmActiveDocument.Editawy1.PrintMagnification = -3
    
    MesaurePreviewPages
    ShowPreviewPage
    
End Sub

Private Sub MesaurePreviewPages()
    
    Dim Infos() As String, FirstVisibleChar As Long, x As Long
    
    ReDim PreviewPagesInfo(0) As String
    
    'Measure the print pages
    PreviewTotalPages = frmActiveDocument.Editawy1.PrintPagesMeasure( _
                        0, frmActiveDocument.Editawy1.GetTextLength, _
                        rectMargins.left, rectMargins.top, _
                        rectMargins.right, rectMargins.bottom, _
                        PreviewNextCharPos, _
                        PreviewPagesInfo())
        

    Debug.Print "TotalPages: "; PreviewTotalPages
    
    'Get the first visible line char position
    FirstVisibleChar = frmActiveDocument.Editawy1.PositionFromLine( _
                        frmActiveDocument.Editawy1.GetFirstVisibleLine)
                        
    Debug.Print "FirstVisibleChar: "; FirstVisibleChar
    
    'Now find what page number is visible on the user screen
    For x = 1 To UBound(PreviewPagesInfo)
        Infos = Split(PreviewPagesInfo(x), ":")
        ' PageNum:PageStartCharPos:PageEndCharPos
        If UBound(Infos) < 2 Then Exit For
        If Infos(1) >= FirstVisibleChar Then
            PreviewCurrentPage = x
            PreviewStartCharPos = Infos(1)
            PreviewEndCharPos = Infos(2) - 1
            If PreviewEndCharPos < 0 Then PreviewEndCharPos = 0
            Exit For
        End If
    Next x
    
End Sub

Private Sub cmdClose_Click()
    Unload Me
End Sub

Private Sub cmdNextPage_Click()
    Dim Infos() As String
    
    If PreviewCurrentPage < UBound(PreviewPagesInfo) Then
        PreviewCurrentPage = PreviewCurrentPage + 1
        Infos = Split(PreviewPagesInfo(PreviewCurrentPage), ":")
        If UBound(Infos) < 2 Then Exit Sub
        PreviewStartCharPos = Infos(1)
        PreviewEndCharPos = Infos(2) - 1
        If PreviewEndCharPos < 0 Then PreviewEndCharPos = 0
        ShowPreviewPage
    End If
    
End Sub

Private Sub cmdPrevPage_Click()
    Dim Infos() As String
    
    If PreviewCurrentPage > LBound(PreviewPagesInfo) Then
        PreviewCurrentPage = PreviewCurrentPage - 1
        Infos = Split(PreviewPagesInfo(PreviewCurrentPage), ":")
        If UBound(Infos) < 2 Then Exit Sub
        'Debug.Print "Infos: "; Infos(0), Infos(1), Infos(2)
        PreviewStartCharPos = Infos(1)
        PreviewEndCharPos = Infos(2) - 1
        If PreviewEndCharPos < 0 Then PreviewEndCharPos = 0
        ShowPreviewPage
    End If
    
End Sub

Private Sub cmdZoomIn_Click()
    If PreviewZoomFactor < 2 Then
        PreviewZoomFactor = PreviewZoomFactor + 0.2
        ShowPreviewPage
    End If
End Sub

Private Sub cmdZoomOut_Click()
    If PreviewZoomFactor > 0.2 Then
        PreviewZoomFactor = PreviewZoomFactor - 0.2
        ShowPreviewPage
    End If
End Sub

Private Sub Form_Activate()
    
    'Set the first preview page to the current visible page
    PreviewStartCharPos = frmActiveDocument.Editawy1.PositionFromLine( _
                            frmActiveDocument.Editawy1.GetFirstVisibleLine)
    'PreviewStartCharPos = 0
    ShowPreviewPage
End Sub

Private Sub ShowPreviewPage()

    Dim lWidth As Long, lHeight As Long
    Dim rc As RECT, rcpage  As RECT
    Dim PixelWidth As Long, PixelHeight As Long
    Dim pic As StdPicture, Pages As Long
    Dim hBmpDC As Long
    'Dim PreviewZoom As Single
    Dim FisrtCharPos As Long
    Dim PagesInfo() As String, x As Long
    
    picPreview.AutoRedraw = True
    
    PixelWidth = 2024
    PixelHeight = 1768
       
    picPreview.width = PixelWidth * Screen.TwipsPerPixelX
    picPreview.height = PixelHeight * Screen.TwipsPerPixelY
       
    picPreview.ScaleLeft = Printer.ScaleLeft
    picPreview.ScaleTop = Printer.ScaleTop
    picPreview.ScaleWidth = Printer.ScaleWidth
    picPreview.ScaleHeight = Printer.ScaleHeight
    
    'Debug.Print "PixelWidth, PixelHeight: "; PixelWidth, PixelHeight
    
    hBmpDC = frmActiveDocument.Editawy1.CreatePictureDC( _
                            PixelWidth, PixelHeight, vbWhite)
    If hBmpDC = 0 Then
        Exit Sub
    End If
    
    frmActiveDocument.Editawy1.ClsDC hBmpDC, vbWhite, PixelWidth, PixelHeight
        
    picPreview.Cls
      
    x = frmActiveDocument.Editawy1.PrintPreview(hBmpDC, _
                            PreviewStartCharPos, _
                            PreviewEndCharPos, _
                            rectMargins.left \ Printer.TwipsPerPixelX, _
                            rectMargins.top \ Printer.TwipsPerPixelY, _
                            rectMargins.right \ Printer.TwipsPerPixelX, _
                            rectMargins.bottom \ Printer.TwipsPerPixelY, _
                            PreviewNextCharPos)
    '======================================================
    Set PreviewPageImage = frmActiveDocument.Editawy1.CreatePictureFromDC( _
                            hBmpDC, PixelWidth, PixelHeight)
                                
    'Debug.Print "Pic: "; PreviewPageImage.width, PreviewPageImage.height, "&H"; Hex(PreviewPageImage.Handle)
    
    With picPreview
                .PaintPicture PreviewPageImage, 0, 0, _
                        CLng(PreviewPageImage.width * PreviewZoomFactor), _
                        CLng(PreviewPageImage.height * PreviewZoomFactor), _
                        0, 0, PreviewPageImage.width, PreviewPageImage.height, _
                        vbSrcCopy
    End With
    
    frmActiveDocument.Editawy1.DeletePictureDC hBmpDC
    
    StatusBar1.Panels("Status").Text = "Page " & CStr(PreviewCurrentPage) & " of " & CStr(PreviewTotalPages)
    StatusBar1.Panels("Zoom").Text = "Zoom: " & CStr(PreviewZoomFactor * 100) & "% "
End Sub

Private Sub ShowPreviewPageXX()

    Dim hBmpDC As Long
    Dim FisrtCharPos As Long
    Dim x As Long
    
    picPreview.AutoRedraw = True
    
    'Printer.Zoom = 0
    picPreview.width = 1600
    picPreview.height = 900
    
    picPreview.Cls
    
    hBmpDC = picPreview.hdc
        
    x = frmActiveDocument.Editawy1.PrintPreview(hBmpDC, _
                            PreviewStartCharPos, _
                            PreviewEndCharPos, _
                            rectMargins.left \ Printer.TwipsPerPixelX, _
                            rectMargins.top \ Printer.TwipsPerPixelY, _
                            rectMargins.right \ Printer.TwipsPerPixelX, _
                            rectMargins.bottom \ Printer.TwipsPerPixelY, _
                            PreviewNextCharPos)
    
    StatusBar1.Panels("Status").Text = "Page " & CStr(PreviewCurrentPage) & " of " & CStr(PreviewTotalPages)
End Sub


Private Sub Form_Resize()

    If Me.WindowState = vbMinimized Then Exit Sub
    
    picPage.Move 0, picToolbar.top + picToolbar.height + 5, Me.ScaleWidth, Me.ScaleHeight - picToolbar.top - picToolbar.height - StatusBar1.height - 10
    
    VScroll1.Move picPage.ScaleLeft + picPage.ScaleWidth - 250, picPage.ScaleTop + 5, 250, picPage.height - 50
            
    picPreview.top = 10
End Sub

Private Sub VScroll1_Change()
    
    Dim Percent As Single
    Percent = (VScroll1.Value / 100)
    If Percent <= 0 Then Percent = 0.1

End Sub

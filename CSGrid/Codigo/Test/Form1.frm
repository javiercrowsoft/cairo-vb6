VERSION 5.00
Object = "{D5E078F9-5926-4845-9172-73CD66955B2C}#1.0#0"; "CSGrid.ocx"
Object = "{E82A759A-7510-4F56-B239-9C0B78CF437B}#1.0#0"; "CSImageList.ocx"
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   7275
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   5955
   LinkTopic       =   "Form1"
   ScaleHeight     =   7275
   ScaleWidth      =   5955
   StartUpPosition =   3  'Windows Default
   Begin CSGrid.cGrid grdThis 
      Height          =   6990
      Left            =   0
      TabIndex        =   0
      Top             =   0
      Width           =   5460
      _ExtentX        =   9631
      _ExtentY        =   12330
      BackgroundPictureHeight=   0
      BackgroundPictureWidth=   0
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      DisableIcons    =   -1  'True
      Begin VB.TextBox txtEdit 
         Height          =   285
         Left            =   675
         TabIndex        =   1
         Text            =   "Text1"
         Top             =   1260
         Width           =   1680
      End
   End
   Begin CSImageList.cImageList ilsIcons 
      Left            =   5535
      Top             =   0
      _ExtentX        =   953
      _ExtentY        =   953
      IconSizeX       =   24
      IconSizeY       =   24
      ColourDepth     =   24
      Size            =   50856
      Images          =   "Form1.frx":0000
      KeyCount        =   26
      Keys            =   "ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ"
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private m_sStatus As String
Private m_iValue As Long
Private m_iMax As Long

Public Property Let Max(ByVal iMax As Long)
   m_iMax = iMax
End Property

Public Property Get Value() As Long
   Value = m_iValue
End Property
Public Property Let Status(ByVal sText As String)
   m_sStatus = sText
End Property
Public Property Let Value(ByVal iValue As Long)
   m_iValue = iValue
End Property

Private Sub Form_Load()
   
   
   Me.Show
   Me.Refresh
   
   With grdThis
      ' Turn redraw off for speed:
      .Redraw = False
      
      .ImageList = ilsIcons.hIml
      .AddColumn "file", "Name", , , 32, , , , False
      .AddColumn "size", "Size", , , 48
      .AddColumn "type", "Type"
      .AddColumn "date", "Modified", , , 64, False, , , , "Long Date"
      .AddColumn "col5", "Col 5", , , 196
      .AddColumn "col6", "Col 6"
      .AddColumn "col7", "Col 7"
      .AddColumn "col8", "Col 8"
      .AddColumn "col9", "Col 9"
      .AddColumn "col10", "Col 10"
      .SetHeaders
      .KeySearchColumn = .ColumnIndex("size")
      pPopulate
      
      ' Ensure the grid will draw!
      .Redraw = True
      
   End With
End Sub

Private Sub Form_Resize()
Dim lSize As Long
Dim lHeight As Long
On Error Resume Next
   lHeight = Me.ScaleHeight * Screen.TwipsPerPixelY
   lSize = grdThis.Left
   grdThis.Move 2 * Screen.TwipsPerPixelX, 2 * Screen.TwipsPerPixelY, Me.ScaleWidth - grdThis.Left * 2 - lSize, lHeight
End Sub

Private Sub pPopulate()
Dim lRow As Long, lCol As Long, lIndent As Long
      
   Dim sFnt2 As New StdFont
   sFnt2.Name = "Times New Roman"
   sFnt2.Bold = True
   sFnt2.Size = 12
   
   With grdThis
      .DefaultRowHeight = 24
      .Redraw = False
      .Rows = CLng(100)
      Max = .Rows
      For lRow = 1 To .Rows
         For lCol = 1 To .Columns
            If (.ColumnKey(lCol) = "file") Or (.ColumnKey(lCol) = "col8") Then
               .CellDetails lRow, lCol, , , Rnd * (ilsIcons.ImageCount - 1)
            ElseIf (.ColumnKey(lCol) = "date") Then
               .CellDetails lRow, lCol, DateSerial(Year(Now) + Rnd * 8 - 1, Rnd * 12, Rnd * 31)
            ElseIf (.ColumnKey(lCol) = "col5") Then
               ' Icons + text
               If (lRow Mod 2) = 0 Then
                  lIndent = 24
               Else
                  lIndent = 0
               End If
               .CellDetails lRow, lCol, "This is a longer piece of text which can wrap onto a second line if the default cell format is changed so the DT_SINGLELINE option is removed. Test ampersands: Autos & Auto Parts.", DT_LEFT Or DT_MODIFYSTRING Or DT_WORDBREAK Or DT_END_ELLIPSIS, Rnd * ilsIcons.ImageCount - 1, , , , lIndent
            Else
               ' Text:
               .CellDetails lRow, lCol, "Row" & lRow & ",Col" & lCol
            End If
            
            ' Demonstrating multiple forecolor, backcolor and fonts for cells
            If (lRow Mod 42) = 0 Then
               .CellFont(lRow, lCol) = sFnt2
            ElseIf (lRow Mod 35) = 0 Then
               If (lCol = 4) Then
                  .CellBackColor(lRow, lCol) = &HCC9966
               Else
                  .CellBackColor(lRow, lCol) = &HEECC99
               End If
            ElseIf (lRow Mod 10) = 0 Then
               .CellForeColor(lRow, lCol) = &HFF&
            End If
            
         Next lCol
         If (lRow Mod 10) = 0 Then
            Value = Value + 10
            Status = lRow & " of " & .Rows
         End If
      Next lRow
      Value = 0
      .Redraw = True
   End With
   
End Sub


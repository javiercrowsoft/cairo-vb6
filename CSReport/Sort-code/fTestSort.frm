VERSION 5.00
Begin VB.Form fTestSort 
   Caption         =   "Form1"
   ClientHeight    =   1845
   ClientLeft      =   60
   ClientTop       =   405
   ClientWidth     =   7395
   LinkTopic       =   "Form1"
   ScaleHeight     =   1845
   ScaleWidth      =   7395
   StartUpPosition =   3  'Windows-Standard
   Begin VB.CommandButton btSort 
      Caption         =   "Sort It"
      Default         =   -1  'True
      Enabled         =   0   'False
      Height          =   495
      Left            =   3090
      TabIndex        =   0
      Top             =   375
      Width           =   1215
   End
   Begin VB.Label Label1 
      Alignment       =   2  'Zentriert
      AutoSize        =   -1  'True
      Height          =   195
      Left            =   3675
      TabIndex        =   1
      Top             =   1335
      Width           =   45
   End
End
Attribute VB_Name = "fTestSort"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private WithEvents Sort     As cSort
Attribute Sort.VB_VarHelpID = -1
Private UnsortedTable()     As String
Private Const UsedKeySize   As Long = 5

Private Sub btSort_Click()

  Dim ts As Single
  Dim i As Long

    ts = Timer
    MousePointer = vbHourglass

    Set Sort = New cSort
    With Sort
        .LowBound = LBound(UnsortedTable)
        .HighBound = UBound(UnsortedTable)
        .KeyPosition = 1
        .KeySize = UsedKeySize
        .PartialKeys = LessFullKeys
        .SortDirection = Ascending
        i = .SortTable(UnsortedTable)
    End With 'SORT

    MousePointer = vbNormal
    Label1 = UBound(UnsortedTable) - LBound(UnsortedTable) + 1 & " elements with " & i & " distinct keys sorted in " & Timer - ts & " seconds"

End Sub

Private Sub Form_Load()

  Dim i As Long

    Show
    DoEvents
    ReDim UnsortedTable(1 To 1000000)
    For i = LBound(UnsortedTable) To UBound(UnsortedTable)
        UnsortedTable(i) = Format$(Rnd * 100000000, "00000000")
    Next i
    btSort.Enabled = True

End Sub

':) Ulli's VB Code Formatter V2.17.4 (2004-Aug-15 13:25) 5 + 40 = 45 Lines

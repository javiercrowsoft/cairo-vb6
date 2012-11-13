VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   3195
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4680
   LinkTopic       =   "Form1"
   ScaleHeight     =   3195
   ScaleWidth      =   4680
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton Command1 
      Caption         =   "Command1"
      Height          =   495
      Left            =   1740
      TabIndex        =   0
      Top             =   1380
      Width           =   1215
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Command1_Click()
  Dim WebChart
  Dim vBytes
  
  Set WebChart = CreateObject("CSWebChart.cChart")
  
  'vBytes = WebChart.GetChart(Pie,AliceBlue,AntiqueWhite,Both,true,true,Medium,Medium,Png)
  vBytes = WebChart.GetChart(0, -984833, -332841, 3, True, True, 8, 200, 2)
  Debug.Print UBound(vBytes)
End Sub

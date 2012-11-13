VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   7635
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   6075
   LinkTopic       =   "Form1"
   ScaleHeight     =   7635
   ScaleWidth      =   6075
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox Text1 
      Height          =   5295
      Left            =   420
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   1
      Text            =   "Form1.frx":0000
      Top             =   2160
      Width           =   5475
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Command1"
      Height          =   495
      Left            =   300
      TabIndex        =   0
      Top             =   720
      Width           =   1215
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Declare Function DeviceCapabilities Lib "winspool.drv" _
   Alias "DeviceCapabilitiesA" (ByVal lpDeviceName As String, _
   ByVal lpPort As String, ByVal iIndex As Long, lpOutput As Any, _
   ByVal dev As Long) As Long

Private Const DC_BINS = 6
Private Const DC_BINNAMES = 12

Private Sub Command1_Click()
   Dim prn As Printer
   Dim dwbins As Long
   Dim ct As Long
   Dim nameslist As String
   Dim nextString As String
   Dim numBin() As Integer

   Text1.Font.Name = "Courier New"
   Text1.Font.Size = 12
   Text1.Text = ""
   For Each prn In Printers
   
   If prn.DeviceName = "" Then
        dwbins = DeviceCapabilities(prn.DeviceName, prn.Port, _
          DC_BINS, ByVal vbNullString, 0)
        ReDim numBin(1 To dwbins)
        nameslist = String(24 * dwbins, 0)
        dwbins = DeviceCapabilities(prn.DeviceName, prn.Port, _
          DC_BINS, numBin(1), 0)
        dwbins = DeviceCapabilities(prn.DeviceName, prn.Port, _
          DC_BINNAMES, ByVal nameslist, 0)
        If Text1.Text <> "" Then
           Text1.Text = Text1.Text & vbCrLf & vbCrLf
        End If
        Text1.Text = Text1.Text & prn.DeviceName
        For ct = 1 To dwbins
           nextString = Mid(nameslist, 24 * (ct - 1) + 1, 24)
           nextString = Left(nextString, InStr(1, nextString, _
             Chr(0)) - 1)
           nextString = String(6 - Len(CStr(numBin(ct))), " ") & _
           numBin(ct) & "  " & nextString
           Text1.Text = Text1.Text & vbCrLf & nextString
        Next ct
   End If
   
   Next prn
End Sub

Private Sub Form_Load()
   ' Size and position the Form and controls
   Me.Height = 7000
   Me.Width = 7000
   Text1.Top = 100
   Text1.Left = 100
   Text1.Height = 6450
   Text1.Width = 5000
   Text1.Text = ""   ' Clear the TextBox
   Command1.Left = 5300
   Command1.Top = 1000
   Command1.Width = 1500
   Command1.Caption = "List Bins"
End Sub



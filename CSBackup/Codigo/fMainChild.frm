VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Begin VB.Form fMain 
   Caption         =   "Backup"
   ClientHeight    =   4935
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   7200
   Icon            =   "fMainChild.frx":0000
   LinkTopic       =   "Form1"
   MDIChild        =   -1  'True
   ScaleHeight     =   4935
   ScaleWidth      =   7200
   Begin MSComctlLib.ImageList ImageList1 
      Left            =   4440
      Top             =   1860
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483643
      ImageWidth      =   16
      ImageHeight     =   16
      MaskColor       =   12632256
      UseMaskColor    =   0   'False
      _Version        =   393216
      BeginProperty Images {2C247F25-8591-11D1-B16A-00C0F0283628} 
         NumListImages   =   2
         BeginProperty ListImage1 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMainChild.frx":1042
            Key             =   ""
         EndProperty
         BeginProperty ListImage2 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fMainChild.frx":13DC
            Key             =   ""
         EndProperty
      EndProperty
   End
   Begin MSComctlLib.ListView lvTask 
      Height          =   735
      Left            =   960
      TabIndex        =   0
      Top             =   1320
      Width           =   1575
      _ExtentX        =   2778
      _ExtentY        =   1296
      LabelWrap       =   -1  'True
      HideSelection   =   -1  'True
      _Version        =   393217
      ForeColor       =   -2147483640
      BackColor       =   -2147483643
      BorderStyle     =   1
      Appearance      =   1
      NumItems        =   0
   End
   Begin MSComctlLib.ListView lvSchedule 
      Height          =   735
      Left            =   2100
      TabIndex        =   1
      Top             =   1320
      Width           =   1575
      _ExtentX        =   2778
      _ExtentY        =   1296
      LabelWrap       =   -1  'True
      HideSelection   =   -1  'True
      _Version        =   393217
      ForeColor       =   -2147483640
      BackColor       =   -2147483643
      BorderStyle     =   1
      Appearance      =   1
      NumItems        =   0
   End
   Begin VB.Label Label1 
      BackStyle       =   0  'Transparent
      Caption         =   "Definición de tareas de Backup y Programación de ejecuciones"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   13.5
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   735
      Left            =   900
      TabIndex        =   3
      Top             =   300
      UseMnemonic     =   0   'False
      Width           =   8115
   End
   Begin VB.Image Image1 
      Height          =   780
      Left            =   0
      Picture         =   "fMainChild.frx":1976
      Top             =   60
      Width           =   750
   End
   Begin VB.Shape shBottom 
      BackColor       =   &H00FFFFFF&
      BackStyle       =   1  'Opaque
      BorderStyle     =   0  'Transparent
      Height          =   495
      Left            =   480
      Top             =   2280
      Width           =   3255
   End
   Begin VB.Label lbDescrip 
      BackColor       =   &H00C0C0C0&
      BackStyle       =   0  'Transparent
      Caption         =   "Seleccione una tarea ..."
      Height          =   375
      Left            =   720
      TabIndex        =   2
      Top             =   3000
      Width           =   1215
   End
   Begin VB.Shape shBottomBorder 
      BorderColor     =   &H00808080&
      Height          =   495
      Left            =   2640
      Top             =   3120
      Width           =   855
   End
   Begin VB.Shape shTop 
      BackColor       =   &H00FFFFFF&
      BackStyle       =   1  'Opaque
      BorderStyle     =   0  'Transparent
      Height          =   975
      Left            =   0
      Top             =   0
      Width           =   9285
   End
End
Attribute VB_Name = "fMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Const C_Module = "fMainChild"

Private Sub Form_Load()
  On Error GoTo ControlError

  With lvTask
    .View = lvwReport
    .GridLines = True
    .LabelEdit = lvwManual
    .FullRowSelect = True
    .BorderStyle = ccNone
    .SmallIcons = ImageList1
  End With
  
  With lvSchedule
    .View = lvwReport
    .GridLines = True
    .LabelEdit = lvwManual
    .FullRowSelect = True
    .BorderStyle = ccNone
    .SmallIcons = ImageList1
  End With

  Me.WindowState = vbMaximized

  GoTo ExitProc
ControlError:
  MngError Err, "Form_Load", C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
  If NotUnloadFromAppOrWindows(UnloadMode) Then
    Cancel = True
  End If
End Sub

Private Sub Form_Resize()
  On Error Resume Next
  
  Const csBottomHeight As Integer = 1000
  Dim iHeight As Single
  
  iHeight = (Me.ScaleHeight - csBottomHeight - shTop.Height) / 2
  
  lvTask.Move 0, shTop.Height, Me.ScaleWidth, _
                    iHeight
                    
  lvSchedule.Move 0, lvTask.Top + iHeight, Me.ScaleWidth, _
                    iHeight
                    
  lbDescrip.Move 100, Me.ScaleHeight - csBottomHeight + 100, _
                      Me.ScaleWidth - 200, csBottomHeight - 200
                      
  shBottom.Move 0, Me.ScaleHeight - csBottomHeight, _
                   Me.ScaleWidth, csBottomHeight
                    
  shBottomBorder.Move 50, Me.ScaleHeight - csBottomHeight + 50, _
                          Me.ScaleWidth - 100, csBottomHeight - 100
End Sub

Private Sub lvSchedule_DblClick()
  fMainMDI.mnuScheduleEdit_Click
End Sub

Private Sub lvTask_DblClick()
  fMainMDI.mnuTaskEdit_Click
End Sub

Private Sub lvTask_ItemClick(ByVal Item As MSComctlLib.ListItem)
  lbDescrip.Caption = Item.Tag
End Sub

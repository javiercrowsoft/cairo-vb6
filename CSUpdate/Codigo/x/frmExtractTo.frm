VERSION 5.00
Begin VB.Form frmExtractTo 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Extract To Folder..."
   ClientHeight    =   3930
   ClientLeft      =   4635
   ClientTop       =   5850
   ClientWidth     =   7245
   BeginProperty Font 
      Name            =   "Tahoma"
      Size            =   8.25
      Charset         =   0
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmExtractTo.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3930
   ScaleWidth      =   7245
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.CheckBox chkOverwritePrompt 
      Caption         =   "&Overwrite Prompt"
      Height          =   255
      Left            =   60
      TabIndex        =   10
      Top             =   1020
      Width           =   2475
   End
   Begin VB.CheckBox chkUseFolderNames 
      Caption         =   "&Use Folder Names"
      Height          =   255
      Left            =   60
      TabIndex        =   9
      Top             =   780
      Value           =   1  'Checked
      Width           =   2475
   End
   Begin VB.PictureBox picCapture 
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   3555
      Left            =   2640
      ScaleHeight     =   3495
      ScaleWidth      =   3195
      TabIndex        =   5
      Top             =   300
      Width           =   3255
   End
   Begin VB.CommandButton cmdCancel 
      Caption         =   "Cancel"
      Height          =   375
      Left            =   6000
      TabIndex        =   4
      Top             =   480
      Width           =   1215
   End
   Begin VB.CommandButton cmdExtract 
      Caption         =   "&Extract To"
      Height          =   375
      Left            =   6000
      TabIndex        =   3
      Top             =   60
      Width           =   1215
   End
   Begin VB.CommandButton cmdNewFolder 
      Caption         =   "&New Folder..."
      Height          =   375
      Left            =   6000
      TabIndex        =   2
      Top             =   3480
      Width           =   1215
   End
   Begin VB.ComboBox cboExtractTo 
      Height          =   315
      Left            =   60
      TabIndex        =   1
      Text            =   "Combo1"
      Top             =   300
      Width           =   2115
   End
   Begin VB.CommandButton cmdPick 
      Caption         =   "4"
      BeginProperty Font 
         Name            =   "Marlett"
         Size            =   9
         Charset         =   2
         Weight          =   500
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   315
      Left            =   2220
      TabIndex        =   0
      Top             =   300
      Width           =   315
   End
   Begin VB.Label lblFolder 
      Caption         =   "Folder/Dirs"
      Height          =   195
      Left            =   2640
      TabIndex        =   7
      Top             =   60
      Width           =   2895
   End
   Begin VB.Label lblExtractTo 
      Caption         =   "Extract To:"
      Height          =   195
      Left            =   120
      TabIndex        =   6
      Top             =   60
      Width           =   2415
   End
   Begin VB.Image imgVBAL 
      Height          =   495
      Left            =   75
      Picture         =   "frmExtractTo.frx":1272
      Top             =   3255
      Width           =   2490
   End
   Begin VB.Label Label1 
      BackColor       =   &H00000000&
      BorderStyle     =   1  'Fixed Single
      Caption         =   "Label1"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   675
      Left            =   60
      TabIndex        =   8
      Top             =   3180
      Width           =   2535
   End
End
Attribute VB_Name = "frmExtractTo"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private m_c As cCaptureBF
' Whether user cancelled or not:
Private m_bCancel As Boolean
' MRU of Extract locations:
Private m_s() As String
Private m_iCount As Long
' Options:
Private m_sCurrentFolder As String
Private m_bOVerwritePrompt As Boolean
Private m_bUseFolderNames As Boolean

Private Declare Function SetFocusAPI Lib "user32" Alias "SetFocus" (ByVal hwnd As Long) As Long

Implements ICaptureBF

Public Sub LoadMRU(ByRef cTheMRU As cMRU)
Dim i As Long
   m_iCount = cTheMRU.Count
   If m_iCount > 0 Then
      ReDim m_s(1 To m_iCount) As String
      For i = 1 To m_iCount
         m_s(i) = cTheMRU.Item(i)
      Next i
   End If
   
End Sub

Private Function doUnload()
   ' Do this before we unload, otherwise
   ' the main form looses focus, or another
   ' window can flash to the foreground
   ' before it does come into focus (a problem
   ' with VB when you show a form from a
   ' disabled form: when you unload the form
   ' you showed, VB cannot set focus back to
   ' the form, and fails to ZOrder it properly!)
   frmUnzip.Enabled = True
   frmUnzip.SetFocus
   ' Actually unload:
   Unload Me
End Function

Public Property Get Cancelled() As Boolean
   Cancelled = m_bCancel
End Property
Public Property Get SelectedFolder() As String
   SelectedFolder = m_sCurrentFolder
End Property
Public Property Get OverwritePrompt() As Boolean
   OverwritePrompt = m_bOVerwritePrompt
End Property
Public Property Let OverwritePrompt(ByVal bState As Boolean)
   m_bOVerwritePrompt = bState
End Property
Public Property Get UseFolderNames() As Boolean
   UseFolderNames = m_bUseFolderNames
End Property
Public Property Let UseFolderNames(ByVal bState As Boolean)
   m_bUseFolderNames = bState
End Property

Private Sub chkOverwritePrompt_Click()
   m_bOVerwritePrompt = (chkOverwritePrompt.Value = Checked)
End Sub

Private Sub chkUseFolderNames_Click()
   m_bUseFolderNames = (chkUseFolderNames.Value = Checked)
End Sub

Private Sub cmdCancel_Click()
   doUnload
End Sub

Private Sub cmdExtract_Click()
   ' Chosen to extract!
   m_bCancel = False
   doUnload
End Sub

Private Sub cmdNewFolder_Click()
Dim sI As String
   ' Get a new folder to extract to:
   sI = InputBox("Please enter the folder name.", , m_sCurrentFolder)
   If sI <> "" Then
      On Error Resume Next
      MkDir sI
      If Err.Number <> 0 Then
         MsgBox "An error occurred: " & Err.Description, vbExclamation
      Else
         ' Reload the browse dialog but point to
         ' the newly created path.  This is much
         ' smoother than the WinZip equivalent!!!
         m_c.Reload sI
      End If
   End If
End Sub

Private Sub cmdPick_Click()
   m_c.Browse.SetFolder cboExtractTo.Text
End Sub

Private Sub Form_Initialize()
   'DebugMsg "frmCapture:Initialize"
   m_bCancel = True
End Sub

Private Sub Form_Load()
Dim i As Long
   ' Set up options:
   For i = 1 To m_iCount
      cboExtractTo.AddItem m_s(i)
   Next i
   chkOverwritePrompt.Value = Abs(m_bOVerwritePrompt)
   chkUseFolderNames.Value = Abs(m_bUseFolderNames)
End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
   ' Ensure we have unloaded the dialog:
   m_c.Unload
   ' Important: to ensure this class terminates we
   ' must set to nothing here:
   Set m_c = Nothing
   ' Re-enable the main form- this ensures it doesn't loose focus
End Sub

Private Sub Form_Terminate()
   'DebugMsg "frmCapture:Terminate"
End Sub

Private Property Let ICaptureBF_CaptureBrowseForFolder(RHS As Object)
   ' Provides you with a reference to the cCaptureBrowseForFolder
   ' object, which you can use to refer to the cBrowseForFolder
   ' dialog:
   Set m_c = RHS
End Property

Private Property Get ICaptureBF_CapturehWnd() As Long
   ' Requests the window you want to capture the folder browse
   ' dialog into.  You must ensure you have shown the form at this stage.
   Me.Show , frmUnzip
   picCapture.BorderStyle = 0
   ICaptureBF_CapturehWnd = picCapture.hwnd
End Property

Private Sub ICaptureBF_SelectionChanged(ByVal sPath As String)
   ' Fired when the selection in the folder browse dialog
   ' changes:
   cboExtractTo.Text = sPath
   cboExtractTo.SelStart = Len(sPath)
   If Len(sPath) > 0 Then
      cboExtractTo.SelLength = Len(sPath)
   End If
   m_sCurrentFolder = sPath
End Sub

Private Sub ICaptureBF_Unload()
   ' Fired when the browse for folder dialog
   ' is closed.  Ensures that you clear up at
   ' the right time.
   doUnload
End Sub



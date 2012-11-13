VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Begin VB.Form frmUnzip 
   AutoRedraw      =   -1  'True
   Caption         =   "Unzip Tester"
   ClientHeight    =   5940
   ClientLeft      =   3990
   ClientTop       =   2370
   ClientWidth     =   8685
   BeginProperty Font 
      Name            =   "Tahoma"
      Size            =   8.25
      Charset         =   0
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmUnzip.frx":0000
   LinkTopic       =   "VBUnzFrm"
   ScaleHeight     =   5940
   ScaleWidth      =   8685
   Begin MSComctlLib.ImageList ilsIcons16 
      Left            =   7800
      Top             =   4200
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483643
      ImageWidth      =   16
      ImageHeight     =   16
      MaskColor       =   12632256
      _Version        =   393216
      BeginProperty Images {2C247F25-8591-11D1-B16A-00C0F0283628} 
         NumListImages   =   2
         BeginProperty ListImage1 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmUnzip.frx":1272
            Key             =   "DEFAULT"
         EndProperty
         BeginProperty ListImage2 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmUnzip.frx":13CC
            Key             =   "OPEN"
         EndProperty
      EndProperty
   End
   Begin MSComctlLib.ListView lvwZip 
      Height          =   5115
      Left            =   60
      TabIndex        =   5
      Top             =   420
      Width           =   7455
      _ExtentX        =   13150
      _ExtentY        =   9022
      View            =   3
      MultiSelect     =   -1  'True
      LabelWrap       =   -1  'True
      HideSelection   =   -1  'True
      _Version        =   393217
      ForeColor       =   -2147483640
      BackColor       =   -2147483643
      BorderStyle     =   1
      Appearance      =   1
      NumItems        =   0
   End
   Begin MSComctlLib.StatusBar sbrMain 
      Align           =   2  'Align Bottom
      Height          =   255
      Left            =   0
      TabIndex        =   4
      Top             =   5685
      Width           =   8685
      _ExtentX        =   15319
      _ExtentY        =   450
      _Version        =   393216
      BeginProperty Panels {8E3867A5-8586-11D1-B16A-00C0F0283628} 
         NumPanels       =   1
         BeginProperty Panel1 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
            AutoSize        =   1
            Object.Width           =   14817
         EndProperty
      EndProperty
   End
   Begin VB.CommandButton cmdInvert 
      Caption         =   "&Invert"
      Enabled         =   0   'False
      Height          =   315
      Left            =   3660
      TabIndex        =   3
      Top             =   60
      Width           =   1155
   End
   Begin VB.CommandButton cmdAll 
      Caption         =   "&Select All"
      Enabled         =   0   'False
      Height          =   315
      Left            =   2460
      TabIndex        =   2
      Top             =   60
      Width           =   1155
   End
   Begin VB.CommandButton cmdExtract 
      Caption         =   "&Extract..."
      Enabled         =   0   'False
      Height          =   315
      Left            =   1260
      TabIndex        =   1
      Top             =   60
      Width           =   1155
   End
   Begin VB.CommandButton cmdOpen 
      Caption         =   "&Open..."
      Height          =   315
      Left            =   60
      TabIndex        =   0
      Top             =   60
      Width           =   1155
   End
   Begin VB.Menu mnuFileTOP 
      Caption         =   "&File"
      Begin VB.Menu mnuFile 
         Caption         =   "&Open..."
         Index           =   0
         Shortcut        =   ^O
      End
      Begin VB.Menu mnuFile 
         Caption         =   "Ex&tract..."
         Enabled         =   0   'False
         Index           =   1
         Shortcut        =   {F5}
      End
      Begin VB.Menu mnuFile 
         Caption         =   "-"
         Index           =   2
         Visible         =   0   'False
      End
      Begin VB.Menu mnuFile 
         Caption         =   ""
         Index           =   3
         Visible         =   0   'False
      End
      Begin VB.Menu mnuFile 
         Caption         =   ""
         Index           =   4
         Visible         =   0   'False
      End
      Begin VB.Menu mnuFile 
         Caption         =   ""
         Index           =   5
         Visible         =   0   'False
      End
      Begin VB.Menu mnuFile 
         Caption         =   ""
         Index           =   6
         Visible         =   0   'False
      End
      Begin VB.Menu mnuFile 
         Caption         =   "-"
         Index           =   7
      End
      Begin VB.Menu mnuFile 
         Caption         =   "&Close"
         Index           =   8
      End
   End
   Begin VB.Menu mnuEditTOP 
      Caption         =   "&Edit"
      Begin VB.Menu mnuEdit 
         Caption         =   "&Select All"
         Enabled         =   0   'False
         Index           =   0
         Shortcut        =   ^A
      End
      Begin VB.Menu mnuEdit 
         Caption         =   "&Invert Selection"
         Enabled         =   0   'False
         Index           =   1
      End
   End
   Begin VB.Menu mnuHelpTOP 
      Caption         =   "&Help"
      Begin VB.Menu mnuHelp 
         Caption         =   "&About..."
         Index           =   0
      End
   End
End
Attribute VB_Name = "frmUnzip"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

' ======================================================================================
' Name:     vbAccelerator Unzip sample
' Author:   Steve McMahon (steve@vbaccelerator.com)
' Date:     1 December 2000
'
' Requires: Info-ZIP's Unzip32.DLL v5.40, renamed to vbuzip10.dll
'           mUnzip.bas
'
' Copyright © 2000 Steve McMahon for vbAccelerator
' --------------------------------------------------------------------------------------
' Visit vbAccelerator - advanced free source code for VB programmers
' http://vbaccelerator.com
' --------------------------------------------------------------------------------------
'
' This sample uses decompression code by the Info-ZIP group.  The
' original Info-Zip sources are freely available from their website
' at
'     http://www.cdrcom.com/pubs/infozip/
'
' Please ensure you visit the site and read their free source licensing
' information and requirements before using their code in your own
' application.
'
' ======================================================================================

Private WithEvents m_cUnzip As cUnzip
Attribute m_cUnzip.VB_VarHelpID = -1
Private m_cExtractToMRU As cMRU
Private m_cZipMRU As cMRU
Private m_sBaseKey As String

Private Function pOpen(ByVal sFIle As String) As Boolean
Dim i As Long
Dim sIcon As String
Dim itmX As ListItem

   lvwZip.ListItems.Clear
   
   ' Get the file directory:
   m_cUnzip.ZipFile = sFIle
   m_cUnzip.Directory
   
   If m_cUnzip.FileCount > 0 Then
      m_cZipMRU.Add sFIle
      pShowOpenMRU
   End If
   
   pEnableControls
   
   ' Display it in the ListView:
   For i = 1 To m_cUnzip.FileCount
      sIcon = AddIconToImageList(m_cUnzip.Filename(i), ilsIcons16, "DEFAULT")
      sFIle = m_cUnzip.Filename(i)
      If m_cUnzip.FileEncrypted(i) Then
         ' the way WinZip represents it.  I guess a nicer way would be
         ' to use overlay icons/state icons and/or colour changes in the LV
         sFIle = sFIle & "+"
      End If
      Set itmX = lvwZip.ListItems.Add(, "File" & i, sFIle, , sIcon)
      itmX.SubItems(1) = m_cUnzip.FileSize(i)
      itmX.SubItems(2) = Format$(m_cUnzip.FileDate(i), "short date") & " " & Format$(m_cUnzip.FileDate(i), "short time")
      itmX.SubItems(3) = m_cUnzip.FilePackedSize(i)
      itmX.SubItems(4) = m_cUnzip.FileDirectory(i)
   Next i

End Function

Private Function FileExists(ByVal sFIle As String) As Boolean
Dim s As String
On Error Resume Next
   s = Dir(sFIle)
   FileExists = ((s <> "") And (Err.Number = 0))
End Function

Private Function KillFileIfExists(ByVal sFIle As String) As Boolean
   On Error Resume Next
   Kill sFIle
   KillFileIfExists = ((Err.Number = 0) Or (Err.Number = 53))
End Function

Private Sub pEnableControls()
Dim bS As Boolean
   bS = (m_cUnzip.FileCount > 0)
   cmdExtract.Enabled = bS
   mnuFile(1).Enabled = bS
   cmdAll.Enabled = bS
   mnuEdit(0).Enabled = bS
   cmdInvert.Enabled = bS
   mnuEdit(1).Enabled = bS
End Sub

Private Sub pShowOpenMRU()
Dim i As Long
Dim iC As Long
   If m_cZipMRU.Count > 0 Then
      mnuFile(2).Visible = True
      iC = m_cZipMRU.Count
      If iC > 4 Then iC = 4
      For i = 1 To iC
         mnuFile(i + 2).Visible = True
         mnuFile(i + 2).Caption = "&" & i & ") " & m_cZipMRU.Item(i)
         mnuFile(i + 2).Tag = m_cZipMRU.Item(i)
         If i = 1 Then
            mnuFile(i + 2).Checked = (m_cUnzip.FileCount > 0)
         End If
      Next i
   End If
End Sub
Private Function pbLoadOptions(ByRef hKey As ERegistryClassConstants) As Boolean
On Error Resume Next

   Dim cR As New cRegistry
   
   cR.ClassKey = hKey
   cR.SectionKey = m_sBaseKey
   If cR.KeyExists Then
      cR.ValueType = REG_DWORD
      cR.ValueKey = "UseFolderNames"
      m_cUnzip.UseFolderNames = Not (cR.Value = 0)
      cR.ValueKey = "OverwritePrompt"
      m_cUnzip.PromptToOverwrite = Not (cR.Value = 0)
      cR.SectionKey = m_sBaseKey & "\ExtractToMRU"
      If cR.KeyExists Then
         m_cExtractToMRU.DeSerialise cR
         cR.SectionKey = m_sBaseKey & "\FileOpenMRU"
         If cR.KeyExists Then
            m_cZipMRU.DeSerialise cR
            pbLoadOptions = True
            pShowOpenMRU
         End If
      End If
   End If
End Function
Private Sub pSaveOptions(ByVal hKey As ERegistryClassConstants)
   Dim cR As New cRegistry
   
   cR.ClassKey = hKey
   cR.SectionKey = m_sBaseKey & "\ExtractToMRU"
   m_cExtractToMRU.Serialise cR
   
   cR.SectionKey = m_sBaseKey & "\FileOpenMRU"
   m_cZipMRU.Serialise cR
   
   cR.ValueType = REG_DWORD
   cR.SectionKey = m_sBaseKey
   cR.ValueKey = "UseFolderNames"
   cR.Value = Abs(m_cUnzip.UseFolderNames)
   cR.ValueKey = "OverwritePrompt"
   cR.Value = Abs(m_cUnzip.PromptToOverwrite)
   
End Sub

Private Sub cmdAll_Click()
Dim itmX As ListItem
   For Each itmX In lvwZip.ListItems
      itmX.Selected = True
   Next itmX
End Sub

Private Sub cmdExtract_Click()
Dim itmX As ListItem
Dim bSel As Boolean
Dim sFolder As String
Dim iItem As Long

   ' Choose Selected items:
   For Each itmX In lvwZip.ListItems
      iItem = CLng(Mid$(itmX.Key, 5))
      m_cUnzip.FileSelected(iItem) = (itmX.Selected)
      If itmX.Selected Then
         bSel = True
      End If
   Next itmX
   
   ' If none selected do entire zip:
   If Not bSel Then
      For iItem = 1 To m_cUnzip.FileCount
         m_cUnzip.FileSelected(iItem) = True
      Next iItem
   End If
   
   ' Get extract folder and do it:
   sFolder = GetFolder()
   If (sFolder <> "") Then
      m_cExtractToMRU.Add sFolder
      m_cUnzip.UnzipFolder = sFolder
      m_cUnzip.Unzip
   End If
   
End Sub
Private Function GetFolder() As String
Dim i As Long

   Me.Enabled = False
   Dim fC As New frmExtractTo
   fC.LoadMRU m_cExtractToMRU
   Dim c As New cCaptureBF
   With c
      With .Browse
         .hWndOwner = Me.hwnd
         If m_cExtractToMRU.Count > 0 Then
            .InitialDir = m_cExtractToMRU.Item(1)
         Else
            .InitialDir = App.Path
         End If
         .FileSystemOnly = True
         .Title = ""
      End With
      .Show fC
   End With
   If Not fC.Cancelled Then
      ' Add selected location to the extract dir:
      m_cExtractToMRU.Add fC.SelectedFolder
      ' Store the selected options:
      m_cUnzip.PromptToOverwrite = fC.OverwritePrompt
      m_cUnzip.UseFolderNames = fC.UseFolderNames
      
      GetFolder = fC.SelectedFolder
   End If
End Function

Private Sub cmdInvert_Click()
Dim itmX As ListItem
   For Each itmX In lvwZip.ListItems
      itmX.Selected = Not (itmX.Selected)
   Next itmX
End Sub

Private Sub cmdOpen_Click()
Dim cc As New GCommonDialog
Dim sFIle As String

   If (cc.VBGetOpenFileName(sFIle, , , , , , "Zip Files (*.ZIP)|*.ZIP|All Files (*.*)|*.*", , , "Choose Zip FIle to Open", "ZIP", Me.hwnd)) Then
      pOpen sFIle
   End If
   
End Sub

Private Sub Form_Load()
   
   ' Apologies for the old school interface in this
   ' sample :)
   ' Pls feel welcome to add a real toolbar, add sorting
   ' to the ListView and so forth...

   ' Set up ListView
   With lvwZip
      .SmallIcons = ilsIcons16
      With .ColumnHeaders
         .Add , , "Filename", 160 * Screen.TwipsPerPixelX
         .Add , , "Size", 32 * Screen.TwipsPerPixelX
         .Add , , "Date", 96 * Screen.TwipsPerPixelX
         .Add , , "Packed", 32 * Screen.TwipsPerPixelX
         .Add , , "Folder", 160 * Screen.TwipsPerPixelX
      End With
   End With
      
   ' Set up unzipping object
   Set m_cUnzip = New cUnzip
   ' Set up Extract To MRU:
   Set m_cExtractToMRU = New cMRU
   ' Set up Zip FIles MRU:
   Set m_cZipMRU = New cMRU
   
   m_sBaseKey = "SOFTWARE\vbAccelerator\VBUnZip"
   If Not pbLoadOptions(HKEY_LOCAL_MACHINE) Then
      pbLoadOptions HKEY_CURRENT_USER
   End If
   
End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
On Error Resume Next
   pSaveOptions HKEY_CURRENT_USER
   pSaveOptions HKEY_LOCAL_MACHINE
End Sub

Private Sub Form_Resize()
   On Error Resume Next
   lvwZip.Move lvwZip.Left, lvwZip.Top, Me.ScaleWidth - lvwZip.Left * 2, Me.ScaleHeight - lvwZip.Top - sbrMain.Height - 4 * Screen.TwipsPerPixelY
End Sub

Private Sub m_cUnzip_Cancel(ByVal sMsg As String, bCancel As Boolean)
   Debug.Print "Cancel:" & sMsg
End Sub

Private Sub m_cUnzip_OverWritePrompt(ByVal sFIle As String, eResponse As EUZOverWriteResponse)
   'Debug.Print "Overwrite request: " & sFIle
   Dim fO As New frmOverwrite
   With fO
      .TheCaption = "Do you want to overwrite the existing copy of " & sFIle & "?"
      fO.Show vbModal, Me
      If fO.Response = vbYes Then
         If fO.ApplyToAll Then
            eResponse = euzOverwriteAllFiles
         Else
            eResponse = euzOverwriteThisFile
         End If
      ElseIf fO.Response = vbNo Then
         If fO.ApplyToAll Then
            eResponse = euzOverwriteNone
         Else
            eResponse = euzDoNotOverwrite
         End If
      Else
         ' Hmmm...
         eResponse = euzOverwriteNone
      End If
   End With
   
End Sub

Private Sub m_cUnzip_PasswordRequest(sPassword As String, bCancel As Boolean)
   Dim fP As New frmPassword
   With fP
      .Show vbModal, Me
      If Not fP.Cancelled Then
         sPassword = fP.Password
      Else
         bCancel = True
      End If
   End With
End Sub

Private Sub m_cUnzip_Progress(ByVal lCount As Long, ByVal sMsg As String)
   sbrMain.Panels(1).Text = sMsg
End Sub

Private Sub mnuEdit_Click(Index As Integer)
   Select Case Index
   Case 0
      cmdAll_Click
   Case 1
      cmdInvert_Click
   End Select
End Sub

Private Sub mnuFile_Click(Index As Integer)
   Select Case Index
   Case 0
      cmdOpen_Click
   Case 1
      cmdExtract_Click
   Case 8
      Unload Me
   Case Else
      If mnuFile(Index).Tag <> "" Then
         pOpen mnuFile(Index).Tag
      End If
   End Select
End Sub

Private Sub mnuHelp_Click(Index As Integer)
   MsgBox "vbAccelerator UnZip Demonstration." & vbCrLf & vbCrLf & "This sample uses decompression code by the Info-ZIP group.  The original Info-Zip sources are freely available from their website at http://www.cdrcom.com/pubs/infozip/", vbInformation
End Sub

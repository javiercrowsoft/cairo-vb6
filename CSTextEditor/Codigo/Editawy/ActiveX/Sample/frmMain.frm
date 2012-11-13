VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "comdlg32.ocx"
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Begin VB.MDIForm frmMain 
   BackColor       =   &H8000000C&
   Caption         =   "Mewsoft Visual Studio"
   ClientHeight    =   4905
   ClientLeft      =   165
   ClientTop       =   735
   ClientWidth     =   9705
   Icon            =   "frmMain.frx":0000
   LinkTopic       =   "MDIForm1"
   StartUpPosition =   3  'Windows Default
   Begin MSComctlLib.ImageList ImageList2 
      Left            =   1860
      Top             =   2400
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483643
      ImageWidth      =   16
      ImageHeight     =   16
      MaskColor       =   12632256
      _Version        =   393216
      BeginProperty Images {2C247F25-8591-11D1-B16A-00C0F0283628} 
         NumListImages   =   37
         BeginProperty ListImage1 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":0442
            Key             =   "ToggleBookmark"
         EndProperty
         BeginProperty ListImage2 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":0994
            Key             =   "NextBookmark"
         EndProperty
         BeginProperty ListImage3 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":0EE6
            Key             =   "PreviousBookmark"
         EndProperty
         BeginProperty ListImage4 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":1438
            Key             =   "ClearAllBookmarks"
         EndProperty
         BeginProperty ListImage5 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":198A
            Key             =   "ZoomIn"
         EndProperty
         BeginProperty ListImage6 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":1B64
            Key             =   "ZoomOut"
         EndProperty
         BeginProperty ListImage7 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":1D3E
            Key             =   "Tool9"
         EndProperty
         BeginProperty ListImage8 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":2290
            Key             =   "Tool10"
         EndProperty
         BeginProperty ListImage9 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":27E2
            Key             =   "Tool2"
         EndProperty
         BeginProperty ListImage10 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":2D34
            Key             =   "Tool3"
         EndProperty
         BeginProperty ListImage11 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":3286
            Key             =   "Tool4"
         EndProperty
         BeginProperty ListImage12 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":37D8
            Key             =   "Tool5"
         EndProperty
         BeginProperty ListImage13 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":3D2A
            Key             =   "Tool6"
         EndProperty
         BeginProperty ListImage14 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":427C
            Key             =   "Tool7"
         EndProperty
         BeginProperty ListImage15 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":47CE
            Key             =   "Tool8"
         EndProperty
         BeginProperty ListImage16 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":4D20
            Key             =   "Tool1"
         EndProperty
         BeginProperty ListImage17 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":5272
            Key             =   "Collapse"
            Object.Tag             =   "Collapse"
         EndProperty
         BeginProperty ListImage18 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":544C
            Key             =   "PreviousWindow"
         EndProperty
         BeginProperty ListImage19 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":55A6
            Key             =   "CloseWindow"
         EndProperty
         BeginProperty ListImage20 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":5700
            Key             =   "NextWindow"
         EndProperty
         BeginProperty ListImage21 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":585A
            Key             =   "Cascade"
         EndProperty
         BeginProperty ListImage22 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":59B4
            Key             =   "TileHorizontal"
         EndProperty
         BeginProperty ListImage23 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":5B0E
            Key             =   "TileVertical"
         EndProperty
         BeginProperty ListImage24 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":5C68
            Key             =   "Expand"
            Object.Tag             =   "Expand"
         EndProperty
         BeginProperty ListImage25 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":5E42
            Key             =   "ExpandAll"
            Object.Tag             =   "ExpandAll"
         EndProperty
         BeginProperty ListImage26 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":601C
            Key             =   "CollapseAll"
            Object.Tag             =   "CollapseAll"
         EndProperty
         BeginProperty ListImage27 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":61F6
            Key             =   "ToUpper"
         EndProperty
         BeginProperty ListImage28 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":6350
            Key             =   "ToLower"
         EndProperty
         BeginProperty ListImage29 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":68EA
            Key             =   "Wrap"
            Object.Tag             =   "Wrap"
         EndProperty
         BeginProperty ListImage30 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":6E84
            Key             =   "MacroRecord"
         EndProperty
         BeginProperty ListImage31 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":705E
            Key             =   "MacroStop"
         EndProperty
         BeginProperty ListImage32 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":7238
            Key             =   "Macro1q"
         EndProperty
         BeginProperty ListImage33 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":7392
            Key             =   "Macro1"
         EndProperty
         BeginProperty ListImage34 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":74EC
            Key             =   "Macro2"
         EndProperty
         BeginProperty ListImage35 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":7646
            Key             =   "Macro3"
         EndProperty
         BeginProperty ListImage36 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":77A0
            Key             =   "Macro4"
         EndProperty
         BeginProperty ListImage37 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":78FA
            Key             =   "Macro5"
         EndProperty
      EndProperty
   End
   Begin MSComctlLib.Toolbar tbToolBar1 
      Align           =   1  'Align Top
      Height          =   360
      Left            =   0
      TabIndex        =   3
      Top             =   360
      Width           =   9705
      _ExtentX        =   17119
      _ExtentY        =   635
      ButtonWidth     =   609
      ButtonHeight    =   582
      Wrappable       =   0   'False
      Appearance      =   1
      Style           =   1
      ImageList       =   "ImageList2"
      _Version        =   393216
      BeginProperty Buttons {66833FE8-8583-11D1-B16A-00C0F0283628} 
         NumButtons      =   23
         BeginProperty Button1 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "ToUpper"
            Object.ToolTipText     =   "To Upper"
            ImageKey        =   "ToUpper"
         EndProperty
         BeginProperty Button2 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "ToLower"
            Object.ToolTipText     =   "To Lower"
            ImageKey        =   "ToLower"
         EndProperty
         BeginProperty Button3 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Style           =   3
         EndProperty
         BeginProperty Button4 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "ExpandAll"
            Object.ToolTipText     =   "Expand All"
            ImageKey        =   "ExpandAll"
         EndProperty
         BeginProperty Button5 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "CollapseAll"
            Object.ToolTipText     =   "Collapse All"
            ImageKey        =   "CollapseAll"
         EndProperty
         BeginProperty Button6 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Style           =   3
         EndProperty
         BeginProperty Button7 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "ZoomIn"
            Object.ToolTipText     =   "Zoom In"
            ImageKey        =   "ZoomIn"
         EndProperty
         BeginProperty Button8 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "ZoomOut"
            Object.ToolTipText     =   "Zoom Out"
            ImageKey        =   "ZoomOut"
         EndProperty
         BeginProperty Button9 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Style           =   3
         EndProperty
         BeginProperty Button10 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "ToggleBookmark"
            Object.ToolTipText     =   "Toggle Bookmark"
            ImageKey        =   "ToggleBookmark"
         EndProperty
         BeginProperty Button11 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "NextBookmark"
            Object.ToolTipText     =   "Next Bookmark"
            ImageKey        =   "NextBookmark"
         EndProperty
         BeginProperty Button12 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "PreviousBookmark"
            Object.ToolTipText     =   "Previous Bookmark"
            ImageKey        =   "PreviousBookmark"
         EndProperty
         BeginProperty Button13 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "ClearAllBookmarks"
            Object.ToolTipText     =   "Clear All Bookmarks"
            ImageKey        =   "ClearAllBookmarks"
         EndProperty
         BeginProperty Button14 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Style           =   3
         EndProperty
         BeginProperty Button15 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "MacroRecord"
            Object.ToolTipText     =   "Macro Record"
            ImageKey        =   "MacroRecord"
         EndProperty
         BeginProperty Button16 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "MacroStop"
            Object.ToolTipText     =   "Macro Stop"
            ImageKey        =   "MacroStop"
         EndProperty
         BeginProperty Button17 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Style           =   3
         EndProperty
         BeginProperty Button18 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "Macro1"
            Object.ToolTipText     =   "Play Macro 1"
            ImageKey        =   "Macro1"
         EndProperty
         BeginProperty Button19 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "Macro2"
            Object.ToolTipText     =   "Play Macro 2"
            ImageKey        =   "Macro2"
         EndProperty
         BeginProperty Button20 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "Macro3"
            Object.ToolTipText     =   "Play Macro 3"
            ImageKey        =   "Macro3"
         EndProperty
         BeginProperty Button21 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "Macro4"
            Object.ToolTipText     =   "Play Macro 4"
            ImageKey        =   "Macro4"
         EndProperty
         BeginProperty Button22 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "Macro5"
            Object.ToolTipText     =   "Play Macro 5"
            ImageKey        =   "Macro5"
         EndProperty
         BeginProperty Button23 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Style           =   3
         EndProperty
      EndProperty
   End
   Begin MSComctlLib.ImageList ImageList1 
      Left            =   1080
      Top             =   2400
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
            Picture         =   "frmMain.frx":7A54
            Key             =   "LightOff"
            Object.Tag             =   "LightOff"
         EndProperty
         BeginProperty ListImage2 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":7EA6
            Key             =   "LightOn"
            Object.Tag             =   "LightOn"
         EndProperty
      EndProperty
   End
   Begin MSComctlLib.Toolbar tbDocs 
      Align           =   1  'Align Top
      Height          =   600
      Left            =   0
      TabIndex        =   2
      Top             =   720
      Width           =   9705
      _ExtentX        =   17119
      _ExtentY        =   1058
      ButtonWidth     =   1032
      ButtonHeight    =   1005
      Wrappable       =   0   'False
      Appearance      =   1
      Style           =   1
      TextAlignment   =   1
      ImageList       =   "ImageList1"
      _Version        =   393216
   End
   Begin MSComctlLib.Toolbar tbToolBar 
      Align           =   1  'Align Top
      Height          =   360
      Left            =   0
      TabIndex        =   1
      Top             =   0
      Width           =   9705
      _ExtentX        =   17119
      _ExtentY        =   635
      ButtonWidth     =   609
      ButtonHeight    =   582
      Wrappable       =   0   'False
      Appearance      =   1
      Style           =   1
      ImageList       =   "imlToolbarIcons"
      _Version        =   393216
      BeginProperty Buttons {66833FE8-8583-11D1-B16A-00C0F0283628} 
         NumButtons      =   25
         BeginProperty Button1 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "New"
            Object.ToolTipText     =   "New"
            ImageKey        =   "New"
         EndProperty
         BeginProperty Button2 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "Open"
            Object.ToolTipText     =   "Open"
            ImageKey        =   "Open"
         EndProperty
         BeginProperty Button3 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "Save"
            Object.ToolTipText     =   "Save"
            ImageKey        =   "Save"
         EndProperty
         BeginProperty Button4 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Style           =   3
         EndProperty
         BeginProperty Button5 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "Print"
            Object.ToolTipText     =   "Print"
            ImageKey        =   "Print"
         EndProperty
         BeginProperty Button6 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Style           =   3
         EndProperty
         BeginProperty Button7 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "Cut"
            Object.ToolTipText     =   "Cut"
            ImageKey        =   "Cut"
         EndProperty
         BeginProperty Button8 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "Copy"
            Object.ToolTipText     =   "Copy"
            ImageKey        =   "Copy"
         EndProperty
         BeginProperty Button9 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "Paste"
            Object.ToolTipText     =   "Paste"
            ImageKey        =   "Paste"
         EndProperty
         BeginProperty Button10 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "Delete"
            Object.ToolTipText     =   "Delete"
            ImageKey        =   "Delete"
         EndProperty
         BeginProperty Button11 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Style           =   3
         EndProperty
         BeginProperty Button12 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "Undo"
            Object.ToolTipText     =   "Undo"
            ImageKey        =   "Undo"
         EndProperty
         BeginProperty Button13 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "Redo"
            Object.ToolTipText     =   "Redo"
            ImageKey        =   "Redo"
         EndProperty
         BeginProperty Button14 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Style           =   3
         EndProperty
         BeginProperty Button15 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "Find"
            Object.ToolTipText     =   "Find"
            ImageKey        =   "Find"
         EndProperty
         BeginProperty Button16 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "FindNext"
            Object.ToolTipText     =   "Find Next"
            ImageKey        =   "FindNext"
         EndProperty
         BeginProperty Button17 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "FindPrev"
            Object.ToolTipText     =   "Find Previous"
            ImageKey        =   "FindPrev"
         EndProperty
         BeginProperty Button18 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "Replace"
            Object.ToolTipText     =   "Replace"
            Object.Tag             =   "Replace"
            ImageKey        =   "Replace"
         EndProperty
         BeginProperty Button19 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Style           =   3
         EndProperty
         BeginProperty Button20 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "Wrap"
            Object.ToolTipText     =   "Word wrap"
            ImageKey        =   "Wrap"
            Style           =   1
         EndProperty
         BeginProperty Button21 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Style           =   3
         EndProperty
         BeginProperty Button22 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "Properties"
            Object.ToolTipText     =   "Properties"
            ImageKey        =   "Properties"
         EndProperty
         BeginProperty Button23 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "View Details"
            Object.ToolTipText     =   "View Details"
            ImageKey        =   "View Details"
            Style           =   2
         EndProperty
         BeginProperty Button24 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "Help"
            Object.ToolTipText     =   "Help"
            ImageKey        =   "Help"
         EndProperty
         BeginProperty Button25 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Style           =   3
         EndProperty
      EndProperty
   End
   Begin MSComctlLib.StatusBar sbStatusBar 
      Align           =   2  'Align Bottom
      Height          =   270
      Left            =   0
      TabIndex        =   0
      Top             =   4635
      Width           =   9705
      _ExtentX        =   17119
      _ExtentY        =   476
      _Version        =   393216
      BeginProperty Panels {8E3867A5-8586-11D1-B16A-00C0F0283628} 
         NumPanels       =   10
         BeginProperty Panel1 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
            AutoSize        =   1
            Text            =   "Status"
            TextSave        =   "Status"
            Key             =   "Status"
            Object.Tag             =   "Status"
            Object.ToolTipText     =   "Status"
         EndProperty
         BeginProperty Panel2 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
            Text            =   "Line:"
            TextSave        =   "Line:"
            Key             =   "Line"
            Object.Tag             =   "Line"
            Object.ToolTipText     =   "Current Line"
         EndProperty
         BeginProperty Panel3 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
            Text            =   "Column:"
            TextSave        =   "Column:"
            Key             =   "Column"
            Object.Tag             =   "Column"
            Object.ToolTipText     =   "Column"
         EndProperty
         BeginProperty Panel4 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
            Text            =   "Total Lines:"
            TextSave        =   "Total Lines:"
            Key             =   "TotalLines"
            Object.Tag             =   "TotalLines"
            Object.ToolTipText     =   "Total Lines"
         EndProperty
         BeginProperty Panel5 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
            Text            =   "Position"
            TextSave        =   "Position"
            Key             =   "Position"
            Object.Tag             =   "Position"
            Object.ToolTipText     =   "Position"
         EndProperty
         BeginProperty Panel6 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
            Style           =   1
            AutoSize        =   2
            Enabled         =   0   'False
            Object.Width           =   900
            MinWidth        =   176
            TextSave        =   "CAPS"
         EndProperty
         BeginProperty Panel7 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
            Style           =   3
            AutoSize        =   2
            Enabled         =   0   'False
            Object.Width           =   635
            MinWidth        =   176
            TextSave        =   "INS"
         EndProperty
         BeginProperty Panel8 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
            Style           =   2
            AutoSize        =   2
            Enabled         =   0   'False
            Object.Width           =   820
            MinWidth        =   176
            TextSave        =   "NUM"
         EndProperty
         BeginProperty Panel9 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
            Style           =   6
            AutoSize        =   2
            Object.Width           =   1693
            MinWidth        =   176
            TextSave        =   "15/12/2005"
         EndProperty
         BeginProperty Panel10 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
            Style           =   5
            AutoSize        =   2
            Object.Width           =   1111
            MinWidth        =   176
            TextSave        =   "09:02 ã"
         EndProperty
      EndProperty
   End
   Begin MSComDlg.CommonDialog dlgCommonDialog 
      Left            =   180
      Top             =   3840
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin MSComctlLib.ImageList imlToolbarIcons 
      Left            =   240
      Top             =   2400
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483643
      ImageWidth      =   16
      ImageHeight     =   16
      MaskColor       =   12632256
      _Version        =   393216
      BeginProperty Images {2C247F25-8591-11D1-B16A-00C0F0283628} 
         NumListImages   =   19
         BeginProperty ListImage1 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":82F8
            Key             =   "New"
         EndProperty
         BeginProperty ListImage2 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":840A
            Key             =   "Open"
         EndProperty
         BeginProperty ListImage3 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":851C
            Key             =   "Save"
         EndProperty
         BeginProperty ListImage4 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":862E
            Key             =   "Print"
         EndProperty
         BeginProperty ListImage5 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":8740
            Key             =   "Cut"
         EndProperty
         BeginProperty ListImage6 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":8852
            Key             =   "Copy"
         EndProperty
         BeginProperty ListImage7 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":8964
            Key             =   "Paste"
         EndProperty
         BeginProperty ListImage8 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":8A76
            Key             =   "Delete"
         EndProperty
         BeginProperty ListImage9 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":8B88
            Key             =   "Undo"
         EndProperty
         BeginProperty ListImage10 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":8C9A
            Key             =   "Redo"
         EndProperty
         BeginProperty ListImage11 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":8DAC
            Key             =   "Find"
         EndProperty
         BeginProperty ListImage12 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":8EBE
            Key             =   "Macro"
         EndProperty
         BeginProperty ListImage13 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":8FD0
            Key             =   "Properties"
         EndProperty
         BeginProperty ListImage14 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":90E2
            Key             =   "View Details"
         EndProperty
         BeginProperty ListImage15 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":91F4
            Key             =   "Help"
         EndProperty
         BeginProperty ListImage16 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":9306
            Key             =   "Wrap"
            Object.Tag             =   "Wrap"
         EndProperty
         BeginProperty ListImage17 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":98A0
            Key             =   "FindNext"
         EndProperty
         BeginProperty ListImage18 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":99FA
            Key             =   "FindPrev"
         EndProperty
         BeginProperty ListImage19 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":9A92
            Key             =   "Replace"
         EndProperty
      EndProperty
   End
   Begin MSComctlLib.ImageList ImageList4 
      Index           =   0
      Left            =   0
      Top             =   0
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483643
      ImageWidth      =   16
      ImageHeight     =   16
      MaskColor       =   12632256
      _Version        =   393216
      BeginProperty Images {2C247F25-8591-11D1-B16A-00C0F0283628} 
         NumListImages   =   45
         BeginProperty ListImage1 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":9E14
            Key             =   "ToggleBookmark"
         EndProperty
         BeginProperty ListImage2 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":A366
            Key             =   "NextBookmark"
         EndProperty
         BeginProperty ListImage3 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":A8B8
            Key             =   "PreviousBookmark"
         EndProperty
         BeginProperty ListImage4 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":AE0A
            Key             =   "ClearAllBookmarks"
         EndProperty
         BeginProperty ListImage5 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":B35C
            Key             =   "ZoomIn"
         EndProperty
         BeginProperty ListImage6 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":B536
            Key             =   "ZoomOut"
         EndProperty
         BeginProperty ListImage7 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":B710
            Key             =   "Tool9"
         EndProperty
         BeginProperty ListImage8 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":BC62
            Key             =   "Tool10"
         EndProperty
         BeginProperty ListImage9 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":C1B4
            Key             =   "Tool2"
         EndProperty
         BeginProperty ListImage10 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":C706
            Key             =   "Tool3"
         EndProperty
         BeginProperty ListImage11 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":CC58
            Key             =   "Tool4"
         EndProperty
         BeginProperty ListImage12 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":D1AA
            Key             =   "Tool5"
         EndProperty
         BeginProperty ListImage13 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":D6FC
            Key             =   "Tool6"
         EndProperty
         BeginProperty ListImage14 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":DC4E
            Key             =   "Tool7"
         EndProperty
         BeginProperty ListImage15 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":E1A0
            Key             =   "Tool8"
         EndProperty
         BeginProperty ListImage16 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":E6F2
            Key             =   "Tool1"
         EndProperty
         BeginProperty ListImage17 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":EC44
            Key             =   "Collapse"
            Object.Tag             =   "Collapse"
         EndProperty
         BeginProperty ListImage18 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":EE1E
            Key             =   "PreviousWindow"
         EndProperty
         BeginProperty ListImage19 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":EF78
            Key             =   "CloseWindow"
         EndProperty
         BeginProperty ListImage20 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":F0D2
            Key             =   "NextWindow"
         EndProperty
         BeginProperty ListImage21 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":F22C
            Key             =   "Cascade"
         EndProperty
         BeginProperty ListImage22 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":F386
            Key             =   "TileHorizontal"
         EndProperty
         BeginProperty ListImage23 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":F4E0
            Key             =   "TileVertical"
         EndProperty
         BeginProperty ListImage24 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":F63A
            Key             =   "Expand"
            Object.Tag             =   "Expand"
         EndProperty
         BeginProperty ListImage25 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":F814
            Key             =   "ExpandAll"
            Object.Tag             =   "ExpandAll"
         EndProperty
         BeginProperty ListImage26 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":F9EE
            Key             =   "CollapseAll"
            Object.Tag             =   "CollapseAll"
         EndProperty
         BeginProperty ListImage27 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":FBC8
            Key             =   "ToUpper"
         EndProperty
         BeginProperty ListImage28 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":FD22
            Key             =   "ToLower"
         EndProperty
         BeginProperty ListImage29 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":102BC
            Key             =   ""
         EndProperty
         BeginProperty ListImage30 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":106D8
            Key             =   "Wrap"
            Object.Tag             =   "Wrap"
         EndProperty
         BeginProperty ListImage31 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":10C72
            Key             =   "MacroRecord"
         EndProperty
         BeginProperty ListImage32 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":11016
            Key             =   "MacroStop"
         EndProperty
         BeginProperty ListImage33 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":113BC
            Key             =   "MacroPlay"
         EndProperty
         BeginProperty ListImage34 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":11763
            Key             =   "Macro1"
         EndProperty
         BeginProperty ListImage35 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":11B0D
            Key             =   "Macro2"
         EndProperty
         BeginProperty ListImage36 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":11EBB
            Key             =   "Macro3"
         EndProperty
         BeginProperty ListImage37 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":12269
            Key             =   "Macro4"
         EndProperty
         BeginProperty ListImage38 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":12615
            Key             =   "Macro5"
         EndProperty
         BeginProperty ListImage39 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":129BE
            Key             =   "Macro6"
         EndProperty
         BeginProperty ListImage40 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":12D66
            Key             =   "Macro7"
         EndProperty
         BeginProperty ListImage41 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":13110
            Key             =   "Macro8"
         EndProperty
         BeginProperty ListImage42 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":134BC
            Key             =   "Macro9"
         EndProperty
         BeginProperty ListImage43 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":13866
            Key             =   "Macro10"
         EndProperty
         BeginProperty ListImage44 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":13C0F
            Key             =   "MacroKey"
         EndProperty
         BeginProperty ListImage45 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":13FB3
            Key             =   "Macro0"
         EndProperty
      EndProperty
   End
   Begin VB.Menu mnuFile 
      Caption         =   "&File"
      Begin VB.Menu mnuFileNew 
         Caption         =   "&New"
         Shortcut        =   ^N
      End
      Begin VB.Menu mnuFileOpen 
         Caption         =   "&Open..."
         Shortcut        =   ^O
      End
      Begin VB.Menu mnuFileClose 
         Caption         =   "&Close"
      End
      Begin VB.Menu mnuFileBar0 
         Caption         =   "-"
      End
      Begin VB.Menu mnuFileSave 
         Caption         =   "&Save"
         Shortcut        =   ^S
      End
      Begin VB.Menu mnuFileSaveAs 
         Caption         =   "Save &As..."
      End
      Begin VB.Menu mnuFileSaveAll 
         Caption         =   "Save A&ll"
      End
      Begin VB.Menu mnuFileBar1 
         Caption         =   "-"
      End
      Begin VB.Menu mnuFileProperties 
         Caption         =   "Propert&ies"
      End
      Begin VB.Menu mnuFileBar2 
         Caption         =   "-"
      End
      Begin VB.Menu mnuFilePageSetup 
         Caption         =   "Page Set&up..."
      End
      Begin VB.Menu mnuFilePrintPreview 
         Caption         =   "Print Pre&view"
      End
      Begin VB.Menu mnuFilePrint 
         Caption         =   "&Print..."
      End
      Begin VB.Menu mnuFileBar3 
         Caption         =   "-"
      End
      Begin VB.Menu mnuFileSend 
         Caption         =   "Sen&d..."
      End
      Begin VB.Menu mnuFileBar4 
         Caption         =   "-"
      End
      Begin VB.Menu mnuFileMRU 
         Caption         =   ""
         Index           =   1
         Visible         =   0   'False
      End
      Begin VB.Menu mnuFileMRU 
         Caption         =   ""
         Index           =   2
         Visible         =   0   'False
      End
      Begin VB.Menu mnuFileMRU 
         Caption         =   ""
         Index           =   3
         Visible         =   0   'False
      End
      Begin VB.Menu mnuFileBar5 
         Caption         =   "-"
         Visible         =   0   'False
      End
      Begin VB.Menu mnuFileExit 
         Caption         =   "E&xit"
      End
   End
   Begin VB.Menu mnuEdit 
      Caption         =   "&Edit"
      Begin VB.Menu mnuEditUndo 
         Caption         =   "&Undo"
      End
      Begin VB.Menu mnuEditBar0 
         Caption         =   "-"
      End
      Begin VB.Menu mnuEditCut 
         Caption         =   "Cu&t"
         Shortcut        =   ^X
      End
      Begin VB.Menu mnuEditCopy 
         Caption         =   "&Copy"
         Shortcut        =   ^C
      End
      Begin VB.Menu mnuEditPaste 
         Caption         =   "&Paste"
         Shortcut        =   ^V
      End
      Begin VB.Menu mnuEditPasteSpecial 
         Caption         =   "Paste &Special..."
      End
   End
   Begin VB.Menu mnuSearch 
      Caption         =   "&Search"
      Begin VB.Menu mnuFind 
         Caption         =   "&Find"
         Shortcut        =   ^F
      End
      Begin VB.Menu mnuReplace 
         Caption         =   "&Replace"
         Shortcut        =   ^H
      End
      Begin VB.Menu mnuSearch0 
         Caption         =   "-"
      End
      Begin VB.Menu mnuFindNext 
         Caption         =   "Find &Next"
         Shortcut        =   {F3}
      End
      Begin VB.Menu mnuFindPrevious 
         Caption         =   "Find &Previous"
         Shortcut        =   ^{F3}
      End
      Begin VB.Menu mnuSearch1 
         Caption         =   "-"
      End
      Begin VB.Menu mnuGoToLine 
         Caption         =   "Go to Line"
         Shortcut        =   ^G
      End
   End
   Begin VB.Menu mnuView 
      Caption         =   "&View"
      Begin VB.Menu mnuViewToolbar 
         Caption         =   "&Toolbar"
         Checked         =   -1  'True
      End
      Begin VB.Menu mnuViewStatusBar 
         Caption         =   "Status &Bar"
         Checked         =   -1  'True
      End
      Begin VB.Menu mnuViewBar0 
         Caption         =   "-"
      End
      Begin VB.Menu mnuViewRefresh 
         Caption         =   "&Refresh"
      End
      Begin VB.Menu mnuViewOptions 
         Caption         =   "&Options..."
      End
      Begin VB.Menu mnuViewWebBrowser 
         Caption         =   "&Web Browser"
      End
   End
   Begin VB.Menu mnuTools 
      Caption         =   "&Tools"
      Begin VB.Menu mnuToolsOptions 
         Caption         =   "&Options..."
      End
   End
   Begin VB.Menu mnuWindow 
      Caption         =   "&Window"
      WindowList      =   -1  'True
      Begin VB.Menu mnuWindowNewWindow 
         Caption         =   "&New Window"
      End
      Begin VB.Menu mnuWindowBar0 
         Caption         =   "-"
      End
      Begin VB.Menu mnuWindowCascade 
         Caption         =   "&Cascade"
      End
      Begin VB.Menu mnuWindowTileHorizontal 
         Caption         =   "Tile &Horizontal"
      End
      Begin VB.Menu mnuWindowTileVertical 
         Caption         =   "Tile &Vertical"
      End
      Begin VB.Menu mnuWindowArrangeIcons 
         Caption         =   "&Arrange Icons"
      End
   End
   Begin VB.Menu mnuHelp 
      Caption         =   "&Help"
      Begin VB.Menu mnuHelpContents 
         Caption         =   "&Contents"
      End
      Begin VB.Menu mnuHelpSearchForHelpOn 
         Caption         =   "&Search For Help On..."
      End
      Begin VB.Menu mnuHelpBar0 
         Caption         =   "-"
      End
      Begin VB.Menu mnuHelpAbout 
         Caption         =   "&About "
      End
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Declare Function SendMessage Lib "user32" Alias "SendMessageA" (ByVal hwnd As Long, ByVal wMsg As Long, ByVal wParam As Long, ByVal lParam As Any) As Long
Const EM_UNDO = &HC7
Private Declare Function OSWinHelp% Lib "user32" Alias "WinHelpA" (ByVal hwnd&, ByVal HelpFile$, ByVal wCommand%, dwData As Any)

Private Sub MDIForm_Load()
    
    Me.Left = GetSetting(App.Title, "Settings", "MainLeft", 1000)
    Me.top = GetSetting(App.Title, "Settings", "MainTop", 1000)
    Me.width = GetSetting(App.Title, "Settings", "MainWidth", 6500)
    Me.height = GetSetting(App.Title, "Settings", "MainHeight", 6500)
    '-------------------------------------------------------
    ' Select the boomkark marker number 0 to 31
    lBookmarkMarker = 2
    'The markerMask argument should have one bit set for each marker you wish to find. Set bit 0 to find marker 0, bit 1 for marker 1 and so on. Used for marker search, find next and previous marks operations
    lBookmarkMarkerMask = &H4
    '-------------------------------------------------------
    lCurentMacro = 0
    tbToolBar1.Buttons("MacroRecord").Enabled = True
    tbToolBar1.Buttons("MacroStop").Enabled = False
    tbToolBar1.Buttons("Macro1").Enabled = False
    tbToolBar1.Buttons("Macro2").Enabled = False
    tbToolBar1.Buttons("Macro3").Enabled = False
    tbToolBar1.Buttons("Macro4").Enabled = False
    tbToolBar1.Buttons("Macro5").Enabled = False
    '-------------------------------------------------------
    LoadNewDoc
    'ActiveForm.Editawy1.SetFocus
    '-------------------------------------------------------
    'SetParent frmOutput.hWnd, Picture1.hWnd
End Sub

Private Sub LoadNewDoc()

    Static lDocumentCount As Long
    Dim frmD As frmDoc
    
    Dim sFilename As String
    Dim sKey As String
    Dim btnX As Button
    
    'LockWindowUpdate Me.hwnd
    
    lDocumentCount = lDocumentCount + 1
    Set frmD = New frmDoc
    Load frmD
    
    frmD.Caption = "Untitled" & CStr(lDocumentCount)
    
    sFilename = frmD.Caption
    
    sKey = "F" & CStr(lDocumentCount)
    frmD.Tag = sKey
    
    Set btnX = tbDocs.Buttons.Add(, sKey, sFilename, 2)
    btnX.ToolTipText = sFilename
    btnX.Description = btnX.ToolTipText
    btnX.Image = "LightOff"
    'btnX.Value = tbrPressed
    
    tbDocs.Buttons.Add , "S" & sKey, , tbrSeparator
    
    frmD.Show
    
    Set frmD = Nothing
    Set btnX = Nothing
    
    'LockWindowUpdate 0
    
End Sub

Private Sub MDIForm_Unload(Cancel As Integer)
    If Me.WindowState <> vbMinimized Then
        SaveSetting App.Title, "Settings", "MainLeft", Me.Left
        SaveSetting App.Title, "Settings", "MainTop", Me.top
        SaveSetting App.Title, "Settings", "MainWidth", Me.width
        SaveSetting App.Title, "Settings", "MainHeight", Me.height
    End If
End Sub

Private Sub mnuHelpAbout_Click()
    frmAbout.Show vbModal, Me
End Sub

Private Sub mnuHelpSearchForHelpOn_Click()
    Dim nRet As Integer

    'if there is no helpfile for this project display a message to the user
    'you can set the HelpFile for your application in the
    'Project Properties dialog
    If Len(App.HelpFile) = 0 Then
        MsgBox "Unable to display Help Contents. There is no Help associated with this project.", vbInformation, Me.Caption
    Else
        On Error Resume Next
        nRet = OSWinHelp(Me.hwnd, App.HelpFile, 261, 0)
        If Err Then
            MsgBox Err.Description
        End If
    End If

End Sub

Private Sub mnuHelpContents_Click()
    Dim nRet As Integer

    'if there is no helpfile for this project display a message to the user
    'you can set the HelpFile for your application in the
    'Project Properties dialog
    If Len(App.HelpFile) = 0 Then
        MsgBox "Unable to display Help Contents. There is no Help associated with this project.", vbInformation, Me.Caption
    Else
        On Error Resume Next
        nRet = OSWinHelp(Me.hwnd, App.HelpFile, 3, 0)
        If Err Then
            MsgBox Err.Description
        End If
    End If

End Sub

Private Sub mnuWindowArrangeIcons_Click()
    Me.Arrange vbArrangeIcons
End Sub

Private Sub mnuWindowTileVertical_Click()
    Me.Arrange vbTileVertical
End Sub

Private Sub mnuWindowTileHorizontal_Click()
    Me.Arrange vbTileHorizontal
End Sub

Private Sub mnuWindowCascade_Click()
    Me.Arrange vbCascade
End Sub

Private Sub mnuWindowNewWindow_Click()
    LoadNewDoc
End Sub

Private Sub mnuToolsOptions_Click()
    frmOptions.Show vbModal, Me
End Sub

Private Sub mnuViewWebBrowser_Click()
    Dim frmB As New frmBrowser
    frmB.StartingAddress = "http://www.mewsoft.com"
    frmB.Show
End Sub

Private Sub mnuViewOptions_Click()
    frmOptions.Show vbModal, Me
End Sub

Private Sub mnuViewRefresh_Click()
    'ToDo: Add 'mnuViewRefresh_Click' code.
    MsgBox "Add 'mnuViewRefresh_Click' code."
End Sub

Private Sub mnuViewStatusBar_Click()
    mnuViewStatusBar.Checked = Not mnuViewStatusBar.Checked
    sbStatusBar.Visible = mnuViewStatusBar.Checked
End Sub

Private Sub mnuViewToolbar_Click()
    mnuViewToolbar.Checked = Not mnuViewToolbar.Checked
    tbToolBar.Visible = mnuViewToolbar.Checked
End Sub

Private Sub mnuEditPasteSpecial_Click()
    'ToDo: Add 'mnuEditPasteSpecial_Click' code.
    MsgBox "Add 'mnuEditPasteSpecial_Click' code."
End Sub

Private Sub mnuEditPaste_Click()
    On Error Resume Next
    ActiveForm.Editawy1.Paste

End Sub

Private Sub mnuEditCopy_Click()
    On Error Resume Next
    ActiveForm.Editawy1.Copy

End Sub

Private Sub mnuEditCut_Click()
    On Error Resume Next
    ActiveForm.Editawy1.Cut

End Sub

Private Sub mnuEditUndo_Click()
    'ToDo: Add 'mnuEditUndo_Click' code.
    ActiveForm.Editawy1.Undo
End Sub


Private Sub mnuFileExit_Click()
    'unload the form
    Unload Me

End Sub

Private Sub mnuFileSend_Click()
    'ToDo: Add 'mnuFileSend_Click' code.
    MsgBox "Add 'mnuFileSend_Click' code."
End Sub

Private Sub mnuFilePrint_Click()
    On Error Resume Next
    If ActiveForm Is Nothing Then Exit Sub
    

    With dlgCommonDialog
        .DialogTitle = "Print"
        .CancelError = True
        .Flags = cdlPDReturnDC + cdlPDNoPageNums
        If ActiveForm.rtfText.SelLength = 0 Then
            .Flags = .Flags + cdlPDAllPages
        Else
            .Flags = .Flags + cdlPDSelection
        End If
        .ShowPrinter
        If Err <> MSComDlg.cdlCancel Then
            ActiveForm.rtfText.SelPrint .hDC
        End If
    End With

End Sub

Private Sub mnuFilePrintPreview_Click()
    'ToDo: Add 'mnuFilePrintPreview_Click' code.
    'MsgBox "Add 'mnuFilePrintPreview_Click' code."
    ActiveForm.Editawy1.SetFocus
End Sub

Private Sub mnuFilePageSetup_Click()
    On Error Resume Next
    With dlgCommonDialog
        .DialogTitle = "Page Setup"
        .CancelError = True
        .ShowPrinter
    End With
    ActiveForm.Editawy1.SetFocus
    
End Sub

Private Sub mnuFileProperties_Click()
    'ToDo: Add 'mnuFileProperties_Click' code.
    'MsgBox "Add 'mnuFileProperties_Click' code."
    ActiveForm.Editawy1.SetFocus
End Sub

Private Sub mnuFileSaveAll_Click()
    'ToDo: Add 'mnuFileSaveAll_Click' code.
    'MsgBox "Add 'mnuFileSaveAll_Click' code."
    ActiveForm.Editawy1.SetFocus
End Sub

Private Sub mnuFileSaveAs_Click()
    Dim sFile As String
    
    If ActiveForm Is Nothing Then Exit Sub

    With dlgCommonDialog
        .DialogTitle = "Save As"
        .CancelError = False
        'ToDo: set the flags and attributes of the common dialog control
        .Filter = "All Files (*.*)|*.*"
        .ShowSave
        If Len(.FileName) = 0 Then
            ActiveForm.Editawy1.SetFocus
            Exit Sub
        End If
        sFile = .FileName
    End With
    ActiveForm.Caption = sFile
    'ActiveForm.rtfText.SaveFile sFile
    ActiveForm.Editawy1.SetFocus

End Sub

Private Sub mnuFileSave_Click()
    
    Dim sFile As String
    
    If Left$(ActiveForm.Caption, 8) = "Untitled" Then
        With dlgCommonDialog
            .DialogTitle = "Save"
            .CancelError = False
            'ToDo: set the flags and attributes of the common dialog control
            .Filter = "All Files (*.*)|*.*"
            .ShowSave
            If Len(.FileName) = 0 Then
                ActiveForm.Editawy1.SetFocus
                Exit Sub
            End If
            sFile = .FileName
        End With
        'ActiveForm.rtfText.SaveFile sFile
    Else
        sFile = ActiveForm.Caption
        'ActiveForm.rtfText.SaveFile sFile
    End If
    
    ActiveForm.Editawy1.SetFocus
End Sub

Private Sub mnuFileClose_Click()
    'ToDo: Add 'mnuFileClose_Click' code.
    MsgBox "Add 'mnuFileClose_Click' code."
End Sub

Private Sub mnuFileOpen_Click()
    Dim sFile As String

    If ActiveForm Is Nothing Then LoadNewDoc

    With dlgCommonDialog
        .DialogTitle = "Open"
        .CancelError = False
        'ToDo: set the flags and attributes of the common dialog control
        .Filter = "All Files (*.*)|*.*"
        .ShowOpen
        If Len(.FileName) = 0 Then
            Exit Sub
        End If
        sFile = .FileName
    End With
    ActiveForm.rtfText.LoadFile sFile
    ActiveForm.Caption = sFile

End Sub

Private Sub mnuFileNew_Click()
    LoadNewDoc
End Sub

Private Sub tbDocs_ButtonClick(ByVal Button As MSComctlLib.Button)
    
    Dim Frm As Form
   'Debug.Print "Button.Key: "; Button.Key
   
    Dim X As Long
    For X = 1 To tbDocs.Buttons.Count
        tbDocs.Buttons(X).Value = tbrUnpressed
    Next X
    
    tbDocs.Buttons(Button.Key).Value = tbrPressed
   
    For Each Frm In Forms
        If Frm.Tag = Button.Key Then
            Frm.SetFocus
            Frm.Editawy1.SetFocus
        End If
    Next
    
    Dim i As Long
    
'    For i = 0 To Forms.Count - 1
'        Debug.Print "Caption: "; Forms(i).Caption
'    Next i
    ActiveForm.Editawy1.SetFocus
End Sub

Private Sub tbToolBar_ButtonClick(ByVal Button As MSComctlLib.Button)
    
    On Error Resume Next
    
    'Debug.Print "ActiveForm"; ActiveForm.Caption
    'ActiveForm.Editawy1.GrabFocus
    'ActiveForm.Editawy1.SetFocus
    
    Select Case Button.Key
        Case "New"
            LoadNewDoc
            
        Case "Open"
            mnuFileOpen_Click
            
        Case "Save"
            mnuFileSave_Click
            
        Case "Print"
            mnuFilePrint_Click
            
        Case "Cut"
            ActiveForm.Editawy1.Cut
            
        Case "Copy"
            ActiveForm.Editawy1.Copy
            
        Case "Paste"
            ActiveForm.Editawy1.Paste
            
        Case "Delete"
            ActiveForm.Editawy1.Clear
            
        Case "Undo"
            ActiveForm.Editawy1.Undo
            
        Case "Redo"
            ActiveForm.Editawy1.Redo
            
        Case "Find"
            frmFind.Show , Me
            frmFind.SetFocus
            'OnTop frmFind
            Exit Sub
        
        Case "FindNext":
            'frmFind.FindNext
        
        Case "Replace":
            frmReplace.Show , Me
            frmReplace.SetFocus
            Exit Sub
         
        'Wrap long lines at word boundaries
        Case "Wrap":
            If tbToolBar.Buttons("Wrap").Value = tbrPressed Then
                ActiveForm.Editawy1.WrapMode = 1
            Else
                ActiveForm.Editawy1.WrapMode = 0
            End If
            
        Case "Properties"
            
        Case "View Details"
            
        Case "Help"
            
    End Select
    ActiveForm.Editawy1.SetFocus
End Sub

Private Sub tbToolBar1_ButtonClick(ByVal Button As MSComctlLib.Button)
    
    On Error Resume Next
    
    Dim X As Long
    
    Select Case Button.Key
    
        'Convert selected text to upper case characters
        Case "ToUpper":
            ActiveForm.Editawy1.KeyUpperCase
        
        'Convert selected text to lower case characters
        Case "ToLower":
            ActiveForm.Editawy1.KeyLowerCase
                    
        'Expand all folding
        Case "ExpandAll"
            ActiveForm.Editawy1.ExpandAll
        
        'Collapse all folding
        Case "CollapseAll":
            ActiveForm.Editawy1.CollapseAll
        
        ' Zoom in 1 step
        Case "ZoomIn":
            ActiveForm.Editawy1.ZoomIn
            
        'Zoom out 1 step
        Case "ZoomOut":
            ActiveForm.Editawy1.ZoomOut
        
        'Display or hide bookmark at the current caret line
        Case "ToggleBookmark":
            X = ActiveForm.Editawy1.MarkerGet(ActiveForm.Editawy1.Line)
            If X > 0 Then
                ActiveForm.Editawy1.MarkerDelete ActiveForm.Editawy1.Line, lBookmarkMarker
            Else
                ActiveForm.Editawy1.MarkerAdd ActiveForm.Editawy1.Line, lBookmarkMarker
            End If
        
        'Move caret and display to next bookmark
        Case "NextBookmark":
            X = ActiveForm.Editawy1.MarkerNext(ActiveForm.Editawy1.Line + 1, lBookmarkMarkerMask)
            If X <> -1 Then
                ActiveForm.Editawy1.GotoLineEnsureVisible X
            End If
        
        'Move caret and display to previous bookmark
        Case "PreviousBookmark":
            X = ActiveForm.Editawy1.MarkerPrevious(ActiveForm.Editawy1.Line - 1, lBookmarkMarkerMask)
            If X <> -1 Then
                ActiveForm.Editawy1.GotoLineEnsureVisible X
            End If
        
        'Delete al markers
        Case "ClearAllBookmarks":
            ActiveForm.Editawy1.MarkerDeleteAll lBookmarkMarker
        
        Case "MacroRecord":
            bMacroRecording = True
            tbToolBar1.Buttons("MacroRecord").Enabled = False
            tbToolBar1.Buttons("MacroStop").Enabled = True
            lCurentMacro = lCurentMacro + 1
            If lCurentMacro > 5 Then lCurentMacro = 1
            sMacros(lCurentMacro) = ""
            ActiveForm.Editawy1.StartRecord
            
        Case "MacroStop":
            bMacroRecording = False
            tbToolBar1.Buttons("MacroRecord").Enabled = True
            tbToolBar1.Buttons("MacroStop").Enabled = False
            ActiveForm.Editawy1.StopRecord
            
            If sMacros(lCurentMacro) = "" Then
                lCurentMacro = lCurentMacro - 1
            Else
                tbToolBar1.Buttons("Macro" & CStr(lCurentMacro)).Enabled = True
            End If
        
        Case "Macro1":
            PlayMacro 1
            
        Case "Macro2":
            PlayMacro 2
            
        Case "Macro3":
            PlayMacro 3
            
        Case "Macro4":
            PlayMacro 4
            
        Case "Macro5":
            PlayMacro 5
            
    End Select
    
End Sub

Public Sub PlayMacro(ByVal lMacroNumber As Long)
            
    Dim Cmds() As String
    Dim Msgs() As String
    Dim Macro As Long
    
    If sMacros(lMacroNumber) = "" Then Exit Sub
    Cmds = Split(sMacros(lMacroNumber), "|")
    
    For Macro = 1 To UBound(Cmds)
        Msgs = Split(Cmds(Macro), ":")
        ActiveForm.Editawy1.SendEditor Msgs(0), Msgs(1), Msgs(2)
    Next Macro

End Sub
Private Sub mnuFind_Click()
    frmFind.Show , Me
    frmFind.SetFocus
    'frmFind.FindNext
End Sub
Private Sub mnuReplace_Click()
    frmReplace.Show , Me
    frmReplace.SetFocus
End Sub

Private Sub mnuGoToLine_Click()
    'frmGoTo.Show vbModal, Me
End Sub

Private Sub mnuFindNext_Click()
    Debug.Print "mnuFindNext_Click"
    'Debug.Print ActiveForm.Editawy1.SearchNext(lLastSearchFlags, sLastSearchTerm)
End Sub

Private Sub mnuFindPrevious_Click()
    Debug.Print "mnuFindPrevious_Click"
    'Debug.Print ActiveForm.Editawy1.SearchPrev(lLastSearchFlags, sLastSearchTerm)
End Sub


Private Sub Toolbar1_ButtonClick(ByVal Button As MSComctlLib.Button)
    Select Case Button.Key
    Case "Test":
        Debug.Print "Test key"
    End Select
End Sub

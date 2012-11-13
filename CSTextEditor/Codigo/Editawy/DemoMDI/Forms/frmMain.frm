VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "comdlg32.ocx"
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Object = "{BDC217C8-ED16-11CD-956C-0000C04E4C0A}#1.1#0"; "Tabctl32.ocx"
Begin VB.MDIForm frmMain 
   BackColor       =   &H8000000C&
   Caption         =   "Editawy"
   ClientHeight    =   4935
   ClientLeft      =   165
   ClientTop       =   735
   ClientWidth     =   9510
   LinkTopic       =   "MDIForm1"
   StartUpPosition =   3  'Windows Default
   Begin VB.PictureBox picDocs 
      Align           =   1  'Align Top
      Appearance      =   0  'Flat
      ForeColor       =   &H80000008&
      Height          =   435
      Left            =   0
      ScaleHeight     =   405
      ScaleWidth      =   9480
      TabIndex        =   12
      Top             =   720
      Width           =   9510
      Begin MSComctlLib.TabStrip TabStrip1 
         Height          =   315
         Left            =   60
         TabIndex        =   13
         Top             =   60
         Width           =   9195
         _ExtentX        =   16219
         _ExtentY        =   556
         Style           =   2
         HotTracking     =   -1  'True
         Separators      =   -1  'True
         ImageList       =   "ImageList1"
         _Version        =   393216
         BeginProperty Tabs {1EFB6598-857C-11D1-B16A-00C0F0283628} 
            NumTabs         =   1
            BeginProperty Tab1 {1EFB659A-857C-11D1-B16A-00C0F0283628} 
               ImageVarType    =   2
            EndProperty
         EndProperty
      End
   End
   Begin VB.PictureBox picOutput 
      Align           =   2  'Align Bottom
      Appearance      =   0  'Flat
      ForeColor       =   &H80000008&
      Height          =   1575
      Left            =   0
      ScaleHeight     =   1545
      ScaleWidth      =   9480
      TabIndex        =   3
      Top             =   3090
      Width           =   9510
      Begin TabDlg.SSTab SSTab1 
         Height          =   1275
         Left            =   60
         TabIndex        =   4
         Top             =   120
         Width           =   9135
         _ExtentX        =   16113
         _ExtentY        =   2249
         _Version        =   393216
         TabOrientation  =   1
         Style           =   1
         TabHeight       =   520
         TabCaption(0)   =   "Output"
         TabPicture(0)   =   "frmMain.frx":0000
         Tab(0).ControlEnabled=   -1  'True
         Tab(0).Control(0)=   "frameOutput"
         Tab(0).Control(0).Enabled=   0   'False
         Tab(0).ControlCount=   1
         TabCaption(1)   =   "Find in files"
         TabPicture(1)   =   "frmMain.frx":001C
         Tab(1).ControlEnabled=   0   'False
         Tab(1).Control(0)=   "frameSearch"
         Tab(1).ControlCount=   1
         TabCaption(2)   =   "Clipboard"
         TabPicture(2)   =   "frmMain.frx":0038
         Tab(2).ControlEnabled=   0   'False
         Tab(2).Control(0)=   "FrameClipboard"
         Tab(2).ControlCount=   1
         Begin VB.Frame FrameClipboard 
            Height          =   735
            Left            =   -74880
            TabIndex        =   9
            Top             =   60
            Width           =   5835
            Begin VB.TextBox txtClipboard 
               Height          =   495
               Left            =   840
               MultiLine       =   -1  'True
               TabIndex        =   10
               Top             =   180
               Width           =   3375
            End
         End
         Begin VB.Frame frameSearch 
            Height          =   795
            Left            =   -74820
            TabIndex        =   7
            Top             =   60
            Width           =   5475
            Begin MSComctlLib.ListView lvSearch 
               Height          =   555
               Left            =   840
               TabIndex        =   8
               Top             =   180
               Width           =   2595
               _ExtentX        =   4577
               _ExtentY        =   979
               LabelWrap       =   -1  'True
               HideSelection   =   -1  'True
               _Version        =   393217
               ForeColor       =   -2147483640
               BackColor       =   -2147483643
               BorderStyle     =   1
               Appearance      =   1
               NumItems        =   0
            End
         End
         Begin VB.Frame frameOutput 
            Height          =   735
            Left            =   540
            TabIndex        =   5
            Top             =   120
            Width           =   6075
            Begin VB.TextBox txtOutput 
               Height          =   495
               Left            =   900
               MultiLine       =   -1  'True
               TabIndex        =   6
               Top             =   180
               Width           =   3075
            End
         End
      End
   End
   Begin MSComDlg.CommonDialog dlgCommonDialog 
      Left            =   2880
      Top             =   1860
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin MSComctlLib.ImageList ImageList2 
      Left            =   4980
      Top             =   1860
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483643
      ImageWidth      =   16
      ImageHeight     =   16
      MaskColor       =   12632256
      _Version        =   393216
      BeginProperty Images {2C247F25-8591-11D1-B16A-00C0F0283628} 
         NumListImages   =   40
         BeginProperty ListImage1 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":0054
            Key             =   "ToggleBookmark"
         EndProperty
         BeginProperty ListImage2 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":05A6
            Key             =   "NextBookmark"
         EndProperty
         BeginProperty ListImage3 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":0AF8
            Key             =   "PreviousBookmark"
         EndProperty
         BeginProperty ListImage4 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":104A
            Key             =   "ClearAllBookmarks"
         EndProperty
         BeginProperty ListImage5 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":159C
            Key             =   "ZoomIn"
         EndProperty
         BeginProperty ListImage6 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":1776
            Key             =   "ZoomOut"
         EndProperty
         BeginProperty ListImage7 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":1950
            Key             =   "Tool9"
         EndProperty
         BeginProperty ListImage8 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":1EA2
            Key             =   "Tool10"
         EndProperty
         BeginProperty ListImage9 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":23F4
            Key             =   "Tool2"
         EndProperty
         BeginProperty ListImage10 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":2946
            Key             =   "Tool3"
         EndProperty
         BeginProperty ListImage11 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":2E98
            Key             =   "Tool4"
         EndProperty
         BeginProperty ListImage12 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":33EA
            Key             =   "Tool5"
         EndProperty
         BeginProperty ListImage13 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":393C
            Key             =   "Tool6"
         EndProperty
         BeginProperty ListImage14 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":3E8E
            Key             =   "Tool7"
         EndProperty
         BeginProperty ListImage15 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":43E0
            Key             =   "Tool8"
         EndProperty
         BeginProperty ListImage16 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":4932
            Key             =   "Tool1"
         EndProperty
         BeginProperty ListImage17 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":4E84
            Key             =   "Collapse"
            Object.Tag             =   "Collapse"
         EndProperty
         BeginProperty ListImage18 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":505E
            Key             =   "PreviousWindow"
         EndProperty
         BeginProperty ListImage19 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":51B8
            Key             =   "CloseWindow"
         EndProperty
         BeginProperty ListImage20 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":5312
            Key             =   "NextWindow"
         EndProperty
         BeginProperty ListImage21 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":546C
            Key             =   "Cascade"
         EndProperty
         BeginProperty ListImage22 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":55C6
            Key             =   "TileHorizontal"
         EndProperty
         BeginProperty ListImage23 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":5720
            Key             =   "TileVertical"
         EndProperty
         BeginProperty ListImage24 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":587A
            Key             =   "Expand"
            Object.Tag             =   "Expand"
         EndProperty
         BeginProperty ListImage25 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":5A54
            Key             =   "ExpandAll"
            Object.Tag             =   "ExpandAll"
         EndProperty
         BeginProperty ListImage26 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":5C2E
            Key             =   "CollapseAll"
            Object.Tag             =   "CollapseAll"
         EndProperty
         BeginProperty ListImage27 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":5E08
            Key             =   "ToUpper"
         EndProperty
         BeginProperty ListImage28 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":5F62
            Key             =   "ToLower"
         EndProperty
         BeginProperty ListImage29 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":64FC
            Key             =   "Wrap"
            Object.Tag             =   "Wrap"
         EndProperty
         BeginProperty ListImage30 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":6A96
            Key             =   "MacroRecord"
         EndProperty
         BeginProperty ListImage31 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":6C70
            Key             =   "MacroStop"
         EndProperty
         BeginProperty ListImage32 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":6E4A
            Key             =   "Macro1q"
         EndProperty
         BeginProperty ListImage33 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":6FA4
            Key             =   "Macro1"
         EndProperty
         BeginProperty ListImage34 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":70FE
            Key             =   "Macro2"
         EndProperty
         BeginProperty ListImage35 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":7258
            Key             =   "Macro3"
         EndProperty
         BeginProperty ListImage36 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":73B2
            Key             =   "Macro4"
         EndProperty
         BeginProperty ListImage37 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":750C
            Key             =   "Macro5"
         EndProperty
         BeginProperty ListImage38 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":7666
            Key             =   "NoZoom"
         EndProperty
         BeginProperty ListImage39 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":7840
            Key             =   "Indent"
         EndProperty
         BeginProperty ListImage40 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":7A1A
            Key             =   "Outdent"
         EndProperty
      EndProperty
   End
   Begin MSComctlLib.ImageList ImageList1 
      Left            =   4260
      Top             =   1860
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
            Picture         =   "frmMain.frx":7BF4
            Key             =   "LightOff"
            Object.Tag             =   "LightOff"
         EndProperty
         BeginProperty ListImage2 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":8046
            Key             =   "LightOn"
            Object.Tag             =   "LightOn"
         EndProperty
      EndProperty
   End
   Begin MSComctlLib.ImageList imlToolbarIcons 
      Left            =   3540
      Top             =   1860
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483643
      ImageWidth      =   16
      ImageHeight     =   16
      MaskColor       =   12632256
      _Version        =   393216
      BeginProperty Images {2C247F25-8591-11D1-B16A-00C0F0283628} 
         NumListImages   =   20
         BeginProperty ListImage1 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":8498
            Key             =   "New"
         EndProperty
         BeginProperty ListImage2 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":85AA
            Key             =   "Open"
         EndProperty
         BeginProperty ListImage3 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":86BC
            Key             =   "Save"
         EndProperty
         BeginProperty ListImage4 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":87CE
            Key             =   "Print"
         EndProperty
         BeginProperty ListImage5 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":88E0
            Key             =   "Cut"
         EndProperty
         BeginProperty ListImage6 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":89F2
            Key             =   "Copy"
         EndProperty
         BeginProperty ListImage7 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":8B04
            Key             =   "Paste"
         EndProperty
         BeginProperty ListImage8 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":8C16
            Key             =   "Delete"
         EndProperty
         BeginProperty ListImage9 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":8D28
            Key             =   "Undo"
         EndProperty
         BeginProperty ListImage10 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":8E3A
            Key             =   "Redo"
         EndProperty
         BeginProperty ListImage11 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":8F4C
            Key             =   "Find"
         EndProperty
         BeginProperty ListImage12 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":905E
            Key             =   "Macro"
         EndProperty
         BeginProperty ListImage13 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":9170
            Key             =   "Properties"
         EndProperty
         BeginProperty ListImage14 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":9282
            Key             =   "View Details"
         EndProperty
         BeginProperty ListImage15 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":9394
            Key             =   "Help"
         EndProperty
         BeginProperty ListImage16 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":94A6
            Key             =   "Wrap"
            Object.Tag             =   "Wrap"
         EndProperty
         BeginProperty ListImage17 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":9A40
            Key             =   "FindNext"
         EndProperty
         BeginProperty ListImage18 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":9B9A
            Key             =   "FindPrev"
         EndProperty
         BeginProperty ListImage19 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":9C32
            Key             =   "Replace"
         EndProperty
         BeginProperty ListImage20 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMain.frx":9FB4
            Key             =   "GoTo"
         EndProperty
      EndProperty
   End
   Begin MSComctlLib.Toolbar tbToolBar 
      Align           =   1  'Align Top
      Height          =   360
      Left            =   0
      TabIndex        =   0
      Top             =   0
      Width           =   9510
      _ExtentX        =   16775
      _ExtentY        =   635
      ButtonWidth     =   609
      ButtonHeight    =   582
      Wrappable       =   0   'False
      Appearance      =   1
      Style           =   1
      ImageList       =   "imlToolbarIcons"
      _Version        =   393216
      BeginProperty Buttons {66833FE8-8583-11D1-B16A-00C0F0283628} 
         NumButtons      =   22
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
            Key             =   "GoTo"
            Object.ToolTipText     =   "Go To Line"
            Object.Tag             =   "GoTo"
            ImageKey        =   "GoTo"
         EndProperty
         BeginProperty Button20 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Style           =   3
         EndProperty
         BeginProperty Button21 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "Wrap"
            Object.ToolTipText     =   "Word wrap"
            ImageKey        =   "Wrap"
            Style           =   1
         EndProperty
         BeginProperty Button22 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Style           =   3
         EndProperty
      EndProperty
   End
   Begin MSComctlLib.Toolbar tbToolBar1 
      Align           =   1  'Align Top
      Height          =   360
      Left            =   0
      TabIndex        =   1
      Top             =   360
      Width           =   9510
      _ExtentX        =   16775
      _ExtentY        =   635
      ButtonWidth     =   609
      ButtonHeight    =   582
      Wrappable       =   0   'False
      Appearance      =   1
      Style           =   1
      ImageList       =   "ImageList2"
      _Version        =   393216
      BeginProperty Buttons {66833FE8-8583-11D1-B16A-00C0F0283628} 
         NumButtons      =   26
         BeginProperty Button1 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "Indent"
            Object.ToolTipText     =   "Indent"
            ImageKey        =   "Indent"
         EndProperty
         BeginProperty Button2 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "Outdent"
            Object.ToolTipText     =   "Outdent"
            ImageKey        =   "Outdent"
         EndProperty
         BeginProperty Button3 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "ToUpper"
            Object.ToolTipText     =   "To Upper"
            ImageKey        =   "ToUpper"
         EndProperty
         BeginProperty Button4 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "ToLower"
            Object.ToolTipText     =   "To Lower"
            ImageKey        =   "ToLower"
         EndProperty
         BeginProperty Button5 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Style           =   3
         EndProperty
         BeginProperty Button6 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "ExpandAll"
            Object.ToolTipText     =   "Expand All"
            ImageKey        =   "ExpandAll"
         EndProperty
         BeginProperty Button7 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "CollapseAll"
            Object.ToolTipText     =   "Collapse All"
            ImageKey        =   "CollapseAll"
         EndProperty
         BeginProperty Button8 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Style           =   3
         EndProperty
         BeginProperty Button9 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "ZoomIn"
            Object.ToolTipText     =   "Zoom In"
            ImageKey        =   "ZoomIn"
         EndProperty
         BeginProperty Button10 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "ZoomOut"
            Object.ToolTipText     =   "Zoom Out"
            ImageKey        =   "ZoomOut"
         EndProperty
         BeginProperty Button11 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "NoZoom"
            Object.ToolTipText     =   "No Zoom"
            ImageKey        =   "NoZoom"
         EndProperty
         BeginProperty Button12 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Style           =   3
         EndProperty
         BeginProperty Button13 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "ToggleBookmark"
            Object.ToolTipText     =   "Toggle Bookmark"
            ImageKey        =   "ToggleBookmark"
         EndProperty
         BeginProperty Button14 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "NextBookmark"
            Object.ToolTipText     =   "Next Bookmark"
            ImageKey        =   "NextBookmark"
         EndProperty
         BeginProperty Button15 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "PreviousBookmark"
            Object.ToolTipText     =   "Previous Bookmark"
            ImageKey        =   "PreviousBookmark"
         EndProperty
         BeginProperty Button16 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "ClearAllBookmarks"
            Object.ToolTipText     =   "Clear All Bookmarks"
            ImageKey        =   "ClearAllBookmarks"
         EndProperty
         BeginProperty Button17 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Style           =   3
         EndProperty
         BeginProperty Button18 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "MacroRecord"
            Object.ToolTipText     =   "Macro Record"
            ImageKey        =   "MacroRecord"
         EndProperty
         BeginProperty Button19 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "MacroStop"
            Object.ToolTipText     =   "Macro Stop"
            ImageKey        =   "MacroStop"
         EndProperty
         BeginProperty Button20 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "Macro1"
            Object.ToolTipText     =   "Play Macro 1"
            ImageKey        =   "Macro1"
         EndProperty
         BeginProperty Button21 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "Macro2"
            Object.ToolTipText     =   "Play Macro 2"
            ImageKey        =   "Macro2"
         EndProperty
         BeginProperty Button22 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "Macro3"
            Object.ToolTipText     =   "Play Macro 3"
            ImageKey        =   "Macro3"
         EndProperty
         BeginProperty Button23 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "Macro4"
            Object.ToolTipText     =   "Play Macro 4"
            ImageKey        =   "Macro4"
         EndProperty
         BeginProperty Button24 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "Macro5"
            Object.ToolTipText     =   "Play Macro 5"
            ImageKey        =   "Macro5"
         EndProperty
         BeginProperty Button25 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Style           =   3
         EndProperty
         BeginProperty Button26 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "Test"
            ImageIndex      =   3
         EndProperty
      EndProperty
      Begin VB.PictureBox Picture1 
         Height          =   0
         Left            =   60
         ScaleHeight     =   0
         ScaleWidth      =   9435
         TabIndex        =   11
         Top             =   360
         Width           =   9435
      End
   End
   Begin MSComctlLib.StatusBar sbStatusBar 
      Align           =   2  'Align Bottom
      Height          =   270
      Left            =   0
      TabIndex        =   2
      Top             =   4665
      Width           =   9510
      _ExtentX        =   16775
      _ExtentY        =   476
      _Version        =   393216
      BeginProperty Panels {8E3867A5-8586-11D1-B16A-00C0F0283628} 
         NumPanels       =   9
         BeginProperty Panel1 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
            AutoSize        =   1
            Key             =   "Status"
         EndProperty
         BeginProperty Panel2 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
            Text            =   "Line:"
            TextSave        =   "Line:"
            Key             =   "Line"
            Object.ToolTipText     =   "Line"
         EndProperty
         BeginProperty Panel3 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
            Text            =   "Column:"
            TextSave        =   "Column:"
            Key             =   "Column"
            Object.Tag             =   "Column"
            Object.ToolTipText     =   "Column"
         EndProperty
         BeginProperty Panel4 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
            Text            =   "Lines:"
            TextSave        =   "Lines:"
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
            Object.Width           =   2646
            MinWidth        =   2646
            Text            =   "Size:"
            TextSave        =   "Size:"
            Key             =   "DocSize"
            Object.ToolTipText     =   "Document Length"
         EndProperty
         BeginProperty Panel7 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
            Style           =   1
            AutoSize        =   2
            Enabled         =   0   'False
            Object.Width           =   900
            MinWidth        =   176
            TextSave        =   "CAPS"
         EndProperty
         BeginProperty Panel8 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
            Style           =   3
            AutoSize        =   2
            Object.Width           =   635
            MinWidth        =   176
            TextSave        =   "INS"
         EndProperty
         BeginProperty Panel9 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
            Style           =   2
            AutoSize        =   2
            Enabled         =   0   'False
            Object.Width           =   820
            MinWidth        =   176
            TextSave        =   "NUM"
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
      Begin VB.Menu mnuFileCloseAll 
         Caption         =   "Clos&e All"
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
      Begin VB.Menu mnuFilePageSetup 
         Caption         =   "Page Set&up..."
      End
      Begin VB.Menu mnuFilePrintPreview 
         Caption         =   "Print Pre&view"
      End
      Begin VB.Menu mnuFilePrint 
         Caption         =   "&Print..."
         Shortcut        =   ^P
      End
      Begin VB.Menu mnuFileBar3 
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
         Shortcut        =   ^Z
      End
      Begin VB.Menu mnuEditRedo 
         Caption         =   "&Redo"
         Shortcut        =   ^Y
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
      Begin VB.Menu mnuEditDelete 
         Caption         =   "&Delete"
      End
      Begin VB.Menu mnuEdit3 
         Caption         =   "-"
      End
      Begin VB.Menu mnuEditSelectAll 
         Caption         =   "Select &All"
         Shortcut        =   ^A
      End
      Begin VB.Menu mnuEdit4 
         Caption         =   "-"
      End
      Begin VB.Menu mnuEditIndent 
         Caption         =   "&Indent"
      End
      Begin VB.Menu mnuEditOutdent 
         Caption         =   "&Outdent"
      End
      Begin VB.Menu mnuEditAutoIndent 
         Caption         =   "A&uto Indentation"
      End
      Begin VB.Menu mnuEdit5 
         Caption         =   "-"
      End
      Begin VB.Menu mnuEditLineBreak 
         Caption         =   "Line &Break"
         Begin VB.Menu mnuEditLineBreakDOS 
            Caption         =   "&Dos / Windows"
         End
         Begin VB.Menu mnuEditLineBreakUnix 
            Caption         =   "&Unix"
         End
         Begin VB.Menu mnuEditLineBreakMac 
            Caption         =   "&Macintosh"
         End
      End
   End
   Begin VB.Menu mnuSearch 
      Caption         =   "&Search"
      Begin VB.Menu mnuSearchFind 
         Caption         =   "&Find"
         Shortcut        =   ^F
      End
      Begin VB.Menu mnuSearchReplace 
         Caption         =   "&Replace"
         Shortcut        =   ^H
      End
      Begin VB.Menu mnuSearch0 
         Caption         =   "-"
      End
      Begin VB.Menu mnuSearchFindNext 
         Caption         =   "Find &Next"
         Shortcut        =   {F3}
      End
      Begin VB.Menu mnuSearchFindPrev 
         Caption         =   "Find &Previous"
         Shortcut        =   ^{F3}
      End
      Begin VB.Menu mnuSearch1 
         Caption         =   "-"
      End
      Begin VB.Menu mnuSearchGoto 
         Caption         =   "&Go to Line"
         Shortcut        =   ^G
      End
      Begin VB.Menu mnuSearch2 
         Caption         =   "-"
      End
      Begin VB.Menu mnuSearchToggleBookmark 
         Caption         =   "&Toggle Bookmark"
      End
      Begin VB.Menu mnuSearchClearAllBookmarks 
         Caption         =   "&Clear all Bookmarks"
      End
      Begin VB.Menu mnuSearchGotoNextBookmark 
         Caption         =   "Goto &Next Bookmark"
      End
      Begin VB.Menu mnuSearchGotoPrevBookmark 
         Caption         =   "G&oto Previous Bookmark"
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
      Begin VB.Menu mnuViewZoomIn 
         Caption         =   "Zoom &In"
         Shortcut        =   ^{F7}
      End
      Begin VB.Menu mnuViewZoomOut 
         Caption         =   "Zoom &Out"
         Shortcut        =   ^{F8}
      End
      Begin VB.Menu mnuViewNoZoom 
         Caption         =   "Zoom 100%"
         Shortcut        =   ^{F9}
      End
      Begin VB.Menu mnuView3 
         Caption         =   "-"
      End
      Begin VB.Menu mnuViewSpaces 
         Caption         =   "T&abs and Spaces"
      End
      Begin VB.Menu mnuViewLineBreaks 
         Caption         =   "&Line Breaks"
      End
      Begin VB.Menu mnuViewSyntaxHighlighting 
         Caption         =   "&Syntax Highlighting"
      End
      Begin VB.Menu mnuViewMatchingBrace 
         Caption         =   "&Matching Brace"
      End
      Begin VB.Menu mnuView4 
         Caption         =   "-"
      End
      Begin VB.Menu mnuViewFolding 
         Caption         =   "&Fold Margin"
      End
      Begin VB.Menu mnuViewSymbolMargin 
         Caption         =   "&Symbol Margin"
      End
      Begin VB.Menu mnuViewLineNumbers 
         Caption         =   "Line &Numbers"
      End
      Begin VB.Menu mnuView5 
         Caption         =   "-"
      End
      Begin VB.Menu mnuViewIndentationGuids 
         Caption         =   "&Indentation Guids"
      End
      Begin VB.Menu mnuViewCaretLineVisible 
         Caption         =   "C&aret Line"
      End
      Begin VB.Menu mnuView6 
         Caption         =   "-"
      End
      Begin VB.Menu mnuViewViewInBrowser 
         Caption         =   "View in &Browser"
      End
   End
   Begin VB.Menu mnuTools 
      Caption         =   "&Tools"
      Begin VB.Menu mnuToolsWebBrowser 
         Caption         =   "&Web Browser"
      End
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

Private Declare Function SendMessage Lib "user32" Alias "SendMessageA" (ByVal hWnd As Long, ByVal wMsg As Long, ByVal wParam As Long, ByVal lParam As Any) As Long
Const EM_UNDO = &HC7
Private Declare Function OSWinHelp% Lib "user32" Alias "WinHelpA" (ByVal hWnd&, ByVal HelpFile$, ByVal wCommand%, dwData As Any)

'Private m_cSplitLeft As New cMDISplit
'Private m_cSplitRight As New cMDISplit
'Private m_cSplitTop As New cMDISplit
Private m_cSplitBottom As New cMDISplit

'Public formOutput As frmOutput

Private Sub MDIForm_Load()
    
    Me.left = GetSetting(App.Title, "Settings", "MainLeft", 1000)
    Me.top = GetSetting(App.Title, "Settings", "MainTop", 1000)
    Me.width = GetSetting(App.Title, "Settings", "MainWidth", 6500)
    Me.height = GetSetting(App.Title, "Settings", "MainHeight", 6500)
        
    'Default page setup margins in 1/00 millimeters or in 1/000 inches
    rectMargins.bottom = GetSetting(App.Title, "Settings", "MarginsBottom", 1000)
    rectMargins.top = GetSetting(App.Title, "Settings", "MarginsTop", 1000)
    rectMargins.right = GetSetting(App.Title, "Settings", "MarginsRight", 1000)
    rectMargins.left = GetSetting(App.Title, "Settings", "MarginsLeft", 1000)
    '-------------------------------------------------------
    'm_cSplitLeft.FullDrag = False
    'm_cSplitRight.FullDrag = False
    'm_cSplitTop.FullDrag = False
    
    m_cSplitBottom.FullDrag = False
    m_cSplitBottom.SplitSize = 5
    m_cSplitBottom.Attach picOutput
         
    'SetOutputForm
 
    'm_cSplitLeft.MaxSize = 128
    
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
    Dim x As Long
   
    For x = 1 To TabStrip1.Tabs.count
        TabStrip1.Tabs.Remove x
    Next x
    '-------------------------------------------------------
    'Me.BackColor = vbWhite
    '-------------------------------------------------------
    LoadNewDoc
    'ActiveForm.Editawy1.SetFocus
    '-------------------------------------------------------
    'SetParent  frmOutput.hwnd, picOutput.hwnd

End Sub

Private Sub SetOutputForm()
    'Set formOutput = New frmOutput
    'formOutput.Move picOutput.ScaleLeft, picOutput.ScaleTop + 50, _
        picOutput.ScaleWidth, picOutput.ScaleHeight
    'SetParent formOutput.hwnd, picOutput.hwnd
    'formOutput.Show
End Sub

Private Sub picOutput_Resize()

    On Error Resume Next
    'picOutput.Visible = False
    
    picOutput.top = sbStatusBar.top - picOutput.height - 5
    
    'formOutput.Move picOutput.ScaleLeft, picOutput.ScaleTop + 50, _
        picOutput.ScaleWidth, picOutput.ScaleHeight
    'picOutput.Visible = True
    
    frameOutput.Move picOutput.ScaleLeft, picOutput.ScaleTop + 50, _
        picOutput.ScaleWidth - 30, picOutput.ScaleHeight - 400
    
    frameSearch.Move picOutput.ScaleLeft, picOutput.ScaleTop + 50, _
        picOutput.ScaleWidth - 30, picOutput.ScaleHeight - 400
    
    FrameClipboard.Move picOutput.ScaleLeft, picOutput.ScaleTop + 50, _
        picOutput.ScaleWidth - 30, picOutput.ScaleHeight - 400
    
    SSTab1.Move picOutput.ScaleLeft, picOutput.ScaleTop + 50, _
        picOutput.ScaleWidth, picOutput.ScaleHeight
        
    txtOutput.Move picOutput.ScaleLeft, picOutput.ScaleTop + 50, _
        picOutput.ScaleWidth - 30, picOutput.ScaleHeight - 400

    lvSearch.Move picOutput.ScaleLeft, picOutput.ScaleTop + 50, _
        picOutput.ScaleWidth - 30, picOutput.ScaleHeight - 400
    
    txtClipboard.Move picOutput.ScaleLeft, picOutput.ScaleTop + 50, _
        picOutput.ScaleWidth - 30, picOutput.ScaleHeight - 400
End Sub

Private Sub MDIForm_Resize()
    On Error Resume Next
    
    'SSTab1.Move picOutput.ScaleLeft, picOutput.ScaleTop + 50, _
        picOutput.ScaleWidth, picOutput.ScaleHeight
    picDocs.height = 340
    
    TabStrip1.Move picDocs.ScaleLeft, picDocs.ScaleTop, _
                picDocs.ScaleWidth, picDocs.ScaleHeight
    
End Sub

Private Sub LoadNewDoc()

    Static lDocumentCount As Long
    Dim frmD As frmDocument
    
    Dim sFile, strDir, sFileName As String
    Dim sKey As String
    
    'LockWindowUpdate Me.hwnd
    
    lDocumentCount = lDocumentCount + 1
    Set frmD = New frmDocument
    Load frmD
    
    sFile = "Untitled" & CStr(lDocumentCount) & "." & sNewFileExt
    strDir = CurDir
    strDir = strDir & IIf(right(strDir, 1) <> "\", "\", "")
    sFileName = strDir & sFile
    
    frmD.Caption = sFileName
    frmD.Editawy1.FileName = sFileName
    
    sKey = "F" & CStr(lDocumentCount)
    frmD.Tag = sKey
    frmD.strFilename = sFileName
    
    TabStrip1.Tabs.Add , sKey, sFile, "LightOff"
    TabStrip1.Tabs(sKey).ToolTipText = sFileName
    
    frmD.Show
    
    Set frmD = Nothing
    
    'LockWindowUpdate 0
  
End Sub

Private Sub MDIForm_Unload(Cancel As Integer)
    If Me.WindowState <> vbMinimized Then
        SaveSetting App.Title, "Settings", "MainLeft", Me.left
        SaveSetting App.Title, "Settings", "MainTop", Me.top
        SaveSetting App.Title, "Settings", "MainWidth", Me.width
        SaveSetting App.Title, "Settings", "MainHeight", Me.height
    End If
    
    Static Unloading As Boolean
    Dim i As Integer
    
    If Unloading Then Exit Sub
    
    Unloading = True
    For i = Forms.count - 1 To 0 Step -1
        Unload Forms(i)
    Next i
    
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
        nRet = OSWinHelp(Me.hWnd, App.HelpFile, 261, 0)
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
        nRet = OSWinHelp(Me.hWnd, App.HelpFile, 3, 0)
        If Err Then
            MsgBox Err.Description
        End If
    End If

End Sub

Private Sub mnuSearchFind_Click()
    frmFind.Show , Me
    frmFind.SetFocus
End Sub

Private Sub mnuSearchReplace_Click()
    frmReplace.Show , Me
End Sub

Private Sub mnuSearchFindNext_Click()
    On Error Resume Next
    ActiveForm.Editawy1.FindNext
End Sub

Private Sub mnuSearchFindPrev_Click()
    On Error Resume Next
    ActiveForm.Editawy1.FindPrev
End Sub

Private Sub mnuSearchGoto_Click()
    On Error Resume Next
    frmGoto.Show , Me
End Sub

Private Sub mnuSearchToggleBookmark_Click()
    On Error Resume Next
    Dim x As Long
    x = ActiveForm.Editawy1.MarkerGet(ActiveForm.Editawy1.Line)
    If x > 0 Then
        ActiveForm.Editawy1.MarkerDelete ActiveForm.Editawy1.Line, lBookmarkMarker
    Else
        ActiveForm.Editawy1.MarkerAdd ActiveForm.Editawy1.Line, lBookmarkMarker
    End If
End Sub

Private Sub mnuSearchClearAllBookmarks_Click()
    ActiveForm.Editawy1.MarkerDeleteAll lBookmarkMarker
End Sub

Private Sub mnuSearchGotoNextBookmark_Click()
    On Error Resume Next
    Dim x As Long
    x = ActiveForm.Editawy1.MarkerNext(ActiveForm.Editawy1.Line + 1, lBookmarkMarkerMask)
    If x <> -1 Then
        ActiveForm.Editawy1.GotoLineEnsureVisible x
    End If
End Sub

Private Sub mnuSearchGotoPrevBookmark_Click()
    On Error Resume Next
    Dim x As Long
    x = ActiveForm.Editawy1.MarkerPrevious(ActiveForm.Editawy1.Line - 1, lBookmarkMarkerMask)
    If x <> -1 Then
        ActiveForm.Editawy1.GotoLineEnsureVisible x
    End If
End Sub

Private Sub mnuViewStatusBar_Click()
    mnuViewStatusBar.Checked = Not mnuViewStatusBar.Checked
    sbStatusBar.Visible = mnuViewStatusBar.Checked
End Sub

Private Sub mnuViewToolbar_Click()
    mnuViewToolbar.Checked = Not mnuViewToolbar.Checked
    tbToolBar.Visible = mnuViewToolbar.Checked
End Sub

Private Sub mnuViewCaretLineVisible_Click()
    On Error Resume Next
    ActiveForm.Editawy1.CaretLineVisible = Not ActiveForm.Editawy1.CaretLineVisible
    mnuViewCaretLineVisible.Checked = ActiveForm.Editawy1.CaretLineVisible
End Sub

Private Sub mnuViewLineBreaks_Click()
    On Error Resume Next
    ActiveForm.Editawy1.EOLVisible = Not ActiveForm.Editawy1.EOLVisible
    mnuViewLineBreaks.Checked = ActiveForm.Editawy1.EOLVisible
End Sub

Private Sub mnuViewFolding_Click()
    On Error Resume Next
    ActiveForm.Editawy1.Folding = Not ActiveForm.Editawy1.Folding
    mnuViewFolding.Checked = ActiveForm.Editawy1.Folding
End Sub


Private Sub mnuViewLineNumbers_Click()
    On Error Resume Next
    ActiveForm.Editawy1.LineNumbers = Not ActiveForm.Editawy1.LineNumbers
    mnuViewLineNumbers.Checked = ActiveForm.Editawy1.LineNumbers
End Sub

Private Sub mnuViewMatchingBrace_Click()
    On Error Resume Next
    ActiveForm.Editawy1.MatchBraces = Not ActiveForm.Editawy1.MatchBraces
    mnuViewMatchingBrace.Checked = ActiveForm.Editawy1.MatchBraces
End Sub

Private Sub mnuViewSpaces_Click()
    On Error Resume Next
    ActiveForm.Editawy1.WhiteSpaceVisible = Not ActiveForm.Editawy1.WhiteSpaceVisible
    mnuViewSpaces.Checked = ActiveForm.Editawy1.WhiteSpaceVisible
End Sub

Private Sub mnuViewSyntaxHighlighting_Click()
'
End Sub

Private Sub mnuViewViewInBrowser_Click()
'
End Sub

Private Sub mnuViewZoomIn_Click()
    On Error Resume Next
    ActiveForm.Editawy1.ZoomIn
    If ActiveForm.Editawy1.GetZoom = 0 Then
        tbToolBar1.Buttons("NoZoom").Enabled = False
    Else
        tbToolBar1.Buttons("NoZoom").Enabled = True
    End If
End Sub

Private Sub mnuViewZoomOut_Click()
    On Error Resume Next
    ActiveForm.Editawy1.ZoomOut
    If ActiveForm.Editawy1.GetZoom = 0 Then
        tbToolBar1.Buttons("NoZoom").Enabled = False
    Else
        tbToolBar1.Buttons("NoZoom").Enabled = True
    End If
End Sub

Private Sub mnuViewNoZoom_Click()
    On Error Resume Next
    ActiveForm.Editawy1.SetZoom 0
    If ActiveForm.Editawy1.GetZoom = 0 Then
        tbToolBar1.Buttons("NoZoom").Enabled = False
    Else
        tbToolBar1.Buttons("NoZoom").Enabled = True
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

Private Sub mnuToolsWebBrowser_Click()
    Dim frmB As New frmBrowser
    frmB.StartingAddress = "http://www.mewsoft.com"
    frmB.Show
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
    ActiveForm.Editawy1.Undo
End Sub

Private Sub mnuEditRedo_Click()
    ActiveForm.Editawy1.Redo
End Sub

Private Sub mnuEditDelete_Click()
    ActiveForm.Editawy1.Delete
End Sub

Private Sub mnuEditSelectAll_Click()
    ActiveForm.Editawy1.SelectAll
End Sub

Private Sub mnuEditAutoIndent_Click()
    ActiveForm.Editawy1.AutoIndent = Not ActiveForm.Editawy1.AutoIndent
    mnuEditAutoIndent.Checked = ActiveForm.Editawy1.AutoIndent
End Sub

Private Sub mnuEditIndent_Click()
    On Error Resume Next
    ActiveForm.Editawy1.KeyTab
End Sub

Private Sub mnuEditOutdent_Click()
    On Error Resume Next
    ActiveForm.Editawy1.KeyBackTab
End Sub

Private Sub mnuEditLineBreakDOS_Click()
    'Macintosh (\r), Unix (\n) and CP/M / DOS / Windows (\r\n).
'    EolCRLF = 0                     ' CR + LF
'    EolCR = 1                       ' CR
'    EolLF = 2                       ' LF
    ActiveForm.Editawy1.EndOfLine = EolCRLF
    ActiveForm.Editawy1.ConvertEOLs EolCRLF
    
    mnuEditLineBreakDOS.Checked = True
    mnuEditLineBreakUnix.Checked = False
    mnuEditLineBreakMac.Checked = False
End Sub

Private Sub mnuEditLineBreakMac_Click()
    'Macintosh (\r), Unix (\n) and CP/M / DOS / Windows (\r\n).
    ActiveForm.Editawy1.EndOfLine = EolLF
    ActiveForm.Editawy1.ConvertEOLs EolLF
    
    mnuEditLineBreakDOS.Checked = False
    mnuEditLineBreakMac.Checked = True
    mnuEditLineBreakMac.Checked = False
End Sub

Private Sub mnuEditLineBreakUnix_Click()
    'Macintosh (\r), Unix (\n) and CP/M / DOS / Windows (\r\n).
    ActiveForm.Editawy1.EndOfLine = EolCR
    ActiveForm.Editawy1.ConvertEOLs EolCR
    
    mnuEditLineBreakDOS.Checked = False
    mnuEditLineBreakMac.Checked = False
    mnuEditLineBreakUnix.Checked = True
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
    PrintDialog
End Sub

Private Sub mnuFilePrintPreview_Click()
    If Not ActiveForm Is Nothing Then
        Set frmActiveDocument = ActiveForm
        frmPreview.Show vbModal, Me
    End If
End Sub

Private Sub mnuFilePageSetup_Click()
    On Error Resume Next
    PageSetupDialog
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

Private Sub mnuFileNew_Click()
    LoadNewDoc
End Sub

Private Sub mnuFileOpen_Click()
    
    Dim sFileName As String, sFile As String, sPath As String
    Dim strText As String, FileNumber As Long
    Dim sKey As String

    On Error GoTo ErrHandler

    With dlgCommonDialog
        .DialogTitle = "Open"
        .CancelError = False
        'ToDo: set the flags and attributes of the common dialog control
        .Flags = cdlOFNExplorer Or cdlOFNFileMustExist Or cdlOFNHelpButton Or cdlOFNPathMustExist
        .Filter = "All Files (*.*)|*.*"
        .ShowOpen
        If Len(.FileName) = 0 Then
            Exit Sub
        End If
        sFileName = .FileName
    End With
    
    ''We don't want to have an error if the file doesn't exist.
    If Dir(sFileName) = "" Then Exit Sub
    
    LoadNewDoc
    
    'ActiveForm.Editawy1.LoadFile sFile
    
    ActiveForm.Editawy1.SplitFilePath sFileName, sFile, sPath
    ActiveForm.Caption = sFileName
    TabStrip1.Tabs(ActiveForm.Tag).Caption = sFile
    TabStrip1.Tabs(ActiveForm.Tag).ToolTipText = sFileName
    '----------------------------------------------------------------
    FileNumber = FreeFile   ' Get unused file number
    Open sFileName For Input As #FileNumber
    strText = Input$(LOF(FileNumber), #FileNumber)
    Close #FileNumber
    
    ActiveForm.Editawy1.ClearAll
    ActiveForm.Editawy1.Text = strText
    ActiveForm.Editawy1.EmptyUndoBuffer
    ActiveForm.Editawy1.SetSavePoint
    
    ActiveForm.strFilename = sFileName
    ActiveForm.Editawy1.FileName = sFileName
    
    Exit Sub
    
ErrHandler:
    MsgBox "Error opening file: " & Err.Description, vbOKOnly Or vbCritical, "Error"
End Sub

Private Sub mnuFileSave_Click()
    
    Dim sFileName As String, sFile As String, sPath As String
    Dim strText As String, FileNumber As Long
    Dim sKey As String
    
    On Error GoTo ErrHandler
        
    If ActiveForm Is Nothing Then Exit Sub
    sKey = ActiveForm.Tag
    
    strText = ActiveForm.Editawy1.Text
    
    If Not ActiveForm.Editawy1.Modified Then
            'Exit Sub
    End If
    
    sFileName = ActiveForm.strFilename
    
    ActiveForm.Editawy1.SplitFilePath sFileName, sFile, sPath
    
    If left(sFile, 8) = "Untitled" Then
        With dlgCommonDialog
            .DialogTitle = "Save"
            .CancelError = False
            .Flags = cdlOFNCreatePrompt Or cdlOFNExplorer Or cdlOFNNoReadOnlyReturn Or cdlOFNOverwritePrompt
            .FileName = ActiveForm.Caption
            .Filter = "All Files (*.*)|*.*"
            '.InitDir = sPath
            
            .ShowSave
            
            If Len(.FileName) = 0 Then
                ActiveForm.Editawy1.SetFocus
                Exit Sub
            End If
            
            sFileName = .FileName
        End With
    Else
        'File not modified
        If Not ActiveForm.Editawy1.Modified Then
            Exit Sub
        End If
        sFileName = ActiveForm.strFilename
    End If
    
    ActiveForm.Editawy1.SplitFilePath sFileName, sFile, sPath
    'Debug.Print "sFile: "; sFile, sPath
    
    FileNumber = FreeFile   ' Get unused file number
    Open sFileName For Output As #FileNumber
    Print #FileNumber, strText;
    Close #FileNumber
    
    'If Err = 0 Then
    'End If
    
    'tbDocs.Buttons(ActiveForm.Tag).Caption = sFile
    'tbDocs.Buttons(ActiveForm.Tag).Image = "LightOff"
    ActiveForm.Editawy1.FileName = sFileName
    ActiveForm.Caption = sFileName
    TabStrip1.Tabs(sKey).Caption = sFile
    TabStrip1.Tabs(sKey).Image = "LightOff"
    
    ActiveForm.Editawy1.SetSavePoint
    ActiveForm.Editawy1.SetFocus
    
    Exit Sub

ErrHandler:
    MsgBox "Error saving file: " & Err.Description, vbOKOnly Or vbCritical, "Error"
End Sub

Private Sub mnuFileClose_Click()
    If Not ActiveForm Is Nothing Then
        Unload ActiveForm
    End If
End Sub

Private Sub TabStrip1_Click()
    
    On Error Resume Next
    
    Dim frm As Form
    Dim x As Long
   
    For x = 1 To fMainForm.TabStrip1.Tabs.count
        fMainForm.TabStrip1.Tabs(Me.Tag).Selected = False
    Next x
    
    For Each frm In Forms
        If frm.Tag = TabStrip1.SelectedItem.Key Then
            frm.SetFocus
            frm.Editawy1.SetFocus
        End If
    Next
    
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
            'mnuFilePrint_Click
            PrintDialog
            
        Case "Cut"
            mnuEditCut_Click
            
        Case "Copy"
            mnuEditCopy_Click
            
        Case "Paste"
            mnuEditPaste_Click
            
        Case "Delete"
            mnuEditDelete_Click
            
        Case "Undo"
            mnuEditUndo_Click
            
        Case "Redo"
            mnuEditRedo_Click
            
        Case "Find"
            mnuSearchFind_Click
        
        Case "FindNext":
            mnuSearchFindNext_Click
            
        Case "FindPrev":
            mnuSearchFindPrev_Click
            
        Case "Replace":
            mnuSearchReplace_Click
        
        Case "GoTo":
            mnuSearchGoto_Click
            
        'Wrap long lines at word boundaries
        Case "Wrap":
            If tbToolBar.Buttons("Wrap").Value = tbrPressed Then
                ActiveForm.Editawy1.WrapMode = 1
            Else
                ActiveForm.Editawy1.WrapMode = 0
            End If
            
        Case "Properties":
            
        Case "View Details":
            
        Case "Help":
        
        Case Else:
            'ActiveForm.Editawy1.SetFocus
            
    End Select
    
End Sub

Private Sub tbToolBar1_ButtonClick(ByVal Button As MSComctlLib.Button)
    
    'On Error GoTo ErrHandler
    
    Dim x As Long
    
    Select Case Button.Key
    
        'Convert selected text to upper case characters
        Case "Indent":
            mnuEditIndent_Click
            
        Case "Outdent":
            mnuEditOutdent_Click
        
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
            mnuViewZoomIn_Click
            
        'Zoom out 1 step
        Case "ZoomOut":
            mnuViewZoomOut_Click
            
        Case "NoZoom":
            mnuViewNoZoom_Click
            
        'Display or hide bookmark at the current caret line
        Case "ToggleBookmark":
            mnuSearchToggleBookmark_Click
        
        'Move caret and display to next bookmark
        Case "NextBookmark":
            mnuSearchGotoNextBookmark_Click
        
        'Move caret and display to previous bookmark
        Case "PreviousBookmark":
            mnuSearchGotoPrevBookmark_Click
        
        'Delete al markers
        Case "ClearAllBookmarks":
            mnuSearchClearAllBookmarks_Click
        
        Case "MacroRecord":
            bMacroRecording = True
            tbToolBar1.Buttons("MacroRecord").Enabled = False
            tbToolBar1.Buttons("MacroStop").Enabled = True
            lCurentMacro = lCurentMacro + 1
            If lCurentMacro > 5 Then lCurentMacro = 1
            ActiveForm.Editawy1.RecordMacro lCurentMacro
            
            'sMacros(lCurentMacro) = ""
            'ActiveForm.Editawy1.StartRecord
            
        Case "MacroStop":
            bMacroRecording = False
            tbToolBar1.Buttons("MacroRecord").Enabled = True
            tbToolBar1.Buttons("MacroStop").Enabled = False
            ActiveForm.Editawy1.StopRecord
            
            If ActiveForm.Editawy1.GetMacro(lCurentMacro) = "" Then
                Debug.Print ActiveForm.Editawy1.GetMacro(lCurentMacro)
                lCurentMacro = lCurentMacro - 1
            Else
                tbToolBar1.Buttons("Macro" & CStr(lCurentMacro)).Enabled = True
            End If
        
        Case "Macro1":
            ActiveForm.Editawy1.PlayMacro 1
            
        Case "Macro2":
            ActiveForm.Editawy1.PlayMacro 2
            
        Case "Macro3":
            ActiveForm.Editawy1.PlayMacro 3
            
        Case "Macro4":
            ActiveForm.Editawy1.PlayMacro 4
            
        Case "Macro5":
            ActiveForm.Editawy1.PlayMacro 5
         
         Case "Test":
            'frmTest.Show
            ActiveSpliterEditor = ActiveSpliterEditor + 1
            If ActiveSpliterEditor > 1 Then ActiveSpliterEditor = 0
            'SetActiveEditor
                        
    End Select
    
    Exit Sub
    
ErrHandler:
    Debug.Print "Error: "; Err.Description
End Sub

Public Sub PageSetupDialog()

    Dim MinMargins As RECT
    
    'minimum margins in 1/00 millimeters or in 1/000 inches
    MinMargins.bottom = 10
    MinMargins.top = 10
    MinMargins.right = 10
    MinMargins.left = 10
    
    'The new margins set by the user returned in
    'rectMargins in 1/00 millimeters or in 1/000 inches
    ActiveForm.Editawy1.PageSetupDialog Me.hWnd, rectMargins, MinMargins
    
    'Debug.Print rectMargins.bottom, rectMargins.top, rectMargins.left, rectMargins.right
End Sub

Public Sub PrintDialog()
    
    On Error GoTo ErrHandler
    
    If ActiveForm Is Nothing Then Exit Sub
    
    Dim startPos As Long, endPos  As Long
    Dim PagesInfo() As String, NextCharPos As Long
    Dim x As Long, Infos() As String
    Dim TotalPages As Long
    
    ReDim PagesInfo(0) As String
    
    'Measure the print pages
    TotalPages = ActiveForm.Editawy1.PrintPagesMeasure( _
                        0, ActiveForm.Editawy1.GetTextLength, _
                        rectMargins.left, rectMargins.top, _
                        rectMargins.right, rectMargins.bottom, _
                        NextCharPos, _
                        PagesInfo())
    
    Debug.Print "TotalPages: "; TotalPages
    
    If TotalPages < 1 Then Exit Sub
    
    With dlgCommonDialog
        .CancelError = True
        '.Flags = cdlPDPrintSetup
        .Min = 1        'Low Page
        .Max = 32767    'Max Number of pages
        .FromPage = 1   'Low Page
        .ToPage = TotalPages     'Max Number of pages
        
        'cdlPDReturnDC: Returns a device context for the printer selection made in the dialog box. The device context is returned in the hDC property of the dialog box.

        'Enable the Selection button if user selected some text
        If ActiveForm.Editawy1.GetSelectionLength > 0 Then
            .Flags = cdlPDReturnDC Or cdlPDCollate Or cdlPDPageNums Or cdlPDAllPages
        Else
            .Flags = cdlPDReturnDC Or cdlPDCollate Or cdlPDPageNums Or cdlPDAllPages Or cdlPDNoSelection
        End If
        
        'Display the printer dialog
        .ShowPrinter
        '------------------------------------------------------------
        ' Locate the printer that the user selected in the Printers collection.
        Dim PrinterName As String
        Dim objPrinter As Printer
        PrinterName = UCase(.PrinterDefault)
        
        If Printer.DeviceName <> PrinterName Then
            For Each objPrinter In Printers
               If UCase(objPrinter.DeviceName) = PrinterName Then
                    Set Printer = objPrinter
               End If
            Next
        End If
        
'        vbPRPQDraft
'        vbPRPQHigh
'        vbPRPQLow
'        vbPRPQMedium
'        Printer.PrintQuality
        '------------------------------------------------------------
        'Let's print what the user selected
        '------------------------------------------------------------
        'Print only selected text
        If (.Flags And cdlPDSelection) = cdlPDSelection Then
            'Debug.Print "cdlPDSelection"
            'Margins are 1/1000 Inch in U.S. system
            'Margins are 1/1000 Cm in Metric system
            ActiveForm.Editawy1.PrintPages _
                    ActiveForm.Editawy1.GetSelectionStart, _
                    ActiveForm.Editawy1.GetSelectionEnd, _
                    rectMargins.left, rectMargins.top, rectMargins.right, rectMargins.bottom
        
        'Print selected page or page range
        ElseIf (.Flags And cdlPDPageNums) = cdlPDPageNums Then
            'Debug.Print "cdlPDPageNums"
            '.FromPage
            '.ToPage
            For x = 1 To UBound(PagesInfo)
                Infos = Split(PagesInfo(x), ":")
                If UBound(Infos) < 2 Then Exit For
                If Infos(0) = .FromPage Then
                    startPos = Infos(1)
                End If
                If Infos(0) = .ToPage Then
                    endPos = Infos(2) - 1
                    If endPos < 0 Then endPos = 0
                End If
            Next x
            
            ActiveForm.Editawy1.PrintPages startPos, endPos, _
                rectMargins.left, rectMargins.top, rectMargins.right, rectMargins.bottom
        
        'Print all pages
        ElseIf (.Flags And cdlPDAllPages) = cdlPDAllPages Then
            'Debug.Print "cdlPDAllPages"
            ActiveForm.Editawy1.PrintPages 0, _
                ActiveForm.Editawy1.GetTextLength, _
                rectMargins.left, rectMargins.top, rectMargins.right, rectMargins.bottom
        End If
        
        'Debug.Print "Done .Flags: "; Hex(.Flags)
    End With
   
    Exit Sub
    
ErrHandler:
    MsgBox "Printing Error: " & Err.Description, vbCritical Or vbOKOnly, "Error"
End Sub

Public Function MeasurePrintPages( _
            ByVal startPage As Long, _
            ByVal endPage As Long, _
            ByRef startPos As Long, _
            ByRef endPos As Long) As Long
    
    Dim PagesInfo() As String
    Dim x As Long, Infos() As String
    Dim Pages As Long, NextCharPos As Long
    
    ReDim PagesInfo(0) As String
    
    'Public Function PrintPreview(ByVal TargetDC As Long, _
                ByVal startPos As Long, ByVal endPos As Long, _
                ByVal LeftMarginWidth As Long, ByVal TopMarginHeight As Long, _
                ByVal RightMarginWidth As Long, ByVal BottomMarginHeight As Long, _
                ByRef PreviewNextCharPos As Long, _
                ByRef PagesInfo() As String, _
                Optional ByVal bMeasureOnly As Boolean = False) As Long
    
    Pages = ActiveForm.Editawy1.PrintPreview(Printer.hdc, _
        0, ActiveForm.Editawy1.GetTextLength, _
        rectMargins.left, rectMargins.top, rectMargins.right, rectMargins.bottom, _
        NextCharPos, _
        PagesInfo(), _
        True)

    For x = 1 To UBound(PagesInfo)
        Infos = Split(PagesInfo(x), ":")
        If UBound(Infos) < 2 Then Exit For
        If Infos(0) = startPage Then
            startPos = Infos(1)
        End If
        If Infos(0) = endPage Then
            endPos = Infos(2) - 1
            If endPos < 0 Then endPos = 0
        End If
    Next x

End Function
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
    'frmFind.Show , Me
    'frmFind.SetFocus
    'frmFind.FindNext
End Sub
Private Sub mnuReplace_Click()
    'frmReplace.Show , Me
    'frmReplace.SetFocus
End Sub

Private Sub mnuGoToLine_Click()
    'frmGoTo.Show vbModal, Me
End Sub

Private Sub mnuFindNext_Click()
    Debug.Print "mnuFindNext_Click"
    'Debug.Print ActiveForm.Editawy1.SearchNext(lLastSearchFlags, sLastSearchTerm)
End Sub

Private Sub mnuFindPrevious_Click()
    'Debug.Print "mnuFindPrevious_Click"
    'Debug.Print ActiveForm.Editawy1.SearchPrev(lLastSearchFlags, sLastSearchTerm)
End Sub

Private Sub Toolbar1_ButtonClick(ByVal Button As MSComctlLib.Button)
    Select Case Button.Key
    Case "Test":
        Debug.Print "Test key"
    End Select
End Sub


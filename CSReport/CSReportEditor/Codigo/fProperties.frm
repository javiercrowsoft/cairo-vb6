VERSION 5.00
Object = "{353A8433-36B8-422E-ABBD-36CEE8BE628E}#1.0#0"; "CSButton.ocx"
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Object = "{BDC217C8-ED16-11CD-956C-0000C04E4C0A}#1.1#0"; "tabctl32.ocx"
Object = "{F7BB685C-0860-4FD1-A9CF-22277199D7A5}#1.2#0"; "CSMaskEdit2.ocx"
Begin VB.Form fProperties 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Propiedades"
   ClientHeight    =   7620
   ClientLeft      =   45
   ClientTop       =   405
   ClientWidth     =   6210
   Icon            =   "fProperties.frx":0000
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   7620
   ScaleWidth      =   6210
   StartUpPosition =   3  'Windows Default
   Begin VB.PictureBox Picture1 
      BorderStyle     =   0  'None
      Height          =   675
      Left            =   -120
      ScaleHeight     =   675
      ScaleWidth      =   6615
      TabIndex        =   63
      Top             =   6930
      Width           =   6615
      Begin CSButton.cButton cmdCancelar 
         Cancel          =   -1  'True
         Height          =   315
         Left            =   4815
         TabIndex        =   36
         Top             =   300
         Width           =   1275
         _ExtentX        =   2249
         _ExtentY        =   556
         Caption         =   "&Cancelar"
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         FontName        =   "MS Sans Serif"
         FontSize        =   8.25
      End
      Begin CSButton.cButton cmdAceptar 
         Default         =   -1  'True
         Height          =   315
         Left            =   3420
         TabIndex        =   35
         Top             =   300
         Width           =   1275
         _ExtentX        =   2249
         _ExtentY        =   556
         Caption         =   "&Aceptar"
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         FontName        =   "MS Sans Serif"
         FontSize        =   8.25
      End
      Begin VB.Line Line6 
         BorderColor     =   &H80000014&
         X1              =   45
         X2              =   6330
         Y1              =   190
         Y2              =   190
      End
      Begin VB.Line Line5 
         BorderColor     =   &H80000010&
         X1              =   60
         X2              =   6345
         Y1              =   180
         Y2              =   180
      End
   End
   Begin TabDlg.SSTab TabMain 
      Height          =   6465
      Left            =   -45
      TabIndex        =   39
      Top             =   675
      Width           =   6285
      _ExtentX        =   11086
      _ExtentY        =   11404
      _Version        =   393216
      Style           =   1
      Tabs            =   6
      Tab             =   1
      TabsPerRow      =   6
      TabHeight       =   503
      TabCaption(0)   =   "Formato"
      TabPicture(0)   =   "fProperties.frx":058A
      Tab(0).ControlEnabled=   0   'False
      Tab(0).Control(0)=   "Label1"
      Tab(0).Control(1)=   "Label2"
      Tab(0).Control(2)=   "Label3"
      Tab(0).Control(3)=   "Label4"
      Tab(0).Control(4)=   "Label5"
      Tab(0).Control(5)=   "Label6"
      Tab(0).Control(6)=   "Label9"
      Tab(0).Control(7)=   "Line1"
      Tab(0).Control(8)=   "Line2"
      Tab(0).Control(9)=   "Line3"
      Tab(0).Control(10)=   "Label10"
      Tab(0).Control(11)=   "Label11"
      Tab(0).Control(12)=   "Label12"
      Tab(0).Control(13)=   "shForeColor"
      Tab(0).Control(14)=   "shBackColor"
      Tab(0).Control(15)=   "Label13"
      Tab(0).Control(16)=   "Label14"
      Tab(0).Control(17)=   "Label15"
      Tab(0).Control(18)=   "Label44"
      Tab(0).Control(19)=   "Label45"
      Tab(0).Control(20)=   "Line7"
      Tab(0).Control(21)=   "Line8"
      Tab(0).Control(22)=   "txExportColIdx"
      Tab(0).Control(23)=   "txTag"
      Tab(0).Control(24)=   "txSymbol"
      Tab(0).Control(25)=   "TxFormat"
      Tab(0).Control(26)=   "TxBackColor"
      Tab(0).Control(27)=   "TxForeColor"
      Tab(0).Control(28)=   "TxFontSize"
      Tab(0).Control(29)=   "TxName"
      Tab(0).Control(30)=   "txWidth"
      Tab(0).Control(31)=   "txHeight"
      Tab(0).Control(32)=   "txTop"
      Tab(0).Control(33)=   "txLeft"
      Tab(0).Control(34)=   "txText"
      Tab(0).Control(35)=   "txFont"
      Tab(0).Control(36)=   "chkFontBold"
      Tab(0).Control(37)=   "chkFontItalic"
      Tab(0).Control(38)=   "chkFontUnderline"
      Tab(0).Control(39)=   "chkTransparent"
      Tab(0).Control(40)=   "chkFontStrike"
      Tab(0).Control(41)=   "cbAlign"
      Tab(0).Control(42)=   "chkWordWrap"
      Tab(0).Control(43)=   "chkCanGrow"
      Tab(0).Control(44)=   "chkIsFreeCtrl"
      Tab(0).ControlCount=   45
      TabCaption(1)   =   "Formulas"
      TabPicture(1)   =   "fProperties.frx":05A6
      Tab(1).ControlEnabled=   -1  'True
      Tab(1).Control(0)=   "lbFormulaValue"
      Tab(1).Control(0).Enabled=   0   'False
      Tab(1).Control(1)=   "lbFormulaHide"
      Tab(1).Control(1).Enabled=   0   'False
      Tab(1).Control(2)=   "Line4"
      Tab(1).Control(2).Enabled=   0   'False
      Tab(1).Control(3)=   "Shape3"
      Tab(1).Control(3).Enabled=   0   'False
      Tab(1).Control(4)=   "Shape4"
      Tab(1).Control(4).Enabled=   0   'False
      Tab(1).Control(5)=   "Label22"
      Tab(1).Control(5).Enabled=   0   'False
      Tab(1).Control(6)=   "Label23"
      Tab(1).Control(6).Enabled=   0   'False
      Tab(1).Control(7)=   "Label24"
      Tab(1).Control(7).Enabled=   0   'False
      Tab(1).Control(8)=   "Label25"
      Tab(1).Control(8).Enabled=   0   'False
      Tab(1).Control(9)=   "Label26"
      Tab(1).Control(9).Enabled=   0   'False
      Tab(1).Control(10)=   "lbFormulaIndexId"
      Tab(1).Control(10).Enabled=   0   'False
      Tab(1).Control(11)=   "Shape5"
      Tab(1).Control(11).Enabled=   0   'False
      Tab(1).Control(12)=   "txIdxGroup"
      Tab(1).Control(12).Enabled=   0   'False
      Tab(1).Control(13)=   "cmdFormulaValue"
      Tab(1).Control(13).Enabled=   0   'False
      Tab(1).Control(14)=   "chkFormulaHide"
      Tab(1).Control(14).Enabled=   0   'False
      Tab(1).Control(15)=   "cmdFormulaHide"
      Tab(1).Control(15).Enabled=   0   'False
      Tab(1).Control(16)=   "chkFormulaValue"
      Tab(1).Control(16).Enabled=   0   'False
      Tab(1).Control(17)=   "opBeforePrint"
      Tab(1).Control(17).Enabled=   0   'False
      Tab(1).Control(18)=   "opAfterPrint"
      Tab(1).Control(18).Enabled=   0   'False
      Tab(1).ControlCount=   19
      TabCaption(2)   =   "Base de Datos"
      TabPicture(2)   =   "fProperties.frx":05C2
      Tab(2).ControlEnabled=   0   'False
      Tab(2).Control(0)=   "Label7"
      Tab(2).Control(1)=   "lbDescrip"
      Tab(2).Control(2)=   "Shape2"
      Tab(2).Control(3)=   "TxDbField"
      Tab(2).ControlCount=   4
      TabCaption(3)   =   "Imagen"
      TabPicture(3)   =   "fProperties.frx":05DE
      Tab(3).ControlEnabled=   0   'False
      Tab(3).Control(0)=   "Label16"
      Tab(3).Control(1)=   "shImage"
      Tab(3).Control(2)=   "txImageFile"
      Tab(3).Control(3)=   "picImage"
      Tab(3).ControlCount=   4
      TabCaption(4)   =   "Bordes"
      TabPicture(4)   =   "fProperties.frx":05FA
      Tab(4).ControlEnabled=   0   'False
      Tab(4).Control(0)=   "Label17"
      Tab(4).Control(1)=   "shBorderColor"
      Tab(4).Control(2)=   "Label18"
      Tab(4).Control(3)=   "Label19"
      Tab(4).Control(4)=   "shBorder3D"
      Tab(4).Control(5)=   "Label20"
      Tab(4).Control(6)=   "shBorderShadow"
      Tab(4).Control(7)=   "Label21"
      Tab(4).Control(8)=   "txBorderShadow"
      Tab(4).Control(9)=   "txBorder3D"
      Tab(4).Control(10)=   "txBorderWidth"
      Tab(4).Control(11)=   "txBorderColor"
      Tab(4).Control(12)=   "cbBorderType"
      Tab(4).Control(13)=   "chkBorderRounded"
      Tab(4).ControlCount=   14
      TabCaption(5)   =   "Grafico"
      TabPicture(5)   =   "fProperties.frx":0616
      Tab(5).ControlEnabled=   0   'False
      Tab(5).Control(0)=   "Picture3"
      Tab(5).Control(1)=   "Picture2"
      Tab(5).Control(2)=   "chkSort"
      Tab(5).Control(3)=   "cbColorSerie2"
      Tab(5).Control(4)=   "cbFormatType"
      Tab(5).Control(5)=   "cbType"
      Tab(5).Control(6)=   "cbColorSerie1"
      Tab(5).Control(7)=   "cbLinesType"
      Tab(5).Control(8)=   "cbChartThickness"
      Tab(5).Control(9)=   "cbChartSize"
      Tab(5).Control(10)=   "TxDbFieldVal1"
      Tab(5).Control(11)=   "TxDbFieldLbl1"
      Tab(5).Control(12)=   "TxDbFieldVal2"
      Tab(5).Control(13)=   "TxDbFieldLbl2"
      Tab(5).Control(14)=   "txChartTop"
      Tab(5).Control(15)=   "TxDbFieldGroupValue"
      Tab(5).Control(16)=   "txChartGroupValue"
      Tab(5).Control(17)=   "Label43"
      Tab(5).Control(18)=   "Label42"
      Tab(5).Control(19)=   "Label41"
      Tab(5).Control(20)=   "Label38(1)"
      Tab(5).Control(21)=   "Label40"
      Tab(5).Control(22)=   "Label39"
      Tab(5).Control(23)=   "Label38(0)"
      Tab(5).Control(24)=   "Label37"
      Tab(5).Control(25)=   "Label36"
      Tab(5).Control(26)=   "Label35"
      Tab(5).Control(27)=   "Label34"
      Tab(5).Control(28)=   "Label33"
      Tab(5).Control(29)=   "Label32"
      Tab(5).Control(30)=   "Label31"
      Tab(5).Control(31)=   "Label30"
      Tab(5).Control(32)=   "Label29"
      Tab(5).Control(33)=   "Label28"
      Tab(5).Control(34)=   "Label27"
      Tab(5).ControlCount=   35
      Begin VB.PictureBox Picture3 
         BorderStyle     =   0  'None
         Height          =   315
         Left            =   -73740
         ScaleHeight     =   315
         ScaleWidth      =   1515
         TabIndex        =   112
         Top             =   1440
         Width           =   1515
         Begin VB.OptionButton opLinesNo 
            Caption         =   "No"
            Height          =   315
            Left            =   660
            TabIndex        =   114
            Top             =   0
            Width           =   615
         End
         Begin VB.OptionButton opLinesYes 
            Caption         =   "Yes"
            Height          =   315
            Left            =   0
            TabIndex        =   113
            Top             =   0
            Width           =   615
         End
      End
      Begin VB.PictureBox Picture2 
         BorderStyle     =   0  'None
         Height          =   315
         Left            =   -73740
         ScaleHeight     =   315
         ScaleWidth      =   1395
         TabIndex        =   109
         Top             =   1140
         Width           =   1395
         Begin VB.OptionButton opValuesYes 
            Caption         =   "Yes"
            Height          =   315
            Left            =   0
            TabIndex        =   111
            Top             =   0
            Width           =   615
         End
         Begin VB.OptionButton opValuesNo 
            Caption         =   "No"
            Height          =   315
            Left            =   660
            TabIndex        =   110
            Top             =   0
            Width           =   615
         End
      End
      Begin VB.CheckBox chkIsFreeCtrl 
         Alignment       =   1  'Right Justify
         Appearance      =   0  'Flat
         Caption         =   "El control es el fondo de la hoja (No esta sujeto a los limites de la sección) :"
         ForeColor       =   &H80000008&
         Height          =   195
         Left            =   -74865
         TabIndex        =   105
         Top             =   5400
         Width           =   5595
      End
      Begin VB.CheckBox chkSort 
         Alignment       =   1  'Right Justify
         Appearance      =   0  'Flat
         Caption         =   "Ordenar :"
         ForeColor       =   &H80000008&
         Height          =   240
         Left            =   -74700
         TabIndex        =   104
         Top             =   1860
         Width           =   975
      End
      Begin VB.ComboBox cbColorSerie2 
         Height          =   315
         Left            =   -73920
         Style           =   2  'Dropdown List
         TabIndex        =   96
         Top             =   5280
         Width           =   1515
      End
      Begin VB.ComboBox cbFormatType 
         Height          =   315
         Left            =   -70740
         Style           =   2  'Dropdown List
         TabIndex        =   87
         Top             =   420
         Width           =   1755
      End
      Begin VB.ComboBox cbType 
         Height          =   315
         Left            =   -73740
         Style           =   2  'Dropdown List
         TabIndex        =   86
         Top             =   420
         Width           =   1755
      End
      Begin VB.ComboBox cbColorSerie1 
         Height          =   315
         Left            =   -73920
         Style           =   2  'Dropdown List
         TabIndex        =   85
         Top             =   3960
         Width           =   1515
      End
      Begin VB.ComboBox cbLinesType 
         Height          =   315
         Left            =   -73740
         Style           =   2  'Dropdown List
         TabIndex        =   84
         Top             =   780
         Width           =   1755
      End
      Begin VB.ComboBox cbChartThickness 
         Height          =   315
         Left            =   -70740
         Style           =   2  'Dropdown List
         TabIndex        =   83
         Top             =   1140
         Width           =   1755
      End
      Begin VB.ComboBox cbChartSize 
         Height          =   315
         Left            =   -70740
         Style           =   2  'Dropdown List
         TabIndex        =   82
         Top             =   780
         Width           =   1755
      End
      Begin VB.OptionButton opAfterPrint 
         Caption         =   "despues"
         Height          =   195
         Left            =   3360
         TabIndex        =   70
         Top             =   4800
         Width           =   975
      End
      Begin VB.OptionButton opBeforePrint 
         Caption         =   "antes"
         Height          =   195
         Left            =   2220
         TabIndex        =   67
         Top             =   4800
         Width           =   795
      End
      Begin VB.CheckBox chkBorderRounded 
         Alignment       =   1  'Right Justify
         Appearance      =   0  'Flat
         Caption         =   "Bordes redondeados:"
         ForeColor       =   &H80000008&
         Height          =   240
         Left            =   -74820
         TabIndex        =   62
         Top             =   2580
         Width           =   1905
      End
      Begin VB.ComboBox cbBorderType 
         Height          =   315
         ItemData        =   "fProperties.frx":0632
         Left            =   -73365
         List            =   "fProperties.frx":0634
         Sorted          =   -1  'True
         Style           =   2  'Dropdown List
         TabIndex        =   52
         Top             =   720
         Width           =   1680
      End
      Begin VB.CheckBox chkCanGrow 
         Alignment       =   1  'Right Justify
         Appearance      =   0  'Flat
         Caption         =   "Puede crecer :"
         ForeColor       =   &H80000008&
         Height          =   240
         Left            =   -74880
         TabIndex        =   33
         Top             =   4875
         Width           =   1455
      End
      Begin VB.PictureBox picImage 
         Appearance      =   0  'Flat
         AutoRedraw      =   -1  'True
         BackColor       =   &H80000005&
         BorderStyle     =   0  'None
         ForeColor       =   &H80000008&
         Height          =   375
         Left            =   -74160
         ScaleHeight     =   375
         ScaleWidth      =   375
         TabIndex        =   51
         Top             =   1200
         Width           =   375
      End
      Begin VB.CheckBox chkWordWrap 
         Alignment       =   1  'Right Justify
         Appearance      =   0  'Flat
         Caption         =   "Ajustar Texto :"
         ForeColor       =   &H80000008&
         Height          =   420
         Left            =   -73230
         TabIndex        =   34
         Top             =   4800
         Width           =   1485
      End
      Begin VB.CheckBox chkFormulaValue 
         Appearance      =   0  'Flat
         Caption         =   "Valor"
         ForeColor       =   &H80000008&
         Height          =   285
         Left            =   1530
         TabIndex        =   46
         Top             =   4395
         Width           =   750
      End
      Begin VB.ComboBox cbAlign 
         Height          =   315
         ItemData        =   "fProperties.frx":0636
         Left            =   -73785
         List            =   "fProperties.frx":0638
         Sorted          =   -1  'True
         Style           =   2  'Dropdown List
         TabIndex        =   11
         Top             =   2160
         Width           =   1680
      End
      Begin VB.CheckBox chkFontStrike 
         Alignment       =   1  'Right Justify
         Appearance      =   0  'Flat
         Caption         =   "Tachado :"
         ForeColor       =   &H80000008&
         Height          =   240
         Left            =   -70410
         TabIndex        =   15
         Top             =   2565
         Width           =   1140
      End
      Begin VB.CheckBox chkTransparent 
         Alignment       =   1  'Right Justify
         Appearance      =   0  'Flat
         Caption         =   "Transparente :"
         ForeColor       =   &H80000008&
         Height          =   240
         Left            =   -71850
         TabIndex        =   20
         Top             =   3015
         Width           =   1455
      End
      Begin VB.CheckBox chkFontUnderline 
         Alignment       =   1  'Right Justify
         Appearance      =   0  'Flat
         Caption         =   "SubRayado :"
         ForeColor       =   &H80000008&
         Height          =   240
         Left            =   -70545
         TabIndex        =   13
         Top             =   2205
         Width           =   1275
      End
      Begin VB.CheckBox chkFontItalic 
         Alignment       =   1  'Right Justify
         Appearance      =   0  'Flat
         Caption         =   "Italica :"
         ForeColor       =   &H80000008&
         Height          =   240
         Left            =   -71670
         TabIndex        =   14
         Top             =   2565
         Width           =   825
      End
      Begin VB.CheckBox chkFontBold 
         Alignment       =   1  'Right Justify
         Appearance      =   0  'Flat
         Caption         =   "Negrita :"
         ForeColor       =   &H80000008&
         Height          =   240
         Left            =   -71805
         TabIndex        =   12
         Top             =   2205
         Width           =   960
      End
      Begin CSButton.cButton cmdFormulaHide 
         Height          =   375
         Left            =   150
         TabIndex        =   40
         ToolTipText     =   "Editar Formula ..."
         Top             =   450
         Width           =   1005
         _ExtentX        =   1773
         _ExtentY        =   661
         Caption         =   "Editar..."
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         FontName        =   "MS Sans Serif"
         FontSize        =   8.25
         Picture         =   "fProperties.frx":063A
      End
      Begin VB.CheckBox chkFormulaHide 
         Appearance      =   0  'Flat
         Caption         =   "Tiene formula para mostrar"
         ForeColor       =   &H80000008&
         Height          =   285
         Left            =   1530
         TabIndex        =   37
         Top             =   495
         Width           =   2370
      End
      Begin CSMaskEdit2.cMaskEdit txFont 
         Height          =   285
         Left            =   -73785
         TabIndex        =   7
         Top             =   1755
         Width           =   2985
         _ExtentX        =   5265
         _ExtentY        =   503
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         FontName        =   "MS Sans Serif"
         FontSize        =   8.25
         EnabledNoChngBkColor=   0   'False
         Text            =   ""
         csType          =   5
         BorderColor     =   12164479
         BorderType      =   1
         csNotRaiseError =   -1  'True
         csWithOutCalc   =   -1  'True
      End
      Begin CSMaskEdit2.cMaskEdit txText 
         Height          =   285
         Left            =   -73785
         TabIndex        =   3
         Top             =   945
         Width           =   4560
         _ExtentX        =   8043
         _ExtentY        =   503
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         FontName        =   "MS Sans Serif"
         FontSize        =   8.25
         EnabledNoChngBkColor=   0   'False
         Text            =   ""
         csType          =   5
         BorderColor     =   12164479
         BorderType      =   1
         csNotRaiseError =   -1  'True
      End
      Begin CSMaskEdit2.cMaskEdit txLeft 
         Height          =   285
         Left            =   -73785
         TabIndex        =   26
         Top             =   3915
         Width           =   1230
         _ExtentX        =   2170
         _ExtentY        =   503
         Alignment       =   1
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         FontName        =   "MS Sans Serif"
         FontSize        =   8.25
         EnabledNoChngBkColor=   0   'False
         Text            =   "0.00"
         csType          =   3
         BorderColor     =   12164479
         BorderType      =   1
         csNotRaiseError =   -1  'True
      End
      Begin CSMaskEdit2.cMaskEdit txTop 
         Height          =   285
         Left            =   -71175
         TabIndex        =   30
         Top             =   3915
         Width           =   1230
         _ExtentX        =   2170
         _ExtentY        =   503
         Alignment       =   1
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         FontName        =   "MS Sans Serif"
         FontSize        =   8.25
         EnabledNoChngBkColor=   0   'False
         Text            =   "0.00"
         csType          =   3
         BorderColor     =   12164479
         BorderType      =   1
         csNotRaiseError =   -1  'True
      End
      Begin CSMaskEdit2.cMaskEdit txHeight 
         Height          =   285
         Left            =   -73785
         TabIndex        =   28
         Top             =   4320
         Width           =   1230
         _ExtentX        =   2170
         _ExtentY        =   503
         Alignment       =   1
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         FontName        =   "MS Sans Serif"
         FontSize        =   8.25
         EnabledNoChngBkColor=   0   'False
         Text            =   "0.00"
         csType          =   3
         BorderColor     =   12164479
         BorderType      =   1
         csNotRaiseError =   -1  'True
      End
      Begin CSMaskEdit2.cMaskEdit txWidth 
         Height          =   285
         Left            =   -71175
         TabIndex        =   32
         Top             =   4320
         Width           =   1230
         _ExtentX        =   2170
         _ExtentY        =   503
         Alignment       =   1
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         FontName        =   "MS Sans Serif"
         FontSize        =   8.25
         EnabledNoChngBkColor=   0   'False
         Text            =   "0.00"
         csType          =   3
         BorderColor     =   12164479
         BorderType      =   1
         csNotRaiseError =   -1  'True
      End
      Begin CSMaskEdit2.cMaskEdit TxDbField 
         Height          =   285
         Left            =   -74160
         TabIndex        =   38
         Top             =   630
         Width           =   5040
         _ExtentX        =   8890
         _ExtentY        =   503
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         FontName        =   "MS Sans Serif"
         FontSize        =   8.25
         EnabledNoChngBkColor=   0   'False
         Text            =   ""
         csType          =   5
         BorderColor     =   12164479
         BorderType      =   1
         csNotRaiseError =   -1  'True
      End
      Begin CSMaskEdit2.cMaskEdit TxName 
         Height          =   285
         Left            =   -73785
         TabIndex        =   1
         Top             =   450
         Width           =   4560
         _ExtentX        =   8043
         _ExtentY        =   503
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         FontName        =   "MS Sans Serif"
         FontSize        =   8.25
         EnabledNoChngBkColor=   0   'False
         Text            =   ""
         csType          =   5
         BorderColor     =   12164479
         BorderType      =   1
         csNotRaiseError =   -1  'True
      End
      Begin CSMaskEdit2.cMaskEdit TxFontSize 
         Height          =   285
         Left            =   -69960
         TabIndex        =   9
         Top             =   1755
         Width           =   735
         _ExtentX        =   1296
         _ExtentY        =   503
         Alignment       =   1
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         FontName        =   "MS Sans Serif"
         FontSize        =   8.25
         EnabledNoChngBkColor=   0   'False
         Text            =   "0.00"
         csType          =   3
         BorderColor     =   12164479
         BorderType      =   1
         csNotRaiseError =   -1  'True
      End
      Begin CSMaskEdit2.cMaskEdit TxForeColor 
         Height          =   285
         Left            =   -73785
         TabIndex        =   17
         Top             =   2610
         Width           =   1365
         _ExtentX        =   2408
         _ExtentY        =   503
         Alignment       =   1
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         FontName        =   "MS Sans Serif"
         FontSize        =   8.25
         EnabledNoChngBkColor=   0   'False
         Text            =   "0"
         csType          =   2
         BorderColor     =   12164479
         BorderType      =   1
         csNotRaiseError =   -1  'True
         csWithOutCalc   =   -1  'True
      End
      Begin CSMaskEdit2.cMaskEdit TxBackColor 
         Height          =   285
         Left            =   -73785
         TabIndex        =   19
         Top             =   3015
         Width           =   1365
         _ExtentX        =   2408
         _ExtentY        =   503
         Alignment       =   1
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         FontName        =   "MS Sans Serif"
         FontSize        =   8.25
         EnabledNoChngBkColor=   0   'False
         Text            =   "0"
         csType          =   2
         BorderColor     =   12164479
         BorderType      =   1
         csNotRaiseError =   -1  'True
         csWithOutCalc   =   -1  'True
      End
      Begin CSMaskEdit2.cMaskEdit TxFormat 
         Height          =   285
         Left            =   -73785
         TabIndex        =   22
         Top             =   3420
         Width           =   2985
         _ExtentX        =   5265
         _ExtentY        =   503
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         FontName        =   "MS Sans Serif"
         FontSize        =   8.25
         EnabledNoChngBkColor=   0   'False
         Text            =   ""
         csType          =   5
         BorderColor     =   12164479
         BorderType      =   1
         csNotRaiseError =   -1  'True
      End
      Begin CSButton.cButton cmdFormulaValue 
         Height          =   375
         Left            =   150
         TabIndex        =   45
         ToolTipText     =   "Editar Formula ..."
         Top             =   4350
         Width           =   1005
         _ExtentX        =   1773
         _ExtentY        =   661
         Caption         =   "Editar..."
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         FontName        =   "MS Sans Serif"
         FontSize        =   8.25
         Picture         =   "fProperties.frx":0BD4
      End
      Begin CSMaskEdit2.cMaskEdit txSymbol 
         Height          =   285
         Left            =   -69915
         TabIndex        =   24
         Top             =   3420
         Width           =   645
         _ExtentX        =   1138
         _ExtentY        =   503
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         FontName        =   "MS Sans Serif"
         FontSize        =   8.25
         EnabledNoChngBkColor=   0   'False
         Text            =   ""
         csType          =   5
         BorderColor     =   12164479
         BorderType      =   1
         csNotRaiseError =   -1  'True
      End
      Begin CSMaskEdit2.cMaskEdit txImageFile 
         Height          =   285
         Left            =   -74160
         TabIndex        =   49
         Top             =   630
         Width           =   5040
         _ExtentX        =   8890
         _ExtentY        =   503
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         FontName        =   "MS Sans Serif"
         FontSize        =   8.25
         EnabledNoChngBkColor=   0   'False
         Text            =   ""
         csType          =   5
         BorderColor     =   12164479
         BorderType      =   1
         csNotRaiseError =   -1  'True
      End
      Begin CSMaskEdit2.cMaskEdit txBorderColor 
         Height          =   285
         Left            =   -73365
         TabIndex        =   54
         Top             =   1140
         Width           =   1365
         _ExtentX        =   2408
         _ExtentY        =   503
         Alignment       =   1
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         FontName        =   "MS Sans Serif"
         FontSize        =   8.25
         EnabledNoChngBkColor=   0   'False
         Text            =   "0"
         csType          =   2
         BorderColor     =   12164479
         BorderType      =   1
         csNotRaiseError =   -1  'True
         csWithOutCalc   =   -1  'True
      End
      Begin CSMaskEdit2.cMaskEdit txBorderWidth 
         Height          =   285
         Left            =   -73365
         TabIndex        =   56
         Top             =   2220
         Width           =   990
         _ExtentX        =   1746
         _ExtentY        =   503
         Alignment       =   1
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         FontName        =   "MS Sans Serif"
         FontSize        =   8.25
         EnabledNoChngBkColor=   0   'False
         Text            =   "0.00"
         csType          =   3
         BorderColor     =   12164479
         BorderType      =   1
         csNotRaiseError =   -1  'True
      End
      Begin CSMaskEdit2.cMaskEdit txBorder3D 
         Height          =   285
         Left            =   -73365
         TabIndex        =   58
         Top             =   1500
         Width           =   1365
         _ExtentX        =   2408
         _ExtentY        =   503
         Alignment       =   1
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         FontName        =   "MS Sans Serif"
         FontSize        =   8.25
         EnabledNoChngBkColor=   0   'False
         Text            =   "0"
         csType          =   2
         BorderColor     =   12164479
         BorderType      =   1
         csNotRaiseError =   -1  'True
         csWithOutCalc   =   -1  'True
      End
      Begin CSMaskEdit2.cMaskEdit txBorderShadow 
         Height          =   285
         Left            =   -73365
         TabIndex        =   60
         Top             =   1860
         Width           =   1365
         _ExtentX        =   2408
         _ExtentY        =   503
         Alignment       =   1
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         FontName        =   "MS Sans Serif"
         FontSize        =   8.25
         EnabledNoChngBkColor=   0   'False
         Text            =   "0"
         csType          =   2
         BorderColor     =   12164479
         BorderType      =   1
         csNotRaiseError =   -1  'True
         csWithOutCalc   =   -1  'True
      End
      Begin CSMaskEdit2.cMaskEdit txIdxGroup 
         Height          =   285
         Left            =   5160
         TabIndex        =   65
         Top             =   4440
         Width           =   735
         _ExtentX        =   1296
         _ExtentY        =   503
         Alignment       =   1
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         FontName        =   "MS Sans Serif"
         FontSize        =   8.25
         EnabledNoChngBkColor=   0   'False
         Text            =   "0"
         csType          =   2
         BorderColor     =   12164479
         BorderType      =   1
         csNotRaiseError =   -1  'True
         ButtonStyle     =   0
      End
      Begin CSMaskEdit2.cMaskEdit TxDbFieldVal1 
         Height          =   285
         Left            =   -73905
         TabIndex        =   72
         Top             =   3240
         Width           =   5040
         _ExtentX        =   8890
         _ExtentY        =   503
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         FontName        =   "MS Sans Serif"
         FontSize        =   8.25
         EnabledNoChngBkColor=   0   'False
         Text            =   ""
         csType          =   5
         BorderColor     =   12164479
         BorderType      =   1
         csNotRaiseError =   -1  'True
      End
      Begin CSMaskEdit2.cMaskEdit TxDbFieldLbl1 
         Height          =   285
         Left            =   -73905
         TabIndex        =   74
         Top             =   3600
         Width           =   5040
         _ExtentX        =   8890
         _ExtentY        =   503
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         FontName        =   "MS Sans Serif"
         FontSize        =   8.25
         EnabledNoChngBkColor=   0   'False
         Text            =   ""
         csType          =   5
         BorderColor     =   12164479
         BorderType      =   1
         csNotRaiseError =   -1  'True
      End
      Begin CSMaskEdit2.cMaskEdit TxDbFieldVal2 
         Height          =   285
         Left            =   -73905
         TabIndex        =   77
         Top             =   4560
         Width           =   5040
         _ExtentX        =   8890
         _ExtentY        =   503
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         FontName        =   "MS Sans Serif"
         FontSize        =   8.25
         EnabledNoChngBkColor=   0   'False
         Text            =   ""
         csType          =   5
         BorderColor     =   12164479
         BorderType      =   1
         csNotRaiseError =   -1  'True
      End
      Begin CSMaskEdit2.cMaskEdit TxDbFieldLbl2 
         Height          =   285
         Left            =   -73905
         TabIndex        =   79
         Top             =   4920
         Width           =   5040
         _ExtentX        =   8890
         _ExtentY        =   503
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         FontName        =   "MS Sans Serif"
         FontSize        =   8.25
         EnabledNoChngBkColor=   0   'False
         Text            =   ""
         csType          =   5
         BorderColor     =   12164479
         BorderType      =   1
         csNotRaiseError =   -1  'True
      End
      Begin CSMaskEdit2.cMaskEdit txChartTop 
         Height          =   285
         Left            =   -70740
         TabIndex        =   98
         Top             =   1560
         Width           =   735
         _ExtentX        =   1296
         _ExtentY        =   503
         Alignment       =   1
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         FontName        =   "MS Sans Serif"
         FontSize        =   8.25
         EnabledNoChngBkColor=   0   'False
         Text            =   "0.00"
         csType          =   3
         BorderColor     =   12164479
         BorderType      =   1
         csNotRaiseError =   -1  'True
      End
      Begin CSMaskEdit2.cMaskEdit TxDbFieldGroupValue 
         Height          =   285
         Left            =   -73905
         TabIndex        =   100
         Top             =   2340
         Width           =   5040
         _ExtentX        =   8890
         _ExtentY        =   503
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         FontName        =   "MS Sans Serif"
         FontSize        =   8.25
         EnabledNoChngBkColor=   0   'False
         Text            =   ""
         csType          =   5
         BorderColor     =   12164479
         BorderType      =   1
         csNotRaiseError =   -1  'True
      End
      Begin CSMaskEdit2.cMaskEdit txChartGroupValue 
         Height          =   285
         Left            =   -73905
         TabIndex        =   102
         Top             =   2700
         Width           =   735
         _ExtentX        =   1296
         _ExtentY        =   503
         Alignment       =   1
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         FontName        =   "MS Sans Serif"
         FontSize        =   8.25
         EnabledNoChngBkColor=   0   'False
         Text            =   "0.00"
         csType          =   3
         BorderColor     =   12164479
         BorderType      =   1
         csNotRaiseError =   -1  'True
      End
      Begin CSMaskEdit2.cMaskEdit txTag 
         Height          =   285
         Left            =   -73785
         TabIndex        =   5
         Top             =   1350
         Width           =   4560
         _ExtentX        =   8043
         _ExtentY        =   503
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         FontName        =   "MS Sans Serif"
         FontSize        =   8.25
         EnabledNoChngBkColor=   0   'False
         Text            =   ""
         csType          =   5
         BorderColor     =   12164479
         BorderType      =   1
         csNotRaiseError =   -1  'True
      End
      Begin CSMaskEdit2.cMaskEdit txExportColIdx 
         Height          =   285
         Left            =   -72435
         TabIndex        =   106
         Top             =   5895
         Width           =   1230
         _ExtentX        =   2170
         _ExtentY        =   503
         Alignment       =   1
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         FontName        =   "MS Sans Serif"
         FontSize        =   8.25
         EnabledNoChngBkColor=   0   'False
         Text            =   "0.00"
         csType          =   3
         BorderColor     =   12164479
         BorderType      =   1
         csNotRaiseError =   -1  'True
      End
      Begin VB.Shape Shape5 
         BorderColor     =   &H80000010&
         Height          =   1755
         Left            =   120
         Top             =   2520
         Width           =   6075
      End
      Begin VB.Label lbFormulaIndexId 
         Caption         =   "Para funciones que se ejecutan en el Header se debe ingresar:  -2000"
         BeginProperty Font 
            Name            =   "Courier New"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H000000FF&
         Height          =   1635
         Left            =   240
         TabIndex        =   108
         Top             =   2580
         Width           =   5895
      End
      Begin VB.Line Line8 
         BorderColor     =   &H80000010&
         X1              =   -74820
         X2              =   -69240
         Y1              =   5760
         Y2              =   5760
      End
      Begin VB.Line Line7 
         BorderColor     =   &H80000010&
         X1              =   -74820
         X2              =   -69240
         Y1              =   5220
         Y2              =   5220
      End
      Begin VB.Label Label45 
         Caption         =   "Id de columna en la exportación:"
         Height          =   285
         Left            =   -74820
         TabIndex        =   107
         Top             =   5895
         Width           =   2400
      End
      Begin VB.Label Label44 
         Caption         =   "Tag :"
         Height          =   285
         Left            =   -74820
         TabIndex        =   4
         Top             =   1350
         Width           =   915
      End
      Begin VB.Label Label43 
         Alignment       =   1  'Right Justify
         Caption         =   "Group value :"
         Height          =   285
         Left            =   -75105
         TabIndex        =   103
         Top             =   2700
         Width           =   1140
      End
      Begin VB.Label Label42 
         Alignment       =   1  'Right Justify
         Caption         =   "Group value :"
         Height          =   285
         Left            =   -75105
         TabIndex        =   101
         Top             =   2385
         Width           =   1140
      End
      Begin VB.Label Label41 
         Alignment       =   1  'Right Justify
         Caption         =   "Top"
         Height          =   285
         Left            =   -71460
         TabIndex        =   99
         Top             =   1560
         Width           =   615
      End
      Begin VB.Label Label38 
         Alignment       =   1  'Right Justify
         BackStyle       =   0  'Transparent
         Caption         =   "Color :"
         Height          =   255
         Index           =   1
         Left            =   -75300
         TabIndex        =   97
         Top             =   5340
         Width           =   1335
      End
      Begin VB.Label Label40 
         Alignment       =   1  'Right Justify
         BackStyle       =   0  'Transparent
         Caption         =   "Format"
         Height          =   255
         Left            =   -71580
         TabIndex        =   95
         Top             =   480
         Width           =   735
      End
      Begin VB.Label Label39 
         Alignment       =   1  'Right Justify
         BackStyle       =   0  'Transparent
         Caption         =   "Type"
         Height          =   255
         Left            =   -74640
         TabIndex        =   94
         Top             =   480
         Width           =   735
      End
      Begin VB.Label Label38 
         Alignment       =   1  'Right Justify
         BackStyle       =   0  'Transparent
         Caption         =   "Color :"
         Height          =   255
         Index           =   0
         Left            =   -75300
         TabIndex        =   93
         Top             =   4020
         Width           =   1335
      End
      Begin VB.Label Label37 
         Alignment       =   1  'Right Justify
         BackStyle       =   0  'Transparent
         Caption         =   "Bar Grid Lines"
         Height          =   255
         Left            =   -75240
         TabIndex        =   92
         Top             =   840
         Width           =   1335
      End
      Begin VB.Label Label36 
         Alignment       =   1  'Right Justify
         BackColor       =   &H00FFFFFF&
         BackStyle       =   0  'Transparent
         Caption         =   "Bar Values"
         Height          =   315
         Left            =   -75120
         TabIndex        =   91
         Top             =   1200
         Width           =   1215
      End
      Begin VB.Label Label35 
         Alignment       =   1  'Right Justify
         BackStyle       =   0  'Transparent
         Caption         =   "Pie Chart Thickness"
         Height          =   255
         Left            =   -72300
         TabIndex        =   90
         Top             =   1200
         Width           =   1455
      End
      Begin VB.Label Label34 
         Alignment       =   1  'Right Justify
         BackStyle       =   0  'Transparent
         Caption         =   "Pie Chart Size"
         Height          =   255
         Left            =   -72180
         TabIndex        =   89
         Top             =   840
         Width           =   1335
      End
      Begin VB.Label Label33 
         Alignment       =   1  'Right Justify
         BackColor       =   &H00FFFFFF&
         BackStyle       =   0  'Transparent
         Caption         =   "Show Outlines"
         Height          =   315
         Left            =   -75120
         TabIndex        =   88
         Top             =   1500
         Width           =   1215
      End
      Begin VB.Label Label32 
         Caption         =   "Serie 2"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   315
         Left            =   -74880
         TabIndex        =   81
         Top             =   4320
         Width           =   2475
      End
      Begin VB.Label Label31 
         Alignment       =   1  'Right Justify
         Caption         =   "Field label :"
         Height          =   285
         Left            =   -75105
         TabIndex        =   80
         Top             =   4965
         Width           =   1140
      End
      Begin VB.Label Label30 
         Alignment       =   1  'Right Justify
         Caption         =   "Field value :"
         Height          =   285
         Left            =   -75105
         TabIndex        =   78
         Top             =   4605
         Width           =   1140
      End
      Begin VB.Label Label29 
         Caption         =   "Serie 1"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   315
         Left            =   -74880
         TabIndex        =   76
         Top             =   3000
         Width           =   2475
      End
      Begin VB.Label Label28 
         Alignment       =   1  'Right Justify
         Caption         =   "Field label :"
         Height          =   285
         Left            =   -75105
         TabIndex        =   75
         Top             =   3645
         Width           =   1140
      End
      Begin VB.Label Label27 
         Alignment       =   1  'Right Justify
         Caption         =   "Field value :"
         Height          =   285
         Left            =   -75105
         TabIndex        =   73
         Top             =   3285
         Width           =   1140
      End
      Begin VB.Label Label26 
         Caption         =   "de imprimir la linea"
         Height          =   255
         Left            =   4380
         TabIndex        =   71
         Top             =   4800
         Width           =   1395
      End
      Begin VB.Label Label25 
         Caption         =   "o"
         Height          =   255
         Left            =   3060
         TabIndex        =   69
         Top             =   4800
         Width           =   135
      End
      Begin VB.Label Label24 
         Caption         =   "Ejecutar"
         Height          =   255
         Left            =   1560
         TabIndex        =   68
         Top             =   4800
         Width           =   615
      End
      Begin VB.Label Label23 
         Caption         =   "Ejecutar solo en el grupo:"
         Height          =   255
         Left            =   3120
         TabIndex        =   66
         Top             =   4440
         Width           =   1875
      End
      Begin VB.Label Label22 
         Caption         =   "La formula debe devolver un valor distinto de cero para que se muestre la sección."
         Height          =   375
         Left            =   240
         TabIndex        =   64
         Top             =   960
         Width           =   5715
      End
      Begin VB.Label Label21 
         Caption         =   "Color 3D Sombra :"
         Height          =   285
         Left            =   -74760
         TabIndex        =   61
         Top             =   1860
         Width           =   1335
      End
      Begin VB.Shape shBorderShadow 
         BackStyle       =   1  'Opaque
         BorderColor     =   &H00808080&
         Height          =   300
         Left            =   -71970
         Top             =   1860
         Width           =   285
      End
      Begin VB.Label Label20 
         Caption         =   "Color 3D :"
         Height          =   285
         Left            =   -74760
         TabIndex        =   59
         Top             =   1500
         Width           =   915
      End
      Begin VB.Shape shBorder3D 
         BackStyle       =   1  'Opaque
         BorderColor     =   &H00808080&
         Height          =   300
         Left            =   -71970
         Top             =   1500
         Width           =   285
      End
      Begin VB.Label Label19 
         Caption         =   "Ancho :"
         Height          =   285
         Left            =   -74760
         TabIndex        =   57
         Top             =   2220
         Width           =   915
      End
      Begin VB.Label Label18 
         Caption         =   "Color :"
         Height          =   285
         Left            =   -74760
         TabIndex        =   55
         Top             =   1140
         Width           =   915
      End
      Begin VB.Shape shBorderColor 
         BackStyle       =   1  'Opaque
         BorderColor     =   &H00808080&
         Height          =   300
         Left            =   -71970
         Top             =   1140
         Width           =   285
      End
      Begin VB.Label Label17 
         Caption         =   "Tipo :"
         Height          =   285
         Left            =   -74760
         TabIndex        =   53
         Top             =   720
         Width           =   915
      End
      Begin VB.Shape shImage 
         BorderColor     =   &H80000010&
         Height          =   405
         Left            =   -74175
         Top             =   1185
         Width           =   405
      End
      Begin VB.Label Label16 
         Caption         =   "Imagen :"
         Height          =   285
         Left            =   -74880
         TabIndex        =   50
         Top             =   675
         Width           =   1140
      End
      Begin VB.Shape Shape4 
         BorderColor     =   &H80000010&
         Height          =   1035
         Left            =   180
         Top             =   5100
         Width           =   5715
      End
      Begin VB.Shape Shape3 
         BorderColor     =   &H80000010&
         Height          =   795
         Left            =   180
         Top             =   1440
         Width           =   5715
      End
      Begin VB.Shape Shape2 
         BorderColor     =   &H80000010&
         Height          =   3135
         Left            =   -74760
         Top             =   960
         Width           =   5775
      End
      Begin VB.Line Line4 
         BorderColor     =   &H80000010&
         X1              =   120
         X2              =   6200
         Y1              =   2400
         Y2              =   2400
      End
      Begin VB.Label Label15 
         Caption         =   "Simbolo :"
         Height          =   285
         Left            =   -70680
         TabIndex        =   23
         Top             =   3420
         Width           =   915
      End
      Begin VB.Label Label14 
         Caption         =   "Formato :"
         Height          =   285
         Left            =   -74820
         TabIndex        =   21
         Top             =   3420
         Width           =   915
      End
      Begin VB.Label Label13 
         Caption         =   "Alineación :"
         Height          =   285
         Left            =   -74820
         TabIndex        =   10
         Top             =   2205
         Width           =   915
      End
      Begin VB.Shape shBackColor 
         BackStyle       =   1  'Opaque
         BorderColor     =   &H00808080&
         BorderWidth     =   2
         Height          =   300
         Left            =   -72390
         Top             =   3015
         Width           =   285
      End
      Begin VB.Shape shForeColor 
         BackColor       =   &H80000008&
         BackStyle       =   1  'Opaque
         BorderColor     =   &H00808080&
         BorderWidth     =   2
         Height          =   300
         Left            =   -72390
         Top             =   2610
         Width           =   285
      End
      Begin VB.Label Label12 
         Caption         =   "Color Fondo :"
         Height          =   285
         Left            =   -74820
         TabIndex        =   18
         Top             =   3060
         Width           =   960
      End
      Begin VB.Label Label11 
         Caption         =   "Color Texto :"
         Height          =   285
         Left            =   -74820
         TabIndex        =   16
         Top             =   2655
         Width           =   915
      End
      Begin VB.Label Label10 
         Caption         =   "Tamaño :"
         Height          =   285
         Left            =   -70680
         TabIndex        =   8
         Top             =   1755
         Width           =   915
      End
      Begin VB.Line Line3 
         BorderColor     =   &H80000010&
         X1              =   -74820
         X2              =   -69240
         Y1              =   3780
         Y2              =   3780
      End
      Begin VB.Line Line2 
         BorderColor     =   &H80000010&
         X1              =   -74820
         X2              =   -69240
         Y1              =   4725
         Y2              =   4725
      End
      Begin VB.Line Line1 
         BorderColor     =   &H80000010&
         X1              =   -74775
         X2              =   -69195
         Y1              =   810
         Y2              =   810
      End
      Begin VB.Label Label9 
         Caption         =   "Nombre :"
         Height          =   285
         Left            =   -74820
         TabIndex        =   0
         Top             =   450
         Width           =   915
      End
      Begin VB.Label lbDescrip 
         Appearance      =   0  'Flat
         ForeColor       =   &H80000008&
         Height          =   2880
         Left            =   -74745
         TabIndex        =   42
         Top             =   975
         Width           =   5760
      End
      Begin VB.Label Label7 
         Caption         =   "Campo :"
         Height          =   285
         Left            =   -74775
         TabIndex        =   41
         Top             =   675
         Width           =   1140
      End
      Begin VB.Label Label6 
         Caption         =   "Alto :"
         Height          =   285
         Left            =   -74820
         TabIndex        =   27
         Top             =   4320
         Width           =   915
      End
      Begin VB.Label Label5 
         Caption         =   "Ancho :"
         Height          =   285
         Left            =   -71850
         TabIndex        =   31
         Top             =   4320
         Width           =   915
      End
      Begin VB.Label Label4 
         Caption         =   "Arriba :"
         Height          =   285
         Left            =   -71850
         TabIndex        =   29
         Top             =   3915
         Width           =   915
      End
      Begin VB.Label Label3 
         Caption         =   "Izquierda :"
         Height          =   285
         Left            =   -74820
         TabIndex        =   25
         Top             =   3915
         Width           =   915
      End
      Begin VB.Label Label2 
         Caption         =   "Texto :"
         Height          =   285
         Left            =   -74820
         TabIndex        =   2
         Top             =   945
         Width           =   915
      End
      Begin VB.Label Label1 
         Caption         =   "Fuente :"
         Height          =   285
         Left            =   -74820
         TabIndex        =   6
         Top             =   1800
         Width           =   915
      End
      Begin VB.Label lbFormulaHide 
         Appearance      =   0  'Flat
         ForeColor       =   &H80000008&
         Height          =   660
         Left            =   195
         TabIndex        =   47
         Top             =   1455
         Width           =   5700
      End
      Begin VB.Label lbFormulaValue 
         Appearance      =   0  'Flat
         ForeColor       =   &H80000008&
         Height          =   900
         Left            =   195
         TabIndex        =   48
         Top             =   5175
         Width           =   5700
      End
   End
   Begin MSComDlg.CommonDialog CommDialog 
      Left            =   5580
      Top             =   60
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.Label LbControl 
      BackStyle       =   0  'Transparent
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   240
      Left            =   3105
      TabIndex        =   44
      Top             =   225
      Width           =   1815
   End
   Begin VB.Label Label8 
      BackStyle       =   0  'Transparent
      Caption         =   "Propiedades del control:"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   240
      Left            =   915
      TabIndex        =   43
      Top             =   225
      Width           =   2235
   End
   Begin VB.Image Image1 
      Height          =   585
      Left            =   135
      Picture         =   "fProperties.frx":116E
      Top             =   45
      Width           =   675
   End
   Begin VB.Shape Shape1 
      BorderStyle     =   0  'Transparent
      FillColor       =   &H00FFFFFF&
      FillStyle       =   0  'Solid
      Height          =   645
      Left            =   0
      Top             =   0
      Width           =   6360
   End
End
Attribute VB_Name = "fProperties"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit


'--------------------------------------------------------------------------------
' fProperties
' 25-10-2001

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "fProperties"

Private Const C_Label = 0
Private Const C_Formula = 1
Private Const C_Field = 2
Private Const C_Image = 3
Private Const C_Chart = 5

' estructuras
' variables privadas
Private m_Ok                As Boolean
Private m_Done              As Boolean

Private m_Index                         As Long
Private m_FieldType                     As Long

Private m_FormulaHide                   As String
Private m_FormulaValue                  As String

Private m_FormulaName                   As String

Private m_IsAccounting                  As Boolean

Private m_Mouse                         As cMouse

Private m_TextChanged                   As Boolean
Private m_TagChanged                    As Boolean
Private m_FontChanged                   As Boolean
Private m_ForeColorChanged              As Boolean
Private m_BackColorChanged              As Boolean
Private m_FormatChanged                 As Boolean
Private m_LeftChanged                   As Boolean
Private m_TopChanged                    As Boolean
Private m_HeightChanged                 As Boolean
Private m_WidthChanged                  As Boolean
Private m_SymbolChanged                 As Boolean
Private m_TransparentChanged            As Boolean
Private m_StrikeChanged                 As Boolean
Private m_UnderlineChanged              As Boolean
Private m_WordWrapChanged               As Boolean
Private m_ItalicChanged                 As Boolean
Private m_BoldChanged                   As Boolean
Private m_AlignChanged                  As Boolean
Private m_FontSizeChanged               As Boolean
Private m_CanGrowChanged                As Boolean
Private m_FormulaHideChanged            As Boolean
Private m_FormulaValueChanged           As Boolean
Private m_IdxGroupChanged               As Boolean
Private m_WhenEvalChanged               As Boolean
Private m_DbFieldChanged                As Boolean
Private m_SetFormulaHideChanged         As Boolean
Private m_SetFormulaValueChanged        As Boolean
Private m_PictureChanged                As Boolean
Private m_BorderTypeChanged             As Boolean
Private m_Border3DChanged               As Boolean
Private m_Border3DShadowChanged         As Boolean
Private m_BorderRoundedChanged          As Boolean
Private m_BorderWidthChanged            As Boolean
Private m_BorderColorChanged            As Boolean

Private m_ChartFieldVal1Changed         As Boolean
Private m_ChartFieldVal2Changed         As Boolean
Private m_ChartFieldLbl1Changed         As Boolean
Private m_ChartFieldLbl2Changed         As Boolean
Private m_ChartSizeChanged              As Boolean
Private m_ChartThicknessChanged         As Boolean
Private m_ChartColorSerie1Changed       As Boolean
Private m_ChartColorSerie2Changed       As Boolean
Private m_ChartFormatTypeChanged        As Boolean
Private m_ChartLinesTypeChanged         As Boolean
Private m_ChartTypeChanged              As Boolean
Private m_ChartShowLinesChanged         As Boolean
Private m_ChartShowValuesChanged        As Boolean
Private m_ChartTopChanged               As Boolean
Private m_ChartSortChanged              As Boolean

Private m_ChartFieldGroupChanged        As Boolean
Private m_ChartGroupValueChanged        As Boolean

Private m_IsFreeCtrlChanged             As Boolean
Private m_ExportColIdxChanged           As Boolean

Private m_ChartIndex()                  As Long
Private m_ChartFieldType()              As Long

Private m_ChartGroupIndex               As Long
Private m_ChartGroupFieldType           As Long

' eventos
Public Event ShowHelpDbField(ByRef Cancel As Boolean)
Public Event ShowHelpChartGroupField(ByRef Cancel As Boolean)
Public Event ShowHelpChartField(ByRef Cancel As Boolean, ByRef Ctrl As Object, ByVal Idx As Long)
Public Event ShowEditFormula(ByRef Formula As String, ByRef Cancel As Boolean)
Public Event UnloadForm()
Public Event Cancel()
' propiedades publicas
Public Property Get PictureChanged() As Boolean
   PictureChanged = m_PictureChanged
End Property

Public Property Let PictureChanged(ByVal rhs As Boolean)
   m_PictureChanged = rhs
End Property

Public Property Get Ok() As Boolean
  Ok = m_Ok
End Property

Public Property Get Index() As Long
   Index = m_Index
End Property

Public Property Get ChartGroupIndex() As Long
   ChartGroupIndex = m_ChartGroupIndex
End Property

Public Property Get ChartIndex(ByVal Idx As Long) As Long
   ChartIndex = m_ChartIndex(Idx)
End Property

Public Property Get FieldType() As Long
   FieldType = m_FieldType
End Property

Public Property Get ChartFieldType(ByVal Idx As Long) As Long
   ChartFieldType = m_ChartFieldType(Idx)
End Property

Public Property Get ChartGroupFieldType() As Long
   ChartGroupFieldType = m_ChartGroupFieldType
End Property

Public Property Let Index(ByVal rhs As Long)
   m_Index = rhs
End Property

Public Property Let ChartGroupIndex(ByVal rhs As Long)
   m_ChartGroupIndex = rhs
End Property

Public Property Let ChartIndex(ByVal Idx As Long, ByVal rhs As Long)
   m_ChartIndex(Idx) = rhs
End Property

Public Property Let FieldType(ByVal rhs As Long)
   m_FieldType = rhs
End Property

Public Property Let ChartGroupFieldType(ByVal rhs As Long)
   m_ChartGroupFieldType = rhs
End Property

Public Property Let ChartFieldType(ByVal Idx As Long, ByVal rhs As Long)
   m_ChartFieldType(Idx) = rhs
End Property

Public Property Get FormulaHide() As String
   FormulaHide = m_FormulaHide
End Property

Public Property Let FormulaHide(ByVal rhs As String)
   m_FormulaHide = rhs
End Property

Public Property Get FormulaValue() As String
   FormulaValue = m_FormulaValue
End Property

Public Property Let FormulaValue(ByVal rhs As String)
   m_FormulaValue = rhs
End Property

Public Property Get FormulaName() As String
   FormulaName = m_FormulaName
End Property

Public Property Let FormulaName(ByVal rhs As String)
   m_FormulaName = rhs
End Property

Public Property Get IsAccounting() As Boolean
   IsAccounting = m_IsAccounting
End Property

Public Property Let IsAccounting(ByVal rhs As Boolean)
   m_IsAccounting = rhs
End Property

Public Property Get TextChanged() As Boolean
   TextChanged = m_TextChanged
End Property

Public Property Let TextChanged(ByVal rhs As Boolean)
   m_TextChanged = rhs
End Property

Public Property Get TagChanged() As Boolean
   TagChanged = m_TagChanged
End Property

Public Property Let TagChanged(ByVal rhs As Boolean)
   m_TagChanged = rhs
End Property

Public Property Get FontChanged() As Boolean
   FontChanged = m_FontChanged
End Property

Public Property Let FontChanged(ByVal rhs As Boolean)
   m_FontChanged = rhs
End Property

Public Property Get ForeColorChanged() As Boolean
   ForeColorChanged = m_ForeColorChanged
End Property

Public Property Let ForeColorChanged(ByVal rhs As Boolean)
   m_ForeColorChanged = rhs
End Property

Public Property Get BackColorChanged() As Boolean
   BackColorChanged = m_BackColorChanged
End Property

Public Property Let BackColorChanged(ByVal rhs As Boolean)
   m_BackColorChanged = rhs
End Property

Public Property Get FormatChanged() As Boolean
   FormatChanged = m_FormatChanged
End Property

Public Property Let FormatChanged(ByVal rhs As Boolean)
   m_FormatChanged = rhs
End Property

Public Property Get LeftChanged() As Boolean
   LeftChanged = m_LeftChanged
End Property

Public Property Let LeftChanged(ByVal rhs As Boolean)
   m_LeftChanged = rhs
End Property

Public Property Get TopChanged() As Boolean
   TopChanged = m_TopChanged
End Property

Public Property Let TopChanged(ByVal rhs As Boolean)
   m_TopChanged = rhs
End Property

Public Property Get HeightChanged() As Boolean
   HeightChanged = m_HeightChanged
End Property

Public Property Let HeightChanged(ByVal rhs As Boolean)
   m_HeightChanged = rhs
End Property

Public Property Get WidthChanged() As Boolean
   WidthChanged = m_WidthChanged
End Property

Public Property Let WidthChanged(ByVal rhs As Boolean)
   m_WidthChanged = rhs
End Property

Public Property Get SymbolChanged() As Boolean
   SymbolChanged = m_SymbolChanged
End Property

Public Property Let SymbolChanged(ByVal rhs As Boolean)
   m_SymbolChanged = rhs
End Property

Public Property Get TransparentChanged() As Boolean
   TransparentChanged = m_TransparentChanged
End Property

Public Property Let TransparentChanged(ByVal rhs As Boolean)
   m_TransparentChanged = rhs
End Property

Public Property Get StrikeChanged() As Boolean
   StrikeChanged = m_StrikeChanged
End Property

Public Property Let StrikeChanged(ByVal rhs As Boolean)
   m_StrikeChanged = rhs
End Property

Public Property Get UnderlineChanged() As Boolean
   UnderlineChanged = m_UnderlineChanged
End Property

Public Property Let UnderlineChanged(ByVal rhs As Boolean)
   m_UnderlineChanged = rhs
End Property

Public Property Get WordWrapChanged() As Boolean
   WordWrapChanged = m_WordWrapChanged
End Property

Public Property Let WordWrapChanged(ByVal rhs As Boolean)
   m_WordWrapChanged = rhs
End Property

Public Property Get ItalicChanged() As Boolean
   ItalicChanged = m_ItalicChanged
End Property

Public Property Let ItalicChanged(ByVal rhs As Boolean)
   m_ItalicChanged = rhs
End Property

Public Property Get BoldChanged() As Boolean
   BoldChanged = m_BoldChanged
End Property

Public Property Let BoldChanged(ByVal rhs As Boolean)
   m_BoldChanged = rhs
End Property

Public Property Get AlignChanged() As Boolean
   AlignChanged = m_AlignChanged
End Property

Public Property Let AlignChanged(ByVal rhs As Boolean)
   m_AlignChanged = rhs
End Property

Public Property Get FontSizeChanged() As Boolean
   FontSizeChanged = m_FontSizeChanged
End Property

Public Property Let FontSizeChanged(ByVal rhs As Boolean)
   m_FontSizeChanged = rhs
End Property

Public Property Get CanGrowChanged() As Boolean
   CanGrowChanged = m_CanGrowChanged
End Property

Public Property Let CanGrowChanged(ByVal rhs As Boolean)
   m_CanGrowChanged = rhs
End Property

Public Property Get FormulaHideChanged() As Boolean
   FormulaHideChanged = m_FormulaHideChanged
End Property

Public Property Let FormulaHideChanged(ByVal rhs As Boolean)
   m_FormulaHideChanged = rhs
End Property

Public Property Get FormulaValueChanged() As Boolean
   FormulaValueChanged = m_FormulaValueChanged
End Property

Public Property Let FormulaValueChanged(ByVal rhs As Boolean)
   m_FormulaValueChanged = rhs
End Property

Public Property Get WhenEvalChanged() As Boolean
   WhenEvalChanged = m_WhenEvalChanged
End Property

Public Property Let WhenEvalChanged(ByVal rhs As Boolean)
   m_WhenEvalChanged = rhs
End Property

Public Property Get IdxGroupChanged() As Boolean
   IdxGroupChanged = m_IdxGroupChanged
End Property

Public Property Let IdxGroupChanged(ByVal rhs As Boolean)
   m_IdxGroupChanged = rhs
End Property

Public Property Get DbFieldChanged() As Boolean
   DbFieldChanged = m_DbFieldChanged
End Property

Public Property Let DbFieldChanged(ByVal rhs As Boolean)
   m_DbFieldChanged = rhs
End Property

Public Property Get SetFormulaHideChanged() As Boolean
   SetFormulaHideChanged = m_SetFormulaHideChanged
End Property

Public Property Let SetFormulaHideChanged(ByVal rhs As Boolean)
   m_SetFormulaHideChanged = rhs
End Property

Public Property Get SetFormulaValueChanged() As Boolean
   SetFormulaValueChanged = m_SetFormulaValueChanged
End Property

Public Property Let SetFormulaValueChanged(ByVal rhs As Boolean)
   m_SetFormulaValueChanged = rhs
End Property

Public Property Get BorderTypeChanged() As Boolean
   BorderTypeChanged = m_BorderTypeChanged
End Property

Public Property Let BorderTypeChanged(ByVal rhs As Boolean)
   m_BorderTypeChanged = rhs
End Property

Public Property Get Border3DChanged() As Boolean
   Border3DChanged = m_Border3DChanged
End Property

Public Property Let Border3DChanged(ByVal rhs As Boolean)
   m_Border3DChanged = rhs
End Property

Public Property Get Border3DShadowChanged() As Boolean
   Border3DShadowChanged = m_Border3DShadowChanged
End Property

Public Property Let Border3DShadowChanged(ByVal rhs As Boolean)
   m_Border3DShadowChanged = rhs
End Property

Public Property Get BorderRoundedChanged() As Boolean
   BorderRoundedChanged = m_BorderRoundedChanged
End Property

Public Property Let BorderRoundedChanged(ByVal rhs As Boolean)
   m_BorderRoundedChanged = rhs
End Property

Public Property Get BorderWidthChanged() As Boolean
   BorderWidthChanged = m_BorderWidthChanged
End Property

Public Property Let BorderWidthChanged(ByVal rhs As Boolean)
   m_BorderWidthChanged = rhs
End Property

Public Property Get BorderColorChanged() As Boolean
   BorderColorChanged = m_BorderColorChanged
End Property

Public Property Let BorderColorChanged(ByVal rhs As Boolean)
   m_BorderColorChanged = rhs
End Property

Public Property Get ChartFieldVal1Changed() As Boolean
   ChartFieldVal1Changed = m_ChartFieldVal1Changed
End Property

Public Property Let ChartFieldVal1Changed(ByVal rhs As Boolean)
   m_ChartFieldVal1Changed = rhs
End Property

Public Property Get ChartFieldVal2Changed() As Boolean
   ChartFieldVal2Changed = m_ChartFieldVal2Changed
End Property

Public Property Let ChartFieldVal2Changed(ByVal rhs As Boolean)
   m_ChartFieldVal2Changed = rhs
End Property

Public Property Get ChartFieldLbl1Changed() As Boolean
   ChartFieldLbl1Changed = m_ChartFieldLbl1Changed
End Property

Public Property Let ChartFieldLbl1Changed(ByVal rhs As Boolean)
   m_ChartFieldLbl1Changed = rhs
End Property

Public Property Get ChartFieldGroupChanged() As Boolean
   ChartFieldGroupChanged = m_ChartFieldGroupChanged
End Property

Public Property Let ChartFieldGroupChanged(ByVal rhs As Boolean)
   m_ChartFieldGroupChanged = rhs
End Property

Public Property Get ChartGroupValueChanged() As Boolean
   ChartGroupValueChanged = m_ChartGroupValueChanged
End Property

Public Property Let ChartGroupValueChanged(ByVal rhs As Boolean)
   m_ChartGroupValueChanged = rhs
End Property

Public Property Get ChartFieldLbl2Changed() As Boolean
   ChartFieldLbl2Changed = m_ChartFieldLbl2Changed
End Property

Public Property Let ChartFieldLbl2Changed(ByVal rhs As Boolean)
   m_ChartFieldLbl2Changed = rhs
End Property

Public Property Get ChartSizeChanged() As Boolean
   ChartSizeChanged = m_ChartSizeChanged
End Property

Public Property Let ChartSizeChanged(ByVal rhs As Boolean)
   m_ChartSizeChanged = rhs
End Property

Public Property Get ChartThicknessChanged() As Boolean
   ChartThicknessChanged = m_ChartThicknessChanged
End Property

Public Property Let ChartThicknessChanged(ByVal rhs As Boolean)
   m_ChartThicknessChanged = rhs
End Property

Public Property Get ChartColorSerie1Changed() As Boolean
   ChartColorSerie1Changed = m_ChartColorSerie1Changed
End Property

Public Property Let ChartColorSerie1Changed(ByVal rhs As Boolean)
   m_ChartColorSerie1Changed = rhs
End Property

Public Property Get ChartColorSerie2Changed() As Boolean
   ChartColorSerie2Changed = m_ChartColorSerie2Changed
End Property

Public Property Let ChartColorSerie2Changed(ByVal rhs As Boolean)
   m_ChartColorSerie2Changed = rhs
End Property

Public Property Get ChartFormatTypeChanged() As Boolean
   ChartFormatTypeChanged = m_ChartFormatTypeChanged
End Property

Public Property Let ChartFormatTypeChanged(ByVal rhs As Boolean)
   m_ChartFormatTypeChanged = rhs
End Property

Public Property Get ChartLinesTypeChanged() As Boolean
   ChartLinesTypeChanged = m_ChartLinesTypeChanged
End Property

Public Property Let ChartLinesTypeChanged(ByVal rhs As Boolean)
   m_ChartLinesTypeChanged = rhs
End Property

Public Property Get ChartTypeChanged() As Boolean
   ChartTypeChanged = m_ChartTypeChanged
End Property

Public Property Let ChartTypeChanged(ByVal rhs As Boolean)
   m_ChartTypeChanged = rhs
End Property

Public Property Get ChartShowLinesChanged() As Boolean
   ChartShowLinesChanged = m_ChartShowLinesChanged
End Property

Public Property Let ChartShowLinesChanged(ByVal rhs As Boolean)
   m_ChartShowLinesChanged = rhs
End Property

Public Property Get ChartShowValuesChanged() As Boolean
   ChartShowValuesChanged = m_ChartShowValuesChanged
End Property

Public Property Let ChartShowValuesChanged(ByVal rhs As Boolean)
   m_ChartShowValuesChanged = rhs
End Property

Public Property Get ChartTopChanged() As Boolean
   ChartTopChanged = m_ChartTopChanged
End Property

Public Property Let ChartTopChanged(ByVal rhs As Boolean)
   m_ChartTopChanged = rhs
End Property

Public Property Get ChartSortChanged() As Boolean
   ChartSortChanged = m_ChartSortChanged
End Property

Public Property Let ChartSortChanged(ByVal rhs As Boolean)
   m_ChartSortChanged = rhs
End Property

Public Property Get IsFreeCtrlChanged() As Boolean
   IsFreeCtrlChanged = m_IsFreeCtrlChanged
End Property

Public Property Let IsFreeCtrlChanged(ByVal rhs As Boolean)
   m_IsFreeCtrlChanged = rhs
End Property

Public Property Get ExportColIdxChanged() As Boolean
   ExportColIdxChanged = m_ExportColIdxChanged
End Property

Public Property Let ExportColIdxChanged(ByVal rhs As Boolean)
   m_ExportColIdxChanged = rhs
End Property

' propiedades privadas
' funciones publicas
Public Sub ResetChangedFlags()
  m_TextChanged = False
  m_TagChanged = False
  m_FontChanged = False
  m_ForeColorChanged = False
  m_BackColorChanged = False
  m_FormatChanged = False
  m_LeftChanged = False
  m_TopChanged = False
  m_HeightChanged = False
  m_WidthChanged = False
  m_SymbolChanged = False
  m_TransparentChanged = False
  m_StrikeChanged = False
  m_UnderlineChanged = False
  m_WordWrapChanged = False
  m_ItalicChanged = False
  m_BoldChanged = False
  m_AlignChanged = False
  m_FontSizeChanged = False
  m_CanGrowChanged = False
  m_FormulaHideChanged = False
  m_FormulaValueChanged = False
  m_IdxGroupChanged = False
  m_WhenEvalChanged = False
  m_DbFieldChanged = False
  m_SetFormulaHideChanged = False
  m_SetFormulaValueChanged = False
  m_PictureChanged = False
  m_BorderTypeChanged = False
  m_Border3DChanged = False
  m_Border3DShadowChanged = False
  m_BorderRoundedChanged = False
  m_BorderWidthChanged = False
  m_BorderColorChanged = False
  
  m_ChartFieldGroupChanged = False
  m_ChartFieldLbl1Changed = False
  m_ChartFieldLbl2Changed = False
  m_ChartFieldVal1Changed = False
  m_ChartFieldVal2Changed = False

  m_ChartSizeChanged = False
  m_ChartThicknessChanged = False
  m_ChartColorSerie1Changed = False
  m_ChartColorSerie2Changed = False
  m_ChartFormatTypeChanged = False
  m_ChartLinesTypeChanged = False
  m_ChartTypeChanged = False
  m_ChartShowLinesChanged = False
  m_ChartShowValuesChanged = False
  m_ChartTopChanged = False
  m_ChartTopChanged = False
  
  m_ChartFieldGroupChanged = False
  m_ChartGroupValueChanged = False
  
  m_IsFreeCtrlChanged = False
  m_ExportColIdxChanged = False
  
End Sub

Public Sub HideTabField()
  tabMain.TabVisible(C_Field) = False
End Sub

Public Sub HideTabImage()
  tabMain.TabVisible(C_Image) = False
End Sub

Public Sub HideTabChart()
  tabMain.TabVisible(C_Chart) = False
End Sub

Private Sub cbAlign_Click()
  m_AlignChanged = True
End Sub

Private Sub cbBorderType_Click()
  m_BorderTypeChanged = True
End Sub

Private Sub chkBorderRounded_Click()
  m_BorderRoundedChanged = True
End Sub

Private Sub chkFormulaHide_Click()
  m_SetFormulaHideChanged = True
End Sub

Private Sub chkFormulaValue_Click()
  m_SetFormulaValueChanged = True
End Sub

' funciones privadas
Private Sub cmdAceptar_Click()
  m_Ok = True
  Me.Hide
End Sub

Private Sub cmdCancelar_Click()
  m_Ok = False
  Me.Hide
  RaiseEvent Cancel
End Sub

Private Sub cmdFormulaHide_Click()
  Dim Cancel As Boolean
  m_FormulaName = "Ocultar"
  ShowFormula m_FormulaHide, Cancel
  If Not Cancel Then
    m_FormulaHideChanged = True
    lbFormulaHide.Caption = m_FormulaHide
  End If
End Sub

Private Sub cmdFormulaValue_Click()
  Dim Cancel As Boolean
  m_FormulaName = "Valor"
  ShowFormula m_FormulaValue, Cancel
  If Not Cancel Then
    m_FormulaValueChanged = True
    lbFormulaValue.Caption = m_FormulaValue
  End If
End Sub

Private Sub ShowFormula(ByRef Formula As String, ByRef Cancel As Boolean)
  RaiseEvent ShowEditFormula(Formula, Cancel)
End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
  If UnloadMode <> vbFormCode Then
    Cancel = True
    cmdCancelar_Click
  End If
End Sub

Private Sub Form_Unload(Cancel As Integer)
  Set m_Mouse = Nothing
  RaiseEvent UnloadForm
  ReDim m_ChartFieldType(0)
  ReDim m_ChartIndex(0)
End Sub

Private Sub Label46_Click()

End Sub

Private Sub opAfterPrint_Click()
  m_WhenEvalChanged = True
End Sub

Private Sub opBeforePrint_Click()
  m_WhenEvalChanged = True
End Sub

Private Sub txBorder3D_LostFocus()
  On Error Resume Next
  shBorder3D.BackColor = txBorder3D.csValue
End Sub

Private Sub txBorder3D_ButtonClick(Cancel As Boolean)
  On Error Resume Next
  
  Cancel = True
  
  With CommDialog
    .CancelError = True
    .Color = txBorder3D.csValue
    .Flags = cdlCCRGBInit
    Err.Clear
    .ShowColor
    If Err.Number <> 0 Then Exit Sub
    txBorder3D.Text = .Color
  End With
  
  shBorder3D.BackColor = txBorder3D.csValue
End Sub

Private Sub txBorderColor_LostFocus()
  On Error Resume Next
  shBorderColor.BackColor = txBorderColor.csValue
End Sub

Private Sub txBorderColor_ButtonClick(Cancel As Boolean)
  On Error Resume Next
  
  Cancel = True
  
  With CommDialog
    .CancelError = True
    .Color = txBorderColor.csValue
    .Flags = cdlCCRGBInit
    Err.Clear
    .ShowColor
    If Err.Number <> 0 Then Exit Sub
    txBorderColor.Text = .Color
  End With
  
  shBorderColor.BackColor = txBorderColor.csValue
End Sub

Private Sub txBorderShadow_LostFocus()
  On Error Resume Next
  shBorderShadow.BackColor = txBorderShadow.csValue
End Sub

Private Sub txBorderShadow_ButtonClick(Cancel As Boolean)
  On Error Resume Next
  
  Cancel = True
  
  With CommDialog
    .CancelError = True
    .Color = txBorderShadow.csValue
    .Flags = cdlCCRGBInit
    Err.Clear
    .ShowColor
    If Err.Number <> 0 Then Exit Sub
    txBorderShadow.Text = .Color
  End With
  
  shBorderShadow.BackColor = txBorderShadow.csValue
End Sub

Private Sub txBorderWidth_Change()
  m_BorderWidthChanged = True
End Sub

Private Sub txChartGroupValue_Change()
  m_ChartGroupValueChanged = True
End Sub

Private Sub txChartTop_Change()
  m_ChartTopChanged = True
End Sub

Private Sub TxDbField_ButtonClick(ByRef Cancel As Boolean)
  Cancel = True
  Dim Cancel2 As Boolean
  RaiseEvent ShowHelpDbField(Cancel2)
  If Not Cancel2 Then
    m_DbFieldChanged = True
  End If
End Sub

Private Sub TxDbFieldGroupValue_ButtonClick(Cancel As Boolean)
  Cancel = True
  Dim Cancel2 As Boolean
  RaiseEvent ShowHelpChartGroupField(Cancel2)
  If Not Cancel2 Then
    m_ChartFieldGroupChanged = True
  End If
End Sub

Private Sub TxDbFieldLbl1_ButtonClick(Cancel As Boolean)
  Cancel = True
  Dim Cancel2 As Boolean
  RaiseEvent ShowHelpChartField(Cancel2, TxDbFieldLbl1, 2)
  If Not Cancel2 Then
    m_ChartFieldLbl1Changed = True
  End If
End Sub

Private Sub TxDbFieldLbl2_ButtonClick(Cancel As Boolean)
  Cancel = True
  Dim Cancel2 As Boolean
  RaiseEvent ShowHelpChartField(Cancel2, TxDbFieldLbl2, 3)
  If Not Cancel2 Then
    m_ChartFieldLbl2Changed = True
  End If
End Sub

Private Sub TxDbFieldVal1_ButtonClick(ByRef Cancel As Boolean)
  Cancel = True
  Dim Cancel2 As Boolean
  RaiseEvent ShowHelpChartField(Cancel2, TxDbFieldVal1, 0)
  If Not Cancel2 Then
    m_ChartFieldVal1Changed = True
  End If
End Sub

Private Sub TxDbFieldVal2_ButtonClick(ByRef Cancel As Boolean)
  Cancel = True
  Dim Cancel2 As Boolean
  RaiseEvent ShowHelpChartField(Cancel2, TxDbFieldVal2, 1)
  If Not Cancel2 Then
    m_ChartFieldVal2Changed = True
  End If
End Sub

Private Sub TxForeColor_ButtonClick(ByRef Cancel As Boolean)
  On Error Resume Next
  
  Cancel = True
  
  With CommDialog
    .CancelError = True
    .Color = TxForeColor.csValue
    .Flags = cdlCCRGBInit
    Err.Clear
    .ShowColor
    If Err.Number <> 0 Then Exit Sub
    TxForeColor.Text = .Color
  End With
  
  shForeColor.BackColor = TxForeColor.csValue
End Sub

Private Sub TxForeColor_LostFocus()
  On Error Resume Next
  shForeColor.BackColor = TxForeColor.csValue
End Sub

Private Sub TxBackColor_ButtonClick(ByRef Cancel As Boolean)
  On Error Resume Next
  
  Cancel = True
  With CommDialog
    .CancelError = True
    .Color = TxBackColor.csValue
    Err.Clear
    .ShowColor
    If Err.Number <> 0 Then Exit Sub
    TxBackColor.Text = .Color
  End With
  
  shBackColor.BackColor = TxBackColor.csValue
End Sub

Private Sub TxBackColor_LostFocus()
  On Error Resume Next
  shBackColor.BackColor = TxBackColor.csValue
End Sub

Private Sub TxFont_ButtonClick(ByRef Cancel As Boolean)
  On Error Resume Next
  
  Cancel = True
  With CommDialog
    .CancelError = True
    .Flags = cdlCFBoth Or cdlCFEffects
    .FontName = txFont.Text
    .FontBold = chkFontBold.Value = vbChecked
    .FontItalic = chkFontItalic.Value = vbChecked
    .FontUnderline = chkFontUnderline.Value = vbChecked
    .FontStrikethru = chkFontStrike.Value = vbChecked
    .FontSize = TxFontSize.csValue
    .Color = TxForeColor.csValue
    Err.Clear
    .ShowFont

    If Err.Number <> 0 Then Exit Sub
    
    txFont.Text = .FontName
    chkFontBold.Value = IIf(.FontBold, vbChecked, vbUnchecked)
    chkFontItalic.Value = IIf(.FontItalic, vbChecked, vbUnchecked)
    chkFontUnderline.Value = IIf(.FontUnderline, vbChecked, vbUnchecked)
    chkFontStrike.Value = IIf(.FontStrikethru, vbChecked, vbUnchecked)
    TxFontSize.Text = .FontSize
    TxForeColor.Text = .Color
    
  End With
    
End Sub

' construccion - destruccion
Private Sub Form_Activate()
  On Error Resume Next
  
  If m_Done Then Exit Sub
  m_Done = True
  fProperties.txName.SetFocus
  TxForeColor_LostFocus
  TxBackColor_LostFocus
  
  txBorderColor_LostFocus
  txBorderShadow_LostFocus
  txBorder3D_LostFocus
  
  m_Mouse.MouseSet vbDefault
  lbFormulaHide.Caption = m_FormulaHide
  lbFormulaValue.Caption = m_FormulaValue
End Sub

Private Sub Form_Load()
  m_Done = False
  tabMain.Tab = 0
  CenterForm Me
  m_Ok = False
  Set m_Mouse = New cMouse
  
  With cbAlign
    .Clear
    .AddItem "Izquierda"
    .ItemData(.NewIndex) = AlignmentConstants.vbLeftJustify
    .AddItem "Derecha"
    .ItemData(.NewIndex) = AlignmentConstants.vbRightJustify
    .AddItem "Centro"
    .ItemData(.NewIndex) = AlignmentConstants.vbCenter
  End With
  
  With cbBorderType
    .Clear
    .AddItem "Flat"
    .ItemData(.NewIndex) = CSReportDll2.csReportBorderType.csRptBSFixed
    .AddItem "3D"
    .ItemData(.NewIndex) = CSReportDll2.csReportBorderType.csRptBS3d
    .AddItem "(Ninguno)"
    .ItemData(.NewIndex) = CSReportDll2.csReportBorderType.csRptBSNone
  End With
  
  ReDim m_ChartFieldType(3)
  ReDim m_ChartIndex(3)
  
  InitChart
  
  pSetLbFormulasGroup
  
End Sub

Private Sub TxFormat_ButtonClick(ByRef Cancel As Boolean)
  fFormat.Show vbModal
  
  Cancel = True
  If fFormat.Ok Then
  
    TxFormat.Text = fFormat.sFormat
    txSymbol.Text = fFormat.Symbol
    m_IsAccounting = fFormat.IsAccounting
    
    TxFormat_Change
  End If
  
  Unload fFormat
End Sub

Private Sub TxFormat_Change()
  m_FormatChanged = True
End Sub

Private Sub txHeight_Change()
  m_HeightChanged = True
End Sub

Private Sub txIdxGroup_Change()
  m_IdxGroupChanged = True
End Sub

Private Sub txImageFile_ButtonClick(Cancel As Boolean)
  On Error GoTo ControlError

  Cancel = True
  
  Dim FullFileName As String
  Dim Image As CSReportPaint2.cImage
  Set Image = New CSReportPaint2.cImage
  
  Image.LoadImage Me.CommDialog, picImage, shImage, FullFileName
  
  txImageFile.Text = FullFileName
  
  m_PictureChanged = True

  GoTo ExitProc
ControlError:
  MngError Err, "txImageFile_ButtonClick", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub txLeft_Change()
  m_LeftChanged = True
End Sub

Private Sub txSymbol_Change()
  m_SymbolChanged = True
End Sub

Private Sub txText_Change()
  m_TextChanged = True
End Sub

Private Sub txTag_Change()
  m_TagChanged = True
End Sub

Private Sub txFont_Change()
  m_FontChanged = True
End Sub

Private Sub TxForeColor_Change()
  m_ForeColorChanged = True
End Sub

Private Sub TxBackColor_Change()
  m_BackColorChanged = True
End Sub

Private Sub txTop_Change()
  m_TopChanged = True
End Sub

Private Sub txWidth_Change()
  m_WidthChanged = True
End Sub

Private Sub TxFontSize_Change()
  m_FontSizeChanged = True
End Sub

Private Sub chkFontBold_Click()
  m_BoldChanged = True
End Sub

Private Sub chkCanGrow_Click()
  m_CanGrowChanged = True
End Sub

Private Sub chkFontItalic_Click()
  m_ItalicChanged = True
End Sub

Private Sub chkFontStrike_Click()
  m_StrikeChanged = True
End Sub

Private Sub chkFontUnderline_Click()
  m_UnderlineChanged = True
End Sub

Private Sub chkWordWrap_Click()
  m_WordWrapChanged = True
End Sub

Private Sub chkTransparent_Click()
  m_TransparentChanged = True
End Sub

Private Sub TxBorderColor_Change()
  m_BorderColorChanged = True
End Sub

Private Sub TxBorderShadow_Change()
  m_Border3DShadowChanged = True
End Sub

Private Sub TxBorder3D_Change()
  m_Border3DChanged = True
End Sub

Private Sub chkIsFreeCtrl_Click()
  m_IsFreeCtrlChanged = True
End Sub

Private Sub txExportColIdx_Change()
  m_ExportColIdxChanged = True
End Sub

Private Sub InitChart()
  cbFormatType.AddItem "BMP": cbFormatType.ItemData(cbFormatType.NewIndex) = csRptChartFormat.Bmp
  cbFormatType.AddItem "JPG": cbFormatType.ItemData(cbFormatType.NewIndex) = csRptChartFormat.Jpeg
  cbFormatType.AddItem "GIF": cbFormatType.ItemData(cbFormatType.NewIndex) = csRptChartFormat.Gif
  cbFormatType.AddItem "PNG": cbFormatType.ItemData(cbFormatType.NewIndex) = csRptChartFormat.Png
  cbFormatType.ListIndex = 1
  
  cbType.AddItem "Pie": cbType.ItemData(cbType.NewIndex) = csRptChartType.Pie
  cbType.AddItem "Bar": cbType.ItemData(cbType.NewIndex) = csRptChartType.Bar
  cbType.ListIndex = 0
  
  opLinesYes.Value = True
  opValuesYes.Value = True
  
  pFillColors cbColorSerie1
  cbColorSerie1.ListIndex = 11
  
  pFillColors cbColorSerie2
  cbColorSerie2.ListIndex = 70

  cbChartSize.AddItem "Smallest": cbChartSize.ItemData(cbChartSize.NewIndex) = 50
  cbChartSize.AddItem "Smaller": cbChartSize.ItemData(cbChartSize.NewIndex) = 100
  cbChartSize.AddItem "Small": cbChartSize.ItemData(cbChartSize.NewIndex) = 150
  cbChartSize.AddItem "Medium": cbChartSize.ItemData(cbChartSize.NewIndex) = 200
  cbChartSize.AddItem "Large": cbChartSize.ItemData(cbChartSize.NewIndex) = 250
  cbChartSize.AddItem "Larger": cbChartSize.ItemData(cbChartSize.NewIndex) = 350
  cbChartSize.ListIndex = 4
  
  cbChartThickness.AddItem "None": cbChartThickness.ItemData(cbChartThickness.NewIndex) = 0
  cbChartThickness.AddItem "Wafer": cbChartThickness.ItemData(cbChartThickness.NewIndex) = 2
  cbChartThickness.AddItem "Thin": cbChartThickness.ItemData(cbChartThickness.NewIndex) = 4
  cbChartThickness.AddItem "Medium": cbChartThickness.ItemData(cbChartThickness.NewIndex) = 8
  cbChartThickness.AddItem "Thick": cbChartThickness.ItemData(cbChartThickness.NewIndex) = 16
  cbChartThickness.AddItem "Thickest": cbChartThickness.ItemData(cbChartThickness.NewIndex) = 32
  cbChartThickness.ListIndex = 3
  
  cbLinesType.AddItem "None": cbLinesType.ItemData(cbLinesType.NewIndex) = csRptChartLineStyle.None
  cbLinesType.AddItem "Horizontal": cbLinesType.ItemData(cbLinesType.NewIndex) = csRptChartLineStyle.Horizontal
  cbLinesType.AddItem "Numbered": cbLinesType.ItemData(cbLinesType.NewIndex) = csRptChartLineStyle.Numbered
  cbLinesType.AddItem "Both": cbLinesType.ItemData(cbLinesType.NewIndex) = csRptChartLineStyle.Both
  cbLinesType.ListIndex = 3

End Sub

Private Sub pFillColors(ByVal cbList As ComboBox)
  cbList.AddItem "AliceBlue": cbList.ItemData(cbList.NewIndex) = &HFFF0F8FF
  cbList.AddItem "AntiqueWhite ": cbList.ItemData(cbList.NewIndex) = &HFFFAEBD7
  cbList.AddItem "Aqua ": cbList.ItemData(cbList.NewIndex) = &HFF00FFFF
  cbList.AddItem "Aquamarine ": cbList.ItemData(cbList.NewIndex) = &HFF7FFFD4
  cbList.AddItem "Azure ": cbList.ItemData(cbList.NewIndex) = &HFFF0FFFF
  cbList.AddItem "Beige ": cbList.ItemData(cbList.NewIndex) = &HFFF5F5DC
  cbList.AddItem "Bisque ": cbList.ItemData(cbList.NewIndex) = &HFFFFE4C4
  cbList.AddItem "Black ": cbList.ItemData(cbList.NewIndex) = &HFF000000
  cbList.AddItem "BlanchedAlmond ": cbList.ItemData(cbList.NewIndex) = &HFFFFEBCD
  cbList.AddItem "Blue ": cbList.ItemData(cbList.NewIndex) = &HFF0000FF
  cbList.AddItem "BlueViolet ": cbList.ItemData(cbList.NewIndex) = &HFF8A2BE2
  cbList.AddItem "Brown ": cbList.ItemData(cbList.NewIndex) = &HFFA52A2A
  cbList.AddItem "BurlyWood ": cbList.ItemData(cbList.NewIndex) = &HFFDEB887
  cbList.AddItem "CadetBlue ": cbList.ItemData(cbList.NewIndex) = &HFF5F9EA0
  cbList.AddItem "Chartreuse ": cbList.ItemData(cbList.NewIndex) = &HFF7FFF00
  cbList.AddItem "Chocolate ": cbList.ItemData(cbList.NewIndex) = &HFFD2691E
  cbList.AddItem "Coral ": cbList.ItemData(cbList.NewIndex) = &HFFFF7F50
  cbList.AddItem "CornflowerBlue ": cbList.ItemData(cbList.NewIndex) = &HFF6495ED
  cbList.AddItem "Cornsilk ": cbList.ItemData(cbList.NewIndex) = &HFFFFF8DC
  cbList.AddItem "Crimson ": cbList.ItemData(cbList.NewIndex) = &HFFDC143C
  cbList.AddItem "Cyan ": cbList.ItemData(cbList.NewIndex) = &HFF00FFFF
  cbList.AddItem "DarkBlue ": cbList.ItemData(cbList.NewIndex) = &HFF00008B
  cbList.AddItem "DarkCyan ": cbList.ItemData(cbList.NewIndex) = &HFF008B8B
  cbList.AddItem "DarkGoldenrod ": cbList.ItemData(cbList.NewIndex) = &HFFB8860B
  cbList.AddItem "DarkGray ": cbList.ItemData(cbList.NewIndex) = &HFFA9A9A9
  cbList.AddItem "DarkGreen ": cbList.ItemData(cbList.NewIndex) = &HFF006400
  cbList.AddItem "DarkKhaki ": cbList.ItemData(cbList.NewIndex) = &HFFBDB76B
  cbList.AddItem "DarkMagenta ": cbList.ItemData(cbList.NewIndex) = &HFF8B008B
  cbList.AddItem "DarkOliveGreen ": cbList.ItemData(cbList.NewIndex) = &HFF556B2F
  cbList.AddItem "DarkOrange ": cbList.ItemData(cbList.NewIndex) = &HFFFF8C00
  cbList.AddItem "DarkOrchid ": cbList.ItemData(cbList.NewIndex) = &HFF9932CC
  cbList.AddItem "DarkRed ": cbList.ItemData(cbList.NewIndex) = &HFF8B0000
  cbList.AddItem "DarkSalmon ": cbList.ItemData(cbList.NewIndex) = &HFFE9967A
  cbList.AddItem "DarkSeaGreen ": cbList.ItemData(cbList.NewIndex) = &HFF8FBC8B
  cbList.AddItem "DarkSlateBlue ": cbList.ItemData(cbList.NewIndex) = &HFF483D8B
  cbList.AddItem "DarkSlateGray ": cbList.ItemData(cbList.NewIndex) = &HFF2F4F4F
  cbList.AddItem "DarkTurquoise ": cbList.ItemData(cbList.NewIndex) = &HFF00CED1
  cbList.AddItem "DarkViolet ": cbList.ItemData(cbList.NewIndex) = &HFF9400D3
  cbList.AddItem "DeepPink ": cbList.ItemData(cbList.NewIndex) = &HFFFF1493
  cbList.AddItem "DeepSkyBlue ": cbList.ItemData(cbList.NewIndex) = &HFF00BFFF
  cbList.AddItem "DimGray ": cbList.ItemData(cbList.NewIndex) = &HFF696969
  cbList.AddItem "DodgerBlue ": cbList.ItemData(cbList.NewIndex) = &HFF1E90FF
  cbList.AddItem "Firebrick ": cbList.ItemData(cbList.NewIndex) = &HFFB22222
  cbList.AddItem "FloralWhite ": cbList.ItemData(cbList.NewIndex) = &HFFFFFAF0
  cbList.AddItem "ForestGreen ": cbList.ItemData(cbList.NewIndex) = &HFF228B22
  cbList.AddItem "Fuchsia ": cbList.ItemData(cbList.NewIndex) = &HFFFF00FF
  cbList.AddItem "Gainsboro ": cbList.ItemData(cbList.NewIndex) = &HFFDCDCDC
  cbList.AddItem "GhostWhite ": cbList.ItemData(cbList.NewIndex) = &HFFF8F8FF
  cbList.AddItem "Gold ": cbList.ItemData(cbList.NewIndex) = &HFFFFD700
  cbList.AddItem "Goldenrod ": cbList.ItemData(cbList.NewIndex) = &HFFDAA520
  cbList.AddItem "Gray ": cbList.ItemData(cbList.NewIndex) = &HFF808080
  cbList.AddItem "Green ": cbList.ItemData(cbList.NewIndex) = &HFF008000
  cbList.AddItem "GreenYellow ": cbList.ItemData(cbList.NewIndex) = &HFFADFF2F
  cbList.AddItem "Honeydew ": cbList.ItemData(cbList.NewIndex) = &HFFF0FFF0
  cbList.AddItem "HotPink ": cbList.ItemData(cbList.NewIndex) = &HFFFF69B4
  cbList.AddItem "IndianRed ": cbList.ItemData(cbList.NewIndex) = &HFFCD5C5C
  cbList.AddItem "Indigo ": cbList.ItemData(cbList.NewIndex) = &HFF4B0082
  cbList.AddItem "Ivory ": cbList.ItemData(cbList.NewIndex) = &HFFFFFFF0
  cbList.AddItem "Khaki ": cbList.ItemData(cbList.NewIndex) = &HFFF0E68C
  cbList.AddItem "Lavender ": cbList.ItemData(cbList.NewIndex) = &HFFE6E6FA
  cbList.AddItem "LavenderBlush ": cbList.ItemData(cbList.NewIndex) = &HFFFFF0F5
  cbList.AddItem "LawnGreen ": cbList.ItemData(cbList.NewIndex) = &HFF7CFC00
  cbList.AddItem "LemonChiffon ": cbList.ItemData(cbList.NewIndex) = &HFFFFFACD
  cbList.AddItem "LightBlue ": cbList.ItemData(cbList.NewIndex) = &HFFADD8E6
  cbList.AddItem "LightCoral ": cbList.ItemData(cbList.NewIndex) = &HFFF08080
  cbList.AddItem "LightCyan ": cbList.ItemData(cbList.NewIndex) = &HFFE0FFFF
  cbList.AddItem "LightGoldenrodYellow ": cbList.ItemData(cbList.NewIndex) = &HFFFAFAD2
  cbList.AddItem "LightGray ": cbList.ItemData(cbList.NewIndex) = &HFFD3D3D3
  cbList.AddItem "LightGreen ": cbList.ItemData(cbList.NewIndex) = &HFF90EE90
  cbList.AddItem "LightPink ": cbList.ItemData(cbList.NewIndex) = &HFFFFB6C1
  cbList.AddItem "LightSalmon ": cbList.ItemData(cbList.NewIndex) = &HFFFFA07A
  cbList.AddItem "LightSeaGreen ": cbList.ItemData(cbList.NewIndex) = &HFF20B2AA
  cbList.AddItem "LightSkyBlue ": cbList.ItemData(cbList.NewIndex) = &HFF87CEFA
  cbList.AddItem "LightSlateGray ": cbList.ItemData(cbList.NewIndex) = &HFF778899
  cbList.AddItem "LightSteelBlue ": cbList.ItemData(cbList.NewIndex) = &HFFB0C4DE
  cbList.AddItem "LightYellow ": cbList.ItemData(cbList.NewIndex) = &HFFFFFFE0
  cbList.AddItem "Lime ": cbList.ItemData(cbList.NewIndex) = &HFF00FF00
  cbList.AddItem "LimeGreen ": cbList.ItemData(cbList.NewIndex) = &HFF32CD32
  cbList.AddItem "Linen ": cbList.ItemData(cbList.NewIndex) = &HFFFAF0E6
  cbList.AddItem "Magenta ": cbList.ItemData(cbList.NewIndex) = &HFFFF00FF
  cbList.AddItem "Maroon ": cbList.ItemData(cbList.NewIndex) = &HFF800000
  cbList.AddItem "MediumAquamarine ": cbList.ItemData(cbList.NewIndex) = &HFF66CDAA
  cbList.AddItem "MediumBlue ": cbList.ItemData(cbList.NewIndex) = &HFF0000CD
  cbList.AddItem "MediumOrchid ": cbList.ItemData(cbList.NewIndex) = &HFFBA55D3
  cbList.AddItem "MediumPurple ": cbList.ItemData(cbList.NewIndex) = &HFF9370DB
  cbList.AddItem "MediumSeaGreen ": cbList.ItemData(cbList.NewIndex) = &HFF3CB371
  cbList.AddItem "MediumSlateBlue ": cbList.ItemData(cbList.NewIndex) = &HFF7B68EE
  cbList.AddItem "MediumSpringGreen ": cbList.ItemData(cbList.NewIndex) = &HFF00FA9A
  cbList.AddItem "MediumTurquoise ": cbList.ItemData(cbList.NewIndex) = &HFF48D1CC
  cbList.AddItem "MediumVioletRed ": cbList.ItemData(cbList.NewIndex) = &HFFC71585
  cbList.AddItem "MidnightBlue ": cbList.ItemData(cbList.NewIndex) = &HFF191970
  cbList.AddItem "MintCream ": cbList.ItemData(cbList.NewIndex) = &HFFF5FFFA
  cbList.AddItem "MistyRose ": cbList.ItemData(cbList.NewIndex) = &HFFFFE4E1
  cbList.AddItem "Moccasin ": cbList.ItemData(cbList.NewIndex) = &HFFFFE4B5
  cbList.AddItem "NavajoWhite ": cbList.ItemData(cbList.NewIndex) = &HFFFFDEAD
  cbList.AddItem "Navy ": cbList.ItemData(cbList.NewIndex) = &HFF000080
  cbList.AddItem "OldLace ": cbList.ItemData(cbList.NewIndex) = &HFFFDF5E6
  cbList.AddItem "Olive ": cbList.ItemData(cbList.NewIndex) = &HFF808000
  cbList.AddItem "OliveDrab ": cbList.ItemData(cbList.NewIndex) = &HFF6B8E23
  cbList.AddItem "Orange ": cbList.ItemData(cbList.NewIndex) = &HFFFFA500
  cbList.AddItem "OrangeRed ": cbList.ItemData(cbList.NewIndex) = &HFFFF4500
  cbList.AddItem "Orchid ": cbList.ItemData(cbList.NewIndex) = &HFFDA70D6
  cbList.AddItem "PaleGoldenrod ": cbList.ItemData(cbList.NewIndex) = &HFFEEE8AA
  cbList.AddItem "PaleGreen ": cbList.ItemData(cbList.NewIndex) = &HFF98FB98
  cbList.AddItem "PaleTurquoise ": cbList.ItemData(cbList.NewIndex) = &HFFAFEEEE
  cbList.AddItem "PaleVioletRed ": cbList.ItemData(cbList.NewIndex) = &HFFDB7093
  cbList.AddItem "PapayaWhip ": cbList.ItemData(cbList.NewIndex) = &HFFFFEFD5
  cbList.AddItem "PeachPuff ": cbList.ItemData(cbList.NewIndex) = &HFFFFDAB9
  cbList.AddItem "Peru ": cbList.ItemData(cbList.NewIndex) = &HFFCD853F
  cbList.AddItem "Pink ": cbList.ItemData(cbList.NewIndex) = &HFFFFC0CB
  cbList.AddItem "Plum ": cbList.ItemData(cbList.NewIndex) = &HFFDDA0DD
  cbList.AddItem "PowderBlue ": cbList.ItemData(cbList.NewIndex) = &HFFB0E0E6
  cbList.AddItem "Purple ": cbList.ItemData(cbList.NewIndex) = &HFF800080
  cbList.AddItem "Red ": cbList.ItemData(cbList.NewIndex) = &HFFFF0000
  cbList.AddItem "RosyBrown ": cbList.ItemData(cbList.NewIndex) = &HFFBC8F8F
  cbList.AddItem "RoyalBlue ": cbList.ItemData(cbList.NewIndex) = &HFF4169E1
  cbList.AddItem "SaddleBrown ": cbList.ItemData(cbList.NewIndex) = &HFF8B4513
  cbList.AddItem "Salmon ": cbList.ItemData(cbList.NewIndex) = &HFFFA8072
  cbList.AddItem "SandyBrown ": cbList.ItemData(cbList.NewIndex) = &HFFF4A460
  cbList.AddItem "SeaGreen ": cbList.ItemData(cbList.NewIndex) = &HFF2E8B57
  cbList.AddItem "SeaShell ": cbList.ItemData(cbList.NewIndex) = &HFFFFF5EE
  cbList.AddItem "Sienna ": cbList.ItemData(cbList.NewIndex) = &HFFA0522D
  cbList.AddItem "Silver ": cbList.ItemData(cbList.NewIndex) = &HFFC0C0C0
  cbList.AddItem "SkyBlue ": cbList.ItemData(cbList.NewIndex) = &HFF87CEEB
  cbList.AddItem "SlateBlue ": cbList.ItemData(cbList.NewIndex) = &HFF6A5ACD
  cbList.AddItem "SlateGray ": cbList.ItemData(cbList.NewIndex) = &HFF708090
  cbList.AddItem "Snow ": cbList.ItemData(cbList.NewIndex) = &HFFFFFAFA
  cbList.AddItem "SpringGreen ": cbList.ItemData(cbList.NewIndex) = &HFF00FF7F
  cbList.AddItem "SteelBlue ": cbList.ItemData(cbList.NewIndex) = &HFF4682B4
  cbList.AddItem "Tan ": cbList.ItemData(cbList.NewIndex) = &HFFD2B48C
  cbList.AddItem "Teal ": cbList.ItemData(cbList.NewIndex) = &HFF008080
  cbList.AddItem "Thistle ": cbList.ItemData(cbList.NewIndex) = &HFFD8BFD8
  cbList.AddItem "Tomato ": cbList.ItemData(cbList.NewIndex) = &HFFFF6347
  cbList.AddItem "Transparent ": cbList.ItemData(cbList.NewIndex) = &HFFFFFF
  cbList.AddItem "Turquoise ": cbList.ItemData(cbList.NewIndex) = &HFF40E0D0
  cbList.AddItem "Violet ": cbList.ItemData(cbList.NewIndex) = &HFFEE82EE
  cbList.AddItem "Wheat ": cbList.ItemData(cbList.NewIndex) = &HFFF5DEB3
  cbList.AddItem "White ": cbList.ItemData(cbList.NewIndex) = &HFFFFFFFF
  cbList.AddItem "WhiteSmoke ": cbList.ItemData(cbList.NewIndex) = &HFFF5F5F5
  cbList.AddItem "Yellow ": cbList.ItemData(cbList.NewIndex) = &HFFFFFF00
  cbList.AddItem "YellowGreen ": cbList.ItemData(cbList.NewIndex) = &HFF9ACD32
End Sub
'//////////////////////////////
'  Codigo estandar de errores
'  On Error GoTo ControlError
'
'  GoTo ExitProc
'ControlError:
'  MngError err,"", C_Module, ""
'ExitProc:

'------------------------------------------------------
Private Sub cbChartSize_Click()
  m_ChartSizeChanged = True
End Sub

Private Sub cbChartThickness_Click()
  m_ChartThicknessChanged = True
End Sub

Private Sub cbColorSerie1_Click()
  m_ChartColorSerie1Changed = True
End Sub

Private Sub cbColorSerie2_Click()
  m_ChartColorSerie2Changed = True
End Sub

Private Sub cbFormatType_Click()
  m_ChartFormatTypeChanged = True
End Sub

Private Sub cbLinesType_Click()
  m_ChartLinesTypeChanged = True
End Sub

Private Sub cbType_Click()
  m_ChartTypeChanged = True
End Sub

Private Sub opLinesNo_Click()
  m_ChartShowLinesChanged = True
End Sub

Private Sub opLinesYes_Click()
  m_ChartShowLinesChanged = True
End Sub

Private Sub opValuesNo_Click()
  m_ChartShowValuesChanged = True
End Sub

Private Sub opValuesYes_Click()
  m_ChartShowValuesChanged = True
End Sub

Private Sub chkSort_Click()
  m_ChartSortChanged = True
End Sub

Private Sub pSetLbFormulasGroup()
  lbFormulaIndexId.Caption = _
    "El valor de [Ejecutar solo en el grupo:]" & vbCrLf & _
    "Sale de la siguiente tabla:" & vbCrLf & _
    "-2000 Formulas que estan en los headers y se deben evaluar antes de imprimir la primera linea del detalle" & vbCrLf & _
    "+indice para Formulas que estan en los Group headers" & vbCrLf & _
    "-indice para Formulas que estan en los Group footers" & vbCrLf & _
    "0     Todas las formulas que estan en el detalle" & vbCrLf & _
    "-2001 Formulas que estan en los footers"
End Sub

VERSION 5.00
Object = "{3B008041-905A-11D1-B4AE-444553540000}#1.0#0"; "VSOCX6.OCX"
Object = "{972DE6B5-8B09-11D2-B652-A1FD6CC34260}#1.0#0"; "ACTIVESKIN.OCX"
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Object = "{065E6FD1-1BF9-11D2-BAE8-00104B9E0792}#3.0#0"; "SSA3D30.OCX"
Object = "{CDF3B183-D408-11CE-AE2C-0080C786E37D}#2.1#0"; "EDT32X20.OCX"
Begin VB.Form F_ConfigUsuario 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Propiedades del Puesto"
   ClientHeight    =   4470
   ClientLeft      =   5835
   ClientTop       =   3120
   ClientWidth     =   5595
   FillStyle       =   0  'Solid
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   4470
   ScaleWidth      =   5595
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  'CenterScreen
   Begin ACTIVESKINLibCtl.SkinForm SkinForm1 
      Height          =   480
      Left            =   0
      OleObjectBlob   =   "ConfigUsuario.frx":0000
      TabIndex        =   32
      Top             =   0
      Width           =   480
   End
   Begin vsOcx6LibCtl.vsElastic vsElastic1 
      Height          =   4470
      Left            =   0
      TabIndex        =   0
      TabStop         =   0   'False
      Tag             =   "#c=1;"
      Top             =   0
      Width           =   5595
      _ExtentX        =   9869
      _ExtentY        =   7885
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Enabled         =   -1  'True
      Appearance      =   1
      MousePointer    =   0
      _ConvInfo       =   1
      Version         =   600
      BackColor       =   -2147483633
      ForeColor       =   -2147483630
      FloodColor      =   192
      ForeColorDisabled=   -2147483631
      Caption         =   ""
      Align           =   5
      Appearance      =   1
      AutoSizeChildren=   0
      BorderWidth     =   6
      ChildSpacing    =   4
      Splitter        =   0   'False
      FloodDirection  =   0
      FloodPercent    =   0
      CaptionPos      =   1
      WordWrap        =   -1  'True
      MaxChildSize    =   0
      MinChildSize    =   0
      TagWidth        =   0
      TagPosition     =   0
      Style           =   0
      TagSplit        =   0   'False
      PicturePos      =   4
      CaptionStyle    =   0
      ResizeFonts     =   0   'False
      GridRows        =   0
      GridCols        =   0
      _GridInfo       =   ""
      Begin vsOcx6LibCtl.vsIndexTab VSIndexTab1 
         Height          =   4485
         Left            =   0
         TabIndex        =   17
         Tag             =   "#c=1;"
         Top             =   30
         Width           =   5595
         _ExtentX        =   9869
         _ExtentY        =   7911
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Enabled         =   -1  'True
         Appearance      =   1
         MousePointer    =   0
         _ConvInfo       =   1
         Version         =   600
         BackColor       =   -2147483633
         ForeColor       =   -2147483630
         FrontTabColor   =   -2147483638
         BackTabColor    =   -2147483633
         TabOutlineColor =   12632256
         FrontTabForeColor=   4210752
         Caption         =   "Directorios|Calendario|Explorar|General|Apariencia"
         Align           =   0
         Appearance      =   1
         CurrTab         =   0
         FirstTab        =   0
         Style           =   3
         Position        =   0
         AutoSwitch      =   -1  'True
         AutoScroll      =   -1  'True
         TabPreview      =   -1  'True
         ShowFocusRect   =   -1  'True
         TabsPerPage     =   0
         BorderWidth     =   0
         BoldCurrent     =   0   'False
         DogEars         =   -1  'True
         MultiRow        =   0   'False
         MultiRowOffset  =   200
         CaptionStyle    =   0
         TabHeight       =   0
         Begin vsOcx6LibCtl.vsElastic VideoSoftElastic2 
            Height          =   4110
            Left            =   45
            TabIndex        =   18
            TabStop         =   0   'False
            Top             =   330
            Width           =   5505
            _ExtentX        =   9710
            _ExtentY        =   7250
            BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
               Name            =   "MS Sans Serif"
               Size            =   8.25
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Enabled         =   -1  'True
            Appearance      =   1
            MousePointer    =   0
            _ConvInfo       =   1
            Version         =   600
            BackColor       =   -2147483633
            ForeColor       =   -2147483630
            FloodColor      =   192
            ForeColorDisabled=   -2147483631
            Caption         =   ""
            Align           =   0
            Appearance      =   1
            AutoSizeChildren=   0
            BorderWidth     =   0
            ChildSpacing    =   4
            Splitter        =   0   'False
            FloodDirection  =   0
            FloodPercent    =   0
            CaptionPos      =   1
            WordWrap        =   -1  'True
            MaxChildSize    =   0
            MinChildSize    =   0
            TagWidth        =   0
            TagPosition     =   0
            Style           =   0
            TagSplit        =   0   'False
            PicturePos      =   4
            CaptionStyle    =   0
            ResizeFonts     =   0   'False
            GridRows        =   0
            GridCols        =   0
            _GridInfo       =   ""
            Begin Threed.SSOption O_ConfEmpresa 
               Height          =   285
               Left            =   360
               TabIndex        =   1
               Top             =   90
               Width           =   2085
               _ExtentX        =   3678
               _ExtentY        =   503
               _Version        =   196609
               Caption         =   "Configuración Empresa"
            End
            Begin MSComDlg.CommonDialog CommonDialog1 
               Left            =   0
               Top             =   2640
               _ExtentX        =   847
               _ExtentY        =   847
               _Version        =   393216
            End
            Begin vsOcx6LibCtl.vsElastic vsElastic 
               Height          =   885
               Left            =   135
               TabIndex        =   19
               TabStop         =   0   'False
               Top             =   525
               Width           =   5205
               _ExtentX        =   9181
               _ExtentY        =   1561
               BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
                  Name            =   "MS Sans Serif"
                  Size            =   8.25
                  Charset         =   0
                  Weight          =   400
                  Underline       =   0   'False
                  Italic          =   0   'False
                  Strikethrough   =   0   'False
               EndProperty
               Enabled         =   -1  'True
               Appearance      =   1
               MousePointer    =   0
               _ConvInfo       =   1
               Version         =   600
               BackColor       =   -2147483633
               ForeColor       =   -2147483630
               FloodColor      =   192
               ForeColorDisabled=   -2147483631
               Caption         =   "Directorio de Reportes "
               Align           =   0
               Appearance      =   1
               AutoSizeChildren=   0
               BorderWidth     =   6
               ChildSpacing    =   4
               Splitter        =   0   'False
               FloodDirection  =   0
               FloodPercent    =   0
               CaptionPos      =   1
               WordWrap        =   -1  'True
               MaxChildSize    =   0
               MinChildSize    =   0
               TagWidth        =   0
               TagPosition     =   0
               Style           =   1
               TagSplit        =   0   'False
               PicturePos      =   4
               CaptionStyle    =   0
               ResizeFonts     =   0   'False
               GridRows        =   0
               GridCols        =   0
               _GridInfo       =   ""
               Begin EditLib.fpText Sel_ReportDataPath 
                  Height          =   300
                  Left            =   390
                  TabIndex        =   3
                  Tag             =   "&Cliente :"
                  Top             =   360
                  Width           =   4545
                  _Version        =   131073
                  _ExtentX        =   8017
                  _ExtentY        =   529
                  _StockProps     =   68
                  BackColor       =   -2147483643
                  ForeColor       =   -2147483640
                  ThreeDInsideStyle=   1
                  ThreeDInsideHighlightColor=   -2147483633
                  ThreeDInsideShadowColor=   -2147483642
                  ThreeDInsideWidth=   1
                  ThreeDOutsideStyle=   1
                  ThreeDOutsideHighlightColor=   16777215
                  ThreeDOutsideShadowColor=   -2147483632
                  ThreeDOutsideWidth=   1
                  ThreeDFrameWidth=   0
                  BorderStyle     =   0
                  BorderColor     =   -2147483642
                  BorderWidth     =   1
                  ButtonDisable   =   0   'False
                  ButtonHide      =   0   'False
                  ButtonIncrement =   1
                  ButtonMin       =   0
                  ButtonMax       =   100
                  ButtonStyle     =   3
                  ButtonWidth     =   0
                  ButtonWrap      =   -1  'True
                  ButtonDefaultAction=   -1  'True
                  ThreeDText      =   0
                  ThreeDTextHighlightColor=   -2147483633
                  ThreeDTextShadowColor=   -2147483632
                  ThreeDTextOffset=   1
                  AlignTextH      =   0
                  AlignTextV      =   0
                  AllowNull       =   0   'False
                  NoSpecialKeys   =   0
                  AutoAdvance     =   0   'False
                  AutoBeep        =   0   'False
                  AutoCase        =   0
                  CaretInsert     =   0
                  CaretOverWrite  =   3
                  UserEntry       =   1
                  HideSelection   =   -1  'True
                  InvalidColor    =   -2147483637
                  InvalidOption   =   0
                  MarginLeft      =   3
                  MarginTop       =   3
                  MarginRight     =   3
                  MarginBottom    =   3
                  NullColor       =   -2147483637
                  OnFocusAlignH   =   0
                  OnFocusAlignV   =   0
                  OnFocusNoSelect =   0   'False
                  OnFocusPosition =   0
                  ControlType     =   0
                  Text            =   ""
                  CharValidationText=   ""
                  MaxLength       =   255
                  MultiLine       =   0   'False
                  PasswordChar    =   ""
                  IncHoriz        =   0.25
                  BorderGrayAreaColor=   -2147483637
                  NoPrefix        =   -1  'True
                  ScrollV         =   0   'False
                  ThreeDOnFocusInvert=   0   'False
                  ThreeDFrameColor=   -2147483633
                  Appearance      =   2
                  BorderDropShadow=   0
                  BorderDropShadowColor=   -2147483632
                  BorderDropShadowWidth=   3
                  MouseIcon       =   "ConfigUsuario.frx":00F9
               End
            End
            Begin vsOcx6LibCtl.vsElastic VideoSoftElastic3 
               Height          =   885
               Left            =   90
               TabIndex        =   20
               TabStop         =   0   'False
               Top             =   2505
               Width           =   5235
               _ExtentX        =   9234
               _ExtentY        =   1561
               BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
                  Name            =   "MS Sans Serif"
                  Size            =   8.25
                  Charset         =   0
                  Weight          =   400
                  Underline       =   0   'False
                  Italic          =   0   'False
                  Strikethrough   =   0   'False
               EndProperty
               Enabled         =   -1  'True
               Appearance      =   1
               MousePointer    =   0
               _ConvInfo       =   1
               Version         =   600
               BackColor       =   -2147483633
               ForeColor       =   -2147483630
               FloodColor      =   192
               ForeColorDisabled=   -2147483631
               Caption         =   "Directorio de Exportación"
               Align           =   0
               Appearance      =   1
               AutoSizeChildren=   0
               BorderWidth     =   6
               ChildSpacing    =   4
               Splitter        =   0   'False
               FloodDirection  =   0
               FloodPercent    =   0
               CaptionPos      =   1
               WordWrap        =   -1  'True
               MaxChildSize    =   0
               MinChildSize    =   0
               TagWidth        =   0
               TagPosition     =   0
               Style           =   1
               TagSplit        =   0   'False
               PicturePos      =   4
               CaptionStyle    =   0
               ResizeFonts     =   0   'False
               GridRows        =   0
               GridCols        =   0
               _GridInfo       =   ""
               Begin EditLib.fpText SEL_ExportacionPath 
                  Height          =   300
                  Left            =   390
                  TabIndex        =   5
                  Tag             =   "&Cliente :"
                  Top             =   360
                  Width           =   4545
                  _Version        =   131073
                  _ExtentX        =   8017
                  _ExtentY        =   529
                  _StockProps     =   68
                  BackColor       =   -2147483643
                  ForeColor       =   -2147483640
                  ThreeDInsideStyle=   1
                  ThreeDInsideHighlightColor=   -2147483633
                  ThreeDInsideShadowColor=   -2147483642
                  ThreeDInsideWidth=   1
                  ThreeDOutsideStyle=   1
                  ThreeDOutsideHighlightColor=   16777215
                  ThreeDOutsideShadowColor=   -2147483632
                  ThreeDOutsideWidth=   1
                  ThreeDFrameWidth=   0
                  BorderStyle     =   0
                  BorderColor     =   -2147483642
                  BorderWidth     =   1
                  ButtonDisable   =   0   'False
                  ButtonHide      =   0   'False
                  ButtonIncrement =   1
                  ButtonMin       =   0
                  ButtonMax       =   100
                  ButtonStyle     =   3
                  ButtonWidth     =   0
                  ButtonWrap      =   -1  'True
                  ButtonDefaultAction=   -1  'True
                  ThreeDText      =   0
                  ThreeDTextHighlightColor=   -2147483633
                  ThreeDTextShadowColor=   -2147483632
                  ThreeDTextOffset=   1
                  AlignTextH      =   0
                  AlignTextV      =   0
                  AllowNull       =   0   'False
                  NoSpecialKeys   =   0
                  AutoAdvance     =   0   'False
                  AutoBeep        =   0   'False
                  AutoCase        =   0
                  CaretInsert     =   0
                  CaretOverWrite  =   3
                  UserEntry       =   1
                  HideSelection   =   -1  'True
                  InvalidColor    =   -2147483637
                  InvalidOption   =   0
                  MarginLeft      =   3
                  MarginTop       =   3
                  MarginRight     =   3
                  MarginBottom    =   3
                  NullColor       =   -2147483637
                  OnFocusAlignH   =   0
                  OnFocusAlignV   =   0
                  OnFocusNoSelect =   0   'False
                  OnFocusPosition =   0
                  ControlType     =   0
                  Text            =   ""
                  CharValidationText=   ""
                  MaxLength       =   255
                  MultiLine       =   0   'False
                  PasswordChar    =   ""
                  IncHoriz        =   0.25
                  BorderGrayAreaColor=   -2147483637
                  NoPrefix        =   -1  'True
                  ScrollV         =   0   'False
                  ThreeDOnFocusInvert=   0   'False
                  ThreeDFrameColor=   -2147483633
                  Appearance      =   2
                  BorderDropShadow=   0
                  BorderDropShadowColor=   -2147483632
                  BorderDropShadowWidth=   3
                  MouseIcon       =   "ConfigUsuario.frx":0115
               End
            End
            Begin vsOcx6LibCtl.vsElastic VideoSoftElastic4 
               Height          =   885
               Left            =   120
               TabIndex        =   21
               TabStop         =   0   'False
               Top             =   1515
               Width           =   5205
               _ExtentX        =   9181
               _ExtentY        =   1561
               BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
                  Name            =   "MS Sans Serif"
                  Size            =   8.25
                  Charset         =   0
                  Weight          =   400
                  Underline       =   0   'False
                  Italic          =   0   'False
                  Strikethrough   =   0   'False
               EndProperty
               Enabled         =   -1  'True
               Appearance      =   1
               MousePointer    =   0
               _ConvInfo       =   1
               Version         =   600
               BackColor       =   -2147483633
               ForeColor       =   -2147483630
               FloodColor      =   192
               ForeColorDisabled=   -2147483631
               Caption         =   "Directorio de Reportes de Usuarios"
               Align           =   0
               Appearance      =   1
               AutoSizeChildren=   0
               BorderWidth     =   6
               ChildSpacing    =   4
               Splitter        =   0   'False
               FloodDirection  =   0
               FloodPercent    =   0
               CaptionPos      =   1
               WordWrap        =   -1  'True
               MaxChildSize    =   0
               MinChildSize    =   0
               TagWidth        =   0
               TagPosition     =   0
               Style           =   1
               TagSplit        =   0   'False
               PicturePos      =   4
               CaptionStyle    =   0
               ResizeFonts     =   0   'False
               GridRows        =   0
               GridCols        =   0
               _GridInfo       =   ""
               Begin EditLib.fpText Sel_ReportDataPathUsuario 
                  Height          =   300
                  Left            =   360
                  TabIndex        =   4
                  Tag             =   "&Cliente :"
                  Top             =   360
                  Width           =   4545
                  _Version        =   131073
                  _ExtentX        =   8017
                  _ExtentY        =   529
                  _StockProps     =   68
                  BackColor       =   -2147483643
                  ForeColor       =   -2147483640
                  ThreeDInsideStyle=   1
                  ThreeDInsideHighlightColor=   -2147483633
                  ThreeDInsideShadowColor=   -2147483642
                  ThreeDInsideWidth=   1
                  ThreeDOutsideStyle=   1
                  ThreeDOutsideHighlightColor=   16777215
                  ThreeDOutsideShadowColor=   -2147483632
                  ThreeDOutsideWidth=   1
                  ThreeDFrameWidth=   0
                  BorderStyle     =   0
                  BorderColor     =   -2147483642
                  BorderWidth     =   1
                  ButtonDisable   =   0   'False
                  ButtonHide      =   0   'False
                  ButtonIncrement =   1
                  ButtonMin       =   0
                  ButtonMax       =   100
                  ButtonStyle     =   3
                  ButtonWidth     =   0
                  ButtonWrap      =   -1  'True
                  ButtonDefaultAction=   -1  'True
                  ThreeDText      =   0
                  ThreeDTextHighlightColor=   -2147483633
                  ThreeDTextShadowColor=   -2147483632
                  ThreeDTextOffset=   1
                  AlignTextH      =   0
                  AlignTextV      =   0
                  AllowNull       =   0   'False
                  NoSpecialKeys   =   0
                  AutoAdvance     =   0   'False
                  AutoBeep        =   0   'False
                  AutoCase        =   0
                  CaretInsert     =   0
                  CaretOverWrite  =   3
                  UserEntry       =   1
                  HideSelection   =   -1  'True
                  InvalidColor    =   -2147483637
                  InvalidOption   =   0
                  MarginLeft      =   3
                  MarginTop       =   3
                  MarginRight     =   3
                  MarginBottom    =   3
                  NullColor       =   -2147483637
                  OnFocusAlignH   =   0
                  OnFocusAlignV   =   0
                  OnFocusNoSelect =   0   'False
                  OnFocusPosition =   0
                  ControlType     =   0
                  Text            =   ""
                  CharValidationText=   ""
                  MaxLength       =   255
                  MultiLine       =   0   'False
                  PasswordChar    =   ""
                  IncHoriz        =   0.25
                  BorderGrayAreaColor=   -2147483637
                  NoPrefix        =   -1  'True
                  ScrollV         =   0   'False
                  ThreeDOnFocusInvert=   0   'False
                  ThreeDFrameColor=   -2147483633
                  Appearance      =   2
                  BorderDropShadow=   0
                  BorderDropShadowColor=   -2147483632
                  BorderDropShadowWidth=   3
                  MouseIcon       =   "ConfigUsuario.frx":0131
               End
            End
            Begin Threed.SSCommand Command1 
               Height          =   375
               Left            =   2805
               TabIndex        =   6
               Top             =   3690
               Width           =   1200
               _ExtentX        =   2117
               _ExtentY        =   661
               _Version        =   196609
               Caption         =   "&Aceptar"
            End
            Begin Threed.SSCommand Command2 
               Height          =   375
               Left            =   4125
               TabIndex        =   7
               Top             =   3690
               Width           =   1200
               _ExtentX        =   2117
               _ExtentY        =   661
               _Version        =   196609
               Caption         =   "&Cancelar"
            End
            Begin Threed.SSOption O_ConfUsuario 
               Height          =   285
               Left            =   2655
               TabIndex        =   2
               Top             =   90
               Width           =   1905
               _ExtentX        =   3360
               _ExtentY        =   503
               _Version        =   196609
               Caption         =   "Configuración Usuario"
            End
            Begin VB.Line Line1 
               BorderColor     =   &H00000080&
               X1              =   90
               X2              =   5355
               Y1              =   3600
               Y2              =   3600
            End
         End
         Begin vsOcx6LibCtl.vsElastic VSElastic9 
            Height          =   4110
            Left            =   6240
            TabIndex        =   22
            TabStop         =   0   'False
            Top             =   330
            Width           =   5505
            _ExtentX        =   9710
            _ExtentY        =   7250
            BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
               Name            =   "MS Sans Serif"
               Size            =   8.25
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Enabled         =   -1  'True
            Appearance      =   1
            MousePointer    =   0
            _ConvInfo       =   1
            Version         =   600
            BackColor       =   -2147483633
            ForeColor       =   -2147483630
            FloodColor      =   192
            ForeColorDisabled=   -2147483631
            Caption         =   ""
            Align           =   0
            Appearance      =   1
            AutoSizeChildren=   0
            BorderWidth     =   6
            ChildSpacing    =   4
            Splitter        =   0   'False
            FloodDirection  =   0
            FloodPercent    =   0
            CaptionPos      =   7
            WordWrap        =   -1  'True
            MaxChildSize    =   0
            MinChildSize    =   0
            TagWidth        =   3000
            TagPosition     =   0
            Style           =   0
            TagSplit        =   0   'False
            PicturePos      =   4
            CaptionStyle    =   0
            ResizeFonts     =   0   'False
            GridRows        =   0
            GridCols        =   0
            _GridInfo       =   ""
            Begin VB.ComboBox CB_CA_HeaderStyle 
               Appearance      =   0  'Flat
               Height          =   315
               Left            =   2010
               Style           =   2  'Dropdown List
               TabIndex        =   8
               Tag             =   "&Tipo del encabezado :"
               Top             =   465
               Width           =   2175
            End
            Begin VB.ComboBox CB_CA_MonthHeaderStyle 
               Appearance      =   0  'Flat
               Height          =   315
               Left            =   2010
               Style           =   2  'Dropdown List
               TabIndex        =   9
               Tag             =   "&Encabezado del mes :"
               Top             =   840
               Width           =   2175
            End
            Begin VB.ComboBox CB_CA_YearHeaderStyle 
               Appearance      =   0  'Flat
               Height          =   315
               Left            =   2010
               Style           =   2  'Dropdown List
               TabIndex        =   10
               Tag             =   "E&ncabezado del año :"
               Top             =   1215
               Width           =   2175
            End
            Begin VB.ComboBox CB_CA_WeekDayHdr 
               Appearance      =   0  'Flat
               Height          =   315
               Left            =   2010
               Style           =   2  'Dropdown List
               TabIndex        =   11
               Tag             =   "&Letras de dias :"
               Top             =   1575
               Width           =   2175
            End
            Begin VB.ComboBox CB_CA_FirstDayOfWeek 
               Appearance      =   0  'Flat
               Height          =   315
               Left            =   2010
               Style           =   2  'Dropdown List
               TabIndex        =   12
               Tag             =   "&Primer dia de la semana :"
               Top             =   1965
               Width           =   2175
            End
         End
         Begin vsOcx6LibCtl.vsElastic VSElastic2 
            Height          =   4110
            Left            =   6540
            TabIndex        =   23
            TabStop         =   0   'False
            Top             =   330
            Width           =   5505
            _ExtentX        =   9710
            _ExtentY        =   7250
            BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
               Name            =   "MS Sans Serif"
               Size            =   8.25
               Charset         =   0
               Weight          =   700
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Enabled         =   -1  'True
            Appearance      =   1
            MousePointer    =   0
            _ConvInfo       =   1
            Version         =   600
            BackColor       =   -2147483633
            ForeColor       =   -2147483630
            FloodColor      =   192
            ForeColorDisabled=   -2147483631
            Caption         =   ""
            Align           =   0
            Appearance      =   1
            AutoSizeChildren=   0
            BorderWidth     =   6
            ChildSpacing    =   4
            Splitter        =   0   'False
            FloodDirection  =   0
            FloodPercent    =   0
            CaptionPos      =   1
            WordWrap        =   -1  'True
            MaxChildSize    =   0
            MinChildSize    =   0
            TagWidth        =   0
            TagPosition     =   0
            Style           =   0
            TagSplit        =   0   'False
            PicturePos      =   4
            CaptionStyle    =   0
            ResizeFonts     =   0   'False
            GridRows        =   0
            GridCols        =   0
            _GridInfo       =   ""
            Begin vsOcx6LibCtl.vsElastic VSElastic4 
               Height          =   3015
               Left            =   120
               TabIndex        =   24
               TabStop         =   0   'False
               Top             =   0
               Width           =   5115
               _ExtentX        =   9022
               _ExtentY        =   5318
               BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
                  Name            =   "MS Sans Serif"
                  Size            =   8.25
                  Charset         =   0
                  Weight          =   400
                  Underline       =   0   'False
                  Italic          =   0   'False
                  Strikethrough   =   0   'False
               EndProperty
               Enabled         =   -1  'True
               Appearance      =   1
               MousePointer    =   0
               _ConvInfo       =   1
               Version         =   600
               BackColor       =   -2147483633
               ForeColor       =   -2147483630
               FloodColor      =   192
               ForeColorDisabled=   -2147483631
               Caption         =   "Opciones de exploración"
               Align           =   0
               Appearance      =   1
               AutoSizeChildren=   0
               BorderWidth     =   6
               ChildSpacing    =   4
               Splitter        =   0   'False
               FloodDirection  =   0
               FloodPercent    =   0
               CaptionPos      =   1
               WordWrap        =   -1  'True
               MaxChildSize    =   0
               MinChildSize    =   0
               TagWidth        =   0
               TagPosition     =   0
               Style           =   1
               TagSplit        =   0   'False
               PicturePos      =   4
               CaptionStyle    =   0
               ResizeFonts     =   0   'False
               GridRows        =   0
               GridCols        =   0
               _GridInfo       =   ""
               Begin VB.PictureBox Picture1 
                  Appearance      =   0  'Flat
                  AutoRedraw      =   -1  'True
                  AutoSize        =   -1  'True
                  BackColor       =   &H00C0C0C0&
                  BorderStyle     =   0  'None
                  DrawStyle       =   5  'Transparent
                  ForeColor       =   &H80000008&
                  Height          =   600
                  Left            =   1680
                  Picture         =   "ConfigUsuario.frx":014D
                  ScaleHeight     =   600
                  ScaleWidth      =   600
                  TabIndex        =   26
                  Top             =   720
                  Width           =   600
               End
               Begin VB.PictureBox Picture2 
                  Appearance      =   0  'Flat
                  AutoRedraw      =   -1  'True
                  BackColor       =   &H8000000C&
                  BorderStyle     =   0  'None
                  DrawStyle       =   5  'Transparent
                  ForeColor       =   &H80000008&
                  Height          =   480
                  Left            =   1680
                  Picture         =   "ConfigUsuario.frx":144F
                  ScaleHeight     =   480
                  ScaleWidth      =   660
                  TabIndex        =   25
                  Top             =   1800
                  Width           =   660
               End
               Begin Threed.SSCheck CHECK_ExpandirArboles 
                  Height          =   270
                  Left            =   360
                  TabIndex        =   15
                  Top             =   2610
                  Width           =   2400
                  _ExtentX        =   4233
                  _ExtentY        =   476
                  _Version        =   196609
                  BackStyle       =   1
                  BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
                     Name            =   "MS Sans Serif"
                     Size            =   8.25
                     Charset         =   0
                     Weight          =   400
                     Underline       =   0   'False
                     Italic          =   0   'False
                     Strikethrough   =   0   'False
                  EndProperty
                  Caption         =   "&Expandir los Arboles"
               End
               Begin Threed.SSOption O_Multiwindow 
                  Height          =   315
                  Left            =   360
                  TabIndex        =   13
                  Top             =   360
                  Width           =   3600
                  _ExtentX        =   6350
                  _ExtentY        =   556
                  _Version        =   196609
                  BackStyle       =   1
                  BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
                     Name            =   "MS Sans Serif"
                     Size            =   8.25
                     Charset         =   0
                     Weight          =   400
                     Underline       =   0   'False
                     Italic          =   0   'False
                     Strikethrough   =   0   'False
                  EndProperty
                  Caption         =   "&Explorar ventanas usando varias ventanas"
                  Value           =   -1
               End
               Begin Threed.SSOption O_Onlywindow 
                  Height          =   315
                  Left            =   360
                  TabIndex        =   14
                  Top             =   1440
                  Width           =   3600
                  _ExtentX        =   6350
                  _ExtentY        =   556
                  _Version        =   196609
                  BackStyle       =   1
                  BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
                     Name            =   "MS Sans Serif"
                     Size            =   8.25
                     Charset         =   0
                     Weight          =   400
                     Underline       =   0   'False
                     Italic          =   0   'False
                     Strikethrough   =   0   'False
                  EndProperty
                  Caption         =   "E&xplorar ventanas usando una sola ventana"
               End
            End
         End
         Begin vsOcx6LibCtl.vsElastic VideoSoftElastic1 
            Height          =   4110
            Left            =   6840
            TabIndex        =   27
            TabStop         =   0   'False
            Top             =   330
            Width           =   5505
            _ExtentX        =   9710
            _ExtentY        =   7250
            BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
               Name            =   "MS Sans Serif"
               Size            =   8.25
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Enabled         =   -1  'True
            Appearance      =   1
            MousePointer    =   0
            _ConvInfo       =   1
            Version         =   600
            BackColor       =   -2147483633
            ForeColor       =   -2147483630
            FloodColor      =   192
            ForeColorDisabled=   -2147483631
            Caption         =   ""
            Align           =   0
            Appearance      =   1
            AutoSizeChildren=   0
            BorderWidth     =   6
            ChildSpacing    =   4
            Splitter        =   0   'False
            FloodDirection  =   0
            FloodPercent    =   0
            CaptionPos      =   7
            WordWrap        =   -1  'True
            MaxChildSize    =   0
            MinChildSize    =   0
            TagWidth        =   3000
            TagPosition     =   0
            Style           =   0
            TagSplit        =   0   'False
            PicturePos      =   4
            CaptionStyle    =   0
            ResizeFonts     =   0   'False
            GridRows        =   0
            GridCols        =   0
            _GridInfo       =   ""
            Begin EditLib.fpDoubleSingle TB_Minutos 
               Height          =   315
               Left            =   2640
               TabIndex        =   16
               Tag             =   "Tiempo de espera de servidor:"
               Top             =   1800
               Width           =   615
               _Version        =   131073
               _ExtentX        =   1085
               _ExtentY        =   556
               _StockProps     =   68
               BackColor       =   -2147483643
               ForeColor       =   -2147483640
               ThreeDInsideStyle=   1
               ThreeDInsideHighlightColor=   -2147483633
               ThreeDInsideShadowColor=   -2147483642
               ThreeDInsideWidth=   1
               ThreeDOutsideStyle=   1
               ThreeDOutsideHighlightColor=   16777215
               ThreeDOutsideShadowColor=   -2147483632
               ThreeDOutsideWidth=   1
               ThreeDFrameWidth=   0
               BorderStyle     =   0
               BorderColor     =   -2147483642
               BorderWidth     =   1
               ButtonDisable   =   0   'False
               ButtonHide      =   0   'False
               ButtonIncrement =   1
               ButtonMin       =   0
               ButtonMax       =   100
               ButtonStyle     =   0
               ButtonWidth     =   0
               ButtonWrap      =   -1  'True
               ButtonDefaultAction=   -1  'True
               ThreeDText      =   0
               ThreeDTextHighlightColor=   -2147483633
               ThreeDTextShadowColor=   -2147483632
               ThreeDTextOffset=   1
               AlignTextH      =   2
               AlignTextV      =   0
               AllowNull       =   0   'False
               NoSpecialKeys   =   0
               AutoAdvance     =   0   'False
               AutoBeep        =   0   'False
               CaretInsert     =   0
               CaretOverWrite  =   3
               UserEntry       =   0
               HideSelection   =   -1  'True
               InvalidColor    =   -2147483637
               InvalidOption   =   0
               MarginLeft      =   3
               MarginTop       =   3
               MarginRight     =   3
               MarginBottom    =   3
               NullColor       =   -2147483637
               OnFocusAlignH   =   0
               OnFocusAlignV   =   0
               OnFocusNoSelect =   0   'False
               OnFocusPosition =   0
               ControlType     =   0
               Text            =   "0"
               DecimalPlaces   =   -1
               DecimalPoint    =   ""
               FixedPoint      =   0   'False
               LeadZero        =   0
               MaxValue        =   "9000000000"
               MinValue        =   "0"
               NegFormat       =   1
               NegToggle       =   0   'False
               Separator       =   ""
               UseSeparator    =   0   'False
               IncInt          =   1
               IncDec          =   1
               BorderGrayAreaColor=   -2147483637
               ThreeDOnFocusInvert=   0   'False
               ThreeDFrameColor=   -2147483633
               Appearance      =   2
               BorderDropShadow=   0
               BorderDropShadowColor=   -2147483632
               BorderDropShadowWidth=   3
               MouseIcon       =   "ConfigUsuario.frx":2511
            End
            Begin vsOcx6LibCtl.vsElastic vsElastic3 
               Height          =   375
               Left            =   3330
               TabIndex        =   28
               TabStop         =   0   'False
               Top             =   1800
               Width           =   1125
               _ExtentX        =   1984
               _ExtentY        =   661
               BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
                  Name            =   "MS Sans Serif"
                  Size            =   8.25
                  Charset         =   0
                  Weight          =   400
                  Underline       =   0   'False
                  Italic          =   0   'False
                  Strikethrough   =   0   'False
               EndProperty
               Enabled         =   -1  'True
               Appearance      =   1
               MousePointer    =   0
               _ConvInfo       =   1
               Version         =   600
               BackColor       =   -2147483633
               ForeColor       =   -2147483630
               FloodColor      =   192
               ForeColorDisabled=   -2147483631
               Caption         =   ""
               Align           =   0
               Appearance      =   1
               AutoSizeChildren=   0
               BorderWidth     =   6
               ChildSpacing    =   4
               Splitter        =   0   'False
               FloodDirection  =   0
               FloodPercent    =   0
               CaptionPos      =   1
               WordWrap        =   -1  'True
               MaxChildSize    =   0
               MinChildSize    =   0
               TagWidth        =   0
               TagPosition     =   0
               Style           =   0
               TagSplit        =   0   'False
               PicturePos      =   4
               CaptionStyle    =   0
               ResizeFonts     =   0   'False
               GridRows        =   0
               GridCols        =   0
               _GridInfo       =   ""
               Begin VB.Label Label2 
                  Caption         =   "Minutos"
                  Height          =   255
                  Left            =   90
                  TabIndex        =   29
                  Tag             =   "#borde=1;"
                  Top             =   60
                  Width           =   855
               End
            End
            Begin Threed.SSCheck CHK_MailAutomaticoOnError 
               Height          =   450
               Left            =   540
               TabIndex        =   30
               Top             =   630
               Width           =   240
               _ExtentX        =   423
               _ExtentY        =   794
               _Version        =   196609
               BackStyle       =   1
               BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
                  Name            =   "MS Sans Serif"
                  Size            =   8.25
                  Charset         =   0
                  Weight          =   400
                  Underline       =   0   'False
                  Italic          =   0   'False
                  Strikethrough   =   0   'False
               EndProperty
            End
            Begin VB.Label Label1 
               Caption         =   "Mail automatico para el envio de sugerencias y o  detección de errores"
               Height          =   495
               Left            =   900
               TabIndex        =   31
               Tag             =   " "
               Top             =   750
               Width           =   3735
            End
         End
         Begin vsOcx6LibCtl.vsElastic VideoSoftElastic10 
            Height          =   4110
            Left            =   7140
            TabIndex        =   33
            TabStop         =   0   'False
            Top             =   330
            Width           =   5505
            _ExtentX        =   9710
            _ExtentY        =   7250
            BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
               Name            =   "MS Sans Serif"
               Size            =   8.25
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Enabled         =   -1  'True
            Appearance      =   1
            MousePointer    =   0
            _ConvInfo       =   1
            Version         =   600
            BackColor       =   -2147483633
            ForeColor       =   -2147483630
            FloodColor      =   192
            ForeColorDisabled=   -2147483631
            Caption         =   ""
            Align           =   0
            Appearance      =   1
            AutoSizeChildren=   0
            BorderWidth     =   0
            ChildSpacing    =   4
            Splitter        =   0   'False
            FloodDirection  =   0
            FloodPercent    =   0
            CaptionPos      =   1
            WordWrap        =   -1  'True
            MaxChildSize    =   0
            MinChildSize    =   0
            TagWidth        =   0
            TagPosition     =   0
            Style           =   0
            TagSplit        =   0   'False
            PicturePos      =   4
            CaptionStyle    =   0
            ResizeFonts     =   0   'False
            GridRows        =   0
            GridCols        =   0
            _GridInfo       =   ""
            Begin vsOcx6LibCtl.vsElastic vsElastic5 
               Height          =   885
               Left            =   135
               TabIndex        =   34
               TabStop         =   0   'False
               Top             =   210
               Width           =   5205
               _ExtentX        =   9181
               _ExtentY        =   1561
               BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
                  Name            =   "MS Sans Serif"
                  Size            =   8.25
                  Charset         =   0
                  Weight          =   400
                  Underline       =   0   'False
                  Italic          =   0   'False
                  Strikethrough   =   0   'False
               EndProperty
               Enabled         =   -1  'True
               Appearance      =   1
               MousePointer    =   0
               _ConvInfo       =   1
               Version         =   600
               BackColor       =   -2147483633
               ForeColor       =   -2147483630
               FloodColor      =   192
               ForeColorDisabled=   -2147483631
               Caption         =   "Ventana principal"
               Align           =   0
               Appearance      =   1
               AutoSizeChildren=   0
               BorderWidth     =   6
               ChildSpacing    =   4
               Splitter        =   0   'False
               FloodDirection  =   0
               FloodPercent    =   0
               CaptionPos      =   1
               WordWrap        =   -1  'True
               MaxChildSize    =   0
               MinChildSize    =   0
               TagWidth        =   0
               TagPosition     =   0
               Style           =   1
               TagSplit        =   0   'False
               PicturePos      =   4
               CaptionStyle    =   0
               ResizeFonts     =   0   'False
               GridRows        =   0
               GridCols        =   0
               _GridInfo       =   ""
               Begin EditLib.fpText SEL_Skin_VentanaPrincipal 
                  Height          =   300
                  Left            =   390
                  TabIndex        =   35
                  Tag             =   "&Cliente :"
                  Top             =   360
                  Width           =   4545
                  _Version        =   131073
                  _ExtentX        =   8017
                  _ExtentY        =   529
                  _StockProps     =   68
                  BackColor       =   -2147483643
                  ForeColor       =   -2147483640
                  ThreeDInsideStyle=   1
                  ThreeDInsideHighlightColor=   -2147483633
                  ThreeDInsideShadowColor=   -2147483642
                  ThreeDInsideWidth=   1
                  ThreeDOutsideStyle=   1
                  ThreeDOutsideHighlightColor=   16777215
                  ThreeDOutsideShadowColor=   -2147483632
                  ThreeDOutsideWidth=   1
                  ThreeDFrameWidth=   0
                  BorderStyle     =   0
                  BorderColor     =   -2147483642
                  BorderWidth     =   1
                  ButtonDisable   =   0   'False
                  ButtonHide      =   0   'False
                  ButtonIncrement =   1
                  ButtonMin       =   0
                  ButtonMax       =   100
                  ButtonStyle     =   3
                  ButtonWidth     =   0
                  ButtonWrap      =   -1  'True
                  ButtonDefaultAction=   -1  'True
                  ThreeDText      =   0
                  ThreeDTextHighlightColor=   -2147483633
                  ThreeDTextShadowColor=   -2147483632
                  ThreeDTextOffset=   1
                  AlignTextH      =   0
                  AlignTextV      =   0
                  AllowNull       =   0   'False
                  NoSpecialKeys   =   0
                  AutoAdvance     =   0   'False
                  AutoBeep        =   0   'False
                  AutoCase        =   0
                  CaretInsert     =   0
                  CaretOverWrite  =   3
                  UserEntry       =   1
                  HideSelection   =   -1  'True
                  InvalidColor    =   -2147483637
                  InvalidOption   =   0
                  MarginLeft      =   3
                  MarginTop       =   3
                  MarginRight     =   3
                  MarginBottom    =   3
                  NullColor       =   -2147483637
                  OnFocusAlignH   =   0
                  OnFocusAlignV   =   0
                  OnFocusNoSelect =   0   'False
                  OnFocusPosition =   0
                  ControlType     =   0
                  Text            =   ""
                  CharValidationText=   ""
                  MaxLength       =   255
                  MultiLine       =   0   'False
                  PasswordChar    =   ""
                  IncHoriz        =   0.25
                  BorderGrayAreaColor=   -2147483637
                  NoPrefix        =   -1  'True
                  ScrollV         =   0   'False
                  ThreeDOnFocusInvert=   0   'False
                  ThreeDFrameColor=   -2147483633
                  Appearance      =   2
                  BorderDropShadow=   0
                  BorderDropShadowColor=   -2147483632
                  BorderDropShadowWidth=   3
                  MouseIcon       =   "ConfigUsuario.frx":252D
               End
            End
            Begin vsOcx6LibCtl.vsElastic vsElastic6 
               Height          =   885
               Left            =   90
               TabIndex        =   36
               TabStop         =   0   'False
               Top             =   2190
               Width           =   5235
               _ExtentX        =   9234
               _ExtentY        =   1561
               BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
                  Name            =   "MS Sans Serif"
                  Size            =   8.25
                  Charset         =   0
                  Weight          =   400
                  Underline       =   0   'False
                  Italic          =   0   'False
                  Strikethrough   =   0   'False
               EndProperty
               Enabled         =   -1  'True
               Appearance      =   1
               MousePointer    =   0
               _ConvInfo       =   1
               Version         =   600
               BackColor       =   -2147483633
               ForeColor       =   -2147483630
               FloodColor      =   192
               ForeColorDisabled=   -2147483631
               Caption         =   "Ventanas de edición de documentos"
               Align           =   0
               Appearance      =   1
               AutoSizeChildren=   0
               BorderWidth     =   6
               ChildSpacing    =   4
               Splitter        =   0   'False
               FloodDirection  =   0
               FloodPercent    =   0
               CaptionPos      =   1
               WordWrap        =   -1  'True
               MaxChildSize    =   0
               MinChildSize    =   0
               TagWidth        =   0
               TagPosition     =   0
               Style           =   1
               TagSplit        =   0   'False
               PicturePos      =   4
               CaptionStyle    =   0
               ResizeFonts     =   0   'False
               GridRows        =   0
               GridCols        =   0
               _GridInfo       =   ""
               Begin EditLib.fpText SEL_Skin_VentanaDocumento 
                  Height          =   300
                  Left            =   390
                  TabIndex        =   37
                  Tag             =   "&Cliente :"
                  Top             =   360
                  Width           =   4545
                  _Version        =   131073
                  _ExtentX        =   8017
                  _ExtentY        =   529
                  _StockProps     =   68
                  BackColor       =   -2147483643
                  ForeColor       =   -2147483640
                  ThreeDInsideStyle=   1
                  ThreeDInsideHighlightColor=   -2147483633
                  ThreeDInsideShadowColor=   -2147483642
                  ThreeDInsideWidth=   1
                  ThreeDOutsideStyle=   1
                  ThreeDOutsideHighlightColor=   16777215
                  ThreeDOutsideShadowColor=   -2147483632
                  ThreeDOutsideWidth=   1
                  ThreeDFrameWidth=   0
                  BorderStyle     =   0
                  BorderColor     =   -2147483642
                  BorderWidth     =   1
                  ButtonDisable   =   0   'False
                  ButtonHide      =   0   'False
                  ButtonIncrement =   1
                  ButtonMin       =   0
                  ButtonMax       =   100
                  ButtonStyle     =   3
                  ButtonWidth     =   0
                  ButtonWrap      =   -1  'True
                  ButtonDefaultAction=   -1  'True
                  ThreeDText      =   0
                  ThreeDTextHighlightColor=   -2147483633
                  ThreeDTextShadowColor=   -2147483632
                  ThreeDTextOffset=   1
                  AlignTextH      =   0
                  AlignTextV      =   0
                  AllowNull       =   0   'False
                  NoSpecialKeys   =   0
                  AutoAdvance     =   0   'False
                  AutoBeep        =   0   'False
                  AutoCase        =   0
                  CaretInsert     =   0
                  CaretOverWrite  =   3
                  UserEntry       =   1
                  HideSelection   =   -1  'True
                  InvalidColor    =   -2147483637
                  InvalidOption   =   0
                  MarginLeft      =   3
                  MarginTop       =   3
                  MarginRight     =   3
                  MarginBottom    =   3
                  NullColor       =   -2147483637
                  OnFocusAlignH   =   0
                  OnFocusAlignV   =   0
                  OnFocusNoSelect =   0   'False
                  OnFocusPosition =   0
                  ControlType     =   0
                  Text            =   ""
                  CharValidationText=   ""
                  MaxLength       =   255
                  MultiLine       =   0   'False
                  PasswordChar    =   ""
                  IncHoriz        =   0.25
                  BorderGrayAreaColor=   -2147483637
                  NoPrefix        =   -1  'True
                  ScrollV         =   0   'False
                  ThreeDOnFocusInvert=   0   'False
                  ThreeDFrameColor=   -2147483633
                  Appearance      =   2
                  BorderDropShadow=   0
                  BorderDropShadowColor=   -2147483632
                  BorderDropShadowWidth=   3
                  MouseIcon       =   "ConfigUsuario.frx":2549
               End
            End
            Begin vsOcx6LibCtl.vsElastic vsElastic7 
               Height          =   885
               Left            =   120
               TabIndex        =   38
               TabStop         =   0   'False
               Top             =   1200
               Width           =   5205
               _ExtentX        =   9181
               _ExtentY        =   1561
               BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
                  Name            =   "MS Sans Serif"
                  Size            =   8.25
                  Charset         =   0
                  Weight          =   400
                  Underline       =   0   'False
                  Italic          =   0   'False
                  Strikethrough   =   0   'False
               EndProperty
               Enabled         =   -1  'True
               Appearance      =   1
               MousePointer    =   0
               _ConvInfo       =   1
               Version         =   600
               BackColor       =   -2147483633
               ForeColor       =   -2147483630
               FloodColor      =   192
               ForeColorDisabled=   -2147483631
               Caption         =   "Barra de exploración"
               Align           =   0
               Appearance      =   1
               AutoSizeChildren=   0
               BorderWidth     =   6
               ChildSpacing    =   4
               Splitter        =   0   'False
               FloodDirection  =   0
               FloodPercent    =   0
               CaptionPos      =   1
               WordWrap        =   -1  'True
               MaxChildSize    =   0
               MinChildSize    =   0
               TagWidth        =   0
               TagPosition     =   0
               Style           =   1
               TagSplit        =   0   'False
               PicturePos      =   4
               CaptionStyle    =   0
               ResizeFonts     =   0   'False
               GridRows        =   0
               GridCols        =   0
               _GridInfo       =   ""
               Begin EditLib.fpText SEL_Skin_BarraExploracion 
                  Height          =   300
                  Left            =   360
                  TabIndex        =   39
                  Tag             =   "&Cliente :"
                  Top             =   360
                  Width           =   4545
                  _Version        =   131073
                  _ExtentX        =   8017
                  _ExtentY        =   529
                  _StockProps     =   68
                  BackColor       =   -2147483643
                  ForeColor       =   -2147483640
                  ThreeDInsideStyle=   1
                  ThreeDInsideHighlightColor=   -2147483633
                  ThreeDInsideShadowColor=   -2147483642
                  ThreeDInsideWidth=   1
                  ThreeDOutsideStyle=   1
                  ThreeDOutsideHighlightColor=   16777215
                  ThreeDOutsideShadowColor=   -2147483632
                  ThreeDOutsideWidth=   1
                  ThreeDFrameWidth=   0
                  BorderStyle     =   0
                  BorderColor     =   -2147483642
                  BorderWidth     =   1
                  ButtonDisable   =   0   'False
                  ButtonHide      =   0   'False
                  ButtonIncrement =   1
                  ButtonMin       =   0
                  ButtonMax       =   100
                  ButtonStyle     =   3
                  ButtonWidth     =   0
                  ButtonWrap      =   -1  'True
                  ButtonDefaultAction=   -1  'True
                  ThreeDText      =   0
                  ThreeDTextHighlightColor=   -2147483633
                  ThreeDTextShadowColor=   -2147483632
                  ThreeDTextOffset=   1
                  AlignTextH      =   0
                  AlignTextV      =   0
                  AllowNull       =   0   'False
                  NoSpecialKeys   =   0
                  AutoAdvance     =   0   'False
                  AutoBeep        =   0   'False
                  AutoCase        =   0
                  CaretInsert     =   0
                  CaretOverWrite  =   3
                  UserEntry       =   1
                  HideSelection   =   -1  'True
                  InvalidColor    =   -2147483637
                  InvalidOption   =   0
                  MarginLeft      =   3
                  MarginTop       =   3
                  MarginRight     =   3
                  MarginBottom    =   3
                  NullColor       =   -2147483637
                  OnFocusAlignH   =   0
                  OnFocusAlignV   =   0
                  OnFocusNoSelect =   0   'False
                  OnFocusPosition =   0
                  ControlType     =   0
                  Text            =   ""
                  CharValidationText=   ""
                  MaxLength       =   255
                  MultiLine       =   0   'False
                  PasswordChar    =   ""
                  IncHoriz        =   0.25
                  BorderGrayAreaColor=   -2147483637
                  NoPrefix        =   -1  'True
                  ScrollV         =   0   'False
                  ThreeDOnFocusInvert=   0   'False
                  ThreeDFrameColor=   -2147483633
                  Appearance      =   2
                  BorderDropShadow=   0
                  BorderDropShadowColor=   -2147483632
                  BorderDropShadowWidth=   3
                  MouseIcon       =   "ConfigUsuario.frx":2565
               End
            End
            Begin Threed.SSCommand Cmd_SkinAceptar 
               Default         =   -1  'True
               Height          =   375
               Left            =   2805
               TabIndex        =   40
               Top             =   3690
               Width           =   1200
               _ExtentX        =   2117
               _ExtentY        =   661
               _Version        =   196609
               Caption         =   "&Aceptar"
            End
            Begin Threed.SSCommand Cmd_SkinCancelar 
               Height          =   375
               Left            =   4125
               TabIndex        =   41
               Top             =   3690
               Width           =   1200
               _ExtentX        =   2117
               _ExtentY        =   661
               _Version        =   196609
               Caption         =   "&Cancelar"
            End
            Begin VB.Line Line2 
               BorderColor     =   &H00000080&
               X1              =   90
               X2              =   5355
               Y1              =   3600
               Y2              =   3600
            End
         End
      End
   End
End
Attribute VB_Name = "F_ConfigUsuario"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit


Private Sub Command1_Click()
  On Error GoTo FailSafe_Error


  If Vacio(Sel_ReportDataPath.Text) Then
    ScWarning ("El Directorio de reportes no puede estar vacio")
    VSIndexTab1.CurrTab = 3 ' tab inicio
    Sel_ReportDataPath.SetFocus

  Else
    Guardar
    Unload Me
  End If

  FailSafe_Exit:
  Exit Sub
  FailSafe_Error:
  ScShowError "Sub Command1_Click", vbCritical
  Resume FailSafe_Exit
End Sub


Private Sub Command2_Click()
  On Error GoTo FailSafe_Error

  Unload Me
  FailSafe_Exit:
  Exit Sub
  FailSafe_Error:
  ScShowError "Sub Command2_Click", vbCritical
  Resume FailSafe_Exit
End Sub


Private Sub Guardar()
  On Error GoTo FailSafe_Error

  'Edicion
  MousePointer = 11
  '  SaveIniString "Sonido", Trim(Check_Sonido.Value)
  '  SaveIniString "GuardarPosicion", Trim(Check_GuardarPosicion.Value)
  SaveIniString "MailAutomaticoOnError", CHK_MailAutomaticoOnError.Value
  GuardarFecha
  'calendario
  GuardarCalendarioTab
  'exploracion
  SaveIniString "MultiplesVentanas", Trim(O_Multiwindow.Value)
  SaveIniString "ExpandirArboles", Trim(CHECK_ExpandirArboles.Value)
  'Reportes

  If O_ConfEmpresa.Value = True Then
    SaveIniString G_User & "ReportDataPath", ""

  Else
    SaveIniString G_User & "ReportDataPath", Sel_ReportDataPath.Text
  End If

  G_ReportDatapath = Sel_ReportDataPath.Text

  If O_ConfEmpresa.Value = True Then
    SaveIniString G_User & "ReportDataPathUsuario", ""

  Else
    SaveIniString G_User & "ReportDataPathUsuario", Sel_ReportDataPathUsuario.Text
  End If

  G_ReportDataPathUsuario = Sel_ReportDataPathUsuario.Text
  'exportacion

  If O_ConfEmpresa.Value = True Then
    SaveIniString G_User & "ExportacionPath", ""

  Else
    SaveIniString G_User & "ExportacionPath", SEL_ExportacionPath.Text
  End If

  G_ExportacionPath = SEL_ExportacionPath.Text
  'Time Out
  SaveIniString "TimeOut", TB_Minutos.Text
  G_TimeOut = TB_Minutos.Text
  MyDb.QueryTimeout = Val(G_TimeOut) * 60
  'restauro la Configuración
  GetConfiguracion
  MousePointer = 0
  FailSafe_Exit:
  Exit Sub
  FailSafe_Error:
  ScShowError "Sub Guardar", vbCritical
  Resume FailSafe_Exit
End Sub


Private Sub FillCalendarioTab()
  On Error GoTo FailSafe_Error

  'header style
  CB_CA_HeaderStyle.AddItem "Ninguno"
  CB_CA_HeaderStyle.ItemData(CB_CA_HeaderStyle.NewIndex) = 0
  CB_CA_HeaderStyle.AddItem "1 linea"
  CB_CA_HeaderStyle.ItemData(CB_CA_HeaderStyle.NewIndex) = 1
  CB_CA_HeaderStyle.AddItem "2 lineas"
  CB_CA_HeaderStyle.ItemData(CB_CA_HeaderStyle.NewIndex) = 2
  LiListSelect CB_CA_HeaderStyle, Val(GetIniString("CA_HeaderStyle", "1"))
  'Month Style
  CB_CA_MonthHeaderStyle.AddItem "Scroll"
  CB_CA_MonthHeaderStyle.ItemData(CB_CA_MonthHeaderStyle.NewIndex) = 1
  CB_CA_MonthHeaderStyle.AddItem "Drop Down"
  CB_CA_MonthHeaderStyle.ItemData(CB_CA_MonthHeaderStyle.NewIndex) = 2
  LiListSelect CB_CA_MonthHeaderStyle, Val(GetIniString("CA_MonthHeaderStyle", "1"))
  'Year Style
  CB_CA_YearHeaderStyle.AddItem "Scroll"
  CB_CA_YearHeaderStyle.ItemData(CB_CA_YearHeaderStyle.NewIndex) = 1
  CB_CA_YearHeaderStyle.AddItem "Drop Down"
  CB_CA_YearHeaderStyle.ItemData(CB_CA_YearHeaderStyle.NewIndex) = 2
  LiListSelect CB_CA_YearHeaderStyle, Val(GetIniString("CA_YearHeaderStyle", "1"))
  'Day of week
  CB_CA_WeekDayHdr.AddItem "Ninguno"
  CB_CA_WeekDayHdr.ItemData(CB_CA_WeekDayHdr.NewIndex) = 0
  CB_CA_WeekDayHdr.AddItem "1 Letra"
  CB_CA_WeekDayHdr.ItemData(CB_CA_WeekDayHdr.NewIndex) = 1
  CB_CA_WeekDayHdr.AddItem "2 Letras"
  CB_CA_WeekDayHdr.ItemData(CB_CA_WeekDayHdr.NewIndex) = 2
  CB_CA_WeekDayHdr.AddItem "3 Letras"
  CB_CA_WeekDayHdr.ItemData(CB_CA_WeekDayHdr.NewIndex) = 3
  CB_CA_WeekDayHdr.AddItem "Completo"
  CB_CA_WeekDayHdr.ItemData(CB_CA_WeekDayHdr.NewIndex) = 4
  LiListSelect CB_CA_WeekDayHdr, Val(GetIniString("CA_WeekDayHdr", "2"))
  'First day of week
  CB_CA_FirstDayOfWeek.AddItem "Domingo"
  CB_CA_FirstDayOfWeek.ItemData(CB_CA_FirstDayOfWeek.NewIndex) = 0
  CB_CA_FirstDayOfWeek.AddItem "Lunes"
  CB_CA_FirstDayOfWeek.ItemData(CB_CA_FirstDayOfWeek.NewIndex) = 1
  LiListSelect CB_CA_FirstDayOfWeek, Val(GetIniString("CA_Firstdayofweek", "0"))
  FailSafe_Exit:
  Exit Sub
  FailSafe_Error:
  ScShowError "Sub FillCalendarioTab", vbCritical
  Resume FailSafe_Exit
End Sub


Private Sub FillFecha()
  On Error GoTo FailSafe_Error

  Dim Opcion%
  Opcion = Val(GetIniString("FechaDesde", "0"))
  '  O_FechaDesde(Opcion).Value = True
  '  TB_FE_CantDias.Text = GetIniString("FDesdeCantDias", "1")
  '  TB_FE_Fecha.Text = GetIniString("FDesdeFecha", format$(Date, C_PFecha))
  FailSafe_Exit:
  Exit Sub
  FailSafe_Error:
  ScShowError "Sub FillFecha", vbCritical
  Resume FailSafe_Exit
End Sub


Private Sub GuardarCalendarioTab()
  On Error GoTo FailSafe_Error

  'header style
  SaveIniString "CA_HeaderStyle", Trim(LigetitemData(CB_CA_HeaderStyle))
  'Month Style
  SaveIniString "CA_MonthHeaderStyle", Trim(LigetitemData(CB_CA_MonthHeaderStyle))
  'Year Style
  SaveIniString "CA_YearHeaderStyle", Trim(LigetitemData(CB_CA_YearHeaderStyle))
  'Day of week
  SaveIniString "CA_WeekDayHdr", Trim(LigetitemData(CB_CA_WeekDayHdr))
  'First day of week
  SaveIniString "CA_Firstdayofweek", Trim(LigetitemData(CB_CA_FirstDayOfWeek))
  FailSafe_Exit:
  Exit Sub
  FailSafe_Error:
  ScShowError "Sub GuardarCalendarioTab", vbCritical
  Resume FailSafe_Exit
End Sub


Private Sub GuardarFecha()
  On Error GoTo FailSafe_Error

  Dim i%
  Dim Opcion%
  '  For i = 0 To 2
  '    If O_FechaDesde(i).Value Then
  '      Opcion = i
  '      Exit For
  '    End If
  '  Next
  '
  'SaveIniString "FechaDesde", Trim(Opcion)
  'SaveIniString "FDesdeCantDias", Trim(TB_FE_CantDias.Text)
  'SaveIniString "FDesdeFecha", format$(TB_FE_Fecha.Text, C_PFecha)
  FailSafe_Exit:
  Exit Sub
  FailSafe_Error:
  ScShowError "Sub GuardarFecha", vbCritical
  Resume FailSafe_Exit
End Sub


Private Sub Form_Load()
  On Error GoTo FailSafe_Error

  SCSetFromProperties Me
  SCFormateoForms Me, formOtrosModal
  Dim datoIniReport As String
  Dim datoIniReportUsuario As String
  Dim datoIniExport As String
  datoIniReport = GetIniString(G_User & "ReportDataPath", "")
  datoIniReportUsuario = GetIniString(G_User & "ReportDataPathUsuario", "")
  datoIniExport = GetIniString(G_User & "ExportacionPath", "")

  If Vacio(datoIniReport) And Vacio(datoIniReportUsuario) And Vacio(datoIniExport) Then
    O_ConfEmpresa = True
    G_ExportacionPath = CfGet(GetSistemaEmpresa, "Exportacionpath", "")
    G_ReportDatapath = CfGet(GetSistemaEmpresa, "ReportDataPath", "")
    G_ReportDataPathUsuario = CfGet(GetSistemaEmpresa, "ReportDataPathUsuario", "")

  Else
    O_ConfUsuario = True
  End If

  '--------------------------------------------------
  'Edicion
  '--------------------------------------------------
  '  Check_Sonido = Val(GetIniString("Sonido", "-1"))
  '  Check_GuardarPosicion = Val(GetIniString("GuardarPosicion", "-1"))
  CHECK_ExpandirArboles = Val(GetIniString("ExpandirArboles", "0"))
  CHK_MailAutomaticoOnError.Value = Val(GetIniString("MailAutomaticoOnError", "0"))
  FillFecha
  '--------------------------------------------------
  'Calendario
  '--------------------------------------------------
  FillCalendarioTab
  '--------------------------------------------------
  'Exploracion
  '--------------------------------------------------
  O_Multiwindow.Value = Val(GetIniString("MultiplesVentanas", "-1"))
  O_Onlywindow.Value = Not O_Multiwindow.Value
  '--------------------------------------------------
  'Reportes
  '--------------------------------------------------
  Sel_ReportDataPath.Text = G_ReportDatapath
  Sel_ReportDataPathUsuario.Text = G_ReportDataPathUsuario
  SEL_ExportacionPath.Text = G_ExportacionPath
  TB_Minutos.Text = G_TimeOut
  FailSafe_Exit:
  Exit Sub
  FailSafe_Error:
  ScShowError "Sub Form_Load", vbCritical
  Resume FailSafe_Exit
End Sub


Private Sub O_ConfEmpresa_Click(Value As Integer)
  vsElastic.Visible = Not Value
  VideoSoftElastic3.Visible = Not Value
  VideoSoftElastic4.Visible = Not Value
  SEL_ExportacionPath = CfGet(GetSistemaEmpresa, "Exportacionpath", "")
  Sel_ReportDataPath = CfGet(GetSistemaEmpresa, "ReportDataPath", "")
  Sel_ReportDataPathUsuario = CfGet(GetSistemaEmpresa, "ReportDataPathUsuario", "")
End Sub


Private Sub O_ConfUsuario_Click(Value As Integer)
  vsElastic.Visible = Value
  VideoSoftElastic3.Visible = Value
  VideoSoftElastic4.Visible = Value
End Sub


Private Sub SEL_ExportacionPath_ButtonHit(Button As Integer, NewIndex As Integer)
  On Error GoTo FailSafe_Error

  Dim ReportName As Integer
  CommonDialog1.InitDir = SEL_ExportacionPath.Text
  CommonDialog1.DialogTitle = "Indique la ubicación del directorio de Exportacion"
  CommonDialog1.ShowOpen
  'ReportName = Len(CommonDialog1.FileTitle) + 1

  If Not Vacio(CommonDialog1.FileName) Then
    'Sel_ReportDataPath.Text = left(CommonDialog1.FileName, Len(CommonDialog1.FileName) - ReportName)
    SEL_ExportacionPath.Text = GetPathFromString(CommonDialog1.FileName)
  End If

  FailSafe_Exit:
  Exit Sub
  FailSafe_Error:
  ScShowError "Sub Sel_ExportacionPath_Buttonhit", vbCritical
  Resume FailSafe_Exit
End Sub


Private Sub Sel_ReportDataPath_ButtonHit(Button As Integer, NewIndex As Integer)
  On Error GoTo FailSafe_Error

  Dim ReportName As Integer
  CommonDialog1.InitDir = Sel_ReportDataPath.Text
  CommonDialog1.DialogTitle = "Indique la ubicación del directorio de Reportes"
  CommonDialog1.ShowOpen
  'ReportName = Len(CommonDialog1.FileTitle) + 1

  If Not Vacio(CommonDialog1.FileName) Then
    'Sel_ReportDataPath.Text = left(CommonDialog1.FileName, Len(CommonDialog1.FileName) - ReportName)
    Sel_ReportDataPath.Text = GetPathFromString(CommonDialog1.FileName)
  End If

  FailSafe_Exit:
  Exit Sub
  FailSafe_Error:
  ScShowError "Sub Sel_ReportDataPath_Buttonhit", vbCritical
  Resume FailSafe_Exit
End Sub


Private Sub Sel_ReportDataPathUsuario_ButtonHit(Button As Integer, NewIndex As Integer)
  On Error GoTo FailSafe_Error

  Dim ReportName As Integer
  CommonDialog1.InitDir = Sel_ReportDataPathUsuario.Text
  CommonDialog1.DialogTitle = "Indique la ubicación del directorio de Reportes"
  CommonDialog1.ShowOpen
  'ReportName = Len(CommonDialog1.FileTitle) + 1

  If Not Vacio(CommonDialog1.FileName) Then
    'Sel_ReportDataPath.Text = left(CommonDialog1.FileName, Len(CommonDialog1.FileName) - ReportName)
    Sel_ReportDataPathUsuario.Text = GetPathFromString(CommonDialog1.FileName)
  End If

  FailSafe_Exit:
  Exit Sub
  FailSafe_Error:
  ScShowError "Sub Sel_ReportDataPathUsuario_Buttonhit", vbCritical
  Resume FailSafe_Exit
End Sub


Private Sub SEL_Skin_VentanaPrincipal_ButtonHit(Button As Integer, NewIndex As Integer)
  On Error GoTo FailSafe_Error

  Dim ReportName As Integer
  CommonDialog1.InitDir = SEL_Skin_VentanaPrincipal.Text
  CommonDialog1.DialogTitle = "Seleccione la plantilla"
  CommonDialog1.ShowOpen

  If Not Vacio(CommonDialog1.FileName) Then
    SEL_Skin_VentanaPrincipal.Text = GetPathFromString(CommonDialog1.FileName)
  End If

  FailSafe_Exit:
  Exit Sub
  FailSafe_Error:
  ScShowError "Sub SEL_Skin_VentanaPrincipal_Buttonhit", vbCritical
  Resume FailSafe_Exit
End Sub


Private Sub SEL_Skin_VentanaDocumento_ButtonHit(Button As Integer, NewIndex As Integer)
  On Error GoTo FailSafe_Error

  Dim ReportName As Integer
  CommonDialog1.InitDir = SEL_Skin_VentanaDocumento.Text
  CommonDialog1.DialogTitle = "Seleccione la plantilla"
  CommonDialog1.ShowOpen

  If Not Vacio(CommonDialog1.FileName) Then
    SEL_Skin_VentanaDocumento.Text = GetPathFromString(CommonDialog1.FileName)
  End If

  FailSafe_Exit:
  Exit Sub
  FailSafe_Error:
  ScShowError "Sub SEL_Skin_VentanaDocumento_Buttonhit", vbCritical
  Resume FailSafe_Exit
End Sub


Private Sub SEL_Skin_BarraExploracion_ButtonHit(Button As Integer, NewIndex As Integer)
  On Error GoTo FailSafe_Error

  Dim ReportName As Integer
  CommonDialog1.InitDir = SEL_Skin_BarraExploracion.Text
  CommonDialog1.DialogTitle = "Seleccione la plantilla"
  CommonDialog1.ShowOpen

  If Not Vacio(CommonDialog1.FileName) Then
    SEL_Skin_BarraExploracion.Text = GetPathFromString(CommonDialog1.FileName)
  End If

  FailSafe_Exit:
  Exit Sub
  FailSafe_Error:
  ScShowError "Sub SEL_Skin_BarraExploracion_Buttonhit", vbCritical
  Resume FailSafe_Exit
End Sub


Private Sub CmdSkinAceptar_Click()
  On Error GoTo FailSafe_Error


  If Vacio(Sel_ReportDataPath.Text) Then
    ScWarning ("El Directorio de reportes no puede estar vacio")
    VSIndexTab1.CurrTab = 3 ' tab inicio
    Sel_ReportDataPath.SetFocus

  Else
    Guardar
    Unload Me
  End If

  FailSafe_Exit:
  Exit Sub
  FailSafe_Error:
  ScShowError "Sub CmdSkinAceptar_Click", vbCritical
  Resume FailSafe_Exit
End Sub


Private Sub CmdSkinCancelar_Click()
  On Error GoTo FailSafe_Error

  Unload Me
  FailSafe_Exit:
  Exit Sub
  FailSafe_Error:
  ScShowError "Sub CmdSkinCancelar_Click", vbCritical
  Resume FailSafe_Exit
End Sub


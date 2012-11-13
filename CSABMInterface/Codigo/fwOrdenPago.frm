VERSION 5.00
Object = "{57EC5E1A-9098-47A9-A8E3-EF352F97282B}#2.2#0"; "CSButton.ocx"
Object = "{600443F6-6F00-4B3F-BEB8-92D0CDADE10D}#4.3#0"; "CSMaskEdit.ocx"
Object = "{0B7EBB95-21B3-4493-8B5C-1319674D4CF8}#2.0#0"; "CSControls.ocx"
Begin VB.Form fwOrdenPago 
   ClientHeight    =   6630
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   12165
   Icon            =   "fwOrdenPago.frx":0000
   KeyPreview      =   -1  'True
   LinkTopic       =   "Form1"
   ScaleHeight     =   6630
   ScaleWidth      =   12165
   Begin CSButton.cButton cmdNext 
      Height          =   330
      Left            =   8885
      TabIndex        =   0
      Top             =   6225
      Width           =   1275
      _ExtentX        =   0
      _ExtentY        =   0
      Caption         =   "&Siguiente"
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
   Begin CSButton.cButton cmdBack 
      Height          =   330
      Left            =   7530
      TabIndex        =   1
      Top             =   6225
      Width           =   1275
      _ExtentX        =   0
      _ExtentY        =   0
      Caption         =   "&Atras"
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
   Begin CSButton.cButton cmdCancel 
      Height          =   330
      Left            =   10410
      TabIndex        =   2
      Top             =   6225
      Width           =   1275
      _ExtentX        =   0
      _ExtentY        =   0
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
   Begin CSButton.cButton cbTab 
      Height          =   330
      Index           =   0
      Left            =   90
      TabIndex        =   18
      Top             =   540
      Visible         =   0   'False
      Width           =   1680
      _ExtentX        =   0
      _ExtentY        =   0
      Caption         =   "&1-Paso1"
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
      TabButton       =   -1  'True
      BackColorPressed=   -2147483628
   End
   Begin CSButton.cButton cbTab 
      Height          =   330
      Index           =   1
      Left            =   1750
      TabIndex        =   19
      Top             =   540
      Visible         =   0   'False
      Width           =   1680
      _ExtentX        =   0
      _ExtentY        =   0
      Caption         =   "&2-Paso2"
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
      TabButton       =   -1  'True
      BackColorPressed=   -2147483628
   End
   Begin CSButton.cButton cbTab 
      Height          =   330
      Index           =   2
      Left            =   3410
      TabIndex        =   20
      Top             =   540
      Visible         =   0   'False
      Width           =   1680
      _ExtentX        =   0
      _ExtentY        =   0
      Caption         =   "&3-Paso3"
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
      TabButton       =   -1  'True
      BackColorPressed=   -2147483628
   End
   Begin CSButton.cButton cbTab 
      Height          =   330
      Index           =   3
      Left            =   5070
      TabIndex        =   21
      Top             =   540
      Visible         =   0   'False
      Width           =   1680
      _ExtentX        =   0
      _ExtentY        =   0
      Caption         =   "&4-Paso4"
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
      TabButton       =   -1  'True
      BackColorPressed=   -2147483628
   End
   Begin CSButton.cButton cbTab 
      Height          =   330
      Index           =   4
      Left            =   6730
      TabIndex        =   22
      Top             =   540
      Visible         =   0   'False
      Width           =   1680
      _ExtentX        =   0
      _ExtentY        =   0
      Caption         =   "&5-Paso5"
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
      TabButton       =   -1  'True
      BackColorPressed=   -2147483628
   End
   Begin CSButton.cButton cbTab 
      Height          =   330
      Index           =   5
      Left            =   8400
      TabIndex        =   23
      Top             =   540
      Visible         =   0   'False
      Width           =   1680
      _ExtentX        =   0
      _ExtentY        =   0
      Caption         =   "&6-Paso6"
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
      TabButton       =   -1  'True
      BackColorPressed=   -2147483628
   End
   Begin CSButton.cButton cbTab 
      Height          =   330
      Index           =   6
      Left            =   150
      TabIndex        =   24
      Tag             =   "_INNERTAB_401"
      Top             =   1100
      Visible         =   0   'False
      Width           =   1680
      _ExtentX        =   0
      _ExtentY        =   0
      Caption         =   "&1-Cheques"
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
      TabButton       =   -1  'True
      BackColorPressed=   -2147483628
   End
   Begin CSButton.cButton cbTab 
      Height          =   330
      Index           =   7
      Left            =   1810
      TabIndex        =   25
      Tag             =   "_INNERTAB_402"
      Top             =   1100
      Visible         =   0   'False
      Width           =   1680
      _ExtentX        =   0
      _ExtentY        =   0
      Caption         =   "&2-Efectivo"
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
      TabButton       =   -1  'True
      BackColorPressed=   -2147483628
   End
   Begin CSButton.cButton cbTab 
      Height          =   330
      Index           =   8
      Left            =   3470
      TabIndex        =   26
      Tag             =   "_INNERTAB_403"
      Top             =   1100
      Visible         =   0   'False
      Width           =   1680
      _ExtentX        =   0
      _ExtentY        =   0
      Caption         =   "&3-Otros"
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
      TabButton       =   -1  'True
      BackColorPressed=   -2147483628
   End
   Begin CSButton.cButton cbTab 
      Height          =   330
      Index           =   9
      Left            =   5130
      TabIndex        =   27
      Tag             =   "_INNERTAB_404"
      Top             =   1100
      Visible         =   0   'False
      Width           =   1680
      _ExtentX        =   0
      _ExtentY        =   0
      Caption         =   "&4-Cuenta Corriente"
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
      TabButton       =   -1  'True
      TabSelected     =   -1  'True
      BackColor       =   -2147483628
      BackColorPressed=   -2147483628
   End
   Begin CSControls.cHelp HL 
      Height          =   285
      Index           =   1
      Left            =   3700
      TabIndex        =   33
      Top             =   1500
      Visible         =   0   'False
      Width           =   4000
      _ExtentX        =   0
      _ExtentY        =   0
      BorderColor     =   -2147483633
      BorderType      =   1
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
   Begin CSControls.cHelp HL 
      Height          =   285
      Index           =   2
      Left            =   3700
      TabIndex        =   35
      Top             =   2000
      Visible         =   0   'False
      Width           =   4000
      _ExtentX        =   0
      _ExtentY        =   0
      BorderColor     =   -2147483633
      BorderType      =   1
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
   Begin VB.CheckBox CHK 
      Appearance      =   0  'Flat
      ForeColor       =   &H80000008&
      Height          =   285
      Index           =   1
      Left            =   11400
      TabIndex        =   39
      Top             =   100
      Visible         =   0   'False
      Width           =   370
   End
   Begin VB.CheckBox CHK 
      Appearance      =   0  'Flat
      ForeColor       =   &H80000008&
      Height          =   285
      Index           =   2
      Left            =   11400
      TabIndex        =   41
      Top             =   400
      Visible         =   0   'False
      Width           =   370
   End
   Begin CSMaskEdit.cMaskEdit ME 
      Height          =   285
      Index           =   1
      Left            =   10650
      TabIndex        =   43
      Top             =   750
      Visible         =   0   'False
      Width           =   1200
      _ExtentX        =   3519
      _ExtentY        =   556
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
      BorderColor     =   -2147483633
      BorderType      =   1
      csNotRaiseError =   -1  'True
   End
   Begin CSButton.cButton CMD 
      Height          =   330
      Index           =   1
      Left            =   200
      TabIndex        =   47
      Top             =   5660
      Visible         =   0   'False
      Width           =   2200
      _ExtentX        =   0
      _ExtentY        =   0
      Caption         =   "Marcar Todas"
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
   Begin CSMaskEdit.cMaskEdit ME 
      Height          =   285
      Index           =   2
      Left            =   3500
      TabIndex        =   49
      Top             =   5660
      Visible         =   0   'False
      Width           =   1800
      _ExtentX        =   3519
      _ExtentY        =   556
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
      BorderColor     =   -2147483633
      BorderType      =   1
      csNotRaiseError =   -1  'True
   End
   Begin CSMaskEdit.cMaskEdit ME 
      Height          =   285
      Index           =   3
      Left            =   7000
      TabIndex        =   51
      Top             =   5660
      Visible         =   0   'False
      Width           =   1800
      _ExtentX        =   3519
      _ExtentY        =   556
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
      BorderColor     =   -2147483633
      BorderType      =   1
      csNotRaiseError =   -1  'True
   End
   Begin CSMaskEdit.cMaskEdit ME 
      Height          =   285
      Index           =   4
      Left            =   9820
      TabIndex        =   53
      Top             =   5660
      Visible         =   0   'False
      Width           =   1800
      _ExtentX        =   3519
      _ExtentY        =   556
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
      BorderColor     =   -2147483633
      BorderType      =   1
      csNotRaiseError =   -1  'True
   End
   Begin CSControls.cHelp HL 
      Height          =   285
      Index           =   3
      Left            =   4080
      TabIndex        =   57
      Top             =   1600
      Visible         =   0   'False
      Width           =   3500
      _ExtentX        =   6165
      _ExtentY        =   503
      BorderColor     =   -2147483633
      BorderType      =   1
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
   Begin CSControls.cHelp HL 
      Height          =   285
      Index           =   4
      Left            =   4080
      TabIndex        =   59
      Top             =   2040
      Visible         =   0   'False
      Width           =   2040
      _ExtentX        =   3598
      _ExtentY        =   503
      BorderColor     =   -2147483633
      BorderType      =   1
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
   Begin CSMaskEdit.cMaskEdit ME 
      Height          =   285
      Index           =   5
      Left            =   4080
      TabIndex        =   61
      Top             =   2480
      Visible         =   0   'False
      Width           =   1200
      _ExtentX        =   2117
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
      BorderColor     =   -2147483633
      BorderType      =   1
      csNotRaiseError =   -1  'True
   End
   Begin CSMaskEdit.cMaskEdit ME 
      Height          =   285
      Index           =   6
      Left            =   4080
      TabIndex        =   63
      Top             =   2925
      Visible         =   0   'False
      Width           =   1200
      _ExtentX        =   2117
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
      BorderColor     =   -2147483633
      BorderType      =   1
      csNotRaiseError =   -1  'True
   End
   Begin CSControls.cGridAdvanced GR 
      Height          =   4000
      Index           =   2
      Left            =   150
      TabIndex        =   67
      Top             =   1600
      Visible         =   0   'False
      Width           =   11500
      _ExtentX        =   0
      _ExtentY        =   0
   End
   Begin CSControls.cGridAdvanced GR 
      Height          =   4000
      Index           =   3
      Left            =   150
      TabIndex        =   69
      Top             =   1600
      Visible         =   0   'False
      Width           =   11500
      _ExtentX        =   0
      _ExtentY        =   0
   End
   Begin CSControls.cGridAdvanced GR 
      Height          =   4000
      Index           =   4
      Left            =   150
      TabIndex        =   71
      Top             =   1600
      Visible         =   0   'False
      Width           =   11500
      _ExtentX        =   0
      _ExtentY        =   0
   End
   Begin CSControls.cGridAdvanced GR 
      Height          =   4000
      Index           =   5
      Left            =   150
      TabIndex        =   73
      Top             =   1600
      Visible         =   0   'False
      Width           =   11500
      _ExtentX        =   0
      _ExtentY        =   0
   End
   Begin CSMaskEdit.cMaskEdit ME 
      Height          =   285
      Index           =   7
      Left            =   1800
      TabIndex        =   75
      Top             =   5700
      Visible         =   0   'False
      Width           =   1800
      _ExtentX        =   3519
      _ExtentY        =   556
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
      BorderColor     =   -2147483633
      BorderType      =   1
      csNotRaiseError =   -1  'True
   End
   Begin CSMaskEdit.cMaskEdit ME 
      Height          =   285
      Index           =   8
      Left            =   4800
      TabIndex        =   77
      Top             =   5700
      Visible         =   0   'False
      Width           =   1800
      _ExtentX        =   3519
      _ExtentY        =   556
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
      BorderColor     =   -2147483633
      BorderType      =   1
      csNotRaiseError =   -1  'True
   End
   Begin CSMaskEdit.cMaskEdit ME 
      Height          =   285
      Index           =   9
      Left            =   7200
      TabIndex        =   79
      Top             =   5700
      Visible         =   0   'False
      Width           =   1800
      _ExtentX        =   3519
      _ExtentY        =   556
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
      BorderColor     =   -2147483633
      BorderType      =   1
      csNotRaiseError =   -1  'True
   End
   Begin CSMaskEdit.cMaskEdit ME 
      Height          =   285
      Index           =   10
      Left            =   9850
      TabIndex        =   81
      Top             =   5700
      Visible         =   0   'False
      Width           =   1800
      _ExtentX        =   3519
      _ExtentY        =   556
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
      BorderColor     =   -2147483633
      BorderType      =   1
      csNotRaiseError =   -1  'True
   End
   Begin CSMaskEdit.cMaskEdit MEFE 
      Height          =   285
      Index           =   1
      Left            =   2800
      TabIndex        =   85
      Top             =   1600
      Visible         =   0   'False
      Width           =   1400
      _ExtentX        =   3519
      _ExtentY        =   556
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
      BorderColor     =   -2147483633
      BorderType      =   1
      csNotRaiseError =   -1  'True
   End
   Begin CSControls.cHelp HL 
      Height          =   285
      Index           =   5
      Left            =   2800
      TabIndex        =   4
      Top             =   2040
      Visible         =   0   'False
      Width           =   2265
      _ExtentX        =   0
      _ExtentY        =   0
      BorderColor     =   -2147483633
      BorderType      =   1
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
   Begin CSControls.cHelp HL 
      Height          =   285
      Index           =   6
      Left            =   2800
      TabIndex        =   6
      Top             =   2480
      Visible         =   0   'False
      Width           =   2265
      _ExtentX        =   0
      _ExtentY        =   0
      BorderColor     =   -2147483633
      BorderType      =   1
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
   Begin CSMaskEdit.cMaskEdit TX 
      Height          =   285
      Index           =   1
      Left            =   6800
      TabIndex        =   8
      Top             =   1600
      Visible         =   0   'False
      Width           =   2265
      _ExtentX        =   3519
      _ExtentY        =   556
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
      BorderColor     =   -2147483633
      BorderType      =   1
      csNotRaiseError =   -1  'True
      ButtonStyle     =   0
   End
   Begin CSControls.cHelp HL 
      Height          =   285
      Index           =   7
      Left            =   6800
      TabIndex        =   10
      Top             =   2040
      Visible         =   0   'False
      Width           =   2265
      _ExtentX        =   0
      _ExtentY        =   0
      BorderColor     =   -2147483633
      BorderType      =   1
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
   Begin CSControls.cHelp HL 
      Height          =   285
      Index           =   8
      Left            =   6800
      TabIndex        =   12
      Top             =   2480
      Visible         =   0   'False
      Width           =   2265
      _ExtentX        =   0
      _ExtentY        =   0
      BorderColor     =   -2147483633
      BorderType      =   1
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
   Begin CSMaskEdit.cMaskEdit TX 
      Height          =   880
      Index           =   2
      Left            =   2800
      TabIndex        =   14
      Top             =   2920
      Visible         =   0   'False
      Width           =   6250
      _ExtentX        =   3519
      _ExtentY        =   556
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
      BorderColor     =   -2147483633
      BorderType      =   1
      csNotRaiseError =   -1  'True
      ButtonStyle     =   0
   End
   Begin CSControls.cGridAdvanced GR 
      Height          =   4500
      Index           =   1
      Left            =   150
      TabIndex        =   45
      Top             =   1100
      Visible         =   0   'False
      Width           =   11500
      _ExtentX        =   0
      _ExtentY        =   0
   End
   Begin VB.Label lbTitle2 
      BackStyle       =   0  'Transparent
      Caption         =   "Bienvenido al Asistente de ordenes de pago"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   14.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   880
      Index           =   1
      Left            =   2700
      TabIndex        =   29
      Top             =   100
      Width           =   7000
   End
   Begin VB.Label lbTitleEx2 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   330
      Left            =   4635
      TabIndex        =   17
      Top             =   45
      Width           =   75
   End
   Begin VB.Label LBDescrip 
      BackStyle       =   0  'Transparent
      Caption         =   "pirulo en pirulo por pirulo"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   690
      Left            =   1710
      TabIndex        =   16
      Top             =   945
      Visible         =   0   'False
      Width           =   6090
   End
   Begin VB.Line Line2 
      BorderColor     =   &H8000000E&
      X1              =   0
      X2              =   12165
      Y1              =   6101
      Y2              =   6101
   End
   Begin VB.Line Line1 
      BorderColor     =   &H80000010&
      X1              =   0
      X2              =   12165
      Y1              =   6091
      Y2              =   6091
   End
   Begin VB.Shape shTitle 
      BackStyle       =   1  'Opaque
      BorderStyle     =   0  'Transparent
      Height          =   510
      Left            =   0
      Top             =   0
      Width           =   12165
   End
   Begin VB.Image Img 
      Height          =   4365
      Index           =   1
      Left            =   0
      Top             =   0
      Width           =   4365
   End
   Begin VB.Label LB 
      BackStyle       =   0  'Transparent
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   420
      Index           =   1
      Left            =   -1190
      TabIndex        =   28
      Top             =   0
      Visible         =   0   'False
      Width           =   1190
   End
   Begin VB.Label LB2 
      BackStyle       =   0  'Transparent
      Caption         =   "Con este asistente usted podra generar los autorizaciones por ordenes de pago."
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   880
      Index           =   1
      Left            =   3000
      TabIndex        =   30
      Top             =   1200
      Width           =   6000
   End
   Begin VB.Image Img 
      Height          =   960
      Index           =   2
      Left            =   105
      Top             =   105
      Width           =   960
   End
   Begin VB.Label LB 
      BackStyle       =   0  'Transparent
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   420
      Index           =   2
      Left            =   -1090
      TabIndex        =   31
      Top             =   100
      Visible         =   0   'False
      Width           =   1190
   End
   Begin VB.Label LB2 
      BackStyle       =   0  'Transparent
      Caption         =   "Indique el documento a utilizar y el proveedor al que se le emitirá el recibo"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   880
      Index           =   2
      Left            =   1500
      TabIndex        =   32
      Top             =   400
      Visible         =   0   'False
      Width           =   8000
   End
   Begin VB.Label LB 
      BackStyle       =   0  'Transparent
      Caption         =   "Documento"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   420
      Index           =   3
      Left            =   2510
      TabIndex        =   34
      Top             =   1500
      Visible         =   0   'False
      Width           =   1190
   End
   Begin VB.Label LB 
      BackStyle       =   0  'Transparent
      Caption         =   "Proveedor"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   420
      Index           =   4
      Left            =   2510
      TabIndex        =   36
      Top             =   2000
      Visible         =   0   'False
      Width           =   1190
   End
   Begin VB.Image Img 
      Height          =   960
      Index           =   3
      Left            =   105
      Top             =   105
      Width           =   960
   End
   Begin VB.Label LB 
      BackStyle       =   0  'Transparent
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   420
      Index           =   5
      Left            =   -1090
      TabIndex        =   37
      Top             =   100
      Visible         =   0   'False
      Width           =   1190
   End
   Begin VB.Label LB2 
      BackStyle       =   0  'Transparent
      Caption         =   "Seleccione las facturas he indique los importes que cancelará en cada una de ellas"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   880
      Index           =   3
      Left            =   1500
      TabIndex        =   38
      Top             =   400
      Visible         =   0   'False
      Width           =   8000
   End
   Begin VB.Label LB 
      BackStyle       =   0  'Transparent
      Caption         =   "Agrupar"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   420
      Index           =   6
      Left            =   10700
      TabIndex        =   40
      Top             =   100
      Visible         =   0   'False
      Width           =   700
   End
   Begin VB.Label LB 
      BackStyle       =   0  'Transparent
      Caption         =   "Ver solo vencidos"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   420
      Index           =   7
      Left            =   10000
      TabIndex        =   42
      Top             =   400
      Visible         =   0   'False
      Width           =   1400
   End
   Begin VB.Label LB 
      BackStyle       =   0  'Transparent
      Caption         =   "Cotización"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   420
      Index           =   8
      Left            =   9250
      TabIndex        =   44
      Top             =   750
      Visible         =   0   'False
      Width           =   1400
   End
   Begin VB.Label LB 
      BackStyle       =   0  'Transparent
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   420
      Index           =   9
      Left            =   9250
      TabIndex        =   46
      Top             =   1035
      Visible         =   0   'False
      Width           =   1185
   End
   Begin VB.Label LB 
      BackStyle       =   0  'Transparent
      Caption         =   "Marcar Todas"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   420
      Index           =   10
      Left            =   190
      TabIndex        =   48
      Top             =   5660
      Visible         =   0   'False
      Width           =   10
   End
   Begin VB.Label LB 
      BackStyle       =   0  'Transparent
      Caption         =   "Anticipo"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   420
      Index           =   11
      Left            =   2500
      TabIndex        =   50
      Top             =   5660
      Visible         =   0   'False
      Width           =   1000
   End
   Begin VB.Label LB 
      BackStyle       =   0  'Transparent
      Caption         =   "Total Origen"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   420
      Index           =   12
      Left            =   6000
      TabIndex        =   52
      Top             =   5660
      Visible         =   0   'False
      Width           =   1000
   End
   Begin VB.Label LB 
      BackStyle       =   0  'Transparent
      Caption         =   "Total"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   420
      Index           =   13
      Left            =   9220
      TabIndex        =   54
      Top             =   5660
      Visible         =   0   'False
      Width           =   600
   End
   Begin VB.Image Img 
      Height          =   960
      Index           =   4
      Left            =   105
      Top             =   105
      Width           =   960
   End
   Begin VB.Label LB 
      BackStyle       =   0  'Transparent
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   420
      Index           =   14
      Left            =   -1090
      TabIndex        =   55
      Top             =   100
      Visible         =   0   'False
      Width           =   1190
   End
   Begin VB.Label LB2 
      BackStyle       =   0  'Transparent
      Caption         =   "Indique los datos del anticipo"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   880
      Index           =   4
      Left            =   1500
      TabIndex        =   56
      Top             =   400
      Visible         =   0   'False
      Width           =   8000
   End
   Begin VB.Label LB 
      BackStyle       =   0  'Transparent
      Caption         =   "Cuenta"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   420
      Index           =   15
      Left            =   3120
      TabIndex        =   58
      Top             =   1600
      Visible         =   0   'False
      Width           =   1185
   End
   Begin VB.Label LB 
      BackStyle       =   0  'Transparent
      Caption         =   "Moneda"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   420
      Index           =   16
      Left            =   3120
      TabIndex        =   60
      Top             =   2040
      Visible         =   0   'False
      Width           =   1185
   End
   Begin VB.Label LB 
      BackStyle       =   0  'Transparent
      Caption         =   "Cotización"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   420
      Index           =   17
      Left            =   3120
      TabIndex        =   62
      Top             =   2480
      Visible         =   0   'False
      Width           =   1185
   End
   Begin VB.Label LB 
      BackStyle       =   0  'Transparent
      Caption         =   "Importe"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   420
      Index           =   18
      Left            =   3120
      TabIndex        =   64
      Top             =   2920
      Visible         =   0   'False
      Width           =   1185
   End
   Begin VB.Image Img 
      Height          =   960
      Index           =   5
      Left            =   105
      Top             =   105
      Width           =   960
   End
   Begin VB.Label LB 
      BackStyle       =   0  'Transparent
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   420
      Index           =   19
      Left            =   -1090
      TabIndex        =   65
      Top             =   100
      Visible         =   0   'False
      Width           =   1190
   End
   Begin VB.Label LB2 
      BackStyle       =   0  'Transparent
      Caption         =   "Indique los instrumentos de pago"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   880
      Index           =   5
      Left            =   1500
      TabIndex        =   66
      Top             =   400
      Visible         =   0   'False
      Width           =   8000
   End
   Begin VB.Label LB 
      BackStyle       =   0  'Transparent
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   420
      Index           =   20
      Left            =   360
      TabIndex        =   68
      Top             =   1035
      Visible         =   0   'False
      Width           =   1185
   End
   Begin VB.Label LB 
      BackStyle       =   0  'Transparent
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   420
      Index           =   21
      Left            =   2740
      TabIndex        =   70
      Top             =   1035
      Visible         =   0   'False
      Width           =   1185
   End
   Begin VB.Label LB 
      BackStyle       =   0  'Transparent
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   420
      Index           =   22
      Left            =   2740
      TabIndex        =   72
      Top             =   1035
      Visible         =   0   'False
      Width           =   1185
   End
   Begin VB.Label LB 
      BackStyle       =   0  'Transparent
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   420
      Index           =   23
      Left            =   2740
      TabIndex        =   74
      Top             =   1035
      Visible         =   0   'False
      Width           =   1185
   End
   Begin VB.Label LB 
      BackStyle       =   0  'Transparent
      Caption         =   "A cobrar"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   420
      Index           =   24
      Left            =   800
      TabIndex        =   76
      Top             =   5700
      Visible         =   0   'False
      Width           =   1000
   End
   Begin VB.Label LB 
      BackStyle       =   0  'Transparent
      Caption         =   "Neto"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   420
      Index           =   25
      Left            =   4300
      TabIndex        =   78
      Top             =   5700
      Visible         =   0   'False
      Width           =   500
   End
   Begin VB.Label LB 
      BackStyle       =   0  'Transparent
      Caption         =   "Otros"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   420
      Index           =   26
      Left            =   6700
      TabIndex        =   80
      Top             =   5700
      Visible         =   0   'False
      Width           =   500
   End
   Begin VB.Label LB 
      BackStyle       =   0  'Transparent
      Caption         =   "Total"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   420
      Index           =   27
      Left            =   9350
      TabIndex        =   82
      Top             =   5700
      Visible         =   0   'False
      Width           =   500
   End
   Begin VB.Image Img 
      Height          =   960
      Index           =   6
      Left            =   105
      Top             =   105
      Width           =   960
   End
   Begin VB.Label LB 
      BackStyle       =   0  'Transparent
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   420
      Index           =   28
      Left            =   -1090
      TabIndex        =   83
      Top             =   100
      Visible         =   0   'False
      Width           =   1190
   End
   Begin VB.Label LB2 
      BackStyle       =   0  'Transparent
      Caption         =   "Complete los siguientes datos del recibo"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   880
      Index           =   6
      Left            =   1500
      TabIndex        =   84
      Top             =   400
      Visible         =   0   'False
      Width           =   8000
   End
   Begin VB.Label LB 
      BackStyle       =   0  'Transparent
      Caption         =   "Fecha"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   420
      Index           =   29
      Left            =   1610
      TabIndex        =   3
      Top             =   1600
      Visible         =   0   'False
      Width           =   1190
   End
   Begin VB.Label LB 
      BackStyle       =   0  'Transparent
      Caption         =   "Proveedor"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   420
      Index           =   30
      Left            =   1610
      TabIndex        =   5
      Top             =   2040
      Visible         =   0   'False
      Width           =   1185
   End
   Begin VB.Label LB 
      BackStyle       =   0  'Transparent
      Caption         =   "Sucursal"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   420
      Index           =   31
      Left            =   1610
      TabIndex        =   7
      Top             =   2480
      Visible         =   0   'False
      Width           =   1185
   End
   Begin VB.Label LB 
      BackStyle       =   0  'Transparent
      Caption         =   "Comprobante"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   420
      Index           =   32
      Left            =   5610
      TabIndex        =   9
      Top             =   1600
      Visible         =   0   'False
      Width           =   1190
   End
   Begin VB.Label LB 
      BackStyle       =   0  'Transparent
      Caption         =   "Legajo"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   420
      Index           =   33
      Left            =   5610
      TabIndex        =   11
      Top             =   2040
      Visible         =   0   'False
      Width           =   1185
   End
   Begin VB.Label LB 
      BackStyle       =   0  'Transparent
      Caption         =   "Centro de Costo"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   420
      Index           =   34
      Left            =   5610
      TabIndex        =   13
      Top             =   2480
      Visible         =   0   'False
      Width           =   1185
   End
   Begin VB.Label LB 
      BackStyle       =   0  'Transparent
      Caption         =   "Observaciones"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   420
      Index           =   35
      Left            =   1610
      TabIndex        =   15
      Top             =   2920
      Visible         =   0   'False
      Width           =   1190
   End
   Begin VB.Shape ShTab 
      BackColor       =   &H80000014&
      BackStyle       =   1  'Opaque
      Height          =   6810
      Left            =   -90
      Top             =   -105
      Width           =   12525
   End
End
Attribute VB_Name = "fwOrdenPago"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Implements CSIABMForm.cIABMDocForm
'--------------------------------------------------------------------------------
' fwOrdenPago
' 18-05-04

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "fwOrdenPago"
' estructuras
' variables privadas
Private m_oldCB()       As String
Private m_oldME()       As String
Private m_oldMEFE()     As String
Private m_oldTX()       As String
Private m_WasActivated  As Boolean

' Controles
Private WithEvents m_Toolbar  As Toolbar
Attribute m_Toolbar.VB_VarHelpID = -1
Private m_ToolBars            As Collection
Private m_FramesToolBar       As Collection
Private m_NextToolBar         As Integer
Private m_NextFrameToolBar    As Integer

Private m_OriginalShapeBottom       As Integer
Private m_OriginalButtonsBottom     As Integer
Private m_OriginalLinesBottom       As Integer

Private m_ABMObject            As Object

Private m_ObjHeader            As cIABMDocEvent

Private m_CancelUnload         As Boolean
Private m_WasChanged           As Boolean

'//////////////////////////////////////////////////////////////////////////
' Indices de controles para el ObjClient
Private m_CBhockUbound                  As Long
Private m_CBUbound                      As Long
Private m_HLUbound                      As Long
Private m_MEUbound                      As Long
Private m_MEFEUbound                    As Long
Private m_LB2Ubound                     As Long
Private m_LbTitle2Ubound                As Long
Private m_PrgBarUbound                  As Long
Private m_LBDescripUbound               As Long
Private m_ImgUbound                     As Long
Private m_TXUbound                      As Long
Private m_CHKUbound                     As Long
Private m_GRUbound                      As Long
Private m_CMDUbound                     As Long
Private m_LBUbound                      As Long

' eventos
' propiedades publicas
Public Property Get CBhockUbound() As Long
   CBhockUbound = m_CBhockUbound
End Property

Public Property Let CBhockUbound(ByVal rhs As Long)
   m_CBhockUbound = rhs
End Property

Public Property Get CBUbound() As Long
   CBUbound = m_CBUbound
End Property

Public Property Let CBUbound(ByVal rhs As Long)
   m_CBUbound = rhs
End Property

Public Property Get HLUbound() As Long
   HLUbound = m_HLUbound
End Property

Public Property Let HLUbound(ByVal rhs As Long)
   m_HLUbound = rhs
End Property

Public Property Get MEUbound() As Long
   MEUbound = m_MEUbound
End Property

Public Property Let MEUbound(ByVal rhs As Long)
   m_MEUbound = rhs
End Property

Public Property Get MEFEUbound() As Long
   MEFEUbound = m_MEFEUbound
End Property

Public Property Let MEFEUbound(ByVal rhs As Long)
   m_MEFEUbound = rhs
End Property

Public Property Get LB2Ubound() As Long
   LB2Ubound = m_LB2Ubound
End Property

Public Property Let LB2Ubound(ByVal rhs As Long)
   m_LB2Ubound = rhs
End Property

Public Property Get LbTitle2Ubound() As Long
   LbTitle2Ubound = m_LbTitle2Ubound
End Property

Public Property Let LbTitle2Ubound(ByVal rhs As Long)
   m_LbTitle2Ubound = rhs
End Property

Public Property Get PrgBarUbound() As Long
   PrgBarUbound = m_PrgBarUbound
End Property

Public Property Let PrgBarUbound(ByVal rhs As Long)
   m_PrgBarUbound = rhs
End Property

Public Property Get LBDescripUbound() As Long
   LBDescripUbound = m_LBDescripUbound
End Property

Public Property Let LBDescripUbound(ByVal rhs As Long)
   m_LBDescripUbound = rhs
End Property

Public Property Get ImgUbound() As Long
   ImgUbound = m_ImgUbound
End Property

Public Property Let ImgUbound(ByVal rhs As Long)
   m_ImgUbound = rhs
End Property

Public Property Get TXUbound() As Long
   TXUbound = m_TXUbound
End Property

Public Property Let TXUbound(ByVal rhs As Long)
   m_TXUbound = rhs
End Property

Public Property Get CHKUbound() As Long
   CHKUbound = m_CHKUbound
End Property

Public Property Let CHKUbound(ByVal rhs As Long)
   m_CHKUbound = rhs
End Property

Public Property Get GRUbound() As Long
   GRUbound = m_GRUbound
End Property

Public Property Let GRUbound(ByVal rhs As Long)
   m_GRUbound = rhs
End Property

Public Property Get CMDUbound() As Long
   CMDUbound = m_CMDUbound
End Property

Public Property Let CMDUbound(ByVal rhs As Long)
   m_CMDUbound = rhs
End Property

Public Property Get LBUbound() As Long
   LBUbound = m_LBUbound
End Property

Public Property Let LBUbound(ByVal rhs As Long)
   m_LBUbound = rhs
End Property

'//////////////////////////////////////////////////////////////////////////
Public Property Set ObjHeader(ByRef rhs As cIABMDocEvent)
  Set m_ObjHeader = rhs
End Property

Public Property Get cIABMDocForm_ABMObject() As Object
  Set cIABMDocForm_ABMObject = m_ABMObject
End Property

Public Property Set cIABMDocForm_ABMObject(ByRef rhs As Object)
  Set m_ABMObject = rhs
End Property

Private Property Let cIABMDocForm_CancelUnload(ByVal rhs As Boolean)
  m_CancelUnload = rhs
End Property

Private Property Get cIABMDocForm_CancelUnload() As Boolean
  cIABMDocForm_CancelUnload = m_CancelUnload
End Property

Private Sub cIABMDocForm_doPropertyChange()

End Sub

Private Sub cIABMDocForm_InitMembers()

End Sub

Public Property Let cIABMDocForm_Loading(ByVal rhs As Boolean)
End Property

' propiedades privadas
' funciones publicas
Public Function cIABMDocForm_GetToolBar() As Toolbar
  Set cIABMDocForm_GetToolBar = m_Toolbar
End Function

Public Sub cIABMDocForm_UnLoadToolbar()
  Dim o As Control
  
  With Me.Controls
    For Each o In m_ToolBars
      .Remove o
    Next
    For Each o In m_FramesToolBar
      .Remove o
    Next
  End With
  
  CollClear m_FramesToolBar
  CollClear m_ToolBars
End Sub

Public Sub cIABMDocForm_SetToolbar(ByRef Tbl As Object)
  Set m_Toolbar = Tbl
End Sub

Public Function cIABMDocForm_LoadToolbar(ByRef frToolBar As Frame) As Toolbar
  Dim f As Frame
  Dim t As Toolbar
  
  With Me.Controls
    Set f = .Add("VB.Frame", pGetFrameToolBarName)
    m_FramesToolBar.Add f
    Set t = .Add("MSComctlLib.Toolbar", pGetToolBarName, f)
    m_ToolBars.Add t
  End With
  
  Set frToolBar = f
  Set cIABMDocForm_LoadToolbar = t
End Function

Public Sub cIABMDocForm_SetFocusFirstControl()
  On Error Resume Next
  
  Dim c As Control
  
  For Each c In Me.Controls
    With c
      If .TabIndex = 0 And Not TypeOf c Is Label Then
        .SetFocus
        Exit For
      End If
    End With
  Next
End Sub

Public Function cIABMDocForm_CtrlKeySave() As Boolean
  cIABMDocForm_CtrlKeySave = True
End Function

Public Function cIABMDocForm_CtrlKeyNew() As Boolean
  cIABMDocForm_CtrlKeyNew = True
End Function

Public Function cIABMDocForm_CtrlKeyCopy() As Boolean
  cIABMDocForm_CtrlKeyCopy = True
End Function

Public Function cIABMDocForm_CtrlKeyRefresh() As Boolean
  cIABMDocForm_CtrlKeyRefresh = True
End Function

Public Function cIABMDocForm_CtrlKeyClose() As Boolean
  cIABMDocForm_CtrlKeyClose = True
End Function

' funciones privadas
Private Sub cbTab_Click(Index As Integer)
  Call m_ObjHeader.cbTabClick(Index, "")
End Sub

Private Sub CHK_Click(Index As Integer)
  Call m_ObjHeader.CHKClick(Index)
End Sub

Private Property Let cIABMDocForm_WasChanged(ByVal rhs As Boolean)
  m_WasChanged = rhs
End Property

Private Property Get cIABMDocForm_WasChanged() As Boolean
  cIABMDocForm_WasChanged = m_WasChanged
End Property

Private Sub CMD_Click(Index As Integer)
  Call m_ObjHeader.CMDClick(Index)
End Sub

Private Sub cmdNext_Click()
  Call m_ObjHeader.cmdNextClick
End Sub

Private Sub cmdCancel_Click()
  Call m_ObjHeader.cmdCancelClick
End Sub

Private Sub cmdBack_Click()
  Call m_ObjHeader.cmdBackClick
End Sub

Private Sub Form_Activate()
  If m_WasActivated Then Exit Sub
  m_WasActivated = True
End Sub

Private Sub Form_KeyDown(KeyCode As Integer, Shift As Integer)
  ProcessVirtualKey KeyCode, Shift, Me
End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
  Call m_ObjHeader.FormQueryUnload(Cancel, UnloadMode)
  If Cancel Then
    gUnloadCancel = True
  End If
End Sub

Private Sub GR_ColumnAfterEdit(Index As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long, bCancel As Boolean)
  Call m_ObjHeader.GRColumnAfterEdit(Index, lRow, lCol, NewValue, NewValueID, bCancel)
End Sub

Private Sub GR_ColumnAfterUpdate(Index As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long)
  Call m_ObjHeader.GRColumnAfterUpdate(Index, lRow, lCol, NewValue, NewValueID)
End Sub

Private Sub GR_ColumnBeforeEdit(Index As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer, bCancel As Boolean)
  Call m_ObjHeader.GRColumnBeforeEdit(Index, lRow, lCol, iKeyAscii, bCancel)
End Sub

Private Sub GR_ColumnClick(Index As Integer, ByVal lCol As Long)
  Call m_ObjHeader.GRClick(Index)
End Sub

Private Sub GR_DblClick(Index As Integer, ByVal lRow As Long, ByVal lCol As Long)
  Call m_ObjHeader.GRDblClick(Index, lRow, lCol)
End Sub

Private Sub GR_DeleteRow(Index As Integer, ByVal lRow As Long, bCancel As Boolean)
  Call m_ObjHeader.GRDeleteRow(Index, lRow, bCancel)
End Sub

Private Sub GR_NewRow(Index As Integer, ByVal lRow As Long)
  Call m_ObjHeader.GRNewRow(Index, lRow)
End Sub

Private Sub GR_SelectionChange(Index As Integer, ByVal lRow As Long, ByVal lCol As Long)
  Call m_ObjHeader.GRSelectionChange(Index, lRow, lCol)
End Sub

Private Sub GR_ValidateRow(Index As Integer, ByVal lRow As Long, bCancel As Boolean)
  Call m_ObjHeader.GRValidateRow(Index, lRow, bCancel)
End Sub

Private Sub HL_Change(Index As Integer)
  Call m_ObjHeader.HLChange(Index)
End Sub

Private Sub m_ToolBar_ButtonClick(ByVal Button As MSComctlLib.Button)
  Call m_ObjHeader.ToolBarButtonClick(Button)
End Sub

Private Sub ME_GotFocus(Index As Integer)
  On Error GoTo ControlError
  If UBound(m_oldME) < Index Then ReDim Preserve m_oldME(Index)
  m_oldME(Index) = Me.ME(Index).csValue
ControlError:
End Sub

Private Sub ME_LostFocus(Index As Integer)
  On Error GoTo ControlError
  If m_oldME(Index) = Me.ME(Index).csValue Then Exit Sub
  Call m_ObjHeader.MEChange(Index)
ControlError:
End Sub

Private Sub MEFE_GotFocus(Index As Integer)
  On Error GoTo ControlError
  If UBound(m_oldMEFE) < Index Then ReDim Preserve m_oldMEFE(Index)
  m_oldMEFE(Index) = Me.MEFE(Index).csValue
ControlError:
End Sub

Private Sub MEFE_LostFocus(Index As Integer)
  If m_oldMEFE(Index) = Me.MEFE(Index).csValue Then Exit Sub
  Call m_ObjHeader.MEDateChange(Index)
End Sub

Private Sub TX_GotFocus(Index As Integer)
  On Error GoTo ControlError
  If UBound(m_oldTX) < Index Then ReDim Preserve m_oldTX(Index)
  m_oldTX(Index) = TX(Index).Text
ControlError:
End Sub

Private Sub TX_ReturnFromHelp(Index As Integer)
  On Error GoTo ControlError
  
  If m_oldTX(Index) = TX(Index).Text Then Exit Sub
  Call m_ObjHeader.TXChange(Index)
  m_oldTX(Index) = TX(Index).Text

  Exit Sub
ControlError:
  MngError Err, "m_FormWizard_TXChange", C_Module, ""
End Sub

Private Sub TX_LostFocus(Index As Integer)
  On Error GoTo ControlError
  If m_oldTX(Index) = TX(Index).Text Then Exit Sub
  Call m_ObjHeader.TXChange(Index)
ControlError:
End Sub

Private Sub Form_Resize()
  If WindowState = vbMinimized Then Exit Sub
  
  With Line1
    .Y1 = Me.ScaleHeight - m_OriginalLinesBottom
    .Y2 = .Y1
    Line2.Y1 = .Y1 + 10
    Line2.Y2 = Line2.Y1
  
    .X1 = 0
    .X2 = ScaleWidth
    Line2.X1 = 0
    Line2.X2 = ScaleWidth
  End With
  
  With cmdCancel
    .Top = Me.ScaleHeight - m_OriginalButtonsBottom - .Height
    cmdNext.Top = .Top
    cmdBack.Top = .Top
    
    .Left = ScaleWidth - 480 - .Width
  End With
  
  With cmdNext
    .Left = cmdCancel.Left - .Width - 250
    cmdBack.Left = .Left - cmdBack.Width - 80
  End With
End Sub

Private Function pGetFrameToolBarName() As String
  pGetFrameToolBarName = "FrameToolBar" & m_NextFrameToolBar
  m_NextFrameToolBar = m_NextFrameToolBar + 1
End Function

Private Function pGetToolBarName() As String
  pGetToolBarName = "ToolBar" & m_NextToolBar
  m_NextToolBar = m_NextToolBar + 1
End Function

' construccion - destruccion
Private Sub Form_Load()
  On Error GoTo ControlError
  
  ReDim m_oldCB(0)
  ReDim m_oldME(0)
  ReDim m_oldMEFE(0)
  ReDim m_oldTX(0)
    
  With Me
    
    Set m_FramesToolBar = New Collection
    Set m_ToolBars = New Collection
    
    m_WasActivated = False
  
    m_OriginalShapeBottom = .ScaleHeight - ShTab.Height - ShTab.Top
    m_OriginalButtonsBottom = .ScaleHeight - cmdCancel.Height - cmdCancel.Top
    m_OriginalLinesBottom = .ScaleHeight - Line1.Y1 - Line1.BorderWidth
  End With

  Call m_ObjHeader.FormLoad
  GoTo ExitProc
ControlError:
  MngError Err, "Form_Load", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Form_Unload(Cancel As Integer)
  ReDim m_oldCB(0)
  ReDim m_oldME(0)
  ReDim m_oldMEFE(0)
  ReDim m_oldTX(0)

  Set m_ABMObject = Nothing
  
  Set m_FramesToolBar = Nothing
  Set m_ToolBars = Nothing
  Set m_Toolbar = Nothing
  
  Call m_ObjHeader.FormUnload(Cancel)
  CSKernelClient.UnloadForm Me, "ABM_" & Me.Caption
End Sub

VERSION 5.00
Object = "{57EC5E1A-9098-47A9-A8E3-EF352F97282B}#2.1#0"; "csButton.ocx"
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Object = "{600443F6-6F00-4B3F-BEB8-92D0CDADE10D}#3.1#0"; "csMaskEdit.ocx"
Begin VB.Form fNewWizard 
   Caption         =   "Form1"
   ClientHeight    =   5715
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   7920
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   ScaleHeight     =   5715
   ScaleWidth      =   7920
   Begin VB.PictureBox picStep1 
      BackColor       =   &H00FFFFFF&
      Height          =   720
      Left            =   6900
      ScaleHeight     =   660
      ScaleWidth      =   840
      TabIndex        =   57
      Top             =   180
      Width           =   900
   End
   Begin VB.PictureBox picStep21 
      BackColor       =   &H00FFFFFF&
      Height          =   480
      Left            =   7140
      ScaleHeight     =   420
      ScaleWidth      =   420
      TabIndex        =   56
      Top             =   240
      Width           =   480
   End
   Begin VB.PictureBox picStep22 
      BackColor       =   &H00FFFFFF&
      Height          =   480
      Left            =   7140
      ScaleHeight     =   420
      ScaleWidth      =   420
      TabIndex        =   55
      Top             =   240
      Width           =   480
   End
   Begin VB.PictureBox Picture3 
      BackColor       =   &H00FFFFFF&
      Height          =   480
      Left            =   7140
      ScaleHeight     =   420
      ScaleWidth      =   420
      TabIndex        =   54
      Top             =   240
      Width           =   480
   End
   Begin VB.PictureBox Picture2 
      Height          =   480
      Left            =   7140
      ScaleHeight     =   420
      ScaleWidth      =   420
      TabIndex        =   53
      Top             =   240
      Width           =   480
   End
   Begin VB.PictureBox picStep31 
      Height          =   480
      Left            =   7140
      ScaleHeight     =   420
      ScaleWidth      =   420
      TabIndex        =   52
      Top             =   240
      Width           =   480
   End
   Begin VB.PictureBox picStep4 
      BackColor       =   &H00FFFFFF&
      Height          =   480
      Left            =   7140
      ScaleHeight     =   420
      ScaleWidth      =   420
      TabIndex        =   51
      Top             =   240
      Width           =   480
   End
   Begin VB.PictureBox Picture1 
      BackColor       =   &H00FFFFFF&
      Height          =   480
      Left            =   7140
      ScaleHeight     =   420
      ScaleWidth      =   420
      TabIndex        =   50
      Top             =   240
      Width           =   480
   End
   Begin VB.PictureBox picStep6 
      BackColor       =   &H00FFFFFF&
      Height          =   480
      Left            =   7140
      ScaleHeight     =   420
      ScaleWidth      =   420
      TabIndex        =   49
      Top             =   240
      Width           =   480
   End
   Begin VB.PictureBox picStep0 
      BackColor       =   &H00800000&
      Height          =   540
      Left            =   1380
      ScaleHeight     =   480
      ScaleWidth      =   480
      TabIndex        =   48
      Top             =   540
      Width           =   540
   End
   Begin VB.Frame frStep1 
      Height          =   1620
      Left            =   2520
      TabIndex        =   44
      Top             =   2100
      Width           =   2580
      Begin VB.OptionButton opSQL 
         Caption         =   "Microsoft SQL Server"
         Height          =   300
         Left            =   180
         TabIndex        =   47
         Top             =   660
         Width           =   2300
      End
      Begin VB.OptionButton Option1 
         Caption         =   "Microsoft Access"
         Height          =   300
         Left            =   180
         TabIndex        =   46
         Top             =   1140
         Width           =   2300
      End
      Begin VB.OptionButton opAccess 
         Caption         =   "Microsoft Access"
         Height          =   300
         Left            =   180
         TabIndex        =   45
         Top             =   180
         Width           =   2300
      End
   End
   Begin CSMaskEdit.cMaskEdit txUserSql 
      Height          =   285
      Left            =   3240
      TabIndex        =   43
      Top             =   2520
      Width           =   2760
      _ExtentX        =   4868
      _ExtentY        =   503
      Text            =   ""
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      FontName        =   "Arial"
      FontSize        =   8,25
      MaxLength       =   32767
      csType          =   5
      BorderColor     =   4210752
      BorderType      =   1
      csNotRaiseError =   -1  'True
      ButtonStyle     =   0
   End
   Begin CSMaskEdit.cMaskEdit txPassword 
      Height          =   285
      Left            =   3240
      TabIndex        =   42
      Top             =   2880
      Width           =   2760
      _ExtentX        =   4868
      _ExtentY        =   503
      Text            =   ""
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Marlett"
         Size            =   8.25
         Charset         =   2
         Weight          =   500
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      FontName        =   "Marlett"
      FontSize        =   8,25
      MaxLength       =   32767
      PasswordChar    =   "h"
      csType          =   5
      BorderColor     =   4210752
      BorderType      =   1
      csNotRaiseError =   -1  'True
      ButtonStyle     =   0
   End
   Begin VB.Frame frStep0 
      Height          =   1140
      Left            =   3600
      TabIndex        =   39
      Top             =   2400
      Width           =   3720
      Begin VB.OptionButton opBlankReport 
         Caption         =   "En blanco"
         Height          =   360
         Left            =   180
         TabIndex        =   41
         Top             =   480
         Width           =   3240
      End
      Begin VB.OptionButton opUseWizard 
         Caption         =   "Con ayuda del asistente"
         Height          =   300
         Left            =   180
         TabIndex        =   40
         Top             =   120
         Width           =   3180
      End
   End
   Begin VB.Frame frStep22 
      Height          =   720
      Left            =   2940
      TabIndex        =   36
      Top             =   1680
      Width           =   4080
      Begin VB.OptionButton RadioButton1 
         Caption         =   "Autentificación de SQL Server"
         Height          =   240
         Left            =   120
         TabIndex        =   38
         Top             =   420
         Width           =   2640
      End
      Begin VB.OptionButton opNT 
         Caption         =   "Autentificación de NT"
         Height          =   240
         Left            =   120
         TabIndex        =   37
         Top             =   60
         Width           =   2220
      End
   End
   Begin CSButton.cButtonLigth cmdNew 
      Height          =   300
      Left            =   5040
      TabIndex        =   35
      Top             =   1020
      Width           =   360
      _ExtentX        =   635
      _ExtentY        =   529
      Caption         =   ""
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
      FontSize        =   8,25
   End
   Begin CSButton.cButtonLigth cmdDelete 
      Height          =   300
      Left            =   5460
      TabIndex        =   34
      Top             =   1020
      Width           =   360
      _ExtentX        =   635
      _ExtentY        =   529
      Caption         =   ""
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Arial"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      FontName        =   "Arial"
      FontSize        =   9
   End
   Begin VB.PictureBox PictureBox2 
      BorderStyle     =   0  'None
      Height          =   3060
      Left            =   60
      ScaleHeight     =   3060
      ScaleWidth      =   1860
      TabIndex        =   31
      Top             =   180
      Width           =   1860
   End
   Begin CSMaskEdit.cMaskEdit TxFileName 
      Height          =   285
      Left            =   2280
      TabIndex        =   30
      Top             =   2160
      Width           =   3960
      _ExtentX        =   6985
      _ExtentY        =   503
      Text            =   "$ 0,00"
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
      FontSize        =   8,25
      csNotRaiseError =   -1  'True
      ButtonStyle     =   0
   End
   Begin CSMaskEdit.cMaskEdit TxStrConnect 
      Height          =   285
      Left            =   2280
      TabIndex        =   29
      Top             =   2160
      Width           =   3960
      _ExtentX        =   6985
      _ExtentY        =   503
      Text            =   ""
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      FontName        =   "Arial"
      FontSize        =   8,25
      csType          =   5
      BorderColor     =   4210752
      BorderType      =   1
      csNotRaiseError =   -1  'True
      ButtonStyle     =   0
   End
   Begin CSButton.cButtonLigth cmdAdd 
      Height          =   1740
      Left            =   3240
      TabIndex        =   27
      Top             =   1740
      Width           =   420
      _ExtentX        =   741
      _ExtentY        =   3069
      Caption         =   ""
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
      FontSize        =   8,25
   End
   Begin VB.OptionButton opSp 
      Caption         =   "Consulta"
      Height          =   240
      Left            =   3960
      TabIndex        =   24
      Top             =   1080
      Width           =   2760
   End
   Begin VB.OptionButton opTable 
      Caption         =   "Tabla"
      Height          =   240
      Left            =   180
      TabIndex        =   21
      Top             =   1080
      Width           =   2760
   End
   Begin VB.ComboBox cbDataBases 
      Height          =   315
      Left            =   2820
      Style           =   2  'Dropdown List
      TabIndex        =   11
      Top             =   3480
      Width           =   3240
   End
   Begin MSComctlLib.ListView lvTables 
      Height          =   2460
      Left            =   120
      TabIndex        =   10
      Top             =   1380
      Width           =   3660
      _ExtentX        =   6456
      _ExtentY        =   4339
      LabelWrap       =   -1  'True
      HideSelection   =   -1  'True
      _Version        =   393217
      ForeColor       =   -2147483640
      BackColor       =   -2147483643
      BorderStyle     =   1
      Appearance      =   1
      NumItems        =   0
   End
   Begin VB.ComboBox cbServers 
      Height          =   315
      Left            =   2820
      TabIndex        =   9
      Text            =   "Combo1"
      Top             =   1140
      Width           =   3240
   End
   Begin MSComctlLib.ListView lvSps 
      Height          =   2640
      Left            =   3900
      TabIndex        =   8
      Top             =   1380
      Width           =   3660
      _ExtentX        =   6456
      _ExtentY        =   4657
      LabelEdit       =   1
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
   Begin MSComctlLib.TreeView tvReport 
      Height          =   3660
      Left            =   3720
      TabIndex        =   7
      Top             =   1380
      Width           =   3780
      _ExtentX        =   6668
      _ExtentY        =   6456
      _Version        =   393217
      HideSelection   =   0   'False
      Style           =   7
      BorderStyle     =   1
      Appearance      =   1
   End
   Begin MSComctlLib.ListView lvColumns 
      Height          =   3660
      Left            =   180
      TabIndex        =   6
      Top             =   1380
      Width           =   3000
      _ExtentX        =   5292
      _ExtentY        =   6456
      LabelEdit       =   1
      LabelWrap       =   -1  'True
      HideSelection   =   0   'False
      _Version        =   393217
      ForeColor       =   -2147483640
      BackColor       =   -2147483643
      BorderStyle     =   1
      Appearance      =   1
      NumItems        =   0
   End
   Begin VB.TextBox TxSqlstmt 
      Height          =   660
      Left            =   180
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   5
      Top             =   4290
      Width           =   7320
   End
   Begin CSButton.cButtonLigth cmdEnd 
      Height          =   375
      Left            =   6300
      TabIndex        =   3
      Top             =   5280
      Width           =   1275
      _ExtentX        =   2249
      _ExtentY        =   661
      Caption         =   "&Finalizar"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Arial"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      FontName        =   "Arial"
      FontSize        =   9
   End
   Begin CSButton.cButtonLigth cmdBack 
      Height          =   375
      Left            =   4860
      TabIndex        =   2
      Top             =   5280
      Width           =   1275
      _ExtentX        =   2249
      _ExtentY        =   661
      Caption         =   "&Atras"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Arial"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      FontName        =   "Arial"
      FontSize        =   9
   End
   Begin CSButton.cButtonLigth cmdCancel 
      Height          =   375
      Left            =   3120
      TabIndex        =   1
      Top             =   5280
      Width           =   1275
      _ExtentX        =   2249
      _ExtentY        =   661
      Caption         =   "&Cancelar"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Arial"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      FontName        =   "Arial"
      FontSize        =   9
   End
   Begin VB.OptionButton opSqlstmt 
      Caption         =   "Sentencia SQL"
      Height          =   240
      Left            =   180
      TabIndex        =   0
      Top             =   3990
      Width           =   2760
   End
   Begin CSButton.cButtonLigth cmdNext 
      Height          =   375
      Left            =   6300
      TabIndex        =   4
      Top             =   5280
      Width           =   1275
      _ExtentX        =   2249
      _ExtentY        =   661
      Caption         =   "&Siguiente"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Arial"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      FontName        =   "Arial"
      FontSize        =   9
   End
   Begin VB.Label lbFields 
      Caption         =   "Campos :"
      Height          =   240
      Left            =   240
      TabIndex        =   33
      Top             =   1020
      Width           =   840
   End
   Begin VB.Label lbFrame0 
      BackColor       =   &H00800000&
      Caption         =   "Label1"
      Height          =   6000
      Left            =   0
      TabIndex        =   32
      Top             =   -60
      Width           =   2040
   End
   Begin VB.Label lbFrameTop 
      BackColor       =   &H00FFFFFF&
      Height          =   1140
      Left            =   -180
      TabIndex        =   28
      Top             =   0
      Width           =   8220
   End
   Begin VB.Label lbFile 
      Caption         =   "Archivo :"
      Height          =   300
      Left            =   1260
      TabIndex        =   26
      Top             =   2160
      Width           =   840
   End
   Begin VB.Label lbSections 
      Caption         =   "Secciones :"
      Height          =   240
      Left            =   3780
      TabIndex        =   25
      Top             =   1020
      Width           =   960
   End
   Begin VB.Label lbFinish2 
      Caption         =   " Haga clic en el bóton Finalizar."
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   300
      Left            =   300
      TabIndex        =   23
      Top             =   2400
      Width           =   6960
   End
   Begin VB.Line lbLine1 
      BorderColor     =   &H00808080&
      X1              =   2220
      X2              =   6180
      Y1              =   3300
      Y2              =   3315
   End
   Begin VB.Label lbStrConnect 
      Caption         =   "Cadena de conexión :"
      Height          =   300
      Left            =   480
      TabIndex        =   22
      Top             =   2160
      Width           =   1740
   End
   Begin VB.Label lbDescrip 
      BackColor       =   &H00FFFFFF&
      Caption         =   "Este asistente lo guiara por una serie pasos que le permitiran generar un reporte en pocos minutos."
      Height          =   420
      Left            =   2325
      TabIndex        =   20
      Top             =   660
      Width           =   5175
   End
   Begin VB.Line lbLine2 
      X1              =   2220
      X2              =   6180
      Y1              =   1620
      Y2              =   1635
   End
   Begin VB.Label lbCreateReport 
      Caption         =   "Crear un nuevo reporte :"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   300
      Left            =   2445
      TabIndex        =   19
      Top             =   1980
      Width           =   3060
   End
   Begin VB.Label lbChoice 
      Caption         =   "¿ Que desea hacer ?"
      Height          =   360
      Left            =   2445
      TabIndex        =   18
      Top             =   1560
      Width           =   3060
   End
   Begin VB.Label lbFinish1 
      Caption         =   "El asistente tiene toda la información necesaria para generar el reporte."
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   360
      Left            =   300
      TabIndex        =   17
      Top             =   1740
      Width           =   7260
   End
   Begin VB.Label lbServer 
      Caption         =   "Servidor :"
      Height          =   300
      Left            =   1980
      TabIndex        =   16
      Top             =   1200
      Width           =   840
   End
   Begin VB.Label lbTitle 
      BackColor       =   &H00FFFFFF&
      Caption         =   "Crear un reporte"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   20.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   480
      Left            =   2160
      TabIndex        =   15
      Top             =   120
      Width           =   4740
   End
   Begin VB.Label lbUser 
      Caption         =   "Usuario :"
      Height          =   300
      Left            =   2280
      TabIndex        =   14
      Top             =   2520
      Width           =   840
   End
   Begin VB.Label lbPassword 
      Caption         =   "Clave :"
      Height          =   300
      Left            =   2280
      TabIndex        =   13
      Top             =   2880
      Width           =   840
   End
   Begin VB.Label lbDataBase 
      Caption         =   "Base :"
      Height          =   300
      Left            =   2235
      TabIndex        =   12
      Top             =   3510
      Width           =   600
   End
   Begin VB.Line lbLineMain 
      BorderColor     =   &H00808080&
      X1              =   2400
      X2              =   7680
      Y1              =   5160
      Y2              =   5160
   End
End
Attribute VB_Name = "fNewWizard"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

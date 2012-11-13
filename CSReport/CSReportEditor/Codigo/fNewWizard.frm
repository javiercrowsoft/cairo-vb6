VERSION 5.00
Object = "{57EC5E1A-9098-47A9-A8E3-EF352F97282B}#3.1#0"; "CSButton.ocx"
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "comdlg32.ocx"
Object = "{5E754090-10B8-424A-9F90-05CFA0432522}#18.0#0"; "CSMaskEdit2.ocx"
Begin VB.Form fNewWizard 
   Caption         =   "Form1"
   ClientHeight    =   5715
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   7920
   ControlBox      =   0   'False
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   5715
   ScaleWidth      =   7920
   StartUpPosition =   3  'Windows Default
   Begin CSButton.cButtonLigth cmdAdd 
      Height          =   540
      Left            =   3240
      TabIndex        =   27
      Top             =   2220
      Width           =   540
      _ExtentX        =   953
      _ExtentY        =   953
      Caption         =   ""
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      FontName        =   "MS Sans Serif"
      FontSize        =   9.75
   End
   Begin VB.PictureBox picStep0 
      BackColor       =   &H00800000&
      BorderStyle     =   0  'None
      Height          =   540
      Left            =   1560
      Picture         =   "fNewWizard.frx":0000
      ScaleHeight     =   540
      ScaleWidth      =   480
      TabIndex        =   9
      Top             =   120
      Width           =   480
   End
   Begin VB.PictureBox picWelcom 
      BorderStyle     =   0  'None
      Height          =   3060
      Left            =   60
      Picture         =   "fNewWizard.frx":08CA
      ScaleHeight     =   3060
      ScaleWidth      =   1860
      TabIndex        =   24
      Top             =   180
      Width           =   1860
   End
   Begin MSComctlLib.ImageList imlist 
      Left            =   3660
      Top             =   2580
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483643
      ImageWidth      =   16
      ImageHeight     =   16
      MaskColor       =   12632256
      _Version        =   393216
      BeginProperty Images {2C247F25-8591-11D1-B16A-00C0F0283628} 
         NumListImages   =   12
         BeginProperty ListImage1 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fNewWizard.frx":7150
            Key             =   ""
         EndProperty
         BeginProperty ListImage2 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fNewWizard.frx":76EA
            Key             =   ""
         EndProperty
         BeginProperty ListImage3 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fNewWizard.frx":7C84
            Key             =   ""
         EndProperty
         BeginProperty ListImage4 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fNewWizard.frx":7DDE
            Key             =   ""
         EndProperty
         BeginProperty ListImage5 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fNewWizard.frx":7F38
            Key             =   ""
         EndProperty
         BeginProperty ListImage6 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fNewWizard.frx":8092
            Key             =   ""
         EndProperty
         BeginProperty ListImage7 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fNewWizard.frx":81EC
            Key             =   ""
         EndProperty
         BeginProperty ListImage8 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fNewWizard.frx":8346
            Key             =   ""
         EndProperty
         BeginProperty ListImage9 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fNewWizard.frx":8798
            Key             =   ""
         EndProperty
         BeginProperty ListImage10 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fNewWizard.frx":88F2
            Key             =   ""
         EndProperty
         BeginProperty ListImage11 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fNewWizard.frx":8E8C
            Key             =   ""
         EndProperty
         BeginProperty ListImage12 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fNewWizard.frx":9426
            Key             =   ""
         EndProperty
      EndProperty
   End
   Begin MSComDlg.CommonDialog cmOpenFile 
      Left            =   3720
      Top             =   2640
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.OptionButton opSqlstmt 
      Caption         =   "Sentencia SQL"
      Height          =   240
      Left            =   180
      TabIndex        =   40
      Top             =   3990
      Width           =   2760
   End
   Begin VB.TextBox TxSqlstmt 
      Height          =   660
      Left            =   180
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   36
      Top             =   4290
      Width           =   7320
   End
   Begin VB.ComboBox cbServers 
      Height          =   315
      Left            =   2820
      TabIndex        =   32
      Text            =   "Combo1"
      Top             =   1140
      Width           =   3240
   End
   Begin VB.ComboBox cbDataBases 
      Height          =   315
      Left            =   2820
      Style           =   2  'Dropdown List
      TabIndex        =   30
      Top             =   3480
      Width           =   3240
   End
   Begin VB.OptionButton opTable 
      Caption         =   "Tabla"
      Height          =   240
      Left            =   180
      TabIndex        =   29
      Top             =   1080
      Width           =   2760
   End
   Begin VB.OptionButton opSp 
      Caption         =   "Consulta"
      Height          =   240
      Left            =   3960
      TabIndex        =   28
      Top             =   1080
      Width           =   2760
   End
   Begin VB.Frame frStep22 
      BorderStyle     =   0  'None
      Height          =   840
      Left            =   2280
      TabIndex        =   19
      Top             =   1560
      Width           =   4080
      Begin VB.OptionButton opNT 
         Caption         =   "Autentificación de NT"
         Height          =   240
         Left            =   120
         TabIndex        =   21
         Top             =   180
         Width           =   2220
      End
      Begin VB.OptionButton opSQLSecurity 
         Caption         =   "Autentificación de SQL Server"
         Height          =   240
         Left            =   120
         TabIndex        =   20
         Top             =   540
         Value           =   -1  'True
         Width           =   2640
      End
   End
   Begin VB.Frame frStep0 
      Height          =   1140
      Left            =   3600
      TabIndex        =   16
      Top             =   2400
      Width           =   3720
      Begin VB.OptionButton opUseWizard 
         Caption         =   "Con ayuda del asistente"
         Height          =   300
         Left            =   180
         TabIndex        =   18
         Top             =   180
         Value           =   -1  'True
         Width           =   3180
      End
      Begin VB.OptionButton opBlankReport 
         Caption         =   "En blanco"
         Height          =   360
         Left            =   180
         TabIndex        =   17
         Top             =   540
         Width           =   3240
      End
   End
   Begin VB.Frame frStep1 
      Height          =   1620
      Left            =   2520
      TabIndex        =   10
      Top             =   2100
      Width           =   2580
      Begin VB.OptionButton opAccess 
         Caption         =   "Microsoft Access"
         Height          =   300
         Left            =   180
         TabIndex        =   13
         Top             =   180
         Value           =   -1  'True
         Width           =   2300
      End
      Begin VB.OptionButton opOleDB 
         Caption         =   "Provider OLEDB"
         Height          =   300
         Left            =   180
         TabIndex        =   12
         Top             =   1140
         Width           =   2300
      End
      Begin VB.OptionButton opSQL 
         Caption         =   "Microsoft SQL Server"
         Height          =   300
         Left            =   180
         TabIndex        =   11
         Top             =   660
         Width           =   2300
      End
   End
   Begin VB.PictureBox picStep6 
      BackColor       =   &H00FFFFFF&
      Height          =   480
      Left            =   7140
      ScaleHeight     =   420
      ScaleWidth      =   420
      TabIndex        =   8
      Top             =   240
      Width           =   480
   End
   Begin VB.PictureBox Picture1 
      BackColor       =   &H00FFFFFF&
      Height          =   480
      Left            =   7140
      ScaleHeight     =   420
      ScaleWidth      =   420
      TabIndex        =   7
      Top             =   240
      Width           =   480
   End
   Begin VB.PictureBox picStep4 
      BackColor       =   &H00FFFFFF&
      Height          =   480
      Left            =   7140
      ScaleHeight     =   420
      ScaleWidth      =   420
      TabIndex        =   6
      Top             =   240
      Width           =   480
   End
   Begin VB.PictureBox picStep31 
      Height          =   480
      Left            =   7140
      ScaleHeight     =   420
      ScaleWidth      =   420
      TabIndex        =   5
      Top             =   240
      Width           =   480
   End
   Begin VB.PictureBox Picture2 
      Height          =   480
      Left            =   7140
      ScaleHeight     =   420
      ScaleWidth      =   420
      TabIndex        =   4
      Top             =   240
      Width           =   480
   End
   Begin VB.PictureBox Picture3 
      BackColor       =   &H00FFFFFF&
      Height          =   480
      Left            =   7140
      ScaleHeight     =   420
      ScaleWidth      =   420
      TabIndex        =   3
      Top             =   240
      Width           =   480
   End
   Begin VB.PictureBox picStep22 
      BackColor       =   &H00FFFFFF&
      Height          =   480
      Left            =   7140
      ScaleHeight     =   420
      ScaleWidth      =   420
      TabIndex        =   2
      Top             =   240
      Width           =   480
   End
   Begin VB.PictureBox picStep21 
      BackColor       =   &H00FFFFFF&
      Height          =   480
      Left            =   7140
      ScaleHeight     =   420
      ScaleWidth      =   420
      TabIndex        =   1
      Top             =   240
      Width           =   480
   End
   Begin VB.PictureBox picStep1 
      BackColor       =   &H00FFFFFF&
      BorderStyle     =   0  'None
      Height          =   720
      Left            =   6900
      Picture         =   "fNewWizard.frx":99C0
      ScaleHeight     =   720
      ScaleWidth      =   900
      TabIndex        =   0
      Top             =   180
      Width           =   900
   End
   Begin CSMaskEdit2.cMaskEdit txUserSql 
      Height          =   285
      Left            =   3240
      TabIndex        =   14
      Top             =   2520
      Width           =   2760
      _ExtentX        =   4868
      _ExtentY        =   503
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Arial"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      FontName        =   "Arial"
      FontSize        =   9.75
      EnabledNoChngBkColor=   0   'False
      Text            =   ""
      csType          =   5
      BorderColor     =   4210752
      BorderType      =   1
      csNotRaiseError =   -1  'True
      ButtonStyle     =   0
   End
   Begin CSMaskEdit2.cMaskEdit txPassword 
      Height          =   285
      Left            =   3240
      TabIndex        =   15
      Top             =   2880
      Width           =   2760
      _ExtentX        =   4868
      _ExtentY        =   503
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Marlett"
         Size            =   9.75
         Charset         =   2
         Weight          =   500
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      FontName        =   "Marlett"
      FontSize        =   9.75
      PasswordChar    =   "h"
      EnabledNoChngBkColor=   0   'False
      Text            =   ""
      csType          =   5
      BorderColor     =   4210752
      BorderType      =   1
      csNotRaiseError =   -1  'True
      ButtonStyle     =   0
   End
   Begin CSButton.cButtonLigth cmdNew 
      Height          =   300
      Left            =   5040
      TabIndex        =   22
      Top             =   1020
      Width           =   360
      _ExtentX        =   635
      _ExtentY        =   529
      Caption         =   ""
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      FontName        =   "MS Sans Serif"
      FontSize        =   9.75
   End
   Begin CSButton.cButtonLigth cmdDelete 
      Height          =   300
      Left            =   5460
      TabIndex        =   23
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
   Begin CSMaskEdit2.cMaskEdit TxFileName 
      Height          =   285
      Left            =   2280
      TabIndex        =   25
      Top             =   2160
      Width           =   3960
      _ExtentX        =   6985
      _ExtentY        =   503
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      FontName        =   "MS Sans Serif"
      FontSize        =   9.75
      EnabledNoChngBkColor=   0   'False
      Text            =   ""
      csType          =   8
      BorderType      =   1
      csNotRaiseError =   -1  'True
   End
   Begin CSMaskEdit2.cMaskEdit TxStrConnect 
      Height          =   285
      Left            =   2280
      TabIndex        =   26
      Top             =   2160
      Width           =   3960
      _ExtentX        =   6985
      _ExtentY        =   503
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Arial"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      FontName        =   "Arial"
      FontSize        =   9.75
      EnabledNoChngBkColor=   0   'False
      Text            =   ""
      csType          =   5
      BorderColor     =   4210752
      BorderType      =   1
      csNotRaiseError =   -1  'True
      ButtonStyle     =   0
   End
   Begin MSComctlLib.ListView lvTables 
      Height          =   2460
      Left            =   120
      TabIndex        =   31
      Top             =   1380
      Width           =   3660
      _ExtentX        =   6456
      _ExtentY        =   4339
      View            =   3
      LabelWrap       =   -1  'True
      HideSelection   =   -1  'True
      _Version        =   393217
      ForeColor       =   -2147483640
      BackColor       =   -2147483643
      BorderStyle     =   1
      Appearance      =   1
      NumItems        =   0
   End
   Begin MSComctlLib.ListView lvSps 
      Height          =   2640
      Left            =   3900
      TabIndex        =   33
      Top             =   1380
      Width           =   3660
      _ExtentX        =   6456
      _ExtentY        =   4657
      View            =   3
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
      Left            =   3960
      TabIndex        =   34
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
      TabIndex        =   35
      Top             =   1380
      Width           =   3000
      _ExtentX        =   5292
      _ExtentY        =   6456
      View            =   3
      LabelEdit       =   1
      MultiSelect     =   -1  'True
      LabelWrap       =   -1  'True
      HideSelection   =   0   'False
      _Version        =   393217
      ForeColor       =   -2147483640
      BackColor       =   -2147483643
      BorderStyle     =   1
      Appearance      =   1
      NumItems        =   0
   End
   Begin CSButton.cButtonLigth cmdEnd 
      Height          =   315
      Left            =   6300
      TabIndex        =   37
      Top             =   5340
      Width           =   1275
      _ExtentX        =   2249
      _ExtentY        =   556
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
      Height          =   315
      Left            =   4860
      TabIndex        =   38
      Top             =   5340
      Width           =   1275
      _ExtentX        =   2249
      _ExtentY        =   556
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
      Height          =   315
      Left            =   3120
      TabIndex        =   39
      Top             =   5340
      Width           =   1275
      _ExtentX        =   2249
      _ExtentY        =   556
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
   Begin CSButton.cButtonLigth cmdNext 
      Height          =   315
      Left            =   6300
      TabIndex        =   41
      Top             =   5340
      Width           =   1275
      _ExtentX        =   2249
      _ExtentY        =   556
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
   Begin VB.Line lbLine2 
      BorderColor     =   &H00808080&
      X1              =   2220
      X2              =   6180
      Y1              =   1510
      Y2              =   1510
   End
   Begin VB.Label lbFrame0 
      BackColor       =   &H00800000&
      Height          =   6000
      Left            =   0
      TabIndex        =   43
      Top             =   -60
      Width           =   2040
   End
   Begin VB.Line lbLineMain 
      BorderColor     =   &H00808080&
      X1              =   2400
      X2              =   7680
      Y1              =   5220
      Y2              =   5220
   End
   Begin VB.Label lbDataBase 
      Caption         =   "Base :"
      Height          =   300
      Left            =   2235
      TabIndex        =   57
      Top             =   3510
      Width           =   600
   End
   Begin VB.Label lbPassword 
      Caption         =   "Clave :"
      Height          =   300
      Left            =   2280
      TabIndex        =   56
      Top             =   2880
      Width           =   840
   End
   Begin VB.Label lbUser 
      Caption         =   "Usuario :"
      Height          =   300
      Left            =   2280
      TabIndex        =   55
      Top             =   2520
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
      TabIndex        =   54
      Top             =   120
      Width           =   4740
   End
   Begin VB.Label lbServer 
      Caption         =   "Servidor :"
      Height          =   300
      Left            =   1980
      TabIndex        =   53
      Top             =   1200
      Width           =   840
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
      TabIndex        =   52
      Top             =   1740
      Width           =   7260
   End
   Begin VB.Label lbChoice 
      Caption         =   "¿ Que desea hacer ?"
      Height          =   360
      Left            =   2445
      TabIndex        =   51
      Top             =   1560
      Width           =   3060
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
      TabIndex        =   50
      Top             =   1980
      Width           =   3060
   End
   Begin VB.Label lbDescrip 
      BackColor       =   &H00FFFFFF&
      Caption         =   "Este asistente lo guiara por una serie pasos que le permitiran generar un reporte en pocos minutos."
      Height          =   420
      Left            =   2325
      TabIndex        =   49
      Top             =   660
      Width           =   5175
   End
   Begin VB.Label lbStrConnect 
      Caption         =   "Cadena de conexión :"
      Height          =   300
      Left            =   480
      TabIndex        =   48
      Top             =   2160
      Width           =   1740
   End
   Begin VB.Line lbLine1 
      BorderColor     =   &H00808080&
      X1              =   2220
      X2              =   6180
      Y1              =   3300
      Y2              =   3300
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
      TabIndex        =   47
      Top             =   2400
      Width           =   6960
   End
   Begin VB.Label lbSections 
      Caption         =   "Secciones :"
      Height          =   240
      Left            =   3780
      TabIndex        =   46
      Top             =   1020
      Width           =   960
   End
   Begin VB.Label lbFile 
      Caption         =   "Archivo :"
      Height          =   300
      Left            =   1260
      TabIndex        =   45
      Top             =   2160
      Width           =   840
   End
   Begin VB.Label lbFrameTop 
      BackColor       =   &H00FFFFFF&
      Height          =   1140
      Left            =   -180
      TabIndex        =   44
      Top             =   0
      Width           =   8220
   End
   Begin VB.Label lbFields 
      Caption         =   "Campos :"
      Height          =   240
      Left            =   240
      TabIndex        =   42
      Top             =   1020
      Width           =   840
   End
End
Attribute VB_Name = "fNewWizard"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' fNewWizard
' 04-02-2002

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
  ' constantes
  ' estructuras
  ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "fNewWizard"

' Paso 4
Private Const c_Headers = "s0"
Private Const c_GroupHeaders = "s1"
Private Const c_Details = "s2"
Private Const c_GroupFooters = "s3"
Private Const c_Footers = "s4"
Private Const c_SectionNode = "s"

Private Enum csImgSec
  Header = 4
  Detail = 5
  Footer = 6
  Group = 7
  Field = 3
End Enum

Private Enum csImgDataSource
  imgTbl = 10
  imgView = 11
  imgSp = 12
End Enum
' estructuras
' variables privadas
Private m_Showed As Boolean
Private m_CurrStep As csStepsWizardNew

' Pasos
' Paso 0
Private m_Choice As csNewWizardChoice
' Paso 1
Private m_ChoiceDb As csNewWizardChoiceDb
' Paso 2.1
Private m_FileName As String
' Paso 2.2
Private m_DataBasesLoaded As Boolean
Private m_strConnect As String
' Paso 2.3
Private m_DataBase As String
Private m_Server As String
Private m_User As String
Private m_Password As String
' Paso 3
Private m_DataSource As String
Private m_DataSourceType As CSConnect2.csDataSourceType
' Paso 3.1
Private m_CtlParameters As Collection
Private m_lbParameters As Collection
' Paso 4
Private m_Parameters As CSConnect2.cParameters
Private m_Report As CSReportDll2.cReport
Private WithEvents m_fGroup As fGroup
Attribute m_fGroup.VB_VarHelpID = -1
Private m_NextNameCtrl As Long ' Nombres

' eventos
Public Event Cancel()
Public Event GoToBack()
Public Event GoToNext()
Public Event FinalizeWizard(ByRef Report As CSReportDll2.cReport)
' propiedades publicas

Public Property Get Showed() As Boolean
  Showed = m_Showed
End Property

' Pasos
  ' Paso 0
Public Property Get Choice() As csNewWizardChoice
  Choice = m_Choice
End Property

' Paso 1
Public Property Get ChoiceDb() As csNewWizardChoiceDb
  ChoiceDb = m_ChoiceDb
End Property

' Paso 2.1
Public Property Get FileName() As String
  FileName = m_FileName
End Property

' Paso 2.2
Public Property Get strConnect() As String
  strConnect = m_strConnect
End Property

' Paso 3
Public Property Get DataSource() As String
  DataSource = m_DataSource
End Property

Public Property Get DataSourceType() As CSConnect2.csDataSourceType
  DataSourceType = m_DataSourceType
End Property

' Paso 3.1
Public Property Get Parameters() As CSConnect2.cParameters
   Set Parameters = m_Parameters
End Property

Public Property Set Parameters(ByRef rhs As CSConnect2.cParameters)
    Set m_Parameters = rhs
End Property

Public Property Get sqlParameters() As String
  Dim s As String
  Dim i As Long
  Dim c As CSMaskEdit2.cMaskEdit
  For i = 1 To m_CtlParameters.Count
    Set c = m_CtlParameters(i)
    With c
      Select Case .Tag
        Case "T"
          s = s & "'" & Replace(.csValue, "'", "''") & "',"
        Case "N"
          s = s & GetNumberSql(.csValue) & ","
        Case "F"
          s = s & "'" & Format(.csValue, "yyyy/mm/dd hh:nn:ss") & "',"
      End Select

      m_Parameters.Item(i).Value = .csValue
    End With
  Next

  If Right$(s, 1) = "," Then s = Left$(s, Len(s) - 1)

  sqlParameters = s

End Property
' Paso 4
Public Property Get Report() As CSReportDll2.cReport
  If m_Report Is Nothing Then InitReport
  Set Report = m_Report
End Property

Public Property Set Report(ByRef rhs As CSReportDll2.cReport)
   Set m_Report = rhs
End Property

Public Property Get ShowingProperties() As Boolean
End Property

Public Property Let ShowingProperties(ByVal rhs As Boolean)
End Property

Public Property Get fGroup() As fGroup
  Set fGroup = m_fGroup
End Property

Public Property Set fGroup(ByRef rhs As fGroup)
  Set m_fGroup = rhs
End Property

Public Property Get DataHasChanged() As Boolean
End Property

Public Property Let DataHasChanged(ByVal rhs As Boolean)
End Property

  ' Paso 6
Public Property Get NextNameCtrl() As Long
  NextNameCtrl = m_NextNameCtrl
End Property

' propiedades privadas
' funciones publicas
Public Sub ShowControls(ByVal nStep As csStepsWizardNew)

  m_CurrStep = nStep

  Dim c As Control
  For Each c In Me.Controls
    If Not c Is cmdNext And _
       Not c Is cmdBack And _
       Not c Is cmdCancel And _
       Not c Is lbLineMain And _
       Not c Is lbFrameTop Then
       
       pSetVisible c
       
    End If
  Next

  If nStep = csStepsWizardNew.step_welcom Then
    lbTitle.Font.Size = 20.25
    
    lbTitle.Left = 2160
    lbTitle.Top = 120
    lbTitle.Width = 4740
    lbTitle.Height = 550
    
    lbDescrip.Left = 2325
    lbDescrip.Top = 660
    lbDescrip.Width = 5175
    lbDescrip.Height = 420
    
    lbFrame0.Visible = True
    lbLineMain.X1 = 2340
    lbLineMain.X2 = 5340 + lbLineMain.X1
    lbFrameTop.Height = 1140
    cmdBack.Visible = False
  Else
    lbTitle.Font.Size = 11.25
    
    lbTitle.Left = 120
    lbTitle.Top = 60
    lbTitle.Width = 4740
    lbTitle.Height = 380
    
    lbDescrip.Left = 240
    lbDescrip.Top = 420
    lbDescrip.Width = 6240
    lbDescrip.Height = 480
    
    lbLineMain.X1 = 80
    lbLineMain.X2 = Me.ScaleWidth - 80
    lbFrameTop.Height = 915
    cmdBack.Visible = True
  End If

  Select Case nStep
    Case csStepsWizardNew.step_welcom
      picWelcom.ZOrder
      picWelcom.Visible = True
      picStep0.ZOrder
      lbChoice.Visible = True
      lbCreateReport.Visible = True
      opBlankReport.Visible = True
      opUseWizard.Visible = True
      lbTitle.Caption = "Crear un reporte"
      lbDescrip.Caption = "Este asistente lo guiara por una serie pasos que le permitiran generar un reporte en pocos minutos."
      picStep0.Visible = True
      frStep0.Visible = True
      Me.Caption = "Asistente"

    Case csStepsWizardNew.step_choice_db
      picStep1.Visible = True
      opAccess.Visible = True
      opSQL.Visible = True
      opOleDB.Visible = True
      lbTitle.Caption = "Elegir el tipo de base de datos"
      lbDescrip.Caption = "Puede crear una conexión con una base Access o Sql Server, o puede indicar cualquier origen de datos para la que cuente con un Proveedor OLEDB."
      frStep1.Visible = True
      Me.Caption = "Asistente - Paso 1"

    Case csStepsWizardNew.step_open_db
      Select Case m_ChoiceDb

        Case csNewWizardChoiceDb.csChoiceAccess
          TxFileName.Visible = True
          lbFile.Visible = True
          lbTitle.Caption = "Base de datos Access"
          lbDescrip.Caption = "Debe indicar el nombre y la ubicación de la archivo."

        Case csNewWizardChoiceDb.csChoiceSQL
          txUserSql.Visible = True
          txPassword.Visible = True
          cbServers.Visible = True
          cbDataBases.Visible = True
          lbUser.Visible = True
          lbServer.Visible = True
          lbLine1.Visible = True
          lbLine2.Visible = True
          lbDataBase.Visible = True
          opNT.Visible = True
          opSQLSecurity.Visible = True
          frStep22.Visible = True
          lbTitle.Caption = "Base de datos SQL Server"
          lbDescrip.Caption = "Debe indicar el nombre del servidor, de la base de datos y el metodo de autentificación a utilizar."

        Case csNewWizardChoiceDb.csChoiceOLEDB
          TxStrConnect.Visible = True
          lbStrConnect.Visible = True
          lbTitle.Caption = "Base de datos OLEDB"
          lbDescrip.Caption = "Debe indicar un string de conexión"
      End Select
      Me.Caption = "Asistente - Paso 2"

    Case csStepsWizardNew.step_choice_source
      opSp.Visible = True
      opSqlstmt.Visible = True
      opTable.Visible = True
      lvTables.Visible = True
      lvSps.Visible = True
      TxSqlstmt.Visible = True
      lbTitle.Caption = "Origen de los datos"
      lbDescrip.Caption = "Debe elegir una tabla, una consulta, o una sentencia sql, a partir de la que se generará el reporte."

      Me.Caption = "Asistente - Paso 3"

    Case csStepsWizardNew.step_set_parameters
      LoadParameters

      lbTitle.Caption = "Parametros de la consulta"
      lbDescrip.Caption = "Debe dar un valor para cada parametro que recibe la consulta o puede asignar un Null."

      Me.Caption = "Asistente - Paso 3.1"

    Case csStepsWizardNew.step_add_fields
      lbSections.Visible = True
      lbFields.Visible = True
      cmdAdd.Visible = True
      cmdNew.Visible = True
      cmdDelete.Visible = True
      lvColumns.Visible = True
      tvReport.Visible = True
      lbTitle.Caption = "Agregar secciones, grupos y campos al reporte"
      lbDescrip.Caption = "Haga clic en una seccion y agrege los campos que desee incluir en ella. Tambien puede agregar nuevas secciones."

      Me.Caption = "Asistente - Paso 4"

    Case csStepsWizardNew.step_add_formulas
      lbSections.Visible = True
      lbFields.Visible = True
      cmdAdd.Visible = True
      cmdDelete.Visible = True
      lvColumns.Visible = True
      tvReport.Visible = True
      lbTitle.Caption = "Agregar formulas"
      lbDescrip.Caption = "Haga clic en una seccion y agrege las formulas que desee incluir en ella."

      Me.Caption = "Asistente - Paso 5"

    Case csStepsWizardNew.step_finish
      lbFinish1.Visible = True
      lbFinish2.Visible = True
      lbTitle.Caption = "Generar el reporte"
      lbDescrip.Caption = "El asistente esta listo para crear el nuevo reporte."
      cmdEnd.Visible = True
      cmdEnd.ZOrder

      Me.Caption = "Asistente - Paso 6"
  End Select
  
  lbTitle.Visible = True
  lbDescrip.Visible = True
End Sub

' Paso 4
Public Sub AddSection(ByVal TypeSection As CSReportDll2.csRptTypeSection)
End Sub
Public Sub FillLists(ByVal TypeFill As csWizarTypeFill)
  Dim Sec As CSReportDll2.cReportSection

  Dim lvItem As ListItem
  Dim tvItem As Node


  lvColumns.Sorted = False
  lvColumns.ColumnHeaders.Clear
  lvColumns.ListItems.Clear
  tvReport.Nodes.Clear

  lvColumns.ColumnHeaders.Add , , "Campos", lvColumns.Width - 10, vbLeftJustify

  Set tvItem = tvReport.Nodes.Add(, , c_Headers, "Encabezados")
  tvItem.Image = 1
  tvItem.SelectedImage = 1
  tvItem.Tag = c_Headers

  Set tvItem = tvReport.Nodes.Add(, , c_GroupHeaders, "Grupos-Encabezados")
  tvItem.Image = 1
  tvItem.SelectedImage = 1
  tvItem.Tag = c_GroupHeaders

  Set tvItem = tvReport.Nodes.Add(, , c_Details, "Detalle")
  tvItem.Image = 1
  tvItem.SelectedImage = 1
  tvItem.Tag = c_Details

  Set tvItem = tvReport.Nodes.Add(, , c_GroupFooters, "Grupos-Pies")
  tvItem.Image = 1
  tvItem.SelectedImage = 1
  tvItem.Tag = c_GroupFooters

  Set tvItem = tvReport.Nodes.Add(, , c_Footers, "Pies de pagina")
  tvItem.Image = 1
  tvItem.SelectedImage = 1
  tvItem.Tag = c_Footers

  For Each Sec In m_Report.Headers
    Set tvItem = tvReport.Nodes.Add(c_Headers, tvwChild, Sec.Key, Sec.Name)
    tvItem.Image = csImgSec.Header
    tvItem.SelectedImage = csImgSec.Header
    tvItem.Tag = Sec.Key
    If TypeFill = csWizarTypeFill.FillWithFields Then
      FillSectionsWithFields tvItem, Sec
    Else
      FillSectionsWithFormulas tvItem, Sec
    End If
  Next

  For Each Sec In m_Report.GroupsHeaders
    Set tvItem = tvReport.Nodes.Add(c_GroupHeaders, tvwChild, Sec.Key, Sec.Name)
    tvItem.Image = csImgSec.Group
    tvItem.SelectedImage = csImgSec.Group
    tvItem.Tag = Sec.Key
    If TypeFill = csWizarTypeFill.FillWithFields Then
      FillSectionsWithFields tvItem, Sec
    Else
      FillSectionsWithFormulas tvItem, Sec
    End If
  Next

  For Each Sec In m_Report.Details
    Set tvItem = tvReport.Nodes.Add(c_Details, tvwChild, Sec.Key, Sec.Name)
    tvItem.Image = csImgSec.Detail
    tvItem.SelectedImage = csImgSec.Detail
    tvItem.Tag = Sec.Key
    If TypeFill = csWizarTypeFill.FillWithFields Then
      FillSectionsWithFields tvItem, Sec
    Else
      FillSectionsWithFormulas tvItem, Sec
    End If
  Next

  For Each Sec In m_Report.GroupsFooters
    Set tvItem = tvReport.Nodes.Add(c_GroupFooters, tvwChild, Sec.Key, Sec.Name)
    tvItem.Image = csImgSec.Group
    tvItem.SelectedImage = csImgSec.Group
    tvItem.Tag = Sec.Key
    If TypeFill = csWizarTypeFill.FillWithFields Then
      FillSectionsWithFields tvItem, Sec
    Else
      FillSectionsWithFormulas tvItem, Sec
    End If
  Next

  For Each Sec In m_Report.Footers
    Set tvItem = tvReport.Nodes.Add(c_Footers, tvwChild, Sec.Key, Sec.Name)
    tvItem.Image = csImgSec.Footer
    tvItem.SelectedImage = csImgSec.Footer
    tvItem.Tag = Sec.Key
    If TypeFill = csWizarTypeFill.FillWithFields Then
      FillSectionsWithFields tvItem, Sec
    Else
      FillSectionsWithFormulas tvItem, Sec
    End If
  Next

  If TypeFill = csWizarTypeFill.FillWithFields Then
    FillFields
  Else
    FillFormulas
    lvColumns.Sorted = True
  End If
End Sub
' funciones friend
' funciones privadas

' Controles

' Paso 2.2
Private Sub opNT_Click()
  If opNT.Value Then
    txPassword.Enabled = False
    txUserSql.Enabled = False
    txPassword.BackColor = vbButtonFace
    txUserSql.BackColor = vbButtonFace
  End If
  m_DataBasesLoaded = False
End Sub

Private Sub opSQLSecurity_Click()
  If opSQLSecurity.Value Then
    txPassword.Enabled = True
    txUserSql.Enabled = True
    txPassword.BackColor = vbWindowBackground
    txUserSql.BackColor = vbWindowBackground
  End If
  m_DataBasesLoaded = False
End Sub

Private Sub cbDataBases_DropDown()
  ' Hay que intentar conectarse para
  ' cargar las bases de datos
  If Not m_DataBasesLoaded Then
    LoadDatabases
  End If
End Sub

Private Sub cbServers_Click()
  m_DataBasesLoaded = False
End Sub

Private Sub txUserSql_Change()
  m_DataBasesLoaded = False
End Sub

Private Sub txPassword_Change()
  m_DataBasesLoaded = False
End Sub

Private Sub LoadDatabases()
  On Error GoTo ControlError

  cbDataBases.Clear

  If Trim(cbServers.Text) = vbNullString Then Exit Sub

  Dim cn As ADODB.Connection
  Dim strConnect As String
  strConnect = "Provider=SQLOLEDB.1;"
  'strConnect = strConnect & "Initial Catalog=" & cbDataBases.Text & ";"
  strConnect = strConnect & "Data Source=" & cbServers.Text & ";"

  If opNT.Value Then
    strConnect = strConnect & "Persist Security Info=False;Integrated Security=SSPI;"

  Else

    If Trim(txUserSql.Text) = vbNullString Then Exit Sub

    strConnect = strConnect & "Password=" & txPassword.Text & ";Persist Security Info=True;User ID=" & txUserSql.Text & ";"
  End If

  Set cn = New ADODB.Connection
  cn.Open (strConnect)
  Dim rs As ADODB.Recordset
  Set rs = cn.OpenSchema(ADODB.SchemaEnum.adSchemaCatalogs)

  While Not rs.EOF
    cbDataBases.AddItem rs.Fields(0).Value
    rs.MoveNext
  Wend

  m_DataBasesLoaded = True

  GoTo ExitProc
ControlError:
  MngError Err(), "txPassword_Change", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
  If Not rs Is Nothing Then
    If rs.State <> ADODB.ObjectStateEnum.adStateClosed Then
      rs.Close
    End If
  End If
  If Not cn Is Nothing Then
    If cn.State <> ADODB.ObjectStateEnum.adStateClosed Then
      cn.Close
    End If
  End If
End Sub

  ' Paso 2.3
Private Sub TxStrConnect_ButtonClick(ByRef Cancel As Boolean)
  Cancel = True
  Connect
End Sub

Private Sub Connect()
  Dim oConnect As CSConnect2.cConnect
  Set oConnect = New CSConnect2.cConnect

  TxStrConnect.Text = oConnect.GetNewConnect()

  If TxStrConnect.Text = vbNullString Then
    m_strConnect = vbNullString
    m_DataBase = vbNullString
    m_Server = vbNullString
    m_User = vbNullString
    m_Password = vbNullString
  Else
    With oConnect
      m_strConnect = .strConnect
      m_DataBase = .Database
      m_Server = .Server
      m_User = .User
      m_Password = .Password
    End With
  End If
End Sub
  ' Paso 3
  
Public Function ShowSchema(ByVal strConnect As String) As Boolean
  Dim rs As ADODB.Recordset
  Dim Num As Long
  Dim cn As New ADODB.Connection
  Dim Mouse As New CSKernelClient2.cMouseWait

  On Error Resume Next

  cn.Open (strConnect)

  If Err.Number <> 0 Then
    MngError Err(), "fDBInfo.ShowSchema", C_Module, "Fallo la conexion. Si ud esta conectandose a SQL Server debe marcar el checkbox 'Allow saving password'", "Fallo al abrir la conexión", , csErrorAdo, cn
    Exit Function
  End If

  Set rs = cn.OpenSchema(ADODB.SchemaEnum.adSchemaTables)
  'TABLE_CATALOG = rs.fields(0)
  'TABLE_SCHEMA = rs.fields(1)
  'TABLE_NAME = rs.fields(2)
  'TABLE_TYPE = rs.fields(3)
  Dim lvItem As ListItem

  Do While Not rs.EOF

    Select Case LCase(rs.Fields(3).Value)

      Case "table", "system table"
        Set lvItem = lvTables.ListItems.Add(, , rs.Fields(2).Value)
        lvItem.SmallIcon = csImgDataSource.imgTbl
      Case "view"
        Set lvItem = lvTables.ListItems.Add(, , rs.Fields(2).Value)
        lvItem.SmallIcon = csImgDataSource.imgView

    End Select

    rs.MoveNext

  Loop

  Set rs = cn.OpenSchema(ADODB.SchemaEnum.adSchemaProcedures)
  'PROCEDURE_CATALOG = rs(0)
  'PROCEDURE_SCHEMA = rs(1)
  'PROCEDURE_NAME =rs(2)
  'PROCEDURE_TYPE = rs(3)

  Do While Not rs.EOF
    Set lvItem = lvSps.ListItems.Add(, , Replace(rs.Fields(2).Value, ";1", vbNullString))
    lvItem.SmallIcon = csImgDataSource.imgSp
    rs.MoveNext
  Loop

  cn.Close

  ShowSchema = True
End Function

Private Sub opTable_Click()
  EnabledControls
End Sub

Private Sub opSqlstmt_Click()
  EnabledControls
End Sub

Private Sub opSp_Click()
  EnabledControls
End Sub

Private Sub EnabledControls()
  If opTable.Value Then
    lvTables.BackColor = vbWindowBackground
    lvTables.Enabled = True
  Else
    lvTables.BackColor = vbButtonFace
    lvTables.Enabled = False
  End If
  If opSp.Value Then
    lvSps.BackColor = vbWindowBackground
    lvSps.Enabled = True
  Else
    lvSps.BackColor = vbButtonFace
    lvSps.Enabled = False
  End If
  If opSqlstmt.Value Then
    TxSqlstmt.BackColor = vbWindowBackground
    TxSqlstmt.Enabled = True
  Else
    TxSqlstmt.BackColor = vbButtonFace
    TxSqlstmt.Enabled = False
  End If
End Sub
' Paso 3.1

Private Function GetNumberSql(ByVal sNumber As String) As String
  If Not IsNumeric(sNumber) Then
    GetNumberSql = "0"
  Else
    sNumber = Format(sNumber, String(27, "#") & "0." & String(28, "#"))
    sNumber = Replace(sNumber, ",", ".")
    If Right$(sNumber, 1) = "." Then sNumber = Left$(sNumber, Len(sNumber) - 1)
    GetNumberSql = sNumber
  End If
End Function
  
Private Sub LoadParameters()
  Dim oParameter  As CSConnect2.cParameter
  Dim i           As Long
  Dim nTop        As Long
  Dim Value       As Variant

  UnLoadParameters
  nTop = 1080
  
  For Each oParameter In m_Parameters
    i = i + 1

    m_CtlParameters.Add Me.Controls.Add("CSMaskEdit2.cMaskEdit", "MASK_" & i)
    m_lbParameters.Add Me.Controls.Add("VB.Label", "LBL_" & i)

    With m_lbParameters(i)
      .Top = nTop
      .Visible = True
      .Caption = oParameter.Name & " :"
      .Left = 240
      .Width = 1500
      .Height = 270
    End With

    With m_CtlParameters(i)
      .Left = m_lbParameters(i).Left + m_lbParameters(i).Width + 5
      .Top = nTop
      .Height = 270
      nTop = nTop + .Height + 100
      .Visible = True
      .Tag = oParameter.Key
      .MaxLength = 0
      .BorderType = CSMaskEdit2.cSingle
      
      Value = oParameter.Value

      Select Case oParameter.TypeColumn
        Case adLongVarChar, adLongVarWChar, adChar, adVarChar, adVarWChar, adWChar
          .csType = CSMaskEdit2.csMkText
          .MaxLength = .MaxLength
          .Width = 2250
          .Tag = "T"
          .ButtonStyle = CSMaskEdit2.cButtonNone
        Case adInteger, adBigInt, adBinary, adNumeric, adLongVarBinary, adSmallInt, adTinyInt, adUnsignedBigInt, adUnsignedInt, adUnsignedSmallInt, adUnsignedTinyInt
          .csType = CSMaskEdit2.csMkInteger
          .Width = 1500
          .Tag = "N"
          .csWithOutCalc = True
          .ButtonStyle = CSMaskEdit2.cButtonNone
        Case adBoolean
          .csType = CSMaskEdit2.csMkInteger
          .MaxLength = 1
          .Width = 255
          .Tag = "N"
          .csWithOutCalc = True
          .csWithOutButton = True
        Case adCurrency, adSingle, adDecimal, adNumeric, adDouble
          .csType = CSMaskEdit2.csMkDouble
          .Width = 1500
          .Tag = "N"
          .csWithOutCalc = True
          .csWithOutButton = True
        Case adDBTime, adDate, adDBDate, adDBTimeStamp
          .csType = CSMaskEdit2.csMkDate
          .csValue = Format(Now, "dd/MM/yyyy")
          .Width = 2250
          .Tag = "F"
          If Not IsDate(Value) Then
            Value = Format(Now, "dd/MM/yyyy")
          ElseIf Value = csNoFecha Then
            Value = Format(Now, "dd/MM/yyyy")
          End If

      End Select

      SetParamValue m_CtlParameters(i), Value
    End With
  Next

  On Error Resume Next
  m_CtlParameters(1).Focus
End Sub

Private Sub SetParamValue(ByRef o As Control, ByVal Val As Variant)
  On Error Resume Next
  o.Text = Val
End Sub

Private Sub UnLoadParameters()
  On Error Resume Next
  Dim i As Long

  Dim c As Control
  For Each c In Me.Controls
    If TypeOf c Is CSMaskEdit2.cMaskEdit Or TypeOf c Is Label Then
      If Left$(c.Name, 4) = "LBL_" Or Left$(c.Name, 5) = "MASK_" Then
        Me.Controls.Remove c
      End If
    End If
  Next

  For i = 1 To m_CtlParameters.Count
    m_CtlParameters.Remove 1
    m_lbParameters.Remove 1
  Next i
End Sub
' Paso 4

Private Sub cmdAdd_Click()
  On Error GoTo ControlError

  If lvColumns.SelectedItem Is Nothing Then Exit Sub

  Dim tvItem As Node

  If tvReport.SelectedItem Is Nothing Then Exit Sub

  ' Si esta en una carpeta no hago nada
  If Left$(tvReport.SelectedItem.Tag, 1) = c_SectionNode Then Exit Sub

  ' Obtengo una referencia al nodo
  Set tvItem = tvReport.SelectedItem

  Dim sKey As String
  Dim Sec As CSReportDll2.cReportSection
  Dim Group As CSReportDll2.cReportGroup

  Set Sec = GetSection(tvItem)
  If m_CurrStep = csStepsWizardNew.step_add_fields Then
    AddControl Sec, tvItem
  ElseIf m_CurrStep = csStepsWizardNew.step_add_formulas Then
    AddFormula Sec, tvItem
  End If

  tvItem.Expanded = True

  GoTo ExitProc
ControlError:
  MngError Err(), "cmdAdd_Click", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub cmdDelete_Click()
  On Error GoTo ControlError

  Dim tvItem As Node

  If tvReport.SelectedItem Is Nothing Then Exit Sub

  ' Si esta en una carpeta no hago nada
  If Left$(tvReport.SelectedItem.Tag, 1) = c_SectionNode Then Exit Sub

  Dim Sec As CSReportDll2.cReportSection

  ' Obtengo una referencia al nodo
  Set tvItem = tvReport.SelectedItem

  Set Sec = GetSection(tvItem)

  ' Obtengo una referencia al nodo
  ' esto es por que GetSection altera el puntero
  Set tvItem = tvReport.SelectedItem

  ' Si su padre no es una carpeta entonces
  ' se trata de un field
  If Left$(tvItem.Parent.Tag, 1) <> c_SectionNode Then
    Sec.SectionLines.Item(1).Controls.Remove tvItem.Tag
    tvReport.Nodes.Remove tvItem.Index

  ElseIf m_CurrStep = csStepsWizardNew.step_add_fields Then

    Select Case Sec.TypeSection
      Case CSReportDll2.csRptTpScHeader
        m_Report.Headers.Remove tvItem.Tag
      Case CSReportDll2.csRptTpGroupHeader
        m_Report.Groups.Remove tvItem.Tag
      Case CSReportDll2.csRptTpGroupFooter
        m_Report.Groups.Remove tvItem.Tag
      Case CSReportDll2.csRptTpScFooter
        m_Report.Footers.Remove tvItem.Tag
    End Select

    tvReport.Nodes.Remove tvItem.Index
  End If

  GoTo ExitProc
ControlError:
  MngError Err(), vbNullString, C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Function GetSection(ByVal tvItem As Node) As CSReportDll2.cReportSection
  Dim Sec As CSReportDll2.cReportSection
  Dim sKey As String

  ' Si su padre no es una carpeta entonces
  ' se trata de un field
  If Left$(tvItem.Parent.Tag, 1) <> c_SectionNode Then
    ' Obtengo una referencia a la seccion del field
    Set tvItem = tvItem.Parent
  End If

  ' Obtengo la clave de la seccion
  sKey = tvItem.Tag

  Select Case tvItem.Parent.Key

    Case c_Headers
      Set Sec = m_Report.Headers.Item(sKey)

    Case c_GroupHeaders
      Set Sec = m_Report.GroupsHeaders.Item(sKey)

    Case c_Details
      Set Sec = m_Report.Details.Item(sKey)

    Case c_GroupFooters
      Set Sec = m_Report.GroupsFooters.Item(sKey)

    Case c_Footers
      Set Sec = m_Report.Footers.Item(sKey)

  End Select

  Set GetSection = Sec

End Function

Private Sub cmdNew_Click()
  On Error GoTo ControlError
  Dim tvItem As Node
  If tvReport.SelectedItem Is Nothing Then Exit Sub

  If Left$(tvReport.SelectedItem.Tag, 1) = c_SectionNode Then
    Set tvItem = tvReport.SelectedItem
  Else
    Set tvItem = tvReport.SelectedItem.Parent
  End If

  Dim sKey As String
  Dim Sec As CSReportDll2.cReportSection
  Dim Group As CSReportDll2.cReportGroup

  Select Case tvItem.Tag

    Case c_Headers
      Set Sec = m_Report.Headers.Add(, sKey)
      Sec.Name = "Encabezado " & Sec.Indice
      Set tvItem = tvReport.Nodes.Add(tvItem.Key, tvwChild, Sec.Key, Sec.Name)
      tvItem.Image = csImgSec.Header
      tvItem.SelectedImage = csImgSec.Header
      tvItem.Tag = Sec.Key

    Case c_GroupHeaders, c_GroupFooters

      If Not ShowGroupProperties(Nothing, Me) Then Exit Sub

      Set Group = m_Report.Groups.Item(m_Report.Groups.Count)
      Group.Header.Name = "Encabezado " & Group.Indice
      Group.Footer.Name = "Pie " & Group.Indice

      Set tvItem = tvReport.Nodes.Add(c_GroupHeaders, tvwChild, Group.Header.Key, Group.Header.Name)
      tvItem.Image = csImgSec.Group
      tvItem.SelectedImage = csImgSec.Group
      tvItem.Tag = Group.Header.Key
      tvItem.Parent.Expanded = True

      Set tvItem = tvReport.Nodes.Add(c_GroupFooters, tvwChild, Group.Footer.Key, Group.Footer.Name)
      tvItem.Image = csImgSec.Group
      tvItem.SelectedImage = csImgSec.Group
      tvItem.Tag = Group.Footer.Key

    Case c_Footers
      Set Sec = m_Report.Footers.Add(, sKey)
      Sec.Name = "Pie " & Sec.Indice
      Set tvItem = tvReport.Nodes.Add(tvItem.Key, tvwChild, Sec.Key, Sec.Name)
      tvItem.Image = csImgSec.Footer
      tvItem.SelectedImage = csImgSec.Footer
      tvItem.Tag = Sec.Key
      
    Case c_Details
      MsgWarning "Esta funcionalidad no esta implementada para detalles"
      Exit Sub
  End Select

  tvItem.Parent.Expanded = True

  GoTo ExitProc
ControlError:
  MngError Err(), "cmdNew_Click", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub m_fGroup_ShowHelpDbField()
  Dim nIndex As Long
  Dim nFieldType As Long
  Dim sField As String

  With m_fGroup
    sField = .TxDbField.Text
    nFieldType = .FieldType
    nIndex = .Index

    If Not ShowDbFields(sField, nFieldType, nIndex, Me) Then Exit Sub

    .TxDbField.Text = sField
    .FieldType = nFieldType
    .Index = nIndex

  End With
End Sub

Private Sub m_fGroup_UnloadForm()
  Set m_fGroup = Nothing
End Sub

Private Function InitReport()
  Dim oLaunchInfo As CSReportDll2.cReportLaunchInfo
  Set m_Report = New CSReportDll2.cReport
  Set oLaunchInfo = New CSReportDll2.cReportLaunchInfo

  With m_Report.PaperInfo
    .PaperSize = GetPaperType(Me.hwnd, fMain.PrinterName)
    .Orientation = GetPrinterOrientation(Me.hwnd, fMain.PrinterName)
  End With
'  m_Report.PaperInfo.Tipo = Printer.PaperSize
'  m_Report.PaperInfo.Orientation = Printer.Orientation
  
  Set oLaunchInfo.Printer = GetcPrinterFromDefaultPrinter
  Set oLaunchInfo.ObjPaint = New CSReportPaint2.cReportPrint
  m_Report.Init oLaunchInfo
  
  Dim tR As Rectangle
  tR = GetRectFromPaperSize(fMain, fMain.PaperSize, fMain.Orientation)
  CreateStandarSections m_Report, tR  'GetRectFromPrinter(Printer)
End Function

Private Sub FillSectionsWithFields(ByRef tvItem As Node, ByRef Sec As CSReportDll2.cReportSection)
  Dim SecL As CSReportDll2.cReportSectionLine
  Dim Ctrl As CSReportDll2.cReportControl

  For Each SecL In Sec.SectionLines
    For Each Ctrl In SecL.Controls
      AddControlToTree tvItem, Ctrl
    Next
  Next
End Sub

Private Sub AddControl(ByRef Sec As CSReportDll2.cReportSection, ByRef tvItem As Node)
  Dim Ctrl As CSReportDll2.cReportControl
  Dim i As Long
  Dim Col As CSReportDll2.cColumnInfo

  For i = 1 To lvColumns.ListItems.Count

    If lvColumns.ListItems(i).Selected Then
      Set Ctrl = Sec.SectionLines.Item(1).Controls.Add()
  
      ' Luego defino que es y le cargo la info
      m_NextNameCtrl = m_NextNameCtrl + 1
      Ctrl.Name = C_Control_Name & m_NextNameCtrl
      Ctrl.Label.Aspect.Align = vbLeftJustify
  
      Set Col = m_Report.Connect.Columns.Item(lvColumns.ListItems(i).Tag)
  
      With Ctrl.Field
        .FieldType = Col.TypeColumn
        .Name = Col.Name
        .Index = Col.Position
      End With
  
      Ctrl.ControlType = CSReportDll2.csRptCtField
      Ctrl.Label.Text = Col.Name
  
      If IsNumberField(Col.TypeColumn) Then
        With Ctrl.Label.Aspect
          .Align = vbRightJustify
          .Format = "#0.00;-#0.00"
        End With
      End If
  
      AddControlToTree tvItem, Ctrl
    End If
  Next
End Sub

Private Sub AddControlToTree(ByRef tvItem As Node, ByRef Ctrl As CSReportDll2.cReportControl)
  Dim tvItemField As Node
  Set tvItemField = tvReport.Nodes.Add(tvItem, tvwChild, Ctrl.Key, Ctrl.Label.Text)
  tvItemField.Image = csImgSec.Field
  tvItemField.SelectedImage = csImgSec.Field
  tvItemField.Tag = Ctrl.Key
End Sub

Private Sub FillFields()
  Dim lvItem As ListItem
  Dim Col As CSReportDll2.cColumnInfo

  Dim i As Long
  For Each Col In m_Report.Connect.Columns
    i = i + 1
    Set lvItem = lvColumns.ListItems.Add(, , Col.Name)
    lvItem.Tag = i
    lvItem.SmallIcon = csImgSec.Field
  Next

  pExpandAllNodes tvReport
End Sub

  ' Paso 5
Private Sub FillFormulas()
  Dim lvItem As ListItem
  Dim i As Long
  Dim Ctrl As CSReportDll2.cReportControl

  For Each Ctrl In m_Report.Controls
    With Ctrl
      If IsNumberField(.Field.FieldType) Then
          ' Esto no es lo mas prolijo pero
          ' tomando en cuenta los tiempos
          ' por ahora queda asi. Lo correcto
          ' seria establecer algun mecanismo
          ' para indicar en la definicion de la
          ' formula que puede ser propuesta en
          ' el asistente.
          Set lvItem = lvColumns.ListItems.Add(, , "Suma de " & .Field.Name)
          lvItem.Tag = "_Sum(" & .Name & ")"
          lvItem.SmallIcon = csImgSec.Field

          Set lvItem = lvColumns.ListItems.Add(, , "Máximo de " & .Field.Name)
          lvItem.Tag = "_Max(" & .Name & ")"
          lvItem.SmallIcon = csImgSec.Field

          Set lvItem = lvColumns.ListItems.Add(, , "Minimo de " & .Field.Name)
          lvItem.Tag = "_Min(" & .Name & ")"
          lvItem.SmallIcon = csImgSec.Field

          Set lvItem = lvColumns.ListItems.Add(, , "Promedio " & .Field.Name)
          lvItem.Tag = "_Average(" & .Name & ")"
          lvItem.SmallIcon = csImgSec.Field

      End If
    End With
  Next Ctrl

  pExpandAllNodes tvReport
End Sub

Private Sub FillSectionsWithFormulas(ByRef tvItem As Node, ByRef Sec As CSReportDll2.cReportSection)
  Dim SecL As CSReportDll2.cReportSectionLine
  Dim Ctrl As CSReportDll2.cReportControl

  For Each SecL In Sec.SectionLines
    For Each Ctrl In SecL.Controls
      If Ctrl.ControlType = CSReportDll2.csRptCtLabel Then
        If Ctrl.HasFormulaValue Then
          AddFormulaToTree tvItem, Ctrl
        End If
      End If
    Next
  Next
End Sub

Private Sub AddFormula(ByRef Sec As CSReportDll2.cReportSection, ByRef tvItem As Node)
  Dim Ctrl As CSReportDll2.cReportControl
  Dim i As Long
  Dim sFormula As String

  For i = 1 To lvColumns.ListItems.Count

    If lvColumns.ListItems(i).Selected Then
      Set Ctrl = Sec.SectionLines.Item(1).Controls.Add()
  
      ' Luego defino que es y le cargo la info
      m_NextNameCtrl = m_NextNameCtrl + 1
      Ctrl.Name = C_Control_Name & m_NextNameCtrl
      Ctrl.Label.Aspect.Align = vbLeftJustify
  
      sFormula = lvColumns.ListItems(i).Tag
  
      With Ctrl
        .ControlType = CSReportDll2.csRptCtLabel
        .FormulaValue.Text = sFormula
        .HasFormulaValue = True
        .Label.Aspect.Format = "0.00;-0.00"
        .Label.Aspect.Font.Bold = True
        .Label.Text = lvColumns.ListItems(i).Text
        .Label.Aspect.Align = vbRightJustify
      End With
  
      AddFormulaToTree tvItem, Ctrl
    End If
  Next
End Sub

Private Sub AddFormulaToTree(ByRef tvItem As Node, ByRef Ctrl As CSReportDll2.cReportControl)
  Dim tvItemField As Node
  Set tvItemField = tvReport.Nodes.Add(tvItem.Key, tvwChild, Ctrl.Key, Ctrl.Label.Text)
  tvItemField.Image = csImgSec.Field
  tvItemField.SelectedImage = csImgSec.Field
  tvItemField.Tag = Ctrl.Key
End Sub

Private Function GetFormulaName(ByVal sFormula As String) As String
  If InStr(sFormula, "Sum_(", vbTextCompare) Then
    GetFormulaName = "Sum_"
  ElseIf InStr(sFormula, "Max_(", vbTextCompare) Then
    GetFormulaName = "Max_"
  ElseIf InStr(sFormula, "Min_(", vbTextCompare) Then
    GetFormulaName = "Min_"
  ElseIf InStr(sFormula, "Average_(", vbTextCompare) Then
    GetFormulaName = "Average_"
  End If
End Function

' Pasos
Private Sub Step0()
  If opUseWizard.Value Then
    m_Choice = csNewWizardChoice.csChoiceUseWizard
  Else
    m_Choice = csNewWizardChoice.csChoiceBlankReport
  End If
End Sub

Private Sub Step1()
  If opAccess.Value Then
    m_ChoiceDb = csNewWizardChoiceDb.csChoiceAccess
  ElseIf opSQL.Value Then
    m_ChoiceDb = csNewWizardChoiceDb.csChoiceSQL
  Else 'opOleDB.value
    m_ChoiceDb = csNewWizardChoiceDb.csChoiceOLEDB
  End If
End Sub

Private Function Step2() As Boolean
  Select Case m_ChoiceDb
    Case csNewWizardChoiceDb.csChoiceAccess
      Step2 = Step21()
    Case csNewWizardChoiceDb.csChoiceSQL
      Step2 = Step22()
    Case csNewWizardChoiceDb.csChoiceOLEDB
      Step2 = Step23()
  End Select
End Function

Private Function Step21() As Boolean
  m_FileName = Trim(TxFileName.Text)
  If m_FileName = vbNullString Then
    MsgWarning ("Debe indicar el nombre y la ubicación de un archivo Microsoft Access.")
    Exit Function
  End If
  Step21 = True
End Function

Private Function Step22() As Boolean
  If Trim(cbServers.Text) = vbNullString Then
    MsgWarning ("Debe indicar un server SQL")
    Exit Function
  End If

  If Trim(cbDataBases.Text) = vbNullString Then
    MsgWarning ("Debe indicar una base de datos")
    Exit Function
  End If

  m_strConnect = "Provider=SQLOLEDB.1;"
  m_strConnect = m_strConnect & "Initial Catalog=" & cbDataBases.Text & ";"
  m_strConnect = m_strConnect & "Data Source=" & cbServers.Text & ";"

  If opNT.Value Then
    m_strConnect = m_strConnect & "Persist Security Info=False;Integrated Security=SSPI;"

  Else

    If Trim(txUserSql.Text) = vbNullString Then
      MsgWarning ("Debe indicar un usuario de SQL")
      Exit Function
    End If

    m_strConnect = m_strConnect & "Password=" & txPassword.Text & ";Persist Security Info=True;User ID=" & txUserSql.Text & ";"
  End If
  Step22 = True
End Function

Private Function Step23() As Boolean
  m_strConnect = Trim(TxStrConnect.Text)
  If m_strConnect = vbNullString Then
    MsgWarning ("Debe indicar una cadena de conexion")
    Exit Function
  End If
  Step23 = True
End Function

Private Function Step3() As Boolean
  If opTable.Value Then
    If lvTables.SelectedItem Is Nothing Then
      MsgWarning ("Debe seleccionar una tabla")
      Exit Function
    End If
    m_DataSourceType = CSConnect2.csDataSourceType.csDTTable
    m_DataSource = lvTables.SelectedItem.Text
  ElseIf opSp.Value Then
    If lvSps.SelectedItem Is Nothing Then
      MsgWarning ("Debe seleccionar una consulta")
      Exit Function
    End If
    m_DataSourceType = CSConnect2.csDataSourceType.cdDTProcedure
    m_DataSource = lvSps.SelectedItem.Text
  Else
    If Trim(TxSqlstmt.Text) = vbNullString Then
      MsgWarning ("Debe indicar una sentencia sql")
      Exit Function
    End If
    m_DataSource = TxSqlstmt.Text
    m_DataSourceType = CSConnect2.csDataSourceType.cdDTSqlstmt
  End If
  Step3 = True
End Function

' Eventos de navegación
Private Sub cmdNext_Click()
  Select Case m_CurrStep

    Case csStepsWizardNew.step_welcom
      Step0
    Case csStepsWizardNew.step_choice_db
      Step1
    Case csStepsWizardNew.step_open_db
      If Not Step2() Then Exit Sub
    Case csStepsWizardNew.step_choice_source
      If Not Step3() Then Exit Sub
  End Select

  RaiseEvent GoToNext
End Sub

Private Sub cmdEnd_Click()
  RaiseEvent FinalizeWizard(m_Report)
End Sub

Private Sub cmdBack_Click()
  RaiseEvent GoToBack
End Sub

Private Sub cmdCancel_Click()
  RaiseEvent Cancel
End Sub

Private Sub pExpandAllNodes(ByRef tvTree As TreeView)
  Dim i As Long
  
  For i = 1 To tvTree.Nodes.Count
    tvTree.Nodes(i).Expanded = True
  Next
End Sub

Private Sub pSetVisible(ByRef c As Control)
  On Error Resume Next
  c.Visible = False
End Sub

' construccion - destruccion
Private Sub Form_Load()

  opUseWizard.Value = True
  opAccess.Value = True
  opTable.Value = True
  opNT.Value = True
  cbServers.AddItem "(Local)"
  cbServers.ListIndex = 0

  lvTables.View = lvwReport
  lvTables.LabelEdit = False
  lvTables.ColumnHeaders.Add , , "Tablas", lvTables.Width - 18, vbLeftJustify

  lvSps.View = lvwReport
  lvSps.LabelEdit = False
  lvSps.ColumnHeaders.Add , , "Consultas", lvSps.Width - 18, vbLeftJustify

  lvColumns.View = lvwReport

  Set lvTables.SmallIcons = imlist
  Set lvSps.SmallIcons = imlist
  Set lvColumns.SmallIcons = Me.imlist

  Set m_CtlParameters = New Collection
  Set m_lbParameters = New Collection

  CenterForm Me
  
  m_Showed = True

  ' Paso 4 y Paso 5
  Set cmdAdd.Picture = imlist.ListImages(8).Picture
  Set cmdNew.Picture = imlist.ListImages(3).Picture
  Set cmdDelete.Picture = imlist.ListImages(9).Picture
  Set tvReport.ImageList = Me.imlist
  
  ' Paso 2.1
  TxFileName.FileFilter = "Archivos Microsoft Access|*.mdb|Todos los archivos|*.*"
End Sub

Private Sub Form_Unload(Cancel As Integer)
  m_Showed = False
End Sub


'//////////////////////////////
'  Codigo estandar de errores
'  On Error GoTo ControlError
'
'  GoTo ExitProc
'ControlError:
'  MngError err,"", C_Module, ""
'  If Err.Number Then Resume ExitProc
'ExitProc:
'  On Error Resume Next



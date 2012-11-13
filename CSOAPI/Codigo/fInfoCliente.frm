VERSION 5.00
Object = "{353A8433-36B8-422E-ABBD-36CEE8BE628E}#1.0#0"; "CSButton.ocx"
Object = "{757F6B6F-8057-4D0A-85C2-0A1807E33D34}#1.6#0"; "CSGrid2.ocx"
Begin VB.Form fInfoCliente 
   BackColor       =   &H80000005&
   Caption         =   "Info Cliente"
   ClientHeight    =   7035
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   9075
   Icon            =   "fInfoCliente.frx":0000
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   ScaleHeight     =   7035
   ScaleWidth      =   9075
   StartUpPosition =   3  'Windows Default
   Begin CSButton.cButtonLigth cmdHlCliente 
      Height          =   315
      Left            =   5775
      TabIndex        =   31
      Top             =   165
      Width           =   240
      _ExtentX        =   423
      _ExtentY        =   556
      Caption         =   "..."
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
      ForeColor       =   0
   End
   Begin VB.TextBox txHlCliente 
      BorderStyle     =   0  'None
      Height          =   285
      Left            =   855
      TabIndex        =   30
      Top             =   180
      Width           =   5025
   End
   Begin CSButton.cButton cmdTab 
      Height          =   330
      Index           =   1
      Left            =   90
      TabIndex        =   4
      Top             =   1440
      Width           =   1500
      _ExtentX        =   2646
      _ExtentY        =   582
      Caption         =   "&Resumen"
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
      BackColorPressed=   -2147483643
   End
   Begin CSButton.cButton cmdTab 
      Height          =   330
      Index           =   3
      Left            =   3060
      TabIndex        =   5
      Top             =   1440
      Width           =   1500
      _ExtentX        =   2646
      _ExtentY        =   582
      Caption         =   "&Partes"
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
      BackColorPressed=   -2147483643
   End
   Begin CSButton.cButton cmdTab 
      Height          =   330
      Index           =   2
      Left            =   1575
      TabIndex        =   22
      Top             =   1440
      Width           =   1500
      _ExtentX        =   2646
      _ExtentY        =   582
      Caption         =   "&Pedidos"
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
      BackColor       =   -2147483643
      BackColorPressed=   -2147483643
   End
   Begin VB.PictureBox picPedidos 
      BackColor       =   &H80000005&
      BorderStyle     =   0  'None
      Height          =   5100
      Left            =   135
      ScaleHeight     =   5100
      ScaleWidth      =   8430
      TabIndex        =   23
      Top             =   1800
      Width           =   8430
      Begin CSGrid2.cGrid grdPedidos 
         Height          =   1320
         Left            =   60
         TabIndex        =   24
         Top             =   2025
         Width           =   8250
         _ExtentX        =   14552
         _ExtentY        =   2328
         BackgroundPictureHeight=   0
         BackgroundPictureWidth=   0
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         BorderStyle     =   0
         DisableIcons    =   -1  'True
         RowOddColor     =   0
      End
      Begin CSGrid2.cGrid grdProductos 
         Height          =   1320
         Left            =   60
         TabIndex        =   25
         Top             =   3735
         Width           =   8250
         _ExtentX        =   14552
         _ExtentY        =   2328
         BackgroundPictureHeight=   0
         BackgroundPictureWidth=   0
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         BorderStyle     =   0
         DisableIcons    =   -1  'True
         RowOddColor     =   0
      End
      Begin VB.Image imgChartProducto 
         Height          =   1305
         Left            =   4455
         Top             =   360
         Width           =   3855
      End
      Begin VB.Shape shProductos 
         BorderColor     =   &H80000010&
         Height          =   1350
         Left            =   45
         Top             =   3720
         Width           =   8280
      End
      Begin VB.Label lbProductosTitle 
         BackStyle       =   0  'Transparent
         Caption         =   "Ultimos Artículos Comprados"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H80000011&
         Height          =   330
         Left            =   360
         TabIndex        =   29
         Top             =   3465
         Width           =   2670
      End
      Begin VB.Image imgProductos 
         Height          =   240
         Left            =   60
         Picture         =   "fInfoCliente.frx":058A
         Top             =   3420
         Width           =   240
      End
      Begin VB.Shape shPedidos 
         BorderColor     =   &H80000010&
         Height          =   1350
         Left            =   45
         Top             =   2010
         Width           =   8280
      End
      Begin VB.Label lbPedidosTitle 
         BackStyle       =   0  'Transparent
         Caption         =   "Pedidos/Remitos Pendientes"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H80000011&
         Height          =   330
         Left            =   360
         TabIndex        =   28
         Top             =   1755
         Width           =   3345
      End
      Begin VB.Image imgPedidos 
         Height          =   240
         Left            =   60
         Picture         =   "fInfoCliente.frx":0914
         Top             =   1710
         Width           =   240
      End
      Begin VB.Label lbPedidos 
         Alignment       =   1  'Right Justify
         BackStyle       =   0  'Transparent
         Caption         =   "9.999.999,00"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H80000010&
         Height          =   240
         Left            =   7110
         TabIndex        =   27
         Top             =   1755
         Width           =   1185
      End
      Begin VB.Shape shPedidosSaldo 
         BorderColor     =   &H80000010&
         Height          =   270
         Left            =   7020
         Top             =   1710
         Width           =   1305
      End
      Begin VB.Image imgChartEvol 
         Height          =   1305
         Left            =   90
         Top             =   360
         Width           =   4305
      End
      Begin VB.Label lbEvolucionTitle 
         BackStyle       =   0  'Transparent
         Caption         =   "Evolución"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H80000011&
         Height          =   330
         Left            =   360
         TabIndex        =   26
         Top             =   90
         Width           =   6810
      End
      Begin VB.Image imgEvolucion 
         Height          =   240
         Left            =   60
         Picture         =   "fInfoCliente.frx":0C9E
         Top             =   45
         Width           =   240
      End
   End
   Begin VB.PictureBox picResumen 
      BackColor       =   &H80000005&
      BorderStyle     =   0  'None
      Height          =   5100
      Left            =   135
      ScaleHeight     =   5100
      ScaleWidth      =   8430
      TabIndex        =   6
      Top             =   1845
      Width           =   8430
      Begin CSGrid2.cGrid grdCheques 
         Height          =   1320
         Left            =   60
         TabIndex        =   7
         Top             =   3735
         Width           =   8295
         _ExtentX        =   14631
         _ExtentY        =   2328
         BackgroundPictureHeight=   0
         BackgroundPictureWidth=   0
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         BorderStyle     =   0
         DisableIcons    =   -1  'True
         RowOddColor     =   0
      End
      Begin CSGrid2.cGrid grdCobranzas 
         Height          =   1320
         Left            =   60
         TabIndex        =   8
         Top             =   2025
         Width           =   8295
         _ExtentX        =   14631
         _ExtentY        =   2328
         BackgroundPictureHeight=   0
         BackgroundPictureWidth=   0
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         BorderStyle     =   0
         DisableIcons    =   -1  'True
         RowOddColor     =   0
      End
      Begin CSGrid2.cGrid grdVentas 
         Height          =   1320
         Left            =   60
         TabIndex        =   18
         Top             =   315
         Width           =   8295
         _ExtentX        =   14631
         _ExtentY        =   2328
         BackgroundPictureHeight=   0
         BackgroundPictureWidth=   0
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         BorderStyle     =   0
         DisableIcons    =   -1  'True
         RowOddColor     =   0
      End
      Begin VB.Image imgCheques 
         Height          =   240
         Left            =   60
         Picture         =   "fInfoCliente.frx":1028
         ToolTipText     =   "Expandir"
         Top             =   3420
         Width           =   240
      End
      Begin VB.Label lbChequesTitle 
         BackStyle       =   0  'Transparent
         Caption         =   "Cheques Pendientes"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H80000011&
         Height          =   330
         Left            =   375
         TabIndex        =   17
         Top             =   3465
         Width           =   1860
      End
      Begin VB.Shape shCheques 
         BorderColor     =   &H80000010&
         Height          =   1350
         Left            =   45
         Top             =   3720
         Width           =   8325
      End
      Begin VB.Image imgVentas 
         Height          =   240
         Left            =   60
         Picture         =   "fInfoCliente.frx":13B2
         ToolTipText     =   "Expandir"
         Top             =   0
         Width           =   240
      End
      Begin VB.Label lbVentasTitle 
         BackStyle       =   0  'Transparent
         Caption         =   "Ultimas Ventas"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H80000011&
         Height          =   330
         Left            =   375
         TabIndex        =   16
         Top             =   45
         Width           =   1725
      End
      Begin VB.Shape shVentas 
         BorderColor     =   &H80000010&
         Height          =   1350
         Left            =   45
         Top             =   300
         Width           =   8325
      End
      Begin VB.Image imgCobranzas 
         Height          =   240
         Left            =   60
         Picture         =   "fInfoCliente.frx":173C
         ToolTipText     =   "Expandir"
         Top             =   1710
         Width           =   240
      End
      Begin VB.Label lbCobranzasTitle 
         BackStyle       =   0  'Transparent
         Caption         =   "Ultimas Cobranzas"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H80000011&
         Height          =   330
         Left            =   360
         TabIndex        =   15
         Top             =   1755
         Width           =   1725
      End
      Begin VB.Shape shCobranzas 
         BorderColor     =   &H80000010&
         Height          =   1350
         Left            =   45
         Top             =   2010
         Width           =   8325
      End
      Begin VB.Label lbVentasTotal 
         BackStyle       =   0  'Transparent
         Caption         =   "Total"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H80000010&
         Height          =   240
         Left            =   6570
         TabIndex        =   14
         Top             =   45
         Width           =   510
      End
      Begin VB.Label lbVentas 
         Alignment       =   1  'Right Justify
         BackStyle       =   0  'Transparent
         Caption         =   "9.999.999,00"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H80000010&
         Height          =   240
         Left            =   7065
         TabIndex        =   13
         Top             =   45
         Width           =   1275
      End
      Begin VB.Shape shVentasSaldo 
         BorderColor     =   &H80000010&
         Height          =   270
         Left            =   7065
         Top             =   0
         Width           =   1305
      End
      Begin VB.Label lbCobranzasTotal 
         BackStyle       =   0  'Transparent
         Caption         =   "Total"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H80000010&
         Height          =   240
         Left            =   6570
         TabIndex        =   12
         Top             =   1755
         Width           =   510
      End
      Begin VB.Label lbCobranzas 
         Alignment       =   1  'Right Justify
         BackStyle       =   0  'Transparent
         Caption         =   "9.999.999,00"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H80000010&
         Height          =   240
         Left            =   7065
         TabIndex        =   11
         Top             =   1755
         Width           =   1275
      End
      Begin VB.Shape shCobranzasSaldo 
         BorderColor     =   &H80000010&
         Height          =   270
         Left            =   7065
         Top             =   1710
         Width           =   1305
      End
      Begin VB.Label lbChequesTotal 
         BackStyle       =   0  'Transparent
         Caption         =   "Total"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H80000010&
         Height          =   240
         Left            =   6570
         TabIndex        =   10
         Top             =   3465
         Width           =   465
      End
      Begin VB.Label lbCheques 
         Alignment       =   1  'Right Justify
         BackStyle       =   0  'Transparent
         Caption         =   "9.999.999,00"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H80000010&
         Height          =   240
         Left            =   7065
         TabIndex        =   9
         Top             =   3465
         Width           =   1230
      End
      Begin VB.Shape shChequesSaldo 
         BorderColor     =   &H80000010&
         Height          =   270
         Left            =   7065
         Top             =   3420
         Width           =   1260
      End
   End
   Begin VB.PictureBox picPartes 
      BackColor       =   &H80000005&
      BorderStyle     =   0  'None
      Height          =   5100
      Left            =   135
      ScaleHeight     =   5100
      ScaleWidth      =   8430
      TabIndex        =   19
      Top             =   1845
      Width           =   8430
      Begin CSGrid2.cGrid grdPartes 
         Height          =   4740
         Left            =   60
         TabIndex        =   20
         Top             =   315
         Width           =   8295
         _ExtentX        =   14631
         _ExtentY        =   8361
         BackgroundPictureHeight=   0
         BackgroundPictureWidth=   0
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         BorderStyle     =   0
         DisableIcons    =   -1  'True
         RowOddColor     =   0
      End
      Begin VB.Shape shPartes 
         BorderColor     =   &H80000010&
         Height          =   4770
         Left            =   45
         Top             =   300
         Width           =   8325
      End
      Begin VB.Label Label14 
         BackStyle       =   0  'Transparent
         Caption         =   "Ultimos Partes"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H80000011&
         Height          =   330
         Left            =   375
         TabIndex        =   21
         Top             =   45
         Width           =   1725
      End
      Begin VB.Image Image9 
         Height          =   240
         Left            =   60
         Picture         =   "fInfoCliente.frx":1AC6
         Top             =   0
         Width           =   240
      End
   End
   Begin VB.Label label10 
      BackStyle       =   0  'Transparent
      Caption         =   "Crédito"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000010&
      Height          =   285
      Left            =   4860
      TabIndex        =   45
      Top             =   705
      Width           =   1140
   End
   Begin VB.Label lbCreditoTotal 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "9.999.999,00"
      ForeColor       =   &H80000010&
      Height          =   240
      Left            =   5640
      TabIndex        =   44
      Top             =   705
      Width           =   990
   End
   Begin VB.Shape Shape4 
      BorderColor     =   &H80000010&
      Height          =   255
      Index           =   9
      Left            =   5565
      Top             =   675
      Width           =   1125
   End
   Begin VB.Label Label3 
      BackStyle       =   0  'Transparent
      Caption         =   "Crédito Cta."
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000010&
      Height          =   285
      Left            =   2460
      TabIndex        =   43
      Top             =   705
      Width           =   1140
   End
   Begin VB.Label lbCreditoCC 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "9.999.999,00"
      ForeColor       =   &H80000010&
      Height          =   240
      Left            =   3630
      TabIndex        =   42
      Top             =   705
      Width           =   1005
   End
   Begin VB.Shape Shape4 
      BorderColor     =   &H80000010&
      Height          =   255
      Index           =   8
      Left            =   3585
      Top             =   675
      Width           =   1185
   End
   Begin VB.Label Label1 
      BackStyle       =   0  'Transparent
      Caption         =   "Disponible"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000010&
      Height          =   285
      Left            =   6900
      TabIndex        =   41
      Top             =   705
      Width           =   1200
   End
   Begin VB.Label lbDisponible 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "9.999.999,00"
      ForeColor       =   &H80000010&
      Height          =   240
      Left            =   7830
      TabIndex        =   40
      Top             =   705
      Width           =   1050
   End
   Begin VB.Shape Shape4 
      BorderColor     =   &H80000010&
      Height          =   255
      Index           =   7
      Left            =   7830
      Top             =   675
      Width           =   1110
   End
   Begin VB.Label Label11 
      BackStyle       =   0  'Transparent
      Caption         =   "Pedidos"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000010&
      Height          =   285
      Left            =   6900
      TabIndex        =   39
      Top             =   1065
      Width           =   840
   End
   Begin VB.Label lbPedidosSaldo 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "9.999.999,00"
      ForeColor       =   &H80000010&
      Height          =   240
      Left            =   7830
      TabIndex        =   38
      Top             =   1065
      Width           =   1050
   End
   Begin VB.Shape Shape4 
      BorderColor     =   &H80000010&
      Height          =   240
      Index           =   6
      Left            =   7830
      Top             =   1035
      Width           =   1110
   End
   Begin VB.Label Label7 
      BackStyle       =   0  'Transparent
      Caption         =   "Remitos"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000010&
      Height          =   285
      Left            =   4860
      TabIndex        =   37
      Top             =   1065
      Width           =   780
   End
   Begin VB.Label lbRemitos 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "9.999.999,00"
      ForeColor       =   &H80000010&
      Height          =   240
      Left            =   5640
      TabIndex        =   36
      Top             =   1065
      Width           =   990
   End
   Begin VB.Shape Shape4 
      BorderColor     =   &H80000010&
      Height          =   240
      Index           =   5
      Left            =   5565
      Top             =   1035
      Width           =   1125
   End
   Begin VB.Label Label2 
      BackStyle       =   0  'Transparent
      Caption         =   "Documentos"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000010&
      Height          =   285
      Left            =   2460
      TabIndex        =   35
      Top             =   1065
      Width           =   1080
   End
   Begin VB.Label lbDocumentos 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "9.999.999,00"
      ForeColor       =   &H80000010&
      Height          =   240
      Left            =   3660
      TabIndex        =   34
      Top             =   1065
      Width           =   1005
   End
   Begin VB.Shape Shape4 
      BorderColor     =   &H80000010&
      Height          =   240
      Index           =   1
      Left            =   3585
      Top             =   1035
      Width           =   1185
   End
   Begin VB.Label Label4 
      BackStyle       =   0  'Transparent
      Caption         =   "Cta. Cte."
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000010&
      Height          =   285
      Left            =   120
      TabIndex        =   33
      Top             =   1065
      Width           =   780
   End
   Begin VB.Label lbCtaCte 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "9.999.999,00"
      ForeColor       =   &H80000010&
      Height          =   240
      Left            =   1020
      TabIndex        =   32
      Top             =   1065
      Width           =   1245
   End
   Begin VB.Shape Shape4 
      BorderColor     =   &H80000010&
      Height          =   240
      Index           =   2
      Left            =   945
      Top             =   1040
      Width           =   1365
   End
   Begin VB.Shape Shape4 
      BorderColor     =   &H80000010&
      Height          =   315
      Index           =   0
      Left            =   840
      Top             =   165
      Width           =   5055
   End
   Begin VB.Shape shMain 
      BorderColor     =   &H80000010&
      Height          =   5235
      Left            =   90
      Top             =   1755
      Width           =   8520
   End
   Begin VB.Shape Shape4 
      BorderColor     =   &H80000010&
      Height          =   300
      Index           =   4
      Left            =   6975
      Top             =   195
      Width           =   1965
   End
   Begin VB.Label lbEstado 
      BackStyle       =   0  'Transparent
      Caption         =   "Crédito Excedido"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000010&
      Height          =   240
      Left            =   7065
      TabIndex        =   3
      Top             =   240
      Width           =   1890
   End
   Begin VB.Label Label9 
      BackStyle       =   0  'Transparent
      Caption         =   "Estado"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000010&
      Height          =   285
      Left            =   6150
      TabIndex        =   2
      Top             =   240
      Width           =   960
   End
   Begin VB.Line Line2 
      BorderColor     =   &H8000000F&
      X1              =   -270
      X2              =   89775
      Y1              =   1365
      Y2              =   1365
   End
   Begin VB.Shape Shape4 
      BorderColor     =   &H80000010&
      Height          =   255
      Index           =   3
      Left            =   945
      Top             =   675
      Width           =   1365
   End
   Begin VB.Label lbSaldo 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "9.999.999,00"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000010&
      Height          =   240
      Left            =   1035
      TabIndex        =   1
      Top             =   720
      Width           =   1245
   End
   Begin VB.Label Label8 
      BackStyle       =   0  'Transparent
      Caption         =   "Saldo"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000010&
      Height          =   285
      Left            =   135
      TabIndex        =   0
      Top             =   720
      Width           =   780
   End
   Begin VB.Image Image1 
      Height          =   480
      Left            =   90
      Picture         =   "fInfoCliente.frx":1E50
      Top             =   75
      Width           =   480
   End
   Begin VB.Line Line1 
      BorderColor     =   &H8000000F&
      X1              =   0
      X2              =   90000
      Y1              =   600
      Y2              =   600
   End
End
Attribute VB_Name = "fInfoCliente"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Const C_Module As String = "fInfoCliente"

Private Const c_ObjABMName = "CSABMInterface2.cABMGeneric"

Private m_cli_id              As Long
Private m_CurrentValue        As String
Private m_ValueUser           As String
Private m_ValueHelp           As String
Private m_ValueProcess        As String
Private m_Editing             As Boolean
Private m_ValueValid          As Boolean
Private m_NoLostFocus         As Boolean
Private m_KeyHelp             As Long
Private m_ForeColorIn         As Long
Private m_ForeColorOut        As Long
Private m_ErrorColor          As Long
Private m_cmdTabIndex         As Long

Private m_SmallChart          As Boolean
Private m_vChartDataEvol()    As t_ChartDataEvol
Private m_vChartDataProd()    As t_ChartDataProd

Private m_NonModalAllowed     As Boolean

Private m_bCobranzasMaximized     As Boolean
Private m_bVentasMaximized        As Boolean
Private m_bPedidosMaximized       As Boolean
Private m_bChequesMaximized       As Boolean
Private m_bProductosMaximized     As Boolean
Private m_bChartsdMaximized       As Boolean

Private m_ChartProdHeight As Long
Private m_ChartEvolHeight As Long
Private m_ChartProdWidth  As Long
Private m_ChartEvolWidth  As Long

Private m_LastFormHeight  As Single
Private m_LastFormWidth   As Single

' pseudoconstantes
Private c_grdventas_height      As Long
Private c_ventas_height         As Long

Private c_gdrcobranzas_top      As Long
Private c_grdcobranzas_height   As Long
Private c_imgcobranzas_top      As Long
Private c_lbcobranzastitle_top  As Long
Private c_lbcobranzastotal_top  As Long
Private c_lbcobranzas_top       As Long
Private c_cobranzassaldo_top    As Long
Private c_cobranzas_top         As Long
Private c_cobranzas_Height      As Long

Private c_gdrcheques_top        As Long
Private c_grdcheques_height     As Long
Private c_imgcheques_top        As Long
Private c_lbchequestitle_top    As Long
Private c_lbchequestotal_top    As Long
Private c_lbcheques_top         As Long
Private c_chequessaldo_top      As Long
Private c_cheques_top           As Long
Private c_cheques_Height        As Long

Private c_gdrpedidos_top        As Long
Private c_grdpedidos_height     As Long
Private c_imgpedidos_top        As Long
Private c_lbpedidostitle_top    As Long
Private c_lbpedidos_top         As Long
Private c_pedidossaldo_top      As Long
Private c_pedidos_top           As Long
Private c_pedidos_Height        As Long

Private c_gdrproductos_top        As Long
Private c_grdproductos_height     As Long
Private c_imgproductos_top        As Long
Private c_lbproductostitle_top    As Long
Private c_productos_top           As Long
Private c_productos_Height        As Long

Private c_scale_height          As Long

Public Property Get ChartProdHeight() As String
  ChartProdHeight = m_ChartProdHeight
End Property
Public Property Let ChartProdHeight(ByVal rhs As String)
  m_ChartProdHeight = rhs
End Property

Public Property Get ChartProdWidth() As String
  ChartProdWidth = m_ChartProdWidth
End Property
Public Property Let ChartProdWidth(ByVal rhs As String)
  m_ChartProdWidth = rhs
End Property

Public Property Get ChartEvolHeight() As String
  ChartEvolHeight = m_ChartEvolHeight
End Property
Public Property Let ChartEvolHeight(ByVal rhs As String)
  m_ChartEvolHeight = rhs
End Property

Public Property Get ChartEvolWidth() As String
  ChartEvolWidth = m_ChartEvolWidth
End Property
Public Property Let ChartEvolWidth(ByVal rhs As String)
  m_ChartEvolWidth = rhs
End Property

Public Property Let NonModalAllowed(ByVal rhs As Boolean)
  m_NonModalAllowed = rhs
End Property

Public Property Get cli_id() As Long
  cli_id = m_cli_id
End Property

Public Property Let cli_id(ByVal rhs As Long)
  m_cli_id = rhs
End Property

Public Property Get SmallChart() As Boolean
  SmallChart = m_SmallChart
End Property

Public Sub FillChartProd(ByRef Chart As Object)
  mGlobal.FillChartProd m_vChartDataProd, Chart
End Sub

Public Sub FillChartEvol(ByRef Chart As Object)
  mGlobal.FillChartEvol m_vChartDataEvol, Chart
End Sub

Public Sub ShowChartProd()
  If m_SmallChart Then
    imgChartProducto.Height = 1320
    m_ChartProdHeight = 1320
  Else
    If imgChartProducto.Height < 4740 Then
      imgChartProducto.Height = 4740
    End If
  End If
End Sub

Public Sub ShowChartEvol()
  If m_SmallChart Then
    imgChartEvol.Height = 1320
  Else
    If imgChartEvol.Height < 4740 Then
      imgChartEvol.Height = 4740
    End If
  End If
End Sub

Public Sub SetChartDataEvol(ByRef rs As ADODB.Recordset)
  Dim i As Long
  
  For i = 1 To UBound(m_vChartDataEvol)
    m_vChartDataEvol(i).Total = 0
  Next
  i = 0
  
  If rs.EOF Then Exit Sub
  
  rs.MoveLast
  rs.MoveFirst
  
  Do While Not rs.EOF
    For i = 1 To UBound(m_vChartDataEvol)
      With m_vChartDataEvol(i)
        If gDB.ValField(rs.Fields, "anio") = .Anio Then
          If gDB.ValField(rs.Fields, "mes") = .Mes Then
            .Total = gDB.ValField(rs.Fields, "total")
            Exit For
          End If
        End If
      End With
    Next
    rs.MoveNext
  Loop
End Sub

Public Sub SetChartDataProd(ByRef rs As ADODB.Recordset)
  
  ReDim m_vChartDataProd(0)
  
  If rs.EOF Then Exit Sub
  
  rs.MoveLast
  rs.MoveFirst
  
  Dim i As Long
  Const c_max_items = 9
  
  ReDim m_vChartDataProd(IIf(rs.RecordCount < c_max_items, rs.RecordCount, c_max_items))
  
  Do While Not rs.EOF
    If i < c_max_items Then
      i = i + 1
    
      With m_vChartDataProd(i)
        .Producto = gDB.ValField(rs.Fields, "artículo")
        .Total = gDB.ValField(rs.Fields, "total")
      End With
    
    Else
    
      With m_vChartDataProd(i)
        .Total = .Total + gDB.ValField(rs.Fields, "total")
      End With
    End If
    rs.MoveNext
  Loop
  
  If i = c_max_items Then
    m_vChartDataProd(i).Producto = "Otros"
  End If
End Sub

Private Sub cmdHlCliente_Click()
  pShowHelp
End Sub

Private Sub cmdTab_Click(Index As Integer)
  Dim bCallResize As Boolean
  
  bCallResize = m_cmdTabIndex <> Index
  m_cmdTabIndex = Index
  
  If bCallResize Then
    pResize True
  End If
  
  If Index = 1 Then
    picPartes.Visible = False
    picPedidos.Visible = False
    picResumen.Visible = True
  ElseIf Index = 2 Then
    picPartes.Visible = False
    picPedidos.Visible = True
    picResumen.Visible = False
  Else
    picPartes.Visible = True
    picPedidos.Visible = False
    picResumen.Visible = False
  End If
End Sub

Private Sub Form_Load()
  On Error GoTo ControlError
  
  c_scale_height = Me.ScaleHeight
  
  CSKernelClient2.LoadForm Me, Me.Name
  cmdTab.Item(1).VirtualPush
  m_SmallChart = True
  
  Dim i     As Integer
  Dim ddate As Date
  
  ddate = DateAdd("m", -6, Date)
  ReDim m_vChartDataEvol(6)
  ReDim m_vChartDataProd(0)

  For i = 1 To 6
    ddate = DateAdd("m", 1, ddate)
    With m_vChartDataEvol(i)
      .Anio = Year(ddate)
      .Mes = Month(ddate)
    End With
  Next
  
  m_KeyHelp = vbKeyF4
  m_ForeColorIn = vbWindowText
  m_ForeColorOut = vbWindowText
  m_ErrorColor = vbRed

  c_grdventas_height = grdVentas.Height
  c_ventas_height = shVentas.Height

  c_gdrcobranzas_top = grdCobranzas.Top
  c_grdcobranzas_height = grdCobranzas.Height
  c_imgcobranzas_top = imgCobranzas.Top
  c_lbcobranzastitle_top = lbCobranzasTitle.Top
  c_lbcobranzastotal_top = lbCobranzasTotal.Top
  c_lbcobranzas_top = lbCobranzas.Top
  c_cobranzassaldo_top = shCobranzasSaldo.Top
  c_cobranzas_top = shCobranzas.Top
  c_cobranzas_Height = shCobranzas.Height

  c_gdrcheques_top = grdCheques.Top
  c_grdcheques_height = grdCheques.Height
  c_imgcheques_top = imgCheques.Top
  c_lbchequestitle_top = lbChequesTitle.Top
  c_lbchequestotal_top = lbChequesTotal.Top
  c_lbcheques_top = lbCheques.Top
  c_chequessaldo_top = shChequesSaldo.Top
  c_cheques_top = shCheques.Top
  c_cheques_Height = shCheques.Height

  c_gdrpedidos_top = grdPedidos.Top
  c_grdpedidos_height = grdPedidos.Height
  c_imgpedidos_top = imgPedidos.Top
  c_lbpedidostitle_top = lbPedidosTitle.Top
  c_lbpedidos_top = lbPedidos.Top
  c_pedidossaldo_top = shPedidosSaldo.Top
  c_pedidos_top = shPedidos.Top
  c_pedidos_Height = shPedidos.Height

  c_gdrproductos_top = grdProductos.Top
  c_grdproductos_height = grdProductos.Height
  c_imgproductos_top = imgProductos.Top
  c_lbproductostitle_top = lbProductosTitle.Top
  c_productos_top = shProductos.Top
  c_productos_Height = shProductos.Height

  cmdTab_Click 1
  
  picPartes.Width = Me.ScaleWidth - picPartes.Left * 2
  picPedidos.Height = picPartes.Height
  picResumen.Height = picPartes.Height
  picPedidos.Width = picPartes.Width
  picResumen.Width = picPartes.Width
  
  pResizeWidth

  Exit Sub
ControlError:
  MngError Err, "Form_Load", C_Module, ""
End Sub

Private Sub hlCliente_Change()
  txHlCliente.Text = m_ValueUser
  ShowInfoCliente_ Val(m_cli_id), Me
  m_CurrentValue = m_ValueUser
End Sub

Private Sub Form_Resize()
  On Error Resume Next
  
  shMain.Width = Me.ScaleWidth - shMain.Left * 2
  shMain.Height = Me.ScaleHeight - shMain.Top - 40
  
  If Me.ScaleHeight > 7035 Then
    picPartes.Height = Me.ScaleHeight - picPartes.Top - 220
  Else
    picPartes.Height = 5100
  End If
  
  picPartes.Width = Me.ScaleWidth - picPartes.Left * 2
  picPedidos.Height = picPartes.Height
  picResumen.Height = picPartes.Height
  picPedidos.Width = picPartes.Width
  picResumen.Width = picPartes.Width
  
  pResize False

End Sub

Private Sub grdCobranzas_DblClick(ByVal lRow As Long, ByVal lCol As Long)
  On Error GoTo ControlError
  
  pEdit 13, Val(grdCobranzas.CellItemData(lRow, 1))

  Exit Sub
ControlError:
  MngError Err, "grdCobranzas_DblClick", C_Module, ""
End Sub

Private Sub grdPedidos_DblClick(ByVal lRow As Long, ByVal lCol As Long)
  On Error GoTo ControlError
  
  pEdit Val(grdPedidos.CellItemData(lRow, 1)), Val(grdPedidos.CellText(lRow, 2))

  Exit Sub
ControlError:
  MngError Err, "grdPedidos_DblClick", C_Module, ""
End Sub

Private Sub grdProductos_DblClick(ByVal lRow As Long, ByVal lCol As Long)
  On Error GoTo ControlError
  
  pEdit Val(grdProductos.CellItemData(lRow, 1)), Val(grdProductos.CellText(lRow, 2))

  Exit Sub
ControlError:
  MngError Err, "grdProductos_DblClick", C_Module, ""
End Sub

Private Sub grdVentas_DblClick(ByVal lRow As Long, ByVal lCol As Long)
  On Error GoTo ControlError
  
  pEdit 1, Val(grdVentas.CellItemData(lRow, 1))

  Exit Sub
ControlError:
  MngError Err, "grdVentas_DblClick", C_Module, ""
End Sub

Private Sub imgCheques_Click()
  If Not m_bChequesMaximized Then
    m_bChequesMaximized = True
    grdCheques.Top = grdVentas.Top
    grdCheques.Height = IIf(picResumen.ScaleHeight - grdCheques.Top - 60 > 4740, _
                              picResumen.ScaleHeight - grdCheques.Top - 60, 4740)
    shVentas.Height = grdCheques.Height + 30
    imgCheques.Top = imgVentas.Top
    shChequesSaldo.Top = shVentas.Top
    lbCheques.Top = lbVentas.Top
    lbChequesTitle.Top = lbVentasTitle.Top
    imgCheques.ToolTipText = "Restaurar"
    lbVentasTitle.Visible = False
    lbVentas.Visible = False
  Else
    m_bChequesMaximized = False
'    grdCheques.Top = 3735
'    grdCheques.Height = 1320
'    shVentas.Height = 1350
'    imgCheques.Top = 3420
'    shChequesSaldo.Top = 3420
'    lbCheques.Top = 3465
'    lbChequesTitle.Top = 3465
    imgCheques.ToolTipText = "Expandir"
    lbVentasTitle.Visible = True
    lbVentas.Visible = True
    pResize True
  End If
  shCheques.ZOrder
  lbCheques.ZOrder
  lbChequesTotal.ZOrder
  grdCheques.ZOrder
  imgCheques.ZOrder
End Sub

Private Sub pResize(ByVal bForceResize As Boolean)

  Dim coef As Single
  
  If Not bForceResize Then
    If Abs(m_LastFormHeight - Me.ScaleHeight) < 40 Then
      If Abs(m_LastFormWidth - Me.ScaleWidth) < 40 Then
        Exit Sub
      End If
    End If
  End If
  
  m_LastFormHeight = Me.ScaleHeight
  m_LastFormWidth = Me.ScaleWidth
  
  coef = Me.ScaleHeight / c_scale_height
  If coef < 1 Then
    coef = 1
  Else
    If coef > 1 Then
      coef = coef + (8 * coef / 100)
    End If
  End If

  If m_cmdTabIndex = 1 Then

    If m_bVentasMaximized Then
      grdVentas.Height = IIf(picResumen.ScaleHeight - grdVentas.Top - 20 > 4740, _
                                picResumen.ScaleHeight - grdVentas.Top - 20, 4740)
      shVentas.Height = grdVentas.Height + 30
    Else
      grdVentas.Height = c_grdventas_height * coef
      shVentas.Height = c_ventas_height * coef
    End If
    
    If m_bCobranzasMaximized Then
      grdCobranzas.Height = IIf(picResumen.ScaleHeight - grdCobranzas.Top - 20 > 4740, _
                                picResumen.ScaleHeight - grdCobranzas.Top - 20, 4740)
      shVentas.Height = grdCobranzas.Height + 30
    Else
      grdCobranzas.Top = c_gdrcobranzas_top * coef
      grdCobranzas.Height = c_grdcobranzas_height * coef
      imgCobranzas.Top = c_imgcobranzas_top * coef
      lbCobranzasTitle.Top = c_lbcobranzastitle_top * coef
      lbCobranzasTotal.Top = c_lbcobranzastotal_top * coef
      lbCobranzas.Top = c_lbcobranzas_top * coef
      shCobranzasSaldo.Top = c_cobranzassaldo_top * coef
      shCobranzas.Top = c_cobranzas_top * coef
      shCobranzas.Height = c_cobranzas_Height * coef
    End If
    
    If m_bChequesMaximized Then
      grdCheques.Height = IIf(picResumen.ScaleHeight - grdCheques.Top - 20 > 4740, _
                                picResumen.ScaleHeight - grdCheques.Top - 20, 4740)
      shVentas.Height = grdCheques.Height + 30
    Else
      grdCheques.Top = c_gdrcheques_top * coef
      imgCheques.Top = c_imgcheques_top * coef
      lbChequesTitle.Top = c_lbchequestitle_top * coef
      lbChequesTotal.Top = c_lbchequestotal_top * coef
      lbCheques.Top = c_lbcheques_top * coef
      shChequesSaldo.Top = c_chequessaldo_top * coef
      shCheques.Top = c_cheques_top * coef
    End If
  
    grdCheques.Height = picResumen.ScaleHeight - 40 - grdCheques.Top
    shCheques.Height = grdCheques.Height + 30
  
  ElseIf m_cmdTabIndex = 2 Then
  
    If m_bChartsdMaximized Then
      
      If Me.ScaleWidth > 8670 Then
        imgChartProducto.Left = 5455
        imgChartProducto.Width = picPedidos.ScaleWidth - imgChartProducto.Left - 180
      Else
        imgChartProducto.Width = 4050
        imgChartProducto.Left = 4455
      End If
  
      imgChartEvol.Width = imgChartProducto.Left - imgChartEvol.Left - 250
      m_ChartProdWidth = imgChartProducto.Width
      m_ChartEvolWidth = imgChartEvol.Width
      
      If Me.ScaleHeight > 1 Then
        imgChartEvol.Height = picPedidos.ScaleHeight - imgChartEvol.Top - 100
        imgChartProducto.Height = imgChartEvol.Height
        m_ChartEvolHeight = imgChartEvol.Height
        m_ChartProdHeight = imgChartProducto.Height
      Else
        imgChartEvol.Height = 4740
        imgChartProducto.Height = 4740
        m_ChartEvolHeight = 4740
        m_ChartProdHeight = 4740
        
      End If
      
      MakeChartEvol Me, False, m_ChartEvolHeight, m_ChartEvolWidth
      MakeChartProd Me, False, m_ChartProdHeight, m_ChartProdWidth
    Else
      imgChartEvol.Height = 1320
      m_ChartEvolHeight = 1320
      imgChartProducto.Height = 1320
      m_ChartProdHeight = 1320
    
      MakeChartEvol Me, True, 0, 0
      MakeChartProd Me, True, 0, 0
    End If
    
    If m_bPedidosMaximized Then
      grdPedidos.Height = IIf(picResumen.ScaleHeight - grdPedidos.Top - 20 > 4740, _
                                picResumen.ScaleHeight - grdPedidos.Top - 20, 4740)
      shPedidos.Height = grdPedidos.Height + 30
    Else
      grdPedidos.Top = c_gdrpedidos_top * coef
      grdPedidos.Height = c_grdpedidos_height * coef
      imgPedidos.Top = c_imgpedidos_top * coef
      lbPedidosTitle.Top = c_lbpedidostitle_top * coef
      lbPedidos.Top = c_lbpedidos_top * coef
      shPedidosSaldo.Top = c_pedidossaldo_top * coef
      shPedidos.Top = c_pedidos_top * coef
      shPedidos.Height = c_pedidos_Height * coef
    End If
    
    If m_bProductosMaximized Then
      grdProductos.Height = IIf(picResumen.ScaleHeight - grdProductos.Top - 20 > 4740, _
                                picResumen.ScaleHeight - grdProductos.Top - 20, 4740)
      shProductos.Height = grdProductos.Height + 30
    Else
      grdProductos.Top = c_gdrproductos_top * coef
      imgProductos.Top = c_imgproductos_top * coef
      lbProductosTitle.Top = c_lbproductostitle_top * coef
      shProductos.Top = c_productos_top * coef
    End If
    
    grdProductos.Height = picResumen.ScaleHeight - 40 - grdProductos.Top
    shProductos.Height = grdProductos.Height + 30
  
  ElseIf m_cmdTabIndex = 3 Then
  
    grdPartes.Height = IIf(picResumen.ScaleHeight - grdPartes.Top - 20 > 4740, _
                              picResumen.ScaleHeight - grdPartes.Top - 20, 4740)
    
  
  End If
  
  pResizeWidth
End Sub

Private Sub pResizeWidth()
  grdVentas.Width = picResumen.ScaleWidth - grdVentas.Left * 2
  grdCobranzas.Width = grdVentas.Width
  grdCheques.Width = grdVentas.Width
  grdPedidos.Width = grdVentas.Width
  grdProductos.Width = grdVentas.Width
  grdPartes.Width = grdVentas.Width
  
  shVentas.Width = picResumen.ScaleWidth - shVentas.Left * 2
  shCobranzas.Width = shVentas.Width
  shCheques.Width = shVentas.Width
  shPedidos.Width = shVentas.Width
  shProductos.Width = shVentas.Width
  shPartes.Width = shVentas.Width
End Sub

Private Sub imgCobranzas_Click()
  If Not m_bCobranzasMaximized Then
    m_bCobranzasMaximized = True
    grdCobranzas.Top = grdVentas.Top
    grdCobranzas.Height = IIf(picResumen.ScaleHeight - grdCobranzas.Top - 20 > 4740, _
                              picResumen.ScaleHeight - grdCobranzas.Top - 20, 4740)
    shVentas.Height = grdCobranzas.Height + 30
    imgCobranzas.Top = imgVentas.Top
    shCobranzasSaldo.Top = shVentas.Top
    lbCobranzas.Top = lbVentas.Top
    lbCobranzasTitle.Top = lbVentasTitle.Top
    imgCobranzas.ToolTipText = "Restaurar"
    lbVentasTitle.Visible = False
    lbVentas.Visible = False
  Else
    m_bCobranzasMaximized = False
'    grdCobranzas.Top = 2025
'    grdCobranzas.Height = 1320
'    shVentas.Height = 1350
'    imgCobranzas.Top = 1710
'    shCobranzasSaldo.Top = 1710
'    lbCobranzas.Top = 1755
'    lbCobranzasTitle.Top = 1755
    imgCobranzas.ToolTipText = "Expandir"
    lbVentasTitle.Visible = True
    lbVentas.Visible = True
    pResize True
  End If
  shCobranzas.ZOrder
  lbCobranzas.ZOrder
  lbCobranzasTotal.ZOrder
  grdCobranzas.ZOrder
  imgCobranzas.ZOrder
End Sub

Private Sub imgVentas_Click()
  If Not m_bVentasMaximized Then
    m_bVentasMaximized = True
    grdVentas.Height = IIf(picResumen.ScaleHeight - grdVentas.Top - 20 > 4740, _
                              picResumen.ScaleHeight - grdVentas.Top - 20, 4740)
    shVentas.Height = grdVentas.Height + 30
    imgVentas.ToolTipText = "Restaurar"
  Else
    m_bVentasMaximized = False
'    grdVentas.Height = 1320
'    shVentas.Height = 1350
    imgVentas.ToolTipText = "Expandir"
    pResize True
  End If
  grdVentas.ZOrder
End Sub

Private Sub imgPedidos_Click()
  If Not m_bPedidosMaximized Then
    m_bPedidosMaximized = True
    grdPedidos.Top = imgChartEvol.Top
    grdPedidos.Height = IIf(picResumen.ScaleHeight - grdPedidos.Top - 20 > 4740, _
                              picResumen.ScaleHeight - grdPedidos.Top - 20, 4740)
    shPedidos.Height = grdPedidos.Height + 30
    shPedidos.Top = imgChartEvol.Top - 10
    imgPedidos.Top = imgEvolucion.Top
    lbPedidos.Top = lbEvolucionTitle.Top
    shPedidosSaldo.Top = lbEvolucionTitle.Top - 40
    lbPedidosTitle.Top = lbEvolucionTitle.Top
    imgPedidos.ToolTipText = "Restaurar"
    lbEvolucionTitle.Visible = False
    imgChartProducto.Visible = False
  Else
    m_bPedidosMaximized = False
'    grdPedidos.Top = 2025
'    grdPedidos.Height = 1320
'    shPedidos.Height = 1350
'    imgPedidos.Top = 1710
'    shPedidos.Top = 2010
'    shPedidosSaldo.Top = 1710
'    lbPedidos.Top = 1755
'    lbPedidosTitle.Top = 1755
    imgPedidos.ToolTipText = "Expandir"
    lbEvolucionTitle.Visible = True
    imgChartProducto.Visible = True
    pResize True
  End If
  shPedidos.ZOrder
  lbPedidos.ZOrder
  grdPedidos.ZOrder
  imgPedidos.ZOrder
End Sub

Private Sub imgProductos_Click()
  If Not m_bProductosMaximized Then
    m_bProductosMaximized = True
    grdProductos.Top = imgChartEvol.Top
    grdProductos.Height = IIf(picResumen.ScaleHeight - grdProductos.Top - 20 > 4740, _
                              picResumen.ScaleHeight - grdProductos.Top - 20, 4740)
    shProductos.Height = grdProductos.Height + 30
    shProductos.Top = imgChartEvol.Top - 10
    imgProductos.Top = imgEvolucion.Top
    lbProductosTitle.Top = lbEvolucionTitle.Top
    imgProductos.ToolTipText = "Restaurar"
    lbEvolucionTitle.Visible = False
    imgChartProducto.Visible = False
  Else
    m_bProductosMaximized = False
'    grdProductos.Top = 3735
'    grdProductos.Height = 1320
'    shProductos.Height = 1350
'    imgProductos.Top = 3420
'    shProductos.Top = 3720
'    lbProductosTitle.Top = 3465
    imgProductos.ToolTipText = "Expandir"
    lbEvolucionTitle.Visible = True
    imgChartProducto.Visible = True
    pResize True
  End If
  shProductos.ZOrder
  grdProductos.ZOrder
  imgProductos.ZOrder
End Sub

Private Sub imgEvolucion_Click()
  If Not m_bChartsdMaximized Then
    m_bChartsdMaximized = True
    imgEvolucion.ToolTipText = "Restaurar"
    grdPedidos.Visible = False
    grdProductos.Visible = False
    lbPedidos.Visible = False
    lbPedidosTitle.Visible = False
    lbProductosTitle.Visible = False
    shPedidosSaldo.Visible = False
    shPedidos.Visible = False
    shProductos.Visible = False
    imgPedidos.Visible = False
    imgProductos.Visible = False
    m_SmallChart = False
    
    If Me.ScaleWidth > 8670 Then
      imgChartProducto.Left = 5455
      imgChartProducto.Width = picPedidos.ScaleWidth - imgChartProducto.Left - 180
    Else
      imgChartProducto.Width = 4050
      imgChartProducto.Left = 4455
    End If

    imgChartEvol.Width = imgChartProducto.Left - imgChartEvol.Left - 250
    m_ChartProdWidth = imgChartProducto.Width
    m_ChartEvolWidth = imgChartEvol.Width
    
    If Me.ScaleHeight > 1 Then
      imgChartEvol.Height = picPedidos.ScaleHeight - imgChartEvol.Top - 100
      imgChartProducto.Height = imgChartEvol.Height
      m_ChartEvolHeight = imgChartEvol.Height
      m_ChartProdHeight = imgChartProducto.Height
    Else
      imgChartEvol.Height = 4740
      imgChartProducto.Height = 4740
      m_ChartEvolHeight = 4740
      m_ChartProdHeight = 4740
      
    End If
    
    MakeChartEvol Me, False, m_ChartEvolHeight, m_ChartEvolWidth
    MakeChartProd Me, False, m_ChartProdHeight, m_ChartProdWidth
  
  Else
    m_bChartsdMaximized = False
    imgEvolucion.ToolTipText = "Expandir"
    grdPedidos.Visible = True
    grdProductos.Visible = True
    lbPedidos.Visible = True
    lbPedidosTitle.Visible = True
    lbProductosTitle.Visible = True
    shPedidosSaldo.Visible = True
    shPedidos.Visible = True
    shProductos.Visible = True
    imgPedidos.Visible = True
    imgProductos.Visible = True
    m_SmallChart = True
    MakeChartEvol Me, True, 0, 0
    imgChartEvol.Height = 1320
    m_ChartEvolHeight = 1320
    MakeChartProd Me, True, 0, 0
    imgChartProducto.Height = 1320
    m_ChartProdHeight = 1320
  End If
  imgChartEvol.ZOrder
  imgChartProducto.ZOrder
End Sub

'--------------------------------------------------------------
Private Sub pShowHelp()
  Dim bCancel As Boolean
  Dim hr      As cHelpResult
  Dim Help    As CSOAPI2.cHelp
  
  ' Para que se ejecute el lostfocus de los demas controles
  DoEvents
  
  Set Help = New CSOAPI2.cHelp
  
  m_CurrentValue = txHlCliente.Text
  
  Set hr = Help.Show(txHlCliente, _
                     28, _
                     m_ValueHelp, _
                     m_ValueUser, _
                     m_ValueProcess, _
                     csNormal, _
                     vbNullString, _
                     vbNullString, , _
                     True)
    
  Dim oldValueHelp As String
  oldValueHelp = m_ValueHelp
    
  With hr
    m_ValueHelp = .Id
    m_cli_id = .Id
    m_ValueUser = .Value
    m_ValueProcess = .Value2
  End With
    
  With txHlCliente
    If LCase(m_CurrentValue) <> LCase(.Text) Or m_ValueHelp <> oldValueHelp Then
      hlCliente_Change
    End If
    
    m_CurrentValue = .Text
  End With
    
  SetFocusControl txHlCliente
  
End Sub

Private Sub txHlCliente_GotFocus()
  On Error Resume Next
  m_CurrentValue = txHlCliente.Text
  m_NoLostFocus = True
  m_Editing = True
  SetColor
  pTxGotFocus
End Sub

Private Sub txHlCliente_KeyDown(KeyCode As Integer, Shift As Integer)
  On Error Resume Next
  If KeyCode = m_KeyHelp And Shift = 0 Then pShowHelp
End Sub

Private Sub txHlCliente_KeyPress(KeyAscii As Integer)
  If KeyAscii = vbKeyReturn Then
    txHlCliente_LostFocus
  End If
End Sub

Private Sub txHlCliente_LostFocus()
  On Error Resume Next
  m_NoLostFocus = False
  DoEvents: DoEvents: DoEvents: DoEvents: DoEvents

  If m_NoLostFocus Then
    m_NoLostFocus = False
    Exit Sub
  End If

  pValidate

  If Not LCase(m_CurrentValue) = LCase(txHlCliente.Text) Then
    hlCliente_Change
  End If
End Sub

Private Sub SetColor()
  With txHlCliente
    If m_Editing Then
      .ForeColor = m_ForeColorIn
    Else
      If m_ValueValid Then
          .ForeColor = m_ForeColorOut
      Else
          .ForeColor = m_ErrorColor
      End If
    End If
  End With
End Sub

Private Sub pTxGotFocus()
  
  With txHlCliente
    If .Text <> vbNullString Then
    
      .SelStart = Len(.Text)
      .SelStart = 0
      .SelLength = Len(.Text)
    End If
  End With
End Sub

Private Sub pValidate()
  Dim Help    As CSOAPI2.cHelp
  Dim hr      As CSOAPI2.cHelpResult
  
  Set Help = New CSOAPI2.cHelp
  
  Help.ForAbm = True
  Set hr = Help.ValidateEx(28, _
                           txHlCliente.Text, _
                           m_ValueHelp, _
                           vbNullString, _
                           vbNullString)
  
  With hr
    m_ValueValid = Not .Cancel
    m_ValueHelp = .Id
    m_cli_id = .Id
    m_ValueUser = .Value
    m_ValueProcess = .Value2
  End With
  
  m_Editing = False
  SetColor
End Sub

Private Sub pEdit(ByVal DoctId As Long, ByVal CompId As Long)
  Dim DoctObject As String
  Dim PreId      As Long
    
  If m_NonModalAllowed Then
    
    If Not GetDocumentoTipoInfo_(DoctId, _
                                 "", _
                                 DoctObject, _
                                 PreId) Then Exit Sub
      
      
    If Not gSecurity.CanAccess(PreId) Then Exit Sub
    
    Dim DocObj As cIEditGeneric
    Set DocObj = CSKernelClient2.CreateObject(DoctObject)
        
    Dim oDoc As cIEditGenericDoc
    
    Set DocObj.ObjABM = CSKernelClient2.CreateObject(c_ObjABMName)
    Set oDoc = DocObj
    Set oDoc.Footer = CSKernelClient2.CreateObject(c_ObjABMName)
    Set oDoc.Items = CSKernelClient2.CreateObject(c_ObjABMName)
    
    DocObj.Edit CompId
    
  Else
  
    MsgInfo "No es posible mostrar esta factura ya que la ventana de Info se esta mostrando Modal."
  End If
End Sub

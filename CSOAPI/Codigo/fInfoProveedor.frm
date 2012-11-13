VERSION 5.00
Object = "{353A8433-36B8-422E-ABBD-36CEE8BE628E}#1.0#0"; "CSButton.ocx"
Object = "{757F6B6F-8057-4D0A-85C2-0A1807E33D34}#1.6#0"; "CSGrid2.ocx"
Begin VB.Form fInfoProveedor 
   BackColor       =   &H80000005&
   Caption         =   "Info Proveedor"
   ClientHeight    =   7035
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   9105
   Icon            =   "fInfoProveedor.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   7035
   ScaleWidth      =   9105
   StartUpPosition =   3  'Windows Default
   Begin CSButton.cButtonLigth cmdHlProveedor 
      Height          =   315
      Left            =   5745
      TabIndex        =   0
      Top             =   150
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
   Begin VB.PictureBox picPedidos 
      BackColor       =   &H80000005&
      BorderStyle     =   0  'None
      Height          =   5100
      Left            =   105
      ScaleHeight     =   5100
      ScaleWidth      =   8430
      TabIndex        =   5
      Top             =   1785
      Width           =   8430
      Begin CSGrid2.cGrid grdPedidos 
         Height          =   1320
         Left            =   60
         TabIndex        =   6
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
         TabIndex        =   7
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
      Begin VB.Image imgEvolucion 
         Height          =   240
         Left            =   60
         Picture         =   "fInfoProveedor.frx":058A
         Top             =   45
         Width           =   240
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
         TabIndex        =   11
         Top             =   90
         Width           =   6810
      End
      Begin VB.Image imgChartEvol 
         Height          =   1305
         Left            =   90
         Top             =   360
         Width           =   4305
      End
      Begin VB.Shape shPedidosSaldo 
         BorderColor     =   &H80000010&
         Height          =   270
         Left            =   7020
         Top             =   1710
         Width           =   1305
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
         TabIndex        =   10
         Top             =   1755
         Width           =   1185
      End
      Begin VB.Image imgPedidos 
         Height          =   240
         Left            =   60
         Picture         =   "fInfoProveedor.frx":0914
         Top             =   1710
         Width           =   240
      End
      Begin VB.Label lbPedidosTitle 
         BackStyle       =   0  'Transparent
         Caption         =   "Ordenes/Remitos Pendientes"
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
         TabIndex        =   9
         Top             =   1755
         Width           =   3345
      End
      Begin VB.Shape shPedidos 
         BorderColor     =   &H80000010&
         Height          =   1350
         Left            =   45
         Top             =   2010
         Width           =   8280
      End
      Begin VB.Image imgProductos 
         Height          =   240
         Left            =   60
         Picture         =   "fInfoProveedor.frx":0C9E
         Top             =   3420
         Width           =   240
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
         TabIndex        =   8
         Top             =   3465
         Width           =   2670
      End
      Begin VB.Shape shProductos 
         BorderColor     =   &H80000010&
         Height          =   1350
         Left            =   45
         Top             =   3720
         Width           =   8280
      End
      Begin VB.Image imgChartProducto 
         Height          =   1305
         Left            =   4455
         Top             =   360
         Width           =   3855
      End
   End
   Begin VB.TextBox txHlProveedor 
      BorderStyle     =   0  'None
      Height          =   285
      Left            =   825
      TabIndex        =   1
      Top             =   165
      Width           =   5025
   End
   Begin CSButton.cButton cmdTab 
      Height          =   330
      Index           =   1
      Left            =   60
      TabIndex        =   2
      Top             =   1425
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
      Left            =   3030
      TabIndex        =   3
      Top             =   1425
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
      Left            =   1545
      TabIndex        =   4
      Top             =   1425
      Width           =   1500
      _ExtentX        =   2646
      _ExtentY        =   582
      Caption         =   "&Ordenes"
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
   Begin VB.PictureBox picPartes 
      BackColor       =   &H80000005&
      BorderStyle     =   0  'None
      Height          =   5100
      Left            =   105
      ScaleHeight     =   5100
      ScaleWidth      =   8430
      TabIndex        =   25
      Top             =   1830
      Width           =   8430
      Begin CSGrid2.cGrid grdPartes 
         Height          =   4740
         Left            =   60
         TabIndex        =   26
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
      Begin VB.Image Image9 
         Height          =   240
         Left            =   60
         Picture         =   "fInfoProveedor.frx":1028
         Top             =   0
         Width           =   240
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
         TabIndex        =   27
         Top             =   45
         Width           =   1725
      End
      Begin VB.Shape shPartes 
         BorderColor     =   &H80000010&
         Height          =   4770
         Left            =   45
         Top             =   300
         Width           =   8325
      End
   End
   Begin VB.PictureBox picResumen 
      BackColor       =   &H80000005&
      BorderStyle     =   0  'None
      Height          =   5100
      Left            =   105
      ScaleHeight     =   5100
      ScaleWidth      =   8430
      TabIndex        =   12
      Top             =   1830
      Width           =   8430
      Begin CSGrid2.cGrid grdCheques 
         Height          =   1320
         Left            =   60
         TabIndex        =   13
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
      Begin CSGrid2.cGrid grdPagos 
         Height          =   1320
         Left            =   60
         TabIndex        =   14
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
      Begin CSGrid2.cGrid grdCompras 
         Height          =   1320
         Left            =   60
         TabIndex        =   15
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
      Begin VB.Shape shChequesSaldo 
         BorderColor     =   &H80000010&
         Height          =   270
         Left            =   7065
         Top             =   3420
         Width           =   1260
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
         TabIndex        =   24
         Top             =   3465
         Width           =   1230
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
         TabIndex        =   23
         Top             =   3465
         Width           =   465
      End
      Begin VB.Shape shPagosSaldo 
         BorderColor     =   &H80000010&
         Height          =   270
         Left            =   7065
         Top             =   1710
         Width           =   1305
      End
      Begin VB.Label lbPagos 
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
         TabIndex        =   22
         Top             =   1755
         Width           =   1275
      End
      Begin VB.Label lbPagosTotal 
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
         TabIndex        =   21
         Top             =   1755
         Width           =   510
      End
      Begin VB.Shape shComprasSaldo 
         BorderColor     =   &H80000010&
         Height          =   270
         Left            =   7065
         Top             =   0
         Width           =   1305
      End
      Begin VB.Label lbCompras 
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
         TabIndex        =   20
         Top             =   45
         Width           =   1275
      End
      Begin VB.Label lbComprasTotal 
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
         TabIndex        =   19
         Top             =   45
         Width           =   510
      End
      Begin VB.Shape shPagos 
         BorderColor     =   &H80000010&
         Height          =   1350
         Left            =   45
         Top             =   2010
         Width           =   8325
      End
      Begin VB.Label lbPagosTitle 
         BackStyle       =   0  'Transparent
         Caption         =   "Ultimos Pagos"
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
         TabIndex        =   18
         Top             =   1755
         Width           =   1725
      End
      Begin VB.Image imgPagos 
         Height          =   240
         Left            =   60
         Picture         =   "fInfoProveedor.frx":13B2
         ToolTipText     =   "Expandir"
         Top             =   1710
         Width           =   240
      End
      Begin VB.Shape shCompras 
         BorderColor     =   &H80000010&
         Height          =   1350
         Left            =   45
         Top             =   300
         Width           =   8325
      End
      Begin VB.Label lbComprasTitle 
         BackStyle       =   0  'Transparent
         Caption         =   "Ultimas Compras"
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
         Top             =   45
         Width           =   1725
      End
      Begin VB.Image imgCompras 
         Height          =   240
         Left            =   60
         Picture         =   "fInfoProveedor.frx":173C
         ToolTipText     =   "Expandir"
         Top             =   0
         Width           =   240
      End
      Begin VB.Shape shCheques 
         BorderColor     =   &H80000010&
         Height          =   1350
         Left            =   45
         Top             =   3720
         Width           =   8325
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
         TabIndex        =   16
         Top             =   3465
         Width           =   1860
      End
      Begin VB.Image imgCheques 
         Height          =   240
         Left            =   60
         Picture         =   "fInfoProveedor.frx":1AC6
         ToolTipText     =   "Expandir"
         Top             =   3420
         Width           =   240
      End
   End
   Begin VB.Line Line1 
      BorderColor     =   &H8000000F&
      X1              =   -30
      X2              =   89970
      Y1              =   585
      Y2              =   585
   End
   Begin VB.Image Image1 
      Height          =   480
      Left            =   60
      Picture         =   "fInfoProveedor.frx":1E50
      Top             =   60
      Width           =   480
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
      Left            =   105
      TabIndex        =   45
      Top             =   705
      Width           =   780
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
      Left            =   1005
      TabIndex        =   44
      Top             =   705
      Width           =   1245
   End
   Begin VB.Shape Shape4 
      BorderColor     =   &H80000010&
      Height          =   255
      Index           =   3
      Left            =   915
      Top             =   660
      Width           =   1365
   End
   Begin VB.Line Line2 
      BorderColor     =   &H8000000F&
      X1              =   -300
      X2              =   89745
      Y1              =   1350
      Y2              =   1350
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
      Left            =   6120
      TabIndex        =   43
      Top             =   225
      Width           =   960
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
      Left            =   7035
      TabIndex        =   42
      Top             =   225
      Width           =   1890
   End
   Begin VB.Shape Shape4 
      BorderColor     =   &H80000010&
      Height          =   300
      Index           =   4
      Left            =   6945
      Top             =   180
      Width           =   1965
   End
   Begin VB.Shape shMain 
      BorderColor     =   &H80000010&
      Height          =   5235
      Left            =   60
      Top             =   1740
      Width           =   8520
   End
   Begin VB.Shape Shape4 
      BorderColor     =   &H80000010&
      Height          =   315
      Index           =   0
      Left            =   810
      Top             =   150
      Width           =   5055
   End
   Begin VB.Shape Shape4 
      BorderColor     =   &H80000010&
      Height          =   240
      Index           =   2
      Left            =   915
      Top             =   1020
      Width           =   1365
   End
   Begin VB.Label lbCtaCte 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "9.999.999,00"
      ForeColor       =   &H80000010&
      Height          =   240
      Left            =   990
      TabIndex        =   41
      Top             =   1050
      Width           =   1245
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
      Left            =   90
      TabIndex        =   40
      Top             =   1050
      Width           =   780
   End
   Begin VB.Shape Shape4 
      BorderColor     =   &H80000010&
      Height          =   240
      Index           =   1
      Left            =   3555
      Top             =   1020
      Width           =   1185
   End
   Begin VB.Label lbDocumentos 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "9.999.999,00"
      ForeColor       =   &H80000010&
      Height          =   240
      Left            =   3630
      TabIndex        =   39
      Top             =   1050
      Width           =   1005
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
      Left            =   2430
      TabIndex        =   38
      Top             =   1050
      Width           =   1080
   End
   Begin VB.Shape Shape4 
      BorderColor     =   &H80000010&
      Height          =   240
      Index           =   5
      Left            =   5535
      Top             =   1020
      Width           =   1125
   End
   Begin VB.Label lbRemitos 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "9.999.999,00"
      ForeColor       =   &H80000010&
      Height          =   240
      Left            =   5610
      TabIndex        =   37
      Top             =   1050
      Width           =   990
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
      Left            =   4830
      TabIndex        =   36
      Top             =   1050
      Width           =   780
   End
   Begin VB.Shape Shape4 
      BorderColor     =   &H80000010&
      Height          =   240
      Index           =   6
      Left            =   7800
      Top             =   1020
      Width           =   1110
   End
   Begin VB.Label lbPedidosSaldo 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "9.999.999,00"
      ForeColor       =   &H80000010&
      Height          =   240
      Left            =   7800
      TabIndex        =   35
      Top             =   1050
      Width           =   1050
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
      Left            =   6870
      TabIndex        =   34
      Top             =   1050
      Width           =   840
   End
   Begin VB.Shape Shape4 
      BorderColor     =   &H80000010&
      Height          =   255
      Index           =   7
      Left            =   7800
      Top             =   660
      Width           =   1110
   End
   Begin VB.Label lbDisponible 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "9.999.999,00"
      ForeColor       =   &H80000010&
      Height          =   240
      Left            =   7800
      TabIndex        =   33
      Top             =   690
      Width           =   1050
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
      Left            =   6870
      TabIndex        =   32
      Top             =   690
      Width           =   1200
   End
   Begin VB.Shape Shape4 
      BorderColor     =   &H80000010&
      Height          =   255
      Index           =   8
      Left            =   3555
      Top             =   660
      Width           =   1185
   End
   Begin VB.Label lbCreditoCC 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "9.999.999,00"
      ForeColor       =   &H80000010&
      Height          =   240
      Left            =   3600
      TabIndex        =   31
      Top             =   690
      Width           =   1005
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
      Left            =   2430
      TabIndex        =   30
      Top             =   690
      Width           =   1140
   End
   Begin VB.Shape Shape4 
      BorderColor     =   &H80000010&
      Height          =   255
      Index           =   9
      Left            =   5535
      Top             =   660
      Width           =   1125
   End
   Begin VB.Label lbCreditoTotal 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "9.999.999,00"
      ForeColor       =   &H80000010&
      Height          =   240
      Left            =   5610
      TabIndex        =   29
      Top             =   690
      Width           =   990
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
      Left            =   4830
      TabIndex        =   28
      Top             =   690
      Width           =   1140
   End
End
Attribute VB_Name = "fInfoProveedor"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Const C_Module As String = "fInfoProveedor"

Private Const c_ObjABMName = "CSABMInterface2.cABMGeneric"

Private m_prov_id              As Long
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

Private m_bPagosMaximized     As Boolean
Private m_bComprasMaximized        As Boolean
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
Private c_grdCompras_height      As Long
Private c_Compras_height         As Long

Private c_gdrPagos_top      As Long
Private c_grdPagos_height   As Long
Private c_imgPagos_top      As Long
Private c_lbPagostitle_top  As Long
Private c_lbPagostotal_top  As Long
Private c_lbPagos_top       As Long
Private c_Pagossaldo_top    As Long
Private c_Pagos_top         As Long
Private c_Pagos_Height      As Long

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

Public Property Get prov_id() As Long
  prov_id = m_prov_id
End Property

Public Property Let prov_id(ByVal rhs As Long)
  m_prov_id = rhs
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

Private Sub cmdHlProveedor_Click()
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

  c_grdCompras_height = grdCompras.Height
  c_Compras_height = shCompras.Height

  c_gdrPagos_top = grdPagos.Top
  c_grdPagos_height = grdPagos.Height
  c_imgPagos_top = imgPagos.Top
  c_lbPagostitle_top = lbPagosTitle.Top
  c_lbPagostotal_top = lbPagosTotal.Top
  c_lbPagos_top = lbPagos.Top
  c_Pagossaldo_top = shPagosSaldo.Top
  c_Pagos_top = shPagos.Top
  c_Pagos_Height = shPagos.Height

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

Private Sub hlProveedor_Change()
  txHlProveedor.Text = m_ValueUser
  ShowInfoProveedor_ Val(m_prov_id), Me
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

Private Sub grdPagos_DblClick(ByVal lRow As Long, ByVal lCol As Long)
  On Error GoTo ControlError
  
  pEdit 16, Val(grdPagos.CellItemData(lRow, 1))

  Exit Sub
ControlError:
  MngError Err, "grdPagos_DblClick", C_Module, ""
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

Private Sub grdCompras_DblClick(ByVal lRow As Long, ByVal lCol As Long)
  On Error GoTo ControlError
  
  pEdit 2, Val(grdCompras.CellItemData(lRow, 1))

  Exit Sub
ControlError:
  MngError Err, "grdCompras_DblClick", C_Module, ""
End Sub

Private Sub imgCheques_Click()
  If Not m_bChequesMaximized Then
    m_bChequesMaximized = True
    grdCheques.Top = grdCompras.Top
    grdCheques.Height = IIf(picResumen.ScaleHeight - grdCheques.Top - 60 > 4740, _
                              picResumen.ScaleHeight - grdCheques.Top - 60, 4740)
    shCompras.Height = grdCheques.Height + 30
    imgCheques.Top = imgCompras.Top
    shChequesSaldo.Top = shCompras.Top
    lbCheques.Top = lbCompras.Top
    lbChequesTitle.Top = lbComprasTitle.Top
    imgCheques.ToolTipText = "Restaurar"
    lbComprasTitle.Visible = False
    lbCompras.Visible = False
  Else
    m_bChequesMaximized = False
'    grdCheques.Top = 3735
'    grdCheques.Height = 1320
'    shCompras.Height = 1350
'    imgCheques.Top = 3420
'    shChequesSaldo.Top = 3420
'    lbCheques.Top = 3465
'    lbChequesTitle.Top = 3465
    imgCheques.ToolTipText = "Expandir"
    lbComprasTitle.Visible = True
    lbCompras.Visible = True
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

    If m_bComprasMaximized Then
      grdCompras.Height = IIf(picResumen.ScaleHeight - grdCompras.Top - 20 > 4740, _
                                picResumen.ScaleHeight - grdCompras.Top - 20, 4740)
      shCompras.Height = grdCompras.Height + 30
    Else
      grdCompras.Height = c_grdCompras_height * coef
      shCompras.Height = c_Compras_height * coef
    End If
    
    If m_bPagosMaximized Then
      grdPagos.Height = IIf(picResumen.ScaleHeight - grdPagos.Top - 20 > 4740, _
                                picResumen.ScaleHeight - grdPagos.Top - 20, 4740)
      shCompras.Height = grdPagos.Height + 30
    Else
      grdPagos.Top = c_gdrPagos_top * coef
      grdPagos.Height = c_grdPagos_height * coef
      imgPagos.Top = c_imgPagos_top * coef
      lbPagosTitle.Top = c_lbPagostitle_top * coef
      lbPagosTotal.Top = c_lbPagostotal_top * coef
      lbPagos.Top = c_lbPagos_top * coef
      shPagosSaldo.Top = c_Pagossaldo_top * coef
      shPagos.Top = c_Pagos_top * coef
      shPagos.Height = c_Pagos_Height * coef
    End If
    
    If m_bChequesMaximized Then
      grdCheques.Height = IIf(picResumen.ScaleHeight - grdCheques.Top - 20 > 4740, _
                                picResumen.ScaleHeight - grdCheques.Top - 20, 4740)
      shCompras.Height = grdCheques.Height + 30
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
  grdCompras.Width = picResumen.ScaleWidth - grdCompras.Left * 2
  grdPagos.Width = grdCompras.Width
  grdCheques.Width = grdCompras.Width
  grdPedidos.Width = grdCompras.Width
  grdProductos.Width = grdCompras.Width
  grdPartes.Width = grdCompras.Width
  
  shCompras.Width = picResumen.ScaleWidth - shCompras.Left * 2
  shPagos.Width = shCompras.Width
  shCheques.Width = shCompras.Width
  shPedidos.Width = shCompras.Width
  shProductos.Width = shCompras.Width
  shPartes.Width = shCompras.Width
End Sub

Private Sub imgPagos_Click()
  If Not m_bPagosMaximized Then
    m_bPagosMaximized = True
    grdPagos.Top = grdCompras.Top
    grdPagos.Height = IIf(picResumen.ScaleHeight - grdPagos.Top - 20 > 4740, _
                              picResumen.ScaleHeight - grdPagos.Top - 20, 4740)
    shCompras.Height = grdPagos.Height + 30
    imgPagos.Top = imgCompras.Top
    shPagosSaldo.Top = shCompras.Top
    lbPagos.Top = lbCompras.Top
    lbPagosTitle.Top = lbComprasTitle.Top
    imgPagos.ToolTipText = "Restaurar"
    lbComprasTitle.Visible = False
    lbCompras.Visible = False
  Else
    m_bPagosMaximized = False
'    grdPagos.Top = 2025
'    grdPagos.Height = 1320
'    shCompras.Height = 1350
'    imgPagos.Top = 1710
'    shPagosSaldo.Top = 1710
'    lbPagos.Top = 1755
'    lbPagosTitle.Top = 1755
    imgPagos.ToolTipText = "Expandir"
    lbComprasTitle.Visible = True
    lbCompras.Visible = True
    pResize True
  End If
  shPagos.ZOrder
  lbPagos.ZOrder
  lbPagosTotal.ZOrder
  grdPagos.ZOrder
  imgPagos.ZOrder
End Sub

Private Sub imgCompras_Click()
  If Not m_bComprasMaximized Then
    m_bComprasMaximized = True
    grdCompras.Height = IIf(picResumen.ScaleHeight - grdCompras.Top - 20 > 4740, _
                              picResumen.ScaleHeight - grdCompras.Top - 20, 4740)
    shCompras.Height = grdCompras.Height + 30
    imgCompras.ToolTipText = "Restaurar"
  Else
    m_bComprasMaximized = False
'    grdCompras.Height = 1320
'    shCompras.Height = 1350
    imgCompras.ToolTipText = "Expandir"
    pResize True
  End If
  grdCompras.ZOrder
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
  
  m_CurrentValue = txHlProveedor.Text
  
  Set hr = Help.Show(txHlProveedor, _
                     29, _
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
    m_prov_id = .Id
    m_ValueUser = .Value
    m_ValueProcess = .Value2
  End With
    
  With txHlProveedor
    If LCase(m_CurrentValue) <> LCase(.Text) Or m_ValueHelp <> oldValueHelp Then
      hlProveedor_Change
    End If
    
    m_CurrentValue = .Text
  End With
    
  SetFocusControl txHlProveedor
  
End Sub

Private Sub txHlProveedor_GotFocus()
  On Error Resume Next
  m_CurrentValue = txHlProveedor.Text
  m_NoLostFocus = True
  m_Editing = True
  SetColor
  pTxGotFocus
End Sub

Private Sub txHlProveedor_KeyDown(KeyCode As Integer, Shift As Integer)
  On Error Resume Next
  If KeyCode = m_KeyHelp And Shift = 0 Then pShowHelp
End Sub

Private Sub txHlProveedor_KeyPress(KeyAscii As Integer)
  If KeyAscii = vbKeyReturn Then
    txHlProveedor_LostFocus
  End If
End Sub

Private Sub txHlProveedor_LostFocus()
  On Error Resume Next
  m_NoLostFocus = False
  DoEvents: DoEvents: DoEvents: DoEvents: DoEvents

  If m_NoLostFocus Then
    m_NoLostFocus = False
    Exit Sub
  End If

  pValidate

  If Not LCase(m_CurrentValue) = LCase(txHlProveedor.Text) Then
    hlProveedor_Change
  End If
End Sub

Private Sub SetColor()
  With txHlProveedor
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
  
  With txHlProveedor
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
  Set hr = Help.ValidateEx(29, _
                           txHlProveedor.Text, _
                           m_ValueHelp, _
                           vbNullString, _
                           vbNullString)
  
  With hr
    m_ValueValid = Not .Cancel
    m_ValueHelp = .Id
    m_prov_id = .Id
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
  
    MsgInfo "No es posible mostrar esta factura ya que la Comprana de Info se esta mostrando Modal."
  End If
End Sub



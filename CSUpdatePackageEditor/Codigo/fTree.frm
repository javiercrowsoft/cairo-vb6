VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Object = "{F7BB685C-0860-4FD1-A9CF-22277199D7A5}#1.0#0"; "CSMaskEdit2.ocx"
Object = "{353A8433-36B8-422E-ABBD-36CEE8BE628E}#1.0#0"; "CSButton.ocx"
Object = "{EBA71138-C194-4F8F-8A43-4781BBB517F8}#1.0#0"; "CSTree2.ocx"
Begin VB.Form fTree 
   BackColor       =   &H00FFFFFF&
   Caption         =   "Paquete de Actualización de Informes"
   ClientHeight    =   6510
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   10500
   Icon            =   "fTree.frx":0000
   LinkTopic       =   "Form2"
   ScaleHeight     =   11490
   ScaleWidth      =   19080
   Begin VB.PictureBox picProgress 
      BorderStyle     =   0  'None
      Height          =   4290
      Left            =   2565
      ScaleHeight     =   4290
      ScaleWidth      =   6135
      TabIndex        =   11
      Top             =   1845
      Visible         =   0   'False
      Width           =   6135
      Begin VB.ListBox lsFiles 
         Appearance      =   0  'Flat
         BackColor       =   &H8000000F&
         Height          =   1785
         Left            =   135
         TabIndex        =   16
         Top             =   1890
         Width           =   5865
      End
      Begin CSButton.cButtonLigth cmdCancel 
         Height          =   330
         Left            =   2385
         TabIndex        =   15
         Top             =   3825
         Width           =   1410
         _ExtentX        =   2487
         _ExtentY        =   582
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
         ForeColor       =   0
      End
      Begin VB.PictureBox picStatus 
         AutoRedraw      =   -1  'True
         BackColor       =   &H00FFFFFF&
         BorderStyle     =   0  'None
         ClipControls    =   0   'False
         FillColor       =   &H0080C0FF&
         Height          =   330
         Left            =   195
         ScaleHeight     =   330
         ScaleWidth      =   5730
         TabIndex        =   12
         TabStop         =   0   'False
         Top             =   1350
         Width           =   5730
      End
      Begin VB.Label lbClose 
         Alignment       =   2  'Center
         BackColor       =   &H000080FF&
         Caption         =   "X"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   9.75
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   240
         Left            =   5715
         TabIndex        =   17
         Top             =   90
         Width           =   240
      End
      Begin VB.Shape Shape6 
         BackColor       =   &H8000000F&
         BorderColor     =   &H0080C0FF&
         BorderWidth     =   3
         Height          =   4290
         Left            =   0
         Top             =   0
         Width           =   6135
      End
      Begin VB.Shape Shape5 
         BorderColor     =   &H0080C0FF&
         Height          =   435
         Left            =   135
         Top             =   1290
         Width           =   5850
      End
      Begin VB.Label Label5 
         BackStyle       =   0  'Transparent
         Caption         =   "Procesando:"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   9.75
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Left            =   150
         TabIndex        =   14
         Top             =   135
         Width           =   1470
      End
      Begin VB.Label lbProcess 
         BackStyle       =   0  'Transparent
         BorderStyle     =   1  'Fixed Single
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   765
         Left            =   150
         TabIndex        =   13
         Top             =   465
         Width           =   5820
      End
   End
   Begin VB.PictureBox picToolBar 
      Align           =   1  'Align Top
      Appearance      =   0  'Flat
      BorderStyle     =   0  'None
      ForeColor       =   &H80000008&
      Height          =   2775
      Left            =   0
      ScaleHeight     =   2775
      ScaleWidth      =   19080
      TabIndex        =   1
      Top             =   0
      Width           =   19080
      Begin CSMaskEdit2.cMaskEdit txCsrPath 
         Height          =   285
         Left            =   1980
         TabIndex        =   8
         Top             =   1110
         Width           =   5865
         _ExtentX        =   10345
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
         ForeColor       =   0
         EnabledNoChngBkColor=   0   'False
         Text            =   ""
         csType          =   9
         csNotRaiseError =   -1  'True
      End
      Begin VB.TextBox txDescrip 
         BorderStyle     =   0  'None
         Height          =   645
         Left            =   1980
         MultiLine       =   -1  'True
         TabIndex        =   6
         Top             =   1515
         Width           =   5865
      End
      Begin VB.TextBox txPackageName 
         BorderStyle     =   0  'None
         Height          =   285
         Left            =   1980
         TabIndex        =   3
         Text            =   "Informes.csai"
         Top             =   720
         Width           =   2805
      End
      Begin MSComctlLib.Toolbar tbMain 
         Height          =   330
         Left            =   225
         TabIndex        =   7
         Top             =   135
         Width           =   9210
         _ExtentX        =   16245
         _ExtentY        =   582
         ButtonWidth     =   609
         ButtonHeight    =   582
         Style           =   1
         ImageList       =   "iltbMain"
         _Version        =   393216
         BeginProperty Buttons {66833FE8-8583-11D1-B16A-00C0F0283628} 
            NumButtons      =   3
            BeginProperty Button1 {66833FEA-8583-11D1-B16A-00C0F0283628} 
               Key             =   "SAVE"
               Object.ToolTipText     =   "Generar Paquete de Actualización de Informes..."
               ImageIndex      =   1
            EndProperty
            BeginProperty Button2 {66833FEA-8583-11D1-B16A-00C0F0283628} 
               Style           =   3
            EndProperty
            BeginProperty Button3 {66833FEA-8583-11D1-B16A-00C0F0283628} 
               Key             =   "SEARCH"
               Object.ToolTipText     =   "Buscar Informe..."
               ImageIndex      =   2
            EndProperty
         EndProperty
      End
      Begin CSMaskEdit2.cMaskEdit txPackagePath 
         Height          =   285
         Left            =   1980
         TabIndex        =   9
         Top             =   2280
         Width           =   5865
         _ExtentX        =   10345
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
         ForeColor       =   0
         EnabledNoChngBkColor=   0   'False
         Text            =   ""
         csType          =   9
         csNotRaiseError =   -1  'True
      End
      Begin VB.Label Label4 
         Caption         =   "Guardar el paquete en:"
         Height          =   240
         Left            =   90
         TabIndex        =   10
         Top             =   2280
         Width           =   1770
      End
      Begin VB.Shape Shape4 
         BorderColor     =   &H80000010&
         Height          =   345
         Left            =   1950
         Top             =   2250
         Width           =   5925
      End
      Begin VB.Shape Shape3 
         BorderColor     =   &H80000010&
         Height          =   705
         Left            =   1950
         Top             =   1485
         Width           =   5925
      End
      Begin VB.Label Label3 
         Caption         =   "Descripción del Paquete:"
         Height          =   285
         Left            =   90
         TabIndex        =   5
         Top             =   1515
         Width           =   1815
      End
      Begin VB.Shape Shape2 
         BorderColor     =   &H80000010&
         Height          =   345
         Left            =   1950
         Top             =   1080
         Width           =   5925
      End
      Begin VB.Label Label2 
         Caption         =   "Carpeta de Reportes:"
         Height          =   240
         Left            =   90
         TabIndex        =   4
         Top             =   1110
         Width           =   1590
      End
      Begin VB.Shape Shape1 
         BorderColor     =   &H80000010&
         Height          =   345
         Left            =   1950
         Top             =   690
         Width           =   2865
      End
      Begin VB.Label Label1 
         Caption         =   "Nombre del Paquete:"
         Height          =   240
         Left            =   90
         TabIndex        =   2
         Top             =   720
         Width           =   1590
      End
      Begin VB.Shape shToolBar 
         BorderColor     =   &H80000003&
         Height          =   495
         Index           =   0
         Left            =   0
         Top             =   0
         Width           =   9375
      End
      Begin VB.Shape shToolBar 
         BorderColor     =   &H80000014&
         Height          =   495
         Index           =   1
         Left            =   0
         Top             =   0
         Width           =   9375
      End
      Begin VB.Line Line2 
         BorderColor     =   &H80000010&
         X1              =   90
         X2              =   90
         Y1              =   60
         Y2              =   430
      End
      Begin VB.Line Line1 
         BorderColor     =   &H80000014&
         X1              =   80
         X2              =   80
         Y1              =   60
         Y2              =   430
      End
      Begin VB.Line Line3 
         BorderColor     =   &H80000014&
         X1              =   135
         X2              =   135
         Y1              =   60
         Y2              =   430
      End
      Begin VB.Line Line4 
         BorderColor     =   &H80000010&
         X1              =   150
         X2              =   150
         Y1              =   60
         Y2              =   430
      End
   End
   Begin CSTree2.cTreeCtrl Tree 
      Height          =   2715
      Left            =   630
      TabIndex        =   0
      Top             =   3420
      Width           =   4785
      _ExtentX        =   8440
      _ExtentY        =   4789
   End
   Begin MSComctlLib.ImageList iltbMain 
      Left            =   6210
      Top             =   3465
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
            Picture         =   "fTree.frx":038A
            Key             =   ""
         EndProperty
         BeginProperty ListImage2 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fTree.frx":0B9C
            Key             =   ""
         EndProperty
      EndProperty
   End
End
Attribute VB_Name = "fTree"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' fTree
' 22-06-00

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes

Private Const C_Module = "fTree"

' estructuras
' variables privadas
Private m_Name                As String
Private m_MngInformes         As cMngInformes

Private m_bCancel             As Boolean

' propiedades publicas
Public Property Let NameEdit(ByVal rhs As String)
  m_Name = rhs
End Property
Public Property Get NameEdit() As String
  NameEdit = m_Name
End Property

Public Property Let Cancel(ByVal rhs As Boolean)
  m_bCancel = rhs
End Property
Public Property Get Cancel() As Boolean
  Cancel = m_bCancel
End Property
' propiedades privadas
' funciones publicas
Public Function Init() As Boolean
  Tree.IconText = csIMG_REDCUBE
  Tree.TreeCheckBox = True
  Tree.ListCheckBox = True

  Set Tree.ListChecked = m_MngInformes.Informes
  Tree.NameClient = "Tree"
  
  If Not Tree.Load(csTblInforme) Then Exit Function

End Function

Private Sub cbView_Click()
  Form_Resize
End Sub

Private Sub cmdSave_Click()
  On Error GoTo ControlError
  
  Dim Mouse As cMouseWait
  Set Mouse = New cMouseWait

  If txPackageName.Text = vbNullString Then
    MsgWarning "Debe indicar el nombre del archivo de actualización"
    SetFocusControl txPackageName
    Exit Sub
  End If
  
  If txCsrPath.Text = vbNullString Then
    MsgWarning "Debe indicar la carpeta de reportes"
    SetFocusControl txCsrPath
    Exit Sub
  End If

  If txPackagePath.Text = vbNullString Then
    MsgWarning "Debe indicar la carpeta donde se guardará el archivo de actualización"
    SetFocusControl txPackagePath
    Exit Sub
  End If

  If Not Tree.MoveCheckedToListChecked() Then Exit Sub
  If Not m_MngInformes.Informes.Save(txCsrPath.Text) Then Exit Sub

  Exit Sub
ControlError:
  MngError Err, "cmdSave_Click", C_Module, ""
End Sub

Private Sub cmdSearch_Click()
  On Error Resume Next
  
  Dim Id As Long
  
  Id = pSearchAux(csTblInforme)
  
  Tree.Search Id
End Sub

Private Function pSearchAux(ByVal table As Long) As Long
  Dim Help As CSOAPI2.cHelp
  Dim hr   As cHelpResult
  
  Set Help = New CSOAPI2.cHelp
  
  Set hr = Help.Show(Nothing, table, "", "", "")
  
  If hr.Cancel Then Exit Function
  
  pSearchAux = hr.Id
End Function

Private Sub cmdCancel_Click()
  If Ask("Confirma que desea cancelar", vbNo) Then
    m_bCancel = True
  End If
End Sub

Private Sub Form_Load()
  On Error GoTo ControlError

  Set m_MngInformes = New cMngInformes
  
  Tree.Top = picToolBar.Height + 40
  Tree.Left = 0
  
  ' Barritas de la Toolbar que quedan chebere :)
  '
  Line1.Y1 = 130
  Line2.Y1 = Line1.Y1
  Line3.Y1 = Line1.Y1
  Line4.Y1 = Line1.Y1
  Line1.Y2 = 480
  Line2.Y2 = Line1.Y2
  Line3.Y2 = Line1.Y2
  Line4.Y2 = Line1.Y2
  
  CSKernelClient2.LoadForm Me, m_Name
  
  txCsrPath.Text = GetIniValue("RPT-CONFIG", "RPT_PATH_REPORTES", "", GetValidPath(App.Path) & "cairo.ini")
  txPackagePath.Text = GetValidPath(GetEspecialFolders(sfidDESKTOP)) & "package"
  Exit Sub
ControlError:
  MngError Err, "Form_Load", C_Module, ""
End Sub

' funciones privadas
Private Sub Form_Resize()
  On Error Resume Next
  
  Tree.Width = ScaleWidth
  Tree.Height = ScaleHeight - Tree.Top
  
  With picProgress
    .Move (ScaleWidth - .Width) * 0.5
  End With
End Sub

' construccion - destruccion
Private Sub Form_Unload(Cancel As Integer)
  On Error GoTo ControlError
  
  Tree.SavePreference WindowState
  Set Tree.ListChecked = Nothing
  Set m_MngInformes = Nothing
  CSKernelClient2.UnloadForm Me, m_Name
  
  Exit Sub
ControlError:
  MngError Err, "Form_Unload", C_Module, ""
End Sub

Private Sub lbClose_Click()
  picProgress.Visible = False
End Sub

Private Sub lsFiles_DblClick()
  MsgInfo lsFiles.Text
End Sub

Private Sub picToolBar_Resize()
  On Error Resume Next
  shToolBar(0).Move -20, 80, picToolBar.Width + 40, 480
  shToolBar(1).Move -20, 90, picToolBar.Width + 40, 480
  tbMain.Move 190, 120, picToolBar.Width - 220
End Sub

Private Sub tbMain_ButtonClick(ByVal Button As MSComctlLib.Button)
  On Error GoTo ControlError
  
  Select Case Button.Key
    Case "SAVE"
      cmdSave_Click
    Case "SEARCH"
      cmdSearch_Click
  End Select
  
  Exit Sub
ControlError:
  MngError Err, "tbMain_ButtonClick", C_Module, ""
End Sub

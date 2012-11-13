VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Object = "{353A8433-36B8-422E-ABBD-36CEE8BE628E}#1.0#0"; "CSButton.ocx"
Object = "{F7BB685C-0860-4FD1-A9CF-22277199D7A5}#1.0#0"; "CSMaskEdit2.ocx"
Begin VB.Form fDBInfo 
   BorderStyle     =   5  'Sizable ToolWindow
   Caption         =   "Fuente de datos"
   ClientHeight    =   6645
   ClientLeft      =   60
   ClientTop       =   300
   ClientWidth     =   7395
   Icon            =   "fDBInfo.frx":0000
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   6645
   ScaleWidth      =   7395
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin CSMaskEdit2.cMultiLine txSqlstmt 
      Height          =   795
      Left            =   60
      TabIndex        =   10
      Top             =   5130
      Width           =   7275
      _ExtentX        =   12832
      _ExtentY        =   1402
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
      MultiLine       =   -1  'True
      EnabledNoChngBkColor=   0   'False
      Text            =   ""
      BorderType      =   1
   End
   Begin VB.OptionButton opSql 
      Caption         =   "Sentencia SQL"
      Height          =   255
      Left            =   60
      TabIndex        =   9
      Top             =   4770
      Width           =   3495
   End
   Begin VB.OptionButton opSpTable 
      Caption         =   "Procedimiento almacenado o tabla"
      Height          =   255
      Left            =   60
      TabIndex        =   8
      Top             =   1410
      Width           =   3495
   End
   Begin VB.PictureBox PicSplitter 
      BorderStyle     =   0  'None
      Height          =   2850
      Left            =   3015
      MousePointer    =   9  'Size W E
      ScaleHeight     =   2850
      ScaleWidth      =   45
      TabIndex        =   1
      TabStop         =   0   'False
      Top             =   1770
      Width           =   50
   End
   Begin VB.PictureBox PicSplitterBar 
      BackColor       =   &H8000000D&
      BorderStyle     =   0  'None
      Height          =   2850
      Left            =   3105
      ScaleHeight     =   2850
      ScaleWidth      =   105
      TabIndex        =   0
      TabStop         =   0   'False
      Top             =   1770
      Width           =   105
   End
   Begin CSButton.cButton cmdAceptar 
      Height          =   330
      Left            =   4365
      TabIndex        =   2
      Top             =   6165
      Width           =   1410
      _ExtentX        =   2487
      _ExtentY        =   582
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
   Begin CSMaskEdit2.cMaskEdit txDataSource 
      Height          =   285
      Left            =   1350
      TabIndex        =   3
      Top             =   840
      Width           =   6000
      _ExtentX        =   10583
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
      BorderType      =   1
      csNotRaiseError =   -1  'True
      csWithOutCalc   =   -1  'True
   End
   Begin MSComctlLib.ImageList il 
      Left            =   4320
      Top             =   1575
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483643
      ImageWidth      =   16
      ImageHeight     =   16
      MaskColor       =   12632256
      _Version        =   393216
      BeginProperty Images {2C247F25-8591-11D1-B16A-00C0F0283628} 
         NumListImages   =   8
         BeginProperty ListImage1 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fDBInfo.frx":08CA
            Key             =   ""
         EndProperty
         BeginProperty ListImage2 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fDBInfo.frx":0E66
            Key             =   ""
         EndProperty
         BeginProperty ListImage3 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fDBInfo.frx":1402
            Key             =   ""
         EndProperty
         BeginProperty ListImage4 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fDBInfo.frx":199E
            Key             =   ""
         EndProperty
         BeginProperty ListImage5 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fDBInfo.frx":1F3A
            Key             =   ""
         EndProperty
         BeginProperty ListImage6 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fDBInfo.frx":2B0E
            Key             =   ""
         EndProperty
         BeginProperty ListImage7 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fDBInfo.frx":39EA
            Key             =   ""
         EndProperty
         BeginProperty ListImage8 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fDBInfo.frx":3F84
            Key             =   ""
         EndProperty
      EndProperty
   End
   Begin MSComctlLib.ListView lvDBInfo 
      Height          =   2850
      Left            =   3195
      TabIndex        =   4
      Top             =   1770
      Width           =   4155
      _ExtentX        =   7329
      _ExtentY        =   5027
      LabelEdit       =   1
      Sorted          =   -1  'True
      LabelWrap       =   -1  'True
      HideSelection   =   -1  'True
      FlatScrollBar   =   -1  'True
      _Version        =   393217
      ForeColor       =   -2147483640
      BackColor       =   -2147483643
      Appearance      =   1
      NumItems        =   0
   End
   Begin MSComctlLib.TreeView tvDBInfo 
      Height          =   2850
      Left            =   0
      TabIndex        =   5
      Top             =   1770
      Width           =   3135
      _ExtentX        =   5530
      _ExtentY        =   5027
      _Version        =   393217
      HideSelection   =   0   'False
      Indentation     =   353
      LabelEdit       =   1
      LineStyle       =   1
      Style           =   7
      ImageList       =   "il"
      Appearance      =   1
   End
   Begin CSButton.cButton cmdCancelar 
      Height          =   330
      Left            =   5940
      TabIndex        =   6
      Top             =   6165
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
   End
   Begin VB.Image Image1 
      Height          =   585
      Left            =   135
      Picture         =   "fDBInfo.frx":451E
      Top             =   45
      Width           =   675
   End
   Begin VB.Label Label8 
      BackStyle       =   0  'Transparent
      Caption         =   "Controles"
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
      Left            =   1050
      TabIndex        =   11
      Top             =   225
      Width           =   2235
   End
   Begin VB.Line lnTitle 
      BorderColor     =   &H8000000C&
      X1              =   0
      X2              =   8000
      Y1              =   1230
      Y2              =   1230
   End
   Begin VB.Line lnButtons 
      BorderColor     =   &H8000000C&
      X1              =   0
      X2              =   8000
      Y1              =   6030
      Y2              =   6030
   End
   Begin VB.Line lnSqlstmt 
      BorderColor     =   &H8000000C&
      X1              =   0
      X2              =   8000
      Y1              =   4710
      Y2              =   4710
   End
   Begin VB.Label Label1 
      Caption         =   "&Fuente de datos:"
      Height          =   240
      Left            =   45
      TabIndex        =   7
      Top             =   855
      Width           =   1230
   End
   Begin VB.Shape Shape1 
      BorderStyle     =   0  'Transparent
      FillColor       =   &H00FFFFFF&
      FillStyle       =   0  'Solid
      Height          =   690
      Left            =   0
      Top             =   0
      Width           =   7530
   End
End
Attribute VB_Name = "fDBInfo"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' fDBInfo
' 30-10-2001

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "fDBInfo"

Const sglSplitLimit = 500

' estructuras
' variables privadas
Private m_cn                            As New ADODB.Connection
Private m_moving                        As Boolean

Private m_Ok                            As Boolean
Private m_StrConnect                    As String
Private m_DataBase                      As String
Private m_Server                        As String
Private m_User                          As String
Private m_Password                      As String
Private m_DataSource                    As String
Private m_DataSourceType                As csDataSourceType

Private m_vTablasU()                    As String
Private m_vTablasS()                    As String
Private m_vVistas()                     As String
Private m_vOtros()                      As String
Private m_vSPsU()                       As String
Private m_vSPsS()                       As String
' eventos
' propiedades publicas
Public Property Get Ok() As Boolean
   Ok = m_Ok
End Property

Public Property Get StrConnect() As String
   StrConnect = m_StrConnect
End Property

Public Property Let StrConnect(ByVal rhs As String)
   m_StrConnect = rhs
End Property

Public Property Get DataBase() As String
   DataBase = m_DataBase
End Property

Public Property Let DataBase(ByVal rhs As String)
   m_DataBase = rhs
End Property

Public Property Get Server() As String
   Server = m_Server
End Property

Public Property Let Server(ByVal rhs As String)
   m_Server = rhs
End Property

Public Property Get User() As String
   User = m_User
End Property

Public Property Let User(ByVal rhs As String)
   m_User = rhs
End Property

Public Property Get Password() As String
   Password = m_Password
End Property

Public Property Let Password(ByVal rhs As String)
   m_Password = rhs
End Property

Public Property Get DataSource() As String
   DataSource = m_DataSource
End Property

Public Property Let DataSource(ByVal rhs As String)
   m_DataSource = rhs
End Property

Public Property Get DataSourceType() As csDataSourceType
   DataSourceType = m_DataSourceType
End Property

Public Property Let DataSourceType(ByVal rhs As csDataSourceType)
   m_DataSourceType = rhs
End Property

' propiedades privadas
' funciones publicas
' funciones privadas
Private Sub cmdAceptar_Click()
  CSKernelClient2.Title = "Definir conexión"
  
  If Not m_Ok Then
    MsgWarning "Debe definir una conexión"
    Exit Sub
  End If
  
  If opSpTable.Value Then
  
    If lvDBInfo.SelectedItem Is Nothing Then
      MsgWarning "Debe seleccionar una tabla o una vista o un procedimiento almacenado"
      Exit Sub
    End If
    
    Dim Tag         As String
    Dim DataSource  As String
    
    Tag = tvDBInfo.SelectedItem.Tag
    DataSource = lvDBInfo.SelectedItem.Text
    
    If Tag = "" Then
      MsgWarning "Debe seleccionar una tabla o una vista o un procedimiento almacenado"
      Exit Sub
    End If
    
    If Tag = "t" Or Tag = "s" Then
      m_DataSource = DataSource
      m_DataSourceType = csDTTable
    ElseIf Tag = "p" Or Tag = "y" Then
      m_DataSource = DataSource
      m_DataSourceType = cdDTProcedure
    Else
      MsgWarning "Tipo de origen de datos no soportado."
      Exit Sub
    End If
  Else
  
    If txSqlstmt.Text = "" Then
      MsgWarning "Debe indicar una sentencia SQL"
      Exit Sub
    End If
  
    m_DataSource = txSqlstmt.Text
    m_DataSourceType = cdDTSqlstmt
  End If
  Hide
End Sub

Private Sub cmdCancelar_Click()
  m_Ok = False
  Hide
End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
  If UnloadMode <> vbFormCode Then
    Cancel = True
    m_Ok = False
    Hide
  End If
End Sub

Private Sub Form_Resize()
  SizeControls
End Sub

Private Sub opSpTable_Click()
  txSqlstmt.Enabled = Not opSpTable.Value
  tvDBInfo.Enabled = Not txSqlstmt.Enabled
  lvDBInfo.Enabled = tvDBInfo.Enabled
End Sub

Private Sub opSql_Click()
  txSqlstmt.Enabled = opSql.Value
  tvDBInfo.Enabled = Not txSqlstmt.Enabled
  lvDBInfo.Enabled = tvDBInfo.Enabled
End Sub

Private Sub txDataSource_ButtonClick(ByRef Cancel As Boolean)
  Dim oConnect As cConnect
  Set oConnect = New cConnect
  
  Cancel = True
  
  txDataSource.Text = oConnect.GetNewConnect()
  
  If txDataSource.Text = "" Then
    m_StrConnect = ""
    m_DataBase = ""
    m_Server = ""
    m_User = ""
    m_Password = ""
    m_Ok = False
  Else
    With oConnect
      m_StrConnect = .StrConnect
      m_DataBase = .DataBase
      m_Server = .Server
      m_User = .User
      m_Password = .Password
    End With
  
    m_Ok = ShowSchema(txDataSource.Text)
  End If
End Sub

Private Function ShowSchema(ByVal StrConnect As String) As Boolean
  Dim rs        As ADODB.Recordset
  Dim Node      As Node
  Dim Node1     As Node
  Dim Node2     As Node
  Dim Num       As Integer
  Dim mouse     As cMouseWait
  Set mouse = New cMouseWait
  
  tvDBInfo.Nodes.Clear
  
  On Error Resume Next
  
  m_cn.Open StrConnect
  
  If Err.Number <> 0 Then
    If m_Password = "" Then
      MngError Err, "fDBInfo.ShowSchema", C_Module, "Fallo la conexion. Si ud esta conectandose a SQL Server debe marcar el checkbox 'Allow saving password'", "Fallo al abrir la conexión", , csErrorAdo, m_cn
    End If
    Exit Function
  End If
  
  Set rs = m_cn.OpenSchema(adSchemaTables)
  ' en adoptant le paramètre adSchemaTables
  'TABLE_CATALOG = rs.fields(0)
  'TABLE_SCHEMA = rs.fields(1)
  'TABLE_NAME = rs.fields(2)
  'TABLE_TYPE = rs.fields(3)
  Set Node = tvDBInfo.Nodes.Add(, , , "<Base>", 1, 1)
  tvDBInfo.Nodes.Add(Node, tvwChild, "FY", "Tablas del Sistema", 8, 8).Tag = "s"
  tvDBInfo.Nodes.Add(Node, tvwChild, "FT", "Tablas de usuario", 8, 8).Tag = "t"
  tvDBInfo.Nodes.Add(Node, tvwChild, "FV", "Vistas", 8, 8).Tag = "v"
  tvDBInfo.Nodes.Add(Node, tvwChild, "FV", "Vistas", 8, 8).Tag = "o"
  tvDBInfo.Nodes.Add(Node, tvwChild, "FS", "Procedimientos Almacenados", 8, 8).Tag = ""
  'in order to see all differents nodes
  Node.Expanded = True


  ReDim m_vOtros(0)
  ReDim m_vSPsS(0)
  ReDim m_vSPsU(0)
  ReDim m_vTablasS(0)
  ReDim m_vTablasU(0)
  ReDim m_vVistas(0)

  Do While Not rs.EOF
    'ici, je vais retrouver le nom des tables de cette base de données
    'here, i find all DB Tables(columns)(Sorry for my english if i hurt someone)

    Select Case LCase(rs.Fields(3))
    'dans le fields(3) se trouve le type d'élément(table, requete,etc...)
    'in fields(3) we find the kind of object : column, query...

    Case "table"
        ReDim Preserve m_vTablasU(UBound(m_vTablasU) + 1)
        m_vTablasU(UBound(m_vTablasU)) = rs.Fields(2)
        Num = 2
    Case Is = "view"
        ReDim Preserve m_vVistas(UBound(m_vVistas) + 1)
        m_vVistas(UBound(m_vVistas)) = rs.Fields(2)
        Num = 5
    Case "system table"
        ReDim Preserve m_vTablasS(UBound(m_vTablasS) + 1)
        m_vTablasS(UBound(m_vTablasS)) = rs.Fields(2)
        Num = 6
     Case Else
        ReDim Preserve m_vOtros(UBound(m_vOtros) + 1)
        m_vOtros(UBound(m_vOtros)) = rs.Fields(2)
        Num = 4
    End Select


    rs.MoveNext

  Loop
  
  Set rs = m_cn.OpenSchema(adSchemaProcedures)
  'PARA adSchemaProcedures:
  'PROCEDURE_CATALOG = rs(0)
  'PROCEDURE_SCHEMA = rs(1)
  'PROCEDURE_NAME =rs(2)
  'PROCEDURE_TYPE = rs(3)

  tvDBInfo.Nodes.Add(tvDBInfo.Nodes("FS"), tvwChild, "FSU", "Usuario", 8, 8).Tag = "p"
  tvDBInfo.Nodes.Add(tvDBInfo.Nodes("FS"), tvwChild, "FSY", "Sistema", 8, 8).Tag = "y"

  Do While Not rs.EOF
    If Left(rs.Fields(2), 2) <> "dt" Then
      ReDim Preserve m_vSPsU(UBound(m_vSPsU) + 1)
      m_vSPsU(UBound(m_vSPsU)) = Replace(rs.Fields(2).Value, ";1", "") 'rs.Fields(2)
    Else
      ReDim Preserve m_vSPsS(UBound(m_vSPsS) + 1)
      m_vSPsS(UBound(m_vSPsS)) = Replace(rs.Fields(2).Value, ";1", "") 'rs.Fields(2)
    End If
    rs.MoveNext
  Loop

  m_cn.Close
  
  ShowSchema = True
End Function

Private Sub tvDBInfo_NodeClick(ByVal Node As MSComctlLib.Node)
  Dim Item            As ListItem
  Dim i               As Integer
  
  On Error GoTo hdl

  lvDBInfo.ListItems.Clear
  lvDBInfo.ColumnHeaders.Clear
  
  lvDBInfo.ColumnHeaders.Add(, , "Nombre").Width = 2500
  lvDBInfo.View = lvwReport
  lvDBInfo.Sorted = True
  lvDBInfo.SortKey = 0
  Select Case Node.Tag
    Case "s"
      For i = 1 To UBound(m_vTablasS)
        Set Item = lvDBInfo.ListItems.Add(, , m_vTablasS(i))
      Next i
    Case "t"
      For i = 1 To UBound(m_vTablasU)
        Set Item = lvDBInfo.ListItems.Add(, , m_vTablasU(i))
      Next i
    Case "v"
      For i = 1 To UBound(m_vVistas)
        Set Item = lvDBInfo.ListItems.Add(, , m_vVistas(i))
      Next i
    Case "o"
      For i = 1 To UBound(m_vOtros)
        Set Item = lvDBInfo.ListItems.Add(, , m_vOtros(i))
      Next i
    Case "p"
      For i = 1 To UBound(m_vSPsU)
        Set Item = lvDBInfo.ListItems.Add(, , m_vSPsU(i))
      Next i
    Case "y"
      For i = 1 To UBound(m_vSPsS)
        Set Item = lvDBInfo.ListItems.Add(, , m_vSPsS(i))
      Next i
 End Select
  
  Exit Sub
hdl:
End Sub

'-------------------------------------------------------------
' Splitter
Private Sub PicSplitter_MouseDown(Button As Integer, Shift As Integer, x As Single, y As Single)
    With PicSplitter
        PicSplitterBar.Move .Left, .Top, .Width \ 2, .Height - 20
    End With
    PicSplitterBar.Visible = True
    m_moving = True
End Sub

Private Sub PicSplitter_MouseMove(Button As Integer, Shift As Integer, x As Single, y As Single)
    Dim sglPos As Single

    If m_moving Then
        sglPos = x + PicSplitter.Left
        If sglPos < sglSplitLimit Then
            PicSplitterBar.Left = sglSplitLimit
        ElseIf sglPos > Width - sglSplitLimit Then
            PicSplitterBar.Left = Width - sglSplitLimit
        Else
            PicSplitterBar.Left = sglPos
        End If
    End If
End Sub
Private Sub PicSplitter_MouseUp(Button As Integer, Shift As Integer, x As Single, y As Single)
    SizeControls
    PicSplitterBar.Visible = False
    m_moving = False
End Sub

Private Sub SizeControls()
    Dim i As Integer
    Dim iHeigth     As Integer
    
    On Error GoTo ControlError
    
    DoEvents: DoEvents: DoEvents: DoEvents
    
    If WindowState = vbMinimized Then Exit Sub
    
    PicSplitterBar.Visible = False
    
    Shape1.Width = Me.Width
    
    If PicSplitterBar.Left > ScaleWidth Then
        PicSplitterBar.Left = ScaleWidth - 50
    End If
    
    lnButtons.Y1 = ScaleHeight - cmdAceptar.Height - 200
    lnButtons.Y2 = lnButtons.Y1
    
    lnSqlstmt.Y1 = lnButtons.Y1 - txSqlstmt.Height - 200
    lnSqlstmt.Y2 = lnSqlstmt.Y1
    
    opSql.Top = lnSqlstmt.Y1 - opSql.Height - 80
    
    txSqlstmt.Top = lnSqlstmt.Y1 + 80
    txSqlstmt.Width = ScaleWidth - txSqlstmt.Left * 2
    lnButtons.X2 = ScaleWidth - lnButtons.X1
    lnSqlstmt.X2 = lnButtons.X2
    lnTitle.X2 = lnButtons.X2
    
    iHeigth = opSql.Top - tvDBInfo.Top - 100
    
    PicSplitter.Left = PicSplitterBar.Left
    PicSplitter.Height = iHeigth
    PicSplitterBar.Height = iHeigth
    
    cmdAceptar.Top = ScaleHeight - cmdAceptar.Height - 100
    cmdCancelar.Top = cmdAceptar.Top
    
    tvDBInfo.Width = PicSplitter.Left
    tvDBInfo.Height = iHeigth
    lvDBInfo.Height = iHeigth
    lvDBInfo.Left = PicSplitter.Left + PicSplitter.Width
    lvDBInfo.Width = ScaleWidth - lvDBInfo.Left
    cmdCancelar.Left = ScaleWidth - cmdCancelar.Width - 50
    cmdAceptar.Left = cmdCancelar.Left - cmdAceptar.Width - 100
ControlError:
End Sub
' construccion - destruccion
Private Sub Form_Load()
  m_Ok = False
  CenterForm Me
  lvDBInfo.FlatScrollBar = False
  lvDBInfo.FullRowSelect = True
  lvDBInfo.GridLines = True
  tvDBInfo.Left = 0
  SizeControls
  opSpTable.Value = True
End Sub



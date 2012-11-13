VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Object = "{E82A759A-7510-4F56-B239-9C0B78CF437B}#1.0#0"; "CSImageList.ocx"
Object = "{757F6B6F-8057-4D0A-85C2-0A1807E33D34}#1.0#0"; "CSGrid2.ocx"
Begin VB.Form fDataBases 
   Caption         =   "Empresas"
   ClientHeight    =   3615
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4515
   Icon            =   "fDataBases.frx":0000
   LinkTopic       =   "Form1"
   MDIChild        =   -1  'True
   ScaleHeight     =   3615
   ScaleWidth      =   4515
   Begin MSComctlLib.ImageList imgMain 
      Left            =   2940
      Top             =   0
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483643
      ImageWidth      =   16
      ImageHeight     =   16
      MaskColor       =   12632256
      _Version        =   393216
      BeginProperty Images {2C247F25-8591-11D1-B16A-00C0F0283628} 
         NumListImages   =   3
         BeginProperty ListImage1 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fDataBases.frx":014A
            Key             =   ""
         EndProperty
         BeginProperty ListImage2 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fDataBases.frx":06E4
            Key             =   ""
         EndProperty
         BeginProperty ListImage3 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fDataBases.frx":0C7E
            Key             =   ""
         EndProperty
      EndProperty
   End
   Begin CSImageList.cImageList ilList 
      Left            =   2880
      Top             =   2520
      _ExtentX        =   953
      _ExtentY        =   953
      Size            =   940
      Images          =   "fDataBases.frx":0DD8
      KeyCount        =   1
      Keys            =   ""
   End
   Begin CSGrid2.cGrid grDataBase 
      Height          =   1860
      Left            =   240
      TabIndex        =   0
      Top             =   900
      Width           =   3705
      _ExtentX        =   6535
      _ExtentY        =   3281
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
   End
   Begin MSComctlLib.Toolbar tbMain 
      Height          =   330
      Left            =   60
      TabIndex        =   1
      Top             =   60
      Width           =   3360
      _ExtentX        =   5927
      _ExtentY        =   582
      ButtonWidth     =   609
      ButtonHeight    =   582
      Style           =   1
      ImageList       =   "imgMain"
      _Version        =   393216
      BeginProperty Buttons {66833FE8-8583-11D1-B16A-00C0F0283628} 
         NumButtons      =   5
         BeginProperty Button1 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Style           =   3
         EndProperty
         BeginProperty Button2 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "NEW"
            Object.ToolTipText     =   "Nuevo"
            ImageIndex      =   1
         EndProperty
         BeginProperty Button3 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "DELETE"
            Object.ToolTipText     =   "Borrar"
            ImageIndex      =   2
         EndProperty
         BeginProperty Button4 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Style           =   3
         EndProperty
         BeginProperty Button5 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "REFRESH"
            ImageIndex      =   3
         EndProperty
      EndProperty
   End
   Begin VB.Shape shToolbar 
      BorderColor     =   &H80000010&
      Height          =   435
      Left            =   0
      Top             =   0
      Width           =   3855
   End
End
Attribute VB_Name = "fDataBases"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' fDataBases
' 00-11-2002

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "fDataBases"
' estructuras
' variables privadas
Private m_IsPresent As Boolean
' eventos
' propiedadades publicas
Public Property Get IsPresent() As Boolean
  IsPresent = m_IsPresent
End Property
' propiedadades friend
' propiedades privadas
' funciones publicas
' funciones friend
' funciones privadas
Private Function pSetGrDataBases()
  With grDataBase
    .AddColumn , , , , , False
    .AddColumn , "Empresa", , , 200
    .AddColumn , "Base", , , 200
    .AddColumn , "Server", , , 200
    .AddColumn , "Login", , , 80
    .AddColumn , , , , , False
    .AddColumn , , , , , False
  End With
End Function

Private Sub pShowDataBases()
  Dim sqlstmt As String
  Dim db      As cDataBase
  Dim rs      As ADODB.Recordset
  Dim iRow    As Long
  Dim Encrypt As cEncrypt
  
  Set Encrypt = New cEncrypt
  
  Set db = GetDataBase
  sqlstmt = "select * from BaseDatos"
  If Not db.OpenRs(sqlstmt, rs) Then Exit Sub
  
  grDataBase.Redraw = False
  grDataBase.Clear False
  grDataBase.RowMode = True
  
  If Not rs.EOF Then
  
    rs.MoveLast
    rs.MoveFirst
    
    grDataBase.Rows = rs.RecordCount
  
    While Not rs.EOF
      iRow = iRow + 1
      
      pSetId iRow, db.ValField(rs.Fields, cscBdId)
      pSetEmpresa iRow, Encrypt.Decript(db.ValField(rs.Fields, cscBdEmpresa), c_LoginSignature)
      pSetBase iRow, Encrypt.Decript(db.ValField(rs.Fields, cscBdNombre), c_LoginSignature)
      pSetLogin iRow, Encrypt.Decript(db.ValField(rs.Fields, cscBdLogin), c_LoginSignature)
      pSetServer iRow, Encrypt.Decript(db.ValField(rs.Fields, cscBdServer), c_LoginSignature)
      pSetPassword iRow, Encrypt.Decript(db.ValField(rs.Fields, cscBdPwd), c_LoginSignature)
      
      pSetSecurityType iRow, db.ValField(rs.Fields, cscBdSecuritytype)
      
      rs.MoveNext
    Wend
  End If
  
  grDataBase.Redraw = True
End Sub

Private Function pGetId(ByVal iRow As Long) As Long
  pGetId = Val(pGetCol(iRow, 1))
End Function

Private Function pGetEmpresa(ByVal iRow As Long) As String
  pGetEmpresa = pGetCol(iRow, 2)
End Function

Private Function pGetBase(ByVal iRow As Long) As String
  pGetBase = pGetCol(iRow, 3)
End Function

Private Function pGetServer(ByVal iRow As Long) As String
  pGetServer = pGetCol(iRow, 4)
End Function

Private Function pGetLogin(ByVal iRow As Long) As String
  pGetLogin = pGetCol(iRow, 5)
End Function

Private Function pGetPassword(ByVal iRow As Long) As String
  pGetPassword = pGetCol(iRow, 6)
End Function

Private Function pGetSecurityType(ByVal iRow As Long) As Long
  pGetSecurityType = Val(pGetCol(iRow, 7))
End Function

Private Sub pSetId(ByVal iRow As Long, ByVal rhs As Long)
  pSetCol iRow, 1, rhs
End Sub

Private Sub pSetEmpresa(ByVal iRow As Long, ByVal rhs As String)
  pSetCol iRow, 2, rhs
  grDataBase.CellIcon(iRow, 2) = 1
End Sub

Private Sub pSetBase(ByVal iRow As Long, ByVal rhs As String)
  pSetCol iRow, 3, rhs
End Sub

Private Sub pSetServer(ByVal iRow As Long, ByVal rhs As String)
  pSetCol iRow, 4, rhs
End Sub

Private Sub pSetLogin(ByVal iRow As Long, ByVal rhs As String)
  pSetCol iRow, 5, rhs
End Sub

Private Sub pSetPassword(ByVal iRow As Long, ByVal rhs As String)
  pSetCol iRow, 6, rhs
End Sub

Private Sub pSetSecurityType(ByVal iRow As Long, ByVal rhs As String)
  pSetCol iRow, 7, rhs
End Sub

Private Function pGetCol(ByVal iRow As Long, ByVal iCol As Long) As String
  pGetCol = grDataBase.CellText(iRow, iCol)
End Function

Private Sub pSetCol(ByVal iRow As Long, ByVal iCol As Long, ByVal rhs As String)
  grDataBase.CellText(iRow, iCol) = rhs
End Sub

Private Sub pDelete(ByVal lRow As Long)
  On Error GoTo ControlError

  Dim sqlstmt As String
  Dim db      As cDataBase
  
  Set db = GetDataBase()
  
  sqlstmt = "sp_SysDomainDeleteDB " & pGetId(lRow)
  
  If Not db.Execute(sqlstmt) Then Exit Sub
  
  grDataBase.RemoveRow lRow
  
  pShowDataBases

  GoTo ExitProc
ControlError:
  MngError Err, "pDelete", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub tbMain_ButtonClick(ByVal Button As MSComctlLib.Button)
  On Error GoTo ControlError
  
  Select Case Button.Key
    Case "NEW"
      If pCanAdd() Then
        fDataBase.Show vbModal
        pShowDataBases
      End If
    Case "DELETE"
      pDelete grDataBase.SelectedRow
    Case "REFRESH"
      pShowDataBases
  End Select

  GoTo ExitProc
ControlError:
  MngError Err, "tbMain_ButtonClick", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub grDataBase_DblClick(ByVal lRow As Long, ByVal lCol As Long)
  On Error GoTo ControlError
  
  Load fDataBase
  
  With fDataBase
    .Id = pGetId(lRow)
    .txDataBase.Text = pGetBase(lRow)
    .txEmpresa.Text = pGetEmpresa(lRow)
    .txLogin.Text = pGetLogin(lRow)
    .txPassword.Text = pGetPassword(lRow)
    .txServer.Text = pGetServer(lRow)
    If pGetSecurityType(lRow) Then
      .opNT.Value = True
    Else
      .opSQL.Value = True
    End If
    .Changed = False
    .Show vbModal
  End With
  
  pShowDataBases

  GoTo ExitProc
ControlError:
  MngError Err, "grDataBase_DblClick", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Function pCanAdd() As Boolean
  Dim Empresas As Long
  Dim strCode  As String
  
  If Not GetActiveCode(strCode) Then Exit Function
  
  Empresas = GetEmpresas(strCode)

  'If Empresas <= grDataBase.Rows Then
  '  MsgWarning "La cantidad de licencias para empresas es de " & Empresas & ".;;" & c_GetCodigoStr
  '  Exit Function
  'End If

  pCanAdd = True
End Function

' construccion - destruccion
Private Sub Form_Load()
  On Error GoTo ControlError

  Me.WindowState = vbMaximized

  grDataBase.ImageList = ilList

  pSetGrDataBases
  pShowDataBases
  
  m_IsPresent = True

  GoTo ExitProc
ControlError:
  MngError Err, "Form_Load", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Form_Resize()
  On Error Resume Next
  grDataBase.Move 0, tbMain.Height + 200, ScaleWidth, ScaleHeight
  Me.shToolbar.Width = Me.ScaleWidth
End Sub

Private Sub Form_Unload(Cancel As Integer)
  m_IsPresent = False
End Sub
'//////////////////////////////
'  Codigo estandar de errores
'  On Error GoTo ControlError
'
'  GoTo ExitProc
'ControlError:
'  MngError err,"", C_Module, ""
'  If Err.Number <> 0 Then Resume ExitProc
'ExitProc:
'  On Error Resume Next

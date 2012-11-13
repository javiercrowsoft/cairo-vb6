VERSION 5.00
Object = "{57EC5E1A-9098-47A9-A8E3-EF352F97282B}#3.0#0"; "CSButton.ocx"
Object = "{4229EED8-03F6-4D02-A380-811F63059FE6}#1.3#0"; "CSGrid2.ocx"
Object = "{E82A759A-7510-4F56-B239-9C0B78CF437B}#1.0#0"; "CSImageList.ocx"
Begin VB.Form fDataBases 
   BackColor       =   &H00FFFFFF&
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Bases"
   ClientHeight    =   4590
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   7230
   Icon            =   "fDataBases.frx":0000
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   4590
   ScaleWidth      =   7230
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin CSButton.cButton cmdOk 
      Default         =   -1  'True
      Height          =   360
      Left            =   4200
      TabIndex        =   1
      Top             =   4170
      Width           =   1545
      _ExtentX        =   2725
      _ExtentY        =   635
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
   Begin CSButton.cButton cmdCancel 
      Cancel          =   -1  'True
      Height          =   360
      Left            =   5820
      TabIndex        =   2
      Top             =   4170
      Width           =   1365
      _ExtentX        =   2408
      _ExtentY        =   635
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
   Begin CSImageList.cImageList ilList 
      Left            =   6435
      Top             =   225
      _ExtentX        =   953
      _ExtentY        =   953
      Size            =   940
      Images          =   "fDataBases.frx":038A
      KeyCount        =   1
      Keys            =   ""
   End
   Begin CSGrid2.cGrid grDataBase 
      Height          =   2895
      Left            =   90
      TabIndex        =   0
      Top             =   1035
      Width           =   7035
      _ExtentX        =   12409
      _ExtentY        =   5106
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
   Begin VB.Shape Shape1 
      BackColor       =   &H8000000F&
      BackStyle       =   1  'Opaque
      BorderColor     =   &H8000000F&
      BorderStyle     =   0  'Transparent
      Height          =   3120
      Left            =   0
      Top             =   945
      Width           =   7260
   End
   Begin VB.Label Label1 
      BackStyle       =   0  'Transparent
      Caption         =   "Seleccione la base de datos de donde extraer los informes."
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   600
      Left            =   1035
      TabIndex        =   3
      Top             =   225
      Width           =   5505
   End
   Begin VB.Image Image1 
      Height          =   735
      Left            =   90
      Picture         =   "fDataBases.frx":0756
      Top             =   90
      Width           =   750
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
Private m_Ok            As Boolean
' eventos
' propiedadades publicas
Public Property Get Ok() As Boolean
  Ok = m_Ok
End Property

' propiedadades friend
' propiedades privadas
' funciones publicas
' funciones friend
' funciones privadas
Private Function pSetGrDataBases()
  With grDataBase
    .AddColumn , , , , , False
    .AddColumn , "Empresa", , , 160
    .AddColumn , "Base", , , 100
    .AddColumn , "Server", , , 100
    .AddColumn , "Login", , , 60
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
    
    If grDataBase.Rows Then grDataBase.SelectedRow = 1
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

Private Sub cmdCancel_Click()
  m_Ok = False
  Me.Hide
End Sub

Private Sub cmdOk_Click()
  
  Dim lRow As Long
  
  lRow = grDataBase.SelectedRow
  
  If lRow Then
    g_db.db_id = pGetId(lRow)
    g_db.server = pGetServer(lRow)
    g_db.DataBase = pGetBase(lRow)
    g_db.User = pGetLogin(lRow)
    g_db.Pwd = pGetPassword(lRow)
    g_db.UseNT = pGetSecurityType(lRow)
  End If
  
  m_Ok = True
  Me.Hide
End Sub

Private Sub grDataBase_DblClick(ByVal lRow As Long, ByVal lCol As Long)
  On Error GoTo ControlError
  
  cmdOk_Click

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

  If Empresas <= grDataBase.Rows Then
    MsgWarning "La cantidad de licencias para empresas es de " & Empresas & ".;;" & c_GetCodigoStr
    Exit Function
  End If

  pCanAdd = True
End Function

' construccion - destruccion
Private Sub Form_Load()
  On Error GoTo ControlError

  CSKernelClient2.CenterForm Me

  m_Ok = False

  grDataBase.ImageList = ilList

  pSetGrDataBases
  pShowDataBases
  
  GoTo ExitProc
ControlError:
  MngError Err, "Form_Load", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
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


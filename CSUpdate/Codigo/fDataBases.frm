VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
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
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   4590
   ScaleWidth      =   7230
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "&Cancelar"
      Height          =   330
      Left            =   5850
      TabIndex        =   3
      Top             =   4185
      Width           =   1185
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "&Aceptar"
      Default         =   -1  'True
      Height          =   330
      Left            =   4590
      TabIndex        =   2
      Top             =   4185
      Width           =   1185
   End
   Begin MSComctlLib.ListView grDataBase 
      Height          =   2895
      Left            =   90
      TabIndex        =   1
      Top             =   1035
      Width           =   7035
      _ExtentX        =   12409
      _ExtentY        =   5106
      LabelWrap       =   -1  'True
      HideSelection   =   -1  'True
      _Version        =   393217
      ForeColor       =   -2147483640
      BackColor       =   -2147483643
      BorderStyle     =   1
      Appearance      =   1
      NumItems        =   0
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
   Begin VB.Image Image1 
      Height          =   735
      Left            =   90
      Picture         =   "fDataBases.frx":038A
      Top             =   90
      Width           =   750
   End
   Begin VB.Label Label1 
      BackStyle       =   0  'Transparent
      Caption         =   "Seleccione la base de datos de donde extraer los informes."
      Height          =   375
      Left            =   1035
      TabIndex        =   0
      Top             =   495
      Width           =   5505
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
Private m_ok            As Boolean
' eventos
' propiedadades publicas
Public Property Get Ok() As Boolean
  Ok = m_ok
End Property

' propiedadades friend
' propiedades privadas
' funciones publicas
' funciones friend
' funciones privadas
Private Function pSetGrDataBases()
  With grDataBase
    .View = lvwReport
    .LabelEdit = lvwManual
    .FullRowSelect = True
    .HideSelection = False
    
    With .ColumnHeaders
      .Add
      .Add , , "Empresa", 2500
      .Add , , "Base", 2000
      .Add , , "Server", 2000
      .Add , , "Login", 1000
      .Add
      .Add
    End With
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
  
  grDataBase.ListItems.Clear
  grDataBase.Sorted = False
  
  If Not rs.EOF Then
  
    rs.MoveLast
    rs.MoveFirst
    
    While Not rs.EOF
    
      grDataBase.ListItems.Add
    
      iRow = iRow + 1
      
      pSetId iRow, db.ValField(rs.fields, cscBdId)
      pSetEmpresa iRow, Encrypt.Decrypt(db.ValField(rs.fields, cscBdEmpresa), c_LoginSignature)
      pSetBase iRow, Encrypt.Decrypt(db.ValField(rs.fields, cscBdNombre), c_LoginSignature)
      pSetLogin iRow, Encrypt.Decrypt(db.ValField(rs.fields, cscBdLogin), c_LoginSignature)
      pSetServer iRow, Encrypt.Decrypt(db.ValField(rs.fields, cscBdServer), c_LoginSignature)
      pSetPassword iRow, Encrypt.Decrypt(db.ValField(rs.fields, cscBdPwd), c_LoginSignature)
      
      pSetSecurityType iRow, db.ValField(rs.fields, cscBdSecuritytype)
      
      rs.MoveNext
    Wend
    
    If grDataBase.ListItems.Count Then
      grDataBase.ListItems(1).Selected = True
    End If
  End If
 
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
  If iCol > 1 Then
    pGetCol = grDataBase.ListItems.Item(iRow).SubItems(iCol - 1)
  Else
    pGetCol = grDataBase.ListItems.Item(iRow).Text
  End If
End Function

Private Sub pSetCol(ByVal iRow As Long, ByVal iCol As Long, ByVal rhs As String)
  If iCol > 1 Then
    grDataBase.ListItems.Item(iRow).SubItems(iCol - 1) = rhs
  Else
    grDataBase.ListItems.Item(iRow).Text = rhs
  End If
End Sub

Private Sub pDelete(ByVal lRow As Long)
  On Error GoTo ControlError

  Dim sqlstmt As String
  Dim db      As cDataBase
  
  Set db = GetDataBase()
  
  sqlstmt = "sp_SysDomainDeleteDB " & pGetId(lRow)
  
  If Not db.Execute(sqlstmt, "") Then Exit Sub
  
  grDataBase.ListItems.Remove lRow
  
  pShowDataBases

  GoTo ExitProc
ControlError:
  MngError Err, "pDelete", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub grDataBase_DblClick()
  On Error GoTo ControlError
  
  cmdOk_Click

  GoTo ExitProc
ControlError:
  MngError Err, "grDataBase_DblClick", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub cmdCancel_Click()
  m_ok = False
  Me.Hide
End Sub

Private Sub cmdOk_Click()
 
  Dim lRow As Long
  
  lRow = grDataBase.SelectedItem.Index
  
  If lRow Then
    g_db.db_id = pGetId(lRow)
    g_db.server = pGetServer(lRow)
    g_db.DataBase = pGetBase(lRow)
    g_db.User = pGetLogin(lRow)
    g_db.Pwd = pGetPassword(lRow)
    g_db.UseNT = pGetSecurityType(lRow)
  End If
  
  m_ok = True
  Me.Hide
End Sub

Private Function pCanAdd() As Boolean
  Dim Empresas As Long
  Dim strCode  As String
  
  If Not GetActiveCode(strCode) Then Exit Function
  
  Empresas = GetEmpresas(strCode)

  If Empresas <= grDataBase.ListItems.Count Then
    MsgWarning "La cantidad de licencias para empresas es de " & Empresas & ".;;" & c_GetCodigoStr
    Exit Function
  End If

  pCanAdd = True
End Function

' construccion - destruccion
Private Sub Form_Load()
  On Error GoTo ControlError

  m_ok = False

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

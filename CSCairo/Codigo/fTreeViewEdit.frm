VERSION 5.00
Object = "{353A8433-36B8-422E-ABBD-36CEE8BE628E}#1.0#0"; "CSButton.ocx"
Object = "{F7BB685C-0860-4FD1-A9CF-22277199D7A5}#1.2#0"; "CSMaskEdit2.ocx"
Object = "{EBA71138-C194-4F8F-8A43-4781BBB517F8}#1.0#0"; "CSTree2.ocx"
Begin VB.Form fTreeViewEdit 
   Caption         =   "Vista"
   ClientHeight    =   7500
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   10575
   Icon            =   "fTreeViewEdit.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   7500
   ScaleWidth      =   10575
   Begin CSMaskEdit2.cMultiLine txDescrip 
      Height          =   915
      Left            =   1380
      TabIndex        =   5
      Top             =   780
      Width           =   5595
      _ExtentX        =   9869
      _ExtentY        =   1614
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
      BorderColor     =   12164479
      BorderType      =   1
   End
   Begin CSMaskEdit2.cMaskEdit txNombre 
      Height          =   315
      Left            =   1380
      TabIndex        =   2
      Top             =   300
      Width           =   5595
      _ExtentX        =   9869
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
      ForeColor       =   0
      EnabledNoChngBkColor=   0   'False
      Text            =   ""
      csType          =   5
      BorderColor     =   12164479
      BorderType      =   1
      csNotRaiseError =   -1  'True
      ButtonStyle     =   0
   End
   Begin CSButton.cButton cmdSave 
      Height          =   375
      Left            =   7140
      TabIndex        =   1
      Top             =   300
      Width           =   1575
      _ExtentX        =   2778
      _ExtentY        =   661
      Caption         =   "Guardar"
      Style           =   3
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
   Begin VB.Timer TmrCompatCollObjEdit 
      Interval        =   60000
      Left            =   2880
      Top             =   7215
   End
   Begin VB.Timer tmResize 
      Left            =   6480
      Top             =   6360
   End
   Begin CSTree2.cTreeCtrl csTree1 
      Height          =   4875
      Left            =   720
      TabIndex        =   0
      Top             =   2760
      Width           =   4575
      _ExtentX        =   8070
      _ExtentY        =   8599
   End
   Begin CSButton.cButton cmdShowCollapsed 
      Height          =   375
      Left            =   180
      TabIndex        =   6
      Top             =   1800
      Width           =   2655
      _ExtentX        =   4683
      _ExtentY        =   661
      Caption         =   "Mostrar la carpeta colapsada"
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
      Picture         =   "fTreeViewEdit.frx":038A
   End
   Begin CSButton.cButton cmdShowExpanded 
      Height          =   375
      Left            =   180
      TabIndex        =   7
      Top             =   2220
      Width           =   2655
      _ExtentX        =   4683
      _ExtentY        =   661
      Caption         =   "Mostrar la carpeta expandida"
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
      Picture         =   "fTreeViewEdit.frx":0724
   End
   Begin CSButton.cButton cmdCopy 
      Height          =   375
      Left            =   7140
      TabIndex        =   8
      Top             =   720
      Width           =   1575
      _ExtentX        =   2778
      _ExtentY        =   661
      Caption         =   "Duplicar"
      Style           =   5
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
   Begin CSButton.cButton cmdCollapseAll 
      Height          =   375
      Left            =   2940
      TabIndex        =   9
      Top             =   1800
      Width           =   3735
      _ExtentX        =   6588
      _ExtentY        =   661
      Caption         =   "Marcar todas las carpetas como colapsadas"
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
      Picture         =   "fTreeViewEdit.frx":0ABE
   End
   Begin CSButton.cButton cmdExpandAll 
      Height          =   375
      Left            =   2940
      TabIndex        =   10
      Top             =   2220
      Width           =   3735
      _ExtentX        =   6588
      _ExtentY        =   661
      Caption         =   "Marcar todas las carpetas como expandidas"
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
      Picture         =   "fTreeViewEdit.frx":0E58
   End
   Begin VB.Label Label2 
      BackStyle       =   0  'Transparent
      Caption         =   "Descripción:"
      Height          =   255
      Left            =   120
      TabIndex        =   4
      Top             =   780
      Width           =   1215
   End
   Begin VB.Label Label1 
      BackStyle       =   0  'Transparent
      Caption         =   "Nombre:"
      Height          =   255
      Left            =   120
      TabIndex        =   3
      Top             =   360
      Width           =   1215
   End
   Begin VB.Shape shTop 
      BackStyle       =   1  'Opaque
      BorderStyle     =   0  'Transparent
      Height          =   2655
      Left            =   0
      Top             =   0
      Width           =   9375
   End
End
Attribute VB_Name = "fTreeViewEdit"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Const c_name As String = "treeviewsedit"

' Ojo estas constantes no pueden cambiar por que se usan en la logica
' de fTreeViewEdit en cairo
'
Const IMG_FOLDER_OPEN = 2
Const IMG_FOLDER_CLOSE = 1
Const IMG_FOLDER_COLLAPSED_OPEN = 11
Const IMG_FOLDER_COLLAPSED_CLOSE = 10

Private m_TblId       As Long
Private m_Name        As String
Private m_arbv_id     As Long
Private m_arb_id      As Long
Private m_waschanged  As Boolean

Public Property Let TblId(ByVal rhs As Long)
  m_TblId = rhs
End Property

Public Property Let AbmName(ByVal rhs As String)
  m_Name = rhs
End Property

Public Property Let ArbvId(ByVal rhs As Long)
  m_arbv_id = rhs
End Property

Public Property Let ArbId(ByVal rhs As Long)
  m_arb_id = rhs
End Property

Public Function Init() As Boolean
  Caption = m_Name
  csTree1.NameClient = m_Name
  csTree1.IconText = 0
  csTree1.HideTreeComobo
  csTree1.InViewMode = True
  Init = csTree1.Load(m_TblId)
  csTree1.SetTree m_arb_id
  csTree1.CollapseChanged = False

  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  Dim db      As cDataBase
  
  Set db = OAPI.Database
  
  If m_arbv_id Then
  
    sqlstmt = "select * from ArbolVista where arbv_id = " & m_arbv_id
    If Not db.OpenRs(sqlstmt, rs) Then Exit Function
    If rs.EOF Then Exit Function
  
    txNombre.Text = db.ValField(rs.Fields, "arbv_nombre")
    txDescrip.Text = db.ValField(rs.Fields, "arbv_descrip")
  
  End If
  
  Dim ram_id  As Long
  Dim nodo    As Node
  Dim estado  As Integer
  
  sqlstmt = "sp_ArbVistaGetItems " & m_arbv_id
  If Not db.OpenRs(sqlstmt, rs) Then Exit Function
    
  While Not rs.EOF
  
    For Each nodo In csTree1.TreeCtrl.Nodes
      
      ram_id = pGetIdFromKey(nodo.key)
      estado = db.ValField(rs.Fields, "ramv_estado")
      
      If rs.Fields.Item("ram_id") = ram_id Then
        
        If estado = 3 Then
          nodo.Image = IMG_FOLDER_COLLAPSED_CLOSE
          nodo.SelectedImage = IMG_FOLDER_COLLAPSED_OPEN
          
          nodo.Expanded = False
        ElseIf estado = 2 Then
          nodo.Image = IMG_FOLDER_COLLAPSED_CLOSE
          nodo.SelectedImage = IMG_FOLDER_COLLAPSED_OPEN
          
          nodo.Expanded = True
        Else
          nodo.Expanded = estado
        End If
        Exit For
      End If
      
    Next
    
    rs.MoveNext
  Wend
  
  m_waschanged = False
  csTree1.CollapseChanged = False
End Function

Private Sub cmdCopy_Click()
  m_arbv_id = csNO_ID
  txNombre.ForeColor = vbBlue
  txNombre.FontBold = True
  m_waschanged = True
End Sub

Private Sub cmdSave_Click()
  On Error Resume Next
  
  If Not pValidate() Then Exit Sub
  
  If pSave() Then
  
    m_waschanged = False
    csTree1.CollapseChanged = False
  End If
  
End Sub

Private Function pValidate() As Boolean
  If Trim$(txNombre.Text) = "" Then
    MsgInfo "Debe indicar un nombre"
    Exit Function
  End If
  pValidate = True
End Function

Private Function pSave() As Boolean
  Dim nodo    As Node
  Dim ram_id  As Long
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  Dim db      As cDataBase
  
  Set db = OAPI.Database
  
  sqlstmt = "sp_ArbVistaSave " & m_arb_id & "," _
                    & m_arbv_id & "," _
                    & db.sqlString(txNombre.Text) & "," _
                    & db.sqlString(txDescrip.Text)
  
  If Not db.OpenRs(sqlstmt, rs) Then Exit Function
  If rs.EOF Then Exit Function
  
  m_arbv_id = rs.Fields.Item(0).Value
  
  sqlstmt = "sp_ArbVistaDeleteItems " & m_arbv_id
  If Not db.Execute(sqlstmt) Then Exit Function
  
  For Each nodo In csTree1.TreeCtrl.Nodes
    ram_id = pGetIdFromKey(nodo.key)
    If nodo.Image = IMG_FOLDER_COLLAPSED_CLOSE Then
      If nodo.Expanded Then
        sqlstmt = "sp_ArbVistaSaveItem " & m_arbv_id & "," & ram_id & ", 2"
      Else
        sqlstmt = "sp_ArbVistaSaveItem " & m_arbv_id & "," & ram_id & ", 3"
      End If
    ElseIf nodo.Expanded Then
      sqlstmt = "sp_ArbVistaSaveItem " & m_arbv_id & "," & ram_id & ", 1"
    Else
      sqlstmt = "sp_ArbVistaSaveItem " & m_arbv_id & "," & ram_id & ", 0"
    End If
    
    If Not db.Execute(sqlstmt) Then Exit Function
  Next
  
  pSave = True
End Function

Private Function pGetIdFromKey(ByVal key As String) As Long
  If Left$(LCase$(key), 1) = "k" Then
    pGetIdFromKey = Val(Mid$(key, 2))
  Else
    pGetIdFromKey = 0
  End If
End Function

Private Sub cmdShowCollapsed_Click()
  On Error Resume Next
  
  csTree1.showCollpased
  m_waschanged = True
End Sub

Private Sub cmdShowExpanded_Click()
  On Error Resume Next
  
  csTree1.showExpanded
  m_waschanged = True
End Sub

Private Sub cmdCollapseAll_Click()
  On Error Resume Next
  
  Dim nodo As Node
  
  For Each nodo In csTree1.TreeCtrl.Nodes
    nodo.Image = IMG_FOLDER_COLLAPSED_CLOSE
    nodo.SelectedImage = IMG_FOLDER_COLLAPSED_OPEN
  Next
  m_waschanged = True
End Sub

Private Sub cmdExpandAll_Click()
  On Error Resume Next
  
  Dim nodo As Node
  
  For Each nodo In csTree1.TreeCtrl.Nodes
    nodo.Image = IMG_FOLDER_CLOSE
    nodo.SelectedImage = IMG_FOLDER_OPEN
  Next
  m_waschanged = True
End Sub

Private Sub Form_Load()
  On Error Resume Next
  
  CSKernelClient2.LoadForm Me, c_name
  
  DoEvents
  
  csTree1.Top = shTop.Height
  csTree1.Left = 0
    
End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
  On Error Resume Next
  
  Dim answer As Integer
  
  If csTree1.CollapseChanged Or m_waschanged Then
    answer = MsgBox("Ud. ha realizado cambios que no se han guardado." & vbCrLf & "¿Desea guardar estos cambios?", vbQuestion + vbYesNoCancel)
    If answer = vbYes Then

      If pValidate() Then
        If Not pSave() Then
          Cancel = True
        End If
      Else
        Cancel = True
      End If
    ElseIf answer = vbCancel Then
      Cancel = True
    End If
  End If
End Sub

Private Sub Form_Resize()
  On Error Resume Next
  shTop.Width = Me.ScaleWidth
  csTree1.Height = Me.ScaleHeight - csTree1.Top
  csTree1.Width = Me.ScaleWidth
End Sub

Private Sub Form_Unload(Cancel As Integer)
  On Error Resume Next
  CSKernelClient2.UnloadForm Me, c_name, False
End Sub

Private Sub txDescrip_Change()
  m_waschanged = True
End Sub

Private Sub txNombre_Change()
  m_waschanged = True
End Sub

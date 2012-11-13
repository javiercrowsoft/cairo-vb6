VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Begin VB.Form fMain 
   Caption         =   "Configuracion de CSGetHtmlToken"
   ClientHeight    =   6735
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   7140
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   ScaleHeight     =   6735
   ScaleWidth      =   7140
   StartUpPosition =   3  'Windows Default
   Begin VB.Frame Frame2 
      Caption         =   "Tokens"
      Height          =   3075
      Left            =   120
      TabIndex        =   12
      Top             =   2820
      Width           =   6495
      Begin VB.CommandButton cmdAdd 
         Caption         =   "Agregar"
         Height          =   315
         Left            =   5100
         TabIndex        =   16
         Top             =   420
         Width           =   1215
      End
      Begin VB.ListBox lsTokens 
         Height          =   2595
         Left            =   240
         TabIndex        =   15
         Top             =   300
         Width           =   4695
      End
      Begin VB.CommandButton cmdEdit 
         Caption         =   "Editar"
         Height          =   315
         Left            =   5100
         TabIndex        =   14
         Top             =   840
         Width           =   1215
      End
      Begin VB.CommandButton cmdRemove 
         Caption         =   "Remover"
         Height          =   315
         Left            =   5100
         TabIndex        =   13
         Top             =   1260
         Width           =   1215
      End
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "&Cancelar"
      Height          =   315
      Left            =   5460
      TabIndex        =   11
      Top             =   6300
      Width           =   1575
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "&Aceptar"
      Default         =   -1  'True
      Height          =   315
      Left            =   3780
      TabIndex        =   10
      Top             =   6300
      Width           =   1575
   End
   Begin VB.Frame Frame1 
      Caption         =   "Conexión"
      Height          =   1695
      Left            =   120
      TabIndex        =   3
      Top             =   900
      Width           =   6495
      Begin VB.TextBox txPassword 
         Height          =   315
         IMEMode         =   3  'DISABLE
         Left            =   840
         PasswordChar    =   "*"
         TabIndex        =   9
         Top             =   1200
         Width           =   2475
      End
      Begin VB.TextBox txUser 
         Height          =   315
         Left            =   840
         TabIndex        =   7
         Top             =   780
         Width           =   2475
      End
      Begin VB.TextBox txProxy 
         Height          =   315
         Left            =   840
         TabIndex        =   5
         Top             =   360
         Width           =   2475
      End
      Begin VB.Label Label4 
         Caption         =   "&PWD"
         Height          =   315
         Left            =   180
         TabIndex        =   8
         Top             =   1260
         Width           =   795
      End
      Begin VB.Label Label3 
         Caption         =   "Pro&xy"
         Height          =   315
         Left            =   180
         TabIndex        =   4
         Top             =   360
         Width           =   675
      End
      Begin VB.Label Label2 
         Caption         =   "&USR"
         Height          =   255
         Left            =   180
         TabIndex        =   6
         Top             =   780
         Width           =   675
      End
   End
   Begin MSComDlg.CommonDialog dlg 
      Left            =   5040
      Top             =   0
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.CommandButton cmdOpen 
      Caption         =   "..."
      Height          =   315
      Left            =   6660
      TabIndex        =   2
      Top             =   480
      Width           =   375
   End
   Begin VB.TextBox txFileIni 
      Height          =   315
      Left            =   120
      TabIndex        =   1
      Top             =   480
      Width           =   6495
   End
   Begin VB.Line Line2 
      BorderColor     =   &H80000014&
      X1              =   60
      X2              =   7080
      Y1              =   6135
      Y2              =   6135
   End
   Begin VB.Line Line1 
      BorderColor     =   &H80000010&
      X1              =   60
      X2              =   7080
      Y1              =   6120
      Y2              =   6120
   End
   Begin VB.Label Label1 
      Caption         =   "&Archivo de Configuración:"
      Height          =   315
      Left            =   120
      TabIndex        =   0
      Top             =   180
      Width           =   2415
   End
End
Attribute VB_Name = "fMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Declare Function GetPrivateProfileString Lib "kernel32" Alias "GetPrivateProfileStringA" _
                                (ByVal lpApplicationName As String, _
                                 ByVal lpKeyName As Any, _
                                 ByVal lpDefault As String, _
                                 ByVal lpReturnedString As String, _
                                 ByVal nSize As Long, _
                                 ByVal lpFileName As String) As Long
                                
Private Declare Function WritePrivateProfileString Lib "kernel32" Alias "WritePrivateProfileStringA" _
                                (ByVal lpApplicationName As String, _
                                 ByVal lpKeyName As Any, _
                                 ByVal lpString As Any, _
                                 ByVal lpFileName As String) As Long

Private Const c_connection          As String = "CONNECTION"
Private Const c_proxy               As String = "PROXY"
Private Const c_proxy_default       As String = "192.160.142.98"
Private Const c_usr                 As String = "USR"
Private Const c_pwd                 As String = "PWD"

Private Const c_config              As String = "CONFIG"
Private Const c_tokens              As String = "TOKENS"

Private Const c_url                 As String = "URL"
Private Const c_tag                 As String = "TAG"
Private Const c_tag_end             As String = "TAG_END"
Private Const c_run_at              As String = "RUN_AT"
Private Const c_run_between         As String = "RUN_BETWEEN"

Private Const c_delimiter           As String = "|"

Private m_Tokens As Collection

Private Sub cmdAdd_Click()
  On Error GoTo ControlError
  
  fToken.Show vbModal
  
  If fToken.Ok Then
    Dim Token As cToken
    Set Token = New cToken
    
    With fToken
      Token.Name = .txName.Text
      Token.RunAt = .txRunAt.Text
      Token.RunBetween = .txRunBetween.Text
      Token.Tag = .txTag.Text
      Token.TagEnd = .txTagEnd.Text
      Token.Url = .txUrl.Text
    End With
    
    m_Tokens.Add Token, Token.Name
    lsTokens.AddItem Token.Name
    
    Unload fToken
  End If
  
  Exit Sub
ControlError:

  If Err.Number = 457 Then
    MsgBox "ya existe un Token con ese nombre, cambielo", vbExclamation
  Else
    MsgBox Err.Description
  End If
  
  If Err.Number <> 0 Then Resume ExitProc
  
ExitProc:
  On Error Resume Next
  Unload fToken
End Sub

Private Sub cmdCancel_Click()
  Unload Me
End Sub

Private Sub cmdEdit_Click()
  On Error GoTo ControlError
  
  If lsTokens.ListIndex <> -1 Then
    Load fToken
    
    Dim Token As cToken
    Set Token = m_Tokens.item(lsTokens.Text)
    
    With fToken
      .txName.Text = Token.Name
      .txRunAt.Text = Token.RunAt
      .txRunBetween.Text = Token.RunBetween
      .txTag.Text = Token.Tag
      .txTagEnd.Text = Token.TagEnd
      .txUrl.Text = Token.Url
    End With
    
    fToken.Show vbModal
    
    If fToken.Ok Then
      
      With fToken
        Token.Name = .txName.Text
        Token.RunAt = .txRunAt.Text
        Token.RunBetween = .txRunBetween.Text
        Token.Tag = .txTag.Text
        Token.TagEnd = .txTagEnd.Text
        Token.Url = .txUrl.Text
      End With
            
      Unload fToken
    End If
    
  Else
    MsgBox "Debe elegir un item para editar"
  End If
  
  Exit Sub
ControlError:

  If Err.Number = 457 Then
    MsgBox "ya existe un Token con ese nombre, cambielo", vbExclamation
  Else
    MsgBox Err.Description
  End If
  
  If Err.Number <> 0 Then Resume ExitProc
  
ExitProc:
  On Error Resume Next
  Unload fToken
End Sub

Private Sub cmdOk_Click()

  If txFileIni.Text <> vbNullString Then
    SetIniValue c_connection, c_proxy, txProxy.Text, txFileIni.Text
    SetIniValue c_connection, c_usr, txUser.Text, txFileIni.Text
    SetIniValue c_connection, c_pwd, txPassword.Text, txFileIni.Text
    
    Dim Token   As cToken
    Dim Tokens  As String
    Dim Section As String
    
    For Each Token In m_Tokens
      
      Tokens = Tokens & Token.Name & c_delimiter
    
      Section = UCase$(Token.Name)
      SetIniValue Section, c_url, Token.Url, txFileIni.Text
      SetIniValue Section, c_run_at, Token.RunAt, txFileIni.Text
      SetIniValue Section, c_run_between, Token.RunBetween, txFileIni.Text
      SetIniValue Section, c_tag, Token.Tag, txFileIni.Text
      SetIniValue Section, c_tag_end, Token.TagEnd, txFileIni.Text
    Next
    
    If Right$(Tokens, 1) = c_delimiter Then
      Tokens = Left$(Tokens, Len(Tokens) - 1)
    End If
    SetIniValue c_config, c_tokens, Tokens, txFileIni.Text
    
    Unload Me
  Else
    MsgBox "debe indicar un archivo de configuracion para guardar los parametros"
  End If
End Sub

Private Sub cmdOpen_Click()
  With dlg
    .Filter = "Archivos de configuracion|*.ini"
    .ShowOpen
    If .FileName <> vbNullString Then
      txFileIni.Text = .FileName
      txProxy.Text = GetIniValue(c_connection, c_proxy, c_proxy_default, txFileIni.Text)
      txUser.Text = GetIniValue(c_connection, c_usr, vbNullString, txFileIni.Text)
      txPassword.Text = GetIniValue(c_connection, c_pwd, vbNullString, txFileIni.Text)
      
      Dim Token   As cToken
      Dim Tokens  As String
      Dim vTokens As Variant
      Dim i       As Integer
      Dim Section As String
      
      Set m_Tokens = New Collection
      lsTokens.Clear
      
      Tokens = GetIniValue(c_config, c_tokens, vbNullString, txFileIni.Text)
      vTokens = Split(Tokens, c_delimiter)
      For i = 0 To UBound(vTokens)
        Set Token = New cToken
        Token.Name = vTokens(i)
        Section = UCase$(Token.Name)
        Token.Url = GetIniValue(Section, c_url, vbNullString, txFileIni.Text)
        Token.Tag = GetIniValue(Section, c_tag, vbNullString, txFileIni.Text)
        Token.TagEnd = GetIniValue(Section, c_tag_end, vbNullString, txFileIni.Text)
        Token.RunAt = GetIniValue(Section, c_run_at, vbNullString, txFileIni.Text)
        Token.RunBetween = GetIniValue(Section, c_run_between, vbNullString, txFileIni.Text)
        
        m_Tokens.Add Token, Token.Name
        lsTokens.AddItem Token.Name
      Next i
    End If
  End With
End Sub

Private Sub cmdRemove_Click()
  On Error GoTo ControlError
  
  With lsTokens
    If .ListIndex <> -1 Then
      m_Tokens.Remove .Text
      .RemoveItem .ListIndex
      If .ListCount Then
        .ListIndex = 0
      End If
    Else
      MsgBox "Debe elegir un item para remover"
    End If
  End With
  
  Exit Sub
ControlError:

  If Err.Number = 457 Then
    MsgBox "ya existe un Token con ese nombre, cambielo", vbExclamation
  Else
    MsgBox Err.Description
  End If
End Sub

Private Sub Form_Initialize()
  Set m_Tokens = New Collection
End Sub

Private Sub Form_Terminate()
  Set m_Tokens = Nothing
End Sub

Private Sub Form_Load()
  With Me
    .Move (Screen.Width - .Width) * 0.5, (Screen.Height - .Height) * 0.5
  End With
End Sub

Public Function GetIniValue(ByVal Section As String, _
                            ByVal item As String, _
                            ByVal default As String, _
                            ByVal file As String) As String
  
  On Error GoTo ControlError

  Dim buffer As String
  Dim length As Integer
  Dim rtn    As String
 
  buffer = String$(256, " ")
  length = GetPrivateProfileString(Section, item, default, buffer, Len(buffer), file)
  rtn = Mid$(buffer, 1, length)
  
  GetIniValue = rtn
  
  GoTo ExitProc
ControlError:
  MsgBox Err.Description
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Public Sub SetIniValue(ByVal Section, _
                       ByVal item As String, _
                       ByVal value As String, _
                       ByVal file As String)
                       
  On Error GoTo ControlError
  
  WritePrivateProfileString Section, item, value, file

  GoTo ExitProc
ControlError:
  MsgBox Err.Description
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub


VERSION 5.00
Begin VB.Form fMain 
   Caption         =   "CS-Monitor de Seguridad"
   ClientHeight    =   5160
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   5880
   Icon            =   "fMain.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   5160
   ScaleWidth      =   5880
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton CmdRefrescar 
      Caption         =   "&Refrescar"
      Height          =   330
      Left            =   45
      TabIndex        =   1
      Top             =   4725
      Width           =   1455
   End
   Begin VB.TextBox TxInfo 
      BackColor       =   &H00000000&
      BeginProperty Font 
         Name            =   "Courier New"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FFFFFF&
      Height          =   4515
      Left            =   45
      MultiLine       =   -1  'True
      ScrollBars      =   3  'Both
      TabIndex        =   0
      Top             =   90
      Width           =   5775
   End
End
Attribute VB_Name = "fMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private m_Servidor  As CSInterfaces.cISecurity

Private WithEvents m_ConfigEvents As CSConfig.cConfig
Attribute m_ConfigEvents.VB_VarHelpID = -1
Private m_Config    As CSInterfaces.cIConfig

Private Sub CmdRefrescar_Click()
    m_ConfigEvents_RefreshLogins
End Sub

Private Sub Form_Load()
'--------------------------------------------------------------------------
'   COLISIONES POR OLE
'--------------------------------------------------------------------------
    Dim iCounter As Integer
    Dim nCurErrorCount As Integer
    Const MAX_ERROR_COUNT = 10
    
    On Error GoTo CallbackError
'--------------------------------------------------------------------------
    
    Set m_ConfigEvents = New CSConfig.cConfig
    Set m_Config = m_ConfigEvents
100 Set m_Servidor = CreateObject("CSSecurity.cSecurity")
    
101 If Not m_Servidor.Success Then
        MsgBox "Error al obtener enlace con el servidor." & vbCrLf & vbCrLf & m_Servidor.LastNumberError & ": " & m_Servidor.LastError & ".", vbCritical, "Monitor de seguridad"
        Exit Sub
    End If
    
    m_Config.User = "sa"
    m_Config.Password = "catalina"
    
102 If Not m_Servidor.LogginOn(m_Config) Then
        MsgBox m_Config.ErrorMsg, vbCritical, "Monitor de seguridad"
        Exit Sub
    End If
    
    Exit Sub
'--------------------------------------------------------------------------
'   COLISIONES POR OLE
'--------------------------------------------------------------------------
CallbackError:
    If (Erl >= 100 And Erl <= 102) And Err = &H80010001 Then
      If nCurErrorCount >= MAX_ERROR_COUNT Then
        MsgBox "Error al intentar conectarce con el servidor de seguridad" & vbCrLf & vbCrLf & Err.Description, vbCritical, "Monitor de seguridad"
        Resume EndOfError
      Else
        For iCounter = 1 To 2000 * Rnd()
          DoEvents
        Next iCounter
        Err = 0
        Resume
      End If
    ElseIf Err <> 0 Then
        MsgBox "Error al intentar conectarce con el servidor de seguridad" & vbCrLf & vbCrLf & Err.Description, vbCritical, "Monitor de seguridad"
    End If
EndOfError:
End Sub

Private Sub Form_Resize()
    TxInfo.Width = ScaleWidth - TxInfo.Left * 2
    CmdRefrescar.Top = ScaleHeight - 25 - CmdRefrescar.Height
    TxInfo.Height = ScaleHeight - CmdRefrescar.Height - TxInfo.Top - 100
End Sub

Private Sub Form_Unload(Cancel As Integer)
'--------------------------------------------------------------------------
'   COLISIONES POR OLE
'--------------------------------------------------------------------------
    Dim iCounter As Integer
    Dim nCurErrorCount As Integer
    Const MAX_ERROR_COUNT = 10
    
    On Error GoTo CallbackError
'--------------------------------------------------------------------------

100 m_Servidor.LogginOff m_Config

'--------------------------------------------------------------------------
'   COLISIONES POR OLE
'--------------------------------------------------------------------------
CallbackError:
    If (Erl = 100) And Err = &H80010001 Then
      If nCurErrorCount >= MAX_ERROR_COUNT Then
        MsgBox "Error al intentar desconectarce del servidor de seguridad" & vbCrLf & vbCrLf & Err.Description, vbCritical, "Monitor de seguridad"
        Resume EndOfError
      Else
        For iCounter = 1 To 2000 * Rnd()
          DoEvents
        Next iCounter
        Err = 0
        Resume
      End If
    ElseIf Err <> 0 Then
        MsgBox "Error al intentar desconectarce del servidor de seguridad" & vbCrLf & vbCrLf & Err.Description, vbCritical, "Monitor de seguridad"
    End If
EndOfError:
    Set m_ConfigEvents = Nothing
    Set m_Config = Nothing
    Set m_Servidor = Nothing
End Sub

Private Sub TxInfo_KeyDown(KeyCode As Integer, Shift As Integer)
    If KeyCode = vbKeyF4 And Shift = 4 Then Exit Sub
    If KeyCode <> vbKeyLeft And KeyCode <> vbKeyUp And KeyCode <> vbKeyRight And KeyCode <> vbKeyDown And KeyCode <> vbKeyPageDown And KeyCode <> vbKeyPageUp Then
        KeyCode = 0
    End If
End Sub

Private Sub TxInfo_KeyPress(KeyAscii As Integer)
    KeyAscii = 0
End Sub

'--------------------------------------------------------------------------
Private Sub m_ConfigEvents_RefreshLogins()
'--------------------------------------------------------------------------
'   COLISIONES POR OLE
'--------------------------------------------------------------------------
    Dim iCounter As Integer
    Dim nCurErrorCount As Integer
    Const MAX_ERROR_COUNT = 10
    
    On Error GoTo CallbackError
'--------------------------------------------------------------------------
    TxInfo.Text = ""
    
    TxInfo.Text = TxInfo.Text & "SID|"
    TxInfo.Text = TxInfo.Text & "Usuario             |"
    TxInfo.Text = TxInfo.Text & "UID|"
    TxInfo.Text = TxInfo.Text & "Puesto              |"
    TxInfo.Text = TxInfo.Text & "Inicio Sesion" & vbCrLf
    TxInfo.Text = TxInfo.Text & String(62, "_") & vbCrLf & vbCrLf
    
    Dim o As CSInterfaces.cIItemClient
100 m_Servidor.GetActivity m_Config

    
    For Each o In m_Config.Logins
        TxInfo.Text = TxInfo.Text & GetText(o.SesionId, 3) & "|"
        TxInfo.Text = TxInfo.Text & GetText(o.User, 20) & "|"
        TxInfo.Text = TxInfo.Text & GetText(o.UserId, 3) & "|"
        TxInfo.Text = TxInfo.Text & GetText(o.Puesto, 20) & "|"
        TxInfo.Text = TxInfo.Text & GetText(o.StartConection, 12) & vbCrLf
    Next

'--------------------------------------------------------------------------
'   COLISIONES POR OLE
'--------------------------------------------------------------------------
CallbackError:
    If (Erl = 100) And Err = &H80010001 Then
      If nCurErrorCount >= MAX_ERROR_COUNT Then
        MsgBox "Error al refrescar informe de conexiones" & vbCrLf & vbCrLf & Err.Description, vbCritical, "Monitor de seguridad"
        Resume EndOfError
      Else
        For iCounter = 1 To 2000 * Rnd()
          DoEvents
        Next iCounter
        Err = 0
        Resume
      End If
    ElseIf Err <> 0 Then
        MsgBox "Error al refrescar informe de conexiones" & vbCrLf & vbCrLf & Err.Description, vbCritical, "Monitor de seguridad"
    End If
EndOfError:
End Sub

Private Function GetText(ByVal sString As String, ByVal n As Integer) As String
    GetText = Mid(sString & String(n, " "), 1, n)
End Function

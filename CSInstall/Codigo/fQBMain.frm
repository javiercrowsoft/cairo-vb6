VERSION 5.00
Begin VB.Form fMain2 
   BackColor       =   &H00FFFFFF&
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Instalando QBPoint Axción"
   ClientHeight    =   4515
   ClientLeft      =   45
   ClientTop       =   435
   ClientWidth     =   4095
   Icon            =   "fQBMain.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   4515
   ScaleWidth      =   4095
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.ListBox lsRegister 
      Height          =   2595
      Left            =   60
      TabIndex        =   0
      Top             =   1860
      Width           =   3975
   End
   Begin VB.Image Image1 
      Height          =   1800
      Left            =   60
      Picture         =   "fQBMain.frx":058A
      Top             =   0
      Width           =   4065
   End
End
Attribute VB_Name = "fMain2"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' fMain
' 31-12-2003

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "fMain"
' estructuras
' variables privadas
Private m_bDone       As Boolean
Private m_Path        As String
' eventos
' propiedades publicas
Public Property Let Path(ByVal rhs As String)
  m_Path = rhs
End Property
' propiedades friend
' propiedades privadas
' funciones publicas
Public Sub Register()
  On Error GoTo ControlError
  
  Dim strFile As String
  Dim strPath As String
  Dim strRegsvr32 As String
  
  strRegsvr32 = Environ$("WINDIR") & "\SYSTEM32\REGSVR32.EXE"
  If Not pFileExists(strRegsvr32) Then
    
    strRegsvr32 = Environ$("WINDIR") & "\SYSTEM\REGSVR32.EXE"
    
    If Not pFileExists(strRegsvr32) Then
      
      strRegsvr32 = App.Path & "\REGSVR32.EXE"
      
      If Not pFileExists(strRegsvr32) Then
        MsgBox "No se puede ubicar Regsvr32.exe en " & strRegsvr32, vbCritical, "Error"
        Exit Sub
      End If
    End If
  End If
  
#If PREPROC_INSTALL_CLIENT Then

  If Right$(m_Path, 1) <> "\" Then
    strPath = m_Path & "\"
  End If

#Else

  If Right$(App.Path, 1) <> "\" Then
    strPath = App.Path & "\"
  End If
  
#End If
  
  strFile = Dir(strPath & "*.dll")
  pRegister strFile, strPath, strRegsvr32, False
  
  strFile = Dir(strPath & "*.ocx")
  pRegister strFile, strPath, strRegsvr32, True
  
#If PREPROC_INSTALL_CLIENT Then

  Unload Me

#Else

  MsgBox "Los componentes se han registrados con exito"

#End If

  GoTo ExitProc
ControlError:
  MsgBox Err.Description, vbCritical, C_Module & ".Register"
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub pRegister(ByVal strFile As String, ByVal strPath As String, ByVal strRegsvr32 As String, ByVal bChatClient As Boolean)
  Dim result      As Long
  
  While strFile <> ""
  
    result = ShellExecute(strRegsvr32 & " /s " & """" & strPath & strFile & """", vbHide, True)
  
    If result = 0 Then
      lsRegister.AddItem "!!!! ERROR: " & strFile
    Else
      lsRegister.AddItem strFile
    End If
    DoEvents
    
    lsRegister.ListIndex = lsRegister.ListCount - 1
  
    strFile = Dir
  Wend
  
  If bChatClient Then
  
    Dim strFileChat As String
    strFileChat = pGetValidPath(App.Path) & "cschatclient.exe"
    If pFileExists(strFileChat) Then
      Shell strFileChat & " register"
      lsRegister.AddItem "CSChatClient.exe"
      lsRegister.ListIndex = lsRegister.ListCount - 1
    End If
  End If
End Sub

Private Function pGetValidPath(ByVal Path As String) As String
  If Right$(Path, 1) <> "\" Then
    pGetValidPath = Path & "\"
  End If
End Function

Private Function pFileExists(ByVal strFile As String) As Boolean
  On Error Resume Next
  
  Err.Clear
  
  If Dir(strFile) <> "" Then
    pFileExists = True
  End If
  
  If Err.Number Then pFileExists = False
End Function

Private Sub Form_Activate()
  #If PREPROC_INSTALL_CLIENT Then
    
    If m_bDone Then Exit Sub
    m_bDone = True
    fMain2.Register
    
  #End If
End Sub
' funciones friend
' funciones privadas
' construccion - destruccion
Private Sub Form_Load()
  On Error Resume Next
  
  m_bDone = False
  
  With Me
    .Left = (Screen.Width - .Width) / 2
    .Top = (Screen.Height - .Height) / 2
  End With
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

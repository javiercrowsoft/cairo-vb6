VERSION 5.00
Begin VB.Form fPreferences 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Preferencias"
   ClientHeight    =   7260
   ClientLeft      =   45
   ClientTop       =   345
   ClientWidth     =   6105
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   7260
   ScaleWidth      =   6105
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.CheckBox chkInitWithWindows 
      Caption         =   "Ejecutar CSBackup al iniciar Windows"
      Height          =   255
      Left            =   120
      TabIndex        =   14
      Top             =   3720
      Width           =   5355
   End
   Begin VB.CommandButton cmdSetMasterPassword 
      Caption         =   "Ingresar Clave Maestra"
      Height          =   315
      Left            =   480
      TabIndex        =   8
      Top             =   6180
      Width           =   2355
   End
   Begin VB.CheckBox chkMasterPassword 
      Caption         =   "Usar una clave maestra"
      Height          =   255
      Left            =   120
      TabIndex        =   7
      Top             =   4200
      Width           =   5355
   End
   Begin VB.TextBox txPassword2 
      Height          =   315
      IMEMode         =   3  'DISABLE
      Left            =   120
      PasswordChar    =   "*"
      TabIndex        =   6
      Top             =   3180
      Width           =   5415
   End
   Begin VB.TextBox txPassword 
      Height          =   315
      IMEMode         =   3  'DISABLE
      Left            =   120
      PasswordChar    =   "*"
      TabIndex        =   4
      Top             =   2340
      Width           =   5415
   End
   Begin VB.CommandButton cmdOpenFolder 
      Caption         =   "..."
      Height          =   375
      Left            =   5640
      TabIndex        =   2
      Top             =   1560
      Width           =   375
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "&Cancelar"
      Height          =   315
      Left            =   4380
      TabIndex        =   10
      Top             =   6780
      Width           =   1575
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "&Aceptar"
      Default         =   -1  'True
      Height          =   315
      Left            =   2700
      TabIndex        =   9
      Top             =   6780
      Width           =   1575
   End
   Begin VB.TextBox txPath 
      Height          =   315
      Left            =   120
      TabIndex        =   1
      Top             =   1560
      Width           =   5415
   End
   Begin VB.Label Label6 
      Caption         =   "Le recomendamos que active el uso de clave maestra para aumentar el nivel de seguridad de CSBackup."
      Height          =   495
      Left            =   480
      TabIndex        =   13
      Top             =   5580
      Width           =   5175
   End
   Begin VB.Label Label5 
      Caption         =   $"fPreferences.frx":0000
      Height          =   915
      Left            =   480
      TabIndex        =   12
      Top             =   4620
      Width           =   5115
   End
   Begin VB.Label Label4 
      Caption         =   "C&onfirme la clave:"
      Height          =   315
      Left            =   120
      TabIndex        =   5
      Top             =   2880
      Width           =   3195
   End
   Begin VB.Label Label3 
      Caption         =   "C&lave de encriptación de los archivos:"
      Height          =   315
      Left            =   120
      TabIndex        =   3
      Top             =   2040
      Width           =   3195
   End
   Begin VB.Line Line2 
      BorderColor     =   &H80000014&
      X1              =   -840
      X2              =   6180
      Y1              =   6615
      Y2              =   6615
   End
   Begin VB.Line Line1 
      BorderColor     =   &H80000010&
      X1              =   -840
      X2              =   6180
      Y1              =   6600
      Y2              =   6600
   End
   Begin VB.Label Label2 
      BackStyle       =   0  'Transparent
      Caption         =   "Preferencias"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   18
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   495
      Left            =   1200
      TabIndex        =   11
      Top             =   240
      Width           =   2535
   End
   Begin VB.Image Image1 
      Height          =   675
      Left            =   360
      Picture         =   "fPreferences.frx":011A
      Top             =   120
      Width           =   675
   End
   Begin VB.Shape Shape1 
      BackColor       =   &H00FFFFFF&
      BackStyle       =   1  'Opaque
      BorderStyle     =   0  'Transparent
      Height          =   975
      Left            =   -120
      Top             =   0
      Width           =   6255
   End
   Begin VB.Label Label1 
      Caption         =   "&Ubicacion de archivos:"
      Height          =   375
      Left            =   120
      TabIndex        =   0
      Top             =   1200
      Width           =   1815
   End
End
Attribute VB_Name = "fPreferences"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub chkMasterPassword_Click()
  If chkMasterPassword.Value = vbChecked Then
    cmdSetMasterPassword.Enabled = True
  Else
    cmdSetMasterPassword.Enabled = False
  End If
End Sub

Private Sub cmdCancel_Click()
  Unload Me
End Sub

Private Sub cmdOk_Click()
  
  Dim OldMasterPassword As String
  OldMasterPassword = GetMasterPassword()
  
  If chkMasterPassword.Value = vbChecked And _
    LenB(GetMasterPassword()) = 0 Then
  
    If Not RequestMasterPassword(True) Then Exit Sub
  
  End If
  
  If OldMasterPassword <> GetMasterPassword() Then
  
    ChangeMasterPassword OldMasterPassword, GetMasterPassword
    
  End If
  
  If txPassword.Text <> txPassword2.Text Then
  
    MsgWarning "La clave y su confirmación no coinciden"
    Exit Sub
  End If
  
  SetIniValue csSecConfig, csUseMasterPassword, IIf(chkMasterPassword.Value = vbChecked, 1, 0), GetIniFullFile(csIniFile)
  SetIniValue csSecConfig, csPasswordTestValue, EncryptData(c_testvalue, GetMasterPassword()), GetIniFullFile(csIniFile)
  SetIniValue csSecConfig, csDbPath, Me.txPath.Text, GetIniFullFile(csIniFile)
  SetIniValue csSecConfig, csInitWithWindows, IIf(chkInitWithWindows.Value = vbChecked, 1, 0), GetIniFullFile(csIniFile)
  
  Dim Password As String
  Password = GetProgramPassword()
  
  SetIniValue csSecConfig, csPasswordFiles, EncryptData(txPassword.Text, Password), GetIniFullFile(csIniFile)
  
  LoadPasswordFiles
  
  pSetInitWithWindows
  
  Unload Me
  LoadTask fMain.lvTask
  LoadSchedule fMain.lvSchedule
End Sub

Private Sub cmdOpenFolder_Click()
  Dim Fld   As cFolder
  Dim sPath As String
  
  Set Fld = New cFolder
  
  sPath = Fld.SelectFolder(Me.hWnd)
  
  If sPath <> vbNullString Then
    Me.txPath.Text = sPath
  End If
  
  Set Fld = Nothing
End Sub

Private Sub Form_Load()
  
  FormLoad Me, False
  Me.txPath.Text = GetIniValue(csSecConfig, _
                               csDbPath, _
                               vbNullString, _
                               GetIniFullFile(csIniFile))

  Me.txPassword.Text = GetPasswordFiles()
  Me.txPassword2.Text = GetPasswordFiles()

  If Val(GetIniValue(csSecConfig, _
                    csUseMasterPassword, _
                    0, _
                    GetIniFullFile(csIniFile))) Then
    chkMasterPassword.Value = vbChecked
  Else
    chkMasterPassword.Value = vbUnchecked
  End If

  If Val(GetIniValue(csSecConfig, _
                    csInitWithWindows, _
                    1, _
                    GetIniFullFile(csIniFile))) Then
    chkInitWithWindows.Value = vbChecked
  Else
    chkInitWithWindows.Value = vbUnchecked
  End If

  If LenB(GetMasterPassword) Then
    cmdSetMasterPassword.Caption = "Cambiar la clave maestra"
  End If
  
  chkMasterPassword_Click

End Sub

Private Sub Form_Unload(Cancel As Integer)

  FormUnload Me, False

End Sub

VERSION 5.00
Begin VB.MDIForm fMainMdi 
   BackColor       =   &H8000000C&
   Caption         =   "CSWebBrowser"
   ClientHeight    =   5160
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   7545
   LinkTopic       =   "MDIForm1"
   StartUpPosition =   3  'Windows Default
End
Attribute VB_Name = "fMainMdi"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

' SysTray
Private WithEvents m_fSysTray As fSysTray
Attribute m_fSysTray.VB_VarHelpID = -1

Public Property Get fSysTray() As fSysTray
  Set fSysTray = m_fSysTray
End Property

Public Sub RefreshIcon(ByVal iconIndex, ByVal msg As String)
  Me.Icon = fMain.ilIcon.ListImages(iconIndex).Picture
  m_fSysTray.ToolTip = "CVXI Browser! " & msg
  m_fSysTray.IconHandle = Me.Icon.Handle
End Sub

Private Sub m_fSysTray_MenuClick(ByVal lIndex As Long, ByVal sKey As String)
    Select Case sKey
    Case "open" '--lng
        Me.Show
        Me.ZOrder
        fInfo.Show , fMainMdi
    Case "close" '--lng
        Unload Me
    End Select
    
End Sub

Private Sub m_fSysTray_SysTrayDoubleClick(ByVal eButton As MouseButtonConstants)
    Me.Show
    Me.ZOrder
End Sub

Private Sub m_fSysTray_SysTrayMouseDown(ByVal eButton As MouseButtonConstants)
    If (eButton = vbRightButton) Then
        m_fSysTray.ShowMenu
    End If
End Sub


'/////////////////////////////////////////////////////////////
' SysTray

Private Sub LoadSysTray()
    Set m_fSysTray = New fSysTray
    With m_fSysTray
        .AddMenuItem "&Abrir CVXI Browser", "open", True '--lng
        .AddMenuItem "-"
        .AddMenuItem "&Cerrar", "close" '--lng
        .ToolTip = "CVXI Browser!"
        .IconHandle = Me.Icon.Handle
    End With
End Sub

Private Sub MDIForm_Load()
  On Error Resume Next
  LoadSysTray
End Sub

Private Sub MDIForm_QueryUnload(Cancel As Integer, UnloadMode As Integer)
  
  '
  ' Cuando la aplicacion detecta que se esta navegando la pagina de preguntas
  ' Al cerrar la ventana la aplicacion se oculta (Hide = True), Igual que cuando
  ' se minimiza la aplicacion, y se iconiza en el SysTray.
  ' Cuando la aplicacion no esta navegando la pagina de preguntas debe cerrarse
  ' (terminar el proceso) cuando se cierra la ventana.
  '
  If fMain.bInPreguntas Or fMain.bInArticulos Or fMain.bInMercadoPago Or fMain.bInVentas Then
  
    If UnloadMode = vbFormControlMenu Then
      fMain.CallManager False, False
      Me.Hide
      Cancel = True
    Else
      Unload m_fSysTray
      Set m_fSysTray = Nothing
    End If
  
  Else
    Unload m_fSysTray
    Set m_fSysTray = Nothing
  End If
End Sub


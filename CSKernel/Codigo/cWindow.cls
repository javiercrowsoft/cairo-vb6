VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cWindow"
Attribute VB_GlobalNameSpace = True
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cWindow
' 27-12-99

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' Funciones
    Private Declare Function SetWindowPos Lib "user32" _
                                                  (ByVal hwnd As Long, _
                                                  ByVal hWndInsertAfter As Long, _
                                                  ByVal x As Long, _
                                                  ByVal y As Long, _
                                                  ByVal cx As Long, _
                                                  ByVal cy As Long, _
                                                  ByVal wFlags As Long) As Long

'--------------------------------------------------------------------------------

' constantes
Private Const m_LeftIcon = 120
Private Const m_TopIcon = 120
Private Const m_LeftLbObjeto = 495
Private Const m_TopLbObjeto = 240
Private Const m_LeftCbObjeto = 2880
Private Const m_TopCbObjeto = 240
Private Const m_HeightShHeader = 735

' estructuras
' variables privadas
Private m_Title As String

' Referencia a la coleccion de forms del exe cliente
' usada en la clase clsScreen para Center y descargar forms
Private m_Forms As Object

' propiedades publicas
Public Property Let Silent(ByVal rhs As Boolean)
  gbSilent = rhs
End Property
Public Property Get Silent() As Boolean
  Silent = gbSilent
End Property
Public Property Get Title() As String
    Title = m_Title
End Property
Public Property Let Title(rhs As String)
    m_Title = rhs
End Property
Public Property Set OForms(rhs As Object)
    Set m_Forms = rhs
End Property

' propiedades privadas
' funciones publicas
Public Sub AlwaysOnTop(myfrm As Object, SetOnTop As Boolean)
    Dim lFlag As Integer
    
    If SetOnTop Then
        lFlag = HWND_TOPMOST
    Else
        lFlag = HWND_NOTOPMOST
    End If

    SetWindowPos myfrm.hwnd, lFlag, _
    myfrm.Left / Screen.TwipsPerPixelX, _
    myfrm.Top / Screen.TwipsPerPixelY, _
    myfrm.Width / Screen.TwipsPerPixelX, _
    myfrm.Height / Screen.TwipsPerPixelY, _
    SWP_NOACTIVATE Or SWP_SHOWWINDOW
End Sub
'---------------
' Carga y descarga de forms
Public Function ShowFormWithInit(ByRef f As Object, ByVal Name As String, Optional ByVal Modal As FormShowConstants = vbModeless) As Boolean
  LoadForm f, Name
  ShowFormWithInit = f.Init
    
  If LCase(f.Name) = LCase("flistdoc") Then
    If Val(GetRegistry_(csInterface, Name + "_HIDEPARAMETERS", 0)) Then
      f.cListDoc1.HideParameters
    End If
  End If
    
  If ShowFormWithInit Then
    If Modal = vbModeless Then
      f.Show Modal
      f.ZOrder
    Else
      f.Show Modal
    End If
  End If
End Function
Public Sub ShowForm(ByRef f As Object, ByVal Name As String, Optional ByVal Modal As FormShowConstants = vbModeless)
    LoadForm f, Name
    If Modal = vbModeless Then
      f.Show Modal
      f.ZOrder
    Else
      f.Show Modal
    End If
End Sub
Public Sub LoadForm(ByRef f As Object, ByVal Name As String)
    Load f
    GetConfigForm f, Name
End Sub

Public Sub UnloadForm(ByRef f As Object, ByVal Name As String, Optional YesUnload As Boolean = False)
    SaveConfigForm f, Name
    If YesUnload Then Unload f
End Sub

'---------------
' Propiedades de los forms
Public Sub GetConfigForm(ByRef f As Object, ByVal Name As String)
  On Error Resume Next
  Dim bExistsInRegistry As Boolean
  
  bExistsInRegistry = Val(GetRegistry_(csInterface, Name + "_EXISTS", 0))

  If Not bExistsInRegistry Then
    f.Left = (Screen.Width - f.Width) / 2
    f.Top = (Screen.Height - f.Height) / 2
    Exit Sub
  End If
  
  f.WindowState = GetRegistry_(csInterface, Name + "_WINDOW_STATE", vbNormal)
  
  If f.WindowState = vbNormal Then
  
    If pIsSizable(f) Then
      Dim Width     As Long
      Dim Height    As Long
      
      Width = GetRegistry_(csInterface, Name + "_WIDTH", f.Width)
      Height = GetRegistry_(csInterface, Name + "_HEIGHT", f.Height)
      If Width > 1000 Then f.Width = Width
      If Height > 1000 Then f.Height = Height
    End If
    
    If UCase(f.Name) <> "FHELP" And UCase(f.Name) <> "FHELPTREE" Then
      
      f.Left = GetRegistry_(csInterface, Name + "_LEFT", f.Left)
      f.Top = GetRegistry_(csInterface, Name + "_TOP", f.Top)
      
      If f.Left < 0 Then f.Left = 0
      If f.Top < 0 Then f.Top = 0
    
    Else
      If f.Left + f.Width > Screen.Width Then f.Left = Screen.Width - f.Width - 50
                                          ' Estimativo para el alto de la barra inicio
                                          ' esperando claro esta que el usuario la ponga
                                          ' en la parte inferior de la pantalla
      If f.Top + f.Height > Screen.Height - 500 Then f.Top = f.Top - f.Height - 285
      If f.Top < 0 Then f.Top = 0
      If f.Left < 0 Then f.Left = 0
    End If
  End If
End Sub

Private Function pIsSizable(ByRef f As Object) As Boolean
  On Error Resume Next
  pIsSizable = f.BorderStyle = vbSizable Or f.BorderStyle = vbSizableToolWindow
End Function

Public Sub SaveConfigForm(ByRef f As Object, ByVal Name As String)
  If f.WindowState = vbMinimized Then Exit Sub
  SetRegistry_ csInterface, Name + "_EXISTS", -1
  SetRegistry_ csInterface, Name + "_WINDOW_STATE", f.WindowState
  If f.WindowState = vbNormal Then
    SetRegistry_ csInterface, Name + "_LEFT", f.Left
    SetRegistry_ csInterface, Name + "_TOP", f.Top
    If f.Width > 1000 Then SetRegistry_ csInterface, Name + "_WIDTH", f.Width
    If f.Height > 1000 Then SetRegistry_ csInterface, Name + "_HEIGHT", f.Height
  End If
  If LCase(f.Name) = LCase("flistdoc") Then
    SetRegistry_ csInterface, Name + "_HIDEPARAMETERS", CInt(Not f.cListDoc1.ParamVisible)
  End If
End Sub

'---------------
' Dialogos
Public Sub MsgError(ByVal msg As String, Optional ByVal Title As String = "@@@@@")
  If Title = "@@@@@" Then Title = m_Title
  MsgError_ msg, Title
End Sub
Public Sub MsgWarning(ByVal msg As String, Optional ByVal Title As String = "@@@@@")
Attribute MsgWarning.VB_Description = "Muestra un mensaje de advertencia al usuario."
  If Title = "@@@@@" Then Title = m_Title
  MsgWarning_ msg, Title
End Sub
Public Sub MsgWarningEx(ByVal msg As String, Optional ByVal Title As String = "@@@@@", Optional ByVal Details As String)
  If Title = "@@@@@" Then Title = m_Title
  MsgWarning_ msg, Title, Details
End Sub
Public Function Ask(ByVal msg As String, ByVal default As VbMsgBoxResult, Optional ByVal Title As String = "@@@@@") As Boolean
  If Title = "@@@@@" Then Title = m_Title
  Ask = Ask_(msg, default, Title)
End Function
Public Function MsgInfo(ByVal msg As String, Optional ByVal Title As String = "@@@@@")
  If Title = "@@@@@" Then Title = m_Title
  MsgInfo_ msg, Title
End Function

'--------------------
' Manejo de ventanas
Public Sub FreeResource()
  Dim frm As Form
  
  ' recorro la coleccion de forms y los descargo a todos excepto al
  ' MDI principal
  For Each frm In m_Forms
    If Not TypeOf frm Is MDIForm Then
      Unload frm
    End If
  Next
End Sub

' Coordenadas de un control relativas al screen
Public Function LeftControlToLeftForm(ByVal lhwnd As Long) As Long
    Dim lpRect As RECT
    Dim iRet As Long
    
    iRet = GetWindowRect(lhwnd, lpRect)
    
    LeftControlToLeftForm = 0
    
    ' Hubo un error devuelvo cero
    If iRet = 0 Then Exit Function
    
    LeftControlToLeftForm = lpRect.Left * Screen.TwipsPerPixelX
End Function
Public Function TopControlToTopForm(ByVal lhwnd As Long, ByVal lHeight As Long) As Long
    Dim lpRect As RECT
    Dim iRet As Long
    
    iRet = GetWindowRect(lhwnd, lpRect)
    
    TopControlToTopForm = 0
    
    ' Hubo un error devuelvo cero
    If iRet = 0 Then Exit Function
    
    TopControlToTopForm = lpRect.Top * Screen.TwipsPerPixelY + lHeight
End Function

Public Sub CenterForm(ByRef frm As Object, Optional ByVal fMain As Object)
  CenterForm_ frm, fMain
End Sub

Public Sub SetStyleHeaderEditCombo(ByRef frm As Object, Optional ByVal Tree1 As String, Optional ByVal Tree2 As String)
    frm.ShHeader.Left = 0
    frm.ShHeader.Top = 0
    frm.ShHeader.Width = frm.ScaleWidth
    frm.ShHeader.Height = m_HeightShHeader
    frm.ImgIcon.Left = m_LeftIcon
    frm.ImgIcon.Top = m_TopIcon
    frm.LbObjeto.Top = m_TopLbObjeto
    frm.LbObjeto.Left = m_LeftLbObjeto
    
    If Tree1 <> "" Then
    
        If Tree2 <> "" Then
            With frm.Controls(Tree1)
              .Height = (frm.ScaleHeight - m_HeightShHeader) / 2
              .Top = m_HeightShHeader
              .Left = 0
              .Width = frm.ScaleWidth
            End With
            
            With frm.Controls(Tree2)
              .Height = (frm.ScaleHeight - m_HeightShHeader) / 2
              .Top = m_HeightShHeader + frm.Controls(Tree2).Height
              .Left = 0
              .Width = frm.ScaleWidth
            End With
        Else
            With frm.Controls(Tree1)
              .Height = frm.ScaleHeight - m_HeightShHeader
              .Top = m_HeightShHeader
              .Left = 0
              .Width = frm.ScaleWidth
            End With
        End If
    ElseIf Tree2 <> "" Then
        With frm.Controls(Tree2)
          .Height = frm.ScaleHeight - m_HeightShHeader
          .Top = m_HeightShHeader
          .Left = 0
          .Width = frm.ScaleWidth
        End With
    Else
        With frm.ArbObjeto
          .Height = frm.ScaleHeight - m_HeightShHeader
          .Top = m_HeightShHeader
          .Left = 0
          .Width = frm.ScaleWidth
        End With
    End If
End Sub
' Funciones privadas
  

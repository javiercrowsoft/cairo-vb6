VERSION 5.00
Object = "{895A3E6C-C27E-4388-95FB-595E3D758B6E}#1.0#0"; "Editawy.ocx"
Begin VB.UserControl cTextEditor 
   ClientHeight    =   3600
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   4800
   ScaleHeight     =   3600
   ScaleWidth      =   4800
   Begin EditawyX.Editawy Editawy1 
      Left            =   1380
      Top             =   1020
      _ExtentX        =   847
      _ExtentY        =   847
      SymbolMargin    =   0   'False
      Folding         =   0   'False
      BeginProperty DefaultFont {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      CaretLineVisible=   0   'False
      TabWidth        =   0
      EdgeColumn      =   120
      EdgeColor       =   0
   End
End
Attribute VB_Name = "cTextEditor"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Public Sub Copy()
  Editawy1.Copy
End Sub

Public Sub Cut()
  Editawy1.Cut
End Sub

Public Sub Find()
  frmFind.SetTextEditor Me
  frmFind.Show , Me
  frmFind.SetFocus
End Sub

Public Sub Replace()
  frmReplace.SetTextEditor Me
  frmReplace.Show , Me
  frmReplace.SetFocus
End Sub

Public Sub Paste()
  Editawy1.Paste
End Sub

Public Property Get hWnd() As Long
  hWnd = UserControl.hWnd
End Property

Public Property Get SelText() As String
  SelText = Editawy1.GetSelText
End Property

Public Property Get SelStart() As Long
  SelStart = Editawy1.GetSelectionStart
End Property

Public Property Get SelLength() As Long
  SelLength = Editawy1.GetSelectionEnd - Editawy1.GetSelectionStart
End Property

Public Property Get Text() As String
  Text = Editawy1.Text
End Property

Public Property Let Text(ByVal rhs As String)
    
    Editawy1.ClearAll
    Editawy1.Text = rhs
    Editawy1.EmptyUndoBuffer
    Editawy1.SetSavePoint

End Property

Public Property Get Editawy() As Object
  Set Editawy = Editawy1
End Property

Public Function Initialize(ByVal FileConfig As String, _
                           ByVal Language As String) As Boolean
  
    Dim iniFile         As String
    Dim LanguageStyler  As Styler
        
    '----------------------------------------------------------------
    Editawy1.Initialize
    '----------------------------------------------------------------
    Editawy1.Folding = True
    Editawy1.LineNumbers = True
    Editawy1.SymbolMargin = True
    Editawy1.ReadOnly = False
    Editawy1.HScrollBar = True
    Editawy1.CaretLineVisible = True
    
    Editawy1.TabWidth = 2
    
    If LenB(FileConfig) = 0 Then
      iniFile = App.Path & "\LexersConf.ini"
    End If
    If LenB(Language) = 0 Then
      Language = "SQL"
    End If
    
    LanguageStyler = Editawy1.ReadLanguageStyler(Language, iniFile)
    Editawy1.SetLanguageStyler LanguageStyler
    
    Initialize = True
    
End Function

Private Sub UserControl_Resize()
  On Error Resume Next
  
  Dim H As Single
  Dim W As Single
  
  H = UserControl.Height
  W = UserControl.Width
 
  If H < 100 And W < 100 Then Exit Sub
 
  Editawy1.Resize 0, 0, W \ Screen.TwipsPerPixelX - 8, (H \ Screen.TwipsPerPixelY) \ 1 - 25

End Sub

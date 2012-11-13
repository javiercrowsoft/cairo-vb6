VERSION 5.00
Begin VB.Form fIcon 
   BackColor       =   &H80000005&
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Icon"
   ClientHeight    =   3195
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   4680
   Icon            =   "fIcon.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3195
   ScaleWidth      =   4680
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.Line Line1 
      BorderColor     =   &H80000004&
      X1              =   120
      X2              =   4500
      Y1              =   420
      Y2              =   420
   End
   Begin VB.Label Label1 
      BackStyle       =   0  'Transparent
      Caption         =   "Seleccione una imagen"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   195
      Left            =   120
      TabIndex        =   0
      Top             =   180
      Width           =   3795
   End
   Begin VB.Image ImgIcon 
      Height          =   435
      Index           =   0
      Left            =   360
      ToolTipText     =   "Doble click para seleccionar"
      Top             =   780
      Width           =   435
   End
End
Attribute VB_Name = "fIcon"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' cWindow
' -08-2003

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cWindow"

' estructuras
' variables privadas
Private m_ImageIndex                    As Long
Private m_Ok                            As Boolean
' eventos
' propiedades publicas
Public Property Get Ok() As Boolean
   Ok = m_Ok
End Property

Public Property Let Ok(ByVal rhs As Boolean)
   m_Ok = rhs
End Property

Public Property Get SelectedImage() As Long
  SelectedImage = m_ImageIndex
End Property
' propiedades friend
' propiedades privadas
' funciones publicas
Public Function ShowImages(ByVal FullFileIcon As String) As Boolean
  On Error GoTo ControlError

  Dim n    As Long
  Dim Img  As Image
  Dim nLeft As Long
  Dim nTop  As Long
  Dim oIcon As cFileIcon
  
  Set oIcon = New cFileIcon
  
  If Not oIcon.LoadIcon(FullFileIcon) Then Exit Function
  
  nLeft = 400
  nTop = 1000
  
  For n = 1 To oIcon.ImageCount
    Load ImgIcon(ImgIcon.UBound + 1)
    
    Set Img = ImgIcon(ImgIcon.UBound)
    
    Set Img.Picture = oIcon.IconPicture(Me.hDC, n)
    
    Img.Left = nLeft
    Img.Top = nTop
    
    Img.Visible = True
    
    nLeft = nLeft + 800
    If nLeft + 1000 > Me.ScaleWidth Then
      nLeft = 400
      nTop = nTop + 800
    End If
  Next
  
  GoTo ExitProc
ControlError:
  MngError Err, "ShowImages", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function
' funciones friend
' funciones privadas
Private Sub ImgIcon_DblClick(Index As Integer)
  m_ImageIndex = Index
  Me.Hide
End Sub
' construccion - destruccion
Private Sub Form_Load()
  On Error Resume Next
  CenterForm Me
End Sub

'//////////////////////////////
'  Codigo estandar de errores
'  On Error GoTo ControlError
'
'  GoTo ExitProc
'ControlError:
'  MngError err,"", C_Module, ""
'  If Err.Number Then Resume ExitProc
'ExitProc:
'  On Error Resume Next



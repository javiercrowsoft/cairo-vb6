VERSION 5.00
Object = "{353A8433-36B8-422E-ABBD-36CEE8BE628E}#1.0#0"; "CSButton.ocx"
Object = "{F7BB685C-0860-4FD1-A9CF-22277199D7A5}#1.0#0"; "CSMaskEdit2.ocx"
Begin VB.Form fSPLaunch 
   BorderStyle     =   5  'Sizable ToolWindow
   Caption         =   "Ejecutar procedimiento almacenado"
   ClientHeight    =   7800
   ClientLeft      =   60
   ClientTop       =   300
   ClientWidth     =   5115
   Icon            =   "fSPLaunch.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   7800
   ScaleWidth      =   5115
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin CSButton.cButton cmdEjecutar 
      Default         =   -1  'True
      Height          =   315
      Left            =   2250
      TabIndex        =   0
      Top             =   7410
      Width           =   1365
      _ExtentX        =   2408
      _ExtentY        =   556
      Caption         =   "&Ejecutar"
      Style           =   2
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
   Begin CSMaskEdit2.cMaskEdit txParameter 
      Height          =   300
      Index           =   0
      Left            =   1755
      TabIndex        =   3
      Top             =   975
      Visible         =   0   'False
      Width           =   2175
      _ExtentX        =   3836
      _ExtentY        =   529
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
      EnabledNoChngBkColor=   0   'False
      Text            =   ""
      csType          =   5
      BorderType      =   1
      csNotRaiseError =   -1  'True
      ButtonStyle     =   0
   End
   Begin CSButton.cButton cmdCancelar 
      Cancel          =   -1  'True
      Height          =   315
      Left            =   3720
      TabIndex        =   1
      Top             =   7410
      Width           =   1365
      _ExtentX        =   2408
      _ExtentY        =   556
      Caption         =   "&Cancelar"
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
   Begin VB.Image Image1 
      Height          =   585
      Left            =   225
      Picture         =   "fSPLaunch.frx":27A2
      Top             =   45
      Width           =   675
   End
   Begin VB.Line Line1 
      BorderColor     =   &H80000010&
      X1              =   45
      X2              =   5040
      Y1              =   7335
      Y2              =   7335
   End
   Begin VB.Label lbParameter 
      Caption         =   "Label2"
      Height          =   195
      Index           =   0
      Left            =   135
      TabIndex        =   4
      Top             =   1020
      Visible         =   0   'False
      Width           =   1365
   End
   Begin VB.Label Label1 
      BackStyle       =   0  'Transparent
      Caption         =   "Indique los valores de los parametros para ejecutar el procedimiento"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   585
      Left            =   1065
      TabIndex        =   2
      Top             =   180
      Width           =   3840
   End
   Begin VB.Shape Shape1 
      BackStyle       =   1  'Opaque
      BorderStyle     =   0  'Transparent
      Height          =   765
      Left            =   0
      Top             =   0
      Width           =   5145
   End
End
Attribute VB_Name = "fSPLaunch"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' fSPLaunch
' 30-10-2001

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "fSPLaunch"
' estructuras
' variables privadas
Private m_ColumnsInfo                   As cColumnsInfo
Private m_Parameters                    As cParameters
Private m_Ok                            As Boolean
' eventos
' propiedades publicas

Public Property Get Ok() As Boolean
   Ok = m_Ok
End Property

Public Property Get ColumnsInfo() As cColumnsInfo
   Set ColumnsInfo = m_ColumnsInfo
End Property

Public Property Set ColumnsInfo(ByRef rhs As cColumnsInfo)
   Set m_ColumnsInfo = rhs
End Property

Public Property Get Parameters() As cParameters
   Set Parameters = m_Parameters
End Property

Public Property Get sqlParameters() As String
  Dim s As String
  Dim i As Integer
  For i = 1 To txParameter.Count - 1
    With txParameter(i)
      Select Case .Tag
        Case "T"
          s = s & "'" & Replace(.csValue, "'", "''") & "',"
        Case "N"
          s = s & GetNumberSql(.csValue) & ","
        Case "F"
          s = s & Format(.csValue, csSqlDateString) & ","
      End Select
      
      m_Parameters.Item(i).Value = .csValue
    End With
  Next
  
  If Right(s, 1) = "," Then s = Left(s, Len(s) - 1)
  
  sqlParameters = s
End Property

Private Function GetNumberSql(ByVal sNumber As String) As String
  If Not IsNumeric(sNumber) Then
    GetNumberSql = "0"
  Else
    sNumber = Format(sNumber, String(27, "#") & "0." & String(28, "#"))
    sNumber = Replace(sNumber, ",", ".")
    If Right(sNumber, 1) = "." Then sNumber = Left(sNumber, Len(sNumber) - 1)
    GetNumberSql = sNumber
  End If
End Function

Public Property Set Parameters(ByRef rhs As cParameters)
   Set m_Parameters = rhs
End Property

' propiedades privadas
' funciones publicas
' funciones friend
' funciones privadas
Private Sub LoadParameters()
  UnLoadParameters
  Dim oParameter As cParameter
  Dim i As Integer
  Dim nTop As Integer
  nTop = txParameter(0).Top
  For Each oParameter In m_Parameters
    i = i + 1
    Load txParameter(i)
    Load lbParameter(i)
    With lbParameter(i)
      .Top = nTop
      .Visible = True
      .Caption = oParameter.Name & " :"
    End With
    With txParameter(i)
      .Left = lbParameter(i).Left + lbParameter(i).Width + 100
      .Top = nTop
      nTop = nTop + .Height + 50
      .Visible = True
      .Tag = oParameter.key
      .MaxLength = 0
      Select Case oParameter.TypeColumn
        Case adLongVarChar, adLongVarWChar, adChar, adVarChar, adVarWChar, adWChar
          .csType = csMkText
          .MaxLength = .MaxLength
          .Width = 2500
          .Tag = "T"
        Case adBigInt, adBinary, adInteger, adLongVarBinary, adSmallInt, adTinyInt, adUnsignedBigInt, adUnsignedInt, adUnsignedSmallInt, adUnsignedTinyInt
          .csType = csMkInteger
          .Width = 1000
          .Tag = "N"
          .csWithOutCalc = True
        Case adBoolean
          .csType = csMkInteger
          .MaxLength = 1
          .Width = 200
          .Tag = "N"
          .csWithOutCalc = True
        Case adCurrency, adSingle, adDecimal, adNumeric, adDouble
          .csType = csMkDouble
          .Width = 1000
          .Tag = "N"
          .csWithOutCalc = True
        Case adDBTime, adDate, adDBDate
          .csType = csMkDate
          .csValue = Now
          .Width = 1500
          .Tag = "F"
        Case adDBTimeStamp
          .csType = csMkDate
          .Width = 1500
          .Tag = "F"
      End Select
      
      SetParamValue txParameter(i), oParameter.Value
    End With
  Next
  
  On Error Resume Next
  txParameter(1).SetFocus
End Sub

Private Sub SetParamValue(ByRef o As Control, ByVal Val As Variant)
  On Error Resume Next
  o.Text = Val
End Sub

Private Sub UnLoadParameters()
  On Error Resume Next
  Dim i As Integer
  For i = txParameter.Count - 1 To i = 1 Step -1
    Unload txParameter(i)
    Unload lbParameter(i)
  Next i

End Sub

Private Sub cmdCancelar_Click()
  m_Ok = False
  Me.Hide
End Sub

Private Sub cmdEjecutar_Click()
  m_Ok = True
  Me.Hide
End Sub

Private Sub Form_Click()
  CenterForm Me
  LoadParameters
End Sub

' construccion - destruccion
Private Sub Form_Load()
  On Error GoTo ControlError
  CenterForm Me
  LoadParameters
  GoTo ExitProc
ControlError:
  MngError Err, "Form_Load", C_Module, ""
ExitProc:
End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
  If UnloadMode <> vbFormCode Then
    Cancel = True
    m_Ok = False
    Hide
  End If
End Sub

Private Sub Form_Resize()
  On Error Resume Next
  
  Shape1.Width = Me.Width
  
  Line1.Y1 = Me.ScaleHeight - 500
  Line1.Y2 = Line1.Y1
  Line1.X2 = Me.Width
  cmdCancelar.Top = Line1.Y1 + 80
  cmdEjecutar.Top = cmdCancelar.Top
  cmdEjecutar.Left = Me.ScaleWidth - cmdCancelar.Width - cmdEjecutar.Width - 100
  cmdCancelar.Left = Me.ScaleWidth - cmdCancelar.Width - 50
End Sub

Private Sub Form_Unload(Cancel As Integer)
  On Error Resume Next
  Set m_ColumnsInfo = Nothing
  Set m_Parameters = Nothing
End Sub

'//////////////////////////////
'  Codigo estandar de errores
'  On Error GoTo ControlError
'
'  GoTo ExitProc
'ControlError:
'  MngError err,"", C_Module, ""
'ExitProc:



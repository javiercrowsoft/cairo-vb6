VERSION 5.00
Object = "{AAE806BF-0AA4-415D-8EAA-4F0A32FF6B71}#1.6#0"; "CSControls2.ocx"
Begin VB.Form fEquipoDetalle 
   Caption         =   "Detalle"
   ClientHeight    =   7455
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   5475
   Icon            =   "fEquipoDetalle.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   7455
   ScaleWidth      =   5475
   StartUpPosition =   3  'Windows Default
   Begin CSControls2.cReportParam rptParams 
      Height          =   6015
      Left            =   60
      TabIndex        =   0
      Top             =   1320
      Width           =   5280
      _ExtentX        =   9313
      _ExtentY        =   10610
   End
End
Attribute VB_Name = "fEquipoDetalle"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
'--------------------------------------------------------------------------------
' fParameters
' 05-10-03

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
' estructuras
' variables privadas
Private m_Name      As String
Private m_Ok        As Boolean
' propiedades privadas
' propiedades publicas
Public Property Get Ok() As Boolean
  Ok = m_Ok
End Property
Public Property Let Ok(ByVal rhs As Boolean)
  m_Ok = rhs
End Property

Public Property Get NameEdit() As String
    NameEdit = m_Name
End Property
Public Property Let NameEdit(ByVal rhs As String)
    m_Name = rhs
End Property
' propiedades privadas
' funciones publicas
Public Function Init() As Boolean
  Caption = m_Name
  rptParams.NameClient = m_Name
  rptParams.SetToolBar
  Init = True
End Function

' funciones privadas
Private Sub Form_Resize()
  rptParams.Move 0, 60, ScaleWidth, ScaleHeight - 60
End Sub

' construccion - destruccion
Private Sub Form_Unload(Cancel As Integer)
  On Error Resume Next
  CSKernelClient2.UnloadForm Me, m_Name
End Sub

Private Sub Form_Load()
  On Error Resume Next
  CSKernelClient2.LoadForm Me, m_Name
  
  Dim c As Control
  For Each c In rptParams.Controls
    'Debug.Print c.Name
    If c.Name = "cmdSave" Then
      c.Visible = True
    End If
    If c.Name = "cmdDefaults" Then
      c.Visible = True
    End If
  Next
End Sub

VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "fPreview"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
Option Strict Off
Option Explicit On
Friend Class fPreview
Inherits System.Windows.Forms.Form
#Region "Windows Form Designer generated code "
Public Sub New()
  MyBase.New()
  'This call is required by the Windows Form Designer.
  InitializeComponent()
End Sub
'Form overrides dispose to clean up the component list.
Protected Overloads Overrides Sub Dispose(ByVal Disposing As Boolean)
  If Disposing Then
    If Not components Is Nothing Then
      components.Dispose()
    End If
  End If
  MyBase.Dispose (Disposing)
End Sub
Private components As System.ComponentModel.IContainer
Friend WithEvents rpwReport As CSReportPreview.cReportPreview
'Required by the Windows Form Designer
  Public ToolTip1 As System.Windows.Forms.ToolTip
  'NOTE: The following procedure is required by the Windows Form Designer
'It can be modified using the Windows Form Designer.
'Do not modify it using the code editor.
<System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
Me.components = New System.ComponentModel.Container()
Dim resources As System.Resources.ResourceManager = New System.Resources.ResourceManager(GetType(fPreview))
Me.ToolTip1 = New System.Windows.Forms.ToolTip(Me.components)
Me.rpwReport = New CSReportPreview.cReportPreview()
Me.SuspendLayout()
'
'rpwReport
'
Me.rpwReport.CurrPage = CType(0, Short)
Me.rpwReport.Location = New System.Drawing.Point(8, 8)
Me.rpwReport.Name = "rpwReport"
Me.rpwReport.Pages = CType(0, Short)
Me.rpwReport.Size = New System.Drawing.Size(456, 344)
Me.rpwReport.TabIndex = 0
'
'fPreview
'
Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
Me.ClientSize = New System.Drawing.Size(561, 394)
Me.Controls.AddRange(New System.Windows.Forms.Control() {Me.rpwReport})
Me.Font = New System.Drawing.Font("Arial", 8!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
Me.Location = New System.Drawing.Point(4, 23)
Me.Name = "fPreview"
Me.Text = "Preview"
Me.ResumeLayout (False)

End Sub
#End Region

'--------------------------------------------------------------------------------
' fPreview
' 15-09-2001

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
' constantes
' estructuras
' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module As String = "fPreview"
' estructuras
' variables privadas
' eventos
' propiedades publicas
' propiedades privadas
' funciones publicas
' funciones friend
' funciones privadas
' construccion - destruccion
Private Sub fPreview_Load(ByVal eventSender As System.Object, ByVal eventArgs As System.eventArgs)
  With rpwReport
    .Left = VB6.TwipsToPixelsX(0)
    .Top = VB6.TwipsToPixelsY(0)
  End With
End Sub

Private Sub fPreview_Resize(ByVal eventSender As System.Object, ByVal eventArgs As System.eventArgs)
  On Error Resume Next
  With rpwReport
    .Width = VB6.TwipsToPixelsX(VB6.PixelsToTwipsX(ClientRectangle.Width))
    .Height = VB6.TwipsToPixelsY(VB6.PixelsToTwipsY(ClientRectangle.Height))
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


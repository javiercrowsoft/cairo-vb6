VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "fPics"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
#Region "Windows Form Designer generated code "
  Public Sub New()
    MyBase.New()
    If m_vb6FormDefInstance Is Nothing Then
      If m_InitializingDefInstance Then
        m_vb6FormDefInstance = Me
      Else
        Try
          'For the start-up form, the first instance created is the default instance.
          If System.Reflection.Assembly.GetExecutingAssembly.EntryPoint.DeclaringType Is Me.GetType Then
            m_vb6FormDefInstance = Me
          End If
        Catch
        End Try
      End If
    End If
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
  'Required by the Windows Form Designer
  Private components As System.ComponentModel.Container
  Public ToolTip1 As System.Windows.Forms.ToolTip
  Public WithEvents PicGrid As System.Windows.Forms.PictureBox
Attribute PicGrid.VB_VarHelpID = -1
  Public WithEvents PicBackground As System.Windows.Forms.PictureBox
Attribute PicBackground.VB_VarHelpID = -1
  'NOTE: The following procedure is required by the Windows Form Designer
  'It can be modified using the Windows Form Designer.
  'Do not modify it using the code editor.
  <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
    Me.components = New System.ComponentModel.Container()
    Me.ToolTip1 = New System.Windows.Forms.ToolTip(components)
    Me.ToolTip1.Active = True
    Me.PicGrid = New System.Windows.Forms.PictureBox
    Me.PicBackground = New System.Windows.Forms.PictureBox
    Me.Text = "Form1"
    Me.ClientSize = New System.Drawing.Size(312, 213)
    Me.Location = New System.Drawing.Point(4, 23)
    Me.StartPosition = System.Windows.Forms.FormStartPosition.WindowsDefaultLocation
    Me.Font = New System.Drawing.Font("Arial", 8!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
    Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
    Me.BackColor = System.Drawing.SystemColors.Control
    Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.Sizable
    Me.ControlBox = True
    Me.Enabled = True
    Me.KeyPreview = False
    Me.MaximizeBox = True
    Me.MinimizeBox = True
    Me.Cursor = System.Windows.Forms.Cursors.Default
    Me.RightToLeft = System.Windows.Forms.RightToLeft.No
    Me.ShowInTaskbar = True
    Me.HelpButton = False
    Me.WindowState = System.Windows.Forms.FormWindowState.Normal
    Me.Name = "fPics"
    Me.PicGrid.Size = New System.Drawing.Size(79, 34)
    Me.PicGrid.Location = New System.Drawing.Point(33, 21)
    Me.PicGrid.TabIndex = 1
    Me.PicGrid.Font = New System.Drawing.Font("Arial", 8!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
    Me.PicGrid.Dock = System.Windows.Forms.DockStyle.None
    Me.PicGrid.BackColor = System.Drawing.SystemColors.Control
    Me.PicGrid.CausesValidation = True
    Me.PicGrid.Enabled = True
    Me.PicGrid.ForeColor = System.Drawing.SystemColors.ControlText
    Me.PicGrid.Cursor = System.Windows.Forms.Cursors.Default
    Me.PicGrid.RightToLeft = System.Windows.Forms.RightToLeft.No
    Me.PicGrid.TabStop = True
    Me.PicGrid.Visible = True
    Me.PicGrid.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Normal
    Me.PicGrid.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
    Me.PicGrid.Name = "PicGrid"
    Me.PicBackground.Size = New System.Drawing.Size(79, 34)
    Me.PicBackground.Location = New System.Drawing.Point(33, 63)
    Me.PicBackground.TabIndex = 0
    Me.PicBackground.Font = New System.Drawing.Font("Arial", 8!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
    Me.PicBackground.Dock = System.Windows.Forms.DockStyle.None
    Me.PicBackground.BackColor = System.Drawing.SystemColors.Control
    Me.PicBackground.CausesValidation = True
    Me.PicBackground.Enabled = True
    Me.PicBackground.ForeColor = System.Drawing.SystemColors.ControlText
    Me.PicBackground.Cursor = System.Windows.Forms.Cursors.Default
    Me.PicBackground.RightToLeft = System.Windows.Forms.RightToLeft.No
    Me.PicBackground.TabStop = True
    Me.PicBackground.Visible = True
    Me.PicBackground.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Normal
    Me.PicBackground.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
    Me.PicBackground.Name = "PicBackground"
    Me.Controls.Add (PicGrid)
    Me.Controls.Add (PicBackground)
  End Sub
#End Region
#Region "Upgrade Support "
  Private m_vb6FormDefInstance As fPics
  Private m_InitializingDefInstance As Boolean
  Public Shared Property DefInstance() As fPics
    Get
      If m_vb6FormDefInstance Is Nothing OrElse m_vb6FormDefInstance.IsDisposed Then
        m_InitializingDefInstance = True
        m_vb6FormDefInstance = New fPics()
        m_InitializingDefInstance = False
      End If
      DefInstance = m_vb6FormDefInstance
    End Get
    Set
      m_vb6FormDefInstance = Value
    End Set
  End Property
#End Region


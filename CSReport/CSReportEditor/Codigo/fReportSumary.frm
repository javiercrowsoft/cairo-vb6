VERSION 5.00
Object = "{3B7C8863-D78F-101B-B9B5-04021C009402}#1.2#0"; "richtx32.ocx"
Begin VB.Form fReportSumary 
   BackColor       =   &H00808080&
   BorderStyle     =   5  'Sizable ToolWindow
   Caption         =   "Resumen del Reporte"
   ClientHeight    =   3195
   ClientLeft      =   60
   ClientTop       =   300
   ClientWidth     =   4680
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3195
   ScaleWidth      =   4680
   StartUpPosition =   3  'Windows Default
   Begin RichTextLib.RichTextBox rtxSumary 
      Height          =   2415
      Left            =   120
      TabIndex        =   1
      Top             =   720
      Width           =   3975
      _ExtentX        =   7011
      _ExtentY        =   4260
      _Version        =   393217
      ScrollBars      =   3
      TextRTF         =   $"fReportSumary.frx":0000
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Arial"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
   End
   Begin VB.Label Label8 
      BackStyle       =   0  'Transparent
      Caption         =   "Resumen del Reporte"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   240
      Left            =   915
      TabIndex        =   0
      Top             =   270
      Width           =   2235
   End
   Begin VB.Image Image1 
      Height          =   585
      Left            =   135
      Picture         =   "fReportSumary.frx":0077
      Top             =   45
      Width           =   675
   End
   Begin VB.Shape shTop 
      BorderStyle     =   0  'Transparent
      FillColor       =   &H00FFFFFF&
      FillStyle       =   0  'Solid
      Height          =   690
      Left            =   0
      Top             =   0
      Width           =   6360
   End
End
Attribute VB_Name = "fReportSumary"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Const c_Title2 = 16
Private Const c_Title3 = 14
Private Const c_Title4 = 12
Private Const c_Title5 = 10
Private Const c_Title6 = 9

Private Type T_Format
  FontName        As String
  FontSize        As Integer
  FontBold        As Boolean
  FontItalic      As Boolean
  FontUnderline   As Boolean
  FontColor       As Long
End Type

Private m_vWords() As String
Private m_vFormats() As T_Format

Private Sub Form_Load()
  On Error Resume Next
  CSKernelClient2.LoadForm Me, Me.Name
  pShowSumary
End Sub

Private Sub Form_Resize()
  On Error Resume Next
  rtxSumary.Move 0, shTop.Height + 10, Me.ScaleWidth, Me.ScaleHeight - (shTop.Height + 20)
  shTop.Width = Me.ScaleWidth
End Sub

Private Sub pShowSumary()
  On Error Resume Next
  
  ReDim m_vWords(0)
  ReDim m_vFormats(0)
  
  pAddText "Resumen del Reporte" & vbCrLf, "Tahoma", c_Title2, &HCECECE, True
  pAddText vbCrLf, "Verdana", 8, &H80C0FF, True
  pAddText GetDocActive.Report.Name & vbCrLf, "Verdana", 20
  pAddText vbCrLf, "Verdana", 8, &H80C0FF, True
  
  ' Ubicacion
  '
  pAddText "Ubicación" & vbCrLf, "Verdana", c_Title2, &HCECECE, True
  pAddText vbCrLf, "Verdana", 8, &H80C0FF, True
  ' Conexion Principal
  '
  pAddText "Conexión Principal" & vbCrLf, "Verdana", c_Title2, &HCECECE, True
  pAddText vbCrLf, "Verdana", 8, &H80C0FF, True
      ' DataSource
      '
      pAddText vbTab & "Server" & vbCrLf, "Verdana", c_Title3, &H80C0FF, True
      pAddText vbCrLf, "Verdana", 8, &H80C0FF, True
      ' Parametros
      '
      pAddText vbTab & "Parámetros" & vbCrLf, "Verdana", c_Title3, &H80C0FF, True
      pAddText vbCrLf, "Verdana", 8, &H80C0FF, True
  ' Conexiones adicionales
  '
  pAddText "Conexiones Adicionales" & vbCrLf, "Verdana", c_Title2, &HCECECE, True
  pAddText vbCrLf, "Verdana", 8, &H80C0FF, True

      ' DataSource
      '
      pAddText vbTab & "Server" & vbCrLf, "Verdana", c_Title3, &H80C0FF, True
      pAddText vbCrLf, "Verdana", 8, &H80C0FF, True
      ' Parametros
      '
      pAddText vbTab & "Parámetros" & vbCrLf, "Verdana", c_Title3, &H80C0FF, True
      pAddText vbCrLf, "Verdana", 8, &H80C0FF, True
      '
  
  ' Secciones
  '
  pAddText "Secciones" & vbCrLf, "Tahoma", c_Title2, &HCECECE, True
  pAddText vbCrLf, "Verdana", 8, &H80C0FF, True

    ' Encabezados
    pAddText vbTab & "Encabezados" & vbCrLf, "Tahoma", c_Title3, &H808080, True
    pAddText vbCrLf, "Verdana", 8, &H80C0FF, True
      ' Formulas
      pAddText vbTab & vbTab & "Fórmulas" & vbCrLf, "Tahoma", c_Title4, &H808080, True
      pAddText vbCrLf, "Verdana", 8, &H80C0FF, True
      ' Renglones
      pAddText vbTab & vbTab & "Renglones" & vbCrLf, "Tahoma", c_Title4, &H808080, True
      pAddText vbCrLf, "Verdana", 8, &H80C0FF, True
        ' Formulas
        pAddText vbTab & vbTab & vbTab & "Fórmula de Renglones" & vbCrLf, "Tahoma", c_Title5, &H808080, True
        pAddText vbCrLf, "Verdana", 8, &H80C0FF, True
        ' Controles
        pAddText vbTab & vbTab & vbTab & "Controles" & vbCrLf, "Tahoma", c_Title5, &H808080, True
        pAddText vbCrLf, "Verdana", 8, &H80C0FF, True
          ' Formulas
          pAddText vbTab & vbTab & vbTab & vbTab & "Fórmulas" & vbCrLf, "Tahoma", c_Title6, &H808080, True
          pAddText vbCrLf, "Verdana", 8, &H80C0FF, True
    ' Grupos
    pAddText vbTab & "Grupos" & vbCrLf, "Tahoma", c_Title3, &H80C0FF, True
    pAddText vbCrLf, "Verdana", 8, &H80C0FF, True
      ' Encabezados
      pAddText vbTab & vbTab & "Encabezados" & vbCrLf, "Tahoma", c_Title4, &H808080, True
      pAddText vbCrLf, "Verdana", 8, &H80C0FF, True
        ' Formulas
        pAddText vbTab & vbTab & vbTab & "Fórmulas" & vbCrLf, "Tahoma", c_Title5, &H808080, True
        pAddText vbCrLf, "Verdana", 8, &H80C0FF, True
        ' Renglones
        pAddText vbTab & vbTab & vbTab & "Renglones" & vbCrLf, "Tahoma", c_Title5, &H808080, True
        pAddText vbCrLf, "Verdana", 8, &H80C0FF, True
          ' Formulas
          pAddText vbTab & vbTab & vbTab & vbTab & "Fórmulas" & vbCrLf, "Tahoma", c_Title6, &H808080, True
          pAddText vbCrLf, "Verdana", 8, &H80C0FF, True
          ' Controles
          pAddText vbTab & vbTab & vbTab & vbTab & "Controles" & vbCrLf, "Tahoma", c_Title6, &H808080, True
          pAddText vbCrLf, "Verdana", 8, &H80C0FF, True
            ' Formulas
            pAddText vbTab & vbTab & vbTab & vbTab & vbTab & "Fórmulas" & vbCrLf, "Tahoma", c_Title6, , True
            pAddText vbCrLf, "Verdana", 8, &H80C0FF, True
      
      ' Pies
      pAddText vbTab & "Pies" & vbCrLf, "Tahoma", c_Title3, &H80C0FF, True
      pAddText vbCrLf, "Verdana", 8, &H80C0FF, True
        ' Formulas
        pAddText vbTab & vbTab & "Fórmulas" & vbCrLf, "Tahoma", c_Title4, &H808080, True
        pAddText vbCrLf, "Verdana", 8, &H80C0FF, True
        ' Renglones
        pAddText vbTab & vbTab & "Renglones" & vbCrLf, "Tahoma", c_Title4, &H808080, True
        pAddText vbCrLf, "Verdana", 8, &H80C0FF, True
          ' Formulas
          pAddText vbTab & vbTab & vbTab & "Fórmulas" & vbCrLf, "Tahoma", c_Title5, &H808080, True
          pAddText vbCrLf, "Verdana", 8, &H80C0FF, True
          ' Controles
          pAddText vbTab & vbTab & vbTab & "Controles" & vbCrLf, "Tahoma", c_Title5, &H808080, True
          pAddText vbCrLf, "Verdana", 8, &H80C0FF, True
            ' Formulas
          pAddText vbTab & vbTab & vbTab & vbTab & "Fórmulas" & vbCrLf, "Tahoma", c_Title6, , True
          pAddText vbCrLf, "Verdana", 8, &H80C0FF, True
    ' Detalle
    pAddText vbTab & "Detalle" & vbCrLf, "Tahoma", c_Title3, &H80C0FF, True
    pAddText vbCrLf, "Verdana", 8, &H80C0FF, True
      ' Formulas
      pAddText vbTab & vbTab & "Fórmulas" & vbCrLf, "Tahoma", c_Title4, &H808080, True
      pAddText vbCrLf, "Verdana", 8, &H80C0FF, True
      ' Renglones
      pAddText vbTab & vbTab & "Renglones" & vbCrLf, "Tahoma", c_Title4, &H808080, True
      pAddText vbCrLf, "Verdana", 8, &H80C0FF, True
        ' Formulas
        pAddText vbTab & vbTab & vbTab & "Fórmulas" & vbCrLf, "Tahoma", c_Title5, &H808080, True
        pAddText vbCrLf, "Verdana", 8, &H80C0FF, True
        ' Controles
        pAddText vbTab & vbTab & vbTab & "Controles" & vbCrLf, "Tahoma", c_Title5, &H808080, True
        pAddText vbCrLf, "Verdana", 8, &H80C0FF, True
          ' Formulas
        pAddText vbTab & vbTab & vbTab & vbTab & "Fórmulas" & vbCrLf, "Tahoma", c_Title6, , True
        pAddText vbCrLf, "Verdana", 8, &H80C0FF, True
    
    ' Pies
    pAddText vbTab & "Pies" & vbCrLf, "Tahoma", c_Title3, &H80C0FF, True
    pAddText vbCrLf, "Verdana", 8, &H80C0FF, True
      ' Formulas
      pAddText vbTab & vbTab & "Fórmulas" & vbCrLf, "Tahoma", c_Title4, &H808080, True
      pAddText vbCrLf, "Verdana", 8, &H80C0FF, True
      ' Renglones
      pAddText vbTab & vbTab & "Renglones" & vbCrLf, "Tahoma", c_Title4, &H808080, True
      pAddText vbCrLf, "Verdana", 8, &H80C0FF, True
        ' Formulas
      pAddText vbTab & vbTab & vbTab & "Fórmulas" & vbCrLf, "Tahoma", c_Title5, &H808080, True
      pAddText vbCrLf, "Verdana", 8, &H80C0FF, True
        ' Controles
      pAddText vbTab & vbTab & vbTab & "Controles" & vbCrLf, "Tahoma", c_Title5, &H808080, True
      pAddText vbCrLf, "Verdana", 8, &H80C0FF, True
          ' Formulas
      pAddText vbTab & vbTab & vbTab & vbTab & "Fórmulas" & vbCrLf, "Tahoma", c_Title6, , True
      pAddText vbCrLf, "Verdana", 8, &H80C0FF, True
    
  rtxSumary.Text = Join(m_vWords, "")
  
  Dim i     As Integer
  Dim iLen  As Long
  
  For i = 0 To UBound(m_vWords)
    With rtxSumary
      .SelStart = iLen
      .SelLength = Len(m_vWords(i))
      .SelBold = m_vFormats(i).FontBold
      .SelColor = m_vFormats(i).FontColor
      .SelItalic = m_vFormats(i).FontItalic
      .SelFontName = m_vFormats(i).FontName
      .SelFontSize = m_vFormats(i).FontSize
      .SelUnderline = m_vFormats(i).FontUnderline
      iLen = iLen + .SelLength
    End With
  Next
  
  rtxSumary.SelStart = 0
  
End Sub

Private Sub pAddText(ByVal Text As String, _
                     Optional ByVal FontName As String = "Tahoma", _
                     Optional ByVal FontSize As Integer = 10, _
                     Optional ByVal FontColor As Long = vbBlack, _
                     Optional ByVal FontBold As Boolean, _
                     Optional ByVal FontItalic As Boolean, _
                     Optional ByVal FontUnderline As Boolean)
  On Error Resume Next
  
  
  ReDim Preserve m_vWords(UBound(m_vWords) + 1)
  m_vWords(UBound(m_vWords)) = Text
  ReDim Preserve m_vFormats(UBound(m_vFormats) + 1)
  With m_vFormats(UBound(m_vFormats))
    .FontBold = FontBold
    .FontColor = FontColor
    .FontItalic = FontItalic
    .FontName = FontName
    .FontSize = FontSize
    .FontUnderline = FontUnderline
  End With
End Sub

Private Sub Form_Unload(Cancel As Integer)
  CSKernelClient2.UnloadForm Me, Me.Name
End Sub

Private Sub rtxSumary_KeyDown(KeyCode As Integer, Shift As Integer)
  Select Case KeyCode
    Case vbKeyRight, vbKeyLeft, vbKeyDown, vbKeyUp, vbKeyPageDown, vbKeyPageUp
    Case vbKeyF4
    Case vbKeyC
    Case Else
      KeyCode = 0
  End Select
End Sub

Private Sub rtxSumary_KeyPress(KeyAscii As Integer)
  KeyAscii = 0
End Sub

VERSION 5.00
Object = "{353A8433-36B8-422E-ABBD-36CEE8BE628E}#1.0#0"; "CSButton.ocx"
Object = "{F7BB685C-0860-4FD1-A9CF-22277199D7A5}#1.2#0"; "CSMaskEdit2.ocx"
Begin VB.Form fFormat 
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "Formato"
   ClientHeight    =   5715
   ClientLeft      =   45
   ClientTop       =   285
   ClientWidth     =   5760
   Icon            =   "fFormat.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   5715
   ScaleWidth      =   5760
   StartUpPosition =   3  'Windows Default
   Begin CSMaskEdit2.cMaskEdit txDecimals 
      Height          =   285
      Left            =   3735
      TabIndex        =   11
      Top             =   1620
      Width           =   1005
      _ExtentX        =   1773
      _ExtentY        =   503
      Alignment       =   1
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
      Text            =   "0"
      csType          =   2
      BorderColor     =   12164479
      BorderType      =   1
      csNotRaiseError =   -1  'True
      csWithOutCalc   =   -1  'True
      ButtonStyle     =   0
   End
   Begin VB.ListBox lsFormats 
      Height          =   1620
      Left            =   2025
      TabIndex        =   4
      Top             =   2565
      Width           =   3615
   End
   Begin VB.CheckBox chkSepMiles 
      Caption         =   "&Usar separador de miles"
      Height          =   375
      Left            =   2070
      TabIndex        =   2
      Top             =   2070
      Width           =   2265
   End
   Begin VB.ListBox lsFormatTypes 
      Height          =   3375
      ItemData        =   "fFormat.frx":000C
      Left            =   90
      List            =   "fFormat.frx":000E
      Sorted          =   -1  'True
      TabIndex        =   0
      Top             =   810
      Width           =   1815
   End
   Begin CSButton.cButton cmdCancelar 
      Height          =   315
      Left            =   4365
      TabIndex        =   8
      Top             =   5265
      Width           =   1275
      _ExtentX        =   2249
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
   Begin CSButton.cButton cmdAceptar 
      Height          =   315
      Left            =   2970
      TabIndex        =   9
      Top             =   5265
      Width           =   1275
      _ExtentX        =   2249
      _ExtentY        =   556
      Caption         =   "&Aceptar"
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
   Begin VB.ComboBox cbSymbol 
      Height          =   315
      Left            =   4365
      Style           =   2  'Dropdown List
      TabIndex        =   3
      Top             =   855
      Visible         =   0   'False
      Width           =   1230
   End
   Begin VB.Line Line3 
      BorderColor     =   &H80000014&
      X1              =   0
      X2              =   7045
      Y1              =   5145
      Y2              =   5145
   End
   Begin VB.Label Label8 
      BackStyle       =   0  'Transparent
      Caption         =   "Formatos"
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
      Left            =   1050
      TabIndex        =   12
      Top             =   225
      Width           =   2235
   End
   Begin VB.Image Image1 
      Height          =   585
      Left            =   135
      Picture         =   "fFormat.frx":0010
      Top             =   45
      Width           =   675
   End
   Begin VB.Label lbSymbol 
      Caption         =   "Símbolo:"
      Height          =   240
      Left            =   4500
      TabIndex        =   10
      Top             =   2190
      Visible         =   0   'False
      Width           =   735
   End
   Begin VB.Line Line1 
      BorderColor     =   &H80000010&
      X1              =   1980
      X2              =   5625
      Y1              =   1485
      Y2              =   1485
   End
   Begin VB.Line Line2 
      BorderColor     =   &H80000010&
      X1              =   -45
      X2              =   7000
      Y1              =   5130
      Y2              =   5130
   End
   Begin VB.Label lbPosDecimal 
      Height          =   240
      Left            =   2025
      TabIndex        =   7
      Top             =   1620
      Width           =   1590
   End
   Begin VB.Label Label3 
      Caption         =   "Muestra:"
      Height          =   195
      Left            =   2070
      TabIndex        =   6
      Top             =   810
      Width           =   870
   End
   Begin VB.Label lbSample 
      Height          =   375
      Left            =   2070
      TabIndex        =   5
      Top             =   1080
      Width           =   2175
   End
   Begin VB.Label lbDescrip 
      Height          =   690
      Left            =   135
      TabIndex        =   1
      Top             =   4320
      Width           =   5415
   End
   Begin VB.Shape Shape1 
      BorderStyle     =   0  'Transparent
      FillColor       =   &H00FFFFFF&
      FillStyle       =   0  'Solid
      Height          =   690
      Left            =   0
      Top             =   0
      Width           =   6360
   End
End
Attribute VB_Name = "fFormat"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Const c_number = 1
Private Const c_date = 2
Private Const c_money = 3
Private Const c_percent = 4
Private Const c_accounting = 5
Private Const c_time = 6
Private Const c_SampleNumber = 1880215.3278911
Private Const c_SampleDate = #10/20/1999 10:35:22 PM#
Private Const c_moneypositive = 1
Private Const c_moneynegative = 2
Private Const c_moneynegativered = 3
Private Const c_moneynegativebrackets = 4

Private Const c_numberpositive = 5
Private Const c_numbernegative = 6
Private Const c_numbernegativered = 7
Private Const c_numbernegativebrackets = 8

Private m_vDescrip(1 To 6) As String

Private m_Ok                As Boolean

Private Const c_formatLongNumber = "###,###,###,###,##0"

Private m_Format            As String
Private m_Symbol            As String
Private m_IsAccounting      As Boolean

Private m_vFormatsDate()    As String

Public Property Get Ok() As Boolean
  Ok = m_Ok
End Property

Public Property Get sFormat() As String
  sFormat = m_Format
End Property

Public Property Get Symbol() As String
  Symbol = m_Symbol
End Property

Public Property Get IsAccounting() As Boolean
   IsAccounting = m_IsAccounting
End Property

Private Sub cbSymbol_Click()
  Dim a As String
  Dim d As String
  
  Const f2 = "  #,##0;  -#,##0"
  
  Select Case ListItemData(lsFormatTypes)
    Case c_money
      a = cbSymbol.Text
      lsFormats.Clear
      d = GetDecFormat
      
      With lsFormats
        .AddItem a & Format(-1234, f2) & d
        .ItemData(.NewIndex) = c_moneynegative
        .AddItem a & Format(-1234, f2) & d & " rojo"
        .ItemData(.NewIndex) = c_moneynegativered
        .AddItem a & Format(-1234, "  #,##0;  (#,##0)") & d
        .ItemData(.NewIndex) = c_moneynegativebrackets
        .AddItem a & Format(1234, f2) & d & " rojo"
        .ItemData(.NewIndex) = c_moneypositive
      End With
      lsFormats.ListIndex = 0
    
    Case c_accounting
      ShowAccountingSample
  
  End Select
End Sub

Private Function GetDecFormat() As String
  Dim f As String
 
  If Val(txDecimals.Text) > 0 Then
    f = "." & String(Val(txDecimals.Text), "0")
  End If
  GetDecFormat = f
End Function

Private Sub chkSepMiles_Click()
  FillFormatNumber
End Sub

Private Sub cmdAceptar_Click()
  m_Ok = True
  Me.Hide
End Sub

Private Sub cmdCancelar_Click()
  m_Ok = False
  Me.Hide
End Sub

Private Sub Form_Load()
  m_Ok = False
  LoadList
  PosForm
End Sub

Private Sub LoadList()
  m_vDescrip(c_number) = "Para la presentación de números en general. Para dar formato a valores monetarios utilice de moneda y contabilidad."
  m_vDescrip(c_date) = "Los formatos de fecha presentan números que representan fechas y horas como valores de fecha. Use los formartos de hora si desea presentar sólo la parte horaria."
  m_vDescrip(c_money) = "Los formatos de moneda se utilizan con los valores monetarios. Utilice los formatos de contabilidad para alinear las comas decimales en una columna."
  m_vDescrip(c_percent) = "Los formatos de porcentaje multiplican el valor de la celda por 100 y muestran el resultado con un símbolo porcentual."
  m_vDescrip(c_accounting) = "Los formatos de contabilidad alinean los símbolos de moneda y las comas decimales en una columna."
  m_vDescrip(c_time) = "Los formatos de hora presentan números que representan fechas y horas como valores de una hora. Use los formatos de fecha si desea presentar sólo la parte de la fecha."
  
  lbSymbol.Top = 1965
  cbSymbol.Top = 2200
  lbSymbol.Left = lsFormats.Left
  cbSymbol.Left = lsFormats.Left

  With lsFormatTypes
    .AddItem "Número"
    .ItemData(.NewIndex) = c_number
    .AddItem "Fecha"
    .ItemData(.NewIndex) = c_date
    .AddItem "Moneda"
    .ItemData(.NewIndex) = c_money
    .AddItem "Porcentaje"
    .ItemData(.NewIndex) = c_percent
    .AddItem "Contabilidad"
    .ItemData(.NewIndex) = c_accounting
    .AddItem "Hora"
    .ItemData(.NewIndex) = c_time
  End With
  With cbSymbol
    .AddItem "$"
    .AddItem "u$s"
    .AddItem "€"
    .ListIndex = 0
  End With
  
End Sub

Private Sub PosForm()
  Me.Left = (Screen.Width - Me.Width) * 0.75
  Me.Top = (Screen.Height - Me.Height) * 0.5
End Sub

Private Sub lsFormats_Click()
  Dim d As String
  Dim Signo As Long

  
  lbSample.ForeColor = vbWindowText

  Select Case ListItemData(lsFormatTypes)
      
    Case c_number
      d = GetDecFormat
      
      Select Case ListItemData(lsFormats)
        Case c_numbernegative
          If chkSepMiles.Value = vbChecked Then
            m_Format = c_formatLongNumber & d & ";-" & c_formatLongNumber & d
          Else
            m_Format = "0" & d & ";-0" & d
          End If
          Signo = -1
        Case c_numbernegativebrackets
          If chkSepMiles.Value = vbChecked Then
            m_Format = c_formatLongNumber & d & ";(" & c_formatLongNumber & d & ")"
          Else
            m_Format = "0" & d & ";(0" & d & ")"
          End If
          Signo = -1
        Case c_numbernegativered
          If chkSepMiles.Value = vbChecked Then
            m_Format = c_formatLongNumber & d & ";" & c_formatLongNumber & d
          Else
            m_Format = "0" & d & ";0" & d
          End If
          lbSample.ForeColor = vbRed
          Signo = -1
        Case c_numberpositive
          If chkSepMiles.Value = vbChecked Then
            m_Format = c_formatLongNumber & d & ";-" & c_formatLongNumber & d
          Else
            m_Format = "0" & d & ";-0" & d
          End If
          lbSample.ForeColor = vbRed
          Signo = 1
      End Select
      ShowSample c_SampleNumber * Signo
        
    Case c_date, c_time
      m_Format = m_vFormatsDate(lsFormats.ListIndex)
      ShowSample c_SampleDate, ""
    
    Case c_money
      d = GetDecFormat
      
      Select Case ListItemData(lsFormats)
        Case c_moneynegative
          m_Format = c_formatLongNumber & d & ";-" & c_formatLongNumber & d
          Signo = -1
        Case c_moneynegativebrackets
          m_Format = c_formatLongNumber & d & ";(" & c_formatLongNumber & d & ")"
          Signo = -1
        Case c_moneynegativered
          m_Format = c_formatLongNumber & d & ";" & c_formatLongNumber & d
          lbSample.ForeColor = vbRed
          Signo = -1
        Case c_moneypositive
          m_Format = c_formatLongNumber & d & ";-" & c_formatLongNumber & d
          lbSample.ForeColor = vbRed
          Signo = 1
      End Select
      ShowSample c_SampleNumber * Signo, cbSymbol.Text
      
    Case c_percent
      
    Case c_accounting
         
  End Select
End Sub

Private Sub lsFormatTypes_Click()
  lsFormats.Clear
  lsFormats.Height = 1620
  lsFormats.Top = 2565 '1800
  chkSepMiles.Visible = False
  cbSymbol.Visible = False
  lbSymbol.Visible = False
  lbPosDecimal.Visible = True
  lbPosDecimal.Caption = "&Posiciones decimales:"
  txDecimals.Visible = True
  m_IsAccounting = False
  
  Select Case ListItemData(lsFormatTypes)
    Case c_number
      lbDescrip.Caption = m_vDescrip(c_number)
      chkSepMiles.Visible = True
      FillFormatNumber
      lsFormats.Visible = True
    Case c_date
      lbDescrip.Caption = m_vDescrip(c_date)
      lbPosDecimal.Visible = False
      txDecimals.Visible = False
      lsFormats.Height = 2300
      lsFormats.Top = 1965
      lbPosDecimal.Caption = "Tipo:"
      lbPosDecimal.Visible = True
      ReDim m_vFormatsDate(0 To 11)
      With lsFormats
        .AddItem "14-3"
        m_vFormatsDate(0) = "dd-m"
        .AddItem "14-3-98"
        m_vFormatsDate(1) = "dd-m-yy"
        .AddItem "14-03-98"
        m_vFormatsDate(2) = "dd-mm-yy"
        .AddItem "14 mar"
        m_vFormatsDate(3) = "dd-mmm"
        .AddItem "14-mar-98"
        m_vFormatsDate(4) = "dd-mmm-yy"
        .AddItem "mar-98"
        m_vFormatsDate(5) = "mmm-yy"
        .AddItem "marzo-98"
        m_vFormatsDate(6) = "mmmm-yy"
        .AddItem "14 de marzo de 1998"
        m_vFormatsDate(7) = "dd \de mmmm \de yyyy"
        .AddItem "14-03-98 1:30 pm"
        m_vFormatsDate(8) = "dd-mm-yy h:nn am/pm"
        .AddItem "14-03-98 13:30"
        m_vFormatsDate(9) = "dd-mm-yy hh:nn"
        .AddItem "m"
        m_vFormatsDate(10) = "m"
        .AddItem "m-98"
        m_vFormatsDate(11) = "m-yy"
      End With
      lsFormats.ListIndex = 0
      lsFormats.Visible = True
    Case c_money
      lbDescrip.Caption = m_vDescrip(c_money)
      cbSymbol.Visible = True
      lbSymbol.Visible = True
      cbSymbol.ListIndex = -1
      cbSymbol.ListIndex = 0
      lsFormats.Visible = True
    Case c_percent
      lbDescrip.Caption = m_vDescrip(c_percent)
      lsFormats.Visible = False
      ShowPercentSample
    Case c_accounting
      lbDescrip.Caption = m_vDescrip(c_accounting)
      cbSymbol.Visible = True
      lbSymbol.Visible = True
      lsFormats.Visible = False
      m_IsAccounting = True
      ShowAccountingSample
    Case c_time
      lbDescrip.Caption = m_vDescrip(c_time)
      lbPosDecimal.Visible = False
      txDecimals.Visible = False
      lsFormats.Height = 2300
      lsFormats.Top = 1965
      lbPosDecimal.Caption = "Tipo:"
      lbPosDecimal.Visible = True
      ReDim m_vFormatsDate(0 To 7)
      With lsFormats
        .AddItem "13:30"
        m_vFormatsDate(0) = "hh:nn"
        .AddItem "1:30 pm"
        m_vFormatsDate(1) = "h:nn am/pm"
        .AddItem "13:30:55"
        m_vFormatsDate(2) = "hh:nn:ss"
        .AddItem "1:30:55 pm"
        m_vFormatsDate(3) = "h:nn:ss am/pm"
        .AddItem "30:55:7"
        m_vFormatsDate(4) = "nn:ss:0"
        .AddItem "37:30:55"
        m_vFormatsDate(5) = "nn:ss:00"
        .AddItem "14-3-98 1:30 pm"
        m_vFormatsDate(6) = "dd-m-yy h:nn am/pm"
        .AddItem "14-3-98 13:30"
        m_vFormatsDate(7) = "dd-m-yy nn:ss"
      End With
      lsFormats.Visible = True
      lsFormats.ListIndex = 0
  End Select
  
End Sub

Private Sub ShowSample(ByVal Value As Variant, Optional ByVal Symbol As String)
  m_Symbol = Symbol
  If Symbol <> "" Then
    lbSample.Caption = Symbol & " " & Format(Value, m_Format)
  Else
    lbSample.Caption = Format(Value, m_Format)
  End If
  
End Sub

Private Sub txDecimals_Change()
  Select Case ListItemData(lsFormatTypes)
    Case c_number
      FillFormatNumber
    Case c_money
      cbSymbol_Click
    Case c_percent
      ShowPercentSample
    Case c_accounting
      ShowAccountingSample
  End Select
  
End Sub

Private Sub FillFormatNumber()
  Dim d As String
  Dim f2 As String
  
  If chkSepMiles.Value = vbChecked Then
    f2 = " #,##0; -#,##0"
  Else
    f2 = " 0; 0"
  End If
  

  lsFormats.Clear
  d = GetDecFormat
  
  With lsFormats
    .AddItem Format(-1234, f2) & d
    .ItemData(.NewIndex) = c_numbernegative
    .AddItem Format(-1234, f2) & d & " rojo"
    .ItemData(.NewIndex) = c_numbernegativered
    If chkSepMiles.Value = vbChecked Then
      .AddItem Format(-1234, " #,##0; (#,##0)") & d
    Else
      .AddItem Format(-1234, " 0; (0)") & d
    End If
    .ItemData(.NewIndex) = c_numbernegativebrackets
    .AddItem Format(1234, f2) & d & " rojo"
    .ItemData(.NewIndex) = c_numberpositive
  End With
  lsFormats.ListIndex = 0
End Sub

Private Sub ShowPercentSample()
  Dim d As String
  
  d = GetDecFormat()
  m_Format = "0" & d & " %;0" & d & "%"
  ShowSample 0.85549
End Sub

Private Sub ShowAccountingSample()
  Dim d As String
  
  d = GetDecFormat()
  m_Format = c_formatLongNumber & d & ";-" & c_formatLongNumber & d
  ShowSample 25028207, cbSymbol.Text & "     "
End Sub

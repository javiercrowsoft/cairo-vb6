VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cABMGridCellFormat"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIABMGridCellFormat

'--------------------------------------------------------------------------------
' cABMGridColumn
' 06-01-01

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
Private m_SubType       As csSubTypeABMProperty
Private m_Table         As csTables
Private m_Type          As csTypeABMProperty
Private m_List          As cABMList
Private m_Size          As Integer
Private m_Enabled       As Boolean
Private m_HelpFilter    As String
Private m_Format        As String
Private m_Color         As Long
Private m_BackColor     As Long

' Fonts
'
Private m_Bold                          As Boolean
Private m_FontSize                      As Double
Private m_FontName                      As String
Private m_Underline                     As Boolean
Private m_Strike                        As Boolean
Private m_Align                         As ECGTextAlignFlags
Private m_Italic                        As Boolean

' eventos
' propiedades publicas
Private Property Let cIABMGridCellFormat_BackColor(ByVal rhs As Long)
  m_BackColor = rhs
End Property

Private Property Get cIABMGridCellFormat_BackColor() As Long
  cIABMGridCellFormat_BackColor = m_BackColor
End Property

Private Property Let cIABMGridCellFormat_Color(ByVal rhs As Long)
  m_Color = rhs
End Property

Private Property Get cIABMGridCellFormat_Color() As Long
  cIABMGridCellFormat_Color = m_Color
End Property

Private Property Let cIABMGridCellFormat_Format(ByVal rhs As String)
  m_Format = rhs
End Property

Private Property Get cIABMGridCellFormat_Format() As String
  cIABMGridCellFormat_Format = m_Format
End Property

Private Property Let cIABMGridCellFormat_Enabled(ByVal rhs As Boolean)
  m_Enabled = rhs
End Property

Private Property Get cIABMGridCellFormat_Enabled() As Boolean
  cIABMGridCellFormat_Enabled = m_Enabled
End Property

Private Property Let cIABMGridCellFormat_HelpFilter(ByVal rhs As String)
  m_HelpFilter = rhs
End Property

Private Property Get cIABMGridCellFormat_HelpFilter() As String
  cIABMGridCellFormat_HelpFilter = m_HelpFilter
End Property

Private Property Let cIABMGridCellFormat_List(ByVal rhs As CSInterfacesABM.cIABMList)
  Set m_List = rhs
End Property

Private Property Get cIABMGridCellFormat_List() As CSInterfacesABM.cIABMList
  If m_List Is Nothing Then Set m_List = New cABMList
  Set cIABMGridCellFormat_List = m_List
End Property

Private Property Let cIABMGridCellFormat_SubType(ByVal rhs As csSubTypeABMProperty)
  m_SubType = rhs
End Property

Private Property Get cIABMGridCellFormat_SubType() As csSubTypeABMProperty
  cIABMGridCellFormat_SubType = m_SubType
End Property

Private Property Let cIABMGridCellFormat_Table(ByVal rhs As csTables)
  m_Table = rhs
End Property

Private Property Get cIABMGridCellFormat_Table() As csTables
  cIABMGridCellFormat_Table = m_Table
End Property

Private Property Let cIABMGridCellFormat_Size(ByVal rhs As Integer)
  m_Size = rhs
End Property

Private Property Get cIABMGridCellFormat_Size() As Integer
  cIABMGridCellFormat_Size = m_Size
End Property

Private Property Let cIABMGridCellFormat_PropertyType(ByVal rhs As csTypeABMProperty)
  m_Type = rhs
End Property

Private Property Get cIABMGridCellFormat_PropertyType() As csTypeABMProperty
  cIABMGridCellFormat_PropertyType = m_Type
End Property

'/////////////////////////////////////////////////////////////////////////////////////
' Formato
'

Public Property Get Bold() As Boolean
   Bold = m_Bold
End Property

Public Property Let Bold(ByVal rhs As Boolean)
   m_Bold = rhs
End Property

Public Property Get FontSize() As Double
   FontSize = m_FontSize
End Property

Public Property Let FontSize(ByVal rhs As Double)
   m_FontSize = rhs
End Property

Public Property Get FontName() As String
   FontName = m_FontName
End Property

Public Property Let FontName(ByVal rhs As String)
   m_FontName = rhs
End Property

Public Property Get Underline() As Boolean
   Underline = m_Underline
End Property

Public Property Let Underline(ByVal rhs As Boolean)
   m_Underline = rhs
End Property

Public Property Get Strike() As Boolean
   Strike = m_Strike
End Property

Public Property Let Strike(ByVal rhs As Boolean)
   m_Strike = rhs
End Property

Public Property Get Align() As ECGTextAlignFlags
   Align = m_Align
End Property

Public Property Let Align(ByVal rhs As ECGTextAlignFlags)
   m_Align = rhs
End Property

Public Property Get Italic() As Boolean
   Italic = m_Italic
End Property

Public Property Let Italic(ByVal rhs As Boolean)
   m_Italic = rhs
End Property

' propiedades privadas
' funciones publicas
' funciones privadas
' construccion - destruccion
Private Sub Class_Initialize()
  m_Enabled = True
  m_Color = vbWindowText
  m_BackColor = vbWindowBackground
  m_FontSize = 8.25
  m_FontName = "MS Sans Serif"
  m_Align = DT_NOPREFIX
End Sub

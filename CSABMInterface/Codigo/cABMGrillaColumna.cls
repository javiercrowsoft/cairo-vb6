VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cABMGridColumn"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIABMGridColumn

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
Private m_Key               As Integer
Private m_Name              As String
Private m_Visible           As Boolean
Private m_SubType           As csSubTypeABMProperty
Private m_Table             As csTables
Private m_Type              As csTypeABMProperty
Private m_List              As cABMList
Private m_Size              As Integer
Private m_HelpId            As Long
Private m_Enabled           As Boolean
Private m_HelpFilter        As String
Private m_HelpSPFilter      As String
Private m_HelpSPInfoFilter  As String
Private m_Width             As Integer
Private m_Format            As String
Private m_Default           As cABMGridRowValue
Private m_Index             As Long
Private m_IsDetail          As Boolean
Private m_IsForAbm          As Boolean
Private m_IsEditColumn      As Boolean

Private m_HelpType          As csHelpType

' eventos
' propiedades publicas
Public Property Get Index() As Long
  Index = m_Index
End Property

Public Property Let Index(ByVal rhs As Long)
  m_Index = rhs
End Property

Public Property Get IsDetail() As Boolean
  IsDetail = m_IsDetail
End Property

Public Property Let IsDetail(ByVal rhs As Boolean)
  m_IsDetail = rhs
End Property

Public Property Get HelpType() As csHelpType
  HelpType = m_HelpType
End Property

Public Property Let HelpType(ByVal rhs As csHelpType)
  m_HelpType = rhs
End Property

Public Property Get IsForAbm() As Boolean
  IsForAbm = m_IsForAbm
End Property

Public Property Let IsForAbm(ByVal rhs As Boolean)
  m_IsForAbm = rhs
End Property

Public Property Get IsEditColumn() As Boolean
  IsEditColumn = m_IsEditColumn
End Property

Public Property Let IsEditColumn(ByVal rhs As Boolean)
  m_IsEditColumn = rhs
End Property

Private Property Set cIABMGridColumn_DefaultValue(rhs As CSInterfacesABM.cIABMGridCellValue)
  Set m_Default = rhs
End Property

Private Property Get cIABMGridColumn_DefaultValue() As CSInterfacesABM.cIABMGridCellValue
  Set cIABMGridColumn_DefaultValue = m_Default
End Property

Private Property Let cIABMGridColumn_Format(ByVal rhs As String)
  m_Format = rhs
End Property

Private Property Get cIABMGridColumn_Format() As String
  cIABMGridColumn_Format = m_Format
End Property

Private Property Let cIABMGridColumn_HelpSPFilter(ByVal rhs As String)
  m_HelpSPFilter = rhs
End Property

Private Property Get cIABMGridColumn_HelpSPFilter() As String
  cIABMGridColumn_HelpSPFilter = m_HelpSPFilter
End Property

Private Property Let cIABMGridColumn_HelpSPInfoFilter(ByVal rhs As String)
  m_HelpSPInfoFilter = rhs
End Property

Private Property Get cIABMGridColumn_HelpSPInfoFilter() As String
  cIABMGridColumn_HelpSPInfoFilter = m_HelpSPInfoFilter
End Property

Private Property Get cIABMGridColumn_Key() As Integer
  cIABMGridColumn_Key = m_Key
End Property

Private Property Let cIABMGridColumn_Key(ByVal rhs As Integer)
  m_Key = rhs
End Property

Private Property Get cIABMGridColumn_Name() As String
  cIABMGridColumn_Name = m_Name
End Property

Private Property Let cIABMGridColumn_Name(rhs As String)
  m_Name = rhs
End Property

Private Property Let cIABMGridColumn_Visible(ByVal rhs As Boolean)
  m_Visible = rhs
End Property

Private Property Get cIABMGridColumn_Visible() As Boolean
  cIABMGridColumn_Visible = m_Visible
End Property

Private Property Let cIABMGridColumn_Enabled(ByVal rhs As Boolean)
  m_Enabled = rhs
End Property

Private Property Get cIABMGridColumn_Enabled() As Boolean
  cIABMGridColumn_Enabled = m_Enabled
End Property

Private Property Let cIABMGridColumn_HelpFilter(ByVal rhs As String)
  m_HelpFilter = rhs
End Property

Private Property Get cIABMGridColumn_HelpFilter() As String
  cIABMGridColumn_HelpFilter = m_HelpFilter
End Property

Private Property Let cIABMGridColumn_List(ByVal rhs As CSInterfacesABM.cIABMList)
  Set m_List = rhs
End Property

Private Property Get cIABMGridColumn_List() As CSInterfacesABM.cIABMList
  If m_List Is Nothing Then Set m_List = New cABMList
  Set cIABMGridColumn_List = m_List
End Property

Private Property Let cIABMGridColumn_SubType(ByVal rhs As csSubTypeABMProperty)
  m_SubType = rhs
End Property

Private Property Get cIABMGridColumn_SubType() As csSubTypeABMProperty
  cIABMGridColumn_SubType = m_SubType
End Property

Private Property Let cIABMGridColumn_Table(ByVal rhs As csTables)
  m_Table = rhs
End Property

Private Property Get cIABMGridColumn_Table() As csTables
  cIABMGridColumn_Table = m_Table
End Property

Private Property Let cIABMGridColumn_Size(ByVal rhs As Integer)
  m_Size = rhs
End Property

Private Property Get cIABMGridColumn_Size() As Integer
  cIABMGridColumn_Size = m_Size
End Property

Private Property Let cIABMGridColumn_PropertyType(ByVal rhs As csTypeABMProperty)
  m_Type = rhs
End Property

Private Property Get cIABMGridColumn_PropertyType() As csTypeABMProperty
  cIABMGridColumn_PropertyType = m_Type
End Property

Private Property Let cIABMGridColumn_Width(ByVal rhs As Integer)
  m_Width = rhs
End Property

Private Property Get cIABMGridColumn_Width() As Integer
  cIABMGridColumn_Width = m_Width
End Property

' propiedades privadas
' funciones publicas
' funciones privadas
' construccion - destruccion

Private Sub Class_Initialize()
  m_Visible = True
  m_Enabled = True
  m_IsEditColumn = True
End Sub

Private Sub Class_Terminate()
  Set m_Default = Nothing
End Sub

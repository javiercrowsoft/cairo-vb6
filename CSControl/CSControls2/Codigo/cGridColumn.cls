VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cGridColumn"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' CSGrid.cGridColumn
' 15-05-2003

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "CSGrid.cGridColumn"
' estructuras
' variables privadas

' Propiedades de las columnas de CSGrid
Private m_Caption                       As String
Private m_IconIndex                     As Long
Private m_Key                           As String
Private m_Align                         As csGridAlignEnum
Private m_Width                         As Long
Private m_Order                         As Long
Private m_Visible                       As Boolean
Private m_Fixed                         As Boolean
Private m_Format                        As String
Private m_IsDetail                      As Boolean
Private m_SortType                      As csGridSortTypeEnum
Private m_AllowEdit                     As Boolean
Private m_Index                         As Integer

' Para manejar la edicion
Private m_Table                         As csTables
Private m_EditType                      As csTypeABMProperty
Private m_EditSubType                   As csSubTypeABMProperty
Private m_Value                         As String
Private m_List                          As Object
Private m_Size                          As Integer
Private m_HelpId                        As Long
Private m_TabIndex                      As Integer
Private m_Enabled                       As Boolean
Private m_HelpFilter                    As String

' Para manejar la actualizacion de las columnas
Private m_Grid                          As CSGrid.cGrid

' eventos
' propiedadades publicas
Public Property Get Index() As Integer
   Index = m_Index
End Property

Public Property Get Caption() As String
   Caption = m_Caption
End Property

Public Property Let Caption(ByVal rhs As String)
   m_Caption = rhs
   If m_Grid Is Nothing Then Exit Property
   m_Grid.ColumnHeader(m_Index) = rhs
End Property

Public Property Get IconIndex() As Long
   IconIndex = m_IconIndex
End Property

Public Property Let IconIndex(ByVal rhs As Long)
   m_IconIndex = rhs
   If m_Grid Is Nothing Then Exit Property
   m_Grid.ColumnImage(m_Index) = rhs
End Property

Public Property Get Key() As String
   Key = m_Key
End Property

Public Property Get Align() As csGridAlignEnum
   Align = m_Align
End Property

Public Property Let Align(ByVal rhs As csGridAlignEnum)
   m_Align = rhs
   If m_Grid Is Nothing Then Exit Property
   m_Grid.ColumnAlign(m_Index) = rhs
End Property

Public Property Get Width() As Long
  If m_Grid Is Nothing Then
    Width = m_Width
  Else
    m_Width = m_Grid.ColumnWidth(m_Index) * Screen.TwipsPerPixelX
    Width = m_Width
  End If
End Property

Public Property Let Width(ByVal rhs As Long)
   m_Width = rhs
   If m_Grid Is Nothing Then Exit Property
   m_Grid.ColumnWidth(m_Index) = rhs / Screen.TwipsPerPixelX
   m_Grid.SetHeaders
End Property

Public Property Get Order() As Long
  If m_Grid Is Nothing Then
    Order = m_Order
  Else
    m_Order = m_Grid.ColumnOrder(m_Index)
    Order = m_Order
  End If
End Property

Public Property Let Order(ByVal rhs As Long)
   m_Order = rhs
   If m_Grid Is Nothing Then Exit Property
   If rhs > 0 Then
    m_Grid.ColumnOrder(m_Index) = rhs
  End If
End Property

Public Property Get Visible() As Boolean
   Visible = m_Visible
End Property

Public Property Let Visible(ByVal rhs As Boolean)
   m_Visible = rhs
   If m_Grid Is Nothing Then Exit Property
   m_Grid.ColumnVisible(m_Index) = rhs
End Property

Public Property Get Fixed() As Boolean
   Fixed = m_Fixed
End Property

Public Property Let Fixed(ByVal rhs As Boolean)
   m_Fixed = rhs
   If m_Grid Is Nothing Then Exit Property
   ' Por ahora no hace nada, falta programarlo en el control cGrid
   'm_Grid.ColumnVisible(m_Index) = rhs
End Property

Public Property Get Format() As String
   Format = m_Format
End Property

Public Property Let Format(ByVal rhs As String)
   m_Format = rhs
   If m_Grid Is Nothing Then Exit Property
   m_Grid.ColumnFormatString(m_Index) = rhs
End Property

Public Property Get IsDetail() As Boolean
   IsDetail = m_IsDetail
End Property

Public Property Get SortType() As csGridSortTypeEnum
   SortType = m_SortType
End Property

Public Property Let SortType(ByVal rhs As csGridSortTypeEnum)
   m_SortType = rhs
   If m_Grid Is Nothing Then Exit Property
   m_Grid.ColumnSortType(m_Index) = rhs
End Property

Public Property Get AllowEdit() As Boolean
   AllowEdit = m_AllowEdit
End Property

Public Property Let AllowEdit(ByVal rhs As Boolean)
   m_AllowEdit = rhs
End Property

Public Property Get EditType() As csTypeABMProperty
   EditType = m_EditType
End Property

Public Property Let EditType(ByVal rhs As csTypeABMProperty)
   m_EditType = rhs
   Select Case m_EditType
    Case csTypeABMProperty.cspNumeric
      Align = csALignRight
    Case csTypeABMProperty.cspDate
      Align = csALignRight
      Format = "dd-mm-yyyy"
    Case csTypeABMProperty.cspCheck
      m_Grid.ColumnEditOnClick(m_Index) = True
   End Select
End Property

Public Property Get EditSubType() As csSubTypeABMProperty
   EditSubType = m_EditSubType
End Property

Public Property Let EditSubType(ByVal rhs As csSubTypeABMProperty)
   m_EditSubType = rhs
   Select Case rhs
    Case csSubTypeABMProperty.cspDouble
      Format = "#,###,##0.00"
    Case csSubTypeABMProperty.cspInteger
      Format = "#,###,##0"
    Case csSubTypeABMProperty.cspMoney
      Format = "$ #,###,##0.00"
    Case csSubTypeABMProperty.cspPercent
      Format = "0.00 %"
   End Select
End Property

Public Property Let Enabled(ByVal rhs As Boolean)
   m_Enabled = rhs
End Property

Public Property Get Enabled() As Boolean
   Enabled = m_Enabled
End Property

Public Property Let HelpFilter(ByVal rhs As String)
   m_HelpFilter = rhs
End Property

Public Property Get HelpFilter() As String
   HelpFilter = m_HelpFilter
End Property

Public Property Let List(ByVal rhs As Object)
   Set m_List = rhs
End Property

Public Property Get List() As Object
   Set List = m_List
End Property

Public Property Let Table(ByVal rhs As csTables)
   m_Table = rhs
End Property

Public Property Get Table() As csTables
   Table = m_Table
End Property

Public Property Let Size(ByVal rhs As Integer)
   m_Size = rhs
End Property

Public Property Get Size() As Integer
   Size = m_Size
End Property

' propiedadades friend
Friend Property Let IsDetail(ByVal rhs As Boolean)
  m_IsDetail = rhs
End Property

Friend Property Let Key(ByVal rhs As String)
  m_Key = rhs
End Property

Friend Property Let Index(ByVal rhs As Integer)
  m_Index = rhs
End Property

Friend Property Get Grid() As CSGrid.cGrid
  Set Grid = m_Grid
End Property

Friend Property Set Grid(ByRef rhs As CSGrid.cGrid)
  Set m_Grid = rhs
End Property
' propiedades privadas
' funciones publicas
' funciones friend
' funciones privadas
' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError

  m_Align = csALignLeft
  m_IconIndex = -1
  m_Width = -1
  m_Order = -1
  m_Visible = True
  m_Enabled = True
  m_AllowEdit = True
  m_SortType = csGridSortString

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
  On Error GoTo ControlError
  
  Set m_Grid = Nothing
  
  GoTo ExitProc
ControlError:
  MngError Err, "Class_Terminate", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
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



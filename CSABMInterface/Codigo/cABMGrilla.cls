VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cABMGrid"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIABMGrid

'--------------------------------------------------------------------------------
' cABMGrid
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
Private m_Columns                       As cABMGridColumns
Private m_Rows                          As cABMGridRows
Private m_bRowSelect                    As Boolean
Private m_DontResize                    As Boolean
Private m_DontResizeHeight              As Boolean
Private m_bDontSelectInGotFocus         As Boolean
Private m_bMultiSelect                  As Boolean

' eventos
' propiedades publicas
' propiedades privadas
' funciones publicas
Public Function SetRows(ByRef Rows As cIABMGridRows)
  Set m_Rows = Rows
End Function

Public Property Get DontSelectInGotFocus() As Boolean
  DontSelectInGotFocus = m_bDontSelectInGotFocus
End Property

Public Property Let DontSelectInGotFocus(ByVal rhs As Boolean)
  m_bDontSelectInGotFocus = rhs
End Property

Public Property Get RowSelect() As Boolean
  RowSelect = m_bRowSelect
End Property

Public Property Let RowSelect(ByVal rhs As Boolean)
  m_bRowSelect = rhs
End Property

Public Property Let DontResize(ByVal rhs As Boolean)
  m_DontResize = rhs
End Property

Public Property Get DontResize() As Boolean
  DontResize = m_DontResize
End Property

Public Property Let DontResizeHeight(ByVal rhs As Boolean)
  m_DontResizeHeight = rhs
End Property

Public Property Get DontResizeHeight() As Boolean
  DontResizeHeight = m_DontResizeHeight
End Property

Public Property Get MultiSelect() As Boolean
  MultiSelect = m_bMultiSelect
End Property

Public Property Let MultiSelect(ByVal rhs As Boolean)
  m_bMultiSelect = rhs
End Property

Private Property Get cIABMGrid_Rows() As CSInterfacesABM.cIABMGridRows
    If m_Rows Is Nothing Then Set m_Rows = New cABMGridRows
    Set cIABMGrid_Rows = m_Rows
End Property

Private Property Get cIABMGrid_Columns() As CSInterfacesABM.cIABMGridColumns
    If m_Columns Is Nothing Then Set m_Columns = New cABMGridColumns
    Set cIABMGrid_Columns = m_Columns
End Property

' funciones privadas
' construccion - destruccion

Private Sub Class_Terminate()
    Set m_Columns = Nothing
    Set m_Rows = Nothing
End Sub

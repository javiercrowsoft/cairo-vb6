VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cABMGridRowValue"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIABMGridCellValue

'--------------------------------------------------------------------------------
' cABMGridRowValue
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
Private m_Value             As String
Private m_ID                As Long
Private m_Format            As cABMGridCellFormat
Private m_strKey            As String
Private m_HelpValueProcess  As String

' eventos
' propiedades publicas
Public Property Get strKey() As String
  strKey = m_strKey
End Property

Public Property Let strKey(ByVal rhs As String)
  m_strKey = rhs
End Property

Public Property Let HelpValueProcess(ByVal rhs As String)
  m_HelpValueProcess = rhs
End Property

Public Property Get HelpValueProcess() As String
  HelpValueProcess = m_HelpValueProcess
End Property

' propiedades privadas
' funciones publicas
Private Property Get cIABMGridCellValue_ID() As Long
  cIABMGridCellValue_ID = m_ID
End Property

Private Property Let cIABMGridCellValue_ID(rhs As Long)
  m_ID = rhs
End Property

Private Property Get cIABMGridCellValue_Key() As Integer
  cIABMGridCellValue_Key = m_Key
End Property

Private Property Let cIABMGridCellValue_Key(ByVal rhs As Integer)
  m_Key = rhs
End Property

Private Property Get cIABMGridCellValue_Value() As String
  cIABMGridCellValue_Value = m_Value
End Property

Private Property Let cIABMGridCellValue_Value(rhs As String)
  m_Value = rhs
End Property

Private Property Set cIABMGridCellValue_Format(rhs As CSInterfacesABM.cIABMGridCellFormat)
  Set m_Format = rhs
End Property

Private Property Get cIABMGridCellValue_Format() As CSInterfacesABM.cIABMGridCellFormat
  Set cIABMGridCellValue_Format = m_Format
End Property

' funciones privadas
' construccion - destruccion
Private Sub Class_Terminate()
  On Error Resume Next
  Set m_Format = Nothing
End Sub

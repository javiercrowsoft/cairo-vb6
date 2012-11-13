VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cGenericEditProperty"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cGenericEditProperty
' 01-12-2008

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cGenericEditProperty"

Private Const c_no_value = "##_no_value_##"

' estructuras
' variables privadas
Private m_tbl_id                       As Long
Private m_Tabla                        As String
Private m_Id                           As Long
Private m_Nombre                       As String
Private m_NombreFisico                 As String
Private m_Tipo                         As csTypeABMProperty
Private m_SubTipo                      As csSubTypeABMProperty
Private m_Orden                        As Integer
Private m_HelpType                     As csHelpType
Private m_Filtro                       As String
Private m_DefaultValue                 As String
Private m_MinValue                     As String
Private m_MaxValue                     As String
Private m_TextAlign                    As AlignmentConstants
Private m_TextMask                     As String
Private m_Format                       As String
Private m_Width                        As Integer
Private m_Height                       As Integer
Private m_Top                          As Integer
Private m_Left                         As Integer
Private m_NoShowButton                 As Boolean
Private m_Sqlstmt                      As String

Private m_Value                        As String
Private m_HelpValue                    As String

' eventos
' propiedades publicas
Public Property Get tbl_id() As Long
  tbl_id = m_tbl_id
End Property

Public Property Let tbl_id(ByVal rhs As Long)
  m_tbl_id = rhs
End Property

Public Property Get Tabla() As String
  Tabla = m_Tabla
End Property

Public Property Let Tabla(ByVal rhs As String)
  m_Tabla = rhs
End Property

Public Property Get Id() As Long
  Id = m_Id
End Property

Public Property Let Id(ByVal rhs As Long)
  m_Id = rhs
End Property

Public Property Get Nombre() As String
  Nombre = m_Nombre
End Property

Public Property Let Nombre(ByVal rhs As String)
  m_Nombre = rhs
End Property

Public Property Get NombreFisico() As String
  NombreFisico = m_NombreFisico
End Property

Public Property Let NombreFisico(ByVal rhs As String)
  m_NombreFisico = rhs
End Property

Public Property Get Tipo() As csTypeABMProperty
  Tipo = m_Tipo
End Property

Public Property Let Tipo(ByVal rhs As csTypeABMProperty)
  m_Tipo = rhs
End Property

Public Property Get SubTipo() As csSubTypeABMProperty
  If m_Tipo = cspNumeric Then
    If m_SubTipo <> 0 Then
      SubTipo = m_SubTipo
    Else
      SubTipo = cspInteger
    End If
  Else
    SubTipo = m_SubTipo
  End If
End Property

Public Property Let SubTipo(ByVal rhs As csSubTypeABMProperty)
  m_SubTipo = rhs
End Property

Public Property Get Orden() As Integer
  Orden = m_Orden
End Property

Public Property Let Orden(ByVal rhs As Integer)
  m_Orden = rhs
End Property

Public Property Get HelpType() As csHelpType
  HelpType = m_HelpType
End Property

Public Property Let HelpType(ByVal rhs As csHelpType)
  m_HelpType = rhs
End Property

Public Property Get Filtro() As String
  Filtro = m_Filtro
End Property

Public Property Let Filtro(ByVal rhs As String)
  m_Filtro = pReplaceMacro(rhs)
End Property

Public Property Get DefaultValue() As String
  DefaultValue = m_DefaultValue
End Property

Public Property Let DefaultValue(ByVal rhs As String)
  m_DefaultValue = rhs
End Property

Public Property Get MinValue() As String
  MinValue = m_MinValue
End Property

Public Property Let MinValue(ByVal rhs As String)
  m_MinValue = rhs
End Property

Public Property Get MaxValue() As String
  MaxValue = m_MaxValue
End Property

Public Property Let MaxValue(ByVal rhs As String)
  m_MaxValue = rhs
End Property

Public Property Get TextAlign() As AlignmentConstants
  TextAlign = m_TextAlign
End Property

Public Property Let TextAlign(ByVal rhs As AlignmentConstants)
  m_TextAlign = rhs
End Property

Public Property Get TextMask() As String
  TextMask = m_TextMask
End Property

Public Property Let TextMask(ByVal rhs As String)
  m_TextMask = rhs
End Property

Public Property Get Format() As String
  Format = m_Format
End Property

Public Property Let Format(ByVal rhs As String)
  m_Format = rhs
End Property

Public Property Get Width() As Integer
  Width = m_Width
End Property

Public Property Let Width(ByVal rhs As Integer)
  m_Width = rhs
End Property

Public Property Get Height() As Integer
  Height = m_Height
End Property

Public Property Let Height(ByVal rhs As Integer)
  m_Height = rhs
End Property

Public Property Get Top() As Integer
  Top = m_Top
End Property

Public Property Let Top(ByVal rhs As Integer)
  m_Top = rhs
End Property

Public Property Get Left() As Integer
  Left = m_Left
End Property

Public Property Let Left(ByVal rhs As Integer)
  m_Left = rhs
End Property

Public Property Get NoShowButton() As Boolean
  NoShowButton = m_NoShowButton
End Property

Public Property Let NoShowButton(ByVal rhs As Boolean)
  m_NoShowButton = rhs
End Property

Public Property Get sqlstmt() As String
  sqlstmt = m_Sqlstmt
End Property

Public Property Let sqlstmt(ByVal rhs As String)
  m_Sqlstmt = rhs
End Property

Public Property Get Value() As String
  If m_Value = c_no_value Then
    Value = m_DefaultValue
  Else
    Value = m_Value
  End If
End Property

Public Property Let Value(ByVal rhs As String)
  m_Value = rhs
End Property

Public Property Get HelpValue() As String
  HelpValue = m_HelpValue
End Property

Public Property Let HelpValue(ByVal rhs As String)
  m_HelpValue = rhs
End Property
' propiedades friend
' propiedades privadas
' funciones publicas
' funciones friend
' funciones privadas
Private Function pReplaceMacro(ByVal rhs As String) As String
  rhs = Replace(rhs, "@@emp_id", EmpId)
  rhs = Replace(rhs, "@@us_id", User.Id)
End Function
' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError

  m_Value = c_no_value

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, ""
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


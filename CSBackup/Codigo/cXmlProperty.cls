VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cXmlProperty"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' cXmlProperty
' 25-01-06

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones
    Private Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (lpvDest As Any, lpvSource As Any, ByVal cbCopy As Long)
    
'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cXmlProperty"
' estructuras
' variables privadas
Private m_Name                          As String
Private m_Value                         As String
Private m_Parent                        As String
Private m_BinaryValue                   As Variant

' eventos
' propiedades publicas
Public Property Get BinaryValue() As Variant
   BinaryValue = m_BinaryValue
End Property

Public Property Let BinaryValue(ByVal rhs As Variant)
  Dim vBytes()  As Byte
  Dim vSource() As Byte
  
  If IsEmpty(rhs) Then
    BinaryValue = Empty
  Else
    If Not pIsNullArray(rhs) Then
      ReDim vBytes(UBound(rhs))
      vSource = rhs
      CopyMemory vBytes(0), vSource(0), UBound(vSource) + 1
    Else
      ReDim vBytes(0)
    End If
    m_BinaryValue = vBytes
  End If
End Property

Private Function pIsNullArray(ByVal v As Variant) As Boolean
  On Error Resume Next
  Dim n As Long
  
  Err.Clear
  n = UBound(v)
  
  pIsNullArray = Err.Number <> 0
End Function

Public Property Get Name() As String
   Name = m_Name
End Property

Public Property Let Name(ByVal rhs As String)
   m_Name = rhs
End Property

Public Property Get Value(ByVal ValType As csTypes) As Variant
  Select Case ValType
    Case csTypes.csBoolean
      Select Case m_Value
        Case "True", "Verdadero"
          Value = -1
        Case "False", "Falso"
          Value = 0
        Case Else
          If IsNumeric(m_Value) Then
            Value = CBool(m_Value)
          Else
            Value = 0
          End If
      End Select
    Case csTypes.csDate, csTypes.csDateOrNull, csTypes.csDouble
      If IsDate(m_Value) Then
        Value = m_Value
      Else
        Value = 0
      End If
    Case csTypes.csLong, csTypes.csInteger, csTypes.csId, csTypes.csSingle, csTypes.csCurrency
      If IsNumeric(m_Value) Then
        Value = m_Value
      Else
        Value = 0
      End If
    Case csTypes.csText, csTypes.csVariant, csTypes.csCuit
      Value = m_Value
    Case Else
      Value = m_Value
  End Select
End Property

Public Property Let Value(ByVal ValType As csTypes, ByVal rhs As Variant)
  If VarType(rhs) = vbBoolean Then
    m_Value = IIf(rhs, -1, 0)
  Else
    If IsNull(rhs) Then
      m_Value = Empty
    Else
      m_Value = rhs
    End If
  End If
End Property

Public Property Get Parent() As String
   Parent = m_Parent
End Property

Public Property Let Parent(ByVal rhs As String)
   m_Parent = rhs
End Property

' propiedades privadas
' funciones publicas
' funciones privadas
' construccion - destruccion

'//////////////////////////////
'  Codigo estandar de errores
'  On Error GoTo ControlError
'
'  GoTo ExitProc
'ControlError:
'  MngError "", C_Module, ""
'ExitProc:





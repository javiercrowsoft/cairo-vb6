VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cField"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cField
' 04-01-00

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' FunctionNamees

'--------------------------------------------------------------------------------

' constantes
' estructuras
' variables privadas
Private m_Name            As String
Private m_value             As String
Private m_Type              As csTypes
' propiedades publicas
Public Property Get Name() As String
    Name = m_Name
End Property
Public Property Let Name(ByVal rhs As String)
    m_Name = rhs
End Property
Public Property Get Value() As String
    Select Case m_Type
        Case csInteger, csLong
          If IsNumeric(m_value) Then
            Value = m_value
          Else
            Value = 0
          End If
        Case csBoolean
          Value = IIf(CBool(m_value), 1, 0)
        Case csDouble, csSingle, csCurrency
            Value = GetNumberSql(m_value)
        Case csText
            Value = "'" + Replace(m_value, "'", "''") + "'"
        Case csCuit
            Value = "'" + Replace(m_value, "-", "") + "'"
        Case csVariant
            Value = "'" + m_value + "'"
        Case csDate
            Value = Format(m_value, csSqlDateString)
        Case csDateOrNull
            If Not IsDate(m_value) Then
              Value = "NULL"
            Else
              Value = Format(m_value, csSqlDateString)
            End If
        Case csId
          If m_value = "0" Then
            Value = "NULL"
          Else
            Value = m_value
          End If
    End Select
End Property
Public Property Let Value(ByVal rhs As String)
    m_value = rhs
End Property
Public Property Get VarType() As csTypes
    VarType = m_Type
End Property
Public Property Let VarType(ByVal rhs As csTypes)
    m_Type = rhs
End Property
' propiedades privadas
Private Function GetNumberSql(ByVal Value As String) As String
    If Not IsNumeric(Value) Then
        GetNumberSql = "0"
    Else
        Dim coma As String
        coma = GetSepDecimal
        
        If coma = "," Then
            GetNumberSql = Replace(Replace(Value, ".", ""), ",", ".")
        Else
            GetNumberSql = Replace(Value, ",", "")
        End If
    End If
End Function
' FunctionNamees publicas
' FunctionNamees privadas
' construccion - destruccion


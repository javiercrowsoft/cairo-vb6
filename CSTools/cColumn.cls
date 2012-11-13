VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cColumn"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cColumn
' 15-07-2002

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cColumn"
' estructuras
' variables privadas
Private m_Name                          As String
Private m_SqlType                       As String
Private m_Size                          As String
Private m_AllowNull                     As Boolean
Private m_InPrimaryKey                  As Boolean
Private m_Default                       As String
Private m_DefaultName                   As String
Private m_NumericPresicion              As Long
Private m_NumericScale                  As Long
' eventos
' propiedadades publicas
Public Property Get Name() As String
   Name = m_Name
End Property

Public Property Let Name(ByVal rhs As String)
   m_Name = rhs
End Property

Public Property Get SqlType() As String
   SqlType = m_SqlType
End Property

Public Property Let SqlType(ByVal rhs As String)
   m_SqlType = rhs
End Property

Public Property Get Size() As String
   Size = m_Size
End Property

Public Property Let Size(ByVal rhs As String)
   m_Size = rhs
End Property

Public Property Get Default() As String
   Default = m_Default
End Property

Public Property Let Default(ByVal rhs As String)
   m_Default = rhs
End Property

Public Property Get DefaultName() As String
   DefaultName = m_DefaultName
End Property

Public Property Let DefaultName(ByVal rhs As String)
   m_DefaultName = rhs
End Property

Public Property Get NumericPresicion() As Long
   NumericPresicion = m_NumericPresicion
End Property

Public Property Let NumericPresicion(ByVal rhs As Long)
   m_NumericPresicion = rhs
End Property

Public Property Get NumericScale() As Long
   NumericScale = m_NumericScale
End Property

Public Property Let NumericScale(ByVal rhs As Long)
   m_NumericScale = rhs
End Property

Public Property Get InPrimaryKey() As Boolean
   InPrimaryKey = m_InPrimaryKey
End Property

Public Property Let InPrimaryKey(ByVal rhs As Boolean)
   m_InPrimaryKey = rhs
End Property

Public Property Get AllowNull() As Boolean
   AllowNull = m_AllowNull
End Property

Public Property Let AllowNull(ByVal rhs As Boolean)
   m_AllowNull = rhs
End Property

' propiedadades friend
' propiedades privadas
' funciones publicas
' funciones friend
' funciones privadas
' construccion - destruccion

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



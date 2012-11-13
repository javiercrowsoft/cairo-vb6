VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cCampo"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cCampo
' 06-12-00

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
Private m_Funcion   As String
Private m_Modulo    As String
Private m_Titulo    As String
Private m_Nivel     As csErrorNivel

Private m_Field     As ADODB.Field
' propiedades publicas
Public Property Get Nombre() As String
    Nombre = m_Field.Name
End Property
Public Property Get Valor() As Variant
    Valor = m_Field.Value
End Property
Public Property Let Valor(ByVal rhs As Variant)
    m_Field.Value = rhs
End Property
Public Property Get Tipo() As Integer
    Tipo = m_Field.Type
End Property
Public Property Get Longitud() As Long
    Longitud = m_Field.DefinedSize
End Property
Public Property Get LongitudActual() As Long
    LongitudActual = m_Field.ActualSize
End Property

Public Property Let funcion(ByVal rhs As String)
    m_Funcion = rhs
End Property
Public Property Let Modulo(ByVal rhs As String)
    m_Modulo = rhs
End Property
Public Property Let titulo(ByVal rhs As String)
    m_Titulo = rhs
End Property
Public Property Let nivel(ByVal rhs As csErrorNivel)
    m_Nivel = rhs
End Property

' propiedades Friend
Friend Property Set Field(ByRef rhs As ADODB.Field)
    Set m_Field = rhs
End Property

' propiedades privadas
' funciones publicas
' funciones privadas
' construccion - destruccion

Private Sub Class_Initialize()
' no borrar
End Sub

Private Sub Class_Terminate()
    Set m_Field = Nothing
End Sub

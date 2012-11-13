VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cCampos"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cCampos
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

Private m_Fields    As ADODB.Fields
Private m_Campo     As cCampo
Private m_Coll      As Collection

' propiedades publicas
Public Property Let funcion(ByVal rhs As String)
    m_Funcion = rhs
    m_Campo.funcion = m_Funcion
End Property
Public Property Let Modulo(ByVal rhs As String)
    m_Modulo = rhs
    m_Campo.Modulo = m_Modulo
End Property
Public Property Let titulo(ByVal rhs As String)
    m_Titulo = rhs
    m_Campo.titulo = m_Titulo
End Property
Public Property Let nivel(ByVal rhs As csErrorNivel)
    m_Nivel = rhs
    m_Campo.nivel = m_Nivel
End Property
Public Property Get Cantidad() As Integer
    Cantidad = m_Fields.Count
End Property
Public Property Get Campo(ByVal Index As String) As cCampo
Attribute Campo.VB_UserMemId = 0
    On Error GoTo ControlError
    If IsNumeric(Index) Then
        Set m_Campo.Field = m_Fields(Val(Index))
    Else
        Set m_Campo.Field = m_Fields(Index)
    End If
    
    Set Campo = m_Campo
    Exit Property
ControlError:
    Dim sdescrip As String
    If Err.Number = 448 Then
        sdescrip = "El campo " & Index & " no se encontro en la colección"
    Else
        sdescrip = Err.Description
    End If
    Err.Raise Err.Number, Err.Source, sdescrip, Err.HelpFile, Err.HelpContext
End Property
' propiedades Friend
Friend Property Set Fields(ByRef rhs As ADODB.Fields)
    Set m_Fields = rhs
End Property
' propiedades privadas
' funciones publicas
' funciones friends
' funciones privadas
' construccion - destruccion

Private Sub Class_Initialize()
    Set m_Campo = New cCampo
End Sub

Private Sub Class_Terminate()
    Set m_Fields = Nothing
    Set m_Campo = Nothing
End Sub

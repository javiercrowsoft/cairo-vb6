VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cRegistros"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cRegistros
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
Private m_Recordset As ADODB.Recordset
Private m_Campos    As cCampos

Private m_Funcion   As String
Private m_Modulo    As String
Private m_Titulo    As String
Private m_Nivel     As csErrorNivel

' propiedades publicas
Public Property Get Cantidad() As Long
    Cantidad = m_Recordset.RecordCount
End Property
Public Property Get Campos() As cCampos
Attribute Campos.VB_UserMemId = 0
    Set Campos = m_Campos
End Property
Public Property Get EOF() As Boolean
    EOF = m_Recordset.EOF
End Property
Public Property Get BOF() As Boolean
    BOF = m_Recordset.BOF
End Property
Public Property Get Estado() As csRegistrosEstado
    Estado = m_Recordset.State
End Property

Public Property Let funcion(ByVal rhs As String)
    m_Funcion = rhs
    m_Campos.funcion = m_Funcion
End Property
Public Property Let Modulo(ByVal rhs As String)
    m_Modulo = rhs
    m_Campos.Modulo = m_Modulo
End Property
Public Property Let titulo(ByVal rhs As String)
    m_Titulo = rhs
    m_Campos.titulo = m_Titulo
End Property
Public Property Let nivel(ByVal rhs As csErrorNivel)
    m_Nivel = rhs
    m_Campos.nivel = m_Nivel
End Property ' propiedades privadas
' propiedades Friend
Friend Property Set Recordset(ByRef rhs As ADODB.Recordset)
    Set m_Recordset = rhs
    SetFields
End Property

Friend Property Get Recordset() As ADODB.Recordset
    Set Recordset = m_Recordset
End Property

' funciones publicas
Public Function Siguiente() As Boolean
    On Error GoTo ControlError
    m_Recordset.MoveNext
    Siguiente = SetFields
    Exit Function
ControlError:
    MngError_ Err, m_Funcion, m_Modulo, "", m_Titulo, m_Nivel, csErrorVba
End Function
Public Function Anterior() As Boolean
    On Error GoTo ControlError
    m_Recordset.MovePrevious
    Anterior = SetFields
    Exit Function
ControlError:
    MngError_ Err, m_Funcion, m_Modulo, "", m_Titulo, m_Nivel, csErrorVba
End Function
Public Function Primero() As Boolean
    On Error GoTo ControlError
    m_Recordset.MoveFirst
    Primero = SetFields
    Exit Function
ControlError:
    MngError_ Err, m_Funcion, m_Modulo, "", m_Titulo, m_Nivel, csErrorVba
End Function
Public Function Ultimo() As Boolean
    On Error GoTo ControlError
    m_Recordset.MoveLast
    Ultimo = SetFields
    Exit Function
ControlError:
    MngError_ Err, m_Funcion, m_Modulo, "", m_Titulo, m_Nivel, csErrorVba
End Function
Public Sub Cerrar()
    On Error GoTo ControlError
    If m_Recordset.State = adStateOpen Then m_Recordset.Close
ControlError:
End Sub
Public Function Buscar(ByVal Criterio As String) As Boolean
    On Error GoTo ControlError
    m_Recordset.Find Criterio, 0, adSearchForward
    Buscar = True
    Exit Function
ControlError:
    MngError_ Err, m_Funcion, m_Modulo, "", m_Titulo, m_Nivel, csErrorVba
End Function
Public Function AgregarNuevo() As Boolean
    On Error GoTo ControlError
    m_Recordset.AddNew
    AgregarNuevo = True
    Exit Function
ControlError:
    MngError_ Err, m_Funcion, m_Modulo, "", m_Titulo, m_Nivel, csErrorVba
End Function
Public Function Actualizar() As Boolean
    On Error GoTo ControlError
    m_Recordset.Update
    Actualizar = True
    Exit Function
ControlError:
    MngError_ Err, m_Funcion, m_Modulo, "", m_Titulo, m_Nivel, csErrorVba
End Function
Public Function Borrar() As Boolean
    On Error GoTo ControlError
    m_Recordset.Delete
    Borrar = True
    Exit Function
ControlError:
    MngError_ Err, m_Funcion, m_Modulo, "", m_Titulo, m_Nivel, csErrorVba
End Function
Public Function GetFilas(Optional ByVal rows As Long = -1, Optional ByVal start As Variant, Optional ByVal Fields As Variant) As Variant
  If IsMissing(start) And IsMissing(Fields) Then
    GetFilas = m_Recordset.GetRows(rows)
  ElseIf IsMissing(start) Then
    GetFilas = m_Recordset.GetRows(rows, , Fields)
  ElseIf IsMissing(Fields) Then
    GetFilas = m_Recordset.GetRows(rows, start)
  Else
    GetFilas = m_Recordset.GetRows(rows, start, Fields)
  End If
End Function
' funciones friend
Friend Function SetFields() As Boolean
    On Error GoTo ControlError
    
    Set m_Campos.Fields = m_Recordset.Fields

    SetFields = True
    Exit Function
ControlError:
    MngError_ Err, m_Funcion, m_Modulo, "", m_Titulo, m_Nivel, csErrorVba
End Function
' funciones privadas
' construccion - destruccion

Private Sub Class_Initialize()
    Set m_Campos = New cCampos
End Sub

Private Sub Class_Terminate()
    On Error Resume Next
    If m_Recordset.State = adStateOpen Then m_Recordset.Close
    Set m_Recordset = Nothing
    Set m_Campos = Nothing
End Sub

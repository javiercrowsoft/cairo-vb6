VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cSysModuloTCP"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cSysModuloTCP
' 03-01-04

'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cSysModuloTCP"

' estructuras
' variables privadas

Private m_Objetoinicializacion         As String
Private m_ObjetoEdicion                As String
Private m_Id                           As Long
Private m_Orden                        As Long

' Properties publicas
Public Property Get Objetoinicializacion() As String
  Objetoinicializacion = m_Objetoinicializacion
End Property

Public Property Let Objetoinicializacion(ByVal rhs As String)
  m_Objetoinicializacion = rhs
End Property

Public Property Get ObjetoEdicion() As String
  ObjetoEdicion = m_ObjetoEdicion
End Property

Public Property Let ObjetoEdicion(ByVal rhs As String)
  m_ObjetoEdicion = rhs
End Property

Public Property Get Id() As Long
  Id = m_Id
End Property

Public Property Let Id(ByVal rhs As Long)
  m_Id = rhs
End Property

Public Property Get Orden() As Long
  Orden = m_Orden
End Property

Public Property Let Orden(ByVal rhs As Long)
  m_Orden = rhs
End Property

' Properties privadas
' funciones publicas

' Implementacion de cIABMClient

' Implementacion de cIEditGeneric

Public Function Load(ByVal Id As Long) As Boolean

  If gDB Is Nothing Then Exit Function
  
  Dim sqlstmt As String

  sqlstmt = "select * from sysmoduloTCP where syst_id = " & Id

  Dim rs As Recordset

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "Load", C_Module) Then Exit Function

  If Not rs.EOF Then

    m_Objetoinicializacion = gDB.ValField(rs.Fields, cscSystObjetoinicializacion)
    m_ObjetoEdicion = gDB.ValField(rs.Fields, cscSystObjetoedicion)
    m_Id = gDB.ValField(rs.Fields, cscSystId)
    m_Orden = gDB.ValField(rs.Fields, cscSystOrden)

  Else
    m_Objetoinicializacion = vbNullString
    m_ObjetoEdicion = vbNullString
    m_Id = csNO_ID
    m_Orden = 0

  End If

  Load = True
End Function

' funciones privadas

' construccion - destruccion
Private Sub Class_Terminate()
End Sub

'//////////////////////////////
'  Codigo estandar de errores
'  On Error GoTo ControlError
'
'  GoTo ExitProc
'ControlError:
'  MngError err,"", C_Module, ""
'  If Err.Number Then Resume ExitProc
'ExitProc:
'  On Error Resume Next




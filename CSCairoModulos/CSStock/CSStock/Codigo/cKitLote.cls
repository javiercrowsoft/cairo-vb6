VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cKitLote"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cKitLote
' 15-08-2006

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cKitLote"
' estructuras
' variables privadas
Private m_prk_id            As Long
Private m_pr_id             As Long
Private m_Nombre            As String
Private m_cantidad          As Double
Private m_bVariable         As Boolean
Private m_ta_id             As Long
Private m_bTalEdit          As Boolean

Private m_Items             As cKitLoteNumbers
Private m_Alts              As cKitAlts

' eventos
' propiedades publicas

Public Property Get prk_id() As Long
  prk_id = m_prk_id
End Property
Public Property Let prk_id(ByVal rhs As Long)
  m_prk_id = rhs
End Property

Public Property Get pr_id() As Long
  pr_id = m_pr_id
End Property
Public Property Let pr_id(ByVal rhs As Long)
  m_pr_id = rhs
End Property

Public Property Get Nombre() As String
  Nombre = m_Nombre
End Property
Public Property Let Nombre(ByVal rhs As String)
  m_Nombre = rhs
End Property

Public Property Get Cantidad() As Double
  Cantidad = m_cantidad
End Property
Public Property Let Cantidad(ByVal rhs As Double)
  m_cantidad = rhs
End Property

Public Property Get Variable() As Boolean
  Variable = m_bVariable
End Property
Public Property Let Variable(ByVal rhs As Boolean)
  m_bVariable = rhs
End Property

Public Property Get Items() As cKitLoteNumbers
  Set Items = m_Items
End Property

Public Property Get Alts() As cKitAlts
  Set Alts = m_Alts
End Property

Public Property Get ta_id() As Long
  ta_id = m_ta_id
End Property
Public Property Let ta_id(ByVal rhs As Long)
  m_ta_id = rhs
End Property

Public Property Get bTalEdit() As Boolean
  bTalEdit = m_bTalEdit
End Property
Public Property Let bTalEdit(ByVal rhs As Boolean)
  m_bTalEdit = rhs
End Property

' propiedades friend
' propiedades privadas
' funciones publicas
' funciones friend
' funciones privadas
' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError

  Set m_Items = New cKitLoteNumbers
  Set m_Alts = New cKitAlts
  
  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
  On Error GoTo ControlError

  Set m_Items = Nothing
  Set m_Alts = Nothing
  
  GoTo ExitProc
ControlError:
  MngError Err, "Class_Terminate", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
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
'  If Err.Number Then Resume ExitProc
'ExitProc:
'  On Error Resume Next


VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cGridGroup"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cGridGroup
' 00-11-2002

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cGridGroup"
' estructuras
' variables privadas
Private m_Name                          As String
Private m_Key                           As String
Private m_SortType                      As cShellSortOrderCOnstants
Private m_Index                         As Integer
Private m_GroupsRows                    As cGridGroupRows
Private m_IsSortCol                     As Boolean
' eventos
' propiedades publicas
Public Property Get Name() As String
   Name = m_Name
End Property

Public Property Let Name(ByVal rhs As String)
   m_Name = rhs
End Property

Public Property Get Key() As String
   Key = m_Key
End Property

Public Property Let Key(ByVal rhs As String)
   m_Key = rhs
End Property

Public Property Get SortType() As cShellSortOrderCOnstants
   SortType = m_SortType
End Property

Public Property Let SortType(ByVal rhs As cShellSortOrderCOnstants)
   m_SortType = rhs
End Property

Public Property Get Index() As Integer
   Index = m_Index
End Property

Public Property Let Index(ByVal rhs As Integer)
   m_Index = rhs
End Property

Public Property Get GroupRows() As cGridGroupRows
  Set GroupRows = m_GroupsRows
End Property

Public Property Get IsSortCol() As Boolean
  IsSortCol = m_IsSortCol
End Property

Public Property Let IsSortCol(ByVal rhs As Boolean)
  m_IsSortCol = rhs
End Property

' propiedades friend
Friend Property Set GroupRows(ByRef rhs As cGridGroupRows)
  Set m_GroupsRows = rhs
End Property

' propiedades privadas
' funciones publicas
Public Sub ExpandAll()
  
End Sub
' funciones friend
' funciones privadas
' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  Set m_GroupsRows = New cGridGroupRows

  GoTo ExitProc
ControlError:
  MngError "Class_Initialize", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
  On Error GoTo ControlError
  
  Set m_GroupsRows = Nothing

  GoTo ExitProc
ControlError:
  MngError "Class_Terminate", C_Module, ""
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



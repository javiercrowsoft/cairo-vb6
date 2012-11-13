VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cMenuInfo"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
'--------------------------------------------------------------------------------
' cMenuInfo
' 29-04-2002

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cMenuInfo"
' estructuras
' variables privadas
Private m_Caption                       As String
Private m_IsSeparator                   As Boolean
Private m_HaveSeparator                 As Boolean
Private m_IsPopUpMenu                   As Boolean
Private m_IsMainMenu                    As Boolean
Private m_Father                        As String
Private m_Id                            As Long
Private m_Last                          As Boolean
Private m_Position                      As Long
Private m_ObjMenu                       As cIMenuClient
Private m_Handle                        As Long
Private m_lIconIndex                    As Long
' eventos
' propiedades publicas
Public Property Get Caption() As String
   Caption = m_Caption
End Property

Public Property Let Caption(ByVal rhs As String)
   m_Caption = rhs
End Property

Public Property Get IsSeparator() As Boolean
   IsSeparator = m_IsSeparator
End Property

Public Property Let IsSeparator(ByVal rhs As Boolean)
   m_IsSeparator = rhs
End Property

Public Property Get HaveSeparator() As Boolean
   HaveSeparator = m_HaveSeparator
End Property

Public Property Let HaveSeparator(ByVal rhs As Boolean)
   m_HaveSeparator = rhs
End Property

Public Property Get IsPopUpMenu() As Boolean
   IsPopUpMenu = m_IsPopUpMenu
End Property

Public Property Let IsPopUpMenu(ByVal rhs As Boolean)
   m_IsPopUpMenu = rhs
End Property

Public Property Get IsMainMenu() As Boolean
   IsMainMenu = m_IsMainMenu
End Property

Public Property Let IsMainMenu(ByVal rhs As Boolean)
   m_IsMainMenu = rhs
End Property

Public Property Get Father() As String
   Father = m_Father
End Property

Public Property Let Father(ByVal rhs As String)
   m_Father = rhs
End Property

Public Property Get id() As Long
   id = m_Id
End Property

Public Property Let id(ByVal rhs As Long)
   m_Id = rhs
End Property

Public Property Get Last() As Boolean
   Last = m_Last
End Property

Public Property Let Last(ByVal rhs As Boolean)
   m_Last = rhs
End Property

Public Property Get Position() As Long
   Position = m_Position
End Property

Public Property Let Position(ByVal rhs As Long)
   m_Position = rhs
End Property

Public Property Get ObjMenu() As cIMenuClient
   Set ObjMenu = m_ObjMenu
End Property

Public Property Set ObjMenu(ByRef rhs As cIMenuClient)
   Set m_ObjMenu = rhs
End Property

Public Property Get Handle() As Long
   Handle = m_Handle
End Property

Public Property Let Handle(ByVal rhs As Long)
   m_Handle = rhs
End Property

Public Property Get lIconIndex() As Long
  lIconIndex = m_lIconIndex
End Property

Public Property Let lIconIndex(ByVal rhs As Long)
  m_lIconIndex = rhs
End Property

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


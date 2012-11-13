VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cPermiso"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements cICheckedListItem
'--------------------------------------------------------------------------------
' cPermiso
' 25-07-00

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
Private m_Id                As Long
Private m_PreId             As Long
Private m_RolId             As Long
Private m_UsId              As Long
Private m_Modify            As Long
Private m_LastUpdate        As Date
Private m_Created           As Date
Private m_Granted           As Boolean
Private m_Enabled           As Boolean
Private m_Tag               As String
' Properties publicas
Public Property Get Id() As Long
  Id = m_Id
End Property
Public Property Let Id(ByVal rhs As Long)
  m_Id = rhs
End Property

' Permite al editor de permisos sacar permisos
Public Property Get Granted() As Boolean
  Granted = m_Granted
End Property
Public Property Let Granted(ByVal rhs As Boolean)
  m_Granted = rhs
End Property
Public Property Get PreId() As Long
  PreId = m_PreId
End Property
Public Property Let PreId(ByVal rhs As Long)
  m_PreId = rhs
End Property
Public Property Get RolId() As Long
  RolId = m_RolId
End Property
Public Property Let RolId(ByVal rhs As Long)
  m_RolId = rhs
End Property
Public Property Get UsId() As Long
  UsId = m_UsId
End Property
Public Property Let UsId(ByVal rhs As Long)
  m_UsId = rhs
End Property
Public Property Get Modify() As Long
  Modify = m_Modify
End Property
Public Property Let Modify(ByVal rhs As Long)
  m_Modify = rhs
End Property
Public Property Get LastUpdate() As Date
  LastUpdate = m_LastUpdate
End Property
Public Property Let LastUpdate(ByVal rhs As Date)
  m_LastUpdate = rhs
End Property
Public Property Get Created() As Date
  Created = m_Created
End Property
Public Property Let Created(ByVal rhs As Date)
  m_Created = rhs
End Property
Public Property Get Enabled() As Boolean
  Enabled = m_Enabled
End Property
Public Property Let Enabled(ByVal rhs As Boolean)
  m_Enabled = rhs
End Property
Public Property Let Tag(ByVal rhs As String)
  m_Tag = rhs
End Property
' Propiedades friend
' Propiedades privadas
' funciones publicas

' Implementacion de interfaz
Private Property Get cICheckedListItem_Checked() As Boolean
  cICheckedListItem_Checked = m_Granted
End Property
Private Property Let cICheckedListItem_Checked(ByVal rhs As Boolean)
  m_Granted = rhs
End Property

Private Property Get cICheckedListItem_Enabled() As Boolean
  cICheckedListItem_Enabled = m_Enabled
End Property

Private Property Let cICheckedListItem_Id(ByVal rhs As Long)
  Err.Raise csErrorUsoPropIdEnPermission, "CSOAPI", LNGGetText(3066, vbNullString)
                                                    'El uso de la propiedad cICheckedListItem_Id en la clase cPermiso no esta permitido
End Property

Private Property Get cICheckedListItem_Id() As Long
  cICheckedListItem_Id = m_PreId
End Property

Private Property Get cICheckedListItem_Tag() As String
  cICheckedListItem_Tag = m_Tag
End Property

' funciones privadas
' construccion - destruccion
Private Sub Class_Initialize()

End Sub

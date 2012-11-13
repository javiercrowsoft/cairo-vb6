VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cUsuarioRol"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements cICheckedListItem
'--------------------------------------------------------------------------------
' cUsuarioRol
' 13-01-00

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
  ' constantes
  ' estructuras
  ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const K_NAME        As Integer = 1
Private Const K_ACTIVE      As Integer = 3
' estructuras
' variables privadas
Private m_UsId          As Long
Private m_RolId         As Long
Private m_LastUpdate    As Date
Private m_Created       As Date
Private m_Modify        As Long

Private m_Granted       As Boolean

Private m_WhoOwnsThis As csPermissionType

' Properties publicas
Public Property Get UsId() As Long
  UsId = m_UsId
End Property
Public Property Let UsId(ByVal rhs As Long)
  m_UsId = rhs
End Property
Public Property Get RolId() As Long
  RolId = m_RolId
End Property
Public Property Let RolId(ByVal rhs As Long)
  m_RolId = rhs
End Property
Public Property Get WhoOwnsThis() As csPermissionType
  WhoOwnsThis = m_WhoOwnsThis
End Property
Public Property Let WhoOwnsThis(ByVal rhs As csPermissionType)
  m_WhoOwnsThis = rhs
End Property

' Permite al editor de permisos sacar permisos
Public Property Get Granted() As Boolean
  Granted = m_Granted
End Property
Public Property Let Granted(ByVal rhs As Boolean)
  m_Granted = rhs
End Property

Public Property Get LastUpdate() As Date
  LastUpdate = m_LastUpdate
End Property
Public Property Get Modify() As Long
  Modify = m_Modify
End Property
Public Property Get Created() As Date
  Created = m_Created
End Property
' Properties privadas
' funciones publicas
' Implementacion de interfaz
Private Property Get cICheckedListItem_Checked() As Boolean
  cICheckedListItem_Checked = m_Granted
End Property

Private Property Let cICheckedListItem_Checked(ByVal rhs As Boolean)
  m_Granted = rhs
End Property

Private Property Get cICheckedListItem_Enabled() As Boolean
  cICheckedListItem_Enabled = True
End Property

Private Property Get cICheckedListItem_Tag() As String

End Property

Private Property Let cICheckedListItem_Id(ByVal rhs As Long)
  Err.Raise csErrorUsoPropIdEnRol, "CSOAPI", LNGGetText(2814, vbNullString)
                                            'El uso de la propiedad cICheckedListItem_UsId en la clase cUsuarioRol no esta permitido
End Property

Private Property Get cICheckedListItem_Id() As Long
  If m_WhoOwnsThis = csTPUser Then
    cICheckedListItem_Id = m_RolId
  Else
    cICheckedListItem_Id = m_UsId
  End If
End Property
' Funciones de grabación
' funciones privadas
' construccion - destruccion

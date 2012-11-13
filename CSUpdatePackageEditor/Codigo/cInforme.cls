VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cInforme"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
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
Private m_InfId             As Long
Private m_Granted           As Boolean
Private m_Enabled           As Boolean
Private m_Tag               As String
' Properties publicas

' Permite al editor de permisos sacar permisos
Public Property Get Granted() As Boolean
  Granted = m_Granted
End Property
Public Property Let Granted(ByVal rhs As Boolean)
  m_Granted = rhs
End Property
Public Property Get InfId() As Long
  InfId = m_InfId
End Property
Public Property Let InfId(ByVal rhs As Long)
  m_InfId = rhs
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
  Err.Raise csErrorUsoPropIdEnPermission, "CSOAPI", LNGGetText(3467, vbNullString)
                                                  'El uso de la propiedad cICheckedListItem_Id en la clase cPermiso no esta permitido
End Property

Private Property Get cICheckedListItem_Id() As Long
  cICheckedListItem_Id = m_InfId
End Property

Private Property Get cICheckedListItem_Tag() As String
  cICheckedListItem_Tag = m_Tag
End Property

' funciones privadas
' construccion - destruccion


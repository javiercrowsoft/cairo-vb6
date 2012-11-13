VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cProductoSerieType"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cProductoSerieType
' 19-06-2004

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cProductoSerieType"
' estructuras
' variables privadas
Private m_prns_id                       As Long
Private m_pr_id                         As Long
Private m_Codigo                        As String
Private m_Codigo2                       As String
Private m_Codigo3                       As String
Private m_Descrip                       As String
Private m_FechaVto                      As Date
Private m_pr_id_item                    As Long
Private m_KitItem                       As String
Private m_pr_id_kit                     As Long
Private m_IdGroup                       As Long
Private m_Deleted                       As Boolean ' Permite saber si este
                                                   ' numero de serie debe ser
                                                   ' borrado de la base por
                                                   ' cambio en las cantidades
                                                   ' de un renglon de remito de
                                                   ' compra o factura de compra
' eventos
' propiedades publicas
Public Property Get prns_id() As Long
  prns_id = m_prns_id
End Property

Public Property Let prns_id(ByVal rhs As Long)
  m_prns_id = rhs
End Property

Public Property Get Codigo() As String
  Codigo = m_Codigo
End Property

Public Property Let Codigo(ByVal rhs As String)
  m_Codigo = rhs
End Property

Public Property Get Codigo2() As String
  Codigo2 = m_Codigo2
End Property

Public Property Let Codigo2(ByVal rhs As String)
  m_Codigo2 = rhs
End Property

Public Property Get Codigo3() As String
  Codigo3 = m_Codigo3
End Property

Public Property Let Codigo3(ByVal rhs As String)
  m_Codigo3 = rhs
End Property

Public Property Get Descrip() As String
  Descrip = m_Descrip
End Property

Public Property Let Descrip(ByVal rhs As String)
  m_Descrip = rhs
End Property

Public Property Get FechaVto() As Date
  FechaVto = m_FechaVto
End Property

Public Property Let FechaVto(ByVal rhs As Date)
  m_FechaVto = rhs
End Property

Public Property Get pr_id() As Long
  pr_id = m_pr_id
End Property

Public Property Let pr_id(ByVal rhs As Long)
  m_pr_id = rhs
End Property

Public Property Get pr_id_item() As Long
  pr_id_item = m_pr_id_item
End Property

Public Property Let pr_id_item(ByVal rhs As Long)
  m_pr_id_item = rhs
End Property

Public Property Get KitItem() As String
  KitItem = m_KitItem
End Property

Public Property Let KitItem(ByVal rhs As String)
  m_KitItem = rhs
End Property

Public Property Get IdGroup() As Long
  IdGroup = m_IdGroup
End Property

Public Property Let IdGroup(ByVal rhs As Long)
  m_IdGroup = rhs
End Property

Public Property Get pr_id_kit() As Long
  pr_id_kit = m_pr_id_kit
End Property

Public Property Let pr_id_kit(ByVal rhs As Long)
  m_pr_id_kit = rhs
End Property

Public Property Get Deleted() As Boolean
  Deleted = m_Deleted
End Property

Public Property Let Deleted(ByVal rhs As Boolean)
  m_Deleted = rhs
End Property
' propiedades friend
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
'  If Err.Number Then Resume ExitProc
'ExitProc:
'  On Error Resume Next

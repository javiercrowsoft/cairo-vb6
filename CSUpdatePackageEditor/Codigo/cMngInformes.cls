VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cMngInformes"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' cMngInformes
' 27-01-01

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
  ' constantes
  ' estructuras
  ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cMngInformes"
' estructuras
' variables privadas
Private m_Id           As Long

Private m_Informes     As cInformes

' eventos
' Properties publicas
Public Property Get Informes() As cInformes
  Set Informes = m_Informes
End Property

Public Property Set Informes(ByVal rhs As cInformes)
  Set m_Informes = rhs
End Property

' Properties privadas
' funciones publicas
Public Function Load() As Boolean
  m_Informes.IsLoaded = False
  Load = m_Informes.Load()
End Function

Public Sub SetBranchChecked(ByRef collBranchs As Collection)

End Sub

Public Sub CreateTree()

End Sub

' funciones privadas
' construccion - destruccion

Private Sub Class_Initialize()
  Set m_Informes = New cInformes
End Sub

Private Sub Class_Terminate()
  Set m_Informes = Nothing
End Sub

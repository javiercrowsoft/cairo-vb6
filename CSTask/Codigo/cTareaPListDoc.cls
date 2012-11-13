VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cTareaPListDoc"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGenericListDoc
Implements CSInterfacesABM.cIABMListDocClient

'--------------------------------------------------------------------------------
' cTareaPListDoc
' 20-11-06

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
  ' constantes
  ' estructuras
  ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cTareaPListDoc"

' estructuras
' variables privadas
Private m_TareaListDoc        As cTareaListDoc
Private m_ABMTareaListDoc     As cIABMListDocClient
Private m_EDITTareaListDoc    As cIEditGenericListDoc

' propiedades publicas
' propiedades privadas
' funciones publicas

'-------------------------------------------------------------------------------------
' Interfaz cliente de List de documentos

Private Property Get cIABMListDocClient_Aplication() As String
  cIABMListDocClient_Aplication = gAppName
End Property

Private Sub cIABMListDocClient_DiscardChanges()
  m_TareaListDoc.LoadCollection
End Sub

Private Function cIABMListDocClient_ListAdHock(List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMListDocClient_Load()

End Sub

Private Property Get cIABMListDocClient_Properties() As Object
  Set cIABMListDocClient_Properties = m_ABMTareaListDoc.Properties
End Property

Private Function cIABMListDocClient_PropertyChange(ByVal Key As Integer) As Boolean
  cIABMListDocClient_PropertyChange = m_ABMTareaListDoc.PropertyChange(Key)
End Function

Private Function cIABMListDocClient_Refresh() As String
  cIABMListDocClient_Refresh = m_ABMTareaListDoc.Refresh()
End Function

Private Function cIABMListDocClient_Save() As Boolean
  cIABMListDocClient_Save = m_ABMTareaListDoc.Save()
End Function

Private Function cIABMListDocClient_Terminate() As Boolean
  cIABMListDocClient_Terminate = m_ABMTareaListDoc.Terminate()
End Function

Private Property Get cIABMListDocClient_Title() As String
  cIABMListDocClient_Title = m_ABMTareaListDoc.Title
End Property

Private Function cIABMListDocClient_Validate() As Boolean
  cIABMListDocClient_Validate = m_ABMTareaListDoc.Validate()
End Function

'-------------------------------------------------------------------------------------
' Implementacion de cIEditGeneric
Private Function cIEditGenericListDoc_GridAdd(ByVal ClavePropiedad As Integer) As Boolean

End Function

Private Function cIEditGenericListDoc_GridEdit(ByVal ClavePropiedad As Integer) As Boolean

End Function

Private Function cIEditGenericListDoc_GridRemove(ByVal ClavePropiedad As Integer) As Boolean

End Function

Private Property Set cIEditGenericListDoc_ObjAbm(rhs As CSInterfacesABM.cIABMGenericListDoc)
  Set m_EDITTareaListDoc.ObjABM = rhs
End Property

Private Function cIEditGenericListDoc_ShowParams(ByVal Us_id As Long) As Boolean
  cIEditGenericListDoc_ShowParams = m_EDITTareaListDoc.ShowParams(Us_id)
End Function

Private Property Set cIEditGenericListDoc_ObjList(rhs As Object)
  Set m_EDITTareaListDoc.ObjList = rhs
End Property

Private Function cIEditGenericListDoc_PropertyChange(ByVal Clave As Integer) As Boolean

End Function

Private Function cIEditGenericListDoc_TabClick(ByVal Index As Integer) As Boolean

End Function

' funciones privadas
' construccion - destruccion

Private Sub Class_Initialize()
  On Error GoTo ControlError
 
  Set m_TareaListDoc = New cTareaListDoc
  Set m_ABMTareaListDoc = m_TareaListDoc
  Set m_EDITTareaListDoc = m_TareaListDoc
  m_TareaListDoc.Plantillas = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "Class_Terminate", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
  On Error GoTo ControlError
  
  Set m_TareaListDoc = Nothing
  Set m_ABMTareaListDoc = Nothing
  Set m_EDITTareaListDoc = Nothing

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

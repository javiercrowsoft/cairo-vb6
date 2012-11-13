VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cReportConnectsAux"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cReportConnectsAux
' cReportConnect
' 15-10-2003

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cReportConnectsAux"
Private Const c_RptConnectsAux = "RptConnectsAux"
' estructuras
' variables privadas
Private m_Coll As Collection
' propiedades publicas
' propiedades privadas
' funciones friend
#If Not PREPROC_SFS Then
  Friend Function Save(ByRef xDoc As CSXml2.cXml, ByRef NodeFather As Object) As Boolean
    Dim Connect As cReportConnect
    
    If NodeFather Is Nothing Then
    
      Dim xProperty As CSXml2.cXmlProperty
      Set xProperty = New CSXml2.cXmlProperty
      xProperty.Name = c_RptConnectsAux
      
      Set NodeFather = xDoc.AddNode(xProperty)
    End If
    
    For Each Connect In m_Coll
      If Not Connect.Save(xDoc, NodeFather) Then Exit Function
    Next
    
    Save = True
  End Function
#End If

Friend Function Load(ByRef xDoc As CSXml2.cXml, ByRef NodeFather As Object)
  Dim NodObj As Object
  
  CollClear m_Coll
  
  If Not NodeFather Is Nothing Then
  
    If xDoc.NodeHasChild(NodeFather) Then
      Set NodObj = xDoc.GetNodeChild(NodeFather)
      While Not NodObj Is Nothing
        If Not Add(Nothing).Load(xDoc, NodObj) Then Exit Function
        Set NodObj = xDoc.GetNextNode(NodObj)
      Wend
    End If
  End If
  
  Load = True
End Function
' funciones publicas
Public Function Add(ByVal c As cReportConnect, Optional Key As Variant) As cReportConnect
    On Error GoTo ControlError

    If c Is Nothing Then Set c = New cReportConnect

    If IsMissing(Key) Then
        m_Coll.Add c
    Else
        m_Coll.Add c, GetKey(Key)
    End If

    Set Add = c
    Exit Function
ControlError:
    Set Add = Nothing
End Function

Public Sub Clear()
    CollClear m_Coll
End Sub

Public Sub Remove(ByVal kItem As Variant)
    On Error GoTo ControlError
    m_Coll.Remove kItem
    Exit Sub
ControlError:
End Sub

Public Function Count() As Long
    On Error GoTo ControlError
    Count = m_Coll.Count
    Exit Function
ControlError:
    Count = 0
End Function

Public Function Item(ByVal kItem As Variant) As cReportConnect
Attribute Item.VB_UserMemId = 0
    On Error GoTo ControlError
    Set Item = m_Coll(kItem)
    Exit Function
ControlError:
End Function

Public Function NewEnum() As IUnknown
Attribute NewEnum.VB_UserMemId = -4
    Set NewEnum = m_Coll.[_NewEnum]
End Function

' funciones privadas

' construccion - destruccion
Private Sub Class_Initialize()
    Set m_Coll = New Collection
End Sub

Private Sub Class_Terminate()
    CollClear m_Coll
    Set m_Coll = Nothing
End Sub


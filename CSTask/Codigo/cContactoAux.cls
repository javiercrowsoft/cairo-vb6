VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cContactoAux"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIABMClient
'--------------------------------------------------------------------------------
' cContactoAux
' 29-04-02

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
  ' constantes
  ' estructuras
  ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cContactoAux"

Private Const K_AGN_ID             As Integer = 12
' estructuras
' variables privadas
Private m_agn_id             As Long
Private m_Agenda             As String

Private m_ObjAbm             As cIABMGeneric

' propiedades publicas
' propiedades privadas
' funciones publicas

Public Function GetAgenda() As Long
  Set m_ObjAbm = CSKernelClient2.CreateObject("CSABMInterface2.cABMGeneric")
  m_ObjAbm.InModalWindow = True
  LoadCollection
  GetAgenda = m_agn_id
End Function

' Implementacion de cIABMClient
Private Function cIABMClient_Copy() As Boolean
End Function

Private Function cIABMClient_EditNew() As Boolean
End Function

Private Property Get cIABMClient_Aplication() As String
  cIABMClient_Aplication = gAppName
End Property

Private Property Get cIABMClient_CanAddDocDigital() As Boolean
  cIABMClient_CanAddDocDigital = False
End Property

Private Property Get cIABMClient_CanCopy() As Boolean
  cIABMClient_CanCopy = False
End Property

Private Property Get cIABMClient_CanNew() As Boolean
  cIABMClient_CanNew = False
End Property

Private Function cIABMClient_ShowDocDigital() As Boolean
End Function

Private Function cIABMClient_MessageEx(ByVal MessageID As Long, ByVal Info As Variant) As Variant
  cIABMClient_MessageEx = True
End Function

Private Sub cIABMClient_DiscardChanges()
  LoadCollection
End Sub

Private Function cIABMClient_ListAdHock(List As CSInterfacesABM.cIABMList) As Boolean
End Function

Private Sub cIABMClient_Load()
End Sub

Private Function cIABMClient_PropertyChange(ByVal Clave As Integer) As Boolean
End Function

Private Function cIABMClient_Save() As Boolean
  
  With m_ObjAbm.Properties.Item(cscAgnId)
    m_agn_id = .HelpId
    m_Agenda = .Value
  End With
  
  cIABMClient_Save = True
End Function

Private Function cIABMClient_Terminate() As Boolean
  cIABMClient_Terminate = True
End Function

Private Property Get cIABMClient_Title() As String
  cIABMClient_Title = LNGGetText(2636, vbNullString)  'Contactos
End Property

Private Function cIABMClient_Validate() As Boolean
  Dim IProperty As cIABMProperty

  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_AGN_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(2637, vbNullString)  'Debe indicar una agenda
            Exit Function
          End If
      End Select
    End With
  Next

  cIABMClient_Validate = True
End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  Dim c As cIABMProperty
  Dim AbmObj As cABMGeneric
  
  m_ObjAbm.Properties.Clear
  Set AbmObj = m_ObjAbm
  AbmObj.bDontAskForSave = True
  AbmObj.OkCancelDialog = True

'  With m_ObjAbm.ObjForm
'    .cmdSave.Caption = "&Aceptar"
'    .cmdClose.Caption = "&Cancelar"
'    .cmdCancel.Visible = False
'  End With
  
  Set c = m_ObjAbm.Properties.Add(Nothing)
  c.PropertyType = cspLabel
  c.Value = LNGGetText(2642, vbNullString)  'Debe indicar que Agenda desea editar
  c.Width = 6000
  c.FontBold = True

  Set c = m_ObjAbm.Properties.Add(Nothing, cscAgnId)
  c.PropertyType = cspHelp
  c.Table = csAgenda
  c.Name = LNGGetText(2638, vbNullString)  'Agenda
  c.Key = K_AGN_ID
  c.Value = m_Agenda
  c.HelpId = m_agn_id
  c.HelpFilter = pGetFilter() '"exists(select per_id from permiso where pre_id = pre_id_listar and (us_id = " & User.Id & " or exists(select rol_id from usuariorol where us_id = permiso.us_id)))"
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

Private Function pGetFilter() As String
  pGetFilter = "((exists(select * from Permiso where pre_id = Agenda.pre_id_propietario and us_id = " & User.Id & "))" _
             & "or (exists(select * from Permiso where pre_id = Agenda.pre_id_propietario and exists " _
             & "(select * from UsuarioRol where rol_id = Permiso.rol_id and us_id = " & User.Id & "))))"
              
End Function

' construccion - destruccion

Private Sub Class_Initialize()
'
End Sub

Private Sub Class_Terminate()
  Set m_ObjAbm = Nothing
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

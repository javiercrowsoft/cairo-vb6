VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cImport"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIABMClient
Implements CSMenu.cIMenuClient
'--------------------------------------------------------------------------------
' cImport
' 27-06-04

'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cImport"

Private Const K_IMPP_ID                      As Integer = 1

' estructuras
' variables privadas

'OJO HASTA ACA

Private m_Editing           As Boolean
Private m_ObjAbm            As cIABMGeneric
Private m_Host              As CSMenu.cIMenuHost

Private m_impp_id             As Long
Private m_ImportacionProceso  As String
' Properties publicas
' Properties privadas
' funciones publicas

' Implementacion de cIABMClient
Private Property Get cIABMClient_Aplication() As String
  cIABMClient_Aplication = gAppName
End Property

Private Property Get cIABMClient_CanAddDocDigital() As Boolean
End Property

Private Property Get cIABMClient_CanCopy() As Boolean
End Property

Private Property Get cIABMClient_CanNew() As Boolean
End Property

Private Function cIABMClient_EditNew() As Boolean
End Function

Private Function cIABMClient_ShowDocDigital() As Boolean
End Function

Private Function cIABMClient_MessageEx(ByVal MessageID As Long, ByVal Info As Variant) As Variant
  cIABMClient_MessageEx = True
End Function

Private Sub cIABMClient_DiscardChanges()
  LoadCollection
End Sub

Private Function cIABMClient_Copy() As Boolean
End Function

Private Function cIABMClient_ListAdHock(List As CSInterfacesABM.cIABMList) As Boolean
End Function

Private Sub cIABMClient_Load()
End Sub

Private Function cIABMClient_PropertyChange(ByVal Key As Integer) As Boolean
End Function

Private Function cIABMClient_Save() As Boolean
  pImport
  cIABMClient_Save = True
End Function

Private Function cIABMClient_Terminate() As Boolean
  m_Editing = False
  cIABMClient_Terminate = True
End Function

Private Property Get cIABMClient_Title() As String
  cIABMClient_Title = LNGGetText(3333, vbNullString) 'Proceso de Importación
End Property

Private Function cIABMClient_Validate() As Boolean
  Dim IProperty As cIABMProperty

  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_IMPP_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(3334, vbNullString) 'Debe indicar un proceso de Importación
            Exit Function
          End If
      End Select
    End With
  Next

  cIABMClient_Validate = True
End Function

' Implementacion de cIMenuClient
Private Function cIMenuClient_Initialize(f As Object, Host As CSMenu.cIMenuHost) As Boolean
  On Error GoTo ControlError
  Dim str_3335  As String
  
  str_3335 = LNGGetText(3335, vbNullString) 'Impor&tación
  
  Set m_Host = Host
  m_Host.Server.AddMenu str_3335, csMenuEnum.csMenuImport, vbNullString, 1, False, False, False, True, False, Nothing
  m_Host.Server.AddMenu LNGGetText(3336, vbNullString), csPreImporExecImport, str_3335, 0, True, False, False, False, False, Me
                        '&Ejecutar Importación
  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, "cIMenuClient_Initialize", C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal ID As Long) As Variant
  pEdit
End Function

' funciones privadas
Private Sub pEdit()
  On Error GoTo ControlError
  
  Set m_ObjAbm = New cABMGeneric
  
  If Not SecurityCanAccess(csPreImporExecImport) Then Exit Sub

  If Not LoadCollection() Then Exit Sub
  
  m_Editing = True
  
  Exit Sub
ControlError:
  MngError Err, "pEdit", "cCompraConfig", vbNullString
End Sub

Private Sub pImport()
  On Error GoTo ControlError
  
  Dim Mouse As cMouse
  Set Mouse = New cMouse
  
  Mouse.MouseSet vbArrowHourglass

  Dim oImport As cImportForm
  Set oImport = New cImportForm
  
  With m_ObjAbm.Properties.Item(cscImppId)
    m_impp_id = .HelpId
    m_ImportacionProceso = .Value
  End With
  
  oImport.RunImport m_impp_id

  Exit Sub
ControlError:
  MngError Err, "pEdit", "cCompraConfig", vbNullString
End Sub

Private Function LoadCollection() As Boolean
  
  With m_ObjAbm.Properties
    
    .Clear

    With .Add(Nothing, cscImppId)
      .PropertyType = cspHelp
      .Table = csImportacionProceso
      .Name = LNGGetText(3333, vbNullString) 'Proceso de Importación
      .Width = 6000
      .Key = K_IMPP_ID
      .HelpId = m_impp_id
      .Value = m_ImportacionProceso
    End With

  End With
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  
  AbmObj.Frm.cmdsave.Caption = LNGGetText(3337, vbNullString) '&Importar
  AbmObj.Frm.cmdCancel.Visible = False
  
  m_ObjAbm.InModalWindow = True
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function
' construccion - destruccion

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
'  If Err.Number <> 0 Then Resume ExitProc
'ExitProc:
'  On Error Resume Next

VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Object = "{AAE806BF-0AA4-415D-8EAA-4F0A32FF6B71}#1.2#0"; "CSControls2.ocx"
Begin VB.Form fListDoc 
   Caption         =   "Listado"
   ClientHeight    =   7845
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   8850
   ControlBox      =   0   'False
   Icon            =   "fListDoc.frx":0000
   KeyPreview      =   -1  'True
   LinkTopic       =   "Form1"
   MDIChild        =   -1  'True
   ScaleHeight     =   7845
   ScaleWidth      =   8850
   Begin VB.Timer tmResize 
      Left            =   7620
      Top             =   7200
   End
   Begin MSComctlLib.Toolbar tbrTool 
      Align           =   1  'Align Top
      Height          =   630
      Left            =   0
      TabIndex        =   1
      Top             =   0
      Width           =   8850
      _ExtentX        =   15610
      _ExtentY        =   1111
      ButtonWidth     =   609
      ButtonHeight    =   953
      Appearance      =   1
      _Version        =   393216
   End
   Begin CSControls2.cListDoc cListDoc1 
      Height          =   5415
      Left            =   360
      TabIndex        =   0
      Top             =   1320
      Width           =   7575
      _ExtentX        =   13361
      _ExtentY        =   9551
      HelpType        =   2
   End
End
Attribute VB_Name = "fListDoc"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
'--------------------------------------------------------------------------------
' fListDoc
' 23-03-02

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "fListDoc"
' estructuras
' variables privadas
Private m_Name              As String
Private m_Buttons1          As Long
Private m_Buttons2          As Long
Private m_Buttons3          As Long
Private m_IconText          As Integer

Private m_ObjEditName       As String
Private m_ObjABMName        As String

Private m_ObjListNombre     As String
Private m_ObjListABMNombre  As String

Private m_ListObject        As cIEditGenericListDoc
Private m_done              As Boolean

Private m_AuxParam          As String

Private m_Initiated         As Boolean

' Preferencias del Usuario
'
Private m_UserCfg           As cUsuarioConfig

' propiedades privadas
Private Property Get ObjEdit() As cIEditGeneric
  On Error GoTo ControlError
  
  Set ObjEdit = GetObjectEdit
  Exit Property
ControlError:
  MngError Err, "ObjEdit", "fListDoc", ""
End Property

' propiedades publicas
Public Property Let AuxParam(ByVal rhs As String)
  m_AuxParam = rhs
End Property

Public Property Get ObjEditName() As String
  ObjEditName = m_ObjEditName
End Property
Public Property Let ObjEditName(ByVal rhs As String)
  m_ObjEditName = rhs
End Property

Public Property Get ObjListNombre() As String
  ObjListNombre = m_ObjListNombre
End Property
Public Property Let ObjListNombre(ByVal rhs As String)
  m_ObjListNombre = rhs
End Property

Public Property Get ObjListABMNombre() As String
  ObjListABMNombre = m_ObjListABMNombre
End Property
Public Property Let ObjListABMNombre(ByVal rhs As String)
  m_ObjListABMNombre = rhs
End Property

Public Property Get ObjABMName() As String
  ObjABMName = m_ObjABMName
End Property
Public Property Let ObjABMName(ByVal rhs As String)
  m_ObjABMName = rhs
End Property

Public Property Get NameEdit() As String
  NameEdit = m_Name
End Property
Public Property Let NameEdit(ByVal rhs As String)
  m_Name = rhs
End Property
Public Property Get Buttons1() As Long
  Buttons1 = m_Buttons1
End Property
Public Property Let Buttons1(ByVal rhs As Long)
  m_Buttons1 = rhs
End Property
Public Property Get Buttons2() As Long
  Buttons2 = m_Buttons2
End Property
Public Property Let Buttons2(ByVal rhs As Long)
  m_Buttons2 = rhs
End Property
Public Property Get Buttons3() As Long
  Buttons3 = m_Buttons3
End Property
Public Property Let Buttons3(ByVal rhs As Long)
  m_Buttons3 = rhs
End Property
Public Property Get IconPersona() As Integer
  IconPersona = csIMG_PERSON
End Property
Public Property Get IconRoles() As Integer
  IconRoles = csIMG_ROLS
End Property
Public Property Get IconCubo() As Integer
  IconCubo = csIMG_REDCUBE
End Property
Public Property Get IconText() As Integer
  IconText = m_IconText
End Property
Public Property Let IconText(ByVal rhs As Integer)
  m_IconText = rhs
End Property
' propiedades privadas
' funciones publicas
Public Function Init() As Boolean
  
  Caption = m_Name
  cListDoc1.NameClient = m_Name
  
  If Not m_Initiated Then
  
    cListDoc1.Buttons1 = m_Buttons1
    cListDoc1.Buttons2 = m_Buttons2
    cListDoc1.Buttons3 = m_Buttons3
    pSetToolBar
    cListDoc1.SetToolBar
    cListDoc1.IconText = m_IconText
    
  End If
  
  m_Initiated = True
  Init = True
End Function

Public Sub ShowParameters()
  On Error Resume Next
  
  Me.cListDoc1.ShowParameters
  pShowParams
  
End Sub

Private Sub pShowParams()
  CSKernelClient2.ShowToolBarButton BUTTON_WITH_PARAMS, tbrTool, False
  CSKernelClient2.ShowToolBarButton BUTTON_WITHOUT_PARAMS, tbrTool, True
End Sub

Private Sub pHideParams()
  CSKernelClient2.ShowToolBarButton BUTTON_WITH_PARAMS, tbrTool, True
  CSKernelClient2.ShowToolBarButton BUTTON_WITHOUT_PARAMS, tbrTool, False
End Sub

Public Sub HideParameters()
  On Error Resume Next
  
  Me.cListDoc1.HideParameters
  pHideParams
  
End Sub

' funciones privadas
Private Sub pSetToolBar()
  Buttons1 = Buttons1 + BUTTON_WITHOUT_PARAMS
  Buttons1 = Buttons1 + BUTTON_WITH_PARAMS
  Buttons1 = Buttons1 + BUTTON_UPDATE
  
  'Buttons2 = Buttons2 + BUTTON_SAVE_PARAMS
  'Buttons2 = Buttons2 + BUTTON_RELOAD_PARAMS
  
  'CSKernelClient2.SetToolBar24 tbrTool, Buttons1, Buttons2, Buttons3, m_UserCfg.ViewNamesInToolbar, True
  CSKernelClient2.SetToolBar tbrTool, Buttons1, Buttons2, Buttons3
  
  DoEvents
  
  Form_Resize
End Sub

Private Function GetObjectEdit() As cIEditGeneric
  Dim obj As Object
  Dim o   As cIEditGeneric

  Set obj = CSKernelClient2.CreateObject(m_ObjEditName)
  
  If LenB(m_AuxParam) Then
    obj.AuxParam = m_AuxParam
  End If
  
  Set o = obj
  Set o.ObjTree = cListDoc1
  
  Dim Editor As cIABMGeneric
  Set Editor = CSKernelClient2.CreateObject(m_ObjABMName)
  Set o.ObjAbm = Editor

  pSetGenericDoc o

  Set GetObjectEdit = o
End Function

Private Sub pSetGenericDoc(ByRef o As Object)
  Dim oDoc As cIEditGenericDoc
  If TypeOf o Is cIEditGenericDoc Then
    Set oDoc = o
    Set oDoc.Footer = CSKernelClient2.CreateObject(m_ObjABMName)
    Set oDoc.Items = CSKernelClient2.CreateObject(m_ObjABMName)
  End If
End Sub

Private Sub cListDoc1_DblClick()
  On Error GoTo ControlError
  
  With cListDoc1
    If .RowIsGroup(.SelectedRow) Then Exit Sub
  End With
  
  Dim Mouse As cMouseWait
  Dim o As cIEditGeneric

  Set Mouse = New cMouseWait
  Set o = ObjEdit
  o.Edit cListDoc1.Id

  Exit Sub
ControlError:
  MngError Err, "cListDoc1_ToolBarClick", "fListDoc", ""
End Sub

Private Sub cListDoc1_HideParams()
  On Error Resume Next
  HideParameters
End Sub

Private Sub Form_KeyDown(KeyCode As Integer, Shift As Integer)
  ProcessVirtualKey KeyCode, Shift, Me
End Sub

Private Sub Form_Activate()
  ActiveBar Me
  
  If m_done Then Exit Sub
  m_done = True
  
  If cListDoc1.ParamVisible Then
    pShowParams
  Else
    pHideParams
  End If
End Sub

Private Sub Form_Deactivate()
  DeactiveBar Me
End Sub

Private Sub Form_Load()
  On Error GoTo ControlError

  Dim Editor As cIABMGenericListDoc
  Dim o As cIEditGenericListDoc
  
  Set o = CSKernelClient2.CreateObject(m_ObjListNombre)
  Set Editor = CSKernelClient2.CreateObject(m_ObjListABMNombre)
  Set o.ObjAbm = Editor
  Set o.ObjList = cListDoc1
  o.ShowParams User.Id
  
  Set m_ListObject = o
  
  Set o = Nothing
  Set Editor = Nothing
  
  m_done = False
  
  On Error Resume Next
  Me.WindowState = vbMaximized
  
  ' Preferencias del Usuario
  '
  Set m_UserCfg = New cUsuarioConfig
  m_UserCfg.Load
  
  Exit Sub
ControlError:
  MngError Err, "Form_Load", "fListDoc", ""
End Sub

Private Sub tbrTool_ButtonClick(ByVal Button As MSComctlLib.Button)
  On Error Resume Next
  CSKernelClient2.PresButtonToolbar Button.Key, Me
End Sub

Private Sub Form_Resize()
  On Error Resume Next
  
  Dim tbHeight As Integer
  tbHeight = tbrTool.Height + 60
  
  If tbHeight > 900 Then
    tmResize.Interval = 1000
  Else
    pResize
  End If
End Sub

Private Sub pResize()
  Dim tbHeight As Integer
  tbHeight = tbrTool.Height + 60
  
  cListDoc1.Move 0, tbHeight, ScaleWidth, ScaleHeight - tbHeight
End Sub

Private Function pAskDelete(ByVal msg As String) As Boolean
  pAskDelete = Ask(msg, vbYes, "Borrar")
End Function

' construccion - destruccion
Private Sub Form_Unload(Cancel As Integer)
  On Error Resume Next
  
  Set m_ListObject.ObjAbm = Nothing
  Set m_ListObject = Nothing
  
  ' Preferencias del Usuario
  '
  Set m_UserCfg = Nothing
  
  cListDoc1.SavePreference WindowState
  CSKernelClient2.UnloadForm Me, m_Name
  DeactiveBar Me
  fMain.RefreshTabs

  m_Initiated = False

End Sub

'---------------------------------------------------------------
' Manejo de la barra de herramientas
'---------------------------------------------------------------
Public Sub Edit()
  Dim Mouse As cMouseWait
  Set Mouse = New cMouseWait
  ObjEdit.Edit cListDoc1.Id
End Sub

Public Sub PrintObj()
  Dim PrintManager As CSPrintManager2.cPrintManager
  Dim iDoc         As CSIDocumento.cIDocumento
  
  Set PrintManager = New CSPrintManager2.cPrintManager
  
  If cListDoc1.Id = csNO_ID Then Exit Sub
  
  If Not TypeOf ObjEdit Is CSIDocumento.cIDocumento Then Exit Sub
  Set iDoc = ObjEdit
  
  If Not iDoc.LoadForPrint(cListDoc1.Id) Then Exit Sub
  
  PrintManager.Path = GetRptPath
  PrintManager.CommandTimeout = GetRptCommandTimeOut
  PrintManager.ConnectionTimeout = GetRptConnectionTimeOut

  If iDoc.DocTId = 0 Then
    PrintManager.ShowPrint iDoc.Id, iDoc.DocId * -1, 0
  Else
    PrintManager.ShowPrint iDoc.Id, csNO_ID, iDoc.DocId
  End If
End Sub
Public Sub NewObj()
  Dim Mouse As cMouseWait
  Set Mouse = New cMouseWait
  
  ObjEdit.Edit 0
End Sub

Public Sub Delete()
  On Error GoTo ControlError
  
  Dim i         As Long
  Dim vIds()    As Long
  Dim msgDelete As String
  Dim ObjEdit   As cIEditGeneric
  
  vIds = cListDoc1.SelectedItems
  
  If vIds(0) <> csNO_ID Then
    
    If UBound(vIds) > 0 Then
      msgDelete = "los items"
    Else
      msgDelete = "el item"
    End If
    
    If pAskDelete("Confirma que desea borrar " & msgDelete) Then
    
      Dim Mouse As cMouseWait
      Set Mouse = New cMouseWait
    
      Set ObjEdit = CSKernelClient2.CreateObject(m_ObjEditName)
    
      For i = 0 To UBound(vIds)
        If ObjEdit.Delete(vIds(i)) Then cListDoc1.Remove vIds(i)
      Next
      
      Set ObjEdit = Nothing
    End If
  End If

  GoTo ExitProc
ControlError:
  MngError Err, "Delete", "fListDoc", ""
  If Err.Number Then Resume ExitProc
ExitProc:
  Set ObjEdit = Nothing
End Sub

'--------------------------------------------------
' Para implementar en el futuro
'
    'Public Sub ShowDocAux()
    '  Dim iAbm As cIABMClient
    '  Set iAbm = ObjEdit
    '  iAbm.MessageEx MSG_DOC_DOC_AUX, Nothing
    '  cListDoc1.Id
    'End Sub
'
'--------------------------------------------------

Public Sub CloseForm()
  Unload Me
End Sub
Public Sub Update()
  On Error Resume Next
  cListDoc1.Update
End Sub
Public Sub Search()
  Dim iAbm As cIABMClient
  Set iAbm = ObjEdit
  iAbm.MessageEx MSG_DOC_SEARCH, True
End Sub
Public Sub ReloadParams()
  On Error Resume Next
  'cListDoc1.ReloadParams
End Sub
Public Sub SaveParams()
  On Error Resume Next
  'cListDoc1.SaveParams
End Sub

'---------------------------------------------------------------
' Manejo de key stroke
'---------------------------------------------------------------
Public Function CtrlKeyNew() As Boolean
  NewObj
  CtrlKeyNew = True
End Function

Public Function CtrlKeyRefresh() As Boolean
  Update
  CtrlKeyRefresh = True
End Function

Public Function CtrlKeyClose() As Boolean
  CloseForm
  CtrlKeyClose = True
End Function

Public Function CtrlKeyPrint() As Boolean
  PrintObj
  CtrlKeyPrint = True
End Function

Public Function CtrlKeyDelete() As Boolean
  Delete
  CtrlKeyDelete = True
End Function

Public Function CtrlKeySearch() As Boolean
  Search
  CtrlKeySearch = True
End Function

'---------------------------------------------------------------

#If PREPROC_DEBUG Then
Private Sub Form_Initialize()
  gdbInitInstance C_Module
End Sub

Private Sub Form_Terminate()
  gdbTerminateInstance C_Module
End Sub
#End If

Private Sub tmResize_Timer()
  On Error Resume Next
  tmResize.Interval = 0
  pResize
End Sub

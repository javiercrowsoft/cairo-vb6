VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Object = "{0B7EBB95-21B3-4493-8B5C-1319674D4CF8}#3.0#0"; "csControls.ocx"
Begin VB.Form fListDoc 
   Caption         =   "Listado"
   ClientHeight    =   7845
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   8850
   ControlBox      =   0   'False
   Icon            =   "fListDoc2.frx":0000
   KeyPreview      =   -1  'True
   LinkTopic       =   "Form1"
   MDIChild        =   -1  'True
   ScaleHeight     =   7845
   ScaleWidth      =   8850
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
      BorderStyle     =   1
   End
   Begin CSControls.cListDoc cListDoc1 
      Height          =   5415
      Left            =   360
      TabIndex        =   0
      Top             =   1320
      Width           =   7575
      _ExtentX        =   13361
      _ExtentY        =   9551
      HelpType        =   2
   End
   Begin VB.Timer TmrCompatCollObjEdit 
      Interval        =   60000
      Left            =   7965
      Top             =   1395
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
Private Const c_TbKeyNEW = "NEW"
Private Const c_TbKeyEXIT = "EXIT"
' estructuras
' variables privadas
Private m_Name    As String
Private m_Buttons1  As Long
Private m_Buttons2  As Long
Private m_Buttons3  As Long
Private m_IconText  As Integer

Private m_ObjEditName     As String
Private m_ObjABMName      As String

Private m_ObjListNombre     As String
Private m_ObjListABMNombre  As String

Private m_CollObjEdit As Collection

Private m_ListObject As cIEditGenericListDoc
Private m_done       As Boolean

' propiedades privadas
Private Property Get ObjEdit() As cIEditGeneric
  On Error GoTo ControlError
  
  Set ObjEdit = GetObjectEdit
  Exit Property
ControlError:
  MngError Err, "ObjEdit", "fListDoc", ""
End Property

' propiedades publicas
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
Public Function CtrlKeySave() As Boolean
End Function

Public Function CtrlKeyNew() As Boolean
  pToolbarButtonClick c_TbKeyNEW
  CtrlKeyNew = True
End Function

Public Function CtrlKeyCopy() As Boolean
End Function

Public Function CtrlKeyRefresh() As Boolean
  Update
  CtrlKeyRefresh = True
End Function

Public Function CtrlKeyClose() As Boolean
  pToolbarButtonClick c_TbKeyEXIT
  CtrlKeyClose = True
End Function

'-----------------------
' Para que no chille
Public Sub Edit()
End Sub
Public Sub NewObj()
End Sub
Public Sub Delete()
End Sub
Public Sub CloseForm()
End Sub
Public Sub Search()
End Sub
Public Sub Update()
  On Error Resume Next
  cListDoc1.Update
End Sub
'-----------------------

Public Function Init() As Boolean
  Caption = m_Name
  cListDoc1.NameClient = m_Name
  cListDoc1.Buttons1 = m_Buttons1
  cListDoc1.Buttons2 = m_Buttons2
  cListDoc1.Buttons3 = m_Buttons3
  pSetToolBar
  cListDoc1.SetToolBar
  cListDoc1.IconText = m_IconText
  Init = True
  Set m_CollObjEdit = New Collection
End Function

Public Sub ShowParameters()
  On Error Resume Next
  
  Me.cListDoc1.ShowParameters
  
  CSKernelClient.ShowToolBarButton BUTTON_WITH_PARAMS, tbrTool, False
  CSKernelClient.ShowToolBarButton BUTTON_WITHOUT_PARAMS, tbrTool, True
End Sub

Public Sub HideParameters()
  On Error Resume Next
  
  Me.cListDoc1.HideParameters
  
  CSKernelClient.ShowToolBarButton BUTTON_WITH_PARAMS, tbrTool, True
  CSKernelClient.ShowToolBarButton BUTTON_WITHOUT_PARAMS, tbrTool, False
End Sub

' funciones privadas
Private Sub pSetToolBar()
  Buttons1 = Buttons1 + BUTTON_WITHOUT_PARAMS
  Buttons1 = Buttons1 + BUTTON_WITH_PARAMS
  Buttons1 = Buttons1 + BUTTON_UPDATE
  
  CSKernelClient.SetToolBar tbrTool, Buttons1, Buttons2, Buttons3
  
  DoEvents
  
  Form_Resize
End Sub

Private Function GetObjectEdit() As cIEditGeneric
  Dim o As cIEditGeneric
  Dim Founded As Boolean
  Dim i As Integer

  Set o = CSKernelClient.CreateObject(m_ObjEditName)
  Set o.ObjTree = cListDoc1
  
  Dim Editor As cIABMGeneric
  Set Editor = CSKernelClient.CreateObject(m_ObjABMName)
  Set o.ObjAbm = Editor

  pSetGenericDoc o

  Set GetObjectEdit = o
  m_CollObjEdit.Add o
End Function

Private Sub pSetGenericDoc(ByRef o As Object)
  Dim oDoc As cIEditGenericDoc
  If TypeOf o Is cIEditGenericDoc Then
    Set oDoc = o
    Set oDoc.Footer = CSKernelClient.CreateObject(m_ObjABMName)
    Set oDoc.Items = CSKernelClient.CreateObject(m_ObjABMName)
  End If
End Sub

Private Function CompactCollObjectEdit() As Boolean
  On Error GoTo ControlError

  Dim o As cIEditGeneric
  Dim i As Integer

  i = 1
  For Each o In m_CollObjEdit
    If Not o.Editing Then
       m_CollObjEdit.Remove i
    Else
      i = i + 1
    End If
  Next

  CompactCollObjectEdit = True

  Exit Function
ControlError:
  MngError Err, "CompactCollObjectEdit", "fListDoc", ""
End Function

Private Sub cListDoc1_DblClick()
  On Error GoTo ControlError
  
  Dim Mouse As cMouseWait
  Dim o As cIEditGeneric

  Set Mouse = New cMouseWait
  Set o = ObjEdit
  o.Edit cListDoc1.Id

  Exit Sub
ControlError:
  MngError Err, "cListDoc1_ToolBarClick", "fListDoc", ""
End Sub

Private Sub cListDoc1_ToolBarClick(ByVal Button As Object)
  On Error GoTo ControlError

  Dim Mouse As cMouseWait
  Dim o As cIEditGeneric
  
  Select Case Button.Key
    Case c_TbKeyEXIT
      Unload Me
    Case "EDIT"
      Set Mouse = New cMouseWait
      Set o = ObjEdit
      o.Edit cListDoc1.Id
    Case c_TbKeyNEW
      Set Mouse = New cMouseWait
      Set o = ObjEdit
      o.Edit 0
    Case "DELETE"
      If cListDoc1.Id <> csNO_ID Then
        If ObjEdit.Delete(cListDoc1.Id) Then cListDoc1.Remove cListDoc1.Id
      End If
  End Select
  Exit Sub
ControlError:
  MngError Err, "cListDoc1_ToolBarClick", "fListDoc", ""
End Sub

Private Sub cListDoc1_ToolBarClickEx(ByVal ToolBar As Object, ByVal lButton As Long)
  pToolbarButtonClick ToolBar.Buttons(lButton).Key
End Sub

Private Sub pToolbarButtonClick(ByVal ButtonKey As String)
  On Error GoTo ControlError
  Dim Mouse As cMouseWait
  Dim o As cIEditGeneric
  Select Case ButtonKey
    Case c_TbKeyEXIT
      Unload Me
    Case "EDIT"
      Set Mouse = New cMouseWait
      Set o = ObjEdit
      o.Edit cListDoc1.Id
    Case c_TbKeyNEW
      Set Mouse = New cMouseWait
      Set o = ObjEdit
      o.Edit 0
    Case "DELETE"
      
      Dim i         As Long
      Dim vIds()    As Long
      Dim msgDelete As String
      
      vIds = cListDoc1.SelectedItems
      
      If vIds(0) <> csNO_ID Then
        
        If UBound(vIds) > 0 Then
          msgDelete = "los items"
        Else
          msgDelete = "el item"
        End If
        
        If pAskDelete("Confirma que desea borrar " & msgDelete) Then
        
          For i = 0 To UBound(vIds)
            If ObjEdit.Delete(vIds(i)) Then cListDoc1.Remove vIds(i)
          Next
        End If
      End If
    
    Case "PRINTOBJ"
      pPrint
  End Select
  
  Exit Sub

ControlError:
  MngError Err, "pToolbarButtonClick", "fListDoc", ""
End Sub

Private Sub Form_KeyDown(KeyCode As Integer, Shift As Integer)
  ProcessVirtualKey KeyCode, Shift, Me
End Sub

Private Sub Form_Activate()
  ActiveBar Me
  
  If m_done Then Exit Sub
  m_done = True
  
  If cListDoc1.ParamVisible Then
    CSKernelClient.ShowToolBarButton BUTTON_WITH_PARAMS, tbrTool, False
  Else
    CSKernelClient.ShowToolBarButton BUTTON_WITHOUT_PARAMS, tbrTool, False
  End If
End Sub

Private Sub Form_Deactivate()
  DeactiveBar Me
End Sub

Private Sub Form_Load()
  On Error GoTo ControlError

  Dim Editor As cIABMGenericListDoc
  Dim o As cIEditGenericListDoc
  
  Set o = CSKernelClient.CreateObject(m_ObjListNombre)
  Set Editor = CSKernelClient.CreateObject(m_ObjListABMNombre)
  Set o.ObjAbm = Editor
  Set o.ObjList = cListDoc1
  o.ShowParams User.Id
  
  Set m_ListObject = o
  
  Set o = Nothing
  Set Editor = Nothing
  
  m_done = False
  
  On Error Resume Next
  Me.WindowState = vbMaximized
  
  Exit Sub
ControlError:
  MngError Err, "Form_Load", "fListDoc", ""
End Sub

Private Sub tbrTool_ButtonClick(ByVal Button As MSComctlLib.Button)
  On Error Resume Next
  CSKernelClient.PresButtonToolbarEx Button.Key, Me
  cListDoc1_ToolBarClickEx tbrTool, Button.Index
End Sub

Private Sub TmrCompatCollObjEdit_Timer()
  CompactCollObjectEdit
End Sub

Private Sub Form_Resize()
  On Error Resume Next
  Dim tbHeight As Integer
  tbHeight = tbrTool.Height
  cListDoc1.Move 0, tbHeight, ScaleWidth, ScaleHeight - tbHeight
End Sub

Private Function pAskDelete(ByVal Msg As String) As Boolean
  pAskDelete = Ask(Msg, vbYes, "Borrar")
End Function

Private Sub pPrint()
  Dim PrintManager As CSPrintManager.cPrintManager
  Dim iDoc         As CSIDocumento.cIDocumento
  
  Set PrintManager = New CSPrintManager.cPrintManager
  
  If cListDoc1.Id = csNO_ID Then Exit Sub
  
  If Not TypeOf ObjEdit Is CSIDocumento.cIDocumento Then Exit Sub
  Set iDoc = ObjEdit
  
  If Not iDoc.LoadForPrint(cListDoc1.Id) Then Exit Sub
  
  PrintManager.Path = GetValidPath(IniGetEx(c_RPT_KEY, c_RPT_PathReportes, App.Path))
  PrintManager.CommandTimeOut = Val(IniGetEx(c_RPT_KEY, c_RPT_CommandTimeOut, 0))
  PrintManager.ConnectionTimeout = Val(IniGetEx(c_RPT_KEY, c_RPT_ConnectionTimeOut, 0))

  PrintManager.ShowPrint iDoc.Id, csNO_ID, iDoc.DocId
End Sub

' construccion - destruccion
Private Sub Form_Unload(Cancel As Integer)
  On Error Resume Next
  
  TmrCompatCollObjEdit.Enabled = False
  
  Set m_ListObject.ObjAbm = Nothing
  Set m_ListObject = Nothing
  
  CollClear m_CollObjEdit
  Set m_CollObjEdit = Nothing
  
  cListDoc1.SavePreference WindowState
  CSKernelClient.UnloadForm Me, m_Name
  DeactiveBar Me
  fMain.RefreshTabs
End Sub

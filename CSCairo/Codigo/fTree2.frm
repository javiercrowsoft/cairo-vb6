VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Object = "{0B7EBB95-21B3-4493-8B5C-1319674D4CF8}#3.0#0"; "csControls.ocx"
Begin VB.Form fTree 
   BackColor       =   &H80000005&
   Caption         =   "Form1"
   ClientHeight    =   5625
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   7485
   ControlBox      =   0   'False
   Icon            =   "fTree2.frx":0000
   KeyPreview      =   -1  'True
   LinkTopic       =   "Form1"
   MDIChild        =   -1  'True
   ScaleHeight     =   5625
   ScaleWidth      =   7485
   Begin VB.Timer TmrCompatCollObjEdit 
      Interval        =   60000
      Left            =   5640
      Top             =   3900
   End
   Begin MSComctlLib.Toolbar tbrTool 
      Align           =   1  'Align Top
      Height          =   630
      Left            =   0
      TabIndex        =   1
      Top             =   0
      Width           =   7485
      _ExtentX        =   13203
      _ExtentY        =   1111
      ButtonWidth     =   609
      ButtonHeight    =   953
      Appearance      =   1
      _Version        =   393216
      BorderStyle     =   1
   End
   Begin CSControls.cTreeCtrl csTree1 
      Height          =   4605
      Left            =   240
      TabIndex        =   0
      Top             =   780
      Width           =   4785
      _ExtentX        =   8440
      _ExtentY        =   8123
   End
End
Attribute VB_Name = "fTree"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
'--------------------------------------------------------------------------------
' fTree
' 27-12-99

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
Private Const c_TbKeySEARCH = "SEARCH"
' estructuras
' variables privadas
Private m_Name      As String
Private m_Buttons1  As Long
Private m_Buttons2  As Long
Private m_Buttons3  As Long
Private m_IconText  As Integer
Private m_TblId     As csTables

Private m_ObjEditName   As String
Private m_ObjABMName  As String

Private m_CollObjEdit As Collection

' propiedades privadas
Private Property Get ObjEdit() As cIEditGeneric
    On Error GoTo ControlError
    
    Set ObjEdit = GetObjectEdit
    Exit Property
ControlError:
    MngError Err, "ObjEdit", "fTree", ""
End Property

' propiedades publicas
Public Property Get ObjEditName() As String
    ObjEditName = m_ObjEditName
End Property
Public Property Let ObjEditName(ByVal rhs As String)
    m_ObjEditName = rhs
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
Public Property Let Table(ByVal rhs As csTables)
    m_TblId = rhs
End Property
' propiedades privadas
' funciones publicas
Public Function Init() As Boolean
  Caption = m_Name
  csTree1.NameClient = m_Name
  csTree1.Buttons1 = m_Buttons1
  csTree1.Buttons2 = m_Buttons2
  csTree1.Buttons3 = m_Buttons3
  pSetToolBar
  csTree1.IconText = m_IconText
  Init = csTree1.Load(m_TblId)
  Set m_CollObjEdit = New Collection
End Function

Public Function CtrlKeySave() As Boolean
End Function

Public Function CtrlKeyNew() As Boolean
  pToolbarButtonClick c_TbKeyNEW
  CtrlKeyNew = True
End Function

Public Function CtrlKeyCopy() As Boolean
End Function

Public Function CtrlKeyRefresh() As Boolean
End Function

Public Function CtrlKeySearch() As Boolean
  pToolbarButtonClick c_TbKeySEARCH
  CtrlKeySearch = True
End Function

Public Function CtrlKeyClose() As Boolean
  pToolbarButtonClick c_TbKeyEXIT
  CtrlKeyClose = True
End Function

' funciones privadas
Private Sub pSetToolBar()
  CSKernelClient.SetToolBar tbrTool, Buttons1, Buttons2, Buttons3

  DoEvents
  
  Form_Resize
End Sub

Private Function GetObjectEdit() As cIEditGeneric
  Dim o As cIEditGeneric
  Dim YaEncontreUno As Boolean
  Dim i As Integer
  
  i = 1
  For Each o In m_CollObjEdit
    If Not o.Editing Then
      If YaEncontreUno Then
        m_CollObjEdit.Remove i
      Else
        YaEncontreUno = True
        i = i + 1
        Set GetObjectEdit = o
      End If
    Else
      i = i + 1
    End If
  Next
  
  If Not YaEncontreUno Then
    Dim Editor As cIABMGeneric
    Set o = CSKernelClient.CreateObject(m_ObjEditName)
    Set Editor = CSKernelClient.CreateObject(m_ObjABMName)
    Set o.ObjAbm = Editor
    Set o.ObjTree = csTree1
    Set GetObjectEdit = o
    m_CollObjEdit.Add o
  End If
End Function

Private Function pSearch() As Long
  Dim Help As CSOAPI.cHelp
  Dim hr As cHelpResult
  
  Set Help = New CSOAPI.cHelp
  
  Set hr = Help.Show(Nothing, m_TblId, "", "", "")
  
  If hr.Cancel Then Exit Function
  
  pSearch = hr.Id
End Function

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
  MngError Err, "CompactCollObjectEdit", "fTree", ""
End Function

Private Sub csTree1_DblClick()
  On Error GoTo ControlError
  
  Dim Mouse As cMouseWait
  Dim o As cIEditGeneric
  Set Mouse = New cMouseWait
  
  Set o = ObjEdit
  o.TreeId = csTree1.TreeId
  o.BranchId = csTree1.BranchId
  o.Edit csTree1.Id
  
  Exit Sub
ControlError:
  MngError Err, "csTree1_DblClick", "fTree", ""
End Sub

Private Sub csTree1_ToolBarClickEx(ByVal ToolBar As Object, ByVal lButton As Long)
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
      o.TreeId = csTree1.TreeId
      o.BranchId = csTree1.BranchId
      o.Edit csTree1.Id
    Case c_TbKeyNEW
      Set Mouse = New cMouseWait
      Set o = ObjEdit
      o.TreeId = csTree1.TreeId
      o.BranchId = csTree1.BranchId
      o.Edit 0
    Case "DELETE"
      
      Dim i         As Long
      Dim vIds()    As Long
      Dim msgDelete As String
      
      vIds = csTree1.SelectedItems
      
      If vIds(0) <> csNO_ID Then
        
        If UBound(vIds) > 0 Then
          msgDelete = "los items"
        Else
          msgDelete = "el item"
        End If
        
        If pAskDelete("Confirma que desea borrar " & msgDelete) Then
        
          For i = 0 To UBound(vIds)
            ObjEdit.Delete vIds(i)
          Next
        
          csTree1.RefreshActiveBranch
        End If
      End If
      
    Case "PRINTOBJ"
      pPrint
    Case c_TbKeySEARCH
      
      Dim Id As Long
      
      Id = pSearch
      csTree1.Search Id
      
  End Select
  Exit Sub
ControlError:
  MngError Err, "pToolbarButtonClick", "fTree", ""
End Sub

Private Sub csTree1_ToolBarClick(ByVal Button As Object)
  On Error GoTo ControlError
  
  Dim o As cIEditGeneric
  
  Select Case Button.Key
    Case c_TbKeyEXIT
      Unload Me
    Case "EDIT"
      Set o = ObjEdit
      o.TreeId = csTree1.TreeId
      o.BranchId = csTree1.BranchId
      o.Edit csTree1.Id
    Case c_TbKeyNEW
      Set o = ObjEdit
      o.TreeId = csTree1.TreeId
      o.BranchId = csTree1.BranchId
      o.Edit 0
    Case "DELETE"
      If csTree1.Id <> csNO_ID Then
        ObjEdit.Delete csTree1.Id
        csTree1.RefreshActiveBranch
      End If
    Case "PRINTOBJ"
      pPrint
  End Select
  Exit Sub
ControlError:
  MngError Err, "csTree1_ToolBarClick", "fTree", ""
End Sub

Private Sub pPrint()
  Dim PrintManager As CSPrintManager.cPrintManager
  Set PrintManager = New CSPrintManager.cPrintManager
  PrintManager.Path = GetValidPath(IniGetEx(c_RPT_KEY, c_RPT_PathReportes, App.Path))
  PrintManager.CommandTimeOut = Val(IniGetEx(c_RPT_KEY, c_RPT_CommandTimeOut, 0))
  PrintManager.ConnectionTimeout = Val(IniGetEx(c_RPT_KEY, c_RPT_ConnectionTimeOut, 0))

  PrintManager.ShowPrint csTree1.BranchId, m_TblId
End Sub

Private Sub tbrTool_ButtonClick(ByVal Button As MSComctlLib.Button)
  On Error Resume Next
  csTree1_ToolBarClickEx tbrTool, Button.Index
End Sub

Private Sub Form_KeyDown(KeyCode As Integer, Shift As Integer)
  ProcessVirtualKey KeyCode, Shift, Me
End Sub

Private Sub Form_Activate()
  ActiveBar Me
End Sub

Private Sub Form_Deactivate()
  DeactiveBar Me
End Sub

Private Sub Form_Load()
  On Error Resume Next
  Me.WindowState = vbMaximized
End Sub

Private Sub TmrCompatCollObjEdit_Timer()
  CompactCollObjectEdit
End Sub

Private Sub Form_Resize()
  On Error Resume Next
  Dim tbHeight As Integer
  tbHeight = tbrTool.Height
  csTree1.Move 0, tbHeight, ScaleWidth, ScaleHeight - tbHeight
End Sub

Private Function pAskDelete(ByVal Msg As String) As Boolean
  pAskDelete = Ask(Msg, vbYes, "Borrar")
End Function

' construccion - destruccion
Private Sub Form_Unload(Cancel As Integer)
  CollClear m_CollObjEdit
  Set m_CollObjEdit = Nothing
  csTree1.SavePreference WindowState
  CSKernelClient.UnloadForm Me, m_Name
  DeactiveBar Me
  fMain.RefreshTabs
End Sub


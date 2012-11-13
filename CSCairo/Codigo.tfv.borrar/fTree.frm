VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Object = "{EBA71138-C194-4F8F-8A43-4781BBB517F8}#1.0#0"; "CSTree2.ocx"
Begin VB.Form fTree 
   BackColor       =   &H80000005&
   Caption         =   "Form1"
   ClientHeight    =   5625
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   7485
   ControlBox      =   0   'False
   Icon            =   "fTree.frx":0000
   KeyPreview      =   -1  'True
   LinkTopic       =   "Form1"
   MDIChild        =   -1  'True
   ScaleHeight     =   5625
   ScaleWidth      =   7485
   Begin VB.Timer tmResize 
      Left            =   6120
      Top             =   3960
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
   End
   Begin VB.Timer TmrCompatCollObjEdit 
      Interval        =   60000
      Left            =   2520
      Top             =   4815
   End
   Begin CSTree2.cTreeCtrl csTree1 
      Height          =   4875
      Left            =   360
      TabIndex        =   0
      Top             =   360
      Width           =   4575
      _ExtentX        =   8070
      _ExtentY        =   8599
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
Private Const C_Module = "fTree"

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

' Preferencias del Usuario
'
Private m_UserCfg           As cUsuarioConfig

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

' funciones privadas
Private Sub pSetToolBar()
  'CSKernelClient2.SetToolBar24 tbrTool, Buttons1, Buttons2, Buttons3, m_UserCfg.ViewNamesInToolbar
  CSKernelClient2.SetToolBarEx tbrTool, Buttons1, Buttons2, Buttons3
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
    Set o = CSKernelClient2.CreateObject(m_ObjEditName)
    Set Editor = CSKernelClient2.CreateObject(m_ObjABMName)
    Set o.ObjAbm = Editor
    Set o.ObjTree = csTree1
    Set GetObjectEdit = o
    m_CollObjEdit.Add o
  End If
End Function

Private Function pSearch() As Long
  Dim Help As CSOAPI2.cHelp
  Dim hr As cHelpResult
  
  Set Help = New CSOAPI2.cHelp
  
  Help.IsSearch = True
  
  Set hr = Help.Show(Nothing, m_TblId, "", "", "", , , , , True)
  
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

  ' Preferencias del Usuario
  '
  Set m_UserCfg = New cUsuarioConfig
  m_UserCfg.Load

End Sub

Private Sub tbrTool_ButtonClick(ByVal Button As MSComctlLib.Button)
  CSKernelClient2.PresButtonToolbar Button.Key, Me
End Sub

Private Sub TmrCompatCollObjEdit_Timer()
  CompactCollObjectEdit
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

Private Function pAskDelete(ByVal msg As String) As Boolean
  pAskDelete = Ask(msg, vbYes, "Borrar")
End Function

' construccion - destruccion
Private Sub Form_Unload(Cancel As Integer)
  On Error Resume Next
  
  CollClear m_CollObjEdit
  
  ' Preferencias del Usuario
  '
  Set m_UserCfg = Nothing
  
  Set m_CollObjEdit = Nothing
  csTree1.SavePreference WindowState
  CSKernelClient2.UnloadForm Me, m_Name
  DeactiveBar Me
  fMain.RefreshTabs
End Sub

'---------------------------------------------------------------
' Manejo de la barra de herramientas
'---------------------------------------------------------------
Public Sub Edit()
  Dim Mouse As cMouseWait
  Set Mouse = New cMouseWait
  
  Dim o As cIEditGeneric
  Set o = ObjEdit
  o.TreeId = csTree1.TreeId
  o.BranchId = csTree1.BranchId
  o.Edit csTree1.Id
End Sub
Public Sub NewObj()
  Dim Mouse As cMouseWait
  Set Mouse = New cMouseWait
  
  Dim o As cIEditGeneric
  Set o = ObjEdit
  o.TreeId = csTree1.TreeId
  o.BranchId = csTree1.BranchId
  o.Edit 0
End Sub
Public Sub PrintObj()
  Dim PrintManager As CSPrintManager2.cPrintManager
  Set PrintManager = New CSPrintManager2.cPrintManager
  PrintManager.Path = GetRptPath
  PrintManager.CommandTimeout = GetRptCommandTimeOut
  PrintManager.ConnectionTimeout = GetRptConnectionTimeOut

  PrintManager.ShowPrint csTree1.BranchId, m_TblId
End Sub
Public Sub Delete()
  On Error GoTo ControlError
  
  Dim i         As Long
  Dim vIds()    As Long
  Dim msgDelete As String
  Dim ObjEdit   As cIEditGeneric
  
  vIds = csTree1.SelectedItems
  
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
        ObjEdit.Delete vIds(i)
      Next
    
      csTree1.RefreshActiveBranch
      
      Set ObjEdit = Nothing
    End If
  End If

  GoTo ExitProc
ControlError:
  MngError Err, "Delete", "fTree", ""
  If Err.Number Then Resume ExitProc
ExitProc:
  Set ObjEdit = Nothing
End Sub
Public Sub CloseForm()
  Unload Me
End Sub
Public Sub Search()
  Dim Id As Long
  
  Id = pSearch
  csTree1.Search Id
End Sub

'---------------------------------------------------------------
' Manejo de key stroke
'---------------------------------------------------------------
Public Function CtrlKeyNew() As Boolean
  NewObj
  CtrlKeyNew = True
End Function

Public Function CtrlKeySearch() As Boolean
  Search
  CtrlKeySearch = True
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

Private Sub pResize()
  Dim tbHeight As Integer
  tbHeight = tbrTool.Height + 60
  
  csTree1.Move 0, tbHeight, ScaleWidth, ScaleHeight - tbHeight
End Sub

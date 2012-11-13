VERSION 5.00
Object = "{90BC2404-A4C7-4252-82A5-F13572974974}#49.0#0"; "CSControls2.ocx"
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Begin VB.Form fMain 
   ClientHeight    =   7020
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   9555
   Icon            =   "fMain.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   7020
   ScaleWidth      =   9555
   StartUpPosition =   3  'Windows Default
   Begin VB.Timer TmrCompatCollObjEdit 
      Interval        =   60000
      Left            =   8505
      Top             =   1395
   End
   Begin CSControls2.cListDoc cListDoc1 
      Height          =   5415
      Left            =   900
      TabIndex        =   0
      Top             =   1320
      Width           =   7575
      _ExtentX        =   13361
      _ExtentY        =   9551
      HelpType        =   2
   End
   Begin MSComctlLib.Toolbar tbrTool 
      Align           =   1  'Align Top
      Height          =   630
      Left            =   0
      TabIndex        =   1
      Top             =   0
      Width           =   9555
      _ExtentX        =   16854
      _ExtentY        =   1111
      ButtonWidth     =   609
      ButtonHeight    =   953
      Appearance      =   1
      _Version        =   393216
   End
End
Attribute VB_Name = "fMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' fMain
' 13-02-00

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' Interfaces
' constantes
Private Const C_Module = "fMain"
Private Const c_TbKeyNEW = "NEW"
Private Const c_TbKeyEXIT = "EXIT"
' estructuras
' variables privadas
Private WithEvents m_Client As cTCPIPClient
Attribute m_Client.VB_VarHelpID = -1
Private m_CollTCPObjects    As Collection
Private m_CollObjEdit       As Collection
Private m_ListObject        As cIEditGenericListDoc

Private m_ObjEditName       As String
Private m_ObjABMName        As String
Private m_ObjListNombre     As String
Private m_ObjListABMNombre  As String

Private m_IconText  As Integer

Private m_Name      As String
Private m_Buttons1  As Long
Private m_Buttons2  As Long
Private m_Buttons3  As Long
' propiedades publicas
Public Property Get Client() As cTCPIPClient
  Set Client = m_Client
End Property
Public Property Set Client(ByRef rhs As cTCPIPClient)
  Set m_Client = rhs
End Property
' propiedades privadas
Private Property Get ObjEdit() As cIEditGeneric
  On Error GoTo ControlError
  
  Set ObjEdit = GetObjectEdit
  Exit Property
ControlError:
  MngError Err, "ObjEdit", "fListDoc", ""
End Property
' funciones publicas
' funciones privadas
Private Sub m_Client_ReciveText(ByVal Buffer As String)
  On Error GoTo ControlError
   
  Dim IDInstance As Long
  Dim iModule    As cITCPModule
  
  If Buffer = "" Then Exit Sub
  
  IDInstance = TCPGetDllID(Buffer)
  
  If IDInstance = 0 Then Exit Sub
  
  If m_CollTCPObjects Is Nothing Then Exit Sub
  
  Dim IDTcp      As Long
  IDTcp = TCPGetDllProgID(Buffer)
  If IDTcp = 0 Then Exit Sub
  
  For Each iModule In m_CollTCPObjects
    If (iModule.IDInstance = IDInstance) Or _
       (IDInstance = c_AnyComponentTCP And iModule.ProgId = IDTcp) _
       Then Exit For
  Next
  
  If iModule Is Nothing Then
    
    Dim SysTCP     As CSOAPI2.cSysModuloTCP
    
    Set SysTCP = New CSOAPI2.cSysModuloTCP
    If Not SysTCP.Load(IDTcp) Then Exit Sub
    
    If SysTCP.ObjetoEdicion = "" Then Exit Sub
    
    Set iModule = CSKernelClient2.CreateObject(SysTCP.ObjetoEdicion)
    
    m_CollTCPObjects.Add iModule
    iModule.IDInstance = m_CollTCPObjects.Count
  End If
  
  iModule.ProcessMessage TCPGetSrvToClientMsg(Buffer)

  GoTo ExitProc
ControlError:
  MngError Err, "m_Client_ReciveText", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

' Construccion - Destruccion
Private Sub Form_Load()
  On Error GoTo ControlError
   
  CSKernelClient2.LoadForm Me, "MAIN"

  Set m_CollTCPObjects = New Collection
  
  GoTo ExitProc
ControlError:
  MngError Err, "MDIForm_Load", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
  On Error GoTo ControlError

  Cancel = Not CSABMInterface2.CloseDll()

  GoTo ExitProc
ControlError:
  MngError Err, "MDIForm_QueryUnload", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Form_Unload(Cancel As Integer)
  On Error GoTo ControlError
   
  UnloadApp
  
  CollClear m_CollTCPObjects
  
  Set m_CollTCPObjects = Nothing
  
  CSKernelClient2.UnloadForm Me, "MAIN"
  CloseApp

  GoTo ExitProc
ControlError:
  MngError Err, "MDIForm_Unload", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Form_Resize()
  On Error Resume Next
  Dim tbHeight As Integer
  DoEvents: DoEvents: DoEvents
  tbHeight = tbrTool.Height + 60
  cListDoc1.Move 0, tbHeight, ScaleWidth, ScaleHeight - tbHeight
End Sub
'//////////////////////////////////////////////////////////////////////
Private Sub pShowList()
  On Error GoTo ControlError
  
  ' Me aseguro que tenga permiso de edicion
  Dim o As cIEditGeneric
  Set o = CSKernelClient2.CreateObject("CSVenta2.cFacturaVenta")
  
  ' Si no puede editar chau
  If Not o.ShowList Then Exit Sub
  
  m_ObjABMName = "CSABMInterface2.CABMGeneric"
  m_ObjEditName = "CSVenta2.cFacturaVenta"
  m_ObjListABMNombre = "CSABMInterface2.CABMGenericListDoc"
  m_ObjListNombre = "CSVenta2.cFacturaVtaListDoc"
  
  ' Configuro el form para este abm
  m_Name = "Facturas de Venta"
  m_Buttons1 = BUTTON_DELETE + BUTTON_SEARCH + BUTTON_EDIT + BUTTON_PRINTOBJ + BUTTON_NEW + BUTTON_EXIT
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIMenuHost_MenuListDocClick", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

'/////////
Private Function GetObjectEdit() As cIEditGeneric
  Dim o As cIEditGeneric
  Dim Founded As Boolean
  Dim i As Integer

  Set o = CSKernelClient2.CreateObject(m_ObjEditName)
  Set o.ObjTree = cListDoc1
  
  Dim Editor As cIABMGeneric
  Set Editor = CSKernelClient2.CreateObject(m_ObjABMName)
  Set o.ObjAbm = Editor

  pSetGenericDoc o

  Set GetObjectEdit = o
  m_CollObjEdit.Add o
End Function

Private Sub pSetGenericDoc(ByRef o As Object)
  Dim oDoc As cIEditGenericDoc
  If TypeOf o Is cIEditGenericDoc Then
    Set oDoc = o
    Set oDoc.Footer = CSKernelClient2.CreateObject(m_ObjABMName)
    Set oDoc.Items = CSKernelClient2.CreateObject(m_ObjABMName)
  End If
End Sub

'//////////////////////////////////////////////////////////////////////////////
Public Sub ShowParameters()
  On Error Resume Next
  
  Me.cListDoc1.ShowParameters
  
  CSKernelClient2.ShowToolBarButton BUTTON_WITH_PARAMS, tbrTool, False
  CSKernelClient2.ShowToolBarButton BUTTON_WITHOUT_PARAMS, tbrTool, True
End Sub

Public Sub HideParameters()
  On Error Resume Next
  
  Me.cListDoc1.HideParameters
  
  CSKernelClient2.ShowToolBarButton BUTTON_WITH_PARAMS, tbrTool, True
  CSKernelClient2.ShowToolBarButton BUTTON_WITHOUT_PARAMS, tbrTool, False
End Sub

Public Sub ShowList()
  On Error GoTo ControlError

  pShowList

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
  
  Caption = Caption & " - " & m_Name
  cListDoc1.NameClient = m_Name
  cListDoc1.Buttons1 = m_Buttons1
  cListDoc1.Buttons2 = m_Buttons2
  cListDoc1.Buttons3 = m_Buttons3
  pSetToolBar
  cListDoc1.SetToolBar
  cListDoc1.IconText = m_IconText

  Set m_CollObjEdit = New Collection
  
  If cListDoc1.ParamVisible Then
    CSKernelClient2.ShowToolBarButton BUTTON_WITH_PARAMS, tbrTool, False
  Else
    CSKernelClient2.ShowToolBarButton BUTTON_WITHOUT_PARAMS, tbrTool, False
  End If
  
  Exit Sub
ControlError:
  MngError Err, "Form_Load", "fListDoc", ""
End Sub

Private Sub pSetToolBar()
  m_Buttons1 = m_Buttons1 + BUTTON_WITHOUT_PARAMS
  m_Buttons1 = m_Buttons1 + BUTTON_WITH_PARAMS
  m_Buttons1 = m_Buttons1 + BUTTON_UPDATE
  
  CSKernelClient2.SetToolBar tbrTool, m_Buttons1, m_Buttons2, m_Buttons3

  DoEvents
  
  Form_Resize
End Sub

Private Sub tbrTool_ButtonClick(ByVal Button As MSComctlLib.Button)
  On Error Resume Next
  CSKernelClient2.PresButtonToolbar Button.Key, Me
End Sub

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
  pToolbarButtonClick ToolBar.ButtonKey(lButton)
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

Private Function pAskDelete(ByVal Msg As String) As Boolean
  pAskDelete = Ask(Msg, vbYes, "Borrar")
End Function

Private Sub pPrint()
  Dim PrintManager As CSPrintManager2.cPrintManager
  Dim iDoc         As CSIDocumento.cIDocumento
  
  Set PrintManager = New CSPrintManager2.cPrintManager
  
  If cListDoc1.Id = csNO_ID Then Exit Sub
  
  If Not TypeOf ObjEdit Is CSIDocumento.cIDocumento Then Exit Sub
  Set iDoc = ObjEdit
  
  If Not iDoc.LoadForPrint(cListDoc1.Id) Then Exit Sub
  
  PrintManager.Path = GetValidPath(IniGetEx(c_RPT_KEY, c_RPT_PathReportes, App.Path))
  PrintManager.CommandTimeout = Val(IniGetEx(c_RPT_KEY, c_RPT_CommandTimeOut, 0))
  PrintManager.ConnectionTimeout = Val(IniGetEx(c_RPT_KEY, c_RPT_ConnectionTimeOut, 0))

  If iDoc.DocTId = 0 Then
    PrintManager.ShowPrint iDoc.Id, iDoc.DocId * -1, 0
  Else
    PrintManager.ShowPrint iDoc.Id, csNO_ID, iDoc.DocId
  End If
End Sub

'////////////////////////////////////////////////////////////////////////////////
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
  ObjEdit.Edit 0
End Sub
Public Sub Update()
  On Error Resume Next
  cListDoc1.Update
End Sub
Public Sub Delete()
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
End Sub
Public Sub CloseForm()
  Unload Me
End Sub
Public Sub Search()
  Dim iAbm As cIABMClient
  Set iAbm = ObjEdit
  iAbm.MessageEx MSG_DOC_SEARCH, True
End Sub
'-----------------------


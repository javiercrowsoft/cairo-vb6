VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cListaPrecioPrint"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGeneric
Implements CSInterfacesABM.cIABMClient
'--------------------------------------------------------------------------------
' cListaPrecioPrint
' 07-10-2004

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cListaPrecioPrint"
Private Const c_ConIva = "conIva"
Private Const c_SinClientes = "sinCliente"
Private Const c_SinBases = "sinBases"

Private Const K_LP_ID                          As Integer = 1
Private Const K_PR_ID                          As Integer = 2
Private Const K_CON_IVA                        As Integer = 3
Private Const K_SIN_CLIENTES                   As Integer = 4
Private Const K_SIN_BASES                      As Integer = 5

' estructuras
' variables privadas
Private m_lp_id                        As String
Private m_pr_id                        As String
Private m_bIva                         As Boolean
Private m_bSinClientes                 As Boolean
Private m_bSinBases                    As Boolean

'OJO HASTA ACA

Private m_rptName           As String
Private m_rptFile           As String
Private m_Action            As Integer
Private m_Copies            As Long
Private m_Path              As String

Private m_ConnectionTimeout             As Long
Private m_CommandTimeout                As Long

Private m_ObjAbm            As cIABMGeneric

Private m_IsNew             As Boolean

' eventos
' Properties publicas
' propiedades friend
' propiedades privadas
' funciones publicas
Public Function DoPrint(ByVal rptName As String, _
                        ByVal rptFile As String, _
                        ByVal Action As Integer, _
                        ByVal Copies As Long, _
                        ByVal Id As String, _
                        ByVal Path As String, _
                        ByVal CommandTimeout As Long, _
                        ByVal ConnectionTimeout As Long) As Boolean
                        
  m_rptName = rptName
  m_rptFile = rptFile
  m_Action = Action
  m_Copies = Copies
  m_Path = Path
  m_ConnectionTimeout = ConnectionTimeout
  m_CommandTimeout = CommandTimeout
  
  Set m_ObjAbm = New CSABMInterface2.cABMGeneric
  cIEditGeneric_Edit csNO_ID, False
  
  DoPrint = True
End Function

' funciones friend

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

Private Function cIABMClient_MessageEx(ByVal MessageID As Long, ByVal Info As Variant) As Variant
  cIABMClient_MessageEx = True
End Function

Private Function cIABMClient_ShowDocDigital() As Boolean
End Function

Private Function cIABMClient_EditNew() As Boolean
  cIEditGeneric_Edit csNO_ID
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
  
  m_lp_id = m_ObjAbm.Properties.Item(cscLpId).HelpValueProcess
  m_pr_id = m_ObjAbm.Properties.Item(cscPrId).HelpValueProcess
  m_bIva = Val(m_ObjAbm.Properties.Item(c_ConIva).Value)
  m_bSinClientes = Val(m_ObjAbm.Properties.Item(c_SinClientes).Value)
  m_bSinBases = Val(m_ObjAbm.Properties.Item(c_SinBases).Value)
  
  pPrint m_rptName, m_rptFile, m_Action, m_Copies
  
  cIABMClient_Save = True
End Function

Private Function cIABMClient_Terminate() As Boolean
  cIABMClient_Terminate = True
End Function

Private Property Get cIABMClient_Title() As String
  cIABMClient_Title = LNGGetText(2881, vbNullString) 'Imprimir Listas de Precios
End Property

Private Function cIABMClient_Validate() As Boolean
  cIABMClient_Validate = True
End Function

' Implementacion de cIEditGeneric

Private Function cIEditGeneric_TabClick(ByVal Index As Integer) As Boolean

End Function

Private Property Let cIEditGeneric_TreeId(ByVal rhs As Long)
End Property

Private Property Get cIEditGeneric_TreeId() As Long
End Property

Private Function cIEditGeneric_GridAdd(ByVal KeyProperty As Integer) As Boolean

End Function

Private Function cIEditGeneric_GridEdit(ByVal KeyProperty As Integer) As Boolean

End Function

Private Function cIEditGeneric_GridRemove(ByVal KeyProperty As Integer) As Boolean

End Function

Private Function cIEditGeneric_ShowList() As Boolean
    cIEditGeneric_ShowList = False
End Function

Private Property Get cIEditGeneric_ObjAbm() As CSInterfacesABM.cIABMGeneric
  Set cIEditGeneric_ObjAbm = m_ObjAbm
End Property

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
    Set m_ObjAbm = rhs
End Property

Private Property Get cIEditGeneric_Editing() As Boolean
End Property

Private Function cIEditGeneric_Delete(Id As Long) As Boolean
  cIEditGeneric_Delete = False
End Function

Private Function cIEditGeneric_Search(Id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  m_IsNew = Id = csNO_ID
  
  m_ObjAbm.InModalWindow = InModalWindow
  
  If Not LoadCollection() Then Exit Function
  
  m_ObjAbm.InModalWindow = InModalWindow

    Exit Function
ControlError:
    MngError Err, "cIEditGeneric_Edit", "cListaPrecioPrint", vbNullString
End Function

Private Function cIEditGeneric_PrintObj(ByVal Id As Long) As Boolean

End Function

Private Property Set cIEditGeneric_ObjTree(rhs As Object)
End Property

Private Property Let cIEditGeneric_BranchId(ByVal rhs As Long)
End Property

Private Property Get cIEditGeneric_BranchId() As Long
End Property

Private Function cIEditGeneric_Preview(ByVal Id As Long) As Boolean

End Function

Private Function cIEditGeneric_PropertyChange(ByVal Key As Integer) As Boolean

End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  Dim iTab    As cIABMTabItem
  Dim c       As cIABMProperty
  Dim iProp   As cABMProperty
  
  m_ObjAbm.Tabs.Clear
  m_ObjAbm.Properties.Clear
  
  Set iTab = m_ObjAbm.Tabs.Add(Nothing)
  iTab.Index = 0
  iTab.Name = C_strGeneral
  
  Set c = m_ObjAbm.Properties.Add(Nothing, "label1")
  c.PropertyType = cspLabel
  c.Value = LNGGetText(2882, vbNullString)
            'Seleccione la lista y los artículos. Puede seleccionar varias listas que & _
              se imprimirán en hojas separadas.
  c.FontBold = True
  c.Width = 4000
  c.Height = 700
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscLpId)
  c.PropertyType = cspHelp
  Set iProp = c
  iProp.HelpType = csTree
  c.Table = csListaPrecio
  c.Name = LNGGetText(1397, vbNullString) 'Lista de Precios
  c.Width = 3000
  c.Key = K_LP_ID
  c.Value = vbNullString
  c.HelpId = csNO_ID
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscPrId)
  c.PropertyType = cspHelp
  Set iProp = c
  iProp.HelpType = csTree
  c.Table = csProducto
  c.Name = LNGGetText(1283, vbNullString)   'Articulos
  c.Width = 3000
  c.Key = K_PR_ID
  c.Value = vbNullString
  c.HelpId = csNO_ID
  
  Set c = m_ObjAbm.Properties.Add(Nothing, c_ConIva)
  c.PropertyType = cspCheck
  c.Name = LNGGetText(2885, vbNullString)   'Incluir iva
  c.Key = K_CON_IVA
  
  Set c = m_ObjAbm.Properties.Add(Nothing, c_SinClientes)
  c.PropertyType = cspCheck
  c.Name = LNGGetText(2886, vbNullString)   'Sin clientes
  c.Key = K_SIN_CLIENTES
  
  Set c = m_ObjAbm.Properties.Add(Nothing, c_SinBases)
  c.PropertyType = cspCheck
  c.Name = LNGGetText(2887, vbNullString)   'Sin bases
  c.Key = K_SIN_BASES
  
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  AbmObj.OkCancelDialog = True
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

Private Sub pPrint(ByVal rptName As String, _
                   ByVal rptFile As String, _
                   ByVal Action As Integer, _
                   ByVal Copies As Long)
                   
  On Error GoTo ControlError

  Dim rpt      As Object 'cReport
  Dim RptPrint As Object 'CSReportPaint2.cReportPrint
  Dim c_OpenRpt     As String
  
  c_OpenRpt = LNGGetText(2888, vbNullString) 'Abrir Reporte

  Dim Mouse As cMouseWait
  Set Mouse = New cMouseWait

  Set rpt = CSKernelClient2.CreateObject("CSReportTDll.cReport")

  If Not rpt.Init(CSKernelClient2.CreateObject("CSReportTDll.cReportLaunchInfo")) Then Exit Sub

  Set RptPrint = CSKernelClient2.CreateObject("CSReportTPaint.cReportPrint")
  Set rpt.LaunchInfo.ObjPaint = RptPrint

  rptFile = GetValidPath(m_Path) & rptFile

  Dim FileEx As CSKernelFile.cFileEx
  Set FileEx = New CSKernelFile.cFileEx
  
  If Not FileEx.FileExists(rptFile) Then
    MsgWarning LNGGetText(2889, vbNullString, rptFile), c_OpenRpt
              'El archivo;; & rptFile & ;;no existe.;;Verifique la ubicación de los & _
              reportes.
    Exit Sub
  End If

  If Not rpt.LoadSilent(rptFile) Then
    MsgWarning LNGGetText(3105, vbNullString, rptFile, CSKernelClient2.LastErrorDescription), c_OpenRpt
    'No se pudo cargar el reporte  & rptFile & ;( & CSKernelClient2.LastErrorDescription & )

    Exit Sub
  End If

  rpt.Connect.StrConnect = gDB.StrConnect
  
  Dim ConnectAux As Object
  For Each ConnectAux In rpt.ConnectsAux
    ConnectAux.StrConnect = gDB.StrConnect
  Next
  
  With rpt.LaunchInfo
    With .Printer.PaperInfo
      .PaperSize = rpt.PaperInfo.PaperSize
      .Orientation = rpt.PaperInfo.Orientation
      .CustomHeight = rpt.PaperInfo.CustomHeight
      .CustomWidth = rpt.PaperInfo.CustomWidth
    End With
    .Copies = Copies
    .Action = Action
    .ShowPrintersDialog = True
  End With

  rpt.DescripUser = rptName

  pSetParams rpt

  If m_CommandTimeout > 0 Then rpt.Connect.CommandTimeout = m_CommandTimeout
  If m_ConnectionTimeout > 0 Then rpt.Connect.ConnectionTimeout = m_ConnectionTimeout

  rpt.LaunchInfo.InternalPreview = True

  rpt.Launch

  GoTo ExitProc
ControlError:
  MngError Err, "pPrint", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub pSetParams(ByRef rpt As Object)
  On Error Resume Next
  With rpt.Connect.Parameters
    .Item(1).Value = m_lp_id
    .Item(2).Value = m_pr_id
    .Item(3).Value = CInt(m_bIva)
    .Item(4).Value = CInt(m_bSinClientes)
    .Item(5).Value = CInt(m_bSinBases)
  End With
End Sub

' construccion - destruccion

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


VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cRptManager"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cRptManager
' 13-04-2005

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cRptManager"

Private Const c_NodeLinks = "links"
Private Const c_NodeIncludes = "includes"
Private Const c_NodeControls = "controls"
Private Const c_file = "file"

Private Const c_doct_id = "doct_id"
Private Const c_comp_id = "comp_id"

' estructuras
' variables privadas
Private m_CountReference As Long
Private m_DefLoaded      As Boolean
Private m_CollDef        As cRptDefLinks
Private m_CollFiles      As Collection
Private m_EasyLink       As Boolean

' eventos
' propiedades publicas
Public Property Get CountReference() As Long
  CountReference = m_CountReference
End Property

Public Property Let CountReference(ByVal rhs As Long)
  m_CountReference = rhs
End Property

' propiedades friend
' propiedades privadas
' funciones publicas
Friend Function Load(ByVal rptName As String, _
                     ByVal Path As String, _
                     ByRef Report As cReport) As Boolean
                     
  Dim DocXml    As CSXml2.cXml
  Dim fileName  As String
  Dim File      As CSKernelFile.cFileEx
  
  Set File = New CSKernelFile.cFileEx
  fileName = File.FileGetNameWithoutExt(rptName) & ".xml"
  
  If ExistsStandarTypeInColl(m_CollFiles, fileName) Then Exit Function
  
  m_CollFiles.Add fileName, fileName
  
  If File.FileExists(GetValidPath(Path) & fileName) Then
  
    m_EasyLink = False
  
    Set DocXml = New CSXml2.cXml
  
    DocXml.Init Nothing
    DocXml.Name = fileName
    DocXml.Path = Path
  
    If Not DocXml.OpenXml() Then Exit Function
  
    Load = pLoad(DocXml, Path)
    
  Else
    
    m_EasyLink = pIsEasyLink(Report)
    
    If m_EasyLink Then
      
      With m_CollDef.Add()
        .Doct_id = c_doct_id
        .Id = c_comp_id
        .ObjectName = "CSInforme2.cLinkManager"
      End With
      
      m_DefLoaded = True
      Load = True
    End If
  End If
End Function

Friend Function LoadForGrid(ByVal rptName As String, _
                            ByVal Path As String, _
                            ByRef Grid As cGrid) As Boolean
                     
'////////////////////////////////////////////////////
'
' Por ahora las grillas o son easy link o nada
'
'////////////////////////////////////////////////////


'  Dim DocXml    As CSXml2.cXml
'  Dim fileName  As String
'  Dim File      As CSKernelFile.cFileEx
'
'  Set File = New CSKernelFile.cFileEx
'  fileName = File.FileGetNameWithoutExt(rptName) & ".xml"
'
'  If ExistsStandarTypeInColl(m_CollFiles, fileName) Then Exit Function
'
'  m_CollFiles.Add fileName, fileName
'
'  If File.FileExists(GetValidPath(Path) & fileName) Then
'
'    m_EasyLink = False
'
'    Set DocXml = New CSXml2.cXml
'
'    DocXml.Init Nothing
'    DocXml.Name = fileName
'    DocXml.Path = Path
'
'    If Not DocXml.OpenXml() Then Exit Function
'
'    LoadForGrid = pLoad(DocXml, Path)
'
'  Else
    
    m_EasyLink = pIsEasyLinkForGrid(Grid)
    
    If m_EasyLink Then
      
      With m_CollDef.Add()
        .Doct_id = c_doct_id
        .Id = c_comp_id
        .ObjectName = "CSInforme2.cLinkManager"
      End With
      
      m_DefLoaded = True
      LoadForGrid = True
    End If

'  End If
End Function

Friend Sub ClickOnField(ByRef fPreview As fPreview, _
                        ByVal IndexField As Long)
                        
  On Error GoTo ControlError
  
  If Not m_DefLoaded Then Exit Sub

  If Not pIsLinkField(fPreview, IndexField) Then Exit Sub
  
  Dim DefLink As cRptDefLink
  
  Set DefLink = pGetDefLink(fPreview, IndexField)
  DefLink.ObjManager.ManageLink DefLink, fPreview, IndexField

  GoTo ExitProc
ControlError:
  MngError Err, "ClickOnField", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Friend Sub ClickOnLine(ByRef fPreview As fPreview, _
                       ByVal Id As Long)
                       
  On Error GoTo ControlError
  
  If Not m_DefLoaded Then Exit Sub

  GoTo ExitProc
ControlError:
  MngError Err, "ClickOnLine", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Friend Sub DblClickOnField(ByRef fPreview As fPreview, _
                           ByVal IndexField As Long)
                           
  On Error GoTo ControlError
  
  If Not m_DefLoaded Then Exit Sub

  GoTo ExitProc
ControlError:
  MngError Err, "DblClickOnField", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Friend Sub DblClickOnFieldForGrid(ByRef fPreview As fPreviewGrid, _
                                  ByVal IndexField As Long)
                           
  On Error GoTo ControlError
  
  If Not m_DefLoaded Then Exit Sub

  'If Not pIsLinkField(fPreview, IndexField) Then Exit Sub
  If Not m_EasyLink Then Exit Sub
  
  Dim DefLink As cRptDefLink
  
  Set DefLink = pGetDefLinkForGrid()
  DefLink.ObjManager.ManageLink DefLink, fPreview, IndexField

  GoTo ExitProc
ControlError:
  MngError Err, "DblClickOnFieldForGrid", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Friend Sub DblClickOnLine(ByRef fPreview As fPreview, _
                          ByVal Id As Long)
                          
  On Error GoTo ControlError
  
  If Not m_DefLoaded Then Exit Sub

  GoTo ExitProc
ControlError:
  MngError Err, "DblClickOnLine", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Friend Sub MouseDownOnField(ByRef fPreview As fPreview, _
                            ByVal IndexField As Long, ByVal Button As Integer, _
                            ByVal Shift As Integer, Cancel As Boolean, _
                            ByVal x As Single, ByVal y As Single)
                            
  On Error GoTo ControlError
  
  If Not m_DefLoaded Then Exit Sub

  GoTo ExitProc
ControlError:
  MngError Err, "MouseDownOnField", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Friend Sub MouseOnField(ByRef fPreview As fPreview, _
                        ByVal IndexField As Long)
                        
  On Error GoTo ControlError
  
  If Not m_DefLoaded Then Exit Sub

  If pIsLinkField(fPreview, IndexField) Then

    On Error Resume Next
    fPreview.rptMain.MousePointer = vbCustom
    Set fPreview.rptMain.MouseIcon = fPreview.imgCur.Picture
    pSetLink fPreview, IndexField, True
  
  Else
    MouseOutField fPreview
  End If

  ' Debug.Print IndexField

  GoTo ExitProc
ControlError:
  MngError Err, "MouseOnField", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Friend Sub MouseOutField(ByRef fPreview As fPreview)
                        
  On Error GoTo ControlError
  
  If Not m_DefLoaded Then Exit Sub

  On Error Resume Next
  fPreview.rptMain.MousePointer = vbDefault
  Set fPreview.rptMain.MouseIcon = Nothing
  pSetLink fPreview, fPreview.LastIndexField, False
  
  ' Debug.Print "chau"

  GoTo ExitProc
ControlError:
  MngError Err, "MouseOutField", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

' funciones friend
' funciones privadas
Private Function pLoad(ByRef DocXml As CSXml2.cXml, _
                       ByVal Path As String) As Boolean
  
  Dim NodObj As Object
  Dim NodObjAux As Object
  Dim NodObjCtrls As Object
  
  Set NodObj = DocXml.GetRootNode()
  
  Set NodObj = DocXml.GetNodeFromNode(NodObj, c_NodeLinks)
  Set NodObj = DocXml.GetNodeFromNode(NodObj, c_NodeControls)
  
  If DocXml.NodeHasChild(NodObj) Then
    Set NodObjCtrls = DocXml.GetNodeChild(NodObj)
    While Not NodObjCtrls Is Nothing
      Set NodObjAux = NodObjCtrls
      If m_CollDef.Exists(NodObjAux.nodename) Then
        m_CollDef.Item(NodObjAux.nodename).LoadChild DocXml, NodObjAux
      Else
        If Not m_CollDef.Add(, NodObjAux.nodename).Load(DocXml, NodObjAux) Then Exit Function
      End If
      Set NodObjCtrls = DocXml.GetNextNode(NodObjCtrls)
    Wend
  End If
  
  pLoadIncludes DocXml, Path
  
  m_DefLoaded = True
  
  pLoad = True
End Function

Private Function pLoadIncludes(ByRef DocXml As CSXml2.cXml, _
                               ByVal Path As String) As Boolean

  Dim NodObj As Object
  Dim NodObjInclude As Object
  
  Set NodObj = DocXml.GetRootNode()
  
  Set NodObj = DocXml.GetNodeFromNode(NodObj, c_NodeLinks)
  Set NodObj = DocXml.GetNodeFromNode(NodObj, c_NodeIncludes)
  
  If DocXml.NodeHasChild(NodObj) Then
    Set NodObjInclude = DocXml.GetNodeChild(NodObj)
    While Not NodObjInclude Is Nothing
      Load DocXml.GetNodeProperty(NodObjInclude, c_file).Value(csText), Path, Nothing
      Set NodObjInclude = DocXml.GetNextNode(NodObjInclude)
    Wend
  End If
  
  pLoadIncludes = True
End Function

Private Sub pSetLink(ByRef fPreview As fPreview, _
                     ByVal IndexField As Long, _
                     ByVal HighLight As Boolean)

' Por ahora no vamos a iluminar mas el texto por que se ve pa la mona
'
'  If HighLight Then
'
'    If fPreview.LastIndexField <> 0 Then
'      pSetLink fPreview, fPreview.LastIndexField, False
'    End If
'
'    fPreview.LastIndexField = IndexField
'
'    If IndexField = 0 Then Exit Sub
'
'    With pGetRptField(fPreview.RptPrint, IndexField).Info.Aspect.Font
'      fPreview.LnkForeColor = .ForeColor
'      fPreview.LnkFontBold = .Bold
'      .ForeColor = vbBlue
'      '.Bold = True
'    End With
'
'  Else
'
'    If IndexField = 0 Then Exit Sub
'
'    With pGetRptField(fPreview.RptPrint, IndexField).Info.Aspect.Font
'      .ForeColor = fPreview.LnkForeColor
'      '.Bold = fPreview.LnkFontBold
'    End With
'  End If
'
'  fPreview.RptPrint.RefreshCtrl IndexField
End Sub

Private Function pIsLinkField(ByRef Preview As fPreview, _
                              ByVal IndexField As Long) As Boolean
  If m_EasyLink Then
    pIsLinkField = Preview.RptPrint.FieldIsInDetail(IndexField)
  Else
    pIsLinkField = m_CollDef.Exists(pGetFieldName(Preview.RptPrint, IndexField))
  End If
End Function

Private Function pGetDefLink(ByRef Preview As fPreview, _
                             ByVal IndexField As Long) As cRptDefLink
  
  If m_EasyLink Then
    Set pGetDefLink = m_CollDef.Item(1)
  Else
    Set pGetDefLink = m_CollDef.Item(pGetFieldName(Preview.RptPrint, IndexField))
  End If
End Function

Private Function pGetDefLinkForGrid() As cRptDefLink
  
  If m_EasyLink Then
    Set pGetDefLinkForGrid = m_CollDef.Item(1)
  Else
    Set pGetDefLinkForGrid = Nothing ' Por ahora no se soporta
  End If
End Function

Private Function pGetRptField(ByVal RptPrint As cReportPrint, _
                              ByVal IndexField As Long) As cReportPageField
  Set pGetRptField = RptPrint.GetField(IndexField)
End Function

Private Function pGetFieldName(ByVal RptPrint As cReportPrint, _
                               ByVal IndexField As Long) As String
  Dim RptField As cReportPageField
  
  Set RptField = RptPrint.GetField(IndexField)
  
  If RptField Is Nothing Then Exit Function

  pGetFieldName = RptField.Info.Name
End Function

Private Function pIsEasyLinkForGrid(ByRef Grid As cGrid) As Boolean
  
  If Grid Is Nothing Then Exit Function
  
  Dim i             As Long
  Dim doctIdFound   As Boolean
  Dim compIdFound   As Boolean
  
  For i = 1 To Grid.Columns
    If Grid.ColumnHeader(i) = c_doct_id Then
      doctIdFound = True
    End If
    If Grid.ColumnHeader(i) = c_comp_id Then
      compIdFound = True
    End If
    
    If doctIdFound And compIdFound Then Exit For
  Next
  
  If Not (doctIdFound And compIdFound) Then Exit Function
  
  pIsEasyLinkForGrid = True
End Function

Private Function pIsEasyLink(ByRef Report As cReport) As Boolean
  
  If Report Is Nothing Then Exit Function
  
  Dim Ctrl          As cReportControl
  Dim doctIdFound   As Boolean
  Dim compIdFound   As Boolean
  
  For Each Ctrl In Report.Controls
    If Ctrl.Name = c_doct_id Then
      doctIdFound = True
    End If
    If Ctrl.Name = c_comp_id Then
      compIdFound = True
    End If
    
    If doctIdFound And compIdFound Then Exit For
  Next
  
  If Not (doctIdFound And compIdFound) Then Exit Function
  
  pIsEasyLink = True
End Function

' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError

  Set m_CollDef = New cRptDefLinks
  Set m_CollFiles = New Collection
  m_DefLoaded = False
  
  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
  On Error GoTo ControlError

  Set m_CollDef = Nothing
  
  CollClear m_CollFiles
  Set m_CollFiles = Nothing
  
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

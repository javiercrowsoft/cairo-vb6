VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cLinkManager"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cLinkManager
' 16-04-2005

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cLinkManager"
Private Const c_ObjABMName = "CSABMInterface2.cABMGeneric"

Private Const c_doct_id = "doct_id"
Private Const c_comp_id = "comp_id"

' estructuras
' variables privadas
Private m_CountReference As Long
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
Public Function ManageLink(ByRef DefLink As cRptDefLink, _
                           ByRef Preview As Object, _
                           ByVal IndexField As Long) As Boolean
  
  ' Si es un documento
  If Len(DefLink.Doct_id) Then
  
    pShowDoc DefLink, Preview, IndexField
  Else
    pShowMaestro DefLink, Preview, IndexField
  End If

End Function
' funciones friend
' funciones privadas
Private Sub pShowMaestro(ByRef DefLink As cRptDefLink, _
                         ByRef Preview As fPreview, _
                         ByVal IndexField As Long)
                     
  Dim sqlstmt       As String
  Dim rs            As ADODB.Recordset
  Dim objectEdit    As String
  Dim objectAbm     As String
  
  sqlstmt = "select tbl_objectEdit, tbl_objectAbm from tabla where tbl_nombrefisico = " _
               & gDB.sqlString(DefLink.Table)
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  If rs.EOF Then Exit Sub
  
  objectEdit = gDB.ValField(rs.Fields, csctblObjectEdit)
  objectAbm = gDB.ValField(rs.Fields, csctblObjectAbm)
  
  If Len(objectAbm) = 0 Or Len(objectEdit) = 0 Then Exit Sub
  
  ' Vemos que tenga permiso
  '
  sqlstmt = "select pre_id from sysmodulo where sysm_objetoedicion = " _
              & gDB.sqlString(objectEdit)
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  If rs.EOF Then Exit Sub
  
  If Not SecurityCanAccess(gDB.ValField(rs.Fields, 0)) Then Exit Sub
  
  Dim oEdit As cIEditGeneric
  
  Set oEdit = CSKernelClient2.CreateObject(objectEdit)
  Set oEdit.ObjABM = CSKernelClient2.CreateObject(objectAbm)
  
  oEdit.Edit Val(pGetRptField(Preview.RptPrint, IndexField, DefLink.Id).Value)
End Sub

Private Sub pShowDoc(ByRef DefLink As cRptDefLink, _
                     ByRef Preview As Object, _
                     ByVal IndexField As Long)
                     
  Dim DocObj  As cIEditGeneric
  Dim DocId   As Long
  Dim DoctId  As Long
                       
  If TypeOf Preview Is fPreview Then
  
    Dim Fld As cReportPageField
    
    Set Fld = pGetRptField(Preview.RptPrint, IndexField, DefLink.Id)
    If Fld Is Nothing Then Exit Sub
    DocId = Val(Fld.Value)
    
    If DocId = csNO_ID Then
      MsgWarning LNGGetText(2744, vbNullString)
      'No hay ningún documento asociado a este link.;;Esto puede deberse a que el link está mostrando Saldos Iniciales.
      Exit Sub
    End If
                         
    Set Fld = pGetRptField(Preview.RptPrint, IndexField, DefLink.Doct_id)
    If Fld Is Nothing Then Exit Sub
    
    DoctId = Val(Fld.Value)
    
  ElseIf TypeOf Preview Is fPreviewGrid Then
    
    DocId = Val(pGetValueFromColumn(Preview.grItems, IndexField, DefLink.Id))
    
    If DocId = csNO_ID Then
      MsgWarning LNGGetText(2744, vbNullString)
      Exit Sub
    End If
    
    DoctId = Val(pGetValueFromColumn(Preview.grItems, IndexField, DefLink.Doct_id))
    If DoctId = csNO_ID Then
      
      Exit Sub
    End If
  End If
  
  Dim DoctObject As String
  Dim PreId      As Long
    
  If Not GetDocumentoTipoInfo(DoctId, _
                              "", _
                              DoctObject, _
                              PreId) Then Exit Sub
    
    
  If Not SecurityCanAccess(PreId) Then Exit Sub
  Set DocObj = CSKernelClient2.CreateObject(DoctObject)
      
  If DoctId < 0 Then
    
    Dim oAbm As cIEditGeneric
    
    Set DocObj.ObjABM = CSKernelClient2.CreateObject(c_ObjABMName)
    Set oAbm = DocObj
  
  Else
    
    Dim oDoc As cIEditGenericDoc
    
    Set DocObj.ObjABM = CSKernelClient2.CreateObject(c_ObjABMName)
    Set oDoc = DocObj
    Set oDoc.Footer = CSKernelClient2.CreateObject(c_ObjABMName)
    Set oDoc.Items = CSKernelClient2.CreateObject(c_ObjABMName)
    
  End If
  
  DocObj.Edit DocId
  
End Sub

Private Function pGetValueFromColumn(ByRef Grid As cGrid, _
                                     ByVal lRow As Long, _
                                     ByVal colName As String) As String
  
  If lRow < 1 Then Exit Function
  If lRow > Grid.Rows Then Exit Function
  
  Dim i As Long
  
  colName = LCase$(colName)
  
  For i = 1 To Grid.Columns
    If LCase$(Grid.ColumnHeader(i)) = colName Then
      If colName = c_comp_id Then
        If IsEmpty(Grid.CellText(lRow, i)) Then
          pGetValueFromColumn = Grid.CellItemData(lRow, i)
        Else
          pGetValueFromColumn = Grid.CellText(lRow, i)
        End If
      
      ElseIf colName = c_doct_id Then
        If IsEmpty(Grid.CellText(lRow, i)) Then
          pGetValueFromColumn = Grid.CellItemData(lRow, i)
        Else
          pGetValueFromColumn = Grid.CellText(lRow, i)
        End If
      
      Else
        pGetValueFromColumn = Grid.CellText(lRow, i)
      End If
      Exit Function
    End If
  Next
End Function

'Private Function pGetRptField(ByVal RptPrint As CSReportPaint2.cReportPrint, _
                              ByVal IndexField As Long, _
                              ByVal key As Variant) As cReportPageField
Private Function pGetRptField(ByVal RptPrint As cReportPrint, _
                              ByVal IndexField As Long, _
                              ByVal key As Variant) As cReportPageField
  If VarType(key) = vbString Then
    Set pGetRptField = pGetFieldFromName(RptPrint, IndexField, key)
  Else
    Set pGetRptField = RptPrint.GetField(IndexField)
  End If
End Function

'Private Function pGetFieldFromName(ByVal RptPrint As CSReportPaint2.cReportPrint, _
                                   ByVal IndexField As Long, _
                                   ByVal FieldName As String) As cReportPageField
Private Function pGetFieldFromName(ByVal RptPrint As cReportPrint, _
                                   ByVal IndexField As Long, _
                                   ByVal FieldName As String) As cReportPageField
  Dim Fields As cReportPageFields
  Set Fields = RptPrint.GetLine(IndexField)
  
  Dim Fld As cReportPageField
  
  For Each Fld In Fields
    ' Debug.Print Fld.Info.Name
    If LCase(Fld.Info.Name) = FieldName Then
      Exit For
    End If
  Next
  
  Set pGetFieldFromName = Fld
End Function

' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
  On Error GoTo ControlError

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


'///////////////////////////////////////////////////////////////////////////////////////////////
' Para depurar
'

'  pGetInfoLink DefLink, Preview, IndexField
'
'Private Sub pGetInfoLink(ByRef DefLink As cRptDefLink, _
'                         ByRef Preview As Object, _
'                         ByVal IndexField As Long)
'
'  Dim fPreview As fPreview
'  Dim msg      As String
'  Dim doct_id  As Long
'
'  Set fPreview = Preview
'
'  With DefLink
'
'    If Not pGetRptField(fPreview.RptPrint, IndexField, .doct_id) Is Nothing Then
'      doct_id = Val(pGetRptField(fPreview.RptPrint, IndexField, .doct_id).Value)
'    End If
'    msg = "id= " & .Id & " Valor=" & pGetRptField(fPreview.RptPrint, IndexField, .Id).Value & vbCrLf & _
'          "doct_id= " & .doct_id & " Valor=" & doct_id & vbCrLf & _
'          "table=" & .Table & vbCrLf & _
'          "param_info=" & .ParamInfo
'  End With
'
'  MsgInfo msg
'End Sub

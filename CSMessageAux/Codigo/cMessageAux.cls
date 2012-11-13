VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cMessageAux"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Private Const c_ObjABMName = "CSABMInterface2.cABMGeneric"

Private Const c_doct_id     As String = "doct_id"
Private Const c_comp_id     As String = "comp_id"
Private Const cscDoctNombre As String = "doct_nombre"
Private Const cscDoctObject As String = "doct_object"
Private Const cscPreID      As String = "pre_id"

Private Const csNoDate          As Date = #1/1/1900#
Private Const cscActivo         As String = "activo"

Private WithEvents m_fInfo As fInfo
Attribute m_fInfo.VB_VarHelpID = -1
Private m_db               As Object

Public Sub ShowMessageFromRecordset(ByVal InfoTitle As String, _
                                    ByRef rs As Recordset, _
                                    ByRef db As Object)
  Dim f   As fInfo
  Dim Fld As Field
  Dim i   As Long
  
  Set f = New fInfo
  Set m_db = db
  
  f.FormName = InfoTitle
  Load f
  
  With f.grdInfo
    .GridLines = True
    
    For Each Fld In rs.fields
      .AddColumn , Fld.Name, , , 165, InStr(1, Fld.Name, "_ID", vbTextCompare) = 0
    Next
    
    Dim n As Integer
    
    While Not rs.EOF
      .AddRow
      For Each Fld In rs.fields
        i = i + 1
        .CellDetails .Rows, i, ValField_(rs.fields, n)
        n = n + 1
      Next
      i = 0
      n = 0
      rs.MoveNext
    Wend
  End With
  
  f.grdInfo.AutoWidthColumns
  
  Dim mouse As cMouse
  Set mouse = New cMouse
  mouse.MouseDefault
  
  Set m_fInfo = f
  Set f.AuxRef = Me
  
  f.Show vbModeless
End Sub

Private Function ValField_(ByRef fields As ADODB.fields, ByVal FieldName As String, Optional ByRef FieldType As csFieldType) As Variant
  On Error GoTo ControlError
  
  Dim Field As ADODB.Field
  
  If IsNumeric(FieldName) Then
    Set Field = fields(CInt(FieldName))
  Else
    Set Field = fields(FieldName)
  End If
  
  If Field Is Nothing Then
    Err.Raise vbObjectError + csErrorVal, "VAL function CSOAPI", "No se paso un campo. Error interno"
  End If
  
  If IsNull(Field.Value) Then
    Select Case Field.Type
      Case adLongVarChar, adLongVarWChar, adChar, adVarChar, adVarWChar, adWChar
        ValField_ = ""
      Case adBigInt, adBinary, adInteger, adLongVarBinary, adNumeric, adSmallInt, adTinyInt, adUnsignedBigInt, adUnsignedInt, adUnsignedSmallInt, adUnsignedTinyInt
        ValField_ = 0
      Case adBoolean
        ValField_ = False
      Case adCurrency, adSingle, adDecimal, adDouble
        ValField_ = 0
      Case adDBTime, adDate, adDBDate
        ValField_ = csNoDate
      Case adDBTimeStamp
        ValField_ = csNoDate
    End Select
  Else
    ValField_ = Field.Value
  End If
  
  ' Comprobacion especial para el field activo
  If LCase(Field.Name) = cscActivo Then
    FieldType = csFieldBoolean
  End If

  Exit Function
ControlError:
  If Err.Number = 3265 Then Err.Description = "Falto el campo " & FieldName & vbCrLf & "Descripción original:" & Err.Description
  Err.Raise Err.Number, Err.Source, Err.Description, Err.HelpFile, Err.HelpContext
End Function

Private Sub pShowDoc(ByRef f As fInfo, _
                     ByVal lRow As Long)
                     
  Dim DocObj  As cIEditGeneric
  Dim DocId   As Long
  Dim DoctId  As Long
                       
  DocId = Val(pGetValueFromColumn(f.grdInfo, lRow, "comp_id"))
  
  If DocId = csNO_ID Then
    MsgWarning "No hay ningún documento asociado a este link."
    Exit Sub
  End If
  
  DoctId = Val(pGetValueFromColumn(f.grdInfo, lRow, "doct_id"))
  If DoctId = csNO_ID Then Exit Sub
  
  Dim DoctObject As String
  Dim PreId      As Long
    
  If Not pGetDocumentoTipoInfo(DoctId, _
                               "", _
                               DoctObject, _
                               PreId) Then Exit Sub
    
    
  If Not SecurityCanAccess(PreId) Then Exit Sub
  Set DocObj = CSKernelClient2.CreateObject(DoctObject)
      
  Dim oDoc As cIEditGenericDoc
  
  Set DocObj.ObjABM = CSKernelClient2.CreateObject(c_ObjABMName)
  Set oDoc = DocObj
  Set oDoc.Footer = CSKernelClient2.CreateObject(c_ObjABMName)
  Set oDoc.Items = CSKernelClient2.CreateObject(c_ObjABMName)
  
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
      Else
        pGetValueFromColumn = Grid.CellText(lRow, i)
      End If
      Exit Function
    End If
  Next
End Function

Private Function pGetDocumentoTipoInfo(ByVal doct_id As Long, _
                                       ByRef doct_nombre As String, _
                                       ByRef doct_object As String, _
                                       ByRef pre_id As Long) As Boolean

  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  If m_db Is Nothing Then Exit Function
  
  sqlstmt = "select doct_nombre, doct_object, pre_id from documentoTipo where doct_id = " & doct_id
  
  If Not m_db.OpenRs(sqlstmt, rs) Then Exit Function
  If rs.EOF Then Exit Function
  
  doct_nombre = m_db.ValField(rs.fields, cscDoctNombre)
  doct_object = m_db.ValField(rs.fields, cscDoctObject)
  pre_id = m_db.ValField(rs.fields, cscPreID)
  
  pGetDocumentoTipoInfo = True
End Function

Private Sub m_fInfo_grdInfoDblClick(ByVal lRow As Long, ByVal lCol As Long)
  pShowDoc m_fInfo, lRow
End Sub

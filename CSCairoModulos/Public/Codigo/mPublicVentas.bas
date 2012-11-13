Attribute VB_Name = "mPublicVentas"
Option Explicit

Private Const C_PRINT_SERVICE_STATE_WRITING = 1
Private Const C_PRINT_SERVICE_STATE_READY = 2

Public Sub ShowDataAddCliente(ByVal bShowData As Boolean, _
                              ByRef AbmObj As cABMGeneric)

  If bShowData Then
    Dim CliId   As Long
    Dim ObjAbm  As cIABMGeneric
    Dim iProp   As cIABMProperty
    Dim dataAdd As String
    
    Set ObjAbm = AbmObj
    CliId = ObjAbm.Properties.Item(cscCliId).HelpId
    
    If CliId Then
    
      Dim sqlstmt As String
      Dim rs      As ADODB.Recordset
      
      sqlstmt = "sp_ClienteGetDataAdd " & CliId
      If gDB.OpenRs(sqlstmt, rs) Then
        If Not rs.EOF Then
          dataAdd = gDB.ValField(rs.fields, 0)
        End If
      End If
    End If
    
    Set iProp = ObjAbm.Properties.Item(c_ClienteDataAdd)
    iProp.Value = dataAdd
    AbmObj.ShowValue iProp
  End If
End Sub

Public Function facturaVentaGetCAE(ByVal fv_id As Long) As Boolean
  Dim sqlstmt As String
  Dim rs As ADODB.Recordset
  
  sqlstmt = "sp_FE_RequestCae " & fv_id
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  If rs.EOF Then Exit Function
  
  MsgInfo gDB.ValField(rs.fields, "info")
  facturaVentaGetCAE = gDB.ValField(rs.fields, "success")
End Function

Public Function facturaVentaSendCAEByEmail(ByVal fvId As Long) As Boolean
  Dim rs As Recordset
  Dim sqlstmt As String
  
  sqlstmt = "select fv_nrodoc, fv_cae" _
            & " from FacturaVenta fv" _
            & " where fv.fv_id = " & fvId & " and fv_cae <> ''"

  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  If rs.EOF Then Exit Function
  
  If gDB.ValField(rs.fields, cscFvCAE) = "" Then
  
    MsgInfo LNGGetText(5132, vbNullString, gDB.ValField(rs.fields, cscFvNrodoc)) ' La factura #1# aun no tiene CAE
    Exit Function
  
  End If
  
  sqlstmt = "select fv.doc_id, fv.emp_id, fv.fv_nrodoc, emp.emp_nombre" _
            & " from FacturaVenta fv inner join Empresa emp on fv.emp_id = emp.emp_id" _
            & " where fv.fv_id = " & fvId

  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function

  Dim docId As Long
  Dim empId As Long
  Dim fvNroDoc As String
  Dim empNombre As String

  If rs.EOF Then Exit Function

  docId = gDB.ValField(rs.fields, "doc_id")
  empId = gDB.ValField(rs.fields, "emp_id")
  empNombre = gDB.ValField(rs.fields, "emp_nombre")
  fvNroDoc = gDB.ValField(rs.fields, "fv_nrodoc")

  Dim timp_id As Long

  timp_id = pGetTrabajoImpresionId(docId, fvId, empId, fvNroDoc, empNombre)
  If timp_id = 0 Then Exit Function

  '-------------------------------------------------------------------------
  ' reports
  '
  sqlstmt = "select rptf_nombre, rptf_csrfile, rptf_object" & _
            " from reporteformulario" & _
            " where rptf_sugerido <> 0 and doc_id = " & docId

  sqlstmt = sqlstmt & " and activo <> 0"

  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function


  While Not rs.EOF

    If Not pPrintReportToService( _
                                  timp_id, _
                                  gDB.ValField(rs.fields, "rptf_nombre"), _
                                  gDB.ValField(rs.fields, "rptf_csrfile"), _
                                  2, _
                                  gDB.ValField(rs.fields, "rptf_object")) Then Exit Function
    rs.MoveNext
  Wend

  If Not pSetTrabajoImpresionStateReadyToPrint(timp_id, docId, fvId, empId) Then Exit Function

  facturaVentaSendCAEByEmail = True
End Function

Private Function pGetTrabajoImpresionId(ByVal docId As Long, ByVal fvId As Long, ByVal empId As Long, ByVal fvNroDoc As String, ByVal empNombre As String) As Long
  Dim sqlstmt As String
  Dim rs As Recordset

  sqlstmt = "sp_TrabajoImpresionSave 0, " _
                            & gDB.sqlDate(Now) & "," _
                            & gDB.sqlString(GetComputerName()) & "," _
                            & C_PRINT_SERVICE_STATE_WRITING & "," _
                            & "0," _
                            & docId & "," _
                            & fvId & "," _
                            & "1," _
                            & empId & "," _
                            & "1," _
                            & gDB.sqlString(empNombre & ": Comprobante de Factura Electronica " & fvNroDoc)

  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  If rs.EOF Then Exit Function

  pGetTrabajoImpresionId = gDB.ValField(rs.fields, "timp_id")

End Function

Private Function pSetTrabajoImpresionStateReadyToPrint(ByVal timp_id As Long, ByVal docId As Long, ByVal fvId As Long, ByVal empId As Long) As Boolean
  Dim sqlstmt As String

  sqlstmt = "sp_TrabajoImpresionSave " & timp_id & ", " _
                            & gDB.sqlDate(Now) & "," _
                            & gDB.sqlString(GetComputerName()) & "," _
                            & C_PRINT_SERVICE_STATE_READY & "," _
                            & "0," _
                            & docId & "," _
                            & fvId & "," _
                            & "1," _
                            & empId

  If Not gDB.Execute(sqlstmt) Then Exit Function

  pSetTrabajoImpresionStateReadyToPrint = True

End Function

Private Function pPrintReportToService(ByVal timp_id As Long, _
                                       ByVal rptName As String, _
                                       ByVal rptFile As String, _
                                       ByVal copies As Long, _
                                       ByVal strObject As String) As Boolean
  Dim sqlstmt As String

  sqlstmt = "sp_TrabajoImpresionSaveItem " _
                            & timp_id & ", " _
                            & "0," _
                            & gDB.sqlString(rptName) & "," _
                            & gDB.sqlString(rptFile) & "," _
                            & "2," _
                            & copies & "," _
                            & gDB.sqlString(strObject)

  pPrintReportToService = gDB.Execute(sqlstmt)

End Function


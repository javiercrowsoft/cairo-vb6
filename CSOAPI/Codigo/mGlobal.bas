Attribute VB_Name = "mGlobal"
Option Explicit

'--------------------------------------------------------------------------------
' mGlobal
' 18-01-00

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "mGlobal"

Private Enum csTvImage
  c_img_down = 1
  c_img_up
End Enum
' estructuras

Public Type t_ChartDataEvol
  Anio  As Long
  Mes   As Long
  Total As Double
End Type

Public Type t_ChartDataProd
  Producto  As String
  Total     As Double
End Type

' variables privadas
' variables publicas
Public G_FormResult As Boolean
Public G_InputValue As String   ' Usada por fEdit para devolver el resultado.

' funciones publicas
Public Function ListViewSortColumns(ByRef grData As ListView, ByVal ColumnHeader As MSComctlLib.ColumnHeader)
  On Error Resume Next

  Dim i As Integer
  
  For i = 1 To grData.ColumnHeaders.Count
    grData.ColumnHeaders(i).Icon = 0
  Next
  
  grData.SortKey = ColumnHeader.Index - 1
  If grData.SortOrder = lvwAscending Then
    grData.SortOrder = lvwDescending
    ColumnHeader.Icon = c_img_down
  Else
    grData.SortOrder = lvwAscending
    ColumnHeader.Icon = c_img_up
    ColumnHeader.Alignment = lvwColumnLeft
  End If
  grData.Sorted = True
End Function

Public Sub ShowInfo_(ByVal InfoTitle As String, ByRef rs As Recordset)
  Dim F         As fInfo
  Dim fld       As Field
  Dim fldName   As String
  Dim lngColor  As Long
  Dim strSpaces As String
  
  Set F = New fInfo
  
  F.FormName = InfoTitle
  Load F
  
  Dim oFont       As StdFont
  Dim oFontValue  As StdFont
  
  Set oFont = New StdFont
  With oFont
    .Name = "Arial"
    .Bold = True
  End With
  
  Set oFontValue = New StdFont
  With oFontValue
    .Name = "Arial"
  End With
  
  With F.grdInfo
    .GridLines = True
    .AddColumn , , , , 20
    .AddColumn , , , , 200
    .AddColumn , , , , 300
    Do While Not rs.EOF
      For Each fld In rs.Fields
        If InStr(1, fld.Name, "_ID", vbTextCompare) = 0 Then
          .AddRow
          .CellDetails .Rows, 1, , , , &HCCCCCC
          If InStr(fld.Name, "---") Then
            .CellDetails .Rows, 2, Replace(fld.Name, "---", ""), , , &HCCCCCC, , oFont
            .CellDetails .Rows, 3, Replace(gDB.ValField(rs.Fields, fld.Name), "---", ""), , , &HCCCCCC
          Else
            lngColor = &H0
            oFontValue.Bold = False
            oFontValue.Size = 8
            strSpaces = "                              "
            If InStr(1, fld.Name, "-(-(") Then
              .CellDetails .Rows, 2, "        " & Mid(fld.Name, 1, InStr(1, fld.Name, "-(-(") - 1), , , &HCCCCCC, , oFont
            ElseIf InStr(1, fld.Name, "#") Then
              If InStr(1, fld.Name, "#Red") Then
                fldName = Mid(fld.Name, 1, InStr(1, fld.Name, "#Red") - 1)
                lngColor = &HFF
                oFontValue.Bold = True
                oFontValue.Size = 12
                strSpaces = "                      "
              ElseIf InStr(1, fld.Name, "#Blue") Then
                fldName = Mid(fld.Name, 1, InStr(1, fld.Name, "#Blue") - 1)
                lngColor = &HCC0000
                oFontValue.Bold = True
                oFontValue.Size = 12
                strSpaces = "                      "
              End If
              .CellDetails .Rows, 2, "        " & fldName, , , &HCCCCCC, , oFont
            Else
              .CellDetails .Rows, 2, "        " & fld.Name, , , &HCCCCCC, , oFont
            End If
            
            Select Case fld.Type
              Case adCurrency, adSingle, adDecimal, adDouble, adNumeric
                .CellDetails .Rows, 3, "    " & Format(gDB.ValField(rs.Fields, fld.Name), "#,###,###,##0.00") & strSpaces, DT_RIGHT, , &HEEEEEE, lngColor, oFontValue
              Case adBigInt, adBinary, adInteger, adLongVarBinary, adSmallInt, adTinyInt, adUnsignedBigInt, adUnsignedInt, adUnsignedSmallInt, adUnsignedTinyInt
                .CellDetails .Rows, 3, Format(gDB.ValField(rs.Fields, fld.Name), "#,###,###,##0") & strSpaces, DT_RIGHT, , &HEEEEEE, lngColor, oFontValue
              Case Else
              .CellDetails .Rows, 3, "    " & gDB.ValField(rs.Fields, fld.Name), , , &HEEEEEE, lngColor, oFontValue
            End Select
          End If
        End If
      Next
      Set rs = rs.NextRecordset
      If rs Is Nothing Then Exit Do
    Loop
  End With
  
  Dim Mouse As cMouse
  Set Mouse = New cMouse
  
  Mouse.MouseDefault
  
  F.Show vbModal
End Sub

Public Sub ShowInfoRows_(ByVal InfoTitle As String, ByRef rs As Recordset)
  Dim F   As fInfo
  Dim fld As Field
  Dim i   As Long
  
  Set F = New fInfo
  
  F.FormName = InfoTitle
  Load F
  
  With F.grdInfo
    .GridLines = True
    
    For Each fld In rs.Fields
      If InStr(1, fld.Name, "_ID", vbTextCompare) = 0 Then
        .AddColumn , fld.Name, , , 165
      End If
    Next
      
    While Not rs.EOF
      .AddRow
      For Each fld In rs.Fields
        If InStr(1, fld.Name, "_ID", vbTextCompare) = 0 Then
          i = i + 1
          .CellDetails .Rows, i, gDB.ValField(rs.Fields, fld.Name)
        End If
      Next
      i = 0
      rs.MoveNext
    Wend
  End With
  
  Dim Mouse As cMouse
  Set Mouse = New cMouse
  
  Mouse.MouseDefault
  
  F.Show vbModal
End Sub

Public Sub ShowNotes_(ByVal InfoTitle As String, _
                      ByVal sqlstmt As String, _
                      ByVal ObjectEdit As String, _
                      ByVal ObjectABM As String)
  Dim F   As fInfo
  
  Set F = New fInfo
  
  F.IsNotes = True
  F.FormName = InfoTitle
  Load F
  
  If LenB(ObjectEdit) Then
    F.ObjectEdit = ObjectEdit
  End If
  If LenB(ObjectABM) Then
    F.ObjectABM = ObjectABM
  End If
  
  Dim Grid As cGridManager
  Set Grid = New cGridManager
  
  Grid.SetPropertys F.grdInfo
  
  Grid.LoadFromSqlstmt F.grdInfo, sqlstmt, Nothing
  
  Dim Mouse As cMouse
  Set Mouse = New cMouse
  
  Mouse.MouseDefault
  
  F.Show vbModal

End Sub

Public Sub ShowInfoCliente_(ByVal cli_id As Long, _
                            Optional ByRef F As fInfoCliente, _
                            Optional ByVal bShowModal As Boolean = True)
  
  Dim bShow As Boolean
  
  If F Is Nothing Then
    Dim cli_nombre As String
    
    If Not gDB.GetData("Cliente", "cli_id", cli_id, _
                        "cli_nombre", cli_nombre) Then Exit Sub
    
    Set F = New fInfoCliente
    Load F
    
    F.txHlCliente.Text = cli_nombre
    F.cli_id = cli_id
  
    bShow = True
  End If
  
  Const c_format_saldo = "#,###,###,##0.00"
  
  Dim Saldo       As Double
  Dim CtaCte      As Double
  Dim Documentos  As Double
  Dim Remitos     As Double
  Dim Pedidos     As Double
  Dim CreditoCC   As Double
  Dim Credito     As Double
  
  Dim sqlstmt As String
  Dim Mouse   As cMouseWait
  
  Set Mouse = New cMouseWait
  
  sqlstmt = "sp_infoClienteVentas " & gUser.Id & "," & gEmpId & "," & cli_id
  pShowInfoGrid sqlstmt, F.grdVentas, True, Saldo, "pendiente"
  F.grdVentas.AutoWidthColumns
  F.lbVentas.Caption = Format(Saldo, c_format_saldo)
  
  sqlstmt = "sp_infoClienteCobranzas " & gUser.Id & "," & gEmpId & "," & cli_id
  pShowInfoGrid sqlstmt, F.grdCobranzas, True, Saldo, "total"
  F.grdCobranzas.AutoWidthColumns
  F.lbCobranzas.Caption = Format(Saldo, c_format_saldo)
  
  sqlstmt = "sp_infoClienteCheques " & gUser.Id & "," & gEmpId & "," & cli_id
  pShowInfoGrid sqlstmt, F.grdCheques, True, Saldo, "total"
  F.grdCheques.AutoWidthColumns
  F.lbCheques.Caption = Format(Saldo, c_format_saldo)
  
  sqlstmt = "sp_infoClientePartes " & gUser.Id & "," & gEmpId & "," & cli_id
  pShowInfoGrid sqlstmt, F.grdPartes
  F.grdPartes.AutoWidthColumns
  
  sqlstmt = "sp_infoClientePedidos " & gUser.Id & "," & gEmpId & "," & cli_id
  pShowInfoGrid sqlstmt, F.grdPedidos, True, Saldo, "pendiente"
  F.grdPedidos.AutoWidthColumns
  F.lbPedidos.Caption = Format(Saldo, c_format_saldo)
  
  sqlstmt = "sp_infoClienteProductos " & gUser.Id & "," & gEmpId & "," & cli_id
  pShowInfoGrid sqlstmt, F.grdProductos
  F.grdProductos.AutoWidthColumns
  
  Dim rs    As ADODB.Recordset
  
  sqlstmt = "sp_infoClienteSaldo " & gUser.Id & "," & gEmpId & "," & cli_id
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  If Not rs.EOF Then
    Saldo = gDB.ValField(rs.Fields, "saldo")
    CtaCte = gDB.ValField(rs.Fields, "cli_deudactacte")
    Documentos = gDB.ValField(rs.Fields, "cli_deudadoc")
    Remitos = gDB.ValField(rs.Fields, "cli_deudaremito")
    Pedidos = gDB.ValField(rs.Fields, "cli_deudapedido")
    CreditoCC = gDB.ValField(rs.Fields, "cli_creditoctacte")
    Credito = gDB.ValField(rs.Fields, "cli_creditototal")
  End If
  
  F.lbSaldo.Caption = Format(Saldo, c_format_saldo)
  F.lbCtaCte.Caption = Format(CtaCte, c_format_saldo)
  F.lbDocumentos.Caption = Format(Documentos, c_format_saldo)
  F.lbRemitos.Caption = Format(Remitos, c_format_saldo)
  F.lbPedidosSaldo.Caption = Format(Pedidos, c_format_saldo)
  F.lbCreditoCC.Caption = Format(CreditoCC, c_format_saldo)
  F.lbCreditoTotal.Caption = Format(Credito, c_format_saldo)
  
  If CreditoCC - CtaCte < Credito - Saldo Then
    F.lbDisponible.Caption = Format(CreditoCC - CtaCte, c_format_saldo)
  Else
    F.lbDisponible.Caption = Format(Credito - Saldo, c_format_saldo)
  End If
  
  If Val(F.lbDisponible.Caption) < 0 Then
    F.lbDisponible.ForeColor = vbRed
  Else
    F.lbDisponible.ForeColor = vbBlue
  End If
  
  If Saldo > Credito Then
    F.lbEstado.Caption = "Crédito Excedido"
    F.lbEstado.ForeColor = vbRed
  Else
    F.lbEstado.Caption = "Crédito OK"
    F.lbEstado.ForeColor = vbBlue
  End If
  
  sqlstmt = "sp_infoClienteChartVentas " & gUser.Id & "," & gEmpId & "," & cli_id
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  F.SetChartDataEvol rs
  
  MakeChartEvol F, F.SmallChart, F.ChartEvolHeight, F.ChartEvolWidth
  
  sqlstmt = "sp_infoClienteChartProductos " & gUser.Id & "," & gEmpId & "," & cli_id
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  F.SetChartDataProd rs
  
  MakeChartProd F, F.SmallChart, F.ChartProdHeight, F.ChartProdWidth
  
  Set Mouse = Nothing
  
  If bShow Then
    F.NonModalAllowed = Not bShowModal
    If bShowModal Then
      F.Show vbModal
    Else
      pShowFormCli F
    End If
  End If
End Sub

Private Sub pShowFormCli(ByRef F As fInfoCliente)
  On Error Resume Next
  
  Err.Clear
  
  F.Show vbModeless
  
  If Err.Number = 401 Then
    Err.Clear
    F.NonModalAllowed = True
    F.Show vbModal
  End If

End Sub

Public Sub ShowInfoProveedor_(ByVal prov_id As Long, _
                              Optional ByRef F As fInfoProveedor, _
                              Optional ByVal bShowModal As Boolean = True)
  
  Dim bShow As Boolean
  
  If F Is Nothing Then
    Dim prov_nombre As String
    
    If Not gDB.GetData("Proveedor", "prov_id", prov_id, _
                        "prov_nombre", prov_nombre) Then Exit Sub
    
    Set F = New fInfoProveedor
    Load F
    
    F.txHlProveedor.Text = prov_nombre
    F.prov_id = prov_id
  
    bShow = True
  End If
  
  Const c_format_saldo = "#,###,###,##0.00"
  
  Dim Saldo       As Double
  Dim CtaCte      As Double
  Dim Documentos  As Double
  Dim Remitos     As Double
  Dim Pedidos     As Double
  Dim CreditoCC   As Double
  Dim Credito     As Double
  
  Dim sqlstmt As String
  Dim Mouse   As cMouseWait
  
  Set Mouse = New cMouseWait
  
  sqlstmt = "sp_infoProveedorCompras " & gUser.Id & "," & gEmpId & "," & prov_id
  pShowInfoGrid sqlstmt, F.grdCompras, True, Saldo, "pendiente"
  F.grdCompras.AutoWidthColumns
  F.lbCompras.Caption = Format(Saldo, c_format_saldo)
  
  sqlstmt = "sp_infoProveedorPagos " & gUser.Id & "," & gEmpId & "," & prov_id
  pShowInfoGrid sqlstmt, F.grdPagos, True, Saldo, "total"
  F.grdPagos.AutoWidthColumns
  F.lbPagos.Caption = Format(Saldo, c_format_saldo)
  
  sqlstmt = "sp_infoProveedorCheques " & gUser.Id & "," & gEmpId & "," & prov_id
  pShowInfoGrid sqlstmt, F.grdCheques, True, Saldo, "total"
  F.grdCheques.AutoWidthColumns
  F.lbCheques.Caption = Format(Saldo, c_format_saldo)
  
  sqlstmt = "sp_infoProveedorPartes " & gUser.Id & "," & gEmpId & "," & prov_id
  pShowInfoGrid sqlstmt, F.grdPartes
  F.grdPartes.AutoWidthColumns
  
  sqlstmt = "sp_infoProveedorPedidos " & gUser.Id & "," & gEmpId & "," & prov_id
  pShowInfoGrid sqlstmt, F.grdPedidos, True, Saldo, "pendiente"
  F.grdPedidos.AutoWidthColumns
  F.lbPedidos.Caption = Format(Saldo, c_format_saldo)
  
  sqlstmt = "sp_infoProveedorProductos " & gUser.Id & "," & gEmpId & "," & prov_id
  pShowInfoGrid sqlstmt, F.grdProductos
  F.grdProductos.AutoWidthColumns
  
  Dim rs    As ADODB.Recordset
  
  sqlstmt = "sp_infoProveedorSaldo " & gUser.Id & "," & gEmpId & "," & prov_id
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  If Not rs.EOF Then
    Saldo = gDB.ValField(rs.Fields, "saldo")
    CtaCte = gDB.ValField(rs.Fields, "prov_deudactacte")
    Documentos = gDB.ValField(rs.Fields, "prov_deudadoc")
    Remitos = gDB.ValField(rs.Fields, "prov_deudaremito")
    Pedidos = gDB.ValField(rs.Fields, "prov_deudaorden")
    CreditoCC = gDB.ValField(rs.Fields, "prov_creditoctacte")
    Credito = gDB.ValField(rs.Fields, "prov_creditototal")
  End If
  
  F.lbSaldo.Caption = Format(Saldo, c_format_saldo)
  F.lbCtaCte.Caption = Format(CtaCte, c_format_saldo)
  F.lbDocumentos.Caption = Format(Documentos, c_format_saldo)
  F.lbRemitos.Caption = Format(Remitos, c_format_saldo)
  F.lbPedidosSaldo.Caption = Format(Pedidos, c_format_saldo)
  F.lbCreditoCC.Caption = Format(CreditoCC, c_format_saldo)
  F.lbCreditoTotal.Caption = Format(Credito, c_format_saldo)
  
  If CreditoCC - CtaCte < Credito - Saldo Then
    F.lbDisponible.Caption = Format(CreditoCC - CtaCte, c_format_saldo)
  Else
    F.lbDisponible.Caption = Format(Credito - Saldo, c_format_saldo)
  End If
  
  If Val(F.lbDisponible.Caption) < 0 Then
    F.lbDisponible.ForeColor = vbRed
  Else
    F.lbDisponible.ForeColor = vbBlue
  End If
  
  If Saldo > Credito Then
    F.lbEstado.Caption = "Crédito Excedido"
    F.lbEstado.ForeColor = vbRed
  Else
    F.lbEstado.Caption = "Crédito OK"
    F.lbEstado.ForeColor = vbBlue
  End If
  
  sqlstmt = "sp_infoProveedorChartCompras " & gUser.Id & "," & gEmpId & "," & prov_id
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  F.SetChartDataEvol rs
  
  MakeChartEvol F, F.SmallChart, F.ChartEvolHeight, F.ChartEvolWidth
  
  sqlstmt = "sp_infoProveedorChartProductos " & gUser.Id & "," & gEmpId & "," & prov_id
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  F.SetChartDataProd rs
  
  MakeChartProd F, F.SmallChart, F.ChartProdHeight, F.ChartProdWidth
  
  Set Mouse = Nothing
  
  If bShow Then
    F.NonModalAllowed = Not bShowModal
    If bShowModal Then
      F.Show vbModal
    Else
      pShowFormProv F
    End If
  End If
End Sub

Private Sub pShowFormProv(ByRef F As fInfoProveedor)
  On Error Resume Next
  
  Err.Clear
  
  F.Show vbModeless
  
  If Err.Number = 401 Then
    Err.Clear
    F.NonModalAllowed = True
    F.Show vbModal
  End If

End Sub

Private Sub pShowInfoGrid(ByVal sqlstmt As String, _
                          ByRef grd As cGrid, _
                          Optional ByVal bCalcSaldo As Boolean, _
                          Optional ByRef Saldo As Double, _
                          Optional ByVal col_name_saldo As String)
  Dim Grid As cGridManager
  Set Grid = New cGridManager
  
  Grid.SetPropertys grd
  Grid.LoadFromSqlstmt grd, sqlstmt, Nothing

  If bCalcSaldo Then
    
    Dim i     As Long
    Dim iCol  As Long
    
    Saldo = 0
    
    For i = 1 To grd.Columns
      If LCase$(grd.ColumnHeader(i)) = col_name_saldo Then
        iCol = i
        Exit For
      End If
    Next
    
    If iCol > 0 Then
      For i = 1 To grd.Rows
        Saldo = Saldo + pVal(grd.CellText(i, iCol))
      Next
    End If
  End If
End Sub

Public Function RsSort(ByRef rs As Recordset, ByVal iCol As Integer)
  On Error Resume Next
  rs.Sort = rs.Fields(iCol).Name
End Function

' funciones privadas

' No tengo puta idea de porque la funcion Val de
' visual basic me devuelve 94 si le paso 94,365.38
' y la funcion cdbl anda joya, Ojo con configuracion
' regional en "." para decimales.
'
Private Function pVal(ByVal strVal As String) As Double
  If IsNumeric(strVal) Then
    pVal = CDbl(strVal)
  Else
    pVal = 0
  End If
End Function
' construccion - destruccion

'--------------------------------------------------------------------
Public Sub MakeChartProd(ByRef F As Object, _
                         ByVal bSmall As Boolean, _
                         ByVal Height As Single, _
                         ByVal Width As Single)
                     
  On Error GoTo ControlError
  
  Dim Title As String
  Dim Chart As Object
  Dim coef As Single
  
  Set Chart = CSKernelClient2.CreateObject("CSChartServer.cWebChart")
  
  If bSmall Then
    Chart.ShowTitle = False
  Else
    If TypeOf F Is fInfoCliente Then
      Title = "Ventas por Artículo"
    Else
      Title = "Compras por Artículo"
    End If
    If DivideByCero(Width, Height) > 1.7 Then
      Chart.ShowLegendUnderPie = False
      coef = 0.6
    Else
      Chart.ShowLegendUnderPie = True
      coef = 0.4
    End If
  End If
  
  ' 0 = Pie
  Chart.NewChartType 0, Title
  
  F.FillChartProd Chart
  
  Chart.ShowValues = True
  Chart.ShowLegend = True
  
  Chart.Thickness = 8
  Chart.Diameter = IIf(bSmall, 70, (Height / 1320) * coef * 70)
  
  Chart.Format = 1 ' Jpg
  Chart.SaveTo = 1 ' File
  
  Dim tempfile As String
  
  tempfile = Environ$("TEMP") & "\~prod.jpg"
  pKillFile tempfile
  
  Chart.FileName = tempfile
  
  Chart.CopyRight = ""
  Chart.RenderWebChartImage
  
  pShowChartProd F, tempfile
  
  GoTo ExitProc
ControlError:
  If Err.Number Then
    MngError Err, "MakeChartProd", C_Module, vbNullString
    Resume ExitProc
  End If
ExitProc:
  On Error Resume Next
  Chart.Dispose
  Set Chart = Nothing
End Sub

Public Sub MakeChartEvol(ByRef F As Object, _
                         ByVal bSmall As Boolean, _
                         ByVal Height As Single, _
                         ByVal Width As Single)
                     
  On Error GoTo ControlError
  
  Dim Title As String
  Dim Chart As Object
  Set Chart = CSKernelClient2.CreateObject("CSChartServer.cWebChart")
  
  If bSmall Then
    Chart.ShowTitle = False
  Else
    If TypeOf F Is fInfoCliente Then
      Title = "Ventas del Ultimo Semestre"
    Else
      Title = "Compras del Ultimo Semestre"
    End If
  End If
  
  ' 1 = Bar
  Chart.NewChartType 1, Title
  
  F.FillChartEvol Chart
  
  If bSmall Then
    Chart.BarHeight = 100
  Else
    If Height Then
      Chart.BarHeight = (Height / 1320) * 0.7 * 100
    End If
  End If
  
  Chart.ColorAlternate = -24454
  Chart.ColorPrimary = -5952982
  
  Chart.GridLines = 1
  Chart.OutlineBars = True
  Chart.ShowValues = True
  Chart.ShowLegend = False
  
  Chart.Format = 1 ' Jpg
  Chart.SaveTo = 1 ' File
  
  Dim tempfile As String
  
  tempfile = Environ$("TEMP") & "\~evol.jpg"
  pKillFile tempfile
  
  Chart.FileName = tempfile
  
  Chart.CopyRight = ""
  Chart.RenderWebChartImage
  
  pShowChartEvol F, tempfile
  
  GoTo ExitProc
ControlError:
  If Err.Number Then
    MngError Err, "MakeChartEvol", C_Module, vbNullString
    Resume ExitProc
  End If
ExitProc:
  On Error Resume Next
  Chart.Dispose
  Set Chart = Nothing
End Sub

Private Sub pKillFile(ByVal FullFile As String)
  On Error Resume Next
  Kill FullFile
End Sub

Private Sub pShowChartProd(ByRef F As Object, _
                           ByVal FullFile As String)
  On Error Resume Next
  Set F.imgChartProducto.Picture = LoadPicture(FullFile)
  F.ShowChartProd
End Sub

Private Sub pShowChartEvol(ByRef F As Object, _
                           ByVal FullFile As String)
  On Error Resume Next
  Set F.imgChartEvol.Picture = LoadPicture(FullFile)
  F.ShowChartEvol
End Sub

Public Sub FillChartEvol(ByRef vChartData() As t_ChartDataEvol, _
                         ByRef Chart As Object)
  Dim i As Long
  
  For i = 1 To UBound(vChartData)
    With Chart.WebChartItems
      With .Item(.Add(Nothing))
        .PrimaryValue = vChartData(i).Total
        .PrimaryLabel = vChartData(i).Mes & "-" & Right$(vChartData(i).Anio, 2)
      End With
    End With
  Next
End Sub

Public Sub FillChartProd(ByRef vChartData() As t_ChartDataProd, _
                         ByRef Chart As Object)
  Dim i As Long
  
  For i = 1 To UBound(vChartData)
    With Chart.WebChartItems
      With .Item(.Add(Nothing))
        .PieLabel = vChartData(i).Producto
        .PrimaryValue = vChartData(i).Total
      End With
    End With
  Next
End Sub

Public Function GetDocumentoTipoInfo_(ByVal doct_id As Long, _
                                      ByRef doct_nombre As String, _
                                      ByRef doct_object As String, _
                                      ByRef PRE_ID As Long) As Boolean

  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "select doct_nombre, doct_object, pre_id from documentoTipo where doct_id = " & doct_id
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  If rs.EOF Then Exit Function
  
  doct_nombre = gDB.ValField(rs.Fields, cscDoctNombre)
  doct_object = gDB.ValField(rs.Fields, cscDoctObject)
  PRE_ID = gDB.ValField(rs.Fields, cscPreID)
  
  GetDocumentoTipoInfo_ = True
End Function

' Esta dos veces por el tema de paramarray
' mas adelante buscaremos una tecnica para
' pasar el paramarray si es que la hay.
'
' Esta funcion esta en cUtil copiada exactamente igual
'
Public Function LNGGetText(ByVal lengi_codigo As String, _
                           ByVal Default As String, _
                           ParamArray params() As Variant) As String

  If gDB Is Nothing Then
    LNGGetText = Default
    Exit Function
  End If

  Dim sqlstmt As String
  Dim rs      As Recordset
  Dim rtn     As String
  
  sqlstmt = "sp_LengGetText " & gDB.sqlString(lengi_codigo) & "," & gDB.UserId
  
  If gDB.OpenRs(sqlstmt, rs) Then
    If Not rs.EOF Then
      If gDB.ValField(rs.Fields, 0) <> "" Then
        rtn = gDB.ValField(rs.Fields, 0)
      Else
        rtn = Default
      End If
    Else
      rtn = Default
    End If
  Else
    rtn = Default
  End If
  
'-------------------------------------
  On Error GoTo ExitProc
  
  Dim i As Long
  Dim q As Long
  
  For i = LBound(params) To UBound(params)
    q = q + 1
    rtn = Replace(rtn, "#" & q & "#", CStr(params(i)))
  Next
  
ExitProc:
'-------------------------------------

  LNGGetText = rtn
End Function

Public Function ShowSelectRs_(ByVal SelectTitle As String, _
                              ByRef rs As Recordset, _
                              ByRef Id As Long) As Boolean
  Dim F       As fSelectRs
  Dim fld     As Field
  Dim i       As Long
  Dim Value   As Variant
  
  Set F = New fSelectRs
  
  F.FormName = SelectTitle
  Load F
  
  With F.grdGrid
    .GridLines = True
    
    For Each fld In rs.Fields
      .AddColumn , fld.Name, , , 165
      If InStr(1, fld.Name, "_ID", vbTextCompare) <> 0 Then
        .ColumnVisible(.Columns) = False
      End If
    Next
      
    While Not rs.EOF
      .AddRow
      For Each fld In rs.Fields
        i = i + 1
        Value = gDB.ValField(rs.Fields, fld.Name)
        Select Case fld.Type
          Case adBoolean, adDBTime, adDate, adDBDate, adDBTimeStamp
            If Value = csNoDate Then
              .CellDetails .Rows, i, vbNullString
            Else
              .CellDetails .Rows, i, Value
            End If
          Case Else
            .CellDetails .Rows, i, Value
        End Select
      Next
      i = 0
      rs.MoveNext
    Wend
  End With
  
  If F.grdGrid.Rows Then
    F.grdGrid.SelectedRow = 1
  End If
  
  F.grdGrid.KeyReturnEmulateTab = False
  F.grdGrid.AutoWidthColumns
  F.Show vbModal
  
  If F.Ok Then
    If F.grdGrid.SelectedRow > 0 Then
      Id = Val(F.grdGrid.CellText(F.grdGrid.SelectedRow, 1))
      ShowSelectRs_ = True
    End If
  End If
End Function


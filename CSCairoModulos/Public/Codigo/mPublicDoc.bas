Attribute VB_Name = "mPublicDoc"
Option Explicit

'--------------------------------------------------------------------------------
' mPublicDoc
' 04-04-2004

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "mPublicDoc"

' estructuras
' variables privadas
' eventos
' propiedades publicas
' propiedades friend
' propiedades privadas
' funciones publicas
Public Function SetMask(ByVal Text As String, ByVal Mask As String) As String
  Dim c       As String
  Dim i       As Long
  Dim rtn     As String
  Dim s       As String
  Dim s2      As String
  
  If Len(Mask) - Len(Text) > 0 Then
    Text = String(Len(Mask) - Len(Text), " ") & Text
  End If
  
  For i = Len(Mask) To 1 Step -1
  
    s = Mid$(Mask, i, 1)
    s2 = Mid$(Text, i, 1)
    
    Select Case s
      Case "0"
        If Not IsNumeric(s2) Then
          s2 = "0"
        End If
      Case "-"
        If IsNumeric(s2) Then
          Text = Mid$(Text, 2)
        End If
        s2 = "-"
      Case Else
        s2 = s
    End Select
    
    rtn = s2 & rtn
  Next
  
  SetMask = rtn
End Function

Public Function GetNombreRama(ByVal Tbl_id As Long, ByVal Ram_ID As Long, ByRef bExists As Boolean) As String
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  sqlstmt = "select ram_nombre "
  sqlstmt = sqlstmt & " from rama,arbol "
  sqlstmt = sqlstmt & " where rama.arb_id = arbol.arb_id "
  sqlstmt = sqlstmt & " and ram_id = " & Ram_ID
  sqlstmt = sqlstmt & " and tbl_id = " & Tbl_id
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  If rs.EOF Then Exit Function
  
  bExists = True
  
  GetNombreRama = gDB.ValField(rs.Fields, cscRamNombre)
End Function

Public Function pCell(ByRef Row As cIABMGridRow, ByVal Key As Long) As cIABMGridCellValue
  Dim Cell    As cIABMGridCellValue
  For Each Cell In Row
    If Cell.Key = Key Then
      Set pCell = Cell
      Exit Function
    End If
  Next
End Function

Public Function pGetKeyFromCol(ByRef Columns As cIABMGridColumns, ByVal lCol As Long) As Long
  On Error Resume Next
  pGetKeyFromCol = Columns.Item(lCol).Key
End Function

Public Function pGetColFromKey(ByRef Columns As cIABMGridColumns, ByVal Key As Long) As Long
  On Error Resume Next
  Dim i As Long
  For i = 1 To Columns.Count
    If Columns(i).Key = Key Then
      pGetColFromKey = i
      Exit Function
    End If
  Next
End Function

Public Function IsRNI(ByVal CliId As Long) As Boolean
  Dim CatFiscal As csCatFiscal
  If Not gDB.GetData(csTCliente, cscCliId, CliId, cscCliCatfiscal, CatFiscal) Then Exit Function
  
  IsRNI = CatFiscal = csCatFNoInscripto
End Function

Public Function pCol(ByRef Columns As cIABMGridColumns, ByVal Key As Long) As cIABMGridColumn
  Dim Col    As cIABMGridColumn
  For Each Col In Columns
    If Col.Key = Key Then
      Set pCol = Col
    End If
  Next
End Function

#If PREPROC_NRO_SERIE Then
  
  Public Function EditNroSerie(ByVal Grupo As Long, _
                               ByVal Cantidad As Long, _
                               ByRef Row As cIABMGridRow, _
                               ByRef NrosSerie As Collection, _
                               ByVal KI_GRUPO As Long, _
                               ByVal KI_NROSERIE As Long, _
                               ByVal lRow As Long, _
                               ByVal PrId As Long, _
                               ByVal DeplId As Long, _
                               ByVal IsInput As Boolean) As Boolean
    Dim EditSerie As cProductoSerie
    Dim i         As Long
    Dim n         As Long
    Dim coll      As Collection
    Dim Nros      As String
    
    If Cantidad < 1 Then
      MsgWarning "Debe indicar una cantidad"
      Exit Function
    End If
    
    Set EditSerie = New cProductoSerie
    
    With EditSerie
      
      ' Si ya existen numeros de serie para este item
      '
      If ExistsObjectInColl(NrosSerie, GetKey(Grupo)) Then
        
        ' Paso de la coleccion a la ventana de edicion
        '
        Set coll = NrosSerie.Item(GetKey(Grupo))
        For i = 1 To coll.Count
          .AddProductoSerie coll.Item(i)
        Next
        n = .coll.Count
      End If
      
      ' Creo filas para los nuevos numeros de serie
      '
      For i = n + 1 To Cantidad
        .AddProductoSerie New cProductoSerieType
        .coll(i).prns_id = i * -1
      Next
      
      .depl_id = DeplId
      .PR_ID = PrId
      .IsInput = IsInput
      
      If Not .Edit Then Exit Function
      
      ' Si este item aun no tiene numeros de serie
      ' creo una nueva coleccion y la agrego a la coleccion de items
      ' el grupo esta en negativo para indicar que son nuevos
      '
      If coll Is Nothing Then
        Grupo = lRow * -1
        pCell(Row, KI_GRUPO).Id = (NrosSerie.Count + 1) * -1
        Set coll = New Collection
        NrosSerie.Add coll, GetKey(Grupo)
      End If
      
      CollClear coll
      
      ' Paso de la ventana a la coleccion del item
      '
      For i = 1 To .coll.Count
        Nros = Nros & .coll.Item(i).Codigo & ","
        With .coll
          coll.Add .Item(i), GetKey(.Item(i).prns_id)
        End With
      Next
    End With
    
    pCell(Row, KI_NROSERIE).Value = RemoveLastColon(Nros)
  End Function

#End If

#If Not PREPROC_STOCK Then
  Public Function GetMonedaDefault() As Long
    Dim sqlstmt As String
    Dim rs      As Recordset
    
    sqlstmt = "select mon_id from Moneda where mon_legal <> 0"
    If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
    
    If rs.EOF Then
      MsgWarning "Debe definir cual es la moneda legal con la que opera el sistema"
      Exit Function
    End If
    
    GetMonedaDefault = gDB.ValField(rs.Fields, cscMonId)
  End Function
  
  Public Function GetMonedaFromCuenta(ByRef MonId As Long, ByRef Moneda As String, ByVal Cue_id As Long) As Boolean
    Dim sqlstmt As String
    Dim rs      As ADODB.Recordset
  
    sqlstmt = "select * from moneda inner join cuenta on moneda.mon_id = cuenta.mon_id where cue_id = " & Cue_id
    If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
    
    If rs.EOF Then Exit Function
    
    MonId = gDB.ValField(rs.Fields, cscMonId)
    Moneda = gDB.ValField(rs.Fields, cscMonNombre)
  End Function
  
  Public Function GetChequeNumber(ByVal ChqId As Long) As String
    Dim Chequera As cChequera
    Dim Cheque   As Long
    
    Set Chequera = New cChequera
    If Not Chequera.GetNextNumber(ChqId, Cheque) Then Exit Function
    
    GetChequeNumber = Cheque
  End Function
  
  Public Function GetTasaFromProducto(ByVal PR_ID As Long, ByRef ti_ri As Long, ByRef ti_rni As Long) As Boolean
    Dim sqlstmt As String
    Dim rs      As ADODB.Recordset
    
    sqlstmt = "sp_ProductoGetTasas " & PR_ID
    
    If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
    
    If Not rs.EOF Then

  #If PREPROC_COMPRAS Then
      ti_ri = gDB.ValField(rs.Fields, cscPrTiIdRiCompra)
      ti_rni = gDB.ValField(rs.Fields, cscPrTiIdRniCompra)
  #End If
    
  #If PREPROC_VENTAS Or PREPROC_ENVIO Or PREPROC_PEDIDOVTA Then
      ti_ri = gDB.ValField(rs.Fields, cscPrTiIdRiVenta)
      ti_rni = gDB.ValField(rs.Fields, cscPrTiIdRniVenta)
  #End If
    End If
    
    GetTasaFromProducto = True
  End Function
  
  #If PREPROC_COMPRAS Or PREPROC_EXPORT Then
    Public Function GetProveedorData(ByVal prov_id As Long, ByRef lp_id As Long, ByRef ld_id As Long, ByRef cpg_id As Long, ByVal mon_id As Long)
      Dim sqlstmt As String
      Dim rs      As ADODB.Recordset
      
      sqlstmt = "sp_ProveedorGetData " & prov_id & "," & mon_id
      
      If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
      
      If Not rs.EOF Then
        lp_id = gDB.ValField(rs.Fields, cscLpId)
        ld_id = gDB.ValField(rs.Fields, cscLdId)
        cpg_id = gDB.ValField(rs.Fields, cscCpgId)
      End If
      
      GetProveedorData = True
    End Function
  #End If
  
  #If PREPROC_VENTAS Or PREPROC_ENVIO Or PREPROC_PEDIDOVTA Then
    Public Function GetClienteData(ByVal cli_id As Long, ByRef lp_id As Long, ByRef ld_id As Long, ByRef cpg_id As Long, ByVal mon_id As Long)
      Dim sqlstmt As String
      Dim rs      As ADODB.Recordset
      
      sqlstmt = "sp_ClienteGetData " & cli_id & "," & mon_id
      
      If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
      
      If Not rs.EOF Then
        lp_id = gDB.ValField(rs.Fields, cscLpId)
        ld_id = gDB.ValField(rs.Fields, cscLdId)
        cpg_id = gDB.ValField(rs.Fields, cscCpgId)
      End If
      
      GetClienteData = True
    End Function
  #End If

#End If
' funciones friend
' funciones privadas
' construccion - destruccion

'//////////////////////////////
'  Codigo estandar de errores
'  On Error GoTo ControlError
'
'  GoTo ExitProc
'ControlError:
'  MngError err,"", C_Module, ""
'  If Err.Number <> 0 Then Resume ExitProc
'ExitProc:
'  On Error Resume Next


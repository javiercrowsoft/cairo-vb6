Attribute VB_Name = "mPublic"
Option Explicit

'--------------------------------------------------------------------------------
' mPublic
' 23-03-02

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
' estructuras
' variables privadas
' variables publicas

' Base de datos
Public gDB          As cDataBase

' nombre de la Aplication
Public gAppName     As String

' funciones publicas
Public Sub WizSetShowStockData(ByRef ObjWiz As cIWizardGeneric, _
                               ByVal KeyStep As String, _
                               ByRef ShowStockData As Boolean)
  Dim DocId     As Long
  Dim DocIdRto  As Long
  Dim Doc       As cDocumento
  
  Set Doc = New cDocumento
  
  ShowStockData = False
  
  With ObjWiz.Steps.Item(GetKey(KeyStep)).Properties.Item(c_Wiz_Key_Doc)
    DocId = .HelpId
  End With
  
  ' Si el remito mueve stock
  '
  If CBool(Doc.GetData(DocId, cscDocMueveStock, csBoolean)) Then
    ShowStockData = True
  End If
End Sub

Public Function WizGetDeposito(ByRef ObjWiz As cIWizardGeneric, _
                               ByVal KeyStep As String, _
                               ByVal KeyDeposito As String) As Long
                               
  With ObjWiz.Steps.Item(GetKey(KeyStep)).Properties.Item(KeyDeposito)
    WizGetDeposito = .HelpId
  End With
End Function

Public Function WizGetDepositoProp(ByRef ObjWiz As cIWizardGeneric, _
                                   ByVal KeyStep As String, _
                                   ByVal KeyDeposito As String) As cIABMProperty
                               
  Set WizGetDepositoProp = ObjWiz.Steps.Item(GetKey(KeyStep)).Properties.Item(KeyDeposito)
End Function

Public Function ShowCobranzaContado(ByVal CliId As Long, _
                                    ByVal FvId As Long, _
                                    ByVal FvFecha As Date, _
                                    ByVal FvTotal As Double, _
                                    ByVal SucId As Long, _
                                    ByVal CcosId As Long, _
                                    ByVal LgjId As Long, _
                                    ByVal CjId As Long, _
                                    Optional ByVal bAutoPago As Boolean, _
                                    Optional ByVal CueIdAutoPago As Long) As Boolean
  
  Dim CobranzaCdo As cCobranzaContado
  Set CobranzaCdo = New cCobranzaContado
  
  CobranzaCdo.ShowCobranza CliId, FvId, FvFecha, FvTotal, _
                           SucId, CcosId, LgjId, CjId, _
                           bAutoPago, CueIdAutoPago

  ShowCobranzaContado = True
  
End Function

Public Function VentasPorHojadeRuta() As Boolean

  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_DocVentasPorHojadeRuta"
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  If rs.EOF Then Exit Function
  
  VentasPorHojadeRuta = gDB.ValField(rs.fields, 0) <> 0

End Function

Public Function IsCobranzaPorCajero(ByVal FvId As Long) As Boolean

  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_DocEsCobranzaPorCajero " & FvId
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  If rs.EOF Then Exit Function
  
  IsCobranzaPorCajero = gDB.ValField(rs.fields, 0) <> 0

End Function

Public Function IsCobranzaContado(ByVal FvId As Long) As Boolean
  
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_DocEsCobranzaCdo " & FvId
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  If rs.EOF Then Exit Function
  
  IsCobranzaContado = gDB.ValField(rs.fields, 0) <> 0

End Function

Public Function SaveFacturaVentaCajero(ByVal fv_id As Long, ByVal cj_id As Long, ByVal CtaCte As Boolean) As Boolean
  Dim sqlstmt As String
  sqlstmt = "sp_DocCobranzaCdoSaveFactura " & fv_id & "," & cj_id & "," & IIf(CtaCte, 1, 0)
  SaveFacturaVentaCajero = gDB.Execute(sqlstmt)
End Function

Public Function ValidateNroSerieCantidad(ByRef Items As cIABMGrid, _
                                         ByVal KI_PR_LLEVANROSERIE As Long, _
                                         ByVal KII_SELECT As Long, _
                                         ByRef NrosSerie As Collection, _
                                         ByVal KII_APLICAR As Long) As Boolean
  Dim Row     As cIABMGridRow
  Dim Grupo   As Long
  Dim iRow    As Long
  Dim Coll    As Collection
  Dim pt      As cProductoSerieType

  For iRow = 1 To Items.Rows.count
    Set Row = Items.Rows.Item(iRow)
    Grupo = iRow * -1
    If pCell(Row, KI_PR_LLEVANROSERIE).id Then
      If pCell(Row, KII_SELECT).id Then
        If ExistsObjectInColl(NrosSerie, GetKey(Grupo)) Then
        
          Set Coll = NrosSerie.Item(GetKey(Grupo))
        
          If Coll.count <> Val(pCell(Row, KII_APLICAR).Value) Then
            MsgInfo LNGGetText(3490, vbNullString, iRow)   '"Faltan indicar números de serie en la fila " & iRow
            Exit Function
          End If
        End If
      End If
    End If
  Next
  
  ValidateNroSerieCantidad = True

End Function

' funciones privadas
' construccion - destruccion


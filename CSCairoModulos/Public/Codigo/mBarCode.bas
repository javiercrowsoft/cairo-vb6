Attribute VB_Name = "mBarCode"
Option Explicit

' Esta funcion devuelve el pr_id asociado a un
' codigo de barras
'
Public Function BCGetPrIdFromBarCode(ByVal pr_codigobarra As String, _
                                      ByRef pr_id As Long, _
                                      ByRef pr_nombrecompra As String, _
                                      ByRef pr_nombreventa As String) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  ' TODO: Remover cuando este en csgeneralex
  '
  Const cscPrNombreVenta = "pr_nombreventa"
  
  pr_codigobarra = Trim$(pr_codigobarra)
  
  pr_id = csNO_ID
  pr_nombrecompra = vbNullString
  pr_nombreventa = vbNullString
  
  If pr_codigobarra = vbNullString Then Exit Function
  
  sqlstmt = "sp_ProductoGetFromCodigoBarra " & gDB.sqlString(pr_codigobarra)
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  If rs.EOF Then Exit Function
  pr_id = rs.fields(cscPrId)
  pr_nombrecompra = rs.fields(cscPrNombreCompra)
  pr_nombreventa = rs.fields(cscPrNombreVenta)
  
  BCGetPrIdFromBarCode = True
End Function

' Esta funcion obtiene el codigo del producto
' extrayendolo del codigo de barra leido por
' la lectora.
'
' El sistema puede trabajar por codigos de longitud
' fija, o por un caracter espcial que separa el
' codigo del producto del numero de serie
'
' TODO: hay que implementar las ventanas de configuracion
'       y codificar esta funcion. Por ahora solo trabaja
'       con codigos de longitud fija y el tamaño esta
'       fijo en 4
'
Public Function BCGetPrCodigoBarra(ByVal codigo_barra As String, _
                                   ByVal c_cod_barra_tipo As csE_StockCodigoBarraTipo, _
                                   ByVal c_cod_barra_longitud As Long, _
                                   ByVal c_cod_barra_caracter As String) As String
                                   
  If c_cod_barra_tipo = csESCB_Fijo Then
    BCGetPrCodigoBarra = Left$(codigo_barra, c_cod_barra_longitud)
  Else
    BCGetPrCodigoBarra = Left$(codigo_barra, _
                               InStr(1, codigo_barra, _
                                      c_cod_barra_caracter))
  End If
End Function

' Esta funcio devuelve el numero de serie
' extrayendolo del codigo de barra leido por
' la lectora.
'
' Funciona de la misma forma que BCGetPrCodigoBarra
'
' TODO: hay que implementar el codigo, por ahora esta fijo
'       en 4 posiciones
'
Public Function BCGetNroSerie(ByVal codigo_barra As String, _
                              ByVal c_cod_barra_tipo As csE_StockCodigoBarraTipo, _
                              ByVal c_cod_barra_longitud As Long, _
                              ByVal c_cod_barra_caracter As String) As String
                              
  If c_cod_barra_tipo = csESCB_Fijo Then
    BCGetNroSerie = Mid$(codigo_barra, c_cod_barra_longitud + 1)
  Else
    BCGetNroSerie = Mid$(codigo_barra, _
                          InStr(1, codigo_barra, _
                                 c_cod_barra_caracter) + 1)
  End If
End Function


Attribute VB_Name = "mCobranza"
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
Public Type T_CtaCte
  Cuenta                  As String
  Cue_id                  As Long
  Importe                 As Double
  ImporteOrigen           As Double
End Type

Private Type T_FacCta
  fac_id                  As Long
  Cue_id                  As Long
  Cuenta                  As String
End Type
' variables privadas
' nombre de la Aplication
' variables publicas
' funciones publicas
#If PREPROC_TESORERIA Then

  Public Function GetCuentasAcreedor(ByRef Facturas As cIABMGrid, ByRef vCtaCte() As T_CtaCte, _
                                     ByVal KI_FV_ID As Long, ByVal KI_APLICAR As Long, _
                                     ByVal KI_COTIZACION As Long, _
                                     ByVal Anticipo As Double, ByVal cue_id_anticipo, _
                                     ByVal AnticipoCuenta As String, ByVal AnticipoOrigen As Double) As Boolean
    
    GetCuentasAcreedor = pGetCuentasAux(Facturas, vCtaCte(), KI_FV_ID, KI_APLICAR, KI_COTIZACION, False, _
                                        Anticipo, cue_id_anticipo, AnticipoCuenta, AnticipoOrigen)
  End Function
  
  Public Function GetCuentasDeudor(ByRef Facturas As cIABMGrid, ByRef vCtaCte() As T_CtaCte, _
                                   ByVal KI_FV_ID As Long, ByVal KI_APLICAR As Long, _
                                   ByVal KI_COTIZACION As Long, _
                                   ByVal Anticipo As Double, ByVal cue_id_anticipo, _
                                   ByVal AnticipoCuenta As String, ByVal AnticipoOrigen As Double) As Boolean
    
    GetCuentasDeudor = pGetCuentasAux(Facturas, vCtaCte(), KI_FV_ID, KI_APLICAR, KI_COTIZACION, True, _
                                      Anticipo, cue_id_anticipo, AnticipoCuenta, AnticipoOrigen)
  End Function
  
  ' funciones privadas
  Private Function pGetCuentasAux(ByRef Facturas As cIABMGrid, ByRef vCtaCte() As T_CtaCte, _
                                  ByVal KI_FV_ID As Long, ByVal KI_APLICAR As Long, _
                                  ByVal KI_COTIZACION As Long, ByVal bDeudor As Boolean, _
                                  ByVal Anticipo As Double, ByVal cue_id_anticipo, _
                                  ByVal AnticipoCuenta As String, ByVal AnticipoOrigen As Double) As Boolean
    Dim vFacIds()     As Long
    Dim i             As Long
    Dim Row           As cIABMGridRow
    Dim Cell          As cIABMGridCellValue
    Dim Value         As Double
    Dim ValueOrigen   As Double
    Dim Cotizacion    As Double
    Dim Total         As Double
    
    ReDim vCtaCte(0)
    
    ' Dimensiono la grilla y el vector de facturas
    ReDim vFacIds(0)
    
    ' Por cada factura que tengo seleccionada la
    ' agrego al vector de ids de facturas
    For Each Row In Facturas.Rows
      If Val(pCell(Row, KI_APLICAR).Value) Then
        pAddFacId vFacIds, pCell(Row, KI_FV_ID).Id
      End If
    Next
    
    ' Debe seleccionar al menos una factura
    If UBound(vFacIds) = 0 And Anticipo < 0 Then
      MsgWarning "Debe seleccionar al menos una factura o un anticipo"
      Exit Function
    End If
    
    If UBound(vFacIds) > 0 Then
      ' Convierto el vector en un string
      Dim sqlstmt As String
      For i = 1 To UBound(vFacIds)
        sqlstmt = sqlstmt & vFacIds(i) & ","
      Next
      
      ' Preparo la sentencia sql
      sqlstmt = RemoveLastColon(sqlstmt)
      
      If bDeudor Then
        sqlstmt = "sp_DocCobranzaGetCuentaDeudor '" & sqlstmt & "'"
      Else
        sqlstmt = "sp_DocOrdenPagoGetCuentaAcreedor '" & sqlstmt & "'"
      End If
      
      Dim rs As ADODB.Recordset
      If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
      
      ' Voy a cargar un vector con las cuentas del tercero
      Dim vFacVtaCueId() As T_FacCta
      ReDim vFacVtaCueId(0)
      
      If Not rs.EOF Then
        rs.MoveLast
        rs.MoveFirst
        ReDim vFacVtaCueId(rs.RecordCount)
      End If
      
      ' Cargo las cuentas en el vector
      i = 0
      While Not rs.EOF
        i = i + 1
        With vFacVtaCueId(i)
          .Cue_id = gDB.ValField(rs.Fields, cscCueId)
          .Cuenta = gDB.ValField(rs.Fields, cscCueNombre)
          .fac_id = gDB.ValField(rs.Fields, 0)
        End With
        rs.MoveNext
      Wend
      
      ' Aplico los importes a cada una de las cuentas
      ' en un nuevo vector que tiene la cuenta y el importe
      For Each Row In Facturas.Rows
        Value = Val(pCell(Row, KI_APLICAR).Value)
        If Value > 0 Then
          Cotizacion = Val(pCell(Row, KI_COTIZACION).Value)
          ValueOrigen = DivideByCero(Value, Cotizacion)
          pAddCtaCte Value, ValueOrigen, vCtaCte, vFacVtaCueId, pCell(Row, KI_FV_ID).Id
        End If
      Next
    End If
    
    ' Finalmente si hay un anticipo lo agrego al vector de cuentas
    If Anticipo > 0 Then
      pAddCtaCteAux Anticipo, AnticipoOrigen, vCtaCte, cue_id_anticipo, AnticipoCuenta
    End If
    
    pGetCuentasAux = True
  End Function

  Private Sub pAddCtaCte(ByVal Value As Double, ByVal ValueOrigen As Double, ByRef vCtaCte() As T_CtaCte, ByRef vFacVtaCueId() As T_FacCta, ByVal fac_id As Long)
    Dim i           As Long
    Dim Cue_id      As Long
    Dim cue_nombre  As String
    
    For i = 1 To UBound(vFacVtaCueId)
      With vFacVtaCueId(i)
        If .fac_id = fac_id Then
          Cue_id = .Cue_id
          cue_nombre = .Cuenta
          Exit For
        End If
      End With
    Next
    
    pAddCtaCteAux Value, ValueOrigen, vCtaCte, Cue_id, cue_nombre
  End Sub
  
  Private Sub pAddCtaCteAux(ByVal Value As Double, ByVal ValueOrigen As Double, ByRef vCtaCte() As T_CtaCte, ByVal Cue_id As Long, ByVal cue_nombre As String)
    Dim i As Long
    
    For i = 1 To UBound(vCtaCte())
      With vCtaCte(i)
        If .Cue_id = Cue_id Then
          .Importe = .Importe + Value
          .ImporteOrigen = .ImporteOrigen + ValueOrigen
          
          ' Lo encontre, listo me voy
          '
          Exit Sub
        End If
      End With
    Next
    
    ' No lo encontre asi que lo agrego
    '
    ReDim Preserve vCtaCte(UBound(vCtaCte) + 1)
    With vCtaCte(UBound(vCtaCte))
      .Importe = Value
      .ImporteOrigen = ValueOrigen
      .Cue_id = Cue_id
      .Cuenta = cue_nombre
    End With
  End Sub
  
  Private Sub pAddFacId(ByRef vFacIds() As Long, ByVal Id As Long)
    Dim i As Long
    For i = 1 To UBound(vFacIds)
      If vFacIds(i) = Id Then
        Exit Sub
      End If
    Next
    ReDim Preserve vFacIds(UBound(vFacIds) + 1)
    vFacIds(i) = Id
  End Sub

#End If

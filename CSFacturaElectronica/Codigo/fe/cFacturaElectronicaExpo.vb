Option Strict Off
Option Explicit On

Imports CSLog
Imports CSFEWSAA

Public Class cFacturaElectronicaExpo

    Private Const c_module As String = "cFacturaElectronicaExpo"

    Public listaSolicitudesAEnviar As New ArrayList
    Dim respuesta As String

    ' Para Exportacion
    'Private unv_Items_ex As New v_Items_EX

    ' Para Produccion Exportacion
    Dim objProdWSFEX As New ar.gov.afip.wsfexhomo.Service
    Dim objProdFEXUltNroResponse As New ar.gov.afip.wsfexhomo.FEXResponse_LastID
    Dim objProdFEXDetalleRequestProd As New ar.gov.afip.wsfexhomo.ClsFEXRequest
    Dim ArrayOfv_PermisosDestinoProd(0) As ar.gov.afip.wsfexhomo.Permiso
    Dim ArrayOfv_ItemsProd(0) As ar.gov.afip.wsfexhomo.Item
    Dim ArrayOfv_cmpasociados_Prod(0) As ar.gov.afip.wsfexhomo.Cmp_asoc
    Dim objProdFEXRequest As New ar.gov.afip.wsfexhomo.ClsFEXRequest
    Dim objProdFEXGetCMPR As New ar.gov.afip.wsfexhomo.ClsFEXGetCMPR
    Dim objProdFEXResponseAuthorize As New ar.gov.afip.wsfexhomo.FEXResponseAuthorize ' ver si podemos borrar
    Dim objProdFEXAuthRequest As New ar.gov.afip.wsfexhomo.ClsFEXAuthRequest

    Dim objProdFEXResponseLast_CMP As New ar.gov.afip.wsfexhomo.FEXResponseLast_CMP
    Dim objProdClsFEX_LastCMP As New ar.gov.afip.wsfexhomo.ClsFEX_LastCMP
    Dim objProdClsFEX_LastCMP_Response As New ar.gov.afip.wsfexhomo.ClsFEX_LastCMP_Response

    Public objProdFEXGetCMPResponse As New ar.gov.afip.wsfexhomo.FEXGetCMPResponse


    public function getCAE_EX(ByVal wsaa As cFEWSAA,
                              byval urlWsfex_Wsdl As String,
                              ByVal facturador_cuit As Long,
                              ByVal fvId As Long,
                              ByVal cuit_pais As Long, _
                              ByVal cliente_nombre As String, _
                              ByVal tipo_doc As Integer, _
                              ByVal nro_doc As Long, _
                              ByVal tipo_cbte As Integer, _
                              ByVal punto_vta As Integer, _
                              ByVal cbt_desde As Long, _
                              ByVal cbt_hasta As Long, _
                              ByVal imp_total As Double, _
                              ByVal imp_tot_conc As Double, _
                              ByVal imp_neto As Double, _
                              ByVal impto_liq As Double, _
                              ByVal impto_liq_rni As Double, _
                              ByVal imp_tributo As Double, _
                              ByVal imp_op_ex As Double, _
                              ByVal moneda_id As String, _
                              ByVal moneda_cotiz As Decimal, _
                              ByVal pais_id As Short, _
                              ByVal fecha_cbte As String, _
                              ByVal fecha_serv_desde As String, _
                              ByVal fecha_serv_hasta As String, _
                              ByVal fecha_venc_pago As String, _
                              ByVal ArrayOfIva() As ar.gov.afip.wsfev1homo.AlicIva,
                              ByVal ArrayOfTributos() As ar.gov.afip.wsfev1homo.Tributo) As cCAE

      Dim comp as Comprobante = New Comprobante

      comp.Id = fvId
      comp.Cbte_tipo = tipo_doc 
      comp.Fecha_cbte = fecha_cbte
      comp.Punto_vta = punto_vta
      comp.Cbte_nro = nro_doc
      comp.Tipo_expo = 2
      comp.Permiso_existente = "N" 
      comp.Dst_cmp = pais_id
      comp.Cliente = cliente_nombre
      comp.Cuit_pais_cliente = cuit_pais 
      comp.Domicilio_cliente = ""
      comp.ID_impositivo = ""
      comp.Moneda_ID = moneda_id
      comp.Moneda_Ctz = moneda_cotiz
      comp.Obs_comerciales = ""
      comp.Imp_total = imp_total
      comp.Incoterms = "" 
      comp.Incoterms_Ds = ""

      'Se deberá indicar en que idioma se hará el
      'documento. Consultar Método
      'FEXGET_PARAM_IDIOMAS.
      'Valores posibles: 1,2,3
      '1:Español
      '2: Inglés
      '3: Portugués

      comp.Idioma_cbte = 1 
      comp.formaspago = ""

      Dim cae As New cCAE

      solicitarCAE_ex(comp, cae, wsaa, urlWsfex_Wsdl, facturador_cuit)

      Return cae

    end function

    Public Function solicitarCAE_ex(ByVal pun_comprobante As Comprobante, ByVal cae As cCAE, 
                                    ByVal wsaa As cFEWSAA,
                                    ByVal urlWsfex_Wsdl As String,
                                    ByVal facturador_cuit As Long) As Boolean

        Try

                objProdWSFEX.Url = urlWsfex_Wsdl
                AdaptarFormatoAFIPPROD_EX(pun_comprobante, wsaa, facturador_cuit)
                objProdFEXResponseAuthorize = objProdWSFEX.FEXAuthorize(objProdFEXAuthRequest, objProdFEXRequest)
                If Not objProdFEXResponseAuthorize.FEXResultAuth Is Nothing Then
                    respuesta = objProdFEXResponseAuthorize.FEXResultAuth.Resultado.ToString()
                End If

        Catch ex As Exception
            cLog.write(ex.Message, c_module)
            Exit Function
        End Try

        If respuesta = "R" Or respuesta Is Nothing Then

                If objProdFEXResponseAuthorize.FEXErr.ErrCode <> 0 Then
                    cLog.write("ErrCode: " + objProdFEXResponseAuthorize.FEXErr.ErrCode, c_module)
                    cLog.write("ErrMsg: " + objProdFEXResponseAuthorize.FEXErr.ErrMsg, c_module)
                    cLog.write("idsolicitud: " + pun_comprobante.Id, c_module)
                Else
                    cLog.write("Comprobante rechazado por error desconocido.", c_module)
                End If

        End If

        cae.cae = objProdFEXResponseAuthorize.FEXResultAuth.Cae
        cae.nro_factura = objProdFEXResponseAuthorize.FEXResultAuth.Cbte_nro
        cae.vencimiento = objProdFEXResponseAuthorize.FEXResultAuth.Fch_venc_Cae

        cLog.write("Actualizando datos del comprobante", c_module)
        cLog.write("fecha comprobante: " + objProdFEXResponseAuthorize.FEXResultAuth.Fch_cbte, c_module)
        cLog.write("id auth: " + objProdFEXResponseAuthorize.FEXResultAuth.Id, c_module)
        cLog.write("pto venta: " + objProdFEXResponseAuthorize.FEXResultAuth.Punto_vta, c_module)
        cLog.write("cae: " + cae.cae, c_module)
        cLog.write("nro_factura: " + cae.nro_factura, c_module)
        cLog.write("vto: " + cae.vencimiento, c_module)

        solicitarCAE_ex = True

    End Function

    Private Function AdaptarFormatoAFIPPROD_EX(ByVal comp As Comprobante, ByVal wsaa As cFEWSAA, facturador_cuit As Long) As Boolean

        cLog.write("Adaptando formato Afip - Produccion - EX", c_module)

        Dim existeItems As Boolean = False

        objProdFEXAuthRequest.Token = wsaa.token
        objProdFEXAuthRequest.Sign = wsaa.sign

        objProdFEXAuthRequest.Cuit = facturador_cuit

        objProdWSFEX.Timeout = 60000
  
        With objProdFEXRequest
            .Cbte_Tipo = comp.Cbte_Tipo
            .Punto_vta = comp.Punto_vta
            .Cbte_nro = comp.Cbte_nro
            .Cliente = comp.Cliente
            .Cuit_pais_cliente = comp.Cuit_pais_cliente
            .Domicilio_cliente = comp.Domicilio_cliente
            .Dst_cmp = comp.Dst_cmp
            .Fecha_cbte = comp.Fecha_cbte
            .Forma_pago = comp.formaspago
            .Id = comp.Id
            .Id_impositivo = comp.ID_impositivo
            .Idioma_cbte = comp.Idioma_cbte
            .Imp_total = comp.Imp_total
            .Incoterms = comp.Incoterms
            .Incoterms_Ds = comp.Incoterms_Ds
            .Moneda_ctz = comp.Moneda_Ctz
            .Moneda_Id = comp.Moneda_ID
            .Obs_comerciales = comp.Obs_comerciales
            .Permiso_existente = comp.Permiso_existente
            .Tipo_expo = comp.Tipo_expo
        End With

        'Dim i As Integer = 0
        'For Each unv_Items_ex As v_Items_EX In unv_Items_exDAO.listav_Items_EX
        '    ReDim Preserve ArrayOfv_ItemsProd(0 To i)
        '    existeItems = True
        '    ArrayOfv_ItemsProd(0 To i) = New ar.gov.afip.wsfexhomo.Item
        '    ArrayOfv_ItemsProd(i).Pro_codigo = unv_Items_ex.Pro_codigo.valor
        '    ArrayOfv_ItemsProd(i).Pro_ds = unv_Items_ex.Pro_ds.valor
        '    ArrayOfv_ItemsProd(i).Pro_precio_uni = unv_Items_ex.Pro_precio_uni.valor
        '    ArrayOfv_ItemsProd(i).Pro_qty = unv_Items_ex.Pro_qty.valor
        '    ArrayOfv_ItemsProd(i).Pro_total_item = unv_Items_ex.Pro_total_item.valor
        '    ArrayOfv_ItemsProd(i).Pro_umed = unv_Items_ex.Pro_umed.valor

        '    i = i + 1
        'Next
        'If existeItems Then
        '    objProdFEXRequest.Items = ArrayOfv_ItemsProd
        '    cLog.write("Lista de Items creada", c_module)
        'End If

        cLog.write("Adaptacion Prodlogacion Completa", c_module)
        AdaptarFormatoAFIPPROD_EX = True

    End Function

    'Public Function BuscarComprobantesPRODAfip_EX(ByVal punComprobante As Comprobante) As Boolean
    '    BuscarComprobantesPRODAfip_EX = False

    '    Dim ptoVta As String = punComprobante.ptovta.ToString


    '    If Not objAccesoTA.obtenerTicketProduccion_Ex() Then
    '        Me.error = objAccesoTA.Error
    '        Exit Function
    '    End If


    '    objProdClsFEX_LastCMP.Cuit = Configuration.ConfigurationManager.AppSettings("CUIT_FONSECA")
    '    objProdClsFEX_LastCMP.Sign = objAccesoTA.Sign
    '    objProdClsFEX_LastCMP.Token = objAccesoTA.Token


    '    If punComprobante.ptovta.valor = 0 Then
    '        objProdClsFEX_LastCMP.Pto_venta = CType(Configuration.ConfigurationManager.AppSettings("DEFAULT_PTO_VTA_EX"), Integer)
    '    Else
    '        objProdClsFEX_LastCMP.Pto_venta = punComprobante.ptovta.valor
    '    End If

    '    If punComprobante.tipo.valor = 0 Then
    '        objProdClsFEX_LastCMP.Tipo_cbte = CType(Configuration.ConfigurationManager.AppSettings("DEFAULT_CBTE_TIPO_EX"), Integer)
    '    Else
    '        objProdClsFEX_LastCMP.Tipo_cbte = punComprobante.tipo.valor
    '    End If
    '    Dim objClsFEXGetCMP As New ar.gov.afip.wsfexhomo.ClsFEXGetCMP
    '    Try
    '        If punComprobante.codaut.valor = 0 Then
    '            objProdFEXResponseLast_CMP = objProdWSFEX.FEXGetLast_CMP(objProdClsFEX_LastCMP)
    '            objClsFEXGetCMP.Cbte_nro = objProdFEXResponseLast_CMP.FEXResult_LastCMP.Cbte_nro
    '        Else
    '            objClsFEXGetCMP.Cbte_nro = punComprobante.nro.valor
    '        End If

    '        objClsFEXGetCMP.Cbte_nro = objProdFEXResponseLast_CMP.FEXResult_LastCMP.Cbte_nro
    '        objClsFEXGetCMP.Punto_vta = objProdClsFEX_LastCMP.Pto_venta
    '        objClsFEXGetCMP.Tipo_cbte = objProdClsFEX_LastCMP.Tipo_cbte

    '        objProdFEXAuthRequest.Cuit = objProdClsFEX_LastCMP.Cuit
    '        objProdFEXAuthRequest.Sign = objProdClsFEX_LastCMP.Sign
    '        objProdFEXAuthRequest.Token = objProdClsFEX_LastCMP.Token

    '        objProdFEXGetCMPResponse = objProdWSFEX.FEXGetCMP(objProdFEXAuthRequest, objClsFEXGetCMP)

    '    Catch ex As Exception
    '        Me.error = ex.Message
    '        If ex.InnerException().ToString.Contains("(407)") Then
    '            objAccesoTA.CargarWebAFIP_WS()
    '            Me.error += vbCrLf + "Intente nuevamente."
    '        End If
    '        cLog.write(Me.error, c_module)
    '        Exit Function
    '    End Try

    '    BuscarComprobantesPRODAfip_EX = True
    'End Function
End Class

Public Class Comprobante

    Public Id As Long
    Public Cbte_tipo As Short
    Public Fecha_cbte As String
    Public Punto_vta As Short
    Public Cbte_nro As Long
    Public Tipo_expo As Short
    Public Permiso_existente As String
    Public Dst_cmp As Short
    Public Cliente As String
    Public Cuit_pais_cliente As Long
    Public Domicilio_cliente As String
    Public ID_impositivo As String
    Public Moneda_ID As String
    Public Moneda_Ctz As Decimal
    Public Obs_comerciales As String
    Public Imp_total As Decimal
    Public Incoterms As String
    Public Incoterms_Ds As String
    Public Idioma_cbte As Short
    Public formaspago As String

End Class


'Public Class v_Items_EX

'    Public Pro_codigo As New Campo
'    Public Pro_ds As New Campo
'    Public Pro_qty As New Campo
'    Public Pro_umed As New Campo
'    Public Pro_precio_uni As New Campo
'    Public Pro_total_item As New Campo


'End Class

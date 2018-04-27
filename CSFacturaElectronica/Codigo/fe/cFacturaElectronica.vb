Option Strict Off
Option Explicit On

Imports System.Timers
Imports System.Data
Imports CSLog
Imports CSFEWSAA

Public Class cFacturaElectronica

  Private Const c_module As String = "cFacturaElectronica"

  Private Const C_PRINT_SERVICE_STATE_WRITING = 1
  Private Const C_PRINT_SERVICE_STATE_READY = 2

  Private Shared m_Timer As System.Timers.Timer
  Private m_cancel As Boolean
  Private m_objFEAuthRequest1 As New ar.gov.afip.wsfev1homo.FEAuthRequest
  Private m_objWSFE1 As New ar.gov.afip.wsfev1homo.Service

  ' wsaa
  Private m_wsaa As cFEWSAA
  Private m_ticketAutorization As String
  Private m_urlWsaaWsdl As String
  Private m_idServicioNegocio As String
  Private m_rutaCertSigner As String
  Private m_proxy As String
  Private m_proxyUser As String
  Private m_proxyPassword As String
  Private m_verboseMode As Boolean

  Private m_cn As cConnection

  Private m_cuit As String

  Private m_ptoVta1 As String
  Private m_ptoVta2 As String

  Dim m_serverName As String
  Dim m_user As String
  Dim m_password As String
  Dim m_useTrusted As Boolean
  Dim m_database As String
  Dim m_emp_id As Integer

  Dim urlWsfex_Wsdl As String

  Public Sub initProcess()

    cLog.logFileName = "CSFacturaElectronica.log"
    cLog.write("Iniciando la ejecución de CSFacturaElectronica Service", "endProcess", c_module)

    cIni.setIniFileName("CSFacturaElectronica.ini")

    m_serverName = cIni.getValue("CONFIG", "db_serverName", "")
    m_user = cIni.getValue("CONFIG", "db_user", "")
    m_password = cIni.getValue("CONFIG", "db_password", "APP_PATH")
    m_useTrusted = CBool(Val(cIni.getValue("CONFIG", "db_useTrusted", "0")))
    m_database = cIni.getValue("CONFIG", "db_database", "")

    cLog.write("Iniciando el timer", "endProcess", c_module)

    Dim interval As Integer
    Dim urlWsfe_Wsdl1 As String
    

    interval = Val(cIni.getValue("CONFIG", "Interval", 1000))
    m_urlWsaaWsdl = cIni.getValue("CONFIG", "urlWsaaWsdl", "")
    m_idServicioNegocio = cIni.getValue("CONFIG", "idServicioNegocio", "")
    m_rutaCertSigner = cIni.getValue("CONFIG", "rutaCertSigner", "APP_PATH")
    m_proxy = cIni.getValue("CONFIG", "proxy", "")
    m_proxyUser = cIni.getValue("CONFIG", "proxyUser", "")
    m_proxyPassword = cIni.getValue("CONFIG", "proxyPassword", "")
    m_verboseMode = CBool(Val(cIni.getValue("CONFIG", "verboseMode", "")))
    urlWsfe_Wsdl1 = cIni.getValue("CONFIG", "urlWsfeWsdl1", "")
    urlWsfex_Wsdl = cIni.getValue("CONFIG", "urlWsfexWsdl", "")
    m_cuit = cIni.getValue("CONFIG", "cuit", "")
    m_ptoVta1 = cIni.getValue("CONFIG", "ptoVta1", "1")
    m_ptoVta2 = cIni.getValue("CONFIG", "ptoVta2", "1")
    m_emp_id = CInt(Val(cIni.getValue("CONFIG", "emp_id", "0")))

    If m_emp_id = 0 then
      cLog.write("Debe indicar una empresa en el achivo CSFacturaElectronica.ini. Use el parametro emp_id. El proceso para obtener facturas no esta activo.", "initProcess", c_module)
      Exit sub
    End If

    cLog.write("Interval: " & interval & vbCrLf & _
               "urlWsaaWdl: " & m_urlWsaaWsdl & vbCrLf & _
               "urlWsfeWsdl1: " & urlWsfe_Wsdl1 & vbCrLf & _
               "urlWsfexWsdl: " & urlWsfex_Wsdl & vbCrLf & _
               "idServicioNegocio: " & m_idServicioNegocio & vbCrLf & _
               "rutaCertSigner: " & m_rutaCertSigner & vbCrLf & _
               "proxy: " & m_proxy & vbCrLf & _
               "proxyUser: " & m_proxyUser & vbCrLf & _
               "proxyPassword: " & m_proxyPassword & vbCrLf & _
               "verboseMode: " & m_verboseMode & vbCrLf & _
               "cuit:" & m_cuit & vbCrLf & _
               "ptoVta1:" & m_ptoVta1 & vbCrLf & _
               "ptoVta2:" & m_ptoVta2 & vbCrLf & _
               "emp_id:" & m_emp_id & vbCrLf, "endProcess ***Params:", c_module)

    m_objWSFE1.Url = urlWsfe_Wsdl1

    getLastDocV1()

    While True
      System.Threading.Thread.Sleep(interval)
      work
    End While    
    
  End Sub

  Private Sub work()
    Try

      cLog.write("Timer tick", "work", c_module)

      m_cancel = False
      processFacturas()
      processCompRequest()
      processGetLastNumbers()

    Catch ex As Exception

      cLog.write(ex.Message, "work", c_module)

    End Try
  End Sub

  Public Sub endProcess()

    cLog.write("Terminando la ejecución de CSFacturaElectronica Service", "endProcess", c_module)

    Try

      m_Timer.Stop()

      m_cancel = True

    Catch ex As Exception

      cLog.write(ex.Message, "endProcess ***Error:", c_module)

    End Try

    cLog.write("Ejecución de CSBackup Service terminada con éxito", "endProcess", c_module)

  End Sub

  '//------------------------------------------------------------------------------
  '
  ' Factura electronica
  '
  '--------------------------------------------------------------------------------

  Private Sub processFacturas()
    Dim rs As DataSet = Nothing

    try

      cLog.write("1", "processFacturas", c_module)

      If Not pConnect() Then Exit Sub

      cLog.write("2", "processFacturas", c_module)

      If m_cancel Then Exit Sub

      If Not initWSAA() Then Exit Sub
      
      cLog.write("3", "processFacturas", c_module)

      Dim sqlstmt As String

      sqlstmt = "sp_FE_GetFacturas " & m_emp_id

      If Not m_cn.openRs(sqlstmt, rs) Then Exit Sub

      cLog.write("4", "processFacturas", c_module)

      Dim dr As DataRow
      Dim cae As cCAE

      For Each dr In rs.Tables(0).Rows

        cLog.write("in for 1", "processFacturas", c_module)

        Dim ArrayOfIva() As ar.gov.afip.wsfev1homo.AlicIva
        If Not pGetArrayOfIva(dr.Item("fv_id"), ArrayOfIva) Then Exit Sub

        Dim ArrayOfTributos() As ar.gov.afip.wsfev1homo.Tributo
        If Not pGetArrayOfTributo(dr.Item("fv_id"), ArrayOfTributos) Then Exit Sub

        cLog.write("in for 2", "processFacturas", c_module)


        If(dr.Item("es_factura_expo")) then

              Dim feExpo as cFacturaElectronicaExpo = New cFacturaElectronicaExpo
              
              cae = feExpo.getCAE_EX(m_wsaa, _
                                      urlWsfex_Wsdl, _
                                      m_cuit, _
                                      dr.Item("fv_id"), _
                                      dr.Item("nro_doc"), _
                                      dr.Item("cli_razonsocial"), _
                                      dr.Item("tipo_doc"), _
                                      dr.Item("nro_doc"), _
                                      dr.Item("tipo_cbte"), _
                                      dr.Item("punto_vta"), _
                                      dr.Item("cbt_desde"), _
                                      dr.Item("cbt_hasta"), _
                                      dr.Item("imp_total_origen"), _
                                      dr.Item("imp_tot_conc"), _
                                      dr.Item("imp_neto"), _
                                      dr.Item("impto_liq"), _
                                      dr.Item("impto_liq_rni"), _
                                      dr.Item("imp_tributo"), _
                                      dr.Item("imp_op_ex"), _
                                      dr.Item("moneda_id"), _
                                      dr.Item("moneda_cotizacion"), _
                                      dr.Item("pais_id"), _
                                      CDate(dr.Item("fecha_cbte")).ToString("yyyyMMdd"), _
                                      CDate(dr.Item("fecha_serv_desde")).ToString("yyyyMMdd"), _
                                      CDate(dr.Item("fecha_serv_hasta")).ToString("yyyyMMdd"), _
                                      CDate(dr.Item("fecha_venc_pago")).ToString("yyyyMMdd"), _
                                      ArrayOfIva,
                                      ArrayOfTributos)
        
        Else

              cae = getCAEV1(dr.Item("cuit"), _
                              dr.Item("tipo_doc"), _
                              dr.Item("nro_doc"), _
                              dr.Item("tipo_cbte"), _
                              dr.Item("punto_vta"), _
                              dr.Item("cbt_desde"), _
                              dr.Item("cbt_hasta"), _
                              dr.Item("imp_total"), _
                              dr.Item("imp_tot_conc"), _
                              dr.Item("imp_neto"), _
                              dr.Item("impto_liq"), _
                              dr.Item("impto_liq_rni"), _
                              dr.Item("imp_tributo"), _
                              dr.Item("imp_op_ex"), _
                              CDate(dr.Item("fecha_cbte")).ToString("yyyyMMdd"), _
                              CDate(dr.Item("fecha_serv_desde")).ToString("yyyyMMdd"), _
                              CDate(dr.Item("fecha_serv_hasta")).ToString("yyyyMMdd"), _
                              CDate(dr.Item("fecha_venc_pago")).ToString("yyyyMMdd"), _
                              ArrayOfIva,
                              ArrayOfTributos)
        End If

        If cae.cae <> "" And LCase$(cae.cae) <> "null" Then
          sqlstmt = "sp_FE_UpdateCae " & dr.Item("fv_id") _
                                        & ",'" & cae.cae & "','" _
                                        & cae.nro_factura & "','" _
                                        & cae.vencimiento & "','" _
                                        & CDate(dr.Item("fecha_cbte")).ToString("yyyyMMdd") & "'"
          m_cn.Execute(sqlstmt)

          sendEmail(dr.Item("fv_id"))
        End If

      Next

    Catch ex As Exception

      cLog.write(ex.Message, "processFacturas", c_module)

    Finally

      If Not rs Is Nothing Then
        rs.Dispose()
      End if

    End Try

  End Sub

  Private Function pGetArrayOfIva(ByVal fv_id As Long, ByRef ArrayOfIva() As ar.gov.afip.wsfev1homo.AlicIva) As Boolean
    Dim rs As DataSet = Nothing
    Dim sqlstmt As String

    sqlstmt = "sp_FE_GetIvasForFactura " & fv_id

    If Not m_cn.openRs(sqlstmt, rs) Then Exit Function

    Dim dr As DataRow
    Dim i As Integer = 0

    Try

      For Each dr In rs.Tables(0).Rows

        ReDim Preserve ArrayOfIva(i)
        ArrayOfIva(i) = New ar.gov.afip.wsfev1homo.AlicIva
        With ArrayOfIva(i)
          .BaseImp = dr.Item("baseImp")
          .Id = dr.Item("ivaId")
          .Importe = dr.Item("importe")
        End With
        i += 1
      Next

    Catch ex As Exception

      cLog.write(ex.Message, "processFacturas", c_module)

      Return False

    Finally

      rs.Dispose()

    End Try

    Return True

  End Function

  Private Function pGetArrayOfTributo(ByVal fv_id As Long, ByRef ArrayOfTributo() As ar.gov.afip.wsfev1homo.Tributo) As Boolean
    Dim rs As DataSet = Nothing
    Dim sqlstmt As String

    sqlstmt = "sp_FE_GetTributosForFactura " & fv_id

    If Not m_cn.openRs(sqlstmt, rs) Then Exit Function

    Dim dr As DataRow
    Dim i As Integer = 0

    Try

      For Each dr In rs.Tables(0).Rows

        ReDim Preserve ArrayOfTributo(i)
        ArrayOfTributo(i) = New ar.gov.afip.wsfev1homo.Tributo
        With ArrayOfTributo(i)
          .BaseImp = dr.Item("baseImp")
          .Id = dr.Item("tribId")
          .Importe = dr.Item("importe")
          .Alic = dr.Item("alic")
        End With
        i += 1
      Next

    Catch ex As Exception

      cLog.write(ex.Message, "processFacturas", c_module)

      Return False

    Finally

      rs.Dispose()

    End Try

    Return True

  End Function

  Private Function getCAEV1(ByVal cuit As Long, _
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
                            ByVal fecha_cbte As String, _
                            ByVal fecha_serv_desde As String, _
                            ByVal fecha_serv_hasta As String, _
                            ByVal fecha_venc_pago As String, _
                            ByVal ArrayOfIva() As ar.gov.afip.wsfev1homo.AlicIva,
                            ByVal ArrayOfTributos() As ar.gov.afip.wsfev1homo.Tributo) As cCAE

    Dim cantidadreg As Integer = 1
    Dim indicemax As Integer = 0
    Dim d As Integer = 0

    Dim objFERequest As New ar.gov.afip.wsfev1homo.FECAERequest
    Dim objFECabeceraRequest As New ar.gov.afip.wsfev1homo.FECAECabRequest
    Dim ArrayOfFEDetalleRequest(indicemax) As ar.gov.afip.wsfev1homo.FECAEDetRequest
    Dim objFEResponse As New ar.gov.afip.wsfev1homo.FECAEResponse

    Dim cae As New cCAE

    m_objFEAuthRequest1.Cuit = cuit
    m_objFEAuthRequest1.Token = m_wsaa.token
    m_objFEAuthRequest1.Sign = m_wsaa.sign

    '
    '----------------------------------------------

    objFECabeceraRequest.CantReg = cantidadreg
    objFECabeceraRequest.PtoVta = punto_vta
    objFECabeceraRequest.CbteTipo = tipo_cbte
    objFERequest.FeCabReq = objFECabeceraRequest

    Dim objFEDetalleRequest As New ar.gov.afip.wsfev1homo.FECAEDetRequest
    With objFEDetalleRequest
      .Concepto = 1
      .DocTipo = tipo_doc
      .DocNro = nro_doc
      .CbteDesde = cbt_desde ' last_cbte_nro + 1 'cbt_desde
      .CbteHasta = cbt_hasta ' last_cbte_nro + 1 'cbt_hasta
      .ImpTotal = imp_total
      .ImpTotConc = imp_tot_conc
      .ImpNeto = imp_neto
      .ImpIVA = impto_liq
      .ImpTrib = imp_tributo
      .ImpOpEx = imp_op_ex
      .CbteFch = fecha_cbte
      .Iva = ArrayOfIva
      .Tributos = ArrayOfTributos
      .MonId = "PES"
      .MonCotiz = 1
    End With
    ArrayOfFEDetalleRequest(d) = objFEDetalleRequest
    objFERequest.FeDetReq = ArrayOfFEDetalleRequest

    cLog.write("****************************************", "", "")

    cLog.write("Factura: " & vbCrLf & _
                "tipo_doc = " & tipo_doc & vbCrLf & _
                "nro_doc = " & nro_doc & vbCrLf & _
                "tipo_cbte = " & tipo_cbte & vbCrLf & _
                "punto_vta = " & punto_vta & vbCrLf & _
                "cbt_desde = " & cbt_desde & vbCrLf & _
                "cbt_hasta = " & cbt_hasta & vbCrLf & _
                "imp_total = " & imp_total & vbCrLf & _
                "imp_tot_conc = " & imp_tot_conc & vbCrLf & _
                "imp_neto = " & imp_neto & vbCrLf & _
                "impto_liq = " & impto_liq & vbCrLf & _
                "impto_liq_rni = " & impto_liq_rni & vbCrLf & _
                "imp_op_ex = " & imp_op_ex & vbCrLf & _
                "fecha_cbte = " & fecha_cbte & vbCrLf & _
                "fecha_serv_desde = " & fecha_serv_desde & vbCrLf & _
                "fecha_serv_hasta = " & fecha_serv_hasta & vbCrLf & _
                "fecha_venc_pago = " & fecha_venc_pago & vbCrLf _
                , "getCAEV1", c_module)

    ' Invoco al método FEAutRequest
    Try
      cLog.write("llamando a getcae", "", "")
      objFEResponse = m_objWSFE1.FECAESolicitar(m_objFEAuthRequest1, objFERequest)
      cLog.write("getcae respondio", "", "")
      If objFEResponse.FeCabResp Is Nothing Then
        cLog.write("FEResponse.Errors: " + objFEResponse.Errors.ToString + vbCrLf _
                   , "getCAEV1: FEResponse:", c_module)
        
        Dim err As ar.gov.afip.wsfev1homo.Err

        For Each err in objFEResponse.Errors
          cLog.write("err-code: " & err.Code, "", c_module)
          cLog.write("err-message: " & err.Msg, "", c_module)
        Next err

      Else
        cLog.write("FEResponse.FecResp.resultado: " + objFEResponse.FeCabResp.Resultado + vbCrLf _
                    , "getCAEV1: FEResponse", c_module)

        cLog.write("FeCabResp Is Not Nothing", "", "")

        ' Solo si fue aprobada
        '
        If objFEResponse.FeCabResp.Resultado = "A" Then
          cLog.write("CAE Aprobado ", "getCAEV1: FEResponse", c_module)
        Else
          cLog.write("CAE Rechazado", "getCAEV1: FEResponse", c_module)
        End If

        cLog.write("1", "", "")

        If Not objFEResponse.Errors Is Nothing Then

          cLog.write("FEResponse.Errors: " + objFEResponse.Errors.ToString + vbCrLf _
                      , "getCAEV1: FEResponse", c_module)

          Dim err As ar.gov.afip.wsfev1homo.Err
          For Each err In objFEResponse.Errors
            cLog.write("Error " + err.Msg, "getCAEV1: Error", c_module)
          Next

        End If

        cLog.write("2", "", "")

        If Not objFEResponse.FeDetResp Is Nothing Then

          cLog.write("3", "", "")

          For d = 0 To (indicemax)

            ' Solo si fue aprobada
            '
            If objFEResponse.FeDetResp(d).Resultado = "A" Then
              cLog.write("Comprobante Aprobado ", "getCAEV1: FEResponse", c_module)
            Else
              cLog.write("Comprobante Rechazado", "getCAEV1: FEResponse", c_module)
            End If

            cae.cae = objFEResponse.FeDetResp(d).CAE.ToString
            cae.nro_factura = objFEResponse.FeDetResp(d).CbteDesde
            cae.vencimiento = objFEResponse.FeDetResp(d).CAEFchVto
            cLog.write("FEResponse.FedResp(" + d.ToString + ").cae: " + objFEResponse.FeDetResp(d).CAE.ToString + vbCrLf + _
                        "FEResponse.FedResp(" + d.ToString + ").cbt_desde: " + objFEResponse.FeDetResp(d).CbteDesde.ToString + vbCrLf + _
                        "FEResponse.FedResp(" + d.ToString + ").resultado: " + objFEResponse.FeDetResp(d).Resultado + vbCrLf _
                        , "getCAEV1: FEResponse", c_module)


            If Not objFEResponse.FeDetResp(d).Observaciones Is Nothing Then

              Dim obs As ar.gov.afip.wsfev1homo.Obs
              For Each obs In objFEResponse.FeDetResp(d).Observaciones
                cLog.write("Error " + obs.Msg, "getCAEV1: Error", c_module)
              Next

            End If

          Next d

        End If

        cLog.write("4", "", "")

      End If

    Catch ex As Exception
      cLog.write(ex.Message, "getCAEV1", c_module)
    End Try

    Return cae

  End Function

  Private Sub processGetLastNumbers()

    If Not pConnect() Then Exit Sub

    Dim rs As DataSet = Nothing
    Dim sqlstmt As String

    Try

      sqlstmt = "sp_FE_GetConsultaTalonarios " & m_emp_id

      If Not m_cn.openRs(sqlstmt, rs) Then Exit Sub

      Dim strResponse As String = ""
      Dim dr As DataRow

      For Each dr In rs.Tables(0).Rows

        Dim lastNumber As Integer
        lastNumber = getLastDocV1(dr.Item("ta_puntovta"), _
                                  dr.Item("ta_tipoafip"))

        sqlstmt = "sp_FE_UpdateConsultaTalonario " & dr.Item("ta_id") _
                                                   & "," & lastNumber
        m_cn.Execute(sqlstmt)

        strResponse += "Pto. Vta.: " & dr.Item("ta_puntovta") _
                        & "  Tipo Comp.: " & getTipoComp(dr.Item("ta_tipoafip")) _
                        & "  Numero: " & lastNumber & vbCrLf
      Next

      If strResponse = "" Then

        strResponse = "No hay talonarios que actualizar"

      End If

      sqlstmt = "sp_FE_UpdateConsultaTalonarios '" & strResponse & "', " & m_emp_id

      m_cn.Execute(sqlstmt)

    Catch ex As Exception

      cLog.write(ex.Message, "processGetLastNumbers", c_module)

    Finally

      rs.Dispose()

    End Try

  End Sub

  Private Function getTipoComp(ByVal tipoComp As Integer) As String

    Select Case tipoComp
      Case 1
        Return "Factura A"
      Case 6
        Return "Factura B"
      Case 11
        Return "Factura C"
      Case 3
        Return "Nota de Credito A"
      Case 8
        Return "Nota de Credito B"
      Case 13
        Return "Nota de Credito C"
      Case 2
        Return "Nota de Dedito A"
      Case 7
        Return "Nota de Dedito B"
      Case 12
        Return "Nota de Dedito C"

      Case Else
        Return ""
    End Select

  End Function

  Private Sub processCompRequest()

    If Not pConnect() Then Exit Sub

    Dim rs As DataSet = Nothing
    Dim sqlstmt As String

    Try

      sqlstmt = "sp_FE_GetConsultaComprobantes"

      If Not m_cn.openRs(sqlstmt, rs) Then Exit Sub

      Dim dr As DataRow
      Dim response As ar.gov.afip.wsfev1homo.FECompConsResponse
      Dim strResponse As String = ""

      For Each dr In rs.Tables(0).Rows

        response = getComp(dr.Item("fvfec_cuit"), _
                           dr.Item("fvfec_tipdoc"), _
                           dr.Item("fvfec_ptovta"), _
                           dr.Item("fvfec_numero"))

        strResponse = ""

        If Not response Is Nothing Then
          strResponse = "Fecha: " & response.CbteFch & vbCrLf & _
                        "Vto:" & response.FchVto & vbCrLf & _
                        "Nro:" & response.DocNro & vbCrLf & _
                        "Tipo:" & response.DocTipo.ToString() & vbCrLf & _
                        "Pto Vta:" & response.PtoVta.ToString() & vbCrLf & _
                        "Neto:" & response.ImpNeto.ToString() & vbCrLf & _
                        "Tot Conceptos:" & response.ImpTotConc.ToString() & vbCrLf & _
                        "Tributos:" & response.ImpTrib.ToString() & vbCrLf & _
                        "Op Exentas:" & response.ImpOpEx.ToString() & vbCrLf & _
                        "Total:" & response.ImpTotal.ToString() & vbCrLf & _
                        "Resultado: " & response.Resultado & vbCrLf & _
                        "Cae:" & response.CodAutorizacion & vbCrLf & _
                        "Concepto:" & response.Concepto & vbCrLf & _
                        "Tipo Emision:" & response.EmisionTipo & vbCrLf & _
                        "Fecha Proc:" & response.FchProceso & vbCrLf & _
                        "Imp. Iva:" & response.ImpIVA & vbCrLf & _
                        "Imp. Trib:" & response.ImpTrib & vbCrLf & _
                        "Moneda:" & response.MonId & vbCrLf

          Dim strObs As String = ""
          Dim obs As ar.gov.afip.wsfev1homo.Obs
          If Not response.Observaciones Is Nothing Then

            For Each obs In response.Observaciones
              strObs += obs.Code.ToString & " " & obs.Msg & vbCrLf
            Next

          End If

          Dim strIva As String = ""
          If Not response.Iva Is Nothing Then


            Dim iva As ar.gov.afip.wsfev1homo.AlicIva
            For Each iva In response.Iva
              strIva += "Base Imponible: " & iva.BaseImp & vbCrLf & _
                        "Base Imponible: :" & iva.Importe & vbCrLf & _
                        "Id: :" & iva.Id & vbCrLf
            Next

          End If

          strResponse += "IVA:" & strIva & vbCrLf
          strResponse += "Observaciones:" & vbCrLf & strObs

        Else

          strResponse = "Ocurrio un error al solicitar informacion sobre el comprobante: " & vbCrLf & _
                        "CUIT:" & dr.Item("fvfec_cuit").ToString() & vbCrLf & _
                        "Tipo Doc:" & dr.Item("fvfec_tipdoc").ToString() & vbCrLf & _
                        "Pto Vta:" & dr.Item("fvfec_ptovta").ToString() & vbCrLf & _
                        "Nro Comp:" & dr.Item("fvfec_numero").ToString()
        End If

        sqlstmt = "sp_FE_UpdateConsultaComprobante " & dr.Item("fvfec_id") _
                               & ",'" & strResponse & "'"
        m_cn.Execute(sqlstmt)

      Next

    Catch ex As Exception

      cLog.write(ex.Message, "processCompRequest", c_module)

    Finally

      rs.Dispose()

    End Try

  End Sub

  Private Function getComp(ByVal cuit As Long, _
                           ByVal cbteTipo As Integer, _
                           ByVal ptoVta As Integer, _
                           ByVal cbteNro As Integer) As ar.gov.afip.wsfev1homo.FECompConsResponse

    Dim objFERequest As New ar.gov.afip.wsfev1homo.FECompConsultaReq

    objFERequest.CbteNro = cbteNro
    objFERequest.CbteTipo = cbteTipo
    objFERequest.PtoVta = ptoVta

    m_objFEAuthRequest1.Cuit = cuit
    m_objFEAuthRequest1.Token = m_wsaa.token
    m_objFEAuthRequest1.Sign = m_wsaa.sign

    Dim objFECompResponse As New ar.gov.afip.wsfev1homo.FECompConsultaResponse
    Try

      objFECompResponse = m_objWSFE1.FECompConsultar(m_objFEAuthRequest1, objFERequest)
      Dim response As ar.gov.afip.wsfev1homo.FECompConsResponse = objFECompResponse.ResultGet

      If response Is Nothing Then
        Dim objError As ar.gov.afip.wsfev1homo.Err
        For Each objError In objFECompResponse.Errors
          cLog.write("FEUltNroResponse.RError.percode: " + objError.Code.ToString() + vbCrLf + _
                     "FEUltNroResponse.RError.perrmsg: " + objError.Msg + vbCrLf + vbCrLf + _
                     "No se pudo setear el campo FECabeceraRequest.id del Formulario" _
                     , "getCAE: FEUltNroResponse:", c_module)
        Next
      End If

      Return response

    Catch ex As Exception

      cLog.write(ex.Message, "getCAE", c_module)
      Return Nothing

    End Try

  End Function

  Private Function initWSAA() As Boolean
    Try

      If m_wsaa Is Nothing Then
        m_wsaa = New cFEWSAA
      End If

      If m_wsaa.expirationTime < DateAdd(DateInterval.Minute, -5, Now) Then
        m_ticketAutorization = m_wsaa.getTA(m_urlWsaaWsdl, _
                                            m_idServicioNegocio, _
                                            m_rutaCertSigner, _
                                            m_proxy, _
                                            m_proxyUser, _
                                            m_proxyPassword, _
                                            m_verboseMode)
      End If
      Return True

    Catch ex As Exception
      cLog.write(ex.Message, "initWSAA", c_module)
      Return False
    End Try

  End Function

  Private Sub getLastDocV1()

    Try

      cLog.write("Line: 1", "getLastDocV1", c_module)
      If Not initWSAA() Then Exit Sub

      cLog.write("Line: 2", "getLastDocV1", c_module)
      If Not pConnect() Then Exit Sub

      Dim objFEResponse As New ar.gov.afip.wsfev1homo.FERecuperaLastCbteResponse
      Dim last_cbte_nro As Long

      cLog.write("Line: 3", "getLastDocV1", c_module)
      m_objFEAuthRequest1.Cuit = m_cuit
      'm_objFEAuthRequest1.cuit = 30707587241
      'm_objFEAuthRequest1.Cuit = 20250282010
      m_objFEAuthRequest1.Token = m_wsaa.token
      m_objFEAuthRequest1.Sign = m_wsaa.sign

      cLog.write("Line: 4", "getLastDocV1", c_module)
      '----------------------------------------------------------------------------------
      Dim vTipoCbte(8) As Integer
      vTipoCbte(0) = 1
      vTipoCbte(1) = 6
      vTipoCbte(2) = 11
      vTipoCbte(3) = 3
      vTipoCbte(4) = 8
      vTipoCbte(5) = 13
      vTipoCbte(6) = 2
      vTipoCbte(7) = 7
      vTipoCbte(8) = 12

      cLog.write("Line: 5", "getLastDocV1", c_module)

      Dim ptoVta(1) As Integer
      ptoVta(0) = m_ptoVta1
      ptoVta(1) = m_ptoVta2
      'ptoVta(0) = 1
      'ptoVta(1) = 1

      Dim i As Integer
      Dim j As Integer

      cLog.write("Line: 6", "getLastDocV1", c_module)

      For j = 0 To 1
        If ptoVta(j) > 0 then
          
          cLog.write("Line: 7: " & j , "getLastDocV1", c_module)
          
          For i = 0 To 8

            Try
              objFEResponse = m_objWSFE1.FECompUltimoAutorizado(m_objFEAuthRequest1, ptoVta(j), vTipoCbte(i))
            
              last_cbte_nro = objFEResponse.CbteNro

              cLog.write("Pto. Vta.: " & ptoVta(j) & "  cbte_tipo: " & vTipoCbte(i) & "  numero: " & last_cbte_nro, "getLastDoc1", c_module)

            Catch ex As Exception
              cLog.write(ex.Message, "getLastDoc1", c_module)
            End Try
          Next
        end if
      Next
      '
      '----------------------------------------------

      cLog.write("Line: 8", "getLastDocV1", c_module)

      Dim tiposIva As ar.gov.afip.wsfev1homo.IvaTipoResponse = m_objWSFE1.FEParamGetTiposIva(m_objFEAuthRequest1)
      Dim tipoIva As ar.gov.afip.wsfev1homo.IvaTipo

      cLog.write("Line: 9", "getLastDocV1", c_module)

      Try
        For Each tipoIva In tiposIva.ResultGet
          cLog.write("Id: " & tipoIva.Id & " - Desc: " & tipoIva.Desc & " - Fecha Desde " & tipoIva.FchDesde & " - Fecha Hasta " & tipoIva.FchHasta, "", "")
        Next
      Catch ex As Exception
        cLog.write(ex.Message, "getLastDocV1 3", c_module)
      End Try

      cLog.write("Line: 10", "getLastDocV1", c_module)

      Dim tiposMoneda As ar.gov.afip.wsfev1homo.MonedaResponse = m_objWSFE1.FEParamGetTiposMonedas(m_objFEAuthRequest1)
      Dim tipoMoneda As ar.gov.afip.wsfev1homo.Moneda

      cLog.write("Line: 11", "getLastDocV1", c_module)

      try
        For Each tipoMoneda In tiposMoneda.ResultGet
          cLog.write("Id: " & tipoMoneda.Id & " - Desc: " & tipoMoneda.Desc & " - Fecha Desde " & tipoMoneda.FchDesde & " - Fecha Hasta " & tipoMoneda.FchHasta, "", "")
        Next
      Catch ex As Exception
        cLog.write(ex.Message, "getLastDocV1 3", c_module)
      End Try

      cLog.write("Line: 12", "getLastDocV1", c_module)

      Dim tiposTributo As ar.gov.afip.wsfev1homo.FETributoResponse = m_objWSFE1.FEParamGetTiposTributos(m_objFEAuthRequest1)
      Dim tipoTributo As ar.gov.afip.wsfev1homo.TributoTipo

      cLog.write("Line: 9", "getLastDocV1", c_module)

      Try
        For Each tipoTributo In tiposTributo.ResultGet
          cLog.write("Id: " & tipoTributo.Id & " - Desc: " & tipoTributo.Desc & " - Fecha Desde " & tipoTributo.FchDesde & " - Fecha Hasta " & tipoTributo.FchHasta, "", "")
        Next
      Catch ex As Exception
        cLog.write(ex.Message, "getLastDocV1 3", c_module)
      End Try

    Catch ex As Exception
      Dim st As StackTrace
      st = New StackTrace(ex, True)
      cLog.write("Line: " & st.GetFrame(0).GetFileLineNumber().ToString, "getLastDocV1 3", c_module)
      cLog.write(ex.Message, "getLastDocV1 3", c_module)
    End Try
  End Sub

  Private Function getLastDocV1(ByVal ptoVta As Integer, ByVal tipoDoc As Integer) As Long

    Try

      If Not initWSAA() Then Exit Function

      If Not pConnect() Then Exit Function

      Dim objFEResponse As New ar.gov.afip.wsfev1homo.FERecuperaLastCbteResponse
      Dim last_cbte_nro As Long

      m_objFEAuthRequest1.Cuit = m_cuit
      'm_objFEAuthRequest1.cuit = 30707587241
      'm_objFEAuthRequest1.Cuit = 20250282010
      m_objFEAuthRequest1.Token = m_wsaa.token
      m_objFEAuthRequest1.Sign = m_wsaa.sign

      '----------------------------------------------------------------------------------

      Try
        objFEResponse = m_objWSFE1.FECompUltimoAutorizado(m_objFEAuthRequest1, ptoVta, tipoDoc)
        last_cbte_nro = objFEResponse.CbteNro

        cLog.write("Pto. Vta.: " & ptoVta & "  cbte_tipo: " & tipoDoc & "  numero: " & last_cbte_nro, "getLastDoc1", c_module)

        Return last_cbte_nro

      Catch ex As Exception
                cLog.write(ex.Message, "getLastDocV1 1", c_module)
                cLog.write(Environment.StackTrace.ToString(), "getLastDocV1 1", c_module)
      End Try
      '
      '----------------------------------------------

    Catch ex As Exception
            cLog.write(ex.Message, "getLastDocV1 2", c_module)
            cLog.write(Environment.StackTrace.ToString(), "getLastDocV1 2", c_module)
    End Try
  End Function

  Private Function pConnect() As Boolean

    If Not pCreateConnectionObject() Then
      Return False
    End If

    Return m_cn.OpenConnectionEx(m_serverName, m_user, m_password, m_useTrusted, m_database, True)
  End Function

  Private Function pCreateConnectionObject() As Boolean

    Try
      If Not m_cn Is Nothing Then
        m_cn.Dispose()
        m_cn = Nothing
      End If
    Catch ex As Exception
      cLog.write(ex.Message, "pCreateConnectionObject", c_module)
    End Try

    Try
      m_cn = New cConnection
    Catch ex As Exception
      cLog.write(ex.Message, "pCreateConnectionObject", c_module)
      Return False
    End Try

    Return True

  End Function

  Private Function pGetTrabajoImpresionId(ByVal docId As Long, ByVal fvId As Long, ByVal empId As Long, ByVal fvNroDoc As String, ByVal empNombre As String) As Long
    Dim sqlstmt As String
    Dim rs As DataSet = Nothing

    Try

      sqlstmt = "sp_TrabajoImpresionSave 0, " _
                                & sqlDate(Now) & "," _
                                & sqlString(Environment.MachineName) & "," _
                                & C_PRINT_SERVICE_STATE_WRITING & "," _
                                & "0," _
                                & docId & "," _
                                & fvId & "," _
                                & "1," _
                                & empId & "," _
                                & "1," _
                                & sqlString(empNombre & ": Comprobante de Factura Electronica " & fvNroDoc)

      If Not m_cn.openRs(sqlstmt, rs) Then Exit Function
      If rs.Tables(0).Rows.Count = 0 Then Exit Function

      Dim dr As DataRow
      dr = rs.Tables(0).Rows(0)

      Return dr.Item("timp_id")

    Catch ex As Exception

      cLog.write(ex.Message, "pGetTrabajoImpresionId", c_module)

    Finally

      rs.Dispose()

    End Try
  End Function

  Private Function pSetTrabajoImpresionStateReadyToPrint(ByVal timp_id As Long, ByVal docId As Long, ByVal fvId As Long, ByVal empId As Long) As Boolean
    Dim sqlstmt As String

    sqlstmt = "sp_TrabajoImpresionSave " & timp_id & ", " _
                              & sqlDate(Now) & "," _
                              & sqlString(Environment.MachineName) & "," _
                              & C_PRINT_SERVICE_STATE_READY & "," _
                              & "0," _
                              & DocId & "," _
                              & fvId & "," _
                              & "1," _
                              & empId

    If Not m_cn.Execute(sqlstmt) Then Exit Function

    Return True

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
                              & sqlString(rptName) & "," _
                              & sqlString(rptFile) & "," _
                              & "2," _
                              & copies & "," _
                              & sqlString(strObject)

    Return m_cn.Execute(sqlstmt)

  End Function

  Private Function sendEmail(ByVal fvId As Long) As Boolean
    Dim rs As DataSet = Nothing
    Dim sqlstmt As String

    sqlstmt = "select fv.doc_id, fv.emp_id, fv.fv_nrodoc, emp.emp_nombre" _
              & " from FacturaVenta fv inner join Empresa emp on fv.emp_id = emp.emp_id" _
              & " where fv.fv_id = " & fvId

    If Not m_cn.openRs(sqlstmt, rs) Then Exit Function

    Dim dr As DataRow
    Dim docId As Long
    Dim empId As Long
    Dim fvNroDoc As String
    Dim empNombre As String

    Try

      If rs.Tables(0).Rows.Count = 0 Then Exit Function

      dr = rs.Tables(0).Rows(0)

      docId = dr.Item("doc_id")
      empId = dr.Item("emp_id")
      empNombre = dr.Item("emp_nombre")
      fvNroDoc = dr.Item("fv_nrodoc")

    Catch ex As Exception

      cLog.write(ex.Message, "processFacturas", c_module)

      Return False

    Finally

      rs.Dispose()

    End Try

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

    If Not m_cn.openRs(sqlstmt, rs) Then Exit Function

    Try

      For Each dr In rs.Tables(0).Rows

        If Not pPrintReportToService( _
                                      timp_id, _
                                      dr.Item("rptf_nombre"), _
                                      dr.Item("rptf_csrfile"), _
                                      2, _
                                      dr.Item("rptf_object")) Then Exit Function
      Next

    Catch ex As Exception

      cLog.write(ex.Message, "processFacturas", c_module)

      Return False

    Finally

      rs.Dispose()

    End Try

    If Not pSetTrabajoImpresionStateReadyToPrint(timp_id, docId, fvId, empId) Then Exit Function

    Return True
  End Function

  Private Function sqlDate(ByVal dDate As Date) As String
    Return Format(dDate, "\'yyyyMMdd HH:mm:ss\'")
  End Function

  Private Function sqlString(ByVal sString As String) As String
    Return "'" + sString.Replace("'", "''") + "'"
  End Function

End Class

Public Class cCAE
  Public cae As String
  Public nro_factura As String
  Public vencimiento As String
End Class

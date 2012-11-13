Attribute VB_Name = "mPublic"
Option Explicit

'--------------------------------------------------------------------------------
' mPublic
' 30-07-2003

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "mPublic"

Public Const C_IVA_EXENTO = 4             '04  IVA Sujeto Exento
Public Const C_IVA_PROVEEDOR_EXTERIOR = 8 '08  Proveedor del Exterior
Public Const C_IVA_CLIENTE_EXTERIOR = 9   '09  Cliente del Exterior
Public Const C_IVA_IVA_LIBERADO = 10      '10  IVA Liberado - ley 19640

Public Const LOG_NAME = "\CSAFIPRes1361.log"
Public Const LOG_NAME2 = "\CSAFIPRes1361"

Private Const KI_PROVC_ID                       As Integer = 1
Private Const KI_NUMERO                         As Integer = 2
Private Const KI_DESCRIP                        As Integer = 3
Private Const KI_FECHAVTO                       As Integer = 4
Private Const KI_ACTIVO                         As Integer = 6

' estructuras
' variables privadas
Private m_db As cDataBase
' eventos
' propiedades publicas
Public gAppName     As String
Public gDB          As cDataBase

Public rsConceptosVtas        As ADODB.Recordset
Public rsConceptosCpra        As ADODB.Recordset
Public rsTipoFormulariosVta   As ADODB.Recordset
Public rsTipoFormulariosCpra  As ADODB.Recordset

Public rsMonedas           As ADODB.Recordset
Public rsIVA               As ADODB.Recordset
' propiedades friend
' propiedades privadas
' funciones publicas
Public Function DestroyDbAccess()
  On Error Resume Next
  m_db.CloseDb
  Set m_db = Nothing
End Function

Public Function GetgDB(ByVal Parametros As cIAFIPParametros, ByVal FolderDBF As String) As cDataBase
  Dim StrConnect As String
  
  If m_db Is Nothing Then
    Set m_db = New cDataBase
  End If
  
  StrConnect = GetStrConnect(Parametros, FolderDBF)
  
  If m_db.OriginalStrConnect <> StrConnect Then
    If Not m_db.InitDB(, , , , StrConnect) Then
      Err.Raise c_ErrorClientOpenDB, "SAFIPRes1361", LastErrorInfo
    End If
  End If
  
  Set GetgDB = m_db
End Function

Public Function GetStrConnect(ByVal Parametros As cIAFIPParametros, Optional ByVal FolderDBF As String) As String
  Dim StrConnect As String
  
  StrConnect = GetParamValue(C_Param_StrConnect, Parametros)
  StrConnect = ReplaceMacros(StrConnect, Parametros, FolderDBF)
  
  GetStrConnect = StrConnect
End Function

Public Function ReplaceMacros(ByVal stmt As String, ByRef Parametros As cIAFIPParametros, Optional ByVal FolderDBF As String) As String
    
  stmt = Replace(stmt, C_Macro_FechaDesde, GetDate(C_Param_FechaDesde, Parametros))
  stmt = Replace(stmt, C_Macro_FechaHasta, GetDate(C_Param_FechaHasta, Parametros))
  stmt = Replace(stmt, C_Macro_Path, GetValidPath(GetParamValue(C_Param_Path, Parametros)) & FolderDBF)
  
  ReplaceMacros = stmt
End Function

'Código Moneda
'002  DÓLAR EEUU LIBRE
'003  FRANCOS FRANCESES
'004  LIRAS ITALIANAS
'005  PESETAS
'006  MARCOS ALEMANES
'007  FLORINES HOLANDESES
'008  FRANCOS BELGAS
'009  FRANCOS SUIZOS
'010  PESOS MEJICANOS
'011  PESOS URUGUAYOS
'012  REAL
'013  ESCUDOS PORTUGUESES
'014  CORONAS DANESAS
'015  CORONAS NORUEGAS
'016  CORONAS SUECAS
'017  CHELINES AUSTRÍACOS
'018  DÓLAR CANADIENSE
'019  YENS
'021  LIBRA ESTERLINA
'022  MARCOS FINLANDESES
'023  BOLÍVAR
'024  CORONA CHECA
'025  DINAR
'026  DÓLAR AUSTRALIANO
'027  DRACMA
'028  FLORÍN (ANTILLAS HOLA
'029  GUARANÍ
'030  SHEKEL (ISRAEL)
'031  PESO BOLIVIANO
'032  PESO COLOMBIANO
'033  PESO CHILENO
'034  RAND
'035  SOL PERUANO
'035  NUEVO SOL PERUANO
'036  SUCRE
'050  LIBRAS IRLANDESAS
'051  DÓLAR DE HONG KONG
'052  DÓLAR DE SINGAPUR
'053  DÓLAR DE JAMAICA
'054  DÓLAR DE TAIWÁN
'055  QUETZAL
'056  FORINT (HUNGRÍA)
'057  BAHT (TAILANDIA)
'058  ECU
'059  DINAR KUWAITÍ
'060  EURO
'DOL  DÓLAR ESTADOUNIDENSE
'PES  PESOS
Public Function AFIPGetCodigoMoneda(ByVal CodMonedaStrad As String) As String
  Dim Fields As ADODB.Fields
   
  If Not pGetMoneda(CodMonedaStrad, Fields) Then
    Err.Raise vbObjectError + 1520, "CSAFIPRes3419", "El codigo de moneda [" & CodMonedaStrad & "] no existe en la tabla Moneda"
  End If
  
  AFIPGetCodigoMoneda = ValField(Fields, "mon_codigoDGI1")
End Function

Public Function AFIPGetCodigoMoneda1361(ByVal CodMonedaStrad As String) As String
  Dim Fields As ADODB.Fields
   
  If Not pGetMoneda(CodMonedaStrad, Fields) Then
    Err.Raise vbObjectError + 1520, "CSAFIPRes1361", "El codigo de moneda [" & CodMonedaStrad & "] no existe en la tabla Moneda"
  End If
  
  AFIPGetCodigoMoneda1361 = ValField(Fields, "mon_codigoDGI2")
End Function

Public Function AFIPGetCodigoIVA(ByVal CodIvaStrad As Double) As String
  Dim Fields As ADODB.Fields
   
  If Not pGetIVA(CodIvaStrad, Fields) Then
    Err.Raise vbObjectError + 1520, "CSAFIPRes3419", "El codigo de IVA [" & CodIvaStrad & "] no existe en la tabla TasaImpositiva"
  End If
  
  AFIPGetCodigoIVA = ValField(Fields, "ti_codigoDGI1")
End Function

Public Function AFIPGetCodigoIVA1361(ByVal CodIvaStrad As Double) As String
  Dim Fields As ADODB.Fields
   
  If CodIvaStrad = 0 Then
    AFIPGetCodigoIVA1361 = 0
  Else
   
    If Not pGetIVA(CodIvaStrad, Fields) Then
      Err.Raise vbObjectError + 1520, "CSAFIPRes1361", "El codigo de IVA [" & CodIvaStrad & "] no existe en la tabla TasaImpositiva"
    End If
  
    AFIPGetCodigoIVA1361 = ValField(Fields, "ti_codigoDGI2")
  End If
End Function

Public Function AFIPGetEsConceptoExento(ByVal CodigoConcepto As String, ByVal Compras As Boolean) As Boolean
  Dim Fields As ADODB.Fields
   
  If Compras Then
    If Not pGetConceptoCpra(CodigoConcepto, Fields) Then
      Err.Raise vbObjectError + 1520, "CSAFIPRes1361/3419", "El codigo de concepto (CODCPT) [" & CodigoConcepto & "] no existe en la tabla PVCO00"
    End If
  Else
    If Not pGetConceptoVta(CodigoConcepto, Fields) Then
      Err.Raise vbObjectError + 1520, "CSAFIPRes1361/3419", "El codigo de concepto (CODCPT) [" & CodigoConcepto & "] no existe en la tabla VTCO00"
    End If
  End If
  
  AFIPGetEsConceptoExento = ValField(Fields, "TASAII") = 0
End Function

Public Function AFIPEsOperacionExenta(ByRef Fields As Fields) As Boolean
  Dim TipoStradIva As Integer
  
  ' Si se da esto estamos ante un comprobante probablemente mal cargado
  ' el usuario recibira un warning cuando se obtengan los datos del proveedor
  ' o cliente. Aca solo contestamos que no es una operacion exenta
  If IsNull(Fields("CNDIVA")) And IsNull(Fields("CNDIVA")) Then
    Exit Function
  End If
  
  If IsNull(Fields("CNDIVA")) Then
    TipoStradIva = Val(ValField(Fields, "CNDIVA"))
  Else
    TipoStradIva = Val(ValField(Fields, "CNDIVA"))
  End If

  Select Case AFIPGetCondicionIva(TipoStradIva)
    Case C_IVA_CLIENTE_EXTERIOR, C_IVA_EXENTO, C_IVA_IVA_LIBERADO, C_IVA_PROVEEDOR_EXTERIOR
      AFIPEsOperacionExenta = True
    Case Else
      AFIPEsOperacionExenta = False
  End Select
End Function

' Tabla DGI
  '01  IVA Responsable Inscripto
  '02  IVA Responsable no Inscripto
  '03  IVA no Responsable
  '04  IVA Sujeto Exento
  '05  Consumidor Final
  '06  Responsable Monotributo
  '07  Sujeto no Categorizado
  '08  Proveedor del Exterior
  '09  Cliente del Exterior
  '10  IVA Liberado - ley 19640
  '11  IVA Responsable Inscripto - Agente de Percepción

' Tabla Strad
  'IVA1  RESPONSABLE INSCRIPTO     (Tasa Normal)
  'IVA2  RESPONSABLE INSCRIPTO    (TN) (Ag. Per.)
  'IVA3  CONSUMIDOR FINAL
  'IVA4  EXENTO
  'IVA5  RESPONSABLE NO INSCRIPTO
  'IVA6  CLIENTE DEL EXTERIOR
  'IVA7  MONOTRIBUTISTA

Public Function AFIPGetCondicionIva(ByVal TipoStrad As Integer) As String
  Select Case TipoStrad
    Case 1
      AFIPGetCondicionIva = "01"
    Case 2
      AFIPGetCondicionIva = "01"
    Case 3
      AFIPGetCondicionIva = "05"
    Case 4
      AFIPGetCondicionIva = "04"
    Case 5
      AFIPGetCondicionIva = "02"
    Case 6
      AFIPGetCondicionIva = "09"
    Case 7
      AFIPGetCondicionIva = "06"
    Case Else
      Err.Raise c_ErrorCondicionIvaStrad, "CSAFIPRes1361/3419", "La condicion de iva strad: " & TipoStrad & " no esta contemplada"
  End Select
End Function

Public Function AFIPGetTipoDoc(ByVal TipoStrad As Integer) As Integer
  Select Case TipoStrad
    Case 72, 80, 90, 95, 93
      AFIPGetTipoDoc = 80 ' CUIT
    Case Else
      'Err.Raise c_ErrorCodigoDocStrad, "CSAFIPRes1361/3419", "El codigo de documento strad: " & TipoStrad & " no esta contemplado"
      AFIPGetTipoDoc = TipoStrad
  End Select
End Function

Public Sub CopyCampos(ByRef FromCampos As cIAFIPCampos, ByRef ToCampos As cIAFIPCampos)
  Dim Campo     As cIAFIPCampo
  
  ToCampos.Clear
  
  For Each Campo In FromCampos
    With ToCampos.Add(Nothing)
      .Activo = Campo.Activo
      .Alineacion = Campo.Alineacion
      .CantDigitosDecimales = Campo.CantDigitosDecimales
      .CantDigitosEnteros = Campo.CantDigitosEnteros
      .Columna = Campo.Columna
      .Creado = Campo.Creado
      .Descrip = Campo.Descrip
      .FormatoFecha = Campo.FormatoFecha
      .ID = Campo.ID
      .Largo = Campo.Largo
      .Modificado = Campo.Modificado
      .Modifico = Campo.Modifico
      .Nombre = Campo.Nombre
      .Posicion = Campo.Posicion
      .Registro = Campo.Registro
      .Relleno = Campo.Relleno
      .SeparadorDecimal = Campo.SeparadorDecimal
      .Tipo = Campo.Tipo
      .Valor = Campo.Valor
    End With
  Next
End Sub

Public Function AFIPGetIvaFromConcepto(ByVal Concepto As String) As Double

End Function

Public Function AFIPGetUnidad(ByVal Unidad As String) As String
  Select Case Unidad
    Case "KGS"
      '01 KILOGRAMO
      AFIPGetUnidad = "01"
    Case "MIL"
      '11 MILLAR
      AFIPGetUnidad = "11"
    Case "MTR"
      '02 METROS
      AFIPGetUnidad = "02"
    Case "SOB", "BOB", "CAJ", ""
      '98 OTRAS UNIDADES
      AFIPGetUnidad = "98"
    Case "UNI"
      '07 UNIDAD
      AFIPGetUnidad = "07"
    Case "GRA"
      AFIPGetUnidad = "14"
    Case "PAQ"
      AFIPGetUnidad = "62"
    Case Else
      Err.Raise vbObjectError + 1005, "CSAFIPRes1361/3419", "La unidad [" & Unidad & "] no esta definida"
  End Select
  
  'Código Descripción
  '01 KILOGRAMO
  '02 METROS
  '03 METRO CUADRADO
  '04 METRO CÚBICO
  '05 LITROS
  '06 1000 KILOWATT HORA
  '07 UNIDAD
  '08 PAR
  '09 DOCENA
  '10 QUILATE
  '11 MILLAR
  '12 MEGA-U. INT. ACT. ANTIB
  '13 UNIDAD INT. ACT. INMUNG
  '14 GRAMO
  '15 MILÍMETRO
  '16 MILÍMETRO CÚBICO
  '17 KILÓMETRO
  '18 HECTOLITRO
  '19 MEGA U. INT. ACT. INMUNG.
  '20 CENTÍMETRO
  '21 KILOGRAMO ACTIVO
  '22 GRAMO ACTIVO
  '23 GRAMO BASE
  '24 UIACTHOR
  '25 JUEGO O PAQUETE MAZO DE NAIPES
  '26 MUIACTHOR
  '27 CENTÍMETRO CÚBICO
  '28 UIACTANT
  '29 TONELADA
  '30 DECÁMETRO CÚBICO
  '31 HECTÓMETRO CÚBICO
  '32 KILÓMETRO CÚBICO
  '33 MICROGRAMO
  '34 NANOGRAMO
  '35 PICOGRAMO
  '36 MUIACTANT
  '37 UIACTIG
  '41 MILIGRAMO
  '47 MILILITRO
  '48 CURIE
  '49 MILICURIE
  '50 MICROCURIE
  '51 U. INTER. ACT. HOR.
  '52 MEGA U. INTER. ACT. HOR.
  '53 KILOGRAMO BASE
  '54 GRUESA
  '55 MUIACTIG
  '61 KG. BRUTO
  '62 PACK
  '63 HORMA
  '98 OTRAS UNIDADES
  '99 BONIFICACION
End Function

Public Function AFIPGetCAI(ByRef Fields As ADODB.Fields, ByRef rtn As String, ByRef StrError As String) As Boolean
  Dim cuit      As String
  Dim FechaComp As Date
  Dim FechaStr  As String
  Dim Nombre    As String
  Dim GetCai    As Boolean
  Dim Suc       As String
  
  Dim rtn1      As String
  Dim rtn2      As String
  
  If UCase(Trim(ValField(Fields, "LETRID"))) = "C" Then
    rtn = ""
    AFIPGetCAI = True
  End If
  
  If IsNull(Fields("NRCUIT")) Then
    cuit = ValField(Fields, "CNTNRCUIT")
    Nombre = ValField(Fields, "CNTNOMBRE")
  Else
    cuit = ValField(Fields, "NRCUIT")
    Nombre = ValField(Fields, "NOMBRE")
  End If
  
  Suc = ValField(Fields, "SUCURS")
  
  If cuit = "" Then
    StrError = "El cuit del proveedor " & Nombre & " esta vacio y no es posible obtener su CAI. Debe cargar el CUIT y volver a iniciar el proceso."
    Exit Function
  End If

  Dim sqlstmt As String
  sqlstmt = "select proveedor.prov_id, provc_id, provc_numero, provc_fechavto, prov_imprimeticket,provc_sucursal " & vbCrLf
  sqlstmt = sqlstmt & " from ProveedorCAI, Proveedor " & vbCrLf
  sqlstmt = sqlstmt & " where ProveedorCAI.prov_id = Proveedor.prov_id " & vbCrLf
  sqlstmt = sqlstmt & " and prov_cuit = '" & cuit & "'" & vbCrLf
  sqlstmt = sqlstmt & " order by provc_fechavto"
  
  Dim rs As ADODB.Recordset
  
  If Not gDB.OpenRs(sqlstmt, rs) Then
    StrError = "Error: no fue posible cargar el recordset con los CAIs" & LastErrorInfo
    Exit Function
  End If
  
  If rs.BOF And rs.EOF Then
    AFIPGetCAI = True
    rtn = ""
    Exit Function
  End If
  
  ' Si es un ticket fiscal no tiene CAI
  If Val(gDB.ValField(rs.Fields, cscProvImprimeTicket)) <> 0 Then
    AFIPGetCAI = True
    rtn = ""
    Exit Function
  End If
  
  
  FechaStr = ValField(Fields, "FCHMOV")
  FechaComp = DateSerial(Mid(FechaStr, 1, 4), Mid(FechaStr, 5, 2), Mid(FechaStr, 6, 2))
  
  Dim bFound As Boolean
  
  If Not rs.EOF Then
    While Not rs.EOF
      If ValField(rs.Fields, "provc_fechavto") >= FechaComp Then
        ' Busco uno que ademas tenga la sucursal igual a la del comprobante
        If UCase(ValField(rs.Fields, "provc_sucursal")) = UCase(Suc) Then
          rtn1 = ValField(rs.Fields, "provc_numero")
        End If
        rtn2 = ValField(rs.Fields, "provc_numero")
        bFound = True
      End If
      rs.MoveNext
    Wend
  End If
  
  If bFound Then
    ' Encontre el CAI joya me voy con exito
    If rtn1 <> "" Then
      rtn = rtn1
    Else
      rtn = rtn2
    End If
    AFIPGetCAI = True
    Exit Function
  End If
  
  If Ask("El CAI para el proveedor " & Nombre & " no esta definido.;;¿Desea ingresarlo?", vbYes, "CAI") Then
    GetCai = True
  Else
    If Ask("¿Confirma que no indicara el CAI?", vbYes) Then
      AFIPGetCAI = True
      rtn = ""
      Exit Function
    Else
      GetCai = True
    End If
  End If
  
  If GetCai Then
    Do
      If Not GetInput(rtn, "Ingrese el CAI para el proveedor " & Nombre & " Comprobante Nro " & ValField(Fields, "CODMOV") & "-" & ValField(Fields, "NROFOR")) Then
        If Ask("¿Confirma que no indicara el CAI?", vbYes) Then
          AFIPGetCAI = True
          rtn = ""
          Exit Function
        Else
          GetCai = True
        End If
      Else
              
        sqlstmt = "select prov_id" & vbCrLf
        sqlstmt = sqlstmt & " from Proveedor " & vbCrLf
        sqlstmt = sqlstmt & " where prov_cuit = '" & cuit & "'" & vbCrLf

        If Not gDB.OpenRs(sqlstmt, rs) Then
          StrError = "Error: no fue posible cargar el recordset con los CAIs" & LastErrorInfo
          Exit Function
        End If
              
#If PREPROC_1361 Then
        pSaveCAI rtn, ValField(rs.Fields, "prov_id"), FechaComp
#End If
        ' El usuario ingreso el CAI joya salimos con exito
        AFIPGetCAI = True
        Exit Function
      End If
    Loop
  End If
  ' Si llegue hasta aca es por que todo mal
  StrError = "Error: No se pudo encontrar el CAI para el proveedor " & Nombre & " Comprobante Nro " & ValField(Fields, "CODMOV") & "-" & ValField(Fields, "NROFOR") & ". El Usuario decidio cancelar el proceso."
  
End Function

#If PREPROC_1361 Then

Private Function pSaveCAI(ByVal Numero As String, ByVal prov_id As Long, ByVal fechafac As Date) As Boolean
  Dim vto As String
  
  Do
    If Not GetInput(vto, "Ingrese la fecha de vencimiento del CAI") Then
      
      If Ask("Si no indica el CAI se cancelara el proceso. ¿Esta seguro de cancelarlo?", vbNo) Then
        Exit Function
      End If
    Else
      If IsDate(vto) Then
        If DateValue(vto) >= fechafac Then Exit Do
      End If
      MsgWarning "La fecha no es valida (" & vto & "), ingresela nuevamente.", "CAIS"
    End If
  Loop
  
  Dim iProvABM  As cIABMClient
  Dim Proveedor As Object
  
  Set Proveedor = CSKernelClient2.CreateObject("CSGeneral2.cProveedor")
  
  If Proveedor.Load(prov_id) Then
    Dim Properties As cIABMProperties
    Set Properties = New CSABMInterface2.cABMProperties
    
    With Properties.Add(Nothing, cscProvcId)
      .Key = KI_PROVC_ID
      .Value = csNO_ID
    End With
    With Properties.Add(Nothing, cscProvcNumero)
      .Key = KI_NUMERO
      .Value = Numero
    End With
    With Properties.Add(Nothing, cscProvcDescrip)
      .Key = KI_DESCRIP
      .Value = ""
    End With
    With Properties.Add(Nothing, cscProvcFechavto)
      .Key = KI_FECHAVTO
      .Value = vto
    End With
    With Properties.Add(Nothing, cscActivo)
      .Key = KI_ACTIVO
      .Value = -1
    End With
    
    pSaveCAI = Proveedor.UpdateCAI(Properties)
  End If
End Function

#End If

Public Function AFIPGetTipoComprobante(ByVal CODORI As String, ByVal CODMOV As String, ByVal Compras As Boolean) As String
  Dim Fields As ADODB.Fields
  
  If Compras Then
    If Not pGetTipoFormularioCpra(CODORI, Fields) Then
      Err.Raise vbObjectError + 1520, "CSAFIPRes1361/3419", "El codigo de formulario origen (CODORI) [" & CODORI & "] no existe en la tabla PVCB00"
    End If
  Else
    If Not pGetTipoFormularioVta(CODORI, Fields) Then
      Err.Raise vbObjectError + 1520, "CSAFIPRes1361/3419", "El codigo de formulario origen (CODORI) [" & CODORI & "] no existe en la tabla VTCB00"
    End If
  End If
  
  If ValField(Fields, "CODF01") = CODMOV Then
    AFIPGetTipoComprobante = ValField(Fields, "DGIC01")
  ElseIf ValField(Fields, "CODF02") = CODMOV Then
    AFIPGetTipoComprobante = ValField(Fields, "DGIC02")
  ElseIf ValField(Fields, "CODF03") = CODMOV Then
    AFIPGetTipoComprobante = ValField(Fields, "DGIC03")
  ElseIf ValField(Fields, "CODF04") = CODMOV Then
    AFIPGetTipoComprobante = ValField(Fields, "DGIC04")
  ElseIf ValField(Fields, "CODF05") = CODMOV Then
    AFIPGetTipoComprobante = ValField(Fields, "DGIC05")
  ElseIf ValField(Fields, "CODF06") = CODMOV Then
    AFIPGetTipoComprobante = ValField(Fields, "DGIC06")
  ElseIf ValField(Fields, "CODF07") = CODMOV Then
    AFIPGetTipoComprobante = ValField(Fields, "DGIC07")
  ElseIf ValField(Fields, "CODF08") = CODMOV Then
    AFIPGetTipoComprobante = ValField(Fields, "DGIC08")
  ElseIf ValField(Fields, "CODF09") = CODMOV Then
    AFIPGetTipoComprobante = ValField(Fields, "DGIC09")
  ElseIf ValField(Fields, "CODF10") = CODMOV Then
    AFIPGetTipoComprobante = ValField(Fields, "DGIC10")
  Else
    Err.Raise vbObjectError + 1521, "CSAFIPRes1361/3419", "El codigo de formulario (CODMOV) [" & CODMOV & "] no esta definido para el tipo de formulario [" & CODORI & "]"
  End If
  
  
  '1) Tabla de comprobantes
  'Código Descripción
  '01 Facturas A
  '02 Notas de Débito A
  '03 Notas de Crédito A
  '04 Recibos A
  '05 Notas de Venta al contado A
  '06 Facturas B
  '07 Notas de Débito B
  '08 Notas de Crédito B
  '09 Recibos B
  '10 Notas de Venta al contado B
  '11 Facturas C
  '12 Notas de Débito C
  '13 Notas de Crédito C
  '14 Documento aduanero
  '15 Recibos C
  '16 Notas de Venta al contado C
  '19 Facturas de Exportación
  '20 Notas de Débito por operaciones con el exterior
  '21 Notas de Crédito por operaciones con el exterior
  '22 Facturas - Permiso Exportación simplificado D. 855/1997
  '30 Comprobantes de compra de bienes usados
  '34 Comprobantes A del Anexo I, Apartado A, inc. f), RG 1415
  '35 Comprobantes B del Anexo I, Apartado A, inc. f), RG 1415
  '36 Comprobantes C del Anexo I, Apartado A, inc. f), RG 1415
  '37 Notas de Débito o documento equivalente que cumplan con la RG 1415
  '38 Notas de Crédito o documento equivalente que cumplan con la RG 1415
  '39 Otros comprobantes A que cumplan con la RG 1415
  '40 Otros comprobantes B que cumplan con la RG 1415
  '41 Otros comprobantes C que cumplan con la RG 1415
  '60 Cuenta de Venta y Líquido producto A
  '61 Cuenta de Venta y Líquido producto B
  '62 Cuenta de Venta y Líquido producto C
  '63 Liquidación A
  '64 Liquidación B
  '65 Liquidación C
  '80 Comprobante diario de cierre (zeta)
  '81 Tique-Factura 'A'
  '82 Tique-Factura 'B'
  '83 Tique
  '84 Comprobante/Factura de servicios públicos
  '85 Nota de Crédito - servicios públicos
  '86 Nota de Débito - servicios públicos
  '87 Otros comprobantes - servicios del exterior
  '92 Ajustes contables que incrementan el débito fiscal
  '93 Ajustes contables que disminuyen el débito fiscal
  '94 Ajustes contables que incrementan el crédito fiscal
  '95 Ajustes contables que disminuyen el crédito fiscal
End Function

Public Sub SetDatosClienteContado(ByRef Fields As ADODB.Fields, ByRef Campos As cIAFIPCampos)
  If Fields Is Nothing Then Exit Sub
  
  If IsNull(Fields("NOMBRE")) Then
    Campos.Item(6).Valor = ValField(Fields, "CNTNOMBRE")
  End If
  
  If IsNull(Fields("NRCUIT")) Then
    Campos.Item(8).Valor = ValField(Fields, "CNTNRCUIT")
  End If
  
End Sub

Public Sub SetDatosProveedorContado(ByRef Fields As ADODB.Fields, ByRef Campos As cIAFIPCampos)
  If Fields Is Nothing Then Exit Sub
  
  If IsNull(Fields("NOMBRE")) Then
    Campos.Item(6).Valor = ValField(Fields, "CNTNOMBRE")
  End If
  
  If IsNull(Fields("NRCUIT")) Then
    Campos.Item(8).Valor = ValField(Fields, "CNTNRCUIT")
  End If
  
End Sub

Public Function CreateVTCL(ByRef Parametros As cIAFIPParametros) As Boolean
  On Error GoTo ControlError
  
  Dim db  As Connection
  Dim gDB As cDataBase
  Dim rs  As Recordset
  Dim sqlstmt As String
  
  Set db = New Connection
  db.CursorLocation = adUseClient
  db.Open "PROVIDER=MSDASQL;dsn=VT;uid=;pwd=;"

  Set rs = New Recordset
  rs.Open "select NROCTA, NOMBRE, TIPDOC, CNDIVA, NRCUIT from VTCL00", db, adOpenStatic, adLockOptimistic
  
  Set gDB = GetgDB(Parametros, "VT")
  
  sqlstmt = "delete * from VTCL00"
  If Not gDB.Execute(sqlstmt, "", C_Module) Then Exit Function
  
  While Not rs.EOF
    sqlstmt = "insert into VTCL00 (NROCTA, NOMBRE, TIPDOC, CNDIVA, NRCUIT) "
    sqlstmt = sqlstmt & "VALUES ('" & ValField(rs.Fields, "NROCTA") & "','" & Replace(ValField(rs.Fields, "NOMBRE"), "'", "''") & "'," & ValField(rs.Fields, "TIPDOC") & ",'" & ValField(rs.Fields, "CNDIVA") & "','" & ValField(rs.Fields, "NRCUIT") & "')"
    If Not gDB.Execute(sqlstmt, "", C_Module) Then Exit Function
    rs.MoveNext
  Wend
  CreateVTCL = True
  Exit Function
ControlError:
End Function

Public Function CreatePVCL(ByRef Parametros As cIAFIPParametros) As Boolean
  On Error GoTo ControlError
  
  Dim db  As Connection
  Dim gDB As cDataBase
  Dim rs  As Recordset
  Dim sqlstmt As String
  
  Set db = New Connection
  db.CursorLocation = adUseClient
  db.Open "PROVIDER=MSDASQL;dsn=PV;uid=;pwd=;"

  Set rs = New Recordset
  rs.Open "select NROCTA, NOMBRE, TIPDOC, CNDIVA, NRCUIT from PVCL00", db, adOpenStatic, adLockOptimistic
  
  Set gDB = GetgDB(Parametros, "PV")
  
  sqlstmt = "delete * from PVCL00"
  If Not gDB.Execute(sqlstmt, "", C_Module) Then Exit Function
  
  While Not rs.EOF
    sqlstmt = "insert into PVCL00 (NROCTA, NOMBRE, TIPDOC, CNDIVA, NRCUIT) "
    sqlstmt = sqlstmt & "VALUES ('" & ValField(rs.Fields, "NROCTA") & "','" & Replace(ValField(rs.Fields, "NOMBRE"), "'", "''") & "'," & ValField(rs.Fields, "TIPDOC") & ",'" & ValField(rs.Fields, "CNDIVA") & "','" & ValField(rs.Fields, "NRCUIT") & "')"
    If Not gDB.Execute(sqlstmt, "", C_Module) Then Exit Function
    rs.MoveNext
  Wend
  CreatePVCL = True
  Exit Function
ControlError:
End Function

' funciones friend
' funciones privadas
Private Function pGetTipoFormularioVta(ByVal CODORI As String, ByRef Fields As ADODB.Fields) As Boolean

  rsTipoFormulariosVta.Filter = "CODIGO = '" & CODORI & "'"
  
  If rsTipoFormulariosVta.EOF Then Exit Function
  
  Set Fields = rsTipoFormulariosVta.Fields
  
  pGetTipoFormularioVta = True
End Function

Private Function pGetTipoFormularioCpra(ByVal CODORI As String, ByRef Fields As ADODB.Fields) As Boolean

  rsTipoFormulariosCpra.Filter = "CODIGO = '" & CODORI & "'"
  
  If rsTipoFormulariosCpra.EOF Then Exit Function
  
  Set Fields = rsTipoFormulariosCpra.Fields
  
  pGetTipoFormularioCpra = True
End Function

Private Function pGetMoneda(ByVal CODIGO_MONEDA As String, ByRef Fields As ADODB.Fields) As Boolean

  If CODIGO_MONEDA = "" Then CODIGO_MONEDA = "PES"
  If CODIGO_MONEDA = "DO" Then CODIGO_MONEDA = "DOL"

  rsMonedas.Filter = "mon_codigo = '" & CODIGO_MONEDA & "'"
  
  If rsMonedas.EOF Then Exit Function
  
  Set Fields = rsMonedas.Fields
  
  pGetMoneda = True
End Function

Private Function pGetIVA(ByVal TasaIva As Double, ByRef Fields As ADODB.Fields) As Boolean

  rsIVA.Filter = "ti_codigo = '" & Trim(TasaIva) & "'"
  
  If rsIVA.EOF Then Exit Function
  
  Set Fields = rsIVA.Fields
  
  pGetIVA = True
End Function

Private Function pGetConceptoVta(ByVal CODCPT As String, ByRef Fields As ADODB.Fields) As Boolean

  rsConceptosVtas.Filter = "CODCPT = '" & CODCPT & "'"
  
  If rsConceptosVtas.EOF Then Exit Function
  
  Set Fields = rsConceptosVtas.Fields
  
  pGetConceptoVta = True
End Function

Private Function pGetConceptoCpra(ByVal CODCPT As String, ByRef Fields As ADODB.Fields) As Boolean

  rsConceptosCpra.Filter = "CODCPT = '" & CODCPT & "'"
  
  If rsConceptosCpra.EOF Then Exit Function
  
  Set Fields = rsConceptosCpra.Fields
  
  pGetConceptoCpra = True
End Function

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



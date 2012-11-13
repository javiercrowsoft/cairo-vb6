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
' estructuras
' variables privadas
Private m_db As cDataBase
' eventos
' propiedades publicas
Public rsConceptosVtas     As ADODB.Recordset
Public rsTipoFormularios   As ADODB.Recordset
' propiedades friend
' propiedades privadas
' funciones publicas
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

Public Function AFIPGetCondicionIva(ByVal TipoStrad As Integer) As Integer
  Select Case TipoStrad
    Case 1
      AFIPGetCondicionIva = 1
    Case 2
      AFIPGetCondicionIva = 1
    Case 3
      AFIPGetCondicionIva = 5
    Case 4
      AFIPGetCondicionIva = 4
    Case 5
      AFIPGetCondicionIva = 2
    Case 6
      AFIPGetCondicionIva = 9
    Case 7
      AFIPGetCondicionIva = 6
    Case Else
      Err.Raise c_ErrorCondicionIvaStrad, "CSAFIPRes1361", "La condicion de iva strad: " & TipoStrad & " no esta contemplada"
  End Select
End Function

Public Function AFIPGetTipoDoc(ByVal TipoStrad As Integer) As Integer
  Select Case TipoStrad
    Case 72, 80, 90, 95
      AFIPGetTipoDoc = 80 ' CUIT
    Case Else
      Err.Raise c_ErrorCodigoDocStrad, "CSAFIPRes1361", "El codigo de documento strad: " & TipoStrad & " no esta contemplado"
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
      .Id = Campo.Id
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
    Case Else
      Err.Raise vbObjectError + 1005, "CSAFIPRes1361", "La unidad [" & Unidad & "] no esta definida"
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

Public Function AFIPGetTipoComprobante(ByVal CODORI As String, ByVal CODMOV As String) As String
  Dim Fields As ADODB.Fields
  
  If Not pGetTipoFormulario(CODORI, Fields) Then
    Err.Raise vbObjectError + 1520, "CSAFIPRes1361", "El codigo de formulario origen (CODORI) [" & CODORI & "] no existe en la tabla VTCO00"
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
    Err.Raise vbObjectError + 1521, "CSAFIPRes1361", "El codigo de formulario (CODMOV) [" & CODMOV & "] no esta definido para el tipo de formulario [" & CODORI & "]"
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

' funciones friend
' funciones privadas
Private Function pGetTipoFormulario(ByVal CODORI As String, ByRef Fields As ADODB.Fields) As Boolean

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



VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cProcesoVentas1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements cIAFIPProceso
'--------------------------------------------------------------------------------
' cProcesoVentas1
' 16-07-2003

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cProcesoVentas1"
' estructuras
Private Type T_Ivas
  Total_11          As Double
  TotalNoGravado_12 As Double
  NetoGravado_13    As Double
  TasaIva_14        As Double
  TotalRI_15        As Double
  TotalRNI_16       As Double
  TotalExento_17    As Double
  TotalPercep_18    As Double
  TotalIngBr_19     As Double
  TotalMunic_20     As Double
  TotalInternos_21  As Double
End Type
' variables privadas
Private m_ObjProc   As cObjetoProceso
Private m_Campos    As cIAFIPCampos
Private m_LastIva   As Integer
Private m_vIvas()   As T_Ivas
' eventos
' propiedades publicas
Private Function cIAFIPProceso_ProcessRecord(Parametros As cIAFIPParametros, Fields As ADODB.Fields, Campos As cIAFIPCampos, ByVal IsLastRecord As Boolean, IsEmptyRecord As Boolean, ByVal lIndexRecord As Long, Esquema As cIAFIPEsquema) As Boolean
  
  If IsLastRecord Then
  
    IsEmptyRecord = Not pSetCampos(Campos, Esquema, Fields)
    
  Else
    
    ' Si m_Campos.Count = 0 estoy en el primer registro
    If m_Campos.Count = 0 Then
      
      ' Agrego el campo ID a la coleccion
      With Campos.Add(Nothing, C_ID)
        .Columna = C_ID
        .Posicion = -1
      End With
    End If
    
    If Not m_ObjProc.ProcessRecord(Parametros, Fields, Campos, IsLastRecord, IsEmptyRecord, lIndexRecord, Esquema) Then
      Esquema.Log C_Module, "Fallo al procesar el registro " & lIndexRecord, LogSevError
      Exit Function
    End If
    
    ' Datos del cliente
    If Not pGetDatosCliente(Parametros, Fields, Campos) Then
      Esquema.Log C_Module, "Fallo al obtener datos del cliente del registro " & lIndexRecord, LogSevError
      Exit Function
    End If
  
    ' Si m_Campos.Count = 0 estoy en el primer registro
    If m_Campos.Count = 0 Then
      
      ' El primero siempre es vacio
      IsEmptyRecord = True
      pSetCampos Campos, Esquema, Fields
      
    Else
      
      ' Si cambio de documento (El id esta siempre al final)
      If m_Campos.Item(m_Campos.Count).Valor <> Campos.Item(Campos.Count).Valor Then
        
        IsEmptyRecord = Not pSetCampos(Campos, Esquema, Fields)
        
      Else
        
        pAddCampos Campos, Fields
      
        IsEmptyRecord = True
      End If
    End If
  End If
  
  cIAFIPProceso_ProcessRecord = True
End Function
' propiedades friend
' propiedades privadas
' funciones publicas
' funciones friend
' funciones privadas
Private Function pSetCampos(ByRef rtnCampos As cIAFIPCampos, ByRef Esquema As cIAFIPEsquema, ByRef Fields As ADODB.Fields) As Boolean
  Dim tmpCampos As cIAFIPCampos
  Dim rtn       As Boolean
  
  ' Si m_Campos no esta vacia es por que
  ' hay datos
  rtn = m_Campos.Count > 0

  ' Inicializo el flag de tasas iva
  m_LastIva = -1

  Set tmpCampos = CSKernelClient2.CreateObject("CSInfoAFIP.cAFIPCampos")
  
  ' Paso de rtnCampos a TmpCampos
  CopyCampos rtnCampos, tmpCampos
  
  ' Si hay campos en m_Campos los paso a rtnCampos
  If rtn Then
    
    pCampo26
    
    ' Paso de m_Campos a rtnCampos
    CopyCampos m_Campos, rtnCampos
  End If
  
  ' Renglones de iva
  pGetLinesIva Esquema
  
  ' Ahora paso de TmpCampos (originalmente rtnCampos) a m_Campos
  CopyCampos tmpCampos, m_Campos
  
  ' Realizo las verificaciones a este registro como a cualquier otro
  pSetDefaults
  SetDatosClienteContado Fields, m_Campos
  pAddCampos m_Campos, Fields
  
  pSetCampos = rtn
End Function

Private Sub pCampo26()
  ' Campo 26: Código de operación
  ' Si la alícuota de IVA (campo 14) es igual a cero (0), se deberá completar
  ' de acuerdo con la siguiente codificación:
  If IsNumeric(m_Campos(14).Valor) Then
    If CDbl(m_Campos(14).Valor) = 0 Then
      ' Z-Exportaciones a la zona franca.
      ' X-Exportaciones al exterior.
      ' E-Operaciones exentas.
      ' N-No gravado.
      m_Campos.Item(26).Valor = "E"
    Else
      m_Campos.Item(26).Valor = ""
    End If
  End If
End Sub

Private Function pGetLinesIva(ByRef Esquema As cIAFIPEsquema) As Boolean
  ' Campo 14: Alícuota de IVA
  ' Se deberá completar con la alícuota de IVA correspondiente,
  ' conforme la tabla indicada en el Anexo II, apartado E), punto 6).
  ' En los casos en que se deba informar más de una alícuota para el
  ' mismo comprobante, se procederá a grabar tantos registros de tipo "1"
  ' como alícuotas se deban declarar.
  ' Los campos 1 a 10 y 22 a 30 se grabarán con la misma información en
  ' todos los registros de tipo "1", los restantes campos se completarán con
  ' los datos que correspondan a cada alícuota de impuesto.
  ' La alícuota podrá ser cero en caso de operaciones de exportación,
  ' exentas y no gravadas, procediéndose a completar el código de operación
  ' (campo 26) respectivo, o en el supuesto de tratarse de un comprobante
  ' anulado.
  
  ' Si no hay mas de una no hay que hacer nada
  If Not UBound(m_vIvas) > 1 Then
    pGetLinesIva = True
    Exit Function
  End If

  Dim i As Integer
  
  Dim rtnCampos As cIAFIPCampos
  Set rtnCampos = CSKernelClient2.CreateObject("CSInfoAFIP.cAFIPCampos")
  
  CopyCampos m_Campos, rtnCampos
  
  ' Voy hasta UBound(m_vIvas) - 1 por que la ultima
  ' tasa de iva la devuelve pSetCampos
  For i = 1 To UBound(m_vIvas) - 1
    With m_vIvas(i)
      rtnCampos.Item(11).Valor = .Total_11
      rtnCampos.Item(12).Valor = .TotalNoGravado_12
      rtnCampos.Item(13).Valor = .NetoGravado_13
      rtnCampos.Item(14).Valor = AFIPGetCodigoIVA1361(.TasaIva_14)
      rtnCampos.Item(15).Valor = .TotalRI_15
      rtnCampos.Item(16).Valor = .TotalRNI_16
      rtnCampos.Item(17).Valor = .TotalExento_17
      rtnCampos.Item(18).Valor = .TotalPercep_18
      rtnCampos.Item(19).Valor = .TotalIngBr_19
      rtnCampos.Item(20).Valor = .TotalMunic_20
      rtnCampos.Item(21).Valor = .TotalInternos_21
    End With
    
    If Not Esquema.AddLine(rtnCampos) Then Exit Function
  Next
  
  ReDim m_vIvas(0)
  
  pGetLinesIva = True
End Function

Private Sub pSetDefaults()
  ' Tipo de campo
  m_Campos.Item(1).Valor = 1
  
  ' CUIT sin guiones
  With m_Campos.Item(9)
    .Valor = Replace(.Valor, "-", "")
  End With
  
  ' Importe total de la operacion
  m_Campos.Item(11).Valor = 0
  
  ' Campo 12: Importe total de conceptos que no integran el precio neto gravado
  m_Campos.Item(12).Valor = 0

  ' Campo 13: Importe neto gravado
  m_Campos.Item(13).Valor = 0
  
  ' Impuesto liquidado
  m_Campos.Item(15).Valor = 0

  ' Impuesto liquidado a RNI o percepcion a no categorizados
  m_Campos.Item(16).Valor = 0
  
  ' Importe de operaciones exentas
  m_Campos.Item(17).Valor = 0
  
  ' Importe de percepciones o pagos a cuenta sobre impuestos nacionales
  m_Campos.Item(18).Valor = 0
  
  ' Importe de percepciones de ingresos brutos
  m_Campos.Item(19).Valor = 0
  
  ' Importe de percepcion por impuestos municipales
  m_Campos.Item(20).Valor = 0
  
  ' Importe de impuestos internos
  m_Campos.Item(21).Valor = 0
          
  ' Cantidad alicuotas de IVA
  m_Campos.Item(25).Valor = 0
  
  ' Información adicional
  m_Campos.Item(30).Valor = ""
End Sub

Private Sub pAddCampos(ByRef Campos As cIAFIPCampos, ByRef Fields As ADODB.Fields)
  Dim Index As Integer
  ' Solo pongo los valores que me interesan
  ' En SetCampos se guardan los valores comunes
  ' a todos los registros
  
  If Not Fields Is Nothing Then
  
    Dim cpt As String
    Dim Iva As Integer
    Dim c As String
    
    If m_Campos.Item(3).Valor = "" Then
      ' Lo hacemos una vez por comprobante
      ' Tipo de comprobante
      m_Campos.Item(3).Valor = AFIPGetTipoComprobante(ValField(Fields, "CODORI"), ValField(Fields, "CODMOV"), False)
    End If
    
    cpt = Left(ValField(Fields, ("CODCPT")), 3)
    c = Left$(cpt, 1)
    
    ' OJO NO LO CAMBIEN DE LUGAR POR QUE AFECTA LA LOGICA DE LOS CAMPOS
    ' QUE ESTAN DEBAJO.
    
    ' Este es el primer campo a evaluar por que determina
    ' en que tasa de iva estamos y redimenciona el vector correspondiente
    
    ' En ventas hay que poner un registro por cada tasa de IVA
    ' Campo 14: Alícuota de IVA
    ' Se deberá completar con la alícuota de IVA correspondiente,
    ' conforme la tabla indicada en el Anexo II, apartado E), punto 6).
    ' En los casos en que se deba informar más de una alícuota para el
    ' mismo comprobante, se procederá a grabar tantos registros de tipo "1"
    ' como alícuotas se deban declarar.
    ' Los campos 1 a 10 y 22 a 30 se grabarán con la misma información en
    ' todos los registros de tipo "1", los restantes campos se completarán con
    ' los datos que correspondan a cada alícuota de impuesto.
    ' La alícuota podrá ser cero en caso de operaciones de exportación,
    ' exentas y no gravadas, procediéndose a completar el código de operación
    ' (campo 26) respectivo, o en el supuesto de tratarse de un comprobante
    ' anulado.
    
    Index = UBound(m_vIvas)
    
    Iva = ValField(Fields, "TASAII")
    If m_LastIva <> Iva Then
      
      If m_LastIva <> 0 Then
        
        Index = Index + 1
        ReDim Preserve m_vIvas(Index)
        
        m_vIvas(Index).TasaIva_14 = Iva
        m_LastIva = Iva
      End If
    End If
    
    ' Importe total de la operacion
    ' IMPORT del archivo iv del registro de totales
    ' (codcpt: A= item, I=Impueto, T=Total)
    If c = "T" Then
      m_Campos.Item(11).Valor = ValField(Fields, "IMPORT")
    
      ' Campo 17: Importe de operaciones exentas
      If AFIPEsOperacionExenta(Fields) Then
        m_Campos.Item(17).Valor = ValField(Fields, "IMPORT")
      End If
  
    ' Impuesto liquidado a RI y RNI
    ElseIf Left(cpt, 1) = "I" Then
      m_vIvas(Index).Total_11 = m_vIvas(Index).Total_11 + CDbl(ValField(Fields, "IMPORT"))
  
    ' Impuesto liquidado
    ' IMPORT Conceptos de tipo I01
    ElseIf cpt = "I01" Or cpt = "A27" Then
      m_Campos.Item(15).Valor = ValField(Fields, "IMPORT")
      m_vIvas(Index).TotalRI_15 = m_vIvas(Index).TotalRI_15 + CDbl(ValField(Fields, "IMPORT"))
  
    ' Impuesto liquidado a RNI o percepcion a no categorizados
    ' IMPORT Conceptos de tipo I02
    ElseIf cpt = "I02" Then
      m_Campos.Item(16).Valor = ValField(Fields, "IMPORT")
      m_vIvas(Index).TotalRNI_16 = m_vIvas(Index).TotalRNI_16 + CDbl(ValField(Fields, "IMPORT"))
  
    ' Importe de percepciones de ingresos brutos
    ' IMPORT Conceptos de tipo J01 y J02
    ElseIf cpt = "J01" Or cpt = "J02" Then
      m_Campos.Item(19).Valor = ValField(Fields, "IMPORT")
      m_vIvas(Index).TotalIngBr_19 = m_vIvas(Index).TotalIngBr_19 + CDbl(ValField(Fields, "IMPORT"))
    
    ' Si no es de tipo A o D no es un concepto exento.
    ElseIf c = "A" Or c = "D" Then
      ' Campo 12: Importe total de conceptos que no integran el precio neto gravado
      ' Se consignará el importe que surja de sumar los montos que no integren la
      ' base imponible. Dicho importe podrá ser cero.
      If AFIPGetEsConceptoExento(cpt, False) Then
        With m_Campos.Item(12)
          .Valor = CDbl(.Valor) + CDbl(ValField(Fields, "IMPORT"))
        End With
      Else
      ' Campo 13: Importe neto gravado
      ' El mismo deberá ser menor o igual al importe total de la operación y
      ' mayor o igual al impuesto liquidado. Podrá ser cero si la operación no
      ' se encuentra gravada por IVA en su totalidad (campo 14 = 0).
        With m_Campos.Item(13)
          .Valor = CDbl(.Valor) + CDbl(ValField(Fields, "IMPORT"))
        End With
      End If
    End If
  
    ' Campo 25: Cantidad de alícuotas de IVA
    ' Si se trata de varias alícuotas a informar, en el presente campo se
    ' deberá indicar la cantidad total de ellas, consignándose en los campos 13,
    ' 14, 15 y 16 la parte correspondiente a cada tasa. En caso contrario se
    ' consignará "1", como también si se trata de una operación de venta de
    ' productos exentos con productos gravados a tasa única.
    ' OK TASAII el count de los distntos
    Iva = ValField(Fields, "TASAII")
    If m_LastIva <> Iva Then
      m_LastIva = Iva
      If m_LastIva <> 0 Then
        m_Campos.Item(25).Valor = Val(m_Campos.Item(25).Valor) + 1
      End If
    End If
  End If
End Sub

Private Function pGetDatosCliente(Parametros As cIAFIPParametros, Fields As ADODB.Fields, Campos As cIAFIPCampos) As Boolean
  Dim TipoStradDoc As Integer
  Dim TipoStradIva As Integer
  
  If IsNull(Fields("TIPDOC")) Then
    TipoStradDoc = Val(ValField(Fields, "CNTTIPDOC"))
  Else
    TipoStradDoc = Val(ValField(Fields, "TIPDOC"))
  End If
  
  If IsNull(Fields("CNDIVA")) Then
    TipoStradIva = Val(ValField(Fields, "CNTCNDIVA"))
  Else
    TipoStradIva = Val(ValField(Fields, "CNDIVA"))
  End If
  
  Campos.Item(8).Valor = AFIPGetTipoDoc(TipoStradDoc)
  Campos.Item(22).Valor = AFIPGetCondicionIva(TipoStradIva)
  
  Campos.Item(23).Valor = AFIPGetCodigoMoneda1361(ValField(Fields, "COFDEU"))

  pGetDatosCliente = True
End Function
' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  Set m_ObjProc = New cObjetoProceso
  ReDim m_vIvas(0)
  Set m_Campos = CSKernelClient2.CreateObject("CSInfoAFIP.cAFIPCampos")
  
  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
  On Error GoTo ControlError

  Set m_ObjProc = Nothing
  Set m_Campos = Nothing
  ReDim m_vIvas(0)
  
  GoTo ExitProc
ControlError:
  MngError Err, "Class_Terminate", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

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






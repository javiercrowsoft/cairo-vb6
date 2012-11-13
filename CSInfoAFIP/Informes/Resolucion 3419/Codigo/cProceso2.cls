VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cProceso2"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements cIAFIPProceso
'--------------------------------------------------------------------------------
' cProceso2
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
Private Const C_Module = "cProceso2"
' estructuras
' variables privadas
Private m_ObjProc   As cObjetoProceso
Private m_Campos    As cIAFIPCampos
' eventos
' propiedades publicas
Private Function cIAFIPProceso_ProcessRecord(Parametros As cIAFIPParametros, Fields As ADODB.Fields, Campos As cIAFIPCampos, ByVal IsLastRecord As Boolean, IsEmptyRecord As Boolean, ByVal lIndexRecord As Long, Esquema As cIAFIPEsquema) As Boolean
  Dim IVA As Double
  
  If IsLastRecord Then
  
    IsEmptyRecord = Not pSetCampos(Campos, Nothing)
    
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
    
    ' Nro comprobante tiene que incluir la sucursal
    With Campos.Item(4)
      .Valor = ValField(Fields, "SUCURS") & .Valor
    End With
    
    ' Pongo el iva del concepto que tenga iva <> 0
    IVA = CDbl(ValField(Fields, "TASAII"))
    If IVA <> 0 Then
      m_Campos.Item(12).Valor = IVA
      m_Campos.Item(20).Valor = AFIPGetCodigoIVA(IVA)
    End If
    
    ' Si m_Campos.Count = 0 estoy en el primer registro
    If m_Campos.Count = 0 Then
      
      ' El primero siempre es vacio
      IsEmptyRecord = True
      pSetCampos Campos, Fields
      
    Else
      
      ' Si cambio de documento (El id esta siempre al final)
      If m_Campos.Item(m_Campos.Count).Valor <> Campos.Item(Campos.Count).Valor Then
        
        IsEmptyRecord = Not pSetCampos(Campos, Fields)
        
      Else
      
        pAddCampos Fields
      
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
Private Function pSetCampos(ByRef rtnCampos As cIAFIPCampos, ByRef Fields As ADODB.Fields) As Boolean
  Dim tmpCampos As cIAFIPCampos
  Dim rtn       As Boolean
  
  ' Si m_Campos no esta vacia es por que
  ' hay datos
  rtn = m_Campos.Count > 0

  Set tmpCampos = CSKernelClient2.CreateObject("CSInfoAFIP.cAFIPCampos")
  
  ' Paso de rtnCampos a TmpCampos
  CopyCampos rtnCampos, tmpCampos
  
  ' Si hay campos en m_Campos los paso a rtnCampos
  If rtn Then
    ' Paso de m_Campos a rtnCampos
    CopyCampos m_Campos, rtnCampos
  End If
  
  ' Ahora paso de TmpCampos (originalmente rtnCampos) a m_Campos
  CopyCampos tmpCampos, m_Campos
  
  ' Realizo las verificaciones a este registro como a cualquier otro
  pSetDefaults
  SetDatosClienteContado Fields, m_Campos
  pAddCampos Fields
  
  pSetCampos = rtn
End Function

Private Sub pSetDefaults()
  ' Tipo de campo
  m_Campos.Item(1).Valor = 2
  
  ' Cantidad de hojas
  m_Campos.Item(5).Valor = 1
  
  ' CUIT Tiene que ir sin guiones
  With m_Campos.Item(8)
    .Valor = Replace(.Valor, "-", "")
  End With
  
  ' Importe de la operacion
  m_Campos.Item(9).Valor = 0
  
  ' Importe de conceptos que no integran el neto gravado
  m_Campos.Item(10).Valor = 0
  
  ' Importe gravado
  m_Campos.Item(11).Valor = 0
  
  ' Alicuota IVA
  m_Campos.Item(12).Valor = 0
  
  ' Impuesto Liquidado
  m_Campos.Item(13).Valor = 0

  ' Impuesto RNI
  m_Campos.Item(14).Valor = 0

  ' Importe Exento
  m_Campos.Item(15).Valor = 0

  ' Impuesto Liquidado
  m_Campos.Item(13).Valor = 0

  ' Percepciones o Retenciones
  m_Campos.Item(16).Valor = 0
End Sub

Private Sub pAddCampos(ByRef Fields As ADODB.Fields)
  ' Solo pongo los valores que me interesan
  ' En SetCampos se guardan los valores comunes
  ' a todos los registros
  
  If Not Fields Is Nothing Then
  
    Dim cpt As String
    Dim c As String
    
    If m_Campos.Item(3).Valor = "" Then
      ' Lo hacemos una vez por comprobante
      ' Tipo de comprobante
      m_Campos.Item(3).Valor = AFIPGetTipoComprobante(ValField(Fields, "CODORI"), ValField(Fields, "CODMOV"), False)
    End If
    
    cpt = Left$(ValField(Fields, ("CODCPT")), 3)
    c = Left$(cpt, 1)
    
    ' Importe total de la operacion
    ' IMPORT del archivo iv del registro de totales
    ' (codcpt: A= item, I=Impueto, T=Total)
    If c = "T" Then
      m_Campos.Item(9).Valor = ValField(Fields, "IMPORT")
      
      ' Campo 15: Importe de operaciones exentas
      If AFIPEsOperacionExenta(Fields) Then
        m_Campos.Item(15).Valor = ValField(Fields, "IMPORT")
      End If
  
    ' Impuesto liquidado
    ' IMPORT Conceptos de tipo I01 Iva, A27 Devolucion de iva
    ElseIf cpt = "I01" Or cpt = "A27" Then
      m_Campos.Item(13).Valor = ValField(Fields, "IMPORT")
  
    ' Impuesto liquidado a RNI o percepcion a no categorizados
    ' IMPORT Conceptos de tipo I02
    ElseIf cpt = "I02" Then
      m_Campos.Item(14).Valor = ValField(Fields, "IMPORT")
  
    ' Importe de percepciones de ingresos brutos
    ' IMPORT Conceptos de tipo J01 y J02
    ElseIf cpt = "J01" Or cpt = "J02" Then
      With m_Campos.Item(16)
        .Valor = CDbl(.Valor) + CDbl(ValField(Fields, "IMPORT"))
      End With
    
    ' I03 PERCEPCIONES IVA en el subdiario lo ponen en la columna exento
    ' me parece mal, pero mas vale hacer lo mismo que strad.
    ElseIf cpt = "I03" Then
      With m_Campos.Item(15)
        .Valor = CDbl(.Valor) + CDbl(ValField(Fields, "IMPORT"))
      End With
    
    ' Si no es de tipo A o D no es un concepto exento.
    ElseIf c = "A" Or c = "D" Then
      
      If AFIPGetEsConceptoExento(cpt, False) Then
        With m_Campos.Item(10)
          .Valor = CDbl(.Valor) + CDbl(ValField(Fields, "IMPORT"))
        End With
      Else
        With m_Campos.Item(11)
          .Valor = CDbl(.Valor) + CDbl(ValField(Fields, "IMPORT"))
        End With
      End If
    End If
  End If

  ' Si el impuesto liquidado (campo 10) es igual a cero (0) y
  ' el importe total de conceptos que no integran el precio neto
  ' gravado (campo 10) es distinto de cero, se deberá completar de
  ' acuerdo con la siguiente codificación:
  If IsNumeric(m_Campos(10).Valor) And IsNumeric(m_Campos(13).Valor) Then
    If CDbl(m_Campos(10).Valor) <> 0 And CDbl(m_Campos(13).Valor) = 0 Then
      'Z-Exportaciones a la zona franca.
      'X-Exportaciones al exterior.
      'E-Operaciones exentas.
      'N-No gravado
      m_Campos.Item(21).Valor = "E"
    Else
      m_Campos.Item(21).Valor = ""
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


  Campos.Item(7).Valor = AFIPGetTipoDoc(TipoStradDoc)
  Campos.Item(17).Valor = AFIPGetCondicionIva(TipoStradIva)
  
  Campos.Item(18).Valor = AFIPGetCodigoMoneda(ValField(Fields, "COFDEU"))
  
  pGetDatosCliente = True
  
End Function
' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  Set m_ObjProc = New cObjetoProceso
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




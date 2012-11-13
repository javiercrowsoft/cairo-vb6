VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cProcesoCompras2"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements cIAFIPProceso
'--------------------------------------------------------------------------------
' cProcesoCompras2
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
Private Const C_Module = "cProcesoCompras2"
' estructuras
' variables privadas
Private m_ObjProc As cObjetoProceso
Private m_Campos    As cIAFIPCampos
' eventos
' propiedades publicas
Private Function cIAFIPProceso_ProcessRecord(Parametros As cIAFIPParametros, Fields As ADODB.Fields, Campos As cIAFIPCampos, ByVal IsLastRecord As Boolean, IsEmptyRecord As Boolean, ByVal lIndexRecord As Long, Esquema As cIAFIPEsquema) As Boolean
  
  If IsLastRecord Then
  
    ' Campo 4: Cantidad de registros de tipo 1
    m_Campos.Item(4).Valor = Esquema.LineCount
  
    IsEmptyRecord = Not pSetCampos(Campos, Parametros, Fields)
  
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
  
    IsEmptyRecord = True
  
    ' Si m_Campos.Count = 0 estoy en el primer registro
    If m_Campos.Count = 0 Then
      pSetCampos Campos, Parametros, Fields
    Else
      pAddCampos Campos, Fields
    End If
  End If
  
  cIAFIPProceso_ProcessRecord = True
End Function
' propiedades friend
' propiedades privadas
' funciones publicas
' funciones friend
' funciones privadas
Private Function pSetCampos(ByRef rtnCampos As cIAFIPCampos, ByRef Parametros As cIAFIPParametros, ByRef Fields As ADODB.Fields) As Boolean
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
  pSetDefaults Parametros
  pAddCampos m_Campos, Fields
  
  pSetCampos = rtn
End Function

Private Sub pSetDefaults(ByRef Parametros As cIAFIPParametros)
  ' Tipo de campo
  m_Campos.Item(1).Valor = 2
  
  ' Período
  ' Se deberá completar con el período fiscal que se registra (AAAAMM).
  m_Campos.Item(2).Valor = GetDate(C_Param_FechaDesde, Parametros, "YYYYMM")
  
  ' CUIT del informante
  ' Se deberá completar con la CUIT del emisor de los comprobantes.
  m_Campos.Item(6).Valor = "30599012628"
  
  ' Campo 8: Importe total de la operación
  ' Se consignará el importe total de las
  ' operaciones efectuadas durante el período informado. Deberá
  ' ser igual a la sumatoria del campo homónimo de la totalidad de
  ' los registros de tipo 1 (suma del campo 11 del registro de tipo 1).
  m_Campos.Item(8).Valor = 0
  
  ' Campo 9: Importe total de conceptos que no integran el precio
  '          neto gravado
  ' Se procederá a informar la sumatoria de los importes que no integren el
  ' hecho imponible, el cual podrá ser cero (suma del campo 12 del registro
  ' de tipo 1).
  m_Campos.Item(9).Valor = 0
  
  ' Campo 10: Importe neto gravado
  ' Se deberá consignar la sumatoria de los importes netos gravados
  ' correspondientes a las operaciones realizadas durante el período
  ' que se informa (suma del campo 13 del registro de tipo 1).
  m_Campos.Item(10).Valor = 0
  
  ' Campo 12: Impuesto liquidado
  ' Se deberá consignar la sumatoria del total de los importes liquidados de IVA
  ' (suma del campo 19 del registro de tipo 1).
  m_Campos.Item(12).Valor = 0
  
  ' Campo 13: Importe de operaciones exentas
  ' Se deberá consignar la sumatoria total de los importes de operaciones
  ' exentas (suma del campo 20 del registro de tipo 1).
  m_Campos.Item(13).Valor = 0
  
  ' Campo 14: Importe de percepciones o pagos a cuenta del impuesto al valor
  '           agregado
  ' Se deberá consignar la sumatoria del total de las percepciones o pagos a
  ' cuenta (suma del campo 21 del registro de tipo 1).
  m_Campos.Item(14).Valor = 0
  
  ' Campo 15: Importe de percepciones o pagos a cuenta de otros impuestos
  '           nacionales
  ' Se deberá consignar la sumatoria del total de las percepciones o pagos a
  ' cuenta (suma del campo 22 del registro de tipo 1).
  m_Campos.Item(15).Valor = 0
  
  ' Campo 16: Importe de percepciones de ingresos brutos
  ' Se deberá consignar la sumatoria del total de las percepciones de ingresos
  ' brutos (suma del campo 23 del registro de tipo 1).
  m_Campos.Item(16).Valor = 0
  
  ' Campo 17: Importe de percepción de impuestos municipales
  ' Se deberá consignar la sumatoria del total de percepciones de impuestos
  ' municipales (suma del campo 24 del registro de tipo 1).
  m_Campos.Item(17).Valor = 0
  
  ' Campo 18: Importe de impuestos internos
  ' Se deberá consignar la sumatoria del total de impuestos internos
  ' (suma del campo 21 del registro de tipo 1).
  m_Campos.Item(18).Valor = 0
End Sub

Private Sub pAddCampos(ByRef Campos As cIAFIPCampos, ByRef Fields As ADODB.Fields)
  ' Solo pongo los valores que me interesan
  ' En SetCampos se guardan los valores comunes
  ' a todos los registros
  
  If Not Fields Is Nothing Then
  
    Dim cpt As String
    Dim c As String
    
    cpt = Left(ValField(Fields, ("CODCPT")), 3)
    c = Left$(cpt, 1)
    
    ' Importe total de la operacion
    ' IMPORT del archivo iv del registro de totales
    ' (codcpt: A= item, I=Impueto, T=Total)
    If c = "T" Then
      With m_Campos.Item(8)
        .Valor = CDbl(.Valor) + CDbl(ValField(Fields, "IMPORT"))
      End With
    
      ' Importe de operaciones exentas
      ' Se deberá consignar la sumatoria del total de los importes de
      ' operaciones exentas (suma del campo 20 del registro de tipo 1).
      If AFIPEsOperacionExenta(Fields) Then
        With m_Campos.Item(13)
          .Valor = CDbl(.Valor) + CDbl(ValField(Fields, "IMPORT"))
        End With
      End If

  
    ' Impuesto liquidado
    ' IMPORT Conceptos de tipo I01
    ElseIf cpt = "I01" Then
      With m_Campos.Item(12)
        .Valor = CDbl(.Valor) + CDbl(ValField(Fields, "IMPORT"))
      End With
    
    ' Importe de percepciones o pagos a cuenta del impuesto al valor agregado
    ElseIf cpt = "I03" Then
      With m_Campos.Item(14)
        .Valor = CDbl(.Valor) + CDbl(ValField(Fields, "IMPORT"))
      End With
  
    ' Importe de percepciones de ingresos brutos
    ' IMPORT Conceptos de tipo J01 y J02
    ElseIf cpt = "J01" Or cpt = "J02" Then
      With m_Campos.Item(16)
        .Valor = CDbl(.Valor) + CDbl(ValField(Fields, "IMPORT"))
      End With
    
    ' Si no es de tipo A o D no es un concepto exento.
    ElseIf c = "A" Or c = "D" Then
      If AFIPGetEsConceptoExento(cpt, True) Then
        ' Campo 9: Importe total de conceptos que no integran
        '          el precio neto gravado
        ' Se procederá a informar la sumatoria de los importes
        ' que no integren el hecho imponible, el cual podrá ser
        ' cero (suma del campo 13 del registro de tipo 1).
        With m_Campos.Item(9)
          .Valor = CDbl(.Valor) + CDbl(ValField(Fields, "IMPORT"))
        End With
      Else
        ' Campo 10: Importe neto gravado
        ' Se deberá consignar la sumatoria de los importes netos gravados
        ' correspondientes a las operaciones realizadas durante el período
        ' que se informa (suma del campo 14 del registro de tipo 1).
        With m_Campos.Item(10)
          .Valor = CDbl(.Valor) + CDbl(ValField(Fields, "IMPORT"))
        End With
      End If
    End If
  End If
End Sub
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





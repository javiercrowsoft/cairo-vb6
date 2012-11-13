VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cProcesoDetalle"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements cIAFIPProceso
'--------------------------------------------------------------------------------
' cProcesoDetalle
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
Private Const C_Module = "cProcesoDetalle"
' estructuras
' variables privadas
Private m_ObjProc As cObjetoProceso
' eventos
' propiedades publicas
Private Function cIAFIPProceso_ProcessRecord(Parametros As cIAFIPParametros, Fields As ADODB.Fields, Campos As cIAFIPCampos, ByVal IsLastRecord As Boolean, IsEmptyRecord As Boolean, ByVal lIndexRecord As Long, Esquema As cIAFIPEsquema) As Boolean
  
  If IsLastRecord Then
  
    IsEmptyRecord = True
    
  Else
    
    pSetDefaults Campos

    If Not m_ObjProc.ProcessRecord(Parametros, Fields, Campos, IsLastRecord, IsEmptyRecord, lIndexRecord, Esquema) Then
      Esquema.Log C_Module, "Fallo al procesar el registro " & lIndexRecord, LogSevError
      Exit Function
    End If
  
    IsEmptyRecord = Not pGetLine(Campos, Fields)
  End If
  
  cIAFIPProceso_ProcessRecord = True
End Function
' propiedades friend
' propiedades privadas
' funciones publicas
' funciones friend
' funciones privadas
Private Sub pSetDefaults(ByRef Campos As cIAFIPCampos)
  ' Precio unitario
  Campos.Item(9).Valor = 0
  
  ' Importe de bonificacion
  Campos.Item(10).Valor = 0
  
  ' Subtotal por registro
  Campos.Item(12).Valor = 0
  
  ' Alicuota de IVA aplicable
  Campos.Item(13).Valor = 0
End Sub

Private Function pGetLine(ByRef Campos As cIAFIPCampos, ByRef Fields As ADODB.Fields) As Boolean
  ' Solo pongo los valores que me interesan
  ' En SetCampos se guardan los valores comunes
  ' a todos los registros
  
  Dim cpt As String
  
  cpt = Left(ValField(Fields, ("CODCPT")), 3)
  ' Importe total de la operacion
  ' IMPORT del archivo iv del registro de totales
  ' (codcpt: A= item, I=Impueto, T=Total)
  If Not (Left(cpt, 1) = "A" And IsNumeric(Mid(cpt, 2))) Then Exit Function
  
  pGetLine = True
  
  ' Tipo de comprobante
  Campos.Item(1).Valor = AFIPGetTipoComprobante(ValField(Fields, "CODORI"), ValField(Fields, "CODMOV"), False)
  
  ' Unidad de medida
  Campos.Item(8).Valor = AFIPGetUnidad(ValField(Fields, "UNIFAC"))
  
  ' Codigo de iva
  Campos.Item(13).Valor = AFIPGetCodigoIVA1361(CDbl(ValField(Fields, "TASAII")))
  
  ' Campo 12: Subtotal por registro
  With Campos
    .Item(8).Valor = (CDbl(.Item(9).Valor) * CDbl(.Item(7).Valor)) - CDbl(.Item(10).Valor)
  End With
  
  ' Campo 14: Indicación de exento, gravado o no gravado
  ' Se indicará con la letra "E" en el supuesto de tratarse de un bien o
  ' servicio exento de IVA (campo 13 = 0) o una letra "N" si es un bien o
  ' servicio no gravado en IVA. Para el resto de los casos, se consignará
  ' la letra "G". Si el comprobante fue anulado antes de ser emitido
  ' (campo 15 = "A") no se consignará letra alguna.
  If Val(Campos.Item(13).Valor) = 0 Then
    If AFIPGetIvaFromConcepto(ValField(Fields, "CODCPTPR")) = 0 Then
      Campos.Item(14).Valor = "N"
    Else
      Campos.Item(14).Valor = "E"
    End If
  Else
    Campos.Item(14).Valor = "G"
  End If
End Function

' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  Set m_ObjProc = New cObjetoProceso
  
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





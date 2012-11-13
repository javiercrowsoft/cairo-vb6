VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cProceso1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements cIAFIPProceso
'--------------------------------------------------------------------------------
' cProceso1
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
Private Const C_Module = "cProceso1"
' estructuras
' variables privadas
Private m_ObjProc   As cObjetoProceso
Private m_Campos    As cIAFIPCampos
' eventos
' propiedades publicas
Private Function cIAFIPProceso_ProcessRecord(Parametros As cIAFIPParametros, Fields As ADODB.Fields, Campos As cIAFIPCampos, ByVal IsLastRecord As Boolean, IsEmptyRecord As Boolean, ByVal lIndexRecord As Long, Esquema As cIAFIPEsquema) As Boolean
  
  If IsLastRecord Then
  
    IsEmptyRecord = Not pSetCampos(Campos)
    
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
      pSetCampos Campos
      
    Else
      
      ' Si cambio de documento (El id esta siempre al final)
      If m_Campos.Item(m_Campos.Count).Valor <> Campos.Item(Campos.Count).Valor Then
        
        IsEmptyRecord = Not pSetCampos(Campos)
        
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
Private Function pSetCampos(ByRef rtnCampos As cIAFIPCampos) As Boolean
  Dim tmpCampos As cIAFIPCampos
  Dim rtn       As Boolean
  
  ' Si m_Campos no esta vacia es por que
  ' hay datos
  rtn = m_Campos.Count > 0

  Set tmpCampos = CSKernelClient.CreateObject("CSInfoAFIP.cAFIPCampos")
  
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
  pAddCampos m_Campos
  
  pSetCampos = rtn
End Function

Private Sub pSetDefaults()
  ' Tipo de campo
  m_Campos.Item(1).Valor = 1
  
End Sub

Private Sub pAddCampos(ByRef Campos As cIAFIPCampos, Optional ByRef Fields As ADODB.Fields)
  ' Solo pongo los valores que me interesan
  ' En SetCampos se guardan los valores comunes
  ' a todos los registros
  
  If Not Fields Is Nothing Then
  
    Dim cpt As String
    Dim Iva As Integer
    
    cpt = Left(ValField(Fields, ("CODCPT")), 3)
    ' Importe total de la operacion
    ' IMPORT del archivo iv del registro de totales
    ' (codcpt: A= item, I=Impueto, T=Total)
    If Left(cpt, 1) = "T" Then
      m_Campos.Item(12).Valor = ValField(Fields, "IMPORT")
      
      ' Lo hacemos una vez por comprobante
      ' Tipo de comprobante
      Campos.Item(3).Valor = AFIPGetTipoComprobante(ValField(Fields, "CODORI"), ValField(Fields, "CODMOV"))
    End If
  
    ' Impuesto liquidado
    ' IMPORT Conceptos de tipo I01
    If cpt = "I01" Then
      m_Campos.Item(15).Valor = ValField(Fields, "IMPORT")
    End If
  
    ' Impuesto liquidado a RNI o percepcion a no categorizados
    ' IMPORT Conceptos de tipo I02
    If cpt = "I02" Then
      m_Campos.Item(16).Valor = ValField(Fields, "IMPORT")
    End If
  
    ' Importe de percepciones de ingresos brutos
    ' IMPORT Conceptos de tipo J01 y J02
    If cpt = "J01" Or cpt = "J02" Then
      m_Campos.Item(19).Valor = ValField(Fields, "IMPORT")
    End If
    
  End If
End Sub

Private Function pGetDatosCliente(Parametros As cIAFIPParametros, Fields As ADODB.Fields, Campos As cIAFIPCampos) As Boolean

  Campos.Item(9).Valor = AFIPGetTipoDoc(Val(ValField(Fields, "TIPDOC")))
  Campos.Item(23).Valor = AFIPGetCondicionIva(Val(ValField(Fields, "CNDIVA")))
  
  pGetDatosCliente = True
  
End Function
' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  Set m_ObjProc = New cObjetoProceso
  Set m_Campos = CSKernelClient.CreateObject("CSInfoAFIP.cAFIPCampos")
  
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




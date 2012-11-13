VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cProcesoOtrasPercep"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements cIAFIPProceso
'--------------------------------------------------------------------------------
' cProcesoOtrasPercep
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
Private Const C_Module = "cProcesoOtrasPercep"
' estructuras
' variables privadas
Private m_ObjProc   As cObjetoProceso
' eventos
' propiedades publicas
Private Function cIAFIPProceso_ProcessRecord(Parametros As cIAFIPParametros, Fields As ADODB.Fields, Campos As cIAFIPCampos, ByVal IsLastRecord As Boolean, IsEmptyRecord As Boolean, ByVal lIndexRecord As Long, Esquema As cIAFIPEsquema) As Boolean
  If IsLastRecord Then
  
    IsEmptyRecord = True
    
  Else
    
    If Not m_ObjProc.ProcessRecord(Parametros, Fields, Campos, IsLastRecord, IsEmptyRecord, lIndexRecord, Esquema) Then
      Esquema.Log C_Module, "Fallo al procesar el registro " & lIndexRecord, LogSevError
      Exit Function
    End If
    
    Dim cpt As String
    cpt = Left(ValField(Fields, ("CODCPT")), 3)
    
    ' Si hay una percepcion
    If cpt = "J01" Or cpt = "J02" Then
      
      pSetCampos Campos, Esquema, Fields
      IsEmptyRecord = False
    Else
    
      IsEmptyRecord = True
    End If
  End If
  
  cIAFIPProceso_ProcessRecord = True
End Function
' propiedades friend
' propiedades privadas
' funciones publicas
' funciones friend
' funciones privadas
Private Sub pSetCampos(ByRef Campos As cIAFIPCampos, ByRef Esquema As cIAFIPEsquema, ByRef Fields As ADODB.Fields)
  
  ' Realizo las verificaciones a este registro como a cualquier otro
  pSetDefaults Campos
  pAddCampos Campos, Fields
End Sub

Private Sub pSetDefaults(ByRef Campos As cIAFIPCampos)
  ' Campo 7: Jurisdicción de impuestos municipales
  Campos.Item(7).Valor = ""
  
  ' Campo 8: Importe de percepciones por impuestos municipales
  Campos.Item(8).Valor = 0
  
  ' Campo 6: Importe de percepciones por ingresos brutos
  Campos.Item(6).Valor = 0
End Sub

Private Sub pAddCampos(ByRef Campos As cIAFIPCampos, ByRef Fields As ADODB.Fields)
  Dim Index As Integer
  ' Solo pongo los valores que me interesan
  ' En SetCampos se guardan los valores comunes
  ' a todos los registros
  
  If Not Fields Is Nothing Then
  
    Dim cpt As String
    Dim Iva As Integer
    
    cpt = Left(ValField(Fields, ("CODCPT")), 3)
    
    ' Campo 6: Importe de percepciones por ingresos brutos
    ' IMPORT Conceptos de tipo J01 y J02
    If cpt = "J01" Or cpt = "J02" Then
      Campos.Item(6).Valor = ValField(Fields, "IMPORT")
      
      ' Lo hacemos una vez por comprobante
      ' Tipo de comprobante
      Campos.Item(2).Valor = AFIPGetTipoComprobante(ValField(Fields, "CODORI"), ValField(Fields, "CODMOV"), True)
      
      If cpt = "J01" Then
        Campos.Item(5).Valor = "01"
      Else
        Campos.Item(5).Valor = "11"
      End If
    End If
  End If
End Sub

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

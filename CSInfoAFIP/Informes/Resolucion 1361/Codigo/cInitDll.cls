VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cInitDll"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements cIAFIPDll
'--------------------------------------------------------------------------------
' cInitDll
' 03-08-2003

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cInitDll"

' estructuras
' variables privadas
' eventos
' propiedades publicas
' propiedades friend
' propiedades privadas
' funciones publicas
Private Function cIAFIPDll_Initialize(ByRef Parametros As cIAFIPParametros, ByRef Esquema As cIAFIPEsquema) As Boolean
  Dim sqlstmt As String
  Dim Mouse As cMouseWait
  
  Set Mouse = New cMouseWait
  
  Esquema.Log C_Module, "Actualizando el maestro de clientes...", LogSevInformation
  
  DestroyDbAccess
  
  If Not CreateVTCL(Parametros) Then
    Esquema.Log C_Module, "Error: No se pudo cargar la tabla de clientes." & vbCrLf & LastErrorInfo, LogSevError
    Exit Function
  End If

  DestroyDbAccess

  If Not CreatePVCL(Parametros) Then
    Esquema.Log C_Module, "Error: No se pudo cargar la tabla de proveedors." & vbCrLf & LastErrorInfo, LogSevError
    Exit Function
  End If
  
  sqlstmt = "SELECT CODCPT, TASAII FROM VTCO00"
  If Not GetgDB(Parametros, "VT").OpenRsEX(True, False, True, sqlstmt, rsConceptosVtas, , , , "cIAFIPDll_Initialize", C_Module) Then
    Esquema.Log C_Module, "Error: No se pudo cargar la tabla de conceptos de ventas." & vbCrLf & LastErrorInfo, LogSevError
    Exit Function
  End If
  
  sqlstmt = "SELECT CODCPT, TASAII FROM PVCO00"
  If Not GetgDB(Parametros, "PV").OpenRsEX(True, False, True, sqlstmt, rsConceptosCpra, , , , "cIAFIPDll_Initialize", C_Module) Then
    Esquema.Log C_Module, "Error: No se pudo cargar la tabla de conceptos de compras." & vbCrLf & LastErrorInfo, LogSevError
    Exit Function
  End If
  
  sqlstmt = pGetSqlstmtTipoFormVta
  If Not GetgDB(Parametros, "VT").OpenRsEX(True, False, True, sqlstmt, rsTipoFormulariosVta, , , , "cIAFIPDll_Initialize", C_Module) Then
    Esquema.Log C_Module, "Error: No se pudo cargar la tabla de tipos de formularios de compra." & vbCrLf & LastErrorInfo, LogSevError
    Exit Function
  End If
  
  sqlstmt = pGetSqlstmtTipoFormCpra
  If Not GetgDB(Parametros, "VT").OpenRsEX(True, False, True, sqlstmt, rsTipoFormulariosCpra, , , , "cIAFIPDll_Initialize", C_Module) Then
    Esquema.Log C_Module, "Error: No se pudo cargar la tabla de tipos de formularios." & vbCrLf & LastErrorInfo, LogSevError
    Exit Function
  End If
  
  sqlstmt = "select mon_codigo, mon_codigodgi1, mon_codigodgi2 from moneda"
  If Not gDB.OpenRsEX(True, False, True, sqlstmt, rsMonedas, , , , "cIAFIPDll_Initialize", C_Module) Then
    Esquema.Log C_Module, "Error: No se pudo cargar la tabla de monedas." & vbCrLf & LastErrorInfo, LogSevError
    Exit Function
  End If
  
  sqlstmt = "select ti_codigo, ti_codigodgi1, ti_codigodgi2 from tasaimpositiva"
  If Not gDB.OpenRsEX(True, False, True, sqlstmt, rsIVA, , , , "cIAFIPDll_Initialize", C_Module) Then
    Esquema.Log C_Module, "Error: No se pudo cargar la tabla de alicuotas de IVA." & vbCrLf & LastErrorInfo, LogSevError
    Exit Function
  End If
  
  cIAFIPDll_Initialize = True
End Function

Private Function cIAFIPDll_Terminate(ByRef Esquema As cIAFIPEsquema) As Boolean
  pCloseObjects
  
  cIAFIPDll_Terminate = True
End Function
' funciones friend
' funciones privadas
Private Sub pCloseObjects()
  On Error Resume Next
  
  rsConceptosVtas.Close
  rsConceptosCpra.Close
  Set rsConceptosVtas = Nothing
  Set rsConceptosCpra = Nothing

'  rsFormularios.Close
'  Set rsFormularios = Nothing

  rsTipoFormulariosVta.Close
  rsTipoFormulariosCpra.Close
  Set rsTipoFormulariosVta = Nothing
  Set rsTipoFormulariosCpra = Nothing
End Sub

Private Function pGetSqlstmtTipoFormVta() As String
  Dim sqlstmt As String
  sqlstmt = "SELECT "
  
  sqlstmt = sqlstmt & "  VTCB00.CODIGO, " & vbCrLf
  sqlstmt = sqlstmt & "  VTCB00.DESCRP, " & vbCrLf
  sqlstmt = sqlstmt & "  VTCB00.CNDI01, " & vbCrLf
  sqlstmt = sqlstmt & "  VTCB00.CNDI02, " & vbCrLf
  sqlstmt = sqlstmt & "  VTCB00.CNDI03, " & vbCrLf
  sqlstmt = sqlstmt & "  VTCB00.CNDI04, " & vbCrLf
  sqlstmt = sqlstmt & "  VTCB00.CNDI05, " & vbCrLf
  sqlstmt = sqlstmt & "  VTCB00.CNDI06, " & vbCrLf
  sqlstmt = sqlstmt & "  VTCB00.CNDI07, " & vbCrLf
  sqlstmt = sqlstmt & "  VTCB00.CNDI08, " & vbCrLf
  sqlstmt = sqlstmt & "  VTCB00.CNDI09, " & vbCrLf
  sqlstmt = sqlstmt & "  VTCB00.CNDI10, " & vbCrLf
  sqlstmt = sqlstmt & "  VTCB00.CODF01, " & vbCrLf
  sqlstmt = sqlstmt & "  VTCB00.CODF02, " & vbCrLf
  sqlstmt = sqlstmt & "  VTCB00.CODF03, " & vbCrLf
  sqlstmt = sqlstmt & "  VTCB00.CODF04, " & vbCrLf
  sqlstmt = sqlstmt & "  VTCB00.CODF05, " & vbCrLf
  sqlstmt = sqlstmt & "  VTCB00.CODF06, " & vbCrLf
  sqlstmt = sqlstmt & "  VTCB00.CODF07, " & vbCrLf
  sqlstmt = sqlstmt & "  VTCB00.CODF08, " & vbCrLf
  sqlstmt = sqlstmt & "  VTCB00.CODF09, " & vbCrLf
  sqlstmt = sqlstmt & "  VTCB00.CODF10, " & vbCrLf
  sqlstmt = sqlstmt & "  VTCB00.DGIC01, " & vbCrLf
  sqlstmt = sqlstmt & "  VTCB00.DGIC02, " & vbCrLf
  sqlstmt = sqlstmt & "  VTCB00.DGIC03, " & vbCrLf
  sqlstmt = sqlstmt & "  VTCB00.DGIC04, " & vbCrLf
  sqlstmt = sqlstmt & "  VTCB00.DGIC05, " & vbCrLf
  sqlstmt = sqlstmt & "  VTCB00.DGIC06, " & vbCrLf
  sqlstmt = sqlstmt & "  VTCB00.DGIC07, " & vbCrLf
  sqlstmt = sqlstmt & "  VTCB00.DGIC08, " & vbCrLf
  sqlstmt = sqlstmt & "  VTCB00.DGIC09, " & vbCrLf
  sqlstmt = sqlstmt & "  VTCB00.DGIC10 " & vbCrLf
  
  sqlstmt = sqlstmt & " FROM VTCB00"

  pGetSqlstmtTipoFormVta = sqlstmt
End Function

Private Function pGetSqlstmtTipoFormCpra() As String
  Dim sqlstmt As String
  sqlstmt = "SELECT "
  
  sqlstmt = sqlstmt & "  PVCB00.CODIGO, " & vbCrLf
  sqlstmt = sqlstmt & "  PVCB00.DESCRP, " & vbCrLf
  sqlstmt = sqlstmt & "  PVCB00.CNDI01, " & vbCrLf
  sqlstmt = sqlstmt & "  PVCB00.CNDI02, " & vbCrLf
  sqlstmt = sqlstmt & "  PVCB00.CNDI03, " & vbCrLf
  sqlstmt = sqlstmt & "  PVCB00.CNDI04, " & vbCrLf
  sqlstmt = sqlstmt & "  PVCB00.CNDI05, " & vbCrLf
  sqlstmt = sqlstmt & "  PVCB00.CNDI06, " & vbCrLf
  sqlstmt = sqlstmt & "  PVCB00.CNDI07, " & vbCrLf
  sqlstmt = sqlstmt & "  PVCB00.CNDI08, " & vbCrLf
  sqlstmt = sqlstmt & "  PVCB00.CNDI09, " & vbCrLf
  sqlstmt = sqlstmt & "  PVCB00.CNDI10, " & vbCrLf
  sqlstmt = sqlstmt & "  PVCB00.CODF01, " & vbCrLf
  sqlstmt = sqlstmt & "  PVCB00.CODF02, " & vbCrLf
  sqlstmt = sqlstmt & "  PVCB00.CODF03, " & vbCrLf
  sqlstmt = sqlstmt & "  PVCB00.CODF04, " & vbCrLf
  sqlstmt = sqlstmt & "  PVCB00.CODF05, " & vbCrLf
  sqlstmt = sqlstmt & "  PVCB00.CODF06, " & vbCrLf
  sqlstmt = sqlstmt & "  PVCB00.CODF07, " & vbCrLf
  sqlstmt = sqlstmt & "  PVCB00.CODF08, " & vbCrLf
  sqlstmt = sqlstmt & "  PVCB00.CODF09, " & vbCrLf
  sqlstmt = sqlstmt & "  PVCB00.CODF10, " & vbCrLf
  sqlstmt = sqlstmt & "  PVCB00.DGIC01, " & vbCrLf
  sqlstmt = sqlstmt & "  PVCB00.DGIC02, " & vbCrLf
  sqlstmt = sqlstmt & "  PVCB00.DGIC03, " & vbCrLf
  sqlstmt = sqlstmt & "  PVCB00.DGIC04, " & vbCrLf
  sqlstmt = sqlstmt & "  PVCB00.DGIC05, " & vbCrLf
  sqlstmt = sqlstmt & "  PVCB00.DGIC06, " & vbCrLf
  sqlstmt = sqlstmt & "  PVCB00.DGIC07, " & vbCrLf
  sqlstmt = sqlstmt & "  PVCB00.DGIC08, " & vbCrLf
  sqlstmt = sqlstmt & "  PVCB00.DGIC09, " & vbCrLf
  sqlstmt = sqlstmt & "  PVCB00.DGIC10 " & vbCrLf
  
  sqlstmt = sqlstmt & " FROM PVCB00"

  pGetSqlstmtTipoFormCpra = sqlstmt
End Function
' construccion - destruccion
Private Sub Class_Terminate()
  On Error GoTo ControlError

  pCloseObjects
  
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



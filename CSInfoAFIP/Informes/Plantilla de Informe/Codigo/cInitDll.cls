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
  
  sqlstmt = "SELECT CODCPT, TASAII FROM VTCO00"
  If Not GetgDB(Parametros, "VT").OpenRs(sqlstmt, rsConceptosVtas, , , , "cIAFIPDll_Initialize", C_Module) Then
    Esquema.Log C_Module, "Error No se pudo cargar la tabla de conceptos de ventas." & vbCrLf & LastErrorInfo, LogSevError
    Exit Function
  End If
  
  sqlstmt = pGetSqlstmtTipoFormularios
  If Not GetgDB(Parametros, "VT").OpenRs(sqlstmt, rsTipoFormularios, , , , "cIAFIPDll_Initialize", C_Module) Then
    Esquema.Log C_Module, "Error No se pudo cargar la tabla de tipos de formularios." & vbCrLf & LastErrorInfo, LogSevError
    Exit Function
  End If
  
'  sqlstmt = "SELECT CODIGO,DESCRP,CODAFI FROM VTFR00"
'  If Not GetgDB(Parametros, "VT").OpenRs(sqlstmt, rsFormularios, , , , "cIAFIPDll_Initialize", C_Module) Then
'    Esquema.Log C_Module, "Error No se pudo cargar la tabla de formularios." & vbCrLf & LastErrorInfo, LogSevError
'    Exit Function
'  End If
  
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
  Set rsConceptosVtas = Nothing

'  rsFormularios.Close
'  Set rsFormularios = Nothing

  rsTipoFormularios.Close
  Set rsTipoFormularios = Nothing
End Sub

Private Function pGetSqlstmtTipoFormularios() As String
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

  pGetSqlstmtTipoFormularios = sqlstmt
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



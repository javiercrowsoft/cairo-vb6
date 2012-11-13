VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cEntradaPercepIIBB"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements cIAFIPEntrada
'--------------------------------------------------------------------------------
' cEntrada
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
Private Const C_Module = "cEntrada"

Private Const C_Param_Sqlstmt    As String = "sentencia"
' estructuras
' variables privadas
' eventos
' propiedades publicas
Private Property Get cIAFIPEntrada_NombreArchivo(Parametros As CSInterfacesInfoAFIP.cIAFIPParametros) As String
  cIAFIPEntrada_NombreArchivo = GetValidPath(GetParamValue(C_Param_FolderOut, Parametros)) _
                                 & "Percep_IIBB_" & GetParamValue(C_Param_Empresa, Parametros) _
                                 & "_" & GetDate(C_Param_FechaDesde, Parametros, "YYYYMM") & ".txt"
End Property
' propiedades friend
' propiedades privadas
' funciones publicas
Private Function cIAFIPEntrada_GetRecordset(Parametros As cIAFIPParametros, rs As ADODB.Recordset, Esquema As cIAFIPEsquema) As Boolean
  Dim sqlstmt     As String
  Dim ObjEntrada  As cObjetoEntrada
  Dim db          As cDataBase
  
  Set ObjEntrada = New cObjetoEntrada
  Set db = New cDataBase
  
  sqlstmt = GetParamValue(C_Param_Sqlstmt, Parametros) & " " _
            & db.sqlDate(GetParamValue(C_Param_FechaDesde, Parametros)) & ", " _
            & db.sqlDate(GetParamValue(C_Param_FechaHasta, Parametros)) & ", " _
            & GetParamId(C_Param_Empresa, Parametros) & ", " _
            & GetParamId(C_Param_Circuito, Parametros)
  
  cIAFIPEntrada_GetRecordset = ObjEntrada.GetRecordset(sqlstmt, Parametros, rs, Esquema)
End Function
' funciones friend
' funciones privadas
' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
  On Error GoTo ControlError

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




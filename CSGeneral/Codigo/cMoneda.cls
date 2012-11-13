VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cMoneda"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cMoneda
' 31-01-2001

'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes

Private Const C_Module = "cMoneda"

' estructuras
' variables privadas
' propiedades publicas
' propiedades privadas
' funciones publicas
Public Function GetCotizacion(ByVal Mon_id As Long, ByVal Fecha As Date) As Double
  On Error GoTo ControlError

  Dim sqlstmt             As String
  Dim rs                  As ADODB.Recordset
  Dim DecimalesCotizacion As Double
  
  sqlstmt = "sp_monedaGetCotizacion " & Mon_id & ", " & gDB.sqlDate(Fecha)
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  If rs.EOF Then Exit Function
  
  DecimalesCotizacion = gDB.ValField(rs.Fields, "DecimalesCotizacion")
  
  GetCotizacion = Round(gDB.ValField(rs.Fields, cscMoniPrecio), DecimalesCotizacion)

  GoTo ExitProc
ControlError:
  MngError Err, "GetCotizacion", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function
' funciones privadas
' construccion - destruccion

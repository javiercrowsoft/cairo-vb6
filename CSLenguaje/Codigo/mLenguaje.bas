Attribute VB_Name = "mLenguaje"
Option Explicit

'--------------------------------------------------------------------------------
' mLenguaje
' 24-12-2003

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "mLenguaje"
' estructuras
' variables privadas
' eventos
' propiedades publicas
' propiedades friend
' propiedades privadas
' funciones publicas
Public Function LENGGetText(ByVal Code As String, ByVal Default As String)
  Dim sqlstmt As String
  Dim rs      As Recordset
  Dim rtn     As String
  
  sqlstmt = "sp_LengGetText " & gDB.sqlString(Code) & "," & gDB.UserId
  
  rtn = Default
  
  If gDB.OpenRs(sqlstmt, rs) Then
    If Not rs.EOF Then
      If gDB.ValField(rs.fields, 0) <> "" Then
        rtn = gDB.ValField(rs.fields, 0)
      End If
    End If
  End If
  
  LENGGetText = rtn
End Function
' funciones friend
' funciones privadas
' construccion - destruccion

'//////////////////////////////
'  Codigo estandar de errores
'  On Error GoTo ControlError
'
'  GoTo ExitProc
'ControlError:
'  MngError err,"", C_Module, ""
'  If Err.Number Then Resume ExitProc
'ExitProc:
'  On Error Resume Next



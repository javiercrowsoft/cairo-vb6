Attribute VB_Name = "mPublic"
Option Explicit

'--------------------------------------------------------------------------------
' mPublic
' 20-01-01

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
' estructuras
' variables privadas
' variables publicas

' Base de datos
Public gDB          As cDataBase

' nombre de la Aplication
Public gAppName     As String

' funciones publicas

Public Function ShowCobranzaContado(ByVal CliId As Long, _
                                    ByVal FvId As Long, _
                                    ByVal FvFecha As Date, _
                                    ByVal FvTotal As Double, _
                                    ByVal SucId As Long, _
                                    ByVal CcosId As Long, _
                                    ByVal LgjId As Long) As Boolean
  
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_DocEsCobranzaCdo " & FvId
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  If rs.EOF Then Exit Function
  
  If gDB.ValField(rs.fields, 0) Then
  
    Dim CobranzaCdo As cCobranzaContado
    Set CobranzaCdo = New cCobranzaContado
    
    CobranzaCdo.ShowCobranza CliId, FvId, FvFecha, FvTotal, _
                             SucId, CcosId, LgjId, csNO_ID
  
  End If
  
  ShowCobranzaContado = True
End Function

Public Function IsCobranzaContado(ByVal FvId As Long) As Boolean
  
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_DocEsCobranzaCdo " & FvId
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  If rs.EOF Then Exit Function
  
  IsCobranzaContado = gDB.ValField(rs.fields, 0) <> 0

End Function


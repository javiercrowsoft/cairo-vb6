Attribute VB_Name = "mPublic"
Option Explicit

'--------------------------------------------------------------------------------
' mPublic
' 23-03-02

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

Public Function GetNombreRama(ByVal Tbl_id As Long, ByVal Ram_ID As Long, ByRef bExists As Boolean) As String
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  sqlstmt = "select ram_nombre "
  sqlstmt = sqlstmt & " from rama,arbol "
  sqlstmt = sqlstmt & " where rama.arb_id = arbol.arb_id "
  sqlstmt = sqlstmt & " and ram_id = " & Ram_ID
  sqlstmt = sqlstmt & " and tbl_id = " & Tbl_id
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  If rs.EOF Then Exit Function
  
  bExists = True
  
  GetNombreRama = gDB.ValField(rs.Fields, cscRamNombre)
End Function
' funciones privadas
' construccion - destruccion





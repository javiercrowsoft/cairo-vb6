Attribute VB_Name = "mPublicAux"
Option Explicit

'--------------------------------------------------------------------------------
' mPublicAux
' -01-2004

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "mPublicAux"
' estructuras
' variables privadas
' eventos
' propiedades publicas
' propiedades friend
' propiedades privadas
' funciones publicas
Public Function GetDocumentoTipoInfo_(ByVal doct_id As Long, _
                                      ByRef doct_nombre As String, _
                                      ByRef doct_object As String, _
                                      ByRef pre_id As Long) As Boolean

  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  If doct_id < 0 Then
    sqlstmt = "select tbl_nombre as doct_nombre, tbl_objectedit as doct_object, pre_id from tabla where tbl_id = " & doct_id * -1
  Else
    sqlstmt = "select doct_nombre, doct_object, pre_id from documentoTipo where doct_id = " & doct_id
  End If
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  If rs.EOF Then Exit Function
  
  doct_nombre = gDB.ValField(rs.Fields, cscDoctNombre)
  doct_object = gDB.ValField(rs.Fields, cscDoctObject)
  pre_id = gDB.ValField(rs.Fields, cscPreID)
  
  GetDocumentoTipoInfo_ = True
End Function

Public Function GetHelpFilterCliSuc_(ByVal cli_id As Long) As String
  GetHelpFilterCliSuc_ = "cli_id = " & cli_id
End Function

' funciones friend
' funciones privadas
' construccion - destruccion

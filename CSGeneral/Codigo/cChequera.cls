VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cChequera"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cChequera
' 06-09-2003
'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones
'--------------------------------------------------------------------------------
' constantes
Private Const C_Module = "cChequera"
' estructuras
' variables privadas
' Properties publicas
' Properties privadas
' funciones publicas
Public Function GetNextNumber(ByVal chq_id As Long, ByRef rtn As Long) As Boolean
  Dim sqlstmt As String
  Dim rs      As Recordset
  Dim Min     As Long
  Dim Max     As Long
  
  sqlstmt = "select chq_ultimonumero, chq_numerodesde, chq_numerohasta" & _
            " from chequera where chq_id = " & chq_id
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  If rs.EOF Then
    rtn = 0
    GetNextNumber = False
  Else
    Min = gDB.ValField(rs.Fields, cscChqNumerodesde)
    Max = gDB.ValField(rs.Fields, cscChqNumerohasta)
  
    rtn = gDB.ValField(rs.Fields, cscChqUltimonumero) + 1
    
    If rtn < Min Then rtn = Min
    If rtn > Max Then rtn = Max
    
    GetNextNumber = True
  End If
End Function

' funciones privadas
' construccion - destruccion

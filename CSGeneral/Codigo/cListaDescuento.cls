VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cListaDescuento"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cListaDescuento
' 09-05-2003

'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cListaDescuento"
' estructuras
' variables privadas
' Properties publicas
' Properties privadas
' funciones publicas

' Implementacion de cIABMClient
Public Function GetDescuentoStr(ByVal ld_id As Long, ByVal pr_id As Long) As String
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  sqlstmt = "sp_ldGetDescuentoStr " _
                  & ld_id & C_StrColon _
                  & pr_id & C_StrColon _
                  & "'',1"
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  If Not rs.EOF Then
    GetDescuentoStr = gDB.ValField(rs.Fields, 0)
  Else
    GetDescuentoStr = vbNullString
  End If
End Function

Public Function GetPrecio(ByVal ld_id As Long, ByVal pr_id As Long, ByVal Precio As Double) As Double
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  sqlstmt = "sp_ldGetDescuento " _
              & ld_id & C_StrColon _
              & pr_id & C_StrColon _
              & gDB.sqlNumber(Precio) & ",1"
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  If Not rs.EOF Then
    GetPrecio = gDB.ValField(rs.Fields, 0)
  Else
    GetPrecio = Precio
  End If
End Function

Public Function GetData(ByVal Id As Long, ByVal strField As String, ByVal TypeValue As csTypes) As Variant
  Dim Data As Variant
  
  Select Case TypeValue
    Case csTypes.csBoolean
      Data = False
    Case csTypes.csCuit, csTypes.csText
      Data = vbNullString
    Case csTypes.csDate, csTypes.csDateOrNull
      Data = csNoDate
    Case csTypes.csCurrency, csTypes.csDouble, _
         csTypes.csInteger, csTypes.csLong, _
         csTypes.csSingle, csTypes.csId
      Data = 0
    Case csTypes.csVariant
      Data = Empty
  End Select
  
  If Not gDB.GetData(csTListaDescuento, cscLdId, Id, strField, Data, "GetData", C_Module) Then
    Select Case TypeValue
      Case csTypes.csBoolean
        Data = False
      Case csTypes.csCuit, csTypes.csText
        Data = vbNullString
      Case csTypes.csDate, csTypes.csDateOrNull
        Data = csNoDate
      Case csTypes.csCurrency, csTypes.csDouble, _
           csTypes.csInteger, csTypes.csLong, _
           csTypes.csSingle, csTypes.csId
        Data = 0
      Case csTypes.csVariant
        Data = Empty
    End Select
  End If
  
  GetData = Data
End Function

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

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
Public Const KICHT_OPGI_ID               As Integer = 1
Public Const KICHT_MFI_ID                As Integer = 1

Public Const KICHT_CUE_ID                As Integer = 2
Public Const KICHT_IMPORTE               As Integer = 3
Public Const KICHT_IMPORTEORIGEN         As Integer = 4
Public Const KICHT_CLI_ID                As Integer = 5
Public Const KICHT_BCO_ID                As Integer = 6
Public Const KICHT_CHEQUE                As Integer = 7
Public Const KICHT_MON_ID                As Integer = 8
Public Const KICHT_FECHACOBRO            As Integer = 10
Public Const KICHT_FECHAVTO              As Integer = 11
Public Const KICHT_CLE_ID                As Integer = 12
Public Const KICHT_DESCRIP               As Integer = 13
Public Const KICHT_CHEQ_ID               As Integer = 14
' estructuras

' variables privadas

' Base de datos
Public gDB          As cDataBase

' nombre de la Aplication
Public gAppName     As String

Public g_conciliacion_cue_id As Long
Public g_conciliacion_desde  As Date
Public g_conciliacion_hasta  As Date
Public g_fecha_cobro_cheque  As Boolean

' variables publicas
' funciones publicas
' funciones privadas
' construccion - destruccion

Public Sub SetChequeData(ByRef Row As cIABMGridRow, ByVal cheq_id As Long)
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_chequeGetData " & cheq_id
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  If Not rs.EOF Then
  
    pCell(Row, KICHT_BCO_ID).Value = gDB.ValField(rs.Fields, cscBcoNombre)
    pCell(Row, KICHT_CLI_ID).Value = gDB.ValField(rs.Fields, cscCliNombre)
    pCell(Row, KICHT_FECHAVTO).Value = gDB.ValField(rs.Fields, cscCheqFechaVto)
    pCell(Row, KICHT_FECHACOBRO).Value = gDB.ValField(rs.Fields, cscCheqFechaCobro)
    pCell(Row, KICHT_CLE_ID).Value = gDB.ValField(rs.Fields, cscCleNombre)
    pCell(Row, KICHT_IMPORTE).Value = gDB.ValField(rs.Fields, cscCheqImporte)
    pCell(Row, KICHT_IMPORTEORIGEN).Value = gDB.ValField(rs.Fields, cscCheqImporteOrigen)
  
  Else
  
    pCell(Row, KICHT_BCO_ID).Value = vbNullString
    pCell(Row, KICHT_CLI_ID).Value = vbNullString
    pCell(Row, KICHT_FECHAVTO).Value = vbNullString
    pCell(Row, KICHT_FECHACOBRO).Value = vbNullString
    pCell(Row, KICHT_CLE_ID).Value = vbNullString
    pCell(Row, KICHT_IMPORTE).Value = 0
    pCell(Row, KICHT_IMPORTEORIGEN).Value = 0
  End If
End Sub

Public Function ValidateCuota(ByVal tjc_id As Long, ByVal tjccu_id As Long) As Boolean
  Dim tjc_id2 As Long
  
  If tjccu_id <> csNO_ID Then
    If Not gDB.GetData("TarjetaCreditoCuota", "tjccu_id", tjccu_id, "tjc_id", tjc_id2) Then Exit Function
    If tjc_id2 <> tjc_id Then Exit Function
  End If
  ValidateCuota = True
End Function

Public Sub SetFilterCuotas(ByRef Row As cIABMGridRow, ByRef IProperty As cIABMProperty, ByRef AbmObj As cABMGeneric, ByVal KIT_TJC_ID As Integer)
  Dim TjcId As Long
  Const c_Cuotas = "Cuotas"
  
  TjcId = pCell(Row, KIT_TJC_ID).Id
  IProperty.Grid.Columns(c_Cuotas).HelpFilter = "tjc_id = " & TjcId
  AbmObj.RefreshColumnProperties IProperty, c_Cuotas
End Sub

Public Function GetHelpFilterCheques() As String
  GetHelpFilterCheques = "(" & cscCuecId & "=" & csECuecBancos & " or " _
                          & cscCuecId & "=" & csECuecDocEnCartera & _
                          ") and (emp_id = " & EmpId & " or emp_id is null)"
End Function

Public Function GetHelpFilterEfectivo() As String
  GetHelpFilterEfectivo = "(" & cscCuecId & "=" & csECuecCaja & " or " _
                          & cscCuecId & "=" & csECuecBancos & _
                          ") and (emp_id = " & EmpId & " or emp_id is null)"
End Function

Public Function GetHelpFilterCupon() As String
  GetHelpFilterCupon = "(" & cscCuecId & "=" & csECuecDepositoCupones & _
                        ") and (emp_id = " & EmpId & " or emp_id is null)"
End Function

Public Function GetHelpFilterChequesP() As String
  GetHelpFilterChequesP = "(" & cscCuecId & "=" & csECuecBancos & _
                          ") and (emp_id = " & EmpId & " or emp_id is null)"
End Function

Public Function GetHelpFilterChequesT() As String
  GetHelpFilterChequesT = "(" & cscCuecId & "=" & csECuecDocEnCartera & _
                          ") and (emp_id = " & EmpId & " or emp_id is null)"
End Function

Public Function GetChequeFileter(ByVal CueId As Long) As String
  GetChequeFileter = "Cheque.cue_id =" & CueId & " and Cheque.cheq_anulado = 0"
End Function

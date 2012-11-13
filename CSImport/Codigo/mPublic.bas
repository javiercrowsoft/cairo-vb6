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

Public Const LOG_NAME = "\CSImport.log"
Public Const LOG_NAME2 = "\CSImport"
' funciones privadas
' construccion - destruccion

Public Sub pSaveLogToDb(ByVal msg As String, ByVal Severity As csLogSeverity, _
                        ByVal impp_id As Long, ByVal Module As String)
  Dim register As cRegister
  
  Set register = New cRegister
  register.fieldId = cscImplId
  register.Table = csTImportacionLog
  register.ID = csNew

  register.Fields.Add2 cscImplDescrip, msg, csText
  register.Fields.Add2 cscImplSeveridad, Severity, csInteger
  register.Fields.Add2 cscImplSeveridad, Date, csDate
  register.Fields.Add2 cscImppId, impp_id, csId

  register.Fields.HaveLastUpdate = False
  register.Fields.HaveWhoModify = False

  If Not gDB.Save(register, , "pSaveLogToDb", Module, "Error al grabar el log") Then Exit Sub
  
End Sub

#If PREPROC_UNATTENDED Then
Public Function LNGGetText(ByVal lengi_codigo As String, _
                           ByVal Default As String, _
                           ParamArray params() As Variant) As String

  If gDB Is Nothing Then
    LNGGetText = Default
    Exit Function
  End If

  Dim sqlstmt As String
  Dim rs      As Recordset
  Dim rtn     As String
  
  sqlstmt = "sp_LengGetText " & gDB.sqlString(lengi_codigo) & "," & gDB.UserId
  
  If gDB.OpenRs(sqlstmt, rs) Then
    If Not rs.EOF Then
      If LenB(gDB.ValField(rs.Fields, 0)) Then
        rtn = gDB.ValField(rs.Fields, 0)
      Else
        rtn = Default
      End If
    Else
      rtn = Default
    End If
  Else
    rtn = Default
  End If
  
'-------------------------------------
  On Error GoTo ExitProc
  
  Dim i As Long
  Dim q As Long
  
  For i = LBound(params) To UBound(params)
    q = q + 1
    rtn = Replace(rtn, "#" & q & "#", CStr(params(i)))
  Next
  
ExitProc:
'-------------------------------------

  LNGGetText = rtn
End Function
#End If

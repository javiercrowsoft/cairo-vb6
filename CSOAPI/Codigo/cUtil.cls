VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cUtil"
Attribute VB_GlobalNameSpace = True
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cUtil
' 27-12-99

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cUtil"
' estructuras
' variables privadas
' Properties publicas
Public Property Let EmpId(ByVal rhs As Long)
  gEmpId = rhs
End Property
Public Property Get EmpId() As Long
  EmpId = gEmpId
End Property
Public Property Get EmpNombre() As String
  EmpNombre = gEmpNombre
End Property
Public Property Get BdVersion() As String
  BdVersion = gBdVersion
End Property
Public Property Let BdId(ByVal rhs As Long)
  gBdId = rhs
End Property
Public Property Get BdId() As Long
  BdId = gBdId
End Property
Public Property Get User() As cUsuario
  Set User = gUser
End Property
Public Property Get TCPClient() As cTCPIPClient
  Set TCPClient = gTCPClient
End Property
Public Property Get ClientProcessId() As Long
  ClientProcessId = gClientProcessId
End Property
Public Property Get ConnectString() As String
  ConnectString = gDB.StrConnect
End Property
Public Property Get Starting() As Boolean
  Starting = gStarting
End Property
Public Property Let Starting(ByVal rhs As Boolean)
  gStarting = rhs
End Property

' Properties privadas
' funciones publicas
Public Function SelectFromRs(ByVal SelectTitle As String, _
                             ByRef rs As ADODB.Recordset, _
                             ByRef Id As Long) As Boolean
  On Error GoTo ControlError
  
  SelectFromRs = ShowSelectRs_(SelectTitle, rs, Id)

  GoTo ExitProc
ControlError:
  MngError Err, "SelectFromRs", C_Module, vbNullString
ExitProc:
End Function

Public Function GetDocIDFromRecordset(ByRef rs As ADODB.Recordset, ByRef Id As Long) As Boolean
  On Error GoTo ControlError
  
  Do
    If UCase(Trim(gDB.ValField(rs.Fields, 0))) = "ERROR" Then
      MsgWarning Trim(gDB.ValField(rs.Fields, 1))
      Exit Function
    End If
    
    If UCase(Trim(gDB.ValField(rs.Fields, 0))) = "INFO" Then
      MsgInfo Trim(gDB.ValField(rs.Fields, 1))
    End If
    
    Id = Val(gDB.ValField(rs.Fields, 0))
  
    Set rs = rs.NextRecordset
  Loop Until rs Is Nothing
  
  GetDocIDFromRecordset = True

  GoTo ExitProc
ControlError:
  MngError Err, "GetDocIDFromRecordset", C_Module, vbNullString, LNGGetText(3459, vbNullString), csErrorWarning, csErrorVba
                                                                'Error al obtener el resultado de la grabación de un documento
ExitProc:
End Function

Public Function LENGGetText(ByVal Code As String, ByVal Default As String)
  Dim sqlstmt As String
  Dim rs      As Recordset
  Dim rtn     As String
  
  sqlstmt = "sp_LengGetText " & gDB.sqlString(Code) & "," & gDB.UserId
  
  rtn = Default
  
  If gDB.OpenRs(sqlstmt, rs) Then
    If Not rs.EOF Then
      If LenB(gDB.ValField(rs.Fields, 0)) Then
        rtn = gDB.ValField(rs.Fields, 0)
      End If
    End If
  End If
  
  LENGGetText = rtn
End Function

Public Function ShowInfo(ByVal InfoTitle As String, ByVal sqlstmt As String) As Boolean
  On Error GoTo ControlError
  
  Dim rs As Recordset
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function

  ShowInfoRows_ InfoTitle, rs

  GoTo ExitProc
ControlError:
  MngError Err, "ShowInfo", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Public Function ShowNotes(ByVal InfoTitle As String, ByVal sqlstmt As String) As Boolean
  On Error GoTo ControlError

  ShowNotes_ InfoTitle, sqlstmt, vbNullString, vbNullString

  ShowNotes = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "ShowNotes", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Public Function ShowNotesEx(ByVal InfoTitle As String, _
                            ByVal sqlstmt As String, _
                            ByVal ObjectEdit As String, _
                            ByVal ObjectABM As String) As Boolean
                            
  On Error GoTo ControlError

  ShowNotes_ InfoTitle, sqlstmt, ObjectEdit, ObjectABM

  ShowNotesEx = True

  GoTo ExitProc
ControlError:
  MngError Err, "ShowNotesEx", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Public Function ShowInfoCliente(ByVal cli_id As Long) As Boolean
  On Error GoTo ControlError

  ShowInfoCliente_ cli_id, Nothing, Not App.NonModalAllowed

  GoTo ExitProc
ControlError:
  MngError Err, "ShowInfoCliente", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

' Esta dos veces por el tema de paramarray
' mas adelante buscaremos una tecnica para
' pasar el paramarray si es que la hay.
'
' Esta funcion esta en mGlobal copiada exactamente igual
'
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

Public Sub ShowHistory(ByVal tbl_id As Long, _
                       ByVal Id As Long, _
                       ByVal descrip As String)
  On Error GoTo ControlError

  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_HistoriaShow " & tbl_id & "," & Id
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  ShowInfoRows_ "Historial de " & descrip, rs
  
  GoTo ExitProc
ControlError:
  MngError Err, "ShowHistory", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Public Function ValidateDate(Optional ByVal bSilent As Boolean = False) As Boolean
  Dim sqlstmt As String
  Dim rs As ADODB.Recordset
  
  sqlstmt = "select getdate()"
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  If rs.EOF Then Exit Function
  
  Dim server_date As Date
  server_date = gDB.ValField(rs.Fields, 0)
  
  If Abs(DateDiff("n", server_date, Now)) > 5 Then
     
    If Not bSilent Then
    
      Dim msg As String
      msg = LNGGetText(4824, vbNullString, server_date, Now)
            ' La fecha y hora del servidor es distinta a la fecha de esta pc.
            ' Fecha en el Server: server_date
            ' Fecna en esta pc: now
      MsgWarning msg
    
    End If
      
    Exit Function
  End If
  
  ValidateDate = True
End Function

' funciones privadas
' construccion - destruccion


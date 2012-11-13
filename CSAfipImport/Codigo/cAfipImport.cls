VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cAfipImport"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

'/////////////////////////////////////////////////////////////////////////////
' Diseño de registro de salida
'    Nombre         Posición  Longitud  Comentarios (*)
'    CUIT           1-11      11
'    DENOMINACION   12-41     30
'    IMP GANANCIAS  42/43     2         'NI' , 'AC','EX','ET'
'    IMP IVA        44/45     2         'NI' , 'AC','EX','NA','XN','AN'
'    MONOTRIBUTO    46 / 47   2         'NI' , "Codigo categoria tributaria"
'    INTEGRANTE SOC 48        1         'N' , 'S'
'    EMPLEADOR      49        1         'N', 'S'
'/////////////////////////////////////////////////////////////////////////////

Private m_cn As ADODB.Connection

Private Type t_afip
  cuit            As String
  denominacion    As String
  ganancias       As String
  iva             As String
  mono            As String
  soc             As String
  empleador       As String
End Type

Public Function Connect() As Boolean
  On Error GoTo ControlError

  If m_cn Is Nothing Then Set m_cn = New Connection
  m_cn.Open "file name=" & App.Path & "\AFIPImport.udl"
  
  MsgInfo "Conexion exitosa"

  Connect = True

  GoTo ExitProc
ControlError:
  MngError "Connect", err
  If err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Public Function Import(ByVal File As String)
  On Error GoTo ControlError
  
  Dim f     As Integer
  Dim afip  As t_afip
  Dim str   As String
  Dim n     As Long
 
  f = FreeFile
 
  Open File For Binary As #f
 
  While Not EOF(f)

    ReadRecord f, str

    pFillAfip afip, str
    
    n = n + 1
    
    pInsert afip
  Wend
  
  GoTo ExitProc
ControlError:
  MngError "Import", err
  If err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
  Close f
End Function

Private Sub pFillAfip(ByRef afip As t_afip, ByVal str As String)
  With afip
    .cuit = Mid(str, 1, 11)
    .denominacion = Mid(str, 12, 30)
    .ganancias = Mid(str, 42, 2)
    .iva = Mid(str, 44, 2)
    .mono = Mid(str, 46, 2)
    .soc = Mid(str, 48, 1)
    .empleador = Mid(str, 49, 1)
  End With
End Sub

Private Sub pInsert(ByRef afip As t_afip)
  On Error GoTo ControlError
  
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  sqlstmt = "select aabaafip_cuit from aaba_afip where aabaafip_cuit = '" & afip.cuit & "'"
  
  Set rs = New ADODB.Recordset
  rs.Open sqlstmt, m_cn, adOpenStatic, adLockReadOnly
  
  With afip
  
    If rs.EOF Then
    
      sqlstmt = "insert aaba_afip ("
      sqlstmt = sqlstmt & "aabaafip_cuit"
      sqlstmt = sqlstmt & ",aabaafip_denominacion"
      sqlstmt = sqlstmt & ",aabaafip_empleador"
      sqlstmt = sqlstmt & ",aabaafip_ganancias"
      sqlstmt = sqlstmt & ",aabaafip_mono"
      sqlstmt = sqlstmt & ",aabaafip_iva"
      sqlstmt = sqlstmt & ",aabaafip_soc"
      sqlstmt = sqlstmt & ") values ("
      sqlstmt = sqlstmt & pGetStringSql(.cuit)
      sqlstmt = sqlstmt & "," & pGetStringSql(.denominacion)
      sqlstmt = sqlstmt & "," & pGetStringSql(.empleador)
      sqlstmt = sqlstmt & "," & pGetStringSql(.ganancias)
      sqlstmt = sqlstmt & "," & pGetStringSql(.mono)
      sqlstmt = sqlstmt & "," & pGetStringSql(.iva)
      sqlstmt = sqlstmt & "," & pGetStringSql(.soc)
      sqlstmt = sqlstmt & ")"
    
    
    ' No creo que sea util
    '
    'Else

      'sqlstmt = "update aaba_afip set "
      'sqlstmt = sqlstmt & "aabaafip_denominacion =" & pGetStringSql(.denominacion)
      'sqlstmt = sqlstmt & ",aabaafip_empleador =" & pGetStringSql(.empleador)
      'sqlstmt = sqlstmt & ",aabaafip_ganancias =" & pGetStringSql(.ganancias)
      'sqlstmt = sqlstmt & ",aabaafip_mono =" & pGetStringSql(.mono)
      'sqlstmt = sqlstmt & ",aabaafip_iva =" & pGetStringSql(.iva)
      'sqlstmt = sqlstmt & ",aabaafip_soc =" & pGetStringSql(.soc)
      'sqlstmt = sqlstmt & " where aabaafip_cuit = '" & rs.Fields(0).value & "'"
      
    End If
    
    rs.Close
    
    m_cn.Execute sqlstmt
  End With

  GoTo ExitProc
ControlError:
  MngError "pInsert", err
  If err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Function pGetStringSql(value)
  pGetStringSql = "'" & Replace(value, "'", "''") & "'"
End Function

Private Sub Class_Terminate()
  On Error Resume Next
  m_cn.Close
  Set m_cn = Nothing
End Sub


Private Sub ReadRecord(ByVal f As Integer, ByRef str As String)
  Dim bBuffer(0) As Byte
  
  str = ""
  Do While Not EOF(f)
  
    Get #f, , bBuffer()
  
    ' End record
    If bBuffer(0) = 10 Then
      Exit Do
    End If
    str = str & Chr(bBuffer(0))
  Loop
End Sub

Public Function RepairFile(ByVal File As String)
  On Error GoTo ControlError
  
  Dim f     As Integer
  Dim fo    As Integer
  Dim afip  As t_afip
  Dim str   As String
 
  f = FreeFile
 
  Open File For Binary As #f
 
  fo = FreeFile
  Open File & ".txt" For Output As #fo
 
  While Not EOF(f)

    ReadRecord f, str
    
    Print #fo, str
  Wend
  
  GoTo ExitProc
ControlError:
  MngError "RepairFile", err
  If err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
  Close f
End Function


VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Begin VB.Form FrmScriptor 
   Caption         =   "Generar Script"
   ClientHeight    =   4740
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   8940
   Icon            =   "FrmScriptor.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   4740
   ScaleWidth      =   8940
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton cmdTodos 
      Caption         =   "Todos"
      Height          =   375
      Left            =   6570
      TabIndex        =   13
      Top             =   495
      Width           =   1545
   End
   Begin MSComDlg.CommonDialog CDialog 
      Left            =   7920
      Top             =   2970
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.CheckBox ChkSinEspacios 
      Alignment       =   1  'Right Justify
      Caption         =   "No rellenar con espacios"
      Height          =   195
      Left            =   5355
      TabIndex        =   12
      Top             =   3600
      Width           =   2130
   End
   Begin VB.CommandButton CmdAgregar 
      Caption         =   "Agregar"
      Height          =   375
      Left            =   6570
      TabIndex        =   11
      Top             =   45
      Width           =   1545
   End
   Begin VB.CheckBox ChkArchivoXTabla 
      Alignment       =   1  'Right Justify
      Caption         =   "Un archivo por tabla"
      Height          =   195
      Left            =   2520
      TabIndex        =   10
      Top             =   3600
      Width           =   2130
   End
   Begin VB.CheckBox ChkCrearFile 
      Alignment       =   1  'Right Justify
      Caption         =   "Archivo Nuevo"
      Height          =   195
      Left            =   180
      TabIndex        =   9
      Top             =   3600
      Width           =   1725
   End
   Begin VB.CommandButton CmdBuscar 
      Caption         =   "Buscar"
      Height          =   375
      Left            =   5805
      TabIndex        =   5
      Top             =   3060
      Width           =   1455
   End
   Begin VB.TextBox TxFile 
      Height          =   330
      Left            =   1710
      TabIndex        =   4
      Top             =   3015
      Width           =   3840
   End
   Begin VB.CommandButton CmdGenerar 
      Caption         =   "Generar"
      Height          =   375
      Left            =   7200
      TabIndex        =   3
      Top             =   4230
      Width           =   1545
   End
   Begin VB.CommandButton CmdSentenciaBasica 
      Caption         =   "Sentencia basica"
      Height          =   375
      Left            =   90
      TabIndex        =   2
      Top             =   1710
      Width           =   1545
   End
   Begin VB.TextBox TxSqlstmt 
      Height          =   1905
      Left            =   1710
      MultiLine       =   -1  'True
      ScrollBars      =   3  'Both
      TabIndex        =   1
      Top             =   900
      Width           =   7035
   End
   Begin VB.ComboBox CbTablas 
      Height          =   315
      Left            =   1755
      Sorted          =   -1  'True
      Style           =   2  'Dropdown List
      TabIndex        =   0
      Top             =   315
      Width           =   4335
   End
   Begin VB.Line Line1 
      BorderColor     =   &H8000000E&
      Index           =   1
      X1              =   135
      X2              =   8775
      Y1              =   4020
      Y2              =   4020
   End
   Begin VB.Line Line1 
      BorderColor     =   &H8000000C&
      Index           =   0
      X1              =   135
      X2              =   8775
      Y1              =   4005
      Y2              =   4005
   End
   Begin VB.Label Label1 
      Caption         =   "Archivo"
      Height          =   240
      Index           =   2
      Left            =   180
      TabIndex        =   8
      Top             =   3060
      Width           =   1455
   End
   Begin VB.Label Label1 
      Caption         =   "Sentencia"
      Height          =   240
      Index           =   1
      Left            =   180
      TabIndex        =   7
      Top             =   945
      Width           =   1455
   End
   Begin VB.Label Label1 
      Caption         =   "Tablas"
      Height          =   240
      Index           =   0
      Left            =   180
      TabIndex        =   6
      Top             =   360
      Width           =   1455
   End
End
Attribute VB_Name = "FrmScriptor"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub CmdAgregar_Click()
  If Trim(TxSqlstmt) = "" Then
    TxSqlstmt = "select * from " & CbTablas
  Else
    TxSqlstmt = TxSqlstmt & vbCrLf & "/n" & vbCrLf & "select * from " & CbTablas
  End If
End Sub

Private Sub CmdBuscar_Click()
  CDialog.Filter = "Todos los archivos_ (*.*) |*.*| Archivos SQL (*.sql) |*.sql|"
  CDialog.FilterIndex = 2
  CDialog.ShowSave
  TxFile.Text = CDialog.FileName
End Sub

Private Sub CmdGenerar_Click()
  On Error GoTo ControlError
  
  Dim vSelects() As String
  
  Screen.MousePointer = vbHourglass
  
  DoEvents: DoEvents: DoEvents
  
  If Trim(TxSqlstmt) = "" Then CmdSentenciaBasica_Click
  
  GetSelects vSelects
  
  Dim i As Integer
  Dim o As Integer
  
  Dim sqlstmt As String
  Dim rs As CSDataBaseClient.cRegistros
  
  If Trim(TxFile) = "" Then TxFile = "c:\script.sql"

  Dim lFile As Integer
  
  If Not ChkArchivoXTabla Then
  
    lFile = FreeFile
  
    If Dir(TxFile) <> "" And ChkCrearFile.Value = vbChecked Then Kill TxFile
  
    Open TxFile For Append Access Write Lock Write As lFile
  End If
  
  Dim sTabla As String
  
  For o = 1 To UBound(vSelects)
  
    sTabla = GetTableNameFromSelect(vSelects(o))
  
    If ChkArchivoXTabla Then
      
      Dim sFile As String
      
      sFile = sTabla & ".sql"
      
      lFile = FreeFile
    
      If Dir(sFile) <> "" Then Kill TxFile
    
      Open sFile For Append Access Write Lock Write As lFile
    End If
  
    sqlstmt = vSelects(o)
    If Not gDb.OpenRs(sqlstmt, rs) Then GoTo ExitProc
    
    sqlstmt = "INSERT INTO " & sTabla & " ("
    

    For i = 0 To rs.Campos.Cantidad - 1
      sqlstmt = sqlstmt & rs.Campos(i).Nombre & ","
    Next
    
    sqlstmt = Left(sqlstmt, Len(sqlstmt) - 1)
    
    sqlstmt = sqlstmt & ")VALUES ("
    
    Dim valores As String
    
    Dim q As Integer
    
    While Not rs.EOF
    
      valores = ""
      For i = 0 To rs.Campos.Cantidad - 1
      
        If ChkSinEspacios Then
          If IsNull(rs.Campos(i).Valor) Then
            valores = valores & "NULL,"
          Else
            Select Case rs.Campos(i).Tipo
            
              Case DataTypeEnum.adTinyInt, DataTypeEnum.adBigInt, DataTypeEnum.adCurrency, DataTypeEnum.adDecimal, DataTypeEnum.adDouble, DataTypeEnum.adInteger, DataTypeEnum.adNumeric, DataTypeEnum.adSingle, DataTypeEnum.adSmallInt, DataTypeEnum.adTinyInt, DataTypeEnum.adUnsignedBigInt, DataTypeEnum.adUnsignedInt, DataTypeEnum.adUnsignedSmallInt, DataTypeEnum.adUnsignedTinyInt, DataTypeEnum.adVarNumeric
                If InStr(1, rs.Campos(i).Nombre, "_ID_", vbTextCompare) > 0 Or Right(rs.Campos(i).Nombre, 3) = "_ID" Then
                  valores = valores & Val(rs.Campos(i).Valor) * 1000 & ","
                Else
                  valores = valores & rs.Campos(i).Valor & ","
                End If
              Case DataTypeEnum.adBoolean
                valores = valores & Val(rs.Campos(i).Valor) & ","
              Case DataTypeEnum.adChar, DataTypeEnum.adVarChar, adLongVarChar
                valores = valores & "'" & Replace(rs.Campos(i).Valor, "'", "''") & "',"
              Case DataTypeEnum.adDate, DataTypeEnum.adDBDate, DataTypeEnum.adDBFileTime, DataTypeEnum.adDBTime, DataTypeEnum.adDBTimeStamp
                valores = valores & "'" & Format(rs.Campos(i).Valor, "yyyymmdd hh:nn:ss") & "',"
              Case Else
                Stop
            End Select
          End If
        
        Else
          If IsNull(rs.Campos(i).Valor) Then
          
            Select Case rs.Campos(i).Tipo
            
              Case DataTypeEnum.adTinyInt, DataTypeEnum.adBigInt, DataTypeEnum.adCurrency, DataTypeEnum.adDecimal, DataTypeEnum.adDouble, DataTypeEnum.adInteger, DataTypeEnum.adNumeric, DataTypeEnum.adSingle, DataTypeEnum.adSmallInt, DataTypeEnum.adTinyInt, DataTypeEnum.adUnsignedBigInt, DataTypeEnum.adUnsignedInt, DataTypeEnum.adUnsignedSmallInt, DataTypeEnum.adUnsignedTinyInt, DataTypeEnum.adVarNumeric
                valores = valores & Left("NULL" & "                    ", 20) & ","
              Case DataTypeEnum.adBoolean
                valores = valores & Left("NULL" & "                    ", 20) & ","
              Case DataTypeEnum.adChar, DataTypeEnum.adVarChar, adLongVarChar
                valores = valores & Left("NULL " & String(rs.Campos(i).Longitud, " "), rs.Campos(i).Longitud + 1) & ","
              Case DataTypeEnum.adDate, DataTypeEnum.adDBDate, DataTypeEnum.adDBFileTime, DataTypeEnum.adDBTime, DataTypeEnum.adDBTimeStamp
                valores = valores & "NULL             ,"
            End Select
          Else
            Select Case rs.Campos(i).Tipo
            
              Case DataTypeEnum.adTinyInt, DataTypeEnum.adBigInt, DataTypeEnum.adCurrency, DataTypeEnum.adDecimal, DataTypeEnum.adDouble, DataTypeEnum.adInteger, DataTypeEnum.adNumeric, DataTypeEnum.adSingle, DataTypeEnum.adSmallInt, DataTypeEnum.adTinyInt, DataTypeEnum.adUnsignedBigInt, DataTypeEnum.adUnsignedInt, DataTypeEnum.adUnsignedSmallInt, DataTypeEnum.adUnsignedTinyInt, DataTypeEnum.adVarNumeric
                valores = valores & Left(rs.Campos(i).Valor & "                    ", 20) & ","
              Case DataTypeEnum.adBoolean
                valores = valores & Left(Val(rs.Campos(i).Valor) & "                    ", 20) & ","
              Case DataTypeEnum.adChar, DataTypeEnum.adVarChar, adLongVarChar
                If rs.Campos(i).Longitud < 201 Then
                  valores = valores & "'" & Left(Replace(rs.Campos(i).Valor, "'", "''") & "'" & String(rs.Campos(i).Longitud, " "), rs.Campos(i).Longitud) & ","
                Else
                  valores = valores & "'" & Left(Replace(rs.Campos(i).Valor, "'", "''") & "'" & String(200, " "), 200) & ","
                End If
                
              Case DataTypeEnum.adDate, DataTypeEnum.adDBDate, DataTypeEnum.adDBFileTime, DataTypeEnum.adDBTime, DataTypeEnum.adDBTimeStamp
                valores = valores & "'" & Format(rs.Campos(i).Valor, "yyyymmdd hh:nn:ss") & "',"
            End Select
          End If
        End If
      Next
    
      valores = Left(valores, Len(valores) - 1)
      Print #lFile, sqlstmt & valores & ")"
    
      rs.Siguiente
      q = q + 1
      If q = 10 Then
        Print #lFile, "GO"
        q = 0
      End If
    Wend
  
    If ChkArchivoXTabla Then
      Close lFile
    Else
      Print #lFile, ""
    End If
  
  Next
  
  GoTo ExitProc
ControlError:
  MngError Err, "CmdGenerar_Click", "FrmScriptor", ""
  Resume ExitProc
ExitProc:
  On Error Resume Next
  Close lFile
  Screen.MousePointer = vbDefault
End Sub

Private Sub CmdSentenciaBasica_Click()
  TxSqlstmt = "select * from " & CbTablas
End Sub

Private Sub cmdTodos_Click()
  Dim i As Integer
  TxSqlstmt.Text = ""
  For i = 0 To CbTablas.ListCount - 1
    CbTablas.ListIndex = i
    DoEvents
    CmdAgregar_Click
  Next
End Sub

Private Sub Form_Load()
  Dim sqlstmt As String
  Dim rs As CSDataBaseClient.cRegistros
  
  TxFile = "c:\WINDOWS\ESCRITORIO\script.sql"
  
  sqlstmt = "sp_tables"
  
  If Not gDb.OpenRs(sqlstmt, rs) Then Exit Sub
  
  While Not rs.EOF
  
    If gDb.ValField(rs("TABLE_TYPE")) = "TABLE" Then
  
      CbTablas.AddItem gDb.ValField(rs("TABLE_NAME"))
    End If
  
    rs.Siguiente
  Wend
End Sub

Private Sub GetSelects(ByRef vSelects() As String)
  Dim PosIni As Integer
  Dim PosFin As Integer
  Dim q      As Integer
  
  PosIni = 1
  
  Do
    q = q + 1
    ReDim Preserve vSelects(q)
    
    PosFin = InStr(PosIni, TxSqlstmt, "/n", vbTextCompare)
    
    If PosFin = 0 Then
      vSelects(q) = Mid(TxSqlstmt, PosIni)
    Else
      vSelects(q) = Mid(TxSqlstmt, PosIni, PosFin - PosIni)
    End If
    
    PosIni = PosFin + 2
    
  Loop Until PosFin = 0
End Sub

Private Function GetTableNameFromSelect(ByVal sqlstmt As String) As String
  Dim PosIni As String
  Dim PosFin As String
  Dim c      As String
  Dim EmpesoLaTabla As Boolean
  Dim q      As Integer
  
  
  PosIni = InStr(1, sqlstmt, "from", vbTextCompare)
  
  If PosIni = 0 Then Err.Raise 9, "GetTableNameFromSelect", "Sentencia sql invalida."
  
  PosFin = PosIni + 4
  Do
    PosFin = PosFin + 1
    
    c = Mid(sqlstmt, PosFin, 1)
    
    If c <> " " Then EmpesoLaTabla = True
    
    If c = " " And EmpesoLaTabla Then Exit Do
    
    If PosFin > Len(sqlstmt) Then Exit Do
    
    If Asc(c) = 13 And EmpesoLaTabla Then Exit Do
    
    q = q + 1
    
    If q > 150 Then Err.Raise 9, "GetTableNameFromSelect", "Error interno, se dieron 150 vueltas y no se encontro el nombre de la tabla."
  Loop
  
  GetTableNameFromSelect = Trim(Replace(Replace(Mid(sqlstmt, PosIni + 5, PosFin - PosIni - 5), Chr(13), ""), Chr(10), ""))
End Function

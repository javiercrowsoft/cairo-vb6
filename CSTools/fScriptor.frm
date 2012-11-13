VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Begin VB.Form fScriptor 
   Caption         =   "Generar Script"
   ClientHeight    =   4755
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   8940
   Icon            =   "fScriptor.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   4755
   ScaleWidth      =   8940
   StartUpPosition =   3  'Windows Default
   Begin VB.CheckBox chkIsLenguaje 
      Alignment       =   1  'Right Justify
      Caption         =   "Es un script de lenguaje"
      Height          =   195
      Left            =   4500
      TabIndex        =   18
      Top             =   3420
      Width           =   2085
   End
   Begin VB.CommandButton cmdView 
      Caption         =   "Ver"
      Height          =   375
      Left            =   7200
      TabIndex        =   17
      Top             =   4185
      Width           =   1545
   End
   Begin VB.TextBox txOffset 
      Alignment       =   1  'Right Justify
      Height          =   330
      Left            =   1710
      TabIndex        =   15
      Text            =   "1"
      Top             =   3285
      Width           =   1320
   End
   Begin VB.CheckBox chkUpdates 
      Alignment       =   1  'Right Justify
      Caption         =   "Generar updates"
      Height          =   195
      Left            =   7065
      TabIndex        =   14
      Top             =   3735
      Value           =   1  'Checked
      Width           =   1500
   End
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
      Top             =   2835
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.CheckBox ChkSinEspacios 
      Alignment       =   1  'Right Justify
      Caption         =   "No rellenar con espacios"
      Height          =   195
      Left            =   4500
      TabIndex        =   12
      Top             =   3735
      Value           =   1  'Checked
      Width           =   2085
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
      Left            =   2295
      TabIndex        =   10
      Top             =   3735
      Width           =   1770
   End
   Begin VB.CheckBox ChkCrearFile 
      Alignment       =   1  'Right Justify
      Caption         =   "Archivo Nuevo"
      Height          =   195
      Left            =   180
      TabIndex        =   9
      Top             =   3735
      Value           =   1  'Checked
      Width           =   1725
   End
   Begin VB.CommandButton CmdBuscar 
      Caption         =   "Buscar"
      Height          =   375
      Left            =   5805
      TabIndex        =   5
      Top             =   2925
      Width           =   1455
   End
   Begin VB.TextBox TxFile 
      Height          =   330
      Left            =   1710
      TabIndex        =   4
      Top             =   2880
      Width           =   3840
   End
   Begin VB.CommandButton CmdGenerar 
      Caption         =   "Generar"
      Height          =   375
      Left            =   5535
      TabIndex        =   3
      Top             =   4185
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
   Begin VB.Label Label1 
      Caption         =   "Archivo"
      Height          =   240
      Index           =   3
      Left            =   180
      TabIndex        =   16
      Top             =   3330
      Width           =   1455
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
      Top             =   2925
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
Attribute VB_Name = "fScriptor"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' fScriptor
' 00-11-2002

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    Private Const SW_SHOWNORMAL = 1
    Private Const ERROR_PATH_NOT_FOUND = 3&
    Private Const ERROR_BAD_FORMAT = 11&
    Private Const SE_ERR_ACCESSDENIED = 5            '  access denied
    Private Const SE_ERR_ASSOCINCOMPLETE = 27
    Private Const SE_ERR_DDEBUSY = 30
    Private Const SE_ERR_DDEFAIL = 29
    Private Const SE_ERR_DDETIMEOUT = 28
    Private Const SE_ERR_DLLNOTFOUND = 32
    Private Const SE_ERR_FNF = 2                     '  file not found
    Private Const SE_ERR_NOASSOC = 31
    Private Const SE_ERR_OOM = 8                     '  out of memory
    Private Const SE_ERR_PNF = 3                     '  path not found
    Private Const SE_ERR_SHARE = 26
    
    ' estructuras
    ' funciones
    Private Declare Function ShellExecute Lib "shell32.dll" Alias "ShellExecuteA" (ByVal hwnd As Long, ByVal lpOperation As String, ByVal lpFile As String, ByVal lpParameters As String, ByVal lpDirectory As String, ByVal nShowCmd As Long) As Long

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "fScriptor"
' estructuras
' variables privadas
' eventos
' propiedadades publicas
Private m_db         As cDataSource
' propiedadades friend
' propiedades privadas
' funciones publicas
Public Function Script(ByVal Server As String, ByVal Database As String, ByVal User As String, ByVal Password As String, ByVal NTSecurity As Boolean)
  Dim sqlstmt As String
  Dim rs As Recordset
  
  If Not m_db.OpenConnection(Server, Database, User, Password, NTSecurity) Then Exit Function
  
  txFile = "c:\WINDOWS\ESCRITORIO\script.sql"
  
  sqlstmt = "sp_tables"
  
  If Not m_db.OpenRs(rs, sqlstmt) Then Exit Function
  
  While Not rs.EOF
  
    If m_db.ValField(rs("TABLE_TYPE")) = "TABLE" Then
  
      CbTablas.AddItem m_db.ValField(rs("TABLE_NAME"))
    End If
  
    rs.MoveNext
  Wend
  
  Me.Show vbModal
End Function
' funciones friend
' funciones privadas
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
  txFile.Text = CDialog.FileName
End Sub

Private Sub CmdGenerar_Click()
  On Error GoTo ControlError
  
  Dim vSelects() As String
  Dim bProcess   As Boolean
  
  Screen.MousePointer = vbHourglass
  
  DoEvents: DoEvents: DoEvents
  
  If Trim(TxSqlstmt) = "" Then CmdSentenciaBasica_Click
  
  GetSelects vSelects
  
  Dim i As Integer
  Dim o As Integer
  
  Dim sqlstmt As String
  Dim sqlstmtExists As String
  Dim sqlstmtExistsAux As String
  Dim sqlstmtUpdate As String
  Dim sqlstmtUpdateWhere As String
  Dim FieldKey  As String
  
  Dim rs As Recordset
  
  If Trim(txFile) = "" Then txFile = "c:\script.sql"

  Dim lFile As Integer
  
  If Not ChkArchivoXTabla Then
  
    lFile = FreeFile
  
    If Dir(txFile) <> "" And ChkCrearFile.Value = vbChecked Then Kill txFile
  
    Open txFile For Append Access Write Lock Write As lFile
    
    If chkIsLenguaje.Value = vbChecked Then
      Print #lFile, "declare @lengi_id int" & vbCrLf
    End If
    
  End If
  
  Dim sTabla As String
  Dim lengi_codigo As String
  
  For o = 1 To UBound(vSelects)
  
    sTabla = GetTableNameFromSelect(vSelects(o))
  
    If ChkArchivoXTabla Then
      
      Dim sFile As String
      
      sFile = sTabla & ".sql"
      
      lFile = FreeFile
    
      If Dir(sFile) <> "" Then Kill txFile
    
      Open sFile For Append Access Write Lock Write As lFile
      
      If chkIsLenguaje.Value = vbChecked Then
        Print #lFile, "declare @lengi_id int" & vbCrLf
      End If
      
    End If
  
    sqlstmt = vSelects(o)
    If Not m_db.OpenRs(rs, sqlstmt) Then GoTo ExitProc
    
    If chkIsLenguaje.Value = vbChecked Then
      sqlstmt = "exec sp_dbgetnewid 'LenguajeItem','lengi_id',@lengi_id out, 0" & vbCrLf
      sqlstmt = sqlstmt & vbCrLf
      sqlstmt = sqlstmt & "INSERT INTO " & sTabla & " ("
    Else
      sqlstmt = "INSERT INTO " & sTabla & " ("
    End If

    For i = 0 To rs.Fields.Count - 1
      sqlstmt = sqlstmt & rs.Fields(i).Name & ","
    Next
    
    sqlstmt = Left(sqlstmt, Len(sqlstmt) - 1)
    
    sqlstmt = sqlstmt & ") VALUES ("
    
    If chkUpdates.Value = vbChecked Then
      sqlstmtExistsAux = pGetSqlstmtExists(sTabla, FieldKey)
    End If
    
    Dim valores As String
    
    Dim q As Integer
    
    While Not rs.EOF
    
      valores = ""
      sqlstmtUpdate = ""
      
      For i = 0 To rs.Fields.Count - 1
      
        If chkIsLenguaje.Value = vbChecked Then
          
          If LCase(rs.Fields(i).Name) = "lengi_codigo" Then
            
            sqlstmtExists = "select * from lenguajeitem where lengi_codigo = '" & rs.Fields(i).Value & "' and leng_id = " & rs.Fields("leng_id").Value
            sqlstmtUpdateWhere = " lengi_codigo = '" & rs.Fields(i).Value & "' and leng_id = " & rs.Fields("leng_id").Value
          
          End If
        
        Else
      
          If LCase(rs.Fields(i).Name) = FieldKey Then
            sqlstmtUpdateWhere = FieldKey & " = " & rs.Fields(i).Value
            sqlstmtExists = sqlstmtExistsAux & rs.Fields(i).Value
          End If
        End If
        
        If ChkSinEspacios.Value = vbChecked Then
          
          If chkIsLenguaje.Value = vbChecked Then
            
            If LCase(rs.Fields(i).Name) = FieldKey Then
            
              bProcess = False
              valores = valores & "@lengi_id,"
            
            Else
              bProcess = True
            End If
          
          Else
            bProcess = True
          End If
          
          If bProcess Then
          
            If IsNull(rs.Fields(i).Value) Then
              valores = valores & "NULL,"
              sqlstmtUpdate = sqlstmtUpdate & rs.Fields(i).Name & "= null,"
            Else
              Select Case rs.Fields(i).Type
              
                Case DataTypeEnum.adTinyInt, DataTypeEnum.adBigInt, DataTypeEnum.adCurrency, DataTypeEnum.adDecimal, DataTypeEnum.adDouble, DataTypeEnum.adInteger, DataTypeEnum.adNumeric, DataTypeEnum.adSingle, DataTypeEnum.adSmallInt, DataTypeEnum.adTinyInt, DataTypeEnum.adUnsignedBigInt, DataTypeEnum.adUnsignedInt, DataTypeEnum.adUnsignedSmallInt, DataTypeEnum.adUnsignedTinyInt, DataTypeEnum.adVarNumeric
                  If InStr(1, rs.Fields(i).Name, "_ID_", vbTextCompare) > 0 Or Right(rs.Fields(i).Name, 3) = "_ID" Then
                    valores = valores & Val(rs.Fields(i).Value) * Val(txOffset.Text) & ","
                    sqlstmtUpdate = sqlstmtUpdate & rs.Fields(i).Name & "= " & Val(rs.Fields(i).Value) * Val(txOffset.Text) & ","
                  Else
                    valores = valores & rs.Fields(i).Value & ","
                    sqlstmtUpdate = sqlstmtUpdate & rs.Fields(i).Name & "= " & rs.Fields(i).Value & ","
                  End If
                Case DataTypeEnum.adBoolean
                  valores = valores & Val(rs.Fields(i).Value) & ","
                  sqlstmtUpdate = sqlstmtUpdate & rs.Fields(i).Name & "= " & Val(rs.Fields(i).Value) & ","
                Case DataTypeEnum.adChar, DataTypeEnum.adVarChar, adLongVarChar, adVarWChar
                  valores = valores & "'" & Replace(rs.Fields(i).Value, "'", "''") & "',"
                  sqlstmtUpdate = sqlstmtUpdate & rs.Fields(i).Name & "= '" & Replace(rs.Fields(i).Value, "'", "''") & "',"
                Case DataTypeEnum.adDate, DataTypeEnum.adDBDate, DataTypeEnum.adDBTimeStamp, DataTypeEnum.adDBTime, DataTypeEnum.adDBTimeStamp
                  valores = valores & "'" & Format(rs.Fields(i).Value, "yyyymmdd hh:nn:ss") & "',"
                  sqlstmtUpdate = sqlstmtUpdate & rs.Fields(i).Name & "= '" & Format(rs.Fields(i).Value, "yyyymmdd hh:nn:ss") & "',"
                Case Else
                  Debug.Assert 1 = 2
              End Select
            End If
          End If
          
        Else
          If IsNull(rs.Fields(i).Value) Then
          
            sqlstmtUpdate = sqlstmtUpdate & rs.Fields(i).Name & "= null," & vbCrLf
            
            Select Case rs.Fields(i).Type
            
              Case DataTypeEnum.adTinyInt, DataTypeEnum.adBigInt, DataTypeEnum.adCurrency, DataTypeEnum.adDecimal, DataTypeEnum.adDouble, DataTypeEnum.adInteger, DataTypeEnum.adNumeric, DataTypeEnum.adSingle, DataTypeEnum.adSmallInt, DataTypeEnum.adTinyInt, DataTypeEnum.adUnsignedBigInt, DataTypeEnum.adUnsignedInt, DataTypeEnum.adUnsignedSmallInt, DataTypeEnum.adUnsignedTinyInt, DataTypeEnum.adVarNumeric
                valores = valores & Left("NULL" & "                    ", 20) & ","
              Case DataTypeEnum.adBoolean
                valores = valores & Left("NULL" & "                    ", 20) & ","
              Case DataTypeEnum.adChar, DataTypeEnum.adVarChar, adLongVarChar
                valores = valores & Left("NULL " & String(rs.Fields(i).DefinedSize, " "), rs.Fields(i).DefinedSize + 1) & ","
              Case DataTypeEnum.adDate, DataTypeEnum.adDBDate, DataTypeEnum.adDBTimeStamp, DataTypeEnum.adDBTime, DataTypeEnum.adDBTimeStamp
                valores = valores & "NULL             ,"
            End Select
          Else
            Select Case rs.Fields(i).Type
            
              Case DataTypeEnum.adTinyInt, DataTypeEnum.adBigInt, DataTypeEnum.adCurrency, DataTypeEnum.adDecimal, DataTypeEnum.adDouble, DataTypeEnum.adInteger, DataTypeEnum.adNumeric, DataTypeEnum.adSingle, DataTypeEnum.adSmallInt, DataTypeEnum.adTinyInt, DataTypeEnum.adUnsignedBigInt, DataTypeEnum.adUnsignedInt, DataTypeEnum.adUnsignedSmallInt, DataTypeEnum.adUnsignedTinyInt, DataTypeEnum.adVarNumeric
                valores = valores & Left(rs.Fields(i).Value & "                    ", 20) & ","
                sqlstmtUpdate = sqlstmtUpdate & rs.Fields(i).Name & "= " & rs.Fields(i).Value & "," & vbCrLf
              
              Case DataTypeEnum.adBoolean
                valores = valores & Left(Val(rs.Fields(i).Value) & "                    ", 20) & ","
                sqlstmtUpdate = sqlstmtUpdate & rs.Fields(i).Name & "= " & Val(rs.Fields(i).Value) & "," & vbCrLf
                
              Case DataTypeEnum.adChar, DataTypeEnum.adVarChar, adLongVarChar
                sqlstmtUpdate = sqlstmtUpdate & rs.Fields(i).Name & "= " & "'" & Replace(rs.Fields(i).Value, "'", "''") & "'," & vbCrLf
                
                If rs.Fields(i).DefinedSize < 201 Then
                  valores = valores & "'" & Left(Replace(rs.Fields(i).Value, "'", "''") & "'" & String(rs.Fields(i).DefinedSize, " "), rs.Fields(i).DefinedSize) & ","
                Else
                  valores = valores & "'" & Left(Replace(rs.Fields(i).Value, "'", "''") & "'" & String(200, " "), 200) & ","
                End If
                
              Case DataTypeEnum.adDate, DataTypeEnum.adDBDate, DataTypeEnum.adDBTimeStamp, DataTypeEnum.adDBTime, DataTypeEnum.adDBTimeStamp
                valores = valores & "'" & Format(rs.Fields(i).Value, "yyyymmdd hh:nn:ss") & "',"
                sqlstmtUpdate = sqlstmtUpdate & rs.Fields(i).Name & "= " & "'" & Format(rs.Fields(i).Value, "yyyymmdd hh:nn:ss") & "'," & vbCrLf
            End Select
          End If
        End If
      Next
      
      If ChkSinEspacios.Value = vbChecked Then
        sqlstmtUpdate = Left(sqlstmtUpdate, Len(sqlstmtUpdate) - 1)
      Else
        sqlstmtUpdate = Left(sqlstmtUpdate, Len(sqlstmtUpdate) - 2)
      End If
      
      valores = Left(valores, Len(valores) - 1)
      
      
      If chkUpdates.Value = vbChecked Then
        Print #lFile, "if exists(" & sqlstmtExists & ") begin"
        Print #lFile, "update " & sTabla & " set " & sqlstmtUpdate & " where " & sqlstmtUpdateWhere
        Print #lFile, "end else begin "
      End If
      
      Print #lFile, sqlstmt & valores & ")"
      
      If chkUpdates.Value = vbChecked Then
        Print #lFile, "end"
      End If
      
    
      rs.MoveNext
      q = q + 1
      If q = 10 Then
      
        Print #lFile, "GO"
        
        If chkIsLenguaje.Value = vbChecked Then
          Print #lFile, "declare @lengi_id int" & vbCrLf
        End If
        
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

Private Sub cmdView_Click()
  EditFile txFile.Text, Me.hwnd
End Sub

Private Sub Form_Load()
  Set m_db = New cDataSource
End Sub

Private Sub Form_Unload(Cancel As Integer)
  Set m_db = Nothing
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

Private Function pGetSqlstmtExists(ByVal Table As String, ByRef FieldKey As String) As String
  Dim rs As Recordset
  Dim sqlstmt As String
  
  sqlstmt = "sp_pkeys " & Table
  
  If Not m_db.OpenRs(rs, sqlstmt) Then Exit Function
  
  If rs.EOF Then
    FieldKey = InputBox("Indique el nombre del PK para esta tabla")
  Else
    FieldKey = rs.Fields(3).Value
  End If
  
  pGetSqlstmtExists = "select * from " & Table & " where " & FieldKey & " = "
End Function

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
  
  GetTableNameFromSelect = Trim(Replace(Replace(Mid(sqlstmt, PosIni + 5, PosFin - PosIni - 5), chr(13), ""), chr(10), ""))
End Function

Private Sub txOffset_Change()
  If Val(txOffset.Text) < 1 Then txOffset.Text = 1
End Sub

Private Sub EditFile(ByVal sArchivo As String, ByVal hwnd As Long)
  Dim Hresult As Long
  
  
  Hresult = ShellExecute(hwnd, "open", sArchivo + chr(0), 0, sArchivo + chr(0), SW_SHOWNORMAL)
  
  Select Case Hresult
    Case ERROR_PATH_NOT_FOUND '= 3&
        MsgBox "La ruta de acceso no se encuentra"
    Case ERROR_BAD_FORMAT '= 11&
        MsgBox "Formato no reconocido"
    Case SE_ERR_ACCESSDENIED '= 5 '  access denied
        MsgBox "Error a intentar acceder al archivo. Acceso Denegado."
    Case SE_ERR_ASSOCINCOMPLETE '= 27
        MsgBox "Acceso Incompleto"
    Case SE_ERR_DDEBUSY '= 30
        
    Case SE_ERR_DDEFAIL '= 29
        MsgBox "Falla al intentar editar el archivo"
    Case SE_ERR_DDETIMEOUT '= 28
        
    Case SE_ERR_DLLNOTFOUND '= 32
        MsgBox "El archivo no se encuentra"
    Case SE_ERR_FNF '= 2                     '  file not found
        MsgBox "Archivo no encontrado"
    Case SE_ERR_NOASSOC '= 31
    Case SE_ERR_OOM '= 8                     '  out of memory
        MsgBox "Error de Memoria "
    Case SE_ERR_PNF '= 3                     '  path not found
        MsgBox "La ruta de acceso no se encuentra"
    Case SE_ERR_SHARE '= 26
        
  End Select
End Sub

' construccion - destruccion

'//////////////////////////////
'  Codigo estandar de errores
'  On Error GoTo ControlError
'
'  GoTo ExitProc
'ControlError:
'  MngError err,"", C_Module, ""
'  If Err.Number <> 0 Then Resume ExitProc
'ExitProc:
'  On Error Resume Next


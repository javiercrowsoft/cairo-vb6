VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cImportWork"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
'--------------------------------------------------------------------------------
' cImportacion
' 14-02-04

'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cImportacion"

Private Const c_Origen = "Origen"

Public Enum csLogSeverity
  LogSevInformation = 1
  LogSevWarnning = 2
  LogSevError = 3
End Enum

' Campos
Private Const K_NOMBRE      As Integer = 1
Private Const K_CODIGO      As Integer = 2
Private Const K_ACTIVO      As Integer = 3
Private Const K_ITEMS       As Integer = 4

Private Const KI_IMPI_ID                        As Integer = 2
Private Const KI_CAMPOORIGEN                    As Integer = 3
Private Const KI_CAMPODESTINO                   As Integer = 4
Private Const KI_DEFAULT                        As Integer = 5

' estructuras
Private Type T_Defaults
  ColDestino As String
  Default    As String
End Type

Private Type T_FKeysInfo
  TblName         As String
  ColNameId       As String
  ColNameCodigo   As String
  ColFk           As String
End Type

Private Type T_Mapeo
  Destino         As String
  Origen          As String
End Type

' Seudo - Variables
Private c_ErrorSave                   As String

' variables privadas
Private m_Id                           As Long
Private m_OrigenTabla                  As String
Private m_OrigenPath                   As String
Private m_Sqlstmt                      As String
Private m_DestinoTabla                 As String
Private m_DestinoTblId                 As Long
Private m_Nombre                       As String
Private m_Descrip                      As String
Private m_Creado                       As Date
Private m_Modificado                   As Date
Private m_Modifico                     As Long

Private m_bCancel                      As Boolean

Private m_Property                     As cABMProperty

Private m_impp_id                      As Long

' Eventos
Public Event Progress(ByVal Value As Integer, ByRef Cancel As Boolean)

Public Property Let impp_id(ByVal rhs As Long)
  m_impp_id = rhs
End Property

Public Property Let sqlstmt(ByRef rhs As String)
  m_Sqlstmt = rhs
End Property

' Wizard
Public Function Work() As Boolean
  On Error GoTo ControlError

  m_bCancel = False
  Work = pWizardProcess()
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIWizardClient_Work", C_Module, vbNullString
  pSaveLogToDb LastErrorDescription, LogSevError, m_impp_id, C_Module
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pGetTblId() As Long
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  sqlstmt = "select tbl_id from tabla where tbl_nombrefisico = '" & m_DestinoTabla & "'"
  
  If Not gDB.OpenRs(sqlstmt, rs) Then
    pSaveLogToDb LastErrorDescription, LogSevError, m_impp_id, C_Module
    Exit Function
  End If
  
  If rs.EOF Then
    pSaveLogToDb LNGGetText(3345, vbNullString), LogSevError, m_impp_id, C_Module
                'No se pudo obtener el ID de la tabla destino
    Exit Function
  End If
  pGetTblId = rs.Fields(0)
End Function

Private Function pWizardProcess() As Boolean
  On Error GoTo ControlError

  Dim i    As Long
  Dim msg  As String
  Dim iProperties       As cIABMProperties
  Dim bError            As Boolean
  
  Dim Mouse As cMouse
  Set Mouse = New cMouse
  Mouse.MouseSet vbHourglass

  Dim rs As ADODB.Recordset
  Dim RowId As Long
  Dim ColCodigo  As String
  Dim ColDestino As String
  Dim ColType    As csTypes
  Dim ColId     As String
  Dim TblName   As String
  Dim ColCodigoOrigen As String
  Dim sqlstmt         As String
  Dim register        As cRegister
  Dim fld             As ADODB.Field
  Dim CollColType     As Collection
  Dim vMapeos()       As T_Mapeo
  Dim vDefaults()     As T_Defaults
  Dim Value           As Variant
  Dim vFkeysInfo()    As T_FKeysInfo
  Dim IndexCol        As Long
  Dim startTime       As Date
  Dim NextIndex       As Long
  Dim bHaveLastUpdate As Boolean
  Dim bHaveWhoModify  As Boolean
  Dim Codigo          As String
  
  Dim nOk             As Long
  Dim nFail           As Long
  Dim nWarning        As Long
  
  startTime = Now
  pShowProcessTime startTime, iProperties
  pShowProgressBar 0, False
  
  pShowCount 0
  pShowCurrent 0
  
  pProcessLogSep
  pProcessLog LNGGetText(3291, vbNullString), LogSevInformation
              'Obteniendo datos
  pLoadMapeoItem
  
  pGetColCodigo ColCodigo, ColCodigoOrigen
  If ColCodigoOrigen = "" Then
    MsgWarning LNGGetText(3292, vbNullString)
              'Indique la columna en el origen que corresponde al campo codigo
    GoTo ExitProc
  End If
  
  Set rs = pGetRecordsetOrigen()

  pShowProcessTime startTime, iProperties
  
  If Not (rs.EOF And rs.BOF) Then rs.MoveFirst
  
  pGetColId ColId, TblName
    
  sqlstmt = "select " & ColId & " from " & TblName & " where " & ColCodigo & " = "
    
  pGetModifyAndUpdate bHaveLastUpdate, bHaveWhoModify, TblName
    
  Set CollColType = pGetColType(TblName)
  pGetColDestino vMapeos
  pGetDefaults vDefaults
  pGetFkeysInfo vFkeysInfo, TblName
  
  pShowCount pGetRecordCount(rs)

  pProcessLog LNGGetText(3293, vbNullString), LogSevInformation
              'Importando registros
  While Not rs.EOF
  
    pShowProcessTime startTime, iProperties
  
    If pUserCancel() Then GoTo ExitProc
    
    RowId = pGetRowId(ColCodigoOrigen, sqlstmt, rs)
    
    Set register = New cRegister
    register.fieldId = ColId
    register.Table = TblName

    register.ID = RowId
    
    For Each fld In rs.Fields
      NextIndex = 1
      While pColSelected(vMapeos, fld.Name, NextIndex)
        ColDestino = vMapeos(NextIndex).Destino
        ColType = CollColType(ColDestino)
        
        Value = pGetValue(gDB.ValField(rs.Fields, fld.Name), ColType)
        If pIsFkCol(ColDestino, vFkeysInfo, IndexCol) Then
          Value = pGetFkValue(ColDestino, gDB.ValField(rs.Fields, fld.Name), vFkeysInfo(IndexCol))
          ColType = csId
        End If
          
        register.Fields.Add2 ColDestino, Value, ColType
        NextIndex = NextIndex + 1
      Wend
    Next
    
    For i = 1 To UBound(vDefaults)
      With vDefaults(i)
        ColType = CollColType(.ColDestino)
        
        Value = pGetValue(.Default, ColType)
        If pIsFkCol(.ColDestino, vFkeysInfo, IndexCol) Then
          Value = pGetFkValue(.ColDestino, .Default, vFkeysInfo(IndexCol))
        End If
        register.Fields.Add2 .ColDestino, Value, ColType
      End With
    Next
    
    register.Fields.HaveLastUpdate = bHaveLastUpdate
    register.Fields.HaveWhoModify = bHaveWhoModify
    
    If Not gDB.Save(register, , "pWizardProcess", C_Module, c_ErrorSave) Then
    
      '========================================================
      ' Cuando es desatendido no pregunto, sigo con el siguiente
      ' hasta terminar el proceso
      '
      #If Not PREPROC_UNATTENDED Then
        If Ask(LNGGetText(3296, vbNullString), vbYes) Then
                'Desea continuar con la importación
          nFail = nFail + 1
        Else
          bError = True
          GoTo EndProcess
        End If
      #Else
        Codigo = vbCrLf & LNGGetText(3346, vbNullString) & rs.Fields(ColCodigoOrigen).Value
                          'Código del registro:
        pSaveLogToDb LastErrorDescription & Codigo, LogSevError, m_impp_id, C_Module
        nFail = nFail + 1
      #End If
      '========================================================
    Else
      nOk = nOk + 1
    End If
    
    pShowCurrent rs.AbsolutePosition
    pShowProgressBar pGetProgress(rs), m_bCancel
    DoEvents
    
    rs.MoveNext
  Wend

EndProcess:

  pProcessLog LNGGetText(3297, vbNullString, pShowProcessTime(startTime, iProperties)), LogSevInformation
              'El proceso demoro (1)
  If nOk > 0 Then pProcessLog LNGGetText(3298, vbNullString, nOk), LogSevInformation
                              'Se importaron  & nOk &  registros
  If nFail > 0 Then
    If nFail = 1 Then
      pProcessLog LNGGetText(3347, vbNullString), LogSevInformation
                  'Hubo un registro que dió error y no se importó
    Else
      pProcessLog LNGGetText(3299, vbNullString, nFail), LogSevInformation
                  'Hubo  & nFail &  registros que dieron error y no se importaron
    End If
  End If
  If nWarning > 0 Then
    If nWarning = 1 Then
      pProcessLog LNGGetText(3349, vbNullString), LogSevInformation
                  'Hubo un registro que dió un mensaje de advertencia y se importó
    Else
      pProcessLog LNGGetText(3349, vbNullString, nWarning), LogSevInformation
                'Hubo  & nWarning &  registros que dieron mensajes de _
                advertencia y se importaron
    End If
  End If
  pProcessLog LNGGetText(3301, vbNullString), LogSevInformation
              'El proceso se termino con éxito
  pProcessLogSep

  pWizardProcess = True

  GoTo ExitProc
ControlError:
  MngError Err, "pWizardProcess", C_Module, vbNullString
  pSaveLogToDb LastErrorDescription, LogSevError, m_impp_id, C_Module
  If Err.Number <> 0 Then
    bError = True
    Resume ExitProc
  End If
ExitProc:
  On Error Resume Next
End Function

Private Sub pShowCurrent(ByVal Current As Long)
End Sub

Private Sub pShowCount(ByVal Count As Long)
End Sub

Private Sub pGetModifyAndUpdate(ByRef bHaveLastUpdate As Boolean, ByRef bHaveWhoModify As Boolean, ByVal TblName As String)
  Dim sqlstmt   As String
  Dim rs        As ADODB.Recordset
  Dim fld       As ADODB.Field
  
  sqlstmt = "select * from " & TblName & " where 1=2"
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  bHaveLastUpdate = False
  bHaveWhoModify = False
  
  For Each fld In rs.Fields
    If LCase(fld.Name) = cscModifico Then
      bHaveWhoModify = True
    ElseIf LCase(fld.Name) = cscModificado Then
      bHaveLastUpdate = True
    End If
  Next
End Sub

Private Sub pShowProgressBar(ByVal Value As Integer, ByRef Cancel As Boolean)
  RaiseEvent Progress(Value, Cancel)
End Sub

Private Sub pProcessLogSep()
  pProcessLog String(20, "-"), LogSevInformation
End Sub

Private Sub pProcessLog(ByVal msg As String, ByVal Severity As csLogSeverity, Optional ByVal Module As String = C_Module)
  pSaveLogToDb msg, Severity, m_impp_id, C_Module
#If Not PREPROC_UNATTENDED Then
  pProcessLogAux msg, Severity, Module
#End If
End Sub

Private Sub pProcessLogAux(ByVal msg As String, ByVal Severity As csLogSeverity, Optional ByVal Module As String = C_Module)
  Dim str_3209    As String
  Dim str_3323    As String
  
  str_3209 = LNGGetText(3209, vbNullString) 'Error
  str_3323 = LNGGetText(3323, vbNullString) 'Advertencia !!!
  ' File
  If Severity = LogSevError Then
    SaveLog String(20, "-") & str_3209 & String(20, "-")
  ElseIf Severity = LogSevWarnning Then
    SaveLog String(20, "-") & str_3323
  End If
  
  If InStr(1, msg, vbCrLf) > 1 Then
    SaveLog Module
    SaveLog msg
  Else
    If Len(Module) > 50 Then
      SaveLog Module & String(50 - Len(Module), " ") & msg
    Else
      SaveLog Module & "   " & msg
    End If
  End If
  
  If Severity = LogSevError Then
    SaveLog String(16, "-") & LNGGetText(3324, vbNullString) & String(20, "-")
                              'Fin Error
  ElseIf Severity = LogSevWarnning Then
    SaveLog String(16, "-") & LNGGetText(3325, vbNullString)  'Fin Advertencia !!!
  End If
  
  ' Window
  If Severity = LogSevError Then
    msg = vbCrLf & String(20, "-") & str_3209 & String(20, "-") & vbCrLf & msg & vbCrLf & String(16, "-") & LNGGetText(3324, vbNullString) & String(20, "-")
                                                                                                            'Fin Error
    
  ElseIf Severity = LogSevWarnning Then
    msg = vbCrLf & String(20, "-") & str_3323 & vbCrLf & msg & vbCrLf & String(16, "-") & LNGGetText(3325, vbNullString)  'Fin Advertencia !!!
  End If
  
End Sub

Private Function pColSelected(ByRef vMapeos() As T_Mapeo, ByVal ColOrigen As String, ByRef NextIndex As Long) As Boolean
  Dim i As Long
  For i = NextIndex To UBound(vMapeos)
    If vMapeos(i).Origen = ColOrigen Then
      NextIndex = i
      pColSelected = True
      Exit Function
    End If
  Next
End Function

Private Function pGetFkValue(ByVal ColFk As String, ByVal Codigo As String, ByRef FkeysInfo As T_FKeysInfo) As Long
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  With FkeysInfo
    sqlstmt = "select " & .ColNameId & " from " & .TblName & " where " & .ColNameCodigo & " = " & gDB.sqlString(Codigo)
  End With
  
  If Not gDB.OpenRs(sqlstmt, rs) Then
    pSaveLogToDb LastErrorDescription, LogSevError, m_impp_id, C_Module
    Exit Function
  End If
  
  If rs.EOF Then Exit Function

  pGetFkValue = rs.Fields(0).Value
End Function

Private Function pIsFkCol(ByVal ColFk As String, ByRef vFkeysInfo() As T_FKeysInfo, ByRef IndexCol As Long) As Boolean
  Dim i       As Long
  
  For i = 1 To UBound(vFkeysInfo)
    If vFkeysInfo(i).ColFk = ColFk Then Exit For
  Next
  
  If i > UBound(vFkeysInfo) Then Exit Function
  
  IndexCol = i
  pIsFkCol = True
End Function

Private Function pGetValue(ByVal Value As Variant, ByVal ColType As csTypes) As Variant
  Select Case ColType
    Case csTypes.csBoolean
      pGetValue = CInt(CBool(Value))
    Case csTypes.csCurrency, csTypes.csDouble, csTypes.csInteger, csTypes.csLong, csTypes.csSingle
      pGetValue = Val(Value)
    Case csTypes.csText
      pGetValue = Trim(Value)
    Case csTypes.csDate, csTypes.csDateOrNull
      If Not IsDate(Value) Then
        pGetValue = csNoDate
      Else
        pGetValue = Value
      End If
  End Select
End Function

Private Sub pGetColDestino(ByRef vMapeos() As T_Mapeo)
  Dim iProp       As cIABMProperty
  Dim Row         As cIABMGridRow
  Dim ColName     As String
  Dim ColDestino  As String
  
  ReDim vMapeos(0)
  
  Set iProp = m_Property
  
  For Each Row In iProp.Grid.Rows
    ColName = pGetCellFromKey(Row, KI_CAMPOORIGEN).Value
    If LenB(ColName) Then
      ColDestino = pGetCellFromKey(Row, KI_CAMPODESTINO).Value
      ReDim Preserve vMapeos(UBound(vMapeos) + 1)
      With vMapeos(UBound(vMapeos))
        .Destino = ColDestino
        .Origen = ColName
      End With
    End If
  Next
End Sub

Private Sub pGetFkeysInfo(ByRef vFkeysInfo() As T_FKeysInfo, ByVal TblName As String)
  Dim rs As ADODB.Recordset
  Dim sqlstmt As String
  Dim i  As Long
  
  sqlstmt = "sp_fkeys @fktable_name = '" & TblName & "'"
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub

  ReDim vFkeysInfo(0)
  If rs.EOF Then Exit Sub

  rs.MoveLast
  rs.MoveFirst
  
  ReDim vFkeysInfo(rs.RecordCount)
  While Not rs.EOF
    i = i + 1
    With vFkeysInfo(i)
      .ColNameId = rs.Fields("PKCOLUMN_NAME").Value
      .TblName = rs.Fields("PKTABLE_NAME").Value
      .ColFk = rs.Fields("FKCOLUMN_NAME").Value
      .ColNameCodigo = pGetColCodigoFk(.TblName)
    End With
    rs.MoveNext
  Wend
End Sub

Private Function pGetColCodigoFk(ByVal TblName As String) As String
  Dim fld     As ADODB.Field
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "select * from " & TblName & " where 1 = 2"
  
  If Not gDB.OpenRs(sqlstmt, rs) Then
    pSaveLogToDb LastErrorDescription, LogSevError, m_impp_id, C_Module
    Exit Function
  End If
  
  For Each fld In rs.Fields
    If LCase(Right$(fld.Name, 6)) = "codigo" Then
      pGetColCodigoFk = fld.Name
      Exit Function
    End If
  Next
End Function

Private Sub pGetDefaults(ByRef vDefaults() As T_Defaults)
  Dim iProp     As cIABMProperty
  Dim Row       As cIABMGridRow
  Dim Default   As String
  
  ReDim vDefaults(0)
  
  Set iProp = m_Property
  
  For Each Row In iProp.Grid.Rows
    Default = pGetCellFromKey(Row, KI_DEFAULT).Value
    If LenB(Default) Then
      ReDim Preserve vDefaults(UBound(vDefaults) + 1)
      With vDefaults(UBound(vDefaults))
        .ColDestino = pGetCellFromKey(Row, KI_CAMPODESTINO).Value
        .Default = Default
      End With
    End If
  Next
End Sub

Private Function pGetColType(ByVal TblName As String) As Collection
  Dim rtn As Collection
  Dim sqlstmt As String
  Dim rs      As Recordset
  Dim fld     As ADODB.Field
  
  sqlstmt = "select * from " & TblName & " where 1 = 2"
  If Not gDB.OpenRs(sqlstmt, rs) Then
    pSaveLogToDb LastErrorDescription, LogSevError, m_impp_id, C_Module
    Exit Function
  End If
  
  Set rtn = New Collection
  
  For Each fld In rs.Fields

    Select Case fld.Type
      Case adLongVarChar, adLongVarWChar, adChar, adVarChar, adVarWChar, adWChar
        rtn.Add csTypes.csText, fld.Name
      Case adBigInt, adBinary, adInteger, adLongVarBinary, adSmallInt, adTinyInt, adUnsignedBigInt, adUnsignedInt, adUnsignedSmallInt, adUnsignedTinyInt
        rtn.Add csTypes.csLong, fld.Name
      Case adBoolean
        rtn.Add csTypes.csBoolean, fld.Name
      Case adCurrency, adSingle, adDecimal, adDouble, adNumeric
        rtn.Add csTypes.csDouble, fld.Name
      Case adDBTime, adDate, adDBDate
        rtn.Add csTypes.csDate, fld.Name
      Case adDBTimeStamp
        rtn.Add csTypes.csDate, fld.Name
    End Select
  Next
  
  Set pGetColType = rtn
End Function

Private Function pGetRowId(ByVal ColCodigoOrigen As String, ByVal sqlstmt As String, ByRef rsOrigen As ADODB.Recordset) As Long
  Dim rs As ADODB.Recordset
  Dim Codigo As String
  
  If IsNull(rsOrigen.Fields(ColCodigoOrigen).Value) Then
    
    Exit Function
    
  Else
  
    sqlstmt = sqlstmt & gDB.sqlString(rsOrigen.Fields(ColCodigoOrigen).Value)
    
    If Not gDB.OpenRs(sqlstmt, rs) Then
      pSaveLogToDb LastErrorDescription, LogSevError, m_impp_id, C_Module
      Exit Function
    End If
    
    If rs.EOF Then Exit Function
    pGetRowId = rs.Fields(0).Value
  
  End If
End Function

Private Sub pGetColId(ByRef ColId As String, ByRef TblName As String)
  Dim rs As ADODB.Recordset
  Dim sqlstmt As String
  
  If Not gDB.GetData("Tabla", "tbl_id", pGetDestino, "tbl_nombrefisico", TblName) Then Exit Sub
  
  sqlstmt = "sp_pKeys '" & TblName & "'"
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  If rs.EOF Then Exit Sub
  
  ColId = rs.Fields("COLUMN_NAME").Value
End Sub

Private Sub pGetColCodigo(ByRef ColCodigo As String, ByRef ColCodigoOrigen As String)
  Dim iProp     As cIABMProperty
  Dim Row       As cIABMGridRow
  Dim ColName   As String
  
  Set iProp = m_Property
  
  ColCodigo = pGetColCodigoName
  
  For Each Row In iProp.Grid.Rows
    ColName = pGetCellFromKey(Row, KI_CAMPODESTINO).Value
    If LCase(ColName) = LCase(ColCodigo) Then
      ColCodigo = ColName
      ColCodigoOrigen = pGetCellFromKey(Row, KI_CAMPOORIGEN).Value
      Exit For
    End If
  Next
End Sub

Private Function pGetColCodigoName() As String
  Dim ColCodigo As String
  
  If pGetDestino = csUsuario Then
    ColCodigo = "us_nombre"
  Else
    If Not gDB.GetData("Tabla", "tbl_id", pGetDestino, "tbl_campocodigo", ColCodigo) Then Exit Function
  End If
  pGetColCodigoName = ColCodigo
End Function

'Private Sub pGetColCodigo(ByRef ColCodigo As String, ByRef ColCodigoOrigen As String)
'  Dim iProp     As cIABMProperty
'  Dim Row       As cIABMGridRow
'  Dim ColName   As String
'
'  Set iProp = m_Property
'
'  For Each Row In iProp.Grid.Rows
'    ColName = pGetCellFromKey(Row, KI_CAMPODESTINO).Value
'    If LCase(Right$(ColName, 6)) = "codigo" Then
'      ColCodigo = ColName
'      ColCodigoOrigen = pGetCellFromKey(Row, KI_CAMPOORIGEN).Value
'      Exit For
'    End If
'  Next
'End Sub

Private Function pGetRecordsetOrigen() As ADODB.Recordset
  On Error GoTo ControlError
  
  Dim errNumber  As Long
  Dim errDescrip As String
  Dim errSource  As String
  
  Dim rs    As ADODB.Recordset
  Dim Path  As String
  Dim IsAdo As Boolean
  Dim xlSheet As Object 'As Excel.Worksheet
  Dim xlBook  As Object 'As Excel.Workbook
  Dim sqlstmt As String
  
  Path = pGetPath
  
  sqlstmt = pGetSqlstmt
  If sqlstmt = "" Then
    sqlstmt = "select * from [" & pGetOrigen & "]"
  End If
  
  Dim FileEx As CSKernelFile.cFileEx
  Set FileEx = New CSKernelFile.cFileEx
  
  Select Case LCase(FileEx.FileGetFileExt(FileEx.FileGetName(Path)))
    Case "xls"
      Set xlSheet = pGetSheet(Path, xlBook)
      IsAdo = False
    Case "dbf"
      Set rs = pGetRsCamposOrigen(Path, False, sqlstmt)
      IsAdo = True
    Case "mdb"
      Set rs = pGetRsCamposOrigen(Path, True, sqlstmt)
      IsAdo = True
    Case Else
      If LCase(Left$(Path, 4)) = "dsn=" Or LCase(Left$(Path, 9)) = "provider=" Or LCase(Right$(Path, 4)) = ".udl" Then
        
        sqlstmt = pGetSqlstmt
        If sqlstmt = "" Then
          sqlstmt = "select * from " & pGetOrigen
        End If
        Set rs = pGetRsCamposOrigen(Path, False, sqlstmt)
        IsAdo = True
      End If
  End Select
  
  If Not IsAdo Then
    Dim i As Long
    Dim j As Long
    Dim RowEmpty As Long
    Dim ColEmpty As Long
    Dim ColName  As String
    Dim ColValue As String
    
    Set rs = New ADODB.Recordset
    
    pProcessLog "Cargando datos desde Excel", LogSevInformation
    
    For i = 1 To 256
      ColName = Trim(xlSheet.Cells(1, i))
      If LenB(ColName) Then
        rs.Fields.Append ColName & " (" & Format(i, "00") & ")", adVarChar, 5000
        ColEmpty = 0
      Else
        ColEmpty = ColEmpty + 1
        If ColEmpty > 10 Then Exit For
      End If
    Next
    
    rs.Open
    
    For j = 2 To 65535
      RowEmpty = RowEmpty + 1
      For i = 1 To 256
        ColName = Trim(xlSheet.Cells(1, i))
        If LenB(ColName) Then
          ColValue = Trim(xlSheet.Cells(j, i))
          If LenB(ColValue) Then
            RowEmpty = 0
            Exit For
          End If
          ColEmpty = 0
        Else
          ColEmpty = ColEmpty + 1
          If ColEmpty > 10 Then
            RowEmpty = RowEmpty + 1
            Exit For
          End If
        End If
      Next
      
      If RowEmpty = 0 Then
        rs.AddNew
        For i = 1 To 256
          ColName = Trim(xlSheet.Cells(1, i))
          If LenB(ColName) Then
            ColName = ColName & " (" & Format(i, "00") & ")"
            ColValue = Trim(xlSheet.Cells(j, i))
            If LenB(ColValue) Then
              pSetValue rs.Fields(ColName), ColValue
            End If
          End If
        Next
      Else
        If RowEmpty > 10 Then Exit For
      End If
    Next
  End If

  Set pGetRecordsetOrigen = rs

  GoTo CloseExcel
ControlError:

  errNumber = Err.Number
  errDescrip = Err.Description
  errSource = Err.Source
  
  Resume CloseExcel
CloseExcel:
  On Error GoTo 0
  If Not xlBook Is Nothing Then
    xlBook.Close False
  End If
  
  If errNumber <> 0 Then
    Err.Raise errNumber, errSource, errDescrip
  End If
End Function

Private Sub pSetValue(ByRef Field As ADODB.Field, ByVal Value As String)
  On Error Resume Next
  Err.Clear
  Field.Value = Value
  If Err.Number = -2147217887 Then
    Dim i      As Long
    
    If Field.Type = adVarChar Then
      For i = 1 To Len(Value)
        Field.Value = Field.Value & Mid(Value, i, 1)
      Next
    End If
  End If
End Sub

Private Function pLoadMapeoItem() As Boolean
  Dim iProp As cIABMProperty
  Dim sqlstmt As String
  Dim rs As ADODB.Recordset
  Dim o As cIABMGridColumn
  
  Set m_Property = New cABMProperty
  
  Set iProp = m_Property

  sqlstmt = "sp_Columns " & gDB.sqlString(pGetDestinoNombre)
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadMapeoItem", C_Module) Then
    pSaveLogToDb LastErrorDescription, LogSevError, m_impp_id, C_Module
    Exit Function
  End If
  
  iProp.Grid.Columns.Clear
  iProp.Grid.Rows.Clear
  
  Set o = iProp.Grid.Columns.Add(Nothing)
  o.Name = "impi_id"
  o.Visible = False
  o.Key = KI_IMPI_ID
  
  Set o = iProp.Grid.Columns.Add(Nothing)
  o.Name = LNGGetText(3212, vbNullString) 'Valor por defecto
  o.PropertyType = cspText
  o.Width = 2500
  o.Key = KI_DEFAULT
  
  Set o = iProp.Grid.Columns.Add(Nothing, c_Origen)
  o.Name = LNGGetText(3313, vbNullString) 'Columna origen
  o.PropertyType = cspList
  o.Width = 3000
  o.Key = KI_CAMPOORIGEN
  
  pLoadCamposOrigen o
  
  Set o = iProp.Grid.Columns.Add(Nothing)
  o.Name = LNGGetText(3314, vbNullString) 'Columna destino
  o.PropertyType = cspText
  o.Width = 3000
  o.Key = KI_CAMPODESTINO
  
  Dim f  As cIABMGridRow
  Dim fv As cIABMGridCellValue
  Dim ColName As String
  
  While Not rs.EOF
    ColName = gDB.ValField(rs.Fields, "COLUMN_NAME")
    If ColName <> cscModificado And ColName <> cscModifico Then
  
      Set f = iProp.Grid.Rows.Add(Nothing)
      
      Set fv = f.Add(Nothing)
      fv.Value = csNew
      fv.Key = KI_IMPI_ID
      
      Set fv = f.Add(Nothing)
      fv.Value = ""
      fv.Key = KI_DEFAULT
  
      Set fv = f.Add(Nothing)
      fv.Value = ""
      fv.Key = KI_CAMPOORIGEN
      
      Set fv = f.Add(Nothing)
      fv.Value = gDB.ValField(rs.Fields, "COLUMN_NAME")
      fv.Key = KI_CAMPODESTINO
    End If
    
    rs.MoveNext
  Wend
  
  pLoadMapeoFromDb iProp
  
  pLoadMapeoItem = True
End Function

Private Sub pLoadMapeoFromDb(ByRef iProp As cIABMProperty)
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  Dim Row     As cIABMGridRow
  Dim List       As cIABMList
  Dim ListItem   As cIABMListItem
  Dim Origen     As String
  Dim Default    As String
  Dim bFound     As Boolean
  
  sqlstmt = "select * from ImportacionItem where imp_id = " & m_Id
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  Set List = iProp.Grid.Columns(c_Origen).List
  
  While Not rs.EOF
    
    Origen = gDB.ValField(rs.Fields, cscImpiCampoOrigen)
    Default = gDB.ValField(rs.Fields, cscImpiDefault)
    
    If LenB(Origen) Or LenB(Default) Then
      For Each Row In iProp.Grid.Rows
        If LCase(pGetCellFromKey(Row, KI_CAMPODESTINO).Value) = LCase(gDB.ValField(rs.Fields, cscImpiCampoDestino)) Then
          If LenB(Origen) Then
            bFound = False
            For Each ListItem In List
              If LCase(ListItem.Value) = LCase(Origen) Then
                pGetCellFromKey(Row, KI_CAMPOORIGEN).Value = Origen
                bFound = True
                Exit For
              End If
            Next
            
            If Not bFound And Right$(Origen, 1) = ")" And Left$(Right$(Origen, 4), 1) = "(" And IsNumeric(Left$(Right$(Origen, 3), 2)) Then
              For Each ListItem In List
                If Len(ListItem.Value) - 4 > 0 Then
                  If LCase(Mid(ListItem.Value, 1, Len(ListItem.Value) - 4)) = LCase(Mid(Origen, 1, Len(Origen) - 4)) Then
                    pGetCellFromKey(Row, KI_CAMPOORIGEN).Value = ListItem.Value
                    Exit For
                  End If
                End If
              Next
            End If
            
            Exit For
          Else
            pGetCellFromKey(Row, KI_DEFAULT).Value = Default
            Exit For
          End If
        End If
      Next
    End If
    
    rs.MoveNext
  Wend
End Sub

Private Sub pLoadCamposOrigen(ByVal o As cIABMGridColumn)
  On Error GoTo ControlError
  
  Dim errNumber  As Long
  Dim errDescrip As String
  Dim errSource  As String
  
  Dim rs    As ADODB.Recordset
  Dim Path  As String
  Dim IsAdo As Boolean
  Dim xlSheet As Object 'As Excel.Worksheet
  Dim xlBook  As Object 'As Excel.Workbook
  Dim sqlstmt As String
  
  sqlstmt = pGetSqlstmt
  If sqlstmt = "" Then
    sqlstmt = "select * from [" & pGetOrigen & "] where 1=2"
  Else
     sqlstmt = pGetSqlstmt12(sqlstmt)
  End If
  
  Path = pGetPath
  
  Dim FileEx As CSKernelFile.cFileEx
  Set FileEx = New CSKernelFile.cFileEx
  
  Select Case LCase(FileEx.FileGetFileExt(FileEx.FileGetName(Path)))
    Case "xls"
      Set xlSheet = pGetSheet(Path, xlBook)
      IsAdo = False
    Case "dbf", "udl"
      Set rs = pGetRsCamposOrigen(Path, False, sqlstmt)
      IsAdo = True
    Case "mdb"
      Set rs = pGetRsCamposOrigen(Path, True, sqlstmt)
      IsAdo = True
    Case Else
      If LCase(Left$(Path, 4)) = "dsn=" Or LCase(Left$(Path, 9)) = "provider=" Or LCase(Right$(Path, 4)) = ".udl" Then
        sqlstmt = pGetSqlstmt
        If sqlstmt = "" Then
          sqlstmt = "select * from " & pGetOrigen & " where 1=2"
        Else
          sqlstmt = pGetSqlstmt12(sqlstmt)
        End If
        Set rs = pGetRsCamposOrigen(Path, False, sqlstmt)
        IsAdo = True
      End If
  End Select
  
  If IsAdo Then
    With o.List
      .Clear
      Dim f As Field
      For Each f In rs.Fields
        With .Add(Nothing)
          .Value = f.Name
        End With
      Next
    End With
  
  Else
    Dim i As Long
    Dim ColName As String
    With o.List
      .Clear
      For i = 1 To 256
        ColName = Trim(xlSheet.Cells(1, i))
        If LenB(ColName) Then
          With .Add(Nothing)
            .Value = ColName & " (" & Format(i, "00") & ")"
          End With
        End If
      Next
    End With
  End If

  With o.List.Add(Nothing)
    .Value = vbNullString
  End With

  GoTo CloseExcel
ControlError:

  errNumber = Err.Number
  errDescrip = Err.Description
  errSource = Err.Source
  
  Resume CloseExcel
CloseExcel:
  On Error GoTo 0
  If Not xlBook Is Nothing Then
    xlBook.Close False
  End If
  
  If errNumber <> 0 Then
    Err.Raise errNumber, errSource, errDescrip
  End If
End Sub
                                                           'Excel.Workbook
Private Function pGetSheet(ByVal Path As String, ByRef xlBook As Object) As Object 'Excel.Worksheet
  Dim xlApp     As Object 'Excel.Application
  Dim IProperty As cIABMProperty
  Dim Mouse     As cMouseWait
  
  Set Mouse = New cMouseWait
  DoEvents
  
  Set xlApp = CreateObject("Excel.Application")
  Set xlBook = xlApp.Workbooks.Open(Path)
  
  Set pGetSheet = xlBook.Worksheets(pGetOrigen)
End Function

Private Function pGetRsCamposOrigen(ByVal Path As String, ByVal IsAccess As Boolean, ByVal sqlstmt As String) As ADODB.Recordset
  Dim db        As cDataBase
  Dim IProperty As cIABMProperty
  Dim Mouse     As cMouseWait
  Dim rs        As ADODB.Recordset
  
  Set Mouse = New cMouseWait
  DoEvents
  
  Set db = New cDataBase
  
  If IsAccess Then
    If Not db.InitDB(Path) Then
      pSaveLogToDb LastErrorDescription, LogSevError, m_impp_id, C_Module
      Exit Function
    End If
  Else
    Dim sconnect As String
    
    If LCase(Left$(Path, 4)) = "dsn=" Or LCase(Left$(Path, 9)) = "provider=" Or LCase(Right$(Path, 4)) = ".udl" Then
    
      sconnect = Path
    
    Else
      
      Dim FileEx As CSKernelFile.cFileEx
      Set FileEx = New CSKernelFile.cFileEx
    
      sconnect = "Provider=MSDASQL.1;Persist Security Info=False;" & _
                  "Extended Properties=CollatingSequence=ASCII;" & _
                  "DefaultDir=" & FileEx.FileGetPath(Path) & ";" & _
                  "Deleted=0;Driver={Microsoft dBase Driver (*.dbf)};" & _
                  "DriverId=533;FIL=dBase 5.0;MaxBufferSize=2048;MaxScanRows=8;" & _
                  "PageTimeout=600;SafeTransactions=0;Statistics=0;Threads=3;" & _
                  "UID=admin;UserCommitSync=Yes;" & _
                  "Initial Catalog=" & FileEx.FileGetPath(Path)
    End If
    
    If Not db.InitDB(, , , , sconnect) Then
      pSaveLogToDb LastErrorDescription, LogSevError, m_impp_id, C_Module
      Exit Function
    End If
    
    If Left$(Path, 4) = "Dsn=" Then
      If Not db.Execute("set isolation to dirty read;") Then
        pSaveLogToDb LastErrorDescription, LogSevError, m_impp_id, C_Module
      End If
    End If
  End If
  
  pProcessLog sqlstmt, LogSevInformation
  
  db.OpenRs sqlstmt, rs
  
  db.DisconnectRecordset rs
    
  Set pGetRsCamposOrigen = rs
End Function

Private Function pUserCancel() As Boolean
  If m_bCancel Then pUserCancel = True
  m_bCancel = False
End Function

Private Function pGetOrigen() As String
  pGetOrigen = m_OrigenTabla
End Function

Private Function pGetSqlstmt() As String
  pGetSqlstmt = m_Sqlstmt
End Function

Private Function pGetDestino() As Long
  pGetDestino = m_DestinoTblId
End Function

Private Function pGetDestinoNombre() As String
  pGetDestinoNombre = m_DestinoTabla
End Function

Private Function pGetPath() As String
  pGetPath = m_OrigenPath
End Function

' funciones privadas
Public Function Load(ByVal ID As Long) As Boolean

  Dim sqlstmt As String

  sqlstmt = "select * from Importacion where imp_id = " & ID

  Dim rs As Recordset

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "Load", "cImportacion") Then
    pSaveLogToDb LastErrorDescription, LogSevError, m_impp_id, C_Module
    Exit Function
  End If
  
  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.Fields, cscImpId)
    m_OrigenTabla = gDB.ValField(rs.Fields, cscImpOrigenTabla)
    m_OrigenPath = gDB.ValField(rs.Fields, cscImpOrigenPath)
    m_Sqlstmt = gDB.ValField(rs.Fields, cscImpSqlstmt)
    m_DestinoTabla = gDB.ValField(rs.Fields, cscImpDestinoTabla)
    m_DestinoTblId = pGetTblId
    m_Nombre = gDB.ValField(rs.Fields, cscImpNombre)
    m_Descrip = gDB.ValField(rs.Fields, cscImpDescrip)
    m_Creado = gDB.ValField(rs.Fields, cscCreado)
    m_Modificado = gDB.ValField(rs.Fields, cscModificado)
    m_Modifico = gDB.ValField(rs.Fields, cscModifico)

  Else
    m_Id = csNO_ID
    m_OrigenTabla = vbNullString
    m_OrigenPath = vbNullString
    m_DestinoTabla = vbNullString
    m_DestinoTblId = csNO_ID
    m_Nombre = vbNullString
    m_Sqlstmt = vbNullString
    m_Descrip = vbNullString
    m_Creado = csNoDate
    m_Modificado = csNoDate
    m_Modifico = 0

  End If

  Load = True
End Function

Private Function pGetCellFromKey(ByRef Row As cIABMGridRow, ByVal Key As Long) As cIABMGridCellValue
  Dim Cell    As cIABMGridCellValue
  For Each Cell In Row
    If Cell.Key = Key Then
      Set pGetCellFromKey = Cell
    End If
  Next
End Function

Private Function pShowProcessTime(ByVal startTime As Date, ByRef iProperties As cIABMProperties) As String
  Dim Seconds As Long
  Dim Minutes As Long
  Dim strTime As String
  
  Seconds = DateDiff("s", startTime, Now)
  Minutes = Fix(Seconds / 60)
  Seconds = Seconds Mod 60
  
  strTime = Minutes & ":" & Format(Seconds, "00")
  
  pShowProcessTime = strTime
End Function

Private Function pGetProgress(ByRef rs As ADODB.Recordset) As Double
  On Error Resume Next
  Dim rtn As Long
  
  Err.Clear
  
  rtn = (rs.AbsolutePosition / pGetRecordCount(rs)) * 100
  
  If Err.Number <> 0 Then rtn = 1
  
  pGetProgress = rtn
End Function

Private Function pGetRecordCount(ByRef rs As ADODB.Recordset) As Long
  On Error Resume Next
  Dim rtn As Long
  
  Err.Clear
  rtn = rs.RecordCount
  
  If Err.Number <> 0 Then rtn = 1
  
  pGetRecordCount = rtn
End Function

Private Function pGetSqlstmt12(ByVal sqlstmt As String) As String
  If InStr(1, sqlstmt, "order by", vbTextCompare) Or InStr(1, sqlstmt, "group by", vbTextCompare) Then
    Err.Raise vbObjectError + 1, C_Module, LNGGetText(3321, vbNullString)
                                            'No se puede incluir un order by ni un group by en la sentencia origen
  End If
  If InStr(1, sqlstmt, "where", vbTextCompare) Then
    sqlstmt = sqlstmt & " and (1=2)"
  Else
    sqlstmt = sqlstmt & " where (1=2)"
  End If
  
  pGetSqlstmt12 = sqlstmt
End Function

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


Private Sub Class_Initialize()
  On Error GoTo ControlError

  c_ErrorSave = LNGGetText(3350, vbNullString) 'Error al Importar el registro

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

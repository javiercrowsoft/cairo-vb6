VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cImportarOblea"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSImportInterfaces2.cIImport
'--------------------------------------------------------------------------------
' cImportarOblea
' 27-06-2004

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cImportarOblea"

Private Enum csEWhat
  csE_Items = 1
  csE_Header
End Enum

' ImportacionProcesoItem
Private Const csTImportacionProcesoItem                  As String = "ImportacionProcesoItem"
Private Const cscImppiId                                 As String = "imppi_id"
Private Const cscImppiObjeto                             As String = "imppi_objeto"
Private Const cscImppiParams                             As String = "imppi_params"
Private Const cscImppiUltimaImpo                         As String = "imppi_ultimaimportacion"

' estructuras
' variables privadas
Private WithEvents m_Work           As cImportWork
Attribute m_Work.VB_VarHelpID = -1
Private m_db                        As cDataBase
Private m_imppi_id                  As Long
Private m_ObjForm                   As Object
Private m_LastDate                  As Date

' eventos
' propiedades publicas
' propiedades friend
' propiedades privadas
' funciones publicas
' funciones friend
' funciones privadas
Private Sub m_Work_Progress(ByVal Value As Integer, ByRef Cancel As Boolean)
  On Error GoTo ControlError
  
  DoEvents
  
  If m_ObjForm.Cancel Then
    Cancel = True
    Exit Sub
  End If
  
  m_ObjForm.ShowProgress Value
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIImport_Import", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Function cIImport_Import(ObjForm As Object, ByVal Params As String, ByVal imppi_id As Long, Db As CSDataBaseClient2.cDataBase) As Boolean
  On Error GoTo ControlError
  
  Set m_db = Db
  m_imppi_id = imppi_id
  
  Set m_ObjForm = ObjForm
  
  m_ObjForm.Title = "Obleas"
  m_ObjForm.Descript = "Obteniendo Datos"
  
  m_LastDate = Date
  
  Dim vParams As Variant
  vParams = Split(Params, "|")
  
  If UBound(vParams) < 1 Then Err.Raise vbObjectError + 1, C_Module, "La clase cImportOblea debe recibir los nombres de las dos importaciones de obleas (Header e Items {en ese orden}) separadas por un pipe (|)"
  
  If Not pImport(csE_Header, vParams(0)) Then Exit Function
  If Not pImport(csE_Items, vParams(1)) Then Exit Function
  
  If Not pSaveOblea() Then Exit Function
  
  ' Guardo la fecha de ultima importacion
  Dim imp_id As Long
  imp_id = pGetImpId(vParams(0))
  If Not pSaveLastImportDate() Then Exit Function
  imp_id = pGetImpId(vParams(1))
  If Not pSaveLastImportDate() Then Exit Function
  
  cIImport_Import = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIImport_Import", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
  Set m_Work = Nothing
  Set m_ObjForm = Nothing
End Function

Private Function pSaveOblea() As Boolean
  Dim sqlstmt As String
  Dim rs      As Recordset
  Dim rs2     As Recordset
  Dim ID      As Long
  
  sqlstmt = "select pv_id from GNG_PedidoVenta"
  If Not m_db.OpenRs(sqlstmt, rs, , , , "pSaveOblea") Then Exit Function
   
  If Not rs.EOF Then
    rs.MoveLast
    rs.MoveFirst
  End If
  
  m_db.DisconnectRecordset rs
  
  While Not rs.EOF
    sqlstmt = "GNG_Impt_PedidoVenta " & m_db.ValField(rs.Fields, "pv_id")
    If m_db.OpenRs(sqlstmt, rs2, , , , "pSaveOblea", C_Module) Then
    
      sqlstmt = "sp_DocPedidoVentaCargaSave " & m_db.ValField(rs2.Fields, "pvTMP_id")
      If m_db.OpenRs(sqlstmt, rs2, , , , "pSaveOblea") Then
      
        If Not GetDocIDFromRecordset(rs2, ID) Then Exit Function
      End If
    End If
    
    m_ObjForm.ShowProgress (rs.AbsolutePosition / rs.RecordCount) * 100
    
    DoEvents
    
    rs.MoveNext
  Wend
  
  pSaveOblea = True
End Function

Private Function pImport(ByVal What As csEWhat, ByVal Params As String) As Boolean
  Dim sqlstmt As String
  
  If Not pGetSqlstmt(sqlstmt, What) Then Exit Function
  
  Dim objImpt As cImportWork
  Set objImpt = New cImportWork

  Set m_Work = objImpt
  
  Dim imp_id As Long
  imp_id = pGetImpId(Params)
  
  objImpt.impp_id = pGetImppId()
  
  If Not objImpt.Load(imp_id) Then Exit Function
  
  objImpt.sqlstmt = sqlstmt
  
  If Not objImpt.Work() Then Exit Function

  pImport = True
End Function

Private Function pSaveLastImportDate() As Boolean
  On Error GoTo ControlError
  
  Dim register As cRegister
  Set register = New cRegister
  
  register.Table = csTImportacionProcesoItem
  register.fieldId = cscImppiId
  
  register.ID = m_imppi_id
  register.Fields.Add2 cscImppiUltimaImpo, m_LastDate, csDate
  
  register.Fields.HaveLastUpdate = True
  register.Fields.HaveWhoModify = True
  
  If Not m_db.Save(register, False, "pSaveLastImportDate", C_Module) Then Exit Function
  
  pSaveLastImportDate = True

  GoTo ExitProc
ControlError:
  MngError Err, "pSaveLastImportDate", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pGetImppId() As Long
  Dim impp_id As Long
  
  If Not m_db.GetData("ImportacionProcesoItem", "imppi_id", m_imppi_id, "impp_id", impp_id) Then Exit Function
  pGetImppId = impp_id
End Function

Private Function pGetImpId(ByVal ImpNombre As String) As Long
  Dim imp_id  As Long
  Dim bExists As Boolean
  
  If Not m_db.GetDataWithCondition("Importacion", "imp_id", "imp_nombre = " & m_db.sqlString(ImpNombre), imp_id, bExists) Then
    imp_id = csNO_ID
  Else
    If Not bExists Then imp_id = csNO_ID
  End If
  pGetImpId = imp_id
End Function

Private Function pGetSqlstmt(ByRef sqlstmt As String, ByVal What As csEWhat) As Boolean
  Dim UltimaImpo As Date
  
  If Not m_db.GetData("ImportacionProcesoItem", "imppi_id", m_imppi_id, "imppi_ultimaimportacion", UltimaImpo) Then Exit Function
  
  Select Case What
    Case csEWhat.csE_Header
      sqlstmt = "select * from ord_entcb "
      sqlstmt = sqlstmt & " where  " & GetDateWhereInformix("fecha", UltimaImpo, ">=") '"fecha > '" & Format(UltimaImpo, "ddmmyyyy") & "'"
      sqlstmt = sqlstmt & " and cliente >= 800000 and cliente < 900000"
      
    Case csEWhat.csE_Items
 
      sqlstmt = "select " & vbCrLf
      sqlstmt = sqlstmt & "                ord_entln.ordent,  " & vbCrLf
      sqlstmt = sqlstmt & "                ord_entln.nrolin,  " & vbCrLf
      sqlstmt = sqlstmt & "                (ord_entln.ordent * 1000) + ord_entln.nrolin as id,  " & vbCrLf
      sqlstmt = sqlstmt & "                cumplido," & vbCrLf
      sqlstmt = sqlstmt & "                articulo" & vbCrLf
      sqlstmt = sqlstmt & "from ord_entln,ord_entcb  " & vbCrLf
      sqlstmt = sqlstmt & "where  ord_entln.ordent = ord_entcb.ordent  " & vbCrLf
      sqlstmt = sqlstmt & "and " & GetDateWhereInformix("ord_entcb.fecha", UltimaImpo, ">=") & vbCrLf '"ord_entcb.fecha > '"& Format(UltimaImpo, "ddmmyyyy") & "'" & vbCrLf
      sqlstmt = sqlstmt & "and ord_entcb.cliente >= 800000 " & vbCrLf
      sqlstmt = sqlstmt & "and ord_entcb.cliente < 900000" & vbCrLf
  End Select
  
  pGetSqlstmt = True
End Function

Private Function GetDocIDFromRecordset(ByRef rs As ADODB.Recordset, ByRef ID As Long) As Boolean
  On Error GoTo ControlError
  
  Do
    If UCase(Trim(m_db.ValField(rs.Fields, 0))) = "ERROR" Then
      MsgWarning Trim(m_db.ValField(rs.Fields, 1))
      Exit Function
    End If
    
    ID = Val(m_db.ValField(rs.Fields, 0))
  
    Set rs = rs.NextRecordset
  Loop Until rs Is Nothing
  
  GetDocIDFromRecordset = True

  GoTo ExitProc
ControlError:
  MngError Err, "GetDocIDFromRecordset", "cUtil", "", "Error al obtener el resultado de la grabación de un documento", csErrorWarning, csErrorVba
ExitProc:
End Function

' construccion - destruccion
Private Sub Class_Terminate()
  On Error GoTo ControlError

  Set m_db = Nothing
  Set m_Work = Nothing
  Set m_ObjForm = Nothing

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Terminate", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

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



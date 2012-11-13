VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cImportarVarios"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSImportInterfaces2.cIImport
'--------------------------------------------------------------------------------
' cImportarVarios
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
Private Const C_Module = "cImportarVarios"

' ImportacionProcesoItem
Private Const csTImportacionProcesoItem                  As String = "ImportacionProcesoItem"
Private Const cscImppiId                                 As String = "imppi_id"
Private Const cscImppiObjeto                             As String = "imppi_objeto"
Private Const cscImppiParams                             As String = "imppi_params"
Private Const cscImppiUltimaImpo                         As String = "imppi_ultimaimportacion"

Private Const c_ImpoExpoClientes = "muresco - clientes - expo"
Private Const c_ImpoLaEuropeaClientes = "muresco - clientes la europea"
Private Const c_ImpoMurescoClientes = "muresco - clientes muresco"

' estructuras
' variables privadas
Private WithEvents m_Work           As cImportWork
Attribute m_Work.VB_VarHelpID = -1
Private m_db                        As cDataBase
Private m_imppi_id                  As Long
Private m_ObjForm                   As Object
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
  MngError m_ObjForm, m_imppi_id, Err, "cIImport_Import", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Function cIImport_Import(ObjForm As Object, ByVal Params As String, ByVal imppi_id As Long, Db As CSDataBaseClient2.cDataBase) As Boolean
  On Error GoTo ControlError
  
  Dim sqlstmt   As String
  
  Set m_db = Db
  m_imppi_id = imppi_id
  
  Set m_ObjForm = ObjForm
  
  m_ObjForm.Title = "Importaciones Varias"
  m_ObjForm.Descript = "Obteniendo Datos"
  
  If Not pGetSqlstmt(sqlstmt, Params) Then Exit Function
  
  Dim objImpt As cImportWork
  Set objImpt = New cImportWork

  Set m_Work = objImpt
  
  Dim imp_id As Long
  imp_id = pGetImpId(Params)
  
  objImpt.impp_id = pGetImppId()
  
  If Not objImpt.Load(imp_id) Then Exit Function
  
  objImpt.sqlstmt = sqlstmt
  
  If Not objImpt.Work() Then Exit Function
  
  If Not pRunSp(Params) Then Exit Function

  If Not pSaveLastImportDate() Then Exit Function
  
  cIImport_Import = True
  
  GoTo ExitProc
ControlError:
  MngError m_ObjForm, m_imppi_id, Err, "cIImport_Import", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
  Set m_Work = Nothing
  Set m_ObjForm = Nothing
End Function

Private Function pRunSp(ByVal Params As String) As Boolean
  
  If InStr(1, LCase(Params), "unidad") > 0 Then
    
    ' Por ahora nada que hacer
  
  ElseIf InStr(1, LCase(Params), "deposito") > 0 Then
    
    ' Por ahora nada que hacer
  
  ElseIf pIsTitular(Params) Then
    If LCase(Params) = c_ImpoExpoClientes Then
      
      pVincularCliConEmpresa
      pVincularConExpo
      
    ElseIf LCase(Params) = c_ImpoLaEuropeaClientes Then
      
      pVincularCliConEmpresa
      pVincularConVendedores
      
    ElseIf LCase(Params) = c_ImpoMurescoClientes Then
    
      pVincularCliConEmpresa
      pVincularConVentasMureco
      
    ElseIf InStr(1, LCase(Params), "proveedor") Then
      
      pVincularProvConEmpresa
      
    End If
  
  ElseIf InStr(1, LCase(Params), "familia") > 0 Then
    
    ' Por ahora nada que hacer
  
  ElseIf InStr(1, LCase(Params), "grupo") > 0 Then

    ' Por ahora nada que hacer
  
  End If
  
  pRunSp = True
End Function

Private Function pVincularConVendedores() As Boolean
  Dim sqlstmt As String
  
  sqlstmt = "MUR_DepartamentoClienteMuresco"
  
  pVincularConVendedores = pExecInDB(sqlstmt)
End Function

Private Function pVincularConVentasMureco() As Boolean
  Dim sqlstmt As String
  
  sqlstmt = "MUR_DepartamentoClienteMuresco"
  
  pVincularConVentasMureco = pExecInDB(sqlstmt)
End Function

Private Function pVincularConExpo() As Boolean
  Dim sqlstmt As String
  
  sqlstmt = "MUR_DepartamentoCliente 95, 800000, 899999"
  
  pVincularConExpo = pExecInDB(sqlstmt)
End Function

Private Function pVincularCliConEmpresa() As Boolean
  Dim sqlstmt As String
  
  sqlstmt = "MUR_ClienteEmpresa"
  
  pVincularCliConEmpresa = pExecInDB(sqlstmt)
End Function

Private Function pVincularProvConEmpresa() As Boolean
  Dim sqlstmt As String
  
  sqlstmt = "MUR_ProveedorEmpresa"
  
  pVincularProvConEmpresa = pExecInDB(sqlstmt)
End Function

Private Function pExecInDB(ByVal sqlstmt As String) As Boolean
  '
  ' Ojo a partir de aqui no se puede salir por
  ' EXIT FUNCTION, ya que se modifico el timeout
  ' y se debe salir por ExitProc
  '
  On Error GoTo ControlError
  
  Dim oldCommandTimeout As Long
  
  oldCommandTimeout = m_db.CommandTimeout
  m_db.CommandTimeout = 0
  
  pExecInDB = m_db.Execute(sqlstmt)

  GoTo ExitProc
ControlError:
  MngError m_ObjForm, m_imppi_id, Err, "pExecInDB", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
  m_db.CommandTimeout = oldCommandTimeout
End Function

Private Function pSaveLastImportDate() As Boolean
  On Error GoTo ControlError
  
  Dim register As cRegister
  Set register = New cRegister
  
  register.Table = csTImportacionProcesoItem
  register.fieldId = cscImppiId
  
  register.ID = m_imppi_id
  register.Fields.Add2 cscImppiUltimaImpo, Date, csDate
  
  register.Fields.HaveLastUpdate = True
  register.Fields.HaveWhoModify = True
  
  If Not m_db.Save(register, False, "pSaveLastImportDate", C_Module) Then Exit Function
  
  pSaveLastImportDate = True

  GoTo ExitProc
ControlError:
  MngError m_ObjForm, m_imppi_id, Err, "pSaveLastImportDate", C_Module, ""
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

Private Function pGetSqlstmt(ByRef sqlstmt As String, ByVal Params As String) As Boolean
  Dim UltimaImpo As Date
  
  If Not m_db.GetData("ImportacionProcesoItem", "imppi_id", m_imppi_id, "imppi_ultimaimportacion", UltimaImpo) Then Exit Function
  
  If InStr(1, LCase(Params), "unidad") > 0 Then
    sqlstmt = "select * from unidades"
  
  ElseIf InStr(1, LCase(Params), "deposito") > 0 Then
    sqlstmt = "select * from dptos"
  
  ElseIf pIsTitular(Params) Then
    If LCase(Params) = c_ImpoExpoClientes Then
      sqlstmt = "select * from sc01titl where  num_tit >= 800000 and  num_tit < 900000"
    ElseIf LCase(Params) = c_ImpoLaEuropeaClientes Then
      sqlstmt = "select * from sc01titl where  cod_vend >= 100 and  cod_vend <=299"
    ElseIf LCase(Params) = c_ImpoMurescoClientes Then
      sqlstmt = "select * from sc01titl where  num_tit >= 300000 and  num_tit < 500000"
    ElseIf InStr(1, LCase(Params), "proveedor") Then
      sqlstmt = "select * from sc01titl where  num_tit > 600000 and  num_tit < 700000"
    End If
    sqlstmt = sqlstmt & " and " & GetDateWhereInformix("fec_reg", UltimaImpo, ">=")
  
  ElseIf InStr(1, LCase(Params), "familia") > 0 Then
    sqlstmt = "select * from codigo where tipo_cod = 'fam'"
  
  ElseIf InStr(1, LCase(Params), "grupo") > 0 Then
    sqlstmt = "select * from codigo where tipo_cod = 'grp'"
  
  End If
  
  pGetSqlstmt = True
End Function

Private Function pIsTitular(ByVal Params As String) As Boolean
  If LCase(Params) = c_ImpoExpoClientes Or _
     LCase(Params) = c_ImpoLaEuropeaClientes Or _
     LCase(Params) = c_ImpoMurescoClientes Or _
     InStr(1, LCase(Params), "proveedor") > 0 Then
    pIsTitular = True
  End If
End Function

' construccion - destruccion
Private Sub Class_Terminate()
  On Error GoTo ControlError

  Set m_db = Nothing
  Set m_Work = Nothing
  Set m_ObjForm = Nothing

  GoTo ExitProc
ControlError:
  MngError m_ObjForm, m_imppi_id, Err, "Class_Terminate", C_Module, ""
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


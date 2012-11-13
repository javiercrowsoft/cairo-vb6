VERSION 5.00
Begin VB.Form fMain 
   BorderStyle     =   0  'None
   Caption         =   "CrowSoft Print Manager Service"
   ClientHeight    =   5190
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   6885
   Icon            =   "fMain.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   5190
   ScaleWidth      =   6885
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.Timer tmMain 
      Interval        =   10000
      Left            =   2820
      Top             =   2340
   End
   Begin VB.ListBox lsEvents 
      Height          =   4935
      Left            =   60
      TabIndex        =   0
      Top             =   120
      Width           =   6735
   End
End
Attribute VB_Name = "fMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Const C_Module = "fMain"

Private m_db As cDataSource
Private m_left As Long
Private m_top As Long
Private m_emp_id As Long
Private m_db_id As Long
Private m_initObjects As String
Private m_vInitObjects() As Object

Private Const APP_NAME = "CSPrintManagerServExe"

Private m_InitCSOAPI  As CSOAPI2.cInitCSOAPI

Public Property Let OwnerLeft(ByVal rhs As Long)
  m_left = rhs
End Property

Public Property Let OwnerTop(ByVal rhs As Long)
  m_top = rhs
End Property

Public Property Get Db() As cDataSource
  Set Db = m_db
End Property

Private Sub Form_Load()
  On Error Resume Next
  ReDim m_vInitObjects(0)
  addMessage "Iniciando el servicio " & Format(Now, "dd-mm-yyyy hh:nn")
  Set User = New cUser
  Set gDb = New cDataBaseBridge
  Me.left = m_left
  Me.top = m_top
End Sub

Private Sub Form_Resize()
  On Error Resume Next
  lsEvents.Move 100, 100, Me.ScaleWidth - 200, Me.ScaleHeight - 200
End Sub

Private Sub Form_Unload(Cancel As Integer)
  On Error Resume Next
  
  Set m_db = Nothing
  Set m_InitCSOAPI = Nothing

  Err.Clear
End Sub

Private Sub tmMain_Timer()
  tmMain.Enabled = False
  If m_db Is Nothing Then
    pOpenDB
  Else
    addMessage "Leyendo"
    pProcessJobs
    lsEvents.ListIndex = lsEvents.ListCount - 1
  End If
  tmMain.Enabled = True
End Sub

Private Sub pOpenDB()
  On Error GoTo ControlError

  Set m_db = New cDataSource

  Dim Server    As String
  Dim Database  As String
  Dim User      As String
  Dim Password  As String
  Dim TrustedConnection As Boolean
  
  Server = IniGet(c_k_Server, "(Local)")
  Database = IniGet(c_k_DataBase, "Master")
  User = IniGet(c_k_User, "sa")
  Password = IniGet(c_k_Password, "")
  TrustedConnection = IniGet(c_k_TrustedConnection, "0")
  m_db_id = IniGet(c_k_DbId, "0")
  m_initObjects = IniGet(c_k_InitObjects, "0")
  
  m_db.OpenConnection Server, Database, User, Password, TrustedConnection
    
  addMessage "Conectado a la base de datos con exito"
  addMessage "Leyendo cada 1 segundo"
  tmMain.Interval = 1000

  GoTo ExitProc
ControlError:
  MngError Err, "pOpenDB", C_Module, ""
  Set m_db = Nothing
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub pProcessJobs()
  On Error GoTo ControlError
  
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_TrabajoImpresionGetNextJob"
  If Not m_db.OpenRs(rs, sqlstmt) Then Exit Sub
  If rs.EOF Then Exit Sub
  
  Dim timp_id As Long
  timp_id = m_db.ValField(rs.fields(0))
  
  ' set empid
  EmpId = m_db.ValField(rs.fields("emp_id"))
  ' set userid
  User.id = m_db.ValField(rs.fields("us_id"))
  ' print
  
  Dim usuario As String
  Dim empresa As String
  Dim sendByEmail As Boolean
  Dim emailAddress As String
  Dim emailSubject As String
  Dim emailBody As String
  
  usuario = m_db.ValField(rs.fields("us_nombre"))
  empresa = m_db.ValField(rs.fields("emp_nombre"))
  sendByEmail = m_db.ValField(rs.fields("timp_sendByEmail"))
  emailAddress = m_db.ValField(rs.fields("timp_emailAddress"))
  emailSubject = m_db.ValField(rs.fields("timp_emailSubject"))
  emailBody = m_db.ValField(rs.fields("timp_emailBody"))
  
  If Not InitCSOAPI(EmpId, m_db_id, usuario, m_initObjects) Then
    sqlstmt = "sp_TrabajoImpresionSetError " & timp_id
    If Not m_db.Execute(sqlstmt, "") Then Exit Sub
    Exit Sub
  End If
  
  addMessage "Procesando trabjo " & timp_id
  addMessage "Usuario " & usuario
  addMessage "Empresa " & empresa
  
  Dim rsi As ADODB.Recordset
  sqlstmt = "sp_TrabajoImpresionGetItems " & timp_id
  If Not m_db.OpenRs(rsi, sqlstmt) Then Exit Sub
  
  Dim pm As cPrintManager
  Set pm = New cPrintManager
  pm.Path = IniGet(c_k_rptpath, App.Path & "\reportes")
  pm.id = m_db.ValField(rs.fields("id"))
  pm.DocId = m_db.ValField(rs.fields("doc_id"))
  pm.TblId = m_db.ValField(rs.fields("tbl_id"))
  pm.emailAddress = emailAddress
  pm.emailSubject = emailSubject
  pm.emailBody = emailBody
  
  Dim rptName   As String
  Dim rptFile   As String
  Dim copies    As Long
  Dim collRpts  As Collection
  Dim rpt       As cReport
  
  If sendByEmail Then
    addMessage "Hay que enviar por email"
    Set collRpts = New Collection
  End If
  
  While Not rsi.EOF
    
    rptName = m_db.ValField(rsi.fields("timpi_rptname"))
    rptFile = m_db.ValField(rsi.fields("timpi_rptfile"))
    copies = m_db.ValField(rsi.fields("timpi_copies"))
    
    addMessage "Imprimiendo reporte " & rptName
    addMessage "Usando archivo " & rptFile
    addMessage "Copias " & copies
    
    Set rpt = Nothing
    
    If Not pm.PrintReport(rptName, _
                          rptFile, _
                          m_db.ValField(rsi.fields("timpi_action")), _
                          copies, _
                          m_db.ValField(rsi.fields("timpi_strobject")), _
                          rpt, _
                          True _
                          ) Then
      
      addMessage "Fallo la impresion " & rptName
      addMessage "Error: " & CSKernelClient2.LastErrorDescription
      
      sqlstmt = "sp_TrabajoImpresionSetError " & timp_id
      If Not m_db.Execute(sqlstmt, "") Then Exit Sub
                  
      Exit Sub
    End If
    
    If sendByEmail Then
    
      collRpts.Add rpt
      
    End If
    
    rsi.MoveNext
  Wend

  If sendByEmail Then
    addMessage "Enviando por email a " & emailAddress
    If Not pm.sendEmail(collRpts) Then
      
      sqlstmt = "sp_TrabajoImpresionSetError " & timp_id
      If Not m_db.Execute(sqlstmt, "") Then Exit Sub
      
      Exit Sub
    End If
  End If

  sqlstmt = "sp_TrabajoImpresionSetDone " & timp_id
  If Not m_db.Execute(sqlstmt, "") Then Exit Sub

  addMessage "Trabajo procesado"
  addMessage "**********************************"

  Exit Sub
ControlError:
  addMessage "Ocurrio un error: " & Err.Description
End Sub

Public Sub addError(ByVal msg As String)
  addMessage msg
End Sub

Public Sub addMessage(ByVal msg As String)
  If lsEvents.ListCount > 300 Then
    lsEvents.RemoveItem 0
  End If
  lsEvents.AddItem Format(Now, "hh:nn:ss  ") & msg
  lsEvents.ListIndex = lsEvents.ListCount - 1
  DoEvents
End Sub

Private Function InitCSOAPI(ByVal emp_id As Long, ByVal bd_id As Long, ByVal userName As String, ByVal initObjects As String) As Boolean
  Dim mustInit As Boolean
  If m_InitCSOAPI Is Nothing Then
    mustInit = True
  ElseIf m_emp_id <> emp_id Then
    mustInit = True
  End If
  
  If mustInit Then
  
    addMessage "Creando objeto CSOAPI2.cInitCSOAPI"
  
      Set m_InitCSOAPI = New CSOAPI2.cInitCSOAPI
      m_InitCSOAPI.AppName = APP_NAME
      CSOAPI2.EmpId = emp_id
      CSOAPI2.BdId = bd_id
      
    addMessage "Iniciando CSOAPI"
      
      If Not m_InitCSOAPI.Init(m_db.ConnectString, userName, Nothing, 0) Then
        addMessage "Fallo al crear CSOAPI. " & CSKernelClient2.LastErrorDescription
        Exit Function
      End If
      m_InitCSOAPI.Database.Silent = True
    
      addMessage "String de Conexión Original: " & m_InitCSOAPI.Database.OriginalStrConnect
      addMessage "String de Conexión de cDataBase: " & m_InitCSOAPI.Database.StrConnect
      addMessage "CSOAPI inicializada con exito"
    
      addMessage "Invocando a GetUser"
      If Not CSOAPI2.User.GetUser(m_InitCSOAPI.Database.UserId) Then
        addMessage "GetUser fallo. " & CSKernelClient2.LastErrorDescription
        Exit Function
      End If
    
    addMessage "CSOAPI iniciada"
    
    m_emp_id = emp_id
    
    If m_initObjects <> "" Then
    
      Dim vInitObjectNames As Variant
      Dim i As Long
      
      vInitObjectNames = Split(m_initObjects, ",")
      
      If UBound(m_vInitObjects) < UBound(vInitObjectNames) + 1 Then
        ReDim m_vInitObjects(UBound(vInitObjectNames) + 1)
      End If
      
      For i = 0 To UBound(vInitObjectNames)
        If m_vInitObjects(i + 1) Is Nothing Then
          Set m_vInitObjects(i + 1) = CSKernelClient2.CreateObject(vInitObjectNames(i))
        End If
        
        m_vInitObjects(i + 1).Init m_InitCSOAPI.Database
        
      Next
    
    End If
  
  End If
  
  InitCSOAPI = True
  
End Function

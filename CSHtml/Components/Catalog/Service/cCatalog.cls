VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cCatalog"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
'--------------------------------------------------------------------------------
' cCatalog
' 01-11-2002

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' Interfaces
Implements cIService

' constantes
Private Const C_Module = "cCatalog"

' Configuracion
Private Const csTConfiguracion                         As String = "Configuracion"
Private Const cscCfgGrupo                              As String = "cfg_grupo"
Private Const cscCfgAspecto                            As String = "cfg_aspecto"
Private Const cscCfgValor                              As String = "cfg_valor"

' estructuras
' variables privadas
Private m_ServiceID           As Long
Private m_Server              As cIServer
Private m_db                  As cDataSource

Private m_logFile             As String
Private m_bInProcess          As Boolean
Private WithEvents m_Timer    As cTimer
Attribute m_Timer.VB_VarHelpID = -1

' eventos
' propiedadades publicas
Private Property Let cIService_ServiceID(ByVal rhs As Long)
  m_ServiceID = rhs
End Property

Private Property Get cIService_ServiceID() As Long
  cIService_ServiceID = m_ServiceID
End Property

Private Property Set cIService_Server(rhs As CSIService.cIServer)
  Set m_Server = rhs
End Property

Private Property Get cIService_Server() As CSIService.cIServer
  Set cIService_Server = m_Server
End Property
' propiedadades friend
' propiedades privadas
' funciones publicas
' funciones friend
' funciones privadas
Private Sub cIService_ClientShutDown(ByVal ClientId As Long)
  Const c_ServiceShutDown = -1000
  If ClientId = c_ServiceShutDown Then
    gClose = True
  End If
End Sub

Private Sub cIService_WndProc(ByVal ClientId As Long, Message() As Byte, Response() As Byte)
  On Error GoTo ControlError

  Dim sMessage          As String
  Dim ErrDescription    As String
  
  m_Server.ByteArrayToString sMessage, Message
  
  Select Case TCPGetTypeMessage(sMessage)
    
    Case Else
            
      ' No esta implementado
  
  End Select

  GoTo ExitProc
ControlError:
  MngError Err, "cIService_WndProc", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
  m_Server.StringToByteArray c_ErrorCode & gErrorInfo, Response
ExitProc:
  On Error Resume Next
End Sub

Private Function pGetDataBaseInfo( _
                                ByVal bd_id As Long, _
                                ByRef Database As String, _
                                ByRef SqlLogin As String, _
                                ByRef SqlPassw As String, _
                                ByRef Server As String, _
                                ByRef UseNTSecurity As Integer _
                                ) As Boolean
                                
  Dim Encrypt As cEncrypt
  Set Encrypt = New cEncrypt
                                
  If Not pGetDBData(bd_id, "bd_login", SqlLogin) Then Exit Function
  If Not pGetDBData(bd_id, "bd_pwd", SqlPassw) Then Exit Function
  If Not pGetDBData(bd_id, "bd_server", Server) Then Exit Function
  If Not pGetDBData(bd_id, "bd_nombre", Database) Then Exit Function
  If Not pGetDBData(bd_id, "bd_securitytype", UseNTSecurity) Then Exit Function

  SqlLogin = Encrypt.Decript(SqlLogin, c_LoginSignature)
  SqlPassw = Encrypt.Decript(SqlPassw, c_LoginSignature)
  Server = Encrypt.Decript(Server, c_LoginSignature)
  Database = Encrypt.Decript(Database, c_LoginSignature)

  pGetDataBaseInfo = True

End Function

Private Function pGetDataBases(ByRef rs As ADODB.Recordset) As Boolean
  On Error GoTo ControlError

  Dim sqlstmt As String
  
  sqlstmt = "select * from basedatos"
  
  If Not m_db.OpenRs(rs, sqlstmt) Then
    GoTo ExitProc
  End If

  pGetDataBases = True

  GoTo ExitProc
ControlError:
  MngError Err, "pGetDataBases", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pGetDBData(ByVal bd_id As Long, ByVal Field As String, ByRef rtn As Variant) As Boolean
  pGetDBData = m_db.GetData("BaseDatos", "bd_id", bd_id, Field, rtn)
End Function

Private Function pRemoveLastSep(ByVal sMessage As String) As String
  If Right$(sMessage, 1) = c_TCPSep2 Then sMessage = Left$(sMessage, Len(sMessage) - 1)
  pRemoveLastSep = sMessage
End Function

Private Sub pOpenDB()
  On Error GoTo ControlError

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
  
  m_db.OpenConnection Server, Database, User, Password, TrustedConnection

  GoTo ExitProc
ControlError:
  MngError Err, "pOpenDB", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub pProcess()
  
  Dim rs As ADODB.Recordset
  
  pSaveLog "Cargando Bases ..."
    
  If Not pGetDataBases(rs) Then
    pSaveLog "La carga de las bases fallo", True
    Exit Sub
  End If
  
  pSaveLog "Creando Objeto de Encriptación"
  
  Dim Encrypt As cEncrypt
  Set Encrypt = New cEncrypt
  
  pSaveLog "Recorriendo las bases"
  
  Dim Server          As String
  Dim Database        As String
  Dim User            As String
  Dim pwd             As String
  Dim UseNTSecurity   As Boolean
  
  Do While Not rs.EOF
    
    Server = Encrypt.Decript(m_db.ValField(rs.Fields.Item("bd_server")), c_LoginSignature)
    Database = Encrypt.Decript(m_db.ValField(rs.Fields.Item("bd_nombre")), c_LoginSignature)
    User = Encrypt.Decript(m_db.ValField(rs.Fields.Item("bd_login")), c_LoginSignature)
    pwd = Encrypt.Decript(m_db.ValField(rs.Fields.Item("bd_pwd")), c_LoginSignature)
    UseNTSecurity = Val(Encrypt.Decript(m_db.ValField(rs.Fields.Item("bd_securitytype")), c_LoginSignature))
    
    pSaveLog "Configurando Email para: [" & Server & "] - [" & Database & "]"
    
    If Not pSetEmail(Server, _
                     Database, _
                     User, _
                     pwd, _
                     UseNTSecurity) Then
      
      pSaveLog "La configuracion del Email fallo", True
    
    Else
  
      pSaveLog "Procesando Catalogos para: [" & Server & "] - [" & Database & "]"
  
      pUpdateCatalogs Server, Database, User, pwd, UseNTSecurity
    
    End If
    
    If gClose Then Exit Do
    
    rs.MoveNext
    
  Loop
  
End Sub

Private Function pUpdateCatalogs(ByVal Server As String, ByVal Database As String, _
                                 ByVal User As String, ByVal Password As String, _
                                 ByVal UseNTSecurity As Boolean) As Boolean
                                 
  On Error GoTo ControlError
  
  Dim sqlstmt As String
  Dim db      As cDataSource
  Dim rs      As ADODB.Recordset
  Dim alm_id  As Long

  pSaveLog "Actualizando catalogos para " & Server & " - " & _
                                            Database & " - " & _
                                            User & _
                                            " - NT " & _
                                            IIf(UseNTSecurity, "Si", "No")
  
  Set db = New cDataSource
  If Not db.OpenConnection(Server, _
                           Database, _
                           User, _
                           Password, _
                           UseNTSecurity, _
                           vbNullString) Then Exit Function
  
  
  '--------------------------------------------
  '
  ' Productos
  '
  sqlstmt = "sp_srv_catalog_getcatalogos"
  If Not db.OpenRs(rs, sqlstmt) Then
    pSaveLog "Obtener Productos Falló", True
    Exit Function
  End If
  
  pSaveLog "Catalogos cargados con éxito"
  
  If rs.EOF Then
    pSaveLog "No hay catalogos"
  End If
  
  Do While Not rs.EOF
  
    pUpdateCatalogsCatalogo db, _
                            rs.Fields.Item("catw_id").Value, _
                            rs.Fields.Item("catw_updateaddress").Value, _
                            rs.Fields.Item("catw_updateuser").Value, _
                            rs.Fields.Item("catw_updatepwd").Value
  
    If gClose Then Exit Do
    
    rs.MoveNext
  Loop
  
  pUpdateCatalogs = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "pUpdateCatalogs", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pUpdateCatalogsCatalogo(ByRef db As cDataSource, _
                                         ByVal catw_id As Long, _
                                         ByVal htmlpage As String, _
                                         ByVal User As String, _
                                         ByVal pwd As String) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  '--------------------------------------------
  '
  ' Productos
  '
  
  sqlstmt = "sp_srv_catalog_getproductos " & catw_id

  If Not db.OpenRs(rs, sqlstmt) Then
    pSaveLog "Obtener Productos Falló", True
    Exit Function
  End If
  
  pSaveLog "Productos cargados con éxito"
  
  If rs.EOF Then
    pSaveLog "No hay productos"
  End If
  
  Dim CatalogWeb As cCatalogWeb
  Set CatalogWeb = New cCatalogWeb
  
  Const c_max_len_inputs = 100
  
  Dim vsqlstmt_if(c_max_len_inputs) As String
  Dim vsqlstmt_update(c_max_len_inputs) As String
  Dim vsqlstmt_insert(c_max_len_inputs) As String

  Dim sqlstmt_if      As String
  Dim sqlstmt_update  As String
  Dim sqlstmt_insert  As String

  Dim n As Long

  Do While Not rs.EOF
  
    n = n + 1
  
    pSaveLog "Procesando Producto: " & db.ValField(rs.Fields.Item("pr_nombre"))
  
    pProcessProducto db, _
                     sqlstmt_if, _
                     sqlstmt_update, _
                     sqlstmt_insert, _
                     db.ValField(rs.Fields.Item("pr_id")), _
                     db.ValField(rs.Fields.Item("pr_nombre")), _
                     db.ValField(rs.Fields.Item("pr_codigo")), _
                     db.ValField(rs.Fields.Item("pr_descrip")), _
                     db.ValField(rs.Fields.Item("pr_nombreweb")), _
                     db.ValField(rs.Fields.Item("pr_aliasweb")), _
                     db.ValField(rs.Fields.Item("pr_codigohtml")), _
                     db.ValField(rs.Fields.Item("pr_codigohtmldetalle")), _
                     db.ValField(rs.Fields.Item("pr_codigopadre")), _
                     Val(db.ValField(rs.Fields.Item("pr_orden"))), _
                     db.ValField(rs.Fields.Item("pr_marca")), _
                     db.ValField(rs.Fields.Item("pr_iva")), _
                     db.ValField(rs.Fields.Item("precio")), _
                     db.ValField(rs.Fields.Item("activo"))
    
    vsqlstmt_if(n) = sqlstmt_if
    vsqlstmt_update(n) = sqlstmt_update
    vsqlstmt_insert(n) = sqlstmt_insert
    
    If n = c_max_len_inputs Then
      
      pProcessProductoAux CatalogWeb, _
                          htmlpage, _
                          User, _
                          pwd, _
                          vsqlstmt_if(), _
                          vsqlstmt_update(), _
                          vsqlstmt_insert()

      n = 0
    End If
    
    If gClose Then Exit Do
    
    rs.MoveNext
  Loop
  
  If n > 0 Then
    pProcessProductoAux CatalogWeb, _
                        htmlpage, _
                        User, _
                        pwd, _
                        vsqlstmt_if(), _
                        vsqlstmt_update(), _
                        vsqlstmt_insert()
    n = 0
  End If
  
  '--------------------------------------------
  '
  ' Tags de Productos
  '
  
  sqlstmt = "sp_srv_catalog_getproductotags " & catw_id

  If Not db.OpenRs(rs, sqlstmt) Then
    pSaveLog "Obtener Productos Tag Falló", True
    Exit Function
  End If
  
  pSaveLog "Tags de Productos cargados con éxito"
  
  If rs.EOF Then
    pSaveLog "No hay productos"
  End If
    
  Do While Not rs.EOF
  
    n = n + 1
    
    pSaveLog "Procesando Tag: " & db.ValField(rs.Fields.Item("prt_texto"))
  
    pProcessProductoTag db, _
                        sqlstmt_if, _
                        sqlstmt_update, _
                        sqlstmt_insert, _
                        db.ValField(rs.Fields.Item("prt_id")), _
                        db.ValField(rs.Fields.Item("prt_texto")), _
                        db.ValField(rs.Fields.Item("pr_id"))
        
    vsqlstmt_if(n) = sqlstmt_if
    vsqlstmt_update(n) = sqlstmt_update
    vsqlstmt_insert(n) = sqlstmt_insert
    
    If n = c_max_len_inputs Then
      
      pProcessProductoTagAux CatalogWeb, _
                             htmlpage, _
                             User, _
                             pwd, _
                             vsqlstmt_if(), _
                             vsqlstmt_update(), _
                             vsqlstmt_insert()

      n = 0
    End If
    
    If gClose Then Exit Do
    
    rs.MoveNext
  Loop
  
  If n > 0 Then
    pProcessProductoTagAux CatalogWeb, _
                           htmlpage, _
                           User, _
                           pwd, _
                           vsqlstmt_if(), _
                           vsqlstmt_update(), _
                           vsqlstmt_insert()
  End If
  
  ' FIN
  '
  '----------------------------------------------------
  
  CatalogWeb.DestroyFormWeb

End Function

Private Function pProcessProducto(ByRef db As cDataSource, _
                                  ByRef sqlstmt_if As String, _
                                  ByRef sqlstmt_update As String, _
                                  ByRef sqlstmt_insert As String, _
                                  ByVal pr_id As Long, _
                                  ByVal pr_nombre As String, _
                                  ByVal pr_codigo As String, _
                                  ByVal pr_descrip As String, _
                                  ByVal pr_nombreweb As String, _
                                  ByVal pr_aliasweb As String, _
                                  ByVal pr_codigohtml As String, _
                                  ByVal pr_codigohtmldetalle As String, _
                                  ByVal pr_codigopadre As String, _
                                  ByVal pr_orden As Integer, _
                                  ByVal pr_marca As String, _
                                  ByVal pr_iva As Double, _
                                  ByVal precio As Double, _
                                  ByVal activo As Integer) As Boolean
  
  sqlstmt_if = "select pr_id from producto where pr_id = " & pr_id & ";"
  
  sqlstmt_update = "update producto set pr_nombre = " & db.sqlString(pr_nombre) & _
                                      ", pr_codigo = " & db.sqlString(pr_codigo) & _
                                      ", pr_descrip = " & db.sqlString(pr_descrip) & _
                                      ", pr_nombreweb = " & db.sqlString(pr_nombreweb) & _
                                      ", pr_aliasweb = " & db.sqlString(pr_aliasweb) & _
                                      ", pr_codigohtml = " & db.sqlString(pr_codigohtml) & _
                                      ", pr_codigohtmldetalle = " & db.sqlString(pr_codigohtmldetalle) & _
                                      ", pr_codigopadre = " & db.sqlString(pr_codigopadre) & _
                                      ", pr_marca = " & db.sqlString(pr_marca) & _
                                      ", pr_iva = " & db.sqlNumber(pr_iva) & _
                                      ", pr_orden = " & pr_orden & _
                                      ", pr_precio = " & db.sqlNumber(precio) & _
                                      ", activo = " & activo & _
                   " where pr_id = " & pr_id & ";"

  sqlstmt_insert = "insert into producto (pr_id,pr_nombre,pr_codigo,pr_descrip,pr_nombreweb,pr_aliasweb,pr_codigohtml,pr_codigohtmldetalle,pr_codigopadre,pr_orden,pr_precio,pr_marca,pr_iva,activo)" & _
                        " values (" & pr_id & _
                                  "," & db.sqlString(pr_nombre) & _
                                  "," & db.sqlString(pr_codigo) & _
                                  "," & db.sqlString(pr_descrip) & _
                                  "," & db.sqlString(pr_nombreweb) & _
                                  "," & db.sqlString(pr_aliasweb) & _
                                  "," & db.sqlString(pr_codigohtml) & _
                                  "," & db.sqlString(pr_codigohtmldetalle) & _
                                  "," & db.sqlString(pr_codigopadre) & _
                                  "," & pr_orden & _
                                  "," & db.sqlNumber(precio) & _
                                  "," & db.sqlString(pr_marca) & _
                                  "," & db.sqlNumber(pr_iva) & _
                                  "," & activo & _
                            ");"

  pProcessProducto = True
  
End Function

Private Function pProcessProductoAux(ByRef CatalogWeb As cCatalogWeb, _
                                     ByVal htmlpage As String, _
                                     ByVal User As String, _
                                     ByVal pwd As String, _
                                     ByRef sqlstmt_if() As String, _
                                     ByRef sqlstmt_update() As String, _
                                     ByRef sqlstmt_insert() As String _
                                     ) As Boolean
  
  On Error Resume Next

  CatalogWeb.UpdateProducto htmlpage, _
                            True, _
                            User, _
                            pwd, _
                            sqlstmt_if, _
                            sqlstmt_update, _
                            sqlstmt_insert
  Dim i As Long
  For i = 1 To UBound(sqlstmt_if)
    pSaveLog sqlstmt_if(i)
    pSaveLog sqlstmt_update(i)
    pSaveLog sqlstmt_insert(i)
  Next
  
  If Err.Description = "Automation error" Then
    CatalogWeb.DestroyFormWeb
    Set CatalogWeb = Nothing
    Set CatalogWeb = New cCatalogWeb
    Err.Clear
  End If
  
  pProcessProductoAux = Err.Number = 0
End Function

Private Function pProcessProductoTag(ByRef db As cDataSource, _
                                     ByRef sqlstmt_if As String, _
                                     ByRef sqlstmt_update As String, _
                                     ByRef sqlstmt_insert As String, _
                                     ByVal prt_id As Long, _
                                     ByVal prt_texto As String, _
                                     ByVal pr_id As Long) As Boolean
  
  sqlstmt_if = "select prt_id from productotag where prt_id = " & prt_id & ";"
  
  sqlstmt_update = "update productotag set prt_texto = " & db.sqlString(prt_texto) & _
                                      ", pr_id = " & pr_id & _
                   " where prt_id = " & prt_id & ";"

  sqlstmt_insert = "insert into productotag (prt_id,prt_texto,pr_id)" & _
                        " values (" & prt_id & _
                                  "," & db.sqlString(prt_texto) & _
                                  "," & pr_id & _
                            ");"

  pProcessProductoTag = True
  
End Function

Private Function pProcessProductoTagAux(ByRef CatalogWeb As cCatalogWeb, _
                                        ByVal htmlpage As String, _
                                        ByVal User As String, _
                                        ByVal pwd As String, _
                                        ByRef sqlstmt_if() As String, _
                                        ByRef sqlstmt_update() As String, _
                                        ByRef sqlstmt_insert() As String _
                                        )

  On Error Resume Next

  CatalogWeb.UpdateProducto htmlpage, _
                            True, _
                            User, _
                            pwd, _
                            sqlstmt_if, _
                            sqlstmt_update, _
                            sqlstmt_insert
  
  If Err.Description = "Automation error" Then
    CatalogWeb.DestroyFormWeb
    Set CatalogWeb = Nothing
    Set CatalogWeb = New cCatalogWeb
    Err.Clear
  End If
  
  pProcessProductoTagAux = Err.Number = 0
End Function

Private Function pSendEmail(ByVal addressTo As String, _
                            ByVal subject As String, _
                            ByVal Message As String) As Boolean

  pSaveLog "Creando Objeto de Email"
  
  Dim Mail As Object
  Set Mail = CreateObject("CSMail.cMail")
  
  Dim body   As String
  
  body = Message
  
  Dim vAddressTo As Variant
  Dim i          As Long
  
  addressTo = Replace(addressTo, ";", ",")
  vAddressTo = Split(addressTo, ",")
  
  For i = 0 To UBound(vAddressTo)
  
    If Mail.SendEmail(vAddressTo(i), _
                      gEmailAddress, _
                      gEmailAddress, _
                      gEmailServer, _
                      gEmailPort, _
                      gEmailUser, _
                      gEmailPwd, subject, body) Then
      pSaveLog "El mail se envio con éxito"
    Else
      pSaveLog "El mail fallo " & Mail.ErrNumber & " - " & Mail.ErrDescrip, True
      Exit Function
    End If
    
  Next
  
  pSendEmail = True
End Function

Private Sub m_Timer_ThatTime()
  On Error GoTo ControlError
  
  If gClose Then
    m_Timer.Interval = 0
    Exit Sub
  End If
  
  If m_bInProcess Then Exit Sub
  
  m_bInProcess = True
  
  pSaveLog "Procesando Timer ..."
  
  pProcess

  GoTo ExitProc
ControlError:
  MngError Err, "m_Timer_ThatTime", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
  m_bInProcess = False
  pSaveLog "Fin Procesando Timer ..."
End Sub

Private Function pSetEmail(ByVal Server As String, ByVal Database As String, _
                           ByVal User As String, ByVal Password As String, _
                           ByVal UseNTSecurity As Boolean) As Boolean
  On Error GoTo ControlError
  
  Const c_GrupoGeneral = "General"
  Const c_EmailServer = "Email Server"
  Const c_EmailPort = "Email Port"
  Const c_EmailUser = "Email User"
  Const c_EmailPwd = "Email Pwd"
  Const c_EmailAddress = "Email Address"
  
  Dim sqlstmt As String
  Dim db      As cDataSource
  Dim rs      As ADODB.Recordset

  Set db = New cDataSource
  If Not db.OpenConnection(Server, _
                           Database, _
                           User, _
                           Password, _
                           UseNTSecurity, _
                           vbNullString) Then Exit Function
  
  sqlstmt = "select * from configuracion where cfg_grupo = " & db.sqlString(c_GrupoGeneral)
  If Not db.OpenRs(rs, sqlstmt) Then Exit Function
  
  Dim EmailServer          As String
  Dim EmailPort            As Long
  Dim EmailUser            As String
  Dim EmailPwd             As String
  Dim EmailAddress         As String

  EmailServer = ""
  EmailPort = 25
  EmailUser = ""
  EmailPwd = ""
  EmailAddress = ""

  While Not rs.EOF
    Select Case db.ValField(rs.Fields(cscCfgAspecto))
      Case c_EmailServer
        EmailServer = db.ValField(rs.Fields.Item(cscCfgValor))
      Case c_EmailPort
        EmailPort = Val(db.ValField(rs.Fields.Item(cscCfgValor)))
      Case c_EmailUser
        EmailUser = db.ValField(rs.Fields.Item(cscCfgValor))
      Case c_EmailPwd
        EmailPwd = db.ValField(rs.Fields.Item(cscCfgValor))
      Case c_EmailAddress
        EmailAddress = db.ValField(rs.Fields.Item(cscCfgValor))
    End Select
    
    rs.MoveNext
  Wend
  
  gEmailAddress = EmailAddress
  gEmailPort = EmailPort
  gEmailPwd = EmailPwd
  gEmailServer = EmailServer
  gEmailUser = EmailUser
  
  pSaveLog "Email-Address: " & gEmailAddress
  pSaveLog "Email-Server : " & gEmailServer
  pSaveLog "Email-Port   : " & gEmailPort
  pSaveLog "Email-User   : " & gEmailUser
  'pSaveLog "Email-PWD    : " & gEmailPwd
  
  pSaveLog "LenB   : " & LenB(gEmailAddress) * _
              LenB(gEmailServer) * _
              LenB(gEmailUser) * _
              LenB(gEmailPwd)
  
  If (LenB(gEmailUser) * _
      LenB(gEmailPwd)) = 0 Then
    pSaveLog "Advertencia: El usuario y la clave de email estan en blanco", True
  End If
  
  pSetEmail = LenB(gEmailAddress) * _
              LenB(gEmailServer)
  
  GoTo ExitProc
ControlError:
  MngError Err, "pSetEmail", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError

  m_ServiceID = SRV_ID_CATALOG

  m_logFile = IniGet(c_k_Log, pGetPath(App.Path) & "Log\CSCatalog.log")

  pSaveLog "Server Catalog Start", True

  Set m_Timer = New cTimer
  m_Timer.Interval = Val(IniGet(c_k_interval, 3000))
  
  pSaveLog "Interval: " & m_Timer.Interval, True
  
  Set m_Server = gServer
  gServiceCreated = True
  
  Set m_db = New cDataSource
  pOpenDB

  pSaveLog "Initialize Complete Successfully", True

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
  On Error GoTo ControlError

  pSaveLog "Server Catalog Stop", True
  
  Set m_Server = Nothing
  gServiceCreated = False
  
  Set m_db = Nothing
  Set m_Timer = Nothing
  
  GoTo ExitProc
ControlError:
  MngError Err, "Class_Terminate", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub pSaveLog(ByVal msg As String, _
                     Optional ByVal bLog As Boolean)
  On Error Resume Next
  
  If gLogFull Or bLog Then
  
    Dim f As Integer
    f = FreeFile
    Open m_logFile For Append As f
    Print #f, Format(Now, "dd/mm/yy hh:nn:ss   ") & msg
    Close f
    
  End If
End Sub

Private Function pGetPath(ByVal Path As String) As String
  If Right(Path, 1) <> "\" Then Path = Path & "\"
  pGetPath = Path
End Function

'Private Function pGetHtmlPage() As String
'  'pGetHtmlPage = "http://localhost:8080/catalogo/tools.php"
'  pGetHtmlPage = IniGet(c_k_update_page, "http://localhost/catalogo/tools.php")
'End Function

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

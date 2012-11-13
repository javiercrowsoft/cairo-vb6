VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cCatalogoCSCart"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
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

Private Function pGetDBData(ByVal bd_id As Long, ByVal field As String, ByRef rtn As Variant) As Boolean
  pGetDBData = m_db.GetData("BaseDatos", "bd_id", bd_id, field, rtn)
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
  ' Catalogos
  '
  sqlstmt = "sp_srv_catalog_getcatalogos 1"
  If Not db.OpenRs(rs, sqlstmt) Then
    pSaveLog "Obtener Productos Falló", True
    Exit Function
  End If
  
  pSaveLog "Catalogos cargados con éxito"
  
  If rs.EOF Then
    pSaveLog "No hay catalogos"
  End If

  Do While Not rs.EOF
  
  'If rs.Fields.Item("catw_id").Value <> 5 Then
    pUpdateCatalogsCatalogo db, _
                            rs.Fields.Item("catw_id").Value, _
                            rs.Fields.Item("catw_updateaddress").Value, _
                            rs.Fields.Item("catw_updateuser").Value, _
                            rs.Fields.Item("catw_updatepwd").Value
  'End If
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

Private Function pGetVersionPage(ByVal URL As String) As String
  Dim i As Integer
  Dim rtn As String
  
  For i = Len(URL) To 1 Step -1
    If Mid$(URL, i, 1) = "/" Then
      rtn = Mid$(URL, 1, i) & "version.html"
      Exit For
    End If
  Next
  pGetVersionPage = rtn
End Function

Private Function pUpdateCatalogsCatalogo(ByRef db As cDataSource, _
                                         ByVal catw_id As Long, _
                                         ByVal htmlpage As String, _
                                         ByVal User As String, _
                                         ByVal pwd As String) As Boolean
  
  Dim CatalogWeb As cCatalogWeb
  Set CatalogWeb = New cCatalogWeb
  
  Dim version As String
  
  version = CatalogWeb.GetVersion(pGetVersionPage(htmlpage), _
                                  True, _
                                  User, _
                                  pwd)
  
  If version = vbNullString Then
    pSaveLog "No se pudo obtener la version del catalogo", True
    Exit Function
  ElseIf version <> "1" And version <> "2" Then
    pSaveLog "La version [" & version & "] del catalogo no esta soportada", True
    Exit Function
  End If
  
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  '--------------------------------------------
  '
  ' Productos
  '
  
  sqlstmt = "sp_srv_catalog_cscart_getproductos " & catw_id

  If Not db.OpenRs(rs, sqlstmt) Then
    pSaveLog "Obtener Productos Falló", True
    Exit Function
  End If
  
  pSaveLog "Productos cargados con éxito"
  
  If rs.EOF Then
    pSaveLog "No hay productos"
  End If
    
  Const c_max_len_inputs = 100
  
  Dim vsqlstmt_if(c_max_len_inputs) As String
  Dim vsqlstmt_update(c_max_len_inputs) As String
  Dim vsqlstmt_insert(c_max_len_inputs) As String

  Dim sqlstmt_if      As String
  Dim sqlstmt_update  As String
  Dim sqlstmt_insert  As String

  Dim n As Long

  '--------------------------------------------
  '
  ' cscart_products
  '
  Do While Not rs.EOF
  
    n = n + 1
  
    pSaveLog "Procesando Producto: " & db.ValField(rs.Fields.Item("pr_nombre")), , 10
  
    If version = "1" Then
  
      pProcessProducto1 db, _
                       sqlstmt_if, _
                       sqlstmt_update, _
                       sqlstmt_insert, _
                       rs
    
    ElseIf version = "2" Then
    
      pProcessProducto2 db, _
                       sqlstmt_if, _
                       sqlstmt_update, _
                       sqlstmt_insert, _
                       rs
    End If
    
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
  ' cscart_product_descriptions
  '
  n = 0
  
  If Not (rs.EOF And rs.BOF) Then
    rs.MoveFirst
  End If
  
  Do While Not rs.EOF
  
    n = n + 1
  
    pSaveLog "Procesando Descripción del Producto: " & db.ValField(rs.Fields.Item("pr_nombre"))
  
    pProcessProductoDescrip db, _
                            sqlstmt_if, _
                            sqlstmt_update, _
                            sqlstmt_insert, _
                            rs
    
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
  ' cscart_product_prices
  '
  n = 0
  
  If Not (rs.EOF And rs.BOF) Then
    rs.MoveFirst
  End If
  
  Do While Not rs.EOF
  
    n = n + 1
  
    pSaveLog "Procesando Precios del Producto: " & db.ValField(rs.Fields.Item("pr_nombre"))
  
    If version = "1" Then
      pProcessProductoPrice1 db, _
                            sqlstmt_if, _
                            sqlstmt_update, _
                            sqlstmt_insert, _
                            rs
                            
    ElseIf version = "2" Then
      pProcessProductoPrice2 db, _
                            sqlstmt_if, _
                            sqlstmt_update, _
                            sqlstmt_insert, _
                            rs
    End If
    
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
  ' cscart_products_taxes
  '
  n = 0
  
  If Not (rs.EOF And rs.BOF) Then
    rs.MoveFirst
  End If
  
  Do While Not rs.EOF
  
    n = n + 1
  
    pSaveLog "Procesando Tasas Impositivas del Producto: " & db.ValField(rs.Fields.Item("pr_nombre"))
  
    If version = "1" Then
      pProcessProductoTax1 db, _
                            sqlstmt_if, _
                            sqlstmt_update, _
                            sqlstmt_insert, _
                            rs
    ElseIf version = "2" Then
      pProcessProductoTax2 db, _
                            sqlstmt_if, _
                            sqlstmt_update, _
                            sqlstmt_insert, _
                            rs
    End If
    
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
  ' cscart_products_categories
  '
  n = 0
  
  sqlstmt = "sp_srv_catalog_cscart_getproductoCategorylinks " & catw_id

  If Not db.OpenRs(rs, sqlstmt) Then
    pSaveLog "Obtener Productos CategoryLink Falló", True
    Exit Function
  End If
  
  Dim last_pr_id As Long
  
  If Not (rs.EOF And rs.BOF) Then
    rs.MoveFirst
  End If
  
  Do While Not rs.EOF
  
    n = n + 1
  
    If last_pr_id <> rs.Fields.Item("pr_id").Value Then
    
      vsqlstmt_if(n) = "select product_id from cscart_products_categories where 1=2;"
      vsqlstmt_update(n) = ""
      vsqlstmt_insert(n) = "delete from cscart_products_categories where product_id = " & _
                                  "@@get_product_id(" & rs.Fields("pr_id").Value & ");"
        
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
    
      n = n + 1
      last_pr_id = rs.Fields.Item("pr_id").Value
    
    End If
    
    pSaveLog "Procesando Descripcion del Producto: " & db.ValField(rs.Fields.Item("pr_nombre"))
  
    pProcessProductoCategories db, _
                               sqlstmt_if, _
                               sqlstmt_update, _
                               sqlstmt_insert, _
                               rs
    
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
  n = 0
  
  sqlstmt = "sp_srv_catalog_getproductotags " & catw_id

  If Not db.OpenRs(rs, sqlstmt) Then
    pSaveLog "Obtener Productos Tag Falló", True
    Exit Function
  End If
  
  pSaveLog "Tags de Productos cargados con éxito"
  
  If rs.EOF Then
    pSaveLog "No hay tags de productos"
  End If
    
  last_pr_id = 0
    
  Do While Not rs.EOF
  
    n = n + 1
    
    pSaveLog "Procesando Tag: " & db.ValField(rs.Fields.Item("prt_texto"))
  
    If last_pr_id <> rs.Fields.Item("pr_id").Value Then
    
      vsqlstmt_if(n) = "select pr_id from productotag where 1=2;"
      vsqlstmt_update(n) = ""
      vsqlstmt_insert(n) = "delete from productotag where pr_id = " & rs.Fields("pr_id").Value & ";"
        
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
    
      n = n + 1
      last_pr_id = rs.Fields.Item("pr_id").Value
    
    End If
  
    pProcessProductoTag db, _
                        sqlstmt_if, _
                        sqlstmt_update, _
                        sqlstmt_insert, _
                        db.ValField(rs.Fields.Item("prt_id")), _
                        db.ValField(rs.Fields.Item("prt_texto")), _
                        db.ValField(rs.Fields.Item("pr_id")), _
                        db.ValField(rs.Fields.Item("exposicion_web")), _
                        db.ValField(rs.Fields.Item("pr_id_tag"))
        
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
    
  '--------------------------------------------
  '
  ' Marcas
  '
  n = 0
  
  sqlstmt = "sp_srv_catalog_getmarcas "

  If Not db.OpenRs(rs, sqlstmt) Then
    pSaveLog "Obtener Marcas", True
    Exit Function
  End If
  
  pSaveLog "Marcas cargadas con éxito"
  
  If rs.EOF Then
    pSaveLog "No hay marcas"
  End If
    
  Do While Not rs.EOF
  
    n = n + 1
    
    pSaveLog "Procesando Marcas: " & db.ValField(rs.Fields.Item("marc_nombre"))
  
    vsqlstmt_if(n) = "select marc_id from Marca where marc_id=" & db.ValField(rs.Fields.Item("marc_id")) & ";"
    vsqlstmt_update(n) = "update Marca Set " & _
                           "marc_nombre = " & db.sqlString(db.ValField(rs.Fields.Item("marc_nombre"))) & "," & _
                           "marc_texto_web = " & db.sqlString(db.ValField(rs.Fields.Item("marc_textoweb"))) & _
                         "where marc_id = " & db.ValField(rs.Fields.Item("marc_id")) & ";"
    vsqlstmt_insert(n) = "insert into Marca (marc_id, marc_nombre, marc_texto_web)" & " values(" & _
                           db.ValField(rs.Fields.Item("marc_id")) & "," & _
                           db.sqlString(db.ValField(rs.Fields.Item("marc_nombre"))) & "," & _
                           db.sqlString(db.ValField(rs.Fields.Item("marc_textoweb"))) & _
                         ");"
                    
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
  
  '--------------------------------------------
  '
  ' Marcas Categorias
  '
  n = 0
  
  sqlstmt = "sp_srv_catalog_getmarcacategoria " & catw_id

  If Not db.OpenRs(rs, sqlstmt) Then
    pSaveLog "Obtener Marcas y Categorias", True
    Exit Function
  End If
  
  pSaveLog "Marcas y categorias cargadas con éxito"
  
  If rs.EOF Then
    pSaveLog "No hay marcas y categorias"
  End If
    
  Do While Not rs.EOF
  
    n = n + 1
    
    pSaveLog "Procesando Marcas y Categorias: " & db.ValField(rs.Fields.Item("marc_nombre"))
  
    vsqlstmt_if(n) = "select marc_id from marcacategoria where marc_id=" & db.ValField(rs.Fields.Item("marc_id")) & " and rubti_id=" & db.ValField(rs.Fields.Item("rubti_id")) & ";"
    vsqlstmt_update(n) = "update marcacategoria Set " & _
                           "marc_nombre = " & db.sqlString(db.ValField(rs.Fields.Item("marc_nombre"))) & "," & _
                           "rubti_nombre = " & db.sqlString(db.ValField(rs.Fields.Item("rubti_nombre"))) & _
                         "where marc_id = " & db.ValField(rs.Fields.Item("marc_id")) & " and rubti_id=" & db.ValField(rs.Fields.Item("rubti_id")) & ";"
    vsqlstmt_insert(n) = "insert into marcacategoria (marc_id, marc_nombre, rubti_id, rubti_nombre)" & " values(" & _
                           db.ValField(rs.Fields.Item("marc_id")) & "," & _
                           db.sqlString(db.ValField(rs.Fields.Item("marc_nombre"))) & "," & _
                           db.ValField(rs.Fields.Item("rubti_id")) & "," & _
                           db.sqlString(db.ValField(rs.Fields.Item("rubti_nombre"))) & _
                         ");"
                    
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
  
  '--------------------------------------------
  '
  ' cscart_product_images
  '
  n = 0
  
  sqlstmt = "sp_srv_catalog_cscart_getproductoimages " & catw_id

  If Not db.OpenRs(rs, sqlstmt) Then
    pSaveLog "Obtener Productos Image Falló", True
    Exit Function
  End If
  
  pSaveLog "Images de Productos cargadas con éxito"
  
  If rs.EOF Then
    pSaveLog "No hay images de productos"
  End If
    
  Do While Not rs.EOF
  
    pSaveLog "Procesando Images: " & db.ValField(rs.Fields.Item("prwi_archivo"))
          
    If version = "1" Then
          
      ' La pagina de carga de imagenes se debe llamar
      ' igual que la de sentencias mas el postfijo _image
      '
      pProcessProductoImage1 CatalogWeb, _
                            Left(htmlpage, Len(htmlpage) - 4) & "_image.php", _
                            User, _
                            pwd, _
                            db.ValField(rs.Fields.Item("imageFile"))

    ElseIf version = "2" Then
    
      pProcessProductoImage2 CatalogWeb, _
                            Left(htmlpage, Len(htmlpage) - 4) & "_image.php", _
                            User, _
                            pwd, _
                            db.ValField(rs.Fields.Item("imageFile"))
    
    End If
    
    If gClose Then Exit Do
    
    rs.MoveNext
  Loop
  
  If version = "2" Then

    If Not (rs.EOF And rs.BOF) Then
      rs.MoveFirst
    End If

    Dim FileName As String
    
    n = 0
    
    Do While Not rs.EOF
    
      n = n + 1
      FileName = db.sqlString(pGetFileName(db.ValField(rs.Fields.Item("imageFile"))))
    
      vsqlstmt_if(n) = "select image_id from cscart_images where image_path=" & FileName & ";"
      vsqlstmt_update(n) = "update cscart_images set image_path = image_path where image_path = " & FileName & ";"
      vsqlstmt_insert(n) = "insert into cscart_images(image_path,image_x,image_y,alt)" & _
                                      " values (" & FileName & ",0,0,'');"
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
  
  End If
  
  '--------------------------------------------
  '
  ' cscart_product_images_links
  '
  n = 0
  
  sqlstmt = "sp_srv_catalog_cscart_getproductoimageslinks " & catw_id

  If Not db.OpenRs(rs, sqlstmt) Then
    pSaveLog "Obtener Productos ImageLink Falló", True
    Exit Function
  End If
  
  pSaveLog "ImageLink de Productos cargados con éxito"
  
  If rs.EOF Then
    pSaveLog "No hay ImageLink de productos"
  End If
  
  last_pr_id = 0
  
  Do While Not rs.EOF
  
    n = n + 1
  
    If last_pr_id <> rs.Fields.Item("pr_id").Value Then
    
      If version = "1" Then
    
        vsqlstmt_if(n) = "select product_id from cscart_product_images_links where 1=2;"
        vsqlstmt_update(n) = ""
        vsqlstmt_insert(n) = "delete from cscart_product_images_links where product_id = " & _
                                    "@@get_product_id(" & rs.Fields("pr_id").Value & ");"
        
      ElseIf version = "2" Then
      
        vsqlstmt_if(n) = "select product_id from cscart_images_links where 1=2;"
        vsqlstmt_update(n) = ""
        vsqlstmt_insert(n) = "delete from cscart_images_links where object_id = " & _
                                    "@@get_product_id(" & rs.Fields("pr_id").Value & ")" & _
                                    " and object_type = 'product';"
      
      End If
        
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
    
      n = n + 1
      last_pr_id = rs.Fields.Item("pr_id").Value
    
    End If
  
    pSaveLog "Procesando Link a Imagenes del Producto: " & db.ValField(rs.Fields.Item("pr_nombre"))
  
    If version = "1" Then
      pProcessProductoImagesLink1 db, _
                                 sqlstmt_if, _
                                 sqlstmt_update, _
                                 sqlstmt_insert, _
                                 rs
    ElseIf version = "2" Then
      pProcessProductoImagesLink2 db, _
                                 sqlstmt_if, _
                                 sqlstmt_update, _
                                 sqlstmt_insert, _
                                 rs
    End If
    
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
  
  ' FIN
  '
  '----------------------------------------------------
  
  CatalogWeb.DestroyFormWeb

End Function

Private Function pProcessProducto1(ByRef db As cDataSource, _
                                   ByRef sqlstmt_if As String, _
                                   ByRef sqlstmt_update As String, _
                                   ByRef sqlstmt_insert As String, _
                                   ByRef rs As ADODB.Recordset) As Boolean
  
  sqlstmt_if = "select pr_id from cscart_products where pr_id = " & rs.Fields("pr_id").Value & ";"
  
  sqlstmt_update = "update cscart_products "
  sqlstmt_update = sqlstmt_update & "set "
  sqlstmt_update = sqlstmt_update & " product_code= " & db.sqlString(db.ValField(rs.Fields("product_code"))) & ","
  sqlstmt_update = sqlstmt_update & " product_type= " & db.sqlString(db.ValField(rs.Fields("product_type"))) & ","
  sqlstmt_update = sqlstmt_update & " owner_id= " & db.sqlNumber(db.ValField(rs.Fields("owner_id"))) & ","
  sqlstmt_update = sqlstmt_update & " avail= " & db.sqlString(db.ValField(rs.Fields("avail"))) & ","
  sqlstmt_update = sqlstmt_update & " manufacturer_id= " & db.sqlNumber(db.ValField(rs.Fields("manufacturer_id"))) & ","
  sqlstmt_update = sqlstmt_update & " list_price= " & db.sqlNumber(db.ValField(rs.Fields("list_price"))) & ","
  sqlstmt_update = sqlstmt_update & " amount= " & db.sqlNumber(db.ValField(rs.Fields("amount"))) & ","
  sqlstmt_update = sqlstmt_update & " min_amount= " & db.sqlNumber(db.ValField(rs.Fields("min_amount"))) & ","
  sqlstmt_update = sqlstmt_update & " weight= " & db.sqlNumber(db.ValField(rs.Fields("weight"))) & ","
  sqlstmt_update = sqlstmt_update & " length= " & db.sqlNumber(db.ValField(rs.Fields("length"))) & ","
  sqlstmt_update = sqlstmt_update & " width= " & db.sqlNumber(db.ValField(rs.Fields("width"))) & ","
  sqlstmt_update = sqlstmt_update & " height= " & db.sqlNumber(db.ValField(rs.Fields("height"))) & ","
  sqlstmt_update = sqlstmt_update & " shipping_freight= " & db.sqlNumber(db.ValField(rs.Fields("shipping_freight"))) & ","
  sqlstmt_update = sqlstmt_update & " low_avail_limit= " & db.sqlNumber(db.ValField(rs.Fields("low_avail_limit"))) & ","
  sqlstmt_update = sqlstmt_update & " timestamp= " & db.sqlNumber(db.ValField(rs.Fields("timestamp"))) & ","
  sqlstmt_update = sqlstmt_update & " is_edp= " & db.sqlString(db.ValField(rs.Fields("is_edp"))) & ","
  sqlstmt_update = sqlstmt_update & " edp_shipping= " & db.sqlString(db.ValField(rs.Fields("edp_shipping"))) & ","
  sqlstmt_update = sqlstmt_update & " tracking= " & db.sqlString(db.ValField(rs.Fields("tracking"))) & ","
  sqlstmt_update = sqlstmt_update & " free_shipping= " & db.sqlString(db.ValField(rs.Fields("free_shipping"))) & ","
  sqlstmt_update = sqlstmt_update & " feature_comparison= " & db.sqlString(db.ValField(rs.Fields("feature_comparison"))) & ","
  sqlstmt_update = sqlstmt_update & " zero_price_action= " & db.sqlString(db.ValField(rs.Fields("zero_price_action"))) & ","
  sqlstmt_update = sqlstmt_update & " is_pbp= " & db.sqlString(db.ValField(rs.Fields("is_pbp"))) & ","
  sqlstmt_update = sqlstmt_update & " is_op= " & db.sqlString(db.ValField(rs.Fields("is_op"))) & ","
  sqlstmt_update = sqlstmt_update & " is_oper= " & db.sqlString(db.ValField(rs.Fields("is_oper"))) & ","
  sqlstmt_update = sqlstmt_update & " supplier_id= " & db.sqlNumber(db.ValField(rs.Fields("supplier_id"))) & ","
  sqlstmt_update = sqlstmt_update & " is_returnable= " & db.sqlString(db.ValField(rs.Fields("is_returnable"))) & ","
  sqlstmt_update = sqlstmt_update & " return_period= " & db.sqlNumber(db.ValField(rs.Fields("return_period"))) & ","
    
  sqlstmt_update = sqlstmt_update & " pr_aliasweb= " & db.sqlString(db.ValField(rs.Fields("pr_aliasweb"))) & ","
  sqlstmt_update = sqlstmt_update & " pr_codigopadre= " & db.sqlString(db.ValField(rs.Fields("pr_codigopadre"))) & ","
  sqlstmt_update = sqlstmt_update & " pr_marca= " & db.sqlString(db.ValField(rs.Fields("pr_marca"))) & ","
  sqlstmt_update = sqlstmt_update & " pr_iva= " & db.sqlNumber(db.ValField(rs.Fields("pr_iva"))) & ","
  sqlstmt_update = sqlstmt_update & " activo= " & db.ValField(rs.Fields("activo")) & ","
  
  sqlstmt_update = sqlstmt_update & " exposicion_web= " & db.sqlNumber(db.ValField(rs.Fields("exposicion_web"))) & ","
  sqlstmt_update = sqlstmt_update & " rubro= " & db.sqlString(db.ValField(rs.Fields("rubro"))) & ","
  sqlstmt_update = sqlstmt_update & " venta_maxima= " & db.sqlNumber(db.ValField(rs.Fields("venta_maxima"))) & ","
  
  sqlstmt_update = sqlstmt_update & " atributo01= " & db.sqlString(db.ValField(rs.Fields("atributo01"))) & ","
  sqlstmt_update = sqlstmt_update & " atributo02= " & db.sqlString(db.ValField(rs.Fields("atributo02"))) & ","
  sqlstmt_update = sqlstmt_update & " atributo03= " & db.sqlString(db.ValField(rs.Fields("atributo03"))) & ","
  sqlstmt_update = sqlstmt_update & " atributo04= " & db.sqlString(db.ValField(rs.Fields("atributo04"))) & ","
  sqlstmt_update = sqlstmt_update & " atributo05= " & db.sqlString(db.ValField(rs.Fields("atributo05"))) & ","
  sqlstmt_update = sqlstmt_update & " atributo06= " & db.sqlString(db.ValField(rs.Fields("atributo06"))) & ","
  sqlstmt_update = sqlstmt_update & " atributo07= " & db.sqlString(db.ValField(rs.Fields("atributo07"))) & ","
  sqlstmt_update = sqlstmt_update & " atributo08= " & db.sqlString(db.ValField(rs.Fields("atributo08"))) & ","
  sqlstmt_update = sqlstmt_update & " atributo09= " & db.sqlString(db.ValField(rs.Fields("atributo09"))) & ","
  sqlstmt_update = sqlstmt_update & " atributo10= " & db.sqlString(db.ValField(rs.Fields("atributo10"))) & ","
  sqlstmt_update = sqlstmt_update & " referidos= " & db.sqlString(db.ValField(rs.Fields("referidos")))
  
  sqlstmt_update = sqlstmt_update & " where pr_id = " & rs.Fields("pr_id").Value & ";"

  sqlstmt_insert = "insert into cscart_products(pr_id,product_code,product_type,owner_id,avail,manufacturer_id,list_price,amount,min_amount,weight,length,width,height,shipping_freight,low_avail_limit,timestamp,is_edp,edp_shipping,tracking,free_shipping,feature_comparison,zero_price_action,is_pbp,is_op,is_oper,supplier_id,is_returnable,return_period,pr_aliasweb,pr_codigopadre,pr_marca,pr_iva,activo,exposicion_web,rubro,venta_maxima,atributo01,atributo02,atributo03,atributo04,atributo05,atributo06,atributo07,atributo08,atributo09,atributo10,referidos)"
  sqlstmt_insert = sqlstmt_insert & " values ("
  sqlstmt_insert = sqlstmt_insert & rs.Fields("pr_id").Value & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlString(db.ValField(rs.Fields("product_code"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlString(db.ValField(rs.Fields("product_type"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlNumber(db.ValField(rs.Fields("owner_id"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlString(db.ValField(rs.Fields("avail"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlNumber(db.ValField(rs.Fields("manufacturer_id"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlNumber(db.ValField(rs.Fields("list_price"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlNumber(db.ValField(rs.Fields("amount"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlNumber(db.ValField(rs.Fields("min_amount"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlNumber(db.ValField(rs.Fields("weight"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlNumber(db.ValField(rs.Fields("length"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlNumber(db.ValField(rs.Fields("width"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlNumber(db.ValField(rs.Fields("height"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlNumber(db.ValField(rs.Fields("shipping_freight"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlNumber(db.ValField(rs.Fields("low_avail_limit"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlNumber(db.ValField(rs.Fields("timestamp"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlString(db.ValField(rs.Fields("is_edp"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlString(db.ValField(rs.Fields("edp_shipping"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlString(db.ValField(rs.Fields("tracking"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlString(db.ValField(rs.Fields("free_shipping"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlString(db.ValField(rs.Fields("feature_comparison"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlString(db.ValField(rs.Fields("zero_price_action"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlString(db.ValField(rs.Fields("is_pbp"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlString(db.ValField(rs.Fields("is_op"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlString(db.ValField(rs.Fields("is_oper"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlNumber(db.ValField(rs.Fields("supplier_id"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlString(db.ValField(rs.Fields("is_returnable"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlNumber(db.ValField(rs.Fields("return_period"))) & ","
  
  sqlstmt_insert = sqlstmt_insert & db.sqlString(db.ValField(rs.Fields("pr_aliasweb"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlString(db.ValField(rs.Fields("pr_codigopadre"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlString(db.ValField(rs.Fields("pr_marca"))) & ","
  
  sqlstmt_insert = sqlstmt_insert & db.sqlNumber(db.ValField(rs.Fields("pr_iva"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.ValField(rs.Fields("activo")) & ","
  
  
  sqlstmt_insert = sqlstmt_insert & db.sqlNumber(db.ValField(rs.Fields("exposicion_web"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlString(db.ValField(rs.Fields("rubro"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlNumber(db.ValField(rs.Fields("venta_maxima"))) & ","
  
  sqlstmt_insert = sqlstmt_insert & db.sqlString(db.ValField(rs.Fields("atributo01"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlString(db.ValField(rs.Fields("atributo02"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlString(db.ValField(rs.Fields("atributo03"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlString(db.ValField(rs.Fields("atributo04"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlString(db.ValField(rs.Fields("atributo05"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlString(db.ValField(rs.Fields("atributo06"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlString(db.ValField(rs.Fields("atributo07"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlString(db.ValField(rs.Fields("atributo08"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlString(db.ValField(rs.Fields("atributo09"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlString(db.ValField(rs.Fields("atributo10"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlString(db.ValField(rs.Fields("referidos")))
  
  sqlstmt_insert = sqlstmt_insert & ");"

  pProcessProducto1 = True
  
End Function

Private Function pProcessProducto2(ByRef db As cDataSource, _
                                   ByRef sqlstmt_if As String, _
                                   ByRef sqlstmt_update As String, _
                                   ByRef sqlstmt_insert As String, _
                                   ByRef rs As ADODB.Recordset) As Boolean
  
  Dim status As String
  If db.ValField(rs.Fields("avail")) = "Y" Then
    status = "A"
  Else
    status = "D"
  End If
  
  sqlstmt_if = "select pr_id from cscart_products where pr_id = " & rs.Fields("pr_id").Value & ";"
  
  sqlstmt_update = "update cscart_products "
  sqlstmt_update = sqlstmt_update & "set "
  sqlstmt_update = sqlstmt_update & " product_code= " & db.sqlString(db.ValField(rs.Fields("product_code"))) & ","
  sqlstmt_update = sqlstmt_update & " product_type= " & db.sqlString(db.ValField(rs.Fields("product_type"))) & ","
  sqlstmt_update = sqlstmt_update & " owner_id= " & db.sqlNumber(db.ValField(rs.Fields("owner_id"))) & ","
  sqlstmt_update = sqlstmt_update & " status= " & db.sqlString(status) & ","
  sqlstmt_update = sqlstmt_update & " list_price= " & db.sqlNumber(db.ValField(rs.Fields("list_price"))) & ","
  sqlstmt_update = sqlstmt_update & " amount= " & db.sqlNumber(db.ValField(rs.Fields("amount"))) & ","
  sqlstmt_update = sqlstmt_update & " min_amount= " & db.sqlNumber(db.ValField(rs.Fields("min_amount"))) & ","
  sqlstmt_update = sqlstmt_update & " weight= " & db.sqlNumber(db.ValField(rs.Fields("weight"))) & ","
  sqlstmt_update = sqlstmt_update & " length= " & db.sqlNumber(db.ValField(rs.Fields("length"))) & ","
  sqlstmt_update = sqlstmt_update & " width= " & db.sqlNumber(db.ValField(rs.Fields("width"))) & ","
  sqlstmt_update = sqlstmt_update & " height= " & db.sqlNumber(db.ValField(rs.Fields("height"))) & ","
  sqlstmt_update = sqlstmt_update & " shipping_freight= " & db.sqlNumber(db.ValField(rs.Fields("shipping_freight"))) & ","
  sqlstmt_update = sqlstmt_update & " low_avail_limit= " & db.sqlNumber(db.ValField(rs.Fields("low_avail_limit"))) & ","
  sqlstmt_update = sqlstmt_update & " timestamp= " & db.sqlNumber(db.ValField(rs.Fields("timestamp"))) & ","
  sqlstmt_update = sqlstmt_update & " is_edp= " & db.sqlString(db.ValField(rs.Fields("is_edp"))) & ","
  sqlstmt_update = sqlstmt_update & " edp_shipping= " & db.sqlString(db.ValField(rs.Fields("edp_shipping"))) & ","
  sqlstmt_update = sqlstmt_update & " tracking= " & db.sqlString(db.ValField(rs.Fields("tracking"))) & ","
  sqlstmt_update = sqlstmt_update & " free_shipping= " & db.sqlString(db.ValField(rs.Fields("free_shipping"))) & ","
  sqlstmt_update = sqlstmt_update & " feature_comparison= " & db.sqlString(db.ValField(rs.Fields("feature_comparison"))) & ","
  sqlstmt_update = sqlstmt_update & " zero_price_action= " & db.sqlString(db.ValField(rs.Fields("zero_price_action"))) & ","
  sqlstmt_update = sqlstmt_update & " is_pbp= " & db.sqlString(db.ValField(rs.Fields("is_pbp"))) & ","
  sqlstmt_update = sqlstmt_update & " is_op= " & db.sqlString(db.ValField(rs.Fields("is_op"))) & ","
  sqlstmt_update = sqlstmt_update & " is_oper= " & db.sqlString(db.ValField(rs.Fields("is_oper"))) & ","
  sqlstmt_update = sqlstmt_update & " supplier_id= " & db.sqlNumber(db.ValField(rs.Fields("supplier_id"))) & ","
  sqlstmt_update = sqlstmt_update & " is_returnable= " & db.sqlString(db.ValField(rs.Fields("is_returnable"))) & ","
  sqlstmt_update = sqlstmt_update & " return_period= " & db.sqlNumber(db.ValField(rs.Fields("return_period"))) & ","
    
  sqlstmt_update = sqlstmt_update & " pr_aliasweb= " & db.sqlString(db.ValField(rs.Fields("pr_aliasweb"))) & ","
  sqlstmt_update = sqlstmt_update & " pr_codigopadre= " & db.sqlString(db.ValField(rs.Fields("pr_codigopadre"))) & ","
  sqlstmt_update = sqlstmt_update & " pr_marca= " & db.sqlString(db.ValField(rs.Fields("pr_marca"))) & ","
  sqlstmt_update = sqlstmt_update & " pr_iva= " & db.sqlNumber(db.ValField(rs.Fields("pr_iva"))) & ","
  sqlstmt_update = sqlstmt_update & " activo= " & db.ValField(rs.Fields("activo")) & ","
  
  sqlstmt_update = sqlstmt_update & " exposicion_web= " & db.sqlNumber(db.ValField(rs.Fields("exposicion_web"))) & ","
  sqlstmt_update = sqlstmt_update & " rubro= " & db.sqlString(db.ValField(rs.Fields("rubro"))) & ","
  sqlstmt_update = sqlstmt_update & " venta_maxima= " & db.sqlNumber(db.ValField(rs.Fields("venta_maxima"))) & ","
  
  sqlstmt_update = sqlstmt_update & " atributo01= " & db.sqlString(db.ValField(rs.Fields("atributo01"))) & ","
  sqlstmt_update = sqlstmt_update & " atributo02= " & db.sqlString(db.ValField(rs.Fields("atributo02"))) & ","
  sqlstmt_update = sqlstmt_update & " atributo03= " & db.sqlString(db.ValField(rs.Fields("atributo03"))) & ","
  sqlstmt_update = sqlstmt_update & " atributo04= " & db.sqlString(db.ValField(rs.Fields("atributo04"))) & ","
  sqlstmt_update = sqlstmt_update & " atributo05= " & db.sqlString(db.ValField(rs.Fields("atributo05"))) & ","
  sqlstmt_update = sqlstmt_update & " atributo06= " & db.sqlString(db.ValField(rs.Fields("atributo06"))) & ","
  sqlstmt_update = sqlstmt_update & " atributo07= " & db.sqlString(db.ValField(rs.Fields("atributo07"))) & ","
  sqlstmt_update = sqlstmt_update & " atributo08= " & db.sqlString(db.ValField(rs.Fields("atributo08"))) & ","
  sqlstmt_update = sqlstmt_update & " atributo09= " & db.sqlString(db.ValField(rs.Fields("atributo09"))) & ","
  sqlstmt_update = sqlstmt_update & " atributo10= " & db.sqlString(db.ValField(rs.Fields("atributo10"))) & ","
  sqlstmt_update = sqlstmt_update & " referidos= " & db.sqlString(db.ValField(rs.Fields("referidos")))
  sqlstmt_update = sqlstmt_update & " ,usergroup_ids= '', unlimited_download = 'N', avail_since = 0, buy_in_advance = 'N', localization= '', min_qty = 0, max_qty = 0, qty_step = 0, list_qty_count = 0, age_verification = 'N', age_limit = 0"
  
  sqlstmt_update = sqlstmt_update & " where pr_id = " & rs.Fields("pr_id").Value & ";"

  sqlstmt_insert = "insert into cscart_products(pr_id,product_code,product_type,owner_id,status,list_price,amount,min_amount,weight,length,width,height,shipping_freight,low_avail_limit,timestamp,is_edp,edp_shipping,tracking,free_shipping,feature_comparison,zero_price_action,is_pbp,is_op,is_oper,supplier_id,is_returnable,return_period,pr_aliasweb,pr_codigopadre,pr_marca,pr_iva,activo,exposicion_web,rubro,venta_maxima,atributo01,atributo02,atributo03,atributo04,atributo05,atributo06,atributo07,atributo08,atributo09,atributo10,referidos,usergroup_ids,unlimited_download," & _
                    "avail_since, " & _
                    "buy_in_advance, " & _
                    "localization, " & _
                    "min_qty, " & _
                    "max_qty, " & _
                    "qty_step, " & _
                    "list_qty_count, " & _
                    "tax_ids, " & _
                    "age_verification, " & _
                    "age_limit)"
                    
  sqlstmt_insert = sqlstmt_insert & " values ("
  sqlstmt_insert = sqlstmt_insert & rs.Fields("pr_id").Value & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlString(db.ValField(rs.Fields("product_code"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlString(db.ValField(rs.Fields("product_type"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlNumber(db.ValField(rs.Fields("owner_id"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlString(status) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlNumber(db.ValField(rs.Fields("list_price"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlNumber(db.ValField(rs.Fields("amount"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlNumber(db.ValField(rs.Fields("min_amount"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlNumber(db.ValField(rs.Fields("weight"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlNumber(db.ValField(rs.Fields("length"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlNumber(db.ValField(rs.Fields("width"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlNumber(db.ValField(rs.Fields("height"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlNumber(db.ValField(rs.Fields("shipping_freight"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlNumber(db.ValField(rs.Fields("low_avail_limit"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlNumber(db.ValField(rs.Fields("timestamp"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlString(db.ValField(rs.Fields("is_edp"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlString(db.ValField(rs.Fields("edp_shipping"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlString(db.ValField(rs.Fields("tracking"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlString(db.ValField(rs.Fields("free_shipping"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlString(db.ValField(rs.Fields("feature_comparison"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlString(db.ValField(rs.Fields("zero_price_action"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlString(db.ValField(rs.Fields("is_pbp"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlString(db.ValField(rs.Fields("is_op"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlString(db.ValField(rs.Fields("is_oper"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlNumber(db.ValField(rs.Fields("supplier_id"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlString(db.ValField(rs.Fields("is_returnable"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlNumber(db.ValField(rs.Fields("return_period"))) & ","
  
  sqlstmt_insert = sqlstmt_insert & db.sqlString(db.ValField(rs.Fields("pr_aliasweb"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlString(db.ValField(rs.Fields("pr_codigopadre"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlString(db.ValField(rs.Fields("pr_marca"))) & ","
  
  sqlstmt_insert = sqlstmt_insert & db.sqlNumber(db.ValField(rs.Fields("pr_iva"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.ValField(rs.Fields("activo")) & ","
  
  
  sqlstmt_insert = sqlstmt_insert & db.sqlNumber(db.ValField(rs.Fields("exposicion_web"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlString(db.ValField(rs.Fields("rubro"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlNumber(db.ValField(rs.Fields("venta_maxima"))) & ","
  
  sqlstmt_insert = sqlstmt_insert & db.sqlString(db.ValField(rs.Fields("atributo01"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlString(db.ValField(rs.Fields("atributo02"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlString(db.ValField(rs.Fields("atributo03"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlString(db.ValField(rs.Fields("atributo04"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlString(db.ValField(rs.Fields("atributo05"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlString(db.ValField(rs.Fields("atributo06"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlString(db.ValField(rs.Fields("atributo07"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlString(db.ValField(rs.Fields("atributo08"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlString(db.ValField(rs.Fields("atributo09"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlString(db.ValField(rs.Fields("atributo10"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlString(db.ValField(rs.Fields("referidos")))
  
  sqlstmt_insert = sqlstmt_insert & ",'','N'," & _
                    "0, " & _
                    "'N', " & _
                    "'', " & _
                    "0, " & _
                    "0, " & _
                    "0, " & _
                    "0, " & _
                    "'', " & _
                    "'N', " & _
                    "0);"

  pProcessProducto2 = True
  
End Function

Private Function pProcessProductoDescrip(ByRef db As cDataSource, _
                                         ByRef sqlstmt_if As String, _
                                         ByRef sqlstmt_update As String, _
                                         ByRef sqlstmt_insert As String, _
                                         ByRef rs As ADODB.Recordset) As Boolean
  
  sqlstmt_if = "select product_id from cscart_product_descriptions where product_id = @@get_product_id(" & rs.Fields("pr_id").Value & ");"
  
  sqlstmt_update = "update cscart_product_descriptions "
  sqlstmt_update = sqlstmt_update & "set "
  sqlstmt_update = sqlstmt_update & "lang_code= " & db.sqlString(db.ValField(rs.Fields("lang_code"))) & ","
  sqlstmt_update = sqlstmt_update & "product= " & db.sqlString(db.ValField(rs.Fields("product"))) & ","
  sqlstmt_update = sqlstmt_update & "shortname= " & db.sqlString(db.ValField(rs.Fields("shortname"))) & ","
  sqlstmt_update = sqlstmt_update & "short_description= " & db.sqlString(db.ValField(rs.Fields("short_description"))) & ","
  sqlstmt_update = sqlstmt_update & "full_description= " & db.sqlString(db.ValField(rs.Fields("full_description"))) & ","
  sqlstmt_update = sqlstmt_update & "meta_keywords= " & db.sqlString(db.ValField(rs.Fields("meta_keywords"))) & ","
  sqlstmt_update = sqlstmt_update & "meta_description= " & db.sqlString(db.ValField(rs.Fields("meta_description"))) & ","
  sqlstmt_update = sqlstmt_update & "search_words= " & db.sqlString(db.ValField(rs.Fields("search_words"))) & ","
  sqlstmt_update = sqlstmt_update & "page_title= " & db.sqlString(db.ValField(rs.Fields("page_title")))
  sqlstmt_update = sqlstmt_update & " where product_id = @@get_product_id(" & rs.Fields("pr_id").Value & ");"

  sqlstmt_insert = "insert into cscart_product_descriptions(product_id,lang_code,product,shortname,short_description,full_description,meta_keywords,meta_description,search_words,page_title)"
  sqlstmt_insert = sqlstmt_insert & " values ("
  sqlstmt_insert = sqlstmt_insert & "@@get_product_id(" & rs.Fields("pr_id").Value & "),"
  sqlstmt_insert = sqlstmt_insert & db.sqlString(db.ValField(rs.Fields("lang_code"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlString(db.ValField(rs.Fields("product"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlString(db.ValField(rs.Fields("shortname"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlString(db.ValField(rs.Fields("short_description"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlString(db.ValField(rs.Fields("full_description"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlString(db.ValField(rs.Fields("meta_keywords"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlString(db.ValField(rs.Fields("meta_description"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlString(db.ValField(rs.Fields("search_words"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlString(db.ValField(rs.Fields("page_title")))
  sqlstmt_insert = sqlstmt_insert & ");"

  pProcessProductoDescrip = True
  
End Function

Private Function pProcessProductoPrice1(ByRef db As cDataSource, _
                                       ByRef sqlstmt_if As String, _
                                       ByRef sqlstmt_update As String, _
                                       ByRef sqlstmt_insert As String, _
                                       ByRef rs As ADODB.Recordset) As Boolean
  
  sqlstmt_if = "select product_id from cscart_product_prices where product_id = @@get_product_id(" & rs.Fields("pr_id").Value & ");"
  
  sqlstmt_update = "update cscart_product_prices "
  sqlstmt_update = sqlstmt_update & "set "
  sqlstmt_update = sqlstmt_update & "price= " & db.sqlNumber(db.ValField(rs.Fields("price"))) & ","
  sqlstmt_update = sqlstmt_update & "lower_limit= " & db.sqlNumber(db.ValField(rs.Fields("lower_limit")))
  sqlstmt_update = sqlstmt_update & " where product_id = @@get_product_id(" & rs.Fields("pr_id").Value & ") and membership_id = 0;"

  sqlstmt_insert = "insert into cscart_product_prices(product_id,price,lower_limit,membership_id)"
  sqlstmt_insert = sqlstmt_insert & " values ("
  sqlstmt_insert = sqlstmt_insert & "@@get_product_id(" & rs.Fields("pr_id").Value & "),"
  sqlstmt_insert = sqlstmt_insert & db.sqlNumber(rs.Fields("price")) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlNumber(rs.Fields("lower_limit")) & ","
  sqlstmt_insert = sqlstmt_insert & "0"
  sqlstmt_insert = sqlstmt_insert & ");"

  pProcessProductoPrice1 = True
  
End Function

Private Function pProcessProductoPrice2(ByRef db As cDataSource, _
                                       ByRef sqlstmt_if As String, _
                                       ByRef sqlstmt_update As String, _
                                       ByRef sqlstmt_insert As String, _
                                       ByRef rs As ADODB.Recordset) As Boolean
  
  sqlstmt_if = "select product_id from cscart_product_prices where product_id = @@get_product_id(" & rs.Fields("pr_id").Value & ");"
  
  sqlstmt_update = "update cscart_product_prices "
  sqlstmt_update = sqlstmt_update & "set "
  sqlstmt_update = sqlstmt_update & "price= " & db.sqlNumber(db.ValField(rs.Fields("price"))) & ","
  sqlstmt_update = sqlstmt_update & "lower_limit= " & db.sqlNumber(db.ValField(rs.Fields("lower_limit")))
  sqlstmt_update = sqlstmt_update & " where product_id = @@get_product_id(" & rs.Fields("pr_id").Value & ");"

  sqlstmt_insert = "insert into cscart_product_prices(product_id,price,lower_limit,usergroup_id)"
  sqlstmt_insert = sqlstmt_insert & " values ("
  sqlstmt_insert = sqlstmt_insert & "@@get_product_id(" & rs.Fields("pr_id").Value & "),"
  sqlstmt_insert = sqlstmt_insert & db.sqlNumber(rs.Fields("price")) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlNumber(rs.Fields("lower_limit")) & ","
  sqlstmt_insert = sqlstmt_insert & "0"
  sqlstmt_insert = sqlstmt_insert & ");"

  pProcessProductoPrice2 = True
  
End Function

Private Function pProcessProductoTax1(ByRef db As cDataSource, _
                                       ByRef sqlstmt_if As String, _
                                       ByRef sqlstmt_update As String, _
                                       ByRef sqlstmt_insert As String, _
                                       ByRef rs As ADODB.Recordset) As Boolean
  
  sqlstmt_if = "select product_id from cscart_products_taxes where product_id = @@get_product_id(" & rs.Fields("pr_id").Value & ");"
  
  sqlstmt_update = "update cscart_products_taxes "
  sqlstmt_update = sqlstmt_update & "set "
  sqlstmt_update = sqlstmt_update & "tax_id= @@get_tax_id(" & db.sqlNumber(db.ValField(rs.Fields("pr_iva"))) & "),"
  sqlstmt_update = sqlstmt_update & " where product_id = @@get_product_id(" & rs.Fields("pr_id").Value & ");"

  sqlstmt_insert = "insert into cscart_products_taxes(product_id,tax_id)"
  sqlstmt_insert = sqlstmt_insert & " values ("
  sqlstmt_insert = sqlstmt_insert & "@@get_product_id(" & rs.Fields("pr_id").Value & "),"
  sqlstmt_insert = sqlstmt_insert & "@@get_tax_id(" & db.sqlNumber(db.ValField(rs.Fields("pr_iva"))) & ")"
  sqlstmt_insert = sqlstmt_insert & ");"

  pProcessProductoTax1 = True
  
End Function

Private Function pProcessProductoTax2(ByRef db As cDataSource, _
                                       ByRef sqlstmt_if As String, _
                                       ByRef sqlstmt_update As String, _
                                       ByRef sqlstmt_insert As String, _
                                       ByRef rs As ADODB.Recordset) As Boolean
  
  sqlstmt_if = "select product_id from cscart_products where product_id = @@get_product_id(" & rs.Fields("pr_id").Value & ");"
  
  sqlstmt_update = "update cscart_products "
  sqlstmt_update = sqlstmt_update & "set "
  sqlstmt_update = sqlstmt_update & "tax_ids= @@get_tax_id(" & db.sqlNumber(db.ValField(rs.Fields("pr_iva"))) & ")"
  sqlstmt_update = sqlstmt_update & " where product_id = @@get_product_id(" & rs.Fields("pr_id").Value & ");"

  sqlstmt_insert = "select 1"

  pProcessProductoTax2 = True
  
End Function

Private Function pProcessProductoCategories(ByRef db As cDataSource, _
                                            ByRef sqlstmt_if As String, _
                                            ByRef sqlstmt_update As String, _
                                            ByRef sqlstmt_insert As String, _
                                            ByRef rs As ADODB.Recordset) As Boolean
                                    
  sqlstmt_if = "select product_id from cscart_products_categories "
  sqlstmt_if = sqlstmt_if & "where product_id = @@get_product_id(" & rs.Fields("pr_id").Value & ")"
  sqlstmt_if = sqlstmt_if & " and category_id = " & rs.Fields("category_id") & ";"
  
  sqlstmt_update = "update cscart_products_categories "
  sqlstmt_update = sqlstmt_update & "set "
  sqlstmt_update = sqlstmt_update & "link_type= " & db.sqlString(db.ValField(rs.Fields("link_type"))) & ","
  sqlstmt_update = sqlstmt_update & "position= " & db.sqlString(db.ValField(rs.Fields("position"))) & ","
  sqlstmt_update = sqlstmt_update & " where product_id = @@get_product_id(" & rs.Fields("pr_id").Value & ");"

  sqlstmt_insert = "insert into cscart_products_categories(product_id,category_id,link_type,position)"
  sqlstmt_insert = sqlstmt_insert & " values ("
  sqlstmt_insert = sqlstmt_insert & "@@get_product_id(" & rs.Fields("pr_id").Value & "),"
  sqlstmt_insert = sqlstmt_insert & rs.Fields("category_id").Value & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlString(db.ValField(rs.Fields("link_type"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.ValField(rs.Fields("position"))
  sqlstmt_insert = sqlstmt_insert & ");"

  pProcessProductoCategories = True
  
End Function

Private Function pProcessProductoImagesLink1(ByRef db As cDataSource, _
                                            ByRef sqlstmt_if As String, _
                                            ByRef sqlstmt_update As String, _
                                            ByRef sqlstmt_insert As String, _
                                            ByRef rs As ADODB.Recordset) As Boolean
  
  sqlstmt_if = "select product_id from cscart_product_images_links where 1=2;"

  sqlstmt_update = ""

  sqlstmt_insert = "insert into cscart_product_images_links(product_id,image_id,detailed_id,type,position)"
  sqlstmt_insert = sqlstmt_insert & " values ("
  sqlstmt_insert = sqlstmt_insert & "@@get_product_id(" & rs.Fields("pr_id").Value & "),"
  sqlstmt_insert = sqlstmt_insert & "@@get_image_id(" & rs.Fields("prwi_archivo").Value & "),"
  sqlstmt_insert = sqlstmt_insert & db.ValField(rs.Fields("detailed_id")) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlString(db.ValField(rs.Fields("type"))) & ","
  sqlstmt_insert = sqlstmt_insert & db.ValField(rs.Fields("position"))
  sqlstmt_insert = sqlstmt_insert & ");"

  pProcessProductoImagesLink1 = True
  
End Function

Private Function pProcessProductoImagesLink2(ByRef db As cDataSource, _
                                            ByRef sqlstmt_if As String, _
                                            ByRef sqlstmt_update As String, _
                                            ByRef sqlstmt_insert As String, _
                                            ByRef rs As ADODB.Recordset) As Boolean
  
  sqlstmt_if = "select product_id from cscart_images_links where 1=2;"

  sqlstmt_update = ""

  sqlstmt_insert = "insert into cscart_images_links(object_type,object_id,image_id,detailed_id,type)"
  sqlstmt_insert = sqlstmt_insert & " values ('product',"
  sqlstmt_insert = sqlstmt_insert & "@@get_product_id(" & rs.Fields("pr_id").Value & "),"
  sqlstmt_insert = sqlstmt_insert & "@@get_image_id(" & rs.Fields("prwi_archivo").Value & "),"
  sqlstmt_insert = sqlstmt_insert & db.ValField(rs.Fields("detailed_id")) & ","
  sqlstmt_insert = sqlstmt_insert & db.sqlString(db.ValField(rs.Fields("type")))
  sqlstmt_insert = sqlstmt_insert & ");"

  pProcessProductoImagesLink2 = True
  
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
    pSaveLog sqlstmt_if(i), , 10
    pSaveLog sqlstmt_update(i), , 10
    pSaveLog sqlstmt_insert(i), , 10
  Next
  
  If Err.Description = "Automation error" Then
    CatalogWeb.DestroyFormWeb
    Set CatalogWeb = Nothing
    Set CatalogWeb = New cCatalogWeb
    Err.Clear
  End If
  
  pProcessProductoAux = Err.Number = 0
End Function

Private Function pProcessProductoImage1(ByRef CatalogWeb As cCatalogWeb, _
                                       ByVal htmlpage As String, _
                                       ByVal User As String, _
                                       ByVal pwd As String, _
                                       ByVal imageFile As String _
                                     ) As Boolean
  
  On Error Resume Next

  CatalogWeb.UpdateImage htmlpage, _
                         True, _
                         User, _
                         pwd, _
                         imageFile
                         
  pSaveLog imageFile
  
  If Err.Description = "Automation error" Then
    CatalogWeb.DestroyFormWeb
    Set CatalogWeb = Nothing
    Set CatalogWeb = New cCatalogWeb
    Err.Clear
  End If
  
  pProcessProductoImage1 = Err.Number = 0
End Function

Private Function pProcessProductoImage2(ByRef CatalogWeb As cCatalogWeb, _
                                       ByVal htmlpage As String, _
                                       ByVal User As String, _
                                       ByVal pwd As String, _
                                       ByVal imageFile As String _
                                     ) As Boolean
  
  On Error Resume Next
  
  If Not pProcessProductoImage1(CatalogWeb, htmlpage, User, pwd, imageFile) Then Exit Function
  
  pProcessProductoImage2 = Err.Number = 0
End Function

Private Function pProcessProductoTag(ByRef db As cDataSource, _
                                     ByRef sqlstmt_if As String, _
                                     ByRef sqlstmt_update As String, _
                                     ByRef sqlstmt_insert As String, _
                                     ByVal prt_id As Long, _
                                     ByVal prt_texto As String, _
                                     ByVal pr_id As Long, _
                                     ByVal expoweb As Long, _
                                     ByVal pr_id_tag As Long) As Boolean
  
  sqlstmt_if = "select prt_id from productotag where prt_id = " & prt_id & ";"
  
  sqlstmt_update = "update productotag set prt_texto = " & db.sqlString(prt_texto) & _
                                      ", pr_id = " & pr_id & _
                                      ", exposicion_web = " & db.sqlNumber(expoweb) & _
                                      ", pr_id_tag = " & IIf(pr_id_tag, pr_id_tag, "null") & _
                   " where prt_id = " & prt_id & ";"

  sqlstmt_insert = "insert into productotag (prt_id,prt_texto,exposicion_web,pr_id_tag,pr_id)" & _
                        " values (" & prt_id & _
                                  "," & db.sqlString(prt_texto) & _
                                  "," & db.sqlNumber(expoweb) & _
                                  "," & IIf(pr_id_tag, pr_id_tag, "null") & _
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
                     Optional ByVal bLog As Boolean, _
                     Optional ByVal iLevel As Long)
  On Error Resume Next
  
  If (gLogFull Or bLog Or iLevel >= giLevel) And LenB(msg) <> 0 Then
  
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

Private Function pGetFileName(ByVal FileName As String) As String
  Dim i As Long
  For i = Len(FileName) To 1 Step -1
    If Mid$(FileName, i, 1) = "\" Then
      FileName = Mid$(FileName, i + 1)
      Exit For
    End If
  Next
  pGetFileName = FileName
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



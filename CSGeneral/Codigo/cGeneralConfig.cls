VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cGeneralConfig"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIABMClient
Implements CSMenu.cIMenuClient
'--------------------------------------------------------------------------------
' cGeneralConfig
' 16-10-2003

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cGeneralConfig"

Private Const csTblLenguaje = 14000

Private Const K_CANT_DECIMALES_IMPORTE = 1
Private Const K_CANT_DECIMALES_CANTIDAD = 2
Private Const K_CANT_DECIMALES_COTIZACION = 9

Private Const K_LENGUAJE = 200

Private Const K_EMAIL_SERVER = 103
Private Const K_EMAIL_PORT = 104
Private Const K_EMAIL_USER = 105
Private Const K_EMAIL_PWD = 106
Private Const K_EMAIL_PWD2 = 107
Private Const K_EMAIL_ADDRESS = 108
Private Const K_EMAIL_ADDRESS_TEST = 109
Private Const K_EMAIL_CMD_TEST = 110

' Color en Empresa
'
Private Const K_COLOR_BACKGROUND               As Integer = 370

Private Const c_GrupoGeneral = "General"
Private Const c_Lenguaje = "Lenguaje"
Private Const c_DecimalesImporte = "Decimales Importe"
Private Const c_DecimalesCantidad = "Decimales Cantidad"
Private Const c_DecimalesCotizacion = "Decimales Cotización"
Private Const c_EmailServer = "Email Server"
Private Const c_EmailPort = "Email Port"
Private Const c_EmailUser = "Email User"
Private Const c_EmailPwd = "Email Pwd"
Private Const c_EmailPwd2 = "Email Pwd2"
Private Const c_EmailAddress = "Email Address"
Private Const c_EmailAddressTest = "emailTest"
Private Const c_EmailTestCmd = "cmdTest"

' Colores en Empresas
Private Const c_ColorEnEmpresa = "Color Empresa"

' estructuras
' Seudo - Variables
Private c_ErrorSave                     As String

' variables privadas
Private m_DecimalesImporte              As Long
Private m_DecimalesCantidad             As Long
Private m_DecimalesCotizacion           As Long

Private m_FormatDecImporte              As String
Private m_FormatDecCantidad             As String
Private m_FormatDecCotizacion           As String

Private m_leng_id                     As Long
Private m_LengNombre                  As String

Private m_EmailServer          As String
Private m_EmailPort            As Long
Private m_EmailUser            As String
Private m_EmailPwd             As String
Private m_EmailAddress         As String

Private m_ColorEnEmpresa       As Long

Private m_Editing           As Boolean
Private m_Host              As CSMenu.cIMenuHost
Private m_ObjAbm            As cIABMGeneric
' eventos
' propiedades publicas
Public Property Get DecimalesImporte() As Long
   DecimalesImporte = m_DecimalesImporte
End Property

Public Property Get DecimalesCantidad() As Long
   DecimalesCantidad = m_DecimalesCantidad
End Property

Public Property Get DecimalesCotizacion() As Long
   DecimalesCotizacion = m_DecimalesCotizacion
End Property

Public Property Get FormatDecCantidad() As String
  FormatDecCantidad = m_FormatDecCantidad
End Property

Public Property Get FormatDecImporte() As String
  FormatDecImporte = m_FormatDecImporte
End Property

Public Property Get FormatDecCotizacion() As String
  FormatDecCotizacion = m_FormatDecCotizacion
End Property

Public Property Get LengId() As Long
  LengId = m_leng_id
End Property

Public Property Get EmailServer() As String
  EmailServer = m_EmailServer
End Property

Public Property Get EmailPort() As Long
  EmailPort = m_EmailPort
End Property

Public Property Get EmailUser() As String
  EmailUser = m_EmailUser
End Property

Public Property Get EmailPwd() As String
  EmailPwd = m_EmailPwd
End Property

Public Property Get EmailAddress() As String
  EmailAddress = m_EmailAddress
End Property

Public Property Get ColorEnEmpresa() As Long
  ColorEnEmpresa = m_ColorEnEmpresa
End Property

' propiedades friend
' propiedades privadas
' funciones publicas
Private Function cIABMClient_Copy() As Boolean
End Function

Private Function cIABMClient_EditNew() As Boolean
End Function

Private Property Get cIABMClient_Aplication() As String
    cIABMClient_Aplication = gAppName
End Property

Private Property Get cIABMClient_CanAddDocDigital() As Boolean
  cIABMClient_CanAddDocDigital = False
End Property

Private Property Get cIABMClient_CanCopy() As Boolean
  cIABMClient_CanCopy = False
End Property

Private Property Get cIABMClient_CanNew() As Boolean
  cIABMClient_CanNew = False
End Property

Private Function cIABMClient_ShowDocDigital() As Boolean
  cIABMClient_ShowDocDigital = False
End Function

Private Function cIABMClient_MessageEx(ByVal MessageID As Long, ByVal Info As Variant) As Variant
  cIABMClient_MessageEx = True
End Function

Private Sub cIABMClient_DiscardChanges()
    LoadCollection
End Sub

Private Function cIABMClient_ListAdHock(List As CSInterfacesABM.cIABMList) As Boolean
End Function

Private Sub cIABMClient_Load()
End Sub

Private Function cIABMClient_PropertyChange(ByVal Key As Integer) As Boolean

  Select Case Key
  
    Case K_EMAIL_CMD_TEST
    
      pSendTest
  End Select

End Function

Private Function cIABMClient_Save() As Boolean
  Dim IProperty As cIABMProperty
  Dim IsNew     As Boolean
  Dim register  As cRegister
  
  Set register = New cRegister
  
  With register
    .Table = csTConfiguracion
    .fields.HaveLastUpdate = True
    .fields.HaveWhoModify = True
    .UtilizaIdentity = True
  End With
  
  ' Esto es para que el codigo en cDataBase no
  ' interprete que es un registro nuevo
  register.Id = -1
  
  For Each IProperty In m_ObjAbm.Properties
    With register
      Select Case IProperty.Key
        Case K_CANT_DECIMALES_CANTIDAD
        
          .fields.Clear
          
          .Filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                    " and cfg_aspecto = " & gDB.sqlString(c_DecimalesCantidad)
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoGeneral, csText
            .Add2 cscCfgAspecto, c_DecimalesCantidad, csText
            .Add2 cscCfgValor, Val(IProperty.Value), csText
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
        
        Case K_CANT_DECIMALES_IMPORTE
          
          .fields.Clear
          
          .Filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                    " and cfg_aspecto = " & gDB.sqlString(c_DecimalesImporte)
          
          If Not register.Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoGeneral, csText
            .Add2 cscCfgAspecto, c_DecimalesImporte, csText
            .Add2 cscCfgValor, Val(IProperty.Value), csText
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
      
        Case K_CANT_DECIMALES_COTIZACION
          
          .fields.Clear
          
          .Filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                    " and cfg_aspecto = " & gDB.sqlString(c_DecimalesCotizacion)
          
          If Not register.Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoGeneral, csText
            .Add2 cscCfgAspecto, c_DecimalesCotizacion, csText
            .Add2 cscCfgValor, Val(IProperty.Value), csText
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
        
        Case K_LENGUAJE
          .fields.Clear
          
          .Filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                            " and cfg_aspecto = " & _
                                    gDB.sqlString(c_Lenguaje) & _
                            " and emp_id = " & EmpId
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoGeneral, csText
            .Add2 cscCfgAspecto, c_Lenguaje, csText
            .Add2 cscCfgValor, IProperty.HelpId, csText
            .Add2 cscEmpId, EmpId, csText
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
        
        Case K_EMAIL_SERVER
        
          .fields.Clear
          
          .Filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                    " and cfg_aspecto = " & gDB.sqlString(c_EmailServer)
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoGeneral, csText
            .Add2 cscCfgAspecto, c_EmailServer, csText
            .Add2 cscCfgValor, IProperty.Value, csText
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
      
        Case K_EMAIL_PORT
        
          .fields.Clear
          
          .Filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                    " and cfg_aspecto = " & gDB.sqlString(c_EmailPort)
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoGeneral, csText
            .Add2 cscCfgAspecto, c_EmailPort, csText
            .Add2 cscCfgValor, Val(IProperty.Value), csText
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
      
        Case K_EMAIL_USER
        
          .fields.Clear
          
          .Filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                    " and cfg_aspecto = " & gDB.sqlString(c_EmailUser)
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoGeneral, csText
            .Add2 cscCfgAspecto, c_EmailUser, csText
            .Add2 cscCfgValor, IProperty.Value, csText
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
      
        Case K_EMAIL_PWD
        
          .fields.Clear
          
          .Filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                    " and cfg_aspecto = " & gDB.sqlString(c_EmailPwd)
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoGeneral, csText
            .Add2 cscCfgAspecto, c_EmailPwd, csText
            .Add2 cscCfgValor, IProperty.Value, csText
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
      
        Case K_EMAIL_ADDRESS
        
          .fields.Clear
          
          .Filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                    " and cfg_aspecto = " & gDB.sqlString(c_EmailAddress)
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoGeneral, csText
            .Add2 cscCfgAspecto, c_EmailAddress, csText
            .Add2 cscCfgValor, IProperty.Value, csText
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
      
        Case K_COLOR_BACKGROUND
          .fields.Clear
          
          .Filter = "cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & _
                            " and cfg_aspecto = " & _
                                    gDB.sqlString(c_ColorEnEmpresa) & _
                            " and emp_id = " & EmpId
          
          If Not .Exists(gDB, IsNew) Then Exit Function
          IsNew = Not IsNew
          
          With .fields
            .Add2 cscCfgGrupo, c_GrupoGeneral, csText
            .Add2 cscCfgAspecto, c_ColorEnEmpresa, csText
            .Add2 cscCfgValor, IProperty.Value, csText
            .Add2 cscEmpId, EmpId, csId
          End With
          
          If Not gDB.Save(register, IsNew, C_ABMClientSave, C_Module, _
                 c_ErrorSave) Then Exit Function
      
      End Select
    End With
  Next
  cIABMClient_Save = Load()
End Function

Private Function cIABMClient_Terminate() As Boolean
  m_Editing = False
  cIABMClient_Terminate = True
End Function

Private Property Get cIABMClient_Title() As String
  cIABMClient_Title = LNGGetText(2862, vbNullString) 'Configuración General
End Property

Private Function cIABMClient_Validate() As Boolean

  Dim pwd       As String
  Dim pwd2      As String
  Dim IProperty As cIABMProperty

  CSKernelClient2.Title = LNGGetText(2862, vbNullString) 'Configuración General

  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_CANT_DECIMALES_CANTIDAD
          If Val(.Value) < 0 Or Val(.Value) > 6 Then
            MsgWarning LNGGetText(2863, vbNullString)
                       'La cantidad de decimales para la cantidad no puede ser mayor & _
                        a 6 ni menor a 0
            Exit Function
          End If
        Case K_CANT_DECIMALES_IMPORTE
          If Val(.Value) < 0 Or Val(.Value) > 6 Then
            MsgWarning LNGGetText(2864, vbNullString)
                       'La cantidad de decimales para los importes no puede ser mayor a & _
                        6 ni menor a 0
            Exit Function
          End If
        Case K_EMAIL_PWD
          pwd = .Value
        Case K_EMAIL_PWD2
          pwd2 = .Value
      End Select
    End With
  Next

  If pwd <> pwd2 Then
    MsgWarning LNGGetText(2865, vbNullString)
              'La clave para la cuenta de e-mail no conicide con la confirmación.
    Exit Function
  End If

  cIABMClient_Validate = True
End Function

' ////////////////////////////////
' ////////////////////////////////
' ////////////////////////////////
' ////////////////////////////////
' ////////////////////////////////
' ////////////////////////////////

' Menu
Private Function cIMenuClient_Initialize(F As Object, Host As CSMenu.cIMenuHost) As Boolean
  On Error GoTo ControlError

  Set m_Host = Host
  
  m_Host.Server.AddMenu C_MenuGeneral, csMenuConfigGeneral, C_MenuConfig, 0, True, False, False, False, True, Nothing
  m_Host.Server.AddMenu C_MenuGeneral, csPreGModifyConfig, C_MenuGeneral, 0, True, False, False, False, False, Me

  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, C_MenuClientInit, C_Module, vbNullString
  If Err.Number Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal Id As Long) As Variant
  pEdit
End Function

Public Function Load() As Boolean
  Dim sqlstmt As String

  sqlstmt = "select * from configuracion where cfg_grupo = " & gDB.sqlString(c_GrupoGeneral)

  Dim rs As Recordset

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  m_DecimalesCantidad = 2
  m_DecimalesImporte = 2
  m_DecimalesCotizacion = 3
  
  m_leng_id = csNO_ID
  m_LengNombre = vbNullString
  
  m_EmailServer = vbNullString
  m_EmailPort = 25
  m_EmailUser = vbNullString
  m_EmailPwd = vbNullString
  m_EmailAddress = LNGGetText(2866, vbNullString)   'mi_casilla@server.com

  While Not rs.EOF
    Select Case gDB.ValField(rs.fields, cscCfgAspecto)
      
      Case c_DecimalesCantidad
        m_DecimalesCantidad = Val(gDB.ValField(rs.fields, cscCfgValor))
        
        If m_DecimalesCantidad > 0 Then
          m_FormatDecCantidad = "#,###,###,##0." & String(m_DecimalesCantidad, "0")
        Else
          m_FormatDecCantidad = "#,###,###,##0"
        End If
        
      Case c_DecimalesImporte
        m_DecimalesImporte = Val(gDB.ValField(rs.fields, cscCfgValor))
        
        If m_DecimalesImporte > 0 Then
          m_FormatDecImporte = "#,###,###,##0." & String(m_DecimalesImporte, "0")
        Else
          m_FormatDecImporte = "#,###,###,##0"
        End If
      
      Case c_DecimalesCotizacion
        m_DecimalesCotizacion = Val(gDB.ValField(rs.fields, cscCfgValor))
        
        If m_DecimalesCotizacion > 0 Then
          m_FormatDecCotizacion = "#,###,###,##0." & String(m_DecimalesCotizacion, "0")
        Else
          m_FormatDecCotizacion = "#,###,###,##0"
        End If
      
      Case c_Lenguaje
        m_leng_id = Val(gDB.ValField(rs.fields, cscCfgValor))
        If Not gDB.GetData(csTLenguaje, cscLengId, m_leng_id, cscLengNombre, m_LengNombre) Then Exit Function
      
      Case c_EmailServer
        m_EmailServer = gDB.ValField(rs.fields, cscCfgValor)
      Case c_EmailPort
        m_EmailPort = Val(gDB.ValField(rs.fields, cscCfgValor))
      Case c_EmailUser
        m_EmailUser = gDB.ValField(rs.fields, cscCfgValor)
      Case c_EmailPwd
        m_EmailPwd = gDB.ValField(rs.fields, cscCfgValor)
      Case c_EmailAddress
        m_EmailAddress = gDB.ValField(rs.fields, cscCfgValor)
    
      Case c_ColorEnEmpresa
        m_ColorEnEmpresa = Val(gDB.ValField(rs.fields, cscCfgValor))
    
    End Select
    
    rs.MoveNext
  Wend

  Load = True
End Function

Private Sub pEdit()
  On Error GoTo ControlError
  
  Set m_ObjAbm = New cABMGeneric
  
  If Not SecurityCanAccess(csPreGModifyConfig) Then Exit Sub

  If Not Load() Then Exit Sub
  
  If Not LoadCollection() Then Exit Sub
  
  m_Editing = True
  
  Exit Sub
ControlError:
  MngError Err, "pEdit", C_Module, vbNullString
End Sub

Private Function LoadCollection() As Boolean

  Const c_tab_Decimales = 0
  Const c_tab_Mail = 1
  
  With m_ObjAbm.Tabs
    .Clear
    
    With .Add(Nothing)
      .Index = c_tab_Decimales
      .name = LNGGetText(2867, vbNullString)   'Decimales
    End With
  
    With .Add(Nothing)
      .Index = c_tab_Mail
      .name = LNGGetText(2868, vbNullString)   'E-Mail
    End With
  End With

  With m_ObjAbm.Properties
    
    .Clear
    
    With .Add(Nothing, c_DecimalesCantidad)
      .PropertyType = cspNumeric
      .SubType = cspInteger
      .name = LNGGetText(2869, vbNullString)   'Decimales en cantidades
      .Key = K_CANT_DECIMALES_CANTIDAD
      .Value = m_DecimalesCantidad
      .Left = 4100
      .Width = 800
      .LeftLabel = -3800
    End With
  
    With .Add(Nothing, c_DecimalesImporte)
      .PropertyType = cspNumeric
      .SubType = cspInteger
      .name = LNGGetText(2870, vbNullString)   'Decimales en Importes
      .Key = K_CANT_DECIMALES_IMPORTE
      .Value = m_DecimalesImporte
      .Width = 800
      .LeftLabel = -3800
    End With
    
    With .Add(Nothing, c_DecimalesCotizacion)
      .PropertyType = cspNumeric
      .SubType = cspInteger
      .name = LNGGetText(2871, vbNullString)   'Decimales en la Cotización de Moneda Extranjera
      .Key = K_CANT_DECIMALES_COTIZACION
      .Value = m_DecimalesCotizacion
      .Width = 800
      .LeftLabel = -3800
    End With
    
    With .Add(Nothing, c_ColorEnEmpresa)
      .PropertyType = cspNumeric
      .SubType = cspInteger
      .Width = 6000
      .name = LNGGetText(4915, vbNullString) 'Color en Empresa
      .Key = K_COLOR_BACKGROUND
      .Value = m_ColorEnEmpresa
      .Left = 4100
      .LeftLabel = -3830
      .Width = 1500
    End With
    
    With .Add(Nothing, c_Lenguaje)
      .PropertyType = cspHelp
      .Table = csTblLenguaje
      .Left = 1100
      .Width = 4000
      .LeftLabel = -800
      .name = c_Lenguaje
      .Key = K_LENGUAJE
      .HelpId = m_leng_id
      .Value = m_LengNombre
    End With
    
    With .Add(Nothing, c_EmailServer)
      .PropertyType = cspText
      .name = LNGGetText(2872, vbNullString)   'Servidor
      .Width = 5000
      .Key = K_EMAIL_SERVER
      .Value = m_EmailServer
      .TabIndex = c_tab_Mail
      .Left = 1500
    End With
    
    With .Add(Nothing, c_EmailPort)
      .PropertyType = cspNumeric
      .SubType = cspInteger
      .name = LNGGetText(2873, vbNullString)   'Puerto
      .Width = 1200
      .Key = K_EMAIL_PORT
      .Value = m_EmailPort
      .TabIndex = c_tab_Mail
    End With
    
    With .Add(Nothing, c_EmailUser)
      .PropertyType = cspText
      .name = LNGGetText(1137, vbNullString)   'Usuario
      .Width = 2500
      .Key = K_EMAIL_USER
      .Value = m_EmailUser
      .TabIndex = c_tab_Mail
    End With
    
    With .Add(Nothing, c_EmailPwd)
      .PropertyType = cspPassword
      .name = LNGGetText(2807, vbNullString)   'Clave
      .Width = 2500
      .Key = K_EMAIL_PWD
      .Value = m_EmailPwd
      .TabIndex = c_tab_Mail
    End With
    
    With .Add(Nothing, c_EmailPwd2)
      .PropertyType = cspPassword
      .name = LNGGetText(2876, vbNullString)   'Confirmar
      .Width = 2500
      .Key = K_EMAIL_PWD2
      .Value = m_EmailPwd
      .TabIndex = c_tab_Mail
    End With
    
    With .Add(Nothing, c_EmailAddress)
      .PropertyType = cspText
      .name = LNGGetText(2868, vbNullString)   'Email
      .Width = 2500
      .Key = K_EMAIL_ADDRESS
      .Value = m_EmailAddress
      .TabIndex = c_tab_Mail
    End With
  
    With .Add(Nothing, c_EmailAddressTest)
      .PropertyType = cspText
      .name = LNGGetText(2874, vbNullString)   'Email para Test
      .Width = 2500
      .Key = K_EMAIL_ADDRESS_TEST
      .TabIndex = c_tab_Mail
    End With
  
    With .Add(Nothing, c_EmailTestCmd)
      .PropertyType = cspButton
      .name = LNGGetText(2875, vbNullString)   'Test
      .Key = K_EMAIL_CMD_TEST
      .LeftLabel = -1
      .TabIndex = c_tab_Mail
    End With
  
  End With
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function
' funciones friend
' funciones privadas

Private Sub pSendTest()
  
  Dim Mail As Object
  Set Mail = CreateObject("CSMail.cMail")
  
  Dim subject As String
  Dim body   As String
  
  subject = LNGGetText(2877, vbNullString) 'CrowSoft Cairo - Test de Email
  
  body = "Prueba de email para los servicios de CrowSoft Cairo" _
         & vbCrLf & vbCrLf & _
         "Fecha: " & Format(Now, "dd/mm/yyyy hh:nn:ss")
  
  Dim addressTo  As String
  Dim vAddressTo As Variant
  Dim i          As Long
  
  addressTo = Replace(pGetAddressTest(), ";", ",")
  vAddressTo = Split(addressTo, ",")
  
  For i = 0 To UBound(vAddressTo)
  
    If Mail.SendEmail(vAddressTo(i), _
                      pGetAddress(), _
                      pGetAddress(), _
                      pGetServer(), _
                      pGetPort(), _
                      pGetUser(), _
                      pGetPassword(), subject, body) Then
      MsgInfo LNGGetText(1531, vbNullString) 'El mail se envio con éxito
    Else
      MsgError "El mail fallo " & Mail.errNumber & " - " & Mail.ErrDescrip
    End If
    
  Next

End Sub

Private Function pGetAddressTest() As String
  pGetAddressTest = m_ObjAbm.Properties.Item(c_EmailAddressTest).Value
End Function

Private Function pGetAddress() As String
  pGetAddress = m_ObjAbm.Properties.Item(c_EmailAddress).Value
End Function

Private Function pGetServer() As String
  pGetServer = m_ObjAbm.Properties.Item(c_EmailServer).Value
End Function

Private Function pGetPort() As Long
  pGetPort = Val(m_ObjAbm.Properties.Item(c_EmailPort).Value)
End Function

Private Function pGetUser() As String
  pGetUser = m_ObjAbm.Properties.Item(c_EmailUser).Value
End Function

Private Function pGetPassword() As String
  pGetPassword = m_ObjAbm.Properties.Item(c_EmailPwd).Value
End Function

Private Sub pSetColorEmpresa()
  Dim AbmGen As cABMGeneric
  
  Set AbmGen = m_ObjAbm
  
  If m_ColorEnEmpresa Then
    AbmGen.SetBakcColorTagMainEx m_ColorEnEmpresa
  Else
    AbmGen.SetBakcColorTagMainEx vbWhite
  End If
End Sub

' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  c_ErrorSave = LNGGetText(2301, vbNullString) 'Error al grabar la Configuración General
  
  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
  On Error Resume Next
  Set m_ObjAbm = Nothing
End Sub

'//////////////////////////////
'  Codigo estandar de errores
'  On Error GoTo ControlError
'
'  GoTo ExitProc
'ControlError:
'  MngError err,"", C_Module, ""
'  If Err.Number Then Resume ExitProc
'ExitProc:
'  On Error Resume Next


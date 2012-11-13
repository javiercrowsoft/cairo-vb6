VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cUsuario"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGenerico
Implements CSInterfacesABM.cIABMClient
'--------------------------------------------------------------------------------
' cUsuario
' 13-01-00

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const K_NOMBRE      As Integer = 1
Private Const K_CLAVE       As Integer = 2
Private Const K_ACTIVO      As Integer = 3
Private Const K_CONFIRMAR   As Integer = 4
' estructuras
'Private Type PrestacionAccede
'    Prestacion  As Long
'    Accede      As Boolean
'End Type
' variables privadas
Private m_Id            As Long
Private m_Nombre        As String
Private m_Clave         As String
Private m_Activo        As Boolean
Private m_Modificado    As Date
Private m_Creado        As Date
Private m_Modifico      As Long

Private m_DB            As cDataBase

'Private m_Prestaciones()  As PrestacionAccede

Private m_Editando          As Boolean

Private m_ObjAbm            As cIABMGenerico
Private m_ObjArbol          As Object

Private m_Nuevo             As Boolean

Private m_RamaId            As Long
Private m_ArbolId           As Long
' propiedades publicas
Public Property Get Id() As Long
    Id = m_Id
End Property
Public Property Let Id(ByVal RHS As Long)
    m_Id = RHS
End Property
Public Property Get Nombre() As String
    Nombre = m_Nombre
End Property
Public Property Let Nombre(ByVal RHS As String)
    m_Nombre = RHS
End Property
Public Property Get Pasword() As String
    Pasword = m_Clave
End Property
Public Property Let Pasword(ByVal RHS As String)
    m_Clave = RHS
End Property
Public Property Get Activo() As Boolean
    Activo = m_Activo
End Property
Public Property Let Activo(ByVal RHS As Boolean)
    m_Activo = RHS
End Property
Public Property Get Modificado() As Date
    Modificado = m_Modificado
End Property
Public Property Get Modifico() As Long
    Modifico = m_Modifico
End Property
Public Property Get Creado() As Date
    Creado = m_Creado
End Property
Public Property Set DB(ByRef RHS As cDataBase)
    Set m_DB = RHS
End Property
' propiedades privadas
' funciones publicas
Public Function Exists(ByVal sNombre As String, ByRef bExists As Boolean) As Boolean
    If Not m_DB.Exists(bExists, csTUsuario, cscUsNombre + " = " + m_DB.sqlString(m_Nombre), cscUsId, "GetUsuario", "cUsuario", , csErrorFatal) Then Exit Function
    Exists = True
End Function
Public Function GetPasword(ByRef Pasword As String) As Boolean
    Dim clave As String
    Dim bExists As Boolean
    Dim bActivo As Boolean
    
    If Not m_DB.GetDatoWithCondition(csTUsuario, cscUsClave, cscUsNombre + " = " + m_DB.sqlString(m_Nombre), clave, bExists, False, "GetPasword", "cUsuario", , csErrorFatal) Then Exit Function
   
    If Not bExists Then
        CSKernelClient.MsgWarning "El usuario no existe", "Login"
        Exit Function
    End If
    
    If Not m_DB.Activo(bActivo, csTUsuario, cscUsNombre + " = " + m_DB.sqlString(m_Nombre), "GetPasword", "cUsuario", , csErrorFatal) Then Exit Function
        
    If Not bActivo Then
        CSKernelClient.MsgWarning "El usuario esta inactivo. Cosulte con el Administrador del sistema.", "Login"
        Exit Function
    End If
    Pasword = clave
    GetPasword = True
End Function
Public Function GetUsuario(ByVal Id As Long, Optional ByVal Nombre As String = "") As Boolean
    Dim rs As cRegistros
    Dim sqlstmt As String
    
    m_Id = csNO_ID
    m_Nombre = ""
    m_Creado = csNoFecha
    m_Modificado = csNoFecha
    m_Activo = False
    m_Clave = ""
    m_Modifico = csNO_ID
    
    
    If Id = csNO_ID And Vacio_(Nombre, csText) Then Exit Function
    
    sqlstmt = "SELECT * FROM " + csTUsuario + " WHERE "
    
    If Not Vacio_(Nombre, csText) Then
        sqlstmt = sqlstmt + cscUsNombre + " = '" + Trim(Nombre) + "'"
    Else
        sqlstmt = sqlstmt + cscUsId + " = " + Trim(Id)
    End If
    
    If Not m_DB.OpenRs(sqlstmt, rs, , , , "GetUsuario", "cUsuario", "Error al cargar le usuario", csErrorAdvertencia) Then Exit Function
    
    If Not rs.EOF Then
        m_Id = rs.Campos(cscUsId).Valor
        m_Nombre = m_DB.ValField(rs.Campos(cscUsNombre))
        m_Creado = m_DB.ValField(rs.Campos(cscCreado))
        m_Modificado = m_DB.ValField(rs.Campos(cscModificado))
        m_Modifico = m_DB.ValField(rs.Campos(cscModifico))
        m_Activo = rs.Campos(cscActivo).Valor
        m_Clave = m_DB.ValField(rs.Campos(cscUsClave))
    End If
    GetUsuario = True
End Function
' Implementacion de cIABMClient
Private Property Get cIABMClient_Aplicacion() As String
    cIABMClient_Aplicacion = gAppName
End Property

Private Sub cIABMClient_DescargarCambios()
    CargarColeccion
End Sub

Private Function cIABMClient_ListaAdHock(lista As CSInterfacesABM.cIABMLista) As Boolean

End Function

Private Sub cIABMClient_Load()

End Sub

Private Function cIABMClient_Save() As Boolean
    Dim Registro As cRegister
    Set Registro = New cRegister
    
    Registro.CampoId = cscUsId
    Registro.Tabla = csTUsuario
    Registro.Id = m_Id
    
    Dim IPropiedad As cIABMPropiedad
    For Each IPropiedad In m_ObjAbm.Propiedades
        With IPropiedad
            Select Case .clave
                Case K_NOMBRE
                    Registro.Fields.Add2 cscUsNombre, .Valor, csText
                Case K_CLAVE
                    Registro.Fields.Add2 cscUsClave, UCase(.Valor), csText
                Case K_ACTIVO
                    Registro.Fields.Add2 cscActivo, Val(.Valor), csBoolean
            End Select
        End With
    Next
    Registro.Fields.TieneModificado = True
    Registro.Fields.TieneQuienModifico = True
    
    If Not gDB.Save(Registro, , "cIABMClient_Save", "cUsuario", "Error al grabar Usuarios") Then Exit Function
    
    cIABMClient_Save = Cargar(Registro.Id)
End Function

Private Function cIABMClient_Terminar() As Boolean
    m_Editando = False
    
    cIABMClient_Terminar = True
    ' Este objeto puede no cumplir con la interfaz esperada, asi que si hay un error no
    ' le doy bola
    On Error GoTo ControlError
    If m_Id = csNO_ID Then Exit Function
    If m_ObjArbol Is Nothing Then Exit Function
    
    If m_Nuevo Then
        m_ObjArbol.AddHoja m_Id, m_RamaId, m_ArbolId
    Else
        m_ObjArbol.AddIdEditado m_Id
        m_ObjArbol.RefreshRamaActiva
    End If
ControlError:
End Function

Private Property Get cIABMClient_Titulo() As String
    cIABMClient_Titulo = "Usuarios"
End Property

Private Function cIABMClient_Validate() As Boolean
    Dim IPropiedad As cIABMPropiedad
    Dim clave As String
    
    For Each IPropiedad In m_ObjAbm.Propiedades
        With IPropiedad
            Select Case .clave
                Case K_NOMBRE
                    If Vacio_(.Valor, csText) Then
                        MsgInfo "Debe indicar un nombre"
                        Exit Function
                    End If
                Case K_CLAVE
                    clave = .Valor
                Case K_CONFIRMAR
                    If clave <> .Valor Then
                        MsgInfo "La clave y su confirmación no coinciden"
                        Exit Function
                    End If
                Case K_ACTIVO
            End Select
        End With
    Next
    
    cIABMClient_Validate = True
End Function

Private Property Let cIEditGenerico_ArbolId(ByVal RHS As Long)
    m_ArbolId = RHS
End Property

Private Property Get cIEditGenerico_ArbolId() As Long
    cIEditGenerico_ArbolId = m_ArbolId
End Property

Private Function cIEditGenerico_MostrarLista() As Boolean
    cIEditGenerico_MostrarLista = gSeguridad.Accede(csPreOListaUsuario)
End Function

' Implementacion de cIEditGenerico
Private Property Set cIEditGenerico_ObjAbm(RHS As CSInterfacesABM.cIABMGenerico)
    Set m_ObjAbm = RHS
End Property

Private Property Get cIEditGenerico_Editando() As Boolean
    cIEditGenerico_Editando = m_Editando
End Property

Private Function cIEditGenerico_Borrar(Id As Long) As Boolean
    If Not gSeguridad.Accede(csPreOBorrarUsuario) Then Exit Function
    
    Dim sqlstmt As String
    
    sqlstmt = "Delete " & csTUsuario & " where " & cscUsId & " = " & Id
    
    cIEditGenerico_Borrar = gDB.Execute(sqlstmt, "cIEditGenerico_Borrar", "cUsuario")
End Function

Private Function cIEditGenerico_Buscar(Id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGenerico_Editar(Id As Long) As Boolean
    On Error GoTo ControlError
    
    If Id = csNO_ID Then
        m_Nuevo = True
        If Not gSeguridad.Accede(csPreOAltaUsuario) Then Exit Function
    Else
        m_Nuevo = False
        If Not gSeguridad.Accede(csPreOEditarUsuario) Then Exit Function
    End If
    
    If Not Cargar(Id) Then Exit Function
    
    If Not CargarColeccion() Then Exit Function
    
 
    m_Editando = True
    cIEditGenerico_Editar = True
    Exit Function
ControlError:
    MngError "cIEditGenerico_Editar", "cUsuario", ""
End Function

Private Function cIEditGenerico_Imprimir(ByVal Id As Long) As Boolean

End Function

Private Property Set cIEditGenerico_ObjArbol(RHS As Object)
    Set m_ObjArbol = RHS
End Property

Private Property Let cIEditGenerico_RamaId(ByVal RHS As Long)
    m_RamaId = RHS
End Property

Private Property Get cIEditGenerico_RamaId() As Long
    cIEditGenerico_RamaId = m_RamaId
End Property

Private Function cIEditGenerico_VistaPreliminar(ByVal Id As Long) As Boolean

End Function

' Funciones de grabación
'Public Function Collectdata(ByRef Registro As cRegister, ByVal f As Object) As Boolean
'    Registro.CampoId = cscUsId
'    Registro.Id = m_Id
'    Registro.Tabla = csTUsuario
'    Registro.Fields.Add2 cscUsNombre, f.TxNombre, csText
'    Registro.Fields.Add2 cscUsClave, f.TxClave, csText
'    Registro.Fields.Add2 cscActivo, f.ChkActivo, csBoolean
'    Collectdata = True
'End Function
'Public Function Save(ByRef Registro As cRegister) As Boolean
'    If Not m_DB.Save(Registro, "Save", "cUsuario", "Error al guardar el usuario", csErrorAdvertencia) Then Exit Function
'    If m_Id = csNO_ID Then
'        If Not GetUsuario(Registro.Id) Then Exit Function
'    End If
'    Save = True
'End Function
'Public Function Validate(ByRef f As Object) As Boolean
'    On Error Resume Next
'    If Vacio_(f.TxNombre, csText) Then
'        CSKernelClient.MsgWarning "El nombre no puede estar vacio"
'        f.TxNombre.SetFocus
'        Exit Function
'    ElseIf UCase(Trim((f.TxClave))) <> UCase(Trim(f.TxConfirmacion)) Then
'        CSKernelClient.MsgWarning "La clave y su confirmación no coinciden"
'        f.TxConfirmacion.Text = ""
'        f.TxClave.SetFocus
'        Exit Function
'    End If
'    Validate = True
'End Function

Public Function ShowUsers(ByRef fListaUsuarios As Object) As Boolean
    If Not gSeguridad.Accede(csPreOListaUsuario) Then Exit Function
    With fListaUsuarios
        .Nombre = "Usuarios"
        .Botones1 = BOTON_BORRAR + BOTON_BUSCAR + BOTON_EDITAR + BOTON_IMPRIMIR + BOTON_NUEVO + BOTON_VISTA_PRELIMINAR + BOTON_SALIR + BOTON_PERMISOS + BOTON_ROLES
        .IconText = .IconPersona
        .Tabla = csUsuario
        .csArbol1.ToolBarVisible = True
    End With
    CSKernelClient.ShowFormWithInit fListaUsuarios, "Usuarios"
End Function

' funciones privadas
Private Function CargarColeccion() As Boolean
    m_ObjAbm.Propiedades.Clear
    
    Dim c As cIABMPropiedad
    
    Set c = m_ObjAbm.Propiedades.Add(c, cscUsNombre)
    c.Tipo = cspTexto
    c.Nombre = "Nombre"
    c.Tamano = 30
    c.clave = K_NOMBRE
    c.Valor = m_Nombre
    Set c = Nothing
    Set c = m_ObjAbm.Propiedades.Add(c, cscUsClave)
    c.Tipo = cspClave
    c.Nombre = "Clave"
    c.Tamano = 15
    c.Valor = m_Clave
    c.clave = K_CLAVE
    Set c = Nothing
    Set c = m_ObjAbm.Propiedades.Add(c, "CONFIRMACION")
    c.Tipo = cspClave
    c.Nombre = "Confirmar"
    c.Tamano = 15
    c.Valor = m_Clave
    c.clave = K_CONFIRMAR
    Set c = Nothing
    Set c = m_ObjAbm.Propiedades.Add(c, cscActivo)
    c.Tipo = cspCheck
    c.Nombre = "Activo"
    c.clave = K_ACTIVO
    c.Valor = CInt(m_Activo)
    Set c = Nothing
    
    If Not m_ObjAbm.Show(Me) Then Exit Function

    CargarColeccion = True
End Function

Private Function Cargar(ByVal Id As Long) As Boolean
    Dim sqlstmt As String
    
    sqlstmt = "SELECT * FROM " & csTUsuario & " WHERE " & cscUsId & "=" & Id
    
    Dim rs As cRegistros
    
    If Not gDB.OpenRs(sqlstmt, rs, csRsEstatico, csTrabaSoloLectura, csCmdTexto, "Cargar", "cUsuario") Then Exit Function
    
    If rs.EOF Then
        m_Activo = False
        m_Nombre = ""
        m_Id = csNO_ID
        m_Clave = ""
    Else
        m_Activo = gDB.ValField(rs(cscActivo))
        m_Nombre = gDB.ValField(rs(cscUsNombre))
        m_Id = gDB.ValField(rs(cscUsId))
        m_Clave = gDB.ValField(rs(cscUsClave))
    End If
    Cargar = True
End Function
' construccion - destruccion

Private Sub Class_Initialize()
    Set m_DB = gDB
End Sub

Private Sub Class_Terminate()
    Set m_ObjAbm = Nothing
    Set m_ObjArbol = Nothing
'    ReDim m_prestacion(0)
    Set m_DB = Nothing
End Sub

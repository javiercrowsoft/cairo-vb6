VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cTask"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGenerico
Implements CSInterfacesABM.cIABMClient
'--------------------------------------------------------------------------------
' cTask
' 24-03-02

'--------------------------------------------------------------------------------
' notas:

' tar   reemplazar por el prefijo de la tabla (ej pro)
' Tarea    reemplazar por el nombre de la tabla (ej Provincia)
' cTask    reemplazar por el nombre de la clase (ej cProvincia)
' Tareas  reemplazar por el nombre logico del abm (ej Provincias)
' PreTask  reemplazar por el nombre logico del abm (ej PreG)
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const K_NOMBRE                         As Integer = 2
Private Const K_DESCRIP                        As Integer = 3
Private Const K_FECHAINI                       As Integer = 4
Private Const K_FECHAFIN                       As Integer = 5
Private Const K_ALARMA                         As Integer = 6
Private Const K_FINALIZADA                     As Integer = 7
Private Const K_CUMPLIDA                       As Integer = 8
Private Const K_RECHAZADA                      As Integer = 9
Private Const K_US_ID_RESPONSABLE              As Integer = 10
Private Const K_US_ID_ASIGNADOR                As Integer = 11
Private Const K_CONT_ID                        As Integer = 12
Private Const K_TAREST_ID                      As Integer = 13
Private Const K_PRIO_ID                        As Integer = 14
Private Const K_ACTIVO                         As Integer = 18
' estructuras
' variables privadas
Private m_Id                           As Long
Private m_Nombre                       As String
Private m_Descrip                      As String
Private m_Fechaini                     As Date
Private m_Fechafin                     As Date
Private m_Alarma                       As Date
Private m_Finalizada                   As Boolean
Private m_Cumplida                     As Boolean
Private m_Rechazada                    As Boolean
Private m_Us_id_responsable            As Long
Private m_Responsable                  As String
Private m_Us_id_asignador              As Long
Private m_Asignador                    As String
Private m_Cont_id                      As Long
Private m_Contacto                     As String
Private m_Tarest_id                    As Long
Private m_Estado                       As String
Private m_Prio_id                      As Long
Private m_Prioridad                    As String
Private m_Modificado                   As Date
Private m_Creado                       As Date
Private m_Modifico                     As Long
Private m_Activo                       As Boolean

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

Public Property Let Id(ByVal rhs As Long)
    m_Id = rhs
End Property

Public Property Get Nombre() As String
    Nombre = m_Nombre
End Property

Public Property Let Nombre(ByVal rhs As String)
    m_Nombre = rhs
End Property

Public Property Get Descrip() As String
    Descrip = m_Descrip
End Property

Public Property Let Descrip(ByVal rhs As String)
    m_Descrip = rhs
End Property

Public Property Get Fechaini() As Date
    Fechaini = m_Fechaini
End Property

Public Property Let Fechaini(ByVal rhs As Date)
    m_Fechaini = rhs
End Property

Public Property Get Fechafin() As Date
    Fechafin = m_Fechafin
End Property

Public Property Let Fechafin(ByVal rhs As Date)
    m_Fechafin = rhs
End Property

Public Property Get Alarma() As Date
    Alarma = m_Alarma
End Property

Public Property Let Alarma(ByVal rhs As Date)
    m_Alarma = rhs
End Property

Public Property Get Finalizada() As Boolean
    Finalizada = m_Finalizada
End Property

Public Property Let Finalizada(ByVal rhs As Boolean)
    m_Finalizada = rhs
End Property

Public Property Get Cumplida() As Boolean
    Cumplida = m_Cumplida
End Property

Public Property Let Cumplida(ByVal rhs As Boolean)
    m_Cumplida = rhs
End Property

Public Property Get Rechazada() As Boolean
    Rechazada = m_Rechazada
End Property

Public Property Let Rechazada(ByVal rhs As Boolean)
    m_Rechazada = rhs
End Property

Public Property Get Us_id_responsable() As Long
    Us_id_responsable = m_Us_id_responsable
End Property

Public Property Let Us_id_responsable(ByVal rhs As Long)
    m_Us_id_responsable = rhs
End Property

Public Property Get Responsable() As String
    Us_id_responsable = m_Responsable
End Property

Public Property Let Responsable(ByVal rhs As String)
    m_Responsable = rhs
End Property

Public Property Get Us_id_asignador() As Long
    Us_id_asignador = m_Us_id_asignador
End Property

Public Property Let Us_id_asignador(ByVal rhs As Long)
    m_Us_id_asignador = rhs
End Property

Public Property Get Asignador() As String
    Us_id_asignador = m_Asignador
End Property

Public Property Let Asignador(ByVal rhs As String)
    m_Asignador = rhs
End Property

Public Property Get Cont_id() As Long
    Cont_id = m_Cont_id
End Property

Public Property Let Cont_id(ByVal rhs As Long)
    m_Cont_id = rhs
End Property

Public Property Get Contacto() As String
    Cont_id = m_Contacto
End Property

Public Property Let Contacto(ByVal rhs As String)
    m_Contacto = rhs
End Property

Public Property Get Tarest_id() As Long
    Tarest_id = m_Tarest_id
End Property

Public Property Let Tarest_id(ByVal rhs As Long)
    m_Tarest_id = rhs
End Property

Public Property Get Estado() As String
    Tarest_id = m_Estado
End Property

Public Property Let Estado(ByVal rhs As String)
    m_Estado = rhs
End Property

Public Property Get Prio_id() As Long
    Prio_id = m_Prio_id
End Property

Public Property Let Prio_id(ByVal rhs As Long)
    m_Prio_id = rhs
End Property

Public Property Get Prioridad() As String
    Prio_id = m_Prioridad
End Property

Public Property Let Prioridad(ByVal rhs As String)
    m_Prioridad = rhs
End Property

Public Property Get Modificado() As Date
    Modificado = m_Modificado
End Property

Public Property Let Modificado(ByVal rhs As Date)
    m_Modificado = rhs
End Property

Public Property Get Creado() As Date
    Creado = m_Creado
End Property

Public Property Let Creado(ByVal rhs As Date)
    m_Creado = rhs
End Property

Public Property Get Modifico() As Long
    Modifico = m_Modifico
End Property

Public Property Let Modifico(ByVal rhs As Long)
    m_Modifico = rhs
End Property

Public Property Get Activo() As Boolean
    Activo = m_Activo
End Property

Public Property Let Activo(ByVal rhs As Boolean)
    m_Activo = rhs
End Property

' propiedades privadas
' funciones publicas


' Implementacion de cIABMClient
Private Property Get cIABMClient_Aplicacion() As String
    cIABMClient_Aplicacion = gAppName
End Property

Private Sub cIABMClient_DescargarCambios()
    CargarColeccion
End Sub

Private Function cIABMClient_ListaAdHock(Lista As CSInterfacesABM.cIABMLista) As Boolean

End Function

Private Sub cIABMClient_Load()

End Sub

Private Function cIABMClient_Save() As Boolean
    Dim registro As cRegister
    Set registro = New cRegister
    
    registro.CampoId = csctarId
    registro.Tabla = csTTarea
    registro.Id = m_Id
    
    Dim IPropiedad As cIABMPropiedad
    For Each IPropiedad In m_ObjAbm.Propiedades
        With IPropiedad
            Select Case .Clave
                Case K_NOMBRE
                    registro.Fields.Add2 csctarNombre, .Valor, csText
                Case K_ALIAS
                    registro.Fields.Add2 csctarAlias, UCase(.Valor), csText
                Case K_ACTIVO
                    registro.Fields.Add2 cscActivo, Val(.Valor), csBoolean
            End Select
        End With
    Next
    registro.Fields.TieneModificado = True
    registro.Fields.TieneQuienModifico = True
    
    If Not gDB.Save(registro, , "cIABMClient_Save", "cTask", "Error al grabar Tareas") Then Exit Function
    
    cIABMClient_Save = Cargar(registro.Id)
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
    cIABMClient_Titulo = "Tareas"
End Property

Private Function cIABMClient_Validate() As Boolean
    Dim IPropiedad As cIABMPropiedad
    
    For Each IPropiedad In m_ObjAbm.Propiedades
        With IPropiedad
            Select Case .Clave
                Case K_NOMBRE
                    If Vacio(.Valor, csText) Then
                        MsgInfo "Debe indicar un nombre"
                        Exit Function
                    End If
                Case K_ALIAS
                    If Vacio(.Valor, csText) Then
                        MsgInfo "Debe indicar un alias"
                        Exit Function
                    End If
                Case K_ACTIVO
            End Select
        End With
    Next
    
    cIABMClient_Validate = True
End Function

' Implementacion de cIEditGenerico

Private Property Let cIEditGenerico_ArbolId(ByVal rhs As Long)
    m_ArbolId = rhs
End Property

Private Property Get cIEditGenerico_ArbolId() As Long
    cIEditGenerico_ArbolId = m_ArbolId
End Property

Private Function cIEditGenerico_MostrarLista() As Boolean
    cIEditGenerico_MostrarLista = SeguridadAccede(csPreTaskListaTarea)
End Function

Private Property Set cIEditGenerico_ObjAbm(rhs As CSInterfacesABM.cIABMGenerico)
    Set m_ObjAbm = rhs
End Property

Private Property Get cIEditGenerico_Editando() As Boolean
    cIEditGenerico_Editando = m_Editando
End Property

Private Function cIEditGenerico_Borrar(Id As Long) As Boolean
    If Not SeguridadAccede(csPreTaskBorrarTarea) Then Exit Function

    Dim sqlstmt As String
    
    sqlstmt = "Delete " & csTTarea & " where " & csctarId & " = " & Id
    
    cIEditGenerico_Borrar = gDB.Execute(sqlstmt, "cIEditGenerico_Borrar", "cTask")
End Function

Private Function cIEditGenerico_Buscar(Id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGenerico_Editar(Id As Long) As Boolean
    On Error GoTo ControlError
    
    If Id = csNO_ID Then
        m_Nuevo = True
        If Not SeguridadAccede(csPreTaskAltaTarea) Then Exit Function
    Else
        m_Nuevo = False
        If Not SeguridadAccede(csPreTaskEditarTarea) Then Exit Function
    End If

    If Not Cargar(Id) Then Exit Function
    
    If Not CargarColeccion() Then Exit Function
    
    m_Editando = True
    cIEditGenerico_Editar = True
    Exit Function
ControlError:
    MngError "cIEditGenerico_Editar", "cTask", ""
End Function

Private Function cIEditGenerico_Imprimir(ByVal Id As Long) As Boolean

End Function

Private Property Set cIEditGenerico_ObjArbol(rhs As Object)
    Set m_ObjArbol = rhs
End Property

Private Property Let cIEditGenerico_RamaId(ByVal rhs As Long)
    m_RamaId = rhs
End Property

Private Property Get cIEditGenerico_RamaId() As Long
    cIEditGenerico_RamaId = m_RamaId
End Property

Private Function cIEditGenerico_VistaPreliminar(ByVal Id As Long) As Boolean

End Function

' funciones privadas
Private Function CargarColeccion() As Boolean
    m_ObjAbm.Propiedades.Clear
    
    Dim c As cIABMPropiedad
    
    Set c = m_ObjAbm.Propiedades.Add(c, csctarNombre)
    c.Tipo = cspTexto
    c.Nombre = "Nombre"
    c.Tamano = 30
    c.Clave = K_NOMBRE
    c.Valor = m_Nombre
    Set c = Nothing
    Set c = m_ObjAbm.Propiedades.Add(c, csctarAlias)
    c.Tipo = cspTexto
    c.Nombre = "Alias"
    c.Tamano = 15
    c.Valor = m_Alias
    c.Clave = K_ALIAS
    Set c = Nothing
    Set c = m_ObjAbm.Propiedades.Add(c, cscActivo)
    c.Tipo = cspCheck
    c.Nombre = "Activo"
    c.Clave = K_ACTIVO
    c.Valor = CInt(m_Activo)
    Set c = Nothing
    
    If Not m_ObjAbm.Show(Me) Then Exit Function

    CargarColeccion = True
End Function

Private Function Cargar(ByVal Id As Long) As Boolean
    Dim sqlstmt As String
    
    sqlstmt = "SELECT * FROM " & csTTarea & " WHERE " & csctarId & "=" & Id
    
    Dim rs As cRegistros
    
    If Not gDB.OpenRs(sqlstmt, rs, csRsEstatico, csTrabaSoloLectura, csCmdTexto, "Cargar", "cTask") Then Exit Function
    
    If rs.EOF Then
        m_Activo = False
        m_Nombre = ""
        m_Alias = ""
        m_Id = csNO_ID
        m_Modificado = csNoFecha
        m_Creado = csNoFecha
        m_Modifico = csNO_ID
    Else
        m_Activo = gDB.ValField(rs(cscActivo))
        m_Nombre = gDB.ValField(rs(csctarNombre))
        m_Alias = gDB.ValField(rs(csctarAlias))
        m_Id = gDB.ValField(rs(csctarId))
        m_Modificado = gDB.ValField(rs(cscModificado))
        m_Creado = gDB.ValField(rs(cscCreado))
        m_Modifico = gDB.ValField(rs(cscModifico))
    End If
    Cargar = True
End Function
' construccion - destruccion

Private Sub Class_Initialize()
'
End Sub

Private Sub Class_Terminate()
    Set m_ObjAbm = Nothing
    Set m_ObjArbol = Nothing
End Sub


VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cHoraListDoc"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGenericListDoc
Implements CSInterfacesABM.cIABMListDocClient
'--------------------------------------------------------------------------------
' cHoraListDoc
' 02-07-03

'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cHoraListDoc"

Private Const K_FECHADESDE                     As Integer = 1
Private Const K_FECHAHASTA                     As Integer = 2
Private Const K_PROYECTO                       As Integer = 4
Private Const K_PROYECTOITEM                   As Integer = 5
Private Const K_OBJETIVO                       As Integer = 6
Private Const K_USUARIO                        As Integer = 7
Private Const K_TAREA                          As Integer = 8
Private Const K_DESCRIP                        As Integer = 9
Private Const K_TITULO                         As Integer = 10
Private Const K_CLIENTE                        As Integer = 11

' Seudo - Variables
Private c_strLoad                         As String
Private c_ErrorSave                       As String

' estructuras
' variables privadas

Private m_FechaDesdeV                     As String
Private m_FechaHastaV                     As String

Private m_FechaDesde                      As Date
Private m_FechaHasta                      As Date

Private m_Proyecto                       As String
Private m_ProyectoItem                   As String
Private m_Objetivo                       As String
Private m_Cliente                        As String
Private m_Usuario                        As String
Private m_Tarea                          As String

Private m_Proy_id                       As String
Private m_Proyi_id                      As String
Private m_Obje_id                       As String
Private m_Cli_id                        As String
Private m_us_id2                        As String
Private m_Tar_id                        As String
Private m_Descrip                        As String
Private m_Titulo                         As String

Private m_MenuLoaded        As Boolean
Private m_MenuShowFactura   As Long

Private m_MenuShowMensajes  As Long
Private m_MenuShowInfoCli   As Long
Private m_MenuAddMensaje    As Long
Private m_MenuFirmar        As Long

'OJO HASTA ACA
Private m_ObjAbm        As cIABMGenericListDoc
Private m_ObjList       As Object

Private m_Us_id         As Long

Private m_Properties    As cABMDocProperties
' Properties publicas
' Properties privadas
' funciones publicas
Public Function ProcessMenu(ByVal Index As Long)
  On Error GoTo ControlError

  Select Case Index
  
    Case m_MenuShowFactura
      pShowFactura
    
    Case m_MenuShowInfoCli
      HelpShowInfo csCliente, pGetCliId()
    
    Case m_MenuShowMensajes
      pShowMensajes
      
    Case m_MenuAddMensaje
      pAddMensaje
  
  End Select
  GoTo ExitProc
ControlError:
  MngError Err, "ProcessMenu", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

' Implementacion de cIABMClient

'-------------------------------------------------------------------------------------
' Interfaz cliente de List de documentos

Private Property Get cIABMListDocClient_Aplication() As String
  cIABMListDocClient_Aplication = gAppName
End Property

Private Sub cIABMListDocClient_DiscardChanges()
  LoadCollection
End Sub

Private Function cIABMListDocClient_ListAdHock(List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMListDocClient_Load()

End Sub

Private Property Get cIABMListDocClient_Properties() As Object
  Set cIABMListDocClient_Properties = m_Properties
End Property

Private Function cIABMListDocClient_PropertyChange(ByVal Key As Integer) As Boolean
  Dim iProp     As cIABMProperty
  
  Select Case Key

    Case K_FECHADESDE
      Set iProp = m_ObjAbm.Properties(cscHoraDesde)

      If LenB(iProp.HelpValueProcess) Then
        m_FechaDesdeV = iProp.HelpValueProcess
        m_FechaDesde = VDGetDateByName(m_FechaDesdeV)
      ElseIf IsDate(iProp.Value) Then
        m_FechaDesdeV = ""
        m_FechaDesde = iProp.Value
      Else
        m_FechaDesdeV = ""
        iProp.Value = m_FechaDesde
      End If

    Case K_FECHAHASTA
      
      Set iProp = m_ObjAbm.Properties(cscHoraHasta)
      
      If LenB(iProp.HelpValueProcess) Then
        m_FechaHastaV = iProp.HelpValueProcess
        m_FechaHasta = VDGetDateByName(m_FechaHastaV)
      ElseIf IsDate(iProp.Value) Then
        m_FechaHastaV = ""
        m_FechaHasta = iProp.Value
      Else
        m_FechaHastaV = ""
        iProp.Value = m_FechaHasta
      End If

    Case K_PROYECTO
      m_Proy_id = m_ObjAbm.Properties(cscProyId).HelpValueProcess

    Case K_PROYECTOITEM
      m_Proyi_id = m_ObjAbm.Properties(cscProyIId).HelpValueProcess

    Case K_OBJETIVO
      m_Obje_id = m_ObjAbm.Properties(cscObjeId).HelpValueProcess
      
    Case K_CLIENTE
      m_Cli_id = m_ObjAbm.Properties(cscCliId).HelpValueProcess

    Case K_USUARIO
      m_us_id2 = m_ObjAbm.Properties(cscUsId).HelpValueProcess

    Case K_TAREA
      m_Tar_id = m_ObjAbm.Properties(cscTarId).HelpValueProcess

    Case K_DESCRIP
      m_Descrip = m_ObjAbm.Properties(cscHoraDescrip).Value

    Case K_TITULO
      m_Titulo = m_ObjAbm.Properties(cscHoraTitulo).Value

   End Select

   cIABMListDocClient_PropertyChange = True
End Function

Private Function cIABMListDocClient_Refresh() As String
  Dim sqlstmt As String

  sqlstmt = "sp_lsdoc_Horas "

  sqlstmt = sqlstmt & gDB.UserId & ","
  
  If Not DateNames(m_FechaDesdeV) Is Nothing Then
    sqlstmt = sqlstmt & gDB.sqlDate(VDGetDateByName(m_FechaDesdeV)) & ","
  Else
    sqlstmt = sqlstmt & gDB.sqlDate(m_FechaDesde) & ","
  End If
  
  If Not DateNames(m_FechaHastaV) Is Nothing Then
    sqlstmt = sqlstmt & gDB.sqlDate(VDGetDateByName(m_FechaHastaV)) & ","
  Else
    sqlstmt = sqlstmt & gDB.sqlDate(m_FechaHasta) & ","
  End If
  
  sqlstmt = sqlstmt & gDB.sqlString(m_Cli_id) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_Proy_id) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_Proyi_id) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_Obje_id) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_Tar_id) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_us_id2) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_Descrip) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_Titulo)

  cIABMListDocClient_Refresh = sqlstmt
End Function

Private Function cIABMListDocClient_Save() As Boolean
  Dim register As cRegister
  Set register = New cRegister

  Dim sqlstmt As String
  sqlstmt = "delete ListaDocumentoParametro " & _
            " where pre_id = " & csPreTareaListHora & _
              " and us_id = " & m_Us_id

  If Not gDB.Execute(sqlstmt, "cIABMClient_Save", C_Module, c_ErrorSave) Then Exit Function

  register.Table = csTListaDocumentoParametro
  register.UtilizaIdentity = True

  Dim IProperty As cIABMProperty
  For Each IProperty In m_ObjAbm.Properties

    register.fields.Clear

    With IProperty
      Select Case .Key

        Case K_FECHADESDE
          If LenB(.HelpValueProcess) Then
            register.fields.Add2 cscLdpValor, .HelpValueProcess, csText
          Else
            register.fields.Add2 cscLdpValor, .Value, csText
          End If
          register.fields.Add2 cscLdpOrden, 10, csInteger
          register.fields.Add2 cscLdpId, K_FECHADESDE, csInteger
        Case K_FECHAHASTA
          If LenB(.HelpValueProcess) Then
            register.fields.Add2 cscLdpValor, .HelpValueProcess, csText
          Else
            register.fields.Add2 cscLdpValor, .Value, csText
          End If
          register.fields.Add2 cscLdpOrden, 20, csInteger
          register.fields.Add2 cscLdpId, K_FECHAHASTA, csInteger
        Case K_PROYECTO
          register.fields.Add2 cscLdpValor, .HelpValueProcess, csText
          register.fields.Add2 cscLdpOrden, 30, csInteger
          register.fields.Add2 cscLdpId, K_PROYECTO, csInteger
        Case K_PROYECTOITEM
          register.fields.Add2 cscLdpValor, .HelpValueProcess, csText
          register.fields.Add2 cscLdpOrden, 40, csInteger
          register.fields.Add2 cscLdpId, K_PROYECTOITEM, csInteger
        Case K_OBJETIVO
          register.fields.Add2 cscLdpValor, .HelpValueProcess, csText
          register.fields.Add2 cscLdpOrden, 50, csInteger
          register.fields.Add2 cscLdpId, K_OBJETIVO, csInteger
        Case K_CLIENTE
          register.fields.Add2 cscLdpValor, .HelpValueProcess, csText
          register.fields.Add2 cscLdpOrden, 50, csInteger
          register.fields.Add2 cscLdpId, K_CLIENTE, csInteger
        Case K_USUARIO
          register.fields.Add2 cscLdpValor, .HelpValueProcess, csText
          register.fields.Add2 cscLdpOrden, 60, csInteger
          register.fields.Add2 cscLdpId, K_USUARIO, csInteger
        Case K_TAREA
          register.fields.Add2 cscLdpValor, .HelpValueProcess, csText
          register.fields.Add2 cscLdpOrden, 70, csInteger
          register.fields.Add2 cscLdpId, K_TAREA, csInteger
        Case K_DESCRIP
          register.fields.Add2 cscLdpValor, .Value, csText
          register.fields.Add2 cscLdpOrden, 80, csInteger
          register.fields.Add2 cscLdpId, K_DESCRIP, csInteger
        Case K_TITULO
          register.fields.Add2 cscLdpValor, .Value, csText
          register.fields.Add2 cscLdpOrden, 90, csInteger
          register.fields.Add2 cscLdpId, K_TITULO, csInteger

      End Select
      register.fields.Add2 cscUsId, m_Us_id, csId
      register.fields.Add2 cscPreID, csPreTareaListHora, csId

      register.fields.HaveLastUpdate = False
      register.fields.HaveLastUpdate = False
      If Not gDB.Save(register, , "cIABMClient_Save", C_Module, c_ErrorSave) Then Exit Function
    End With
  Next
  If Not Load(m_Us_id) Then Exit Function

  cIABMListDocClient_Save = True
End Function

Private Function cIABMListDocClient_Terminate() As Boolean
  cIABMListDocClient_Terminate = True
End Function

Private Property Get cIABMListDocClient_Title() As String
  cIABMListDocClient_Title = LNGGetText(1795, vbNullString) 'Tareas
End Property

Private Function cIABMListDocClient_Validate() As Boolean
  cIABMListDocClient_Validate = True
End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  Dim c As cIABMProperty
  Dim o As cIABMListItem
  Dim Value As String
  Dim bExists As Boolean

  m_ObjAbm.Properties.Clear

  Set c = m_ObjAbm.Properties.Add(Nothing, cscHoraDesde)
  c.PropertyType = cspDate
  c.Name = LNGGetText(1203, vbNullString) 'Fecha Desde
  c.Key = K_FECHADESDE
  If LenB(m_FechaDesdeV) Then
    c.Value = m_FechaDesdeV
  Else
    c.Value = m_FechaDesde
  End If
  

  Set c = m_ObjAbm.Properties.Add(Nothing, cscHoraHasta)
  c.PropertyType = cspDate
  c.Name = LNGGetText(1204, vbNullString) 'Fecha Hasta
  c.Key = K_FECHAHASTA
  If LenB(m_FechaHastaV) Then
    c.Value = m_FechaHastaV
  Else
    c.Value = m_FechaHasta
  End If
  

  Set c = m_ObjAbm.Properties.Add(Nothing, cscCliId)
  c.PropertyType = cspHelp
  c.Table = csCliente
  c.Name = LNGGetText(1150, vbNullString) 'Cliente
  c.Key = K_CLIENTE
  Value = m_Cliente
  If UCase(Left$(m_Cli_id, 1)) = KEY_NODO Then
    Value = GetNombreRama(csCliente, Val(Mid(m_Cli_id, 2)), bExists)
    If Not bExists Then m_Cli_id = "0"
  End If
  c.Value = Value
  c.HelpId = Val(m_Cli_id)
  c.HelpValueProcess = m_Cli_id
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscProyId)
  c.PropertyType = cspHelp
  c.Table = csProyecto
  c.Name = LNGGetText(1658, vbNullString) 'Proyecto
  c.Key = K_PROYECTO
  Value = m_Proyecto
  If UCase(Left$(m_Proy_id, 1)) = KEY_NODO Then
    Value = GetNombreRama(csProyecto, Val(Mid(m_Proy_id, 2)), bExists)
    If Not bExists Then m_Proy_id = "0"
  End If
  c.Value = Value
  c.HelpId = Val(m_Proy_id)
  c.HelpValueProcess = m_Proy_id
  

  Set c = m_ObjAbm.Properties.Add(Nothing, cscProyIId)
  c.PropertyType = cspHelp
  c.Table = csProyectoItem
  c.Name = LNGGetText(2657, vbNullString) 'Proyecto Item
  c.Key = K_PROYECTOITEM
  Value = m_ProyectoItem
  If UCase(Left$(m_Proyi_id, 1)) = KEY_NODO Then
    Value = GetNombreRama(csProyectoItem, Val(Mid(m_Proyi_id, 2)), bExists)
    If Not bExists Then m_Proyi_id = "0"
  End If
  c.Value = Value
  c.HelpId = Val(m_Proyi_id)
  c.HelpValueProcess = m_Proyi_id
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscObjeId)
  c.PropertyType = cspHelp
  c.Table = csObjetivo
  c.Name = LNGGetText(2651, vbNullString) 'Objetivo
  c.Key = K_OBJETIVO
  Value = m_Objetivo
  If UCase(Left$(m_Obje_id, 1)) = KEY_NODO Then
    Value = GetNombreRama(csObjetivo, Val(Mid(m_Obje_id, 2)), bExists)
    If Not bExists Then m_Obje_id = "0"
  End If
  c.Value = Value
  c.HelpId = Val(m_Obje_id)
  c.HelpValueProcess = m_Obje_id
  

  Set c = m_ObjAbm.Properties.Add(Nothing, cscTarId)
  c.PropertyType = cspHelp
  c.Table = cstblTarea
  c.Name = LNGGetText(1836, vbNullString) 'Tarea
  c.Key = K_TAREA
  Value = m_Tarea
  If UCase(Left$(m_Tar_id, 1)) = KEY_NODO Then
    Value = GetNombreRama(cstblTarea, Val(Mid(m_Tar_id, 2)), bExists)
    If Not bExists Then m_Tar_id = "0"
  End If
  c.Value = Value
  c.HelpId = Val(m_Tar_id)
  c.HelpValueProcess = m_Tar_id
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscUsId)
  c.PropertyType = cspHelp
  c.Table = csUsuario
  c.Name = LNGGetText(1137, vbNullString) 'Usuario
  c.Key = K_USUARIO
  
  Value = m_Usuario
  If UCase(Left$(m_us_id2, 1)) = KEY_NODO Then
    Value = GetNombreRama(csUsuario, Val(Mid(m_us_id2, 2)), bExists)
    If Not bExists Then m_us_id2 = "0"
  End If
  c.Value = Value
  c.HelpId = Val(m_us_id2)
  c.HelpValueProcess = m_us_id2

  Set c = m_ObjAbm.Properties.Add(Nothing, cscHoraDescrip)
  c.PropertyType = cspText
  c.Name = C_strDescrip
  c.Size = 255
  c.Key = K_DESCRIP
  c.Value = m_Descrip
  

  Set c = m_ObjAbm.Properties.Add(Nothing, cscHoraTitulo)
  c.PropertyType = cspText
  c.Name = LNGGetText(1864, vbNullString) 'Título
  c.Size = 255
  c.Key = K_TITULO
  c.Value = m_Titulo
  
  pCreateMenu
  If Not m_ObjAbm.Show(Me, m_ObjList) Then Exit Function

  LoadCollection = True
End Function

Private Function Load(ByVal Us_id As Long) As Boolean
  Dim sqlstmt As String

  sqlstmt = "select * from ListaDocumentoParametro " & _
            " where us_id = " & Us_id & _
              " and pre_id = " & csPreTareaListHora & _
            " order by " & cscLdpOrden

  Dim rs As ADODB.Recordset

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If rs.EOF Then

    m_FechaDesde = Date
    m_FechaHasta = Date
    m_FechaDesdeV = vbNullString
    m_FechaHastaV = vbNullString
    m_Cli_id = csNO_ID
    m_Cliente = vbNullString
    m_Proy_id = csNO_ID
    m_Proyecto = vbNullString
    m_Proyi_id = csNO_ID
    m_ProyectoItem = vbNullString
    m_Obje_id = csNO_ID
    m_Objetivo = vbNullString
    m_us_id2 = User.Id
    m_Usuario = User.Name
    m_Tar_id = csNO_ID
    m_Tarea = vbNullString
    m_Descrip = vbNullString
    m_Titulo = vbNullString
  Else

    rs.MoveLast
    rs.MoveFirst
    
    Dim i As Integer
    While Not rs.EOF

      Select Case gDB.ValField(rs.fields, cscLdpId)

        Case K_FECHADESDE
          m_FechaDesdeV = gDB.ValField(rs.fields, cscLdpValor)
          m_FechaDesde = IIf(IsDate(gDB.ValField(rs.fields, cscLdpValor)), gDB.ValField(rs.fields, cscLdpValor), Date)
        Case K_FECHAHASTA
          m_FechaHastaV = gDB.ValField(rs.fields, cscLdpValor)
          m_FechaHasta = IIf(IsDate(gDB.ValField(rs.fields, cscLdpValor)), gDB.ValField(rs.fields, cscLdpValor), Date)
        Case K_PROYECTO
          m_Proy_id = gDB.ValField(rs.fields, cscLdpValor)
        Case K_PROYECTOITEM
          m_Proyi_id = gDB.ValField(rs.fields, cscLdpValor)
        Case K_CLIENTE
          m_Cli_id = gDB.ValField(rs.fields, cscLdpValor)
        Case K_OBJETIVO
          m_Obje_id = gDB.ValField(rs.fields, cscLdpValor)
        Case K_USUARIO
          m_us_id2 = gDB.ValField(rs.fields, cscLdpValor)
        Case K_TAREA
          m_Tar_id = gDB.ValField(rs.fields, cscLdpValor)
        Case K_DESCRIP
          m_Descrip = gDB.ValField(rs.fields, cscLdpValor)
        Case K_TITULO
          m_Titulo = gDB.ValField(rs.fields, cscLdpValor)
      End Select

      rs.MoveNext
    Wend

    Dim Data As String

    m_FechaDesde = IIf(m_FechaDesde <> csNoDate, m_FechaDesde, Date)
    m_FechaHasta = IIf(m_FechaHasta <> csNoDate, m_FechaHasta, Date)

    
    If UCase(Left$(m_Proy_id, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTProyecto, cscProyId, Val(m_Proy_id), cscProyNombre, Data, C_LoadFunction, C_Module, c_strLoad) Then Exit Function
      m_Proyecto = Data
    End If
    
    If UCase(Left$(m_Proyi_id, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTProyectoItem, cscProyIId, Val(m_Proyi_id), cscProyINombre, Data, C_LoadFunction, C_Module, c_strLoad) Then Exit Function
      m_ProyectoItem = Data
    End If
    
    If UCase(Left$(m_Cli_id, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTCliente, cscCliId, Val(m_Cli_id), cscCliNombre, Data, C_LoadFunction, C_Module, c_strLoad) Then Exit Function
      m_Cliente = Data
    End If
    
    If UCase(Left$(m_Obje_id, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTObjetivo, cscObjeId, Val(m_Obje_id), cscObjeNombre, Data, C_LoadFunction, C_Module, c_strLoad) Then Exit Function
      m_Objetivo = Data
    End If
    
    If UCase(Left$(m_us_id2, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTusuario, cscUsId, Val(m_us_id2), cscUsNombre, Data, C_LoadFunction, C_Module, c_strLoad) Then Exit Function
      m_Usuario = Data
    End If
    
    If UCase(Left$(m_Tar_id, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTTarea, cscTarId, Val(m_Tar_id), cscTarNombre, Data, C_LoadFunction, C_Module, c_strLoad) Then Exit Function
      m_Tarea = Data
    End If

  End If

  Load = True

End Function

'-------------------------------------------------------------------------------------
' Implementacion de cIEditGeneric
Private Function cIEditGenericListDoc_GridAdd(ByVal ClavePropiedad As Integer) As Boolean

End Function

Private Function cIEditGenericListDoc_GridEdit(ByVal ClavePropiedad As Integer) As Boolean

End Function

Private Function cIEditGenericListDoc_GridRemove(ByVal ClavePropiedad As Integer) As Boolean

End Function

Private Property Set cIEditGenericListDoc_ObjAbm(rhs As CSInterfacesABM.cIABMGenericListDoc)
  Set m_ObjAbm = rhs
End Property

Private Function cIEditGenericListDoc_ShowParams(ByVal Us_id As Long) As Boolean
  On Error GoTo ControlError
  
  If Us_id = csNO_ID Then Exit Function

  m_Us_id = Us_id
  
  If Not Load(Us_id) Then Exit Function
  
  If Not LoadCollection() Then Exit Function
  
  cIEditGenericListDoc_ShowParams = True
  Exit Function
ControlError:
  MngError Err, "cIEditGenericListDoc_ShowParams", C_Module, vbNullString
End Function

Private Property Set cIEditGenericListDoc_ObjList(rhs As Object)
  Set m_ObjList = rhs
End Property

Private Function cIEditGenericListDoc_PropertyChange(ByVal Clave As Integer) As Boolean

End Function

Private Function cIEditGenericListDoc_TabClick(ByVal Index As Integer) As Boolean

End Function

Private Sub pCreateMenu()
  On Error Resume Next
  
  If m_MenuLoaded Then Exit Sub
  
  m_MenuLoaded = True
  
  With m_ObjList
    Set .ObjClientMenu = Me
    .ClearMenu
    m_MenuShowFactura = .AddMenu(LNGGetText(1613, vbNullString))   'Facturar
    .AddMenu "-"
    m_MenuShowInfoCli = .AddMenu(LNGGetText(1614, vbNullString))   'Ver Info del Cliente
    m_MenuAddMensaje = .AddMenu(LNGGetText(1615, vbNullString))    'Agregar Nota
    m_MenuShowMensajes = .AddMenu(LNGGetText(1616, vbNullString))  'Ver Notas
  End With
End Sub

Private Sub pShowMensajes()
  Dim sqlstmt As String
  Dim HoraId    As Long
  Dim rs      As ADODB.Recordset
  
  HoraId = m_ObjList.Id
  
  sqlstmt = "sp_ParteDiarioGetTitleForDoc " & csHora & "," & HoraId
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  If rs.EOF Then Exit Sub
  
  Dim infodoc As String
  Dim DoctId  As Long
  
  DoctId = csHora
  infodoc = gDB.ValField(rs.fields, "info_doc")
  
  sqlstmt = "sp_PartesDiarioGetForDoc " & gDB.UserId & "," & EmpId & "," & DoctId & "," & HoraId
  ShowNotes LNGGetText(2658, vbNullString, infodoc), sqlstmt
            'Notas sobre Horas  & infodoc
End Sub

Private Sub pAddMensaje()
  Dim Parte As Object
  Set Parte = CSKernelClient2.CreateObject("CSEnvio2.cParteDiario")
  
  Parte.AddParteToDoc csHora, m_ObjList.Id, False
End Sub

Private Sub pShowFactura()
  On Error GoTo ControlError

  Dim o As Object
  Set o = CSKernelClient2.CreateObject("CSVenta2.cFacturaVenta")
  
  o.ShowFacturaProyecto pGetCliId(), pGetHoraIds()

  GoTo ExitProc
ControlError:
  MngError Err, "pShowFactura", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Function pGetCliId() As Long
  On Error Resume Next
  
  Dim HoraId  As Long
  Dim CliId As Long
  
  HoraId = m_ObjList.Id
  gDB.GetData csTHora, cscHoraId, HoraId, cscCliId, CliId
  
  pGetCliId = CliId
End Function

Private Function pGetHoraIds() As Long()
  pGetHoraIds = m_ObjList.SelectedItems
End Function

' construccion - destruccion

Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  c_strLoad = LNGGetText(2655, vbNullString)
              'Error al cargar los parámetros de navegación de Hora
  c_ErrorSave = LNGGetText(2656, vbNullString)
              'Error al grabar los párametros de navegación de Hora
  
  Set m_Properties = New cABMDocProperties
  With m_Properties
  'Set .ImageList = fIcons.ilList
  .HaveDetail = True
  .StartRowText = 4
  
  With .Columns.Add(Nothing, "TypeTask")
    .Name = "TypeTask"
    .Caption = " "
    With .Icons.Add(Nothing)
    .FormulaType = csCondTNone
    .IconIndex = c_img_task
    End With
    .Width = 500
    .SortType = csSrtTIcon
  End With
  
  With .Columns.Add(Nothing, "Descripción")
    .Name = "Descripción"
    .FontName = "Tahoma"
    .FontSize = 8
    .ForeColor = vbBlue
  End With
  End With
  
  GoTo ExitProc
ControlError:
  MngError Err, "Class_Terminate", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
  On Error GoTo ControlError
  
  Set m_ObjAbm = Nothing
  Set m_ObjList = Nothing
  Set m_Properties = Nothing

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Terminate", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub


VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cHora"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGeneric
Implements CSInterfacesABM.cIABMClient
Implements CSMenu.cIMenuClient
'--------------------------------------------------------------------------------
' cHora
' 03-07-2003

'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cHora"

Private Const K_TITULO                         As Integer = 1
Private Const K_DESCRIP                        As Integer = 2
Private Const K_FECHA                          As Integer = 3
Private Const K_DESDE                          As Integer = 4
Private Const K_HASTA                          As Integer = 5
Private Const K_HORAS                          As Integer = 6
Private Const K_MINUTOS                        As Integer = 7
Private Const K_FACTURABLE                     As Integer = 8
Private Const K_CLI_ID                         As Integer = 9
Private Const K_PROY_ID                        As Integer = 10
Private Const K_PROYI_ID                       As Integer = 11
Private Const K_OBJE_ID                        As Integer = 12
Private Const K_US_ID                          As Integer = 13
Private Const K_TAR_ID                         As Integer = 14

' Seudo - Variables
Private c_ErrorSave                   As String

' estructuras
' variables privadas
Private m_Id                           As Long
Private m_Titulo                       As String
Private m_Descrip                      As String
Private m_Fecha                        As Date
Private m_Desde                        As Date
Private m_Hasta                        As Date
Private m_Horas                        As Integer
Private m_Minutos                      As Integer
Private m_Facturable                   As Integer
Private m_Cli_id                       As Long
Private m_Cliente                      As String
Private m_Proy_id                      As Long
Private m_Proyecto                     As String
Private m_Proyi_id                     As Long
Private m_ProyectoItem                 As String
Private m_Obje_id                      As Long
Private m_Objetivo                     As String
Private m_Us_id                        As Long
Private m_Usuario                      As String
Private m_Tar_id                       As Long
Private m_Tarea                        As String
Private m_Creado                       As Date
Private m_Modificado                   As Date
Private m_Modifico                     As Long

'OJO HASTA ACA

Private m_Editing           As Boolean

Private m_ObjAbm            As cIABMGeneric
Private m_ObjTree           As Object

Private m_IsNew             As Boolean

Private m_BranchId          As Long
Private m_TreeId            As Long

Private m_Host              As CSMenu.cIMenuHost
Private m_Copy              As Boolean

' Properties publicas
'Public Property Get ID() As Long
'  ID = m_Id
'End Property
'
'Public Property Let ID(ByVal rhs As Long)
'  m_Id = rhs
'End Property
'
'Public Property Get Titulo() As String
'  Titulo = m_Titulo
'End Property
'
'Public Property Let Titulo(ByVal rhs As String)
'  m_Titulo = rhs
'End Property
'
'Public Property Get Descrip() As String
'  Descrip = m_Descrip
'End Property
'
'Public Property Let Descrip(ByVal rhs As String)
'  m_Descrip = rhs
'End Property
'
'Public Property Get Fecha() As Date
'  Fecha = m_Fecha
'End Property
'
'Public Property Let Fecha(ByVal rhs As Date)
'  m_Fecha = rhs
'End Property
'
'Public Property Get Desde() As Date
'  Desde = m_Desde
'End Property
'
'Public Property Let Desde(ByVal rhs As Date)
'  m_Desde = rhs
'End Property
'
'Public Property Get Hasta() As Date
'  Hasta = m_Hasta
'End Property
'
'Public Property Let Hasta(ByVal rhs As Date)
'  m_Hasta = rhs
'End Property
'
'Public Property Get Horas() As Integer
'  Horas = m_Horas
'End Property
'
'Public Property Let Horas(ByVal rhs As Integer)
'  m_Horas = rhs
'End Property
'
'Public Property Get Minutos() As Integer
'  Minutos = m_Minutos
'End Property
'
'Public Property Let Minutos(ByVal rhs As Integer)
'  m_Minutos = rhs
'End Property
'
'Public Property Get Facturable() As Integer
'  Facturable = m_Facturable
'End Property
'
'Public Property Let Facturable(ByVal rhs As Integer)
'  m_Facturable = rhs
'End Property
'
'Public Property Get Cli_id() As Long
'  Cli_id = m_Cli_id
'End Property
'
'Public Property Let Cli_id(ByVal rhs As Long)
'  m_Cli_id = rhs
'End Property
'
'Public Property Get Cliente() As String
'  Cliente = m_Cliente
'End Property
'
'Public Property Let Cliente(ByVal rhs As String)
'  m_Cliente = rhs
'End Property
'
'Public Property Get Proy_id() As Long
'  Proy_id = m_Proy_id
'End Property
'
'Public Property Let Proy_id(ByVal rhs As Long)
'  m_Proy_id = rhs
'End Property
'
'Public Property Get Proyecto() As String
'  Proyecto = m_Proyecto
'End Property
'
'Public Property Let Proyecto(ByVal rhs As String)
'  m_Proyecto = rhs
'End Property
'
'Public Property Get Proyi_id() As Long
'  Proyi_id = m_Proyi_id
'End Property
'
'Public Property Let Proyi_id(ByVal rhs As Long)
'  m_Proyi_id = rhs
'End Property
'
'Public Property Get ProyectoItem() As String
'  ProyectoItem = m_ProyectoItem
'End Property
'
'Public Property Let ProyectoItem(ByVal rhs As String)
'  m_ProyectoItem = rhs
'End Property
'
'Public Property Get Obje_id() As Long
'  Obje_id = m_Obje_id
'End Property
'
'Public Property Let Obje_id(ByVal rhs As Long)
'  m_Obje_id = rhs
'End Property
'
'Public Property Get Objetivo() As String
'  Objetivo = m_Objetivo
'End Property
'
'Public Property Let Objetivo(ByVal rhs As String)
'  m_Objetivo = rhs
'End Property
'
'Public Property Get Us_id() As Long
'  Us_id = m_Us_id
'End Property
'
'Public Property Let Us_id(ByVal rhs As Long)
'  m_Us_id = rhs
'End Property
'
'Public Property Get Usuario() As String
'  Usuario = m_Usuario
'End Property
'
'Public Property Let Usuario(ByVal rhs As String)
'  m_Usuario = rhs
'End Property
'
'Public Property Get Tar_id() As Long
'  Tar_id = m_Tar_id
'End Property
'
'Public Property Let Tar_id(ByVal rhs As Long)
'  m_Tar_id = rhs
'End Property
'
'Public Property Get Tarea() As String
'  Tarea = m_Tarea
'End Property
'
'Public Property Let Tarea(ByVal rhs As String)
'  m_Tarea = rhs
'End Property
'
'Public Property Get Creado() As Date
'  Creado = m_Creado
'End Property
'
'Public Property Let Creado(ByVal rhs As Date)
'  m_Creado = rhs
'End Property
'
'Public Property Get Modificado() As Date
'  Modificado = m_Modificado
'End Property
'
'Public Property Let Modificado(ByVal rhs As Date)
'  m_Modificado = rhs
'End Property
'
'Public Property Get Modifico() As Long
'  Modifico = m_Modifico
'End Property
'
'Public Property Let Modifico(ByVal rhs As Long)
'  m_Modifico = rhs
'End Property
' Properties privadas
' funciones publicas


' Implementacion de cIABMClient
Private Function cIABMClient_Copy() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True
  
  With m_ObjAbm.Properties(cscHoraTitulo)
    .Value = C_CopiaDe & .Value
  End With
    
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscHoraTitulo)
  
  m_Copy = True
End Function

Private Function cIABMClient_EditNew() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True
  
  cIEditGeneric_Edit csNO_ID
End Function

Private Property Get cIABMClient_Aplication() As String
    cIABMClient_Aplication = gAppName
End Property

Private Property Get cIABMClient_CanAddDocDigital() As Boolean
  cIABMClient_CanAddDocDigital = m_Id <> csNO_ID
End Property

Private Property Get cIABMClient_CanCopy() As Boolean
  cIABMClient_CanCopy = True
End Property

Private Property Get cIABMClient_CanNew() As Boolean
  cIABMClient_CanNew = True
End Property

Private Function cIABMClient_ShowDocDigital() As Boolean
  On Error GoTo ControlError
  
  If m_Id = csNO_ID Then Exit Function
  
  Dim Doc As cDocDigital
  Set Doc = New cDocDigital

  Doc.ClientTable = csTHora
  Doc.ClientTableID = m_Id

  cIABMClient_ShowDocDigital = Doc.ShowDocs(gDB)

  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClient_ShowDocDigital", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
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
  Dim Filter As String
  
  cIABMClient_PropertyChange = True
  
  Select Case Key
    Case K_DESDE, K_HASTA
      Dim Minutos As Integer
      Dim Horas   As Integer
      
      Dim HoraDesde As Date
      Dim HoraHasta As Date
      
      HoraDesde = m_ObjAbm.Properties(cscHoraDesde).Value
      HoraHasta = m_ObjAbm.Properties(cscHoraHasta).Value
      
      If HoraDesde <> csNoDate And HoraHasta <> csNoDate Then
      
        Horas = Fix(DateDiff("n", HoraDesde, HoraHasta) / 60)
        Minutos = DateDiff("n", HoraDesde, HoraHasta) Mod 60
      
        m_ObjAbm.Properties(cscHoraHoras).Value = pGetTiempo(Horas, Minutos)
        m_ObjAbm.Properties(cscHoraHoras).Enabled = False
      Else
        m_ObjAbm.Properties(cscHoraHoras).Enabled = True
      End If
  
    Case K_PROY_ID
      With m_ObjAbm.Properties
        Filter = "proy_id = " & .Item(cscProyId).HelpId
        ValidateHelp cscProyIId, csProyectoItem, .Item(cscProyIId).HelpId, Filter
        ValidateHelp cscObjeId, csObjetivo, .Item(cscObjeId).HelpId, Filter
        ValidateHelp cscTarId, cstblTarea, .Item(cscTarId).HelpId, pGetFilterTarea()
      End With
      
    Case K_OBJE_ID, K_PROYI_ID
      ValidateHelp cscTarId, cstblTarea, m_ObjAbm.Properties.Item(cscTarId).HelpId, pGetFilterTarea()
    
    Case K_CLI_ID
      With m_ObjAbm.Properties
        Filter = "(cli_id = " & .Item(cscCliId).HelpId & " or proy_publico <> 0)"
        ValidateHelp cscProyId, csProyecto, .Item(cscProyId).HelpId, Filter
        
        Filter = "proy_id = " & .Item(cscProyId).HelpId
        ValidateHelp cscProyIId, csProyectoItem, .Item(cscProyIId).HelpId, Filter
        ValidateHelp cscObjeId, csObjetivo, .Item(cscObjeId).HelpId, Filter
        
        ValidateHelp cscTarId, cstblTarea, .Item(cscTarId).HelpId, pGetFilterTarea()
      End With
      
    Case K_TAR_ID
      With m_ObjAbm.Properties
        If ValEmpty(.Item(cscHoraTitulo).Value, csText) Then
          .Item(cscHoraTitulo).Value = .Item(cscTarId).Value
        End If
      End With
    Case Else
      cIABMClient_PropertyChange = False
  End Select
End Function

Private Function pGetFilterTarea() As String
  Dim Filter As String
  Filter = " t.proy_id = " & m_ObjAbm.Properties(cscProyId).HelpId
  Filter = Filter & " and proyi_id = " & m_ObjAbm.Properties(cscProyIId).HelpId
  Filter = Filter & " and obje_id = " & m_ObjAbm.Properties(cscObjeId).HelpId

  pGetFilterTarea = Filter
End Function

Private Sub ValidateHelp(ByVal Key As String, ByVal Table As Long, ByVal Id As Long, ByVal Filter As String)
  Dim help As CSOAPI2.cHelp
  Dim hr As CSOAPI2.cHelpResult

  Set help = New CSOAPI2.cHelp

  With m_ObjAbm.Properties(Key)
    
    If Table = csProyecto Or Table = cstblTarea Then
      Filter = gDB.sqlString(Filter)
    End If
      
    .HelpFilter = Filter
    
    Set hr = help.ValidateEx(Table, .Value, Id, Filter)
    If hr.Cancel Then
      .Value = vbNullString
      .HelpId = csNO_ID
    End If
  End With
End Sub

Private Function cIABMClient_Save() As Boolean
  Dim register   As cRegister
  Dim fields     As cFields
  
  Set register = New cRegister
  
  With register
  
    Set fields = .fields
    
    .fieldId = cscHoraId
    .Table = csTHora
  
    If m_Copy Then
      .Id = csNew
    Else
      .Id = m_Id
    End If
  End With
  
  Dim IProperty As cIABMProperty
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_TITULO
          fields.Add2 cscHoraTitulo, .Value, csText
        Case K_DESCRIP
          fields.Add2 cscHoraDescrip, .Value, csText
        Case K_FECHA
          fields.Add2 cscHoraFecha, .Value, csDate
        Case K_DESDE
          fields.Add2 cscHoraDesde, .Value, csDate
        Case K_HASTA
          fields.Add2 cscHoraHasta, .Value, csDate
        Case K_HORAS
          Dim Horas As Integer
          Dim Minutos As Integer
          
          Horas = Val(Mid(.Value, 1, 2))
          Minutos = Val(Mid(.Value, 4, 2))
          
          register.fields.Add2 cscHoraHoras, Horas, csInteger
          register.fields.Add2 cscHoraMinutos, Minutos, csInteger
        
        Case K_FACTURABLE
          fields.Add2 cscHoraFacturable, .Value, csInteger
        Case K_CLI_ID
          fields.Add2 cscCliId, .HelpId, csId
        Case K_PROY_ID
          fields.Add2 cscProyId, .HelpId, csId
        Case K_PROYI_ID
          fields.Add2 cscProyIId, .HelpId, csId
        Case K_OBJE_ID
          fields.Add2 cscObjeId, .HelpId, csId
        Case K_US_ID
          fields.Add2 cscUsId, .HelpId, csId
          If gLastUser Is Nothing Or gLastUser Is CSOAPI2.User Then
            Set gLastUser = New cUsuario
          End If
          gLastUser.GetUser .HelpId
        Case K_TAR_ID
          fields.Add2 cscTarId, .HelpId, csId

      End Select
    End With
  Next
  fields.HaveLastUpdate = True
  fields.HaveWhoModify = True
  
  If Not register.BeginTrans(gDB) Then Exit Function
  
  If Not gDB.Save(register, , "cIABMClient_Save", C_Module, c_ErrorSave) Then Exit Function
  
  Dim sqlstmt As String
  sqlstmt = "sp_horaSetPendiente " & register.Id
  gDB.Execute sqlstmt
  
  register.CommitTrans
  
  m_Copy = False
  cIABMClient_Save = Load(register.Id)
End Function

Private Function cIABMClient_Terminate() As Boolean
  m_Editing = False
  
  cIABMClient_Terminate = True
  ' Este objeto puede no cumplir con la interfaz esperada, asi que si hay un error no
  ' le doy bola
  On Error GoTo ControlError
  If m_Id = csNO_ID Then Exit Function
  If m_ObjTree Is Nothing Then Exit Function
  
  m_ObjTree.sqlstmt = "sp_lsdoc_hora"
  
  If m_IsNew Then
    m_ObjTree.AddLine m_Id
  Else
    m_ObjTree.RefreshLine m_Id
  End If
ControlError:
End Function

Private Property Get cIABMClient_Title() As String
    cIABMClient_Title = LNGGetText(1660, vbNullString)  'Horas
End Property

Private Function cIABMClient_Validate() As Boolean
  Dim IPropiedad As cIABMProperty
  Dim HorasOMinutos As Boolean
  
  CSKernelClient2.Title = LNGGetText(1660, vbNullString)  'Horas
  
  For Each IPropiedad In m_ObjAbm.Properties
    With IPropiedad
      Select Case .Key
        Case K_TITULO
          If ValEmpty(.Value, csText) Then
            MsgInfo LNGGetText(1855, vbNullString)  'Debe indicar un título
            Exit Function
          End If
        
        Case K_CLI_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(1563, vbNullString)  'Debe indicar un cliente
            Exit Function
          End If
        
        Case K_PROY_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(2643, vbNullString)  'Debe indicar un Proyecto
            Exit Function
          End If
        
        Case K_PROYI_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(2644, vbNullString)  'Debe indicar un Sub-Proyecto
            Exit Function
          End If
        
        Case K_OBJE_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(2645, vbNullString)  'Debe indicar un Objetivo
            Exit Function
          End If
        
        Case K_US_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(1938, vbNullString)  'Debe indicar un usuario
            Exit Function
          End If
        
        Case K_HORAS
          If Not ValEmpty(.Value, csDate) Then
            
            Dim Horas As Integer
            Dim Minutos As Integer
            
            Horas = Val(Mid(.Value, 1, 2))
            Minutos = Val(Mid(.Value, 4, 2))
            
            If Val(Horas) < 0 Or Val(Horas) > 24 Then
            MsgInfo LNGGetText(2646, vbNullString)  'Las Horas deben estar en el rango 0 a 23
            Exit Function
            ElseIf Horas <> 0 Then
            HorasOMinutos = True
            End If
          
            If Val(Minutos) < 0 Or Val(Minutos) > 59 Then
            MsgInfo LNGGetText(2647, vbNullString)  'Los Minutos deben estar en el rango 0 a 59
            Exit Function
            ElseIf Minutos <> 0 Then
            HorasOMinutos = True
            End If
          End If
          
          If Not HorasOMinutos Then
            MsgInfo LNGGetText(2648, vbNullString)  'Debe indicar el tiempo utilizado
            Exit Function
          End If
          
'        Case K_MINUTOS
'          If Not ValEmpty(.Value, csInteger) Then
'            If Val(.Value) < 0 Or Val(.Value) > 59 Then
'            MsgInfo "Los minutos deben estar en el rango 0 a 59"
'            Exit Function
'            Else
'            HorasOMinutos = True
'            End If
'          End If
      End Select
    End With
  Next
  
'  If Not HorasOMinutos Then
'    MsgInfo "Debe indicar el tiempo utilizado"
'    Exit Function
'  End If
  
  If Not pValidatePermiso() Then Exit Function
  
  cIABMClient_Validate = True
End Function

Private Function pValidatePermiso() As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_ProyectoValidatePermiso " _
              & User.Id & ",0," _
              & m_ObjAbm.Properties.Item(cscProyId).HelpId & "," & IIf(m_IsNew, csTNewHora, csTEditHora)
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  If rs.EOF Then Exit Function
  
  If Val(gDB.ValField(rs.fields, 0)) = 0 Then
    MsgWarning LNGGetText(2649, vbNullString)
                'Ud. no tiene permiso para agregar o modificar horas de este Proyecto.
    Exit Function
  End If
  
  pValidatePermiso = True
End Function

' Implementacion de cIEditGeneric
Private Property Get cIEditGeneric_ObjAbm() As CSInterfacesABM.cIABMGeneric
  Set cIEditGeneric_ObjAbm = m_ObjAbm
End Property

Private Function cIEditGeneric_TabClick(ByVal Index As Integer) As Boolean

End Function

Private Property Let cIEditGeneric_TreeId(ByVal rhs As Long)
    m_TreeId = rhs
End Property

Private Property Get cIEditGeneric_TreeId() As Long
    cIEditGeneric_TreeId = m_TreeId
End Property

Private Function cIEditGeneric_GridAdd(ByVal ClavePropiedad As Integer) As Boolean

End Function

Private Function cIEditGeneric_GridEdit(ByVal ClavePropiedad As Integer) As Boolean

End Function

Private Function cIEditGeneric_GridRemove(ByVal ClavePropiedad As Integer) As Boolean

End Function

Private Function cIEditGeneric_ShowList() As Boolean
    cIEditGeneric_ShowList = SecurityCanAccess(csPreTareaListHora)
End Function

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
    Set m_ObjAbm = rhs
End Property

Private Property Get cIEditGeneric_Editing() As Boolean
    cIEditGeneric_Editing = m_Editing
End Property

Private Function cIEditGeneric_Delete(Id As Long) As Boolean
    If Not SecurityCanAccess(csPreTareaDeleteHora) Then Exit Function

    Dim sqlstmt As String
  
    sqlstmt = "Delete Hora where hora_id = " & Id
    
    cIEditGeneric_Delete = gDB.Execute(sqlstmt, "cIEditGeneric_Delete", C_Module)
End Function

Private Function cIEditGeneric_Search(Id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Id = csNO_ID Then
    m_IsNew = True
    If Not SecurityCanAccess(csPreTareaNewHora) Then Exit Function
  Else
    m_IsNew = False
    If Not SecurityCanAccess(csPreTareaEditHora) Then Exit Function
  End If
  
  ' JMA I
  m_ObjAbm.InModalWindow = InModalWindow
' JMA F
  
  If Not Load(Id) Then Exit Function
  
  If Not LoadCollection() Then Exit Function
  
  m_Editing = True
  m_Copy = False
  
  If InModalWindow Then
    cIEditGeneric_Edit = m_Id <> csNO_ID
  Else
    cIEditGeneric_Edit = True
  End If

  Exit Function
ControlError:
  MngError Err, "cIEditGeneric_Edit", C_Module, vbNullString
End Function

Private Function cIEditGeneric_PrintObj(ByVal Id As Long) As Boolean

End Function

Private Property Set cIEditGeneric_ObjTree(rhs As Object)
    Set m_ObjTree = rhs
End Property

Private Property Let cIEditGeneric_BranchId(ByVal rhs As Long)
    m_BranchId = rhs
End Property

Private Property Get cIEditGeneric_BranchId() As Long
    cIEditGeneric_BranchId = m_BranchId
End Property

Private Function cIEditGeneric_Preview(ByVal Id As Long) As Boolean

End Function

Private Function cIEditGeneric_PropertyChange(ByVal Key As Integer) As Boolean

End Function

' Menu Client
Private Function cIMenuClient_Initialize(F As Object, Host As CSMenu.cIMenuHost) As Boolean
  On Error GoTo ControlError
  Dim str_1755  As String
  Dim str_2650  As String
  
  
  str_1755 = LNGGetText(1755, vbNullString)   'Se&rvicios
  str_2650 = LNGGetText(2650, vbNullString)   '&Horas
  
  #If Not PREPROC_NO_MENU_ICON Then
    Dim lIconIndex As Long
    Set m_Host = Host
    lIconIndex = m_Host.AddIcon(LoadResPicture(102, LoadResConstants.vbResIcon))
    m_Host.Server.AddMenu str_1755, csMenuProyecto, vbNullString, 1, False, False, False, True, False, Nothing
    m_Host.Server.AddMenu str_2650, csPreTareaListHora, str_1755, 0, True, False, False, False, False, Me, lIconIndex
  
  #Else
    Set m_Host = Host
    m_Host.Server.AddMenu str_1755, csMenuProyecto, vbNullString, 1, False, False, False, True, False, Nothing
    m_Host.Server.AddMenu str_2650, csPreTareaListHora, str_1755, 0, True, False, False, False, False, Me
  #End If

  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, "cIMenuClient_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal Id As Long) As Variant
  m_Host.MenuListDocClick "CSABMInterface2.CABMGeneric", "CSTarea2.cHora", "CSABMInterface2.CABMGenericListDoc", "CSTarea2.cHoraListDoc", Me, LNGGetText(1660, vbNullString), 0
                                                                                                                                              'Horas
End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  m_ObjAbm.Properties.Clear
  
  Dim c As cIABMProperty

  Set c = m_ObjAbm.Properties.Add(Nothing, cscHoraFecha)
  c.PropertyType = cspDate
  c.Name = LNGGetText(1569, vbNullString) 'Fecha
  c.Key = K_FECHA
  c.Value = m_Fecha

  Set c = m_ObjAbm.Properties.Add(Nothing, cscCliId)
  c.PropertyType = cspHelp
  c.Table = csCliente
  c.Name = LNGGetText(1150, vbNullString) 'Cliente
  c.Key = K_CLI_ID
  c.Value = m_Cliente
  c.HelpId = m_Cli_id
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscProyId)
  c.PropertyType = cspHelp
  c.Table = csProyecto
  c.Name = LNGGetText(1658, vbNullString) 'Proyecto
  c.HelpFilter = "'(cli_id = " & m_Cli_id & " or proy_publico <> 0)'"
  c.Key = K_PROY_ID
  c.Value = m_Proyecto
  c.HelpId = m_Proy_id
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscProyIId)
  c.PropertyType = cspHelp
  c.Table = csProyectoItem
  c.Name = LNGGetText(2652, vbNullString) 'Sub Proyecto
  c.HelpFilter = "proy_id = " & m_Proy_id
  c.Key = K_PROYI_ID
  c.Value = m_ProyectoItem
  c.HelpId = m_Proyi_id
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscObjeId)
  c.PropertyType = cspHelp
  c.TopFromProperty = cscHoraFecha
  c.Left = 5300
  c.LeftLabel = -1000
  c.Table = csObjetivo
  c.HelpFilter = "proy_id = " & m_Proy_id
  c.Name = LNGGetText(2651, vbNullString) 'Objetivo
  c.Key = K_OBJE_ID
  c.Value = m_Objetivo
  c.HelpId = m_Obje_id
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscUsId)
  c.PropertyType = cspHelp
  c.Table = csUsuario
  c.Name = LNGGetText(1137, vbNullString) 'Usuario
  c.Key = K_US_ID
  c.Value = m_Usuario
  c.HelpId = m_Us_id
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscTarId)
  c.PropertyType = cspHelp
  c.Table = cstblTarea
  c.Name = LNGGetText(1836, vbNullString) 'Tarea
  c.HelpFilter = "'t.proy_id = " & m_Proy_id & _
                 " and proyi_id = " & m_Proyi_id & _
                 " and obje_id =" & m_Obje_id & "'"
  c.Key = K_TAR_ID
  c.Value = m_Tarea
  c.HelpId = m_Tar_id
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscHoraFacturable)
  c.PropertyType = cspCheck
  c.Name = LNGGetText(2653, vbNullString) 'Facturable
  c.Key = K_FACTURABLE
  c.Value = m_Facturable
    
  Set c = m_ObjAbm.Properties.Add(Nothing, cscHoraDesde)
  c.PropertyType = cspTime
  c.TopFromProperty = cscHoraFecha
  c.Left = 9000
  c.LeftLabel = -1000
  c.Name = LNGGetText(1767, vbNullString) 'Hora Desde
  c.Key = K_DESDE
  c.Value = m_Desde
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscHoraHasta)
  c.PropertyType = cspTime
  c.Name = LNGGetText(2533, vbNullString) 'Hasta
  c.TopToPrevious = -1
  c.LeftToPrevious = 2750
  c.LeftLabel = -600
  c.Key = K_HASTA
  c.Value = m_Hasta

  Set c = m_ObjAbm.Properties.Add(Nothing, cscHoraHoras)
  c.PropertyType = cspTime
  c.Name = LNGGetText(1769, vbNullString) 'Tiempo
  c.Key = K_HORAS
  c.Value = pGetTiempo(m_Horas, m_Minutos)

'  Set c = m_ObjAbm.Properties.Add(nothing, cscHoraHoras)
'  c.PropertyType = cspNumeric
'  c.Name = "Horas"
'  c.SubType = cspInteger
'  c.Key = K_HORAS
'  c.Value = Horas
'
'  Set c = m_ObjAbm.Properties.Add(nothing, cscHoraMinutos)
'  c.PropertyType = cspNumeric
'  c.SubType = cspInteger
'  c.Name = "Minutos"
'  c.Key = K_MINUTOS
'  c.Value = Minutos
'
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscHoraTitulo)
  c.PropertyType = cspText
  c.LeftFromProperty = cscHoraFecha
  c.TopFromProperty = cscProyIId
  c.TopToPrevious = 440
  c.Name = LNGGetText(1864, vbNullString) 'Título
  c.Width = 9800
  c.Size = 255
  c.Key = K_TITULO
  c.Value = m_Titulo
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscHoraDescrip)
  c.PropertyType = cspText
  c.SubType = cspMemo
  c.Name = C_strDescrip
  c.Width = 9800
  c.Size = 1000
  c.Height = 725
  c.Key = K_DESCRIP
  c.Value = m_Descrip
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

Private Function Load(ByVal Id As Long) As Boolean

  Dim sqlstmt As String

  sqlstmt = "sp_horaGet " & Id

  Dim rs As Recordset

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.fields, cscHoraId)
    m_Titulo = gDB.ValField(rs.fields, cscHoraTitulo)
    m_Descrip = gDB.ValField(rs.fields, cscHoraDescrip)
    m_Fecha = gDB.ValField(rs.fields, cscHoraFecha)
    m_Desde = gDB.ValField(rs.fields, cscHoraDesde)
    m_Hasta = gDB.ValField(rs.fields, cscHoraHasta)
    m_Horas = gDB.ValField(rs.fields, cscHoraHoras)
    m_Minutos = gDB.ValField(rs.fields, cscHoraMinutos)
    m_Facturable = gDB.ValField(rs.fields, cscHoraFacturable)
    m_Cli_id = gDB.ValField(rs.fields, cscCliId)
    m_Proy_id = gDB.ValField(rs.fields, cscProyId)
    m_Proyi_id = gDB.ValField(rs.fields, cscProyIId)
    m_Obje_id = gDB.ValField(rs.fields, cscObjeId)
    m_Us_id = gDB.ValField(rs.fields, cscUsId)
    m_Tar_id = gDB.ValField(rs.fields, cscTarId)
    
    m_Cliente = gDB.ValField(rs.fields, cscCliNombre)
    m_Proyecto = gDB.ValField(rs.fields, cscProyNombre)
    m_ProyectoItem = gDB.ValField(rs.fields, cscProyINombre)
    m_Objetivo = gDB.ValField(rs.fields, cscObjeNombre)
    m_Usuario = gDB.ValField(rs.fields, cscUsNombre)
    m_Tarea = gDB.ValField(rs.fields, cscTarNombre)
    
    m_Creado = gDB.ValField(rs.fields, cscCreado)
    m_Modificado = gDB.ValField(rs.fields, cscModificado)
    m_Modifico = gDB.ValField(rs.fields, cscModifico)

  Else
  
    If gLastUser Is Nothing Then Set gLastUser = CSOAPI2.User
  
    m_Id = csNO_ID
    m_Titulo = vbNullString
    m_Descrip = vbNullString
    m_Fecha = Date
    m_Desde = csNoDate
    m_Hasta = csNoDate
    m_Horas = 0
    m_Minutos = 0
    m_Facturable = 0
    m_Cli_id = csNO_ID
    m_Proy_id = csNO_ID
    m_Proyi_id = csNO_ID
    m_Obje_id = csNO_ID
    m_Us_id = gLastUser.Id
    m_Tar_id = csNO_ID
    
    m_Cliente = vbNullString
    m_Proyecto = vbNullString
    m_ProyectoItem = vbNullString
    m_Objetivo = vbNullString
    m_Usuario = gLastUser.Name
    m_Tarea = vbNullString
    
    m_Creado = csNoDate
    m_Modificado = csNoDate
    m_Modifico = 0

  End If

  Load = True
End Function

Private Function pGetTiempo(ByVal Horas As Integer, ByVal Minutos As Integer) As String
  pGetTiempo = Format(Horas, "00") & ":" & Format(Minutos, "00")
End Function
' construccion - destruccion

Private Sub Class_Initialize()
  On Error GoTo ControlError

  c_ErrorSave = LNGGetText(2654, vbNullString) 'Error al grabar Hora

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
  Set m_ObjAbm = Nothing
  Set m_ObjTree = Nothing
End Sub




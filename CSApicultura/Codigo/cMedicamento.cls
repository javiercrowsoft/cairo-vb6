VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cMedicamento"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True

Option Explicit
Implements CSInterfacesABM.cIEditGeneric
Implements CSInterfacesABM.cIABMClient
Implements CSMenu.cIMenuClient
'--------------------------------------------------------------------------------
' cMedicamento
' 00-06-03

'--------------------------------------------------------------------------------
' notas:

' med          reemplazar por el prefijo de la tabla (ej pro)
' Medicamento           reemplazar por el nombre de la tabla (ej Provincia)
' cMedicamento           reemplazar por el nombre de la clase (ej cProvincia)
' Medicamentos         reemplazar por el nombre logico del abm (ej Provincias)
' PreA     reemplazar por el prefijo de las prestaciones (ej PreA)
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cMedicamento"

Private Const K_NOMBRE                         As Integer = 1
Private Const K_CODIGO                         As Integer = 2
Private Const K_DESCRIP                        As Integer = 3
Private Const K_FECHAVTO                       As Integer = 4
Private Const K_CANTIDAD                       As Integer = 5
Private Const K_UN_ID                          As Integer = 7
Private Const K_ACTIVO                         As Integer = 8
' estructuras
' variables privadas
Private m_Id                           As Long
Private m_Nombre                       As String
Private m_Codigo                       As String
Private m_Descrip                      As String
Private m_FechaVto                     As Date
Private m_Cantidad                     As Double
Private m_Un_id                        As Long
Private m_Unidad                       As String
Private m_medicamento                  As String
Private m_Creado                       As Date
Private m_Modificado                   As Date
Private m_Modifico                     As Long
Private m_Activo                       As Boolean

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
Public Property Get ID() As Long
  ID = m_Id
End Property

Public Property Let ID(ByVal rhs As Long)
  m_Id = rhs
End Property

Public Property Get Nombre() As String
  Nombre = m_Nombre
End Property

Public Property Let Nombre(ByVal rhs As String)
  m_Nombre = rhs
End Property

Public Property Get Codigo() As String
  Codigo = m_Codigo
End Property

Public Property Let Codigo(ByVal rhs As String)
  m_Codigo = rhs
End Property

Public Property Get Descrip() As String
  Descrip = m_Descrip
End Property

Public Property Let Descrip(ByVal rhs As String)
  m_Descrip = rhs
End Property

Public Property Get FechaVto() As Date
  FechaVto = m_FechaVto
End Property

Public Property Let FechaVto(ByVal rhs As Date)
  m_FechaVto = rhs
End Property

Public Property Get Cantidad() As Double
  Cantidad = m_Cantidad
End Property

Public Property Let Cantidad(ByVal rhs As Double)
  m_Cantidad = rhs
End Property

Public Property Get Un_id() As Long
  Un_id = m_Un_id
End Property

Public Property Let Un_id(ByVal rhs As Long)
  m_Un_id = rhs
End Property

Public Property Get Unidad() As String
  Unidad = m_Unidad
End Property

Public Property Let Unidad(ByVal rhs As String)
  m_Unidad = rhs
End Property

Public Property Get medicamento() As String
  medicamento = m_medicamento
End Property

Public Property Let medicamento(ByVal rhs As String)
  m_medicamento = rhs
End Property

Public Property Get Creado() As Date
  Creado = m_Creado
End Property

Public Property Let Creado(ByVal rhs As Date)
  m_Creado = rhs
End Property

Public Property Get Modificado() As Date
  Modificado = m_Modificado
End Property

Public Property Let Modificado(ByVal rhs As Date)
  m_Modificado = rhs
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


' Properties privadas
' funciones publicas


' Implementacion de cIABMClient
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

Private Function cIABMClient_Copy() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True
  
  With m_ObjAbm.Properties(cscMedCodigo)
    .Value = "C-" & .Value
  End With
  
  With m_ObjAbm.Properties(cscMedNombre)
    .Value = "Copia de " & .Value
  End With
  
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscMedCodigo)
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscMedNombre)
  
  m_Copy = True
End Function

Private Sub cIABMClient_DiscardChanges()
    LoadCollection
End Sub

Private Function cIABMClient_EditNew() As Boolean

  cIABMClient_Terminate
  m_IsNew = True

  cIEditGeneric_Edit csNO_ID
End Function

Private Function cIABMClient_ListAdHock(List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClient_Load()

End Sub

Private Function cIABMClient_ShowDocDigital() As Boolean
  On Error GoTo ControlError
  
  If m_Id = csNO_ID Then Exit Function
  
  Dim Doc As cDocDigital
  Set Doc = New cDocDigital

  Doc.ClientTable = csTMedicamento
  Doc.ClientTableID = m_Id

  cIABMClient_ShowDocDigital = Doc.ShowDocs(gDB)

  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClient_ShowDocDigital", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIABMClient_MessageEx(ByVal MessageID As Long, ByVal Info As Variant) As Boolean
  cIABMClient_MessageEx = True
End Function

Private Function cIABMClient_PropertyChange(ByVal Key As Integer) As Boolean

End Function

Private Function cIABMClient_Save() As Boolean
  Dim register As cRegister
  Set register = New cRegister
  register.fieldId = cscMedId
  register.Table = csTMedicamento

  If m_Copy Then
    register.ID = csNew
  Else
    register.ID = m_Id
  End If

  Dim IProperty As cIABMProperty
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_NOMBRE
          register.Fields.Add2 cscMedNombre, .Value, csText
        Case K_CODIGO
          register.Fields.Add2 cscMedCodigo, .Value, csText
        Case K_DESCRIP
          register.Fields.Add2 cscMedDescrip, .Value, csText
        Case K_FECHAVTO
          register.Fields.Add2 cscMedFechaVto, .Value, csDate
        Case K_CANTIDAD
          register.Fields.Add2 cscMedCantidad, .Value, csDouble
        Case K_UN_ID
          register.Fields.Add2 cscUnId, .HelpId, csId
        Case K_ACTIVO
          register.Fields.Add2 cscActivo, .Value, csBoolean

      End Select
    End With
  Next
  
  register.Fields.HaveLastUpdate = True
  register.Fields.HaveWhoModify = True
  
  If Not gDB.Save(register, , "cIABMClient_Save", "cmedicamento", "Error al grabar medicamento") Then Exit Function
  
  m_Copy = False
  cIABMClient_Save = Load(register.ID)
End Function

Private Function cIABMClient_Terminate() As Boolean
    m_Editing = False
    
    cIABMClient_Terminate = True
    ' Este objeto puede no cumplir con la interfaz esperada, asi que si hay un error no
    ' le doy bola
    On Error GoTo ControlError
    If m_Id = csNO_ID Then Exit Function
    If m_ObjTree Is Nothing Then Exit Function
    
    If m_IsNew Then
        m_ObjTree.AddLeave m_Id, m_BranchId, m_TreeId
    Else
        m_ObjTree.AddEditedId m_Id
        m_ObjTree.RefreshActiveBranch
    End If
ControlError:
End Function

Private Property Get cIABMClient_Title() As String
    cIABMClient_Title = "Medicamentos"
End Property

Private Function cIABMClient_Validate() As Boolean

  Dim IProperty As cIABMProperty

  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_NOMBRE
          If ValEmpty(.Value, csText) Then
            MsgInfo "Debe indicar un nombre"
            Exit Function
          End If
        Case K_CODIGO
          If ValEmpty(.Value, csText) Then
            MsgInfo "Debe indicar un código"
            Exit Function
          End If
        Case K_DESCRIP
          If ValEmpty(.Value, csText) Then
            MsgInfo "Debe indicar un descrip"
            Exit Function
          End If
        Case K_FECHAVTO
          If ValEmpty(.Value, csDate) Then
            MsgInfo "Debe indicar un fechavto"
            Exit Function
          End If
        Case K_CANTIDAD
          If ValEmpty(.Value, csDouble) Then
            MsgInfo "Debe indicar un cantidad"
            Exit Function
          End If
        Case K_UN_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo "Debe indicar un un_id"
            Exit Function
          End If

      End Select
    End With
  Next

  cIABMClient_Validate = True
End Function


Private Function cIEditGeneric_Edit(ID As Long, Optional ByVal InModalWindow As Boolean) As Boolean
    On Error GoTo ControlError
    
    If ID = csNO_ID Then
        m_IsNew = True
        If Not SecurityCanAccess(csPreANewMedicamento) Then Exit Function
    Else
        m_IsNew = False
        If Not SecurityCanAccess(csPreAEditMedicamento) Then Exit Function
    End If

    If Not Load(ID) Then Exit Function
    
    If Not LoadCollection() Then Exit Function
    
    m_Editing = True
    cIEditGeneric_Edit = True
    Exit Function
ControlError:
    MngError Err, "cIEditGeneric_Edit", "cMedicamento", ""
End Function

' Implementacion de cIEditGeneric

Private Function cIEditGeneric_TabClick(ByVal Index As Integer) As Boolean

End Function

Private Property Let cIEditGeneric_TreeId(ByVal rhs As Long)
    m_TreeId = rhs
End Property

Private Property Get cIEditGeneric_TreeId() As Long
    cIEditGeneric_TreeId = m_TreeId
End Property

Private Function cIEditGeneric_GridAdd(ByVal KeyProperty As Integer) As Boolean

End Function

Private Function cIEditGeneric_GridEdit(ByVal KeyProperty As Integer) As Boolean

End Function

Private Function cIEditGeneric_GridRemove(ByVal KeyProperty As Integer) As Boolean

End Function

Private Function cIEditGeneric_ShowList() As Boolean
    cIEditGeneric_ShowList = SecurityCanAccess(csPreAListMedicamento)
End Function

Private Property Get cIEditGeneric_ObjAbm() As CSInterfacesABM.cIABMGeneric
  Set cIEditGeneric_ObjAbm = m_ObjAbm
End Property

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
    Set m_ObjAbm = rhs
End Property

Private Property Get cIEditGeneric_Editing() As Boolean
    cIEditGeneric_Editing = m_Editing
End Property

Private Function cIEditGeneric_Delete(ID As Long) As Boolean
    If Not SecurityCanAccess(csPreADeleteMedicamento) Then Exit Function

    Dim sqlstmt As String
    
    sqlstmt = "Delete " & csTMedicamento & " where " & cscMedId & " = " & ID
    
    cIEditGeneric_Delete = gDB.Execute(sqlstmt, "cIEditGeneric_Delete", "cMedicamento")
End Function

Private Function cIEditGeneric_Search(ID As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_PrintObj(ByVal ID As Long) As Boolean

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

Private Function cIEditGeneric_Preview(ByVal ID As Long) As Boolean

End Function

Private Function cIEditGeneric_PropertyChange(ByVal Key As Integer) As Boolean

End Function
Private Function cIMenuClient_Initialize(F As Object, Host As CSMenu.cIMenuHost) As Boolean
  On Error GoTo ControlError

  Set m_Host = Host
  m_Host.Server.AddMenu "&Medicamentos", csPreAListMedicamento, "&Apicultura", 0, True, False, False, False, False, Me

  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, "cIMenuClient_Initialize", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal ID As Long) As Variant
  m_Host.MenuABMClick "CSApicultura.cMedicamento", Me, "Medicamentos", 0, csETablesApicultura.csMedicamento
End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  m_ObjAbm.Properties.Clear
  
  Dim c As cIABMProperty

  Set c = m_ObjAbm.Properties.Add(c, cscMedNombre)
  c.PropertyType = cspText
  c.Name = "Nombre"
  c.Size = 50
  c.Key = K_NOMBRE
  c.Value = Nombre
  Set c = Nothing
  
  Set c = m_ObjAbm.Properties.Add(c, cscMedCodigo)
  c.PropertyType = cspText
  c.Name = "Código"
  c.Size = 10
  c.Key = K_CODIGO
  c.Value = Codigo
  Set c = Nothing
  
  Set c = m_ObjAbm.Properties.Add(c, cscActivo)
  c.PropertyType = cspCheck
  c.Name = "activo"
  c.Key = K_ACTIVO
  c.Value = CInt(m_Activo)
  Set c = Nothing
   
  Set c = m_ObjAbm.Properties.Add(c, cscMedFechaVto)
  c.PropertyType = cspDate
  c.Name = "Vencimiento"
  c.Key = K_FECHAVTO
  c.Value = FechaVto
  Set c = Nothing
   
  Set c = m_ObjAbm.Properties.Add(c, cscMedDescrip)
  c.PropertyType = cspText
  c.Name = "Descripción"
  c.Size = 255
  c.SubType = cspMemo
  c.Height = 880
  c.Width = 6500
  c.Key = K_DESCRIP
  c.Value = Descrip
  Set c = Nothing
  
  Set c = m_ObjAbm.Properties.Add(c, cscMedCantidad)
  c.PropertyType = cspNumeric
  c.SubType = cspDouble
  c.Name = "Cantidad"
  c.TopFromProperty = cscMedNombre
  c.Left = 5800
  c.Key = K_CANTIDAD
  c.Value = Cantidad
  Set c = Nothing
  
  Set c = m_ObjAbm.Properties.Add(c, cscUnId)
  c.PropertyType = cspHelp
  c.Table = csUnidad
  c.Name = "Unidad"
  c.Key = K_UN_ID
  c.Value = m_Unidad
  c.HelpId = m_Un_id
  Set c = Nothing
  
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

Private Function Load(ByVal ID As Long) As Boolean

  Dim sqlstmt As String

  sqlstmt = sqlstmt & "select medicamento.*, un_nombre from medicamento,unidad "
  sqlstmt = sqlstmt & " where med_id = " & ID
  sqlstmt = sqlstmt & " and medicamento.un_id = unidad.un_id"
  

  Dim rs As Recordset

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "Load", "cmedicamento") Then Exit Function

  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.Fields, cscMedId)
    m_Nombre = gDB.ValField(rs.Fields, cscMedNombre)
    m_Codigo = gDB.ValField(rs.Fields, cscMedCodigo)
    m_Descrip = gDB.ValField(rs.Fields, cscMedDescrip)
    m_FechaVto = gDB.ValField(rs.Fields, cscMedFechaVto)
    m_Cantidad = gDB.ValField(rs.Fields, cscMedCantidad)
    m_Un_id = gDB.ValField(rs.Fields, cscUnId)
    m_Unidad = gDB.ValField(rs.Fields, cscUnNombre)
    m_Creado = gDB.ValField(rs.Fields, cscCreado)
    m_Modificado = gDB.ValField(rs.Fields, cscModificado)
    m_Modifico = gDB.ValField(rs.Fields, cscModifico)
    m_Activo = IIf(LCase(gDB.ValField(rs.Fields, cscActivo)) <> "si", 0, 1)

  Else
    m_Id = csNO_ID
    m_Nombre = ""
    m_Codigo = ""
    m_Descrip = ""
    m_FechaVto = csNoDate
    m_Cantidad = 0
    m_Un_id = csNO_ID
    m_Unidad = ""
    m_Creado = csNoDate
    m_Modificado = csNoDate
    m_Modifico = 0
    m_Activo = False

  End If

  Load = True
End Function

' construccion - destruccion

Private Sub Class_Initialize()
'
End Sub

Private Sub Class_Terminate()
    Set m_ObjAbm = Nothing
    Set m_ObjTree = Nothing
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



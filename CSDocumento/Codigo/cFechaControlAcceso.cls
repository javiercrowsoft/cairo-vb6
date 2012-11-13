VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cFechaControlAcceso"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGeneric
Implements CSInterfacesABM.cIABMClient
Implements CSMenu.cIMenuClient
'--------------------------------------------------------------------------------
' cFechaControlAcceso
' 23-03-02

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module As String = "cFechaControlAcceso"

Private Const K_NOMBRE            As Integer = 1
Private Const K_CODIGO            As Integer = 2
Private Const K_ACTIVO            As Integer = 3
Private Const K_FECHADESDE        As Integer = 4
Private Const K_FECHAHASTA        As Integer = 5

' Seudo - Variables
Private c_ErrorSave         As String

' estructuras
' variables privadas
Private m_Id                As Long
Private m_Nombre            As String
Private m_Codigo            As String
Private m_FechaDesde        As Date
Private m_FechaHasta        As Date
Private m_Activo            As Boolean
Private m_Modificado        As Date
Private m_Creado            As Date
Private m_Modifico          As Long


Private m_Editing          As Boolean

Private m_ObjAbm           As cIABMGeneric
Private m_ObjTree          As Object

Private m_IsNew            As Boolean

Private m_BranchId         As Long
Private m_TreeId           As Long

Private m_Host             As CSMenu.cIMenuHost
Private m_Copy             As Boolean

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

Public Property Get Codigo() As String
    Codigo = m_Codigo
End Property

Public Property Let Codigo(ByVal rhs As String)
    m_Codigo = rhs
End Property
' propiedades privadas
' funciones publicas


' Implementacion de cIABMClient
Private Function cIABMClient_Copy() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True
  
  With m_ObjAbm.Properties(cscFcaCodigo)
    .Value = "C-" & .Value
  End With
    
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscFcaCodigo)
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscFcaNombre)
  
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

  Doc.ClientTable = csTfechaControlAcceso
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

Private Function cIABMClient_ListAdHock(Lista As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClient_Load()

End Sub

Private Function cIABMClient_PropertyChange(ByVal Clave As Integer) As Boolean

End Function

Private Function cIABMClient_Save() As Boolean
    Dim register As cRegister
    Dim fields   As cFields
    
    Set register = New cRegister
    
    With register
      Set fields = .fields
      .fieldId = cscFcaId
      .Table = csTfechaControlAcceso
  
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
                Case K_NOMBRE
                    fields.Add2 cscFcaNombre, .Value, csText
                Case K_CODIGO
                    fields.Add2 cscFcaCodigo, .Value, csText
                Case K_ACTIVO
                    fields.Add2 cscActivo, Val(.Value), csBoolean
                Case K_FECHADESDE
                    fields.Add2 cscFcaFechaDesde, .Value, csDate
                Case K_FECHAHASTA
                    fields.Add2 cscFcaFechaHasta, .Value, csDate
            End Select
        End With
    Next
    
    fields.HaveLastUpdate = True
    fields.HaveWhoModify = True
    
    If Not gDB.Save(register, , "cIABMClient_Save", C_Module, c_ErrorSave) Then Exit Function
    
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
    
    If m_IsNew Then
        m_ObjTree.AddLeave m_Id, m_BranchId, m_TreeId
    Else
        m_ObjTree.AddEditedId m_Id
        m_ObjTree.RefreshActiveBranch
    End If
ControlError:
End Function

Private Property Get cIABMClient_Title() As String
    cIABMClient_Title = LNGGetText(2571, vbNullString) 'Fechas de control de acceso
End Property

Private Function cIABMClient_Validate() As Boolean
    Dim IProperty As cIABMProperty
    
    For Each IProperty In m_ObjAbm.Properties
        With IProperty
            Select Case .Key
                Case K_NOMBRE
                    If ValEmpty(.Value, csText) Then
                        MsgInfo LNGGetText(1007, vbNullString) 'Debe indicar un nombre
                        Exit Function
                    End If
                Case K_CODIGO
                    If ValEmpty(.Value, csText) Then
                        MsgInfo LNGGetText(1008, vbNullString) 'Debe indicar un código
                        Exit Function
                    End If
                Case K_FECHADESDE
                    If ValEmpty(.Value, csDate) Then
                        MsgInfo LNGGetText(2393, vbNullString) 'Debe indicar una fecha desde
                        Exit Function
                    End If
                Case K_FECHAHASTA
                    If ValEmpty(.Value, csDate) Then
                        MsgInfo LNGGetText(2394, vbNullString) 'Debe indicar una fecha hasta
                        Exit Function
                    End If
            End Select
        End With
    Next
    
    cIABMClient_Validate = True
End Function

' Implementacion de cIEditGeneric
Private Property Get cIEditGeneric_ObjAbm() As CSInterfacesABM.cIABMGeneric
  Set cIEditGeneric_ObjAbm = m_ObjAbm
End Property

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
    cIEditGeneric_ShowList = SecurityCanAccess(csPreDListFechaControlAcceso)
End Function

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
    Set m_ObjAbm = rhs
End Property

Private Property Get cIEditGeneric_Editing() As Boolean
    cIEditGeneric_Editing = m_Editing
End Property

Private Function cIEditGeneric_Delete(Id As Long) As Boolean
    If Not SecurityCanAccess(csPreDDeleteFechaControlAcceso) Then Exit Function

    Dim sqlstmt As String
    
    sqlstmt = "Delete fechaControlAcceso where fca_id = " & Id
    
    cIEditGeneric_Delete = gDB.Execute(sqlstmt, "cIEditGeneric_Delete", C_Module)
End Function

Private Function cIEditGeneric_Search(Id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Id = csNO_ID Then
    m_IsNew = True
    If Not SecurityCanAccess(csPreDNewFechaControlAcceso) Then Exit Function
  Else
    m_IsNew = False
    If Not SecurityCanAccess(csPreDEditFechaControlAcceso) Then Exit Function
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

Private Function cIEditGeneric_PropertyChange(ByVal Clave As Integer) As Boolean

End Function

Private Property Let cIEditGeneric_BranchId(ByVal rhs As Long)
    m_BranchId = rhs
End Property

Private Property Get cIEditGeneric_BranchId() As Long
    cIEditGeneric_BranchId = m_BranchId
End Property

Private Function cIEditGeneric_TabClick(ByVal Index As Integer) As Boolean

End Function

Private Function cIEditGeneric_Preview(ByVal Id As Long) As Boolean

End Function

Private Function cIMenuClient_Initialize(F As Object, Host As CSMenu.cIMenuHost) As Boolean
  On Error GoTo ControlError
  Dim str_2569 As String
  
  str_2569 = LNGGetText(2569, vbNullString) '&Documentos
  Set m_Host = Host
                                                          'Co&nfiguración
  m_Host.Server.AddMenu str_2569, csMenuConfigDocumentos, LNGGetText(1028, vbNullString), 0, True, False, True, False, True, Nothing
  m_Host.Server.AddMenu LNGGetText(2622, vbNullString), csPreDListFechaControlAcceso, str_2569, 0, True, False, False, False, False, Me
                        '&Fechas de Control de Acceso
  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, "cIMenuClient_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal Id As Long) As Variant
  m_Host.MenuABMClick "CSDocumentoEdit.cFechaControlAcceso", Me, LNGGetText(2571, vbNullString), 0, csETablasDocumento.csFechaControlAcceso
                                                                'Fechas de Control de Acceso
End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  
  With m_ObjAbm.Properties
    
    .Clear
    
    With .Add(Nothing, cscFcaNombre)
      .PropertyType = cspText
      .Name = C_strNombre
      .Size = 30
      .Key = K_NOMBRE
      .Value = m_Nombre
    End With
    
    With .Add(Nothing, cscFcaCodigo)
      .PropertyType = cspText
      .Name = C_strCodigo
      .Size = 15
      .Value = m_Codigo
      .Key = K_CODIGO
    End With
    
    With .Add(Nothing, cscFcaFechaDesde)
      .PropertyType = cspDate
      .Name = LNGGetText(1203, vbNullString) 'Fecha desde
      .Value = m_FechaDesde
      .Key = K_FECHADESDE
    End With
    
    With .Add(Nothing, cscFcaFechaHasta)
      .PropertyType = cspDate
      .Name = LNGGetText(1204, vbNullString) 'Fecha hasta
      .Value = m_FechaHasta
      .Key = K_FECHAHASTA
    End With
    
    With .Add(Nothing, cscActivo)
      .PropertyType = cspCheck
      .Name = C_strActivo
      .Key = K_ACTIVO
      .Value = CInt(m_Activo)
    End With
  
  End With
  If Not m_ObjAbm.Show(Me) Then Exit Function

  LoadCollection = True
End Function

Private Function Load(ByVal Id As Long) As Boolean
    Dim sqlstmt As String
    
    sqlstmt = "select * from fechaControlAcceso  where fca_id = " & Id
    
    Dim rs As ADODB.Recordset
    
    If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function
    
   If Not rs.EOF Then

      m_Id = gDB.ValField(rs.fields, cscFcaId)
      m_Nombre = gDB.ValField(rs.fields, cscFcaNombre)
      m_Codigo = gDB.ValField(rs.fields, cscFcaCodigo)
      m_FechaDesde = gDB.ValField(rs.fields, cscFcaFechaDesde)
      m_FechaHasta = gDB.ValField(rs.fields, cscFcaFechaHasta)
      m_Activo = gDB.ValField(rs.fields, cscActivo)
      m_Creado = gDB.ValField(rs.fields, cscCreado)
      m_Modificado = gDB.ValField(rs.fields, cscModificado)
      m_Modifico = gDB.ValField(rs.fields, cscModifico)

    Else
      m_Id = csNO_ID
      m_Nombre = vbNullString
      m_Codigo = vbNullString
      m_FechaDesde = VDGetDateById(csMonth_FirstDay)
      m_FechaHasta = VDGetDateById(csMonth_LastDay)
      m_Activo = True
      m_Creado = csNoDate
      m_Modificado = csNoDate
      m_Modifico = 0
    End If

    Load = True
End Function
' construccion - destruccion

Private Sub Class_Initialize()
On Error GoTo ControlError
  
  c_ErrorSave = LNGGetText(2623, vbNullString)
                'Error al grabar Fechas de Control de Acceso a Documentos
  
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


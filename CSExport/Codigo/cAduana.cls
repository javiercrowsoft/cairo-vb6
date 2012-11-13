VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cAduana"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGeneric
Implements CSInterfacesABM.cIABMClient
Implements CSMenu.cIMenuClient
'--------------------------------------------------------------------------------
' cAduana
' 28-04-04

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cAduana"

Private Const K_NOMBRE                         As Integer = 1
Private Const K_CODIGO                         As Integer = 2
Private Const K_DESCRIP                        As Integer = 3
Private Const K_PA_ID                          As Integer = 4
Private Const K_ACTIVO                         As Integer = 5

' Seudo - Variables
Private c_ErrorSave         As String

' estructuras
' variables privadas
Private m_Id                           As Long
Private m_Nombre                       As String
Private m_Codigo                       As String
Private m_Descrip                      As String
Private m_Pa_id                        As Long
Private m_Pais                         As String
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
Private m_Copy              As Boolean

Private m_Host              As CSMenu.cIMenuHost

' Properties publicas
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

Private Function cIABMClient_ShowDocDigital() As Boolean
  On Error GoTo ControlError
  
  If m_Id = csNO_ID Then Exit Function
  
  Dim Doc As cDocDigital
  Set Doc = New cDocDigital

  Doc.ClientTable = csTAduana
  Doc.ClientTableID = m_Id

  cIABMClient_ShowDocDigital = Doc.ShowDocs(gDB)

  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClient_ShowDocDigital", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIABMClient_EditNew() As Boolean

  cIABMClient_Terminate
  m_IsNew = True

  cIEditGeneric_Edit csNO_ID
End Function

Private Function cIABMClient_MessageEx(ByVal MessageID As Long, ByVal Info As Variant) As Variant
  cIABMClient_MessageEx = True
End Function

Private Sub cIABMClient_DiscardChanges()
    LoadCollection
End Sub

Private Function cIABMClient_Copy() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True

  With m_ObjAbm.Properties(cscAduCodigo)
    .Value = C_C & .Value
  End With
  
  With m_ObjAbm.Properties(cscAduNombre)
    .Value = C_CopiaDe & .Value
  End With
  
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscAduCodigo)
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscAduNombre)
  
  m_Copy = True
End Function

Private Function cIABMClient_ListAdHock(List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClient_Load()

End Sub

Private Function cIABMClient_PropertyChange(ByVal Key As Integer) As Boolean

End Function

Private Function cIABMClient_Save() As Boolean
  Dim register As cRegister
  Set register = New cRegister
  
  register.fieldId = cscAduId
  register.Table = csTAduana
  
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
          register.Fields.Add2 cscAduNombre, .Value, csText
        Case K_CODIGO
          register.Fields.Add2 cscAduCodigo, .Value, csText
        Case K_DESCRIP
          register.Fields.Add2 cscAduDescrip, .Value, csText
        Case K_PA_ID
          register.Fields.Add2 cscPaId, .HelpId, csId
        Case K_ACTIVO
          register.Fields.Add2 cscActivo, .Value, csBoolean
      End Select
    End With
  Next
  
  register.Fields.HaveLastUpdate = True
  register.Fields.HaveWhoModify = True
  
  If Not gDB.Save(register, , "cIABMClient_Save", C_Module, c_ErrorSave) Then Exit Function
  
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
    cIABMClient_Title = LNGGetText(2417, vbNullString) 'Aduanas
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
        Case K_PA_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(1411, vbNullString) 'Debe indicar un pais
            Exit Function
          End If
      End Select
    End With
  Next

  cIABMClient_Validate = True
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
    cIEditGeneric_ShowList = SecurityCanAccess(csPreExpListAduana)
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
    If Not SecurityCanAccess(csPreExpDeleteAduana) Then Exit Function

    Dim sqlstmt As String
    
    sqlstmt = "Delete Aduana where adu_id = " & ID
    
    cIEditGeneric_Delete = gDB.Execute(sqlstmt, "cIEditGeneric_Delete", C_Module)
End Function

Private Function cIEditGeneric_Search(ID As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(ID As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If ID = csNO_ID Then
    m_IsNew = True
    If Not SecurityCanAccess(csPreExpNewAduana) Then Exit Function
  Else
    m_IsNew = False
    If Not SecurityCanAccess(csPreExpEditAduana) Then Exit Function
  End If
  
  m_ObjAbm.InModalWindow = InModalWindow
  
  If Not Load(ID) Then Exit Function
  
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

' Menu
Private Function cIMenuClient_Initialize(F As Object, Host As CSMenu.cIMenuHost) As Boolean
  On Error GoTo ControlError
  Dim str_2418 As String
  
  str_2418 = LNGGetText(2418, vbNullString) '&Exportación
  Set m_Host = Host
                                                          'Co&nfiguración
  m_Host.Server.AddMenu str_2418, csMenuExportacionConfig, LNGGetText(1028, vbNullString), 0, True, False, True, False, True, Nothing
  m_Host.Server.AddMenu LNGGetText(2419, vbNullString), csPreExpListAduana, str_2418, 0, True, False, False, False, False, Me
                          '&Aduana
  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, "cIMenuClient_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal ID As Long) As Variant
  m_Host.MenuABMClick "CSExport2.cAduana", Me, LNGGetText(2417, vbNullString), 0, csETablesExport.csAduana
                                                'Aduanas
End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  Dim c As cIABMProperty
  
  m_ObjAbm.Properties.Clear
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscAduNombre)
  c.PropertyType = cspText
  c.Name = C_strNombre
  c.Size = 100
  c.Key = K_NOMBRE
  c.Value = m_Nombre
  

  Set c = m_ObjAbm.Properties.Add(Nothing, cscAduCodigo)
  c.PropertyType = cspText
  c.Name = C_strCodigo
  c.Size = 15
  c.Key = K_CODIGO
  c.Value = m_Codigo
  

  Set c = m_ObjAbm.Properties.Add(Nothing, cscActivo)
  c.PropertyType = cspCheck
  c.Name = C_strActivo
  c.Key = K_ACTIVO
  c.Value = CInt(m_Activo)
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscPaId)
  c.PropertyType = cspHelp
  c.Table = csPais
  c.Name = LNGGetText(1212, vbNullString) 'Pais
  c.Key = K_PA_ID
  c.Value = m_Pais
  c.HelpId = m_Pa_id
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscAduDescrip)
  c.PropertyType = cspText
  c.SubType = cspMemo
  c.Name = C_strDescrip
  c.Width = 5000
  c.Height = 880
  c.Size = 255
  c.Key = K_DESCRIP
  c.Value = m_Descrip
  
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

Private Function Load(ByVal ID As Long) As Boolean
  Dim sqlstmt As String
  Dim rs      As Recordset

  sqlstmt = "select Aduana.*,pa_nombre from Aduana inner join Pais on Aduana.pa_id = Pais.pa_id where adu_id = " & ID

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.Fields, cscAduId)
    m_Nombre = gDB.ValField(rs.Fields, cscAduNombre)
    m_Codigo = gDB.ValField(rs.Fields, cscAduCodigo)
    m_Descrip = gDB.ValField(rs.Fields, cscAduDescrip)
    m_Pa_id = gDB.ValField(rs.Fields, cscPaId)
    m_Pais = gDB.ValField(rs.Fields, cscPaNombre)
    m_Creado = gDB.ValField(rs.Fields, cscCreado)
    m_Modificado = gDB.ValField(rs.Fields, cscModificado)
    m_Modifico = gDB.ValField(rs.Fields, cscModifico)
    m_Activo = gDB.ValField(rs.Fields, cscActivo)

  Else
    m_Id = csNO_ID
    m_Nombre = vbNullString
    m_Codigo = vbNullString
    m_Descrip = vbNullString
    m_Pa_id = csNO_ID
    m_Pais = vbNullString
    m_Creado = csNoDate
    m_Modificado = csNoDate
    m_Modifico = 0
    m_Activo = True

  End If

  Load = True
End Function

Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  c_ErrorSave = LNGGetText(2416, vbNullString)  'Error al grabar Aduana
  
  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

' construccion - destruccion
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
'  If Err.Number Then Resume ExitProc
'ExitProc:
'  On Error Resume Next

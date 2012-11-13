VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cRetencionTipo"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGeneric
Implements CSInterfacesABM.cIABMClient
Implements CSMenu.cIMenuClient
'--------------------------------------------------------------------------------
' cRetencionTipo
' 27-06-04

'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cRetencionTipo"

Private Const K_NOMBRE                         As Integer = 1
Private Const K_CODIGO                         As Integer = 2
Private Const K_DESCRIP                        As Integer = 3
Private Const K_GENERASICORE                   As Integer = 4
Private Const K_CODIGOSICORE                   As Integer = 5
Private Const K_CUE_ID                         As Integer = 6
Private Const K_ACTIVO                         As Integer = 7
Private Const K_TIPO                           As Integer = 8

' estructuras
' variables privadas
Private m_Id                           As Long
Private m_Nombre                       As String
Private m_Codigo                       As String
Private m_descrip                      As String
Private m_GeneraSicore                 As Boolean
Private m_CodigoSicore                 As String
Private m_Cue_id                       As Long
Private m_Cuenta                       As String
Private m_Tipo                         As Integer
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

Public Enum csE_RetencionTipo
  csERetTSobreIva = 1
  csERetTSobreNeto = 2
  csERetTGanancias = 3
  csERetTBrutoEIva = 4
End Enum

' propiedades publicas

Public Property Get Id() As Long
  Id = m_Id
End Property

Public Property Get Nombre() As String
  Nombre = m_Nombre
End Property

Public Property Get Codigo() As String
  Codigo = m_Codigo
End Property
' propiedades privadas
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

  Doc.ClientTable = csTRetencionTipo
  Doc.ClientTableID = m_Id

  cIABMClient_ShowDocDigital = Doc.ShowDocs(gDB)

  GoTo ExitProc
ControlError:
  MngError Err, C_ShowDocDigital, C_Module, vbNullString
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
  Select Case MessageID
  
    Case MSG_DOC_INFO
    
      Dim AbmGen As cABMGeneric
      Set AbmGen = m_ObjAbm
      
      CSKernelClient2.ShowHelp AbmGen.hWnd, _
                               vbNullString, _
                               vbNullString, _
                               csPreGNewRetencionTipo
      cIABMClient_MessageEx = MSG_DOC_INFO_HANDLED
    Case Else
      cIABMClient_MessageEx = True
  End Select
End Function

Private Sub cIABMClient_DiscardChanges()
    LoadCollection
End Sub

Private Function cIABMClient_Copy() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True

  With m_ObjAbm.Properties(cscRettCodigo)
    .Value = C_C & .Value
  End With
  
'  With m_ObjAbm.Properties(cscRettNombre)
'    .Value = C_CopiaDe & .Value
'  End With
  
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscRettCodigo)
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscRettNombre)
  
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
  Dim fields     As cFields
  
  Set register = New cRegister
  Set fields = register.fields
  
  With register
    .fieldId = cscRettId
    .Table = csTRetencionTipo
    
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
          fields.Add2 cscRettNombre, .Value, csText
        Case K_CODIGO
          fields.Add2 cscRettCodigo, .Value, csText
        Case K_DESCRIP
          fields.Add2 cscRettDescrip, .Value, csText
        Case K_GENERASICORE
          fields.Add2 cscRettGeneraSicore, .Value, csBoolean
        Case K_CODIGOSICORE
          fields.Add2 cscRettCodigoSicore, .Value, csText
        Case K_CUE_ID
          fields.Add2 cscCueId, .HelpId, csId
        Case K_ACTIVO
          fields.Add2 cscActivo, .Value, csBoolean
        Case K_TIPO
          fields.Add2 cscRettTipo, .ListItemData, csInteger
      End Select
    End With
  Next
  
  fields.HaveLastUpdate = True
  fields.HaveWhoModify = True
                                                         'Error al grabar RetencionTipo
  If Not gDB.SaveEx(register, , _
                    cscRettCodigo, _
                    C_ABMClientSave, _
                    C_Module, _
                    LNGGetText(1421, vbNullString)) Then Exit Function
  
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
    cIABMClient_Title = LNGGetText(1422, vbNullString)  'Tipos de Retención
End Property

Private Function cIABMClient_Validate() As Boolean

  Dim IProperty       As cIABMProperty
  Dim bHaveSicore     As Boolean
  Dim bCodigoSicore   As Boolean

  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_NOMBRE
          If ValEmpty(.Value, csText) Then
            MsgInfo C_DebeIndicarNombre
            Exit Function
          End If
        Case K_CODIGO
          If ValEmpty(.Value, csText) Then
            .Value = c_get_codigo_from_id
          End If
        Case K_GENERASICORE
          If Not ValEmpty(Val(.Value), csInteger) Then
            bCodigoSicore = True
          End If
        Case K_CODIGOSICORE
          If Not ValEmpty(.Value, csText) Then
            bHaveSicore = True
          End If
        Case K_CUE_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(1261, vbNullString)
                    'Debe indicar una cuenta
            Exit Function
          End If

      End Select
    End With
  Next

  If bCodigoSicore And Not bHaveSicore Then
    MsgInfo LNGGetText(1263, vbNullString)
              'Debe indicar un código sicore
    Exit Function
  End If

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
    cIEditGeneric_ShowList = SecurityCanAccess(csPreGListRetencionTipo)
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

Private Function cIEditGeneric_Delete(Id As Long) As Boolean
    If Not SecurityCanAccess(csPreGDeleteRetencionTipo) Then Exit Function

    Dim sqlstmt As String
    
    sqlstmt = "delete RetencionTipo where rett_id = " & Id
    
    cIEditGeneric_Delete = gDB.Execute(sqlstmt, C_EditGenericDelete, C_Module)
End Function

Private Function cIEditGeneric_Search(Id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Id = csNO_ID Then
    m_IsNew = True
    If Not SecurityCanAccess(csPreGNewRetencionTipo) Then Exit Function
  Else
    m_IsNew = False
    If Not SecurityCanAccess(csPreGEditRetencionTipo) Then Exit Function
  End If
  
  m_ObjAbm.InModalWindow = InModalWindow
  
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
  MngError Err, C_EditGenericEdit, C_Module, vbNullString
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

' Menu
Private Function cIMenuClient_Initialize(F As Object, Host As CSMenu.cIMenuHost) As Boolean
  On Error GoTo ControlError

  Set m_Host = Host
  m_Host.Server.AddMenu C_MenuContabilidad, csMenuConfigContabilidad, C_MenuConfig, 0, True, False, True, False, True, Nothing
                        '&Tipos de Retención
  m_Host.Server.AddMenu LNGGetText(1423, vbNullString), csPreGListRetencionTipo, C_MenuContabilidad, 0, True, False, False, False, False, Me

  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, C_MenuClientInit, C_Module, vbNullString
  If Err.Number Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal Id As Long) As Variant
                                                      'Tipos de Retención
  m_Host.MenuABMClick "CSGeneral2.cRetencionTipo", Me, LNGGetText(1422, vbNullString), 0, csETablasGeneral.csRetencionTipo
End Function

' Funciones Privadas
Private Function LoadCollection() As Boolean
  
  m_ObjAbm.Title2 = m_Nombre
  
  With m_ObjAbm.Properties
    
    .Clear

    With .Add(Nothing, cscRettNombre)
      .PropertyType = cspText
      .Name = C_strNombre
      .Size = 100
      .Key = K_NOMBRE
      .Value = m_Nombre
    End With
    
    With .Add(Nothing, cscRettCodigo)
      .PropertyType = cspText
      .Name = C_strCodigo
      .Size = 15
      .Key = K_CODIGO
      .Value = m_Codigo
    End With
    
    With .Add(Nothing, cscActivo)
      .PropertyType = cspCheck
      .Name = C_strActivo
      .Key = K_ACTIVO
      .Value = CInt(m_Activo)
    End With
    
    With .Add(Nothing, cscRettGeneraSicore)
      .PropertyType = cspCheck
      .TopFromProperty = cscActivo
      .Left = 3500
      .Name = LNGGetText(1266, vbNullString)   'Genera Sicore
      .Key = K_GENERASICORE
      .Value = CInt(m_GeneraSicore)
    End With
    
    With .Add(Nothing, cscRettCodigoSicore)
      .PropertyType = cspText
      .TopFromProperty = cscRettNombre
      .Left = 5500
      .Name = LNGGetText(1265, vbNullString)   'Código Sicore
      .Size = 50
      .Key = K_CODIGOSICORE
      .Value = m_CodigoSicore
    End With
    
    With .Add(Nothing, cscCueId)
      .PropertyType = cspHelp
      .Table = csCuenta
      .Name = LNGGetText(1267, vbNullString)   'Cuenta
      .Key = K_CUE_ID
      .Value = m_Cuenta
      .HelpId = m_Cue_id
    End With
    
    With .Add(Nothing, cscRettTipo)
      .PropertyType = cspList
      .Name = LNGGetText(1223, vbNullString)   'Tipo
      .Key = K_TIPO
      .ListItemData = m_Tipo
      .ListWhoSetItem = csListItemData
  
      With .List.Add(Nothing)
        .Id = csERetTSobreIva
        .Value = LNGGetText(1424, vbNullString)   'Sobre Iva
      End With
      With .List.Add(Nothing)
        .Id = csERetTSobreNeto
        .Value = LNGGetText(1425, vbNullString)   'Sobre Neto
      End With
      With .List.Add(Nothing)
        .Id = csERetTGanancias
        .Value = LNGGetText(1426, vbNullString)   'Ganancias
      End With
      With .List.Add(Nothing)
        .Id = csERetTBrutoEIva
        .Value = LNGGetText(1427, vbNullString)   'Sobre el Total
      End With
    
    End With
    
    With .Add(Nothing, cscRettDescrip)
      .PropertyType = cspText
      .LeftFromProperty = cscRettCodigo
      .TopFromProperty = cscActivo
      .TopToPrevious = 440
      .SubType = cspMemo
      .Name = C_strDescrip
      .Size = 255
      .Width = 6250
      .Height = 880
      .Key = K_DESCRIP
      .Value = m_descrip
    End With
   
  End With
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

Private Function Load(ByVal Id As Long) As Boolean

  Dim sqlstmt As String
  Dim rs      As Recordset

  sqlstmt = "select rt.*,cue_nombre" & _
            " from RetencionTipo rt inner join Cuenta c on rt.cue_id = c.cue_id" & _
            " where rett_id = " & Id

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.fields, cscRettId)
    m_Nombre = gDB.ValField(rs.fields, cscRettNombre)
    m_Codigo = gDB.ValField(rs.fields, cscRettCodigo)
    m_descrip = gDB.ValField(rs.fields, cscRettDescrip)
    m_GeneraSicore = gDB.ValField(rs.fields, cscRettGeneraSicore)
    m_CodigoSicore = gDB.ValField(rs.fields, cscRettCodigoSicore)
    m_Cue_id = gDB.ValField(rs.fields, cscCueId)
    m_Cuenta = gDB.ValField(rs.fields, cscCueNombre)
    m_Tipo = gDB.ValField(rs.fields, cscRettTipo)
    m_Activo = gDB.ValField(rs.fields, cscActivo)

  Else
    m_Id = csNO_ID
    m_Nombre = vbNullString
    m_Codigo = vbNullString
    m_descrip = vbNullString
    m_GeneraSicore = False
    m_CodigoSicore = vbNullString
    m_Cue_id = csNO_ID
    m_Cuenta = vbNullString
    m_Tipo = 0
    m_Activo = True

  End If

  Load = True
End Function

' construccion - destruccion
Private Sub Class_Terminate()
  On Error Resume Next
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

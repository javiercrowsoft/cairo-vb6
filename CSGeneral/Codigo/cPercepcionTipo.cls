VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cPercepcionTipo"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGeneric
Implements CSInterfacesABM.cIABMClient
Implements CSMenu.cIMenuClient
'--------------------------------------------------------------------------------
' cPercepcionTipo
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
Private Const C_Module = "cPercepcionTipo"

Private Const K_NOMBRE                         As Integer = 1
Private Const K_CODIGO                         As Integer = 2
Private Const K_DESCRIP                        As Integer = 3
Private Const K_GENERASICORE                   As Integer = 4
Private Const K_CODIGOSICORE                   As Integer = 5
Private Const K_CUE_ID                         As Integer = 6
Private Const K_ACTIVO                         As Integer = 7

' estructuras
' variables privadas
Private m_Id                As Long
Private m_Nombre            As String
Private m_Codigo            As String
Private m_descrip           As String
Private m_GeneraSicore      As Boolean
Private m_CodigoSicore      As String
Private m_Cue_id            As Long
Private m_Cuenta            As String
Private m_Activo            As Boolean

'OJO HASTA ACA

Private m_Editing           As Boolean

Private m_ObjAbm            As cIABMGeneric
Private m_ObjTree           As Object

Private m_IsNew             As Boolean

Private m_BranchId          As Long
Private m_TreeId            As Long
Private m_Copy              As Boolean

Private m_Host              As CSMenu.cIMenuHost
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

  Doc.ClientTable = csTPercepcionTipo
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
                               csPreGNewPercepcionTipo
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

  With m_ObjAbm.Properties(cscPerctCodigo)
    .Value = C_C & .Value
  End With
  
'  With m_ObjAbm.Properties(cscPerctNombre)
'    .Value = C_CopiaDe & .Value
'  End With
  
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscPerctCodigo)
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscPerctNombre)
  
  m_Copy = True
End Function

Private Function cIABMClient_ListAdHock(List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClient_Load()

End Sub

Private Function cIABMClient_PropertyChange(ByVal Key As Integer) As Boolean

End Function

Private Function cIABMClient_Save() As Boolean
  Dim register   As cRegister
  Dim fields     As cFields
  
  Set register = New cRegister
  Set fields = register.fields
  
  With register
    .fieldId = cscPerctId
    .Table = csTPercepcionTipo
    
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
          fields.Add2 cscPerctNombre, .Value, csText
        Case K_CODIGO
          fields.Add2 cscPerctCodigo, .Value, csText
        Case K_DESCRIP
          fields.Add2 cscPerctDescrip, .Value, csText
        Case K_GENERASICORE
          fields.Add2 cscPerctGeneraSicore, .Value, csBoolean
        Case K_CODIGOSICORE
          fields.Add2 cscPerctCodigoSicore, .Value, csText
        Case K_CUE_ID
          fields.Add2 cscCueId, .HelpId, csId
        Case K_ACTIVO
          fields.Add2 cscActivo, .Value, csBoolean
      End Select
    End With
  Next
  
  fields.HaveLastUpdate = True
  fields.HaveWhoModify = True
                                                         'Error al grabar PercepcionTipo
  If Not gDB.SaveEx(register, , _
                    cscPerctCodigo, _
                    C_ABMClientSave, _
                    C_Module, _
                    LNGGetText(1268, vbNullString)) Then Exit Function
  
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
                      'Tipos de Percepción
  cIABMClient_Title = LNGGetText(1262, vbNullString)
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
    cIEditGeneric_ShowList = SecurityCanAccess(csPreGListPercepcionTipo)
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
    If Not SecurityCanAccess(csPreGDeletePercepcionTipo) Then Exit Function

    Dim sqlstmt As String
    
    sqlstmt = "delete PercepcionTipo where perct_id = " & Id
    
    cIEditGeneric_Delete = gDB.Execute(sqlstmt, C_EditGenericDelete, C_Module)
End Function

Private Function cIEditGeneric_Search(Id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Id = csNO_ID Then
    m_IsNew = True
    If Not SecurityCanAccess(csPreGNewPercepcionTipo) Then Exit Function
  Else
    m_IsNew = False
    If Not SecurityCanAccess(csPreGEditPercepcionTipo) Then Exit Function
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
                            '&Tipos de Percepción
  m_Host.Server.AddMenu LNGGetText(1264, vbNullString), csPreGListPercepcionTipo, C_MenuContabilidad, 0, True, False, True, False, False, Me

  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, C_MenuClientInit, C_Module, vbNullString
  If Err.Number Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal Id As Long) As Variant
                                                          ' Tipos de percepción
  m_Host.MenuABMClick "CSGeneral2.cPercepcionTipo", Me, LNGGetText(1262, vbNullString), 0, csETablasGeneral.csPercepcionTipo
End Function

' Funciones Privadas
Private Function LoadCollection() As Boolean
 
  m_ObjAbm.Title2 = m_Nombre
  
  With m_ObjAbm.Properties
  
    .Clear
  
    With .Add(Nothing, cscPerctNombre)
      .PropertyType = cspText
      .Name = C_strNombre
      .Size = 100
      .Key = K_NOMBRE
      .Value = m_Nombre
    End With
    
    With .Add(Nothing, cscPerctCodigo)
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
    
    With .Add(Nothing, cscPerctGeneraSicore)
      .PropertyType = cspCheck
      .TopFromProperty = cscActivo
      .Left = 3500
      .Name = LNGGetText(1266, vbNullString) 'Genera Sicore
      .Key = K_GENERASICORE
      .Value = CInt(m_GeneraSicore)
    End With
    
    With .Add(Nothing, cscPerctCodigoSicore)
      .PropertyType = cspText
      .TopFromProperty = cscPerctNombre
      .Left = 5500
      .Name = LNGGetText(1265, vbNullString) 'Código Sicore
      .Size = 50
      .Key = K_CODIGOSICORE
      .Value = m_CodigoSicore
    End With
    
    With .Add(Nothing, cscCueId)
      .PropertyType = cspHelp
      .Table = csCuenta
      .Name = LNGGetText(1267, vbNullString) 'Cuenta
      .Key = K_CUE_ID
      .Value = m_Cuenta
      .HelpId = m_Cue_id
    End With
      
    With .Add(Nothing, cscPerctDescrip)
      .PropertyType = cspText
      .LeftFromProperty = cscPerctCodigo
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

  sqlstmt = "select pt.*,cue_nombre" & _
            " from PercepcionTipo pt inner join Cuenta c on pt.cue_id = c.cue_id " & _
            " where perct_id =" & Id

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.fields, cscPerctId)
    m_Nombre = gDB.ValField(rs.fields, cscPerctNombre)
    m_Codigo = gDB.ValField(rs.fields, cscPerctCodigo)
    m_descrip = gDB.ValField(rs.fields, cscPerctDescrip)
    m_GeneraSicore = gDB.ValField(rs.fields, cscPerctGeneraSicore)
    m_CodigoSicore = gDB.ValField(rs.fields, cscPerctCodigoSicore)
    m_Cue_id = gDB.ValField(rs.fields, cscCueId)
    m_Cuenta = gDB.ValField(rs.fields, cscCueNombre)
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

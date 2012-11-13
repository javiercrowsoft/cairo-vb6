VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cChequera"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGeneric
Implements CSInterfacesABM.cIABMClient
Implements CSMenu.cIMenuClient
'--------------------------------------------------------------------------------
' cChequeraEdit
' 04-12-2004
'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones
'--------------------------------------------------------------------------------
' constantes
Private Const C_Module = "cChequeraEdit"

Private Const K_CODIGO          As Integer = 2
Private Const K_ACTIVO          As Integer = 3
Private Const K_CUE_ID          As Integer = 4
Private Const K_DESCRIP         As Integer = 6
Private Const K_NUMERODESDE     As Integer = 7
Private Const K_NUMEROHASTA     As Integer = 8
Private Const K_ULTIMONUMERO    As Integer = 9
Private Const K_DEFAULT         As Integer = 10
' estructuras
' Seudo - Variables
Private c_ErrorSave             As String

' variables privadas
Private m_Id                           As Long
Private m_cue_id                       As Long
Private m_Cuenta                       As String
Private m_Codigo                       As String
Private m_Descrip                      As String
Private m_Numerodesde                  As Long
Private m_Numerohasta                  As Long
Private m_Ultimonumero                 As Long
Private m_Default                      As Boolean
Private m_Activo                       As Boolean

Private m_Editing                      As Boolean

Private m_ObjAbm                       As cIABMGeneric
Private m_ObjTree                      As Object

Private m_IsNew                        As Boolean

Private m_BranchId                     As Long
Private m_TreeId                       As Long
Private m_Host                         As CSMenu.cIMenuHost
Private m_Copy                         As Boolean
' Properties publicas

Public Property Get ID() As Long
  ID = m_Id
End Property

Public Property Get Nombre() As String
  Nombre = m_Codigo
End Property

Public Property Get Codigo() As String
  Codigo = m_Codigo
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

Private Function cIABMClient_ShowDocDigital() As Boolean
  On Error GoTo ControlError
  
  If m_Id = csNO_ID Then Exit Function
  
  Dim Doc As cDocDigital
  Set Doc = New cDocDigital

  Doc.ClientTable = csTChequera
  Doc.ClientTableID = m_Id

  cIABMClient_ShowDocDigital = Doc.ShowDocs(gDB)

  GoTo ExitProc
ControlError:
  MngError Err, C_ShowDocDigital, C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIABMClient_MessageEx(ByVal MessageID As Long, ByVal Info As Variant) As Variant
  cIABMClient_MessageEx = True
End Function

Private Function cIABMClient_Copy() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True
  
  With m_ObjAbm.Properties(cscChqCodigo)
    .Value = C_C & .Value
  End With
  
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscChqCodigo)
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

Private Function cIABMClient_PropertyChange(ByVal Key As Integer) As Boolean

End Function

Private Function cIEditGeneric_Edit(ID As Long, Optional ByVal InModalWindow As Boolean) As Boolean
On Error GoTo ControlError
  
  If ID = csNO_ID Then
    m_IsNew = True
    If Not SecurityCanAccess(csPreGNewChequera) Then Exit Function
  Else
    m_IsNew = False
    If Not SecurityCanAccess(csPreGEditChequera) Then Exit Function
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
  MngError Err, C_EditGenericEdit, C_Module, vbNullString
End Function

Private Function cIMenuClient_Initialize(F As Object, Host As CSMenu.cIMenuHost) As Boolean
  On Error GoTo ControlError

  Set m_Host = Host
  
  m_Host.Server.AddMenu C_MenuTesoreria, csMenuConfigTesoreria, C_MenuConfig, 0, True, False, False, False, True, Nothing
  m_Host.Server.AddMenu LNGGetText(3109, vbNullString), csPreGListChequera, C_MenuTesoreria, 0, True, False, False, False, False, Me
                        '&Chequeras
  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, C_MenuClientInit, C_Module, vbNullString
  If Err.Number Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function



Private Function cIABMClient_Save() As Boolean
  Dim register As cRegister
  Dim fields   As cFields
  Dim CueId    As Long
  Dim bDefault As Boolean
  
  Set register = New cRegister
  With register
    Set fields = .fields
    .fieldId = cscChqId
    .Table = csTChequera
    .ID = m_Id
    
    If m_Copy Then
        .ID = csNew
      Else
        .ID = m_Id
    End If
  End With
  
  Dim IProperty As cIABMProperty
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_CUE_ID
          CueId = .HelpId
          fields.Add2 cscCueId, CueId, csId
        Case K_CODIGO
          fields.Add2 cscChqCodigo, .Value, csText
        Case K_DESCRIP
          fields.Add2 cscChqDescrip, .Value, csText
        Case K_NUMERODESDE
          fields.Add2 cscChqNumerodesde, .Value, csLong
        Case K_NUMEROHASTA
          fields.Add2 cscChqNumerohasta, .Value, csLong
        Case K_ULTIMONUMERO
          fields.Add2 cscChqUltimonumero, .Value, csLong
        Case K_DEFAULT
          bDefault = Val(.Value)
          fields.Add2 cscChqDefault, CInt(bDefault), csBoolean
      End Select
    End With
  Next
  
  fields.HaveLastUpdate = True
  fields.HaveWhoModify = True
  
  If Not register.BeginTrans(gDB) Then Exit Function
  
  If Not gDB.Save(register, , C_ABMClientSave, C_Module, c_ErrorSave) Then Exit Function
  If Not pSaveDefault(bDefault, register.ID, CueId) Then Exit Function
  
  If Not register.CommitTrans() Then Exit Function
  
  m_Copy = False
  cIABMClient_Save = Load(register.ID)
End Function

Private Function pSaveDefault(ByVal bDefault As Boolean, ByVal ID As Long, ByVal CueId As Long) As Boolean
  Dim sqlstmt As String
  
  If bDefault Then
    sqlstmt = "update Chequera set chq_default = 0 where chq_id <> " & ID & " and cue_id = " & CueId
    If Not gDB.Execute(sqlstmt) Then Exit Function
  End If
  
  pSaveDefault = True
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
    cIABMClient_Title = LNGGetText(3110, vbNullString) 'Chequeras
End Property

Private Function cIABMClient_Validate() As Boolean

  Dim IProperty As cIABMProperty

  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_CODIGO
          If ValEmpty(.Value, csText) Then
            MsgInfo C_DebeIndicarCodigo
            Exit Function
          End If
        Case K_NUMERODESDE
          If ValEmpty(.Value, csLong) Then
            MsgInfo LNGGetText(3111, vbNullString)   'Debe indicar un número Desde
            Exit Function
          End If
        Case K_NUMEROHASTA
          If ValEmpty(.Value, csLong) Then
            MsgInfo LNGGetText(3112, vbNullString)   'Debe indicar un número Hasta
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
    cIEditGeneric_ShowList = SecurityCanAccess(csPreGListChequera)
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
    If Not SecurityCanAccess(csPreGDeleteChequera) Then Exit Function

    Dim sqlstmt As String
    
    sqlstmt = "Delete Chequera where chq_id = " & ID
    
    cIEditGeneric_Delete = gDB.Execute(sqlstmt, C_EditGenericDelete, C_Module)
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

' funciones privadas
Private Function LoadCollection() As Boolean
  m_ObjAbm.Title2 = m_Codigo
  
  With m_ObjAbm.Properties
    
    .Clear
    
    With .Add(Nothing, cscChqCodigo)
      .PropertyType = cspText
      .Name = C_strCodigo
      .Size = 100
      .Key = K_CODIGO
      .Value = m_Codigo
    End With
      
    With .Add(Nothing, cscCueId)
      .PropertyType = cspHelp
      .Table = csCuenta
      .Name = LNGGetText(1267, vbNullString) 'Cuenta
      .Key = K_CUE_ID
      .Value = m_Cuenta
      .HelpId = m_cue_id
      .HelpFilter = pGetCuentaFilter()
    End With
      
    With .Add(Nothing, cscChqDescrip)
      .PropertyType = cspText
      .Name = C_strDescrip
      .Size = 255
      .Width = 6500
      .Height = 660
      .SubType = cspMemo
      .Key = K_DESCRIP
      .Value = m_Descrip
    End With
      
    With .Add(Nothing, cscChqNumerodesde)
      .PropertyType = cspNumeric
      .Name = LNGGetText(3113, vbNullString) 'Número Desde
      .Key = K_NUMERODESDE
      .Value = m_Numerodesde
      .SubType = cspInteger
    End With
      
    With .Add(Nothing, cscChqNumerohasta)
      .PropertyType = cspNumeric
      .Name = LNGGetText(3114, vbNullString) 'Número hasta
      .Key = K_NUMEROHASTA
      .Value = m_Numerohasta
      .SubType = cspInteger
    End With
      
    With .Add(Nothing, cscChqUltimonumero)
      .PropertyType = cspNumeric
      .Name = LNGGetText(3115, vbNullString) 'Ultimo cheque emitido
      .Key = K_ULTIMONUMERO
      .Value = m_Ultimonumero
      .SubType = cspInteger
    End With
      
    With .Add(Nothing, cscChqDefault)
      .PropertyType = cspCheck
      .Name = LNGGetText(3116, vbNullString) 'Chequera sugerida
      .Key = K_DEFAULT
      .Value = m_Default
    End With
  End With
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

Private Function pGetCuentaFilter() As String
  pGetCuentaFilter = cscCuecId & "=" & csECuecBancos & " and emp_id is not null"
End Function

Private Function Load(ByVal ID As Long) As Boolean

  Dim sqlstmt As String
  Dim rs      As Recordset
  'TODO: SQL
  sqlstmt = "SELECT Chequera.*,cue_nombre FROM Chequera, Cuenta" & vbCrLf
  sqlstmt = sqlstmt & "Where chq_id = " & ID & " and chequera.cue_id = cuenta.cue_id"

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.fields, cscChqId)
    m_cue_id = gDB.ValField(rs.fields, cscCueId)
    m_Codigo = gDB.ValField(rs.fields, cscChqCodigo)
    m_Descrip = gDB.ValField(rs.fields, cscChqDescrip)
    m_Numerodesde = gDB.ValField(rs.fields, cscChqNumerodesde)
    m_Numerohasta = gDB.ValField(rs.fields, cscChqNumerohasta)
    m_Ultimonumero = gDB.ValField(rs.fields, cscChqUltimonumero)
    m_Default = gDB.ValField(rs.fields, cscChqDefault)
    m_Cuenta = gDB.ValField(rs.fields, cscCueNombre)

  Else
    m_Id = csNO_ID
    m_cue_id = csNO_ID
    m_Codigo = vbNullString
    m_Descrip = vbNullString
    m_Numerodesde = 0
    m_Numerohasta = 0
    m_Ultimonumero = 0
    m_Default = 0
    m_Cuenta = vbNullString

  End If

  Load = True
End Function

Private Function cIMenuClient_ProcessMenu(ByVal ID As Long) As Variant
  m_Host.MenuABMClick "CSTesoreriaConfig.cChequera", Me, LNGGetText(3110, vbNullString), 0, csETablasGeneral.csChequera
                                                          'Chequeras
End Function

Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  c_ErrorSave = LNGGetText(3117, vbNullString) 'Error al grabar la Chequera
  
  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

' construccion - destruccion
Private Sub Class_Terminate()
  On Error Resume Next
   Set m_ObjAbm = Nothing
   Set m_ObjTree = Nothing
End Sub

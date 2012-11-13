VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cAlsa"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGeneric
Implements CSInterfacesABM.cIABMClient
Implements CSMenu.cIMenuClient
'--------------------------------------------------------------------------------
' cAlsa
' 02-09-03

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cAlsa"

Private Const K_CODIGO                         As Integer = 1
Private Const K_DESCRIP                        As Integer = 2
Private Const K_TIPOMADERA                     As Integer = 3
Private Const K_TIPOCAMARA                     As Integer = 4
Private Const K_TIPOALSA                       As Integer = 5
Private Const K_COLM_ID                        As Integer = 6
Private Const K_ACTIVO                         As Integer = 7

' estructuras
' Seudo - Variables
Private c_ErrorSave                    As String

' variables privadas
Private m_Id                           As Long
Private m_Codigo                       As String
Private m_Descrip                      As String
Private m_TipoMadera                   As Integer
Private m_TipoCamara                   As Integer
Private m_TipoAlsa                     As Integer
Private m_Colm_id                      As Long
Private m_Colmena                      As String
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
Private m_Host As CSMenu.cIMenuHost

Private m_Copy              As Boolean
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

Private Function cIABMClient_Copy() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True
  
  With m_ObjAbm.Properties(cscAlsaCodigo)
    .Value = "C-" & .Value
  End With
  
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscAlsaCodigo)
  
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

  Doc.ClientTable = csTAlsa
  Doc.ClientTableID = m_Id

  cIABMClient_ShowDocDigital = Doc.ShowDocs(gDB)

  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClient_ShowDocDigital", C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIABMClient_MessageEx(ByVal MessageID As Long, ByVal Info As Variant) As Variant
  cIABMClient_MessageEx = True
End Function

Private Function cIABMClient_PropertyChange(ByVal Key As Integer) As Boolean
End Function

Private Function cIABMClient_Save() As Boolean
  Dim register   As cRegister
  Dim fields     As cFields
  
  Set register = New cRegister
  Set fields = register.fields
  
  With register
    .fieldId = cscAlsaId
    .Table = csTAlsa
    
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
        Case K_CODIGO
          fields.Add2 cscAlsaCodigo, .Value, csText
        Case K_DESCRIP
          fields.Add2 cscAlsaDescrip, .Value, csText
        Case K_TIPOMADERA
          fields.Add2 cscAlsaTipoMadera, .ListItemData, csInteger
        Case K_TIPOCAMARA
          fields.Add2 cscAlsaTipoCamara, .ListItemData, csInteger
        Case K_TIPOALSA
          fields.Add2 cscAlsaTipoAlsa, .ListItemData, csInteger
        Case K_ACTIVO
          fields.Add2 cscActivo, .Value, csBoolean
      End Select
    End With
  Next
  
  fields.HaveLastUpdate = True
  fields.HaveWhoModify = True
  
  If Not gDB.Save(register, , "cIABMClient_Save", "cAlsa", c_ErrorSave) Then Exit Function
  
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
    cIABMClient_Title = LNGGetText(2999, vbNullString)  'Alsas
End Property

Private Function cIABMClient_Validate() As Boolean

  Dim IProperty As cIABMProperty

  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_CODIGO
          If ValEmpty(.Value, csText) Then
            MsgInfo LNGGetText(1008, vbNullString)  'Debe indicar un código
            Exit Function
          End If
        Case K_TIPOMADERA
          If ValEmpty(.ListItemData, csInteger) Then
            MsgInfo LNGGetText(3000, vbNullString)  'Debe indicar un tipo de madera
            Exit Function
          End If
        Case K_TIPOCAMARA
          If ValEmpty(.ListItemData, csInteger) Then
            MsgInfo LNGGetText(3001, vbNullString)  'Debe indicar un tipo de cámara
            Exit Function
          End If
        Case K_TIPOALSA
          If ValEmpty(.ListItemData, csInteger) Then
            MsgInfo LNGGetText(3002, vbNullString)  'Debe indicar un tipo de Alsa
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
    If Not SecurityCanAccess(csPreANewAlsa) Then Exit Function
  Else
    m_IsNew = False
    If Not SecurityCanAccess(csPreAEditAlsa) Then Exit Function
  End If
  
  ' JMA I
  m_ObjAbm.InModalWindow = InModalWindow
' JMA F
  
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
  MngError Err, "cIEditGeneric_Edit", "cAlsa", vbNullString
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
    cIEditGeneric_ShowList = SecurityCanAccess(csPreAListAlsa)
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
    If Not SecurityCanAccess(csPreADeleteAlsa) Then Exit Function

    Dim sqlstmt As String
    
    sqlstmt = "Delete Alsa where alsa_id = " & ID
    
    cIEditGeneric_Delete = gDB.Execute(sqlstmt, "cIEditGeneric_Delete", "cAlsa")
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
  Dim str_3003  As String
  
  str_3003 = LNGGetText(3003, vbNullString)  '&Apicultura
  Set m_Host = Host
                                                'Co&nfiguración
  m_Host.Server.AddMenu str_3003, csMenuConfig, LNGGetText(1028, vbNullString), 0, True, False, True, False, True, Nothing
  m_Host.Server.AddMenu LNGGetText(3004, vbNullString), csPreAListAlsa, str_3003, 0, True, False, False, False, False, Me
                        '&Alsa
  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, "cIMenuClient_Initialize", C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal ID As Long) As Variant
  m_Host.MenuABMClick "CSApicultura2.cAlsa", Me, LNGGetText(3005, vbNullString), 0, csETablesApicultura.csAlsa
                                                  'Alsa
End Function


' funciones privadas
Private Function LoadCollection() As Boolean
  
  Dim c As cIABMProperty
  
  With m_ObjAbm.Properties
    
    .Clear
    
    With .Add(Nothing, cscAlsaCodigo)
      .PropertyType = cspText
      .Name = C_strCodigo
      .Size = 10
      .Key = K_CODIGO
      .Value = m_Codigo
    End With
      
    With .Add(Nothing, cscActivo)
      .PropertyType = cspCheck
      .Name = C_strActivo
      .Key = K_ACTIVO
      .Value = CInt(m_Activo)
    End With
      
    With .Add(Nothing, cscColmId)
      .PropertyType = cspText
      .Name = LNGGetText(3006, vbNullString) 'Colmena
      .Enabled = False
      .Key = K_COLM_ID
      .Value = m_Colmena
    End With
      
    With .Add(Nothing, cscAlsaTipoMadera)
      .PropertyType = cspList
        
      With .List.Add(Nothing)
        .ID = csTMAlsaCalden
        .Value = LNGGetText(3007, vbNullString) 'Calden
      End With
      
      With .List.Add(Nothing)
        .ID = csTMAlsaPino
        .Value = LNGGetText(3008, vbNullString) 'Pino
      End With
      
      With .List.Add(Nothing)
        .ID = csTMAlsaSaligna
        .Value = LNGGetText(3009, vbNullString) 'Saligna
      End With
    
      .Name = LNGGetText(3010, vbNullString) 'Tipo de Madera
      .TopFromProperty = cscAlsaCodigo
      .Left = 5800
      .Key = K_TIPOMADERA
      .ListItemData = m_TipoMadera
      .ListWhoSetItem = csListItemData
    End With
      
    With .Add(Nothing, cscAlsaTipoCamara)
      .PropertyType = cspList
        
      With .List.Add(Nothing)
        .ID = csTCAlsaCria
        .Value = LNGGetText(3011, vbNullString) 'Cría
      End With
      
      With .List.Add(Nothing)
        .ID = csTCAlsaMelaria
        .Value = LNGGetText(3012, vbNullString) 'Melaria
      End With
      
      .Name = LNGGetText(3013, vbNullString) 'Tipo de Camara
      .Key = K_TIPOCAMARA
      .ListItemData = m_TipoCamara
      .ListWhoSetItem = csListItemData
    End With
      
    With .Add(Nothing, cscAlsaTipoAlsa)
      .PropertyType = cspList
        
      With .List.Add(Nothing)
        .ID = csTAAlsaMediaAlsa
        .Value = LNGGetText(3014, vbNullString) 'Media Alsa
      End With
      
      With .List.Add(Nothing)
        .ID = csTAAlsaAlsa
        .Value = LNGGetText(3005, vbNullString) 'Alsa
      End With
        
      .Name = LNGGetText(3015, vbNullString) 'Tipo de Alsa
      .Key = K_TIPOALSA
      .ListItemData = m_TipoAlsa
      .ListWhoSetItem = csListItemData
    End With
            
    With .Add(Nothing, cscAlsaDescrip)
      .PropertyType = cspText
      .Name = C_strDescrip
      .Size = 255
      .Height = 880
      .Width = 6500
      .LeftFromProperty = cscAlsaCodigo
      .SubType = cspMemo
      .Key = K_DESCRIP
      .Value = m_Descrip
    End With
  End With
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

Private Function Load(ByVal ID As Long) As Boolean

  Dim sqlstmt As String

  sqlstmt = "select Alsa.*,colm_codigo from Alsa,Colmena " & _
              " where alsa_id = " & ID & _
                " and alsa.colm_id *= colmena.colm_id"

  Dim rs As Recordset

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "Load", "cAlsa") Then Exit Function

  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.fields, cscAlsaId)
    m_Codigo = gDB.ValField(rs.fields, cscAlsaCodigo)
    m_Descrip = gDB.ValField(rs.fields, cscAlsaDescrip)
    m_TipoMadera = gDB.ValField(rs.fields, cscAlsaTipoMadera)
    m_TipoCamara = gDB.ValField(rs.fields, cscAlsaTipoCamara)
    m_TipoAlsa = gDB.ValField(rs.fields, cscAlsaTipoAlsa)
    m_Colm_id = gDB.ValField(rs.fields, cscColmId)
    m_Colmena = gDB.ValField(rs.fields, cscColmCodigo)
    m_Creado = gDB.ValField(rs.fields, cscCreado)
    m_Modificado = gDB.ValField(rs.fields, cscModificado)
    m_Modifico = gDB.ValField(rs.fields, cscModifico)
    m_Activo = gDB.ValField(rs.fields, cscActivo)

  Else
    m_Id = csNO_ID
    m_Codigo = vbNullString
    m_Descrip = vbNullString
    m_TipoMadera = 0
    m_TipoCamara = 0
    m_TipoAlsa = 0
    m_Colm_id = csNO_ID
    m_Colmena = vbNullString
    m_Creado = csNoDate
    m_Modificado = csNoDate
    m_Modifico = 0
    m_Activo = False

  End If

  Load = True
End Function
' construccion - destruccion

Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  c_ErrorSave = LNGGetText(3016, vbNullString) 'Error al grabar Alsa
  
  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
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



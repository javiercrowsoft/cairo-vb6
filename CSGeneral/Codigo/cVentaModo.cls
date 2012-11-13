VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cVentaModo"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGeneric
Implements CSInterfacesABM.cIABMClient
Implements CSMenu.cIMenuClient
'--------------------------------------------------------------------------------
' cVentaModo
' 23-06-10

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cVentaModo"

Private Const K_NOMBRE      As Integer = 1
Private Const K_CODIGO      As Integer = 2
Private Const K_ACTIVO      As Integer = 3
Private Const K_DESCRIP     As Integer = 4
Private Const K_CTACTE      As Integer = 5
Private Const K_CUE_ID      As Integer = 6
Private Const K_OS          As Integer = 7
Private Const K_PV          As Integer = 8
Private Const K_CMVXI       As Integer = 9
Private Const K_COBZ        As Integer = 10

' estructuras
' variables privadas
Private m_Id                As Long
Private m_Nombre            As String
Private m_Codigo            As String
Private m_Activo            As Boolean
Private m_descrip           As String
Private m_Cue_id            As Long
Private m_Cuenta            As String
Private m_ctacte            As csE_VentaModoCtaCte
Private m_pv                As Boolean
Private m_os                As Boolean
Private m_cmvxi             As Boolean
Private m_cobz              As Boolean

Private m_Editing           As Boolean

Private m_ObjAbm            As cIABMGeneric
Private m_ObjTree           As Object

Private m_IsNew             As Boolean

Private m_BranchId          As Long
Private m_TreeId            As Long

Private m_Host              As CSMenu.cIMenuHost
Private m_Copy              As Boolean

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
Private Function cIABMClient_Copy() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True
  
  With m_ObjAbm.Properties(cscVmCodigo)
    .Value = C_C & .Value
  End With
  
'  With m_ObjAbm.Properties(cscvmNombre)
'    .Value = C_CopiaDe & .Value
'  End With
  
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscVmCodigo)
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscVmNombre)
  
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

  Doc.ClientTable = csTVentaModo
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
  Select Case MessageID
  
    Case MSG_DOC_INFO
    
      Dim AbmGen As cABMGeneric
      Set AbmGen = m_ObjAbm
      
      CSKernelClient2.ShowHelp AbmGen.hWnd, _
                               vbNullString, _
                               vbNullString, _
                               csPreGNewVentaModo
      cIABMClient_MessageEx = MSG_DOC_INFO_HANDLED
    Case Else
      cIABMClient_MessageEx = True
  End Select
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
    Dim register   As cRegister
    Dim fields     As cFields
    
    Set register = New cRegister
    Set fields = register.fields
    
    With register
      .fieldId = cscVmId
      .Table = csTVentaModo
      
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
                    fields.Add2 cscVmNombre, .Value, csText
                Case K_CODIGO
                    fields.Add2 cscVmCodigo, .Value, csText
                Case K_ACTIVO
                    fields.Add2 cscActivo, Val(.Value), csBoolean
                Case K_DESCRIP
                    fields.Add2 cscVmDescrip, .Value, csText
                Case K_CTACTE
                    fields.Add2 cscVmCtaCte, .ListItemData, csInteger
                Case K_CUE_ID
                    fields.Add2 cscCueId, .HelpId, csId
                Case K_OS
                    fields.Add2 cscVmOs, Val(.Value), csBoolean
                Case K_PV
                    fields.Add2 cscVmPv, Val(.Value), csBoolean
                Case K_COBZ
                    fields.Add2 cscVmCobz, Val(.Value), csBoolean
                Case K_CMVXI
                    fields.Add2 cscVmCmvxi, Val(.Value), csBoolean
            End Select
        End With
    Next
    
    fields.HaveLastUpdate = True
    fields.HaveWhoModify = True
    
    'Error al grabar modos de venta
    If Not gDB.SaveEx(register, , _
                      cscVmCodigo, _
                      C_ABMClientSave, _
                      C_Module, _
                      LNGGetText(5075, vbNullString)) Then Exit Function
    
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
    cIABMClient_Title = LNGGetText(5078, vbNullString)  'Modos de Venta
End Property

Private Function cIABMClient_Validate() As Boolean
  Dim IProperty As cIABMProperty
  
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
        Case K_ACTIVO
      End Select
    End With
  Next
  
  cIABMClient_Validate = True
End Function

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
    cIEditGeneric_ShowList = SecurityCanAccess(csPreGListVentaModo)
End Function

' Implementacion de cIEditGeneric
Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
    Set m_ObjAbm = rhs
End Property

Private Property Get cIEditGeneric_Editing() As Boolean
    cIEditGeneric_Editing = m_Editing
End Property

Private Function cIEditGeneric_Delete(Id As Long) As Boolean
    If Not SecurityCanAccess(csPreGDeleteVentaModo) Then Exit Function
    
    Dim sqlstmt As String
    
    sqlstmt = "delete VentaModo where vm_id = " & Id
    
    cIEditGeneric_Delete = gDB.Execute(sqlstmt, C_EditGenericDelete, C_Module)
End Function

Private Function cIEditGeneric_Search(Id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Id = csNO_ID Then
    m_IsNew = True
    If Not SecurityCanAccess(csPreGNewVentaModo) Then Exit Function
  Else
    m_IsNew = False
    If Not SecurityCanAccess(csPreGEditVentaModo) Then Exit Function
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

  Set m_Host = Host
  
  m_Host.Server.AddMenu C_MenuVentas, csMenuConfigVentas, C_MenuConfig, 0, True, False, False, False, True, Nothing
                            '&Modos de Venta
  m_Host.Server.AddMenu LNGGetText(5076, vbNullString), csPreGListVentaModo, C_MenuVentas, 0, True, False, False, False, False, Me

  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, C_MenuClientInit, C_Module, vbNullString
  If Err.Number Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal Id As Long) As Variant
                                                  'Modos de Venta
  m_Host.MenuABMClick "CSGeneral2.cVentaModo", Me, LNGGetText(5078, vbNullString), 0, csETablasGeneral.csVentaModo
End Function

' funciones privadas
Private Function LoadCollection() As Boolean
    
  Dim AbmGen As cABMGeneric
  Set AbmGen = m_ObjAbm
    
  m_ObjAbm.Title2 = m_Nombre
  
  AbmGen.MinHeight = 6800
  
  With m_ObjAbm.Properties
    .Clear
    
    With .Add(Nothing, cscVmNombre)
      .PropertyType = cspText
      .Name = C_strNombre
      .Size = 100
      .Key = K_NOMBRE
      .Value = m_Nombre
      .Width = 6500
    End With
        
    With .Add(Nothing, cscVmCodigo)
      .PropertyType = cspText
      .Name = C_strCodigo
      .Size = 15
      .Value = m_Codigo
      .Key = K_CODIGO
    End With
    
    With .Add(Nothing, cscActivo)
      .PropertyType = cspCheck
      .Name = C_strActivo
      .Key = K_ACTIVO
      .Value = CInt(m_Activo)
    End With
        
    With .Add(Nothing, cscVmCtaCte)
      .PropertyType = cspList
      .Name = LNGGetText(5104, vbNullString) 'Tipo de Cobranza
      .Size = 15
      .ListItemData = m_ctacte
      .ListWhoSetItem = csListItemData
      With .List
        With .Add(Nothing)
          .Id = csE_VentaModoCtaCte.csVM_CtaCteHojaRuta
          .Value = LNGGetText(5106, vbNullString) 'Hoja de Ruta
        End With
        With .Add(Nothing)
          .Id = csE_VentaModoCtaCte.csVM_CtaCteMostrador
          .Value = LNGGetText(5107, vbNullString) 'Cobranza por Mostrador
        End With
        With .Add(Nothing)
          .Id = csE_VentaModoCtaCte.csVM_CtaCteMostradoFactura
          .Value = LNGGetText(5108, vbNullString) 'Cobranza por Facturador
        End With
      End With
      .Key = K_CTACTE
      .Width = 3000
      .LeftNotChange = True
      .Left = 5000
      .LeftLabel = -1800
      .TopFromProperty = cscActivo
    End With
        
    With .Add(Nothing)
      .PropertyType = cspLabel
      .Height = 20
      .BackColor = &HCECECE
      .Left = 200
      .Width = 8000
      .LeftNotChange = True
      .TopToPrevious = 420
      .TopNotChange = True
    End With
        
    With .Add(Nothing)
      .PropertyType = cspLabel
      .Value = LNGGetText(5081, vbNullString) 'Se utiliza en:
      .Height = 285
      .FontBold = True
      .Left = 360
      .LeftNotChange = True
      .TopToPrevious = 160
    End With
        
    With .Add(Nothing, cscVmPv)
      .PropertyType = cspCheck
      .Name = LNGGetText(5082, vbNullString) 'Pedidos de Venta
      .Size = 15
      .Value = CInt(m_pv)
      .Key = K_PV
      .Width = 1000
      .LeftNotChange = True
      .Left = 3000
      .LeftLabel = -1800
      .TopFromProperty = cscActivo
      .TopToPrevious = 880
    End With
        
    With .Add(Nothing, cscVmOs)
      .PropertyType = cspCheck
      .Name = LNGGetText(5083, vbNullString) 'Ordenes de Servicio
      .Size = 15
      .Value = CInt(m_os)
      .Key = K_OS
      .Width = 1000
      .LeftNotChange = True
      .Left = 7000
      .LeftLabel = -1800
      .TopFromProperty = cscActivo
      .TopToPrevious = 880
    End With
        
    With .Add(Nothing, cscVmCobz)
      .PropertyType = cspCheck
      .Name = LNGGetText(2128, vbNullString) 'Cobranzas
      .Size = 15
      .Value = CInt(m_cobz)
      .Key = K_COBZ
      .Width = 1000
      .LeftNotChange = True
      .Left = 3000
      .LeftLabel = -1800
      .TopFromProperty = cscActivo
      .TopToPrevious = 1280
    End With
        
    With .Add(Nothing, cscVmCmvxi)
      .PropertyType = cspCheck
      .Name = LNGGetText(5105, vbNullString) 'Cobro por Internet
      .Size = 15
      .Value = CInt(m_cmvxi)
      .Key = K_CMVXI
      .Width = 1000
      .LeftNotChange = True
      .Left = 7000
      .LeftLabel = -1800
      .TopFromProperty = cscActivo
      .TopToPrevious = 1280
    End With
        
    With .Add(Nothing)
      .PropertyType = cspLabel
      .Height = 20
      .BackColor = &HCECECE
      .Left = 200
      .Width = 8000
      .LeftNotChange = True
      .TopToPrevious = 590
      .TopNotChange = True
    End With
        
    With .Add(Nothing, cscCueId)
      .PropertyType = cspHelp
      .Table = csCuenta
      .HelpFilter = "cuec_id = " & csECuecCaja
      .Name = LNGGetText(1267, vbNullString) 'Cuenta
      .Size = 15
      .Value = m_Cuenta
      .HelpId = m_Cue_id
      .Key = K_CUE_ID
      .Width = 6500
      .TopToPrevious = 520
    End With
        
    With .Add(Nothing, cscVmDescrip)
      .PropertyType = cspText
      .Name = C_strDescrip
      .Size = 255
      .Height = 660
      .Width = 6500
      .SubType = cspMemo
      .Value = m_descrip
      .Key = K_DESCRIP
    End With
  
  End With
      
  If Not m_ObjAbm.Show(Me) Then Exit Function

  LoadCollection = True
End Function

Private Function Load(ByVal Id As Long) As Boolean
    
    Dim sqlstmt As String
    Dim rs      As ADODB.Recordset
    
    sqlstmt = "select v.*,cue_nombre " & _
              " from VentaModo v left join Cuenta cue on v.cue_id = cue.cue_id " & _
              " where v.vm_id = " & Id
    
    If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function
    
    If rs.EOF Then
        m_Activo = True
        m_Nombre = vbNullString
        m_Codigo = vbNullString
        m_descrip = vbNullString
        m_Id = csNO_ID
        m_Cue_id = csNO_ID
        m_Cuenta = vbNullString
        m_ctacte = csE_VentaModoCtaCte.csVM_CtaCteMostradoFactura
        m_pv = 0
        m_os = 0
        m_cmvxi = 0
        m_cobz = 0
    Else
        m_Activo = gDB.ValField(rs.fields, cscActivo)
        m_Nombre = gDB.ValField(rs.fields, cscVmNombre)
        m_Codigo = gDB.ValField(rs.fields, cscVmCodigo)
        m_descrip = gDB.ValField(rs.fields, cscVmDescrip)
        m_Id = gDB.ValField(rs.fields, cscVmId)
        m_ctacte = gDB.ValField(rs.fields, cscVmCtaCte)
        m_pv = gDB.ValField(rs.fields, cscVmPv)
        m_os = gDB.ValField(rs.fields, cscVmOs)
        m_cmvxi = gDB.ValField(rs.fields, cscVmCmvxi)
        m_cobz = gDB.ValField(rs.fields, cscVmCobz)
        m_Cuenta = gDB.ValField(rs.fields, cscCueNombre)
        m_Cue_id = gDB.ValField(rs.fields, cscCueId)
    End If
    Load = True
End Function

' construccion - destruccion
Private Sub Class_Terminate()
  On Error Resume Next
  Set m_ObjAbm = Nothing
  Set m_ObjTree = Nothing
End Sub




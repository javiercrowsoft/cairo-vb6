VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cComunidadInternet"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGeneric
Implements CSInterfacesABM.cIABMClient
Implements csMenu.cIMenuClient
'--------------------------------------------------------------------------------
' cComunidadInternet
' 16-11-09

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cComunidadInternet"

Private Const csDocumento = 4001

Private Const K_NOMBRE                         As Integer = 1
Private Const K_CODIGO                         As Integer = 2
Private Const K_DESCRIP                        As Integer = 4
Private Const K_PR_ID                          As Integer = 10
Private Const K_DOC_PEDIDO                     As Integer = 11
Private Const K_SUC_ID                         As Integer = 12
Private Const K_ACTIVO                         As Integer = 13
Private Const K_LP_ID                          As Integer = 14
Private Const K_LD_ID                          As Integer = 15
Private Const K_DEPL_ID                        As Integer = 16

' estructuras
' Seudo - Variables
Private c_ErrorSave                    As String

' variables privadas
Private m_Id                           As Long
Private m_Nombre                       As String
Private m_Codigo                       As String
Private m_Descrip                      As String
Private m_Pr_id                        As Long
Private m_Producto                     As String

Private m_Lp_id                        As Long
Private m_ListaPrecio                  As String

Private m_Ld_id                        As Long
Private m_ListaDescuento               As String

Private m_depl_id                      As Long
Private m_deposito                     As String

Private m_doc_id                       As Long
Private m_Documento                    As String
Private m_suc_id                       As Long
Private m_Sucursal                     As String
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

Private m_Host As csMenu.cIMenuHost

Private m_WasChanged        As Boolean

' Properties publicas

Public Property Get id() As Long
  id = m_Id
End Property

Public Property Get Nombre() As String
  Nombre = m_Nombre
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

  Doc.ClientTable = csTComunidadInternet
  Doc.ClientTableID = m_Id

  cIABMClient_ShowDocDigital = Doc.ShowDocs(gDB)

  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClient_ShowDocDigital", C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc
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
  
  With m_ObjAbm.Properties(cscCmiCodigo)
    .Value = C_C & .Value
  End With
  
  With m_ObjAbm.Properties(cscCmiNombre)
    .Value = C_CopiaDe & .Value
  End With
  
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscCmiCodigo)
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscCmiNombre)
  
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
  Dim fields   As cFields
  Dim LastId   As Long
  
  Set register = New cRegister
  
  With register
    Set fields = .fields
    .fieldId = cscCmiId
    .Table = csTComunidadInternet
  
    If m_Copy Then
      .id = csNew
    Else
      .id = m_Id
    End If
  End With
  
  Dim IProperty As cIABMProperty
  
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_NOMBRE
          register.fields.Add2 cscCmiNombre, .Value, csText
        Case K_CODIGO
          register.fields.Add2 cscCmiCodigo, .Value, csText
        Case K_DESCRIP
          register.fields.Add2 cscCmiDescrip, .Value, csText
        Case K_PR_ID
          register.fields.Add2 cscPrId, .HelpId, csId
        Case K_LP_ID
          register.fields.Add2 cscLpId, .HelpId, csId
        Case K_LD_ID
          register.fields.Add2 cscLdId, .HelpId, csId
        Case K_DOC_PEDIDO
          register.fields.Add2 cscDocId, .HelpId, csId
        Case K_SUC_ID
          register.fields.Add2 cscSucId, .HelpId, csId
        Case K_ACTIVO
          register.fields.Add2 cscActivo, .Value, csBoolean
        Case K_DEPL_ID
          register.fields.Add2 cscDeplId, .HelpId, csId
      End Select
    End With
  Next
  
  fields.HaveLastUpdate = True
  fields.HaveWhoModify = True
    
  If Not gDB.SaveEx(register, , _
                    cscCmiCodigo, _
                    C_ABMClientSave, _
                    C_Module, _
                    c_ErrorSave) Then Exit Function
  
  m_Copy = False
  
  cIABMClient_Save = Load(register.id)

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
    cIABMClient_Title = LNGGetText(5029, vbNullString)
                        ' Comunidad de Internet
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
        Case K_PR_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(5033, vbNullString) 'Debe indicar un producto de venta
            Exit Function
          End If
        Case K_DOC_PEDIDO
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(5034, vbNullString) 'Debe indicar un documento de pedido de venta
            Exit Function
          End If
        Case K_SUC_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(1560, vbNullString) 'Debe indicar una sucursal
            Exit Function
          End If
        Case K_DEPL_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(1559, vbNullString) 'Debe indicar un deposito lógico
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
    cIEditGeneric_ShowList = SecurityCanAccess(csPreCVXIListComunidad)
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

Private Function cIEditGeneric_Delete(id As Long) As Boolean
    If Not SecurityCanAccess(csPreCVXIDeleteComunidad) Then Exit Function

    Dim sqlstmt As String
    
    sqlstmt = "delete ComunidadInternet where cmi_id = " & id
    
    cIEditGeneric_Delete = gDB.Execute(sqlstmt, "cIEditGeneric_Delete", C_Module)
End Function

Private Function cIEditGeneric_Search(id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If id = csNO_ID Then
      m_IsNew = True
      If Not SecurityCanAccess(csPreCVXINewComunidad) Then Exit Function
  Else
      m_IsNew = False
      If Not SecurityCanAccess(csPreCVXIEditComunidad) Then Exit Function
  End If

  m_ObjAbm.InModalWindow = InModalWindow

  If Not Load(id) Then Exit Function
  
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

Private Function cIEditGeneric_PrintObj(ByVal id As Long) As Boolean

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

Private Function cIEditGeneric_Preview(ByVal id As Long) As Boolean

End Function

Private Function cIEditGeneric_PropertyChange(ByVal Key As Integer) As Boolean

End Function


Private Function cIMenuClient_Initialize(f As Object, Host As csMenu.cIMenuHost) As Boolean
  On Error GoTo ControlError

  Dim str_4999 As String

  str_4999 = LNGGetText(4999, vbNullString)

  Set m_Host = Host
  m_Host.Server.AddMenu str_4999, csMenuConfig, C_MenuConfig, 0, True, False, True, False, True, Nothing
  m_Host.Server.AddMenu LNGGetText(5030, vbNullString), csPreCVXIListComunidad, str_4999, 0, True, False, False, False, False, Me
                        '&Comunidad de Internet

  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, "cIMenuClient_Initialize", C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal id As Long) As Variant
  m_Host.MenuABMClick "CSCVXI.cComunidadInternet", Me, LNGGetText(5031, vbNullString), 0, csETablesCVXI.csComunidadInternet
                                                       ' Comunidades de Internet
End Function

' funciones privadas

Private Function LoadCollection() As Boolean
  Dim abmgen As cABMGeneric
  Set abmgen = m_ObjAbm
  abmgen.MinHeight = 7000
  
  With m_ObjAbm.Properties
    
    .Clear

    With .Add(Nothing, cscCmiNombre)
      .PropertyType = cspText
      .Name = C_strNombre
      .Size = 100
      .Key = K_NOMBRE
      .Value = m_Nombre
      .Width = 6500
    End With
  
    With .Add(Nothing, cscCmiCodigo)
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
      .TopFromProperty = cscCmiCodigo
      .Left = 5300
      .LeftNotChange = True
      .LeftLabel = -800
    End With
            
    With .Add(Nothing, cscPrId)
      .PropertyType = cspHelp
      .Table = csProductoVenta
      .Name = LNGGetText(1619, vbNullString) ' Producto
      .Key = K_PR_ID
      .Value = m_Producto
      .HelpId = m_Pr_id
      .Width = 4000
    End With
            
    With .Add(Nothing, cscDocId)
      .PropertyType = cspHelp
      .Table = csDocumento
      .Name = LNGGetText(1567, vbNullString) ' Documento
      .Key = K_DOC_PEDIDO
      .Value = m_Documento
      .HelpId = m_doc_id
      .HelpFilter = "doct_id = 5"
      .Width = 4000
    End With
            
    With .Add(Nothing, cscSucId)
      .PropertyType = cspHelp
      .Table = csSucursal
      .Name = LNGGetText(1281, vbNullString) ' Sucursal
      .Key = K_SUC_ID
      .Value = m_Sucursal
      .HelpId = m_suc_id
      .Width = 4000
    End With
            
    With .Add(Nothing, cscLpId)
      .PropertyType = cspHelp
      .Table = csListaPrecio
      .Name = LNGGetText(1397, vbNullString) ' Lista Precio
      .Key = K_LP_ID
      .Value = m_ListaPrecio
      .HelpId = m_Lp_id
      .Width = 4000
    End With
            
    With .Add(Nothing, cscLdId)
      .PropertyType = cspHelp
      .Table = csListaDescuento
      .Name = LNGGetText(1398, vbNullString) ' Lista Descuento
      .Key = K_LD_ID
      .Value = m_ListaDescuento
      .HelpId = m_Ld_id
      .Width = 4000
    End With
            
    With .Add(Nothing, cscDeplId)
      .PropertyType = cspHelp
      .Table = csDepositoLogico
      .Name = LNGGetText(1574, vbNullString) ' Deposito
      .Key = K_DEPL_ID
      .Value = m_deposito
      .HelpId = m_depl_id
      .Width = 4000
    End With
            
    With .Add(Nothing, cscCmiDescrip)
      .PropertyType = cspText
      .SubType = cspMemo
      .Name = C_strDescrip
      .Size = 255
      .Width = 6500
      .Height = 880
      .Key = K_DESCRIP
      .Value = m_Descrip
      .LeftFromProperty = cscCmiNombre
    End With
                                    
  End With
    
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

Private Function Load(ByVal id As Long) As Boolean
  Dim sqlstmt As String
  Dim rs As Recordset
  
  sqlstmt = "sp_ComunidadInternetGet " & id

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "Load", C_Module) Then Exit Function

  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.fields, cscCmiId)
    m_Nombre = gDB.ValField(rs.fields, cscCmiNombre)
    m_Codigo = gDB.ValField(rs.fields, cscCmiCodigo)
    m_Descrip = gDB.ValField(rs.fields, cscCmiDescrip)
    m_Creado = gDB.ValField(rs.fields, cscCreado)
    m_Modificado = gDB.ValField(rs.fields, cscModificado)
    m_Modifico = gDB.ValField(rs.fields, cscModifico)
    m_Activo = gDB.ValField(rs.fields, cscActivo)
    m_Pr_id = gDB.ValField(rs.fields, cscPrId)
    m_Producto = gDB.ValField(rs.fields, cscPrNombreVenta)
    
    m_Lp_id = gDB.ValField(rs.fields, cscLpId)
    m_ListaPrecio = gDB.ValField(rs.fields, cscLpNombre)
    m_Ld_id = gDB.ValField(rs.fields, cscLdId)
    m_ListaDescuento = gDB.ValField(rs.fields, cscLdNombre)
    
    m_depl_id = gDB.ValField(rs.fields, cscDeplId)
    m_deposito = gDB.ValField(rs.fields, cscDeplNombre)
    
    m_doc_id = gDB.ValField(rs.fields, cscDocId)
    m_Documento = gDB.ValField(rs.fields, cscDocNombre)
    m_suc_id = gDB.ValField(rs.fields, cscSucId)
    m_Sucursal = gDB.ValField(rs.fields, cscSucNombre)

  Else
  
    m_Id = csNO_ID
    m_Nombre = vbNullString
    m_Codigo = vbNullString
    m_Descrip = vbNullString
    m_Creado = csNoDate
    m_Modificado = csNoDate
    m_Modifico = 0
    m_Activo = True
  
    m_Pr_id = csNO_ID
    m_Producto = vbNullString
    
    m_Lp_id = csNO_ID
    m_ListaPrecio = vbNullString
    m_Ld_id = csNO_ID
    m_ListaDescuento = vbNullString
    
    m_depl_id = csNO_ID
    m_deposito = csNO_ID
    
    m_doc_id = csNO_ID
    m_Documento = vbNullString
    m_suc_id = csNO_ID
    m_Sucursal = vbNullString
    
  End If

  Load = True
End Function

Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  c_ErrorSave = LNGGetText(5032, vbNullString) 'Error al grabar la comunidad de internet

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc
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
'  If Err.Number <> 0 Then Resume ExitProc
'ExitProc:
'  On Error Resume Next

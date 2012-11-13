VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cTasaImpositiva"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
 
Implements CSInterfacesABM.cIEditGeneric
Implements CSInterfacesABM.cIABMClient
Implements CSMenu.cIMenuClient
'--------------------------------------------------------------------------------
' cTasaImpositiva
' 31-07-00

'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cTasaImpositiva"

Private Const K_NOMBRE       As Integer = 1
Private Const K_CODIGO       As Integer = 2
Private Const K_ACTIVO       As Integer = 3
Private Const K_PORCENTAJE   As Integer = 4
Private Const K_CODIGODGI1   As Integer = 5
Private Const K_CODIGODGI2   As Integer = 6
Private Const K_CUE_ID       As Integer = 7
Private Const K_TIPO         As Integer = 8

Public Enum csE_TasaImpositivaTipo
  csTI_Ventas = 1
  csTI_Compras = 2
End Enum

' estructuras
' variables privadas
Private m_Id                As Long
Private m_Nombre            As String
Private m_Codigo            As String
Private m_Activo            As Boolean
Private m_Porcentaje        As Double
Private m_CodigoDGI1        As String
Private m_CodigoDGI2        As String
Private m_cuenta            As String
Private m_cue_id            As Long
Private m_Tipo              As Long

Private m_Editing          As Boolean

Private m_ObjAbm           As cIABMGeneric
Private m_ObjTree          As Object

Private m_IsNew            As Boolean

Private m_BranchId         As Long
Private m_TreeId           As Long

Private m_Host As CSMenu.cIMenuHost

Private m_Copy              As Boolean

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
Public Function Data(ByVal Id As Long, ByVal Field As String) As Variant
  Dim rtn As String
  
  If Not gDB.GetData(csTTasaImpositiva, cscTiId, Id, Field, rtn, "Data", C_Module) Then Exit Function
  Data = rtn
End Function

' Implementacion de cIABMClient
Private Function cIABMClient_Copy() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True
  
  With m_ObjAbm.Properties(cscTiCodigo)
    .Value = C_C & .Value
  End With
  
'  With m_ObjAbm.Properties(cscTiNombre)
'    .Value = C_CopiaDe & .Value
'  End With
  
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscTiCodigo)
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscTiNombre)
  
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

  Doc.ClientTable = csTTasaImpositiva
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
                               csPreGNewTasaImpositiva
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
    .fieldId = cscTiId
    .Table = csTTasaImpositiva
  
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
          fields.Add2 cscTiNombre, .Value, csText
        Case K_CODIGO
          fields.Add2 cscTiCodigo, .Value, csText
        Case K_ACTIVO
          fields.Add2 cscActivo, Val(.Value), csBoolean
        Case K_PORCENTAJE
          fields.Add2 cscTiPorcentaje, .Value, csCurrency
        Case K_CODIGODGI1
          fields.Add2 cscTiCodigoDGI1, .Value, csText
        Case K_CODIGODGI2
          fields.Add2 cscTiCodigoDGI2, .Value, csText
        Case K_CUE_ID
          fields.Add2 cscCueId, .HelpId, csText
        Case K_TIPO
          fields.Add2 cscTiTipo, .ListItemData, csInteger
      End Select
    End With
  Next
  
  fields.HaveLastUpdate = True
  fields.HaveWhoModify = True
                                                         'Error al grabar Tasas Impositivas
  If Not gDB.SaveEx(register, , _
                    cscTiCodigo, _
                    C_ABMClientSave, _
                    C_Module, _
                    LNGGetText(1481, vbNullString)) Then Exit Function
  
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
  cIABMClient_Title = LNGGetText(1482, vbNullString)  'Tasas Impositivas
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
        Case K_CUE_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(1261, vbNullString)
                    'Debe indicar una cuenta
            Exit Function
          End If
        
        Case K_PORCENTAJE
          If Not IsNumeric(.Value) Then
            MsgInfo LNGGetText(1484, vbNullString)
                    'El porcentaje debe ser un número de -200.00 a 200.00
            Exit Function
          End If
          If .Value < -200 Or .Value > 200 Then
            MsgInfo LNGGetText(1483, vbNullString)
                    'El porcentaje esta fuera del rango permitido (-200.00 a 200.00)
            Exit Function
          End If
          
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
  cIEditGeneric_ShowList = SecurityCanAccess(csPreGListTasaImpositiva)
End Function

' Implementacion de cIEditGeneric
Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
  Set m_ObjAbm = rhs
End Property

Private Property Get cIEditGeneric_Editing() As Boolean
  cIEditGeneric_Editing = m_Editing
End Property

Private Function cIEditGeneric_Delete(Id As Long) As Boolean
  If Not SecurityCanAccess(csPreGDeleteTasaImpositiva) Then Exit Function
   
  Dim sqlstmt As String
  
  sqlstmt = "delete TasaImpositiva where ti_id = " & Id
  
  cIEditGeneric_Delete = gDB.Execute(sqlstmt, C_EditGenericDelete, C_Module)
End Function

Private Function cIEditGeneric_Search(Id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Id = csNO_ID Then
    m_IsNew = True
    If Not SecurityCanAccess(csPreGNewTasaImpositiva) Then Exit Function
  Else
    m_IsNew = False
    If Not SecurityCanAccess(csPreGEditTasaImpositiva) Then Exit Function
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
  
  m_Host.Server.AddMenu C_MenuContabilidad, csMenuConfigContabilidad, C_MenuConfig, 0, True, False, True, False, True, Nothing
                        '&Tasas Impositivas
  m_Host.Server.AddMenu LNGGetText(1485, vbNullString), csPreGListTasaImpositiva, C_MenuContabilidad, 0, True, False, False, False, False, Me
  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, C_MenuClientInit, C_Module, vbNullString
  If Err.Number Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal Id As Long) As Variant
                                                            'Tasas Impositivas
  m_Host.MenuABMClick "CSGeneral2.cTasaImpositiva", Me, LNGGetText(1482, vbNullString), 0, csETablasGeneral.csTasaImpositiva
End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  
  m_ObjAbm.Title2 = m_Nombre
  
  With m_ObjAbm.Properties
    
    .Clear
    
    With .Add(Nothing, cscTiNombre)
      .PropertyType = cspText
      .Name = C_strNombre
      .Size = 100
      .Width = 4500
      .Key = K_NOMBRE
      .Value = m_Nombre
    End With
    
    With .Add(Nothing, cscTiCodigo)
      .PropertyType = cspText
      .Name = C_strCodigo
      .Size = 15
      .Value = m_Codigo
      .Key = K_CODIGO
    End With
    
    With .Add(Nothing, cscActivo)
      .PropertyType = cspCheck
      .Name = C_strActivo
      .TopFromProperty = cscTiCodigo
      .TopNotChange = True
      .Left = 5200
      .LeftNotChange = True
      .LeftLabel = -700
      .Key = K_ACTIVO
      .Value = CInt(m_Activo)
    End With
    
    With .Add(Nothing, cscTiPorcentaje)
      .PropertyType = cspNumeric
      .SubType = cspPercent
      .Name = LNGGetText(1105, vbNullString) 'Porcentaje
      .Key = K_PORCENTAJE
      .Width = 1000
      .Value = m_Porcentaje
    End With
    
    With .Add(Nothing, cscCuecId)
      .PropertyType = cspHelp
      .Table = csCuenta
      .Name = LNGGetText(1267, vbNullString) 'Cuenta
      .Key = K_CUE_ID
      .Value = m_cuenta
      .HelpId = m_cue_id
    End With
    
    With .Add(Nothing, cscTiCodigoDGI1)
      .PropertyType = cspText
      .Name = LNGGetText(1486, vbNullString) 'Código DGI 1
      .Size = 5
      .Width = 1500
      .Key = K_CODIGODGI1
      .Value = m_CodigoDGI1
    End With
    
    With .Add(Nothing, cscTiCodigoDGI2)
      .PropertyType = cspText
      .Name = LNGGetText(1487, vbNullString) 'Código DGI 2
      .TopFromProperty = cscTiCodigoDGI1
      .TopNotChange = True
      .Left = 4500
      .LeftNotChange = True
      .Size = 5
      .Width = 1500
      .Key = K_CODIGODGI2
      .Value = m_CodigoDGI2
    End With
    
    With .Add(Nothing, cscTiTipo)
      .PropertyType = cspList
      .Name = LNGGetText(1223, vbNullString) 'Tipo
      .Size = 5
      .Key = K_TIPO
      .ListWhoSetItem = csListItemData
      .ListItemData = m_Tipo
      
      With .List
        With .Add(Nothing, csTI_Ventas)
          .Id = csTI_Ventas
          .Value = LNGGetText(1488, vbNullString) 'Ventas
        End With
        
        With .Add(Nothing, csTI_Compras)
          .Id = csTI_Compras
          .Value = LNGGetText(1489, vbNullString) 'Compras
        End With
      End With
    
    End With
    
  End With
  
  If Not m_ObjAbm.Show(Me) Then Exit Function

  LoadCollection = True
End Function

Private Function Load(ByVal Id As Long) As Boolean
  
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset

  sqlstmt = "select TasaImpositiva.*,cue_nombre from TasaImpositiva,Cuenta" & _
            " where TasaImpositiva.cue_id = Cuenta.cue_id" & _
              " and ti_id = " & Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function
  
  If rs.EOF Then
    m_Activo = True
    m_Nombre = vbNullString
    m_Codigo = vbNullString
    m_Id = csNO_ID
    m_Porcentaje = 0
    m_CodigoDGI1 = vbNullString
    m_CodigoDGI2 = vbNullString
    m_cue_id = 0
    m_cuenta = vbNullString
    m_Tipo = csTI_Ventas
  Else
    m_Activo = gDB.ValField(rs.fields, cscActivo)
    m_Nombre = gDB.ValField(rs.fields, cscTiNombre)
    m_Codigo = gDB.ValField(rs.fields, cscTiCodigo)
    m_Id = gDB.ValField(rs.fields, cscTiId)
    m_Porcentaje = gDB.ValField(rs.fields, cscTiPorcentaje)
    m_CodigoDGI1 = gDB.ValField(rs.fields, cscTiCodigoDGI1)
    m_CodigoDGI2 = gDB.ValField(rs.fields, cscTiCodigoDGI2)
    m_cue_id = gDB.ValField(rs.fields, cscCueId)
    m_cuenta = gDB.ValField(rs.fields, cscCueNombre)
    m_Tipo = gDB.ValField(rs.fields, cscTiTipo)
  End If
  Load = True
End Function

' construccion - destruccion
Private Sub Class_Terminate()
  On Error Resume Next
  Set m_ObjAbm = Nothing
  Set m_ObjTree = Nothing
End Sub

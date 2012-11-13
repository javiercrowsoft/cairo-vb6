VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cGasto"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGeneric
Implements CSInterfacesABM.cIABMClient
Implements CSMenu.cIMenuClient
'--------------------------------------------------------------------------------
' cGasto
' 02-02-04

'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cGasto"

Private Const K_NOMBRE                         As Integer = 1
Private Const K_CODIGO                         As Integer = 2
Private Const K_DESCRIP                        As Integer = 3
Private Const K_TIPO                           As Integer = 4
Private Const K_FIJO                           As Integer = 5
Private Const K_MINIMO                         As Integer = 6
Private Const K_PORCENTAJE                     As Integer = 7
Private Const K_IMPORTE                        As Integer = 8
Private Const K_MON_ID                         As Integer = 9
Private Const K_TI_ID                          As Integer = 10
Private Const K_ACTIVO                         As Integer = 11

' estructuras
' variables privadas
Private m_Id                           As Long
Private m_Nombre                       As String
Private m_Codigo                       As String
Private m_descrip                      As String
Private m_Tipo                         As csE_GastoTipo
Private m_Fijo                         As Double
Private m_Minimo                       As Double
Private m_Porcentaje                   As Double
Private m_Importe                      As Double
Private m_mon_id                       As Long
Private m_Moneda                       As String
Private m_Ti_id                        As Long
Private m_TasaImpositiva               As String
Private m_Activo                       As Boolean

Private m_Host              As CSMenu.cIMenuHost

Private m_Editing           As Boolean

Private m_ObjAbm            As cIABMGeneric
Private m_ObjTree           As Object

Private m_IsNew             As Boolean

Private m_BranchId          As Long
Private m_TreeId            As Long
Private m_Copy              As Boolean

' Properties publicas

Public Property Get Id() As Long
  Id = m_Id
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

  Doc.ClientTable = csTGasto
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
  cIABMClient_MessageEx = True
End Function

Private Sub cIABMClient_DiscardChanges()
    LoadCollection
End Sub

Private Function cIABMClient_Copy() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True

  With m_ObjAbm.Properties(cscGtoCodigo)
    .Value = C_C & .Value
  End With
  
'  With m_ObjAbm.Properties(cscGtoNombre)
'    .Value = C_CopiaDe & .Value
'  End With
  
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscGtoCodigo)
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscGtoNombre)
  
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
    .fieldId = cscGtoId
    .Table = csTGasto
    
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
          fields.Add2 cscGtoNombre, .Value, csText
        Case K_CODIGO
          fields.Add2 cscGtoCodigo, .Value, csText
        Case K_DESCRIP
          fields.Add2 cscGtoDescrip, .Value, csText
        Case K_TIPO
          fields.Add2 cscGtoTipo, .ListItemData, csInteger
        Case K_FIJO
          fields.Add2 cscGtoFijo, .Value, csCurrency
        Case K_MINIMO
          fields.Add2 cscGtoMinimo, .Value, csCurrency
        Case K_PORCENTAJE
          fields.Add2 cscGtoPorcentaje, .Value, csCurrency
        Case K_IMPORTE
          fields.Add2 cscGtoImporte, .Value, csCurrency
        Case K_MON_ID
          fields.Add2 cscMonId, .HelpId, csId
        Case K_TI_ID
          fields.Add2 cscTiId, .HelpId, csId
        Case K_ACTIVO
          fields.Add2 cscActivo, .Value, csBoolean

      End Select
    End With
  Next
  
  fields.HaveLastUpdate = True
  fields.HaveWhoModify = True
                                                         'Error al grabar Gasto
  If Not gDB.SaveEx(register, , _
                    cscGtoCodigo, _
                    C_ABMClientSave, _
                    C_Module, _
                    LNGGetText(1220, vbNullString)) Then Exit Function
  
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
                        'Gastos
  cIABMClient_Title = LNGGetText(1221, vbNullString)
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
        Case K_TIPO
          If ValEmpty(.ListItemData, csInteger) Then
            MsgInfo LNGGetText(1222, vbNullString)  'Debe indicar un tipo
            Exit Function
          End If
        Case K_MON_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(1108, vbNullString)  'Debe indicar un moneda
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
    cIEditGeneric_ShowList = SecurityCanAccess(csPreGListGasto)
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
    If Not SecurityCanAccess(csPreGDeleteGasto) Then Exit Function

    Dim sqlstmt As String
    
    sqlstmt = "delete Gasto where gto_id = " & Id
    
    cIEditGeneric_Delete = gDB.Execute(sqlstmt, C_EditGenericDelete, C_Module)
End Function

Private Function cIEditGeneric_Search(Id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Id = csNO_ID Then
    m_IsNew = True
    If Not SecurityCanAccess(csPreGNewGasto) Then Exit Function
  Else
    m_IsNew = False
    If Not SecurityCanAccess(csPreGEditGasto) Then Exit Function
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

' funciones privadas
Private Function LoadCollection() As Boolean
  
  m_ObjAbm.Title2 = m_Nombre
  
  With m_ObjAbm.Properties
  
    .Clear
  
    With .Add(Nothing, cscGtoNombre)
      .PropertyType = cspText
      .Name = C_strNombre
      .Size = 100
      .Key = K_NOMBRE
      .Value = m_Nombre
    End With
    
    With .Add(Nothing, cscGtoCodigo)
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
    
    With .Add(Nothing, cscGtoTipo)
      .PropertyType = cspList
      .Name = LNGGetText(1223, vbNullString)   'Tipo
      .Key = K_TIPO
      .ListWhoSetItem = csListItemData
      .ListItemData = m_Tipo
        
      With .List.Add(Nothing)
        .Id = csE_GastoTipo.csEGtoTAereo
        .Value = LNGGetText(1224, vbNullString)   'Aéreo
      End With
      With .List.Add(Nothing)
        .Id = csE_GastoTipo.csEGtoTGeneral
        .Value = C_strGeneral
      End With
      With .List.Add(Nothing)
        .Id = csE_GastoTipo.csEGtoTMaritimo
        .Value = LNGGetText(1225, vbNullString)   'Marítimo
      End With
    
    End With
    
    With .Add(Nothing, cscGtoFijo)
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Name = LNGGetText(1226, vbNullString)   'Fijo
      .Key = K_FIJO
      .Value = m_Fijo
    End With
    
    With .Add(Nothing, cscGtoMinimo)
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Name = LNGGetText(1227, vbNullString)   'Mínimo
      .Key = K_MINIMO
      .Value = m_Minimo
      .TopFromProperty = cscGtoNombre
      .Left = 5800
    End With
    
    With .Add(Nothing, cscGtoPorcentaje)
      .PropertyType = cspNumeric
      .SubType = cspPercent
      .Name = LNGGetText(1105, vbNullString)   'Porcentaje
      .Key = K_PORCENTAJE
      .Value = m_Porcentaje
    End With
    
    With .Add(Nothing, cscGtoImporte)
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Name = LNGGetText(1228, vbNullString)   'Importe
      .Key = K_IMPORTE
      .Value = m_Importe
    End With
    
    With .Add(Nothing, cscMonId)
      .PropertyType = cspHelp
      .Table = csMoneda
      .Name = LNGGetText(1113, vbNullString)   'Moneda
      .Key = K_MON_ID
      .Value = m_Moneda
      .HelpId = m_mon_id
    End With
    
    With .Add(Nothing, cscTiId)
      .PropertyType = cspHelp
      .Table = csTasaImpositiva
      .Name = LNGGetText(1229, vbNullString)   'Tasa Impositiva
      .Key = K_TI_ID
      .Value = m_TasaImpositiva
      .HelpId = m_Ti_id
    End With
    
    With .Add(Nothing, cscGtoDescrip)
      .PropertyType = cspText
      .Name = C_strDescrip
      .LeftFromProperty = cscGtoNombre
      .TopFromProperty = cscGtoFijo
      .TopToPrevious = 440
      .Height = 660
      .Width = 6500
      .Size = 255
      .SubType = cspMemo
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

  sqlstmt = "Select Gasto.*, mon_nombre, ti_nombre" & _
            " from Gasto, Moneda, TasaImpositiva" & _
            " where gto_id = " & Id & _
            " and Gasto.mon_id *= Moneda.mon_id" & _
            " and Gasto.ti_id *= TasaImpositiva.ti_id"
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.fields, cscGtoId)
    m_Nombre = gDB.ValField(rs.fields, cscGtoNombre)
    m_Codigo = gDB.ValField(rs.fields, cscGtoCodigo)
    m_descrip = gDB.ValField(rs.fields, cscGtoDescrip)
    m_Tipo = gDB.ValField(rs.fields, cscGtoTipo)
    m_Fijo = gDB.ValField(rs.fields, cscGtoFijo)
    m_Minimo = gDB.ValField(rs.fields, cscGtoMinimo)
    m_Porcentaje = gDB.ValField(rs.fields, cscGtoPorcentaje)
    m_Importe = gDB.ValField(rs.fields, cscGtoImporte)
    
    m_mon_id = gDB.ValField(rs.fields, cscMonId)
    m_Moneda = gDB.ValField(rs.fields, cscMonNombre)
    
    m_Ti_id = gDB.ValField(rs.fields, cscTiId)
    m_TasaImpositiva = gDB.ValField(rs.fields, cscTiNombre)
    m_Activo = gDB.ValField(rs.fields, cscActivo)

  Else
    m_Id = csNO_ID
    m_Nombre = vbNullString
    m_Codigo = vbNullString
    m_descrip = vbNullString
    m_Tipo = csEGtoTGeneral
    m_Fijo = 0
    m_Minimo = 0
    m_Porcentaje = 0
    m_mon_id = csNO_ID
    m_Moneda = vbNullString
    m_Ti_id = csNO_ID
    m_TasaImpositiva = vbNullString
    m_Importe = 0
    m_Activo = True

  End If

  Load = True
End Function
' construccion - destruccion

Private Function cIMenuClient_Initialize(F As Object, Host As CSMenu.cIMenuHost) As Boolean
  On Error GoTo ControlError

  Set m_Host = Host
  m_Host.Server.AddMenu C_MenuTesoreria, csMenuConfigTesoreria, C_MenuConfig, 0, True, False, False, False, True, Nothing
                          '&Gasto
  m_Host.Server.AddMenu LNGGetText(1230, vbNullString), csPreGListGasto, C_MenuTesoreria, 0, True, False, False, False, False, Me

  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, C_MenuClientInit, C_Module, vbNullString
  If Err.Number Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal Id As Long) As Variant
                                                  'Gastos
  m_Host.MenuABMClick "CSGeneral2.cGasto", Me, LNGGetText(1231, vbNullString), 0, csETablasGeneral.csGasto
End Function

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


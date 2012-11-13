VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cTarifario"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGeneric
Implements CSInterfacesABM.cIABMClient
Implements CSMenu.cIMenuClient
Implements CSInterfacesABM.cIABMClientGrid
'--------------------------------------------------------------------------------
' cTarifario
' 30-01-01

'--------------------------------------------------------------------------------

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cTarifario"

Private Const c_keyRowItem = "#RI#"

Private Const c_alturas    As String = "alturas"
Private Const c_calles     As String = "calles"
Private Const c_paralelas  As String = "paralelas"
Private Const c_calle      As String = "calle"

Private Const K_NOMBRE       As Integer = 1
Private Const K_CODIGO       As Integer = 2
Private Const K_ACTIVO       As Integer = 3
Private Const K_DESCRIP      As Integer = 4
Private Const K_CIUDAD       As Integer = 5

Private Const K_CALLES       As Integer = 9
Private Const K_PARALELAS    As Integer = 10
Private Const K_ALTURAS      As Integer = 11

Private Const KI_TFA_ID       As Integer = 1
Private Const KI_TFCALLE_ID   As Integer = 2
Private Const KI_DESDE        As Integer = 6
Private Const KI_HASTA        As Integer = 7
Private Const KI_ZONA         As Integer = 8

Private Const KIC_TFCALLE_ID  As Integer = 1
Private Const KIC_CALLE_ID    As Integer = 2

Private Const KIP_TFP_ID      As Integer = 1
Private Const KIP_TFCALLE_ID  As Integer = 2
Private Const KIP_CALLE_ID    As Integer = 3
Private Const KIP_ALTURABASE  As Integer = 4
Private Const KIP_ALTURADESDE As Integer = 5

' pseudo-constantes
Private c_ErrorSave As String

' estructuras
' variables privadas
Private m_Id                 As Long
Private m_Nombre             As String
Private m_Codigo             As String
Private m_Activo             As Boolean
Private m_Ciudad             As String
Private m_ciu_id             As Long
Private m_descrip            As String

Private m_Editing            As Boolean

Private m_ItemsDeleted            As String
Private m_ItemsDeletedCalle       As String
Private m_ItemsDeletedParalela    As String

Private m_ObjAbm             As cIABMGeneric
Private m_ObjTree            As Object

Private m_IsNew              As Boolean

Private m_BranchId           As Long
Private m_TreeId             As Long

Private m_Host               As CSMenu.cIMenuHost
Private m_Copy               As Boolean

Private m_WasChanged         As Boolean

Private m_collParalelas      As Collection
Private m_collAlturas        As Collection

Private m_LastRowCalle       As Long

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
  
  With m_ObjAbm.Properties(cscTfCodigo)
    .Value = C_C & .Value
  End With
  
'  With m_ObjAbm.Properties(cscTfNombre)
'    .Value = C_CopiaDe & .Value
'  End With
  
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscTfCodigo)
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscTfNombre)
  
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

  Doc.ClientTable = csTTarifario
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
                               csPreGNewTarifario
      cIABMClient_MessageEx = MSG_DOC_INFO_HANDLED
    
    Case MSG_GRID_ROW_CHANGE
      If Info Is Nothing Then Exit Function
      
      Dim iPropCalles As cIABMProperty
      Set iPropCalles = Info
      
      If iPropCalles.Key = K_CALLES Then
      
        If m_LastRowCalle <> 0 Then
          pUpdateGridParalela iPropCalles
          pUpdateGridAltura iPropCalles
        End If
        
        If iPropCalles.Grid.Rows.Count >= iPropCalles.SelectedIndex Then
        
          m_LastRowCalle = iPropCalles.SelectedIndex
    
          pLoadGridParalelas iPropCalles
          pLoadGridAlturas iPropCalles
        
        Else
        
          pLoadGridParalelas Nothing
          pLoadGridAlturas Nothing
        
          m_LastRowCalle = iPropCalles.SelectedIndex
          
        End If
      
      End If
      
    Case Else
      cIABMClient_MessageEx = True
  End Select
End Function

Private Sub pUpdateGridParalela(ByVal iPropCalles As cIABMProperty)
  Dim row As cIABMGridRow
  Dim tfcalle_id As Long
  
  If iPropCalles.Grid.Rows.Item(m_LastRowCalle) Is Nothing Then Exit Sub
  
  tfcalle_id = Val(pCell(iPropCalles.Grid.Rows.Item(m_LastRowCalle), KIC_TFCALLE_ID).Value)
  
  If tfcalle_id = 0 Then tfcalle_id = -m_LastRowCalle
  
  Dim i As Long
  i = 1
  While i <= m_collParalelas.Count
    Set row = m_collParalelas.Item(i)
    If Val(pCell(row, KIP_TFCALLE_ID).Value) = tfcalle_id Then
      m_collParalelas.Remove i
    Else
      i = i + 1
    End If
  Wend
  
  For Each row In m_ObjAbm.Properties.Item(c_paralelas).Grid.Rows
    If Val(pCell(row, KIP_TFCALLE_ID).Value) = 0 Then
      pCell(row, KIP_TFCALLE_ID).Value = tfcalle_id
    End If
    m_collParalelas.Add row
  Next
End Sub

Private Sub pUpdateGridAltura(ByVal iPropCalles As cIABMProperty)
  Dim row As cIABMGridRow
  Dim tfcalle_id As Long
  
  If iPropCalles.Grid.Rows.Item(m_LastRowCalle) Is Nothing Then Exit Sub
  
  tfcalle_id = Val(pCell(iPropCalles.Grid.Rows.Item(m_LastRowCalle), KIC_TFCALLE_ID).Value)
  
  If tfcalle_id = 0 Then tfcalle_id = -m_LastRowCalle
  
  Dim i As Long
  i = 1
  While i <= m_collAlturas.Count
    Set row = m_collAlturas.Item(i)
    If Val(pCell(row, KIC_CALLE_ID).Value) = tfcalle_id Then
      m_collAlturas.Remove i
    Else
      i = i + 1
    End If
  Wend
  
  For Each row In m_ObjAbm.Properties.Item(c_alturas).Grid.Rows
    If Val(pCell(row, KIP_TFCALLE_ID).Value) = 0 Then
      pCell(row, KIP_TFCALLE_ID).Value = tfcalle_id
    End If
    m_collAlturas.Add row
  Next
End Sub

Private Sub cIABMClient_DiscardChanges()
    LoadCollection
End Sub

Private Function cIABMClient_ListAdHock(Lista As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClient_Load()

End Sub

Private Function cIABMClient_PropertyChange(ByVal Key As Integer) As Boolean
  Select Case Key
    Case K_CIUDAD
      
      pGetParalelas().Grid.Columns.Item(c_calle).HelpFilter = pGetFilterCalle()
      pGetCalles().Grid.Columns.Item(c_calle).HelpFilter = pGetFilterCalle()
      
      Dim AbmGen As cABMGeneric
      Set AbmGen = m_ObjAbm
      
      AbmGen.RefreshColumnProperties pGetParalelas(), c_calle
      AbmGen.RefreshColumnProperties pGetCalles(), c_calle
  
  End Select
End Function

Private Function pGetParalelas() As cIABMProperty
  Set pGetParalelas = m_ObjAbm.Properties.Item(c_paralelas)
End Function

Private Function pGetCalles() As cIABMProperty
  Set pGetCalles = m_ObjAbm.Properties.Item(c_calles)
End Function

Private Function pGetFilterCalle() As String
  Dim filter As String
  filter = "ciu_id = " & m_ObjAbm.Properties.Item(cscCiuId).HelpId
  pGetFilterCalle = filter
End Function

Private Function cIABMClient_Save() As Boolean
  
  If m_LastRowCalle <> 0 Then
    pUpdateGridParalela m_ObjAbm.Properties.Item(c_calles)
    pUpdateGridAltura m_ObjAbm.Properties.Item(c_calles)
  End If
  
  Dim LastId     As Long
  Dim register   As cRegister
  Dim fields     As cFields
  
  Set register = New cRegister
  Set fields = register.fields
  
  With register
    .fieldId = cscTfId
    .Table = csTTarifario
    
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
            fields.Add2 cscTfNombre, .Value, csText
        Case K_CODIGO
            fields.Add2 cscTfCodigo, .Value, csText
        Case K_ACTIVO
            fields.Add2 cscActivo, Val(.Value), csBoolean
        Case K_CIUDAD
            fields.Add2 cscCiuId, Val(.HelpId), csId
        Case K_DESCRIP
            fields.Add2 cscTfDescrip, .Value, csText
      End Select
    End With
  Next
    
  fields.HaveLastUpdate = True
  fields.HaveWhoModify = True
    
  If Not register.BeginTrans(gDB) Then Exit Function
  
  If Not gDB.SaveEx(register, , _
                    cscTfCodigo, _
                    C_ABMClientSave, _
                    C_Module, _
                    c_ErrorSave) Then Exit Function
  
  LastId = m_Id
  m_Id = register.Id
  
  If Not pSaveCalles() Then GoTo SaveError
  
  If Not register.CommitTrans() Then GoTo SaveError
  
  m_Copy = False
  cIABMClient_Save = Load(register.Id)
  
  Exit Function
SaveError:
  m_Id = LastId
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
    cIABMClient_Title = LNGGetText(5040, vbNullString) 'Tarifarios
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
        Case K_CIUDAD
          If ValEmpty(Val(.HelpId), csId) Then
              MsgInfo LNGGetText(3922, vbNullString) 'Debe indicar una ciudad
              Exit Function
          End If
              
      End Select
    End With
  Next
  
  cIABMClient_Validate = True
End Function

Private Function cIABMClientGrid_ColumnAfterEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long) As Boolean
  cIABMClientGrid_ColumnAfterEdit = True
End Function

Private Function cIABMClientGrid_ColumnAfterUpdate(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long) As Boolean
  Select Case Key
    Case K_ALTURAS
      m_WasChanged = True
  End Select
  cIABMClientGrid_ColumnAfterUpdate = True
End Function

Private Function cIABMClientGrid_ColumnBeforeEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean
  cIABMClientGrid_ColumnBeforeEdit = True
End Function

Private Function cIABMClientGrid_ColumnButtonClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean

End Function

Private Sub cIABMClientGrid_ColumnCancelEdit(ByVal Key As Integer)

End Sub

Private Sub cIABMClientGrid_ColumnClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Sub cIABMClientGrid_DblClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Function cIABMClientGrid_DeleteRow(ByVal Key As Integer, row As CSInterfacesABM.cIABMGridRow, ByVal lRow As Long) As Boolean
  Dim Id As Long
  
  Select Case Key
    Case K_CALLES
      Id = Val(pCell(row, KIC_TFCALLE_ID).Value)
      If Id <> csNO_ID Then m_ItemsDeletedCalle = m_ItemsDeletedCalle & Id & C_StrColon
      
      pUpdateCollParalela lRow, Id
      pUpdateCollAltura lRow, Id
      
      pLoadGridParalelas Nothing
      pLoadGridAlturas Nothing
      
      m_LastRowCalle = 0

    Case K_PARALELAS
      Id = Val(pCell(row, KIP_TFP_ID).Value)
      If Id <> csNO_ID Then m_ItemsDeletedParalela = m_ItemsDeletedParalela & Id & C_StrColon
  
    Case K_ALTURAS
      Id = Val(pCell(row, KI_TFA_ID).Value)
      If Id <> csNO_ID Then m_ItemsDeleted = m_ItemsDeleted & Id & C_StrColon
  End Select
  
  cIABMClientGrid_DeleteRow = True
End Function

Private Function pUpdateCollParalela(ByVal row_deleted As Long, ByVal tfcalle_id_deleted As Long)
  Dim row As cIABMGridRow
  Dim tfcalle_id As Long
  Dim i As Long
  i = 1
  While i <= m_collParalelas.Count
    Set row = m_collParalelas.Item(i)
    tfcalle_id = Val(pCell(row, KIP_TFCALLE_ID).Value)
    If tfcalle_id < 0 Then
      If tfcalle_id * -1 = row_deleted Then
        m_collParalelas.Remove i
      Else
        i = i + 1
      End If
    Else
      If tfcalle_id = tfcalle_id_deleted Then
        m_collParalelas.Remove i
      Else
        i = i + 1
      End If
    End If
  Wend
  
  For Each row In m_collParalelas
    tfcalle_id = Val(pCell(row, KIP_TFCALLE_ID).Value)
    If tfcalle_id < 0 Then
      If tfcalle_id * -1 > row_deleted Then
        pCell(row, KIP_TFCALLE_ID).Value = tfcalle_id + 1 ' le resto 1 al negativo
      End If
    End If
  Next
End Function

Private Function pUpdateCollAltura(ByVal row_deleted As Long, ByVal tfcalle_id_deleted As Long)
  Dim row As cIABMGridRow
  Dim tfcalle_id As Long
  Dim i As Long
  i = 1
  While i <= m_collAlturas.Count
    Set row = m_collAlturas.Item(i)
    tfcalle_id = Val(pCell(row, KI_TFCALLE_ID).Value)
    If tfcalle_id < 0 Then
      If tfcalle_id * -1 = row_deleted Then
        m_collAlturas.Remove i
      Else
        i = i + 1
      End If
    Else
      If tfcalle_id = tfcalle_id_deleted Then
        m_collAlturas.Remove i
      Else
        i = i + 1
      End If
    End If
  Wend
  
  For Each row In m_collAlturas
    tfcalle_id = Val(pCell(row, KI_TFCALLE_ID).Value)
    If tfcalle_id < 0 Then
      If tfcalle_id * -1 > row_deleted Then
        pCell(row, KI_TFCALLE_ID).Value = tfcalle_id + 1 ' le resto 1 al negativo
      End If
    End If
  Next
End Function

Private Function cIABMClientGrid_IsEmptyRow(ByVal Key As Integer, row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_CALLES
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowCalle(row, RowIndex)
    Case K_PARALELAS
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowParalela(row, RowIndex)
    Case K_ALTURAS
      cIABMClientGrid_IsEmptyRow = pIsEmptyRow(row, RowIndex)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, C_ValidateRow, C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIABMClientGrid_ListAdHock(ByVal Key As Integer, row As CSInterfacesABM.cIABMGridRow, ByVal ColIndex As Long, List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClientGrid_NewRow(ByVal Key As Integer, ByVal Rows As Integer)

End Sub

Private Function cIABMClientGrid_ValidateRow(ByVal Key As Integer, row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_CALLES
      cIABMClientGrid_ValidateRow = pValidadeRowCalle(row, RowIndex)
    Case K_PARALELAS
      cIABMClientGrid_ValidateRow = pValidadeRowParalela(row, RowIndex)
    Case K_ALTURAS
      cIABMClientGrid_ValidateRow = pValidadeRow(row, RowIndex)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, C_ValidateRow, C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
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
    cIEditGeneric_ShowList = SecurityCanAccess(csPreGListTarifario)
End Function

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
    Set m_ObjAbm = rhs
End Property

Private Property Get cIEditGeneric_Editing() As Boolean
    cIEditGeneric_Editing = m_Editing
End Property

Private Function cIEditGeneric_Delete(Id As Long) As Boolean
    If Not SecurityCanAccess(csPreGDeleteTarifario) Then Exit Function

    Dim sqlstmt As String
    
    sqlstmt = "delete TarifarioAltura where tf_Id = " & Id & _
              " delete TarifarioParalela where tf_Id = " & Id & _
              " delete TarifarioCalle where tf_Id = " & Id & _
              " delete Tarifario where tf_Id = " & Id
    
    cIEditGeneric_Delete = gDB.Execute(sqlstmt, C_EditGenericDelete, C_Module)
End Function

Private Function cIEditGeneric_Search(Id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Id = csNO_ID Then
    m_IsNew = True
    If Not SecurityCanAccess(csPreGNewTarifario) Then Exit Function
  Else
    m_IsNew = False
    If Not SecurityCanAccess(csPreGEditTarifario) Then Exit Function
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

Private Function cIEditGeneric_PropertyChange(ByVal Key As Integer) As Boolean

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
                        '&Tarifarios
  m_Host.Server.AddMenu LNGGetText(5041, vbNullString), csPreGListTarifario, C_MenuVentas, 0, True, False, False, False, False, Me
  
  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, C_MenuClientInit, C_Module, vbNullString
  If Err.Number Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal Id As Long) As Variant
                                                   'Tarifario
  m_Host.MenuABMClick "CSGeneral2.cTarifario", Me, LNGGetText(5042, vbNullString), 0, csETablasGeneral.csTarifario
End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  
  AbmObj.MinHeight = 8600
    
  Dim c As cIABMProperty
  Dim iProp As cABMProperty
  
  m_ObjAbm.Title2 = m_Nombre
  
  Const tab_general = 0
  
  With m_ObjAbm.Tabs
    
    .Clear
  
    With .Add(Nothing)
      .Name = C_strGeneral
    End With
      
  End With
  
  With m_ObjAbm.Properties
    
    .Clear

    With .Add(Nothing, cscTfNombre)
      .PropertyType = cspText
      .Name = C_strNombre
      .Size = 100
      .Width = 7450
      .Key = K_NOMBRE
      .Value = m_Nombre
    End With
    
    With .Add(Nothing, cscTfCodigo)
      .PropertyType = cspText
      .Name = C_strCodigo
      .Size = 15
      .Value = m_Codigo
      .Key = K_CODIGO
    End With
    
    With .Add(Nothing, cscActivo)
      .TopFromProperty = cscTfCodigo
      .Left = 5000
      .LeftLabel = -600
      .LeftNotChange = True
      .PropertyType = cspCheck
      .Name = C_strActivo
      .Key = K_ACTIVO
      .Value = CInt(m_Activo)
    End With
        
    With .Add(Nothing, cscCiuId)
      .PropertyType = cspHelp
      .Table = csCiudad
      .Name = LNGGetText(1079, vbNullString)    'Ciudad
      .Key = K_CIUDAD
      .Value = m_Ciudad
      .Width = 3000
      .HelpId = m_ciu_id
      .Enabled = m_Id = csNO_ID
    End With
                
    With .Add(Nothing, cscTfDescrip)
      .PropertyType = cspText
      .Name = C_strDescrip
      .LeftFromProperty = cscTfNombre
      .TopFromProperty = cscCiuId
      .TopToPrevious = 440
      .Height = 660
      .Width = 7450
      .Size = 255
      .SubType = cspMemo
      .Key = K_DESCRIP
      .Value = m_descrip
    End With
        
    m_LastRowCalle = 0
        
    With .Add(Nothing)
      .PropertyType = cspLabel
      .Value = LNGGetText(3921, vbNullString)   'Calles
      .Left = 200
      .Top = 3200
    End With
        
    Dim o As cABMGrid

    Set c = .Add(Nothing, c_calles)
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      If Not pLoadCalles(c) Then Exit Function
      .Name = LNGGetText(3921, vbNullString)   'Calles
      .Key = K_CALLES
      .GridAdd = True
      .GridEdit = True
      .GridRemove = True
      .Left = 200
      .Height = 2000
      .Top = 3500
      
      Set o = c.Grid
      o.DontResizeHeight = True
    End With
        
    With .Add(Nothing)
      .PropertyType = cspLabel
      .Value = LNGGetText(5044, vbNullString)   'Paralelas
      .Left = 200
      .Top = 5700
    End With
    
    Set c = .Add(Nothing, c_paralelas)
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      If Not pLoadParalelas(c) Then Exit Function
      .Name = LNGGetText(5044, vbNullString)   'Paralelas
      .Key = K_PARALELAS
      .GridAdd = True
      .GridEdit = True
      .GridRemove = True
      .Left = 200
      .Height = 1700
      .Top = 6000
      .Enabled = False
    
      Set o = c.Grid
      o.DontResizeHeight = True
    End With
    
    m_ItemsDeletedCalle = vbNullString
        
    With .Add(Nothing)
      .PropertyType = cspLabel
      .Value = LNGGetText(3924, vbNullString)   'Alturas
      .Left = 200
      .Top = 7900
    End With
    
    m_ItemsDeletedParalela = vbNullString
        
    Set c = .Add(Nothing, c_alturas)
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      If Not pLoadAlturas(c) Then Exit Function
      .Name = LNGGetText(3924, vbNullString)   'Alturas
      .Key = K_ALTURAS
      .GridAdd = True
      .GridEdit = True
      .GridRemove = True
      .Left = 200
      .Top = 8200
      .Enabled = False
    End With

    m_ItemsDeleted = vbNullString

  End With
      
  If Not m_ObjAbm.Show(Me) Then Exit Function

  LoadCollection = True
End Function

Private Function Load(ByVal Id As Long) As Boolean
  
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "select c.*,ciu_nombre from Tarifario c inner join ciudad ciu on c.ciu_id = ciu.ciu_id and tf_id = " & Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function
  
  If rs.EOF Then
    m_Activo = True
    m_Nombre = vbNullString
    m_Codigo = vbNullString
    m_descrip = vbNullString
    m_Id = csNO_ID
    m_ciu_id = csNO_ID
    m_Ciudad = vbNullString
  Else
    m_Activo = gDB.ValField(rs.fields, cscActivo)
    m_Nombre = gDB.ValField(rs.fields, cscTfNombre)
    m_Codigo = gDB.ValField(rs.fields, cscTfCodigo)
    m_descrip = gDB.ValField(rs.fields, cscTfDescrip)
    m_Id = gDB.ValField(rs.fields, cscTfId)
    m_ciu_id = gDB.ValField(rs.fields, cscCiuId)
    m_Ciudad = gDB.ValField(rs.fields, cscCiuNombre)
  End If
    
  Load = True
End Function

Private Function pLoadCalles(ByRef Propiedad As cIABMProperty) As Boolean
  
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  m_WasChanged = False

  Dim filter As String
  
  sqlstmt = "select t.*,calle_nombre" & _
           " from TarifarioCalle t" & _
                " inner join Calle c on t.calle_id = c.calle_id" & _
           " where t.tf_id = " & m_Id
    
  If Not gDB.OpenRs(sqlstmt, _
                    rs, _
                    csRsStatic, _
                    csLockReadOnly, _
                    csCmdText, _
                    C_LoadFunction, _
                    C_Module) Then Exit Function
  
  With Propiedad.Grid
    With .Columns
    
      .Clear
      
      With .Add(Nothing)
        .Visible = False
        .Key = KIC_TFCALLE_ID
      End With
    
      With .Add(Nothing, c_calle)
        .Name = LNGGetText(1194, vbNullString)  'Calle
        .PropertyType = cspHelp
        .Table = csCalle
        .Width = 1200
        .Key = KIC_CALLE_ID
        .HelpFilter = pGetFilterCalle()
      End With
    
    End With
          
    With .Rows
    
      .Clear
    
      While Not rs.EOF
      
        With .Add(Nothing, rs(cscTfCalleId).Value)
          
          With .Add(Nothing)
            .Value = rs(cscTfCalleId).Value
            .Key = KIC_TFCALLE_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCalleNombre)
            .Id = gDB.ValField(rs.fields, cscCalleId)
            .Key = KIC_CALLE_ID
          End With
       
        End With
                
        rs.MoveNext
      Wend
    
    End With
  End With
  
  pLoadCalles = True

End Function

Private Function pLoadParalelas(ByRef Propiedad As cIABMProperty) As Boolean
  
  With Propiedad.Grid
    With .Columns
    
      .Clear
      
      With .Add(Nothing)
        .Visible = False
        .Key = KIP_TFP_ID
      End With
    
      With .Add(Nothing)
        .Visible = False
        .Key = KIP_TFCALLE_ID
      End With
    
      With .Add(Nothing, c_calle)
        .Name = LNGGetText(1194, vbNullString)  'Calle
        .PropertyType = cspHelp
        .Table = csCalle
        .Width = 1200
        .Key = KIP_CALLE_ID
        .HelpFilter = pGetFilterCalle()
      End With
    
      With .Add(Nothing)
        .Name = LNGGetText(5045, vbNullString)  'Altura Base
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Format = "0"
        .Width = 1200
        .Key = KIP_ALTURABASE
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(5046, vbNullString)  'Altura Desde
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Format = "0"
        .Width = 1200
        .Key = KIP_ALTURADESDE
      End With
    
    End With
          
    With .Rows
    
      .Clear
    
    End With
  End With

  pLoadParalelas = pCollLoadParalelas(Propiedad)
End Function

Private Function pLoadAlturas(ByRef Propiedad As cIABMProperty) As Boolean
  
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  m_WasChanged = False

  Dim filter As String
  
  sqlstmt = "select t.*, zon_nombre" & _
           " from TarifarioAltura t" & _
                " inner join Zona z on t.zon_id = z.zon_id" & _
           " where tf_id = " & m_Id
    
  If Not gDB.OpenRs(sqlstmt, _
                    rs, _
                    csRsStatic, _
                    csLockReadOnly, _
                    csCmdText, _
                    C_LoadFunction, _
                    C_Module) Then Exit Function
  
  With Propiedad.Grid
    With .Columns
    
      .Clear
      
      With .Add(Nothing)
        .Visible = False
        .Key = KI_TFA_ID
      End With
    
      With .Add(Nothing)
        .Visible = False
        .Key = KI_TFCALLE_ID
      End With
    
      With .Add(Nothing)
        .Name = LNGGetText(2532, vbNullString)  'Desde
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Format = "0"
        .Width = 1200
        .Key = KI_DESDE
      End With
    
      With .Add(Nothing)
        .Name = LNGGetText(2533, vbNullString)  'Hasta
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Format = "0"
        .Width = 1200
        .Key = KI_HASTA
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1402, vbNullString)  'Zona
        .PropertyType = cspHelp
        .Table = csZona
        .Key = KI_ZONA
        .Width = 2500
      End With
    
    End With
          
    With .Rows
    
      .Clear
    
    End With
    
  End With
  
  pLoadAlturas = pCollLoadAlturas(Propiedad)

End Function

Private Sub pLoadGridParalelas(ByVal iPropCalles As cIABMProperty)
  Dim row As cIABMGridRow
  Dim tfcalle_id As Long
  Dim Rows As cIABMGridRows
  Dim iProp As cIABMProperty
    
  Set iProp = m_ObjAbm.Properties.Item(c_paralelas)
  Set Rows = iProp.Grid.Rows
  Rows.Clear
    
  If Not iPropCalles Is Nothing Then
  
    tfcalle_id = Val(pCell(iPropCalles.Grid.Rows.Item(iPropCalles.SelectedIndex), KIC_TFCALLE_ID).Value)
    
    If tfcalle_id = 0 Then tfcalle_id = -iPropCalles.SelectedIndex
    
    For Each row In m_collParalelas
      If Val(pCell(row, KIP_TFCALLE_ID).Value) = tfcalle_id Then
        Rows.Add row
      End If
    Next
  
  End If
  
  Dim AbmGen As cABMGeneric
  Set AbmGen = m_ObjAbm
  iProp.Enabled = True
  AbmGen.ShowValue iProp, True
End Sub

Private Sub pLoadGridAlturas(ByVal iPropCalles As cIABMProperty)
  Dim row As cABMGridRow
  Dim tfcalle_id As Long
  Dim Rows As cIABMGridRows
  Dim iProp As cIABMProperty
    
  Set iProp = m_ObjAbm.Properties.Item(c_alturas)
  Set Rows = iProp.Grid.Rows
  Rows.Clear
  
  If Not iPropCalles Is Nothing Then
    
    tfcalle_id = Val(pCell(iPropCalles.Grid.Rows.Item(iPropCalles.SelectedIndex), KIC_TFCALLE_ID).Value)
    
    If tfcalle_id = 0 Then tfcalle_id = -iPropCalles.SelectedIndex
    
    For Each row In m_collAlturas
      If Val(pCell(row, KIP_TFCALLE_ID).Value) = tfcalle_id Then
        Rows.Add row
      End If
    Next
  
  End If
  
  Dim AbmGen As cABMGeneric
  Set AbmGen = m_ObjAbm
  iProp.Enabled = True
  AbmGen.ShowValue iProp, True
End Sub

Private Function pCollLoadAlturas(ByRef Propiedad As cIABMProperty) As Boolean
  
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  m_WasChanged = False

  Dim filter As String
  
  sqlstmt = "select t.*, zon_nombre" & _
           " from TarifarioAltura t" & _
                " inner join Zona z on t.zon_id = z.zon_id" & _
           " where tf_id = " & m_Id
    
  If Not gDB.OpenRs(sqlstmt, _
                    rs, _
                    csRsStatic, _
                    csLockReadOnly, _
                    csCmdText, _
                    "pCollLoadAlturas", _
                    C_Module) Then Exit Function
  
  Set m_collAlturas = New Collection
          
  With m_collAlturas
      
    While Not rs.EOF
    
      Dim i As Long
      Dim row As cABMGridRow
      Set row = New cABMGridRow
      
      m_collAlturas.Add row
    
      With row
        
        With .Add(Nothing, c_keyRowItem)
          .Value = i
        End With
        
        With .Add(Nothing)
          .Value = rs(cscTfaId).Value
          .Key = KI_TFA_ID
        End With
        
        With .Add(Nothing)
          .Value = rs(cscTfCalleId).Value
          .Key = KI_TFCALLE_ID
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscTfaDesde)
          .Key = KI_DESDE
        End With
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscTfaHasta)
          .Key = KI_HASTA
        End With
     
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscZonNombre)
          .Id = gDB.ValField(rs.fields, cscZonId)
          .Key = KI_ZONA
        End With
     
      End With
              
      rs.MoveNext
    Wend
    
  End With
  
  pCollLoadAlturas = True

End Function

Private Function pCollLoadParalelas(ByRef Propiedad As cIABMProperty) As Boolean
  
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  m_WasChanged = False

  Dim filter As String
  
  sqlstmt = "select t.*, c.calle_nombre" & _
           " from TarifarioParalela t" & _
                " inner join Calle c on t.calle_id = c.calle_id" & _
           " where tf_id = " & m_Id
    
  If Not gDB.OpenRs(sqlstmt, _
                    rs, _
                    csRsStatic, _
                    csLockReadOnly, _
                    csCmdText, _
                    "pCollLoadParalelas", _
                    C_Module) Then Exit Function
  
  Set m_collParalelas = New Collection
          
  With m_collParalelas
      
    While Not rs.EOF
    
      Dim i As Long
      Dim row As cIABMGridRow
      Set row = New cABMGridRow
      
      m_collParalelas.Add row
      i = i + 1
      
      With row
        
        With .Add(Nothing, c_keyRowItem)
          .Value = i
        End With
        
        With .Add(Nothing)
          .Value = rs(cscTfpId).Value
          .Key = KIP_TFP_ID
        End With
        
        With .Add(Nothing)
          .Value = rs(cscTfCalleId).Value
          .Key = KIP_TFCALLE_ID
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscCalleNombre)
          .Id = gDB.ValField(rs.fields, cscCalleId)
          .Key = KIP_CALLE_ID
        End With
     
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscTfpAlturaBase)
          .Key = KIP_ALTURABASE
        End With
        
        With .Add(Nothing)
          .Value = gDB.ValField(rs.fields, cscTfpAlturaDesde)
          .Key = KIP_ALTURADESDE
        End With
     
      End With
              
      rs.MoveNext
    Wend
    
  End With
  
  pCollLoadParalelas = True

End Function

Private Function pSaveCalles() As Boolean
  
  Dim register  As cRegister
  Dim fields    As cFields
  Dim IProperty As cIABMProperty
  
  With m_ObjAbm.Properties.Item(c_calles)
    Dim row  As cIABMGridRow
    Dim Cell As cIABMGridCellValue
    
    For Each row In .Grid.Rows
       
      Set register = New cRegister
      
      With register
        Set fields = .fields
        .fieldId = cscTfCalleId
        .Table = csTTarifarioCalle
        .Id = csNew
        
        For Each Cell In row
          Select Case Cell.Key
            
            Case KIC_TFCALLE_ID
              If Not m_Copy Then
                .Id = Val(Cell.Value)
              End If
              
            Case KIC_CALLE_ID
              fields.Add2 cscCalleId, Cell.Id, csId
                      
          End Select
        Next
        
        fields.Add2 cscTfId, m_Id, csId
        
        fields.HaveLastUpdate = False
        fields.HaveWhoModify = False
        
      End With
                                                              
      If Not gDB.Save(register, , "pSaveCalles", C_Module, c_ErrorSave) Then Exit Function
      
      Dim rowItem     As cIABMGridRow
      Dim tfcalle_id  As Long
      Dim i           As Long
      
      i = i + 1
      
      For Each rowItem In m_collParalelas
        tfcalle_id = Val(pCell(rowItem, KIP_TFCALLE_ID).Value)
        If tfcalle_id < 0 Then
          If tfcalle_id = -i Then
            If Not pSaveParalela(register.Id, rowItem) Then Exit Function
          End If
        Else
          If tfcalle_id = register.Id Then
            If Not pSaveParalela(register.Id, rowItem) Then Exit Function
          End If
        End If
      Next
      
      For Each rowItem In m_collAlturas
        tfcalle_id = Val(pCell(rowItem, KI_TFCALLE_ID).Value)
        If tfcalle_id < 0 Then
          If tfcalle_id = -i Then
            If Not pSaveAltura(register.Id, rowItem) Then Exit Function
          End If
        Else
          If tfcalle_id = register.Id Then
            If Not pSaveAltura(register.Id, rowItem) Then Exit Function
          End If
        End If
      Next
      
    Next
  End With
  
  Dim sqlstmt As String
  
  If m_ItemsDeletedCalle <> vbNullString And Not m_Copy Then
    m_ItemsDeletedCalle = RemoveLastColon(m_ItemsDeletedCalle)
    sqlstmt = "delete TarifarioParalela where tfcalle_id in (" & m_ItemsDeletedCalle & ")" & _
              " delete TarifarioAltura where tfcalle_id in (" & m_ItemsDeletedCalle & ")" & _
              " delete TarifarioCalle where tfcalle_id in (" & m_ItemsDeletedCalle & ")"

    If Not gDB.Execute(sqlstmt, "pSaveCalles", C_Module) Then Exit Function
  End If
  
  If m_ItemsDeletedParalela <> vbNullString And Not m_Copy Then
    m_ItemsDeletedParalela = RemoveLastColon(m_ItemsDeletedParalela)
    sqlstmt = "delete TarifarioParalela where tfp_id in (" & m_ItemsDeletedParalela & ")"
  
    If Not gDB.Execute(sqlstmt, "pSaveCalles", C_Module) Then Exit Function
  End If
  
  If m_ItemsDeleted <> vbNullString And Not m_Copy Then
    m_ItemsDeleted = RemoveLastColon(m_ItemsDeleted)
    sqlstmt = "delete TarifarioAltura where tfa_id in (" & m_ItemsDeleted & ")"
  
    If Not gDB.Execute(sqlstmt, "pSaveCalles", C_Module) Then Exit Function
  End If
  
  pSaveCalles = True
End Function

Private Function pSaveParalela(ByVal tfcalle_id As Long, ByVal row As cIABMGridRow) As Boolean
  Dim register  As cRegister
  Dim fields    As cFields
  Dim Cell      As cIABMGridCellValue
  
  Set register = New cRegister
  
  With register
    Set fields = .fields
    .fieldId = cscTfpId
    .Table = csTTarifarioParalela
    .Id = csNew
    
    For Each Cell In row
      Select Case Cell.Key
        
        Case KIP_TFP_ID
          If Not m_Copy Then
            .Id = Val(Cell.Value)
          End If
        
        Case KIP_TFCALLE_ID
          fields.Add2 cscTfCalleId, tfcalle_id, csId
        
        Case KIP_CALLE_ID
          fields.Add2 cscCalleId, Cell.Id, csId
                          
        Case KIP_ALTURABASE
          fields.Add2 cscTfpAlturaBase, Cell.Value, csLong
                          
        Case KIP_ALTURADESDE
          fields.Add2 cscTfpAlturaDesde, Cell.Value, csLong
                          
      End Select
    Next
    
    fields.Add2 cscTfId, m_Id, csId
    
    fields.HaveLastUpdate = False
    fields.HaveWhoModify = False
    
  End With
                                                          
  If Not gDB.Save(register, , "pSaveParalelas", C_Module, c_ErrorSave) Then Exit Function
    
  pSaveParalela = True
End Function

Private Function pSaveAltura(ByVal tfcalle_id As Long, ByVal row As cIABMGridRow) As Boolean
  Dim register  As cRegister
  Dim fields    As cFields
  Dim Cell      As cIABMGridCellValue
  
  Set register = New cRegister
  
  With register
    Set fields = .fields
    .fieldId = cscTfaId
    .Table = csTTarifarioAltura
    .Id = csNew
    
    For Each Cell In row
      Select Case Cell.Key
        
        Case KI_TFA_ID
          If Not m_Copy Then
            .Id = Val(Cell.Value)
          End If
        
        Case KI_DESDE
          fields.Add2 cscTfaDesde, Cell.Value, csDouble
        Case KI_HASTA
          fields.Add2 cscTfaHasta, Cell.Value, csDouble
          
        Case KIP_TFCALLE_ID
          fields.Add2 cscTfCalleId, tfcalle_id, csId
          
        Case KI_ZONA
          fields.Add2 cscZonId, Cell.Id, csId
          
      End Select
    Next
    
    fields.Add2 cscTfId, m_Id, csId
    
    fields.HaveLastUpdate = False
    fields.HaveWhoModify = False
    
  End With
                                                          
  If Not gDB.Save(register, , "pSaveAlturas", C_Module, c_ErrorSave) Then Exit Function
  
  pSaveAltura = True
End Function

Private Function pValidadeRowCalle(row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In row
    Select Case Cell.Key
      Case KIC_CALLE_ID
        If Cell.Id = csNO_ID Then
                    'Debe indicar una calle
          MsgInfo LNGGetText(3827, vbNullString, strRow)
          Exit Function
        End If
    End Select
  Next
  
  pValidadeRowCalle = True
End Function

Private Function pValidadeRowParalela(row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In row
    Select Case Cell.Key
      Case KIP_CALLE_ID
        If Cell.Id = csNO_ID Then
                    'Debe indicar una calle
          MsgInfo LNGGetText(3827, vbNullString, strRow)
          Exit Function
        End If
    End Select
  Next
  
  pValidadeRowParalela = True
End Function

Private Function pValidadeRow(row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In row
    Select Case Cell.Key
      Case KI_DESDE
        If Val(Cell.Value) < 0 Then
                    'Debe indicar una altura inicial
          MsgInfo LNGGetText(3925, vbNullString, strRow)
          Exit Function
        End If
      Case KI_HASTA
        If Val(Cell.Value) <= 0 Then
                    'Debe indicar una altura final
          MsgInfo LNGGetText(3926, vbNullString, strRow)
          Exit Function
        End If
      Case KI_ZONA
        If Cell.Id = csNO_ID Then
                    'Debe indicar una zona
          MsgInfo LNGGetText(3926, vbNullString, strRow)
          Exit Function
        End If
    End Select
  Next
  
  pValidadeRow = True
End Function

Private Function pIsEmptyRowCalle(ByRef row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim bRowIsEmpty           As Boolean
  
  bRowIsEmpty = True
  
  For Each Cell In row
    Select Case Cell.Key
      Case KIC_CALLE_ID
        If Cell.Value <> "" Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowCalle = bRowIsEmpty
End Function

Private Function pIsEmptyRowParalela(ByRef row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim bRowIsEmpty           As Boolean
  
  bRowIsEmpty = True
  
  For Each Cell In row
    Select Case Cell.Key
      Case KIP_CALLE_ID
        If Cell.Value <> "" Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowParalela = bRowIsEmpty
End Function

Private Function pIsEmptyRow(ByRef row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim bRowIsEmpty           As Boolean
  
  bRowIsEmpty = True
  
  For Each Cell In row
    Select Case Cell.Key
      Case KI_DESDE, KI_HASTA
        If Val(Cell.Value) > 0 Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRow = bRowIsEmpty
End Function

' construccion - destruccion
Private Sub Class_Initialize()
  On Error Resume Next
  c_ErrorSave = LNGGetText(5043, vbNullString) 'Error al grabar el tarifario
End Sub

Private Sub Class_Terminate()
  On Error Resume Next
  Set m_ObjAbm = Nothing
  Set m_ObjTree = Nothing
End Sub


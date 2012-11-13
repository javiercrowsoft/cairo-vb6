VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cSindicatoConvenio"
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
' cSindicatoConvenio
' 12-08-08

'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cSindicatoConvenio"

Private Const K_NOMBRE      As Integer = 1
Private Const K_CODIGO      As Integer = 2
Private Const K_DESCRIP     As Integer = 3
Private Const K_ACTIVO      As Integer = 4
Private Const K_SIND_ID     As Integer = 5

Private Const K_ITEMS           As Integer = 7

Private Const KI_SINDCC_ID      As Integer = 1
Private Const KI_IMPORTE        As Integer = 2
Private Const KI_TIPO           As Integer = 3
Private Const KI_HORAXMES       As Integer = 4
Private Const KI_DIAXMES        As Integer = 5
Private Const KI_SINDCA_ID      As Integer = 6
Private Const KI_DESDE          As Integer = 7
Private Const KI_HASTA          As Integer = 8

' estructuras
' Seudo - Variables
Private c_ErrorSave         As String

' variables privadas
Private m_Id                As Long
Private m_Nombre            As String
Private m_Codigo            As String
Private m_descrip           As String
Private m_Activo            As Boolean
Private m_Sindicato         As String
Private m_sind_id           As Long

' HOJO HASTA ACA

Private m_Editing           As Boolean

Private m_ObjAbm            As cIABMGeneric
Private m_ObjTree           As Object

Private m_IsNew             As Boolean

Private m_BranchId          As Long
Private m_TreeId            As Long

Private m_Host              As CSMenu.cIMenuHost
Private m_Copy              As Boolean

Private m_GeneralConfig     As cGeneralConfig

Private m_ItemsDeletedItems            As String
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
Private Function cIABMClient_Copy() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True
  
  With m_ObjAbm.Properties(cscSindCodigo)
    .Value = C_C & .Value
  End With
  
'  With m_ObjAbm.Properties(cscPaNombre)
'    .Value = C_CopiaDe & .Value
'  End With
  
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscSindCodigo)
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscSindNombre)
  
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

  Doc.ClientTable = csTSindicatoConvenio
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
                               csPrePNewSindicatoConvenio
      cIABMClient_MessageEx = MSG_DOC_INFO_HANDLED
    Case Else
      cIABMClient_MessageEx = True
  End Select
End Function

Private Sub cIABMClient_DiscardChanges()
    LoadCollection
End Sub

Private Function cIABMClient_ListAdHock(List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClient_Load()

End Sub

Private Function cIABMClient_PropertyChange(ByVal Clave As Integer) As Boolean

End Function

Private Function cIABMClient_Save() As Boolean
  Dim LastId      As Long
  Dim register    As cRegister
  Dim fields      As cFields
  
  Set register = New cRegister
  Set fields = register.fields
  
  With register
    .fieldId = cscSindcoId
    .Table = csTSindicatoConvenio
  
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
          fields.Add2 cscSindcoNombre, .Value, csText
        Case K_CODIGO
          fields.Add2 cscSindcoCodigo, .Value, csText
        Case K_DESCRIP
          fields.Add2 cscSindcoDescrip, .Value, csText
        Case K_ACTIVO
          fields.Add2 cscActivo, .Value, csBoolean
        Case K_SIND_ID
          fields.Add2 cscSindId, .HelpId, csId
      End Select
    End With
  Next
  
  fields.HaveLastUpdate = True
  fields.HaveWhoModify = True
  
  If Not register.BeginTrans(gDB) Then Exit Function
  
  If Not gDB.SaveEx(register, , _
                    cscSindcoCodigo, _
                    C_ABMClientSave, _
                    C_Module, _
                    c_ErrorSave) Then Exit Function
  
  LastId = m_Id
  m_Id = register.Id
  
  If Not pSaveItems() Then GoTo SaveError
  
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
                             'Convenio Sindical
  cIABMClient_Title = LNGGetText(4504, vbNullString)
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
        Case K_SIND_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(4507, vbNullString) ' Debe indicar un sindicato
            Exit Function
          End If

      End Select
    End With
  Next

  cIABMClient_Validate = True
End Function

' Implementacion de cIEditGeneric
Private Property Get cIEditGeneric_ObjAbm() As CSInterfacesABM.cIABMGeneric
  Set cIEditGeneric_ObjAbm = m_ObjAbm
End Property

Private Function cIEditGeneric_TabClick(ByVal Index As Integer) As Boolean

End Function

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
    cIEditGeneric_ShowList = SecurityCanAccess(csPrePListSindicatoConvenio)
End Function

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
    Set m_ObjAbm = rhs
End Property

Private Property Get cIEditGeneric_Editing() As Boolean
    cIEditGeneric_Editing = m_Editing
End Property

Private Function cIEditGeneric_Delete(Id As Long) As Boolean
    If Not SecurityCanAccess(csPrePDeleteSindicatoConvenio) Then Exit Function

    Dim sqlstmt As String
    
    sqlstmt = "delete SindicatoConvenioCategoria where sindco_id = " & Id
    sqlstmt = sqlstmt & " delete SindicatoConvenio where sindco_id = " & Id
    
    cIEditGeneric_Delete = gDB.Execute(sqlstmt, C_EditGenericDelete, C_Module)
End Function

Private Function cIEditGeneric_Search(Id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Id = csNO_ID Then
    m_IsNew = True
    If Not SecurityCanAccess(csPrePNewSindicatoConvenio) Then Exit Function
  Else
    m_IsNew = False
    If Not SecurityCanAccess(csPrePEditSindicatoConvenio) Then Exit Function
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

Private Function cIMenuClient_Initialize(F As Object, Host As CSMenu.cIMenuHost) As Boolean
  On Error GoTo ControlError

  Set m_Host = Host
  
  m_Host.Server.AddMenu C_MenuManejoPersonal, csMenuConfigMPersonal, C_MenuConfig, 0, True, False, False, False, True, Nothing
  m_Host.Server.AddMenu C_MenuSueldos, csMenuConfigSueldos, C_MenuManejoPersonal, 0, True, False, False, False, True, Nothing
                            '&Convenio Sindical
  m_Host.Server.AddMenu LNGGetText(4508, vbNullString), csPrePListSindicatoConvenio, C_MenuSueldos, 0, True, False, False, False, False, Me
  
  cIMenuClient_Initialize = True
  
  GoTo ExitProc
ControlError:
  MngError Err, C_MenuClientInit, C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal Id As Long) As Variant
                                                  'Convenios Sindicales
  m_Host.MenuABMClick "CSPersonal.cSindicatoConvenio", Me, LNGGetText(4506, vbNullString), 0, csETablesPersonal.csSindicatoConvenio
  
End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  Dim c As cIABMProperty
      
  With m_ObjAbm.Tabs
  
    .Clear
      
    With .Add(Nothing)
      .Name = C_strGeneral
    End With
    
    With .Add(Nothing)
      .Index = 1
      .Name = LNGGetText(4502, vbNullString) 'Categorias
    End With
    
  End With
  
  m_ObjAbm.Title2 = m_Nombre

  With m_ObjAbm.Properties
    
    .Clear
    
    With .Add(Nothing, cscSindcoNombre)
      .PropertyType = cspText
      .Name = C_strNombre
      .Size = 100
      .Key = K_NOMBRE
      .Value = m_Nombre
      .Width = 6200
    End With
      
    With .Add(Nothing, cscSindcoCodigo)
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
      
    With .Add(Nothing, cscSindId)
      .PropertyType = cspHelp
      .Table = csSindicato
      .Name = LNGGetText(4503, vbNullString) ' Sindicato
      .Key = K_SIND_ID
      .Value = m_Sindicato
      .HelpId = m_sind_id
      .Width = 5200
    End With
    
    With .Add(Nothing, cscSindcoDescrip)
      .PropertyType = cspText
      .Name = C_strDescrip
      .Size = 255
      .Key = K_DESCRIP
      .Value = m_descrip
      .SubType = cspMemo
      .Width = 6200
      .Height = 880
    End With
  
    Set c = .Add(Nothing, c_Items)
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      If Not pLoadItems(c) Then Exit Function
      .Name = c_Items
      .Key = K_ITEMS
      .TabIndex = 1
      .GridAdd = True
      .GridEdit = True
      .GridRemove = True
    End With
  
    m_ItemsDeletedItems = vbNullString
  
  End With
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

Private Function Load(ByVal Id As Long) As Boolean

  Dim sqlstmt As String
  Dim rs      As Recordset
  
  sqlstmt = "select s.*,sind_nombre from SindicatoConvenio s inner join Sindicato sind on s.sind_id = sind.sind_id where sindco_id = " & Id

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.fields, cscSindcoId)
    m_Nombre = gDB.ValField(rs.fields, cscSindcoNombre)
    m_Codigo = gDB.ValField(rs.fields, cscSindcoCodigo)
    m_descrip = gDB.ValField(rs.fields, cscSindcoDescrip)
    m_Activo = gDB.ValField(rs.fields, cscActivo)
    m_Sindicato = gDB.ValField(rs.fields, cscSindNombre)
    m_sind_id = gDB.ValField(rs.fields, cscSindId)

  Else
    m_Id = csNO_ID
    m_Nombre = vbNullString
    m_Codigo = vbNullString
    m_descrip = vbNullString
    m_Activo = True
    m_Sindicato = vbNullString
    m_sind_id = csNO_ID

  End If

  Load = True
End Function

Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  c_ErrorSave = LNGGetText(4505, vbNullString) 'Error al grabar el convenio sindical
  
  Set m_GeneralConfig = New cGeneralConfig
  m_GeneralConfig.Load

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
  Set m_GeneralConfig = Nothing
End Sub


'------------------------------------------------------------------
'------------------------------------------------------------------
Private Function cIABMClientGrid_ColumnAfterEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long) As Boolean
  cIABMClientGrid_ColumnAfterEdit = True
End Function

Private Function cIABMClientGrid_ColumnBeforeEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean
  cIABMClientGrid_ColumnBeforeEdit = True
End Function

Private Function cIABMClientGrid_ColumnButtonClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean

End Function

Private Sub cIABMClientGrid_ColumnCancelEdit(ByVal Key As Integer)

End Sub

Private Function cIABMClientGrid_DeleteRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal lRow As Long) As Boolean
  Dim Id As Long
  
  Id = Val(pCell(Row, KI_SINDCC_ID).Value)
  
  If Id <> csNO_ID Then m_ItemsDeletedItems = m_ItemsDeletedItems & Id & C_StrColon
  
  cIABMClientGrid_DeleteRow = True
End Function

Private Function cIABMClientGrid_ListAdHock(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal ColIndex As Long, List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClientGrid_NewRow(ByVal Key As Integer, ByVal Rows As Integer)

End Sub

Private Sub cIABMClientGrid_ColumnClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Sub cIABMClientGrid_DblClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Function cIABMClientGrid_ValidateRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_ITEMS
      cIABMClientGrid_ValidateRow = pValidateRowItems(Row, RowIndex)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, C_ValidateRow, C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIABMClientGrid_ColumnAfterUpdate(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long) As Boolean

End Function

Private Function cIABMClientGrid_IsEmptyRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_ITEMS
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowItems(Row, RowIndex)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, C_IsEmptyRow, C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pIsEmptyRowItems(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim bRowIsEmpty           As Boolean
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_IMPORTE
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KI_TIPO
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowItems = bRowIsEmpty
End Function


Private Function pValidateRowItems(Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell    As cIABMGridCellValue
  Dim strRow  As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_SINDCA_ID
        If ValEmpty(Cell.Id, csId) Then
          MsgInfo LNGGetText(4649, vbNullString, strRow) 'Debe indicar una categoria
          Exit Function
        End If
      Case KI_IMPORTE
        If Val(Cell.Value) < 0 Then
          MsgInfo LNGGetText(4513, vbNullString, strRow) 'El importe no puede ser negativo
          Exit Function
        End If
      Case KI_DIAXMES
        If Val(Cell.Value) <= 0 Or Val(Cell.Value) > 31 Then
          MsgInfo LNGGetText(4514, vbNullString, strRow) 'La cantidad de días debe ser mayor a cero y menor a 32
          Exit Function
        End If
      Case KI_HORAXMES
        If Val(Cell.Value) <= 0 Or Val(Cell.Value) > 740 Then
          MsgInfo LNGGetText(4515, vbNullString, strRow) 'La cantidad de horas debe ser mayor a cero y menor a 740
          Exit Function
        End If
      Case KI_DESDE
        If Cell.Value <= #1/1/2004# Or Cell.Value > #1/1/2100# Then
          MsgInfo LNGGetText(4650, vbNullString, strRow) 'La fecha desde debe estar en el rango de 1-1-2004 al 1-1-2100
          Exit Function
        End If
      Case KI_HASTA
        If Cell.Value <= #1/1/2004# Or Cell.Value > #1/1/2100# Then
          MsgInfo LNGGetText(4651, vbNullString, strRow) 'La fecha desde debe estar en el rango de 1-1-2004 al 1-1-2100
          Exit Function
        End If
    End Select
  Next
  
  pValidateRowItems = True
  
End Function

Private Function pLoadItems(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "select s.*,sindca_nombre" & _
            " from SindicatoConvenioCategoria s inner join SindicatoCategoria sindca on s.sindca_id = sindca.sindca_id" & _
            " where sindco_id = " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, _
                    rs, _
                    csRsStatic, _
                    csLockReadOnly, _
                    csCmdText, _
                    "pLoadItems", _
                    C_Module) Then Exit Function
  
  With Propiedad.Grid
    
    With .Columns
      
      .Clear
      
      With .Add(Nothing)
        .Visible = False
        .Key = KI_SINDCC_ID
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1120, vbNullString) 'Categoría
        .PropertyType = cspHelp
        .Table = csSindicatoCategoria
        .Width = 2500
        .Key = KI_SINDCA_ID
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1228, vbNullString) 'Importe
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Width = 2500
        .Key = KI_IMPORTE
        .Format = m_GeneralConfig.FormatDecCotizacion
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1223, vbNullString) 'Tipo
        .PropertyType = cspList
        With .List
          With .Add(Nothing)
            .Id = csETL_Jornalizado
            .Value = LNGGetText(4509, vbNullString) 'Jornalizado
          End With
          With .Add(Nothing)
            .Id = csETL_Mensualizado
            .Value = LNGGetText(4510, vbNullString) 'Mensualizado
          End With
        End With
        .Width = 1000
        .Key = KI_TIPO
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(4512, vbNullString) ' Dias por mes
        .PropertyType = cspNumeric
        .SubType = cspInteger
        .Width = 800
        .Key = KI_DIAXMES
        .Format = "0"
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(4511, vbNullString) ' Horas por mes
        .PropertyType = cspNumeric
        .SubType = cspInteger
        .Width = 800
        .Key = KI_HORAXMES
        .Format = "0"
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(2532, vbNullString) ' Desde
        .PropertyType = cspDate
        .Width = 800
        .Key = KI_DESDE
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(2533, vbNullString) ' Hasta
        .PropertyType = cspDate
        .Width = 800
        .Key = KI_HASTA
      End With
      
    End With
    
    With .Rows
      
      .Clear
      
      While Not rs.EOF
      
        With .Add(Nothing, rs(cscSindccId).Value)
        
          With .Add(Nothing)
            .Value = rs(cscSindccId).Value
            .Key = KI_SINDCC_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscSindcaNombre)
            .Id = gDB.ValField(rs.fields, cscSindcaId)
            .Key = KI_SINDCA_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscSindccImporte)
            .Key = KI_IMPORTE
          End With
          
          With .Add(Nothing)
            .Id = gDB.ValField(rs.fields, cscSindccTipo)
            .Key = KI_TIPO
          End With
         
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscSindccDiaXmes)
            .Key = KI_DIAXMES
          End With
         
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscSindccHoraXmes)
            .Key = KI_HORAXMES
          End With
         
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscSindccDesde)
            .Key = KI_DESDE
          End With
         
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscSindccHasta)
            .Key = KI_HASTA
          End With
         
         End With
         
        rs.MoveNext
      Wend
    
    End With
    
  End With
  
  pLoadItems = True

End Function

Private Function pSaveItems() As Boolean
  Dim register As cRegister
  Dim Row  As cIABMGridRow
  Dim Cell As cIABMGridCellValue
  
  With m_ObjAbm.Properties.Item(c_Items).Grid
          
    For Each Row In .Rows
    
      Set register = New cRegister
      With register
        .fieldId = cscSindccId
        .Table = csTSindicatoConvenioCategoria
        .Id = csNew
        
        For Each Cell In Row
          Select Case Cell.Key
            
            Case KI_SINDCC_ID
              If Not m_Copy Then
                .Id = Val(Cell.Value)
              End If
  
            Case KI_SINDCA_ID
              .fields.Add2 cscSindcaId, Cell.Id, csId
            Case KI_IMPORTE
              .fields.Add2 cscSindccImporte, Cell.Value, csDouble
            Case KI_TIPO
              .fields.Add2 cscSindccTipo, Cell.Id, csInteger
            Case KI_HORAXMES
              .fields.Add2 cscSindccHoraXmes, Cell.Value, csInteger
            Case KI_DIAXMES
              .fields.Add2 cscSindccDiaXmes, Cell.Value, csInteger
            Case KI_DESDE
              .fields.Add2 cscSindccDesde, Cell.Value, csDate
            Case KI_HASTA
              .fields.Add2 cscSindccHasta, Cell.Value, csDate
          End Select
        Next
        
        .fields.Add2 cscSindId, pGetSindicato().HelpId, csId
        .fields.Add2 cscSindcoId, m_Id, csId
        
        .fields.HaveLastUpdate = False
        .fields.HaveWhoModify = False
      End With
      
      If Not gDB.Save(register, , C_pSaveItemsFunc, C_Module, c_ErrorSave) Then Exit Function
    Next
  End With
  
  Dim sqlstmt As String
  
  If LenB(m_ItemsDeletedItems) And Not m_Copy Then
    m_ItemsDeletedItems = RemoveLastColon(m_ItemsDeletedItems)
    sqlstmt = "delete SindicatoConvenioCategoria where sindcc_id in (" & m_ItemsDeletedItems & ")"
  
    If Not gDB.Execute(sqlstmt, C_pSaveItemsFunc, C_Module) Then Exit Function
  End If
  
  pSaveItems = True
End Function

Private Function pGetSindicato() As cIABMProperty
  Set pGetSindicato = m_ObjAbm.Properties.Item(cscSindId)
End Function

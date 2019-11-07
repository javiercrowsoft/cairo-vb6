VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cLenguaje"
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
' cLenguaje
' 24-12-03

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cLenguaje"

Private Const c_Items = "Items"
Private Const c_Filter = "filter"
Private Const c_Top = "top"

Private Const K_NOMBRE                          As Integer = 1
Private Const K_CODIGO                          As Integer = 2
Private Const K_DESCRIP                         As Integer = 3
Private Const K_ID_PADRE                        As Integer = 4
Private Const K_ACTIVO                          As Integer = 5
Private Const K_ITEMS                           As Integer = 6
Private Const K_CMD_FILTER                      As Integer = 7
Private Const K_FILTER                          As Integer = 8
Private Const K_TOP                             As Integer = 9

Private Const KI_LENGI_ID                       As Integer = 1
Private Const KI_CODIGO                         As Integer = 2
Private Const KI_TEXTO                          As Integer = 4

' estructuras
' Seudo - Variables
Private c_ErrorSave                    As String

' variables privadas
Private m_Id                           As Long
Private m_Nombre                       As String
Private m_Codigo                       As String
Private m_Descrip                      As String
Private m_Padre                        As String
Private m_Id_Padre                     As Long
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

Private m_Host As CSMenu.cIMenuHost

Private m_ItemsDeletedItems            As String

Private m_MaxCodigo         As Long

Private m_WasChanged        As Boolean

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

  Doc.ClientTable = csTLenguaje
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
  
  With m_ObjAbm.Properties(cscLengCodigo)
    .Value = C_C & .Value
  End With
  
  With m_ObjAbm.Properties(cscLengNombre)
    .Value = C_CopiaDe & .Value
  End With
  
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscLengCodigo)
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscLengNombre)
  
  m_Copy = True
End Function

Private Function cIABMClient_ListAdHock(List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClient_Load()

End Sub

Private Function cIABMClient_PropertyChange(ByVal Key As Integer) As Boolean

  With m_ObjAbm.Properties
    Select Case Key
      
      Case K_CMD_FILTER, K_TOP
        pShowItems
    End Select
  End With

End Function

Private Sub pShowItems()
  
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  
  If AbmObj.InSave Then Exit Sub
  
  If m_WasChanged Then
    If Not Ask(LNGGetText(1086, vbNullString), vbNo) Then Exit Sub
  End If
  
  Dim iProp As cIABMProperty
  Set iProp = m_ObjAbm.Properties.Item(c_Items)
  pLoadItems iProp
  m_ObjAbm.ShowValue iProp
End Sub

Private Function cIABMClient_Save() As Boolean
  Dim register As cRegister
  Dim fields   As cFields
  Dim LastId   As Long
  
  Set register = New cRegister
  
  With register
    Set fields = .fields
    .fieldId = cscLengId
    .Table = csTLenguaje
  
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
          fields.Add2 cscLengNombre, .Value, csText
        Case K_CODIGO
          fields.Add2 cscLengCodigo, .Value, csText
        Case K_DESCRIP
          fields.Add2 cscLengDescrip, .Value, csText
        Case K_ID_PADRE
          fields.Add2 cscLengIdpadre, .HelpId, csId
        Case K_ACTIVO
          fields.Add2 cscActivo, .Value, csBoolean
      End Select
    End With
  Next
  
  fields.HaveLastUpdate = True
  fields.HaveWhoModify = True
  
  If Not register.BeginTrans(gDB) Then Exit Function
  
  If Not gDB.SaveEx(register, , _
                    cscLengCodigo, _
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
    cIABMClient_Title = LNGGetText(1006, vbNullString)
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
      End Select
    End With
  Next

  cIABMClient_Validate = True
End Function

Private Function cIABMClientGrid_ColumnAfterUpdate(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long) As Boolean
  Select Case Key
    Case K_ITEMS
      m_WasChanged = True
  End Select
  cIABMClientGrid_ColumnAfterUpdate = True
End Function

Private Sub cIABMClientGrid_ColumnClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Sub cIABMClientGrid_DblClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Function cIABMClientGrid_IsEmptyRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_ITEMS
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowItems(Row, RowIndex)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_IsEmptyRow", C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
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
    cIEditGeneric_ShowList = SecurityCanAccess(csPreLengListLenguaje)
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
    If Not SecurityCanAccess(csPreLengDeleteLenguaje) Then Exit Function

    Dim sqlstmt As String
    
    sqlstmt = "delete LenguajeItem where leng_id = " & Id & _
              " delete Lenguaje where leng_id = " & Id
    
    cIEditGeneric_Delete = gDB.Execute(sqlstmt, "cIEditGeneric_Delete", C_Module)
End Function

Private Function cIEditGeneric_Search(Id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Id = csNO_ID Then
      m_IsNew = True
      If Not SecurityCanAccess(csPreLengNewLenguaje) Then Exit Function
  Else
      m_IsNew = False
      If Not SecurityCanAccess(csPreLengEditLenguaje) Then Exit Function
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
  MngError Err, "cIEditGeneric_Edit", C_Module, vbNullString
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

  Dim str_1001 As String

  str_1001 = LNGGetText(1001, vbNullString)

  Set m_Host = Host
  m_Host.Server.AddMenu str_1001, csMenuConfig, C_MenuConfig, 0, True, False, True, False, True, Nothing
                                  '"&Lenguajes"
  m_Host.Server.AddMenu str_1001, csPreLengListLenguaje, str_1001, 0, True, False, False, False, False, Me

  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, "cIMenuClient_Initialize", C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal Id As Long) As Variant
  m_Host.MenuABMClick "CSLenguaje2.cLenguaje", Me, LNGGetText(1006, vbNullString), 0, csETablesLenguaje.csTblLenguaje
End Function

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
  
  Id = Val(pCell(Row, KI_LENGI_ID).Value)
  
  If Id <> csNO_ID Then m_ItemsDeletedItems = m_ItemsDeletedItems & Id & ","
  
  cIABMClientGrid_DeleteRow = True
End Function

Private Function cIABMClientGrid_ListAdHock(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal ColIndex As Long, List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClientGrid_NewRow(ByVal Key As Integer, ByVal Rows As Integer)

End Sub

Private Function cIABMClientGrid_ValidateRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_ITEMS
      cIABMClientGrid_ValidateRow = pValidateRowItems(Row, RowIndex)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ValidateRow", C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

' funciones privadas
Private Function pSaveItems() As Boolean
  Dim register    As cRegister
  Dim Row         As cIABMGridRow
  Dim Cell        As cIABMGridCellValue
  
  Set register = New cRegister
  
  With register
    .fieldId = csclengiId
    .Table = csTLenguajeItem
      
    .fields.HaveLastUpdate = True
    .fields.HaveWhoModify = True
  
    For Each Row In m_ObjAbm.Properties.Item(c_Items).Grid.Rows
      
      .Id = csNew
      
      With .fields
      
        .Clear
        
        For Each Cell In Row
          Select Case Cell.Key
            Case KI_LENGI_ID
              If Not m_Copy Then
                register.Id = Val(Cell.Value)
              End If
            Case KI_CODIGO
              .Add2 csclengiCodigo, Cell.Value, csText
            Case KI_TEXTO
              .Add2 csclengiTexto, Cell.Value, csText
          End Select
        Next
      
        .Add2 cscLengId, m_Id, csId
      
      End With
      If Not gDB.Save(register, , _
                      "pSaveItems", _
                      C_Module, _
                      c_ErrorSave) Then Exit Function
    Next
  End With
  
  Dim sqlstmt As String
  
  If LenB(m_ItemsDeletedItems) And Not m_Copy Then
  
    m_ItemsDeletedItems = RemoveLastColon(m_ItemsDeletedItems)
    sqlstmt = "delete lenguajeItem where lengi_id in (" & m_ItemsDeletedItems & ")"
  
    If Not gDB.Execute(sqlstmt, "pSaveItems", C_Module) Then Exit Function
  End If
  
  pSaveItems = True
End Function

Private Function LoadCollection() As Boolean
  Dim c As cIABMProperty
  Dim iProp As cABMProperty
  
  With m_ObjAbm.Tabs
    .Clear
      
    With .Add(Nothing)
      .Name = C_strGeneral
    End With
  
    With .Add(Nothing)
      .Index = 1
      .Name = c_Items
    End With
    
  End With
      
  With m_ObjAbm.Properties
    
    .Clear

    With .Add(Nothing, cscLengNombre)
      .PropertyType = cspText
      .Name = C_strNombre
      .Size = 100
      .Key = K_NOMBRE
      .Value = m_Nombre
      .Width = 6500
    End With
  
    With .Add(Nothing, cscLengCodigo)
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
    
    With .Add(Nothing, cscLengIdpadre)
      .PropertyType = cspHelp
      .Table = csTblLenguaje
      .Name = LNGGetText(1002, vbNullString) '"Lenguaje Padre"
      .Key = K_ID_PADRE
      .Value = m_Padre
      .HelpId = m_Id_Padre
      .HelpFilter = "IsNull(leng_id_padre,0) <> " & m_Id & " and leng_id <> " & m_Id
    End With
  
    With .Add(Nothing, cscLengDescrip)
      .PropertyType = cspText
      .SubType = cspMemo
      .Name = C_strDescrip
      .Size = 255
      .Width = 6500
      .Height = 880
      .Key = K_DESCRIP
      .Value = m_Descrip
    End With
  
    Set c = .Add(Nothing, c_Filter)
    With c
      .Name = LNGGetText(2826, vbNullString) 'Filtro
      .PropertyType = cspText
      .TabIndex = 1
      Set iProp = c
      iProp.IsEditProperty = False
      .Key = K_FILTER
    End With
        
    With .Add(Nothing)
      .PropertyType = cspButton
      .TopFromProperty = c_Filter
      .Left = 4000
      .LeftNotChange = True
      .TopNotChange = True
      .LeftLabel = -1
      .Name = LNGGetText(3432, vbNullString) 'Filtrar
      .TabIndex = 1
      .Key = K_CMD_FILTER
    End With
    
    Set c = .Add(Nothing, c_Top)
    With c
      .PropertyType = cspCheck
      .Name = LNGGetText(3479, vbNullString) 'Top 50
      .TopFromProperty = c_Filter
      .Left = 7500
      .LeftNotChange = True
      .TopNotChange = True
      .LeftLabel = -800
      .TabIndex = 1
      .Key = K_TOP
      .Value = -1
      Set iProp = c
      iProp.IsEditProperty = False
    End With
    
    Set c = .Add(Nothing, c_Items)
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      If Not pLoadItems(c) Then Exit Function
      .Name = c_Items
      .Key = K_ITEMS
      .TabIndex = 1
      .Top = 1500
      .Left = 200
      .GridAdd = True
      .GridEdit = True
      .GridRemove = True
    End With
    
  End With
  
  m_ItemsDeletedItems = vbNullString
  
  m_MaxCodigo = 0
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

Private Function Load(ByVal Id As Long) As Boolean
  Dim sqlstmt As String
  Dim rs As Recordset
  
  sqlstmt = "select Lenguaje.*,L2.leng_nombre as padre " & _
              " from Lenguaje left join Lenguaje L2 on Lenguaje.leng_id_padre = L2.leng_id" & _
              " where Lenguaje.leng_id = " & Id

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "Load", C_Module) Then Exit Function

  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.fields, cscLengId)
    m_Nombre = gDB.ValField(rs.fields, cscLengNombre)
    m_Codigo = gDB.ValField(rs.fields, cscLengCodigo)
    m_Descrip = gDB.ValField(rs.fields, cscLengDescrip)
    m_Id_Padre = gDB.ValField(rs.fields, cscLengIdpadre)
    m_Padre = gDB.ValField(rs.fields, "padre")
    m_Creado = gDB.ValField(rs.fields, cscCreado)
    m_Modificado = gDB.ValField(rs.fields, cscModificado)
    m_Modifico = gDB.ValField(rs.fields, cscModifico)
    m_Activo = gDB.ValField(rs.fields, cscActivo)

  Else
    
    m_Id = csNO_ID
    m_Nombre = vbNullString
    m_Codigo = vbNullString
    m_Descrip = vbNullString
    m_Id_Padre = csNO_ID
    m_Padre = vbNullString
    m_Creado = csNoDate
    m_Modificado = csNoDate
    m_Modifico = 0
    m_Activo = True
    
  End If

  m_MaxCodigo = 0

  Load = True
End Function

Private Function pIsEmptyRowItems(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim bRowIsEmpty           As Boolean
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_CODIGO
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KI_TEXTO
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowItems = bRowIsEmpty
End Function

Private Function pValidateRowItems(Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell   As cIABMGridCellValue
  Dim strRow As String
  Dim Codigo As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.Key
        Case KI_CODIGO
          If ValEmpty(Cell.Value, csText) Then
          
                  ' "No ha indicado un código" & strRow & ";;¿Desea que el sistema le sugiera el proximo numero a usar?"
                  '
            If Ask(LNGGetText(1003, vbNullString, strRow), vbYes) Then
            
              If Not pItemCodigoGet(Codigo) Then Exit Function
              Cell.Value = Codigo
            Else
              Exit Function
            End If
          End If
        Case KI_TEXTO
          If ValEmpty(Cell.Value, csText) Then
                                    ' Debe indicar un texto
            MsgInfo LNGGetText(1004, vbNullString, strRow)
            Exit Function
          End If
    End Select
  Next
  
  pValidateRowItems = True
End Function

Private Function pLoadItems(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  Dim rs As ADODB.Recordset
  
  m_WasChanged = False
  
  Dim filter As String
  
  With m_ObjAbm.Properties
    filter = .Item(c_Filter).Value
    sqlstmt = "select " & IIf(Val(.Item(c_Top).Value), "top 50 ", vbNullString) & "* from LenguajeItem where leng_id = " & m_Id
  End With
  
  If LenB(filter) Then
  
    filter = gDB.sqlString(filter)
  
    sqlstmt = sqlstmt & _
              " and (lengi_texto like " & filter & _
              " or lengi_codigo like " & filter & ")"
  End If
  
  sqlstmt = sqlstmt & " order by lengi_texto"
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadItems", C_Module) Then Exit Function
  
  With Propiedad.Grid
  
    With .Columns
    
      .Clear
    
      With .Add(Nothing)
        .Visible = False
        .Key = KI_LENGI_ID
      End With
  
      With .Add(Nothing)
        .Name = C_strCodigo
        .PropertyType = cspText
        .Width = 3500
        .Key = KI_CODIGO
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1005, vbNullString)
        .PropertyType = cspText
        .SubType = cspTextButtonEx
        .Width = 1200
        .Key = KI_TEXTO
      End With
    
    End With
    
    With .Rows
      
      .Clear
      
      While Not rs.EOF
      
        With .Add(Nothing, rs(csclengiId).Value)
        
          With .Add(Nothing)
            .Value = rs(csclengiId).Value
            .Key = KI_LENGI_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, csclengiCodigo)
            .Key = KI_CODIGO
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, csclengiTexto)
            .Key = KI_TEXTO
          End With
          
        End With
        
        rs.MoveNext
      Wend
    
    End With
  
  End With
  
  pLoadItems = True
End Function

Private Function pItemCodigoGet(ByRef rtn As String) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  If m_MaxCodigo = 0 Then
  
    sqlstmt = "sp_LenguajeItemGetCodigo"
    
    If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
    
    rtn = gDB.ValField(rs.fields, 0)
    
    m_MaxCodigo = Val(rtn)
  
  Else
  
    m_MaxCodigo = m_MaxCodigo + 1
    
    rtn = m_MaxCodigo
    
  End If
  
  pItemCodigoGet = True
End Function

Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  c_ErrorSave = LNGGetText(3433, vbNullString) 'Error al grabar Lenguaje

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


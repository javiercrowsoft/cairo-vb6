VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cImportacionProceso"
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
' cImportacionProceso
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
Private Const C_Module = "cImportacionProceso"

Private Const K_NOMBRE                         As Integer = 1
Private Const K_CODIGO                         As Integer = 2
Private Const K_DESCRIP                        As Integer = 4
Private Const K_ACTIVO                         As Integer = 5
Private Const K_ITEMS                          As Integer = 6

Private Const KI_IMPPI_ID                       As Integer = 2
Private Const KI_OBJETO                         As Integer = 3
Private Const KI_PARAMS                         As Integer = 4
Private Const KI_ULTIMAIMPO                     As Integer = 5

' estructuras
' Seudo - Variables
Private c_ErrorSave          As String

' variables privadas
Private m_Id                           As Long
Private m_Nombre                       As String
Private m_Codigo                       As String
Private m_Descrip                      As String
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

Private m_Host                As CSMenu.cIMenuHost

Private m_ItemsDeletedItems   As String

' Properties publicas
Public Property Get ID() As Long
  ID = m_Id
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

  Doc.ClientTable = csTImportacionProceso
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

  With m_ObjAbm.Properties(cscImppCodigo)
    .Value = "C-" & .Value
  End With
  
  With m_ObjAbm.Properties(cscImppNombre)
    .Value = "Copia de " & .Value
  End With
  
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscImppCodigo)
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscImppNombre)
  
  m_Copy = True
End Function

Private Function cIABMClient_ListAdHock(List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClient_Load()

End Sub

Private Function cIABMClient_PropertyChange(ByVal Key As Integer) As Boolean

End Function

Private Function cIABMClient_Save() As Boolean
  Dim LastId   As Long
  Dim register As cRegister
  
  Set register = New cRegister
  register.fieldId = cscImppId
  register.Table = csTImportacionProceso
  
  If m_Copy Then
    register.ID = csNew
  Else
    register.ID = m_Id
  End If
  
  Dim IProperty As cIABMProperty
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_NOMBRE
          register.Fields.Add2 cscImppNombre, .Value, csText
        Case K_CODIGO
          register.Fields.Add2 cscImppCodigo, .Value, csText
        Case K_DESCRIP
          register.Fields.Add2 cscImppDescrip, .Value, csText
        Case K_ACTIVO
          register.Fields.Add2 cscActivo, .Value, csBoolean

      End Select
    End With
  Next
  
  register.Fields.HaveLastUpdate = True
  register.Fields.HaveWhoModify = True
  
  If Not register.BeginTrans(gDB) Then Exit Function
  
  If Not gDB.Save(register, , "cIABMClient_Save", C_Module, c_ErrorSave) Then Exit Function
  
  LastId = m_Id
  m_Id = register.ID
  
  If Not pSaveItemsItems() Then GoTo SaveError
  
  If Not register.CommitTrans() Then GoTo SaveError
  
  m_Copy = False
  cIABMClient_Save = Load(register.ID)
  
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
  cIABMClient_Title = LNGGetText(3338, vbNullString) 'Procesos de Importación
End Property

Private Function cIABMClient_Validate() As Boolean

  Dim IProperty As cIABMProperty

  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_NOMBRE
          If ValEmpty(.Value, csText) Then
            MsgInfo LNGGetText(1007, vbNullString) 'Debe indicar un nombre
            Exit Function
          End If
        Case K_CODIGO
          If ValEmpty(.Value, csText) Then
            MsgInfo LNGGetText(1008, vbNullString) 'Debe indicar un codigo
            Exit Function
          End If
      End Select
    End With
  Next

  cIABMClient_Validate = True
End Function

' Implementacion de cIABMClientGrid

Private Function cIABMClientGrid_ColumnAfterEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long) As Boolean
  cIABMClientGrid_ColumnAfterEdit = True
End Function

Private Function cIABMClientGrid_ColumnAfterUpdate(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long) As Boolean
  cIABMClientGrid_ColumnAfterUpdate = True
End Function

Private Function cIABMClientGrid_ColumnBeforeEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean
  cIABMClientGrid_ColumnBeforeEdit = True
End Function

Private Sub cIABMClientGrid_ColumnClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Function cIABMClientGrid_ColumnButtonClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean

End Function

Private Sub cIABMClientGrid_ColumnCancelEdit(ByVal Key As Integer)

End Sub

Private Function cIABMClientGrid_DeleteRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal lRow As Long) As Boolean
  Dim ID As Long
  
  ID = Val(pCell(Row, KI_IMPPI_ID).Value)
  
  If ID <> csNO_ID Then m_ItemsDeletedItems = m_ItemsDeletedItems & ID & ","
  
  cIABMClientGrid_DeleteRow = True
End Function

Private Sub cIABMClientGrid_DblClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Function cIABMClientGrid_IsEmptyRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_ITEMS
      cIABMClientGrid_IsEmptyRow = pValidateIsEmptyRowItems(Row, RowIndex)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_IsEmptyRow", C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
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
    cIEditGeneric_ShowList = SecurityCanAccess(csPreImporListImportacionProceso)
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
  If Not SecurityCanAccess(csPreImporDeleteImportacionProceso) Then Exit Function

  Dim sqlstmt As String
  
  sqlstmt = "Delete importacionProcesoItem where impp_id  = " & ID & vbCrLf & _
            "Delete importacionProceso where impp_id = " & ID
  
  cIEditGeneric_Delete = gDB.Execute(sqlstmt, "cIEditGeneric_Delete", C_Module)
End Function

Private Function cIEditGeneric_Search(ID As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(ID As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If ID = csNO_ID Then
    m_IsNew = True
    If Not SecurityCanAccess(csPreImporNewImportacionProceso) Then Exit Function
  Else
    m_IsNew = False
    If Not SecurityCanAccess(csPreImporEditImportacionProceso) Then Exit Function
  End If

' JMA I
  m_ObjAbm.InModalWindow = InModalWindow
' JMA F

  If Not Load(ID) Then Exit Function
  
  If Not LoadCollection() Then Exit Function
  
  m_Editing = True
  m_Copy = False

  m_ObjAbm.InModalWindow = InModalWindow

  Exit Function
ControlError:
  MngError Err, "cIEditGeneric_Edit", C_Module, vbNullString
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

Private Function cIMenuClient_Initialize(f As Object, Host As CSMenu.cIMenuHost) As Boolean
  On Error GoTo ControlError
  Dim str_3335  As String
  
  str_3335 = LNGGetText(3335, vbNullString) 'Impor&tación

  Set m_Host = Host
  m_Host.Server.AddMenu str_3335, csMenuEnum.csMenuImport, vbNullString, 1, False, False, False, True, False, Nothing
  m_Host.Server.AddMenu LNGGetText(3339, vbNullString), csPreImporListImportacionProceso, str_3335, 0, True, False, False, False, False, Me
                          '&Procesos de Importación
  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, "cIMenuClient_Initialize", C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal ID As Long) As Variant
  m_Host.MenuABMClick "CSImport2.cImportacionProceso", Me, LNGGetText(3333, vbNullString), 0, csETablesImport.csImportacionProceso
                                                            'Proceso de Importación
End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  Dim c As cIABMProperty
  
  m_ObjAbm.Properties.Clear
  
  With m_ObjAbm.Tabs
    
    .Clear
    
    With .Add(Nothing)
      .Name = C_strGeneral
    End With
  
    With .Add(Nothing)
      .Index = 1
      .Name = LNGGetText(3340, vbNullString) 'Procesos
    End With
  
  End With

  Set c = m_ObjAbm.Properties.Add(c, cscImppNombre)
  c.PropertyType = cspText
  c.Name = C_strNombre
  c.Size = 100
  c.Width = 4000
  c.Key = K_NOMBRE
  c.Value = m_Nombre
  Set c = Nothing

  Set c = m_ObjAbm.Properties.Add(c, cscImppCodigo)
  c.PropertyType = cspText
  c.Name = C_strCodigo
  c.Size = 15
  c.Key = K_CODIGO
  c.Value = m_Codigo
  Set c = Nothing

  Set c = m_ObjAbm.Properties.Add(c, cscActivo)
  c.PropertyType = cspCheck
  c.Name = C_strActivo
  c.Key = K_ACTIVO
  c.Value = CInt(m_Activo)
  Set c = Nothing

  Set c = m_ObjAbm.Properties.Add(c, cscImppDescrip)
  c.PropertyType = cspText
  c.SubType = cspMemo
  c.Name = C_strDescrip
  c.Size = 255
  c.Width = 6000
  c.Height = 880
  c.Key = K_DESCRIP
  c.Value = m_Descrip
  Set c = Nothing
  
  Set c = m_ObjAbm.Properties.Add(c, "ITEMS")
  c.PropertyType = cspGrid
  c.LeftLabel = -1
  If Not pLoadItems(c) Then Exit Function
  c.Name = "ITEMS"
  c.Key = K_ITEMS
  c.TabIndex = 1
  c.GridAdd = True
  c.GridEdit = True
  c.GridRemove = True
  Set c = Nothing
  
  m_ItemsDeletedItems = vbNullString
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

Private Function Load(ByVal ID As Long) As Boolean

  Dim sqlstmt As String

  sqlstmt = "select * from ImportacionProceso where impp_id = " & ID

  Dim rs As Recordset

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "Load", C_Module) Then Exit Function

  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.Fields, cscImppId)
    m_Nombre = gDB.ValField(rs.Fields, cscImppNombre)
    m_Codigo = gDB.ValField(rs.Fields, cscImppCodigo)
    m_Descrip = gDB.ValField(rs.Fields, cscImppDescrip)
    m_Creado = gDB.ValField(rs.Fields, cscCreado)
    m_Modificado = gDB.ValField(rs.Fields, cscModificado)
    m_Modifico = gDB.ValField(rs.Fields, cscModifico)
    m_Activo = gDB.ValField(rs.Fields, cscActivo)

  Else
    m_Id = csNO_ID
    m_Nombre = vbNullString
    m_Codigo = vbNullString
    m_Descrip = vbNullString
    m_Creado = csNoDate
    m_Modificado = csNoDate
    m_Modifico = 0
    m_Activo = True

  End If

  Load = True
End Function

Private Function pSaveItemsItems() As Boolean
  Dim register As cRegister
  Dim IProperty As cIABMProperty
  
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_ITEMS
        
          Dim Row  As cIABMGridRow
          Dim Cell As cIABMGridCellValue
          
          For Each Row In IProperty.Grid.Rows
          
            Set register = New cRegister
            register.fieldId = cscImppiId
            register.Table = csTImportacionProcesoItem
            register.ID = csNew
            
            For Each Cell In Row
              Select Case Cell.Key
                Case KI_IMPPI_ID
                  If Not m_Copy Then
                    register.ID = Val(Cell.Value)
                  End If
                Case KI_OBJETO
                  register.Fields.Add2 cscImppiObjeto, Cell.Value, csText
                Case KI_PARAMS
                  register.Fields.Add2 cscImppiParams, Cell.Value, csText
                Case KI_ULTIMAIMPO
                  register.Fields.Add2 cscImppiUltimaImpo, Cell.Value, csDate
              End Select
            Next
            
            register.Fields.Add2 cscImppId, m_Id, csId
            
            register.Fields.HaveLastUpdate = True
            register.Fields.HaveWhoModify = True
            
            If Not gDB.Save(register, , "pSaveItemsIems", C_Module, c_ErrorSave) Then Exit Function
          Next
      End Select
    End With
  Next
  
  Dim sqlstmt As String
  
  If LenB(m_ItemsDeletedItems) Then
    m_ItemsDeletedItems = RemoveLastColon(m_ItemsDeletedItems)
    sqlstmt = "delete importacionProcesoItem where imppi_id in (" & m_ItemsDeletedItems & ")"
  
    If Not gDB.Execute(sqlstmt, "pSaveItemsItems", C_Module) Then Exit Function
  End If
  
  pSaveItemsItems = True
End Function

Private Function pLoadItems(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  
  Dim rs As ADODB.Recordset
  
  sqlstmt = "select ImportacionProcesoItem.*" & _
            " from ImportacionProcesoItem" & _
            " where impp_id = " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadItems", C_Module) Then Exit Function
  
  Dim o As cIABMGridColumn
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Visible = False
  o.Key = KI_IMPPI_ID
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = LNGGetText(3341, vbNullString) 'Objeto
  o.PropertyType = cspText
  o.Width = 3500
  o.Key = KI_OBJETO
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = LNGGetText(1817, vbNullString) 'Parametros
  o.PropertyType = cspText
  o.Width = 3500
  o.Key = KI_PARAMS
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = LNGGetText(3342, vbNullString) 'Ultima Importación
  o.PropertyType = cspDate
  o.Width = 2500
  o.Key = KI_ULTIMAIMPO
  
  Dim f  As cIABMGridRow
  Dim fv As cIABMGridCellValue
  
  While Not rs.EOF
  
    Set f = Propiedad.Grid.Rows.Add(Nothing, rs(cscImppiId).Value)
    
    Set fv = f.Add(Nothing)
    fv.Value = rs(cscImppiId).Value
    fv.Key = KI_IMPPI_ID
    
    Set fv = f.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscImppiObjeto)
    fv.Key = KI_OBJETO
    
    Set fv = f.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscImppiParams)
    fv.Key = KI_PARAMS
    
    Set fv = f.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscImppiUltimaImpo)
    fv.Key = KI_ULTIMAIMPO
    
    rs.MoveNext
  Wend
  
  pLoadItems = True
End Function

Private Function pValidateIsEmptyRowItems(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim bRowIsEmpty           As Boolean
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_OBJETO
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pValidateIsEmptyRowItems = bRowIsEmpty
End Function

Private Function pValidateRowItems(Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.Key
        Case KI_OBJETO
          If ValEmpty(Cell.Value, csText) Then
            MsgInfo LNGGetText(3343, vbNullString, strRow) 'Debe indicar un Objeto (1)
            Exit Function
          End If
    End Select
  Next
  
  pValidateRowItems = True
End Function

Private Sub Class_Initialize()
  On Error GoTo ControlError

  c_ErrorSave = LNGGetText(3344, vbNullString) 'Error al grabar el Proceso de Importación

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


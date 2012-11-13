VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cProyecto"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGeneric
Implements CSInterfacesABM.cIABMClient
Implements CSInterfacesABM.cIABMClientGrid
Implements CSMenu.cIMenuClient
'--------------------------------------------------------------------------------
' cProyecto
' 10-08-02

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
  ' constantes
  ' estructuras
  ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cProyecto"

Private Const K_NOMBRE              As Integer = 1
Private Const K_CODIGO              As Integer = 2
Private Const K_DESCRIP             As Integer = 3
Private Const K_DESDE               As Integer = 4
Private Const K_HASTA               As Integer = 5
Private Const K_PROV_ID             As Integer = 6
Private Const K_CLI_ID              As Integer = 7
Private Const K_PR_ID               As Integer = 8
Private Const K_ACTIVO              As Integer = 9
Private Const K_ITEMS               As Integer = 10
Private Const K_OBJETIVOS           As Integer = 11
Private Const K_PRECIOS             As Integer = 12
Private Const K_PROY_ID             As Integer = 13
Private Const K_ESTADO              As Integer = 14
Private Const K_TA_ID               As Integer = 15
Private Const K_LLEVAAPROB          As Integer = 16
Private Const K_FILESIZE            As Integer = 17
Private Const K_PUBLICO             As Integer = 18

Private Const KI_PROYI_ID           As Integer = 1
Private Const KI_NOMBRE             As Integer = 2
Private Const KI_CODIGO             As Integer = 3
Private Const KI_DESCRIP            As Integer = 4
Private Const KI_ACTIVO             As Integer = 6

Private Const KI_OBJE_ID            As Integer = 1

Private Const KI_PROYP_ID           As Integer = 1
Private Const KI_US_ID              As Integer = 2
Private Const KI_PRECIO             As Integer = 3
Private Const KI_PR_ID              As Integer = 4

Private Const KI_PROYEST_ID         As Integer = 1
Private Const KI_ESTADO             As Integer = 2

' Seudo - Variables
Private c_strTitle           As String
Private c_ErrorSave          As String

' estructuras
' variables privadas
Private m_Id                As Long
Private m_Nombre            As String
Private m_Codigo            As String
Private m_Descrip           As String
Private m_Desde             As Date
Private m_Hasta             As Date
Private m_Prov_id           As Long
Private m_Proveedor         As String
Private m_Cli_id            As Long
Private m_Cliente           As String
Private m_pr_id             As Long
Private m_producto          As String
Private m_proy_id_padre     As Long
Private m_ProyectoPadre     As String
Private m_Ta_id             As Long
Private m_Talonario         As String
Private m_Modificado        As Date
Private m_Creado            As Date
Private m_llevaAprob        As Integer
Private m_FileSize          As Integer
Private m_Publico           As Boolean

Private m_Activo            As Integer
Private m_Modifico          As Long


Private m_Editing                           As Boolean

Private m_ObjAbm                            As cIABMGeneric
Private m_ObjTree                           As Object

Private m_IsNew                             As Boolean

Private m_BranchId                          As Long
Private m_TreeId                            As Long

Private m_Host                              As CSMenu.cIMenuHost

Private m_ItemsDeletedItems                 As String
Private m_ItemsDeletedObjetivos             As String
Private m_ItemsDeletedPrecios               As String
Private m_ItemsDeletedEstados               As String
Private m_Copy                              As Boolean

Private m_GeneralConfig     As cGeneralConfig

' propiedades publicas

' JMA I
Public Property Get Id() As Long
  Id = m_Id
End Property

Public Property Get Nombre() As String
  Nombre = m_Nombre
End Property

Public Property Get Codigo() As String
  Codigo = m_Codigo
End Property
' JMA F

' propiedades privadas
' funciones publicas

' Implementacion de cIABMClient
Private Function cIABMClient_Copy() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True
  
  With m_ObjAbm.Properties(cscProyCodigo)
    .Value = "C-" & .Value
  End With
  
  With m_ObjAbm.Properties(cscProyNombre)
    .Value = C_CopiaDe & .Value
  End With
  
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscProyCodigo)
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscProyNombre)
  
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

  Doc.ClientTable = csTProyecto
  Doc.ClientTableID = m_Id

  cIABMClient_ShowDocDigital = Doc.ShowDocs(gDB)

  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClient_ShowDocDigital", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIABMClient_MessageEx(ByVal MessageID As Long, ByVal Info As Variant) As Variant
  cIABMClient_MessageEx = True
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
  Dim register   As cRegister
  Dim fields     As cFields
  
  Set register = New cRegister
  Set fields = register.fields
  
  With register
    .fieldId = cscProyId
    .Table = csTProyecto
  
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
          fields.Add2 cscProyNombre, .Value, csText
        Case K_CODIGO
          fields.Add2 cscProyCodigo, .Value, csText
        Case K_DESCRIP
          fields.Add2 cscProyDescrip, .Value, csText
        Case K_DESDE
          fields.Add2 cscProyDesde, .Value, csDate
        Case K_HASTA
          fields.Add2 cscProyHasta, .Value, csDate
        Case K_PROV_ID
          fields.Add2 cscProvId, .HelpId, csId
        Case K_CLI_ID
          fields.Add2 cscCliId, .HelpId, csId
        Case K_PR_ID
          fields.Add2 cscPrId, .HelpId, csId
        Case K_PROY_ID
          fields.Add2 cscProyIdPadre, .HelpId, csId
        Case K_TA_ID
          fields.Add2 cscTaId, .HelpId, csId
        Case K_LLEVAAPROB
          fields.Add2 cscProyLlevaAprobacion, .Value, csBoolean
        Case K_FILESIZE
          fields.Add2 cscProyFileSize, .Value, csInteger
        Case K_PUBLICO
          fields.Add2 cscProyPublico, .Value, csBoolean
        Case K_ACTIVO
          fields.Add2 cscActivo, .Value, csBoolean
      End Select
    End With
  Next
  
  If m_IsNew Then
    fields.Add2 cscUsIdalta, User.Id, csId
  End If
  
  fields.HaveLastUpdate = True
  fields.HaveWhoModify = True
  
  If Not register.BeginTrans(gDB) Then Exit Function
  
  If Not gDB.Save(register, , "cIABMClient_Save", C_Module, c_ErrorSave) Then Exit Function
  
  If Not pSaveItemsItems(register.Id) Then Exit Function
  If Not pSaveItemsObjetivos(register.Id) Then Exit Function
  If Not pSaveItemsPrecios(register.Id) Then Exit Function
  If Not pSaveItemsEstado(register.Id) Then Exit Function
  If Not pSavePrestacion(register.Id) Then Exit Function
  
  If Not register.CommitTrans() Then Exit Function
  
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
  cIABMClient_Title = c_strTitle
End Property

Private Function cIABMClient_Validate() As Boolean

  Dim IProperty As cIABMProperty
  
  CSKernelClient2.Title = c_strTitle

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
            MsgInfo LNGGetText(1008, vbNullString) 'Debe indicar un código
            Exit Function
          End If
        Case K_DESDE
          If ValEmpty(.Value, csDate) Then
            MsgInfo LNGGetText(2393, vbNullString) 'Debe indicar una fecha desde
            Exit Function
          End If
        Case K_HASTA
          If ValEmpty(.Value, csDate) Then
            MsgInfo LNGGetText(2394, vbNullString) 'Debe indicar una fecha hasta
            Exit Function
          End If
      End Select
    End With
  Next

  cIABMClient_Validate = True
End Function

Private Function cIABMClientGrid_IsEmptyRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_OBJETIVOS
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowObjetivos(Row, RowIndex)
    Case K_ITEMS
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowItems(Row, RowIndex)
    Case K_PRECIOS
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowPrecios(Row, RowIndex)
    Case K_ESTADO
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowEstados(Row, RowIndex)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ValidateRow", C_Module, vbNullString
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
  cIEditGeneric_ShowList = SecurityCanAccess(csPreTareaListProyecto)
End Function

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
  Set m_ObjAbm = rhs
End Property

Private Property Get cIEditGeneric_Editing() As Boolean
  cIEditGeneric_Editing = m_Editing
End Property

Private Function cIEditGeneric_Delete(Id As Long) As Boolean
  If Not SecurityCanAccess(csPreTareaDeleteProyecto) Then Exit Function

  Dim sqlstmt As String
  
  sqlstmt = "sp_ProyectoDelete " & Id
  
  If gDB.Execute(sqlstmt, "cIEditGeneric_Delete", C_Module) Then Exit Function
  
  cIEditGeneric_Delete = True
End Function

Private Function cIEditGeneric_Search(Id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Id = csNO_ID Then
    m_IsNew = True
    If Not SecurityCanAccess(csPreTareaNewProyecto) Then Exit Function
  Else
    m_IsNew = False
    If Not SecurityCanAccess(csPreTareaEditProyecto) Then Exit Function
  End If

  ' JMA I
  m_ObjAbm.InModalWindow = InModalWindow
' JMA F
  
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

' ----------------------
' Interfaz cIMenuClient

Private Function cIMenuClient_Initialize(F As Object, Host As CSMenu.cIMenuHost) As Boolean
  On Error GoTo ControlError
  Dim str_1851 As String
  
  str_1851 = LNGGetText(1851, vbNullString) '&Servicios
  Set m_Host = Host
                                                'Co&nfiguración
  m_Host.Server.AddMenu str_1851, csMenuConfig, LNGGetText(1028, vbNullString), 0, True, False, True, False, True, Nothing
  m_Host.Server.AddMenu LNGGetText(2662, vbNullString), csPreTareaListProyecto, str_1851, 0, True, False, False, False, False, Me
                          '&Proyecto/Grupos/Contratos
  cIMenuClient_Initialize = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIMenuClient_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal Id As Long) As Variant
  m_Host.MenuABMClick "CSTarea2.cProyecto", Me, c_strTitle, 0, csETablesTask.csProyecto
End Function

' Grid
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

Private Sub cIABMClientGrid_ColumnClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Sub cIABMClientGrid_DblClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Function cIABMClientGrid_DeleteRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal lRow As Long) As Boolean
  Dim Id As Long
  
  If Key = K_ITEMS Then
    Id = Val(pCell(Row, KI_PROYI_ID).Value)
    
    If Id <> csNO_ID Then m_ItemsDeletedItems = m_ItemsDeletedItems & Id & ","
    
    cIABMClientGrid_DeleteRow = True
  
  ElseIf Key = K_OBJETIVOS Then
    Id = Val(pCell(Row, KI_OBJE_ID).Value)
    
    If Id <> csNO_ID Then m_ItemsDeletedObjetivos = m_ItemsDeletedObjetivos & Id & ","
  
    cIABMClientGrid_DeleteRow = True
  
  ElseIf Key = K_ESTADO Then
    Id = Val(pCell(Row, KI_OBJE_ID).Value)
    
    If Id <> csNO_ID Then m_ItemsDeletedEstados = m_ItemsDeletedEstados & Id & ","
  
    cIABMClientGrid_DeleteRow = True
  
  ElseIf Key = K_PRECIOS Then
    Id = Val(pCell(Row, KI_PROYP_ID).Value)
    
    If Id <> csNO_ID Then m_ItemsDeletedPrecios = m_ItemsDeletedPrecios & Id & ","
  
    cIABMClientGrid_DeleteRow = True
  End If
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
    Case K_OBJETIVOS
      cIABMClientGrid_ValidateRow = pValidateRowObjetivos(Row, RowIndex)
    Case K_PRECIOS
      cIABMClientGrid_ValidateRow = pValidateRowPrecios(Row, RowIndex)
    Case K_ESTADO
      cIABMClientGrid_ValidateRow = pValidateRowEstados(Row, RowIndex)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ValidateRow", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIABMClientGrid_ColumnAfterUpdate(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long) As Boolean
  cIABMClientGrid_ColumnAfterUpdate = True
End Function

Private Function pValidateRowObjetivos(Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_NOMBRE
        If ValEmpty(Cell.Value, csText) Then
          MsgInfo LNGGetText(1811, vbNullString, strRow) 'Debe indicar un nombre (1)
          Exit Function
        End If
      Case KI_CODIGO
        If ValEmpty(Cell.Value, csText) Then
          MsgInfo LNGGetText(1526, vbNullString, strRow) 'Debe indicar un código (1)
          Exit Function
        End If
    End Select
  Next
  
  pValidateRowObjetivos = True
  
End Function

Private Function pValidateRowEstados(Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_ESTADO
        If ValEmpty(Cell.Value, csText) Then
          MsgInfo LNGGetText(2663, vbNullString, strRow) 'Debe indicar un estado (1)
          Exit Function
        End If
    End Select
  Next
  
  pValidateRowEstados = True
  
End Function

Private Function pValidateRowPrecios(Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_US_ID
        If ValEmpty(Cell.Id, csId) Then
          MsgInfo LNGGetText(1153, vbNullString, strRow) 'Debe indicar un usuario (1)
          Exit Function
        End If
      Case KI_PRECIO
        If ValEmpty(Cell.Value, csDouble) Then
          MsgInfo LNGGetText(1897, vbNullString, strRow) 'Debe indicar un importe (1)
          Exit Function
        End If
    End Select
  Next
  
  pValidateRowPrecios = True
  
End Function

Private Function pValidateRowItems(Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_NOMBRE
        If ValEmpty(Cell.Value, csText) Then
          MsgInfo LNGGetText(1811, vbNullString, strRow) 'Debe indicar un nombre (1)
          Exit Function
        End If
      Case KI_CODIGO
        If ValEmpty(Cell.Value, csText) Then
          MsgInfo LNGGetText(1526, vbNullString, strRow) 'Debe indicar un código (1)
          Exit Function
        End If
    End Select
  Next
  
  pValidateRowItems = True
End Function

'-----------------------
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
      .Name = LNGGetText(2664, vbNullString) 'Sub Proyectos
    End With
    
    With .Add(Nothing)
      .Index = 2
      .Name = LNGGetText(2665, vbNullString) 'Objetivos
    End With
    
    With .Add(Nothing)
      .Index = 3
      .Name = LNGGetText(2666, vbNullString) 'Precios
    End With
    
    With .Add(Nothing)
      .Index = 4
      .Name = LNGGetText(2667, vbNullString) 'Estados
    End With
  
  End With
  
  With m_ObjAbm.Properties
    .Clear
  
    With .Add(Nothing, cscProyNombre)
      .PropertyType = cspText
      .Name = C_strNombre
      .Size = 50
      .Key = K_NOMBRE
      .Value = m_Nombre
    End With
    
    With .Add(Nothing, cscProyCodigo)
      .PropertyType = cspText
      .Name = C_strCodigo
      .Size = 20
      .Key = K_CODIGO
      .Value = m_Codigo
    End With
    
    With .Add(Nothing, cscActivo)
      .PropertyType = cspCheck
      .Name = C_strActivo
      .Key = K_ACTIVO
      .Value = m_Activo
    End With
    
    With .Add(Nothing, cscProyLlevaAprobacion)
      .PropertyType = cspCheck
      .Name = LNGGetText(2668, vbNullString) 'Requiere Aprobación
      .Key = K_LLEVAAPROB
      .Value = m_llevaAprob
    End With
    
    With .Add(Nothing, cscProyPublico)
      .PropertyType = cspCheck
      .Name = LNGGetText(3062, vbNullString) 'Publico
      .Key = K_PUBLICO
      .Value = CInt(m_Publico)
    End With
    
    With .Add(Nothing, cscProyDesde)
      .PropertyType = cspDate
      .Name = LNGGetText(2669, vbNullString) 'Vigente desde
      .Key = K_DESDE
      .Value = m_Desde
    End With
    
    With .Add(Nothing, cscProyHasta)
      .PropertyType = cspDate
      .Name = LNGGetText(2670, vbNullString) 'Vigente hasta
      .Key = K_HASTA
      .Value = m_Hasta
    End With
        
    With .Add(Nothing, cscProvId)
      .PropertyType = cspHelp
      .TopFromProperty = cscProyNombre
      .Left = 5500
      .Table = csProveedor
      .Name = LNGGetText(1151, vbNullString) 'Proveedor
      .Key = K_PROV_ID
      .Value = m_Proveedor
      .HelpId = m_Prov_id
    End With
    
    With .Add(Nothing, cscCliId)
      .PropertyType = cspHelp
      .Table = csCliente
      .Name = LNGGetText(1150, vbNullString) 'Cliente
      .Key = K_CLI_ID
      .Value = m_Cliente
      .HelpId = m_Cli_id
    End With
    
    With .Add(Nothing, cscPrId)
      .PropertyType = cspHelp
      .Table = csProductoVenta
      .Name = LNGGetText(1367, vbNullString) 'Articulo
      .Key = K_PR_ID
      .Value = m_producto
      .HelpId = m_pr_id
    End With
    
    With .Add(Nothing, cscProyIdPadre)
      .PropertyType = cspHelp
      .Table = csProyecto
      .Name = LNGGetText(2671, vbNullString) 'Proyecto Padre
      .Key = K_PROY_ID
      .Value = m_ProyectoPadre
      .HelpId = m_proy_id_padre
      .HelpFilter = "'proy_id <> " & m_Id & "'"
    End With
    
    With .Add(Nothing, cscTaId)
      .PropertyType = cspHelp
      .Table = csTalonario
      .Name = LNGGetText(1256, vbNullString) 'Talonario
      .Key = K_TA_ID
      .Value = m_Talonario
      .HelpId = m_Ta_id
    End With
  
    With .Add(Nothing, cscProyFileSize)
      .PropertyType = cspNumeric
      .SubType = cspInteger
      .Name = LNGGetText(2672, vbNullString) 'Tamaño Máximo en Datos Adjuntos
      .Key = K_FILESIZE
      .Value = m_FileSize
    End With
    
    With .Add(Nothing, cscProyDescrip)
      .PropertyType = cspText
      .SubType = cspMemo
      .Name = C_strDescrip
      .TopFromProperty = cscProyHasta
      .TopToPrevious = 440
      .LeftFromProperty = cscProyNombre
      .Size = 255
      .Height = 800
      .Width = 6000
      .Key = K_DESCRIP
      .Value = m_Descrip
    End With
  
    Set c = .Add(Nothing, "Items")
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      If Not pLoadItems(c) Then Exit Function
      .Name = "Items"
      .Key = K_ITEMS
      .TabIndex = 1
      .GridAdd = True
      .GridEdit = True
      .GridRemove = True
    End With
    
    m_ItemsDeletedItems = vbNullString
  
    Set c = .Add(Nothing, "Objetivos")
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      If Not pLoadObjetivos(c) Then Exit Function
      .Name = "Objetivos"
      .Key = K_OBJETIVOS
      .TabIndex = 2
      .GridAdd = True
      .GridEdit = True
      .GridRemove = True
    End With
    
    m_ItemsDeletedObjetivos = vbNullString
  
    Set c = .Add(Nothing, "Precios")
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      If Not pLoadPrecios(c) Then Exit Function
      .Name = "Precios"
      .Key = K_PRECIOS
      .TabIndex = 3
      .GridAdd = True
      .GridEdit = True
      .GridRemove = True
    End With
    
    m_ItemsDeletedPrecios = vbNullString
  
    Set c = .Add(Nothing, "Estados")
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      If Not pLoadEstados(c) Then Exit Function
      .Name = "Estados"
      .Key = K_ESTADO
      .TabIndex = 4
      .GridAdd = True
      .GridEdit = True
      .GridRemove = True
    End With
    
    m_ItemsDeletedEstados = vbNullString
  End With
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

Private Function Load(ByVal Id As Long) As Boolean

  Dim sqlstmt As String

  sqlstmt = "sp_proyectoGet " & Id

  Dim rs As ADODB.Recordset

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.fields, cscProyId)
    m_Nombre = gDB.ValField(rs.fields, cscProyNombre)
    m_Codigo = gDB.ValField(rs.fields, cscProyCodigo)
    m_Descrip = gDB.ValField(rs.fields, cscProyDescrip)
    m_Desde = gDB.ValField(rs.fields, cscProyDesde)
    m_Hasta = gDB.ValField(rs.fields, cscProyHasta)
    m_llevaAprob = gDB.ValField(rs.fields, cscProyLlevaAprobacion)
    m_FileSize = gDB.ValField(rs.fields, cscProyFileSize)
    m_Publico = gDB.ValField(rs.fields, cscProyPublico)
    m_Prov_id = gDB.ValField(rs.fields, cscProvId)
    m_Proveedor = gDB.ValField(rs.fields, cscProvNombre)
    m_Cli_id = gDB.ValField(rs.fields, cscCliId)
    m_Cliente = gDB.ValField(rs.fields, cscCliNombre)
    m_pr_id = gDB.ValField(rs.fields, cscPrId)
    m_producto = gDB.ValField(rs.fields, cscPrNombreVenta)
    m_Modificado = gDB.ValField(rs.fields, cscModificado)
    m_Creado = gDB.ValField(rs.fields, cscCreado)
    m_Activo = gDB.ValField(rs.fields, cscActivo)
    m_Modifico = gDB.ValField(rs.fields, cscModifico)

    m_proy_id_padre = gDB.ValField(rs.fields, cscProyIdPadre)
    m_ProyectoPadre = gDB.ValField(rs.fields, "padre")
    
    m_Ta_id = gDB.ValField(rs.fields, cscTaId)
    m_Talonario = gDB.ValField(rs.fields, cscTaNombre)

  Else
    m_Id = csNO_ID
    m_Nombre = vbNullString
    m_Codigo = vbNullString
    m_Descrip = vbNullString
    m_Desde = Date
    m_Hasta = csMaxDate
    m_llevaAprob = False
    m_FileSize = 1
    m_Publico = True
    m_Prov_id = csNO_ID
    m_Proveedor = vbNullString
    m_Cli_id = csNO_ID
    m_Cliente = vbNullString
    m_pr_id = csNO_ID
    m_producto = vbNullString
    m_Modificado = csNoDate
    m_Creado = csNoDate
    m_Activo = True
    m_Modifico = csNO_ID

    m_proy_id_padre = csNO_ID
    m_ProyectoPadre = vbNullString

    m_Ta_id = csNO_ID
    m_Talonario = vbNullString
    
  End If

  Load = True
End Function

Private Function pLoadObjetivos(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  
  Dim rs As ADODB.Recordset
  
  sqlstmt = "select Objetivo.* from objetivo where proy_id = " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadObjetivos", C_Module) Then Exit Function
  
  Dim o As cIABMGridColumn
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Visible = False
  o.Key = KI_OBJE_ID
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = C_strNombre
  o.PropertyType = cspText
  o.Width = 2500
  o.Key = KI_NOMBRE
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = C_strCodigo
  o.PropertyType = cspText
  o.Width = 800
  o.Key = KI_CODIGO
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = C_strDescrip
  o.PropertyType = cspText
  o.Width = 3000
  o.Key = KI_DESCRIP
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = C_strActivo
  o.PropertyType = cspCheck
  o.Width = 800
  o.Key = KI_ACTIVO
  
  Dim F  As cIABMGridRow
  Dim fv As cIABMGridCellValue
  
  While Not rs.EOF
  
    Set F = Propiedad.Grid.Rows.Add(Nothing, rs(cscObjeId).Value)
    
    Set fv = F.Add(Nothing)
    fv.Value = rs(cscObjeId).Value
    fv.Key = KI_OBJE_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscObjeNombre)
    fv.Key = KI_NOMBRE
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscObjeCodigo)
    fv.Key = KI_CODIGO
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscObjeDescrip)
    fv.Key = KI_DESCRIP
    
    Set fv = F.Add(Nothing)
    fv.Id = gDB.ValField(rs.fields, cscActivo)
    fv.Key = KI_ACTIVO
    
    rs.MoveNext
  Wend
  
  pLoadObjetivos = True
End Function

Private Function pLoadEstados(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  
  Dim rs As ADODB.Recordset
  
  sqlstmt = "select e.*,tarest_nombre " & _
            " from ProyectoTareaEstado e " & _
            " inner join TareaEstado est on e.tarest_id = est.tarest_id" & _
            " where proy_id = " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadEstados", C_Module) Then Exit Function
  
  Dim o As cIABMGridColumn
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Visible = False
  o.Key = KI_PROYEST_ID
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = LNGGetText(1568, vbNullString)   'Estado
  o.PropertyType = cspHelp
  o.Table = csTareaEstado
  o.Width = 2500
  o.Key = KI_ESTADO
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = C_strActivo
  o.PropertyType = cspCheck
  o.Width = 800
  o.Key = KI_ACTIVO
  
  Dim F  As cIABMGridRow
  Dim fv As cIABMGridCellValue
  
  While Not rs.EOF
  
    Set F = Propiedad.Grid.Rows.Add(Nothing, rs(cscProyEstId).Value)
    
    Set fv = F.Add(Nothing)
    fv.Value = rs(cscProyEstId).Value
    fv.Key = KI_PROYEST_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscTarestNombre)
    fv.Id = gDB.ValField(rs.fields, cscTarestId)
    fv.Key = KI_ESTADO
    
    Set fv = F.Add(Nothing)
    fv.Id = gDB.ValField(rs.fields, cscActivo)
    fv.Key = KI_ACTIVO
    
    rs.MoveNext
  Wend
  
  pLoadEstados = True
End Function

Private Function pLoadPrecios(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  
  Dim rs As ADODB.Recordset
  
  sqlstmt = "sp_proyectoPrecioGet " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadPrecios", C_Module) Then Exit Function
  
  Dim o As cIABMGridColumn
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Visible = False
  o.Key = KI_PROYP_ID
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = LNGGetText(1137, vbNullString)   'Usuario
  o.PropertyType = cspHelp
  o.Table = csUsuario
  o.Width = 2500
  o.Key = KI_US_ID
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = LNGGetText(2673, vbNullString)   'Honorarios
  o.PropertyType = cspNumeric
  o.SubType = cspMoney
  o.Format = m_GeneralConfig.FormatDecImporte
  o.Width = 800
  o.Key = KI_PRECIO
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = LNGGetText(1367, vbNullString)   'Articulo
  o.PropertyType = cspHelp
  o.Table = csProductoVenta
  o.Width = 2500
  o.Key = KI_PR_ID
  
  Dim F  As cIABMGridRow
  Dim fv As cIABMGridCellValue
  
  While Not rs.EOF
  
    Set F = Propiedad.Grid.Rows.Add(Nothing, rs(cscProypId).Value)
    
    Set fv = F.Add(Nothing)
    fv.Value = rs(cscProypId).Value
    fv.Key = KI_PROYP_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscUsNombre)
    fv.Id = gDB.ValField(rs.fields, cscUsId)
    fv.Key = KI_US_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscProypPrecio)
    fv.Key = KI_PRECIO
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscPrNombreVenta)
    fv.Id = gDB.ValField(rs.fields, cscPrId)
    fv.Key = KI_PR_ID
    
    rs.MoveNext
  Wend
  
  pLoadPrecios = True
End Function

Private Function pLoadItems(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  
  Dim rs As ADODB.Recordset
  
  sqlstmt = "select ProyectoItem.* from proyectoItem where proy_id = " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadItems", C_Module) Then Exit Function
  
  Dim o As cIABMGridColumn
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = "proyi_id"
  o.Visible = False
  o.Key = KI_PROYI_ID
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = C_strNombre
  o.PropertyType = cspText
  o.Width = 2500
  o.Key = KI_NOMBRE
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = C_strCodigo
  o.PropertyType = cspText
  o.Width = 800
  o.Key = KI_CODIGO
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = C_strDescrip
  o.PropertyType = cspText
  o.Width = 3000
  o.Key = KI_DESCRIP
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = C_strActivo
  o.PropertyType = cspCheck
  o.Width = 800
  o.Key = KI_ACTIVO
  
  Dim F  As cIABMGridRow
  Dim fv As cIABMGridCellValue
  
  While Not rs.EOF
  
    Set F = Propiedad.Grid.Rows.Add(Nothing, rs(cscProyIId).Value)
    
    Set fv = F.Add(Nothing)
    fv.Value = rs(cscProyIId).Value
    fv.Key = KI_PROYI_ID

    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscProyINombre)
    fv.Key = KI_NOMBRE
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscProyICodigo)
    fv.Key = KI_CODIGO
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscProyIDescrip)
    fv.Key = KI_DESCRIP
    
    Set fv = F.Add(Nothing)
    fv.Id = gDB.ValField(rs.fields, cscActivo)
    fv.Key = KI_ACTIVO
    
    rs.MoveNext
  Wend
  
  pLoadItems = True
End Function

Private Function pSaveItemsEstado(ByVal Id As Long) As Boolean
  Dim register As cRegister
  Dim IProperty As cIABMProperty
  
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_ESTADO
        
          Dim Row  As cIABMGridRow
          Dim Cell As cIABMGridCellValue
          
          For Each Row In IProperty.Grid.Rows
          
            Set register = New cRegister
            register.fieldId = cscProyEstId
            register.Table = csTProyectoTareaEstado
            register.Id = csNew
            
            For Each Cell In Row
              Select Case Cell.Key
                
                Case KI_PROYEST_ID
                  If Not m_Copy Then
                    register.Id = Val(Cell.Value)
                  End If
                Case KI_ESTADO
                  register.fields.Add2 cscTarestId, Cell.Id, csId
                Case KI_ACTIVO
                  register.fields.Add2 cscActivo, Cell.Id, csBoolean
              End Select
            Next
            
            register.fields.Add2 cscProyId, Id, csId
            
            register.fields.HaveLastUpdate = True
            register.fields.HaveWhoModify = True
            
            If Not gDB.Save(register, , "pSaveItemsEstado", C_Module, c_ErrorSave) Then Exit Function
          Next
      End Select
    End With
  Next
  
  Dim sqlstmt As String
  
  If LenB(m_ItemsDeletedEstados) And Not m_Copy Then
    m_ItemsDeletedEstados = RemoveLastColon(m_ItemsDeletedEstados)
    sqlstmt = "delete ProyectoTareaEstado where proyest_id in (" & m_ItemsDeletedEstados & ")"
  
    If Not gDB.Execute(sqlstmt, "pSaveItemsEstados", C_Module) Then Exit Function
  End If
  
  pSaveItemsEstado = True
End Function

Private Function pSaveItemsObjetivos(ByVal Id As Long) As Boolean
  Dim register As cRegister
  Dim IProperty As cIABMProperty
  
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_OBJETIVOS
        
          Dim Row  As cIABMGridRow
          Dim Cell As cIABMGridCellValue
          
          For Each Row In IProperty.Grid.Rows
          
            Set register = New cRegister
            register.fieldId = cscObjeId
            register.Table = csTObjetivo
            register.Id = csNew
            
            For Each Cell In Row
              Select Case Cell.Key
                
                Case KI_OBJE_ID
                  If Not m_Copy Then
                    register.Id = Val(Cell.Value)
                  End If
                Case KI_NOMBRE
                  register.fields.Add2 cscObjeNombre, Cell.Value, csText
                Case KI_CODIGO
                  register.fields.Add2 cscObjeCodigo, Cell.Value, csText
                Case KI_DESCRIP
                  register.fields.Add2 cscObjeDescrip, Cell.Value, csText
                Case KI_ACTIVO
                  register.fields.Add2 cscActivo, Cell.Id, csBoolean
              End Select
            Next
            
            register.fields.Add2 cscProyId, Id, csId
            
            register.fields.HaveLastUpdate = True
            register.fields.HaveWhoModify = True
            
            If Not gDB.Save(register, , "pSaveItemsObjetivos", C_Module, c_ErrorSave) Then Exit Function
          Next
      End Select
    End With
  Next
  
  Dim sqlstmt As String
  
  If LenB(m_ItemsDeletedObjetivos) And Not m_Copy Then
    m_ItemsDeletedObjetivos = RemoveLastColon(m_ItemsDeletedObjetivos)
    sqlstmt = "delete Objetivo where obje_id in (" & m_ItemsDeletedObjetivos & ")"
  
    If Not gDB.Execute(sqlstmt, "pSaveItemsObjetivos", C_Module) Then Exit Function
  End If
  
  pSaveItemsObjetivos = True
End Function

Private Function pSaveItemsPrecios(ByVal Id As Long) As Boolean
  Dim register As cRegister
  Dim IProperty As cIABMProperty
  
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_PRECIOS
        
          Dim Row  As cIABMGridRow
          Dim Cell As cIABMGridCellValue
          
          For Each Row In IProperty.Grid.Rows
          
            Set register = New cRegister
            register.fieldId = cscProypId
            register.Table = csTProyectoPrecio
            register.Id = csNew
            
            For Each Cell In Row
              Select Case Cell.Key
                
                Case KI_PROYP_ID
                  If Not m_Copy Then
                    register.Id = Val(Cell.Value)
                  End If
                Case KI_PRECIO
                  register.fields.Add2 cscProypPrecio, Val(Cell.Value), csDouble
                Case KI_US_ID
                  register.fields.Add2 cscUsId, Cell.Id, csId
                Case KI_PR_ID
                  register.fields.Add2 cscPrId, Cell.Id, csId
              End Select
            Next
            
            register.fields.Add2 cscProyId, Id, csId
            
            register.fields.HaveLastUpdate = True
            register.fields.HaveWhoModify = True
            
            If Not gDB.Save(register, , "pSaveItemsPrecios", C_Module, c_ErrorSave) Then Exit Function
          Next
      End Select
    End With
  Next
  
  Dim sqlstmt As String
  
  If LenB(m_ItemsDeletedPrecios) And Not m_Copy Then
    m_ItemsDeletedPrecios = RemoveLastColon(m_ItemsDeletedPrecios)
    sqlstmt = "delete ProyectoPrecio where proyp_id in (" & m_ItemsDeletedPrecios & ")"
  
    If Not gDB.Execute(sqlstmt, "pSaveItemsPrecios", C_Module) Then Exit Function
  End If
  
  pSaveItemsPrecios = True
End Function

Private Function pSaveItemsItems(ByVal Id As Long) As Boolean
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
            register.fieldId = cscProyIId
            register.Table = csTProyectoItem
            register.Id = csNew
            
            For Each Cell In Row
              Select Case Cell.Key
                
                Case KI_PROYI_ID
                  If Not m_Copy Then
                    register.Id = Val(Cell.Value)
                  End If
                Case KI_NOMBRE
                  register.fields.Add2 cscProyINombre, Cell.Value, csText
                Case KI_CODIGO
                  register.fields.Add2 cscProyICodigo, Cell.Value, csText
                Case KI_DESCRIP
                  register.fields.Add2 cscProyIDescrip, Cell.Value, csText
                Case KI_ACTIVO
                  register.fields.Add2 cscActivo, Cell.Id, csBoolean
              End Select
            Next
            
            register.fields.Add2 cscProyId, Id, csId
            
            register.fields.HaveLastUpdate = True
            register.fields.HaveWhoModify = True
            
            If Not gDB.Save(register, , "pSaveItemsItems", C_Module, c_ErrorSave) Then Exit Function
          Next
      End Select
    End With
  Next
  
  Dim sqlstmt As String
  
  If LenB(m_ItemsDeletedItems) And Not m_Copy Then
    m_ItemsDeletedItems = RemoveLastColon(m_ItemsDeletedItems)
    sqlstmt = "delete ProyectoItem where proyi_id in (" & m_ItemsDeletedItems & ")"
  
    If Not gDB.Execute(sqlstmt, "pSaveItemsItems", C_Module) Then Exit Function
  End If
  
  pSaveItemsItems = True
End Function

Public Function pSavePrestacion(ByVal Id As Long) As Boolean
  Dim sqlstmt As String
  sqlstmt = "sp_ProyectoSavePrestacion " & Id
  pSavePrestacion = gDB.Execute(sqlstmt)
End Function

Private Function pIsEmptyRowItems(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  Dim bRowIsEmpty           As Boolean
  
  strRow = " (Fila " & RowIndex & ")"
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_NOMBRE
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KI_CODIGO
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowItems = bRowIsEmpty
End Function

Private Function pIsEmptyRowObjetivos(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  Dim bRowIsEmpty           As Boolean
  
  strRow = " (Fila " & RowIndex & ")"
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_NOMBRE
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KI_CODIGO
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowObjetivos = bRowIsEmpty
End Function

Private Function pIsEmptyRowEstados(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  Dim bRowIsEmpty           As Boolean
  
  strRow = " (Fila " & RowIndex & ")"
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_ESTADO
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowEstados = bRowIsEmpty
End Function

Private Function pIsEmptyRowPrecios(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  Dim bRowIsEmpty           As Boolean
  
  strRow = " (Fila " & RowIndex & ")"
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_PRECIO
        If Not ValEmpty(Cell.Value, csDouble) Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KI_US_ID
        If Not ValEmpty(Cell.Id, csId) Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KI_PR_ID
        If Not ValEmpty(Cell.Id, csId) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowPrecios = bRowIsEmpty
End Function

' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  c_strTitle = LNGGetText(3040, vbNullString) 'Proyectos/Grupos/Contratos
  c_ErrorSave = LNGGetText(3039, vbNullString) 'Error al grabar Tarea
  
  Set m_GeneralConfig = New cGeneralConfig
  m_GeneralConfig.Load

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
  On Error Resume Next
  Set m_ObjAbm = Nothing
  Set m_ObjTree = Nothing
  Set m_GeneralConfig = Nothing
End Sub

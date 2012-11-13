VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cMail"
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
' cMail
' 17-07-2003

'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cMail"

Private Const c_Items = "Items"

Private Const K_NOMBRE                         As Integer = 1
Private Const K_CODIGO                         As Integer = 2
Private Const K_DESCRIP                        As Integer = 3
Private Const K_ACTIVO                         As Integer = 4
Private Const K_EMAILTO                        As Integer = 5
Private Const K_EMAILCC                        As Integer = 6
Private Const K_TIPO                           As Integer = 7

Private Const K_ITEMS                          As Integer = 8

Private Const KI_MAILI_ID                      As Integer = 2
Private Const KI_EMAIL                         As Integer = 3
Private Const KI_TIEMPO                        As Integer = 4
Private Const KI_TIEMPOTIPO                    As Integer = 5

' pseudo-constantes
Private c_ErrorSave As String

' estructuras
' variables privadas
Private m_Id                           As Long
Private m_Nombre                       As String
Private m_Codigo                       As String
Private m_Descrip                      As String
Private m_Activo                       As Boolean
Private m_EmailTo                      As String
Private m_EmailCC                      As String
Private m_Tipo                         As Integer

'OJO HASTA ACA

Private m_Editing           As Boolean

Private m_ObjAbm            As cIABMGeneric
Private m_ObjTree           As Object

Private m_IsNew             As Boolean

Private m_BranchId          As Long
Private m_TreeId            As Long

Private m_Host              As CSMenu.cIMenuHost
Private m_Copy              As Boolean

Private m_ItemsDeleted           As String
  
' Properties publicas
' Properties privadas
' funciones publicas

' Implementacion de cIABMClient
Private Function cIABMClient_Copy() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True
  
  With m_ObjAbm.Properties(cscMailNombre)
    .Value = C_CopiaDe & .Value
  End With
    
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscMailNombre)
  
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

  Doc.ClientTable = csMail
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

Private Function cIABMClient_PropertyChange(ByVal key As Integer) As Boolean
  cIABMClient_PropertyChange = True
End Function

Private Function cIABMClient_Save() As Boolean
  Dim register   As cRegister
  Dim Fields     As cFields
  Dim sqlstmt    As String
  
  Set register = New cRegister
  
  With register
  
    Set Fields = .Fields
    
    .fieldId = cscMailId
    .table = csTMail
  
    If m_Copy Then
      .Id = csNew
    Else
      .Id = m_Id
    End If
  End With
  
  Dim IProperty As cIABMProperty
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .key
        Case K_NOMBRE
          Fields.Add2 cscMailNombre, .Value, csText
        Case K_CODIGO
          Fields.Add2 cscMailCodigo, .Value, csText
        Case K_DESCRIP
          Fields.Add2 cscMailDescrip, .Value, csText
        Case K_EMAILTO
          Fields.Add2 cscMailEmailTo, .Value, csText
        Case K_EMAILCC
          Fields.Add2 cscMailEmailCc, .Value, csText
        Case K_TIPO
          Fields.Add2 cscMailTipo, .ListItemData, csInteger
        Case K_ACTIVO
          Fields.Add2 cscActivo, .Value, csBoolean
      End Select
    End With
  Next
  
  Fields.HaveLastUpdate = True
  Fields.HaveWhoModify = True
  
  If Not register.BeginTrans(gDB) Then Exit Function
                                                            
  If Not gDB.SaveEx(register, , _
                    cscMailCodigo, _
                    C_ABMClientSave, _
                    C_Module, _
                    c_ErrorSave) Then Exit Function
  
  'If Not gDB.Save(register, , "cIABMClient_Save", C_Module, c_ErrorSave) Then Exit Function
  
  If Not pSaveItems(register.Id) Then Exit Function
  
  register.CommitTrans
  
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
  cIABMClient_Title = LNGGetText(3261, vbNullString)  'Mails
End Property

Private Function cIABMClient_Validate() As Boolean
  Dim IPropiedad    As cIABMProperty
                          
  CSKernelClient2.title = LNGGetText(3261, vbNullString) 'Mails
  
  For Each IPropiedad In m_ObjAbm.Properties
    With IPropiedad
      Select Case .key
        
        Case K_NOMBRE
          If ValEmpty(.Value, csText) Then
            MsgInfo C_DebeIndicarNombre  'Debe indicar un nombre
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
    cIEditGeneric_ShowList = SecurityCanAccess(csPreTickListMail)
End Function

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
    Set m_ObjAbm = rhs
End Property

Private Property Get cIEditGeneric_Editing() As Boolean
    cIEditGeneric_Editing = m_Editing
End Property

Private Function cIEditGeneric_Delete(Id As Long) As Boolean
    If Not SecurityCanAccess(csPreTickDeleteMail) Then Exit Function

    Dim sqlstmt As String
  
    sqlstmt = "delete Mailitem where mail_id = " & Id & _
              " delete Mail where mail_id = " & Id
    
    cIEditGeneric_Delete = gDB.Execute(sqlstmt, "cIEditGeneric_Delete", C_Module)
End Function

Private Function cIEditGeneric_Search(Id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Id = csNO_ID Then
    m_IsNew = True
    If Not SecurityCanAccess(csPreTickNewMail) Then Exit Function
  Else
    m_IsNew = False
    If Not SecurityCanAccess(csPreTickEditMail) Then Exit Function
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

Private Function cIEditGeneric_PropertyChange(ByVal key As Integer) As Boolean

End Function

' Menu Client
Private Function cIMenuClient_Initialize(F As Object, Host As CSMenu.cIMenuHost) As Boolean
  On Error GoTo ControlError
  Dim str_1028  As String
  Dim str_1851  As String
  Dim str_3262  As String
  
  str_1028 = LNGGetText(1028, vbNullString)   'Co&nfiguración
  str_1851 = LNGGetText(1851, vbNullString)   '&Servicios
  str_3262 = LNGGetText(3262, vbNullString)  '&Mails
  
  Set m_Host = Host
  
  #If Not PREPROC_NO_MENU_ICON Then
    Dim lIconIndex As Long
    lIconIndex = m_Host.AddIcon(LoadResPicture(102, LoadResConstants.vbResIcon))
    m_Host.Server.AddMenu str_1851, csMenuConfig, str_1028, 0, True, False, True, False, True, Nothing
    m_Host.Server.AddMenu str_3262, csPreTickListMail, str_1851, 0, True, False, False, False, False, Me, lIconIndex
  
  #Else
    m_Host.Server.AddMenu str_1851, csMenuConfig, str_1028, 0, True, False, True, False, True, Nothing
    m_Host.Server.AddMenu str_3262, csPreTickListMail, str_1851, 0, True, False, False, False, False, Me
  #End If

  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, "cIMenuClient_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal Id As Long) As Variant
  m_Host.MenuABMClick "CSTicket.cMail", Me, LNGGetText(3261, vbNullString), 0, csMail 'Mails
End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  Dim c       As cIABMProperty
  Dim AbmObj  As cABMGeneric
  
  m_ObjAbm.Properties.Clear
  
  Const c_tab_items = 1
  
  Set AbmObj = m_ObjAbm
  AbmObj.MinHeight = 8000

  With m_ObjAbm.Tabs
    
    .Clear
    
    With .Add(Nothing)
      .Name = C_strGeneral
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1371, vbNullString)  'Items
      .Index = c_tab_items
    End With
    
  End With

  With m_ObjAbm.Properties

    With .Add(Nothing, cscMailNombre)
      .PropertyType = cspText
      .Name = C_strNombre
      .Width = 6500
      .Size = 255
      .key = K_NOMBRE
      .Value = m_Nombre
    End With
  
    With .Add(Nothing, cscMailCodigo)
      .PropertyType = cspText
      .Name = C_strCodigo
      .Width = 2500
      .Size = 255
      .key = K_CODIGO
      .Value = m_Codigo
    End With
    
    With .Add(Nothing, cscActivo)
      .PropertyType = cspCheck
      .TopFromProperty = cscMailCodigo
      .LeftNotChange = True
      .Left = 5200
      .LeftLabel = -600
      .Name = C_strActivo
      .key = K_ACTIVO
      .Value = CInt(m_Activo)
    End With
    
    With .Add(Nothing, cscMailEmailTo)
      .PropertyType = cspText
      .Name = LNGGetText(3255, vbNullString) ' Destinatario/s
      .Width = 6500
      .key = K_EMAILTO
      .Value = m_EmailTo
    End With
    
    With .Add(Nothing, cscMailEmailCc)
      .PropertyType = cspText
      .Name = LNGGetText(3256, vbNullString) ' Con copia a
      .Width = 6500
      .key = K_EMAILCC
      .Value = m_EmailCC
    End With
    
    With .Add(Nothing, cscMailTipo)
      .PropertyType = cspList
      .Name = LNGGetText(1223, vbNullString) ' Tipo
      With .List
        With .Add(Nothing)
          .Id = csEMailTtype.csE_MailTypeAllHaveToResponse
          .Value = LNGGetText(3257, vbNullString) ' Todos deben responder
        End With
        With .Add(Nothing)
          .Id = csEMailTtype.csE_MailTypeOneHaveToResponse
          .Value = LNGGetText(3258, vbNullString) ' Al menos uno debe responder
        End With
      End With
      .Width = 6500
      .Size = 255
      .key = K_TIPO
      .ListWhoSetItem = csListItemData
      .ListItemData = m_Tipo
    End With
    
    With .Add(Nothing, cscMailDescrip)
      .PropertyType = cspText
      .SubType = cspMemo
      .Name = C_strDescrip
      .Width = 6500
      .Size = 255
      .Height = 725
      .key = K_DESCRIP
      .Value = m_Descrip
    End With
  
    '////////////////////////////////////////////////////////////
    ' Items
    '
    Set c = .Add(Nothing, c_Items)
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      If Not pLoadItems(c) Then Exit Function
      .Name = c_Items
      .key = K_ITEMS
      .TabIndex = c_tab_items
      .GridAdd = True
      .GridEdit = True
      .GridRemove = True
    End With
  
    m_ItemsDeleted = vbNullString
    
  End With
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

Private Function Load(ByVal Id As Long) As Boolean

  Dim sqlstmt As String

  sqlstmt = "select * from Mail where mail_id = " & Id

  Dim rs As Recordset

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.Fields, cscMailId)
    m_Nombre = gDB.ValField(rs.Fields, cscMailNombre)
    m_Codigo = gDB.ValField(rs.Fields, cscMailCodigo)
    m_Descrip = gDB.ValField(rs.Fields, cscMailDescrip)
    m_Activo = gDB.ValField(rs.Fields, cscActivo)
    m_EmailTo = gDB.ValField(rs.Fields, cscMailEmailTo)
    m_EmailCC = gDB.ValField(rs.Fields, cscMailEmailCc)
    m_Tipo = gDB.ValField(rs.Fields, cscMailTipo)

  Else
  
    m_Id = csNO_ID
    m_Nombre = vbNullString
    m_Nombre = vbNullString
    m_Descrip = vbNullString
    m_EmailTo = vbNullString
    m_EmailCC = vbNullString
    m_Tipo = csEMailTtype.csE_MailTypeOneHaveToResponse
    m_Activo = True

  End If

  Load = True
End Function

Private Sub Class_Initialize()
  On Error GoTo ControlError
                                  
  c_ErrorSave = LNGGetText(3263, vbNullString) 'Error al grabar el Mail

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

' construccion - destruccion
Private Sub Class_Terminate()
  Set m_ObjAbm = Nothing
  Set m_ObjTree = Nothing
End Sub

Private Function cIABMClientGrid_ColumnAfterEdit(ByVal key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long) As Boolean
  cIABMClientGrid_ColumnAfterEdit = True
End Function

Private Function cIABMClientGrid_ColumnBeforeEdit(ByVal key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean
  cIABMClientGrid_ColumnBeforeEdit = True
End Function

Private Function cIABMClientGrid_ColumnButtonClick(ByVal key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean

End Function

Private Sub cIABMClientGrid_ColumnCancelEdit(ByVal key As Integer)

End Sub

Private Function cIABMClientGrid_DeleteRow(ByVal key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal lRow As Long) As Boolean
  Dim Id As Long
  
  Select Case key
    
    Case K_ITEMS
      Id = Val(pCell(Row, KI_MAILI_ID).Value)
      If Id <> csNO_ID Then m_ItemsDeleted = m_ItemsDeleted & Id & C_StrColon
      
  End Select
  
  cIABMClientGrid_DeleteRow = True
End Function

Private Function cIABMClientGrid_ListAdHock(ByVal key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal ColIndex As Long, List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClientGrid_NewRow(ByVal key As Integer, ByVal Rows As Integer)

End Sub

Private Function cIABMClientGrid_ValidateRow(ByVal key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case key
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

Private Function cIABMClientGrid_ColumnAfterUpdate(ByVal key As Integer, ByVal lRow As Long, ByVal lCol As Long) As Boolean
  cIABMClientGrid_ColumnAfterUpdate = True
End Function

Private Sub cIABMClientGrid_ColumnClick(ByVal key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Sub cIABMClientGrid_DblClick(ByVal key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Function cIABMClientGrid_IsEmptyRow(ByVal key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case key
    Case K_ITEMS
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowItems(Row, RowIndex)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, C_ValidateRow, C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pSaveItems(ByVal al_id As Long) As Boolean
  Dim register As cRegister
  Dim IProperty As cIABMProperty
  
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .key
        Case K_ITEMS
        
          Dim Row  As cIABMGridRow
          Dim Cell As cIABMGridCellValue
          
          For Each Row In IProperty.Grid.Rows
          
            Set register = New cRegister
            register.fieldId = cscMailiId
            register.table = csTMailItem
            register.Id = csNew
            
            With register.Fields
            
              For Each Cell In Row
                Select Case Cell.key
                  Case KI_MAILI_ID
                    If Not m_Copy Then
                      register.Id = Val(Cell.Value)
                    End If
                  Case KI_EMAIL
                    .Add2 cscMailiEmail, Cell.Value, csText
                  Case KI_TIEMPO
                    .Add2 cscMailiTiempo, Val(Cell.Value), csInteger
                  Case KI_TIEMPOTIPO
                    .Add2 cscMailiTiempotipo, Cell.Id, csInteger
                  
                End Select
              Next
              
              .Add2 cscMailId, al_id, csId
              
              .HaveLastUpdate = False
              .HaveWhoModify = False
              
            End With
                                                                 
            If Not gDB.Save(register, , "pSaveItems", C_Module, c_ErrorSave) Then Exit Function
          Next
      End Select
    End With
  Next
  
  Dim sqlstmt As String
  
  If LenB(m_ItemsDeleted) And Not m_Copy Then
  
    m_ItemsDeleted = RemoveLastColon(m_ItemsDeleted)
    sqlstmt = "delete MailItem where maili_id in (" & m_ItemsDeleted & ")"
  
    If Not gDB.Execute(sqlstmt, "pSaveItems", C_Module) Then Exit Function
  End If
  
  pSaveItems = True
End Function

Private Function pLoadItems(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "select * from MailItem where mail_id = " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadItems", C_Module) Then Exit Function
  
  With Propiedad.Grid
  
    With .Columns
    
      .Clear
  
      With .Add(Nothing)
        .Visible = False
        .key = KI_MAILI_ID
      End With
  
      With .Add(Nothing)
        .PropertyType = cspText
        .Name = C_strNombre
        .key = KI_EMAIL
      End With
      
      With .Add(Nothing)
        .PropertyType = cspNumeric
        .SubType = cspInteger
        .Name = LNGGetText(1769, vbNullString)  'Tiempo
        .key = KI_TIEMPO
      End With
      
      With .Add(Nothing)
        
        .PropertyType = cspList
        
        With .List
          With .Add(Nothing)
            .Id = csEMailTimeType.csE_MTTMinuto
            .Value = LNGGetText(1780, vbNullString)  'Minutos
          End With
          With .Add(Nothing)
            .Id = csEMailTimeType.csE_MTTHora
            .Value = LNGGetText(1660, vbNullString)  'Horas
          End With
          With .Add(Nothing)
            .Id = csEMailTimeType.csE_MTTDia
            .Value = LNGGetText(1085, vbNullString)  'Dias
          End With
        End With
        
        Set .DefaultValue = New cABMGridRowValue
        .DefaultValue.Id = csEMailTimeType.csE_MTTHora
        .Name = LNGGetText(1223, vbNullString)  'Tipo
        .key = KI_TIEMPOTIPO
      End With
      
    End With
    
    With .Rows
    
      .Clear
    
      While Not rs.EOF
      
        With .Add(Nothing, rs(cscMailiId).Value)
        
          With .Add(Nothing)
            .Value = rs(cscMailiId).Value
            .key = KI_MAILI_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscMailiEmail)
            .key = KI_EMAIL
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscMailiTiempo)
            .key = KI_TIEMPO
          End With
          
          With .Add(Nothing)
            .Id = gDB.ValField(rs.Fields, cscMailiTiempotipo)
            .key = KI_TIEMPOTIPO
          End With
                    
        End With
        
        rs.MoveNext
      Wend
    End With
  End With
  
  pLoadItems = True
End Function

Private Function pValidateRowItems(Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.key
      Case KI_EMAIL
        If ValEmpty(Cell.Value, csText) Then
          MsgInfo LNGGetText(3259, vbNullString, strRow)
                  'Debe indicar una mail para el item (1)
          Exit Function
        End If
    
      Case KI_TIEMPO
        If ValEmpty(Cell.Value, csInteger) Then
          MsgInfo LNGGetText(3260, vbNullString, strRow)
                  'Debe indicar una tiempo para el item (1)
          Exit Function
        End If
      
    End Select
  Next
  
  pValidateRowItems = True
End Function

Private Function pIsEmptyRowItems(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim bRowIsEmpty           As Boolean
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.key
      Case KI_EMAIL
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
        
    End Select
  Next
  
  pIsEmptyRowItems = bRowIsEmpty
End Function

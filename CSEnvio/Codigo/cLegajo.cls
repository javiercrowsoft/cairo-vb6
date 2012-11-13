VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cLegajo"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGeneric
Implements CSInterfacesABM.cIABMClient
Implements CSMenu.cIMenuClient
Implements CSInterfacesABM.cIABMClientGrid
Implements CSIDocumento.cIDocumento
'--------------------------------------------------------------------------------
' cLegajo
' 25-12-03

'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cLegajo"

Private Const c_Items = "Items"

Private Const K_TITULO                         As Integer = 1
Private Const K_CODIGO                         As Integer = 2
Private Const K_DESCRIP                        As Integer = 3
Private Const K_FECHA                          As Integer = 4
Private Const K_ATA                            As Integer = 5
Private Const K_HAWBBL                         As Integer = 6
Private Const K_ETD                            As Integer = 7
Private Const K_ETA                            As Integer = 8
Private Const K_MAWBBL                         As Integer = 9
Private Const K_FOB                            As Integer = 10
Private Const K_GIRO                           As Integer = 11
Private Const K_FLETE                          As Integer = 12
Private Const K_LGJT_ID                        As Integer = 13
Private Const K_EST_ID                         As Integer = 14
Private Const K_CLI_ID                         As Integer = 15
Private Const K_MON_ID                         As Integer = 16
Private Const K_TRANS_ID                       As Integer = 17
Private Const K_BARC_ID                        As Integer = 18
Private Const K_VUE_ID                         As Integer = 19
Private Const K_PUE_ID                         As Integer = 20
Private Const K_ACTIVO                         As Integer = 21

Private Const K_ITEMS                          As Integer = 22

Private Const KI_PTD_ID                         As Integer = 1
Private Const KI_NUMERO                         As Integer = 2
Private Const KI_TITULO                         As Integer = 3
Private Const KI_DESCRIP                        As Integer = 4
Private Const KI_FECHAINI                       As Integer = 5
Private Const KI_FECHAFIN                       As Integer = 6
Private Const KI_ALARMA                         As Integer = 7
Private Const KI_CUMPLIDA                       As Integer = 8

' pseudo-constantes
Private c_strTitle As String
Private c_ErrorSave As String

' estructuras
' variables privadas
Private m_Id                           As Long
Private m_Titulo                       As String
Private m_Codigo                       As String
Private m_Descrip                      As String
Private m_Fecha                        As Date
Private m_Ata                          As String
Private m_Hawbbl                       As String
Private m_Etd                          As String
Private m_Eta                          As String
Private m_Mawbbl                       As String
Private m_Fob                          As String
Private m_Giro                         As String
Private m_Flete                        As String
Private m_est_id                       As Long
Private m_Estado                       As String
Private m_cli_id                       As Long
Private m_Cliente                      As String
Private m_Lgjt_id                      As Long
Private m_LegajoTipo                   As String
Private m_mon_id                       As Long
Private m_Moneda                       As String
Private m_trans_id                     As Long
Private m_Transporte                   As String
Private m_Barc_id                      As Long
Private m_Barco                        As String
Private m_Vue_id                       As Long
Private m_Vuelo                        As String
Private m_Pue_id                       As Long
Private m_Puerto                       As String
Private m_Modificado                   As Date
Private m_Creado                       As Date
Private m_Modifico                     As Long
Private m_Activo                       As Boolean

Private m_Tal_id                       As Long

'OJO HASTA ACA
Private m_Editing           As Boolean

Private m_ObjAbm            As cIABMGeneric
Private m_ObjTree           As Object

Private m_IsNew             As Boolean

Private m_BranchId          As Long
Private m_TreeId            As Long
Private m_Copy              As Boolean

Private m_Host As CSMenu.cIMenuHost

' Properties publicas

Public Property Get ID() As Long
  ID = m_Id
End Property

Public Property Get Nombre() As String
  Nombre = m_Titulo
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

  Doc.ClientTable = csTLegajo
  Doc.ClientTableID = m_Id

  cIABMClient_ShowDocDigital = Doc.ShowDocs(gDB)

  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClient_ShowDocDigital", C_Module, vbNullString
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
  
  With m_ObjAbm.Properties(cscLgjCodigo)
    .Value = vbNullString
  End With
  'TODO cambiar el Copiar
  With m_ObjAbm.Properties(cscLgjTitulo)
    .Value = C_CopiaDe & .Value
  End With
  
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscLgjCodigo)
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscLgjTitulo)
  
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
  Dim Number   As Long
  Dim Tal      As cTalonario
  Dim Codigo   As String
  
  If m_Tal_id = csNO_ID Then
    MsgWarning LNGGetText(2320, vbNullString)
                'Debe configurar un talonario para los Partes Diarios
    Exit Function
  End If
  
  Set register = New cRegister
  With register
    Set fields = .fields
    .fieldId = cscLgjId
    .Table = csTLegajo
    
    If m_Copy Then
      .ID = csNew
    Else
      .ID = m_Id
    End If
  End With
  
  Dim IProperty As cIABMProperty
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_TITULO
          fields.Add2 cscLgjTitulo, .Value, csText
        Case K_DESCRIP
          fields.Add2 cscLgjDescrip, .Value, csText
        Case K_FECHA
          fields.Add2 cscLgjFecha, .Value, csDate
        Case K_EST_ID
          fields.Add2 cscEstId, .HelpId, csId
        Case K_CLI_ID
          fields.Add2 cscCliId, .HelpId, csId
        Case K_ACTIVO
          fields.Add2 cscActivo, .Value, csBoolean
        Case K_ATA
          fields.Add2 cscLgjAta, .Value, csText
        Case K_HAWBBL
          fields.Add2 cscLgjHawbbl, .Value, csText
        Case K_ETD
          fields.Add2 cscLgjEtd, .Value, csText
        Case K_ETA
          fields.Add2 cscLgjEta, .Value, csText
        Case K_MAWBBL
          fields.Add2 cscLgjMawbbl, .Value, csText
        Case K_FOB
          fields.Add2 cscLgjFob, .Value, csText
        Case K_GIRO
          fields.Add2 cscLgjGiro, .Value, csText
        Case K_FLETE
          fields.Add2 cscLgjFlete, .Value, csText
        Case K_LGJT_ID
          fields.Add2 cscLgjtId, .HelpId, csId
          
          If Not pUpdateCodigo(.HelpId, register.ID = csNew, Number, Tal, Codigo) Then Exit Function
          fields.Add2 cscLgjCodigo, Codigo, csText
      
        Case K_MON_ID
          fields.Add2 cscMonId, .HelpId, csId
        Case K_TRANS_ID
          fields.Add2 cscTransId, .HelpId, csId
        Case K_BARC_ID
          fields.Add2 cscBarcId, .HelpId, csId
        Case K_VUE_ID
          fields.Add2 cscVueId, .HelpId, csId
        Case K_PUE_ID
          fields.Add2 cscPueId, .HelpId, csId
      End Select
    End With
  Next
  
  fields.HaveLastUpdate = True
  fields.HaveWhoModify = True
  
  If Not register.BeginTrans(gDB) Then Exit Function
                      
  If Not gDB.Save(register, , "cIABMClient_Save", C_Module, c_ErrorSave) Then Exit Function
  
  If Not Tal Is Nothing Then
    If Not Tal.UpdateLastUsedNumber(m_Tal_id, Number) Then GoTo SaveError
  End If
  
  If Not register.CommitTrans() Then GoTo SaveError
  
  m_Copy = False
  cIABMClient_Save = Load(register.ID)

  Exit Function
SaveError:
End Function

Private Function pUpdateCodigo(ByVal lgjt_id As Long, ByVal bGetNewNumber As Boolean, ByRef Number As Long, ByRef Tal As cTalonario, ByRef Codigo As String) As Boolean
  Dim tmp         As String
  Dim fecha       As Date
  Dim TipoCodigo  As String
  
  Codigo = m_ObjAbm.Properties.Item(cscLgjCodigo).Value
  
  If LenB(Codigo) Then bGetNewNumber = False
  
  If Not gDB.GetData(csTLegajoTipo, cscLgjtId, lgjt_id, cscLgjtCodigo, TipoCodigo) Then Exit Function
  
  If bGetNewNumber Then
    Set Tal = New cTalonario
    Number = Tal.GetNextNumber(m_Tal_id, vbNullString, False)
  Else
    tmp = Mid(Codigo, InStr(1, Codigo, "-") + 1)
    
    If InStr(1, tmp, "-") = 0 Then
      MsgWarning LNGGetText(2321, vbNullString)
        'El código no es correco verifique que cumpla con el formato:;;    XXX-000-00-00;; Ejemplo: FIM-051-04-04
      Exit Function
    End If
    
    tmp = Mid(tmp, 1, InStr(1, tmp, "-") - 1)
    Number = Val(tmp)
  End If
  
  fecha = m_ObjAbm.Properties.Item(cscLgjFecha).Value
  
  Codigo = TipoCodigo & "-" & Format(Number, "000") & "-" & Format(fecha, "mm-yy")
  
  pUpdateCodigo = True
End Function

Private Function cIABMClient_Terminate() As Boolean
  m_Editing = False
  
  cIABMClient_Terminate = True
  ' Este objeto puede no cumplir con la interfaz esperada, asi que si hay un error no
  ' le doy bola
  On Error GoTo ControlError
  If m_Id = csNO_ID Then Exit Function
  If m_ObjTree Is Nothing Then Exit Function
  
  m_ObjTree.sqlstmt = "sp_lsdoc_legajo"
  
  If m_IsNew Then
    m_ObjTree.AddLine m_Id
  Else
    m_ObjTree.RefreshLine m_Id
  End If
ControlError:
End Function

Private Property Get cIABMClient_Title() As String
    cIABMClient_Title = c_strTitle
End Property

Private Function cIABMClient_Validate() As Boolean

  Dim IProperty As cIABMProperty
  Dim bVuelo As Boolean

  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_FECHA
          If ValEmpty(.Value, csDate) Then
            MsgInfo LNGGetText(1558, vbNullString) 'Debe indicar un fecha
            Exit Function
          End If
        Case K_EST_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(2322, vbNullString) 'Debe indicar un Estado
            Exit Function
          End If
        Case K_LGJT_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(2323, vbNullString) 'Debe indicar un Tipo de Legajo
            Exit Function
          End If
        Case K_MON_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(1108, vbNullString) 'Debe indicar una moneda
            Exit Function
          End If
      End Select
    End With
  Next

'  If Not bVuelo Then
'    MsgInfo "Debe indicar un vapor o un vuelo"
'    Exit Function
'  End If

  cIABMClient_Validate = True
End Function

'-------------------------------------------------------------------------------------
' Documento
Private Property Get cIDocumento_DocId() As Long
  cIDocumento_DocId = csLegajo
End Property

Private Property Get cIDocumento_DocTId() As Long
  cIDocumento_DocTId = csNO_ID
End Property

Private Property Get cIDocumento_Id() As Long
  cIDocumento_Id = m_Id
End Property

Private Function cIDocumento_LoadForPrint(ByVal ID As Long) As Boolean
  On Error GoTo ControlError

  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  m_Id = ID
  
  cIDocumento_LoadForPrint = True

  GoTo ExitProc
ControlError:
  MngError Err, "cIDocumento_LoadForPrint", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
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
    cIEditGeneric_ShowList = SecurityCanAccess(csPreEnvListLegajo)
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
  If Not SecurityCanAccess(csPreEnvDeleteLegajo) Then Exit Function

  Dim sqlstmt As String
  
  sqlstmt = "Delete Legajo where lgj_id  = " & ID
  
  cIEditGeneric_Delete = gDB.Execute(sqlstmt, "cIEditGeneric_Delete", C_Module)
End Function

Private Function cIEditGeneric_Search(ID As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(ID As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If ID = csNO_ID Then
    m_IsNew = True
    If Not SecurityCanAccess(csPreEnvNewLegajo) Then Exit Function
  Else
    m_IsNew = False
    If Not SecurityCanAccess(csPreEnvEditLegajo) Then Exit Function
  End If
  
  If m_Tal_id = csNO_ID Then
    MsgWarning LNGGetText(2324, vbNullString) 'Debe configurar un talonario para los Legajos
    Exit Function
  End If
  
  m_ObjAbm.InModalWindow = InModalWindow
  
  If Not Load(ID) Then Exit Function
  
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

Private Function cIMenuClient_Initialize(F As Object, Host As CSMenu.cIMenuHost) As Boolean
  On Error GoTo ControlError
  Dim str_2312 As String
  
  str_2312 = LNGGetText(2312, vbNullString) '&Envios
  Set m_Host = Host
  m_Host.Server.AddMenu str_2312, csMenuEnvio, vbNullString, 1, False, False, False, True, False, Nothing
  m_Host.Server.AddMenu LNGGetText(2325, vbNullString), csPreEnvListLegajo, str_2312, 0, True, False, False, False, False, Me
                        '&Legajos
  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, "cIMenuClient_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal ID As Long) As Variant
  m_Host.MenuListDocClick "CSABMInterface2.CABMGeneric", "CSEnvio2.cLegajo", "CSABMInterface2.CABMGenericListDoc", "CSEnvio2.cLegajoListDoc", Me, c_strTitle, 0
End Function

' Grilla
Private Function cIABMClientGrid_ColumnAfterUpdate(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long) As Boolean

End Function

Private Sub cIABMClientGrid_ColumnClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Sub cIABMClientGrid_DblClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)
  
  Select Case Key
    Case K_ITEMS
      pEditParte Val(m_ObjAbm.Properties(c_Items).Grid.Rows(lRow).Item(1).Value)
  End Select

End Sub

Private Function cIABMClientGrid_IsEmptyRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  cIABMClientGrid_IsEmptyRow = True
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
  cIABMClientGrid_DeleteRow = True
End Function

Private Function cIABMClientGrid_ListAdHock(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal ColIndex As Long, List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClientGrid_NewRow(ByVal Key As Integer, ByVal Rows As Integer)

End Sub

Private Function cIABMClientGrid_ValidateRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  cIABMClientGrid_ValidateRow = True
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
      .Name = LNGGetText(3523, vbNullString) 'Comex
    End With
    
    With .Add(Nothing)
      .Index = 2
      .Name = LNGGetText(1371, vbNullString) 'Items
    End With
    
  End With

  With m_ObjAbm.Properties
    
    .Clear
    
    With .Add(Nothing, cscLgjtId)
      .PropertyType = cspHelp
      .Table = csLegajoTipo
      .Name = LNGGetText(1223, vbNullString) 'Tipo
      .Key = K_LGJT_ID
      .Value = m_LegajoTipo
      .HelpId = m_Lgjt_id
    End With
      
    With .Add(Nothing, cscActivo)
      .PropertyType = cspCheck
      .Name = C_strActivo
      .Key = K_ACTIVO
      .Value = CInt(m_Activo)
      .LeftNotChange = True
      .LeftLabel = -600
      .Left = 4700
      .TopFromProperty = cscLgjtId
      .TopNotChange = True
    End With
      
    With .Add(Nothing, cscLgjCodigo)
      .PropertyType = cspText
      .Name = C_strCodigo
      .LeftLabel = -700
      .Size = 50
      .Key = K_CODIGO
      .Value = m_Codigo
      '.Enabled = False
      .LeftNotChange = True
      .Left = 6100
      .TopFromProperty = cscLgjtId
      .TopNotChange = True
    End With
      
    With .Add(Nothing, cscLgjTitulo)
      .PropertyType = cspText
      .Name = LNGGetText(1864, vbNullString) 'Título
      .Size = 255
      .Key = K_TITULO
      .Value = m_Titulo
      .Width = 6800
    End With
      
    With .Add(Nothing, cscLgjFecha)
      .PropertyType = cspDate
      .Name = LNGGetText(1569, vbNullString) 'Fecha
      .Key = K_FECHA
      .Value = m_Fecha
    End With
    
    With .Add(Nothing, cscEstId)
      .PropertyType = cspHelp
      .Table = csEstado
      .Name = LNGGetText(1568, vbNullString) 'Estado
      .Key = K_EST_ID
      .Value = m_Estado
      .HelpId = m_est_id
    End With
    
    With .Add(Nothing, cscCliId)
      .PropertyType = cspHelp
      .Table = csCliente
      .Name = LNGGetText(1150, vbNullString) 'Cliente
      .Key = K_CLI_ID
      .Value = m_Cliente
      .HelpId = m_cli_id
    End With
      
    With .Add(Nothing, cscLgjAta)
      .PropertyType = cspText
      .Name = LNGGetText(2326, vbNullString) 'ATA
      .Size = 50
      .Key = K_ATA
      .Value = m_Ata
      .TabIndex = 1
    End With
    
    With .Add(Nothing, cscLgjHawbbl)
      .PropertyType = cspText
      .Name = LNGGetText(2327, vbNullString) 'HAWB/BL
      .Size = 50
      .Key = K_HAWBBL
      .Value = m_Hawbbl
      .TabIndex = 1
    End With
    
    With .Add(Nothing, cscLgjEtd)
      .PropertyType = cspText
      .Name = LNGGetText(2328, vbNullString) 'ETD
      .Size = 50
      .Key = K_ETD
      .Value = m_Etd
      .TabIndex = 1
    End With
    
    With .Add(Nothing, cscLgjEta)
      .PropertyType = cspText
      .Name = LNGGetText(2329, vbNullString) 'ETA
      .Size = 50
      .Key = K_ETA
      .Value = m_Eta
      .TabIndex = 1
    End With
    
    With .Add(Nothing, cscLgjMawbbl)
      .PropertyType = cspText
      .Name = LNGGetText(2330, vbNullString) 'MAWB/BL
      .Size = 50
      .Key = K_MAWBBL
      .Value = m_Mawbbl
      .TabIndex = 1
    End With
    
    With .Add(Nothing, cscLgjFob)
      .PropertyType = cspText
      .Name = LNGGetText(2331, vbNullString) 'FOB
      .Size = 50
      .Key = K_FOB
      .Value = m_Fob
      .TabIndex = 1
    End With
    
    With .Add(Nothing, cscLgjGiro)
      .PropertyType = cspText
      .Name = LNGGetText(2332, vbNullString) 'Giro
      .Size = 50
      .Key = K_GIRO
      .Value = m_Giro
      .Left = 6100
      .TopFromProperty = cscLgjAta
      .TabIndex = 1
    End With
    
    With .Add(Nothing, cscLgjFlete)
      .PropertyType = cspText
      .Name = LNGGetText(2333, vbNullString) 'Flete
      .Size = 50
      .Key = K_FLETE
      .Value = m_Flete
      .TabIndex = 1
    End With
      
    With .Add(Nothing, cscMonId)
      .PropertyType = cspHelp
      .Table = csMoneda
      .Name = LNGGetText(1113, vbNullString) 'Moneda
      .Key = K_MON_ID
      .Value = m_Moneda
      .HelpId = m_mon_id
      .TabIndex = 1
    End With
    
    With .Add(Nothing, cscTransId)
      .PropertyType = cspHelp
      .Table = csTransporte
      .Name = LNGGetText(1050, vbNullString) 'Transporte
      .Key = K_TRANS_ID
      .Value = m_Transporte
      .HelpId = m_trans_id
      .TabIndex = 1
    End With
    
    With .Add(Nothing, cscBarcId)
      .PropertyType = cspHelp
      .Table = csBarco
      .Name = LNGGetText(2335, vbNullString) 'Vapor
      .Key = K_BARC_ID
      .Value = m_Barco
      .HelpId = m_Barc_id
    End With
    
    With .Add(Nothing, cscVueId)
      .PropertyType = cspHelp
      .Table = csVuelo
      .Name = LNGGetText(2336, vbNullString) 'Vuelo
      .Key = K_VUE_ID
      .Value = m_Vuelo
      .HelpId = m_Vue_id
      .TabIndex = 1
    End With
    
    With .Add(Nothing, cscPueId)
      .PropertyType = cspHelp
      .Table = csPuerto
      .Name = LNGGetText(2334, vbNullString) 'Aduana
      .Key = K_PUE_ID
      .Value = m_Puerto
      .HelpId = m_Pue_id
      .TabIndex = 1
    End With
      
    With .Add(Nothing, cscLgjDescrip)
      .PropertyType = cspText
      .SubType = cspMemo
      .Name = C_strDescrip
      .LeftFromProperty = cscLgjtId
      .Height = 880
      .Width = 6800
      .Size = 255
      .Key = K_DESCRIP
      .Value = m_Descrip
    End With
    
    Set c = .Add(Nothing, c_Items)
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      If Not pLoadItems(c) Then Exit Function
      .Name = LNGGetText(1371, vbNullString) 'Items
      .Key = K_ITEMS
      .TabIndex = 2
      .GridAdd = False
      .GridEdit = False
      .GridRemove = False
    End With
  
  End With

  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

Private Function Load(ByVal ID As Long) As Boolean
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  sqlstmt = "sp_LegajoGet " & ID

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.fields, cscLgjId)
    m_Titulo = gDB.ValField(rs.fields, cscLgjTitulo)
    m_Codigo = gDB.ValField(rs.fields, cscLgjCodigo)
    m_Descrip = gDB.ValField(rs.fields, cscLgjDescrip)
    m_Fecha = gDB.ValField(rs.fields, cscLgjFecha)
    
    m_Ata = gDB.ValField(rs.fields, cscLgjAta)
    m_Hawbbl = gDB.ValField(rs.fields, cscLgjHawbbl)
    m_Etd = gDB.ValField(rs.fields, cscLgjEtd)
    m_Eta = gDB.ValField(rs.fields, cscLgjEta)
    m_Mawbbl = gDB.ValField(rs.fields, cscLgjMawbbl)
    m_Fob = gDB.ValField(rs.fields, cscLgjFob)
    m_Giro = gDB.ValField(rs.fields, cscLgjGiro)
    m_Flete = gDB.ValField(rs.fields, cscLgjFlete)
    
    m_est_id = gDB.ValField(rs.fields, cscEstId)
    m_cli_id = gDB.ValField(rs.fields, cscCliId)
    m_Estado = gDB.ValField(rs.fields, cscEstNombre)
    m_Cliente = gDB.ValField(rs.fields, cscCliNombre)
    m_Modificado = gDB.ValField(rs.fields, cscModificado)
    m_Lgjt_id = gDB.ValField(rs.fields, cscLgjtId)
    m_LegajoTipo = gDB.ValField(rs.fields, cscLgjtNombre)
    m_Creado = gDB.ValField(rs.fields, cscCreado)
    m_Modifico = gDB.ValField(rs.fields, cscModifico)
    m_Activo = gDB.ValField(rs.fields, cscActivo)

    m_mon_id = gDB.ValField(rs.fields, cscMonId)
    m_trans_id = gDB.ValField(rs.fields, cscTransId)
    m_Barc_id = gDB.ValField(rs.fields, cscBarcId)
    m_Vue_id = gDB.ValField(rs.fields, cscVueId)
    m_Pue_id = gDB.ValField(rs.fields, cscPueId)

    m_Moneda = gDB.ValField(rs.fields, cscMonNombre)
    m_Transporte = gDB.ValField(rs.fields, cscTransNombre)
    m_Barco = gDB.ValField(rs.fields, cscBarcNombre)
    m_Vuelo = gDB.ValField(rs.fields, cscVueNombre)
    m_Puerto = gDB.ValField(rs.fields, cscPueNombre)

  Else
    m_Id = csNO_ID
    m_Titulo = vbNullString
    m_Codigo = vbNullString
    m_Descrip = vbNullString
    m_Fecha = Date
    
    m_Ata = vbNullString
    m_Hawbbl = vbNullString
    m_Etd = vbNullString
    m_Eta = vbNullString
    m_Mawbbl = vbNullString
    m_Fob = vbNullString
    m_Giro = vbNullString
    m_Flete = vbNullString
    
    m_est_id = csEEstado.csEEst_Pendiente
    gDB.GetData csTEstado, cscEstId, m_est_id, cscEstNombre, m_Estado
    m_cli_id = csNO_ID
    m_Cliente = vbNullString
    m_Lgjt_id = csNO_ID
    m_LegajoTipo = vbNullString
    
    m_mon_id = csNO_ID
    m_trans_id = csNO_ID
    m_Barc_id = csNO_ID
    m_Vue_id = csNO_ID
    m_Pue_id = csNO_ID
    
    m_Moneda = vbNullString
    m_Transporte = vbNullString
    m_Barco = vbNullString
    m_Vuelo = vbNullString
    m_Puerto = vbNullString
    
    m_Modificado = csNoDate
    m_Creado = csNoDate
    m_Modifico = 0
    m_Activo = True
    
    pSetMonedaDefault

  End If

  Load = True
End Function

Private Function pLoadItems(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "select ParteDiario.*  from ParteDiario " & _
            " where lgj_id = " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadItems", C_Module) Then Exit Function
  
  Dim o As cIABMGridColumn
  
  With Propiedad.Grid.Columns
    
    .Clear
    
    Set o = .Add(Nothing)
    o.Visible = False
    o.Key = KI_PTD_ID
    
    Set o = .Add(Nothing)
    o.Name = LNGGetText(1065, vbNullString) 'Número
    o.PropertyType = cspText
    o.Width = 1200
    o.Key = KI_NUMERO
    
    Set o = .Add(Nothing)
    o.Name = LNGGetText(1864, vbNullString) 'Titulo
    o.PropertyType = cspText
    o.Width = 2500
    o.Key = KI_TITULO
    
    Set o = .Add(Nothing)
    o.Name = LNGGetText(1211, vbNullString) 'Observ.
    o.PropertyType = cspText
    o.Width = 3000
    o.Key = KI_DESCRIP
    
    Set o = .Add(Nothing)
    o.Name = LNGGetText(2337, vbNullString) 'Inicio
    o.PropertyType = cspDate
    o.Width = 1200
    o.Key = KI_FECHAINI
    
    Set o = .Add(Nothing)
    o.Name = LNGGetText(2338, vbNullString) 'Fin
    o.PropertyType = cspDate
    o.Width = 1200
    o.Key = KI_FECHAFIN
    
    Set o = .Add(Nothing)
    o.Name = LNGGetText(2339, vbNullString) 'Alarma
    o.PropertyType = cspDate
    o.Width = 1200
    o.Key = KI_ALARMA
    
    Set o = .Add(Nothing)
    o.Name = LNGGetText(1568, vbNullString) 'Estado
    o.PropertyType = cspText
    o.Width = 1000
    o.Key = KI_CUMPLIDA
  End With
  
  Dim F  As cIABMGridRow
  Dim fv As cIABMGridCellValue
  
  While Not rs.EOF
  
    Set F = Propiedad.Grid.Rows.Add(Nothing, rs(cscPtdId).Value)
    
    Set fv = F.Add(Nothing)
    fv.Value = rs(cscPtdId).Value
    fv.Key = KI_PTD_ID

    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscPtdNumero)
    fv.Key = KI_NUMERO
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscPtdTitulo)
    fv.Key = KI_TITULO
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscPtdDescrip)
    fv.Key = KI_DESCRIP
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscPtdFechaini)
    fv.Key = KI_FECHAINI
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscPtdFechafin)
    fv.Key = KI_FECHAFIN
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscPtdAlarma)
    fv.Key = KI_ALARMA
    
    Set fv = F.Add(Nothing)
    Select Case gDB.ValField(rs.fields, cscPtdCumplida)
      Case csECumplida_Rechazada
        fv.Value = LNGGetText(2055, vbNullString) 'Rechazado
      Case csECumplida_Cumplida
        fv.Value = LNGGetText(2340, vbNullString) 'Cumplido
      Case csECumplida_Pendiente
        fv.Value = LNGGetText(1609, vbNullString) 'Pendiente
    End Select
    fv.Key = KI_CUMPLIDA
    
    rs.MoveNext
  Wend
  
  pLoadItems = True
End Function

Private Sub pEditParte(ByVal ptd_id As Long)
  Dim objEdit As cIEditGeneric
  Dim objIAbm As cIABMGeneric
  
  Set objIAbm = New cABMGeneric
  Set objEdit = New cParteDiario
  Set objEdit.ObjABM = objIAbm
  
  objEdit.Edit ptd_id
End Sub

Private Sub pSetMonedaDefault()
  Dim rs As ADODB.Recordset
  Dim sqlstmt As String
  
  sqlstmt = "select mon_id, mon_nombre from moneda where mon_legal <> 0"
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  If rs.EOF Then Exit Sub
  
  m_mon_id = gDB.ValField(rs.fields, cscMonId)
  m_Moneda = gDB.ValField(rs.fields, cscMonNombre)
End Sub

' construccion - destruccion

Private Sub Class_Initialize()
  On Error GoTo ControlError

  c_strTitle = LNGGetText(2318, vbNullString) 'Legajos
  c_ErrorSave = LNGGetText(2319, vbNullString) 'Error al grabar el Legajo

  Dim Cfg As cEnvioConfig
  Set Cfg = New cEnvioConfig
  If Not Cfg.Load Then Exit Sub
  m_Tal_id = Cfg.Tal_Id_Legajo

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

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
'  If Err.Number Then Resume ExitProc
'ExitProc:
'  On Error Resume Next

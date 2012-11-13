VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cParteDiario"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGeneric
Implements CSInterfacesABM.cIABMClient
Implements CSMenu.cIMenuClient
'--------------------------------------------------------------------------------
' cParteDiario
' 27-12-03

'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cParteDiario"

Private Const csAlumno = 37004

Private Const c_docDescrip  As String = "doc_descrip"
Private Const c_docnro      As String = "doc_nro"

Private Const K_NUMERO                         As Integer = 1
Private Const K_TITULO                         As Integer = 2
Private Const K_DESCRIP                        As Integer = 3
Private Const K_FECHAINI                       As Integer = 4
Private Const K_FECHAFIN                       As Integer = 5
Private Const K_ALARMA                         As Integer = 6
Private Const K_CUMPLIDA                       As Integer = 8
Private Const K_RECURRENTE                     As Integer = 10
Private Const K_US_ID_RESPONSABLE              As Integer = 11
Private Const K_US_ID_ASIGNADOR                As Integer = 12
Private Const K_CONT_ID                        As Integer = 13
Private Const K_TAREST_ID                      As Integer = 14
Private Const K_PRIO_ID                        As Integer = 15
Private Const K_LGJ_ID                         As Integer = 16
Private Const K_CLI_ID                         As Integer = 17
Private Const K_LISTAUSUARIOS                  As Integer = 18

Private Const K_DOCT_ID                        As Integer = 19
Private Const K_DOC_ID                         As Integer = 20
Private Const K_VTO_AVISO                      As Integer = 21
Private Const K_VTO_CUMPLIDO                   As Integer = 22

Private Const K_PROV_ID                        As Integer = 23
Private Const K_PRIVADO                        As Integer = 24

Private Const K_ALUM_ID                        As Integer = 25

' pseudo-constantes
Private c_ErrorSave As String

' estructuras
' variables privadas
Private m_Id                           As Long
Private m_Numero                       As Long
Private m_Titulo                       As String
Private m_Descrip                      As String
Private m_FechaIni                     As Date
Private m_FechaFin                     As Date
Private m_Alarma                       As Date
Private m_Cumplida                     As Long
Private m_Recurrente                   As Long
Private m_Us_id_responsable            As Long
Private m_Responsable                  As String
Private m_Us_id_asignador              As Long
Private m_Asignador                    As String
Private m_Cont_id                      As Long
Private m_Contacto                     As String
Private m_Tarest_id                    As Long
Private m_Estado                       As String
Private m_Prio_id                      As Long
Private m_Prioridad                    As String
Private m_lgj_id                       As Long
Private m_Legajo                       As String
Private m_cli_id                       As Long
Private m_Cliente                      As String

Private m_prov_id                      As Long
Private m_proveedor                    As String

Private m_alum_id                      As Long
Private m_alumno                       As String

Private m_privado                      As Boolean

Private m_ListaUsuariosId              As String

Private m_bNoChangeDoc                 As Boolean
Private m_DocumentoTipo                As String
Private m_DoctId                       As Long
Private m_DocNro                       As String
Private m_DocDescrip                   As String
Private m_DocId                        As Long
Private m_VtoAviso                     As Boolean
Private m_VtoCumplido                  As csE_VencimientoCumplido

Private m_Tal_id                       As Long

'OJO HASTA ACA

Private m_Editing           As Boolean
Private m_Host              As CSMenu.cIMenuHost
Private m_ObjAbm            As cIABMGeneric
Private m_ObjTree           As Object

Private m_IsNew             As Boolean

Private m_BranchId          As Long
Private m_TreeId            As Long
Private m_Copy              As Boolean

Private m_UserCfg           As cUsuarioConfig

' Properties publicas

Public Property Get ID() As Long
  ID = m_Id
End Property

Public Property Get Nombre() As String
  Nombre = m_Titulo
End Property

Public Property Get Codigo() As String
  Codigo = m_Numero
End Property

' Properties privadas
' funciones publicas
Public Function AddParteToDoc(ByVal DoctId As Long, _
                              ByVal DocId As Long, _
                              ByVal InModalWindow As Boolean) As Boolean
  
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_ParteDiarioGetDocInfo " & DoctId & "," & DocId
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  If Not rs.EOF Then
    
    m_bNoChangeDoc = True
    m_DocumentoTipo = gDB.ValField(rs.fields, cscDoctNombre)
    m_DocNro = gDB.ValField(rs.fields, c_docnro)
    m_DoctId = DoctId
    m_DocId = DocId
    m_DocDescrip = gDB.ValField(rs.fields, c_docDescrip)
    
    Select Case DoctId

      Case 1, 7, 9
        m_cli_id = gDB.ValField(rs.fields, cscCliId)
        m_Cliente = gDB.ValField(rs.fields, cscCliNombre)
    
      Case 2, 8, 10
        m_prov_id = gDB.ValField(rs.fields, cscProvId)
        m_proveedor = gDB.ValField(rs.fields, cscProvNombre)
    
      Case 4, 25
        m_prov_id = gDB.ValField(rs.fields, cscProvId)
        m_proveedor = gDB.ValField(rs.fields, cscProvNombre)
        
      Case 35, 36
        m_prov_id = gDB.ValField(rs.fields, cscProvId)
        m_proveedor = gDB.ValField(rs.fields, cscProvNombre)
    
      Case 6, 23
        m_prov_id = gDB.ValField(rs.fields, cscProvId)
        m_proveedor = gDB.ValField(rs.fields, cscProvNombre)
    
      Case 3, 24
        m_cli_id = gDB.ValField(rs.fields, cscCliId)
        m_Cliente = gDB.ValField(rs.fields, cscCliNombre)
        
      Case 5, 22
        m_cli_id = gDB.ValField(rs.fields, cscCliId)
        m_Cliente = gDB.ValField(rs.fields, cscCliNombre)
    
      Case 11, 39
        m_cli_id = gDB.ValField(rs.fields, cscCliId)
        m_Cliente = gDB.ValField(rs.fields, cscCliNombre)
        
      Case 13
        m_cli_id = gDB.ValField(rs.fields, cscCliId)
        m_Cliente = gDB.ValField(rs.fields, cscCliNombre)
    
      Case 16
        m_prov_id = gDB.ValField(rs.fields, cscProvId)
        m_proveedor = gDB.ValField(rs.fields, cscProvNombre)
        
      Case 26
        m_cli_id = gDB.ValField(rs.fields, cscCliId)
        m_Cliente = gDB.ValField(rs.fields, cscCliNombre)
        
      Case csAlumno
        m_alum_id = gDB.ValField(rs.fields, cscAlumId)
        m_alumno = gDB.ValField(rs.fields, cscAlumNombre)
        
      Case 17
        
      Case 14
    
      Case 30, 34
        
      Case 38
        
      Case 44
        m_prov_id = gDB.ValField(rs.fields, cscProvId)
        m_proveedor = gDB.ValField(rs.fields, cscProvNombre)
        
      Case 45
        m_cli_id = gDB.ValField(rs.fields, cscCliId)
        m_Cliente = gDB.ValField(rs.fields, cscCliNombre)
        
      Case 2007
        m_cli_id = gDB.ValField(rs.fields, cscCliId)
        m_Cliente = gDB.ValField(rs.fields, cscCliNombre)
        
      Case 2006
        m_cli_id = gDB.ValField(rs.fields, cscCliId)
        m_Cliente = gDB.ValField(rs.fields, cscCliNombre)
        
      Case 1017
        
      Case 1702
        
      Case 15001

     
    End Select
  
  End If
  
  Set m_ObjAbm = CSKernelClient2.CreateObject("CSABMInterface2.cABMGeneric")
  
  cIEditGeneric_Edit csNO_ID, InModalWindow
  
End Function

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

  Doc.ClientTable = csTParteDiario
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
  Select Case MessageID
    Case MSG_BUTTON_TEXT_CLICK
      Dim iProp As cIABMProperty
      Set iProp = Info
      Select Case iProp.Key
        Case K_LISTAUSUARIOS
          pSelectUsuarios iProp
      End Select
  End Select
  
  cIABMClient_MessageEx = True
End Function

Private Sub cIABMClient_DiscardChanges()
    LoadCollection
End Sub

Private Function cIABMClient_Copy() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True
  
  On Error GoTo ControlError
  
  With m_ObjAbm.Properties(cscPtdTitulo)
    .Value = C_CopiaDe & .Value
  End With
  
  With m_ObjAbm.Properties(cscPtdNumero)
    .Value = 0
  End With
  
  With m_ObjAbm.Properties(cscPtdCumplida)
    .ListItemData = csECumplida_Pendiente
  End With
  
  Dim d         As Long
  Dim FechaFin  As Date
  Dim FechaIni  As Date
  Dim Alarma    As Date
  
  d = DateDiff("d", m_FechaIni, m_FechaFin)
  FechaFin = DateAdd("d", d, Date)
  d = DateDiff("d", m_FechaIni, m_Alarma)
  Alarma = DateAdd("d", d, Date)
  FechaIni = Date
  
  With m_ObjAbm.Properties(cscPtdFechafin)
    .Value = FechaFin
  End With
  With m_ObjAbm.Properties(cscPtdFechaini)
    .Value = FechaIni
  End With
  With m_ObjAbm.Properties(cscPtdAlarma)
    .Value = Alarma
  End With
  
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscPtdFechafin)
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscPtdFechaini)
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscPtdAlarma)
  
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscPtdNumero)
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscPtdTitulo)
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscPtdCumplida)
  
  m_Copy = True
  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClient_Copy", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIABMClient_ListAdHock(List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClient_Load()

End Sub

Private Function cIABMClient_PropertyChange(ByVal Key As Integer) As Boolean
  Dim fecha   As Date
  Dim AbmObj  As cABMGeneric
  
  Select Case Key
    
    Case K_CLI_ID
      
      pSetVendedor
    
    Case K_FECHAINI
    
      If m_UserCfg.PtdFecha Then
      
        With m_ObjAbm.Properties
          
          fecha = .Item(cscPtdFechaini).Value
          
          Set AbmObj = m_ObjAbm
          
          .Item(cscPtdFechafin).Value = fecha
          AbmObj.ShowValue .Item(cscPtdFechafin)
          
          .Item(cscPtdAlarma).Value = fecha
          AbmObj.ShowValue .Item(cscPtdAlarma)
          
        End With
      End If
    
  End Select

End Function

Private Function cIABMClient_Save() As Boolean
  Dim register As cRegister
  Dim fields   As cFields
  Dim Tal      As cTalonario

  If m_Tal_id = csNO_ID Then
    MsgWarning LNGGetText(2320, vbNullString)
                'Debe configurar un talonario para los partes diarios
    Exit Function
  End If

  Set register = New cRegister
  
  With register
    Set fields = .fields
    .fieldId = cscPtdId
    .Table = csTParteDiario
  
    If m_Copy Then
      .ID = csNew
    Else
      .ID = m_Id
    End If
  End With
  
  ' Si es nuevo obtengo el numero
  If register.ID = csNew Then
    
    Set Tal = New cTalonario
    m_Numero = Tal.GetNextNumber(m_Tal_id, vbNullString, False)
  End If
  
  Dim IProperty As cIABMProperty
  Dim UserIDs   As String
  
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_NUMERO
          fields.Add2 cscPtdNumero, m_Numero, csLong
        Case K_TITULO
          fields.Add2 cscPtdTitulo, .Value, csText
        Case K_DESCRIP
          fields.Add2 cscPtdDescrip, .Value, csText
        Case K_FECHAINI
          fields.Add2 cscPtdFechaini, .Value, csDate
        Case K_FECHAFIN
          fields.Add2 cscPtdFechafin, .Value, csDate
        Case K_ALARMA
          fields.Add2 cscPtdAlarma, .Value, csDate
        Case K_CUMPLIDA
          fields.Add2 cscPtdCumplida, .ListItemData, csInteger
        Case K_RECURRENTE
          fields.Add2 cscPtdRecurrente, .ListItemData, csInteger
        Case K_US_ID_RESPONSABLE
          fields.Add2 cscusidResponsable, .HelpId, csId
        Case K_LISTAUSUARIOS
          UserIDs = pGetListaUsuariosId(.Value)
          fields.Add2 cscPtdListausuariosId, UserIDs, csText
        Case K_US_ID_ASIGNADOR
          fields.Add2 cscusidAsignador, .HelpId, csId
          If gLastUser Is Nothing Or gLastUser Is CSOAPI2.User Then
            Set gLastUser = New cUsuario
          End If
          gLastUser.GetUser .HelpId
        Case K_CONT_ID
          fields.Add2 cscContId, .HelpId, csId
        Case K_TAREST_ID
          fields.Add2 cscTarestId, .HelpId, csId
        Case K_PRIO_ID
          fields.Add2 cscPrioId, .HelpId, csId
        Case K_LGJ_ID
          fields.Add2 cscLgjId, .HelpId, csId
        Case K_CLI_ID
          fields.Add2 cscCliId, .HelpId, csId
        Case K_PROV_ID
          fields.Add2 cscProvId, .HelpId, csId
        Case K_DOCT_ID
          fields.Add2 cscDoctId, .HelpId, csId
        Case K_DOC_ID
          fields.Add2 cscDocId, .HelpId, csId
        Case K_VTO_AVISO
          fields.Add2 cscPtdVtoAviso, Val(.Value), csBoolean
        Case K_VTO_CUMPLIDO
          fields.Add2 cscPtdVtoAviso, .ListItemData, csLong
        Case K_PRIVADO
          fields.Add2 cscPtdPrivado, Val(.Value), csBoolean
        Case K_ALUM_ID
          fields.Add2 cscAlumId, .HelpId, csId
      End Select
    End With
  Next
    
  fields.HaveLastUpdate = True
  fields.HaveWhoModify = True
  
  If Not register.BeginTrans(gDB) Then Exit Function
  
  If Not gDB.Save(register, , "cIABMClient_Save", C_Module, c_ErrorSave) Then Exit Function
  
  If Not Tal Is Nothing Then
    If Not Tal.UpdateLastUsedNumber(m_Tal_id, m_Numero) Then GoTo SaveError
  End If
  
  If Not register.CommitTrans() Then GoTo SaveError
  
  m_Copy = False
  cIABMClient_Save = Load(register.ID)
  
  If m_UserCfg.NuevoPTDAlGrabar Then
  
    Dim AbmGen As cABMGeneric
    Set AbmGen = m_ObjAbm

    AbmGen.SendNewABM = True
  End If
  
  'pSaveAviso UserIDs
  
  Exit Function
SaveError:
End Function

Private Function cIABMClient_Terminate() As Boolean
  m_Editing = False
  
  cIABMClient_Terminate = True
  ' Este objeto puede no cumplir con la interfaz esperada, asi que si hay un error no
  ' le doy bola
  On Error GoTo ControlError
  If m_Id = csNO_ID Then Exit Function
  If m_ObjTree Is Nothing Then Exit Function
  
  m_ObjTree.sqlstmt = "sp_lsdoc_partediario"
  
  If m_IsNew Then
    m_ObjTree.AddLine m_Id
  Else
    m_ObjTree.RefreshLine m_Id
  End If
ControlError:
End Function

Private Property Get cIABMClient_Title() As String
    cIABMClient_Title = LNGGetText(2348, vbNullString)  'Partes Diarios
End Property

Private Function cIABMClient_Validate() As Boolean
  Dim bTitulo   As Boolean
  Dim IProperty As cIABMProperty

  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_TITULO
          If Not ValEmpty(.Value, csText) Then
            bTitulo = True
          End If
        Case K_DESCRIP
          If Not ValEmpty(.Value, csText) Then
            bTitulo = True
          End If
        Case K_US_ID_RESPONSABLE
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(2349, vbNullString)  'Debe indicar un Responsable
            Exit Function
          End If
        Case K_US_ID_ASIGNADOR
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(2350, vbNullString)  'Debe indicar quién asigna este Parte
            Exit Function
          End If
        Case K_TAREST_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(2322, vbNullString)  'Debe indicar un Estado
            Exit Function
          End If
      End Select
    End With
  Next

  If Not bTitulo Then
    MsgInfo LNGGetText(2351, vbNullString)  'Debe indicar un Título o una Descripción
    Exit Function
  End If

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
    cIEditGeneric_ShowList = SecurityCanAccess(csPreEnvListParteDiario)
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
  If Not SecurityCanAccess(csPreEnvDeleteParteDiario) Then Exit Function

  Dim sqlstmt As String
  
  sqlstmt = "Delete ParteDiario where ptd_id = " & ID
  
  cIEditGeneric_Delete = gDB.Execute(sqlstmt, "cIEditGeneric_Delete", C_Module)
End Function

Private Function cIEditGeneric_Search(ID As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(ID As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If ID = csNO_ID Then
    m_IsNew = True
    If Not SecurityCanAccess(csPreEnvNewParteDiario) Then Exit Function
  Else
    m_IsNew = False
    If Not SecurityCanAccess(csPreEnvEditParteDiario) Then Exit Function
  End If
  
  If m_Tal_id = csNO_ID Then
    MsgWarning LNGGetText(2320, vbNullString)
                'Debe configurar un talonario para los partes diarios
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

' funciones privadas
Private Sub pSetVendedor()
  Dim sqlstmt As String
  Dim rs      As Recordset
  Dim iProp   As cIABMProperty
  
  Set iProp = m_ObjAbm.Properties(cscusidResponsable)
  
  sqlstmt = "select usuario.us_id, us_nombre " & vbCrLf
  sqlstmt = sqlstmt & "from cliente,vendedor,usuario " & vbCrLf
  sqlstmt = sqlstmt & "where cliente.ven_id = vendedor.ven_id " & vbCrLf
  sqlstmt = sqlstmt & "and usuario.us_id = vendedor.us_id " & vbCrLf
  sqlstmt = sqlstmt & "and cliente.cli_id = " & m_ObjAbm.Properties(cscCliId).HelpId & vbCrLf
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  If rs.EOF Then Exit Sub
  
  iProp.HelpId = gDB.ValField(rs.fields, 0)
  iProp.Value = gDB.ValField(rs.fields, 1)
  
  m_ObjAbm.ShowValue iProp
End Sub

Private Function LoadCollection() As Boolean
  
  Dim AbmGen As cABMGeneric
  Set AbmGen = m_ObjAbm
  
  AbmGen.MinHeight = 8600
  
  Const c_tab_doc = 1
  
  With m_ObjAbm
    With .Tabs
    
      .Clear
      With .Add(Nothing)
        .Name = C_strGeneral
      End With
      With .Add(Nothing)
        .Name = LNGGetText(1567, vbNullString)  'Documento
        .Index = c_tab_doc
      End With
    
    End With
    With .Properties
      .Clear
  
      With .Add(Nothing, cscPtdNumero)
        .PropertyType = cspNumeric
        .SubType = cspInteger
        .Enabled = False
        .FontBold = True
        .Name = LNGGetText(1065, vbNullString)  'Número
        .Top = 140
        .Left = 6100
        .Width = 1000
        .LeftLabel = -800
        .LeftNotChange = True
        .TopNotChange = True
        .Value = m_Numero
        .Key = K_NUMERO
      End With
  
      With .Add(Nothing, cscPtdTitulo)
        .PropertyType = cspText
        .SubType = cspMemo
        .Name = LNGGetText(1864, vbNullString)  'Título
        .Size = 5000
        .Key = K_TITULO
        .Value = m_Titulo
        .Width = 5700
        .Height = 600
      End With
    
      With .Add(Nothing, cscPtdPrivado)
        .PropertyType = cspCheck
        .Name = LNGGetText(4835, vbNullString)  'Privado
        .Value = CInt(m_privado)
        .LeftNotChange = True
        .Left = 8100
        .LeftLabel = -700
        .Key = K_PRIVADO
        .TopFromProperty = cscPtdTitulo
      End With
    
      With .Add(Nothing, cscPtdDescrip)
        .PropertyType = cspText
        .SubType = cspMemo
        .Height = 1560
        .Width = 6800
        .Name = C_strDescrip
        .Size = 1000
        .Key = K_DESCRIP
        .Value = m_Descrip
        .TopFromProperty = cscPtdTitulo
        .TopToPrevious = 640
      End With
    
      With .Add(Nothing, cscPtdListausuariosId)
        .PropertyType = cspText
        .SubType = cspTextButton
        .Name = LNGGetText(2352, vbNullString)  'Notificar a
        .Size = 1000
        .Key = K_LISTAUSUARIOS
        .Value = pGetListaUsuarios(m_ListaUsuariosId)
        .Width = 6800
      End With
      
      With .Add(Nothing, cscusidResponsable)
        .PropertyType = cspHelp
        .Table = csUsuario
        .Name = LNGGetText(1822, vbNullString)  'Responsable
        .Key = K_US_ID_RESPONSABLE
        .Value = m_Responsable
        .HelpId = m_Us_id_responsable
      End With
      
      With .Add(Nothing, cscusidAsignador)
        .PropertyType = cspHelp
        .Table = csUsuario
        .Name = LNGGetText(1960, vbNullString)  'Generado por
        .Key = K_US_ID_ASIGNADOR
        .Value = m_Asignador
        .HelpId = m_Us_id_asignador
      End With
    
      With .Add(Nothing, cscLgjId)
        .PropertyType = cspHelp
        .Table = csLegajo
        .Name = LNGGetText(2353, vbNullString)  'Carpeta
        .Key = K_LGJ_ID
        .Value = m_Legajo
        .HelpId = m_lgj_id
      End With
    
      With .Add(Nothing, cscCliId)
        .PropertyType = cspHelp
        .Table = csCliente
        .Name = LNGGetText(1150, vbNullString)  'Cliente
        .Key = K_CLI_ID
        .Value = m_Cliente
        .HelpId = m_cli_id
      End With
    
      With .Add(Nothing, cscProvId)
        .PropertyType = cspHelp
        .Table = csProveedor
        .Name = LNGGetText(1151, vbNullString)  'Proveedor
        .Key = K_PROV_ID
        .Value = m_proveedor
        .HelpId = m_prov_id
      End With
    
      With .Add(Nothing, cscAlumId)
        .PropertyType = cspHelp
        .Table = csAlumno
        .Name = LNGGetText(4692, vbNullString) 'Alumno
        .Key = K_ALUM_ID
        .Value = m_alumno
        .HelpId = m_alum_id
      End With

      With .Add(Nothing, cscPrioId)
        .PropertyType = cspHelp
        .Table = csPrioridad
        .Name = LNGGetText(1825, vbNullString)  'Prioridad
        .Key = K_PRIO_ID
        .Value = m_Prioridad
        .HelpId = m_Prio_id
      End With
    
      With .Add(Nothing, cscPtdRecurrente)
        .PropertyType = cspList
        .Name = LNGGetText(2354, vbNullString)  'Se repite cada
        .Key = K_RECURRENTE
        .ListWhoSetItem = csListItemData
        .ListItemData = m_Recurrente
      
        With .List
          With .Add(Nothing, csERecur_Once)
            .ID = csERecur_Once
            .Value = LNGGetText(2355, vbNullString)  '(Una sola vez)
          End With
      
          With .Add(Nothing, csERecur_Day)
            .ID = csERecur_Day
            .Value = LNGGetText(1214, vbNullString)  'Día
          End With
          
          With .Add(Nothing, csERecur_Week)
            .ID = csERecur_Week
            .Value = LNGGetText(2356, vbNullString)  'Semana
          End With
      
          With .Add(Nothing, csERecur_Month)
            .ID = csERecur_Month
            .Value = LNGGetText(1215, vbNullString)  'Mes
          End With
          
          With .Add(Nothing, csERecur_Year)
            .ID = csERecur_Year
            .Value = LNGGetText(1216, vbNullString)  'Año
          End With
      
          With .Add(Nothing, csERecur_TwoMonth)
            .ID = csERecur_TwoMonth
            .Value = LNGGetText(2357, vbNullString)  'Bimestre
          End With
      
          With .Add(Nothing, csERecur_TreeMonth)
            .ID = csERecur_TreeMonth
            .Value = LNGGetText(2358, vbNullString)  'Trimestre
          End With
      
          With .Add(Nothing, csERecur_FourMonth)
            .ID = csERecur_FourMonth
            .Value = LNGGetText(2359, vbNullString)  'Cuatrimestre
          End With
      
          With .Add(Nothing, csERecur_SixMonth)
            .ID = csERecur_SixMonth
            .Value = LNGGetText(2360, vbNullString)  'Semestre
          End With
        End With
      
        .Left = 6110
        .TopFromProperty = cscusidResponsable
      End With
    
      With .Add(Nothing, cscPtdFechaini)
        .PropertyType = cspDate
        .Name = LNGGetText(2361, vbNullString)  'Fecha inicio"
        .Key = K_FECHAINI
        .Value = m_FechaIni
      End With
      
      With .Add(Nothing, cscPtdAlarma)
        .PropertyType = cspDate
        .Name = LNGGetText(2339, vbNullString)  'Alarma
        .Key = K_ALARMA
        .Value = m_Alarma
      End With
    
      With .Add(Nothing, cscPtdFechafin)
        .PropertyType = cspDate
        .Name = LNGGetText(2362, vbNullString)  'Fecha Fin
        .Key = K_FECHAFIN
        .Value = m_FechaFin
      End With
    
      With .Add(Nothing, cscPtdCumplida)
        .PropertyType = cspList
        .Name = LNGGetText(2363, vbNullString)  'Cumplida
        .Key = K_CUMPLIDA
        .ListWhoSetItem = csListItemData
        .ListItemData = m_Cumplida
      
        With .List
          With .Add(Nothing, csECumplida_Pendiente)
            .ID = csECumplida_Pendiente
            .Value = LNGGetText(2364, vbNullString)  '(Pendiente)
          End With
      
          With .Add(Nothing, csECumplida_Cumplida)
            .ID = csECumplida_Cumplida
            .Value = LNGGetText(2340, vbNullString)  'Cumplido
          End With
          
          With .Add(Nothing, csECumplida_Rechazada)
            .ID = csECumplida_Rechazada
            .Value = LNGGetText(2055, vbNullString)  'Rechazado
          End With
        End With
      End With
    
      With .Add(Nothing, cscContId)
        .PropertyType = cspHelp
        .Table = csContacto
        .Name = LNGGetText(1035, vbNullString)  'Contacto
        .Key = K_CONT_ID
        .Value = m_Contacto
        .HelpId = m_Cont_id
      End With
    
      With .Add(Nothing, cscTarestId)
        .PropertyType = cspHelp
        .Table = csTareaEstado
        .Name = LNGGetText(1568, vbNullString)  'Estado
        .Key = K_TAREST_ID
        .Value = m_Estado
        .HelpId = m_Tarest_id
      End With
      
      With .Add(Nothing, cscPtdVtoAviso)
        .PropertyType = cspCheck
        .Name = LNGGetText(2365, vbNullString)  'Aviso de Vto./Cobranza/Pago
        .Value = CInt(m_VtoAviso)
        .LeftNotChange = True
        .Left = 2680
        .LeftLabel = -2300
        .TabIndex = 1
        .Key = K_VTO_AVISO
      End With
      
      With .Add(Nothing, cscPtdVtoCumplido)
        .PropertyType = cspList
        .Name = LNGGetText(1568, vbNullString)  'Estado
        With .List
          With .Add(Nothing)
            .ID = csE_VencimientoCumplido.csEPtdVtoPendiente
            .Value = LNGGetText(1609, vbNullString)  'Pendiente
          End With
          With .Add(Nothing)
            .ID = csE_VencimientoCumplido.csEPtdVtoCumplido
            .Value = LNGGetText(2340, vbNullString)  'Cumplido
          End With
          With .Add(Nothing)
            .ID = csE_VencimientoCumplido.csEPtdVtoRechazado
            .Value = LNGGetText(2055, vbNullString)  'Rechazado
          End With
        End With
        .ListWhoSetItem = csListItemData
        .ListItemData = m_VtoCumplido
        .TabIndex = 1
        .Key = K_VTO_CUMPLIDO
      End With
      
      With .Add(Nothing, cscDoctId)
        .PropertyType = cspHelp
        .Table = csDocumentoTipo
        .Name = LNGGetText(2366, vbNullString)  'Tipo de Documento
        .Width = 4000
        .Value = m_DocumentoTipo
        .HelpId = m_DoctId
        .TabIndex = 1
        .Key = K_DOCT_ID
      End With
    
      With .Add(Nothing, cscDocId)
        .PropertyType = cspHelp
        
        Select Case m_DoctId
          Case csEDT_FacturaVenta
            .Table = csFacturaVenta
          Case csEDT_FacturaCompra
            .Table = csFacturaCompra
        End Select
        
        .Name = LNGGetText(1610, vbNullString)  'Comprobante
        .Width = 1500
        .Value = m_DocNro
        .HelpId = m_DocId
        .TabIndex = 1
        .Key = K_DOC_ID
      End With
    
      With .Add(Nothing, c_docDescrip)
        .PropertyType = cspLabel
        .Value = m_DocDescrip
        .FontName = "Courier New"
        .TabIndex = 1
        .Width = 7000
        .Height = 3000
      End With
    
    End With
  End With
    
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  AbmGen.SetIconFormABM 1
  
  LoadCollection = True
End Function

Private Function Load(ByVal ID As Long) As Boolean

  Dim sqlstmt As String

  sqlstmt = "sp_ParteDiarioGet " & ID

  Dim rs As Recordset

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.fields, cscPtdId)
    m_Numero = gDB.ValField(rs.fields, cscPtdNumero)
    m_Titulo = gDB.ValField(rs.fields, cscPtdTitulo)
    m_Descrip = gDB.ValField(rs.fields, cscPtdDescrip)
    m_FechaIni = gDB.ValField(rs.fields, cscPtdFechaini)
    m_FechaFin = gDB.ValField(rs.fields, cscPtdFechafin)
    m_Alarma = gDB.ValField(rs.fields, cscPtdAlarma)
    m_Cumplida = gDB.ValField(rs.fields, cscPtdCumplida)
    m_Recurrente = gDB.ValField(rs.fields, cscPtdRecurrente)
    m_Us_id_responsable = gDB.ValField(rs.fields, cscusidResponsable)
    m_Responsable = gDB.ValField(rs.fields, "responsable")
    m_Us_id_asignador = gDB.ValField(rs.fields, cscusidAsignador)
    m_Asignador = gDB.ValField(rs.fields, "asignador")
    m_Cont_id = gDB.ValField(rs.fields, cscContId)
    m_Contacto = gDB.ValField(rs.fields, cscContNombre)
    m_Tarest_id = gDB.ValField(rs.fields, cscTarestId)
    m_Estado = gDB.ValField(rs.fields, cscTarestNombre)
    m_Prio_id = gDB.ValField(rs.fields, cscPrioId)
    m_Prioridad = gDB.ValField(rs.fields, cscPrioNombre)
    m_lgj_id = gDB.ValField(rs.fields, cscLgjId)
    m_Legajo = gDB.ValField(rs.fields, cscLgjCodigo)
    m_cli_id = gDB.ValField(rs.fields, cscCliId)
    m_Cliente = gDB.ValField(rs.fields, cscCliNombre)
    
    m_prov_id = gDB.ValField(rs.fields, cscProvId)
    m_proveedor = gDB.ValField(rs.fields, cscProvNombre)
    
    m_alum_id = gDB.ValField(rs.fields, cscAlumId)
    m_alumno = gDB.ValField(rs.fields, cscAlumNombre)
    
    m_privado = gDB.ValField(rs.fields, cscPtdPrivado)
    
    m_ListaUsuariosId = gDB.ValField(rs.fields, cscPtdListausuariosId)
    
    m_VtoAviso = gDB.ValField(rs.fields, cscPtdVtoAviso)
    m_VtoCumplido = gDB.ValField(rs.fields, cscPtdVtoCumplido)
    m_DoctId = gDB.ValField(rs.fields, cscDoctId)
    m_DocumentoTipo = gDB.ValField(rs.fields, cscDoctNombre)
    m_DocId = gDB.ValField(rs.fields, cscDocId)
    m_DocNro = gDB.ValField(rs.fields, c_docnro)
    m_DocDescrip = gDB.ValField(rs.fields, c_docDescrip)
    
  Else
    
    If gLastUser Is Nothing Then Set gLastUser = CSOAPI2.User
    
    m_Id = csNO_ID
    m_Numero = 0
    m_Titulo = vbNullString
    m_Descrip = vbNullString
    m_FechaIni = Date
    m_FechaFin = DateAdd("m", 1, Date)
    m_Alarma = DateAdd("d", -2, m_FechaFin)
    m_Cumplida = csECumplida_Pendiente
    m_Recurrente = csERecur_Once
    m_Us_id_responsable = gLastUser.ID
    m_Responsable = gLastUser.Name
    
    m_Us_id_asignador = gLastUser.ID
    m_Asignador = gLastUser.Name
    
    m_Cont_id = csNO_ID
    m_Contacto = vbNullString
    
    pGetEstadoDefault
    
    m_Prio_id = csNO_ID
    m_Prioridad = vbNullString
    m_lgj_id = csNO_ID
    m_Legajo = vbNullString
    
    m_privado = False
    
    m_ListaUsuariosId = vbNullString
  
    m_VtoAviso = False
    m_VtoCumplido = csEPtdVtoPendiente
    
    If m_bNoChangeDoc Then
      m_bNoChangeDoc = False
    Else
      m_cli_id = csNO_ID
      m_Cliente = vbNullString
      m_prov_id = csNO_ID
      m_proveedor = vbNullString
      m_alum_id = csNO_ID
      m_alumno = vbNullString
      m_DoctId = csNO_ID
      m_DocumentoTipo = vbNullString
      m_DocId = csNO_ID
      m_DocNro = vbNullString
      m_DocDescrip = vbNullString
    End If
  End If

  Load = True
End Function

Private Sub pGetEstadoDefault()
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  m_Tarest_id = csNO_ID
  m_Estado = vbNullString
  
  sqlstmt = "select tarest_id,tarest_nombre from TareaEstado where tarest_default <> 0"
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
    
  If Not rs.EOF Then
    m_Tarest_id = ValField(rs.fields, cscTarestId)
    m_Estado = ValField(rs.fields, cscTarestNombre)
  Else
    Dim est_nombre As String
    
    If Not gDB.GetData(csTTareaEstado, cscTarestId, 1, cscTarestNombre, est_nombre) Then Exit Sub
  
    m_Tarest_id = 1
    m_Estado = est_nombre
  End If
End Sub

Private Function cIMenuClient_Initialize(F As Object, Host As CSMenu.cIMenuHost) As Boolean
  On Error GoTo ControlError
  Dim strMenu As String
  
  strMenu = LNGGetText(2367, vbNullString)  '&Agenda
  
  Set m_Host = Host
  m_Host.Server.AddMenu strMenu, csMenuAgenda, vbNullString, 1, False, False, False, True, False, Nothing
  m_Host.Server.AddMenu LNGGetText(2368, vbNullString), csPreEnvListParteDiario, strMenu, 0, True, False, False, False, False, Me
                        '&Parte Diario
  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, "cIMenuClient_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal ID As Long) As Variant
  m_Host.MenuListDocClick "CSABMInterface2.CABMGeneric", "CSEnvio2.cParteDiario", "CSABMInterface2.CABMGenericListDoc", "CSEnvio2.cParteDiarioListDoc", Me, LNGGetText(2348, vbNullString), 0
                                                                                                                                                              'Partes Diarios
End Function

Private Function pGetListaUsuarios(ByVal UserIDs As String) As String
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  UserIDs = Trim(UserIDs)
  If UserIDs = vbNullString Then Exit Function
  sqlstmt = "select us_nombre from usuario where us_id in (" & UserIDs & ")"
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  Dim rtn As String
  
  While Not rs.EOF
    rtn = rtn & gDB.ValField(rs.fields, 0) & ","
    rs.MoveNext
  Wend
  
  pGetListaUsuarios = RemoveLastColon(rtn)
End Function

Private Function pGetListaUsuariosId(ByVal UserNames As String) As String
  Dim sqlstmt   As String
  Dim rs        As Recordset
  Dim vUsers()  As String
  Dim i         As Long
  
  UserNames = Trim(UserNames)
  If UserNames = vbNullString Then Exit Function
  
  UserNames = Replace(UserNames, ";", ",")
  
  vUsers = Split(UserNames, ",")
  UserNames = vbNullString
  For i = 0 To UBound(vUsers)
    UserNames = UserNames & gDB.sqlString(vUsers(i)) & ","
  Next
  
  UserNames = RemoveLastColon(UserNames)
  
  sqlstmt = "select us_id from usuario where us_nombre in (" & UserNames & ")"
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  Dim rtn As String
  
  While Not rs.EOF
    rtn = rtn & gDB.ValField(rs.fields, 0) & ","
    rs.MoveNext
  Wend
  
  pGetListaUsuariosId = RemoveLastColon(rtn)
End Function

Private Function pSelectUsuarios(ByRef iProp As cIABMProperty) As Boolean
  Dim Help    As CSOAPI2.cHelp
  
  Set Help = New CSOAPI2.cHelp
  
  With Help.Show(m_ObjAbm.ObjForm, csUsuario, vbNullString, vbNullString, vbNullString, csTree)
    If .Cancel Then Exit Function
    
    Dim sqlstmt As String
    Dim rs      As Recordset
    
    If UCase$(Left$(.ID, 1)) = KEY_NODO Then
      sqlstmt = "sp_ArbGetAllHojas " & Val(Mid$(.ID, 2))
      
      If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
      
      sqlstmt = vbNullString
      While Not rs.EOF
        sqlstmt = sqlstmt & gDB.ValField(rs.fields, 0) & ","
        rs.MoveNext
      Wend
      
      iProp.Value = pGetListaUsuarios(RemoveLastColon(sqlstmt))
    Else
      
      iProp.Value = pGetListaUsuarios(.ID)
    End If
    m_ObjAbm.ShowValue iProp
  End With
  
  pSelectUsuarios = True
End Function

'Private Sub pSaveAviso(ByVal UserIDs As String)
'  Dim Aviso As cAviso
'  Dim i     As Long
'
'  If Trim(UserIDs) = vbnullstring Then Exit Sub
'
'  Set Aviso = New cAviso
'
'  Dim vUsers() As String
'  vUsers = Split(UserIDs, ",")
'
'  For i = 0 To UBound(vUsers)
'    Aviso.Save csNO_ID, C_AVT_PTD_ID, m_Id, vUsers(i), vbnullstring
'  Next
'
'  If m_Cumplida <> csECumplida_Pendiente Then
'    Aviso.DeleteFromClientID C_AVT_PTD_Pendientes, m_Id, m_Us_id_responsable
'  Else
'    If m_Alarma <= Date Then
'      Aviso.Save csNO_ID, C_AVT_PTD_Pendientes, m_Id, m_Us_id_responsable, vbnullstring
'    End If
'  End If
'End Sub

' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError

  c_ErrorSave = LNGGetText(2369, vbNullString) 'Error al grabar Parte Diario

  Dim Cfg As cEnvioConfig
  Set Cfg = New cEnvioConfig
  If Not Cfg.Load Then Exit Sub
  m_Tal_id = Cfg.Tal_Id_Legajo

  ' Preferencias del Usuario
  '
  Set m_UserCfg = New cUsuarioConfig
  m_UserCfg.Load

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
  On Error GoTo ControlError
  
  Set m_ObjAbm = Nothing
  Set m_ObjTree = Nothing

  ' Preferencias del Usuario
  '
  Set m_UserCfg = Nothing

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Terminate", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
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

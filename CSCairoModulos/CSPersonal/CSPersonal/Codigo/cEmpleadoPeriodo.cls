VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cEmpleadoPeriodo"
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
' cEmpleadoPeriodo
' 23-09-08

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
  ' constantes
  ' estructuras
  ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cEmpleadoPeriodo"

Private Const c_max_horas = "max_horas"
Private Const c_max_ccos = "max_ccos"
Private Const c_em_id_folder = "em_id_folder"
Private Const c_semanas = "semanas"

Private Const c_col_total = "col_total"

Private Const c_fixed_col = 4
Private Const c_fixed_col_semana = 3

Private Const K_NUMERO             As Integer = 2
Private Const K_DESCRIP            As Integer = 3
Private Const K_FECHA              As Integer = 4
Private Const K_FECHADESDE         As Integer = 5
Private Const K_FECHAHASTA         As Integer = 6
Private Const K_CCOS_ID            As Integer = 7
Private Const K_TIPO               As Integer = 8

Private Const K_CICO_ID            As Integer = 9

Private Const K_ITEMS              As Integer = 100
Private Const K_SEMANAS            As Integer = 200

Private Const KI_ITEM_ID           As Integer = 1
Private Const KI_EM_ID             As Integer = 2
Private Const KI_CCOS_ID           As Integer = 3

Private Const K_EM_ID_FOLDER       As Integer = 110
Private Const K_CMD_LOAD_EMPLEADOS As Integer = 120

' Seudo - Variables
Private c_ErrorSave          As String

' estructuras
' variables privadas
Private m_Id                 As Long
Private m_Numero             As Long
Private m_Descrip            As String
Private m_fecha              As Date
Private m_Desde              As Date
Private m_Hasta              As Date
Private m_ccos_id            As Long
Private m_CentroCosto        As String
Private m_cico_id            As Long
Private m_Circuito           As String
Private m_tipo               As csETipoPeriodo

Private m_max_horas          As Double
Private m_max_ccos           As Long

Private m_Editing       As Boolean

Private m_ObjAbm        As cIABMGeneric
Private m_ObjTree       As Object

Private m_IsNew         As Boolean

Private m_BranchId      As Long
Private m_TreeId        As Long

Private m_Host          As CSMenu.cIMenuHost
Private m_Copy          As Boolean

Private m_LastRow       As Long

' propiedades friend
' propiedades privadas
' funciones publicas

' Implementacion de cIABMClient
Private Function cIABMClient_Copy() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True
  
  With m_ObjAbm.Properties(cscEmpeNumero)
    .Value = C_CopiaDe & .Value
  End With
  
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscEmpeNumero)
  
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

  Doc.ClientTable = csTEmpleadoPeriodo
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
  
  Select Case MessageID
    Case MSG_GRID_ROW_CHANGE
      Dim iProp As cIABMProperty
      Dim Row   As cABMGridRow
      
      Dim AbmGen As cABMGeneric
      Set AbmGen = m_ObjAbm
      
      Set iProp = Info
      
      If m_LastRow Then
        Set Row = iProp.Grid.Rows(m_LastRow)
        If Not Row Is Nothing Then
          Row.BackColor = vbWindowBackground
          AbmGen.RefreshRowColor iProp, m_LastRow, Row
        End If
      End If
      
      m_LastRow = iProp.SelectedIndex
      Set Row = iProp.Grid.Rows(m_LastRow)
      If Row Is Nothing Then Exit Function
      
      Row.BackColor = &HFFCC99
      AbmGen.RefreshRowColor iProp, m_LastRow, Row
      
  End Select
  
  cIABMClient_MessageEx = True
End Function

Private Sub cIABMClient_DiscardChanges()
  LoadCollection
End Sub

Private Function cIABMClient_ListAdHock(List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClient_Load()

End Sub

Private Function cIABMClient_PropertyChange(ByVal Key As Integer) As Boolean
  Select Case Key
    Case K_CMD_LOAD_EMPLEADOS
      pAddEmpleados
  End Select
End Function

Private Function cIABMClient_Save() As Boolean
  Dim register   As cRegister
  Dim fields     As cFields
  Dim LastId     As Long
  
  Set register = New cRegister
  
  With register
    Set fields = .fields
      
    .fieldId = cscEmpeId
    .Table = csTEmpleadoPeriodo
  
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
        Case K_DESCRIP
          fields.Add2 cscEmpeDescrip, .Value, csText
        Case K_FECHA
          fields.Add2 cscEmpeFecha, .Value, csDate
        Case K_FECHADESDE
          fields.Add2 cscEmpeDesde, .Value, csDate
        Case K_FECHAHASTA
          fields.Add2 cscEmpeHasta, .Value, csDate
        Case K_CCOS_ID
          fields.Add2 cscCcosId, .HelpId, csId
        Case K_TIPO
          fields.Add2 cscEmpeTipo, .ListItemData, csInteger
        Case K_CICO_ID
          fields.Add2 cscCicoId, .HelpId, csId
      End Select
    End With
  Next
    
  fields.HaveLastUpdate = True
  fields.HaveWhoModify = True
  
  If Not register.BeginTrans(gDB) Then Exit Function
  
  If Not gDB.Save(register, , _
                  "cIABMClient_Save", _
                  C_Module, _
                  c_ErrorSave) Then Exit Function
  
  LastId = m_Id
  m_Id = register.ID
  
  If Not pSaveItems() Then GoTo SaveError
  If Not pSaveSemana() Then GoTo SaveError
  
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  m_max_horas = Val(pGetMaxHoras().Value)
  m_max_ccos = Val(pGetMaxCcos().Value)
  
  sqlstmt = "sp_EmpleadoPeriodoSave " & register.ID & ", " & _
                                        m_max_horas & ", " & _
                                        m_max_ccos
                                        
  If Not gDB.OpenRs(sqlstmt, rs) Then GoTo SaveError
  
  If rs.EOF Then GoTo SaveError
  
  If gDB.ValField(rs.fields, "success") = 0 Then GoTo SaveError
  
  If Not register.CommitTrans() Then GoTo SaveError
  
  pShowWarning rs
  
  m_Copy = False
  cIABMClient_Save = Load(register.ID)

  Exit Function
SaveError:

  m_Id = LastId
End Function

Private Sub pShowWarning(ByRef rs As ADODB.Recordset)
  On Error Resume Next
  
  If gDB.ValField(rs.fields, "warning") Then
  
    Dim msg As String
    msg = gDB.ValField(rs.fields, "message")
    
    MsgWarning msg
    
    Dim ErrorDetail As Object
    
    Set rs = rs.NextRecordset
    
    While Not rs Is Nothing
  
      If rs.State = adStateOpen Then
        
        If Not rs.EOF Then
        
          Set ErrorDetail = CSKernelClient2.CreateObject("CSMessageAux.cMessageAux")
          ErrorDetail.ShowMessageFromRecordset "Info", rs, Me
        End If
      End If
      
      Err.Clear
      Set rs = rs.NextRecordset
      If Err.Number Then Exit Sub
      
    Wend
    
  End If

End Sub

Private Function cIABMClient_Terminate() As Boolean
  m_Editing = False
  
  cIABMClient_Terminate = True
  ' Este objeto puede no cumplir con la interfaz esperada, asi que si hay un error no
  ' le doy bola
  On Error GoTo ControlError
  If m_Id = csNO_ID Then Exit Function
  If m_ObjTree Is Nothing Then Exit Function
  
  m_ObjTree.sqlstmt = "sp_lsdoc_empleadoperiodo"
  
  If m_IsNew Then
    m_ObjTree.AddLine m_Id
  Else
    m_ObjTree.RefreshLine m_Id
  End If
ControlError:
End Function

Private Property Get cIABMClient_Title() As String
                      'Presentismo y Asistencia
  cIABMClient_Title = LNGGetText(4578, vbNullString)
End Property

Private Function cIABMClient_Validate() As Boolean

  Dim IProperty As cIABMProperty

  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_FECHADESDE
          If ValEmpty(.Value, csDate) Then
            MsgInfo LNGGetText(2393, vbNullString) 'Debe indicar una fecha desde
            Exit Function
          End If
        Case K_FECHAHASTA
          If ValEmpty(.Value, csDate) Then
            MsgInfo LNGGetText(2394, vbNullString) 'Debe indicar una fecha hasta
            Exit Function
          End If
      End Select
    End With
  Next

  cIABMClient_Validate = True
End Function

'-------------------------------------------------------------------------------------
' Implementacion de cIABMClientGrid
Private Function cIABMClientGrid_ColumnAfterEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long) As Boolean
  cIABMClientGrid_ColumnAfterEdit = True
End Function

Private Function cIABMClientGrid_ColumnAfterUpdate(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long) As Boolean
  
  pUpdateTotal lRow
    
  cIABMClientGrid_ColumnAfterUpdate = True
End Function

Private Sub pUpdateTotal(ByVal lRow As Long)

  Dim Row   As cIABMGridRow
  Dim Cell  As cIABMGridCellValue
  Dim Total As Double
  
  If lRow = 0 Then Exit Sub
  
  Set Row = pGetItems().Grid.Rows.Item(lRow)
  
  For Each Cell In Row
  
    If InStr(1, Cell.Value, "hs") Then
      Total = Total + Val(Replace(Cell.Value, "hs", ""))
    End If
  Next
  
  Row.Item(Row.Count).Value = Total

End Sub

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

End Function

Private Function cIABMClientGrid_IsEmptyRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  cIABMClientGrid_IsEmptyRow = False
End Function

Private Function cIABMClientGrid_ListAdHock(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal ColIndex As Long, List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClientGrid_NewRow(ByVal Key As Integer, ByVal Rows As Integer)

End Sub

Private Function cIABMClientGrid_ValidateRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  cIABMClientGrid_ValidateRow = True
End Function

'-------------------------------------------------------------------------------------
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
  cIEditGeneric_ShowList = SecurityCanAccess(csPrePListEmpleadoPeriodo)
End Function

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
  Set m_ObjAbm = rhs
End Property

Private Property Get cIEditGeneric_Editing() As Boolean
  cIEditGeneric_Editing = m_Editing
End Property

Private Function cIEditGeneric_Delete(ID As Long) As Boolean
  If Not SecurityCanAccess(csPrePDeleteEmpleadoPeriodo) Then Exit Function
  
  Dim sqlstmt As String
  
  sqlstmt = "sp_empleadoPeriodoDelete " & ID
  
  cIEditGeneric_Delete = gDB.Execute(sqlstmt, "cIEditGeneric_Delete", C_Module)
End Function

Private Function cIEditGeneric_Search(ID As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(ID As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If ID = csNO_ID Then
    m_IsNew = True
    If Not SecurityCanAccess(csPrePNewEmpleadoPeriodo) Then Exit Function
  Else
    m_IsNew = False
    If Not SecurityCanAccess(csPrePEditEmpleadoPeriodo) Then Exit Function
  End If

  m_ObjAbm.InModalWindow = InModalWindow
  
  If Not Load(ID) Then Exit Function
  
  If Not LoadCollection() Then Exit Function
  
  m_Editing = True
  m_Copy = False
  
  ' JMA I
  If InModalWindow Then
    cIEditGeneric_Edit = m_Id <> csNO_ID
  Else
    cIEditGeneric_Edit = True
  End If
' JMA I

  Exit Function
ControlError:
  MngError Err, "cIEditGeneric_Edit", C_Module, vbNullString
End Function

Private Function cIEditGeneric_PrintObj(ByVal ID As Long) As Boolean

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

Private Function cIEditGeneric_Preview(ByVal ID As Long) As Boolean

End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  Dim c As cIABMProperty
  Dim iProp As cABMProperty
  
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  AbmObj.MinHeight = 6600
  AbmObj.MinWidth = 11000
  
  With m_ObjAbm.Tabs
  
    .Clear
      
    With .Add(Nothing)
      .Name = C_strGeneral
    End With
    
    With .Add(Nothing)
      .Index = 1
      .Name = LNGGetText(4840, vbNullString) ' Horas por Jornal
    End With
    
  End With
  
  With m_ObjAbm.Properties
    .Clear
    
    With .Add(Nothing, cscEmpeNumero)
      .PropertyType = cspNumeric
      .SubType = cspInteger
      .Enabled = False
      .FontBold = True
      .Name = LNGGetText(1065, vbNullString)  'Número
      .Top = 140
      .Left = 8250
      .Width = 2000
      .LeftLabel = -800
      .LeftNotChange = True
      .TopNotChange = True
      .Value = m_Numero
      .Key = K_NUMERO
    End With
    
    With .Add(Nothing, cscEmpeFecha)
      .PropertyType = cspDate
      .Name = LNGGetText(1569, vbNullString)  'Fecha
      .Key = K_FECHA
      .Value = m_fecha
    End With
    
    With .Add(Nothing, cscEmpeTipo)
      .PropertyType = cspList
      .Name = LNGGetText(1223, vbNullString)  'Tipo
      .Key = K_TIPO
      With .List
        With .Add(Nothing)
          .ID = csETL_Jornalizado
          .Value = LNGGetText(4509, vbNullString) 'Jornalizado
        End With
        With .Add(Nothing)
          .ID = csETL_Mensualizado
          .Value = LNGGetText(4510, vbNullString) 'Mensualizado
        End With
      End With
      .ListWhoSetItem = csListItemData
      .ListItemData = m_tipo
      .Width = 1800
      .TopFromProperty = cscEmpeFecha
      .Left = 4000
      .LeftLabel = -600
      .LeftNotChange = True
    End With
    
    With .Add(Nothing, cscCicoId)
      .PropertyType = cspHelp
      .Table = csCircuitoContable
      .Name = LNGGetText(4652, vbNullString)  'Circuito
      .Key = K_CICO_ID
      .Value = m_Circuito
      .HelpId = m_cico_id
      .TopFromProperty = cscEmpeFecha
      .Left = 7000
      .LeftLabel = -600
      .LeftNotChange = True
      .Width = 4000
    End With
    
    With .Add(Nothing, cscEmpeDesde)
      .PropertyType = cspDate
      .Name = LNGGetText(2532, vbNullString)  'Desde
      .Key = K_FECHADESDE
      .Value = m_Desde
    End With
    
    With .Add(Nothing, cscEmpeHasta)
      .PropertyType = cspDate
      .Name = LNGGetText(2533, vbNullString)  'Hasta
      .Key = K_FECHAHASTA
      .Value = m_Hasta
      .TopFromProperty = cscEmpeDesde
      .Left = 4000
      .LeftLabel = -600
    End With
    
    With .Add(Nothing, cscCcosId)
      .PropertyType = cspHelp
      .Table = csCentroCosto
      .Name = LNGGetText(1057, vbNullString)  'Centro de Costo
      .Key = K_CCOS_ID
      .Value = m_CentroCosto
      .HelpId = m_ccos_id
      .TopFromProperty = cscEmpeDesde
      .Left = 7000
      .Width = 4000
    End With
    
    With .Add(Nothing, cscEmpeDescrip)
      .PropertyType = cspText
      .Width = 9500
      .Height = 880
      .SubType = cspMemo
      .Name = C_strDescrip
      .Size = 7000
      .Key = K_DESCRIP
      .Value = m_Descrip
      .LeftFromProperty = cscEmpeDesde
    End With
    
    Set c = .Add(Nothing, c_max_horas)
    With c
      .PropertyType = cspNumeric
      .SubType = cspDouble
      .Format = "00.00"
      .Name = LNGGetText(4599, vbNullString) ' Maximo de Horas por Día
      .Width = 800
      .Left = 2400
      .LeftLabel = -2000
      .Value = m_max_horas
      
      Set iProp = c
      iProp.IsEditProperty = False
      
    End With
    
    Set c = .Add(Nothing, c_max_ccos)
    With c
      .PropertyType = cspNumeric
      .SubType = cspInteger
      .Name = LNGGetText(4600, vbNullString) ' Maximo de Obras por Día
      .Width = 800
      .TopFromProperty = c_max_horas
      .Left = 5400
      .LeftLabel = -2000
      .Value = m_max_ccos
    
      Set iProp = c
      iProp.IsEditProperty = False
    End With
    
    Set c = .Add(Nothing, c_em_id_folder)
    With c
      .PropertyType = cspHelp
      .Table = csEmpleado
      .Key = K_EM_ID_FOLDER
      .Name = LNGGetText(4555, vbNullString) 'Empleado
      
      .TopFromProperty = c_max_horas
      .Left = 7200
      .LeftLabel = -800
      .Width = 2500
      
      Set iProp = c
      iProp.HelpType = csTree
      iProp.IsEditProperty = False
    End With
    
    Set c = .Add(Nothing)
    With c
      .PropertyType = cspButton
      .Key = K_CMD_LOAD_EMPLEADOS
      .Name = LNGGetText(2057, vbNullString) 'Agregar
      .TopFromProperty = c_max_horas
      .Left = 9900
      .LeftLabel = -1
      .Width = 1000
    End With
    
    Set c = .Add(Nothing, c_Items)
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      If Not pLoadItems(c) Then Exit Function
      .Name = c_Items
      .Key = K_ITEMS
      .GridAdd = True
      .GridEdit = True
      .GridRemove = True
      .Top = 3400
      .Left = 200
    End With
    
    Set c = .Add(Nothing, c_semanas)
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      If Not pLoadSemanas(c) Then Exit Function
      .Name = c_semanas
      .Key = K_SEMANAS
      .GridAdd = True
      .GridEdit = True
      .GridRemove = True
      .TabIndex = 1
      .TopFromProperty = cscEmpeFecha
    End With
    
  End With
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

Private Function Load(ByVal ID As Long) As Boolean
  Dim sqlstmt As String
  Dim Hora    As Integer
  
  sqlstmt = "select empe.*,ccos_nombre, cico_nombre from EmpleadoPeriodo empe " _
              & " left join CentroCosto ccos on empe.ccos_id = ccos.ccos_id" _
              & " left join CircuitoContable cico on empe.cico_id = cico.cico_id" _
              & " where empe_id = " & ID
  
  Dim rs As ADODB.Recordset
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function
  
  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.fields, cscEmpeId)
    m_Numero = gDB.ValField(rs.fields, cscEmpeNumero)
    m_Descrip = gDB.ValField(rs.fields, cscEmpeDescrip)
    m_fecha = gDB.ValField(rs.fields, cscEmpeFecha)
    m_Desde = gDB.ValField(rs.fields, cscEmpeDesde)
    m_Hasta = gDB.ValField(rs.fields, cscEmpeHasta)
    m_tipo = gDB.ValField(rs.fields, cscEmpeTipo)
    
    m_ccos_id = gDB.ValField(rs.fields, cscCcosId)
    m_CentroCosto = gDB.ValField(rs.fields, cscCcosNombre)
    m_cico_id = gDB.ValField(rs.fields, cscCicoId)
    m_Circuito = gDB.ValField(rs.fields, cscCicoNombre)
    
  Else
    
    m_Id = csNO_ID
    m_Numero = 0
    m_Descrip = vbNullString
    m_fecha = Date
    If Day(Date) > 15 Then
      m_Desde = VDGetDateById(csMonth_FirstDay)
    Else
      m_Desde = DateSerial(Year(Date), Month(Date), 16)
    End If
    m_Hasta = Date
    m_tipo = csETP_Jornalizado
    
    m_ccos_id = csNO_ID
    m_CentroCosto = vbNullString
    m_cico_id = csNO_ID
    m_Circuito = vbNullString
    
    m_max_ccos = 2
    m_max_horas = 11

  End If

  Load = True

End Function

Private Function pLoadItems(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  Dim offset  As Integer
  Dim i       As Integer
  Dim iMonth  As Long
  Dim iYear   As Long
  
  Dim bAddRow     As Boolean
  Dim Row         As cIABMGridRow
  Dim lastEmId    As Long
  Dim lastCcosId  As Long
  Dim iDay        As Long
  Dim cellFormat  As cIABMGridCellFormat

  sqlstmt = "sp_EmpleadoPeriodoGetItems " & m_Id
  
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
        .Key = KI_ITEM_ID
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(4555, vbNullString) 'Empleado
        .PropertyType = cspHelp
        .Table = csEmpleado
        .Width = 2500
        .Key = KI_EM_ID
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(4590, vbNullString) 'C.C.
        .PropertyType = cspHelp
        .Table = csCentroCosto
        .Width = 2500
        .Key = KI_CCOS_ID
      End With
      
      offset = Day(pGetDesde().Value) - 1
      iMonth = Month(pGetDesde().Value)
      iYear = Year(pGetDesde().Value)
      
      ' Se cargan de 14 a 16 pares de columnas para las fechas
      ' de la quincena.
      ' la posicion impar tiene la asistencia tipo o las horas
      ' la posicion impar tiene el emh_id
      '
      For i = 1 To 16
                
        If offset >= 15 Then
          Select Case iMonth
            Case 1, 3, 5, 7, 8, 10, 12
            Case 4, 6, 9, 11
              If i = 31 Then Exit Function
            Case 2
              If i = 29 Then
                If Not pIsDateAux(29, 2, iYear) Then
                  Exit For
                End If
              End If
              If i = 30 Then Exit For
          End Select
        End If
        
        With .Add(Nothing, GetKey(i))
          .Name = pGetDayName(DateSerial(iYear, iMonth, i + offset)) & Format(i + offset, "00")
          .PropertyType = cspHelp
          .Table = csEmpleadoAsistenciaTipo
          .Width = 500
          
          If offset = 0 And i = 16 Then
            .Visible = False
          End If
          
        End With
        
        .Add(Nothing).Visible = False
        
      Next
      
      With .Add(Nothing, c_col_total)
        .Name = LNGGetText(1584, vbNullString)
        .PropertyType = cspNumeric
      End With
      
    End With
    
    With .Rows
      
      .Clear
      m_LastRow = 0
      
      Set cellFormat = New cABMGridCellFormat
      cellFormat.BackColor = vbRed
      
      While Not rs.EOF
        
        If lastEmId <> gDB.ValField(rs.fields, cscEmId) Then
          
          bAddRow = True
          lastEmId = gDB.ValField(rs.fields, cscEmId)
          lastCcosId = gDB.ValField(rs.fields, cscCcosId)
          
        ElseIf lastCcosId <> gDB.ValField(rs.fields, cscCcosId) Then
        
          bAddRow = True
          lastCcosId = gDB.ValField(rs.fields, cscCcosId)
        End If
      
        ' Si estoy en un nuevo empleado o centro de costo
        ' agrego una fila
        '
        If bAddRow Then
        
          pUpdateTotal .Count
          
          Set Row = .Add(Nothing)
        
          With Row
            
            ' Columnas fijas de la fila
            '
            .Add(Nothing).Key = KI_ITEM_ID
            
            With .Add(Nothing)
              .Value = gDB.ValField(rs.fields, cscEmNombre)
              .ID = gDB.ValField(rs.fields, cscEmId)
              .Key = KI_EM_ID
            End With
            
            With .Add(Nothing)
              .Value = gDB.ValField(rs.fields, cscCcosNombre)
              .ID = gDB.ValField(rs.fields, cscCcosId)
              .Key = KI_CCOS_ID
            End With
          
            ' Columnas de fechas de la fila
            '
            For i = 1 To 16
              
              .Add Nothing ' Asistencia Tipo u Horas
              .Add Nothing ' emh_id
              
            Next
            
            .Add Nothing ' Total de horas
          
          End With
          
          bAddRow = False
          
        End If
      
        ' Ahora tengo que colocar en la columna correspondiente
        ' las horas y su emh_id
        '
        With Row
        
          iDay = Day(gDB.ValField(rs.fields, cscEmhFecha))
          
          With pGetCellHorasFromFecha(Row, iDay)
            .Value = gDB.ValField(rs.fields, cscEastCodigo)
            .ID = gDB.ValField(rs.fields, cscEastId)
            If Weekday(gDB.ValField(rs.fields, cscEmhFecha)) = vbSunday Then
              Set .Format = cellFormat
            End If
          End With
          
          pGetCellIdFromFecha(Row, iDay).ID = gDB.ValField(rs.fields, cscEmhId)
          
        End With
         
        rs.MoveNext
      Wend
    
      pUpdateTotal .Count
    
    End With
    
  End With
  
  pLoadItems = True

End Function

Private Function pLoadSemanas(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  Dim offset  As Integer
  Dim i       As Integer
  Dim iMonth  As Long
  Dim iYear   As Long
  
  Dim bAddRow     As Boolean
  Dim Row         As cIABMGridRow
  Dim lastCcosId  As Long
  Dim iDay        As Long
  Dim cellFormat  As cIABMGridCellFormat

  sqlstmt = "sp_EmpleadoPeriodoGetSemanas " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, _
                    rs, _
                    csRsStatic, _
                    csLockReadOnly, _
                    csCmdText, _
                    "pLoadSemanas", _
                    C_Module) Then Exit Function
  
  With Propiedad.Grid
    
    With .Columns
      
      .Clear
      
      With .Add(Nothing)
        .Visible = False
        .Key = KI_ITEM_ID
      End With
            
      With .Add(Nothing)
        .Name = LNGGetText(4590, vbNullString) 'C.C.
        .PropertyType = cspHelp
        .Table = csCentroCosto
        .Width = 2500
        .Key = KI_CCOS_ID
      End With
      
      offset = Day(pGetDesde().Value) - 1
      iMonth = Month(pGetDesde().Value)
      iYear = Year(pGetDesde().Value)
      
      ' Se cargan de 14 a 16 columnas para las fechas
      ' de la quincena.
      '
      ' la posicion impar tiene las horas
      ' la posicion impar tiene el ems_id
      '
      For i = 1 To 16
                
        If offset >= 15 Then
          Select Case iMonth
            Case 1, 3, 5, 7, 8, 10, 12
            Case 4, 6, 9, 11
              If i = 31 Then Exit Function
            Case 2
              If i = 29 Then
                If Not pIsDateAux(29, 2, iYear) Then
                  Exit For
                End If
              End If
              If i = 30 Then Exit For
          End Select
        End If
        
        With .Add(Nothing, GetKey(i))
          .Name = pGetDayName(DateSerial(iYear, iMonth, i + offset)) & Format(i + offset, "00")
          .PropertyType = cspNumeric
          .SubType = cspDouble
          .Width = 500
          
          If offset = 0 And i = 16 Then
            .Visible = False
          End If
          
        End With
                
        .Add(Nothing).Visible = False
        
      Next
            
    End With
    
    With .Rows
      
      .Clear
      m_LastRow = 0
      
      Set cellFormat = New cABMGridCellFormat
      cellFormat.BackColor = vbRed
      
      While Not rs.EOF
        
        If lastCcosId <> gDB.ValField(rs.fields, cscCcosId) Then
        
          bAddRow = True
          lastCcosId = gDB.ValField(rs.fields, cscCcosId)
        End If
      
        ' Si estoy en un nuevo empleado o centro de costo
        ' agrego una fila
        '
        If bAddRow Then
        
          pUpdateTotal .Count
          
          Set Row = .Add(Nothing)
        
          With Row
            
            ' Columnas fijas de la fila
            '
            .Add(Nothing).Key = KI_ITEM_ID
            
            With .Add(Nothing)
              .Value = gDB.ValField(rs.fields, cscCcosNombre)
              .ID = gDB.ValField(rs.fields, cscCcosId)
              .Key = KI_CCOS_ID
            End With
          
            ' Columnas de fechas de la fila
            '
            For i = 1 To 16
              
              .Add Nothing ' Cantidad de Horas
              .Add Nothing ' ems_id
              
            Next
          
          End With
          
          bAddRow = False
          
        End If
      
        ' Ahora tengo que colocar en la columna correspondiente
        ' las horas y su emh_id
        '
        With Row
        
          iDay = Day(gDB.ValField(rs.fields, cscEmsFecha))
          
          With pGetCellHorasSemanaFromFecha(Row, iDay)
            .Value = gDB.ValField(rs.fields, cscEmsHoras)
            If Weekday(gDB.ValField(rs.fields, cscEmsFecha)) = vbSunday Then
              Set .Format = cellFormat
            End If
          End With
          
          pGetCellIdSemanaFromFecha(Row, iDay).ID = gDB.ValField(rs.fields, cscEmsId)
                    
        End With
         
        rs.MoveNext
      Wend
    
    End With
    
  End With
  
  pLoadSemanas = True

End Function

'/////////////////////////////////////////////////////////////
' Menu
Private Function cIMenuClient_Initialize(F As Object, Host As CSMenu.cIMenuHost) As Boolean
  On Error GoTo ControlError
  Dim str_4582  As String
  Dim str_4583  As String
  
  str_4582 = LNGGetText(4582, vbNullString)  '&Personal
  str_4583 = LNGGetText(4583, vbNullString)  '&Presentismo y Asistencia
  
  Set m_Host = Host
  m_Host.Server.AddMenu str_4582, csMenuPersonalMain, vbNullString, 1, False, False, False, True, False, Nothing
  m_Host.Server.AddMenu str_4583, csPrePListEmpleadoPeriodo, str_4582, 0, True, False, False, False, False, Me
    
  cIMenuClient_Initialize = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIMenuClient_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal ID As Long) As Variant
  m_Host.MenuListDocClick "CSABMInterface2.CABMGeneric", _
                          "CSPersonal.cEmpleadoPeriodo", _
                          "CSABMInterface2.CABMGenericListDoc", _
                          "CSPersonal.cEmpleadoPeriodoListDoc", Me, _
                          LNGGetText(4584, vbNullString), 0
                          ' Asistencias y Presentismo
End Function

Private Function pGetDesde() As cIABMProperty
  Set pGetDesde = m_ObjAbm.Properties.Item(cscEmpeDesde)
End Function

Private Function pGetHasta() As cIABMProperty
  Set pGetHasta = m_ObjAbm.Properties.Item(cscEmpeHasta)
End Function

Private Function pIsDateAux(ByVal iDay As Integer, ByVal iMonth As Integer, ByVal iYear As Long) As Boolean
  On Error Resume Next
  Err.Clear
  
  Dim v As Date
  
  v = DateSerial(iYear, iMonth, iDay)
  
  pIsDateAux = Err.Number = 0
End Function

Private Sub pAddEmpleados()
  Dim Row       As cIABMGridRow
  Dim rs        As ADODB.Recordset
  Dim sqlstmt   As String
  Dim i         As Long
  Dim offset    As Integer
  Dim iMonth    As Long
  Dim iYear     As Long
  
  Dim AbmGen As cABMGeneric
  Set AbmGen = m_ObjAbm
  
  offset = Day(pGetDesde().Value) - 1
  iMonth = Month(pGetDesde().Value)
  iYear = Year(pGetDesde().Value)
  
  sqlstmt = "sp_EmpleadoPeriodoAddEmpleados " & m_Id & "," & _
                      gDB.sqlString(pGetEmpleados().HelpValueProcess) & "," & _
                      gDB.sqlDate(pGetDesde().Value) & "," & _
                      gDB.sqlDate(pGetHasta().Value)
                      
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub

  With pGetItems.Grid
    
    With .Rows
  
      While Not rs.EOF
        
        Set Row = .Add(Nothing)
      
        With Row
          
          ' Columnas fijas de la fila
          '
          .Add(Nothing).Key = KI_ITEM_ID
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscEmNombre)
            .ID = gDB.ValField(rs.fields, cscEmId)
            .Key = KI_EM_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCcosNombre)
            .ID = gDB.ValField(rs.fields, cscCcosId)
            .Key = KI_CCOS_ID
          End With
        
          ' Columnas de fechas de la fila
          '
          For i = 1 To 16
                        
            If offset >= 15 Then
              Select Case iMonth
                Case 1, 3, 5, 7, 8, 10, 12
                Case 4, 6, 9, 11
                  If i + offset = 31 Then Exit Sub
                Case 2
                  If i + offset = 29 Then
                    If Not pIsDateAux(29, 2, iYear) Then
                      Exit For
                    End If
                  End If
                  If i + offset = 30 Then Exit For
              End Select
            End If
            
            With .Add(Nothing)
              .Value = "10 hs" ' Asistencia Tipo u Horas
              .ID = -1018
            End With
            .Add Nothing ' emh_id
            
          Next
          
          .Add Nothing ' c_col_total
        
        End With
         
        rs.MoveNext
      Wend
    
    End With
    
  End With
  
  Dim col     As cIABMGridColumn
  Dim iProp   As cIABMProperty
  Dim j       As Long
  Dim Columns As cIABMGridColumns
  
  Set iProp = pGetItems
  Set Columns = iProp.Grid.Columns
  
  For i = 1 To 16
  
    j = j + 1
    Set col = Columns.Item(GetKey(j))
    
    col.Name = pGetDayName(DateSerial(iYear, iMonth, i + offset)) & Format(i + offset, "00")
    AbmGen.RefreshColumnProperties iProp, GetKey(j)
  Next
  
  If offset > 0 Then
  
    Select Case iMonth
      Case 1, 3, 5, 7, 8, 10, 12
        
        Columns(31).Visible = True
        AbmGen.RefreshColumnProperties iProp, GetKey(14)
        Columns(33).Visible = True
        AbmGen.RefreshColumnProperties iProp, GetKey(15)
        Columns(35).Visible = True
        AbmGen.RefreshColumnProperties iProp, GetKey(16)
        
      Case 4, 6, 9, 11
        
        Columns(31).Visible = False
        AbmGen.RefreshColumnProperties iProp, GetKey(14)
        Columns(33).Visible = True
        AbmGen.RefreshColumnProperties iProp, GetKey(15)
        Columns(35).Visible = False
        AbmGen.RefreshColumnProperties iProp, GetKey(16)

      Case 2
        
        If Not pIsDateAux(29, 2, iYear) Then
          Columns(31).Visible = False
          AbmGen.RefreshColumnProperties iProp, GetKey(14)
        End If
        Columns(33).Visible = False
        AbmGen.RefreshColumnProperties iProp, GetKey(15)
        Columns(35).Visible = False
        AbmGen.RefreshColumnProperties iProp, GetKey(16)
        
    End Select
  
  Else
        
    Columns(31).Visible = True
    AbmGen.RefreshColumnProperties iProp, GetKey(14)
    Columns(33).Visible = True
    AbmGen.RefreshColumnProperties iProp, GetKey(15)
    Columns(35).Visible = False
    AbmGen.RefreshColumnProperties iProp, GetKey(16)
    
  End If
  
  AbmGen.ShowValue pGetItems(), True
  
End Sub

Private Function pSaveItems() As Boolean
  Dim register  As cRegister
  Dim Row       As cIABMGridRow
  Dim Cell      As cIABMGridCellValue
  Dim iCol      As Long
  Dim toDelete  As String
  
  Dim bHaveToDelete           As Boolean
  Dim bHaveToUpdateInsert     As Boolean
  
  Dim em_id     As Long
  Dim ccos_id   As Long
  
  With m_ObjAbm.Properties.Item(c_Items).Grid
          
    For Each Row In .Rows
    
      iCol = 0
      bHaveToDelete = False
      bHaveToUpdateInsert = False
    
      Set register = New cRegister
      With register
        .fieldId = cscEmhId
        .Table = csTEmpleadoHoras
        .ID = csNew
      End With
      
      For Each Cell In Row
      
        iCol = iCol + 1
      
        Select Case Cell.Key
          
          Case KI_ITEM_ID
            
            ' Nada que hacer, solo esta para que no entre por el else
            ' y se descarta automaticamente
            
          Case KI_EM_ID
            em_id = Cell.ID
          
          Case KI_CCOS_ID
            ccos_id = Cell.ID
            
          Case Else
          
            ' En la primera no se hace nada
            '
            If iCol = 1 Then
            
            ' Si la columna es de horas
            '
            ElseIf pIsColHora(iCol) Then
            
              ' Si no hay hora tengo que borrar el registro en EmpleadoHoras
              '
              If Cell.ID = csNO_ID Then
                bHaveToDelete = True
              
              ElseIf Cell.ID < 0 Then
              
                register.fields.Add2 cscEmhHoras, pGetHorasFromVirtualEAST_ID(Cell.ID), csDouble
                bHaveToUpdateInsert = True
              Else
                
                register.fields.Add2 cscEmhHoras, 0, csDouble
                register.fields.Add2 cscEastId, Cell.ID, csId
                bHaveToUpdateInsert = True
              End If
            
            ' Si la columna es de Id
            '
            Else
              
              ' Si hay que borrar la hora
              '
              If bHaveToDelete Then
              
                If Cell.ID Then
                  toDelete = toDelete & Cell.ID & ","
                End If
                
                bHaveToDelete = False
              
              ' Si hay horas cargadas o asistencia tipo
              '
              ElseIf bHaveToUpdateInsert Then
                
                register.ID = Cell.ID
                
                register.fields.Add2 cscEmId, em_id, csId
                register.fields.Add2 cscCcosId, ccos_id, csId
                register.fields.Add2 cscEmpeId, m_Id, csId
                register.fields.Add2 cscEmhFecha, pGetFechaFromCol(iCol), csDate
              
                If Not gDB.Save(register, , _
                                C_pSaveItemsFunc, _
                                C_Module, _
                                c_ErrorSave) Then Exit Function
                
                ' Nuevo registro
                '
                Set register = New cRegister
                With register
                  .fieldId = cscEmhId
                  .Table = csTEmpleadoHoras
                  .ID = csNew
                End With
                
                bHaveToUpdateInsert = False
              
              End If
            
            End If
            
        End Select
      Next
      
    Next
  End With
  
  Dim sqlstmt As String
  
  If LenB(toDelete) And Not m_Copy Then
    toDelete = RemoveLastColon(toDelete)
    sqlstmt = "delete EmpleadoHoras where emh_id in (" & toDelete & ")"
  
    If Not gDB.Execute(sqlstmt, C_pSaveItemsFunc, C_Module) Then Exit Function
  End If
  
  pSaveItems = True
End Function

Private Function pSaveSemana() As Boolean
  Dim register  As cRegister
  Dim Row       As cIABMGridRow
  Dim Cell      As cIABMGridCellValue
  Dim iCol      As Long
  Dim toDelete  As String
  
  Dim bHaveToDelete           As Boolean
  Dim bHaveToUpdateInsert     As Boolean
  
  Dim ccos_id   As Long
  
  With m_ObjAbm.Properties.Item(c_semanas).Grid
          
    For Each Row In .Rows
    
      iCol = 0
    
      Set register = New cRegister
      With register
        .fieldId = cscEmsId
        .Table = csTEmpleadoSemana
        .ID = csNew
      End With
      
      For Each Cell In Row
      
        iCol = iCol + 1
      
        Select Case Cell.Key
          
          Case KI_ITEM_ID
            
            ' Nada que hacer, solo esta para que no entre por el else
            ' y se descarta automaticamente
                      
          Case KI_CCOS_ID
            ccos_id = Cell.ID
            
          Case Else
          
            ' En la primera no se hace nada
            '
            If iCol = 1 Then
            
            ' Si la columna es de horas
            '
            ElseIf pIsColHoraSemana(iCol) Then
            
              ' Si no hay hora tengo que borrar el registro en EmpleadoSemana
              '
              If Val(Cell.Value) = 0 Then
                bHaveToDelete = True
              
              Else
              
                register.fields.Add2 cscEmsHoras, Cell.Value, csDouble
                bHaveToUpdateInsert = True
              End If
            
            ' Si la columna es de Id
            '
            Else
              
              ' Si hay que borrar la hora
              '
              If bHaveToDelete Then
              
                If Cell.ID Then
                  toDelete = toDelete & Cell.ID & ","
                End If
                
                bHaveToDelete = False
              
              ' Si hay horas cargadas o asistencia tipo
              '
              ElseIf bHaveToUpdateInsert Then
                
                register.ID = Cell.ID
                
                register.fields.Add2 cscCcosId, ccos_id, csId
                register.fields.Add2 cscEmpeId, m_Id, csId
                register.fields.Add2 cscEmsFecha, pGetFechaSemanaFromCol(iCol), csDate
              
                If Not gDB.Save(register, , _
                                C_pSaveItemsFunc, _
                                C_Module, _
                                c_ErrorSave) Then Exit Function
                
                ' Nuevo registro
                '
                Set register = New cRegister
                With register
                  .fieldId = cscEmsId
                  .Table = csTEmpleadoSemana
                  .ID = csNew
                End With
                
                bHaveToUpdateInsert = False
              
              End If
            
            End If
            
        End Select
      Next
      
    Next
  End With
  
  Dim sqlstmt As String
  
  If LenB(toDelete) And Not m_Copy Then
    toDelete = RemoveLastColon(toDelete)
    sqlstmt = "delete EmpleadoSemana where ems_id in (" & toDelete & ")"
  
    If Not gDB.Execute(sqlstmt, C_pSaveItemsFunc, C_Module) Then Exit Function
  End If
  
  pSaveSemana = True
End Function

Private Function pGetFechaSemanaFromCol(ByVal iColIndex As Long) As Date
  Dim rtn     As Date
  Dim iDay    As Long
  
  rtn = pGetDesde().Value
  If Day(rtn) < 15 Then
    rtn = DateSerial(Year(rtn), Month(rtn), (iColIndex - c_fixed_col_semana) / 2)
  Else
    rtn = DateSerial(Year(rtn), Month(rtn), 15 + ((iColIndex - c_fixed_col_semana) / 2))
  End If
  
  pGetFechaSemanaFromCol = rtn
End Function

Private Function pGetFechaFromCol(ByVal iColIndex As Long) As Date
  Dim rtn     As Date
  Dim iDay    As Long
  
  rtn = pGetDesde().Value
  If Day(rtn) < 15 Then
    rtn = DateSerial(Year(rtn), Month(rtn), (iColIndex - c_fixed_col) / 2)
  Else
    rtn = DateSerial(Year(rtn), Month(rtn), 15 + ((iColIndex - c_fixed_col) / 2))
  End If
  
  pGetFechaFromCol = rtn
End Function

Private Function pIsColHora(ByVal iColIndex As Long) As Boolean
  pIsColHora = ((iColIndex - c_fixed_col) Mod 2 - 1) = 0
End Function

Private Function pIsColHoraSemana(ByVal iColIndex As Long) As Boolean
  pIsColHoraSemana = ((iColIndex - c_fixed_col_semana) Mod 2 - 1) = 0
End Function

Private Function pGetHorasFromVirtualEAST_ID(ByVal east_id As Long) As Double
  Dim rtn As Double
  
  Select Case east_id
    Case -1000
      rtn = 1
    Case -1001
      rtn = 1.5
    Case -1002
      rtn = 2
    Case -1003
      rtn = 2.5
    Case -1004
      rtn = 3
    Case -1005
      rtn = 3.5
    Case -1006
      rtn = 4
    Case -1007
      rtn = 4.5
    Case -1008
      rtn = 5
    Case -1009
      rtn = 5.5
    Case -1010
      rtn = 6
    Case -1011
      rtn = 6.5
    Case -1012
      rtn = 7
    Case -1013
      rtn = 7.5
    Case -1014
      rtn = 8
    Case -1015
      rtn = 8.5
    Case -1016
      rtn = 9
    Case -1017
      rtn = 9.5
    Case -1018
      rtn = 10
    Case -1019
      rtn = 10.5
    Case -1020
      rtn = 11
    Case -1021
      rtn = 11.5
    Case -1022
      rtn = 12
    Case -1023
      rtn = 12.5
    Case -1024
      rtn = 13
    Case -1025
      rtn = 13.5
    Case -1026
      rtn = 14
    Case -1027
      rtn = 14.5
    Case -1028
      rtn = 15
    Case -1029
      rtn = 15.5
    Case -1030
      rtn = 16
    Case -1031
      rtn = 16.5
    Case -1032
      rtn = 17
    Case -1033
      rtn = 17.5
    Case -1034
      rtn = 18
    Case -1035
      rtn = 18.5
  End Select
  
  pGetHorasFromVirtualEAST_ID = rtn
End Function

Private Function pGetCellHorasSemanaFromFecha(ByRef Row As cIABMGridRow, ByVal iDay As Long) As cIABMGridCellValue
  
  If iDay > 15 Then iDay = iDay - 15
  iDay = iDay * 2 - 1
  Set pGetCellHorasSemanaFromFecha = Row.Item(iDay + c_fixed_col_semana)
  
End Function

Private Function pGetCellIdSemanaFromFecha(ByRef Row As cIABMGridRow, ByVal iDay As Long) As cIABMGridCellValue
  
  If iDay > 15 Then iDay = iDay - 15
  iDay = iDay * 2
  Set pGetCellIdSemanaFromFecha = Row.Item(iDay + c_fixed_col_semana)
  
End Function

Private Function pGetCellHorasFromFecha(ByRef Row As cIABMGridRow, ByVal iDay As Long) As cIABMGridCellValue
  
  If iDay > 15 Then iDay = iDay - 15
  iDay = iDay * 2 - 1
  Set pGetCellHorasFromFecha = Row.Item(iDay + c_fixed_col)
  
End Function

Private Function pGetCellIdFromFecha(ByRef Row As cIABMGridRow, ByVal iDay As Long) As cIABMGridCellValue
  
  If iDay > 15 Then iDay = iDay - 15
  iDay = iDay * 2
  Set pGetCellIdFromFecha = Row.Item(iDay + c_fixed_col)
  
End Function

Private Function pGetMaxHoras() As cIABMProperty
  Set pGetMaxHoras = m_ObjAbm.Properties.Item(c_max_horas)
End Function

Private Function pGetMaxCcos() As cIABMProperty
  Set pGetMaxCcos = m_ObjAbm.Properties.Item(c_max_ccos)
End Function

Private Function pGetItems() As cIABMProperty
  Set pGetItems = m_ObjAbm.Properties.Item(c_Items)
End Function

Private Function pGetEmpleados() As cIABMProperty
  Set pGetEmpleados = m_ObjAbm.Properties.Item(c_em_id_folder)
End Function

Private Function pGetDayName(ByVal dDate As Date) As String
  Select Case Weekday(dDate, vbMonday)
    Case 1
      pGetDayName = "LU "
    Case 2
      pGetDayName = "MA "
    Case 3
      pGetDayName = "MI "
    Case 4
      pGetDayName = "JU "
    Case 5
      pGetDayName = "VI "
    Case 6
      pGetDayName = "SA "
    Case 7
      pGetDayName = "DO "
  End Select
End Function

' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  c_ErrorSave = LNGGetText(4585, vbNullString) 'Error al grabar las novedades de asistencia y presentismo
  
  m_max_ccos = 2
  m_max_horas = 11
  
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

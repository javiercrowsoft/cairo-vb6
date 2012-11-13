VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cDialogSearch"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIABMClient
Implements CSInterfacesABM.cIABMClientGrid
'--------------------------------------------------------------------------------
' cDialogSearch
' 10-04-2005

'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes

Private Const C_Module = "cDialogSearch"

Private Const c_Fields = "Fields"
Private Const c_Filters = "Filters"
Private Const c_Filter = "Filter"
Private Const c_Search = "Search"
Private Const c_Results = "Results"
Private Const c_SearchType = "SearchType"

Private Const K_FIELDS          As Integer = 1
Private Const K_FILTERS         As Integer = 2
Private Const K_FILTER          As Integer = 3
Private Const K_SEARCH          As Integer = 4
Private Const K_RESULTS         As Integer = 5
Private Const K_SEARCHTYPE      As Integer = 6

Private Const KI_SELECT         As Integer = 1
Private Const KI_FIELD          As Integer = 2
Private Const KI_NAME           As Integer = 3
Private Const KI_FILTER         As Integer = 4

' estructuras
' variables privadas
Private m_ObjAbm           As cIABMGeneric

Private m_Fields           As Collection
Private m_Filters          As cIABMProperties
Private m_SerchObj         As Object
Private m_rslt             As cSearchResult

' propiedades publicas
Public Property Set ObjAbm(ByRef rhs As cIABMGeneric)
  Set m_ObjAbm = rhs
End Property

' propiedades privadas
' funciones publicas
Public Function Search(ByRef Filters As cIABMProperties, _
                       ByRef Fields As Collection, _
                       ByRef SearchObj As Object) As cSearchResult
  Set m_Fields = Fields
  Set m_Filters = Filters
  Set m_SerchObj = SearchObj
  
  Set m_rslt = New cSearchResult
  Set Search = m_rslt
  
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  m_ObjAbm.InModalWindow = True
  AbmObj.OkCancelDialog = True
  AbmObj.bDontAskForSave = True
  
  If Not LoadCollection() Then Exit Function
  
  If Not AbmObj.OkCancelDialogRslt Then Exit Function
  
  m_rslt.Success = True
End Function

' Implementacion de cIABMClient
Private Function cIABMClient_Copy() As Boolean

End Function

Private Function cIABMClient_EditNew() As Boolean

End Function

Private Property Get cIABMClient_Aplication() As String
  cIABMClient_Aplication = gAppName
End Property

Private Property Get cIABMClient_CanAddDocDigital() As Boolean
  cIABMClient_CanAddDocDigital = False
End Property

Private Property Get cIABMClient_CanCopy() As Boolean
  cIABMClient_CanCopy = False
End Property

Private Property Get cIABMClient_CanNew() As Boolean
  cIABMClient_CanNew = False
End Property

Private Function cIABMClient_ShowDocDigital() As Boolean

End Function

Private Function cIABMClient_MessageEx(ByVal MessageID As Long, ByVal Info As Variant) As Variant
  Select Case MessageID
    
    Case MSG_GRID_ROW_CHANGE

      If Info Is Nothing Then Exit Function

      Dim Row      As cIABMGridRow
      Dim iProp    As cIABMProperty
      Dim Aplicado As Double

      Set iProp = Info

      Select Case iProp.Key

        Case K_RESULTS

      End Select
  End Select

  cIABMClient_MessageEx = True
End Function

Private Sub cIABMClient_DiscardChanges()
  LoadCollection
End Sub

Private Function cIABMClient_ListAdHock(Lista As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClient_Load()

End Sub

Private Function cIABMClient_PropertyChange(ByVal Key As Integer) As Boolean
  Select Case Key
    Case K_SEARCH
      pSearch
  End Select
End Function

Private Function cIABMClient_Save() As Boolean
  cIABMClient_Save = pSelect
End Function

Private Function cIABMClient_Terminate() As Boolean
  cIABMClient_Terminate = True
End Function

Private Property Get cIABMClient_Title() As String
  cIABMClient_Title = LNGGetText(2819, vbNullString)  'Buscar Documentos
End Property

Private Function cIABMClient_Validate() As Boolean
  cIABMClient_Validate = True
End Function

' Implementacion de cIABMClientGrid

Private Function cIABMClientGrid_ColumnAfterEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long) As Boolean
  cIABMClientGrid_ColumnAfterEdit = True
End Function

Private Function cIABMClientGrid_ColumnBeforeEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean
  Select Case Key
    Case K_FILTERS
      Dim iProp       As cIABMProperty
      Dim iPropFilter As cIABMProperty
      
      Set iProp = m_ObjAbm.Properties.Item(c_Filters)
      If iProp.Grid.Rows.Item(lRow).Item(lCol).Key = KI_FILTER Then
        Set iPropFilter = m_Filters.Item(lRow)
        Select Case iPropFilter.PropertyType
          Case cspHelp
            With iProp.Grid.Columns.Item(c_Filter)
              .PropertyType = cspHelp
              .Table = iPropFilter.Table
              .HelpFilter = iPropFilter.HelpFilter
            End With
          Case cspDate
            iProp.Grid.Columns.Item(c_Filter).PropertyType = cspDate
        End Select
        Dim AbmObj As cABMGeneric
        Set AbmObj = m_ObjAbm
        AbmObj.RefreshColumnProperties iProp, c_Filter
      End If
  End Select
  cIABMClientGrid_ColumnBeforeEdit = True
End Function

Private Function cIABMClientGrid_ColumnButtonClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean

End Function

Private Sub cIABMClientGrid_ColumnCancelEdit(ByVal Key As Integer)

End Sub

Private Function cIABMClientGrid_DeleteRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal lRow As Long) As Boolean

End Function

Private Function cIABMClientGrid_ListAdHock(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal ColIndex As Long, List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClientGrid_NewRow(ByVal Key As Integer, ByVal Rows As Integer)

End Sub

Private Sub cIABMClientGrid_ColumnClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Sub cIABMClientGrid_DblClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)
  Select Case Key
    Case K_RESULTS
      Dim AbmObj As cABMGeneric
      Set AbmObj = m_ObjAbm
      AbmObj.Save
  End Select
End Sub

Private Function cIABMClientGrid_ValidateRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  cIABMClientGrid_ValidateRow = True
End Function

Private Function cIABMClientGrid_ColumnAfterUpdate(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long) As Boolean

End Function

Private Function cIABMClientGrid_IsEmptyRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  cIABMClientGrid_IsEmptyRow = False
End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  Dim c     As cIABMProperty
  Dim Grid  As cABMGrid
  
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  
  AbmObj.MinHeight = 7500
  AbmObj.MinWidth = 10300
  
  m_ObjAbm.Properties.Clear
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, c_Filter)
  With c
    c.Name = LNGGetText(2820, vbNullString)  'Buscar
    c.PropertyType = cspText
    c.Width = 5600
    c.Left = 900
    c.LeftLabel = -600
    c.Key = K_FILTER
  End With
  
  Set c = m_ObjAbm.Properties.Add(Nothing, c_SearchType)
  With c
    c.Name = vbNullString
    c.Width = 1700
    c.Left = 6700
    c.TopFromProperty = c_Filter
    c.LeftLabel = -1
    c.PropertyType = cspList
    With c.List.Add(Nothing)
      .Id = csESearchInString
      .Value = LNGGetText(2821, vbNullString)  'Contiene
    End With
    With c.List.Add(Nothing)
      .Id = csESearchBeginWith
      .Value = LNGGetText(2822, vbNullString)  'Empieza con
    End With
    With c.List.Add(Nothing)
      .Id = csESearchEqual
      .Value = LNGGetText(2823, vbNullString)  'Igual
    End With
    c.ListWhoSetItem = csListItemData
    c.ListItemData = csESearchInString
    c.Key = K_SEARCHTYPE
  End With
  
  Set c = m_ObjAbm.Properties.Add(Nothing, c_Search)
  With c
    c.Name = "Buscar"
    c.Width = 1300
    c.Left = 8600
    c.TopFromProperty = c_Filter
    c.LeftLabel = -1
    c.PropertyType = cspButton
    c.Key = K_SEARCH
  End With
  
  Set c = m_ObjAbm.Properties.Add(Nothing, "lb")
  With c
    .PropertyType = cspLabel
    .Value = "Campos"
    .Left = 300
  End With
  
  Set c = m_ObjAbm.Properties.Add(Nothing, c_Fields)
  With c
    .PropertyType = cspGrid
    .LeftLabel = -1
    If Not pLoadFields(c) Then Exit Function
    .Name = c_Fields
    .Key = K_FIELDS
    .GridEdit = True
    
    .Left = 300
    .Top = 1800
    .Height = 1800
    .Width = 3100
    
    Set Grid = .Grid
    Grid.DontResize = True
    Grid.DontResizeHeight = True
  End With

  Set c = m_ObjAbm.Properties.Add(Nothing)
  With c
    .PropertyType = cspLabel
    .TopFromProperty = "lb"
    .Value = LNGGetText(3104, vbNullString) 'Filtros
    .Left = 3500
  End With
  
  Set c = m_ObjAbm.Properties.Add(Nothing, c_Filters)
  With c
    .PropertyType = cspGrid
    If Not pLoadFilters(c) Then Exit Function
    .Name = c_Filters
    .Key = K_FILTERS
    .GridEdit = True
    
    .TopFromProperty = c_Fields
    .Left = 3500
    .LeftLabel = -1
    .Height = 1800
    .Width = 5000
  
    Set Grid = .Grid
    Grid.DontResize = True
    Grid.DontResizeHeight = True
  End With
  
  Set c = m_ObjAbm.Properties.Add(Nothing, c_Results)
  With c
    .PropertyType = cspGrid
    If Not pLoadResults(c) Then Exit Function
    .Name = c_Results
    .Key = K_RESULTS
    .GridEdit = True
    
    .Top = 3800
    .LeftLabel = -1
    .LeftFromProperty = c_Fields
  End With
    
  AbmObj.DontMoveGenericButton = True
  With AbmObj.Frm
    With .cmdSave
      .Left = 8600
      .Top = 1480
      .Style = 0
      .Caption = LNGGetText(2824, vbNullString)  '&Seleccionar
    End With
    With .cmdCancel
      .Left = 8600
      .Top = 1890
    End With
  End With
  
  If Not m_ObjAbm.Show(Me) Then Exit Function

  LoadCollection = True
End Function

Private Function pLoadFields(ByRef Propiedad As cIABMProperty) As Boolean
  Dim o       As cIABMGridColumn
  
  With Propiedad.Grid.Columns
    
    Set o = .Add(Nothing)
    o.PropertyType = cspCheck
    o.Width = 400
    o.Key = KI_SELECT
    
    Set o = .Add(Nothing, c_Fields)
    o.Name = LNGGetText(2825, vbNullString)  'Campos
    o.PropertyType = cspText
    o.Width = 3500
    o.Key = KI_FIELD
  End With
  
  Dim F       As cIABMGridRow
  Dim fv      As cIABMGridCellValue
  Dim field   As Variant
  
  For Each field In m_Fields

    Set F = Propiedad.Grid.Rows.Add(Nothing)

    Set fv = F.Add(Nothing)
    fv.Id = 1
    fv.Key = KI_SELECT

    Set fv = F.Add(Nothing)
    fv.Value = field
    fv.Key = KI_FIELD
  Next
  
  pLoadFields = True
End Function

Private Function pLoadFilters(ByRef Propiedad As cIABMProperty) As Boolean
  Dim o       As cIABMGridColumn
  
  With Propiedad.Grid.Columns
    
    Set o = .Add(Nothing)
    o.PropertyType = cspText
    o.Enabled = False
    o.Width = 2500
    o.Key = KI_NAME
    
    Set o = .Add(Nothing, c_Filter)
    o.Name = LNGGetText(2826, vbNullString)  'Filtro
    o.PropertyType = cspText
    o.Width = 2300
    o.Key = KI_FILTER
  End With
  
  Dim F       As cIABMGridRow
  Dim fv      As cIABMGridCellValue
  Dim iProp   As cIABMProperty
  
  For Each iProp In m_Filters

    Set F = Propiedad.Grid.Rows.Add(Nothing)

    Set fv = F.Add(Nothing)
    fv.Value = iProp.Name
    fv.Key = KI_NAME

    Set fv = F.Add(Nothing)
    fv.Value = iProp.Value
    fv.Id = iProp.HelpId
    fv.Key = KI_FILTER
  Next
  
  pLoadFilters = True
End Function

Private Function pLoadResults(ByRef Propiedad As cIABMProperty) As Boolean
  Dim o       As cIABMGridColumn
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Width = 6000
  
  pLoadResults = True
End Function

Private Function pSelect() As Boolean
  Dim iProp   As cIABMProperty
  
  Set iProp = m_ObjAbm.Properties.Item(c_Results)
  If iProp.SelectedIndex = 0 Then
    MsgInfo LNGGetText(2827, vbNullString)  'Debe seleccionar un elemento
    Exit Function
  End If
  
  m_SerchObj.SetResult m_rslt, iProp
  
  pSelect = True
End Function

Private Sub pSearch()
  Dim rs As ADODB.Recordset
  
  Dim Fields As Collection
  pGetFields Fields
  pGetFilters m_Filters
  
  With m_ObjAbm.Properties
    
    Set rs = m_SerchObj.GetRows(.Item(c_Filter).Value, _
                                .Item(c_SearchType).ListItemData, _
                                m_Filters, _
                                Fields)
  End With
  
  pShowResult rs
End Sub

Private Sub pShowResult(ByRef rs As ADODB.Recordset)
  Dim iCol    As cIABMGridColumn
  Dim oCol    As cABMGridColumn
  Dim Grid    As cIABMGrid
  Dim iProp   As cIABMProperty
  
  Set iProp = m_ObjAbm.Properties.Item(c_Results)
  
  Set Grid = iProp.Grid
  
  If rs Is Nothing Then
    pClearGrid Grid
  
  Else
    
    If rs.State <> adStateOpen Then
      pClearGrid Grid
    
    ElseIf rs.EOF And rs.BOF Then
      pClearGrid Grid
      
    Else
      
      Grid.Columns.Clear
      Grid.Rows.Clear
      
      Dim fld As ADODB.field
      
      For Each fld In rs.Fields
        Set iCol = Grid.Columns.Add(Nothing)
        With iCol
          If InStr(1, LCase(fld.Name), "_id") Then
            .Visible = False
          ElseIf fld.Name = "__details" Then
            Set oCol = iCol
            oCol.IsDetail = True
          Else
            .Name = fld.Name
          End If
          If fld.Name = "comp_id" Then .Key = c_compId
          If fld.Name = "doct_id" Then .Key = c_doctId
        End With
      Next
      
      While Not rs.EOF
      
        With Grid.Rows.Add(Nothing)
          
          For Each fld In rs.Fields
            .Add(Nothing).Value = gDB.ValField(rs.Fields, fld.Name)
          Next
        End With
      
        rs.MoveNext
      Wend
    End If
  End If
  
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  m_ObjAbm.ShowValue iProp
  AbmObj.AutoWidthColumn iProp
End Sub

Private Sub pClearGrid(ByRef Grid As cIABMGrid)
  Grid.Columns.Clear
  Grid.Rows.Clear
  
  Grid.Columns.Add(Nothing).Width = 9000
  Grid.Rows.Add(Nothing).Add(Nothing).Value = LNGGetText(2828, vbNullString)  'No se encontraron datos
End Sub

Public Sub pGetFilters(ByRef Filters As cIABMProperties)
  Dim iProp As cIABMProperty
  Dim Row   As cIABMGridRow
  Dim i     As Long
  Dim Cell  As cIABMGridCellValue
  
  Set iProp = m_ObjAbm.Properties.Item(c_Filters)
  
  For Each Row In iProp.Grid.Rows
    Set Cell = pCell(Row, KI_FILTER)
    i = i + 1
    With Filters.Item(i)
      .Value = Cell.Value
      .HelpId = Cell.Id
      .ListItemData = Cell.Id
    End With
  Next
End Sub

Public Sub pGetFields(ByRef Fields As Collection)
  Dim iProp As cIABMProperty
  Dim Row   As cIABMGridRow
  Dim fld   As String
  
  Set iProp = m_ObjAbm.Properties.Item(c_Fields)
  
  If Fields Is Nothing Then
    Set Fields = New Collection
  Else
    CollClear Fields
  End If
  
  For Each Row In iProp.Grid.Rows
    If pCell(Row, KI_SELECT).Id Then
      fld = pCell(Row, KI_FIELD).Value
      Fields.Add fld, fld
    End If
  Next
End Sub

' construccion - destruccion
Private Sub Class_Terminate()
  On Error Resume Next
  Set m_Filters = Nothing
  Set m_Fields = Nothing
  Set m_SerchObj = Nothing
  Set m_ObjAbm = Nothing
  Set m_rslt = Nothing
End Sub

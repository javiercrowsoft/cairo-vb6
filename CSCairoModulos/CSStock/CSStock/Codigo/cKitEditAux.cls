VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cKitEditAux"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIABMClient
Implements CSInterfacesABM.cIABMClientGrid
'--------------------------------------------------------------------------------
' cKitEditAux
' 20-08-2006

'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes

Private Const C_Module = "cKitEditAux"

Private Enum csE_ColType
  csECT_Serie = 0
  csECT_SerieA = 1000
  csECT_Lote = 2000
  csECT_Alt = 4000
  csECT_Var = 5000
End Enum

Private Const c_col_serie_lote = "serie"

Private Const K_ITEMS          As Integer = 1

Private Const KI_PR_ID          As Integer = 2 ' Ojo: Tiene que concidir con la
                                               '      declaracion en mKit
Private Const KI_SERIE_LOTE     As Integer = 3
Private Const KI_CANTIDAD       As Integer = 4

' estructuras
' variables privadas
Private m_ctrlStock         As csE_ControlStock
Private m_depf_id           As Long
Private m_depl_id           As Long
Private m_KitLns            As cKitLines
Private m_KitLn             As cKitLine
Private m_Kit               As cKit
Private m_Item              As Object

Private m_ObjAbm            As cIABMGeneric

Private m_lRowKey           As Long
Private m_lColKey           As Long
Private m_strDescrip        As String

' propiedades publicas
' propiedades privadas
' funciones publicas
Public Function Edit(ByRef Kit As cKit, _
                     ByRef Item As Object, _
                     ByVal depl_id As Long, _
                     ByVal depf_id As Long, _
                     ByVal ctrlStock As csE_ControlStock, _
                     ByRef KitLn As cKitLine, _
                     ByRef KitLns As cKitLines, _
                     ByVal lRow As Long, _
                     ByVal lCol As Long, _
                     ByRef strDescrip As String) As Boolean
  
  m_depl_id = depl_id
  m_depf_id = depf_id
  m_ctrlStock = ctrlStock
  m_lRowKey = lRow
  m_lColKey = lCol * 1000
  
  Set m_Kit = Kit
  Set m_Item = Item
  Set m_KitLn = KitLn
  Set m_KitLns = KitLns
  Set m_ObjAbm = New cABMGeneric
  
  Dim AbmObj As cABMGeneric
  
  Set AbmObj = m_ObjAbm
  AbmObj.CreateRowInBeforeEdit = True ' Esto es necesario para
                                      ' poder armar el filtro en
                                      ' series y lotes
  AbmObj.OkCancelDialog = True
  m_ObjAbm.InModalWindow = True
  
  If Not LoadCollection() Then Exit Function
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  Edit = AbmObj.OkCancelDialogRslt
  strDescrip = RemoveLastColon(m_strDescrip)
  
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

End Property

Private Property Get cIABMClient_CanCopy() As Boolean

End Property

Private Property Get cIABMClient_CanNew() As Boolean

End Property

Private Function cIABMClient_ShowDocDigital() As Boolean

End Function

Private Function cIABMClient_MessageEx(ByVal MessageID As Long, ByVal Info As Variant) As Variant
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

End Function

Private Function cIABMClient_Save() As Boolean
  cIABMClient_Save = pSaveItems()
End Function

Private Function cIABMClient_Terminate() As Boolean
  Set m_Kit = Nothing
  Set m_Item = Nothing
  Set m_KitLn = Nothing
  Set m_KitLns = Nothing
  cIABMClient_Terminate = True
End Function

Private Property Get cIABMClient_Title() As String
  cIABMClient_Title = LNGGetText(1991, vbNullString)  'Item Kit
End Property

Private Function cIABMClient_Validate() As Boolean
  cIABMClient_Validate = True
End Function

' Implementacion de cIABMClientGrid
Private Function cIABMClientGrid_ColumnAfterEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long) As Boolean
  cIABMClientGrid_ColumnAfterEdit = True
End Function

Private Function cIABMClientGrid_ColumnBeforeEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean
  Dim iKey As Long
  iKey = m_ObjAbm.Properties.Item(c_Items).Grid.Columns.Item(lCol).Key
  If iKey <> KI_SERIE_LOTE Then
    cIABMClientGrid_ColumnBeforeEdit = pBeforeEdit(lRow, lCol)
  ElseIf TypeOf m_Item Is cKitAlt Then
    cIABMClientGrid_ColumnBeforeEdit = True
  Else
    cIABMClientGrid_ColumnBeforeEdit = pBeforeEdit(lRow, lCol)
  End If
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
  cIABMClientGrid_ColumnAfterUpdate = True
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
  Dim strRow                As String
  Dim bRowIsEmpty           As Boolean
  
  strRow = " (Fila " & RowIndex & ")"
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_CANTIDAD
        If Not ValEmpty(Cell.Value, csCurrency) Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KI_SERIE_LOTE
        If Not ValEmpty(Cell.Id, csId) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowItems = bRowIsEmpty
End Function

Private Function pValidateRowItems(Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell              As cIABMGridCellValue
  Dim strRow            As String
  
  strRow = " (Fila " & RowIndex & ")"
  
'  For Each Cell In Row
'
'    Select Case Cell.Key
'
'      Case KI_PR_ID
'        If ValEmpty(Cell.Id, csId) Then
'          MsgInfo "Debe indicar un artículo" & strRow
'          Exit Function
'        End If
'
'    End Select
'  Next
  
  pValidateRowItems = True
End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  
  Dim c As cIABMProperty
  
  With m_ObjAbm
  
    .Title2 = m_Kit.Nombre
    
    With .Properties
      
      .Clear
    
      Set c = .Add(Nothing, c_Items)
      With c
        .PropertyType = cspGrid
        .LeftLabel = -1
        If Not pLoadItems(c) Then Exit Function
        .Name = "Items"
        .Key = K_ITEMS
        .GridAdd = True
        .GridEdit = True
        .GridRemove = True
      End With
    End With
  End With

  LoadCollection = True
End Function

Private Function pSaveItems() As Boolean
  Dim rtn As Boolean
  
  m_strDescrip = vbNullString
  If TypeOf m_Item Is cKitSerie Then
    rtn = pSaveSerie(m_Item)
  ElseIf TypeOf m_Item Is cKitLote Then
    rtn = pSaveLote(m_Item)
  Else
    rtn = pSaveAlt(m_Item)
  End If
  pSaveItems = rtn
End Function

Private Function pSaveSerie(ByRef Serie As cKitSerie) As Boolean
  Dim Row   As cIABMGridRow
  Dim Cell  As cIABMGridCellValue
  Dim lRow  As Long
  
  Serie.Items.Clear
  
  With Serie.Items
    For Each Row In m_ObjAbm.Properties(c_Items).Grid.Rows
      
      lRow = lRow + 1
      With .Add(KitGetKeyItem(m_lRowKey, m_lColKey + lRow), Nothing)
        
        Set Cell = pCell(Row, KI_PR_ID)
        .Nombre = Cell.Value
        .pr_id = Cell.Id
        
        Set Cell = pCell(Row, KI_SERIE_LOTE)
        .prns_id = Cell.Id
        .Serie = Cell.Value
        
        m_strDescrip = m_strDescrip & Cell.Value & ","
      End With
      
    Next
  End With
  
  pSaveSerie = True
End Function

Private Function pSaveLote(ByRef Lote As cKitLote) As Boolean
  Dim Row   As cIABMGridRow
  Dim Cell  As cIABMGridCellValue
  Dim lRow  As Long
  
  Lote.Items.Clear
  
  With Lote.Items
    For Each Row In m_ObjAbm.Properties(c_Items).Grid.Rows

      lRow = lRow + 1
      With .Add(KitGetKeyItem(m_lRowKey, m_lColKey + lRow), Nothing)
        
        Set Cell = pCell(Row, KI_PR_ID)
        .Nombre = Cell.Value
        .pr_id = Cell.Id
        
        Set Cell = pCell(Row, KI_SERIE_LOTE)
        .stl_id = Cell.Id
        .Lote = Cell.Value
        
        .Cantidad = Val(pCell(Row, KI_CANTIDAD).Value)
        m_strDescrip = m_strDescrip & Cell.Value & _
                                      "(" & Format(.Cantidad, "0.00") & "),"
      End With
      
    Next
  End With
  pSaveLote = True
End Function

Private Function pSaveAlt(ByRef Alt As cKitItem) As Boolean
  Dim Row   As cIABMGridRow
  Dim Cell  As cIABMGridCellValue
  
  Alt.Items.Clear
  
  With Alt.Items
    For Each Row In m_ObjAbm.Properties(c_Items).Grid.Rows
    
      With .Add(Nothing)
        
        Set Cell = pCell(Row, KI_PR_ID)
        .Nombre = Cell.Value
        .pr_id = Cell.Id
        
        .Cantidad = Val(pCell(Row, KI_CANTIDAD).Value)
        m_strDescrip = m_strDescrip & Cell.Value & _
                                      "(" & Format$(.Cantidad, "0.00") & "),"
      End With
      
    Next
  End With
  pSaveAlt = True
End Function

Private Function pLoadItems(ByRef Propiedad As cIABMProperty) As Boolean
  
  Dim Alt As cKitAlt
  
  With Propiedad.Grid
    
    .Columns.Clear
    .Rows.Clear
    
    With .Columns
      
      With .Add(Nothing)
        .Name = LNGGetText(1984, vbNullString)  'Alt.
        
        If m_Item.Alts.Count Then
          .PropertyType = cspList
          Set .DefaultValue = New cABMGridRowValue
          .DefaultValue.Id = m_Item.pr_id
          With .List
            With .Add(Nothing)
              .Value = m_Item.Nombre
              .Id = m_Item.pr_id
            End With
            For Each Alt In m_Item.Alts
              With .Add(Nothing)
                .Id = Alt.pr_id
                .Value = Alt.Nombre
              End With
            Next
          End With
          .Width = 1000
        Else
          .Visible = False
        End If
        .Key = KI_PR_ID
      End With
      
      With .Add(Nothing, c_col_serie_lote)
        If TypeOf m_Item Is cKitSerie Then
          .Name = LNGGetText(1992, vbNullString)  'Serie
          .PropertyType = cspHelp
          .Table = csProductoSerie
        ElseIf TypeOf m_Item Is cKitLote Then
          .Name = LNGGetText(1640, vbNullString)  'Lote
          .PropertyType = cspHelp
          .Table = csStockLote
        Else
          .Visible = False
        End If
        .Key = KI_SERIE_LOTE
        .Width = 2500
      End With
      
      With .Add(Nothing)
        If TypeOf m_Item Is cKitSerie Then
          .Visible = False
        Else
          .Name = LNGGetText(1374, vbNullString)  'Cantidad
          .PropertyType = cspNumeric
          .SubType = cspDouble
          .Width = 1000
        End If
        .Key = KI_CANTIDAD
      End With
    End With
    
    
    If TypeOf m_Item Is cKitSerie Then
      pLoadSerie m_Item, .Rows
      
    ElseIf TypeOf m_Item Is cKitLote Then
      pLoadLote m_Item, .Rows
      
    Else
      pLoadAlt m_Item, .Rows
    End If
    
  End With
  
  pLoadItems = True
End Function

Private Sub pLoadSerie(ByRef Serie As cKitSerie, _
                       ByRef Rows As cIABMGridRows)
  
  Dim Item As cKitSerieNumber
  
  For Each Item In Serie.Items
    With Rows.Add(Nothing)
      
      With .Add(Nothing)
        .Value = Item.Nombre
        .Id = Item.pr_id
        .Key = KI_PR_ID
      End With
      
      With .Add(Nothing)
        .Value = Item.Serie
        .Id = Item.prns_id
        .Key = KI_SERIE_LOTE
      End With
      
      ' En series la cantidad no se usa
      .Add(Nothing).Key = KI_CANTIDAD
    End With
  Next
End Sub

Private Sub pLoadLote(ByRef Lote As cKitLote, _
                      ByRef Rows As cIABMGridRows)

  Dim Item As cKitLoteNumber
  
  For Each Item In Lote.Items
    With Rows.Add(Nothing)
      
      With .Add(Nothing)
        .Value = Item.Nombre
        .Id = Item.pr_id
        .Key = KI_PR_ID
      End With
      
      With .Add(Nothing)
        .Value = Item.Lote
        .Id = Item.stl_id
        .Key = KI_SERIE_LOTE
      End With
      
      With .Add(Nothing)
        .Value = Item.Cantidad
        .Key = KI_CANTIDAD
      End With
    End With
  Next
End Sub

Private Sub pLoadAlt(ByRef Alt As cKitItem, _
                     ByRef Rows As cIABMGridRows)

  Dim Item As cKitAltItem
  
  For Each Item In Alt.Items
    With Rows.Add(Nothing)
      
      With .Add(Nothing)
        .Value = Item.Nombre
        .Id = Item.pr_id
        .Key = KI_PR_ID
      End With
      
      ' Las alternativas no usan esta columna
      '
      .Add(Nothing).Key = KI_SERIE_LOTE
      
      With .Add(Nothing)
        .Value = Item.Cantidad
        .Key = KI_CANTIDAD
      End With
    End With
  Next
End Sub

Private Function pBeforeEdit(ByVal lRow As Long, _
                             ByVal lCol As Long) As Boolean
  On Error GoTo ControlError
  
  Dim Serie   As cKitSerie
  Dim o       As cIABMGridColumn
  Dim iProp   As cIABMProperty
  Dim Row     As cIABMGridRow
  Dim i       As Long
  Dim iKey    As Long
  
  Set iProp = m_ObjAbm.Properties.Item(c_Items)
  Set o = iProp.Grid.Columns(lCol)
  Set Row = iProp.Grid.Rows(lRow)
  
  If TypeOf m_Item Is cKitSerie Then
    o.HelpFilter = gDB.sqlString( _
                   KitGetFilterSerie(m_Item, _
                                     Row, _
                                     i, _
                                     lRow, _
                                     lCol, _
                                     m_lRowKey, _
                                     m_lColKey + lRow, _
                                     m_depl_id, _
                                     m_ctrlStock, _
                                     m_depf_id, _
                                     m_KitLns, _
                                     m_KitLn, _
                                     m_ObjAbm, _
                                     True))
  ElseIf TypeOf m_Item Is cKitLote Then
    o.HelpFilter = pGetFilterLote(m_Item, Row, i, lRow)
  End If
  
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  AbmObj.RefreshColumnProperties iProp, c_col_serie_lote
  
  pBeforeEdit = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "pBeforeEdit ", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pGetFilterLote(ByRef Lote As cKitLote, _
                                ByRef Row As cIABMGridRow, _
                                ByVal idx As Long, _
                                ByVal lRow As Long) As String
                                
  Dim pr_id       As Long
  Dim filter      As String
  Dim FilterDepl  As String
  
  pr_id = pCell(Row, KI_PR_ID).Id
  If pr_id = csNO_ID Then
    pr_id = Lote.pr_id
  End If

  filter = KitGetFilterLote(Lote, _
                            pr_id, _
                            m_ctrlStock, _
                            m_depl_id, _
                            m_depf_id, _
                            lRow)
  
  pGetFilterLote = "'" & filter & "'"

'  Filter = cscPrId & " = " & pr_id
'
'  If m_depl_id <> csNO_ID Then
'                                    ' Este 'OR' es momentaneo hasta
'                                    ' que el control de stock este estable
'                                    '
'    If m_ctrlStock = csEStockFisico Or m_ctrlStock = csENoControlaStock Then
'      ' Si me indico un deposito y el stock es por deposito fisico
'      ' exijo que el numero de serie este en algun deposito logico
'      ' del deposito fisico al que pertenece el deposito logico
'      ' que me pasaron.
'      '
'      FilterDepl = " and " & cscDeplId & " in (select depl_id from depositoLogico where depf_id = " & m_depf_id & ")"
'
'      ' Sino es por deposito fisico exijo que este
'      ' en el deposito logico que me pasaron
'      '
'    ElseIf m_ctrlStock = csEStockLogico Then
'      FilterDepl = " and " & cscDeplId & " = " & m_depl_id
'    End If
'
'    If FilterDepl <> vbNullString Then
'      FilterDepl = " and exists (select stl_id from StockCache where pr_id = " & pr_id _
'                                & FilterDepl & _
'                                "group by stl_id having sum (stc_cantidad)>0.01)"
'
'      Filter = Filter & FilterDepl
'    End If
'
'  End If
'
'  Dim stl_id  As Long
'  Dim KitLote As cKitLoteNumber
'  Set KitLote = Lote.Items(GetKey(lRow))
'  If Not KitLote Is Nothing Then
'    If KitLote.pr_id = pr_id Then
'      stl_id = KitLote.stl_id
'      Filter = "(" & Filter & ") or ( stl_id = " & stl_id & ")"
'    End If
'  End If
'
'  pGetFilterLote = "'" & Filter & "'"
End Function

Private Function pGetPropKey(ByVal idx As Long, ByVal What As csE_ColType)
  pGetPropKey = idx + What
End Function

' construccion - destruccion
Private Sub Class_Terminate()
  On Error Resume Next
  Set m_ObjAbm = Nothing
End Sub

VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cProductoSerie"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIABMClient
Implements CSInterfacesABM.cIABMClientGrid
'--------------------------------------------------------------------------------
' cProductoSerie
' 18-06-04

'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes

Private Const C_Module = "cProductoSerie"

Private Const c_Items = "Items"
Private Const c_NroSerie = "NroS"
Private Const c_LoadEx = "LoadEx"
Private Const c_PasteXls = "PasteXls"
Private Const c_NoFiterDepl = "NoFilterDepl"

Private Const K_ITEMS          As Integer = 1
Private Const K_CMD_EDITEX     As Integer = 2
Private Const K_PASTE_FROM_XLS As Integer = 3
Private Const K_NOFILTER_DEPL  As Integer = 4

Private Const KI_PRNS_ID       As Integer = 1
Private Const KI_NUMERO        As Integer = 2
Private Const KI_NUMERO2       As Integer = 10
Private Const KI_NUMERO3       As Integer = 11
Private Const KI_DESCRIP       As Integer = 3
Private Const KI_FECHAVTO      As Integer = 4
Private Const KI_KITITEM       As Integer = 5
Private Const KI_DELETE        As Integer = 6


' estructuras
' variables privadas
Private m_Coll             As Collection

Private m_ObjAbm           As cIABMGeneric
Private m_IsInput          As Boolean
Private m_pr_id            As Long
Private m_depl_id          As Long
Private m_depf_id          As Long
Private m_ctrlStock        As csE_ControlStock
Private m_bEditKit         As Boolean
Private m_bParteProdKit    As Boolean
Private m_prov_id          As Long
Private m_cli_id           As Long
Private m_bDelete          As Boolean
Private m_DeleteCount      As Long

' propiedades publicas
Public Property Get Coll() As Collection
  Set Coll = m_Coll
End Property

Public Property Set Coll(ByRef rhs As Collection)
  Set m_Coll = rhs
End Property

Public Property Let IsInput(ByVal rhs As Boolean)
  m_IsInput = rhs
End Property

Public Property Let pr_id(ByVal rhs As Long)
  m_pr_id = rhs
End Property

Public Property Let depl_id(ByVal rhs As Long)
  m_depl_id = rhs
  pGetDepfId
End Property

Public Property Let bEditKit(ByVal rhs As Boolean)
  m_bEditKit = rhs
End Property

Public Property Let bParteProdKit(ByVal rhs As Boolean)
  m_bParteProdKit = rhs
End Property

Public Property Let prov_id(ByVal rhs As Long)
  m_prov_id = rhs
End Property

Public Property Let cli_id(ByVal rhs As Long)
  m_cli_id = rhs
End Property

Public Property Let Delete(ByVal rhs As Boolean)
  m_bDelete = rhs
End Property

Public Property Let DeleteCount(ByVal rhs As Long)
  m_DeleteCount = rhs
End Property

' propiedades privadas
' funciones publicas
Public Sub AddProductoSerie(ByRef pt As cProductoSerieType)
  On Error GoTo ControlError
  
  Dim pt2 As cProductoSerieType
  
  Set pt2 = New cProductoSerieType
  
  With pt2
    .Codigo = pt.Codigo
    .Codigo2 = pt.Codigo2
    .Codigo3 = pt.Codigo3
    .Descrip = pt.Descrip
    .FechaVto = pt.FechaVto
    .prns_id = pt.prns_id
    .pr_id_item = pt.pr_id_item
    .pr_id_kit = pt.pr_id_kit
    .KitItem = pt.KitItem
  End With
  
  m_Coll.Add pt2

  GoTo ExitProc
ControlError:
  MngError Err, "AddProductoSerie", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Public Function Edit() As Boolean
  On Error GoTo ControlError
  
  Dim AbmObj As cABMGeneric
  
  Set m_ObjAbm = New cABMGeneric
  Set AbmObj = m_ObjAbm
  AbmObj.OkCancelDialog = True
  AbmObj.bDontAskForSave = True
  
  m_ObjAbm.InModalWindow = True
  
  LoadCollection

  Edit = AbmObj.OkCancelDialogRslt
  
  GoTo ExitProc
ControlError:
  MngError Err, "Edit", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
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
    Case K_CMD_EDITEX
      pEditByRange
    Case K_PASTE_FROM_XLS
      pPasteFromXLS
  End Select
End Function

Private Function cIABMClient_Save() As Boolean
  cIABMClient_Save = pSaveItems
End Function

Private Function cIABMClient_Terminate() As Boolean
  cIABMClient_Terminate = True
End Function

Private Property Get cIABMClient_Title() As String
  cIABMClient_Title = LNGGetText(2890, vbNullString) 'Números de Serie
End Property

Private Function cIABMClient_Validate() As Boolean
  Dim DeleteCount   As Long
  Dim Row           As cIABMGridRow
  Dim iProp         As cIABMProperty
  
  Set iProp = m_ObjAbm.Properties.Item(c_Items)
  
  For Each Row In iProp.Grid.Rows
  
    If pCell(Row, KI_DELETE).Id Then
      DeleteCount = DeleteCount + 1
    End If
  Next
  
  If m_DeleteCount <> DeleteCount Then
    
    If m_DeleteCount > 1 Then
      MsgInfo LNGGetText(2891, vbNullString, m_DeleteCount)
              'Ud. ha maracado más números de serie que los requeridos.  & _
              Sólo se eliminarán los primeros  & m_DeleteCount &  marcados  & _
              empezando a contar desde la fila 1.
    Else
      MsgInfo LNGGetText(2892, vbNullString)
              'Ud. ha maracado más números de serie que los requeridos.  & _
              Solo se eliminará el primer número marcado  & _
              empezando a contar desde la fila 1.
    End If
  
    DeleteCount = 0
    For Each Row In iProp.Grid.Rows
    
      If DeleteCount >= m_DeleteCount Then
        pCell(Row, KI_DELETE).Id = 0
      Else
        If pCell(Row, KI_DELETE).Id Then
          DeleteCount = DeleteCount + 1
        End If
      End If
    Next
    
    m_ObjAbm.ShowValue iProp
  
  ElseIf m_DeleteCount > DeleteCount Then
    
    MsgInfo LNGGetText(2893, vbNullString)  'Debe marcar los números a eliminar.
    Exit Function
    
  End If
  
  cIABMClient_Validate = True

End Function

' Implementacion de cIABMClientGrid

Private Function cIABMClientGrid_ColumnAfterEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long) As Boolean
  Dim Row As cIABMGridRow
  
  ' Si no es un remito de compra o una factura de compra que mueve stock
  ' el numero de serie tiene que salir de la tabla ProductoNumeroSerie
  ' y como en la primera columna guardo el prns_id voy a actualizarlo
  ' para que todo el codigo trabaje bien
  '
  If Not m_IsInput Then
    Select Case Key
      Case K_ITEMS
        With m_ObjAbm.Properties(c_Items).Grid
          If .Columns(lCol).Key = KI_NUMERO Then
            Set Row = .Rows(lRow)
            pCell(Row, KI_PRNS_ID).Value = NewValueID
          End If
        End With
    End Select
  End If
  cIABMClientGrid_ColumnAfterEdit = True
End Function

Private Function cIABMClientGrid_ColumnBeforeEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean
  On Error GoTo ControlError
  
  Dim o       As cIABMGridColumn
  Dim iProp   As cIABMProperty
  Dim Row     As cIABMGridRow
  
  Set iProp = m_ObjAbm.Properties.Item(c_Items)
  Set o = iProp.Grid.Columns(lCol)
  If o.Key = KI_NUMERO Then
  
    Set Row = iProp.Grid.Rows(lRow)
    
    o.HelpFilter = gDB.sqlString(pGetFilter(Row, lRow))
    
    Dim AbmObj As cABMGeneric
    Set AbmObj = m_ObjAbm
    AbmObj.RefreshColumnProperties iProp, c_NroSerie
  
  ElseIf o.Key = KI_KITITEM Then
    Exit Function
  End If
  
  cIABMClientGrid_ColumnBeforeEdit = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ColumnBeforeEdit ", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
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
  ' Ninguna fila puede estar vacia
  ' ya que el usuario debe completar
  ' todos los numeros de serie
  cIABMClientGrid_IsEmptyRow = False
End Function

Private Function pValidateRowItems(Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell          As cIABMGridCellValue
  Dim strRow        As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_NUMERO
        If m_IsInput Then
          If ValEmpty(Cell.Value, csText) Then
            MsgInfo LNGGetText(1630, vbNullString, strRow) 'Debe indicar un número de serie (1)
            Exit Function
          End If
        Else
          If ValEmpty(Cell.Id, csId) Or Cell.Id < 0 Then
            MsgInfo LNGGetText(2894, vbNullString, strRow) 'Debe indicar un Número de Serie existente (1)
            Exit Function
          End If
        End If
    End Select
  Next
  
  pValidateRowItems = True
End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  Dim c As cIABMProperty
  
  With m_ObjAbm.Properties
    .Clear
  
    Set c = .Add(Nothing, c_Items)
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      If Not pLoadItems(c) Then Exit Function
      .name = c_Items
      .Key = K_ITEMS
      .GridEdit = True
      .Top = 1600
    End With
    
    If Not m_bDelete Then
      With .Add(Nothing, c_LoadEx)
        .PropertyType = cspButton
        .name = LNGGetText(2895, vbNullString) 'Cargar números por rango
        .LeftLabel = -1
        .Key = K_CMD_EDITEX
        .Top = 1100
        .Left = 380
      End With
      
      With .Add(Nothing, c_PasteXls)
        .PropertyType = cspButton
        .name = LNGGetText(1982, vbNullString) 'Pegar desde Excel
        .LeftLabel = -1
        .Key = K_PASTE_FROM_XLS
        .Top = 1100
        .Left = 3000
      End With
      
      With .Add(Nothing, c_NoFiterDepl)
        .PropertyType = cspCheck
        .name = LNGGetText(2896, vbNullString) 'No Filtrar por Depósitos
        .Key = K_NOFILTER_DEPL
        .Top = 1100
        .Left = 7500
        .LeftLabel = -1800
        .Visible = SecurityCanAccessSilent(csPreGSelectSerieEx)
      End With
      
    End If
  End With
  
  If m_bDelete Then
    If m_DeleteCount > 1 Then
      m_ObjAbm.Title2 = LNGGetText(2897, vbNullString, m_DeleteCount)
                        'Indique los  & m_DeleteCount &  números de serie a eliminar
    Else
      m_ObjAbm.Title2 = LNGGetText(2898, vbNullString)
                        'Indique el número a eliminar
    End If
  End If
  
  If Not m_ObjAbm.Show(Me) Then Exit Function

  LoadCollection = True
End Function

Private Function pLoadItems(ByRef Propiedad As cIABMProperty) As Boolean
  Dim pt      As cProductoSerieType
  
  With Propiedad.Grid.Columns
    
    With .Add(Nothing)
      .Visible = False
      .Key = KI_PRNS_ID
    End With
    
    With .Add(Nothing)
      .PropertyType = cspText
      .name = LNGGetText(2899, vbNullString)    'Item
      .Width = 2500
      .Visible = m_bEditKit
      .Key = KI_KITITEM
    End With
    
    With .Add(Nothing, c_NroSerie)
      .name = LNGGetText(1065, vbNullString)    'Numero
    
      If m_IsInput Then
        .PropertyType = cspText
      Else
        .PropertyType = cspHelp
        .Table = csProductoSerie
      End If
    
      .Enabled = Not m_bDelete
      
      .Width = 2500
      .Key = KI_NUMERO
    End With
    
    With .Add(Nothing)
      .name = LNGGetText(1983, vbNullString)    'Borrar
      .PropertyType = cspCheck
      .Key = KI_DELETE
      .Visible = m_bDelete
    End With
    
    With .Add(Nothing)
      .name = LNGGetText(2900, vbNullString)    'Número 2
      .PropertyType = cspText
      .Enabled = Not m_bDelete
      .Width = 2500
      .Key = KI_NUMERO2
    End With
    
    With .Add(Nothing)
      .name = LNGGetText(2901, vbNullString)    'Número 3
      .PropertyType = cspText
      .Enabled = Not m_bDelete
      .Width = 2500
      .Key = KI_NUMERO3
    End With
    
    With .Add(Nothing)
      .name = C_strDescrip
      .PropertyType = cspText
      .Enabled = Not m_bDelete
      .Width = 3000
      .Key = KI_DESCRIP
    End With
    
    With .Add(Nothing)
      .name = LNGGetText(2902, vbNullString)    'Fecha Vto.
      .PropertyType = cspDate
      .Enabled = Not m_bDelete
      .Width = 1200
      .Key = KI_FECHAVTO
    End With
    
  End With
  
  With Propiedad.Grid.Rows
    
    For Each pt In m_Coll
  
      With .Add(Nothing, pt.prns_id)
  
        With .Add(Nothing)
          .Value = pt.prns_id
          .Key = KI_PRNS_ID
        End With
        
        With .Add(Nothing)
          .Value = pt.KitItem
          .Id = pt.pr_id_item
          .Key = KI_KITITEM
        End With
        
        With .Add(Nothing)
          .Value = pt.Codigo
          .Id = pt.prns_id
          .Key = KI_NUMERO
        End With
        
        With .Add(Nothing)
          .Id = pt.Deleted
          .Key = KI_DELETE
        End With
        
        With .Add(Nothing)
          .Value = pt.Codigo2
          .Key = KI_NUMERO2
        End With
        
        With .Add(Nothing)
          .Value = pt.Codigo3
          .Key = KI_NUMERO3
        End With
        
        With .Add(Nothing)
          .Value = pt.Descrip
          .Key = KI_DESCRIP
        End With
        
        With .Add(Nothing)
          .Value = pt.FechaVto
          .Key = KI_FECHAVTO
        End With
      End With
    Next
  End With
  
  pLoadItems = True
End Function

Private Function pSaveItems() As Boolean
  Dim Row         As cIABMGridRow
  Dim Cell        As cIABMGridCellValue
  Dim i           As Long
  Dim pt          As cProductoSerieType
  
  For Each Row In m_ObjAbm.Properties(c_Items).Grid.Rows
    i = i + 1
    Set pt = m_Coll(i)
    For Each Cell In Row
      Select Case Cell.Key
        Case KI_DESCRIP
          pt.Descrip = Cell.Value
        Case KI_NUMERO
          pt.Codigo = Cell.Value
        Case KI_NUMERO2
          pt.Codigo2 = Cell.Value
        Case KI_NUMERO3
          pt.Codigo3 = Cell.Value
        Case KI_FECHAVTO
          pt.FechaVto = Cell.Value
        Case KI_PRNS_ID
          pt.prns_id = Val(Cell.Value)
        Case KI_DELETE
          pt.Deleted = Cell.Id
      End Select
    Next
  Next
  
  pSaveItems = pValidateUnique()
End Function

Private Function pValidateUnique() As Boolean
  Dim CollAux     As Collection
  Dim pt          As cProductoSerieType
  Dim series      As String
  Dim bNotUnique  As Boolean
  Dim q           As Integer
  
  On Error Resume Next
  
  Set CollAux = New Collection
  Err.Clear
  For Each pt In m_Coll
  
    CollAux.Add pt, "K" & pt.prns_id
    If Err.Number Then
      series = series & pt.Codigo & ", "
      Err.Clear
      q = q + 1
      bNotUnique = True
    End If
  Next
  
  If bNotUnique Then
    series = RemoveLastColon(RTrim$(series))
    If q > 1 Then
      MsgWarning LNGGetText(2903, vbNullString, series)
              'Los Números de Serie & series & están indicados más de una vez
    Else
      MsgWarning LNGGetText(2904, vbNullString, series)
                'El Número de Serie  & series &  está indicado más de una vez
    End If
    Exit Function
  End If
  
  pValidateUnique = True
End Function

Private Sub pPasteFromXLS()

  Dim Data  As String
  Dim vData As Variant
  
  Data = Clipboard.GetText
  vData = Split(Data, Chr(13) & Chr(10))

  If UBound(vData) < 0 Then Exit Sub

  Dim Row       As cIABMGridRow
  Dim firstRow  As Long
  Dim iProp     As cIABMProperty
  Dim q         As Long
  Dim i         As Long
  
  Set iProp = m_ObjAbm.Properties(c_Items)
  
  firstRow = iProp.SelectedIndex
  If firstRow < 1 Then firstRow = 1
  
  For i = firstRow To m_Coll.Count
    
    If UBound(vData) < q Then Exit For
    
    Set Row = iProp.Grid.Rows(i)
    
    With pCell(Row, KI_NUMERO)
      .Value = vData(q)
      If Not m_IsInput Then
        .Id = pSetPrnsId(Row, i, .Value)
        pCell(Row, KI_PRNS_ID).Value = .Id
      End If
    End With
    q = q + 1
  Next
  
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  AbmObj.ShowValue iProp, True
End Sub

Private Sub pEditByRange()
  Dim PrnsRange As cProductoSerieRange
  
  Set PrnsRange = New cProductoSerieRange
  If Not PrnsRange.Edit() Then Exit Sub
  
  Dim iProp As cIABMProperty
  Set iProp = m_ObjAbm.Properties(c_Items)
  
  Dim first       As String
  Dim last        As String
  Dim current     As String
  Dim bByChar     As Boolean
  Dim i           As Long
  Dim valueAux    As Long
  Dim firstRow    As Long
  
  bByChar = PrnsRange.bByChar
  first = PrnsRange.first
  last = PrnsRange.last
  
  '-----------------
  ' TODO: por ahora no soportamos incrementacion alfabetica
  If bByChar Then
    MsgInfo LNGGetText(1986, vbNullString)  'Esta opción aún no esta implementada
    Exit Sub
  End If
  
  If IsNumeric(first) Then
    current = pGetFirstSerie(first)
  Else
    current = first
  End If
  valueAux = pGetFirstSerie(first)
  
  firstRow = iProp.SelectedIndex
  If firstRow < 1 Then firstRow = 1
  
  Dim Row As cIABMGridRow
  
  For i = firstRow To m_Coll.Count
    current = pIncrement(current, bByChar, valueAux)
    
    Set Row = iProp.Grid.Rows(i)
    
    If pFinish(current, last) Then Exit For
    
    With pCell(Row, KI_NUMERO)
      .Value = current
      If Not m_IsInput Then
        .Id = pSetPrnsId(Row, i, .Value)
        pCell(Row, KI_PRNS_ID).Value = .Id
      End If
    End With
  Next
  
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  AbmObj.ShowValue iProp, True
End Sub

Private Function pFinish(ByVal current As String, ByVal last As String) As Boolean
  If IsNumeric(last) And IsNumeric(current) Then
    pFinish = Val(last) < Val(current)
  Else
    pFinish = last < current
  End If
End Function

Private Function pGetFirstSerie(ByVal first As String) As Variant
  Dim rtn           As Variant
  Dim aux           As String
  Dim n             As Long
  Dim strZeroLeft   As String
  
  If IsNumeric(first) Then
    
    If Len(Trim$(Val(first))) < Len(first) Then
      strZeroLeft = Mid(first, 1, Len(first) - Len(Trim$(Val(first))))
    End If
    
    rtn = strZeroLeft & Abs(Val(first) - 1)
    
  Else
    Do
      n = n + 1
      aux = Right$(first, n)
    Loop Until Not IsNumeric(aux)
    aux = Mid(aux, 2)
    If IsNumeric(aux) Then
      rtn = Val(aux) - 1
    Else
      rtn = 0
    End If
  End If
  pGetFirstSerie = rtn
End Function

Private Function pIncrement(ByVal Value As String, ByVal bByChar As Boolean, ByRef valueAux As Long) As String
  Dim length        As Long
  Dim strNumber     As String
  Dim strZeroLeft   As String
  
  If bByChar Then
  Else
    If IsNumeric(Value) Then
    
      If Len(Trim$(Val(Value))) < Len(Value) Then
        strZeroLeft = Mid$(Value, 1, Len(Value) - Len(Trim$(Val(Value) + 1)))
      End If
      
      Value = strZeroLeft & Val(Value) + 1
      
    Else
      valueAux = valueAux + 1
      strNumber = valueAux
      length = Len(Value) - Len(strNumber)
      If length < 0 Then length = 0
      Value = Mid$(Value, 1, length)
      Value = Value & strNumber
    End If
  End If
  
  pIncrement = Value
End Function

Private Function pGetDepfId()
  If m_depl_id = csNO_ID Then
    m_depf_id = csNO_ID
    m_ctrlStock = csENoControlaStock
  Else
    gDB.GetData csTDepositoLogico, cscDeplId, m_depl_id, cscDepfId, m_depf_id
    pGetTypeStockControl
  End If
End Function

Private Sub pGetTypeStockControl()
  Dim rs        As ADODB.Recordset
  Dim sqlstmt   As String
  sqlstmt = "select cfg_valor from configuracion where cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & " and cfg_aspecto = " & gDB.sqlString(c_TipoControlStock)
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  If rs.EOF Then Exit Sub
  m_ctrlStock = Val(gDB.ValField(rs.fields, cscCfgValor))
End Sub

' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  Set m_Coll = New Collection

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
  On Error Resume Next
  Set m_Coll = Nothing
  Set m_ObjAbm = Nothing
End Sub

Private Function pSetPrnsId(ByVal Row As cIABMGridRow, _
                            ByVal lRow As Long, _
                            ByVal prnsCodigo As String) As Long
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "select prns_id from ProductoNumeroSerie where prns_codigo = " _
              & gDB.sqlString(prnsCodigo) _
              & " and " & pGetFilter(Row, lRow)
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  If rs.EOF Then Exit Function
  
  pSetPrnsId = gDB.ValField(rs.fields, cscPrnsId)
End Function

Private Function pGetFilter(ByVal Row As cIABMGridRow, ByVal lRow As Long) As String
  Dim Filter          As String
  Dim pt              As cProductoSerieType
  Dim bNoFilterDepl   As Boolean
  
  Set pt = m_Coll.Item(lRow)

  If m_bEditKit And Not m_bParteProdKit Then
    ' Tiene que ser un numero de serie asociado a un kit de este tipo de pr_id
    '
    Filter = cscPrId & " = " & pCell(Row, KI_KITITEM).Id & " and pr_id_kit = " & m_pr_id
    
  ElseIf m_bParteProdKit Then
    ' Tiene que ser un numero de serie que no este asociado a ningun kit o
    ' asociado a un kit que componga al kit que estamos editando
    '
    Filter = cscPrId & " = " & pCell(Row, KI_KITITEM).Id
    If pt.pr_id_kit <> 0 Then
      Filter = Filter & " and pr_id_kit = " & pt.pr_id_kit
    Else
      Filter = Filter & " and pr_id_kit is null"
    End If
  
  Else
    ' Tiene que ser un numero de serie que no este asociado a ningun kit
    '
    Filter = cscPrId & " = " & m_pr_id & " and pr_id_kit is null"
  End If
  
  bNoFilterDepl = pGetNoFilterDepl()
  
  If Not bNoFilterDepl Then
  
    ' Los contra-documentos (devoluciones y notas de credito) envian
    ' el deposito del tercero y el cliente o proveedor segun corresponda
    '
    If m_depl_id = csE_DepositosInternos.csEDeplIdTercero Then
    
      Filter = Filter & " and depl_id = " & csE_DepositosInternos.csEDeplIdTercero
      
      If m_cli_id <> csNO_ID Then
        Filter = Filter & " and cli_id = " & m_cli_id
        
      ElseIf m_prov_id <> csNO_ID Then
        
        Filter = Filter & " and (prov_id = " & m_prov_id & " or prov_id is null)"
      End If
    
    Else
      ' No puede estar en depositos internos del sistema
      '
      Filter = Filter & " and depl_id not in (-2,-3)"
    End If
    
    If m_depl_id <> csNO_ID Then
                                      ' Este 'OR' es momentaneo hasta
                                      ' que el control de stock este estable
                                      '
      If m_ctrlStock = csEStockFisico Or m_ctrlStock = csENoControlaStock Then
        ' Si me indico un deposito y el stock es por deposito fisico
        ' exijo que el numero de serie este en algun deposito logico
        ' del deposito fisico al que pertenece el deposito logico
        ' que me pasaron.
        '
        Filter = Filter & " and " & cscDeplId & " in (select depl_id from depositoLogico where depf_id = " & m_depf_id & ")"
        
        ' Sino es por deposito fisico exijo que este
        ' en el deposito logico que me pasaron
        '
      ElseIf m_ctrlStock = csEStockLogico Then
        Filter = Filter & " and " & cscDeplId & " = " & m_depl_id
      End If
    
    Else
      Filter = Filter & " and (1=2)"
    End If
  
  End If
  
  If pt.prns_id Then
    Filter = "(" & Filter & ") or ( prns_id = " & pt.prns_id & ")"
  End If
  
  pGetFilter = Filter
End Function

Private Function pGetNoFilterDepl() As Boolean
  pGetNoFilterDepl = Val(m_ObjAbm.Properties.Item(c_NoFiterDepl).Value)
End Function

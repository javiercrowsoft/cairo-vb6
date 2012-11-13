VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cKitEdit"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIABMClient
Implements CSInterfacesABM.cIABMClientGrid
'--------------------------------------------------------------------------------
' cKitEdit
' 17-08-2006

'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes

Private Const C_Module = "cKitEdit"

Private Const c_LoadEx = "LoadEx"
Private Const c_PasteXls = "PasteXls"
Private Const c_BarcodeInput = "BarcodeInput"
Private Const c_BarcodeDesc = "BarcodeDesc"

Private Const c_cmd_aceptar = "**ACEPTAR"
Private Const c_cmd_cancelar = "**CANCELAR"

Private Const K_ITEMS          As Integer = 1
Private Const K_CMD_EDITEX     As Integer = 2
Private Const K_PASTE_FROM_XLS As Integer = 3

Private Const K_BARCODE_INPUT  As Integer = 4
Private Const K_BARCODE_DESC   As Integer = 5

Private Const KI_PRK_ID        As Integer = -100
Private Const KI_DELETE        As Integer = -101

' estructuras

' pseudo constantes
Private c_cmd_bajar_renglon     As String
Private c_cmd_subir_renglon     As String
Private c_cod_barra_tipo        As csE_StockCodigoBarraTipo
Private c_cod_barra_longitud    As Long
Private c_cod_barra_caracter    As String

' variables privadas
Private m_ctrlStock         As csE_ControlStock
Private m_depf_id           As Long
Private m_depl_id           As Long
Private m_KitLn             As cKitLine
Private m_KitLns            As cKitLines
Private m_bDelete           As Boolean

Private m_ObjAbm            As cIABMGeneric

Private m_strDescrip        As String

Private m_BarcodeActiveRow  As Long

Private m_vLoteAux()        As Boolean

' propiedades publicas
' propiedades privadas
' funciones publicas
Public Function Edit(ByRef KitLn As cKitLine, _
                     ByVal depl_id As Long, _
                     ByRef KitLines As cKitLines, _
                     ByRef Row As cIABMGridRow, _
                     ByVal KI_ID As Long, _
                     ByVal bDelete As Boolean) As Boolean
  
  
  Dim StockConfig As CSGeneralEx2.cStockConfig
  Set StockConfig = New CSGeneralEx2.cStockConfig
  
  If Not StockConfig.Load() Then Exit Function
  
  With StockConfig
    
    c_cmd_subir_renglon = .StockCodigoBarraSubir
    c_cmd_bajar_renglon = .StockCodigoBarraBajar
    c_cod_barra_tipo = .StockCodigoBarraTipo
    c_cod_barra_longitud = .StockCodigoBarraLongitud
    c_cod_barra_caracter = .StockCodigoBarraTipo
    
  End With
  
  ReDim m_vLoteAux(0)
  
  m_depl_id = depl_id
  m_bDelete = bDelete
  
  pGetDepfId
  Set m_KitLns = KitLines
  Set m_KitLn = KitLn
  Set m_ObjAbm = New cABMGeneric
  
  Dim AbmObj As cABMGeneric
  
  Set AbmObj = m_ObjAbm
  AbmObj.OkCancelDialog = True
  m_ObjAbm.InModalWindow = True
  
  If Not LoadCollection() Then Exit Function
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  If AbmObj.OkCancelDialogRslt() Then
    
    pCell(Row, KI_ID).Value = RemoveLastColon(m_strDescrip)
    Edit = True
  End If
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
  Select Case Key
    Case K_CMD_EDITEX
      pEditByRange pGetColActive()
    Case K_PASTE_FROM_XLS
      pPasteFromXLS pGetColActive()
    Case K_BARCODE_INPUT
      cIABMClient_PropertyChange = pProcessBarcode()
    Case K_BARCODE_DESC
      cIABMClient_PropertyChange = False
  End Select
End Function

Private Function cIABMClient_Save() As Boolean
  If m_bDelete Then
    cIABMClient_Save = pDeleteItems()
  Else
    cIABMClient_Save = pSaveItems()
  End If
End Function

Private Function cIABMClient_Terminate() As Boolean
  Set m_KitLn = Nothing
  Set m_KitLns = Nothing
  cIABMClient_Terminate = True
End Function

Private Property Get cIABMClient_Title() As String
  cIABMClient_Title = LNGGetText(1301, vbNullString)  'Kit
End Property

Private Function cIABMClient_Validate() As Boolean
  ReDim m_vLoteAux(0)
  cIABMClient_Validate = True
End Function

' Implementacion de cIABMClientGrid
Private Function cIABMClientGrid_ColumnAfterEdit(ByVal Key As Integer, _
                                                 ByVal lRow As Long, _
                                                 ByVal lCol As Long, _
                                                 ByVal NewValue As Variant, _
                                                 ByVal NewValueID As Long) As Boolean
  If m_bDelete Then
    cIABMClientGrid_ColumnAfterEdit = pGetItems().Grid.Columns.Item(lCol).Key = KI_DELETE
  Else
    cIABMClientGrid_ColumnAfterEdit = True
  End If
End Function

Private Function cIABMClientGrid_ColumnBeforeEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean
  If m_bDelete Then
    cIABMClientGrid_ColumnBeforeEdit = pGetItems().Grid.Columns.Item(lCol).Key = KI_DELETE
  Else
    cIABMClientGrid_ColumnBeforeEdit = pBeforeEdit(lRow, lCol)
  End If
End Function

Private Function cIABMClientGrid_ColumnButtonClick(ByVal Key As Integer, _
                                                   ByVal lRow As Long, _
                                                   ByVal lCol As Long, _
                                                   ByVal iKeyAscii As Integer) As Boolean
    
  Dim Serie     As cKitSerie
  Dim Lote      As cKitLote
  Dim Alt       As cKitItem
  Dim Item      As Object
  Dim EditAux   As cKitEditAux
  Dim i         As Long
  Dim iKey      As Long
  Dim o         As cIABMGridColumn
  Dim iProp     As cIABMProperty
  
  Set iProp = pGetItems()
  Set o = iProp.Grid.Columns(lCol)
  
  For Each Serie In KitGetKit(m_KitLn, lRow).Series
  
    i = i + 1
    iKey = KitGetPropKey(i, csECT_Serie)
    
    If o.Key = iKey Then
      Set Item = Serie
      Exit For
    End If
  Next
  
  If Item Is Nothing Then
    
    For Each Lote In KitGetKit(m_KitLn, lRow).Lotes
    
      i = i + 1
      iKey = KitGetPropKey(i, csECT_Lote)
      
      If o.Key = iKey Then
        Set Item = Lote
        Exit For
      End If
    Next
  End If
  
  If Item Is Nothing Then
    
    For Each Alt In KitGetKit(m_KitLn, lRow).Alts
    
      i = i + 1
      iKey = KitGetPropKey(i, csECT_Alt)
      
      If o.Key = iKey Then
        Set Item = Alt
        Exit For
      End If
    Next
  End If
  
  If Not Item Is Nothing Then
  
    Dim strDescrip As String
    Set EditAux = New cKitEditAux
    
    If EditAux.Edit(KitGetKit(m_KitLn, lRow), _
                    Item, _
                    m_depl_id, _
                    m_depf_id, _
                    m_ctrlStock, _
                    m_KitLn, _
                    m_KitLns, _
                    lRow, _
                    lCol, _
                    strDescrip) Then
      With iProp.Grid.Rows
        pCell(.Item(lRow), iKey).Value = strDescrip
      End With
      
    End If
  End If
  
  cIABMClientGrid_ColumnButtonClick = True
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
  pIsEmptyRowItems = False
End Function

Private Function pValidateRowItems(Row As CSInterfacesABM.cIABMGridRow, _
                                   ByVal RowIndex As Long) As Boolean
                                   
  Dim Cell        As cIABMGridCellValue
  Dim strRow      As String
  Dim i           As Long
  Dim iLote       As Long
  Dim iColLote    As Long
  Dim nlotes      As Long
  Dim Lotes       As cKitLotes
  
  strRow = " (Fila " & RowIndex & ")"
  
  Dim Serie As cKitSerie
  Dim Lote  As cKitLote
  Dim Alt   As cKitItem
  Dim Var   As cKitVar
  
  ' Controlo lo que hay en la grilla
  ' Series, Alts y Variables
  '
  For Each Serie In m_KitLn.KitType.Series
    i = i + 1
    If Not (Serie.Variable Or Serie.ta_id <> csNO_ID) Then
      If ValEmpty(pCell(Row, KitGetPropKey(i, csECT_Serie)).Id, csId) Then
        MsgInfo LNGGetText(2034, vbNullString, Serie.Nombre, strRow)
                'Debe indicar un Número de Serie para " & Serie.Nombre & strRow
        Exit Function
      End If
    End If
  Next
  
  iColLote = i
  i = i + m_KitLn.KitType.Lotes.Count
  
  ' Las alternativas se resuelven por el
  ' producto default indicado en la formula
  '
  i = i + m_KitLn.KitType.Alts.Count
  
  For Each Var In m_KitLn.KitType.Vars
    i = i + 1
    If ValEmpty(pCell(Row, KitGetPropKey(i, csECT_Var)).Value, csDouble) Then
      If Not Ask(LNGGetText(2035, vbNullString, Var.Nombre, strRow), vbNo) Then
                 'No ha indicado una cantidad para le item con cantidad variable " & _
                 'Var.Nombre & " en la fila" & strRow & _
                 '";;¿Confirma que la carga del kit es correcta?", vbNo) Then
        Exit Function
      End If
    End If
  Next
  
  ' Controlo lo que hay en las colecciones
  ' Lotes y Series/Alts con cant. variable
  '
  For Each Serie In KitGetKit(m_KitLn, RowIndex).Series
    If Serie.Variable Then
      If Serie.Items.Count = 0 Then
        If Not Ask(LNGGetText(2036, vbNullString, Serie.Nombre, strRow), vbNo) Then
                  '"No ha indicado números de serie para el item " & _
                  ' Serie.Nombre & " en la fila" & strRow & _
                  ' ";;¿Confirma que la carga del kit es correcta?", vbNo) Then
          Exit Function
        End If
      End If
    End If
  Next
  
  nlotes = KitGetKit(m_KitLn, RowIndex).Lotes.Count
  If UBound(m_vLoteAux) < nlotes Then
    ReDim m_vLoteAux(nlotes)
  End If
  
  Set Lotes = KitGetKit(m_KitLn, 1).Lotes
  
  For Each Lote In KitGetKit(m_KitLn, RowIndex).Lotes
    
    iLote = iLote + 1
    iColLote = iColLote + 1
    
    If Lote.Items.Count = 0 Then
      If (Lote.Variable Or Lote.ta_id <> csNO_ID) Then
      
        If Lote.Variable Then
          If Not Ask(LNGGetText(2037, vbNullString, Lote.Nombre, strRow), vbNo) Then
                     '"No ha indicado números de lote para el item " & _
                     'Lote.Nombre & " en la fila" & strRow & _
                     '";;¿Confirma que la carga del kit es correcta?", vbNo) Then
            Exit Function
          End If
        End If
      Else
      
        If RowIndex > 1 Then
        
          If Not m_vLoteAux(iLote) Then
          
            If Not Ask(LNGGetText(2038, vbNullString, Lote.Nombre, strRow), vbNo) Then
                       '"No ha indicado números de lote para el item " & _
                       'Lote.Nombre & " en la fila" & strRow & _
                       '";;¿Desea utilizar el lote de la primera fila para todos los kits?", vbNo) Then
              Exit Function
            End If
            
            m_vLoteAux(iLote) = True
          End If
          
          pCopyLote Lote, Lotes.Item(iLote), iColLote, RowIndex
          
        Else
          MsgInfo LNGGetText(2039, vbNullString, Lote.Nombre, strRow)
                  'Debe indicar al menos un Número de Lote para
                   'Lote.Nombre & " en la fila" & strRow
          Exit Function
        End If
      End If
    End If
  Next
  
  For Each Alt In KitGetKit(m_KitLn, RowIndex).Alts
    If Alt.Variable Then
      If Alt.Items.Count = 0 Then
        If Not Ask(LNGGetText(2040, vbNullString, Alt.Nombre, strRow), vbNo) Then
                  '"No ha indicado alternativas para el item " & _
                  ' Alt.Nombre & " en la fila" & strRow & _
                  ' ";;¿Confirma que la carga del kit es correcta?", vbNo) Then
          Exit Function
        End If
      End If
    End If
  Next
  
  pValidateRowItems = True
End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  
  Dim c As cIABMProperty
  
  With m_ObjAbm
  
    .Title2 = m_KitLn.KitType.Nombre
    
    With .Properties
      
      .Clear
    
      Set c = .Add(Nothing, c_Items)
      With c
        .PropertyType = cspGrid
        .LeftLabel = -1
        If Not pLoadItems(c) Then Exit Function
        .Name = LNGGetText(1371, vbNullString)  'Items
        .Key = K_ITEMS
        .GridEdit = True
        .Top = 1600
      End With
      
      With .Add(Nothing, c_LoadEx)
        .PropertyType = cspButton
        .Name = LNGGetText(1981, vbNullString)  'Cargar por Rango
        .LeftLabel = -1
        .Key = K_CMD_EDITEX
        .Top = 1100
        .Left = 380
        .Width = 1500
      End With
    
      With .Add(Nothing, c_PasteXls)
        .PropertyType = cspButton
        .Name = LNGGetText(1982, vbNullString)  'Pegar desde Excel
        .LeftLabel = -1
        .Key = K_PASTE_FROM_XLS
        .Top = 1100
        .Left = 2000
        .Width = 1800
      End With
    
      With .Add(Nothing, c_BarcodeInput)
        .PropertyType = cspText
        .Name = LNGGetText(1177, vbNullString)  'Código de Barras
        .LeftLabel = -1300
        .Key = K_BARCODE_INPUT
        .TopFromProperty = c_LoadEx
        .Left = 5200
      End With
    
      With .Add(Nothing, c_BarcodeDesc)
        .PropertyType = cspText
        .Name = LNGGetText(1367, vbNullString)  'Artículo
        .LeftLabel = -700
        .Key = K_BARCODE_DESC
        .TopFromProperty = c_LoadEx
        .Width = 3500
        .Left = 8300
      End With
    End With
  End With

  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  AbmObj.NoChangeColsInRefresh = True

  LoadCollection = True
End Function

Private Function pGetItems() As cIABMProperty
  Set pGetItems = m_ObjAbm.Properties.Item(c_Items)
End Function

Private Function pDeleteItems() As Boolean
  Dim Row       As cIABMGridRow
  Dim lRow      As Long
  Dim Kit       As cKit
  Dim i         As Long
  Dim Serie     As cKitSerie
  Dim Lote      As cKitLote
  Dim Alt       As cKitItem
  Dim Var       As cKitVar
  
  Dim SerieN    As cKitSerieNumber
  Dim LoteN     As cKitLoteNumber
  Dim AltI      As cKitAltItem
  
  m_strDescrip = vbNullString
  
  '----------------------------------------------------------
  ' Cada fila contiene toda la definicion de un Kit
  '
  For Each Row In pGetItems().Grid.Rows
    
    lRow = lRow + 1
    Set Kit = KitGetKit(m_KitLn, lRow)
    
    If pCell(Row, KI_DELETE).Id Then
      
      For i = 1 To m_KitLn.Items.Count
        If Kit Is m_KitLn.Items.Item(i) Then
          m_KitLn.Items.Remove i
          Exit For
        End If
      Next
    
    Else
      
      For Each Serie In Kit.Series
        For Each SerieN In Serie.Items
          m_strDescrip = m_strDescrip & SerieN.Serie & ","
        Next
      Next
    
      For Each Lote In Kit.Lotes
        For Each LoteN In Lote.Items
          m_strDescrip = m_strDescrip & LoteN.Lote & ","
        Next
      Next
    
      For Each Alt In Kit.Alts
        For Each AltI In Alt.Items
          m_strDescrip = m_strDescrip & AltI.Nombre & ": " & AltI.Cantidad & ","
        Next
      Next
    
      For Each Var In Kit.Vars
        m_strDescrip = m_strDescrip & Var.Nombre & ": " & Var.Cantidad & ","
      Next
    End If
    
  Next
  
  Dim tmpItems As cKits
  Set tmpItems = New cKits
  
  ' Paso a una coleccion temporal todos
  ' los kits para que su key coincida con
  ' su indice por que lo necesito para
  ' editarlos
  '
  i = 0
  For Each Kit In m_KitLn.Items
    i = i + 1
    tmpItems.Add GetKey(i), Kit
  Next
  
  Set m_KitLn.Items = tmpItems
  
  pDeleteItems = True
End Function

Private Function pSaveItems() As Boolean
  Dim Row       As cIABMGridRow
  Dim Serie     As cKitSerie
  Dim Lote      As cKitLote
  Dim Alt       As cKitItem
  Dim Var       As cKitVar
  Dim iCol      As Long
  Dim n         As Long
  Dim q         As Long
  Dim bHaveAlt  As Boolean
  Dim Cell      As cIABMGridCellValue
  Dim lRow      As Long
  Dim Kit       As cKit
  
  m_strDescrip = vbNullString
  
  Dim vSeries()   As String
  Dim idx         As Long
  Dim ubSeries    As Long
  
  ubSeries = 400
  ReDim vSeries(ubSeries)
  
  '----------------------------------------------------------
  ' Cada fila contiene toda la definicion de un Kit
  '
  For Each Row In pGetItems().Grid.Rows
    
    iCol = 0
    
    lRow = lRow + 1
    
    Set Kit = KitGetKit(m_KitLn, lRow)
    
    ' Series
    '
    For Each Serie In Kit.Series
      
      ' Si la cantidad es variable
      ' la coleccion se actualiza
      ' cuando el usuario ingresa
      ' a la celda y se edita en
      ' cKitEditAux
      '
      If Serie.Variable Then
        iCol = iCol + 1
      
      Else
        
        ' Por cada numero de serie tengo
        ' una columna y opcinalmente una columna
        ' para su alternativa.
        '
        ' Esto mutlitiplicado por la cantidad
        ' indicada en el item de la formula.
        '
        ' Es decir un kit que lleva 3 del producto
        ' XXX que indica numero de serie y posee
        ' alternativas YYY y ZZZ, da como resultado
        ' seis columnas en esta grilla.
        '
        ' Siempre accedo a las celdas a travez de
        ' la propiedad Key usando pCell.
        '
        
        bHaveAlt = Serie.Alts.Count
        
        n = Serie.Cantidad
        If n < 1 Then n = 1 ' Por seguridad
        
        With Serie.Items
          .Clear
          
          For q = 1 To n
            
            iCol = iCol + 1
            With .Add(KitGetKeyItem(lRow, iCol))
              Set Cell = pCell(Row, KitGetPropKey(iCol, csECT_Serie))
              .prns_id = Cell.Id
              .Serie = Cell.Value
              
              If idx > ubSeries Then
                ubSeries = ubSeries + 400
                ReDim Preserve vSeries(ubSeries)
              End If
              
              vSeries(idx) = .Serie
              
              idx = idx + 1

              If bHaveAlt Then
                Set Cell = pCell(Row, KitGetPropKey(iCol, csECT_SerieA))
                If Cell.Id Then
                  .pr_id = Cell.Id
                Else
                  .pr_id = Serie.pr_id
                End If
                .Nombre = Cell.Value
              Else
                .pr_id = Serie.pr_id
              End If
            End With
          Next
        End With
      End If
    Next
    
    ' Los Lotes se cargan a tavez de EditAux,
    ' excepto en el caso del lote del kit
    ' que sale de un talonario
    '
    If Kit.bIdentidad And Kit.bLote And Not Kit.bLoteXItem Then
      
      Set Cell = pCell(Row, KitGetPropKey(iCol + 1, csECT_Lote))
      Kit.stl_id = Cell.Id
      Kit.stl_codigo = Cell.Value
      
    End If
    
    ' Desplazo el indice de columnas
    ' para descartar todas las de lotes
    '
    iCol = iCol + Kit.Lotes.Count
    
    
    ' Alternativas
    '
    For Each Alt In Kit.Alts
      ' Si la cantidad es variable
      ' la coleccion se actualiza
      ' cuando el usuario ingresa
      ' a la celda y se edita en
      ' cKitEditAux
      '
      If Alt.Variable Or Alt.Cantidad > 3 Then
        iCol = iCol + 1
      
        If idx > ubSeries Then
          ubSeries = ubSeries + 400
          ReDim Preserve vSeries(ubSeries)
        End If
        
        vSeries(idx) = pCell(Row, KitGetPropKey(iCol, csECT_Alt)).Value
        
        idx = idx + 1
      
      Else
        
        ' Por cada alternativa tengo una columna
        '
        ' Esto mutlitiplicado por la cantidad
        ' indicada en el item de la formula.
        '
        ' Es decir un kit que lleva 3 del producto
        ' XXX y posee alternativas da como resultado
        ' tres columnas en esta grilla.
        '
        ' Siempre accedo a las celdas a travez de
        ' la propiedad Key usando pCell.
        '
        n = Alt.Cantidad
        If n < 1 Then n = 1 ' Por seguridad
        
        With Alt.Items
          .Clear
          
          For q = 1 To n
            
            iCol = iCol + 1
            With .Add()
              Set Cell = pCell(Row, KitGetPropKey(iCol, csECT_Alt))
              
              ' Si no indico alternativa usamos
              ' el indicado en la formula
              '
              If Cell.Id = csNO_ID Then
                .pr_id = Alt.pr_id
                .Nombre = Alt.Nombre
              Else
                .pr_id = Cell.Id
                .Nombre = Cell.Value
              End If
              .Cantidad = 1
              
              If idx > ubSeries Then
                ubSeries = ubSeries + 400
                ReDim Preserve vSeries(ubSeries)
              End If
              
              vSeries(idx) = .Nombre
              
              idx = idx + 1
              
            End With
          Next
        End With
      End If
    Next
    
    ' Variables
    '
    For Each Var In Kit.Vars
          
      iCol = iCol + 1
      Var.Cantidad = Val(pCell(Row, KitGetPropKey(iCol, csECT_Var)).Value)
      
      If idx > ubSeries Then
        ubSeries = ubSeries + 400
        ReDim Preserve vSeries(ubSeries)
      End If
      
      vSeries(idx) = Var.Nombre & ": " & Var.Cantidad
      
      idx = idx + 1
      
    Next
    
    ' Identidad y lote del Kit
    '
    If Kit.bIdentidad Then
      
      If Kit.bIdentidadXItem Then
        For Each Serie In Kit.Series
          If Serie.pr_id = Kit.pr_id_serie Then
            If Serie.Items.Count < 1 Then
              MsgWarning LNGGetText(2041, vbNullString, Serie.Nombre, lRow)
                         'Debe indicar el número de serie para el item
                         'Serie.Nombre que identifica al Kit en la fila  & lRow
              Exit Function
            Else
              Kit.prns_id = Serie.Items(1).prns_id
              Exit For
            End If
          End If
        Next
      
      Else
      
        ' Si la identidad no es por item, en load
        ' le agregamos como primer serie el mismo kit
        ' y le dimos el talonario.
        '
        With Kit.Series.Item(1).Items(1)
          Kit.prns_id = .prns_id
          Kit.prns_codigo = .Serie
        End With
      End If
    
      If Kit.bLote And Kit.bLoteXItem Then
        For Each Lote In Kit.Lotes
          If Lote.pr_id = Kit.pr_id_lote Then
            If Lote.Items.Count < 1 Then
              MsgWarning LNGGetText(2042, vbNullString, Serie.Nombre, lRow)
                          'Debe indicar el lote para el item " & _
                          'Lote.Nombre & _
                          'que identifica al Kit para la fila " & lRow
              Exit Function
            Else
              Kit.stl_id = Lote.Items(1).stl_id
              Exit For
            End If
          End If
        Next
      End If
    End If
    
  Next
  
  idx = idx - 1
  If idx >= 0 Then
    ReDim Preserve vSeries(idx)
    m_strDescrip = Join(vSeries, ",")
  End If
  
  pSaveItems = True
End Function

Private Function pLoadItems(ByRef Propiedad As cIABMProperty) As Boolean
  
  Dim Serie     As cKitSerie
  Dim Lote      As cKitLote
  Dim Item      As cKitItem
  Dim Var       As cKitVar
  Dim bHaveAlt  As Boolean
  Dim iCols     As Long
  Dim iKey      As Long
  Dim q         As Long
  Dim n         As Long
  Dim i         As Long
  Dim j         As Long
  Dim Cols      As cIABMGridColumns
  Dim Alt       As cKitAlt
  Dim Kit       As cKit
  Dim lRow      As Long
  Dim strLotes  As String
  Dim strSeries As String
  Dim strAlts   As String
  
  Dim ItemSerie As cKitSerieNumber
  Dim ItemLote  As cKitLoteNumber
  Dim ItemAlt   As cKitAltItem
  
'--------------------------------------------------------------------------------
'
' COLS
'
'--------------------------------------------------------------------------------
  
  With Propiedad.Grid
    
    Set Cols = .Columns
    .Columns.Clear
    .Rows.Clear
    
    With .Columns
      With .Add(Nothing)
        .Visible = False
        .Key = KI_PRK_ID
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1983, vbNullString)  'Borrar
        .Visible = m_bDelete
        .PropertyType = cspCheck
        .Width = 800
        .Key = KI_DELETE
      End With
      
      ' Series
      '
      For Each Serie In m_KitLn.KitType.Series
        
        bHaveAlt = Serie.Alts.Count
        
        n = Serie.Cantidad
        If n < 1 Then n = 1
        For q = 1 To n
        
          i = i + 1
          iKey = KitGetPropKey(i, csECT_Serie)
          
          With .Add(Nothing, GetKey(iKey))
            .Name = Serie.Nombre
            
            If Serie.Variable Then
              .PropertyType = cspText
              .SubType = cspTextButton
            
            ElseIf Serie.ta_id <> csNO_ID Then
              .PropertyType = cspText
              .Enabled = Serie.bTalEdit
              
            Else
              .PropertyType = cspHelp
              .Table = csProductoSerie
            End If
            
            .Key = iKey
            .Width = 2500
          End With
          
          If bHaveAlt And Not Serie.Variable Then
          
            iKey = KitGetPropKey(i, csECT_SerieA)
            With .Add(Nothing, GetKey(iKey))
              .Name = LNGGetText(1984, vbNullString)  'Alt.
              .PropertyType = cspList
              
              With .List
                .Add(Nothing).Id = Serie.pr_id
                For Each Alt In Serie.Alts
                  With .Add(Nothing)
                    .Id = Alt.pr_id
                    .Value = Alt.Nombre
                  End With
                Next
              End With
              
              .Key = iKey
              .Width = 1000
            End With
          End If
        Next
      Next
            
      ' Lotes
      '
      For Each Lote In m_KitLn.KitType.Lotes
        
        bHaveAlt = Lote.Alts.Count
      
        i = i + 1
        iKey = KitGetPropKey(i, csECT_Lote)
        
        With .Add(Nothing, GetKey(iKey))
          .Name = Lote.Nombre
          .PropertyType = cspText
          
          If Lote.ta_id <> csNO_ID Then
            
            .Enabled = Lote.bTalEdit
          
          Else

            .SubType = cspTextButton
          End If
          
          .Key = iKey
          .Width = 2500
        End With
      Next
      
      ' Alternativas
      '
      For Each Item In m_KitLn.KitType.Alts
        
        n = Item.Cantidad
        If n < 1 Or n > 3 Then n = 1
        
        For q = 1 To n
          
          i = i + 1
          iKey = KitGetPropKey(i, csECT_Alt)
          
          With .Add(Nothing, GetKey(iKey))
            .Name = Item.Nombre
            
            If Item.Variable Or Item.Cantidad > 3 Then
              .PropertyType = cspText
              .SubType = cspTextButton
            Else
              .PropertyType = cspList
              With .List
                .Add(Nothing).Id = Item.pr_id
                For Each Alt In Item.Alts
                  With .Add(Nothing)
                    .Id = Alt.pr_id
                    .Value = Alt.Nombre
                  End With
                Next
              End With
            End If
            .Key = iKey
            .Width = 1000
          End With
        Next
      Next
      
      ' Variables
      '
      For Each Var In m_KitLn.KitType.Vars
        
        i = i + 1
        iKey = KitGetPropKey(i, csECT_Var)
        
        With .Add(Nothing, GetKey(iKey))
          .Name = Var.Nombre
          .PropertyType = cspNumeric
          .SubType = cspDouble
          .Key = iKey
          .Width = 1000
        End With

      Next
      
      iCols = .Count - 1
      
    End With
    
'--------------------------------------------------------------------------------
'
' ROWS
'
'--------------------------------------------------------------------------------
    With .Rows
      
      For lRow = 1 To m_KitLn.KitType.Cantidad
      
        Set Kit = KitGetKit(m_KitLn, lRow)
        
        With .Add(Nothing)
          
          i = 0

          With .Add(Nothing)
            .Value = Kit.prsk_id
            .Key = KI_PRK_ID
          End With
      
          With .Add(Nothing)
            .Key = KI_DELETE
          End With
      
          ' Series
          '
          For Each Serie In Kit.Series
            
            If Serie.Variable Then
            
                strSeries = vbNullString
                
                For Each ItemSerie In Serie.Items
                  strSeries = strSeries & ItemSerie.Serie & ","
                Next
            
                i = i + 1
                iKey = KitGetPropKey(i, csECT_Serie)
                
                With .Add(Nothing)
                  .Value = RemoveLastColon(strSeries)
                  .Key = iKey
                End With
            
            Else
            
              bHaveAlt = Serie.Alts.Count
              
              n = Serie.Cantidad
              If n < 1 Then n = 1
              For q = 1 To n
              
                i = i + 1
                iKey = KitGetPropKey(i, csECT_Serie)
                
                Set ItemSerie = Serie.Items(q)
                
                With .Add(Nothing)
                  If Not ItemSerie Is Nothing Then
                    .Value = ItemSerie.Serie
                    .Id = ItemSerie.prns_id
                  End If
                  .Key = iKey
                End With
                
                If bHaveAlt And Not Serie.Variable Then
                
                  iKey = KitGetPropKey(i, csECT_SerieA)
                  With .Add(Nothing)
                    If Not ItemSerie Is Nothing Then
                      .Value = ItemSerie.Nombre
                      .Id = ItemSerie.pr_id
                    End If
                    .Key = iKey
                  End With
                End If
              Next
            End If
          Next
                
          ' Lotes
          '
          For Each Lote In Kit.Lotes

            strLotes = vbNullString

            For Each ItemLote In Lote.Items
            
              strLotes = strLotes & ItemLote.Lote & _
                                    "(" & Format(ItemLote.Cantidad, "0.00") & "),"
            Next
        
            i = i + 1
            iKey = KitGetPropKey(i, csECT_Lote)
          
            With .Add(Nothing)
              .Value = RemoveLastColon(strLotes)
              .Key = iKey
            End With
          Next
          
          ' Alternativas
          '
          For Each Item In Kit.Alts
            
            If Item.Variable Or Item.Cantidad > 3 Then
            
              strAlts = vbNullString
            
              i = i + 1
              iKey = KitGetPropKey(i, csECT_Alt)
              
              For Each ItemAlt In Item.Items
                strAlts = strAlts & ItemAlt.Nombre & _
                                   "(" & Format(ItemAlt.Cantidad, "0.00") & "),"
              Next
              
              With .Add(Nothing)
                .Value = RemoveLastColon(strAlts)
                .Key = iKey
              End With
            Else
              
              n = Item.Cantidad
              If n < 1 Then n = 1
              For q = 1 To n
                
                i = i + 1
                iKey = KitGetPropKey(i, csECT_Alt)
                
                Set ItemAlt = Item.Items(q)
                
                With .Add(Nothing)
                  If Not ItemAlt Is Nothing Then
                    .Id = ItemAlt.pr_id
                  End If
                  .Key = iKey
                End With
              Next
            End If
          Next
          
          ' Variables
          '
          For Each Var In Kit.Vars
            
            i = i + 1
            iKey = KitGetPropKey(i, csECT_Var)
            
            With .Add(Nothing)
              .Value = Var.Cantidad
              .Key = iKey
            End With
    
          Next
        End With
      Next
    End With
  End With
  
  pLoadItems = True
End Function

Private Function pBeforeEdit(ByVal lRow As Long, _
                             ByVal lCol As Long) As Boolean
  On Error GoTo ControlError
  
  Dim Serie   As cKitSerie
  Dim o       As cIABMGridColumn
  Dim iProp   As cIABMProperty
  Dim Row     As cIABMGridRow
  Dim i       As Long
  Dim iKey    As Long
  
  Set iProp = pGetItems()
  Set o = iProp.Grid.Columns(lCol)
  
  For Each Serie In m_KitLn.KitType.Series
  
    i = i + 1
    iKey = KitGetPropKey(i, csECT_Serie)
    
    If o.Key = iKey Then
    
      Set Row = iProp.Grid.Rows(lRow)
      
      o.HelpFilter = gDB.sqlString( _
                     KitGetFilterSerie(Serie, _
                                       Row, i, _
                                       lRow, _
                                       lCol, _
                                       lRow, _
                                       lCol, _
                                       m_depl_id, _
                                       m_ctrlStock, _
                                       m_depf_id, _
                                       m_KitLns, _
                                       m_KitLn, _
                                       m_ObjAbm, _
                                       False))
      
      Dim AbmObj As cABMGeneric
      Set AbmObj = m_ObjAbm
      AbmObj.RefreshColumnProperties iProp, GetKey(iKey)
      Exit For
    
    End If
  Next
  
  pBeforeEdit = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "pBeforeEdit ", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Sub pGetDepfId()
  If m_depl_id = csNO_ID Then
    m_depf_id = csNO_ID
    m_ctrlStock = csENoControlaStock
  Else
    gDB.GetData csTDepositoLogico, cscDeplId, m_depl_id, cscDepfId, m_depf_id
    pGetTypeStockControl
  End If
End Sub

Private Sub pGetTypeStockControl()
  Dim rs        As ADODB.Recordset
  Dim sqlstmt   As String
  sqlstmt = "select cfg_valor from configuracion where cfg_grupo = " & gDB.sqlString(c_GrupoGeneral) & " and cfg_aspecto = " & gDB.sqlString(c_TipoControlStock)
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  If rs.EOF Then Exit Sub
  m_ctrlStock = Val(gDB.ValField(rs.Fields, cscCfgValor))
End Sub

' construccion - destruccion
Private Sub Class_Terminate()
  On Error Resume Next
  Set m_ObjAbm = Nothing
  Set m_KitLn = Nothing
  Set m_KitLns = Nothing
End Sub

'////////////////////////////////////////////////////////////////////
'
' Edit By Range
'
'////////////////////////////////////////////////////////////////////
Private Sub pEditByRange(ByVal lCol As Long)
  Dim KI_NUMERO As Long
  Dim PrnsRange As cProductoSerieRange
  
  If lCol < 4 Then
    If m_KitLn.KitType.Series.Count > 1 Then
      MsgInfo LNGGetText(1985, vbNullString)
          'Para poder cargar números por rango debe ubicarse en la columna del número a editar
      Exit Sub
    Else
      lCol = 4
    End If
  End If
  
  Set PrnsRange = New cProductoSerieRange
  If Not PrnsRange.Edit() Then Exit Sub
  
  Dim iProp As cIABMProperty
  Set iProp = pGetItems()
  
  Dim first       As String
  Dim last        As String
  Dim current     As String
  Dim bByChar     As Boolean
  Dim valueAux    As Long
  Dim firstRow    As Long
  
  bByChar = PrnsRange.bByChar
  first = PrnsRange.first
  last = PrnsRange.last
  
  '-----------------
  ' TODO: por ahora no soportamos incrementacion alfabetica
  If bByChar Then
    MsgInfo LNGGetText(1986, vbNullString)  'Esta opción aún no está implementada
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
  
  '///////////////////////////////////////////
  '
  ' Para obtener el filtro de cada prns
  '
  '///////////////////////////////////////////
  
  Dim Serie     As cKitSerie
  Dim o         As cIABMGridColumn
  Dim iKey      As Long
  Dim idxSerie  As Long
  
  Set iProp = pGetItems()
  Set o = iProp.Grid.Columns(lCol)
  
  idxSerie = 0
  For Each Serie In m_KitLn.KitType.Series
  
    idxSerie = idxSerie + 1
    iKey = KitGetPropKey(idxSerie, csECT_Serie)
    
    If o.Key = iKey Then
      Exit For
    End If
  Next
  
  If Serie Is Nothing Then
    MsgWarning LNGGetText(1987, vbNullString)  'No se encontró el artículo serie a editar.
    Exit Sub
  End If
  
  '///////////////////////////////////////////
  '
  '
  '
  '///////////////////////////////////////////
  
  Dim Row   As cIABMGridRow
  Dim lRow  As Long
  
  KI_NUMERO = iKey
  
  Dim Mouse As cMouseWait
  Set Mouse = New cMouseWait
  
  Dim iPropDesc As cIABMProperty
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  
  Dim q As Long
  Dim c_van As String
  
  c_van = LNGGetText(2043, vbNullString)
  Set iPropDesc = pGetBarcodeDesc
  
  For lRow = firstRow To m_KitLn.KitType.Cantidad
    current = pIncrement(current, bByChar, valueAux)
    
    Set Row = iProp.Grid.Rows(lRow)
    
    If pFinish(current, last) Then Exit For
    
    With pCell(Row, KI_NUMERO)
      .Value = current
      .Id = pSetPrnsId(Row, lRow, .Value, Serie, idxSerie, lCol)
    End With
  
    q = q + 1
    If q Mod 50 = 0 Then
      iPropDesc.Value = c_van & q
      AbmObj.ShowValue iPropDesc
    End If
  
  Next
  
  iPropDesc.Value = c_van & q
  AbmObj.ShowValue iPropDesc
  
  AbmObj.ShowValue iProp, True

  iPropDesc.Value = vbNullString
  AbmObj.ShowValue iPropDesc

End Sub

Private Sub pPasteFromXLS(ByVal lCol As Long)
  Dim KI_NUMERO As Long
  
  If lCol < 4 Then
    If m_KitLn.KitType.Series.Count > 1 Then
      MsgInfo LNGGetText(1988, vbNullString)
      'Para poder pegar números desde Excel debe ubicarse en la columna del número a editar
      Exit Sub
    Else
      lCol = 4
    End If
  End If
  
  Dim Data  As String
  Dim vData As Variant
  
  Data = Clipboard.GetText
  vData = Split(Data, Chr(13) & Chr(10))

  If UBound(vData) < 0 Then Exit Sub

  '///////////////////////////////////////////
  '
  ' Para obtener el filtro de cada prns
  '
  '///////////////////////////////////////////
  Dim iProp     As cIABMProperty
  Dim iPropDesc As cIABMProperty
  Dim Serie     As cKitSerie
  Dim o         As cIABMGridColumn
  Dim iKey      As Long
  Dim idxSerie  As Long
  
  Set iProp = pGetItems()
  Set o = iProp.Grid.Columns(lCol)
  
  idxSerie = 0
  For Each Serie In m_KitLn.KitType.Series
  
    idxSerie = idxSerie + 1
    iKey = KitGetPropKey(idxSerie, csECT_Serie)
    
    If o.Key = iKey Then
      Exit For
    End If
  Next
  
  If Serie Is Nothing Then
    MsgWarning LNGGetText(1987, vbNullString)  'No se encontro el articulo serie a editar.
    Exit Sub
  End If
  
  '///////////////////////////////////////////
  '
  '
  '
  '///////////////////////////////////////////
  
  Dim Row       As cIABMGridRow
  Dim firstRow  As Long
  Dim q         As Long
  Dim i         As Long
  Dim c_van     As String
  
  c_van = LNGGetText(2043, vbNullString)
  
  KI_NUMERO = iKey
  
  Set iProp = m_ObjAbm.Properties(c_Items)
  
  firstRow = iProp.SelectedIndex
  If firstRow < 1 Then firstRow = 1
    
  Dim Mouse As cMouseWait
  Set Mouse = New cMouseWait
  
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  
  Set iPropDesc = pGetBarcodeDesc
  
  For i = firstRow To m_KitLn.KitType.Cantidad
    
    If UBound(vData) < q Then Exit For
    
    Set Row = iProp.Grid.Rows(i)
    
    With pCell(Row, KI_NUMERO)
      .Value = vData(q)
      .Id = pSetPrnsId(Row, i, .Value, Serie, idxSerie, lCol)
    End With
    
    q = q + 1
    
    If q Mod 50 = 0 Then
      iPropDesc.Value = c_van & q
      AbmObj.ShowValue iPropDesc
    End If
    
  Next
  
  iPropDesc.Value = c_van & q
  AbmObj.ShowValue iPropDesc
  
  AbmObj.ShowValue iProp, True

  iPropDesc.Value = vbNullString
  AbmObj.ShowValue iPropDesc
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
    
    If Len(Trim(Val(first))) < Len(first) Then
      strZeroLeft = Mid(first, 1, Len(first) - Len(Trim(Val(first))))
    End If
    
    rtn = strZeroLeft & Val(first) - 1
    
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
    
      If Len(Trim(Val(Value))) < Len(Value) Then
        strZeroLeft = Mid(Value, 1, Len(Value) - Len(Trim(Val(Value))))
      End If
      
      Value = strZeroLeft & Val(Value) + 1
      
    Else
      valueAux = valueAux + 1
      strNumber = valueAux
      length = Len(Value) - Len(strNumber)
      If length < 0 Then length = 0
      Value = Mid(Value, 1, length)
      Value = Value & strNumber
    End If
  End If
  
  pIncrement = Value
End Function

Private Function pSetPrnsId(ByVal Row As cIABMGridRow, _
                            ByVal lRow As Long, _
                            ByVal prnsCodigo As String, _
                            ByVal Serie As cKitSerie, _
                            ByVal idxSerie As Long, _
                            ByVal lCol As Long _
                            ) As Long
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "select prns_id from ProductoNumeroSerie where prns_codigo = " & gDB.sqlString(prnsCodigo)
  sqlstmt = sqlstmt & " and " & KitGetFilterSerie(Serie, _
                                                  Row, idxSerie, _
                                                  lRow, _
                                                  lCol, _
                                                  lRow, _
                                                  lCol, _
                                                  m_depl_id, _
                                                  m_ctrlStock, _
                                                  m_depf_id, _
                                                  m_KitLns, _
                                                  m_KitLn, _
                                                  m_ObjAbm, _
                                                  False)
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  If rs.EOF Then Exit Function
  
  pSetPrnsId = gDB.ValField(rs.Fields, cscPrnsId)
End Function

Private Function pSetStlId(ByVal stlCodigo As String, _
                           ByVal Lote As cKitLote, _
                           ByVal lRowKey As Long, _
                           ByVal lColKey As Long _
                           ) As Long
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "select stl_id, stl_codigo from StockLote where stl_codigo = " & gDB.sqlString(stlCodigo)
  sqlstmt = sqlstmt & " and " & KitGetFilterLote(Lote, _
                                                 Lote.pr_id, _
                                                 m_ctrlStock, _
                                                 m_depl_id, _
                                                 m_depf_id)
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  If rs.EOF Then Exit Function
  
  Dim stl_id      As Long
  Dim stl_codigo  As String
  
  stl_id = gDB.ValField(rs.Fields, cscStlId)
  stl_codigo = gDB.ValField(rs.Fields, cscStlCodigo)
  
  Lote.Items.Clear
  
  With Lote.Items
      
    With .Add(KitGetKeyItem(lRowKey, lColKey + 1), Nothing)
      
      .Nombre = Lote.Nombre
      .pr_id = Lote.pr_id
      
      .stl_id = stl_id
      .Lote = stl_codigo
      
      .Cantidad = Lote.Cantidad
    End With
    
  End With
  
  pSetStlId = stl_id
End Function

Private Function pGetColActive() As Long
  On Error Resume Next
  
  Dim oProp As cABMProperty
  Set oProp = pGetItems()
  
  pGetColActive = oProp.ctl.SelectedCol
End Function

Private Function pGetBarcodeInput() As cIABMProperty
  Set pGetBarcodeInput = m_ObjAbm.Properties.Item(c_BarcodeInput)
End Function

Private Function pGetBarcodeDesc() As cIABMProperty
  Set pGetBarcodeDesc = m_ObjAbm.Properties.Item(c_BarcodeDesc)
End Function

Private Function pProcessBarcode() As Boolean
  Dim codigo_barra      As String
  Dim pr_id             As Long
  Dim pr_nombrecompra   As String
  Dim pr_codigobarra    As String
  Dim NroSerie          As String
  Dim comando           As String
  Dim iProp             As cIABMProperty
  
  Set iProp = pGetBarcodeInput()
  
  codigo_barra = Trim$(iProp.Value)
  
  If codigo_barra <> vbNullString Then
  
    pr_codigobarra = BCGetPrCodigoBarra( _
                             codigo_barra, _
                             c_cod_barra_tipo, _
                             c_cod_barra_longitud, _
                             c_cod_barra_caracter)
                             
    NroSerie = BCGetNroSerie( _
                      codigo_barra, _
                      c_cod_barra_tipo, _
                      c_cod_barra_longitud, _
                      c_cod_barra_caracter)
    
    If pIsCommand(codigo_barra) Then
  
      comando = pProcessCommand(codigo_barra)
  
      pGetBarcodeDesc().Value = comando
  
      pSetFocusInBarcodeInput iProp
      
    Else
    
      If BCGetPrIdFromBarCode(pr_codigobarra, _
                              pr_id, _
                              pr_nombrecompra, _
                              vbNullString) Then
      
        pSetNroSerieInGrid NroSerie, pr_id
      Else
        iProp.Value = codigo_barra & " (código invalido)"
        pPlayInvalidSound
      End If
      
      pGetBarcodeDesc().Value = pr_nombrecompra
      
      pSetFocusInBarcodeInput iProp
    
    End If
  End If
  
  pProcessBarcode = True
End Function

Private Sub pSetFocusInBarcodeInput(ByRef iProp As cIABMProperty)
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  AbmObj.SetFocusCtrl iProp
End Sub

Private Function pIsCommand(ByVal codigo_barra As String) As Boolean
  Select Case UCase$(codigo_barra)
    Case c_cmd_bajar_renglon, c_cmd_subir_renglon, _
         c_cmd_aceptar, c_cmd_cancelar
      pIsCommand = True
  End Select
End Function

Private Function pProcessCommand(ByVal codigo_barra As String) As String
  Dim AbmObj As cABMGeneric
  
  Select Case UCase$(codigo_barra)
    Case c_cmd_bajar_renglon
      If m_BarcodeActiveRow < m_KitLn.Items.Count Then
        m_BarcodeActiveRow = m_BarcodeActiveRow + 1
      End If
      pProcessCommand = LNGGetText(2044, vbNullString, m_BarcodeActiveRow)
                        'Bajar un rénglon (" & m_BarcodeActiveRow & ")
    Case c_cmd_subir_renglon
      If m_BarcodeActiveRow > 1 Then
        m_BarcodeActiveRow = m_BarcodeActiveRow - 1
      End If
      pProcessCommand = LNGGetText(2045, vbNullString, m_BarcodeActiveRow)
                        'Subir un rénglon (" & m_BarcodeActiveRow & ")
    Case c_cmd_aceptar
      Set AbmObj = m_ObjAbm
      AbmObj.bSendSave = True
      pProcessCommand = LNGGetText(1989, vbNullString)  'Guardando...
      
    Case c_cmd_cancelar
      Set AbmObj = m_ObjAbm
      AbmObj.bSendClose = True
      pProcessCommand = LNGGetText(1990, vbNullString)  'Cerrando...
  End Select
End Function

Private Function pSetNroSerieInGrid(ByVal NroSerieLote As String, _
                                    ByVal pr_id As Long) As Boolean
  Dim iCol      As Long
  Dim iColToSet As Long
  Dim q         As Long
  Dim n         As Long
  Dim Serie     As cKitSerie
  Dim Lote      As cKitLote
  Dim bFound    As Boolean
  Dim Row       As cIABMGridRow
  Dim idxSerie  As Long
  Dim Kit       As cKit
  Dim bHaveAlt  As Boolean
  Dim iKey      As Long
  
  If m_BarcodeActiveRow < 1 Then
    m_BarcodeActiveRow = 1
  End If
  
  Set Row = pGetItems().Grid.Rows(m_BarcodeActiveRow)
  
  Set Kit = KitGetKit(m_KitLn, m_BarcodeActiveRow)
    
    ' Series
    '
    For Each Serie In Kit.Series
      
      idxSerie = idxSerie + 1

      If Serie.pr_id = pr_id Then
        bFound = True
      End If
      
      ' Si la cantidad es variable
      ' la coleccion se actualiza
      ' cuando el usuario ingresa
      ' a la celda y se edita en
      ' cKitEditAux, y por lo tanto
      ' no esta soportada en la edicion
      ' por lectora de codigo de barras
      ' almenos por ahora.
      '
      If Serie.Variable Then
        iCol = iCol + 1
        If bFound Then
          iColToSet = iCol
          Exit Function
        End If
      Else
        
        ' Por cada numero de serie tengo
        ' una columna y opcinalmente una columna
        ' para su alternativa.
        '
        ' Esto mutlitiplicado por la cantidad
        ' indicada en el item de la formula.
        '
        ' Es decir un kit que lleva 3 del producto
        ' XXX que indica numero de serie y posee
        ' alternativas YYY y ZZZ, da como resultado
        ' seis columnas en esta grilla.
        '
        ' Siempre accedo a las celdas a travez de
        ' la propiedad Key usando pCell.
        '
        
        bHaveAlt = Serie.Alts.Count

        n = Serie.Cantidad
        If n < 1 Then n = 1 ' Por seguridad
        For q = 1 To n
          iCol = iCol + 1
          iKey = KitGetPropKey(iCol, csECT_Serie)
          If pCell(Row, iKey).Id = csNO_ID And bFound Then
            iColToSet = iCol
            Exit For
          End If
        Next
      End If
    
      If bFound Then
        If iColToSet > 0 Then
          
          iKey = KitGetPropKey(iColToSet, csECT_Serie)
          With pCell(Row, iKey)
            .Value = NroSerieLote
            .Id = pSetPrnsId(Row, _
                             m_BarcodeActiveRow, _
                             .Value, _
                             Serie, _
                             idxSerie, _
                             iColToSet)
          End With
        End If
        Exit For
      End If
    Next
    
    If Not bFound Then
      ' Lotes
      '
      ' TODO: Lotes x Lectora
      
      For Each Lote In Kit.Lotes
      
        idxSerie = idxSerie + 1
        iCol = iCol + 1
        
        If Lote.pr_id = pr_id Then
          bFound = True
        End If
      
        If bFound Then
          
          iColToSet = iCol
          
          If iColToSet > 0 Then
            
            iKey = KitGetPropKey(iColToSet, csECT_Lote)
            With pCell(Row, iKey)
              .Id = pSetStlId(NroSerieLote, _
                              Lote, _
                              m_BarcodeActiveRow, _
                              iColToSet)
              If .Id <> csNO_ID Then
                .Value = NroSerieLote & _
                              "(" & Format(Lote.Cantidad, "0.00") & "),"
              Else
                .Value = vbNullString
              End If
            End With
          End If
          Exit For
        End If
      
      Next
    End If

End Function

Private Function pCopyLote(ByRef DestLote As cKitLote, _
                           ByRef SourceLote As cKitLote, _
                           ByVal iColKey As Long, _
                           ByVal iRowKey As Long)

  Dim LoteN As cKitLoteNumber
  Dim lRow  As Long
  
  iColKey = iColKey * 1000
  
  With DestLote.Items
  
    .Clear
    
    For Each LoteN In SourceLote.Items
      
      lRow = lRow + 1
      
      With .Add(KitGetKeyItem(iRowKey, iColKey + lRow), Nothing)
        
        .Nombre = LoteN.Nombre
        .pr_id = LoteN.pr_id
        .stl_id = LoteN.stl_id
        .Lote = LoteN.Lote
        .Cantidad = LoteN.Cantidad
      End With
      
    Next
  End With

End Function

Private Sub pPlayInvalidSound()
  Dim i As Long
  For i = 1 To 10
    Sleep 200
    Beep
  Next
End Sub


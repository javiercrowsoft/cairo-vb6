VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cListaPrecioCalc"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIABMClient
Implements CSInterfacesABM.cIABMClientGrid
Implements CSMenu.cIMenuClient
'--------------------------------------------------------------------------------
' cListaPrecioCalc
' 07-10-2008

'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cListaPrecioCalc"

Private Const c_costo_lista = "costo_lista"
Private Const c_descuento = "descuento"
Private Const c_costo = "costo"
Private Const c_costo_venta = "costo_venta"
Private Const c_iva_porc = "iva_proc"
Private Const c_iva_importe = "iva_importe"
Private Const c_internos_porc = "internos_porc"
Private Const c_internos_importe = "internos_importe"
Private Const c_margen = "margen"
Private Const c_precio = "precio"
Private Const c_precio_final = "precio_final"

Private Const c_Items = "Precios"
Private Const c_Facturas = "Facturas"

Private Const c_cmd_save_prices = "cmd_save_prices"

' pSeudo constant
'
Private Const c_col_select_index = 4

' Factura Compra
Private Const cscFcId       As String = "fc_id"
Private Const cscFcNrodoc   As String = "fc_nrodoc"
Private Const cscFcFecha    As String = "fc_fecha"

' Factura Compra Item
Private Const cscFciId      As String = "fci_id"

' Documento Tipo
Private Const cscDoctId     As String = "doct_id"

Private Const cscFciPrecioLista     As String = "fci_precioLista"
Private Const cscFciPrecio          As String = "fci_precio"
Private Const cscFciDescuento       As String = "fci_descuento"

' Keys

Private Const K_PRODUCTO                       As Integer = 1
Private Const K_COSTO_LISTA                    As Integer = 2
Private Const K_DESCUENTO                      As Integer = 3
Private Const K_COSTO                          As Integer = 4
Private Const K_REL_COMPRA_VTA                 As Integer = 5
Private Const K_COSTO_VENTA                    As Integer = 6
Private Const K_MARGEN                         As Integer = 7
Private Const K_IVA_PORC                       As Integer = 8
Private Const K_IVA_IMPORTE                    As Integer = 9
Private Const K_INTERNOS_PORC                  As Integer = 10
Private Const K_INTERNOS_IMPORTE               As Integer = 11
Private Const K_PRECIO                         As Integer = 12
Private Const K_PRECIO_FINAL                   As Integer = 13

Private Const K_ITEMS                          As Integer = 300
Private Const K_FACTURAS                       As Integer = 301

Private Const K_CMD_SAVE_PRICES                As Integer = 302

Private Const KI_LPI_ID                       As Integer = 1
Private Const KI_SELECT                       As Integer = 2
Private Const KI_LP_ID                        As Integer = 3
Private Const KI_PRECIO                       As Integer = 4
Private Const KI_PORC                         As Integer = 5

Private Const KI_FC_ID                        As Integer = 1
Private Const KI_FC_SELECT                    As Integer = 2
Private Const KI_FC_FECHA                     As Integer = 3
Private Const KI_FC_FACTURA                   As Integer = 4
Private Const KI_FC_PROVEEDOR                 As Integer = 5
Private Const KI_FC_PRECIO_LISTA              As Integer = 6
Private Const KI_FC_DESCUENTOS                As Integer = 7
Private Const KI_FC_PRECIO                    As Integer = 8
Private Const KI_FC_CANTIDAD                  As Integer = 9
Private Const KI_FCI_ID                       As Integer = 10
Private Const KI_DOCT_ID                      As Integer = 11

' estructuras
' Seudo - Variables
Private c_ErrorSave         As String

Private m_Pr_id             As Long

' variables privadas
Private m_Editing           As Boolean

Private m_ObjAbm            As cIABMGeneric
Private m_ObjTree           As Object

Private m_BranchId          As Long
Private m_TreeId            As Long
 
Private m_ItemsDeleted      As String

Private m_Host              As CSMenu.cIMenuHost
Private m_Copy              As Boolean

Private m_GeneralConfig     As cGeneralConfig

Private m_internos_porc     As Double

' Properties publicas

' Properties privadas
' funciones publicas

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

Private Function cIABMClient_ListAdHock(List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClient_Load()

End Sub

Private Function cIABMClient_PropertyChange(ByVal Key As Integer) As Boolean

  With m_ObjAbm.Properties
    Select Case Key
      Case K_PRODUCTO
        If pSaveChanges() Then
        
          pShowProducto
          
        End If
        
      Case K_MARGEN
      
        pApplyMargen
        
      Case K_PRECIO
      
        pUpdateFromPrecio
      
      Case K_PRECIO_FINAL
      
        pUpdateFromPrecioFinal
        
      Case K_CMD_SAVE_PRICES
      
        pSavePrices
        
    End Select
  End With
End Function

Private Function pGetProducto() As cIABMProperty
  Set pGetProducto = m_ObjAbm.Properties.Item(cscPrId)
End Function

Private Sub pShowProducto()
  Dim AbmGen As cABMGeneric
  
  Set AbmGen = m_ObjAbm
  
  m_Pr_id = pGetProducto().HelpId
  
  pLoadItemsXPrId pGetItems()
  AbmGen.ShowValue pGetItems(), True
  
  pLoadFacturasXPrId pGetFacturas()
  AbmGen.ShowValue pGetFacturas(), True
  
  If pGetFacturas.Grid.Rows.Count Then
    cIABMClientGrid_ColumnAfterEdit K_FACTURAS, 1, c_col_select_index, 1, 1
  End If
  
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_ProductoCalcPrecioGetData " & m_Pr_id
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  If rs.EOF Then Exit Sub
  
  Dim iProp As cIABMProperty
  Set iProp = pGetVentaCompra()
  iProp.Value = gDB.ValField(rs.fields, cscPrVentaCompra)
  AbmGen.ShowValue iProp
  
  Set iProp = pGetIVA()
  iProp.Value = gDB.ValField(rs.fields, "iva")
  AbmGen.ShowValue iProp
  
  Set iProp = pGetInternos()
  iProp.Value = gDB.ValField(rs.fields, "internos")
  AbmGen.ShowValue iProp
  
  m_internos_porc = gDB.ValField(rs.fields, cscPrPorcinternov)
End Sub

Private Function pSaveChanges() As Boolean

  Dim AbmGen As cABMGeneric
  Set AbmGen = m_ObjAbm
  
  pSaveChanges = AbmGen.SaveChanges()

  pSaveChanges = True
End Function

Private Function cIABMClient_Save() As Boolean
  
  cIABMClient_Save = pSaveItems()

End Function

Private Function pGetItems() As cIABMProperty
  Set pGetItems = m_ObjAbm.Properties.Item(c_Items)
End Function

Private Function pGetFacturas() As cIABMProperty
  Set pGetFacturas = m_ObjAbm.Properties.Item(c_Facturas)
End Function

Private Function pSaveItems() As Boolean
  
  pSaveItems = True
End Function

Private Function cIABMClient_Terminate() As Boolean
  m_Editing = False
  cIABMClient_Terminate = True
End Function

Private Property Get cIABMClient_Title() As String
  cIABMClient_Title = LNGGetText(4899, vbNullString) 'Calculo de Precios de Venta
End Property

Private Function cIABMClient_Validate() As Boolean
  cIABMClient_Validate = True
End Function

' Implementacion de cIABMClientGrid
Private Function cIABMClientGrid_ColumnAfterEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long) As Boolean
  Select Case Key
    Case K_FACTURAS
      Dim row     As cIABMGridRow
      Dim Rows    As cIABMGridRows
      Dim i       As Long
      Dim AbmGen  As cABMGeneric
      Dim iProp   As cIABMProperty
      
      Set AbmGen = m_ObjAbm
      Set iProp = pGetFacturas()
      Set Rows = iProp.Grid.Rows
      
      For i = 1 To Rows.Count
        If i <> lRow Then
          
          Set row = Rows(i)
          pCell(row, KI_FC_SELECT).Id = 0
          AbmGen.ShowCellValue iProp, i, c_col_select_index + 1
          
        End If
      Next
      
      pShowCostoFromFactura Rows.Item(lRow)
      
  End Select
  cIABMClientGrid_ColumnAfterEdit = True
End Function

Private Sub pShowCostoFromFactura(ByRef row As cIABMGridRow)
                                  
  Dim ItemId As Long
  Dim doct_id As Long

  ItemId = pCell(row, KI_FCI_ID).Id
  doct_id = pCell(row, KI_DOCT_ID).Id
  
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  Dim costo As Double
  Dim descuento As String
  Dim costo_lista As Double
  Dim precio_lista As Double
  
  If doct_id Then
  
    If doct_id = 2 Then
    
      sqlstmt = "select fci_precio as costo, fci_descuento as descuento, fci_precioUsr as costo_lista, fci_precioLista" & _
                " from FacturaCompraItem where fci_id = " & ItemId
  
    ElseIf doct_id = 4 Then
    
      sqlstmt = "select rci_precio as costo, rci_descuento as descuento, rci_precioUsr as costo_lista, rci_precioLista" & _
                " from RemitoCompraItem where rci_id = " & ItemId
    
    End If
    
    If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
    If rs.EOF Then Exit Sub
    
    costo = gDB.ValField(rs.fields, "costo")
    costo_lista = gDB.ValField(rs.fields, "costo_lista")
    descuento = gDB.ValField(rs.fields, "descuento")
  
  Else
  
    costo = Val(pCell(row, KI_FC_PRECIO).Value)
    costo_lista = Val(pCell(row, KI_FC_PRECIO_LISTA).Value)
    descuento = pCell(row, KI_FC_DESCUENTOS).Value
  
  End If
  
  Dim iProp         As cIABMProperty
  Dim AbmGen        As cABMGeneric
  Dim venta_compra  As Double
  
  Set AbmGen = m_ObjAbm
  
  venta_compra = Val(pGetVentaCompra().Value)
  
  Set iProp = pGetCosto()
  iProp.Value = costo
  AbmGen.ShowValue iProp

  Set iProp = pGetCostoLista()
  iProp.Value = costo_lista
  AbmGen.ShowValue iProp

  Set iProp = pGetDescuento()
  iProp.Value = descuento
  AbmGen.ShowValue iProp

  Dim costo_venta As Double
  costo_venta = costo * venta_compra

  Set iProp = pGetCostoVenta()
  iProp.Value = Format(costo_venta, m_GeneralConfig.FormatDecImporte)
  AbmGen.ShowValue iProp

  Dim Margen As Double
  Dim Internos As Double
  Dim Iva As Double
  
  Margen = Val(pGetMargen().Value)
  Internos = Val(pGetInternos().Value)
  Iva = Val(pGetIVA().Value)

  Dim Precio As Double
  Dim Precio_Final As Double

  Precio = costo_venta + (costo_venta * Margen / 100)

  Iva = Precio * Iva / 100
  Internos = (Precio * m_internos_porc / 100) * Internos / 100
  
  Set iProp = pGetIVAImporte()
  iProp.Value = Format(Iva, m_GeneralConfig.FormatDecImporte)
  AbmGen.ShowValue iProp

  Set iProp = pGetInternosImporte()
  iProp.Value = Format(Internos, m_GeneralConfig.FormatDecImporte)
  AbmGen.ShowValue iProp

  Set iProp = pGetPrecio()
  iProp.Value = Format(Precio, m_GeneralConfig.FormatDecImporte)
  AbmGen.ShowValue iProp
  
  Precio_Final = Precio + Iva + Internos

  Set iProp = pGetPrecioFinal()
  iProp.Value = Format(Precio_Final, m_GeneralConfig.FormatDecImporte)
  AbmGen.ShowValue iProp

End Sub

Private Sub pApplyMargen()

  Dim iProp         As cIABMProperty
  Dim AbmGen        As cABMGeneric
  Dim costo_venta   As Double
  Dim Margen        As Double
  Dim Internos      As Double
  Dim Iva           As Double
  
  Set AbmGen = m_ObjAbm
  costo_venta = Val(pGetCostoVenta().Value)

  Margen = Val(pGetMargen().Value)
  Internos = Val(pGetInternos().Value)
  Iva = Val(pGetIVA().Value)
  
  Dim Precio As Double
  Dim Precio_Final As Double

  Precio = costo_venta + (costo_venta * Margen / 100)

  Iva = Precio * Iva / 100
  Internos = (Precio * m_internos_porc / 100) * Internos / 100
  
  Set iProp = pGetIVAImporte()
  iProp.Value = Format(Iva, m_GeneralConfig.FormatDecImporte)
  AbmGen.ShowValue iProp

  Set iProp = pGetInternosImporte()
  iProp.Value = Format(Internos, m_GeneralConfig.FormatDecImporte)
  AbmGen.ShowValue iProp

  Set iProp = pGetPrecio()
  iProp.Value = Format(Precio, m_GeneralConfig.FormatDecImporte)
  AbmGen.ShowValue iProp
  
  Precio_Final = Precio + Iva + Internos

  Set iProp = pGetPrecioFinal()
  iProp.Value = Format(Precio_Final, m_GeneralConfig.FormatDecImporte)
  AbmGen.ShowValue iProp

End Sub

Private Sub pUpdateFromPrecio()

  Dim iProp         As cIABMProperty
  Dim AbmGen        As cABMGeneric
  Dim costo_venta   As Double
  Dim Margen        As Double
  Dim Internos      As Double
  Dim Iva           As Double
  
  Set AbmGen = m_ObjAbm
  costo_venta = Val(pGetCostoVenta().Value)

  Internos = Val(pGetInternos().Value)
  Iva = Val(pGetIVA().Value)
  
  Dim Precio As Double
  Dim Precio_Final As Double

  Precio = Val(pGetPrecio().Value) 'costo_venta + (costo_venta * Margen / 100)

  Iva = Precio * Iva / 100
  Internos = (Precio * m_internos_porc / 100) * Internos / 100
  
  Margen = (DivideByCero(Precio, costo_venta) - 1) * 100 ' Val(pGetMargen().Value)
  
  Set iProp = pGetMargen()
  iProp.Value = Format(Margen, "0.000")
  AbmGen.ShowValue iProp
  
  Set iProp = pGetIVAImporte()
  iProp.Value = Format(Iva, m_GeneralConfig.FormatDecImporte)
  AbmGen.ShowValue iProp

  Set iProp = pGetInternosImporte()
  iProp.Value = Format(Internos, m_GeneralConfig.FormatDecImporte)
  AbmGen.ShowValue iProp

  Set iProp = pGetPrecio()
  iProp.Value = Format(Precio, m_GeneralConfig.FormatDecImporte)
  AbmGen.ShowValue iProp
  
  Precio_Final = Precio + Iva + Internos

  Set iProp = pGetPrecioFinal()
  iProp.Value = Format(Precio_Final, m_GeneralConfig.FormatDecImporte)
  AbmGen.ShowValue iProp

End Sub

Private Sub pUpdateFromPrecioFinal()

  Dim iProp         As cIABMProperty
  Dim AbmGen        As cABMGeneric
  Dim costo_venta   As Double
  Dim Margen        As Double
  Dim Internos      As Double
  Dim Iva           As Double
  
  Set AbmGen = m_ObjAbm
  costo_venta = Val(pGetCostoVenta().Value)

  Internos = Val(pGetInternos().Value)
  Iva = Val(pGetIVA().Value)
  
  Dim Precio As Double
  Dim Precio_Final As Double

  Precio_Final = Val(pGetPrecioFinal().Value)  'costo_venta + (costo_venta * Margen / 100)
  
  Margen = (DivideByCero( _
                        DivideByCero(Precio_Final, _
                                     (1 + Iva / 100 + Internos / 100)), _
                        costo_venta) - 1) * 100

  Precio = DivideByCero(Precio_Final, _
                        (1 + Iva / 100 + Internos / 100))

  Iva = Precio * Iva / 100
  Internos = (Precio * m_internos_porc / 100) * Internos / 100
    
  Set iProp = pGetMargen()
  iProp.Value = Format(Margen, "0.000")
  AbmGen.ShowValue iProp
  
  Set iProp = pGetIVAImporte()
  iProp.Value = Format(Iva, m_GeneralConfig.FormatDecImporte)
  AbmGen.ShowValue iProp

  Set iProp = pGetInternosImporte()
  iProp.Value = Format(Internos, m_GeneralConfig.FormatDecImporte)
  AbmGen.ShowValue iProp

  Set iProp = pGetPrecio()
  iProp.Value = Format(Precio, m_GeneralConfig.FormatDecImporte)
  AbmGen.ShowValue iProp
  
End Sub

Private Function cIABMClientGrid_ColumnAfterUpdate(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long) As Boolean

End Function

Private Function cIABMClientGrid_ColumnBeforeEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean
  Select Case Key
    Case K_ITEMS
      If pGetItems().Grid.Columns.Item(lCol).Key = KI_SELECT Then
        cIABMClientGrid_ColumnBeforeEdit = True
      End If
    Case K_FACTURAS
      If pGetFacturas().Grid.Columns.Item(lCol).Key = KI_FC_SELECT Then
        cIABMClientGrid_ColumnBeforeEdit = True
      End If
  End Select
End Function

Private Function cIABMClientGrid_ColumnButtonClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean

End Function

Private Sub cIABMClientGrid_ColumnCancelEdit(ByVal Key As Integer)

End Sub

Private Sub cIABMClientGrid_ColumnClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Sub cIABMClientGrid_DblClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Function cIABMClientGrid_DeleteRow(ByVal Key As Integer, row As CSInterfacesABM.cIABMGridRow, ByVal lRow As Long) As Boolean

End Function

Private Function cIABMClientGrid_IsEmptyRow(ByVal Key As Integer, row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean

End Function

Private Function cIABMClientGrid_ListAdHock(ByVal Key As Integer, row As CSInterfacesABM.cIABMGridRow, ByVal ColIndex As Long, List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClientGrid_NewRow(ByVal Key As Integer, ByVal Rows As Integer)

End Sub

Private Function cIABMClientGrid_ValidateRow(ByVal Key As Integer, row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  cIABMClientGrid_ValidateRow = True
End Function

Private Function cIMenuClient_Initialize(F As Object, Host As CSMenu.cIMenuHost) As Boolean
  On Error GoTo ControlError

  Set m_Host = Host
  
  m_Host.Server.AddMenu C_MenuArticulos, csMenuConfigArticulos, C_MenuConfig, 0, True, False, False, False, True, Nothing
  m_Host.Server.AddMenu LNGGetText(4900, vbNullString), csPreGListaPrecioCalc, C_MenuArticulos, 0, True, False, False, False, False, Me
                        '&Calculo de Precios de Venta
  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, C_MenuClientInit, C_Module, vbNullString
  If Err.Number Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal Id As Long) As Variant
  pEdit
End Function

Private Sub pEdit()
  On Error GoTo ControlError
  
  Set m_ObjAbm = New cABMGeneric
  
  If Not SecurityCanAccess(csPreGListaPrecioCalc) Then Exit Sub

  If Not LoadCollection() Then Exit Sub
  
  m_Editing = True
  
  Exit Sub
ControlError:
  MngError Err, "pEdit", C_Module, vbNullString
End Sub

' funciones privadas
Private Function LoadCollection() As Boolean
  Dim oGrid  As cABMGrid
  Dim AbmObj As cABMGeneric
  
  Dim iProp   As cABMProperty
  Dim c       As cIABMProperty
  Dim oProp   As cABMProperty
  
  Set AbmObj = m_ObjAbm
  AbmObj.MinHeight = 8800
  
  AbmObj.OkCancelDialog = True
  AbmObj.bDontAskForSave = True
  
  m_ObjAbm.Tabs.Clear
  m_ObjAbm.Title2 = vbNullString
    
  With m_ObjAbm.Properties
    
    .Clear
    
    Set c = .Add(Nothing, cscPrId)
    With c
      .PropertyType = cspHelp
      .Table = csProductoVenta
      .Name = LNGGetText(1367, vbNullString) 'Articulo
      .Key = K_PRODUCTO
      .Width = 5000
      
      Set oProp = c
      oProp.IsEditProperty = False
    End With
            
    Set c = .Add(Nothing, c_costo_lista)
    With c
      .PropertyType = cspNumeric
      .SubType = cspDouble
      .Name = LNGGetText(4911, vbNullString) 'Costo Lista
      .Key = K_COSTO_LISTA
      .Enabled = False
      .Width = 1000
      .TopToPrevious = 380
    End With
            
    Set c = .Add(Nothing, c_descuento)
    With c
      .PropertyType = cspText
      .Name = LNGGetText(4909, vbNullString) 'Descuento
      .Key = K_DESCUENTO
      .Enabled = False
      .Width = 1500
      .TopFromProperty = c_costo_lista
      .Left = 4500
      .LeftNotChange = True
    End With
            
    Set c = .Add(Nothing, c_costo)
    With c
      .PropertyType = cspNumeric
      .SubType = cspDouble
      .Name = LNGGetText(3088, vbNullString) 'Costo
      .Key = K_COSTO
      .Enabled = False
      .Width = 1000
      .TopToPrevious = 380
    End With
            
    Set c = .Add(Nothing, cscPrVentaCompra)
    With c
      .PropertyType = cspNumeric
      .SubType = cspDouble
      .Name = LNGGetText(1335, vbNullString) 'Relación Venta-Compra
      .Key = K_REL_COMPRA_VTA
      .Enabled = False
      .Format = "0.000000"
      .TopFromProperty = c_costo
      .Left = 4500
      .LeftNotChange = True
    End With
            
    Set c = .Add(Nothing, c_costo_venta)
    With c
      .PropertyType = cspNumeric
      .SubType = cspDouble
      .Name = LNGGetText(4910, vbNullString) 'Costo Venta
      .Key = K_COSTO_VENTA
      .Enabled = False
      .Width = 1000
      .TopToPrevious = 380
    End With
            
    Set c = .Add(Nothing, c_margen)
    With c
      .PropertyType = cspNumeric
      .SubType = cspPercent
      .Name = LNGGetText(4906, vbNullString) 'Margen
      .Key = K_MARGEN
      .TopToPrevious = 380
      .Format = "0.000"
    End With
            
    Set c = .Add(Nothing, c_iva_porc)
    With c
      .PropertyType = cspNumeric
      .SubType = cspPercent
      .Name = LNGGetText(4902, vbNullString) 'Iva Porc.
      .Key = K_IVA_PORC
      .Enabled = False
      .TopToPrevious = 380
    End With
            
    Set c = .Add(Nothing, c_iva_importe)
    With c
      .PropertyType = cspNumeric
      .SubType = cspDouble
      .Name = LNGGetText(4903, vbNullString) 'Iva Importe
      .Key = K_IVA_IMPORTE
      .Enabled = False
      .TopFromProperty = c_iva_porc
      .Left = 4500
      .LeftNotChange = True
    End With
            
    Set c = .Add(Nothing, c_internos_porc)
    With c
      .PropertyType = cspNumeric
      .SubType = cspPercent
      .Name = LNGGetText(4904, vbNullString) 'Internos Porc.
      .Key = K_INTERNOS_PORC
      .Enabled = False
      .TopToPrevious = 380
    End With
            
    Set c = .Add(Nothing, c_internos_importe)
    With c
      .PropertyType = cspNumeric
      .SubType = cspDouble
      .Name = LNGGetText(4905, vbNullString) 'Internos Importe
      .Key = K_INTERNOS_IMPORTE
      .Enabled = False
      .TopFromProperty = c_internos_porc
      .Left = 4500
      .LeftNotChange = True
    End With
                
    Set c = .Add(Nothing, c_precio)
    With c
      .PropertyType = cspNumeric
      .SubType = cspDouble
      .Name = LNGGetText(4907, vbNullString) 'Precio Sin Impuestos
      .Key = K_PRECIO
      .TopToPrevious = 380
    End With
    
    Set c = .Add(Nothing, c_precio_final)
    With c
      .PropertyType = cspNumeric
      .SubType = cspDouble
      .Name = LNGGetText(4908, vbNullString) 'Precio Con Impuestos
      .Key = K_PRECIO_FINAL
      .TopFromProperty = c_precio
      .Left = 4500
      .LeftNotChange = True
    End With
            
    Set c = .Add(Nothing, c_cmd_save_prices)
    With c
      .PropertyType = cspButton
      .Name = LNGGetText(4913, vbNullString) 'Aplicar Precios
      .Key = K_CMD_SAVE_PRICES
      .TopFromProperty = c_precio
      .Left = 6500
      .LeftLabel = -1
      .LeftNotChange = True
    End With
            
    Set c = .Add(Nothing, c_Facturas)
    With c
      .PropertyType = cspGrid
      If Not pLoadFacturas(c) Then Exit Function
      .Name = c_Facturas
      .Key = K_FACTURAS
      .LeftLabel = -1
      .Left = 400
      .Height = 2000
      .TopFromProperty = c_precio
      .TopToPrevious = 440
      .GridAdd = False
      .GridEdit = True
      .GridRemove = False
    End With
            
    Set c = .Add(Nothing, c_Items)
    With c
      .PropertyType = cspGrid
      If Not pLoadItems(c) Then Exit Function
      .Name = c_Items
      .Key = K_ITEMS
      .LeftLabel = -1
      .Left = 400
      .TopFromProperty = c_Facturas
      .TopToPrevious = 2100
      .GridAdd = False
      .GridEdit = True
      .GridRemove = False
    End With
    
    m_ItemsDeleted = vbNullString
  
  End With
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

Private Function pLoadFacturas(ByRef Propiedad As cIABMProperty) As Boolean
    
  With Propiedad.Grid
    
    With .Columns
      
      .Clear
      
      With .Add(Nothing)
        .Visible = False
        .Key = KI_FC_ID
      End With
      
      With .Add(Nothing)
        .Visible = False
        .Key = KI_FCI_ID
      End With
      
      With .Add(Nothing)
        .Visible = False
        .Key = KI_DOCT_ID
      End With
      
      With .Add(Nothing)
        .PropertyType = cspCheck
        .Width = 400
        .Key = KI_FC_SELECT
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1569, vbNullString) 'Fecha
        .Width = 3500
        .Key = KI_FC_FECHA
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1866, vbNullString) 'Factura
        .Width = 3500
        .Key = KI_FC_FACTURA
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1151, vbNullString) 'Proveedor
        .Width = 3500
        .Key = KI_FC_PROVEEDOR
      End With
      
      With .Add(Nothing)
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Name = LNGGetText(4912, vbNullString) 'Precio Lista
        .Width = 3500
        .Key = KI_FC_PRECIO_LISTA
        .Format = m_GeneralConfig.FormatDecImporte
      End With
            
      With .Add(Nothing)
        .Name = LNGGetText(4909, vbNullString) 'Descuentos
        .Width = 3500
        .Key = KI_FC_DESCUENTOS
      End With
            
      With .Add(Nothing)
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Name = LNGGetText(1586, vbNullString) 'Precio
        .Width = 3500
        .Key = KI_FC_PRECIO
        .Format = m_GeneralConfig.FormatDecImporte
      End With
            
      With .Add(Nothing)
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Name = LNGGetText(1374, vbNullString) 'Cantidad
        .Width = 3500
        .Key = KI_FC_PRECIO
        .Format = m_GeneralConfig.FormatDecCantidad
      End With
            
    End With
      
  End With
  
  pLoadFacturas = True
End Function

Private Function pLoadFacturasXPrId(ByRef Propiedad As cIABMProperty) As Boolean
  
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  Dim bSelect As Boolean
    
  With m_ObjAbm.Properties
  
    sqlstmt = "sp_ProductoGetUltimasCompras " & m_Pr_id

  End With
  
  If Not gDB.OpenRs(sqlstmt, _
                    rs, _
                    csRsStatic, _
                    csLockReadOnly, _
                    csCmdText, _
                    "pLoadFacturasXPrId", _
                    C_Module) Then Exit Function
  
  bSelect = True
  
  With Propiedad.Grid
      
    With .Rows
    
      .Clear
    
      While Not rs.EOF
      
        ' Ahora tengo que colocar en la columna correspondiente
        ' las horas y su emh_id
        '
        With .Add(Nothing)
        
          With .Add(Nothing)
            .Id = gDB.ValField(rs.fields, cscFcId)
            .Key = KI_FC_ID
          End With
          
          With .Add(Nothing)
            .Id = gDB.ValField(rs.fields, cscFciId)
            .Key = KI_FCI_ID
          End With
          
          With .Add(Nothing)
            .Id = gDB.ValField(rs.fields, cscDoctId)
            .Key = KI_DOCT_ID
          End With
          
          With .Add(Nothing)
            .Id = bSelect
            .Key = KI_FC_SELECT  ' Checkbox
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscFcFecha)
            .Key = KI_FC_FECHA
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscFcNrodoc)
            .Key = KI_FC_FACTURA
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscProvNombre)
            .Key = KI_FC_PROVEEDOR
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscFciPrecioLista)
            .Key = KI_FC_PRECIO_LISTA
          End With
                    
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscFciDescuento)
            .Key = KI_FC_DESCUENTOS
          End With
                    
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscFciPrecio)
            .Key = KI_FC_PRECIO
          End With
                    
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscFciPrecio)
            .Key = KI_FC_CANTIDAD
          End With
                    
        End With
        
        bSelect = False
        
        rs.MoveNext
      Wend
    
    End With
  End With
  
  pLoadFacturasXPrId = True
End Function

Private Function pLoadItems(ByRef Propiedad As cIABMProperty) As Boolean
    
  With Propiedad.Grid
    
    With .Columns
      
      .Clear
      
      With .Add(Nothing)
        .Visible = False
        .Key = KI_LPI_ID
      End With
      
      With .Add(Nothing)
        .PropertyType = cspCheck
        .Width = 400
        .Key = KI_SELECT
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(2273, vbNullString) 'Lista
        .Width = 3500
        .Key = KI_LP_ID
      End With
      
      With .Add(Nothing)
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Name = LNGGetText(1586, vbNullString) 'Precio
        .Width = 3500
        .Key = KI_PRECIO
        .Format = m_GeneralConfig.FormatDecImporte
      End With
      
      With .Add(Nothing)
        .PropertyType = cspNumeric
        .SubType = cspPercent
        .Name = LNGGetText(1105, vbNullString) 'Porcentaje
        .Width = 3500
        .Key = KI_PORC
      End With
      
    End With
      
  End With
  
  pLoadItems = True
End Function

Private Function pLoadItemsXPrId(ByRef Propiedad As cIABMProperty) As Boolean
  
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  Dim Precio  As Double
    
  With m_ObjAbm.Properties
  
    sqlstmt = "sp_ProductoGetListasPrecio " & m_Pr_id

  End With
  
  If Not gDB.OpenRs(sqlstmt, _
                    rs, _
                    csRsStatic, _
                    csLockReadOnly, _
                    csCmdText, _
                    "pLoadItemsXPrId", _
                    C_Module) Then Exit Function
  
  With Propiedad.Grid
      
    With .Rows
    
      .Clear
    
      While Not rs.EOF
      
        ' Ahora tengo que colocar en la columna correspondiente
        ' las horas y su emh_id
        '
        With .Add(Nothing)
        
          Precio = gDB.ValField(rs.fields, cscLpiPrecio)
        
          With .Add(Nothing)
            .Id = gDB.ValField(rs.fields, cscLpiId)
            .Key = KI_LPI_ID
          End With
          
          With .Add(Nothing)
            .Key = KI_SELECT
            .Id = IIf(Precio, 1, 0)
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscLpNombre)
            .Id = gDB.ValField(rs.fields, cscLpId)
            .Key = KI_LP_ID
          End With
          
          With .Add(Nothing)
            .Value = Precio
            .Key = KI_PRECIO
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscLpiPorcentaje)
            .Key = KI_PORC
          End With
                    
        End With
        
        rs.MoveNext
      Wend
    
    End With
  End With
  
  pLoadItemsXPrId = True
End Function

Private Function pGetVentaCompra() As cIABMProperty
  Set pGetVentaCompra = m_ObjAbm.Properties.Item(cscPrVentaCompra)
End Function

Private Function pGetIVA() As cIABMProperty
  Set pGetIVA = m_ObjAbm.Properties.Item(c_iva_porc)
End Function

Private Function pGetInternosImporte() As cIABMProperty
  Set pGetInternosImporte = m_ObjAbm.Properties.Item(c_internos_importe)
End Function

Private Function pGetIVAImporte() As cIABMProperty
  Set pGetIVAImporte = m_ObjAbm.Properties.Item(c_iva_importe)
End Function

Private Function pGetInternos() As cIABMProperty
  Set pGetInternos = m_ObjAbm.Properties.Item(c_internos_porc)
End Function

Private Function pGetMargen() As cIABMProperty
  Set pGetMargen = m_ObjAbm.Properties.Item(c_margen)
End Function

Private Function pGetDescuento() As cIABMProperty
  Set pGetDescuento = m_ObjAbm.Properties.Item(c_descuento)
End Function

Private Function pGetCostoLista() As cIABMProperty
  Set pGetCostoLista = m_ObjAbm.Properties.Item(c_costo_lista)
End Function

Private Function pGetCosto() As cIABMProperty
  Set pGetCosto = m_ObjAbm.Properties.Item(c_costo)
End Function

Private Function pGetCostoVenta() As cIABMProperty
  Set pGetCostoVenta = m_ObjAbm.Properties.Item(c_costo_venta)
End Function

Private Function pGetPrecio() As cIABMProperty
  Set pGetPrecio = m_ObjAbm.Properties.Item(c_precio)
End Function

Private Function pGetPrecioFinal() As cIABMProperty
  Set pGetPrecioFinal = m_ObjAbm.Properties.Item(c_precio_final)
End Function

Private Sub pSavePrices()
  Dim row As cIABMGridRow
  
  For Each row In pGetItems().Grid.Rows
    If pCell(row, KI_SELECT).Id Then
      pSavePricesAux pCell(row, KI_LPI_ID).Id, _
                     Val(pGetPrecio().Value)
    End If
  Next

  Dim AbmGen As cABMGeneric
  Set AbmGen = m_ObjAbm

  pLoadItemsXPrId pGetItems()
  AbmGen.ShowValue pGetItems(), True

End Sub

Private Sub pSavePricesAux(ByVal lpi_id As Long, _
                           ByVal Precio As Double)
  Dim sqlstmt As String
  
  sqlstmt = "update ListaPrecioItem set lpi_precio = " _
               & gDB.sqlNumber(Precio) & _
            " where lpi_id = " & lpi_id
  
  gDB.Execute sqlstmt
  
End Sub


' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  c_ErrorSave = LNGGetText(4901, vbNullString) 'Error al grabar los precios

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

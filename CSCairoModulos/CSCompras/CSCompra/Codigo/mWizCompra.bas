Attribute VB_Name = "mWizCompra"
Option Explicit

Public Const c_StepWelcome             As Integer = 1
Public Const c_StepSelectProveedor     As Integer = 3
Public Const c_StepSelectOrdenRemito   As Integer = 4
Public Const c_StepSelectItems         As Integer = 6
Public Const c_StepPercepciones        As Integer = 7
Public Const c_StepDatosGenerales      As Integer = 8

Public Sub WizCpraLoadStepDatosGrales(ByRef ObjWiz As cIWizardGeneric, _
                                      ByRef resource As Object, _
                                      ByVal doc_id As Long, _
                                      ByVal prov_id As Long, _
                                      ByVal FormatCotiz As String)
  Dim Filter As String
  
  ' La clave de los pasos debe ser la constante que los define
  ' Esto es vital para que la navegacion funcione correctamente
  With ObjWiz.Steps.Add(Nothing, GetKey(c_StepDatosGenerales)).Properties
  
    With .Add(Nothing)
      '.Name = vbNullString
      .Top = 100
      .Left = 100
      .TopNotChange = True
      .LeftNotChange = True
      .PropertyType = cspImage
      .Value = 3
      'Set .Picture = resource.ImgWiz3.Picture
    End With

    With .Add(Nothing)
      '.Name = vbNullString
      .Top = 400
      .Left = 1500
      .TopNotChange = True
      .LeftNotChange = True
      .Height = 880
      .Width = 8000
      .PropertyType = cspLabel
      .FontBold = True
      .Value = LNGGetText(1663, vbNullString) 'Complete los siguientes datos de la factura
    End With
  
    With .Add(Nothing, c_Wiz_Key_Fecha)
      .PropertyType = cspDate
      .Left = 2800
      .Name = LNGGetText(1569, vbNullString) 'Fecha
      .Value = Date
    End With
    
    With .Add(Nothing, c_Wiz_Key_FechaIva)
      .PropertyType = cspDate
      .Left = 2800
      .Name = LNGGetText(1900, vbNullString)  'F. IVA
      .Value = Date
    End With
        
    With .Add(Nothing, c_Wiz_Key_Proveedor2)
      .PropertyType = cspHelp
      .Table = csProveedor
      .Enabled = False
      .Name = LNGGetText(1151, vbNullString) 'Proveedor
    End With
  
    With .Add(Nothing, c_Wiz_Key_CondicionPago)
      .PropertyType = cspHelp
      .Table = csCondicionPago
      .Name = LNGGetText(1395, vbNullString) 'Condición de Pago
      .Key = KW_CPG_ID
    End With
    
    With .Add(Nothing, c_Wiz_Key_FechaVto)
      .PropertyType = cspDate
      .Name = LNGGetText(1634, vbNullString)  'Vto.
      .Value = Date
      .Visible = False
    End With
    
    With .Add(Nothing, c_Wiz_Key_Sucursal)
      .PropertyType = cspHelp
      .Table = csSucursal
      .Name = LNGGetText(1281, vbNullString) 'Sucursal
      .Value = User.Sucursal
      .HelpId = User.suc_id
    End With
  
    With .Add(Nothing, c_Wiz_Key_Cotizacion)
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Name = LNGGetText(1635, vbNullString) 'Cotización
      .Format = FormatCotiz
    End With
  
    With .Add(Nothing, c_Wiz_Key_Comprobante)
      .PropertyType = cspText
      .Left = 6800
      .TopFromProperty = c_Wiz_Key_Fecha
      .Name = LNGGetText(1610, vbNullString) 'Comprobante
    End With
  
    With .Add(Nothing, c_Wiz_Key_ListaPrecio)
      .PropertyType = cspHelp
      .Table = csListaPrecio
      .Name = LNGGetText(1397, vbNullString) 'Lista de Precios
      .HelpFilter = GetListaPrecioGetXProveedor(doc_id, prov_id)
    End With
  
    With .Add(Nothing, c_Wiz_Key_ListaDescuento)
      .PropertyType = cspHelp
      .Table = csListaDescuento
      .Name = LNGGetText(1398, vbNullString) 'Lista de Descuentos
      .HelpFilter = GetListaDescGetXProveedor(doc_id, prov_id)
    End With
  
    With .Add(Nothing, c_Wiz_Key_Legajo)
      .PropertyType = cspHelp
      .Table = csLegajo
      .Name = LNGGetText(1575, vbNullString) 'Legajo
    End With
    
    With .Add(Nothing, c_Wiz_Key_CentroCosto)
      .PropertyType = cspHelp
      .Table = csCentroCosto
      .Name = LNGGetText(1057, vbNullString) 'Centro de Costo
    End With
  
    With .Add(Nothing, c_Wiz_Key_TipoComprobante)
      .PropertyType = cspList
      .Name = LNGGetText(1903, vbNullString) 'Tipo Comprobante
      .ListWhoSetItem = csListItemData
      .ListItemData = csETC_Original
      With .List
        With .Add(Nothing)
          .Id = csETC_Original
          .Value = LNGGetText(2090, vbNullString) 'Original
        End With
        
        With .Add(Nothing)
          .Id = csETC_Fax
          .Value = LNGGetText(1200, vbNullString) 'Fax
        End With
        
        With .Add(Nothing)
          .Id = csETC_FotoCopia
          .Value = LNGGetText(2091, vbNullString) 'Fotocopia
        End With
        
        With .Add(Nothing)
          .Id = csETC_Duplicado
          .Value = LNGGetText(2092, vbNullString) 'Duplicado
        End With
      End With
    End With

    With .Add(Nothing, c_Wiz_Key_CotizacionProv)
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Name = LNGGetText(4653, vbNullString) 'Cotización Proveedor
      .Format = FormatCotiz
    End With

    With .Add(Nothing, c_Wiz_Key_Observaciones)
      .PropertyType = cspText
      .Left = 2800
      .TopFromProperty = c_Wiz_Key_CotizacionProv
      .TopToPrevious = 440
      .Height = 880
      .Width = 6250
      .Name = LNGGetText(1861, vbNullString) 'Observaciones
    End With
  End With
End Sub

Public Sub WizCpraShowCotizacion(ByRef ObjWiz As cIWizardGeneric, _
                                 ByVal StepId As Integer, _
                                 ByVal DocId As Long, _
                                 ByVal bShow As Boolean)
  Dim MonId   As Long
  Dim iProp   As cIABMProperty
  
  If DocId = csNO_ID Then Exit Sub
  If Not gDB.GetData(csTDocumento, cscDocId, DocId, cscMonId, MonId) Then Exit Sub
  
  Set iProp = GetWizProperty(ObjWiz, StepId, c_Wiz_Key_Cotizacion)
  iProp.Visible = MonId <> GetMonedaDefault
  
  Dim Moneda As cMoneda
  Set Moneda = New cMoneda
  
  iProp.Value = Moneda.GetCotizacion(MonId, Date)
  
  If bShow Then
    ObjWiz.ShowValue iProp
  End If
End Sub

Public Sub pGetIvaFromProveedor(ByVal prov_id As Long, _
                                ByRef bIva As Boolean, _
                                ByRef bIvaRni As Boolean)
  Dim sqlstmt     As String
  Dim rs          As ADODB.Recordset
  
  sqlstmt = "sp_ProveedorGetIva " & prov_id
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  If rs.EOF Then Exit Sub
  
  bIva = gDB.ValField(rs.fields, "bIva")
  bIvaRni = gDB.ValField(rs.fields, "bIvaRni")
End Sub


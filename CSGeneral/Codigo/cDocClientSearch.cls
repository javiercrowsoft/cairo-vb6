VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cDocClientSearch"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cDocClientSearch
' 19-04-2005

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cDocClientSearch"
Private Const c_ObjABMName = "CSABMInterface2.cABMGeneric"

' estructuras
' variables privadas
' eventos
' propiedades publicas
Public Function Search(ByRef Filters As cIABMProperties, _
                       ByRef Fields As Collection, _
                       ByVal DoctId As Long, _
                       ByVal bReuseWindow As Boolean, _
                       ByVal bClientDoSearch As Boolean, _
                       ByRef ObjectClient As Object) As cSearchResult

  Dim DocServerSearch As cDocServerSearch
  Set DocServerSearch = New cDocServerSearch
  
  If Filters Is Nothing Then Set Filters = New cABMProperties
  If Fields Is Nothing Then Set Fields = New Collection
  
  pGetFilters Filters, DoctId
  pGetFields Fields, DoctId
  
  Dim rslt As cSearchResult
  Set rslt = DocServerSearch.Search(Filters, _
                                    Fields, _
                                    DoctId, _
                                    bClientDoSearch, _
                                    ObjectClient)
  If rslt.Success Then
    
    If rslt.Id <> csNO_ID Then
      If rslt.DoctId <> DoctId Or Not bReuseWindow Then
        pEdit rslt.DoctId, rslt.Id
      End If
    End If
  End If
  
  Set Search = rslt
End Function

Private Sub pEdit(ByVal DoctId As Long, ByVal CompId As Long)
  Dim DoctObject As String
  Dim PreId      As Long
    
  If DoctId > csNO_ID Then
    
    If Not GetDocumentoTipoInfo_(DoctId, _
                                 vbNullString, _
                                 DoctObject, _
                                 PreId) Then Exit Sub
      
      
    If Not SecurityCanAccess(PreId) Then Exit Sub
    
    Dim DocObj As cIEditGeneric
    Set DocObj = CSKernelClient2.CreateObject(DoctObject)
        
    Dim oDoc As cIEditGenericDoc
    
    Set DocObj.ObjAbm = CSKernelClient2.CreateObject(c_ObjABMName)
    Set oDoc = DocObj
    Set oDoc.Footer = CSKernelClient2.CreateObject(c_ObjABMName)
    Set oDoc.Items = CSKernelClient2.CreateObject(c_ObjABMName)
    
    DocObj.Edit CompId
  
  Else
  
    pEditTable DoctId * -1, CompId
  
  End If
  
End Sub

' propiedades friend
' propiedades privadas
' funciones publicas
' funciones friend
' funciones privadas
Private Sub pGetFields(ByRef Fields As Collection, _
                       ByVal DoctId As Long)
  
  If Fields.Count Then Exit Sub
  
  If DoctId > csNO_ID Then
    
    Fields.Add c_FieldNumero
    Fields.Add c_FieldComprobante
    Fields.Add c_FieldTotal
    Fields.Add c_FieldObservaciones
    
  ElseIf DoctId = csProductoSerie * -1 Then
    
    Fields.Add c_FieldCodigo
    Fields.Add c_FieldCodigo2
    Fields.Add c_FieldCodigo3
    Fields.Add c_FieldCodigo4
    Fields.Add c_FieldContacto
  
  Else
  
    Fields.Add c_FieldCodigo
  
  End If
End Sub

Private Sub pGetFilters(ByRef Filter As cIABMProperties, _
                        ByVal DoctId As Long)
  Dim c As cIABMProperty
  Dim o As cIABMListItem
  Dim Value           As String
  Dim bExists         As Boolean
  Dim bAddCliente     As Boolean
  Dim bAddProveedor   As Boolean
  Dim bAddDeposito    As Boolean
  Dim bAddCuenta      As Boolean
  Dim bAddBarco       As Boolean
  Dim bAddBanco       As Boolean
  Dim bAddVendedor    As Boolean

  Const csDocumentoTipo = 4003
  Const csEstado = 4005
  Const csDocumento = 4001
  Const csBarco = 12004

  If Filter.Count Then Exit Sub

  Dim doctNombre As String

  ' Si me pasaron un DoctId
  '
  If DoctId > csNO_ID Then

    If Not GetDocumentoTipoInfo_(DoctId, _
                                 doctNombre, _
                                 vbNullString, _
                                 0) Then Exit Sub
  End If
  
  bAddCliente = False
  bAddProveedor = False
  bAddDeposito = False
  bAddCuenta = False
  bAddBarco = False
  bAddBanco = False
  bAddVendedor = False
  
  Select Case DoctId
    Case csEDT_FacturaVenta, csEDT_RemitoVenta, csEDT_PedidoVenta, csEDT_NotaCreditoVenta, _
         csEDT_NotaDebitoVenta, csEDT_PresupuestoVenta, csEDT_Cobranza, csEDT_PresupuestoEnvio, _
         csEDT_ManifiestoCarga, csEDT_DevolucionPedidoVta, csEDT_DevolucionRemitoVta, _
         csEDT_MovimientoFondo, csEDT_PackingList, csEDT_ImportacionTemp, _
         csEDT_PackingListDevolucion
         
      bAddCliente = True
      bAddVendedor = True
      
    Case csEDT_FacturaCompra, csEDT_RemitoCompra, csEDT_PedidoCompra, csEDT_NotaCreditoCompra, _
         csEDT_NotaDebitoCompra, csEDT_PresupuestoCompra, csEDT_OrdenPago, _
         csEDT_DevolucionPedidoCpra, csEDT_DevolucionRemitoCpra
      
      bAddProveedor = True
         
    Case csEDT_AsientoContable, csEDT_MovimientoFondo
    
      bAddCuenta = True
    
    Case csEDT_TrasferenciaStock, csEDT_RecuentoStock, csEDT_ParteProdKit
    
      bAddDeposito = True
    
    Case csEDT_DepositoBanco, csEDT_DepositoCupon, csEDT_ResolucionCupon
    
      bAddBanco = True
    
    Case csEDT_PermisoEmbarque
    
      bAddBarco = True
      
    Case csProductoSerie * -1
    
      bAddCliente = True
      bAddProveedor = True
      bAddDeposito = True
  
  End Select

  With Filter

    If DoctId > csNO_ID Then

      Set c = .Add(Nothing, cscDoctId)
      c.PropertyType = cspHelp
      c.Table = csDocumentoTipo
      c.Name = LNGGetText(2366, vbNullString)  'Tipo de documento
      c.Value = doctNombre
      c.HelpId = DoctId
    
    Else
      
      Set c = .Add(Nothing, cscDoctId)
      c.Visible = False
      c.HelpId = DoctId
    
    End If
    
    Set c = .Add(Nothing, c_FechaIni)
    c.PropertyType = cspDate
    c.Name = LNGGetText(1203, vbNullString)  'Fecha desde
    c.Value = VDGetDateById(csMonthLast_FirstDay)
  
    Set c = .Add(Nothing, c_FechaFin)
    c.PropertyType = cspDate
    c.Name = LNGGetText(1204, vbNullString)  'Fecha hasta
    c.Value = VDGetDateById(csToday)
    
    If bAddCliente Then
    
      Set c = .Add(Nothing, cscCliId)
      c.PropertyType = cspHelp
      c.Table = csCliente
      c.Name = LNGGetText(1150, vbNullString)  'Cliente
    End If
    
    If bAddProveedor Then
      Set c = .Add(Nothing, cscProvId)
      c.PropertyType = cspHelp
      c.Table = csProveedor
      c.Name = LNGGetText(1151, vbNullString)  'Proveedor
    End If
    
    Set c = .Add(Nothing, cscEstId)
    c.PropertyType = cspHelp
    c.Table = csEstado
    c.Name = LNGGetText(1568, vbNullString)  'Estado
    
    Set c = .Add(Nothing, cscSucId)
    c.PropertyType = cspHelp
    c.Table = csSucursal
    c.Name = LNGGetText(1281, vbNullString)  'Sucursal
    
    If bAddVendedor Then
    
      Set c = .Add(Nothing, cscVenId)
      c.PropertyType = cspHelp
      c.Table = csVendedores
      c.Name = LNGGetText(1510, vbNullString)  'Vendedor
    End If
    
    If bAddCuenta Then
    
      Set c = .Add(Nothing, cscCueId)
      c.PropertyType = cspHelp
      c.Table = csCuenta
      c.Name = LNGGetText(1267, vbNullString)  'Cuenta
    End If
    
    If bAddBanco Then
    
      Set c = .Add(Nothing, cscBcoId)
      c.PropertyType = cspHelp
      c.Table = csBanco
      c.Name = LNGGetText(1122, vbNullString)  'Banco
    End If
    
    If bAddBarco Then
    
      Set c = .Add(Nothing, cscBarcId)
      c.PropertyType = cspHelp
      c.Table = csBarco
      c.Name = LNGGetText(2424, vbNullString)  'Barco
    End If
    
    Set c = .Add(Nothing, cscDocId)
    c.PropertyType = cspHelp
    c.Table = csDocumento
    c.Name = LNGGetText(1611, vbNullString)  'Documentos
   
    Set c = .Add(Nothing, cscEmpId)
    c.PropertyType = cspHelp
    c.Table = csEmpresa
    c.Name = LNGGetText(1114, vbNullString)  'Empresa
  End With
End Sub

Private Sub pEditTable(ByVal Tbl_id As Long, _
                       ByVal Id As Long)
  
  Dim sqlstmt     As String
  Dim rs          As ADODB.Recordset
  Dim ObjAbmName  As String
  Dim ObjEditName As String
  
  sqlstmt = "select * from tabla where tbl_id = " & Tbl_id
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  If rs.EOF Then Exit Sub
  
  ObjAbmName = gDB.ValField(rs.Fields, cscTblobjectABM)
  ObjEditName = gDB.ValField(rs.Fields, cscTblobjectEdit)

  Dim Obj     As Object
  Dim o       As cIEditGeneric
  Dim Editor  As cIABMGeneric
  
  Set Obj = CSKernelClient2.CreateObject(ObjEditName)
  Set o = Obj
  
  Set Editor = CSKernelClient2.CreateObject(ObjAbmName)
  Set o.ObjAbm = Editor

  o.Edit Id, False

End Sub

' construccion - destruccion

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

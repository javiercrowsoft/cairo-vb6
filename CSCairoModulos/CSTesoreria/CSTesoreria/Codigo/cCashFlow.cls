VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cCashFlow"
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
' cCashFlow
' 01-11-2006

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cCashFlow"

'AsientoItem
Private Const csTAsientoItem                           As String = "AsientoItem"
Private Const cscAsiId                                 As String = "asi_id"
Private Const cscAsiOrden                              As String = "asi_orden"
Private Const cscAsiDescrip                            As String = "asi_descrip"
Private Const cscAsiDebe                               As String = "asi_debe"
Private Const cscAsiHaber                              As String = "asi_haber"
Private Const cscAsiOrigen                             As String = "asi_origen"


Private Const c_id_row_fecha          As Long = -100
Private Const c_id_row_fecha_total    As Long = -101
Private Const c_id_row_total_periodo  As Long = -102

Private Const c_debe             As Long = 1
Private Const c_haber            As Long = 2

Private Const c_load             As String = "load"
Private Const c_params           As String = "params"
Private Const c_crosstab         As String = "crosstab"
Private Const c_grid_crosstab    As String = "grid_crosstab"
Private Const c_Items            As String = "Items"
Private Const c_SaldoDetalle     As String = "SaldoDetalle"
Private Const c_Ctas             As String = "Ctas"
Private Const c_Origen           As String = "ORIGEN"
Private Const c_saldoInicial     As String = "SaldoIni"
Private Const c_saldoIniExcluido As String = "SaldoIniEx"
Private Const c_total            As String = "total"
Private Const c_totalexcluido    As String = "totalex"

Private Const c_changed          As String = "changed"
Private Const c_key_debe         As String = "debe"
Private Const c_key_haber        As String = "haber"
Private Const c_excluir          As String = "excluir"
Private Const c_saldo            As String = "saldo"
Private Const c_tercero          As String = "tercero"
Private Const c_comprobante      As String = "comprobante"

Private Const c_key_debeex         As String = "debeex"
Private Const c_key_haberex        As String = "haberex"
Private Const c_saldoex            As String = "saldoex"

Private Const K_NOMBRE                         As Integer = 1
Private Const K_FECHA                          As Integer = 2
Private Const K_DESCRIP                        As Integer = 3
Private Const K_FECHADESDE                     As Integer = 4
Private Const K_FECHAHASTA                     As Integer = 5
Private Const K_FECHACHEQUE                    As Integer = 6
Private Const K_FV                             As Integer = 7
Private Const K_RV                             As Integer = 8
Private Const K_PV                             As Integer = 9
Private Const K_FC                             As Integer = 10
Private Const K_RC                             As Integer = 11
Private Const K_OC                             As Integer = 12
Private Const K_CUE_ID                         As Integer = 13

Private Const K_PARAMS                         As Integer = 14
Private Const K_CROSSTAB                       As Integer = 140

Private Const K_SALDO_INI                      As Integer = 100
Private Const K_SALDO_INI_EXCLUIDO             As Integer = 101
Private Const K_TOTAL                          As Integer = 102
Private Const K_TOTAL_EXCLUIDO                 As Integer = 103

Private Const K_LOAD                           As Integer = 104
Private Const K_ITEMS                          As Integer = 105
Private Const K_CUENTAS                        As Integer = 106
Private Const K_CUENTAS_PARAM                  As Integer = 107
Private Const K_SALDO_DETALLE                  As Integer = 108
Private Const K_ITEMS_CROSSTAB                 As Integer = 109

Private Const KI_CFP_ID                         As Integer = 1
Private Const KI_CUENTA                         As Integer = 100
Private Const KI_CFI_ID                         As Integer = 1
Private Const KI_EXCLUIR                        As Integer = 2
Private Const KI_FECHA                          As Integer = 3
Private Const KI_ORDEN                          As Integer = 4
Private Const KI_DESCRIP                        As Integer = 6
Private Const KI_HABER                          As Integer = 20
Private Const KI_DEBE                           As Integer = 21
Private Const KI_CCOS_ID                        As Integer = 22
Private Const KI_ORIGEN                         As Integer = 24

Private Const KI_DH                             As Integer = 5000
Private Const KI_FECHA_REAL                     As Integer = 5001
Private Const KI_FECHA_REAL2                    As Integer = 5002
Private Const KI_IMPORTE_REAL                   As Integer = 5003
Private Const KI_IMPORTE_REAL2                  As Integer = 5004

Private Const KI_TDOC                           As Integer = 2001
Private Const KI_COMP                           As Integer = 2002
Private Const KI_TERCERO                        As Integer = 2003
Private Const KI_SALDO                          As Integer = 2004

Private Const KI_HABER_EX                       As Integer = 3070
Private Const KI_DEBE_EX                        As Integer = 3071
Private Const KI_SALDO_EX                       As Integer = 3072

Private Const KICH_IMPORTE               As Integer = 1003
Private Const KICH_IMPORTEORIGEN         As Integer = 1004
Private Const KICH_CHEQUERA              As Integer = 1005
Private Const KICH_CHEQUE                As Integer = 1006
Private Const KICH_CHEQ_ID               As Integer = 1007
Private Const KICH_MON_ID                As Integer = 1008
Private Const KICH_CUE_ID                As Integer = 1009
Private Const KICH_FECHACOBRO            As Integer = 1010
Private Const KICH_FECHAVTO              As Integer = 1011
Private Const KICH_CLE_ID                As Integer = 1012
Private Const KICH_DESCRIP               As Integer = 1013
Private Const KICH_COBZ_ID               As Integer = 1014
Private Const KICH_OPG_ID                As Integer = 1015
Private Const KICH_MF_ID                 As Integer = 1016

Private Const KI_CHANGED                 As Integer = 9999

' pseudo-constantes
Private c_ErrorSave       As String

' estructuras
' variables privadas

Private m_Id                           As Long
Private m_Nombre                       As String
Private m_Fecha                        As Date
Private m_Descrip                      As String
Private m_Fechadesde                   As Date
Private m_Fechahasta                   As Date
Private m_Fechacheque                  As Boolean
Private m_Fv                           As Boolean
Private m_Rv                           As Boolean
Private m_Pv                           As Boolean
Private m_Fc                           As Boolean
Private m_Rc                           As Boolean
Private m_Oc                           As Boolean
Private m_cue_id                       As Long
Private m_cuenta                       As String

Private m_Params                       As Collection

Private m_Editing           As Boolean
Private m_Host              As CSMenu.cIMenuHost
Private m_ObjAbm            As cIABMGeneric
Private m_ObjTree           As Object

Private m_Title             As String
Private m_GeneralConfig     As cGeneralConfig

Private m_Changed           As Boolean
Private m_ParamsChanged     As Boolean

Private m_BranchId      As Long
Private m_TreeId        As Long

Private m_IsNew         As Boolean
Private m_Copy          As Boolean

' eventos
' propiedades publicas
Public Property Get Id() As Long
  Id = m_Id
End Property
' propiedades friend
' propiedades privadas
' funciones publicas
Private Function cIABMClient_Copy() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True
  
  With m_ObjAbm.Properties(cscCfNombre)
    .Value = "C- " & .Value
  End With
  
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscCfNombre)
  
  m_Copy = True
End Function

Private Function cIABMClient_EditNew() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True
  
  Load csNO_ID
  pRefreshProperties
End Function

Private Property Get cIABMClient_Aplication() As String
  cIABMClient_Aplication = gAppName
End Property

Private Property Get cIABMClient_CanAddDocDigital() As Boolean
  cIABMClient_CanAddDocDigital = False
End Property

Private Property Get cIABMClient_CanCopy() As Boolean
  cIABMClient_CanCopy = True
End Property

Private Property Get cIABMClient_CanNew() As Boolean
  cIABMClient_CanNew = True
End Property

Private Function cIABMClient_ShowDocDigital() As Boolean
  cIABMClient_ShowDocDigital = False
End Function

Private Function cIABMClient_MessageEx(ByVal MessageID As Long, ByVal Info As Variant) As Variant
  Select Case MessageID
  
    Case MSG_DOC_REFRESH
      pRefreshProperties
    
    Case Else
      cIABMClient_MessageEx = True
  
  End Select

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
    
    Case K_LOAD
      
      Dim Mouse As cMouseWait
      Set Mouse = New cMouseWait
      
      If m_Changed Then
        If Ask(LNGGetText(2046, vbNullString), vbYes) Then
               'Desea guardar los cambios
          If Not pSaveItems(False, m_Id) Then Exit Function
          If m_ParamsChanged Then
            If Not pSaveParams(m_Id) Then Exit Function
          End If
        End If
        m_Changed = False
      End If
      
      If m_ParamsChanged Then
        If Ask(LNGGetText(2066, vbNullString), vbYes) Then
                'Para que los cambios a los parámetros tengan efecto se deben guardar.;;¿Desea guardar los cambios?
          If m_Id = csNO_ID Then
            If Not pSave() Then Exit Function
          Else
            If Not pSaveParams(m_Id) Then Exit Function
          End If
        End If
        m_Changed = False
      End If
      
      pLoadSaldoDetalleXCuenta
      pLoadItemsXCuenta
      pLoadCuentaSaldos
      
    Case K_PARAMS
      
      pEditParams
      
    Case K_CROSSTAB
    
      pShowCrosstab
      
    Case Else
    
      Dim AbmObj As cABMGeneric
      Set AbmObj = m_ObjAbm
      AbmObj.bDontAskForSave = True
      
  End Select
End Function

Private Function cIABMClient_Save() As Boolean
  On Error GoTo ControlError
  
  If pSave() Then
  
    pLoadSaldoDetalleXCuenta
    pLoadItemsXCuenta
    pLoadCuentaSaldos
  
    cIABMClient_Save = True
  
  Else
  
    cIABMClient_Save = False
  
  End If
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClient_Save", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIABMClient_Terminate() As Boolean
  m_Editing = False
  
  cIABMClient_Terminate = True
  ' Este objeto puede no cumplir con la interfaz esperada, asi que si hay un error no
  ' le doy bola
  On Error GoTo ControlError
  If m_Id = csNO_ID Then Exit Function
  If m_ObjTree Is Nothing Then Exit Function
  
  m_ObjTree.sqlstmt = "sp_lsdoc_cashflow"
  
  If m_IsNew Then
    m_ObjTree.AddLine m_Id
  Else
    m_ObjTree.RefreshLine m_Id
  End If
ControlError:
End Function

Private Property Get cIABMClient_Title() As String
  cIABMClient_Title = m_Title
End Property

Private Function cIABMClient_Validate() As Boolean

  Dim IProperty As cIABMProperty

  CSKernelClient2.Title = LNGGetText(2067, vbNullString) 'Flujo de Fondos

  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_NOMBRE
          If ValEmpty(.Value, csText) Then
            MsgInfo LNGGetText(1855, vbNullString) 'Debe indicar un título
            Exit Function
          End If
      End Select
    End With
  Next

  cIABMClient_Validate = True
End Function

Private Function cIABMClientGrid_ColumnAfterEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long) As Boolean
  cIABMClientGrid_ColumnAfterEdit = True
End Function

Private Function cIABMClientGrid_ColumnAfterUpdate(ByVal Key As Integer, _
                                                   ByVal lRow As Long, _
                                                   ByVal lCol As Long) As Boolean
  Dim Row As cIABMGridRow
  Set Row = pGetItems().Grid.Rows(lRow)
  
  Dim row_id As Long
  row_id = Val(Row.Item(cscCfiId).Value)
  
  If row_id = c_id_row_fecha Or _
     row_id = c_id_row_fecha_total Or _
     row_id = c_id_row_total_periodo Then
    Exit Function
  End If
  
  Row.Item(c_changed).Value = 1
  
  Dim Total           As Double
  Dim total_excluido  As Double
  Dim Debe            As Double
  Dim Haber           As Double
  
  Dim total_debe  As Double
  Dim total_haber As Double

  Dim total_debe2  As Double
  Dim total_haber2 As Double

  Total = Val(pGetSaldoIni().Value)
  
  Dim i         As Long
  Dim Rows      As cIABMGridRows
  Dim oFormat   As cABMGridCellFormat
  
  Set Rows = pGetItems().Grid.Rows
  
  Dim importe_real As Double
  Dim importe      As Double
  Dim strImporte   As String
  
  importe_real = Val(pCell(Row, KI_IMPORTE_REAL).Value)
  importe = Val(pCell(Row, KI_DEBE).Value)
  If importe = 0 Then importe = Val(pCell(Row, KI_HABER).Value)
  
  If importe_real <> importe Then
    strImporte = importe_real
  Else
    strImporte = vbNullString
  End If
  pCell(Row, KI_IMPORTE_REAL2).Value = strImporte
  
  Dim fecha_real As Date
  Dim fecha      As Date
  Dim strfecha   As String
  
  fecha_real = pCell(Row, KI_FECHA_REAL).Value
  fecha = pCell(Row, KI_FECHA).Value
  
  If fecha_real <> fecha Then
    strfecha = fecha_real
  Else
    strfecha = vbNullString
  End If
  pCell(Row, KI_FECHA_REAL2).Value = strfecha
  
  
  For i = 1 To pGetItems().Grid.Rows.count
    Set Row = Rows.Item(i)

    row_id = Val(Row.Item(cscCfiId).Value)

    If row_id = c_id_row_fecha_total Then
    
      Row.Item(c_key_debe).Value = total_debe
      Row.Item(c_key_haber).Value = total_haber
      
      total_debe = 0
      total_haber = 0
    
    ElseIf row_id = c_id_row_total_periodo Then
      
      Row.Item(c_key_debe).Value = total_debe2
      Row.Item(c_key_haber).Value = total_haber2
      
    Else
      
      Debe = Val(Row.Item(c_key_debe).Value)
      Haber = Val(Row.Item(c_key_haber).Value)
  
      If Row.Item(c_excluir).Id Then
        
        total_excluido = total_excluido + Debe - Haber
        
        Set oFormat = Row.Item(c_comprobante).Format
        oFormat.Strike = True
        Set oFormat = Row.Item(c_tercero).Format
        oFormat.Strike = True
        Set oFormat = Row.Item(c_key_debe).Format
        oFormat.Strike = True
        oFormat.Align = 2 'DT_RIGHT
        Set oFormat = Row.Item(c_key_haber).Format
        oFormat.Strike = True
        oFormat.Align = 2 'DT_RIGHT
          
      Else
        
        total_debe = total_debe + Debe
        total_haber = total_haber + Haber
        total_debe2 = total_debe2 + Debe
        total_haber2 = total_haber2 + Haber
        Total = Total + Debe - Haber
          
        If row_id >= 0 Then
          Set oFormat = Row.Item(c_comprobante).Format
          oFormat.Strike = False
        End If
        
        Set oFormat = Row.Item(c_tercero).Format
        oFormat.Strike = False
        Set oFormat = Row.Item(c_key_debe).Format
        oFormat.Strike = False
        oFormat.Align = 2 'DT_RIGHT
        Set oFormat = Row.Item(c_key_haber).Format
        oFormat.Strike = False
        oFormat.Align = 2 'DT_RIGHT
      End If
    End If
    
    Row.Item(c_saldo).Value = Total
  Next

  Dim iProp  As cIABMProperty
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  
  Set iProp = pGetTotal()
  iProp.Value = Total
  AbmObj.ShowValue iProp
  
  Set iProp = pGetTotalExcluido()
  iProp.Value = Val(pGetSaldoIniExcluido().Value) + total_excluido
  AbmObj.ShowValue iProp
  
  Set iProp = pGetItems()
  AbmObj.RefreshGridRows iProp, 11
  
  m_Changed = True
  
  cIABMClientGrid_ColumnAfterUpdate = True
End Function

Private Function cIABMClientGrid_ColumnBeforeEdit(ByVal Key As Integer, _
                                                  ByVal lRow As Long, _
                                                  ByVal lCol As Long, _
                                                  ByVal iKeyAscii As Integer) As Boolean
  Dim Row       As cIABMGridRow
  Dim col_key   As Long
  
  Set Row = pGetItems().Grid.Rows(lRow)
  col_key = Row.Item(lCol).Key
  
  Dim row_id As Long
  
  row_id = Val(Row.Item(cscCfiId).Value)
  
  If row_id = c_id_row_fecha Or _
     row_id = c_id_row_fecha_total Then
    Exit Function
  End If
  
  Select Case col_key
    Case KI_EXCLUIR, KI_FECHA
      cIABMClientGrid_ColumnBeforeEdit = True
    Case KI_DEBE
      cIABMClientGrid_ColumnBeforeEdit = Val(pCell(Row, KI_DH).Value) = c_debe
    Case KI_HABER
      cIABMClientGrid_ColumnBeforeEdit = Val(pCell(Row, KI_DH).Value) = c_haber
  End Select
End Function

Private Function cIABMClientGrid_ColumnButtonClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean

End Function

Private Sub cIABMClientGrid_ColumnCancelEdit(ByVal Key As Integer)

End Sub

Private Sub cIABMClientGrid_ColumnClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Sub cIABMClientGrid_DblClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)
  On Error GoTo ControlError
  
  Dim Id          As Long
  Dim ObjEditName As String
  Dim tipo        As Long
  Dim iProp       As cIABMProperty
  
  Select Case Key

    Case K_ITEMS
      
      Set iProp = pGetItems()
      
      With iProp.Grid.Rows
        
        Id = pCell(.Item(lRow), KI_COMP).Id
        
        If Id <> csNO_ID Then
          
          tipo = pCell(.Item(lRow), KI_TDOC).Id
          
          Select Case tipo
          
            Case csEDocumentoTipo.csEDT_PedidoVenta
              ObjEditName = "CSPedidoVenta2.cPedidoVenta"
            Case csEDocumentoTipo.csEDT_OrdenCompra
              ObjEditName = "CSCompra2.cOrdenCompra"
            
            Case csEDocumentoTipo.csEDT_FacturaVenta, _
                 csEDocumentoTipo.csEDT_NotaCreditoVenta, _
                 csEDocumentoTipo.csEDT_NotaDebitoVenta
            
              ObjEditName = "CSVenta2.cFacturaVenta"
              Id = pGetFvIdFromFvdId(Id)
              
            Case csEDocumentoTipo.csEDT_FacturaCompra, _
                 csEDocumentoTipo.csEDT_NotaCreditoCompra, _
                 csEDocumentoTipo.csEDT_NotaDebitoCompra
              
              ObjEditName = "CSCompra2.cFacturaCompra"
              Id = pGetFcIdFromFcdId(Id)
              
            Case csEDocumentoTipo.csEDT_AsientoContable
            
              ObjEditName = "CSContabilidad2.cAsiento"
              Id = pGetAsIdFromAsiId(Id)
              
            Case csEDocumentoTipo.csEDT_OrdenPago
            
              ObjEditName = "CSTesoreria2.cOrdenPago"
              Id = pGetOpgIdFromOpgiId(Id)
              
            Case csEDocumentoTipo.csEDT_Cobranza
            
              ObjEditName = "CSTesoreria2.cCobranza"
              Id = pGetCobzIdFromCobziId(Id)
            
            Case csEDocumentoTipo.csEDT_RemitoVenta, _
                 csEDocumentoTipo.csEDT_DevolucionRemitoVta
            
              ObjEditName = "CSVenta2.cRemitoVenta"

            Case csEDocumentoTipo.csEDT_RemitoCompra, _
                 csEDocumentoTipo.csEDT_DevolucionRemitoCpra
            
              ObjEditName = "CSCompra2.cRemitoCompra"

            Case csEDocumentoTipo.csEDT_MovimientoFondo
            
              ObjEditName = "CSTesoreria2.cMovimientoFondo"
              Id = pGetMfIdFromMfiId(Id)
              
          End Select

          If Id > 0 Then
            ShowDocAux Id, _
                       ObjEditName, _
                       "CSABMInterface2.cABMGeneric"
                                
          End If
        End If
      End With
  End Select

  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_DblClick", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Function cIABMClientGrid_DeleteRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal lRow As Long) As Boolean
  cIABMClientGrid_DeleteRow = False
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

' ////////////////////////////////
' ////////////////////////////////
' ////////////////////////////////
' ////////////////////////////////
' ////////////////////////////////
' ////////////////////////////////

' Menu
Private Function cIMenuClient_Initialize(F As Object, Host As CSMenu.cIMenuHost) As Boolean
  On Error GoTo ControlError
  Dim str_2048  As String
  
  str_2048 = LNGGetText(2048, vbNullString) 'T&esoreria
  Set m_Host = Host
  m_Host.Server.AddMenu str_2048, csMenuEnum.csMenuTesoreria, vbNullString, 1, False, False, False, True, False, Nothing
  
  m_Host.Server.AddMenu LNGGetText(2068, vbNullString), csPreTsrEditCashFlow, str_2048, 0, True, False, False, False, False, Me
                          'Fl&ujo de Fondos
  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, C_MenuClientInit, C_Module, vbNullString
  If Err.Number Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal Id As Long) As Variant
  m_Host.MenuListDocClick "CSABMInterface2.CABMGeneric", "CSTesoreria2.cCashFlow", "CSABMInterface2.CABMGenericListDoc", "CSTesoreria2.cCashFlowListDoc", Me, m_Title, 0
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
  cIEditGeneric_ShowList = SecurityCanAccess(csPreTsrEditCashFlow)
End Function

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
  Set m_ObjAbm = rhs
End Property

Private Property Get cIEditGeneric_Editing() As Boolean
  cIEditGeneric_Editing = m_Editing
End Property

Private Function cIEditGeneric_Delete(Id As Long) As Boolean
  If Not SecurityCanAccess(csPreTsrEditCashFlow) Then Exit Function
  
  Dim sqlstmt As String
  
  sqlstmt = "sp_DocCashFlowDelete " & Id & "," & EmpId & "," & User.Id
  
  cIEditGeneric_Delete = gDB.Execute(sqlstmt, "cIEditGeneric_Delete", "cCashFlow")
End Function

Private Function cIEditGeneric_Search(Id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Id = csNO_ID Then
    m_IsNew = True
    If Not SecurityCanAccess(csPreTsrEditCashFlow) Then Exit Function
  Else
    m_IsNew = False
    If Not SecurityCanAccess(csPreTsrEditCashFlow) Then Exit Function
  End If

  ' JMA I
  m_ObjAbm.InModalWindow = InModalWindow
' JMA F
  
  If Not Load(Id) Then Exit Function
  
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
  MngError Err, "cIEditGeneric_Edit", "cCashFlow", vbNullString
End Function

Private Function cIEditGeneric_PrintObj(ByVal Id As Long) As Boolean

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

Private Function cIEditGeneric_Preview(ByVal Id As Long) As Boolean

End Function

Private Sub pEdit()
  On Error GoTo ControlError
  
  Set m_ObjAbm = New cABMGeneric
  
  If Not SecurityCanAccess(csPreTsrEditCashFlow) Then Exit Sub
  
  If Not LoadCollection() Then Exit Sub
  
  m_Editing = True
  
  Exit Sub
ControlError:
  MngError Err, "pEdit", C_Module, vbNullString
End Sub

Private Function LoadCollection() As Boolean
  
  Dim c As cIABMProperty
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  AbmObj.bSendRefresh = True
  
  With m_ObjAbm.Tabs
    .Clear
    With .Add(Nothing)
      .Name = C_strGeneral
    End With
    With .Add(Nothing)
      .Name = LNGGetText(1861, vbNullString)  'Observaciones
      .Index = 1
    End With
    With .Add(Nothing)
      .Name = LNGGetText(4846, vbNullString)  'Vista Semanal
      .Index = 2
    End With
  End With
  
  With m_ObjAbm.Properties
  
    .Clear
    
    With .Add(Nothing, cscCfNombre)
      .PropertyType = cspText
      .Left = 950
      .LeftLabel = -600
      .Name = LNGGetText(1864, vbNullString)  'Título
      .Size = 255
      .Width = 6750
      .Key = K_NOMBRE
      .Value = m_Nombre
    End With
  
    With .Add(Nothing, cscCfFecha)
      .PropertyType = cspDate
      .TopFromProperty = cscCfNombre
      .Left = 8900
      .LeftLabel = -600
      .Name = LNGGetText(1569, vbNullString)  'Fecha
      .Key = K_FECHA
      .Value = m_Fecha
    End With
  
    With .Add(Nothing, cscCueId)
      .PropertyType = cspHelp
      .Table = csCuenta
      .Left = 950
      .LeftLabel = -600
      .Width = 3900
      .Name = LNGGetText(1267, vbNullString)  'Cuenta
      .Key = K_CUE_ID
      .Value = m_cuenta
      .HelpId = m_cue_id
    End With
  
    With .Add(Nothing, cscCfFechadesde)
      .PropertyType = cspDate
      .Name = LNGGetText(1203, vbNullString)  'Fecha Desde
      .TopFromProperty = cscCueId
      .Left = 6300
      .LeftLabel = -1000
      .LeftNotChange = True
      .Key = K_FECHADESDE
      .Value = m_Fechadesde
    End With
  
    With .Add(Nothing, cscCfFechahasta)
      .PropertyType = cspDate
      .Name = LNGGetText(1204, vbNullString)  'Fecha Hasta
      .TopFromProperty = cscCueId
      .Left = 8900
      .LeftLabel = -1000
      .LeftNotChange = True
      .Key = K_FECHAHASTA
      .Value = m_Fechahasta
    End With
  
    With .Add(Nothing, cscCfFechacheque)
      .PropertyType = cspCheck
      .Left = 3450
      .LeftLabel = -3100
      .Name = LNGGetText(2050, vbNullString)  'Tomar la fecha de cobro de los cheques
      .Key = K_FECHACHEQUE
      .Value = CInt(m_Fechacheque)
    End With
  
    With .Add(Nothing, cscCfFv)
      .PropertyType = cspCheck
      .TopFromProperty = cscCfFechacheque
      .Left = 4650
      .LeftLabel = -280
      .Name = LNGGetText(2069, vbNullString)  'FV
      .Key = K_FV
      .Value = CInt(m_Fv)
    End With
  
    With .Add(Nothing, cscCfRv)
      .PropertyType = cspCheck
      .TopFromProperty = cscCfFv
      .Left = 5400
      .LeftLabel = -280
      .Name = LNGGetText(2070, vbNullString)  'RV
      .Key = K_RV
      .Value = CInt(m_Rv)
    End With
  
    With .Add(Nothing, cscCfPv)
      .PropertyType = cspCheck
      .TopFromProperty = cscCfFv
      .Left = 6150
      .LeftLabel = -280
      .Name = LNGGetText(2071, vbNullString)  'PV
      .Key = K_PV
      .Value = CInt(m_Pv)
    End With
  
    With .Add(Nothing, cscCfFc)
      .PropertyType = cspCheck
      .TopFromProperty = cscCfFv
      .Left = 6900
      .LeftLabel = -280
      .Name = LNGGetText(2072, vbNullString)  'FC
      .Key = K_FC
      .Value = CInt(m_Fc)
    End With
  
    With .Add(Nothing, cscCfRc)
      .PropertyType = cspCheck
      .TopFromProperty = cscCfFv
      .Left = 7650
      .LeftLabel = -280
      .Name = LNGGetText(2073, vbNullString)  'RC
      .Key = K_RC
      .Value = CInt(m_Rc)
    End With
  
    With .Add(Nothing, cscCfOc)
      .PropertyType = cspCheck
      .TopFromProperty = cscCfFv
      .Left = 8400
      .LeftLabel = -280
      .Name = LNGGetText(2074, vbNullString)  'OC
      .Key = K_OC
      .Value = CInt(m_Oc)
    End With
    
    With .Add(Nothing, c_params)
      .PropertyType = cspButton
      .TopFromProperty = cscCfFv
      .Left = 8800
      .LeftLabel = -1
      .Width = 1500
      .Name = LNGGetText(1817, vbNullString)  'Parametros
      .Key = K_PARAMS
    End With
  
    With .Add(Nothing, c_saldoInicial)
      .PropertyType = cspNumeric
      .SubType = cspDouble
      .Name = LNGGetText(2054, vbNullString)  'Saldo Incial
      .Left = 5500
      .Width = 1500
      .LeftLabel = -900
      .Key = K_SALDO_INI
      .Format = m_GeneralConfig.FormatDecImporte
      .Enabled = False
    End With
  
    With .Add(Nothing, c_saldoIniExcluido)
      .PropertyType = cspNumeric
      .SubType = cspDouble
      .Name = LNGGetText(2075, vbNullString)  'Saldo Inicial Excluido
      .Left = 8800
      .LeftLabel = -1600
      .Key = K_SALDO_INI_EXCLUIDO
      .Format = m_GeneralConfig.FormatDecImporte
      .TopFromProperty = c_saldoInicial
      .Enabled = False
    End With
  
    With .Add(Nothing, c_total)
      .PropertyType = cspNumeric
      .SubType = cspDouble
      .Name = LNGGetText(1584, vbNullString)  'Total
      .Left = 5500
      .LeftLabel = -500
      .Key = K_TOTAL
      .Format = m_GeneralConfig.FormatDecImporte
      .TopFromProperty = c_saldoInicial
      .TopToPrevious = 440
      .Enabled = False
    End With
  
    With .Add(Nothing, c_totalexcluido)
      .PropertyType = cspNumeric
      .SubType = cspDouble
      .Name = LNGGetText(2076, vbNullString)  'Total Excluido
      .Left = 8800
      .LeftLabel = -1100
      .Key = K_TOTAL_EXCLUIDO
      .Format = m_GeneralConfig.FormatDecImporte
      .TopFromProperty = c_total
      .Enabled = False
    End With
  
    With .Add(Nothing, c_load)
      .PropertyType = cspButton
      .Left = 350
      .TopFromProperty = c_total
      .Name = LNGGetText(2057, vbNullString)  'Cargar
      .LeftLabel = -1
      .Key = K_LOAD
    End With
    
    Set c = .Add(Nothing, c_Ctas)
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      .TopFromProperty = c_load
      .TopToPrevious = 440
      .Left = 350
      If Not pLoadCtas(c) Then Exit Function
      .Name = c_Ctas
      .Key = K_CUENTAS
      .GridAdd = False
      .GridEdit = False
      .GridRemove = False
      .Height = 1500
      
    End With
    
    Set c = .Add(Nothing, c_SaldoDetalle)
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      .TopFromProperty = c_load
      .TopToPrevious = 2040
      .Left = 350
      If Not pLoadSaldoDetalle(c) Then Exit Function
      .Name = c_Items
      .Key = K_SALDO_DETALLE
      .GridAdd = False
      .GridEdit = False
      .GridRemove = False
      .Height = 1500
      
    End With
    
    Set c = .Add(Nothing, c_Items)
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      .TopFromProperty = c_load
      .TopToPrevious = 3740
      .Left = 350
      If Not pLoadItems(c) Then Exit Function
      .Name = c_Items
      .Key = K_ITEMS
      .GridAdd = False
      .GridEdit = True
      .GridRemove = False
      
    End With

    With .Add(Nothing, c_crosstab)
      .PropertyType = cspButton
      .Width = 2500
      .Name = LNGGetText(4847, vbNullString)  'Cargar Vista por Semana
      .Key = K_CROSSTAB
      .TabIndex = 2
      .LeftLabel = -1
    End With

    Set c = .Add(Nothing, c_grid_crosstab)
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      .Name = c_grid_crosstab
      .TopFromProperty = c_crosstab
      .TopToPrevious = 440
      .Key = K_ITEMS_CROSSTAB
      .GridAdd = False
      .GridEdit = False
      .GridRemove = False
      .TabIndex = 2
      
    End With

    With .Add(Nothing, cscCfDescrip)
      .PropertyType = cspText
      .SubType = cspMemo
      .Left = 400
      .LeftLabel = -1
      .Name = C_strDescrip
      .Width = 9800
      .Height = 2000
      .Size = 5000
      .Key = K_DESCRIP
      .Value = m_Descrip
      .TabIndex = 1
    End With

  End With
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

Private Function pLoadSaldoDetalle(ByRef Propiedad As cIABMProperty) As Boolean
  
  With Propiedad.Grid
  
    .Columns.Clear
    .Rows.Clear
    
    With .Columns
  
      With .Add(Nothing, cscCfiId)
        .Visible = False
        .Key = KI_CFI_ID
      End With
      
      With .Add(Nothing, c_excluir)
        .Name = LNGGetText(2077, vbNullString)  'Excluir
        .PropertyType = cspCheck
        .Key = KI_EXCLUIR
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1569, vbNullString)  'Fecha
        .PropertyType = cspDate
        .Key = KI_FECHA
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1063, vbNullString)  'Tipo Doc.
        .PropertyType = cspHelp
        .Key = KI_TDOC
      End With
      
      With .Add(Nothing, c_comprobante)
        .Name = LNGGetText(1610, vbNullString)  'Comprobante
        .PropertyType = cspHelp
        .Key = KI_COMP
      End With
      
      With .Add(Nothing, c_tercero)
        .Name = LNGGetText(2078, vbNullString)  'Tercero
        .PropertyType = cspText
        .Key = KI_TERCERO
      End With
      
      With .Add(Nothing, c_key_debe)
        .Name = LNGGetText(1904, vbNullString)  'Debe
        .Format = m_GeneralConfig.FormatDecImporte
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Width = 1200
        .Key = KI_DEBE
      End With
      
      With .Add(Nothing, c_key_haber)
        .Name = LNGGetText(1905, vbNullString)  'Haber
        .Format = m_GeneralConfig.FormatDecImporte
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Width = 1200
        .Key = KI_HABER
      End With
      
      With .Add(Nothing)
        .Name = C_strDescrip
        .PropertyType = cspText
        .SubType = cspTextButtonEx
        .Width = 2300
        .Key = KI_DESCRIP
      End With
    
    End With
  End With
  pLoadSaldoDetalle = True
End Function

Private Function pLoadItems(ByRef Propiedad As cIABMProperty) As Boolean
  
  With Propiedad.Grid
  
    .Columns.Clear
    .Rows.Clear
    
    With .Columns
  
      With .Add(Nothing, cscCfiId)
        .Visible = False
        .Key = KI_CFI_ID
      End With
      
      With .Add(Nothing, c_excluir)
        .Name = LNGGetText(2077, vbNullString)  'Excluir
        .PropertyType = cspCheck
        .Key = KI_EXCLUIR
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1569, vbNullString)  'Fecha
        .PropertyType = cspDate
        .Key = KI_FECHA
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1063, vbNullString)  'Tipo Doc.
        .PropertyType = cspHelp
        .Key = KI_TDOC
      End With
      
      With .Add(Nothing, c_comprobante)
        .Name = LNGGetText(1610, vbNullString)  'Comprobante
        .PropertyType = cspHelp
        .Key = KI_COMP
      End With
      
      With .Add(Nothing, c_tercero)
        .Name = LNGGetText(2078, vbNullString)  'Tercero
        .PropertyType = cspText
        .Key = KI_TERCERO
      End With
      
      With .Add(Nothing, c_key_debe)
        .Name = LNGGetText(1904, vbNullString)  'Debe
        .Format = m_GeneralConfig.FormatDecImporte
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Width = 1200
        .Key = KI_DEBE
      End With
      
      With .Add(Nothing, c_key_haber)
        .Name = LNGGetText(1905, vbNullString)  'Haber
        .Format = m_GeneralConfig.FormatDecImporte
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Width = 1200
        .Key = KI_HABER
      End With
      
      With .Add(Nothing, c_saldo)
        .Name = LNGGetText(2079, vbNullString)  'Saldo
        .Format = m_GeneralConfig.FormatDecImporte
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Width = 1200
        .Key = KI_SALDO
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(2080, vbNullString)  'Fecha Real
        .PropertyType = cspDate
        .Key = KI_FECHA_REAL2
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(2081, vbNullString)  'Importe Real
        .Format = m_GeneralConfig.FormatDecImporte
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Width = 1200
        .Key = KI_IMPORTE_REAL2
      End With
      
      With .Add(Nothing, c_Origen)
        .Name = LNGGetText(1963, vbNullString)  'Moneda Origen
        .Format = m_GeneralConfig.FormatDecImporte
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Width = 1500
        .Visible = False
        .Key = KI_ORIGEN
      End With
      
      With .Add(Nothing)
        .Name = C_strDescrip
        .PropertyType = cspText
        .SubType = cspTextButtonEx
        .Width = 2300
        .Key = KI_DESCRIP
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1057, vbNullString)  'Centro de Costo
        .Width = 1800
        .Key = KI_CCOS_ID
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(2059, vbNullString)  'Nr. Cheque
        .Width = 1000
        .Key = KICH_CHEQUE
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(2058, vbNullString)  'Cheque
        .Width = 1000
        .Enabled = False
        .Key = KICH_CHEQ_ID
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(2060, vbNullString)  'Cobranza
        .Width = 520
        .Key = KICH_COBZ_ID
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(2061, vbNullString)  'Orden Pago
        .Width = 520
        .Key = KICH_OPG_ID
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(2062, vbNullString)  'Mov. Fondo
        .Width = 520
        .Key = KICH_MF_ID
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1267, vbNullString)  'Cuenta
        .Width = 520
        .Key = KICH_CUE_ID
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(2063, vbNullString)  'Mon
        .Width = 520
        .Key = KICH_MON_ID
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1901, vbNullString)  'Origen
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Format = m_GeneralConfig.FormatDecImporte
        .Width = 920
        .Key = KICH_IMPORTEORIGEN
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1228, vbNullString)  'Importe
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Format = m_GeneralConfig.FormatDecImporte
        .Width = 920
        .Key = KICH_IMPORTE
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(2064, vbNullString)  'Chequera
        .Width = 1000
        .Key = KICH_CHEQUERA
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(2065, vbNullString)  'Depositar el
        .Width = 970
        .Key = KICH_FECHACOBRO
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1634, vbNullString)  'Vto.
        .Width = 970
        .Key = KICH_FECHAVTO
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1083, vbNullString)  'Clering
        .Width = 800
        .Key = KICH_CLE_ID
      End With
      
      With .Add(Nothing)
        .Name = C_strDescrip
        .Width = 1600
        .Key = KICH_DESCRIP
      End With
    
      With .Add(Nothing, c_changed)
        .Visible = False
        .Key = KI_CHANGED
      End With
    
      With .Add(Nothing)
        .Visible = False
        .Key = KI_DH
      End With
    
      With .Add(Nothing)
        .Visible = False
        .Key = KI_FECHA_REAL
      End With
    
      With .Add(Nothing)
        .Visible = False
        .Key = KI_IMPORTE_REAL
      End With
    
    End With
  End With
  pLoadItems = True
End Function

Private Function pLoadCtas(ByRef Propiedad As cIABMProperty) As Boolean
  
  With Propiedad.Grid
  
    .Columns.Clear
    .Rows.Clear
    
    With .Columns
  
      With .Add(Nothing, cscCfpId)
        .Visible = False
        .Key = KI_CFP_ID
      End With

' Pesos

      With .Add(Nothing)
        .Name = LNGGetText(1267, vbNullString)  'Cuenta
        .PropertyType = cspText
        .Width = 1800
        .Key = KI_CUENTA
      End With
      
      With .Add(Nothing, c_key_debe)
        .Name = LNGGetText(1904, vbNullString)  'Debe
        .Format = m_GeneralConfig.FormatDecImporte
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Width = 1200
        .Key = KI_DEBE
      End With
      
      With .Add(Nothing, c_key_haber)
        .Name = LNGGetText(1905, vbNullString)  'Haber
        .Format = m_GeneralConfig.FormatDecImporte
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Width = 1200
        .Key = KI_HABER
      End With
      
      With .Add(Nothing, c_saldo)
        .Name = LNGGetText(2079, vbNullString)  'Saldo
        .Format = m_GeneralConfig.FormatDecImporte
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Width = 1200
        .Key = KI_SALDO
      End With
    
' Dolares

      With .Add(Nothing, c_key_debeex)
        .Name = LNGGetText(4832, vbNullString)  'Debe Orig.
        .Format = m_GeneralConfig.FormatDecImporte
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Width = 1200
        .Key = KI_DEBE_EX
      End With
      
      With .Add(Nothing, c_key_haberex)
        .Name = LNGGetText(4833, vbNullString)  'Haber Orig.
        .Format = m_GeneralConfig.FormatDecImporte
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Width = 1200
        .Key = KI_HABER_EX
      End With
      
      With .Add(Nothing, c_saldoex)
        .Name = LNGGetText(4831, vbNullString)  'Saldo Orig.
        .Format = m_GeneralConfig.FormatDecImporte
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Width = 1200
        .Key = KI_SALDO_EX
      End With
    
    
    End With
  End With
  pLoadCtas = True
End Function

' funciones friend
' funciones privadas
Private Function Load(ByVal Id As Long) As Boolean
  Dim sqlstmt As String
  
  sqlstmt = "sp_DocCashFlowGet " & Id
  
  Dim rs As ADODB.Recordset
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "Load", "cCashFlow") Then Exit Function
  
  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.Fields, cscCfId)
    m_Nombre = gDB.ValField(rs.Fields, cscCfNombre)
    m_Fecha = gDB.ValField(rs.Fields, cscCfFecha)
    m_Descrip = gDB.ValField(rs.Fields, cscCfDescrip)
    m_Fechadesde = gDB.ValField(rs.Fields, cscCfFechadesde)
    m_Fechahasta = gDB.ValField(rs.Fields, cscCfFechahasta)
    m_Fechacheque = gDB.ValField(rs.Fields, cscCfFechacheque)
    m_Fv = gDB.ValField(rs.Fields, cscCfFv)
    m_Rv = gDB.ValField(rs.Fields, cscCfRv)
    m_Pv = gDB.ValField(rs.Fields, cscCfPv)
    m_Fc = gDB.ValField(rs.Fields, cscCfFc)
    m_Rc = gDB.ValField(rs.Fields, cscCfRc)
    m_Oc = gDB.ValField(rs.Fields, cscCfOc)
    m_cue_id = gDB.ValField(rs.Fields, cscCueId)
    m_cuenta = gDB.ValField(rs.Fields, cscCueNombre)

    If Not pLoadParams() Then Exit Function

  Else
    
    CollClear m_Params
    
    m_Id = csNO_ID
    m_Nombre = LNGGetText(2082, vbNullString)  'Flujo de Caja
    m_Fecha = Date
    m_Descrip = vbNullString
    m_Fechadesde = Date
    m_Fechahasta = DateAdd("yyyy", 1, Date)
    m_Fechacheque = True
    m_Fv = True
    m_Rv = True
    m_Pv = True
    m_Fc = True
    m_Rc = True
    m_Oc = True
    m_cue_id = csNO_ID
    m_cuenta = vbNullString

  End If

  Load = True

End Function

Private Function pSave() As Boolean
  Dim register As cRegister
  Set register = New cRegister
  register.fieldId = cscCfId
  register.Table = csTCashFlow
  If m_Copy Then
    register.Id = csNew
  Else
    register.Id = m_Id
  End If
  Dim IProperty As cIABMProperty
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_NOMBRE
          register.Fields.Add2 cscCfNombre, .Value, csText
        Case K_FECHA
          register.Fields.Add2 cscCfFecha, .Value, csDate
        Case K_DESCRIP
          register.Fields.Add2 cscCfDescrip, .Value, csText
        Case K_FECHADESDE
          register.Fields.Add2 cscCfFechadesde, .Value, csDate
        Case K_FECHAHASTA
          register.Fields.Add2 cscCfFechahasta, .Value, csDate
        Case K_FECHACHEQUE
          register.Fields.Add2 cscCfFechacheque, .Value, csBoolean
        Case K_FV
          register.Fields.Add2 cscCfFv, .Value, csBoolean
        Case K_RV
          register.Fields.Add2 cscCfRv, .Value, csBoolean
        Case K_PV
          register.Fields.Add2 cscCfPv, .Value, csBoolean
        Case K_FC
          register.Fields.Add2 cscCfFc, .Value, csBoolean
        Case K_RC
          register.Fields.Add2 cscCfRc, .Value, csBoolean
        Case K_OC
          register.Fields.Add2 cscCfOc, .Value, csBoolean
        Case K_CUE_ID
          register.Fields.Add2 cscCueId, .HelpId, csId

      End Select
    End With
  Next
  
  register.Fields.HaveLastUpdate = True
  register.Fields.HaveWhoModify = True
  
  If Not register.BeginTrans(gDB) Then Exit Function
  
  If Not gDB.Save(register, , _
                  "cIABMClient_Save", _
                  "cCashFlow", _
                  c_ErrorSave) Then Exit Function
                  
  If Not pSaveItems(False, register.Id) Then Exit Function
  
  register.CommitTrans
  
  If m_ParamsChanged Then
    If Not pSaveParams(register.Id) Then Exit Function
  End If
  
  m_Copy = False
  pSave = Load(register.Id)

End Function

Private Function pSaveItems(ByVal bCopy As Boolean, _
                            ByVal cf_id As Long) As Boolean
  Dim Row      As cIABMGridRow
  Dim sqlstmt  As String
  
  For Each Row In pGetItems().Grid.Rows

    Dim oRow As cABMGridRow
    Dim oCell As cABMGridRowValue
    
    Set oCell = pGetItems().Grid.Rows.Item(2).Item(2)
    

    If Val(Row.Item(c_changed).Value) Then
      
      If Not pSaveCashFlowItem(Row, bCopy, cf_id) Then Exit Function
      
    End If

  Next

  m_Changed = False

  pSaveItems = True
End Function

Private Function pSaveCashFlowItem(ByRef Row As cIABMGridRow, _
                                   ByVal bCopy As Boolean, _
                                   ByVal cf_id As Long) As Boolean
  
  Dim register As cRegister
  Dim Cell     As cIABMGridCellValue
  
  Set register = New cRegister
  register.fieldId = cscCfiId
  register.Table = csTCashFlowItem
  
  Dim bDelete         As Boolean
  Dim importe         As Double
  Dim fecha           As Date
  Dim importe_real    As Double
  Dim fecha_real      As Date
  Dim cfi_id          As Long
  
  bDelete = True
  
  With register.Fields
  
    For Each Cell In Row
    
      Select Case Cell.Key
      
        Case KI_CFI_ID
          If bCopy Then
            cfi_id = csNew
          Else
            cfi_id = Val(Cell.Value)
          End If
          register.Id = cfi_id
      
        Case KI_FECHA
          If IsDate(Cell.Value) Then
            fecha = Cell.Value
          Else
            fecha = csNoDate
          End If
          .Add2 cscCfiFecha, fecha, csDate
        
        Case KI_DEBE
          If Val(pCell(Row, KI_DH).Value) = c_debe Then
            importe = Cell.Value
            .Add2 cscCfiImporte, importe, csCurrency
            .Add2 cscCfiTipo, c_debe, csInteger
          End If
        
        Case KI_HABER
          If Val(pCell(Row, KI_DH).Value) = c_haber Then
            importe = Cell.Value
            .Add2 cscCfiImporte, importe, csCurrency
            .Add2 cscCfiTipo, c_haber, csInteger
          End If
        
        Case KI_EXCLUIR
          If Cell.Id Then
            bDelete = False
          End If
          .Add2 cscCfiExcluir, Cell.Id, csBoolean
        
        Case KI_TDOC
          .Add2 cscDoctId, Cell.Id, csLong
        
        Case KI_COMP
          .Add2 cscCompId, Cell.Id, csLong

        Case KI_FECHA_REAL
          If IsDate(Cell.Value) Then
            fecha_real = Cell.Value
          End If
          
        Case KI_IMPORTE_REAL
          importe_real = Val(Cell.Value)
      End Select
    
    Next
  
    .Add2 cscCfId, cf_id, csId
  
  End With
  
  If importe_real <> importe Then
    bDelete = False
  End If

  If fecha_real <> fecha Then
    bDelete = False
  End If
  
  If bDelete And Not bCopy Then
  
    Dim sqlstmt As String
    sqlstmt = "delete CashFlowItem where cfi_id = " & cfi_id
    If Not gDB.Execute(sqlstmt) Then Exit Function
  
  Else
    If Not gDB.Save(register, , _
                    "cIABMClient_Save", _
                    "cCashFlowItem", _
                    c_ErrorSave) Then
      Exit Function
    End If
  End If
  
  pSaveCashFlowItem = True
End Function

Private Function pGetCuenta() As Long
  pGetCuenta = m_ObjAbm.Properties.Item(cscCueId).HelpId
End Function

Private Function pGetCuentas() As cIABMProperty
  Set pGetCuentas = m_ObjAbm.Properties.Item(c_Ctas)
End Function

Private Function pLoadCuentaSaldos() As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
    
  sqlstmt = "sp_CashFlowGetCuentaSaldo " & m_Id & "," _
                                         & gDB.sqlDate(pGetDesde())

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadItems", C_Module) Then Exit Function
  
  Dim iProp   As cIABMProperty
  Dim AbmObj  As cABMGeneric
  
  Set AbmObj = m_ObjAbm
  Set iProp = pGetCuentas()

  With iProp.Grid
  
    .Rows.Clear
    
    With .Rows
    
      While Not rs.EOF
                
        With .Add(Nothing)
        
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscCfpId)
            .Key = KI_CFP_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscCueNombre)
            .Id = gDB.ValField(rs.Fields, cscCueId)
            .Key = KI_CUENTA
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, "Debe")
            .Key = KI_DEBE
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, "Haber")
            .Key = KI_HABER
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, "Saldo")
            .Key = KI_SALDO
          End With
        
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, "DebeEx")
            .Key = KI_DEBE_EX
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, "HaberEx")
            .Key = KI_HABER_EX
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, "SaldoEx")
            .Key = KI_SALDO_EX
          End With
        End With
        
        rs.MoveNext
      Wend
    End With
  End With
  
  AbmObj.ShowValue iProp, True
  
  pLoadCuentaSaldos = True
End Function

Private Function pLoadSaldoDetalleXCuenta() As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_CashFlowGetSaldoInicialDetalle " & m_Id & "," & _
                    pGetCuenta() & "," & _
                    gDB.sqlDate(pGetDesde()) & "," & _
                    pGetFechaCheque() & "," & _
                    pGetFv() & "," & _
                    pGetRv() & "," & _
                    pGetPv() & "," & _
                    pGetFc() & "," & _
                    pGetRc() & "," & _
                    pGetOc()

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadItems", C_Module) Then Exit Function
  
  Dim iProp As cIABMProperty
  
'  Dim Pendiente     As Double
'  Dim Conciliado    As Double
'  Dim Rechazado     As Double
'  Dim Total         As Double
'  Dim TotalExcluido As Double
  Dim Debe          As Double
  Dim Haber         As Double
'  Dim importe_real  As Double
'  Dim fecha_real    As Date
  Dim Row           As cIABMGridRow
  Dim oRow          As cABMGridRow
  Dim excluir       As Boolean
  Dim oFormat       As cABMGridCellFormat
  Dim AbmObj        As cABMGeneric
  
  Set AbmObj = m_ObjAbm
      
  Set iProp = pGetSaldoDetalle()
  
  Dim fecha       As Date
'  Dim lastFecha   As Date
'  Dim total_debe  As Double
'  Dim total_haber As Double
'
'  Dim total_debe2  As Double
'  Dim total_haber2 As Double

'  lastFecha = csNoDate
  
  With iProp.Grid
  
    .Rows.Clear
    
    With .Rows
    
      While Not rs.EOF
      
        fecha = gDB.ValField(rs.Fields, "Fecha")
'        If lastFecha <> fecha Then
'          If lastFecha <> csNoDate Then
'            pAddRowDate .Add(Nothing), _
'                        csNoDate, _
'                        total_debe, _
'                        total_haber, _
'                        LNGGetText(2085, vbNullString, lastFecha), _
'                        c_id_row_fecha_total, _
'                        Total
'
'                        'Total del " & lastFecha
'
'          End If
'          lastFecha = fecha
'          total_debe = 0
'          total_haber = 0
'          pAddRowDate .Add(Nothing), _
'                      fecha, _
'                      total_debe, _
'                      total_haber, _
'                      vbNullString, _
'                      c_id_row_fecha, _
'                      Total
'        End If
      
        Set Row = .Add(Nothing)
        Set oRow = Row
        
        With Row
        
          With .Add(Nothing, cscCfiId)
            .Value = gDB.ValField(rs.Fields, cscCfiId)
            .Key = KI_CFI_ID
          End With
          
          excluir = gDB.ValField(rs.Fields, "excluir")
          With .Add(Nothing, c_excluir)
            .Id = excluir
            .Key = KI_EXCLUIR
          End With
          
          With .Add(Nothing)
            .Value = fecha
            .Key = KI_FECHA
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, "Tipo Doc.")
            .Id = gDB.ValField(rs.Fields, cscDoctId)
            .Key = KI_TDOC
          End With
          
          With .Add(Nothing, c_comprobante)
            .Value = gDB.ValField(rs.Fields, "Comprobante")
            .Id = gDB.ValField(rs.Fields, cscCompId)
            .Key = KI_COMP
            Set .Format = New cABMGridCellFormat
          End With
          
          With .Add(Nothing, c_tercero)
            .Value = gDB.ValField(rs.Fields, "Tercero")
            .Key = KI_TERCERO
            Set .Format = New cABMGridCellFormat
          End With
          
          Debe = gDB.ValField(rs.Fields, "Debe")
          With .Add(Nothing, c_key_debe)
            .Value = Debe
            .Key = KI_DEBE
            Set .Format = New cABMGridCellFormat
            Set oFormat = .Format
            oFormat.Align = 2 'DT_RIGHT
          End With
          
          Haber = gDB.ValField(rs.Fields, "Haber")
          With .Add(Nothing, c_key_haber)
            .Value = Haber
            .Key = KI_HABER
            Set .Format = New cABMGridCellFormat
            Set oFormat = .Format
            oFormat.Align = 2 'DT_RIGHT
          End With
          
'          If Not excluir Then
'            total_debe = total_debe + Debe
'            total_haber = total_haber + Haber
'            total_debe2 = total_debe2 + Debe
'            total_haber2 = total_haber2 + Haber
'            Total = Total + Debe - Haber
'          Else
'            TotalExcluido = TotalExcluido + Debe - Haber
'          End If
'
'          With .Add(Nothing, c_saldo)
'            .Value = Total
'            .Key = KI_SALDO
'          End With
          
'          fecha_real = gDB.ValField(rs.Fields, "fecha_real")
'          With .Add(Nothing)
'            If fecha_real <> fecha Then
'              .Value = fecha_real
'            End If
'            .Key = KI_FECHA_REAL2
'          End With
'
'          importe_real = gDB.ValField(rs.Fields, "importe_real")
'          With .Add(Nothing)
'            If (importe_real <> Debe And Debe <> 0) Or _
'               (importe_real <> Haber And Haber <> 0) Then
'
'              .Value = importe_real
'            End If
'            .Key = KI_IMPORTE_REAL2
'          End With
'
'          With .Add(Nothing)
'            .Value = gDB.ValField(rs.Fields, "Origen")
'            .Key = KI_ORIGEN
'          End With
'
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, "Descrip")
            .Key = KI_DESCRIP
          End With
'
'          With .Add(Nothing)
'            .Value = gDB.ValField(rs.Fields, cscCcosNombre)
'            .Key = KI_CCOS_ID
'          End With
'
'          With .Add(Nothing)
'            .Value = gDB.ValField(rs.Fields, cscChqCodigo)
'            .Key = KICH_CHEQUERA
'          End With
'
'          With .Add(Nothing)
'            .Value = gDB.ValField(rs.Fields, cscCheqNumeroDoc)
'            .Key = KICH_CHEQUE
'          End With
'
'          With .Add(Nothing)
'            .Value = gDB.ValField(rs.Fields, cscCobzNrodoc)
'            .Key = KICH_COBZ_ID
'          End With
'
'          With .Add(Nothing)
'            .Value = gDB.ValField(rs.Fields, cscOpgNrodoc)
'            .Key = KICH_OPG_ID
'          End With
'
'          With .Add(Nothing)
'            .Value = gDB.ValField(rs.Fields, cscMfNrodoc)
'            .Key = KICH_MF_ID
'          End With
'
'          With .Add(Nothing)
'            .Value = gDB.ValField(rs.Fields, cscCueNombre)
'            .Key = KICH_CUE_ID
'          End With
'
'          With .Add(Nothing)
'            .Value = gDB.ValField(rs.Fields, cscMonNombre)
'            .Key = KICH_MON_ID
'          End With
'
'          With .Add(Nothing)
'            .Value = gDB.ValField(rs.Fields, cscCheqImporteOrigen)
'            .Key = KICH_IMPORTEORIGEN
'          End With
'
'          With .Add(Nothing)
'            .Value = gDB.ValField(rs.Fields, cscCheqImporte)
'            .Key = KICH_IMPORTE
'          End With
'
'          With .Add(Nothing)
'            .Value = gDB.ValField(rs.Fields, cscCheqNumero)
'            '.ID = gDB.ValField(rs.Fields, cscCheqId)
'            .Key = KICH_CHEQ_ID
'          End With
'
'          With .Add(Nothing)
'            .Value = gDB.ValField(rs.Fields, cscCheqFechaCobro)
'            .Key = KICH_FECHACOBRO
'          End With
'
'          With .Add(Nothing)
'            .Value = gDB.ValField(rs.Fields, cscCheqFechaVto)
'            .Key = KICH_FECHAVTO
'          End With
'
'          With .Add(Nothing)
'            .Value = gDB.ValField(rs.Fields, cscCleNombre)
'            .Key = KICH_CLE_ID
'          End With
'
'          With .Add(Nothing)
'            .Value = gDB.ValField(rs.Fields, cscCheqDescrip)
'            .Key = KICH_DESCRIP
'          End With
'
'          With .Add(Nothing, c_changed)
'            .Value = 0
'            .Key = KI_CHANGED
'          End With
'
'          With .Add(Nothing)
'            If Debe > 0 Then
'              .Value = c_debe
'            ElseIf Haber > 0 Then
'              .Value = c_haber
'            End If
'            .Key = KI_DH
'          End With
'
'          With .Add(Nothing)
'            .Value = fecha_real
'            .Key = KI_FECHA_REAL
'          End With
'
'          With .Add(Nothing)
'            .Value = importe_real
'            .Key = KI_IMPORTE_REAL
'          End With
'
        End With
'
'        If excluir Then
'          Set oFormat = Row.Item(c_comprobante).Format
'          oFormat.Strike = True
'          Set oFormat = Row.Item(c_tercero).Format
'          oFormat.Strike = True
'          Set oFormat = Row.Item(c_key_debe).Format
'          oFormat.Strike = True
'          oFormat.Align = 2 'DT_RIGHT
'          Set oFormat = Row.Item(c_key_haber).Format
'          oFormat.Strike = True
'          oFormat.Align = 2 'DT_RIGHT
'        End If
'
'        If Total < 0 Then
'          oRow.ForeColor = vbRed
'        End If
        
        rs.MoveNext
      Wend
  
'      If lastFecha <> csNoDate Then
'        pAddRowDate .Add(Nothing), _
'                    csNoDate, _
'                    total_debe, _
'                    total_haber, _
'                    LNGGetText(2085, vbNullString, lastFecha), _
'                    c_id_row_fecha_total, _
'                    Total
'
'                    'Total del " & lastFecha
'
'        pAddRowDate .Add(Nothing), _
'                    csNoDate, _
'                    total_debe2, _
'                    total_haber2, _
'                    LNGGetText(2086, vbNullString, pGetDesde(), pGetHasta), _
'                    c_id_row_total_periodo, _
'                    Total
'      End If
    
    End With
  
'    Dim oRows As cABMGridRows
'    Set oRows = .Rows
'
'    oRows.HaveKey = True
  
  End With
  
  AbmObj.ShowValue iProp, True
  
'  Set iProp = pGetTotalExcluido()
'  iProp.Value = TotalExcluido
'  AbmObj.ShowValue iProp
'
'  Set iProp = pGetTotal()
'  iProp.Value = Total
'  AbmObj.ShowValue iProp
  
  pLoadSaldoDetalleXCuenta = True
End Function

Private Function pLoadItemsXCuenta() As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_CashFlowGet " & m_Id & "," & _
                    pGetCuenta() & "," & _
                    gDB.sqlDate(pGetDesde()) & "," & _
                    gDB.sqlDate(pGetHasta()) & "," & _
                    pGetFechaCheque() & "," & _
                    pGetFv() & "," & _
                    pGetRv() & "," & _
                    pGetPv() & "," & _
                    pGetFc() & "," & _
                    pGetRc() & "," & _
                    pGetOc()

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadItems", C_Module) Then Exit Function
  
  Dim iProp As cIABMProperty
  
  Dim Pendiente     As Double
  Dim Conciliado    As Double
  Dim Rechazado     As Double
  Dim Total         As Double
  Dim TotalExcluido As Double
  Dim Debe          As Double
  Dim Haber         As Double
  Dim importe_real  As Double
  Dim fecha_real    As Date
  Dim Row           As cIABMGridRow
  Dim oRow          As cABMGridRow
  Dim excluir       As Boolean
  Dim oFormat       As cABMGridCellFormat
  Dim AbmObj        As cABMGeneric
  
  Set AbmObj = m_ObjAbm
  
  If Not rs.EOF Then
    Total = gDB.ValField(rs.Fields, "saldo_inicial")
    TotalExcluido = gDB.ValField(rs.Fields, "saldo_ini_excluido")
  End If
  
  Set iProp = pGetSaldoIni()
  iProp.Value = Total
  AbmObj.ShowValue iProp
  
  Set iProp = pGetSaldoIniExcluido()
  iProp.Value = TotalExcluido
  AbmObj.ShowValue iProp
  
  Set iProp = pGetItems()
  
  Set rs = rs.NextRecordset
  
  Dim fecha       As Date
  Dim lastFecha   As Date
  Dim total_debe  As Double
  Dim total_haber As Double

  Dim total_debe2  As Double
  Dim total_haber2 As Double

  lastFecha = csNoDate
  
  With iProp.Grid
  
    .Rows.Clear
    
    With .Rows
    
      While Not rs.EOF
      
        fecha = gDB.ValField(rs.Fields, "Fecha")
        If lastFecha <> fecha Then
          If lastFecha <> csNoDate Then
            pAddRowDate .Add(Nothing), _
                        csNoDate, _
                        total_debe, _
                        total_haber, _
                        LNGGetText(2085, vbNullString, lastFecha), _
                        c_id_row_fecha_total, _
                        Total
                        
                        'Total del " & lastFecha
                        
          End If
          lastFecha = fecha
          total_debe = 0
          total_haber = 0
          pAddRowDate .Add(Nothing), _
                      fecha, _
                      total_debe, _
                      total_haber, _
                      vbNullString, _
                      c_id_row_fecha, _
                      Total
        End If
      
        Set Row = .Add(Nothing)
        Set oRow = Row
        
        With Row
        
          With .Add(Nothing, cscCfiId)
            .Value = gDB.ValField(rs.Fields, cscCfiId)
            .Key = KI_CFI_ID
          End With
          
          excluir = gDB.ValField(rs.Fields, "excluir")
          With .Add(Nothing, c_excluir)
            .Id = excluir
            .Key = KI_EXCLUIR
          End With
          
          With .Add(Nothing)
            .Value = fecha
            .Key = KI_FECHA
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, "Tipo Doc.")
            .Id = gDB.ValField(rs.Fields, cscDoctId)
            .Key = KI_TDOC
          End With
          
          With .Add(Nothing, c_comprobante)
            .Value = gDB.ValField(rs.Fields, "Comprobante")
            .Id = gDB.ValField(rs.Fields, cscCompId)
            .Key = KI_COMP
            Set .Format = New cABMGridCellFormat
          End With
          
          With .Add(Nothing, c_tercero)
            .Value = gDB.ValField(rs.Fields, "Tercero")
            .Key = KI_TERCERO
            Set .Format = New cABMGridCellFormat
          End With
          
          Debe = gDB.ValField(rs.Fields, "Debe")
          With .Add(Nothing, c_key_debe)
            .Value = Debe
            .Key = KI_DEBE
            Set .Format = New cABMGridCellFormat
            Set oFormat = .Format
            oFormat.Align = 2 'DT_RIGHT
          End With
          
          Haber = gDB.ValField(rs.Fields, "Haber")
          With .Add(Nothing, c_key_haber)
            .Value = Haber
            .Key = KI_HABER
            Set .Format = New cABMGridCellFormat
            Set oFormat = .Format
            oFormat.Align = 2 'DT_RIGHT
          End With
          
          If Not excluir Then
            total_debe = total_debe + Debe
            total_haber = total_haber + Haber
            total_debe2 = total_debe2 + Debe
            total_haber2 = total_haber2 + Haber
            Total = Total + Debe - Haber
          Else
            TotalExcluido = TotalExcluido + Debe - Haber
          End If
          
          With .Add(Nothing, c_saldo)
            .Value = Total
            .Key = KI_SALDO
          End With
          
          fecha_real = gDB.ValField(rs.Fields, "fecha_real")
          With .Add(Nothing)
            If fecha_real <> fecha Then
              .Value = fecha_real
            End If
            .Key = KI_FECHA_REAL2
          End With
          
          importe_real = gDB.ValField(rs.Fields, "importe_real")
          With .Add(Nothing)
            If (importe_real <> Debe And Debe <> 0) Or _
               (importe_real <> Haber And Haber <> 0) Then
              
              .Value = importe_real
            End If
            .Key = KI_IMPORTE_REAL2
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, "Origen")
            .Key = KI_ORIGEN
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, "Descrip")
            .Key = KI_DESCRIP
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscCcosNombre)
            .Key = KI_CCOS_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscChqCodigo)
            .Key = KICH_CHEQUERA
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscCheqNumeroDoc)
            .Key = KICH_CHEQUE
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscCobzNrodoc)
            .Key = KICH_COBZ_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscOpgNrodoc)
            .Key = KICH_OPG_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscMfNrodoc)
            .Key = KICH_MF_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscCueNombre)
            .Key = KICH_CUE_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscMonNombre)
            .Key = KICH_MON_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscCheqImporteOrigen)
            .Key = KICH_IMPORTEORIGEN
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscCheqImporte)
            .Key = KICH_IMPORTE
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscCheqNumero)
            '.ID = gDB.ValField(rs.Fields, cscCheqId)
            .Key = KICH_CHEQ_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscCheqFechaCobro)
            .Key = KICH_FECHACOBRO
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscCheqFechaVto)
            .Key = KICH_FECHAVTO
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscCleNombre)
            .Key = KICH_CLE_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscCheqDescrip)
            .Key = KICH_DESCRIP
          End With
          
          With .Add(Nothing, c_changed)
            .Value = 0
            .Key = KI_CHANGED
          End With
        
          With .Add(Nothing)
            If Abs(Debe) > 0 Then
              .Value = c_debe
            ElseIf Abs(Haber) > 0 Then
              .Value = c_haber
            End If
            .Key = KI_DH
          End With
          
          With .Add(Nothing)
            .Value = fecha_real
            .Key = KI_FECHA_REAL
          End With
          
          With .Add(Nothing)
            .Value = importe_real
            .Key = KI_IMPORTE_REAL
          End With
          
        End With
        
        If excluir Then
          Set oFormat = Row.Item(c_comprobante).Format
          oFormat.Strike = True
          Set oFormat = Row.Item(c_tercero).Format
          oFormat.Strike = True
          Set oFormat = Row.Item(c_key_debe).Format
          oFormat.Strike = True
          oFormat.Align = 2 'DT_RIGHT
          Set oFormat = Row.Item(c_key_haber).Format
          oFormat.Strike = True
          oFormat.Align = 2 'DT_RIGHT
        End If
        
        If Total < 0 Then
          oRow.ForeColor = vbRed
        End If
        
        rs.MoveNext
      Wend
  
      If lastFecha <> csNoDate Then
        pAddRowDate .Add(Nothing), _
                    csNoDate, _
                    total_debe, _
                    total_haber, _
                    LNGGetText(2085, vbNullString, lastFecha), _
                    c_id_row_fecha_total, _
                    Total
                    
                    'Total del " & lastFecha

        pAddRowDate .Add(Nothing), _
                    csNoDate, _
                    total_debe2, _
                    total_haber2, _
                    LNGGetText(2086, vbNullString, pGetDesde(), pGetHasta), _
                    c_id_row_total_periodo, _
                    Total
      End If
    
    End With
  
    Dim oRows As cABMGridRows
    Set oRows = .Rows
    
    oRows.HaveKey = True
  
  End With
  
  
  AbmObj.ShowValue iProp, True
  
  Set iProp = pGetTotalExcluido()
  iProp.Value = TotalExcluido
  AbmObj.ShowValue iProp
  
  Set iProp = pGetTotal()
  iProp.Value = Total
  AbmObj.ShowValue iProp
  
  pLoadItemsXCuenta = True
End Function

Private Sub pAddRowDate(ByRef Row As cIABMGridRow, _
                        ByVal fecha As Date, _
                        ByVal total_debe As Double, _
                        ByVal total_haber As Double, _
                        ByVal descrip As String, _
                        ByVal id_row As Long, _
                        ByVal Saldo As Double)
                        
  Dim oRow      As cABMGridRow
  Dim oFormat   As cABMGridCellFormat
  
  Set oRow = Row

  With Row
  
    With .Add(Nothing, cscCfiId)
      .Key = KI_CFI_ID
      .Value = id_row
    End With
    
    With .Add(Nothing, c_excluir)
      .Value = 0
      .Key = KI_EXCLUIR
    End With
    
    With .Add(Nothing)
      If fecha <> csNoDate Then
        .Value = fecha
      End If
      .Key = KI_FECHA
    End With
    
    With .Add(Nothing)
      .Key = KI_TDOC
    End With
    
    With .Add(Nothing, c_comprobante)
      .Key = KI_COMP
    End With
    
    With .Add(Nothing, c_tercero)
      If descrip <> vbNullString Then
        .Value = descrip
      End If
      .Key = KI_TERCERO
      Set .Format = New cABMGridCellFormat
    End With
    
    With .Add(Nothing, c_key_debe)
      If total_debe Or total_haber Then
        .Value = total_debe
      End If
      .Key = KI_DEBE
      Set .Format = New cABMGridCellFormat
      Set oFormat = .Format
      oFormat.Align = 2 'DT_RIGHT
    End With
    
    With .Add(Nothing, c_key_haber)
      If total_debe Or total_haber Then
        .Value = total_haber
      End If
      .Key = KI_HABER
      Set .Format = New cABMGridCellFormat
      Set oFormat = .Format
      oFormat.Align = 2 'DT_RIGHT
    End With
    
    With .Add(Nothing, c_saldo)
      .Value = Saldo
      .Key = KI_SALDO
    End With
    
    With .Add(Nothing)
      .Key = KI_FECHA_REAL2
    End With
    
    With .Add(Nothing)
      .Key = KI_IMPORTE_REAL2
    End With
    
    With .Add(Nothing)
      .Key = KI_ORIGEN
    End With
    
    With .Add(Nothing)
      .Key = KI_DESCRIP
    End With
    
    With .Add(Nothing)
      .Key = KI_CCOS_ID
    End With
    
    With .Add(Nothing)
      .Key = KICH_CHEQUERA
    End With
    
    With .Add(Nothing)
      .Key = KICH_CHEQUE
    End With
    
    With .Add(Nothing)
      .Key = KICH_COBZ_ID
    End With
    
    With .Add(Nothing)
      .Key = KICH_OPG_ID
    End With
    
    With .Add(Nothing)
      .Key = KICH_MF_ID
    End With
    
    With .Add(Nothing)
      .Key = KICH_CUE_ID
    End With
    
    With .Add(Nothing)
      .Key = KICH_MON_ID
    End With
    
    With .Add(Nothing)
      .Key = KICH_IMPORTEORIGEN
    End With
    
    With .Add(Nothing)
      .Key = KICH_IMPORTE
    End With
    
    With .Add(Nothing)
      .Key = KICH_CHEQ_ID
    End With
    
    With .Add(Nothing)
      .Key = KICH_FECHACOBRO
    End With
    
    With .Add(Nothing)
      .Key = KICH_FECHAVTO
    End With
    
    With .Add(Nothing)
      .Key = KICH_CLE_ID
    End With
    
    With .Add(Nothing)
      .Key = KICH_DESCRIP
    End With
    
    With .Add(Nothing, c_changed)
      .Key = KI_CHANGED
    End With
  
    With .Add(Nothing)
      .Key = KI_DH
    End With
    
    With .Add(Nothing)
      .Key = KI_FECHA_REAL
    End With
    
    With .Add(Nothing)
      .Key = KI_IMPORTE_REAL
    End With
  
  End With
  
  oRow.BackColor = &HCCCCCC
End Sub

Private Function pGetDesde() As String
  pGetDesde = m_ObjAbm.Properties.Item(cscCfFechadesde).Value
End Function

Private Function pGetHasta() As String
  pGetHasta = m_ObjAbm.Properties.Item(cscCfFechahasta).Value
End Function

Private Function pGetFechaCheque() As String
  pGetFechaCheque = m_ObjAbm.Properties.Item(cscCfFechacheque).Value
End Function

Private Function pGetFv() As String
  pGetFv = Val(m_ObjAbm.Properties.Item(cscCfFv).Value)
End Function

Private Function pGetRv() As String
  pGetRv = Val(m_ObjAbm.Properties.Item(cscCfRv).Value)
End Function

Private Function pGetPv() As String
  pGetPv = Val(m_ObjAbm.Properties.Item(cscCfPv).Value)
End Function

Private Function pGetFc() As String
  pGetFc = Val(m_ObjAbm.Properties.Item(cscCfFc).Value)
End Function

Private Function pGetRc() As String
  pGetRc = Val(m_ObjAbm.Properties.Item(cscCfRc).Value)
End Function

Private Function pGetOc() As String
  pGetOc = Val(m_ObjAbm.Properties.Item(cscCfOc).Value)
End Function

Private Function pGetItems() As cIABMProperty
  Set pGetItems = m_ObjAbm.Properties(c_Items)
End Function

Private Function pGetGridCrosstab() As cIABMProperty
  Set pGetGridCrosstab = m_ObjAbm.Properties(c_grid_crosstab)
End Function

Private Function pGetSaldoDetalle() As cIABMProperty
  Set pGetSaldoDetalle = m_ObjAbm.Properties(c_SaldoDetalle)
End Function

Private Function pGetSaldoIni() As cIABMProperty
  Set pGetSaldoIni = m_ObjAbm.Properties(c_saldoInicial)
End Function

Private Function pGetSaldoIniExcluido() As cIABMProperty
  Set pGetSaldoIniExcluido = m_ObjAbm.Properties(c_saldoIniExcluido)
End Function

Private Function pGetTotal() As cIABMProperty
  Set pGetTotal = m_ObjAbm.Properties(c_total)
End Function

Private Function pGetTotalExcluido() As cIABMProperty
  Set pGetTotalExcluido = m_ObjAbm.Properties(c_totalexcluido)
End Function

Private Sub pRefreshProperties()
  Dim c      As cIABMProperty
  Dim AbmGen As cABMGeneric
  Dim Filter As String

  With m_ObjAbm
    
    .Title2 = m_Nombre
    
    With .Properties
    
      With .Item(cscCfNombre)
        .Value = m_Nombre
      End With
    
      With .Item(cscCfFecha)
        .Value = m_Fecha
      End With
    
      With .Item(cscCueId)
        .Value = m_cuenta
        .HelpId = m_cue_id
      End With
    
      With .Item(cscCfFechadesde)
        .Value = m_Fechadesde
      End With
    
      With .Item(cscCfFechahasta)
        .Value = m_Fechahasta
      End With
    
      With .Item(cscCfFechacheque)
        .Value = CInt(m_Fechacheque)
      End With
    
      With .Item(cscCfFv)
        .Value = CInt(m_Fv)
      End With
    
      With .Item(cscCfRv)
        .Value = CInt(m_Rv)
      End With
    
      With .Item(cscCfPv)
        .Value = CInt(m_Pv)
      End With
    
      With .Item(cscCfFc)
        .Value = CInt(m_Fc)
      End With
    
      With .Item(cscCfRc)
        .Value = CInt(m_Rc)
      End With
    
      With .Item(cscCfOc)
        .Value = CInt(m_Oc)
      End With
      
      With .Item(cscCfDescrip)
        .Value = m_Descrip
      End With
      
    End With

  End With
  
  Set AbmGen = m_ObjAbm
  AbmGen.ShowValues m_ObjAbm.Properties
  
  AbmGen.ResetChanged
  
End Sub

Private Sub pShowCrosstab()
  Dim sqlstmt As String
  Dim rs As ADODB.Recordset
  
  Dim Mouse As cMouseWait
  Set Mouse = New cMouseWait
  
  sqlstmt = "sp_CashFlowGetMatrix " & m_Id & "," & _
                    pGetCuenta() & "," & _
                    gDB.sqlDate(pGetDesde()) & "," & _
                    gDB.sqlDate(pGetHasta()) & "," & _
                    pGetFechaCheque() & "," & _
                    pGetFv() & "," & _
                    pGetRv() & "," & _
                    pGetPv() & "," & _
                    pGetFc() & "," & _
                    pGetRc() & "," & _
                    pGetOc()
                    
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
                    
  Dim Columns       As String
  Dim desde         As Date
  Dim hasta         As Date
  Dim i             As Long
  Dim fecha         As Date
  Dim fecha_value   As Date
  Dim columns_value As String
  Dim dayw          As Long
  
  Dim lastYear          As Long
  Dim lastDayOfYear     As Date
  
  desde = pGetDesde()
  hasta = pGetHasta()
  
  hasta = DateAdd("d", 14, hasta)
  
  ' Le resto una semana para saldos iniciales
  '
  fecha = desde
  
  ' Lo pongo en el viernes
  '
  dayw = DatePart("w", fecha, vbSaturday)
  fecha = DateAdd("d", -dayw + 7, fecha)
  fecha_value = fecha
  
  Columns = Columns & "Saldos Iniciales|"
  columns_value = columns_value & Replace(Format(#1/2/1900#, "yyyy ", vbSaturday), "-", "/") & DatePart("ww", #1/2/1900#, vbSaturday) & "|"
    
  i = 1
    
  While i < 255 And fecha < hasta
  
    Columns = Columns & Format(fecha, "dd-mm-yy ") & DatePart("ww", fecha, vbSaturday) & "|"
    columns_value = columns_value & Replace(Format(fecha_value, "yyyy ", vbSaturday), "-", "/") & DatePart("ww", fecha_value, vbSaturday) & "|"
    
    lastYear = Year(fecha)
    fecha = DateAdd("d", 7, fecha)
    
    If lastYear <> Year(fecha) Then

      lastDayOfYear = DateSerial(lastYear, 12, 31)

      If DatePart("ww", lastDayOfYear, vbSaturday) <> DatePart("ww", fecha_value, vbSaturday) Then

        columns_value = columns_value & Replace(Format(lastDayOfYear, "yyyy ", vbSaturday), "-", "/") & DatePart("ww", lastDayOfYear, vbSaturday) & "|"
        Columns = Columns & Format(lastDayOfYear, "dd-mm-yy ") & DatePart("ww", lastDayOfYear, vbSaturday) & "|"
        
      End If

    End If
    
    fecha_value = DateAdd("d", 7, fecha_value)
    
    i = i + 1
  
  Wend
  
  If Right$(Columns, 1) = "|" Then Columns = Left$(Columns, Len(Columns) - 1)
  If Right$(columns_value, 1) = "|" Then columns_value = Left$(columns_value, Len(columns_value) - 1)
                    
  Dim MngGrid As cGridManager
  Dim oProp   As cABMProperty
  
  Set MngGrid = New cGridManager
  
  Set oProp = pGetGridCrosstab()
  
  MngGrid.ColSaldo = "Saldo"
  MngGrid.RowSumCol = "cue_id"
  MngGrid.RowSumIds = pGetCueIds()
  
  MngGrid.LoadMatrixFromRecordSetEx oProp.ctl.GridCtrl, _
                                    rs, _
                                    Columns, _
                                    columns_value, _
                                    ADODB.DataTypeEnum.adCurrency, _
                                    csTypes.csText, _
                                    "Fecha", _
                                    "Concepto", _
                                    "Saldo", _
                                    "Grupo", _
                                    Nothing
End Sub

Private Function pGetCueIds() As Long()
  Dim rtn()     As Long
  Dim rs        As ADODB.Recordset
  Dim sqlstmt   As String
  
  sqlstmt = "select cue_id from cuenta where cuec_id in (1,2)"
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  If Not rs.EOF Then
    
    Dim i As Long
    
    rs.MoveLast
    rs.MoveFirst
    ReDim rtn(rs.RecordCount)
    
    While Not rs.EOF
      i = i + 1
      rtn(i) = rs.Fields.Item(0).Value
      rs.MoveNext
    Wend
  Else
    ReDim rtn(0)
  End If
  
  pGetCueIds = rtn
End Function

Private Sub pEditParams()

  Dim CashFlowParams As cCashFlowParams
  Set CashFlowParams = New cCashFlowParams
  
  If Not CashFlowParams.Edit(m_Params) Then Exit Sub
  
  m_ParamsChanged = True
  
  Set CashFlowParams = Nothing

End Sub

Private Function pLoadParams() As Boolean
  Dim Param   As cCashFlowParam
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  CollClear m_Params
  
  sqlstmt = "sp_DocCashFlowGetParams " & m_Id
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  While Not rs.EOF
    
    Set Param = New cCashFlowParam
    With Param
      .Banco = gDB.ValField(rs.Fields, cscBcoNombre)
      .bco_id = gDB.ValField(rs.Fields, cscBcoId)
      .Proveedor = gDB.ValField(rs.Fields, cscProvNombre)
      .prov_id = gDB.ValField(rs.Fields, cscProvId)
      .cli_id = gDB.ValField(rs.Fields, cscCliId)
      .Cliente = gDB.ValField(rs.Fields, cscCliNombre)
      .cue_id = gDB.ValField(rs.Fields, cscCueId)
      .Cuenta = gDB.ValField(rs.Fields, cscCueNombre)
    End With
    m_Params.Add Param
    
    rs.MoveNext
  Wend
  
  pLoadParams = True
End Function

Private Function pSaveParams(ByVal cf_id As Long) As Boolean
  Dim register    As cRegister
  Dim Param       As cCashFlowParam
  Dim sqlstmt     As String
  Dim c_ErrorSave As String
  
  c_ErrorSave = LNGGetText(2087, vbNullString) 'Error al grabar el parámetro del Flujo de Fondos
  
  gDB.BeginTransaction
  
  sqlstmt = "delete CashFlowParam where cf_id = " & cf_id
  If Not gDB.Execute(sqlstmt) Then
    gDB.RollBackTransaction
    Exit Function
  End If
  
  For Each Param In m_Params
  
    Set register = New cRegister
    With register
      .fieldId = cscCfpId
      .Table = csTCashFlowParam
  
      .Id = csNew
      
      With .Fields
        .Add2 cscCfId, cf_id, csId
        .Add2 cscCliId, Param.cli_id, csId
        .Add2 cscProvId, Param.prov_id, csId
        .Add2 cscBcoId, Param.bco_id, csId
        .Add2 cscCueId, Param.cue_id, csId
      End With
    End With
  
    If Not gDB.Save(register, , _
                    "cIABMClient_Save", _
                    "cCashFlowItem", _
                    c_ErrorSave) Then
      Exit Function
    End If
  Next
  
  gDB.CommitTransaction
  
  m_ParamsChanged = False
  
  pSaveParams = True
  
End Function

Private Function pGetFvIdFromFvdId(ByVal FvdId As Long) As Long
  Dim FvId As Long
  If Not gDB.GetData("FacturaVentaDeuda", cscFvdId, FvdId, cscFvId, FvId) Then Exit Function
  pGetFvIdFromFvdId = FvId
End Function

Private Function pGetFcIdFromFcdId(ByVal FcdId As Long) As Long
  Dim FcId As Long
  If Not gDB.GetData("FacturaCompraDeuda", cscFcdId, FcdId, cscFcId, FcId) Then Exit Function
  pGetFcIdFromFcdId = FcId
End Function

Private Function pGetAsIdFromAsiId(ByVal AsiId As Long) As Long
  Dim AsId As Long
  If Not gDB.GetData("AsientoItem", cscAsiId, AsiId, cscAsId, AsId) Then Exit Function
  pGetAsIdFromAsiId = AsId
End Function

Private Function pGetOpgIdFromOpgiId(ByVal OpgiId As Long) As Long
  Dim OpgId As Long
  If Not gDB.GetData("OrdenPagoItem", cscOpgiId, OpgiId, cscOpgId, OpgId) Then Exit Function
  pGetOpgIdFromOpgiId = OpgId
End Function

Private Function pGetCobzIdFromCobziId(ByVal CobziId As Long) As Long
  Dim CobzId As Long
  If Not gDB.GetData("CobranzaItem", cscCobziId, CobziId, cscCobzId, CobzId) Then Exit Function
  pGetCobzIdFromCobziId = CobzId
End Function

Private Function pGetMfIdFromMfiId(ByVal MfiId As Long) As Long
  Dim MfId As Long
  If Not gDB.GetData("MovimientoFondoItem", cscMfiId, MfiId, cscMfId, MfId) Then Exit Function
  pGetMfIdFromMfiId = MfId
End Function

' construccion - destruccion
Private Sub Class_Terminate()
  On Error Resume Next
  Set m_Params = Nothing
  Set m_ObjAbm = Nothing
  Set m_GeneralConfig = Nothing
  Set m_ObjTree = Nothing
End Sub

Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  c_ErrorSave = LNGGetText(2083, vbNullString) 'Error al grabar el Flujo de Fondos
  
  Set m_Params = New Collection
  Set m_GeneralConfig = New cGeneralConfig
  m_GeneralConfig.Load
  
  m_Title = LNGGetText(2067, vbNullString)  'Flujo de Fondos

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, vbNullString
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

VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cDespachoImpCalculo"
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
' cDespachoImpCalculo
' 05-11-2006

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
  ' constantes
  ' estructuras
  ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cDespachoImpCalculo"

Private Const c_Items = "ITEMS"
Private Const c_Products = "Products"
Private Const c_importe = "importe"
Private Const c_porc = "porc"

Private Const K_NUMERO                         As Integer = 1
Private Const K_RC_ID                          As Integer = 2
Private Const K_FECHA                          As Integer = 3
Private Const K_TIPO                           As Integer = 4
Private Const K_TITULO                         As Integer = 5
Private Const K_DESCRIP                        As Integer = 6
Private Const K_VIA                            As Integer = 7
Private Const K_VIAEMPRESA                     As Integer = 8
Private Const K_FACTURA                        As Integer = 9
Private Const K_CAMBIO1                        As Integer = 10
Private Const K_CAMBIO2                        As Integer = 11
Private Const K_PASE                           As Integer = 12
Private Const K_TOTALGTOS                      As Integer = 16
Private Const K_PORCFOB                        As Integer = 17
Private Const K_VAR                            As Integer = 18
Private Const K_PORCFOBFINAL                   As Integer = 19
Private Const K_TOTAL                          As Integer = 20
Private Const K_TOTALORIGEN                    As Integer = 21
Private Const K_MON_ID1                        As Integer = 23
Private Const K_MON_ID2                        As Integer = 24

Private Const K_ITEMS                          As Integer = 25
Private Const K_PRODUCTS                       As Integer = 26

Private Const K_CALCULAR                       As Integer = 27

Private Const KI_DICI_ID                       As Integer = 1
Private Const KI_CODIGO                        As Integer = 2
Private Const KI_NAME                          As Integer = 3
Private Const KI_SIGNO                         As Integer = 4
Private Const KI_IMPORTE                       As Integer = 5
Private Const KI_VALUE                         As Integer = 6

Private Const KI_DICP_ID                       As Integer = 1
Private Const KI_POAR_ID                       As Integer = 2
Private Const KI_DERECHOS                      As Integer = 3
Private Const KI_ESTADISTICAS                  As Integer = 4
Private Const KI_IVA                           As Integer = 5
Private Const KI_IVA3431                       As Integer = 6
Private Const KI_GANANCIAS                     As Integer = 7
Private Const KI_IGB                           As Integer = 8
Private Const KI_GASTOENVIO                    As Integer = 9

' Codigo de los items
'

  Private Const codigo_ex_work     As Long = 1
  Private Const codigo_seguro      As Long = 2
  Private Const codigo_embalaje    As Long = 3
  Private Const codigo_totalfob    As Long = -3
  Private Const codigo_flete       As Long = 4
  Private Const codigo_totalcif    As Long = -5
  Private Const codigo_derechos    As Long = 6
  Private Const codigo_estadist    As Long = 7
  Private Const codigo_totalcifde  As Long = -8
  Private Const codigo_iva21       As Long = 9
  Private Const codigo_iva3431_91  As Long = 10
  Private Const codigo_gan3543_92  As Long = 11
  Private Const codigo_igb         As Long = 12

  Private Const codigo_gastosloc   As Long = -13
  Private Const codigo_sim         As Long = 14
  Private Const codigo_honodesp    As Long = 15
  
  Private Const codigo_digital_doc As Long = 25
  Private Const codigo_gastosenvio As Long = 26
  Private Const codigo_gtopba      As Long = 27
    
  Private Const codigo_gtogsan     As Long = 16
  Private Const codigo_almacen     As Long = 17
  Private Const codigo_ley25413    As Long = 18
  Private Const codigo_acarreo     As Long = 19
  Private Const codigo_gastos      As Long = 20
  Private Const codigo_ivagastos   As Long = 21

  Private Const codigo_banco       As Long = 22
  Private Const codigo_sumaapagar  As Long = -23
  Private Const codigo_recuperoiva As Long = -24

' pseudo-constantes
Private c_ErrorSave As String

' estructuras
' variables privadas
Private m_Id                           As Long
Private m_Numero                       As Long
Private m_Remito                       As String
Private m_rc_id                        As Long
Private m_Fecha                        As Date
Private m_Tipo                         As Boolean
Private m_Titulo                       As String
Private m_Descrip                      As String
Private m_Via                          As String
Private m_Viaempresa                   As String
Private m_Factura                      As String
Private m_Cambio1                      As Double
Private m_Cambio2                      As Double
Private m_Pase                         As Double
Private m_Totalgtos                    As Double
Private m_Porcfob                      As Double
Private m_Var                          As Double
Private m_Porcfobfinal                 As Double
Private m_Total                        As Double
Private m_Totalorigen                  As Double
Private m_Mon_id1                      As Long
Private m_moneda1                      As String
Private m_Mon_id2                      As Long
Private m_moneda2                      As String
Private m_Creado                       As Date
Private m_Modificado                   As Date
Private m_Modifico                     As Long

Private m_singoMonDef                  As String

Private m_Editing       As Boolean

Private m_ObjAbm        As cIABMGeneric
Private m_ObjTree       As Object

Private m_IsNew         As Boolean

Private m_BranchId      As Long
Private m_TreeId        As Long

Private m_Host          As CSMenu.cIMenuHost
Private m_Copy          As Boolean

Private m_Title         As String

Private m_GeneralConfig     As cGeneralConfig

' propiedades publicas

' JMA I
Public Property Get Id() As Long
  Id = m_Id
End Property

Public Property Get Nombre() As String
  Nombre = m_Titulo
End Property

Public Property Get codigo() As String
  codigo = m_Titulo
End Property
' JMA F

' propiedades privadas
' funciones publicas


' Implementacion de cIABMClient
Private Function cIABMClient_Copy() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True
  
  With m_ObjAbm.Properties(cscDicTitulo)
    .Value = "c-" & .Value
  End With
  
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscDicTitulo)
  
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

  Doc.ClientTable = csTDespachoImpCalculo
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
  
    Case MSG_ABM_PRINT
      
      If m_Id = csNO_ID Then
        MsgInfo LNGGetText(1852, vbNullString), LNGGetText(1853, vbNullString)
              'Debe grabar el cálculo para poder imprimirlo, Imprimir
      Else
        Dim AbmObj As cABMGeneric
        Set AbmObj = m_ObjAbm
        AbmObj.PrintABM m_Id, -csDespachoImpCalculo ' El menos es para que pase Id y no NODO Id en PrintManager
      End If
      
      cIABMClient_MessageEx = True
    
    Case MSG_ABM_CAN_PRINT
      
      cIABMClient_MessageEx = MSG_ABM_CAN_PRINT
  
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

  Dim AbmObj As cABMGeneric
  Dim iProp  As cIABMProperty

  Set AbmObj = m_ObjAbm

  Select Case Key
  
    Case K_CAMBIO1, K_CAMBIO2
    
      If Not AbmObj.InSave Then
        pCalcCambio
      End If
      
    Case K_VAR
      
      pCalcFOBFinal
      
    Case K_CALCULAR
          
      pUpdateTotalExWorks
                
      Set iProp = pGetProducts()
      pLoadProducts iProp, True
      
      pUpdateDatosPOAR
      
      Set iProp = pGetItems()
      AbmObj.ShowValue iProp, True
      
      pCalcTotalFob

      Set iProp = pGetItems()
      AbmObj.ShowValue iProp, True

    Case K_RC_ID
            
      Set AbmObj = m_ObjAbm
      
      If Not AbmObj.InSave Then
            
        Set iProp = pGetProducts()
        pLoadProducts iProp, True
        
        Set AbmObj = m_ObjAbm
        AbmObj.ShowValue iProp, True
        
        pUpdateTotalExWorks
        
        pUpdateDatosPOAR
        
        pCalcTotalFob
              
        Set iProp = pGetItems()
        AbmObj.ShowValue iProp, True
      
      End If
      
  End Select

  cIABMClient_PropertyChange = True
End Function

Private Function cIABMClient_Save() As Boolean
  Dim proy_id    As Long
  Dim register   As cRegister
  Dim fields     As cFields
  
  Set register = New cRegister
  
  With register
    Set fields = .fields
      
    .fieldId = cscDicId
    .Table = csTDespachoImpCalculo
  
    If m_Copy Then
      .Id = csNew
    Else
      .Id = m_Id
    End If
  End With
  
  Dim IProperty As cIABMProperty
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_RC_ID
          fields.Add2 cscRcId, .HelpId, csText
        Case K_FECHA
          fields.Add2 cscDicFecha, .Value, csDate
        Case K_TIPO
          fields.Add2 cscDicTipo, .ListItemData, csInteger
        Case K_TITULO
          fields.Add2 cscDicTitulo, .Value, csText
        Case K_DESCRIP
          fields.Add2 cscDicDescrip, .Value, csText
        Case K_VIA
          fields.Add2 cscDicVia, .Value, csText
        Case K_VIAEMPRESA
          fields.Add2 cscDicViaempresa, .Value, csText
        Case K_FACTURA
          fields.Add2 cscDicFactura, .Value, csText
        Case K_CAMBIO1
          fields.Add2 cscDicCambio1, .Value, csCurrency
        Case K_CAMBIO2
          fields.Add2 cscDicCambio2, .Value, csCurrency
        Case K_PASE
          fields.Add2 cscDicPase, .Value, csCurrency
        Case K_TOTALGTOS
          fields.Add2 cscDicTotalgtos, .Value, csCurrency
        Case K_PORCFOB
          fields.Add2 cscDicPorcfob, .Value, csCurrency
        Case K_VAR
          fields.Add2 cscDicVar, .Value, csCurrency
        Case K_PORCFOBFINAL
          fields.Add2 cscDicPorcfobfinal, .Value, csCurrency
        Case K_TOTAL
          fields.Add2 cscDicTotal, .Value, csCurrency
        Case K_TOTALORIGEN
          fields.Add2 cscDicTotalorigen, .Value, csCurrency
        Case K_MON_ID1
          fields.Add2 cscMonId1, .HelpId, csId
        Case K_MON_ID2
          fields.Add2 cscMonId2, .HelpId, csId
      End Select
    End With
  Next
  
  fields.HaveLastUpdate = True
  fields.HaveWhoModify = True
  
  If Not register.BeginTrans(gDB) Then Exit Function
  
  ' Obtengo el numero de esta tarea
  '
  If register.Id = csNew Then
    
    Dim dic_numero As Long
    
    If Not gDB.GetNewId(csTDespachoImpCalculo, cscDicNumero, dic_numero) Then
      Exit Function
    End If
    fields.Add2 cscDicNumero, dic_numero, csLong
  End If
  
  If Not gDB.Save(register, , _
                  "cIABMClient_Save", _
                  C_Module, _
                  c_ErrorSave) Then Exit Function
                  
  If Not pSaveItems(register.Id) Then Exit Function
  If Not pSaveProducts(register.Id) Then Exit Function
  
  If Not pSaveCosto(register.Id) Then Exit Function
  
  register.CommitTrans
  
  m_Copy = False
  cIABMClient_Save = Load(register.Id)
End Function

Private Function cIABMClient_Terminate() As Boolean
  m_Editing = False
  
  cIABMClient_Terminate = True
  ' Este objeto puede no cumplir con la interfaz esperada, asi que si hay un error no
  ' le doy bola
  On Error GoTo ControlError
  If m_Id = csNO_ID Then Exit Function
  If m_ObjTree Is Nothing Then Exit Function
  
  m_ObjTree.sqlstmt = "sp_lsdoc_despachoimpcalculo"
  
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

  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_RC_ID
          If ValEmpty(.Value, csText) Then
            MsgInfo LNGGetText(1854, vbNullString)  'Debe indicar un número de documento
            Exit Function
          End If
        Case K_FECHA
          If ValEmpty(.Value, csDate) Then
            MsgInfo LNGGetText(1558, vbNullString)  'Debe indicar un fecha
            Exit Function
          End If
        Case K_TIPO
          If ValEmpty(.Value, csBoolean) Then
            MsgInfo LNGGetText(1222, vbNullString)  'Debe indicar un tipo
            Exit Function
          End If
        Case K_TITULO
          If ValEmpty(.Value, csText) Then
            MsgInfo LNGGetText(1855, vbNullString)  'Debe indicar un título
            Exit Function
          End If
        Case K_VIA
          If ValEmpty(.Value, csText) Then
            MsgInfo LNGGetText(1856, vbNullString)  'Debe indicar una via
            Exit Function
          End If
        Case K_VIAEMPRESA
          If ValEmpty(.Value, csText) Then
            MsgInfo LNGGetText(1129, vbNullString)  'Debe indicar una empresa
            Exit Function
          End If
        Case K_FACTURA
          If ValEmpty(.Value, csText) Then
            MsgInfo LNGGetText(1857, vbNullString)  'Debe indicar una factura
            Exit Function
          End If
        Case K_CAMBIO1
          If ValEmpty(.Value, csCurrency) Then
            MsgInfo LNGGetText(1858, vbNullString) & " " & pGetMon1Signo() & "-" & m_singoMonDef
                    'Debe indicar el cambio
            Exit Function
          End If
        Case K_CAMBIO2
          If ValEmpty(.Value, csCurrency) Then
            MsgInfo LNGGetText(1858, vbNullString) & " " & pGetMon2Signo() & "-" & m_singoMonDef
                    'Debe indicar el cambio
            Exit Function
          End If
        Case K_MON_ID1
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(1859, vbNullString)  'Debe indicar una moneda extranjera
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
  Dim Row           As cIABMGridRow
  Dim codigo        As Long
  Dim gasto_banco   As Double
  
  Dim iProp  As cIABMProperty
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  
  If Key = K_PRODUCTS Then
  
    pUpdateDatosPOAR
    
    pCalcTotalFob
        
    Set iProp = pGetItems()
    AbmObj.ShowValue iProp, True
    
    cIABMClientGrid_ColumnAfterUpdate = True
  
  Else
  
    Set Row = pGetItems().Grid.Rows.Item(lRow)
    codigo = Val(pCell(Row, KI_CODIGO).Value)
    
    Select Case codigo
      Case codigo_ex_work, codigo_seguro, codigo_embalaje
        pCalcTotalFob
        cIABMClientGrid_ColumnAfterUpdate = True
      
      Case codigo_flete
        pCalcTotalCif
        cIABMClientGrid_ColumnAfterUpdate = True
        
      Case codigo_derechos, codigo_estadist
        
        pCalcTotalCifDE
        
        cIABMClientGrid_ColumnAfterUpdate = True
      
      Case codigo_iva21, codigo_iva3431_91, codigo_gan3543_92, codigo_igb
        
        ' Si se toco la columna de porcentajes
        '
        If lCol = 7 Then
          With Row.Item(c_porc)
            If IsNumeric(.Value) Then
            
              Select Case codigo
                Case codigo_iva21
                  pCalcIva21
                Case codigo_iva3431_91
                  pCalcIva3431
                Case codigo_gan3543_92
                  pCalcGan3543
                Case codigo_igb
                  pCalcIgb
              End Select
              
              .Value = Format$(Val(.Value) / 100, "0.0%")
            End If
          End With
        End If
        
        cIABMClientGrid_ColumnAfterUpdate = True
      
      Case codigo_sim, codigo_honodesp, codigo_gtogsan, codigo_almacen, _
           codigo_ley25413, codigo_acarreo, codigo_gastos, codigo_gtopba, _
           codigo_digital_doc, codigo_gastosenvio, codigo_banco
           
        If lCol = 6 Then
          pCalcIvaGastos -codigo, False
        Else
          pCalcIvaGastos codigo, False
        End If
        
        cIABMClientGrid_ColumnAfterUpdate = True
                   
      Case codigo_banco
      
        With Row.Item(c_porc)
          If IsNumeric(.Value) Then
            gasto_banco = Val(.Value)
            .Value = Format$(gasto_banco, m_GeneralConfig.FormatDecImporte)
          End If
          Row.Item(c_importe).Value = DivideByCero(gasto_banco, pGetCambio())
        End With
      
        pCalcSumaAPagar
      
        cIABMClientGrid_ColumnAfterUpdate = True
        
      Case codigo_ivagastos
      
        pCalcIvaGastos2 lCol
        cIABMClientGrid_ColumnAfterUpdate = True
    End Select
    
    Set iProp = pGetItems()
    AbmObj.RefreshGridRows iProp, 0

  End If

End Function

Private Function cIABMClientGrid_ColumnBeforeEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean
  
  If Key = K_PRODUCTS Then
  
    cIABMClientGrid_ColumnBeforeEdit = True
    
  Else
  
    ' 6 y 7 son los indices de las columnas importe y porcentaje
    '
    If lCol <> 6 And lCol <> 7 Then Exit Function
    
    Dim Row As cIABMGridRow
    Set Row = pGetItems().Grid.Rows.Item(lRow)
    
    ' Si es un importe
    '
    If lCol = 6 Then
    
      Select Case Val(pCell(Row, KI_CODIGO).Value)
        Case codigo_ex_work, codigo_seguro, codigo_flete, _
             codigo_derechos, codigo_estadist, codigo_iva21, _
             codigo_iva3431_91, codigo_gan3543_92, codigo_igb, codigo_embalaje, _
             codigo_sim, codigo_honodesp, codigo_gtogsan, _
             codigo_almacen, codigo_ley25413, _
             codigo_acarreo, codigo_gastos, _
             codigo_ivagastos, codigo_banco, codigo_gtopba, _
             codigo_digital_doc, codigo_gastosenvio
             
          cIABMClientGrid_ColumnBeforeEdit = True
      End Select
    
    ' Si es un porcentaje
    '
    ElseIf lCol = 7 Then
    
      Select Case Val(pCell(Row, KI_CODIGO).Value)
        
        Case codigo_sim, codigo_honodesp, codigo_gtogsan, _
             codigo_almacen, codigo_ley25413, _
             codigo_acarreo, codigo_gastos, _
             codigo_ivagastos, codigo_banco, codigo_gtopba, _
             codigo_digital_doc, codigo_gastosenvio, codigo_iva21, codigo_iva3431_91, codigo_gan3543_92, codigo_igb
             
          cIABMClientGrid_ColumnBeforeEdit = True
      End Select
    
    End If
  End If
  
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
  cIABMClientGrid_IsEmptyRow = True
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
  cIEditGeneric_ShowList = SecurityCanAccess(csPreCpraListDespImpoCalc)
End Function

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
  Set m_ObjAbm = rhs
End Property

Private Property Get cIEditGeneric_Editing() As Boolean
  cIEditGeneric_Editing = m_Editing
End Property

Private Function cIEditGeneric_Delete(Id As Long) As Boolean
  If Not SecurityCanAccess(csPreCpraDeleteDespImpoCalc) Then Exit Function
  
  Dim sqlstmt As String
  
  sqlstmt = "sp_DocDespachoImpCalculoDelete  " & Id
  
  cIEditGeneric_Delete = gDB.Execute(sqlstmt, "cIEditGeneric_Delete", C_Module)
End Function

Private Function cIEditGeneric_Search(Id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Id = csNO_ID Then
    m_IsNew = True
    If Not SecurityCanAccess(csPreCpraNewDespImpoCalc) Then Exit Function
  Else
    m_IsNew = False
    If Not SecurityCanAccess(csPreCpraEditDespImpoCalc) Then Exit Function
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
  MngError Err, "cIEditGeneric_Edit", C_Module, vbNullString
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

' funciones privadas
Private Function LoadCollection() As Boolean
  
  Dim AbmObj As cABMGeneric
  Dim c As cIABMProperty
  
  Set AbmObj = m_ObjAbm
  AbmObj.MinHeight = 8000
  AbmObj.MinWidth = 11000
  AbmObj.NoChangeColsInRefresh = True
  AbmObj.bNoChangeBackColorCell = True
  
  With m_ObjAbm.Tabs
    
    .Clear
    
    With .Add(Nothing)
      .Name = C_strGeneral
    End With
        
    With .Add(Nothing)
      .Name = LNGGetText(1371, vbNullString)  'Items
      .Index = 1
    End With
        
    With .Add(Nothing)
      .Name = LNGGetText(1861, vbNullString)  'Observaciones
      .Index = 2
    End With
  
  End With
  
  With m_ObjAbm.Properties
    
    .Clear
  
    With .Add(Nothing, cscDicTipo)
      .PropertyType = cspList
      .Left = 1000
      .LeftLabel = -600
      .Width = 1300
      .Name = LNGGetText(1223, vbNullString)  'Tipo
      .Key = K_TIPO
      
      .ListWhoSetItem = csListItemData
      .ListItemData = m_Tipo
        
        With .List.Add(New cABMListItem, csEDIC_Provisorio)
          .Id = csEDIC_Provisorio
          .Value = LNGGetText(1862, vbNullString)  'Provisorio
        End With
        
        With .List.Add(New cABMListItem, csEDIC_Definitivo)
          .Id = csEDIC_Definitivo
          .Value = LNGGetText(1863, vbNullString)  'Definitivo
        End With
      
    End With
    
    With .Add(Nothing, cscRcId)
      .PropertyType = cspHelp
      .Table = csRemitoCompra
      .TopFromProperty = cscDicTipo
      .Name = LNGGetText(1610, vbNullString)  'Comprobante
      .Left = 3600
      .LeftLabel = -1000
      .Size = 50
      .Width = 4000
      .Key = K_RC_ID
      .Value = m_Remito
      .HelpId = m_rc_id
      .Enabled = m_Id = csNO_ID
    End With
        
    With .Add(Nothing, cscDicNumero)
      .PropertyType = cspNumeric
      .SubType = cspInteger
      .TopFromProperty = cscDicTipo
      .Left = 8600
      .LeftLabel = -600
      .Width = 1000
      .Name = LNGGetText(1065, vbNullString)  'Número
      .Key = K_NUMERO
      .Enabled = False
      .Value = m_Numero
    End With
    
    With .Add(Nothing, cscDicTitulo)
      .PropertyType = cspText
      .Left = 1500
      .LeftLabel = -800
      .Width = 5560
      .Name = LNGGetText(1864, vbNullString)  'Título
      .Size = 255
      .Key = K_TITULO
      .Value = m_Titulo
    End With
    
    With .Add(Nothing, cscDicFecha)
      .PropertyType = cspDate
      .Left = 8100
      .LeftLabel = -800
      .LeftNotChange = True
      .TopFromProperty = cscDicTitulo
      .Name = LNGGetText(1569, vbNullString)  'Fecha
      .Key = K_FECHA
      .Value = m_Fecha
    End With
    
    With .Add(Nothing, cscDicVia)
      .PropertyType = cspText
      .TopToPrevious = 330
      .Name = LNGGetText(1865, vbNullString)  'Via
      .Size = 255
      .Key = K_VIA
      .Value = m_Via
    End With
    
    With .Add(Nothing, cscDicViaempresa)
      .PropertyType = cspText
      .TopFromProperty = cscDicVia
      .Left = 4800
      .Name = LNGGetText(1114, vbNullString)  'Empresa
      .LeftLabel = -800
      .Size = 255
      .Key = K_VIAEMPRESA
      .Value = m_Viaempresa
    End With
        
    With .Add(Nothing, cscDicFactura)
      .PropertyType = cspText
      .TopFromProperty = cscDicVia
      .Left = 8100
      .LeftLabel = -800
      .Name = LNGGetText(1866, vbNullString)  'Factura
      .Size = 50
      .Key = K_FACTURA
      .Value = m_Factura
    End With
    
    With .Add(Nothing, cscMonId1)
      .PropertyType = cspHelp
      .Table = csMoneda
      .LeftFromProperty = cscDicVia
      .TopToPrevious = 330
      .LeftLabel = -800
      .Name = LNGGetText(1867, vbNullString)  'M. ComEx
      .Key = K_MON_ID1
      .Value = m_moneda1
      .HelpId = m_Mon_id1
    End With
    
    With .Add(Nothing, cscDicCambio1)
      .PropertyType = cspNumeric
      .SubType = cspDouble
      .TopFromProperty = cscMonId1
      .Left = 6500
      .LeftLabel = -800
      .Name = LNGGetText(1868, vbNullString)  'Cambio 1
      .Format = "0.0000"
      .Key = K_CAMBIO1
      .Value = m_Cambio1
    End With
    
    With .Add(Nothing, cscMonId2)
      .PropertyType = cspHelp
      .Table = csMoneda
      .LeftFromProperty = cscMonId1
      .LeftLabel = -800
      .TopToPrevious = 350
      .Name = LNGGetText(1870, vbNullString)  'M. Origen
      .Key = K_MON_ID2
      .Value = m_moneda2
      .HelpId = m_Mon_id2
    End With
    
    With .Add(Nothing, cscDicCambio2)
      .PropertyType = cspNumeric
      .SubType = cspDouble
      .TopFromProperty = cscMonId2
      .Name = LNGGetText(1869, vbNullString)  'Cambio 2
      .Format = "0.0000"
      .Left = 6500
      .LeftLabel = -800
      .Key = K_CAMBIO2
      .Value = m_Cambio2
    End With
    
    With .Add(Nothing, cscDicPase)
      .PropertyType = cspNumeric
      .SubType = cspDouble
      .TopFromProperty = cscDicCambio2
      .Left = 8100
      .LeftLabel = -400
      .Name = LNGGetText(1871, vbNullString)  'Pase
      .Format = "0.0000"
      .Key = K_PASE
      .Value = m_Pase
      .Enabled = False
    End With
    
    With .Add(Nothing)
      .PropertyType = cspLabel
      .Height = 10
      .BackColor = &HCECECE
      .Width = 10200
      .Left = 300
      .LeftNotChange = True
    End With
    
    With .Add(Nothing, cscDicTotalgtos)
      .PropertyType = cspNumeric
      .SubType = cspDouble
      .LeftFromProperty = cscDicTitulo
      .LeftLabel = -800
      .TopToPrevious = 100
      .Name = LNGGetText(1872, vbNullString)  'T. Gastos
      .Enabled = False
      .Format = m_GeneralConfig.FormatDecImporte
      .Width = 1400
      .Key = K_TOTALGTOS
      .Value = m_Totalgtos
    End With
    
    With .Add(Nothing, cscDicTotal)
      .PropertyType = cspNumeric
      .TopFromProperty = cscDicTotalgtos
      .Left = 3900
      .SubType = cspDouble
      .LeftLabel = -800
      .Name = LNGGetText(1873, vbNullString)  'Embarque
      .Enabled = False
      .Format = m_GeneralConfig.FormatDecImporte
      .Width = 1400
      .Key = K_TOTAL
      .Value = m_Total
    End With
    
    With .Add(Nothing, cscDicTotalorigen)
      .PropertyType = cspNumeric
      .SubType = cspDouble
      .TopFromProperty = cscDicTotalgtos
      .Left = 6700
      .LeftLabel = -500
      .Name = LNGGetText(2177, vbNullString, pGetMon1Signo()) 'Total  & pGetMon1Signo()
      .Enabled = False
      .Format = m_GeneralConfig.FormatDecImporte
      .Width = 1400
      .Key = K_TOTALORIGEN
      .Value = m_Totalorigen
    End With
    
    With .Add(Nothing, cscDicPorcfob)
      .PropertyType = cspNumeric
      .SubType = cspPercent
      .LeftFromProperty = cscDicTitulo
      .TopToPrevious = 350
      .LeftLabel = -800
      .Name = LNGGetText(1874, vbNullString)  'Porc. FOB
      .Enabled = False
      .Width = 1400
      .Key = K_PORCFOB
      .Value = m_Porcfob
    End With
    
    With .Add(Nothing, cscDicVar)
      .PropertyType = cspNumeric
      .SubType = cspPercent
      .TopFromProperty = cscDicPorcfob
      .LeftLabel = -800
      .Name = LNGGetText(1875, vbNullString)  'Variación
      .Width = 1400
      .LeftFromProperty = cscDicTotal
      .Key = K_VAR
      .Value = m_Var
    End With
    
    With .Add(Nothing, cscDicPorcfobfinal)
      .PropertyType = cspNumeric
      .SubType = cspPercent
      .TopFromProperty = cscDicPorcfob
      .LeftFromProperty = cscDicTotalorigen
      .Name = LNGGetText(1876, vbNullString)  'Porc. FOB Final
      .Width = 1400
      .FontBold = True
      .Enabled = False
      .Key = K_PORCFOBFINAL
      .Value = m_Porcfobfinal
    End With
    
    With .Add(Nothing)
      .PropertyType = cspButton
      .Name = LNGGetText(4985, vbNullString) ' Calcular Valores
      .TopFromProperty = cscDicPorcfobfinal
      .TopToPrevious = -50
      .Left = 8300
      .TopNotChange = True
      .LeftLabel = -1
      .Key = K_CALCULAR
    End With
      
    Dim oGrid As cABMGrid
    Set c = .Add(Nothing, c_Items)
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      If Not pLoadItems(c) Then Exit Function
      .TopFromProperty = cscDicPorcfobfinal
      .TopToPrevious = 380
      .Left = 400
      .Name = c_Items
      .Key = K_ITEMS
      .GridAdd = False
      .GridEdit = True
      .GridRemove = False
      Set oGrid = c.Grid
    End With
    
    Set c = .Add(Nothing, c_Products)
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      If Not pLoadProducts(c, False) Then Exit Function
      .Left = 400
      .Name = c_Products
      .Key = K_PRODUCTS
      .GridAdd = False
      .GridEdit = True
      .GridRemove = False
      Set oGrid = c.Grid
      .TabIndex = 1
      .Top = 1000
    End With
    
    With .Add(Nothing, cscDicDescrip)
      .PropertyType = cspText
      .SubType = cspMemo
      .LeftLabel = -1
      .Name = LNGGetText(1211, vbNullString)  'Observ.
      .Size = 5000
      .Key = K_DESCRIP
      .Value = m_Descrip
      .Width = 7500
      .Height = 2000
      .TabIndex = 2
    End With
    
  End With
    
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

Private Function pLoadProducts(ByRef Propiedad As cIABMProperty, _
                               ByVal bCalc As Boolean) As Boolean
  Dim sqlstmt     As String
  Dim rs          As ADODB.Recordset
  
  sqlstmt = "sp_DocDespachoImpCalculoGetPOAR " _
                           & m_Id & "," & _
                           pGetRemito().HelpId & "," & _
                           IIf(bCalc, 1, 0) & "," & _
                           gDB.sqlNumber(pGetSeguro()) & "," & _
                           gDB.sqlNumber(pGetEmbalaje()) & "," & _
                           gDB.sqlNumber(pGetFlete())
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadItems", C_Module) Then Exit Function

  If Not rs.EOF Then

    If rs.fields(0).Name = "error_in_sp_id" Then
        
      MsgWarning rs.fields(0).Value
        
      Dim ErrorDetail As Object
      
      Set ErrorDetail = CSKernelClient2.CreateObject("CSMessageAux.cMessageAux")
      ErrorDetail.ShowMessageFromRecordset "Info", rs, Me

      Exit Function
    End If
  End If

  With Propiedad.Grid
    
    .Columns.Clear
    .Rows.Clear
    
    With .Columns
    
      With .Add(Nothing)
        .Visible = False
        .Key = KI_DICP_ID
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(3275, vbNullString) ' Posición Arancelaria
        .Key = KI_POAR_ID
      End With
      With .Add(Nothing)
        .Name = LNGGetText(4977, vbNullString) ' Derechos
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Format = m_GeneralConfig.FormatDecImporte
        .Key = KI_DERECHOS
      End With
      With .Add(Nothing)
        .Name = LNGGetText(4978, vbNullString) ' Estadisticas
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Format = m_GeneralConfig.FormatDecImporte
        .Key = KI_ESTADISTICAS
      End With
      With .Add(Nothing)
        .Name = LNGGetText(4979, vbNullString) ' IVA
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Format = m_GeneralConfig.FormatDecImporte
        .Key = KI_IVA
      End With
      With .Add(Nothing)
        .Name = LNGGetText(4980, vbNullString) ' IVA 3431/91
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Format = m_GeneralConfig.FormatDecImporte
        .Key = KI_IVA3431
      End With
      With .Add(Nothing)
        .Name = LNGGetText(4981, vbNullString) ' Ganancias 3543/92 3%
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Format = m_GeneralConfig.FormatDecImporte
        .Key = KI_GANANCIAS
      End With
      With .Add(Nothing)
        .Name = LNGGetText(4982, vbNullString) ' IGB
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Format = m_GeneralConfig.FormatDecImporte
        .Key = KI_IGB
      End With
      With .Add(Nothing)
        .Name = LNGGetText(4983, vbNullString) ' Gastos Envio
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Format = m_GeneralConfig.FormatDecImporte
        .Key = KI_GASTOENVIO
      End With
      
    End With
    
    With .Rows

      While Not rs.EOF

        With .Add(Nothing)

          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscDicpId)
            .Key = KI_DICP_ID
          End With

          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPoarNombre)
            .Id = gDB.ValField(rs.fields, cscPoarId)
            .Key = KI_POAR_ID
          End With
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscDicpDerechos)
            .Key = KI_DERECHOS
          End With
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscDicpEstadisticas)
            .Key = KI_ESTADISTICAS
          End With
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscDicpIva)
            .Key = KI_IVA
          End With
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscDicpIva3431)
            .Key = KI_IVA3431
          End With
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscDicpGanancias)
            .Key = KI_GANANCIAS
          End With
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscDicpIgb)
            .Key = KI_IGB
          End With
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscDicpGastoenvio)
            .Key = KI_GASTOENVIO
          End With

        End With

        rs.MoveNext
      Wend

    End With
  End With

  pLoadProducts = True

End Function

Private Function pLoadItems(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt     As String
  Dim rs          As ADODB.Recordset
  Dim Signo       As String
  Dim codigo      As Long
  Dim Row         As cIABMGridRow
  Dim oRow        As cABMGridRow
  Dim cellFormat  As cABMGridCellFormat
  
  sqlstmt = "sp_DocDespachoImpCalculoGetItems " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadItems", C_Module) Then Exit Function
  
  Signo = pGetMon2Signo()
  
  With Propiedad.Grid
    
    .Columns.Clear
    .Rows.Clear
    
    With .Columns
    
      With .Add(Nothing)
        .Visible = False
        .Key = KI_DICI_ID
      End With
      
      With .Add(Nothing)
        .Visible = False
        .Key = KI_CODIGO
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1877, vbNullString)  'Concepto
        .PropertyType = cspText
        .Enabled = False
        .Width = 1800
        .Key = KI_NAME
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1113, vbNullString)  'Moneda
        .PropertyType = cspText
        .Enabled = False
        .Width = 1200
        .Key = KI_SIGNO
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1228, vbNullString)  'Importe
        .Format = m_GeneralConfig.FormatDecImporte
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Width = 1200
        .Key = KI_IMPORTE
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1878, vbNullString)  'Porc./$
        .PropertyType = cspText
        .Width = 1200
        .Key = KI_VALUE
      End With
      
    End With
  
    Set cellFormat = New cABMGridCellFormat
    cellFormat.Align = 2 'DT_RIGHT
  
    With .Rows

      While Not rs.EOF

        codigo = gDB.ValField(rs.fields, cscDiciCodigo)

        Set Row = .Add(Nothing, codigo)
        Set oRow = Row

        With Row

          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscDiciId)
            .Key = KI_DICI_ID
          End With

          With .Add(Nothing, codigo)
            .Value = codigo
            .Key = KI_CODIGO
          End With

          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, "name")
            .Key = KI_NAME
          End With

          With .Add(Nothing)
            .Value = Signo
            .Key = KI_SIGNO
          End With

          With .Add(Nothing, c_importe)
            If codigo <> codigo_gastosloc Then
              .Value = gDB.ValField(rs.fields, cscDiciImporte)
            End If
            .Key = KI_IMPORTE
          End With

          With .Add(Nothing, c_porc)
            Select Case codigo
              Case codigo_derechos, codigo_estadist, _
                   codigo_iva21, codigo_iva3431_91, _
                   codigo_gan3543_92, codigo_igb
                   
                .Value = gDB.ValField(rs.fields, cscDiciPorc)
                
              Case codigo_sim, codigo_honodesp, codigo_gtogsan, _
                   codigo_almacen, codigo_ley25413, codigo_acarreo, _
                   codigo_gastos, codigo_ivagastos, codigo_banco, _
                   codigo_sumaapagar, codigo_recuperoiva, codigo_gtopba, _
                   codigo_digital_doc, codigo_gastosenvio
                   
                .Value = Format(gDB.ValField(rs.fields, cscDiciValor), m_GeneralConfig.FormatDecImporte)
                
            End Select
            .Key = KI_VALUE
            Set .Format = cellFormat
          End With
          
          Select Case codigo
            Case codigo_ex_work, codigo_totalfob, codigo_totalcif, codigo_totalcifde, codigo_gastosloc, codigo_sumaapagar
              oRow.BackColor = &HCCCCCC
          End Select

        End With

        rs.MoveNext
      Wend

    End With
  End With
  
  pLoadItems = True
End Function

Private Function Load(ByVal Id As Long) As Boolean
  Dim sqlstmt As String
  
  sqlstmt = "sp_DocDespachoImpCalculoGet " & Id
  
  Dim rs As ADODB.Recordset
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function
  
  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.fields, cscDicId)
    m_Numero = gDB.ValField(rs.fields, cscDicNumero)
    m_Remito = gDB.ValField(rs.fields, "comprobante")
    m_rc_id = gDB.ValField(rs.fields, cscRcId)
    m_Fecha = gDB.ValField(rs.fields, cscDicFecha)
    m_Tipo = gDB.ValField(rs.fields, cscDicTipo)
    m_Titulo = gDB.ValField(rs.fields, cscDicTitulo)
    m_Descrip = gDB.ValField(rs.fields, cscDicDescrip)
    m_Via = gDB.ValField(rs.fields, cscDicVia)
    m_Viaempresa = gDB.ValField(rs.fields, cscDicViaempresa)
    m_Factura = gDB.ValField(rs.fields, cscDicFactura)
    m_Cambio1 = gDB.ValField(rs.fields, cscDicCambio1)
    m_Cambio2 = gDB.ValField(rs.fields, cscDicCambio2)
    m_Pase = gDB.ValField(rs.fields, cscDicPase)
    m_Totalgtos = gDB.ValField(rs.fields, cscDicTotalgtos)
    m_Porcfob = gDB.ValField(rs.fields, cscDicPorcfob)
    m_Var = gDB.ValField(rs.fields, cscDicVar)
    m_Porcfobfinal = gDB.ValField(rs.fields, cscDicPorcfobfinal)
    m_Total = gDB.ValField(rs.fields, cscDicTotal)
    m_Totalorigen = gDB.ValField(rs.fields, cscDicTotalorigen)
    m_Mon_id1 = gDB.ValField(rs.fields, cscMonId1)
    m_Mon_id2 = gDB.ValField(rs.fields, cscMonId2)
    m_Creado = gDB.ValField(rs.fields, cscCreado)
    m_Modificado = gDB.ValField(rs.fields, cscModificado)
    m_Modifico = gDB.ValField(rs.fields, cscModifico)

    m_moneda1 = gDB.ValField(rs.fields, "moneda1")
    m_moneda2 = gDB.ValField(rs.fields, "moneda2")

  Else
    
    m_Id = csNO_ID
    m_Numero = 0
    m_Remito = vbNullString
    m_Fecha = csNoDate
    m_Tipo = False
    m_Titulo = vbNullString
    m_Descrip = vbNullString
    m_Via = vbNullString
    m_Viaempresa = vbNullString
    m_Factura = vbNullString
    m_Cambio1 = 0
    m_Cambio2 = 0
    m_Pase = 0
    m_Totalgtos = 0
    m_Porcfob = 0
    m_Var = 0
    m_Porcfobfinal = 0
    m_Total = 0
    m_Totalorigen = 0
    m_Mon_id1 = csNO_ID
    m_Mon_id2 = csNO_ID
    m_Creado = csNoDate
    m_Modificado = csNoDate
    m_Modifico = 0
    
    m_moneda1 = vbNullString
    m_moneda2 = vbNullString

  End If

  Load = True

End Function

'/////////////////////////////////////////////////////////////
' Menu
Private Function cIMenuClient_Initialize(f As Object, Host As CSMenu.cIMenuHost) As Boolean
  On Error GoTo ControlError
  Dim str_1879 As String
  
  str_1879 = LNGGetText(1879, vbNullString)   'Com&pras
  
  Set m_Host = Host
  m_Host.Server.AddMenu str_1879, csMenuEnum.csMenuCompras, vbNullString, 1, False, False, False, True, False, Nothing
  m_Host.Server.AddMenu LNGGetText(1880, vbNullString), csPreCpraListDespImpoCalc, str_1879, 0, True, False, False, False, False, Me
                        'Coeficiente Costo Importación
  cIMenuClient_Initialize = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIMenuClient_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal Id As Long) As Variant
  m_Host.MenuListDocClick "CSABMInterface2.CABMGeneric", "CSCompra2.cDespachoImpCalculo", "CSABMInterface2.CABMGenericListDoc", "CSCompra2.cDespachoImpCalculoListDoc", Me, m_Title, 0
End Function

' TODO
Private Function pGetMon1Signo() As String
  Dim mon_signo As String
  
  gDB.GetData csTMoneda, _
              cscMonId, _
              pGetMonId1(), _
              cscMonSigno, _
              mon_signo
  
  pGetMon1Signo = mon_signo
End Function

' TODO
Private Function pGetMon2Signo() As String
  Dim mon_signo As String
  
  gDB.GetData csTMoneda, _
              cscMonId, _
              pGetMonId2(), _
              cscMonSigno, _
              mon_signo
              
  pGetMon2Signo = mon_signo
End Function

Private Function pGetMonId1()
  pGetMonId1 = m_ObjAbm.Properties.Item(cscMonId1).HelpId
End Function

Private Function pGetMonId2()
  pGetMonId2 = m_ObjAbm.Properties.Item(cscMonId2).HelpId
End Function

Private Function pGetItems() As cIABMProperty
  Set pGetItems = m_ObjAbm.Properties.Item(c_Items)
End Function

Private Sub pCalcTotalFob()
  
  With pGetItems().Grid.Rows
  
    .Item(GetKey(codigo_totalfob)).Item( _
        c_importe).Value = Val(.Item(GetKey(codigo_ex_work)).Item(c_importe).Value) + _
                           Val(.Item(GetKey(codigo_seguro)).Item(c_importe).Value) + _
                           Val(.Item(GetKey(codigo_embalaje)).Item(c_importe).Value)
  End With
  
  pCalcTotalCif
End Sub

Private Sub pCalcTotalCif()
  
  With pGetItems().Grid.Rows
  
    .Item(GetKey(codigo_totalcif)).Item( _
        c_importe).Value = Val(.Item(GetKey(codigo_totalfob)).Item(c_importe).Value) + _
                           Val(.Item(GetKey(codigo_flete)).Item(c_importe).Value)
  End With

  pCalcTotalCifDE

End Sub

Private Function pGetFlete() As Double
  With pGetItems().Grid.Rows
    pGetFlete = Val(.Item(GetKey(codigo_flete)).Item(c_importe).Value)
  End With
End Function

Private Function pGetSeguro() As Double
  With pGetItems().Grid.Rows
    pGetSeguro = Val(.Item(GetKey(codigo_seguro)).Item(c_importe).Value)
  End With
End Function

Private Function pGetEmbalaje() As Double
  With pGetItems().Grid.Rows
    pGetEmbalaje = Val(.Item(GetKey(codigo_embalaje)).Item(c_importe).Value)
  End With
End Function

Private Sub pCalcTotalCifDE()
  Dim derechos    As Double
  Dim Estadist    As Double
  Dim total_cif   As Double
  
  With pGetItems().Grid.Rows
  
    total_cif = .Item(GetKey(codigo_totalcif)).Item(c_importe).Value
  
    derechos = Val(.Item(GetKey(codigo_derechos)).Item(c_importe).Value)
    Estadist = Val(.Item(GetKey(codigo_estadist)).Item(c_importe).Value)
  
    .Item(GetKey(codigo_totalcifde)).Item( _
        c_importe).Value = total_cif + derechos + Estadist
                           
  End With

  pCalcSumaAPagar
End Sub

Private Sub pCalcIva21()
  
  Dim iva21         As Double
  Dim total_cifde   As Double
  
  With pGetItems().Grid.Rows
  
    total_cifde = .Item(GetKey(codigo_totalcifde)).Item(c_importe).Value
    
    iva21 = Val(.Item(GetKey(codigo_iva21)).Item(c_importe).Value)
    
    If iva21 <> 0 Then
      If Not Ask(LNGGetText(1882, vbNullString), vbYes) Then
              'Desea recalcular el monto por IVA 21%
        Exit Sub
      End If
    End If
    
    iva21 = total_cifde * Val(.Item(GetKey(codigo_iva21)).Item(c_porc).Value) / 100
  
    .Item(GetKey(codigo_iva21)).Item( _
        c_importe).Value = iva21
  
  End With
  
  pCalcSumaAPagar
End Sub

Private Sub pCalcIva3431()
  
  Dim iva3431       As Double
  Dim total_cifde   As Double
  
  With pGetItems().Grid.Rows
  
    total_cifde = .Item(GetKey(codigo_totalcifde)).Item(c_importe).Value
    
    iva3431 = Val(.Item(GetKey(codigo_iva3431_91)).Item(c_importe).Value)
    
    If iva3431 <> 0 Then
      If Not Ask(LNGGetText(1883, vbNullString), vbYes) Then
              'Desea recalcular el monto por IVA 3431/91
        Exit Sub
      End If
    End If
    
    iva3431 = total_cifde * Val(.Item(GetKey(codigo_iva3431_91)).Item(c_porc).Value) / 100
  
    .Item(GetKey(codigo_iva3431_91)).Item( _
        c_importe).Value = iva3431
  
  End With
  
  pCalcSumaAPagar
End Sub

Private Sub pCalcGan3543()
  
  Dim gan3543       As Double
  Dim total_cifde   As Double
  
  With pGetItems().Grid.Rows
  
    total_cifde = .Item(GetKey(codigo_totalcifde)).Item(c_importe).Value
    
    gan3543 = Val(.Item(GetKey(codigo_gan3543_92)).Item(c_importe).Value)
    
    If gan3543 <> 0 Then
      If Not Ask(LNGGetText(1884, vbNullString), vbYes) Then
              'Desea recalcular el monto por Ganancias 3543/92
        Exit Sub
      End If
    End If
    
    gan3543 = total_cifde * Val(.Item(GetKey(codigo_gan3543_92)).Item(c_porc).Value) / 100
  
    .Item(GetKey(codigo_gan3543_92)).Item( _
        c_importe).Value = gan3543
  
  End With
  
  pCalcSumaAPagar
End Sub

Private Sub pCalcIgb()
  
  Dim igb           As Double
  Dim total_cifde   As Double
  
  With pGetItems().Grid.Rows
  
    total_cifde = .Item(GetKey(codigo_totalcifde)).Item(c_importe).Value
    
    igb = Val(.Item(GetKey(codigo_igb)).Item(c_importe).Value)
    
    If igb <> 0 Then
      If Not Ask(LNGGetText(4986, vbNullString), vbYes) Then
              'Desea recalcular el monto por Ingresos Brutos
        Exit Sub
      End If
    End If
    
    igb = total_cifde * Val(.Item(GetKey(codigo_igb)).Item(c_porc).Value) / 100
  
    .Item(GetKey(codigo_igb)).Item( _
        c_importe).Value = igb
  
  End With

End Sub

Private Sub pCalcCambio()

  pCalcIvaGastos codigo_sim, True
  pCalcIvaGastos codigo_honodesp, True
  pCalcIvaGastos codigo_gtogsan, True
  pCalcIvaGastos codigo_almacen, True
  pCalcIvaGastos codigo_ley25413, True
  pCalcIvaGastos codigo_digital_doc, True
  pCalcIvaGastos codigo_gastosenvio, True
  pCalcIvaGastos codigo_gtopba, True
  
  pCalcIvaGastos codigo_acarreo, False
  
  Dim iProp  As cIABMProperty
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm

  Set iProp = pGetItems()
  AbmObj.RefreshGridRows iProp, 0

End Sub

Private Sub pCalcIvaGastos(ByVal codigo As Long, ByVal OnlyItem As Boolean)
  Dim total_gastos As Double
  Dim iva_gastos   As Double
  
  With pGetItems().Grid.Rows
  
    If codigo < 0 Then
  
      codigo = codigo * -1
  
      With .Item(GetKey(codigo))
        .Item(c_porc).Value = Format$(0, m_GeneralConfig.FormatDecImporte)
      End With
    
    Else
    
      With .Item(GetKey(codigo))
        .Item(c_importe).Value = DivideByCero(Val(.Item(c_porc).Value), pGetCambio())
        With .Item(c_porc)
          .Value = Format$(.Value, m_GeneralConfig.FormatDecImporte)
        End With
      End With
    
    End If
    
    If OnlyItem Then Exit Sub
    
    pCalcIvaGastos2 7
               
  End With
  
  pCalcSumaAPagar
End Sub

Private Function pGetBaseIvaGastos() As Double
  Dim total_gastos As Double
  
  With pGetItems().Grid.Rows
  
    total_gastos = Val(.Item(GetKey(codigo_sim)).Item(c_importe).Value) _
                 + Val(.Item(GetKey(codigo_honodesp)).Item(c_importe).Value) _
                 + Val(.Item(GetKey(codigo_gtogsan)).Item(c_importe).Value) _
                 + Val(.Item(GetKey(codigo_almacen)).Item(c_importe).Value) _
                 + Val(.Item(GetKey(codigo_ley25413)).Item(c_importe).Value) _
                 + Val(.Item(GetKey(codigo_acarreo)).Item(c_importe).Value) _
                 + Val(.Item(GetKey(codigo_gastosenvio)).Item(c_importe).Value) _
                 + Val(.Item(GetKey(codigo_gtopba)).Item(c_importe).Value)
  End With
  
  pGetBaseIvaGastos = total_gastos
  
End Function

Private Sub pCalcIvaGastos2(ByVal lCol As Long)
  Dim total_gastos As Double
  Dim iva_gastos   As Double
  
  total_gastos = pGetBaseIvaGastos()

  With pGetItems().Grid.Rows
  
    If lCol = 6 Then
    
      With .Item(GetKey(codigo_ivagastos))
        
        .Item(c_porc).Value = Format(Val(.Item(c_importe).Value) / total_gastos * 100, m_GeneralConfig.FormatDecImporte)

      End With
    
    ElseIf lCol = 7 Then
          
      Dim iva_porc As Double
            
      With .Item(GetKey(codigo_ivagastos))
      
        iva_porc = Val(.Item(c_porc).Value)
      
        If iva_porc = 0 Then iva_porc = 21
        
        iva_gastos = total_gastos * iva_porc / 100
      
        .Item(c_importe).Value = Format(iva_gastos, m_GeneralConfig.FormatDecImporte)
        .Item(c_porc).Value = Format(iva_porc, m_GeneralConfig.FormatDecImporte)
      End With
    
    End If
  End With
  
  pCalcSumaAPagar
End Sub

Private Sub pCalcSumaAPagar()
  Dim total_gastos    As Double
  Dim total_der_est   As Double
  Dim total_iva_gan   As Double
  Dim total_iva       As Double
  Dim total_banco     As Double
  Dim suma_a_pagar    As Double
  Dim flete           As Double

  With pGetItems().Grid.Rows
  
    flete = Val(.Item(GetKey(codigo_flete)).Item(c_importe).Value)
  
    total_der_est = Val(.Item(GetKey(codigo_derechos)).Item(c_importe).Value) _
                  + Val(.Item(GetKey(codigo_estadist)).Item(c_importe).Value)
  
    total_iva_gan = Val(.Item(GetKey(codigo_iva21)).Item(c_importe).Value) _
                  + Val(.Item(GetKey(codigo_iva3431_91)).Item(c_importe).Value) _
                  + Val(.Item(GetKey(codigo_gan3543_92)).Item(c_importe).Value)
  
    total_gastos = Val(.Item(GetKey(codigo_sim)).Item(c_importe).Value) _
                 + Val(.Item(GetKey(codigo_honodesp)).Item(c_importe).Value) _
                 + Val(.Item(GetKey(codigo_gtogsan)).Item(c_importe).Value) _
                 + Val(.Item(GetKey(codigo_almacen)).Item(c_importe).Value) _
                 + Val(.Item(GetKey(codigo_ley25413)).Item(c_importe).Value) _
                 + Val(.Item(GetKey(codigo_acarreo)).Item(c_importe).Value) _
                 + Val(.Item(GetKey(codigo_gastos)).Item(c_importe).Value) _
                 + Val(.Item(GetKey(codigo_digital_doc)).Item(c_importe).Value) _
                 + Val(.Item(GetKey(codigo_gastosenvio)).Item(c_importe).Value) _
                 + Val(.Item(GetKey(codigo_gtopba)).Item(c_importe).Value)
  
    total_iva = Val(.Item(GetKey(codigo_ivagastos)).Item(c_importe).Value)
    
    total_banco = Val(.Item(GetKey(codigo_banco)).Item(c_importe).Value)
        
    suma_a_pagar = flete + total_der_est _
                 + total_iva_gan _
                 + total_gastos _
                 + total_iva _
                 + total_banco
    
    .Item(GetKey(codigo_sumaapagar)).Item( _
        c_importe).Value = suma_a_pagar
    
    .Item(GetKey(codigo_sumaapagar)).Item( _
        c_porc).Value = Format$(suma_a_pagar * pGetCambio(), m_GeneralConfig.FormatDecImporte)
    
  End With
  
  pCalcRecuperoIvaGan
End Sub

Private Sub pCalcRecuperoIvaGan()
  Dim total_iva_gan   As Double
  Dim total_iva       As Double
  Dim iva_recupero    As Double
  Dim suma_a_pagar    As Double
  Dim total_fob       As Double
  Dim total_gastos    As Double
  Dim porc_fob        As Double
  
  With pGetItems().Grid.Rows
  
    total_iva_gan = Val(.Item(GetKey(codigo_iva21)).Item(c_importe).Value) _
                  + Val(.Item(GetKey(codigo_iva3431_91)).Item(c_importe).Value) _
                  + Val(.Item(GetKey(codigo_gan3543_92)).Item(c_importe).Value)
  
    total_iva = Val(.Item(GetKey(codigo_ivagastos)).Item(c_importe).Value)
    
    total_fob = Val(.Item(GetKey(codigo_totalfob)).Item(c_importe).Value)
    
    suma_a_pagar = Val(.Item(GetKey(codigo_sumaapagar)).Item(c_importe).Value)
    
    iva_recupero = total_iva_gan + total_iva
    
    .Item(GetKey(codigo_recuperoiva)).Item( _
        c_importe).Value = iva_recupero
    
    .Item(GetKey(codigo_recuperoiva)).Item( _
        c_porc).Value = Format$(iva_recupero * pGetCambio(), m_GeneralConfig.FormatDecImporte)
    
  End With
  
  Dim iProp  As cIABMProperty
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  
  total_gastos = suma_a_pagar - iva_recupero
  Set iProp = pGetTotalGtos()
  iProp.Value = total_gastos
  AbmObj.ShowValue iProp
  
  Set iProp = pGetTotal()
  iProp.Value = total_fob + total_gastos
  AbmObj.ShowValue iProp
  
  Set iProp = pGetTotalOrigen()
  iProp.Value = DivideByCero((total_fob + total_gastos) * pGetCambio(), pGetCambioComex())
  AbmObj.ShowValue iProp
  
  porc_fob = DivideByCero(total_gastos, total_fob) * 100
  Set iProp = pGetPorcFOB()
  iProp.Value = Round(porc_fob, 2)
  AbmObj.ShowValue iProp
  
  pCalcFOBFinal
  
End Sub

Private Sub pCalcFOBFinal()
  Dim iProp  As cIABMProperty
  Dim AbmObj As cABMGeneric
  
  Set AbmObj = m_ObjAbm
  
  Set iProp = pGetPorcFOBFinal()
  iProp.Value = Round(Val(pGetPorcFOB().Value) + pGetVar(), 2)
  AbmObj.ShowValue iProp

End Sub

Private Function pGetCambio() As Double
  pGetCambio = Val(m_ObjAbm.Properties.Item(cscDicCambio2).Value)
End Function

Private Function pGetCambioComex() As Double
  pGetCambioComex = Val(m_ObjAbm.Properties.Item(cscDicCambio1).Value)
End Function

Private Function pGetTotalGtos() As cIABMProperty
  Set pGetTotalGtos = m_ObjAbm.Properties.Item(cscDicTotalgtos)
End Function

Private Function pGetTotal() As cIABMProperty
  Set pGetTotal = m_ObjAbm.Properties.Item(cscDicTotal)
End Function

Private Function pGetTotalOrigen() As cIABMProperty
  Set pGetTotalOrigen = m_ObjAbm.Properties.Item(cscDicTotalorigen)
End Function

Private Function pGetPorcFOB() As cIABMProperty
  Set pGetPorcFOB = m_ObjAbm.Properties.Item(cscDicPorcfob)
End Function

Private Function pGetVar() As Double
  pGetVar = Val(m_ObjAbm.Properties.Item(cscDicVar).Value)
End Function

Private Function pGetPorcFOBFinal() As cIABMProperty
  Set pGetPorcFOBFinal = m_ObjAbm.Properties.Item(cscDicPorcfobfinal)
End Function

Private Function pGetRemito() As cIABMProperty
  Set pGetRemito = m_ObjAbm.Properties.Item(cscRcId)
End Function

Private Function pGetProducts() As cIABMProperty
  Set pGetProducts = m_ObjAbm.Properties.Item(c_Products)
End Function

Private Function pSaveItems(ByVal DicId As Long) As Boolean
  Dim register  As cRegister
  Dim IProperty As cIABMProperty
  Dim Row       As cIABMGridRow
  Dim Cell      As cIABMGridCellValue
  Dim codigo    As Long
  
  For Each Row In pGetItems().Grid.Rows
    
    Set register = New cRegister
    register.fieldId = cscDiciId
    register.Table = csTDespachoImpCalculoItem
    
    With register.fields
    
      For Each Cell In Row
        Select Case Cell.Key
          
          Case KI_DICI_ID
            If m_Copy Then
              register.Id = csNew
            Else
              register.Id = Val(Cell.Value)
            End If
          Case KI_CODIGO
            codigo = Cell.Value
            .Add2 cscDiciCodigo, codigo, csLong
          Case KI_IMPORTE
            .Add2 cscDiciImporte, Cell.Value, csCurrency
          Case KI_VALUE
          
            Select Case codigo
            
              Case codigo_derechos, codigo_estadist, codigo_iva21, _
                   codigo_iva3431_91, codigo_gan3543_92, codigo_igb
                   
                .Add2 cscDiciPorc, Cell.Value, csCurrency
              Case Else
                .Add2 cscDiciValor, Cell.Value, csCurrency
            End Select
            
        End Select
      Next
      
      .Add2 cscDicId, DicId, csId
      
      .HaveLastUpdate = False
      .HaveWhoModify = False
    End With
                                                        
    If Not gDB.Save(register, , "pSaveItems", C_Module, c_ErrorSave) Then Exit Function
  Next

  pSaveItems = True
End Function

Private Function pSaveProducts(ByVal DicId As Long) As Boolean
  Dim register  As cRegister
  Dim IProperty As cIABMProperty
  Dim Row       As cIABMGridRow
  Dim Cell      As cIABMGridCellValue
  Dim codigo    As Long
  
  For Each Row In pGetProducts().Grid.Rows
    
    Set register = New cRegister
    register.fieldId = cscDicpId
    register.Table = csTDespachoImpPosicionArancel
    
    With register.fields
    
      For Each Cell In Row
        Select Case Cell.Key
          
          Case KI_DICP_ID
            If m_Copy Then
              register.Id = csNew
            Else
              register.Id = Val(Cell.Value)
            End If
            
          Case KI_POAR_ID
            .Add2 cscPoarId, Cell.Id, csId
            
          Case KI_DERECHOS
            .Add2 cscDicpDerechos, Cell.Value, csDouble
            
          Case KI_ESTADISTICAS
            .Add2 cscDicpEstadisticas, Cell.Value, csDouble
            
          Case KI_IVA
            .Add2 cscDicpIva, Cell.Value, csDouble
            
          Case KI_IVA3431
            .Add2 cscDicpIva3431, Cell.Value, csDouble
            
          Case KI_GANANCIAS
            .Add2 cscDicpGanancias, Cell.Value, csDouble
            
          Case KI_IGB
            .Add2 cscDicpIgb, Cell.Value, csDouble
            
          Case KI_GASTOENVIO
            .Add2 cscDicpGastoenvio, Cell.Value, csDouble
            
        End Select
      Next
      
      .Add2 cscDicId, DicId, csId
      
      .HaveLastUpdate = False
      .HaveWhoModify = False
    End With
                                                        
    If Not gDB.Save(register, , "pSaveProducts", C_Module, c_ErrorSave) Then Exit Function
  Next

  pSaveProducts = True
End Function

Private Sub pUpdateTotalExWorks()
  Dim rc_neto As Double
  
  If Not gDB.GetData(csTRemitoCompra, _
                     cscRcId, _
                     pGetRemito().HelpId, _
                     cscRcNeto, _
                     rc_neto) Then Exit Sub
  
  With pGetItems().Grid.Rows
  
    .Item(GetKey(codigo_ex_work)).Item(c_importe).Value = rc_neto
        
  End With
      
End Sub

Private Sub pUpdateDatosPOAR()
  Dim Row           As cIABMGridRow
  Dim derechos      As Double
  Dim estadisticas  As Double
  Dim iva           As Double
  Dim iva3431       As Double
  Dim ganancias     As Double
  Dim igb           As Double
  Dim gastoenvio    As Double
  
  For Each Row In pGetProducts().Grid.Rows
  
    derechos = derechos + pCell(Row, KI_DERECHOS).Value
    estadisticas = estadisticas + pCell(Row, KI_ESTADISTICAS).Value
    iva = iva + pCell(Row, KI_IVA).Value
    iva3431 = iva3431 + pCell(Row, KI_IVA3431).Value
    ganancias = ganancias + pCell(Row, KI_GANANCIAS).Value
    igb = igb + pCell(Row, KI_IGB).Value
    gastoenvio = gastoenvio + pCell(Row, KI_GASTOENVIO).Value
  
  Next
  
  With pGetItems().Grid.Rows
  
    .Item(GetKey(codigo_derechos)).Item(c_importe).Value = derechos
    .Item(GetKey(codigo_estadist)).Item(c_importe).Value = estadisticas
    .Item(GetKey(codigo_iva21)).Item(c_importe).Value = iva
    .Item(GetKey(codigo_iva3431_91)).Item(c_importe).Value = iva3431
    .Item(GetKey(codigo_gan3543_92)).Item(c_importe).Value = ganancias
    .Item(GetKey(codigo_igb)).Item(c_importe).Value = igb
    .Item(GetKey(codigo_gastos)).Item(c_importe).Value = gastoenvio
        
  End With
  
End Sub

Private Function pSaveCosto(ByVal Id As Long) As Boolean
  Dim sqlstmt As String
  sqlstmt = "sp_DespachoImpCalculoUpdateCosto " & Id
  
  If Not gDB.Execute(sqlstmt) Then Exit Function
  pSaveCosto = True
End Function

' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  c_ErrorSave = LNGGetText(2178, vbNullString)
                'Error al grabar el Cálculo de Coeficiente para Despachos de Importación"

  Set m_GeneralConfig = New cGeneralConfig
  m_GeneralConfig.Load
  
  gDB.GetData csTMoneda, _
              cscMonId, _
              GetMonedaDefault(), _
              cscMonSigno, _
              m_singoMonDef
  
  m_Title = LNGGetText(2176, vbNullString)  'Coeficiente de Costo de Importación

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Terminate", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
  Set m_ObjAbm = Nothing
  Set m_ObjTree = Nothing
End Sub

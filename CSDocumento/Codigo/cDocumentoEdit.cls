VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cDocumento"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGeneric
Implements CSInterfacesABM.cIABMClient
Implements CSMenu.cIMenuClient
Implements CSInterfacesABM.cIABMClientGrid
'--------------------------------------------------------------------------------
' cDocumento
' 29-05-03

'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cDocumento"

Private Const c_FacturaDesdePackingList = "facpacklst"
Private Const c_FacturaDesdeRemito = "facremito"
Private Const c_FacturaDesdePedido = "facpedido"
Private Const c_FacturaDesdeProyecto = "facproyecto"
Private Const c_FacturaDirecta = "facdirecta"
Private Const c_FacturaDesdeOrden = "facorden"

Private Const c_PackingListDesdePedido = "packlstpedido"
Private Const c_PackingListDesdeRemito = "packlstremito"
Private Const c_PackingListDesdeManifiesto = "packlstmanif"
Private Const c_PackingListDirecto = "packlstdirecto"

Private Const c_OrdenDirecta = "orddirecta"
Private Const c_OrdenDesdePedido = "ordpedido"
Private Const c_OrdenDesdePresupuesto = "ordpresu"

Private Const c_Reportes = "Reportes"
Private Const c_Firmas = "Firmas"

Private Const K_NOMBRE                         As Integer = 1
Private Const K_CODIGO                         As Integer = 2
Private Const K_DESCRIP                        As Integer = 3
Private Const K_DOCT_ID                        As Integer = 4
Private Const K_ACTIVO                         As Integer = 5
Private Const K_EDITAR_IMPRESOS                As Integer = 6
Private Const K_MON_ID                         As Integer = 7
Private Const K_LLEVAFIRMA                     As Integer = 8
Private Const K_ESRESUMENBCO                   As Integer = 802

Private Const K_ESCREDITOBANCO                 As Integer = 810
Private Const K_ESVENTAACCION                  As Integer = 811
Private Const K_ESVENTACHEQUE                  As Integer = 812
Private Const K_ESCOBCHEQUESGR                 As Integer = 813
Private Const K_ESCOBCAIDASGR                  As Integer = 814

Private Const K_LLEVAFIRMACREDITO              As Integer = 800
Private Const K_LLEVAFIRMAPRINT0               As Integer = 801
Private Const K_CICO_ID                        As Integer = 9
Private Const K_EMP_ID                         As Integer = 10

Private Const K_TA_ID                          As Integer = 11

Private Const K_REPORTES                        As Integer = 14
Private Const K_FIRMAS                          As Integer = 15

Private Const K_FCA_ID                          As Integer = 18
Private Const K_CUEG_ID                         As Integer = 19

Private Const K_TA_ID_FINAL                    As Integer = 20
Private Const K_TA_ID_INSCRIPTO                As Integer = 21
Private Const K_TA_ID_EXTERNO                  As Integer = 22
Private Const K_TA_ID_INSCRIPTOM               As Integer = 37

Private Const K_TA_ID_HABERES                  As Integer = 47

Private Const K_DOC_ID_ASIENTO                 As Integer = 23

' Remito Venta/Compra
Private Const K_RV_DESDE_PV                    As Integer = 24
Private Const K_RV_DESDE_OS                    As Integer = 400
Private Const K_RC_DESDE_OC                    As Integer = 24
Private Const K_RV_BOM                         As Integer = 41
Private Const K_RC_DESPACHOIMPO                As Integer = 44

Private Const K_PV_DESDE_PRV                   As Integer = 42

' Factura
Private Const K_FV_DIRECTA                     As Integer = 25
Private Const K_FV_DESDE_PV                    As Integer = 26
Private Const K_FV_DESDE_RV                    As Integer = 27
Private Const K_FV_DESDE_PKLST                 As Integer = 28
Private Const K_FV_DESDE_PROY                  As Integer = 29

Private Const K_FV_SIN_PERCEPCION              As Integer = 30

Private Const K_FC_DIRECTA                     As Integer = 25
Private Const K_FC_DESDE_OC                    As Integer = 26
Private Const K_FC_DESDE_RC                    As Integer = 27

Private Const K_DOCG_ID                        As Integer = 600

Private Const K_FACTURA_ELECTRONICA            As Integer = 601

' Packing List
Private Const K_PKLST_DIRECTO                  As Integer = 29
Private Const K_PKLST_DESDE_PV                 As Integer = 30
Private Const K_PKLST_DESDE_RV                 As Integer = 31
Private Const K_PKLST_DESDE_MFC                As Integer = 32

Private Const K_GENERA_REMITO                  As Integer = 33
Private Const K_MUEVE_STOCK                    As Integer = 34

Private Const K_DOC_ID_STOCK                   As Integer = 35
Private Const K_DOC_ID_REMITO                  As Integer = 36

' Orden de compra
Private Const K_OC_DIRECTA                     As Integer = 38
Private Const K_OC_DESDE_PC                    As Integer = 39
Private Const K_OC_DESDE_PRC                   As Integer = 40

' Stock
Private Const K_ST_CONSUMO                     As Integer = 45

Private Const K_DOC_EDIT_OBJECT                As Integer = 46

Private Const KI_RPTF_ID                        As Integer = 1
Private Const KI_NOMBRE                         As Integer = 2
Private Const KI_CSRFILE                        As Integer = 3
Private Const KI_SUGERIDO                       As Integer = 5
Private Const KI_COPIAS                         As Integer = 6
Private Const KI_PRINTINNEW                     As Integer = 7
Private Const KI_RPT_OBJ                        As Integer = 8
Private Const KI_SUGERIDOMAIL                   As Integer = 9

Private Const KI_DOCFR_ID                       As Integer = 1
Private Const KI_US_ID                          As Integer = 3

' Seudo - Variables
Private c_ErrorSave                    As String

' estructuras
' variables privadas
Private m_Id                           As Long
Private m_Nombre                       As String
Private m_Codigo                       As String
Private m_Descrip                      As String
Private m_Doct_id                      As Long
Private m_DocumentoTipo                As String

Private m_Cico_id                      As Long
Private m_CircuitoContable             As String

Private m_emp_id                       As Long
Private m_Empresa                      As String

Private m_Doc_id_Asiento               As Long
Private m_DocumentoAsiento             As String

Private m_Doc_id_Remito                As Long
Private m_DocumentoRemito              As String
Private m_Doc_id_Stock                 As Long
Private m_DocumentoStock               As String

Private m_Fv_SinPercepcion             As Boolean
Private m_esFacturaElectronica         As Boolean

Private m_Fca_id                       As Long
Private m_FechaControlAcceso           As String
Private m_Creado                       As Date
Private m_Modificado                   As Date
Private m_Modifico                     As Long
Private m_Activo                       As Boolean
Private m_EditarImpresos               As Boolean
Private m_LlevaFirma                   As Boolean
Private m_LlevaFirmaCredito            As Boolean
Private m_LlevaFirmaPrint0             As Boolean
Private m_EsResumenBco                 As Boolean

Private m_EsCreditoBanco               As Boolean
Private m_EsVentaAccion                As Boolean
Private m_EsVentaCheque                As Boolean
Private m_EsCobChequesgr               As Boolean
Private m_EsCobCaidasgr                As Boolean

Private m_RvDesdePv                    As Boolean
Private m_RvDesdeOs                    As Boolean
Private m_RcDesdeOc                    As Boolean
Private m_RcDespachoImpo               As Boolean
Private m_RvBom                        As Boolean
Private m_PvDesdePrv                   As Boolean
Private m_TipoFactura                  As csETipoFactura
Private m_TipoPackingList              As csETipoPackingList
Private m_TipoOrdenCompra              As csETipoOrdenCpra

Private m_GeneraRemito                 As Boolean
Private m_MueveStock                   As Boolean

Private m_Talonario                     As String
Private m_ta_id                         As Long

Private m_TalonarioFinal                As String
Private m_ta_id_Final                   As Long

Private m_TalonarioInscripto            As String
Private m_ta_id_Inscripto               As Long

Private m_TalonarioInscriptoM           As String
Private m_ta_id_InscriptoM              As Long

Private m_TalonarioHaberes              As String
Private m_ta_id_Haberes                 As Long

Private m_DocumentoGrupo                As String
Private m_docg_id                       As Long

Private m_TalonarioExterno              As String
Private m_ta_id_Externo                 As Long

Private m_Moneda                       As String
Private m_mon_id                       As Long

Private m_CuentaGrupo                  As String
Private m_cueg_id                      As Long

Private m_Editing           As Boolean

Private m_ObjAbm            As cIABMGeneric
Private m_ObjTree           As Object

Private m_IsNew             As Boolean

Private m_BranchId          As Long
Private m_TreeId            As Long

Private m_StConsumo         As Boolean

Private m_object_edit       As String

Private m_Host              As CSMenu.cIMenuHost
Private m_Copy              As Boolean

Private m_ItemsDeletedReportes            As String
Private m_FirmasDeleted                   As String

Private m_TopDescrip        As Long
' Properties publicas

' JMA I
Public Property Get Id() As Long
  Id = m_Id
End Property

Public Property Get Nombre() As String
  Nombre = m_Nombre
End Property

Public Property Get Codigo() As String
  Codigo = m_Codigo
End Property
' JMA F

' Properties privadas
' funciones publicas

' Implementacion de cIABMClient
Private Function cIABMClient_Copy() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True
  
  With m_ObjAbm.Properties
    With .Item(cscDocCodigo)
      .Value = "C-" & .Value
    End With
    
    .Item(cscEmpId).Enabled = True
    
    m_ObjAbm.ShowValue .Item(cscDocCodigo)
    m_ObjAbm.ShowValue .Item(cscEmpId)
  End With
  
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

  Doc.ClientTable = csTDocumento
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
    Case MSG_EDIT_PERMISOS
      
      If m_Id = csNO_ID Then
        MsgInfo LNGGetText(2559, vbNullString), LNGGetText(1567, vbNullString)
                'Debe grabar el Documento para poder editar sus permisos, Documento
      
      Else
      
        Dim Permisos As cDocumentoPermiso
        Set Permisos = New cDocumentoPermiso
        Permisos.Edit m_Id, True
      End If
      
      cIABMClient_MessageEx = True
    
    Case MSG_SHOW_EDIT_PERMISOS
      
      cIABMClient_MessageEx = MSG_SHOW_EDIT_PERMISOS
      
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
  On Error Resume Next
  
  Dim iProp As cIABMProperty
  
  Select Case Key
    Case K_MUEVE_STOCK
      With m_ObjAbm.Properties
        If Val(.Item(cscDocMueveStock).Value) Then
          '.Item(cscDocGeneraRemito).Value = 0
          '.Item(cscDocIdRemito).Enabled = False
          .Item(cscDocIdStock).Enabled = True
        End If
      End With
    
    Case K_GENERA_REMITO
      With m_ObjAbm.Properties
        If Val(.Item(cscDocGeneraRemito).Value) Then
          '.Item(cscDocMueveStock).Value = 0
          '.Item(cscDocIdStock).Enabled = False
          .Item(cscDocIdRemito).Enabled = True
        End If
      End With
    
    Case K_EMP_ID
      pChangeEmpresa
  End Select
  
  cIABMClient_PropertyChange = True
End Function

Private Function cIABMClient_Save() As Boolean
  Dim register    As cRegister
  Dim fields      As cFields
  Dim bIsNew      As Boolean
  Dim LastId      As Long
  
  bIsNew = m_Id = csNew
  
  Set register = New cRegister
  With register
     Set fields = .fields
    .fieldId = cscDocId
    .Table = csTDocumento
  
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
        Case K_NOMBRE
          fields.Add2 cscDocNombre, .Value, csText
        Case K_CODIGO
          fields.Add2 cscDocCodigo, .Value, csText
        Case K_DESCRIP
          fields.Add2 cscDocDescrip, .Value, csText
        Case K_CICO_ID
          fields.Add2 cscCicoId, .HelpId, csId
        Case K_EMP_ID
          fields.Add2 cscEmpId, .HelpId, csId
        Case K_DOCT_ID
          fields.Add2 cscDoctId, .HelpId, csId
        Case K_FCA_ID
          fields.Add2 cscFcaId, .HelpId, csId
        Case K_ACTIVO
          fields.Add2 cscActivo, pGetActivo(Val(.Value)), csBoolean
        Case K_EDITAR_IMPRESOS
          fields.Add2 cscDocEditarImpresos, Val(.Value), csBoolean
        Case K_LLEVAFIRMA
          fields.Add2 cscDocLlevaFirma, Val(.Value), csBoolean
        Case K_LLEVAFIRMACREDITO
          fields.Add2 cscDocLlevaFirmaCredito, Val(.Value), csBoolean
        Case K_LLEVAFIRMAPRINT0
          fields.Add2 cscDocLlevaFirmaPrint0, Val(.Value), csBoolean
        Case K_DOC_EDIT_OBJECT
          fields.Add2 cscDocObjectEdit, .Value, csText
      End Select
    End With
  Next
  
  If m_Id <> csNew Then pSaveDocEx register
  
  fields.HaveLastUpdate = True
  fields.HaveWhoModify = True
  
  If Not register.BeginTrans(gDB) Then Exit Function
  
  If Not gDB.Save(register, , "cIABMClient_Save", C_Module, c_ErrorSave) Then Exit Function
  
  LastId = m_Id
  m_Id = register.Id
  
  If Not bIsNew Then
  
    If Not pSaveItemsReportes() Then GoTo SaveError
    If Not pSaveFirmas() Then GoTo SaveError
  
  End If
    
  If Not pSavePrestacion(m_Id) Then GoTo SaveError
  
  If Not register.CommitTrans() Then GoTo SaveError
  
  pSavePermisos LastId, register.Id, bIsNew
  
  m_Copy = False
  
  cIABMClient_Save = Load(register.Id)

  Exit Function
SaveError:
  m_Id = LastId
End Function

Public Function pGetActivo(ByVal Value As Boolean) As Boolean
  
  ' Si no esta activo ni pregunto
  '
  If Not Value Then Exit Function
  
  ' Si no es valido o es nuevo me voy false
  '
  If Not pValidate(True) Or m_Id = csNO_ID Then
    MsgInfo LNGGetText(3527, vbNullString) ' Este documento quedara inactivo por que posee campos obligatorios sin completar. Para poder usuarlo debe completar estos campos y volver a grabar el documento.
    Exit Function
  End If
  
  ' Si llegue hasta aqui es por que esta activo
  '
  pGetActivo = True
End Function

Public Function pSavePrestacion(ByVal Id As Long) As Boolean
  Dim sqlstmt As String
  sqlstmt = "sp_DocumentoSavePrestacion " & Id
  pSavePrestacion = gDB.Execute(sqlstmt)
End Function

Private Function pSaveFirmas() As Boolean
  Dim register As cRegister
  Dim IProperty As cIABMProperty
  
  If m_LlevaFirma _
     Or m_LlevaFirmaCredito _
     Or m_LlevaFirmaPrint0 Then
  
    Set register = New cRegister
    With register
      .fieldId = cscdocfrId
      .Table = csTDocumentoFirma
      .Id = csNew
    
      Dim Row  As cIABMGridRow
      Dim Cell As cIABMGridCellValue
      
      With .fields
        
        For Each Row In m_ObjAbm.Properties.Item(c_Firmas).Grid.Rows
        
          .Clear
          For Each Cell In Row
            Select Case Cell.Key
              Case KI_DOCFR_ID
                If Not m_Copy Then
                  register.Id = Val(Cell.Value)
                End If
              Case KI_US_ID
                .Add2 cscUsId, Cell.Id, csId
            End Select
          Next
        
          .Add2 cscDocId, m_Id, csId
        
          .HaveLastUpdate = True
          .HaveWhoModify = True
        
          If Not gDB.Save(register, , "pSaveItemsDocumento", C_Module, c_ErrorSave) Then Exit Function
        Next
      End With
    End With
    
    Dim sqlstmt As String
    
    If LenB(m_FirmasDeleted) And Not m_Copy Then
      m_FirmasDeleted = RemoveLastColon(m_FirmasDeleted)
      sqlstmt = "delete DocumentoFirma where docfr_id in (" & m_FirmasDeleted & ")"
    
      If Not gDB.Execute(sqlstmt, "pSaveItemsDocumento", C_Module) Then Exit Function
    End If
  End If
  
  pSaveFirmas = True
End Function

Private Sub pSaveDocEx(ByRef register As cRegister)
  Dim fields        As cFields
  Dim IProperty     As cIABMProperty
  Dim bGeneraRto    As Boolean
  Dim bMueveStock   As Boolean
  Dim docIdStock    As Long
  Dim docIdRemito   As Long
  
  Set fields = register.fields
      
  Select Case m_Doct_id
    Case csEDT_FacturaVenta, csEDT_NotaCreditoVenta, csEDT_NotaDebitoVenta
      For Each IProperty In m_ObjAbm.Properties
        With IProperty
          Select Case .Key
            Case K_DOC_ID_ASIENTO
              fields.Add2 cscDocIdAsiento, .HelpId, csId
            Case K_GENERA_REMITO
              bGeneraRto = Val(.Value)
              fields.Add2 cscDocGeneraRemito, bGeneraRto, csBoolean
            Case K_MUEVE_STOCK
              bMueveStock = Val(.Value)
              fields.Add2 cscDocMueveStock, bMueveStock, csBoolean
            Case K_DOC_ID_REMITO
              docIdRemito = .HelpId
            Case K_DOC_ID_STOCK
              docIdStock = .HelpId
            Case K_MON_ID
              fields.Add2 cscMonId, .HelpId, csId
            Case K_TA_ID_FINAL
              fields.Add2 cscTaIdFinal, .HelpId, csId
            Case K_TA_ID_INSCRIPTO
              fields.Add2 cscTaIdInscripto, .HelpId, csId
            Case K_TA_ID_EXTERNO
              fields.Add2 cscTaIdExterno, .HelpId, csId
            Case K_CUEG_ID
              fields.Add2 cscCuegId, .HelpId, csId
            Case K_FV_DESDE_PKLST
              If Val(.Value) <> 0 Then
                fields.Add2 cscDocTipoFactura, csETipoFactura.csETFacPackingList, csLong
              End If
            Case K_FV_DESDE_PV
              If Val(.Value) <> 0 Then
                fields.Add2 cscDocTipoFactura, csETipoFactura.csETFacPedido, csLong
              End If
            Case K_FV_DESDE_RV
              If Val(.Value) <> 0 Then
                fields.Add2 cscDocTipoFactura, csETipoFactura.csETFacRemito, csLong
              End If
            Case K_FV_DIRECTA
              If Val(.Value) <> 0 Then
                fields.Add2 cscDocTipoFactura, csETipoFactura.csETFacDirecta, csLong
              End If
            Case K_FV_DESDE_PROY
              If Val(.Value) <> 0 Then
                fields.Add2 cscDocTipoFactura, csETipoFactura.csETFacProyecto, csLong
              End If
            Case K_FACTURA_ELECTRONICA
              fields.Add2 cscDocesFacturaElectronica, .Value, csBoolean
            Case K_FV_SIN_PERCEPCION
              fields.Add2 cscDocFvSinPercepcion, .Value, csBoolean
            Case K_ESCREDITOBANCO
              fields.Add2 cscDocEsCreditobanco, .Value, csBoolean
            Case K_ESVENTAACCION
              fields.Add2 cscDocEsVentaAccion, .Value, csBoolean
            Case K_ESVENTACHEQUE
              fields.Add2 cscDocEsVentaCheque, .Value, csBoolean
          End Select
        End With
      Next
        
      If Not bGeneraRto Then docIdRemito = csNO_ID
      If Not bMueveStock Then docIdStock = csNO_ID
      fields.Add2 cscDocIdRemito, docIdRemito, csId
      fields.Add2 cscDocIdStock, docIdStock, csId
      
    Case csEDT_FacturaCompra, csEDT_NotaCreditoCompra, csEDT_NotaDebitoCompra
      For Each IProperty In m_ObjAbm.Properties
        With IProperty
          Select Case .Key
            Case K_DOC_ID_ASIENTO
              fields.Add2 cscDocIdAsiento, .HelpId, csId
            Case K_GENERA_REMITO
              bGeneraRto = Val(.Value)
              fields.Add2 cscDocGeneraRemito, bGeneraRto, csBoolean
            Case K_MUEVE_STOCK
              bMueveStock = Val(.Value)
              fields.Add2 cscDocMueveStock, bMueveStock, csBoolean
            Case K_DOC_ID_REMITO
              docIdRemito = .HelpId
            Case K_DOC_ID_STOCK
              docIdStock = .HelpId
            Case K_MON_ID
              fields.Add2 cscMonId, .HelpId, csId
            Case K_TA_ID_FINAL
              fields.Add2 cscTaIdFinal, .HelpId, csId
            Case K_TA_ID_INSCRIPTO
              fields.Add2 cscTaIdInscripto, .HelpId, csId
            Case K_TA_ID_EXTERNO
              fields.Add2 cscTaIdExterno, .HelpId, csId
            Case K_TA_ID_INSCRIPTOM
              fields.Add2 cscTaIdInscriptoM, .HelpId, csId
            Case K_CUEG_ID
              fields.Add2 cscCuegId, .HelpId, csId
            Case K_FC_DESDE_OC
              If Val(.Value) <> 0 Then
                fields.Add2 cscDocTipoFactura, csETipoFactura.csETFacOrden, csLong
              End If
            Case K_FC_DESDE_RC
              If Val(.Value) <> 0 Then
                fields.Add2 cscDocTipoFactura, csETipoFactura.csETFacRemito, csLong
              End If
            Case K_FC_DIRECTA
              If Val(.Value) <> 0 Then
                fields.Add2 cscDocTipoFactura, csETipoFactura.csETFacDirecta, csLong
              End If
            Case K_DOCG_ID
              fields.Add2 cscDocgId, .HelpId, csId
            Case K_ESRESUMENBCO
              fields.Add2 cscDocEsResumenBco, Val(.Value), csBoolean
          End Select
        End With
      Next
    
      If Not bGeneraRto Then docIdRemito = csNO_ID
      If Not bMueveStock Then docIdStock = csNO_ID
      fields.Add2 cscDocIdRemito, docIdRemito, csId
      fields.Add2 cscDocIdStock, docIdStock, csId
    
    Case csEDT_RemitoVenta, csEDT_DevolucionRemitoVta
      For Each IProperty In m_ObjAbm.Properties
        With IProperty
          Select Case .Key
            Case K_MON_ID
              fields.Add2 cscMonId, .HelpId, csId
            Case K_TA_ID
              fields.Add2 cscTaId, .HelpId, csId
            Case K_RV_DESDE_PV
              fields.Add2 cscDocRvDesdePv, Val(.Value), csBoolean
            Case K_RV_DESDE_OS
              fields.Add2 cscDocRvDesdeOs, Val(.Value), csBoolean
            Case K_DOC_ID_STOCK
              fields.Add2 cscDocIdStock, .HelpId, csId
            Case K_MUEVE_STOCK
              fields.Add2 cscDocMueveStock, Val(.Value), csBoolean
            Case K_RV_BOM
              fields.Add2 cscDocRvBom, Val(.Value), csBoolean
          End Select
        End With
      Next
    
    Case csEDT_Liquidacion
      For Each IProperty In m_ObjAbm.Properties
        With IProperty
          Select Case .Key
            Case K_MON_ID
              fields.Add2 cscMonId, .HelpId, csId
            Case K_TA_ID
              fields.Add2 cscTaId, .HelpId, csId
            Case K_TA_ID_HABERES
              fields.Add2 cscTaIdHaberes, .HelpId, csId
            Case K_DOC_ID_ASIENTO
              fields.Add2 cscDocIdAsiento, .HelpId, csId
          End Select
        End With
      Next
    
    Case csEDT_MovimientoFondo
      For Each IProperty In m_ObjAbm.Properties
        With IProperty
          Select Case .Key
            Case K_MON_ID
              fields.Add2 cscMonId, .HelpId, csId
            Case K_TA_ID
              fields.Add2 cscTaId, .HelpId, csId
            Case K_DOC_ID_ASIENTO
              fields.Add2 cscDocIdAsiento, .HelpId, csId
          End Select
        End With
      Next
    Case csEDT_DepositoBanco, csEDT_DepositoCupon, csEDT_ResolucionCupon
      For Each IProperty In m_ObjAbm.Properties
        With IProperty
          Select Case .Key
            Case K_TA_ID
              fields.Add2 cscTaId, .HelpId, csId
            Case K_DOC_ID_ASIENTO
              fields.Add2 cscDocIdAsiento, .HelpId, csId
          End Select
        End With
      Next
    Case csEDT_PermisoEmbarque
      For Each IProperty In m_ObjAbm.Properties
        With IProperty
          Select Case .Key
            Case K_MON_ID
              fields.Add2 cscMonId, .HelpId, csId
          End Select
        End With
      Next
    Case csEDT_ManifiestoCarga
      For Each IProperty In m_ObjAbm.Properties
        With IProperty
          Select Case .Key
            Case K_TA_ID
              fields.Add2 cscTaId, .HelpId, csId
          End Select
        End With
      Next
    Case csEDT_PackingList, csEDT_PackingListDevolucion
      For Each IProperty In m_ObjAbm.Properties
        With IProperty
          Select Case .Key
            Case K_TA_ID
              fields.Add2 cscTaId, .HelpId, csId
            Case K_MON_ID
              fields.Add2 cscMonId, .HelpId, csId
            Case K_PKLST_DESDE_MFC
              If Val(.Value) <> 0 Then
                fields.Add2 cscDocTipoPackingList, csETipoPackingList.csETPackManifiesto, csLong
              End If
            Case K_PKLST_DESDE_PV
              If Val(.Value) <> 0 Then
                fields.Add2 cscDocTipoPackingList, csETipoPackingList.csETPackPedido, csLong
              End If
            Case K_PKLST_DESDE_RV
              If Val(.Value) <> 0 Then
                fields.Add2 cscDocTipoPackingList, csETipoPackingList.csETPackRemito, csLong
              End If
            Case K_PKLST_DIRECTO
              If Val(.Value) <> 0 Then
                fields.Add2 cscDocTipoPackingList, csETipoPackingList.csETPackDirecto, csLong
              End If
          End Select
        End With
      Next
    Case csEDT_OrdenServicio
      For Each IProperty In m_ObjAbm.Properties
        With IProperty
          Select Case .Key
            Case K_MON_ID
              fields.Add2 cscMonId, .HelpId, csId
            Case K_TA_ID
              fields.Add2 cscTaId, .HelpId, csId
            Case K_DOC_ID_STOCK
              fields.Add2 cscDocIdStock, .HelpId, csId
            Case K_MUEVE_STOCK
              fields.Add2 cscDocMueveStock, Val(.Value), csBoolean
          End Select
        End With
      Next
    Case csEDT_RemitoCompra, csEDT_DevolucionRemitoCpra
      For Each IProperty In m_ObjAbm.Properties
        With IProperty
          Select Case .Key
            Case K_MON_ID
              fields.Add2 cscMonId, .HelpId, csId
            Case K_TA_ID
              fields.Add2 cscTaId, .HelpId, csId
            Case K_DOC_ID_STOCK
              fields.Add2 cscDocIdStock, .HelpId, csId
            Case K_RC_DESDE_OC
              fields.Add2 cscDocRcDesdeOc, Val(.Value), csBoolean
            Case K_RC_DESPACHOIMPO
              fields.Add2 cscDocRcDespachoImpo, Val(.Value), csBoolean
            Case K_MUEVE_STOCK
              fields.Add2 cscDocMueveStock, Val(.Value), csBoolean
          End Select
        End With
      Next
    Case csEDT_ImportacionTemp
      For Each IProperty In m_ObjAbm.Properties
        With IProperty
          Select Case .Key
            Case K_MON_ID
              fields.Add2 cscMonId, .HelpId, csId
            Case K_TA_ID
              fields.Add2 cscTaId, .HelpId, csId
            Case K_DOC_ID_STOCK
              fields.Add2 cscDocIdStock, .HelpId, csId
            Case K_MUEVE_STOCK
              fields.Add2 cscDocMueveStock, Val(.Value), csBoolean
          End Select
        End With
      Next
      
    Case csEDT_PedidoVenta, csEDT_DevolucionPedidoVta
      
      For Each IProperty In m_ObjAbm.Properties
        With IProperty
          Select Case .Key
            Case K_TA_ID
              fields.Add2 cscTaId, .HelpId, csId
            Case K_MON_ID
              fields.Add2 cscMonId, .HelpId, csId
            Case K_PV_DESDE_PRV
              fields.Add2 cscDocPvDesdePrv, Val(.Value), csBoolean
          End Select
        End With
      Next
      
      
    Case csEDT_PedidoCompra, csEDT_DevolucionPedidoCpra, _
         csEDT_PresupuestoVenta, csEDT_DevolucionPresuVta, _
         csEDT_PresupuestoCompra, csEDT_DevolucionPresuCpra, _
         csEDT_CotizacionCompra, csEDT_DevolucionCotizacionCpra
         
      For Each IProperty In m_ObjAbm.Properties
        With IProperty
          Select Case .Key
            Case K_TA_ID
              fields.Add2 cscTaId, .HelpId, csId
            Case K_MON_ID
              fields.Add2 cscMonId, .HelpId, csId
          End Select
        End With
      Next
      
    Case csEDT_OrdenCompra, csEDT_DevolucionOrdenCpra
         
      For Each IProperty In m_ObjAbm.Properties
        With IProperty
          Select Case .Key
            Case K_TA_ID
              fields.Add2 cscTaId, .HelpId, csId
            Case K_MON_ID
              fields.Add2 cscMonId, .HelpId, csId
            Case K_OC_DESDE_PC
              If Val(.Value) <> 0 Then
                fields.Add2 cscDocTipoOrdenCompra, csETipoOrdenCpra.csETOrdenPedido, csLong
              End If
            Case K_OC_DESDE_PRC
              If Val(.Value) <> 0 Then
                fields.Add2 cscDocTipoOrdenCompra, csETipoOrdenCpra.csETOrdenPresupuesto, csLong
              End If
            Case K_OC_DIRECTA
              If Val(.Value) <> 0 Then
                fields.Add2 cscDocTipoOrdenCompra, csETipoOrdenCpra.csETOrdenDirecta, csLong
              End If
          End Select
        End With
      Next
      
    Case csEDT_Cobranza
      For Each IProperty In m_ObjAbm.Properties
        With IProperty
          Select Case .Key
            Case K_DOC_ID_ASIENTO
              fields.Add2 cscDocIdAsiento, .HelpId, csId
            Case K_TA_ID
              fields.Add2 cscTaId, .HelpId, csId
            Case K_ESCOBCHEQUESGR
              fields.Add2 cscDocEsCobChequeSgr, .Value, csBoolean
            Case K_ESCOBCAIDASGR
              fields.Add2 cscDocEsCobCaidaSgr, .Value, csBoolean
          End Select
        End With
      Next
    
    Case csEDT_TrasferenciaStock                             ' Trasferencia de Stock
      For Each IProperty In m_ObjAbm.Properties
        With IProperty
          Select Case .Key
            Case K_TA_ID
              fields.Add2 cscTaId, .HelpId, csId
            Case K_ST_CONSUMO
              fields.Add2 cscDocStConsumo, Val(.Value), csBoolean
          End Select
        End With
      Next
    
    Case csEDT_ParteReparacion
      For Each IProperty In m_ObjAbm.Properties
        With IProperty
          Select Case .Key
            Case K_TA_ID
              fields.Add2 cscTaId, .HelpId, csId
            Case K_MON_ID
              fields.Add2 cscMonId, .HelpId, csId
            Case K_DOC_ID_STOCK
              fields.Add2 cscDocIdStock, .HelpId, csId
          End Select
        End With
      Next
    
    Case csEDT_RecuentoStock, csEDT_ParteProdKit, csEDT_ParteDesarmeKit, _
         csEDT_StockProveedor, csEDT_StockCliente ' Recuento de Stock
      For Each IProperty In m_ObjAbm.Properties
        With IProperty
          Select Case .Key
            Case K_TA_ID
              fields.Add2 cscTaId, .HelpId, csId
            Case K_DOC_ID_STOCK
              fields.Add2 cscDocIdStock, .HelpId, csId
          End Select
        End With
      Next
    
    Case csEDT_OrdenProdKit
      For Each IProperty In m_ObjAbm.Properties
        With IProperty
          Select Case .Key
            Case K_TA_ID
              fields.Add2 cscTaId, .HelpId, csId
          End Select
        End With
      Next
    
    Case csEDT_AsientoContable                               ' Asiento Contable
      For Each IProperty In m_ObjAbm.Properties
        With IProperty
          Select Case .Key
            Case K_TA_ID
              fields.Add2 cscTaId, .HelpId, csId
          End Select
        End With
      Next
    Case csEDT_OrdenPago                               ' Orden de Pago
      For Each IProperty In m_ObjAbm.Properties
        With IProperty
          Select Case .Key
            Case K_DOC_ID_ASIENTO
              fields.Add2 cscDocIdAsiento, .HelpId, csId
            Case K_TA_ID
              fields.Add2 cscTaId, .HelpId, csId
          End Select
        End With
      Next
    Case csEDT_PresupuestoEnvio
      For Each IProperty In m_ObjAbm.Properties
        With IProperty
          Select Case .Key
            Case K_TA_ID
              fields.Add2 cscTaId, .HelpId, csId
            Case K_MON_ID
              fields.Add2 cscMonId, .HelpId, csId
          End Select
        End With
      Next
  End Select
End Sub

Private Function cIABMClient_Terminate() As Boolean
    m_Editing = False
    
    If Not m_Activo Then
      MsgInfo LNGGetText(3528, vbNullString) ' Este documento esta inactivo y por lo tanto no podra usarlo para generar transacciones.
    End If
    
    cIABMClient_Terminate = True
    ' Este objeto puede no cumplir con la interfaz esperada, asi que si hay un error no
    ' le doy bola
    On Error GoTo ControlError
    If m_Id = csNO_ID Then Exit Function
    If m_ObjTree Is Nothing Then Exit Function
    
    If m_IsNew Then
        m_ObjTree.AddLeave m_Id, m_BranchId, m_TreeId
    Else
        m_ObjTree.AddEditedId m_Id
        m_ObjTree.RefreshActiveBranch
    End If
ControlError:
End Function

Private Property Get cIABMClient_Title() As String
    cIABMClient_Title = LNGGetText(1611, vbNullString) 'Documentos
End Property

Private Function cIABMClient_Validate() As Boolean
  cIABMClient_Validate = pValidate(False)
End Function

Private Function pValidate(ByVal bSilent As Boolean) As Boolean
  Dim IProperty As cIABMProperty

  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_NOMBRE
          If ValEmpty(.Value, csText) Then
            If Not bSilent Then MsgInfo LNGGetText(1007, vbNullString)  'Debe indicar un nombre
            Exit Function
          End If
        Case K_CODIGO
          If ValEmpty(.Value, csText) Then
            If Not bSilent Then MsgInfo LNGGetText(1008, vbNullString)  'Debe indicar un código
            Exit Function
          End If
        Case K_EMP_ID
          If ValEmpty(.HelpId, csId) Then
            If Not bSilent Then MsgInfo LNGGetText(1129, vbNullString)  'Debe indicar una empresa
            Exit Function
          End If
        Case K_CICO_ID
          If ValEmpty(.HelpId, csId) Then
            If Not bSilent Then MsgInfo LNGGetText(1974, vbNullString)  'Debe indicar un circuito contable
            Exit Function
          End If
        Case K_DOCT_ID
          If ValEmpty(.HelpId, csId) Then
            If Not bSilent Then MsgInfo LNGGetText(2560, vbNullString)  'Debe indicar un Tipo de Documento
            Exit Function
          End If
        Case K_FCA_ID
          If ValEmpty(.HelpId, csId) Then
            If Not bSilent Then MsgInfo LNGGetText(3526, vbNullString)  'Debe indicar una fecha de control de acceso
            Exit Function
          End If
      End Select
    End With
  Next

  pValidate = pValidateEx(bSilent)
End Function

Private Function pValidateEx(ByVal bSilent As Boolean) As Boolean
  Dim IProperty     As cIABMProperty
  Dim bGeneraRto    As Boolean
  Dim bDocRto       As Boolean
  Dim bGeneraStock  As Boolean
  Dim bDocStock     As Boolean
      
  Select Case m_Doct_id
    Case csEDT_FacturaVenta, csEDT_NotaCreditoVenta, csEDT_NotaDebitoVenta
      For Each IProperty In m_ObjAbm.Properties
        With IProperty
          Select Case .Key
            
            Case K_TA_ID_EXTERNO
              If ValEmpty(.HelpId, csId) Then
                If Not bSilent Then MsgInfo LNGGetText(2561, vbNullString)  'Debe indicar un Talonario Externo
                Exit Function
              End If
            
            Case K_TA_ID_FINAL
              If ValEmpty(.HelpId, csId) Then
                If Not bSilent Then MsgInfo LNGGetText(2562, vbNullString)  'Debe indicar un Talonario Exento/Mono/C.F.
                Exit Function
              End If
            
            Case K_TA_ID_INSCRIPTO
              If ValEmpty(.HelpId, csId) Then
                If Not bSilent Then MsgInfo LNGGetText(2563, vbNullString)  'Debe indicar un Talonario Inscripto
                Exit Function
              End If
            
            Case K_DOC_ID_ASIENTO
              If ValEmpty(.HelpId, csId) Then
                If Not bSilent Then MsgInfo LNGGetText(2564, vbNullString)  'Debe indicar un Documento para guardar el Asiento Contable
                Exit Function
              End If
            
            Case K_GENERA_REMITO
              bGeneraRto = Val(.Value)
            
            Case K_MUEVE_STOCK
              bGeneraStock = Val(.Value)
            
            Case K_DOC_ID_REMITO
              bDocRto = Not ValEmpty(.HelpId, csId)
            
            Case K_DOC_ID_STOCK
              bDocStock = Not ValEmpty(.HelpId, csId)
            
            Case K_MON_ID
              If ValEmpty(.HelpId, csId) Then
                If Not bSilent Then MsgInfo LNGGetText(1108, vbNullString)  'Debe indicar una moneda
                Exit Function
              End If
              
            Case K_CUEG_ID
              If ValEmpty(.HelpId, csId) Then
                If Not bSilent Then MsgInfo LNGGetText(2565, vbNullString)  'Debe indicar un Grupo de Cuentas
                Exit Function
              End If
              
          End Select
        End With
      Next
    Case csEDT_FacturaCompra, csEDT_NotaCreditoCompra, csEDT_NotaDebitoCompra
      For Each IProperty In m_ObjAbm.Properties
        With IProperty
          Select Case .Key
            
            Case K_TA_ID_EXTERNO
              If ValEmpty(.HelpId, csId) Then
                If Not bSilent Then MsgInfo LNGGetText(2561, vbNullString)  'Debe indicar un talonario externo
                Exit Function
              End If
            
            Case K_TA_ID_FINAL
              If ValEmpty(.HelpId, csId) Then
                If Not bSilent Then MsgInfo LNGGetText(2562, vbNullString)  'Debe indicar un talonario exento/mono/C.F.
                Exit Function
              End If
            
            Case K_TA_ID_INSCRIPTO
              If ValEmpty(.HelpId, csId) Then
                If Not bSilent Then MsgInfo LNGGetText(2563, vbNullString)  'Debe indicar un talonario inscripto
                Exit Function
              End If
            
            Case K_TA_ID_INSCRIPTOM
              If ValEmpty(.HelpId, csId) Then
                If Not bSilent Then MsgInfo LNGGetText(2566, vbNullString)  'Debe indicar un Talonario Inscripto M
                Exit Function
              End If
            
            Case K_DOC_ID_ASIENTO
              If ValEmpty(.HelpId, csId) Then
                If Not bSilent Then MsgInfo LNGGetText(2564, vbNullString)  'Debe indicar un documento para guardar el asiento contable
                Exit Function
              End If
            
            Case K_MON_ID
              If ValEmpty(.HelpId, csId) Then
                If Not bSilent Then MsgInfo LNGGetText(1108, vbNullString)  'Debe indicar una moneda
                Exit Function
              End If
              
          End Select
        End With
      Next
    
    Case csEDT_RemitoVenta, csEDT_DevolucionRemitoVta
      For Each IProperty In m_ObjAbm.Properties
        With IProperty
          Select Case .Key
            
            Case K_TA_ID
              If ValEmpty(.HelpId, csId) Then
                If Not bSilent Then MsgInfo LNGGetText(1250, vbNullString)  'Debe indicar un talonario
                Exit Function
              End If
            
            Case K_MON_ID
              If ValEmpty(.HelpId, csId) Then
                If Not bSilent Then MsgInfo LNGGetText(1108, vbNullString)  'Debe indicar una moneda
                Exit Function
              End If
              
          End Select
        End With
      Next
      
    Case csEDT_PermisoEmbarque
      For Each IProperty In m_ObjAbm.Properties
        With IProperty
          Select Case .Key
            
            Case K_MON_ID
              If ValEmpty(.HelpId, csId) Then
                If Not bSilent Then MsgInfo LNGGetText(1108, vbNullString)  'Debe indicar una moneda
                Exit Function
              End If
              
          End Select
        End With
      Next
    
    Case csEDT_ManifiestoCarga
      For Each IProperty In m_ObjAbm.Properties
        With IProperty
          Select Case .Key
            
            Case K_TA_ID
              If ValEmpty(.HelpId, csId) Then
                If Not bSilent Then MsgInfo LNGGetText(1250, vbNullString)  'Debe indicar un talonario
                Exit Function
              End If
            
          End Select
        End With
      Next
    
    Case csEDT_PackingList, csEDT_PackingListDevolucion
      For Each IProperty In m_ObjAbm.Properties
        With IProperty
          Select Case .Key
            
            Case K_TA_ID
              If ValEmpty(.HelpId, csId) Then
                If Not bSilent Then MsgInfo LNGGetText(1250, vbNullString)  'Debe indicar un talonario
                Exit Function
              End If
            
          End Select
        End With
      Next
    
    Case csEDT_OrdenServicio
      For Each IProperty In m_ObjAbm.Properties
        With IProperty
          Select Case .Key
            
            Case K_TA_ID
              If ValEmpty(.HelpId, csId) Then
                If Not bSilent Then MsgInfo LNGGetText(1250, vbNullString)  'Debe indicar un talonario
                Exit Function
              End If
            
            Case K_MON_ID
              If ValEmpty(.HelpId, csId) Then
                If Not bSilent Then MsgInfo LNGGetText(1108, vbNullString)  'Debe indicar una moneda
                Exit Function
              End If
              
          End Select
        End With
      Next
    
    Case csEDT_RemitoCompra, csEDT_DevolucionRemitoCpra
      For Each IProperty In m_ObjAbm.Properties
        With IProperty
          Select Case .Key
            
            Case K_TA_ID
              If ValEmpty(.HelpId, csId) Then
                If Not bSilent Then MsgInfo LNGGetText(1250, vbNullString)  'Debe indicar un talonario
                Exit Function
              End If
            
            Case K_MON_ID
              If ValEmpty(.HelpId, csId) Then
                If Not bSilent Then MsgInfo LNGGetText(1108, vbNullString)  'Debe indicar una moneda
                Exit Function
              End If
              
          End Select
        End With
      Next
    
    Case csEDT_ImportacionTemp
      
      bGeneraStock = True
      
      For Each IProperty In m_ObjAbm.Properties
        With IProperty
          Select Case .Key
            
            Case K_TA_ID
              If ValEmpty(.HelpId, csId) Then
                If Not bSilent Then MsgInfo LNGGetText(1250, vbNullString)  'Debe indicar un talonario
                Exit Function
              End If
            
            Case K_MON_ID
              If ValEmpty(.HelpId, csId) Then
                If Not bSilent Then MsgInfo LNGGetText(1108, vbNullString)  'Debe indicar una moneda
                Exit Function
              End If
              
          End Select
        End With
      Next
    
    Case csEDT_PedidoVenta, csEDT_DevolucionPedidoVta, _
         csEDT_PedidoCompra, csEDT_DevolucionPedidoCpra, _
         csEDT_PresupuestoVenta, csEDT_DevolucionPresuVta, _
         csEDT_PresupuestoCompra, csEDT_DevolucionPresuCpra, _
         csEDT_CotizacionCompra, csEDT_DevolucionCotizacionCpra, _
         csEDT_OrdenCompra, csEDT_DevolucionOrdenCpra
         
      For Each IProperty In m_ObjAbm.Properties
        With IProperty
          Select Case .Key
            
            Case K_TA_ID
              If ValEmpty(.HelpId, csId) Then
                If Not bSilent Then MsgInfo LNGGetText(1250, vbNullString)  'Debe indicar un talonario
                Exit Function
              End If
            
            Case K_MON_ID
              If ValEmpty(.HelpId, csId) Then
                If Not bSilent Then MsgInfo LNGGetText(1108, vbNullString)  'Debe indicar una moneda
                Exit Function
              End If
              
          End Select
        End With
      Next
    
    Case csEDT_Cobranza
      For Each IProperty In m_ObjAbm.Properties
        With IProperty
          Select Case .Key
            
            Case K_TA_ID
              If ValEmpty(.HelpId, csId) Then
                If Not bSilent Then MsgInfo LNGGetText(1250, vbNullString)  'Debe indicar un talonario
                Exit Function
              End If
            Case K_DOC_ID_ASIENTO
              If ValEmpty(.HelpId, csId) Then
                If Not bSilent Then MsgInfo LNGGetText(2564, vbNullString)  'Debe indicar un documento para guardar el asiento contable
                Exit Function
              End If
          End Select
        End With
      Next
    
    Case csEDT_TrasferenciaStock
      For Each IProperty In m_ObjAbm.Properties
        With IProperty
          Select Case .Key
            
            Case K_TA_ID
              If ValEmpty(.HelpId, csId) Then
                If Not bSilent Then MsgInfo LNGGetText(1250, vbNullString)  'Debe indicar un talonario
                Exit Function
              End If
          End Select
        End With
      Next
    
    Case csEDT_ParteReparacion
      For Each IProperty In m_ObjAbm.Properties
        With IProperty
          Select Case .Key
            
            Case K_TA_ID
              If ValEmpty(.HelpId, csId) Then
                If Not bSilent Then MsgInfo LNGGetText(1250, vbNullString)  'Debe indicar un talonario
                Exit Function
              End If
            
            Case K_DOC_ID_STOCK
              If ValEmpty(.HelpId, csId) Then
                If Not bSilent Then MsgInfo LNGGetText(2567, vbNullString)  'Debe indicar un Documento para generar el Movimiento de Stock
                Exit Function
              End If
          
            Case K_MON_ID
              If ValEmpty(.HelpId, csId) Then
                If Not bSilent Then MsgInfo LNGGetText(1108, vbNullString)  'Debe indicar una moneda
                Exit Function
              End If
          End Select
        End With
      Next
    
    Case csEDT_OrdenProdKit
      For Each IProperty In m_ObjAbm.Properties
        With IProperty
          Select Case .Key
            
            Case K_TA_ID
              If ValEmpty(.HelpId, csId) Then
                If Not bSilent Then MsgInfo LNGGetText(1250, vbNullString)  'Debe indicar un talonario
                Exit Function
              End If
          End Select
        End With
      Next
    
    Case csEDT_RecuentoStock, csEDT_ParteProdKit, csEDT_ParteDesarmeKit, _
         csEDT_StockProveedor, csEDT_StockCliente
      For Each IProperty In m_ObjAbm.Properties
        With IProperty
          Select Case .Key
            
            Case K_TA_ID
              If ValEmpty(.HelpId, csId) Then
                If Not bSilent Then MsgInfo LNGGetText(1250, vbNullString)  'Debe indicar un talonario
                Exit Function
              End If
            
            Case K_DOC_ID_STOCK
              If ValEmpty(.HelpId, csId) Then
                If Not bSilent Then MsgInfo LNGGetText(2567, vbNullString)  'Debe indicar un documento para generar el movimiento de stock
                Exit Function
              End If
          End Select
        End With
      Next
    
    Case csEDT_AsientoContable
      For Each IProperty In m_ObjAbm.Properties
        With IProperty
          Select Case .Key
            
            Case K_TA_ID
              If ValEmpty(.HelpId, csId) Then
                If Not bSilent Then MsgInfo LNGGetText(1250, vbNullString)  'Debe indicar un talonario
                Exit Function
              End If
          End Select
        End With
      Next
    
    Case csEDT_Liquidacion
      For Each IProperty In m_ObjAbm.Properties
        With IProperty
          Select Case .Key
            
            Case K_TA_ID
              If ValEmpty(.HelpId, csId) Then
                If Not bSilent Then MsgInfo LNGGetText(1250, vbNullString)  'Debe indicar un talonario
                Exit Function
              End If
            Case K_TA_ID_HABERES
              If ValEmpty(.HelpId, csId) Then
                If Not bSilent Then MsgInfo LNGGetText(4640, vbNullString)  'Debe indicar un talonario para los recibos de haberes
                Exit Function
              End If
            Case K_DOC_ID_ASIENTO
              If ValEmpty(.HelpId, csId) Then
                If Not bSilent Then MsgInfo LNGGetText(2564, vbNullString)  'Debe indicar un documento para guardar el asiento contable
                Exit Function
              End If
          End Select
        End With
      Next
    
    Case csEDT_OrdenPago, csEDT_MovimientoFondo, _
         csEDT_DepositoBanco, csEDT_DepositoCupon, csEDT_ResolucionCupon
         
      For Each IProperty In m_ObjAbm.Properties
        With IProperty
          Select Case .Key
            
            Case K_TA_ID
              If ValEmpty(.HelpId, csId) Then
                If Not bSilent Then MsgInfo LNGGetText(1250, vbNullString)  'Debe indicar un talonario
                Exit Function
              End If
            Case K_DOC_ID_ASIENTO
              If ValEmpty(.HelpId, csId) Then
                If Not bSilent Then MsgInfo LNGGetText(2564, vbNullString)  'Debe indicar un documento para guardar el asiento contable
                Exit Function
              End If
          End Select
        End With
      Next
  
    Case csEDT_PresupuestoEnvio
      For Each IProperty In m_ObjAbm.Properties
        With IProperty
          Select Case .Key
            
            Case K_TA_ID
              If ValEmpty(.HelpId, csId) Then
                If Not bSilent Then MsgInfo LNGGetText(1250, vbNullString)  'Debe indicar un talonario
                Exit Function
              End If
            
            Case K_MON_ID
              If ValEmpty(.HelpId, csId) Then
                If Not bSilent Then MsgInfo LNGGetText(1108, vbNullString)  'Debe indicar una moneda
                Exit Function
              End If
              
          End Select
        End With
      Next
  End Select
  
  
  If bGeneraRto And Not bDocRto Then
    If Not bSilent Then MsgInfo LNGGetText(2568, vbNullString)  'Debe indicar un Documento para generar el Remito
    Exit Function
  End If
                
  If bGeneraStock And Not bDocStock Then
    If Not bSilent Then MsgInfo LNGGetText(2567, vbNullString)  'Debe indicar un documento para generar el movimiento de stock
    Exit Function
  End If
  
  pValidateEx = True
End Function

Private Function cIABMClientGrid_ColumnAfterEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long) As Boolean
  cIABMClientGrid_ColumnAfterEdit = True
End Function

Private Function cIABMClientGrid_ColumnAfterUpdate(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long) As Boolean
  Select Case Key
    Case K_REPORTES
      Dim Row As cIABMGridRow
      With m_ObjAbm.Properties.Item("Reportes").Grid
      
        If .Columns(lCol).Key = KI_CSRFILE Then
        
          Dim FileEx As CSKernelFile.cFileEx
          Set FileEx = New CSKernelFile.cFileEx
          
          Set Row = .Rows(lRow)
          pCell(Row, KI_CSRFILE).Value = FileEx.FileGetName(pCell(Row, KI_CSRFILE).Value)
        End If
      End With
  End Select
  cIABMClientGrid_ColumnAfterUpdate = True
End Function

Private Function cIABMClientGrid_ColumnBeforeEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean
  cIABMClientGrid_ColumnBeforeEdit = True
End Function

Private Function cIABMClientGrid_ColumnButtonClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean
  cIABMClientGrid_ColumnButtonClick = True
End Function

Private Sub cIABMClientGrid_ColumnCancelEdit(ByVal Key As Integer)

End Sub

Private Sub cIABMClientGrid_ColumnClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Sub cIABMClientGrid_DblClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Function cIABMClientGrid_DeleteRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal lRow As Long) As Boolean
  Dim Id As Long
  
  Select Case Key
  
    Case K_FIRMAS
      Id = Val(pCell(Row, KI_DOCFR_ID).Value)
      If Id <> csNO_ID Then m_FirmasDeleted = m_FirmasDeleted & Id & ","
  
    Case K_REPORTES
      Id = Val(pCell(Row, KI_RPTF_ID).Value)
      If Id <> csNO_ID Then m_ItemsDeletedReportes = m_ItemsDeletedReportes & Id & ","
  
  End Select
  
  cIABMClientGrid_DeleteRow = True
End Function

Private Function cIABMClientGrid_IsEmptyRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_REPORTES
      cIABMClientGrid_IsEmptyRow = pIsEmptyRow(Row, RowIndex)
    Case K_FIRMAS
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowFirmas(Row, RowIndex)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ValidateRow", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIABMClientGrid_ListAdHock(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal ColIndex As Long, List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClientGrid_NewRow(ByVal Key As Integer, ByVal Rows As Integer)

End Sub

Private Function cIABMClientGrid_ValidateRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_REPORTES
      cIABMClientGrid_ValidateRow = pValidateRowReportes(Row, RowIndex)
    Case K_FIRMAS
      cIABMClientGrid_ValidateRow = pValidateRowFirmas(Row, RowIndex)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ValidateRow", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

' Implementacion de cIEditGeneric
Private Property Get cIEditGeneric_ObjAbm() As CSInterfacesABM.cIABMGeneric
  Set cIEditGeneric_ObjAbm = m_ObjAbm
End Property

Private Function cIEditGeneric_TabClick(ByVal Index As Integer) As Boolean

End Function

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
  cIEditGeneric_ShowList = SecurityCanAccess(csPreDListDocumento)
End Function

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
  Set m_ObjAbm = rhs
End Property

Private Property Get cIEditGeneric_Editing() As Boolean
  cIEditGeneric_Editing = m_Editing
End Property

Private Function cIEditGeneric_Delete(Id As Long) As Boolean
  If Not SecurityCanAccess(csPreDDeleteDocumento) Then Exit Function

  Dim sqlstmt As String
  
  sqlstmt = "sp_DocumentoDelete " & Id
  
  cIEditGeneric_Delete = gDB.Execute(sqlstmt, "cIEditGeneric_Delete", C_Module)
End Function

Private Function cIEditGeneric_Search(Id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Id = csNO_ID Then
    m_IsNew = True
    If Not SecurityCanAccess(csPreDNewDocumento) Then Exit Function
  Else
    m_IsNew = False
    If Not SecurityCanAccess(csPreDEditDocumento) Then Exit Function
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

Private Property Let cIEditGeneric_BranchId(ByVal rhs As Long)
  m_BranchId = rhs
End Property

Private Property Get cIEditGeneric_BranchId() As Long
  cIEditGeneric_BranchId = m_BranchId
End Property

Private Function cIEditGeneric_Preview(ByVal Id As Long) As Boolean

End Function

Private Function cIEditGeneric_PropertyChange(ByVal Key As Integer) As Boolean

End Function

Private Function cIMenuClient_Initialize(F As Object, Host As CSMenu.cIMenuHost) As Boolean
  On Error GoTo ControlError
  Dim str_2569 As String
  
  str_2569 = LNGGetText(2569, vbNullString) '&Documentos
  Set m_Host = Host
                                                          'Co&nfiguración
  m_Host.Server.AddMenu str_2569, csMenuConfigDocumentos, LNGGetText(1028, vbNullString), 0, True, False, True, False, True, Nothing
  m_Host.Server.AddMenu LNGGetText(2570, vbNullString), csPreDListDocumento, str_2569, 0, True, False, False, False, False, Me
                        'D&ocumentos
  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, "cIMenuClient_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal Id As Long) As Variant
  m_Host.MenuABMClick "CSDocumentoEdit.cDocumento", Me, LNGGetText(1611, vbNullString), 0, csETablasDocumento.CSDocumento
                                                        'Documentos
End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  AbmObj.MinHeight = 7600

  m_TopDescrip = 3640
  
  With m_ObjAbm
    .Tabs.Clear
    .Title2 = m_Nombre
  End With

  With m_ObjAbm.Properties
  
    .Clear
    
    With .Add(Nothing, cscDoctId)
      .PropertyType = cspHelp
      .Table = csDocumentoTipo
      .Name = LNGGetText(2366, vbNullString)  'Tipo de Documento
      .Key = K_DOCT_ID
      .Value = m_DocumentoTipo
      .HelpId = m_Doct_id
    End With
    
    With .Add(Nothing, cscEmpId)
      .PropertyType = cspHelp
      .Table = csEmpresa
      .Name = LNGGetText(1114, vbNullString)  'Empresa
      .Key = K_EMP_ID
      .TopFromProperty = cscDoctId
      .LeftNotChange = True
      .Left = 8600
      .Value = m_Empresa
      .HelpId = m_emp_id
    End With
    
    With .Add(Nothing, cscCicoId)
      .PropertyType = cspHelp
      .Table = csCircuitoContable
      .Name = LNGGetText(1073, vbNullString)  'Circuito Contable
      .Key = K_CICO_ID
      .Value = m_CircuitoContable
      .HelpId = m_Cico_id
    End With
      
    With .Add(Nothing, cscDocNombre)
      .PropertyType = cspText
      .Name = C_strNombre
      .Size = 255
      .Key = K_NOMBRE
      .Value = m_Nombre
      .Width = 5000
    End With
      
    With .Add(Nothing, cscDocCodigo)
      .PropertyType = cspText
      .Name = C_strCodigo
      .Size = 50
      .Key = K_CODIGO
      .Value = m_Codigo
      .Width = 2320
    End With
      
    With .Add(Nothing, cscActivo)
      .PropertyType = cspCheck
      .Name = C_strActivo
      .Key = K_ACTIVO
      .Value = CInt(m_Activo)
    End With
      
    With .Add(Nothing, cscDocEditarImpresos)
      .PropertyType = cspCheck
      .Name = LNGGetText(3482, vbNullString)  'Permitir la edición de comprobantes impresos
      .Key = K_EDITAR_IMPRESOS
      .Left = 3840
      .LeftLabel = -3500
      .LeftNotChange = True
      .Value = CInt(m_EditarImpresos)
    End With
      
    With .Add(Nothing, cscFcaId)
      .PropertyType = cspHelp
      .TopFromProperty = cscCicoId
      .Left = 8600
      .Table = csFechaControlAcceso
      .Name = LNGGetText(2571, vbNullString)  'Fecha Control de Acceso
      .Key = K_FCA_ID
      .Value = m_FechaControlAcceso
      .HelpId = m_Fca_id
    End With
      
    pSetTipoDoc
      
    With .Add(Nothing, cscDocDescrip)
      .PropertyType = cspText
      .Name = C_strDescrip
      .Size = 5000
      .Key = K_DESCRIP
      .LeftFromProperty = cscDocNombre
      .Top = m_TopDescrip
      .Height = 880
      .Width = 9300
      .SubType = cspMemo
      .Value = m_Descrip
    End With
  
    With .Add(Nothing, cscDocObjectEdit)
      .PropertyType = cspText
      .Name = LNGGetText(2775, vbNullString)  'Objeto Edición
      .Key = K_DOC_EDIT_OBJECT
      .Value = m_object_edit
      .Width = 9300
    End With
  
  End With
  
  m_ItemsDeletedReportes = vbNullString
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

Private Function Load(ByVal Id As Long) As Boolean

  Dim sqlstmt As String

  sqlstmt = "sp_DocumentoGet " & Id
  
  Dim rs As Recordset

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.fields, cscDocId)
    m_Nombre = gDB.ValField(rs.fields, cscDocNombre)
    m_Codigo = gDB.ValField(rs.fields, cscDocCodigo)
    m_Descrip = gDB.ValField(rs.fields, cscDocDescrip)
    m_Doct_id = gDB.ValField(rs.fields, cscDoctId)
    m_DocumentoTipo = gDB.ValField(rs.fields, cscDoctNombre)
    m_Cico_id = gDB.ValField(rs.fields, cscCicoId)
    m_CircuitoContable = gDB.ValField(rs.fields, cscCicoNombre)
    m_Creado = gDB.ValField(rs.fields, cscCreado)
    m_Modificado = gDB.ValField(rs.fields, cscModificado)
    m_Modifico = gDB.ValField(rs.fields, cscModifico)
    m_LlevaFirma = gDB.ValField(rs.fields, cscDocLlevaFirma)
    
    m_EsResumenBco = gDB.ValField(rs.fields, cscDocEsResumenBco)
    m_EsCreditoBanco = gDB.ValField(rs.fields, cscDocEsCreditobanco)
    m_EsVentaAccion = gDB.ValField(rs.fields, cscDocEsVentaAccion)
    m_EsVentaCheque = gDB.ValField(rs.fields, cscDocEsVentaCheque)
    m_EsCobChequesgr = gDB.ValField(rs.fields, cscDocEsCobChequeSgr)
    m_EsCobCaidasgr = gDB.ValField(rs.fields, cscDocEsCobCaidaSgr)
    
    m_LlevaFirmaCredito = gDB.ValField(rs.fields, cscDocLlevaFirmaCredito)
    m_LlevaFirmaPrint0 = gDB.ValField(rs.fields, cscDocLlevaFirmaPrint0)
    m_TipoFactura = gDB.ValField(rs.fields, cscDocTipoFactura)
    m_TipoPackingList = gDB.ValField(rs.fields, cscDocTipoPackingList)
    m_TipoOrdenCompra = gDB.ValField(rs.fields, cscDocTipoOrdenCompra)
    
    m_RvDesdePv = gDB.ValField(rs.fields, cscDocRvDesdePv)
    m_RvDesdeOs = gDB.ValField(rs.fields, cscDocRvDesdeOs)
    m_RcDesdeOc = gDB.ValField(rs.fields, cscDocRcDesdeOc)
    m_RcDespachoImpo = gDB.ValField(rs.fields, cscDocRcDespachoImpo)
    m_RvBom = gDB.ValField(rs.fields, cscDocRvBom)
    m_PvDesdePrv = gDB.ValField(rs.fields, cscDocPvDesdePrv)
    
    m_Fv_SinPercepcion = gDB.ValField(rs.fields, cscDocFvSinPercepcion)
    m_esFacturaElectronica = gDB.ValField(rs.fields, cscDocesFacturaElectronica)
    
    m_StConsumo = gDB.ValField(rs.fields, cscDocStConsumo)

    m_FechaControlAcceso = gDB.ValField(rs.fields, cscFcaNombre)
    m_Fca_id = gDB.ValField(rs.fields, cscFcaId)
    
    m_ta_id = gDB.ValField(rs.fields, cscTaId)
    m_Talonario = gDB.ValField(rs.fields, cscTaNombre)
    
    m_ta_id_Externo = gDB.ValField(rs.fields, cscTaIdExterno)
    m_TalonarioExterno = gDB.ValField(rs.fields, "taExterno")
    
    m_ta_id_Final = gDB.ValField(rs.fields, cscTaIdFinal)
    m_TalonarioFinal = gDB.ValField(rs.fields, "taFinal")
    
    m_ta_id_Inscripto = gDB.ValField(rs.fields, cscTaIdInscripto)
    m_TalonarioInscripto = gDB.ValField(rs.fields, "taInscripto")
    
    m_ta_id_InscriptoM = gDB.ValField(rs.fields, cscTaIdInscriptoM)
    m_TalonarioInscriptoM = gDB.ValField(rs.fields, "taInscriptoM")
    
    m_ta_id_Haberes = gDB.ValField(rs.fields, cscTaIdHaberes)
    m_TalonarioHaberes = gDB.ValField(rs.fields, "taHaberes")
    
    m_Doc_id_Asiento = gDB.ValField(rs.fields, cscDocIdAsiento)
    m_DocumentoAsiento = gDB.ValField(rs.fields, "docAsiento")
    
    m_mon_id = gDB.ValField(rs.fields, cscMonId)
    m_Moneda = gDB.ValField(rs.fields, cscMonNombre)
    
    m_cueg_id = gDB.ValField(rs.fields, cscCuegId)
    m_CuentaGrupo = gDB.ValField(rs.fields, cscCuegNombre)
    
    m_GeneraRemito = gDB.ValField(rs.fields, cscDocGeneraRemito)
    m_MueveStock = gDB.ValField(rs.fields, cscDocMueveStock)
    
    m_Doc_id_Remito = gDB.ValField(rs.fields, cscDocIdRemito)
    m_DocumentoRemito = gDB.ValField(rs.fields, "docRemito")
    
    m_Doc_id_Stock = gDB.ValField(rs.fields, cscDocIdStock)
    m_DocumentoStock = gDB.ValField(rs.fields, "docStock")
    
    m_emp_id = gDB.ValField(rs.fields, cscEmpId)
    m_Empresa = gDB.ValField(rs.fields, cscEmpNombre)
    
    m_Activo = gDB.ValField(rs.fields, cscActivo)
    m_EditarImpresos = gDB.ValField(rs.fields, cscDocEditarImpresos)

    m_docg_id = gDB.ValField(rs.fields, cscDocgId)
    m_DocumentoGrupo = gDB.ValField(rs.fields, cscDocgNombre)
    
    m_object_edit = gDB.ValField(rs.fields, cscDocObjectEdit)

  Else
    m_Id = csNO_ID
    m_Nombre = vbNullString
    m_Codigo = vbNullString
    m_Descrip = vbNullString
    m_Doct_id = csNO_ID
    m_DocumentoTipo = vbNullString
    m_Creado = csNoDate
    m_Modificado = csNoDate
    m_Modifico = 0
    m_LlevaFirma = False
    m_EsResumenBco = False
    m_EsCreditoBanco = False
    m_EsVentaAccion = False
    m_EsVentaCheque = False
    m_EsCobChequesgr = False
    m_EsCobCaidasgr = False
    m_LlevaFirmaCredito = False
    m_LlevaFirmaPrint0 = False
    m_RvDesdePv = False
    m_RvDesdeOs = False
    m_RvBom = False
    m_PvDesdePrv = False
    m_Fv_SinPercepcion = False
    m_esFacturaElectronica = False
    m_RcDesdeOc = False
    m_RcDespachoImpo = False
    m_TipoFactura = csETFacDirecta
    m_TipoPackingList = csETPackManifiesto
    m_TipoOrdenCompra = csETOrdenDirecta
    m_Cico_id = csNO_ID
    m_CircuitoContable = vbNullString
    m_StConsumo = False
    
    m_FechaControlAcceso = vbNullString
    m_Fca_id = csNO_ID
    
    m_ta_id = csNO_ID
    m_Talonario = vbNullString
    
    m_mon_id = csNO_ID
    m_Moneda = vbNullString
    
    m_cueg_id = csNO_ID
    m_CuentaGrupo = vbNullString
    
    m_ta_id_Externo = csNO_ID
    m_TalonarioExterno = vbNullString
    
    m_ta_id_Final = csNO_ID
    m_TalonarioFinal = vbNullString
    
    m_ta_id_Inscripto = csNO_ID
    m_TalonarioInscripto = vbNullString
    
    m_ta_id_InscriptoM = csNO_ID
    m_TalonarioInscriptoM = vbNullString
    
    m_ta_id_Haberes = csNO_ID
    m_TalonarioHaberes = vbNullString
    
    m_Doc_id_Asiento = csNO_ID
    m_DocumentoAsiento = vbNullString
    
    m_GeneraRemito = False
    m_MueveStock = False
    
    m_Doc_id_Remito = csNO_ID
    m_DocumentoRemito = vbNullString
    
    m_Doc_id_Stock = csNO_ID
    m_DocumentoStock = vbNullString
    
    m_emp_id = csNO_ID
    m_Empresa = vbNullString
    
    m_Activo = True
    m_EditarImpresos = False
    
    m_docg_id = csNO_ID
    m_DocumentoGrupo = vbNullString
    
    m_object_edit = vbNullString
    
  End If

  Load = True
End Function

Private Function pLoadFirmas(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  
  Dim rs As ADODB.Recordset
  
  sqlstmt = "select DocumentoFirma.*, us_nombre" & _
            " from DocumentoFirma, usuario" & _
              " where doc_id = " & m_Id & _
                " and DocumentoFirma.us_id = usuario.us_id"
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadFirmas", C_Module) Then Exit Function
  
  Dim o As cIABMGridColumn
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  'TODO VER JAVIER
  o.Name = "docfr_id"
  o.Visible = False
  o.Key = KI_DOCFR_ID
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = LNGGetText(1137, vbNullString) 'Usuario
  o.PropertyType = cspHelp
  o.Table = csUsuario
  o.Width = 3500
  o.Key = KI_US_ID
  
  Dim F  As cIABMGridRow
  Dim fv As cIABMGridCellValue
  
  While Not rs.EOF
  
    Set F = Propiedad.Grid.Rows.Add(Nothing, rs(cscdocfrId).Value)
    
    Set fv = F.Add(Nothing)
    fv.Value = rs(cscdocfrId).Value
    fv.Key = KI_DOCFR_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscUsNombre)
    fv.Id = gDB.ValField(rs.fields, cscUsId)
    fv.Key = KI_US_ID
    
    rs.MoveNext
  Wend
  
  pLoadFirmas = True
End Function

Private Function pLoadReportes(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  
  Dim rs As ADODB.Recordset
  
  sqlstmt = "select ReporteFormulario.*" & _
            " from ReporteFormulario" & _
              " where doc_id = " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadReportes", C_Module) Then Exit Function
  
  Dim o As cIABMGridColumn
  
  Propiedad.Grid.Columns.Clear
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  'TODO VER CON JAVIER
  o.Name = "rptf_id"
  o.Visible = False
  o.Key = KI_RPTF_ID
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = C_strNombre
  o.PropertyType = cspText
  o.Width = 2000
  o.Key = KI_NOMBRE
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = LNGGetText(2572, vbNullString) 'Archivo CSR
  o.PropertyType = cspFile
  o.Width = 2000
  'TODO VER CON JAVIER
  o.HelpFilter = "Reportes|*.csr"
  o.Key = KI_CSRFILE
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = LNGGetText(2573, vbNullString) 'Sugerido
  o.PropertyType = cspCheck
  o.Width = 800
  o.Key = KI_SUGERIDO
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = LNGGetText(3915, vbNullString) 'Sugerido Mail
  o.PropertyType = cspCheck
  o.Width = 800
  o.Key = KI_SUGERIDOMAIL
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = LNGGetText(2574, vbNullString) 'Copias
  o.PropertyType = cspNumeric
  o.SubType = cspInteger
  o.Width = 800
  o.Key = KI_COPIAS
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = LNGGetText(2575, vbNullString) 'Imprimir al grabar un Documento nuevo
  o.PropertyType = cspCheck
  o.Width = 800
  o.Key = KI_PRINTINNEW
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = LNGGetText(2576, vbNullString) 'Objeto ActiveX
  o.PropertyType = cspText
  o.Width = 2000
  o.Key = KI_RPT_OBJ
  
  Dim F  As cIABMGridRow
  Dim fv As cIABMGridCellValue
  
  Propiedad.Grid.Rows.Clear
  
  While Not rs.EOF
  
    Set F = Propiedad.Grid.Rows.Add(Nothing, rs(cscrptfId).Value)
    
    Set fv = F.Add(Nothing)
    fv.Value = rs(cscrptfId).Value
    fv.Key = KI_RPTF_ID
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscrptfNombre)
    fv.Key = KI_NOMBRE
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscrptfCsrfile)
    fv.Key = KI_CSRFILE
    
    Set fv = F.Add(Nothing)
    fv.Id = gDB.ValField(rs.fields, cscrptfSugerido)
    fv.Key = KI_SUGERIDO
    
    Set fv = F.Add(Nothing)
    fv.Id = gDB.ValField(rs.fields, cscrptfSugeridoEmail)
    fv.Key = KI_SUGERIDOMAIL
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscrptfCopias)
    fv.Key = KI_COPIAS
    
    Set fv = F.Add(Nothing)
    fv.Id = gDB.ValField(rs.fields, cscrptfDocImprimirEnAlta)
    fv.Key = KI_PRINTINNEW
    
    Set fv = F.Add(Nothing)
    fv.Value = gDB.ValField(rs.fields, cscrptfObject)
    fv.Key = KI_RPT_OBJ
    
    rs.MoveNext
  Wend
  
  pLoadReportes = True
End Function

Private Function pValidateRowFirmas(Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_US_ID
        If ValEmpty(Cell.Id, csId) Then
          MsgInfo LNGGetText(1153, vbNullString, strRow) 'Debe indicar un usuario (1)
          Exit Function
        End If
    End Select
  Next
  
  pValidateRowFirmas = True
End Function

Private Function pValidateRowReportes(Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  CSKernelClient2.Title = LNGGetText(2577, vbNullString) 'Reportes
  
  For Each Cell In Row
    Select Case Cell.Key
        Case KI_NOMBRE
          If ValEmpty(Cell.Value, csText) Then
            MsgInfo LNGGetText(1811, vbNullString, strRow) 'Debe indicar un nombre (1)
            Exit Function
          End If
        Case KI_CSRFILE
          If ValEmpty(Cell.Value, csText) Then
            MsgInfo LNGGetText(2579, vbNullString, strRow) 'Debe indicar un Archivo CSR (1)
            Exit Function
          End If
        Case KI_COPIAS
          If Val(Cell.Value) < 1 Then
            MsgInfo LNGGetText(2578, vbNullString, strRow) 'La cantidad de copias debe ser mayor o igual a 1 (1)
            Exit Function
          End If
    End Select
  Next
  
  pValidateRowReportes = True
End Function

Private Function pSaveItemsReportes() As Boolean
  Dim register As cRegister
  Dim IProperty As cIABMProperty
  
  Set register = New cRegister
  With register
    .fieldId = cscrptfId
    .Table = csTReporteFormulario
    .Id = csNew
  
    Dim Row  As cIABMGridRow
    Dim Cell As cIABMGridCellValue
    
    With .fields
      For Each Row In m_ObjAbm.Properties.Item(c_Reportes).Grid.Rows
      
        .Clear
      
        For Each Cell In Row
          Select Case Cell.Key
            
            Case KI_RPTF_ID
              If Not m_Copy Then
                register.Id = Val(Cell.Value)
              End If
            Case KI_NOMBRE
              .Add2 cscrptfNombre, Cell.Value, csText
            Case KI_CSRFILE
              .Add2 cscrptfCsrfile, Cell.Value, csText
            Case KI_SUGERIDO
              .Add2 cscrptfSugerido, Cell.Id, csBoolean
            Case KI_SUGERIDOMAIL
              .Add2 cscrptfSugeridoEmail, Cell.Id, csBoolean
            Case KI_COPIAS
              .Add2 cscrptfCopias, Val(Cell.Value), csInteger
            Case KI_PRINTINNEW
              .Add2 cscrptfDocImprimirEnAlta, Cell.Id, csBoolean
            Case KI_RPT_OBJ
              .Add2 cscrptfObject, Cell.Value, csText
          End Select
        Next
        
        .Add2 cscrptfTipo, csRptFMaestro, csInteger
        .Add2 cscDocId, m_Id, csId
        .Add2 cscActivo, -1, csBoolean
        
        .HaveLastUpdate = True
        .HaveWhoModify = True
        
        If Not gDB.Save(register, , "pSaveItemsReportes", C_Module, c_ErrorSave) Then Exit Function
      Next
    End With
  End With
  
  Dim sqlstmt As String
  
  If LenB(m_ItemsDeletedReportes) And Not m_Copy Then
    m_ItemsDeletedReportes = RemoveLastColon(m_ItemsDeletedReportes)
    sqlstmt = "delete ReporteFormulario where rptf_id in (" & m_ItemsDeletedReportes & ")"
  
    If Not gDB.Execute(sqlstmt, "pSaveItemsReportes", C_Module) Then Exit Function
  End If
  
  pSaveItemsReportes = True
End Function

Private Sub pSetTipoDoc()
  If m_Id = csNO_ID Then
  
    m_ObjAbm.Properties(cscDoctId).Enabled = True
    m_ObjAbm.Properties(cscEmpId).Enabled = True
  Else
  
    Dim iTab As cIABMTabItem
  
    m_ObjAbm.Tabs.Clear
  
    Set iTab = m_ObjAbm.Tabs.Add(iTab)
    iTab.Index = 0
    iTab.Name = C_strGeneral
    Set iTab = Nothing
  
    m_ObjAbm.Properties(cscDoctId).Enabled = False
    m_ObjAbm.Properties(cscEmpId).Enabled = False
    
    Select Case m_Doct_id
      Case csEDT_FacturaVenta, csEDT_NotaCreditoVenta, csEDT_NotaDebitoVenta
        pShowFacturaVenta
      Case csEDT_FacturaCompra, csEDT_NotaCreditoCompra, csEDT_NotaDebitoCompra
        pShowFacturaCompra
      Case csEDT_RemitoVenta, csEDT_DevolucionRemitoVta
        pShowRemitoVenta
      Case csEDT_PackingList, csEDT_PackingListDevolucion
        pShowPackingList
      Case csEDT_ManifiestoCarga
        pShowManifiestoCarga
      Case csEDT_PermisoEmbarque
        pShowPermisoEmbarque
      Case csEDT_OrdenServicio
        pShowOrdenServicio
      Case csEDT_RemitoCompra, csEDT_DevolucionRemitoCpra
        pShowRemitoCompra
      Case csEDT_ImportacionTemp
        pShowImportacionTemp
      Case csEDT_PedidoVenta, csEDT_DevolucionPedidoVta
        pShowPedidoVenta
      Case csEDT_PedidoCompra, csEDT_DevolucionPedidoCpra
        pShowDoc
      Case csEDT_PresupuestoVenta, csEDT_DevolucionPresuVta
        pShowDoc
      Case csEDT_PresupuestoCompra, csEDT_DevolucionPresuCpra
        pShowDoc
      Case csEDT_OrdenCompra, csEDT_DevolucionOrdenCpra
        pShowDoc
        pShowOrdenCompra
      Case csEDT_CotizacionCompra, csEDT_DevolucionCotizacionCpra
        pShowDoc
      Case csEDT_MovimientoFondo
        pShowMovimientoFondo
      Case csEDT_Liquidacion
        pShowLiquidacion
      Case csEDT_DepositoBanco, csEDT_DepositoCupon, csEDT_ResolucionCupon
        pShowDepositoBanco
      Case csEDT_Cobranza
        pShowCobranza
      Case csEDT_TrasferenciaStock
        pShowStock
      Case csEDT_ParteReparacion
        pShowParteReparacion
      Case csEDT_OrdenProdKit
        pShowOrdenProdKit
      Case csEDT_RecuentoStock, csEDT_ParteProdKit, csEDT_ParteDesarmeKit, _
         csEDT_StockProveedor, csEDT_StockCliente
        pShowRecuentoStock
      Case csEDT_AsientoContable
        pShowAsiento
      Case csEDT_OrdenPago
        pShowOrdenPago
      Case csEDT_PresupuestoEnvio
        pShowPresupuestoEnvio
    End Select
    
    pShowReportes
    pShowFirmas
  End If
End Sub

Private Sub pShowAsiento()
  
  With m_ObjAbm.Properties
  
    With .Add(Nothing, cscTaId)
      .PropertyType = cspHelp
      .Table = csTalonario
      .Name = LNGGetText(1256, vbNullString) 'Talonario
      .Key = K_TA_ID
      .Value = m_Talonario
      .HelpId = m_ta_id
    End With
  End With
End Sub

Private Sub pShowStock()
  
  With m_ObjAbm.Properties
    
    With .Add(Nothing, cscTaId)
      .PropertyType = cspHelp
      .Table = csTalonario
      .Name = LNGGetText(1256, vbNullString) 'Talonario
      .Key = K_TA_ID
      .Value = m_Talonario
      .HelpId = m_ta_id
    End With
  
    With .Add(Nothing, cscDocStConsumo)
      .PropertyType = cspCheck
      .Name = LNGGetText(3524, vbNullString) 'Es Consumo de Stock
      .Key = K_ST_CONSUMO
      .Value = CInt(m_StConsumo)
      .Left = 9200
      .LeftLabel = -1780
    End With
  
  End With
End Sub

Private Sub pShowParteReparacion()
  Dim c As cIABMProperty
  Dim o As cABMProperty
  
  With m_ObjAbm.Properties
  
    With .Add(Nothing, cscTaId)
      .PropertyType = cspHelp
      .Table = csTalonario
      .Name = LNGGetText(1256, vbNullString) 'Talonario
      .Key = K_TA_ID
      .Value = m_Talonario
      .HelpId = m_ta_id
    End With
  
    With .Add(Nothing, cscMonId)
      .PropertyType = cspHelp
      .Table = csMoneda
      .Name = LNGGetText(1113, vbNullString) 'Moneda
      .Key = K_MON_ID
      .Value = m_Moneda
      .HelpId = m_mon_id
    End With
    
    Set c = .Add(Nothing, cscDocIdStock)
    With c
      .PropertyType = cspHelp
      .Table = csETablasDocumento.CSDocumento
      .HelpFilter = "'emp_id = " & m_emp_id & " and doct_id = " & csEDT_TrasferenciaStock & "'"
      .Name = "Documento Stock"
      .Value = m_DocumentoStock
      .HelpId = m_Doc_id_Stock
      .Key = K_DOC_ID_STOCK
    
      Set o = c
      o.IsForAbm = True
    
    End With
  End With
End Sub

Private Sub pShowRecuentoStock()
  Dim c As cIABMProperty
  Dim o As cABMProperty
  
  With m_ObjAbm.Properties
  
    With .Add(Nothing, cscTaId)
      .PropertyType = cspHelp
      .Table = csTalonario
      .Name = LNGGetText(1256, vbNullString) 'Talonario
      .Key = K_TA_ID
      .Value = m_Talonario
      .HelpId = m_ta_id
    End With
  
    Set c = .Add(Nothing, cscDocIdStock)
    With c
      .PropertyType = cspHelp
      .Table = csETablasDocumento.CSDocumento
      .HelpFilter = "'emp_id = " & m_emp_id & " and doct_id = " & csEDT_TrasferenciaStock & "'"
      .Name = LNGGetText(2580, vbNullString) 'Documento Stock
      .Value = m_DocumentoStock
      .HelpId = m_Doc_id_Stock
      .Key = K_DOC_ID_STOCK
    
      Set o = c
      o.IsForAbm = True
    
    End With
  End With
End Sub

Private Sub pShowOrdenProdKit()
  Dim c As cIABMProperty
  Dim o As cABMProperty
  
  With m_ObjAbm.Properties
  
    With .Add(Nothing, cscTaId)
      .PropertyType = cspHelp
      .Table = csTalonario
      .Name = LNGGetText(1256, vbNullString) 'Talonario
      .Key = K_TA_ID
      .Value = m_Talonario
      .HelpId = m_ta_id
    End With
  
  End With
End Sub

Private Sub pShowPedidoVenta()
  
  Dim iTab As cIABMTabItem
  
  Set iTab = m_ObjAbm.Tabs.Add(iTab)
  iTab.Index = m_ObjAbm.Tabs.Count - 1
  iTab.Name = LNGGetText(2581, vbNullString) 'Configuración
  
  With m_ObjAbm.Properties
  
    With .Add(Nothing, cscDocLlevaFirma)
      .PropertyType = cspCheck
      .TopFromProperty = cscActivo
      .TopNotChange = True
      .Left = 3300
      .LeftLabel = -1000
      .LeftNotChange = True
      .Name = LNGGetText(2582, vbNullString) 'Lleva Firma
      .Key = K_LLEVAFIRMA
      .Value = CInt(m_LlevaFirma)
    End With
    
    With .Add(Nothing, cscDocLlevaFirmaCredito)
      .PropertyType = cspCheck
      .TopFromProperty = cscActivo
      .TopNotChange = True
      .Left = 5900
      .LeftLabel = -1700
      .LeftNotChange = True
      .Name = LNGGetText(2583, vbNullString) 'Lleva Firma Crédito
      .Key = K_LLEVAFIRMACREDITO
      .Value = CInt(m_LlevaFirmaCredito)
    End With
    
    With .Add(Nothing, cscDocPvDesdePrv)
      .PropertyType = cspCheck
      .TopFromProperty = cscActivo
      .TopNotChange = True
      .Left = 9100
      .LeftLabel = -2400
      .LeftNotChange = True
      .Name = LNGGetText(2584, vbNullString) 'Requiere Presupuesto de Venta
      .Key = K_PV_DESDE_PRV
      .Value = CInt(m_PvDesdePrv)
    End With
  
    With .Add(Nothing, cscTaId)
      .PropertyType = cspHelp
      .Table = csTalonario
      .Name = LNGGetText(1256, vbNullString) 'Talonario
      .Key = K_TA_ID
      .Value = m_Talonario
      .HelpId = m_ta_id
      .HelpFilter = "emp_id = " & m_emp_id
    End With
    
    With .Add(Nothing, cscMonId)
      .PropertyType = cspHelp
      .Table = csMoneda
      .Name = LNGGetText(1113, vbNullString) 'Moneda
      .Key = K_MON_ID
      .Value = m_Moneda
      .HelpId = m_mon_id
    End With
  End With
End Sub

Private Sub pShowRemitoVenta()
  Dim c As cIABMProperty
  Dim o As cABMProperty
  
  Dim iTab As cIABMTabItem
  
  Set iTab = m_ObjAbm.Tabs.Add(iTab)
  iTab.Index = m_ObjAbm.Tabs.Count - 1
  iTab.Name = LNGGetText(2581, vbNullString) 'Configuración
  
  With m_ObjAbm.Properties

    With .Add(Nothing, cscDocLlevaFirma)
      .PropertyType = cspCheck
      .TopFromProperty = cscActivo
      .TopNotChange = True
      .Left = 3000
      .LeftLabel = -1000
      .LeftNotChange = True
      .Name = LNGGetText(2582, vbNullString) 'Lleva Firma
      .Key = K_LLEVAFIRMA
      .Value = CInt(m_LlevaFirma)
    End With
    
    With .Add(Nothing, cscDocRvDesdePv)
      .PropertyType = cspCheck
      .TopFromProperty = cscActivo
      .TopNotChange = True
      .Left = 5700
      .LeftLabel = -2100
      .LeftNotChange = True
      .Name = LNGGetText(2585, vbNullString) 'Requiere Pedido de Venta
      .Key = K_RV_DESDE_PV
      .Value = CInt(m_RvDesdePv)
    End With
  
    With .Add(Nothing, cscDocRvDesdeOs)
      .PropertyType = cspCheck
      .TopFromProperty = cscActivo
      .TopNotChange = True
      .Left = 8300
      .LeftLabel = -2100
      .LeftNotChange = True
      .Name = LNGGetText(2586, vbNullString) 'Requiere Orden de Servicio
      .Key = K_RV_DESDE_OS
      .Value = CInt(m_RvDesdeOs)
    End With
  
    With .Add(Nothing, cscDocRvBom)
      .PropertyType = cspCheck
      .TopFromProperty = cscActivo
      .TopNotChange = True
      .Left = 10600
      .LeftLabel = -1900
      .LeftNotChange = True
      .Name = LNGGetText(2587, vbNullString) 'Consume Stock x B.O.M.
      .Key = K_RV_BOM
      .Value = CInt(m_RvBom)
    End With
  
    With .Add(Nothing, cscTaId)
      .PropertyType = cspHelp
      .Table = csTalonario
      .Name = LNGGetText(1256, vbNullString) 'Talonario
      .Key = K_TA_ID
      .Value = m_Talonario
      .HelpId = m_ta_id
      .HelpFilter = "emp_id = " & m_emp_id
    End With
    
    With .Add(Nothing, cscMonId)
      .PropertyType = cspHelp
      .Table = csMoneda
      .Name = LNGGetText(1113, vbNullString) 'Moneda
      .Key = K_MON_ID
      .Value = m_Moneda
      .HelpId = m_mon_id
    End With
  
    With .Add(Nothing, cscDocMueveStock)
      .PropertyType = cspCheck
      .Name = LNGGetText(2588, vbNullString) 'Mueve Stock
      .Key = K_MUEVE_STOCK
      .Value = CInt(m_MueveStock)
      .TabIndex = iTab.Index
    End With
  
    Set c = .Add(Nothing, cscDocIdStock)
    With c
      .PropertyType = cspHelp
      .Table = csETablasDocumento.CSDocumento
      .HelpFilter = "'emp_id = " & m_emp_id & " and doct_id = " & csEDT_TrasferenciaStock & "'"
      .Name = LNGGetText(2580, vbNullString) 'Documento Stock
      .Value = m_DocumentoStock
      .HelpId = m_Doc_id_Stock
      .Key = K_DOC_ID_STOCK
      .TabIndex = iTab.Index
    
      Set o = c
      o.IsForAbm = True
    
    End With
  End With
End Sub

Private Sub pShowManifiestoCarga()
  
  With m_ObjAbm.Properties
  
    With .Add(Nothing, cscDocLlevaFirma)
      .PropertyType = cspCheck
      .TopFromProperty = cscActivo
      .TopNotChange = True
      .Left = 3600
      .LeftNotChange = True
      .Name = LNGGetText(2582, vbNullString)  'Lleva Firma
      .Key = K_LLEVAFIRMA
      .Value = CInt(m_LlevaFirma)
    End With
    
    With .Add(Nothing, cscTaId)
      .PropertyType = cspHelp
      .Table = csTalonario
      .Name = LNGGetText(1256, vbNullString)  'Talonario
      .Key = K_TA_ID
      .Value = m_Talonario
      .HelpId = m_ta_id
    End With
  End With
End Sub

Private Sub pShowPackingList()
  
  Dim iTab As cIABMTabItem
  
  Set iTab = m_ObjAbm.Tabs.Add(iTab)
  iTab.Index = m_ObjAbm.Tabs.Count - 1
  iTab.Name = LNGGetText(2581, vbNullString)  'Configuración
  
  With m_ObjAbm.Properties
  
    With .Add(Nothing, cscDocLlevaFirma)
      .PropertyType = cspCheck
      .TopFromProperty = cscActivo
      .TopNotChange = True
      .Left = 3600
      .LeftNotChange = True
      .Name = LNGGetText(2582, vbNullString)  'Lleva Firma
      .Key = K_LLEVAFIRMA
      .Value = CInt(m_LlevaFirma)
    End With
    
    With .Add(Nothing, cscTaId)
      .PropertyType = cspHelp
      .Table = csTalonario
      .Name = LNGGetText(1256, vbNullString)  'Talonario
      .Key = K_TA_ID
      .Value = m_Talonario
      .HelpId = m_ta_id
    End With
  
    With .Add(Nothing, cscMonId)
      .PropertyType = cspHelp
      .Table = csMoneda
      .Name = LNGGetText(1113, vbNullString)  'Moneda
      .Key = K_MON_ID
      .Value = m_Moneda
      .HelpId = m_mon_id
    End With
    
    With .Add(Nothing, c_PackingListDirecto)
      .PropertyType = cspOption
      .OptionGroup = 0
      .Width = 2000
      .Name = LNGGetText(2589, vbNullString)  'Sin Documento previo
      .Key = K_PKLST_DIRECTO
      .Value = 0
      .TabIndex = iTab.Index
    End With
    
    With .Add(Nothing, c_PackingListDesdePedido)
      .PropertyType = cspOption
      .OptionGroup = 0
      .Width = 2000
      .TopToPrevious = 300
      .Name = LNGGetText(2590, vbNullString)  'Desde Pedido Venta
      .Key = K_PKLST_DESDE_PV
      .Value = 0
      .TabIndex = iTab.Index
    End With
    
    With .Add(Nothing, c_PackingListDesdeRemito)
      .PropertyType = cspOption
      .TopToPrevious = 300
      .OptionGroup = 0
      .Width = 2000
      .Name = LNGGetText(2591, vbNullString)  'Desde remito
      .Key = K_PKLST_DESDE_RV
      .Value = 0
      .TabIndex = iTab.Index
    End With
    
    With .Add(Nothing, c_PackingListDesdeManifiesto)
      .PropertyType = cspOption
      .TopToPrevious = 300
      .OptionGroup = 0
      .Width = 2000
      .Name = LNGGetText(2592, vbNullString)  'Desde manifiesto
      .Key = K_PKLST_DESDE_MFC
      .Value = 0
      .TabIndex = iTab.Index
      .TopFrame = 2500
    End With
  End With
  
  Select Case m_TipoPackingList
    Case csETPackDirecto
      m_ObjAbm.Properties(c_PackingListDirecto).Value = 1
    Case csETPackPedido
      m_ObjAbm.Properties(c_PackingListDesdePedido).Value = 1
    Case csETPackRemito
      m_ObjAbm.Properties(c_PackingListDesdeRemito).Value = 1
    Case csETPackManifiesto
      m_ObjAbm.Properties(c_PackingListDesdeManifiesto).Value = 1
  End Select
End Sub

Private Sub pShowPermisoEmbarque()
  
  With m_ObjAbm.Properties
  
    With .Add(Nothing, cscDocLlevaFirma)
      .PropertyType = cspCheck
      .TopFromProperty = cscActivo
      .TopNotChange = True
      .Left = 3600
      .LeftNotChange = True
      .Name = LNGGetText(2582, vbNullString)  'Lleva Firma
      .Key = K_LLEVAFIRMA
      .Value = CInt(m_LlevaFirma)
    End With
    
    With .Add(Nothing, cscMonId)
      .PropertyType = cspHelp
      .Table = csMoneda
      .Name = LNGGetText(1113, vbNullString)  'Moneda
      .Key = K_MON_ID
      .Value = m_Moneda
      .HelpId = m_mon_id
    End With
  End With
End Sub

Private Sub pShowRemitoCompra()
  Dim c As cIABMProperty
  Dim o As cABMProperty
  
  Dim iTab As cIABMTabItem
  
  Set iTab = m_ObjAbm.Tabs.Add(iTab)
  iTab.Index = m_ObjAbm.Tabs.Count - 1
  iTab.Name = LNGGetText(2581, vbNullString)  'Configuración
  
  With m_ObjAbm.Properties
  
    With .Add(Nothing, cscDocLlevaFirma)
      .PropertyType = cspCheck
      .TopFromProperty = cscActivo
      .TopNotChange = True
      .Left = 3600
      .LeftNotChange = True
      .Name = LNGGetText(2582, vbNullString)  'Lleva Firma
      .Key = K_LLEVAFIRMA
      .Value = CInt(m_LlevaFirma)
    End With
    
    With .Add(Nothing, cscDocRcDesdeOc)
      .PropertyType = cspCheck
      .TopFromProperty = cscActivo
      .TopNotChange = True
      .Left = 6600
      .LeftLabel = -2100
      .LeftNotChange = True
      .Name = LNGGetText(2593, vbNullString)  'Requiere Orden de Compra
      .Key = K_RC_DESDE_OC
      .Value = CInt(m_RcDesdeOc)
    End With
    
    With .Add(Nothing, cscDocRcDespachoImpo)
      .PropertyType = cspCheck
      .TopFromProperty = cscActivo
      .TopNotChange = True
      .Left = 9840
      .LeftLabel = -2500
      .LeftNotChange = True
      .Name = LNGGetText(2594, vbNullString)  'Es un Despacho de Importación"
      .Key = K_RC_DESPACHOIMPO
      .Value = CInt(m_RcDespachoImpo)
    End With
    
    With .Add(Nothing, cscTaId)
      .PropertyType = cspHelp
      .Table = csTalonario
      .Name = LNGGetText(1256, vbNullString)  'Talonario
      .Key = K_TA_ID
      .Value = m_Talonario
      .HelpId = m_ta_id
      .HelpFilter = "emp_id = " & m_emp_id
    End With
    
    With .Add(Nothing, cscMonId)
      .PropertyType = cspHelp
      .Table = csMoneda
      .Name = LNGGetText(1113, vbNullString)  'Moneda
      .Key = K_MON_ID
      .Value = m_Moneda
      .HelpId = m_mon_id
    End With
  
    With .Add(Nothing, cscDocMueveStock)
      .PropertyType = cspCheck
      .Name = LNGGetText(2588, vbNullString)  'Mueve Stock
      .Key = K_MUEVE_STOCK
      .Value = CInt(m_MueveStock)
      .TabIndex = iTab.Index
    End With
  
    Set c = .Add(Nothing, cscDocIdStock)
    With c
      .PropertyType = cspHelp
      .Table = csETablasDocumento.CSDocumento
      .HelpFilter = "'emp_id = " & m_emp_id & " and doct_id = " & csEDT_TrasferenciaStock & "'"
      .Name = LNGGetText(2580, vbNullString)  'Documento Stock
      .Value = m_DocumentoStock
      .HelpId = m_Doc_id_Stock
      .Key = K_DOC_ID_STOCK
      .TabIndex = iTab.Index
    
      Set o = c
      o.IsForAbm = True
    
    End With
  End With
End Sub

Private Sub pShowOrdenServicio()
  Dim c As cIABMProperty
  Dim o As cABMProperty
  
  Dim iTab As cIABMTabItem
  
  Set iTab = m_ObjAbm.Tabs.Add(iTab)
  iTab.Index = m_ObjAbm.Tabs.Count - 1
  iTab.Name = LNGGetText(2581, vbNullString)  'Configuración
  
  With m_ObjAbm.Properties
  
    With .Add(Nothing, cscDocLlevaFirma)
      .PropertyType = cspCheck
      .TopFromProperty = cscActivo
      .TopNotChange = True
      .Left = 3600
      .LeftNotChange = True
      .Name = LNGGetText(2582, vbNullString)  'Lleva Firma
      .Key = K_LLEVAFIRMA
      .Value = CInt(m_LlevaFirma)
    End With
    
    With .Add(Nothing, cscTaId)
      .PropertyType = cspHelp
      .Table = csTalonario
      .Name = LNGGetText(1256, vbNullString)  'Talonario
      .Key = K_TA_ID
      .Value = m_Talonario
      .HelpId = m_ta_id
      .HelpFilter = "emp_id = " & m_emp_id
    End With
    
    With .Add(Nothing, cscMonId)
      .PropertyType = cspHelp
      .Table = csMoneda
      .Name = LNGGetText(1113, vbNullString)  'Moneda
      .Key = K_MON_ID
      .Value = m_Moneda
      .HelpId = m_mon_id
    End With
  
    With .Add(Nothing, cscDocMueveStock)
      .PropertyType = cspCheck
      .Name = LNGGetText(2588, vbNullString)  'Mueve Stock
      .Key = K_MUEVE_STOCK
      .Value = CInt(m_MueveStock)
      .TabIndex = iTab.Index
    End With
  
    Set c = .Add(Nothing, cscDocIdStock)
    With c
      .PropertyType = cspHelp
      .Table = csETablasDocumento.CSDocumento
      .HelpFilter = "'emp_id = " & m_emp_id & " and doct_id = " & csEDT_TrasferenciaStock & "'"
      .Name = LNGGetText(2580, vbNullString)  'Documento Stock
      .Value = m_DocumentoStock
      .HelpId = m_Doc_id_Stock
      .Key = K_DOC_ID_STOCK
      .TabIndex = iTab.Index
    
      Set o = c
      o.IsForAbm = True
    
    End With
  End With
End Sub

Private Sub pShowImportacionTemp()
  Dim c As cIABMProperty
  Dim o As cABMProperty
  
  Dim iTab As cIABMTabItem
  
  Set iTab = m_ObjAbm.Tabs.Add(iTab)
  iTab.Index = m_ObjAbm.Tabs.Count - 1
  iTab.Name = LNGGetText(2581, vbNullString)  'Configuración
  
  With m_ObjAbm.Properties
  
    With .Add(Nothing, cscDocLlevaFirma)
      .PropertyType = cspCheck
      .TopFromProperty = cscActivo
      .TopNotChange = True
      .Left = 3600
      .LeftNotChange = True
      .Name = LNGGetText(2582, vbNullString)  'Lleva Firma
      .Key = K_LLEVAFIRMA
      .Value = CInt(m_LlevaFirma)
    End With
    
    With .Add(Nothing, cscTaId)
      .PropertyType = cspHelp
      .Table = csTalonario
      .Name = LNGGetText(1256, vbNullString)  'Talonario
      .Key = K_TA_ID
      .Value = m_Talonario
      .HelpId = m_ta_id
    End With
    
    With .Add(Nothing, cscMonId)
      .PropertyType = cspHelp
      .Table = csMoneda
      .Name = LNGGetText(1113, vbNullString)  'Moneda
      .Key = K_MON_ID
      .Value = m_Moneda
      .HelpId = m_mon_id
    End With
  
    With .Add(Nothing, cscDocMueveStock)
      .PropertyType = cspCheck
      .Name = LNGGetText(2588, vbNullString)  'Mueve Stock
      .Key = K_MUEVE_STOCK
      .Value = CInt(m_MueveStock)
      .TabIndex = iTab.Index
    End With
  
    Set c = .Add(Nothing, cscDocIdStock)
    With c
      .PropertyType = cspHelp
      .Table = csETablasDocumento.CSDocumento
      .HelpFilter = "'emp_id = " & m_emp_id & " and doct_id = " & csEDT_TrasferenciaStock & "'"
      .Name = LNGGetText(2580, vbNullString)  'Documento Stock
      .Value = m_DocumentoStock
      .HelpId = m_Doc_id_Stock
      .Key = K_DOC_ID_STOCK
      .TabIndex = iTab.Index
    
      Set o = c
      o.IsForAbm = True
    
    End With
  End With
End Sub

Private Sub pShowDoc()
  
  With m_ObjAbm.Properties
  
    With .Add(Nothing, cscDocLlevaFirma)
      .PropertyType = cspCheck
      .TopFromProperty = cscActivo
      .TopNotChange = True
      .Left = 3600
      .LeftNotChange = True
      .Name = LNGGetText(2582, vbNullString)  'Lleva Firma
      .Key = K_LLEVAFIRMA
      .Value = CInt(m_LlevaFirma)
    End With
    
    With .Add(Nothing, cscTaId)
      .PropertyType = cspHelp
      .Table = csTalonario
      .Name = LNGGetText(1256, vbNullString)  'Talonario
      .Key = K_TA_ID
      .Value = m_Talonario
      .HelpId = m_ta_id
    End With
    
    With .Add(Nothing, cscMonId)
      .PropertyType = cspHelp
      .Table = csMoneda
      .Name = LNGGetText(1113, vbNullString)  'Moneda
      .Key = K_MON_ID
      .Value = m_Moneda
      .HelpId = m_mon_id
    End With
  End With
End Sub

Private Sub pShowMovimientoFondo()
  Dim c As cIABMProperty
  Dim o As cABMProperty
  
  With m_ObjAbm.Properties
  
    With .Add(Nothing, cscDocLlevaFirma)
      .PropertyType = cspCheck
      .TopFromProperty = cscActivo
      .TopNotChange = True
      .Left = 3600
      .LeftNotChange = True
      .Name = LNGGetText(2582, vbNullString)  'Lleva Firma
      .Key = K_LLEVAFIRMA
      .Value = CInt(m_LlevaFirma)
    End With
    
    With .Add(Nothing, cscTaId)
      .PropertyType = cspHelp
      .Table = csTalonario
      .Name = LNGGetText(1256, vbNullString)   'Talonario
      .Key = K_TA_ID
      .Value = m_Talonario
      .HelpId = m_ta_id
    End With
    
    With .Add(Nothing, cscMonId)
      .PropertyType = cspHelp
      .Table = csMoneda
      .Name = LNGGetText(1113, vbNullString)   'Moneda
      .Key = K_MON_ID
      .Value = m_Moneda
      .HelpId = m_mon_id
    End With
    
    Set c = .Add(Nothing, cscDocIdAsiento)
    With c
      .PropertyType = cspHelp
      .Table = csETablasDocumento.CSDocumento
      .HelpFilter = pGetAsIdFilter(m_emp_id)
      .Name = LNGGetText(2596, vbNullString)   'Documento Asiento
      .Value = m_DocumentoAsiento
      .HelpId = m_Doc_id_Asiento
      .Key = K_DOC_ID_ASIENTO
      
      Set o = c
      o.IsForAbm = True
      
    End With
  End With
End Sub

Private Sub pShowDepositoBanco()
  Dim c As cIABMProperty
  Dim o As cABMProperty
  
  With m_ObjAbm.Properties
  
    With .Add(Nothing, cscDocLlevaFirma)
      .PropertyType = cspCheck
      .TopFromProperty = cscActivo
      .TopNotChange = True
      .Left = 3600
      .LeftNotChange = True
      .Name = LNGGetText(2582, vbNullString)  'Lleva Firma
      .Key = K_LLEVAFIRMA
      .Value = CInt(m_LlevaFirma)
    End With
    
    With .Add(Nothing, cscTaId)
      .PropertyType = cspHelp
      .Table = csTalonario
      .Name = LNGGetText(1256, vbNullString)  'Talonario
      .Key = K_TA_ID
      .Value = m_Talonario
      .HelpId = m_ta_id
    End With
    
    Set c = .Add(Nothing, cscDocIdAsiento)
    With c
      .PropertyType = cspHelp
      .Table = csETablasDocumento.CSDocumento
      .HelpFilter = pGetAsIdFilter(m_emp_id)
      .Name = LNGGetText(2596, vbNullString)  'Documento Asiento
      .Value = m_DocumentoAsiento
      .HelpId = m_Doc_id_Asiento
      .Key = K_DOC_ID_ASIENTO
      
      Set o = c
      o.IsForAbm = True
      
    End With
  End With
End Sub

Private Sub pShowFacturaVenta()
  Dim c As cIABMProperty
  Dim o As cABMProperty
  
  Dim iTab As cIABMTabItem
  
  Set iTab = m_ObjAbm.Tabs.Add(iTab)
  iTab.Index = m_ObjAbm.Tabs.Count - 1
  iTab.Name = LNGGetText(2581, vbNullString)  'Configuración
  
  With m_ObjAbm.Properties
  
    With .Add(Nothing, cscDocLlevaFirma)
      .PropertyType = cspCheck
      .TopFromProperty = cscActivo
      .TopNotChange = True
      .Left = 3600
      .LeftNotChange = True
      .Name = LNGGetText(2582, vbNullString)  'Lleva Firma
      .Key = K_LLEVAFIRMA
      .Value = CInt(m_LlevaFirma)
    End With
    
    With .Add(Nothing, cscDocLlevaFirmaPrint0)
      .PropertyType = cspCheck
      .TopFromProperty = cscActivo
      .TopNotChange = True
      .Left = 6600
      .LeftLabel = -2400
      .LeftNotChange = True
      .Name = LNGGetText(3495, vbNullString)  'Lleva Firma por Importes en Cero
      .Key = K_LLEVAFIRMAPRINT0
      .Value = CInt(m_LlevaFirmaPrint0)
    End With
    
    With .Add(Nothing, cscMonId)
      .PropertyType = cspHelp
      .Table = csMoneda
      .Name = LNGGetText(1113, vbNullString)  'Moneda
      .Key = K_MON_ID
      .Value = m_Moneda
      .HelpId = m_mon_id
    End With
    
    With .Add(Nothing, cscCuegId)
      .PropertyType = cspHelp
      .Table = csCuentaGrupo
      .Name = LNGGetText(2597, vbNullString)  'Cuenta Grupo
      .Value = m_CuentaGrupo
      .HelpId = m_cueg_id
      .Key = K_CUEG_ID
      .HelpFilter = "cueg_tipo = 4"
    End With
    
    Set c = .Add(Nothing, cscDocIdAsiento)
    With c
      .PropertyType = cspHelp
      .Table = csETablasDocumento.CSDocumento
      .HelpFilter = pGetAsIdFilter(m_emp_id)
      .Name = LNGGetText(2596, vbNullString)  'Documento Asiento
      .Value = m_DocumentoAsiento
      .HelpId = m_Doc_id_Asiento
      .Key = K_DOC_ID_ASIENTO
      
      Set o = c
      o.IsForAbm = True
      
    End With
    
    With .Add(Nothing, cscTaIdInscripto)
      .PropertyType = cspHelp
      .Table = csTalonario
      .Name = LNGGetText(2598, vbNullString)  'Talonario Inscripto
      .Key = K_TA_ID_INSCRIPTO
      .Value = m_TalonarioInscripto
      .HelpId = m_ta_id_Inscripto
      .TabIndex = iTab.Index
      .Left = 3000
      .LeftLabel = -2400
      .HelpFilter = "emp_id = " & m_emp_id
    End With
    
    With .Add(Nothing, cscTaIdFinal)
      .PropertyType = cspHelp
      .Table = csTalonario
      .Name = LNGGetText(2599, vbNullString)  'Talonario Exento/Mono/C.F.
      .Key = K_TA_ID_FINAL
      .Value = m_TalonarioFinal
      .HelpId = m_ta_id_Final
      .TabIndex = iTab.Index
      .LeftLabel = -2400
      .HelpFilter = "emp_id = " & m_emp_id
    End With
    
    With .Add(Nothing, cscTaIdExterno)
      .PropertyType = cspHelp
      .Table = csTalonario
      .Name = LNGGetText(2600, vbNullString)  'Talonario Externo
      .Key = K_TA_ID_EXTERNO
      .Value = m_TalonarioExterno
      .HelpId = m_ta_id_Externo
      .TabIndex = iTab.Index
      .LeftLabel = -2400
      .HelpFilter = "emp_id = " & m_emp_id
    End With
  
    With .Add(Nothing, c_FacturaDirecta)
      .PropertyType = cspOption
      .OptionGroup = 0
      .Width = 2000
      .Name = LNGGetText(2589, vbNullString)  'Sin documento previo
      .Key = K_FV_DIRECTA
      .Value = 0
      .TabIndex = iTab.Index
    End With
    
    With .Add(Nothing, c_FacturaDesdePedido)
      .PropertyType = cspOption
      .OptionGroup = 0
      .Width = 2000
      .TopToPrevious = 300
      .Name = LNGGetText(2590, vbNullString)  'Desde pedido de venta
      .Key = K_FV_DESDE_PV
      .Value = 0
      .TabIndex = iTab.Index
    End With
    
    With .Add(Nothing, c_FacturaDesdeRemito)
      .PropertyType = cspOption
      .TopToPrevious = 300
      .OptionGroup = 0
      .Width = 2000
      .Name = LNGGetText(2591, vbNullString)  'Desde remito
      .Key = K_FV_DESDE_RV
      .Value = 0
      .TabIndex = iTab.Index
    End With
    
    With .Add(Nothing, c_FacturaDesdePackingList)
      .PropertyType = cspOption
      .TopToPrevious = 300
      .OptionGroup = 0
      .Width = 2000
      .Name = LNGGetText(2601, vbNullString)  'Desde Packing List
      .Key = K_FV_DESDE_PKLST
      .Value = 0
      .TabIndex = iTab.Index
    End With
    
    With .Add(Nothing, c_FacturaDesdeProyecto)
      .PropertyType = cspOption
      .TopToPrevious = 300
      .OptionGroup = 0
      .Width = 2000
      .Name = LNGGetText(2602, vbNullString)  'Desde proyectos
      .Key = K_FV_DESDE_PROY
      .Value = 0
      .TabIndex = iTab.Index
      .TopFrame = 2500
    End With
  
    Select Case m_TipoFactura
      Case csETFacDirecta
        m_ObjAbm.Properties(c_FacturaDirecta).Value = 1
      Case csETFacPedido
        m_ObjAbm.Properties(c_FacturaDesdePedido).Value = 1
      Case csETFacRemito
        m_ObjAbm.Properties(c_FacturaDesdeRemito).Value = 1
      Case csETFacPackingList
        m_ObjAbm.Properties(c_FacturaDesdePackingList).Value = 1
      Case csETFacProyecto
        m_ObjAbm.Properties(c_FacturaDesdeProyecto).Value = 1
    End Select

    With .Add(Nothing, cscDocGeneraRemito)
      .Left = 7000
      .TopFromProperty = cscDoctId
      .PropertyType = cspCheck
      .Name = LNGGetText(2603, vbNullString)  'Genera Remito
      .Key = K_GENERA_REMITO
      .Value = CInt(m_GeneraRemito)
      .TabIndex = iTab.Index
    End With
  
    Set c = .Add(Nothing, cscDocIdRemito)
    With c
      .PropertyType = cspHelp
      .Table = csETablasDocumento.CSDocumento
      .HelpFilter = "'emp_id = " & m_emp_id & " and doct_id = " & csEDT_RemitoVenta & "'"
      .Name = LNGGetText(2604, vbNullString)  'Documento Remito
      .Value = m_DocumentoRemito
      .HelpId = m_Doc_id_Remito
      .Key = K_DOC_ID_REMITO
      .TabIndex = iTab.Index
    
      Set o = c
      o.IsForAbm = True
    
    End With
  
    With .Add(Nothing, cscDocMueveStock)
      .PropertyType = cspCheck
      .Name = LNGGetText(2588, vbNullString)  'Mueve Stock
      .Key = K_MUEVE_STOCK
      .Value = CInt(m_MueveStock)
      .TabIndex = iTab.Index
    End With
  
    Set c = .Add(Nothing, cscDocIdStock)
    With c
      .PropertyType = cspHelp
      .Table = csETablasDocumento.CSDocumento
      .HelpFilter = "'emp_id = " & m_emp_id & " and doct_id = " & csEDT_TrasferenciaStock & "'"
      .Name = LNGGetText(2580, vbNullString)  'Documento Stock
      .Value = m_DocumentoStock
      .HelpId = m_Doc_id_Stock
      .Key = K_DOC_ID_STOCK
      .TabIndex = iTab.Index
    
      Set o = c
      o.IsForAbm = True
    
    End With
  
    With .Add(Nothing, cscDocEsCreditobanco)
      .PropertyType = cspCheck
      .Name = LNGGetText(3695, vbNullString) 'Factura de Aval x Credito Bancario
      .Key = K_ESCREDITOBANCO
      .Value = CInt(m_EsCreditoBanco)
      .LeftLabel = -4000
    End With
  
    With .Add(Nothing, cscDocEsVentaAccion)
      .PropertyType = cspCheck
      .Name = LNGGetText(3696, vbNullString) 'Factura por Venta de Acciones
      .Key = K_ESVENTAACCION
      .Value = CInt(m_EsVentaAccion)
      .LeftLabel = -4000
      .TopToPrevious = 380
    End With
  
    With .Add(Nothing, cscDocEsVentaCheque)
      .PropertyType = cspCheck
      .Name = LNGGetText(3697, vbNullString) 'Factura por Venta de Cheques en Bolsa de Comercio
      .Key = K_ESVENTACHEQUE
      .Value = CInt(m_EsVentaCheque)
      .LeftLabel = -4000
      .TopToPrevious = 380
    End With
  
    With .Add(Nothing, cscDocesFacturaElectronica)
      .PropertyType = cspCheck
      .Name = LNGGetText(5123, vbNullString)  'Factura Electronica
      .Key = K_FACTURA_ELECTRONICA
      .Value = CInt(m_esFacturaElectronica)
      .TabIndex = iTab.Index
      .LeftLabel = -2000
      .Left = 6000
      .TopFromProperty = cscDocIdStock
      .TopToPrevious = 800
    End With
  
    With .Add(Nothing, cscDocFvSinPercepcion)
      .PropertyType = cspCheck
      .Name = LNGGetText(2605, vbNullString)  'Sin Percepción
      .Key = K_FV_SIN_PERCEPCION
      .Value = CInt(m_Fv_SinPercepcion)
      .TabIndex = iTab.Index
      .LeftLabel = -2000
    End With
  
  End With
  
  m_TopDescrip = 4500
End Sub

Private Sub pShowFacturaCompra()
  Dim c As cIABMProperty
  Dim o As cABMProperty
  
  Dim iTab As cIABMTabItem
  
  Set iTab = m_ObjAbm.Tabs.Add(iTab)
  iTab.Index = m_ObjAbm.Tabs.Count - 1
  iTab.Name = LNGGetText(2581, vbNullString)  'Configuración
  
  With m_ObjAbm.Properties
  
    With .Add(Nothing, cscDocLlevaFirma)
      .PropertyType = cspCheck
      .TopFromProperty = cscActivo
      .TopNotChange = True
      .Left = 3600
      .LeftNotChange = True
      .Name = LNGGetText(2582, vbNullString)  'Lleva Firma
      .Key = K_LLEVAFIRMA
      .Value = CInt(m_LlevaFirma)
    End With
    
    With .Add(Nothing, cscDocEsResumenBco)
      .PropertyType = cspCheck
      .TopFromProperty = cscActivo
      .TopNotChange = True
      .Left = 6200
      .LeftNotChange = True
      .LeftLabel = -2000
      .Name = LNGGetText(3584, vbNullString)  'Es un Resumen Bancario
      .Key = K_ESRESUMENBCO
      .Value = CInt(m_EsResumenBco)
    End With
    
    With .Add(Nothing, cscMonId)
      .PropertyType = cspHelp
      .Table = csMoneda
      .Name = LNGGetText(1113, vbNullString)  'Moneda
      .Key = K_MON_ID
      .Value = m_Moneda
      .HelpId = m_mon_id
    End With
  
    With .Add(Nothing, cscCuegId)
      .PropertyType = cspHelp
      .Table = csCuentaGrupo
      .Name = LNGGetText(2597, vbNullString)  'Cuenta grupo
      .Value = m_CuentaGrupo
      .HelpId = m_cueg_id
      .Key = K_CUEG_ID
      .HelpFilter = "cueg_tipo = 3"
    End With
  
    Set c = .Add(Nothing, cscDocIdAsiento)
    With c
      .PropertyType = cspHelp
      .Table = csETablasDocumento.CSDocumento
      .HelpFilter = pGetAsIdFilter(m_emp_id)
      .Name = LNGGetText(2596, vbNullString)  'Documento Asiento
      .Value = m_DocumentoAsiento
      .HelpId = m_Doc_id_Asiento
      .Key = K_DOC_ID_ASIENTO
      
      Set o = c
      o.IsForAbm = True
      
    End With
  
    With .Add(Nothing, cscTaIdInscripto)
      .PropertyType = cspHelp
      .Table = csTalonario
      .Name = LNGGetText(2598, vbNullString)  'Talonario Inscripto
      .Key = K_TA_ID_INSCRIPTO
      .Value = m_TalonarioInscripto
      .HelpId = m_ta_id_Inscripto
      .TabIndex = iTab.Index
      .Left = 3000
      .LeftLabel = -2400
      .HelpFilter = "emp_id = " & m_emp_id
    End With
    
    With .Add(Nothing, cscTaIdFinal)
      .PropertyType = cspHelp
      .Table = csTalonario
      .Name = LNGGetText(2599, vbNullString)  'Talonario Exento/Mono/C.F./R.N.I.
      .Key = K_TA_ID_FINAL
      .Value = m_TalonarioFinal
      .HelpId = m_ta_id_Final
      .TabIndex = iTab.Index
      .LeftLabel = -2400
      .HelpFilter = "emp_id = " & m_emp_id
    End With
    
    With .Add(Nothing, cscTaIdExterno)
      .PropertyType = cspHelp
      .Table = csTalonario
      .Name = LNGGetText(2600, vbNullString)  'Talonario Externo
      .Key = K_TA_ID_EXTERNO
      .Value = m_TalonarioExterno
      .HelpId = m_ta_id_Externo
      .TabIndex = iTab.Index
      .LeftLabel = -2400
      .HelpFilter = "emp_id = " & m_emp_id
    End With
  
    With .Add(Nothing, cscTaIdInscriptoM)
      .PropertyType = cspHelp
      .Table = csTalonario
      .Name = LNGGetText(2606, vbNullString)  'Talonario Inscripto M
      .Key = K_TA_ID_INSCRIPTOM
      .Value = m_TalonarioInscriptoM
      .HelpId = m_ta_id_InscriptoM
      .TabIndex = iTab.Index
      .Left = 3000
      .LeftLabel = -2400
      .HelpFilter = "emp_id = " & m_emp_id
    End With
  
    With .Add(Nothing, c_FacturaDirecta)
      .PropertyType = cspOption
      .OptionGroup = 0
      .Width = 2500
      .Name = LNGGetText(2589, vbNullString)  'Sin documento previo
      .Key = K_FC_DIRECTA
      .Value = 0
      .TabIndex = iTab.Index
    End With
        
    With .Add(Nothing, c_FacturaDesdeOrden)
      .PropertyType = cspOption
      .OptionGroup = 0
      .Width = 2500
      .TopToPrevious = 300
      .Name = LNGGetText(2607, vbNullString)  'Desde Orden de Compra
      .Key = K_FC_DESDE_OC
      .Value = 0
      .TabIndex = iTab.Index
    End With
    
    With .Add(Nothing, c_FacturaDesdeRemito)
      .PropertyType = cspOption
      .TopToPrevious = 300
      .OptionGroup = 0
      .Width = 2500
      .Name = LNGGetText(2591, vbNullString)  'Desde remito
      .Key = K_FC_DESDE_RC
      .Value = 0
      .TabIndex = iTab.Index
    End With
    
    Select Case m_TipoFactura
      Case csETFacDirecta
        m_ObjAbm.Properties(c_FacturaDirecta).Value = 1
      Case csETFacOrden
        m_ObjAbm.Properties(c_FacturaDesdeOrden).Value = 1
      Case csETFacRemito
        m_ObjAbm.Properties(c_FacturaDesdeRemito).Value = 1
    End Select
    
    With .Add(Nothing, cscDocGeneraRemito)
      .Left = 7000
      .TopFromProperty = cscTaIdInscripto
      .PropertyType = cspCheck
      .Name = LNGGetText(2603, vbNullString)  'Genera Remito
      .Key = K_GENERA_REMITO
      .Value = CInt(m_GeneraRemito)
      .TabIndex = iTab.Index
    End With
  
    Set c = .Add(Nothing, cscDocIdRemito)
    With c
      .PropertyType = cspHelp
      .Table = csETablasDocumento.CSDocumento
      .HelpFilter = "'emp_id = " & m_emp_id & " and doct_id = " & csEDT_RemitoCompra & "'"
      .Name = LNGGetText(2604, vbNullString)  'Documento Remito
      .Value = m_DocumentoRemito
      .HelpId = m_Doc_id_Remito
      .Key = K_DOC_ID_REMITO
      .TabIndex = iTab.Index
    
      Set o = c
      o.IsForAbm = True
    
    End With
  
    With .Add(Nothing, cscDocMueveStock)
      .PropertyType = cspCheck
      .Name = LNGGetText(2588, vbNullString)  'Mueve Stock
      .Key = K_MUEVE_STOCK
      .Value = CInt(m_MueveStock)
      .TabIndex = iTab.Index
    End With
    
    Set c = .Add(Nothing, cscDocIdStock)
    With c
      .PropertyType = cspHelp
      .Table = csETablasDocumento.CSDocumento
      .HelpFilter = "'emp_id = " & m_emp_id & " and doct_id = " & csEDT_TrasferenciaStock & "'"
      .Name = LNGGetText(2580, vbNullString)  'Documento Stock
      .Value = m_DocumentoStock
      .HelpId = m_Doc_id_Stock
      .Key = K_DOC_ID_STOCK
      .TabIndex = iTab.Index
    
      Set o = c
      o.IsForAbm = True
    
    End With
    
    With .Add(Nothing, cscDocgId)
      .PropertyType = cspHelp
      .Table = csDocumentoGrupo
      .Name = LNGGetText(1404, vbNullString) ' Grupo
      .Value = m_DocumentoGrupo
      .HelpId = m_docg_id
      .TabIndex = iTab.Index
      .Key = K_DOCG_ID
    End With
    
  End With
End Sub

Private Sub pShowPresupuestoEnvio()
  
  With m_ObjAbm.Properties
  
    With .Add(Nothing, cscDocLlevaFirma)
      .PropertyType = cspCheck
      .TopFromProperty = cscActivo
      .TopNotChange = True
      .Left = 3600
      .LeftNotChange = True
      .Name = LNGGetText(2582, vbNullString)  'Lleva Firma
      .Key = K_LLEVAFIRMA
      .Value = CInt(m_LlevaFirma)
    End With
    
    With .Add(Nothing, cscTaId)
      .PropertyType = cspHelp
      .Table = csTalonario
      .Name = LNGGetText(1256, vbNullString)  'Talonario
      .Key = K_TA_ID
      .Value = m_Talonario
      .HelpId = m_ta_id
    End With
    
    With .Add(Nothing, cscMonId)
      .PropertyType = cspHelp
      .Table = csMoneda
      .Name = LNGGetText(1113, vbNullString)  'Moneda
      .Key = K_MON_ID
      .Value = m_Moneda
      .HelpId = m_mon_id
    End With
  End With
End Sub

Private Sub pShowCobranza()
  Dim c As cIABMProperty
  Dim o As cABMProperty
  
  With m_ObjAbm.Properties
  
    With .Add(Nothing, cscDocLlevaFirma)
      .PropertyType = cspCheck
      .TopFromProperty = cscActivo
      .TopNotChange = True
      .Left = 3600
      .LeftNotChange = True
      .Name = LNGGetText(2582, vbNullString)  'Lleva Firma
      .Key = K_LLEVAFIRMA
      .Value = CInt(m_LlevaFirma)
    End With
    
    With .Add(Nothing, cscTaId)
      .PropertyType = cspHelp
      .Table = csTalonario
      .Name = LNGGetText(1256, vbNullString)  'Talonario
      .Key = K_TA_ID
      .Value = m_Talonario
      .HelpId = m_ta_id
      .HelpFilter = "emp_id = " & m_emp_id
    End With
    
    Set c = .Add(Nothing, cscDocIdAsiento)
    With c
      .PropertyType = cspHelp
      .Table = csETablasDocumento.CSDocumento
      .HelpFilter = pGetAsIdFilter(m_emp_id)
      .Name = LNGGetText(2596, vbNullString)  'Documento Asiento
      .Value = m_DocumentoAsiento
      .HelpId = m_Doc_id_Asiento
      .Key = K_DOC_ID_ASIENTO
      
      Set o = c
      o.IsForAbm = True
      
    End With
  
    With .Add(Nothing, cscDocEsCobChequeSgr)
      .PropertyType = cspCheck
      .Name = LNGGetText(3698, vbNullString)  'Es cobranza de cheques comerciados en la bolsa de comercio
      .Key = K_ESCOBCHEQUESGR
      .Value = CInt(m_EsCobChequesgr)
      .LeftLabel = -5000
      .Left = 10000
    End With
  
    With .Add(Nothing, cscDocEsCobCaidaSgr)
      .PropertyType = cspCheck
      .Name = LNGGetText(3699, vbNullString)  'Es cobranza de cheques o prestamos caidos
      .Key = K_ESCOBCAIDASGR
      .Value = CInt(m_EsCobCaidasgr)
      .LeftLabel = -5000
      .TopToPrevious = 380
    End With
  
  End With
  
  m_TopDescrip = 3800
  
End Sub

Private Sub pShowOrdenPago()
  Dim c As cIABMProperty
  Dim o As cABMProperty
  
  With m_ObjAbm.Properties
  
    With .Add(Nothing, cscDocLlevaFirma)
      .PropertyType = cspCheck
      .TopFromProperty = cscActivo
      .TopNotChange = True
      .Left = 3600
      .LeftNotChange = True
      .Name = LNGGetText(2582, vbNullString)  'Lleva Firma
      .Key = K_LLEVAFIRMA
      .Value = CInt(m_LlevaFirma)
    End With
    
    With .Add(Nothing, cscTaId)
      .PropertyType = cspHelp
      .Table = csTalonario
      .Name = LNGGetText(1256, vbNullString)  'Talonario
      .Key = K_TA_ID
      .Value = m_Talonario
      .HelpId = m_ta_id
      .HelpFilter = "emp_id = " & m_emp_id
    End With
    
    Set c = .Add(Nothing, cscDocIdAsiento)
    With c
      .PropertyType = cspHelp
      .Table = csETablasDocumento.CSDocumento
      .HelpFilter = pGetAsIdFilter(m_emp_id)
      .Name = LNGGetText(2596, vbNullString)  'Documento Asiento
      .Value = m_DocumentoAsiento
      .HelpId = m_Doc_id_Asiento
      .Key = K_DOC_ID_ASIENTO
      
      Set o = c
      o.IsForAbm = True
      
    End With
  End With
End Sub

Private Sub pShowOrdenCompra()
  
  Dim iTab As cIABMTabItem
  
  Set iTab = m_ObjAbm.Tabs.Add(iTab)
  iTab.Index = m_ObjAbm.Tabs.Count - 1
  iTab.Name = LNGGetText(2581, vbNullString)  'Configuración
  
  With m_ObjAbm.Properties
  
    With .Add(Nothing, c_OrdenDirecta)
      .PropertyType = cspOption
      .OptionGroup = 0
      .Width = 2000
      .Name = LNGGetText(2589, vbNullString)  'Sin documento previo
      .Key = K_OC_DIRECTA
      .Value = 0
      .TabIndex = iTab.Index
    End With
    
    With .Add(Nothing, c_OrdenDesdePedido)
      .PropertyType = cspOption
      .OptionGroup = 0
      .Width = 2000
      .TopToPrevious = 300
      .Name = LNGGetText(2608, vbNullString)  'Desde pedido
      .Key = K_OC_DESDE_PC
      .Value = 0
      .TabIndex = iTab.Index
    End With
    
    With .Add(Nothing, c_OrdenDesdePresupuesto)
      .PropertyType = cspOption
      .TopToPrevious = 300
      .OptionGroup = 0
      .Width = 2000
      .Name = LNGGetText(2609, vbNullString)  'Desde presupuesto
      .Key = K_OC_DESDE_PRC
      .Value = 0
      .TabIndex = iTab.Index
    End With
  End With
  
  Select Case m_TipoOrdenCompra
    Case csETOrdenDirecta
      m_ObjAbm.Properties(c_OrdenDirecta).Value = 1
    Case csETOrdenPedido
      m_ObjAbm.Properties(c_OrdenDesdePedido).Value = 1
    Case csETOrdenPresupuesto
      m_ObjAbm.Properties(c_OrdenDesdePresupuesto).Value = 1
  End Select
End Sub

Private Sub pShowLiquidacion()
  Dim c As cIABMProperty
  Dim o As cABMProperty
  
  With m_ObjAbm.Properties
  
    With .Add(Nothing, cscDocLlevaFirma)
      .PropertyType = cspCheck
      .TopFromProperty = cscActivo
      .TopNotChange = True
      .Left = 3600
      .LeftNotChange = True
      .Name = LNGGetText(2582, vbNullString)  'Lleva Firma
      .Key = K_LLEVAFIRMA
      .Value = CInt(m_LlevaFirma)
    End With
    
    With .Add(Nothing, cscTaId)
      .PropertyType = cspHelp
      .Table = csTalonario
      .Name = LNGGetText(1256, vbNullString)   'Talonario
      .Key = K_TA_ID
      .Value = m_Talonario
      .HelpId = m_ta_id
    End With
    
    With .Add(Nothing, cscTaIdHaberes)
      .PropertyType = cspHelp
      .Table = csTalonario
      .Name = LNGGetText(4641, vbNullString)   'Talonario de Recibo
      .Key = K_TA_ID_HABERES
      .Value = m_TalonarioHaberes
      .HelpId = m_ta_id_Haberes
      .TopToPrevious = 400
    End With
    
    With .Add(Nothing, cscMonId)
      .PropertyType = cspHelp
      .Table = csMoneda
      .Name = LNGGetText(1113, vbNullString)   'Moneda
      .Key = K_MON_ID
      .Value = m_Moneda
      .HelpId = m_mon_id
      .TopToPrevious = 400
    End With
    
    Set c = .Add(Nothing, cscDocIdAsiento)
    With c
      .PropertyType = cspHelp
      .Table = csETablasDocumento.CSDocumento
      .HelpFilter = pGetAsIdFilter(m_emp_id)
      .Name = LNGGetText(2596, vbNullString)   'Documento Asiento
      .Value = m_DocumentoAsiento
      .HelpId = m_Doc_id_Asiento
      .Key = K_DOC_ID_ASIENTO
      .TopToPrevious = 400
      
      Set o = c
      o.IsForAbm = True
      
    End With
  End With
End Sub

Private Sub pShowReportes()
  Dim iTab As cIABMTabItem
  Dim c As cIABMProperty
  
  Set iTab = m_ObjAbm.Tabs.Add(iTab)
  iTab.Index = m_ObjAbm.Tabs.Count - 1
  iTab.Name = LNGGetText(2577, vbNullString)  'Reportes

  With m_ObjAbm.Properties
    
    Set c = .Add(Nothing, c_Reportes)
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      If Not pLoadReportes(c) Then Exit Sub
      'TODO VER CON JAVIER
      .Name = "Reportes"
      .Key = K_REPORTES
      .TabIndex = iTab.Index
      .GridAdd = True
      .GridEdit = True
      .GridRemove = True
    End With
  End With
End Sub

Private Sub pShowFirmas()
  Dim iTab As cIABMTabItem
  Dim c As cIABMProperty

  If Not (m_LlevaFirma _
          Or m_LlevaFirmaCredito _
          Or m_LlevaFirmaPrint0) Then Exit Sub

  Set iTab = m_ObjAbm.Tabs.Add(iTab)
  iTab.Index = m_ObjAbm.Tabs.Count - 1
  iTab.Name = LNGGetText(2610, vbNullString)  'Firmas

  With m_ObjAbm.Properties
    
    Set c = .Add(Nothing, c_Firmas)
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      If Not pLoadFirmas(c) Then Exit Sub
      .Name = "Firmas"
      .Key = K_FIRMAS
      .TabIndex = iTab.Index
      .GridAdd = True
      .GridEdit = True
      .GridRemove = True
    End With
  End With
  
  m_FirmasDeleted = vbNullString
End Sub

Private Function pIsEmptyRow(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim bRowIsEmpty           As Boolean
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_NOMBRE
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KI_CSRFILE
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRow = bRowIsEmpty
End Function

Private Function pIsEmptyRowFirmas(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim bRowIsEmpty           As Boolean
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_US_ID
        If Not ValEmpty(Cell.Id, csId) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowFirmas = bRowIsEmpty
End Function

Private Sub pChangeEmpresa()
  Dim emp_id As Long
  Dim AbmObj As cABMGeneric
  
  Set AbmObj = m_ObjAbm
  
  With m_ObjAbm.Properties
  
    emp_id = .Item(cscEmpId).HelpId
    
    Select Case m_Doct_id
      
      Case csEDT_FacturaVenta, csEDT_NotaCreditoVenta, csEDT_NotaDebitoVenta
        
        With .Item(cscDocIdAsiento)
          .HelpFilter = pGetAsIdFilter(emp_id)
        End With
        AbmObj.ValidateProp Nothing, cscDocIdAsiento
        
        With .Item(cscTaIdInscripto)
          .HelpFilter = "emp_id = " & emp_id
        End With
        AbmObj.ValidateProp Nothing, cscTaIdInscripto
          
        With .Item(cscTaIdFinal)
          .HelpFilter = "emp_id = " & emp_id
        End With
        AbmObj.ValidateProp Nothing, cscTaIdFinal
      
        With .Item(cscTaIdExterno)
          .HelpFilter = "emp_id = " & emp_id
        End With
        AbmObj.ValidateProp Nothing, cscTaIdExterno
        
        With .Item(cscDocIdRemito)
          .HelpFilter = "'emp_id = " & emp_id & _
                        " and doct_id = " & csEDT_RemitoVenta & "'"
        End With
        AbmObj.ValidateProp Nothing, cscDocIdRemito
        
        With .Item(cscDocIdStock)
          .HelpFilter = "'emp_id = " & emp_id & _
                        " and doct_id = " & csEDT_TrasferenciaStock & "'"
        End With
        AbmObj.ValidateProp Nothing, cscDocIdStock

      Case csEDT_FacturaCompra, csEDT_NotaCreditoCompra, csEDT_NotaDebitoCompra
        
        With .Item(cscDocIdAsiento)
          .HelpFilter = "'emp_id = " & emp_id & " and doct_id = " _
                        & csEDT_AsientoContable & "'"
        End With
        AbmObj.ValidateProp Nothing, cscDocIdAsiento
        
        With .Item(cscTaIdInscripto)
          .HelpFilter = "emp_id = " & emp_id
        End With
        AbmObj.ValidateProp Nothing, cscTaIdInscripto
        
        With .Item(cscTaIdFinal)
          .HelpFilter = "emp_id = " & emp_id
        End With
        AbmObj.ValidateProp Nothing, cscTaIdFinal
        
        With .Item(cscTaIdExterno)
          .HelpFilter = "emp_id = " & emp_id
        End With
        AbmObj.ValidateProp Nothing, cscTaIdExterno
        
        With .Item(cscTaIdInscriptoM)
          .HelpFilter = "emp_id = " & emp_id
        End With
        AbmObj.ValidateProp Nothing, cscTaIdInscriptoM
  
        With .Item(cscDocIdRemito)
          .HelpFilter = "'emp_id = " & emp_id & " and doct_id = " & _
                          csEDT_RemitoCompra & "'"
        End With
        AbmObj.ValidateProp Nothing, cscDocIdRemito
        
        With .Item(cscDocIdStock)
          .HelpFilter = "'emp_id = " & emp_id & " and doct_id = " & _
                          csEDT_TrasferenciaStock & "'"
        End With
        AbmObj.ValidateProp Nothing, cscDocIdStock

      Case csEDT_RemitoVenta, csEDT_DevolucionRemitoVta
        
        With .Item(cscTaId)
          .HelpFilter = "emp_id = " & emp_id
        End With
        AbmObj.ValidateProp Nothing, cscTaId
          
        With .Item(cscDocIdStock)
          .HelpFilter = "'emp_id = " & emp_id & " and doct_id = " & _
                          csEDT_TrasferenciaStock & "'"
        End With
        AbmObj.ValidateProp Nothing, cscDocIdStock
         
'      Case csEDT_PackingList, csEDT_PackingListDevolucion
'        pShowPackingList
'      Case csEDT_ManifiestoCarga
'        pShowManifiestoCarga
'      Case csEDT_PermisoEmbarque
'        pShowPermisoEmbarque
      Case csEDT_OrdenServicio
        
        With .Item(cscTaId)
          .HelpFilter = "emp_id = " & emp_id
        End With
        AbmObj.ValidateProp Nothing, cscTaId
        
        With .Item(cscDocIdStock)
          .HelpFilter = "'emp_id = " & emp_id & " and doct_id = " & _
                        csEDT_TrasferenciaStock & "'"
        End With
        AbmObj.ValidateProp Nothing, cscDocIdStock
      
      Case csEDT_RemitoCompra, csEDT_DevolucionRemitoCpra
        
        With .Item(cscTaId)
          .HelpFilter = "emp_id = " & emp_id
        End With
        AbmObj.ValidateProp Nothing, cscTaId
        
        With .Item(cscDocIdStock)
          .HelpFilter = "'emp_id = " & emp_id & " and doct_id = " & _
                        csEDT_TrasferenciaStock & "'"
        End With
        AbmObj.ValidateProp Nothing, cscDocIdStock

      Case csEDT_ImportacionTemp
        With .Item(cscDocIdStock)
          .HelpFilter = "'emp_id = " & emp_id & " and doct_id = " & _
                        csEDT_TrasferenciaStock & "'"
        End With
        AbmObj.ValidateProp Nothing, cscDocIdStock

'      Case csEDT_PedidoVenta, csEDT_DevolucionPedidoVta
'        pShowDoc
'      Case csEDT_PedidoCompra, csEDT_DevolucionPedidoCpra
'        pShowDoc
'      Case csEDT_PresupuestoVenta, csEDT_DevolucionPresuVta
'        pShowDoc
'      Case csEDT_PresupuestoCompra, csEDT_DevolucionPresuCpra
'        pShowDoc
'      Case csEDT_OrdenCompra, csEDT_DevolucionOrdenCpra
'        pShowDoc
'        pShowOrdenCompra
'      Case csEDT_CotizacionCompra, csEDT_DevolucionCotizacionCpra
'        pShowDoc
      Case csEDT_MovimientoFondo
        With .Item(cscDocIdAsiento)
          .HelpFilter = "'emp_id = " & emp_id & " and doct_id = " & _
                          csEDT_AsientoContable & "'"
        End With
        AbmObj.ValidateProp Nothing, cscDocIdAsiento

      Case csEDT_DepositoBanco, csEDT_DepositoCupon, csEDT_ResolucionCupon
        With .Item(cscDocIdAsiento)
          .HelpFilter = "'emp_id = " & emp_id & " and doct_id = " & _
                        csEDT_AsientoContable & "'"
        End With
        AbmObj.ValidateProp Nothing, cscDocIdAsiento
        
      Case csEDT_Cobranza
        With .Item(cscTaId)
          .HelpFilter = "emp_id = " & emp_id
        End With
        AbmObj.ValidateProp Nothing, cscTaId
        
        With .Item(cscDocIdAsiento)
          .HelpFilter = "'emp_id = " & emp_id & " and doct_id = " & _
                        csEDT_AsientoContable & "'"
        End With
        AbmObj.ValidateProp Nothing, cscDocIdAsiento
        
      Case csEDT_RecuentoStock, csEDT_ParteProdKit, _
           csEDT_ParteDesarmeKit, csEDT_ParteReparacion, _
           csEDT_StockProveedor, csEDT_StockCliente
        With .Item(cscDocIdStock)
          .HelpFilter = "'emp_id = " & emp_id & " and doct_id = " & _
                          csEDT_TrasferenciaStock & "'"
        End With
        AbmObj.ValidateProp Nothing, cscDocIdStock
        
      Case csEDT_OrdenPago
        With .Item(cscTaId)
          .HelpFilter = "emp_id = " & emp_id
        End With
        AbmObj.ValidateProp Nothing, cscTaId
        
        With .Item(cscDocIdAsiento)
          .HelpFilter = "'emp_id = " & emp_id & " and doct_id = " & _
                        csEDT_AsientoContable & "'"
        End With
        AbmObj.ValidateProp Nothing, cscDocIdAsiento
        
    End Select
  End With
End Sub

Private Sub pSavePermisos(ByVal IdFrom As Long, _
                          ByVal IdTo As Long, _
                          ByVal bIsNew As Boolean)
  Dim sqlstmt As String

  If m_Copy Then
    If Ask(LNGGetText(3478, vbNullString, m_Nombre), _
               vbYes) Then
    
      sqlstmt = "sp_DocumentoDuplicarPermisos " & User.Id & "," & IdFrom & "," & IdTo
      gDB.Execute sqlstmt
    
      ' Refrezca la seguridad
      '
      CSOAPI2.Refresh
    End If
  End If
  
  If bIsNew Then
    If Ask(LNGGetText(3525, vbNullString), vbYes) Then
      cIABMClient_MessageEx MSG_EDIT_PERMISOS, Nothing
    End If
  End If
End Sub

Private Function pGetAsIdFilter(ByVal emp_id As Long) As String
  pGetAsIdFilter = "'emp_id = " & emp_id & _
                   " and doct_id = " & csEDT_AsientoContable & _
                   " and activo <> 0'"
End Function

' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  c_ErrorSave = LNGGetText(2611, vbNullString)  'Error al grabar Documento
  
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

VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cRechazoCheque"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIABMClient
Implements CSMenu.cIMenuClient
'--------------------------------------------------------------------------------
' cRechazoCheque
' 15-01-2006

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cRechazoCheque"

Private Const cscFcNrodoc1 = "fc_nrodoc1"
Private Const cscFcNrodoc2 = "fc_nrodoc2"
Private Const c_info = "info"

Private Const K_CHEQ_ID = 1
Private Const K_INFO_CHEQ = 2
Private Const K_RECHAZADO = 3
Private Const K_FECHA = 4
Private Const K_FC_ID_1 = 5
Private Const K_FC_ID_2 = 6
Private Const K_FV_ID = 7
Private Const K_FC_IMP_1 = 8
Private Const K_FC_IMP_2 = 9
Private Const K_FV_IMP = 10
Private Const K_CHEQ_DESCRIP = 11

Private Const cscCliNombre                          As String = "cli_nombre"

' estructuras
' variables privadas
Private m_Editing           As Boolean
Private m_Host              As CSMenu.cIMenuHost
Private m_ObjAbm            As cIABMGeneric

Private m_Id                As Long
Private m_rechazado         As Boolean
Private m_fechaRechazo      As Date
Private m_info              As String
Private m_fc_id_1           As Long
Private m_fc_id_2           As Long
Private m_fv_id             As Long
Private m_fc_id_1_nro       As String
Private m_fc_id_2_nro       As String
Private m_fv_id_nro         As String
Private m_fc_imp_1          As Double
Private m_fc_imp_2          As Double
Private m_fv_imp            As Double
Private m_Descrip           As String
Private m_Prov_id           As Long
Private m_Cli_id            As Long

' eventos
' propiedades publicas
' propiedades friend
' propiedades privadas
' funciones publicas
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
  cIABMClient_ShowDocDigital = False
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
  Dim bEnabled As Boolean
  
  Select Case Key
    
    Case K_CHEQ_ID
      
      With m_ObjAbm.Properties
        
        If m_Id <> .Item(cscCheqId).HelpId Then
          m_Id = .Item(cscCheqId).HelpId
          bEnabled = m_Id
          
          pLoadCheque
          pRefreshProperties
          
          .Item(cscCheqRechazado).Enabled = bEnabled
          m_ObjAbm.ShowValue .Item(cscCheqRechazado)
        End If
        
        bEnabled = Val(.Item(cscCheqRechazado).Value)
      End With
      
      pSetEnabled bEnabled
    
    Case K_RECHAZADO
      
      bEnabled = Val(m_ObjAbm.Properties.Item(cscCheqRechazado).Value)
      
      pSetEnabled bEnabled
  End Select
End Function

Private Function cIABMClient_Save() As Boolean
  On Error GoTo ControlError
  
  Dim sqlstmt As String
  
  With m_ObjAbm.Properties
  
  sqlstmt = "sp_chequeRechazoSave " & m_Id & "," _
            & IIf(Val(.Item(cscCheqRechazado).Value), 1, 0) & "," _
            & gDB.sqlDate(.Item(cscCheqFechaRechazo).Value) & "," _
            & .Item(cscFcIdNd1).HelpId & "," _
            & .Item(cscFcIdNd2).HelpId & "," _
            & .Item(cscFvIdNd).HelpId & "," _
            & gDB.sqlNumber(.Item(cscCheqFcImporte1).Value) & "," _
            & gDB.sqlNumber(.Item(cscCheqFcImporte2).Value) & "," _
            & gDB.sqlNumber(.Item(cscCheqFvImporte).Value) & "," _
            & gDB.sqlString(.Item(cscCheqDescrip).Value)
  End With
  
  gDB.Execute sqlstmt
  cIABMClient_PropertyChange K_CHEQ_ID
  
  cIABMClient_Save = False
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
End Function

Private Property Get cIABMClient_Title() As String
  cIABMClient_Title = LNGGetText(2216, vbNullString)  'Cheque Rechazado
End Property

Private Function cIABMClient_Validate() As Boolean

  Dim IProperty As cIABMProperty

  CSKernelClient2.Title = LNGGetText(2217, vbNullString)  'Rechazo de Cheques

  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_FECHA
          If Not IsDate(.Value) Then
            MsgWarning LNGGetText(1558, vbNullString)  'Debe indicar una fecha
            Exit Function
          End If
      End Select
    End With
  Next

  cIABMClient_Validate = True
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
  Dim str_2048 As String
  
  str_2048 = LNGGetText(2048, vbNullString) 'T&esoreria
  Set m_Host = Host
  m_Host.Server.AddMenu str_2048, csMenuEnum.csMenuTesoreria, vbNullString, 1, False, False, False, True, False, Nothing
  m_Host.Server.AddMenu LNGGetText(2218, vbNullString), csPreTsrEditRechazoCheque, str_2048, 0, True, False, False, False, False, Me
                          '&Cheques Rechazados
  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, C_MenuClientInit, C_Module, vbNullString
  If Err.Number Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal Id As Long) As Variant
  m_Id = Id
  pEdit
End Function

Private Sub pEdit()
  On Error GoTo ControlError
  
  Set m_ObjAbm = New cABMGeneric
    
  If Not SecurityCanAccess(csPreTsrEditRechazoCheque) Then Exit Sub
  
  m_Id = csNO_ID

  pLoadCheque
  
  If Not LoadCollection() Then Exit Sub
  
  m_Editing = True
  
  Exit Sub
ControlError:
  MngError Err, "pEdit", C_Module, vbNullString
End Sub

Private Function LoadCollection() As Boolean

  m_ObjAbm.Properties.Clear
  
  With m_ObjAbm.Properties.Add(Nothing, cscCheqId)
    .PropertyType = cspHelp
    .Table = csCheque3
    .Name = LNGGetText(2058, vbNullString)  'Cheque
    .Key = K_CHEQ_ID
    .Value = vbNullString
    .HelpId = csNO_ID
  End With
  
  With m_ObjAbm.Properties.Add(Nothing, c_info)
    .PropertyType = cspText
    .SubType = cspMemo
    .Enabled = False
    .Height = 880
    .Width = 6000
    .Name = LNGGetText(2219, vbNullString)  'Info
    .Key = K_INFO_CHEQ
    .Value = m_info
  End With
  
  With m_ObjAbm.Properties.Add(Nothing, cscCheqRechazado)
    .PropertyType = cspCheck
    .Name = LNGGetText(2055, vbNullString)  'Rechazado
    .Key = K_RECHAZADO
    .Value = CInt(m_rechazado)
    .Enabled = False
  End With
  
  With m_ObjAbm.Properties.Add(Nothing, cscCheqFechaRechazo)
    .PropertyType = cspDate
    .Name = LNGGetText(1569, vbNullString)  'Fecha
    .TopFromProperty = cscCheqRechazado
    .Left = 4000
    .LeftLabel = -600
    .LeftNotChange = True
    .Key = K_FECHA
    .Value = m_fechaRechazo
    .Enabled = m_rechazado
  End With
  
  With m_ObjAbm.Properties.Add(Nothing)
    .PropertyType = cspLabel
    .Value = LNGGetText(1489, vbNullString)  'Compras
    .FontBold = True
    .Left = 230
    .LeftNotChange = True
  End With
  
  With m_ObjAbm.Properties.Add(Nothing, cscFcIdNd1)
    .PropertyType = cspHelp
    .Table = csFacturaCompra
    .Name = LNGGetText(2228, vbNullString)  'Nota de Débito 1
    .Key = K_FC_ID_1
    .LeftLabel = -1500
    .Left = 2000
    .Width = 3500
    .Value = m_fc_id_1_nro
    .HelpId = m_fc_id_1
    .HelpFilter = pGetFilterFc()
    .Enabled = m_rechazado
  End With
  
  With m_ObjAbm.Properties.Add(Nothing, cscCheqFcImporte1)
    .PropertyType = cspNumeric
    .SubType = cspDouble
    .Name = LNGGetText(1228, vbNullString)  'Importe
    .TopFromProperty = cscFcIdNd1
    .Left = 6200
    .LeftNotChange = True
    .LeftLabel = -600
    .Width = 1300
    .Key = K_FC_IMP_1
    .Value = m_fc_imp_1
    .Enabled = m_rechazado
  End With
  
  With m_ObjAbm.Properties.Add(Nothing, cscFcIdNd2)
    .PropertyType = cspHelp
    .Table = csFacturaCompra
    .Name = LNGGetText(2229, vbNullString)  'Nota de Débito 2
    .Key = K_FC_ID_2
    .Width = 3500
    .Value = m_fc_id_2_nro
    .HelpId = m_fc_id_2
    .HelpFilter = pGetFilterFc()
    .Enabled = m_rechazado
  End With
  
  With m_ObjAbm.Properties.Add(Nothing, cscCheqFcImporte2)
    .PropertyType = cspNumeric
    .SubType = cspDouble
    .Name = LNGGetText(1228, vbNullString)  'Importe
    .TopFromProperty = cscFcIdNd2
    .Left = 6200
    .LeftNotChange = True
    .LeftLabel = -600
    .Width = 1300
    .Key = K_FC_IMP_2
    .Value = m_fc_imp_2
    .Enabled = m_rechazado
  End With
  
  With m_ObjAbm.Properties.Add(Nothing)
    .PropertyType = cspLabel
    .Value = LNGGetText(1488, vbNullString)  'Ventas
    .FontBold = True
    .Left = 230
    .LeftNotChange = True
  End With
  
  With m_ObjAbm.Properties.Add(Nothing, cscFvIdNd)
    .PropertyType = cspHelp
    .Table = csFacturaVenta
    .Name = LNGGetText(2230, vbNullString)  'Nota de Débito
    .Key = K_FV_ID
    .Width = 3500
    .Value = m_fv_id_nro
    .HelpId = m_fv_id
    .HelpFilter = pGetFilterFv()
    .Enabled = m_rechazado
  End With
  
  With m_ObjAbm.Properties.Add(Nothing, cscCheqFvImporte)
    .PropertyType = cspNumeric
    .SubType = cspDouble
    .Name = LNGGetText(1228, vbNullString)  'Importe
    .TopFromProperty = cscFvIdNd
    .Left = 6200
    .LeftLabel = -600
    .Width = 1300
    .LeftNotChange = True
    .Key = K_FV_IMP
    .Value = m_fv_imp
    .Enabled = m_rechazado
  End With
  
  With m_ObjAbm.Properties.Add(Nothing, cscCheqDescrip)
    .PropertyType = cspText
    .SubType = cspMemo
    .Name = LNGGetText(1861, vbNullString)  'Observaciones
    .Key = K_CHEQ_DESCRIP
    .Value = m_Descrip
    .Left = 1500
    .TopToPrevious = 880
    .Width = 6000
    .Height = 880
    .Enabled = m_rechazado
  End With
  
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  With AbmObj
    .bDontAskForSave = True
    .OkCancelDialog = True
    .MinHeight = 8500
    With .Frm
      With .cmdSave
        .Caption = LNGGetText(2231, vbNullString)  '&Guardar
        .Style = 3 ' csSave
      End With
      .cmdCancel.Caption = LNGGetText(2232, vbNullString)  '&Cerrar
    End With
  End With
  m_ObjAbm.InModalWindow = True

  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function
' funciones friend
' funciones privadas
' construccion - destruccion
Private Sub Class_Terminate()
  On Error Resume Next
  Set m_ObjAbm = Nothing
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

Private Function pGetFilterFc() As String
  Dim rtn As String
  rtn = "(fc.est_id<>7 and fc.doct_id = 10 " _
        & " and fc.prov_id = " & m_Prov_id _
        & " and exists(select * from documento doc where doc.doc_id = fc.doc_id and emp_id = " & EmpId & ")" _
        & ")"
  pGetFilterFc = rtn
End Function

Private Function pGetFilterFv() As String
  Dim rtn As String
  rtn = "(fv.est_id<>7 and fv.doct_id = 9 and fv.emp_id = " _
        & EmpId & " and fv.cli_id = " & m_Cli_id & ")"
  pGetFilterFv = rtn
End Function

Private Function pLoadCheque() As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_chequeRechazoGet " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  If Not rs.EOF Then
    m_info = gDB.ValField(rs.Fields, c_info)
    m_rechazado = gDB.ValField(rs.Fields, cscCheqRechazado)
    m_fechaRechazo = gDB.ValField(rs.Fields, cscCheqFechaRechazo)
    m_fc_id_1 = gDB.ValField(rs.Fields, cscFcIdNd1)
    m_fc_id_2 = gDB.ValField(rs.Fields, cscFcIdNd2)
    m_fv_id = gDB.ValField(rs.Fields, cscFvIdNd)
    m_fc_id_1_nro = gDB.ValField(rs.Fields, cscFcNrodoc1)
    m_fc_id_2_nro = gDB.ValField(rs.Fields, cscFcNrodoc2)
    m_fv_id_nro = gDB.ValField(rs.Fields, cscFvNrodoc)
    m_fc_imp_1 = gDB.ValField(rs.Fields, cscCheqFcImporte1)
    m_fc_imp_2 = gDB.ValField(rs.Fields, cscCheqFcImporte2)
    m_fv_imp = gDB.ValField(rs.Fields, cscCheqFvImporte)
    m_Descrip = gDB.ValField(rs.Fields, cscCheqDescrip)
    m_Prov_id = gDB.ValField(rs.Fields, cscProvId)
    m_Cli_id = gDB.ValField(rs.Fields, cscCliId)
  Else
    m_info = vbNullString
    m_rechazado = False
    m_fechaRechazo = csNoDate
    m_fc_id_1 = csNO_ID
    m_fc_id_2 = csNO_ID
    m_fv_id = csNO_ID
    m_fc_id_1_nro = vbNullString
    m_fc_id_2_nro = vbNullString
    m_fv_id_nro = vbNullString
    m_fc_imp_1 = 0
    m_fc_imp_2 = 0
    m_fv_imp = 0
    m_Descrip = vbNullString
    m_Prov_id = csNO_ID
    m_Cli_id = csNO_ID
  
  End If
  
  pLoadCheque = True
End Function

Private Sub pSetEnabled(ByVal bEnabled As Boolean)
  With m_ObjAbm.Properties
    .Item(cscCheqFechaRechazo).Enabled = bEnabled
    .Item(cscCheqFvImporte).Enabled = bEnabled
    .Item(cscCheqFcImporte1).Enabled = bEnabled
    .Item(cscCheqFcImporte2).Enabled = bEnabled
    .Item(cscCheqDescrip).Enabled = bEnabled
    .Item(cscFcIdNd1).Enabled = bEnabled
    .Item(cscFcIdNd2).Enabled = bEnabled
    .Item(cscFvIdNd).Enabled = bEnabled
    
    m_ObjAbm.ShowValue .Item(cscCheqFechaRechazo)
    m_ObjAbm.ShowValue .Item(cscCheqFvImporte)
    m_ObjAbm.ShowValue .Item(cscCheqFcImporte1)
    m_ObjAbm.ShowValue .Item(cscCheqFcImporte2)
    m_ObjAbm.ShowValue .Item(cscCheqFvImporte)
    m_ObjAbm.ShowValue .Item(cscCheqDescrip)
    m_ObjAbm.ShowValue .Item(cscFcIdNd1)
    m_ObjAbm.ShowValue .Item(cscFcIdNd2)
    m_ObjAbm.ShowValue .Item(cscFvIdNd)
  End With
End Sub

Private Sub pRefreshProperties()
  Dim c             As cIABMProperty
  Dim AbmGen        As cABMGeneric
  
  With m_ObjAbm.Properties
  
    With .Item(c_info)
      .Value = m_info
    End With
    
    With .Item(cscCheqRechazado)
      .Value = CInt(m_rechazado)
    End With
    
    With .Item(cscCheqFechaRechazo)
      .Value = m_fechaRechazo
    End With
    
    With .Item(cscFcIdNd1)
      .HelpId = m_fc_id_1
      .Value = m_fc_id_1_nro
      .HelpFilter = pGetFilterFc()
    End With
    
    With .Item(cscCheqFcImporte1)
      .Value = m_fc_imp_1
    End With
    
    With .Item(cscFcIdNd2)
      .HelpId = m_fc_id_2
      .Value = m_fc_id_2_nro
      .HelpFilter = pGetFilterFc()
    End With
    
    With .Item(cscCheqFcImporte2)
      .Value = m_fc_imp_2
    End With
    
    With .Item(cscFvIdNd)
      .HelpId = m_fv_id
      .Value = m_fv_id_nro
      .HelpFilter = pGetFilterFv()
    End With
    
    With .Item(cscCheqFvImporte)
      .Value = m_fv_imp
    End With
    
    With .Item(cscCheqDescrip)
      .Value = m_Descrip
    End With
  
  End With
  
  Set AbmGen = m_ObjAbm
  AbmGen.ShowValues m_ObjAbm.Properties
  
  AbmGen.ResetChanged
End Sub

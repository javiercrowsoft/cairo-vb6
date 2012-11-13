VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cBancoConciliacion"
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
' cBancoConciliacion
' 29-10-2006

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cBancoConciliacion"

'AsientoItem
Private Const csTAsientoItem                           As String = "AsientoItem"
Private Const cscAsiId                                 As String = "asi_id"
Private Const cscAsiOrden                              As String = "asi_orden"
Private Const cscAsiDescrip                            As String = "asi_descrip"
Private Const cscAsiDebe                               As String = "asi_debe"
Private Const cscAsiHaber                              As String = "asi_haber"
Private Const cscAsiOrigen                             As String = "asi_origen"
Private Const cscAsiConciliado                         As String = "asi_conciliado"

Private Const c_fechacobrocheque As String = "fecha_cheqe"
Private Const c_load             As String = "load"
Private Const c_Items            As String = "Items"
Private Const c_Origen           As String = "ORIGEN"

Private Const c_saldoIniP        As String = "SaldoIniP"
Private Const c_saldoIniC        As String = "SaldoIniC"
Private Const c_saldoIniR        As String = "SaldoIniR"
Private Const c_saldoInicial     As String = "SaldoIni"

Private Const c_conciliado       As String = "conciliado"
Private Const c_pendiente        As String = "pendiente"
Private Const c_rechazado        As String = "rechazado"

Private Const c_totalP           As String = "totalP"
Private Const c_totalC           As String = "totalC"
Private Const c_totalR           As String = "totalR"
Private Const c_total            As String = "total"

Private Const c_saldo            As String = "saldo"

Private Const c_ver_cheques      As String = "c_ver_cheques"
Private Const c_ver_pendientes   As String = "c_ver_pendiente"

Private Const K_CUE_ID                         As Integer = 1
Private Const K_DESDE                          As Integer = 2
Private Const K_HASTA                          As Integer = 3
Private Const K_FECHA_COBRO_CHEQUE             As Integer = 4

Private Const K_SALDO_INI_CONT                 As Integer = 5
Private Const K_SALDO_INI_BCO                  As Integer = 50
Private Const K_SALDO_INI_REC                  As Integer = 51
Private Const K_SALDO_INI_PEND                 As Integer = 52

Private Const K_CONCILIADO_BCO                 As Integer = 6
Private Const K_PENDIENTE                      As Integer = 7
Private Const K_RECHAZADO                      As Integer = 8

Private Const K_SALDO_PEND                     As Integer = 90
Private Const K_SALDO_CONT                     As Integer = 91
Private Const K_SALDO_BCO                      As Integer = 92
Private Const K_SALDO_REC                      As Integer = 93

Private Const K_VER_CHEQUES                    As Integer = 10
Private Const K_VER_PENDIENTES                 As Integer = 20
Private Const K_DESCRIP                        As Integer = 22
Private Const K_FECHA                          As Integer = 23

Private Const K_LOAD                           As Integer = 100
Private Const K_ITEMS                          As Integer = 101

Private Const KI_ASI_ID                         As Integer = 1
Private Const KI_FECHA                          As Integer = 2
Private Const KI_CONCILIADO                     As Integer = 3
Private Const KI_ORDEN                          As Integer = 4
Private Const KI_DESCRIP                        As Integer = 6
Private Const KI_HABER                          As Integer = 20
Private Const KI_DEBE                           As Integer = 21
Private Const KI_CCOS_ID                        As Integer = 22
Private Const KI_ORIGEN                         As Integer = 24
Private Const KI_DOCT_ID                        As Integer = 25
Private Const KI_COMP_ID                        As Integer = 26

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
Private Const KICH_SALDO_CONT            As Integer = 1017
Private Const KICH_SALDO_BCO             As Integer = 1018

Private Const KI_CHANGED                 As Integer = 9999

' pseudo-constantes
Private c_ErrorSave As String

' estructuras
' variables privadas

Private m_Id                           As Long
Private m_Numero                       As Long
Private m_Fecha                        As Date
Private m_Fechadesde                   As Date
Private m_Fechahasta                   As Date
Private m_SaldoIinicialCont            As Double
Private m_SaldoCont                    As Double
Private m_SaldoInicialBco              As Double
Private m_ConciliadoBco                As Double
Private m_SaldoBco                     As Double
Private m_SaldoInicialRech             As Double
Private m_rechazado                    As Double
Private m_SaldoRech                    As Double
Private m_SaldoInicialPendiente        As Double
Private m_Pendiente                    As Double
Private m_SaldoPendiente               As Double
Private m_Fechacheque                  As Boolean
Private m_Verpendientes                As Boolean
Private m_Descrip                      As String
Private m_cue_id                       As Long
Private m_cuenta                       As String

Private m_Editing           As Boolean
Private m_Host              As CSMenu.cIMenuHost
Private m_ObjAbm            As cIABMGeneric
Private m_ObjTree           As Object

Private m_GeneralConfig     As cGeneralConfig

Private m_Changed           As Boolean

Private m_LastConciliacion  As Boolean

Private m_BranchId      As Long
Private m_TreeId        As Long

Private m_IsNew         As Boolean
Private m_Copy          As Boolean

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
  
  Select Case MessageID

    Case MSG_ABM_PRINT
      
      Dim AbmObj As cABMGeneric
      Set AbmObj = m_ObjAbm
      
      g_conciliacion_cue_id = pGetCuenta()
      g_conciliacion_desde = pGetDesde()
      g_conciliacion_hasta = pGetHasta()
      g_fecha_cobro_cheque = pGetFechaCobroCheque()
      
      If m_LastConciliacion Then
        If pSave() Then
        
          AbmObj.PrintABM m_Id, -csBancoConciliacion  ' El menos es para que pase Id y no NODO Id en PrintManager
        
        End If
        
      Else
        
        AbmObj.PrintABM m_Id, -csBancoConciliacion  ' El menos es para que pase Id y no NODO Id en PrintManager
      
      End If
      
      cIABMClient_MessageEx = True
    
    Case MSG_ABM_CAN_PRINT
      
      cIABMClient_MessageEx = MSG_ABM_CAN_PRINT
  
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
      
      If m_Changed Then
        If Ask(LNGGetText(2046, vbNullString), vbYes) Then
                'Desea guardar los cambios
          If Not pSave() Then Exit Function
        End If
        m_Changed = False
      End If
      
      If pGetCuenta() = csNO_ID Then
        MsgWarning LNGGetText(1261, vbNullString) 'Debe indicar una cuenta
        Exit Function
      End If
      
      pLoadItemsXCuenta
      pShowTotals
      
    Case K_VER_CHEQUES
    
      pShowHideColsCheque
      pSetNotAskForSave
      
    Case Else
    
      pSetNotAskForSave
      
  End Select
End Function

Private Sub pSetNotAskForSave()
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  AbmObj.bDontAskForSave = True
End Sub

Private Function cIABMClient_Save() As Boolean
  On Error GoTo ControlError
  
  If pSave() Then
  
    m_ObjAbm.Title2 = m_Numero
    
    Dim AbmObj As cABMGeneric
    Set AbmObj = m_ObjAbm
    AbmObj.RefreshTitle

    cIABMClient_PropertyChange K_LOAD
    
  End If
  
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
  cIABMClient_Title = LNGGetText(2047, vbNullString) 'Conciliación Bancaria
End Property

Private Function cIABMClient_Validate() As Boolean

  Dim IProperty As cIABMProperty

  CSKernelClient2.Title = LNGGetText(2047, vbNullString) 'Conciliación Bancaria

  For Each IProperty In m_ObjAbm.Properties
    With IProperty
'      Select Case .Key
'        Case K_FECHA
'          If Not IsDate(.Value) Then
'            MsgWarning "Debe indicar una fecha"
'            Exit Function
'          End If
'      End Select
    End With
  Next

  cIABMClient_Validate = True
End Function

Private Function cIABMClientGrid_ColumnAfterEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long) As Boolean
  cIABMClientGrid_ColumnAfterEdit = True
End Function

Private Function cIABMClientGrid_ColumnAfterUpdate(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long) As Boolean

  Dim Row           As cIABMGridRow
  Dim Debe          As Double
  Dim Haber         As Double
  Dim Pendiente     As Double
  Dim Conciliado    As Double
  Dim Rechazado     As Double
  Dim Total         As Double
  
  Dim oRow          As cABMGridRow
  
  Dim i As Long
  Dim lColSaldo As Long

  Dim iProp  As cIABMProperty
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  Set iProp = pGetItems()

  Set Row = iProp.Grid.Rows.Item(lRow)
  Set oRow = Row
  pCell(Row, KI_CHANGED).Value = 1
  
  Select Case pCell(Row, KI_CONCILIADO).Id
    Case csEBCConciliado
      oRow.ForeColor = vbBlue
    Case csEBCRechazado
      oRow.ForeColor = vbRed
    Case Else ' csEBCPendiente
      oRow.ForeColor = vbWindowText
  End Select
  
  For i = 1 To iProp.Grid.Columns.count
    If iProp.Grid.Columns.Item(i).Key = KICH_SALDO_BCO Then
      lColSaldo = i
      Exit For
    End If
  Next
  
  i = 0
  
  ' 2008-09-10
  ' Esto esta mal
  '
    ' Conciliado = Val(pGetSaldoIniC().Value)
  
  For Each Row In iProp.Grid.Rows
  
    i = i + 1
    Debe = Val(pCell(Row, KI_DEBE).Value)
    Haber = Val(pCell(Row, KI_HABER).Value)

    Select Case pCell(Row, KI_CONCILIADO).Id
      Case csEBCConciliado
        Conciliado = Conciliado + Debe - Haber
        
      Case csEBCRechazado
        Rechazado = Rechazado + Debe - Haber
        
      Case Else ' csEBCPendiente
        Pendiente = Pendiente + Debe - Haber
    End Select
    
    Row.Item(c_saldo).Value = Conciliado
    
    AbmObj.ShowCellValue iProp, i, lColSaldo
  Next

  Total = Val(pGetSaldoIni().Value) + Conciliado + Rechazado + Pendiente
  
  Set iProp = pGetPendiente()
  iProp.Value = Pendiente
  AbmObj.ShowValue iProp

  Set iProp = pGetConciliado()
  iProp.Value = Conciliado
  AbmObj.ShowValue iProp

  Set iProp = pGetRechazado()
  iProp.Value = Rechazado
  AbmObj.ShowValue iProp

  Set iProp = pGetTotalP()
  iProp.Value = Val(pGetSaldoIniP().Value) + Pendiente
  AbmObj.ShowValue iProp
  
  Set iProp = pGetTotalC()
  iProp.Value = Val(pGetSaldoIniC().Value) + Conciliado
  AbmObj.ShowValue iProp
  
  Set iProp = pGetTotalR()
  iProp.Value = Val(pGetSaldoIniR().Value) + Rechazado
  AbmObj.ShowValue iProp

  Set iProp = pGetTotal()
  iProp.Value = Total
  AbmObj.ShowValue iProp

  AbmObj.bDontAskForSave = False
  m_Changed = True

  cIABMClientGrid_ColumnAfterUpdate = True
End Function

Private Function cIABMClientGrid_ColumnBeforeEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean
  cIABMClientGrid_ColumnBeforeEdit = pGetItems().Grid.Rows(lRow).Item(lCol).Key = KI_CONCILIADO
End Function

Private Function cIABMClientGrid_ColumnButtonClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean

End Function

Private Sub cIABMClientGrid_ColumnCancelEdit(ByVal Key As Integer)

End Sub

Private Sub cIABMClientGrid_ColumnClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Sub cIABMClientGrid_DblClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)
  On Error GoTo ControlError
  
  Select Case Key
    
    Case K_ITEMS
    
      If lCol <> 4 Then
      
        With pGetItems().Grid.Rows
          ShowDocAux pGetAsId(Val(pCell(.Item(lRow), KI_ASI_ID).Value)), _
                     "CSContabilidad2.cAsiento", _
                     "CSABMInterface2.cABMGeneric"
        End With
      
      End If
  End Select

  Exit Sub
ControlError:
  MngError Err, "cIABMClientGrid_DblClick", C_Module, vbNullString
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
  Dim str_2048    As String
  
  str_2048 = LNGGetText(2048, vbNullString)   'T&esorería
  Set m_Host = Host
  m_Host.Server.AddMenu str_2048, csMenuEnum.csMenuTesoreria, vbNullString, 1, False, False, False, True, False, Nothing
  m_Host.Server.AddMenu LNGGetText(2049, vbNullString), csPreTsrEditConciliacionBco, str_2048, 0, True, False, False, False, False, Me
                        'Co&nciliación Bancaria
  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, C_MenuClientInit, C_Module, vbNullString
  If Err.Number Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal Id As Long) As Variant
  m_Host.MenuListDocClick "CSABMInterface2.cABMGeneric", "CSTesoreria2.cBancoConciliacion", "CSABMInterface2.CABMGenericListDoc", "CSTesoreria2.cBancoConciliacionListDoc", Me, LNGGetText(2047, vbNullString), 0
  'pEdit
End Function

Private Sub pEdit()
  On Error GoTo ControlError
  
  If m_Editing Then
  
    Dim AbmObj As cABMGeneric
    Set AbmObj = m_ObjAbm
    
    AbmObj.Frm.ZOrder
  
  Else
    Set m_ObjAbm = New cABMGeneric
    
    If Not SecurityCanAccess(csPreTsrEditConciliacionBco) Then Exit Sub
    
    If Not LoadCollection() Then Exit Sub
    
    m_Editing = True
  
  End If
  
  Exit Sub
ControlError:
  MngError Err, "pEdit", C_Module, vbNullString
End Sub

Private Function LoadCollection() As Boolean

  Dim iTab As cIABMTabItem
  
  m_ObjAbm.Properties.Clear
  
  m_ObjAbm.Tabs.Clear
  
  Set iTab = m_ObjAbm.Tabs.Add(Nothing)
  iTab.Index = 0
  iTab.Name = C_strGeneral
  
  Set iTab = m_ObjAbm.Tabs.Add(Nothing)
  iTab.Index = 1
  iTab.Name = LNGGetText(1566, vbNullString)  'Adicionales
  
  m_ObjAbm.Title2 = m_Numero
  
  With m_ObjAbm.Properties.Add(Nothing, cscCueId)
    .PropertyType = cspHelp
    .Table = csCuenta
    .Left = 950
    .LeftLabel = -600
    .Name = LNGGetText(1267, vbNullString)    'Cuenta
    .Key = K_CUE_ID
    .Width = 3900
    .HelpId = m_cue_id
    .Value = m_cuenta
    .Enabled = m_Id = csNO_ID
  End With

  With m_ObjAbm.Properties.Add(Nothing, c_FechaDesde)
    .PropertyType = cspDate
    .Name = LNGGetText(1203, vbNullString)    'Fecha Desde
    .TopFromProperty = cscCueId
    .Left = 6300
    .LeftLabel = -1000
    .LeftNotChange = True
    .Key = K_DESDE
    .Value = m_Fechadesde
  End With

  With m_ObjAbm.Properties.Add(Nothing, c_FechaHasta)
    .PropertyType = cspDate
    .Name = LNGGetText(1204, vbNullString)    'Fecha Hasta
    .TopFromProperty = cscCueId
    .Left = 8900
    .LeftLabel = -1000
    .LeftNotChange = True
    .Key = K_HASTA
    .Value = m_Fechahasta
  End With

  With m_ObjAbm.Properties.Add(Nothing, c_fechacobrocheque)
    .PropertyType = cspCheck
    .Name = LNGGetText(2050, vbNullString)    'Tomar la Fecha de cobro de los Cheques
    .Left = 9980
    .LeftLabel = -3100
    .Value = CInt(m_Fechacheque)
    .Key = K_FECHA_COBRO_CHEQUE
    .TopToPrevious = 340
  End With
  
  With m_ObjAbm.Properties.Add(Nothing, c_ver_pendientes)
    .PropertyType = cspCheck
    .Name = LNGGetText(3862, vbNullString) 'Ver pendientes
    .Key = K_VER_PENDIENTES
    .Left = 9980
    .LeftLabel = -4500
    .TopToPrevious = 340
    .Value = CInt(m_Verpendientes)
  End With
  
  With m_ObjAbm.Properties.Add(Nothing)
    .PropertyType = cspLabel
    .Value = "Saldo Contable"
    .Width = 2000
    .FontBold = True
    .TopFromProperty = c_ver_pendientes
    .TopToPrevious = 100
    .Left = 350
  End With
  
  With m_ObjAbm.Properties.Add(Nothing)
    .PropertyType = cspLabel
    .Value = "Saldo Según Extracto"
    .Width = 2000
    .FontBold = True
    .TopFromProperty = c_ver_pendientes
    .TopToPrevious = 100
    .Left = 2890
  End With
  
  With m_ObjAbm.Properties.Add(Nothing)
    .PropertyType = cspLabel
    .TopFromProperty = c_ver_pendientes
    .TopToPrevious = 100
    .Left = 2790
    .BackColor = &HCCCCCC
    .Height = 1500
    .Width = 20
    .TopNotChange = True
  End With
  
  With m_ObjAbm.Properties.Add(Nothing)
    .PropertyType = cspLabel
    .TopFromProperty = c_ver_pendientes
    .TopToPrevious = 100
    .Left = 5290
    .BackColor = &HCCCCCC
    .Height = 1500
    .Width = 20
    .TopNotChange = True
  End With
  
  With m_ObjAbm.Properties.Add(Nothing, c_saldoInicial)
    .PropertyType = cspNumeric
    .SubType = cspDouble
    .Name = LNGGetText(2054, vbNullString)    'Saldo Incial
    .Left = 1400
    .Width = 1200
    .LeftLabel = -1050
    .Key = K_SALDO_INI_CONT
    .Enabled = False
    .Value = m_SaldoInicialPendiente
  End With

  With m_ObjAbm.Properties.Add(Nothing, c_saldoIniC)
    .PropertyType = cspNumeric
    .SubType = cspDouble
    .Name = LNGGetText(2052, vbNullString)    'S. Conciliado
    .TopFromProperty = c_saldoInicial
    .Left = 3950
    .Width = 1200
    .LeftLabel = -1050
    .Key = K_SALDO_INI_BCO
    .Enabled = False
    .Value = m_SaldoInicialBco
  End With

  With m_ObjAbm.Properties.Add(Nothing, c_saldoIniR)
    .PropertyType = cspNumeric
    .SubType = cspDouble
    .Name = LNGGetText(2053, vbNullString)    'S. Rechazado
    .TopFromProperty = c_saldoInicial
    .Left = 6550
    .Width = 1200
    .LeftLabel = -1150
    .Key = K_SALDO_INI_REC
    .Enabled = False
    .Value = m_SaldoInicialRech
  End With

  With m_ObjAbm.Properties.Add(Nothing, c_saldoIniP)
    .PropertyType = cspNumeric
    .SubType = cspDouble
    .Name = LNGGetText(2051, vbNullString)    'S. Pendiente
    .TopFromProperty = c_saldoInicial
    .Left = 8950
    .Width = 1200
    .LeftLabel = -1000
    .Key = K_SALDO_INI_PEND
    .Enabled = False
    .Value = m_SaldoInicialPendiente
  End With

  With m_ObjAbm.Properties.Add(Nothing, c_total)
    .PropertyType = cspNumeric
    .SubType = cspDouble
    .Name = LNGGetText(1584, vbNullString)    'Total
    .Left = 1400
    .LeftLabel = -500
    .Key = K_SALDO_CONT
    .Enabled = False
    .TopFromProperty = c_saldoInicial
    .TopToPrevious = 710
    .Value = m_SaldoCont
  End With
  
  With m_ObjAbm.Properties.Add(Nothing, c_conciliado)
    .PropertyType = cspNumeric
    .SubType = cspDouble
    .Name = LNGGetText(2056, vbNullString)    'Conciliado
    .Left = 3950
    .Width = 1200
    .LeftLabel = -900
    .Key = K_CONCILIADO_BCO
    .Enabled = False
    .TopFromProperty = c_saldoIniC
    .TopToPrevious = 360
    .Value = m_ConciliadoBco
  End With

  With m_ObjAbm.Properties.Add(Nothing, c_rechazado)
    .PropertyType = cspNumeric
    .SubType = cspDouble
    .Name = LNGGetText(2055, vbNullString)    'Rechazado
    .Left = 6550
    .LeftLabel = -950
    .Key = K_RECHAZADO
    .TopFromProperty = c_conciliado
    .Enabled = False
    .Value = m_rechazado
  End With

  With m_ObjAbm.Properties.Add(Nothing, c_pendiente)
    .PropertyType = cspNumeric
    .SubType = cspDouble
    .Name = LNGGetText(1609, vbNullString)    'Pendiente
    .Left = 8950
    .LeftLabel = -820
    .Key = K_PENDIENTE
    .TopFromProperty = c_conciliado
    .Enabled = False
    .Value = m_Pendiente
  End With

  With m_ObjAbm.Properties.Add(Nothing, c_totalC)
    .PropertyType = cspNumeric
    .SubType = cspDouble
    .Name = LNGGetText(1584, vbNullString)    'Total
    .Left = 3950
    .Width = 1200
    .LeftLabel = -550
    .Key = K_SALDO_BCO
    .TopFromProperty = c_total
    .Enabled = False
    .Value = m_SaldoBco
  End With

  With m_ObjAbm.Properties.Add(Nothing, c_totalR)
    .PropertyType = cspNumeric
    .SubType = cspDouble
    .Name = LNGGetText(1584, vbNullString)    'Total
    .Left = 6550
    .LeftLabel = -550
    .Key = K_SALDO_REC
    .TopFromProperty = c_total
    .Enabled = False
    .Value = m_SaldoInicialRech
  End With

  With m_ObjAbm.Properties.Add(Nothing, c_totalP)
    .PropertyType = cspNumeric
    .SubType = cspDouble
    .Name = LNGGetText(1584, vbNullString)    'Total
    .LeftLabel = -520
    .Key = K_SALDO_PEND
    .Left = 8950
    .TopFromProperty = c_total
    .Enabled = False
    .Value = m_SaldoPendiente
  End With

  With m_ObjAbm.Properties.Add(Nothing, c_load)
    .PropertyType = cspButton
    .Left = 350
    .Name = LNGGetText(2057, vbNullString)    'Cargar
    .LeftLabel = -1
    .TopFromProperty = c_totalP
    .TopToPrevious = 440
    .Enabled = m_LastConciliacion
    .Key = K_LOAD
  End With
  
  With m_ObjAbm.Properties.Add(Nothing, c_ver_cheques)
    .PropertyType = cspCheck
    .Name = LNGGetText(3805, vbNullString) 'Ver detalle del cheque
    .Key = K_VER_CHEQUES
    .Left = 5000
    .LeftLabel = -1800
    .TopFromProperty = c_load
  End With

  Dim c As cIABMProperty
  Set c = m_ObjAbm.Properties.Add(Nothing, c_Items)
  With c
    .PropertyType = cspGrid
    .LeftLabel = -1
    .TopFromProperty = c_load
    .TopToPrevious = 440
    .Left = 350
    If Not pLoadItems(c) Then Exit Function
    .Name = c_Items
    .Key = K_ITEMS
    .GridAdd = False
    .GridRemove = False
    .GridEdit = m_LastConciliacion
  End With

  With m_ObjAbm.Properties.Add(Nothing, cscBcocFecha)
    .PropertyType = cspDate
    .Name = LNGGetText(1569, vbNullString)  'Fecha
    .Key = K_FECHA
    .Value = m_Fecha
    .Left = 1300
    .LeftLabel = -1000
    .TabIndex = 1
  End With

  With m_ObjAbm.Properties.Add(Nothing, cscBcocDescrip)
    .PropertyType = cspText
    .SubType = cspMemo
    .Name = LNGGetText(1211, vbNullString)  'Observ.
    .Key = K_DESCRIP
    .Value = m_Descrip
    .Width = 7000
    .Height = 1200
    .TabIndex = 1
  End With
  
  ' Si es la ultima conciliacion
  '
  If m_Id Then
    
    If m_LastConciliacion Then
  
      pLoadItemsXCuenta
    
    Else
    
      pLoadItemsFromItems
      
    End If
    
  End If
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  ' Ojo esto no se puede pasar al if de arriba
  ' por que hay que esperar a que se resuelva
  '
  '    m_ObjAbm.Show(Me)
  '
  ' sino se cruzan eventos y kaput :)
  '
  If m_Id Then
  
    If m_LastConciliacion Then
      
      pShowTotals
    
    End If
  
  End If
  
  pShowHideColsCheque

  LoadCollection = True
End Function

Private Function pLoadItems(ByRef Propiedad As cIABMProperty) As Boolean
  
  With Propiedad.Grid
  
    .Columns.Clear
    .Rows.Clear
    
    With .Columns
  
      With .Add(Nothing)
        .Visible = False
        .Key = KI_ASI_ID
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1569, vbNullString)    'Fecha
        .PropertyType = cspDate
        .Key = KI_FECHA
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1568, vbNullString)    'Estado
        .PropertyType = cspList
        With .List.Add(Nothing)
          .Id = csEBCPendiente
          .Value = LNGGetText(1609, vbNullString)    'Pendiente
        End With
        With .List.Add(Nothing)
          .Id = csEBCConciliado
          .Value = LNGGetText(2056, vbNullString)    'Conciliado
        End With
        With .List.Add(Nothing)
          .Id = csEBCRechazado
          .Value = LNGGetText(2055, vbNullString)    'Rechazado
        End With
        .Width = 2000
        .Key = KI_CONCILIADO
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1904, vbNullString)    'Debe
        .Format = m_GeneralConfig.FormatDecImporte
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Width = 1200
        .Key = KI_DEBE
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1905, vbNullString)    'Haber
        .Format = m_GeneralConfig.FormatDecImporte
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Width = 1200
        .Key = KI_HABER
      End With
      
      With .Add(Nothing, c_saldo)
        .Name = LNGGetText(3806, vbNullString)
        .Format = m_GeneralConfig.FormatDecImporte
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Width = 1200
        .Key = KICH_SALDO_BCO
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(2079, vbNullString)
        .Format = m_GeneralConfig.FormatDecImporte
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Width = 1200
        .Key = KICH_SALDO_CONT
      End With
            
      With .Add(Nothing, c_Origen)
        .Name = LNGGetText(1963, vbNullString)    'Moneda Origen
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
      
      With .Add(Nothing, cscCcosId)
        .Name = LNGGetText(1057, vbNullString)    'Centro de Costo
        .Width = 1800
        .Key = KI_CCOS_ID
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(2059, vbNullString)    'Nro. Cheque
        .Width = 1000
        .Key = KICH_CHEQUE
      End With
      
      With .Add(Nothing, cscCheqNumero)
        .Name = LNGGetText(2058, vbNullString)    'Cheque
        .Width = 1000
        .Enabled = False
        .Key = KICH_CHEQ_ID
      End With
      
      With .Add(Nothing, cscCobzId)
        .Name = LNGGetText(2060, vbNullString)    'Cobranza
        .Width = 520
        .Key = KICH_COBZ_ID
      End With
      
      With .Add(Nothing, cscOpgId)
        .Name = LNGGetText(2061, vbNullString)    'Orden Pago
        .Width = 520
        .Key = KICH_OPG_ID
      End With
      
      With .Add(Nothing, cscMfId)
        .Name = LNGGetText(2062, vbNullString)    'Mov. Fondo
        .Width = 520
        .Key = KICH_MF_ID
      End With
      
      With .Add(Nothing, cscCueId)
        .Name = LNGGetText(1267, vbNullString)    'Cuenta
        .Width = 520
        .Key = KICH_CUE_ID
      End With
      
      With .Add(Nothing, cscMonId)
        .Name = LNGGetText(2063, vbNullString)    'Mon.
        .Width = 520
        .Key = KICH_MON_ID
      End With
      
      With .Add(Nothing, cscCheqImporteOrigen)
        .Name = LNGGetText(1901, vbNullString)    'Origen
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Format = m_GeneralConfig.FormatDecImporte
        .Width = 920
        .Key = KICH_IMPORTEORIGEN
      End With
      
      With .Add(Nothing, cscCheqImporte)
        .Name = LNGGetText(1228, vbNullString)    'Importe
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Format = m_GeneralConfig.FormatDecImporte
        .Width = 920
        .Key = KICH_IMPORTE
      End With
      
      With .Add(Nothing, cscChqId)
        .Name = LNGGetText(2064, vbNullString)    'Chequera
        .Width = 1000
        .Key = KICH_CHEQUERA
      End With
      
      With .Add(Nothing, cscCheqFechaCobro)
        .Name = LNGGetText(2065, vbNullString)    'Depositar el
        .Width = 970
        .Key = KICH_FECHACOBRO
      End With
      
      With .Add(Nothing, cscCheqFechaVto)
        .Name = LNGGetText(1634, vbNullString)    'Vto.
        .Width = 970
        .Key = KICH_FECHAVTO
      End With
      
      With .Add(Nothing, cscCleId)
        .Name = LNGGetText(1083, vbNullString)    'Clering
        .Width = 800
        .Key = KICH_CLE_ID
      End With
      
      With .Add(Nothing, cscCheqDescrip)
        .Name = C_strDescrip
        .Width = 1600
        .Key = KICH_DESCRIP
      End With
    
      With .Add(Nothing)
        .Visible = False
        .Key = KI_CHANGED
      End With
    
      With .Add(Nothing)
        .Visible = False
        .Key = KI_DOCT_ID
      End With
      
      With .Add(Nothing)
        .Visible = False
        .Key = KI_COMP_ID
      End With
    
    End With
  End With
  
  pLoadItems = True
End Function

Private Sub pShowHideColsCheque()
  Dim bShow As Boolean
  Dim iProp As cIABMProperty
  
  bShow = Val(m_ObjAbm.Properties.Item(c_ver_cheques).Value)
  
  Set iProp = pGetItems()
  
  With iProp.Grid.Columns
    .Item(cscCcosId).Visible = bShow
    .Item(cscCheqNumero).Visible = bShow
    .Item(cscCobzId).Visible = bShow
    .Item(cscOpgId).Visible = bShow
    .Item(cscMfId).Visible = bShow
    .Item(cscCueId).Visible = bShow
    .Item(cscMonId).Visible = bShow
    .Item(cscCheqImporteOrigen).Visible = bShow
    .Item(cscCheqImporte).Visible = bShow
    .Item(cscChqId).Visible = bShow
    .Item(cscCheqFechaCobro).Visible = bShow
    .Item(cscCheqFechaVto).Visible = bShow
    .Item(cscCleId).Visible = bShow
    .Item(cscCheqDescrip).Visible = bShow
  End With

  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm

  AbmObj.DrawGrid iProp, False

  AbmObj.RefreshColumnProperties iProp, cscCcosId
  AbmObj.RefreshColumnProperties iProp, cscCheqNumero
  AbmObj.RefreshColumnProperties iProp, cscCobzId
  AbmObj.RefreshColumnProperties iProp, cscOpgId
  AbmObj.RefreshColumnProperties iProp, cscMfId
  AbmObj.RefreshColumnProperties iProp, cscCueId
  AbmObj.RefreshColumnProperties iProp, cscMonId
  AbmObj.RefreshColumnProperties iProp, cscCheqImporteOrigen
  AbmObj.RefreshColumnProperties iProp, cscCheqImporte
  AbmObj.RefreshColumnProperties iProp, cscChqId
  AbmObj.RefreshColumnProperties iProp, cscCheqFechaCobro
  AbmObj.RefreshColumnProperties iProp, cscCheqFechaVto
  AbmObj.RefreshColumnProperties iProp, cscCleId
  AbmObj.RefreshColumnProperties iProp, cscCheqDescrip
  
  AbmObj.DrawGrid iProp, True
  
End Sub

' funciones friend
' funciones privadas

Private Function pSave() As Boolean
  
  Dim Mouse As cMouseWait
  Set Mouse = New cMouseWait
  
  Dim Numero As Long
  Numero = pGetNumero()

  ' Numero no puede ser cero
  '
  If Numero = 0 Then
    Exit Function
  End If

  Dim register     As cRegister
  
  DoEvents: DoEvents: DoEvents: DoEvents
  
  Set register = New cRegister
  register.fieldId = cscBcocId
  register.Table = csTBancoConciliacion
  
  register.Id = m_Id
    
  Dim IProperty As cIABMProperty
  
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
      
        Case K_FECHA
          register.Fields.Add2 cscBcocFecha, .Value, csDate
        Case K_DESDE
          register.Fields.Add2 cscBcocFechaDesde, .Value, csDate
        Case K_HASTA
          register.Fields.Add2 cscBcocFechaHasta, .Value, csDate
        
        Case K_SALDO_INI_CONT
          register.Fields.Add2 cscBcocSaldoInicialCont, .Value, csCurrency
        Case K_SALDO_CONT
          register.Fields.Add2 cscBcocSaldoCont, .Value, csCurrency
          
        Case K_SALDO_INI_BCO
          register.Fields.Add2 cscBcocSaldoInicialBco, .Value, csCurrency
        Case K_CONCILIADO_BCO
          register.Fields.Add2 cscBcocConciliadoBco, .Value, csCurrency
        Case K_SALDO_BCO
          register.Fields.Add2 cscBcocSaldoBco, .Value, csCurrency
        
        Case K_SALDO_INI_REC
          register.Fields.Add2 cscBcocSaldoInicialRech, .Value, csCurrency
        Case K_RECHAZADO
          register.Fields.Add2 cscBcocRechazado, .Value, csCurrency
        Case K_SALDO_REC
          register.Fields.Add2 cscBcocSaldoRech, .Value, csCurrency
          
        Case K_SALDO_INI_PEND
          register.Fields.Add2 cscBcocSaldoInicialPendiente, .Value, csCurrency
        Case K_PENDIENTE
          register.Fields.Add2 cscBcocPendiente, .Value, csCurrency
        Case K_SALDO_PEND
          register.Fields.Add2 cscBcocSaldoPendiente, .Value, csCurrency
          
        Case K_FECHA_COBRO_CHEQUE
          register.Fields.Add2 cscBcocFechacheque, .Value, csBoolean
        Case K_VER_PENDIENTES
          register.Fields.Add2 cscBcocVerpendientes, .Value, csBoolean
          
        Case K_DESCRIP
          register.Fields.Add2 cscBcocDescrip, .Value, csText
          
        Case K_CUE_ID
          register.Fields.Add2 cscCueId, .HelpId, csId
      
      End Select
    End With
  Next
  
  register.Fields.Add2 cscBcocNumero, Numero, csLong
    
  register.Fields.HaveLastUpdate = True
  register.Fields.HaveWhoModify = True
  
  If Not register.BeginTrans(gDB) Then Exit Function
  
  If Not gDB.Save(register, , _
                  "cIABMClient_Save", _
                  C_Module, _
                  c_ErrorSave) Then Exit Function
  
  If Not pSaveItems(register.Id) Then Exit Function
  
'---------------------------------------------------

  Dim Row      As cIABMGridRow
  Dim sqlstmt  As String
  
  For Each Row In pGetItems().Grid.Rows

    If Val(pCell(Row, KI_CHANGED).Value) Then

      sqlstmt = "update asientoitem set asi_conciliado = " & pCell(Row, KI_CONCILIADO).Id & " where asi_id = " & Val(pCell(Row, KI_ASI_ID).Value)
      If Not gDB.Execute(sqlstmt) Then Exit Function
    End If

  Next
  
  register.CommitTrans

  m_Id = register.Id
  
  ' Como no hago un load despues de guardar
  ' tengo que actualizar esta variable por
  ' si sigue editando
  '
  m_Numero = Numero

  m_Changed = False

  pSave = True
End Function

Private Function pSaveItems(ByVal Id As Long) As Boolean
  Dim sqlstmt   As String
  Dim register  As cRegister
  Dim Row       As cIABMGridRow
  Dim Cell      As cIABMGridCellValue
  
  sqlstmt = "delete BancoConciliacionItem where bcoc_id = " & Id
  
  If Not gDB.Execute(sqlstmt) Then Exit Function
  
  For Each Row In pGetItems().Grid.Rows
  
    Set register = New cRegister
    register.fieldId = cscBcociId
    register.Table = csTBancoConciliacionItem
    register.Id = csNew
    
    For Each Cell In Row
      Select Case Cell.Key
        
        Case KI_FECHA
          register.Fields.Add2 cscBcociFecha, Cell.Value, csDate
        Case KI_DEBE
          register.Fields.Add2 cscBcociDebe, Val(Cell.Value), csCurrency
        Case KI_HABER
          register.Fields.Add2 cscBcociHaber, Val(Cell.Value), csCurrency
        
        Case KICH_SALDO_BCO
          register.Fields.Add2 cscBcociSaldoBco, Val(Cell.Value), csCurrency
        Case KICH_SALDO_CONT
          register.Fields.Add2 cscBcociSaldoCont, Val(Cell.Value), csCurrency
        
        Case KI_CONCILIADO
          register.Fields.Add2 cscBcociEstado, Cell.Id, csInteger
        Case KI_DESCRIP
          register.Fields.Add2 cscBcociDescrip, Cell.Value, csText

        Case KI_ASI_ID
          register.Fields.Add2 cscAsiId, Val(Cell.Value), csId
        Case KI_DOCT_ID
          register.Fields.Add2 cscDoctId, Val(Cell.Value), csId
        Case KI_COMP_ID
          register.Fields.Add2 cscCompId, Val(Cell.Value), csId
      
      End Select
    Next
    
    register.Fields.Add2 cscBcocId, Id, csId
                                                        
    If Not gDB.Save(register, , _
                    "pSaveItems", _
                    C_Module, _
                    c_ErrorSave) Then Exit Function
  Next
  
  pSaveItems = True

End Function

Private Function pGetNumero() As Long
  
  If m_Id <> csNO_ID Then
  
    pGetNumero = m_Numero
  
  Else
    
    Dim sqlstmt As String
    Dim rs      As ADODB.Recordset
    
    sqlstmt = "select max(bcoc_numero) from BancoConciliacion where cue_id = " & pGetCuenta()
    If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
    
    If Not rs.EOF Then
      pGetNumero = gDB.ValField(rs.Fields, 0) + 1
    Else
      pGetNumero = 1
    End If
  End If
  
End Function

Private Function pGetCuenta() As Long
  pGetCuenta = m_ObjAbm.Properties.Item(cscCueId).HelpId
End Function

Private Function pLoadItemsXCuenta() As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_ConciliacionBancoGet " & pGetCuenta() & "," & _
                    gDB.sqlDate(pGetDesde()) & "," & _
                    gDB.sqlDate(pGetHasta()) & "," & _
                    pGetFechaCobroCheque() & "," & _
                    pGetVerPendiente()

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadItems", C_Module) Then Exit Function
  
  Dim iProp As cIABMProperty
  
  Dim Pendiente     As Double
  Dim Conciliado    As Double
  Dim Rechazado     As Double
  Dim Total         As Double
  Dim SaldoP        As Double
  Dim SaldoC        As Double
  Dim SaldoR        As Double
  Dim SaldoItem     As Double
  Dim SaldoItemC    As Double
  Dim Debe          As Double
  Dim Haber         As Double
  Dim Estado        As csEBcoConciliacionTipo
  Dim Row           As cIABMGridRow
  Dim oRow          As cABMGridRow
  
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  
  If Not rs.EOF Then
    SaldoP = gDB.ValField(rs.Fields, "SaldoP")
    SaldoC = gDB.ValField(rs.Fields, "SaldoC")
    SaldoR = gDB.ValField(rs.Fields, "SaldoR")
  End If
  
  SaldoItem = SaldoP + SaldoC + SaldoR
  SaldoItemC = SaldoC
  
  Set iProp = pGetSaldoIniP()
  iProp.Value = SaldoP
  
  Set iProp = pGetSaldoIniC()
  iProp.Value = SaldoC
  
  Set iProp = pGetSaldoIniR()
  iProp.Value = SaldoR
  
  Set iProp = pGetSaldoIni()
  iProp.Value = SaldoP + SaldoC + SaldoR
   
  Set iProp = pGetItems()
  
  Set rs = rs.NextRecordset
  
  With iProp.Grid
  
    .Rows.Clear
    
    With .Rows
    
      While Not rs.EOF
      
        Set Row = .Add(Nothing, rs(cscAsiId).Value)
        Set oRow = Row
        
        With Row
        
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscAsiId)
            .Key = KI_ASI_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, "Fecha")
            .Key = KI_FECHA
          End With
          
          Estado = gDB.ValField(rs.Fields, cscAsiConciliado)
          With .Add(Nothing)
            .Id = Estado
            .Key = KI_CONCILIADO
          End With
          
          Debe = gDB.ValField(rs.Fields, cscAsiDebe)
          With .Add(Nothing)
            .Value = Debe
            .Key = KI_DEBE
          End With
          
          Haber = gDB.ValField(rs.Fields, cscAsiHaber)
          With .Add(Nothing)
            .Value = Haber
            .Key = KI_HABER
          End With
          
          With .Add(Nothing, c_saldo)
            If Estado = csEBCConciliado Then
              SaldoItemC = SaldoItemC + Debe - Haber
            End If
            .Value = SaldoItemC
            .Key = KICH_SALDO_BCO
          End With
          
          With .Add(Nothing)
            SaldoItem = SaldoItem + Debe - Haber
            .Value = SaldoItem
            .Key = KICH_SALDO_CONT
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscAsiOrigen)
            .Key = KI_ORIGEN
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscAsiDescrip)
            .Key = KI_DESCRIP
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscCcosNombre)
            .Key = KI_CCOS_ID
          End With
                    
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscCheqNumeroDoc)
            .Key = KICH_CHEQUE
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscCheqNumero)
            .Id = gDB.ValField(rs.Fields, cscCheqId)
            .Key = KICH_CHEQ_ID
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
            .Value = gDB.ValField(rs.Fields, cscChqCodigo)
            .Key = KICH_CHEQUERA
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
          
          With .Add(Nothing)
            .Value = 0
            .Key = KI_CHANGED
          End With
        
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscDoctIdCliente)
            .Key = KI_DOCT_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscIdCliente)
            .Key = KI_COMP_ID
          End With
        
        End With
        
        Select Case Estado
        
          Case csEBCConciliado
            Conciliado = Conciliado + Debe - Haber
            oRow.ForeColor = vbBlue
            
          Case csEBCRechazado
            Rechazado = Rechazado + Debe - Haber
            oRow.ForeColor = vbRed
            
          Case Else ' csEBCPendiente
            Pendiente = Pendiente + Debe - Haber
            oRow.ForeColor = vbWindowText
            
        End Select
        rs.MoveNext
      Wend
    
    End With
  End With
  
  Total = SaldoP + SaldoC + SaldoR + Conciliado + Rechazado + Pendiente
    
  Set iProp = pGetPendiente()
  iProp.Value = Pendiente
  
  Set iProp = pGetConciliado()
  iProp.Value = Conciliado
  
  Set iProp = pGetRechazado()
  iProp.Value = Rechazado
  
  Set iProp = pGetTotalP()
  iProp.Value = SaldoP + Pendiente
  
  Set iProp = pGetTotalC()
  iProp.Value = SaldoC + Conciliado
  
  Set iProp = pGetTotalR()
  iProp.Value = SaldoR + Rechazado
  
  Set iProp = pGetTotal()
  iProp.Value = Total
  
  pLoadItemsXCuenta = True
End Function

Private Function pLoadItemsFromItems() As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_BancoConciliacionGetItems " & m_Id

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadItemsFromItems", C_Module) Then Exit Function
  
  Dim iProp As cIABMProperty
  
  Dim Estado        As csEBcoConciliacionTipo
  Dim Row           As cIABMGridRow
  Dim oRow          As cABMGridRow
  Dim asi_id        As Long
  
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  
  Set iProp = pGetItems()
    
  With iProp.Grid
  
    .Rows.Clear
    
    With .Rows
    
      While Not rs.EOF
      
        asi_id = gDB.ValField(rs.Fields, cscAsiId)
        
        If asi_id Then
          Set Row = .Add(Nothing, asi_id)
        Else
          Set Row = .Add(Nothing)
        End If
        
        Set oRow = Row
        
        With Row
        
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscAsiId)
            .Key = KI_ASI_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, "Fecha")
            .Key = KI_FECHA
          End With
          
          Estado = gDB.ValField(rs.Fields, cscAsiConciliado)
          With .Add(Nothing)
            .Id = Estado
            .Key = KI_CONCILIADO
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscBcociDebe)
            .Key = KI_DEBE
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscBcociHaber)
            .Key = KI_HABER
          End With
          
          With .Add(Nothing, c_saldo)
            .Value = gDB.ValField(rs.Fields, cscBcociSaldoBco)
            .Key = KICH_SALDO_BCO
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscBcociSaldoCont)
            .Key = KICH_SALDO_CONT
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscAsiOrigen)
            .Key = KI_ORIGEN
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscBcociDescrip)
            .Key = KI_DESCRIP
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscCcosNombre)
            .Key = KI_CCOS_ID
          End With
                    
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscCheqNumeroDoc)
            .Key = KICH_CHEQUE
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscCheqNumero)
            .Id = gDB.ValField(rs.Fields, cscCheqId)
            .Key = KICH_CHEQ_ID
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
            .Value = gDB.ValField(rs.Fields, cscChqCodigo)
            .Key = KICH_CHEQUERA
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
          
          With .Add(Nothing)
            .Value = 0
            .Key = KI_CHANGED
          End With
        
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscDoctIdCliente)
            .Key = KI_DOCT_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscIdCliente)
            .Key = KI_COMP_ID
          End With
        
        End With
        
        Select Case Estado
        
          Case csEBCConciliado
            oRow.ForeColor = vbBlue
            
          Case csEBCRechazado
            oRow.ForeColor = vbRed
            
          Case Else ' csEBCPendiente
            oRow.ForeColor = vbWindowText
            
        End Select
        rs.MoveNext
      Wend
    
    End With
  End With
  
  pLoadItemsFromItems = True
End Function

Private Function pGetDesde() As String
  pGetDesde = m_ObjAbm.Properties.Item(c_FechaDesde).Value
End Function

Private Function pGetHasta() As String
  pGetHasta = m_ObjAbm.Properties.Item(c_FechaHasta).Value
End Function

Private Function pGetFechaCobroCheque() As Long
  If Val(m_ObjAbm.Properties.Item(c_fechacobrocheque).Value) Then
    pGetFechaCobroCheque = 1
  Else
    pGetFechaCobroCheque = 0
  End If
End Function

Private Function pGetVerPendiente() As Long
  If Val(m_ObjAbm.Properties.Item(c_ver_pendientes).Value) Then
    pGetVerPendiente = 1
  Else
    pGetVerPendiente = 0
  End If
End Function

Private Function pGetItems() As cIABMProperty
  Set pGetItems = m_ObjAbm.Properties(c_Items)
End Function

Private Function pGetSaldoIniP() As cIABMProperty
  Set pGetSaldoIniP = m_ObjAbm.Properties(c_saldoIniP)
End Function

Private Function pGetSaldoIniC() As cIABMProperty
  Set pGetSaldoIniC = m_ObjAbm.Properties(c_saldoIniC)
End Function

Private Function pGetSaldoIniR() As cIABMProperty
  Set pGetSaldoIniR = m_ObjAbm.Properties(c_saldoIniR)
End Function

Private Function pGetSaldoIni() As cIABMProperty
  Set pGetSaldoIni = m_ObjAbm.Properties(c_saldoInicial)
End Function

Private Function pGetPendiente() As cIABMProperty
  Set pGetPendiente = m_ObjAbm.Properties(c_pendiente)
End Function

Private Function pGetConciliado() As cIABMProperty
  Set pGetConciliado = m_ObjAbm.Properties(c_conciliado)
End Function

Private Function pGetRechazado() As cIABMProperty
  Set pGetRechazado = m_ObjAbm.Properties(c_rechazado)
End Function

Private Function pGetTotalP() As cIABMProperty
  Set pGetTotalP = m_ObjAbm.Properties(c_totalP)
End Function
Private Function pGetTotalC() As cIABMProperty
  Set pGetTotalC = m_ObjAbm.Properties(c_totalC)
End Function
Private Function pGetTotalR() As cIABMProperty
  Set pGetTotalR = m_ObjAbm.Properties(c_totalR)
End Function

Private Function pGetTotal() As cIABMProperty
  Set pGetTotal = m_ObjAbm.Properties(c_total)
End Function

Private Function pGetAsId(ByVal asi_id As Long) As Long
  Dim as_id As Long
  If Not gDB.GetData(csTAsientoItem, cscAsiId, asi_id, cscAsId, as_id) Then Exit Function
  pGetAsId = as_id
End Function

' construccion - destruccion
Private Sub Class_Terminate()
  On Error Resume Next
  Set m_ObjAbm = Nothing
  Set m_GeneralConfig = Nothing
End Sub

Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  c_ErrorSave = LNGGetText(2098, vbNullString) 'Error al grabar la Cobranza

  Set m_GeneralConfig = New cGeneralConfig
  m_GeneralConfig.Load
  
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
  cIEditGeneric_ShowList = SecurityCanAccess(csPreTsrListConciliacionBco)
End Function

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
  Set m_ObjAbm = rhs
End Property

Private Property Get cIEditGeneric_Editing() As Boolean
  cIEditGeneric_Editing = m_Editing
End Property

Private Function cIEditGeneric_Delete(Id As Long) As Boolean
  If Not SecurityCanAccess(csPreTsrDeleteConciliacionBco) Then Exit Function
  
  Dim sqlstmt As String
  
  sqlstmt = "sp_BancoConciliacionDelete " & Id
  
  cIEditGeneric_Delete = gDB.Execute(sqlstmt, "cIEditGeneric_Delete", C_Module)
End Function

Private Function cIEditGeneric_Search(Id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Id = csNO_ID Then
    m_IsNew = True
    If Not SecurityCanAccess(csPreTsrNewConciliacionBco) Then Exit Function
  Else
    m_IsNew = False
    If Not SecurityCanAccess(csPreTsrEditConciliacionBco) Then Exit Function
  End If

  m_ObjAbm.InModalWindow = InModalWindow
  
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

Private Function Load(ByVal Id As Long) As Boolean
  Dim sqlstmt As String
  Dim Hora    As Integer
  
  sqlstmt = "sp_BancoConciliacionGet " & Id
  
  Dim rs As ADODB.Recordset
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function
  
  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.Fields, cscBcocId)
    m_Numero = gDB.ValField(rs.Fields, cscBcocNumero)
    m_Fecha = gDB.ValField(rs.Fields, cscBcocFecha)
    m_Fechadesde = gDB.ValField(rs.Fields, cscBcocFechaDesde)
    m_Fechahasta = gDB.ValField(rs.Fields, cscBcocFechaHasta)
    m_SaldoIinicialCont = gDB.ValField(rs.Fields, cscBcocSaldoInicialCont)
    m_SaldoCont = gDB.ValField(rs.Fields, cscBcocSaldoCont)
    m_SaldoInicialBco = gDB.ValField(rs.Fields, cscBcocSaldoInicialBco)
    m_ConciliadoBco = gDB.ValField(rs.Fields, cscBcocConciliadoBco)
    m_SaldoBco = gDB.ValField(rs.Fields, cscBcocSaldoBco)
    m_SaldoInicialRech = gDB.ValField(rs.Fields, cscBcocSaldoInicialRech)
    m_rechazado = gDB.ValField(rs.Fields, cscBcocRechazado)
    m_SaldoRech = gDB.ValField(rs.Fields, cscBcocSaldoRech)
    m_SaldoInicialPendiente = gDB.ValField(rs.Fields, cscBcocSaldoInicialPendiente)
    m_Pendiente = gDB.ValField(rs.Fields, cscBcocPendiente)
    m_SaldoPendiente = gDB.ValField(rs.Fields, cscBcocSaldoPendiente)
    m_Fechacheque = gDB.ValField(rs.Fields, cscBcocFechacheque)
    m_Verpendientes = gDB.ValField(rs.Fields, cscBcocVerpendientes)
    m_Descrip = gDB.ValField(rs.Fields, cscBcocDescrip)
    m_cue_id = gDB.ValField(rs.Fields, cscCueId)
    m_cuenta = gDB.ValField(rs.Fields, cscCueNombre)
    
  Else
    
    m_Id = csNO_ID
    m_Numero = 0
    m_Fecha = Date
    m_Fechadesde = Date 'DateAdd("m", -1, Date)
    m_Fechahasta = DateAdd("yyyy", 1, Date) 'Date
    m_SaldoIinicialCont = 0
    m_SaldoCont = 0
    m_SaldoInicialBco = 0
    m_ConciliadoBco = 0
    m_SaldoBco = 0
    m_SaldoInicialRech = 0
    m_rechazado = 0
    m_SaldoRech = 0
    m_SaldoInicialPendiente = 0
    m_Pendiente = 0
    m_SaldoPendiente = 0
    m_Fechacheque = True
    m_Verpendientes = True
    m_Descrip = vbNullString
    m_cue_id = csNO_ID
    m_cuenta = vbNullString

  End If

  m_LastConciliacion = pIsLastConciliacion()

  Load = True

End Function

Private Function pIsLastConciliacion() As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  If m_Id = csNO_ID Then
  
    pIsLastConciliacion = True
    
  Else
  
    sqlstmt = "sp_BancoConciliacionGetLast " & m_cue_id
    
    If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
    
    If rs.EOF Then
    
      pIsLastConciliacion = True
      
    Else
    
      pIsLastConciliacion = m_Id = gDB.ValField(rs.Fields, cscBcocId)
    
    End If
  End If
End Function

Private Function pShowTotals()
  Dim iProp   As cIABMProperty
  Dim AbmObj  As cABMGeneric
  
  Set AbmObj = m_ObjAbm
  
  Set iProp = pGetSaldoIniP()
  AbmObj.ShowValue iProp
  
  Set iProp = pGetSaldoIniC()
  AbmObj.ShowValue iProp
  
  Set iProp = pGetSaldoIniR()
  AbmObj.ShowValue iProp
  
  Set iProp = pGetSaldoIni()
  AbmObj.ShowValue iProp

  pShowHideColsCheque
    
  Set iProp = pGetItems()
  AbmObj.ShowValue iProp, True
  
  Set iProp = pGetPendiente()
  AbmObj.ShowValue iProp
  
  Set iProp = pGetConciliado()
  AbmObj.ShowValue iProp
  
  Set iProp = pGetRechazado()
  AbmObj.ShowValue iProp
  
  Set iProp = pGetTotalP()
  AbmObj.ShowValue iProp
  
  Set iProp = pGetTotalC()
  AbmObj.ShowValue iProp
  
  Set iProp = pGetTotalR()
  AbmObj.ShowValue iProp
  
  Set iProp = pGetTotal()
  AbmObj.ShowValue iProp

End Function

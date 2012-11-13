VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cPublicDoc"
Attribute VB_GlobalNameSpace = True
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cPublicDoc
' 10-10-2004

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cPublicDoc"

Public Enum csE_DocTypePrestacion
  csEDocTPreNew
  csEDocTPreEdit
  csEDocTPreDelete
  csEDocTPreList
  csEDocTPreAnular
  csEDocTPreDesanular
  csEDocTPreAplicar
  csEDocTPrePrint
End Enum
' estructuras
' variables privadas
Private m_bControlStockLoaded           As Boolean
Private m_ctrlStock                     As csE_ControlStock
Private m_ContConfig                    As cContabilidadConfig

Private m_AutoPrint As Boolean

' eventos
' propiedades publicas
Public Property Get WizAutoPrint() As String
  WizAutoPrint = m_AutoPrint
End Property

Public Property Let WizAutoPrint(ByVal rhs As String)
  m_AutoPrint = rhs
End Property
' propiedades friend
' propiedades privadas
' funciones publicas

'////////////////////////////////////////////////////////////////////////////////////////////////
' Search
'
Public Function DocumentSearch(ByVal DoctId As Long, _
                               ByRef ObjDoc As cIEditGeneric, _
                               ByVal bReuseWindow As Boolean, _
                               Optional ByRef Filters As cIABMProperties, _
                               Optional ByRef Fields As Collection, _
                               Optional ByVal bClientDoSearch As Boolean, _
                               Optional ByRef ObjectClient As Object) As cSearchResult
  
  Dim rslt      As cSearchResult
  Dim DocSearch As cDocClientSearch
  
  Set DocSearch = New cDocClientSearch
  
  Set rslt = DocSearch.Search(Filters, Fields, DoctId, bReuseWindow, bClientDoSearch, ObjectClient)
  
  ' Solo usamos el mecanismo generico cuando el cliente
  ' no se hace cargo de la busqueda, el resultado no fue
  ' cancel, los doct_id del cliente y del comprobante
  ' encontrado coniciden y se permite reusar la ventana
  '
  If rslt.Success And _
     Not bClientDoSearch And _
     rslt.DoctId = DoctId And _
     bReuseWindow Then
     
    ObjDoc.Edit rslt.Id
  End If
  
  Set DocumentSearch = rslt
End Function

Public Function GetdocIdFromObjAbm(ByVal ObjAbm As cIABMGeneric) As Long
  On Error Resume Next
  GetdocIdFromObjAbm = ObjAbm.Properties.Item(cscDocId).HelpId
End Function

Public Function GetEmailFromCliente(ByVal cli_id As Long) As String
  Dim EmailAddress As String
  If Not gDB.GetData(csTCliente, cscCliId, cli_id, cscCliEmail, EmailAddress) Then Exit Function
  GetEmailFromCliente = EmailAddress
End Function

Public Function GetEmailFromProveedor(ByVal prov_id As Long) As String
  Dim EmailAddress As String
  If Not gDB.GetData(csTProveedor, cscProvId, prov_id, cscProvEmail, EmailAddress) Then Exit Function
  GetEmailFromProveedor = EmailAddress
End Function

Public Function DocGetTimeOut(ByRef NrosSerie As Collection) As Long
  Dim Obj     As Object
  Dim Count   As Long
  
  If Not NrosSerie Is Nothing Then
    For Each Obj In NrosSerie
      Count = Count + Obj.Count
    Next
    
    If Count < 100 Then
      DocGetTimeOut = 360
    ElseIf Count < 200 Then
      DocGetTimeOut = 720
    ElseIf Count < 300 Then
      DocGetTimeOut = 1080
    ElseIf Count < 400 Then
      DocGetTimeOut = 1400
    ElseIf Count < 500 Then
      DocGetTimeOut = 1900
    ElseIf Count < 600 Then
      DocGetTimeOut = 2400
    Else
      DocGetTimeOut = 0
    End If
  Else
    DocGetTimeOut = -1
  End If
End Function

'-----------------------------------------------------------------------
' IdEx se usa para que remitos de venta pueda informas
' que se trata de un remito basado en bom, y para
' que facturas de venta puedan indicar que se trata
' horas en lugar de pedidos o remitos
'
Public Sub SetDocumentoForDoctId(ByRef iPropDoc As cIABMProperty, _
                                 ByRef iObjWiz As cIWizardGeneric, _
                                 ByVal doct_id As Long, _
                                 ByVal Doct_Id_Aplic As Long, _
                                 ByRef vIds() As Long, _
                                 ByVal IdEx As Long)
  
  If iPropDoc.HelpId <> csNO_ID Then Exit Sub
  
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  Dim Id      As Long
  
  If UBound(vIds) > 0 Then Id = vIds(1)
  
  sqlstmt = "sp_DocGetDocIdForDoctId " _
                 & EmpId & "," _
                 & User.Id & "," _
                 & doct_id & "," _
                 & Doct_Id_Aplic & "," _
                 & Id & "," _
                 & IdEx
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  If rs.EOF Then Exit Sub
  
  With iPropDoc
    .HelpId = gDB.ValField(rs.Fields, cscDocId)
    .Value = gDB.ValField(rs.Fields, cscDocNombre)
  End With
  
  Dim Wizard As cWizardGeneric
  Set Wizard = iObjWiz
  Wizard.ObjAbm.ShowValue iPropDoc
End Sub

Public Sub MsgApplyDisabled(ByVal emp_nombre As String)
  MsgWarning LNGGetText(2910, vbNullString, emp_nombre)
            'Este documento pertence a la empresa  & emp_nombre & _
             Para poder modificar su aplicación debe ingresar a & emp_nombre &
End Sub

Public Sub WizAddNewDocProperties(ByRef Wiz As cIWizardGeneric, _
                                  ByVal Key As Long)
  WizAddNewDocPropertiesEx Wiz, Key, vbNullString, vbNullString
End Sub

Public Sub WizAddNewDocPropertiesEx2(ByRef Wiz As cIWizardGeneric, _
                                     ByVal Key As Long, _
                                     ByVal strActionButtonCaption As String, _
                                     ByVal strActionButtonAutoCaption As String, _
                                     ByVal strActionButtonCancelCaption As String)
                                    
  Dim iStep As cIWizardStep
  Set iStep = Wiz.Steps.Item(GetKey(Key))
  
  With iStep.Properties
    With .Add(Nothing, c_Wiz_Key_PrintDoc)
      .name = c_WizStr_PrintDoc
      .PropertyType = cspButton
      .LeftLabel = -1
      .Left = 4500
      .Top = 2000
      .Width = 4000
      .Visible = False
      .FontBold = True
      .Key = KW_PRINT_DOC
    End With
    
    With .Add(Nothing, c_Wiz_Key_NewDoc)
      .name = c_WizStr_NewDoc
      .PropertyType = cspButton
      .LeftLabel = -1
      .Top = 2500
      .Visible = False
      .FontBold = True
      .Key = KW_NEW_DOC
    End With
    
    With .Add(Nothing, c_Wiz_Key_CloseWizard)
      .name = c_WizStr_CloseWizard
      .PropertyType = cspButton
      .LeftLabel = -1
      .Top = 3000
      .Visible = False
      .FontBold = True
      .Key = KW_CLOSE_WIZARD
    End With
  
    With .Add(Nothing, c_Wiz_Key_ActionButton)
      .name = strActionButtonCaption
      .PropertyType = cspButton
      .LeftLabel = -1
      .Top = 3500
      .Visible = False
      .FontBold = True
      .Key = KW_ACTION_BUTTON_DOC
    End With
  
    With .Add(Nothing, c_Wiz_Key_ActionButtonAuto)
      .name = strActionButtonAutoCaption
      .PropertyType = cspButton
      .LeftLabel = -1
      .Top = 4000
      .Visible = False
      .FontBold = True
      .Key = KW_ACTION_BUTTON_DOC_AUTO
    End With
  
    If LenB(strActionButtonCancelCaption) Then
  
      With .Add(Nothing, c_Wiz_Key_ActionCancelAuto)
        .name = strActionButtonCancelCaption
        .PropertyType = cspButton
        .LeftLabel = -1
        .Top = 4500
        .Visible = False
        .FontBold = True
        .Key = KW_ACTION_BUTTON_DOC_CANCEL_AUTO
      End With
      
    End If
  End With
                                    
End Sub

Public Sub WizAddNewDocPropertiesEx(ByRef Wiz As cIWizardGeneric, _
                                    ByVal Key As Long, _
                                    ByVal strActionButtonCaption As String, _
                                    ByVal strActionButtonAutoCaption As String)
  
  WizAddNewDocPropertiesEx2 Wiz, _
                            Key, _
                            strActionButtonCaption, _
                            strActionButtonCaption, _
                            vbNullString
End Sub

Public Sub WizPrintDoc(ByVal Id As Long, _
                       ByVal DocId As Long)
  WizPrintDoc Id, DocId
End Sub

Public Sub WizPrintDocEx(ByVal Id As Long, _
                         ByVal DocId As Long, _
                         ByVal EmailAddress As String)

  Const c_RPT_KEY = "RPT-CONFIG"
  Const c_RPT_PathReportes = "RPT_PATH_REPORTES"
  Const c_RPT_CommandTimeOut = "RPT_COMMAND_TIMEOUT"
  Const c_RPT_ConnectionTimeOut = "RPT_CONNECTION_TIMEOUT"

  Dim PrintManager As Object 'CSPrintManager.cPrintManager
  
  Set PrintManager = CSKernelClient2.CreateObject("CSPrintManager2.cPrintManager")
  
  With PrintManager
    .Path = GetValidPath(IniGetEx(c_RPT_KEY, c_RPT_PathReportes, CSKernelClient2.AppPath))
    .CommandTimeout = Val(IniGetEx(c_RPT_KEY, c_RPT_CommandTimeOut, 0))
    .ConnectionTimeout = Val(IniGetEx(c_RPT_KEY, c_RPT_ConnectionTimeOut, 0))
    .EmailAddress = EmailAddress
    
    .AutoPrint = m_AutoPrint
    ' Como la variable es practicamente una global
    ' siempre la reseteamos
    '
    m_AutoPrint = False
    
    .ShowPrint Id, csNO_ID, DocId
  End With

End Sub

Public Sub WizNewDoc(ByRef Wiz As cIWizardGeneric, _
                     ByVal iStep As Integer)
  With Wiz
    .cmdCancel.Visible = True
    .cmdBack.Visible = True
    .cmdNext.Visible = True
    
    .DoNextStep iStep
  End With
End Sub

Public Sub WizShowNewStep(ByRef Wiz As cIWizardGeneric, _
                          ByVal Key As Long, _
                          ByVal NroDoc As String)
  WizShowNewStepEx Wiz, Key, NroDoc, False
End Sub

Public Sub WizShowNewStepEx(ByRef Wiz As cIWizardGeneric, _
                            ByVal Key As Long, _
                            ByVal NroDoc As String, _
                            ByVal bShowActionButton As Boolean)
  
  Dim iPropPrint As cIABMProperty
  Dim iStep      As cIWizardStep
  
  Set iStep = Wiz.Steps.Item(GetKey(Key))
  
  With iStep.Properties
    With .Item(c_Wiz_Key_MainTitle)
      .Value = c_WizStr_NewDocDescrip
    End With
    
    Set iPropPrint = .Item(c_Wiz_Key_PrintDoc)
    With iPropPrint
      .name = Replace(c_WizStr_PrintDoc, "%1", NroDoc)
      .Visible = True
    End With
    
    With .Item(c_Wiz_Key_NewDoc)
      .Visible = True
    End With
    
    With .Item(c_Wiz_Key_CloseWizard)
      .Visible = True
    End With
    
    If bShowActionButton Then
    
      With .Item(c_Wiz_Key_ActionButton)
        .Visible = True
      End With
    
      With .Item(c_Wiz_Key_ActionButtonAuto)
        .Visible = True
      End With
    
      If Not .Item(c_Wiz_Key_ActionCancelAuto) Is Nothing Then
      
        With .Item(c_Wiz_Key_ActionCancelAuto)
          .Visible = True
        End With
      End If
    End If
    
  End With

  With Wiz
    .cmdCancel.Visible = False
    .cmdBack.Visible = False
    .cmdNext.Visible = False
  End With
  
  Dim oWiz    As cWizardGeneric
  Dim AbmObj  As cABMGeneric
  
  Set oWiz = Wiz
  Set AbmObj = oWiz.ObjAbm
  AbmObj.ShowValue iPropPrint
  AbmObj.ResetChanged
  
  ' Con esto se termina el automatic
  '
  oWiz.PushVirtualNext = False
End Sub

Public Function WizGetDesc(ByRef ObjWiz As cIWizardGeneric, _
                           ByVal StepId As Integer, _
                           ByVal c_Wiz_Key_Desc As String) As Double
  WizGetDesc = Val(GetWizProperty( _
                          ObjWiz, _
                          StepId, _
                          c_Wiz_Key_Desc).Value)
End Function

'////////////////////////////////////////////////////////////////////////////////////////////////
' Documentos Auxiliares
'
Public Sub ShowDocAux(ByVal doc_aux_id As Long, _
                      ByVal ObjEditName As String, _
                      ByVal ObjAbmName As String)
  On Error GoTo ControlError
  
  Dim o As cIEditGeneric

  Set o = CSKernelClient2.CreateObject(ObjEditName)
  Set o.ObjTree = Nothing
  
  Dim Editor As cIABMGeneric
  Set Editor = CSKernelClient2.CreateObject(ObjAbmName)
  Set o.ObjAbm = Editor

  pSetGenericDoc o, ObjAbmName

  o.Edit doc_aux_id

  GoTo ExitProc
ControlError:
  MngError Err, "ShowDocAux", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub pSetGenericDoc(ByRef o As Object, _
                           ByVal ObjAbmName As String)
  Dim oDoc As cIEditGenericDoc
  If TypeOf o Is cIEditGenericDoc Then
    Set oDoc = o
    Set oDoc.Footer = CSKernelClient2.CreateObject(ObjAbmName)
    Set oDoc.Items = CSKernelClient2.CreateObject(ObjAbmName)
  End If
End Sub

'////////////////////////////////////////////////////////////////////////////////////////////////
' Save and State
'
Public Sub DocEditableGet(ByVal DocId As Long, _
                          ByRef DocEditable As Boolean, _
                          ByRef DocEditMsg As String, _
                          ByVal PreIdNew As Long)
  Dim rs As ADODB.Recordset
  Dim sqlstmt As String
  
  sqlstmt = "sp_DocEditableGet " & EmpId & "," _
                                 & DocId & "," _
                                 & gDB.UserId & "," _
                                 & PreIdNew
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  If rs.EOF Then Exit Sub
  
  DocEditable = gDB.ValField(rs.Fields, "Editable")
  DocEditMsg = gDB.ValField(rs.Fields, "EditMsg")
End Sub

Public Function DocSecurityCanAccessEx(ByVal pre_id As Long, _
                                       ByVal doc_id As Long, _
                                       ByVal DocPreType As csE_DocTypePrestacion, _
                                       ByVal bForCopy As Boolean) As Boolean
  DocSecurityCanAccessEx = pDocSecurityCanAccess(pre_id, doc_id, DocPreType, bForCopy)
End Function

Public Function DocSecurityCanAccess(ByVal pre_id As Long, _
                                     ByVal doc_id As Long, _
                                     ByVal DocPreType As csE_DocTypePrestacion) As Boolean

  DocSecurityCanAccess = pDocSecurityCanAccess(pre_id, doc_id, DocPreType, False)
End Function

Private Function pDocSecurityCanAccess(ByVal pre_id As Long, _
                                       ByVal doc_id As Long, _
                                       ByVal DocPreType As csE_DocTypePrestacion, _
                                       ByVal bForCopy As Boolean) As Boolean
  Dim field As String
  
  If Not SecurityCanAccess(pre_id) Then Exit Function
  
  If doc_id <> csNO_ID Then
  
    Select Case DocPreType
  
      Case csEDocTPreNew
        field = cscPreIdNew
  
      Case csEDocTPreEdit
        field = cscPreIdEdit
  
      Case csEDocTPreDelete
        field = cscPreIdDelete
  
      Case csEDocTPreList
        field = cscPreIdList
  
      Case csEDocTPreAnular
        field = cscPreIdAnular
  
      Case csEDocTPreDesanular
        field = cscPreIdDesAnular
  
      Case csEDocTPreAplicar
        field = cscPreIdAplicar
  
      Case csEDocTPrePrint
        field = cscPreIdPrint
  
    End Select
  
    If Not gDB.GetData(csTDocumento, cscDocId, doc_id, field, pre_id) Then Exit Function
    
    If Not SecurityCanAccess(pre_id) Then Exit Function
    
    If bForCopy Then
    
      If Not pValidateDocEmpresa(doc_id) Then Exit Function
    End If
    
  End If
  
  pDocSecurityCanAccess = True
End Function

Public Function DocAnular(ByVal Id As Long, _
                          ByRef est_id As Long, _
                          ByRef estado As String, _
                          ByVal PreAnular As Long, _
                          ByVal PreDesAnular As Long, _
                          ByRef ObjAbm As cIABMGeneric, _
                          ByRef DocEditable As Boolean, _
                          ByRef DocEditMsg As String, _
                          ByVal spAnular As String, _
                          ByVal spEditableGet As String) As Boolean
  Dim bAnular   As Boolean
  Dim sqlstmt   As String
  Dim rs        As Recordset

  '////////////////////////////////////////
  ' Me aseguro que el estado de la factura permite
  ' anular o des-anular
  '
  ' El ultimo parametro le indica al sp que valide
  ' todos los atributos del documento excepto el
  ' estado anulado
  '
  sqlstmt = spEditableGet & " " & EmpId & "," & Id & "," & gDB.UserId & ",0,0,1,1"
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function
  
  ' No modifico las variables de retorno DocEditable
  ' ni DocEditMsg ya que si esta anulado y fuera del
  ' rango de control de acceso, al pedirle al sp
  ' que no valide el estado anulado, el estado
  ' devuelto por el sp sera documento fuera
  ' del rango de control de acceso en lugar de
  ' documento anulado y esto confunde al usuario
  '
  If gDB.ValField(rs.Fields, cscDocEditable) Then
  
    If Id = csNO_ID Then
      MsgWarning LNGGetText(2911, vbNullString)
                  'Antes de poder Anular el Documento debe guardarlo.
      Exit Function
    End If
    
    If est_id = csEEst_Anulado Then
      If Not Ask(LNGGetText(2912, vbNullString), vbYes, LNGGetText(2617, vbNullString)) Then
                  'El documento ya ha sido anulado.;;¿Desea des-anularlo? ,Anular
        Exit Function
      End If
      If Not DocSecurityCanAccess(PreDesAnular, GetdocIdFromObjAbm(ObjAbm), csEDocTPreDesanular) Then Exit Function
      bAnular = False
    Else
      If Not DocSecurityCanAccess(PreAnular, GetdocIdFromObjAbm(ObjAbm), csEDocTPreAnular) Then Exit Function
      bAnular = True
    End If
    
    If bAnular Then
      sqlstmt = spAnular & " " & gDB.UserId & "," & Id & ",1,1"
    Else
      sqlstmt = spAnular & " " & gDB.UserId & "," & Id & ",0,1"
    End If
    
    If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
    
    est_id = gDB.ValField(rs.Fields, cscEstId)
    estado = gDB.ValField(rs.Fields, cscEstNombre)
    
    Dim iProp As cIABMProperty
    Set iProp = ObjAbm.Properties(csDocEstateID)
    
    With iProp
      .HelpId = est_id
      .Value = estado
    End With
    
    ObjAbm.ShowValue iProp
    
    '////////////////////////////////////////
    ' Estado de edicion de la interfaz
    '
    sqlstmt = spEditableGet & " " & EmpId & "," & Id & "," & gDB.UserId & ",0,0,1"
    If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function
    DocEditable = gDB.ValField(rs.Fields, cscDocEditable)
    DocEditMsg = gDB.ValField(rs.Fields, cscDoceditMsg)
    
    DocAnular = True
  
  Else
    MsgWarning gDB.ValField(rs.Fields, cscDoceditMsg)
  End If
End Function

Public Function DocCanEdit(ByVal bDocEdit As Boolean, _
                           ByVal DocEditMsg As String) As Boolean
  If Not bDocEdit Then
    MsgWarning LNGGetText(2913, vbNullString, DocEditMsg)
              'Este documento no puede ser modificado debido a:;; & DocEditMsg
    Exit Function
  End If
  DocCanEdit = True
End Function

Public Function DocCanSave(ByVal ObjAbm As cIABMGeneric, _
                           ByVal nombreFecha As String) As Boolean
  DocCanSave = DocCanSaveEx(ObjAbm, nombreFecha, cscDocId)
End Function

Public Function DocCanSaveEx(ByVal ObjAbm As cIABMGeneric, _
                             ByVal nombreFecha As String, _
                             ByVal nombreDoc As String) As Boolean
  With ObjAbm.Properties
    Dim rango As String
    If Not pIsValidDate(.Item(nombreDoc).HelpId, .Item(nombreFecha).Value, rango) Then
      MsgWarning LNGGetText(2914, vbNullString, rango)
                'La fecha del Documento está fuera del rango permitido & _
                por las Fechas de Control de Acceso;; Rango permtido: & rango
      Exit Function
    End If
  End With
  DocCanSaveEx = True
End Function

Public Function DocChange(ByRef ObjAbm As cIABMGeneric, _
                          ByRef LastDoc As Long, _
                          ByRef LastDocName As String) As Boolean
  
  Dim iProp As cIABMProperty
  Set iProp = ObjAbm.Properties.Item(cscDocId)
    
  DocChange = LastDoc <> iProp.HelpId
  
  ' Por seguridad siempre tengo el nombre y el Id
  ' del documento activo
  '
  LastDocName = iProp.Value
  LastDoc = iProp.HelpId
End Function

Public Function GetDocIdFromId(ByVal Id As Long, _
                               ByVal Table As String, _
                               ByVal fieldId As String, _
                               ByRef DocId As Long) As Boolean
                               
  GetDocIdFromId = gDB.GetData(Table, _
                               fieldId, _
                               Id, _
                               cscDocId, _
                               DocId)
End Function

Public Sub GetDocNumber(ByVal doc_id As Long, _
                        ByRef ObjAbm As cIABMGeneric, _
                        ByRef bTaPropuesto As Boolean, _
                        ByVal PropertyKey As String)
  Dim Tl          As Object
  Dim tal_id      As Long
  Dim iProp       As cIABMProperty
  Dim Mask        As String
  Dim Doc         As Object
  
  Set Doc = CreateObject("CSDocumento2.cDocumento")
  
  tal_id = Doc.GetData(doc_id, cscTaId, csId)
  
  Set Tl = CreateObject("CSDocumento2.cTalonario")
  
  Set iProp = ObjAbm.Properties.Item(PropertyKey)
  iProp.Value = Tl.GetNextNumber(tal_id, Mask, bTaPropuesto)
  iProp.TextMask = Mask
  iProp.Enabled = bTaPropuesto
  ObjAbm.ShowValue iProp
End Sub

Public Sub GetDocNumberForProveedor(ByVal prov_id As Long, _
                                    ByVal doc_id As Long, _
                                    ByRef ObjAbm As cIABMGeneric, _
                                    ByRef bTaPropuesto As Boolean)
  Dim Tl          As Object
  Dim tal_id      As Long
  Dim iProp       As cIABMProperty
  Dim sqlstmt     As String
  Dim rs          As ADODB.Recordset
  Dim Mask        As String
  
  sqlstmt = "sp_ProveedorGetTalonario " & prov_id & "," & doc_id
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  If rs.EOF Then Exit Sub
    
  tal_id = gDB.ValField(rs.Fields, 0)
  
  Set Tl = CSKernelClient2.CreateObject("CSDocumento2.cTalonario")
  
  Set iProp = ObjAbm.Properties.Item(cscFcNrodoc)
  iProp.Value = Tl.GetNextNumber(tal_id, Mask, bTaPropuesto)
  iProp.TextMask = Mask
  iProp.Enabled = bTaPropuesto
  
  ObjAbm.ShowValue iProp
End Sub

Public Sub GetDocNumberForCliente(ByVal cli_id As Long, _
                                  ByVal doc_id As Long, _
                                  ByRef ObjAbm As cIABMGeneric, _
                                  ByRef bTaPropuesto As Boolean)
                                 
  Dim Tl          As Object
  Dim tal_id      As Long
  Dim iProp       As cIABMProperty
  Dim sqlstmt     As String
  Dim rs          As ADODB.Recordset
  Dim Mask        As String
  Dim Cai         As String
  
  sqlstmt = "sp_clienteGetTalonario " & cli_id & "," & doc_id
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  If rs.EOF Then Exit Sub
  
  tal_id = gDB.ValField(rs.Fields, 0)
  
  Set Tl = CSKernelClient2.CreateObject("CSDocumento2.cTalonario")
  
  Set iProp = ObjAbm.Properties.Item(cscFvNrodoc)
  iProp.Value = Tl.GetNextNumber(tal_id, Mask, bTaPropuesto, Cai)
  iProp.TextMask = Mask
  iProp.Enabled = bTaPropuesto
  ObjAbm.ShowValue iProp
  
  Set iProp = ObjAbm.Properties.Item(cscFvCai)
  iProp.Value = Cai
  ObjAbm.ShowValue iProp
End Sub

Public Function SetMask(ByVal Text As String, ByVal Mask As String) As String
  Dim c       As String
  Dim i       As Long
  Dim rtn     As String
  Dim s       As String
  Dim s2      As String
  
  If Len(Mask) - Len(Text) > 0 Then
    Text = String(Len(Mask) - Len(Text), " ") & Text
  End If
  
  If LenB(Mask) = 0 Then rtn = Text
  
  For i = Len(Mask) To 1 Step -1
  
    s = Mid$(Mask, i, 1)
    s2 = Mid$(Text, i, 1)
    
    Select Case s
      Case "0"
        If Not IsNumeric(s2) Then
          s2 = "0"
        End If
      Case "-"
        If IsNumeric(s2) Then
          Text = Mid$(Text, 2)
        End If
        s2 = "-"
      Case "#"
        ' No hacer nada
      Case Else
        s2 = s
    End Select
    
    rtn = s2 & rtn
  Next
  
  SetMask = rtn
End Function

Public Function GetNombreRama(ByVal tbl_id As Long, ByVal Ram_ID As Long, ByRef bExists As Boolean) As String
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  sqlstmt = "select ram_nombre from rama,arbol " & _
            " where rama.arb_id = arbol.arb_id " & _
              " and ram_id = " & Ram_ID & _
              " and tbl_id = " & tbl_id
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  If rs.EOF Then Exit Function
  
  bExists = True
  
  GetNombreRama = gDB.ValField(rs.Fields, cscRamNombre)
End Function

Public Function IsRNI(ByVal CliId As Long) As Boolean
  Dim CatFiscal As csCatFiscal
  If Not gDB.GetData(csTCliente, cscCliId, CliId, cscCliCatfiscal, CatFiscal) Then Exit Function
  
  IsRNI = CatFiscal = csCatFNoInscripto
End Function

Public Function GetNroSerieCount(ByRef NrosSerie As Collection, _
                                 ByVal Grupo As String) As Long
  
  Dim pt  As cProductoSerieType
  Dim rtn As Long
  
  If Grupo = 0 Then Exit Function
  
  If ExistsObjectInColl(NrosSerie, GetKey(Grupo)) Then
  
    For Each pt In NrosSerie.Item(GetKey(Grupo))
      If Not pt.Deleted Then
        rtn = rtn + 1
      End If
    Next
  End If
  
  GetNroSerieCount = rtn
End Function

Public Function NroSerieValidateCount2(ByRef Row As cIABMGridRow, _
                                       ByVal KI_GRUPO As Long, _
                                       ByVal RowIndex As Long, _
                                       ByRef NrosSerie As Collection, _
                                       ByVal Cantidad As Double, _
                                       ByVal strRow As String, _
                                       ByVal KI_PR_ID As Long, _
                                       ByVal KI_CANTIDAD As Long, _
                                       ByVal KI_NROSERIE As Long, _
                                       ByVal PrId As Long, _
                                       ByVal DeplId As Long, _
                                       ByVal IsInput As Boolean) As Boolean
  
  NroSerieValidateCount2 = NroSerieValidateCount2Ex( _
                                    Row, _
                                    KI_GRUPO, _
                                    RowIndex, _
                                    NrosSerie, _
                                    Cantidad, _
                                    strRow, _
                                    KI_PR_ID, _
                                    KI_CANTIDAD, _
                                    KI_NROSERIE, _
                                    PrId, _
                                    DeplId, _
                                    IsInput, _
                                    False _
                                  )
End Function

Public Function NroSerieValidateCount2Ex(ByRef Row As cIABMGridRow, _
                                         ByVal KI_GRUPO As Long, _
                                         ByVal RowIndex As Long, _
                                         ByRef NrosSerie As Collection, _
                                         ByVal Cantidad As Double, _
                                         ByVal strRow As String, _
                                         ByVal KI_PR_ID As Long, _
                                         ByVal KI_CANTIDAD As Long, _
                                         ByVal KI_NROSERIE As Long, _
                                         ByVal PrId As Long, _
                                         ByVal DeplId As Long, _
                                         ByVal IsInput As Boolean, _
                                         ByVal bSilent As Boolean) As Boolean
                                         
  NroSerieValidateCount2Ex = NroSerieValidateCount3Ex(Row, _
                                                      KI_GRUPO, _
                                                      RowIndex, _
                                                      NrosSerie, _
                                                      Cantidad, _
                                                      strRow, _
                                                      KI_PR_ID, _
                                                      KI_CANTIDAD, _
                                                      KI_NROSERIE, _
                                                      PrId, _
                                                      DeplId, _
                                                      IsInput, _
                                                      bSilent, _
                                                      False)

End Function

Public Function NroSerieValidateCount3Ex(ByRef Row As cIABMGridRow, _
                                         ByVal KI_GRUPO As Long, _
                                         ByVal RowIndex As Long, _
                                         ByRef NrosSerie As Collection, _
                                         ByVal Cantidad As Double, _
                                         ByVal strRow As String, _
                                         ByVal KI_PR_ID As Long, _
                                         ByVal KI_CANTIDAD As Long, _
                                         ByVal KI_NROSERIE As Long, _
                                         ByVal PrId As Long, _
                                         ByVal DeplId As Long, _
                                         ByVal IsInput As Boolean, _
                                         ByVal bSilent As Boolean, _
                                         ByVal bSuperSilent As Boolean) As Boolean
  Dim Grupo         As Long
  Dim NroSerieCount As Long
  
  Grupo = pCell(Row, KI_GRUPO).Id
  NroSerieCount = GetNroSerieCount(NrosSerie, Grupo)
  
  If Cantidad > NroSerieCount Then
    
    ' Silent=true  and supersilent=false    no pregunta y no genera numeros auxi
    '
    ' Silent=false and supersilent=false    pregunta si debe generar numeros auxi
    '
    ' SuperSilent=true                      no pregunta y genera numeros auxi
    '
    If (Not bSilent) Or bSuperSilent Then
    
      If Not bSuperSilent Then
      
        If Not Ask(LNGGetText(2915, vbNullString, Cantidad, NroSerieCount, strRow), vbYes) Then
                '"Ud ha indicado " & Cantidad & " items pero solo " & _
                 NroSerieCount & " Números de Serie" & strRow & _
                 ";;¿Desea que Cairo genere números auxiliares por Ud?
          Exit Function
          
        End If
      End If
    End If
    
    If Not pCreateNroSerieAux(pCell(Row, KI_GRUPO).Id, _
                       Cantidad, _
                       Row, _
                       NrosSerie, _
                       KI_GRUPO, _
                       KI_NROSERIE, _
                       RowIndex, _
                       PrId, _
                       DeplId, _
                       IsInput, _
                       False, _
                       False, _
                       Nothing, _
                       csNO_ID, _
                       csNO_ID, _
                       0, _
                       csNO_ID) Then Exit Function
      
  ElseIf Cantidad < NroSerieCount Then
  
    MsgInfo LNGGetText(2916, vbNullString, RowIndex)
            'La cantidad del rénglon  & RowIndex &  es menor a la cantidad de & _
            números de serie asociados. Indique el/los números de serie a eleminar.
    
    If Not DeleteNroSerie(pCell(Row, KI_GRUPO).Id, _
                          Val(pCell(Row, KI_CANTIDAD).Value), _
                          Row, _
                          NrosSerie, _
                          KI_GRUPO, _
                          KI_NROSERIE, _
                          RowIndex, _
                          PrId, _
                          DeplId, _
                          IsInput, NroSerieCount - Cantidad) Then
                              
      MsgWarning LNGGetText(2917, vbNullString, RowIndex)
                'El documento no será guardado hasta que no indique los números de & _
                serie a eliminar o modifique la cantidad indicada en el rénglon & RowIndex
      Exit Function
    End If
  End If

  NroSerieValidateCount3Ex = True
End Function

Public Function NroSerieValidateCount(ByRef Row As cIABMGridRow, _
                                      ByVal KI_GRUPO As Long, _
                                      ByVal RowIndex As Long, _
                                      ByRef NrosSerie As Collection, _
                                      ByVal Cantidad As Double, _
                                      ByVal strRow As String, _
                                      ByVal KI_PR_ID As Long, _
                                      ByVal KI_CANTIDAD As Long, _
                                      ByVal KI_NROSERIE As Long, _
                                      ByVal PrId As Long, _
                                      ByVal DeplId As Long, _
                                      ByVal IsInput As Boolean) As Boolean
  Dim Grupo         As Long
  Dim NroSerieCount As Long
  
  Grupo = pCell(Row, KI_GRUPO).Id
  NroSerieCount = GetNroSerieCount(NrosSerie, Grupo)
  
  If Cantidad > NroSerieCount Then
      MsgInfo LNGGetText(2918, vbNullString, Cantidad, NroSerieCount, strRow)
              'Ud ha indicado  & Cantidad &  items pero solo  & _
               NroSerieCount &  números de serie" & strRow
      Exit Function
    
  ElseIf Cantidad < NroSerieCount Then
  
    MsgInfo LNGGetText(2916, vbNullString, RowIndex)
            'La cantidad del rénglon " & RowIndex & " es menor a la cantidad de & _
            números de serie asociados. Indique el/los números de serie a eleminar.
    
    If Not DeleteNroSerie(pCell(Row, KI_GRUPO).Id, _
                          Val(pCell(Row, KI_CANTIDAD).Value), _
                          Row, _
                          NrosSerie, _
                          KI_GRUPO, _
                          KI_NROSERIE, _
                          RowIndex, _
                          PrId, _
                          DeplId, _
                          IsInput, NroSerieCount - Cantidad) Then
                              
      MsgWarning LNGGetText(2917, vbNullString, RowIndex)
                'El documento no será guardado hasta que no indique los números de & _
                serie a eliminar o modifique la cantidad indicada en el rénglon & RowIndex
      Exit Function
    End If
  End If

  NroSerieValidateCount = True
End Function

Public Function NroSerieCantidadChangedPPK(ByRef Row As cIABMGridRow, _
                                           ByVal lRow As Long, _
                                           ByVal KI_CANTIDAD As Long, _
                                           ByVal NewValue As Double, _
                                           ByVal KI_GRUPO As Long, _
                                           ByRef NrosSerie As Collection, _
                                           ByVal KI_PR_ID As Long, _
                                           ByVal KI_NROSERIE As Long, _
                                           ByVal PrId As Long, _
                                           ByVal DeplId As Long, _
                                           ByVal IsNew As Boolean) As Boolean

  NroSerieCantidadChangedPPK = pNroSerieCantidadChanged(Row, _
                                                     lRow, _
                                                     KI_CANTIDAD, _
                                                     NewValue, _
                                                     KI_GRUPO, _
                                                     NrosSerie, _
                                                     KI_PR_ID, _
                                                     KI_NROSERIE, _
                                                     PrId, _
                                                     DeplId, _
                                                     False, _
                                                     csNO_ID, _
                                                     True, IsNew)
End Function

Public Function NroSerieCantidadChanged(ByRef Row As cIABMGridRow, _
                                        ByVal lRow As Long, _
                                        ByVal KI_CANTIDAD As Long, _
                                        ByVal NewValue As Double, _
                                        ByVal KI_GRUPO As Long, _
                                        ByRef NrosSerie As Collection, _
                                        ByVal KI_PR_ID As Long, _
                                        ByVal KI_NROSERIE As Long, _
                                        ByVal PrId As Long, _
                                        ByVal DeplId As Long, _
                                        ByVal IsInput As Boolean, _
                                        ByVal ProvId As Long) As Boolean

  NroSerieCantidadChanged = pNroSerieCantidadChanged(Row, _
                                                     lRow, _
                                                     KI_CANTIDAD, _
                                                     NewValue, _
                                                     KI_GRUPO, _
                                                     NrosSerie, _
                                                     KI_PR_ID, _
                                                     KI_NROSERIE, _
                                                     PrId, _
                                                     DeplId, _
                                                     IsInput, _
                                                     ProvId, _
                                                     False, False)
End Function

Private Function pNroSerieCantidadChanged(ByRef Row As cIABMGridRow, _
                                          ByVal lRow As Long, _
                                          ByVal KI_CANTIDAD As Long, _
                                          ByVal NewValue As Double, _
                                          ByVal KI_GRUPO As Long, _
                                          ByRef NrosSerie As Collection, _
                                          ByVal KI_PR_ID As Long, _
                                          ByVal KI_NROSERIE As Long, _
                                          ByVal PrId As Long, _
                                          ByVal DeplId As Long, _
                                          ByVal IsInput As Boolean, _
                                          ByVal ProvId As Long, _
                                          ByVal IsParteProd As Boolean, _
                                          ByVal IsNewParteProd As Boolean) As Boolean
  Dim OldValue As Double
  OldValue = Val(pCell(Row, KI_CANTIDAD).Value)
  
  If OldValue <> NewValue And OldValue > 0 Then
    
    Dim Grupo         As Long
    Dim NroSerieCount As Long
    
    Grupo = pCell(Row, KI_GRUPO).Id
    NroSerieCount = GetNroSerieCount(NrosSerie, Grupo)
    
    ' Si no hay cargado ningun numero de serie
    ' no muestro la ventana por que es que se
    ' equivoco al cargar la cantidad y antes de
    ' ingresar los numeros corrige la el valor de la
    ' columna (cantidad) o se trata del default que es 1
    ' y ahora esta ingresando la cantidad real
    '
    If NroSerieCount > 0 Then

      If NroSerieCount > NewValue Then
        
        If IsParteProd And Not IsNewParteProd Then
          MsgWarning LNGGetText(3038, vbNullString)
                '"Solo se puede modificar la cantidad" & _
                 " en MENOS, en un parte de producción, " & _
                 " cuando el parte es nuevo.;;" & _
                 "Para partes ya guardados hay que hacer un" & _
                 " ""Parte de Desarme""."
          Exit Function
        Else
          If Not DeleteNroSerie(pCell(Row, KI_GRUPO).Id, _
                                Val(pCell(Row, KI_CANTIDAD).Value), _
                                Row, _
                                NrosSerie, _
                                KI_GRUPO, _
                                KI_NROSERIE, _
                                lRow, _
                                PrId, _
                                DeplId, _
                                IsInput, NroSerieCount - NewValue) Then
            Exit Function
          End If
        End If
        
      ElseIf NroSerieCount < NewValue Then
        
        If Not EditNroSerie(pCell(Row, KI_GRUPO).Id, _
                            NewValue, _
                            Row, _
                            NrosSerie, _
                            KI_GRUPO, _
                            KI_NROSERIE, _
                            lRow, _
                            PrId, _
                            DeplId, _
                            IsInput, _
                            False, Nothing, _
                            ProvId, csNO_ID) Then
          Exit Function
        End If
        
      End If
    End If
  End If

  pNroSerieCantidadChanged = True
End Function

Public Function EditNroSerieINPUT(ByVal Grupo As Long, _
                                  ByVal Cantidad As Long, _
                                  ByRef Row As cIABMGridRow, _
                                  ByRef NrosSerie As Collection, _
                                  ByVal KI_GRUPO As Long, _
                                  ByVal KI_NROSERIE As Long, _
                                  ByVal lRow As Long, _
                                  ByVal PrId As Long, _
                                  ByVal DeplId As Long, _
                                  ByVal IsInput As Boolean, _
                                  ByVal bEditKit As Boolean, _
                                  ByRef CollKitInfo As Collection, _
                                  ByRef prov_id As Long, _
                                  ByRef cli_id As Long) As Boolean
  
  EditNroSerieINPUT = pEditNroSerie(Grupo, _
                                    Cantidad, _
                                    Row, _
                                    NrosSerie, _
                                    KI_GRUPO, _
                                    KI_NROSERIE, _
                                    lRow, _
                                    csNO_ID, _
                                    DeplId, _
                                    IsInput, _
                                    bEditKit, _
                                    False, _
                                    CollKitInfo, _
                                    prov_id, _
                                    cli_id, 0, PrId)
End Function

Public Function EditNroSerie(ByVal Grupo As Long, _
                             ByVal Cantidad As Long, _
                             ByRef Row As cIABMGridRow, _
                             ByRef NrosSerie As Collection, _
                             ByVal KI_GRUPO As Long, _
                             ByVal KI_NROSERIE As Long, _
                             ByVal lRow As Long, _
                             ByVal PrId As Long, _
                             ByVal DeplId As Long, _
                             ByVal IsInput As Boolean, _
                             ByVal bEditKit As Boolean, _
                             ByRef CollKitInfo As Collection, _
                             ByRef prov_id As Long, _
                             ByRef cli_id As Long) As Boolean
  
  EditNroSerie = pEditNroSerie(Grupo, _
                               Cantidad, _
                               Row, _
                               NrosSerie, _
                               KI_GRUPO, _
                               KI_NROSERIE, _
                               lRow, _
                               PrId, _
                               DeplId, _
                               IsInput, _
                               bEditKit, _
                               False, _
                               CollKitInfo, _
                               prov_id, _
                               cli_id, 0, 0)
End Function

Public Function DeleteNroSerie(ByVal Grupo As Long, _
                               ByVal Cantidad As Long, _
                               ByRef Row As cIABMGridRow, _
                               ByRef NrosSerie As Collection, _
                               ByVal KI_GRUPO As Long, _
                               ByVal KI_NROSERIE As Long, _
                               ByVal lRow As Long, _
                               ByVal PrId As Long, _
                               ByVal DeplId As Long, _
                               ByVal IsInput As Boolean, _
                               ByVal DeleteCount As Long) As Boolean
  
  DeleteNroSerie = pEditNroSerie(Grupo, _
                                 Cantidad, _
                                 Row, _
                                 NrosSerie, _
                                 KI_GRUPO, _
                                 KI_NROSERIE, _
                                 lRow, _
                                 PrId, _
                                 DeplId, _
                                 IsInput, _
                                 False, _
                                 False, _
                                 Nothing, _
                                 csNO_ID, _
                                 csNO_ID, DeleteCount, 0)
End Function

Public Function EditNroSeriePPK(ByVal Grupo As Long, _
                                ByVal Cantidad As Long, _
                                ByRef Row As cIABMGridRow, _
                                ByRef NrosSerie As Collection, _
                                ByVal KI_GRUPO As Long, _
                                ByVal KI_NROSERIE As Long, _
                                ByVal lRow As Long, _
                                ByVal PrId As Long, _
                                ByVal DeplId As Long, _
                                ByVal IsInput As Boolean, _
                                ByVal bEditKit As Boolean, _
                                ByRef CollKitInfo As Collection) As Boolean
                             
  EditNroSeriePPK = pEditNroSerie(Grupo, _
                                  Cantidad, _
                                  Row, _
                                  NrosSerie, _
                                  KI_GRUPO, _
                                  KI_NROSERIE, _
                                  lRow, _
                                  PrId, _
                                  DeplId, _
                                  IsInput, _
                                  bEditKit, _
                                  True, _
                                  CollKitInfo, 0, 0, 0, 0)
End Function

Public Function EditNroSeriePDK(ByVal Grupo As Long, _
                                ByVal Cantidad As Long, _
                                ByRef Row As cIABMGridRow, _
                                ByRef NrosSerie As Collection, _
                                ByVal KI_GRUPO As Long, _
                                ByVal KI_NROSERIE As Long, _
                                ByVal lRow As Long, _
                                ByVal PrId As Long, _
                                ByVal DeplId As Long, _
                                ByVal IsInput As Boolean, _
                                ByVal bEditKit As Boolean, _
                                ByRef CollKitInfo As Collection) As Boolean
                             
  EditNroSeriePDK = pEditNroSerie(Grupo, _
                                  Cantidad, _
                                  Row, _
                                  NrosSerie, _
                                  KI_GRUPO, _
                                  KI_NROSERIE, _
                                  lRow, _
                                  PrId, _
                                  DeplId, _
                                  IsInput, _
                                  bEditKit, _
                                  False, _
                                  CollKitInfo, 0, 0, 0, 0)
End Function

Public Function GetMonedaDefault() As Long
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  sqlstmt = "select mon_id from Moneda where mon_legal <> 0"
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  If rs.EOF Then
    MsgWarning LNGGetText(2150, vbNullString)
                'Debe definir cual es la moneda legal con la que opera Cairo
    Exit Function
  End If
  
  GetMonedaDefault = gDB.ValField(rs.Fields, cscMonId)
End Function

Public Function GetMonedaFromCuenta(ByRef MonId As Long, ByRef Moneda As String, ByVal Cue_id As Long) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "select * from moneda inner join cuenta on moneda.mon_id = cuenta.mon_id where cue_id = " & Cue_id
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  If rs.EOF Then Exit Function
  
  MonId = gDB.ValField(rs.Fields, cscMonId)
  Moneda = gDB.ValField(rs.Fields, cscMonNombre)
End Function

Public Function GetListaPrecioGetXCliente(ByVal doc_id As Long, ByVal cli_id As Long) As String
  Dim Filter As String
  
  Filter = "(exists(select lp_id from ListaPrecioCliente where cli_id =" & cli_id _
                  & " and lp_id = ListaPrecio.lp_id)" _
            & " or (lp_default <> 0 and lp_tipo = 1)" _
          & ") and mon_id = " & GetMonIdFromDoc(doc_id)

  GetListaPrecioGetXCliente = Filter
End Function

Public Function GetListaDescGetXCliente(ByVal doc_id As Long, ByVal cli_id As Long) As String
  Dim Filter As String
  
  Filter = "exists(select ld_id from ListaDescuentoCliente where cli_id =" & cli_id
  Filter = Filter & " and ld_id = ListaDescuento.ld_id)"
  Filter = Filter & " and mon_id = " & GetMonIdFromDoc(doc_id)

  GetListaDescGetXCliente = Filter
End Function

Public Function GetListaPrecioGetXProveedor(ByVal doc_id As Long, ByVal prov_id As Long) As String
  Dim Filter As String
  
  Filter = "(exists(select lp_id from ListaPrecioProveedor where prov_id =" & prov_id _
                    & " and lp_id = ListaPrecio.lp_id)" _
            & " or (lp_default <> 0 and lp_tipo in (2,3))" _
          & ") and mon_id = " & GetMonIdFromDoc(doc_id)

  GetListaPrecioGetXProveedor = Filter
End Function

Public Function GetListaDescGetXProveedor(ByVal doc_id As Long, ByVal prov_id As Long) As String
  Dim Filter As String
  
  Filter = "exists(select ld_id from ListaDescuentoProveedor where prov_id =" & prov_id
  Filter = Filter & " and ld_id = ListaDescuento.ld_id)"
  Filter = Filter & " and mon_id = " & GetMonIdFromDoc(doc_id)

  GetListaDescGetXProveedor = Filter
End Function

Public Function GetMonIdFromDoc(ByVal doc_id As Long) As Long
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "select mon_id from Documento where doc_id = " & doc_id
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  If rs.EOF Then Exit Function
  
  GetMonIdFromDoc = gDB.ValField(rs.Fields, cscMonId)
End Function

Public Function GetChequeNumber(ByVal ChqId As Long) As String
  Dim Chequera As cChequera
  Dim Cheque   As Long
  
  Set Chequera = New cChequera
  If Not Chequera.GetNextNumber(ChqId, Cheque) Then Exit Function
  
  GetChequeNumber = Cheque
End Function

Public Function GetTasaFromProducto(ByVal pr_id As Long, _
                                    ByRef ti_ri As Long, _
                                    ByRef ti_rni As Long, _
                                    ByVal IsCompra As Boolean) As Boolean
  GetTasaFromProducto = GetTasaFromProductoEx(pr_id, ti_ri, ti_rni, 0, 0, IsCompra)
End Function

Public Function GetTasaFromProductoEx(ByVal pr_id As Long, _
                                      ByRef ti_ri As Long, _
                                      ByRef ti_rni As Long, _
                                      ByRef ti_interno As Long, _
                                      ByRef porc_internos As Double, _
                                      ByVal IsCompra As Boolean) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_ProductoGetTasas " & pr_id
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  If Not rs.EOF Then
  
    If IsCompra Then
      ti_ri = gDB.ValField(rs.Fields, cscPrTiIdRiCompra)
      ti_rni = gDB.ValField(rs.Fields, cscPrTiIdRniCompra)
      ti_interno = gDB.ValField(rs.Fields, cscPrTiIdInternosC)
      porc_internos = gDB.ValField(rs.Fields, cscPrPorcInternoC)
    Else
      ti_ri = gDB.ValField(rs.Fields, cscPrTiIdRiVenta)
      ti_rni = gDB.ValField(rs.Fields, cscPrTiIdRniVenta)
      ti_interno = gDB.ValField(rs.Fields, cscPrTiIdInternosV)
      porc_internos = gDB.ValField(rs.Fields, cscPrPorcInternoV)
    End If
  End If
  
  GetTasaFromProductoEx = True
End Function

Public Function GetProveedorDataEx(ByVal prov_id As Long, _
                                   ByRef lp_id As Long, _
                                   ByRef ld_id As Long, _
                                   ByRef cpg_id As Long, _
                                   ByRef doc_id As Long)
  GetProveedorDataEx = pGetProveedorData(prov_id, lp_id, ld_id, cpg_id, doc_id)
End Function

Public Function GetProveedorData(ByVal prov_id As Long, _
                                 ByRef lp_id As Long, _
                                 ByRef ld_id As Long, _
                                 ByRef cpg_id As Long)
  GetProveedorData = pGetProveedorData(prov_id, lp_id, ld_id, cpg_id, csNO_ID)
End Function

Private Function pGetProveedorData(ByVal prov_id As Long, _
                                   ByRef lp_id As Long, _
                                   ByRef ld_id As Long, _
                                   ByRef cpg_id As Long, _
                                   ByRef doc_id As Long)
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_ProveedorGetData " & prov_id & "," & GetMonIdFromDoc(doc_id)
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  If Not rs.EOF Then
    lp_id = gDB.ValField(rs.Fields, cscLpId)
    ld_id = gDB.ValField(rs.Fields, cscLdId)
    cpg_id = gDB.ValField(rs.Fields, cscCpgId)
  End If
  
  pGetProveedorData = True
End Function

Public Function GetClienteData2(ByVal cli_id As Long, _
                                ByRef lp_id As Long, _
                                ByRef ld_id As Long, _
                                ByRef cpg_id As Long, _
                                ByVal doc_id As Long)
  
  GetClienteData2 = GetClienteDataEx2(cli_id, _
                                    lp_id, _
                                    ld_id, _
                                    cpg_id, _
                                    0, 0, 0, _
                                    vbNullString, vbNullString, vbNullString, _
                                    doc_id)
End Function

Public Function GetClienteData(ByVal cli_id As Long, _
                               ByRef lp_id As Long, _
                               ByRef ld_id As Long, _
                               ByRef cpg_id As Long)
  
  GetClienteData = GetClienteDataEx(cli_id, _
                                    lp_id, _
                                    ld_id, _
                                    cpg_id, _
                                    0, 0, 0, _
                                    vbNullString, vbNullString, vbNullString)
End Function

Public Function GetClienteDataEx2(ByVal cli_id As Long, _
                                  ByRef lp_id As Long, _
                                  ByRef ld_id As Long, _
                                  ByRef cpg_id As Long, _
                                  ByRef trans_id As Long, _
                                  ByRef pro_id As Long, _
                                  ByRef ven_id As Long, _
                                  ByRef trans_nombre As String, _
                                  ByRef pro_nombre As String, _
                                  ByRef ven_nombre As String, _
                                  ByVal doc_id As Long)
  
  GetClienteDataEx2 = pGetClienteData(cli_id, _
                                      lp_id, _
                                      ld_id, _
                                      cpg_id, _
                                      trans_id, _
                                      pro_id, _
                                      ven_id, _
                                      trans_nombre, _
                                      pro_nombre, _
                                      ven_nombre, _
                                      doc_id)
End Function

Public Function GetClienteDataEx(ByVal cli_id As Long, _
                                 ByRef lp_id As Long, _
                                 ByRef ld_id As Long, _
                                 ByRef cpg_id As Long, _
                                 ByRef trans_id As Long, _
                                 ByRef pro_id As Long, _
                                 ByRef ven_id As Long, _
                                 ByRef trans_nombre As String, _
                                 ByRef pro_nombre As String, _
                                 ByRef ven_nombre As String)
  
  GetClienteDataEx = pGetClienteData(cli_id, _
                                      lp_id, _
                                      ld_id, _
                                      cpg_id, _
                                      trans_id, _
                                      pro_id, _
                                      ven_id, _
                                      trans_nombre, _
                                      pro_nombre, _
                                      ven_nombre, _
                                      csNO_ID)
End Function

Private Function pGetClienteData(ByVal cli_id As Long, _
                                 ByRef lp_id As Long, _
                                 ByRef ld_id As Long, _
                                 ByRef cpg_id As Long, _
                                 ByRef trans_id As Long, _
                                 ByRef pro_id As Long, _
                                 ByRef ven_id As Long, _
                                 ByRef trans_nombre As String, _
                                 ByRef pro_nombre As String, _
                                 ByRef ven_nombre As String, _
                                 ByVal doc_id As Long)
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_ClienteGetData " & cli_id & "," & GetMonIdFromDoc(doc_id)
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  If Not rs.EOF Then
    lp_id = gDB.ValField(rs.Fields, cscLpId)
    ld_id = gDB.ValField(rs.Fields, cscLdId)
    cpg_id = gDB.ValField(rs.Fields, cscCpgId)
    
    trans_id = gDB.ValField(rs.Fields, cscTransId)
    pro_id = gDB.ValField(rs.Fields, cscProId)
    ven_id = gDB.ValField(rs.Fields, cscVenId)
  
    trans_nombre = gDB.ValField(rs.Fields, cscTransNombre)
    pro_nombre = gDB.ValField(rs.Fields, cscProNombre)
    ven_nombre = gDB.ValField(rs.Fields, cscVenNombre)
  End If
  
  pGetClienteData = True
End Function


Public Function GetKitInfo(ByVal PrId As Long, ByRef CollKitInfo As Collection) As Collection
  On Error Resume Next
  Set GetKitInfo = CollKitInfo.Item(GetKey(PrId))
End Function

Public Function GetCollKitInfoXPrId(ByVal PrId As Long, ByRef CollKitInfo As Collection) As Collection
  Dim rtn As Collection
  
  If CollKitInfo Is Nothing Then Set CollKitInfo = New Collection
  
  Set rtn = GetKitInfo(PrId, CollKitInfo)
  
  If rtn Is Nothing Then
    Set rtn = New Collection
    CollKitInfo.Add rtn, GetKey(PrId)
  End If
  
  Set GetCollKitInfoXPrId = rtn
End Function

Public Function GetKitInfoItem(ByRef Coll As Collection, ByVal PrId As Long) As cKitInfo
  On Error Resume Next
  Dim rtn As cKitInfo
  
  Set rtn = GetKitInfoItemAux(Coll, PrId)
  
  If rtn Is Nothing Then
    Set rtn = New cKitInfo
    Coll.Add rtn, GetKey(PrId)
  End If
  
  Set GetKitInfoItem = rtn
End Function

Public Function GetKitInfoItemAux(ByRef Coll As Collection, ByVal PrId As Long) As cKitInfo
  On Error Resume Next
  Set GetKitInfoItemAux = Coll.Item(GetKey(PrId))
End Function

Public Function ValidateNroCuit(ByVal Cuit As String, ByVal bMustByRight As Boolean) As Boolean
  On Error GoTo ControlError
  
  If m_ContConfig Is Nothing Then
    Set m_ContConfig = New cContabilidadConfig
    If Not m_ContConfig.Load() Then Exit Function
  End If
  
  Select Case m_ContConfig.ClaveFiscal
    
    Case csEClaveFiscalCuit
      ValidateNroCuit = ValidateNroCuitEx(Cuit, bMustByRight)
    Case csEClaveFiscalRut
      ValidateNroCuit = ValidateRutEx(Cuit, bMustByRight)
  End Select

  GoTo ExitProc
ControlError:
  MngError Err, "ValidateNroCuit", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Public Function ValidateNroCuitEx(ByVal Cuit As String, ByVal bMustByRight As Boolean) As Boolean
  On Error GoTo ControlError

  Dim iSum    As Long
  Dim iRest   As Long
  Dim iDigit  As Long
  Dim bAsk    As Boolean
  Dim msg     As String
  
  ' Permitimos la palabra CUIT como un cuit valido
  '
  If LCase$(Cuit) = "cuit" Then
    ValidateNroCuitEx = True
    Exit Function
  End If
  
  msg = LNGGetText(2925, vbNullString)  'El número de CUIT no es válido
  
  If LenB(Trim(Cuit)) = 0 Then
    MsgWarning msg
    Exit Function
  End If
  
  If Len(Trim(Cuit)) < 11 Then
    bAsk = True
  Else
    Cuit = Replace(Cuit, "-", vbNullString)
    iSum = Val(Mid(Cuit, 1, 1)) * 5
    iSum = iSum + Val(Mid(Cuit, 2, 1)) * 4
    iSum = iSum + Val(Mid(Cuit, 3, 1)) * 3
    iSum = iSum + Val(Mid(Cuit, 4, 1)) * 2
    iSum = iSum + Val(Mid(Cuit, 5, 1)) * 7
    iSum = iSum + Val(Mid(Cuit, 6, 1)) * 6
    iSum = iSum + Val(Mid(Cuit, 7, 1)) * 5
    iSum = iSum + Val(Mid(Cuit, 8, 1)) * 4
    iSum = iSum + Val(Mid(Cuit, 9, 1)) * 3
    iSum = iSum + Val(Mid(Cuit, 10, 1)) * 2
    iRest = iSum Mod 11
    
    iDigit = 11 - iRest
    iDigit = IIf(iDigit = 11, 0, iDigit)
    iDigit = IIf(iDigit = 10, 1, iDigit)

    If iDigit <> Val(Mid(Cuit, 11, 1)) Then
      bAsk = True
    End If
  End If
  
  If bAsk Then
    If Not bMustByRight Then
      If Not Ask(msg & vbCrLf & vbCrLf & LNGGetText(1529, vbNullString), vbYes) Then
                                      '¿Desea guardar los cambios de todas formas?
        Exit Function
      End If
    Else
      MsgWarning msg
      Exit Function
    End If
  End If
  
  ValidateNroCuitEx = True

  GoTo ExitProc
ControlError:
  MngError Err, "ValidateNroCuitEx", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Public Function ValidateRutEx(ByVal rut As String, ByVal bMustByRight As Boolean) As Boolean
  On Error GoTo ControlError
  
  Dim Cuenta  As Integer
  Dim suma    As Integer
  Dim resto   As Integer
  Dim digito  As Integer
  
  Dim dig     As Currency
  Dim numrut  As Long
  
  Dim msg     As String
    
  suma = 0
  Cuenta = 2
  rut = Replace(rut, ".", vbNullString)
  
  msg = LNGGetText(2919, vbNullString) 'El número de RUT no es válido
  
  If Len(Trim$(rut)) < 10 Then
    MsgWarning msg
    Exit Function
  End If
  
  If Not IsNumeric(Left$(rut, 8)) Then
    MsgWarning msg
    Exit Function
  End If
  
  Dim dv As String
  
  dv = Right$(rut, 1)
  numrut = Left$(rut, 8)
  
  Do
    dig = numrut Mod 10
    numrut = Int(numrut / 10)
    suma = suma + (dig * Cuenta)
    Cuenta = Cuenta + 1
    If Cuenta = 8 Then
      Cuenta = 2
    End If
  Loop Until numrut = 0
  
  resto = suma Mod 11
  digito = 11 - resto
  
  Dim RutDigito As String
  
  Select Case digito
    Case 10
      RutDigito = "K"
    Case 11
      RutDigito = "0"
    Case Else
      RutDigito = Trim(Str(digito))
  End Select
  
  Dim bAsk    As Boolean
  
  If RutDigito <> dv Then
    bAsk = True
  End If

  If bAsk Then
    If Not bMustByRight Then
      If Not Ask(msg & vbCrLf & vbCrLf & LNGGetText(1529, vbNullString), vbYes) Then
                                        '¿Desea guardar los cambios de todas formas?
        Exit Function
      End If
    Else
      MsgWarning msg
      Exit Function
    End If
  End If

  ValidateRutEx = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "ValidateRutEx", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Public Function ShowEditState(ByVal msg As String, ByVal Title As String)
  If LenB(msg) Then
    MsgInfo msg, Title
  Else
    MsgInfo LNGGetText(2920, vbNullString), Title
            'Ud. puede modificar el documento
  End If
End Function

Public Sub SetPrecio(ByRef Row As CSInterfacesABM.cIABMGridRow, _
                     ByVal pr_id As Long, _
                     ByRef iProp As cIABMProperty, _
                     ByVal KI_PRECIO_LP As Long, _
                     ByVal KI_PRECIO_USR As Long)
                      
  Dim LP        As cListaPrecio
  Dim lp_id     As Long
  Dim Precio    As Double
  
  lp_id = iProp.HelpId
    
  If lp_id <> 0 Then
    Set LP = New cListaPrecio
    Precio = LP.GetPrecio(lp_id, pr_id)
  End If
  
  pCell(Row, KI_PRECIO_LP).Value = Precio
  pCell(Row, KI_PRECIO_USR).Value = Precio
End Sub

Public Sub SetDescuento(ByRef Row As CSInterfacesABM.cIABMGridRow, _
                        ByVal pr_id As Long, _
                        ByVal Precio As Double, _
                        ByRef iProp As cIABMProperty, _
                        ByVal KI_PRECIO As Long, _
                        ByVal KI_DESCUENTO As Long)
                         
  Dim LD            As cListaDescuento
  Dim ld_id         As Long
  Dim Descuento     As String
  
  ld_id = iProp.HelpId
  
  If ld_id <> 0 Then
    Set LD = New cListaDescuento
    Precio = LD.GetPrecio(ld_id, pr_id, Precio)
    Descuento = LD.GetDescuentoStr(ld_id, pr_id)
  End If
  
  pCell(Row, KI_PRECIO).Value = Precio
  pCell(Row, KI_DESCUENTO).Value = Descuento
End Sub

Public Sub SetPrecioIva(ByRef Row As CSInterfacesABM.cIABMGridRow, _
                        ByVal KII_PRECIO_SIN_IVA As Long, _
                        ByVal KII_IVARIPercent As Long, _
                        ByVal KII_IVARNIPercent As Long, _
                        ByVal KII_PRECIOIVA As Long, _
                        ByVal bIva As Boolean, _
                        ByVal bIvaRni As Boolean)
  
  SetPrecioIvaEx Row, _
                  KII_PRECIO_SIN_IVA, _
                  KII_IVARIPercent, _
                  KII_IVARNIPercent, _
                  0, _
                  0, _
                  KII_PRECIOIVA, _
                  bIva, _
                  bIvaRni
End Sub

Public Sub SetPrecioIvaEx(ByRef Row As CSInterfacesABM.cIABMGridRow, _
                          ByVal KII_PRECIO_SIN_IVA As Long, _
                          ByVal KII_IVARIPercent As Long, _
                          ByVal KII_IVARNIPercent As Long, _
                          ByVal KII_INTERNOSPercent As Long, _
                          ByVal KII_INTERNOSPorc As Long, _
                          ByVal KII_PRECIOIVA As Long, _
                          ByVal bIva As Boolean, _
                          ByVal bIvaRni As Boolean)
                        
  Dim PrecioIva As Double
  Dim Precio    As Double
  Dim IvaRi     As Double
  Dim IvaRni    As Double
  Dim Internos  As Double
  Dim int_porc  As Double
  
  Precio = Val(pCell(Row, KII_PRECIO_SIN_IVA).Value)
  If bIva Then
    IvaRi = (Precio * Val(pCell(Row, KII_IVARIPercent).Value)) / 100
  End If
  If bIvaRni Then
    IvaRni = (Precio * Val(pCell(Row, KII_IVARNIPercent).Value)) / 100
  End If
  
  If KII_INTERNOSPercent Then
    int_porc = Val(pCell(Row, KII_INTERNOSPorc).Value)
    Internos = Val(pCell(Row, KII_INTERNOSPercent).Value)
    Internos = ((Precio * int_porc / 100) * Internos) / 100
  End If
  
  PrecioIva = Precio + IvaRi + IvaRni + Internos
  
  pCell(Row, KII_PRECIOIVA).Value = PrecioIva
End Sub

Public Sub SetTotal(ByRef Row As cIABMGridRow, _
                    ByVal KII_TOTAL As Long, _
                    ByVal KII_APLICAR As Long, _
                    ByVal KII_PRECIOIVA As Long)
                    
  pCell(Row, KII_TOTAL).Value = Val(pCell(Row, KII_APLICAR).Value) _
                              * Val(pCell(Row, KII_PRECIOIVA).Value)
End Sub

Public Function GetItems(ByRef AbmObj As cIABMGeneric, ByVal Key As String)
  Set GetItems = AbmObj.Properties.Item(Key)
End Function

Public Function GetWizProperty(ByRef ObjWiz As cIWizardGeneric, _
                               ByVal StepId As Integer, _
                               ByVal KeyItem As String) As cIABMProperty
                                
  With ObjWiz.Steps.Item(GetKey(StepId))
    Set GetWizProperty = .Properties.Item(KeyItem)
  End With
End Function

Public Function GetDocumentoTipoInfo(ByVal doct_id As Long, _
                                     ByRef doct_nombre As String, _
                                     ByRef doct_object As String, _
                                     ByRef pre_id As Long) As Boolean

  GetDocumentoTipoInfo = GetDocumentoTipoInfo_(doct_id, _
                                               doct_nombre, _
                                               doct_object, _
                                               pre_id)
End Function

Public Function DocGetCotizacion(ByVal DocId As Long, ByVal dDate As Date) As Double
  Dim MonId As Long
  If Not gDB.GetData(csTDocumento, cscDocId, DocId, cscMonId, MonId) Then Exit Function
  DocGetCotizacion = GetCotizacion(MonId, dDate)
End Function

Public Function GetCotizacion(ByVal MonId As Long, ByVal dDate As Date) As Double
  Dim Moneda As cMoneda
  Set Moneda = New cMoneda

  GetCotizacion = Moneda.GetCotizacion(MonId, dDate)
End Function

Public Function WizMustValidateCotizacion(ByVal DocId As Long) As Boolean
  Dim MonId As Long
  
  If Not gDB.GetData(csTDocumento, cscDocId, DocId, cscMonId, MonId) Then Exit Function
  
  WizMustValidateCotizacion = MonId <> GetMonedaDefault
End Function

Public Sub ShowCotizacion(ByVal CompId As Long, _
                          ByVal DocId As Long, _
                          ByVal MonId As Long, _
                          ByRef LastMonId As Long, _
                          ByRef ObjAbm As cIABMGeneric, _
                          ByVal keyPropCotiz As String, _
                          ByVal keyPropFecha As String)
  
  Dim dDate   As Variant
  Dim iProp   As cIABMProperty
  
  If CompId = csNO_ID Then
    If DocId = csNO_ID Then Exit Sub
    If Not gDB.GetData(csTDocumento, cscDocId, DocId, cscMonId, MonId) Then Exit Sub
  End If
  
  Set iProp = ObjAbm.Properties.Item(keyPropCotiz)
  iProp.Visible = MonId <> GetMonedaDefault
  
  If LastMonId <> MonId Or Val(iProp.Value) = 0 Then
    dDate = ObjAbm.Properties.Item(keyPropFecha).Value
    If Not IsDate(dDate) Then dDate = Date
    iProp.Value = GetCotizacion(MonId, dDate)
    LastMonId = MonId
  End If
  
  ObjAbm.ShowValue iProp
End Sub

Public Function GetStockLoteFilterEx(ByVal depl_id As Long, _
                                     ByVal bStockXFisico As Boolean, _
                                     ByVal pr_id_kit As Long, _
                                     ByVal depf_id As Long, _
                                     ByVal cli_id As Long, _
                                     ByVal prov_id As Long)

  GetStockLoteFilterEx = pGetStockLoteFilter(depl_id, _
                                           bStockXFisico, _
                                           pr_id_kit, _
                                           depf_id, _
                                           cli_id, _
                                           prov_id)
End Function

Public Function GetStockLoteFilter(ByVal depl_id As Long, _
                                   ByVal bStockXFisico As Boolean, _
                                   ByVal pr_id_kit As Long, _
                                   ByVal depf_id As Long) As String
  
  GetStockLoteFilter = pGetStockLoteFilter(depl_id, _
                                           bStockXFisico, _
                                           pr_id_kit, _
                                           depf_id, _
                                           csNO_ID, _
                                           csNO_ID)
End Function

Private Function pGetStockLoteFilter(ByVal depl_id As Long, _
                                     ByVal bStockXFisico As Boolean, _
                                     ByVal pr_id_kit As Long, _
                                     ByVal depf_id As Long, _
                                     ByVal cli_id As Long, _
                                     ByVal prov_id As Long) As String
  Dim sqlstmt As String
  Dim sqlstmtDepl As String
  
  If depl_id = csE_DepositosInternos.csEDeplIdTercero Then
  
    If cli_id <> csNO_ID Then
  
      sqlstmt = "(exists(select stl_id from stockitem sti inner join remitoventa rv " & _
                       "on sti.st_id = rv.st_id and rv.cli_id = " & cli_id & _
                       " where stl_id = stl.stl_id)"
                       
      sqlstmt = sqlstmt & " or exists(select stl_id from stockitem sti inner join facturaventa fv " & _
                                    "on sti.st_id = fv.st_id and fv.cli_id = " & cli_id & _
                                    " where stl_id = stl.stl_id))"
    
    ElseIf prov_id <> csNO_ID Then
  
      sqlstmt = "(exists(select stl_id from stockitem sti inner join remitocompra rc " & _
                       "on sti.st_id = rc.st_id and rc.prov_id = " & prov_id & _
                       " where stl_id = stl.stl_id)"
                       
      sqlstmt = sqlstmt & " or exists(select stl_id from stockitem sti inner join facturacompra fc " & _
                                    "on sti.st_id = fc.st_id and fc.prov_id = " & prov_id & _
                                    " where stl_id = stl.stl_id))"
    Else
      sqlstmt = "(1=2)" ' Para que no devuelva nada
    End If

  Else
  
                    ' Este 'OR' es momentaneo hasta
                    ' que el control de stock este estable
                    '
    If bStockXFisico Or pGetNoControlaStock() Then
      
      sqlstmtDepl = "exists (select * from DepositoLogico depl " & _
                            "where depl.depl_id = stc.depl_id " & _
                             "and depl.depf_id = " & depf_id & ")"
    Else
      sqlstmtDepl = "depl_id = " & depl_id
    End If
    
    sqlstmt = "exists(select stl_id from StockCache stc" & _
                    " where stc.stl_id = stl.stl_id" & _
                       " and stc.pr_id = stl.pr_id" & _
                       " and " & sqlstmtDepl & _
                       " and IsNull(stc.pr_id_kit,0) = " & pr_id_kit & _
                    " group by stl_id having sum(stc_cantidad) > 0)"
  End If
  
  pGetStockLoteFilter = sqlstmt
End Function

Public Function GetHelpFilterCuenta() As String
  GetHelpFilterCuenta = "(emp_id = " & EmpId & " or emp_id is null)"
End Function

Public Function GetHelpFilterCliSuc(ByVal cli_id As Long) As String
  GetHelpFilterCliSuc = GetHelpFilterCliSuc_(cli_id)
End Function

Public Sub HelpShowInfo(ByVal Table As csTables, _
                        ByVal Id As Long, _
                        Optional ByVal SPInfoFilter As String)
                    
  On Error GoTo ControlError
    
  If Id = csNO_ID Then Exit Sub
  
  On Error Resume Next
  Dim c As CSOAPI2.cHelp
  
  Set c = New CSOAPI2.cHelp
  
  c.ShowInfo Table, Val(Id), SPInfoFilter, _
             0, _
             0, _
             0

  GoTo ExitProc
ControlError:
  MngError Err, "HelpShowInfo", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Public Function GetCueIdEfectivoFromUser(ByVal UsId As Long, ByVal EmpId As Long, ByRef Cuenta As String) As Long
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  Cuenta = vbNullString
  
  sqlstmt = "sp_UsuarioGetCueIdEfectivo " & UsId & "," & EmpId
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  If rs.EOF Then Exit Function
  
  GetCueIdEfectivoFromUser = gDB.ValField(rs.Fields, 0)
  Cuenta = gDB.ValField(rs.Fields, 1)
End Function

Public Function GetCueIdEfectivoFromUserHR(ByVal UsId As Long, ByVal EmpId As Long, ByRef Cuenta As String) As Long
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  Cuenta = vbNullString
  
  sqlstmt = "sp_UsuarioGetCueIdEfectivo " & UsId & "," & EmpId & ",1"
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  If rs.EOF Then Exit Function
  
  GetCueIdEfectivoFromUserHR = gDB.ValField(rs.Fields, 0)
  Cuenta = gDB.ValField(rs.Fields, 1)
End Function

Public Function GetCueIdTicketFromUser(ByVal UsId As Long, ByVal EmpId As Long, ByRef Cuenta As String) As Long
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  Cuenta = vbNullString
  
  sqlstmt = "sp_UsuarioGetCueIdTicket " & UsId & "," & EmpId
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  If rs.EOF Then Exit Function
  
  GetCueIdTicketFromUser = gDB.ValField(rs.Fields, 0)
  Cuenta = gDB.ValField(rs.Fields, 1)
End Function

Public Function GetCueIdTicketFromUserHR(ByVal UsId As Long, ByVal EmpId As Long, ByRef Cuenta As String) As Long
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  Cuenta = vbNullString
  
  sqlstmt = "sp_UsuarioGetCueIdTicket " & UsId & "," & EmpId & ",1"
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  If rs.EOF Then Exit Function
  
  GetCueIdTicketFromUserHR = gDB.ValField(rs.Fields, 0)
  Cuenta = gDB.ValField(rs.Fields, 1)
End Function

' funciones friend
' funciones privadas
Private Function pIsValidDate(ByVal DocId As Long, ByVal Fecha As Date, ByRef rango As String) As Boolean
  Dim rs      As ADODB.Recordset
  Dim sqlstmt As String
  
  If DocId = csNO_ID Then Exit Function

  sqlstmt = "sp_docValidateDate " & DocId & "," & gDB.sqlDate(Fecha)
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function

  If rs.EOF Then Exit Function

  pIsValidDate = gDB.ValField(rs.Fields, 0)
  rango = gDB.ValField(rs.Fields, 1)
End Function

Private Function pEditNroSerie(ByVal Grupo As Long, _
                               ByVal Cantidad As Long, _
                               ByRef Row As cIABMGridRow, _
                               ByRef NrosSerie As Collection, _
                               ByVal KI_GRUPO As Long, _
                               ByVal KI_NROSERIE As Long, _
                               ByVal lRow As Long, _
                               ByVal PrId As Long, _
                               ByVal DeplId As Long, _
                               ByVal IsInput As Boolean, _
                               ByVal bEditKit As Boolean, _
                               ByVal bParteProdKit As Boolean, _
                               ByRef CollKitInfo As Collection, _
                               ByVal prov_id As Long, _
                               ByVal cli_id As Long, _
                               ByVal DeleteCount As Long, _
                               ByVal PrId2 As Long) As Boolean
  
  Dim EditSerie As cProductoSerie
  Dim i         As Long
  Dim n         As Long
  Dim Coll      As Collection
  
  If Cantidad < 1 Then
    MsgWarning LNGGetText(2921, vbNullString) 'Debe indicar una cantidad
    Exit Function
  End If
  
  Set EditSerie = New cProductoSerie
  
  With EditSerie
    
    .bEditKit = bEditKit
    .bParteProdKit = bParteProdKit
    
    If bEditKit Then
    
      Cantidad = pGetCantidadForKit(CollKitInfo, Cantidad)
    
      If CollKitInfo Is Nothing Then
        MsgWarning LNGGetText(2922, vbNullString)
                   'No se recibió la definición del kit. No se pueden editar los & _
                   Números de Serie
        Exit Function
      End If
    End If
    
    ' Si ya existen numeros de serie para este item
    '
    If ExistsObjectInColl(NrosSerie, GetKey(Grupo)) Then
      
      ' Paso de la coleccion a la ventana de edicion
      '
      Set Coll = NrosSerie.Item(GetKey(Grupo))
      For i = 1 To Coll.Count
        .AddProductoSerie Coll.Item(i)
      Next
      n = .Coll.Count
    End If
    
    If bEditKit Then
      
      Dim KitS As cKitInfo
    
      While n < Cantidad
        For Each KitS In CollKitInfo
        
          If KitS.LlevaNroSerie Then
        
            For i = 1 To KitS.Cantidad
        
              ' Creo filas para los nuevos numeros de serie
              '
              n = n + 1
              .AddProductoSerie New cProductoSerieType
              With .Coll(n)
                .prns_id = n * -1
                .pr_id = IIf(PrId, PrId, PrId2)
                .pr_id_item = KitS.pr_id
                .pr_id_kit = KitS.pr_id_kit
                .KitItem = KitS.Nombre
              End With
            Next
          End If
        Next
      Wend
    Else
    
      ' Creo filas para los nuevos numeros de serie
      '
      For i = n + 1 To Cantidad
        .AddProductoSerie New cProductoSerieType
        .Coll(i).prns_id = i * -1
        .Coll(i).pr_id = IIf(PrId, PrId, PrId2)
      Next
    
    End If
    
    .depl_id = DeplId
    .pr_id = PrId
    .IsInput = IsInput
    .cli_id = cli_id
    .prov_id = prov_id
    .Delete = DeleteCount
    .DeleteCount = DeleteCount
    
    If Not .Edit Then Exit Function
    
    Dim vSeries()   As String
    Dim idx         As Long
    Dim ubSeries    As Long
    
    ubSeries = 400
    ReDim vSeries(ubSeries)
    
    ' Si este item aun no tiene numeros de serie
    ' creo una nueva coleccion y la agrego a la coleccion de items
    ' el grupo esta en negativo para indicar que son nuevos
    '
    If Coll Is Nothing Then
      Grupo = lRow * -1
      pCell(Row, KI_GRUPO).Id = Grupo '(NrosSerie.Count + 1) * -1
      Set Coll = New Collection
      NrosSerie.Add Coll, GetKey(Grupo)
    End If
    
    CollClear Coll
    
    ' Paso de la ventana a la coleccion del item
    '
    For i = 1 To .Coll.Count
      
      Dim pt        As cProductoSerieType
      Dim delCount  As Long
      
      Set pt = .Coll.Item(i)
      With pt
        .pr_id = IIf(PrId, PrId, PrId2)
        
        If idx > ubSeries Then
          ubSeries = ubSeries + 400
          ReDim Preserve vSeries(ubSeries)
        End If
        
        If .Deleted And delCount < DeleteCount Then
          delCount = delCount + 1
          vSeries(idx) = .Codigo & _
                         IIf(LenB(.Codigo2), _
                             " | " & .Codigo2, _
                             vbNullString) & "(B)"
        Else
          vSeries(idx) = .Codigo & _
                         IIf(LenB(.Codigo2), _
                             " | " & .Codigo2, _
                             vbNullString)
        End If
        
        idx = idx + 1
  
        Coll.Add pt, GetKey(.prns_id)
      End With
    Next
  End With
  
  idx = idx - 1
  If idx >= 0 Then
    ReDim Preserve vSeries(idx)
    pCell(Row, KI_NROSERIE).Value = Join(vSeries, ",")
  Else
    pCell(Row, KI_NROSERIE).Value = vbNullString
  End If
  
  pEditNroSerie = True
End Function

Private Function pCreateNroSerieAux(ByVal Grupo As Long, _
                                    ByVal Cantidad As Long, _
                                    ByRef Row As cIABMGridRow, _
                                    ByRef NrosSerie As Collection, _
                                    ByVal KI_GRUPO As Long, _
                                    ByVal KI_NROSERIE As Long, _
                                    ByVal lRow As Long, _
                                    ByVal PrId As Long, _
                                    ByVal DeplId As Long, _
                                    ByVal IsInput As Boolean, _
                                    ByVal bEditKit As Boolean, _
                                    ByVal bParteProdKit As Boolean, _
                                    ByRef CollKitInfo As Collection, _
                                    ByVal prov_id As Long, _
                                    ByVal cli_id As Long, _
                                    ByVal DeleteCount As Long, _
                                    ByVal PrId2 As Long) As Boolean
  
  Dim EditSerie As cProductoSerie
  Dim i         As Long
  Dim n         As Long
  Dim Coll      As Collection
  Dim Nros      As String
  
  If Cantidad < 1 Then
    MsgWarning LNGGetText(2921, vbNullString) 'Debe indicar una cantidad
    Exit Function
  End If

  If bEditKit Then
    Cantidad = pGetCantidadForKit(CollKitInfo, Cantidad)
    
    If CollKitInfo Is Nothing Then
      MsgWarning LNGGetText(2922, vbNullString)
              'No se recibio la definicion del kit. No se pueden editar los numeros de serie
      Exit Function
    End If
    
  End If
    
    
  ' Si ya existen numeros de serie para este item
  '
  If ExistsObjectInColl(NrosSerie, GetKey(Grupo)) Then
    
    ' Paso de la coleccion a la ventana de edicion
    '
    Set Coll = NrosSerie.Item(GetKey(Grupo))
  
  Else
  
  ' Si este item aun no tiene numeros de serie
  ' creo una nueva coleccion y la agrego a la coleccion de items
  ' el grupo esta en negativo para indicar que son nuevos
  '

    Grupo = lRow * -1
    pCell(Row, KI_GRUPO).Id = Grupo '(NrosSerie.Count + 1) * -1
    Set Coll = New Collection
    NrosSerie.Add Coll, GetKey(Grupo)
  
  End If
    
  n = Coll.Count

  If bEditKit Then
    
    Dim KitS As cKitInfo
  
    While n < Cantidad
      For Each KitS In CollKitInfo
      
        If KitS.LlevaNroSerie Then
      
          For i = 1 To KitS.Cantidad
      
            ' Creo filas para los nuevos numeros de serie
            '
            n = n + 1
            Coll.Add New cProductoSerieType, GetKey(n * -1)
            With Coll(n)
              .Codigo = pGetNextNumeroSerieAux()
              .prns_id = n * -1
              .pr_id = IIf(PrId, PrId, PrId2)
              .pr_id_item = KitS.pr_id
              .pr_id_kit = KitS.pr_id_kit
              .KitItem = KitS.Nombre
            End With
          Next
        End If
      Next
    Wend
  Else
  
    ' Creo filas para los nuevos numeros de serie
    '
    For i = n + 1 To Cantidad
      Coll.Add New cProductoSerieType, GetKey(i * -1)
      With Coll(i)
        .Codigo = pGetNextNumeroSerieAux()
        .prns_id = i * -1
        .pr_id = IIf(PrId, PrId, PrId2)
      End With
    Next
  
  End If
  
  ' Paso de la ventana a la coleccion del item
  '
  For i = 1 To Coll.Count
    
    Dim pt        As cProductoSerieType
    Dim delCount  As Long
    
    Set pt = Coll.Item(i)
    With pt
      .pr_id = IIf(PrId, PrId, PrId2)
      If .Deleted And delCount < DeleteCount Then
        delCount = delCount + 1
        Nros = Nros & .Codigo & "(B),"
      Else
        Nros = Nros & .Codigo & ","
      End If
    End With
  Next
  
  pCell(Row, KI_NROSERIE).Value = RemoveLastColon(Nros)

  pCreateNroSerieAux = True
End Function

Private Function pGetNextNumeroSerieAux() As String
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_StockNumeroSerieAuxGetNext"
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  If rs.EOF Then
    Err.Raise -1, , LNGGetText(2923, vbNullString)
                    '@@ERROR_SP:No se pudo obtener un Número de Serie auxiliar.
    Exit Function
  End If
  
  pGetNextNumeroSerieAux = gDB.ValField(rs.Fields, 0)
End Function

Private Function pValidateDocEmpresa(ByVal doc_id As Long) As Boolean
  Dim emp_id      As Long
  Dim emp_nombre  As String
  
  If Not gDB.GetData(csTDocumento, _
                     cscDocId, _
                     doc_id, _
                     cscEmpId, _
                     emp_id) Then Exit Function
                     
  If emp_id <> EmpId Then
  
    If Not gDB.GetData(csTEmpresa, _
                       cscEmpId, _
                       emp_id, _
                       cscEmpNombre, _
                       emp_nombre) Then Exit Function
  
    MsgWarning LNGGetText(2924, vbNullString, EmpNombre, emp_nombre)
                'El documento no pertenece a la empresa " & EmpNombre & _
                 Debe ingresar a la empresa & emp_nombre & _
                 para poder duplicarlo.
    Exit Function
  End If
    
  pValidateDocEmpresa = True
End Function

Private Function pGetNoControlaStock() As Boolean
  If Not m_bControlStockLoaded Then
    pGetTypeStockControl
  End If
  pGetNoControlaStock = m_ctrlStock = csENoControlaStock
End Function

Private Sub pGetTypeStockControl()
  Dim rs        As ADODB.Recordset
  Dim sqlstmt   As String
  
  sqlstmt = "select cfg_valor from configuracion where cfg_grupo = " _
              & gDB.sqlString(c_GrupoGeneral) _
              & " and cfg_aspecto = " _
              & gDB.sqlString(c_TipoControlStock)
              
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  If rs.EOF Then Exit Sub
  m_ctrlStock = Val(gDB.ValField(rs.Fields, cscCfgValor))
  m_bControlStockLoaded = True
End Sub

' construccion - destruccion
Private Function pGetCantidadForKit(ByRef CollKitInfo As Collection, ByVal Cantidad As Long) As Long
  Dim KitS As cKitInfo
  Dim rtn  As Long
  
  For Each KitS In CollKitInfo
    If KitS.LlevaNroSerie Then
      rtn = rtn + KitS.Cantidad * Cantidad
    End If
  Next
  pGetCantidadForKit = rtn
End Function

Private Sub Class_Terminate()
  On Error Resume Next
  Set m_ContConfig = Nothing
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

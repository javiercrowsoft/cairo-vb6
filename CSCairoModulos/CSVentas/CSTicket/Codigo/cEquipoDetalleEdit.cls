VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cEquipoDetalleEdit"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Private Const C_Module = "cEquipoDetalleEdit"

Implements CSInterfacesABM.cIEditGenericListDoc
Implements CSInterfacesABM.cIABMListDocClient

' pseudo-constantes
Private c_ErrorSave As String

Private m_ObjAbmParams       As cIABMGenericListDoc

' Parametros
Private m_Properties         As cABMDocProperties
Private m_Items              As cEquipoDetalleItems ' Esto no es un error, uso informeParametro
                                                    ' por que en reporteparametro solo tengo
                                                    ' el valor y si es visible

Private m_ed_id                          As Long
Private m_EquipoDetalle                  As String
Private m_OsId                           As Long
Private m_OsTMPId                        As Long
Private m_PrId                           As Long
Private m_PrnsId                         As Long
Private m_ProductoSerie                  As String
Private m_InTemp                         As Boolean

Private m_fParam                         As fEquipoDetalle

Private m_ObjList           As Object

Public Property Get OsId() As Long
  OsId = m_OsId
End Property

Public Property Let OsId(ByVal rhs As Long)
  m_OsId = rhs
End Property

Public Property Get OsTMPId() As Long
  OsTMPId = m_OsTMPId
End Property

Public Property Let OsTMPId(ByVal rhs As Long)
  m_OsTMPId = rhs
End Property

Public Property Get InTemp() As Boolean
  InTemp = m_InTemp
End Property

Public Property Let InTemp(ByVal rhs As Boolean)
  m_InTemp = rhs
End Property

Public Property Get PrId() As Long
  PrId = m_PrId
End Property

Public Property Let PrId(ByVal rhs As Long)
  m_PrId = rhs
End Property

Public Property Get ProductoSerie() As String
  ProductoSerie = m_ProductoSerie
End Property

Public Property Let ProductoSerie(ByVal rhs As String)
  m_ProductoSerie = rhs
End Property

Public Function ShowParams(ByVal prns_id As Long) As Boolean
  On Error GoTo ControlError

  Dim o As cIEditGenericListDoc
  
  Dim fParam As fEquipoDetalle
  Set fParam = New fEquipoDetalle
  
  fParam.NameEdit = LNGGetText(1817, vbNullString)  'Parametros
  fParam.Init
  
  Set o = Me
  Set o.ObjList = fParam.rptParams
  Set o.ObjABM = CSKernelClient2.CreateObject("CSABMInterface2.CABMGenericListDoc")

  o.ShowParams prns_id
  
  ' Si este equipo no tiene asociado un detalle
  ' devolvemos true sin hacer nada mas
  '
  If m_ed_id Then

    Set o = Nothing
    
    On Error Resume Next
    With fParam.rptParams
      .ReportTitle = m_EquipoDetalle & " " & m_ProductoSerie
      fParam.Caption = .ReportTitle
      .SetGenericStyle
    End With
    
    Dim mouse As cMouse
    Set mouse = New cMouse
    
    mouse.MouseSet vbDefault
    
    Set m_fParam = fParam
    
    fParam.Show vbModal
    
    ShowParams = fParam.Ok
  
  Else
    ShowParams = True
  End If
  
  GoTo ExitProc
ControlError:
  MngError Err, "ShowParams", C_Module, vbNullString
  If Err.Number Then Resume ExitProc

ExitProc:
  On Error Resume Next
 
  Set m_ObjAbmParams = Nothing
  Set m_fParam = Nothing
End Function

'//////////////////////////////////////////////////////
'//////////////////////////////////////////////////////
'//////////////////////////////////////////////////////
' Implementacion ListDocClient
'//////////////////////////////////////////////////////
'//////////////////////////////////////////////////////
'//////////////////////////////////////////////////////

Private Property Get cIABMListDocClient_Aplication() As String
  cIABMListDocClient_Aplication = gAppName
End Property

Private Sub cIABMListDocClient_DiscardChanges()
  Unload m_fParam
End Sub

Private Function cIABMListDocClient_ListAdHock(List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMListDocClient_Load()

End Sub

Private Property Get cIABMListDocClient_Properties() As Object
  Set cIABMListDocClient_Properties = m_Properties
End Property

Private Function cIABMListDocClient_PropertyChange(ByVal key As Integer) As Boolean
  cIABMListDocClient_PropertyChange = True
End Function

Private Function cIABMListDocClient_Refresh() As String
  Dim sqlstmt As String
  cIABMListDocClient_Refresh = sqlstmt
End Function

Private Function cIABMListDocClient_Save() As Boolean
  Dim register As cRegister
  Dim oss_id  As Long
  Dim bFound   As Boolean
  
  Set register = New cRegister
  
  Dim IProperty As cIABMProperty
  For Each IProperty In m_ObjAbmParams.Properties
    
    register.Fields.Clear
    
    With IProperty
  
      oss_id = pGetOssIdFromEdiId(.key, bFound)
  
      If bFound Then
      
        If m_InTemp Then
      
          register.fieldId = cscOssTMPId
          register.table = csTOrdenServicioSerieTMP
          register.Id = csNO_ID
        
        Else
          
          register.fieldId = cscOssId
          register.table = csTOrdenServicioSerie
          register.Id = oss_id
          
        End If
        
        Select Case IProperty.PropertyType
          Case cspHelp
            register.Fields.Add2 cscOssValor, .HelpValueProcess, csText
          Case cspList, cspAdHock
            register.Fields.Add2 cscOssValor, .ListItemData, csText
          Case cspDate
            If LenB(.HelpValueProcess) Then
              register.Fields.Add2 cscOssValor, .HelpValueProcess, csText
            Else
              register.Fields.Add2 cscOssValor, .Value, csText
            End If
          Case cspList
            register.Fields.Add2 cscOssValor, .ListItemData, csInteger
          Case Else
            register.Fields.Add2 cscOssValor, .Value, csText
        End Select
    
        If m_InTemp Then
          register.Fields.Add2 cscOsTMPId, m_OsTMPId, csId
        Else
          register.Fields.Add2 cscOsId, m_OsId, csId
        End If
        register.Fields.Add2 cscPrnsId, m_PrnsId, csId
        register.Fields.Add2 cscEdiId, .key, csId
    
        register.Fields.HaveLastUpdate = False
        register.Fields.HaveWhoModify = False
                                                                                
        If Not gDB.Save(register, , "cIABMListDocClient_Save", C_Module, c_ErrorSave) Then Exit Function
      End If
    End With
  Next
  
  If Not pLoadParamsForExec() Then Exit Function
  
  m_fParam.Ok = True
  cIABMListDocClient_Save = True
End Function

Private Function cIABMListDocClient_Terminate() As Boolean
  cIABMListDocClient_Terminate = True
End Function

Private Property Get cIABMListDocClient_Title() As String
  cIABMListDocClient_Title = LNGGetText(1817, vbNullString)   'Parametros
End Property

Private Function cIABMListDocClient_Validate() As Boolean
  cIABMListDocClient_Validate = True
End Function

Private Function pLoadParamsForExec() As Boolean
  Dim sqlstmt As String
  Dim Value   As String
  Dim rs      As Recordset
  
  sqlstmt = "sp_EquipoDetalleGetItems " & m_ed_id & "," & m_OsId & "," & m_PrnsId

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadParamsForExec", C_Module) Then Exit Function

  m_Items.Clear

  While Not rs.EOF
    
    If IsNull(rs.Fields(cscOssValor)) Then
      Value = ValField(rs.Fields, cscEdiDefault)
    Else
      Value = ValField(rs.Fields, cscOssValor)
    End If
    
    With m_Items.Add(Nothing)
      .Nombre = ValField(rs.Fields, cscEdiNombre)
      .Tipo = ValField(rs.Fields, cscEdiTipo)
      .default = Value
      .Tbl_id = ValField(rs.Fields, cscTblId)
      .sqlstmt = ValField(rs.Fields, cscEdiSqlstmt)
      .Id = ValField(rs.Fields, cscEdiId)
      .Visible = True
      
      If .Tipo = csEdItemDate And Not IsDate(.default) Then
        If DateNames(Value) Is Nothing Then
          .default = VDGetDateById(csToday)
        Else
          .default = Value
        End If
      End If
      
      ' Para poder guardarlo
      .oss_id = ValField(rs.Fields, cscOssId)
    End With
    
    rs.MoveNext
  Wend

  pLoadParamsForExec = True
End Function

'//////////////////////////////////////////////////////
'//////////////////////////////////////////////////////
'//////////////////////////////////////////////////////
' Implementacion cIEditGenericListDoc
'//////////////////////////////////////////////////////
'//////////////////////////////////////////////////////
'//////////////////////////////////////////////////////

Private Function cIEditGenericListDoc_GridAdd(ByVal KeyProperty As Integer) As Boolean

End Function

Private Function cIEditGenericListDoc_GridEdit(ByVal KeyProperty As Integer) As Boolean

End Function

Private Function cIEditGenericListDoc_GridRemove(ByVal KeyProperty As Integer) As Boolean

End Function

Private Property Set cIEditGenericListDoc_ObjABM(rhs As CSInterfacesABM.cIABMGenericListDoc)
  Set m_ObjAbmParams = rhs
End Property

Private Property Set cIEditGenericListDoc_ObjList(rhs As Object)
  Set m_ObjList = rhs
End Property

Private Function cIEditGenericListDoc_PropertyChange(ByVal key As Integer) As Boolean

End Function

Private Function cIEditGenericListDoc_ShowParams(ByVal prns_id As Long) As Boolean
  On Error GoTo ControlError
  
  If prns_id = csNO_ID Then Exit Function

  If Not Load(prns_id, m_PrId) Then Exit Function
  If Not pLoadParamsForExec() Then Exit Function
  
  If Not pLoadCollItems() Then Exit Function
  
  cIEditGenericListDoc_ShowParams = True
  Exit Function
ControlError:
  MngError Err, "cIEditGenericListDoc_ShowParams", C_Module, vbNullString
End Function

Private Function cIEditGenericListDoc_TabClick(ByVal Index As Integer) As Boolean

End Function

Private Function pLoadCollItems() As Boolean
  Dim Param      As cEquipoDetalleItem
  Dim tblName    As String
  Dim tblCampo   As String
  Dim tblCampoId As String
  Dim Value      As String
  Dim bExists    As Boolean
  
  m_ObjAbmParams.Properties.Clear

  For Each Param In m_Items
    
    If Param.Visible Then
    
      With m_ObjAbmParams.Properties.Add(Nothing)
        .Name = Param.Nombre
        .Value = Param.default
        .key = Param.Id
        
        Select Case Param.Tipo
          Case csEEdItemType.csEdItemCheck
            .PropertyType = cspCheck
          Case csEEdItemType.csEdItemDate
            .PropertyType = cspDate
          Case csEEdItemType.csEdItemHelp
            .PropertyType = cspHelp
            .table = Param.Tbl_id
            Value = vbNullString
            If Val(Param.default) <> 0 Then
              pGetTblData Param.Tbl_id, tblName, tblCampo, tblCampoId
              gDB.GetDataWithCondition tblName, tblCampo, tblCampoId & "=" & Param.default, Value, bExists
              If Not bExists Then Param.default = "0"
            End If
            .Value = Value
            .HelpId = Val(Param.default)
            .HelpValueProcess = Param.default
            
          Case csEEdItemType.csEdItemList
            .PropertyType = cspList
            Dim vList As Variant
            Dim q     As Long
            
            vList = Split(Param.sqlstmt, "|")
            q = -1
            While q < UBound(vList)
              With .List.Add(Nothing)
                q = q + 1
                .Value = vList(q)
                q = q + 1
                .Id = Val(vList(q))
              End With
            Wend
            
            .ListWhoSetItem = csListItemData
            .ListItemData = Val(Param.default)
            
          Case csEEdItemType.csEdItemNumeric
            .PropertyType = cspNumeric
            .SubType = cspDouble
          Case csEEdItemType.csEdItemSqlstmt
            .PropertyType = cspText
          Case csEEdItemType.csEdItemText
            .PropertyType = cspText
        End Select
      End With
    End If
  Next

  If Not m_ObjAbmParams.Show(Me, m_ObjList) Then Exit Function

  pLoadCollItems = True
End Function

Private Function pGetOssIdFromEdiId(ByVal edi_id As Long, ByRef bFound As Boolean) As Long
  Dim Item As cEquipoDetalleItem
  bFound = False
  For Each Item In m_Items
    If Item.Id = edi_id Then
      pGetOssIdFromEdiId = Item.oss_id
      bFound = True
      Exit Function
    End If
  Next
End Function

Private Function Load(ByVal PrnsId As Long, _
                      ByVal PrId As Long) As Boolean
                      
  Dim sqlstmt As String
  Dim rs As Recordset

  sqlstmt = "sp_EquipoDetalleGetDetalle " & PrnsId & "," & PrId

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If Not rs.EOF Then

    If Val(gDB.ValField(rs.Fields, 0)) Then

      m_PrnsId = gDB.ValField(rs.Fields, cscPrnsId)
      m_PrId = gDB.ValField(rs.Fields, cscPrId)
      m_ed_id = gDB.ValField(rs.Fields, cscEdId)
      m_EquipoDetalle = gDB.ValField(rs.Fields, cscEdNombre)
      
    ' Si no hay detalle de equipo
    ' nos vamos en silencio y sin error
    '
    'Else
    '
    '  MsgWarning gDB.ValField(rs.Fields, 1)
    
    End If
  Else

    m_PrnsId = csNO_ID

  End If

  Load = True
End Function

Private Sub pGetTblData(ByVal Tbl_id As Long, ByRef tblName As String, ByRef tblCampo As String, ByRef tblCampoId As String)
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  tblName = vbNullString
  tblCampo = vbNullString
  tblCampoId = vbNullString
  
  sqlstmt = "select tbl_nombrefisico, tbl_campoid, tbl_camponombre from tabla where tbl_id =" & Tbl_id
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  If Not rs.EOF Then
    tblName = ValField(rs.Fields, "tbl_nombrefisico")
    tblCampo = ValField(rs.Fields, "tbl_camponombre")
    tblCampoId = ValField(rs.Fields, "tbl_campoid")
  End If
End Sub

Private Sub Class_Initialize()
#If PREPROC_DEBUG Then
  gdbInitInstance C_Module
#End If

  On Error GoTo ControlError
 
  c_ErrorSave = LNGGetText(2278, vbNullString) 'Error al grabar Detalle de Equipo
 
  Set m_Properties = New cABMDocProperties
  Set m_Items = New cEquipoDetalleItems
  
  GoTo ExitProc
ControlError:
  MngError Err, "Class_Terminate", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
  On Error Resume Next
  
  Set m_Items = Nothing
  Set m_ObjList = Nothing
  Set m_Properties = Nothing
  Set m_ObjAbmParams = Nothing
  Set m_fParam = Nothing

#If PREPROC_DEBUG Then
  gdbTerminateInstance C_Module
#End If
End Sub

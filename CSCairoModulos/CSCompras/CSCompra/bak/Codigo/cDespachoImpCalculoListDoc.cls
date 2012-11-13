VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cDespachoImpCalculoListDoc"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGenericListDoc
Implements CSInterfacesABM.cIABMListDocClient

'--------------------------------------------------------------------------------
' cDespachoImpCalculoListDoc
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
Private Const C_Module = "cDespachoImpCalculoListDoc"

Private Const c_strDelete = "Error al grabar los párametros"
Private Const c_strLoad = "Error al carga el coeficiente"
Private Const c_strTitle = "Coeficiente de Costo de Importación"

Private Const K_FECHAINI             As Integer = 4
Private Const K_FECHAFIN             As Integer = 5
Private Const K_PROV_ID              As Integer = 6
Private Const K_TITULO               As Integer = 7
Private Const K_VIA                  As Integer = 8
Private Const K_VIA_EMPRESA          As Integer = 9
Private Const K_FACTURA              As Integer = 10
Private Const K_DESCRIP              As Integer = 11

Private Const c_FechaIni = "FechaIni"
Private Const c_FechaFin = "FechaFin"

Private Const c_img_task = 1

' estructuras
' variables privadas
Private m_ObjAbm        As cIABMGenericListDoc
Private m_ObjList       As Object

Private m_Us_id       As Long

Private m_FechaIniV           As String
Private m_FechaFinV           As String

Private m_FechaIni           As Date
Private m_FechaFin           As Date

Private m_Prov_id            As String
Private m_proveedor          As String
Private m_Titulo             As String
Private m_Via                As String
Private m_Viaempresa         As String
Private m_Factura            As String
Private m_Descrip            As String

Private m_Properties         As cABMDocProperties

Private m_MenuLoaded        As Boolean

Private m_MenuShowMensajes  As Long
Private m_MenuShowInfoProv  As Long
Private m_MenuAddMensaje    As Long

' propiedades publicas
' propiedades privadas
' funciones publicas
Public Function ProcessMenu(ByVal Index As Long)
  On Error GoTo ControlError

  Select Case Index
  
    Case m_MenuShowInfoProv
      HelpShowInfo csProveedor, pGetProvId()
    
    Case m_MenuShowMensajes
      pShowMensajes
      
    Case m_MenuAddMensaje
      pAddMensaje
      
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, "ProcessMenu", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

'-------------------------------------------------------------------------------------
' Interfaz cliente de List de documentos

Private Property Get cIABMListDocClient_Aplication() As String
  cIABMListDocClient_Aplication = gAppName
End Property

Private Sub cIABMListDocClient_DiscardChanges()
  LoadCollection
End Sub

Private Function cIABMListDocClient_ListAdHock(List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMListDocClient_Load()

End Sub

Private Property Get cIABMListDocClient_Properties() As Object
  Set cIABMListDocClient_Properties = m_Properties
End Property

Private Function cIABMListDocClient_PropertyChange(ByVal Key As Integer) As Boolean
  Dim iProp     As cIABMProperty
  
  Select Case Key
  
    Case K_FECHAINI
      Set iProp = m_ObjAbm.Properties(c_FechaIni)
  
      If iProp.HelpValueProcess <> vbNullString Then
        m_FechaIniV = iProp.HelpValueProcess
        m_FechaIni = VDGetDateByName(m_FechaIniV)
      ElseIf IsDate(iProp.Value) Then
        m_FechaIniV = vbNullString
        m_FechaIni = iProp.Value
      Else
        m_FechaIniV = vbNullString
        iProp.Value = m_FechaIni
      End If
  
    Case K_FECHAFIN
      Set iProp = m_ObjAbm.Properties(c_FechaFin)
      
      If iProp.HelpValueProcess <> vbNullString Then
        m_FechaFinV = iProp.HelpValueProcess
        m_FechaFin = VDGetDateByName(m_FechaFinV)
      ElseIf IsDate(iProp.Value) Then
        m_FechaFinV = vbNullString
        m_FechaFin = iProp.Value
      Else
        m_FechaFinV = vbNullString
        iProp.Value = m_FechaFin
      End If
      
    Case K_PROV_ID
      m_Prov_id = m_ObjAbm.Properties(cscProvId).HelpValueProcess
    
    Case K_TITULO
      m_Titulo = m_ObjAbm.Properties(cscDicTitulo).Value
    
    Case K_VIA
      m_Via = m_ObjAbm.Properties(cscDicVia).Value
  
    Case K_VIA_EMPRESA
      m_Viaempresa = m_ObjAbm.Properties(cscDicViaempresa).Value
  
    Case K_FACTURA
      m_Factura = m_ObjAbm.Properties(cscDicFactura).Value
  
    Case K_DESCRIP
      m_Descrip = m_ObjAbm.Properties(cscDicDescrip).Value
  
  End Select
  
  cIABMListDocClient_PropertyChange = True
End Function

Private Function cIABMListDocClient_Refresh() As String
  Dim sqlstmt As String
  
  sqlstmt = "sp_lsdoc_despachoimpcalculos "
  
  sqlstmt = sqlstmt & gDB.UserId & ","
  
  If Not DateNames(m_FechaIniV) Is Nothing Then
    sqlstmt = sqlstmt & gDB.sqlDate(VDGetDateByName(m_FechaIniV)) & ","
  Else
    sqlstmt = sqlstmt & gDB.sqlDate(m_FechaIni) & ","
  End If
  
  If Not DateNames(m_FechaFinV) Is Nothing Then
    sqlstmt = sqlstmt & gDB.sqlDate(VDGetDateByName(m_FechaFinV)) & ","
  Else
    sqlstmt = sqlstmt & gDB.sqlDate(m_FechaFin) & ","
  End If
  
  sqlstmt = sqlstmt & gDB.sqlString(m_Prov_id) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_Titulo) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_Via) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_Viaempresa) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_Factura) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_Descrip)
  
  cIABMListDocClient_Refresh = sqlstmt
End Function

Private Function cIABMListDocClient_Save() As Boolean
  Dim register As cRegister
  Set register = New cRegister
  
  Dim sqlstmt As String
  sqlstmt = "delete ListaDocumentoParametro" & _
            " where pre_id = " & csPreCpraListDespImpoCalc & _
              " and us_id = " & m_Us_id
                                                                                'Error al grabar el Coeficiente
  If Not gDB.Execute(sqlstmt, "cIABMClient_Save", "cDespachoImpCalculoListDoc", LNGGetText(1885, vbNullString)) Then Exit Function
  
  register.Table = csTListaDocumentoParametro
  register.UtilizaIdentity = True
  
  Dim IProperty As cIABMProperty
  For Each IProperty In m_ObjAbm.Properties
    
    register.fields.Clear
    
    With IProperty
      Select Case .Key
        Case K_FECHAINI
        
          If .HelpValueProcess <> vbNullString Then
            register.fields.Add2 cscLdpValor, .HelpValueProcess, csText
          Else
            register.fields.Add2 cscLdpValor, .Value, csText
          End If
          register.fields.Add2 cscLdpOrden, 10, csInteger
          register.fields.Add2 cscLdpId, K_FECHAINI, csInteger
          
        Case K_FECHAFIN
          
          If .HelpValueProcess <> vbNullString Then
            register.fields.Add2 cscLdpValor, .HelpValueProcess, csText
          Else
            register.fields.Add2 cscLdpValor, .Value, csText
          End If
          register.fields.Add2 cscLdpOrden, 20, csInteger
          register.fields.Add2 cscLdpId, K_FECHAFIN, csInteger
          
        Case K_PROV_ID
          register.fields.Add2 cscLdpValor, .HelpValueProcess, csText
          register.fields.Add2 cscLdpOrden, 30, csInteger
          register.fields.Add2 cscLdpId, K_PROV_ID, csInteger
          
        Case K_TITULO
          register.fields.Add2 cscLdpValor, .Value, csText
          register.fields.Add2 cscLdpOrden, 40, csInteger
          register.fields.Add2 cscLdpId, K_TITULO, csInteger
          
        Case K_VIA
          register.fields.Add2 cscLdpValor, .Value, csText
          register.fields.Add2 cscLdpOrden, 50, csInteger
          register.fields.Add2 cscLdpId, K_VIA, csInteger
          
        Case K_VIA_EMPRESA
          register.fields.Add2 cscLdpValor, .Value, csText
          register.fields.Add2 cscLdpOrden, 60, csInteger
          register.fields.Add2 cscLdpId, K_VIA_EMPRESA, csInteger
          
        Case K_FACTURA
          register.fields.Add2 cscLdpValor, .Value, csText
          register.fields.Add2 cscLdpOrden, 70, csInteger
          register.fields.Add2 cscLdpId, K_FACTURA, csInteger
          
        Case K_DESCRIP
          register.fields.Add2 cscLdpValor, .Value, csText
          register.fields.Add2 cscLdpOrden, 80, csInteger
          register.fields.Add2 cscLdpId, K_DESCRIP, csInteger
          
      End Select
  
      register.fields.Add2 cscUsId, m_Us_id, csId
      register.fields.Add2 cscPreID, csPreCpraListDespImpoCalc, csId
  
      register.fields.HaveLastUpdate = False
      register.fields.HaveWhoModify = False
      If Not gDB.Save(register, , "cIABMListDocClient_Save", "cDespachoImpCalculoListDoc", LNGGetText(1885, vbNullString)) Then Exit Function
                                                                                           'Error al grabar el Coeficiente
    End With
  Next
  If Not Load(m_Us_id) Then Exit Function
  
  cIABMListDocClient_Save = True
End Function

Private Function cIABMListDocClient_Terminate() As Boolean
  cIABMListDocClient_Terminate = True
End Function

Private Property Get cIABMListDocClient_Title() As String
  cIABMListDocClient_Title = c_strTitle
End Property

Private Function cIABMListDocClient_Validate() As Boolean
  cIABMListDocClient_Validate = True
End Function

'-------------------------------------------------------------------------------------
' Implementacion de cIEditGeneric
Private Function cIEditGenericListDoc_GridAdd(ByVal ClavePropiedad As Integer) As Boolean

End Function

Private Function cIEditGenericListDoc_GridEdit(ByVal ClavePropiedad As Integer) As Boolean

End Function

Private Function cIEditGenericListDoc_GridRemove(ByVal ClavePropiedad As Integer) As Boolean

End Function

Private Property Set cIEditGenericListDoc_ObjAbm(rhs As CSInterfacesABM.cIABMGenericListDoc)
  Set m_ObjAbm = rhs
End Property

Private Function cIEditGenericListDoc_ShowParams(ByVal Us_id As Long) As Boolean
  On Error GoTo ControlError
  
  If Us_id = csNO_ID Then Exit Function

  m_Us_id = Us_id
  
  If Not Load(Us_id) Then Exit Function
  
  If Not LoadCollection() Then Exit Function
  
  cIEditGenericListDoc_ShowParams = True
  Exit Function
ControlError:
  MngError Err, "cIEditGenericListDoc_ShowParams", C_Module, vbNullString
End Function

Private Property Set cIEditGenericListDoc_ObjList(rhs As Object)
  Set m_ObjList = rhs
End Property

Private Function cIEditGenericListDoc_PropertyChange(ByVal Clave As Integer) As Boolean

End Function

Private Function cIEditGenericListDoc_TabClick(ByVal Index As Integer) As Boolean

End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  Dim c As cIABMProperty
  Dim o As cIABMListItem
  Dim Value As String
  Dim bExists As Boolean
  
  m_ObjAbm.Properties.Clear
  
  Set c = m_ObjAbm.Properties.Add(Nothing, c_FechaIni)
  c.PropertyType = cspDate
  c.Name = LNGGetText(1203, vbNullString)   'Fecha desde
  c.Key = K_FECHAINI
  If LenB(m_FechaIniV) Then
    c.Value = m_FechaIniV
  Else
    c.Value = m_FechaIni
  End If
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, c_FechaFin)
  c.PropertyType = cspDate
  c.Name = LNGGetText(1204, vbNullString)   'Fecha hasta
  c.Key = K_FECHAFIN
  If LenB(m_FechaFinV) Then
    c.Value = m_FechaFinV
  Else
    c.Value = m_FechaFin
  End If
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscProvId)
  c.PropertyType = cspHelp
  c.Table = csProveedor
  c.Name = LNGGetText(1151, vbNullString)   'Proveedor
  c.Key = K_PROV_ID
  Value = m_proveedor
  If UCase(Left$(m_Prov_id, 1)) = KEY_NODO Then
    Value = GetNombreRama(csProveedor, Val(Mid(m_Prov_id, 2)), bExists)
    If Not bExists Then m_Prov_id = "0"
  End If
  c.Value = Value
  c.HelpId = Val(m_Prov_id)
  c.HelpValueProcess = m_Prov_id
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscDicTitulo)
  c.PropertyType = cspText
  c.Name = LNGGetText(1864, vbNullString)   'Título
  c.Size = 255
  c.Key = K_TITULO
  c.Value = m_Titulo
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscDicVia)
  c.PropertyType = cspText
  c.Name = LNGGetText(1865, vbNullString)   'Via
  c.Size = 255
  c.Key = K_VIA
  c.Value = m_Via
  

  Set c = m_ObjAbm.Properties.Add(Nothing, cscDicViaempresa)
  c.PropertyType = cspText
  c.Name = LNGGetText(1886, vbNullString)   'Vía Empresa
  c.Size = 255
  c.Key = K_VIA_EMPRESA
  c.Value = m_Viaempresa
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscDicFactura)
  c.PropertyType = cspText
  c.Name = LNGGetText(1866, vbNullString)   'Factura
  c.Size = 255
  c.Key = K_FACTURA
  c.Value = m_Factura
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscDicDescrip)
  c.PropertyType = cspText
  c.Name = LNGGetText(1861, vbNullString)   'Observaciones
  c.Size = 255
  c.Key = K_DESCRIP
  c.Value = m_Descrip
  
  pCreateMenu
  If Not m_ObjAbm.Show(Me, m_ObjList) Then Exit Function
  
  LoadCollection = True
End Function

Private Function Load(ByVal Us_id As Long) As Boolean
  Dim sqlstmt As String
  
  sqlstmt = "select * from ListaDocumentoParametro" & _
            " where us_id = " & Us_id & _
             " and pre_id = " & csPreCpraListDespImpoCalc & _
            " order by " & cscLdpOrden
  
  Dim rs As ADODB.Recordset
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "Load", "cDespachoImpCalculoListDoc") Then Exit Function
  
  If rs.EOF Then
    
    m_FechaIni = Date
    m_FechaFin = Date
    m_FechaIniV = vbNullString
    m_FechaFinV = vbNullString
    m_Prov_id = csNO_ID
    m_proveedor = vbNullString
    m_Titulo = vbNullString
    m_Via = vbNullString
    m_Viaempresa = vbNullString
    m_Factura = vbNullString
    m_Descrip = vbNullString

  Else
  
    rs.MoveLast
    rs.MoveFirst
    
    Dim strLoad As String
    
    strLoad = c_strLoad
    
    Dim i As Integer
    While Not rs.EOF
      Select Case gDB.ValField(rs.fields, cscLdpId)
        Case K_FECHAINI
          m_FechaIniV = gDB.ValField(rs.fields, cscLdpValor)
          m_FechaIni = IIf(IsDate(gDB.ValField(rs.fields, cscLdpValor)), gDB.ValField(rs.fields, cscLdpValor), Date)
        Case K_FECHAFIN
          m_FechaFinV = gDB.ValField(rs.fields, cscLdpValor)
          m_FechaFin = IIf(IsDate(gDB.ValField(rs.fields, cscLdpValor)), gDB.ValField(rs.fields, cscLdpValor), Date)
        Case K_PROV_ID
          m_Prov_id = gDB.ValField(rs.fields, cscLdpValor)
        Case K_TITULO
          m_Titulo = gDB.ValField(rs.fields, cscLdpValor)
        Case K_VIA
          m_Via = gDB.ValField(rs.fields, cscLdpValor)
        Case K_VIA_EMPRESA
          m_Viaempresa = gDB.ValField(rs.fields, cscLdpValor)
        Case K_FACTURA
          m_Factura = gDB.ValField(rs.fields, cscLdpValor)
        Case K_DESCRIP
          m_Descrip = gDB.ValField(rs.fields, cscLdpValor)
      
      End Select
      
      rs.MoveNext
    Wend
    
    Dim Data As String
    
    m_FechaFin = IIf(m_FechaFin <> csNoDate, m_FechaFin, Date)
    m_FechaIni = IIf(m_FechaIni <> csNoDate, m_FechaIni, Date)
    
    If UCase(Left$(m_Prov_id, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTProveedor, cscProvId, m_Prov_id, cscProvNombre, Data, C_LoadFunction, C_Module, strLoad) Then Exit Function
      m_proveedor = Data
    End If
    
  End If

  Load = True

End Function
' construccion - destruccion

Private Sub Class_Initialize()
  On Error GoTo ControlError
 
  Set m_Properties = New cABMDocProperties
  With m_Properties
    'Set .ImageList = fIcons.ilList
    .HaveDetail = True
    .StartRowText = 4
    
    With .Columns.Add(Nothing, "TypeTask")
      .Name = "TypeTask"
      .Caption = " "
      With .Icons.Add(Nothing)
      .FormulaType = csCondTNone
      .IconIndex = c_img_task
      End With
      .Width = 500
      .SortType = csSrtTIcon
    End With
    
    With .Columns.Add(Nothing, "Descripción")
      .Name = "Descripción"
      .FontName = "Tahoma"
      .FontSize = 8
      .ForeColor = vbBlue
    End With
  End With
  
  GoTo ExitProc
ControlError:
  MngError Err, "Class_Terminate", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
  On Error GoTo ControlError
  
  Set m_ObjAbm = Nothing
  Set m_ObjList = Nothing
  Set m_Properties = Nothing

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Terminate", C_Module, vbNullString
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

Private Sub pCreateMenu()
  On Error Resume Next
  
  If m_MenuLoaded Then Exit Sub
  
  m_MenuLoaded = True
  
  With m_ObjList
    Set .ObjClientMenu = Me
    .ClearMenu
    m_MenuShowInfoProv = .AddMenu(LNGGetText(1887, vbNullString))   'Ver Info del Proveedor
    m_MenuAddMensaje = .AddMenu(LNGGetText(1615, vbNullString))     'Agregar Nota
    m_MenuShowMensajes = .AddMenu(LNGGetText(1616, vbNullString))   'Ver Notas
  End With
End Sub

Private Function pGetProvId() As Long
  On Error Resume Next
  
  Dim DicId  As Long
  Dim ProvId As Long
  
  DicId = m_ObjList.Id
  gDB.GetData csTDespachoImpCalculo, cscDicId, DicId, cscProvId, ProvId
  
  pGetProvId = ProvId
End Function

Private Sub pShowMensajes()
  Dim sqlstmt As String
  Dim StId    As Long
  Dim rs      As ADODB.Recordset
  
  StId = m_ObjList.Id
  
  sqlstmt = "sp_ParteDiarioGetTitleForDoc " & csDespachoImpCalculo & "," & StId
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  If rs.EOF Then Exit Sub
  
  Dim infodoc As String
  Dim DoctId  As Long
  
  DoctId = csDespachoImpCalculo
  infodoc = gDB.ValField(rs.fields, "info_doc")
  
  sqlstmt = "sp_PartesDiarioGetForDoc " & gDB.UserId & "," & EmpId & "," & DoctId & "," & StId
  ShowNotes LNGGetText(1888, vbNullString, infodoc), sqlstmt
            'Notas sobre Cálculo de Despacho de Importación (1)
End Sub

Private Sub pAddMensaje()
  Dim Parte As Object
  Set Parte = CSKernelClient2.CreateObject("CSEnvio2.cParteDiario")
  
  Parte.AddParteToDoc csDespachoImpCalculo, m_ObjList.Id, False
End Sub


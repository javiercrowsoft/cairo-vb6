VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cCashFlowListDoc"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGenericListDoc
Implements CSInterfacesABM.cIABMListDocClient

'--------------------------------------------------------------------------------
' cCashFlowListDoc
' 06-11-2006

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
  ' constantes
  ' estructuras
  ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cCashFlowListDoc"

Private Const K_FECHAINI             As Integer = 4
Private Const K_FECHAFIN             As Integer = 5
Private Const K_TITULO               As Integer = 7
Private Const K_DESCRIP              As Integer = 11

Private Const c_FechaIni = "FechaIni"
Private Const c_FechaFin = "FechaFin"

Private Const c_img_task = 1

' pseudo-constantes
Private c_ErrorSave As String

' estructuras
' variables privadas
Private m_ObjAbm        As cIABMGenericListDoc
Private m_ObjList       As Object

Private m_Us_id       As Long

Private m_FechaIniV           As String
Private m_FechaFinV           As String

Private m_FechaIni           As Date
Private m_FechaFin           As Date

Private m_Titulo             As String
Private m_Descrip            As String

Private m_Properties         As cABMDocProperties

Private m_MenuLoaded        As Boolean

Private m_Title             As String

Private m_MenuShowMensajes  As Long
Private m_MenuAddMensaje    As Long

' propiedades publicas
' propiedades privadas
' funciones publicas
Public Function ProcessMenu(ByVal Index As Long)
  On Error GoTo ControlError

  Select Case Index
  
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
      
    Case K_TITULO
      m_Titulo = m_ObjAbm.Properties(cscCfNombre).Value
    
    Case K_DESCRIP
      m_Descrip = m_ObjAbm.Properties(cscCfDescrip).Value
  
  End Select
  
  cIABMListDocClient_PropertyChange = True
End Function

Private Function cIABMListDocClient_Refresh() As String
  Dim sqlstmt As String
  
  sqlstmt = "sp_lsdoc_CashFlows "
  
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
  
  sqlstmt = sqlstmt & gDB.sqlString(m_Titulo) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_Descrip)
  
  cIABMListDocClient_Refresh = sqlstmt
End Function

Private Function cIABMListDocClient_Save() As Boolean
  Dim register As cRegister
  Set register = New cRegister
  
  Dim sqlstmt As String
  sqlstmt = "delete ListaDocumentoParametro " & _
            " where pre_id = " & csPreTsrEditCashFlow & _
              " and us_id = " & m_Us_id
                                                                      
  If Not gDB.Execute(sqlstmt, "cIABMClient_Save", "cCashFlowListDoc", c_ErrorSave) Then Exit Function
  
  register.Table = csTListaDocumentoParametro
  register.UtilizaIdentity = True
  
  Dim IProperty As cIABMProperty
  For Each IProperty In m_ObjAbm.Properties
    
    register.Fields.Clear
    
    With IProperty
      Select Case .Key
        Case K_FECHAINI
        
          If .HelpValueProcess <> vbNullString Then
            register.Fields.Add2 cscLdpValor, .HelpValueProcess, csText
          Else
            register.Fields.Add2 cscLdpValor, .Value, csText
          End If
          register.Fields.Add2 cscLdpOrden, 10, csInteger
          register.Fields.Add2 cscLdpId, K_FECHAINI, csInteger
          
        Case K_FECHAFIN
          
          If .HelpValueProcess <> vbNullString Then
            register.Fields.Add2 cscLdpValor, .HelpValueProcess, csText
          Else
            register.Fields.Add2 cscLdpValor, .Value, csText
          End If
          register.Fields.Add2 cscLdpOrden, 20, csInteger
          register.Fields.Add2 cscLdpId, K_FECHAFIN, csInteger
          
        Case K_TITULO
          register.Fields.Add2 cscLdpValor, .Value, csText
          register.Fields.Add2 cscLdpOrden, 40, csInteger
          register.Fields.Add2 cscLdpId, K_TITULO, csInteger
          
        Case K_DESCRIP
          register.Fields.Add2 cscLdpValor, .Value, csText
          register.Fields.Add2 cscLdpOrden, 80, csInteger
          register.Fields.Add2 cscLdpId, K_DESCRIP, csInteger
          
      End Select
  
      register.Fields.Add2 cscUsId, m_Us_id, csId
      register.Fields.Add2 cscPreID, csPreTsrEditCashFlow, csId
  
      register.Fields.HaveLastUpdate = False
      register.Fields.HaveWhoModify = False
      If Not gDB.Save(register, , "cIABMListDocClient_Save", "cCashFlowListDoc", c_ErrorSave) Then Exit Function
    End With
  Next
  If Not Load(m_Us_id) Then Exit Function
  
  cIABMListDocClient_Save = True
End Function

Private Function cIABMListDocClient_Terminate() As Boolean
  cIABMListDocClient_Terminate = True
End Function

Private Property Get cIABMListDocClient_Title() As String
  cIABMListDocClient_Title = m_Title
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
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscCfNombre)
  c.PropertyType = cspText
  c.Name = LNGGetText(1864, vbNullString)   'Título
  c.Size = 255
  c.Key = K_TITULO
  c.Value = m_Titulo
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscCfDescrip)
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
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "select * from ListaDocumentoParametro " & _
            " where us_id = " & Us_id & _
              " and pre_id = " & csPreTsrEditCashFlow & _
            " order by " & cscLdpOrden
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "Load", "cCashFlowListDoc") Then Exit Function
  
  If rs.EOF Then
    
    m_FechaIni = Date
    m_FechaFin = Date
    m_FechaIniV = vbNullString
    m_FechaFinV = vbNullString
    m_Titulo = vbNullString
    m_Descrip = vbNullString

  Else
  
    rs.MoveLast
    rs.MoveFirst
    
    Dim strLoad As String
    
    strLoad = LNGGetText(2285, vbNullString) 'Error al grabar los parámetros de navegación de flujos de fondos
    
    Dim i As Integer
    While Not rs.EOF
      Select Case gDB.ValField(rs.Fields, cscLdpId)
        Case K_FECHAINI
          m_FechaIniV = gDB.ValField(rs.Fields, cscLdpValor)
          m_FechaIni = IIf(IsDate(gDB.ValField(rs.Fields, cscLdpValor)), gDB.ValField(rs.Fields, cscLdpValor), Date)
        Case K_FECHAFIN
          m_FechaFinV = gDB.ValField(rs.Fields, cscLdpValor)
          m_FechaFin = IIf(IsDate(gDB.ValField(rs.Fields, cscLdpValor)), gDB.ValField(rs.Fields, cscLdpValor), Date)
        Case K_TITULO
          m_Titulo = gDB.ValField(rs.Fields, cscLdpValor)
        Case K_DESCRIP
          m_Descrip = gDB.ValField(rs.Fields, cscLdpValor)
      
      End Select
      
      rs.MoveNext
    Wend
    
    Dim Data As String
    
    m_FechaFin = IIf(m_FechaFin <> csNoDate, m_FechaFin, Date)
    m_FechaIni = IIf(m_FechaIni <> csNoDate, m_FechaIni, Date)
    
  End If

  Load = True

End Function

' construccion - destruccion

Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  c_ErrorSave = LNGGetText(1885, vbNullString) 'Error al grabar el coeficiente
  m_Title = LNGGetText(2284, vbNullString) ' Flujos de Fondos
 
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
    m_MenuAddMensaje = .AddMenu(LNGGetText(1615, vbNullString))    'Agregar Nota
    m_MenuShowMensajes = .AddMenu(LNGGetText(1616, vbNullString))  'Ver Notas
  End With
End Sub

Private Sub pShowMensajes()
  Dim sqlstmt As String
  Dim CfId    As Long
  Dim rs      As ADODB.Recordset
  
  CfId = m_ObjList.id
  
  sqlstmt = "sp_ParteDiarioGetTitleForDoc " & csCashFlow & "," & CfId
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  If rs.EOF Then Exit Sub
  
  Dim infodoc As String
  Dim DoctId  As Long
  
  DoctId = csCashFlow
  infodoc = gDB.ValField(rs.Fields, "info_doc")
  
  sqlstmt = "sp_PartesDiarioGetForDoc " & gDB.UserId & "," & EmpId & "," & DoctId & "," & CfId
  ShowNotes LNGGetText(2088, vbNullString, infodoc), sqlstmt
            'Notas sobre Tareas  & infodoc
End Sub

Private Sub pAddMensaje()
  Dim Parte As Object
  Set Parte = CSKernelClient2.CreateObject("CSEnvio2.cParteDiario")
  
  Parte.AddParteToDoc csCashFlow, m_ObjList.id, False
End Sub

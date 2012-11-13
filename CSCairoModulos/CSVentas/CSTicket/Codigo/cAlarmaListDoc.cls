VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cAlarmaListDoc"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGenericListDoc
Implements CSInterfacesABM.cIABMListDocClient
'--------------------------------------------------------------------------------
' cAlarmaListDoc
' 02-07-03

'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cAlarmaListDoc"

Private Const K_PROYECTO                       As Integer = 4
Private Const K_CLIENTE                        As Integer = 11

' pseudo-constantes
Private c_ErrorSave As String

' estructuras
' variables privadas

Private m_Proyecto                       As String
Private m_Cliente                        As String
Private m_Proy_id                        As String
Private m_cli_id                         As String

Private m_Descrip                        As String
Private m_Titulo                         As String

'OJO HASTA ACA

Private m_ObjAbm        As cIABMGenericListDoc
Private m_ObjList       As Object

Private m_us_id         As Long

Private m_Properties    As cABMDocProperties

Private m_MenuLoaded        As Boolean

Private m_MenuShowMensajes  As Long
Private m_MenuAddMensaje    As Long
' Properties publicas
' Properties privadas
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

' Implementacion de cIABMClient

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

Private Function cIABMListDocClient_PropertyChange(ByVal key As Integer) As Boolean
  Dim iProp     As cIABMProperty
  
  Select Case key

    Case K_PROYECTO
      m_Proy_id = m_ObjAbm.Properties(cscProyId).HelpValueProcess

    Case K_CLIENTE
      m_cli_id = m_ObjAbm.Properties(cscCliId).HelpValueProcess

   End Select

   cIABMListDocClient_PropertyChange = True
End Function

Private Function cIABMListDocClient_Refresh() As String
  Dim sqlstmt As String

  sqlstmt = "sp_lsdoc_alarmas "

  sqlstmt = sqlstmt & gDB.UserId & ","
  
  sqlstmt = sqlstmt & gDB.sqlString(m_cli_id) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_Proy_id)

  cIABMListDocClient_Refresh = sqlstmt
End Function

Private Function cIABMListDocClient_Save() As Boolean
  Dim register As cRegister
  Set register = New cRegister

  Dim sqlstmt As String
  sqlstmt = "delete ListaDocumentoParametro" & _
            " where pre_id = " & csPreTickListAlarma & _
              " and us_id = " & m_us_id
                                                                    
  If Not gDB.Execute(sqlstmt, "cIABMClient_Save", C_Module, c_ErrorSave) Then Exit Function

  register.table = csTListaDocumentoParametro
  register.UtilizaIdentity = True

  Dim IProperty As cIABMProperty
  For Each IProperty In m_ObjAbm.Properties

    register.Fields.Clear

    With IProperty
      Select Case .key

        Case K_PROYECTO
          register.Fields.Add2 cscLdpValor, .HelpValueProcess, csText
          register.Fields.Add2 cscLdpOrden, 30, csInteger
          register.Fields.Add2 cscLdpId, K_PROYECTO, csInteger
        Case K_CLIENTE
          register.Fields.Add2 cscLdpValor, .HelpValueProcess, csText
          register.Fields.Add2 cscLdpOrden, 50, csInteger
          register.Fields.Add2 cscLdpId, K_CLIENTE, csInteger

      End Select
      register.Fields.Add2 cscUsId, m_us_id, csId
      register.Fields.Add2 cscPreID, csPreTickListAlarma, csId

      register.Fields.HaveLastUpdate = False
      register.Fields.HaveLastUpdate = False
      If Not gDB.Save(register, , "cIABMClient_Save", C_Module, c_ErrorSave) Then Exit Function
                                                                          
    End With
  Next
  If Not Load(m_us_id) Then Exit Function

  cIABMListDocClient_Save = True
End Function

Private Function cIABMListDocClient_Terminate() As Boolean
  cIABMListDocClient_Terminate = True
End Function

Private Property Get cIABMListDocClient_Title() As String
  cIABMListDocClient_Title = LNGGetText(1795, vbNullString)   'Tareas
End Property

Private Function cIABMListDocClient_Validate() As Boolean
  cIABMListDocClient_Validate = True
End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  Dim c As cIABMProperty
  Dim o As cIABMListItem
  Dim Value As String
  Dim bExists As Boolean

  m_ObjAbm.Properties.Clear

  Set c = m_ObjAbm.Properties.Add(Nothing, cscCliId)
  c.PropertyType = cspHelp
  c.table = csCliente
  c.Name = LNGGetText(1150, vbNullString)   'Cliente
  c.key = K_CLIENTE
  Value = m_Cliente
  If UCase(Left$(m_cli_id, 1)) = KEY_NODO Then
    Value = GetNombreRama(csCliente, Val(Mid(m_cli_id, 2)), bExists)
    If Not bExists Then m_cli_id = "0"
  End If
  c.Value = Value
  c.HelpId = Val(m_cli_id)
  c.HelpValueProcess = m_cli_id
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscProyId)
  c.PropertyType = cspHelp
  c.table = csProyecto
  c.Name = LNGGetText(1658, vbNullString)   'Proyecto
  c.key = K_PROYECTO
  Value = m_Proyecto
  If UCase(Left$(m_Proy_id, 1)) = KEY_NODO Then
    Value = GetNombreRama(csProyecto, Val(Mid(m_Proy_id, 2)), bExists)
    If Not bExists Then m_Proy_id = "0"
  End If
  c.Value = Value
  c.HelpId = Val(m_Proy_id)
  c.HelpValueProcess = m_Proy_id
  
  pCreateMenu
  If Not m_ObjAbm.Show(Me, m_ObjList) Then Exit Function

  LoadCollection = True
End Function

Private Function Load(ByVal Us_id As Long) As Boolean
  Dim sqlstmt As String

  sqlstmt = "select * from ListaDocumentoParametro" & _
            " where us_id = " & Us_id & _
              " and pre_id = " & csPreTickListAlarma & _
            " order by " & cscLdpOrden

  Dim rs As ADODB.Recordset

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If rs.EOF Then

    m_cli_id = csNO_ID
    m_Cliente = vbNullString
    m_Proy_id = csNO_ID
    m_Proyecto = vbNullString
  Else

    rs.MoveLast
    rs.MoveFirst

    Dim strLoad As String
    
    strLoad = LNGGetText(2303, vbNullString)
            'Error al cargar los parámetros de navegación de Alarma
    Dim i As Integer
    While Not rs.EOF

      Select Case gDB.ValField(rs.Fields, cscLdpId)

        Case K_PROYECTO
          m_Proy_id = gDB.ValField(rs.Fields, cscLdpValor)
        Case K_CLIENTE
          m_cli_id = gDB.ValField(rs.Fields, cscLdpValor)
      End Select

      rs.MoveNext
    Wend

    Dim Data As String

    If UCase(Left$(m_Proy_id, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTProyecto, cscProyId, Val(m_Proy_id), cscProyNombre, Data, C_LoadFunction, C_Module, strLoad) Then Exit Function
      m_Proyecto = Data
    End If
    
    If UCase(Left$(m_cli_id, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTCliente, cscCliId, Val(m_cli_id), cscCliNombre, Data, C_LoadFunction, C_Module, strLoad) Then Exit Function
      m_Cliente = Data
    End If

  End If

  Load = True

End Function

'-------------------------------------------------------------------------------------
' Implementacion de cIEditGeneric
Private Function cIEditGenericListDoc_GridAdd(ByVal ClavePropiedad As Integer) As Boolean

End Function

Private Function cIEditGenericListDoc_GridEdit(ByVal ClavePropiedad As Integer) As Boolean

End Function

Private Function cIEditGenericListDoc_GridRemove(ByVal ClavePropiedad As Integer) As Boolean

End Function

Private Property Set cIEditGenericListDoc_ObjABM(rhs As CSInterfacesABM.cIABMGenericListDoc)
  Set m_ObjAbm = rhs
End Property

Private Function cIEditGenericListDoc_ShowParams(ByVal Us_id As Long) As Boolean
  On Error GoTo ControlError
  
  If Us_id = csNO_ID Then Exit Function

  m_us_id = Us_id
  
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

' construccion - destruccion

Private Sub Class_Initialize()
  On Error GoTo ControlError
    
  c_ErrorSave = LNGGetText(2302, vbNullString)
              'Error al grabar los párametros de navegación de Alarma
    
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
      .Name = C_strDescrip
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

Private Sub pCreateMenu()
  On Error Resume Next
  
  If m_MenuLoaded Then Exit Sub
  
  m_MenuLoaded = True
  
  With m_ObjList
    Set .ObjClientMenu = Me
    .ClearMenu
    m_MenuAddMensaje = .AddMenu(LNGGetText(1615, vbNullString))   'Agregar Nota
    m_MenuShowMensajes = .AddMenu(LNGGetText(1616, vbNullString)) 'Ver Notas
  End With
End Sub

Private Sub pShowMensajes()
  Dim sqlstmt As String
  Dim AlId    As Long
  Dim rs      As ADODB.Recordset
  
  AlId = m_ObjList.Id
  
  sqlstmt = "sp_ParteDiarioGetTitleForDoc " & csAlarma & "," & AlId
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  If rs.EOF Then Exit Sub
  
  Dim infodoc As String
  Dim DoctId  As Long
  
  DoctId = csAlarma
  infodoc = gDB.ValField(rs.Fields, "info_doc")
  
  sqlstmt = "sp_PartesDiarioGetForDoc " & gDB.UserId & "," & EmpId & "," & DoctId & "," & AlId
  ShowNotes LNGGetText(1796, vbNullString, infodoc), sqlstmt
            'Notas sobre Alarmas
End Sub

Private Sub pAddMensaje()
  Dim Parte As Object
  Set Parte = CSKernelClient2.CreateObject("CSEnvio2.cParteDiario")
  
  Parte.AddParteToDoc csAlarma, m_ObjList.Id, False
End Sub


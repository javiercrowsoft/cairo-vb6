VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cCursoListDoc"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGenericListDoc
Implements CSInterfacesABM.cIABMListDocClient

'--------------------------------------------------------------------------------
' cCursoListDoc
' 28-06-04

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cCursoListDoc"

Private Const c_FechaIni = "FechaIni"
Private Const c_FechaFin = "FechaFin"
Private Const c_FechaNac = "FechaNac"

Private Const c_img_task = 1

Private Const K_FECHAINI                       As Integer = 1
Private Const K_FECHAFIN                       As Integer = 2
Private Const K_PROF_ID                        As Integer = 4
Private Const K_MAT_ID                         As Integer = 5
Private Const K_ALUM_ID                        As Integer = 6

' Seudo - Variables
Private c_strTitle    As String '= "Cursos"

' estructuras
' variables privadas
Private m_FechaIniV                      As String
Private m_FechaFinV                      As String

Private m_FechaIni                       As Date
Private m_FechaFin                       As Date
Private m_prof_id                        As String
Private m_Profesor                       As String
Private m_mat_id                         As String
Private m_Materia                        As String
Private m_alum_id                        As String
Private m_Alumno                         As String

'OJO HASTA ACA

Private m_ObjAbm            As cIABMGenericListDoc
Private m_ObjList           As Object
Private m_Us_id             As Long
Private m_Properties        As cABMDocProperties

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

' funciones privadas

Private Function LoadCollection() As Boolean
  Dim c As cIABMProperty
  Dim o As cIABMListItem
  Dim Value As String
  Dim bExists As Boolean

  m_ObjAbm.Properties.Clear

  Set c = m_ObjAbm.Properties.Add(Nothing, c_FechaIni)
  c.PropertyType = cspDate
  c.Name = LNGGetText(1203, vbNullString) 'Fecha desde
  c.Key = K_FECHAINI
  If LenB(m_FechaIniV) Then
    c.Value = m_FechaIniV
  Else
    c.Value = m_FechaIni
  End If
  

  Set c = m_ObjAbm.Properties.Add(Nothing, c_FechaFin)
  c.PropertyType = cspDate
  c.Name = LNGGetText(1204, vbNullString) 'Fecha hasta
  c.Key = K_FECHAFIN
  If LenB(m_FechaFinV) Then
    c.Value = m_FechaFinV
  Else
    c.Value = m_FechaFin
  End If
    
  Set c = m_ObjAbm.Properties.Add(Nothing, cscProfId)
  c.PropertyType = cspHelp
  c.Table = csProfesor
  c.Name = LNGGetText(4682, vbNullString) 'Profesor
  c.Key = K_PROF_ID
  Value = m_Profesor
  If UCase(Left$(m_prof_id, 1)) = KEY_NODO Then
    Value = GetNombreRama(csProfesor, Val(Mid(m_prof_id, 2)), bExists)
    If Not bExists Then m_prof_id = "0"
  End If
  c.Value = Value
  c.HelpId = Val(m_prof_id)
  c.HelpValueProcess = m_prof_id
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscMatId)
  c.PropertyType = cspHelp
  c.Table = csMateria
  c.Name = LNGGetText(4688, vbNullString) 'Materia Cursada
  c.Key = K_MAT_ID
  Value = m_Materia
  If UCase(Left$(m_mat_id, 1)) = KEY_NODO Then
    Value = GetNombreRama(csMateria, Val(Mid(m_mat_id, 2)), bExists)
    If Not bExists Then m_mat_id = "0"
  End If
  c.Value = Value
  c.HelpId = Val(m_mat_id)
  c.HelpValueProcess = m_mat_id
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscAlumId)
  c.PropertyType = cspHelp
  c.Table = csAlumno
  c.Name = LNGGetText(4692, vbNullString) 'Alumno
  c.Key = K_ALUM_ID
  Value = m_Alumno
  If UCase(Left$(m_alum_id, 1)) = KEY_NODO Then
    Value = GetNombreRama(csAlumno, Val(Mid(m_alum_id, 2)), bExists)
    If Not bExists Then m_alum_id = "0"
  End If
  c.Value = Value
  c.HelpId = Val(m_alum_id)
  c.HelpValueProcess = m_alum_id
  
  pCreateMenu
  If Not m_ObjAbm.Show(Me, m_ObjList) Then Exit Function

  LoadCollection = True
End Function

Private Function Load(ByVal us_id As Long) As Boolean
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  sqlstmt = "select * from ListaDocumentoParametro" & _
            " where us_id = " & us_id & _
              " and pre_id = " & csPreEListCurso & _
            " order by " & cscLdpOrden

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If rs.EOF Then
    
    m_FechaIni = Date
    m_FechaFin = Date
    m_FechaIniV = vbNullString
    m_FechaFinV = vbNullString
    m_prof_id = csNO_ID
    m_Profesor = vbNullString
    m_mat_id = csNO_ID
    m_Materia = vbNullString
    m_alum_id = csNO_ID
    m_Alumno = vbNullString
    
  Else

    rs.MoveLast
    rs.MoveFirst

    Dim i As Integer
    While Not rs.EOF

      Select Case gDB.ValField(rs.fields, cscLdpId)

        Case K_FECHAINI
          m_FechaIniV = gDB.ValField(rs.fields, cscLdpValor)
          m_FechaIni = IIf(IsDate(gDB.ValField(rs.fields, cscLdpValor)), gDB.ValField(rs.fields, cscLdpValor), Date)
        Case K_FECHAFIN
          m_FechaFinV = gDB.ValField(rs.fields, cscLdpValor)
          m_FechaFin = IIf(IsDate(gDB.ValField(rs.fields, cscLdpValor)), gDB.ValField(rs.fields, cscLdpValor), Date)
        Case K_PROF_ID
          m_prof_id = gDB.ValField(rs.fields, cscLdpValor)
        Case K_MAT_ID
          m_mat_id = gDB.ValField(rs.fields, cscLdpValor)
        Case K_ALUM_ID
          m_alum_id = gDB.ValField(rs.fields, cscLdpValor)
      End Select

      rs.MoveNext
    Wend

    Dim Data As String
    Dim strLoad As String
    
    strLoad = LNGGetText(4685, vbNullString)
              'Error al cargar los parámetros de navegación de Cursos
    
    m_FechaIni = IIf(m_FechaIni <> csNoDate, m_FechaIni, Date)
    m_FechaFin = IIf(m_FechaFin <> csNoDate, m_FechaFin, Date)

    Dim prs_id As Long
    Dim prs_apellido As String

    If UCase(Left$(m_prof_id, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTProfesor, cscProfId, Val(m_prof_id), cscPrsId, Data, C_LoadFunction, C_Module, strLoad) Then Exit Function
      prs_id = Val(Data)
      If Not gDB.GetData(csTPersona, cscPrsId, prs_id, cscPrsApellido, prs_apellido, C_LoadFunction, C_Module, strLoad) Then Exit Function
      If Not gDB.GetData(csTPersona, cscPrsId, prs_id, cscPrsNombre, Data, C_LoadFunction, C_Module, strLoad) Then Exit Function
      m_Profesor = prs_apellido
      If LenB(prs_apellido) Then
        m_Profesor = m_Profesor & ", " & Data
      Else
        m_Profesor = Data
      End If
    End If
    
    If UCase(Left$(m_alum_id, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTAlumno, cscAlumId, Val(m_alum_id), cscPrsId, Data, C_LoadFunction, C_Module, strLoad) Then Exit Function
      prs_id = Val(Data)
      If Not gDB.GetData(csTPersona, cscPrsId, prs_id, cscPrsApellido, prs_apellido, C_LoadFunction, C_Module, strLoad) Then Exit Function
      If Not gDB.GetData(csTPersona, cscPrsId, prs_id, cscPrsNombre, Data, C_LoadFunction, C_Module, strLoad) Then Exit Function
      m_Alumno = prs_apellido
      If LenB(prs_apellido) Then
        m_Alumno = m_Alumno & ", " & Data
      Else
        m_Alumno = Data
      End If
    End If
    
    If UCase(Left$(m_mat_id, 1)) <> KEY_NODO Then
      If Not gDB.GetData(csTMateria, cscMatId, Val(m_mat_id), cscMatNombre, Data, C_LoadFunction, C_Module, strLoad) Then Exit Function
      m_Materia = Data
    End If
    
  End If

  Load = True
End Function
' construccion - destruccion

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
  
      If LenB(iProp.HelpValueProcess) Then
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
      
      If LenB(iProp.HelpValueProcess) Then
        m_FechaFinV = iProp.HelpValueProcess
        m_FechaFin = VDGetDateByName(m_FechaFinV)
      ElseIf IsDate(iProp.Value) Then
        m_FechaFinV = vbNullString
        m_FechaFin = iProp.Value
      Else
        m_FechaFinV = vbNullString
        iProp.Value = m_FechaFin
      End If

    Case K_PROF_ID
      With m_ObjAbm.Properties(cscProfId)
        m_Profesor = .Value
        m_prof_id = .HelpValueProcess
      End With

    Case K_MAT_ID
      With m_ObjAbm.Properties(cscMatId)
        m_Materia = .Value
        m_mat_id = .HelpValueProcess
      End With
      
    Case K_ALUM_ID
      With m_ObjAbm.Properties(cscAlumId)
        m_Alumno = .Value
        m_alum_id = .HelpValueProcess
      End With
      
  End Select

  cIABMListDocClient_PropertyChange = True
End Function

Private Function cIABMListDocClient_Refresh() As String
  Dim sqlstmt As String

  sqlstmt = "sp_lsdoc_Cursos "

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

  sqlstmt = sqlstmt & gDB.sqlString(m_prof_id) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_mat_id) & ","
  sqlstmt = sqlstmt & gDB.sqlString(m_alum_id)

  cIABMListDocClient_Refresh = sqlstmt
End Function

Private Function cIABMListDocClient_Save() As Boolean

  Dim strError As String
  
  strError = LNGGetText(4686, vbNullString)
          'Error al grabar los párametros de navegación de Cursos
          
  Dim register As cRegister
  Set register = New cRegister

  Dim sqlstmt As String
  
  sqlstmt = "delete ListaDocumentoParametro " & _
            " where pre_id = " & csPreEListCurso & _
              " and us_id = " & m_Us_id

  If Not gDB.Execute(sqlstmt, "cIABMClient_Save", C_Module, strError) Then Exit Function

  register.Table = csTListaDocumentoParametro
  register.UtilizaIdentity = True

  Dim IProperty As cIABMProperty
  For Each IProperty In m_ObjAbm.Properties

    register.fields.Clear

    With IProperty
      Select Case .Key

        Case K_FECHAINI
          
          If LenB(.HelpValueProcess) Then
            register.fields.Add2 cscLdpValor, .HelpValueProcess, csText
          Else
            register.fields.Add2 cscLdpValor, .Value, csText
          End If
          
          register.fields.Add2 cscLdpOrden, 10, csInteger
          register.fields.Add2 cscLdpId, K_FECHAINI, csInteger

        Case K_FECHAFIN

          If LenB(.HelpValueProcess) Then
            register.fields.Add2 cscLdpValor, .HelpValueProcess, csText
          Else
            register.fields.Add2 cscLdpValor, .Value, csText
          End If

          register.fields.Add2 cscLdpOrden, 20, csInteger
          register.fields.Add2 cscLdpId, K_FECHAFIN, csInteger

        Case K_PROF_ID
          register.fields.Add2 cscLdpValor, .HelpValueProcess, csText
          register.fields.Add2 cscLdpOrden, 40, csInteger
          register.fields.Add2 cscLdpId, K_PROF_ID, csInteger
        
        Case K_MAT_ID
          register.fields.Add2 cscLdpValor, .HelpValueProcess, csText
          register.fields.Add2 cscLdpOrden, 50, csInteger
          register.fields.Add2 cscLdpId, K_MAT_ID, csInteger
                        
        Case K_ALUM_ID
          register.fields.Add2 cscLdpValor, .HelpValueProcess, csText
          register.fields.Add2 cscLdpOrden, 60, csInteger
          register.fields.Add2 cscLdpId, K_ALUM_ID, csInteger
                        
      End Select
      
      register.fields.Add2 cscUsId, m_Us_id, csId
      register.fields.Add2 cscPreID, csPreEListCurso, csId

      register.fields.HaveLastUpdate = False
      register.fields.HaveWhoModify = False
      
      If Not gDB.Save(register, , "cIABMClient_Save", C_Module, strError) Then Exit Function
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

Private Function cIEditGenericListDoc_GridAdd(ByVal KeyProperty As Integer) As Boolean

End Function

Private Function cIEditGenericListDoc_GridEdit(ByVal KeyProperty As Integer) As Boolean

End Function

Private Function cIEditGenericListDoc_GridRemove(ByVal KeyProperty As Integer) As Boolean

End Function

Private Property Set cIEditGenericListDoc_ObjABM(rhs As CSInterfacesABM.cIABMGenericListDoc)
  Set m_ObjAbm = rhs
End Property

Private Property Set cIEditGenericListDoc_ObjList(rhs As Object)
  Set m_ObjList = rhs
End Property

Private Function cIEditGenericListDoc_PropertyChange(ByVal Key As Integer) As Boolean
End Function

Private Function cIEditGenericListDoc_ShowParams(ByVal us_id As Long) As Boolean
  On Error GoTo ControlError
  
  If us_id = csNO_ID Then Exit Function

  m_Us_id = us_id
  
  If Not Load(us_id) Then Exit Function
  
  If Not LoadCollection() Then Exit Function
  
  cIEditGenericListDoc_ShowParams = True
  Exit Function
ControlError:
  MngError Err, "cIEditGenericListDoc_ShowParams", C_Module, vbNullString
End Function

Private Function cIEditGenericListDoc_TabClick(ByVal Index As Integer) As Boolean

End Function

Private Sub Class_Initialize()
  On Error GoTo ControlError
 
  c_strTitle = LNGGetText(4680, vbNullString)   'Cursos
 
  Set m_Properties = New cABMDocProperties
  With m_Properties
    'Set .ImageList = fResource.ilList
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
    m_MenuAddMensaje = .AddMenu(LNGGetText(1615, vbNullString))       'Agregar Nota
    m_MenuShowMensajes = .AddMenu(LNGGetText(1616, vbNullString))     'Ver Notas
  End With
End Sub

Private Sub pShowMensajes()
  Dim sqlstmt As String
  Dim CurId    As Long
  Dim rs      As ADODB.Recordset
  
  CurId = m_ObjList.Id
  
  sqlstmt = "sp_ParteDiarioGetTitleForDoc " & cscurso & "," & CurId
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  If rs.EOF Then Exit Sub
  
  Dim infodoc As String
  Dim DoctId  As Long
  
  DoctId = gDB.ValField(rs.fields, cscDoctId)
  infodoc = gDB.ValField(rs.fields, "info_doc")
  
  sqlstmt = "sp_PartesDiarioGetForDoc " & gDB.UserId & "," & EmpId & "," & DoctId & "," & CurId
  ShowNotes LNGGetText(4687, vbNullString, infodoc), sqlstmt
            'Notas sobre Cursos & infodoc
End Sub

Private Sub pAddMensaje()
  Dim Parte As Object
  Set Parte = CSKernelClient2.CreateObject("CSEnvio2.cParteDiario")
  
  Parte.AddParteToDoc cscurso, m_ObjList.Id, False
End Sub

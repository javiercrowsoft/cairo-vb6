VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cReporte"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGeneric
Implements CSInterfacesABM.cIABMClient
Implements CSInterfacesABM.cIWizardClient
Implements CSInterfacesABM.cIABMClientGrid
Implements CSInterfacesABM.cIEditGenericListDoc
Implements CSInterfacesABM.cIABMListDocClient

'--------------------------------------------------------------------------------
' cReport
' 04-10-03

'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cReporte"

Private Const C_Params = "Parametros"

Private Const c_GrupoUsuarioConfig = "Usuario-Config"

' Usar el tamaño de papel que reporta la impresora
Private Const c_UsePrinterSize = "Usar el Tamaño de Papel que Reporta la Impresora"

Private Const KEY_NODO = "N"

Private Const K_NOMBRE                         As Integer = 1
Private Const K_DESCRIP                        As Integer = 2
Private Const K_INF_ID                         As Integer = 3
Private Const K_US_ID                          As Integer = 4
Private Const K_ACTIVO                         As Integer = 5
Private Const K_PARAMETROS                     As Integer = 11

' Wizard
Private Const c_StepWelcome            As Integer = 1
Private Const c_StepShowReport         As Integer = 2
Private Const c_StepShowParameters     As Integer = 4
Private Const c_StepShowSave           As Integer = 5

Private Const c_Wiz_Key_SaveTitle = "SAVET"
Private Const c_Wiz_Key_Save = "SAVE"
Private Const c_Wiz_Key_Nombre = "NAME"
Private Const c_Wiz_Key_Descrip = "DESCRIP"
Private Const c_Wiz_Key_Parameters = "PARAMS"
Private Const c_Wiz_Key_Informe = "INFORME"

Private Const c_WizardTitle = "Asistente de Nuevos Reportes"

Private Const KI_INFP_ID                        As Integer = 1
Private Const KI_NOMBRE                         As Integer = 2
Private Const KI_DEFAULT                        As Integer = 5
Private Const KI_VISIBLE                        As Integer = 6
Private Const KI_RPTP_ID                        As Integer = 7

' estructuras
' Seudo - Variables
Private c_ErrorSave                    As String

' variables privadas
Private m_Id                           As Long
Private m_Nombre                       As String
Private m_Descrip                      As String
Private m_Inf_id                       As Long
Private m_Informe                      As String
Private m_Us_id                        As Long
Private m_Usuario                      As String
Private m_Modificado                   As Date
Private m_Creado                       As Date
Private m_Modifico                     As Long
Private m_Activo                       As Boolean

Private m_bIsProcess                   As Boolean

'OJO HASTA ACA

Private m_Editing           As Boolean

Private m_ObjAbm            As cIABMGeneric
Private m_ObjAbmParams      As cIABMGenericListDoc
Private m_ObjTree           As Object
Private m_ObjList           As Object


Private m_IsNew             As Boolean

Private m_BranchId          As Long
Private m_TreeId            As Long
Private m_Copy              As Boolean

' Wizard
Private m_ObjWizard               As cIWizardGeneric

Private m_WizardProcessing        As Boolean
Private m_WizardCancel            As Boolean

'Private m_Resource                As fResource

' Parametros
Private m_Properties         As cABMDocProperties
Private m_Parametros         As cInformeParametros ' Esto no es un error, uso informeParametro
                                                   ' por que en reporteparametro solo tengo
                                                   ' el valor y si es visible
                                                   
' Preview
Private m_Path                          As String
Private m_ConnectionTimeout             As Long
Private m_CommandTimeout                As Long
                                                   
Private WithEvents m_Report       As cReport
Attribute m_Report.VB_VarHelpID = -1
Private WithEvents m_fProgress    As fProgress
Attribute m_fProgress.VB_VarHelpID = -1
Private m_CancelPrinting          As Boolean
                                                   
Private m_bUsePrinterSizeLoaded   As Boolean
Private m_bUsePrinterSize         As Boolean
                                                   
' eventos
Public Event RefreshDesktop()

' Properties publicas
Public Property Get Id() As Long
  Id = m_Id
End Property

Public Property Let Id(ByVal rhs As Long)
  m_Id = rhs
End Property

Public Property Get Nombre() As String
  Nombre = m_Nombre
End Property

Public Property Let Nombre(ByVal rhs As String)
  m_Nombre = rhs
End Property

Public Property Get Descrip() As String
  Descrip = m_Descrip
End Property

Public Property Let Descrip(ByVal rhs As String)
  m_Descrip = rhs
End Property

Public Property Get inf_id() As Long
  inf_id = m_Inf_id
End Property

Public Property Let inf_id(ByVal rhs As Long)
  m_Inf_id = rhs
End Property

Public Property Get Informe() As String
  Informe = m_Informe
End Property

Public Property Let Informe(ByVal rhs As String)
  m_Informe = rhs
End Property

Public Property Get us_id() As Long
  us_id = m_Us_id
End Property

Public Property Let us_id(ByVal rhs As Long)
  m_Us_id = rhs
End Property

Public Property Get Usuario() As String
  Usuario = m_Usuario
End Property

Public Property Let Usuario(ByVal rhs As String)
  m_Usuario = rhs
End Property

Public Property Get Modificado() As Date
  Modificado = m_Modificado
End Property

Public Property Let Modificado(ByVal rhs As Date)
  m_Modificado = rhs
End Property

Public Property Get Creado() As Date
  Creado = m_Creado
End Property

Public Property Let Creado(ByVal rhs As Date)
  m_Creado = rhs
End Property

Public Property Get Modifico() As Long
  Modifico = m_Modifico
End Property

Public Property Let Modifico(ByVal rhs As Long)
  m_Modifico = rhs
End Property

Public Property Get Activo() As Boolean
  Activo = m_Activo
End Property

Public Property Let Activo(ByVal rhs As Boolean)
  m_Activo = rhs
End Property

Public Property Get Path() As String
   Path = m_Path
End Property

Public Property Let Path(ByVal rhs As String)
   m_Path = rhs
End Property

Public Property Get ConnectionTimeOut() As Long
   ConnectionTimeOut = m_ConnectionTimeout
End Property

Public Property Let ConnectionTimeOut(ByVal rhs As Long)
   m_ConnectionTimeout = rhs
End Property

Public Property Get CommandTimeout() As Long
   CommandTimeout = m_CommandTimeout
End Property

Public Property Let CommandTimeout(ByVal rhs As Long)
   m_CommandTimeout = rhs
End Property

Public Property Get Params() As cInformeParametros
  Set Params = m_Parametros
End Property

Public Property Let IsProcess(ByVal rhs As Boolean)
  m_bIsProcess = rhs
End Property

Public Property Get IsProcess() As Boolean
  IsProcess = m_bIsProcess
End Property

Public Property Get Rpt() As cReport
  Set Rpt = m_Report
End Property

' Properties privadas
' funciones publicas
Public Function LaunchGrid() As Boolean

  Dim c_OpenRpt As String
  
  c_OpenRpt = LNGGetText(2888, vbNullString) 'Abrir Reporte
  
  Dim sqlstmt As String
  Dim Grid    As CSOAPI2.cGridManager
  Dim fPrev   As fPreviewGrid
  
  Dim Mouse As cMouseWait
  Set Mouse = New cMouseWait
  
  m_ObjAbmParams.Refresh
  
  Dim Informe As cInforme
  Set Informe = New cInforme
  
  If Not Informe.Load(m_Inf_id) Then
    MsgWarning LNGGetText(2950, vbNullString, m_Nombre), c_OpenRpt
               'No se pudo cargar el informe;; & m_Nombre & ;;Comuníquese con el Administrador de Cairo.
    Exit Function
  End If
  
  Set fPrev = New fPreviewGrid
  Set Grid = New cGridManager

  fPrev.RptPath = m_Path
  fPrev.inf_codigo = Informe.Codigo
  pSetParamsInfPreviewGrid fPrev
  
  sqlstmt = "[" & Informe.Storedprocedure & "] " & pGetSqlstmt()

  Grid.SetPropertys fPrev.grItems

  ' Ojo a partir de aqui no se puede salir por
  ' EXIT FUNCTION, ya que se modifico el timeout
  ' y se debe salir por ExitProc
  '
  On Error GoTo ControlError
  Dim oldCommandTimeOut As Long
  
  oldCommandTimeOut = gDB.CommandTimeout
  If m_CommandTimeout > 0 Then
    gDB.CommandTimeout = m_CommandTimeout
  End If
  
  If m_bIsProcess Then
    gDB.CommandTimeout = 0 ' Hacemos que no tenga timeout para procesos
  End If
  
  fPrev.LaunchGrid Grid, _
                   sqlstmt, _
                   m_Id, _
                   Informe.Reporte, _
                   GetValidPath(m_Path), _
                   m_CommandTimeout, _
                   Me.Nombre, _
                   pGetParamsDescrip()
  
  fPrev.Caption = "Grilla - " & m_Nombre
  
  fPrev.Show

  GoTo ExitProc
ControlError:
  MngError Err, "LaunchGrid", C_Module, "SP: " & sqlstmt
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
  gDB.CommandTimeout = oldCommandTimeOut
End Function

Public Function Launch(ByVal Action As csRptLaunchAction) As Boolean
  Launch = LaunchEx(Action, Nothing, False)
End Function

Public Function LaunchEx(ByVal Action As csRptLaunchAction, _
                         ByRef oLaunchInfo As cReportLaunchInfo, _
                         ByVal IsForWeb As Boolean) As Boolean
                         
  On Error GoTo ControlError

  Dim fPrev       As fPreview
  Dim Rpt         As cReport
  Dim RptPrint    As cReportPrint
  
  Dim Mouse As cMouse
  Set Mouse = New cMouse
  
  Mouse.MouseSet vbArrowHourglass
  
  If Not IsForWeb Then m_ObjAbmParams.Refresh
  
  Dim c_OpenRpt As String
  
  c_OpenRpt = LNGGetText(2888, vbNullString) 'Abrir Reporte
  
  Set Rpt = New cReport
  
  Set m_Report = Rpt
  
  Rpt.IsForWeb = IsForWeb
  
  If Not IsForWeb Then
    Set fPrev = New fPreview
  End If
  
  If oLaunchInfo Is Nothing Then
    If Not Rpt.Init(New cReportLaunchInfo) Then GoTo ExitProc
  Else
    If Not Rpt.Init(oLaunchInfo) Then GoTo ExitProc
  End If
  
  'Set RptPrint = New CSReportPaint2.cReportPrint
  Set RptPrint = New cReportPrint
  Set Rpt.LaunchInfo.ObjPaint = RptPrint
  
  ' Deben apuntar al mismo objeto o sino
  ' no se toman las modificaciones que hace
  ' el usuario al seleccionar la impresora
  '
  Set Rpt.PaperInfo = Rpt.LaunchInfo.Printer.PaperInfo
    
  ' Me guardo la defincion de PaperInfo que
  ' sale de la impresora default
  '
  Dim PaperInfo As cReportPaperInfo
  Set PaperInfo = New cReportPaperInfo
  PaperInfo.PaperSize = Rpt.PaperInfo.PaperSize
  PaperInfo.Orientation = Rpt.PaperInfo.Orientation
  PaperInfo.Height = Rpt.PaperInfo.Height
  '
  '-----------------------------------------------------
    
  If Not IsForWeb Then
    Set RptPrint.PreviewControl = fPrev.rptMain
  End If
  
  Dim Informe As cInforme
  Set Informe = New cInforme
  
  If Not Informe.Load(m_Inf_id) Then
    MsgWarning LNGGetText(2950, vbNullString, m_Nombre), c_OpenRpt
              'No se pudo cargar el informe;; & m_Nombre & ;;Comuniquese con el administrador del sistema.
    GoTo ExitProc
  End If
  
  If Informe.Reporte = vbNullString Then
    MsgInfo LNGGetText(2745, vbNullString)
    'Este reporte no posee presentación en Vista Previa o por impresora.;;Sólo puede consultarlo por grilla.
    GoTo ExitProc
  End If
  
  Dim rptFile As String
  rptFile = GetValidPath(m_Path) & Informe.Reporte
  
  Dim FileEx As CSKernelFile.cFileEx
  Set FileEx = New CSKernelFile.cFileEx
  
  If Not FileEx.FileExists(rptFile) Then
    MsgWarning LNGGetText(2889, vbNullString, rptFile), c_OpenRpt
              'El archivo;; & rptFile & ;;no existe.;;Verifique la ubicación de los reportes.
    GoTo ExitProc
  End If
  
  If Not Rpt.LoadSilent(rptFile) Then
    MsgWarning LNGGetText(2469, vbNullString, rptFile, CSKernelClient2.LastErrorDescription), c_OpenRpt
              'No se pudo cargar el reporte  & rptFile & ;( & CSKernelClient2.LastErrorDescription & ")", c_OpenRpt
    GoTo ExitProc
  End If
  
  Dim strConnect As String
  
  If IsForWeb Then
    strConnect = gDB.OriginalStrConnect
  Else
    strConnect = gDB.strConnect
  End If
  
  Rpt.Connect.strConnect = strConnect
  
  Dim ConnectAux As cReportConnect
  For Each ConnectAux In Rpt.ConnectsAux
    ConnectAux.strConnect = strConnect
    pSetParamEmpIdInLogos ConnectAux
  Next
  
  pLoadUsePrinterSize
  
  If Not IsForWeb And m_bUsePrinterSize Then
    '
    ' Vamos a tomar el tamaño del papel desde la
    ' impresora si esto trae problemas lo vamos
    ' a parametrizar por usuario por ahora lo usamos
    ' asi :)
    '
    If Rpt.PaperInfo.PaperSize <> PaperInfo.PaperSize Then
      
      Rpt.PaperInfo.PaperSize = PaperInfo.PaperSize
      
      Dim offset As Single
      offset = PaperInfo.Height - Rpt.PaperInfo.Height
      
      Dim sc As cReportSection
      For Each sc In Rpt.Footers
        sc.Aspect.Top = sc.Aspect.Top + offset
        Dim scln As cReportSectionLine
        For Each scln In sc.SectionLines
          scln.Aspect.Top = scln.Aspect.Top + offset
          Dim Ctrl As cReportControl
          For Each Ctrl In scln.Controls
            Ctrl.Label.Aspect.Top = Ctrl.Label.Aspect.Top + offset
          Next
        Next
      Next
    End If
  End If
  
  With Rpt.LaunchInfo
    With .Printer.PaperInfo
      .PaperSize = Rpt.PaperInfo.PaperSize
      .Orientation = Rpt.PaperInfo.Orientation
    End With
  
    .Action = Action
    If IsForWeb Then
      With .Printer.PaperInfo
        .PaperSize = Rpt.PaperInfo.PaperSize
        .Orientation = Rpt.PaperInfo.Orientation
        .CustomHeight = Rpt.PaperInfo.CustomHeight
        .CustomWidth = Rpt.PaperInfo.CustomWidth
        .PagesToPrint = "1-9999"
      End With
      .Copies = 1
      .Action = csRptLaunchPrinter
      .ShowPrintersDialog = False
    Else
      .ShowPrintersDialog = True
    End If
  End With
  
  Rpt.DescripUser = m_Nombre
  Rpt.ExportEmailAddress = pGetEmail()
  
  Dim rptParamCount As Integer
  rptParamCount = Rpt.Connect.Parameters.Count - 1
  If rptParamCount <> m_Parametros.Count Then
    MsgWarning LNGGetText(2951, vbNullString, rptParamCount, m_Parametros.Count)
              'El reporte posee " & rptParamCount & " parametros y la definicion indica " & m_Parametros.Count & ";;Debe solicitar a sistemas que corrija este error para poder ejecutar el reporte.
    GoTo ExitProc
  End If
  
  pSetParams Rpt
  pShowParams Rpt
  pSetPoweredBy Rpt
  
  If m_CommandTimeout > 0 Then Rpt.Connect.CommandTimeout = m_CommandTimeout
  If m_ConnectionTimeout > 0 Then Rpt.Connect.ConnectionTimeOut = m_ConnectionTimeout
  
  Rpt.LaunchInfo.InternalPreview = True
  
  If Not IsForWeb Then
    ShowProgressDlg
  End If
  
  LaunchEx = Rpt.Launch()
  
  If Not IsForWeb Then
    Set fPrev.RptPrint = RptPrint
    fPrev.Caption = "Vista Previa - " & m_Nombre
  End If

  GoTo ExitProc
ControlError:
  MngError Err, "LaunchEx", C_Module, vbNullString

ExitProc:
  Set m_Report = Nothing
  CloseProgressDlg
End Function

Private Sub pSetParamEmpIdInLogos(ByRef Connect As cReportConnect)
  Dim dts As String
  Dim p   As cParameter
  
  dts = LCase(Connect.DataSource)
  If dts = "sp_rptgetlogosgrande" Or dts = "sp_rptgetlogoschico" Then

    If Connect.Parameters.Count = 0 Then
      
      Set p = Connect.Parameters.Add(Nothing)
      p.Name = "@@emp_id"
      p.TypeColumn = csTDInteger
    
    Else
      Set p = Connect.Parameters.Item(1)
    End If
    
    p.Value = EmpId

  End If
End Sub

Private Function pGetSqlstmt() As String
  Dim iProp     As cIABMProperty
  Dim i         As Long
  Dim j         As Integer
  Dim sqlstmt   As String
  
  i = 1
  
  ' El primer parametro siempre es el id del usuario
  sqlstmt = gDB.UserId & ","
  
  Dim param      As cInformeParametro
  Dim tblName    As String
  Dim tblCampo   As String
  Dim tblCampoId As String
  Dim Value      As String
  Dim bExists    As Boolean
  
  ' Por cada parametro de este reporte
  '
  For Each param In m_Parametros
    
    i = i + 1
    
    ' Si no es editable lo saco de la definicion del reporte y del informe
    '
    If Not param.Visible Then
    
      Select Case param.Tipo
        Case csEInfParamType.csInfParamCheck
          sqlstmt = sqlstmt & IIf(Val(param.default), 1, 0) & ","
        Case csEInfParamType.csInfParamDate
          If Not IsDate(param.default) Then
            sqlstmt = sqlstmt & gDB.sqlDate(VDGetDateByName(param.default)) & ","
          Else
            sqlstmt = sqlstmt & gDB.sqlDate(DateValue(param.default)) & ","
          End If
        Case csEInfParamType.csInfParamHelp
          If UCase(Left$(param.default, 1)) = KEY_NODO Then
            pGetNombreRama param.Tbl_id, Val(Mid(param.default, 2)), bExists
            If Not bExists Then param.default = "0"
          Else
            If Val(param.default) <> 0 Then
              pGetTblData param.Tbl_id, tblName, tblCampo, tblCampoId
              gDB.GetDataWithCondition tblName, tblCampo, tblCampoId & "=" & param.default, Value, bExists
              If Not bExists Then param.default = "0"
            End If
          End If
          sqlstmt = sqlstmt & gDB.sqlString(param.default) & ","
        Case csEInfParamType.csInfParamList
          sqlstmt = sqlstmt & gDB.sqlNumber(Val(param.default)) & ","
        Case csEInfParamType.csInfParamNumeric
          sqlstmt = sqlstmt & gDB.sqlNumber(Val(param.default)) & ","
        Case csEInfParamType.csInfParamSqlstmt
          sqlstmt = sqlstmt & gDB.sqlNumber(Val(param.default)) & ","
        Case csEInfParamType.csInfParamText
          sqlstmt = sqlstmt & gDB.sqlString(param.default) & ","
      End Select
    
    ' Si es editable
    ' lo saco de la interfaz
    '
    Else
      
      j = j + 1
      Set iProp = m_ObjAbmParams.Properties.Item(j)
      Select Case iProp.PropertyType
        Case cspHelp
          sqlstmt = sqlstmt & gDB.sqlString(iProp.HelpValueProcess) & ","
        Case cspList, cspAdHock
          sqlstmt = sqlstmt & gDB.sqlNumber(iProp.ListItemData) & ","
        Case cspCheck
          sqlstmt = sqlstmt & Val(iProp.Value) & ","
        Case cspDate
          If LenB(iProp.HelpValueProcess) Then
            sqlstmt = sqlstmt & gDB.sqlDate(VDGetDateByName(iProp.HelpValueProcess)) & ","
          Else
            sqlstmt = sqlstmt & gDB.sqlDate(iProp.Value) & ","
          End If
        Case cspNumeric
          sqlstmt = sqlstmt & gDB.sqlNumber(iProp.Value) & ","
        Case Else
          sqlstmt = sqlstmt & gDB.sqlString(iProp.Value) & ","
      End Select
    End If
  Next

  sqlstmt = RemoveLastColon(sqlstmt)
  
  pGetSqlstmt = sqlstmt
End Function

Private Sub pSetParamsInfPreviewGrid(ByRef F As fPreviewGrid)
  Dim iProp     As cIABMProperty
  
  F.InitParams
  
  For Each iProp In m_ObjAbmParams.Properties
    
    F.AddParam iProp.Name, _
               iProp.Value, _
               iProp.Value, _
               iProp.HelpValueProcess, _
               iProp.HelpId
  Next
End Sub

Private Function pGetParamsDescrip() As String
  Dim iProp     As cIABMProperty
  Dim rtn       As String
  
  For Each iProp In m_ObjAbmParams.Properties
    
    rtn = rtn & iProp.Name & ": " _
              & IIf(iProp.PropertyType <> cspCheck, _
                    iProp.Value, _
                    IIf(Val(iProp.Value), _
                        "Si", "No")) _
              & vbCrLf
  Next
  
  
  pGetParamsDescrip = rtn
End Function

Private Sub pShowParams(ByRef Rpt As cReport)
  Dim iProp As cIABMProperty
  
  Dim sec         As cReportSection
  Dim sec2        As cReportSection
  Dim ctl         As cReportControl
  Dim nexttop     As Long
  Dim col         As Long
  Dim Count       As Long
  Dim i           As Long
  Dim bTitleFound As Boolean
  Dim secln       As cReportSectionLine
  
  Const c_heightctl = 285
  
  '-------------------------------------------
  ' Defino el titulo si no existe
  '
  For Each sec In Rpt.Headers
    For Each secln In sec.SectionLines
      For Each ctl In secln.Controls
        If LCase(ctl.Name) = "@@title" Then
          ctl.Label.Text = m_Nombre
          bTitleFound = True
          Exit For
        End If
      Next
      If bTitleFound Then Exit For
    Next
    If bTitleFound Then Exit For
  Next
  
  '-------------------------------------------
  ' Agrego la seccion si no existe
  '
  For Each sec In Rpt.Headers
    If LCase(sec.Name) = "h_params" Then
      Exit For
    End If
  Next

  If sec Is Nothing Then
    With Rpt.Headers
      Set sec = .Add()
      With .Item(Rpt.Headers.Count - 1).Aspect
        sec.Aspect.Top = .Top + .Height
        sec.Aspect.Width = .Width
      End With
    End With
  End If
  
  ' Solo si el autor del reporte no oculto la seccion
  '
  If Not sec.HasFormulaHide Then
    sec.HasFormulaHide = True
    sec.FormulaHide.Text = "Function x()" & vbCrLf & _
                           "  x= _currentpage() =1" & vbCrLf & _
                           "End Function"
  End If
  
  ' Alto de la seccion
  Dim Height As Long
  
  With sec.Aspect
    Count = m_ObjAbmParams.Properties.Count
    Height = c_heightctl * ((Count / 2) + (Count Mod 2)) + 100
    .Height = Height
    sec.SectionLines(1).Aspect.Height = Height
    nexttop = .Top
  End With
  
  Dim bFound As Boolean

  For Each sec2 In Rpt.Headers
    If Not bFound Then
      If LCase(sec2.Name) = "h_params" Then
        bFound = True
      End If
    Else
      With sec2.Aspect
        .Top = .Top + Height
      End With
      For Each secln In sec2.SectionLines
        With secln.Aspect
          .Top = .Top + Height
          For Each ctl In secln.Controls
            With ctl.Label.Aspect
              .Top = .Top + Height
            End With
          Next
        End With
      Next
    End If
  Next
  
  Count = Count / 2
  col = 1
  
  With Rpt.Connect.Parameters
    For Each iProp In m_ObjAbmParams.Properties
      i = i + 1
      '-------------------------------------------
      ' Agrego el control
      '
      Set ctl = sec.SectionLines(1).Controls.Add(Nothing)
      'ctl.ControlType = CSReportDll2.csRptControlType.csRptCtLabel
      ctl.ControlType = CSReportTDll.csRptControlType.csRptCtLabel
      
      ' Ubico el control
      With ctl.Label.Aspect
        .Top = nexttop
        .Width = 5000
        .Height = 285
        .BorderType = csRptBSNone
        If col = 1 Then
          .Left = 500
        Else
          .Left = 6000
        End If
        .Transparent = True
        .BackColor = vbBlue
      End With
      
      If iProp.PropertyType <> cspCheck Then
        
        If iProp.PropertyType <> cspList Then
          ctl.Label.Text = iProp.Name & ": " & _
                             iProp.Value
        Else
          ctl.Label.Text = iProp.Name & ": " & _
                             pGetListText(iProp.List, _
                                          Val(iProp.ListItemData))
        
        End If
      Else
        ctl.Label.Text = iProp.Name & ": " & _
                             IIf(Val(iProp.Value), _
                                 "Si", "No")
      
      End If
      
      nexttop = nexttop + c_heightctl
      
      If i > Count - 1 Then
        Count = 1000 ' Para que no vuelva a entrar
        col = 2
        nexttop = sec.Aspect.Top
      End If
    Next
  End With

  Set ctl = sec.SectionLines(1).Controls.Add(Nothing)
  'ctl.ControlType = CSReportDll2.csRptControlType.csRptCtLabel
  ctl.ControlType = CSReportTDll.csRptControlType.csRptCtLabel
  
  With ctl.Label.Aspect
    .Height = 10
    .BackColor = 11513775
    .Width = sec.Aspect.Width - 300
    .Top = sec.Aspect.Top + sec.Aspect.Height - 150
    .Left = 150
  End With

End Sub

Private Function pGetListText(ByRef List As cIABMList, _
                              ByVal idx As Long) As String
  Dim ListItem As cIABMListItem
  
  For Each ListItem In List
    With ListItem
      If idx = .Id Then
        pGetListText = .Value
        Exit For
      End If
    End With
  Next
End Function

Private Sub pSetParams(ByRef Rpt As cReport)
  Dim iProp     As cIABMProperty
  Dim i         As Long
  Dim j         As Integer
  Dim rptParam  As CSReportTDll.cParameter
  
  i = 1
  
  ' El primer parametro siempre es el id del usuario
  '
  Rpt.Connect.Parameters.Item(1).Value = gDB.UserId
  
  Dim param      As cInformeParametro
  Dim tblName    As String
  Dim tblCampo   As String
  Dim tblCampoId As String
  Dim Value      As String
  Dim bExists    As Boolean
  
  ' Por cada parametro de este reporte
  '
  For Each param In m_Parametros
    
    i = i + 1
    Set rptParam = Rpt.Connect.Parameters.Item(i)
    
    ' Si no es editable lo saco de la definicion del reporte y del informe
    '
    If Not param.Visible Then
    
      Select Case param.Tipo
        Case csEInfParamType.csInfParamCheck
          rptParam.Value = IIf(Val(param.default), 1, 0)
        Case csEInfParamType.csInfParamDate
          If Not IsDate(param.default) Then
            rptParam.Value = VDGetDateByName(param.default)
          Else
            rptParam.Value = DateValue(param.default)
          End If
        Case csEInfParamType.csInfParamHelp
          If UCase(Left$(param.default, 1)) = KEY_NODO Then
            pGetNombreRama param.Tbl_id, Val(Mid(param.default, 2)), bExists
            If Not bExists Then param.default = "0"
          Else
            If Val(param.default) <> 0 Then
              pGetTblData param.Tbl_id, tblName, tblCampo, tblCampoId
              gDB.GetDataWithCondition tblName, tblCampo, tblCampoId & "=" & param.default, Value, bExists
              If Not bExists Then param.default = "0"
            End If
          End If
          rptParam.Value = param.default
          
        Case csEInfParamType.csInfParamList
          rptParam.Value = Val(param.default)
        Case csEInfParamType.csInfParamNumeric
          rptParam.Value = Val(param.default)
        Case csEInfParamType.csInfParamSqlstmt
          rptParam.Value = param.default
        Case csEInfParamType.csInfParamText
          rptParam.Value = param.default
      End Select
    
    ' Si es editable
    ' lo saco de la interfaz
    '
    Else
      
      j = j + 1
      Set iProp = m_ObjAbmParams.Properties.Item(j)
      Select Case iProp.PropertyType
        Case cspHelp
          rptParam.Value = iProp.HelpValueProcess
        Case cspList, cspAdHock
          rptParam.Value = iProp.ListItemData
        Case cspCheck
          rptParam.Value = IIf(Val(iProp.Value), 1, 0)
        Case cspDate
          If LenB(iProp.HelpValueProcess) Then
            rptParam.Value = VDGetDateByName(iProp.HelpValueProcess)
          Else
            rptParam.Value = iProp.Value
          End If
        Case Else
          rptParam.Value = iProp.Value
      End Select
    End If
  Next
End Sub

Public Sub ShowInfo(ByVal RptId As Long, _
                    ByVal Path As String, _
                    ByVal CommandTiemOut As Long, _
                    ByVal ConnectionTimeOut As Long)
                    
  On Error GoTo ControlError

  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_reporteInfo " & RptId
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  If rs.EOF Then
    MsgInfo LNGGetText(2746, vbNullString)  'No hay información que mostrar para este reporte.
  Else
    MsgInfo LNGGetText(2952, vbNullString, Path, CommandTiemOut, ConnectionTimeOut, rs.Fields(0))
            'Ubicación: & vbTab & Path _
            & vbCrLf & Ejecucion: & vbTab & CommandTiemOut &  segundos _
            & vbCrLf & Conexión: & vbTab & ConnectionTimeOut &  segundos _
            & vbCrLf & rs.Fields(0)
  End If

  Exit Sub
ControlError:
  MngError Err, "ShowInfo", C_Module, vbNullString
End Sub

Public Function CopyRptToUsers(ByVal RptId As Long) As Boolean
  On Error GoTo ControlError
  
  Dim Help  As CSOAPI2.cHelp
  Dim hr    As cHelpResult
  
  Set Help = New CSOAPI2.cHelp
  
  Help.IsSearch = True
  
  Set hr = Help.Show(Nothing, csUsuario, "", "", "", csTree, , , , True)
  
  If hr.Cancel Then Exit Function
  
  Dim sqlstmt As String
  
  sqlstmt = "sp_ReporteCopyToUsers " & RptId & "," & gDB.sqlString(hr.Id)
  If Not gDB.Execute(sqlstmt) Then Exit Function
  
  RaiseEvent RefreshDesktop
  
  CopyRptToUsers = True
  
  Exit Function
ControlError:
  MngError Err, "CopyRptToUsers", C_Module, vbNullString
End Function

Public Function ShowParams() As Boolean
  On Error GoTo ControlError

  Dim o As cIEditGenericListDoc
  
  Dim fParam As fParameters
  Set fParam = New fParameters
  
  fParam.NameEdit = LNGGetText(1817, vbNullString) 'Parametros
  fParam.Init
  Set fParam.Reporte = Me
  
  If Not Load(m_Id) Then Exit Function
  If Not pLoadParamsForExec() Then Exit Function
  
  Set o = Me
  Set o.ObjList = fParam.rptParams
  Set o.ObjABM = CSKernelClient2.CreateObject("CSABMInterface2.CABMGenericListDoc")

  o.ShowParams m_Id
  
  Set o = Nothing
  
  On Error Resume Next
  fParam.rptParams.ReportTitle = m_Nombre
  fParam.Caption = LNGGetText(2953, vbNullString, m_Nombre) 'Parametros -  & m_Nombre
  fParam.Show
  
  ShowParams = True
  
  Exit Function
ControlError:
  MngError Err, "ShowParams", C_Module, vbNullString
End Function

Public Function LoadShowParams() As Boolean
  On Error GoTo ControlError

  If Not Load(m_Id) Then Exit Function
  
  If Not pLoadParamsForExec() Then Exit Function
  
  LoadShowParams = True
  
  Exit Function
ControlError:
  MngError Err, "LoadShowParams", C_Module, vbNullString
End Function

Friend Sub Terminate()
  Dim o As cIEditGenericListDoc
  
  Set o = Me
  Set o.ObjList = Nothing
  Set o.ObjABM = Nothing
End Sub

'//////////////////////////////////////////////////////
'//////////////////////////////////////////////////////
'//////////////////////////////////////////////////////
' Implementacion de cIABMClientGrid
'//////////////////////////////////////////////////////
'//////////////////////////////////////////////////////
'//////////////////////////////////////////////////////

Private Function cIABMClientGrid_ColumnAfterEdit(ByVal key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long) As Boolean
  cIABMClientGrid_ColumnAfterEdit = True
End Function

Private Function cIABMClientGrid_ColumnAfterUpdate(ByVal key As Integer, ByVal lRow As Long, ByVal lCol As Long) As Boolean
  cIABMClientGrid_ColumnAfterUpdate = True
End Function

Private Function cIABMClientGrid_ColumnBeforeEdit(ByVal key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean
  cIABMClientGrid_ColumnBeforeEdit = True
End Function

Private Function cIABMClientGrid_ColumnButtonClick(ByVal key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean

End Function

Private Sub cIABMClientGrid_ColumnCancelEdit(ByVal key As Integer)

End Sub

Private Sub cIABMClientGrid_ColumnClick(ByVal key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Sub cIABMClientGrid_DblClick(ByVal key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Function cIABMClientGrid_DeleteRow(ByVal key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal lRow As Long) As Boolean
  cIABMClientGrid_DeleteRow = False
End Function

Private Function cIABMClientGrid_IsEmptyRow(ByVal key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case key
    Case K_PARAMETROS
      cIABMClientGrid_IsEmptyRow = pIsEmptyRow(Row, RowIndex)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ValidateRow", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIABMClientGrid_ListAdHock(ByVal key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal ColIndex As Long, List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClientGrid_NewRow(ByVal key As Integer, ByVal Rows As Integer)

End Sub

Private Function cIABMClientGrid_ValidateRow(ByVal key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  cIABMClientGrid_ValidateRow = True
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
  pLoadCollParams
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
  Dim Rptp_id  As Long
  Dim bFound   As Boolean
  
  Set register = New cRegister
  
  Dim IProperty As cIABMProperty
  For Each IProperty In m_ObjAbmParams.Properties
    
    register.Fields.Clear
    
    With IProperty
  
      Rptp_id = pGetRptpIdFromInfpId(.key, bFound)
  
      If bFound Then
        register.fieldId = cscRptpId
        register.Table = csTReporteParametro
        register.Id = Rptp_id
        
        Select Case IProperty.PropertyType
          Case cspHelp
            register.Fields.Add2 cscRptpValor, .HelpValueProcess, csText
          Case cspList, cspAdHock
            register.Fields.Add2 cscRptpValor, .ListItemData, csText
          Case cspDate
            If LenB(.HelpValueProcess) Then
              register.Fields.Add2 cscRptpValor, .HelpValueProcess, csText
            Else
              register.Fields.Add2 cscRptpValor, .Value, csText
            End If
          Case cspList
            register.Fields.Add2 cscRptpValor, .ListItemData, csInteger
          Case Else
            register.Fields.Add2 cscRptpValor, .Value, csText
        End Select
    
        If Rptp_id = csNO_ID Then
          register.Fields.Add2 cscRptpVisible, 1, csBoolean
        End If
    
        register.Fields.Add2 cscRptId, m_Id, csId
        register.Fields.Add2 cscInfpId, .key, csId
    
        register.Fields.HaveLastUpdate = True
        register.Fields.HaveWhoModify = True
        
        If Not gDB.Save(register, , "cIABMListDocClient_Save", C_Module, c_ErrorSave) Then Exit Function
      End If
    End With
  Next
  
  If Not pLoadParamsForExec() Then Exit Function
  
  cIABMListDocClient_Save = True
End Function

Private Function cIABMListDocClient_Terminate() As Boolean
  cIABMListDocClient_Terminate = True
End Function

Private Property Get cIABMListDocClient_Title() As String
  cIABMListDocClient_Title = LNGGetText(1817, vbNullString)  'Parametros
End Property

Private Function cIABMListDocClient_Validate() As Boolean
  cIABMListDocClient_Validate = True
End Function

Private Function pLoadParamsForExec() As Boolean
  Dim sqlstmt As String
  Dim Value   As String
  Dim Visible As Boolean
  
  sqlstmt = "sp_reporteGetParametros " & m_Inf_id & "," & m_Id
  
  Dim rs As Recordset

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadParamsForExec", C_Module) Then Exit Function

  m_Parametros.Clear

  While Not rs.EOF
    
    If IsNull(rs.Fields(cscRptpValor)) Then
      Value = ValField(rs.Fields, cscInfpDefault)
    Else
      Value = ValField(rs.Fields, cscRptpValor)
    End If
    
    If IsNull(rs.Fields(cscRptpVisible)) Then
      Visible = ValField(rs.Fields, cscInfpVisible)
    Else
      Visible = ValField(rs.Fields, cscRptpVisible)
    End If
    
    With m_Parametros.Add(Nothing)
      .Nombre = ValField(rs.Fields, cscInfpNombre)
      .Tipo = ValField(rs.Fields, cscInfpTipo)
      .default = Value
      .Tbl_id = ValField(rs.Fields, cscTblId)
      .sqlstmt = ValField(rs.Fields, cscInfpSqlstmt)
      .Visible = Visible
      .Id = ValField(rs.Fields, cscInfpId)
      
      If .Tipo = csInfParamDate And Not IsDate(.default) Then
        If DateNames(Value) Is Nothing Then
          .default = VDGetDateById(csToday)
        Else
          .default = Value
        End If
      End If
      
      ' Para poder guardarlo
      .Rptp_id = ValField(rs.Fields, cscRptpId)
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

Private Function cIEditGenericListDoc_ShowParams(ByVal rpt_id As Long) As Boolean
  On Error GoTo ControlError
  
  If rpt_id = csNO_ID Then Exit Function

  ' Por si las moscas
  If rpt_id <> m_Id Then
    If Not Load(rpt_id) Then Exit Function
    If Not pLoadParamsForExec() Then Exit Function
  End If
  
  If Not pLoadCollParams() Then Exit Function
  
  cIEditGenericListDoc_ShowParams = True
  Exit Function
ControlError:
  MngError Err, "cIEditGenericListDoc_ShowParams", C_Module, vbNullString
End Function

Private Function cIEditGenericListDoc_TabClick(ByVal Index As Integer) As Boolean

End Function

Private Function pLoadCollParams() As Boolean
  Dim param      As cInformeParametro
  Dim tblName    As String
  Dim tblCampo   As String
  Dim tblCampoId As String
  Dim Value      As String
  Dim bExists    As Boolean
  
  m_ObjAbmParams.Properties.Clear

  For Each param In m_Parametros
    
    If param.Visible Then
    
      With m_ObjAbmParams.Properties.Add(Nothing)
        .Name = param.Nombre
        .Value = param.default
        .key = param.Id
        
        Select Case param.Tipo
          Case csEInfParamType.csInfParamCheck
            .PropertyType = cspCheck
          Case csEInfParamType.csInfParamDate
            .PropertyType = cspDate
          Case csEInfParamType.csInfParamHelp
            .PropertyType = cspHelp
            .Table = param.Tbl_id
            Value = ""
            If UCase(Left$(param.default, 1)) = KEY_NODO Then
              Value = pGetNombreRama(param.Tbl_id, Val(Mid(param.default, 2)), bExists)
              If Not bExists Then param.default = "0"
            Else
              If Val(param.default) <> 0 Then
                pGetTblData param.Tbl_id, tblName, tblCampo, tblCampoId
                gDB.GetDataWithCondition tblName, tblCampo, tblCampoId & "=" & param.default, Value, bExists
                If Not bExists Then param.default = "0"
              End If
            End If
            .Value = Value
            .HelpId = Val(param.default)
            .HelpValueProcess = param.default
            
          Case csEInfParamType.csInfParamList
            .PropertyType = cspList
            Dim vList As Variant
            Dim q     As Long
            
            vList = Split(param.sqlstmt, "|")
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
            .ListItemData = Val(param.default)
            
          Case csEInfParamType.csInfParamNumeric
            .PropertyType = cspNumeric
            .SubType = cspDouble
          Case csEInfParamType.csInfParamSqlstmt
            .PropertyType = cspText
          Case csEInfParamType.csInfParamText
            .PropertyType = cspText
            .SubType = cspTextButtonEx
        End Select
      End With
    End If
  Next

  If Not m_ObjAbmParams.Show(Me, m_ObjList) Then Exit Function

  pLoadCollParams = True
End Function
'//////////////////////////////////////////////////////
'//////////////////////////////////////////////////////
'//////////////////////////////////////////////////////
' Implementacion de cIWizardClient
'//////////////////////////////////////////////////////
'//////////////////////////////////////////////////////
'//////////////////////////////////////////////////////

Private Property Get cIWizardClient_Aplication() As String
  cIWizardClient_Aplication = gAppName
End Property

Private Function cIWizardClient_ListAdHock(List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Function cIWizardClient_Load() As Boolean
  On Error GoTo ControlError

  m_ObjWizard.EditGeneric.HideTitle = True
  cIWizardClient_Load = LoadSteps()

  Exit Function
ControlError:
  MngError Err, "cIWizardClient_Load", C_Module, vbNullString
End Function

Private Property Set cIWizardClient_ObjWizard(rhs As CSInterfacesABM.cIWizardGeneric)
   Set m_ObjWizard = rhs
End Property

Private Property Get cIWizardClient_ObjWizard() As CSInterfacesABM.cIWizardGeneric
   Set cIWizardClient_ObjWizard = m_ObjWizard
End Property

Private Function cIWizardClient_Work(ByVal CurrentStep As Integer, ByVal GoingToNext As Boolean) As Boolean
  On Error GoTo ControlError

  Select Case CurrentStep
    Case -1
    Case c_StepWelcome
      ' First step, Disable back
      m_ObjWizard.cmdBack.Enabled = False
    Case c_StepShowParameters

    Case c_StepShowReport

    Case c_StepShowSave
  
  End Select

  cIWizardClient_Work = True

  GoTo ExitProc
ControlError:
  MngError Err, "cIWizardClient_Work", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIWizardClient_NextStep(ByVal nCurrentStep As Integer, nNextStep As Integer) As Boolean
  On Error GoTo ControlError

  Select Case nCurrentStep

    ' Este paso es el primero que se recibe
    ' su proposito es darle una oportunidad al cliente del wizard
    ' de indicar cual es el primer paso
    Case -1
      nNextStep = c_StepWelcome
      m_ObjWizard.cmdNext.Enabled = False
      
    Case c_StepWelcome
      
      nNextStep = c_StepShowReport
      m_ObjWizard.cmdBack.Enabled = True
      pWizardShowReport
      
    Case c_StepShowReport
      nNextStep = c_StepShowParameters
      pWizardShowParameters

    Case c_StepShowParameters
      nNextStep = c_StepShowSave

      m_ObjWizard.cmdNext.Caption = c_WizStr_Finish

    Case c_StepShowSave
      
      With m_ObjWizard.Steps.Item(GetKey(c_StepWelcome)).Properties.Item(c_Wiz_Key_Informe)
        m_Inf_id = .HelpId
      End With
      With m_ObjWizard.Steps.Item(GetKey(c_StepShowReport)).Properties
        With .Item(c_Wiz_Key_Nombre)
          m_Nombre = .Value
        End With
        With .Item(c_Wiz_Key_Descrip)
          m_Descrip = .Value
        End With
      End With
      
      m_Us_id = gDB.UserId
    
      If Not pSaveNewReport() Then Exit Function
      
      ' Finish, now close wizard
      m_ObjWizard.CloseWizard
      ' We return False to cancel pending steps in the generic Wizard's code
      Exit Function
  End Select

  cIWizardClient_NextStep = True

  GoTo ExitProc
ControlError:
  MngError Err, "cIWizardClient_NextStep", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIWizardClient_PreviousStep(ByVal nCurrentStep As Integer, nNextStep As Integer) As Boolean
  Select Case nCurrentStep
    Case c_StepWelcome
      nNextStep = c_StepWelcome

    Case c_StepShowReport
    
      nNextStep = c_StepWelcome
      
    Case c_StepShowParameters
      
      nNextStep = c_StepShowReport

    Case c_StepShowSave
    
      nNextStep = c_StepShowParameters
      m_ObjWizard.cmdNext.Caption = c_WizStr_Next
  End Select

  cIWizardClient_PreviousStep = True
End Function

Private Function cIWizardClient_PropertyChange(ByVal key As Integer) As Boolean
  Select Case key
    Case KW_CANCEL
      If m_WizardProcessing Then
        m_WizardCancel = True
      Else
        cIWizardClient_PropertyChange = True
      End If
    Case K_INF_ID
      m_ObjWizard.cmdNext.Enabled = m_ObjWizard.Steps.Item(GetKey(c_StepWelcome)).Properties.Item(c_Wiz_Key_Informe).HelpId <> 0
  End Select
End Function

Private Function cIWizardClient_Terminate() As Boolean
  cIWizardClient_Terminate = True
  'Unload m_Resource
  'Set m_Resource = Nothing
  RaiseEvent RefreshDesktop
End Function

Private Property Get cIWizardClient_Title() As String
  cIWizardClient_Title = c_WizardTitle
End Property

'//////////////////////////////////////////////////////
'//////////////////////////////////////////////////////
'//////////////////////////////////////////////////////
' Implementacion de cIABMClient
'//////////////////////////////////////////////////////
'//////////////////////////////////////////////////////
'//////////////////////////////////////////////////////

Private Function cIABMClient_Copy() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True
  
  With m_ObjAbm.Properties(cscRptNombre)
    .Value = "C-" & .Value
  End With
  
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscRptNombre)
  
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

Private Function cIABMClient_PropertyChange(ByVal key As Integer) As Boolean

End Function

Private Function cIABMClient_Save() As Boolean
  Dim register As cRegister
  Set register = New cRegister
  register.fieldId = cscRptId
  register.Table = csTReporte
  
  If m_Copy Then
    register.Id = csNew
  Else
    register.Id = m_Id
  End If
  
  Dim IProperty As cIABMProperty
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .key
        Case K_NOMBRE
          register.Fields.Add2 cscRptNombre, .Value, csText
        Case K_DESCRIP
          register.Fields.Add2 cscRptDescrip, .Value, csText
        Case K_ACTIVO
          register.Fields.Add2 cscActivo, .Value, csBoolean
      End Select
    End With
  Next
  
  register.Fields.HaveLastUpdate = True
  register.Fields.HaveWhoModify = True
  
  If Not register.BeginTrans(gDB) Then Exit Function
  
  If Not gDB.Save(register, , "cIABMClient_Save", C_Module, c_ErrorSave) Then Exit Function
  If Not pSaveItemsParametrosAux(m_ObjAbm.Properties(c_Wiz_Key_Parameters)) Then Exit Function
  
  If Not register.CommitTrans() Then Exit Function
  
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
  RaiseEvent RefreshDesktop
ControlError:
End Function

Private Property Get cIABMClient_Title() As String
    cIABMClient_Title = LNGGetText(2577, vbNullString)  'Reportes
End Property

Private Function cIABMClient_Validate() As Boolean

  Dim IProperty As cIABMProperty

  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .key
        Case K_NOMBRE
          If ValEmpty(.Value, csText) Then
            MsgInfo LNGGetText(1007, vbNullString)  'Debe indicar un nombre
            Exit Function
          End If

      End Select
    End With
  Next

  cIABMClient_Validate = True
End Function

'//////////////////////////////////////////////////////
'//////////////////////////////////////////////////////
'//////////////////////////////////////////////////////
' Implementacion de cIEditGeneric
'//////////////////////////////////////////////////////
'//////////////////////////////////////////////////////
'//////////////////////////////////////////////////////

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Id = csNO_ID Then
    m_IsNew = True
    If Not SecurityCanAccess(csPreINewReporte) Then Exit Function
  Else
    m_IsNew = False
    If Not SecurityCanAccess(csPreIEditReporte) Then Exit Function
  End If
  
  If m_ObjAbm Is Nothing Then Set m_ObjAbm = CSKernelClient2.CreateObject("CSABMInterface2.cABMGeneric")
  
  If Not Load(Id) Then Exit Function
  
  If Not LoadCollection() Then Exit Function
  
  m_Editing = True
  cIEditGeneric_Edit = True
  Exit Function
ControlError:
  MngError Err, "cIEditGeneric_Edit", C_Module, vbNullString
End Function

Private Function cIEditGeneric_TabClick(ByVal Index As Integer) As Boolean

End Function

Private Property Let cIEditGeneric_TreeId(ByVal rhs As Long)
    m_TreeId = rhs
End Property

Private Property Get cIEditGeneric_TreeId() As Long
    cIEditGeneric_TreeId = m_TreeId
End Property

Private Function cIEditGeneric_GridAdd(ByVal KeyProperty As Integer) As Boolean

End Function

Private Function cIEditGeneric_GridEdit(ByVal KeyProperty As Integer) As Boolean

End Function

Private Function cIEditGeneric_GridRemove(ByVal KeyProperty As Integer) As Boolean

End Function

Private Function cIEditGeneric_ShowList() As Boolean
    cIEditGeneric_ShowList = SecurityCanAccess(csPreIListReporte)
End Function

Private Property Get cIEditGeneric_ObjAbm() As CSInterfacesABM.cIABMGeneric
  Set cIEditGeneric_ObjAbm = m_ObjAbm
End Property

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
    Set m_ObjAbm = rhs
End Property

Private Property Get cIEditGeneric_Editing() As Boolean
    cIEditGeneric_Editing = m_Editing
End Property

Private Function cIEditGeneric_Delete(Id As Long) As Boolean
  If Not SecurityCanAccess(csPreIDeleteReporte) Then Exit Function

  Dim sqlstmt As String
  
  sqlstmt = "sp_ReporteDelete " & Id
  
  cIEditGeneric_Delete = gDB.Execute(sqlstmt, "cIEditGeneric_Delete", C_Module)
End Function

Private Function cIEditGeneric_Search(Id As Long, Cancela As Boolean) As Boolean

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

Private Function cIEditGeneric_PropertyChange(ByVal key As Integer) As Boolean

End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  Dim iTab As cIABMTabItem
  Dim c As cIABMProperty

  m_ObjAbm.Tabs.Clear
  m_ObjAbm.Properties.Clear
  
  Const c_TabParams = 1
  
  Set iTab = m_ObjAbm.Tabs.Add(Nothing)
  iTab.Index = 0
  iTab.Name = C_strGeneral
  
  Set iTab = m_ObjAbm.Tabs.Add(Nothing)
  iTab.Index = c_TabParams
  iTab.Name = C_Params
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscRptNombre)
  c.PropertyType = cspText
  c.Name = C_strNombre
  c.Size = 100
  c.key = K_NOMBRE
  c.Width = 6000
  c.Value = Nombre
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscRptDescrip)
  c.PropertyType = cspText
  c.Name = C_strDescrip
  c.SubType = cspMemo
  c.Width = 6000
  c.Height = 880
  c.Size = 1000
  c.key = K_DESCRIP
  c.Value = Descrip
  
  Set c = m_ObjAbm.Properties.Add(Nothing, c_Wiz_Key_Parameters)
  c.PropertyType = cspGrid
  c.LeftLabel = -1
  c.key = K_PARAMETROS
  c.GridAdd = False
  c.GridEdit = True
  c.GridRemove = False
  c.TabIndex = c_TabParams
  pFormatGridParameters c, m_Id
  If Not pLoadParamNew(c, m_Inf_id, m_Id) Then Exit Function
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

Private Function Load(ByVal Id As Long) As Boolean
  Dim sqlstmt As String

  sqlstmt = "select reporte.*, inf_nombre, us_nombre" & _
            " from reporte" & _
            " left join informe on reporte.inf_id = informe.inf_id " & _
            " left join usuario on informe.inf_id = usuario.us_id " & _
            " where reporte.rpt_id = " & Id

  Dim rs As Recordset

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.Fields, cscRptId)
    m_Nombre = gDB.ValField(rs.Fields, cscRptNombre)
    m_Descrip = gDB.ValField(rs.Fields, cscRptDescrip)
    m_Inf_id = gDB.ValField(rs.Fields, cscInfId)
    m_Informe = gDB.ValField(rs.Fields, cscInfNombre)
    m_Us_id = gDB.ValField(rs.Fields, cscUsId)
    m_Usuario = gDB.ValField(rs.Fields, cscUsNombre)
    m_Modificado = gDB.ValField(rs.Fields, cscModificado)
    m_Creado = gDB.ValField(rs.Fields, cscCreado)
    m_Modifico = gDB.ValField(rs.Fields, cscModifico)
    m_Activo = gDB.ValField(rs.Fields, cscActivo)

  Else
    m_Id = csNO_ID
    m_Nombre = vbNullString
    m_Descrip = vbNullString
    m_Inf_id = csNO_ID
    m_Us_id = csNO_ID
    m_Modificado = csNoDate
    m_Creado = csNoDate
    m_Modifico = 0
    m_Activo = False
    m_Usuario = vbNullString
    m_Informe = vbNullString

  End If

  Load = True
End Function

'//////////////////////////////////////////////////////
'//////////////////////////////////////////////////////
'//////////////////////////////////////////////////////
' Wizard
'//////////////////////////////////////////////////////
'//////////////////////////////////////////////////////
'//////////////////////////////////////////////////////

Private Function LoadSteps() As Boolean
  Dim sh As Shape
  Set sh = m_ObjWizard.EditGeneric.ShapeMain

  'If m_Resource Is Nothing Then Set m_Resource = New fResource

  sh.Move 0, 0, 9000, 5000
  sh.BorderStyle = 0
  sh.BackColor = vbWhite

  Dim Img As Image
  Set Img = m_ObjWizard.EditGeneric.PicMain

  Img.Visible = False

  pLoadStepWelcome
  pLoadStepReport
  pLoadParameters
  pLoadSave

  LoadSteps = True
End Function

Private Sub pWizardShowReport()
  Dim c       As cIABMProperty
  Dim inf_id  As Long
  Dim Descrip As String
  
  Static OldInf_id As Long
  
  Set c = m_ObjWizard.Steps.Item(GetKey(c_StepShowReport)).Properties.Item(c_Wiz_Key_Nombre)
  With m_ObjWizard.Steps.Item(GetKey(c_StepWelcome)).Properties.Item(c_Wiz_Key_Informe)
  
    inf_id = .HelpId
    If OldInf_id = inf_id Then Exit Sub
    OldInf_id = inf_id
    
    c.Value = .Value
  End With
  m_ObjWizard.ShowValue c
  
  Set c = m_ObjWizard.Steps.Item(GetKey(c_StepShowReport)).Properties.Item(c_Wiz_Key_Descrip)
  gDB.GetDataWithCondition "Informe", "inf_descrip", "inf_id = " & inf_id, Descrip, False
  c.Value = Descrip
  m_ObjWizard.ShowValue c
End Sub

Private Sub pWizardShowParameters()
  Dim c As cIABMProperty
  Dim inf_id As Long
  
  inf_id = m_ObjWizard.Steps.Item(GetKey(c_StepWelcome)).Properties.Item(c_Wiz_Key_Informe).HelpId
  Set c = m_ObjWizard.Steps.Item(GetKey(c_StepShowParameters)).Properties.Item(c_Wiz_Key_Parameters)
      
  If Not pLoadParamNew(c, inf_id, csNO_ID) Then Exit Sub
  
  m_ObjWizard.ShowValue c
End Sub

Private Sub pLoadStepReport()
  With m_ObjWizard.Steps.Add(Nothing, GetKey(c_StepShowReport))
    With .Properties.Add(Nothing)
      .Top = 100
      .Left = 200
      .TopNotChange = True
      .LeftNotChange = True
      .PropertyType = cspImage
      .Value = 5
      'Set .Picture = m_Resource.ImgWiz5.Picture
    End With

    With .Properties.Add(Nothing)
      .Top = 200
      .Left = 800
      .PropertyType = cspLabel
      .Width = 5700
      .Height = 880
      .FontBold = True
      .Value = LNGGetText(2747, vbNullString) 'Definición del Reporte
      .FontSize = 10
    End With
    
    With .Properties.Add(Nothing, c_Wiz_Key_Nombre)
      .Top = 1000
      .Left = 2000
      .Width = 6000
      .Name = C_strNombre
      .PropertyType = cspText
      .key = K_NOMBRE
    End With
  
    With .Properties.Add(Nothing, c_Wiz_Key_Descrip)
      .Name = C_strDescrip
      .PropertyType = cspText
      .SubType = cspMemo
      .Width = 6000
      .Height = 880
      .key = K_DESCRIP
    End With
  End With
End Sub

Private Sub pLoadStepWelcome()
  ' La clave de los pasos debe ser la constante que los define
  ' Esto es vital para que la navegacion funcione correctamente
  With m_ObjWizard.Steps.Add(Nothing, GetKey(c_StepWelcome))
    With .Properties.Add(Nothing)
      .Top = 0
      .Left = 0
      .TopNotChange = True
      .LeftNotChange = True
      .PropertyType = cspImage
      .Value = 1
      'Set .Picture = m_Resource.ImgWiz1.Picture
    End With

    With .Properties.Add(Nothing, c_Wiz_Key_Title)
      .Top = 100
      .Left = 2700
      .TopNotChange = True
      .LeftNotChange = True
      .Height = 880
      .Width = 6000
      .PropertyType = cspTitle
      .Value = LNGGetText(2748, vbNullString) 'Bienvenido al Asistente de Nuevos Reportes
    End With
    
    With .Properties.Add(Nothing)
      .Top = 1200
      .Left = 3000
      .PropertyType = cspLabel
      .Width = 4500
      .Height = 880
      .FontBold = True
      .Value = LNGGetText(2749, vbNullString)
        'Con este asistente usted podrá agregar nuevos reportes basados en los Informes de Cairo sobre los que tenga acceso.
    End With
  
    With .Properties.Add(Nothing)
      .Top = 2700
      .Left = 3000
      .Value = LNGGetText(2750, vbNullString) 'Seleccione el informe
      .key = K_INF_ID
      .PropertyType = cspLabel
      .Width = 4500
      .FontBold = True
    End With
    
    With .Properties.Add(Nothing, c_Wiz_Key_Informe)
      .Top = 3000
      .Left = 3000
      .key = K_INF_ID
      .PropertyType = cspHelp
      .Table = csTblInforme
      .HelpId = 0
      
      ' Paso directamente una constante
      ' ya que CSOAPI no formatea el filtro
      ' y por ende puedo pasar tanto un
      ' numero como un string con un query
      ' mas complejo.
      ' Como en este caso con pasar el
      ' valor del tipo deseado me arreglo
      ' voy con el numero y listo
      ' el sp espera un int en su ultimo
      ' parametro.
      '
      If m_bIsProcess Then
        .HelpFilter = csInfTypeProcess
      Else
        .HelpFilter = csInfTypeReport
      End If
      .Width = 4500
    End With
  End With
End Sub

Private Sub pLoadParameters()
  With m_ObjWizard.Steps.Add(Nothing, GetKey(c_StepShowParameters))
    With .Properties.Add(Nothing)
      .Top = 100
      .Left = 200
      .TopNotChange = True
      .LeftNotChange = True
      .PropertyType = cspImage
      .Value = 5
      'Set .Picture = m_Resource.ImgWiz5.Picture
    End With

    With .Properties.Add(Nothing)
      .Top = 200
      .Left = 800
      .PropertyType = cspLabel
      .Width = 5700
      .Height = 880
      .FontBold = True
      .Value = LNGGetText(2751, vbNullString)
              'Indique los parámetros que serán editables en este Reporte
      .FontSize = 10
    End With
    
    Dim c As cIABMProperty
    Set c = .Properties.Add(Nothing, c_Wiz_Key_Parameters)
    With c
      .Top = 1000
      .Left = 800
      .Width = 7500
      .PropertyType = cspGrid
      .LeftLabel = -1
      .key = K_PARAMETROS
      .GridAdd = False
      .GridEdit = True
      .GridRemove = False
      pFormatGridParameters c, csNO_ID
    End With

  End With
End Sub

Private Function pFormatGridParameters(ByRef Propiedad As cIABMProperty, ByVal rpt_id As Long) As Boolean
  Dim o As cIABMGridColumn
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = "infp_id"
  o.Visible = False
  o.key = KI_INFP_ID
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = C_strNombre
  o.PropertyType = cspText
  o.Width = 2000
  o.Enabled = False
  o.key = KI_NOMBRE
  
  ' Solo cuando es nuevo
  '
  If rpt_id = csNO_ID Then
    Set o = Propiedad.Grid.Columns.Add(Nothing)
    o.Name = LNGGetText(2752, vbNullString) 'Valor
    o.PropertyType = cspText
    o.Width = 2000
    o.key = KI_DEFAULT
  End If
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = LNGGetText(2753, vbNullString)   'Editable
  o.PropertyType = cspCheck
  o.Width = 1000
  o.key = KI_VISIBLE
  
  ' Cuando esta editando
  '
  If rpt_id <> csNO_ID Then
  
    Set o = Propiedad.Grid.Columns.Add(Nothing)
    o.Visible = False
    o.key = KI_RPTP_ID
  
  End If
End Function

Private Function pLoadParamNew(ByRef Propiedad As cIABMProperty, ByVal inf_id As Long, ByVal rpt_id As Long) As Boolean
  Dim sqlstmt As String
  Dim Visible As Boolean
  Dim rs      As ADODB.Recordset
  
  ' Si es nuevo
  '
  If rpt_id = csNO_ID Then
  
    sqlstmt = "select infp_id, infp_nombre, infp_default from InformeParametro " & _
                " where inf_id = " & inf_id & _
                  " and infp_visible <> 0" & _
              " order by infp_orden"
  
  ' Si esta editando
  '
  Else
    
    sqlstmt = "sp_reporteGetParametros " & m_Inf_id & "," & m_Id

  End If
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadParamNew", C_Module) Then Exit Function
  
  Dim F  As cIABMGridRow
  Dim fv As cIABMGridCellValue
  
  Propiedad.Grid.Rows.Clear
  
  While Not rs.EOF
  
    ' Si esta editando
    '
    If rpt_id <> csNO_ID Then
      
      ' El parametro debe ser visible
      ' segun el informe
      '
      Visible = ValField(rs.Fields, cscInfpVisible)
    
    Else
      
      ' Si es nuevo el select solo trae parametros visibles
      '
      Visible = True
    End If
  
    If Visible Then
      Set F = Propiedad.Grid.Rows.Add(Nothing, rs(cscInfpId).Value)
      
      Set fv = F.Add(Nothing)
      fv.Value = rs(cscInfpId).Value
      fv.key = KI_INFP_ID
      
      Set fv = F.Add(Nothing)
      fv.Value = gDB.ValField(rs.Fields, cscInfpNombre)
      fv.key = KI_NOMBRE
      
      ' Si es nuevo
      '
      If rpt_id = csNO_ID Then
      
        Set fv = F.Add(Nothing)
        fv.Value = gDB.ValField(rs.Fields, cscInfpDefault)
        fv.key = KI_DEFAULT
        
        Set fv = F.Add(Nothing)
        fv.Id = -1
        fv.key = KI_VISIBLE
      
      ' Si es para edicion
      '
      Else
              
        Set fv = F.Add(Nothing)
        If gDB.ValField(rs.Fields, cscRptpId) = csNO_ID Then
          fv.Id = -1
        Else
          fv.Id = ValField(rs.Fields, cscRptpVisible)
        End If
        fv.key = KI_VISIBLE
        
        Set fv = F.Add(Nothing)
        fv.Value = gDB.ValField(rs.Fields, cscRptpId)
        fv.key = KI_RPTP_ID
                    
      End If
    End If
    
    rs.MoveNext
  Wend
  
  pLoadParamNew = True
End Function

Private Sub pLoadSave()
  With m_ObjWizard.Steps.Add(Nothing, GetKey(c_StepShowSave))

    With .Properties.Add(Nothing)
      .Top = 100
      .Left = 200
      .TopNotChange = True
      .LeftNotChange = True
      .PropertyType = cspImage
      .Value = 5
      'Set .Picture = m_Resource.ImgWiz5.Picture
    End With
    
    With .Properties.Add(Nothing, c_Wiz_Key_SaveTitle)
      .Top = 200
      .Left = 800
      .PropertyType = cspLabel
      .Width = 5700
      .Height = 880
      .FontBold = True
      .FontSize = 12
      .Value = LNGGetText(2754, vbNullString)  'Guardar el Reporte
    End With

    With .Properties.Add(Nothing, c_Wiz_Key_Save)
      .Top = 1400
      .Left = 1000
      .PropertyType = cspLabel
      .Width = 7000
      .Height = 2500
      .LeftLabel = 10
      .FontSize = 10
      .Value = LNGGetText(2755, vbNullString)
        'El asistente ya tiene toda la información que necesita haga click en el botón Finalizar para guardar el Reporte.
    End With
  End With
End Sub

Private Function pUserCancel() As Boolean
  If m_WizardCancel Then
    
    If Ask(LNGGetText(1665, vbNullString), vbNo) Then
            'Desea cancelar el proceso"
      pUserCancel = True
    End If
  End If
  m_WizardCancel = False
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

Private Function pSaveNewReport() As Boolean
  Dim register As cRegister
  
  Set register = New cRegister
  
  register.fieldId = cscRptId
  register.Table = csTReporte
  register.Id = csNew
  
  register.Fields.Add2 cscRptNombre, m_Nombre, csText
  register.Fields.Add2 cscRptDescrip, m_Descrip, csText
  register.Fields.Add2 cscInfId, m_Inf_id, csId
  register.Fields.Add2 cscUsId, m_Us_id, csId
  register.Fields.Add2 cscActivo, -1, csBoolean
  
  register.Fields.HaveLastUpdate = True
  register.Fields.HaveWhoModify = True
  
  If Not register.BeginTrans(gDB) Then Exit Function
  
  If Not gDB.Save(register, , "pSaveNewReport", C_Module, c_ErrorSave) Then Exit Function
  
  m_Id = register.Id
  
  If Not pSaveItemsParametros() Then Exit Function
  
  If Not register.CommitTrans() Then Exit Function
  
  pSaveNewReport = True
End Function

Private Function pGetRptpIdFromInfpId(ByVal Infp_id As Long, ByRef bFound As Boolean) As Long
  Dim param As cInformeParametro
  bFound = False
  For Each param In m_Parametros
    If param.Id = Infp_id Then
      pGetRptpIdFromInfpId = param.Rptp_id
      bFound = True
      Exit Function
    End If
  Next
End Function

Private Function pSaveItemsParametros() As Boolean
  pSaveItemsParametros = pSaveItemsParametrosAux(m_ObjWizard.Steps.Item(GetKey(c_StepShowParameters)).Properties.Item(c_Wiz_Key_Parameters))
End Function

Private Function pSaveItemsParametrosAux(ByRef iProp As cIABMProperty) As Boolean
  Dim register As cRegister
  
  With iProp
      
    Dim Row  As cIABMGridRow
    Dim Cell As cIABMGridCellValue
    
    For Each Row In .Grid.Rows
    
      Set register = New cRegister
      register.fieldId = cscRptpId
      register.Table = csTReporteParametro
      register.Id = csNew
      
      For Each Cell In Row
        Select Case Cell.key
          
          Case KI_INFP_ID
            register.Fields.Add2 cscInfpId, Val(Cell.Value), csId
          Case KI_DEFAULT
            register.Fields.Add2 cscRptpValor, Cell.Value, csText
          Case KI_VISIBLE
            register.Fields.Add2 cscRptpVisible, Cell.Id, csBoolean
          
          ' Si no esta editando esta columna no existe
          '
          Case KI_RPTP_ID
            register.Id = Val(Cell.Value)
        End Select
      Next
      
      ' Cuando el parametro es nuevo debo darle un valor por defecto
      '
      If register.Id = csNO_ID Then
        register.Fields.Add2 cscRptpValor, vbNullString, csText
      End If
      
      register.Fields.Add2 cscRptId, m_Id, csId
      
      register.Fields.HaveLastUpdate = True
      register.Fields.HaveWhoModify = True
      
      If Not gDB.Save(register, , "pSaveItemsParametrosAux", C_Module, c_ErrorSave) Then Exit Function
    Next
  End With
  
  pSaveItemsParametrosAux = True
End Function

Private Function pGetNombreRama(ByVal Tbl_id As Long, ByVal Ram_ID As Long, ByRef bExists As Boolean) As String
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  sqlstmt = "select ram_nombre from rama,arbol " & _
              " where rama.arb_id = arbol.arb_id " & _
                " and ram_id = " & Ram_ID & _
                " and tbl_id = " & Tbl_id
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  If rs.EOF Then Exit Function
  
  bExists = True
  
  pGetNombreRama = gDB.ValField(rs.Fields, cscRamNombre)
End Function

Private Function pIsEmptyRow(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  Dim bRowIsEmpty           As Boolean
  
  strRow = " (Fila " & RowIndex & ")"
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.key
      Case KI_NOMBRE
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KI_DEFAULT
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRow = bRowIsEmpty
End Function
' construccion - destruccion

Private Sub Class_Initialize()
#If PREPROC_DEBUG Then
  gdbInitInstance C_Module
#End If

  On Error GoTo ControlError
 
  c_ErrorSave = LNGGetText(2954, vbNullString) 'Error al grabar Reporte
 
  Set m_Properties = New cABMDocProperties
  Set m_Parametros = New cInformeParametros
  
  GoTo ExitProc
ControlError:
  MngError Err, "Class_Terminate", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
  On Error Resume Next
  
  Set m_ObjTree = Nothing
  Set m_ObjAbm = Nothing
  Set m_ObjAbmParams = Nothing
  Set m_ObjList = Nothing
  Set m_Properties = Nothing
  Set m_Parametros = Nothing
  'Set m_Resource = Nothing
  Set m_ObjWizard = Nothing

#If PREPROC_DEBUG Then
  gdbTerminateInstance C_Module
#End If
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

'/////////////////////////////////////////////////////////////////
Private Sub m_Report_Done()
  CloseProgressDlg
End Sub

Private Sub m_Report_Progress(ByVal Task As String, ByVal Page As Long, ByVal CurrRecord As Long, ByVal RecordCount As Long, ByRef Cancel As Boolean)

  DoEvents

  If m_CancelPrinting Then
    If Ask(LNGGetText(2741, vbNullString), vbNo) Then
            'Confirma que desea cancelar la ejecución del reporte
      Cancel = True
      CloseProgressDlg
      Exit Sub
    Else
      m_CancelPrinting = False
    End If
  End If

  If m_fProgress Is Nothing Then Exit Sub

  If Page > 0 Then m_fProgress.lbCurrPage.Caption = Page
  If LenB(Task) Then m_fProgress.lbTask.Caption = Task
  If CurrRecord > 0 Then m_fProgress.lbCurrRecord.Caption = CurrRecord
  If RecordCount > 0 And Val(m_fProgress.lbRecordCount.Caption) <> RecordCount Then m_fProgress.lbRecordCount.Caption = RecordCount

  Dim Percent As Double
  If RecordCount > 0 And CurrRecord > 0 Then
    Percent = CurrRecord / RecordCount
    On Error Resume Next
    m_fProgress.prgVar.Value = Percent * 100
  End If
  DoEvents
End Sub

Private Sub CloseProgressDlg()
  On Error Resume Next
  Unload m_fProgress
  Set m_fProgress = Nothing
End Sub

Private Sub ShowProgressDlg()
  m_CancelPrinting = False
  If m_fProgress Is Nothing Then Set m_fProgress = New fProgress
  m_fProgress.lbTask.Caption = m_Nombre
  m_fProgress.Show
  m_fProgress.ZOrder
End Sub

Private Sub m_fProgress_Cancel()
  m_CancelPrinting = True
End Sub

Private Sub pSetPoweredBy(ByRef Rpt As cReport)
  Dim ctl As cReportControl
  
  '-------------------------------------------
  ' Defino el titulo si no existe
  '
  For Each ctl In Rpt.Controls
    If ctl.Name = "Control21" Then
      If ctl.Label.Text = "Impreso por CrowSoft©" Then
        ctl.Label.Text = LNGGetText(3585, vbNullString) ' Powered by CrowSoft© - www.crowsoft.com.ar
      End If
    End If
  Next
End Sub

Private Function pGetEmail() As String
  Dim iProp As cIABMProperty

  For Each iProp In m_ObjAbmParams.Properties
    
    If iProp.PropertyType = cspHelp Then
      
      If iProp.Table = csCliente Then
        pGetEmail = GetEmailFromCliente(iProp.HelpId)
        Exit Function
      ElseIf iProp.Table = csProveedor Then
        pGetEmail = GetEmailFromProveedor(iProp.HelpId)
        Exit Function
      End If
    End If
  Next

End Function

Private Function pLoadUsePrinterSize()
  If Not m_bUsePrinterSizeLoaded Then
    
    Dim sqlstmt               As String
    Dim rs                    As ADODB.Recordset
    Dim claveUsePrinterSize   As String
    
    claveUsePrinterSize = c_UsePrinterSize & " Gral_" & User.Id
    
    sqlstmt = "select cfg_valor from configuracion where emp_id is null and cfg_grupo = " & _
                   gDB.sqlString(c_GrupoUsuarioConfig) & " and cfg_aspecto = " & gDB.sqlString(claveUsePrinterSize)
  
    If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function
    
    m_bUsePrinterSizeLoaded = True
    
    If Not rs.EOF Then
      m_bUsePrinterSize = Val(gDB.ValField(rs.Fields, cscCfgValor))
    End If
  End If
End Function

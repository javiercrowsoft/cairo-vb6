VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cProveedorCAIS"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSMenu.cIMenuClient
Implements CSInterfacesABM.cIWizardClient
'--------------------------------------------------------------------------------
' cProveedorCAIS
' 12-08-2003

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cProveedorCAIS"

Private Const c_StepWelcome             As Integer = 1
Private Const c_StepPath                As Integer = 4
Private Const c_StepShowProgress        As Integer = 5
Private Const c_StepShowResult          As Integer = 6


Private Const c_Wiz_Key_ProcImport = "PROCSESQ"

Private Const c_Wiz_Key_ProgressCount = "PROGRESSCOUNT"
Private Const c_Wiz_Key_ProgressCurrent = "PROGRESSCURRENT"
Private Const c_Wiz_Key_ProgressTime = "PROGRESSTIME"
Private Const c_Wiz_Key_ProgressLog = "PROGRESSLOG"
Private Const c_Wiz_Key_Progress = "PROGRESS"

Private Const c_Wiz_Key_ResultTitle = "RESULTT"
Private Const c_Wiz_Key_Result = "RESULT"

Private Const KW_PATH                        As Integer = 1
Private Const KW_VIEW_LOG                    As Integer = 2

Private Const c_path = "Path"
Private Const c_FechaDesde = "FechaDesde"
Private Const c_WizardTitle = "Importar Proveedores desde Strad"
' estructuras
' variables privadas
Private m_Host              As CSMenu.cIMenuHost
Private m_ObjWizard         As cIWizardGeneric

Private m_WizardProcessing        As Boolean
Private m_WizardCancel            As Boolean

Private m_Resource                        As fResource

Private m_NextCodigo As Long
' eventos
' propiedades publicas
' propiedades friend
' propiedades privadas
' funciones publicas
Private Function cIMenuClient_Initialize(F As Object, Host As CSMenu.cIMenuHost) As Boolean
  On Error GoTo ControlError

  Set m_Host = Host
  m_Host.Server.AddMenu "Importar Proveedores desde Strad", csPreR1361ImportProv, "I&nformes", 0, True, False, False, False, False, Me

  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, "cIMenuClient_Initialize", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal ID As Long) As Variant
  m_Host.MenuWizardClick "CSAFIPRes1361.cProveedorCAIS"
End Function

' Implementacion de cIWizardClient
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
  MngError Err, "cIWizardClient_Load", "cProveedorCAIS", ""
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
    Case c_StepPath

    Case c_StepShowProgress

      DoEvents
      pWizardProcess

      m_ObjWizard.DoNextStep c_StepShowProgress

    Case c_StepShowResult

      pWizardShowResult
  End Select

  cIWizardClient_Work = True

  GoTo ExitProc
ControlError:
  MngError Err, "cIWizardClient_Work", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
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

    Case c_StepWelcome
      nNextStep = c_StepPath

      ' Going to Second step, Enabled back
      m_ObjWizard.cmdBack.Enabled = True
      pSetEnabledNextPath

    Case c_StepPath

      If pGetPath = "" Then
        MsgWarning "Debe indicar una ruta a la base Stradivarius", c_WizardTitle
        Exit Function
      End If

      nNextStep = c_StepShowProgress
      m_ObjWizard.cmdBack.Enabled = False
      m_ObjWizard.cmdNext.Enabled = False
      pSaveLastPath
      pWizardShowProcess

    Case c_StepShowProgress
      nNextStep = c_StepShowResult

      m_ObjWizard.cmdBack.Enabled = True
      m_ObjWizard.cmdNext.Enabled = True
      m_ObjWizard.cmdNext.Caption = c_WizStr_Finish

      m_ObjWizard.cmdCancel.Enabled = False

    Case c_StepShowResult
      ' Finish, now close wizard
      m_ObjWizard.CloseWizard
      ' We return False to cancel pending steps in the generic Wizard's code
      Exit Function
  End Select

  cIWizardClient_NextStep = True

  GoTo ExitProc
ControlError:
  MngError Err, "cIWizardClient_NextStep", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Sub pSaveLastPath()
  CSKernelClient2.SetRegistry CSConfig, c_path, pGetPath
End Sub

Private Function cIWizardClient_PreviousStep(ByVal nCurrentStep As Integer, nNextStep As Integer) As Boolean
  Select Case nCurrentStep
    Case c_StepWelcome
      nNextStep = c_StepWelcome

    Case c_StepPath
      m_ObjWizard.cmdNext.Enabled = True
      nNextStep = c_StepWelcome

    Case c_StepShowProgress
      nNextStep = c_StepPath

    Case c_StepShowResult
      nNextStep = c_StepPath
      m_ObjWizard.cmdCancel.Enabled = True
      m_ObjWizard.cmdNext.Caption = c_WizStr_Next
  End Select

  cIWizardClient_PreviousStep = True
End Function

Private Function cIWizardClient_PropertyChange(ByVal Key As Integer) As Boolean
  Select Case Key
    Case KW_PATH
      pSetEnabledNextPath
    Case KW_VIEW_LOG
      pShowFileLog
    Case KW_CANCEL
      If m_WizardProcessing Then
        m_WizardCancel = True
      Else
        cIWizardClient_PropertyChange = True
      End If
  End Select
End Function

Private Function cIWizardClient_Terminate() As Boolean
  cIWizardClient_Terminate = True
  Unload m_Resource
  Set m_Resource = Nothing
End Function

Private Property Get cIWizardClient_Title() As String
  cIWizardClient_Title = c_WizardTitle
End Property

' funciones friend
' funciones privadas
Private Function LoadSteps() As Boolean
  Dim sh As Shape
  Set sh = m_ObjWizard.EditGeneric.ShapeMain

  If m_Resource Is Nothing Then Set m_Resource = New fResource

  sh.Move 0, 0, 9000, 5000
  sh.BorderStyle = 0
  sh.BackColor = vbWhite

  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjWizard.EditGeneric
  AbmObj.NotLockWnd = True

  Dim Img As Image
  Set Img = m_ObjWizard.EditGeneric.PicMain

  Img.Visible = False

  pLoadStepWelcome
  pLoadPath
  pLoadProcess
  pLoadResult

  LoadSteps = True
End Function

Private Sub pWizardProcess()
  On Error GoTo ControlError

  Dim i As Integer
  Dim msg As String
  Dim iProperties       As cIABMProperties
  Dim IsEmptyRecord     As Boolean
  Dim bError            As Boolean
  Dim startTime         As Date
  Dim RecordCount       As Long
  Dim RecordCountProv   As Long
  
  Dim Proveedor As Object
  
  Dim rsProveedores As Recordset
  Dim rsContado     As Recordset

  Dim rtn As Boolean
  
  Dim Mouse As cMouse
  Set Mouse = New cMouse
  Mouse.MouseSet vbHourglass

  m_WizardProcessing = True
  m_WizardCancel = False

  startTime = Now

  Set iProperties = m_ObjWizard.Steps(GetKey(c_StepShowProgress)).Properties

  pShowProgressBar 0
  iProperties(c_Wiz_Key_ProgressCount).Value = 0
  m_ObjWizard.ShowValue iProperties(c_Wiz_Key_ProgressCount)
  iProperties(c_Wiz_Key_ProgressCurrent).Value = 0
  m_ObjWizard.ShowValue iProperties(c_Wiz_Key_ProgressCurrent)

  pShowProcessTime startTime, iProperties

  InitLog

  With m_ObjWizard.Steps(GetKey(c_StepShowProgress))
    .Properties(c_Wiz_Key_ProgressLog).Value = ""
  End With

  pProcessLogSep
  pProcessLog "Cargando nuevos proveedores", LogSevInformation
  If Not pLoadProveedores(rsContado, rsProveedores) Then
    pProcessLog "Fallo al cargar los proveedores" & _
                vbCrLf & "Error: " & LastErrorDescription, LogSevError
    GoTo ExitProc
  End If

  pShowProcessTime startTime, iProperties

  iProperties(c_Wiz_Key_ProgressCount).Value = 0
  m_ObjWizard.ShowValue iProperties(c_Wiz_Key_ProgressCount)
  iProperties(c_Wiz_Key_ProgressCurrent).Value = 0
  m_ObjWizard.ShowValue iProperties(c_Wiz_Key_ProgressCurrent)

  If pUserCancel() Then GoTo ExitProc

  If Not (rsProveedores.EOF And rsProveedores.BOF) Then

    rsProveedores.MoveLast
    rsProveedores.MoveFirst

    RecordCountProv = rsProveedores.RecordCount
  End If
  
  RecordCount = RecordCountProv
  
  If Not (rsContado.EOF And rsContado.BOF) Then

    rsContado.MoveLast
    rsContado.MoveFirst

    RecordCount = RecordCountProv + rsContado.RecordCount
  End If
  
  iProperties(c_Wiz_Key_ProgressCount).Value = RecordCount
  m_ObjWizard.ShowValue iProperties(c_Wiz_Key_ProgressCount)
  
  Dim dbAccess As cDataBaseAccess
  Set dbAccess = New cDataBaseAccess
  
  While Not rsProveedores.EOF
    pShowProcessTime startTime, iProperties

    If Not dbAccess.Exists(gDB, rtn, "Proveedor", "prov_cuit = '" & ValField(rsProveedores.Fields, "NRCUIT") & "'") Then
      pProcessLog "Fallo al determinar si el proveedor existe en la base (" & ValField(rsProveedores.Fields, "NOMBRE") & ")" & _
                  vbCrLf & "Error: " & LastErrorDescription, LogSevError
      GoTo ExitProc
    End If

    If Not rtn Then
      Set Proveedor = CSKernelClient2.CreateObject("CSGeneral2.cProveedor")
      Proveedor.ID = csNO_ID
      Proveedor.Nombre = ValField(rsProveedores.Fields, "NOMBRE")
      Proveedor.cuit = ValField(rsProveedores.Fields, "NRCUIT")
  
      If Len(Proveedor.cuit) > 13 Then
        msg = "El proveedor " & Proveedor.Nombre & " posee un CUIT invalido" & _
                    vbCrLf & "CUIT: " & Proveedor.cuit
        'MsgWarning msg, "Importando Proveedores"
        pProcessLog msg, LogSevWarnning
      End If
      Proveedor.Codigo = ValField(rsProveedores.Fields, "NROCTA")
      Proveedor.Activo = True
      Proveedor.Razonsocial = Proveedor.Nombre
      Proveedor.Catfiscal = csCatFiscal.csCatFInscripto
      
      If Not Proveedor.Save() Then
        pProcessLog "Fallo al guardar el proveedor " & Proveedor.Nombre & _
                    vbCrLf & "Error: " & LastErrorDescription, LogSevError
        GoTo ExitProc
      End If
    End If
    
    pShowProgressBar (rsProveedores.AbsolutePosition / RecordCount) * 100
    DoEvents

    iProperties(c_Wiz_Key_ProgressCurrent).Value = rsProveedores.AbsolutePosition
    m_ObjWizard.ShowValue iProperties(c_Wiz_Key_ProgressCurrent)

    If pUserCancel() Then GoTo ExitProc

    rsProveedores.MoveNext
  Wend

  While Not rsContado.EOF
    pShowProcessTime startTime, iProperties

    If Not dbAccess.Exists(gDB, rtn, "Proveedor", "prov_cuit = '" & ValField(rsContado.Fields, "NRCUIT") & "'") Then
      pProcessLog "Fallo al determinar si el proveedor existe en la base (" & ValField(rsContado.Fields, "NOMBRE") & ")" & _
                  vbCrLf & "Error: " & LastErrorDescription, LogSevError
      GoTo ExitProc
    End If

    If Not rtn Then

      Set Proveedor = CSKernelClient2.CreateObject("CSGeneral2.cProveedor")
  
      Proveedor.ID = csNO_ID
      Proveedor.Nombre = ValField(rsContado.Fields, "NOMBRE")
      Proveedor.cuit = ValField(rsContado.Fields, "NRCUIT")
      
      If Len(Proveedor.cuit) > 13 Then
        msg = "El proveedor " & Proveedor.Nombre & " posee un CUIT invalido" & _
                    vbCrLf & "CUIT: " & Proveedor.cuit
        'MsgWarning msg, "Importando Proveedores"
        pProcessLog msg, LogSevWarnning
      End If
      Proveedor.Codigo = pGetNextCodigo
      Proveedor.Activo = True
      Proveedor.Razonsocial = Proveedor.Nombre
      Proveedor.Catfiscal = csCatFiscal.csCatFInscripto
      
      If Not Proveedor.Save() Then
        pProcessLog "Fallo al guardar el proveedor " & Proveedor.Nombre & _
                    vbCrLf & "Error: " & LastErrorDescription, LogSevError
        GoTo ExitProc
      End If
    End If
    
    pShowProgressBar ((rsContado.AbsolutePosition + RecordCountProv) / RecordCount) * 100
    DoEvents

    iProperties(c_Wiz_Key_ProgressCurrent).Value = RecordCountProv + rsContado.AbsolutePosition
    m_ObjWizard.ShowValue iProperties(c_Wiz_Key_ProgressCurrent)

    If pUserCancel() Then GoTo ExitProc

    rsContado.MoveNext
  Wend
  
  pShowProcessTime startTime, iProperties

  pProcessLogSep
  pProcessLog "El proceso se termino con éxito", LogSevInformation
  pProcessLogSep

  GoTo ExitProc
ControlError:
  MngError Err, "pWizardProcess", C_Module, ""
  If Err.Number <> 0 Then
    bError = True
    Resume ExitProc
  End If
ExitProc:
  On Error Resume Next

  m_WizardProcessing = False
  m_WizardCancel = False

  If bError Then
    pProcessLog "Error al procesar el informe" & _
                vbCrLf & "Error: " & LastErrorDescription, LogSevError
  End If
End Sub

Private Sub pWizardShowResult()
  Dim sLog As String

  With m_ObjWizard.Steps(GetKey(c_StepShowProgress))
    sLog = .Properties(c_Wiz_Key_ProgressLog).Value
  End With

  With m_ObjWizard.Steps(GetKey(c_StepShowResult))
    .Properties(c_Wiz_Key_Result).Value = sLog
    m_ObjWizard.ShowValue .Properties(c_Wiz_Key_Result)
    .Properties(c_Wiz_Key_ResultTitle).Value = "Resulado de la importacion de nuevos proveedores"
    m_ObjWizard.ShowValue .Properties(c_Wiz_Key_ResultTitle)
    Dim Prop As cABMProperty
    Set Prop = .Properties(c_Wiz_Key_Result)
    Prop.ctl.SelStart = Len(Prop.ctl.Text)
  End With
End Sub

Private Sub pSetEnabledNextPath()
  m_ObjWizard.cmdNext.Enabled = pGetPath <> ""
End Sub

Private Function pGetPath() As String
  pGetPath = m_ObjWizard.Steps(GetKey(c_StepPath)).Properties(c_path).Value
End Function

Private Function pGetFechaDesde() As String
  pGetFechaDesde = m_ObjWizard.Steps(GetKey(c_StepPath)).Properties(c_FechaDesde).Value
End Function

Private Sub pWizardShowProcess()
  With m_ObjWizard.Steps(GetKey(c_StepShowProgress))
    .Properties(c_Wiz_Key_ProcImport).Value = "Importando nuevos proveedores"
    m_ObjWizard.ShowValue .Properties(c_Wiz_Key_ProcImport)
  End With
End Sub

Private Sub pShowFileLog()
  CSKernelClient2.EditFile GetLogFile, 0
End Sub

Private Sub pLoadStepWelcome()
  ' La clave de los pasos debe ser la constante que los define
  ' Esto es vital para que la navegacion funcione correctamente
  With m_ObjWizard.Steps.Add(Nothing, GetKey(c_StepWelcome))
    With .Properties.Add(Nothing)
      .Name = ""
      .Top = 0
      .Left = 0
      .TopNotChange = True
      .LeftNotChange = True
      .PropertyType = cspImage
      Set .Picture = m_Resource.ImgWiz1.Picture
    End With

    With .Properties.Add(Nothing, c_Wiz_Key_Title)
      .Name = ""
      .Top = 100
      .Left = 2700
      .TopNotChange = True
      .LeftNotChange = True
      .Height = 880
      .Width = 6000
      .PropertyType = cspTitle
      .Value = "Bienvenido al Asistente de Importación de Nuevos Proveedores"
    End With
    With .Properties.Add(Nothing)
      .Top = 1200
      .Left = 3000
      .Name = ""
      .PropertyType = cspLabel
      .Width = 4500
      .Height = 880
      .FontBold = True
      .Value = "Con este asistente usted importará los proveedores que se hallan agregado a Stradivarius recientemente."
    End With
    With .Properties.Add(Nothing)
      .Name = ""
      .Top = 2400
      .Left = 3000
      .PropertyType = cspLabel
      .Value = "Para que la importación sea mas rapida podrá indicar la fecha desde la cual desea seleccionar proveedores de contado."
      .Width = 5000
    End With
  End With
End Sub

Private Sub pLoadPath()
  With m_ObjWizard.Steps.Add(Nothing, GetKey(c_StepPath))
    With .Properties.Add(Nothing)
      .Name = ""
      .Top = 0
      .Left = 0
      .TopNotChange = True
      .LeftNotChange = True
      .PropertyType = cspImage
      Set .Picture = m_Resource.ImgWiz1.Picture
    End With

    With .Properties.Add(Nothing)
      .Top = 800
      .Left = 3000
      .Name = ""
      .PropertyType = cspLabel
      .Width = 6000
      .Height = 880
      .FontBold = True
      .Value = "Indique la carpeta donde se encuantra la base Stradivarius y la fecha desde la que se cargarán los nuevos proveedores de operaciones de contado"
    End With
  
    With .Properties.Add(Nothing, c_path)
      .Top = 1800
      .Left = 4200
      .Name = "Carpeta"
      .PropertyType = cspFolder
      .Width = 3000
      .Value = CSKernelClient2.GetRegistry(CSConfig, c_path, "")
      .Key = KW_PATH
    End With
  
    With .Properties.Add(Nothing, c_FechaDesde)
      .Top = 2400
      .Left = 4200
      .Name = "Fecha Desde"
      .PropertyType = cspDate
      .Width = 3000
      .Value = VDGetDateById(csMonthLast_FirstDay)
    End With
  
  End With
End Sub

Private Sub pLoadProcess()
  With m_ObjWizard.Steps.Add(Nothing, GetKey(c_StepShowProgress))
    With .Properties.Add(Nothing)
      .Name = ""
      .Top = 100
      .Left = 200
      .TopNotChange = True
      .LeftNotChange = True
      .PropertyType = cspImage
      Set .Picture = m_Resource.ImgWiz5.Picture
    End With

    With .Properties.Add(Nothing, c_Wiz_Key_ProcImport)
      .Top = 200
      .Left = 800
      .Name = ""
      .PropertyType = cspLabel
      .Width = 5700
      .Height = 880
      .FontBold = True
      .FontSize = 10
    End With

    With .Properties.Add(Nothing)
      .Top = 650
      .Left = 800
      .Width = 7500
      .Name = ""
      .BackColor = vb3DHighlight
      .PropertyType = cspLabel
      .Value = ""
    End With

    With .Properties.Add(Nothing, c_Wiz_Key_ProgressCount)
      .Top = 700
      .Left = 3500
      .Name = "Son"
      .Width = 1000
      .LeftLabel = -500
      .PropertyType = cspNumeric
      .SubType = cspInteger
      .Value = "0"
    End With

    With .Properties.Add(Nothing, c_Wiz_Key_ProgressCurrent)
      .Top = 700
      .Left = 5500
      .LeftLabel = -500
      .Name = "Van"
      .Width = 1000
      .PropertyType = cspNumeric
      .SubType = cspInteger
      .Value = "0"
    End With

    With .Properties.Add(Nothing, c_Wiz_Key_ProgressTime)
      .Top = 700
      .Left = 6800
      .LeftLabel = -1
      .PropertyType = cspTime
      .Value = "0"
    End With

    With .Properties.Add(Nothing, c_Wiz_Key_ProgressLog)
      .Top = 1400
      .Left = 1000
      .Name = ""
      .PropertyType = cspText
      .SubType = cspMemo
      .Enabled = False
      .FontName = "Courier New"
      .BackColor = vbWindowBackground
      .Width = 7000
      .Height = 2500
      .LeftLabel = 10
    End With

    With .Properties.Add(Nothing, c_Wiz_Key_Progress)
      .Top = 4000
      .Left = 1000
      .Name = ""
      .PropertyType = cspProgressBar
      .Width = 7000
    End With
  End With
End Sub

Private Sub pLoadResult()
  With m_ObjWizard.Steps.Add(Nothing, GetKey(c_StepShowResult))

    With .Properties.Add(Nothing, c_Wiz_Key_ResultTitle)
      .Top = 200
      .Left = 800
      .Name = ""
      .PropertyType = cspLabel
      .Width = 5700
      .Height = 880
      .FontBold = True
      .FontSize = 10
    End With

    With .Properties.Add(Nothing)
      .Top = 1100
      .Left = 1000
      .Name = ""
      .PropertyType = cspLabel
      .Value = "Resultado"
    End With

    With .Properties.Add(Nothing, c_Wiz_Key_Result)
      .Top = 1400
      .Left = 1000
      .Name = ""
      .PropertyType = cspText
      .SubType = cspMemo
      .Enabled = True
      .BackColor = vbWindowBackground
      .FontName = "Courier New"
      .Width = 7000
      .Height = 2500
      .LeftLabel = 10
    End With

    With .Properties.Add(Nothing)
      .Top = 3970
      .Left = 7000
      .Name = "Ver Log"
      .Width = 1000
      .LeftLabel = 10
      .PropertyType = cspButton
      .Key = KW_VIEW_LOG
    End With

  End With
End Sub

Private Sub pShowProgressBar(ByVal Value As Integer)
  With m_ObjWizard.Steps(GetKey(c_StepShowProgress))
    .Properties(c_Wiz_Key_Progress).Value = Value
    m_ObjWizard.ShowValue .Properties(c_Wiz_Key_Progress)
  End With
End Sub

Private Sub pShowProcessTime(ByVal startTime As Date, ByRef iProperties As cIABMProperties)
  Dim Seconds As Long
  Dim Minutes As Long
  
  Seconds = DateDiff("s", startTime, Now)
  Minutes = Fix(Seconds / 60)
  Seconds = Seconds Mod 60
  
  iProperties(c_Wiz_Key_ProgressTime).Value = Minutes & ":" & Format(Seconds, "00")
  m_ObjWizard.ShowValue iProperties(c_Wiz_Key_ProgressTime)
End Sub

Private Sub pProcessLogSep()
  pProcessLog String(20, "-"), LogSevInformation
End Sub

Private Sub pProcessLog(ByVal msg As String, ByVal Severity As csInfoAFIPLogSeverity, Optional ByVal Module As String = C_Module)
  
  ' File
  If Severity = LogSevError Then
    SaveLog String(20, "-") & "Error" & String(20, "-")
  ElseIf Severity = LogSevWarnning Then
    SaveLog String(20, "-") & "Advertencia !!!"
  End If
  
  If InStr(1, msg, vbCrLf) > 1 Then
    SaveLog Module
    SaveLog msg
  Else
    If Len(Module) > 50 Then
      SaveLog Module & String(50 - Len(Module), " ") & msg
    Else
      SaveLog Module & "   " & msg
    End If
  End If
  
  If Severity = LogSevError Then
    SaveLog String(16, "-") & "Fin Error" & String(20, "-")
  ElseIf Severity = LogSevWarnning Then
    SaveLog String(16, "-") & "Fin Advertencia !!!"
  End If
  
  ' Window
  If Severity = LogSevError Then
    msg = vbCrLf & String(20, "-") & "Error" & String(20, "-") & vbCrLf & msg & vbCrLf & String(16, "-") & "Fin Error" & String(20, "-")
    
  ElseIf Severity = LogSevWarnning Then
    msg = vbCrLf & String(20, "-") & "Advertencia !!!" & vbCrLf & msg & vbCrLf & String(16, "-") & "Fin Advertencia !!!"
    
  End If
  
  With m_ObjWizard.Steps(GetKey(c_StepShowProgress))
    .Properties(c_Wiz_Key_ProgressLog).Value = Right$(.Properties(c_Wiz_Key_ProgressLog).Value & msg & vbCrLf, 30000)
    m_ObjWizard.ShowValue .Properties(c_Wiz_Key_ProgressLog)
    
    Dim Prop As cABMProperty
    Set Prop = .Properties(c_Wiz_Key_ProgressLog)
    Prop.ctl.SelStart = Len(Prop.ctl.Text)
  End With

End Sub

Private Function pLoadProveedores(ByRef rsContado As Recordset, ByRef rsProveedores As Recordset) As Boolean
  Dim StrConnect  As String
  
'  Dim CUITS As String
'
'  If Not pGetCUITS(CUITS) Then Exit Function
  
  StrConnect = "Provider=MSDASQL.1;Persist Security Info=False;" & _
               "Extended Properties=CollatingSequence=ASCII;" & _
               "DefaultDir=" & pGetPath() & ";" & _
               "Deleted=0;Driver={Microsoft dBase Driver (*.dbf)};" & _
               "DriverId=533;FIL=dBase 5.0;MaxBufferSize=2048;MaxScanRows=8;" & _
               "PageTimeout=600;SafeTransactions=0;Statistics=0;Threads=3;" & _
               "UID=admin;UserCommitSync=Yes;" & _
               "Initial Catalog=" & pGetPath()

  Dim db As cDataBase
  Set db = New cDataBase
  
  If Not db.InitDB(, , , , StrConnect) Then Exit Function
  
  Dim sqlstmt As String
  
  sqlstmt = "SELECT NROCTA, NOMBRE, NRCUIT FROM PVCL00"
  
'  If CUITS <> "" Then
'    sqlstmt = sqlstmt & " WHERE TRIM(NRCUIT) NOT IN (" & CUITS & ")"
'  End If
  
  If Not db.OpenRs(sqlstmt, rsProveedores) Then Exit Function
  
  Set rsProveedores.ActiveConnection = Nothing

  sqlstmt = "SELECT PVIC00.NOMBRE, PVIC00.NRCUIT FROM PVMV00"
  sqlstmt = sqlstmt & "  INNER JOIN PVIC00" & vbCrLf
  sqlstmt = sqlstmt & "      ON (PVMV00.NROMOV = PVIC00.NROMOV) " & vbCrLf
  sqlstmt = sqlstmt & "      AND (PVMV00.CODMOV = PVIC00.CODMOV)" & vbCrLf
  sqlstmt = sqlstmt & "  WHERE [PVMV00].[FCHMOV] >= " & Format(pGetFechaDesde, "yyyymmdd")
  
'  If CUITS <> "" Then
'    sqlstmt = sqlstmt & " AND NOT TRIM(NRCUIT) NOT IN (" & CUITS & ")"
'  End If
  
  If Not db.OpenRs(sqlstmt, rsContado) Then Exit Function
  
  Set rsContado.ActiveConnection = Nothing
  
  pLoadProveedores = True
End Function

Private Function pGetCUITS(ByRef CUITS As String) As Boolean
  Dim rs As Recordset
  Dim sqlstmt As String
  
  sqlstmt = "select prov_cuit from proveedor"
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  While Not rs.EOF
    CUITS = CUITS & "'" & rs.Fields.Item("prov_cuit").Value & "',"
    rs.MoveNext
  Wend
  
  CUITS = RemoveLastColon(CUITS)
  pGetCUITS = True
End Function

Private Function pUserCancel() As Boolean
  If m_WizardCancel Then
    
    If Ask("Desea cancelar el proceso", vbNo) Then
    
      pProcessLog "Proceso cancelado por el usuario", LogSevWarnning
    
      pUserCancel = True
    End If
  End If
  m_WizardCancel = False
End Function

Private Function pGetNextCodigo() As String
  If m_NextCodigo = 0 Then
    Dim sqlstmt As String
    Dim rs As ADODB.Recordset
    
    sqlstmt = "select max(prov_id) from proveedor"
    If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
    
    If Not rs.EOF Then m_NextCodigo = rs.Fields.Item(0).Value
  End If
  
  m_NextCodigo = m_NextCodigo + 1
  
  pGetNextCodigo = "CNT_" & m_NextCodigo
End Function

' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
  On Error GoTo ControlError

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Terminate", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
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
'  If Err.Number <> 0 Then Resume ExitProc
'ExitProc:
'  On Error Resume Next



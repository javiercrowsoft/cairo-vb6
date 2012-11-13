VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cImportacion"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGeneric
Implements CSInterfacesABM.cIABMClientGrid
Implements CSMenu.cIMenuClient
Implements CSInterfacesABM.cIWizardClient

'--------------------------------------------------------------------------------
' cImportacion
' 14-02-04

'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cImportacion"

Private Enum csLogSeverity
  LogSevInformation = 1
  LogSevWarnning = 2
  LogSevError = 3
End Enum

' Wizard
Private Const c_StepWelcome             As Integer = 1
Private Const c_StepOrigen              As Integer = 2
Private Const c_StepMapeo               As Integer = 3
Private Const c_StepShowProgress        As Integer = 7
Private Const c_StepShowResult          As Integer = 10

Private Const c_Wiz_Key_ResultTitle = "RESULTT"
Private Const c_Wiz_Key_Result = "RESULT"
Private Const c_Wiz_Key_ProgressCurrent = "VAN"
Private Const c_Wiz_Key_ProgressCount = "SON"
Private Const c_Wiz_Key_Progress = "PROGRESS"
Private Const c_Wiz_Key_ProgressLog = "PROGRESSLOG"
Private Const c_Wiz_Key_ProgressTime = "PROGRESSTIME"

Private Const KW_PATH                        As Integer = 1
Private Const KW_VIEW_LOG                    As Integer = 2
Private Const KW_TBLORIGEN                   As Integer = 3
Private Const KW_TBLDESTINO                  As Integer = 4
Private Const KW_MAPEO                       As Integer = 5
Private Const KW_GUARDAR                     As Integer = 6
Private Const KW_COPIAR                      As Integer = 7
Private Const KW_SQL                         As Integer = 8
               
Private Const c_Path = "Path"
Private Const c_Nombre = "Nombre"
Private Const c_Descrip = "Descrip"
Private Const c_TblOrigen = "TblOrigen"
Private Const c_Sqlstmt = "SqlStmt"
Private Const c_TblDestino = "TblDestino"
Private Const c_Mapeo = "Mapeo"
Private Const c_Origen = "Origen"
Private Const c_Guardar = "Guardar"
Private Const c_Copiar = "Copiar"

Private Const c_WizardTitle = "Asistente para importación de maestros"

' Campos
Private Const K_NOMBRE      As Integer = 1
Private Const K_CODIGO      As Integer = 2
Private Const K_ACTIVO      As Integer = 3
Private Const K_ITEMS       As Integer = 4

Private Const KI_IMPI_ID                        As Integer = 2
Private Const KI_CAMPOORIGEN                    As Integer = 3
Private Const KI_CAMPODESTINO                   As Integer = 4
Private Const KI_DEFAULT                        As Integer = 5

' estructuras
Private Type T_Defaults
  ColDestino As String
  Default    As String
End Type

Private Type T_FKeysInfo
  tblName         As String
  ColNameId       As String
  ColNameCodigo   As String
  ColFk           As String
End Type

Private Type T_Mapeo
  Destino         As String
  Origen          As String
End Type
' Seudo - Variables
Private c_ErrorSave           As String

' variables privadas
Private m_Id                  As Long
Private m_OrigenTabla         As String
Private m_OrigenPath          As String
Private m_DestinoTabla        As String
Private m_Nombre              As String
Private m_Sqlstmt             As String
Private m_Descrip             As String
Private m_Creado              As Date
Private m_Modificado          As Date
Private m_Modifico            As Long

'OJO HASTA ACA

Private m_Editing             As Boolean

Private m_ObjAbm              As cIABMGeneric
Private m_ObjTree             As Object

Private m_IsNew               As Boolean

Private m_BranchId            As Long
Private m_TreeId              As Long
Private m_Copy                As Boolean

Private m_Host As CSMenu.cIMenuHost

Private m_ObjWizard               As cIWizardGeneric

Private m_WizardProcessing        As Boolean
Private m_WizardCancel            As Boolean

'Private m_Resource                As fResource

Private Function pTerminate() As Boolean
  m_Editing = False
  
  pTerminate = True
  
  ' Este objeto puede no cumplir con la interfaz esperada, asi que si hay un error no
  ' le doy bola
  On Error GoTo ControlError
  If m_Id = csNO_ID Then Exit Function
  If m_ObjTree Is Nothing Then Exit Function
  
  If m_IsNew Then
    m_ObjTree.AddLeave m_Id, m_BranchId, m_TreeId
  Else
    m_ObjTree.AddEditedId m_Id
    m_ObjTree.RefreshActiveBranch
  End If
ControlError:
End Function

' Implementacion de cIEditGeneric

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
    cIEditGeneric_ShowList = SecurityCanAccess(csPreImpleListImportacion)
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
  If Not SecurityCanAccess(csPreImpleDeleteImportacion) Then Exit Function

  Dim sqlstmt As String
  
  sqlstmt = "delete ImportacionItem where imp_id = " & Id & vbCrLf
  sqlstmt = sqlstmt & "delete Importacion where imp_id = " & Id
  
  cIEditGeneric_Delete = gDB.Execute(sqlstmt, "cIEditGeneric_Delete", C_Module)
End Function

Private Function cIEditGeneric_Search(Id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Id = csNO_ID Then
    m_IsNew = True
    If Not SecurityCanAccess(csPreImpleNewImportacion) Then Exit Function
  Else
    m_IsNew = False
    If Not SecurityCanAccess(csPreImpleEditImportacion) Then Exit Function
  End If
  
  pShowStartWizard Id
  
  m_Editing = True
  cIEditGeneric_Edit = True
  Exit Function
ControlError:
  MngError Err, "cIEditGeneric_Edit", C_Module, vbNullString
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

Private Function cIEditGeneric_PropertyChange(ByVal Key As Integer) As Boolean

End Function

' Menu
Private Function cIMenuClient_Initialize(f As Object, Host As CSMenu.cIMenuHost) As Boolean
  On Error GoTo ControlError
  Dim str_3287  As String
  
  str_3287 = LNGGetText(3287, vbNullString) 'I&mplementación
  
  Set m_Host = Host
  m_Host.Server.AddMenu str_3287, csMenuEnum.csMenuMainImplementacion, vbNullString, 1, False, False, False, True, False, Nothing
  m_Host.Server.AddMenu LNGGetText(3288, vbNullString), csPreImpleListImportacion, str_3287, 0, True, False, False, False, False, Me
                        '&Importacion
  
  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, "cIMenuClient_Initialize", C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal Id As Long) As Variant
  m_Host.MenuABMClick "CSImplementacion2.cImportacion", Me, LNGGetText(3289, vbNullString), 0, csETablesImplementacion.csImportacion
                                                            'Importaciones
End Function

' Grid
Private Function cIABMClientGrid_ColumnAfterEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long) As Boolean
  cIABMClientGrid_ColumnAfterEdit = True
End Function

Private Function cIABMClientGrid_ColumnAfterUpdate(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long) As Boolean
  cIABMClientGrid_ColumnAfterUpdate = True
End Function

Private Function cIABMClientGrid_ColumnBeforeEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean
  cIABMClientGrid_ColumnBeforeEdit = True
End Function

Private Function cIABMClientGrid_ColumnButtonClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean
  cIABMClientGrid_ColumnButtonClick = True
End Function

Private Sub cIABMClientGrid_ColumnCancelEdit(ByVal Key As Integer)

End Sub

Private Sub cIABMClientGrid_ColumnClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Sub cIABMClientGrid_DblClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)

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


' Wizard
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

Private Function cIWizardClient_NextStep(ByVal nCurrentStep As Integer, nNextStep As Integer) As Boolean
  On Error GoTo ControlError

  Select Case nCurrentStep

    ' Este paso es el primero que se recibe
    ' su proposito es darle una oportunidad al cliente del wizard
    ' de indicar cual es el primer paso
    Case -1
      If m_Id = csNO_ID Then
        nNextStep = c_StepWelcome
      Else
        nNextStep = c_StepOrigen
      End If
      m_ObjWizard.cmdBack.Enabled = False
      
    Case c_StepWelcome
      nNextStep = c_StepOrigen
      m_ObjWizard.cmdNext.Enabled = False
      m_ObjWizard.cmdBack.Enabled = True
      
    Case c_StepOrigen
      nNextStep = c_StepMapeo
      m_ObjWizard.cmdBack.Enabled = True
      m_ObjWizard.cmdNext.Enabled = True
    
    Case c_StepMapeo
      nNextStep = c_StepShowProgress
      m_ObjWizard.cmdBack.Enabled = False
      m_ObjWizard.cmdNext.Enabled = False
      
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
  MngError Err, "cIWizardClient_NextStep", C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Property Set cIWizardClient_ObjWizard(rhs As CSInterfacesABM.cIWizardGeneric)
  Set m_ObjWizard = rhs
End Property

Private Property Get cIWizardClient_ObjWizard() As CSInterfacesABM.cIWizardGeneric
  Set cIWizardClient_ObjWizard = m_ObjWizard
End Property

Private Function cIWizardClient_PreviousStep(ByVal nCurrentStep As Integer, nNextStep As Integer) As Boolean
  Select Case nCurrentStep
    Case c_StepWelcome
      nNextStep = c_StepWelcome

    Case c_StepOrigen
      nNextStep = c_StepWelcome
      m_ObjWizard.cmdBack.Enabled = False
      m_ObjWizard.cmdNext.Enabled = True
      
    Case c_StepMapeo
      nNextStep = c_StepOrigen
      m_ObjWizard.cmdNext.Enabled = True

    Case c_StepShowProgress
      m_ObjWizard.cmdNext.Enabled = True
      nNextStep = c_StepWelcome

    Case c_StepShowResult
      nNextStep = c_StepMapeo
      m_ObjWizard.cmdCancel.Enabled = True
      m_ObjWizard.cmdNext.Caption = c_WizStr_Next
  End Select

  cIWizardClient_PreviousStep = True
End Function

Private Function cIWizardClient_PropertyChange(ByVal Key As Integer) As Boolean
  Select Case Key
    Case KW_CANCEL
      If m_WizardProcessing Then
        m_WizardCancel = True
      Else
        cIWizardClient_PropertyChange = True
      End If
    Case KW_PATH
      pLoadTablasOrigen pGetPath
      pSetEnabledNextPath
    Case KW_TBLDESTINO, KW_TBLORIGEN, KW_SQL
      pSetEnabledNextPath
    Case KW_GUARDAR
      pSave
    Case KW_COPIAR
      Dim NewName As String
      If Not GetInput(NewName, "Ingrese el nombre") Then Exit Function
      pTerminate
      m_Copy = True
      pSetNombre NewName
      pSave
    Case KW_VIEW_LOG
      EditFile App.Path & LOG_NAME, 0
  End Select
End Function

Private Function cIWizardClient_Terminate() As Boolean
  pTerminate
  cIWizardClient_Terminate = True
  'Unload m_Resource
  'Set m_Resource = Nothing
End Function

Private Property Get cIWizardClient_Title() As String
  cIWizardClient_Title = c_WizardTitle
End Property

Private Function cIWizardClient_Work(ByVal CurrentStep As Integer, ByVal GoingToNext As Boolean) As Boolean
  On Error GoTo ControlError

  Select Case CurrentStep
    Case -1
    Case c_StepWelcome
      ' First step, Disable back
      m_ObjWizard.cmdBack.Enabled = False
      
    Case c_StepOrigen
      If GoingToNext Then pShowImportacion
      
    Case c_StepMapeo
      If GoingToNext Then
        If Not pLoadMapeoItem Then Exit Function
      End If
      
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
  MngError Err, "cIWizardClient_Work", C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Sub pShowImportacion()
  Dim iProp As cIABMProperty
  
  If m_Id = csNO_ID Then Exit Sub
  
  Set iProp = m_ObjWizard.Steps(GetKey(c_StepOrigen)).Properties(c_Descrip)
  iProp.Value = m_Descrip
  m_ObjWizard.ShowValue iProp
  
  Set iProp = m_ObjWizard.Steps(GetKey(c_StepOrigen)).Properties(c_Nombre)
  iProp.Value = m_Nombre
  m_ObjWizard.ShowValue iProp
  
  Set iProp = m_ObjWizard.Steps(GetKey(c_StepOrigen)).Properties(c_TblDestino)
  With iProp
    .HelpId = pGetTblId()
    .Value = m_DestinoTabla
  End With
  m_ObjWizard.ShowValue iProp
  
  Set iProp = m_ObjWizard.Steps(GetKey(c_StepOrigen)).Properties(c_Path)
  iProp.Value = m_OrigenPath
  m_ObjWizard.ShowValue iProp
  
  If Ask(LNGGetText(3290, vbNullString), vbYes) Then
          'Desea volver a cargar las tablas del origen?
    pLoadTablasOrigen m_OrigenPath
  End If
  
  Set iProp = m_ObjWizard.Steps(GetKey(c_StepOrigen)).Properties(c_TblOrigen)
  With iProp
    .ListWhoSetItem = csListText
    .ListText = m_OrigenTabla
  End With
  m_ObjWizard.ShowValue iProp
  
  Set iProp = m_ObjWizard.Steps(GetKey(c_StepOrigen)).Properties(c_Sqlstmt)
  iProp.Value = m_Sqlstmt
  m_ObjWizard.ShowValue iProp
End Sub

Private Function pGetTblId() As Long
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  sqlstmt = "select tbl_id from tabla where tbl_nombrefisico = '" & m_DestinoTabla & "'"
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  If rs.EOF Then Exit Function
  
  pGetTblId = rs.Fields(0)
End Function

Private Function LoadSteps() As Boolean
  Dim sh As Shape
  Set sh = m_ObjWizard.EditGeneric.ShapeMain

  'If m_Resource Is Nothing Then Set m_Resource = New fResource

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
  pLoadOrigen
  pLoadMapeo
  pLoadProcess
  pLoadResult

  LoadSteps = True
End Function

Private Sub pWizardProcess()
  On Error GoTo ControlError

  Dim i    As Long
  Dim msg  As String
  Dim iProperties       As cIABMProperties
  Dim bError            As Boolean
  
  
  Dim Mouse As cMouse
  Set Mouse = New cMouse
  Mouse.MouseSet vbHourglass

  m_WizardProcessing = True
  m_WizardCancel = False
  
  If Not pSave() Then
    bError = True
    GoTo ExitProc
  End If

  Set iProperties = m_ObjWizard.Steps(GetKey(c_StepShowProgress)).Properties

  Dim rs As ADODB.Recordset
  Dim RowId As Long
  Dim ColCodigo  As String
  Dim ColDestino As String
  Dim ColType    As csTypes
  Dim ColId     As String
  Dim tblName   As String
  Dim ColCodigoOrigen As String
  Dim sqlstmt         As String
  Dim Register        As cRegister
  Dim fld             As ADODB.Field
  Dim CollColType     As Collection
  Dim vMapeos()       As T_Mapeo
  Dim vDefaults()     As T_Defaults
  Dim Value           As Variant
  Dim vFkeysInfo()    As T_FKeysInfo
  Dim IndexCol        As Long
  Dim startTime       As Date
  Dim NextIndex       As Long
  Dim bHaveLastUpdate As Boolean
  Dim bHaveWhoModify  As Boolean
  
  Dim nOk             As Long
  Dim nFail           As Long
  Dim nWarning        As Long
  
  startTime = Now
  pShowProcessTime startTime, iProperties
  pShowProgressBar 0
  pResetLog
  
  pShowCount 0
  pShowCurrent 0
  
  pProcessLog LNGGetText(3291, vbNullString), LogSevInformation
              'Obteniendo datos
  pGetColCodigo ColCodigo, ColCodigoOrigen
  If ColCodigoOrigen = "" Then
    MsgWarning LNGGetText(3292, vbNullString)
                'Indique la columna en el origen que corresponde al campo código
    GoTo ExitProc
  End If
  
  Set rs = pGetRecordsetOrigen()

  pShowProcessTime startTime, iProperties
  
  If Not (rs.EOF And rs.BOF) Then rs.MoveFirst
  
  pGetColId ColId, tblName
    
  sqlstmt = "select " & ColId & " from " & tblName & " where " & ColCodigo & " = "
    
  pGetModifyAndUpdate bHaveLastUpdate, bHaveWhoModify, tblName
    
  Set CollColType = pGetColType(tblName)
  pGetColDestino vMapeos
  pGetDefaults vDefaults
  pGetFkeysInfo vFkeysInfo, tblName
  
  pShowCount pGetRecordCount(rs)
  
  pProcessLogSep
  pProcessLog LNGGetText(3293, vbNullString), LogSevInformation
              'Importando registros
  
  While Not rs.EOF

    pShowProcessTime startTime, iProperties
  
    If pUserCancel() Then GoTo ExitProc
    
    If IsNull(rs.Fields(ColCodigoOrigen)) Then
    
      pProcessLog LNGGetText(3294, vbNullString, rs.AbsolutePosition), LogSevError
                  'Registro sin Id (rs.AbsolutePosition)
      nFail = nFail + 1
    Else
    
    RowId = pGetRowId(ColCodigoOrigen, sqlstmt, rs)
    
    Set Register = New cRegister
    Register.fieldId = ColId
    Register.Table = tblName

    Register.Id = RowId
    
    For Each fld In rs.Fields
      NextIndex = 1
      While pColSelected(vMapeos, fld.Name, NextIndex)
        ColDestino = vMapeos(NextIndex).Destino
        ColType = CollColType(ColDestino)
        
        Value = pGetValue(gDB.ValField(rs.Fields, fld.Name), ColType)
        If pIsFkCol(ColDestino, vFkeysInfo, IndexCol) Then
          Value = pGetFkValue(ColDestino, gDB.ValField(rs.Fields, fld.Name), vFkeysInfo(IndexCol))
          ColType = csId
        End If
          
        Register.Fields.Add2 ColDestino, Value, ColType
        NextIndex = NextIndex + 1
      Wend
    Next
    
    For i = 1 To UBound(vDefaults)
      With vDefaults(i)
        ColType = CollColType(.ColDestino)
        
        Value = pGetValue(.Default, ColType)
        If pIsFkCol(.ColDestino, vFkeysInfo, IndexCol) Then
          Value = pGetFkValue(.ColDestino, .Default, vFkeysInfo(IndexCol))
        End If
        Register.Fields.Add2 .ColDestino, Value, ColType
      End With
    Next
    
    Register.Fields.HaveLastUpdate = bHaveLastUpdate
    Register.Fields.HaveWhoModify = bHaveWhoModify
    
    If Not gDB.Save(Register, , "pWizardProcess", C_Module, c_ErrorSave) Then
    
      pProcessLog LNGGetText(3295, vbNullString, rs.AbsolutePosition, LastErrorDescription), LogSevError
                'Falló el registro ( rs.AbsolutePosition ) error original:  LastErrorDescription
    
      If Ask(LNGGetText(3296, vbNullString), vbYes) Then
            'Desea continuar con la importación?
        nFail = nFail + 1
      Else
        bError = True
        GoTo EndProcess
      End If
    Else
      nOk = nOk + 1
    End If
    
    pShowCurrent rs.AbsolutePosition
    pShowProgressBar pGetProgress(rs)
    DoEvents
    
    End If
    
    rs.MoveNext
  Wend

EndProcess:

  pProcessLogSep
  pProcessLog LNGGetText(3297, vbNullString, pShowProcessTime(startTime, iProperties)), LogSevInformation
              '"El proceso demoró  & pShowProcessTime(startTime, iProperties)
  pProcessLogSep
  If nOk > 0 Then pProcessLog LNGGetText(3298, vbNullString, nOk), LogSevInformation
                              'Se importaron  & nOk &  registros
  If nFail > 0 Then pProcessLog LNGGetText(3299, vbNullString, nFail), LogSevInformation
                              'Hubo  & nFail &  registros que dieron error y no se importaron
  If nWarning > 0 Then pProcessLog LNGGetText(3300, vbNullString, nWarning), LogSevInformation
                              'Hubo & nWarning & registros que dieron mensajes de advertencia y se importaron
  pProcessLog LNGGetText(3301, vbNullString), LogSevInformation
              'El proceso se terminó con éxito
  pProcessLogSep

  GoTo ExitProc
ControlError:
  MngError Err, "pWizardProcess", C_Module, vbNullString
  If Err.Number <> 0 Then
    bError = True
    Resume ExitProc
  End If
ExitProc:
  On Error Resume Next

  m_WizardProcessing = False
  m_WizardCancel = False
End Sub

Private Sub pShowCurrent(ByVal Current As Long)
  Dim iProp As cIABMProperty
  Set iProp = m_ObjWizard.Steps(GetKey(c_StepShowProgress)).Properties(c_Wiz_Key_ProgressCurrent)
  iProp.Value = Current
  m_ObjWizard.ShowValue iProp
End Sub

Private Sub pShowCount(ByVal Count As Long)
  Dim iProp As cIABMProperty
  Set iProp = m_ObjWizard.Steps(GetKey(c_StepShowProgress)).Properties(c_Wiz_Key_ProgressCount)
  iProp.Value = Count
  m_ObjWizard.ShowValue iProp
End Sub

Private Sub pGetModifyAndUpdate(ByRef bHaveLastUpdate As Boolean, ByRef bHaveWhoModify As Boolean, ByVal tblName As String)
  Dim sqlstmt   As String
  Dim rs        As ADODB.Recordset
  Dim fld       As ADODB.Field
  
  sqlstmt = "select * from " & tblName & " where 1=2"
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  bHaveLastUpdate = False
  bHaveWhoModify = False
  
  For Each fld In rs.Fields
    If LCase(fld.Name) = cscModifico Then
      bHaveWhoModify = True
    ElseIf LCase(fld.Name) = cscModificado Then
      bHaveLastUpdate = True
    End If
  Next
End Sub

Private Sub pShowProgressBar(ByVal Value As Integer)
  With m_ObjWizard.Steps(GetKey(c_StepShowProgress))
    .Properties(c_Wiz_Key_Progress).Value = Value
    m_ObjWizard.ShowValue .Properties(c_Wiz_Key_Progress)
  End With
End Sub

Private Sub pProcessLogSep()
  pProcessLog String(20, "-"), LogSevInformation
End Sub

Private Sub pProcessLog(ByVal msg As String, ByVal Severity As csLogSeverity, Optional ByVal Module As String = C_Module)
  Dim str_3209  As String
  Dim str_3323  As String
  Dim str_3324  As String
  Dim str_3325  As String
  
  str_3209 = LNGGetText(3209, vbNullString) 'Error
  str_3323 = LNGGetText(3323, vbNullString) 'Advertencia !!!
  str_3324 = LNGGetText(3324, vbNullString) 'Fin Error
  str_3325 = LNGGetText(3324, vbNullString) 'Fin Advertencia !!!
  ' File
  If Severity = LogSevError Then
    SaveLog String(20, "-") & str_3209 & String(20, "-")
  ElseIf Severity = LogSevWarnning Then
    SaveLog String(20, "-") & str_3323
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
    SaveLog String(16, "-") & str_3324 & String(20, "-")
  ElseIf Severity = LogSevWarnning Then
    SaveLog String(16, "-") & str_3325
  End If
  
  ' Window
  If Severity = LogSevError Then
    msg = vbCrLf & String(20, "-") & str_3209 & String(20, "-") & vbCrLf & msg & vbCrLf & String(16, "-") & str_3324 & String(20, "-")
    
  ElseIf Severity = LogSevWarnning Then
    msg = vbCrLf & String(20, "-") & str_3323 & vbCrLf & msg & vbCrLf & String(16, "-") & str_3325
  End If
  
  With m_ObjWizard.Steps(GetKey(c_StepShowProgress))
    .Properties(c_Wiz_Key_ProgressLog).Value = Right$(.Properties(c_Wiz_Key_ProgressLog).Value & msg & vbCrLf, 30000)
    m_ObjWizard.ShowValue .Properties(c_Wiz_Key_ProgressLog)
    
    Dim Prop As cABMProperty
    Set Prop = .Properties(c_Wiz_Key_ProgressLog)
    Prop.ctl.SelStart = Len(Prop.ctl.Text)
  End With

End Sub

Private Sub pResetLog()
  With m_ObjWizard.Steps(GetKey(c_StepShowProgress))
    .Properties(c_Wiz_Key_ProgressLog).Value = ""
    m_ObjWizard.ShowValue .Properties(c_Wiz_Key_ProgressLog)
  End With
End Sub

Private Function pSave() As Boolean
  Dim tblName     As String
  Dim Register    As cRegister
  
  Set Register = New cRegister
  
  Register.fieldId = cscImpId
  Register.Table = csTImportacion
  
  If Not gDB.GetData("Tabla", "tbl_id", pGetDestino, "tbl_nombrefisico", tblName) Then Exit Function
  
  If m_Copy Then
    Register.Id = csNew
  Else
    Register.Id = m_Id
  End If
  
  Register.Fields.Add2 cscImpOrigenTabla, pGetOrigen, csText
  Register.Fields.Add2 cscImpSqlstmt, pGetSqlstmt, csText
  Register.Fields.Add2 cscImpOrigenPath, pGetPath, csText
  Register.Fields.Add2 cscImpDestinoTabla, tblName, csText
  Register.Fields.Add2 cscImpNombre, pGetNombre, csText
  Register.Fields.Add2 cscImpDescrip, pGetDescrip, csText
  
  Register.Fields.HaveLastUpdate = True
  Register.Fields.HaveWhoModify = True
  
  If Not Register.BeginTrans(gDB) Then Exit Function
  
  If Not gDB.Save(Register, , "pSave", C_Module, c_ErrorSave) Then Exit Function
  
  If Not pSaveItems(Register.Id) Then Exit Function
  
  If Not Register.CommitTrans() Then Exit Function
  
  m_Copy = False
  pSave = Load(Register.Id)
End Function

Private Function pSaveItems(ByVal Id As Long) As Boolean
  Dim Register As cRegister
  Dim IProperty As cIABMProperty
  
  Dim sqlstmt As String
  sqlstmt = "delete importacionItem where imp_id = " & Id

  If Not gDB.Execute(sqlstmt, "pSaveItems", C_Module) Then Exit Function
        
  Dim Row  As cIABMGridRow
  Dim Cell As cIABMGridCellValue
  
  Set IProperty = m_ObjWizard.Steps.Item(GetKey(c_StepMapeo)).Properties.Item(c_Mapeo)
  
  For Each Row In IProperty.Grid.Rows
  
    Set Register = New cRegister
    Register.fieldId = cscImpiId
    Register.Table = csTImportacionItem
    Register.Id = csNew
    
    For Each Cell In Row
      Select Case Cell.Key
        
        Case KI_IMPI_ID
          If m_Copy Then
            Register.Id = csNew
          Else
            Register.Id = Val(Cell.Value)
          End If
        Case KI_CAMPOORIGEN
          Register.Fields.Add2 cscImpiCampoOrigen, Cell.Value, csText
        Case KI_CAMPODESTINO
          Register.Fields.Add2 cscImpiCampoDestino, Cell.Value, csText
        Case KI_DEFAULT
          Register.Fields.Add2 cscImpiDefault, Cell.Value, csText
      End Select
    Next
    
    Register.Fields.Add2 cscImpId, Id, csId
    
    Register.Fields.HaveLastUpdate = True
    Register.Fields.HaveWhoModify = True
    
    If Not gDB.Save(Register, , "pSaveItems", C_Module, c_ErrorSave) Then Exit Function
  Next
  
  pSaveItems = True
End Function

Private Function pColSelected(ByRef vMapeos() As T_Mapeo, ByVal ColOrigen As String, ByRef NextIndex As Long) As Boolean
  Dim i As Long
  For i = NextIndex To UBound(vMapeos)
    If vMapeos(i).Origen = ColOrigen Then
      NextIndex = i
      pColSelected = True
      Exit Function
    End If
  Next
End Function

Private Function pGetFkValue(ByVal ColFk As String, ByVal Codigo As String, ByRef FkeysInfo As T_FKeysInfo) As Long
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  With FkeysInfo
    sqlstmt = "select " & .ColNameId & " from " & .tblName & " where " & .ColNameCodigo & " = " & gDB.sqlString(Codigo)
  End With
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  If rs.EOF Then Exit Function
  pGetFkValue = rs.Fields(0).Value
End Function

Private Function pIsFkCol(ByVal ColFk As String, ByRef vFkeysInfo() As T_FKeysInfo, ByRef IndexCol As Long) As Boolean
  Dim i       As Long
  
  For i = 1 To UBound(vFkeysInfo)
    If vFkeysInfo(i).ColFk = ColFk Then Exit For
  Next
  
  If i > UBound(vFkeysInfo) Then Exit Function
  
  IndexCol = i
  pIsFkCol = True
End Function

Private Function pGetValue(ByVal Value As Variant, ByVal ColType As csTypes) As Variant
  Select Case ColType
    Case csTypes.csBoolean
      pGetValue = CInt(CBool(Value))
    Case csTypes.csCurrency, csTypes.csDouble, csTypes.csInteger, csTypes.csLong, csTypes.csSingle
      pGetValue = Val(Value)
    Case csTypes.csText
      pGetValue = Trim(Value)
    Case csTypes.csDate, csTypes.csDateOrNull
      If Not IsDate(Value) Then
        pGetValue = csNoDate
      Else
        pGetValue = Value
      End If
  End Select
End Function

Private Sub pGetColDestino(ByRef vMapeos() As T_Mapeo)
  Dim iProp       As cIABMProperty
  Dim Row         As cIABMGridRow
  Dim ColName     As String
  Dim ColDestino  As String
  
  ReDim vMapeos(0)
  
  Set iProp = m_ObjWizard.Steps.Item(GetKey(c_StepMapeo)).Properties.Item(c_Mapeo)
  
  For Each Row In iProp.Grid.Rows
    ColName = pGetCellFromKey(Row, KI_CAMPOORIGEN).Value
    If LenB(ColName) Then
      ColDestino = pGetCellFromKey(Row, KI_CAMPODESTINO).Value
      ReDim Preserve vMapeos(UBound(vMapeos) + 1)
      With vMapeos(UBound(vMapeos))
        .Destino = ColDestino
        .Origen = ColName
      End With
    End If
  Next
End Sub

Private Sub pGetFkeysInfo(ByRef vFkeysInfo() As T_FKeysInfo, ByVal tblName As String)
  Dim rs As ADODB.Recordset
  Dim sqlstmt As String
  Dim i  As Long
  
  sqlstmt = "sp_fkeys @fktable_name = '" & tblName & "'"
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub

  ReDim vFkeysInfo(0)
  If rs.EOF Then Exit Sub

  rs.MoveLast
  rs.MoveFirst
  
  ReDim vFkeysInfo(rs.RecordCount)
  While Not rs.EOF
    i = i + 1
    With vFkeysInfo(i)
      .ColNameId = rs.Fields("PKCOLUMN_NAME").Value
      .tblName = rs.Fields("PKTABLE_NAME").Value
      .ColFk = rs.Fields("FKCOLUMN_NAME").Value
      .ColNameCodigo = pGetColCodigoFk(.tblName)
    End With
    rs.MoveNext
  Wend
End Sub

Private Function pGetColCodigoFk(ByVal tblName As String) As String
  Dim fld     As ADODB.Field
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  If LCase(tblName) = "usuario" Then
    pGetColCodigoFk = "us_nombre"
  Else
    sqlstmt = "select * from " & tblName & " where 1 = 2"
    
    If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
    
    For Each fld In rs.Fields
      If LCase(Right$(fld.Name, 6)) = "codigo" Then
        pGetColCodigoFk = fld.Name
        Exit Function
      End If
    Next
  End If
End Function

Private Sub pGetDefaults(ByRef vDefaults() As T_Defaults)
  Dim iProp     As cIABMProperty
  Dim Row       As cIABMGridRow
  Dim Default   As String
  
  ReDim vDefaults(0)
  
  Set iProp = m_ObjWizard.Steps.Item(GetKey(c_StepMapeo)).Properties.Item(c_Mapeo)
  
  For Each Row In iProp.Grid.Rows
    Default = pGetCellFromKey(Row, KI_DEFAULT).Value
    If LenB(Default) Then
      ReDim Preserve vDefaults(UBound(vDefaults) + 1)
      With vDefaults(UBound(vDefaults))
        .ColDestino = pGetCellFromKey(Row, KI_CAMPODESTINO).Value
        .Default = Default
      End With
    End If
  Next
End Sub

Private Function pGetColType(ByVal tblName As String) As Collection
  Dim rtn As Collection
  Dim sqlstmt As String
  Dim rs      As Recordset
  Dim fld     As ADODB.Field
  
  sqlstmt = "select * from " & tblName & " where 1 = 2"
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  Set rtn = New Collection
  
  For Each fld In rs.Fields

    Select Case fld.Type
      Case adLongVarChar, adLongVarWChar, adChar, adVarChar, adVarWChar, adWChar
        rtn.Add csTypes.csText, fld.Name
      Case adBigInt, adBinary, adInteger, adLongVarBinary, adSmallInt, adTinyInt, adUnsignedBigInt, adUnsignedInt, adUnsignedSmallInt, adUnsignedTinyInt
        rtn.Add csTypes.csLong, fld.Name
      Case adBoolean
        rtn.Add csTypes.csBoolean, fld.Name
      Case adCurrency, adSingle, adDecimal, adDouble, adNumeric
        rtn.Add csTypes.csDouble, fld.Name
      Case adDBTime, adDate, adDBDate
        rtn.Add csTypes.csDate, fld.Name
      Case adDBTimeStamp
        rtn.Add csTypes.csDate, fld.Name
    End Select
  Next
  
  Set pGetColType = rtn
End Function

Private Function pGetRowId(ByVal ColCodigoOrigen As String, ByVal sqlstmt As String, ByRef rsOrigen As ADODB.Recordset) As Long
  Dim rs As ADODB.Recordset
  Dim Codigo As String
  
  sqlstmt = sqlstmt & gDB.sqlString(rsOrigen.Fields(ColCodigoOrigen).Value)
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  If rs.EOF Then Exit Function
  pGetRowId = rs.Fields(0).Value
End Function

Private Sub pGetColId(ByRef ColId As String, ByRef tblName As String)
  Dim rs As ADODB.Recordset
  Dim sqlstmt As String
  
  If Not gDB.GetData("Tabla", "tbl_id", pGetDestino, "tbl_nombrefisico", tblName) Then Exit Sub
  
  sqlstmt = "sp_pKeys '" & tblName & "'"
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  If rs.EOF Then Exit Sub
  
  ColId = rs.Fields("COLUMN_NAME").Value
End Sub

Private Sub pGetColCodigo(ByRef ColCodigo As String, ByRef ColCodigoOrigen As String)
  Dim iProp     As cIABMProperty
  Dim Row       As cIABMGridRow
  Dim ColName   As String
  
  Set iProp = m_ObjWizard.Steps.Item(GetKey(c_StepMapeo)).Properties.Item(c_Mapeo)
  
  ColCodigo = pGetColCodigoName
  
  For Each Row In iProp.Grid.Rows
    ColName = pGetCellFromKey(Row, KI_CAMPODESTINO).Value
    If LCase(ColName) = LCase(ColCodigo) Then
      ColCodigo = ColName
      ColCodigoOrigen = pGetCellFromKey(Row, KI_CAMPOORIGEN).Value
      Exit For
    End If
  Next
End Sub

Private Function pGetColCodigoName() As String
  Dim ColCodigo As String
  
  If pGetDestino = csUsuario Then
    ColCodigo = "us_nombre"
  Else
    If Not gDB.GetData("Tabla", "tbl_id", pGetDestino, "tbl_campocodigo", ColCodigo) Then Exit Function
  End If
  pGetColCodigoName = ColCodigo
End Function

Private Function pGetRecordsetOrigen() As ADODB.Recordset
  On Error GoTo ControlError
  
  Dim errNumber  As Long
  Dim errDescrip As String
  Dim errSource  As String
  
  Dim rs    As ADODB.Recordset
  Dim Path  As String
  Dim IsAdo As Boolean
  Dim xlSheet As Object 'As Excel.Worksheet
  Dim xlBook  As Object 'As Excel.Workbook
  Dim sqlstmt As String
  
  Path = pGetPath
  
  sqlstmt = pGetSqlstmt
  If sqlstmt = "" Then
    sqlstmt = "select * from [" & pGetOrigen & "]"
  End If
  
  Dim FileEx As CSKernelFile.cFileEx
  Set FileEx = New CSKernelFile.cFileEx
  
  Select Case LCase(FileEx.FileGetFileExt(FileEx.FileGetName(Path)))
    Case "xls"
      Set xlSheet = pGetSheet(Path, xlBook)
      IsAdo = False
    Case "dbf"
      Set rs = pGetRsCamposOrigen(Path, False, sqlstmt)
      IsAdo = True
    Case "mdb"
      Set rs = pGetRsCamposOrigen(Path, True, sqlstmt)
      IsAdo = True
    Case Else
      If LCase(Left$(Path, 4)) = "dsn=" Or LCase(Left$(Path, 9)) = "provider=" Or LCase(Right$(Path, 4)) = ".udl" Then
        
        sqlstmt = pGetSqlstmt
        If sqlstmt = "" Then
          sqlstmt = "select * from " & pGetOrigen
        End If
        Set rs = pGetRsCamposOrigen(Path, False, sqlstmt)
        IsAdo = True
      End If
  End Select
  
  If Not IsAdo Then
    Dim i As Long
    Dim j As Long
    Dim RowEmpty As Long
    Dim ColEmpty As Long
    Dim ColName  As String
    Dim ColValue As String
    
    Set rs = New ADODB.Recordset
    
    pProcessLog LNGGetText(3302, vbNullString), LogSevInformation
                'Cargando datos desde Excel
    For i = 1 To 256
      ColName = Trim(xlSheet.Cells(1, i))
      If LenB(ColName) Then
        rs.Fields.Append ColName & " (" & Format(i, "00") & ")", adVarChar, 5000
        ColEmpty = 0
      Else
        ColEmpty = ColEmpty + 1
        If ColEmpty > 10 Then Exit For
      End If
    Next
    
    rs.Open
    
    Dim iProp As cIABMProperty
    Set iProp = m_ObjWizard.Steps(GetKey(c_StepShowProgress)).Properties(c_Wiz_Key_ProgressCurrent)
    
    For j = 2 To 65535
      RowEmpty = RowEmpty + 1
      For i = 1 To 256
        ColName = Trim(xlSheet.Cells(1, i))
        If LenB(ColName) Then
          ColValue = Trim(xlSheet.Cells(j, i))
          If LenB(ColValue) Then
            RowEmpty = 0
            Exit For
          End If
          ColEmpty = 0
        Else
          ColEmpty = ColEmpty + 1
          If ColEmpty > 10 Then
            RowEmpty = RowEmpty + 1
            Exit For
          End If
        End If
      Next
      
      If RowEmpty = 0 Then
        rs.AddNew
        For i = 1 To 256
          ColName = Trim(xlSheet.Cells(1, i))
          If LenB(ColName) Then
            ColName = ColName & " (" & Format(i, "00") & ")"
            ColValue = Trim(xlSheet.Cells(j, i))
            If LenB(ColValue) Then
              pSetValue rs.Fields(ColName), ColValue
            End If
          End If
        Next
      Else
        If RowEmpty > 10 Then Exit For
      End If
      
      iProp.Value = j
      m_ObjWizard.ShowValue iProp
    Next
  End If

  Set pGetRecordsetOrigen = rs

  GoTo CloseExcel
ControlError:

  errNumber = Err.Number
  errDescrip = Err.Description
  errSource = Err.Source
  
  Resume CloseExcel
CloseExcel:
  On Error GoTo 0
  If Not xlBook Is Nothing Then
    xlBook.Close False
  End If
  
  If errNumber <> 0 Then
    Err.Raise errNumber, errSource, errDescrip
  End If
End Function

Private Sub pSetValue(ByRef Field As ADODB.Field, ByVal Value As String)
  On Error Resume Next
  Err.Clear
  Field.Value = Value
  If Err.Number = -2147217887 Then
    Dim i      As Long
    
    If Field.Type = adVarChar Then
      For i = 1 To Len(Value)
        Field.Value = Field.Value & Mid(Value, i, 1)
      Next
    End If
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
    .Properties(c_Wiz_Key_ResultTitle).Value = LNGGetText(3303, vbNullString)
                                                'Resulado de la importación de Maestros
    m_ObjWizard.ShowValue .Properties(c_Wiz_Key_ResultTitle)
    Dim Prop As cABMProperty
    Set Prop = .Properties(c_Wiz_Key_Result)
    Prop.ctl.SelStart = Len(Prop.ctl.Text)
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
      .Name = ""
      .Top = 100
      .Left = 2700
      .TopNotChange = True
      .LeftNotChange = True
      .Height = 880
      .Width = 6000
      .PropertyType = cspTitle
      .Value = LNGGetText(3304, vbNullString)
                'Bienvenido al Asistente de Importación de Maestros
    End With
    With .Properties.Add(Nothing)
      .Top = 1200
      .Left = 3000
      .PropertyType = cspLabel
      .Width = 4500
      .Height = 880
      .FontBold = True
      .Value = LNGGetText(3305, vbNullString)
              'Con este Asistente usted importará los maestros desde archivos _
              Excel, Access o Dbase.
    End With
  End With
End Sub

Private Sub pLoadOrigen()
  With m_ObjWizard.Steps.Add(Nothing, GetKey(c_StepOrigen))
    With .Properties.Add(Nothing)
      .Top = 100
      .Left = 400
      .TopNotChange = True
      .LeftNotChange = True
      .PropertyType = cspImage
      .Value = 3
      'Set .Picture = m_Resource.ImgWiz3.Picture
    End With
    
    With .Properties.Add(Nothing)
      .Top = 300
      .Left = 1600
      .PropertyType = cspLabel
      .Width = 6000
      .Height = 880
      .FontBold = True
      .Value = LNGGetText(3306, vbNullString)
              'Ingrese un nombre para esta importación, indique la ubicación _
              del archivo a importar y la tabla destino
    End With
    
    With .Properties.Add(Nothing, c_Nombre)
      .Top = 1000
      .Left = 2200
      .Name = C_strNombre
      .PropertyType = cspText
      .Width = 5000
    End With
    
    With .Properties.Add(Nothing, c_Descrip)
      .Name = C_strDescrip
      .PropertyType = cspText
      .SubType = cspMemo
      .Width = 6820
    End With

    With .Properties.Add(Nothing, c_Path)
      .Name = LNGGetText(3307, vbNullString) 'Archivo origen
      .PropertyType = cspFile
      .HelpFilter = LNGGetText(3308, vbNullString)
                    'Archivos de datos|*.mdb;*.xls;*.dbf|Access|*.mdb|Excel|*.xls|DBase|*.dbf|OLEDB|*.udl
      .Width = 7000
      .Value = CSKernelClient2.GetRegistry(CSConfig, c_Path, "")
      .Key = KW_PATH
    End With
  
    With .Properties.Add(Nothing, c_TblOrigen)
      .Name = LNGGetText(3309, vbNullString)  'Tabla Origen
      .PropertyType = cspList
      .Width = 5000
      .Key = KW_TBLORIGEN
    End With
  
    With .Properties.Add(Nothing, c_Sqlstmt)
      .Name = LNGGetText(2276, vbNullString)  'Sqlstmt
      .Height = 880
      .PropertyType = cspText
      .SubType = cspMemo
      .Width = 5000
      .Key = KW_SQL
    End With
    
    With .Properties.Add(Nothing, c_TblDestino)
      .Name = LNGGetText(3310, vbNullString)  'Tabla Destino
      .PropertyType = cspHelp
      .Table = csTabla
      .Width = 5000
      .Key = KW_TBLDESTINO
    End With
  
  End With
End Sub

Private Sub pLoadMapeo()
  With m_ObjWizard.Steps.Add(Nothing, GetKey(c_StepMapeo))
    With .Properties.Add(Nothing)
      .Top = 100
      .Left = 400
      .TopNotChange = True
      .LeftNotChange = True
      .PropertyType = cspImage
      .Value = 3
      'Set .Picture = m_Resource.ImgWiz3.Picture
    End With
    
    With .Properties.Add(Nothing)
      .Top = 300
      .Left = 1600
      .PropertyType = cspLabel
      .Width = 6000
      .Height = 880
      .FontBold = True
      .Value = LNGGetText(3311, vbNullString)
              'Enlace los campos de la Tabla Destino con la Tabla Origen. Puede _
              indicar valores por defecto, dejar columnas del destino sin mapear _
              e indicar una columna del origen más de una vez.
    End With
    
    With .Properties.Add(Nothing, c_Mapeo)
      .Top = 1000
      .Left = 500
      .PropertyType = cspGrid
      .LeftLabel = -1
      .GridAdd = False
      .GridEdit = True
      .GridRemove = False
      .Height = 3000
      .Width = 8700
      .Key = KW_MAPEO
    End With
  
    With .Properties.Add(Nothing, c_Guardar)
      .PropertyType = cspButton
      .Name = LNGGetText(3315, vbNullString) 'Guardar
      .LeftLabel = -1
      .Top = 200
      .Left = 8000
      .Width = 1200
      .Key = KW_GUARDAR
    End With
  
    With .Properties.Add(Nothing, c_Copiar)
      .PropertyType = cspButton
      .Name = LNGGetText(3316, vbNullString) 'Guardar Como
      .LeftLabel = -1
      .Top = 550
      .Left = 8000
      .Width = 1200
      .Key = KW_COPIAR
    End With
  End With
End Sub

Private Function pLoadMapeoItem() As Boolean
  Dim iProp As cIABMProperty
  Dim sqlstmt As String
  Dim rs As ADODB.Recordset
  Dim o As cIABMGridColumn
  
  Set iProp = m_ObjWizard.Steps.Item(GetKey(c_StepMapeo)).Properties.Item(c_Mapeo)

  sqlstmt = "sp_Columns " & gDB.sqlString(pGetDestinoNombre)
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadMapeoItem", C_Module) Then Exit Function
  
  iProp.Grid.Columns.Clear
  iProp.Grid.Rows.Clear
  
  Set o = iProp.Grid.Columns.Add(Nothing)
  o.Visible = False
  o.Key = KI_IMPI_ID
  
  Set o = iProp.Grid.Columns.Add(Nothing)
  o.Name = LNGGetText(3312, vbNullString) 'Valor por defecto
  o.PropertyType = cspText
  o.Width = 2500
  o.Key = KI_DEFAULT
  
  Set o = iProp.Grid.Columns.Add(Nothing, c_Origen)
  o.Name = LNGGetText(3313, vbNullString) 'Columna Origen
  o.PropertyType = cspList
  o.Width = 3000
  o.Key = KI_CAMPOORIGEN
  
  pLoadCamposOrigen o
  
  Set o = iProp.Grid.Columns.Add(Nothing)
  o.Name = LNGGetText(3314, vbNullString) 'Columna Destino
  o.PropertyType = cspText
  o.Width = 3000
  o.Key = KI_CAMPODESTINO
  
  Dim f  As cIABMGridRow
  Dim fv As cIABMGridCellValue
  Dim ColName As String
  
  While Not rs.EOF
    ColName = gDB.ValField(rs.Fields, "COLUMN_NAME")
    If ColName <> cscModificado And ColName <> cscModifico Then
  
      Set f = iProp.Grid.Rows.Add(Nothing)
      
      Set fv = f.Add(Nothing)
      fv.Value = csNew
      fv.Key = KI_IMPI_ID
      
      Set fv = f.Add(Nothing)
      fv.Value = ""
      fv.Key = KI_DEFAULT
  
      Set fv = f.Add(Nothing)
      fv.Value = ""
      fv.Key = KI_CAMPOORIGEN
      
      Set fv = f.Add(Nothing)
      fv.Value = gDB.ValField(rs.Fields, "COLUMN_NAME")
      fv.Key = KI_CAMPODESTINO
    End If
    
    rs.MoveNext
  Wend
  
  If m_Id <> csNO_ID Then
    pLoadMapeoFromDb iProp
  End If
  
  m_ObjWizard.ShowValue iProp
  
  pLoadMapeoItem = True
End Function

Private Sub pLoadMapeoFromDb(ByRef iProp As cIABMProperty)
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  Dim Row     As cIABMGridRow
  Dim List       As cIABMList
  Dim ListItem   As cIABMListItem
  Dim Origen     As String
  Dim Default    As String
  Dim bFound     As Boolean
  
  sqlstmt = "select * from ImportacionItem where imp_id = " & m_Id
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  Set List = iProp.Grid.Columns(c_Origen).List
  
  While Not rs.EOF
    
    Origen = gDB.ValField(rs.Fields, cscImpiCampoOrigen)
    Default = gDB.ValField(rs.Fields, cscImpiDefault)
    
    If LenB(Origen) Or LenB(Default) Then
      For Each Row In iProp.Grid.Rows
        If LCase(pGetCellFromKey(Row, KI_CAMPODESTINO).Value) = LCase(gDB.ValField(rs.Fields, cscImpiCampoDestino)) Then
          If LenB(Origen) Then
            bFound = False
            For Each ListItem In List
              If LCase(ListItem.Value) = LCase(Origen) Then
                pGetCellFromKey(Row, KI_CAMPOORIGEN).Value = Origen
                bFound = True
                Exit For
              End If
            Next
            
            If Not bFound And Right$(Origen, 1) = ")" And Left$(Right$(Origen, 4), 1) = "(" And IsNumeric(Left$(Right$(Origen, 3), 2)) Then
              For Each ListItem In List
                If Len(ListItem.Value) - 4 > 0 Then
                  If LCase(Mid(ListItem.Value, 1, Len(ListItem.Value) - 4)) = LCase(Mid(Origen, 1, Len(Origen) - 4)) Then
                    pGetCellFromKey(Row, KI_CAMPOORIGEN).Value = ListItem.Value
                    Exit For
                  End If
                End If
              Next
            End If
            
            Exit For
          Else
            pGetCellFromKey(Row, KI_DEFAULT).Value = Default
            Exit For
          End If
        End If
      Next
    End If
    
    rs.MoveNext
  Wend
End Sub

Private Sub pLoadCamposOrigen(ByVal o As cIABMGridColumn)
  On Error GoTo ControlError
  
  Dim errNumber  As Long
  Dim errDescrip As String
  Dim errSource  As String
  
  Dim rs    As ADODB.Recordset
  Dim Path  As String
  Dim IsAdo As Boolean
  Dim xlSheet As Object 'As Excel.Worksheet
  Dim xlBook  As Object 'As Excel.Workbook
  Dim sqlstmt As String
  
  sqlstmt = pGetSqlstmt
  If sqlstmt = "" Then
    sqlstmt = "select * from [" & pGetOrigen & "] where 1=2"
  Else
     sqlstmt = pGetSqlstmt12(sqlstmt)
  End If
  
  Path = pGetPath
  
  Dim FileEx As CSKernelFile.cFileEx
  Set FileEx = New CSKernelFile.cFileEx
  
  Select Case LCase(FileEx.FileGetFileExt(FileEx.FileGetName(Path)))
    Case "xls"
      Set xlSheet = pGetSheet(Path, xlBook)
      IsAdo = False
    Case "dbf", "udl"
      Set rs = pGetRsCamposOrigen(Path, False, sqlstmt)
      IsAdo = True
    Case "mdb"
      Set rs = pGetRsCamposOrigen(Path, True, sqlstmt)
      IsAdo = True
    Case Else
      If LCase(Left$(Path, 4)) = "dsn=" Or LCase(Left$(Path, 9)) = "provider=" Or LCase(Right$(Path, 4)) = ".udl" Then
        sqlstmt = pGetSqlstmt
        If sqlstmt = "" Then
          sqlstmt = "select * from " & pGetOrigen & " where 1=2"
        Else
          sqlstmt = pGetSqlstmt12(sqlstmt)
        End If
        Set rs = pGetRsCamposOrigen(Path, False, sqlstmt)
        IsAdo = True
      End If
  End Select
  
  If IsAdo Then
    With o.List
      .Clear
      Dim f As Field
      For Each f In rs.Fields
        With .Add(Nothing)
          .Value = f.Name
        End With
      Next
    End With
  
  Else
    Dim i As Long
    Dim ColName As String
    With o.List
      .Clear
      For i = 1 To 256
        ColName = Trim(xlSheet.Cells(1, i))
        If LenB(ColName) Then
          With .Add(Nothing)
            .Value = ColName & " (" & Format(i, "00") & ")"
          End With
        End If
      Next
    End With
  End If

  With o.List.Add(Nothing)
    .Value = ""
  End With

  GoTo CloseExcel
ControlError:

  errNumber = Err.Number
  errDescrip = Err.Description
  errSource = Err.Source
  
  Resume CloseExcel
CloseExcel:
  On Error GoTo 0
  If Not xlBook Is Nothing Then
    xlBook.Close False
  End If
  
  If errNumber <> 0 Then
    Err.Raise errNumber, errSource, errDescrip
  End If
End Sub
                                                           'Excel.Workbook
Private Function pGetSheet(ByVal Path As String, ByRef xlBook As Object) As Object 'Excel.Worksheet
  Dim xlApp     As Object 'Excel.Application
  Dim IProperty As cIABMProperty
  Dim Mouse     As cMouseWait
  
  Set Mouse = New cMouseWait
  DoEvents
  
  Set xlApp = CreateObject("Excel.Application")
  Set xlBook = xlApp.Workbooks.Open(Path)
  
  Set pGetSheet = xlBook.Worksheets(pGetOrigen)
End Function

Private Function pGetRsCamposOrigen(ByVal Path As String, ByVal IsAccess As Boolean, ByVal sqlstmt As String) As ADODB.Recordset
  Dim db        As cDataBase
  Dim IProperty As cIABMProperty
  Dim Mouse     As cMouseWait
  Dim rs        As ADODB.Recordset
  
  Set Mouse = New cMouseWait
  DoEvents
  
  Set db = New cDataBase
  
  If IsAccess Then
    If Not db.InitDB(Path) Then Exit Function
  
  Else
    Dim sconnect As String
    
    If LCase(Left$(Path, 4)) = "dsn=" Or LCase(Left$(Path, 9)) = "provider=" Or LCase(Right$(Path, 4)) = ".udl" Then
    
      sconnect = Path
    
    Else
    
      Dim FileEx As CSKernelFile.cFileEx
      Set FileEx = New CSKernelFile.cFileEx
    
      sconnect = "Provider=MSDASQL.1;Persist Security Info=False;" & _
                  "Extended Properties=CollatingSequence=ASCII;" & _
                  "DefaultDir=" & FileEx.FileGetPath(Path) & ";" & _
                  "Deleted=0;Driver={Microsoft dBase Driver (*.dbf)};" & _
                  "DriverId=533;FIL=dBase 5.0;MaxBufferSize=2048;MaxScanRows=8;" & _
                  "PageTimeout=600;SafeTransactions=0;Statistics=0;Threads=3;" & _
                  "UID=admin;UserCommitSync=Yes;" & _
                  "Initial Catalog=" & FileEx.FileGetPath(Path)
    End If
    
    If Not db.InitDB(, , , , sconnect) Then Exit Function
    
    If LCase(Left$(Path, 4)) = "dsn=" Then
      db.Execute "set isolation to dirty read;"
    End If
  End If
  
  db.OpenRs sqlstmt, rs
  
  db.DisconnectRecordset rs
    
  Set pGetRsCamposOrigen = rs
End Function

Private Sub pLoadProcess()
  With m_ObjWizard.Steps.Add(Nothing, GetKey(c_StepShowProgress))
    With .Properties.Add(Nothing)
      .Name = ""
      .Top = 100
      .Left = 200
      .TopNotChange = True
      .LeftNotChange = True
      .PropertyType = cspImage
      .Value = 3
      'Set .Picture = m_Resource.ImgWiz3.Picture
    End With

    With .Properties.Add(Nothing)
      .Top = 300
      .Left = 1000
      .Value = LNGGetText(3317, vbNullString) 'Importando Datos
      .PropertyType = cspLabel
      .Width = 5700
      .Height = 880
      .FontBold = True
      .FontSize = 10
    End With

    With .Properties.Add(Nothing, c_Wiz_Key_ProgressCount)
      .Top = 900
      .Left = 3500
      .Name = LNGGetText(3318, vbNullString) 'Son
      .Width = 1000
      .LeftLabel = -500
      .PropertyType = cspNumeric
      .SubType = cspInteger
      .Value = "0"
    End With
  
    With .Properties.Add(Nothing, c_Wiz_Key_ProgressCurrent)
      .Top = 900
      .Left = 5500
      .LeftLabel = -500
      .Name = LNGGetText(2043, vbNullString) 'Van
      .Width = 1000
      .PropertyType = cspNumeric
      .SubType = cspInteger
      .Value = "0"
    End With

    With .Properties.Add(Nothing, c_Wiz_Key_ProgressTime)
      .Top = 900
      .Left = 6800
      .LeftLabel = -1
      .Width = 800
      .PropertyType = cspText
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
      .Value = LNGGetText(1118, vbNullString) 'Resultado
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
      .Name = LNGGetText(3319, vbNullString) 'Ver Log
      .Width = 1000
      .LeftLabel = 10
      .PropertyType = cspButton
      .Key = KW_VIEW_LOG
    End With

  End With
End Sub

Private Function pUserCancel() As Boolean
  If m_WizardCancel Then
    
    If Ask(LNGGetText(1665, vbNullString), vbNo) Then
          'Desea cancelar el proceso
      pUserCancel = True
    End If
  End If
  m_WizardCancel = False
End Function

Private Sub pShowStartWizard(ByVal Id As Long)
  On Error GoTo ControlError
  
  Dim oImport As cImportacion
  Set oImport = New cImportacion
  
  If Not oImport.Load(Id) Then Exit Sub

  Dim iEditGeneric As cIEditGeneric
  Set iEditGeneric = oImport
  Set iEditGeneric.ObjTree = m_ObjTree
  
  Dim iObjWizard As cIWizardGeneric
  Dim oObjWizard   As cWizardGeneric
  
  Set iObjWizard = CSKernelClient2.CreateObject("CSABMInterface2.cWizardGeneric")
  Set oObjWizard = iObjWizard
  Set oObjWizard.ObjClient = oImport
  
  iObjWizard.Show "CSImplementacion2.cImportacion"
  
  GoTo ExitProc
ControlError:
  MngError Err, "pShowStartWizard", C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub pSetEnabledNextPath()
  m_ObjWizard.cmdNext.Enabled = LenB(pGetPath) > 0 And (LenB(pGetOrigen) > 0 Or LenB(pGetSqlstmt) > 0) And pGetDestino <> csNO_ID And LenB(pGetNombre) > 0
End Sub

Private Function pGetDescrip() As String
  pGetDescrip = m_ObjWizard.Steps(GetKey(c_StepOrigen)).Properties(c_Descrip).Value
End Function

Private Function pSetNombre(ByVal rhs As String)
  m_ObjWizard.Steps(GetKey(c_StepOrigen)).Properties(c_Nombre).Value = rhs
End Function

Private Function pGetNombre() As String
  pGetNombre = m_ObjWizard.Steps(GetKey(c_StepOrigen)).Properties(c_Nombre).Value
End Function

Private Function pGetOrigen() As String
  pGetOrigen = m_ObjWizard.Steps(GetKey(c_StepOrigen)).Properties(c_TblOrigen).ListText
End Function

Private Function pGetSqlstmt() As String
  pGetSqlstmt = m_ObjWizard.Steps(GetKey(c_StepOrigen)).Properties(c_Sqlstmt).Value
End Function

Private Function pGetDestino() As Long
  pGetDestino = m_ObjWizard.Steps(GetKey(c_StepOrigen)).Properties(c_TblDestino).HelpId
End Function

Private Function pGetDestinoNombre() As String
  ' Obtengo el nombre real de la tabla
  '
  Dim tbl_id As Long
  Dim tblName As String
  
  tbl_id = m_ObjWizard.Steps(GetKey(c_StepOrigen)).Properties(c_TblDestino).HelpId
  If Not gDB.GetData("Tabla", "tbl_id", tbl_id, "tbl_nombrefisico", tblName) Then Exit Function
  pGetDestinoNombre = tblName
End Function

Private Function pGetPath() As String
  pGetPath = m_ObjWizard.Steps(GetKey(c_StepOrigen)).Properties(c_Path).Value
End Function

Private Sub pLoadTablasOrigen(ByVal Path As String)
  If Path = "" Then
    Dim IProperty As cIABMProperty
    
    Set IProperty = m_ObjWizard.Steps(GetKey(c_StepOrigen)).Properties(c_TblOrigen)
    IProperty.List.Clear
    
    IProperty.ListWhoSetItem = csListListIndex
    IProperty.ListListIndex = 0
    m_ObjWizard.ShowValue IProperty
    
    Exit Sub
  Else
  
    Dim FileEx As CSKernelFile.cFileEx
    Set FileEx = New CSKernelFile.cFileEx
  
    Select Case LCase(FileEx.FileGetFileExt(FileEx.FileGetName(Path)))
      Case "xls"
        pLoadExcel Path
      Case "dbf", "udl"
        pLoadADO Path, False
      Case "mdb"
        pLoadADO Path, True
      Case Else
        If LCase(Left$(Path, 4)) = "dsn=" Or LCase(Left$(Path, 9)) = "provider=" Or LCase(Right$(Path, 4)) = ".udl" Then
          pLoadADO Path, False
        Else
          MsgWarning LNGGetText(3320, vbNullString)
                    'El formato del archivo no es válido.;;Los archivos deben _
                    ser de formato Excel, Access o DBase.
        End If
    End Select
  End If
End Sub

Private Sub pLoadExcel(ByVal Path As String)
  Dim xlApp     As Object 'Excel.Application
  Dim xlBook    As Object 'Excel.Workbook
  Dim xlSheet   As Object 'Excel.Worksheet
  Dim IProperty As cIABMProperty
  Dim Mouse     As cMouseWait
  
  Set Mouse = New cMouseWait
  DoEvents
  
  Set xlApp = CreateObject("Excel.Application")
  Set xlBook = xlApp.Workbooks.Open(Path)
  
  Set IProperty = m_ObjWizard.Steps(GetKey(c_StepOrigen)).Properties(c_TblOrigen)
  IProperty.List.Clear
  
  For Each xlSheet In xlBook.Worksheets
    With IProperty.List.Add(Nothing)
      .Value = xlSheet.Name
    End With
  Next
  
  IProperty.ListWhoSetItem = csListListIndex
  IProperty.ListListIndex = 0
  
  xlBook.Close False

  m_ObjWizard.ShowValue IProperty
End Sub

Private Sub pLoadADO(ByVal Path As String, ByVal IsAccess As Boolean)
  Dim db        As cDataBase
  Dim IProperty As cIABMProperty
  Dim Mouse     As cMouseWait
  Dim sqlstmt   As String
  Dim rs        As ADODB.Recordset
  
  Dim FileEx As CSKernelFile.cFileEx
  Set FileEx = New CSKernelFile.cFileEx
  
  Set Mouse = New cMouseWait
  DoEvents
  
  Set IProperty = m_ObjWizard.Steps(GetKey(c_StepOrigen)).Properties(c_TblOrigen)
  IProperty.List.Clear
  
  Set db = New cDataBase
  
  If IsAccess Then
    If Not db.InitDB(Path) Then Exit Sub
    
    Set rs = db.OpenSchema(adSchemaTables)
    
    While Not rs.EOF
      With IProperty.List.Add(Nothing)
        .Value = gDB.ValField(rs.Fields, "TABLE_NAME")
      End With
      rs.MoveNext
    Wend
  
    IProperty.ListWhoSetItem = csListListIndex
    IProperty.ListListIndex = 0
  
  Else
  
    Dim sconnect As String
    
    If LCase(Left$(Path, 4)) = "dsn=" Or LCase(Left$(Path, 9)) = "provider=" Or LCase(Right$(Path, 4)) = ".udl" Then
    
      sconnect = Path
    
    Else
    
      sconnect = "Provider=MSDASQL.1;Persist Security Info=False;" & _
                  "Extended Properties=CollatingSequence=ASCII;" & _
                  "DefaultDir=" & FileEx.FileGetPath(Path) & ";" & _
                  "Deleted=0;Driver={Microsoft dBase Driver (*.dbf)};" & _
                  "DriverId=533;FIL=dBase 5.0;MaxBufferSize=2048;MaxScanRows=8;" & _
                  "PageTimeout=600;SafeTransactions=0;Statistics=0;Threads=3;" & _
                  "UID=admin;UserCommitSync=Yes;" & _
                  "Initial Catalog=" & FileEx.FileGetPath(Path)
    End If
    
    If Not db.InitDB(, , , , sconnect) Then Exit Sub
  
    Set rs = db.OpenSchema(adSchemaTables)
    
    While Not rs.EOF
      With IProperty.List.Add(Nothing)
        .Value = gDB.ValField(rs.Fields, "TABLE_NAME")
      End With
      rs.MoveNext
    Wend
  
    IProperty.ListWhoSetItem = csListText
    IProperty.ListText = FileEx.FileGetNameWithoutExt(Path)
  
  End If
  
  m_ObjWizard.ShowValue IProperty
End Sub

' funciones privadas
Public Function Load(ByVal Id As Long) As Boolean

  Dim sqlstmt As String

  sqlstmt = "select * from Importacion where imp_id = " & Id

  Dim rs As Recordset

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "Load", C_Module) Then Exit Function

  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.Fields, cscImpId)
    m_OrigenTabla = gDB.ValField(rs.Fields, cscImpOrigenTabla)
    m_OrigenPath = gDB.ValField(rs.Fields, cscImpOrigenPath)
    m_DestinoTabla = gDB.ValField(rs.Fields, cscImpDestinoTabla)
    m_Sqlstmt = gDB.ValField(rs.Fields, cscImpSqlstmt)
    m_Nombre = gDB.ValField(rs.Fields, cscImpNombre)
    m_Descrip = gDB.ValField(rs.Fields, cscImpDescrip)
    m_Creado = gDB.ValField(rs.Fields, cscCreado)
    m_Modificado = gDB.ValField(rs.Fields, cscModificado)
    m_Modifico = gDB.ValField(rs.Fields, cscModifico)

  Else
    m_Id = csNO_ID
    m_OrigenTabla = vbNullString
    m_OrigenPath = vbNullString
    m_DestinoTabla = vbNullString
    m_Sqlstmt = vbNullString
    m_Nombre = vbNullString
    m_Descrip = vbNullString
    m_Creado = csNoDate
    m_Modificado = csNoDate
    m_Modifico = 0

  End If

  Load = True
End Function

Private Function pGetCellFromKey(ByRef Row As cIABMGridRow, ByVal Key As Long) As cIABMGridCellValue
  Dim Cell    As cIABMGridCellValue
  For Each Cell In Row
    If Cell.Key = Key Then
      Set pGetCellFromKey = Cell
    End If
  Next
End Function

Private Function pShowProcessTime(ByVal startTime As Date, ByRef iProperties As cIABMProperties) As String
  Dim Seconds As Long
  Dim Minutes As Long
  Dim strTime As String
  
  Seconds = DateDiff("s", startTime, Now)
  Minutes = Fix(Seconds / 60)
  Seconds = Seconds Mod 60
  
  strTime = Minutes & ":" & Format(Seconds, "00")
  iProperties(c_Wiz_Key_ProgressTime).Value = strTime
  m_ObjWizard.ShowValue iProperties(c_Wiz_Key_ProgressTime)
  
  pShowProcessTime = strTime
End Function

Private Function pGetProgress(ByRef rs As ADODB.Recordset) As Double
  On Error Resume Next
  Dim rtn As Long
  
  Err.Clear
  
  rtn = (rs.AbsolutePosition / pGetRecordCount(rs)) * 100
  
  If Err.Number <> 0 Then rtn = 1
  
  pGetProgress = rtn
End Function

Private Function pGetRecordCount(ByRef rs As ADODB.Recordset) As Long
  On Error Resume Next
  Dim rtn As Long
  
  Err.Clear
  rtn = rs.RecordCount
  
  If Err.Number <> 0 Then rtn = 1
  
  pGetRecordCount = rtn
End Function

Private Function pGetSqlstmt12(ByVal sqlstmt As String) As String
  If InStr(1, sqlstmt, "order by", vbTextCompare) Or InStr(1, sqlstmt, "group by", vbTextCompare) Then
    Err.Raise vbObjectError + 1, C_Module, LNGGetText(3321, vbNullString)
                                          'No se puede incluir un ORDER BY ni un GROUP BY en la sentencia origen"
  End If
  If InStr(1, sqlstmt, "where", vbTextCompare) Then
    sqlstmt = sqlstmt & " and (1=2)"
  Else
    sqlstmt = sqlstmt & " where (1=2)"
  End If
  
  pGetSqlstmt12 = sqlstmt
End Function

' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  CSKernelClient2.Title = LNGGetText(1622, vbNullString) 'CrowSoft
  c_ErrorSave = LNGGetText(3322, vbNullString) 'Error al Importar el Registro
  
  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
  Set m_ObjAbm = Nothing
  Set m_ObjTree = Nothing
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

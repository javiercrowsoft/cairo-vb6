VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cAFIPEsquema"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGeneric
Implements CSInterfacesABM.cIABMClient
Implements CSMenu.cIMenuClient
Implements CSInterfacesABM.cIABMClientGrid
Implements CSInterfacesABM.cIWizardClient
Implements CSInterfacesInfoAFIP.cIAFIPEsquema
'--------------------------------------------------------------------------------
' cAFIPEsquema
' 01-06-03

'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones
    Private Declare Sub Sleep Lib "kernel32" (ByVal dwMilliseconds As Long)

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cAFIPEsquema"

Private Const c_WizardTitle = "Asistente de informes AFIP"

Private Const c_Wiz_Key_Esquema = "RDTSESQ"
Private Const c_Wiz_Key_ProcEsquema = "PROCSESQ"
Private Const c_Wiz_Key_Progress = "PROGRESS"
Private Const c_Wiz_Key_ProgressLog = "PROGRESSLOG"

Private Const c_Wiz_Key_ProgressFile = "PROGRESSFILE"
Private Const c_Wiz_Key_ProgressCount = "PROGRESSCOUNT"
Private Const c_Wiz_Key_ProgressCurrent = "PROGRESSCURRENT"
Private Const c_Wiz_Key_ProgressTime = "PROGRESSTIME"

Private Const c_Wiz_Key_ResultTitle = "RESULTT"
Private Const c_Wiz_Key_Result = "RESULT"

Private Const c_Key_LastEsq_ID = "InfoAFIP_ESQ_ID"
Private Const c_Key_LastEsqNombre = "InfoAFIP_ESQUEMA"
Private Const c_Key_LastPath = "InfoAFIP_PATH"
' Steps
Private Const c_StepWelcome             As Integer = 1
Private Const c_StepChoiceSchema        As Integer = 2
Private Const c_StepShowParameters      As Integer = 3
Private Const c_StepShowReadyToStar     As Integer = 4
Private Const c_StepShowProgress        As Integer = 5
Private Const c_StepShowResult          As Integer = 6


Private Const K_NOMBRE                         As Integer = 1
Private Const K_CODIGO                         As Integer = 2
Private Const K_DESCRIP                        As Integer = 3
Private Const K_ACTIVO                         As Integer = 4
Private Const K_ARCHIVOS                       As Integer = 5
Private Const K_TOOLBAR_ARCHIVOS               As Integer = 6
Private Const K_PARAMETROS                     As Integer = 7
Private Const K_TOOLBAR_PARAMETROS             As Integer = 8
Private Const K_OBJETO_DLL                     As Integer = 9

Private Const KI_AFPARAM_ID                     As Integer = 1
Private Const KI_TIPO                           As Integer = 3
Private Const KI_SUBTIPO                        As Integer = 4
Private Const KI_TABLAHELP                      As Integer = 5
Private Const KI_VALOR                          As Integer = 6
Private Const KI_AVANZADO                       As Integer = 7
Private Const KI_AFARCH_ID                      As Integer = 8
Private Const KI_NOMBRE                         As Integer = 9
Private Const KI_DESCRIP                        As Integer = 10
Private Const KI_SEPARADORREGISTRO              As Integer = 11
Private Const KI_OBJETOENTRADA                  As Integer = 12
Private Const KI_ACTIVO                         As Integer = 13

Private Const KW_ESQUEMA                        As Integer = 1
Private Const KW_VIEW_LOG                       As Integer = 2

Private Const c_ToolBarArchivos   As String = "ToolBarArchivos"
Private Const c_GridArchivos      As String = "ARCHIVOS"
Private Const c_GridParametros    As String = "PARAMETROS"
Private Const c_ToolBarParametros As String = "ToolBarParametros"
' estructuras
' Seudo - Variables
Private c_ErrorSave               As String

' variables privadas
Private m_Id                      As Long
Private m_Nombre                  As String
Private m_Codigo                  As String
Private m_Descrip                 As String
Private m_ObjetoDll               As String
Private m_Creado                  As Date
Private m_Modificado              As Date
Private m_Modifico                As Long
Private m_Activo                  As Boolean

'OJO HASTA ACA

Private m_WizardProcessing        As Boolean
Private m_WizardCancel            As Boolean

Private m_Parametros              As cAFIPParametros

Private m_Editing                 As Boolean

Private m_ObjAbm                  As cIABMGeneric
Private m_ObjTree                 As Object
Private m_ObjWizard               As cIWizardGeneric

Private m_IsNew                   As Boolean

Private m_Copy                   As Boolean

Private m_BranchId               As Long
Private m_TreeId                 As Long

Private m_Host As CSMenu.cIMenuHost

Private m_ItemsDeletedArchivos            As String
Private m_ItemsDeletedParametros          As String

Private m_Resource                        As fResource

Private m_File        As cFile

Private m_FileName              As String
Private m_SeparadorRegistro     As String
Private m_LinesInFile           As Long

' propiedades publicas
Public Property Get ID() As Long
  ID = m_Id
End Property

Public Property Let ID(ByVal RHS As Long)
  m_Id = RHS
End Property

Public Property Get Nombre() As String
  Nombre = m_Nombre
End Property

Public Property Let Nombre(ByVal RHS As String)
  m_Nombre = RHS
End Property

Public Property Get Codigo() As String
  Codigo = m_Codigo
End Property

Public Property Let Codigo(ByVal RHS As String)
  m_Codigo = RHS
End Property

Public Property Get Descrip() As String
  Descrip = m_Descrip
End Property

Public Property Let Descrip(ByVal RHS As String)
  m_Descrip = RHS
End Property

Public Property Get ObjetoDll() As String
  ObjetoDll = m_ObjetoDll
End Property

Public Property Let ObjetoDll(ByVal RHS As String)
  m_ObjetoDll = RHS
End Property

Public Property Get Creado() As Date
  Creado = m_Creado
End Property

Public Property Let Creado(ByVal RHS As Date)
  m_Creado = RHS
End Property

Public Property Get Modificado() As Date
  Modificado = m_Modificado
End Property

Public Property Let Modificado(ByVal RHS As Date)
  m_Modificado = RHS
End Property

Public Property Get Modifico() As Long
  Modifico = m_Modifico
End Property

Public Property Let Modifico(ByVal RHS As Long)
  m_Modifico = RHS
End Property

Public Property Get Activo() As Boolean
  Activo = m_Activo
End Property

Public Property Let Activo(ByVal RHS As Boolean)
  m_Activo = RHS
End Property
' propiedades privadas
' funciones publicas
Public Function Check(ByRef ESQ_ID As Long, ByRef Text As String) As Long
  Dim hlp As cHelp
  Set hlp = New cHelp
  
  With hlp.ValidateEx(csAFIPEsquema, Text, ESQ_ID)
    ESQ_ID = .ID
    If .Cancel Then
      Text = ""
    Else
      Text = .Value
    End If
  End With
  
  Check = ESQ_ID <> 0
End Function
' funciones friend
Friend Function AddArchivo(ByVal ID As Long) As Boolean
  RefreshArchivo ID
End Function

Friend Function RefreshArchivo(ByVal ID As Long) As Boolean
  Dim c As cIABMProperty
  Set c = m_ObjAbm.Properties(c_GridArchivos)
  If Not pLoadArchivos(c) Then Exit Function
  m_ObjAbm.RefreshControls False
End Function

Friend Function AddParametro(ByVal ID As Long) As Boolean
  RefreshParametro ID
End Function

Friend Function RefreshParametro(ByVal ID As Long) As Boolean
  Dim c As cIABMProperty
  Set c = m_ObjAbm.Properties(c_GridParametros)
  If Not pLoadParametros(c) Then Exit Function
  m_ObjAbm.RefreshControls False
End Function

Private Function cIABMClientGrid_IsEmptyRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_ARCHIVOS
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowArchivos(Row, RowIndex)
    Case K_PARAMETROS
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowParametros(Row, RowIndex)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_IsEmptyRow", C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

' cIAFIPEsquema
Private Function cIAFIPEsquema_AddLine(Campos As CSInterfacesInfoAFIP.cIAFIPCampos) As Boolean
  cIAFIPEsquema_AddLine = pAddLineToFile(m_FileName, Campos, m_SeparadorRegistro)
End Function

Private Property Get cIAFIPEsquema_LineCount() As Long
  cIAFIPEsquema_LineCount = m_LinesInFile
End Property

Private Sub cIAFIPEsquema_Log(ByVal Module As String, ByVal msg As String, ByVal Severity As CSInterfacesInfoAFIP.csInfoAFIPLogSeverity)
  pProcessLog msg, Severity, Module
End Sub

Private Property Let cIAFIPEsquema_NombreArchivo(ByVal RHS As String)

End Property

Private Property Get cIAFIPEsquema_NombreArchivo() As String

End Property

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
  MngError Err, "cIWizardClient_Load", C_Module, vbNullString
End Function

Private Property Set cIWizardClient_ObjWizard(RHS As CSInterfacesABM.cIWizardGeneric)
   Set m_ObjWizard = RHS
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
    Case c_StepChoiceSchema
    
    Case c_StepShowParameters
      
    Case c_StepShowReadyToStar
    
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

Private Function cIWizardClient_NextStep(ByVal nCurrentStep As Integer, nNextStep As Integer) As Boolean
  On Error GoTo ControlError
  
  Select Case nCurrentStep
  
    ' Este paso es el primero que se recibe
    ' su proposito es darle una oportunidad al cliente del wizard
    ' de indicar cual es el primer paso
    Case -1
      nNextStep = c_StepWelcome
      
    Case c_StepWelcome
      nNextStep = c_StepChoiceSchema
      
      ' Going to Second step, Enabled back
      m_ObjWizard.cmdBack.Enabled = True
      pSetEnabledNextChoiceEsquema
      
    Case c_StepChoiceSchema
      
      If pGetAFEsq_ID = csNO_ID Then
        MsgWarning LNGGetText(3360, vbNullString), c_WizardTitle
                    'Debe indicar un esquema
        Exit Function
      End If
      
      If Not Load(pGetAFEsq_ID) Then Exit Function
      
      ' We have to load Esquema's parameters and then show its
      If m_Parametros Is Nothing Then Set m_Parametros = New cAFIPParametros
      m_Parametros.Load pGetAFEsq_ID
      
      If m_Parametros.Count > 0 Then
        pWizardShowParametros
      Else
        ' Paso al siguiente paso
        m_ObjWizard.DoNextStep c_StepShowParameters
      End If
      
      pSaveLastEsquema
      
      nNextStep = c_StepShowParameters
      
    Case c_StepShowParameters
      nNextStep = c_StepShowReadyToStar
      pWizardShowReadyToStart
      
    Case c_StepShowReadyToStar
      nNextStep = c_StepShowProgress
      m_ObjWizard.cmdBack.Enabled = False
      m_ObjWizard.cmdNext.Enabled = False
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
  MngError Err, "cIWizardClient_NextStep", C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Sub pSaveLastEsquema()
  CSKernelClient2.SetRegistry CSConfig, c_Key_LastEsq_ID, pGetAFEsq_ID
  CSKernelClient2.SetRegistry CSConfig, c_Key_LastEsqNombre, pGetAFEsquema
End Sub

Private Function cIWizardClient_PreviousStep(ByVal nCurrentStep As Integer, nNextStep As Integer) As Boolean
  Select Case nCurrentStep
    Case c_StepWelcome
      nNextStep = c_StepWelcome
      
    Case c_StepChoiceSchema
      nNextStep = c_StepWelcome
      m_ObjWizard.cmdNext.Enabled = True
      
    Case c_StepShowParameters
      nNextStep = c_StepChoiceSchema
      
    Case c_StepShowReadyToStar
      nNextStep = c_StepShowParameters
      
    Case c_StepShowProgress
      nNextStep = c_StepShowReadyToStar
      
    Case c_StepShowResult
      nNextStep = c_StepShowParameters
      m_ObjWizard.cmdCancel.Enabled = True
      m_ObjWizard.cmdNext.Caption = c_WizStr_Next
  End Select
  
  cIWizardClient_PreviousStep = True
End Function

Private Function cIWizardClient_PropertyChange(ByVal Key As Integer) As Boolean
  Select Case Key
    Case KW_ESQUEMA
      pSetEnabledNextChoiceEsquema
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

' Implementacion de cIABMClient
Private Function cIABMClient_Copy() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True
  
  With m_ObjAbm.Properties(cscAfEsqCodigo)
    .Value = "C-" & .Value
  End With
  
  With m_ObjAbm.Properties(cscAfEsqNombre)
    .Value = "Copia de " & .Value
  End With
  
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscAfEsqCodigo)
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscAfEsqNombre)
  
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
  cIABMClient_CanAddDocDigital = m_Id <> csNO_ID
End Property

Private Property Get cIABMClient_CanCopy() As Boolean
  cIABMClient_CanCopy = True
End Property

Private Property Get cIABMClient_CanNew() As Boolean
  cIABMClient_CanNew = True
End Property

Private Function cIABMClient_ShowDocDigital() As Boolean
  On Error GoTo ControlError
  
  If m_Id = csNO_ID Then Exit Function
  
  Dim Doc As cDocDigital
  Set Doc = New cDocDigital

  Doc.ClientTable = csTAFIPEsquema
  Doc.ClientTableID = m_Id

  cIABMClient_ShowDocDigital = Doc.ShowDocs(gDB)

  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClient_ShowDocDigital", C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
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

Private Function cIABMClient_PropertyChange(ByVal Key As Integer) As Boolean
  Select Case Key
    Case K_TOOLBAR_ARCHIVOS
      pToolBarArchivosClick m_ObjAbm.Properties(c_ToolBarArchivos).Value
    Case K_TOOLBAR_PARAMETROS
      pToolBarParametrosClick m_ObjAbm.Properties(c_ToolBarParametros).Value
  End Select
End Function

Private Function cIABMClient_Save() As Boolean
  Dim realId   As Long
  Dim register As cRegister
  Set register = New cRegister
  register.fieldId = cscAfEsqId
  register.Table = csTAFIPEsquema
  
  Dim Archivos   As cAFIPArchivos
  Dim Parametros As cAFIPParametros

  ' Si voy a copiar tengo que levantar todo el esquema
  ' y cambiar todos sus ids y luego guardar
  If m_Copy Then
    register.ID = csNew
    Set Archivos = New cAFIPArchivos
    Set Parametros = New cAFIPParametros
    
    If Not Archivos.Load(m_Id) Then Exit Function
    If Not Parametros.Load(m_Id) Then Exit Function

    If Not Archivos.BeginCopy() Then Exit Function
    If Not Parametros.BeginCopy() Then Exit Function
  
  Else
    register.ID = m_Id
  End If
  
  Dim IProperty As cIABMProperty
  
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_NOMBRE
          register.Fields.Add2 cscAfEsqNombre, .Value, csText
        Case K_CODIGO
          register.Fields.Add2 cscAfEsqCodigo, .Value, csText
        Case K_DESCRIP
          register.Fields.Add2 cscAfEsqDescrip, .Value, csText
        Case K_ACTIVO
          register.Fields.Add2 cscActivo, .Value, csBoolean
        Case K_OBJETO_DLL
          register.Fields.Add2 cscAfEsqObjetoDll, .Value, csText
      End Select
    End With
  Next
  register.Fields.HaveLastUpdate = True
  register.Fields.HaveWhoModify = True
  
  If Not register.BeginTrans(gDB) Then Exit Function
  
  If Not gDB.Save(register, , "cIABMClient_Save", C_Module, c_ErrorSave) Then Exit Function
  
  realId = m_Id
  m_Id = register.ID
  
  If Not pSaveItemsArchivos() Then GoTo ExitProc
  If Not pSaveItemsParametros() Then GoTo ExitProc
  
  If m_Copy Then
    If Not Archivos.EndCopy(m_Id) Then GoTo ExitProc
    If Not Parametros.EndCopy(m_Id) Then GoTo ExitProc
  End If
  
  If Not register.CommitTrans() Then GoTo ExitProc
  
  realId = m_Id
  
  m_Copy = False
  cIABMClient_Save = Load(register.ID)
  
ExitProc:
  m_Id = realId
End Function

Private Function cIABMClient_Terminate() As Boolean
    m_Editing = False
    
    cIABMClient_Terminate = True
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

Private Property Get cIABMClient_Title() As String
    cIABMClient_Title = LNGGetText(3361, vbNullString) 'AFIP Esquemas
End Property

Private Function cIABMClient_Validate() As Boolean

  Dim IProperty As cIABMProperty

  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_NOMBRE
          If ValEmpty(.Value, csText) Then
            MsgInfo LNGGetText(1007, vbNullString) 'Debe indicar un nombre
            Exit Function
          End If
        Case K_CODIGO
          If ValEmpty(.Value, csText) Then
            MsgInfo LNGGetText(1008, vbNullString) 'Debe indicar un código
            Exit Function
          End If

      End Select
    End With
  Next

  cIABMClient_Validate = True
End Function

Private Property Get cIEditGeneric_ObjAbm() As CSInterfacesABM.cIABMGeneric
  Set cIEditGeneric_ObjAbm = m_ObjAbm
End Property

' Implementacion de cIEditGeneric

Private Function cIEditGeneric_TabClick(ByVal Index As Integer) As Boolean

End Function

Private Property Let cIEditGeneric_TreeId(ByVal RHS As Long)
    m_TreeId = RHS
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
    cIEditGeneric_ShowList = SecurityCanAccess(csInfoAFIPListAFIPEsquema)
End Function

Private Property Set cIEditGeneric_ObjAbm(RHS As CSInterfacesABM.cIABMGeneric)
    Set m_ObjAbm = RHS
End Property

Private Property Get cIEditGeneric_Editing() As Boolean
    cIEditGeneric_Editing = m_Editing
End Property

Private Function cIEditGeneric_Delete(ID As Long) As Boolean
    If Not SecurityCanAccess(csInfoAFIPDeleteAFIPEsquema) Then Exit Function

    Dim sqlstmt           As String
    Dim sqlstmtArchivo    As String
    Dim sqlstmtRegistro   As String
    
    gDB.BeginTransaction
    
    sqlstmtArchivo = "afarch_id in (select afarch_id from afiparchivo where afesq_id = " & ID & ")" & vbCrLf
    sqlstmtRegistro = "afreg_id in (select afreg_id from afipregistro where " & sqlstmtArchivo & ")" & vbCrLf
    
    sqlstmt = "Delete " & csTAFIPCampo & " where " & sqlstmtRegistro & vbCrLf
    sqlstmt = sqlstmt & "Delete " & csTAFIPRegistro & " where " & sqlstmtArchivo & vbCrLf
    sqlstmt = sqlstmt & "Delete " & csTAFIPArchivo & " where " & cscAfEsqId & " = " & ID & vbCrLf
    sqlstmt = sqlstmt & "Delete " & csTAFIPParametro & " where " & cscAfEsqId & " = " & ID & vbCrLf
    sqlstmt = sqlstmt & "Delete " & csTAFIPEsquema & " where " & cscAfEsqId & " = " & ID
    
    If gDB.Execute(sqlstmt, "cIEditGeneric_Delete", C_Module) Then
      cIEditGeneric_Delete = gDB.CommitTransaction
    Else
      gDB.RollBackTransaction
    End If
End Function

Private Function cIEditGeneric_Search(ID As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(ID As Long, Optional ByVal InModalWindow As Boolean) As Boolean
    On Error GoTo ControlError
    
    If ID = csNO_ID Then
        m_IsNew = True
        If Not SecurityCanAccess(csInfoAFIPNewAFIPEsquema) Then Exit Function
    Else
        m_IsNew = False
        If Not SecurityCanAccess(csInfoAFIPEditAFIPEsquema) Then Exit Function
    End If

    If Not Load(ID) Then Exit Function
    
    If Not LoadCollection() Then Exit Function
    
    m_Editing = True
    m_Copy = False
    
    cIEditGeneric_Edit = True
    Exit Function
ControlError:
    MngError Err, "cIEditGeneric_Edit", C_Module, vbNullString
End Function

Private Function cIEditGeneric_PrintObj(ByVal ID As Long) As Boolean

End Function

Private Property Set cIEditGeneric_ObjTree(RHS As Object)
    Set m_ObjTree = RHS
End Property

Private Property Let cIEditGeneric_BranchId(ByVal RHS As Long)
    m_BranchId = RHS
End Property

Private Property Get cIEditGeneric_BranchId() As Long
    cIEditGeneric_BranchId = m_BranchId
End Property

Private Function cIEditGeneric_Preview(ByVal ID As Long) As Boolean

End Function

Private Function cIEditGeneric_PropertyChange(ByVal Key As Integer) As Boolean

End Function

Private Function cIMenuClient_Initialize(f As Object, Host As CSMenu.cIMenuHost) As Boolean
  On Error GoTo ControlError
  Dim str_3362    As String
  
  
  str_3362 = LNGGetText(3362, vbNullString) 'I&nformes
  Set m_Host = Host
  m_Host.Server.AddMenu str_3362, csMenuEnum.csMenuInformes, vbNullString, 1, False, False, False, True, False, Nothing
  m_Host.Server.AddMenu LNGGetText(3363, vbNullString), csInfoAFIPListAFIPEsquema, str_3362, 0, True, False, False, False, False, Me
                        '&Definir Informe AFIP
  m_Host.Server.AddMenu LNGGetText(3364, vbNullString), csInfoAFIPMakeAFIPEsquema, str_3362, 0, True, False, False, False, False, Me
                        '&Procesar Informe AFIP
  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, "cIMenuClient_Initialize", C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal ID As Long) As Variant
  Select Case ID
    Case csInfoAFIPListAFIPEsquema
      m_Host.MenuABMClick "CSInfoAfip2.cAFIPEsquema", Me, LNGGetText(3361, vbNullString), 0, csETablesInfoAFIP.csAFIPEsquema
                                                          'AFIP Esquemas
    Case csInfoAFIPMakeAFIPEsquema
      If SecurityCanAccess(csInfoAFIPMakeAFIPEsquema) Then
        m_Host.MenuWizardClick "CSInfoAfip2.cAFIPEsquema"
      End If
  End Select
End Function

Private Function cIABMClientGrid_ColumnAfterUpdate(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long) As Boolean

End Function

Private Function cIABMClientGrid_ColumnAfterEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long) As Boolean
  cIABMClientGrid_ColumnAfterEdit = True
End Function

Private Function cIABMClientGrid_ColumnBeforeEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean
  cIABMClientGrid_ColumnBeforeEdit = True
End Function

Private Function cIABMClientGrid_ColumnButtonClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean

End Function

Private Sub cIABMClientGrid_ColumnCancelEdit(ByVal Key As Integer)

End Sub

Private Sub cIABMClientGrid_ColumnClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Sub cIABMClientGrid_DblClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)
  Select Case Key
    Case K_ARCHIVOS
      pToolBarArchivosClick "EDIT"
    Case K_PARAMETROS
      pToolBarParametrosClick "EDIT"
  End Select
End Sub

Private Function cIABMClientGrid_DeleteRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal lRow As Long) As Boolean
  Dim ID As Long
  
  If Key = K_ARCHIVOS Then
  
    ID = Val(pCell(Row, KI_AFARCH_ID).Value)
    
    If ID <> csNO_ID Then m_ItemsDeletedArchivos = m_ItemsDeletedArchivos & ID & ","
    
    cIABMClientGrid_DeleteRow = True

  ElseIf Key = K_PARAMETROS Then
  
    ID = Val(pCell(Row, KI_AFPARAM_ID).Value)
    
    If ID <> csNO_ID Then m_ItemsDeletedParametros = m_ItemsDeletedParametros & ID & ","
    
    cIABMClientGrid_DeleteRow = True
  End If
End Function

Private Function cIABMClientGrid_ListAdHock(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal ColIndex As Long, List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClientGrid_NewRow(ByVal Key As Integer, ByVal Rows As Integer)

End Sub

Private Function cIABMClientGrid_ValidateRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_ARCHIVOS
      cIABMClientGrid_ValidateRow = pValidateRowArchivos(Row, RowIndex)
    Case K_PARAMETROS
      cIABMClientGrid_ValidateRow = pValidateRowParametros(Row, RowIndex)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ValidateRow", C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pIsEmptyRowParametros(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim bRowIsEmpty           As Boolean
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_TIPO
        If Not ValEmpty(Cell.Value, csInteger) Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KI_NOMBRE
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowParametros = bRowIsEmpty
End Function

Private Function pValidateRowParametros(Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.Key
        Case KI_NOMBRE
          If ValEmpty(Cell.Value, csText) Then
            MsgInfo LNGGetText(1811, vbNullString, strRow) 'Debe indicar un nombre (1)
            Exit Function
          End If
        Case KI_TIPO
          If ValEmpty(Cell.Value, csInteger) Then
            MsgInfo LNGGetText(1813, vbNullString, strRow) 'Debe indicar un tipo (1)
            Exit Function
          End If
'        Case KI_SUBTIPO
'          If ValEmpty(Cell.Value, csInteger) Then
'            MsgInfo LNGGetText(3365, vbNullString, strRow) 'Debe indicar un Subtipo (1)
'            Exit Function
'          End If
'        Case KI_TABLAHELP
'          If ValEmpty(Cell.Value, csLong) Then
'            MsgInfo LNGGetText(3366, vbNullString, strRow) 'Debe indicar un Tablahelp (1)
'            Exit Function
'          End If
'        Case KI_VALOR
'          If ValEmpty(Cell.Value, csText) Then
'            MsgInfo LNGGetText(3367, vbNullString, strRow) 'Debe indicar un valor (1)
'            Exit Function
'          End If
    End Select
  Next
  
  pValidateRowParametros = True
End Function

Private Function pIsEmptyRowArchivos(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim bRowIsEmpty           As Boolean
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_OBJETOENTRADA
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KI_NOMBRE
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowArchivos = bRowIsEmpty
End Function

Private Function pValidateRowArchivos(Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.Key
        Case KI_NOMBRE
          If ValEmpty(Cell.Value, csText) Then
            MsgInfo LNGGetText(1811, vbNullString, strRow) 'Debe indicar un nombre (1)
            Exit Function
          End If
        Case KI_OBJETOENTRADA
          If ValEmpty(Cell.Value, csText) Then
            MsgInfo LNGGetText(3368, vbNullString, strRow) 'Debe indicar un Objeto de entrada(1)
            Exit Function
          End If
    End Select
  Next
  
  pValidateRowArchivos = True
End Function

Private Function pSaveItemsParametros() As Boolean
  Dim register As cRegister
  Dim IProperty As cIABMProperty
  
  pSaveItemsParametros = True
  Exit Function
  
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_PARAMETROS
        
          Dim Row  As cIABMGridRow
          Dim Cell As cIABMGridCellValue
          
          For Each Row In IProperty.Grid.Rows
          
            Set register = New cRegister
            register.fieldId = cscAfParamId
            register.Table = csTAFIPParametro
            register.ID = csNew
            
            For Each Cell In Row
              Select Case Cell.Key
                
                Case KI_AFPARAM_ID
                  If Not m_Copy Then
                    register.ID = Val(Cell.Value)
                  End If
                Case KI_NOMBRE
                  register.Fields.Add2 cscAfParamNombre, Cell.Value, csText
                Case KI_DESCRIP
                  register.Fields.Add2 cscAfParamDescrip, Cell.Value, csText
                Case KI_TIPO
                  register.Fields.Add2 cscAfParamTipo, Cell.ID, csInteger
                Case KI_SUBTIPO
                  register.Fields.Add2 cscAfParamSubTipo, Cell.ID, csInteger
                Case KI_TABLAHELP
                  register.Fields.Add2 cscAfParamTablaHelp, Cell.Value, csLong
                Case KI_VALOR
                  register.Fields.Add2 cscAfParamValor, Cell.Value, csText
                Case KI_AVANZADO
                  register.Fields.Add2 cscAfParamAvanzado, Cell.ID, csBoolean
                Case KI_ACTIVO
                  register.Fields.Add2 cscActivo, Cell.ID, csBoolean

              End Select
            Next
            
            register.Fields.Add2 cscAfEsqId, m_Id, csId
            
            register.Fields.HaveLastUpdate = True
            register.Fields.HaveWhoModify = True
            
            If Not gDB.Save(register, , "pSaveItemsPARAMETROS", C_Module, c_ErrorSave) Then Exit Function
          Next
      End Select
    End With
  Next
  
  Dim sqlstmt As String
  
  If LenB(m_ItemsDeletedParametros) And Not m_Copy Then
    m_ItemsDeletedParametros = RemoveLastColon(m_ItemsDeletedParametros)
    sqlstmt = "delete AFIPParametro where afparam_id in (" & m_ItemsDeletedParametros & ")"
  
    If Not gDB.Execute(sqlstmt, "pSaveItemsPARAMETROS", C_Module) Then Exit Function
  End If
  
  pSaveItemsParametros = True
End Function

Private Function pSaveItemsArchivos() As Boolean
  Dim register As cRegister
  Dim IProperty As cIABMProperty
  
  pSaveItemsArchivos = True
  Exit Function
  
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_ARCHIVOS
        
          Dim Row  As cIABMGridRow
          Dim Cell As cIABMGridCellValue
          
          For Each Row In IProperty.Grid.Rows
          
            Set register = New cRegister
            register.fieldId = cscAfArchId
            register.Table = csTAFIPArchivo
            register.ID = csNew
            
            For Each Cell In Row
              Select Case Cell.Key
                
                Case KI_AFARCH_ID
                  If Not m_Copy Then
                    register.ID = Val(Cell.Value)
                  End If
                Case KI_NOMBRE
                  register.Fields.Add2 cscAfArchNombre, Cell.Value, csText
                Case KI_DESCRIP
                  register.Fields.Add2 cscAfArchDescrip, Cell.Value, csText
                Case KI_SEPARADORREGISTRO
                  register.Fields.Add2 cscAfArchSeparadorregistro, Cell.Value, csText
                Case KI_OBJETOENTRADA
                  register.Fields.Add2 cscAfArchObjetoentrada, Cell.Value, csText
                Case KI_ACTIVO
                  register.Fields.Add2 cscActivo, Cell.ID, csBoolean
                
              End Select
            Next
            
            register.Fields.Add2 cscAfEsqId, m_Id, csId
            
            register.Fields.HaveLastUpdate = True
            register.Fields.HaveWhoModify = True
            
            If Not gDB.Save(register, , "pSaveItemsArchivos", C_Module, c_ErrorSave) Then Exit Function
          Next
      End Select
    End With
  Next
  
  Dim sqlstmt As String
  
  If LenB(m_ItemsDeletedArchivos) And Not m_Copy Then
    m_ItemsDeletedArchivos = RemoveLastColon(m_ItemsDeletedArchivos)
    sqlstmt = "delete AFIPArchivo where afarch_id in (" & m_ItemsDeletedArchivos & ")"
  
    If Not gDB.Execute(sqlstmt, "pSaveItemsArchivos", C_Module) Then Exit Function
  End If
  
  pSaveItemsArchivos = True
End Function

' funciones privadas
Private Sub pShowFileLog()
  CSKernelClient2.EditFile GetLogFile, 0
End Sub

Private Sub pSetEnabledNextChoiceEsquema()
  m_ObjWizard.cmdNext.Enabled = pGetAFEsq_ID <> csNO_ID
End Sub

Private Function pGetAFEsq_ID() As Long
  pGetAFEsq_ID = m_ObjWizard.Steps(GetKey(c_StepChoiceSchema)).Properties(cscAfEsqId).HelpID
End Function

Private Function pGetAFEsquema() As String
  pGetAFEsquema = m_ObjWizard.Steps(GetKey(c_StepChoiceSchema)).Properties(cscAfEsqId).Value
End Function

Private Function pGetParamProperty(ByVal ParamId As Long) As cIABMProperty
  Set pGetParamProperty = m_ObjWizard.Steps(GetKey(c_StepShowParameters)).Properties(GetKey(ParamId))
End Function

Private Sub pToolBarArchivosClick(ByVal ButtonKey As String)
  Dim Index As Integer
  Dim Obj   As cIEditGeneric
  Dim Row   As cIABMGridRow
  Dim o     As cAFIPArchivo
  
  Set Obj = New cAFIPArchivo
  Set o = Obj
  Set Obj.ObjTree = Me
  
  Select Case ButtonKey
    Case "NEW"
      Set Obj.ObjABM = CreateObject("CSABMInterface2.CABMGeneric")
      o.Title2 = "(Esquema: " & m_ObjAbm.Properties(cscAfEsqNombre).Value & ")"
      Obj.ObjABM.Top = m_ObjAbm.Top + 500
      Obj.ObjABM.Left = m_ObjAbm.Left + 500
      Obj.Edit csNO_ID
    Case "EDIT", "DELETE"
      With m_ObjAbm.Properties(c_GridArchivos)
        If .SelectedIndex > 0 Then
          Set Obj.ObjABM = CreateObject("CSABMInterface2.CABMGeneric")
          Obj.ObjABM.Top = m_ObjAbm.Top + 500
          Obj.ObjABM.Left = m_ObjAbm.Left + 500
          o.Title2 = "(Esquema: " & m_ObjAbm.Properties(cscAfEsqNombre).Value & ")"
          Set Row = .Grid.Rows(.SelectedIndex)
          If ButtonKey = "EDIT" Then
            Obj.Edit GetCell(Row, KI_AFARCH_ID).Value
          Else
            Obj.Delete GetCell(Row, KI_AFARCH_ID).Value
            RefreshArchivo 0
          End If
        End If
      End With
  End Select
  
  Dim AFIPArchivo As cAFIPArchivo
  Set AFIPArchivo = Obj
  AFIPArchivo.Afesq_id = Me.ID
End Sub

Private Sub pToolBarParametrosClick(ByVal ButtonKey As String)
  Dim Index As Integer
  Dim Obj   As cIEditGeneric
  Dim Row   As cIABMGridRow
  Dim o     As cAFIPParametro
  
  Set Obj = New cAFIPParametro
  Set o = Obj
  Set Obj.ObjTree = Me
  
  Select Case ButtonKey
    Case "NEW"
      Set Obj.ObjABM = CreateObject("CSABMInterface2.CABMGeneric")
      o.Title2 = "(Esquema: " & m_ObjAbm.Properties(cscAfEsqNombre).Value & ")"
      Obj.ObjABM.Top = m_ObjAbm.Top + 500
      Obj.ObjABM.Left = m_ObjAbm.Left + 500
      Obj.Edit csNO_ID
    Case "EDIT", "DELETE"
      With m_ObjAbm.Properties(c_GridParametros)
        If .SelectedIndex > 0 Then
          Set Obj.ObjABM = CreateObject("CSABMInterface2.CABMGeneric")
          o.Title2 = "(Esquema: " & m_ObjAbm.Properties(cscAfEsqNombre).Value & ")"
          Obj.ObjABM.Top = m_ObjAbm.Top + 500
          Obj.ObjABM.Left = m_ObjAbm.Left + 500
          Set Row = .Grid.Rows(.SelectedIndex)
          If ButtonKey = "EDIT" Then
            Obj.Edit GetCell(Row, KI_AFPARAM_ID).Value
          Else
            Obj.Delete GetCell(Row, KI_AFPARAM_ID).Value
            RefreshParametro 0
          End If
        End If
      End With
  End Select
  
  Dim AFIPParametro As cAFIPParametro
  Set AFIPParametro = Obj
  AFIPParametro.Afesq_id = Me.ID
End Sub

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
  pLoadChoiceSchema
  pLoadShowParameters
  pLoadReadyToStart
  pLoadProcess
  pLoadResult
  
  LoadSteps = True
End Function

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
      Set .Picture = m_Resource.ImgWiz1.Picture
    End With
    
    With .Properties.Add(Nothing, c_Wiz_Key_Title)
      .Top = 100
      .Left = 2700
      .TopNotChange = True
      .LeftNotChange = True
      .Height = 880
      .Width = 6000
      .PropertyType = cspTitle
      .Value = LNGGetText(3369, vbNullString)
                'Bienvenido al Asistente de Informes AFIP
    End With
    With .Properties.Add(Nothing)
      .Top = 1200
      .Left = 3000
      .PropertyType = cspLabel
      .Width = 4500
      .Height = 880
      .FontBold = True
      .Value = LNGGetText(3370, vbNullString)
              'Con este asistente usted creará los archivos de distintos _
              informes para la AFIP
    End With
    With .Properties.Add(Nothing)
      .Top = 1800
      .Left = 3500
      .PropertyType = cspLabel
      .Value = LNGGetText(3371, vbNullString)
                '- Resolución 1631 (Copia electrónica de documentos en CD)
      .Width = 5000
    End With
    With .Properties.Add(Nothing)
      .Top = 2100
      .PropertyType = cspLabel
      .Value = LNGGetText(3372, vbNullString) '- S.I.C.O.R.E.
    End With
    With .Properties.Add(Nothing)
      .Top = 2400
      .PropertyType = cspLabel
      .Value = LNGGetText(3373, vbNullString) '- C.I.T.I.
    End With
    With .Properties.Add(Nothing)
      .Top = 2700
      .PropertyType = cspLabel
      .Value = LNGGetText(3374, vbNullString) '- S.I.A.P.
    End With
  End With
End Sub

Private Sub pLoadChoiceSchema()
  With m_ObjWizard.Steps.Add(Nothing, GetKey(c_StepChoiceSchema))
    With .Properties.Add(Nothing)
      .Top = 0
      .Left = 0
      .TopNotChange = True
      .LeftNotChange = True
      .PropertyType = cspImage
      Set .Picture = m_Resource.ImgWiz1.Picture
    End With
  
    With .Properties.Add(Nothing)
      .Top = 1200
      .Left = 3000
      .PropertyType = cspLabel
      .Width = 5000
      .Height = 880
      .FontBold = True
      .Value = LNGGetText(3375, vbNullString) 'Seleccione un esquema de informe AFIP para generar
    End With
  
    With .Properties.Add(Nothing, cscAfEsqId)
      .Top = 2500
      .Left = 3000
      .Name = LNGGetText(3376, vbNullString) 'Esquema
      .PropertyType = cspHelp
      .Table = csAFIPEsquema
      
      Dim EsqID As Long
      Dim EsqNombre As String
      
      EsqNombre = CSKernelClient2.GetRegistry(CSConfig, c_Key_LastEsqNombre, "")
      EsqID = Val(CSKernelClient2.GetRegistry(CSConfig, c_Key_LastEsq_ID, 0))
      Check EsqID, EsqNombre
      .Value = EsqNombre
      .HelpID = EsqID
      
      .Width = 3500
      .Left = 4000
      .Key = KW_ESQUEMA
      .LeftLabel = -800
    End With
  End With
End Sub

Private Sub pLoadShowParameters()
  With m_ObjWizard.Steps.Add(Nothing, GetKey(c_StepShowParameters))
  End With
End Sub

Private Sub pLoadReadyToStart()
  With m_ObjWizard.Steps.Add(Nothing, GetKey(c_StepShowReadyToStar))
    With .Properties.Add(Nothing)
      .Top = 0
      .Left = 0
      .TopNotChange = True
      .LeftNotChange = True
      .PropertyType = cspImage
      Set .Picture = m_Resource.ImgWiz1.Picture
    End With
  
    With .Properties.Add(Nothing, c_Wiz_Key_Esquema)
      .Top = 400
      .Left = 2700
      .PropertyType = cspLabel
      .Width = 5700
      .Height = 880
      .FontBold = True
      .FontSize = 10
    End With
  
    With .Properties.Add(Nothing)
      .Top = 1000
      .Left = 2700
      .PropertyType = cspLabel
      .Width = 5000
      .Height = 880
      .Value = LNGGetText(3377, vbNullString)
                'El asistente realizará el Informe con los siguientes parámetros
    End With
  End With
End Sub

Private Sub pLoadProcess()
  With m_ObjWizard.Steps.Add(Nothing, GetKey(c_StepShowProgress))
    With .Properties.Add(Nothing)
      .Top = 100
      .Left = 200
      .TopNotChange = True
      .LeftNotChange = True
      .PropertyType = cspImage
      Set .Picture = m_Resource.ImgWiz5.Picture
    End With
    
    With .Properties.Add(Nothing, c_Wiz_Key_ProcEsquema)
      .Top = 200
      .Left = 800
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
      .BackColor = vb3DHighlight
      .PropertyType = cspLabel
      .Value = ""
    End With
  
    With .Properties.Add(Nothing, c_Wiz_Key_ProgressFile)
      .Top = 700
      .Left = 1000
      .FontBold = True
      .PropertyType = cspLabel
      .Value = ""
    End With
    
    With .Properties.Add(Nothing, c_Wiz_Key_ProgressCount)
      .Top = 700
      .Left = 3500
      .Name = LNGGetText(3318, vbNullString)  'Son
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
      .Name = LNGGetText(2043, vbNullString)  'Van
      .Width = 1000
      .PropertyType = cspNumeric
      .SubType = cspInteger
      .Value = "0"
    End With
  
    With .Properties.Add(Nothing, c_Wiz_Key_ProgressTime)
      .Top = 700
      .Left = 6800
      .LeftLabel = -1
      .Width = 800
      .PropertyType = cspText
      .Value = "0"
    End With
  
    With .Properties.Add(Nothing, c_Wiz_Key_ProgressLog)
      .Top = 1400
      .Left = 1000
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
      .PropertyType = cspLabel
      .Width = 5700
      .Height = 880
      .FontBold = True
      .FontSize = 10
    End With
  
    With .Properties.Add(Nothing)
      .Top = 1100
      .Left = 1000
      .PropertyType = cspLabel
      .Value = LNGGetText(1118, vbNullString)  'Resultado
    End With
    
    With .Properties.Add(Nothing, c_Wiz_Key_Result)
      .Top = 1400
      .Left = 1000
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
      .Name = LNGGetText(3319, vbNullString)  'Ver Log
      .Width = 1000
      .LeftLabel = 10
      .PropertyType = cspButton
      .Key = KW_VIEW_LOG
    End With
  
  End With
End Sub

Private Sub pRefreshParameters()
  Dim Param As cAFIPParametro
  
  For Each Param In m_Parametros
    If Not Param.Avanzado Then
      With m_ObjWizard.Steps(GetKey(c_StepShowParameters)).Properties(GetKey(Param.ID))
        Param.Valor = .Value
        Param.HelpID = .HelpID
        Param.HelpValueProcess = .HelpValueProcess
      End With
    End If
  Next
End Sub

Private Sub pWizardProcess()
  On Error GoTo ControlError

  Dim i As Integer
  
  Dim Archivo   As cAFIPArchivo
  Dim Archivos  As cAFIPArchivos
  Dim Registro  As cAFIPRegistro
  Dim Registros As cAFIPRegistros
  Dim rsEntrada As ADODB.Recordset
  Dim Obj       As Object
  Dim ObjInit   As cIAFIPDll
  
  Dim iProperties       As cIABMProperties
  Dim IsEmptyRecord     As Boolean
  Dim bError            As Boolean
  Dim startTime         As Date
  
  Dim Mouse As cMouse
  Set Mouse = New cMouse
  Mouse.MouseSet vbArrowHourglass
  
  m_WizardProcessing = True
  m_WizardCancel = False
  
  startTime = Now
  
  Set iProperties = m_ObjWizard.Steps(GetKey(c_StepShowProgress)).Properties
  
  pShowProgressBar 0
  iProperties(c_Wiz_Key_ProgressFile).Value = vbNullString
  m_ObjWizard.ShowValue iProperties(c_Wiz_Key_ProgressFile)
  iProperties(c_Wiz_Key_ProgressCount).Value = 0
  m_ObjWizard.ShowValue iProperties(c_Wiz_Key_ProgressCount)
  iProperties(c_Wiz_Key_ProgressCurrent).Value = 0
  m_ObjWizard.ShowValue iProperties(c_Wiz_Key_ProgressCurrent)
  
  pRefreshParameters
  
  pShowProcessTime startTime, iProperties
  
  ' We have to load Esquema's files and then process
  Set Archivos = New cAFIPArchivos
  
  InitLog
  
  With m_ObjWizard.Steps(GetKey(c_StepShowProgress))
    .Properties(c_Wiz_Key_ProgressLog).Value = vbNullString
  End With
  
  If LenB(m_ObjetoDll) Then
    pProcessLogSep
    pProcessLog LNGGetText(3378, vbNullString), LogSevInformation
                'Creando objeto de inicializacion de la Dll Cliente
                
    If Not pCreateObject(ObjInit, m_ObjetoDll) Then
      pProcessLog LNGGetText(3379, vbNullString, LastErrorDescription), LogSevError
                  'Falló al crear el objeto de inicialización. _
                  vbCrLf & Error:  & LastErrorDescription
      GoTo ExitProc
    Else
      If Not ObjInit.Initialize(m_Parametros, Me) Then
        pProcessLog LNGGetText(3380, vbNullString, LastErrorDescription), LogSevError
                    'Falló al inicializar la Dll. & _
                    vbCrLf & Error:  & LastErrorDescription
        GoTo ExitProc
      End If
    End If
  End If
  
  pProcessLogSep
  pProcessLog LNGGetText(3381, vbNullString), LogSevInformation
              'Cargando archivos del Esquema
  If Not Archivos.Load(pGetAFEsq_ID) Then
    pProcessLog LNGGetText(3382, vbNullString, LastErrorDescription), LogSevError
                'Falló al cargar los archivos del Esquema & _
                vbCrLf & Error:  & LastErrorDescription
    GoTo ExitProc
  End If
  
  pShowProcessTime startTime, iProperties
  
  pProcessLogSep
  pProcessLog LNGGetText(3383, vbNullString), LogSevInformation
              'Archivos a procesar:
  For Each Archivo In Archivos
    pProcessLog Archivo.Nombre, LogSevInformation
  Next
    
  For Each Archivo In Archivos
    
    pShowProcessTime startTime, iProperties
    
    pProcessLogSep
    pProcessLog LNGGetText(3384, vbNullString, Archivo.Nombre), LogSevInformation
                'Archivo  & Archivo.Nombre
    pProcessLog LNGGetText(3385, vbNullString, Archivo.ObjetoEntrada), LogSevInformation
                'Creando Objeto Entrada: " & Archivo.ObjetoEntrada
    iProperties(c_Wiz_Key_ProgressFile).Value = Archivo.Nombre
    m_ObjWizard.ShowValue iProperties(c_Wiz_Key_ProgressFile)
    iProperties(c_Wiz_Key_ProgressCount).Value = 0
    m_ObjWizard.ShowValue iProperties(c_Wiz_Key_ProgressCount)
    iProperties(c_Wiz_Key_ProgressCurrent).Value = 0
    m_ObjWizard.ShowValue iProperties(c_Wiz_Key_ProgressCurrent)
    
    m_LinesInFile = 0
    m_SeparadorRegistro = Archivo.SeparadorRegistro
    
    If Not pCreateObject(Obj, Archivo.ObjetoEntrada) Then
      pProcessLog LNGGetText(3386, vbNullString, LastErrorDescription), LogSevError
                  'Falló al crear el Objeto Entrada & _
                  vbCrLf & Error:  & LastErrorDescription
      GoTo ExitProc
    Else
      Set Archivo.ObjectIn = Obj
    End If
    
    Set Registros = New cAFIPRegistros
    
    pProcessLog LNGGetText(3387, vbNullString), LogSevInformation
                'Cargando registros...
    If Not Registros.Load(Archivo.ID) Then
      pProcessLog LNGGetText(3388, vbNullString, LastErrorDescription), LogSevError
                  'Fallo al cargar los registros del archivo & _
                  vbCrLf & Error:  & LastErrorDescription
      GoTo ExitProc
    End If
    
    pShowProcessTime startTime, iProperties
      
    pProcessLogSep
    pProcessLog LNGGetText(3389, vbNullString), LogSevInformation
                'Registros a Procesar:
    For Each Registro In Registros
      pProcessLog Registro.Nombre, LogSevInformation
    Next
    
    For Each Registro In Registros
      pProcessLogSep
      pProcessLog LNGGetText(3390, vbNullString, Registro.Nombre), LogSevInformation
                  'Registro & Registro.Nombre
      pProcessLog LNGGetText(3391, vbNullString, Registro.ObjetoProceso), LogSevInformation
                  'Creando Objeto Proceso:  & Registro.ObjetoProceso
      If Not pCreateObject(Obj, Registro.ObjetoProceso) Then
        pProcessLog LNGGetText(3392, vbNullString, LastErrorDescription), LogSevError
                    'Falló al crear el Objeto Proceso & _
                    vbCrLf & Error:  & LastErrorDescription
        GoTo ExitProc
      Else
        Set Registro.ObjectProc = Obj
      End If
      
      If Not Registro.Campos.Load(Registro.ID) Then
        pProcessLog LNGGetText(3393, vbNullString, LastErrorDescription), LogSevError
                    'Falló al cargar los campos del registro & _
                    vbCrLf & Error:  & LastErrorDescription
        GoTo ExitProc
      End If
    Next
    
    pShowProcessTime startTime, iProperties
    
    m_FileName = Archivo.ObjectIn.NombreArchivo(m_Parametros)
    pProcessLog LNGGetText(3394, vbNullString, m_FileName), LogSevInformation
                'Nombre del archivo a generar:  & m_FileName
    Set m_File = New cFile
    If Not m_File.FOpen(m_FileName, csWrite, True, True, csLockWrite, False, False) Then
      pProcessLog LNGGetText(3395, vbNullString, m_FileName, LastErrorDescription), LogSevError
                  'Error al crear el archivo de salida:  & m_FileName & _
                  vbCrLf & "Error:  & LastErrorDescription, LogSevError
      GoTo ExitProc
    End If
    
    If pUserCancel() Then GoTo ExitProc
    
    pProcessLogSep
    pProcessLog LNGGetText(3396, vbNullString), LogSevInformation
                'Cargando Datos
    pProcessLog LNGGetText(3397, vbNullString), LogSevInformation
                'Invocando al método GetRecordset del Objeto Entrada
    
    If Not Archivo.ObjectIn.GetRecordset(m_Parametros, rsEntrada, Me) Then
      pProcessLog LNGGetText(3398, vbNullString, LastErrorDescription, LastErrorInfo), LogSevError
                  'Falló al invocar el metodo GetRecordset & _
                  vbCrLf & Error:  & LastErrorDescription & vbCrLf & LastErrorInfo
      GoTo ExitProc
    End If

    If Not (rsEntrada.EOF And rsEntrada.BOF) Then

      rsEntrada.MoveLast
      rsEntrada.MoveFirst
      
      iProperties(c_Wiz_Key_ProgressCount).Value = rsEntrada.RecordCount
      m_ObjWizard.ShowValue iProperties(c_Wiz_Key_ProgressCount)
      
      While Not rsEntrada.EOF
        pShowProcessTime startTime, iProperties
          
        For Each Registro In Registros
        
          IsEmptyRecord = False
          
          pResetCampos Registro.Campos
          
          If Not Registro.ObjectProc.ProcessRecord( _
                                            m_Parametros, _
                                            rsEntrada.Fields, _
                                            Registro.Campos, _
                                            False, _
                                            IsEmptyRecord, _
                                            rsEntrada.AbsolutePosition, _
                                            Me) Then
                                            
                  pProcessLog LNGGetText(3399, vbNullString, Registro.Nombre, LastErrorDescription, LastErrorInfo), LogSevError
                              'Error al procesar el registro:  & Registro.Nombre & _
                              vbCrLf & Error:  & LastErrorDescription & vbCrLf & LastErrorInfo
                  GoTo ExitProc
          End If
          
          If Not IsEmptyRecord Then
          
            If Not pAddLineToFile(m_FileName, Registro.Campos, m_SeparadorRegistro) Then
                pProcessLog LNGGetText(3400, vbNullString, m_FileName, LastErrorDescription), LogSevError
                        'Error al grabar en el archivo de salida: & m_FileName & _
                        vbCrLf & Error:  & LastErrorDescription
                GoTo ExitProc
            End If
          End If
        Next
        
        pShowProgressBar (rsEntrada.AbsolutePosition / rsEntrada.RecordCount) * 100
        DoEvents
        
        iProperties(c_Wiz_Key_ProgressCurrent).Value = rsEntrada.AbsolutePosition
        m_ObjWizard.ShowValue iProperties(c_Wiz_Key_ProgressCurrent)
        
        If pUserCancel() Then GoTo ExitProc
        
        rsEntrada.MoveNext
      Wend
    
      For Each Registro In Registros
      
        IsEmptyRecord = False
        
        pResetCampos Registro.Campos
      
        ' Ultima llamada para este archivo.
        ' En esta llamada el objeto proceso tiene la oportunidad
        ' de procesar el ultimo registro y tambien de totalizar
        If Not Registro.ObjectProc.ProcessRecord( _
                                          m_Parametros, _
                                          Nothing, _
                                          Registro.Campos, _
                                          True, _
                                          IsEmptyRecord, _
                                          -1, _
                                          Me) Then
                                          
                pProcessLog LNGGetText(3399, vbNullString, Registro.Nombre, LastErrorDescription, LastErrorInfo), LogSevError
                            'Error al procesar el registro:  & Registro.Nombre & _
                            vbCrLf & Error:  & LastErrorDescription & vbCrLf & LastErrorInfo
                GoTo ExitProc
        End If
        
        If Not IsEmptyRecord Then
        
          If Not pAddLineToFile(m_FileName, Registro.Campos, m_SeparadorRegistro) Then
              pProcessLog LNGGetText(3400, vbNullString, m_FileName, LastErrorDescription), LogSevError
                'Error al grabar en el archivo de salida:  & m_FileName & _
                vbCrLf & Error:  & LastErrorDescription, LogSevError
              GoTo ExitProc
          End If
        End If
      Next
    End If
    
    m_File.FClose
  Next
  
  pShowProcessTime startTime, iProperties
    
  pProcessLogSep
  pProcessLog LNGGetText(3301, vbNullString), LogSevInformation
              'El proceso se termino con éxito
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
  
  If bError Then
    pProcessLog LNGGetText(3401, vbNullString, LastErrorDescription), LogSevError
                'Error al procesar el informe vbCrLf & Error:  & LastErrorDescription
  End If

  If Not ObjInit Is Nothing Then
    pProcessLogSep
    pProcessLog LNGGetText(3402, vbNullString), LogSevInformation
                'Llamando al método Terminate del objeto de inicialización de la Dll cliente
    If Not ObjInit.Terminate(Me) Then
      pProcessLog LNGGetText(3403, vbNullString, LastErrorDescription), LogSevError
                  'Falló al llamar al método Terminate la Dll.vbCrLf & Error: & LastErrorDescription
    End If
  End If
  
  pProcessLog LNGGetText(3404, vbNullString, iProperties(c_Wiz_Key_ProgressTime).Value), LogSevInformation
              'Tiempo utilizado:  & iProperties(c_Wiz_Key_ProgressTime).Value
End Sub

Private Function pUserCancel() As Boolean
  If m_WizardCancel Then
    
    If Ask(LNGGetText(1665, vbNullString), vbNo) Then
            'Desea cancelar el proceso
      pProcessLog LNGGetText(3405, vbNullString), LogSevWarnning
                  'Proceso cancelado por el Usuario
      pUserCancel = True
    End If
  End If
  m_WizardCancel = False
End Function

Private Function pAddLineToFile(ByVal FileName As String, ByRef Campos As cAFIPCampos, ByVal SeparadorRegistro As String) As Boolean
  Dim strLine As String
  Dim Campo As cAFIPCampo
  
  For Each Campo In Campos
   
    If Campo.Posicion > 0 Then
      strLine = strLine & pFormatCampo(Campo) & SeparadorRegistro
    End If
  Next
  
  If Not m_File.FWrite(strLine) Then Exit Function
  m_LinesInFile = m_LinesInFile + 1
  
  pAddLineToFile = True
End Function

Private Function pFormatCampo(ByRef Campo As cAFIPCampo) As String
  Dim Filler      As String
  Dim strFormat   As String
  Dim Valor       As String
  
  Valor = Campo.Valor
  
  If Campo.Relleno = "" Then Campo.Relleno = " "
  
  ' Es una fecha
  If LenB(Campo.FormatoFecha) Then
    Valor = Format(Valor, Campo.FormatoFecha)
  End If
  
  ' Es un numero
  If Campo.CantDigitosDecimales > 0 Or Campo.CantDigitosEnteros Then
    strFormat = String(Campo.CantDigitosEnteros, "0") & "." & String(Campo.CantDigitosDecimales, "0")
    If IsNumeric(Valor) Then
      Valor = Format(CDbl(Valor), strFormat)
      Valor = Replace(Valor, ".", Campo.SeparadorDecimal)
      Valor = Replace(Valor, ",", Campo.SeparadorDecimal)
    Else
      'pProcessLog "El campo [" & Campo.Nombre & "] indica cantidad de decimales o cantidad de enteros pero no es numerico. Valor: " & valor, LogSevWarnning
    End If
  End If
  
  If Campo.Largo - Len(Valor) > 0 Then
    Filler = String(Campo.Largo - Len(Valor), Campo.Relleno)
  End If
  
  Select Case Campo.Alineacion
    Case c_AlignLeft
      Valor = Valor & Filler
      Valor = Mid$(Valor, 1, Campo.Largo)
    Case c_AlignRigth
      Valor = Filler & Valor
      Valor = Mid$(Valor, Len(Valor) - Campo.Largo + 1)
  End Select
  
  pFormatCampo = Valor
End Function

Private Sub pShowProcessTime(ByVal startTime As Date, ByRef iProperties As cIABMProperties)
  Dim Seconds As Long
  Dim Minutes As Long
  
  Seconds = DateDiff("s", startTime, Now)
  Minutes = Fix(Seconds / 60)
  Seconds = Seconds Mod 60
  
  iProperties(c_Wiz_Key_ProgressTime).Value = Minutes & ":" & Format(Seconds, "00")
  m_ObjWizard.ShowValue iProperties(c_Wiz_Key_ProgressTime)
End Sub

Private Sub pResetCampos(ByRef Campos As cAFIPCampos)
  Dim Campo As cAFIPCampo
  For Each Campo In Campos
    Campo.Valor = ""
  Next
End Sub

Private Sub pShowProgressBar(ByVal Value As Integer)
  With m_ObjWizard.Steps(GetKey(c_StepShowProgress))
    .Properties(c_Wiz_Key_Progress).Value = Value
    m_ObjWizard.ShowValue .Properties(c_Wiz_Key_Progress)
  End With
End Sub

Private Function pCreateObject(ByRef Obj As Object, ByVal strClassId As String) As Boolean
  On Error GoTo ControlError
  Set Obj = CreateObject(strClassId)
  pCreateObject = True
  Exit Function
ControlError:
  MngError Err, "pCreateObject", C_Module, vbNullString
End Function

Private Sub pProcessLogSep()
  pProcessLog String(20, "-"), LogSevInformation
End Sub

Private Sub pProcessLog(ByVal msg As String, ByVal Severity As csInfoAFIPLogSeverity, Optional ByVal Module As String = C_Module)
  Dim str_3209    As String 'Error
  Dim str_3323    As String 'Advertencia !!!
  Dim str_3324    As String 'Fin Error
  Dim str_3325    As String 'Fin Advertencia !!!
  
  str_3209 = LNGGetText(3209, vbNullString) 'Error
  str_3323 = LNGGetText(3323, vbNullString) 'Advertencia !!!
  str_3324 = LNGGetText(3324, vbNullString) 'Fin Error
  str_3325 = LNGGetText(3325, vbNullString) 'Fin Advertencia !!!
  
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

Private Sub pWizardShowProcess()
  With m_ObjWizard.Steps(GetKey(c_StepShowProgress))
    .Properties(c_Wiz_Key_ProcEsquema).Value = LNGGetText(3406, vbNullString, pGetAFEsquema)
                                              'Procesando el informe (1)
    m_ObjWizard.ShowValue .Properties(c_Wiz_Key_ProcEsquema)
  End With
End Sub

Private Sub pWizardShowResult()
  Dim sLog As String
  
  With m_ObjWizard.Steps(GetKey(c_StepShowProgress))
    sLog = .Properties(c_Wiz_Key_ProgressLog).Value
  End With

  With m_ObjWizard.Steps(GetKey(c_StepShowResult))
    .Properties(c_Wiz_Key_Result).Value = sLog
    m_ObjWizard.ShowValue .Properties(c_Wiz_Key_Result)
    .Properties(c_Wiz_Key_ResultTitle).Value = LNGGetText(3407, vbNullString, pGetAFEsquema)
                                                'Resulado del informe (1)
    m_ObjWizard.ShowValue .Properties(c_Wiz_Key_ResultTitle)
    Dim Prop As cABMProperty
    Set Prop = .Properties(c_Wiz_Key_Result)
    Prop.ctl.SelStart = Len(Prop.ctl.Text)
  End With
End Sub

Private Sub pWizardShowReadyToStart()
  Dim iProp      As cIABMProperty
  Dim strParams  As String
  Dim strParams2 As String
  Dim Param      As cAFIPParametro
  
  m_ObjWizard.ResetTabLeftTop GetKey(c_StepShowReadyToStar)
  
  With m_ObjWizard.Steps(GetKey(c_StepShowReadyToStar))
    If Not .Properties(c_Wiz_Key_ReadyToStart) Is Nothing Then
      .Properties.Remove c_Wiz_Key_ReadyToStart
    End If
    .Properties(c_Wiz_Key_Esquema).Value = LNGGetText(3408, vbNullString, pGetAFEsquema)
                                          'Ud. ha completado los pasos para crear el informe
    m_ObjWizard.ShowValue .Properties(c_Wiz_Key_Esquema)
  End With
  
  For Each Param In m_Parametros
    If Not Param.Avanzado Then
      strParams = strParams & Param.Nombre & ": " & pGetParamProperty(Param.ID).Value & vbCrLf
    Else
      strParams2 = strParams2 & Param.Nombre & ": " & Param.Valor & vbCrLf
    End If
  Next
  
  strParams = strParams & vbCrLf & LNGGetText(3409, vbNullString) & vbCrLf & strParams2
                                    'Avanzados:
  
  Set iProp = m_ObjWizard.Steps(GetKey(c_StepShowReadyToStar)).Properties.Add(Nothing, c_Wiz_Key_ReadyToStart)
  With iProp
    .Top = 1400
    .Left = 2700
    .Name = ""
    .PropertyType = cspText
    .SubType = cspMemo
    .BackColor = vbWindowBackground
    .Width = 5000
    .Height = 2500
    .Value = strParams
    .LeftLabel = 10
  End With

  If Not m_ObjWizard.LoadControl(iProp) Then Exit Sub
End Sub

Private Sub pWizardShowParametros()
  Dim Param As cAFIPParametro
  Dim iProp As cIABMProperty
  Dim oProp As cABMProperty
  
  m_ObjWizard.Steps(GetKey(c_StepShowParameters)).Properties.Clear
  
  Set iProp = m_ObjWizard.Steps(GetKey(c_StepShowParameters)).Properties.Add(Nothing)
  With iProp
    .Top = 200
    .Left = 200
    .TopNotChange = True
    .LeftNotChange = True
    .PropertyType = cspImage
    Set .Picture = m_Resource.ImgWiz3.Picture
  End With
  If Not m_ObjWizard.LoadControl(iProp) Then Exit Sub
  
  Set iProp = m_ObjWizard.Steps(GetKey(c_StepShowParameters)).Properties.Add(Nothing)
  With iProp
    .Top = 500
    .Left = 1200
    .PropertyType = cspLabel
    .Width = 5000
    .Height = 880
    .FontBold = True
    .Value = LNGGetText(3410, vbNullString) 'Cargue los siguientes parámetros
  End With
  If Not m_ObjWizard.LoadControl(iProp) Then Exit Sub
  
  m_ObjWizard.ResetTabLeftTop GetKey(c_StepShowParameters)
  
  For Each Param In m_Parametros
    If Not Param.Avanzado Then
      Set iProp = m_ObjWizard.Steps(GetKey(c_StepShowParameters)).Properties.Add(Nothing, GetKey(Param.ID))
      With iProp
        .PropertyType = Param.Tipo
        .SubType = Param.SubTipo
        .Name = Param.Nombre
        If Param.Tipo = cspDate Then
          
          If IsDate(Param.Valor) Then
            .Value = Param.Valor
          Else
            .Value = VDGetDate(Param.Valor)
          End If
        Else
          .Value = Param.Valor
        End If
        
        If Param.Tipo = cspHelp Then
          ' Si es un Help y subtipo = 7 es un help de arbol
          '
          If Param.SubTipo = 7 Then
            Set oProp = iProp
            oProp.HelpType = csTree
          End If
        End If
        
        .Table = Param.TablaHelp
        .Size = 255
      End With
      If Not m_ObjWizard.LoadControl(iProp) Then Exit Sub
    End If
  Next
End Sub

' Edicion
Private Function LoadCollection() As Boolean
  
  With m_ObjAbm.Tabs
  
    .Clear
  
    With .Add(Nothing)
      .Name = C_strGeneral
    End With
      
    With .Add(Nothing)
      .Index = 1
      .Name = LNGGetText(3411, vbNullString) 'Archivos
    End With
      
    With .Add(Nothing)
      .Index = 2
      .Name = LNGGetText(1817, vbNullString) 'Parametros
    End With
  End With
  
  Dim c As cIABMProperty
  
  With m_ObjAbm.Properties
    
    .Clear
      
    With .Add(Nothing, cscAfEsqNombre)
      .PropertyType = cspText
      .Name = C_strNombre
      .Width = 4000
      .Size = 50
      .Key = K_NOMBRE
      .Value = Nombre
    End With
    
    With .Add(Nothing, cscAfEsqCodigo)
      .PropertyType = cspText
      .Name = C_strCodigo
      .Size = 10
      .Key = K_CODIGO
      .Value = Codigo
    End With
    
    With .Add(Nothing, cscActivo)
      .PropertyType = cspCheck
      .Name = C_strActivo
      .Key = K_ACTIVO
      .Value = CInt(m_Activo)
    End With
    
    With .Add(Nothing, cscAfEsqObjetoDll)
      .PropertyType = cspText
      .Name = LNGGetText(3412, vbNullString) 'Objeto DLL
      .Width = 4000
      .Size = 50
      .Key = K_OBJETO_DLL
      .Value = ObjetoDll
    End With
    
    With .Add(Nothing, cscAfEsqDescrip)
      .PropertyType = cspText
      .SubType = cspMemo
      .Name = C_strDescrip
      .Height = 980
      .Width = 6500
      .Size = 255
      .Key = K_DESCRIP
      .Value = Descrip
    End With
    
    With .Add(Nothing, c_ToolBarArchivos)
      .PropertyType = cspToolBar
      .Name = LNGGetText(3357, vbNullString) 'ToolBar
      .TabIndex = 1
      .Width = 1350
      .LeftFrame = 6850
      .TopFrame = 870
      .Enabled = m_Id <> csNO_ID
      .Key = K_TOOLBAR_ARCHIVOS
      .Buttons = BUTTON_DELETE + BUTTON_EDIT + BUTTON_NEW
    End With
    
    Set c = .Add(Nothing, c_GridArchivos)
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      If Not pLoadArchivos(c) Then Exit Function
      .Name = LNGGetText(3411, vbNullString) 'Archivos
      .Key = K_ARCHIVOS
      .Top = 1400
      .TabIndex = 1
      .GridAdd = False
      .GridEdit = False
      .Enabled = m_Id <> csNO_ID
      .GridRemove = True
    End With
    
    m_ItemsDeletedArchivos = vbNullString
      
    With .Add(Nothing, c_ToolBarParametros)
      .PropertyType = cspToolBar
      .Name = LNGGetText(3357, vbNullString) 'ToolBar
      .TabIndex = 2
      .Width = 1350
      .LeftFrame = 6850
      .TopFrame = 870
      .Enabled = m_Id <> csNO_ID
      .Key = K_TOOLBAR_PARAMETROS
      .Buttons = BUTTON_DELETE + BUTTON_EDIT + BUTTON_NEW
    End With
      
    Set c = .Add(Nothing, c_GridParametros)
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      If Not pLoadParametros(c) Then Exit Function
      .Name = LNGGetText(1817, vbNullString) 'Parametros
      .Key = K_PARAMETROS
      .Top = 1400
      .TabIndex = 2
      .GridAdd = False
      .GridEdit = False
      .GridRemove = True
    End With
  End With
  
  m_ItemsDeletedParametros = vbNullString
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

Private Function Load(ByVal ID As Long) As Boolean
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  sqlstmt = "select * from AFIPEsquema where afesq_id = " & ID

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "Load", C_Module) Then Exit Function

  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.Fields, cscAfEsqId)
    m_Nombre = gDB.ValField(rs.Fields, cscAfEsqNombre)
    m_Codigo = gDB.ValField(rs.Fields, cscAfEsqCodigo)
    m_Descrip = gDB.ValField(rs.Fields, cscAfEsqDescrip)
    m_ObjetoDll = gDB.ValField(rs.Fields, cscAfEsqObjetoDll)
    m_Creado = gDB.ValField(rs.Fields, cscCreado)
    m_Modificado = gDB.ValField(rs.Fields, cscModificado)
    m_Modifico = gDB.ValField(rs.Fields, cscModifico)
    m_Activo = gDB.ValField(rs.Fields, cscActivo)

  Else
    m_Id = csNO_ID
    m_Nombre = vbNullString
    m_Codigo = vbNullString
    m_Descrip = vbNullString
    m_ObjetoDll = vbNullString
    m_Creado = csNoDate
    m_Modificado = csNoDate
    m_Modifico = 0
    m_Activo = False

  End If

  Load = True
End Function

Private Function pLoadArchivos(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "select AFIPArchivo.* from AFIPArchivo " & _
            " where afesq_id = " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadArchivos", C_Module) Then Exit Function
  
  Dim o As cIABMGridColumn
  
  Propiedad.Grid.Columns.Clear
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = "afarch_id"
  o.Visible = False
  o.Key = KI_AFARCH_ID
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = C_strNombre
  o.PropertyType = cspText
  o.Width = 1200
  o.Key = KI_NOMBRE
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = LNGGetText(3356, vbNullString) 'Objeto de Entrada
  o.PropertyType = cspText
  o.Width = 1200
  o.Key = KI_OBJETOENTRADA
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = LNGGetText(3413, vbNullString) 'Sep. Registro
  o.PropertyType = cspText
  o.Width = 1200
  o.Key = KI_SEPARADORREGISTRO
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = C_strDescrip
  o.PropertyType = cspText
  o.Width = 3000
  o.Key = KI_DESCRIP
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = C_strActivo
  o.PropertyType = cspCheck
  o.Width = 800
  o.Key = KI_ACTIVO
  
  Dim f  As cIABMGridRow
  Dim fv As cIABMGridCellValue
  
  Propiedad.Grid.Rows.Clear
  
  While Not rs.EOF
  
    Set f = Propiedad.Grid.Rows.Add(Nothing, rs(cscAfArchId).Value)
    
    Set fv = f.Add(Nothing)
    fv.Value = rs(cscAfArchId).Value
    fv.Key = KI_AFARCH_ID
    
    Set fv = f.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscAfArchNombre)
    fv.Key = KI_NOMBRE
    
    Set fv = f.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscAfArchObjetoentrada)
    fv.Key = KI_OBJETOENTRADA
        
    Set fv = f.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscAfArchSeparadorregistro)
    fv.Key = KI_SEPARADORREGISTRO
    
    Set fv = f.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscAfArchDescrip)
    fv.Key = KI_DESCRIP
    
    Set fv = f.Add(Nothing)
    fv.ID = gDB.ValField(rs.Fields, cscActivo)
    fv.Key = KI_ACTIVO
    
    rs.MoveNext
  Wend
  
  pLoadArchivos = True
End Function

Private Function pLoadParametros(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "select AFIPParametro.*  from AFIPParametro" & _
              " where afesq_id = " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadParametros", C_Module) Then Exit Function
  
  Dim o As cIABMGridColumn
  
  Propiedad.Grid.Columns.Clear
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = "afparam_id"
  o.Visible = False
  o.Key = KI_AFPARAM_ID
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = C_strNombre
  o.PropertyType = cspText
  o.Width = 1200
  o.Key = KI_NOMBRE
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = C_strDescrip
  o.PropertyType = cspText
  o.Width = 1200
  o.Key = KI_DESCRIP
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = LNGGetText(1223, vbNullString) 'Tipo
  o.PropertyType = cspText
  o.Width = 1200
  o.Key = KI_TIPO
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = LNGGetText(3414, vbNullString) 'Sub Tipo
  o.PropertyType = cspText
  o.Width = 1200
  o.Key = KI_SUBTIPO
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = LNGGetText(1810, vbNullString) 'Tabla
  o.PropertyType = cspText
  o.Width = 1200
  o.Key = KI_TABLAHELP
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = LNGGetText(2752, vbNullString) 'Valor
  o.PropertyType = cspText
  o.Width = 1200
  o.Key = KI_VALOR
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = LNGGetText(3415, vbNullString) 'Avanzado
  o.PropertyType = cspCheck
  o.Width = 1200
  o.Key = KI_AVANZADO
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = C_strActivo
  o.PropertyType = cspCheck
  o.Width = 1200
  o.Key = KI_ACTIVO
  
  Dim f  As cIABMGridRow
  Dim fv As cIABMGridCellValue
  
  Propiedad.Grid.Rows.Clear
  
  While Not rs.EOF
  
    Set f = Propiedad.Grid.Rows.Add(Nothing, rs(cscAfParamId).Value)
    
    Set fv = f.Add(Nothing)
    fv.Value = rs(cscAfParamId).Value
    fv.Key = KI_AFPARAM_ID
    
    Set fv = f.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscAfParamNombre)
    fv.Key = KI_NOMBRE
    
    Set fv = f.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscAfParamDescrip)
    fv.Key = KI_DESCRIP
    
    Set fv = f.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscAfParamTipo)
    fv.Key = KI_TIPO
    
    Set fv = f.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscAfParamSubTipo)
    fv.Key = KI_SUBTIPO
    
    Set fv = f.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscAfParamTablaHelp)
    fv.Key = KI_TABLAHELP
    
    Set fv = f.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscAfParamValor)
    fv.Key = KI_VALOR
    
    Set fv = f.Add(Nothing)
    fv.ID = gDB.ValField(rs.Fields, cscAfParamAvanzado)
    fv.Key = KI_AVANZADO
    
'    Set fv = f.Add(Nothing)
'    fv.Value = gDB.ValField(rs.Fields, cscAfParamObjeto)
'    fv.Key = KI_OBJETO
'
'    Set fv = f.Add(Nothing)
'    fv.Value = gdb.valfield(rs.fields,<<cscafesq_id>>)
'    fv.Id = gDB.ValField(rs.Fields, cscafesq_id)
'    fv.Key = KI_AFESQ_ID
'
'    Set fv = f.Add(Nothing)
'    fv.Value = gdb.valfield(rs.fields,<<cscafarch_id>>)
'    fv.Id = gDB.ValField(rs.Fields, cscafarch_id)
'    fv.Key = KI_AFARCH_ID
'
'    Set fv = f.Add(Nothing)
'    fv.Value = gdb.valfield(rs.fields,<<cscafreg_id>>)
'    fv.Id = gDB.ValField(rs.Fields, cscafreg_id)
'    fv.Key = KI_AFREG_ID
    
    Set fv = f.Add(Nothing)
    fv.ID = gDB.ValField(rs.Fields, cscActivo)
    fv.Key = KI_ACTIVO
    
    rs.MoveNext
  Wend
  
  pLoadParametros = True
End Function

Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  c_ErrorSave = LNGGetText(3416, vbNullString) 'Error al grabar AFIPEsquema
  
  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

' construccion - destruccion
Private Sub Class_Terminate()
  Set m_ObjAbm = Nothing
  Set m_ObjTree = Nothing
  Set m_ObjWizard = Nothing
  Set m_File = Nothing
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



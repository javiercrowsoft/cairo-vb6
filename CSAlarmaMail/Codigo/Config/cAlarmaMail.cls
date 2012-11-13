VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cAlarmaMail"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGeneric
Implements CSInterfacesABM.cIABMClient
Implements CSMenu.cIMenuClient
'--------------------------------------------------------------------------------
' cAlarmaMail
' 21-01-2007

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cAlarmaMail"

Private Const K_NOMBRE                         As Integer = 1
Private Const K_SCRIPT_MAIL                    As Integer = 2
Private Const K_SCRIPT_RESULT                  As Integer = 3
Private Const K_OBJECT                         As Integer = 4
Private Const K_FRECUENCIA                     As Integer = 5
Private Const K_ACTIVO                         As Integer = 6
Private Const K_MAILS                          As Integer = 7

' estructuras
' Seudo - Variables
Private c_ErrorSave         As String

' variables privadas
Private m_Id               As Long
Private m_Nombre           As String
Private m_script_mail      As String
Private m_script_result    As String
Private m_object           As String
Private m_frecuencia       As Long
Private m_mails            As String
Private m_Activo           As Boolean

'OJO HASTA ACA

Private m_Editing          As Boolean

Private m_ObjAbm           As cIABMGeneric
Private m_ObjTree          As Object

Private m_IsNew            As Boolean

Private m_BranchId         As Long
Private m_TreeId           As Long
Private m_Host As CSMenu.cIMenuHost

Private m_Copy              As Boolean
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

Public Property Get Codigo() As String
  Codigo = m_Nombre
End Property

Public Property Let Codigo(ByVal rhs As String)
  m_Nombre = rhs
End Property

' Properties privadas
' funciones publicas

' Implementacion de cIABMClient
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

Private Function cIABMClient_Copy() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True
  
  With m_ObjAbm.Properties(cscAlmNombre)
    .Value = "C-" & .Value
  End With
  
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscAlmNombre)
  
  m_Copy = True
End Function

Private Sub cIABMClient_DiscardChanges()
    LoadCollection
End Sub

Private Function cIABMClient_EditNew() As Boolean

  cIABMClient_Terminate
  m_IsNew = True

  cIEditGeneric_Edit csNO_ID
End Function

Private Function cIABMClient_ListAdHock(List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClient_Load()

End Sub

Private Function cIABMClient_ShowDocDigital() As Boolean
  On Error GoTo ControlError
  
  If m_Id = csNO_ID Then Exit Function
  
  Dim Doc As cDocDigital
  Set Doc = New cDocDigital

  Doc.ClientTable = csTAlarmaMail
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

Private Function cIABMClient_PropertyChange(ByVal Key As Integer) As Boolean

End Function

Private Function cIABMClient_Save() As Boolean
  Dim register   As cRegister
  Dim fields     As cFields
   
  Set register = New cRegister
  Set fields = register.fields
  
  With register
    .fieldId = cscAlmId
    .Table = csTAlarmaMail
  
    If m_Copy Then
      .Id = csNew
    Else
      .Id = m_Id
    End If
  End With
  
  Dim IProperty As cIABMProperty
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_NOMBRE
          fields.Add2 cscAlmNombre, .Value, csText
        Case K_SCRIPT_MAIL
          fields.Add2 cscAlmScriptMails, .Value, csText
        Case K_SCRIPT_RESULT
          fields.Add2 cscAlmScriptResult, .Value, csText
        Case K_OBJECT
          fields.Add2 cscAlmObject, .Value, csText
        Case K_FRECUENCIA
          fields.Add2 cscAlmFrecuencia, .Value, csText
        Case K_ACTIVO
          fields.Add2 cscActivo, .Value, csBoolean
        Case K_MAILS
          fields.Add2 cscAlmMails, .Value, csText

      End Select
    End With
  Next
  
  fields.HaveLastUpdate = True
  fields.HaveWhoModify = True
  
  If Not gDB.Save(register, , "cIABMClient_Save", C_Module, c_ErrorSave) Then Exit Function
  
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
  cIABMClient_Title = LNGGetText(3218, vbNullString) 'AlarmaMails
End Property


Private Function cIABMClient_Validate() As Boolean

  Dim IProperty As cIABMProperty

  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_NOMBRE
          If ValEmpty(.Value, csText) Then
            MsgInfo C_DebeIndicarNombre
            Exit Function
          End If
      End Select
    End With
  Next

  cIABMClient_Validate = True
End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Id = csNO_ID Then
    m_IsNew = True
    If Not SecurityCanAccess(csPreANewAlarmaMail) Then Exit Function
  Else
    m_IsNew = False
    If Not SecurityCanAccess(csPreAEditAlarmaMail) Then Exit Function
  End If
  
  m_ObjAbm.InModalWindow = InModalWindow
  
  If Not Load(Id) Then Exit Function
  
  If Not LoadCollection() Then Exit Function
  
  m_Editing = True
  m_Copy = False
  
  If InModalWindow Then
    cIEditGeneric_Edit = m_Id <> csNO_ID
  Else
    cIEditGeneric_Edit = True
  End If

  Exit Function
ControlError:
  MngError Err, "cIEditGeneric_Edit", "cAlarmaMail", vbnulllstring
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
  cIEditGeneric_ShowList = SecurityCanAccess(csPreAListAlarmaMail)
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
  If Not SecurityCanAccess(csPreADeleteAlarmaMail) Then Exit Function

  Dim sqlstmt As String
  
  sqlstmt = "Delete AlarmaMail where alm_id = " & Id
  
  cIEditGeneric_Delete = gDB.Execute(sqlstmt, "cIEditGeneric_Delete", "cAlarmaMail")
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

Private Function cIEditGeneric_PropertyChange(ByVal Key As Integer) As Boolean

End Function

Private Function cIMenuClient_Initialize(F As Object, Host As CSMenu.cIMenuHost) As Boolean
  On Error GoTo ControlError
  
  Set m_Host = Host
  m_Host.Server.AddMenu LNGGetText(3220, vbNullString), csPreAListAlarmaMail, LNGGetText(2703, vbNullString), 0, True, False, True, False, False, Me
                          '&Alarmas por Mail                                   S&istema
  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, "cIMenuClient_Initialize", C_Module, vbnulllstring
  If Err.Number <> 0 Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal Id As Long) As Variant
  m_Host.MenuABMClick "CSAlarmaMailCfg.cAlarmaMail", Me, LNGGetText(3219, vbNullString), 0, csETablesAlarmaMail.csAlarmaMail
                                                          'Alarmas por Mail
End Function

' funciones privadas
Private Function LoadCollection() As Boolean

  With m_ObjAbm.Tabs
    
    .Clear
    
    With .Add(Nothing)
      .Name = C_strGeneral
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(3210, vbNullString) 'Sistema
      .Index = 1
    End With
  End With

  With m_ObjAbm.Properties
    
    .Clear
  
    With .Add(Nothing, cscAlmNombre)
      .PropertyType = cspText
      .Name = C_strNombre
      .Key = K_NOMBRE
      .Value = m_Nombre
      .Width = 6800
    End With
    
    With .Add(Nothing, cscActivo)
      .PropertyType = cspCheck
      .Name = C_strActivo
      .Key = K_ACTIVO
      .Value = CInt(m_Activo)
    End With
  
    With .Add(Nothing, cscAlmFrecuencia)
      .PropertyType = cspNumeric
      .SubType = cspInteger
      .Name = LNGGetText(3211, vbNullString) 'Frecuencia (minutos)
      .Key = K_FRECUENCIA
      .Value = m_frecuencia
      .Width = 800
    End With
  
    With .Add(Nothing, cscAlmMails)
      .PropertyType = cspText
      .Name = LNGGetText(3212, vbNullString) 'Emails
      .Key = K_MAILS
      .Value = m_mails
      .Width = 6800
    End With
    
    With .Add(Nothing, cscAlmId)
      .PropertyType = cspText
      .Name = LNGGetText(3213, vbNullString) 'ID de la Alarma
      .Value = m_Id
      .Enabled = False
      .Width = 1000
      .TabIndex = 1
    End With
    
    With .Add(Nothing, cscAlmScriptMails)
      .PropertyType = cspText
      .Name = LNGGetText(3214, vbNullString) 'Script Mails
      .Key = K_SCRIPT_MAIL
      .Value = m_script_mail
      .Width = 6800
      .TabIndex = 1
    End With
  
    With .Add(Nothing, cscAlmScriptResult)
      .PropertyType = cspText
      .Name = LNGGetText(3215, vbNullString) 'Script Result
      .Key = K_SCRIPT_RESULT
      .Value = m_script_result
      .Width = 6800
      .TabIndex = 1
    End With
  
    With .Add(Nothing, cscAlmObject)
      .PropertyType = cspText
      .Name = LNGGetText(3216, vbNullString) 'Object
      .Key = K_OBJECT
      .Value = m_object
      .Width = 6800
      .TabIndex = 1
    End With
  
  End With
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

Private Function Load(ByVal Id As Long) As Boolean

  Dim sqlstmt As String
  Dim rs As Recordset

  sqlstmt = "select * from AlarmaMail where alm_id = " & Id

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, _
                    csCmdText, "Load", C_Module) Then Exit Function

  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.fields, cscAlmId)
    m_Nombre = gDB.ValField(rs.fields, cscAlmNombre)
    m_script_mail = gDB.ValField(rs.fields, cscAlmScriptMails)
    m_script_result = gDB.ValField(rs.fields, cscAlmScriptResult)
    m_object = gDB.ValField(rs.fields, cscAlmObject)
    m_frecuencia = gDB.ValField(rs.fields, cscAlmFrecuencia)
    m_mails = gDB.ValField(rs.fields, cscAlmMails)
    m_Activo = gDB.ValField(rs.fields, cscActivo)

  Else
    m_Id = csNO_ID
    m_Nombre = vbNullString
    m_script_mail = vbNullString
    m_script_result = vbNullString
    m_object = vbNullString
    m_frecuencia = 30
    m_mails = vbNullString
    m_Activo = False

  End If

  Load = True
End Function ' construccion - destruccion

Private Sub Class_Initialize()
  On Error GoTo ControlError

  c_ErrorSave = LNGGetText(3217, vbNullString) 'Error al grabar Alarma Mail
  
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

VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cFeriado"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGeneric
Implements CSInterfacesABM.cIABMClient
Implements CSMenu.cIMenuClient
'--------------------------------------------------------------------------------
' cFeriado
' 14-11-06
'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones
'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cFeriado"

Private Const K_NOMBRE                         As Integer = 1
Private Const K_CODIGO                         As Integer = 2
Private Const K_DESCRIP                        As Integer = 3
Private Const K_DIA                            As Integer = 4
Private Const K_MES                            As Integer = 5
Private Const K_ANIO                           As Integer = 6
Private Const K_BANCO                          As Integer = 7
Private Const K_LABORAL                        As Integer = 8
Private Const K_LOCAL                          As Integer = 9
Private Const K_PA_ID                          As Integer = 10
Private Const K_PRO_ID                         As Integer = 11
Private Const K_RECURRENTE                     As Integer = 12

' estructuras
' variables privadas
Private m_Id                           As Long
Private m_Nombre                       As String
Private m_Codigo                       As String
Private m_descrip                      As String
Private m_dia                          As Integer
Private m_mes                          As Integer
Private m_anio                         As Integer
Private m_Banco                        As Boolean
Private m_laboral                      As Boolean
Private m_local                        As Boolean
Private m_Pa_Id                        As Long
Private m_Pais                         As String
Private m_pro_id                       As Long
Private m_provincia                    As String
Private m_recurrente                   As Boolean

'OJO HASTA ACA

Private m_Editing           As Boolean

Private m_ObjAbm            As cIABMGeneric
Private m_ObjTree           As Object

Private m_IsNew             As Boolean

Private m_BranchId          As Long
Private m_TreeId            As Long
Private m_Host              As CSMenu.cIMenuHost
Private m_Copy              As Boolean

' Properties publicas

Public Property Get Id() As Long
  Id = m_Id
End Property

Public Property Get Nombre() As String
  Nombre = m_Nombre
End Property

Public Property Get Codigo() As String
  Codigo = m_Codigo
End Property

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

  Doc.ClientTable = csTFeriado
  Doc.ClientTableID = m_Id

  cIABMClient_ShowDocDigital = Doc.ShowDocs(gDB)

  GoTo ExitProc
ControlError:
  MngError Err, C_ShowDocDigital, C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIABMClient_MessageEx(ByVal MessageID As Long, ByVal Info As Variant) As Variant
  Select Case MessageID
  
    Case MSG_DOC_INFO
    
      Dim AbmGen As cABMGeneric
      Set AbmGen = m_ObjAbm
      
      CSKernelClient2.ShowHelp AbmGen.hWnd, _
                               vbNullString, _
                               vbNullString, _
                               csPreGNewFeriado
      cIABMClient_MessageEx = MSG_DOC_INFO_HANDLED
    Case Else
      cIABMClient_MessageEx = True
  End Select
End Function

Private Sub cIABMClient_DiscardChanges()
    LoadCollection
End Sub

Private Function cIABMClient_ListAdHock(List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClient_Load()

End Sub

Private Function cIABMClient_PropertyChange(ByVal Key As Integer) As Boolean
  
  With m_ObjAbm.Properties
  
    Select Case Key
      Case K_LOCAL
        
        .Item(cscProId).Enabled = Val(.Item(cscFeLocal).Value)
        .Item(cscPaId).Enabled = Val(.Item(cscFeLocal).Value)
        
    End Select
    
  End With
  
  cIABMClient_PropertyChange = True
End Function

Private Function cIABMClient_Copy() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True
  
  With m_ObjAbm.Properties(cscFeCodigo)
    .Value = C_C & .Value
  End With
  
'  With m_ObjAbm.Properties(cscFeNombre)
'    .Value = C_CopiaDe & .Value
'  End With
  
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscFeCodigo)
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscFeNombre)
  
  m_Copy = True
End Function

Private Function cIABMClient_EditNew() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True
  
  cIEditGeneric_Edit csNO_ID
End Function

Private Function cIABMClient_Save() As Boolean
  Dim sqlstmt    As String
  Dim register   As cRegister
  Dim fields     As cFields
  
  Set register = New cRegister
  Set fields = register.fields
  
  With register
    .fieldId = cscFeId
    .Table = csTFeriado
  
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
          fields.Add2 cscFeNombre, .Value, csText
        Case K_CODIGO
          fields.Add2 cscFeCodigo, .Value, csText
        Case K_DESCRIP
          fields.Add2 cscFeDescrip, .Value, csText
        Case K_DIA
          fields.Add2 cscFeDia, .Value, csInteger
        Case K_MES
          fields.Add2 cscFeMes, .Value, csInteger
        Case K_ANIO
          fields.Add2 cscFeAnio, .Value, csInteger
        Case K_BANCO
          fields.Add2 cscFeBanco, .Value, csBoolean
        Case K_LABORAL
          fields.Add2 cscFeLaboral, .Value, csBoolean
        Case K_LOCAL
          fields.Add2 cscFeLocal, .Value, csBoolean
        Case K_PA_ID
          fields.Add2 cscPaId, .HelpId, csId
        Case K_PRO_ID
          fields.Add2 cscProId, .HelpId, csId
        Case K_RECURRENTE
          fields.Add2 cscFeRecurrente, .Value, csBoolean
      End Select
    End With
  Next
  
  fields.HaveLastUpdate = True
  fields.HaveWhoModify = True
  
  register.BeginTrans gDB
                                                         'Error al grabar el Feriado
  If Not gDB.SaveEx(register, , _
                    cscFeCodigo, _
                    C_ABMClientSave, _
                    C_Module, _
                    LNGGetText(1543, vbNullString)) Then Exit Function
  
  sqlstmt = "sp_FeriadoSave " & register.Id
  If Not gDB.Execute(sqlstmt) Then Exit Function
  
  register.CommitTrans
  
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
    cIABMClient_Title = LNGGetText(1544, vbNullString)  'Feriados
End Property


Private Function cIABMClient_Validate() As Boolean
  Dim dia       As Integer
  Dim mes       As Integer
  Dim anio      As Integer
  Dim IProperty As cIABMProperty

  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_NOMBRE
          If ValEmpty(.Value, csText) Then
            MsgInfo LNGGetText(1007, vbNullString)
                    'Debe indicar un Nombre
            Exit Function
          End If
        Case K_CODIGO
          If ValEmpty(.Value, csText) Then
            MsgInfo LNGGetText(1008, vbNullString)
                    'Debe indicar un Código"
            Exit Function
          End If
        Case K_DIA
          dia = Val(.Value)
          If dia < 1 Or dia > 31 Then
            MsgInfo LNGGetText(1545, vbNullString)
                    'Debe indicar un día entre 1 y 31
            Exit Function
          End If
        Case K_MES
          mes = Val(.Value)
          If mes < 1 Or mes > 12 Then
            MsgInfo LNGGetText(1546, vbNullString)
                    'Debe indicar un mes entre 1 y 12
            Exit Function
          Else
            Select Case mes
              Case 4, 6, 9, 11
                If dia > 30 Then
                  MsgInfo LNGGetText(1547, vbNullString)
                          'Debe indicar un día entre 1 y 30
                End If
              Case 2
                If dia > 29 Then
                  MsgInfo LNGGetText(1548, vbNullString)
                          'Debe indicar un día entre 1 y 29
                End If
            End Select
          End If
        Case K_ANIO
          anio = Val(.Value)
          If anio <> 0 Then
            If mes = 2 And dia > 28 Then
              If IsDate(Format$(dia, "00") & "-" & _
                        Format$(mes, "00") & "-" & _
                        Format$(anio, "0000")) Then
                MsgInfo LNGGetText(1549, vbNullString)
                        'La fecha no es válida
                Exit Function
              End If
            End If
          End If
      End Select
    End With
  Next

  cIABMClient_Validate = True
End Function

' Implementacion de cIEditGeneric
Private Property Get cIEditGeneric_ObjAbm() As CSInterfacesABM.cIABMGeneric
  Set cIEditGeneric_ObjAbm = m_ObjAbm
End Property

Private Function cIEditGeneric_TabClick(ByVal Index As Integer) As Boolean

End Function

Private Property Let cIEditGeneric_TreeId(ByVal rhs As Long)
    m_TreeId = rhs
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
    cIEditGeneric_ShowList = SecurityCanAccess(csPreGListFeriado)
End Function

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
    Set m_ObjAbm = rhs
End Property

Private Property Get cIEditGeneric_Editing() As Boolean
    cIEditGeneric_Editing = m_Editing
End Property

Private Function cIEditGeneric_Delete(Id As Long) As Boolean
    If Not SecurityCanAccess(csPreGDeleteFeriado) Then Exit Function

    Dim sqlstmt As String
    
    sqlstmt = "sp_FeriadoDelete " & Id

    cIEditGeneric_Delete = gDB.Execute(sqlstmt, C_EditGenericDelete, C_Module)
End Function

Private Function cIEditGeneric_Search(Id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Id = csNO_ID Then
    m_IsNew = True
    If Not SecurityCanAccess(csPreGNewFeriado) Then Exit Function
  Else
    m_IsNew = False
    If Not SecurityCanAccess(csPreGEditFeriado) Then Exit Function
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
  MngError Err, C_EditGenericEdit, C_Module, vbNullString
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
  
  m_Host.Server.AddMenu C_MenuTesoreria, csMenuConfigGeneral, C_MenuConfig, 0, True, False, False, False, True, Nothing
                        '&Feriado
  m_Host.Server.AddMenu LNGGetText(1209, vbNullString), csPreGListFeriado, C_MenuTesoreria, 0, True, False, False, False, False, Me

  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, C_MenuClientInit, C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal Id As Long) As Variant
                                                'Feriado
  m_Host.MenuABMClick "CSGeneral2.cFeriado", Me, LNGGetText(1210, vbNullString), 0, csETablasGeneral.csFeriado
End Function

' funciones privadas
Private Function LoadCollection() As Boolean
    
  m_ObjAbm.Title2 = m_Nombre

  With m_ObjAbm.Properties
    
    .Clear
    
    With .Add(Nothing, cscFeNombre)
      .PropertyType = cspText
      .Name = C_strNombre
      .Width = 6200
      .Size = 100
      .Key = K_NOMBRE
      .Value = m_Nombre
      .LeftLabel = -800
      .Left = 1300
    End With
      
    With .Add(Nothing, cscFeCodigo)
      .PropertyType = cspText
      .Name = C_strCodigo
      .Size = 15
      .Key = K_CODIGO
      .Value = m_Codigo
    End With
      
    With .Add(Nothing, cscFeDia)
      .PropertyType = cspNumeric
      .SubType = cspInteger
      .Name = LNGGetText(1214, vbNullString)  'Día
      .Key = K_DIA
      .Value = m_dia
      .Width = 700
    End With
      
    With .Add(Nothing, cscFeMes)
      .PropertyType = cspNumeric
      .SubType = cspInteger
      .Name = LNGGetText(1215, vbNullString)  'Mes
      .Key = K_MES
      .Value = m_mes
      .TopFromProperty = cscFeDia
      .Left = 2500
      .LeftLabel = -400
      .Width = 700
    End With
      
    With .Add(Nothing, cscFeAnio)
      .PropertyType = cspNumeric
      .SubType = cspInteger
      .Name = LNGGetText(1216, vbNullString)  'Año
      .Key = K_ANIO
      .Value = m_anio
      .TopFromProperty = cscFeDia
      .Left = 3800
      .LeftLabel = -400
      .Width = 1000
    End With
    
    With .Add(Nothing, cscFeRecurrente)
      .PropertyType = cspCheck
      .Name = LNGGetText(1217, vbNullString)  'Recurrente
      .Key = K_RECURRENTE
      .Value = CInt(m_recurrente)
      .LeftFromProperty = cscFeNombre
      .LeftToPrevious = 380
    End With
      
    With .Add(Nothing, cscFeBanco)
      .PropertyType = cspCheck
      .Name = LNGGetText(1218, vbNullString)  'Feriado Bancario
      .Key = K_BANCO
      .Value = CInt(m_Banco)
      .TopFromProperty = cscFeRecurrente
      .Left = 4000
      .LeftLabel = -1450
    End With
      
    With .Add(Nothing, cscFeLaboral)
      .PropertyType = cspCheck
      .Name = LNGGetText(1219, vbNullString)  'Feriado Laboral
      .Key = K_LABORAL
      .Value = CInt(m_laboral)
      .TopFromProperty = cscFeRecurrente
      .Left = 6000
      .LeftLabel = -1400
    End With
      
    With .Add(Nothing, cscFeLocal)
      .PropertyType = cspCheck
      .Name = LNGGetText(1213, vbNullString)  'Feriado Local
      .Key = K_LOCAL
      .Value = CInt(m_local)
      .LeftLabel = -1200
      .Left = 1680
    End With
    
    With .Add(Nothing, cscPaId)
      .PropertyType = cspHelp
      .Table = csPais
      .Name = LNGGetText(1212, vbNullString)  'País
      .Key = K_PA_ID
      .Value = m_Pais
      .HelpId = m_Pa_Id
      .Enabled = CInt(m_local)
      .Left = 1800
      .LeftLabel = -800
    End With
      
    With .Add(Nothing, cscProId)
      .PropertyType = cspHelp
      .Table = csProvincia
      .Name = LNGGetText(1080, vbNullString)  'Provincia
      .Key = K_PRO_ID
      .Value = m_provincia
      .HelpId = m_pro_id
      .Enabled = CInt(m_local)
      .Left = 1800
      .LeftLabel = -800
    End With
      
    With .Add(Nothing, cscFeDescrip)
      .PropertyType = cspText
      .TopToPrevious = 440
      .Name = LNGGetText(1211, vbNullString)  'Observ.
      .Size = 255
      .Key = K_DESCRIP
      .Value = m_descrip
      .SubType = cspMemo
      .Width = 6200
      .Height = 880
      .Left = 1300
      .LeftLabel = -800
    End With
  
  End With
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

Private Function Load(ByVal Id As Long) As Boolean

  Dim sqlstmt As String
  Dim rs      As Recordset

  sqlstmt = "sp_FeriadoGet " & Id & vbCrLf
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.fields, cscFeId)
    m_Nombre = gDB.ValField(rs.fields, cscFeNombre)
    m_Codigo = gDB.ValField(rs.fields, cscFeCodigo)
    m_descrip = gDB.ValField(rs.fields, cscFeDescrip)
    m_dia = gDB.ValField(rs.fields, cscFeDia)
    m_mes = gDB.ValField(rs.fields, cscFeMes)
    m_anio = gDB.ValField(rs.fields, cscFeAnio)
    m_Banco = gDB.ValField(rs.fields, cscFeBanco)
    m_laboral = gDB.ValField(rs.fields, cscFeLaboral)
    m_local = gDB.ValField(rs.fields, cscFeLocal)
    m_Pa_Id = gDB.ValField(rs.fields, cscPaId)
    m_Pais = gDB.ValField(rs.fields, cscPaNombre)
    m_pro_id = gDB.ValField(rs.fields, cscProId)
    m_provincia = gDB.ValField(rs.fields, cscProNombre)
    m_recurrente = gDB.ValField(rs.fields, cscFeRecurrente)

  Else
    
    m_Id = csNO_ID
    m_Nombre = vbNullString
    m_Codigo = vbNullString
    m_descrip = vbNullString
    m_dia = 1
    m_mes = 1
    m_anio = Year(Date)
    m_Banco = True
    m_laboral = True
    m_local = False
    m_Pa_Id = csNO_ID
    m_Pais = vbNullString
    m_pro_id = csNO_ID
    m_provincia = vbNullString
    m_recurrente = True

  End If

  Load = True
End Function

' construccion - destruccion
Private Sub Class_Terminate()
  On Error Resume Next
  Set m_ObjAbm = Nothing
  Set m_ObjTree = Nothing
End Sub

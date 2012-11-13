VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cEjercicioContable"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGeneric
Implements CSInterfacesABM.cIABMClient
Implements CSMenu.cIMenuClient
'--------------------------------------------------------------------------------
' cEjercicioContable
' 12-06-03
'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cEjercicioContable"

Private Const c_cmd_apertura = "cmdAp"
Private Const c_cmd_cierrepatrimonial = "cmdCP"
Private Const c_cmd_cierreresultados = "cmdCR"

Private Const c_show_apertura = "showap"
Private Const c_delete_apertura = "deleteap"
Private Const c_show_patrimonial = "showpa"
Private Const c_delete_patrimonial = "deletepa"
Private Const c_show_resultados = "showres"
Private Const c_delete_resultados = "deleteres"

Private Const K_NOMBRE                         As Integer = 1
Private Const K_CODIGO                         As Integer = 2
Private Const K_DESCRIP                        As Integer = 3
Private Const K_EMP_ID                         As Integer = 4
Private Const K_CICO_ID                        As Integer = 5
Private Const K_DOC_ID                         As Integer = 6
Private Const K_CUE_ID                         As Integer = 7
Private Const K_FECHAINI                       As Integer = 8
Private Const K_FECHAFIN                       As Integer = 9

Private Const K_APERTURA                       As Integer = 105
Private Const K_CIERREPATRIMONIAL              As Integer = 106
Private Const K_CIERRERESULTADOS               As Integer = 107

Private Const K_CMD_APERTURA                       As Integer = 108
Private Const K_CMD_CIERREPATRIMONIAL              As Integer = 109
Private Const K_CMD_CIERRERESULTADOS               As Integer = 110

Private Const K_CMD_VIEW_APERTURA                       As Integer = 208
Private Const K_CMD_VIEW_CIERREPATRIMONIAL              As Integer = 209
Private Const K_CMD_VIEW_CIERRERESULTADOS               As Integer = 210

Private Const K_CMD_DEL_APERTURA                       As Integer = 308
Private Const K_CMD_DEL_CIERREPATRIMONIAL              As Integer = 309
Private Const K_CMD_DEL_CIERRERESULTADOS               As Integer = 310

' estructuras
' variables privadas
Private m_Id                           As Long
Private m_Nombre                       As String
Private m_Codigo                       As String
Private m_Descrip                      As String

Private m_FechaIni                     As Date
Private m_FechaFin                     As Date

Private m_emp_id                       As String
Private m_empresa                      As String

Private m_cico_id                      As String
Private m_circuito                     As String
Private m_cue_id                       As Long
Private m_cuenta                       As String
Private m_doc_id                       As Long
Private m_Documento                    As String

Private m_apertura                     As String
Private m_cierrePatrimonial            As String
Private m_cierreResultados             As String

Private m_as_id_apertura               As Long
Private m_as_id_cierrepatrimonial      As Long
Private m_as_id_cierreresultados       As Long

'OJO HASTA ACA

Private m_Editing           As Boolean

Private m_ObjAbm            As cIABMGeneric
Private m_ObjTree           As Object

Private m_IsNew             As Boolean

Private m_BranchId          As Long
Private m_TreeId            As Long

Private m_Host              As CSMenu.cIMenuHost
Private m_Copy              As Boolean

Private m_SaveSuccess       As Boolean

' Properties publicas

Public Property Get ID() As Long
  ID = m_Id
End Property

Public Property Get Nombre() As String
  Nombre = m_Codigo
End Property

Public Property Get Codigo() As String
  Codigo = m_Codigo
End Property

' Properties privadas
' funciones publicas

' Implementacion de cIABMClient
Private Function cIABMClient_Copy() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True
  
  With m_ObjAbm.Properties(cscEjcCodigo)
    .Value = C_C & .Value
  End With
   
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscEjcCodigo)
   
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

  Doc.ClientTable = csTEjercicioContable
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
                               csPreConNewEjercicio
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
  Select Case Key
    Case K_CICO_ID, K_EMP_ID
      With m_ObjAbm.Properties
        .Item(cscDocId).HelpFilter = pGetDocFilter(.Item(cscEmpId).HelpId, _
                                                   .Item(cscCicoId).HelpId)
      
        m_ObjAbm.ShowValue .Item(cscDocId)
        
        If Key = K_EMP_ID Then
          .Item(cscCueId).HelpFilter = pGetCueFilter(.Item(cscEmpId).HelpId)
          
          m_ObjAbm.ShowValue .Item(cscCueId)
        End If
        
      End With
  
    Case K_CMD_APERTURA
      
      m_SaveSuccess = False
      pForceSave
      If m_SaveSuccess Then
        pCreateApertura
        pForceSave
      End If
    
    Case K_CMD_CIERREPATRIMONIAL
    
      m_SaveSuccess = False
      pForceSave
      If m_SaveSuccess Then
        pCreateCierrePatrimonial
          pForceSave
      End If
    
    Case K_CMD_CIERRERESULTADOS
    
      m_SaveSuccess = False
      pForceSave
      If m_SaveSuccess Then
        pCreateCierreResultados
        pForceSave
      End If
      
    Case K_CMD_VIEW_APERTURA
      pShowAsiento m_as_id_apertura
      
    Case K_CMD_VIEW_CIERREPATRIMONIAL
      pShowAsiento m_as_id_cierrepatrimonial
      
    Case K_CMD_VIEW_CIERRERESULTADOS
      pShowAsiento m_as_id_cierreresultados
  
    Case K_CMD_DEL_APERTURA
      pDeleteApertura
      
    Case K_CMD_DEL_CIERREPATRIMONIAL
      pDeletePatrimonial
      
    Case K_CMD_DEL_CIERRERESULTADOS
      pDeleteResultados
  End Select
End Function

Private Function cIABMClient_Save() As Boolean
  Dim register   As cRegister
  Dim fields     As cFields
  
  Set register = New cRegister
  Set fields = register.fields
  
  With register
    .fieldId = cscEjcId
    .Table = csTEjercicioContable
  
    If m_Copy Then
      .ID = csNew
    Else
      .ID = m_Id
    End If
  End With
  
  Dim IProperty As cIABMProperty
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_NOMBRE
          fields.Add2 cscEjcNombre, .Value, csText
        Case K_CODIGO
          fields.Add2 cscEjcCodigo, .Value, csText
        Case K_FECHAINI
          fields.Add2 cscEjcFechaIni, .Value, csDate
        Case K_FECHAFIN
          fields.Add2 cscEjcFechaFin, .Value, csDate
        Case K_DESCRIP
          fields.Add2 cscEjcDescrip, .Value, csText
        Case K_EMP_ID
          fields.Add2 cscEmpId, .HelpValueProcess, csText
        Case K_CICO_ID
          fields.Add2 cscCicoId, .HelpValueProcess, csText
        Case K_DOC_ID
          fields.Add2 cscDocId, .HelpId, csId
        Case K_CUE_ID
          fields.Add2 cscCueIdResultado, .HelpId, csId
      End Select
    End With
  Next
  
  fields.HaveLastUpdate = True
  fields.HaveWhoModify = True
  
  If Not register.BeginTrans(gDB) Then Exit Function
  
  If Not gDB.Save(register, , C_ABMClientSave, C_Module, LNGGetText(1740, vbNullString)) Then Exit Function
  
  If Not pSaveEmpresas(register.ID) Then Exit Function
  If Not pSaveCircuitos(register.ID) Then Exit Function
  
  If Not register.CommitTrans() Then Exit Function
  
  m_Copy = False
  m_SaveSuccess = Load(register.ID)
  cIABMClient_Save = m_SaveSuccess
End Function

Private Function pSaveEmpresas(ByVal ejc_id As Long) As Boolean
  Dim sqlstmt As String
  sqlstmt = "sp_EjercicioSaveEmpresas " & ejc_id
  If Not gDB.Execute(sqlstmt) Then Exit Function
  pSaveEmpresas = True
End Function

Private Function pSaveCircuitos(ByVal ejc_id As Long) As Boolean
  Dim sqlstmt As String
  sqlstmt = "sp_EjercicioSaveCircuitos " & ejc_id
  If Not gDB.Execute(sqlstmt) Then Exit Function
  pSaveCircuitos = True
End Function

Private Function cIABMClient_Terminate() As Boolean
  m_Editing = False
  
  cIABMClient_Terminate = True
  ' Este objeto puede no cumplir con la interfaz esperada, asi que si hay un error no
  ' le doy bola
  On Error GoTo ControlError
  If m_Id = csNO_ID Then Exit Function
  If m_ObjTree Is Nothing Then Exit Function
  
  m_ObjTree.sqlstmt = "sp_lsdoc_ejercicio"
  
  If m_IsNew Then
    m_ObjTree.AddLine m_Id
  Else
    m_ObjTree.RefreshLine m_Id
  End If
ControlError:
End Function

Private Property Get cIABMClient_Title() As String
                      ' Ejercicios Contables
  cIABMClient_Title = LNGGetText(1741, vbNullString)
End Property

Private Function cIABMClient_Validate() As Boolean
  Dim IPropiedad As cIABMProperty
  
  For Each IPropiedad In m_ObjAbm.Properties
      With IPropiedad
          Select Case .Key
              Case K_CODIGO
                  If ValEmpty(.Value, csText) Then
                      MsgInfo C_DebeIndicarCodigo
                      Exit Function
                  End If
'              Case K_EMP_ID
'                  If ValEmpty(.HelpId, csId) Then
'                      MsgInfo LNGGetText(1129, vbNullString)  'Debe indicar una Empresa
'                      Exit Function
'                  End If
'              Case K_CICO_ID
'                  If ValEmpty(.HelpId, csId) Then
'                      MsgInfo LNGGetText(1974, vbNullString)  'Debe indicar un Circuito Contable
'                      Exit Function
'                  End If
              Case K_DOC_ID
                  If ValEmpty(.HelpId, csId) Then
                      MsgInfo LNGGetText(1977, vbNullString)  'Debe indicar un Documento de Asiento
                      Exit Function
                  End If
              Case K_FECHAINI
                  If ValEmpty(.Value, csDate) Then
                      MsgInfo LNGGetText(1975, vbNullString)  'Debe indicar una fecha de inicio para el ejercicio
                      Exit Function
                  End If
              Case K_FECHAFIN
                  If ValEmpty(.Value, csDate) Then
                      MsgInfo LNGGetText(1976, vbNullString)  'Debe indicar una fecha de fin para el ejercicio
                      Exit Function
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
  cIEditGeneric_ShowList = SecurityCanAccess(csPreConListEjercicio)
End Function

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
  Set m_ObjAbm = rhs
End Property

Private Property Get cIEditGeneric_Editing() As Boolean
  cIEditGeneric_Editing = m_Editing
End Property

Private Function cIEditGeneric_Delete(ID As Long) As Boolean
  If Not SecurityCanAccess(csPreConDeleteEjercicio) Then Exit Function

  Dim sqlstmt As String
  
  sqlstmt = "delete EjercicioContable where ejc_id = " & ID
  
  cIEditGeneric_Delete = gDB.Execute(sqlstmt, C_EditGenericDelete, C_Module)
End Function

Private Function cIEditGeneric_Search(ID As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(ID As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If ID = csNO_ID Then
    m_IsNew = True
    If Not SecurityCanAccess(csPreConNewEjercicio) Then Exit Function
  Else
    m_IsNew = False
    If Not SecurityCanAccess(csPreConEditEjercicio) Then Exit Function
  End If

  m_ObjAbm.InModalWindow = InModalWindow

  If Not Load(ID) Then Exit Function
  
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

Private Function cIEditGeneric_PrintObj(ByVal ID As Long) As Boolean

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

Private Function cIEditGeneric_Preview(ByVal ID As Long) As Boolean

End Function

Private Function cIEditGeneric_PropertyChange(ByVal Key As Integer) As Boolean

End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  
  Dim oProp  As cABMProperty
  Dim c      As cIABMProperty
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  
  AbmObj.MinHeight = 8000
  AbmObj.UseHelpValueProcess = True
  
  m_ObjAbm.Title2 = m_Nombre
  
  With m_ObjAbm.Properties
    
    .Clear
    
    With .Add(Nothing, cscEjcNombre)
      .PropertyType = cspText
      .Name = C_strNombre
      .Key = K_NOMBRE
      .Value = m_Nombre
      .Width = 6250
    End With
    
    With .Add(Nothing, cscEjcCodigo)
      .PropertyType = cspText
      .Name = C_strCodigo
      .Key = K_CODIGO
      .Value = m_Codigo
    End With
      
    With .Add(Nothing, cscEjcFechaIni)
      .PropertyType = cspDate
      .Name = LENGGetText(1203, vbNullString)
      .Key = K_FECHAINI
      .Value = m_FechaIni
    End With
      
    With .Add(Nothing, cscEjcFechaFin)
      .PropertyType = cspDate
      .Name = LENGGetText(1204, vbNullString)
      .Key = K_FECHAFIN
      .Value = m_FechaFin
      .LeftNotChange = True
      .Left = 5500
      .TopFromProperty = cscEjcFechaIni
    End With
      
    Set c = .Add(Nothing, cscEmpId)
    Set oProp = c
    oProp.IsForAbm = True
    With c
      .PropertyType = cspHelp
      .Table = csEmpresa
      .Name = LENGGetText(1114, vbNullString)
      .Key = K_EMP_ID
      
      .HelpId = Val(m_emp_id)
      .HelpValueProcess = m_emp_id
      .Value = m_empresa
      
      oProp.HelpType = csTree
      Set oProp = Nothing
    End With
    
    Set c = .Add(Nothing, cscCicoId)
    Set oProp = c
    oProp.IsForAbm = True
    With c
      .PropertyType = cspHelp
      .Table = csCircuitoContable
      .Name = LENGGetText(1073, vbNullString)
      .Key = K_CICO_ID
      
      .HelpId = Val(m_cico_id)
      .HelpValueProcess = m_cico_id
      .Value = m_circuito
      
      .LeftNotChange = True
      .Left = 5500
      .TopFromProperty = cscEmpId
      oProp.HelpType = csTree
      Set oProp = Nothing
    End With
    
    Set c = .Add(Nothing, cscDocId)
    Set oProp = c
    oProp.IsForAbm = True
    With c
      .PropertyType = cspHelp
      .Table = CSDocumento
      .Name = LENGGetText(1567, vbNullString)
      .Key = K_DOC_ID
      .Value = m_Documento
      .HelpId = m_doc_id
      .HelpFilter = pGetDocFilter(m_emp_id, m_cico_id)
    End With
    
    With .Add(Nothing, cscCueId)
      .PropertyType = cspHelp
      .Table = csCuenta
      .Name = LENGGetText(1267, vbNullString)
      .Key = K_CUE_ID
      .Value = m_cuenta
      .HelpId = m_cue_id
      .HelpFilter = pGetCueFilter(m_emp_id)
      .LeftNotChange = True
      .Left = 5500
      .TopFromProperty = cscDocId
    End With
    
    With .Add(Nothing, cscEjcDescrip)
      .PropertyType = cspText
      .Name = C_strDescrip
      .SubType = cspMemo
      .Width = 6250
      .Height = 880
      .Size = 255
      .Key = K_DESCRIP
      .Value = m_Descrip
      .LeftFromProperty = cscEjcCodigo
      .TopFromProperty = cscDocId
      .TopToPrevious = 440
    End With
    
    '-----------------------------------------------------------
    ' Apertura
    
        With .Add(Nothing, cscAsIdApertura)
          .PropertyType = cspText
          .Name = LENGGetText(1744, vbNullString)
          .Key = K_APERTURA
          .Width = 5000
          .Value = m_apertura
        End With
        
        With .Add(Nothing, c_show_apertura)
          .PropertyType = cspButton
          .Name = "..."
          .Key = K_CMD_VIEW_APERTURA
          .Width = 400
          .Enabled = m_as_id_apertura <> csNO_ID
          .TopFromProperty = cscAsIdApertura
          .LeftNotChange = True
          .Left = 7000
        End With
        
        With .Add(Nothing, c_delete_apertura)
          .PropertyType = cspButton
          .Name = LENGGetText(1983, vbNullString) ' Borrar
          .Key = K_CMD_DEL_APERTURA
          .Width = 1000
          .LeftLabel = -1
          .Enabled = m_as_id_cierrepatrimonial = csNO_ID And _
                     m_as_id_cierreresultados = csNO_ID And _
                     m_as_id_apertura <> csNO_ID
          .TopFromProperty = cscAsIdApertura
          .LeftNotChange = True
          .Left = 7500
        End With
    
    '-----------------------------------------------------------
    ' Cierre de resultados

        With .Add(Nothing, cscAsIdCierreResultados)
          .PropertyType = cspText
          .Name = LENGGetText(1746, vbNullString)
          .Key = K_CIERRERESULTADOS
          .Width = 5000
          .Value = m_cierreResultados
        End With
        
        With .Add(Nothing, c_show_resultados)
          .PropertyType = cspButton
          .Name = "..."
          .Key = K_CMD_VIEW_CIERRERESULTADOS
          .Width = 400
          .LeftLabel = -1
          .Enabled = m_as_id_cierreresultados <> csNO_ID
          .TopFromProperty = cscAsIdCierreResultados
          .LeftNotChange = True
          .Left = 7000
        End With
        
        With .Add(Nothing, c_delete_resultados)
          .PropertyType = cspButton
          .Name = LENGGetText(1983, vbNullString) ' Borrar
          .Key = K_CMD_DEL_CIERRERESULTADOS
          .Width = 1000
          .LeftLabel = -1
          .Enabled = m_as_id_cierreresultados <> csNO_ID And m_as_id_cierrepatrimonial = csNO_ID
          .TopFromProperty = cscAsIdCierreResultados
          .LeftNotChange = True
          .Left = 7500
        End With
    
    '-----------------------------------------------------------
    ' Cierre patrimonial
    
        With .Add(Nothing, cscAsIdCierrePatrimonial)
          .PropertyType = cspText
          .Name = LENGGetText(1745, vbNullString)
          .Key = K_CIERREPATRIMONIAL
          .Width = 5000
          .Value = m_cierrePatrimonial
        End With
    
        With .Add(Nothing, c_show_patrimonial)
          .PropertyType = cspButton
          .Name = "..."
          .Key = K_CMD_VIEW_CIERREPATRIMONIAL
          .Width = 400
          .LeftLabel = -1
          .Enabled = m_as_id_cierrepatrimonial <> csNO_ID
          .TopFromProperty = cscAsIdCierrePatrimonial
          .LeftNotChange = True
          .Left = 7000
        End With
        
        With .Add(Nothing, c_delete_patrimonial)
          .PropertyType = cspButton
          .Name = LENGGetText(1983, vbNullString) ' Borrar
          .Key = K_CMD_DEL_CIERREPATRIMONIAL
          .Width = 1000
          .LeftLabel = -1
          .Enabled = m_as_id_cierrepatrimonial <> csNO_ID
          .TopFromProperty = cscAsIdCierrePatrimonial
          .LeftNotChange = True
          .Left = 7500
        End With
    
    '-----------------------------------------------------------
    '
    
    Dim ejc_id_anterior As Long
    
    If m_Id <> csNO_ID Then
      
      If Not pGetEjercicioAnterior(m_emp_id, _
                                   m_cico_id, _
                                   m_FechaIni, _
                                   ejc_id_anterior) Then
        Exit Function
      End If
    End If
    
    With .Add(Nothing, c_cmd_apertura)
      .PropertyType = cspButton
      .Name = LENGGetText(1747, vbNullString)
      .Key = K_CMD_APERTURA
      .TopToPrevious = 900
      .LeftLabel = -1
      .Left = 800
      .Width = 2400
      
      ' Solo se puede modificar el asiento
      ' de apertura si aun no se han hecho los
      ' asientos de cierre
      '
      ' Ademas el primer ejercicio no tiene apertura
      '
      .Enabled = Not CBool(m_as_id_cierrepatrimonial _
                          Or m_as_id_cierreresultados) _
                 And m_Id _
                 And ejc_id_anterior <> csNO_ID ' Debe haber un ejerccio anterior
    End With
    
    ' El primer ejercicio no requiere apertura
    '
    With .Add(Nothing, c_cmd_cierreresultados)
      .PropertyType = cspButton
      .Name = LENGGetText(1749, vbNullString)
      .Key = K_CMD_CIERRERESULTADOS
      .LeftLabel = -1
      .Left = 3300
      .Width = 2400
      .TopFromProperty = c_cmd_apertura
      .Enabled = (CBool(m_as_id_apertura) _
                  Or ejc_id_anterior = csNO_ID _
                 ) And m_Id <> csNO_ID _
                 And m_as_id_cierrepatrimonial = csNO_ID
    End With
    
    ' Solo puedo hacer el cierre patrimonial si tengo hecho el cierre
    ' de resultados y el ejercicio siguiente aun no esta abierto
    '
    With .Add(Nothing, c_cmd_cierrepatrimonial)
      .PropertyType = cspButton
      .Name = LENGGetText(1748, vbNullString)
      .Key = K_CMD_CIERREPATRIMONIAL
      .LeftLabel = -1
      .Left = 5800
      .Width = 2400
      .TopFromProperty = c_cmd_apertura
      .Enabled = m_as_id_cierreresultados <> csNO_ID _
                 And Not pEjercicioSiguienteAbierto()
    End With
    
  End With
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

Private Function Load(ByVal ID As Long) As Boolean

  Dim sqlstmt As String
  Dim rs      As Recordset
  
  sqlstmt = "sp_EjercicioContableGet " & ID

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.fields, cscEjcId)
    m_Codigo = gDB.ValField(rs.fields, cscEjcCodigo)
    m_Descrip = gDB.ValField(rs.fields, cscEjcDescrip)
    m_Nombre = gDB.ValField(rs.fields, cscEjcNombre)
    
    m_FechaIni = gDB.ValField(rs.fields, cscEjcFechaIni)
    m_FechaFin = gDB.ValField(rs.fields, cscEjcFechaFin)
    
    m_empresa = gDB.ValField(rs.fields, cscEmpNombre)
    m_emp_id = gDB.ValField(rs.fields, cscEmpId)
    
    m_cico_id = gDB.ValField(rs.fields, cscCicoId)
    m_circuito = gDB.ValField(rs.fields, cscCicoNombre)
    m_doc_id = gDB.ValField(rs.fields, cscDocId)
    m_Documento = gDB.ValField(rs.fields, cscDocNombre)
    m_cue_id = gDB.ValField(rs.fields, cscCueIdResultado)
    m_cuenta = gDB.ValField(rs.fields, cscCueNombre)
    
    m_apertura = gDB.ValField(rs.fields, "Apertura")
    m_cierrePatrimonial = gDB.ValField(rs.fields, "Cierre Patrimonial")
    m_cierreResultados = gDB.ValField(rs.fields, "Cierre Resultados")
    
    m_as_id_apertura = gDB.ValField(rs.fields, cscAsIdApertura)
    m_as_id_cierrepatrimonial = gDB.ValField(rs.fields, cscAsIdCierrePatrimonial)
    m_as_id_cierreresultados = gDB.ValField(rs.fields, cscAsIdCierreResultados)

  Else
    
    m_Id = csNO_ID
    m_Codigo = vbNullString
    m_Descrip = vbNullString
    m_Nombre = vbNullString
    
    m_FechaIni = VDGetDateById(csYear_FirstDay)
    m_FechaFin = VDGetDateById(csYear_LastDay)
    
    m_emp_id = csNO_ID
    m_empresa = vbNullString
    m_cico_id = csNO_ID
    m_circuito = vbNullString
    m_doc_id = csNO_ID
    m_Documento = vbNullString
    m_cue_id = csNO_ID
    m_cuenta = vbNullString

    m_apertura = vbNullString
    m_cierrePatrimonial = vbNullString
    m_cierreResultados = vbNullString

    m_as_id_apertura = csNO_ID
    m_as_id_cierrepatrimonial = csNO_ID
    m_as_id_cierreresultados = csNO_ID

  End If

  Load = True

End Function

Private Function cIMenuClient_Initialize(F As Object, Host As CSMenu.cIMenuHost) As Boolean
  On Error GoTo ControlError
  
  Dim str_1742 As String ' Con&tabilidad
  
  str_1742 = LNGGetText(1742, vbNullString)
  
  Set m_Host = Host
  
  m_Host.Server.AddMenu str_1742, csMenuEnum.csMenuContabilidad, vbNullString, 1, False, False, False, True, False, Nothing
  m_Host.Server.AddMenu LNGGetText(1743, vbNullString), csPreConListEjercicio, str_1742, 0, True, False, False, False, False, Me

  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, C_MenuClientInit, C_Module, vbNullString
  If Err.Number Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal ID As Long) As Variant
                                                
  m_Host.MenuListDocClick "CSABMInterface2.CABMGeneric", _
                          "CSContabilidad2.cEjercicioContable", _
                          "CSABMInterface2.CABMGenericListDoc", _
                          "CSContabilidad2.cEjercicioListDoc", _
                          Me, _
                          LNGGetText(1741, vbNullString), _
                          0
End Function

' construccion - destruccion
Private Sub Class_Terminate()
  On Error Resume Next
  Set m_ObjAbm = Nothing
  Set m_ObjTree = Nothing
End Sub

Private Function pGetDocFilter(ByVal emp_id As String, _
                               ByVal cico_id As String) As String
  Dim rtn As String
  
  If Val(cico_id) <> csNO_ID Then
    rtn = "doct_id = 15 and cico_id = " & cico_id
  Else
    rtn = "doct_id = 15 "
  End If
  
  If Val(emp_id) <> csNO_ID Then
    rtn = rtn & " and emp_id = " & emp_id
  End If
  
  pGetDocFilter = rtn
End Function

Private Function pGetCueFilter(ByVal emp_id As String) As String
  Dim rtn As String
  
  rtn = "cuec_id in (1,2,3,4,5,6,7,8,14,19)"
  
  If Val(emp_id) <> csNO_ID Then
    rtn = rtn & " and (emp_id is null or emp_id = " & emp_id & ")"
  End If
  
  pGetCueFilter = rtn
End Function

Private Function pCreateApertura() As Boolean

  If pEjercicioAnteriorAbierto() Then
    MsgWarning LNGGetText(1978, vbNullString)   'El ejercicio anterior no está cerrado
    Exit Function
  End If
  
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_EjercicioAperturaSave " & gDB.UserId & "," & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  If rs.EOF Then Exit Function
  
  Dim as_id     As Long
  Dim as_nrodoc As Long
  
  If Not GetDocIDFromRecordset(rs, as_id) Then Exit Function
  
'  If Not gDB.GetData(csTAsiento, cscAsId, as_id, cscAsNrodoc, as_nrodoc) Then Exit Function
'
'  With m_ObjAbm.Properties
'    .Item(cscAsIdApertura).Value = Format(pGetFechaIni, "dd/mm/yyyy") & " " & as_nrodoc
'    m_ObjAbm.ShowValue .Item(cscAsIdApertura)
'
'    .Item(cscAsIdCierrePatrimonial).Enabled = True
'    .Item(cscAsIdCierreResultados).Enabled = True
'    m_ObjAbm.ShowValue .Item(cscAsIdCierrePatrimonial)
'    m_ObjAbm.ShowValue .Item(cscAsIdCierreResultados)
'  End With
  
  pCreateApertura = True
End Function

Private Function pEjercicioAnteriorAbierto() As Boolean
  Dim cico_id   As String
  Dim emp_id    As String
  Dim fechaIni  As Date
  Dim ejc_id    As Long
  
  cico_id = pGetCircuito()
  emp_id = pGetEmpresa()
  fechaIni = pGetFechaIni()
  
  If Not pGetEjercicioAnterior(emp_id, _
                               cico_id, _
                               fechaIni, _
                               ejc_id) Then Exit Function
  
  Dim as_id As Long
  
  If Not gDB.GetData(csTEjercicioContable, _
                     cscEjcId, _
                     ejc_id, _
                     cscAsIdCierrePatrimonial, _
                     as_id) Then Exit Function
                     
  pEjercicioAnteriorAbierto = as_id = csNO_ID
End Function

Private Function pEjercicioSiguienteAbierto() As Boolean
  Dim cico_id   As String
  Dim emp_id    As String
  Dim fechaFin  As Date
  Dim ejc_id    As Long
  
  cico_id = pGetCircuito()
  emp_id = pGetEmpresa()
  fechaFin = pGetFechaFin()
  
  If Not pGetEjercicioSiguiente(emp_id, _
                                cico_id, _
                                fechaFin, _
                                ejc_id) Then Exit Function
  
  Dim as_id As Long
  
  If Not gDB.GetData(csTEjercicioContable, _
                     cscEjcId, _
                     ejc_id, _
                     cscAsIdApertura, _
                     as_id) Then Exit Function
                     
  pEjercicioSiguienteAbierto = as_id <> csNO_ID
End Function

Private Function pGetCircuito() As String
  pGetCircuito = m_ObjAbm.Properties.Item(cscCicoId).HelpValueProcess
End Function

Private Function pGetEmpresa() As String
  pGetEmpresa = m_ObjAbm.Properties.Item(cscEmpId).HelpValueProcess
End Function

Private Function pGetFechaIni() As Date
  pGetFechaIni = m_ObjAbm.Properties.Item(cscEjcFechaIni).Value
End Function

Private Function pGetFechaFin() As Date
  pGetFechaFin = m_ObjAbm.Properties.Item(cscEjcFechaFin).Value
End Function

Private Function pGetEjercicioAnterior(ByVal emp_id As String, _
                                       ByVal cico_id As String, _
                                       ByVal fecha As Date, _
                                       ByRef ejc_id As Long) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_EjercicioGetLast " & gDB.sqlString(emp_id) & "," _
                                   & gDB.sqlString(cico_id) & "," _
                                   & gDB.sqlDate(fecha)
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  If Not rs.EOF Then
    ejc_id = gDB.ValField(rs.fields, 0)
  Else
    ejc_id = csNO_ID
  End If
  
  pGetEjercicioAnterior = True
End Function

Private Function pGetEjercicioSiguiente(ByVal emp_id As String, _
                                        ByVal cico_id As String, _
                                        ByVal fecha As Date, _
                                        ByRef ejc_id As Long) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_EjercicioGetNext " & gDB.sqlString(emp_id) & "," _
                                   & gDB.sqlString(cico_id) & "," _
                                   & gDB.sqlDate(fecha)
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  If Not rs.EOF Then
    ejc_id = gDB.ValField(rs.fields, 0)
  Else
    ejc_id = csNO_ID
  End If
  
  pGetEjercicioSiguiente = True
End Function

Private Function pCreateCierrePatrimonial() As Boolean

  If m_as_id_cierreresultados = csNO_ID Then
    MsgWarning LNGGetText(3845, vbNullString)   'Para poder generar el cierre patrimonial, debe generar el asiento de cierre de resultados
    Exit Function
  End If
  
  If pEjercicioSiguienteAbierto() Then
    MsgWarning LNGGetText(3847, vbNullString) 'El siguiente ejercicio posee asiento de apertura. Debe borrar el asiento de apertura del ejercicio siguiente para poder borrar este cierre patrimonial.
    Exit Function
  End If
  
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_EjercicioCierrePSave " & gDB.UserId & "," & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  If rs.EOF Then Exit Function
  
  Dim as_id     As Long
  Dim as_nrodoc As String
  
  If Not GetDocIDFromRecordset(rs, as_id) Then Exit Function
  
'  If Not gDB.GetData(csTAsiento, cscAsId, as_id, cscAsNrodoc, as_nrodoc) Then Exit Function
'
'  With m_ObjAbm.Properties
'    .Item(cscAsIdCierrePatrimonial).Value = Format(pGetFechaIni, "dd/mm/yyyy") & " " & as_nrodoc
'    m_ObjAbm.ShowValue .Item(cscAsIdCierrePatrimonial)
'
'    .Item(cscAsIdApertura).Enabled = False
'    m_ObjAbm.ShowValue .Item(cscAsIdApertura)
'  End With
  
  pCreateCierrePatrimonial = True
End Function

Private Function pEjercicioSinAbrir() As Boolean
  pEjercicioSinAbrir = True
  
  ' Si no hay asiento de apertura
  '
  If m_as_id_apertura = csNO_ID Then
  
    ' Verificamos que no sea el primer ejercicio de la empresa
    '
    Dim sqlstmt As String
    Dim rs      As ADODB.Recordset
    
    Dim cico_id   As String
    Dim emp_id    As String
    Dim fechaIni  As Date
    
    cico_id = pGetCircuito()
    emp_id = pGetEmpresa()
    fechaIni = pGetFechaIni()
    
    sqlstmt = "sp_EjercicioSinAbrir " _
                        & gDB.sqlString(emp_id) & "," _
                        & gDB.sqlString(cico_id) & "," _
                        & gDB.sqlDate(fechaIni)
                 
    If Not gDB.OpenRs(sqlstmt, rs) Then
      Exit Function
    End If
    
    ' Si hay ejercicios anteriores este debe estar abierto
    '
    If Not rs.EOF Then
      If gDB.ValField(rs.fields, 0) <> csNO_ID Then
        Exit Function
      End If
    End If
    
  End If
  
  pEjercicioSinAbrir = False
End Function

Private Function pCreateCierreResultados() As Boolean

  If m_ObjAbm.Properties.Item(cscCueId).HelpId = csNO_ID Then
    MsgWarning LNGGetText(3848, vbNullString)   'Debe indicar la cuenta de resultados
    Exit Function
  End If

  If pEjercicioSinAbrir() Then
    MsgWarning LNGGetText(1979, vbNullString)   'El ejercicio no esta abierto
    Exit Function
  End If
  
  If m_as_id_cierrepatrimonial <> csNO_ID Then
    MsgWarning LNGGetText(3844, vbNullString)   'Este ejercicio ya posee un cierre patrimonial. Debe borrar el cierre patrimonial para poder regenerar el cierre de resultados
    Exit Function
  End If
  
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_EjercicioCierreRSave " & gDB.UserId & "," & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  If rs.EOF Then Exit Function
  
  Dim as_id     As Long
  Dim as_nrodoc As String
  
  If Not GetDocIDFromRecordset(rs, as_id) Then Exit Function
  
'  If Not gDB.GetData(csTAsiento, cscAsId, as_id, cscAsNrodoc, as_nrodoc) Then Exit Function
'
'  With m_ObjAbm.Properties
'    .Item(cscAsIdCierreResultados).Value = Format(pGetFechaIni, "dd/mm/yyyy") & " " & as_nrodoc
'    m_ObjAbm.ShowValue .Item(cscAsIdCierreResultados)
'
'    .Item(cscAsIdApertura).Enabled = False
'    m_ObjAbm.ShowValue .Item(cscAsIdApertura)
'  End With
  
  pCreateCierreResultados = True
End Function

Private Sub pShowAsiento(ByVal AsId As Long)
  ShowDocAux AsId, _
             "CSContabilidad2.cAsiento", _
             "CSABMInterface2.cABMGeneric"
End Sub

Private Function pDeleteApertura() As Boolean

  If m_as_id_cierrepatrimonial <> csNO_ID Or _
     m_as_id_cierreresultados <> csNO_ID Then
     
    MsgWarning LNGGetText(3843, vbNullString)
      ' Este ejercicio posee asientos de cierre.
      ' Debe borrar los asientos de cierre para poder
      ' borrar el asiento de apertura.
    Exit Function
  End If
  
  Dim sqlstmt As String
  
  sqlstmt = "sp_EjercicioAperturaDelete " & gDB.UserId & "," & m_Id
  
  If Not gDB.Execute(sqlstmt) Then Exit Function
  
'  m_as_id_apertura = csNO_ID
'  m_apertura = vbNullString
'
'  With m_ObjAbm.Properties
'    .Item(cscAsIdApertura).Value = vbNullString
'    m_ObjAbm.ShowValue .Item(cscAsIdApertura)
'
'    .Item(cscAsIdCierrePatrimonial).Enabled = False
'    .Item(cscAsIdCierreResultados).Enabled = False
'    m_ObjAbm.ShowValue .Item(cscAsIdCierrePatrimonial)
'    m_ObjAbm.ShowValue .Item(cscAsIdCierreResultados)
'  End With
  
  pForceSave
  
  pDeleteApertura = True
End Function

Private Function pDeleteResultados() As Boolean

  If m_as_id_cierrepatrimonial <> csNO_ID Then
    MsgWarning LNGGetText(3846, vbNullString) 'Este ejercicio ya posee un cierre patrimonial. Debe borrar el cierre patrimonial para poder borrar el cierre de resultados
    Exit Function
  End If
  
  Dim sqlstmt As String
  
  sqlstmt = "sp_EjercicioCierreRDelete " & gDB.UserId & "," & m_Id
  
  If Not gDB.Execute(sqlstmt) Then Exit Function
  
'  m_as_id_cierreresultados = csNO_ID
'  m_cierreResultados = vbNullString
'
'  With m_ObjAbm.Properties
'    .Item(cscAsIdCierreResultados).Value = vbNullString
'    m_ObjAbm.ShowValue .Item(cscAsIdCierreResultados)
'
'    .Item(c_delete_apertura).Enabled = True
'    m_ObjAbm.ShowValue .Item(c_delete_apertura)
'
'    .Item(cscAsIdApertura).Enabled = True
'    m_ObjAbm.ShowValue .Item(cscAsIdApertura)
'  End With
  
  pForceSave
  
  pDeleteResultados = True
End Function

Private Function pDeletePatrimonial() As Boolean

  If pEjercicioSiguienteAbierto() Then
    MsgWarning LNGGetText(3847, vbNullString) 'El siguiente ejercicio posee asiento de apertura. Debe borrar el asiento de apertura del ejercicio siguiente para poder borrar este cierre patrimonial.
    Exit Function
  End If
  
  Dim sqlstmt As String
  
  sqlstmt = "sp_EjercicioCierrePDelete " & gDB.UserId & "," & m_Id
  
  If Not gDB.Execute(sqlstmt) Then Exit Function
  
'  m_as_id_cierrepatrimonial = csNO_ID
'  m_cierrePatrimonial = vbNullString
'
'  With m_ObjAbm.Properties
'    .Item(cscAsIdCierrePatrimonial).Value = vbNullString
'    m_ObjAbm.ShowValue .Item(cscAsIdCierrePatrimonial)
'
'    .Item(c_delete_resultados).Enabled = True
'    m_ObjAbm.ShowValue .Item(c_delete_resultados)
'
'    .Item(cscAsIdCierreResultados).Enabled = True
'    m_ObjAbm.ShowValue .Item(cscAsIdCierreResultados)
'  End With
  
  pForceSave
  
  pDeletePatrimonial = True
End Function

Private Sub pForceSave()
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  AbmObj.Save
End Sub

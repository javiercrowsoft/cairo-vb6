VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cTalonario"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGeneric
Implements CSInterfacesABM.cIABMClient
Implements CSMenu.cIMenuClient

'--------------------------------------------------------------------------------
' cTalonario
' 00-06-03

'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cTalonario"

Private Const K_NOMBRE                         As Integer = 1
Private Const K_CODIGO                         As Integer = 2
Private Const K_DESCRIP                        As Integer = 3
Private Const K_ULTIMONRO                      As Integer = 4
Private Const K_TIPO                           As Integer = 5
Private Const K_MASCARA                        As Integer = 6
Private Const K_CAI                            As Integer = 7
Private Const K_ACTIVO                         As Integer = 8
Private Const K_EMP_ID                         As Integer = 9
Private Const K_PTO_VTA                        As Integer = 10
Private Const K_TIPO_AFIP                      As Integer = 11

' Seudo - Variables
Private c_ErrorSave                   As String
' estructuras
' variables privadas
Private m_Id                           As Long
Private m_Nombre                       As String
Private m_Codigo                       As String
Private m_Descrip                      As String
Private m_Ultimonro                    As Long
Private m_Tipo                         As Integer
Private m_Mascara                      As String
Private m_tipoAFIP                     As Long
Private m_ptoVta                       As Long
Private m_Creado                       As Date
Private m_Modificado                   As Date
Private m_Modifico                     As Long
Private m_Activo                       As Boolean
Private m_Cai                          As String
Private m_emp_id                       As Long
Private m_Empresa                      As String

'OJO HASTA ACA

Private m_Editing           As Boolean

Private m_ObjAbm            As cIABMGeneric
Private m_ObjTree           As Object

Private m_IsNew             As Boolean

Private m_BranchId          As Long
Private m_TreeId            As Long
Private m_Copy              As Boolean

Private m_Host As CSMenu.cIMenuHost

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
  Codigo = m_Codigo
End Property

Public Property Let Codigo(ByVal rhs As String)
  m_Codigo = rhs
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

Private Function cIABMClient_ShowDocDigital() As Boolean
  On Error GoTo ControlError
  
  If m_Id = csNO_ID Then Exit Function
  
  Dim Doc As cDocDigital
  Set Doc = New cDocDigital

  Doc.ClientTable = csTTalonario
  Doc.ClientTableID = m_Id

  cIABMClient_ShowDocDigital = Doc.ShowDocs(gDB)

  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClient_ShowDocDigital", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIABMClient_EditNew() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True
  
  cIEditGeneric_Edit csNO_ID
End Function

Private Function cIABMClient_MessageEx(ByVal MessageID As Long, ByVal Info As Variant) As Variant
  cIABMClient_MessageEx = True
End Function

Private Sub cIABMClient_DiscardChanges()
    LoadCollection
End Sub

Private Function cIABMClient_Copy() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True
  
  With m_ObjAbm.Properties(cscTaCodigo)
    .Value = "C-" & .Value
  End With
    
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscTaCodigo)
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscTaNombre)
  
  m_Copy = True
End Function

Private Function cIABMClient_ListAdHock(List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClient_Load()

End Sub

Private Function cIABMClient_PropertyChange(ByVal Key As Integer) As Boolean

End Function

Private Function cIABMClient_Save() As Boolean
  Dim register As cRegister
  Dim fields   As cFields
  
  Set register = New cRegister
  
  With register
    Set fields = .fields
    .fieldId = cscTaId
    .Table = csTTalonario
    
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
          fields.Add2 cscTaNombre, .Value, csText
        Case K_CODIGO
          fields.Add2 cscTaCodigo, .Value, csText
        Case K_DESCRIP
          fields.Add2 cscTaDescrip, .Value, csText
        Case K_ULTIMONRO
          fields.Add2 cscTaUltimoNro, .Value, csLong
        Case K_TIPO
          fields.Add2 cscTaTipo, .ListItemData, csInteger
        Case K_MASCARA
          fields.Add2 cscTaMascara, .Value, csText
        Case K_ACTIVO
          fields.Add2 cscActivo, .Value, csBoolean
        Case K_CAI
          fields.Add2 cscTaCai, .Value, csText
        Case K_EMP_ID
          fields.Add2 cscEmpId, .HelpId, csId
        Case K_PTO_VTA
          fields.Add2 cscTaPtoVta, .Value, csInteger
        Case K_TIPO_AFIP
          fields.Add2 cscTaTipoAFIP, .Value, csInteger
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
    cIABMClient_Title = LNGGetText(2624, vbNullString) 'Talonarios
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
        Case K_TIPO
          If ValEmpty(.ListItemData, csInteger) Then
            MsgInfo LNGGetText(1222, vbNullString) 'Debe indicar un tipo
            Exit Function
          End If
      End Select
    End With
  Next

  cIABMClient_Validate = True
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
    cIEditGeneric_ShowList = SecurityCanAccess(csPreDListTalonario)
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
    If Not SecurityCanAccess(csPreDDeleteTalonario) Then Exit Function

    Dim sqlstmt As String
    
    sqlstmt = "Delete DocumentoImpresora where ta_id = " & Id & _
              " Delete Talonario where ta_id  = " & Id
    
    cIEditGeneric_Delete = gDB.Execute(sqlstmt, "cIEditGeneric_Delete", C_Module)
End Function

Private Function cIEditGeneric_Search(Id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Id = csNO_ID Then
    m_IsNew = True
    If Not SecurityCanAccess(csPreDNewTalonario) Then Exit Function
  Else
    m_IsNew = False
    If Not SecurityCanAccess(csPreDEditTalonario) Then Exit Function
  End If

' JMA I
  m_ObjAbm.InModalWindow = InModalWindow
' JMA F

  If Not Load(Id) Then Exit Function
  
  If Not LoadCollection() Then Exit Function
  
  m_Editing = True
  m_Copy = False
  
' JMA I
  If InModalWindow Then
    cIEditGeneric_Edit = m_Id <> csNO_ID
  Else
    cIEditGeneric_Edit = True
  End If
' JMA I

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


Private Function cIMenuClient_Initialize(F As Object, Host As CSMenu.cIMenuHost) As Boolean
  On Error GoTo ControlError
  Dim str_2569 As String
  
  str_2569 = LNGGetText(2569, vbNullString) '&Documentos
  Set m_Host = Host
                                                          'Co&nfiguración
  m_Host.Server.AddMenu str_2569, csMenuConfigDocumentos, LNGGetText(1028, vbNullString), 0, True, False, True, False, True, Nothing
  m_Host.Server.AddMenu LNGGetText(2625, vbNullString), csPreDListTalonario, str_2569, 0, True, False, False, False, False, Me
                        '&Talonarios
  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, "cIMenuClient_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal Id As Long) As Variant
  m_Host.MenuABMClick "CSDocumentoEdit.cTalonario", Me, LNGGetText(2624, vbNullString), 0, csETablasDocumento.csTalonario
                                                        'Talonarios
End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  
  Dim abmgen As cABMGeneric
  Set abmgen = m_ObjAbm
  abmgen.MinHeight = 6000
  
  With m_ObjAbm.Properties
    
    .Clear

    With .Add(Nothing, cscTaNombre)
      .PropertyType = cspText
      .Name = C_strNombre
      .Size = 100
      .Key = K_NOMBRE
      .Value = Nombre
    End With
    
    With .Add(Nothing, cscTaCodigo)
      .PropertyType = cspText
      .Name = C_strCodigo
      .Size = 15
      .Key = K_CODIGO
      .Value = Codigo
    End With
    
    With .Add(Nothing, cscTaTipo)
      .PropertyType = cspList
    
      With .List.Add(Nothing)
        .Id = csETTImpresionFiscal
        .Value = LNGGetText(2626, vbNullString) 'Impresión Fiscal
      End With
      With .List.Add(Nothing)
        .Id = csETTPropuesto
        .Value = LNGGetText(2627, vbNullString) 'Propuesto
      End With
      With .List.Add(Nothing)
        .Id = csETTAutoImpresor
        .Value = LNGGetText(2628, vbNullString) 'Auto Impresor
      End With
    
      .ListWhoSetItem = csListItemData
      .Name = LNGGetText(1223, vbNullString) 'Tipo"
      .Key = K_TIPO
      .ListItemData = m_Tipo
    End With
    
    With .Add(Nothing, cscTaUltimoNro)
      .PropertyType = cspNumeric
      .Name = LNGGetText(2629, vbNullString) 'Ultimo número usado
      .SubType = cspInteger
      .Width = 1200
      .Key = K_ULTIMONRO
      .Value = m_Ultimonro
    End With
    
    With .Add(Nothing, cscActivo)
      .PropertyType = cspCheck
      .Name = C_strActivo
      .TopFromProperty = cscTaNombre
      .Left = 5500
      .Key = K_ACTIVO
      .Value = CInt(m_Activo)
    End With
    
    With .Add(Nothing, cscTaMascara)
      .PropertyType = cspText
      .Name = LNGGetText(2630, vbNullString) 'Mascara
      .Size = 20
      .Key = K_MASCARA
      .Value = m_Mascara
    End With
    
    With .Add(Nothing, cscTaCai)
      .PropertyType = cspText
      .Name = LNGGetText(1636, vbNullString) 'CAI
      .Size = 20
      .Key = K_CAI
      .Value = m_Cai
    End With
    
    With .Add(Nothing, cscEmpId)
      .PropertyType = cspHelp
      .Table = csEmpresa
      .Name = LNGGetText(1114, vbNullString) 'Empresa
      .Size = 20
      .Key = K_EMP_ID
      .Value = m_Empresa
      .HelpId = m_emp_id
    End With
    
    With .Add(Nothing, cscTaPtoVta)
      .PropertyType = cspNumeric
      .SubType = cspInteger
      .Name = LNGGetText(5128, vbNullString) 'Punto de Venta
      .Size = 20
      .Key = K_PTO_VTA
      .Value = m_ptoVta
    End With
    
    With .Add(Nothing, cscTaTipoAFIP)
      .PropertyType = cspNumeric
      .SubType = cspInteger
      .Name = LNGGetText(5129, vbNullString) 'Tipo AFIP
      .Size = 20
      .Key = K_TIPO_AFIP
      .Value = m_tipoAFIP
    End With
    
    With .Add(Nothing, cscTaDescrip)
      .PropertyType = cspText
      .Name = C_strDescrip
      .Size = 255
      .Key = K_DESCRIP
      .Value = m_Descrip
      .LeftFromProperty = cscTaNombre
      .TopFromProperty = cscTaTipoAFIP
      .TopToPrevious = 440
      .Width = 6200
      .Height = 880
    End With
    
  End With
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

Private Function Load(ByVal Id As Long) As Boolean

  Dim sqlstmt As String

  sqlstmt = "sp_talonarioGet " & Id

  Dim rs As Recordset

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.fields, cscTaId)
    m_Nombre = gDB.ValField(rs.fields, cscTaNombre)
    m_Codigo = gDB.ValField(rs.fields, cscTaCodigo)
    m_Descrip = gDB.ValField(rs.fields, cscTaDescrip)
    m_Ultimonro = gDB.ValField(rs.fields, cscTaUltimoNro)
    m_Tipo = gDB.ValField(rs.fields, cscTaTipo)
    m_Mascara = gDB.ValField(rs.fields, cscTaMascara)
    m_Cai = gDB.ValField(rs.fields, cscTaCai)
    m_Creado = gDB.ValField(rs.fields, cscCreado)
    m_Modificado = gDB.ValField(rs.fields, cscModificado)
    m_Modifico = gDB.ValField(rs.fields, cscModifico)
    m_Activo = gDB.ValField(rs.fields, cscActivo)
    m_emp_id = gDB.ValField(rs.fields, cscEmpId)
    m_Empresa = gDB.ValField(rs.fields, cscEmpNombre)
    m_tipoAFIP = gDB.ValField(rs.fields, cscTaTipoAFIP)
    m_ptoVta = gDB.ValField(rs.fields, cscTaPtoVta)

  Else
    m_Id = csNO_ID
    m_Nombre = vbNullString
    m_Codigo = vbNullString
    m_Descrip = vbNullString
    m_Ultimonro = 0
    m_Tipo = 0
    m_Mascara = vbNullString
    m_Cai = vbNullString
    m_Creado = csNoDate
    m_Modificado = csNoDate
    m_Modifico = 0
    m_emp_id = csNO_ID
    m_Empresa = vbNullString
    m_Activo = True
    m_tipoAFIP = 0
    m_ptoVta = 0

  End If

  Load = True
End Function
' construccion - destruccion

Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  c_ErrorSave = LNGGetText(2631, vbNullString)  'Error al grabar Talonario
  
  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
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
'  If Err.Number Then Resume ExitProc
'ExitProc:
'  On Error Resume Next


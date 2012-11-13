VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cColmena"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGeneric
Implements CSInterfacesABM.cIABMClient
Implements CSMenu.cIMenuClient
'--------------------------------------------------------------------------------
' cColmena
'09-09-03

'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cColmena"

Private Const K_CODIGO                         As Integer = 1
Private Const K_DESCRIP                        As Integer = 2
Private Const K_POBLACION                      As Integer = 4
Private Const K_ALIMENTO                       As Integer = 5
Private Const K_CRIAHUEVO                      As Integer = 6
Private Const K_CRIAABIERTA                    As Integer = 7
Private Const K_CRIAOPERCULADA                 As Integer = 8
Private Const K_ZANGANERA                      As Integer = 9
Private Const K_FECHAALTA                      As Integer = 10
Private Const K_TIPO                           As Integer = 11
Private Const K_ACTIVO                         As Integer = 12
' estructuras
' Seudo - Variables
Private c_ErrorSave                    As String

' variables privadas
Private m_Id                           As Long
Private m_Codigo                       As String
Private m_Descrip                      As String
Private m_Poblacion                    As Integer
Private m_Alimento                     As Integer
Private m_CriaHuevo                    As Integer
Private m_CriaAbierta                  As Integer
Private m_CriaOperculada               As Integer
Private m_Zanganera                    As Integer
Private m_FechaAlta                    As Date
Private m_Tipo                         As Integer
Private m_Creado                       As Date
Private m_Modificado                   As Date
Private m_Modifico                     As Long
Private m_Activo                       As Boolean

'OJO HASTA ACA

Private m_Editing           As Boolean

Private m_ObjAbm            As cIABMGeneric
Private m_ObjTree           As Object

Private m_IsNew             As Boolean

Private m_BranchId          As Long
Private m_TreeId            As Long
Private m_Host As CSMenu.cIMenuHost

Private m_Copy              As Boolean
' Properties publicas
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
  
  With m_ObjAbm.Properties(cscColmCodigo)
    .Value = "C-" & .Value
  End With
  
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscColmCodigo)
  
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

  Doc.ClientTable = csTColmena
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
  Dim register    As cRegister
  Dim fields      As cFields
  
  Set register = New cRegister
  Set fields = register.fields
  
  With register
    .fieldId = cscColmId
    .Table = csTColmena
    
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
        Case K_CODIGO
          fields.Add2 cscColmCodigo, .Value, csText
        Case K_DESCRIP
          fields.Add2 cscColmDescrip, .Value, csText
        Case K_FECHAALTA
          fields.Add2 cscColmFechaAlta, .Value, csDate
        Case K_ACTIVO
          fields.Add2 cscActivo, .Value, csBoolean
      End Select
    End With
  Next
  
  fields.HaveLastUpdate = True
  fields.HaveWhoModify = True
  
  If Not gDB.Save(register, , "cIABMClient_Save", "cColmena", c_ErrorSave) Then Exit Function
  
  m_Copy = False
  cIABMClient_Save = Load(register.ID)
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
    cIABMClient_Title = LNGGetText(3017, vbNullString)  'Colmenas
End Property

Private Function cIABMClient_Validate() As Boolean

  Dim IProperty As cIABMProperty

  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_CODIGO
          If ValEmpty(.Value, csText) Then
            MsgInfo LNGGetText(1008, vbNullString)  'Debe indicar un código
            Exit Function
          End If
        Case K_FECHAALTA
          If ValEmpty(.Value, csDate) Then
            MsgInfo LNGGetText(3018, vbNullString)  'Debe indicar una fecha de alta
            Exit Function
          End If
      End Select
    End With
  Next

  cIABMClient_Validate = True
End Function


Private Function cIEditGeneric_Edit(ID As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If ID = csNO_ID Then
    m_IsNew = True
    If Not SecurityCanAccess(csPreANewColmena) Then Exit Function
  Else
    m_IsNew = False
    If Not SecurityCanAccess(csPreAEditColmena) Then Exit Function
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
  MngError Err, "cIEditGeneric_Edit", "cColmena", vbNullString
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
    cIEditGeneric_ShowList = SecurityCanAccess(csPreAListColmena)
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

Private Function cIEditGeneric_Delete(ID As Long) As Boolean
    If Not SecurityCanAccess(csPreADeleteColmena) Then Exit Function

    Dim sqlstmt As String
    
    sqlstmt = "Delete Colmena where colm_id = " & ID
    
    cIEditGeneric_Delete = gDB.Execute(sqlstmt, "cIEditGeneric_Delete", "cColmena")
End Function

Private Function cIEditGeneric_Search(ID As Long, Cancela As Boolean) As Boolean

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
Private Function cIMenuClient_Initialize(F As Object, Host As CSMenu.cIMenuHost) As Boolean
  On Error GoTo ControlError
  Dim str_3003  As String
  
  str_3003 = LNGGetText(3003, vbNullString) '&Apicultura
  Set m_Host = Host
                                                'Co&nfiguración
  m_Host.Server.AddMenu str_3003, csMenuConfig, LNGGetText(1028, vbNullString), 0, True, False, True, False, True, Nothing
  m_Host.Server.AddMenu LNGGetText(3019, vbNullString), csPreAListColmena, str_3003, 0, True, False, False, False, False, Me
                        '&Colmenas
  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, "cIMenuClient_Initialize", C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal ID As Long) As Variant
  m_Host.MenuABMClick "CSApicultura2.cColmena", Me, LNGGetText(3017, vbNullString), 0, csETablesApicultura.csColmena
                                                    'Colmenas
End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  
  With m_ObjAbm.Properties
  
    .Clear
    
    With .Add(Nothing, cscColmCodigo)
      .PropertyType = cspText
      .Name = C_strCodigo
      .Size = 10
      .Key = K_CODIGO
      .Value = m_Codigo
    End With
      
    With .Add(Nothing, cscColmFechaAlta)
      .PropertyType = cspDate
      .Name = LNGGetText(3020, vbNullString) 'Fecha de Alta
      .Key = K_FECHAALTA
      .Value = m_FechaAlta
    End With
      
    With .Add(Nothing, cscActivo)
      .PropertyType = cspCheck
      .Name = C_strActivo
      .Key = K_ACTIVO
      .Value = CInt(m_Activo)
    End With
      
    With .Add(Nothing, cscColmZanganera)
      .Enabled = False
      .PropertyType = cspCheck
      .Name = LNGGetText(3021, vbNullString) 'Es Zanganera
      .Key = K_ZANGANERA
      .Value = m_Zanganera
    End With
      
    With .Add(Nothing, cscColmTipo)
      .PropertyType = cspText
      .Enabled = False
      .Name = LNGGetText(1223, vbNullString) 'Tipo
      .Key = K_TIPO
      .ListItemData = m_Tipo
      .ListWhoSetItem = csListItemData
    End With
      
    With .Add(Nothing, cscColmPoblacion)
      .PropertyType = cspNumeric
      .Name = LNGGetText(3022, vbNullString) 'Población
      .LeftLabel = -1500
      .Enabled = False
      .Width = 1100
      .SubType = cspInteger
      .Key = K_POBLACION
      .Value = m_Poblacion
      .TopFromProperty = cscColmCodigo
      .Left = 6200
    End With
      
    With .Add(Nothing, cscColmAlimento)
      .PropertyType = cspNumeric
      .SubType = cspInteger
      .Enabled = False
      .Width = 1100
      .Name = LNGGetText(3023, vbNullString) 'Alimento
      .Key = K_ALIMENTO
      .Value = m_Alimento
    End With
      
    With .Add(Nothing, cscColmCriaHuevo)
      .PropertyType = cspNumeric
      .SubType = cspInteger
      .Name = LNGGetText(3024, vbNullString) 'Cría Huevo
      .Enabled = False
      .Width = 1100
      .Key = K_CRIAHUEVO
      .Value = m_CriaHuevo
    End With
      
    With .Add(Nothing, cscColmCriaAbierta)
      .PropertyType = cspNumeric
      .SubType = cspInteger
      .Name = LNGGetText(3025, vbNullString) 'Cría Abierta
      .Enabled = False
      .Width = 1100
      .Key = K_CRIAABIERTA
      .Value = m_CriaAbierta
    End With
      
    With .Add(Nothing, cscColmCriaOperculada)
      .PropertyType = cspNumeric
      .Name = LNGGetText(3026, vbNullString) 'Cría Operculada
      .Enabled = False
      .Width = 1100
      .SubType = cspInteger
      .Key = K_CRIAOPERCULADA
      .Value = m_CriaOperculada
    End With
      
    With .Add(Nothing, cscColmDescrip)
      .PropertyType = cspText
      .SubType = cspMemo
      .Name = C_strDescrip
      .LeftFromProperty = cscColmCodigo
      .Size = 255
      .Key = K_DESCRIP
      .Value = m_Descrip
      .Width = 6800
      .Height = 780
    End With
  
  End With
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

Private Function Load(ByVal ID As Long) As Boolean

  Dim sqlstmt As String
  Dim rs      As Recordset

  sqlstmt = " select colmena.* from colmena where colm_id = " & ID

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "Load", "cColmena") Then Exit Function

  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.fields, cscColmId)
    m_Codigo = gDB.ValField(rs.fields, cscColmCodigo)
    m_Descrip = gDB.ValField(rs.fields, cscColmDescrip)
    m_Poblacion = gDB.ValField(rs.fields, cscColmPoblacion)
    m_Alimento = gDB.ValField(rs.fields, cscColmAlimento)
    m_CriaHuevo = gDB.ValField(rs.fields, cscColmCriaHuevo)
    m_CriaAbierta = gDB.ValField(rs.fields, cscColmCriaAbierta)
    m_CriaOperculada = gDB.ValField(rs.fields, cscColmCriaOperculada)
    m_Zanganera = gDB.ValField(rs.fields, cscColmZanganera)
    m_FechaAlta = gDB.ValField(rs.fields, cscColmFechaAlta)
    m_Tipo = gDB.ValField(rs.fields, cscColmTipo)
    m_Creado = gDB.ValField(rs.fields, cscCreado)
    m_Modificado = gDB.ValField(rs.fields, cscModificado)
    m_Modifico = gDB.ValField(rs.fields, cscModifico)
    m_Activo = gDB.ValField(rs.fields, cscActivo)

  Else
    m_Id = csNO_ID
    m_Codigo = vbNullString
    m_Descrip = vbNullString
    m_Poblacion = 0
    m_Alimento = 0
    m_CriaHuevo = 0
    m_CriaAbierta = 0
    m_CriaOperculada = 0
    m_Zanganera = 0
    m_FechaAlta = csNoDate
    m_Tipo = 0
    m_Creado = csNoDate
    m_Modificado = csNoDate
    m_Modifico = 0
    m_Activo = False

  End If

  Load = True
End Function ' construccion - destruccion

Private Sub Class_Initialize()
  On Error GoTo ControlError

  c_ErrorSave = LNGGetText(3027, vbNullString) 'Error al grabar Colmena

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



VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cPuerto"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGeneric
Implements CSInterfacesABM.cIABMClient
Implements CSMenu.cIMenuClient
'--------------------------------------------------------------------------------
' cPuerto
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
Private Const C_Module = "cPuerto"

Private Const K_NOMBRE                         As Integer = 1
Private Const K_CODIGO                         As Integer = 2
Private Const K_DESCRIP                        As Integer = 3
Private Const K_CIU_ID                         As Integer = 6
Private Const K_ACTIVO                         As Integer = 7

' estructuras
' Seudo - Variables
Private c_ErrorSave                    As String

' variables privadas
Private m_Id                           As Long
Private m_Nombre                       As String
Private m_Codigo                       As String
Private m_Descrip                      As String
Private m_Ciu_id                       As Long
Private m_Ciudad                       As String
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
Private m_Host              As CSMenu.cIMenuHost
Private m_Copy              As Boolean

' Properties publicas

' JMA I
Public Property Get ID() As Long
  ID = m_Id
End Property

Public Property Get Nombre() As String
  Nombre = m_Nombre
End Property

Public Property Get Codigo() As String
  Codigo = m_Codigo
End Property
' JMA F

'Public Property Get ID() As Long
'  ID = m_Id
'End Property
'
'Public Property Let ID(ByVal rhs As Long)
'  m_Id = rhs
'End Property
'
'Public Property Get Nombre() As String
'  Nombre = m_Nombre
'End Property
'
'Public Property Let Nombre(ByVal rhs As String)
'  m_Nombre = rhs
'End Property
'
'Public Property Get Codigo() As String
'  Codigo = m_Codigo
'End Property
'
'Public Property Let Codigo(ByVal rhs As String)
'  m_Codigo = rhs
'End Property
'
'Public Property Get Descrip() As String
'  Descrip = m_Descrip
'End Property
'
'Public Property Let Descrip(ByVal rhs As String)
'  m_Descrip = rhs
'End Property
'
'Public Property Get Ciu_id() As Long
'  Ciu_id = m_Ciu_id
'End Property
'
'Public Property Let Ciu_id(ByVal rhs As Long)
'  m_Ciu_id = rhs
'End Property
'
'Public Property Get Ciudad() As String
'  Ciudad = m_Ciudad
'End Property
'
'Public Property Let Ciudad(ByVal rhs As String)
'  m_Ciudad = rhs
'End Property
'
'Public Property Get Creado() As Date
'  Creado = m_Creado
'End Property
'
'Public Property Let Creado(ByVal rhs As Date)
'  m_Creado = rhs
'End Property
'
'Public Property Get Modificado() As Date
'  Modificado = m_Modificado
'End Property
'
'Public Property Let Modificado(ByVal rhs As Date)
'  m_Modificado = rhs
'End Property
'
'Public Property Get Modifico() As Long
'  Modifico = m_Modifico
'End Property
'
'Public Property Let Modifico(ByVal rhs As Long)
'  m_Modifico = rhs
'End Property
'
'Public Property Get Activo() As Boolean
'  Activo = m_Activo
'End Property
'
'Public Property Let Activo(ByVal rhs As Boolean)
'  m_Activo = rhs
'End Property
' Properties privadas
' funciones publicas


' Implementacion de cIABMClient
Private Function cIABMClient_Copy() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True
  
  With m_ObjAbm.Properties(cscPueCodigo)
    .Value = "C-" & .Value
  End With
  
  With m_ObjAbm.Properties(cscPueNombre)
    .Value = "Copia de " & .Value
  End With
  
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscPueCodigo)
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscPueNombre)
  
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

  Doc.ClientTable = csTPuerto
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

Private Function cIABMClient_PropertyChange(ByVal Clave As Integer) As Boolean

End Function

Private Function cIABMClient_Save() As Boolean
  Dim register   As cRegister
  Dim fields     As cFields
  
  Set register = New cRegister
  Set fields = register.fields
  
  With register
    .fieldId = cscPueId
    .Table = csTPuerto
  
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
          fields.Add2 cscPueNombre, .Value, csText
        Case K_CODIGO
          fields.Add2 cscPueCodigo, .Value, csText
        Case K_DESCRIP
          fields.Add2 cscPueDescrip, .Value, csText
        Case K_CIU_ID
          fields.Add2 cscCiuId, .HelpId, csId
        Case K_ACTIVO
          fields.Add2 cscActivo, .Value, csBoolean

      End Select
    End With
  Next
  fields.HaveLastUpdate = True
  fields.HaveWhoModify = True
  If Not gDB.Save(register, , "cIABMClient_Save", C_Module, c_ErrorSave) Then Exit Function
  
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
    cIABMClient_Title = LNGGetText(3245, vbNullString) 'Puertos
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
        Case K_CIU_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(3246, vbNullString) 'Debe indicar una Ciudad
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
    cIEditGeneric_ShowList = SecurityCanAccess(csPreEmpqListPuerto)
End Function

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
    Set m_ObjAbm = rhs
End Property

Private Property Get cIEditGeneric_Editing() As Boolean
    cIEditGeneric_Editing = m_Editing
End Property

Private Function cIEditGeneric_Delete(ID As Long) As Boolean
    If Not SecurityCanAccess(csPreEmpqDeletePuerto) Then Exit Function

    Dim sqlstmt As String
    
    sqlstmt = "Delete puerto where pue_Id = " & ID
    
    cIEditGeneric_Delete = gDB.Execute(sqlstmt, "cIEditGeneric_Delete", C_Module)
End Function

Private Function cIEditGeneric_Search(ID As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(ID As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If ID = csNO_ID Then
    m_IsNew = True
    If Not SecurityCanAccess(csPreEmpqNewPuerto) Then Exit Function
  Else
    m_IsNew = False
    If Not SecurityCanAccess(csPreEmpqEditPuerto) Then Exit Function
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
  MngError Err, "cIEditGeneric_Edit", C_Module, vbNullString
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

  Dim str_3236 As String
  str_3236 = LNGGetText(3236, vbNullString)   '&Empaque

  Set m_Host = Host
                                                'Co&nfiguración
  m_Host.Server.AddMenu str_3236, csMenuConfig, LNGGetText(1028, vbNullString), 0, True, False, True, False, True, Nothing
  m_Host.Server.AddMenu LNGGetText(3247, vbNullString), csPreEmpqListPuerto, str_3236, 0, True, False, False, False, False, Me
                        '&Puerto
  cIMenuClient_Initialize = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIMenuClient_Initialize", C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal ID As Long) As Variant
  m_Host.MenuABMClick "CSEmpaque2.cPuerto", Me, LNGGetText(3245, vbNullString), 0, csETablesEmpaque.csPuerto
                                                'Puertos
End Function

' funciones privadas
Private Function LoadCollection() As Boolean

  With m_ObjAbm.Properties
  
    .Clear
  
    With .Add(Nothing, cscPueNombre)
      .PropertyType = cspText
      .Name = C_strNombre
      .Size = 50
      .Width = 5000
      .Key = K_NOMBRE
      .Value = m_Nombre
    End With
      
    With .Add(Nothing, cscPueCodigo)
      .PropertyType = cspText
      .Name = C_strCodigo
      .Size = 10
      .Key = K_CODIGO
      .Value = m_Codigo
    End With
      
    With .Add(Nothing, cscActivo)
      .PropertyType = cspCheck
      .Name = C_strActivo
      .Key = K_ACTIVO
      .Value = CInt(m_Activo)
    End With
      
    With .Add(Nothing, cscCiuId)
      .PropertyType = cspHelp
      .Table = csCiudad
      .Name = LNGGetText(1079, vbNullString) 'Ciudad
      .Key = K_CIU_ID
      .Value = m_Ciudad
      .HelpId = m_Ciu_id
    End With
      
    With .Add(Nothing, cscPueDescrip)
      .PropertyType = cspText
      .Name = C_strDescrip
      .Size = 255
      .SubType = cspMemo
      .Width = 5000
      .Height = 880
      .Key = K_DESCRIP
      .Value = m_Descrip
    End With
      
  End With
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

Private Function Load(ByVal ID As Long) As Boolean

  Dim sqlstmt As String

  sqlstmt = "select ciu_nombre,puerto.* " & _
            "From puerto, Ciudad" & _
              "Where puerto.Ciu_id = Ciudad.Ciu_id" & _
                "and pue_id = " & ID

  Dim rs As Recordset

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "Load", C_Module) Then Exit Function

  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.fields, cscPueId)
    m_Nombre = gDB.ValField(rs.fields, cscPueNombre)
    m_Codigo = gDB.ValField(rs.fields, cscPueCodigo)
    m_Descrip = gDB.ValField(rs.fields, cscPueDescrip)
    m_Ciu_id = gDB.ValField(rs.fields, cscCiuId)
    m_Ciudad = gDB.ValField(rs.fields, cscCiuNombre)
    m_Creado = gDB.ValField(rs.fields, cscCreado)
    m_Modificado = gDB.ValField(rs.fields, cscModificado)
    m_Modifico = gDB.ValField(rs.fields, cscModifico)
    m_Activo = gDB.ValField(rs.fields, cscActivo)

  Else
    m_Id = csNO_ID
    m_Nombre = vbNullString
    m_Codigo = vbNullString
    m_Descrip = vbNullString
    m_Ciu_id = csNO_ID
    m_Ciudad = vbNullString
    m_Creado = csNoDate
    m_Modificado = csNoDate
    m_Modifico = 0
    m_Activo = True

  End If

  Load = True
End Function
' construccion - destruccion

Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  c_ErrorSave = LNGGetText(3248, vbNullString) 'Error al grabar Puerto
  
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

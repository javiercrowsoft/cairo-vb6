VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cAFIPParametro"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGeneric
Implements CSInterfacesABM.cIABMClient
Implements CSInterfacesInfoAFIP.cIAFIPParametro
'--------------------------------------------------------------------------------
' cAFIPParametro
' 12-07-03

'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cAFIPParametro"

Private Const K_NOMBRE                         As Integer = 1
Private Const K_DESCRIP                        As Integer = 2
Private Const K_TIPO                           As Integer = 3
Private Const K_SUBTIPO                        As Integer = 4
Private Const K_TABLAHELP                      As Integer = 5
Private Const K_VALOR                          As Integer = 6
Private Const K_AVANZADO                       As Integer = 7
Private Const K_AFESQ_ID                       As Integer = 9
Private Const K_ACTIVO                         As Integer = 12
' estructuras
' Suedo - Variables
Private c_ErrorSave           As String

' variables privadas
Private m_Id                           As Long
Private m_Nombre                       As String
Private m_Descrip                      As String
Private m_Tipo                         As csTypeABMProperty
Private m_SubTipo                      As csSubTypeABMProperty
Private m_TablaHelp                    As Long
Private m_Valor                        As String
Private m_HelpId                       As String
Private m_HelpValueProcess             As String
Private m_Avanzado                     As Boolean
Private m_Afesq_id                     As Long
Private m_Esquema                      As String
Private m_Creado                       As Date
Private m_Modificado                   As Date
Private m_Modifico                     As Long
Private m_Activo                       As Boolean

'OJO HASTA ACA
Private m_Title2            As String
Private m_Editing           As Boolean

Private m_ObjAbm            As cIABMGeneric
Private m_ObjTree           As Object

Private m_IsNew             As Boolean

Private m_BranchId          As Long
Private m_TreeId            As Long

Private m_Copy              As Boolean
' propiedades publicas
Public Property Let Title2(ByVal RHS As String)
  m_Title2 = RHS
End Property

Public Property Get ID() As Long
  ID = m_Id
End Property

Public Property Get HelpID() As String
  HelpID = m_HelpId
End Property

Public Property Get HelpValueProcess() As String
  HelpValueProcess = m_HelpValueProcess
End Property

Public Property Let HelpID(ByVal RHS As String)
  m_HelpId = RHS
End Property

Public Property Let HelpValueProcess(ByVal RHS As String)
  m_HelpValueProcess = RHS
End Property

Public Property Get Nombre() As String
  Nombre = m_Nombre
End Property

Public Property Get Tipo() As csTypeABMProperty
  Tipo = m_Tipo
End Property

Public Property Get SubTipo() As csSubTypeABMProperty
  SubTipo = m_SubTipo
End Property

Public Property Get TablaHelp() As Long
  TablaHelp = m_TablaHelp
End Property

Public Property Get Valor() As String
  Valor = m_Valor
End Property

Public Property Let Valor(ByVal RHS As String)
  m_Valor = RHS
End Property

Public Property Get Avanzado() As Boolean
  Avanzado = m_Avanzado
End Property

Public Property Let Afesq_id(ByVal RHS As Long)
  m_Afesq_id = RHS
End Property
' Interfaz
Private Property Let cIAFIPParametro_Title2(ByVal RHS As String)
  m_Title2 = RHS
End Property

Private Property Get cIAFIPParametro_ID() As Long
  cIAFIPParametro_ID = m_HelpId
End Property

Private Property Let cIAFIPParametro_ID(ByVal RHS As Long)
  m_HelpId = RHS
End Property

Private Property Get cIAFIPParametro_Nombre() As String
  cIAFIPParametro_Nombre = m_Nombre
End Property

Private Property Let cIAFIPParametro_Nombre(ByVal RHS As String)
  m_Nombre = RHS
End Property

Private Property Get cIAFIPParametro_Descrip() As String
  If LenB(m_HelpValueProcess) Then
    cIAFIPParametro_Descrip = m_HelpValueProcess
  Else
    cIAFIPParametro_Descrip = m_Descrip
  End If
End Property

Private Property Let cIAFIPParametro_Descrip(ByVal RHS As String)
  m_Descrip = RHS
End Property

Private Property Get cIAFIPParametro_Tipo() As csTypeABMProperty
  cIAFIPParametro_Tipo = m_Tipo
End Property

Private Property Let cIAFIPParametro_Tipo(ByVal RHS As csTypeABMProperty)
  m_Tipo = RHS
End Property

Private Property Get cIAFIPParametro_SubTipo() As csSubTypeABMProperty
  cIAFIPParametro_SubTipo = m_SubTipo
End Property

Private Property Let cIAFIPParametro_SubTipo(ByVal RHS As csSubTypeABMProperty)
  m_SubTipo = RHS
End Property

Private Property Get cIAFIPParametro_TablaHelp() As Long
  cIAFIPParametro_TablaHelp = m_TablaHelp
End Property

Private Property Let cIAFIPParametro_TablaHelp(ByVal RHS As Long)
  m_TablaHelp = RHS
End Property

Private Property Get cIAFIPParametro_Valor() As String
  cIAFIPParametro_Valor = m_Valor
End Property

Private Property Let cIAFIPParametro_Valor(ByVal RHS As String)
  m_Valor = RHS
End Property

Private Property Get cIAFIPParametro_Avanzado() As Boolean
  cIAFIPParametro_Avanzado = m_Avanzado
End Property

Private Property Let cIAFIPParametro_Avanzado(ByVal RHS As Boolean)
  m_Avanzado = RHS
End Property

Private Property Get cIAFIPParametro_Esquema() As String
  cIAFIPParametro_Esquema = m_Esquema
End Property

Private Property Let cIAFIPParametro_Esquema(ByVal RHS As String)
  m_Esquema = RHS
End Property

Private Property Get cIAFIPParametro_Creado() As Date
  cIAFIPParametro_Creado = m_Creado
End Property

Private Property Let cIAFIPParametro_Creado(ByVal RHS As Date)
  m_Creado = RHS
End Property

Private Property Get cIAFIPParametro_Modificado() As Date
  cIAFIPParametro_Modificado = m_Modificado
End Property

Private Property Let cIAFIPParametro_Modificado(ByVal RHS As Date)
  m_Modificado = RHS
End Property

Private Property Get cIAFIPParametro_Modifico() As Long
  cIAFIPParametro_Modifico = m_Modifico
End Property

Private Property Let cIAFIPParametro_Modifico(ByVal RHS As Long)
  m_Modifico = RHS
End Property

Private Property Get cIAFIPParametro_Activo() As Boolean
  cIAFIPParametro_Activo = m_Activo
End Property

Private Property Let cIAFIPParametro_Activo(ByVal RHS As Boolean)
  m_Activo = RHS
End Property

' propiedades privadas
' funciones publicas
Public Function Load(ByVal ID As Long) As Boolean
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  sqlstmt = "select AFIPParametro.*, afesq_nombre" & _
            " from AFIPParametro, AFIPEsquema" & _
              " where afparam_id = " & ID & _
                " and AFIPParametro.afesq_id *= AFIPEsquema.afesq_id"

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "Load", C_Module) Then Exit Function

  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.Fields, cscAfParamId)
    m_Nombre = gDB.ValField(rs.Fields, cscAfParamNombre)
    m_Descrip = gDB.ValField(rs.Fields, cscAfParamDescrip)
    m_Tipo = gDB.ValField(rs.Fields, cscAfParamTipo)
    m_SubTipo = gDB.ValField(rs.Fields, cscAfParamSubTipo)
    m_TablaHelp = gDB.ValField(rs.Fields, cscAfParamTablaHelp)
    m_Valor = gDB.ValField(rs.Fields, cscAfParamValor)
    m_Avanzado = gDB.ValField(rs.Fields, cscAfParamAvanzado)
    m_Afesq_id = gDB.ValField(rs.Fields, cscAfEsqId)
    m_Esquema = gDB.ValField(rs.Fields, cscAfEsqNombre)
    m_Creado = gDB.ValField(rs.Fields, cscCreado)
    m_Modificado = gDB.ValField(rs.Fields, cscModificado)
    m_Modifico = gDB.ValField(rs.Fields, cscModifico)
    m_Activo = gDB.ValField(rs.Fields, cscActivo)

  Else
    m_Id = csNO_ID
    m_Nombre = vbNullString
    m_Descrip = vbNullString
    m_Tipo = 0
    m_SubTipo = 0
    m_TablaHelp = 0
    m_Valor = vbNullString
    m_Avanzado = False
    m_Afesq_id = csNO_ID
    m_Esquema = vbNullString
    m_Creado = csNoDate
    m_Modificado = csNoDate
    m_Modifico = 0
    m_Activo = False

  End If

  Load = True
End Function


' Implementacion de cIABMClient
Private Function cIABMClient_Copy() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True
  
  m_Copy = True
  m_Id = -1
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

  Doc.ClientTable = csTAFIPParametro
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
  Dim EsqPresent As Boolean
  Dim register As cRegister
  Set register = New cRegister
  register.fieldId = cscAfParamId
  register.Table = csTAFIPParametro
  
  If m_Copy Then
    register.ID = csNew
  Else
    register.ID = m_Id
  End If

  Dim IProperty As cIABMProperty
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_NOMBRE
          register.Fields.Add2 cscAfParamNombre, .Value, csText
        Case K_DESCRIP
          register.Fields.Add2 cscAfParamDescrip, .Value, csText
        Case K_TIPO
          register.Fields.Add2 cscAfParamTipo, .ListItemData, csInteger
        Case K_SUBTIPO
          register.Fields.Add2 cscAfParamSubTipo, .ListItemData, csInteger
        Case K_TABLAHELP
          register.Fields.Add2 cscAfParamTablaHelp, .Value, csLong
        Case K_VALOR
          register.Fields.Add2 cscAfParamValor, .Value, csText
        Case K_AVANZADO
          register.Fields.Add2 cscAfParamAvanzado, .Value, csBoolean
        Case K_AFESQ_ID
          EsqPresent = True
          register.Fields.Add2 cscAfEsqId, .HelpID, csId
        Case K_ACTIVO
          register.Fields.Add2 cscActivo, .Value, csBoolean

      End Select
    End With
  Next
  
  If Not EsqPresent Then
    register.Fields.Add2 cscAfEsqId, m_Afesq_id, csId
  End If
  
  register.Fields.HaveLastUpdate = True
  register.Fields.HaveWhoModify = True
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
  
  If TypeOf m_ObjTree Is cAFIPEsquema Then
    Dim Esq As cAFIPEsquema
    Set Esq = m_ObjTree
    If m_IsNew Then
        Esq.AddParametro m_Id
    Else
        Esq.RefreshParametro m_Id
    End If
  Else
    If m_IsNew Then
        m_ObjTree.AddLeave m_Id, m_BranchId, m_TreeId
    Else
        m_ObjTree.AddEditedId m_Id
        m_ObjTree.RefreshActiveBranch
    End If
  End If
ControlError:
End Function

Private Property Get cIABMClient_Title() As String
    cIABMClient_Title = LNGGetText(3417, vbNullString) 'AFIP Parámetros
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
    cIEditGeneric_ShowList = SecurityCanAccess(csInfoAFIPListAFIPParametro)
End Function

Private Property Get cIEditGeneric_Editing() As Boolean
    cIEditGeneric_Editing = m_Editing
End Property

Private Property Get cIEditGeneric_ObjAbm() As CSInterfacesABM.cIABMGeneric
  Set cIEditGeneric_ObjAbm = m_ObjAbm
End Property

Private Property Set cIEditGeneric_ObjAbm(RHS As CSInterfacesABM.cIABMGeneric)
    Set m_ObjAbm = RHS
End Property

Private Function cIEditGeneric_Delete(ID As Long) As Boolean
    If Not SecurityCanAccess(csInfoAFIPDeleteAFIPParametro) Then Exit Function

    Dim sqlstmt As String
    
    sqlstmt = "Delete AFIPParametro where AfParam_id = " & ID
    
    cIEditGeneric_Delete = gDB.Execute(sqlstmt, "cIEditGeneric_Delete", C_Module)
End Function

Private Function cIEditGeneric_Search(ID As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(ID As Long, Optional ByVal InModalWindow As Boolean) As Boolean
    On Error GoTo ControlError
    
    If ID = csNO_ID Then
        m_IsNew = True
        If Not SecurityCanAccess(csInfoAFIPNewAFIPParametro) Then Exit Function
    Else
        m_IsNew = False
        If Not SecurityCanAccess(csInfoAFIPEditAFIPParametro) Then Exit Function
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

' funciones friend
Friend Function BeginCopy() As Boolean
  m_Copy = True
  BeginCopy = True
End Function

Friend Function EndCopy(ByVal Afesq_id As Long) As Boolean
  m_Afesq_id = Afesq_id
  If Not pSaveCopy() Then Exit Function
  
  m_Copy = False
  EndCopy = True
End Function

' funciones privadas
Private Function pSaveCopy() As Boolean
  Dim EsqPresent As Boolean
  Dim register As cRegister
  Set register = New cRegister
  register.fieldId = cscAfParamId
  register.Table = csTAFIPParametro
  
  register.ID = csNew

  register.Fields.Add2 cscAfParamNombre, m_Nombre, csText
  register.Fields.Add2 cscAfParamDescrip, m_Descrip, csText
  register.Fields.Add2 cscAfParamTipo, m_Tipo, csInteger
  register.Fields.Add2 cscAfParamSubTipo, m_SubTipo, csInteger
  register.Fields.Add2 cscAfParamTablaHelp, m_TablaHelp, csLong
  register.Fields.Add2 cscAfParamValor, m_Valor, csText
  register.Fields.Add2 cscAfParamAvanzado, m_Avanzado, csBoolean
  register.Fields.Add2 cscAfEsqId, m_Afesq_id, csId
  register.Fields.Add2 cscActivo, m_Activo, csBoolean
  
  register.Fields.HaveLastUpdate = True
  register.Fields.HaveWhoModify = True
  
  If Not gDB.Save(register, , "pSaveCopy", C_Module, c_ErrorSave) Then Exit Function
  pSaveCopy = Load(register.ID)
End Function

Private Function LoadCollection() As Boolean
  Dim c As cIABMProperty
  m_ObjAbm.Title2 = m_Title2
      
  With m_ObjAbm.Properties
  
    .Clear
    
    With .Add(Nothing, cscAfParamNombre)
      .PropertyType = cspText
      .Name = C_strNombre
      .Size = 50
      .Key = K_NOMBRE
      .Value = Nombre
    End With
    
    Set c = .Add(Nothing, cscAfParamTipo)
    With c
      .PropertyType = cspList
      FillTipoParametro c
      .Name = LNGGetText(1223, vbNullString) 'Tipo
      .Key = K_TIPO
      .ListItemData = CInt(m_Tipo)
      .ListWhoSetItem = csListItemData
    End With
    
    Set c = .Add(Nothing, cscAfParamSubTipo)
    With c
      .PropertyType = cspList
      FillSubTipoParametro c
      .Name = LNGGetText(3414, vbNullString) 'Sub Tipo
      .Key = K_SUBTIPO
      .ListItemData = CInt(m_SubTipo)
      .ListWhoSetItem = csListItemData
    End With
      
    With .Add(Nothing, cscActivo)
      .PropertyType = cspCheck
      .TopFromProperty = cscAfParamNombre
      .Left = 5500
      .Name = C_strActivo
      .Key = K_ACTIVO
      .Value = CInt(m_Activo)
    End With
    
    With .Add(Nothing, cscAfParamTablaHelp)
      .PropertyType = cspNumeric
      .SubType = cspInteger
      .Width = 800
      .Name = LNGGetText(3418, vbNullString) 'Tabla Help
      .Key = K_TABLAHELP
      .Value = TablaHelp
    End With
    
    With .Add(Nothing, cscAfParamAvanzado)
      .PropertyType = cspCheck
      .Name = LNGGetText(3415, vbNullString) 'Avanzado
      .Key = K_AVANZADO
      .Value = CInt(m_Avanzado)
    End With
      
    With .Add(Nothing, cscAfParamValor)
      .PropertyType = cspText
      .TopFromProperty = cscAfParamSubTipo
      .TopToPrevious = 440
      .SubType = cspMemo
      .LeftFromProperty = cscAfParamSubTipo
      .Name = LNGGetText(2752, vbNullString) 'Valor
      .Size = 5000
      .Height = 880
      .Width = 6300
      .Key = K_VALOR
      .Value = Valor
    End With
    
    With .Add(Nothing, cscAfParamDescrip)
      .PropertyType = cspText
      .SubType = cspMemo
      .TopFromProperty = cscAfParamValor
      .TopToPrevious = 1000
      .LeftFromProperty = cscAfParamNombre
      .Height = 660
      .Width = 6300
      .Name = C_strDescrip
      .Size = 255
      .Key = K_DESCRIP
      .Value = m_Descrip
    End With
    
  End With
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function
' construccion - destruccion

Private Sub Class_Initialize()
  On Error GoTo ControlError

  c_ErrorSave = LNGGetText(3419, vbNullString)  'Error al grabar AFIPParametro

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


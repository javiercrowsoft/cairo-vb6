VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cPregunta"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGeneric
Implements CSInterfacesABM.cIABMClient
Implements CSMenu.cIMenuClient
'--------------------------------------------------------------------------------
' cPregunta
' 18-11-2010

'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cPregunta"

Private Const K_PREGUNTA                       As Integer = 1
Private Const K_RESPUESTA                      As Integer = 2
Private Const K_FECHA_PREGUNTA                 As Integer = 3
Private Const K_FECHA_RESPUESTA                As Integer = 4
Private Const K_RESPONDIO                      As Integer = 5
Private Const K_CLI_ID                         As Integer = 6
Private Const K_DESCRIP                        As Integer = 7
Private Const K_ARTICULO_ID                    As Integer = 8
Private Const K_ARTICULO                       As Integer = 9
Private Const K_CMI_ID                         As Integer = 10

' pseudo-constantes
Private c_ErrorSave As String

' estructuras
' variables privadas
Private m_Id                           As Long
Private m_pregunta                     As String
Private m_respuesta                    As String
Private m_descrip                      As String
Private m_fechaPregunta                As Date
Private m_fechaRespuesta               As Date
Private m_respondio                    As String
Private m_cliente                      As String
Private m_comunidad                    As String
Private m_articulo_id                  As String
Private m_articulo                     As String

'OJO HASTA ACA

Private m_Editing           As Boolean
Private m_Host              As CSMenu.cIMenuHost
Private m_ObjAbm            As cIABMGeneric
Private m_ObjTree           As Object

Private m_BranchId          As Long
Private m_TreeId            As Long
Private m_Copy              As Boolean

Private m_UserCfg           As cUsuarioConfig

' Properties publicas

Public Property Get ID() As Long
  ID = m_Id
End Property

Public Property Get Nombre() As String
  Nombre = m_pregunta
End Property

Public Property Get Codigo() As String
  Codigo = vbNullString
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
  cIABMClient_CanCopy = False
End Property

Private Property Get cIABMClient_CanNew() As Boolean
  cIABMClient_CanNew = False
End Property

Private Function cIABMClient_ShowDocDigital() As Boolean
  On Error GoTo ControlError
  
  If m_Id = csNO_ID Then Exit Function
  
  Dim Doc As cDocDigital
  Set Doc = New cDocDigital

  Doc.ClientTable = csTComunidadInternetPregunta
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
  cIABMClient_EditNew = False
End Function

Private Function cIABMClient_MessageEx(ByVal MessageID As Long, ByVal Info As Variant) As Variant
  cIABMClient_MessageEx = True
End Function

Private Sub cIABMClient_DiscardChanges()
  LoadCollection
End Sub

Private Function cIABMClient_Copy() As Boolean

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
    .fieldId = cscCmipId
    .Table = csTComunidadInternetPregunta
  
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
        Case K_DESCRIP
          fields.Add2 cscCmipDescrip, .Value, csText
      End Select
    End With
  Next
    
  fields.HaveLastUpdate = True
  fields.HaveWhoModify = True
  
  If Not register.BeginTrans(gDB) Then Exit Function
  
  If Not gDB.Save(register, , "cIABMClient_Save", C_Module, c_ErrorSave) Then Exit Function
    
  If Not register.CommitTrans() Then GoTo SaveError
  
  m_Copy = False
  cIABMClient_Save = Load(register.ID)
    
  Exit Function
SaveError:
End Function

Private Function cIABMClient_Terminate() As Boolean
  m_Editing = False
  
  cIABMClient_Terminate = True
  ' Este objeto puede no cumplir con la interfaz esperada, asi que si hay un error no
  ' le doy bola
  On Error GoTo ControlError
  If m_Id = csNO_ID Then Exit Function
  If m_ObjTree Is Nothing Then Exit Function
  
  m_ObjTree.sqlstmt = "sp_lsdoc_Pregunta"
  
  m_ObjTree.RefreshLine m_Id

ControlError:
End Function

Private Property Get cIABMClient_Title() As String
  cIABMClient_Title = LNGGetText(5090, vbNullString)  'Preguntas
End Property

Private Function cIABMClient_Validate() As Boolean
  cIABMClient_Validate = SecurityCanAccess(csPreCVXIEditPregunta)
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
    cIEditGeneric_ShowList = SecurityCanAccess(csPreCVXIListPregunta)
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
  cIEditGeneric_Delete = False
End Function

Private Function cIEditGeneric_Search(ID As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(ID As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If ID = csNO_ID Then
    Exit Function
  Else
    If Not SecurityCanAccess(csPreCVXIListPregunta) Then Exit Function
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

' funciones privadas
Private Function LoadCollection() As Boolean
  
  Dim AbmGen As cABMGeneric
  Set AbmGen = m_ObjAbm
  
  AbmGen.MinHeight = 8600
  
  With m_ObjAbm
    
    With .Properties
      .Clear
  
      With .Add(Nothing, cscUsIdRespondio)
        .PropertyType = cspText
        .Name = LNGGetText(5091, vbNullString)  'Respondio
        .Key = K_RESPONDIO
        .Value = m_respondio
        .Enabled = False
      End With
    
      With .Add(Nothing, cscCliId)
        .PropertyType = cspText
        .Name = LNGGetText(1150, vbNullString)  'Cliente
        .Key = K_CLI_ID
        .Value = m_cliente
        .Enabled = False
        .Width = 6500
      End With
    
      With .Add(Nothing, cscCmipArticuloid)
        .PropertyType = cspText
        .Name = C_strCodigo
        .Key = K_ARTICULO_ID
        .Value = m_articulo_id
        .Enabled = False
        .Width = 1600
      End With
    
      With .Add(Nothing, cscCmipArticulo)
        .PropertyType = cspText
        .Name = LNGGetText(1367, vbNullString)  ' Articulo
        .Key = K_ARTICULO
        .Value = m_articulo
        .Enabled = False
        .TopFromProperty = cscCmipArticuloid
        .Left = 4000
        .Width = 4050
        .LeftLabel = -700
        .LeftNotChange = True
      End With
    
      With .Add(Nothing, cscCmipFecha)
        .PropertyType = cspDate
        .Name = LNGGetText(5092, vbNullString)  ' Fecha Pregunta
        .Key = K_FECHA_PREGUNTA
        .Value = m_fechaPregunta
      End With
      
      With .Add(Nothing, cscCmipPregunta)
        .PropertyType = cspText
        .SubType = cspMemo
        .Name = LNGGetText(5093, vbNullString)  ' Pregunta
        .Key = K_PREGUNTA
        .Value = m_pregunta
        .Width = 8000
        .Height = 600
      End With
          
      With .Add(Nothing, cscCmipFechaRespuesta)
        .PropertyType = cspDate
        .Name = LNGGetText(5094, vbNullString)  ' Fecha Respuesta
        .Key = K_FECHA_RESPUESTA
        .Value = m_fechaRespuesta
      End With
    
      With .Add(Nothing, cscCmipRespuesta)
        .PropertyType = cspText
        .SubType = cspMemo
        .Name = LNGGetText(5095, vbNullString) ' Respuesta
        .Key = K_RESPUESTA
        .Value = m_respuesta
        .Height = 1560
        .Width = 8000
      End With
    
      With .Add(Nothing, cscCmipDescrip)
        .PropertyType = cspText
        .SubType = cspMemo
        .Name = LNGGetText(1861, vbNullString) ' Observaciones
        .Size = 1000
        .Key = K_DESCRIP
        .Value = m_descrip
        .Height = 1560
        .Width = 8000
      End With
    
    End With
  End With
    
  If Not m_ObjAbm.Show(Me) Then Exit Function
    
  LoadCollection = True
End Function

Private Function Load(ByVal ID As Long) As Boolean

  Dim sqlstmt As String

  sqlstmt = "sp_ComunidadInternetPreguntaGet " & ID

  Dim rs As Recordset

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.fields, cscCmipId)
    m_pregunta = gDB.ValField(rs.fields, cscCmipPregunta)
    m_respuesta = gDB.ValField(rs.fields, cscCmipRespuesta)
    m_descrip = gDB.ValField(rs.fields, cscCmipDescrip)
    m_fechaPregunta = gDB.ValField(rs.fields, cscCmipFecha)
    m_fechaRespuesta = gDB.ValField(rs.fields, cscCmipFechaRespuesta)
    m_respondio = gDB.ValField(rs.fields, "respondio")
    m_cliente = gDB.ValField(rs.fields, cscCliNombre)
    m_articulo_id = gDB.ValField(rs.fields, cscCmipArticuloid)
    m_articulo = gDB.ValField(rs.fields, cscCmipArticulo)
    
  Else
    
    m_Id = csNO_ID
    m_pregunta = vbNullString
    m_respuesta = vbNullString
    m_descrip = vbNullString
    m_fechaPregunta = csNoDate
    m_fechaRespuesta = csNoDate
    m_respondio = vbNullString
    m_cliente = vbNullString
    m_articulo_id = vbNullString
    m_articulo = vbNullString
    
  End If

  Load = True
End Function

Private Function cIMenuClient_Initialize(F As Object, Host As CSMenu.cIMenuHost) As Boolean
  On Error GoTo ControlError
  
  Dim str_5025 As String

  str_5025 = LNGGetText(5025, vbNullString)
  
  Set m_Host = Host
  m_Host.Server.AddMenu str_5025, csMenuEnum.csMenuComunidad, vbNullString, 1, False, False, False, True, False, Nothing
  m_Host.Server.AddMenu LNGGetText(5096, vbNullString), csPreCVXIListPregunta, str_5025, 0, True, False, False, False, False, Me
                        '&Preguntas
  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, "cIMenuClient_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal ID As Long) As Variant
  m_Host.MenuListDocClick "CSABMInterface2.CABMGeneric", "CSCVXI.cPregunta", "CSABMInterface2.CABMGenericListDoc", "CSCVXI.cPreguntaListDoc", Me, LNGGetText(5090, vbNullString), 0
                                                                                                                                                              'Preguntas
End Function

' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError

  c_ErrorSave = LNGGetText(5097, vbNullString) 'Error al grabar la pregunta

  ' Preferencias del Usuario
  '
  Set m_UserCfg = New cUsuarioConfig
  m_UserCfg.Load

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
  On Error GoTo ControlError
  
  Set m_ObjAbm = Nothing
  Set m_ObjTree = Nothing

  ' Preferencias del Usuario
  '
  Set m_UserCfg = Nothing

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Terminate", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
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
'  If Err.Number Then Resume ExitProc
'ExitProc:
'  On Error Resume Next

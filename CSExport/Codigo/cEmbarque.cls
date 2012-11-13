VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cEmbarque"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGeneric
Implements CSInterfacesABM.cIABMClient
Implements CSMenu.cIMenuClient
'--------------------------------------------------------------------------------
' cEmbarque
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
Private Const C_Module = "cEmbarque"

Private Const K_NOMBRE                         As Integer = 1
Private Const K_CODIGO                         As Integer = 2
Private Const K_DESCRIP                        As Integer = 3
Private Const K_FECHA                          As Integer = 4
Private Const K_BARC_ID                        As Integer = 5
Private Const K_PUE_ID_ORIGEN                  As Integer = 6
Private Const K_PUE_ID_DESTINO                 As Integer = 7
Private Const K_ACTIVO                         As Integer = 8

' Suedo - Variables
Private c_ErrorSave       As String

' estructuras
' variables privadas
Private m_Id                           As Long
Private m_Nombre                       As String
Private m_Codigo                       As String
Private m_Descrip                      As String
Private m_Fecha                        As Date
Private m_Barc_id                      As Long
Private m_Barco                        As String
Private m_pue_id_origen                As Long
Private m_PuertoOrigen                 As String
Private m_pue_id_destino               As Long
Private m_PuertoDestino                As String
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
Public Property Get ID() As Long
  ID = m_Id
End Property

Public Property Get Codigo() As String
  Codigo = m_Codigo
End Property

Public Property Get Nombre() As String
  Nombre = m_Nombre
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

  Doc.ClientTable = csTEmbarque
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

  With m_ObjAbm.Properties(cscEmbCodigo)
    .Value = C_C & .Value
  End With
  
  With m_ObjAbm.Properties(cscEmbNombre)
    .Value = C_CopiaDe & .Value
  End With
  
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscEmbCodigo)
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscEmbNombre)
  
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
  
  Set register = New cRegister
  register.fieldId = cscEmbId
  register.Table = csTEmbarque
  
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
          register.Fields.Add2 cscEmbNombre, .Value, csText
        Case K_CODIGO
          register.Fields.Add2 cscEmbCodigo, .Value, csText
        Case K_DESCRIP
          register.Fields.Add2 cscEmbDescrip, .Value, csText
        Case K_FECHA
          register.Fields.Add2 cscEmbFecha, .Value, csDate
        Case K_BARC_ID
          register.Fields.Add2 cscBarcId, .HelpId, csId
        Case K_PUE_ID_ORIGEN
          register.Fields.Add2 cscPueIdOrigen, .HelpId, csId
        Case K_PUE_ID_DESTINO
          register.Fields.Add2 cscPueIdDestino, .HelpId, csId
        Case K_ACTIVO
          register.Fields.Add2 cscActivo, .Value, csBoolean
      End Select
    End With
  Next
  
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
  
  m_ObjTree.sqlstmt = "sp_lsdoc_embarque"
  
  If m_IsNew Then
    m_ObjTree.AddLine m_Id
  Else
    m_ObjTree.RefreshLine m_Id
  End If
ControlError:
End Function

Private Property Get cIABMClient_Title() As String
    cIABMClient_Title = LNGGetText(2421, vbNullString)  'Embarques
End Property

Private Function cIABMClient_Validate() As Boolean
  Dim IProperty As cIABMProperty

  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_NOMBRE
          If ValEmpty(.Value, csText) Then
            MsgInfo LNGGetText(1007, vbNullString)  'Debe indicar un nombre
            Exit Function
          End If
        Case K_CODIGO
          If ValEmpty(.Value, csText) Then
            MsgInfo LNGGetText(1008, vbNullString)  'Debe indicar un código
            Exit Function
          End If
        Case K_FECHA
          If ValEmpty(.Value, csDate) Then
            MsgInfo LNGGetText(1558, vbNullString)  'Debe indicar una fecha
            Exit Function
          End If
        Case K_BARC_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(2422, vbNullString)  'Debe indicar un barco
            Exit Function
          End If
        Case K_PUE_ID_ORIGEN
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(2400, vbNullString)  'Debe indicar un puerto origen
            Exit Function
          End If
        Case K_PUE_ID_DESTINO
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(2401, vbNullString)  'Debe indicar un puerto destino
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
    cIEditGeneric_ShowList = SecurityCanAccess(csPreExpListEmbarque)
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
    If Not SecurityCanAccess(csPreExpDeleteEmbarque) Then Exit Function

    Dim sqlstmt As String
    
    sqlstmt = "Delete Embarque where emb_id = " & ID
    
    cIEditGeneric_Delete = gDB.Execute(sqlstmt, "cIEditGeneric_Delete", C_Module)
End Function

Private Function cIEditGeneric_Search(ID As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(ID As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If ID = csNO_ID Then
    m_IsNew = True
    If Not SecurityCanAccess(csPreExpNewEmbarque) Then Exit Function
  Else
    m_IsNew = False
    If Not SecurityCanAccess(csPreExpEditEmbarque) Then Exit Function
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

' Menu Client
Private Function cIMenuClient_Initialize(F As Object, Host As CSMenu.cIMenuHost) As Boolean
  On Error GoTo ControlError
  Dim str_2423 As String
  
  str_2423 = LNGGetText(2423, vbNullString)   '&Embarque
  
  #If Not PREPROC_NO_MENU_ICON Then
  
    Dim lIconIndex As Long
    Set m_Host = Host
    lIconIndex = m_Host.AddIcon(LoadResPicture(101, LoadResConstants.vbResIcon))
    m_Host.Server.AddMenu c_MenuMain, csMenuExportacion, vbNullString, 1, False, False, False, True, False, Nothing
    m_Host.Server.AddMenu str_2423, csPreExpListEmbarque, c_MenuMain, 0, True, False, False, False, False, Me, lIconIndex
  
  #Else
  
    Set m_Host = Host
    m_Host.Server.AddMenu c_MenuMain, csMenuExportacion, vbNullString, 1, False, False, False, True, False, Nothing
    m_Host.Server.AddMenu str_2423, csPreExpListEmbarque, c_MenuMain, 0, True, False, False, False, False, Me
  
  #End If
  
  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, "cIMenuClient_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal ID As Long) As Variant
  m_Host.MenuListDocClick "CSABMInterface2.CABMGeneric", "CSExport2.cEmbarque", "CSABMInterface2.CABMGenericListDoc", "CSExport2.cEmbarqueListDoc", Me, LNGGetText(1873, vbNullString), 0
                                                                                                                                                        'Embarque
End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  Dim c As cIABMProperty
  
  m_ObjAbm.Properties.Clear

  Set c = m_ObjAbm.Properties.Add(Nothing, cscEmbNombre)
  c.PropertyType = cspText
  c.Name = C_strNombre
  c.Size = 255
  c.Width = 4500
  c.Key = K_NOMBRE
  c.Value = m_Nombre
  

  Set c = m_ObjAbm.Properties.Add(Nothing, cscActivo)
  c.PropertyType = cspCheck
  c.LeftNotChange = True
  c.TopFromProperty = cscEmbNombre
  c.Left = 6900
  c.LeftLabel = -600
  c.Name = C_strActivo
  c.Key = K_ACTIVO
  c.Value = CInt(m_Activo)
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscEmbCodigo)
  c.PropertyType = cspText
  c.Name = C_strCodigo
  c.Size = 270
  c.Key = K_CODIGO
  c.Value = m_Codigo
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscEmbFecha)
  c.PropertyType = cspDate
  c.Name = LNGGetText(1569, vbNullString)   'Fecha
  c.Key = K_FECHA
  c.Value = m_Fecha
  

  Set c = m_ObjAbm.Properties.Add(Nothing, cscBarcId)
  c.PropertyType = cspHelp
  c.Table = csBarco
  c.Name = LNGGetText(2424, vbNullString)   'Barco
  c.Key = K_BARC_ID
  c.Value = m_Barco
  c.HelpId = m_Barc_id
  

  Set c = m_ObjAbm.Properties.Add(Nothing, cscPueIdOrigen)
  c.PropertyType = cspHelp
  c.Table = csPuerto
  c.Name = LNGGetText(2400, vbNullString)   'Puerto origen
  c.Key = K_PUE_ID_ORIGEN
  c.Value = m_PuertoOrigen
  c.HelpId = m_pue_id_origen
  c.TopFromProperty = cscEmbCodigo
  c.Left = 5300
  c.LeftLabel = -1200
  

  Set c = m_ObjAbm.Properties.Add(Nothing, cscPueIdDestino)
  c.PropertyType = cspHelp
  c.Table = csPuerto
  c.Name = LNGGetText(2401, vbNullString)   'Puerto destino
  c.Key = K_PUE_ID_DESTINO
  c.Value = m_PuertoDestino
  c.HelpId = m_pue_id_destino
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscEmbDescrip)
  c.PropertyType = cspText
  c.SubType = cspMemo
  c.Name = C_strDescrip
  c.Size = 1000
  c.Key = K_DESCRIP
  c.Value = m_Descrip
  c.TopFromProperty = cscBarcId
  c.TopToPrevious = 440
  c.LeftFromProperty = cscBarcId
  c.Height = 880
  c.Width = 6000
  
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

Private Function Load(ByVal ID As Long) As Boolean

  Dim sqlstmt As String

  sqlstmt = "sp_embarqueGet " & ID

  Dim rs As Recordset

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.Fields, cscEmbId)
    m_Nombre = gDB.ValField(rs.Fields, cscEmbNombre)
    m_Codigo = gDB.ValField(rs.Fields, cscEmbCodigo)
    m_Descrip = gDB.ValField(rs.Fields, cscEmbDescrip)
    m_Fecha = gDB.ValField(rs.Fields, cscEmbFecha)
    m_Barc_id = gDB.ValField(rs.Fields, cscBarcId)
    m_Barco = gDB.ValField(rs.Fields, cscBarcNombre)
    m_pue_id_origen = gDB.ValField(rs.Fields, cscPueIdOrigen)
    m_PuertoOrigen = gDB.ValField(rs.Fields, "Puerto Origen")
    m_pue_id_destino = gDB.ValField(rs.Fields, cscPueIdDestino)
    m_PuertoDestino = gDB.ValField(rs.Fields, "Puerto Destino")
    m_Creado = gDB.ValField(rs.Fields, cscCreado)
    m_Modificado = gDB.ValField(rs.Fields, cscModificado)
    m_Modifico = gDB.ValField(rs.Fields, cscModifico)
    m_Activo = gDB.ValField(rs.Fields, cscActivo)
    
  Else
    m_Id = csNO_ID
    m_Nombre = vbNullString
    m_Codigo = vbNullString
    m_Descrip = vbNullString
    m_Fecha = Date
    m_Barc_id = csNO_ID
    m_Barco = vbNullString
    m_pue_id_origen = csNO_ID
    m_PuertoOrigen = vbNullString
    m_pue_id_destino = csNO_ID
    m_PuertoDestino = vbNullString
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

  c_ErrorSave = LNGGetText(2420, vbNullString)  'Error al grabar Embarque

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



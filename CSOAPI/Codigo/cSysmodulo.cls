VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cSysmodulo"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGeneric
Implements CSInterfacesABM.cIABMClient
Implements CSMenu.cIMenuClient
'--------------------------------------------------------------------------------
' Sysmodulo
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
Private Const C_Module = "cSysmodulo"

Private Const K_OBJETOINICIALIZACION           As Integer = 1
Private Const K_OBJETOEDICION                  As Integer = 2
Private Const K_ORDEN                          As Integer = 3
Private Const K_ID                             As Integer = 4
Private Const K_PRESTACION                     As Integer = 5
Private Const K_INIT                           As Integer = 6

' estructuras
' Seudo - Variables
Private c_ErrorSave                    As String

' variables privadas
Private m_Objetoinicializacion         As String
Private m_ObjetoEdicion                As String
Private m_Id                           As Long
Private m_Orden                        As Long
Private m_Prestacion                   As Long

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
Public Property Get Objetoinicializacion() As String
  Objetoinicializacion = m_Objetoinicializacion
End Property

Public Property Let Objetoinicializacion(ByVal rhs As String)
  m_Objetoinicializacion = rhs
End Property

Public Property Get ObjetoEdicion() As String
  ObjetoEdicion = m_ObjetoEdicion
End Property

Public Property Let ObjetoEdicion(ByVal rhs As String)
  m_ObjetoEdicion = rhs
End Property

Public Property Get Id() As Long
  Id = m_Id
End Property

Public Property Let Id(ByVal rhs As Long)
  m_Id = rhs
End Property

Public Property Get Orden() As Long
  Orden = m_Orden
End Property

Public Property Let Orden(ByVal rhs As Long)
  m_Orden = rhs
End Property

' Properties privadas
' funciones publicas

' Implementacion de cIABMClient
Private Function cIABMClient_Copy() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True
  
  With m_ObjAbm.Properties(cscsysmObjetoedicion)
    .Value = C_CopiaDe & .Value
  End With
  
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscsysmObjetoedicion)
  
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

  Doc.ClientTable = csTsysModulo
  Doc.ClientTableID = m_Id

  cIABMClient_ShowDocDigital = Doc.ShowDocs(gDB)

  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClient_ShowDocDigital", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
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
  On Error GoTo ControlError
  
  Select Case Key
    Case K_INIT
      Dim ObjName As String
      Dim o       As Object
      
      ObjName = m_ObjAbm.Properties.Item(cscsysmObjetoinicializacion).Value
      Set o = CSKernelClient2.CreateObject(ObjName)
      o.Init gDB
  End Select

  Exit Function
ControlError:
  MngError Err, "cIABMClient_PropertyChange", "Sysmodulo", vbNullString
End Function

Private Function cIABMClient_Save() As Boolean
  Dim register As cRegister
  Set register = New cRegister
  register.fieldId = cscsysmId
  register.Table = csTsysModulo
  
  If m_Copy Then m_IsNew = True
  
  Dim IProperty As cIABMProperty
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_ID
          register.Id = Val(.Value)
        Case K_OBJETOINICIALIZACION
          register.Fields.Add2 cscsysmObjetoinicializacion, .Value, csText
        Case K_OBJETOEDICION
          register.Fields.Add2 cscsysmObjetoedicion, .Value, csText
        Case K_ORDEN
          register.Fields.Add2 cscsysmOrden, .Value, csLong
        Case K_PRESTACION
          register.Fields.Add2 cscPreID, .Value, csLong
      End Select
    End With
  Next
  register.Fields.HaveLastUpdate = False
  register.Fields.HaveWhoModify = False
  
  If Not gDB.Save(register, m_IsNew, "cIABMClient_Save", "csysModulo", c_ErrorSave) Then Exit Function
  
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
    cIABMClient_Title = LNGGetText(2766, vbNullString)  'SysModulo
End Property

Private Function cIABMClient_Validate() As Boolean

  Dim IProperty As cIABMProperty

  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_ID
          If ValEmpty(.Value, csText) Then
            MsgInfo LNGGetText(2767, vbNullString)  'Debe indicar un ID
            Exit Function
          End If
        Case K_OBJETOINICIALIZACION
          If ValEmpty(.Value, csText) Then
            MsgInfo LNGGetText(2768, vbNullString)  'Debe indicar un Objeto Inicialización
            Exit Function
          End If
        Case K_OBJETOEDICION
          If ValEmpty(.Value, csText) Then
            MsgInfo LNGGetText(2769, vbNullString)  'Debe indicar un Objeto Edición
            Exit Function
          End If
        Case K_ORDEN
          If ValEmpty(.Value, csLong) Then
            MsgInfo LNGGetText(2770, vbNullString)  'Debe indicar un Orden
            Exit Function
          End If
        Case K_PRESTACION
          If ValEmpty(.Value, csLong) Then
            MsgInfo LNGGetText(2771, vbNullString)  'Debe indicar una Prestación
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
    cIEditGeneric_ShowList = CSOAPI2.SecurityCanAccess(csPreOListSysmodulo)
End Function

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
    Set m_ObjAbm = rhs
End Property

Private Property Get cIEditGeneric_Editing() As Boolean
    cIEditGeneric_Editing = m_Editing
End Property

Private Function cIEditGeneric_Delete(Id As Long) As Boolean
    If Not CSOAPI2.SecurityCanAccess(csPreODeleteSysmodulo) Then Exit Function

    Dim sqlstmt As String
    
    sqlstmt = "Delete sysModulo where sysm_id = " & Id
    
    cIEditGeneric_Delete = gDB.Execute(sqlstmt, "cIEditGeneric_Delete", "Sysmodulo")
End Function

Private Function cIEditGeneric_Search(Id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Id = csNO_ID Then
    m_IsNew = True
    If Not CSOAPI2.SecurityCanAccess(csPreONewSysmodulo) Then Exit Function
  Else
    m_IsNew = False
    If Not CSOAPI2.SecurityCanAccess(csPreOEditSysmodulo) Then Exit Function
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
  MngError Err, "cIEditGeneric_Edit", "Sysmodulo", vbNullString
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
  Dim str_2703  As String
  
  str_2703 = LNGGetText(2703, vbNullString)   'S&istema
  Set m_Host = Host
  m_Host.Server.AddMenu str_2703, csMenuConfigSys + 500, vbNullString, 0, True, False, False, True, False, Nothing
  m_Host.Server.AddMenu LNGGetText(2772, vbNullString), csPreOListSysmodulo + 500, str_2703, 0, True, False, False, False, False, Me
                        '&Sysmodulo
  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, "cIMenuClient_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal Id As Long) As Variant
  m_Host.MenuABMClick "CSOAPIEdit.cSysmodulo", Me, LNGGetText(2766, vbNullString), 0, csETablesOAPI.csSysModulo
                                                    'Sysmodulo
End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  
  With m_ObjAbm.Properties
    
    .Clear

    With .Add(Nothing, cscsysmId)
      .PropertyType = cspNumeric
      .SubType = cspInteger
      .Name = LNGGetText(2773, vbNullString) 'ID
      .Width = 1200
      .Key = K_ID
      .Value = Id
    End With
      
    With .Add(Nothing, cscsysmObjetoinicializacion)
      .PropertyType = cspText
      .Name = LNGGetText(2774, vbNullString) 'Objeto Inicialización
      .Size = 255
      .Width = 4000
      .Key = K_OBJETOINICIALIZACION
      .Value = Objetoinicializacion
    End With
      
    With .Add(Nothing, cscsysmObjetoedicion)
      .PropertyType = cspText
      .Name = LNGGetText(2775, vbNullString) 'Objeto Edición
      .Width = 4000
      .Size = 255
      .Key = K_OBJETOEDICION
      .Value = ObjetoEdicion
    End With
      
    With .Add(Nothing, cscsysmOrden)
      .PropertyType = cspNumeric
      .Width = 1200
      .Name = LNGGetText(1809, vbNullString) 'Orden
      .Key = K_ORDEN
      .Value = Orden
      .SubType = cspInteger
    End With
      
    With .Add(Nothing, cscPreID)
      .PropertyType = cspNumeric
      .Width = 1200
      .Name = LNGGetText(2776, vbNullString) 'Prestación
      .Key = K_PRESTACION
      .Value = m_Prestacion
      .SubType = cspInteger
    End With
      
    With .Add(Nothing, "Init")
      .PropertyType = cspButton
      .Name = "Init"
      .Key = K_INIT
    End With
    
  End With
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

Private Function Load(ByVal Id As Long) As Boolean

  Dim sqlstmt As String
                    
  sqlstmt = "select * from Sysmodulo where Sysm_id = " & Id

  Dim rs As Recordset

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "Load", "cSysmodulo") Then Exit Function

  If Not rs.EOF Then

    m_Objetoinicializacion = gDB.ValField(rs.Fields, cscsysmObjetoinicializacion)
    m_ObjetoEdicion = gDB.ValField(rs.Fields, cscsysmObjetoedicion)
    m_Id = gDB.ValField(rs.Fields, cscsysmId)
    m_Orden = gDB.ValField(rs.Fields, cscsysmOrden)
    m_Prestacion = gDB.ValField(rs.Fields, cscPreID)

  Else
    m_Objetoinicializacion = vbNullString
    m_ObjetoEdicion = vbNullString
    m_Id = csNO_ID
    m_Orden = 0
    m_Prestacion = csNO_ID
  End If

  Load = True
End Function
' construccion - destruccion

Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  c_ErrorSave = LNGGetText(2777, vbNullString) 'Error al grabar sysModulo
  
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

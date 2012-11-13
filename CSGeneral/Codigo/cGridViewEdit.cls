VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cGridViewEdit"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGeneric
Implements CSInterfacesABM.cIABMClient
'--------------------------------------------------------------------------------
' cGridViewEdit
' 09-10-06
'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones
'--------------------------------------------------------------------------------
' constantes
Private Const C_Module = "cGridViewEdit"

Private Const K_NOMBRE                         As Integer = 3
Private Const K_DEFAULT                        As Integer = 4
Private Const K_PUBLICA                        As Integer = 5
Private Const K_AUTOWIDTH                      As Integer = 6

' estructuras
' Seudo - Variables
Private c_ErrorSave                    As String

' variables privadas
Private m_Grid_name                    As String
Private m_Rpt_id                       As Long
Private m_Id                           As Long
Private m_Nombre                       As String
Private m_Default                      As Boolean
Private m_Publica                      As Boolean
Private m_Autowidth                    As Boolean
Private m_Us_id                        As Long

Private m_Editing                      As Boolean

Private m_ObjAbm                       As cIABMGeneric

' Properties publicas

Public Property Get Id() As Long
  Id = m_Id
End Property

Public Property Get Nombre() As String
  Nombre = m_Nombre
End Property

Public Property Get Codigo() As String
  Codigo = m_Nombre
End Property

Public Property Get Grid_name() As String
  Grid_name = m_Grid_name
End Property

Public Property Let Grid_name(ByVal rhs As String)
  m_Grid_name = rhs
End Property

Public Property Get Rpt_id() As Long
  Rpt_id = m_Rpt_id
End Property

Public Property Let Rpt_id(ByVal rhs As Long)
  m_Rpt_id = rhs
End Property

Public Property Get Us_id() As Long
  Us_id = m_Us_id
End Property

Public Property Let Us_id(ByVal rhs As Long)
  m_Us_id = rhs
End Property

' Properties privadas
' funciones publicas
Public Function EditView(ByVal grdv_id As Long) As Boolean
  Dim AbmObj As cABMGeneric
  Set m_ObjAbm = New CSABMInterface2.cABMGeneric
  Set AbmObj = m_ObjAbm
  AbmObj.OkCancelDialog = True
  EditView = cIEditGeneric_Edit(grdv_id, True)
End Function

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
  cIABMClient_ShowDocDigital = False
End Function

Private Function cIABMClient_MessageEx(ByVal MessageID As Long, ByVal Info As Variant) As Variant
  cIABMClient_MessageEx = True
End Function

Private Function cIABMClient_Copy() As Boolean
  cIABMClient_Copy = False
End Function

Private Sub cIABMClient_DiscardChanges()
  LoadCollection
End Sub

Private Function cIABMClient_EditNew() As Boolean
  cIABMClient_EditNew = False
End Function

Private Function cIABMClient_ListAdHock(List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClient_Load()

End Sub

Private Function cIABMClient_PropertyChange(ByVal Key As Integer) As Boolean

End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError

  m_ObjAbm.InModalWindow = InModalWindow

  If Not Load(Id) Then Exit Function
  
  If Not LoadCollection() Then Exit Function
  
  m_Editing = True

  If InModalWindow Then
    cIEditGeneric_Edit = m_Id <> csNO_ID
  Else
    cIEditGeneric_Edit = True
  End If

  Exit Function
ControlError:
  MngError Err, C_EditGenericEdit, C_Module, vbNullString
End Function

Private Function cIABMClient_Save() As Boolean
  Dim register As cRegister
  Dim Fields   As cFields
  Dim bDefault As Boolean
  
  Set register = New cRegister
  
  With register
    Set Fields = .Fields
    .fieldId = cscGrdvId
    .Table = csTGridView
    .Id = m_Id
  End With
  
  Dim IProperty As cIABMProperty
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_NOMBRE
          register.Fields.Add2 cscGrdvNombre, .Value, csText
        Case K_DEFAULT
          bDefault = Val(.Value)
          register.Fields.Add2 cscGrdvDefault, .Value, csBoolean
        Case K_PUBLICA
          register.Fields.Add2 cscGrdvPublica, .Value, csBoolean
        Case K_AUTOWIDTH
          register.Fields.Add2 cscGrdvAutowidth, .Value, csBoolean
      End Select
    End With
  Next
  
  register.Fields.Add2 cscGridName, m_Grid_name, csText
  register.Fields.Add2 cscRptId, m_Rpt_id, csId
  register.Fields.Add2 cscUsId, m_Us_id, csId

  Fields.HaveLastUpdate = False
  Fields.HaveWhoModify = False
  
  If Not register.BeginTrans(gDB) Then Exit Function
  
  If Not gDB.Save(register, , C_ABMClientSave, C_Module, c_ErrorSave) Then Exit Function
  
  If bDefault Then
    Dim sqlstmt As String
    sqlstmt = "sp_GridViewSaveDefault " & register.Id
    If Not gDB.Execute(sqlstmt) Then Exit Function
  End If
  
  If Not register.CommitTrans() Then Exit Function
  
  cIABMClient_Save = Load(register.Id)
End Function

Private Function cIABMClient_Terminate() As Boolean
  m_Editing = False
  cIABMClient_Terminate = True
End Function

Private Property Get cIABMClient_Title() As String
  cIABMClient_Title = LNGGetText(2786, vbNullString) 'Vista
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

' Implementacion de cIEditGeneric

Private Function cIEditGeneric_TabClick(ByVal Index As Integer) As Boolean

End Function

Private Property Let cIEditGeneric_TreeId(ByVal rhs As Long)

End Property

Private Property Get cIEditGeneric_TreeId() As Long

End Property

Private Function cIEditGeneric_GridAdd(ByVal KeyProperty As Integer) As Boolean

End Function

Private Function cIEditGeneric_GridEdit(ByVal KeyProperty As Integer) As Boolean

End Function

Private Function cIEditGeneric_GridRemove(ByVal KeyProperty As Integer) As Boolean

End Function

Private Function cIEditGeneric_ShowList() As Boolean
    cIEditGeneric_ShowList = False
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
  cIEditGeneric_Delete = False
End Function

Private Function cIEditGeneric_Search(Id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_PrintObj(ByVal Id As Long) As Boolean

End Function

Private Property Set cIEditGeneric_ObjTree(rhs As Object)

End Property

Private Property Let cIEditGeneric_BranchId(ByVal rhs As Long)

End Property

Private Property Get cIEditGeneric_BranchId() As Long

End Property

Private Function cIEditGeneric_Preview(ByVal Id As Long) As Boolean

End Function

Private Function cIEditGeneric_PropertyChange(ByVal Key As Integer) As Boolean

End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  m_ObjAbm.Properties.Clear
  
  Dim c As cIABMProperty
  
  m_ObjAbm.Title2 = m_Nombre
    
  Set c = m_ObjAbm.Properties.Add(c, cscGrdvNombre)
  c.PropertyType = cspText
  c.Name = C_strNombre
  c.Size = 255
  c.Key = K_NOMBRE
  c.Value = Nombre
  c.Width = 5000
  Set c = Nothing

  Set c = m_ObjAbm.Properties.Add(c, cscGrdvDefault)
  c.PropertyType = cspCheck
  c.Name = LNGGetText(2725, vbNullString) 'Por defecto
  c.Key = K_DEFAULT
  c.Value = CInt(m_Default)
  Set c = Nothing

  Set c = m_ObjAbm.Properties.Add(c, cscGrdvPublica)
  c.PropertyType = cspCheck
  c.Name = LNGGetText(2878, vbNullString) 'Pública
  c.Key = K_PUBLICA
  c.Value = CInt(m_Publica)
  Set c = Nothing

  Set c = m_ObjAbm.Properties.Add(c, cscGrdvAutowidth)
  c.PropertyType = cspCheck
  c.Left = 3140
  c.LeftLabel = -2800
  c.Name = LNGGetText(2879, vbNullString) 'Auto Ajustar el ancho de las columnas
  c.Key = K_AUTOWIDTH
  c.Value = CInt(m_Autowidth)
  Set c = Nothing
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

Private Function Load(ByVal Id As Long) As Boolean

  Dim sqlstmt As String

  sqlstmt = "select * from GridView where grdv_id = " & Id

  Dim rs As Recordset

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If Not rs.EOF Then

    m_Grid_name = gDB.ValField(rs.Fields, cscGridName)
    m_Rpt_id = gDB.ValField(rs.Fields, cscRptId)
    m_Id = gDB.ValField(rs.Fields, cscGrdvId)
    m_Nombre = gDB.ValField(rs.Fields, cscGrdvNombre)
    m_Default = gDB.ValField(rs.Fields, cscGrdvDefault)
    m_Publica = gDB.ValField(rs.Fields, cscGrdvPublica)
    m_Autowidth = gDB.ValField(rs.Fields, cscGrdvAutowidth)
    m_Us_id = gDB.ValField(rs.Fields, cscUsId)

  Else
    
    m_Id = csNO_ID
    m_Nombre = vbNullString
    m_Default = False
    m_Publica = False
    m_Autowidth = False

  End If

  Load = True
End Function

Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  c_ErrorSave = LNGGetText(2880, vbNullString) 'Error al grabar la Vista
  
  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

' construccion - destruccion
Private Sub Class_Terminate()
  On Error Resume Next
   Set m_ObjAbm = Nothing
End Sub

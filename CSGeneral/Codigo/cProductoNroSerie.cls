VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cProductoNroSerie"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGeneric
Implements CSInterfacesABM.cIABMClient
'--------------------------------------------------------------------------------
' cProductoNroSerie
' 06-09-03
'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones
'--------------------------------------------------------------------------------
' constantes
Private Const C_Module = "cProductoNroSerie"

Private Const K_CODIGO          As Integer = 2
Private Const K_CODIGO2         As Integer = 10
Private Const K_CODIGO3         As Integer = 11
Private Const K_FECHAVTO        As Integer = 5
Private Const K_DESCRIP         As Integer = 6

' estructuras
' Seudo - Variables
Private c_ErrorSave             As String

' variables privadas
Private m_Id                           As Long
Private m_Codigo                       As String
Private m_Codigo2                      As String
Private m_Codigo3                      As String
Private m_Descrip                      As String
Private m_FechaVto                     As Date

Private m_Editing                      As Boolean

Private m_ObjAbm                       As cIABMGeneric
Private m_ObjTree                      As Object

Private m_BranchId                     As Long
Private m_TreeId                       As Long

' Properties publicas

Public Property Get Id() As Long
  Id = m_Id
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

  Doc.ClientTable = csTProductoNumeroSerie
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
  
  If Id = csNO_ID Then
    Exit Function
  Else
    If Not SecurityCanAccess(csPreGEditProductoNroSerie) Then Exit Function
  End If

' JMA I
  m_ObjAbm.InModalWindow = InModalWindow
' JMA F

  If Not Load(Id) Then Exit Function
  
  If Not LoadCollection() Then Exit Function
  
  m_Editing = True

' JMA I
  If InModalWindow Then
    cIEditGeneric_Edit = m_Id <> csNO_ID
  Else
    cIEditGeneric_Edit = True
  End If
' JMA I

  Exit Function
ControlError:
  MngError Err, C_EditGenericEdit, C_Module, vbNullString
End Function

Private Function cIABMClient_Save() As Boolean
  Dim register As cRegister
  Dim Fields   As cFields
  
  Set register = New cRegister
  
  With register
    Set Fields = .Fields
    .fieldId = cscPrnsId
    .Table = csTProductoNumeroSerie
    .Id = m_Id
  End With
  
  Dim IProperty As cIABMProperty
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_CODIGO
          Fields.Add2 cscPrnsCodigo, .Value, csText
        Case K_CODIGO2
          Fields.Add2 cscPrnsCodigo2, .Value, csText
        Case K_CODIGO3
          Fields.Add2 cscPrnsCodigo3, .Value, csText
        Case K_DESCRIP
          Fields.Add2 cscPrnsDescrip, .Value, csText
        Case K_FECHAVTO
          Fields.Add2 cscPrnsFechaVto, .Value, csDate
      End Select
    End With
  Next
  
  Fields.HaveLastUpdate = True
  Fields.HaveWhoModify = True
  
  If Not register.BeginTrans(gDB) Then Exit Function
  
  If Not gDB.Save(register, , C_ABMClientSave, C_Module, c_ErrorSave) Then Exit Function
  
  If Not register.CommitTrans() Then Exit Function
  
  cIABMClient_Save = Load(register.Id)
End Function

Private Function cIABMClient_Terminate() As Boolean
    m_Editing = False
    cIABMClient_Terminate = True
End Function

Private Property Get cIABMClient_Title() As String
    cIABMClient_Title = LNGGetText(1820, vbNullString) 'Número de Serie
End Property

Private Function cIABMClient_Validate() As Boolean

  Dim IProperty As cIABMProperty

  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_CODIGO
          If ValEmpty(.Value, csText) Then
            MsgInfo C_DebeIndicarCodigo
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

' funciones privadas
Private Function LoadCollection() As Boolean
  m_ObjAbm.Properties.Clear
  
  Dim c As cIABMProperty
  
  m_ObjAbm.Title2 = m_Codigo
    
  Set c = m_ObjAbm.Properties.Add(Nothing, cscPrnsCodigo)
  c.PropertyType = cspText
  c.Name = C_strCodigo
  c.Size = 100
  c.Key = K_CODIGO
  c.Value = m_Codigo
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscPrnsCodigo2)
  c.PropertyType = cspText
  c.Name = C_strCodigo & " 2"
  c.Size = 100
  c.Key = K_CODIGO2
  c.Value = m_Codigo2
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscPrnsCodigo3)
  c.PropertyType = cspText
  c.Name = C_strCodigo & " 3"
  c.Size = 100
  c.Key = K_CODIGO3
  c.Value = m_Codigo3
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscPrnsFechaVto)
  c.PropertyType = cspDate
  c.Name = LNGGetText(1802, vbNullString) 'Fecha de Vto
  c.Value = m_FechaVto
  c.Key = K_FECHAVTO
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscPrnsDescrip)
  c.PropertyType = cspText
  c.Name = C_strDescrip
  c.Size = 255
  c.Width = 6500
  c.Height = 660
  c.SubType = cspMemo
  c.Key = K_DESCRIP
  c.Value = m_Descrip
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

Private Function Load(ByVal Id As Long) As Boolean

  Dim sqlstmt As String

  sqlstmt = "select * from ProductoNumeroSerie Where prns_id = " & Id

  Dim rs As Recordset

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.Fields, cscPrnsId)
    m_Codigo = gDB.ValField(rs.Fields, cscPrnsCodigo)
    m_Codigo2 = gDB.ValField(rs.Fields, cscPrnsCodigo2)
    m_Codigo3 = gDB.ValField(rs.Fields, cscPrnsCodigo3)
    m_Descrip = gDB.ValField(rs.Fields, cscPrnsDescrip)
    m_FechaVto = gDB.ValField(rs.Fields, cscPrnsFechaVto)

  Else
    m_Id = csNO_ID
    m_Codigo = vbNullString
    m_Codigo2 = vbNullString
    m_Codigo3 = vbNullString
    m_Descrip = vbNullString
    m_FechaVto = csNoDate

  End If

  Load = True
End Function

Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  c_ErrorSave = LNGGetText(1798, vbNullString) 'Error al grabar el número de serie del Producto.

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
   Set m_ObjTree = Nothing
End Sub






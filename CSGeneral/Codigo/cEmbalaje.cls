VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cEmbalaje"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGeneric
Implements CSInterfacesABM.cIABMClient
Implements CSMenu.cIMenuClient
'--------------------------------------------------------------------------------
' cEmbalaje
' 17-11-04

'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cEmbalaje"

Private Const K_NOMBRE                         As Integer = 1
Private Const K_CODIGO                         As Integer = 2
Private Const K_DESCRIP                        As Integer = 3
Private Const K_CAPACIDAD                      As Integer = 4
Private Const K_ALTO                           As Integer = 5
Private Const K_ANCHO                          As Integer = 6
Private Const K_LARGO                          As Integer = 7
Private Const K_TARA                           As Integer = 8
Private Const K_PR_ID_STOCK                    As Integer = 9
Private Const K_UN_ID                          As Integer = 10
Private Const K_ACTIVO                         As Integer = 11
' estructuras
' variables privadas
Private m_Id                           As Long
Private m_Nombre                       As String
Private m_Codigo                       As String
Private m_descrip                      As String
Private m_Capacidad                    As Double
Private m_Alto                         As Double
Private m_Ancho                        As Double
Private m_Largo                        As Double
Private m_Tara                         As Double
Private m_UnId                         As Long
Private m_Unidad                       As String
Private m_PrIdStock                    As Long
Private m_Producto                     As String
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
Private m_Copy              As Boolean

Private m_Host              As CSMenu.cIMenuHost

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

  Doc.ClientTable = csTEmbalaje
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
  Select Case MessageID
  
    Case MSG_DOC_INFO
    
      Dim AbmGen As cABMGeneric
      Set AbmGen = m_ObjAbm
      
      CSKernelClient2.ShowHelp AbmGen.hWnd, _
                               vbNullString, _
                               vbNullString, _
                               csPreGNewEmbalaje
      cIABMClient_MessageEx = MSG_DOC_INFO_HANDLED
    Case Else
      cIABMClient_MessageEx = True
  End Select
End Function

Private Sub cIABMClient_DiscardChanges()
  LoadCollection
End Sub

Private Function cIABMClient_Copy() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True

  With m_ObjAbm.Properties(cscEmblCodigo)
    .Value = "C-" & .Value
  End With
  
  With m_ObjAbm.Properties(cscEmblNombre)
    .Value = "Copia de " & .Value
  End With
  
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscEmblCodigo)
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscEmblNombre)
  
  m_Copy = True
End Function

Private Function cIABMClient_ListAdHock(List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClient_Load()

End Sub

Private Function cIABMClient_PropertyChange(ByVal Key As Integer) As Boolean

End Function

Private Function cIABMClient_Save() As Boolean
  Dim register   As cRegister
  Dim fields     As cFields
  
  Set register = New cRegister
  Set fields = register.fields
  
  With register
    .fieldId = cscEmblId
    .Table = csTEmbalaje
    
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
          fields.Add2 cscEmblNombre, .Value, csText
        Case K_CODIGO
          fields.Add2 cscEmblCodigo, .Value, csText
        Case K_DESCRIP
          fields.Add2 cscEmblDescrip, .Value, csText
        Case K_CAPACIDAD
          fields.Add2 cscEmblCapacidad, .Value, csCurrency
        Case K_ALTO
          fields.Add2 cscEmblAlto, .Value, csCurrency
        Case K_ANCHO
          fields.Add2 cscEmblAncho, .Value, csCurrency
        Case K_LARGO
          fields.Add2 cscEmblLargo, .Value, csCurrency
        Case K_TARA
          fields.Add2 cscEmblTara, .Value, csCurrency
        Case K_PR_ID_STOCK
          fields.Add2 cscPrIdStock, .HelpId, csId
        Case K_UN_ID
          fields.Add2 cscUnId, .HelpId, csId
        Case K_ACTIVO
          fields.Add2 cscActivo, .Value, csBoolean
      End Select
    End With
  Next
  
  fields.HaveLastUpdate = True
  fields.HaveWhoModify = True
  
  If Not gDB.SaveEx(register, , _
                    cscEmblCodigo, _
                    C_ABMClientSave, _
                    C_Module, _
                    LNGGetText(1154, vbNullString)) Then Exit Function
  
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
  cIABMClient_Title = LNGGetText(1155, vbNullString)  'Embalajes
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
        Case K_CAPACIDAD
          If ValEmpty(.Value, csCurrency) Then
            MsgInfo LNGGetText(1156, vbNullString)  'Debe indicar una capacidad
            Exit Function
          End If
        Case K_ALTO
          If ValEmpty(.Value, csCurrency) Then
            MsgInfo LNGGetText(1157, vbNullString)  'Debe indicar un alto
            Exit Function
          End If
        Case K_ANCHO
          If ValEmpty(.Value, csCurrency) Then
            MsgInfo LNGGetText(1158, vbNullString)  'Debe indicar un ancho
            Exit Function
          End If
        Case K_LARGO
          If ValEmpty(.Value, csCurrency) Then
            MsgInfo LNGGetText(1159, vbNullString)  'Debe indicar un largo
            Exit Function
          End If
        Case K_TARA
          If ValEmpty(.Value, csCurrency) Then
            MsgInfo LNGGetText(1160, vbNullString)  'Debe indicar una tara
            Exit Function
          End If
        Case K_UN_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(1161, vbNullString)  'Debe indicar una unidad
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
  cIEditGeneric_ShowList = SecurityCanAccess(csPreGListEmbalaje)
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
  If Not SecurityCanAccess(csPreGDeleteEmbalaje) Then Exit Function

  Dim sqlstmt As String
  
  sqlstmt = "delete Embalaje where embl_id = " & Id
  
  cIEditGeneric_Delete = gDB.Execute(sqlstmt, "cIEditGeneric_Delete", "cEmbalaje")
End Function

Private Function cIEditGeneric_Search(Id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Id = csNO_ID Then
    m_IsNew = True
    If Not SecurityCanAccess(csPreGNewEmbalaje) Then Exit Function
  Else
    m_IsNew = False
    If Not SecurityCanAccess(csPreGEditEmbalaje) Then Exit Function
  End If

  m_ObjAbm.InModalWindow = InModalWindow

  If Not Load(Id) Then Exit Function
  
  If Not LoadCollection() Then Exit Function
  
  m_Editing = True
  m_Copy = False

  m_ObjAbm.InModalWindow = InModalWindow

  Exit Function
ControlError:
  MngError Err, "cIEditGeneric_Edit", "cEmbalaje", vbNullString
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

  Set m_Host = Host
  
  m_Host.Server.AddMenu C_MenuArticulos, csMenuConfigArticulos, C_MenuConfig, 0, True, False, False, False, True, Nothing
                        '&Embalajes
  m_Host.Server.AddMenu LNGGetText(1162, vbNullString), csPreGListEmbalaje, C_MenuArticulos, 0, True, False, False, False, False, Me

  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, C_MenuClientInit, C_Module, vbNullString
  If Err.Number Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal Id As Long) As Variant
                                                  'Embalaje
  m_Host.MenuABMClick "CSGeneral2.cEmbalaje", Me, LNGGetText(1163, vbNullString), 0, csETablasGeneral.csEmbalaje
End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  
  m_ObjAbm.Title2 = m_Nombre
  
  With m_ObjAbm.Properties
    
    .Clear
    
    With .Add(Nothing, cscEmblNombre)
      .PropertyType = cspText
      .Name = C_strNombre
      .Size = 255
      .Key = K_NOMBRE
      .Value = Nombre
    End With
    
    With .Add(Nothing, cscEmblCodigo)
      .PropertyType = cspText
      .Name = C_strCodigo
      .Size = 50
      .Key = K_CODIGO
      .Value = Codigo
    End With
    
    With .Add(Nothing, cscActivo)
      .PropertyType = cspCheck
      .Name = C_strCodigo
      .Key = K_ACTIVO
      .Value = CInt(m_Activo)
    End With
      
    With .Add(Nothing, cscEmblCapacidad)
      .PropertyType = cspNumeric
      .SubType = cspDouble
      .Format = gFormatDecCantidad
      .Name = LNGGetText(1164, vbNullString) 'Capacidad
      .Width = 1100
      .Key = K_CAPACIDAD
      .Value = m_Capacidad
    End With
    
    With .Add(Nothing, cscUnId)
      .PropertyType = cspHelp
      .Table = csUnidad
      .Name = LNGGetText(1165, vbNullString) 'Unidad
      .Key = K_UN_ID
      .Value = m_Unidad
      .HelpId = m_UnId
    End With
      
    With .Add(Nothing, cscPrIdStock)
      .PropertyType = cspHelp
      .Table = csProducto
      .Name = LNGGetText(1166, vbNullString) 'Articulo stock
      .Key = K_PR_ID_STOCK
      .Value = m_Producto
      .HelpId = m_PrIdStock
    End With
      
    With .Add(Nothing, cscEmblAlto)
      .PropertyType = cspNumeric
      .SubType = cspDouble
      .Format = gFormatDecCantidad
      .Name = LNGGetText(1167, vbNullString) 'Alto
      .Width = 1100
      .Key = K_ALTO
      .TopFromProperty = cscEmblNombre
      .Left = 5500
      .Value = m_Alto
    End With
    
    With .Add(Nothing, cscEmblAncho)
      .PropertyType = cspNumeric
      .SubType = cspDouble
      .Format = gFormatDecCantidad
      .Name = LNGGetText(1168, vbNullString) 'Ancho
      .Width = 1100
      .Key = K_ANCHO
      .Value = m_Ancho
    End With
    
    With .Add(Nothing, cscEmblLargo)
      .PropertyType = cspNumeric
      .Name = LNGGetText(1169, vbNullString) 'Largo
      .Width = 1100
      .SubType = cspDouble
      .Format = gFormatDecCantidad
      .Key = K_LARGO
      .Value = m_Largo
    End With
    
    With .Add(Nothing, cscEmblTara)
      .PropertyType = cspNumeric
      .SubType = cspDouble
      .Format = gFormatDecCantidad
      .Name = LNGGetText(1049, vbNullString) 'Tara
      .Width = 1100
      .Key = K_TARA
      .Value = m_Tara
    End With
      
    With .Add(Nothing, cscEmblDescrip)
      .PropertyType = cspText
      .Name = C_strDescrip
      .TopFromProperty = cscPrIdStock
      .TopToPrevious = 440
      .Size = 255
      .Key = K_DESCRIP
      .Value = m_descrip
      .SubType = cspMemo
      .LeftFromProperty = cscEmblNombre
      .Width = 6220
      .Height = 660
    End With
  
  End With
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

Private Function Load(ByVal Id As Long) As Boolean

  Dim sqlstmt As String
  Dim rs      As Recordset

  sqlstmt = "select e.*,pr_nombrecompra, un_nombre from Embalaje e inner join Unidad u on e.un_id = u.un_id" & _
            " left join Producto p on e.pr_id_stock = p.pr_id" & _
            " where e.embl_id = " & Id

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.fields, cscEmblId)
    m_Nombre = gDB.ValField(rs.fields, cscEmblNombre)
    m_Codigo = gDB.ValField(rs.fields, cscEmblCodigo)
    m_descrip = gDB.ValField(rs.fields, cscEmblDescrip)
    m_Capacidad = gDB.ValField(rs.fields, cscEmblCapacidad)
    m_Alto = gDB.ValField(rs.fields, cscEmblAlto)
    m_Ancho = gDB.ValField(rs.fields, cscEmblAncho)
    m_Largo = gDB.ValField(rs.fields, cscEmblLargo)
    m_Tara = gDB.ValField(rs.fields, cscEmblTara)
    m_UnId = gDB.ValField(rs.fields, cscUnId)
    m_Unidad = gDB.ValField(rs.fields, cscUnNombre)
    m_PrIdStock = gDB.ValField(rs.fields, cscPrIdStock)
    m_Producto = gDB.ValField(rs.fields, cscPrNombrecompra)
    m_Creado = gDB.ValField(rs.fields, cscCreado)
    m_Modificado = gDB.ValField(rs.fields, cscModificado)
    m_Modifico = gDB.ValField(rs.fields, cscModifico)
    m_Activo = gDB.ValField(rs.fields, cscActivo)

  Else
    
    m_Id = csNO_ID
    m_Nombre = vbNullString
    m_Codigo = vbNullString
    m_descrip = vbNullString
    m_Capacidad = 0
    m_Alto = 0
    m_Ancho = 0
    m_Largo = 0
    m_Tara = 0
    m_UnId = csNO_ID
    m_Unidad = vbNullString
    m_PrIdStock = csNO_ID
    m_Producto = vbNullString
    m_Creado = csNoDate
    m_Modificado = csNoDate
    m_Modifico = 0
    m_Activo = True

  End If

  Load = True
End Function

' construccion - destruccion
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

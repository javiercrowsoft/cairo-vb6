VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cListaPrecioMarcado"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGeneric
Implements CSInterfacesABM.cIABMClient
Implements CSMenu.cIMenuClient
'--------------------------------------------------------------------------------
' cListaPrecioMarcado
' 05-02-01

'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cListaPrecioMarcado"

Private Const K_NOMBRE                         As Integer = 1
Private Const K_CODIGO                         As Integer = 2
Private Const K_BASE                           As Integer = 3
Private Const K_PORCENTAJE                     As Integer = 4
Private Const K_SALTO                          As Integer = 5
Private Const K_DECREMENTO                     As Integer = 6
Private Const K_PORCMINIMO                     As Integer = 7
Private Const K_PORCMAXIMO                     As Integer = 8
Private Const K_MONTOMINIMO                    As Integer = 9
Private Const K_ACTIVO                         As Integer = 10
Private Const K_DESCRIP                        As Integer = 11
Private Const K_MON_ID                         As Integer = 12
' estructuras
' variables privadas
Private m_Id                As Long
Private m_Nombre            As String
Private m_Codigo            As String
Private m_Activo            As Boolean
Private m_descrip           As String

Private m_Base                         As Double
Private m_Porcentaje                   As Double
Private m_Salto                        As Double
Private m_Decremento                   As Double
Private m_Porcminimo                   As Double
Private m_Porcmaximo                   As Double
Private m_Montominimo                  As Double

Private m_mon_id                       As Long
Private m_Moneda                       As String

Private m_Editing          As Boolean

Private m_ObjAbm           As cIABMGeneric
Private m_ObjTree          As Object

Private m_IsNew            As Boolean

Private m_BranchId         As Long
Private m_TreeId           As Long

Private m_Host As CSMenu.cIMenuHost
Private m_Copy              As Boolean

Private m_VentaConfig       As cVentaConfig

' propiedades publicas

Public Property Get Id() As Long
  Id = m_Id
End Property

Public Property Get Nombre() As String
  Nombre = m_Nombre
End Property

Public Property Get Codigo() As String
  Codigo = m_Codigo
End Property

' propiedades privadas
' funciones publicas

' Implementacion de cIABMClient
Private Function cIABMClient_Copy() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True
  
  With m_ObjAbm.Properties(cscLpmCodigo)
    .Value = C_C & .Value
  End With
  
'  With m_ObjAbm.Properties(cscLpmNombre)
'    .Value = C_CopiaDe & .Value
'  End With
  
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscLpmCodigo)
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscLpmNombre)
  
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

  Doc.ClientTable = csTListaPrecioMarcado
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
  Select Case MessageID
  
    Case MSG_DOC_INFO
    
      Dim AbmGen As cABMGeneric
      Set AbmGen = m_ObjAbm
      
      CSKernelClient2.ShowHelp AbmGen.hWnd, _
                               vbNullString, _
                               vbNullString, _
                               csPreGNewListaPrecioMarcado
      cIABMClient_MessageEx = MSG_DOC_INFO_HANDLED
    Case Else
      cIABMClient_MessageEx = True
  End Select
End Function

Private Sub cIABMClient_DiscardChanges()
  LoadCollection
End Sub

Private Function cIABMClient_ListAdHock(Lista As CSInterfacesABM.cIABMList) As Boolean

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
    .fieldId = cscLpmId
    .Table = csTListaPrecioMarcado

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
          fields.Add2 cscLpmNombre, .Value, csText
        Case K_CODIGO
          fields.Add2 cscLpmCodigo, .Value, csText
        Case K_ACTIVO
          fields.Add2 cscActivo, Val(.Value), csBoolean
        Case K_DESCRIP
          fields.Add2 cscLpmDescrip, .Value, csText
        Case K_BASE
          fields.Add2 cscLpmBase, .Value, csCurrency
        Case K_PORCENTAJE
          fields.Add2 cscLpmPorcentaje, .Value, csCurrency
        Case K_SALTO
          fields.Add2 cscLpmSalto, .Value, csCurrency
        Case K_DECREMENTO
          fields.Add2 cscLpmDecremento, .Value, csCurrency
        Case K_PORCMINIMO
          fields.Add2 cscLpmPorcminimo, .Value, csCurrency
        Case K_PORCMAXIMO
          fields.Add2 cscLpmPorcmaximo, .Value, csCurrency
        Case K_MONTOMINIMO
          fields.Add2 cscLpmMontominimo, .Value, csCurrency
        Case K_MON_ID
          fields.Add2 cscMonId, .HelpId, csId
      End Select
    End With
  Next
  
  fields.HaveLastUpdate = True
  fields.HaveWhoModify = True
                    ' Error al grabar la tabla de marcado de precios
  If Not gDB.SaveEx(register, , _
                    cscLpmCodigo, _
                    C_ABMClientSave, _
                    C_Module, _
                    LNGGetText(3505, vbNullString)) Then Exit Function
  
  pUpdateListaPrecioPrecio

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
                        ' Tabla de Marcado de Precios
  cIABMClient_Title = LNGGetText(3506, vbNullString)
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
        Case K_CODIGO
            If ValEmpty(.Value, csText) Then
                .Value = c_get_codigo_from_id
            End If
        Case K_MON_ID
            If ValEmpty(.HelpId, csId) Then
                MsgInfo LNGGetText(1108, vbNullString) ' Debe indicar una moneda
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
    cIEditGeneric_ShowList = SecurityCanAccess(csPreGListListaPrecioMarcado)
End Function

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
    Set m_ObjAbm = rhs
End Property

Private Property Get cIEditGeneric_Editing() As Boolean
    cIEditGeneric_Editing = m_Editing
End Property

Private Function cIEditGeneric_Delete(Id As Long) As Boolean
    If Not SecurityCanAccess(csPreGDeleteListaPrecioMarcado) Then Exit Function

    Dim sqlstmt As String
    
    sqlstmt = "delete ListaPrecioMarcado where lpm_id = " & Id
    
    cIEditGeneric_Delete = gDB.Execute(sqlstmt, C_EditGenericDelete, C_Module)
End Function

Private Function cIEditGeneric_Search(Id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Id = csNO_ID Then
    m_IsNew = True
    If Not SecurityCanAccess(csPreGNewListaPrecioMarcado) Then Exit Function
  Else
    m_IsNew = False
    If Not SecurityCanAccess(csPreGEditListaPrecioMarcado) Then Exit Function
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
  MngError Err, C_EditGenericEdit, C_Module, vbNullString
End Function

Private Function cIEditGeneric_PrintObj(ByVal Id As Long) As Boolean

End Function

Private Property Set cIEditGeneric_ObjTree(rhs As Object)
    Set m_ObjTree = rhs
End Property

Private Function cIEditGeneric_PropertyChange(ByVal Clave As Integer) As Boolean

End Function

Private Property Let cIEditGeneric_BranchId(ByVal rhs As Long)
    m_BranchId = rhs
End Property

Private Property Get cIEditGeneric_BranchId() As Long
    cIEditGeneric_BranchId = m_BranchId
End Property

Private Function cIEditGeneric_TabClick(ByVal Index As Integer) As Boolean

End Function

Private Function cIEditGeneric_Preview(ByVal Id As Long) As Boolean

End Function

Private Function cIMenuClient_Initialize(F As Object, Host As CSMenu.cIMenuHost) As Boolean
  On Error GoTo ControlError

  Set m_Host = Host
  
  m_Host.Server.AddMenu C_MenuArticulos, csMenuConfigArticulos, C_MenuConfig, 0, True, False, False, False, True, Nothing
                            '&Tabla de Marcado de Precios
  m_Host.Server.AddMenu LNGGetText(3507, vbNullString), csPreGListListaPrecioMarcado, C_MenuArticulos, 0, True, False, False, False, False, Me

  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, C_MenuClientInit, C_Module, vbNullString
  If Err.Number Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal Id As Long) As Variant
                      ' Tablas de Marcado de Precios
  m_Host.MenuABMClick "CSGeneral2.cListaPrecioMarcado", _
                      Me, _
                      LNGGetText(3508, vbNullString), _
                      0, _
                      csETablasGeneral.csListaPrecioMarcado
End Function


' funciones privadas
Private Function LoadCollection() As Boolean
  
  m_ObjAbm.Title2 = m_Nombre
  
  With m_ObjAbm.Properties
  
    .Clear
  
    With .Add(Nothing, cscLpmNombre)
      .PropertyType = cspText
      .Name = C_strNombre
      .Size = 100
      .Width = 5000
      .Key = K_NOMBRE
      .Value = m_Nombre
    End With
        
    With .Add(Nothing, cscLpmCodigo)
      .PropertyType = cspText
      .Name = C_strCodigo
      .Size = 15
      .Value = m_Codigo
      .Key = K_CODIGO
    End With
        
    With .Add(Nothing, cscActivo)
      .PropertyType = cspCheck
      .TopFromProperty = cscLpmNombre
      .LeftLabel = -800
      .TopNotChange = True
      .Left = 7500
      .LeftNotChange = True
      .Name = C_strActivo
      .Key = K_ACTIVO
      .Value = CInt(m_Activo)
    End With
        
    With .Add(Nothing, cscLpmBase)
      .PropertyType = cspNumeric
      .SubType = cspDouble
      .Format = gFormatDecCantidad
      .Name = LNGGetText(2550, vbNullString) 'Base
      .Key = K_BASE
      .Value = m_Base
      .Width = 1000
     End With

    With .Add(Nothing, cscLpmPorcentaje)
      .PropertyType = cspNumeric
      .SubType = cspPercent
      .Name = LNGGetText(1105, vbNullString) 'porcentaje
      .Key = K_PORCENTAJE
      .Value = m_Porcentaje
     End With

    With .Add(Nothing, cscLpmSalto)
      .PropertyType = cspNumeric
      .SubType = cspDouble
      .Format = gFormatDecCantidad
      .Name = LNGGetText(3509, vbNullString) 'Salto
      .Key = K_SALTO
      .Value = m_Salto
     End With

    With .Add(Nothing, cscLpmDecremento)
      .PropertyType = cspNumeric
      .SubType = cspPercent
      .Name = LNGGetText(3510, vbNullString) 'Decremento
      .Key = K_DECREMENTO
      .Value = m_Decremento
     End With

    With .Add(Nothing, cscLpmPorcminimo)
      .PropertyType = cspNumeric
      .SubType = cspPercent
      .Name = LNGGetText(3511, vbNullString) 'Porc. Minimo
      .Key = K_PORCMINIMO
      .Value = m_Porcminimo
      .TopFromProperty = cscLpmBase
      .Left = 5500
     End With

    With .Add(Nothing, cscLpmPorcmaximo)
      .PropertyType = cspNumeric
      .SubType = cspPercent
      .Name = LNGGetText(3512, vbNullString) 'Porc. Maximo
      .Key = K_PORCMAXIMO
      .Value = m_Porcmaximo
     End With

    With .Add(Nothing, cscLpmMontominimo)
      .PropertyType = cspNumeric
      .SubType = cspDouble
      .Format = gFormatDecCantidad
      .Name = LNGGetText(3513, vbNullString) 'Monto Minimo
      .Key = K_MONTOMINIMO
      .Value = m_Montominimo
     End With
        
    With .Add(Nothing, cscMonId)
      .PropertyType = cspHelp
      .Table = csMoneda
      .Name = LNGGetText(1113, vbNullString) 'Moneda
      .Key = K_MON_ID
      .HelpId = m_mon_id
      .Value = m_Moneda
    End With
        
    With .Add(Nothing, cscLpmDescrip)
      .PropertyType = cspText
      .SubType = cspMemo
      .Name = C_strDescrip
      .Key = K_DESCRIP
      .Height = 440
      .Width = 6250
      .Value = m_descrip
      .LeftFromProperty = cscLpmNombre
      .TopFromProperty = cscLpmDecremento
      .TopToPrevious = 440
    End With
        
  End With
    
  If Not m_ObjAbm.Show(Me) Then Exit Function

  LoadCollection = True
End Function

Private Function Load(ByVal Id As Long) As Boolean
  
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "select lpm.*,mon_nombre " & _
            "from ListaPrecioMarcado lpm inner join Moneda mon on lpm.mon_id = mon.mon_id " & _
            "where lpm_id = " & Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function
  
  If rs.EOF Then
    m_Activo = True
    m_Nombre = vbNullString
    m_Codigo = vbNullString
    m_Id = csNO_ID
    m_Base = 0
    m_Porcentaje = 0
    m_Salto = 0
    m_Decremento = 0
    m_Porcminimo = 0
    m_Porcmaximo = 0
    m_Montominimo = 0
    m_descrip = vbNullString
    m_mon_id = csNO_ID
    m_Moneda = vbNullString
  Else
    m_Activo = gDB.ValField(rs.fields, cscActivo)
    m_Nombre = gDB.ValField(rs.fields, cscLpmNombre)
    m_Codigo = gDB.ValField(rs.fields, cscLpmCodigo)
    m_Id = gDB.ValField(rs.fields, cscLpmId)
    m_Base = gDB.ValField(rs.fields, cscLpmBase)
    m_Porcentaje = gDB.ValField(rs.fields, cscLpmPorcentaje)
    m_Salto = gDB.ValField(rs.fields, cscLpmSalto)
    m_Decremento = gDB.ValField(rs.fields, cscLpmDecremento)
    m_Porcminimo = gDB.ValField(rs.fields, cscLpmPorcminimo)
    m_Porcmaximo = gDB.ValField(rs.fields, cscLpmPorcmaximo)
    m_Montominimo = gDB.ValField(rs.fields, cscLpmMontominimo)
    m_descrip = gDB.ValField(rs.fields, cscLpmDescrip)
    m_mon_id = gDB.ValField(rs.fields, cscMonId)
    m_Moneda = gDB.ValField(rs.fields, cscMonNombre)
  End If
  
  Load = True
End Function

Private Sub pUpdateListaPrecioPrecio()
  
  If Not m_VentaConfig.UsarListaPrecioPrecio Then Exit Sub
  
  If Ask(LNGGetText(3600, vbNullString), vbYes) Then
    
    Dim sqlstmt     As String
    Dim oldTimeOut  As Long
    
    sqlstmt = "sp_listaPrecioMarcadoUpdateCache " & m_Id
    oldTimeOut = gDB.CommandTimeout
    gDB.CommandTimeout = 1200
    gDB.Execute sqlstmt
    gDB.CommandTimeout = oldTimeOut
  End If
  
End Sub

Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  Set m_VentaConfig = New cVentaConfig
  m_VentaConfig.Load

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
  Set m_VentaConfig = Nothing
End Sub

VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cEmpresa"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGeneric
Implements CSInterfacesABM.cIABMClient
Implements CSMenu.cIMenuClient
'--------------------------------------------------------------------------------
' cEmpresa
' 23-07-04

'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cEmpresa"

Private Const K_NOMBRE                         As Integer = 1
Private Const K_CODIGO                         As Integer = 2
Private Const K_DESCRIP                        As Integer = 3
Private Const K_RAZONSOCIAL                    As Integer = 4
Private Const K_CUIT                           As Integer = 5
Private Const K_INGRESOSBRUTOS                 As Integer = 6
Private Const K_CATFISCAL                      As Integer = 7
Private Const K_CHEQUEORDEN                    As Integer = 8
Private Const K_CODPOSTAL                      As Integer = 9
Private Const K_LOCALIDAD                      As Integer = 10
Private Const K_CALLE                          As Integer = 11
Private Const K_CALLENUMERO                    As Integer = 12
Private Const K_PISO                           As Integer = 13
Private Const K_DEPTO                          As Integer = 14
Private Const K_TEL                            As Integer = 15
Private Const K_FAX                            As Integer = 16
Private Const K_EMAIL                          As Integer = 17
Private Const K_WEB                            As Integer = 18
Private Const K_ACTIVO                         As Integer = 19
Private Const K_CODIGO_BARRA                   As Integer = 20
Private Const K_ES_SUCURSAL                    As Integer = 21

' estructuras
' variables privadas
Private m_Id                           As Long
Private m_Nombre                       As String
Private m_Codigo                       As String
Private m_CodigoBarra                  As String
Private m_descrip                      As String
Private m_Razonsocial                  As String
Private m_Cuit                         As String
Private m_Ingresosbrutos               As String
Private m_CatFiscal                    As Integer
Private m_Chequeorden                  As String
Private m_EsSucursal                   As Boolean
Private m_Codpostal                    As String
Private m_Localidad                    As String
Private m_Calle                        As String
Private m_Callenumero                  As String
Private m_Piso                         As String
Private m_Depto                        As String
Private m_Tel                          As String
Private m_Fax                          As String
Private m_Email                        As String
Private m_Web                          As String
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

Private Function cIABMClient_MessageEx(ByVal MessageID As Long, ByVal Info As Variant) As Variant
  Select Case MessageID
  
    Case MSG_DOC_INFO
    
      Dim AbmGen As cABMGeneric
      Set AbmGen = m_ObjAbm
      
      CSKernelClient2.ShowHelp AbmGen.hWnd, _
                               vbNullString, _
                               vbNullString, _
                               csPreGNewEmpresa
      cIABMClient_MessageEx = MSG_DOC_INFO_HANDLED
    Case Else
      cIABMClient_MessageEx = True
  End Select
End Function

Private Function cIABMClient_ShowDocDigital() As Boolean
  On Error GoTo ControlError
  
  If m_Id = csNO_ID Then Exit Function
  
  Dim Doc As cDocDigital
  Set Doc = New cDocDigital

  Doc.ClientTable = csTEmpresa
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

Private Sub cIABMClient_DiscardChanges()
    LoadCollection
End Sub

Private Function cIABMClient_Copy() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True

  With m_ObjAbm.Properties(cscEmpCodigo)
    .Value = "C-" & .Value
  End With
  
  With m_ObjAbm.Properties(cscEmpNombre)
    .Value = "Copia de " & .Value
  End With
  
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscEmpCodigo)
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscEmpNombre)
  
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
    .fieldId = cscEmpId
    .Table = csTEmpresa
    
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
          fields.Add2 cscEmpNombre, .Value, csText
        Case K_CODIGO
          fields.Add2 cscEmpCodigo, .Value, csText
        Case K_CODIGO_BARRA
          fields.Add2 cscEmpCodigoBarra, .Value, csText
        Case K_ES_SUCURSAL
          fields.Add2 cscEmpEsSucursal, .Value, csBoolean
        Case K_DESCRIP
          fields.Add2 cscEmpDescrip, .Value, csText
        Case K_RAZONSOCIAL
          fields.Add2 cscEmpRazonsocial, .Value, csText
        Case K_CUIT
          fields.Add2 cscEmpCuit, .Value, csText
        Case K_INGRESOSBRUTOS
          fields.Add2 cscEmpIngresosbrutos, .Value, csText
        Case K_CATFISCAL
          fields.Add2 cscEmpCatfiscal, .ListItemData, csInteger
        Case K_CHEQUEORDEN
          fields.Add2 cscEmpChequeorden, .Value, csText
        Case K_CODPOSTAL
          fields.Add2 cscEmpCodpostal, .Value, csText
        Case K_LOCALIDAD
          fields.Add2 cscEmpLocalidad, .Value, csText
        Case K_CALLE
          fields.Add2 cscEmpCalle, .Value, csText
        Case K_CALLENUMERO
          fields.Add2 cscEmpCallenumero, .Value, csText
        Case K_PISO
          fields.Add2 cscEmpPiso, .Value, csText
        Case K_DEPTO
          fields.Add2 cscEmpDepto, .Value, csText
        Case K_TEL
          fields.Add2 cscEmpTel, .Value, csText
        Case K_FAX
          fields.Add2 cscEmpFax, .Value, csText
        Case K_EMAIL
          fields.Add2 cscEmpEmail, .Value, csText
        Case K_WEB
          fields.Add2 cscEmpWeb, .Value, csText
        Case K_ACTIVO
          fields.Add2 cscActivo, .Value, csBoolean
      End Select
    End With
  Next
  
  fields.HaveLastUpdate = True
  fields.HaveWhoModify = True
                                                            'Error al grabar Empresa
  If Not gDB.SaveEx(register, , _
                    cscEmpCodigo, _
                    C_ABMClientSave, _
                    C_Module, _
                    LNGGetText(1170, vbNullString)) Then Exit Function
  
  m_Copy = False
  cIABMClient_Save = Load(register.Id)
  
  pSaveInDomain
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
    cIABMClient_Title = LNGGetText(1171, vbNullString) 'Empresas
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
        Case K_RAZONSOCIAL
          If ValEmpty(.Value, csText) Then
            MsgInfo LNGGetText(1172, vbNullString) 'Debe indicar una razón social
            Exit Function
          End If
        Case K_CUIT
          If ValEmpty(.Value, csText) Then
            MsgInfo LNGGetText(1173, vbNullString) 'Debe indicar un CUIT
            Exit Function
          End If
        Case K_CATFISCAL
          If ValEmpty(.ListItemData, csInteger) Then
            MsgInfo LNGGetText(1174, vbNullString) 'Debe indicar un categoría fiscal
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
    cIEditGeneric_ShowList = SecurityCanAccess(csPreGListEmpresa)
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
  Dim Todo      As Boolean
  Dim fDesde    As Date
  Dim fHasta    As Date
  Dim SoloDoc   As Boolean
  
  If Not SecurityCanAccess(csPreGDeleteEmpresa) Then Exit Function
  If Not pConfirmDelete(Id, Todo, fDesde, fHasta, SoloDoc) Then Exit Function
  
  cIEditGeneric_Delete = pDeleteAux(Id, Todo, fDesde, fHasta, SoloDoc)
End Function

Private Function pConfirmDelete(ByVal EmpId As Long, _
                                ByRef Todo As Boolean, _
                                ByRef fDesde As Date, _
                                ByRef fHasta As Date, _
                                ByRef SoloDoc As Boolean) As Boolean

  Dim iEmpresaDelete As cIEditGeneric
  Dim EmpresaDelete  As cEmpresaDelete
  Dim EmpNombre      As String
  
  If Not gDB.GetData(csTEmpresa, cscEmpId, EmpId, cscEmpNombre, EmpNombre) Then Exit Function
  
  Set iEmpresaDelete = New cEmpresaDelete
  Set EmpresaDelete = iEmpresaDelete
  
  Set iEmpresaDelete.ObjAbm = New cABMGeneric
  EmpresaDelete.Empresa = EmpNombre
  
  If iEmpresaDelete.Edit(EmpId, True) Then
    
    fDesde = EmpresaDelete.FechaDesde
    fHasta = EmpresaDelete.FechaHasta
    SoloDoc = EmpresaDelete.SoloDoc
    Todo = EmpresaDelete.Todo
    pConfirmDelete = True
  End If
End Function

Private Function pDeleteAux(ByVal EmpId As Long, _
                            ByVal Todo As Boolean, _
                            ByVal fDesde As Date, _
                            ByVal fHasta As Date, _
                            ByVal SoloDoc As Boolean) As Boolean

  Dim sqlstmt           As String
  Dim oldCommandTimeout As Long
  
  sqlstmt = "sp_empresaDelete " & EmpId & "," & User.Id & ","
    
  If Todo Then
    sqlstmt = sqlstmt & "null,null,"
  Else
    sqlstmt = sqlstmt & gDB.sqlDate(fDesde) & "," & gDB.sqlDate(fHasta) & ","
  End If
  
  sqlstmt = sqlstmt & CInt(SoloDoc)
  
  ' Ojo no se puede usar exit function
  ' despues de esta linea ya que debe salir
  ' si o si por ExitProc
  '
  On Error GoTo ControlError
  
  oldCommandTimeout = gDB.CommandTimeout
  gDB.CommandTimeout = 0
  
  If gDB.Execute(sqlstmt, "cIEditGeneric_Delete", "cEmpresa") Then
    pDeleteAux = True
    pDeleteInDomain EmpId
  End If
  
  GoTo ExitProc
ControlError:
  MngError Err, "pDeleteAux", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
  gDB.CommandTimeout = oldCommandTimeout
End Function

Private Function cIEditGeneric_Search(Id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Id = csNO_ID Then
      m_IsNew = True
      If Not SecurityCanAccess(csPreGNewEmpresa) Then Exit Function
  Else
      m_IsNew = False
      If Not SecurityCanAccess(csPreGEditEmpresa) Then Exit Function
  End If

  m_ObjAbm.InModalWindow = InModalWindow

  If Not Load(Id) Then Exit Function
  
  If Not LoadCollection() Then Exit Function
  
  m_Editing = True
  m_Copy = False

  m_ObjAbm.InModalWindow = InModalWindow

  Exit Function
ControlError:
  MngError Err, "cIEditGeneric_Edit", "cEmpresa", vbNullString
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
                          '&Empresas                                          &Empresa
  m_Host.Server.AddMenu LNGGetText(1175, vbNullString), csPreGListEmpresa, LNGGetText(1134, vbNullString), 0, True, False, False, False, False, Me
  
  cIMenuClient_Initialize = True
  
  GoTo ExitProc
ControlError:
  MngError Err, C_MenuClientInit, C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal Id As Long) As Variant
                                                  'Empresas
  m_Host.MenuABMClick "CSGeneral2.cEmpresa", Me, LNGGetText(1171, vbNullString), 0, csETablasGeneral.csEmpresa
End Function

' funciones privadas

Private Function LoadCollection() As Boolean
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  AbmObj.MinHeight = 6400

  Dim c As cIABMProperty
  
  With m_ObjAbm
  
    .Title2 = m_Nombre

    With .Tabs
      
      .Clear
      
      With .Add(Nothing)
        .Name = C_strGeneral
      End With
    
      With .Add(Nothing)
        .Index = 1
        .Name = LNGGetText(1037, vbNullString)  'Dirección
      End With
    
    End With
  
    With .Properties
      
      .Clear
  
      With .Add(Nothing, cscEmpNombre)
        .PropertyType = cspText
        .Name = C_strNombre
        .Size = 255
        .Key = K_NOMBRE
        .Value = m_Nombre
      End With
      
      With .Add(Nothing, cscEmpCodigo)
        .PropertyType = cspText
        .Name = C_strCodigo
        .Size = 15
        .Key = K_CODIGO
        .Value = m_Codigo
      End With
      
      With .Add(Nothing, cscActivo)
        .PropertyType = cspCheck
        .Name = C_strActivo
        .Key = K_ACTIVO
        .Value = CInt(m_Activo)
      End With
      
      With .Add(Nothing, cscEmpCodigoBarra)
        .PropertyType = cspText
        .Name = LNGGetText(1177, vbNullString) 'Código de Barras
        .Size = 15
        .Key = K_CODIGO_BARRA
        .Value = m_CodigoBarra
      End With
      
      With .Add(Nothing, cscEmpRazonsocial)
        .PropertyType = cspText
        .Name = LNGGetText(1178, vbNullString) 'Razón Social
        .Size = 255
        .Key = K_RAZONSOCIAL
        .Value = m_Razonsocial
      End With
      
      With .Add(Nothing, cscEmpCuit)
        .PropertyType = cspText
        .Name = LNGGetText(1179, vbNullString) 'Cuit
        .Size = 50
        .Key = K_CUIT
        .Value = m_Cuit
      End With
    
      With .Add(Nothing, cscEmpIngresosbrutos)
        .PropertyType = cspText
        .TopFromProperty = cscEmpNombre
        .Left = 5300
        .Name = LNGGetText(1180, vbNullString) 'Ingresos brutos
        .Size = 20
        .Key = K_INGRESOSBRUTOS
        .Value = m_Ingresosbrutos
      End With
    
      With .Add(Nothing, cscEmpCatfiscal)
        .PropertyType = cspList
        .Name = LNGGetText(1181, vbNullString) 'Categoria Fiscal
        .Key = K_CATFISCAL
        .ListWhoSetItem = csListItemData
        .ListItemData = m_CatFiscal
      
        With .List
        
          With .Add(Nothing, csCatFConsumidorFinal)
            .Id = csCatFConsumidorFinal
            .Value = LNGGetText(1182, vbNullString) 'Consumidor final
          End With
          
          With .Add(Nothing, csCatFNoInscripto)
            .Id = csCatFNoInscripto
            .Value = LNGGetText(1183, vbNullString) 'No Inscripto
          End With
          
          With .Add(Nothing, csCatFInscripto)
            .Id = csCatFInscripto
            .Value = LNGGetText(1184, vbNullString) 'Inscripto
          End With
          
          With .Add(Nothing, csCatFExtranjero)
            .Id = csCatFExtranjero
            .Value = LNGGetText(1185, vbNullString) 'Extranjero
          End With
          
          With .Add(Nothing, csCatFExento)
            .Id = csCatFExento
            .Value = LNGGetText(1186, vbNullString) 'Exento
          End With
        
          With .Add(Nothing, csCatFMonoTributo)
            .Id = csCatFMonoTributo
            .Value = LNGGetText(1187, vbNullString) 'Monotributo
          End With
        
          With .Add(Nothing, csCatFExtranjeroIva)
            .Id = csCatFExtranjeroIva
            .Value = LNGGetText(1188, vbNullString) 'Extranjero con Iva
          End With
        
          With .Add(Nothing, csCatFNoCategorizado)
            .Id = csCatFNoCategorizado
            .Value = LNGGetText(1189, vbNullString) 'No categorizado
          End With
        
          With .Add(Nothing, csCatFNoResponsable)
            .Id = csCatFNoResponsable
            .Value = LNGGetText(1190, vbNullString) 'No responsable
          End With
        
          With .Add(Nothing, csCatFNoResponsableExento)
            .Id = csCatFNoResponsableExento
            .Value = LNGGetText(1191, vbNullString) 'No responsable exento
          End With
      
          With .Add(Nothing, csCatFInscriptoM)
            .Id = csCatFInscriptoM
            .Value = LNGGetText(1192, vbNullString) 'Inscripto M
          End With
        End With
        
      End With
      
      With .Add(Nothing, cscEmpEsSucursal)
        .PropertyType = cspCheck
        .Name = LNGGetText(4654, vbNullString) 'Es Sucursal
        .Key = K_ES_SUCURSAL
        .Value = CInt(m_EsSucursal)
      End With
      
      With .Add(Nothing, cscEmpChequeorden)
        .PropertyType = cspText
        .Name = LNGGetText(1193, vbNullString) 'Cheque Orden
        .Size = 100
        .Key = K_CHEQUEORDEN
        .Value = m_Chequeorden
      End With
    
      With .Add(Nothing, cscEmpCalle)
        .PropertyType = cspText
        .Name = LNGGetText(1194, vbNullString) 'Calle
        .Size = 100
        .Key = K_CALLE
        .TabIndex = 1
        .Value = m_Calle
      End With
    
      With .Add(Nothing, cscEmpCallenumero)
        .PropertyType = cspText
        .Name = LNGGetText(1195, vbNullString) 'Calle Número
        .Size = 100
        .Key = K_CALLENUMERO
        .TabIndex = 1
        .Value = m_Callenumero
      End With
      
      With .Add(Nothing, cscEmpPiso)
        .PropertyType = cspText
        .Name = LNGGetText(1196, vbNullString) 'Piso
        .Size = 100
        .Key = K_PISO
        .TabIndex = 1
        .Value = m_Piso
      End With
    
      With .Add(Nothing, cscEmpDepto)
        .PropertyType = cspText
        .Name = LNGGetText(1197, vbNullString) 'Depto
        .Size = 100
        .Key = K_DEPTO
        .Value = m_Depto
        .TabIndex = 1
      End With
      
      With .Add(Nothing, cscEmpLocalidad)
        .PropertyType = cspText
        .Name = LNGGetText(1198, vbNullString) 'Localidad
        .Size = 100
        .Key = K_LOCALIDAD
        .Value = m_Localidad
        .TabIndex = 1
      End With
      
      With .Add(Nothing, cscEmpCodpostal)
        .PropertyType = cspText
        .Name = LNGGetText(1199, vbNullString) 'Código Postal
        .Size = 50
        .Key = K_CODPOSTAL
        .Value = m_Codpostal
        .TabIndex = 1
      End With
    
      With .Add(Nothing, cscEmpTel)
        .PropertyType = cspText
        .Name = LNGGetText(1036, vbNullString) 'Telefono
        .Size = 100
        .Key = K_TEL
        .Value = m_Tel
      End With
      
      With .Add(Nothing, cscEmpFax)
        .PropertyType = cspText
        .Name = LNGGetText(1200, vbNullString) 'Fax
        .Size = 100
        .Key = K_FAX
        .Value = m_Fax
      End With
      
      With .Add(Nothing, cscEmpEmail)
        .PropertyType = cspText
        .Name = LNGGetText(1034, vbNullString) 'E-Mail
        .LeftLabel = -500
        .Size = 100
        .Key = K_EMAIL
        .Value = m_Email
        .TopFromProperty = cscEmpNombre
        .Left = 8200
      End With
      
      With .Add(Nothing, cscEmpWeb)
        .PropertyType = cspText
        .Name = LNGGetText(1038, vbNullString) 'Web
        .Size = 100
        .Key = K_WEB
        .Value = m_Web
      End With
      
      With .Add(Nothing, cscEmpDescrip)
        .PropertyType = cspText
        .Name = C_strDescrip
        .Size = 255
        .TopFromProperty = cscEmpCuit
        .TopToPrevious = 440
        .LeftFromProperty = cscEmpNombre
        .SubType = cspMemo
        .Height = 880
        .Width = 9000
        .Key = K_DESCRIP
        .Value = m_descrip
      End With
  
    End With
  
    If Not .Show(Me) Then Exit Function
    
  End With
  
  LoadCollection = True
End Function

Private Function Load(ByVal Id As Long) As Boolean

  Dim sqlstmt As String
  Dim rs      As Recordset

  sqlstmt = "select * from empresa where emp_id = " & Id

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.fields, cscEmpId)
    m_Nombre = gDB.ValField(rs.fields, cscEmpNombre)
    m_Codigo = gDB.ValField(rs.fields, cscEmpCodigo)
    m_CodigoBarra = gDB.ValField(rs.fields, cscEmpCodigoBarra)
    m_descrip = gDB.ValField(rs.fields, cscEmpDescrip)
    m_Razonsocial = gDB.ValField(rs.fields, cscEmpRazonsocial)
    m_Cuit = gDB.ValField(rs.fields, cscEmpCuit)
    m_Ingresosbrutos = gDB.ValField(rs.fields, cscEmpIngresosbrutos)
    m_CatFiscal = gDB.ValField(rs.fields, cscEmpCatfiscal)
    m_Chequeorden = gDB.ValField(rs.fields, cscEmpChequeorden)
    m_Codpostal = gDB.ValField(rs.fields, cscEmpCodpostal)
    m_Localidad = gDB.ValField(rs.fields, cscEmpLocalidad)
    m_Calle = gDB.ValField(rs.fields, cscEmpCalle)
    m_Callenumero = gDB.ValField(rs.fields, cscEmpCallenumero)
    m_Piso = gDB.ValField(rs.fields, cscEmpPiso)
    m_Depto = gDB.ValField(rs.fields, cscEmpDepto)
    m_Tel = gDB.ValField(rs.fields, cscEmpTel)
    m_Fax = gDB.ValField(rs.fields, cscEmpFax)
    m_Email = gDB.ValField(rs.fields, cscEmpEmail)
    m_Web = gDB.ValField(rs.fields, cscEmpWeb)
    m_EsSucursal = gDB.ValField(rs.fields, cscEmpEsSucursal)
    m_Activo = gDB.ValField(rs.fields, cscActivo)

  Else
    m_Id = csNO_ID
    m_Nombre = vbNullString
    m_Codigo = vbNullString
    m_CodigoBarra = vbNullString
    m_descrip = vbNullString
    m_Razonsocial = vbNullString
    m_Cuit = vbNullString
    m_Ingresosbrutos = vbNullString
    m_CatFiscal = 0
    m_Chequeorden = vbNullString
    m_Codpostal = vbNullString
    m_Localidad = vbNullString
    m_Calle = vbNullString
    m_Callenumero = vbNullString
    m_Piso = vbNullString
    m_Depto = vbNullString
    m_Tel = vbNullString
    m_Fax = vbNullString
    m_Email = vbNullString
    m_Web = vbNullString
    m_EsSucursal = False
    m_Activo = True

  End If

  Load = True
End Function

Private Sub pSaveInDomain()
  Dim db  As cDataBase
  Set db = pGetDataBase
  pSaveEmpresas db
End Sub

Private Sub pDeleteInDomain(ByVal Id As Long)
  Dim db  As cDataBase
  Set db = pGetDataBase
  pDeleteEmpresa db, Id
End Sub

Private Sub pDeleteEmpresa(ByRef dbDomain As cDataBase, ByVal Id As Long)
  Dim Encrypt As cEncrypt
  Set Encrypt = New cEncrypt
  Dim sqlstmt As String
  
  If dbDomain Is Nothing Then Exit Sub

  sqlstmt = "sp_SysDomainDeleteEmpresa " & BdId & "," & Id
  
  If Not dbDomain.Execute(sqlstmt) Then Exit Sub
  
  GoTo ExitProc
ControlError:
  MngError Err, "pDeleteEmpresa", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub pSaveEmpresas(ByRef dbDomain As cDataBase)
  Dim Encrypt As cEncrypt
  Set Encrypt = New cEncrypt
  Dim sqlstmt As String
  
  If dbDomain Is Nothing Then Exit Sub
  
  sqlstmt = "sp_SysDomainUpdateEmpresa " & BdId & "," & m_Id & "," & dbDomain.sqlString(Encrypt.Encript(m_Nombre, c_LoginSignature))
  
  If Not dbDomain.Execute(sqlstmt) Then Exit Sub
  
  GoTo ExitProc
ControlError:
  MngError Err, "pSaveEmpresas", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Function pGetDataBase() As cDataBase
  Dim db        As cDataBase
  Dim Connstr   As String
  Dim ErrorMsg  As String
  
  If Not pGetConnstrToDomain(Connstr, ErrorMsg) Then
    If LenB(ErrorMsg) Then
      CSKernelClient2.MsgWarning ErrorMsg, LNGGetText(1171, vbNullString)   'Empresas
    Else
                                 ' Ha ocurrido un error al obtener los parametros de conexion a la base dominio
                                 '
      CSKernelClient2.MsgWarning LNGGetText(4655, vbNullString), LNGGetText(1171, vbNullString)      'Empresas
      Exit Function
    End If
  End If

  Set db = New cDataBase
  If Not db.InitDB(, , , , Connstr) Then Exit Function

  Set pGetDataBase = db
End Function

Public Function pGetConnstrToDomain(ByRef strConnect As String, ByRef ErrorMsg As String) As Boolean
  Dim Buffer        As String
  Dim Message       As String
  Dim DataReceived  As String
  
  Buffer = TCPGetMessage(cTCPCommandGetConnectStrDom2, ClientProcessId, Message)
  If Not TCPClient.SendAndReciveText(Buffer, SRV_ID_SERVER) Then Exit Function
  
  DataReceived = TCPClient.DataReceived
  
  If TCPError(DataReceived) Then
    MsgError pGetErrorMessage(DataReceived)
    Exit Function
  End If
  
  Buffer = TCPGetResponse(DataReceived)
  If TCPGetFail(DataReceived) Then
    ErrorMsg = Buffer
    Exit Function
  End If
  
  strConnect = Decript(Buffer, c_LoginSignature)
  
  pGetConnstrToDomain = True
End Function

Private Function pGetErrorMessage(ByVal DataReceived As String) As String
  pGetErrorMessage = LNGGetText(1201, vbNullString, TCPGetResponse(DataReceived))
  
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

VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cClientePV"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGeneric
Implements CSInterfacesABM.cIABMClient
'--------------------------------------------------------------------------------
' cCliente
' 20-08-08
'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cCliente"

Private Const csPreGNewCliente = 1068

Private Const K_NOMBRE                         As Integer = 1
Private Const K_CODIGO                         As Integer = 2
Private Const K_DESCRIP                        As Integer = 3
Private Const K_RAZONSOCIAL                    As Integer = 5
Private Const K_PRO_ID                         As Integer = 6
Private Const K_ZON_ID                         As Integer = 7
Private Const K_CATFISCAL                      As Integer = 8
Private Const K_ACTIVO                         As Integer = 9
Private Const K_CUIT                           As Integer = 19
Private Const K_CODPOSTAL                      As Integer = 10
Private Const K_LOCALIDAD                      As Integer = 11
Private Const K_CALLE                          As Integer = 12
Private Const K_CALLENUMERO                    As Integer = 13
Private Const K_PISO                           As Integer = 14
Private Const K_DEPTO                          As Integer = 15
Private Const K_TEL                            As Integer = 16
Private Const K_EMAIL                          As Integer = 18
Private Const K_CONTACTO                       As Integer = 20
Private Const K_ESPROSPECTO                    As Integer = 47

Private Const K_CPA_ID                         As Integer = 51

Private Const K_HORARIO_M_DESDE                As Integer = 52
Private Const K_HORARIO_M_HASTA                As Integer = 53
Private Const K_HORARIO_T_DESDE                As Integer = 54
Private Const K_HORARIO_T_HASTA                As Integer = 55

' pseudo-constantes
Private c_ErrorSave As String

' estructuras
' variables privadas
Private m_Id                            As Long
Private m_Nombre                        As String
Private m_Contacto                      As String
Private m_Razonsocial                   As String
Private m_Codigo                        As String
Private m_descrip                       As String
Private m_Activo                        As Boolean
Private m_CatFiscal                     As Integer
Private m_pro_id                        As Long
Private m_Provincia                     As String
Private m_zon_id                        As Long
Private m_Zona                          As String
Private m_Codpostal                     As String
Private m_Localidad                     As String
Private m_Calle                         As String
Private m_Callenumero                   As String
Private m_Piso                          As String
Private m_Cuit                          As String
Private m_Depto                         As String
Private m_Tel                           As String
Private m_Email                         As String
Private m_EsProspecto                   As Boolean

Private m_CpaNombre        As String
Private m_cpa_id           As Long
Private m_horario_m_desde  As Date
Private m_horario_m_hasta  As Date
Private m_horario_t_desde  As Date
Private m_horario_t_hasta  As Date

'OJO HASTA ACA

Private m_Editing           As Boolean

Private m_ObjAbm            As cIABMGeneric
Private m_ObjTree           As Object

Private m_IsNew             As Boolean

Private m_BranchId          As Long
Private m_TreeId            As Long

Private m_Host              As CSMenu.cIMenuHost
Private m_Copy              As Boolean

Private m_ventaConfig       As cVentaConfig

' Properties publicas

Public Property Get Id() As Long
  Id = m_Id
End Property

Public Property Get Nombre() As String
  Nombre = m_Nombre
End Property

Public Property Get Codigo() As String
  Codigo = m_Codigo
End Property

' Properties privadas
' funciones publicas

' Implementacion de cIABMClient
Private Function cIABMClient_Copy() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True
  
  With m_ObjAbm.Properties(cscCliCodigo)
    .Value = C_C & .Value
  End With
   
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscCliCodigo)
   
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

  Doc.ClientTable = csTCliente
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
                               csPreGNewCliente
      cIABMClient_MessageEx = MSG_DOC_INFO_HANDLED
    Case Else
      cIABMClient_MessageEx = True
  End Select
End Function

Private Sub cIABMClient_DiscardChanges()
    LoadCollection
End Sub

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
    .fieldId = cscCliId
    .Table = csTCliente
  
    If m_Copy Then
      .Id = csNew
    Else
      .Id = m_Id
    End If
  End With
  
  Dim IProperty As cIABMProperty
  
  Dim cliCatFiscal As Long
  
  cliCatFiscal = m_ObjAbm.Properties.Item(cscCliCatfiscal).ListItemData
  
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
      
        Case K_NOMBRE
          fields.Add2 cscCliNombre, .Value, csText
        Case K_CODIGO
          fields.Add2 cscCliCodigo, .Value, csText
        Case K_RAZONSOCIAL
          fields.Add2 cscCliRazonsocial, .Value, csText
        
        Case K_CUIT
        
          If cliCatFiscal <> csCatFConsumidorFinal _
             Or LCase$(.Value) <> "cuit" Then
        
            fields.Add2 cscCliCuit, .Value, csText
          End If
          
        Case K_CATFISCAL
          fields.Add2 cscCliCatfiscal, .ListItemData, csInteger
        Case K_CODPOSTAL
          fields.Add2 cscCliCodpostal, .Value, csText
        Case K_LOCALIDAD
          fields.Add2 cscCliLocalidad, .Value, csText
        Case K_CALLE
          fields.Add2 cscCliCalle, .Value, csText
        Case K_CALLENUMERO
          fields.Add2 cscCliCallenumero, .Value, csText
        Case K_PISO
          fields.Add2 cscCliPiso, .Value, csText
        Case K_DEPTO
          fields.Add2 cscCliDepto, .Value, csText
        Case K_TEL
          fields.Add2 cscCliTel, .Value, csText
        Case K_EMAIL
          fields.Add2 cscCliEmail, .Value, csText
        Case K_PRO_ID
          fields.Add2 cscProId, .HelpId, csId
        Case K_ZON_ID
          fields.Add2 cscZonId, .HelpId, csId
        Case K_DESCRIP
          fields.Add2 cscCliDescrip, .Value, csText
        Case K_ACTIVO
          fields.Add2 cscActivo, .Value, csBoolean
        Case K_ESPROSPECTO
          fields.Add2 cscCliEsProspecto, .Value, csBoolean
        Case K_CONTACTO
          fields.Add2 cscCliContacto, .Value, csText
      
        Case K_CPA_ID
          fields.Add2 cscCpaId, .HelpId, csId
        Case K_HORARIO_M_DESDE
          fields.Add2 cscCliHorarioMdesde, .Value, csDate
        Case K_HORARIO_M_HASTA
          fields.Add2 cscCliHorarioMhasta, .Value, csDate
        Case K_HORARIO_T_DESDE
          fields.Add2 cscCliHorarioTdesde, .Value, csDate
        Case K_HORARIO_T_HASTA
          fields.Add2 cscCliHorarioThasta, .Value, csDate
      
      End Select
    End With
  Next
  
  fields.Add2 cscCpgId, m_ventaConfig.CpgIdClientePV, csId
  fields.Add2 cscLpId, m_ventaConfig.LpIdClientePV, csId
  
  fields.HaveLastUpdate = True
  fields.HaveWhoModify = True
  
  If Not gDB.SaveEx(register, , _
                    cscCliCodigo, _
                    C_ABMClientSave, _
                    C_Module, _
                    c_ErrorSave) Then Exit Function
  
  pSaveItemsEmpresa register.Id
  
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
  cIABMClient_Title = LNGGetText(1303, vbNullString)  'Clientes
End Property

Private Function cIABMClient_Validate() As Boolean

  Dim IProperty     As cIABMProperty
  Dim Nombre        As String
  
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_NOMBRE
          If ValEmpty(.Value, csText) Then
            MsgInfo C_DebeIndicarNombre
            Exit Function
          End If
          Nombre = .Value
        Case K_CODIGO
          If ValEmpty(.Value, csText) Then
            .Value = c_get_codigo_from_id
          End If
        Case K_RAZONSOCIAL
          If ValEmpty(.Value, csText) Then
            .Value = Nombre
          End If
        Case K_CATFISCAL
          If ValEmpty(.ListItemData, csInteger) Then
            MsgInfo LNGGetText(1174, vbNullString)
                    'Debe indicar un categoria fiscal
            Exit Function
          End If
      End Select
    End With
  Next
  
  If Not pValidateCuitCliente(Trim(m_ObjAbm.Properties.Item(cscCliCuit).Value)) Then Exit Function
  
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
  cIEditGeneric_ShowList = False
End Function

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

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Id = csNO_ID Then
    m_IsNew = True
    If Not SecurityCanAccess(csPreGNewCliente) Then Exit Function
  Else
    Exit Function
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
  
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  AbmObj.MinHeight = 9500
  
  m_ObjAbm.Title2 = m_Nombre
  
  With m_ObjAbm.Properties
    
    .Clear
    
    With .Add(Nothing, cscCliNombre)
      .PropertyType = cspText
      .name = C_strNombre
      .Size = 255
      .Width = 6100
      .Key = K_NOMBRE
      .Value = m_Nombre
    End With
    
    With .Add(Nothing, cscCliRazonsocial)
      .PropertyType = cspText
      .name = LNGGetText(1178, vbNullString) 'Razon Social
      .Width = 6100
      .Size = 255
      .Key = K_RAZONSOCIAL
      .Value = m_Razonsocial
    End With
    
    With .Add(Nothing, cscCliCodigo)
      .PropertyType = cspText
      .name = C_strCodigo
      .Size = 10
      .Key = K_CODIGO
      .Value = m_Codigo
    End With
         
    With .Add(Nothing, cscActivo)
      .PropertyType = cspCheck
      .name = C_strActivo
      .Key = K_ACTIVO
      .Value = CInt(m_Activo)
      .TopNotChange = True
      .LeftNotChange = True
      .TopFromProperty = cscCliCodigo
      .Left = 5000
      .LeftLabel = -900
    End With
    
    With .Add(Nothing, cscCliCatfiscal)
      .PropertyType = cspList
      .name = LNGGetText(1181, vbNullString) 'Categoria Fiscal
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
    
    With .Add(Nothing, cscCliCuit)
      .PropertyType = cspText
      .name = LNGGetText(1179, vbNullString) 'Cuit
      .Size = 13
      .Key = K_CUIT
      .Value = m_Cuit
    End With
  
    With .Add(Nothing, cscCliCalle)
      .PropertyType = cspText
      .name = LNGGetText(1194, vbNullString) 'Calle
      .Key = K_CALLE
      .Value = m_Calle
      .Width = 7000
    End With
    
    With .Add(Nothing, cscCliCallenumero)
      .PropertyType = cspText
      .name = LNGGetText(1065, vbNullString) 'Numero
      .Size = 10
      .Key = K_CALLENUMERO
      .Value = m_Callenumero
      .Width = 1200
    End With
    
    With .Add(Nothing, cscCliPiso)
      .PropertyType = cspText
      .name = LNGGetText(1196, vbNullString) 'Piso
      .Size = 4
      .Key = K_PISO
      .Value = m_Piso
      .Width = 1200
    End With
    
    With .Add(Nothing, cscCliDepto)
      .PropertyType = cspText
      .name = LNGGetText(1278, vbNullString) 'Departamento
      .Size = 4
      .Key = K_DEPTO
      .Value = m_Depto
      .Width = 1200
    End With
    
    With .Add(Nothing, cscCliCodpostal)
      .PropertyType = cspText
      .name = LNGGetText(1199, vbNullString) 'Codigo Postal
      .Size = 20
      .Key = K_CODPOSTAL
      .Value = m_Codpostal
      .Width = 1200
    End With
    
    With .Add(Nothing, cscCliLocalidad)
      .PropertyType = cspText
      .name = LNGGetText(1198, vbNullString) 'Localidad
      .Size = 100
      .Key = K_LOCALIDAD
      .Value = m_Localidad
      .Width = 5000
    End With
    
    With .Add(Nothing, cscProId)
      .PropertyType = cspHelp
      .Table = csProvincia
      .name = LNGGetText(1080, vbNullString) 'Provincia
      .Key = K_PRO_ID
      .Value = m_Provincia
      .HelpId = m_pro_id
      .Width = 5000
    End With
      
    With .Add(Nothing, cscZonId)
      .PropertyType = cspHelp
      .Table = csZona
      .name = LNGGetText(1402, vbNullString) 'Zona
      .Key = K_ZON_ID
      .Value = m_Zona
      .HelpId = m_zon_id
    End With
          
    With .Add(Nothing, cscCliTel)
      .PropertyType = cspText
      .name = LNGGetText(1036, vbNullString) 'Teléfono
      .Size = 100
      .Key = K_TEL
      .Value = m_Tel
      .Width = 4350
      .TopFromProperty = cscCliCallenumero
      .Left = 4200
      .LeftLabel = -900
    End With
        
    With .Add(Nothing, cscCliEmail)
      .PropertyType = cspText
      .name = LNGGetText(1034, vbNullString) 'E-Mail
      .Size = 100
      .Key = K_EMAIL
      .Value = m_Email
      .Width = 4350
    End With
          
    With .Add(Nothing, cscCliContacto)
      .PropertyType = cspText
      .name = LNGGetText(1035, vbNullString) 'Contacto
      .Size = 100
      .Key = K_CONTACTO
      .Value = m_Contacto
    End With
          
    With .Add(Nothing, cscCliEsProspecto)
      .PropertyType = cspCheck
      .name = LNGGetText(3952, vbNullString) ' Es un prospecto
      .Key = K_ESPROSPECTO
      .Value = CInt(m_EsProspecto)
      .LeftNotChange = True
      .LeftToPrevious = 1500
      .LeftLabel = -1500
    End With
          
'-----------------------------------------------------------------

      With .Add(Nothing, cscCpaId)
        .PropertyType = cspHelp
        .Table = csCodigoPostal
        .name = LNGGetText(4964, vbNullString) 'CPA
        .Key = K_CPA_ID
        .Value = m_CpaNombre
        .HelpId = m_cpa_id
        .Width = 1200
        .TopFromProperty = cscZonId
        .TopToPrevious = 440
        .LeftFromProperty = cscZonId
      End With
      
      With .Add(Nothing, cscCliHorarioMdesde)
        .PropertyType = cspTime
        .name = LNGGetText(4965, vbNullString) ' Horario desde
        .Value = m_horario_m_desde
        .Key = K_HORARIO_M_DESDE
        .TopFromProperty = cscCpaId
        .Left = 4500
        .LeftLabel = -1100
        .LeftNotChange = True
      End With
      
      With .Add(Nothing, cscCliHorarioMhasta)
        .PropertyType = cspTime
        .name = LNGGetText(4966, vbNullString) ' Hasta
        .Value = m_horario_m_hasta
        .Key = K_HORARIO_M_HASTA
        .TopFromProperty = cscCpaId
        .Left = 6100
        .LeftLabel = -500
        .LeftNotChange = True
        .TopNotChange = True
      End With
      
      With .Add(Nothing, cscCliHorarioTdesde)
        .PropertyType = cspTime
        .name = LNGGetText(4967, vbNullString) ' Desde
        .Value = m_horario_t_desde
        .Key = K_HORARIO_T_DESDE
        .TopFromProperty = cscCpaId
        .Left = 7700
        .LeftLabel = -500
        .LeftNotChange = True
        .TopNotChange = True
      End With
      
      With .Add(Nothing, cscCliHorarioThasta)
        .PropertyType = cspTime
        .name = LNGGetText(4966, vbNullString) ' Hasta
        .Value = m_horario_t_hasta
        .Key = K_HORARIO_T_HASTA
        .TopFromProperty = cscCpaId
        .Left = 9200
        .LeftLabel = -500
        .LeftNotChange = True
        .TopNotChange = True
      End With
          
'-----------------------------------------------------------------

    With .Add(Nothing, cscCliDescrip)
      .PropertyType = cspText
      .name = C_strDescrip
      .SubType = cspMemo
      .Width = 6250
      .Height = 660
      .Size = 255
      .Key = K_DESCRIP
      .Value = m_descrip
      .TopFromProperty = cscCpaId
      .TopToPrevious = 440
      .LeftFromProperty = cscCliCodigo
    End With
    
  End With
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

Private Function Load(ByVal Id As Long) As Boolean

  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset

  sqlstmt = "sp_clienteGet " & Id

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If Not rs.EOF Then
  
    m_Id = gDB.ValField(rs.fields, cscCliId)
    m_Nombre = gDB.ValField(rs.fields, cscCliNombre)
    m_Codigo = gDB.ValField(rs.fields, cscCliCodigo)
    m_Razonsocial = gDB.ValField(rs.fields, cscCliRazonsocial)
    m_Cuit = gDB.ValField(rs.fields, cscCliCuit)
    m_CatFiscal = gDB.ValField(rs.fields, cscCliCatfiscal)
    m_Codpostal = gDB.ValField(rs.fields, cscCliCodpostal)
    m_Localidad = gDB.ValField(rs.fields, cscCliLocalidad)
    m_Calle = gDB.ValField(rs.fields, cscCliCalle)
    m_Callenumero = gDB.ValField(rs.fields, cscCliCallenumero)
    m_Piso = gDB.ValField(rs.fields, cscCliPiso)
    m_Depto = gDB.ValField(rs.fields, cscCliDepto)
    m_Tel = gDB.ValField(rs.fields, cscCliTel)
    m_Email = gDB.ValField(rs.fields, cscCliEmail)
    m_pro_id = gDB.ValField(rs.fields, cscProId)
    m_zon_id = gDB.ValField(rs.fields, cscZonId)
    m_Provincia = gDB.ValField(rs.fields, cscProNombre)
    m_Zona = gDB.ValField(rs.fields, cscZonNombre)
    m_descrip = gDB.ValField(rs.fields, cscCliDescrip)
    m_Contacto = gDB.ValField(rs.fields, cscCliContacto)
    m_EsProspecto = gDB.ValField(rs.fields, cscCliEsProspecto)
    
    m_CpaNombre = gDB.ValField(rs.fields, cscCpaCodigo)
    m_cpa_id = gDB.ValField(rs.fields, cscCpaId)
    
    m_horario_m_desde = gDB.ValField(rs.fields, cscCliHorarioMdesde)
    m_horario_m_hasta = gDB.ValField(rs.fields, cscCliHorarioMhasta)
    m_horario_t_desde = gDB.ValField(rs.fields, cscCliHorarioTdesde)
    m_horario_t_hasta = gDB.ValField(rs.fields, cscCliHorarioThasta)
    
    m_Activo = gDB.ValField(rs.fields, cscActivo)
  
  Else

    m_Id = csNO_ID
    m_Nombre = vbNullString
    m_Codigo = vbNullString
    m_Razonsocial = m_ventaConfig.RazonSocialClientePV
    m_Cuit = "CUIT"
    m_descrip = vbNullString
    m_CatFiscal = IIf(m_ventaConfig.CatFiscalClientePV, _
                      m_ventaConfig.CatFiscalClientePV, _
                      csCatFConsumidorFinal)
    m_Codpostal = vbNullString
    m_Localidad = vbNullString
    m_Calle = vbNullString
    m_Callenumero = vbNullString
    m_Piso = vbNullString
    m_Depto = vbNullString
    m_Tel = vbNullString
    m_Email = vbNullString
    m_pro_id = m_ventaConfig.ProIdClientePV
    m_Provincia = m_ventaConfig.ProvinciaClientePV
    m_zon_id = m_ventaConfig.ZonIdClientePV
    m_Zona = m_ventaConfig.ZonaClientePV
    m_Contacto = vbNullString
    m_EsProspecto = False
    
    m_CpaNombre = vbNullString
    m_cpa_id = csNO_ID
    
    m_horario_m_desde = csNoDate
    m_horario_m_hasta = csNoDate
    m_horario_t_desde = csNoDate
    m_horario_t_hasta = csNoDate
    
    m_Activo = True

  End If

  Load = True

End Function

' Esta funcion esta practicamente copiada en cClientePV
' si detectan un bug, por favor vean dicha funcion
'
Private Function pValidateCuitCliente(ByVal Cuit As String) As Boolean
  On Error GoTo ControlError

  Dim sqlstmt  As String
  Dim rs       As Recordset
  
  Dim PublicDoc As cPublicDoc
  Set PublicDoc = New cPublicDoc
  
  If LenB(Cuit) Then
  
    If Not PublicDoc.ValidateNroCuit(Cuit, False) Then Exit Function
  
    sqlstmt = "sp_ClienteValidateCuit " & gDB.sqlString(Cuit)
  
    If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
    
    If Not rs.EOF Then
    
      Dim cli_id As Long
      
      If Not m_Copy Then
        cli_id = m_Id
      End If
    
      If cli_id <> gDB.ValField(rs.fields, cscCliId) Then
       ' If Not Ask("El CUIT ya esta usado por el cliente " & _
                  gDB.ValField(rs.fields, cscCliRazonsocial) & _
                  ";;¿Confirma que desea grabar este cliente con el mismo CUIT?", vbNo) Then
        If Not Ask(LNGGetText(1527, vbNullString, _
                              gDB.ValField(rs.fields, cscCliRazonsocial)), _
                   vbNo) Then
          Exit Function
        End If
      End If
    End If
  Else
    
    Dim bAsk As Boolean
    Dim msg  As String
    
    Select Case m_ObjAbm.Properties.Item(cscCliCatfiscal).ListItemData
      Case csCatFConsumidorFinal
        bAsk = False
      Case csCatFInscripto, csCatFExento, csCatFExtranjero, csCatFMonoTributo, _
           csCatFExtranjeroIva, csCatFNoResponsable, csCatFNoResponsableExento, _
           csCatFNoCategorizado, csCatFInscriptoM
        bAsk = True
      Case Else
        bAsk = True
    End Select
    
    If bAsk Then
      'msg = "Para poder guardar un cliente con esta categoría fiscal " & _
            "deben indicar un número de CUIT. Si guarda sin el CUIT el " & _
            "cliente quedará inactivo."
      msg = LNGGetText(1528, vbNullString)
      
      'If Not Ask(msg & vbCrLf & vbCrLf & "¿Desea guardar los cambios de todas formas?", vbYes) Then
      If Not Ask(msg & vbCrLf & vbCrLf & LNGGetText(1529, vbNullString), vbYes) Then
      
        Exit Function
      Else
        With m_ObjAbm.Properties
          .Item(cscActivo).Value = 0
          m_ObjAbm.ShowValue .Item(cscActivo)
        End With
      End If
    End If
    
  End If
     
  pValidateCuitCliente = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "pValidateCuitCliente", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pSaveItemsEmpresa(ByVal cli_id As Long) As Boolean
  Dim register  As cRegister
  Dim fields    As cFields

  Set register = New cRegister
  
  With register
    Set fields = .fields
    .fieldId = cscEmpCliId
    .Table = csTEmpresaCliente
    .Id = csNew
    
    fields.Add2 cscEmpId, EmpId, csId
    fields.Add2 cscCliId, cli_id, csId
    
    fields.HaveLastUpdate = True
    fields.HaveWhoModify = True
  End With
                                                              
  If Not gDB.Save(register, , "pSaveItemsEmpresa", C_Module, c_ErrorSave) Then Exit Function
  
  pSaveItemsEmpresa = True
End Function

Private Sub Class_Initialize()
  On Error Resume Next
  c_ErrorSave = LNGGetText(1537, vbNullString) ' Error al grabar el cliente
  Set m_ventaConfig = New cVentaConfig
  m_ventaConfig.Load
End Sub

' construccion - destruccion
Private Sub Class_Terminate()
  On Error Resume Next
  Set m_ObjAbm = Nothing
  Set m_ObjTree = Nothing
  Set m_ventaConfig = Nothing
End Sub

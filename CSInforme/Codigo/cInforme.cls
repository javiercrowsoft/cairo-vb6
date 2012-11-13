VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cInforme"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGeneric
Implements CSInterfacesABM.cIABMClient
Implements CSMenu.cIMenuClient
Implements CSInterfacesABM.cIABMClientGrid
'--------------------------------------------------------------------------------
' cInforme
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
Private Const C_Module = "cInforme"

Private Const C_Params = "Parametros"
Private Const C_Orders = "Orders"
Private Const C_Groups = "Groups"
Private Const C_Hiperlinks = "Hiperlinks"
Private Const c_Sumaries = "Sumaries"

Private Const K_NOMBRE                         As Integer = 1
Private Const K_CODIGO                         As Integer = 2
Private Const K_DESCRIP                        As Integer = 3
Private Const K_STOREDPROCEDURE                As Integer = 4
Private Const K_REPORTE                        As Integer = 5
Private Const K_PRESENTACIONDEFAULT            As Integer = 6
Private Const K_MODULO                         As Integer = 7
Private Const K_TIPO                           As Integer = 8
Private Const K_PROPIETARIO                    As Integer = 9

Private Const K_COLOCULTAS                     As Integer = 10
Private Const K_CHECKBOX                       As Integer = 11
Private Const K_TOTALESGRALES                  As Integer = 12
Private Const K_CONNSTR                        As Integer = 13

Private Const K_ACTIVO                         As Integer = 14

Private Const K_PARAMETROS                     As Integer = 15

Private Const K_SUMARIES                       As Integer = 16
Private Const K_ORDERS                         As Integer = 17
Private Const K_GROUPS                         As Integer = 18
Private Const K_HIPERLINKS                     As Integer = 19

Private Const KI_INFP_ID                        As Integer = 1
Private Const KI_NOMBRE                         As Integer = 2
Private Const KI_ORDEN                          As Integer = 3
Private Const KI_TIPO                           As Integer = 4
Private Const KI_DEFAULT                        As Integer = 5
Private Const KI_VISIBLE                        As Integer = 6
Private Const KI_SQLSTMT                        As Integer = 7
Private Const KI_TBL_ID                         As Integer = 9

Private Const KIO_INFO_ID                        As Integer = 1
Private Const KIO_NOMBRE                         As Integer = 2

Private Const KIG_INFG_ID                        As Integer = 1
Private Const KIG_NOMBRE                         As Integer = 2
Private Const KIG_DEFAULT                        As Integer = 3

Private Const KIS_INFS_ID                        As Integer = 1
Private Const KIS_NOMBRE                         As Integer = 2
Private Const KIS_OPERATION                      As Integer = 3

Private Const KIH_INFH_ID                        As Integer = 1
Private Const KIH_NOMBRE                         As Integer = 2
Private Const KIH_URL                            As Integer = 3
Private Const KIH_COLUMNA                        As Integer = 4

' estructuras
' Seudo Variables
Private c_ErrorSave                    As String

' variables privadas
Private m_Id                           As Long
Private m_Nombre                       As String
Private m_Codigo                       As String
Private m_Descrip                      As String
Private m_Storedprocedure              As String
Private m_Reporte                      As String
Private m_Presentaciondefault          As Integer
Private m_Modulo                       As String
Private m_Tipo                         As Integer
Private m_Propietario                  As Integer
Private m_Creado                       As Date
Private m_Modificado                   As Date
Private m_Modifico                     As Long
Private m_TotalesGrales                As Boolean
Private m_CheckBox                     As String
Private m_Connstr                      As String
Private m_ColOcultas                   As Long
Private m_Activo                       As Boolean
Private m_pre_id                       As Long
'OJO HASTA ACA

Private m_Editing           As Boolean

Private m_ObjAbm            As cIABMGeneric
Private m_ObjTree           As Object

Private m_IsNew             As Boolean

Private m_BranchId          As Long
Private m_TreeId            As Long
Private m_Host              As CSMenu.cIMenuHost
Private m_Copy              As Boolean

Private m_ItemsDeletedParametros            As String
Private m_ItemsDeletedOrders                As String
Private m_ItemsDeletedGroups                As String
Private m_ItemsDeletedSumaries              As String
Private m_ItemsDeletedHiperlinks            As String

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

Public Property Get Descrip() As String
  Descrip = m_Descrip
End Property

Public Property Let Descrip(ByVal rhs As String)
  m_Descrip = rhs
End Property

Public Property Get Storedprocedure() As String
  Storedprocedure = m_Storedprocedure
End Property

Public Property Let Storedprocedure(ByVal rhs As String)
  m_Storedprocedure = rhs
End Property

Public Property Get Reporte() As String
  Reporte = m_Reporte
End Property

Public Property Let Reporte(ByVal rhs As String)
  m_Reporte = rhs
End Property

Public Property Get Presentaciondefault() As Integer
  Presentaciondefault = m_Presentaciondefault
End Property

Public Property Let Presentaciondefault(ByVal rhs As Integer)
  m_Presentaciondefault = rhs
End Property

Public Property Get Modulo() As String
  Modulo = m_Modulo
End Property

Public Property Let Modulo(ByVal rhs As String)
  m_Modulo = rhs
End Property

Public Property Get Tipo() As Integer
  Tipo = m_Tipo
End Property

Public Property Let Tipo(ByVal rhs As Integer)
  m_Tipo = rhs
End Property

Public Property Get Propietario() As Integer
  Propietario = m_Propietario
End Property

Public Property Let Propietario(ByVal rhs As Integer)
  m_Propietario = rhs
End Property

Public Property Get Creado() As Date
  Creado = m_Creado
End Property

Public Property Let Creado(ByVal rhs As Date)
  m_Creado = rhs
End Property

Public Property Get Modificado() As Date
  Modificado = m_Modificado
End Property

Public Property Let Modificado(ByVal rhs As Date)
  m_Modificado = rhs
End Property

Public Property Get Modifico() As Long
  Modifico = m_Modifico
End Property

Public Property Let Modifico(ByVal rhs As Long)
  m_Modifico = rhs
End Property

Public Property Get Activo() As Boolean
  Activo = m_Activo
End Property

Public Property Let Activo(ByVal rhs As Boolean)
  m_Activo = rhs
End Property
' Properties privadas
' funciones publicas

' Implementacion de cIABMClientGrid
Private Function cIABMClientGrid_ColumnAfterEdit(ByVal key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long) As Boolean
  cIABMClientGrid_ColumnAfterEdit = True
End Function

Private Function cIABMClientGrid_ColumnAfterUpdate(ByVal key As Integer, ByVal lRow As Long, ByVal lCol As Long) As Boolean
  cIABMClientGrid_ColumnAfterUpdate = True
End Function

Private Function cIABMClientGrid_ColumnBeforeEdit(ByVal key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean
  cIABMClientGrid_ColumnBeforeEdit = True
End Function

Private Function cIABMClientGrid_ColumnButtonClick(ByVal key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean

End Function

Private Sub cIABMClientGrid_ColumnCancelEdit(ByVal key As Integer)

End Sub

Private Sub cIABMClientGrid_ColumnClick(ByVal key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Sub cIABMClientGrid_DblClick(ByVal key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Function cIABMClientGrid_DeleteRow(ByVal key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal lRow As Long) As Boolean
  Dim Id As Long
  
  Select Case key
    Case K_PARAMETROS
      Id = Val(pCell(Row, KI_INFP_ID).Value)
      If Id <> csNO_ID Then m_ItemsDeletedParametros = m_ItemsDeletedParametros & Id & ","
    Case K_ORDERS
      Id = Val(pCell(Row, KIO_INFO_ID).Value)
      If Id <> csNO_ID Then m_ItemsDeletedOrders = m_ItemsDeletedOrders & Id & ","
    Case K_GROUPS
      Id = Val(pCell(Row, KIG_INFG_ID).Value)
      If Id <> csNO_ID Then m_ItemsDeletedGroups = m_ItemsDeletedGroups & Id & ","
    Case K_SUMARIES
      Id = Val(pCell(Row, KIS_INFS_ID).Value)
      If Id <> csNO_ID Then m_ItemsDeletedSumaries = m_ItemsDeletedSumaries & Id & ","
    Case K_HIPERLINKS
      Id = Val(pCell(Row, KIH_INFH_ID).Value)
      If Id <> csNO_ID Then m_ItemsDeletedHiperlinks = m_ItemsDeletedHiperlinks & Id & ","
  End Select
  
  cIABMClientGrid_DeleteRow = True
End Function

Private Function cIABMClientGrid_IsEmptyRow(ByVal key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case key
    Case K_PARAMETROS
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowParametros(Row, RowIndex)
    Case K_SUMARIES
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowSumaries(Row, RowIndex)
    Case K_ORDERS
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowOrders(Row, RowIndex)
    Case K_GROUPS
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowGroups(Row, RowIndex)
    Case K_HIPERLINKS
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowHiperlinks(Row, RowIndex)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ValidateRow", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIABMClientGrid_ListAdHock(ByVal key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal ColIndex As Long, List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClientGrid_NewRow(ByVal key As Integer, ByVal Rows As Integer)

End Sub

Private Function cIABMClientGrid_ValidateRow(ByVal key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case key
    Case K_PARAMETROS
      cIABMClientGrid_ValidateRow = pValidateRowParametros(Row, RowIndex)
    Case K_SUMARIES
      cIABMClientGrid_ValidateRow = pValidateRowSumaries(Row, RowIndex)
    Case K_ORDERS
      cIABMClientGrid_ValidateRow = pValidateRowOrders(Row, RowIndex)
    Case K_GROUPS
      cIABMClientGrid_ValidateRow = pValidateRowGroups(Row, RowIndex)
    Case K_HIPERLINKS
      cIABMClientGrid_ValidateRow = pValidateRowHiperlinks(Row, RowIndex)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ValidateRow", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

' Implementacion de cIABMClient
Private Function cIABMClient_Copy() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True
  
  With m_ObjAbm.Properties(cscInfCodigo)
    .Value = "C-" & .Value
  End With
  
  With m_ObjAbm.Properties(cscInfNombre)
    .Value = "Copia de " & .Value
  End With
  
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscInfCodigo)
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscInfNombre)
  
  m_Copy = True
End Function

Private Function cIABMClient_EditNew() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True
  
  If Not pValidateAccessNewEdit(csNO_ID) Then Exit Function
  
  Load csNO_ID
  pRefreshProperties
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

  Doc.ClientTable = csTInforme
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
  
  Select Case MessageID
  
    Case MSG_DOC_INFO
    
      Dim AbmGen As cABMGeneric
      Set AbmGen = m_ObjAbm
      
      CSKernelClient2.ShowHelp AbmGen.hWnd, _
                               vbNullString, _
                               vbNullString, _
                               csPreINewInforme
      cIABMClient_MessageEx = MSG_DOC_INFO_HANDLED
    
    Case MSG_DOC_REFRESH
      pRefreshProperties
  
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

Private Function cIABMClient_PropertyChange(ByVal key As Integer) As Boolean
  Dim Modulo
  Select Case key
    Case K_MODULO
      With m_ObjAbm.Properties(cscInfModulo)
        If .ListItemData = -1 Then
          If GetInput(Modulo, LNGGetText(2697, vbNullString)) Then
                            'Ingrese el nombre del módulo
                            ' TODO VER CON JAVIER
            If Not ValEmpty(Modulo, csText) Then
              With .List.Add(Nothing)
                .Value = Modulo
              End With
              .ListText = Modulo
            End If
            m_ObjAbm.ShowValue m_ObjAbm.Properties(cscInfModulo)
          End If
        End If
      End With
  End Select
End Function

Private Function cIABMClient_Save() As Boolean
  Dim register        As cRegister
  Dim LastId          As Long
  Dim Codigo          As String
  Dim PreId           As Long
  Dim Nombre          As String
  Dim Modulo          As String
  
  Set register = New cRegister
  register.fieldId = cscInfId
  register.Table = csTInforme

  If m_Copy Then
    register.Id = csNew
    PreId = csNew
  Else
    register.Id = m_Id
    PreId = m_pre_id
  End If

  Dim IProperty As cIABMProperty
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .key
        Case K_NOMBRE
          Nombre = .Value
          register.Fields.Add2 cscInfNombre, Nombre, csText
        Case K_CODIGO
          Codigo = UCase(.Value)
          register.Fields.Add2 cscInfCodigo, Codigo, csText
        Case K_DESCRIP
          register.Fields.Add2 cscInfDescrip, .Value, csText
        Case K_STOREDPROCEDURE
          register.Fields.Add2 cscInfStoredprocedure, .Value, csText
        Case K_REPORTE
          register.Fields.Add2 cscInfReporte, .Value, csText
        Case K_PRESENTACIONDEFAULT
          register.Fields.Add2 cscInfPresentaciondefault, .ListItemData, csInteger
        Case K_MODULO
          Modulo = .ListText
          register.Fields.Add2 cscInfModulo, Modulo, csText
        Case K_TIPO
          register.Fields.Add2 cscInfTipo, .ListItemData, csInteger
        Case K_TOTALESGRALES
          register.Fields.Add2 cscInfTotalesGrales, .Value, csBoolean
        Case K_PROPIETARIO
          register.Fields.Add2 cscInfPropietario, .ListItemData, csInteger
        Case K_CONNSTR
          register.Fields.Add2 cscInfConnstr, .Value, csText
        Case K_CHECKBOX
          register.Fields.Add2 cscInfCheckBox, .Value, csText
        Case K_COLOCULTAS
          register.Fields.Add2 cscInfColOcultas, .Value, csInteger
        Case K_ACTIVO
          register.Fields.Add2 cscActivo, .Value, csBoolean
      End Select
    End With
  Next
  
  register.Fields.HaveLastUpdate = True
  register.Fields.HaveWhoModify = True
  
  If Not register.BeginTrans(gDB) Then Exit Function
  
  LastId = m_Id
  
  If Not pSavePrestacion(Codigo, PreId, Nombre, Modulo) Then GoTo SaveError
  
  register.Fields.Add2 cscPreID, PreId, csId

  If Not gDB.Save(register, , "cIABMClient_Save", C_Module, c_ErrorSave) Then GoTo SaveError
  
  m_Id = register.Id
  
  If Not pSaveItemsParametros() Then GoTo SaveError
  If Not pSaveItemsGroups() Then GoTo SaveError
  If Not pSaveItemsHiperlinks() Then GoTo SaveError
  If Not pSaveItemsOrders() Then GoTo SaveError
  If Not pSaveItemsSumaries() Then GoTo SaveError
  
  If Not register.CommitTrans() Then GoTo SaveError
  
  m_Copy = False
  cIABMClient_Save = Load(register.Id)
  
  Exit Function
SaveError:
  m_Id = LastId
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
    cIABMClient_Title = LNGGetText(2698, vbNullString)  'Informes
End Property

Private Function cIABMClient_Validate() As Boolean
  Dim IProperty As cIABMProperty
  Dim msg     As String
  
  msg = LNGGetText(2942, vbNullString)
  'Las dos primeras letra deben ser:" & vbCrLf & _
   DC para desarrollo de Cairo" & vbCrLf & _
   DT para desarrollo de Terceros" & vbCrLf & _
   IC para implementación de Cairo" & vbCrLf & _
   IT para implementación de Terceros" & vbCrLf & _
   CL para Clientes" & vbCrLf & _
   Luego un guión bajo como separador seguido de tres letras que identifican al proyecto donde Cairo es el proyecto CSC (las tres letras salen del nombre del cliente en cada proyecto usándose las primeras 3 consonantes ejemplo Benito Rogio Construcciones seria BRC, Clements CLM) & _
   Luego un guión bajo como separador seguido por tres letras que identifican el módulo al que pertenece el informe. Ejemplo un reporte de contabilidad llevará CON, uno de compras COM y uno de ventas VEN" & vbCrLf & _
   Luego otro guión bajo como separador y cuatro digitos donde se deberá usar rangos de 10 para separar los reportes y solo se deberán usar las unidades cuando se trate de versiones muy similares de informes." & vbCrLf & _
   Por ejemplo un reporte desarrollado por desarrollo de Cairo que pertenece al módulo de ventas llevará el código DC_CSC_VEN_0010." & vbCrLf & _


  CSKernelClient2.Title = LNGGetText(1521, vbNullString)  'Informe

  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .key
        Case K_NOMBRE
          If ValEmpty(.Value, csText) Then
            MsgInfo LNGGetText(1007, vbNullString)  'Debe indicar un nombre
            Exit Function
          End If
        Case K_CODIGO
          If ValEmpty(.Value, csText) Then
            MsgInfo LNGGetText(1008, vbNullString)  'Debe indicar un código
            Exit Function
          Else
            Select Case UCase(Mid(.Value, 1, 2))
              Case "DC", "DT", "IT", "CL", "IC"
              Case Else
                MsgInfo LNGGetText(2943, vbNullString, msg)
                        'El código debe cumplir con el estandar:; & msg
                Exit Function
            End Select
          End If
'        Case K_DESCRIP
'          If ValEmpty(.Value, csText) Then
'            MsgInfo "Debe indicar un descrip"
'            Exit Function
'          End If
        Case K_STOREDPROCEDURE
          If ValEmpty(.Value, csText) Then
            MsgInfo LNGGetText(2699, vbNullString)  'Debe indicar un Stored Procedure
            Exit Function
          End If
'        Case K_REPORTE
'          If ValEmpty(.Value, csText) Then
'            MsgInfo "Debe indicar un reporte"
'            Exit Function
'          End If
        Case K_PRESENTACIONDEFAULT
          If ValEmpty(.ListItemData, csInteger) Then
            MsgInfo LNGGetText(2701, vbNullString) 'Debe indicar un presentación default
            Exit Function
          End If
        Case K_MODULO
          If ValEmpty(.ListText, csText) Then
            MsgInfo LNGGetText(2700, vbNullString) 'Debe indicar un Módulo
            Exit Function
          End If
        Case K_TIPO
          If ValEmpty(.ListItemData, csInteger) Then
            MsgInfo LNGGetText(1222, vbNullString) 'Debe indicar un tipo
            Exit Function
          End If
        Case K_PROPIETARIO
          If ValEmpty(.ListItemData, csInteger) Then
            MsgInfo LNGGetText(2702, vbNullString) 'Debe indicar un Propietario
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
    cIEditGeneric_ShowList = SecurityCanAccess(csPreIListInforme)
End Function

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
    Set m_ObjAbm = rhs
End Property

Private Property Get cIEditGeneric_Editing() As Boolean
    cIEditGeneric_Editing = m_Editing
End Property

Private Function cIEditGeneric_Delete(Id As Long) As Boolean
    If Not SecurityCanAccess(csPreIDeleteInforme) Then Exit Function

    Dim sqlstmt As String
    sqlstmt = "sp_InformeDelete " & Id
    
    cIEditGeneric_Delete = gDB.Execute(sqlstmt, "cIEditGeneric_Delete", C_Module)
End Function

Private Function cIEditGeneric_Search(Id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Not pValidateAccessNewEdit(Id) Then Exit Function
  
  ' JMA I
  m_ObjAbm.InModalWindow = InModalWindow
' JMA F
  
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
  MngError Err, "cIEditGeneric_Edit", C_Module, vbNullString
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

Private Function cIEditGeneric_PropertyChange(ByVal key As Integer) As Boolean

End Function

Private Function cIMenuClient_Initialize(F As Object, Host As CSMenu.cIMenuHost) As Boolean
  On Error GoTo ControlError
  Dim str_2703  As String
  
  str_2703 = LNGGetText(2703, vbNullString)   'S&istema
  Set m_Host = Host
  m_Host.Server.AddMenu LNGGetText(2704, vbNullString), csPreIListInforme, str_2703, 0, True, False, False, False, False, Me
                        'In&formes
  m_Host.Server.AddMenu LNGGetText(2705, vbNullString), csPreIListInforme * -1, str_2703, 0, True, False, False, False, False, Me
                        '&Validar Informes y CSR
  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, "cIMenuClient_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal Id As Long) As Variant
  
  If Id = csPreIListInforme Then
    
    m_Host.MenuABMClick "CSInforme2.cInforme", Me, LNGGetText(2698, vbNullString), 0, csTblInforme
                                                    'Informes
  ElseIf Id = csPreIListInforme * -1 Then
  
    Dim Util As cInformeUtil
    Set Util = New cInformeUtil
    
    Util.ValidateInformeParametroCSRs
    
  End If
End Function

' funciones privadas

Private Function pValidateAccessNewEdit(ByVal Id As Long) As Boolean
  If Id = csNO_ID Then
    m_IsNew = True
    If Not SecurityCanAccess(csPreINewInforme) Then Exit Function
  Else
    m_IsNew = False
    If Not SecurityCanAccess(csPreIEditInforme) Then Exit Function
  End If
  pValidateAccessNewEdit = True
End Function

Private Function LoadCollection() As Boolean
  Dim c As cIABMProperty
  
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  AbmObj.bSendRefresh = True
  
  Const c_TabParams = 1
  Const c_TabWeb = 2
  Const c_TabSumaries = 3
  Const c_TabOrders = 4
  Const c_TabGroups = 5
  Const c_TabHiperlinks = 6
  
  With m_ObjAbm
    
    .Properties.Clear
    
    With .Tabs
    
      .Clear
  
      With .Add(Nothing)
        .Index = 0
        .Name = C_strGeneral
      End With
      
      With .Add(Nothing)
        .Index = c_TabParams
        .Name = C_Params
      End With
    
      With .Add(Nothing)
        .Index = c_TabWeb
        .Name = LNGGetText(1038, vbNullString)    'Web
      End With
    
      With .Add(Nothing)
        .Index = c_TabSumaries
        .Name = LNGGetText(2706, vbNullString)    'Sumaries
      End With
    
      With .Add(Nothing)
        .Index = c_TabOrders
        .Name = C_Orders
      End With
    
      With .Add(Nothing)
        .Index = c_TabGroups
        .Name = C_Groups
      End With
    
      With .Add(Nothing)
        .Index = c_TabHiperlinks
        .Name = C_Hiperlinks
      End With
    
    End With
    
    .Title2 = m_Nombre
  
    With .Properties
  
      With .Add(Nothing, cscInfNombre)
        .PropertyType = cspText
        .Name = C_strNombre
        .Size = 50
        .Width = 6800
        .key = K_NOMBRE
        .Value = Nombre
      End With
      
      With .Add(Nothing, cscInfCodigo)
        .PropertyType = cspText
        .Name = C_strCodigo
        .Size = 50
        .key = K_CODIGO
        .Value = Codigo
      End With
      
      With .Add(Nothing, cscInfStoredprocedure)
        .PropertyType = cspText
        .Name = LNGGetText(2707, vbNullString)    'Procedimiento de Almacenado
        .Size = 50
        .key = K_STOREDPROCEDURE
        .Value = Storedprocedure
      End With
      
      With .Add(Nothing, cscInfReporte)
        .PropertyType = cspText
        .Name = LNGGetText(2708, vbNullString)    'Reporte
        .Size = 255
        .key = K_REPORTE
        .Value = Reporte
      End With
      
      Set c = .Add(Nothing, cscInfModulo)
      With c
        .PropertyType = cspList
        pLoadModulos c
        .Name = LNGGetText(2709, vbNullString)    'Módulo
        .Size = 255
        .key = K_MODULO
        .ListWhoSetItem = csListText
        .ListText = m_Modulo
      End With
      
      With .Add(Nothing, cscInfPresentaciondefault)
        .PropertyType = cspList
        .TopFromProperty = cscInfCodigo
        .Left = 6000
        With .List.Add(Nothing)
          .Id = csInfShowDefChart
          .Value = LNGGetText(2712, vbNullString)    'Gráfico
        End With
        With .List.Add(Nothing)
          .Id = csInfShowDefExcel
          .Value = "Excel"
        End With
        With .List.Add(Nothing)
          .Id = csInfShowDefGrid
          .Value = LNGGetText(2711, vbNullString)    'Grilla
        End With
        With .List.Add(Nothing)
          .Id = csInfShowDefHtml
          .Value = "HTML"
        End With
        With .List.Add(Nothing)
          .Id = csInfShowDefReport
          .Value = LNGGetText(2708, vbNullString)    'Reporte
        End With
        With .List.Add(Nothing)
          .Id = csInfShowDefTxt
          .Value = "TXT"
        End With
        With .List.Add(Nothing)
          .Id = csInfShowDefWord
          .Value = "Word"
        End With
        .Name = LNGGetText(2710, vbNullString)    'Presentación por Defecto
        .key = K_PRESENTACIONDEFAULT
        .ListWhoSetItem = csListItemData
        .ListItemData = m_Presentaciondefault
      End With
      
      With .Add(Nothing, cscInfTipo)
        .PropertyType = cspList
        With .List.Add(Nothing)
          .Id = csInfTypeProcess
          .Value = LNGGetText(2713, vbNullString)    'Proceso
        End With
        
        With .List.Add(Nothing)
          .Id = csInfTypeReport
          .Value = LNGGetText(2708, vbNullString)    'Reporte
        End With
        .Name = LNGGetText(1223, vbNullString)    'Tipo
        .key = K_TIPO
        .ListWhoSetItem = csListItemData
        .ListItemData = m_Tipo
      End With
      
      With .Add(Nothing, cscInfPropietario)
        .PropertyType = cspList
        With .List.Add(Nothing)
          .Id = csInfOwnerCairoDevelop
          .Value = LNGGetText(2714, vbNullString)    'Cairo Desarrollo
        End With
        
        With .List.Add(Nothing)
          .Id = csInfOwnerCairoImplement
          .Value = LNGGetText(2715, vbNullString)    'Cairo Implementación
        End With
    
        With .List.Add(Nothing)
          .Id = csInfOwnerCustomers
          .Value = LNGGetText(1303, vbNullString)    'Clientes
        End With
        
        With .List.Add(Nothing)
          .Id = csInfOwnerOthersDevelop
          .Value = LNGGetText(2716, vbNullString)    'Terceros Desarrollo
        End With
      
        With .List.Add(Nothing)
          .Id = csInfOwnerOthersImplement
          .Value = LNGGetText(2717, vbNullString)    'Terceros Implementación
        End With
        .Name = LNGGetText(2718, vbNullString)    'Propietario
        .key = K_PROPIETARIO
        .ListWhoSetItem = csListItemData
        .ListItemData = m_Propietario
      End With
      
      With .Add(Nothing, cscInfTotalesGrales)
        .PropertyType = cspCheck
        .Name = LNGGetText(2719, vbNullString)    'Totales Grales.
        .key = K_TOTALESGRALES
        .Value = CInt(m_TotalesGrales)
        .TabIndex = c_TabWeb
      End With
      
      With .Add(Nothing, cscInfColOcultas)
        .PropertyType = cspNumeric
        .SubType = cspInteger
        .Name = LNGGetText(2720, vbNullString)    'Columnas Ocultas
        .key = K_COLOCULTAS
        .Value = m_ColOcultas
        .TabIndex = c_TabWeb
      End With
      
      With .Add(Nothing, cscInfConnstr)
        .PropertyType = cspText
        .Name = LNGGetText(2721, vbNullString)    'String Connection
        .key = K_CONNSTR
        .Value = m_Connstr
        .TabIndex = c_TabWeb
      End With
      
      With .Add(Nothing, cscInfCheckBox)
        .PropertyType = cspText
        .Name = LNGGetText(2722, vbNullString)    'Columna CheckBox
        .key = K_CHECKBOX
        .Value = m_CheckBox
        .TabIndex = c_TabWeb
      End With
      
      With .Add(Nothing, cscActivo)
        .PropertyType = cspCheck
        .Name = C_strActivo
        .key = K_ACTIVO
        .Value = CInt(m_Activo)
      End With
      
      With .Add(Nothing, cscInfDescrip)
        .PropertyType = cspText
        .SubType = cspMemo
        .Name = C_strDescrip
        .Size = 1000
        .LeftFromProperty = cscInfNombre
        .Width = 6800
        .Height = 700
        .key = K_DESCRIP
        .Value = Descrip
      End With
      
      Set c = .Add(Nothing, C_Params)
      With c
        .PropertyType = cspGrid
        .LeftLabel = -1
        If Not pLoadParametros(c) Then Exit Function
        .Name = C_Params
        .key = K_PARAMETROS
        .TabIndex = c_TabParams
        .GridAdd = True
        .GridEdit = True
        .GridRemove = True
      End With
      
      m_ItemsDeletedParametros = vbNullString
      
      Set c = .Add(Nothing, C_Groups)
      With c
        .PropertyType = cspGrid
        .LeftLabel = -1
        If Not pLoadGroups(c) Then Exit Function
        .Name = C_Groups
        .key = K_GROUPS
        .TabIndex = c_TabGroups
        .GridAdd = True
        .GridEdit = True
        .GridRemove = True
      End With
      
      m_ItemsDeletedGroups = vbNullString
      
      Set c = .Add(Nothing, C_Orders)
      With c
        .PropertyType = cspGrid
        .LeftLabel = -1
        If Not pLoadOrders(c) Then Exit Function
        .Name = C_Orders
        .key = K_ORDERS
        .TabIndex = c_TabOrders
        .GridAdd = True
        .GridEdit = True
        .GridRemove = True
      End With
      
      m_ItemsDeletedOrders = vbNullString
      
      Set c = .Add(Nothing, c_Sumaries)
      With c
        .PropertyType = cspGrid
        .LeftLabel = -1
        If Not pLoadSumaries(c) Then Exit Function
        .Name = c_Sumaries
        .key = K_SUMARIES
        .TabIndex = c_TabSumaries
        .GridAdd = True
        .GridEdit = True
        .GridRemove = True
      End With
      
      m_ItemsDeletedSumaries = vbNullString
      
      Set c = .Add(Nothing, C_Hiperlinks)
      With c
        .PropertyType = cspGrid
        .LeftLabel = -1
        If Not pLoadHiperlinks(c) Then Exit Function
        .Name = C_Hiperlinks
        .key = K_HIPERLINKS
        .TabIndex = c_TabHiperlinks
        .GridAdd = True
        .GridEdit = True
        .GridRemove = True
      End With
      
      m_ItemsDeletedHiperlinks = vbNullString
    
    End With
    
    If Not .Show(Me) Then Exit Function
    
  End With
  
  LoadCollection = True
End Function

Private Sub pLoadModulos(ByRef c As cIABMProperty)
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  sqlstmt = "select distinct inf_modulo from Informe"
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadModulos", C_Module) Then Exit Sub
  
  With c.List.Add(Nothing)
    .Value = "(Nuevo)"
    .Id = -1
  End With
  
  While Not rs.EOF
    With c.List.Add(Nothing)
      .Value = ValField(rs.Fields, "inf_modulo")
    End With
    rs.MoveNext
  Wend
End Sub

Public Function Load(ByVal Id As Long) As Boolean
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  sqlstmt = sqlstmt & "select * from informe where inf_id = " & Id
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.Fields, cscInfId)
    m_Nombre = gDB.ValField(rs.Fields, cscInfNombre)
    m_Codigo = gDB.ValField(rs.Fields, cscInfCodigo)
    m_Descrip = gDB.ValField(rs.Fields, cscInfDescrip)
    m_Storedprocedure = gDB.ValField(rs.Fields, cscInfStoredprocedure)
    m_Reporte = gDB.ValField(rs.Fields, cscInfReporte)
    m_Presentaciondefault = gDB.ValField(rs.Fields, cscInfPresentaciondefault)
    m_Modulo = gDB.ValField(rs.Fields, cscInfModulo)
    m_Tipo = gDB.ValField(rs.Fields, cscInfTipo)
    m_Propietario = gDB.ValField(rs.Fields, cscInfPropietario)
    m_Creado = gDB.ValField(rs.Fields, cscCreado)
    m_Modificado = gDB.ValField(rs.Fields, cscModificado)
    m_Modifico = gDB.ValField(rs.Fields, cscModifico)
    m_Activo = gDB.ValField(rs.Fields, cscActivo)
    m_pre_id = gDB.ValField(rs.Fields, cscPreID)

  Else
    m_Id = csNO_ID
    m_Nombre = vbNullString
    m_Codigo = vbNullString
    m_Descrip = vbNullString
    m_Storedprocedure = vbNullString
    m_Reporte = vbNullString
    m_Presentaciondefault = csEInfShowDef.csInfShowDefGrid
    m_Modulo = vbNullString
    m_Tipo = csEInfType.csInfTypeReport
    m_Propietario = csEInfOwner.csInfOwnerCairoDevelop
    m_Creado = csNoDate
    m_Modificado = csNoDate
    m_Modifico = 0
    m_pre_id = 0
    m_Activo = True

  End If

  Load = True
End Function

Private Sub pRefreshProperties()
  Dim c      As cIABMProperty
  Dim AbmGen As cABMGeneric
  Dim Filter As String

  With m_ObjAbm
    
    .Title2 = m_Nombre
    
    With .Properties

      With .Item(cscInfNombre)
        .Value = Nombre
      End With
      
      With .Item(cscInfCodigo)
        .Value = Codigo
      End With
      
      With .Item(cscInfStoredprocedure)
        .Value = Storedprocedure
      End With
      
      With .Item(cscInfReporte)
        .Value = Reporte
      End With
      
      With .Item(cscInfModulo)
        .ListText = m_Modulo
      End With
      
      With .Item(cscInfPresentaciondefault)
        .ListItemData = m_Presentaciondefault
      End With
      
      With .Item(cscInfTipo)
        .ListItemData = m_Tipo
      End With
      
      With .Item(cscInfPropietario)
        .ListItemData = m_Propietario
      End With
      
      With .Item(cscInfTotalesGrales)
        .Value = CInt(m_TotalesGrales)
      End With
      
      With .Item(cscInfColOcultas)
        .Value = m_ColOcultas
      End With
      
      With .Item(cscInfConnstr)
        .Value = m_Connstr
      End With
      
      With .Item(cscInfCheckBox)
        .Value = m_CheckBox
      End With
      
      With .Item(cscActivo)
        .Value = CInt(m_Activo)
      End With
      
      With .Item(cscInfDescrip)
        .Value = Descrip
      End With
      
      Set c = .Item(C_Params)
      If Not pLoadParametros(c) Then Exit Sub
      m_ItemsDeletedParametros = vbNullString
      
      Set c = .Item(C_Groups)
      If Not pLoadGroups(c) Then Exit Sub
      m_ItemsDeletedGroups = vbNullString
      
      Set c = .Item(C_Orders)
      If Not pLoadOrders(c) Then Exit Sub
      m_ItemsDeletedOrders = vbNullString
      
      Set c = .Item(c_Sumaries)
      If Not pLoadSumaries(c) Then Exit Sub
      m_ItemsDeletedSumaries = vbNullString
      
      Set c = .Item(C_Hiperlinks)
      If Not pLoadHiperlinks(c) Then Exit Sub
      m_ItemsDeletedHiperlinks = vbNullString
      
    End With
  End With
  
  Set AbmGen = m_ObjAbm
  AbmGen.ShowValues m_ObjAbm.Properties

End Sub
'/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
'
' PARAMETROS
'
'/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Private Function pLoadParametros(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "select InformeParametro.*, tbl_nombre" & _
            " from InformeParametro, Tabla " & _
              " where inf_id = " & m_Id & _
                " and InformeParametro.tbl_id *= Tabla.tbl_id" & _
            " order by infp_orden"
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadParametros", C_Module) Then Exit Function
  
  With Propiedad.Grid
  
    .Columns.Clear
    .Rows.Clear
    
    With .Columns
      With .Add(Nothing)
        .Name = "infp_id"
        .Visible = False
        .key = KI_INFP_ID
      End With
      
      With .Add(Nothing)
        .Name = C_strNombre
        .PropertyType = cspText
        .Width = 2000
        .key = KI_NOMBRE
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1809, vbNullString)  'Orden
        .PropertyType = cspNumeric
        .SubType = cspInteger
        .Width = 1200
        .key = KI_ORDEN
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1223, vbNullString)  'Tipo
        .PropertyType = cspList
      
        With .List.Add(Nothing)
          .Id = csInfParamCheck
          .Value = LNGGetText(2271, vbNullString)  'CheckBox
        End With
        
        With .List.Add(Nothing)
          .Id = csInfParamDate
          .Value = LNGGetText(1569, vbNullString)  'Fecha
        End With
        
        With .List.Add(Nothing)
          .Id = csInfParamHelp
          .Value = LNGGetText(2272, vbNullString)  'Help
        End With
        
        With .List.Add(Nothing)
          .Id = csInfParamList
          .Value = LNGGetText(2273, vbNullString)  'Lista
        End With
        
        With .List.Add(Nothing)
          .Id = csInfParamNumeric
          .Value = LNGGetText(2274, vbNullString)  'Numerico
        End With
        
        With .List.Add(Nothing)
          .Id = csInfParamSqlstmt
          .Value = LNGGetText(2276, vbNullString)  'Sqlstmt
        End With
        
        With .List.Add(Nothing)
          .Id = csInfParamText
          .Value = LNGGetText(1005, vbNullString)  'Texto
        End With
        .Width = 1200
        .key = KI_TIPO
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(2723, vbNullString)  'Visible
        .PropertyType = cspCheck
        .Width = 1200
        .key = KI_VISIBLE
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1810, vbNullString)  'Tabla
        .PropertyType = cspHelp
        .Table = csTabla
        .Width = 2500
        .key = KI_TBL_ID
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(2276, vbNullString)  'Sqlstmt
        .PropertyType = cspText
        .Width = 4000
        .key = KI_SQLSTMT
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(2277, vbNullString)  'Default
        .PropertyType = cspText
        .Width = 4000
        .key = KI_DEFAULT
      End With
      
    End With
    
    With .Rows
  
      While Not rs.EOF
      
        With .Add(Nothing, rs(cscInfpId).Value)
        
          With .Add(Nothing)
            .Value = rs(cscInfpId).Value
            .key = KI_INFP_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscInfpNombre)
            .key = KI_NOMBRE
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscInfpOrden)
            .key = KI_ORDEN
          End With
          
          With .Add(Nothing)
            .Id = gDB.ValField(rs.Fields, cscInfpTipo)
            .key = KI_TIPO
          End With
          
          With .Add(Nothing)
            .Id = gDB.ValField(rs.Fields, cscInfpVisible)
            .key = KI_VISIBLE
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscTblNombre)
            .Id = gDB.ValField(rs.Fields, cscTblId)
            .key = KI_TBL_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscInfpSqlstmt)
            .key = KI_SQLSTMT
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscInfpDefault)
            .key = KI_DEFAULT
          End With
          
        End With
        
        rs.MoveNext
      Wend
      
    End With
  End With
  
  pLoadParametros = True
End Function

Private Function pValidateRowParametros(Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  Dim TablaIsPresent    As Boolean
  Dim Tipo              As csEInfParamType
  Dim SqlstmtIsPresent  As Boolean
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.key
      Case KI_NOMBRE
        If ValEmpty(Cell.Value, csText) Then
          MsgInfo LNGGetText(1811, vbNullString, strRow) 'Debe indicar un nombre (1)
          Exit Function
        End If
      Case KI_ORDEN
        If ValEmpty(Cell.Value, csInteger) Then
          MsgInfo LNGGetText(1812, vbNullString, strRow) 'Debe indicar un orden (1)
          Exit Function
        End If
      Case KI_TIPO
        If ValEmpty(Cell.Id, csInteger) Then
          MsgInfo LNGGetText(1813, vbNullString, strRow) 'Debe indicar un tipo (1)
          Exit Function
        End If
        Tipo = Cell.Id
      Case KI_SQLSTMT
        If Not ValEmpty(Cell.Value, csText) Then SqlstmtIsPresent = True
      Case KI_TBL_ID
        If Not ValEmpty(Cell.Id, csId) Then TablaIsPresent = True
    End Select
  Next
  
  If Tipo = csInfParamHelp And Not TablaIsPresent Then
    MsgInfo LNGGetText(1814, vbNullString, strRow) 'Debe indicar una tabla (1)
    Exit Function
  End If
  
  If Tipo = csInfParamSqlstmt And Not SqlstmtIsPresent Then
    MsgInfo LNGGetText(1815, vbNullString, strRow) 'Debe indicar una sentencia sql (1)
    Exit Function
  End If
  
  If Tipo = csInfParamList And Not SqlstmtIsPresent Then
    MsgInfo LNGGetText(1816, vbNullString, strRow)
            'Debe indicar una lista separada por "|" o una sentencia sql (1)
    Exit Function
  End If
  
  
  pValidateRowParametros = True
  
End Function
  
Private Function pIsEmptyRowParametros(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  Dim bRowIsEmpty           As Boolean
  
  strRow = " (Fila " & RowIndex & ")"
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.key
      Case KI_NOMBRE
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KI_ORDEN
        If Not ValEmpty(Cell.Value, csInteger) Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KI_TIPO
        If Not ValEmpty(Cell.Id, csInteger) Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KI_SQLSTMT
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KI_TBL_ID
        If Not ValEmpty(Cell.Id, csId) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowParametros = bRowIsEmpty
End Function

Private Function pSaveItemsParametros() As Boolean
  Dim register As cRegister
  Dim IProperty As cIABMProperty
  
  Set IProperty = m_ObjAbm.Properties(C_Params)
  With IProperty
        
    Dim Row  As cIABMGridRow
    Dim Cell As cIABMGridCellValue
    
    For Each Row In IProperty.Grid.Rows
    
      Set register = New cRegister
      register.fieldId = cscInfpId
      register.Table = csTInformeParametro
      register.Id = csNew
      
      For Each Cell In Row
        Select Case Cell.key
          
          Case KI_INFP_ID
            If Not m_Copy Then
              register.Id = Val(Cell.Value)
            End If
          Case KI_NOMBRE
            register.Fields.Add2 cscInfpNombre, Cell.Value, csText
          Case KI_ORDEN
            register.Fields.Add2 cscInfpOrden, Cell.Value, csInteger
          Case KI_TIPO
            register.Fields.Add2 cscInfpTipo, Cell.Id, csInteger
          Case KI_DEFAULT
            register.Fields.Add2 cscInfpDefault, Cell.Value, csText
          Case KI_VISIBLE
            register.Fields.Add2 cscInfpVisible, Cell.Id, csBoolean
          Case KI_SQLSTMT
            register.Fields.Add2 cscInfpSqlstmt, Cell.Value, csText
          Case KI_TBL_ID
            register.Fields.Add2 cscTblId, Cell.Id, csId
        End Select
      Next
      
      register.Fields.Add2 cscInfId, m_Id, csId
      
      register.Fields.HaveLastUpdate = True
      register.Fields.HaveWhoModify = True
      
      If Not gDB.Save(register, , "pSaveItemsParametros", C_Module, c_ErrorSave) Then Exit Function
    Next
  End With
  
  Dim sqlstmt As String
  
  If LenB(m_ItemsDeletedParametros) And Not m_Copy Then
    m_ItemsDeletedParametros = RemoveLastColon(m_ItemsDeletedParametros)
    sqlstmt = "delete ReporteParametro where infp_id in (" & m_ItemsDeletedParametros & ")"
    If Not gDB.Execute(sqlstmt, "pSaveItemsParametros", C_Module) Then Exit Function
    
    sqlstmt = "delete InformeParametro where infp_id in (" & m_ItemsDeletedParametros & ")"
    If Not gDB.Execute(sqlstmt, "pSaveItemsParametros", C_Module) Then Exit Function
  End If
  
  pSaveItemsParametros = True
End Function

'/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
'
' Orders
'
'/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Private Function pLoadOrders(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "select InformeOrders.* from InformeOrders " & _
              " where inf_id = " & m_Id & _
            " order by winfo_id"
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadOrders", C_Module) Then Exit Function
  
  With Propiedad.Grid
  
    .Columns.Clear
    .Rows.Clear
    
    With .Columns
      With .Add(Nothing)
        .Name = "winfo_id"
        .Visible = False
        .key = KIO_INFO_ID
      End With
      
      With .Add(Nothing)
        .Name = C_strNombre
        .PropertyType = cspText
        .Width = 2000
        .key = KIO_NOMBRE
      End With
      
    End With
    
    With .Rows
  
      While Not rs.EOF
      
        With .Add(Nothing, rs(cscWInfoId).Value)
        
          With .Add(Nothing)
            .Value = rs(cscWInfoId).Value
            .key = KIO_INFO_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscWInfoNombre)
            .key = KIO_NOMBRE
          End With
        
        End With
        
        rs.MoveNext
      Wend
      
    End With
  End With
  
  pLoadOrders = True
End Function

Private Function pValidateRowOrders(Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  Dim TablaIsPresent    As Boolean
  Dim Tipo              As csEInfParamType
  Dim SqlstmtIsPresent  As Boolean
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.key
      Case KIO_NOMBRE
        If ValEmpty(Cell.Value, csText) Then
          MsgInfo LNGGetText(2724, vbNullString, strRow) 'Debe indicar una Columna (1)
          Exit Function
        End If
    End Select
  Next
  
  pValidateRowOrders = True
  
End Function
  
Private Function pIsEmptyRowOrders(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  Dim bRowIsEmpty           As Boolean
  
  strRow = " (Fila " & RowIndex & ")"
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.key
      Case KIO_NOMBRE
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowOrders = bRowIsEmpty
End Function

Private Function pSaveItemsOrders() As Boolean
  Dim register As cRegister
  Dim IProperty As cIABMProperty
  
  Set IProperty = m_ObjAbm.Properties(C_Orders)
  With IProperty
  
    Dim Row  As cIABMGridRow
    Dim Cell As cIABMGridCellValue
    
    For Each Row In IProperty.Grid.Rows
    
      Set register = New cRegister
      register.fieldId = cscWInfoId
      register.Table = csTInformeOrders
      register.Id = csNew
      
      For Each Cell In Row
        Select Case Cell.key
          
          Case KIO_INFO_ID
            If Not m_Copy Then
              register.Id = Val(Cell.Value)
            End If
          Case KIO_NOMBRE
            register.Fields.Add2 cscWInfoNombre, Cell.Value, csText
        End Select
      Next
      
      register.Fields.Add2 cscInfId, m_Id, csId
      
      register.Fields.HaveLastUpdate = True
      register.Fields.HaveWhoModify = True
      
      If Not gDB.Save(register, , "pSaveItemsOrders", C_Module, c_ErrorSave) Then Exit Function
    Next
  End With
  
  Dim sqlstmt As String
  
  If LenB(m_ItemsDeletedOrders) And Not m_Copy Then
    m_ItemsDeletedOrders = RemoveLastColon(m_ItemsDeletedOrders)
    sqlstmt = "delete " & csTInformeOrders & " where winfo_id in (" & m_ItemsDeletedOrders & ")"
  
    If Not gDB.Execute(sqlstmt, "pSaveItemsOrders", C_Module) Then Exit Function
  End If
  
  pSaveItemsOrders = True
End Function

'/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
'
' Groups
'
'/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Private Function pLoadGroups(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "select InformeGroups.* from InformeGroups " & _
              " where inf_id = " & m_Id & _
            " order by winfg_id"
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadGroups", C_Module) Then Exit Function
  
  With Propiedad.Grid
  
    .Columns.Clear
    .Rows.Clear
    
    With .Columns
    
      With .Add(Nothing)
        .Name = "winfg_id"
        .Visible = False
        .key = KIG_INFG_ID
      End With
      
      With .Add(Nothing)
        .Name = C_strNombre
        .PropertyType = cspText
        .Width = 2000
        .key = KIG_NOMBRE
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(2725, vbNullString) 'Por Defecto
        .PropertyType = cspCheck
        .SubType = cspInteger
        .Width = 2000
        .key = KIG_DEFAULT
      End With
      
    End With
    
    With .Rows
  
      While Not rs.EOF
      
        With .Add(Nothing, rs(cscWInfgId).Value)
        
          With .Add(Nothing)
            .Value = rs(cscWInfgId).Value
            .key = KIG_INFG_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscWInfgNombre)
            .key = KIG_NOMBRE
          End With
          
          With .Add(Nothing)
            .Id = Val(gDB.ValField(rs.Fields, cscWInfgPordefecto))
            .key = KIG_DEFAULT
          End With
          
        End With
        
        rs.MoveNext
      Wend
      
    End With
  End With
  
  pLoadGroups = True
End Function

Private Function pValidateRowGroups(Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  Dim TablaIsPresent    As Boolean
  Dim Tipo              As csEInfParamType
  Dim SqlstmtIsPresent  As Boolean
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.key
      Case KIG_NOMBRE
        If ValEmpty(Cell.Value, csText) Then
          MsgInfo LNGGetText(2724, vbNullString, strRow) 'Debe indicar una columna (1)
          Exit Function
        End If
    End Select
  Next
  
  pValidateRowGroups = True
  
End Function
  
Private Function pIsEmptyRowGroups(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  Dim bRowIsEmpty           As Boolean
  
  strRow = " (Fila " & RowIndex & ")"
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.key
      Case KIG_NOMBRE
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowGroups = bRowIsEmpty
End Function

Private Function pSaveItemsGroups() As Boolean
  Dim register As cRegister
  Dim IProperty As cIABMProperty
  
  Set IProperty = m_ObjAbm.Properties(C_Groups)
  With IProperty
  
    Dim Row  As cIABMGridRow
    Dim Cell As cIABMGridCellValue
    
    For Each Row In IProperty.Grid.Rows
    
      Set register = New cRegister
      register.fieldId = cscWInfgId
      register.Table = csTInformeGroups
      register.Id = csNew
      
      For Each Cell In Row
        Select Case Cell.key
          
          Case KIG_INFG_ID
            If Not m_Copy Then
              register.Id = Val(Cell.Value)
            End If
          Case KIG_NOMBRE
            register.Fields.Add2 cscWInfgNombre, Cell.Value, csText
          Case KIG_DEFAULT
            register.Fields.Add2 cscWInfgPordefecto, Cell.Id, csBoolean
        End Select
      Next
      
      register.Fields.Add2 cscInfId, m_Id, csId
      
      register.Fields.HaveLastUpdate = True
      register.Fields.HaveWhoModify = True
      
      If Not gDB.Save(register, , "pSaveItemsGroups", C_Module, c_ErrorSave) Then Exit Function
    Next
  End With
  
  Dim sqlstmt As String
  
  If LenB(m_ItemsDeletedGroups) And Not m_Copy Then
    m_ItemsDeletedGroups = RemoveLastColon(m_ItemsDeletedGroups)
    sqlstmt = "delete " & csTInformeGroups & " where winfg_id in (" & m_ItemsDeletedGroups & ")"
  
    If Not gDB.Execute(sqlstmt, "pSaveItemsGroups", C_Module) Then Exit Function
  End If
  
  pSaveItemsGroups = True
End Function

'/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
'
' Hiperlinks
'
'/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Private Function pLoadHiperlinks(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "select InformeHiperlinks.* from InformeHiperlinks " & _
              " where inf_id = " & m_Id & _
            " order by winfh_id"
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadHiperlinks", C_Module) Then Exit Function
  
  With Propiedad.Grid
  
    .Columns.Clear
    .Rows.Clear
    
    With .Columns
      With .Add(Nothing)
        .Name = "infh_id"
        .Visible = False
        .key = KIH_INFH_ID
      End With
      
      With .Add(Nothing)
        .Name = C_strNombre
        .PropertyType = cspText
        .Width = 2000
        .key = KIH_NOMBRE
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(2727, vbNullString)  'Url
        .PropertyType = cspText
        .Width = 2000
        .key = KIH_URL
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(2726, vbNullString)  'Columna
        .PropertyType = cspText
        .Width = 2000
        .key = KIH_COLUMNA
      End With
      
    End With
    
    With .Rows
  
      While Not rs.EOF
      
        With .Add(Nothing, rs(cscWInfhId).Value)
        
          With .Add(Nothing)
            .Value = rs(cscWInfhId).Value
            .key = KIH_INFH_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscWInfhNombre)
            .key = KIH_NOMBRE
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscWInfhUrl)
            .key = KIH_URL
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscWInfhIdFieldName)
            .key = KIH_COLUMNA
          End With
        
        End With
        
        rs.MoveNext
      Wend
      
    End With
  End With
  
  pLoadHiperlinks = True
End Function

Private Function pValidateRowHiperlinks(Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  Dim TablaIsPresent    As Boolean
  Dim Tipo              As csEInfParamType
  Dim SqlstmtIsPresent  As Boolean
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.key
      Case KIH_NOMBRE
        If ValEmpty(Cell.Value, csText) Then
          MsgInfo LNGGetText(1811, vbNullString, strRow) 'Debe indicar un nombre (1)
          Exit Function
        End If
      Case KIH_URL
        If ValEmpty(Cell.Value, csText) Then
          MsgInfo LNGGetText(2728, vbNullString, strRow) 'Debe indicar una Url (1)
          Exit Function
        End If
      Case KIH_COLUMNA
        If ValEmpty(Cell.Value, csText) Then
          MsgInfo LNGGetText(2724, vbNullString, strRow) 'Debe indicar una columna (1)
          Exit Function
        End If
    End Select
  Next
  
  pValidateRowHiperlinks = True
End Function
  
Private Function pIsEmptyRowHiperlinks(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  Dim bRowIsEmpty           As Boolean
  
  strRow = " (Fila " & RowIndex & ")"
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.key
      Case KIH_NOMBRE
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KIH_URL
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KIH_COLUMNA
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowHiperlinks = bRowIsEmpty
End Function

Private Function pSaveItemsHiperlinks() As Boolean
  Dim register As cRegister
  Dim IProperty As cIABMProperty
  
  Set IProperty = m_ObjAbm.Properties(C_Hiperlinks)
  With IProperty
  
    Dim Row  As cIABMGridRow
    Dim Cell As cIABMGridCellValue
    
    For Each Row In IProperty.Grid.Rows
    
      Set register = New cRegister
      register.fieldId = cscWInfhId
      register.Table = csTInformeHiperlinks
      register.Id = csNew
      
      For Each Cell In Row
        Select Case Cell.key
          
          Case KIH_INFH_ID
            If Not m_Copy Then
              register.Id = Val(Cell.Value)
            End If
          Case KIH_NOMBRE
            register.Fields.Add2 cscWInfhNombre, Cell.Value, csText
          Case KIH_URL
            register.Fields.Add2 cscWInfhUrl, Cell.Value, csText
          Case KIH_COLUMNA
            register.Fields.Add2 cscWInfhIdFieldName, Cell.Value, csText
        End Select
      Next
      
      register.Fields.Add2 cscInfId, m_Id, csId
      
      register.Fields.HaveLastUpdate = True
      register.Fields.HaveWhoModify = True
      
      If Not gDB.Save(register, , "pSaveItemsHiperlinks", C_Module, c_ErrorSave) Then Exit Function
    Next
  End With
  
  Dim sqlstmt As String
  
  If LenB(m_ItemsDeletedHiperlinks) And Not m_Copy Then
    m_ItemsDeletedHiperlinks = RemoveLastColon(m_ItemsDeletedHiperlinks)
    sqlstmt = "delete " & csTInformeHiperlinks & " where winfh_id in (" & m_ItemsDeletedHiperlinks & ")"
  
    If Not gDB.Execute(sqlstmt, "pSaveItemsHiperlinks", C_Module) Then Exit Function
  End If
  
  pSaveItemsHiperlinks = True
End Function

'/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
'
' Sumaries
'
'/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Private Function pLoadSumaries(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "select InformeSumaries.* from InformeSumaries " & _
              " where inf_id = " & m_Id & _
            " order by winfs_id"
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadSumaries", C_Module) Then Exit Function
  
  With Propiedad.Grid
  
    .Columns.Clear
    .Rows.Clear
    
    With .Columns
      With .Add(Nothing)
        .Name = "infs_id"
        .Visible = False
        .key = KIS_INFS_ID
      End With
      
      With .Add(Nothing)
        .Name = C_strNombre
        .PropertyType = cspText
        .Width = 2000
        .key = KIS_NOMBRE
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(2108, vbNullString) 'Operación
        .PropertyType = cspList
        With .List.Add(Nothing)
          .Value = "average"
        End With
        With .List.Add(Nothing)
          .Value = "sum"
        End With
        With .List.Add(Nothing)
          .Value = "max"
        End With
        With .List.Add(Nothing)
          .Value = "min"
        End With
        With .List.Add(Nothing)
          .Value = "count"
        End With
        .Width = 2000
        .key = KIS_OPERATION
      End With
      
    End With
    
    With .Rows
  
      While Not rs.EOF
      
        With .Add(Nothing, rs(cscWInfsId).Value)
        
          With .Add(Nothing)
            .Value = rs(cscWInfsId).Value
            .key = KIS_INFS_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscWInfsNombre)
            .key = KIS_NOMBRE
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.Fields, cscWInfsOperacion)
            .key = KIS_OPERATION
          End With
          
        End With
        
        rs.MoveNext
      Wend
      
    End With
  End With
  
  pLoadSumaries = True
End Function

Private Function pValidateRowSumaries(Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  Dim TablaIsPresent    As Boolean
  Dim Tipo              As csEInfParamType
  Dim SqlstmtIsPresent  As Boolean
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.key
      Case KIS_NOMBRE
        If ValEmpty(Cell.Value, csText) Then
          MsgInfo LNGGetText(2724, vbNullString, strRow) 'Debe indicar una columna (1)
          Exit Function
        End If
      Case KIS_OPERATION
        If ValEmpty(Cell.Value, csText) Then
          MsgInfo LNGGetText(2729, vbNullString, strRow) 'Debe indicar una Operación (1)
          Exit Function
        End If
    End Select
  Next
  
  pValidateRowSumaries = True
End Function
  
Private Function pIsEmptyRowSumaries(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  Dim bRowIsEmpty           As Boolean
  
  strRow = " (Fila " & RowIndex & ")"
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.key
      Case KIS_NOMBRE
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KIS_OPERATION
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowSumaries = bRowIsEmpty
End Function

Private Function pSaveItemsSumaries() As Boolean
  Dim register As cRegister
  Dim IProperty As cIABMProperty
  
  Set IProperty = m_ObjAbm.Properties(c_Sumaries)
  With IProperty
  
    Dim Row  As cIABMGridRow
    Dim Cell As cIABMGridCellValue
    
    For Each Row In IProperty.Grid.Rows
    
      Set register = New cRegister
      register.fieldId = cscWInfsId
      register.Table = csTInformeSumaries
      register.Id = csNew
      
      For Each Cell In Row
        Select Case Cell.key
          
          Case KIS_INFS_ID
            If Not m_Copy Then
              register.Id = Val(Cell.Value)
            End If
          Case KIS_NOMBRE
            register.Fields.Add2 cscWInfsNombre, Cell.Value, csText
          Case KIS_OPERATION
            register.Fields.Add2 cscWInfsOperacion, Cell.Value, csText
        End Select
      Next
      
      register.Fields.Add2 cscInfId, m_Id, csId
      
      register.Fields.HaveLastUpdate = True
      register.Fields.HaveWhoModify = True
      
      If Not gDB.Save(register, , "pSaveItemsSumaries", C_Module, c_ErrorSave) Then Exit Function
    Next
  End With
  
  Dim sqlstmt As String
  
  If LenB(m_ItemsDeletedSumaries) And Not m_Copy Then
    m_ItemsDeletedSumaries = RemoveLastColon(m_ItemsDeletedSumaries)
    sqlstmt = "delete " & csTInformeSumaries & " where winfs_id in (" & m_ItemsDeletedSumaries & ")"
  
    If Not gDB.Execute(sqlstmt, "pSaveItemsSumaries", C_Module) Then Exit Function
  End If
  
  pSaveItemsSumaries = True
End Function

Private Function pSavePrestacion(ByVal Codigo As String, ByRef PreId As Long, ByVal Nombre As String, ByVal Modulo As String) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  Dim min     As Long
  Dim max     As Long
  
  If PreId = csNO_ID Then
  
    'DC_CSC_CON_0010'
    Select Case UCase(Mid(Codigo, 1, 2))
      Case "DC"
        min = 10000000
        max = 10999999
      Case "DT"
        min = 11000000
        max = 11999999
      Case "IT"
        min = 12000000
        max = 12999999
      Case "CL"
        min = 13000000
        max = 13999999
      Case "IC"
        min = 14000000
        max = 14999999
    End Select
    
    sqlstmt = "SP_DBGetNewId2 'Prestacion', 'pre_id', " & min & ", " & max & ", 0"
    If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
    If rs.EOF Then Exit Function
    
    PreId = rs.Fields(0).Value
    
    sqlstmt = "insert Prestacion (pre_id, pre_nombre,pre_grupo,pre_grupo1,activo)" _
                & " values(" & PreId & "," & gDB.sqlString(Nombre) & ",'Informes'," _
                & gDB.sqlString(Modulo) & ",1)"
    
    If Not gDB.Execute(sqlstmt) Then Exit Function
    
  Else
    
    sqlstmt = "Update Prestacion set " _
                & "pre_nombre = " & gDB.sqlString(Nombre) & "," & vbCrLf _
                & "pre_grupo  = 'Informes'," & vbCrLf _
                & "pre_grupo1 = " & gDB.sqlString(Modulo) & "," & vbCrLf _
                & "activo = 1" & vbCrLf _
                & " where pre_id = " & PreId
    
    If Not gDB.Execute(sqlstmt) Then Exit Function
  
  End If
  
  pSavePrestacion = True
End Function

Private Sub Class_Initialize()
  On Error GoTo ControlError

  c_ErrorSave = LNGGetText(2941, vbNullString) 'Error al grabar el Informe

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

' construccion - destruccion
Private Sub Class_Terminate()
  Set m_ObjAbm = Nothing
  Set m_ObjTree = Nothing
End Sub

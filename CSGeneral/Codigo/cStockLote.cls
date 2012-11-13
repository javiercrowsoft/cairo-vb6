VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cStockLote"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGeneric
Implements CSInterfacesABM.cIABMClient
Implements CSMenu.cIMenuClient
'--------------------------------------------------------------------------------
' cStockLote
' 17-04-06

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cStockLote"

Private Const K_CODIGO                         As Integer = 1
Private Const K_NROLOTE                        As Integer = 2
Private Const K_FECHA                          As Integer = 3
Private Const K_FECHAVTO                       As Integer = 4
Private Const K_DESCRIP                        As Integer = 5
Private Const K_ID_PADRE                       As Integer = 6
Private Const K_PR_ID                          As Integer = 7
Private Const K_PA_ID                          As Integer = 8

' estructuras
' Seudo - Variables
Private c_ErrorSave                  As String

' variables privadas
Private m_Id                         As Long
Private m_Codigo                     As String
Private m_NroLote                    As String
Private m_Fecha                      As Date
Private m_FechaVto                   As Date
Private m_Descrip                    As String

Private m_Producto                   As String
Private m_Pais                       As String
Private m_LotePadre                  As String

Private m_pr_id                      As Long
Private m_Pa_id                      As Long
Private m_stl_id_padre               As Long

'OJO HASTA ACA

Private m_Editing           As Boolean

Private m_ObjAbm            As cIABMGeneric
Private m_ObjTree           As Object

Private m_IsNew             As Boolean

Private m_BranchId          As Long
Private m_TreeId            As Long

Private m_Host          As CSMenu.cIMenuHost
Private m_Copy          As Boolean

Private m_Title         As String

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
                               csPreGNewStockLote
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

  Doc.ClientTable = csTStockLote
  Doc.ClientTableID = m_Id

  cIABMClient_ShowDocDigital = Doc.ShowDocs(gDB)

  GoTo ExitProc
ControlError:
  MngError Err, C_ShowDocDigital, C_Module, vbNullString
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

  With m_ObjAbm.Properties(cscStlCodigo)
    .Value = C_C & .Value
  End With
  
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscStlCodigo)
  
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
  Dim Fields   As cFields
  
  Set register = New cRegister
  Set Fields = register.Fields
  
  With register
    .fieldId = cscStlId
    .Table = csTStockLote
    If m_Copy Then
      .Id = csNew
    Else
      .Id = m_Id
    End If
  End With
  
  Dim IProperty As cIABMProperty
  Dim NroLote   As String
  
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_CODIGO
          NroLote = .Value
          Fields.Add2 cscStlCodigo, .Value, csText
        Case K_NROLOTE
          If Not ValEmpty(.Value, csText) Then
            NroLote = .Value
          End If
          Fields.Add2 cscStlNroLote, NroLote, csText
        Case K_FECHA
          Fields.Add2 cscStlFecha, .Value, csDate
        Case K_FECHAVTO
          Fields.Add2 cscStlFechaVto, .Value, csDate
        Case K_DESCRIP
          Fields.Add2 cscStlDescrip, .Value, csText
        Case K_ID_PADRE
          Fields.Add2 cscStlIdPadre, .HelpId, csId
        Case K_PR_ID
          Fields.Add2 cscPrId, .HelpId, csId
        Case K_PA_ID
          Fields.Add2 cscPaId, .HelpId, csId
      End Select
    End With
  Next
  
  Fields.HaveLastUpdate = True
  Fields.HaveWhoModify = True
  
  If Not gDB.Save(register, , "cIABMClient_Save", C_Module, c_ErrorSave) Then Exit Function
  
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
    cIABMClient_Title = LNGGetText(2926, vbNullString) 'Lotes
End Property

Private Function cIABMClient_Validate() As Boolean

  Dim IProperty As cIABMProperty

  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_CODIGO
          If ValEmpty(.Value, csText) Then
            MsgInfo LNGGetText(1008, vbNullString) 'Debe indicar un código
            Exit Function
          End If
        Case K_FECHA
          If ValEmpty(.Value, csDate) Then
            MsgInfo LNGGetText(1558, vbNullString) 'Debe indicar una fecha
            Exit Function
          End If
        Case K_PR_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(1359, vbNullString) 'Debe indicar un artículo
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
    cIEditGeneric_ShowList = SecurityCanAccess(csPreGListStockLote)
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
    If Not SecurityCanAccess(csPreGDeleteStockLote) Then Exit Function

    Dim sqlstmt As String
    
    sqlstmt = "Delete StockLote where stl_id = " & Id
    
    cIEditGeneric_Delete = gDB.Execute(sqlstmt, "cIEditGeneric_Delete", C_Module)
End Function

Private Function cIEditGeneric_Search(Id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Id = csNO_ID Then
    m_IsNew = True
    If Not SecurityCanAccess(csPreGNewStockLote) Then Exit Function
  Else
    m_IsNew = False
    If Not SecurityCanAccess(csPreGEditStockLote) Then Exit Function
  End If

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

Private Function cIEditGeneric_PropertyChange(ByVal Key As Integer) As Boolean

End Function

'/////////////////////////////////////////////////////////////
' Menu
Private Function cIMenuClient_Initialize(F As Object, Host As CSMenu.cIMenuHost) As Boolean
  On Error GoTo ControlError
  Dim str_2927  As String
  
  str_2927 = LNGGetText(2927, vbNullString) 'S&tock
  
  Set m_Host = Host
  m_Host.Server.AddMenu str_2927, _
                        csMenuEnum.csMenuStock, _
                        vbNullString, _
                        1, _
                        False, _
                        False, _
                        False, _
                        True, _
                        False, _
                        Nothing
                                        '&Lotes
  m_Host.Server.AddMenu LNGGetText(2928, vbNullString), _
                        csPreGListStockLote, _
                        str_2927, _
                        0, True, _
                        False, _
                        False, _
                        False, _
                        False, _
                        Me
  
  cIMenuClient_Initialize = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIMenuClient_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal Id As Long) As Variant
  m_Host.MenuListDocClick "CSABMInterface2.cABMGeneric", _
                          "CSGeneralEx2.cStockLote", _
                          "CSABMInterface2.cABMGenericListDoc", _
                          "CSStock2.cStockLoteListDoc", _
                          Me, _
                          m_Title, _
                          0
End Function

' funciones privadas
Private Function LoadCollection() As Boolean

  With m_ObjAbm.Properties
    
    .Clear
    
    With .Add(Nothing, cscStlCodigo)
      .PropertyType = cspText
      .Name = C_strCodigo
      .Size = 50
      .Key = K_CODIGO
      .Value = m_Codigo
    End With
    
    With .Add(Nothing, cscStlNroLote)
      .PropertyType = cspText
      .Name = LNGGetText(2929, vbNullString)  'Nro. Lote
      .Size = 50
      .Key = K_NROLOTE
      .Value = m_NroLote
    End With
    
    With .Add(Nothing, cscStlFecha)
      .PropertyType = cspDate
      .Name = LNGGetText(1569, vbNullString)  'Fecha
      .Key = K_FECHA
      .Value = m_Fecha
    End With
    
    With .Add(Nothing, cscStlFechaVto)
      .PropertyType = cspDate
      .Name = LNGGetText(2902, vbNullString)  'Fecha Vto.
      .Key = K_FECHAVTO
      .Value = m_FechaVto
    End With
    
    With .Add(Nothing, cscStlIdPadre)
      .PropertyType = cspHelp
      .Table = csStockLote
      .Left = 6000
      .TopFromProperty = cscStlCodigo
      .Name = LNGGetText(2930, vbNullString)  'Lote Padre
      .Key = K_ID_PADRE
      .Value = m_LotePadre
      .HelpId = m_stl_id_padre
    End With
    
    With .Add(Nothing, cscPrId)
      .PropertyType = cspHelp
      .Table = csProducto
      .Name = LNGGetText(1619, vbNullString)  'Producto
      .Key = K_PR_ID
      .Value = m_Producto
      .HelpId = m_pr_id
    End With
    
    With .Add(Nothing, cscPaId)
      .PropertyType = cspHelp
      .Table = csPais
      .Name = LNGGetText(2931, vbNullString)  'País Origen
      .Key = K_PA_ID
      .Value = m_Pais
      .HelpId = m_Pa_id
    End With
  
    With .Add(Nothing, cscStlDescrip)
      .PropertyType = cspText
      .SubType = cspMemo
      .TopFromProperty = cscStlFechaVto
      .TopToPrevious = 440
      .LeftFromProperty = cscStlCodigo
      .Width = 6700
      .Height = 880
      .Name = C_strDescrip
      .Size = 255
      .Key = K_DESCRIP
      .Value = m_Descrip
    End With
  End With
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

Private Function Load(ByVal Id As Long) As Boolean

  Dim sqlstmt As String

  sqlstmt = "sp_StockLoteGet " & Id

  Dim rs As Recordset

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.Fields, cscStlId)
    m_Codigo = gDB.ValField(rs.Fields, cscStlCodigo)
    m_NroLote = gDB.ValField(rs.Fields, cscStlNroLote)
    m_Fecha = gDB.ValField(rs.Fields, cscStlFecha)
    m_FechaVto = gDB.ValField(rs.Fields, cscStlFechaVto)
    m_Descrip = gDB.ValField(rs.Fields, cscStlDescrip)
    
    m_stl_id_padre = gDB.ValField(rs.Fields, cscStlIdPadre)
    m_pr_id = gDB.ValField(rs.Fields, cscPrId)
    m_Pa_id = gDB.ValField(rs.Fields, cscPaId)
    
    m_LotePadre = gDB.ValField(rs.Fields, cscStlCodigo2)
    m_Producto = gDB.ValField(rs.Fields, cscPrNombreCompra)
    m_Pais = gDB.ValField(rs.Fields, cscPaNombre)

  Else
    m_Id = csNO_ID
    m_Codigo = vbNullString
    m_NroLote = vbNullString
    m_Fecha = csNoDate
    m_FechaVto = csNoDate
    m_Descrip = vbNullString
    
    m_stl_id_padre = csNO_ID
    m_pr_id = csNO_ID
    m_Pa_id = csNO_ID

    m_LotePadre = vbNullString
    m_Producto = vbNullString
    m_Pais = vbNullString

  End If

  Load = True
End Function

' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  m_Title = LNGGetText(2926, vbNullString)  'Lotes
  c_ErrorSave = LNGGetText(2932, vbNullString)  'Error al grabar StockLote

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


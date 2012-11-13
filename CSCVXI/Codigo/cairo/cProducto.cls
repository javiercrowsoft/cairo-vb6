VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cProducto"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIABMClient
Implements CSInterfacesABM.cIABMClientGrid
Implements csMenu.cIMenuClient
'--------------------------------------------------------------------------------
' cProducto
' 22-09-07

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cProducto"

Private Const c_items = "Items"

Private Const K_ITEMS           As Integer = 1

Private Const KI_CMIPR_ID       As Integer = 1
Private Const KI_PR_ID          As Integer = 2
Private Const KI_CODIGO         As Integer = 4
Private Const KI_NOMBRE         As Integer = 5
Private Const KI_DESCRIP        As Integer = 6
Private Const KI_COMUNIDAD      As Integer = 7

Private Const KI_FINALIZA       As Integer = 8
Private Const KI_OFERTAS        As Integer = 9
Private Const KI_VISITAS        As Integer = 10
Private Const KI_VENTAS         As Integer = 11
Private Const KI_DISPONIBLE     As Integer = 12
Private Const KI_REPOSICION     As Integer = 13

' Seudo - Variables
Private c_ErrorSave         As String

' estructuras
' variables privadas

Private m_ObjAbm            As cIABMGeneric

Private m_Host              As csMenu.cIMenuHost

' Properties privadas
' funciones publicas

Public Function Edit() As Boolean
  On Error GoTo ControlError
  
  If Not SecurityCanAccess(csPreCVXIEditProducto) Then Exit Function

  Set m_ObjAbm = New CSABMInterface2.cABMGeneric
  
  If Not Load() Then Exit Function
  
  If Not LoadCollection() Then Exit Function
  
  Edit = True
  
  Exit Function
ControlError:
  MngError Err, "Edit", "cProducto", vbNullString
End Function

' Implementacion de cIABMClient
Private Function cIABMClient_Copy() As Boolean
End Function

Private Function cIABMClient_EditNew() As Boolean
End Function

Private Property Get cIABMClient_Aplication() As String
  cIABMClient_Aplication = gAppName
End Property

Private Property Get cIABMClient_CanAddDocDigital() As Boolean
  cIABMClient_CanAddDocDigital = False
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

Private Sub cIABMClient_DiscardChanges()
  LoadCollection
End Sub

Private Function cIABMClient_ListAdHock(List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClient_Load()

End Sub

Private Function cIABMClient_PropertyChange(ByVal Key As Integer) As Boolean
  cIABMClient_PropertyChange = True
End Function

Private Function cIABMClient_Save() As Boolean
  
  If Not pSave() Then Exit Function
  
  cIABMClient_Save = Load()
End Function

Private Function cIABMClient_Terminate() As Boolean
  cIABMClient_Terminate = True
End Function

Private Property Get cIABMClient_Title() As String
  cIABMClient_Title = LNGGetText(5070, vbNullString) 'Articulos de Comunidad Internet
End Property

Private Function cIABMClient_Validate() As Boolean
  cIABMClient_Validate = True
End Function

Private Function cIABMClientGrid_ColumnAfterEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long) As Boolean
  cIABMClientGrid_ColumnAfterEdit = True
End Function

Private Function cIABMClientGrid_ColumnAfterUpdate(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long) As Boolean
  cIABMClientGrid_ColumnAfterUpdate = True
End Function

Private Function cIABMClientGrid_ColumnBeforeEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean
  Select Case pGetKeyFromCol(m_ObjAbm.Properties.Item(c_items).Grid.Columns, lCol)
    Case KI_PR_ID, KI_REPOSICION
      cIABMClientGrid_ColumnBeforeEdit = True
    Case Else
      cIABMClientGrid_ColumnBeforeEdit = False
  End Select
  
End Function

Private Function cIABMClientGrid_ColumnButtonClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean
  cIABMClientGrid_ColumnButtonClick = True
End Function

Private Sub cIABMClientGrid_ColumnCancelEdit(ByVal Key As Integer)

End Sub

Private Sub cIABMClientGrid_ColumnClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Sub cIABMClientGrid_DblClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Function cIABMClientGrid_DeleteRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal lRow As Long) As Boolean
  cIABMClientGrid_DeleteRow = False
End Function

Private Function cIABMClientGrid_IsEmptyRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_ITEMS
      cIABMClientGrid_IsEmptyRow = pIsEmptyRow(Row, RowIndex)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ValidateRow", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIABMClientGrid_ListAdHock(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal ColIndex As Long, List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClientGrid_NewRow(ByVal Key As Integer, ByVal Rows As Integer)

End Sub

Private Function cIABMClientGrid_ValidateRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_ITEMS
      cIABMClientGrid_ValidateRow = pValidateRow(Row, RowIndex)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ValidateRow", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_Initialize(f As Object, Host As csMenu.cIMenuHost) As Boolean
  On Error GoTo ControlError
  Dim str_5025 As String

  str_5025 = LNGGetText(5025, vbNullString)
  Set m_Host = Host
                                                          'Co&nfiguración
  m_Host.Server.AddMenu str_5025, csMenuEnum.csMenuComunidad, vbNullString, 1, False, False, False, True, False, Nothing
  m_Host.Server.AddMenu LNGGetText(5071, vbNullString), csPreCVXIEditProducto, str_5025, 0, True, False, False, False, False, Me
                        '&Articulos
  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, "cIMenuClient_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal id As Long) As Variant
  Edit
End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  Dim c As cIABMProperty
  
  m_ObjAbm.Title2 = LNGGetText(5070, vbNullString) ' Articulos de Comunidad Internet

  With m_ObjAbm.Properties
  
    .Clear
    
    With .Add(Nothing)
      .PropertyType = cspLabel
      .Value = LNGGetText(5072, vbNullString) 'Indique los articulos de Cairo que correponden con los de la Comunidad
      .Width = 7000
      .Left = 400
      .FontBold = True
    End With
    
    Set c = .Add(Nothing, c_items)
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      If Not pLoadItems(c) Then Exit Function
      .Name = LNGGetText(5073, vbNullString) 'Articulos
      .Key = K_ITEMS
      .Top = 1400
      .Left = 200
      .GridAdd = False
      .GridEdit = True
      .GridRemove = False
    End With
    
  End With
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

Private Function Load() As Boolean
  Load = True
End Function

Private Function pLoadItems(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  
  Dim rs As ADODB.Recordset
  
  sqlstmt = "sp_ComunidadInternetProdutosGet"
   
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadItems", C_Module) Then Exit Function
    
  With Propiedad.Grid
    
    With .Columns
      .Clear
  
      With .Add(Nothing)
        .Key = KI_CMIPR_ID
        .Visible = False
      End With
  
      Dim c As cIABMGridColumn
      Dim oc As cABMGridColumn
  
      With .Add(Nothing)
        .Name = C_strCodigo
        .PropertyType = cspText
        .Width = 3000
        .Key = KI_COMUNIDAD
      End With
      
      With .Add(Nothing)
        .Name = C_strCodigo
        .PropertyType = cspText
        .Width = 3000
        .Key = KI_CODIGO
      End With
  
      With .Add(Nothing)
        .Name = C_strNombre
        .PropertyType = cspText
        .Width = 3000
        .Key = KI_NOMBRE
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1619, vbNullString) 'Producto
        .PropertyType = cspHelp
        .Table = csProductoVenta
        .Width = 2000
        .Key = KI_PR_ID
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1488, vbNullString) 'Ventas
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Width = 1000
        .Key = KI_VENTAS
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(5085, vbNullString) 'Ofertas
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Width = 1000
        .Key = KI_OFERTAS
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(5084, vbNullString) 'Visitas
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Width = 1000
        .Key = KI_VISITAS
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(5086, vbNullString) 'Disponible
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Width = 1000
        .Key = KI_DISPONIBLE
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(5087, vbNullString) 'Finaliza
        .PropertyType = cspDate
        .Width = 1000
        .Key = KI_FINALIZA
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(5088, vbNullString) 'Reposicion
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Width = 1000
        .Key = KI_REPOSICION
      End With
      
      With .Add(Nothing)
        .Name = C_strDescrip
        .PropertyType = cspText
        .Width = 3000
        .Key = KI_DESCRIP
      End With
    
    End With
  
    With .Rows
      
      .Clear
      
      While Not rs.EOF
      
        With .Add(Nothing)
        
          With .Add(Nothing)
            .id = gDB.ValField(rs.fields, cscCmiprId)
            .Key = KI_CMIPR_ID
          End With
                    
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCmiNombre)
            .Key = KI_COMUNIDAD
          End With
                    
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCmiprCodigo)
            .Key = KI_CODIGO
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCmiprNombre)
            .Key = KI_NOMBRE
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscPrNombreVenta)
            .id = gDB.ValField(rs.fields, cscPrId)
            .Key = KI_PR_ID
          End With
                  
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCmiprVentas)
            .Key = KI_VENTAS
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCmiprOfertas)
            .Key = KI_OFERTAS
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCmiprVisitas)
            .Key = KI_VISITAS
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCmiprDisponible)
            .Key = KI_DISPONIBLE
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCmiprFinaliza)
            .Key = KI_FINALIZA
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCmiprReposicion)
            .Key = KI_REPOSICION
          End With
        
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, "descrip")
            .Key = KI_DESCRIP
          End With
        
        End With
        
        rs.MoveNext
      Wend
    
    End With
    
  End With
  
  pLoadItems = True
End Function

Private Function pIsEmptyRow(ByRef Row As CSInterfacesABM.cIABMGridRow, _
                             ByVal RowIndex As Long) As Boolean
  pIsEmptyRow = False
End Function

Private Function pValidateRow(ByRef Row As CSInterfacesABM.cIABMGridRow, _
                              ByVal RowIndex As Long) As Boolean
  pValidateRow = True
End Function

Private Function pSave() As Boolean
  Dim Row       As cIABMGridRow
  Dim register  As cRegister
  Dim sqlstmt   As String
  
  With m_ObjAbm.Properties.Item(c_items).Grid
  
    For Each Row In .Rows
      
      Set register = New cRegister
      
      With register
        .fieldId = cscCmiprId
        .Table = csTComunidadInternetProducto
        .fieldId = cscCmiprId
          
        .id = pCell(Row, KI_CMIPR_ID).id
        
        .fields.Add2 cscPrId, pCell(Row, KI_PR_ID).id, csId
        .fields.Add2 cscCmiprReposicion, pCell(Row, KI_REPOSICION).Value, csDouble
        
        .fields.HaveLastUpdate = False
        .fields.HaveWhoModify = False
                  
      End With
      
      If Not gDB.Save(register, , _
                      "pSave", C_Module, c_ErrorSave) Then Exit Function
    
    Next
  
  End With
  
  sqlstmt = "sp_ComunidadInternetProdutosSave"
  If Not gDB.Execute(sqlstmt) Then Exit Function
    
  pSave = True
End Function

Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  c_ErrorSave = LNGGetText(5074, vbNullString)  'Error al grabar Articulos de Comunidad Internet
  
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
End Sub



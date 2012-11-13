VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cProductoBOMItemA"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIABMClient
Implements CSInterfacesABM.cIABMClientGrid
'--------------------------------------------------------------------------------
' cProductoBOM
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
Private Const C_Module = "cProductoBOM"

Private Const c_items = "Items"

Private Const K_ITEMS                       As Integer = 11

' Producto ITEM
Private Const KI_PBMIA_ID                   As Integer = 1
Private Const KI_PR_ID_I                    As Integer = 2

' estructuras
' Seudo - Variables
Private c_ErrorSave                    As String

' variables privadas
Private m_Id                           As Long
Private m_pbm_id                       As Long
Private m_Alternativas                 As String

Private m_ItemsDeletedI                As String

'OJO HASTA ACA

Private m_Editing           As Boolean

Private m_ObjAbm            As cIABMGeneric

Private m_Host              As CSMenu.cIMenuHost

' Properties publicas
Public Property Get Alternativas() As String
  Alternativas = m_Alternativas
End Property
' Properties privadas
' funciones publicas
Public Function Edit(ByVal pbmi_id As Long, _
                     ByVal pbm_id As Long) As Boolean

  On Error GoTo ControlError
  
  Dim AbmObj As cABMGeneric
  
  Set m_ObjAbm = New cABMGeneric
  Set AbmObj = m_ObjAbm
  
  AbmObj.OkCancelDialog = True
  AbmObj.bDontAskForSave = True
  
  m_ObjAbm.InModalWindow = True
  
  m_Id = pbmi_id
  m_pbm_id = pbm_id
  
  LoadCollection

  Edit = AbmObj.OkCancelDialogRslt
  
  GoTo ExitProc
ControlError:
  MngError Err, "Edit", C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

' Implementacion de cIABMClient
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

Private Function cIABMClient_MessageEx(ByVal MessageID As Long, ByVal Info As Variant) As Variant
  Select Case MessageID
  
    Case MSG_DOC_INFO
    
      Dim AbmGen As cABMGeneric
      Set AbmGen = m_ObjAbm
      
      CSKernelClient2.ShowHelp AbmGen.hWnd, _
                               vbNullString, _
                               vbNullString, _
                               csPreProdNewProductoBOM
      cIABMClient_MessageEx = MSG_DOC_INFO_HANDLED
    Case Else
      cIABMClient_MessageEx = True
  End Select
End Function

Private Function cIABMClient_ShowDocDigital() As Boolean
  cIABMClient_ShowDocDigital = True
End Function

Private Function cIABMClient_EditNew() As Boolean
  cIABMClient_EditNew = True
End Function

Private Sub cIABMClient_DiscardChanges()
  LoadCollection
End Sub

Private Function cIABMClient_Copy() As Boolean
  cIABMClient_Copy = True
End Function

Private Function cIABMClient_ListAdHock(List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClient_Load()

End Sub

Private Function cIABMClient_PropertyChange(ByVal Key As Integer) As Boolean

End Function

Private Function cIABMClient_Save() As Boolean
  Dim register As cRegister
  Dim fields   As cFields
  
  Set register = New cRegister
  Set fields = register.fields
  
  fields.HaveLastUpdate = False
  fields.HaveWhoModify = False
    
  If Not register.BeginTrans(gDB) Then Exit Function
  
  If Not pSaveItems() Then Exit Function
  
  If Not register.CommitTrans() Then Exit Function
  
  cIABMClient_Save = True
End Function

Private Function cIABMClient_Terminate() As Boolean
  m_Editing = False
  cIABMClient_Terminate = True
End Function

Private Property Get cIABMClient_Title() As String
  cIABMClient_Title = LNGGetText(3059, vbNullString) 'Insumo Alternativo
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
  cIABMClientGrid_ColumnBeforeEdit = True
End Function

Private Function cIABMClientGrid_ColumnButtonClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean

End Function

Private Sub cIABMClientGrid_ColumnCancelEdit(ByVal Key As Integer)

End Sub

Private Sub cIABMClientGrid_ColumnClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Sub cIABMClientGrid_DblClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Function cIABMClientGrid_DeleteRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal lRow As Long) As Boolean
  Dim Id As Long
  
  Select Case Key
    Case K_ITEMS
      Id = Val(pCell(Row, KI_PBMIA_ID).Value)
      If Id <> csNO_ID Then m_ItemsDeletedI = m_ItemsDeletedI & Id & C_StrColon
  End Select
  
  cIABMClientGrid_DeleteRow = True

End Function

Private Function cIABMClientGrid_IsEmptyRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_ITEMS
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowI(Row, RowIndex)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, C_ValidateRow, C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc
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
      cIABMClientGrid_ValidateRow = pValidateRowI(Row, RowIndex)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, C_ValidateRow, C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next

End Function

' funciones privadas
Private Function LoadCollection() As Boolean
   
  Dim c As cIABMProperty
  
  With m_ObjAbm.Properties
    .Clear
    
    Set c = .Add(Nothing, c_items)
    
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      If Not pLoadItem(c) Then Exit Function
      .Name = c_items
      .Key = K_ITEMS
      .GridAdd = True
      .GridEdit = True
      .GridRemove = True
    End With
    m_ItemsDeletedI = vbNullString
  
  End With
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

Private Function pLoadItem(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt     As String
  Dim pr_nombre   As String
  Dim rs          As ADODB.Recordset
  
  sqlstmt = "select pbma.*,pr_nombrecompra from " & _
            "ProductoBOMItemA pbma inner join Producto pr " & _
                                            "on pbma.pr_id = pr.pr_id " & _
              "where pbmi_id = " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadItem", C_Module) Then Exit Function
  
  m_Alternativas = vbNullString
  
  With Propiedad.Grid.Columns
    With .Add(Nothing)
      .Visible = False
      .Key = KI_PBMIA_ID
    End With
  
    With .Add(Nothing)
      .Name = LNGGetText(1367, vbNullString) 'Artículo
      .PropertyType = cspHelp
      .Table = csProducto
      .Width = 2500
      .Key = KI_PR_ID_I
    End With
  End With
    
  With Propiedad.Grid.Rows
    While Not rs.EOF
    
      With .Add(Nothing, rs(cscPbmiaId).Value)
        
        With .Add(Nothing)
          .Value = rs(cscPbmiaId).Value
          .Key = KI_PBMIA_ID
        End With
        
        pr_nombre = gDB.ValField(rs.fields, cscPrNombreCompra)
        m_Alternativas = m_Alternativas & pr_nombre & ", "
        
        With .Add(Nothing)
          .Value = pr_nombre
          .Id = gDB.ValField(rs.fields, cscPrId)
          .Key = KI_PR_ID_I
        End With
      
      End With
      
      rs.MoveNext
    Wend
  
  End With
  
  pLoadItem = True
End Function

Private Function pIsEmptyRowI(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim bRowIsEmpty           As Boolean
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_PR_ID_I
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowI = bRowIsEmpty
End Function

Private Function pValidateRowI(Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_PR_ID_I
        If ValEmpty(Cell.Id, csId) Then
          MsgInfo LNGGetText(1354, vbNullString, strRow) 'Debe indicar un artículo (1)
          Exit Function
        End If
    End Select
  Next
  
  pValidateRowI = True
End Function

Private Function pSaveItems() As Boolean
  
  Dim pbmit_id  As Boolean
  Dim register  As cRegister
  Dim fields    As cFields
  Dim IProperty As cIABMProperty
  
  With m_ObjAbm.Properties.Item(c_items)
    Dim Row  As cIABMGridRow
    Dim Cell As cIABMGridCellValue
    
    For Each Row In .Grid.Rows
    
      Set register = New cRegister
      
      With register
        Set fields = .fields
        .fieldId = cscPbmiaId
        .Table = csTProductoBOMItemA
        .Id = csNew
        
        For Each Cell In Row
          Select Case Cell.Key
            
            Case KI_PBMIA_ID
              .Id = Val(Cell.Value)
            Case KI_PR_ID_I
              fields.Add2 cscPrId, Cell.Id, csId
          End Select
        Next
        
        fields.Add2 cscPbmiId, m_Id, csId
        
        fields.HaveLastUpdate = False
        fields.HaveWhoModify = False
        
      End With
      
      If Not gDB.Save(register, , "pSaveItems", C_Module, c_ErrorSave) Then Exit Function
    Next
  End With
  
  Dim sqlstmt As String
  
  If LenB(m_ItemsDeletedI) Then
    m_ItemsDeletedI = RemoveLastColon(m_ItemsDeletedI)
    sqlstmt = "delete productoBOMItemA where pbmia_id in (" & m_ItemsDeletedI & ")"
  
    If Not gDB.Execute(sqlstmt, "pSaveItems", C_Module) Then Exit Function
  End If
  
  sqlstmt = "sp_ProductoBOMSave " & m_pbm_id
  If Not gDB.Execute(sqlstmt, "pSaveItems", C_Module) Then Exit Function
  
  pSaveItems = True
End Function

Private Sub Class_Initialize()
  On Error GoTo ControlError

  c_ErrorSave = LNGGetText(3060, vbNullString) 'Error al grabar los Insumos

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

' construccion - destruccion
Private Sub Class_Terminate()
  Set m_ObjAbm = Nothing
End Sub

'//////////////////////////////
'  Codigo estandar de errores
'  On Error GoTo ControlError
'
'  GoTo ExitProc
'ControlError:
'  MngError err,"", C_Module, ""
'  If Err.Number <> 0 Then Resume ExitProc
'ExitProc:
'  On Error Resume Next

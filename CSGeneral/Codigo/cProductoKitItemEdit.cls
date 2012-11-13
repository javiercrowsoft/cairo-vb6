VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cProductoKitItemEdit"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIABMClient
Implements CSInterfacesABM.cIABMClientGrid
'--------------------------------------------------------------------------------
' cProductoKitItemEdit
' 13-08-2006

'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes

Private Const C_Module = "cProductoKitItemEdit"

Private Const c_Items = "Items"

Private Const K_ITEMS          As Integer = 1

Private Const KI_PRKA_ID                  As Integer = 1
Private Const KI_PR_ID                    As Integer = 2
Private Const KI_ACTIVO                   As Integer = 3

' estructuras
' variables privadas

Private m_Producto          As String
Private m_bEditable         As Boolean

Private m_ObjAbm            As cIABMGeneric
Private m_ItemsDeleted      As String
Private m_Descrip           As String

' Para contener las alternativas
'
Private m_CollAlt           As Collection

' propiedades publicas
Public Property Get ItemsDeleted() As String
  ItemsDeleted = m_ItemsDeleted
End Property

Public Property Get CollAlt() As Collection
  Set CollAlt = m_CollAlt
End Property

Public Property Get descrip() As String
  descrip = m_Descrip
End Property

' propiedades privadas
' funciones publicas
Public Function Edit(ByRef ObjAbm As cIABMGeneric, _
                     ByRef CollAlt As Collection, _
                     ByVal ItemsDel As String, _
                     ByVal bEditable As Boolean, _
                     ByVal Producto As String) As Boolean
  
  m_bEditable = bEditable
  m_Producto = Producto
  
  Set m_ObjAbm = ObjAbm
  m_ItemsDeleted = ItemsDel
  Set m_CollAlt = CollAlt
  
  If m_CollAlt Is Nothing Then
    Set m_CollAlt = New Collection
  End If
  
  Dim AbmObj As cABMGeneric
  
  Set AbmObj = m_ObjAbm
  AbmObj.OkCancelDialog = True
  m_ObjAbm.InModalWindow = True
  
  If Not LoadCollection() Then Exit Function
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  Edit = AbmObj.OkCancelDialogRslt
  
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

End Property

Private Property Get cIABMClient_CanCopy() As Boolean

End Property

Private Property Get cIABMClient_CanNew() As Boolean

End Property

Private Function cIABMClient_ShowDocDigital() As Boolean

End Function

Private Function cIABMClient_MessageEx(ByVal MessageID As Long, ByVal Info As Variant) As Variant
  cIABMClient_MessageEx = True
End Function

Private Sub cIABMClient_DiscardChanges()
  LoadCollection
End Sub

Private Function cIABMClient_ListAdHock(Lista As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClient_Load()

End Sub

Private Function cIABMClient_PropertyChange(ByVal Key As Integer) As Boolean

End Function

Private Function cIABMClient_Save() As Boolean
  cIABMClient_Save = pSaveItems()
End Function

Private Function cIABMClient_Terminate() As Boolean
  cIABMClient_Terminate = True
End Function

Private Property Get cIABMClient_Title() As String
  cIABMClient_Title = LNGGetText(1376, vbNullString) 'Alternativas
End Property

Private Function cIABMClient_Validate() As Boolean
  cIABMClient_Validate = True
End Function

' Implementacion de cIABMClientGrid
Private Function cIABMClientGrid_ColumnAfterEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long) As Boolean
  cIABMClientGrid_ColumnAfterEdit = True
End Function

Private Function cIABMClientGrid_ColumnBeforeEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean
  cIABMClientGrid_ColumnBeforeEdit = True
End Function

Private Function cIABMClientGrid_ColumnButtonClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean

End Function

Private Sub cIABMClientGrid_ColumnCancelEdit(ByVal Key As Integer)

End Sub

Private Function cIABMClientGrid_DeleteRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal lRow As Long) As Boolean
  Dim Id As Long
  
  Id = Val(pCell(Row, KI_PRKA_ID).Value)
  
  If Id <> csNO_ID Then m_ItemsDeleted = m_ItemsDeleted & Id & C_StrColon
  
  cIABMClientGrid_DeleteRow = True
End Function

Private Function cIABMClientGrid_ListAdHock(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal ColIndex As Long, List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClientGrid_NewRow(ByVal Key As Integer, ByVal Rows As Integer)

End Sub

Private Sub cIABMClientGrid_ColumnClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Sub cIABMClientGrid_DblClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Function cIABMClientGrid_ValidateRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_ITEMS
      cIABMClientGrid_ValidateRow = pValidateRowItems(Row, RowIndex)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, C_ValidateRow, C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIABMClientGrid_ColumnAfterUpdate(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long) As Boolean

End Function

Private Function cIABMClientGrid_IsEmptyRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_ITEMS
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowItems(Row, RowIndex)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, C_IsEmptyRow, C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pIsEmptyRowItems(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell              As cIABMGridCellValue
  Dim bRowIsEmpty       As Boolean
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      
      Case KI_PR_ID
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowItems = bRowIsEmpty
End Function

Private Function pValidateRowItems(Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell              As cIABMGridCellValue
  Dim strRow            As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    
    Select Case Cell.Key
      
      Case KI_PR_ID
        If ValEmpty(Cell.Id, csId) Then
          MsgInfo LNGGetText(1364, vbNullString, strRow)
                'Debe indicar un artículo
          Exit Function
        End If
        
    End Select
  Next
  
  pValidateRowItems = True
End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  
  Dim c As cIABMProperty
  
  With m_ObjAbm
  
    .Title2 = m_Producto
    
    With .Properties
      
      .Clear
    
      Set c = .Add(Nothing, c_Items)
      With c
        .PropertyType = cspGrid
        .LeftLabel = -1
        If Not pLoadItems(c) Then Exit Function
        .Name = LNGGetText(1371, vbNullString)  ' Items
        .Key = K_ITEMS
        .GridAdd = True
        .GridEdit = True
        .GridRemove = m_bEditable
      End With
    End With
  End With

  LoadCollection = True
End Function

Private Function pSaveItems() As Boolean
  
  Dim Row  As cIABMGridRow
  Dim Cell As cIABMGridCellValue
  Dim Item As cProductoKitItemA
  
  Dim coll As Collection
  Set coll = New Collection
  
  With m_ObjAbm.Properties.Item(c_Items)
    
    For Each Row In .Grid.Rows
    
      Set Item = New cProductoKitItemA
    
      For Each Cell In Row
        Select Case Cell.Key
          
          Case KI_PRKA_ID
            Item.Id = Val(Cell.Value)
            
          Case KI_PR_ID
            Item.Pr_id = Cell.Id
            Item.Nombre = Cell.Value
            m_Descrip = m_Descrip & Cell.Value & ","
          
          Case KI_ACTIVO
            Item.Activo = Cell.Id
          
        End Select
      Next
      
      coll.Add Item
    
    Next
  End With
  
  m_Descrip = RemoveLastColon(m_Descrip)
  Set m_CollAlt = coll
  
  pSaveItems = True
End Function

Private Function pLoadItems(ByRef Propiedad As cIABMProperty) As Boolean
  
  Dim Item As cProductoKitItemA
  
  With Propiedad.Grid
    
    With .Columns
    
      .Clear
    
      With .Add(Nothing)
        .Visible = False
        .Key = KI_PRKA_ID
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1367, vbNullString) 'Artículo
        .PropertyType = cspHelp
        .Table = csProducto
        .Width = 2500
        .Key = KI_PR_ID
      End With
      
      With .Add(Nothing)
        .Name = C_strActivo
        .PropertyType = cspCheck
        .Width = 1000
        .Key = KI_ACTIVO
        Set .DefaultValue = New cABMGridRowValue
        .DefaultValue.Id = 1
      End With
      
    End With
    
    With .Rows
      
      .Clear
      
      For Each Item In m_CollAlt
      
        If Item.Id = csNO_ID Then
          Item.Id = (.Count + 1) * -1
        End If
      
        With .Add(Nothing, Item.Id)
        
          With .Add(Nothing)
            .Value = Item.Id
            .Key = KI_PRKA_ID
          End With
          
          With .Add(Nothing)
            .Value = Item.Nombre
            .Id = Item.Pr_id
            .Key = KI_PR_ID
          End With
          
          With .Add(Nothing)
            .Id = Item.Activo
            .Key = KI_ACTIVO
          End With
         
         End With
         
      Next
    
    End With
    
  End With
  
  pLoadItems = True
End Function

' construccion - destruccion
Private Sub Class_Terminate()
  On Error Resume Next
  Set m_ObjAbm = Nothing
End Sub

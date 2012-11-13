VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cDocumentoImpresora"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIABMClient
Implements CSInterfacesABM.cIABMClientGrid
Implements CSMenu.cIMenuClient
'--------------------------------------------------------------------------------
' cDocumentoImpresora
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
Private Const C_Module = "cDocumentoImpresora"

Private Const c_items = "Items"

Private Const K_ITEMS       As Integer = 1

Private Const KI_DOCI_ID    As Integer = 1
Private Const KI_DOC_ID     As Integer = 2
Private Const KI_TA_ID      As Integer = 3
Private Const KI_PC         As Integer = 4
Private Const KI_IMPRESORA  As Integer = 5
Private Const KI_BANDEJA    As Integer = 6
Private Const KI_TOSERVICE  As Integer = 7

' Seudo - Variables
Private c_ErrorSave         As String

' estructuras
' variables privadas

Private m_IetmsDeleted      As String

Private m_ObjAbm            As cIABMGeneric

Private m_Host              As CSMenu.cIMenuHost

' Properties privadas
' funciones publicas

Public Function Edit() As Boolean
  On Error GoTo ControlError
  
  If Not SecurityCanAccess(csPreDEditDocumentoImpresora) Then Exit Function

  Set m_ObjAbm = New CSABMInterface2.cABMGeneric
  
  If Not Load() Then Exit Function
  
  If Not LoadCollection() Then Exit Function
  
  Edit = True
  
  Exit Function
ControlError:
  MngError Err, "Edit", "cDocumentoImpresora", vbNullString
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
  cIABMClient_Title = LNGGetText(3540, vbNullString) 'Configuración de Impresoras
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
  cIABMClientGrid_ColumnButtonClick = True
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
      Id = pCell(Row, KI_DOCI_ID).Id
      If Id <> csNO_ID Then m_IetmsDeleted = m_IetmsDeleted & Id & ","
  
  End Select
  
  cIABMClientGrid_DeleteRow = True
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

Private Function cIMenuClient_Initialize(F As Object, Host As CSMenu.cIMenuHost) As Boolean
  On Error GoTo ControlError
  Dim str_2569 As String
  
  str_2569 = LNGGetText(2569, vbNullString) '&Documentos
  Set m_Host = Host
                                                          'Co&nfiguración
  m_Host.Server.AddMenu str_2569, csMenuConfigDocumentos, LNGGetText(1028, vbNullString), 0, True, False, True, False, True, Nothing
  m_Host.Server.AddMenu LNGGetText(3548, vbNullString), csPreDEditDocumentoImpresora, str_2569, 0, True, False, False, False, False, Me
                        '&Configuración de Impresoras
  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, "cIMenuClient_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal Id As Long) As Variant
  Edit
End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  Dim c As cIABMProperty
  
  m_ObjAbm.Title2 = LNGGetText(3540, vbNullString) 'Configuración de Impresoras

  With m_ObjAbm.Properties
  
    .Clear
    
    With .Add(Nothing)
      .PropertyType = cspLabel
      .Value = LNGGetText(3549, vbNullString) 'Configure la impresora a utilizar para documentos y talonarios
      .Width = 6000
      .Left = 400
      .FontBold = True
    End With
    
    Set c = .Add(Nothing, c_items)
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      If Not pLoadItems(c) Then Exit Function
      .Name = LNGGetText(3541, vbNullString) 'Impresoras
      .Key = K_ITEMS
      .Top = 1400
      .Left = 200
      .GridAdd = True
      .GridEdit = True
      .GridRemove = True
    End With
    
    m_IetmsDeleted = vbNullString
    
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
  
  sqlstmt = "select doci.*,doc_nombre,ta_nombre from DocumentoImpresora doci " & _
             " left join Documento doc on doci.doc_id = doc.doc_id " & _
             " left join Talonario ta on doci.ta_id = ta.ta_id" & _
             " order by doci_pc"
   
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadItems", C_Module) Then Exit Function
    
  With Propiedad.Grid
    
    With .Columns
      .Clear
  
      With .Add(Nothing)
        .Key = KI_DOCI_ID
        .Visible = False
      End With
  
      Dim c As cIABMGridColumn
      Dim oc As cABMGridColumn
      
      Set c = .Add(Nothing)
      With c
        .Name = LNGGetText(1567, vbNullString) 'Documento
        .PropertyType = cspHelp
        .Table = csETablasDocumento.CSDocumento
        .Width = 2000
        .Key = KI_DOC_ID
        Set oc = c
        oc.IsForAbm = True
      End With
  
      With .Add(Nothing)
        .Name = LNGGetText(1256, vbNullString) 'Talonario
        .PropertyType = cspHelp
        .Table = csETablasDocumento.csTalonario
        .Width = 2000
        .Key = KI_TA_ID
      End With
  
      With .Add(Nothing)
        .Name = LNGGetText(3542, vbNullString) 'PC
        .PropertyType = cspText
        .Width = 3000
        .Key = KI_PC
      End With
  
      With .Add(Nothing)
        .Name = LNGGetText(3544, vbNullString) 'Impresora
        .PropertyType = cspText
        .Width = 3000
        .Key = KI_IMPRESORA
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(3543, vbNullString) 'Bandeja
        .PropertyType = cspText
        .Width = 3000
        .Key = KI_BANDEJA
      End With
  
      With .Add(Nothing)
        .Name = LNGGetText(5089, vbNullString) 'Imprimir por Servicio
        .PropertyType = cspCheck
        .Width = 3000
        .Key = KI_TOSERVICE
      End With
    
    End With
  
    With .Rows
      
      .Clear
      
      While Not rs.EOF
      
        With .Add(Nothing)
        
          With .Add(Nothing)
            .Id = gDB.ValField(rs.fields, cscDociId)
            .Key = KI_DOCI_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscDocNombre)
            .Id = gDB.ValField(rs.fields, cscDocId)
            .Key = KI_DOC_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscTaNombre)
            .Id = gDB.ValField(rs.fields, cscTaId)
            .Key = KI_TA_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscDociPC)
            .Key = KI_PC
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscDociImpresora)
            .Key = KI_IMPRESORA
          End With
        
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscDociBandeja)
            .Key = KI_BANDEJA
          End With
        
          With .Add(Nothing)
            .Id = gDB.ValField(rs.fields, cscDociPrintByService)
            .Key = KI_TOSERVICE
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
                                
  Dim Cell                  As cIABMGridCellValue
  Dim bRowIsEmpty           As Boolean
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_DOC_ID
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KI_TA_ID
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KI_PC
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KI_IMPRESORA
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KI_BANDEJA
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRow = bRowIsEmpty
End Function

Private Function pValidateRow(ByRef Row As CSInterfacesABM.cIABMGridRow, _
                              ByVal RowIndex As Long) As Boolean
                                 
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  Dim bDocIdOrTaId          As Boolean
  
  strRow = " (Fila " & RowIndex & ")"
  
  CSKernelClient2.Title = LNGGetText(2620, vbNullString) 'Permisos
  
  For Each Cell In Row
    Select Case Cell.Key
        Case KI_DOC_ID
          If Not ValEmpty(Cell.Id, csId) Then
            bDocIdOrTaId = True
          End If
        Case KI_TA_ID
          If Not ValEmpty(Cell.Id, csId) Then
            bDocIdOrTaId = True
          End If
        Case KI_IMPRESORA
          If ValEmpty(Cell.Value, csText) Then
            MsgInfo LNGGetText(3546, vbNullString, strRow) 'Debe indicar una impresora
            Exit Function
          End If
    End Select
  Next
  
  If Not bDocIdOrTaId Then
    MsgInfo LNGGetText(3545, vbNullString, strRow) 'Debe indicar un documento o un talonario o ambos
    Exit Function
  End If
  
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
        .fieldId = cscDociId
        .Table = csTDocumentoImpresora
        .fieldId = cscDociId
          
        .Id = pCell(Row, KI_DOCI_ID).Id
        
        .fields.Add2 cscDocId, pCell(Row, KI_DOC_ID).Id, csId
        .fields.Add2 cscTaId, pCell(Row, KI_TA_ID).Id, csId
        .fields.Add2 cscDociPC, pCell(Row, KI_PC).Value, csText
        .fields.Add2 cscDociImpresora, pCell(Row, KI_IMPRESORA).Value, csText
        .fields.Add2 cscDociBandeja, pCell(Row, KI_BANDEJA).Value, csText
        .fields.Add2 cscDociPrintByService, pCell(Row, KI_TOSERVICE).Id, csBoolean
        
        .fields.HaveLastUpdate = True
        .fields.HaveWhoModify = True
                  
      End With
      
      If Not gDB.Save(register, , _
                      "pSave", C_Module, c_ErrorSave) Then Exit Function
    
    Next
  
  End With
  
  If LenB(m_IetmsDeleted) Then
    m_IetmsDeleted = RemoveLastColon(m_IetmsDeleted)
    sqlstmt = "delete DocumentoImpresora where doci_id in (" & m_IetmsDeleted & ")"
  
    If Not gDB.Execute(sqlstmt, "pSave", C_Module) Then Exit Function
  End If
  
  pSave = True
End Function

Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  c_ErrorSave = LNGGetText(3547, vbNullString)  'Error al grabar la configuración de impresoras
  
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

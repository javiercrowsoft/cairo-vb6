VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cCurso"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGeneric
Implements CSInterfacesABM.cIABMClient
Implements CSInterfacesABM.cIABMClientGrid
Implements CSMenu.cIMenuClient
'--------------------------------------------------------------------------------
' cCurso
' 31-10-08

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
  ' constantes
  ' estructuras
  ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cCurso"

Private Const c_fixed_col = 4

Private Const c_calif = "calif"
Private Const c_clases = "clases"
Private Const c_examen = "examen"

Private Const K_NOMBRE             As Integer = 1
Private Const K_CODIGO             As Integer = 2
Private Const K_DESCRIP            As Integer = 3
Private Const K_FECHADESDE         As Integer = 5
Private Const K_FECHAHASTA         As Integer = 6
Private Const K_PROF_ID            As Integer = 7
Private Const K_MAT_ID             As Integer = 9

Private Const K_PROF_ID_ayudante1  As Integer = 10
Private Const K_PROF_ID_ayudante2  As Integer = 11
Private Const K_PROF_ID_ayudante3  As Integer = 12
Private Const K_PROF_ID_ayudante4  As Integer = 13
Private Const K_PROF_ID_ayudante5  As Integer = 14

Private Const K_ITEMS              As Integer = 100
Private Const K_CALIF              As Integer = 101
Private Const K_CLASES             As Integer = 102
Private Const K_EXAMEN             As Integer = 103

Private Const KI_ITEM_ID           As Integer = 1
Private Const KI_ALUM_ID           As Integer = 2
Private Const KI_PROF_ID           As Integer = 3
Private Const KI_CALIF             As Integer = 3 ' Son iguales por que estan en distintas grillas

Private Const KI_FECHA             As Integer = 2
Private Const KI_DESDE             As Integer = 3
Private Const KI_HASTA             As Integer = 4
Private Const KI_HORAS             As Integer = 5
Private Const KI_AULA_ID           As Integer = 6

' Seudo - Variables
Private c_ErrorSave          As String

' estructuras
' variables privadas
Private m_Id                 As Long
Private m_Nombre             As String
Private m_Codigo             As String
Private m_descrip            As String
Private m_Desde              As Date
Private m_Hasta              As Date
Private m_prof_id            As Long
Private m_Profesor           As String
Private m_mat_id             As Long
Private m_Materia            As String

Private m_ayudante1          As String
Private m_prof_id1           As Long
Private m_ayudante2          As String
Private m_prof_id2           As Long
Private m_ayudante3          As String
Private m_prof_id3           As Long
Private m_ayudante4          As String
Private m_prof_id4           As Long
Private m_ayudante5          As String
Private m_prof_id5           As Long

Private m_Editing       As Boolean

Private m_ObjAbm        As cIABMGeneric
Private m_ObjTree       As Object

Private m_IsNew         As Boolean

Private m_BranchId      As Long
Private m_TreeId        As Long

Private m_Host          As CSMenu.cIMenuHost
Private m_Copy          As Boolean

Private m_ItemsDeleted          As String
Private m_ItemsDeletedCalif     As String
Private m_ItemsDeletedClases    As String
Private m_ItemsDeletedExamenes  As String

Private m_GenericEdit       As cGenericEdit

' propiedades friend
' propiedades privadas
' funciones publicas

' Implementacion de cIABMClient
Private Function cIABMClient_Copy() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True
  
  With m_ObjAbm.Properties(cscCurNombre)
    .Value = C_CopiaDe & .Value
  End With
  
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscCurNombre)
  
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

  Doc.ClientTable = csTCurso
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
  
    Case MSG_DOC_SEARCH
      
      pSearch
  
      cIABMClient_MessageEx = True
    
    Case MSG_ABM_PRINT
      
      If m_Id = csNO_ID Then
                ' "Debe grabar el curso para poder imprimirlo"
        MsgInfo LNGGetText(4743, vbNullString), LNGGetText(1853, vbNullString)
              
      Else
        Dim AbmObj As cABMGeneric
        Set AbmObj = m_ObjAbm
        AbmObj.PrintABM m_Id, -csCurso ' El menos es para que pase Id y no NODO Id en PrintManager
      End If
      
      cIABMClient_MessageEx = True
    
    Case MSG_ABM_CAN_PRINT
      
      cIABMClient_MessageEx = MSG_ABM_CAN_PRINT
  
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
  Dim LastId     As Long
  
  Set register = New cRegister
  
  With register
    Set fields = .fields
      
    .fieldId = cscCurId
    .Table = csTCurso
  
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
          fields.Add2 cscCurNombre, .Value, csText
        Case K_CODIGO
          fields.Add2 cscCurCodigo, .Value, csText
        Case K_DESCRIP
          fields.Add2 cscCurDescrip, .Value, csText
        Case K_FECHADESDE
          fields.Add2 cscCurDesde, .Value, csDate
        Case K_FECHAHASTA
          fields.Add2 cscCurHasta, .Value, csDate
        Case K_PROF_ID
          fields.Add2 cscProfId, .HelpId, csId
        Case K_MAT_ID
          fields.Add2 cscMatId, .HelpId, csId
      End Select
    End With
  Next
    
  If Not m_GenericEdit.Save(m_ObjAbm, register) Then Exit Function

  fields.HaveLastUpdate = True
  fields.HaveWhoModify = True
  
  If Not register.BeginTrans(gDB) Then Exit Function
  
  If Not gDB.SaveEx(register, , _
                  cscCurCodigo, _
                  "cIABMClient_Save", _
                  C_Module, _
                  c_ErrorSave) Then Exit Function
  
  LastId = m_Id
  m_Id = register.Id
  
  If Not pSaveClases() Then GoTo SaveError
  If Not pSaveExamenes() Then GoTo SaveError
  If Not pSaveItems() Then GoTo SaveError
  If Not pSaveCalificaciones() Then GoTo SaveError
  
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_CursoSave " & register.Id
                                        
  If Not gDB.OpenRs(sqlstmt, rs) Then GoTo SaveError
  
  If rs.EOF Then GoTo SaveError
  
  If gDB.ValField(rs.fields, "success") = 0 Then GoTo SaveError
  
  If Not register.CommitTrans() Then GoTo SaveError
  
  pShowWarning rs
  
  m_Copy = False
  cIABMClient_Save = Load(register.Id)

  Exit Function
SaveError:

  m_Id = LastId
End Function

Private Sub pShowWarning(ByRef rs As ADODB.Recordset)
  On Error Resume Next
  
  If gDB.ValField(rs.fields, "warning") Then
  
    Dim msg As String
    msg = gDB.ValField(rs.fields, "message")
    
    MsgWarning msg
    
    Dim ErrorDetail As Object
    
    Set rs = rs.NextRecordset
    
    While Not rs Is Nothing
  
      If rs.State = adStateOpen Then
        
        If Not rs.EOF Then
        
          Set ErrorDetail = CSKernelClient2.CreateObject("CSMessageAux.cMessageAux")
          ErrorDetail.ShowMessageFromRecordset "Info", rs, Me
        End If
      End If
      
      Err.Clear
      Set rs = rs.NextRecordset
      If Err.Number Then Exit Sub
      
    Wend
    
  End If

End Sub

Private Function cIABMClient_Terminate() As Boolean
  m_Editing = False
  
  cIABMClient_Terminate = True
  ' Este objeto puede no cumplir con la interfaz esperada, asi que si hay un error no
  ' le doy bola
  On Error GoTo ControlError
  If m_Id = csNO_ID Then Exit Function
  If m_ObjTree Is Nothing Then Exit Function
  
  m_ObjTree.sqlstmt = "sp_lsdoc_Curso"
  
  If m_IsNew Then
    m_ObjTree.AddLine m_Id
  Else
    m_ObjTree.RefreshLine m_Id
  End If
ControlError:
End Function

Private Property Get cIABMClient_Title() As String
                      'Cursos
  cIABMClient_Title = LNGGetText(4694, vbNullString)
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
        Case K_FECHADESDE
          If ValEmpty(.Value, csDate) Then
            MsgInfo LNGGetText(2393, vbNullString) 'Debe indicar una fecha desde
            Exit Function
          End If
        Case K_FECHAHASTA
          If ValEmpty(.Value, csDate) Then
            MsgInfo LNGGetText(2394, vbNullString) 'Debe indicar una fecha hasta
            Exit Function
          End If
        Case K_MAT_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(4709, vbNullString) 'Debe indicar una materia
            Exit Function
          End If
      End Select
    End With
  Next

  If Not m_GenericEdit.Validate(m_ObjAbm) Then Exit Function

  cIABMClient_Validate = True
End Function

'-------------------------------------------------------------------------------------
' Implementacion de cIABMClientGrid
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
      Id = pCell(Row, KI_ALUM_ID).Id
      If Id <> csNO_ID Then m_ItemsDeleted = m_ItemsDeleted & Id & C_StrColon
    Case K_CLASES
      Id = Val(pCell(Row, KI_ITEM_ID).Value)
      If Id <> csNO_ID Then m_ItemsDeletedClases = m_ItemsDeletedClases & Id & C_StrColon
    Case K_EXAMEN
      Id = Val(pCell(Row, KI_ITEM_ID).Value)
      If Id <> csNO_ID Then m_ItemsDeletedExamenes = m_ItemsDeletedExamenes & Id & C_StrColon
    Case K_CALIF
      Id = pCell(Row, KI_ALUM_ID).Id
      If Id <> csNO_ID Then m_ItemsDeletedCalif = m_ItemsDeletedCalif & Id & C_StrColon
  End Select
  cIABMClientGrid_DeleteRow = True
End Function

Private Function cIABMClientGrid_IsEmptyRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_ITEMS
      cIABMClientGrid_IsEmptyRow = pIsEmptyRow(Row, RowIndex)
    Case K_CALIF
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowCalif(Row, RowIndex)
    Case K_CLASES
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowClases(Row, RowIndex)
    Case K_EXAMEN
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowExamenes(Row, RowIndex)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, C_ValidateRow, C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pIsEmptyRow(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim bRowIsEmpty           As Boolean
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_ALUM_ID
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRow = bRowIsEmpty
End Function

Private Function pIsEmptyRowCalif(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim bRowIsEmpty           As Boolean
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_ALUM_ID
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowCalif = bRowIsEmpty
End Function

Private Function pIsEmptyRowExamenes(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim bRowIsEmpty           As Boolean
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_FECHA
        If Not ValEmpty(Cell.Value, csDate) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowExamenes = bRowIsEmpty
End Function

Private Function pIsEmptyRowClases(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim bRowIsEmpty           As Boolean
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_FECHA
        If Not ValEmpty(Cell.Value, csDate) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowClases = bRowIsEmpty
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
    Case K_CALIF
      cIABMClientGrid_ValidateRow = pValidateRowCalif(Row, RowIndex)
    Case K_CLASES
      cIABMClientGrid_ValidateRow = True
    Case K_EXAMEN
      cIABMClientGrid_ValidateRow = True
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, C_ValidateRow, C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pValidateRow(Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_ALUM_ID
        If ValEmpty(Cell.Value, csText) Then
          MsgInfo LNGGetText(4708, vbNullString) 'Debe indicar un alumno #1#
          Exit Function
        End If
    End Select
  Next
  
  pValidateRow = True
End Function

Private Function pValidateRowCalif(Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_ALUM_ID
        If ValEmpty(Cell.Value, csText) Then
          MsgInfo LNGGetText(4708, vbNullString) 'Debe indicar un alumno #1#
          Exit Function
        End If
    End Select
  Next
  
  pValidateRowCalif = True
End Function

'-------------------------------------------------------------------------------------
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
  cIEditGeneric_ShowList = SecurityCanAccess(csPreEListCurso)
End Function

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
  Set m_ObjAbm = rhs
End Property

Private Property Get cIEditGeneric_Editing() As Boolean
  cIEditGeneric_Editing = m_Editing
End Property

Private Function cIEditGeneric_Delete(Id As Long) As Boolean
  If Not SecurityCanAccess(csPreEDeleteCurso) Then Exit Function
  
  Dim sqlstmt As String
  
  sqlstmt = "sp_CursoDelete " & Id
  
  cIEditGeneric_Delete = gDB.Execute(sqlstmt, "cIEditGeneric_Delete", C_Module)
End Function

Private Function cIEditGeneric_Search(Id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Id = csNO_ID Then
    m_IsNew = True
    If Not SecurityCanAccess(csPreENewCurso) Then Exit Function
  Else
    m_IsNew = False
    If Not SecurityCanAccess(csPreEEditCurso) Then Exit Function
  End If

  m_ObjAbm.InModalWindow = InModalWindow
  
  Set m_GenericEdit = New cGenericEdit
  If Not m_GenericEdit.Init(csCurso) Then Exit Function
  
  If Not Load(Id) Then Exit Function
  
  If Not LoadCollection() Then Exit Function
  
  m_Editing = True
  m_Copy = False
  
  ' JMA I
  If InModalWindow Then
    cIEditGeneric_Edit = m_Id <> csNO_ID
  Else
    cIEditGeneric_Edit = True
  End If
' JMA I

  Exit Function
ControlError:
  MngError Err, "cIEditGeneric_Edit", C_Module, vbNullString
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

' funciones privadas
Private Function LoadCollection() As Boolean
  Dim c As cIABMProperty
  Dim iProp As cABMProperty
  
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  AbmObj.MinHeight = 6600
  AbmObj.MinWidth = 11000
  
  Const c_tab_general = 0
  Const c_tab_calif = 1
  Const c_tab_clases = 2
  Const c_tab_examenes = 3
  Const c_tab_ayudantes = 4
  
  With m_ObjAbm.Tabs
    .Clear
    
      .Clear
    
      With .Add(Nothing)
        .Name = C_strGeneral
      End With
      
      With .Add(Nothing)
        .Index = c_tab_calif
        .Name = LNGGetText(4697, vbNullString) 'Calificaciones
      End With
      
      With .Add(Nothing)
        .Index = c_tab_clases
        .Name = LNGGetText(4696, vbNullString) 'Clases
      End With
      
      With .Add(Nothing)
        .Index = c_tab_examenes
        .Name = LNGGetText(4705, vbNullString) 'Examenes
      End With
      
      With .Add(Nothing)
        .Index = c_tab_ayudantes
        .Name = LNGGetText(4698, vbNullString) 'Ayudantes
      End With

  End With
  
  With m_ObjAbm.Properties
    .Clear
    
    With .Add(Nothing, cscCurNombre)
      .PropertyType = cspText
      .Name = C_strNombre
      .Width = 4000
      .Value = m_Nombre
      .Key = K_NOMBRE
    End With
            
    With .Add(Nothing, cscCurCodigo)
      .PropertyType = cspText
      .Name = C_strCodigo
      .Width = 1000
      .Value = m_Codigo
      .Key = K_CODIGO
    End With
                
    With .Add(Nothing, cscCurDesde)
      .PropertyType = cspDate
      .Name = LNGGetText(2532, vbNullString)  'Desde
      .Key = K_FECHADESDE
      .Value = m_Desde
    End With
    
    With .Add(Nothing, cscCurHasta)
      .PropertyType = cspDate
      .Name = LNGGetText(2533, vbNullString)  'Hasta
      .Key = K_FECHAHASTA
      .Value = m_Hasta
      .TopFromProperty = cscCurDesde
      .Left = 4000
      .LeftLabel = -600
    End With
    
    With .Add(Nothing, cscMatId)
      .PropertyType = cspHelp
      .Table = csMateria
      .Name = LNGGetText(4684, vbNullString)  'Materia
      .Key = K_MAT_ID
      .Value = m_Materia
      .HelpId = m_mat_id
      .TopFromProperty = cscCurNombre
      .Left = 7000
      .LeftLabel = -700
      .LeftNotChange = True
      .Width = 4000
    End With
    
    With .Add(Nothing, cscProfId)
      .PropertyType = cspHelp
      .Table = csProfesor
      .Name = LNGGetText(4682, vbNullString)  'Profesor
      .Key = K_PROF_ID
      .Value = m_Profesor
      .HelpId = m_prof_id
      .TopFromProperty = cscMatId
      .TopToPrevious = 440
      .Left = 7000
      .LeftLabel = -700
      .Width = 4000
    End With
    
    With .Add(Nothing, cscCurDescrip)
      .PropertyType = cspText
      .Width = 9500
      .Height = 880
      .SubType = cspMemo
      .Name = C_strDescrip
      .Size = 7000
      .Key = K_DESCRIP
      .Value = m_descrip
      .TopFromProperty = cscCurDesde
      .TopToPrevious = 440
      .LeftFromProperty = cscCurDesde
    End With
    
    ' Asistencias
    
    Set c = .Add(Nothing, c_Items)
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      If Not pLoadItems(c) Then Exit Function
      .Name = c_Items
      .Key = K_ITEMS
      .GridAdd = True
      .GridEdit = True
      .GridRemove = True
      .Top = 3400
      .Left = 200
    End With
    
    m_ItemsDeleted = vbNullString
    
    ' Calificaciones
    
    Set c = .Add(Nothing, c_calif)
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      If Not pLoadCalificaciones(c) Then Exit Function
      .Name = c_calif
      .Key = K_CALIF
      .GridAdd = True
      .GridEdit = True
      .GridRemove = True
      .TabIndex = c_tab_calif
      .Top = 1000
    End With
    
    m_ItemsDeletedCalif = vbNullString
    
    ' Clases
    
    Set c = .Add(Nothing, c_clases)
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      If Not pLoadClases(c) Then Exit Function
      .Name = c_clases
      .Key = K_CLASES
      .GridAdd = True
      .GridEdit = True
      .GridRemove = True
      .TabIndex = c_tab_clases
      .Top = 1000
    End With
    
    m_ItemsDeletedClases = vbNullString
    
    ' Examenes
    
    Set c = .Add(Nothing, c_examen)
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      If Not pLoadExamenes(c) Then Exit Function
      .Name = c_examen
      .Key = K_EXAMEN
      .GridAdd = True
      .GridEdit = True
      .GridRemove = True
      .TabIndex = c_tab_examenes
      .Top = 1000
    End With
    
    m_ItemsDeletedExamenes = vbNullString
    
    ' Ayudantes
    
    With .Add(Nothing, cscProfIdAyudante1)
      .PropertyType = cspHelp
      .Table = csProfesor
      .Name = LNGGetText(4699, vbNullString)  'Ayudante 1
      .Key = K_PROF_ID_ayudante1
      .Value = m_ayudante1
      .HelpId = m_prof_id1
      .LeftFromProperty = cscCurNombre
      .Width = 4000
      .TabIndex = c_tab_ayudantes
    End With
    
    With .Add(Nothing, cscProfIdAyudante2)
      .PropertyType = cspHelp
      .Table = csProfesor
      .Name = LNGGetText(4700, vbNullString)  'Audante 2
      .Key = K_PROF_ID_ayudante2
      .Value = m_ayudante2
      .HelpId = m_prof_id2
      .Width = 4000
      .TabIndex = c_tab_ayudantes
    End With
    
    With .Add(Nothing, cscProfIdAyudante3)
      .PropertyType = cspHelp
      .Table = csProfesor
      .Name = LNGGetText(4701, vbNullString)  'Ayudante 3
      .Key = K_PROF_ID_ayudante3
      .Value = m_ayudante3
      .HelpId = m_prof_id3
      .Width = 4000
      .TabIndex = c_tab_ayudantes
    End With
    
    With .Add(Nothing, cscProfIdAyudante4)
      .PropertyType = cspHelp
      .Table = csProfesor
      .Name = LNGGetText(4702, vbNullString)  'Ayudante 4
      .Key = K_PROF_ID_ayudante4
      .Value = m_ayudante4
      .HelpId = m_prof_id4
      .Width = 4000
      .TabIndex = c_tab_ayudantes
    End With
    
    With .Add(Nothing, cscProfIdAyudante5)
      .PropertyType = cspHelp
      .Table = csProfesor
      .Name = LNGGetText(4703, vbNullString)  'Ayudante 5
      .Key = K_PROF_ID_ayudante5
      .Value = m_ayudante5
      .HelpId = m_prof_id5
      .Width = 4000
      .TabIndex = c_tab_ayudantes
    End With
    
  End With
  
  If Not m_GenericEdit.LoadCollection(m_ObjAbm) Then Exit Function

  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

Private Function Load(ByVal Id As Long) As Boolean
  Dim sqlstmt As String
  Dim Hora    As Integer
  
  sqlstmt = "sp_CursoGet " & Id
  
  Dim rs As ADODB.Recordset
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function
  
  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.fields, cscCurId)
    m_Nombre = gDB.ValField(rs.fields, cscCurNombre)
    m_Codigo = gDB.ValField(rs.fields, cscCurCodigo)
    m_descrip = gDB.ValField(rs.fields, cscCurDescrip)
    m_Desde = gDB.ValField(rs.fields, cscCurDesde)
    m_Hasta = gDB.ValField(rs.fields, cscCurHasta)
    
    m_prof_id = gDB.ValField(rs.fields, cscProfId)
    m_Profesor = gDB.ValField(rs.fields, cscProfNombre)
    m_mat_id = gDB.ValField(rs.fields, cscMatId)
    m_Materia = gDB.ValField(rs.fields, cscMatNombre)
    
    m_prof_id1 = gDB.ValField(rs.fields, cscProfIdAyudante1)
    m_prof_id2 = gDB.ValField(rs.fields, cscProfIdAyudante2)
    m_prof_id3 = gDB.ValField(rs.fields, cscProfIdAyudante3)
    m_prof_id4 = gDB.ValField(rs.fields, cscProfIdAyudante4)
    m_prof_id5 = gDB.ValField(rs.fields, cscProfIdAyudante5)
    
    m_ayudante1 = gDB.ValField(rs.fields, cscProfNombre1)
    m_ayudante2 = gDB.ValField(rs.fields, cscProfNombre2)
    m_ayudante3 = gDB.ValField(rs.fields, cscProfNombre3)
    m_ayudante4 = gDB.ValField(rs.fields, cscProfNombre4)
    m_ayudante5 = gDB.ValField(rs.fields, cscProfNombre5)
    
  Else
    
    m_Id = csNO_ID
    m_Nombre = vbNullString
    m_Codigo = vbNullString
    m_descrip = vbNullString
    m_Desde = Date
    m_Hasta = Date
    
    m_prof_id = csNO_ID
    m_Profesor = vbNullString
    m_mat_id = csNO_ID
    m_Materia = vbNullString
    
    m_prof_id1 = csNO_ID
    m_prof_id2 = csNO_ID
    m_prof_id3 = csNO_ID
    m_prof_id4 = csNO_ID
    m_prof_id5 = csNO_ID
    
    m_ayudante1 = vbNullString
    m_ayudante2 = vbNullString
    m_ayudante3 = vbNullString
    m_ayudante4 = vbNullString
    m_ayudante5 = vbNullString
    
  End If

  If Not m_GenericEdit.Load(m_Id) Then Exit Function

  Load = True

End Function

Private Function pLoadCalificaciones(ByRef Propiedad As cIABMProperty) As Boolean

  Dim sqlstmt       As String
  Dim rs            As ADODB.Recordset
  Dim rsExamenes    As ADODB.Recordset
  
  Dim bAddRow       As Boolean
  Dim Row           As cIABMGridRow
  Dim lastAlumId    As Long
  Dim fecha         As Date
  Dim desde         As Date
  Dim fecha_key     As String
  Dim iColCant      As Long
  Dim i             As Long
  Dim Columns       As cIABMGridColumns
  
  sqlstmt = "sp_CursoGetCalificacion " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, _
                    rs, _
                    csRsStatic, _
                    csLockReadOnly, _
                    csCmdText, _
                    "pLoadCalificaciones", _
                    C_Module) Then Exit Function
  
  If Not pGetExamenes(rsExamenes) Then Exit Function

  With Propiedad.Grid
    
    Set Columns = .Columns
    
    With .Columns
      
      .Clear
      
      With .Add(Nothing)
        .Visible = False
        .Key = KI_ITEM_ID
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(4692, vbNullString) 'Alumno
        .PropertyType = cspHelp
        .Table = csAlumno
        .Width = 2500
        .Key = KI_ALUM_ID
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(4707, vbNullString) 'Final
        .PropertyType = cspNumeric
        .SubType = cspDouble
        .Width = 2500
        .Key = KI_CALIF
        .Format = "0.00"
      End With
      
      ' Se cargan dos columnas
      '
      While Not rsExamenes.EOF
                        
        fecha = gDB.ValField(rsExamenes.fields, cscCureFecha)
        desde = gDB.ValField(rsExamenes.fields, cscCureDesde)
        fecha_key = Format(fecha, "dd-mm-yy") & "-" & Format(desde, "dd-mm-yy")
        
        With .Add(Nothing, GetKey(fecha_key))
          .Name = Format(fecha, "dd-mm")
          .PropertyType = cspNumeric
          .SubType = cspDouble
          .Width = 500
          .Format = "0.00"
        End With
        
        .Add(Nothing).Visible = False
        
        rsExamenes.MoveNext
      Wend
      
      iColCant = rsExamenes.RecordCount
      
    End With
    
    With .Rows
      
      .Clear
      
      While Not rs.EOF
        
        If lastAlumId <> gDB.ValField(rs.fields, cscAlumId) Then
          
          bAddRow = True
          lastAlumId = gDB.ValField(rs.fields, cscAlumId)
          
        End If
      
        ' Si estoy en un nuevo alumno
        ' agrego una fila
        '
        If bAddRow Then
          Set Row = .Add(Nothing)
        
          With Row
            
            ' Columnas fijas de la fila
            '
            .Add(Nothing).Key = KI_ITEM_ID
            
            With .Add(Nothing)
              .Value = gDB.ValField(rs.fields, cscAlumNombre)
              .Id = gDB.ValField(rs.fields, cscAlumId)
              .Key = KI_ALUM_ID
            End With
            
            With .Add(Nothing)
              .Value = gDB.ValField(rs.fields, cscCuriCalificacion)
              .Key = KI_CALIF
            End With
          
            ' Columnas de fechas de la fila
            '
            For i = 1 To iColCant
              
              .Add(Nothing).Value = 0  ' Nota
              .Add Nothing             ' curic_id
              
            Next
          
          End With
          
          bAddRow = False
          
        End If
      
        If Not IsNull(rs.fields.Item(cscCuricId).Value) Then
      
          ' Ahora tengo que colocar en la columna correspondiente
          ' la nota y su curic_id
          '
          With Row
            
            fecha = gDB.ValField(rs.fields, cscCureFecha)
            desde = gDB.ValField(rs.fields, cscCureDesde)
            fecha_key = Format(fecha, "dd-mm-yy") & "-" & Format(desde, "dd-mm-yy")
            
            With pGetCellExamenFromKey(Row, fecha_key, Columns)
              .Value = gDB.ValField(rs.fields, cscCuricCalificacion)
            End With
            
            pGetCellIdFromKey(Row, fecha_key, Columns).Id = gDB.ValField(rs.fields, cscCuricId)
            
          End With
         
        End If
         
        rs.MoveNext
      Wend
    
    End With
    
  End With
  
  pLoadCalificaciones = True

End Function

Private Function pLoadItems(ByRef Propiedad As cIABMProperty) As Boolean

  Dim sqlstmt       As String
  Dim rs            As ADODB.Recordset
  Dim rsClases      As ADODB.Recordset
  
  Dim bAddRow       As Boolean
  Dim Row           As cIABMGridRow
  Dim lastAlumId    As Long
  Dim fecha         As Date
  Dim desde         As Date
  Dim fecha_key     As String
  Dim iColCant      As Long
  Dim i             As Long
  Dim Columns       As cIABMGridColumns
  
  sqlstmt = "sp_CursoGetItems " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, _
                    rs, _
                    csRsStatic, _
                    csLockReadOnly, _
                    csCmdText, _
                    "pLoadItems", _
                    C_Module) Then Exit Function
  
  If Not pGetClases(rsClases) Then Exit Function

  With Propiedad.Grid
    
    Set Columns = .Columns
    
    With .Columns
      
      .Clear
      
      With .Add(Nothing)
        .Visible = False
        .Key = KI_ITEM_ID
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(4692, vbNullString) 'Alumno
        .PropertyType = cspHelp
        .Table = csAlumno
        .Width = 2500
        .Key = KI_ALUM_ID
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(4794, vbNullString) 'Profesor
        .PropertyType = cspHelp
        .Table = csProfesor
        .Width = 2500
        .Key = KI_PROF_ID
      End With
      
      ' Se cargan dos columnas
      '
      While Not rsClases.EOF
                        
        fecha = gDB.ValField(rsClases.fields, cscCurcFecha)
        desde = gDB.ValField(rsClases.fields, cscCurcDesde)
        fecha_key = Format(fecha, "dd-mm-yy") & "-" & Format(desde, "dd-mm-yy")
        
        With .Add(Nothing, GetKey(fecha_key))
          .Name = Format(fecha, "dd-mm")
          .PropertyType = cspCheck
          .Width = 500
        End With
        
        .Add(Nothing).Visible = False
        
        rsClases.MoveNext
      Wend
      
      iColCant = rsClases.RecordCount
      
    End With
    
    With .Rows
      
      .Clear
      
      While Not rs.EOF
        
        If lastAlumId <> gDB.ValField(rs.fields, cscAlumId) Then
          
          bAddRow = True
          lastAlumId = gDB.ValField(rs.fields, cscAlumId)
          
        End If
      
        ' Si estoy en un nuevo alumno
        ' agrego una fila
        '
        If bAddRow Then
          Set Row = .Add(Nothing)
        
          With Row
            
            ' Columnas fijas de la fila
            '
            .Add(Nothing).Key = KI_ITEM_ID
            
            With .Add(Nothing)
              .Value = gDB.ValField(rs.fields, cscAlumNombre)
              .Id = gDB.ValField(rs.fields, cscAlumId)
              .Key = KI_ALUM_ID
            End With
            
            With .Add(Nothing)
              .Value = gDB.ValField(rs.fields, cscProfNombre)
              .Id = gDB.ValField(rs.fields, cscProfId)
              .Key = KI_PROF_ID
            End With
          
            ' Columnas de fechas de la fila
            '
            For i = 1 To iColCant
              
              .Add Nothing ' Asistencia
              .Add Nothing ' curia_id
              
            Next
          
          End With
          
          bAddRow = False
          
        End If
      
        If Not IsNull(rs.fields.Item(cscCuriaId).Value) Then
      
          ' Ahora tengo que colocar en la columna correspondiente
          ' la asistencia y su curia_id
          '
          With Row
            
            fecha = gDB.ValField(rs.fields, cscCurcFecha)
            desde = gDB.ValField(rs.fields, cscCurcDesde)
            fecha_key = Format(fecha, "dd-mm-yy") & "-" & Format(desde, "dd-mm-yy")
            
            With pGetCellClaseFromKey(Row, fecha_key, Columns)
              .Id = 1
            End With
            
            pGetCellIdFromKey(Row, fecha_key, Columns).Id = gDB.ValField(rs.fields, cscCuriaId)
            
          End With
        
        End If
         
        rs.MoveNext
      Wend
    
    End With
    
  End With
  
  pLoadItems = True

End Function

Private Function pLoadClases(ByRef Propiedad As cIABMProperty) As Boolean
  
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "select curc.*, aula_nombre" & _
            " from CursoClase curc left join Aula au" & _
               " on curc.aula_id = au.aula_id" & _
            " where curc.cur_id = " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, _
                    rs, _
                    csRsStatic, _
                    csLockReadOnly, _
                    csCmdText, _
                    "pLoadClases", _
                    C_Module) Then Exit Function
  
  With Propiedad.Grid
    
    With .Columns
      
      .Clear
      
      With .Add(Nothing)
        .Visible = False
        .Key = KI_ITEM_ID
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1569, vbNullString) 'Fecha
        .PropertyType = cspDate
        .Width = 2500
        .Key = KI_FECHA
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(2532, vbNullString) 'Desde
        .PropertyType = cspTime
        .Width = 2500
        .Key = KI_DESDE
        .Format = "hh:nn"
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(2533, vbNullString) 'Hasta
        .PropertyType = cspTime
        .Width = 2500
        .Key = KI_HASTA
        .Format = "hh:nn"
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1660, vbNullString) 'Horas
        .PropertyType = cspTime
        .Width = 2500
        .Key = KI_HORAS
        .Format = "hh:nn"
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(4704, vbNullString) 'Aula
        .PropertyType = cspHelp
        .Table = csAula
        .Width = 2500
        .Key = KI_AULA_ID
      End With
      
    End With
    
    With .Rows
      
      .Clear
      
      While Not rs.EOF
        
        With .Add(Nothing, rs(cscCurcId).Value)
      
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCurcId)
            .Key = KI_ITEM_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCurcFecha)
            .Key = KI_FECHA
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCurcDesde)
            .Key = KI_DESDE
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCurcHasta)
            .Key = KI_HASTA
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCurcHoras)
            .Key = KI_HORAS
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscAulaNombre)
            .Id = gDB.ValField(rs.fields, cscAulaId)
            .Key = KI_AULA_ID
          End With
        
        End With
        
        rs.MoveNext
      Wend
    
    End With
    
  End With
  
  pLoadClases = True

End Function

Private Function pLoadExamenes(ByRef Propiedad As cIABMProperty) As Boolean
  
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "select cure.*, aula_nombre" & _
            " from CursoExamen cure left join Aula au" & _
               " on cure.aula_id = au.aula_id" & _
            " where cure.cur_id = " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, _
                    rs, _
                    csRsStatic, _
                    csLockReadOnly, _
                    csCmdText, _
                    "pLoadExamenes", _
                    C_Module) Then Exit Function
  
  With Propiedad.Grid
    
    With .Columns
      
      .Clear
      
      With .Add(Nothing)
        .Visible = False
        .Key = KI_ITEM_ID
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1569, vbNullString) 'Fecha
        .PropertyType = cspDate
        .Width = 2500
        .Key = KI_FECHA
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(2532, vbNullString) 'Desde
        .PropertyType = cspTime
        .Width = 2500
        .Key = KI_DESDE
        .Format = "hh:nn"
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(2533, vbNullString) 'Hasta
        .PropertyType = cspTime
        .Width = 2500
        .Key = KI_HASTA
        .Format = "hh:nn"
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(1660, vbNullString) 'Horas
        .PropertyType = cspTime
        .Width = 2500
        .Key = KI_HORAS
        .Format = "hh:nn"
      End With
      
      With .Add(Nothing)
        .Name = LNGGetText(4704, vbNullString) 'Aula
        .PropertyType = cspHelp
        .Table = csAula
        .Width = 2500
        .Key = KI_AULA_ID
      End With
      
    End With
    
    With .Rows
      
      .Clear
      
      While Not rs.EOF
        
        With .Add(Nothing, rs(cscCureId).Value)
      
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCureId)
            .Key = KI_ITEM_ID
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCureFecha)
            .Key = KI_FECHA
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCureDesde)
            .Key = KI_DESDE
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCureHasta)
            .Key = KI_HASTA
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscCureHoras)
            .Key = KI_HORAS
          End With
          
          With .Add(Nothing)
            .Value = gDB.ValField(rs.fields, cscAulaNombre)
            .Id = gDB.ValField(rs.fields, cscAulaId)
            .Key = KI_AULA_ID
          End With
        
        End With
        
        rs.MoveNext
      Wend
    
    End With
    
  End With
  
  pLoadExamenes = True

End Function

'/////////////////////////////////////////////////////////////
' Menu
Private Function cIMenuClient_Initialize(F As Object, Host As CSMenu.cIMenuHost) As Boolean
  On Error GoTo ControlError
  Dim str_4690  As String
  
  str_4690 = LNGGetText(4690, vbNullString)  'Institutos &Educativos
  
  Set m_Host = Host

  m_Host.Server.AddMenu str_4690, csMenuEduMain, vbNullString, 1, False, False, False, True, False, Nothing
                                  '&Cursos
  m_Host.Server.AddMenu LNGGetText(4693, vbNullString), csPreEListCurso, str_4690, 0, True, False, False, False, False, Me
  
  
    
  cIMenuClient_Initialize = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIMenuClient_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal Id As Long) As Variant
  m_Host.MenuListDocClick "CSABMInterface2.CABMGeneric", _
                          "CSEdu.cCurso", _
                          "CSABMInterface2.CABMGenericListDoc", _
                          "CSEdu.cCursoListDoc", Me, _
                          LNGGetText(4694, vbNullString), 0
                          ' Cursos
End Function

Private Function pGetDesde() As cIABMProperty
  Set pGetDesde = m_ObjAbm.Properties.Item(cscCurDesde)
End Function

Private Function pGetHasta() As cIABMProperty
  Set pGetHasta = m_ObjAbm.Properties.Item(cscCurHasta)
End Function

Private Function pIsDateAux(ByVal iDay As Integer, ByVal iMonth As Integer, ByVal iYear As Long) As Boolean
  On Error Resume Next
  Err.Clear
  
  Dim v As Date
  
  v = DateSerial(iYear, iMonth, iDay)
  
  pIsDateAux = Err.Number = 0
End Function

Private Function pSaveExamenes() As Boolean
  Dim register As cRegister
  Dim fields   As cFields

  With m_ObjAbm.Properties.Item(c_examen)
    Dim Row  As cIABMGridRow
    Dim Cell As cIABMGridCellValue
    
    For Each Row In .Grid.Rows
    
      Set register = New cRegister
      
      With register
        Set fields = .fields
        .fieldId = cscCureId
        .Table = csTCursoExamen
        .Id = csNew
        
        For Each Cell In Row
          Select Case Cell.Key
            
            Case KI_ITEM_ID
              If Not m_Copy Then
                .Id = Val(Cell.Value)
              End If
            
            Case KI_FECHA
              fields.Add2 cscCureFecha, Cell.Value, csDate
            Case KI_DESDE
              fields.Add2 cscCureDesde, pGetTime(Cell.Value), csDate
            Case KI_HASTA
              fields.Add2 cscCureHasta, pGetTime(Cell.Value), csDate
            Case KI_HORAS
              fields.Add2 cscCureHoras, pGetTime(Cell.Value), csDate
            Case KI_AULA_ID
              fields.Add2 cscAulaId, Cell.Id, csId
          
          End Select
        Next
        
        fields.Add2 cscCurId, m_Id, csId
        
        fields.HaveLastUpdate = False
        fields.HaveWhoModify = False
      End With
                                                                    
      If Not gDB.Save(register, , "pSaveExamenes", C_Module, c_ErrorSave) Then Exit Function
    Next
  End With
  
  Dim sqlstmt As String
  
  If LenB(m_ItemsDeletedExamenes) And Not m_Copy Then
    m_ItemsDeletedExamenes = RemoveLastColon(m_ItemsDeletedExamenes)
    sqlstmt = "delete CursoExamen where cure_id in (" & m_ItemsDeletedExamenes & ")"
  
    If Not gDB.Execute(sqlstmt, "pSaveExamenes", C_Module) Then Exit Function
  End If
  
  pSaveExamenes = True
End Function

Private Function pSaveClases() As Boolean
  Dim register As cRegister
  Dim fields   As cFields

  With m_ObjAbm.Properties.Item(c_clases)
    Dim Row  As cIABMGridRow
    Dim Cell As cIABMGridCellValue
    
    For Each Row In .Grid.Rows
    
      Set register = New cRegister
      
      With register
        Set fields = .fields
        .fieldId = cscCurcId
        .Table = csTCursoClase
        .Id = csNew
        
        For Each Cell In Row
          Select Case Cell.Key
            
            Case KI_ITEM_ID
              If Not m_Copy Then
                .Id = Val(Cell.Value)
              End If
            
            Case KI_FECHA
              fields.Add2 cscCurcFecha, Cell.Value, csDate
            Case KI_DESDE
              fields.Add2 cscCurcDesde, pGetTime(Cell.Value), csDate
            Case KI_HASTA
              fields.Add2 cscCurcHasta, pGetTime(Cell.Value), csDate
            Case KI_HORAS
              fields.Add2 cscCurcHoras, pGetTime(Cell.Value), csDate
            Case KI_AULA_ID
              fields.Add2 cscAulaId, Cell.Id, csId
          
          End Select
        Next
        
        fields.Add2 cscCurId, m_Id, csId
        
        fields.HaveLastUpdate = False
        fields.HaveWhoModify = False
      End With
                                                                    
      If Not gDB.Save(register, , "pSaveClases", C_Module, c_ErrorSave) Then Exit Function
    Next
  End With
  
  Dim sqlstmt As String
  
  If LenB(m_ItemsDeletedClases) And Not m_Copy Then
    m_ItemsDeletedClases = RemoveLastColon(m_ItemsDeletedClases)
    sqlstmt = "delete CursoClase where curc_id in (" & m_ItemsDeletedClases & ")"
  
    If Not gDB.Execute(sqlstmt, "pSaveClases", C_Module) Then Exit Function
  End If
  
  pSaveClases = True
End Function

Private Function pSaveItems() As Boolean
  Dim register  As cRegister
  Dim fields    As cFields
  Dim Row       As cIABMGridRow
  Dim Cell      As cIABMGridCellValue
  Dim iCol      As Long
  Dim toDelete  As String
  Dim curi_id   As Long
  
  Dim bHaveToDelete           As Boolean
  Dim bHaveToUpdateInsert     As Boolean
    
  With m_ObjAbm.Properties.Item(c_Items).Grid
          
    For Each Row In .Rows
    
    
      '----------------------------------------------------
      '
      ' ALUMNOS INSCRIPTOS AL CURSO
      '
      '----------------------------------------------------
    
      Set register = New cRegister
      With register
        Set fields = .fields
        .fieldId = cscCuriId
        .Table = csTCursoItem
        .Id = csNew
    
        For Each Cell In Row
          Select Case Cell.Key
            
            Case KI_ITEM_ID
              If Not m_Copy Then
                .Id = Val(Cell.Value)
              End If
            
            Case KI_ALUM_ID
              
              ' Busco que este alumno no este ya cargado
              '
              curi_id = pGetItemFromAlumno(Cell.Id)
              
              If curi_id Then
                .Id = curi_id
              End If
              
              fields.Add2 cscAlumId, Cell.Id, csId
            Case KI_PROF_ID
              fields.Add2 cscProfId, Cell.Id, csId
          
          End Select
        Next
        
        fields.Add2 cscCurId, m_Id, csId
        fields.Add2 cscEstId, 10, csId 'En curso
        
        fields.HaveLastUpdate = False
        fields.HaveWhoModify = False
      End With
                                                                    
      If Not gDB.Save(register, , "pSaveItems", C_Module, c_ErrorSave) Then Exit Function
      
      curi_id = register.Id
      
    
      '----------------------------------------------------
      '
      ' ASISTENCIA
      '
      '----------------------------------------------------
    
      iCol = 0
    
      Set register = New cRegister
      With register
        .fieldId = cscCuriaId
        .Table = csTCursoItemAsistencia
        .Id = csNew
      End With
      
      For Each Cell In Row
      
        iCol = iCol + 1
      
        Select Case Cell.Key
          
          Case KI_ITEM_ID, KI_ALUM_ID, KI_PROF_ID
                      
            ' Nada que hacer, solo esta para que no entre por el else
            ' y se descarta automaticamente
            
          Case Else
          
            ' En la primera no se hace nada
            '
            If iCol = 1 Then
            
            ' Si la columna es de horas
            '
            ElseIf pIsColValue(iCol) Then
            
              ' Si no hay asistencia tengo que borrar
              ' el registro en CursoItemAsistencia
              '
              If Cell.Id = 0 Then
                bHaveToDelete = True
              
              Else
                
                bHaveToUpdateInsert = True
              End If
            
            ' Si la columna es de Id
            '
            Else
              
              ' Si hay que borrar la hora
              '
              If bHaveToDelete Then
              
                If Cell.Id Then
                  toDelete = toDelete & Cell.Id & ","
                End If
                
                bHaveToDelete = False
              
              ' Si asistio a clases
              '
              ElseIf bHaveToUpdateInsert Then
                
                register.Id = Cell.Id
                
                register.fields.Add2 cscCuriId, curi_id, csId
                register.fields.Add2 cscCurcId, pGetClaseFromCol(iCol), csId
              
                If Not gDB.Save(register, , _
                                C_pSaveItemsFunc, _
                                C_Module, _
                                c_ErrorSave) Then Exit Function
                
                ' Nuevo registro
                '
                Set register = New cRegister
                With register
                  .fieldId = cscCuriaId
                  .Table = csTCursoItemAsistencia
                  .Id = csNew
                End With
                
                bHaveToUpdateInsert = False
              
              End If
            
            End If
            
        End Select
      Next
      
    Next
  End With
  
  Dim sqlstmt As String
  
  If LenB(m_ItemsDeleted) And Not m_Copy Then
    m_ItemsDeleted = RemoveLastColon(m_ItemsDeleted)
    sqlstmt = "delete CursoItemAsistencia where curia_id in (" & m_ItemsDeleted & ")"
  
    If Not gDB.Execute(sqlstmt, C_pSaveItemsFunc, C_Module) Then Exit Function
  End If
  
  If LenB(toDelete) And Not m_Copy Then
    toDelete = RemoveLastColon(toDelete)
    sqlstmt = "delete CursoItemAsistencia where curia_id in (" & toDelete & ")"
  
    If Not gDB.Execute(sqlstmt, C_pSaveItemsFunc, C_Module) Then Exit Function
  End If
  
  pSaveItems = True
End Function

Private Function pSaveCalificaciones() As Boolean
  Dim register  As cRegister
  Dim fields    As cFields
  Dim Row       As cIABMGridRow
  Dim Cell      As cIABMGridCellValue
  Dim iCol      As Long
  Dim toDelete  As String
  Dim curi_id   As Long
  
  Dim bHaveToDelete           As Boolean
  Dim bHaveToUpdateInsert     As Boolean
    
  With m_ObjAbm.Properties.Item(c_calif).Grid
          
    For Each Row In .Rows
    
      iCol = 0
    
      Set register = New cRegister
      With register
        .fieldId = cscCuricId
        .Table = csTCursoItemCalificacion
        .Id = csNew
      End With
      
      For Each Cell In Row
      
        iCol = iCol + 1
      
        Select Case Cell.Key
          
          Case KI_ITEM_ID
          
            ' Nada que hacer, solo esta para que no entre por el else
            ' y se descarta automaticamente
          
          Case KI_ALUM_ID
          
            curi_id = pGetItemFromAlumno(Cell.Id)
          
          Case KI_CALIF
            
            If Not pUpdateNota(Val(Cell.Value), curi_id) Then Exit Function
            
          Case Else
          
            ' En la primera no se hace nada
            '
            If iCol = 1 Then
            
            ' Si la columna es de horas
            '
            ElseIf pIsColValue(iCol) Then
            
              ' Si no hay calificacion tengo que borrar
              ' el registro en CursoItemCalificacion
              '
              If Val(Cell.Value) = 0 Then
                bHaveToDelete = True
              
              Else
                register.fields.Add2 cscCuricCalificacion, Cell.Value, csDouble
                bHaveToUpdateInsert = True
              End If
            
            ' Si la columna es de Id
            '
            Else
              
              ' Si hay que borrar la hora
              '
              If bHaveToDelete Then
              
                If Cell.Id Then
                  toDelete = toDelete & Cell.Id & ","
                End If
                
                bHaveToDelete = False
              
              ' Si asistio a clases
              '
              ElseIf bHaveToUpdateInsert Then
                
                register.Id = Cell.Id
                
                register.fields.Add2 cscCuriId, curi_id, csId
                register.fields.Add2 cscCureId, pGetExamenFromCol(iCol), csId
              
                If Not gDB.Save(register, , _
                                "pSaveCalificaciones", _
                                C_Module, _
                                c_ErrorSave) Then Exit Function
                
                ' Nuevo registro
                '
                Set register = New cRegister
                With register
                  .fieldId = cscCuricId
                  .Table = csTCursoItemCalificacion
                  .Id = csNew
                End With
                
                bHaveToUpdateInsert = False
              
              End If
            
            End If
            
        End Select
      Next
      
    Next
  End With
  
  Dim sqlstmt As String
  
  If LenB(m_ItemsDeleted) And Not m_Copy Then
    m_ItemsDeletedCalif = RemoveLastColon(m_ItemsDeletedCalif)
    sqlstmt = "delete CursoItemCalificacion where curic_id in (" & m_ItemsDeletedCalif & ")"
  
    If Not gDB.Execute(sqlstmt, "pSaveCalificaciones", C_Module) Then Exit Function
  End If
  
  If LenB(toDelete) And Not m_Copy Then
    toDelete = RemoveLastColon(toDelete)
    sqlstmt = "delete CursoItemCalificacion where curic_id in (" & toDelete & ")"
  
    If Not gDB.Execute(sqlstmt, "pSaveCalificaciones", C_Module) Then Exit Function
  End If
  
  pSaveCalificaciones = True
End Function

Private Function pGetItemFromAlumno(ByVal alum_id As Long) As Long
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "select curi_id from CursoItem where cur_id = " & m_Id & " and alum_id = " & alum_id
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  If rs.EOF Then Exit Function
  
  pGetItemFromAlumno = rs.fields.Item(0).Value
  
End Function

Private Function pUpdateNota(ByVal Calif As Double, ByVal curi_id As Long) As Boolean
  Dim sqlstmt As String
  sqlstmt = "Update CursoItem set curi_calificacion = " & gDB.sqlNumber(Calif) _
              & " where curi_id = " & curi_id
              
  If Not gDB.Execute(sqlstmt) Then Exit Function
  pUpdateNota = True
End Function

Private Function pGetExamenFromCol(ByVal iColIndex As Long) As Long
  Dim rs As ADODB.Recordset
  Dim sqlstmt As String
  
  sqlstmt = "select cure_id from CursoExamen where cur_id = " & m_Id & " order by cure_fecha"
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  Dim cure_id As Long
  Dim i As Long
  
  Do While Not rs.EOF
    
    i = i + 1
    If i = (iColIndex - c_fixed_col) / 2 Then
      cure_id = rs.fields.Item(0).Value
      Exit Do
    End If
    
    rs.MoveNext
  Loop
  
  pGetExamenFromCol = cure_id
End Function

Private Function pGetClaseFromCol(ByVal iColIndex As Long) As Long
  Dim rs As ADODB.Recordset
  Dim sqlstmt As String
  
  sqlstmt = "select curc_id from CursoClase where cur_id = " & m_Id & " order by curc_fecha"
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  Dim curc_id As Long
  Dim i As Long
  
  Do While Not rs.EOF
    
    i = i + 1
    If i = (iColIndex - c_fixed_col) / 2 Then
      curc_id = rs.fields.Item(0).Value
      Exit Do
    End If
    
    rs.MoveNext
  Loop
  
  pGetClaseFromCol = curc_id
End Function

Private Function pIsColValue(ByVal iColIndex As Long) As Boolean
  pIsColValue = ((iColIndex - c_fixed_col) Mod 2 - 1) = 0
End Function

Private Function pGetHorasFromVirtualEAST_ID(ByVal east_id As Long) As Double
  Dim rtn As Double
  
  Select Case east_id
    Case -1000
      rtn = 1
    Case -1001
      rtn = 1.5
    Case -1002
      rtn = 2
    Case -1003
      rtn = 2.5
    Case -1004
      rtn = 3
    Case -1005
      rtn = 3.5
    Case -1006
      rtn = 4
    Case -1007
      rtn = 4.5
    Case -1008
      rtn = 5
    Case -1009
      rtn = 5.5
    Case -1010
      rtn = 6
    Case -1011
      rtn = 6.5
    Case -1012
      rtn = 7
    Case -1013
      rtn = 7.5
    Case -1014
      rtn = 8
    Case -1015
      rtn = 8.5
    Case -1016
      rtn = 9
    Case -1017
      rtn = 9.5
    Case -1018
      rtn = 10
    Case -1019
      rtn = 10.5
    Case -1020
      rtn = 11
    Case -1021
      rtn = 11.5
    Case -1022
      rtn = 12
    Case -1023
      rtn = 12.5
    Case -1024
      rtn = 13
    Case -1025
      rtn = 13.5
    Case -1026
      rtn = 14
    Case -1027
      rtn = 14.5
    Case -1028
      rtn = 15
    Case -1029
      rtn = 15.5
    Case -1030
      rtn = 16
    Case -1031
      rtn = 16.5
    Case -1032
      rtn = 17
    Case -1033
      rtn = 17.5
    Case -1034
      rtn = 18
    Case -1035
      rtn = 18.5
  End Select
  
  pGetHorasFromVirtualEAST_ID = rtn
End Function

'----------------------------------------------------------------------------------------------
'
Private Function pGetCellClaseFromKey(ByRef Row As cIABMGridRow, _
                                      ByVal Key As String, _
                                      ByRef Columns As cIABMGridColumns) As cIABMGridCellValue
  Dim iCol As Long
  Dim Col  As cABMGridColumn
  Set Col = Columns.Item(Key)
  iCol = Col.Index
  Set pGetCellClaseFromKey = Row.Item(iCol)
End Function

'----------------------------------------------------------------------------------------------
'
Private Function pGetCellExamenFromKey(ByRef Row As cIABMGridRow, _
                                       ByVal Key As String, _
                                       ByRef Columns As cIABMGridColumns) As cIABMGridCellValue
  Dim iCol As Long
  Dim Col  As cABMGridColumn
  Set Col = Columns.Item(Key)
  iCol = Col.Index
  Set pGetCellExamenFromKey = Row.Item(iCol)
End Function

'----------------------------------------------------------------------------------------------
'
Private Function pGetCellIdFromKey(ByRef Row As cIABMGridRow, _
                                   ByVal Key As String, _
                                   ByRef Columns As cIABMGridColumns) As cIABMGridCellValue
  
  Dim iCol As Long
  Dim Col  As cABMGridColumn
  Set Col = Columns.Item(Key)
  iCol = Col.Index
  Set pGetCellIdFromKey = Row.Item(iCol + 1)
End Function

Private Function pGetItems() As cIABMProperty
  Set pGetItems = m_ObjAbm.Properties.Item(c_Items)
End Function

Private Function pGetDayName(ByVal dDate As Date) As String
  Select Case Weekday(dDate, vbMonday)
    Case 1
      pGetDayName = "LU "
    Case 2
      pGetDayName = "MA "
    Case 3
      pGetDayName = "MI "
    Case 4
      pGetDayName = "JU "
    Case 5
      pGetDayName = "VI "
    Case 6
      pGetDayName = "SA "
    Case 7
      pGetDayName = "DO "
  End Select
End Function

Private Function pGetClases(ByRef rsClases As ADODB.Recordset) As Boolean
  Dim sqlstmt   As String
  
  sqlstmt = "select curc_fecha, curc_desde from CursoClase " & _
            "where cur_id = " & m_Id & " order by curc_fecha"
            
  If Not gDB.OpenRs(sqlstmt, rsClases) Then Exit Function
  
  pGetClases = True
End Function

Private Function pGetExamenes(ByRef rsExamenes As ADODB.Recordset) As Boolean
  Dim sqlstmt   As String
  
  sqlstmt = "select cure_fecha, cure_desde from CursoExamen " & _
            "where cur_id = " & m_Id & " order by cure_fecha"
            
  If Not gDB.OpenRs(sqlstmt, rsExamenes) Then Exit Function
  
  pGetExamenes = True
End Function

Private Function pGetTime(ByVal Value As String) As String
  
  If LenB(Value) Then
  
    pGetTime = Format(Value, "hh:nn")
  
  Else
  
    pGetTime = "00:00"
    
  End If
  
End Function

' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  c_ErrorSave = LNGGetText(4695, vbNullString) 'Error al grabar el curso
    
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

Private Function pSearch() As Long
  Dim Help As CSOAPI2.cHelp
  Dim hr As cHelpResult
  
  Set Help = New CSOAPI2.cHelp
  
  Help.IsSearch = True
  
  Set hr = Help.Show(Nothing, csCurso, "", "", "", , , , , True)
  
  If hr.Cancel Then Exit Function
  
  pSearch = hr.Id
  
  If hr.Id Then
    cIEditGeneric_Edit hr.Id
  End If
End Function


VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cHelp"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cHelp
' 18-01-00

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
  ' constantes
  ' estructuras
  ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cHelp"

Private Const KEY_NODO = "N"

  Const csCliente = 28
  Const csProveedor = 29
  Const c_resumen = "@show_resumen"
  Const c_new_cliente = "@show_new_cliente"
  Const c_edit_cliente = "@edit_cliente"

' estructuras
Private Type t_InfoSP
  Text    As String
  SP      As String
  Key     As String
End Type

' variables privadas
Private m_DiccTabla                 As cDiccTabla
Private WithEvents m_FormHelp       As fHelp
Attribute m_FormHelp.VB_VarHelpID = -1
Private WithEvents m_FormHelpTree   As fHelpTree
Attribute m_FormHelpTree.VB_VarHelpID = -1
Private WithEvents m_Menu           As cPopupMenu
Attribute m_Menu.VB_VarHelpID = -1
Private m_Form                      As Form
Private m_Filter                    As String
Private m_FieldValueProcess         As String
Private m_FieldsToFilter            As String
Private m_FieldsToFilterInt         As String
Private m_bForAbm                   As Boolean
Private m_vInfoSP()                 As t_InfoSP
Private m_infoId                    As Long
Private m_infoTable                 As csTables
Private m_SPInfoFilter              As String
Private m_bIsSearch                 As Boolean

Private m_bIsForServicios           As Boolean
Private m_bIsForParteRep            As Boolean
Private m_bIsForProductoSerie       As Boolean

Private m_objHelp                   As Object

' Properties publicas
Public Property Let ForAbm(ByVal rhs As Boolean)
  m_bForAbm = rhs
End Property

Public Property Let IsSearch(ByVal rhs As Boolean)
  m_bIsSearch = rhs
End Property
' Properties privadas
' funciones publicas
Public Function Show(ByRef F As Object, ByVal Table As csTables, _
                     ByVal Id As String, ByVal Name As String, ByVal ValueProcess As String, _
                     Optional ByVal TypeHelp As csHelpType = csNormal, _
                     Optional ByVal filter As String, _
                     Optional ByVal SPFilter As String, _
                     Optional ByVal ColumnValueProcess As String, _
                     Optional ByVal bForAbm As Boolean) As cHelpResult
  
  Dim bMultiSelect As Boolean
  
  If TypeHelp = csMultiSelect Then
    bMultiSelect = True
    TypeHelp = csNormal
  End If
  
  filter = pReplaceMacrosInFilter(filter)
  
  Set Show = New cHelpResult
  m_bForAbm = bForAbm
  m_Filter = filter
  m_FieldValueProcess = ColumnValueProcess
  Set m_DiccTabla = New cDiccTabla
  
  If TypeHelp = 0 Then TypeHelp = csNormal
  
  If Not m_DiccTabla.Load(Table) Then Exit Function
  If Not m_DiccTabla.HaveTree Then TypeHelp = csNormal
  
  Dim Prefix As String
  
  If TypeHelp = csNormal Then
    If Not LoadNormalHelp() Then Exit Function
    Prefix = vbNullString
    Set m_FormHelpTree = Nothing
    Set m_FormHelp = m_Form
  Else
    If Not LoadTreeHelp() Then Exit Function
    Prefix = "T_"
    m_Form.TableId = Table
    m_Form.TableNameLogic = m_DiccTabla.NameLogic
    Set m_FormHelp = Nothing
    Set m_FormHelpTree = m_Form
  End If
  
  m_Form.ObjABMName = m_DiccTabla.ObjectABM
  m_Form.ObjEditName = m_DiccTabla.ObjectEdit
  m_Form.ClientTable = m_DiccTabla.NameFisic

  Dim sqlstmt As String
  
  If m_bIsSearch Then
    sqlstmt = m_DiccTabla.SqlSearch
    If LenB(sqlstmt) = 0 Then
      sqlstmt = m_DiccTabla.SqlHelp
    End If
  Else
    sqlstmt = m_DiccTabla.SqlHelp
  End If
  
  pShowCbFilter sqlstmt

  ' OJO: No mover sin antes tener en cuenta
  '      el tema de eventos
  '
  ' Esto esta aca porque dispara el evento
  ' load del form
  '
  If TypeHelp = csNormal Then
    pSetProductoHelp
  End If

  If Not GetItems(sqlstmt, _
                  m_DiccTabla.HaveActive, _
                  m_DiccTabla.NameFisic, _
                  vbNullString, _
                  pGetLike(m_Form)) Then Exit Function
  
  m_Form.Caption = LNGGetText(3440, vbNullString, m_DiccTabla.NameLogic)
                  'Seleccionar  (1)
  
  If Not m_Form.LoadItems() Then Exit Function
  
  If bMultiSelect Then
    m_Form.grData.MultiSelect = True
    If TypeOf m_Form Is fHelp Then
      m_Form.cmdAdd.Visible = True
    End If
  End If
  
  SetUbicForm F
  
  CSKernelClient2.ShowForm m_Form, Prefix & m_Form.Caption, vbModal
  
  If m_Form.Ok Then
    Show.Create m_Form.Id, m_Form.FormName, m_Form.Code, False
  Else
    Show.Create Id, Name, ValueProcess, True
  End If
  
  On Error Resume Next
  
  Unload m_Form
End Function

Public Function ValidateEx(ByVal Table As csTables, _
                           ByVal Text As String, _
                           ByVal TextId As String, _
                           Optional ByVal filter As String, _
                           Optional ByVal SPFilter As String) As cHelpResult

  Dim rs              As ADODB.Recordset
  Dim sqlstmt         As String
  Dim bSp             As Boolean
  Dim Id              As Long
  Dim bBranch         As Boolean
  
  Set ValidateEx = New cHelpResult
  ValidateEx.Create 0, Text, Text, True
  
  If Table = csNO_ID Then Exit Function
  
  If Not (LenB(Text) = 0 And (LenB(TextId) = 0 Or TextId = "0")) Then
  
    Set m_DiccTabla = New cDiccTabla
    If Not m_DiccTabla.Load(Table) Then Exit Function
    
    Text = Replace(Text, "'", "''")
  
    ' Si se trata de una rama valido que exista la rama
    If Left$(TextId, 1) = KEY_NODO Then
    
      Id = Val(Mid$(TextId, 2))
    
      sqlstmt = "select ram_id, ram_nombre, ram_nombre as dummy" & _
                " from rama,arbol where ram_nombre = '" & Text & "'" & _
                  " and rama.arb_id = arbol.arb_id" & _
                  " and tbl_id = " & Table
      
      If Id <> 0 Then
        sqlstmt = sqlstmt & " and ram_id = " & Id
      End If
      
      If Not gDB.OpenRs(sqlstmt, rs, csRsKeySet, csLockReadOnly, , LNGGetText(3441, vbNullString, m_DiccTabla.Name), C_Module) Then Exit Function
                                                                    'ValidateEx - Para (1)
      bBranch = True
    ' Valido que exista el registro en la tabla
    Else
      
      Id = Val(TextId)
      
      Dim FieldId     As String
      Dim FieldName   As String
      Dim FieldCode   As String
      Dim FilterChek  As String
  
      With m_DiccTabla
        
        FieldId = .FieldId
        FieldName = .FieldName
        FieldCode = .FieldCode
        
        ' Si es un SP
        If InStr(1, .SqlHelp, "select", vbTextCompare) = 0 Then
          
          sqlstmt = .SqlHelp
          sqlstmt = Replace(LCase(sqlstmt), "@@no_sort", vbNullString)
          sqlstmt = Replace(LCase(sqlstmt), "@@bforabm", IIf(m_bForAbm, 1, 0))
          sqlstmt = Replace(LCase(sqlstmt), "@@bfiltertype", 0)
          sqlstmt = sqlstmt & " '" & Text & "',-1," & Val(TextId)
          
          If LenB(filter) Then
            If Right$(Trim$(filter), 1) <> "'" Then filter = "'" & filter & "'"
            sqlstmt = sqlstmt & "," & filter
          End If
          
          bSp = True
        
        Else
        
          If .OriginalSqlHelp = vbNullString Then
            sqlstmt = "select " & .FieldId & "," & .FieldName & "," & .FieldCode & " from " & .NameFisic
          Else
            sqlstmt = .OriginalSqlHelp
          End If
          
          If Not ValEmpty(.Where, csText) Then sqlstmt = sqlstmt & " where (" & .Where & ")"
          FilterChek = "(" & .FieldCode & "='" & Text & "') or (" & .FieldName & "='" & Text & "')"
        
          If InStr(1, sqlstmt, "select", vbTextCompare) > 0 Then
            Dim sSelect     As String
            Dim sFrom       As String
            Dim sWhere      As String
            Dim sGroupBy    As String
            Dim sOrder      As String
            
            sSelect = gDB.GetSelect(sqlstmt)
            sFrom = gDB.GetFrom(sqlstmt)
            sWhere = gDB.GetWhere(sqlstmt)
            sGroupBy = gDB.GetGroup(sqlstmt)
            sOrder = gDB.GetOrder(sqlstmt)
            
            If LenB(Trim(sWhere)) Then
              sWhere = sWhere & " and (" & FilterChek & ") and (" & FieldName & " <> '' and " & FieldCode & "<>'')"
            Else
              sWhere = " where (" & FilterChek & ") and (" & FieldName & " <> '' and " & FieldCode & "<>'')"
            End If
            
            If LenB(Trim(filter)) Then sWhere = sWhere & " and (" & filter & ")"
            
            If Id <> 0 Then sWhere = sWhere & " and " & .FieldId & " = " & Id
            
            ' Tiene que estar activo si tiene activo
            '
            If .HaveActive And Not m_bForAbm Then
              If LenB(Trim(sWhere)) Then
                sWhere = sWhere & " and (" & .NameFisic & ".activo <> 0)"
              Else
                sWhere = " where (" & .NameFisic & ".activo <> 0)"
              End If
            End If
            '
            ' Fin Activo
            
            sqlstmt = sSelect & " " & sFrom & " " & sWhere & " " & sGroupBy & " " & sOrder
  
          Else
            bSp = True
          End If
        
        End If
      
      End With
      
      If Not gDB.OpenRs(sqlstmt, rs, csRsKeySet, csLockReadOnly, , LNGGetText(3441, vbNullString, m_DiccTabla.Name), C_Module) Then Exit Function
                                                                  'ValidateEx - Para  & m_DiccTabla.Name
    End If
    
    If Not rs.EOF Then
      If bSp Then
        ValidateEx.Create gDB.ValField(rs.Fields, 0), gDB.ValField(rs.Fields, 1), gDB.ValField(rs.Fields, 2), False
      ElseIf bBranch Then
        ValidateEx.Create KEY_NODO & gDB.ValField(rs.Fields, 0), gDB.ValField(rs.Fields, 1), gDB.ValField(rs.Fields, 2), False
      Else
        ValidateEx.Create gDB.ValField(rs.Fields, FieldId), _
                                       gDB.ValField(rs.Fields, "1"), _
                                       gDB.ValField(rs.Fields, "2"), False
      End If
    Else
      ' Pruebo una vez mas para ver si
      ' existe alguno con el codigo o el nombre igual
      ' al texto que me pasaron
      If Id <> 0 Then
        Set ValidateEx = ValidateEx(Table, Text, 0, filter)
      End If
    End If
  End If
End Function

Public Function HaveInfo(ByVal Table As csTables) As Boolean
  On Error GoTo ControlError
  
  Dim rs As Recordset
  Dim sqlstmt As String
  
  If Table = csNO_ID Then Exit Function
  
  If gDB Is Nothing Then Exit Function
  
  sqlstmt = "select tbl_spinfo from tabla where tbl_id = " & Table
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function

  If rs.EOF Then Exit Function

  HaveInfo = gDB.ValField(rs.Fields, 0) <> ""

  GoTo ExitProc
ControlError:
  MngError Err, "HaveInfo", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Public Function ShowInfoEx(ByVal Table As csTables, _
                           ByVal Id As Long, _
                           ByVal SPInfoFilter As String, _
                           ByVal hwnd As Long, _
                           ByVal Left As Long, _
                           ByVal Top As Long, _
                           ByRef objHelp As Object) As Boolean
  On Error GoTo ControlError
  
  Dim rs As Recordset
  Dim sqlstmt   As String
  Dim str_3442  As String
  Dim str_3443  As String
  Dim str_4500  As String
  Dim str_5038  As String
  
  str_3442 = LNGGetText(3442, vbNullString) '|Resumen|
  str_3443 = LNGGetText(3443, vbNullString) 'Info|
  str_4500 = LNGGetText(4500, vbNullString) 'Nuevo Cliente
  str_5038 = LNGGetText(5038, vbNullString) 'Editar Cliente
  
  sqlstmt = "select tbl_spinfo from tabla where tbl_id = " & Table
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  sqlstmt = gDB.ValField(rs.Fields, 0)
  If sqlstmt = vbNullString Then Exit Function

  If Table = csCliente And hwnd Then
    If InStr(1, sqlstmt, "|") Then
      sqlstmt = sqlstmt & "|" & str_3442 & c_resumen
                          '|Resumen|
    
      sqlstmt = sqlstmt & "|" & str_4500 & "|" & c_new_cliente
                          '|Nuevo Cliente|
                          
      sqlstmt = sqlstmt & "|" & str_5038 & "|" & c_edit_cliente
                          '|Editar Cliente|
    Else
      sqlstmt = str_3443 & sqlstmt & str_3442 & c_resumen
               'Info|                |Resumen|
    
      sqlstmt = sqlstmt & "|" & str_4500 & "|" & c_new_cliente
                          '|Nuevo Cliente|
      
      sqlstmt = sqlstmt & "|" & str_5038 & "|" & c_edit_cliente
                          '|Editar Cliente|
    
    End If
  ElseIf Table = csProveedor And hwnd Then
    If InStr(1, sqlstmt, "|") Then
      sqlstmt = sqlstmt & str_3442 & c_resumen
    Else
      sqlstmt = str_3443 & sqlstmt & str_3442 & c_resumen
    End If
  End If

  m_infoId = Id
  m_infoTable = Table

  If InStr(1, sqlstmt, "|") Then
  
    Dim vSqlstmt As Variant
    Dim i        As Integer
    Dim n        As Integer
    
    vSqlstmt = Split(sqlstmt, "|")
    ReDim m_vInfoSP((UBound(vSqlstmt) + 1) / 2)
    For i = 0 To UBound(vSqlstmt) Step 2
      n = n + 1
      With m_vInfoSP(n)
        .Key = GetKey(i)
        .Text = vSqlstmt(i)
        .SP = vSqlstmt(i + 1)
      End With
    Next
    
    pCreateMenu hwnd
    
    Set m_objHelp = objHelp
    
    m_Menu.ShowPopupMenu Left / Screen.TwipsPerPixelX, _
                         Top / Screen.TwipsPerPixelY
  Else
    
    pShowInfo sqlstmt, Table, Id
  End If
  
  ShowInfoEx = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "ShowInfoEx", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
  Set m_objHelp = Nothing
End Function


Public Function ShowInfo(ByVal Table As csTables, _
                         ByVal Id As Long, _
                         ByVal SPInfoFilter As String, _
                         ByVal hwnd As Long, _
                         ByVal Left As Long, _
                         ByVal Top As Long) As Boolean
                         
  ShowInfo = ShowInfoEx(Table, Id, SPInfoFilter, hwnd, Left, Top, Nothing)
  
End Function

Public Function ShowMenu(ByVal Table As csTables, _
                         ByVal Id As Long, _
                         ByVal SPInfoFilter As String, _
                         ByVal hwnd As Long, _
                         ByVal Left As Long, _
                         ByVal Top As Long) As Boolean
  
  ShowMenu = ShowMenuEx(Table, Id, SPInfoFilter, hwnd, Left, Top, Nothing)

End Function

Public Function ShowMenuEx(ByVal Table As csTables, _
                           ByVal Id As Long, _
                           ByVal SPInfoFilter As String, _
                           ByVal hwnd As Long, _
                           ByVal Left As Long, _
                           ByVal Top As Long, _
                           ByRef objHelp As Object) As Boolean
                         
  On Error GoTo ControlError
  
  If Table = csCliente And hwnd Then
    
    ReDim m_vInfoSP(2)
    
    With m_vInfoSP(1)
      .Key = GetKey(0)
      .SP = c_new_cliente
      .Text = LNGGetText(4500, vbNullString) ' Nuevo Cliente
    End With
    
    With m_vInfoSP(2)
      .Key = GetKey(1)
      .SP = c_edit_cliente
      .Text = LNGGetText(5038, vbNullString) ' Editar Cliente
    End With
    
    pCreateMenu hwnd
    
    Set m_objHelp = objHelp
    
    m_Menu.ShowPopupMenu Left / Screen.TwipsPerPixelX, _
                         Top / Screen.TwipsPerPixelY
  
  End If

  
  GoTo ExitProc
ControlError:
  MngError Err, "ShowMenuEx", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
  Set m_objHelp = Nothing
End Function

Private Sub pCreateMenu(ByVal hwnd As Long)
  Dim iPTop   As Long
  Dim iP      As Long
  Dim iP2     As Long
  Dim iP3     As Long
  Dim i       As Integer
  
  If m_Menu Is Nothing Then
    Set m_Menu = New cPopupMenu
  End If
  
  m_Menu.Clear

  ' Creating a Menu:
  With m_Menu
    ' Initial set up:
    .hWndOwner = hwnd
    .OfficeXpStyle = True
  End With

  For i = 1 To UBound(m_vInfoSP)
    With m_vInfoSP(i)
      iP = m_Menu.AddItem(.Text, , , iPTop, , , , .Key)
    End With
  Next
End Sub

' funciones privadas
Private Function pShowInfo(ByVal sqlstmt As String, ByVal Table As csTables, ByVal Id As Long)
  Dim rs As Recordset
  
  sqlstmt = sqlstmt & " " & gUser.Id & "," & Id & "," & gDB.sqlString(m_SPInfoFilter)
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function

  ShowInfo_ "Info", rs
End Function

Private Function pShowNewCliente() As Boolean
  On Error GoTo ControlError

  Dim ObjEdit As Object
  Dim iEdit   As cIEditGeneric
  Dim Editor  As cIABMGeneric
  
  Set ObjEdit = CSKernelClient2.CreateObject("CSGeneralEx2.cClientePV")
  Set iEdit = ObjEdit
  Set iEdit.ObjABM = CSKernelClient2.CreateObject("CSABMInterface2.cABMGeneric")
  
  If iEdit.Edit(csNO_ID, True) Then

    m_objHelp.Text = ObjEdit.Nombre
    m_objHelp.Id = ObjEdit.Id
    m_objHelp.ValueHelp = ObjEdit.Id
    
    m_objHelp.RaiseEventChange

  End If

  pShowNewCliente = True

  GoTo ExitProc
ControlError:
  MngError Err, "pShowNewCliente", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pShowEditCliente(ByVal Id As Long) As Boolean
  On Error GoTo ControlError

  Dim ObjEdit As Object
  Dim iEdit   As cIEditGeneric
  Dim Editor  As cIABMGeneric
  
  Set ObjEdit = CSKernelClient2.CreateObject("CSGeneral2.cCliente")
  Set iEdit = ObjEdit
  Set iEdit.ObjABM = CSKernelClient2.CreateObject("CSABMInterface2.cABMGeneric")
  
  If iEdit.Edit(Id, True) Then

    m_objHelp.Text = ObjEdit.Nombre
    m_objHelp.Id = ObjEdit.Id
    m_objHelp.ValueHelp = ObjEdit.Id
    
    m_objHelp.RaiseEventChange

  End If

  pShowEditCliente = True

  GoTo ExitProc
ControlError:
  MngError Err, "pShowEditCliente", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Sub Class_Terminate()
  On Error Resume Next
  Set m_Menu = Nothing
End Sub

Private Sub m_FormHelpTree_ReloadRs()
  pReloadRs m_FormHelpTree
End Sub

Private Sub m_FormHelp_ReloadRs()
  pReloadRs m_FormHelp
End Sub

Private Sub m_Menu_Click(ByRef ItemNumber As Long)
  On Error GoTo ControlError
  
  Dim Key As String
  Dim i   As Integer
  
  Key = m_Menu.ItemKey(ItemNumber)
  
  For i = 1 To UBound(m_vInfoSP)
    If Key = m_vInfoSP(i).Key Then
      If m_vInfoSP(i).SP = c_resumen Then
        If m_infoTable = csCliente Then
          ShowInfoCliente_ m_infoId, Nothing, Not App.NonModalAllowed
        ElseIf m_infoTable = csProveedor Then
          ShowInfoProveedor_ m_infoId, Nothing, Not App.NonModalAllowed
        End If
      ElseIf m_vInfoSP(i).SP = c_new_cliente Then
        pShowNewCliente
      ElseIf m_vInfoSP(i).SP = c_edit_cliente Then
        pShowEditCliente m_infoId
      Else
        pShowInfo m_vInfoSP(i).SP, m_infoTable, m_infoId
      End If
      Exit For
    End If
  Next

  GoTo ExitProc
ControlError:
  MngError Err, "m_Menu_Click", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub pReloadRs(ByVal frm As Object)
  On Error GoTo ControlError

  Dim sqlstmt As String
  
  If m_bIsSearch Then
    sqlstmt = m_DiccTabla.SqlSearch
    If LenB(sqlstmt) = 0 Then
      sqlstmt = m_DiccTabla.SqlHelp
    End If
  Else
    sqlstmt = m_DiccTabla.SqlHelp
  End If

  Dim filter As String
  
  filter = frm.txSearch.Text
  
  'If frm.FilterType = c_HelpFilterWildcard Then
  '
  '  Filter = Replace$(Filter, "*", "%")
  '
  'ElseIf frm.FilterType = c_HelpFilterEndLike Then
  '
  '  Filter = "%" & Filter
  '
  'End If

  GetItems sqlstmt, _
           m_DiccTabla.HaveActive, _
           m_DiccTabla.NameFisic, _
           filter, _
           pGetLike(frm)

  GoTo ExitProc
ControlError:
  MngError Err, "pReloadRs", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Function pGetLike(ByRef frm As Object) As Long
  If TypeOf frm Is fHelp Then
    pGetLike = ListID(frm.cbFilter)
  Else
    If frm.opContains.Value Then
      pGetLike = c_HelpFilterHaveTo
    Else
      pGetLike = c_HelpFilterBeginLike
    End If
  End If
End Function

Private Sub SetUbicForm(ByRef F As Object)
  On Error GoTo ControlError
  If TypeOf F Is Form Then
    m_Form.Left = LeftControlToLeftForm(F.ActiveControl.hwnd)
    m_Form.Top = TopControlToTopForm(F.ActiveControl.hwnd, F.ActiveControl.Height)
  Else
    m_Form.Left = LeftControlToLeftForm(F.hwnd)
    m_Form.Top = TopControlToTopForm(F.hwnd, F.Height)
  End If
  Exit Sub
ControlError:
  CenterForm m_Form
End Sub

Private Function LoadNormalHelp() As Boolean
  Set m_Form = New fHelp
  LoadConfigHelp csNormal
  LoadNormalHelp = True
End Function

Private Function LoadTreeHelp() As Boolean
  Set m_Form = New fHelpTree
  LoadConfigHelp csTree
  LoadTreeHelp = True
End Function

Private Sub LoadConfigHelp(ByVal TypeHelp As csHelpType)

End Sub

Private Function GetItems(ByVal sqlstmt As String, _
                          ByVal bHaveActive As Boolean, _
                          ByVal tblName As String, _
                          ByVal filter As String, _
                          ByVal iLike As Long) As Boolean
  Dim rs As ADODB.Recordset
  Dim bNoSort As Boolean
  
  If Not m_Form Is Nothing Then
    m_Form.HaveTop = False
  End If
  
  If InStr(1, sqlstmt, "select", vbTextCompare) > 0 Then
  
    bNoSort = False
  
    Dim sSelect  As String
    Dim sFrom    As String
    Dim sWhere   As String
    Dim sGroupBy As String
    Dim sOrder   As String
    Dim strTop   As String
    
    sSelect = gDB.GetSelect(sqlstmt)
    sFrom = gDB.GetFrom(sqlstmt)
    sWhere = gDB.GetWhere(sqlstmt)
    sGroupBy = gDB.GetGroup(sqlstmt)
    sOrder = gDB.GetOrder(sqlstmt)
    
    If Not m_Form Is Nothing Then
    
      If m_FieldsToFilter = vbNullString Then pGetFieldsToFilter sSelect, sFrom
    
      strTop = " " & sSelect
      strTop = Replace(strTop, " select ", "")
      strTop = Left$(Trim(strTop), 4)
      If LCase(strTop) = "top " Then
        m_Form.HaveTop = True
      End If
    End If
    
    ' Habria que agregar el filtro al sqlstmt
    If LenB(Trim(filter)) Or LenB(Trim(m_Filter)) Or LenB(Trim(m_FieldValueProcess)) Or bHaveActive Then
      
      filter = pGetFilter(filter, iLike)
      
      If LenB(Trim(filter)) Then
        If LenB(Trim(sWhere)) Then
          sWhere = sWhere & " and (" & filter & ")"
        Else
          sWhere = " where (" & filter & ")"
        End If
      End If
      
      If LenB(Trim(m_Filter)) Then
        If LenB(Trim(sWhere)) Then
          sWhere = sWhere & " and (" & m_Filter & ")"
        Else
          sWhere = " where (" & m_Filter & ")"
        End If
      End If
      
      If bHaveActive And Not m_bForAbm Then
        If LenB(Trim(sWhere)) Then
          sWhere = sWhere & " and (" & tblName & ".activo <> 0)"
        Else
          sWhere = " where (" & tblName & ".activo <> 0)"
        End If
      End If
      
      If LenB(Trim(m_FieldValueProcess)) Then
        sSelect = sSelect & "," & m_FieldValueProcess
      End If
      
      sqlstmt = sSelect & " " & sFrom & " " & sWhere & " " & sGroupBy & " " & sOrder
    End If
  
  Else
    
    If InStr(1, LCase(sqlstmt), "@@no_sort") <> 0 Then
      sqlstmt = Replace(LCase(sqlstmt), "@@no_sort", vbNullString)
      bNoSort = True
    Else
      bNoSort = False
    End If
    
    m_Form.HaveTop = True
    sqlstmt = sqlstmt & " " & gDB.sqlString(filter) & ",0,0"
    
    sqlstmt = Replace(LCase(sqlstmt), "@@bforabm", IIf(m_bForAbm, 1, 0))
    sqlstmt = Replace(LCase(sqlstmt), "@@bfiltertype", iLike)
    
    If LenB(Trim(m_Filter)) Then
      Dim Filter2 As String
      Filter2 = m_Filter
      If Right$(Trim$(Filter2), 1) <> "'" Then Filter2 = "'" & Filter2 & "'"
      sqlstmt = sqlstmt & "," & Filter2
    End If
    
    If TypeOf m_Form Is fHelp Then
      
      Dim F As fHelp
      Set F = m_Form
      
      If F.IsKeyFilterHelp Then
      
        If LenB(Trim(m_Filter)) Then
          sqlstmt = sqlstmt & "," & F.prch_id
        Else
          sqlstmt = sqlstmt & ",''," & F.prch_id
        End If
        
      End If
    End If
  End If
  
  GetItems = gDB.OpenRs(sqlstmt, rs, csRsKeySet, csLockReadOnly, , "GetItems - Para " + m_DiccTabla.Name + "\n" + sqlstmt, "cHelp")
  
  If bNoSort = False Then
    RsSort rs, 1
  End If
  
  Set m_Form.rs = rs

End Function

Private Function pGetFilter(ByVal toSearch As String, ByVal iLike As Long) As String
  Dim numberFilter As String
  Dim filter As String
  
  filter = toSearch
  
  If filter = vbNullString Then Exit Function
  If m_FieldsToFilter = vbNullString And m_FieldsToFilterInt = vbNullString Then Exit Function
  If Not IsNumeric(filter) And m_FieldsToFilter = vbNullString Then Exit Function
  
  filter = gDB.sqlString(filter)
  filter = Mid(filter, 2)
  
  If Len(filter) < 1 Then Exit Function
  filter = Mid(filter, 1, Len(filter) - 1)
  
  Select Case iLike

    Case 1
    
      filter = filter & "%"
      
    Case 3
    
      filter = Replace(filter, "*", "%")
      
    Case 4
    
      filter = "%" & filter
      
    Case 5
    
        ' nada que hacer@@filter

    ' Default
    ' case 2 then '%' + @@filter + '%'
    Case Else
      
      filter = "%" & filter & "%"

  End Select
      
  If IsNumeric(toSearch) Then
    numberFilter = Replace(m_FieldsToFilterInt, _
                      "|", _
                      " like '" & filter & "') " & vbCrLf & "or (" _
                      )
  End If
  
  filter = Replace(m_FieldsToFilter, "|", " like '" & filter & "') " & vbCrLf & "or (") & numberFilter
  
  If Len(filter) < 6 Then Exit Function
  filter = Mid(filter, 1, Len(filter) - 5)
  
  pGetFilter = "(" & filter
End Function

Private Sub pGetFieldsToFilter(ByVal sSelect As String, _
                               ByVal sFrom As String)

  Dim rs        As ADODB.Recordset
  Dim sqlstmt   As String
  Dim fld       As ADODB.Field
  
  sqlstmt = sSelect & sFrom & " where 1 = 2"
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  m_FieldsToFilter = vbNullString
  m_FieldsToFilterInt = vbNullString
  
  For Each fld In rs.Fields
    Select Case fld.Type
      Case adVarChar
        m_FieldsToFilter = m_FieldsToFilter & pGetRealName(fld.Name, sSelect) & "|"
      Case adInteger, adDecimal, adDouble, adNumeric
        m_FieldsToFilterInt = m_FieldsToFilterInt & "convert(varchar(20)," & pGetRealName(fld.Name, sSelect) & ")|"
    End Select
  Next
End Sub

Private Function pGetRealName(ByVal ColAlias As String, ByVal sSelect As String) As String
  Dim i As Long
  Dim n As Long
  Dim ColAlias2 As String
  
  ' Le quito el select
  '
  sSelect = Trim$(sSelect)
  sSelect = Trim$(Mid$(sSelect, 7))
  
  ' Le quito el top
  '
  If LCase$(Left$(sSelect, 4)) = "top " Then
    sSelect = Trim$(Mid$(sSelect, 5))
    i = InStr(1, sSelect, " ")
    sSelect = Mid$(sSelect, i + 1)
  End If
  
  ' Le quito los espacios
  '
  sSelect = Replace$(sSelect, " ", "")
  ColAlias = Replace$(ColAlias, " ", "")
  
  ' Busco casos tipo:  select Nombre = pr_nombrecompra, .....
  '
  ColAlias2 = ColAlias & "="
  n = InStr(1, sSelect, ColAlias2, vbTextCompare)
  If n > 0 Then
    n = n + Len(ColAlias2)
    i = InStr(n, sSelect, ",")
    If i = 0 Then i = Len(sSelect) + 1
    ColAlias = Mid$(sSelect, n, i - n)
  
  Else
    ' Busco casos tipo:  select pr_nombrecompra as Nombre, .....
    '
    ColAlias2 = "as" & ColAlias
    n = InStr(1, sSelect, ColAlias2, vbTextCompare)
    If n > 0 Then
      i = pGetBeginBlock(n, sSelect, C_StrColon, True) + 1
      If i = 0 Then i = 1
      ColAlias = Mid$(sSelect, i, n - i)
    Else
      ' Busco casos tipo:  select pr_nombrecompra as [Nombre], .....
      '
      ColAlias2 = "as[" & ColAlias
      n = InStr(1, sSelect, ColAlias2, vbTextCompare)
      If n > 0 Then
        i = pGetBeginBlock(n, sSelect, C_StrColon, True) + 1
        If i = 0 Then i = 1
        ColAlias = Mid$(sSelect, i, n - i)
      End If
    End If
  End If
  pGetRealName = ColAlias
End Function

Private Function pGetBeginBlock(ByVal nStart As Long, ByVal sSelect As String, _
                                ByVal sSep As String, ByVal ToBack As Boolean) As Long
  Dim i     As Long
  Dim Max   As Long
  
  i = nStart
  nStart = 0
  
  If ToBack Then
    Do While i > 0
      If Mid(sSelect, i, 1) = sSep Then
        nStart = i
        Exit Do
      End If
      i = i - 1
    Loop
  Else
    Max = Len(sSelect) + 1
    Do While i < Max
      If Mid(sSelect, i, 1) = sSep Then
        nStart = i
        Exit Do
      End If
      i = i + 1
    Loop
  End If
  
  pGetBeginBlock = nStart
End Function

Private Sub pSetProductoHelp()
  
  If Not pIsTableProducto() Then Exit Sub
  
  Dim sqlstmt         As String
  Dim rs              As ADODB.Recordset
  Dim prhc_id_default As Long
  
  If Not TypeOf m_Form Is fHelp Then Exit Sub
  
  sqlstmt = "select * from ProductoHelpConfig where activo <> 0"
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Sub
  
  Dim F As fHelp
  
  Set F = m_Form
  
  F.InitKeyFilter
  
  F.AddKeyFilter 0, vbNullString, "(Sin Filtro)"

  While Not rs.EOF
  
    If m_bIsForServicios Then
    
      If gDB.ValField(rs.Fields, cscPrhcDefaultSrv) Then
        prhc_id_default = gDB.ValField(rs.Fields, cscPrhcId)
      End If
    
    ElseIf m_bIsForParteRep Then
    
      If gDB.ValField(rs.Fields, cscPrhcDefaultPrp) Then
        prhc_id_default = gDB.ValField(rs.Fields, cscPrhcId)
      End If
      
    ElseIf m_bIsForProductoSerie Then
    
      If gDB.ValField(rs.Fields, cscPrhcDefaultPrns) Then
        prhc_id_default = gDB.ValField(rs.Fields, cscPrhcId)
      End If
    
    Else
    
      If gDB.ValField(rs.Fields, cscPrhcDefault) Then
        prhc_id_default = gDB.ValField(rs.Fields, cscPrhcId)
      End If
      
    End If
  
    F.AddKeyFilter gDB.ValField(rs.Fields, cscPrhcId), _
                   gDB.ValField(rs.Fields, cscPrhcTecla), _
                   gDB.ValField(rs.Fields, cscPrhcNombre)
  
    rs.MoveNext
  Wend
  
  F.ShowKeyFilter prhc_id_default
  
End Sub

Private Function pIsTableProducto() As Boolean
  pIsTableProducto = m_DiccTabla.FieldId = cscPrId
End Function

Private Function pReplaceMacrosInFilter(ByVal filter As String) As String
  
  m_bIsForServicios = False
  m_bIsForParteRep = False
  m_bIsForProductoSerie = False
  
  If InStr(1, filter, c_filter_is_for_servicios) Then
  
    m_bIsForServicios = True
    filter = Replace$(filter, c_filter_is_for_servicios, vbNullString)
  End If
  
  If InStr(1, filter, c_filter_is_for_parte_rep) Then
  
    m_bIsForParteRep = True
    filter = Replace$(filter, c_filter_is_for_parte_rep, vbNullString)
  End If
  
  If InStr(1, filter, c_filter_is_for_producto_serie) Then
  
    m_bIsForProductoSerie = True
    filter = Replace$(filter, c_filter_is_for_producto_serie, vbNullString)
  End If
  
  pReplaceMacrosInFilter = filter
End Function

Private Sub pShowCbFilter(ByVal sqlstmt As String)
  If InStr(1, sqlstmt, "select", vbTextCompare) = 0 Then
    If InStr(1, sqlstmt, "@@bfiltertype", vbTextCompare) = 0 Then
      If TypeOf m_Form Is fHelp Then
        m_Form.cbFilter.Visible = False
      End If
    End If
  End If
End Sub

' construccion - destruccion

VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cHelpLD"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cHelpLD
' 16-11-10

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
  ' constantes
  ' estructuras
  ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cHelpLD"

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
Private m_Form                      As Object
Private m_Filter                    As String
Private m_FieldValueProcess         As String
Private m_FieldsToFilter            As String
Private m_FieldsToFilterInt         As String
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
Public Property Let IsSearch(ByVal rhs As Boolean)
  m_bIsSearch = rhs
End Property
' Properties privadas
' pseudo eventos
Public Sub ReloadRs()
  pReloadRs m_Form
End Sub

' funciones publicas
Public Sub Show(ByRef F As Object, ByVal Table As csTables, _
                ByVal Id As String, ByVal Name As String, ByVal ValueProcess As String, _
                Optional ByVal TypeHelp As csHelpType = csNormal, _
                Optional ByVal Filter As String, _
                Optional ByVal SPFilter As String, _
                Optional ByVal ColumnValueProcess As String, _
                Optional ByVal bForAbm As Boolean)
  
  Dim bMultiSelect As Boolean
  
  If TypeHelp <> csNormal Then Exit Sub

  Set m_Form = F

  If TypeHelp = csMultiSelect Then
    bMultiSelect = True
    TypeHelp = csNormal
  End If
  
  Filter = pReplaceMacrosInFilter(Filter)
  
  m_Filter = Filter
  m_FieldValueProcess = ColumnValueProcess
  
  Set m_DiccTabla = New cDiccTabla
  
  If TypeHelp = 0 Then TypeHelp = csNormal
  
  If Not m_DiccTabla.Load(Table) Then Exit Sub
  If Not m_DiccTabla.HaveTree Then TypeHelp = csNormal
  
  Dim Prefix As String
  
  Prefix = vbNullString
  
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

  If Not GetItems(sqlstmt, _
                  m_DiccTabla.HaveActive, _
                  m_DiccTabla.NameFisic, _
                  vbNullString, _
                  pGetLike(m_Form)) Then Exit Sub
    
  If Not m_Form.LoadItems() Then Exit Sub
  
  If bMultiSelect Then
    m_Form.lvSearchResult.MultiSelect = True
  End If
End Sub

Public Function ShowResult() As cHelpResult
  Set ShowResult = New cHelpResult
  If m_Form.Ok Then
    ShowResult.Create m_Form.Id, m_Form.FormName, m_Form.Code, False
  Else
    ShowResult.Create csNO_ID, vbNullString, vbNullString, True
  End If
End Function

Public Function ValidateEx(ByVal Table As csTables, _
                           ByVal Text As String, _
                           ByVal TextId As String, _
                           Optional ByVal Filter As String, _
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
          sqlstmt = Replace(LCase(sqlstmt), "@@bforabm", 0)
          sqlstmt = Replace(LCase(sqlstmt), "@@bfiltertype", 0)
          sqlstmt = sqlstmt & " '" & Text & "',-1," & Val(TextId)
          
          If LenB(Filter) Then
            If Right$(Trim$(Filter), 1) <> "'" Then Filter = "'" & Filter & "'"
            sqlstmt = sqlstmt & "," & Filter
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
            
            If LenB(Trim(Filter)) Then sWhere = sWhere & " and (" & Filter & ")"
            
            If Id <> 0 Then sWhere = sWhere & " and " & .FieldId & " = " & Id
            
            ' Tiene que estar activo si tiene activo
            '
            If .HaveActive Then
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
        Set ValidateEx = ValidateEx(Table, Text, 0, Filter)
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

  Dim Filter As String
  
  Filter = frm.txSearch.Text
  
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
           Filter, _
           pGetLike(frm)

  GoTo ExitProc
ControlError:
  MngError Err, "pReloadRs", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Function pGetLike(ByRef frm As Object) As Long
  pGetLike = ListID(frm.cbFilter)
End Function

Private Function GetItems(ByVal sqlstmt As String, _
                          ByVal bHaveActive As Boolean, _
                          ByVal tblName As String, _
                          ByVal Filter As String, _
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
    If LenB(Trim(Filter)) Or LenB(Trim(m_Filter)) Or LenB(Trim(m_FieldValueProcess)) Or bHaveActive Then
      
      Filter = pGetFilter(Filter, iLike)
      
      If LenB(Trim(Filter)) Then
        If LenB(Trim(sWhere)) Then
          sWhere = sWhere & " and (" & Filter & ")"
        Else
          sWhere = " where (" & Filter & ")"
        End If
      End If
      
      If LenB(Trim(m_Filter)) Then
        If LenB(Trim(sWhere)) Then
          sWhere = sWhere & " and (" & m_Filter & ")"
        Else
          sWhere = " where (" & m_Filter & ")"
        End If
      End If
      
      If bHaveActive Then
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
    sqlstmt = sqlstmt & " " & gDB.sqlString(Filter) & ",0,0"
    
    sqlstmt = Replace(LCase(sqlstmt), "@@bforabm", 0)
    sqlstmt = Replace(LCase(sqlstmt), "@@bfiltertype", iLike)
    
    If LenB(Trim(m_Filter)) Then
      Dim Filter2 As String
      Filter2 = m_Filter
      If Right$(Trim$(Filter2), 1) <> "'" Then Filter2 = "'" & Filter2 & "'"
      sqlstmt = sqlstmt & "," & Filter2
    End If
    
  End If
  
  GetItems = gDB.OpenRs(sqlstmt, rs, csRsKeySet, csLockReadOnly, , "GetItems - Para " + m_DiccTabla.Name + "\n" + sqlstmt, "cHelpLD")
  
  If bNoSort = False Then
    RsSort rs, 1
  End If
  
  Set m_Form.rs = rs

End Function

Private Function pGetFilter(ByVal Filter As String, ByVal iLike As Long) As String
  Dim Filter2 As String
  
  If Filter = vbNullString Then Exit Function
  If m_FieldsToFilter = vbNullString And m_FieldsToFilterInt = vbNullString Then Exit Function
  If Not IsNumeric(Filter) And m_FieldsToFilter = vbNullString Then Exit Function
  
  Filter = gDB.sqlString(Filter)
  Filter = Mid(Filter, 2)
  
  If Len(Filter) < 1 Then Exit Function
  Filter = Mid(Filter, 1, Len(Filter) - 1)
  
  Select Case iLike

    Case 1
    
      Filter = Filter & "%"
      
    Case 3
    
      Filter = Replace(Filter, "*", "%")
      
    Case 4
    
      Filter = "%" & Filter
      
    Case 5
    
        ' nada que hacer@@filter

    ' Default
    ' case 2 then '%' + @@filter + '%'
    Case Else
      
      Filter = "%" & Filter & "%"

  End Select
      
  If IsNumeric(Filter) Then
    Filter2 = Replace(m_FieldsToFilterInt, _
                      "|", _
                      " like '" & Filter & "') " & vbCrLf & "or (" _
                      )
  End If
  
  Filter = Replace(m_FieldsToFilter, "|", " like '" & Filter & "') " & vbCrLf & "or (") & Filter2
  
  If Len(Filter) < 6 Then Exit Function
  Filter = Mid(Filter, 1, Len(Filter) - 5)
  
  pGetFilter = "(" & Filter
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

Private Function pReplaceMacrosInFilter(ByVal Filter As String) As String
  
  m_bIsForServicios = False
  m_bIsForParteRep = False
  m_bIsForProductoSerie = False
  
  If InStr(1, Filter, c_filter_is_for_servicios) Then
  
    m_bIsForServicios = True
    Filter = Replace$(Filter, c_filter_is_for_servicios, vbNullString)
  End If
  
  If InStr(1, Filter, c_filter_is_for_parte_rep) Then
  
    m_bIsForParteRep = True
    Filter = Replace$(Filter, c_filter_is_for_parte_rep, vbNullString)
  End If
  
  If InStr(1, Filter, c_filter_is_for_producto_serie) Then
  
    m_bIsForProductoSerie = True
    Filter = Replace$(Filter, c_filter_is_for_producto_serie, vbNullString)
  End If
  
  pReplaceMacrosInFilter = Filter
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

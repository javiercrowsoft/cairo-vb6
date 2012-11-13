VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 3  'UsesTransaction
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
' estructuras
' variables privadas
Private m_dbh As cDBHelper
' Properties publicas
' Properties privadas
' funciones publicas
Public Function ValidateEx(ByVal Table As Long, _
                           ByVal Text As String, _
                           ByVal TextId As String, _
                           Optional ByVal Filter As String) As cHelpResult
  On Error GoTo ControlError

  Dim rs              As ADODB.Recordset
  Dim sqlstmt         As String
  Dim bSp             As Boolean
  Dim bExistsWhere    As Boolean
  Dim ID              As Long
  Dim bBranch         As Boolean
  Dim DiccTabla       As cDiccTabla
  
  Set ValidateEx = New cHelpResult
  ValidateEx.Create 0, Text, Text, True
  
  Set DiccTabla = New cDiccTabla
  If Not DiccTabla.Load(Table) Then Exit Function
  
  Text = Replace(Text, "'", "''")

  ' Si se trata de una rama valido que exista la rama
  If Left$(TextId, 1) = KEY_NODO Then
  
    ID = Val(Mid$(TextId, 2))
  
    sqlstmt = "select ram_id, ram_nombre, ram_nombre as dummy"
    sqlstmt = sqlstmt & " from rama,arbol where ram_nombre = '" & Text & "'"
    sqlstmt = sqlstmt & " and rama.arb_id = arbol.arb_id"
    sqlstmt = sqlstmt & " and tbl_id = " & Table
    
    If ID <> 0 Then
      sqlstmt = sqlstmt & " and ram_id = " & ID
    End If
    
    Set rs = m_dbh.RunSQLReturnRS(sqlstmt)
    
    bBranch = True
  ' Valido que exista el registro en la tabla
  Else
    
    ID = Val(TextId)
    
    Dim fieldId     As String
    Dim FieldName   As String
    Dim FieldCode   As String
    Dim FilterChek  As String

    With DiccTabla
      
      fieldId = .fieldId
      FieldName = .FieldName
      FieldCode = .FieldCode
      
      ' Si es un SP
      If InStr(1, .SqlHelp, "select", vbTextCompare) = 0 Then
        sqlstmt = .SqlHelp & " '" & Text & "',-1," & Val(TextId)
        If Filter <> "" Then
          sqlstmt = sqlstmt & "," & Filter
        End If
      Else
        If .OriginalSqlHelp = "" Then
          sqlstmt = "select " & .fieldId & "," & .FieldName & "," & .FieldCode & " from " & .NameFisic
        Else
          sqlstmt = .OriginalSqlHelp
        End If
        
        If Not Trim(.Where) = "" Then sqlstmt = sqlstmt & " where (" & .Where & ")"
        FilterChek = "(" & .FieldCode & "='" & Text & "') or (" & .FieldName & "='" & Text & "')"
      End If
    End With
    
    If InStr(1, sqlstmt, "select", vbTextCompare) > 0 Then
      Dim sSelect     As String
      Dim sFrom       As String
      Dim sWhere      As String
      Dim sGroupBy    As String
      Dim sOrder      As String
      
      sSelect = GetSelect(sqlstmt)
      sFrom = GetFrom(sqlstmt)
      sWhere = GetWhere(sqlstmt)
      sGroupBy = GetGroup(sqlstmt)
      sOrder = GetOrder(sqlstmt)
      
      bExistsWhere = Trim(sWhere) <> ""
      
      If bExistsWhere Then
        sWhere = sWhere & " and (" & FilterChek & ")"
      Else
        sWhere = " where (" & FilterChek & ") "
        bExistsWhere = True
      End If
      
      If Trim(Filter) <> "" Then sWhere = sWhere & " and (" & Filter & ")"
      
      If ID <> 0 Then sWhere = sWhere & " and " & DiccTabla.fieldId & " = " & ID
      
      sqlstmt = sSelect & " " & sFrom & " " & sWhere & " " & sGroupBy & " " & sOrder
    Else
      bSp = True
    End If
    
    sqlstmt = Replace(sqlstmt, "@@emp_id", 0)
    sqlstmt = Replace(sqlstmt, "@@us_id", 1)
    sqlstmt = Replace(sqlstmt, "@@bForAbm", 0)
    
    Set rs = m_dbh.RunSQLReturnRS(sqlstmt)
  End If
  
  If Not rs.EOF Then
    If bSp Then
      ValidateEx.Create NullsToZero(rs.Fields(0)), ConvertToString(rs.Fields(1)), ConvertToString(rs.Fields(2)), False
    ElseIf bBranch Then
      ValidateEx.Create KEY_NODO & NullsToZero(rs.Fields(0)), ConvertToString(rs.Fields(1)), ConvertToString(rs.Fields(2)), False
    Else
      
      ValidateEx.Create NullsToZero(rs.Fields(fieldId)), ConvertToString(rs.Fields(FieldName)), ConvertToString(rs.Fields(FieldCode)), False
    End If
  Else
    ' Pruebo una vez mas para ver si
    ' existe alguno con el codigo o el nombre igual
    ' al texto que me pasaron
    If ID <> 0 Then
      Set ValidateEx = ValidateEx(Table, Text, 0, Filter)
    End If
  End If

  GetObjectContext.SetComplete
  Exit Function
      
ControlError:
  CtxRaiseError C_Module, "ValidateEx"
End Function

Public Function Validate(ByVal UsId As Long, _
                         ByVal EmpId As Long, _
                         ByVal Table As Long, _
                         ByVal Text As String, _
                         Optional ByVal Filter As String) As cHelpResult

  On Error GoTo ControlError

  Dim rs As ADODB.Recordset
  Dim sqlstmt As String
  Dim bSp As Boolean
  
  Set Validate = New cHelpResult
  Validate.Create 0, Text, Text, True
  
  Dim DiccTabla As cDiccTabla
  
  Set DiccTabla = New cDiccTabla
  If Not DiccTabla.Load(Table) Then Exit Function
  
  Text = Replace(Text, "'", "''")
  
  Dim fieldId As String
  Dim FieldName As String
  Dim FieldCode As String
  
  With DiccTabla
    
    fieldId = .fieldId
    FieldName = .FieldName
    FieldCode = .FieldCode
    
    If .SqlHelpWeb <> "" Then
      sqlstmt = .SqlHelpWeb & " " & UsId & "," & EmpId & ","
    Else
    
      If InStr(1, .SqlHelp, "select", vbTextCompare) > 0 Then
        sqlstmt = "select " & .fieldId & "," & .FieldName & "," & .FieldCode & " from " & .NameFisic
        sqlstmt = sqlstmt & " where ((" & .FieldCode & "='" & Text & "') or (" & .FieldName & "='" & Text & "'))"
        sqlstmt = sqlstmt & IIf(Trim(.Where) = "", "", " and (" & .Where & ")")
      Else
        sqlstmt = .SqlHelp & " '" & Text & "',-1"
      End If
    End If
  End With
  
  If InStr(1, sqlstmt, "select", vbTextCompare) > 0 Then
    If Trim(Filter) <> "" Then
      Dim sSelect  As String
      Dim sFrom  As String
      Dim sWhere   As String
      Dim sGroupBy As String
      Dim sOrder   As String
      
      sSelect = GetSelect(sqlstmt)
      sFrom = GetFrom(sqlstmt)
      sWhere = GetWhere(sqlstmt)
      sGroupBy = GetGroup(sqlstmt)
      sOrder = GetOrder(sqlstmt)
      
      If Trim(sWhere) <> "" Then
        sWhere = sWhere & " and (" & Filter & ")"
      Else
        sWhere = " where (" & Filter & ") "
      End If
      
      sqlstmt = sSelect & " " & sFrom & " " & sWhere & " " & sGroupBy & " " & sOrder
    End If
  Else
    bSp = True
  End If
  
  sqlstmt = Replace(sqlstmt, "@@emp_id", 0)
  sqlstmt = Replace(sqlstmt, "@@us_id", 1)
  sqlstmt = Replace(sqlstmt, "@@bForAbm", 0)
  
  Set rs = m_dbh.RunSQLReturnRS(sqlstmt)
  
  If Not rs.EOF Then
    If bSp Then
      Validate.Create NullsToZero(rs.Fields(0)), ConvertToString(rs.Fields(1)), ConvertToString(rs.Fields(2)), False
    Else
      Validate.Create NullsToZero(rs.Fields(fieldId)), ConvertToString(rs.Fields(FieldName)), ConvertToString(rs.Fields(FieldCode)), False
    End If
  End If

  GetObjectContext.SetComplete
  Exit Function
      
ControlError:
  CtxRaiseError C_Module, "Validate"
End Function

Public Function GetRows(ByVal UsId As Long, _
                        ByVal EmpId As Long, _
                        ByVal Table As Long, _
                        Optional ByVal Filter As String) As Recordset
                        
  On Error GoTo ControlError
  
  Dim DiccTabla As cDiccTabla
  Dim sqlstmt   As String
  
  Set DiccTabla = New cDiccTabla
  If Not DiccTabla.Load(Table) Then Exit Function
  
  If DiccTabla.SqlHelpWeb <> "" Then
    sqlstmt = DiccTabla.SqlHelpWeb & " " & UsId & "," & EmpId & ","
  Else
    sqlstmt = DiccTabla.SqlHelp
  End If
  
  Set GetRows = GetItems(sqlstmt, DiccTabla.HaveActive, DiccTabla.NameFisic, Filter)

  GetObjectContext.SetComplete
  Exit Function
      
ControlError:
  CtxRaiseError C_Module, "GetItems"
End Function

' funciones privadas
Private Function GetItems(ByVal sqlstmt As String, _
                          ByVal bHaveActive As Boolean, _
                          ByVal tblName As String, _
                          ByVal Filter As String) As Recordset
                         
  On Error GoTo ControlError
  
  If InStr(1, sqlstmt, "select", vbTextCompare) > 0 Then
  
    Dim sSelect  As String
    Dim sFrom    As String
    Dim sWhere   As String
    Dim sGroupBy As String
    Dim sOrder   As String
    
    sSelect = GetSelect(sqlstmt)
    sFrom = GetFrom(sqlstmt)
    sWhere = GetWhere(sqlstmt)
    sGroupBy = GetGroup(sqlstmt)
    sOrder = GetOrder(sqlstmt)
    
    Dim FieldsToFilter  As String
    Dim Filter2         As String
    
    FieldsToFilter = pGetFieldsToFilter(sSelect, sFrom)
    
    ' Habria que agregar el filtro al sqlstmt
    If Trim(Filter2) <> "" Or Trim(Filter) <> "" Or bHaveActive Then
      
      Filter = pGetFilter(Filter, FieldsToFilter)
      
      If Trim(Filter) <> "" Then
        If Trim(sWhere) <> "" Then
          sWhere = sWhere & " and (" & Filter & ")"
        Else
          sWhere = " where (" & Filter & ")"
        End If
      End If
      
      If Trim(Filter2) <> "" Then
        If Trim(sWhere) <> "" Then
          sWhere = sWhere & " and (" & Filter2 & ")"
        Else
          sWhere = " where (" & Filter2 & ")"
        End If
      End If
      
      If bHaveActive Then
        If Trim(sWhere) <> "" Then
          sWhere = sWhere & " and (" & tblName & ".activo <> 0)"
        Else
          sWhere = " where (" & tblName & ".activo <> 0)"
        End If
      End If
      
      sqlstmt = sSelect & " " & sFrom & " " & sWhere & " " & sGroupBy & " " & sOrder
    End If
  
  Else
    
'    If Trim(Filter2) <> "" Then
'      If Trim(Filter) <> "" Then
'        Filter = Filter & " and (" & Filter2 & ")"
'      Else
'        Filter = Filter2
'      End If
'    End If
    
    sqlstmt = sqlstmt & " " & sqlString(Filter) & ",0"
  
    If Trim(Filter2) <> "" Then
      sqlstmt = sqlstmt & "," & Filter2
    End If
  End If
  
  sqlstmt = Replace(sqlstmt, "@@emp_id", 0)
  sqlstmt = Replace(sqlstmt, "@@us_id", 1)
  sqlstmt = Replace(sqlstmt, "@@bForAbm", 0)
  
  Set GetItems = m_dbh.RunSQLReturnRS(sqlstmt)

  GetObjectContext.SetComplete
  Exit Function
      
ControlError:
  CtxRaiseError C_Module, "GetItems"
End Function

Private Function pGetFilter(ByVal Filter As String, ByVal FieldsToFilter As String) As String
  
  If Filter = "" Then Exit Function
  If FieldsToFilter = "" Then Exit Function
  
  Filter = sqlString(Filter)
  Filter = Mid(Filter, 2)
  
  If Len(Filter) < 1 Then Exit Function
  Filter = Mid(Filter, 1, Len(Filter) - 1)
  
  Filter = Replace(FieldsToFilter, ",", " like '%" & Filter & "%') or (")
  
  If Len(Filter) < 6 Then Exit Function
  Filter = Mid(Filter, 1, Len(Filter) - 5)
  
  pGetFilter = "(" & Filter
End Function

Private Function pGetFieldsToFilter(ByVal sSelect As String, _
                                    ByVal sFrom As String) As String

  On Error GoTo ControlError

  Dim rs              As ADODB.Recordset
  Dim sqlstmt         As String
  Dim fld             As ADODB.Field
  Dim FieldsToFilter  As String
  
  sqlstmt = sSelect & sFrom & " where 1 = 2"
  
  Set rs = m_dbh.RunSQLReturnRS(sqlstmt)
  
  FieldsToFilter = ""
  
  For Each fld In rs.Fields
    Select Case fld.Type
      Case adVarChar
        FieldsToFilter = FieldsToFilter & pGetRealName(fld.Name, sSelect) & ","
    End Select
  Next
  
  pGetFieldsToFilter = FieldsToFilter

  GetObjectContext.SetComplete
  Exit Function
      
ControlError:
  CtxRaiseError C_Module, "pGetFieldsToFilter"
End Function

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
      i = pGetBeginBlock(n, sSelect, ",", True) + 1
      If i = 0 Then i = 1
      ColAlias = Mid$(sSelect, i, n - i)
    Else
      ' Busco casos tipo:  select pr_nombrecompra as [Nombre], .....
      '
      ColAlias2 = "as[" & ColAlias
      n = InStr(1, sSelect, ColAlias2, vbTextCompare)
      If n > 0 Then
        i = pGetBeginBlock(n, sSelect, ",", True) + 1
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
' construccion - destruccion
Private Sub Class_Initialize()
  Set m_dbh = CreateObject("CSWebDataBase.cDBHelper")
End Sub

Private Sub Class_Terminate()
  Set m_dbh = Nothing
End Sub

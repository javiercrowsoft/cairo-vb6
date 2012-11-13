VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cListView"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cListView
' 03-02-00

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cListView"
Private Const ARB_CLIENTE_ID = "LEAVE_ID"   ' Es el id del cliente no de la hoja
Private Const COL_MAX_WIDTH = 10000
Private Const c_col_numeric_macro = "_COL_NUMERIC_"
' estructuras
' Seudo - Variables
Private c_ErrorSave         As String

' variables privadas
Private m_CheckBox          As Boolean
Private m_BackColor         As OLE_COLOR
Private m_IMG_Active_TRUE   As Integer
Private m_IMG_Active_FALSE  As Integer
Private m_IMG_ITEM          As Integer
Private m_ItemIndexId       As Integer
' Properties publicas
Public Property Get Columns(ByRef Grid As Object) As Integer
  Columns = Grid.ColumnHeaders.Count
End Property
Public Property Get Rows(ByRef Grid As Object) As Integer
  Rows = Grid.ListItems.Count
End Property
Public Property Get CheckBox() As Boolean
  CheckBox = m_CheckBox
End Property
Public Property Let CheckBox(ByVal rhs As Boolean)
  m_CheckBox = rhs
End Property
Public Property Get BackColor(ByRef Grid As Object) As OLE_COLOR
  BackColor = m_BackColor
End Property
Public Property Let BackColor(ByRef Grid As Object, ByVal rhs As OLE_COLOR)
  m_BackColor = rhs
  Grid.BackColor = m_BackColor
End Property
Public Property Get IMG_Active_TRUE() As Integer
  IMG_Active_TRUE = m_IMG_Active_TRUE
End Property
Public Property Get IMG_Active_FALSE() As Integer
  IMG_Active_FALSE = m_IMG_Active_FALSE
End Property
Public Property Let IMG_Active_TRUE(ByVal rhs As Integer)
  m_IMG_Active_TRUE = rhs
End Property
Public Property Let IMG_Active_FALSE(ByVal rhs As Integer)
  m_IMG_Active_FALSE = rhs
End Property
Public Property Get IMG_Item() As Integer
  IMG_Item = m_IMG_ITEM
End Property
Public Property Let IMG_Item(ByVal rhs As Integer)
  m_IMG_ITEM = rhs
End Property
Public Property Get Id(ByRef Grid As Object) As Long
  If Grid.SelectedItem Is Nothing Then Exit Property
  Id = Val(Grid.SelectedItem.SubItems(m_ItemIndexId))
End Property
Public Property Get Id2(ByRef Grid As Object) As Long
  If Grid.SelectedItem Is Nothing Then Exit Property
  Id2 = GetIdFromKey(Grid.SelectedItem.Key)
End Property
Public Property Get IdFromItem(ByRef ListItem As Object) As Long
  If m_ItemIndexId Then
    IdFromItem = Val(ListItem.SubItems(m_ItemIndexId))
  Else
    IdFromItem = GetIdFromKey(ListItem.Key)
  End If
End Property
Public Property Get Ids(ByRef Grid As Object, ByRef vIds() As Long) As Boolean
  Dim n  As Long
  Dim i  As Integer
  Dim j  As Integer
  
  For i = 1 To Grid.ListItems.Count
    If Grid.ListItems(i).Selected Then
      n = n + 1
    End If
  Next i
  
  If n = 0 Then
    ReDim vIds(0)
  Else
    ReDim vIds(n - 1)
  End If
  
  j = 0
  For i = 1 To Grid.ListItems.Count
    If Grid.ListItems(i).Selected Then
      vIds(j) = Val(Grid.ListItems(i).SubItems(m_ItemIndexId))
      j = j + 1
    End If
  Next i
  Ids = True
End Property
' Properties privadas
' funciones publicas
Public Function Add() As Boolean

End Function
Public Function Remove(ByRef Grid As Object, ByVal Id As Long) As Boolean
  Dim i As Integer
  For i = 1 To Grid.ListItems.Count
    If GetIdFromKey(Grid.ListItems(i).Key) = Id Then
      Grid.ListItems.Remove i
      Exit For
    End If
  Next
End Function

'-----------------------------------------------------------------------------------------------------------
Public Function AddFromRs(ByRef Grid As Object, rs As ADODB.Recordset) As Boolean
  Dim Item        As MSComctlLib.ListItem
  Dim SubItem     As MSComctlLib.ListSubItem
  
  On Error GoTo ControlError
  
  If Not (rs.EOF And rs.BOF) Then rs.MoveFirst
  
  Set gDB.rs = rs

  While Not gDB.EOF
    
    If Not gDB.EOF_Field Then
      ' La primera vez se le da el id y la segunda se le da el primer Field
                            ' 1er     2do
      Set Item = Grid.ListItems.Add(, GetKey(gDB.Field), gDB.Field)  ' Ver Field para entender Hao indio toro sentado, jejeje !!!
    End If
    While Not gDB.EOF_Field
      Set SubItem = Item.ListSubItems.Add(, , gDB.Field)
      If gDB.FieldType = csFieldBoolean Then
        SubItem.ForeColor = vbBlue
      End If
    Wend
    
    gDB.MoveNext
  Wend
  
  Grid.MultiSelect = False
  If Grid.ListItems.Count > 0 Then Grid.ListItems(Grid.ListItems.Count).Selected = True
  Grid.MultiSelect = True
  
  AddFromRs = True
  GoTo ExitProc
ControlError:
  MngError Err, "AddFromRs", C_Module, vbNullString, LNGGetText(3446, vbNullString), csErrorWarning, csErrorVba
                                                    'Error al actualizar la grilla
ExitProc:
End Function

Public Function AddFromSqlstmt(ByRef Grid As Object, ByVal sqlstmt As String) As Boolean
  Dim rs As ADODB.Recordset
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  If rs.EOF Then Exit Function
  
  AddFromSqlstmt = AddFromRs(Grid, rs)
End Function

Public Function UpdateFromSqlstmt(ByRef Grid As Object, ByVal sqlstmt As String) As Boolean
  Dim rs As ADODB.Recordset
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  If rs.EOF Then Exit Function
  
  Remove Grid, gDB.ValField(rs.Fields, 0)
  
  UpdateFromSqlstmt = AddFromRs(Grid, rs)
End Function

Public Function LoadFromSqlstmt(ByRef Grid As Object, ByVal sqlstmt As String) As Boolean
  Dim rs As ADODB.Recordset
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  LoadFromSqlstmt = LoadFromRecordSet(Grid, rs)
End Function

Public Function LoadFromRecordSet(ByRef Grid As Object, rs As ADODB.Recordset, Optional ByVal Filter As String = "") As Boolean
  LoadFromRecordSet = pLoadFromRecordSet(Grid, rs, True, Filter)
End Function

Public Function LoadFromRecordSetEx(ByRef Grid As Object, rs As ADODB.Recordset, ByVal bLike As Boolean, Optional ByVal Filter As String = "") As Boolean
  LoadFromRecordSetEx = pLoadFromRecordSet(Grid, rs, bLike, Filter)
End Function

Public Function pLoadFromRecordSet(ByRef Grid As Object, rs As ADODB.Recordset, ByVal bLike As Boolean, Optional ByVal Filter As String = "") As Boolean
  Dim Item      As MSComctlLib.ListItem
  Dim SubItem   As MSComctlLib.ListSubItem
  Dim Value     As String
  
  On Error GoTo ControlError
  
  ' Si busco por este metodo anulo
  ' esta variable, por que el id esta en el key
  '
  m_ItemIndexId = 0

  If Not (rs.EOF And rs.BOF) Then rs.MoveFirst
  
  Set gDB.rs = rs
  
  Grid.ColumnHeaders.Clear
  Grid.ListItems.Clear

  ' Title de las Columns
  Dim i As Integer
  Dim Col As ColumnHeader
  Dim bIsNumeric As Boolean
  Dim colName    As String
  
  Dim bExistsColColor      As Boolean
  Dim bExistsColForeColor  As Boolean
  Dim bExistsColBackColor  As Boolean
  Dim ForeColor            As Long
  Dim BackColor            As Long
  
  ' En la primera columna esta el id, el cual va en la Key de la grilla. no hay columna que lo
  ' muestre a diferencia de LoadFromBranch.
  For i = 1 To rs.Fields.Count - 1
    bIsNumeric = pGetColIsNumericByName(rs.Fields.Item(i).Name)
    colName = pGetColName(rs.Fields.Item(i).Name)
    colName = UCase$(Left$(colName, 1)) & Mid$(colName, 2)
    
    Set Col = Grid.ColumnHeaders.Add(, , colName)
    
    ' La primera columna de un listview debe estar alineada a la
    ' izquierda si o si
    '
    If i > 1 Then
      If bIsNumeric Then
        Col.Alignment = lvwColumnRight
      Else
        Col.Alignment = GetAlignmentADO(rs.Fields.Item(i).Type)
      End If
    End If
    
    If Not bExistsColForeColor Then
      If rs.Fields.Item(i).Name = "_col_fore_color_" Then
        bExistsColColor = True
        bExistsColForeColor = True
      End If
    End If
  
    If Not bExistsColBackColor Then
      If rs.Fields.Item(i).Name = "_col_back_color_" Then
        bExistsColColor = True
        bExistsColBackColor = True
      End If
    End If
  Next i
  
  Dim Incluir As Boolean

  While Not gDB.EOF
    
    Incluir = False
    
    If Not ValEmpty(Filter, csText) Then
      If Not gDB.ExistsEnRecordEx(rs, Filter, Incluir, bLike, "LoadFromRecordSet", C_Module) Then Exit Function
    Else
      Incluir = True
    End If
    
    If Incluir Then
    
      If bExistsColColor Then
        
        If bExistsColForeColor Then
          ForeColor = rs.Fields.Item("_col_fore_color_").Value
        End If
        
        If bExistsColBackColor Then
          BackColor = rs.Fields.Item("_col_back_color_").Value
        End If
        
      End If
      
      If Not gDB.EOF_Field Then
        ' La primera vez se le da el id y la segund se le da el primer Field
                              ' 1er     2do
        Set Item = Grid.ListItems.Add(, GetKey(gDB.Field), gDB.Field)   ' Ver Field para entender Hao indio toro sentado, jejeje !!!
      
        If bExistsColColor Then
          If bExistsColForeColor Then
            Item.ForeColor = ForeColor
          End If
          If bExistsColBackColor Then
            ' TODO: para cuando pasemos del listview a la grilla
          End If
        End If
      End If
      
      i = 2
      
      While Not gDB.EOF_Field
        Value = gDB.Field
        If rs.Fields.Item(i).Type = adDecimal Or (rs.Fields.Item(i).Type = adNumeric And rs.Fields.Item(i).NumericScale > 0) Then
          Value = Format(Value, "#,###,##0.00")
        End If
        
        Set SubItem = Item.ListSubItems.Add(, , Value)
        
        If LCase(rs.Fields.Item(i).Name) = LCase(cscActivo) Then
          If Val(Value) Then
            SubItem.ForeColor = RGB(0, 99, 0)
            SubItem.Text = "[x]"
          Else
            SubItem.ForeColor = vbRed
            SubItem.Text = "[0]"
          End If
        ElseIf gDB.FieldType = csFieldBoolean Then
          SubItem.ForeColor = vbBlue
        End If
        
        If bExistsColColor Then
          If bExistsColForeColor Then
            SubItem.ForeColor = ForeColor
          End If
          If bExistsColBackColor Then
            ' TODO: para cuando pasemos del listview a la grilla
          End If
        End If
        
        i = i + 1
      Wend
    End If
    gDB.MoveNext
  Wend
  
  If Grid.ListItems.Count > 0 Then
    Dim oldMultiSelect As Boolean
    
    oldMultiSelect = Grid.MultiSelect
    Grid.MultiSelect = False
    Grid.ListItems(1).Selected = True
    Grid.MultiSelect = oldMultiSelect
  End If
  
  pLoadFromRecordSet = True
  GoTo ExitProc
ControlError:
  MngError Err, "pLoadFromRecordSet", C_Module, vbNullString, c_ErrorSave, csErrorWarning, csErrorVba
ExitProc:
End Function

Public Function LoadLeavesFromRs(ByRef Grid As Object, rs As ADODB.Recordset) As Boolean
  LoadLeavesFromRs = LoadLeavesFromRsEx(Grid, rs, False)
End Function

Public Function LoadLeavesFromRsEx(ByRef Grid As Object, rs As ADODB.Recordset, ByVal ForHelp As Boolean) As Boolean
  Dim Item        As MSComctlLib.ListItem
  Dim SubItem     As MSComctlLib.ListSubItem
  
  Dim col1      As String
  Dim col2      As String
  Dim col3      As String
  Dim NotHaveIcons As Boolean
  
  Dim k As Integer
  Dim Value As Variant
  
  On Error GoTo ControlError
  
  NotHaveIcons = Grid.SmallIcons Is Nothing Or (m_IMG_Active_FALSE = 0 Or m_IMG_Active_TRUE = 0)
  
  If Not (rs.EOF And rs.BOF) Then
    rs.MoveLast
    rs.MoveFirst
        
    RsSort rs, 2
    If rs.RecordCount > 200 Then
      Dim mouse As cMouseWait
      Set mouse = New cMouseWait
      DoEvents
    End If
  End If
  
  Set gDB.rs = rs
  
  Grid.ColumnHeaders.Clear
  Grid.ListItems.Clear

  ' Headers
  Dim i As Integer
  Dim colName As String
  
  colName = rs.Fields.Item(0).Name
  colName = UCase$(Left$(colName, 1)) & Mid$(colName, 2)
  
  Grid.ColumnHeaders.Add , , colName
  
  For i = 1 To rs.Fields.Count - 1
  
    colName = rs.Fields.Item(i).Name
    colName = UCase$(Left$(colName, 1)) & Mid$(colName, 2)
    With Grid.ColumnHeaders.Add(, , colName)
      .Alignment = GetAlignmentADO(rs.Fields.Item(i).Type)
    End With
  Next i
  
  ' En la tercera Column tengo el nombre
  Grid.ColumnHeaders(1).Text = rs.Fields.Item(2).Name
  Grid.ColumnHeaders(2).Text = rs.Fields.Item(0).Name
  Grid.ColumnHeaders(3).Text = rs.Fields.Item(1).Name
  
  Dim Incluir As Boolean

  ' OJO si el id no se guarda en la segunda llamada
  ' a .Add, debemos actualizar esta linea
  '
  ' Guardo en esta variable en que Columna guarde los id's
  m_ItemIndexId = 2

  While Not rs.EOF
      
    If ForHelp Then
      col1 = Trim$(rs.Fields.Item(1).Value)
      col2 = Trim$(rs.Fields.Item(0).Value)
    Else
      col1 = Trim$(rs.Fields.Item(0).Value)
      col2 = Trim$(rs.Fields.Item(1).Value)
    End If
    
    Set Item = Grid.ListItems.Add(, GetKey(col1), rs.Fields.Item(2).Value)
    Set SubItem = Item.ListSubItems.Add(, , col1)
    
    ' OJO si el id no se guarda en la segunda llamada
    ' a .Add, debemos actualizar la linea que mas arriba
    ' actualiza m_ItemIndexId
    '
    Set SubItem = Item.ListSubItems.Add(, , col2)
    
    Item.Tag = SetInfoString(Item.Tag, ARB_CLIENTE_ID, col2)
    
    For k = 3 To rs.Fields.Count - 1
      
      With rs.Fields.Item(k)
        If LCase(.Name) = LCase(cscActivo) Then
          Set SubItem = Item.ListSubItems.Add()
          If NotHaveIcons Then
            If .Value Then
              SubItem.ForeColor = RGB(0, 99, 0)
              SubItem.Text = "[x]"
            Else
              SubItem.ForeColor = vbRed
              SubItem.Text = "[0]"
            End If
            
          Else
            If .Value Then
              SubItem.ReportIcon = m_IMG_Active_TRUE
            Else
              SubItem.ReportIcon = m_IMG_Active_FALSE
            End If
          End If
        Else
          
          Value = .Value
          
          If IsNull(Value) Then
            Select Case VarType(Value)
              Case VbVarType.vbString, VbVarType.vbDate
                Set SubItem = Item.ListSubItems.Add(, , "")
              Case Else
                Set SubItem = Item.ListSubItems.Add(, , "0")
            End Select
          Else
            Set SubItem = Item.ListSubItems.Add(, , Value)
          End If
        End If
      End With
    Next
    
    rs.MoveNext
  Wend
  
  If Grid.ListItems.Count > 0 Then
      Dim oldMultiSelect As Boolean
      
      oldMultiSelect = Grid.MultiSelect
      Grid.MultiSelect = False
      Grid.ListItems(1).Selected = True
      Grid.MultiSelect = oldMultiSelect
  End If
  
  LoadLeavesFromRsEx = True
  GoTo ExitProc
ControlError:
  MngError Err, "LoadLeavesFromRsEx", C_Module, vbNullString, c_ErrorSave, csErrorWarning, csErrorVba
ExitProc:
End Function

Public Function SetLineFromRecordSet(ByRef Grid As Object, rs As ADODB.Recordset) As Boolean
  Dim Id As Long
  Dim i  As Integer
  On Error GoTo ControlError
  
  Set gDB.rs = rs
  
  While Not gDB.EOF
    ' El primer Field contiene el id
    Id = gDB.Field
    Grid.ListItems(GetKey(Id)).Text = gDB.Field
    While Not gDB.EOF_Field
      Grid.ListItems(GetKey(Id)).ListSubItems(i).Text = gDB.Field
      If gDB.FieldType = csFieldBoolean Then
        i = i + 1
        Grid.ListItems(GetKey(Id)).ListSubItems(i).ForeColor = vbBlue
      End If
    Wend
    gDB.MoveNext
  Wend
    
  SetLineFromRecordSet = True
  Exit Function
ControlError:
  MngError Err, "SetLineFromRecordSet", C_Module, vbNullString, LNGGetText(3447, vbNullString), csErrorWarning, csErrorVba
                                                                'Error al cargar la línea
End Function

'-----------------------------------------------------------------------------------------------------------
' Devuelve un string con el ucase de la suma de todos los Names de Columns
Public Function GetKeyFromColumns(ByVal Branch As cBranch) As String
  Dim Column As cLeaveColumn
  
  For Each Column In Branch.Columns
    GetKeyFromColumns = GetKeyFromColumns + Column.Name
  Next
  GetKeyFromColumns = UCase(GetKeyFromColumns)
End Function

Public Sub GetSelected(ByRef Grid As Object, ByRef Seleccionados() As Long)
  Dim n  As Long
  Dim i  As Integer
  Dim j  As Integer
  
  Dim mouse As cMouseWait
  Set mouse = New cMouseWait
  
  DoEvents
  
  For i = 1 To Grid.ListItems.Count
    If Grid.ListItems(i).Selected Then
      n = n + 1
    End If
  Next i
  
  If n = 0 Then
    ReDim Seleccionados(0)
  Else
    ReDim Seleccionados(n - 1)
  End If
  
  j = 0
  For i = 1 To Grid.ListItems.Count
    If Grid.ListItems(i).Selected Then
      Seleccionados(j) = GetIdFromKey(Grid.ListItems(i).Key)
      j = j + 1
    End If
  Next i
End Sub

' Solo para Grids con multiselect = false
Public Function GetSelectedId(ByRef Grid As Object) As Long
  On Error Resume Next
  
  If Grid.SelectedItem Is Nothing Then Exit Function
  
  If m_ItemIndexId Then
    GetSelectedId = Id(Grid)
  Else
    GetSelectedId = GetIdFromKey(Grid.SelectedItem.Key)
  End If
End Function

Public Function GetSelectedIds(ByRef Grid As Object) As String
  On Error Resume Next
  
  If Grid.SelectedItem Is Nothing Then
    GetSelectedIds = "0"
  Else
    Dim rtn As String
    Dim i As Long
    For i = 1 To Grid.ListItems.Count
      If Grid.ListItems(i).Selected Then
        rtn = rtn & GetIdFromKey(Grid.ListItems(i).Key) & ","
      End If
    Next
    If LenB(rtn) Then
      rtn = RemoveLastColon(rtn)
    Else
      rtn = "0"
    End If
    GetSelectedIds = rtn
  End If
End Function

Public Function GetSelectedName(ByRef Grid As Object) As String
    GetSelectedName = GetSelectedCol(Grid, 1)
End Function

Public Function GetSelectedCode(ByRef Grid As Object) As String
    GetSelectedCode = GetSelectedCol(Grid, 2)
End Function

Public Function GetSelectedCol(ByRef Grid As Object, ByVal Col As Integer) As String
  On Error GoTo ControlError
  If Grid.SelectedItem Is Nothing Then Exit Function
  
  If Col = 1 Then
    GetSelectedCol = Grid.SelectedItem.Text
  ElseIf Grid.SelectedItem.ListSubItems.Count >= Col - 1 Then
    GetSelectedCol = Grid.SelectedItem.SubItems(Col - 1)
  End If
  Exit Function
ControlError:
  MngError Err, "GetSelectedCol", C_Module, vbNullString, LNGGetText(3439, vbNullString, Col), csErrorWarning, csErrorVba
                                                          'Error al obtener la columna  & Col
End Function

Public Function GetSelectedCount(ByRef Grid As Object) As Integer
  Dim n  As Long
  Dim i  As Integer
  Dim j  As Integer
  
  For i = 1 To Grid.ListItems.Count
    If Grid.ListItems(i).Selected Then
      n = n + 1
    End If
  Next i
  
  GetSelectedCount = n
End Function

Public Sub Clear(ByRef Grid As Object)
  Grid.ListItems.Clear
End Sub
'-----------------------------------------------------------------------------------------------------------
Public Sub SetPropertys(ByRef Grid As Object)
  Grid.Checkboxes = m_CheckBox
  Grid.BackColor = m_BackColor
  Grid.AllowColumnReorder = True
  Grid.BorderStyle = ccNone
  Grid.FullRowSelect = True
  Grid.HideColumnHeaders = False
  Grid.View = lvwReport
  Grid.LabelEdit = lvwManual
  Grid.MultiSelect = True
  Grid.GridLines = True
End Sub
Public Sub SaveColumnWidth(ByRef Grid As Object, ByVal Name As String)
  On Error GoTo ControlError
  
  Dim i As Integer
  For i = 1 To Grid.ColumnHeaders.Count
    SetRegistry csInterface, Name + "_COL_" + Trim(i), CInt(Grid.ColumnHeaders(i).Width)
  Next i

ControlError:
End Sub

Public Sub GetColumnWidth(ByRef Grid As Object, _
                          ByVal Name As String, _
                          Optional idxOcultar As Integer = 0)
  
  Dim i As Long
  
  ' Para evitar eventos paint del control
  ' cuando aun no estan listas todas las columnas
  '
  Grid.Visible = False
  
  If gAutoSizeCols Then
    
    For i = 0 To Grid.ColumnHeaders.Count - 1
    
      AutoWidthCol Grid, i
    
    Next
    
  Else
  
    Dim Width     As Long
    Dim FirstCol  As Long
    
    If idxOcultar = 0 Then
      FirstCol = 1
    Else
      idxOcultar = 2
    End If
    
    For i = 1 To Grid.ColumnHeaders.Count
      Width = GetRegistry(csInterface, Name + "_COL_" + Trim(i), -1)
      If Width > -1 Then
        Grid.ColumnHeaders(i).Width = IIf(Width > COL_MAX_WIDTH, COL_MAX_WIDTH, Width)
      Else
        If i = FirstCol Then
          Grid.ColumnHeaders(i).Width = 3500
        Else
          Grid.ColumnHeaders(i).Width = 2000
        End If
      End If
    Next i
    
  End If

  For i = 2 To idxOcultar + 1
    Grid.ColumnHeaders(i).Width = 0
  Next i

  ' Esto es para que la grilla no se dibuje mal
  '
  DoEvents
  Grid.Visible = True
  DoEvents
  Grid.Visible = False
  DoEvents
  Grid.Visible = True

End Sub

Public Sub AutoWidthCol(ByRef Grid As Object, _
                        ByVal iCol As Long)
  SendMessage Grid.hwnd, _
              LVM_SETCOLUMNWIDTH, _
              iCol, _
              ByVal LVSCW_AUTOSIZE_USEHEADER
  
  If Grid.ColumnHeaders.Count > iCol Then
    With Grid.ColumnHeaders(iCol + 1)
      .Width = .Width + 400
    End With
  End If
End Sub

' funciones privadas
Private Function SetValueBoolean(ByRef Grid As Object, ByRef SubItem As MSComctlLib.ListSubItem)
  If Grid.SmallIcons Is Nothing Or (m_IMG_Active_FALSE = 0 Or m_IMG_Active_TRUE = 0) Then
    SubItem.ForeColor = vbBlue
  Else
    If Val(SubItem.Text) Then
      SubItem.ReportIcon = m_IMG_Active_TRUE
    Else
      SubItem.ReportIcon = m_IMG_Active_FALSE
    End If
    SubItem.Text = vbNullString
  End If
End Function

Private Function GetAlignmentADO(ByVal AdoType As Integer) As Integer
  Select Case AdoType
    Case DataTypeEnum.adBoolean
      ' esto es por que el listview no centra iconos
      GetAlignmentADO = lvwColumnLeft
    Case adCurrency, adSingle, adDecimal, adDouble, adBigInt, adBinary, adInteger, adLongVarBinary, adNumeric, adSmallInt, adTinyInt, adUnsignedBigInt, adUnsignedInt, adUnsignedSmallInt, adUnsignedTinyInt
      GetAlignmentADO = lvwColumnRight
    Case Else
      GetAlignmentADO = lvwColumnLeft
  End Select
End Function

Private Function pGetColIsNumericByName(ByVal Name As String) As Boolean
  pGetColIsNumericByName = UCase$(Left$(Name, 13)) = c_col_numeric_macro
End Function

Private Function pGetColName(ByVal Name As String) As String
  pGetColName = Replace(Name, c_col_numeric_macro, "")
End Function

' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  m_BackColor = vbWindowBackground
  c_ErrorSave = LNGGetText(3438, vbNullString) 'Error al cargar la Grilla
  
  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
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


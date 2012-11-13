VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cGridManager"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cGridManager
' 24-08-02

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cGridManager"

Private Const COL_MAX_WIDTH = 10000
Private Const c_noRow = 0

Private Const c_col_width = 60

Private Const c_AuxKey = "K#"

' estructuras
' Seudo - Variables
Private c_ErrorSave       As String

' variables privadas
Private m_CheckBox  As Boolean
Private m_BackColor As OLE_COLOR
Private m_IMG_Active_TRUE   As Integer
Private m_IMG_Active_FALSE  As Integer
Private m_IMG_ITEM          As Integer
Private m_ItemIndexId       As Integer
Private m_ItemIdLeave       As Integer
Private m_Name              As String
Private m_FirstColVisible   As Long
Private m_Views             As cGridViews

'////////////////////////////////////////////////////////////////////
' Argumentos Auxiliares para la llamada desde el form de progreso
'
Private m_p_oGrid As Object
Private m_p_rs As ADODB.Recordset
Private m_p_Filter As String
Private m_p_flds As ADODB.Fields
Private m_p_IndexId As Integer
Private m_p_lastField As Long
Private m_p_iLastCol As Long
Private m_p_bHaveDetail As Boolean
Private m_p_vAlign() As ECGTextAlignFlags
Private m_p_vFormat() As Boolean
Private m_p_prop As Object
Private m_p_bSetView As Boolean
Private m_p_ViewId As Long

' Para Cross Tab
'
Private m_p_columns As String
Private m_p_columns_value As String
Private m_p_columns_type As csTypes
Private m_p_colColumn As String
Private m_p_colRow As String
Private m_p_colValue As String
Private m_p_colGroup As String

' Suma horizontal de los totales y de las cuentas de banco
'
Private m_ColSaldo      As String
Private m_vRowSumIds()  As Long
Private m_RowSumCol     As String

'
' Argumentos Auxiliares para la llamada desde el form de progreso
'////////////////////////////////////////////////////////////////////

Private WithEvents m_fProgress As fProgressGrid
Attribute m_fProgress.VB_VarHelpID = -1
Private m_bLoadCancel As Boolean
Private m_bIsMatrix   As Boolean

' Properties publicas
Public Property Get ColSaldo() As String
  ColSaldo = m_ColSaldo
End Property
Public Property Let ColSaldo(ByVal rhs As String)
  m_ColSaldo = rhs
End Property

Public Property Get RowSumIds() As Long()
  RowSumIds = m_vRowSumIds
End Property

Public Property Let RowSumIds(ByRef rhs() As Long)
  On Error Resume Next
  Dim i As Long
  
  ReDim m_vRowSumIds(UBound(rhs))
  For i = 1 To UBound(rhs)
    m_vRowSumIds(i) = rhs(i)
  Next
End Property

Public Property Get RowSumCol() As String
  RowSumCol = m_RowSumCol
End Property

Public Property Let RowSumCol(ByVal rhs As String)
  m_RowSumCol = rhs
End Property

Public Property Let Name(ByRef rhs As String)
  m_Name = rhs
End Property
Public Property Get Columns(ByVal oGrid As Object) As Integer
  Columns = oGrid.Columns
End Property
Public Property Get Rows(ByVal oGrid As Object) As Integer
  Rows = oGrid.Rows
End Property
Public Property Get CheckBox() As Boolean
  CheckBox = m_CheckBox
End Property
Public Property Let CheckBox(ByVal rhs As Boolean)
  m_CheckBox = rhs
End Property
Public Property Get BackColor(ByVal oGrid As Object) As OLE_COLOR
  BackColor = m_BackColor
End Property
Public Property Let BackColor(ByVal oGrid As Object, ByVal rhs As OLE_COLOR)
  m_BackColor = rhs
  oGrid.BackColor = m_BackColor
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
Public Property Get Id(ByVal oGrid As Object) As Long
  With oGrid
    If .SelectedRow <= 0 Then Exit Property
    Id = .Cell(.SelectedRow, pItemIndexId(oGrid)).ItemData
  End With
End Property
Public Property Get Id2(ByVal oGrid As Object) As Long
  With oGrid
    If .SelectedRow <= 0 Then Exit Property
    Id2 = .Cell(.SelectedRow, m_ItemIdLeave + oGrid.Groups.Count).ItemData
  End With
End Property
Public Property Get Ids(ByVal oGrid As Object, ByRef vIds() As Long) As Boolean
  Dim n    As Long
  Dim i    As Integer
  Dim j    As Integer
  
  With oGrid
    For i = 1 To .Rows
        If .IsRowSelected(i) Then
            n = n + 1
        End If
    Next i
    
    If n = 0 Then
        ReDim vIds(0)
    Else
        ReDim vIds(n - 1)
    End If
    
    j = 0
    For i = 1 To .Rows
        If .IsRowSelected(i) Then
            vIds(j) = .Cell(i, pItemIndexId(oGrid)).ItemData
            j = j + 1
        End If
    Next i
  End With
  
  Ids = True
End Property

Public Property Get IdsLongColumn(ByVal oGrid As Object, _
                                  ByVal strColName As String, _
                                  ByRef vIds() As Long) As Boolean
  Dim n    As Long
  Dim i    As Integer
  Dim j    As Integer
  Dim iCol As Long
  
  With oGrid
    For i = 1 To .Rows
        If .IsRowSelected(i) Then
            n = n + 1
        End If
    Next i
    
    If n = 0 Then
        ReDim vIds(0)
    Else
        ReDim vIds(n - 1)
    End If
    
    strColName = LCase$(strColName)
    For i = 1 To .Columns
      If LCase$(.ColumnHeader(i)) = strColName Then
        iCol = i
        Exit For
      End If
    Next
    
    If iCol > 0 Then

      j = 0
      For i = 1 To .Rows
          If .IsRowSelected(i) Then
              vIds(j) = Val(.Cell(i, iCol).Text)
              j = j + 1
          End If
      Next i
    End If
    
  End With
  
  IdsLongColumn = True
End Property

Public Property Get Views() As cGridViews
  Set Views = m_Views
End Property
' Properties privadas
' funciones publicas
Public Function Add() As Boolean

End Function

Public Function Remove(ByVal oGrid As Object, ByVal Id As Long) As Boolean
  Dim i As Integer
  With oGrid
    For i = 1 To .Rows
      If .Cell(i, pItemIndexId(oGrid)).ItemData = Id Then
        .RemoveRow i
        Exit For
      End If
    Next
  End With
End Function

Public Function DeleteView(ByVal grdv_id As Long) As Boolean
  Dim sqlstmt As String
  sqlstmt = "sp_GridViewDelete " & grdv_id
  DeleteView = gDB.Execute(sqlstmt)
End Function

Public Function SaveView(ByRef oGrid As Object, _
                         ByVal grdv_id As Long) As Boolean

  Dim sqlstmt As String
  sqlstmt = "sp_GridViewDeleteItems " & grdv_id
  
  If Not gDB.Execute(sqlstmt) Then
    Exit Function
  End If
  
  Dim Group     As Object 'cGridGroup
  Dim Filter    As Object 'cGridColFilter
  Dim Format    As Object 'cGridColFormat
  Dim Formula   As Object 'cGridColFormula
  
  For Each Group In oGrid.Groups
    If Not pViewSaveGroup(Group, grdv_id) Then Exit Function
  Next

  For Each Filter In oGrid.Filters
    If Not pViewSaveFilter(Filter, grdv_id) Then Exit Function
  Next

  For Each Format In oGrid.Formats
    If Not pViewSaveFormat(Format, grdv_id) Then Exit Function
  Next

  For Each Formula In oGrid.Formulas
    If Not pViewSaveFormula(Formula, grdv_id) Then Exit Function
  Next

  Dim i As Long

  For i = 1 To oGrid.Columns
    If Not pViewSaveColumn(oGrid, i, grdv_id) Then Exit Function
  Next

  SaveView = True

End Function

Private Function pViewSaveGroup(ByRef Group As Object, _
                                ByVal grdv_id As Long) As Boolean
  Dim sqlstmt As String
  
  sqlstmt = "sp_GridViewSaveGrupo " & grdv_id & "," & _
                                      Group.Index & "," & _
                                      gDB.sqlString(Group.Name) & "," & _
                                      Group.SortType
  
  If Not gDB.Execute(sqlstmt) Then
    Exit Function
  End If

  pViewSaveGroup = True
End Function

Private Function pViewSaveFormat(ByRef Format As Object, _
                                 ByVal grdv_id As Long) As Boolean
  Dim sqlstmt   As String
  Dim FontName  As String
  Dim FontSize  As Double
  
  If Not Format.Font Is Nothing Then
    FontName = Format.Font.Name
    FontSize = Format.Font.Size
  End If
  
  sqlstmt = "sp_GridViewSaveFormato " & grdv_id & "," & _
                                      gDB.sqlString(Format.Column) & "," & _
                                      gDB.sqlString(Format.Column2) & "," & _
                                      gDB.sqlString(Format.CompareTo) & "," & _
                                      Format.Operator & "," & _
                                      gDB.sqlString(FontName) & "," & _
                                      gDB.sqlNumber(FontSize) & "," & _
                                      pViewGetFontStyle(Format.Font) & "," & _
                                      Format.ForeColor & "," & _
                                      Format.BackColor

  If Not gDB.Execute(sqlstmt) Then
    Exit Function
  End If

  pViewSaveFormat = True
End Function

Private Function pViewGetFontStyle(ByRef Font As StdFont) As Long
  If Font Is Nothing Then
    pViewGetFontStyle = 0
  Else
    If Font.Italic Then
      pViewGetFontStyle = 1
    ElseIf Font.Strikethrough Then
      pViewGetFontStyle = 2
    ElseIf Font.Bold Then
      pViewGetFontStyle = 3
    ElseIf Font.Underline Then
      pViewGetFontStyle = 4
    End If
  End If
End Function

Private Function pViewSaveFilter(ByRef Filter As Object, _
                                 ByVal grdv_id As Long) As Boolean
  Dim sqlstmt As String
  
  sqlstmt = "sp_GridViewSaveFiltro " & grdv_id & "," & _
                                      gDB.sqlString(Filter.Column) & "," & _
                                      gDB.sqlString(Filter.Column2) & "," & _
                                      gDB.sqlString(Filter.CompareTo) & "," & _
                                      Filter.Operator
  
  If Not gDB.Execute(sqlstmt) Then
    Exit Function
  End If

  pViewSaveFilter = True
End Function

Private Function pViewSaveFormula(ByRef Formula As Object, _
                                 ByVal grdv_id As Long) As Boolean
  Dim sqlstmt As String
  
  sqlstmt = "sp_GridViewSaveFormula " & grdv_id & "," & _
                                      gDB.sqlString(Formula.Column) & "," & _
                                      Formula.FormulaType & "," & _
                                      Formula.Index
  
  If Not gDB.Execute(sqlstmt) Then
    Exit Function
  End If

  pViewSaveFormula = True
End Function

Private Function pViewSaveColumn(ByRef oGrid As Object, _
                                 ByVal idx As Long, _
                                 ByVal grdv_id As Long) As Boolean
  Dim sqlstmt As String
  Dim colName As String
  colName = oGrid.ColumnHeader(idx)
  If Not CBool(InStr(1, colName, "_id") Or colName = vbNullString) Then
    sqlstmt = "sp_GridViewSaveColumn " & grdv_id & "," & _
                                        gDB.sqlString(colName) & "," & _
                                        IIf(oGrid.ColumnVisible(idx), 1, 0) & "," & _
                                        oGrid.ColumnWidth(idx) & "," & _
                                        oGrid.ColumnIndex(idx)
    
    If Not gDB.Execute(sqlstmt) Then
      Exit Function
    End If
  End If
  
  pViewSaveColumn = True
End Function

'-----------------------------------------------------------------------------------------------------------
Public Function UpdateFromRs(ByVal oGrid As Object, _
                             ByRef rs As ADODB.Recordset, _
                             ByVal iRow As Long, _
                             ByRef prop As Object) As Boolean
  On Error GoTo ControlError
  
  'Dim oGrid As CSGrid2.cGrid
  'Set oGrid = GridObj
  
  oGrid.RowOddColor = 12639458 'vbButtonFace

  If Not (rs.EOF And rs.BOF) Then
    rs.MoveFirst
  End If
  
  Dim iLastCol     As Long
  Dim bHaveDetail  As Boolean
  Dim IndexId      As Long
  Dim offset       As Long
  
  Dim vAlign()     As ECGTextAlignFlags
  Dim vFormat()    As Boolean
  Dim i            As Long
  Dim flds         As ADODB.Fields
  Dim lastField    As Long
  Dim iRowSelected As Long
  
  Set flds = rs.Fields
  lastField = flds.Count - 1

  ReDim vAlign(lastField)
  ReDim vFormat(lastField)
  
  For i = 0 To lastField
    Select Case flds.item(i).Type
      Case adLongVarChar, adLongVarWChar, adChar, adVarChar, adVarWChar, adWChar
        vAlign(i) = DT_LEFT
      Case adBigInt, adBinary, adInteger, adLongVarBinary, adSmallInt, adUnsignedBigInt, adUnsignedInt, adUnsignedSmallInt, adUnsignedTinyInt
        vAlign(i) = DT_RIGHT
      Case adNumeric, adTinyInt, adCurrency, adSingle, adDecimal, adDouble
        vFormat(i) = True
        vAlign(i) = DT_RIGHT
      Case adBoolean, adDBTime, adDate, adDBDate, adDBTimeStamp
        vAlign(i) = DT_CENTER
    End Select
  Next
  
  With oGrid
    
    offset = .Groups.Count
    
    IndexId = m_ItemIndexId + offset
    
    .Redraw = False
    
    bHaveDetail = prop.HaveDetail
    
    If bHaveDetail Then
      Dim Width As Long
      Width = (Screen.Width / Screen.TwipsPerPixelX) * 0.75
      If Width > 450 Then Width = 450
      oGrid.ColumnWidth(iLastCol) = Width
    End If
    
    If iRow = 0 Or iRow > .Rows Then
      iRow = .Rows + 1
      .Rows = .Rows + rs.RecordCount
    End If
    
    iRowSelected = iRow
    
    iLastCol = lastField + 1
    
    offset = .Groups.Count
    
    While Not rs.EOF
    
      .Cell(iRow, IndexId).ItemData = Val(pValField(flds.item(0)))
    
      For i = 1 To lastField
        pSetCellDetail oGrid, _
                       iRow, _
                       i + 1, _
                       pValField(flds.item(i)), _
                       iLastCol, _
                       offset, _
                       bHaveDetail, _
                       vAlign(i), _
                       vFormat(i)
                       
      Next
      
      iRow = iRow + 1
      rs.MoveNext
    Wend
  
    .MultiSelect = False
    If .Rows > 0 Then .SelectedRow = iRowSelected
    .MultiSelect = True
    
    .Redraw = True
  End With
    
  UpdateFromRs = True
  GoTo ExitProc
ControlError:
  MngError Err, "UpdateFromRs", C_Module, vbNullString, c_ErrorSave, csErrorWarning, csErrorVba
ExitProc:
End Function

Public Function AddFromSqlstmt(ByVal oGrid As Object, _
                               ByVal sqlstmt As String, _
                               ByRef prop As Object) As Boolean
  Dim rs As ADODB.Recordset
  Dim iRow As Long
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  If rs.EOF Then Exit Function
  
  iRow = GetRowFromId(oGrid, gDB.ValField(rs.Fields, 0))
  
  AddFromSqlstmt = UpdateFromRs(oGrid, rs, iRow, prop)
End Function

Public Function UpdateFromSqlstmt(ByVal oGrid As Object, _
                                  ByVal sqlstmt As String, _
                                  ByRef prop As Object) As Boolean
  Dim rs As ADODB.Recordset
  Dim iRow As Long
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  If rs.EOF Then Exit Function
  
  iRow = GetRowFromId(oGrid, gDB.ValField(rs.Fields, 0))
  
  UpdateFromSqlstmt = UpdateFromRs(oGrid, rs, iRow, prop)
End Function

Public Function LoadFromSqlstmt(ByVal oGrid As Object, _
                                ByVal sqlstmt As String, _
                                ByRef prop As Object) As Boolean
  LoadFromSqlstmt = LoadFromSqlstmtEx(oGrid, sqlstmt, prop, False)
End Function

Public Function LoadFromSqlstmtView(ByVal oGrid As Object, _
                                    ByVal sqlstmt As String, _
                                    ByRef prop As Object, _
                                    ByVal bSetView As Boolean, _
                                    ByRef ViewId As Long) As Boolean
                                    
  LoadFromSqlstmtView = LoadFromSqlstmtExView(oGrid, _
                                              sqlstmt, _
                                              prop, _
                                              False, _
                                              bSetView, _
                                              ViewId)
End Function

Public Function LoadFromSqlstmtEx(ByVal oGrid As Object, _
                                  ByVal sqlstmt As String, _
                                  ByRef prop As Object, _
                                  ByVal bAsync As Boolean) As Boolean
  
  LoadFromSqlstmtEx = LoadFromSqlstmtExView(oGrid, _
                                            sqlstmt, _
                                            prop, _
                                            bAsync, _
                                            False, _
                                            csNO_ID)
End Function

Public Function LoadFromSqlstmtExView(ByVal oGrid As Object, _
                                      ByVal sqlstmt As String, _
                                      ByRef prop As Object, _
                                      ByVal bAsync As Boolean, _
                                      ByVal bSetView As Boolean, _
                                      ByRef ViewId As Long) As Boolean
  Dim rs As ADODB.Recordset
  
  If bAsync Then
    If Not gDB.OpenRsEX(True, False, False, sqlstmt, rs) Then Exit Function
  Else
    If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  End If
  
  If rs.State <> adStateOpen Then
    MsgWarning LNGGetText(3436, vbNullString, sqlstmt)
              'La sentencia no devolvió un conjunto de registros. (1)
  Else
    LoadFromSqlstmtExView = LoadFromRecordSetEx(oGrid, rs, prop, , bSetView, ViewId)
  End If
End Function

Private Sub pAddColumn(ByVal oGrid As Object, _
                       ByVal colName As String, _
                       ByVal FieldType As ADODB.DataTypeEnum, _
                       ByRef prop As Object)
  Dim iWidth    As Integer
  Dim oCol      As Object
  Dim Visible   As Boolean
  Dim Caption   As String
  
  iWidth = c_col_width
  Visible = True
  Caption = colName

  If Not prop Is Nothing Then

    Set oCol = prop.Columns(colName)
    If Not oCol Is Nothing Then
    
      With oCol
        iWidth = .Width / Screen.TwipsPerPixelX
        Visible = .Visible
        If LenB(.Caption) Then
          Caption = Trim(.Caption)
        End If
      End With
      
    ' OJO: esto no deberia traer ningun problema
    '      pero al minimo comportamiento raro de las
    '      columnas de la grilla Aca esta el culpable
    '
    Else
      If InStr(1, UCase(colName), "_ID", vbTextCompare) > 0 Then
        Visible = False
      End If
    End If
  
  Else
    If InStr(1, UCase(colName), "_ID", vbTextCompare) > 0 Or colName = "TypeTask" Then
      Visible = False
    Else
      If oGrid.Columns + 1 < m_FirstColVisible Then
        m_FirstColVisible = oGrid.Columns + 1
      End If
    End If
  End If
  
  If iWidth = 0 Then iWidth = c_col_width
  If iWidth > 500 Then iWidth = c_col_width
  
  Dim eAlign      As ECGHdrTextAlignFlags
  Dim eSortType   As cShellSortTypeConstants
  Dim sFmtString  As String
  
  Select Case FieldType
    Case adLongVarChar, adLongVarWChar, adChar, adVarChar, adVarWChar, adWChar
      eAlign = ecgHdrTextALignLeft
      eSortType = CCLSortStringNoCase
    
    Case adBigInt, adBinary, adInteger, adLongVarBinary, adSmallInt, adTinyInt, adUnsignedBigInt, adUnsignedInt, adUnsignedSmallInt, adUnsignedTinyInt
      eAlign = ecgHdrTextALignRight
      eSortType = CCLSortNumeric
      sFmtString = "#,###,###,##0"
    
    Case adNumeric, adCurrency, adSingle, adDecimal, adDouble
      eAlign = ecgHdrTextALignRight
      eSortType = CCLSortNumeric
      sFmtString = "#,###,###,##0.00"
    
    Case adBoolean, adDBTime, adDate, adDBDate, adDBTimeStamp
      eAlign = ecgHdrTextALignCentre
      eSortType = CCLSortDateDayAccuracy
  End Select
  
  oGrid.AddColumn c_AuxKey & oGrid.Columns + 3, Caption, eAlign, , iWidth, Visible, , , , sFmtString, , eSortType
End Sub

Public Function LoadFromRecordSet(ByVal oGrid As Object, _
                                  ByRef rs As ADODB.Recordset, _
                                  ByRef prop As Object, _
                                  Optional ByVal Filter As String = vbNullString) As Boolean
  
  LoadFromRecordSet = LoadFromRecordSetEx(oGrid, _
                                          rs, _
                                          prop, _
                                          Filter)
End Function

Public Function LoadFromRecordSetEx(ByVal oGrid As Object, _
                                    ByRef rs As ADODB.Recordset, _
                                    ByRef prop As Object, _
                                    Optional ByVal Filter As String = vbNullString, _
                                    Optional ByVal bSetView As Boolean, _
                                    Optional ByRef ViewId As Long) As Boolean
  On Error GoTo ControlError
  
  Dim oldRedraw         As Boolean
  Dim oldHeaderVisible  As Boolean
  
  m_bLoadCancel = False
  
  oGrid.FreezeCtrl oldRedraw, oldHeaderVisible
  
  'Dim oGrid As CSGrid2.cGrid
  'Set oGrid = GridObj
  
  oGrid.RowOddColor = 12639458 'vbButtonFace
  
  Dim iLastCol    As Long
  Dim bHaveDetail As Boolean
  Dim IndexId     As Integer
  Dim Width       As Long

  If Not (rs.EOF And rs.BOF) Then
    rs.MoveFirst
  End If
  
  Dim vAlign()     As ECGTextAlignFlags
  Dim vFormat()    As Boolean
  Dim i            As Long
  Dim flds         As ADODB.Fields
  Dim lastField    As Long
  
  Set flds = rs.Fields
  lastField = flds.Count - 1

  ReDim vAlign(lastField)
  ReDim vFormat(lastField)
  
  For i = 0 To lastField
    Select Case flds.item(i).Type
      Case adLongVarChar, adLongVarWChar, adChar, adVarChar, adVarWChar, adWChar
        vAlign(i) = DT_LEFT
      Case adBigInt, adBinary, adInteger, adLongVarBinary, _
           adSmallInt, adUnsignedBigInt, adUnsignedInt, _
           adUnsignedSmallInt, adUnsignedTinyInt
        vAlign(i) = DT_RIGHT
      Case adNumeric, adTinyInt, adCurrency, adSingle, adDecimal, adDouble
        vFormat(i) = True
        vAlign(i) = DT_RIGHT
      Case adBoolean, adDBTime, adDate, adDBDate, adDBTimeStamp
        vAlign(i) = DT_CENTER
    End Select
  Next
  
  m_FirstColVisible = 1000
  
  With oGrid
  
    SaveColumnWidth oGrid, m_Name
    
    .Redraw = False
    .ClearEx True
    
    IndexId = m_ItemIndexId
  
    For i = 0 To lastField - 1
      With flds.item(i)
        pAddColumn oGrid, .Name, .Type, prop
      End With
    Next i
    
    If Not prop Is Nothing Then
      bHaveDetail = prop.HaveDetail
    Else
      If flds.Count > 0 Then
        With flds.item(lastField)
          If .Type = adVarChar And .DefinedSize > 250 Then
            bHaveDetail = True
          End If
        End With
      End If
    End If
    
    If bHaveDetail Then
      ' The special "rowcolumntext" column must be added to the end
      ' of the available columns.  This never appears as a column
      ' header, but the text in it is drawn underneath the row (assuming
      ' the row is high enough for it, starting at the column
      ' specified by .RowTextStartColumn:
      Width = (Screen.Width / Screen.TwipsPerPixelX) * 0.75
      If Width > 450 Then Width = 450
      .AddColumn , flds.item(lastField).Name, , , Width, , , , , , True
      If prop Is Nothing Then
        If flds.Count > m_FirstColVisible + 1 Then
          .RowTextStartColumn = m_FirstColVisible + 1
        Else
          .RowTextStartColumn = 1
        End If
      Else
        .RowTextStartColumn = prop.StartRowText
      End If
      ' You can specify specifically at which column the text will start
      ' like this:
      '   .RowTextStartColumn = .ColumnIndex("from")
      ' If you do this you need to track the ColumnOrderChanged event to
      ' ensure you are at the right column if the user moves this column
      ' to the end of the grid.  If you don't specify this setting, the
      ' grid will automatically start drawing rowtext at the position
      ' of the first column included in the select (bIncludeInSelect
      ' parameter of AddColumn)
    Else
      With flds.item(lastField)
        pAddColumn oGrid, .Name, .Type, prop
      End With
    End If
    
    iLastCol = lastField + 1
    
    .ColumnVisible(IndexId) = False

    .SetHeaders

    If rs.RecordCount > 0 Then
      .Rows = rs.RecordCount
    End If
    
  End With
  
  ' Si hay muchos registros mostramos una ventana de progreso
  '
  If oGrid.Rows > 1000 Then
  
    If Not pShowProgressDialog(oGrid, _
                               rs, _
                               Filter, _
                               flds, _
                               IndexId, _
                               lastField, _
                               iLastCol, _
                               bHaveDetail, _
                               vAlign(), _
                               vFormat(), _
                               prop, _
                               bSetView, _
                               ViewId) Then
      GoTo ExitProc
    End If
  
  Else
  
    If Not pLoadFromRecordSetEx(oGrid, _
                                rs, _
                                Filter, _
                                flds, _
                                IndexId, _
                                lastField, _
                                iLastCol, _
                                bHaveDetail, _
                                vAlign(), _
                                vFormat(), _
                                prop, _
                                bSetView, _
                                ViewId, _
                                False) Then
      GoTo ExitProc
    End If

  End If
    
  LoadFromRecordSetEx = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "LoadFromRecordSetEx", C_Module, vbNullString, c_ErrorSave, csErrorWarning, csErrorVba
ExitProc:
  oGrid.UnFreezeCtrl oldRedraw, oldHeaderVisible
End Function
    
Private Function pShowProgressDialog(ByVal oGrid As Object, _
                                     ByRef rs As ADODB.Recordset, _
                                     ByVal Filter As String, _
                                     ByRef flds As ADODB.Fields, _
                                     ByVal IndexId As Integer, _
                                     ByVal lastField As Long, _
                                     ByVal iLastCol As Long, _
                                     ByVal bHaveDetail As Boolean, _
                                     ByRef vAlign() As ECGTextAlignFlags, _
                                     ByRef vFormat() As Boolean, _
                                     ByRef prop As Object, _
                                     ByVal bSetView As Boolean, _
                                     ByRef ViewId As Long, _
                                     Optional ByVal Columns As String, _
                                     Optional ByVal columns_value As String, _
                                     Optional ByVal columns_type As csTypes, _
                                     Optional ByVal colColumn As String, _
                                     Optional ByVal colRow As String, _
                                     Optional ByVal colValue As String, _
                                     Optional ByVal colGroup As String _
                                     ) As Boolean
  Set m_p_oGrid = oGrid
  Set m_p_rs = rs
  m_p_Filter = Filter
  Set m_p_flds = flds
  m_p_IndexId = IndexId
  m_p_lastField = lastField
  m_p_iLastCol = iLastCol
  m_p_bHaveDetail = bHaveDetail
  
  m_p_columns = Columns
  m_p_columns_value = columns_value
  m_p_columns_type = columns_type
  m_p_colColumn = colColumn
  m_p_colRow = colRow
  m_p_colValue = colValue
  m_p_colGroup = colGroup
  
  Dim i As Long
  
  ReDim m_p_vAlign(UBound(vAlign))
  For i = 0 To UBound(vAlign)
    m_p_vAlign(i) = vAlign(i)
  Next
  
  ReDim m_p_vFormat(UBound(vFormat))
  For i = 0 To UBound(vFormat)
    m_p_vFormat(i) = vFormat(i)
  Next
  
  Set m_p_prop = prop
  m_p_bSetView = bSetView
  m_p_ViewId = ViewId

  Set m_fProgress = New fProgressGrid
  
  Load m_fProgress
  
  m_fProgress.HaveToRaiseEvent = True
  m_fProgress.RaiseEventProgress = True
  
  m_fProgress.Show vbModal
  
  pShowProgressDialog = m_fProgress.bSuccess
  
  ViewId = m_p_ViewId
  
  Set m_p_oGrid = Nothing
  Set m_p_rs = Nothing
  Set m_p_flds = Nothing
  ReDim m_p_vAlign(0)
  ReDim m_p_vFormat(0)
  Set m_p_prop = Nothing

End Function

Private Sub m_fProgress_Cancel()
  If Ask(LNGGetText(2973, vbNullString), vbNo) Then
    m_bLoadCancel = True
  End If
End Sub

Private Sub m_fProgress_Export(ByRef bSuccess As Boolean)
  On Error GoTo ControlError
  
  If m_bIsMatrix Then
  
    bSuccess = pLoadMatrixFromRecordSetEx(m_p_oGrid, _
                                    m_p_rs, _
                                    m_p_Filter, _
                                    m_p_columns, _
                                    m_p_columns_value, _
                                    m_p_columns_type, _
                                    m_p_colColumn, _
                                    m_p_colRow, _
                                    m_p_colValue, _
                                    m_p_colGroup, _
                                    m_p_flds, _
                                    m_p_IndexId, _
                                    m_p_lastField, _
                                    m_p_iLastCol, _
                                    m_p_bHaveDetail, _
                                    m_p_vAlign(), _
                                    m_p_vFormat(), _
                                    m_p_prop, _
                                    m_p_bSetView, _
                                    m_p_ViewId, _
                                    True)
  
  Else
  
    bSuccess = pLoadFromRecordSetEx(m_p_oGrid, _
                                    m_p_rs, _
                                    m_p_Filter, _
                                    m_p_flds, _
                                    m_p_IndexId, _
                                    m_p_lastField, _
                                    m_p_iLastCol, _
                                    m_p_bHaveDetail, _
                                    m_p_vAlign(), _
                                    m_p_vFormat(), _
                                    m_p_prop, _
                                    m_p_bSetView, _
                                    m_p_ViewId, _
                                    True)
  
  End If
  
  GoTo ExitProc
ControlError:
  MngError Err, "m_fProgress_Export", C_Module, vbNullString, c_ErrorSave, csErrorWarning, csErrorVba
ExitProc:
End Sub

Private Function pLoadFromRecordSetEx(ByVal oGrid As Object, _
                                      ByRef rs As ADODB.Recordset, _
                                      ByVal Filter As String, _
                                      ByRef flds As ADODB.Fields, _
                                      ByVal IndexId As Integer, _
                                      ByVal lastField As Long, _
                                      ByVal iLastCol As Long, _
                                      ByVal bHaveDetail As Boolean, _
                                      ByRef vAlign() As ECGTextAlignFlags, _
                                      ByRef vFormat() As Boolean, _
                                      ByRef prop As Object, _
                                      ByVal bSetView As Boolean, _
                                      ByRef ViewId As Long, _
                                      ByVal bShowProgress As Boolean) As Boolean

  On Error GoTo ControlError

  Dim iRow        As Long
  Dim Incluir     As Boolean
  Dim i           As Long
  
  With oGrid
  
    If bShowProgress Then
    
      m_fProgress.prgProgress.Max = .Rows
      
    End If
  
    iRow = 1
  
    ' Este if contiene casi el mismo codigo
    ' que el else y esta solo para hacer mas
    ' rapido la carga de la grilla
    '
    If Trim$(Filter) <> vbNullString Then
  
      While Not rs.EOF
          
        If Not gDB.ExistsEnRecord(rs, _
                                  Filter, _
                                  Incluir, _
                                  "LoadFromRecordSet", _
                                  C_Module) Then
          GoTo ExitProc
        End If
        
        If Incluir Then
        
          .Cell(iRow, IndexId).ItemData = Val(pValField(flds.item(0)))
          
          For i = 1 To lastField
          
            pSetCellDetail oGrid, _
                           iRow, _
                           i + 1, _
                           pValField(flds.item(i)), _
                           iLastCol, _
                           0, _
                           bHaveDetail, _
                           vAlign(i), _
                           vFormat(i)
          Next
        
        End If
        
        ' Si molesta mucho la performance lo sacamos
        '
        If bShowProgress Then
          DoEvents
          m_fProgress.ShowProgress iRow
          If m_bLoadCancel Then Exit Function
        End If
        
        iRow = iRow + 1
        rs.MoveNext
      Wend
    
    Else
    
      While Not rs.EOF
          
        .Cell(iRow, IndexId).ItemData = pValField(flds.item(0))
        
        For i = 1 To lastField
          
          pSetCellDetail oGrid, _
                         iRow, _
                         i + 1, _
                         pValField(flds.item(i)), _
                         iLastCol, _
                         0, _
                         bHaveDetail, _
                         vAlign(i), _
                         vFormat(i)
        Next
        
        ' Si molesta mucho la performance lo sacamos
        '
        If bShowProgress Then
          DoEvents
          m_fProgress.ShowProgress iRow
          If m_bLoadCancel Then Exit Function
        End If
        
        iRow = iRow + 1
        rs.MoveNext
      Wend
    End If
    
    If .Rows > 0 Then
      
      If bShowProgress Then
        m_fProgress.ShowSorting
      End If
      
      Dim oldMultiSelect As Boolean
      
      oldMultiSelect = .MultiSelect
      .MultiSelect = False
      .SelectedRow = 1
      .MultiSelect = oldMultiSelect
    End If
    
    GetColumnWidth oGrid, m_Name, prop
    
    If bSetView Then
    
      ViewId = pSetView(oGrid)
    
      If ViewId = csNO_ID Then
        oGrid.AutoWidthColumns
      End If
    
    Else
      oGrid.AutoWidthColumns
    End If
    
    .RefreshFilters
    .RefreshGroupsAndFormulas
    .RefreshFormats
    
  End With
  
  pLoadFromRecordSetEx = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "pLoadFromRecordSetEx", C_Module, vbNullString, c_ErrorSave, csErrorWarning, csErrorVba
ExitProc:
End Function

Private Function pLoadMatrixFromRecordSetEx(ByVal oGrid As Object, _
                                            ByRef rs As ADODB.Recordset, _
                                            ByVal Columns As String, _
                                            ByVal columns_value As String, _
                                            ByVal columns_type As csTypes, _
                                            ByVal colColumn As String, _
                                            ByVal colRow As String, _
                                            ByVal colValue As String, _
                                            ByVal colGroup As String, _
                                            ByVal Filter As String, _
                                            ByRef flds As ADODB.Fields, _
                                            ByVal IndexId As Integer, _
                                            ByVal lastField As Long, _
                                            ByVal iLastCol As Long, _
                                            ByVal bHaveDetail As Boolean, _
                                            ByRef vAlign() As ECGTextAlignFlags, _
                                            ByRef vFormat() As Boolean, _
                                            ByRef prop As Object, _
                                            ByVal bSetView As Boolean, _
                                            ByRef ViewId As Long, _
                                            ByVal bShowProgress As Boolean) As Boolean

  On Error GoTo ControlError

  Dim iRow        As Long
  Dim iProgress   As Long
  Dim Incluir     As Boolean
  Dim i           As Long
    
  Dim vColumnsValue As Variant
  Dim vColumns As Variant
  
  vColumnsValue = Split(columns_value, "|")
  vColumns = Split(Columns, "|")
  
  For i = 0 To UBound(vColumnsValue)
    Select Case columns_type
      Case csTypes.csDate
        vColumnsValue(i) = DateValue(vColumnsValue(i))
      Case csTypes.csLong, csTypes.csDouble, csTypes.csInteger
        vColumnsValue(i) = Val(vColumnsValue(i))
    End Select
  Next
  
  Dim col_offset As Long
  
  col_offset = rs.Fields.Count - 1
  
  If bHaveDetail Then
    col_offset = col_offset - 1
  End If
  
  ' Ordeno por la fila de grupos
  '
  ' Nota: por ahora uso adodb para esto despues veremos
  '
  rs.Sort = colRow
  
  Dim lastColRowValue As String
    
  lastColRowValue = "#$%&/!$$()" ' Para que de distinto
    
  With oGrid
  
    If bShowProgress Then
    
      m_fProgress.prgProgress.Max = .Rows
      
    End If
  
    iRow = 0
    iProgress = 1
  
    ' Este if contiene casi el mismo codigo
    ' que el else y esta solo para hacer mas
    ' rapido la carga de la grilla
    '
    If Trim$(Filter) <> vbNullString Then
  
      While Not rs.EOF
          
        If Not gDB.ExistsEnRecord(rs, _
                                  Filter, _
                                  Incluir, _
                                  "LoadFromRecordSet", _
                                  C_Module) Then
          GoTo ExitProc
        End If
        
        If Incluir Then
        
          If lastColRowValue <> pValField(flds.item(colRow)) Then
            
            lastColRowValue = pValField(flds.item(colRow))
            
            iRow = iRow + 1
          
            .Cell(iRow, IndexId).ItemData = Val(pValField(flds.item(0)))
            
            For i = 1 To lastField
            
              If flds.item(i).Name <> colColumn Then
                If flds.item(i).Name <> colValue Then
                  pSetCellDetail oGrid, _
                                 iRow, _
                                 i, _
                                 pValField(flds.item(i)), _
                                 iLastCol, _
                                 0, _
                                 bHaveDetail, _
                                 vAlign(i), _
                                 vFormat(i)
                End If
              End If
              
            Next
          
          End If
          
          For i = 0 To UBound(vColumnsValue)
            If vColumnsValue(i) = pValField(flds.item(colColumn)) Then
              
              pSetCellDetail oGrid, _
                             iRow, _
                             i + col_offset, _
                             pValField(flds.item(i)), _
                             iLastCol, _
                             0, _
                             bHaveDetail, _
                             ECGTextAlignFlags.DT_RIGHT, _
                             True
              
              Exit For
            End If
          Next
          
        End If
        
        ' Si molesta mucho la performance lo sacamos
        '
        If bShowProgress Then
          DoEvents
          m_fProgress.ShowProgress iRow
          If m_bLoadCancel Then Exit Function
        End If
        
        iRow = iRow + 1
        rs.MoveNext
      Wend
    
    Else
    
      While Not rs.EOF
          
        If lastColRowValue <> pValField(flds.item(colRow)) Then
          
          lastColRowValue = pValField(flds.item(colRow))
          
          iRow = iRow + 1
        
          .Cell(iRow, IndexId).ItemData = pValField(flds.item(0))
          
          For i = 1 To lastField
            
            If flds.item(i).Name <> colColumn Then
              If flds.item(i).Name <> colValue Then
                pSetCellDetail oGrid, _
                               iRow, _
                               i, _
                               pValField(flds.item(i)), _
                               iLastCol, _
                               0, _
                               bHaveDetail, _
                               vAlign(i), _
                               vFormat(i)
              End If
            End If
            
          Next
          
        End If
        
        For i = 0 To UBound(vColumnsValue)
          If vColumnsValue(i) = pValField(flds.item(colColumn)) Then
            
            pSetCellDetail oGrid, _
                           iRow, _
                           i + col_offset, _
                           pValField(flds.item(colValue)), _
                           iLastCol, _
                           0, _
                           bHaveDetail, _
                           ECGTextAlignFlags.DT_RIGHT, _
                           True
            
            Exit For
          End If
        Next
        
        ' Si molesta mucho la performance lo sacamos
        '
        If bShowProgress Then
          DoEvents
          m_fProgress.ShowProgress iProgress
          If m_bLoadCancel Then Exit Function
        End If
        
        iProgress = iProgress + 1
        rs.MoveNext
      Wend
    End If
    
    .Rows = iRow
    
    Dim mouse As cMouseWait
    Set mouse = New cMouseWait
    
    If .Rows > 0 Then
      
      If bShowProgress Then
        m_fProgress.ShowSorting
      End If
      
      Dim oldMultiSelect As Boolean
      
      oldMultiSelect = .MultiSelect
      .MultiSelect = False
      .SelectedRow = 1
      .MultiSelect = oldMultiSelect
    End If
    
    GetColumnWidth oGrid, m_Name, prop
    
    If bSetView Then
    
      ViewId = pSetView(oGrid)
    
      If ViewId = csNO_ID Then
        oGrid.AutoWidthColumns
      End If
    
    Else
        
      oGrid.Groups.Clear
      
      With oGrid.Groups.Add(Nothing)
        .Name = colGroup
        .Index = 1
        .Key = oGrid.ColumnKey(pGetIndex(colGroup, oGrid))
        .SortType = CCLOrderAscending
      End With
      
      With oGrid.Groups.Add(Nothing)
        .Name = colRow
        .Index = 2
        .Key = oGrid.ColumnKey(pGetIndex(colRow, oGrid))
        .SortType = CCLOrderAscending
        .IsSortCol = True
      End With
          
      For i = 0 To UBound(vColumns)
          
        With oGrid.Formulas.Add(Nothing)
          .Column = vColumns(i)
          .ColumnKey = oGrid.ColumnKey(pGetIndex(vColumns(i), oGrid))
          .FormulaType = csGrFTSum
        End With
      
        With oGrid.Formulas.Add(Nothing)
          .Column = vColumns(i)
          .ColumnKey = oGrid.ColumnKey(pGetIndex(vColumns(i), oGrid))
          .FormulaType = csGrFTSum
          .IsRowGroupFormula = True
        End With
      
      Next
      
      If LCase$(oGrid.ColumnHeader(oGrid.Columns)) = LCase$(m_ColSaldo) Then
        With oGrid.Formulas.Add(Nothing)
          .Column = oGrid.ColumnHeader(oGrid.Columns)
          .ColumnKey = oGrid.ColumnKey(pGetIndex(oGrid.ColumnHeader(oGrid.Columns), oGrid))
          .FormulaType = csGrFTSum
          .IsRowGroupFormula = True
        End With
      End If
      
      '
      ' Ahora tengo que ir por las filas de tipo rowsum
      '
      Dim Key   As String
      Dim j     As Long
      Dim iCol  As Long
      
      If UBound(m_vRowSumIds) Then
      
        iCol = pGetIndex(m_RowSumCol, oGrid)
      
        For iRow = 1 To oGrid.Rows
          For i = 1 To UBound(m_vRowSumIds)
            If Val(oGrid.CellText(iRow, iCol)) = m_vRowSumIds(i) Then
            
              Key = "k" & i
              
              For j = 0 To UBound(vColumns)
                              
                With oGrid.Formulas.Add(Nothing)
                  .Column = vColumns(j)
                  .ColumnKey = oGrid.ColumnKey(pGetIndex(vColumns(j), oGrid))
                  .FormulaType = csGrFTSum
                  .IsRowFormula = True
                  .RowKey = Key
                End With
              
              Next
              
              If LCase$(oGrid.ColumnHeader(oGrid.Cols)) = m_ColSaldo Then
                With oGrid.Formulas.Add(Nothing)
                  .Column = oGrid.ColumnHeader(oGrid.Cols)
                  .ColumnKey = oGrid.ColumnKey(pGetIndex(oGrid.ColumnHeader(oGrid.Cols), oGrid))
                  .IsRowFormula = True
                  .RowKey = Key
                End With
              End If
              
            End If
          Next
        Next
      End If
      
      oGrid.AutoWidthColumns
    End If
    
    .RefreshFilters
    .RefreshGroupsAndFormulas
    .RefreshFormats
    
  End With
  
  pLoadMatrixFromRecordSetEx = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "pLoadMatrixFromRecordSetEx", C_Module, vbNullString, c_ErrorSave, csErrorWarning, csErrorVba
ExitProc:
End Function

Private Function pGetIndex(ByVal colName As String, ByVal oGrid As Object) As Long
  Dim i As Long
  For i = 1 To oGrid.Columns
    If oGrid.ColumnHeader(i) = colName Then
      pGetIndex = i
      Exit Function
    End If
  Next
End Function

' Parametros:
'
' columns             :  es un string separado por | con los nombres
'                        de las columnas
'
' columns_value       :  son los valores asociados a los nombres de las columnas
'                        estan separados por |
'
' columns_type        :  indica el tipo de columns (date, string, double, long)
'                        se usa para el formateo de la columna
'
' columns_value_type  :  indica el tipo de columns_value (date, string, double, long)
'
' colColumn           :  es la columna que no hay que incluir en la fila ya que
'                        se usa su valor para ubicarla en las columnas de la grilla
'
' colRow              :  es el valor por el que se ordena el recordset para obtener
'                        los grupos que forman una fila
'
' colValue            :  es la columna que contiene el valor que debo ubicar en las
'                        columnas del crosstab
'
Public Function LoadMatrixFromRecordSetEx(ByVal oGrid As Object, _
                                          ByRef rs As ADODB.Recordset, _
                                          ByVal Columns As String, _
                                          ByVal columns_value As String, _
                                          ByVal columns_type As ADODB.DataTypeEnum, _
                                          ByVal columns_value_type As csTypes, _
                                          ByVal colColumn As String, _
                                          ByVal colRow As String, _
                                          ByVal colValue As String, _
                                          ByVal colGroup As String, _
                                          ByRef prop As Object, _
                                          Optional ByVal Filter As String = vbNullString, _
                                          Optional ByVal bSetView As Boolean, _
                                          Optional ByRef ViewId As Long) As Boolean
  On Error GoTo ControlError
  
  Dim vColumns As Variant
  Dim vColumnsValue As Variant
    
  vColumns = Split(Columns, "|")
  vColumnsValue = Split(columns_value, "|")
  
  If UBound(vColumns) <> UBound(vColumnsValue) Then
    Err.Raise vbObjectError - 1, "CSOAPI2." & C_Module & ".LoadMatrixFromRecordSetEx", _
              "Los parametros columns y columns_value deben tener la misma cantidad de elementos"
    Exit Function
  End If
  
  
  Dim oldRedraw         As Boolean
  Dim oldHeaderVisible  As Boolean
  
  m_bLoadCancel = False
  
  oGrid.FreezeCtrl oldRedraw, oldHeaderVisible
  
  'Dim oGrid As CSGrid2.cGrid
  'Set oGrid = GridObj
  
  oGrid.RowOddColor = 12639458 'vbButtonFace
  
  Dim iLastCol    As Long
  Dim bHaveDetail As Boolean
  Dim IndexId     As Integer
  Dim Width       As Long

  If Not (rs.EOF And rs.BOF) Then
    rs.MoveFirst
  End If
  
  Dim vAlign()     As ECGTextAlignFlags
  Dim vFormat()    As Boolean
  Dim i            As Long
  Dim flds         As ADODB.Fields
  Dim lastField    As Long
  
  Set flds = rs.Fields
  lastField = flds.Count - 1

  ReDim vAlign(lastField)
  ReDim vFormat(lastField)
  
  For i = 0 To lastField
    Select Case flds.item(i).Type
      Case adLongVarChar, adLongVarWChar, adChar, adVarChar, adVarWChar, adWChar
        vAlign(i) = DT_LEFT
      Case adBigInt, adBinary, adInteger, adLongVarBinary, _
           adSmallInt, adUnsignedBigInt, adUnsignedInt, _
           adUnsignedSmallInt, adUnsignedTinyInt
        vAlign(i) = DT_RIGHT
      Case adNumeric, adTinyInt, adCurrency, adSingle, adDecimal, adDouble
        vFormat(i) = True
        vAlign(i) = DT_RIGHT
      Case adBoolean, adDBTime, adDate, adDBDate, adDBTimeStamp
        vAlign(i) = DT_CENTER
    End Select
  Next
  
  m_FirstColVisible = 1000
  
  With oGrid
  
    SaveColumnWidth oGrid, m_Name
    
    .Redraw = False
    .ClearEx True
    
    IndexId = m_ItemIndexId
  
    For i = 0 To lastField - 1
      With flds.item(i)
      
        ' La columna que da los valores de las columnas del crosstab no se agrega
        '
        If .Name <> colColumn Then
      
          pAddColumn oGrid, .Name, .Type, prop
          
          If .Name = colGroup Then
            oGrid.ColumnVisible(oGrid.Columns) = False
          End If
          
        End If
        
      End With
    Next i
        
    ' Ahora van todas las columnas de detalle
    '
    For i = 0 To UBound(vColumns)
      pAddColumn oGrid, vColumns(i), columns_type, prop
    Next
    
    If Not prop Is Nothing Then
      bHaveDetail = prop.HaveDetail
    Else
      If flds.Count > 0 Then
        With flds.item(lastField)
          If .Type = adVarChar And .DefinedSize > 250 Then
            bHaveDetail = True
          End If
        End With
      End If
    End If
    
    If bHaveDetail Then
      ' The special "rowcolumntext" column must be added to the end
      ' of the available columns.  This never appears as a column
      ' header, but the text in it is drawn underneath the row (assuming
      ' the row is high enough for it, starting at the column
      ' specified by .RowTextStartColumn:
      Width = (Screen.Width / Screen.TwipsPerPixelX) * 0.75
      If Width > 450 Then Width = 450
      .AddColumn , flds.item(lastField).Name, , , Width, , , , , , True
      If prop Is Nothing Then
        If flds.Count > m_FirstColVisible + 1 Then
          .RowTextStartColumn = m_FirstColVisible + 1
        Else
          .RowTextStartColumn = 1
        End If
      Else
        .RowTextStartColumn = prop.StartRowText
      End If
      ' You can specify specifically at which column the text will start
      ' like this:
      '   .RowTextStartColumn = .ColumnIndex("from")
      ' If you do this you need to track the ColumnOrderChanged event to
      ' ensure you are at the right column if the user moves this column
      ' to the end of the grid.  If you don't specify this setting, the
      ' grid will automatically start drawing rowtext at the position
      ' of the first column included in the select (bIncludeInSelect
      ' parameter of AddColumn)
    Else
      With flds.item(lastField)
        pAddColumn oGrid, .Name, .Type, prop
      End With
    End If
    
    iLastCol = oGrid.Columns
    
    .ColumnVisible(IndexId) = False

    .SetHeaders

    If rs.RecordCount > 0 Then
      .Rows = rs.RecordCount
    End If
    
  End With
  
  ' Si hay muchos registros mostramos una ventana de progreso
  '
  If oGrid.Rows > 1000 Then
  
    If Not pShowProgressDialog(oGrid, _
                               rs, _
                               Filter, _
                               flds, _
                               IndexId, _
                               lastField, _
                               iLastCol, _
                               bHaveDetail, _
                               vAlign(), _
                               vFormat(), _
                               prop, _
                               bSetView, _
                               ViewId, _
                               Columns, _
                               columns_value, _
                               columns_type, _
                               colColumn, _
                               colRow, _
                               colValue, _
                               colGroup) Then
      GoTo ExitProc
    End If
  
  Else
  
    If Not pLoadMatrixFromRecordSetEx(oGrid, _
                                rs, _
                                Columns, _
                                columns_value, _
                                columns_type, _
                                colColumn, _
                                colRow, _
                                colValue, _
                                colGroup, _
                                Filter, _
                                flds, _
                                IndexId, _
                                lastField, _
                                iLastCol, _
                                bHaveDetail, _
                                vAlign(), _
                                vFormat(), _
                                prop, _
                                bSetView, _
                                ViewId, _
                                False) Then
      GoTo ExitProc
    End If

  End If
    
  LoadMatrixFromRecordSetEx = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "LoadMatrixFromRecordSetEx", C_Module, vbNullString, c_ErrorSave, csErrorWarning, csErrorVba
ExitProc:
  oGrid.UnFreezeCtrl oldRedraw, oldHeaderVisible
End Function

' Son byref por performance
Private Sub pSetCellDetail(ByVal oGrid As Object, _
                           ByRef iRow As Long, _
                           ByVal iCol As Long, _
                           ByRef Value As String, _
                           ByRef iLastCol As Long, _
                           ByVal offset As Integer, _
                           ByVal bHaveDetail As Boolean, _
                           ByVal eAlign As ECGTextAlignFlags, _
                           ByVal bFormat As Boolean)
                           
  Dim iColGrid    As Integer
  
  iColGrid = iCol + offset
  
  With oGrid
    If iColGrid = iLastCol And bHaveDetail Then
      .CellDetails iRow, iLastCol, Value, DT_WORDBREAK, , , vbBlue
      .RowHeight(iRow) = .EvaluateTextHeight(iRow, .Columns) + .DefaultRowHeight + 2
    Else
      
      If bFormat Then
        Value = Format(Value, "#,###,###,##0.00")
      Else
        
        If .ColumnSortType(iColGrid) = CCLSortDateDayAccuracy Then
          If IsDate(Value) Then
            If Value = csNoDate Then
              Value = ""
            End If
          End If
        End If
        
      End If
      
      .CellDetails iRow, iColGrid, Value, eAlign, , , vbWindowText
    End If
  End With
End Sub

Private Function pSetView(ByRef oGrid As Object) As Long
  Dim View As cGridView
  
  For Each View In m_Views
    If View.Default Then
      If Not SelectView(oGrid, View.Id) Then
        Exit Function
      End If
      pSetView = View.Id
      Exit Function
    End If
  Next
End Function

Public Function SetLineFromRecordSet(ByVal oGrid As Object, rs As ADODB.Recordset) As Boolean
    Dim Id    As Long
    Dim i     As Integer
    Dim iRow  As Long
    Dim iCol  As Long
    
    On Error GoTo ControlError
    
    Set gDB.rs = rs
    
    With oGrid
      While Not gDB.EOF
        ' El primer Field contiene el id
        Id = gDB.Field
        iRow = GetRowFromId(oGrid, Id)
        .Cell(iRow, pItemIndexId(oGrid)).ItemData = gDB.Field
        iCol = 2
        While Not gDB.EOF_Field
          .Cell(iRow, iCol).Text = gDB.Field
          If gDB.FieldType = csFieldBoolean Then
            i = i + 1
            .Cell(iRow, iCol).ForeColor = vbBlue
          End If
          iCol = iCol + 1
        Wend
        gDB.MoveNext
      Wend
    End With
        
    SetLineFromRecordSet = True
    Exit Function
ControlError:
    MngError Err, "SetLineFromRecordSet", C_Module, vbNullString, c_ErrorSave, csErrorWarning, csErrorVba
End Function

Private Function GetRowFromId(ByVal oGrid As Object, ByVal Id As Long) As Long
  Dim iRow As Long
  With oGrid
    For iRow = 1 To .Rows
      If .Cell(iRow, pItemIndexId(oGrid)).ItemData = Id Then
        GetRowFromId = iRow
        Exit For
      End If
    Next
  End With
End Function
'-----------------------------------------------------------------------------------------------------------
'Public Function LoadFromBranch(ByVal oGrid As Object, ByVal Branch As cBranch) As Boolean
'  Dim Leave    As cLeave
'  Dim Column As cLeaveColumn
'  Dim i       As Integer
'  Dim iRow    As Long
'
'  On Error GoTo ControlError
'
'  With oGrid
'
'    SaveColumnWidth oGrid, m_Name
'
'    .Redraw = False
'    .ClearEx True
'
'    .Rows = Branch.Leaves.Count
'    iRow = 1
'
'    For Each Column In Branch.Columns
'        .AddColumn , Column.Name
'    Next
'
'    ' esto es por que el orden en el que agrego las columnas no
'    ' es valido
'    Dim AlignEnHeadersOk As Boolean
'
'    For Each Leave In Branch.Leaves
'
'        .Cell(iRow, Id2(oGrid)).ItemData = Leave.Id
'        .Cell(iRow, pItemIndexId(oGrid)).ItemData = Leave.ClientId
'
'        For i = 3 To Leave.Columns.Count
'
'            Set Column = Leave.Columns(i)
'            .Cell(iRow, i).Text = Column.Value
'            If Column.VarType = csFieldBoolean Then
'                SetValueBoolean oGrid, iRow, i
'            End If
'
'            If Not AlignEnHeadersOk Then .Cell(iRow, i).TextAlign = GetAlignment(Column.VarType)
'        Next
'
'        If m_IMG_ITEM <> 0 Then
'            .Cell(iRow, 3).IconIndex = m_IMG_ITEM
'        End If
'
'        iRow = iRow + 1
'
'        AlignEnHeadersOk = True
'    Next
'
'    If .Rows > 0 Then
'        Dim oldMultiSelect As Boolean
'
'        oldMultiSelect = .MultiSelect
'        .MultiSelect = False
'        .SelectedRow = 1
'        .MultiSelect = oldMultiSelect
'    End If
'
'    .ColumnVisible(pItemIndexId(oGrid)) = False
'    .ColumnVisible(Id2(oGrid)) = False
'
'    GetColumnWidth oGrid, m_Name
'
'    .Redraw = True
'  End With
'
'  LoadFromBranch = True
'  GoTo ExitProc
'ControlError:
'  MngError Err, "LoadFromBranch", "cGridManager", vbnullstring, "Error al cargar la grilla", csErrorWarning, csErrorVba
'ExitProc:
'End Function

' Devuelve un string con el ucase de la suma de todos los Names de Columns
Public Function GetKeyFromColumns(ByVal Branch As cBranch) As String
  Dim Column As cLeaveColumn
  
  For Each Column In Branch.Columns
    GetKeyFromColumns = GetKeyFromColumns + Column.Name
  Next
  GetKeyFromColumns = UCase(GetKeyFromColumns)
End Function

Public Sub GetSelected(ByVal oGrid As Object, ByRef Seleccionados() As Long)
  Dim n  As Long
  Dim i  As Long
  Dim j  As Long
  
  Dim mouse As cMouseWait
  Set mouse = New cMouseWait
  
  DoEvents
  
  With oGrid
    For i = 1 To .Rows
      If .IsRowSelected(i) Then
        n = n + 1
      End If
    Next i
    
    If n = 0 Then
      ReDim Seleccionados(0)
    Else
      ReDim Seleccionados(n - 1)
    End If
    
    j = 0
    For i = 1 To .Rows
      If .IsRowSelected(i) Then
        Seleccionados(j) = .Cell(i, Id2(oGrid)).ItemData
        j = j + 1
      End If
    Next i
  End With
End Sub

' Solo para Grids con multiselect = false
Public Function GetSelectedId(ByVal oGrid As Object) As Long
  With oGrid
    If .SelectedRow = 0 Then Exit Function
    
    GetSelectedId = .Cell(.SelectedRow, Id2(oGrid)).ItemData
  End With
End Function

Public Function GetSelectedName(ByVal oGrid As Object) As String
  GetSelectedName = GetSelectedCol(oGrid, 2)
End Function

Public Function GetSelectedCode(ByVal oGrid As Object) As String
  GetSelectedCode = GetSelectedCol(oGrid, 1)
End Function

Public Function GetSelectedCol(ByVal oGrid As Object, ByVal Col As Integer) As String
  On Error GoTo ControlError
  With oGrid
    If oGrid.SelectedRow = 0 Then Exit Function
    
    GetSelectedCol = .Cell(.SelectedRow, Col).Text
  End With
  Exit Function
ControlError:
  MngError Err, "GetSelectedCol", C_Module, vbNullString, LNGGetText(3439, vbNullString, Col), csErrorWarning, csErrorVba
                                                          'Error al obtener la columna
End Function

Public Function GetSelectedCount(ByVal oGrid As Object) As Integer
  Dim n    As Long
  Dim i    As Long
  
  With oGrid
    For i = 1 To .Rows
        If .IsRowSelected(i) Then
            n = n + 1
        End If
    Next i
    
    GetSelectedCount = n
  End With
End Function

Public Sub Clear(ByVal oGrid As Object)
  SaveColumnWidth oGrid, m_Name
  oGrid.ClearEx True
End Sub

'-----------------------------------------------------------------------------------------------------------
Public Function LoadView(ByVal grdv_id As Long, _
                         ByRef rtnView As cGridView) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "select * from GridView where grdv_id = " & grdv_id
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  If Not rs.EOF Then
    Set rtnView = m_Views.Add(Nothing)
    With rtnView
      .Autowidth = gDB.ValField(rs.Fields, cscGrdvAutowidth)
      .Default = gDB.ValField(rs.Fields, cscGrdvDefault)
      .grid_name = gDB.ValField(rs.Fields, cscGridName)
      .Id = gDB.ValField(rs.Fields, cscGrdvId)
      .Nombre = gDB.ValField(rs.Fields, cscGrdvNombre)
      .Publica = gDB.ValField(rs.Fields, cscGrdvPublica)
      .Rpt_id = gDB.ValField(rs.Fields, cscRptId)
    End With
    
  End If
  
  LoadView = True

End Function

Public Function SelectView(ByRef oGrid As Object, _
                           ByVal grdv_id As Long) As Boolean

  On Error GoTo ControlError
  
  Dim oldRedraw As Boolean
  
  oldRedraw = oGrid.Redraw
  
  oGrid.Redraw = False
  
  ' Filtros
  '
  If Not pApplyViewFilters(oGrid, grdv_id) Then
    GoTo ExitProc
  End If

  ' Grupos
  '
  If Not pApplyViewGroups(oGrid, grdv_id) Then
    GoTo ExitProc
  End If
  
  ' Formulas
  '
  If Not pApplyViewFormulas(oGrid, grdv_id) Then
    GoTo ExitProc
  End If
  
  ' Formatos
  '
  If Not pApplyViewFormats(oGrid, grdv_id) Then
    GoTo ExitProc
  End If
  
  ' Columnas
  '
  If Not pApplyViewColumns(oGrid, grdv_id) Then
    GoTo ExitProc
  End If
  
  If pAutoWidthCols(grdv_id) Then
    oGrid.AutoWidthColumns
  End If
 
  SelectView = True

  GoTo ExitProc
ControlError:
  MngError Err, "SelectView", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
  oGrid.Redraw = oldRedraw
End Function

Private Function pAutoWidthCols(ByVal grdv_id As Long) As Boolean
  On Error Resume Next
  pAutoWidthCols = m_Views.item(GetKey(grdv_id)).Autowidth
End Function

Private Function pApplyViewColumns(ByRef oGrid As Object, _
                                   ByVal grdv_id As Long) As Boolean

  Dim sqlstmt   As String
  Dim rs        As ADODB.Recordset
  Dim bVisible  As Boolean
  Dim Order     As Long
  
  sqlstmt = "select * from GridViewColumn where grdv_id = " & grdv_id
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  Dim i As Long
  Dim n As Long
  
  While Not rs.EOF
  
    ' La ultima columna es de descripciones
    ' asi que no le toco ni ancho ni order
    '
    n = oGrid.Columns
    
    For i = 1 To n
      If LCase$(oGrid.ColumnHeader(i)) _
         = LCase$(gDB.ValField(rs.Fields, _
                          cscGrdvcNombre)) Then
      
        bVisible = gDB.ValField(rs.Fields, cscGrdvcVisible)
        oGrid.ColumnVisible(i) = bVisible
        
        If Not bVisible Then
          oGrid.ColumnHidden(i) = True
        End If
        
        Order = gDB.ValField(rs.Fields, cscGrdvcIndex)
        
        ' Si tiene rowtext no tocamos la ultima columna en cuanto
        ' a ancho y posicion
        '
        If n <> i Or oGrid.RowTextStartColumn = 0 Then
          
          ' Solo si la columna no esta por debajo de la cantidad de columnas
          ' cuando hay rowtext
          '
          If Order < n Or oGrid.RowTextStartColumn = 0 Then
            oGrid.ColumnOrder(i) = Order
          End If
          oGrid.ColumnWidth(i) = gDB.ValField(rs.Fields, cscGrdvcWidth)
        End If
        
        Exit For
      End If
    Next
      
    rs.MoveNext
  Wend
  
  If grdv_id = csNO_ID Then

    With oGrid
      For i = 2 To .Columns
        If InStr(1, LCase$(.ColumnHeader(i)), "_id") = 0 Then
          .ColumnVisible(i) = True
        End If
        .ColumnOrder(i) = i
      Next
    End With

  End If
  
  pApplyViewColumns = True
End Function

Private Function pApplyViewGroups(ByRef oGrid As Object, _
                                  ByVal grdv_id As Long) As Boolean

  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "select * from GridViewGrupo where grdv_id = " & grdv_id
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  Dim i As Long
  
  oGrid.Groups.Clear
  
  While Not rs.EOF
  
    For i = 1 To oGrid.Columns
      If LCase$(oGrid.ColumnHeader(i)) _
         = LCase$(gDB.ValField(rs.Fields, _
                          cscGrdvgColumna)) Then
      
        With oGrid.Groups.Add(Nothing)
          .Name = gDB.ValField(rs.Fields, cscGrdvgColumna)
          .Index = gDB.ValField(rs.Fields, cscGrdvgIndice)
          .Key = oGrid.ColumnKey(i)
          .SortType = gDB.ValField(rs.Fields, cscGrdvgOrden)
        End With
        Exit For
      End If
    Next
  
    rs.MoveNext
  Wend
  
  pApplyViewGroups = True
End Function

Private Function pApplyViewFormulas(ByRef oGrid As Object, _
                                    ByVal grdv_id As Long) As Boolean

  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "select * from GridViewFormula where grdv_id = " & grdv_id & " order by grdvf_indice"
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  Dim i As Long
  
  oGrid.Formulas.Clear
  
  While Not rs.EOF
  
    For i = 1 To oGrid.Columns
      If LCase$(oGrid.ColumnHeader(i)) _
         = LCase$(gDB.ValField(rs.Fields, _
                          cscGrdvfColumna)) Then
      
        With oGrid.Formulas.Add(Nothing)
          .Column = gDB.ValField(rs.Fields, cscGrdvfColumna)
          .ColumnKey = oGrid.ColumnKey(i)
          .FormulaType = gDB.ValField(rs.Fields, cscGrdvfFormula)
        End With
        Exit For
      End If
    Next
  
    rs.MoveNext
  Wend
  
  oGrid.RefreshGroupsAndFormulasEx True
  
  pApplyViewFormulas = True
End Function

Private Function pApplyViewFormats(ByRef oGrid As Object, _
                                   ByVal grdv_id As Long) As Boolean

  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "select * from GridViewFormato where grdv_id = " & grdv_id
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  Dim i As Long
  
  oGrid.Formats.Clear
  
  While Not rs.EOF
  
    For i = 1 To oGrid.Columns
      If LCase$(oGrid.ColumnHeader(i)) _
         = LCase$(gDB.ValField(rs.Fields, _
                          cscGrdvfcColumna)) Then
      
        With oGrid.Formats.Add(Nothing)
          .Column = gDB.ValField(rs.Fields, cscGrdvfcColumna)
          .Column2 = gDB.ValField(rs.Fields, cscGrdvfcColumna2)
          .ColumnKey = oGrid.ColumnKey(i)
          .Operator = gDB.ValField(rs.Fields, cscGrdvfcOperador)
          .ColumnKey2 = pGetColumnKey2(oGrid, .Column2)
          .CompareTo = gDB.ValField(rs.Fields, cscGrdvfcValor)
          Set .Font = pGetFont(gDB.ValField(rs.Fields, cscGrdvfcFontName), _
                               gDB.ValField(rs.Fields, cscGrdvfcFontSize), _
                               gDB.ValField(rs.Fields, cscGrdvfcFontStyle))
          .ForeColor = gDB.ValField(rs.Fields, cscGrdvfcFColor)
          .BackColor = gDB.ValField(rs.Fields, cscGrdvfcBgColor)
        End With
        Exit For
      End If
    Next
  
    rs.MoveNext
  Wend
    
  oGrid.RefreshFormats
  
  pApplyViewFormats = True
End Function

Private Function pApplyViewFilters(ByRef oGrid As Object, _
                                   ByVal grdv_id As Long) As Boolean

  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "select * from GridViewFiltro where grdv_id = " & grdv_id
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  Dim i As Long
  
  oGrid.Filters.Clear
  
  While Not rs.EOF
  
    For i = 1 To oGrid.Columns
      If LCase$(oGrid.ColumnHeader(i)) _
         = LCase$(gDB.ValField(rs.Fields, _
                          cscGrdvfiColumna)) Then
      
        With oGrid.Filters.Add(Nothing)
          .Column = gDB.ValField(rs.Fields, cscGrdvfiColumna)
          .Column2 = gDB.ValField(rs.Fields, cscGrdvfiColumna2)
          .ColumnKey = oGrid.ColumnKey(i)
          .Operator = gDB.ValField(rs.Fields, cscGrdvfiOperador)
          .ColumnKey2 = pGetColumnKey2(oGrid, .Column2)
          .CompareTo = gDB.ValField(rs.Fields, cscGrdvfiValor)
        End With
        Exit For
      End If
    Next
  
    rs.MoveNext
  Wend
    
  oGrid.RefreshFilters
  
  pApplyViewFilters = True
End Function

Private Function pGetFont(ByVal FontName As String, _
                          ByVal FontSize As Double, _
                          ByVal FontStyle As Long) As StdFont
  On Error Resume Next
  
  Dim rtn As StdFont
  Set rtn = New StdFont
  If FontName <> vbNullString Then
    With rtn
      .Name = FontName
      .Size = FontSize
      Select Case FontStyle
        Case 1
          .Italic = True
        Case 2
          .Strikethrough = True
        Case 3
          .Bold = True
        Case 4
          .Underline = True
      End Select
    End With
  End If
  Set pGetFont = rtn
End Function

Private Function pGetColumnKey2(ByRef oGrid As Object, _
                                ByVal Column2 As String) As String
  Dim i As Long
  
  If Column2 <> vbNullString Then
  
    Column2 = LCase$(Column2)
    For i = 1 To oGrid.Columns
      If LCase$(oGrid.ColumnHeader(i)) = Column2 Then
      
        pGetColumnKey2 = oGrid.ColumnKey(i)
        Exit Function
      End If
    Next
  End If
End Function

Public Function LoadViews(Optional ByVal grid_name As String, _
                          Optional ByVal Rpt_id As Long) As Boolean
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_GridViewGetViews " & gDB.sqlString(grid_name) & "," _
                                   & Rpt_id & "," _
                                   & gUser.Id
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  m_Views.Clear
  
  With m_Views.Add(Nothing, GetKey(csNO_ID))
    .Autowidth = False
    .Default = False
    .grid_name = vbNullString
    .Id = csNO_ID
    .Nombre = LNGGetText(3437, vbNullString) 'Vista Estandar
    .Publica = False
    .Rpt_id = csNO_ID
  End With
  
  While Not rs.EOF
    With m_Views.Add(Nothing, GetKey(gDB.ValField(rs.Fields, cscGrdvId)))
      .Autowidth = gDB.ValField(rs.Fields, cscGrdvAutowidth)
      .grid_name = gDB.ValField(rs.Fields, cscGridName)
      .Id = gDB.ValField(rs.Fields, cscGrdvId)
      .Nombre = gDB.ValField(rs.Fields, cscGrdvNombre)
      .Publica = gDB.ValField(rs.Fields, cscGrdvPublica)
      .Rpt_id = gDB.ValField(rs.Fields, cscRptId)
      .us_id = gDB.ValField(rs.Fields, cscUsId)
      
      If .us_id = gUser.Id Then
        .Default = gDB.ValField(rs.Fields, cscGrdvDefault)
      End If
    End With
    rs.MoveNext
  Wend
  
  LoadViews = True
End Function

Public Sub SetPropertys(ByVal oGrid As Object)
  Dim oldRedraw As Boolean
  
  With oGrid
  
    oldRedraw = .Redraw
    .Redraw = False
    
    .RowMode = True
    .MultiSelect = True
    .DefaultRowHeight = 18
    .HeaderFlat = True
    .BackColor = m_BackColor
    .BorderStyle = ecgBorderStyleNone
    .GridLines = False
    
    .Redraw = oldRedraw
  End With
    
End Sub
Public Sub SaveColumnWidth(ByVal oGrid As Object, ByVal Name As String)
  On Error GoTo ControlError
  Dim i       As Integer
  Dim offset  As Integer
  
  With oGrid
    offset = .Groups.Count
    For i = 1 To .Columns - offset
      SetRegistry csInterface, Name + "_COL_" + Trim(i), .ColumnWidth(i + offset)
    Next i
  End With

ControlError:
End Sub
Public Sub GetColumnWidth(ByVal oGrid As Object, _
                          ByVal Name As String, _
                          ByRef prop As Object, _
                          Optional ByVal idxOcultar As Integer = 0)
  Dim i         As Integer
  Dim Width     As Long
  Dim iLastCol  As Long
  Dim offset    As Integer
  Dim k         As Integer
  
  With oGrid
  
    If Not prop Is Nothing Then
  
      If prop.HaveDetail Then
        iLastCol = .Columns - 1
      Else
        iLastCol = .Columns
      End If
    Else
      If .HasRowText Then
        iLastCol = .Columns - 1
      Else
        iLastCol = .Columns
      End If
    End If
    
    If .Groups.Count Then
      offset = .Groups.Count - 1
    Else
      offset = 0
    End If
    
    For i = 1 To iLastCol - offset
        k = i + offset
        Width = GetRegistry(csInterface, Name + "_COL_" + Trim(i), -1)
        If Width = 0 Then Width = c_col_width
        If Width > -1 Then
            .ColumnWidth(k) = IIf(Width > COL_MAX_WIDTH, COL_MAX_WIDTH, Width)
        ElseIf .ColumnWidth(k) = 0 Then
            .ColumnWidth(k) = c_col_width
        End If
    Next i
    
    For i = 1 + offset To idxOcultar + 1 + offset
        .ColumnWidth(i) = 0
        .SetHeaders
    Next i
  End With
End Sub

' funciones privadas
Private Sub SetValueBoolean(ByVal oGrid As Object, ByVal iRow As Long, ByVal iCol As Long)
  With oGrid
    If .hImageList <> 0 Or (m_IMG_Active_FALSE = 0 Or m_IMG_Active_TRUE = 0) Then
        .Cell(iRow, iCol).ForeColor = vbBlue
    Else
        If Val(.Cell(iRow, iCol).Text) Then
            .Cell(iRow, iCol).IconIndex = m_IMG_Active_TRUE
        Else
            .Cell(iRow, iCol).IconIndex = m_IMG_Active_FALSE
        End If
        .Cell(iRow, iCol).Text = vbNullString
    End If
  End With
End Sub
Private Function GetAlignment(ByVal Tipo As csTypes) As ECGTextAlignFlags
  Select Case Tipo
    Case csTypes.csBoolean
      ' esto es por que el listview no centra iconos
      GetAlignment = DT_CENTER
    Case csTypes.csCurrency, csTypes.csDouble, csTypes.csInteger, csTypes.csLong, csTypes.csSingle
      GetAlignment = DT_RIGHT
    Case Else
      GetAlignment = DT_LEFT
  End Select
End Function
Private Function pItemIndexId(ByVal oGrid As Object) As Long
  Dim offset  As Integer
  
  If Not oGrid Is Nothing Then
    offset = oGrid.Groups.Count
  End If
  
  pItemIndexId = m_ItemIndexId + offset
End Function

' Esta funcion es una copia de ValField de cDatabase
' mas resumida para lograr mayor performance al cargar
' muchas filas en la grilla
'
Private Function pValField(ByVal Field As ADODB.Field)
  If IsNull(Field.Value) Then
    Select Case Field.Type
      Case adLongVarChar, adLongVarWChar, adChar, adVarChar, adVarWChar, adWChar
        pValField = vbNullString
      Case adBigInt, adBinary, adInteger, adLongVarBinary, adNumeric, adSmallInt, adTinyInt, adUnsignedBigInt, adUnsignedInt, adUnsignedSmallInt, adUnsignedTinyInt
        pValField = 0
      Case adBoolean
        pValField = False
      Case adCurrency, adSingle, adDecimal, adDouble
        pValField = 0
      Case adDBTime, adDate, adDBDate
        pValField = csNoDate
      Case adDBTimeStamp
        pValField = csNoDate
    End Select
  Else
    pValField = Field.Value
  End If
End Function

' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError

  Set m_Views = New cGridViews
  m_BackColor = vbWindowBackground
  m_ItemIndexId = 1
  m_ItemIdLeave = 2

  c_ErrorSave = LNGGetText(3438, vbNullString)  'Error al cargar la Grilla

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
  On Error Resume Next
  Set m_Views = Nothing
End Sub


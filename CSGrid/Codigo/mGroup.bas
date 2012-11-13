Attribute VB_Name = "mGroup"
Option Explicit

Private Const C_Module = "mGroup"

Public Const C_TOTAL_COLUMN = -1111
Public Const C_TOTAL_COLUMN_EX = -1112

Public Const c_IdColPrefix = "_id"

Private m_bGroup As Boolean

Private Const c_KeyGroupAuxColumn     As String = "##@@1245%%%$$$"
Private Const c_GroupIconExpand       As Long = 1
Private Const c_GroupIconCollapse     As Long = 0
Private Const c_KeyGroup              As String = "##Group!!_"

Private m_iRefCount   As Long

Public Sub EditFilters(ByRef Grd As Object, ByRef vColumns() As String, ByRef vKeys() As String)
  Dim fC             As fConditionalFormat
  Dim j              As Long
  
  Dim Mouse As cMouseWait
  Set Mouse = New cMouseWait
  
  Set fC = New fConditionalFormat
  For j = LBound(vColumns) To UBound(vColumns)
    fC.AddField vColumns(j), vKeys(j)
  Next j
  
  fC.SetFilters Grd.Filters
  
  Set Mouse = Nothing
  fC.Show vbModal
  
  Set Mouse = New cMouseWait
  
  If Not fC.Cancelled Then
    Grd.Filters.Clear
    
    If fC.SelectionCount > 0 Then
      For j = 1 To fC.SelectionCount
        With Grd.Filters.Add(Nothing)
          .Column = fC.SelectedField(j)
          .Column2 = fC.SelectedField2(j)
          .ColumnKey = fC.SelectedKey(j)
          .Operator = fC.SelectedOperator(j)
          .ColumnKey2 = fC.SelectedKey2(j)
          .CompareTo = fC.SelectedCompareTo(j)
        End With
      Next j
    End If
    
    ' Si hay formulas hay que recalcular los
    ' grupos despues de filtrar
    If Grd.Formulas.Count > 0 Then
    
      Grd.Redraw = False
      Grd.RefreshFilters
      
      Grd.RefreshGroupsAndFormulas
      Grd.Redraw = True
    
    Else
      Grd.RefreshFilters
    End If
  End If
End Sub

Public Sub EditFormats(ByRef Grd As Object, ByRef vColumns() As String, ByRef vKeys() As String)
  Dim fC             As fConditionalFormat
  Dim j              As Long
  
  Dim Mouse As cMouseWait
  Set Mouse = New cMouseWait
  
  Set fC = New fConditionalFormat
  For j = LBound(vColumns) To UBound(vColumns)
    fC.AddField vColumns(j), vKeys(j)
  Next j
  
  fC.SetFormats Grd.Formats
  
  Set Mouse = Nothing
  fC.Show vbModal
  
  Set Mouse = New cMouseWait
  
  If Not fC.Cancelled Then
    Grd.Formats.Clear
    
    If fC.SelectionCount > 0 Then
      For j = 1 To fC.SelectionCount
        With Grd.Formats.Add(Nothing)
          .Column = fC.SelectedField(j)
          .Column2 = fC.SelectedField2(j)
          .ColumnKey = fC.SelectedKey(j)
          .Operator = fC.SelectedOperator(j)
          .ColumnKey2 = fC.SelectedKey2(j)
          .CompareTo = fC.SelectedCompareTo(j)
          Set .Font = fC.SelectedFont(j)
          .ForeColor = fC.SelectedForeColor(j)
          .BackColor = fC.SelectedBackColor(j)
        End With
      Next j
    End If
    
    Grd.RefreshFormats
  End If
End Sub

Public Sub EditFormulas(ByRef Grd As Object, _
                        ByRef vColumns() As String, _
                        ByRef vKeys() As String)
                        
  Dim fC            As fFormulas
  Dim j             As Long
  Dim sThis()       As String
  Dim eFormulas()   As csGridFormulaTypes
  
  Dim Mouse As cMouseWait
  Set Mouse = New cMouseWait
  
  Set fC = New fFormulas
  For j = LBound(vColumns) To UBound(vColumns)
    fC.AddField vColumns(j), vKeys(j)
  Next j
  
  fC.SetFormulas Grd.Formulas
  
  Set Mouse = Nothing
  fC.Show vbModal
  
  Set Mouse = New cMouseWait
  
  If Not fC.Cancelled Then
    Grd.Formulas.Clear
    
    If fC.SelectionCount > 0 Then
      ReDim sThis(0 To fC.SelectionCount - 1)
      ReDim eFormulas(0 To fC.SelectionCount - 1)
      For j = 1 To fC.SelectionCount
        sThis(j - 1) = fC.SelectedKey(j)
        eFormulas(j - 1) = fC.SelectedFormula(j)
        With Grd.Formulas.Add(Nothing)
          .Column = fC.SelectedField(j)
          .ColumnKey = fC.SelectedKey(j)
          .FormulaType = fC.SelectedFormula(j)
        End With
      Next j
    End If
    Grd.RefreshGroupsAndFormulas
  End If
End Sub

Public Sub EditGroups(ByRef Grd As Object, _
                      ByRef vColumns() As String, _
                      ByRef vKeys() As String)
                      
  Dim fC        As fGroups
  Dim j         As Long
  Dim sThis()   As String
  Dim eOrder()  As cShellSortOrderCOnstants
  
  Dim Mouse As cMouseWait
  Set Mouse = New cMouseWait
  
  Set fC = New fGroups
  For j = LBound(vColumns) To UBound(vColumns)
    fC.AddField vColumns(j), vKeys(j)
  Next j
  
  fC.SetGroups Grd.Groups
  
  Set Mouse = Nothing
  fC.Show vbModal
  
  Set Mouse = New cMouseWait
  
  If Not fC.Cancelled Then
    Grd.Groups.Clear
    
    If fC.SelectionCount > 0 Then
      ReDim sThis(0 To fC.SelectionCount - 1)
      ReDim eOrder(0 To fC.SelectionCount - 1)
      For j = 1 To fC.SelectionCount
        sThis(j - 1) = fC.SelectedKey(j)
        eOrder(j - 1) = fC.SelectedOrder(j)
        With Grd.Groups.Add(Nothing)
          .Name = fC.SelectedField(j)
          .Index = j
          .Key = fC.SelectedKey(j)
          .SortType = fC.SelectedOrder(j)
        End With
      Next j
      DoGroup Grd, fC.SelectionCount, sThis(), eOrder()
    Else
      DoGroup Grd, 0, sThis(), eOrder()
    End If
  End If
End Sub

Public Sub EditHideColumns(ByRef Grd As Object, _
                           ByRef vColumns() As String, _
                           ByRef vKeys() As String)
                      
  Dim fC            As fGroups
  Dim j             As Long
  Dim i             As Long
  Dim bShow         As Boolean
  Dim bRedrawState  As Boolean
  
  Dim Mouse As cMouseWait
  Set Mouse = New cMouseWait
  
  Set fC = New fGroups
  For j = LBound(vColumns) To UBound(vColumns)
    If InStr(1, LCase$(vColumns(j)), c_IdColPrefix) = 0 Then
      fC.AddField vColumns(j), vKeys(j)
    End If
  Next j
  
  fC.SetHideColumns Grd
  
  Set Mouse = Nothing
  fC.Show vbModal
  
  Set Mouse = New cMouseWait
  
  If Not fC.Cancelled Then
    
    bRedrawState = Grd.Redraw
    Grd.Redraw = False
    
    For i = 1 To Grd.Columns
      
      If InStr(1, LCase$(Grd.ColumnHeader(i)), c_IdColPrefix) = 0 Then
    
        bShow = True
        For j = 1 To fC.SelectionCount
          If Grd.ColumnKey(i) = fC.SelectedKey(j) Then
            bShow = False
            Exit For
          End If
        Next j
        Grd.ColumnVisible(i) = bShow
        
        If Not bShow Then
          Grd.ColumnHidden(i) = True
        End If
      End If
    Next
    
    Grd.Redraw = bRedrawState
  End If
End Sub

Private Sub pCreateGroupColumns(ByRef Grd As Object)
  On Error Resume Next
  
  Dim i As Integer
  
  With Grd
    Err.Clear
    For i = 1 To .Groups.Count
      If .ExistsColumn(c_KeyGroup & i) Then
        .ColumnVisible(c_KeyGroup & i) = True
      Else
        .AddColumn c_KeyGroup & i, , , , 16, True, , i, False
      End If
    Next
    
    ' Now I have to remove group columns not used
    For i = .Groups.Count + 1 To .Columns
      If InStr(1, .ColumnKey(i), c_KeyGroup) > 0 Then
        .RemoveColumn i
      End If
    Next
  End With
End Sub

Public Sub DoFilters(ByRef Grd As Object)
  On Error GoTo ControlError
  
  Dim iRow              As Long
  Dim iCol              As Long
  Dim oFilter           As cGridColFilter
  Dim bFilter           As Boolean
  Dim Value             As Variant
  Dim CompareTo         As Variant
  Dim bRedrawState      As Boolean
  Dim n                 As Long
  Dim iFirstCol         As Long
  Dim iFirstRow         As Long
  
  iFirstRow = 1
  
  If Grd.Formulas.Count > 0 Then
    If Grd.Rows > 0 Then
      If Grd.RowIsGroup(1) Then
        iFirstRow = 3
      End If
    End If
  End If
    
  bRedrawState = Grd.Redraw
  Grd.Redraw = False
  
  iFirstCol = Grd.Groups.Count + 1
  
  If Grd.Filters.Count = 0 Then
    For iRow = iFirstRow To Grd.Rows
    
      Grd.RowFilterHide(iRow) = False
      
      ' Si el grupo no la oculto
      ' la pongo visible
      If Not Grd.RowGroupHide(iRow) Then
        Grd.RowVisible(iRow) = True
      End If
    Next
  Else
    For iRow = iFirstRow To Grd.Rows
    
      bFilter = True
      For n = Grd.Filters.Count To 1 Step -1
    
        Set oFilter = Grd.Filters(n)
    
        iCol = Grd.OriginalColumnIndex(oFilter.ColumnKey)
        
        If iCol > 0 Then
        
          Value = Grd.CellText(iRow, iCol)
          
          If Grd.RowIsGroup(iRow) Then
            iCol = 0
          Else
            If LenB(oFilter.ColumnKey2) Then
              iCol = Grd.OriginalColumnIndex(oFilter.ColumnKey2)
              
              If iCol > 0 Then
                CompareTo = Grd.CellText(iRow, iCol)
              End If
            Else
              CompareTo = oFilter.CompareTo
            End If
          End If
          
          If iCol > 0 Then
            Select Case oFilter.Operator
              Case csGrFOStartLike
                CompareTo = LCase$(Format$(CompareTo))
                If LCase$(Left$(Format$(Value), Len(CompareTo))) = CompareTo Then
                  bFilter = False
                  Exit For
                End If
              
              Case csGrFOLike
                CompareTo = LCase$(Format$(CompareTo))
                If InStr(1, LCase$(Format$(Value)), CompareTo) > 0 Then
                  bFilter = False
                  Exit For
                End If
              
              Case csGrFOEndLike
                CompareTo = LCase$(Format$(CompareTo))
                If LCase$(Right$(Format$(Value), Len(CompareTo))) = CompareTo Then
                  bFilter = False
                  Exit For
                End If
              
              Case csGrFOMajor, csGrFOEqual, csGrFOMinor, csGrFONotEqual
                Select Case Grd.ColumnSortType(iCol)
                  Case CCLSortNumeric
                    If IsNumeric(Value) Then
                      Value = CDbl(Value)
                    Else
                      Value = 0
                    End If
                    If IsNumeric(CompareTo) Then
                      CompareTo = CDbl(CompareTo)
                    Else
                      CompareTo = 0
                    End If
                  ' Date sorting
                  Case CCLSortDate, CCLSortDateYearAccuracy, CCLSortDateMonthAccuracy, _
                       CCLSortDateDayAccuracy, CCLSortDateHourAccuracy, _
                       CCLSortDateMinuteAccuracy
                   
                    If IsDate(Value) Then
                      Value = CVDate(Value)
                    Else
                      Value = 0
                    End If
                    If IsNumeric(CompareTo) Then
                      CompareTo = CVDate(CompareTo)
                    Else
                      CompareTo = 0
                    End If
                   
                  Case Else
                        ' CCLSortString
                        ' CCLSortStringNoCase
                        ' CCLSortIcon
                        ' CCLSortExtraIcon
                        ' CCLSortForeColor
                        ' CCLSortBackColor
                        ' CCLSortFontIndex
                        ' CCLSortSelected
                        ' CCLSortIndentation
                        CompareTo = LCase$(Format$(CompareTo))
                        Value = LCase$(Format$(Value))
                End Select
                
                Select Case oFilter.Operator
                  Case csGrFOEqual
                    If Value = CompareTo Then
                      bFilter = False
                      Exit For
                    End If
                  Case csGrFOMajor
                    If Value > CompareTo Then
                      bFilter = False
                      Exit For
                    End If
                  Case csGrFOMinor
                    If Value < CompareTo Then
                      bFilter = False
                      Exit For
                    End If
                  Case csGrFONotEqual
                    If Value <> CompareTo Then
                      bFilter = False
                      Exit For
                    End If
                End Select
            End Select
          End If
        End If
      Next
      
      ' Si hay que ocultarla
      If bFilter Then
        Grd.RowFilterHide(iRow) = True
        Grd.RowVisible(iRow) = False
      Else
      
        Grd.RowFilterHide(iRow) = False
        
        ' Si paso el filtro y no esta oculta por
        ' un grupo
        If Not Grd.RowGroupHide(iRow) Then
          Grd.RowVisible(iRow) = True
        End If
      End If
    Next
  End If
  
  pGroupsVisible Grd
  
  GoTo ExitProc
ControlError:
  MngError "DoFilters", C_Module
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
  Grd.Redraw = bRedrawState
End Sub

Public Sub DoFormats(ByRef Grd As Object)
  On Error GoTo ControlError
  
  Dim iRow        As Long
  Dim iCol        As Long
  Dim oFormat     As cGridColFormat
  Dim bFormat     As Boolean
  Dim Value       As Variant
  Dim CompareTo         As Variant
  Dim ConditionalFormat As cConditionalFormat
  Dim bRedrawState      As Boolean
  Dim n                 As Long
  Dim iFirstCol         As Long
  
  bRedrawState = Grd.Redraw
  Grd.Redraw = False
  
  iFirstCol = Grd.Groups.Count + 1
  
  If Grd.Formats.Count = 0 Then
    For iRow = 1 To Grd.Rows
      For iCol = 1 To Grd.Columns
        Grd.CellConditionalFormat(iRow, iCol) = Empty
      Next
    Next
  Else
    For iRow = 1 To Grd.Rows
    
      bFormat = False
      For n = Grd.Formats.Count To 1 Step -1
    
        Set oFormat = Grd.Formats(n)
    
        iCol = Grd.OriginalColumnIndex(oFormat.ColumnKey)
        
        If iCol > 0 Then
        
          Value = Grd.CellText(iRow, iCol)
          
          If Grd.RowIsGroup(iRow) And IsEmpty(Value) Then
            iCol = 0
          Else
            If LenB(oFormat.ColumnKey2) Then
              iCol = Grd.OriginalColumnIndex(oFormat.ColumnKey2)
              
              If iCol > 0 Then
                CompareTo = Grd.CellText(iRow, iCol)
              End If
            Else
              CompareTo = oFormat.CompareTo
            End If
          End If
          
          If iCol > 0 Then
            Select Case oFormat.Operator
              Case csGrFOStartLike
                CompareTo = LCase$(Format$(CompareTo))
                If LCase$(Left$(Format$(Value), Len(CompareTo))) = CompareTo Then
                  bFormat = True
                  Exit For
                End If
              
              Case csGrFOLike
                CompareTo = LCase$(Format$(CompareTo))
                If InStr(1, LCase$(Format$(Value)), CompareTo) > 0 Then
                  bFormat = True
                  Exit For
                End If
              
              Case csGrFOEndLike
                CompareTo = LCase$(Format$(CompareTo))
                If LCase$(Right$(Format$(Value), Len(CompareTo))) = CompareTo Then
                  bFormat = True
                  Exit For
                End If
              
              Case csGrFOMajor, csGrFOEqual, csGrFOMinor, csGrFONotEqual
                Select Case Grd.ColumnSortType(iCol)
                  Case CCLSortNumeric
                    If IsNumeric(Value) Then
                      Value = CDbl(Value)
                    Else
                      Value = 0
                    End If
                    If IsNumeric(CompareTo) Then
                      CompareTo = CDbl(CompareTo)
                    Else
                      CompareTo = 0
                    End If
                  ' Date sorting
                  Case CCLSortDate, CCLSortDateYearAccuracy, CCLSortDateMonthAccuracy, _
                       CCLSortDateDayAccuracy, CCLSortDateHourAccuracy, _
                       CCLSortDateMinuteAccuracy
                   
                    If IsDate(Value) Then
                      Value = CVDate(Value)
                    Else
                      Value = 0
                    End If
                    If IsNumeric(CompareTo) Then
                      CompareTo = CVDate(CompareTo)
                    Else
                      CompareTo = 0
                    End If
                   
                  Case Else
                        ' CCLSortString
                        ' CCLSortStringNoCase
                        ' CCLSortIcon
                        ' CCLSortExtraIcon
                        ' CCLSortForeColor
                        ' CCLSortBackColor
                        ' CCLSortFontIndex
                        ' CCLSortSelected
                        ' CCLSortIndentation
                        CompareTo = LCase$(Format$(CompareTo))
                        Value = LCase$(Format$(Value))
                End Select
                
                Select Case oFormat.Operator
                  Case csGrFOEqual
                    If Value = CompareTo Then
                      bFormat = True
                      Exit For
                    End If
                  Case csGrFOMajor
                    If Value > CompareTo Then
                      bFormat = True
                      Exit For
                    End If
                  Case csGrFOMinor
                    If Value < CompareTo Then
                      bFormat = True
                      Exit For
                    End If
                  Case csGrFONotEqual
                    If Value <> CompareTo Then
                      bFormat = True
                      Exit For
                    End If
                End Select
            End Select
          End If
        End If
      Next
      
      If bFormat Then
        
        For iCol = iFirstCol To Grd.Columns
          
          Set ConditionalFormat = New cConditionalFormat
          
          With ConditionalFormat
            If Not oFormat.Font Is Nothing Then
              .IFntIndex = Grd.AddFontIfRequierd(oFormat.Font)
            Else
              .IFntIndex = Grd.CellIFntIndex(iRow, iCol)
            End If
            If oFormat.BackColor <> -1 Then
              .OBackColor = oFormat.BackColor
            Else
              .OBackColor = Grd.CellBackColor(iRow, iCol)
            End If
            If oFormat.ForeColor <> -1 Then
              .OForeColor = oFormat.ForeColor
            Else
              .OForeColor = Grd.CellForeColor(iRow, iCol)
            End If
          End With
          
          Grd.CellConditionalFormat(iRow, iCol) = ConditionalFormat
        Next
      Else
        For iCol = 1 To Grd.Columns
          Grd.CellConditionalFormat(iRow, iCol) = Empty
        Next
      End If
    Next
  End If
  
  GoTo ExitProc
ControlError:
  MngError "DoFormats", C_Module
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
  Grd.Redraw = bRedrawState
End Sub

Public Sub DoGroup(ByRef Grd As Object, _
                   ByVal iItems As Long, _
                   sGroupColumns() As String, _
                   eOrder() As cShellSortOrderCOnstants)
                   
  On Error GoTo ControlError
  
  Dim bRedrawState      As Boolean
  Dim n                 As Long
  
  bRedrawState = Grd.Redraw
  Grd.Redraw = False
  
  m_iRefCount = 0
  pDoGroupAux Grd, iItems, sGroupColumns, eOrder
  
  DoFormats Grd
  
  GoTo ExitProc
ControlError:
  MngError "DoGroup", C_Module
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
  Grd.Redraw = bRedrawState
End Sub

Private Sub pDoGroupAux(ByRef Grd As Object, _
                        ByVal iItems As Long, _
                        sGroupColumns() As String, _
                        eOrder() As cShellSortOrderCOnstants)
                        
  Dim i             As Long
  Dim q             As Long
  Dim iRow          As Long
  Dim iCol          As Long
  Dim iNumber       As Long
  Dim sFnt          As StdFont
  Dim iFnt          As IFont
  Dim sJunk() As String, eJunk() As cShellSortOrderCOnstants
  Dim bForce        As Boolean
  Dim vLastItem()   As Variant
  Dim Group         As cGridGroup
  Dim GroupRow      As cGridGroupRow
  Dim RowGroupKey   As String
  Dim k             As Long
  Dim nIndexGroup   As Long
  Dim bCollapse     As Boolean
  Dim Formula       As cGridColFormula
  Dim Idx           As Long
  Dim Totals()      As Variant
  Dim OpenGroups()  As cGridGroupRow
  Dim Average()     As Long
  Dim CellValue     As Variant
  Dim sCopy1        As String
  Dim sCopy2        As String
  Dim bRowForTotals   As Boolean
  Dim bRowTotal       As Boolean
  
  pCreateGroupColumns Grd
  
  bRowForTotals = Grd.Formulas.Count > 0
  
  ' We need a column with type = RowText to can group
  If Not Grd.HasRowText Then
    Grd.AddColumn c_KeyGroupAuxColumn, , , , , , , , , , True
  Else
    Grd.ColumnKey(Grd.Columns) = c_KeyGroupAuxColumn
  End If

  m_iRefCount = m_iRefCount + 1
  
  If m_iRefCount = 1 Then
    For Each Group In Grd.Groups
      For Each GroupRow In Group.GroupRows
        GroupRow.IsValid = False
      Next
    Next
  End If
  
  iNumber = iItems - 1
  If (iNumber > 7) Then
    MsgBox "Can't do it - max grouping is restricted to 7 columns for this demo.", vbInformation
  Else
  
    ' /////////////////////////////////////////////////////////////////////
    '
    ' Solo formulas de totales generales
    ' esto es cuando no hay grupos
    '
  
    If (iNumber < 0) Then
      m_bGroup = False
      ' Remove all existing group rows:
      If Grd.HasRowText Then
        For iRow = Grd.Rows To 1 Step -1
          If (Grd.CellItemData(iRow, Grd.Columns) <> 0) Then
            Grd.RemoveRow iRow
          End If
        Next iRow
      End If
      For iRow = 1 To Grd.Rows
      
        Grd.RowGroupHide(iRow) = False
      
        ' Solo las filas que el agrupador oculto
        If Not Grd.RowFilterHide(iRow) Then
          Grd.RowVisible(iRow) = True
        End If
      Next iRow
      
      If (m_iRefCount = 1) Then
        
        Set iFnt = Grd.Font
        iFnt.Clone sFnt
        sFnt.Bold = True
        
        If bRowForTotals Then
          Grd.AddRowEx 1, "GROUP", , , True, 1, -1000
          Grd.AddRowEx 1, "GROUP", , , True, 1, -1001
          Grd.CellDetails 1, Grd.Columns, "Totales Generales", , , vbButtonFace, , sFnt, , , -1001
          With Grd.Cell(2, Grd.Columns)
            .ItemData = -1000
            .BackColor = vbButtonFace
          End With
        End If
        
        ReDim Totals(iNumber + 1, Grd.Formulas.Count)
        ReDim Average(iNumber + 1, Grd.Formulas.Count)
      
        ' NOTA: para que no pierda velocidad, duplique el codigo
        '       si detectan un bug en el calculo de los totales
        '       corrijanlo en ambos lugares.
        '       el codigo repetido empieza en el comentario
        '       CODIGO_TOTALES_REPETIDO_PRINCIPIO
        '       y termina en
        '       CODIGO_TOTALES_REPETIDO_FIN
      
        For iRow = 3 To Grd.Rows
        
          If Not Grd.RowFilterHide(iRow) Then
        
            '/////////////////////////////////////////////////
            ' Totales
            For i = 0 To UBound(Totals)
              
              ' CODIGO_TOTALES_REPETIDO_PRINCIPIO
              For Each Formula In Grd.Formulas
                Idx = Formula.Index
                iCol = Grd.OriginalColumnIndex(Formula.ColumnKey)
                If Not Formula.IsRowFormula And Not Formula.IsRowGroupFormula Then
                  If IsEmpty(Totals(i, Idx)) Then
                    If Formula.FormulaType = csGrFTCount Then
                      Totals(i, Idx) = 1
                    Else
                      Totals(i, Idx) = Grd.CellText(iRow, iCol)
                    End If
                    Average(i, Idx) = 1
                  Else
                    If Formula.FormulaType = csGrFTCount Then
                      Totals(i, Idx) = Totals(i, Idx) + 1
                    Else
                      CellValue = Grd.CellText(iRow, iCol)
                      If Not IsEmpty(CellValue) Then
                        
                        If IsNumeric(Totals(i, Idx)) And IsNumeric(CellValue) Then
                          Select Case Formula.FormulaType
                            Case csGrFTAverage
                              Totals(i, Idx) = CDbl(Totals(i, Idx)) + CDbl(CellValue)
                              Average(i, Idx) = Average(i, Idx) + 1
                            Case csGrFTMax
                              If CDbl(Totals(i, Idx)) < CDbl(CellValue) Then
                                Totals(i, Idx) = CDbl(CellValue)
                              End If
                            Case csGrFTMin
                              If CDbl(Totals(i, Idx)) > CDbl(CellValue) Then
                                Totals(i, Idx) = CDbl(CellValue)
                              End If
                            Case csGrFTSum
                              Totals(i, Idx) = CDbl(Totals(i, Idx)) + CDbl(CellValue)
                          End Select
                        
                        ElseIf IsDate(Totals(i, Idx)) And IsDate(CellValue) Then
                          ' For date only Max and Min are valid formulas
                          Select Case Formula.FormulaType
                            Case csGrFTMax
                              If CDbl(Totals(i, Idx)) < CDbl(CellValue) Then
                                Totals(i, Idx) = CDbl(CellValue)
                              End If
                            Case csGrFTMin
                              If CDbl(Totals(i, Idx)) > CDbl(CellValue) Then
                                Totals(i, Idx) = CDbl(CellValue)
                              End If
                          End Select
                        
                        Else
                          ' For string only Max and Min are valid formulas
                          Select Case Formula.FormulaType
                            Case csGrFTMax
                              sCopy1 = Totals(i, Idx)
                              sCopy2 = Trim(CellValue)
                              If sCopy1 < sCopy2 Then
                                Totals(i, Idx) = sCopy2
                              End If
                            Case csGrFTMin
                              sCopy1 = Totals(i, Idx)
                              sCopy2 = Trim(CellValue)
                              If sCopy1 > sCopy2 Then
                                Totals(i, Idx) = sCopy2
                              End If
                          End Select
                        End If
                      End If
                    End If
                  End If
                Else
                  Totals(i, Idx) = "@@sumrowvalue@@"
                End If
              Next
            Next
            ' CODIGO_TOTALES_REPETIDO_FIN
          End If
        Next
      End If
      
    ' /////////////////////////////////////////////////////////////////////
    '
    ' formulas de totales generales y grupos
    ' esto es cuando hay grupos
    '
      
    Else

      ' Remove groupings:
      pDoGroupAux Grd, 0, sJunk(), eJunk()
      m_bGroup = True
      
      ' Sort the grid according to the groupings:
      With Grd.SortObject
        .Clear
        
        ' Seteo el orden
        For i = 0 To UBound(sGroupColumns) 'iNumber
          .SortColumn(i + 1) = Grd.OriginalColumnIndex(sGroupColumns(i))
          .SortOrder(i + 1) = eOrder(i)
          If Grd.ColumnSortType(sGroupColumns(i)) = CCLSortDate Then
            .SortType(i + 1) = CCLSortDateDayAccuracy
          Else
            .SortType(i + 1) = Grd.ColumnSortType(sGroupColumns(i))
          End If
        Next i
      End With
      
      Grd.Sort
      
      ' Now add grouping rows:
      ReDim vLastItem(0 To iNumber)
      For q = 0 To UBound(vLastItem)
        
        ' Algo de basura para que cambien los grupos
        ' que estan debajo de este que si cambio
        vLastItem(q) = "@#$%jaja"
      Next
      
      Set iFnt = Grd.Font
      iFnt.Clone sFnt
      sFnt.Bold = True
      iRow = 1
      
      If bRowForTotals Then
        Grd.AddRowEx 1, "GROUP", , , True, 1, -1000
        Grd.AddRowEx 1, "GROUP", , , True, 1, -1001
        Grd.CellDetails 1, Grd.Columns, "Totales Generales", , , vbButtonFace, , sFnt, , , -1001
        With Grd.Cell(2, Grd.Columns)
          .ItemData = -1000
          .BackColor = vbButtonFace
        End With
        iRow = 3
      End If
      
      ReDim Totals(iNumber + 1, Grd.Formulas.Count)
      ReDim Average(iNumber + 1, Grd.Formulas.Count)
      ReDim OpenGroups(iNumber)
      
      Do
        bForce = False
        
        For i = 0 To iNumber
          If Not Grd.RowIsGroup(iRow) Then
          
            iCol = Grd.OriginalColumnIndex(sGroupColumns(i))
            
            If iCol > 0 Then
            
              Select Case Grd.ColumnSortType(sGroupColumns(i))
              Case CCLSortIcon, CCLSortExtraIcon
                If Val(Grd.CellIcon(iRow, iCol)) <> Val(vLastItem(i)) Or bForce Then
                  vLastItem(i) = Grd.CellIcon(iRow, iCol)
                  
                  ' Las filas de grupos y totales inicialmente se agregan no
                  ' visibles para que pGroupsVisible determine si deben
                  ' verse o no, segun los filtros
                  Grd.AddRowEx iRow, "GROUP", False, , True, i + 1, i + 1
                  If bRowForTotals Then
                    Grd.AddRowEx iRow + 1, "GROUP", , False, True, i + 1, (i + 1) * -1
                    With Grd.Cell(iRow + 1, Grd.Columns)
                      .ItemData = (i + 1) * -1
                      .BackColor = vbButtonFace
                    End With
                    Grd.RowFilterHide(iRow + 1) = True
                  End If
                  Grd.CellDetails iRow, Grd.Columns, , , vLastItem(i), vbButtonFace, , sFnt, , , i + 1
                  Grd.RowFilterHide(iRow) = True
                  
                  bForce = True
                End If
                
              Case Else
                If Trim(Grd.CellText(iRow, iCol)) <> Trim(vLastItem(i)) Or bForce Then
                  vLastItem(i) = Grd.CellText(iRow, iCol)
                  
                  ' Las filas de grupos y totales inicialmente se agregan no
                  ' visibles para que pGroupsVisible determine si deben
                  ' verse o no, segun los filtros
                  Grd.AddRowEx iRow, "GROUP", False, , True, i + 1, i + 1
                  If bRowForTotals Then
                    Grd.AddRowEx iRow + 1, "GROUP", False, , True, i + 1, (i + 1) * -1
                    With Grd.Cell(iRow + 1, Grd.Columns)
                      .ItemData = (i + 1) * -1
                      .BackColor = vbButtonFace
                    End With
                    Grd.RowFilterHide(iRow + 1) = True
                  End If
                  Grd.CellDetails iRow, Grd.Columns, vLastItem(i), , , vbButtonFace, , sFnt, , , i + 1
                  Grd.RowFilterHide(iRow) = True
                  
                  bForce = True
                End If
              End Select
              
            Else
              bForce = bRowTotal
              bRowTotal = False
            End If
            
            If bForce Then
            
              ' Ok cambie de grupo, ahora tengo que
              ' resetear las formulas de los grupos que estan en
              ' en el nivel de este nuevo grupo y debajo de este.
              If Not GroupRow Is Nothing Then
            
                ' Averiguo el nivel del grupo en el que estaba
                nIndexGroup = Grd.IndexGroup(GroupRow.RowIndex) - 1
                
                ' Si se trata de un subgrupo, tengo que seguir incrementando
                ' los grupo padre y los presentare en la grilla cuando cambie
                ' el grupo padre o cuando termine de recorrer las filas
                If nIndexGroup < i Then
                
                  Set OpenGroups(nIndexGroup) = GroupRow
                  
                ' Si se trata de un grupo de nivel igual o superior tengo que cerrar
                ' todos los grupos pendientes hasta el nivel del grupo actual
                Else
                  Set OpenGroups(nIndexGroup) = GroupRow
                  pSetTotalGroups i, OpenGroups, Grd, Totals, Average, sFnt
                End If
              End If
              
              For q = i + 1 To UBound(vLastItem)
                
                ' Algo de basura para que cambien los grupos
                ' que estan debajo de este que si cambio
                vLastItem(q) = "@#$%jaja"
              Next
              
              ' Mantengo una coleccion del estado expandido del row group
              Set Group = Grd.Groups(i + 1)
              
              ' !!!! No hos asusteis esto esta bien, Coño no sean maricones
              '      y lean el comentario del for que limpia vLastItem
              RowGroupKey = pGetKeyGroupRow(Group.Index, vLastItem())
              
              If Group.GroupRows(RowGroupKey) Is Nothing Then
                Set GroupRow = Group.GroupRows.Add(Nothing, RowGroupKey)
                With GroupRow
                  .Expanded = False
                  .RowIndex = iRow
                  .GroupValue = iRow
                  .IsValid = True
                End With
              Else
                Set GroupRow = Group.GroupRows.Item(RowGroupKey)
                With GroupRow
                  .IsValid = True
                  .RowIndex = iRow
                End With
              End If
            End If
          End If
        Next i
        
        ' NOTA: para que no pierda velocidad, duplique el codigo
        '       si detectan un bug en el calculo de los totales
        '       corrijanlo en ambos lugares.
        '       el codigo repetido empieza en el comentario
        '       CODIGO_TOTALES_REPETIDO_PRINCIPIO
        '       y termina en
        '       CODIGO_TOTALES_REPETIDO_FIN
        
        '/////////////////////////////////////////////////
        ' Totales
        If Not (Grd.RowIsGroup(iRow) Or Grd.RowFilterHide(iRow)) Then
          For i = 0 To UBound(Totals)
            
            ' CODIGO_TOTALES_REPETIDO_PRINCIPIO
            For Each Formula In Grd.Formulas
              Idx = Formula.Index
              iCol = Grd.OriginalColumnIndex(Formula.ColumnKey)
              If Not Formula.IsRowFormula And Not Formula.IsRowGroupFormula Then
                If IsEmpty(Totals(i, Idx)) Then
                  If Formula.FormulaType = csGrFTCount Then
                    Totals(i, Idx) = 1
                  Else
                    Totals(i, Idx) = Grd.CellText(iRow, iCol)
                  End If
                  Average(i, Idx) = 1
                Else
                  If Formula.FormulaType = csGrFTCount Then
                    Totals(i, Idx) = Totals(i, Idx) + 1
                  Else
                    CellValue = Grd.CellText(iRow, iCol)
                    If Not IsEmpty(CellValue) Then
                      
                      If IsNumeric(Totals(i, Idx)) And IsNumeric(CellValue) Then
                        Select Case Formula.FormulaType
                          Case csGrFTAverage
                            Totals(i, Idx) = CDbl(Totals(i, Idx)) + CDbl(CellValue)
                            Average(i, Idx) = Average(i, Idx) + 1
                          Case csGrFTMax
                            If CDbl(Totals(i, Idx)) < CDbl(CellValue) Then
                              Totals(i, Idx) = CDbl(CellValue)
                            End If
                          Case csGrFTMin
                            If CDbl(Totals(i, Idx)) > CDbl(CellValue) Then
                              Totals(i, Idx) = CDbl(CellValue)
                            End If
                          Case csGrFTSum
                            Totals(i, Idx) = CDbl(Totals(i, Idx)) + CDbl(CellValue)
                        End Select
                      
                      ElseIf IsDate(Totals(i, Idx)) And IsDate(CellValue) Then
                        ' For date only Max and Min are valid formulas
                        Select Case Formula.FormulaType
                          Case csGrFTMax
                            If CDbl(Totals(i, Idx)) < CDbl(CellValue) Then
                              Totals(i, Idx) = CDbl(CellValue)
                            End If
                          Case csGrFTMin
                            If CDbl(Totals(i, Idx)) > CDbl(CellValue) Then
                              Totals(i, Idx) = CDbl(CellValue)
                            End If
                        End Select
                      
                      Else
                        ' For string only Max and Min are valid formulas
                        Select Case Formula.FormulaType
                          Case csGrFTMax
                            sCopy1 = Totals(i, Idx)
                            sCopy2 = Trim(CellValue)
                            If sCopy1 < sCopy2 Then
                              Totals(i, Idx) = sCopy2
                            End If
                          Case csGrFTMin
                            sCopy1 = Totals(i, Idx)
                            sCopy2 = Trim(CellValue)
                            If sCopy1 > sCopy2 Then
                              Totals(i, Idx) = sCopy2
                            End If
                        End Select
                      End If
                    End If
                  End If
                End If
              Else
                Totals(i, Idx) = "@@sumrowvalue@@"
              End If
            Next
          Next
          ' CODIGO_TOTALES_REPETIDO_FIN
        End If
        iRow = iRow + 1
      Loop While iRow <= Grd.Rows
    
      nIndexGroup = Grd.IndexGroup(GroupRow.RowIndex) - 1
    
      If nIndexGroup >= 0 Then Set OpenGroups(nIndexGroup) = GroupRow
      pSetTotalGroups 0, OpenGroups, Grd, Totals, Average, sFnt
    End If
        
    ' Start redrawing again:
    If (m_iRefCount = 1) Then
      
      pSetGrandTotal Grd, Totals, Average, sFnt
      
      k = 0
      
      ' Elimino los que despues del refresh ya no estan
      For Each Group In Grd.Groups
        While k < Group.GroupRows.Count
          k = k + 1
          If Not Group.GroupRows.Item(k).IsValid Then
            Group.GroupRows.Remove k
          End If
        Wend
      Next
      
      pGroupsVisible Grd
      
      ' /////////////////////////////////////////////////////////////////////
      
      '
      ' Ahora las formulas de tipo fila
      '
      '
      sFnt.Bold = False
      
      Dim bExistsRowGroupFormula As Boolean
      
      For Each Formula In Grd.Formulas
        If Formula.IsRowGroupFormula Then
          bExistsRowGroupFormula = True
        End If
      Next
      
      If bExistsRowGroupFormula And Grd.Rows Then
      
        Dim ValCurrentCol As Double
        Dim sValue        As String
        Dim sRealValue    As String
        Dim nValue        As Double
        Dim bIsTitleGroup As Boolean
        
        iRow = 1
        bIsTitleGroup = True
        
        Do
          '/////////////////////////////////////////////////
          ' Totales
          If Not Grd.RowFilterHide(iRow) Then
            
            If Grd.RowIsGroup(iRow) Then
            
              If bIsTitleGroup Then
                bIsTitleGroup = False
              Else
                bIsTitleGroup = True
                        
                '/////////////////////////////////////////////////
                ' Totales
                For i = 0 To UBound(Totals)
              
                  For Each Formula In Grd.Formulas
                    
                    If Formula.IsRowGroupFormula Then
                      Idx = Formula.Index
                      iCol = Grd.OriginalColumnIndex(Formula.ColumnKey)
                      
                      sValue = Grd.CellText(iRow, iCol)
                      If LenB(sValue) = 0 Then
                        sValue = "@@sumrowvalue@@"
                      End If
                      sRealValue = Replace$(sValue, "@@sumrowvalue@@", "")
                      If sRealValue = "" Then
                        sValue = Format$("0", Grd.ColumnFormatString(iCol)) & vbCrLf & "@@sumrowvalue@@"
                      End If
                      If IsNumeric(sRealValue) Then
                        nValue = CDbl(sRealValue)
                      Else
                        nValue = 0
                      End If
                      ValCurrentCol = ValCurrentCol + nValue
                      sValue = Replace$(sValue, "@@sumrowvalue@@", Format$(ValCurrentCol, Grd.ColumnFormatString(iCol)))
                      Grd.CellDetails iRow, iCol, sValue, DT_RIGHT, , vbButtonFace, , sFnt, , , C_TOTAL_COLUMN_EX
                      
                    End If
                  Next
                Next
              End If
            End If
            
            ' CODIGO_TOTALES_REPETIDO_FIN
          End If
          ValCurrentCol = 0
          iRow = iRow + 1
        Loop While iRow <= Grd.Rows
      
      End If
      
      ' /////////////////////////////////////////////////////////////////////
      
      ' Fin formulas de tipo fila
      
      ' /////////////////////////////////////////////////////////////////////
      
      ' Colapso y Expando las filas que estan dentro de los grupos
      ' segun el estado de los grupos guardados en la coleccion
      ' de grupos.
      pExpandGroups Grd
      
    End If
  End If
  m_iRefCount = m_iRefCount - 1
End Sub

Private Sub pSetGrandTotal(ByRef Grd As Object, ByRef Totals() As Variant, ByRef Average() As Long, ByVal sFnt As StdFont)
  Dim Formula   As cGridColFormula
  Dim Idx       As Long
  Dim Align     As ECGTextAlignFlags
  Dim sValue    As String
  Dim ColName   As String
  Dim FormulaTitle As String
  Dim FormulaTitle2 As String
  Dim sFormulas     As String
  Dim TotalColFlag  As Long
  Dim lCol          As Long
  Dim lRow          As Long
  Dim k             As Long
  
  sFnt.Bold = False
  
  ColName = vbNullString
  
  k = UBound(Totals, 1)
  
  For Each Formula In Grd.Formulas
    Idx = Formula.Index
    If Not IsEmpty(Totals(k, Idx)) Then
      If IsNumeric(Totals(k, Idx)) Or IsDate(Totals(k, Idx)) Then
        Align = DT_RIGHT
      Else
        Align = DT_LEFT
      End If
      
      If Formula.FormulaType = csGrFTAverage And IsNumeric(Totals(k, Idx)) Then
        Totals(k, Idx) = Totals(k, Idx) / Average(k, Idx)
      End If
      
      lCol = Grd.OriginalColumnIndex(Formula.ColumnKey)
      lRow = 2
      
      If ColName = Formula.Column Then
        FormulaTitle = pGetFormulaNick(Formula)
        sValue = Grd.CellText(lRow, lCol) & vbCrLf & Format$(Totals(k, Idx), Grd.ColumnFormatString(lCol))
        If Trim$(Totals(k, Idx)) <> "@@sumrowvalue@@" Then
          sFormulas = sFormulas & FormulaTitle2 & vbCrLf & FormulaTitle
        End If
        FormulaTitle2 = vbNullString
        TotalColFlag = C_TOTAL_COLUMN_EX
        Align = DT_RIGHT
      Else
        sFormulas = vbNullString
        ColName = Formula.Column
        sValue = Format$(Totals(k, Idx), Grd.ColumnFormatString(lCol))
        FormulaTitle2 = pGetFormulaNick(Formula)
        TotalColFlag = C_TOTAL_COLUMN
      End If
      
      lCol = Grd.ColumnIndex(Formula.ColumnKey)
      
      Grd.CellDetails lRow, lCol, sValue, Align, , vbButtonFace, , sFnt, , , TotalColFlag
      Grd.CellTextFormula(lRow, lCol) = sFormulas
      
      ' Reseteo
      Totals(k, Idx) = Empty
    End If
  Next
  
  sFnt.Bold = True
End Sub

Private Sub pSetTotalGroups(ByVal nIndexGroup As Long, ByRef OpenGroups() As cGridGroupRow, ByRef Grd As Object, _
                            ByRef Totals() As Variant, ByRef Average() As Long, ByVal sFnt As StdFont)
  Dim k         As Long
  Dim Formula   As cGridColFormula
  Dim Idx       As Long
  Dim Align     As ECGTextAlignFlags
  Dim GroupRow  As cGridGroupRow
  Dim sValue    As String
  Dim ColName   As String
  Dim FormulaTitle As String
  Dim FormulaTitle2 As String
  Dim sFormulas     As String
  Dim TotalColFlag  As Long
  Dim lCol          As Long
  Dim lRow          As Long
  
  sFnt.Bold = False
  
  For k = nIndexGroup To UBound(OpenGroups)
    Set GroupRow = OpenGroups(k)
    If Not GroupRow Is Nothing Then
      ColName = vbNullString
      For Each Formula In Grd.Formulas
        Idx = Formula.Index
        If k > -1 Then
          If Not IsEmpty(Totals(k, Idx)) Then
            If IsNumeric(Totals(k, Idx)) Or IsDate(Totals(k, Idx)) Then
              Align = DT_RIGHT
            Else
              Align = DT_LEFT
            End If
            
            If Formula.FormulaType = csGrFTAverage And IsNumeric(Totals(k, Idx)) Then
              Totals(k, Idx) = Totals(k, Idx) / Average(k, Idx)
            End If
            
            lCol = Grd.OriginalColumnIndex(Formula.ColumnKey)
            lRow = GroupRow.RowIndex + 1
            
            If ColName = Formula.Column Then
              FormulaTitle = pGetFormulaNick(Formula)
              sValue = Grd.CellText(lRow, lCol) & vbCrLf & Format$(Totals(k, Idx), Grd.ColumnFormatString(lCol))
              If Trim$(Totals(k, Idx)) <> "@@sumrowvalue@@" Then
                sFormulas = sFormulas & FormulaTitle2 & vbCrLf & FormulaTitle
              End If
              FormulaTitle2 = vbNullString
              TotalColFlag = C_TOTAL_COLUMN_EX
              Align = DT_RIGHT
            Else
              sFormulas = vbNullString
              ColName = Formula.Column
              sValue = Format$(Totals(k, Idx), Grd.ColumnFormatString(lCol))
              FormulaTitle2 = pGetFormulaNick(Formula)
              TotalColFlag = C_TOTAL_COLUMN
            End If
            
            lCol = Grd.ColumnIndex(Formula.ColumnKey)
            
            Grd.CellDetails lRow, lCol, sValue, Align, , vbButtonFace, , sFnt, , , TotalColFlag
            Grd.CellTextFormula(lRow, lCol) = sFormulas
            
            ' Reseteo
            Totals(k, Idx) = Empty
          End If
        End If
      Next
      
      Set OpenGroups(nIndexGroup) = Nothing
    End If
  Next
  
  sFnt.Bold = True
End Sub

Private Function pGetFormulaNick(ByRef Formula As cGridColFormula) As String
  Dim rtn As String
  Select Case Formula.FormulaType
    Case csGrFTAverage
      rtn = "prom:"
    Case csGrFTCount
      rtn = "cant:"
    Case csGrFTMax
      rtn = "max:"
    Case csGrFTMin
      rtn = "min:"
    Case csGrFTSum
      rtn = "sum:"
  End Select
  
  pGetFormulaNick = "   " & rtn
End Function

Private Function pFatherGroupIsExpanded(ByRef Grd As Object, ByRef GroupRow As cGridGroupRow) As Boolean
  Dim iRow            As Long
  Dim nIndexGroup     As Long
  Dim currIndexGroup  As Long
  Dim bFound          As Boolean
  
  nIndexGroup = Grd.IndexGroup(GroupRow.RowIndex)
  
  For iRow = GroupRow.RowIndex - 1 To 1 Step -1
    currIndexGroup = Grd.IndexGroup(iRow)
    If currIndexGroup < nIndexGroup And currIndexGroup > 0 Then
      bFound = True
      Exit For
    End If
  Next
  
  If bFound Then
  
    pFatherGroupIsExpanded = pGroupIsExpanded(Grd, iRow)
    
  ' Si no encontre un grupo de nivel superior
  ' devuelvo true
  Else
    pFatherGroupIsExpanded = True
  End If
End Function

Private Function pGetRowFatherGroup(ByRef Grd As Object, ByRef lRow As Long) As Long
  Dim iRow            As Long
  Dim nIndexGroup     As Long
  Dim currIndexGroup  As Long
  Dim bFound          As Boolean
  
  nIndexGroup = Grd.IndexGroup(lRow)
  
  For iRow = lRow - 1 To 1 Step -1
    currIndexGroup = Grd.IndexGroup(iRow)
    If currIndexGroup < nIndexGroup And currIndexGroup > 0 Then
      bFound = True
      Exit For
    End If
  Next
  
  If bFound Then
  
    pGetRowFatherGroup = iRow
    
  ' Si no encontre un grupo de nivel superior
  ' devuelvo true
  Else
    pGetRowFatherGroup = 0
  End If
End Function

Public Sub ExpandAll(ByRef Grd As Object)
  pExpandCollapseAll Grd, c_GroupIconExpand
End Sub

Public Sub CollapseAll(ByRef Grd As Object)
  pExpandCollapseAll Grd, c_GroupIconCollapse
End Sub

Private Sub pExpandCollapseAll(ByRef Grd As Object, ByVal IconGroup As Long)
  Dim lRow As Long
  Dim lCol As Long
  Dim sKey As String
  
  For lRow = 1 To Grd.Rows
  
    If Grd.RowIsGroup(lRow) Then
      For lCol = 1 To Grd.Columns
        sKey = Grd.ColumnKey(lCol)
        If (sKey = c_KeyGroupAuxColumn) Then
          Exit For
        End If
      Next
      If lCol <= Grd.Columns Then
        If (Grd.CellGroupIcon(lRow, Grd.Columns) = IconGroup) Then
          ClickInGroup Grd, lRow, lCol
        End If
      End If
    End If
  Next
End Sub

Public Sub ClickInGroup(ByRef Grd As Object, ByVal lRow As Long, ByVal lCol As Long)
  Dim sKey              As String
  Dim bFound            As Boolean
  Dim CurrGroupIndex    As Long
  Dim FirstGroupIndex   As Long
  Dim bIgnoreUntilNext  As Boolean
  Dim bGroupExpanded()  As Boolean
  Dim Value             As String
  Dim GroupIndex        As Long
  Dim GroupRow          As Long
  Dim bRowForTotals     As Boolean
  Dim oldRedraw         As Boolean

  ' If not have RowText can't be grouped
  If Not Grd.HasRowText Then Exit Sub

  GroupRow = lRow

  If (lRow > 0) And (lCol > 0) Then
    ' Dbl clicked on a valid cell.  Find out whether it is a group or
    ' not:
    sKey = Grd.ColumnKey(lCol)
    If (sKey = c_KeyGroupAuxColumn) Then
      
      oldRedraw = Grd.Redraw
      Grd.Redraw = False
      
      ' Expand or collapse:
      CurrGroupIndex = Grd.CellItemData(lRow, Grd.Columns)
      If (Grd.CellGroupIcon(lRow, Grd.Columns) = c_GroupIconCollapse) Then
        ' collapse:
        Grd.CellGroupIcon(lRow, Grd.Columns) = c_GroupIconExpand
        pSetExpandedGroup Grd, lRow, False
        
        lRow = lRow + 1
        Do While lRow <= Grd.Rows And Not bFound
          GroupIndex = Grd.CellItemData(lRow, Grd.Columns)
          ' Si es una fila de totales
          If GroupIndex < 0 Then
            ' Si no es la fila de totales de este grupo
            ' la oculto
            If GroupIndex * -1 <> CurrGroupIndex Then
              Grd.RowGroupHide(lRow) = True
              Grd.RowVisible(lRow) = False
            End If
            
          ' Si es una fila de subgrupo o una fila comun la oculto
          ElseIf GroupIndex = 0 Or GroupIndex > CurrGroupIndex Then
            Grd.RowGroupHide(lRow) = True
            Grd.RowVisible(lRow) = False
          
          ' Si no encontre un grupo del mismo nivel
          Else
            bFound = True
          End If
          lRow = lRow + 1
        Loop
      Else
        ' expand:
        bRowForTotals = Grd.Formulas.Count > 0
        
        FirstGroupIndex = CurrGroupIndex
        ReDim bGroupExpanded(pGetGroupsCount(Grd))
        
        bGroupExpanded(FirstGroupIndex) = True
        
        Grd.CellGroupIcon(lRow, Grd.Columns) = c_GroupIconCollapse
        pSetExpandedGroup Grd, lRow, True
        
        lRow = lRow + 1
        Do While lRow <= Grd.Rows And Not bFound
          
          GroupIndex = Grd.CellItemData(lRow, Grd.Columns)
          
          ' Si encontre un grupo del mismo nivel que el grupo a expandir
          ' termine
          If GroupIndex <= FirstGroupIndex And GroupIndex > 0 Then
            bFound = True
          
          ' Si es un subgrupo
          ElseIf GroupIndex > CurrGroupIndex Then
            If bGroupExpanded(CurrGroupIndex) Then
              
              Grd.RowGroupHide(lRow) = False
              If bRowForTotals Then
                Grd.RowGroupHide(lRow + 1) = False
              End If
              
              ' Solo las filas que el agrupador oculto
              If Not Grd.RowFilterHide(lRow) Then
                Grd.RowVisible(lRow) = True
                If bRowForTotals Then
                  Grd.RowVisible(lRow + 1) = True
                End If
              End If
              
              CurrGroupIndex = GroupIndex
              bGroupExpanded(CurrGroupIndex) = pGroupIsExpanded(Grd, lRow)
            Else
              Grd.RowGroupHide(lRow) = True
              Grd.RowVisible(lRow) = False
              If bRowForTotals Then
                Grd.RowGroupHide(lRow + 1) = True
                Grd.RowVisible(lRow + 1) = False
              End If
            End If
          
          ' Si es un grupo superior, su rowgroup es visible pues de lo
          ' contrario no entraria en el if, y lo que hay que determinar
          ' es si esta expandido o no
          ElseIf GroupIndex <= CurrGroupIndex And GroupIndex > 0 Then
            
            Grd.RowGroupHide(lRow) = False
            If bRowForTotals Then
              Grd.RowGroupHide(lRow + 1) = False
            End If
            
            ' Solo las filas que el agrupador oculto
            If Not Grd.RowFilterHide(lRow) Then
              Grd.RowVisible(lRow) = True
              If bRowForTotals Then
                Grd.RowVisible(lRow + 1) = True
              End If
            End If
            
            CurrGroupIndex = GroupIndex
            bGroupExpanded(CurrGroupIndex) = pGroupIsExpanded(Grd, lRow)
          
          ' Si es solo una fila, depende de si su grupo es visible o no
          ElseIf GroupIndex = 0 Then
            'If Not grd.RowIsGroup(lRow) Then
              
              Grd.RowGroupHide(lRow) = Not bGroupExpanded(CurrGroupIndex)
              
              ' Solo las filas que el agrupador oculto
              If Not Grd.RowFilterHide(lRow) Then
                Grd.RowVisible(lRow) = bGroupExpanded(CurrGroupIndex)
              End If
            'End If
          ElseIf GroupIndex > 0 Then
            bFound = True
          End If
          lRow = lRow + 1
        Loop
      End If
      
      If oldRedraw Then
      
        Grd.pScrollVisible

        If GroupRow > 1 Then
          Grd.pbEnsureVisibleY GroupRow - 1, lCol
        End If
        
        If GroupRow < Grd.Rows Then
          Grd.pbEnsureVisibleY GroupRow + 1, lCol
        End If
      End If
      
      Grd.pbEnsureVisibleY GroupRow, lCol
      
      Grd.Redraw = oldRedraw
    End If
  End If
End Sub

Private Sub pSetExpandedGroup(ByRef Grd As Object, ByVal lRow As Long, ByVal bState As Boolean)
  Dim RowGroupKey  As String
  Dim nIndexGroup  As Long
  Dim Value()      As Variant
  Dim Group        As cGridGroup
  Dim GroupRow     As cGridGroupRow
  
  nIndexGroup = Grd.IndexGroup(lRow)
  Set Group = Grd.Groups(nIndexGroup)
  
  Value = pGetGroupValue(Grd, lRow)
  
  RowGroupKey = pGetKeyGroupRow(nIndexGroup, Value())
  
  Set GroupRow = Group.GroupRows(RowGroupKey)
  If GroupRow Is Nothing Then Exit Sub
  
  GroupRow.Expanded = bState
End Sub

Private Function pGetGroupValue(ByRef Grd As Object, ByVal lRow As Long) As Variant
  Dim Value()     As Variant
  Dim i           As Long
  Dim nIndexGroup As Long
  Dim lCol        As Long
  
  nIndexGroup = Grd.IndexGroup(lRow)
  
  ReDim Value(nIndexGroup - 1)
  
  For i = nIndexGroup To 1 Step -1
    
    lCol = Grd.Columns
    
    Select Case Grd.ColumnSortType(Grd.Groups(i).Key)
      Case CCLSortIcon, CCLSortExtraIcon
        Value(i - 1) = Grd.CellIcon(lRow, lCol)
      Case Else
        Value(i - 1) = Grd.CellText(lRow, lCol)
    End Select
    
    lRow = pGetRowFatherGroup(Grd, lRow)
  Next
  
  pGetGroupValue = Value
End Function

Private Function pGroupIsExpanded(ByRef Grd As Object, ByVal lRow As Long) As Boolean
  Dim RowGroupKey  As String
  Dim nIndexGroup  As Long
  Dim Value()      As Variant
  Dim GroupRow     As cGridGroupRow
  Dim Group        As cGridGroup
  
  nIndexGroup = Grd.IndexGroup(lRow)
  Set Group = Grd.Groups(nIndexGroup)
  
  Value = pGetGroupValue(Grd, lRow)
  
  RowGroupKey = pGetKeyGroupRow(nIndexGroup, Value)
  
  Set GroupRow = Group.GroupRows(RowGroupKey)
  If GroupRow Is Nothing Then Exit Function
  
  pGroupIsExpanded = GroupRow.Expanded
End Function

Private Function pGetKeyGroupRow(ByVal lIndex As Long, ByRef valRow() As Variant) As String
  Dim Value As String
  Dim i     As Long
  
  For i = 0 To lIndex - 1
    Value = Value & valRow(i) & "|"
  Next
  
  pGetKeyGroupRow = "K" & lIndex & "_" & Value
End Function

Private Sub pExpandGroups(ByRef Grd As Object)
  Dim lRow              As Long
  Dim bFound            As Boolean
  Dim CurrGroupIndex    As Long
  Dim FirstGroupIndex   As Long
  Dim bGroupExpanded()  As Boolean
  Dim GroupIndex        As Long
  Dim bRowForTotals     As Boolean
  
  
  If Grd.Formulas.Count > 0 Then
    bRowForTotals = True
    lRow = 3
  Else
    lRow = 1
  End If
  
  Do While lRow < Grd.Rows
  
    If Grd.RowIsGroup(lRow) Then
    
      CurrGroupIndex = Grd.CellItemData(lRow, Grd.Columns)
  
      FirstGroupIndex = CurrGroupIndex
      
      ' Si es < 0 es una fila de totales
      If FirstGroupIndex < 0 Then
        Grd.RowVisible(lRow) = Grd.RowVisible(lRow - 1)
        Grd.RowGroupHide(lRow) = Not Grd.RowVisible(lRow)
        lRow = lRow + 1
      Else
      
        ReDim bGroupExpanded(pGetGroupsCount(Grd))
        
        bGroupExpanded(FirstGroupIndex) = pGroupIsExpanded(Grd, lRow)
        
        If bGroupExpanded(FirstGroupIndex) Then
          Grd.CellGroupIcon(lRow, Grd.Columns) = c_GroupIconCollapse
        Else
          Grd.CellGroupIcon(lRow, Grd.Columns) = c_GroupIconExpand
        End If
        
        bFound = False
        
        lRow = lRow + 1
        Do While lRow <= Grd.Rows And Not bFound
          
          GroupIndex = Grd.CellItemData(lRow, Grd.Columns)
          
          ' Si es < 0 es una fila de totales
          If GroupIndex < 0 Then
            Grd.RowVisible(lRow) = Grd.RowVisible(lRow - 1)
            Grd.RowGroupHide(lRow) = Not Grd.RowVisible(lRow)
          
          ' Si encontre un grupo del mismo nivel que el grupo a expandir
          ' termine
          ElseIf GroupIndex <= FirstGroupIndex And GroupIndex > 0 Then
            bFound = True
          
          ' Si es un subgrupo
          ElseIf GroupIndex > CurrGroupIndex Then
            If bGroupExpanded(CurrGroupIndex) Then
            
              Grd.RowGroupHide(lRow) = False
              If bRowForTotals Then
                Grd.RowGroupHide(lRow + 1) = False
              End If
            
              ' Solo las filas que el agrupador oculto
              If Not Grd.RowFilterHide(lRow) Then
              
                Grd.RowVisible(lRow) = True
                If bRowForTotals Then
                  Grd.RowVisible(lRow + 1) = True
                End If
              End If
              
              CurrGroupIndex = GroupIndex
              bGroupExpanded(CurrGroupIndex) = pGroupIsExpanded(Grd, lRow)
            Else
              Grd.RowGroupHide(lRow) = True
              If bRowForTotals Then
                Grd.RowGroupHide(lRow + 1) = False
              End If

              Grd.RowVisible(lRow) = False
              If bRowForTotals Then
                Grd.RowVisible(lRow + 1) = False
              End If
            End If
          
          ' Si es un grupo superior, su rowgroup es visible pues de lo
          ' contrario no entraria en el if, y lo que hay que determinar
          ' es si esta expandido o no
          ElseIf GroupIndex <= CurrGroupIndex And GroupIndex > 0 Then
            
            Grd.RowGroupHide(lRow) = False
            If bRowForTotals Then
              Grd.RowGroupHide(lRow + 1) = False
            End If
            
            ' Solo las filas que el agrupador oculto
            If Not Grd.RowFilterHide(lRow) Then
              
              Grd.RowVisible(lRow) = True
              If bRowForTotals Then
                Grd.RowVisible(lRow + 1) = True
              End If
            End If
            
            CurrGroupIndex = GroupIndex
            bGroupExpanded(CurrGroupIndex) = pGroupIsExpanded(Grd, lRow)
          
          ' Si es solo una fila, depende de si su grupo es visible o no
          ElseIf GroupIndex = 0 Then
            'If Not grd.RowIsGroup(lRow) Then
  
              Grd.RowGroupHide(lRow) = Not bGroupExpanded(CurrGroupIndex)
            
              ' Solo las filas que el agrupador oculto
              If Not Grd.RowFilterHide(lRow) Then
                Grd.RowVisible(lRow) = bGroupExpanded(CurrGroupIndex)
              End If
            'End If
          Else
            bFound = True
          End If
          
          If GroupIndex > 0 Then
            If pGroupIsExpanded(Grd, lRow) Then
              Grd.CellGroupIcon(lRow, Grd.Columns) = c_GroupIconCollapse
            Else
              Grd.CellGroupIcon(lRow, Grd.Columns) = c_GroupIconExpand
            End If
          End If
          
          lRow = lRow + 1
        Loop
        lRow = lRow - 1
      End If
    Else
      lRow = lRow + 1
    End If
  Loop
End Sub

Private Sub pGroupsVisible(ByRef Grd As Object)
  Dim lRow             As Long
  Dim lLastRowGroup()  As Long
  Dim bVisible         As Boolean
  Dim nGroupIndex      As Long
  Dim i                As Long
  Dim bRowForTotals    As Boolean
  
  Dim iGroupsCount     As Long
  
  iGroupsCount = pGetGroupsCount(Grd)
  
  ReDim lLastRowGroup(iGroupsCount)
  
  If Grd.Formulas.Count > 0 Then
    bRowForTotals = True
    lRow = 3
  Else
    lRow = 1
  End If
  
  Do While lRow <= Grd.Rows
    ' Si es un grupo y yo lo oculte por filtros
    ' tengo que averiguar si tiene filas visibles
    If Grd.RowIsGroup(lRow) And Grd.RowFilterHide(lRow) Then
      nGroupIndex = Grd.IndexGroup(lRow)
      
      If nGroupIndex > 0 Then
      
        If lLastRowGroup(nGroupIndex) <> 0 And bVisible Then
          For i = 1 To iGroupsCount
            If lLastRowGroup(i) > 0 Then
              If Not Grd.RowGroupHide(lLastRowGroup(i)) Then
                Grd.RowVisible(lLastRowGroup(i)) = True
                If bRowForTotals Then
                  Grd.RowVisible(lLastRowGroup(i) + 1) = True
                End If
              End If
              Grd.RowFilterHide(lLastRowGroup(i)) = False
              If bRowForTotals Then
                Grd.RowFilterHide(lLastRowGroup(i) + 1) = False
              End If
            End If
          Next
        End If
      
        lLastRowGroup(nGroupIndex) = lRow
        bVisible = False
      End If
    
    ElseIf Not Grd.RowIsGroup(lRow) Then
    
      If Not Grd.RowFilterHide(lRow) Then
        bVisible = True
      End If
    End If
    
    lRow = lRow + 1
  Loop

  If bVisible Then
    For i = 1 To iGroupsCount
      If lLastRowGroup(i) > 0 Then
        If Not Grd.RowGroupHide(lLastRowGroup(i)) Then
          Grd.RowVisible(lLastRowGroup(i)) = True
          If bRowForTotals Then
            Grd.RowVisible(lLastRowGroup(i) + 1) = True
          End If
        End If
        Grd.RowFilterHide(lLastRowGroup(i)) = False
        If bRowForTotals Then
          Grd.RowFilterHide(lLastRowGroup(i) + 1) = False
        End If
      End If
    Next
  End If
End Sub

Private Function pGetGroupsCount(ByRef Grd As Object) As Long
  Dim iGroupsCount As Long

  With Grd.Groups
    If .Count Then
      
      If .Item(.Count).IsSortCol Then
        iGroupsCount = .Count - 1
      Else
        iGroupsCount = .Count
      End If
    
    Else
      iGroupsCount = 0
    End If
  End With
  
  pGetGroupsCount = iGroupsCount

End Function

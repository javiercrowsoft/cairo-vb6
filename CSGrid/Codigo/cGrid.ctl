VERSION 5.00
Object = "{E82A759A-7510-4F56-B239-9C0B78CF437B}#1.0#0"; "CSImageList.ocx"
Begin VB.UserControl cGrid 
   ClientHeight    =   3600
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   4800
   ControlContainer=   -1  'True
   ScaleHeight     =   3600
   ScaleWidth      =   4800
   ToolboxBitmap   =   "cGrid.ctx":0000
   Begin CSImageList.cImageList ImgGroup 
      Left            =   540
      Top             =   1080
      _ExtentX        =   953
      _ExtentY        =   953
      Size            =   8460
      Images          =   "cGrid.ctx":00FA
      KeyCount        =   9
      Keys            =   "ÿÿÿÿÿÿÿÿ"
   End
   Begin VB.PictureBox picImage 
      AutoRedraw      =   -1  'True
      AutoSize        =   -1  'True
      BorderStyle     =   0  'None
      Height          =   1920
      Left            =   1980
      ScaleHeight     =   1920
      ScaleWidth      =   1920
      TabIndex        =   0
      TabStop         =   0   'False
      Top             =   900
      Visible         =   0   'False
      Width           =   1920
   End
   Begin VB.Menu mnuPopMain 
      Caption         =   "pop"
      Begin VB.Menu mnuGroup 
         Caption         =   "&Grupos..."
      End
      Begin VB.Menu mnuFormulas 
         Caption         =   "&Formulas..."
      End
      Begin VB.Menu mnuFormats 
         Caption         =   "F&ormatos Condicionales..."
      End
      Begin VB.Menu mnuFilters 
         Caption         =   "F&iltros..."
      End
      Begin VB.Menu mnuHideCols 
         Caption         =   "Ocultar/Mostrar &Columnas..."
      End
      Begin VB.Menu mnuSep 
         Caption         =   "-"
      End
      Begin VB.Menu mnuAutoWidthCol 
         Caption         =   "&Ajustar el Ancho de las Columnas"
      End
   End
End
Attribute VB_Name = "cGrid"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Attribute VB_Description = "vbAccelerator Grid Control"
Option Explicit

' ======================================================================================
' Name:     vbAccelerator S-Grid Control
' Author:   Steve McMahon (steve@vbaccelerator.com)
' Date:     22 December 1998
'
' Requires: SSUBTMR.DLL
'           cScrollBars.cls
'           cShellSort.cls
'           mGDI.bas
'           HeaderControl.ctl
'
' Copyright © 1998-1999 Steve McMahon for vbAccelerator
' --------------------------------------------------------------------------------------
' Visit vbAccelerator - advanced free source code for VB programmers
' http://vbaccelerator.com
' -------------------------------------------------------------7------------------------
'
' A serious VB grid control.  Can be used to replace the ListView and MSFlexGrid, and
' can emulate the Outlook message list view.
'
' Features:
'
'  * Drag-drop columns
'  * Visible or invisible columns
'  * Row height can be set independently for each row
'  * MS Common Controls or vbAccelerator ImageList support
'  * Up to two icons per cell (e.g. a check box and a standard icon)
'  * Indent text within any cell
'  * Many cell text formatting options including multi-line text
'  * Independently set BackColor,ForeColor and Font for each cell
'  * Show/Hide rows to allow filtering options
'  * Show/Hide columns
'  * Scroll bars implemented using true API scroll bars, and support flat/encarta style
'  * Up to 2 billion rows and columns (although practically about 20,000 is the limit)
'  * Full row sorting by up to three columns at once, allows sorting by icon, text,
'    date/time or number.
'  * Tile bitmaps into the grid's background
'  * Autosize columns
'
' Updated 19/10/99
'   * 1) Added hWnd() property (Igor Tur)
'   * 2) Flat Headers (SPM)
'   * 3) Header icons now works when no text set (Igor Tur)
'   * 4) ClearSelection method
'   * 5) EnsureVisible method
'   * 6) Prevented scroll bar edges from being visible in a new grid (see UserControl_Show)
'   * 7) Clear RowTextColumn when columns are removed (Rhys Nicholls)
'   * 8) HighlightForeColor and HighlightBackColor Properties (Michael Karathanasis, Igor Tur)
'   * 9) Make sure all header items are persisted (Ricardo Taborda dos Reis)
'   * 10) Allow setting of HeaderHeight (Andreas Claesson)
'   * 11) First column didn't resize correctly when dbl click header (Cuong Nguyen)
'   * 12) GPF when add column with rows present in grid (Marc Scherwinski)
'   * 13) ColumnWidthChanged event (Brian Beatty)
'   * 14) Ensure cells ungray themselves when enable is set back to true, don't draw
'         focus rect when disabled (Ricardo Taborda dos Reis)
'   * 15)
'
'
' FREE SOURCE CODE - ENJOY!
' ======================================================================================

Private Const C_Module = "cGrid"

Private Const C_TOTAL_COLUMN = -1111
Private Const C_TOTAL_COLUMN_EX = -1112

Public Enum ECGScrollBarStyles
    ecgSbrRegular = EFSStyleConstants.efsRegular
    ecgSbrEncarta = EFSStyleConstants.efsEncarta
    ecgSbrFlat = EFSStyleConstants.efsFlat
End Enum

Public Enum ECGHdrTextAlignFlags
   ecgHdrTextALignLeft = 0 ' EHdrTextAlign.HdrTextALignLeft
   ecgHdrTextALignCentre = 1 ' EHdrTextAlign.HdrTextALignCentre
   ecgHdrTextALignRight = 2 ' EHdrTextAlign.HdrTextALignRight
End Enum

Public Enum ECGTextAlignFlags
   DT_TOP = &H0&
   DT_LEFT = &H0&
   DT_CENTER = &H1&
   DT_RIGHT = &H2&
   DT_VCENTER = &H4&
   DT_BOTTOM = &H8&
   DT_WORDBREAK = &H10&
   DT_SINGLELINE = &H20&
   DT_EXPANDTABS = &H40&
   DT_TABSTOP = &H80&
   DT_NOCLIP = &H100&
   DT_EXTERNALLEADING = &H200&
   DT_CALCRECT = &H400&
   DT_NOPREFIX = &H800&
   DT_INTERNAL = &H1000&
'#if(WINVER >= =&H0400)
   DT_EDITCONTROL = &H2000&
   DT_PATH_ELLIPSIS = &H4000&
   DT_END_ELLIPSIS = &H8000&
   DT_MODIFYSTRING = &H10000
   DT_RTLREADING = &H20000
   DT_WORD_ELLIPSIS = &H40000
End Enum

' The grid:
Private m_tvCells() As tGridCell
Private m_tDefaultCell As tGridCell
Private m_vIRow() As Long

' Row and columns and associated info:
Private m_iCols As Long
Private m_iRows As Long
Private m_tvRows() As tRowPosition
Private Type tColPosition
   lWidth As Long
   lStartX As Long
   lCellColIndex As Long
   bVisible As Boolean
   bHidden As Boolean
   bFixed As Boolean
   bRowTextCol As Long
   sKey As String
   sTag As String
   bIncludeInSelect As Boolean
   lHeadercolIndex As Long
   sHeader As String
   iIconIndex As Long
   eTextAlign As ECGHdrTextAlignFlags
   sFmtString As String
   bImageOnRight As Boolean
   bEditOnClick As Boolean
   eSortType As cShellSortTypeConstants
   eSortOrder As cShellSortOrderCOnstants
   lOriginalColIndex As Long
End Type
Private m_tCols() As tColPosition

' Grouping of cells:
Private Type tGroupCells
   iGroupNum As Long
   iRow As Long
   iCol As Long
End Type
Private m_tGroupCells() As tGroupCells

' Sorting:
Private m_cSort As New cShellSortTGridCells

' Selection optimisations for not multi-select:
Private m_iSelRow As Long
Private m_iSelCol As Long
Private m_iLastSelRow As Long
Private m_iLastSelCol As Long

' Defaults:
Private m_lDefaultRowHeight As Long
Private m_lDefaultColumnWidth As Long

' Display items:
Private m_Fnt() As StdFont
Private m_hFnt() As Long
Private m_iFontCount As Long
' Drawing area:
Private m_lAvailWidth As Long
Private m_lAvailheight As Long
Private m_lGridWidth As Long
Private m_lGridHeight As Long
Private m_lStartX As Long
Private m_lStartY As Long
' Memory DC for flicker-free (1 row only) - also implements clipping
Private m_hDC As Long
Private m_hBmp As Long
Private m_hBmpOld As Long
Private m_lHeight As Long
Private m_lMaxRowHeight As Long
Private m_hFntDC As Long
Private m_hFntOldDC As Long
' Background:
Private m_bBitmap As Boolean
Private m_hDCSrc As Long
Private m_lBitmapW As Long
Private m_lBitmapH As Long
' Icons:
Private m_hIml As Long
Private m_lIconSizeX As Long
Private m_lIconSizeY As Long

' Groups
Private Const c_AuxKey = "K#"
Private m_hImlGroup  As Long
Private m_lIconSizeGroupX As Long
Private m_lIconSizeGroupY As Long
Private m_GroupRowHeight  As Long

Private m_Groups      As cGridGroups
Private m_ColFormulas As cGridColFormulas
Private m_ColFormats  As cGridColFormats
Private m_ColFilters  As cGridColFilters

' Gridlines:
Private m_bGridLines As Boolean
Private m_oGridLineColor As OLE_COLOR
' Active Colour 19/10/1999 (8)
Private m_oHighlightForeColor As OLE_COLOR
Private m_oHighlightBackColor As OLE_COLOR

' Behaviour:
Private m_bMultiSelect                As Boolean
Private m_bRowMode                    As Boolean
Private m_bInFocus                    As Boolean
Private m_hWnd                        As Long
Private m_bDirty                      As Boolean
Private m_bRedraw                     As Boolean
Private m_bUserMode                   As Boolean
Private m_bMouseDown                  As Boolean
Private m_bHeader                     As Boolean
Private m_bInEdit                     As Boolean
Private m_bEditable                   As Boolean
Private m_bEnabled                    As Boolean
Private m_bDisableIcons               As Boolean
Private m_bHighlightSelectedIcons     As Boolean
Private m_bDrawFocusRectangle         As Boolean
Private m_bNoOptimiseScroll           As Boolean
Private m_bTryToFitGroupRows          As Boolean
Private m_KeyHelp                     As Integer
Private m_KeyReturnEmulateTab         As Boolean
Private m_bEditOnClick                As Boolean

' "Row Text" Column:
Private m_iRowTextCol         As Long
Private m_lRowTextStartCol    As Long
Private m_bHasRowText         As Boolean

' Search Column:
Private m_iSearchCol          As Long
Private m_sSearchString       As String

' Scroll bars:
Private WithEvents m_cScroll    As cScrollBars
Attribute m_cScroll.VB_VarHelpID = -1
Private m_eScrollStyle          As EFSStyleConstants
Private m_bAllowVert            As Boolean
Private m_bAllowHorz            As Boolean

' Sort
Private m_bAutomaticSort        As Boolean

' Header:
Private WithEvents m_cHeader As cHeaderControl
Attribute m_cHeader.VB_VarHelpID = -1
Private m_cFlatHeader As cFlatHeader
Private m_bHeaderFlat As Boolean

' Virtual Grid:
'Private m_bIsVirtual As Boolean
'Private m_bInVirtualRequest As Boolean

' Odd Color
Private m_RowOddColor           As OLE_COLOR

Public Enum ECGBorderStyle
   ecgBorderStyleNone = 0
   ecgBorderStyle3d = 1
   ecgBorderStyle3dThin = 2
End Enum
Private m_eBorderStyle As ECGBorderStyle

Public Enum ECGSerialiseTypes
   ecgSerialiseSGRID = 0
   ecgSerialiseSGRIDLayout = 1
   ecgSerialiseTextTabNewLine = 2
   ecgSerialiseCSV = 3
End Enum

Private m_bDontRaiseEvent As Boolean ' Para evitar que se disparen eventos en el ClearEx

Public Event ColumnClick(ByVal lCol As Long)
Attribute ColumnClick.VB_Description = "Raised when the user clicks a column."
Public Event ColumnWidthStartChange(ByVal lCol As Long, ByVal lWidth As Long, ByRef bCancel As Boolean)
Attribute ColumnWidthStartChange.VB_Description = "Raised when the user is about to start changing the width of a column."
Public Event ColumnWidthChanging(ByVal lCol As Long, ByVal lWidth As Long, ByRef bCancel As Boolean)
Attribute ColumnWidthChanging.VB_Description = "Raised whilst a column's width is being changed."
Public Event ColumnWidthChanged(ByVal lCol As Long, ByVal lWidth As Long, ByRef bCancel As Boolean)
Public Event HeaderRightClick(ByVal x As Single, ByVal y As Single)
Attribute HeaderRightClick.VB_Description = "Raised when the user right clicks on the grid's header."
Public Event SelectionChange(ByVal lRow As Long, ByVal lCol As Long)
Attribute SelectionChange.VB_Description = "Raised when the user changes the selected cell."
Public Event SelectionRowChange(ByVal lRow As Long, ByVal lCol As Long)
Public Event SelectionColChange(ByVal lRow As Long, ByVal lCol As Long)

' Edicion
Public Event RequestEdit(ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer, ByRef bCancel As Boolean)
Attribute RequestEdit.VB_Description = "Raised when the grid has the Editable property set to True and the user's actions request editing of the current cell."
Public Event CancelEdit()

Public Event KeyDown(KeyCode As Integer, Shift As Integer, bDoDefault As Boolean)
Attribute KeyDown.VB_Description = "Raised when a key is pressed in the control."
Public Event KeyPress(KeyAscii As Integer)
Attribute KeyPress.VB_Description = "Raised after the KeyDown event when the key press has been converted to an ASCII code."
Public Event KeyUp(KeyCode As Integer, Shift As Integer)
Attribute KeyUp.VB_Description = "Raised when a key is released on the grid."
Public Event MouseDown(Button As Integer, Shift As Integer, x As Single, y As Single, bDoDefault As Boolean)
Attribute MouseDown.VB_Description = "Raised when the a mouse button is pressed over the control."
Public Event MouseMove(Button As Integer, Shift As Integer, x As Single, y As Single)
Attribute MouseMove.VB_Description = "Raised when the mouse moves over the control, or when the mouse moves anywhere and a mouse button has been pressed over the control."
Public Event MouseUp(Button As Integer, Shift As Integer, x As Single, y As Single)
Attribute MouseUp.VB_Description = "Raised when a mouse button is released after having been pressed over the control."
Public Event DblClick(ByVal lRow As Long, ByVal lCol As Long)
Attribute DblClick.VB_Description = "Raised when the user double clicks on the grid."
Public Event RequestRow(ByVal lRow As Long, ByVal sKey As String, ByVal bVisible As Boolean, ByVal lHeight As Long, ByVal bGroupRow As Boolean, ByRef bNoMoreRows As Boolean)
Attribute RequestRow.VB_Description = "Raised when the grid is in Virtual mode and the grid has been scrolled to expose a new row.  Set bNoMoreRows to True to indicate all rows have been added."
Public Event RequestRowData(ByVal lRow As Long)
Attribute RequestRowData.VB_Description = "Raised in virtual mode when a new row has been added in response to RequestRow. Respond by filling in the cells for that row."
Public Event ColumnOrderChanged()
Public Event ShowHelp(ByVal lRow As Long, ByVal lCol As Long)
Public Event RequestNewRow()
Public Event DeleteRow(ByVal lRow As Long, ByRef bCancel As Boolean)
Public Event RowWasDeleted(ByVal lRow As Long)
Public Event DeleteCellValue(ByVal lRow As Long, ByVal lCol As Long)
Public Event ScrollChange()
Public Event ShowPopMenu(ByRef Cancel As Boolean)

Public Property Get AutomaticSort() As Boolean
  AutomaticSort = m_bAutomaticSort
End Property

Public Property Let AutomaticSort(ByVal rhs As Boolean)
  m_bAutomaticSort = rhs
End Property

Public Property Get Groups() As cGridGroups
  Set Groups = m_Groups
End Property

Public Property Get Formulas() As cGridColFormulas
  Set Formulas = m_ColFormulas
End Property

Public Property Get Formats() As cGridColFormats
  Set Formats = m_ColFormats
End Property

Public Property Get Filters() As cGridColFilters
  Set Filters = m_ColFilters
End Property

Public Property Get KeyReturnEmulateTab() As Boolean
  KeyReturnEmulateTab = m_KeyReturnEmulateTab
End Property
Public Property Let KeyReturnEmulateTab(ByVal rhs As Boolean)
  m_KeyReturnEmulateTab = rhs
  PropertyChanged "KeyReturnEmulateTab"
End Property
Public Property Get KeyHelp() As Integer
  KeyHelp = m_KeyHelp
End Property
Public Property Let KeyHelp(ByVal rhs As Integer)
  m_KeyHelp = rhs
  PropertyChanged "KeyHelp"
End Property
Public Property Get HighlightSelectedIcons() As Boolean
Attribute HighlightSelectedIcons.VB_Description = "Gets/sets whether icons in selected cells will be highlighted using the selection colour."
   HighlightSelectedIcons = m_bHighlightSelectedIcons
End Property
Public Property Let HighlightSelectedIcons(ByVal bHighlight As Boolean)
   m_bHighlightSelectedIcons = bHighlight
   PropertyChanged "HighlightSelectedIcons"
End Property
Public Property Get DrawFocusRectangle() As Boolean
Attribute DrawFocusRectangle.VB_Description = "Gets/sets whether a focus rectangle (dotted line around the selection) will be shown."
   DrawFocusRectangle = m_bDrawFocusRectangle
End Property
Public Property Let DrawFocusRectangle(ByVal bDraw As Boolean)
   m_bDrawFocusRectangle = bDraw
   PropertyChanged "DrawFocusRectangle"
End Property

Public Property Get EditOnClick() As Boolean
   EditOnClick = m_bEditOnClick
End Property

Public Property Let EditOnClick(ByVal rhs As Boolean)
   m_bEditOnClick = rhs
   PropertyChanged "EditOnClick"
End Property


Public Property Get Enabled() As Boolean
Attribute Enabled.VB_Description = "Gets/sets whether the grid is enabled or not.  Note the grid can still be read when it is disabled, but cannot be selected or edited."
   Enabled = m_bEnabled
End Property

Public Property Let Enabled(ByVal bState As Boolean)
Dim iRow As Long, iCol As Long
   m_bEnabled = bState
   'm_cHeader.Enabled = bState
   If UserControl.Ambient.UserMode Then
      m_bDirty = True
      For iRow = 1 To m_iRows
         For iCol = 1 To m_iCols
            m_tvCells(iCol, m_vIRow(iRow)).bDirtyFlag = True
         Next iCol
      Next iRow
      Draw
      ' 19/10/1999 (14):
      UserControl_Paint
   End If
   PropertyChanged "Enabled"
End Property

Public Property Get DisableIcons() As Boolean
Attribute DisableIcons.VB_Description = "Gets/sets whether icons are drawn disabled when the control is disabled."
   DisableIcons = m_bDisableIcons
End Property
Public Property Let DisableIcons(ByVal bState As Boolean)
   m_bDisableIcons = bState
   If Not (m_bEnabled) Then
      m_bDirty = True
      Draw
   End If
   PropertyChanged "DisableIcons"
End Property

Public Property Get Editable() As Boolean
Attribute Editable.VB_Description = "Gets/sets whether the grid will be editable (i.e. raise RequestEdit events)."
   Editable = m_bEditable
End Property
Public Property Let Editable(ByVal bState As Boolean)
   m_bEditable = bState
   PropertyChanged "Editable"
End Property

Public Property Get SortObject() As cShellSortTGridCells
Attribute SortObject.VB_Description = "Returns a reference to the sort object where grid sorting options can be specified."
   Set SortObject = m_cSort
End Property

Public Property Get HasRowText() As Boolean
  HasRowText = m_bHasRowText
End Property

Public Property Get RowOddColor() As OLE_COLOR
   m_RowOddColor = m_RowOddColor
End Property

Public Property Let RowOddColor(ByRef rhs As OLE_COLOR)
   m_RowOddColor = rhs
   PropertyChanged "RowOddColor"
End Property

Public Sub Sort()
Attribute Sort.VB_Description = "Sorts the grid data according to the options set up in the SortObject."
Dim sKey As String
Dim i As Long
Dim bS As Boolean
   If m_iRows > 0 And m_iCols > 0 Then
      If (m_iSelRow > 0) And (m_iSelRow <= m_iRows) Then
         sKey = m_tvRows(m_vIRow(m_iSelRow)).sKey
         m_tvRows(m_vIRow(m_iSelRow)).sKey = "!SELECTEDROW!"
      End If
      m_cSort.SortItems2 m_vIRow(), m_tvCells()
      If (m_iSelRow > 0) Then
         For i = 1 To m_iRows
            If (m_tvRows(m_vIRow(i)).sKey = "!SELECTEDROW!") Then
               m_tvRows(m_vIRow(i)).sKey = sKey
               m_iSelRow = i
               Exit For
            End If
         Next i
      End If
      m_tvRows(m_vIRow(1)).lStartY = 0
      RowVisible(1) = RowVisible(1)
      bS = m_bNoOptimiseScroll
      m_bNoOptimiseScroll = True
      m_bDirty = True
      If (m_iSelRow > 0) And (m_iSelCol > 0) Then
         If (m_iSelRow <= m_iRows) And (m_iSelCol <= m_iCols) Then
            pbEnsureVisible m_iSelRow, m_iSelCol
         Else
            m_iSelRow = 1: m_iSelCol = 1
         End If
      End If
      Draw
      m_bNoOptimiseScroll = bS
   Else
      ' That makes the sort somewhat quicker :)
   End If
End Sub

Public Property Get EvaluateTextHeight( _
      ByVal lRow As Long, _
      ByVal lCol As Long _
   ) As Long
  EvaluateTextHeight = pEvaluateTextHeight(lRow, lCol, False)
End Property

Private Function pEvaluateTextHeight( _
      ByVal lRow As Long, _
      ByVal lCol As Long, _
      ByVal bForFont As Boolean _
   ) As Long
Dim hFntOld As Long
Dim tR As RECT
Dim sCopy As String
Dim iCol As Long, lCCol As Long

  If lCol > m_iCols Or lRow > m_iRows Then Exit Function

   ' Ensure correct font:
   If (m_tvCells(lCol, m_vIRow(lRow)).IFntIndex <> 0) Then
      hFntOld = SelectObject(m_hDC, m_hFnt(m_tvCells(lCol, m_vIRow(lRow)).IFntIndex))
   End If
   
   ' Draw the text, calculating rect:
   If (Not IsMissing(m_tvCells(lCol, m_vIRow(lRow)).sText)) Or bForFont Then
      If Not bForFont Then
        sCopy = m_tvCells(lCol, m_vIRow(lRow)).sText
        For iCol = 1 To m_iCols
           If (m_tCols(iCol).lCellColIndex = lCol) Then
              lCCol = iCol
              Exit For
           End If
        Next iCol
      Else
        sCopy = "a"
      End If
      If (LenB(m_tCols(lCCol).sFmtString)) Then
         sCopy = Format$(sCopy, m_tCols(lCCol).sFmtString)
      End If
      tR.Right = m_tCols(lCCol).lWidth - 4 - 2 * Abs(m_bGridLines)
      tR.Right = tR.Right - m_tvCells(lCol, m_vIRow(lRow)).lIndent
      If (m_tvCells(lCol, m_vIRow(lRow)).iIconIndex >= 0) Then
         tR.Right = tR.Right - m_lIconSizeX - 2
      End If
      If (m_tvCells(lCol, m_vIRow(lRow)).lExtraIconIndex >= 0) Then
         tR.Right = tR.Right - m_lIconSizeX - 2
      End If
      If (m_tvCells(lCol, m_vIRow(lRow)).lGroupIconIndex >= 0) Then
         tR.Right = tR.Right - m_lIconSizeGroupX - 2
      End If
      DrawText m_hDC, sCopy & vbNullChar, -1, tR, m_tvCells(lCol, m_vIRow(lRow)).eTextFlags Or DT_CALCRECT
      pEvaluateTextHeight = tR.Bottom - tR.Top
   Else
      ' don't need to do anything:
   End If
   
   If (hFntOld <> 0) Then
      SelectObject m_hDC, hFntOld
      hFntOld = 0
   End If
      
End Function
Public Property Get EvaluateTextWidth( _
      ByVal lRow As Long, _
      ByVal lCol As Long, _
      Optional ByVal bForceNoModify As Boolean = True _
   ) As Long
Attribute EvaluateTextWidth.VB_Description = "Determines the ideal width required to fully display text in a cell."
   EvaluateTextWidth = plEvaluateTextWidth(lRow, lCol, bForceNoModify, 0)
End Property
Private Property Get plEvaluateTextWidth( _
      ByVal lRow As Long, _
      ByVal lCol As Long, _
      ByVal bForceNoModify As Boolean, _
      ByVal lMaxWidth As Long _
   ) As Long
Dim hFntOld As Long
Dim tR As RECT
Dim sCopy As String
Dim sOrig As String
Dim iCol As Long
Dim lCCol As Long
Dim eFlags As ECGTextAlignFlags
Dim lLastRight As Long

   ' Ensure correct font:
   If (m_tvCells(lCol, m_vIRow(lRow)).IFntIndex <> 0) Then
      hFntOld = SelectObject(m_hDC, m_hFnt(m_tvCells(lCol, m_vIRow(lRow)).IFntIndex))
   End If
   
   ' Find the index of lCol in the columns array:
   For iCol = 1 To m_iCols
      If (m_tCols(iCol).lCellColIndex = lCol) Then
         lCCol = iCol
         Exit For
      End If
   Next iCol
   
   ' Evaluate the text in the cell:
   If Not (IsMissing(m_tvCells(lCol, m_vIRow(lRow)).sText)) Then
      sCopy = m_tvCells(lCol, m_vIRow(lRow)).sText
   End If
   If (LenB(m_tCols(lCCol).sFmtString)) Then
      sCopy = Format$(sCopy, m_tCols(lCCol).sFmtString)
   End If
   eFlags = m_tvCells(lCol, m_vIRow(lRow)).eTextFlags Or DT_CALCRECT
   
   ' For multi line we specify the right so we get a height:
   If (eFlags And DT_WORDBREAK) = DT_WORDBREAK Then
      tR.Right = m_tCols(lCCol).lWidth
      If (lMaxWidth > tR.Right) Then
         tR.Right = lMaxWidth
      End If
   End If
   If (bForceNoModify) Then
      eFlags = eFlags And Not (DT_WORD_ELLIPSIS Or DT_PATH_ELLIPSIS Or DT_MODIFYSTRING Or DT_END_ELLIPSIS)
   End If
   
   sOrig = sCopy
   DrawText m_hDC, sCopy & vbNullChar, -1, tR, eFlags
   If (eFlags And DT_WORDBREAK) = DT_WORDBREAK Then
      Do While (tR.Bottom > m_tvRows(m_vIRow(lRow)).lHeight)
         sCopy = sOrig
         ' Extend in blocks of 16 until we fit...
         tR.Right = tR.Right + 16
         lLastRight = tR.Right
         DrawText m_hDC, sCopy & vbNullChar, -1, tR, eFlags
         tR.Right = lLastRight
      Loop
   End If
   
   plEvaluateTextWidth = tR.Right - tR.Left
   
   If (hFntOld <> 0) Then
      SelectObject m_hDC, hFntOld
      hFntOld = 0
   End If
   
End Property
Private Function pEvaluateHeaderWidth(ByVal sCopy As String) As Long
   Dim tR As RECT
   Dim eFlags As ECGTextAlignFlags
   eFlags = DT_CALCRECT
   DrawText UserControl.hdc, sCopy & vbNullChar, -1, tR, eFlags
   pEvaluateHeaderWidth = tR.Right - tR.Left + 18
End Function
Public Property Get RowTextStartColumn() As Long
Attribute RowTextStartColumn.VB_Description = "Gets/sets the column that text in the RowText column will start drawing at."
Attribute RowTextStartColumn.VB_MemberFlags = "400"
   RowTextStartColumn = m_lRowTextStartCol
End Property
Public Property Let RowTextStartColumn(ByVal lColumn As Long)
   m_lRowTextStartCol = lColumn
End Property
Public Property Let DefaultRowHeight(ByVal lHeight As Long)
Attribute DefaultRowHeight.VB_Description = "Gets/sets the height which will be used as a default for rows in the grid."
   m_lDefaultRowHeight = lHeight
   PropertyChanged "DefaultRowHeight"
End Property
Public Property Get DefaultRowHeight() As Long
   DefaultRowHeight = m_lDefaultRowHeight
End Property
Public Property Get Redraw() As Boolean
Attribute Redraw.VB_Description = "Gets/sets whether the grid is redrawn in response to changes.  Set to False whilst setting many properties to increase speed.  Setting to True after it has been False forces a re-draw of the control."
Attribute Redraw.VB_ProcData.VB_Invoke_Property = ";Behavior"
   Redraw = m_bRedraw
End Property
Public Property Let Redraw(ByVal bState As Boolean)
   m_bRedraw = bState
   If (UserControl.Ambient.UserMode) Then
      m_bDirty = True
      Draw
   End If
   PropertyChanged "Redraw"
End Property
Public Property Get SelectedRow() As Long
Attribute SelectedRow.VB_Description = "Gets the selected row.  In multi-select mode, this is the most recently selected row."
Attribute SelectedRow.VB_MemberFlags = "400"
   SelectedRow = m_iSelRow
End Property
Public Property Let SelectedRow(ByVal lRow As Long)
Dim iCol As Long
Dim iRow As Long
   If (m_iSelCol = 0) Then
      'm_iSelCol = plGetFirstVisibleColumn()
   End If
   If (lRow > 0) And (lRow <= m_iRows) Then
      m_iSelRow = lRow
      If (m_bMultiSelect) Then
         For iRow = 1 To m_iRows
            For iCol = 1 To m_iCols
               If (m_bRowMode) Then
                  m_tvCells(iCol, m_vIRow(iRow)).bDirtyFlag = (m_tvCells(iCol, m_vIRow(iRow)).bSelected <> (iRow = m_iSelRow))
                  m_tvCells(iCol, m_vIRow(iRow)).bSelected = (iRow = m_iSelRow)
               Else
                  m_tvCells(iCol, m_vIRow(iRow)).bDirtyFlag = (m_tvCells(iCol, m_vIRow(iRow)).bSelected) <> ((iCol = m_iSelCol) And (iRow = m_iSelRow))
                  m_tvCells(iCol, m_vIRow(iRow)).bSelected = ((iCol = m_iSelCol) And (iRow = m_iSelRow))
               End If
            Next iCol
         Next iRow
      Else
         pSingleModeSelect
      End If
      If Not (pbEnsureVisible(m_iSelRow, m_iSelCol)) Then
         Draw
      End If
   Else
      'Err.Raise 9, App.EXEName & ".cGrid"
   End If
End Property
Public Property Get SelectedCol() As Long
Attribute SelectedCol.VB_Description = "Gets the selected column.  In multi-select mode, this is the most recently selected column."
Attribute SelectedCol.VB_MemberFlags = "400"
   SelectedCol = m_iSelCol
End Property
Public Property Let SelectedCol(ByVal lCol As Long)
  If (lCol > 0) And (lCol <= m_iCols) Then
    m_iSelCol = lCol
    m_tvCells(m_iSelCol, m_vIRow(m_iSelRow)).bSelected = True
    m_tvCells(m_iSelCol, m_vIRow(m_iSelRow)).bDirtyFlag = True
    If Not (pbEnsureVisible(m_iSelRow, m_iSelCol)) Then
      Draw
    End If
  ElseIf lCol = 0 Then
    For lCol = 1 To m_iCols
      m_tvCells(lCol, m_vIRow(m_iSelRow)).bSelected = False
      m_tvCells(lCol, m_vIRow(m_iSelRow)).bDirtyFlag = False
    Next
    m_iSelCol = 0
    If Not (pbEnsureVisible(m_iSelRow, m_iSelCol)) Then
       Draw
    End If
  Else
    'Err.Raise 9, App.EXEName & ".cGrid"
  End If
End Property
Public Property Let ScrollBarStyle(ByVal eStyle As ECGScrollBarStyles)
Attribute ScrollBarStyle.VB_Description = "Gets/sets the style in which scroll bars are drawn.  Flat or Encarta style scroll bars are only supported in systems with COMCTL32.DLL version 4.72 or higher."
   m_eScrollStyle = eStyle
   If Not (m_cScroll Is Nothing) Then
      m_cScroll.Style = eStyle
   End If
   PropertyChanged "ScrollBarStyle"
End Property
Public Property Get ScrollBarStyle() As ECGScrollBarStyles
   ScrollBarStyle = m_eScrollStyle
End Property
Public Property Get CellFormattedText(ByVal lRow As Long, ByVal lCol As Long) As String
Attribute CellFormattedText.VB_Description = "Gets the text of a cell with any formatting string applicable to the cell's column applied."
Dim iCCol As Long
Dim iCol As Long
   For iCol = 1 To m_iCols
      If (m_tCols(iCol).lCellColIndex = lCol) Then
         iCCol = iCol
         Exit For
      End If
   Next iCol
   If (LenB(m_tCols(iCCol).sFmtString)) Then
      CellFormattedText = Format$(m_tvCells(lCol, m_vIRow(lRow)).sText, m_tCols(iCCol).sFmtString)
   Else
      CellFormattedText = m_tvCells(lCol, m_vIRow(lRow)).sText
   End If
End Property
Public Property Get CellText(ByVal lRow As Long, ByVal lCol As Long) As Variant
Attribute CellText.VB_Description = "Gets/sets the text associated with a cell.  This property is a variant allowing you to store Numbers and Dates as well.  In columns which are not visible, it could also be used to store objects. "
  If pbValid(lRow, lCol) Then
    If IsMissing(m_tvCells(lCol, m_vIRow(lRow)).sText) Then
      CellText = vbNullString
    Else
      CellText = m_tvCells(lCol, m_vIRow(lRow)).sText
    End If
  End If
End Property

Public Property Let CellText(ByVal lRow As Long, ByVal lCol As Long, ByVal sText As Variant)
   If pbValid(lRow, lCol) Then
      m_tvCells(lCol, m_vIRow(lRow)).sText = sText
      m_tvCells(lCol, m_vIRow(lRow)).bDirtyFlag = True
      Draw
   End If
End Property

Friend Property Get CellTextFormula(ByVal lRow As Long, ByVal lCol As Long) As String
  If pbValid(lRow, lCol) Then
    CellTextFormula = m_tvCells(lCol, m_vIRow(lRow)).sTextFormulas
  End If
End Property

Public Property Let CellTextFormula(ByVal lRow As Long, ByVal lCol As Long, ByVal sText As String)
   If pbValid(lRow, lCol) Then
      m_tvCells(lCol, m_vIRow(lRow)).sTextFormulas = sText
   End If
End Property

Public Property Get CellTextAlign(ByVal lRow As Long, ByVal lCol As Long) As ECGTextAlignFlags
Attribute CellTextAlign.VB_Description = "Gets/sets the alignment and formatting properties used to draw cell text."
   If pbValid(lRow, lCol) Then
      CellTextAlign = m_tvCells(lCol, m_vIRow(lRow)).eTextFlags
   End If
End Property
Public Property Let CellTextAlign(ByVal lRow As Long, ByVal lCol As Long, ByVal eAlign As ECGTextAlignFlags)
   If pbValid(lRow, lCol) Then
      m_tvCells(lCol, m_vIRow(lRow)).eTextFlags = eAlign Or DT_NOPREFIX And Not DT_CALCRECT
      m_tvCells(lCol, m_vIRow(lRow)).bDirtyFlag = True
      Draw
   End If
End Property

Public Property Get CellIndent(ByVal lRow As Long, ByVal lCol As Long) As Long
Attribute CellIndent.VB_Description = "Gets/sets the horizontal indentation of a cell from the cell's border."
   If pbValid(lRow, lCol) Then
      CellIndent = m_tvCells(lCol, m_vIRow(lRow)).lIndent
   End If
End Property
Public Property Let CellIndent(ByVal lRow As Long, ByVal lCol As Long, ByVal lIndent As Long)
   If pbValid(lRow, lCol) Then
      m_tvCells(lCol, m_vIRow(lRow)).lIndent = lIndent
      m_tvCells(lCol, m_vIRow(lRow)).bDirtyFlag = True
      Draw
   End If
End Property
Public Property Get CellExtraIcon(ByVal lRow As Long, ByVal lCol As Long) As Long
Attribute CellExtraIcon.VB_Description = "Gets/sets the extra icon for a cell.  This icon will always appear in the leftmost position for the cell.  Set CellExtraIcon to -1 to remove an icon.  CellExtraIcons represent ImageList icon indexes and run from 0 to Count-1."
   If pbValid(lRow, lCol) Then
      CellExtraIcon = m_tvCells(lCol, m_vIRow(lRow)).lExtraIconIndex
   End If
End Property
Public Property Let CellExtraIcon(ByVal lRow As Long, ByVal lCol As Long, ByVal lIconIndex As Long)
   If pbValid(lRow, lCol) Then
      m_tvCells(lCol, m_vIRow(lRow)).lExtraIconIndex = lIconIndex
      m_tvCells(lCol, m_vIRow(lRow)).bDirtyFlag = True
      Draw
   End If
End Property

Public Property Get CellGroupIcon(ByVal lRow As Long, ByVal lCol As Long) As Long
   If pbValid(lRow, lCol) Then
      CellGroupIcon = m_tvCells(lCol, m_vIRow(lRow)).lGroupIconIndex
   End If
End Property
Public Property Let CellGroupIcon(ByVal lRow As Long, ByVal lCol As Long, ByVal lIconIndex As Long)
   If pbValid(lRow, lCol) Then
      m_tvCells(lCol, m_vIRow(lRow)).lGroupIconIndex = lIconIndex
      m_tvCells(lCol, m_vIRow(lRow)).bDirtyFlag = True
      Draw
   End If
End Property

Public Property Get CellItemData(ByVal lRow As Long, ByVal lCol As Long) As Long
Attribute CellItemData.VB_Description = "Gets/sets a long value associated with the cell."
   If pbValid(lRow, lCol) Then
      CellItemData = m_tvCells(lCol, m_vIRow(lRow)).lItemData
   End If
End Property
Public Property Let CellItemData(ByVal lRow As Long, ByVal lCol As Long, ByVal lItemData As Long)
   If pbValid(lRow, lCol) Then
      m_tvCells(lCol, m_vIRow(lRow)).lItemData = lItemData
   End If
End Property

Public Property Get CellTag(ByVal lRow As Long, ByVal lCol As Long) As String
   If pbValid(lRow, lCol) Then
      CellTag = m_tvCells(lCol, m_vIRow(lRow)).sTag
   End If
End Property
Public Property Let CellTag(ByVal lRow As Long, ByVal lCol As Long, ByVal rhs As String)
   If pbValid(lRow, lCol) Then
      m_tvCells(lCol, m_vIRow(lRow)).sTag = rhs
   End If
End Property

Public Property Get CellSelected(ByVal lRow As Long, ByVal lCol As Long) As Boolean
Attribute CellSelected.VB_Description = "Gets/sets whether a cell is selected or not."
   If pbValid(lRow, lCol) Then
      CellSelected = m_tvCells(lCol, m_vIRow(lRow)).bSelected
   End If
End Property
Public Property Let CellSelected(ByVal lRow As Long, ByVal lCol As Long, ByVal bState As Boolean)
Dim iInitSelCol As Long
Dim iInitSelRow As Long
Dim iCol As Long
   If pbValid(lRow, lCol) Then
      ' for single select mode, bstate is ignored.
      If (m_bMultiSelect) Then
         iInitSelCol = m_iSelCol
         iInitSelRow = m_iSelRow
         m_iSelRow = lRow
         m_iSelCol = lCol
         If (m_bRowMode) Then
            For iCol = 1 To m_iCols
               m_tvCells(iCol, m_vIRow(m_iSelRow)).bDirtyFlag = (m_tvCells(iCol, m_vIRow(m_iSelRow)).bSelected <> bState)
               m_tvCells(iCol, m_vIRow(m_iSelRow)).bSelected = bState
            Next iCol
         Else
            m_tvCells(m_iSelCol, m_vIRow(m_iSelRow)).bDirtyFlag = (m_tvCells(m_iSelCol, m_vIRow(m_iSelRow)).bSelected <> bState)
            m_tvCells(m_iSelCol, m_vIRow(m_iSelRow)).bSelected = bState
         End If
      Else
         iInitSelCol = m_iSelCol
         iInitSelRow = m_iSelRow
         m_iSelRow = lRow
         m_iSelCol = lCol
         pSingleModeSelect
         If Not (pbEnsureVisible(m_iSelRow, m_iSelCol)) Then
            Draw
         End If
         If (iInitSelCol <> m_iSelCol) Or (iInitSelRow <> m_iSelRow) Then
         
            If Not m_bDontRaiseEvent Then
              RaiseEvent SelectionChange(m_iSelRow, m_iSelCol)
            End If
         End If
      End If
   End If
End Property

Public Property Get CellIcon(ByVal lRow As Long, ByVal lCol As Long) As Long
Attribute CellIcon.VB_Description = "Gets/sets the icon for a cell.  If the cell has an icon set via the CellExtraIcon property, this icon will appear after it.  Set CellIcon to -1 to remove an icon.  CellIcons represent ImageList icon indexes and run from 0 to Count-1."
   If pbValid(lRow, lCol) Then
      CellIcon = m_tvCells(lCol, m_vIRow(lRow)).iIconIndex
   End If
End Property
Public Property Let CellIcon(ByVal lRow As Long, ByVal lCol As Long, ByVal lIconIndex As Long)
   If pbValid(lRow, lCol) Then
      m_tvCells(lCol, m_vIRow(lRow)).iIconIndex = lIconIndex
      m_tvCells(lCol, m_vIRow(lRow)).bDirtyFlag = True
      Draw
   End If
End Property
Public Property Get CellBackColor(ByVal lRow As Long, ByVal lCol As Long) As OLE_COLOR
Attribute CellBackColor.VB_Description = "Gets/sets the background colour for a cell.  Set to -1 to make the cell transparent."
   If pbValid(lRow, lCol) Then
      CellBackColor = m_tvCells(lCol, m_vIRow(lRow)).OBackColor
   End If
End Property
Public Property Let CellBackColor(ByVal lRow As Long, ByVal lCol As Long, ByVal oColor As OLE_COLOR)
   If pbValid(lRow, lCol) Then
      m_tvCells(lCol, m_vIRow(lRow)).OBackColor = oColor
      m_tvCells(lCol, m_vIRow(lRow)).bDirtyFlag = True
      Draw
   End If
End Property
Public Property Get CellForeColor(ByVal lRow As Long, ByVal lCol As Long) As OLE_COLOR
Attribute CellForeColor.VB_Description = "Gets/sets the foreground colour to draw a cell in.  Set to -1 to use the default foreground colour."
   If pbValid(lRow, lCol) Then
      CellForeColor = m_tvCells(lCol, m_vIRow(lRow)).OForeColor
   End If
End Property
Public Property Let CellForeColor(ByVal lRow As Long, ByVal lCol As Long, ByVal oColor As OLE_COLOR)
   If pbValid(lRow, lCol) Then
      m_tvCells(lCol, m_vIRow(lRow)).OForeColor = oColor
      m_tvCells(lCol, m_vIRow(lRow)).bDirtyFlag = True
      Draw
   End If
End Property

Public Property Get CellConditionalFormat(ByVal lRow As Long, ByVal lCol As Long) As Variant
   If pbValid(lRow, lCol) Then
      CellConditionalFormat = m_tvCells(lCol, m_vIRow(lRow)).ConditionalFormat
   End If
End Property

Public Property Let CellConditionalFormat(ByVal lRow As Long, ByVal lCol As Long, ByVal oCondition As Variant)
   If pbValid(lRow, lCol) Then
      If IsEmpty(oCondition) Then
        m_tvCells(lCol, m_vIRow(lRow)).ConditionalFormat = Empty
      Else
        Set m_tvCells(lCol, m_vIRow(lRow)).ConditionalFormat = oCondition
      End If
      m_tvCells(lCol, m_vIRow(lRow)).bDirtyFlag = True
      Draw
   End If
End Property

Public Sub CellDefaultForeColor(ByVal lRow As Long, ByVal lCol As Long)
Attribute CellDefaultForeColor.VB_Description = "Sets a cell to use the default foreground colour (the fore colour of the control)."
   If pbValid(lRow, lCol) Then
      m_tvCells(lCol, m_vIRow(lRow)).OForeColor = CLR_NONE
      m_tvCells(lCol, m_vIRow(lRow)).bDirtyFlag = True
      Draw
   End If
End Sub
Public Sub CellDefaultBackColor(ByVal lRow As Long, ByVal lCol As Long)
Attribute CellDefaultBackColor.VB_Description = "Sets a cell to use the default background colour (transparent)."
   If pbValid(lRow, lCol) Then
      m_tvCells(lCol, m_vIRow(lRow)).OBackColor = CLR_NONE
      m_tvCells(lCol, m_vIRow(lRow)).bDirtyFlag = True
      Draw
   End If
End Sub

Public Property Get CellIFntIndex(ByVal lRow As Long, ByVal lCol As Long) As Long
   If pbValid(lRow, lCol) Then
      CellIFntIndex = m_tvCells(lCol, m_vIRow(lRow)).IFntIndex
   End If
End Property

Public Property Get CellFont(ByVal lRow As Long, ByVal lCol As Long) As StdFont
Attribute CellFont.VB_Description = "Gets/sets the font to use to draw a cell."
   If pbValid(lRow, lCol) Then
      If (m_tvCells(lCol, m_vIRow(lRow)).IFntIndex = 0) Then
         Set CellFont = UserControl.Font
      Else
         Set CellFont = m_Fnt(m_tvCells(lCol, m_vIRow(lRow)).IFntIndex)
      End If
   End If
End Property
Public Property Let CellFont(ByVal lRow As Long, ByVal lCol As Long, ByVal sFnt As StdFont)
   If pbValid(lRow, lCol) Then
      m_tvCells(lCol, m_vIRow(lRow)).IFntIndex = plAddFontIfRequired(sFnt)
      m_tvCells(lCol, m_vIRow(lRow)).bDirtyFlag = True
      Draw
   End If
End Property
Public Sub CellDefaultFont(ByVal lRow As Long, ByVal lCol As Long)
Attribute CellDefaultFont.VB_Description = "Sets a cell to use the default font."
   If pbValid(lRow, lCol) Then
      m_tvCells(lCol, m_vIRow(lRow)).IFntIndex = 0
      m_tvCells(lCol, m_vIRow(lRow)).bDirtyFlag = True
      Draw
   End If
End Sub
Public Property Get MultiSelect() As Boolean
Attribute MultiSelect.VB_Description = "Gets/sets whether multiple grid cells or rows can be selected or not."
Attribute MultiSelect.VB_ProcData.VB_Invoke_Property = ";Behavior"
   MultiSelect = m_bMultiSelect
End Property
Public Property Let MultiSelect(ByVal bState As Boolean)
Dim iCol As Long
Dim iRow As Long
   If (bState <> m_bMultiSelect) Then
      If Not (bState) Then
         For iRow = 1 To m_iRows
            For iCol = 1 To m_iCols
               If (m_bRowMode) Then
                  m_tvCells(iCol, m_vIRow(iRow)).bDirtyFlag = (m_tvCells(iCol, m_vIRow(iRow)).bSelected <> (iRow = m_iSelRow))
                  m_tvCells(iCol, m_vIRow(iRow)).bSelected = (iRow = m_iSelRow)
               Else
                  m_tvCells(iCol, m_vIRow(iRow)).bDirtyFlag = (m_tvCells(iCol, m_vIRow(iRow)).bSelected <> ((iRow = m_iSelRow) And (iCol = m_iSelCol)))
                  m_tvCells(iCol, m_vIRow(iRow)).bSelected = ((iRow = m_iSelRow) And (iCol = m_iSelCol))
               End If
            Next iCol
         Next iRow
      End If
   End If
   m_bMultiSelect = bState
   Draw
   PropertyChanged "MultiSelect"
End Property

Public Function IsRowSelected(ByVal iRow As Long) As Boolean
  Dim iCol As Long
  
  If m_bMultiSelect Then
    If m_bRowMode Then
      For iCol = 1 To m_iCols
        If m_tvCells(iCol, m_vIRow(iRow)).bSelected Then
          IsRowSelected = True
          Exit Function
        End If
      Next iCol
    Else
      IsRowSelected = m_tvCells(1, m_vIRow(iRow)).bSelected
    End If
  Else
    IsRowSelected = (iRow = m_iSelRow)
  End If
End Function

Public Property Get RowMode() As Boolean
Attribute RowMode.VB_Description = "Gets/sets whether cells can be selected in the grid (False) or rows (True)."
Attribute RowMode.VB_ProcData.VB_Invoke_Property = ";Behavior"
   RowMode = m_bRowMode
End Property
Public Property Let RowMode(ByVal bState As Boolean)
Dim iCol As Long
Dim iRow As Long
Dim bSelRow As Boolean
   m_bRowMode = bState
   If Not (m_bMultiSelect) Then
      If (m_iSelRow > 0) And (m_iSelCol > 0) Then
         For iCol = 1 To m_iCols
            m_tvCells(iCol, m_vIRow(m_iSelRow)).bDirtyFlag = True
            If (bState) Then
               m_tvCells(iCol, m_vIRow(m_iSelRow)).bSelected = True
            Else
               m_tvCells(iCol, m_vIRow(m_iSelRow)).bSelected = (iCol = m_iSelCol)
            End If
         Next iCol
      End If
   Else
      If (bState) Then
         For iRow = 1 To m_iRows
            For iCol = 1 To m_iCols
               If (m_tvCells(iCol, m_vIRow(iRow)).bSelected) Then
                  bSelRow = True
                  Exit For
               End If
            Next iCol
            If (bSelRow) Then
               For iCol = 1 To m_iCols
                  m_tvCells(iCol, m_vIRow(iRow)).bSelected = True
                  m_tvCells(iCol, m_vIRow(iRow)).bDirtyFlag = True
               Next iCol
            End If
         Next iRow
      End If
   End If
   m_bDirty = True
   Draw
   PropertyChanged "RowMode"
End Property
Public Property Get RowIsGroup(ByVal lRow As Long) As Boolean
Attribute RowIsGroup.VB_Description = "Gets/sets whether a row should be regarded as a group row."
   If (lRow > 0) And (lRow <= m_iRows) Then
      RowIsGroup = m_tvRows(m_vIRow(lRow)).bGroupRow
   Else
      'Err.Raise 9, App.EXEName, "Invalid Row Subscript"
   End If
End Property

Public Property Let RowIsGroup(ByVal lRow As Long, ByVal bState As Boolean)
Dim iCol As Long
   If (lRow > 0) And (lRow <= m_iRows) Then
      If m_tvRows(m_vIRow(lRow)).bGroupRow <> bState Then
         m_tvRows(m_vIRow(lRow)).bGroupRow = bState
         For iCol = 1 To m_iCols
            m_tvCells(iCol, m_vIRow(lRow)).bDirtyFlag = True
         Next iCol
         Draw
      End If
   Else
      'Err.Raise 9, App.EXEName, "Invalid Row Subscript"
   End If
End Property
Public Property Get IndexGroup(ByVal lRow As Long) As Long
   If (lRow > 0) And (lRow <= m_iRows) Then
      IndexGroup = m_tvRows(m_vIRow(lRow)).nIndexGroup
   Else
      'Err.Raise 9, App.EXEName, "Invalid Row Subscript"
   End If
End Property
Public Property Get RowGroupStartColumn(ByVal lRow As Long) As Long
   If (lRow > 0) And (lRow <= m_iRows) Then
      RowGroupStartColumn = m_tvRows(m_vIRow(lRow)).lGroupStartColIndex
   Else
      'Err.Raise 9, App.EXEName, "Invalid Row Subscript"
   End If
End Property
Public Property Let RowGroupStartColumn(ByVal lRow As Long, ByVal lColumn As Long)
Dim iCol As Long
   If (lRow > 0) And (lRow <= m_iRows) Then
      If m_tvRows(m_vIRow(lRow)).lGroupStartColIndex <> lColumn Then
         m_tvRows(m_vIRow(lRow)).lGroupStartColIndex = lColumn
         For iCol = 1 To m_iCols
            m_tvCells(iCol, m_vIRow(lRow)).bDirtyFlag = True
         Next iCol
         Draw
      End If
   Else
      'Err.Raise 9, App.EXEName, "Invalid Row Subscript"
   End If
End Property
Public Property Get GridLines() As Boolean
Attribute GridLines.VB_Description = "Gets/sets whether grid-lines are drawn or not."
Attribute GridLines.VB_ProcData.VB_Invoke_Property = ";Appearance"
   GridLines = m_bGridLines
End Property
Public Property Let GridLines(ByVal bState As Boolean)
   m_bGridLines = bState
   m_bDirty = True
   Draw
   PropertyChanged "GridLines"
End Property

Public Property Get hImageList() As Long
  hImageList = m_hIml
End Property

Public Property Let ImageList(vThis As Variant)
Attribute ImageList.VB_Description = "Sets an ImageList as the source of icons for the control.  The ImageList can be either a VB ImageList, a vbAccelerator ImageList or an API hIml handle.  If it is a VB Image List, the Image List must have had at least one icon in it before using this prop"
Attribute ImageList.VB_ProcData.VB_Invoke_PropertyPut = ";Behavior"
Dim hIml As Long
   ' Set the ImageList handle property either from a VB
   ' image list or directly:
   If VarType(vThis) = vbObject Then
       ' Assume VB ImageList control.  Note that unless
       ' some call has been made to an object within a
       ' VB ImageList the image list itself is not
       ' created.  Therefore hImageList returns error. So
       ' ensure that the ImageList has been initialised by
       ' drawing into nowhere:
       On Error Resume Next
       ' Get the image list initialised..
       vThis.ListImages(1).Draw 0, 0, 0, 1
       hIml = vThis.hImageList
       If (Err.Number <> 0) Then
           hIml = 0
       End If
       On Error GoTo 0
   ElseIf VarType(vThis) = vbLong Then
       ' Assume ImageList handle:
       hIml = vThis
   Else
       'Err.Raise vbObjectError + 1049, "cToolbar." & App.EXEName, "ImageList property expects ImageList object or long hImageList handle."
       Exit Property
   End If
    
   ' If we have a valid image list, then associate it with the control:
   If (hIml <> 0) Then
      m_hIml = hIml
      m_cHeader.SetImageList UserControl.hdc, hIml
      ImageList_GetIconSize m_hIml, m_lIconSizeX, m_lIconSizeY
   End If
End Property

Public Property Set BackgroundPicture(sPic As StdPicture)
Attribute BackgroundPicture.VB_Description = "Gets/sets a picture to be used as the grid's background."
Attribute BackgroundPicture.VB_ProcData.VB_Invoke_PropertyPutRef = ";Appearance"
On Error Resume Next
   Set picImage.Picture = sPic
   picImage.Refresh
   If (Err.Number <> 0) Or (picImage.ScaleWidth = 0) Or (sPic Is Nothing) Then
      m_hDCSrc = 0
      m_bBitmap = False
   Else
      m_bBitmap = True
      m_hDCSrc = picImage.hdc
      m_lBitmapW = picImage.ScaleWidth \ Screen.TwipsPerPixelX
      m_lBitmapH = picImage.ScaleHeight \ Screen.TwipsPerPixelY
   End If
   m_bDirty = True
   Draw
   PropertyChanged "BackgroundPicture"
End Property
Public Property Get BackgroundPictureHeight() As Long
Attribute BackgroundPictureHeight.VB_Description = "Gets/sets the height of the background picture."
Attribute BackgroundPictureHeight.VB_ProcData.VB_Invoke_Property = ";Appearance"
Attribute BackgroundPictureHeight.VB_MemberFlags = "400"
   BackgroundPictureHeight = m_lBitmapH
End Property
Public Property Let BackgroundPictureHeight(ByVal lHeight As Long)
   m_lBitmapH = lHeight
   PropertyChanged "BackgroundPictureHeight"
End Property
Public Property Get BackgroundPictureWidth() As Long
Attribute BackgroundPictureWidth.VB_Description = "Gets/sets the width of the background picture."
Attribute BackgroundPictureWidth.VB_ProcData.VB_Invoke_Property = ";Appearance"
Attribute BackgroundPictureWidth.VB_MemberFlags = "400"
   BackgroundPictureWidth = m_lBitmapW
End Property
Public Property Let BackgroundPictureWidth(ByVal lWidth As Long)
   m_lBitmapW = lWidth
   PropertyChanged "BackgroundPictureWidth"
End Property

Public Property Get BackgroundPicture() As StdPicture
   Set BackgroundPicture = picImage.Picture
End Property

Public Property Get BackColor() As OLE_COLOR
Attribute BackColor.VB_Description = "Gets/sets the background color of the grid."
Attribute BackColor.VB_ProcData.VB_Invoke_Property = ";Appearance"
Attribute BackColor.VB_UserMemId = -501
   BackColor = UserControl.BackColor
End Property
Public Property Let BackColor(ByVal oColor As OLE_COLOR)
   UserControl.BackColor = oColor
   If (m_hDC <> 0) Then
      SetBkColor m_hDC, TranslateColor(UserControl.BackColor)
   End If
   PropertyChanged "BackColor"
End Property
Public Property Get HighlightBackColor() As OLE_COLOR
' 19/10/1999 (8)
   HighlightBackColor = m_oHighlightBackColor
End Property
Public Property Let HighlightBackColor(oColor As OLE_COLOR)
' 19/10/1999 (8)
   m_oHighlightBackColor = oColor
   PropertyChanged "HighlightBackColor"
End Property
Public Property Get HighlightForeColor() As OLE_COLOR
' 19/10/1999 (8)
   HighlightForeColor = m_oHighlightForeColor
End Property
Public Property Let HighlightForeColor(oColor As OLE_COLOR)
' 19/10/1999 (8)
   m_oHighlightForeColor = oColor
   PropertyChanged "HighlightForeColor"
End Property

Public Property Get ForeColor() As OLE_COLOR
Attribute ForeColor.VB_Description = "Gets/sets the foreground color used to draw the control."
Attribute ForeColor.VB_ProcData.VB_Invoke_Property = ";Appearance"
Attribute ForeColor.VB_UserMemId = -513
   ForeColor = UserControl.ForeColor
End Property
Public Property Let ForeColor(ByVal oColor As OLE_COLOR)
   UserControl.ForeColor = oColor
   If (m_hDC <> 0) Then
      SetTextColor m_hDC, TranslateColor(oColor)
   End If
   PropertyChanged "ForeColor"
End Property
Public Property Get GridLineColor() As OLE_COLOR
Attribute GridLineColor.VB_Description = "Gets/sets the colour used to draw grid lines."
Attribute GridLineColor.VB_ProcData.VB_Invoke_Property = ";Appearance"
   GridLineColor = m_oGridLineColor
End Property
Public Property Let GridLineColor(ByVal oColor As OLE_COLOR)
   m_oGridLineColor = oColor
   m_bDirty = True
   Draw
   PropertyChanged "GridLineColor"
End Property

Public Property Get Font() As StdFont
Attribute Font.VB_Description = "Gets/sets the font used by the control."
Attribute Font.VB_ProcData.VB_Invoke_Property = ";Appearance"
Attribute Font.VB_UserMemId = -512
Dim tLF As LOGFONT
   Set Font = UserControl.Font
End Property
Public Property Set Font(ByVal sFont As StdFont)
Dim tLF As LOGFONT
   Set UserControl.Font = sFont
   m_cHeader.SetFont UserControl.hdc, sFont
   If (m_hFntDC <> 0) Then
      If (m_hDC <> 0) Then
         If (m_hFntOldDC <> 0) Then
            SelectObject m_hDC, m_hFntOldDC
         End If
         DeleteObject m_hFntDC
      End If
   End If
   pOLEFontToLogFont sFont, UserControl.hdc, tLF
   m_hFntDC = CreateFontIndirect(tLF)
   If (m_hDC <> 0) Then
      m_hFntOldDC = SelectObject(m_hDC, m_hFntDC)
   End If
   PropertyChanged "Font"
End Property

Public Property Get Virtual() As Boolean
Attribute Virtual.VB_Description = "Gets/sets whether the grid is in Virtual Mode (i.e. rows are added as required via the RequestRow and RequestRowData events)."
'   Virtual = m_bIsVirtual
End Property
Public Property Let Virtual(ByVal bVirtual As Boolean)
'   m_bIsVirtual = bVirtual
'   If Not m_bIsVirtual Then
'      m_bInVirtualRequest = False
'   Else
'      m_bInVirtualRequest = True
'   End If
'   PropertyChanged "Virtual"
End Property

Public Function AddFontIfRequierd(ByVal sFnt As StdFont) As Long
   AddFontIfRequierd = plAddFontIfRequired(sFnt)
End Function

Public Sub AutoWidthColumns()
   Dim iCCol As Long
   Dim iCol As Long

   CancelEdit
   
   Dim oldRedraw As Boolean
   oldRedraw = m_bRedraw
   
   m_bRedraw = False
   
   ' Autosize column here
   For iCol = 1 To m_iCols
      If m_tCols(iCol).bVisible And Not m_tCols(iCol).bRowTextCol Then
         iCCol = m_tCols(iCol).lCellColIndex
         AutoWidthColumn iCCol
      End If
   Next iCol
   
   Redraw = oldRedraw
End Sub

Public Sub ShowFilters()
  On Error GoTo ControlError
  
  Dim vColumns() As String
  Dim vKeys() As String
  
  Dim iCol As Long
  
  ReDim Preserve vColumns(0)
  ReDim Preserve vKeys(0)
  
  For iCol = 1 To m_iCols
    
    If (m_tCols(iCol).bVisible Or m_tCols(iCol).bHidden) _
       And LenB(m_tCols(iCol).sHeader) _
       And m_iRowTextCol <> iCol Then
       
      If LenB(vColumns(0)) Then
        ReDim Preserve vColumns(UBound(vColumns) + 1)
        ReDim Preserve vKeys(UBound(vKeys) + 1)
      End If
      
      vColumns(UBound(vColumns)) = m_tCols(iCol).sHeader
      If LenB(m_tCols(iCol).sKey) = 0 Then
        m_tCols(iCol).sKey = c_AuxKey & iCol
      End If
      vKeys(UBound(vKeys)) = m_tCols(iCol).sKey
    End If
  Next
  
  Dim oGridGroup As Object
  Set oGridGroup = CSKernelClient2.CreateObject("CSGridGroups.cGridGroups")
  
  oGridGroup.EditFilters Me, vColumns, vKeys
  Set oGridGroup = Nothing

  GoTo ExitProc
ControlError:
  MngError "ShowFilters"
ExitProc:
End Sub

Public Sub ShowFormats()
  On Error GoTo ControlError
  
  Dim vColumns() As String
  Dim vKeys() As String
  
  Dim iCol As Long
  
  ReDim Preserve vColumns(0)
  ReDim Preserve vKeys(0)
  
  For iCol = 1 To m_iCols
    
    If (m_tCols(iCol).bVisible Or m_tCols(iCol).bHidden) _
       And LenB(m_tCols(iCol).sHeader) _
       And m_iRowTextCol <> iCol Then
       
      If LenB(vColumns(0)) Then
        ReDim Preserve vColumns(UBound(vColumns) + 1)
        ReDim Preserve vKeys(UBound(vKeys) + 1)
      End If
      
      vColumns(UBound(vColumns)) = m_tCols(iCol).sHeader
      If LenB(m_tCols(iCol).sKey) = 0 Then
        m_tCols(iCol).sKey = c_AuxKey & iCol
      End If
      vKeys(UBound(vKeys)) = m_tCols(iCol).sKey
    End If
  Next
  
  Dim oGridGroup As Object
  Set oGridGroup = CSKernelClient2.CreateObject("CSGridGroups.cGridGroups")
  
  oGridGroup.EditFormats Me, vColumns, vKeys
  Set oGridGroup = Nothing

  GoTo ExitProc
ControlError:
  MngError "ShowFormats"
ExitProc:
End Sub

Public Sub ShowFormulas()
  On Error GoTo ControlError
  
  Dim vColumns() As String
  Dim vKeys() As String
  
  Dim iCol As Long
  
  ReDim Preserve vColumns(0)
  ReDim Preserve vKeys(0)
  
  For iCol = 1 To m_iCols
    
    If m_tCols(iCol).bVisible _
       And LenB(m_tCols(iCol).sHeader) _
       And m_iRowTextCol <> iCol Then
       
      If LenB(vColumns(0)) Then
        ReDim Preserve vColumns(UBound(vColumns) + 1)
        ReDim Preserve vKeys(UBound(vKeys) + 1)
      End If
      
      vColumns(UBound(vColumns)) = m_tCols(iCol).sHeader
      If LenB(m_tCols(iCol).sKey) = 0 Then
        m_tCols(iCol).sKey = c_AuxKey & iCol
      End If
      vKeys(UBound(vKeys)) = m_tCols(iCol).sKey
    End If
  Next
  
  Dim oGridGroup As Object
  Set oGridGroup = CSKernelClient2.CreateObject("CSGridGroups.cGridGroups")

  oGridGroup.EditFormulas Me, vColumns, vKeys
  Set oGridGroup = Nothing

  GoTo ExitProc
ControlError:
  MngError "ShowFormulas"
ExitProc:
End Sub

Public Sub GroupColumns()
  On Error GoTo ControlError
  
  Dim vColumns() As String
  Dim vKeys() As String
  
  Dim iCol As Long
  
  ReDim Preserve vColumns(0)
  ReDim Preserve vKeys(0)
  
  For iCol = 1 To m_iCols
    
    If (m_tCols(iCol).bVisible Or m_tCols(iCol).bHidden) _
       And LenB(m_tCols(iCol).sHeader) _
       And m_iRowTextCol <> iCol Then
       
      If LenB(vColumns(0)) Then
        ReDim Preserve vColumns(UBound(vColumns) + 1)
        ReDim Preserve vKeys(UBound(vKeys) + 1)
      End If
      
      vColumns(UBound(vColumns)) = m_tCols(iCol).sHeader
      If LenB(m_tCols(iCol).sKey) = 0 Then
        m_tCols(iCol).sKey = c_AuxKey & iCol
      End If
      vKeys(UBound(vKeys)) = m_tCols(iCol).sKey
    End If
  Next
  
  Dim oGridGroup As Object
  Set oGridGroup = CSKernelClient2.CreateObject("CSGridGroups.cGridGroups")
  
  oGridGroup.EditGroups Me, vColumns, vKeys
  Set oGridGroup = Nothing

  GoTo ExitProc
ControlError:
  MngError "GroupColumns"
ExitProc:
End Sub

Public Sub HideColumns()
  On Error GoTo ControlError
  
  Dim vColumns() As String
  Dim vKeys() As String
  
  Dim iCol As Long
  
  ReDim Preserve vColumns(0)
  ReDim Preserve vKeys(0)
  
  For iCol = 1 To m_iCols
    
    If LenB(m_tCols(iCol).sHeader) And _
       m_iRowTextCol <> iCol Then
       
      If LenB(vColumns(0)) Then
        ReDim Preserve vColumns(UBound(vColumns) + 1)
        ReDim Preserve vKeys(UBound(vKeys) + 1)
      End If
      
      vColumns(UBound(vColumns)) = m_tCols(iCol).sHeader
      If LenB(m_tCols(iCol).sKey) = 0 Then
        m_tCols(iCol).sKey = c_AuxKey & iCol
      End If
      vKeys(UBound(vKeys)) = m_tCols(iCol).sKey
    End If
  Next
  
  Dim oGridGroup As Object
  Set oGridGroup = CSKernelClient2.CreateObject("CSGridGroups.cGridGroups")
  
  oGridGroup.EditHideColumns Me, vColumns, vKeys
  Set oGridGroup = Nothing

  GoTo ExitProc
ControlError:
  MngError "HideColumns"
ExitProc:
End Sub

Public Sub CollapseAllGroups()
  pExpandAllGroups False
End Sub

Public Sub ExpandAllGroups()
  pExpandAllGroups True
End Sub

Private Sub pExpandAllGroups(ByVal bExpand As Boolean)
  Dim oGridGroup As Object
  Dim oldRedraw  As Boolean
  
  On Error GoTo ControlError
  
  oldRedraw = Redraw
  Redraw = False
  
  Dim mouse As cMouseWait
  Set mouse = New cMouseWait
  DoEvents: DoEvents: DoEvents
  
  Set oGridGroup = CSKernelClient2.CreateObject("CSGridGroups.cGridGroups")
  
  If bExpand Then
    oGridGroup.ExpandAll Me
  Else
    oGridGroup.CollapseAll Me
  End If
  
  Redraw = oldRedraw
  Exit Sub
ControlError:
  MngError "ExpandAll"
  GoTo ExitProc
ExitProc:
  Redraw = oldRedraw
End Sub

Public Sub Draw()
Attribute Draw.VB_Description = "Draws the control."

Dim iStartRow As Long, iStartCol As Long
Dim iStartX As Long, iStartY As Long
Dim lRowStartX As Long, lThisRowStartX As Long, lRowEndX As Long
Dim iEndRow As Long, iEndCol As Long, iEndCol2 As Long
Dim lStartX As Long
Dim iEndX As Long, iEndY As Long, iY As Long
Dim iRow As Long, iCol As Long
Dim iCellCol As Long, iCRowTextCol As Long, iFirstColInSelect As Long
Dim tR As RECT, tTR As RECT, tBR As RECT, tFR As RECT
Dim sText As String, sCopy As String
Dim lHDC As Long, lHDCC As Long
Dim hBr As Long, hBrGrid As Long
Dim hFntOld As Long
Dim lLastPos As Long, lOffset As Long
Dim bSel As Boolean, bDoIt As Boolean, bDrawBack As Boolean, bCellSelected As Boolean
Dim lStartColIndex As Long
Dim sKey As String, bVisible As Boolean, bGroupRow As Boolean, bNoMoreRows As Boolean, lHeight As Long
Dim bRecall As Boolean
Dim bDefaultStartCol As Boolean
Dim OForeColor As OLE_COLOR
Dim OBackColor As OLE_COLOR
Dim IFntIndex As Long

   If m_bRedraw And m_bUserMode Then
      
      m_lRowTextStartCol = pGetRowTextStartCol
      
      If (m_cHeader.Visible) Then
         lOffset = m_cHeader.Height
      End If
      
      GetClientRect UserControl.hWnd, tR
      If (m_hDC <> 0) Then
         lHDC = m_hDC
         lHDCC = UserControl.hdc
         tBR.Right = m_lAvailWidth + 24 + Abs(m_tCols(iStartCol).lStartX - m_lStartX)
         tBR.Bottom = m_lMaxRowHeight
      Else
         lHDC = UserControl.hdc
         pFillBackground lHDC, tR, 0, 0
      End If
      
      ' Ensure the scroll bars are set correctly:
      pScrollVisible
      
      ' Find the start and end of drawing:
      GetStartEndCell _
         iStartRow, iStartCol, iStartX, iStartY, _
         iEndRow, iEndCol, iEndX, iEndY
         
      ' If in virtual mode then we prepare for more rows:
      'If (m_bIsVirtual And m_bInVirtualRequest) Then
      '   If (iEndY < m_lAvailheight) Then
      '      iY = iEndY
      '      Do
      '         iEndRow = iEndRow + 1
      '         iY = iY + m_lDefaultRowHeight
      '      Loop While iY < m_lAvailheight
      '   End If
      'End If
               
      ' Evaluate the default group column start & end:
      lStartColIndex = m_lRowTextStartCol + m_Groups.Count
      bDefaultStartCol = (lStartColIndex = 0)
      For iCol = 1 To m_iCols
         If iFirstColInSelect = 0 Then
            If (m_tCols(iCol).bIncludeInSelect) Then
               iFirstColInSelect = iCol
               iCRowTextCol = iCol
               lRowStartX = m_tCols(iCol).lStartX - m_lStartX
               If (m_lRowTextStartCol = 0) Then
                  lStartColIndex = iCol
               End If
            End If
         End If
         If (m_tCols(iCol).lCellColIndex = lStartColIndex) And Not (bDefaultStartCol) Then
            lRowStartX = m_tCols(iCol).lStartX - m_lStartX
         ElseIf (m_tCols(iCol).lCellColIndex = m_iRowTextCol) Then
            iCRowTextCol = iCol
         ElseIf m_tCols(iCol).bVisible Then
            If (m_tCols(iCol).lStartX + m_tCols(iCol).lWidth - m_lStartX) > lRowEndX Then
               lRowEndX = m_tCols(iCol).lStartX + m_tCols(iCol).lWidth - m_lStartX
            End If
         End If
      Next iCol
           
      'Set up for grid lines:
      If (m_bGridLines) Then
         If (m_bEnabled) Then
            hBrGrid = CreateSolidBrush(TranslateColor(m_oGridLineColor)) 'GetSysColorBrush(vb3DLight And &H1F&)
         Else
            hBrGrid = GetSysColorBrush(vbGrayText And &H1F&)
         End If
      End If
      ' Text colour for disabled grid:
      'If Not (m_bEnabled) Then
      '   SetTextColor m_hDC, TranslateColor(vbGrayText)
      'End If
      
      ' Draw the dirty cells:
      For iRow = iStartRow To iEndRow
         ' Request new row if in virtual mode:
         If (iRow > m_iRows) Then
            Exit For
            
            'If m_iCols > 0 Then
               'If (m_bIsVirtual) Then
               '   lHeight = m_lDefaultRowHeight
               '   bVisible = True
               '   bGroupRow = False
               '   RaiseEvent RequestRow(iRow, sKey, bVisible, lHeight, bGroupRow, bNoMoreRows)
               '   If bNoMoreRows Then
               '      ' that's it
               '      m_bInVirtualRequest = False
               '      pScrollVisible
               '      bRecall = True
               '      Exit For
               '   Else
               '      AddRow , sKey, bVisible, lHeight, bGroupRow
               '      pScrollVisible
               '      RaiseEvent RequestRowData(iRow)
               '   End If
               'Else
               '   ' This does not occur:
               '   Debug.Assert iRow <= m_iRows
               '   Exit For
               'End If
            'Else
            '   ' Can't do it until cols are set up
            '   Exit Sub
            'End If
         End If
         
         If (m_tvRows(m_vIRow(iRow)).bVisible) Then
         
            If (m_hDC <> 0) Then
               tR.Top = 0
            Else
               tR.Top = m_tvRows(m_vIRow(iRow)).lStartY - m_lStartY
            End If
            tR.Bottom = tR.Top + m_tvRows(m_vIRow(iRow)).lOriginalHeigth
            If (m_hDC <> 0) Then
               pFillBackground lHDC, tBR, 0, m_tvRows(m_vIRow(iRow)).lStartY - m_lStartY
            End If
            
            bDoIt = m_bDirty
            If Not (bDoIt) Then
               ' Any dirty cells on this row?
               If m_tvRows(m_vIRow(iRow)).bGroupRow Then
                  If m_tvCells(m_iRowTextCol, m_vIRow(iRow)).bDirtyFlag Then
                     bDoIt = True
                     m_tvCells(m_iRowTextCol, m_vIRow(iRow)).bDirtyFlag = False
                  End If
               Else
                  For iCol = iStartCol To iEndCol
                     iCellCol = m_tCols(iCol).lCellColIndex
                     If m_tvCells(iCellCol, m_vIRow(iRow)).bDirtyFlag Then
                        bDoIt = True
                        m_tvCells(iCellCol, m_vIRow(iRow)).bDirtyFlag = False
                     End If
                  Next iCol
               End If
            End If
            
            If (bDoIt) Then
               
               
               '/////////////////////////////////////////////////////////////////////////////
               '
               ' Filas normales
               '
'--------------------------------------------------------------------------------------------

               ' Draw individual columns unless this row has the group row style, in
               ' which case we draw only the RowTextColumn.
               If Not (m_tvRows(m_vIRow(iRow)).bGroupRow) Then
                  
                  iEndCol2 = iEndCol
                  If m_iRowTextCol > iEndCol2 Then iEndCol2 = m_iRowTextCol
                  
                  For iCol = iStartCol To iEndCol2
                     
                     If (m_tCols(iCol).bVisible) Then
                        
                        bCellSelected = False
                        iCellCol = m_tCols(iCol).lCellColIndex
                        tR.Left = m_tCols(iCol).lStartX - m_lStartX + m_tvCells(iCellCol, m_vIRow(iRow)).lIndent
                        tR.Right = tR.Left + m_tCols(iCol).lWidth - m_tvCells(iCellCol, m_vIRow(iRow)).lIndent
                        bDrawBack = False
                        
                  '/////////////////////////////////////////////////////////////////////////////
                  '
                  ' Solo la columna activa
                  '
                        If (m_tvCells(iCellCol, m_vIRow(iRow)).bSelected) And (m_bEnabled) Then
                           If (m_tCols(iCol).bIncludeInSelect) Or (iCol > iFirstColInSelect) Then
                              If (m_bInFocus) Then
                                 hBr = CreateSolidBrush(TranslateColor(m_oHighlightBackColor))
                                 bCellSelected = True
                              Else
                                 hBr = GetSysColorBrush(vbButtonFace And &H1F&)
                              End If
                              LSet tTR = tR
                              If (m_bGridLines) Then
                                 InflateRect tTR, -1, -1
                              End If
                              If (m_bRowMode) Then
                                 If (iCol > iFirstColInSelect) Then
                                    tTR.Left = tTR.Left - m_tvCells(iCellCol, m_vIRow(iRow)).lIndent
                                 End If
                              End If
                              LSet tFR = tTR
                              If Not (m_bRowMode) Or m_bGridLines And (m_bEnabled) Then
                                 If (iCellCol = m_iSelCol) And (iRow = m_iSelRow) Then
                                    If m_bDrawFocusRectangle Then
                                       LSet tFR = tTR
                                       InflateRect tFR, -1, -1
                                    End If
                                 End If
                              ElseIf m_bRowMode And Not (m_bGridLines) Then
                                 tFR.Top = tFR.Top + 1
                              End If
                              FillRect lHDC, tFR, hBr
                              DeleteObject hBr
                           Else
                              bDrawBack = True
                           End If
                           bSel = True
                        Else
                           bDrawBack = m_bEnabled
                        End If
                        
                  '/////////////////////////////////////////////////////////////////////////////
                  '
                  ' Todas las columnas menos la activa
                  '
                        If (bDrawBack) Then
                           
                           If Not IsEmpty(m_tvCells(iCellCol, m_vIRow(iRow)).ConditionalFormat) Then
                              With m_tvCells(iCellCol, m_vIRow(iRow)).ConditionalFormat
                                OForeColor = .OForeColor
                                OBackColor = .OBackColor
                              End With
                           Else
                              With m_tvCells(iCellCol, m_vIRow(iRow))
                                OForeColor = .OForeColor
                                OBackColor = .OBackColor
                              End With
                           End If
                           
                           If (OBackColor = CLR_NONE) Then
                              If m_RowOddColor <> CLR_NONE Then
                                 If iRow Mod 2 Then
                                    OBackColor = m_RowOddColor
                                 End If
                              End If
                           End If
                           
                           If (OBackColor <> CLR_NONE) Then
                              hBr = CreateSolidBrush(TranslateColor(OBackColor))
                              LSet tTR = tR
                              If (m_tvCells(iCellCol, m_vIRow(iRow)).lIndent <> 0) Then
                                 tTR.Left = tTR.Left - m_tvCells(iCellCol, m_vIRow(iRow)).lIndent
                              End If
                              FillRect lHDC, tTR, hBr
                              DeleteObject hBr
                           End If
                           
                           If (OForeColor <> CLR_NONE) Then
                              SetTextColor lHDC, TranslateColor(OForeColor)
                              bSel = True
                           Else
                              If (bSel) Then
                                 SetTextColor lHDC, TranslateColor(UserControl.ForeColor)
                                 bSel = False
                              End If
                           End If
                        End If
                        
                        ' Only normal columns
                        If (iCol <> m_iRowTextCol) Then
                          If (m_bGridLines) Then
                             LSet tTR = tR
                             tTR.Left = tTR.Left - m_tvCells(iCellCol, m_vIRow(iRow)).lIndent
                             tTR.Right = tR.Right + 1
                             If (iRow <> iEndRow) Then
                                tTR.Bottom = tR.Bottom + 1
                             End If
                             FrameRect lHDC, tTR, hBrGrid
                             LSet tTR = tR
                             InflateRect tTR, -2, -2
                          Else
                             LSet tTR = tR
                             InflateRect tTR, -1, -1
                          End If
                          If Not (m_bRowMode) Or m_bGridLines And (m_bEnabled) Then
                             If (iCellCol = m_iSelCol) And (iRow = m_iSelRow) Then
                                ' 19/10/1999 (14):
                                If m_bDrawFocusRectangle And m_bInFocus And m_bEnabled Then
                                   LSet tFR = tTR
                                   InflateRect tFR, 1, 1
                                   SetTextColor lHDC, TranslateColor(UserControl.ForeColor)
                                   DrawFocusRect lHDC, tFR
                                   m_tvCells(iCellCol, m_vIRow(iRow)).bDirtyFlag = True
                                End If
                             End If
                          End If
                          If (m_tvCells(iCellCol, m_vIRow(iRow)).lExtraIconIndex > -1) Then
                             DrawImage m_hIml, m_tvCells(iCellCol, m_vIRow(iRow)).lExtraIconIndex, lHDC, tTR.Left, tTR.Top, m_lIconSizeX, m_lIconSizeY, m_tvCells(iCellCol, m_vIRow(iRow)).bSelected And m_bHighlightSelectedIcons, , Not (m_bEnabled) And m_bDisableIcons
                             tTR.Left = tTR.Left + m_lIconSizeX + 2
                          End If
                          If (m_tvCells(iCellCol, m_vIRow(iRow)).lGroupIconIndex > -1) Then
                             DrawImage m_hImlGroup, m_tvCells(iCellCol, m_vIRow(iRow)).lGroupIconIndex, lHDC, tTR.Left, tTR.Top, m_lIconSizeGroupX, m_lIconSizeGroupY, m_tvCells(iCellCol, m_vIRow(iRow)).bSelected And m_bHighlightSelectedIcons, , Not (m_bEnabled) And m_bDisableIcons
                             tTR.Left = tTR.Left + m_lIconSizeGroupX + 2
                          End If
                          If (m_tvCells(iCellCol, m_vIRow(iRow)).iIconIndex > -1) Then
                             DrawImage m_hIml, m_tvCells(iCellCol, m_vIRow(iRow)).iIconIndex, lHDC, tTR.Left, tTR.Top, m_lIconSizeX, m_lIconSizeY, m_tvCells(iCellCol, m_vIRow(iRow)).bSelected And m_bHighlightSelectedIcons, , Not (m_bEnabled) And m_bDisableIcons
                             tTR.Left = tTR.Left + m_lIconSizeX + 2
                          End If
                          If (m_tvCells(iCellCol, m_vIRow(iRow)).eTextFlags And DT_RIGHT) = DT_RIGHT Then
                            tTR.Right = tTR.Right - 4
                          End If
                          
                          If Not (IsMissing(m_tvCells(iCellCol, m_vIRow(iRow)).sText)) Then
                             If (Len(m_tvCells(iCellCol, m_vIRow(iRow)).sText) > 0) Then
                                If Not IsEmpty(m_tvCells(iCellCol, m_vIRow(iRow)).ConditionalFormat) Then
                                  IFntIndex = m_tvCells(iCellCol, m_vIRow(iRow)).ConditionalFormat.IFntIndex
                                Else
                                  IFntIndex = m_tvCells(iCellCol, m_vIRow(iRow)).IFntIndex
                                End If
                                If (IFntIndex <> 0) Then
                                   hFntOld = SelectObject(m_hDC, m_hFnt(IFntIndex))
                                End If
                                sCopy = m_tvCells(iCellCol, m_vIRow(iRow)).sText
                                If (Len(m_tCols(iCol).sFmtString) > 0) Then
                                   sCopy = Format$(sCopy, m_tCols(iCol).sFmtString)
                                End If
                                If bCellSelected Then
                                   ' 19/10/1999 (8):
                                   'SetTextColor lHDC, TranslateColor(vbHighlightText)
                                   SetTextColor lHDC, TranslateColor(m_oHighlightForeColor)
                                End If
                                DrawText lHDC, sCopy & vbNullChar, -1, tTR, m_tvCells(iCellCol, m_vIRow(iRow)).eTextFlags
                                If bCellSelected Then
                                   SetTextColor lHDC, TranslateColor(UserControl.ForeColor)
                                End If
                                If Len(m_sSearchString) > 0 And m_bEnabled Then
                                   If (iRow = m_iSelRow) And (iCellCol = m_iSearchCol) Then
                                      SetBkMode m_hDC, OPAQUE
                                      SetBkColor m_hDC, TranslateColor(UserControl.BackColor)
                                      SetTextColor m_hDC, TranslateColor(UserControl.ForeColor)
                                      'debugmsg "'" & left$(m_tvCells(iCellCol, m_vIrow(iRow)).sText, Len(m_sSearchString)) & "'"
                                      sCopy = Left$(m_tvCells(iCellCol, m_vIRow(iRow)).sText, Len(m_sSearchString))
                                      DrawText m_hDC, sCopy & vbNullChar, -1, tTR, m_tvCells(iCellCol, m_vIRow(iRow)).eTextFlags
                                      SetBkMode m_hDC, TRANSPARENT
                                   End If
                                End If
                                If (hFntOld <> 0) Then
                                   SelectObject m_hDC, hFntOld
                                   hFntOld = 0
                                End If
                             End If
                          End If
                        End If
                     End If
                  Next iCol
               End If

'--------------------------------------------------------------------------------------------
               ' Fin filas normales
               '
               '/////////////////////////////////////////////////////////////////////////////
               
               
               
               If (m_bGridLines) Then
               ' If grid lines requested ensure we continue them off RHS of the grid:
                  If (tR.Right < m_lAvailWidth + 32) Then
                     tTR.Left = tR.Right
                     tTR.Top = tR.Top
                     tTR.Right = m_lAvailWidth + 32
                     If (iRow <> iEndRow) Then
                        tTR.Bottom = tR.Bottom + 1
                     Else
                        tTR.Bottom = tR.Bottom
                     End If
                     FrameRect lHDC, tTR, hBrGrid
                  End If
               Else
               ' Draw focus rectangle for row mode to cover
               ' all the cells:
                  If (m_bRowMode) And Not (m_tvRows(m_vIRow(iRow)).bGroupRow) Then
                     If (iRow = m_iSelRow) Then
                        tTR.Top = 1
                        tTR.Bottom = tR.Bottom
                        tTR.Left = m_tCols(iFirstColInSelect).lStartX - m_lStartX + m_tvCells(m_tCols(iFirstColInSelect).lCellColIndex, m_vIRow(iRow)).lIndent
                        
                        If m_iRowTextCol = 0 Then
                          tTR.Right = tR.Right
                        Else
                          ' Javier: Esto esta mejor
                          If m_cScroll.Visible(efsVertical) Then
                            tTR.Right = (UserControl.Width / Screen.TwipsPerPixelX) - 20
                          Else
                            tTR.Right = (UserControl.Width / Screen.TwipsPerPixelX) - 5
                          End If
                          If tTR.Right < lRowEndX Then tTR.Right = lRowEndX
                        End If
                        
                        ' 19/10/1999 (14):
                        If m_bDrawFocusRectangle And m_bInFocus And m_bEnabled Then
                           LSet tFR = tTR
                           tFR.Top = 0
                           DrawFocusRect lHDC, tTR
                           For iCol = 1 To m_iCols
                              m_tvCells(iCol, m_vIRow(m_iSelRow)).bDirtyFlag = True
                           Next iCol
                        End If
                     End If
                  End If
               End If
               
               ' Draw the grouped cells:
               If (m_bRowMode) Or (m_tvRows(m_vIRow(iRow)).bGroupRow) Then
                  If (m_iRowTextCol <> 0) Then
                     LSet tTR = tR
                     If Not m_tvRows(m_vIRow(iRow)).bGroupRow Then
                        tTR.Top = m_lDefaultRowHeight
                     Else
                        tTR.Top = 1
                        m_tvRows(m_vIRow(iRow)).lHeight = m_tvRows(m_vIRow(iRow)).lOriginalHeigth
                        
                        ' Solo para GroupRows de totales
                        If m_tvRows(m_vIRow(iRow)).nIndexGroup < 0 And m_tvRows(m_vIRow(iRow)).nIndexGroup > -1001 Then
                          ' Todo esto es para columnas con mas de una formula asociada
                          If tTR.Bottom < m_GroupRowHeight Then
                            tR.Bottom = m_GroupRowHeight
                            tTR.Bottom = m_GroupRowHeight
                            m_tvRows(m_vIRow(iRow)).lHeight = m_GroupRowHeight
                            pRowHeight iRow, m_GroupRowHeight, False
                          End If
                        End If
                        bSel = False
                     End If
                     
                     lThisRowStartX = lRowStartX
                     If m_tvRows(m_vIRow(iRow)).bGroupRow And m_tvRows(m_vIRow(iRow)).lGroupStartColIndex <> 0 Then
                        ' Must evaluate the correct start and end points:
                        For iCol = 1 To m_iCols
                           If m_tCols(iCol).lCellColIndex = m_tvRows(m_vIRow(iRow)).lGroupStartColIndex Then
                              lThisRowStartX = m_tCols(iCol).lStartX - m_lStartX
                              Exit For
                           End If
                        Next iCol
                     End If
                     tTR.Left = lThisRowStartX + m_tvCells(m_iRowTextCol, m_vIRow(iRow)).lIndent
                     
                     ' 19-11-2003 Javier: Esto es mas practico ya que el
                     ' metodo anterior de usar todo el espacio disponible no
                     ' quedaba muy bien cuando hay mas columnas que las que se ven
                     ' en la pantalla
                     If m_tvRows(m_vIRow(iRow)).bGroupRow Then
                        tTR.Right = (UserControl.Width / Screen.TwipsPerPixelX) - 1
                        If tTR.Right < lRowEndX Then tTR.Right = lRowEndX
                        If m_tvRows(m_vIRow(iRow)).nIndexGroup < 0 And m_tvRows(m_vIRow(iRow)).nIndexGroup > -1000 Then
                           tTR.Left = tTR.Left + m_lIconSizeGroupX
                        End If
                     Else
                        tTR.Right = tTR.Left + m_tCols(m_iRowTextCol).lWidth
                     End If
                     
                     If Not IsMissing(m_tvCells(m_iRowTextCol, m_vIRow(iRow)).sText) Then
                        sCopy = m_tvCells(m_iRowTextCol, m_vIRow(iRow)).sText
                     Else
                        sCopy = vbNullString
                     End If
                     If (LenB(m_tCols(iCRowTextCol).sFmtString)) Then
                        sCopy = Format$(sCopy, m_tCols(iCRowTextCol).sFmtString)
                     End If
                     If Not (bSel) Then
                        If m_tvRows(m_vIRow(iRow)).bGroupRow Then
                           If m_tvCells(m_iRowTextCol, m_vIRow(iRow)).bSelected Then
                              hBr = CreateSolidBrush(TranslateColor(m_oHighlightBackColor))
                              FillRect m_hDC, tTR, hBr
                              DeleteObject hBr
                              If m_bDrawFocusRectangle And m_bInFocus And m_bEnabled Then
                                 DrawFocusRect lHDC, tTR
                              End If
                              SetTextColor m_hDC, TranslateColor(m_oHighlightForeColor)
                           Else
                              If Not IsEmpty(m_tvCells(m_iRowTextCol, m_vIRow(iRow)).ConditionalFormat) Then
                                 With m_tvCells(m_iRowTextCol, m_vIRow(iRow)).ConditionalFormat
                                    OForeColor = .OForeColor
                                    OBackColor = .OBackColor
                                 End With
                              Else
                                 With m_tvCells(m_iRowTextCol, m_vIRow(iRow))
                                    OForeColor = .OForeColor
                                    OBackColor = .OBackColor
                                 End With
                              End If
                              If (OBackColor <> CLR_NONE) Then
                                 hBr = CreateSolidBrush(TranslateColor(OBackColor))
                                 FillRect m_hDC, tTR, hBr
                                 DeleteObject hBr
                              End If
                              If (OForeColor <> CLR_NONE) Then
                                 SetTextColor m_hDC, TranslateColor(OForeColor)
                              Else
                                 SetTextColor m_hDC, TranslateColor(UserControl.ForeColor)
                              End If
                           End If
                        Else
                           If Not IsEmpty(m_tvCells(m_iRowTextCol, m_vIRow(iRow)).ConditionalFormat) Then
                              With m_tvCells(m_iRowTextCol, m_vIRow(iRow)).ConditionalFormat
                                OForeColor = .OForeColor
                                OBackColor = .OBackColor
                              End With
                           Else
                              With m_tvCells(m_iRowTextCol, m_vIRow(iRow))
                                OForeColor = .OForeColor
                                OBackColor = .OBackColor
                              End With
                           End If
                           If (OBackColor <> CLR_NONE) Then
                              hBr = CreateSolidBrush(TranslateColor(OBackColor))
                              FillRect m_hDC, tTR, hBr
                              DeleteObject hBr
                           End If
                           If (OForeColor <> CLR_NONE) Then
                              SetTextColor m_hDC, TranslateColor(OForeColor)
                           End If
                        End If
                     Else
                       If Not IsEmpty(m_tvCells(m_iRowTextCol, m_vIRow(iRow)).ConditionalFormat) Then
                          OForeColor = m_tvCells(m_iRowTextCol, m_vIRow(iRow)).ConditionalFormat.OForeColor
                       Else
                          OForeColor = m_tvCells(m_iRowTextCol, m_vIRow(iRow)).OForeColor
                       End If
                       If (OForeColor <> CLR_NONE) Then
                         SetTextColor m_hDC, TranslateColor(OForeColor)
                       End If
                     End If
                     If (m_tvCells(m_iRowTextCol, m_vIRow(iRow)).lExtraIconIndex > -1) Then
                        DrawImage m_hIml, m_tvCells(m_iRowTextCol, m_vIRow(iRow)).lExtraIconIndex, lHDC, tTR.Left, tTR.Top, m_lIconSizeX, m_lIconSizeY, m_tvCells(m_iRowTextCol, m_vIRow(iRow)).bSelected And m_bHighlightSelectedIcons, , Not (m_bEnabled) And m_bDisableIcons
                        tTR.Left = tTR.Left + m_lIconSizeX + 2
                     End If
                     If (m_tvCells(m_iRowTextCol, m_vIRow(iRow)).lGroupIconIndex > -1) Then
                        DrawImage m_hImlGroup, m_tvCells(m_iRowTextCol, m_vIRow(iRow)).lGroupIconIndex, lHDC, tTR.Left, tTR.Top, m_lIconSizeGroupX, m_lIconSizeGroupY, m_tvCells(m_iRowTextCol, m_vIRow(iRow)).bSelected And m_bHighlightSelectedIcons, , Not (m_bEnabled) And m_bDisableIcons
                        tTR.Left = tTR.Left + m_lIconSizeGroupX + 2
                     End If
                     If (m_tvCells(m_iRowTextCol, m_vIRow(iRow)).iIconIndex > -1) Then
                        DrawImage m_hIml, m_tvCells(m_iRowTextCol, m_vIRow(iRow)).iIconIndex, lHDC, tTR.Left, tTR.Top, m_lIconSizeX, m_lIconSizeY, m_tvCells(m_iRowTextCol, m_vIRow(iRow)).bSelected And m_bHighlightSelectedIcons, , Not (m_bEnabled) And m_bDisableIcons
                        tTR.Left = tTR.Left + m_lIconSizeX + 2
                     End If
                     If Not IsEmpty(m_tvCells(m_iRowTextCol, m_vIRow(iRow)).ConditionalFormat) Then
                        IFntIndex = m_tvCells(m_iRowTextCol, m_vIRow(iRow)).ConditionalFormat.IFntIndex
                     Else
                        IFntIndex = m_tvCells(m_iRowTextCol, m_vIRow(iRow)).IFntIndex
                     End If
                     If (IFntIndex <> 0) Then
                        hFntOld = SelectObject(m_hDC, m_hFnt(IFntIndex))
                     End If
                     If bCellSelected Then
                        SetTextColor lHDC, TranslateColor(m_oHighlightForeColor)
                     End If
                     DrawText m_hDC, sCopy, Len(sCopy), tTR, m_tvCells(m_iRowTextCol, m_vIRow(iRow)).eTextFlags
                     ' Fix for row getting selection colour after group row:
                     SetTextColor lHDC, TranslateColor(UserControl.ForeColor)
                     If (hFntOld <> 0) Then
                        SelectObject m_hDC, hFntOld
                        hFntOld = 0
                     End If
                     
'///////////////////////////////////////////
                    ' Now total columns
                     For iCol = iStartCol To iEndCol
                       If (m_tCols(iCol).bVisible) _
                       And (m_tvCells(iCol, m_vIRow(iRow)).lItemData = C_TOTAL_COLUMN _
                         Or m_tvCells(iCol, m_vIRow(iRow)).lItemData = C_TOTAL_COLUMN_EX) Then

                          iCellCol = iCol 'm_tCols(iCol).lCellColIndex
                          
                          If (m_tvCells(iCellCol, m_vIRow(iRow)).bSelected) And (m_bEnabled) Then
                             If (m_tCols(iCol).bIncludeInSelect) Or (iCol > iFirstColInSelect) Then
                                bCellSelected = (m_bInFocus)
                             End If
                          End If
                          tR.Left = m_tCols(iCol).lStartX - m_lStartX + m_tvCells(iCellCol, m_vIRow(iRow)).lIndent
                          tR.Right = tR.Left + m_tCols(iCol).lWidth - m_tvCells(iCellCol, m_vIRow(iRow)).lIndent
                          
                          If Not IsEmpty(m_tvCells(iCellCol, m_vIRow(iRow)).ConditionalFormat) Then
                             OForeColor = m_tvCells(iCellCol, m_vIRow(iRow)).ConditionalFormat.OForeColor
                          Else
                             OForeColor = m_tvCells(iCellCol, m_vIRow(iRow)).OForeColor
                          End If
                          If (OForeColor <> CLR_NONE) Then
                             SetTextColor lHDC, TranslateColor(OForeColor)
                          Else
                             SetTextColor lHDC, TranslateColor(UserControl.ForeColor)
                          End If
                          If (m_bGridLines) Then
                             LSet tTR = tR
                             tTR.Left = tTR.Left - m_tvCells(iCellCol, m_vIRow(iRow)).lIndent
                             tTR.Right = tR.Right + 1
                             If (iRow <> iEndRow) Then
                                tTR.Bottom = tR.Bottom + 1
                             End If
                             FrameRect lHDC, tTR, hBrGrid
                             LSet tTR = tR
                             InflateRect tTR, -2, -2
                          Else
                             LSet tTR = tR
                             InflateRect tTR, -1, -1
                          End If
                          If (m_tvCells(iCellCol, m_vIRow(iRow)).lExtraIconIndex > -1) Then
                             DrawImage m_hIml, m_tvCells(iCellCol, m_vIRow(iRow)).lExtraIconIndex, lHDC, tTR.Left, tTR.Top, m_lIconSizeX, m_lIconSizeY, m_tvCells(iCellCol, m_vIRow(iRow)).bSelected And m_bHighlightSelectedIcons, , Not (m_bEnabled) And m_bDisableIcons
                             tTR.Left = tTR.Left + m_lIconSizeX + 2
                          End If
                          If (m_tvCells(iCellCol, m_vIRow(iRow)).lGroupIconIndex > -1) Then
                             DrawImage m_hImlGroup, m_tvCells(iCellCol, m_vIRow(iRow)).lGroupIconIndex, lHDC, tTR.Left, tTR.Top, m_lIconSizeGroupX, m_lIconSizeGroupY, m_tvCells(iCellCol, m_vIRow(iRow)).bSelected And m_bHighlightSelectedIcons, , Not (m_bEnabled) And m_bDisableIcons
                             tTR.Left = tTR.Left + m_lIconSizeGroupX + 2
                          End If
                          If (m_tvCells(iCellCol, m_vIRow(iRow)).iIconIndex > -1) Then
                             DrawImage m_hIml, m_tvCells(iCellCol, m_vIRow(iRow)).iIconIndex, lHDC, tTR.Left, tTR.Top, m_lIconSizeX, m_lIconSizeY, m_tvCells(iCellCol, m_vIRow(iRow)).bSelected And m_bHighlightSelectedIcons, , Not (m_bEnabled) And m_bDisableIcons
                             tTR.Left = tTR.Left + m_lIconSizeX + 2
                          End If
                          If Not (IsMissing(m_tvCells(iCellCol, m_vIRow(iRow)).sText)) Then
                             If (Len(m_tvCells(iCellCol, m_vIRow(iRow)).sText) > 0) Then
                                
                                If Not IsEmpty(m_tvCells(iCellCol, m_vIRow(iRow)).ConditionalFormat) Then
                                   IFntIndex = m_tvCells(iCellCol, m_vIRow(iRow)).ConditionalFormat.IFntIndex
                                Else
                                   IFntIndex = m_tvCells(iCellCol, m_vIRow(iRow)).IFntIndex
                                End If
                                If (IFntIndex <> 0) Then
                                   hFntOld = SelectObject(m_hDC, m_hFnt(IFntIndex))
                                End If
                                sCopy = m_tvCells(iCellCol, m_vIRow(iRow)).sText
                                If (Len(m_tCols(iCol).sFmtString) > 0) Then
                                   sCopy = Format$(sCopy, m_tCols(iCol).sFmtString)
                                End If
                                If bCellSelected Then
                                   SetTextColor lHDC, TranslateColor(m_oHighlightForeColor)
                                End If
                                
                                ' Si la columna tiene mas de una formula asignada la parto en dos
                                If m_tvCells(iCellCol, m_vIRow(iRow)).lItemData = C_TOTAL_COLUMN_EX Then
                                  If (m_tvCells(iCellCol, m_vIRow(iRow)).eTextFlags And DT_RIGHT) <> DT_RIGHT Then
                                    sCopy = m_tvCells(iCellCol, m_vIRow(iRow)).sTextFormulas & sCopy
                                  Else
                                    DrawText lHDC, m_tvCells(iCellCol, m_vIRow(iRow)).sTextFormulas & vbNullChar, _
                                             -1, tTR, DT_LEFT Or DT_NOPREFIX And Not DT_CALCRECT
                                  End If
                                End If
                                
                                DrawText lHDC, sCopy & vbNullChar, -1, tTR, m_tvCells(iCellCol, m_vIRow(iRow)).eTextFlags
                                
                                If bCellSelected Then
                                   SetTextColor lHDC, TranslateColor(UserControl.ForeColor)
                                End If
                                If Len(m_sSearchString) > 0 And m_bEnabled Then
                                   If (iRow = m_iSelRow) And (iCellCol = m_iSearchCol) Then
                                      SetBkMode m_hDC, OPAQUE
                                      SetBkColor m_hDC, TranslateColor(UserControl.BackColor)
                                      SetTextColor m_hDC, TranslateColor(UserControl.ForeColor)
                                      sCopy = Left$(m_tvCells(iCellCol, m_vIRow(iRow)).sText, Len(m_sSearchString))
                                      DrawText m_hDC, sCopy & vbNullChar, -1, tTR, m_tvCells(iCellCol, m_vIRow(iRow)).eTextFlags
                                      SetBkMode m_hDC, TRANSPARENT
                                   End If
                                End If
                                If (hFntOld <> 0) Then
                                   SelectObject m_hDC, hFntOld
                                   hFntOld = 0
                                End If
                             End If
                          End If
                       End If
                     Next iCol

'///////////////////////////////////////////
                  End If
               End If
               
               If (m_hDC <> 0) Then
                  BitBlt lHDCC, _
                         0, _
                         m_tvRows(m_vIRow(iRow)).lStartY - m_lStartY + lOffset, _
                         m_lAvailWidth + Abs(m_tCols(iStartCol).lStartX - m_lStartX) + 32, _
                         m_tvRows(m_vIRow(iRow)).lHeight, _
                         m_hDC, _
                         0, 0, vbSrcCopy
               End If
            End If ' row not dirty
            lLastPos = m_tvRows(m_vIRow(iRow)).lStartY - m_lStartY + m_tvRows(m_vIRow(iRow)).lHeight
            bCellSelected = False
         End If
      Next iRow
      ' Is there any space left over at the bottom?
      tR.Bottom = UserControl.Height \ Screen.TwipsPerPixelY
      If (lLastPos < tR.Bottom) Then
         tR.Left = 0
         tR.Top = lLastPos + lOffset
         tR.Right = m_lAvailWidth + 32
         pFillBackground lHDCC, tR, 0, lLastPos
      End If
      
      If (m_bGridLines) Then
         DeleteObject hBrGrid
      End If
      
      If (bSel) Then
         SetTextColor lHDC, TranslateColor(UserControl.ForeColor)
      End If
      
      m_iLastSelRow = m_iSelRow
      m_iLastSelCol = m_iSelCol
      m_bDirty = False
      
      If bRecall Then
         bRecall = False
         m_bDirty = True
         Draw
      End If
   End If
End Sub

Private Sub pFillBackground( _
      ByVal lHDC As Long, _
      ByRef tR As RECT, _
      ByVal lOffsetX As Long, _
      ByVal lOffsetY As Long _
   )
Dim hBr As Long
   If (m_bBitmap) Then
      TileArea lHDC, tR.Left, tR.Top, tR.Right - tR.Left, tR.Bottom - tR.Top, m_hDCSrc, m_lBitmapW, m_lBitmapH, lOffsetX, lOffsetY
   Else
      If Not (m_bEnabled) Then
         hBr = GetSysColorBrush(vbButtonFace And &H1F&)
      Else
         If (UserControl.BackColor And &H80000000) = &H80000000 Then
            hBr = GetSysColorBrush(UserControl.BackColor And &H1F&)
         Else
            hBr = CreateSolidBrush(TranslateColor(UserControl.BackColor))
         End If
      End If
      FillRect lHDC, tR, hBr
      DeleteObject hBr
   End If
End Sub
Private Sub pCreateHeader()
   Set m_cHeader = New cHeaderControl
   m_cHeader.Init UserControl.hWnd, UserControl.Ambient.UserMode
End Sub
Public Function pbEnsureVisible( _
      ByVal lRow As Long, _
      ByVal lCol As Long _
   ) As Boolean
Dim lXStart As Long
Dim lXEnd As Long
Dim lYStart As Long
Dim lYEnd As Long
Dim lOffset As Long
Dim lValue As Long
Dim iCellCol As Long
Dim lStartColIndex As Long
Dim lOrginialCol As Long

  lOrginialCol = lCol

   ' Check x:
   If Not (m_bRowMode) Or (m_bMouseDown) Then
      For iCellCol = 1 To m_iCols
         If (m_tCols(iCellCol).lCellColIndex = lCol) Then
            lCol = iCellCol
            If lStartColIndex <> 0 Then
               Exit For
            End If
         End If
         If m_lRowTextStartCol = 0 Then
            If m_tCols(iCellCol).bIncludeInSelect Then
               lStartColIndex = iCellCol
            End If
         End If
      Next iCellCol
      
      If m_tvRows(m_vIRow(lRow)).bGroupRow Then
         If m_tvRows(m_vIRow(lRow)).lGroupStartColIndex = 0 Then
            lStartColIndex = m_lRowTextStartCol
         Else
            If m_tvRows(m_vIRow(lRow)).lGroupStartColIndex <> 0 Then
               lStartColIndex = m_tvRows(m_vIRow(lRow)).lGroupStartColIndex
            End If
         End If
         lXStart = m_tCols(lStartColIndex).lStartX
         If m_bTryToFitGroupRows Then
            lXEnd = m_tCols(m_iCols).lStartX + m_tCols(m_iCols).lWidth
         Else
            lXEnd = lXStart + 1
         End If
      Else
         lXStart = m_tCols(lCol).lStartX
         lXEnd = lXStart + m_tCols(lCol).lWidth
      End If
      If (lXStart > m_lStartX) Then
         If (lXEnd < m_lStartX + m_lAvailWidth) Then
            ' Ok
         Else
            ' Have to shift x rightwards:
            If (m_tCols(lCol).lWidth > m_lAvailWidth) Then
            
              ' Ensure start of column is visible:
              lOffset = lXStart - m_lStartX
              lValue = m_cScroll.Value(efsHorizontal)
              m_cScroll.Value(efsHorizontal) = m_cScroll.Value(efsHorizontal) + lOffset
              pbEnsureVisible = (m_cScroll.Value(efsHorizontal) <> lValue)
            
            Else
            
              ' Make entire cell visible:
              lOffset = lXEnd - (m_lStartX + m_lAvailWidth) + 8
              lValue = m_cScroll.Value(efsHorizontal)
              m_cScroll.Value(efsHorizontal) = m_cScroll.Value(efsHorizontal) + lOffset
              pbEnsureVisible = (m_cScroll.Value(efsHorizontal) <> lValue)
            
            End If
         End If
      Else
         ' have to shift x leftwards:
         If (lXStart < m_lStartX) Then
          
             lOffset = lXStart - m_lStartX - 8
             lValue = m_cScroll.Value(efsHorizontal)
             m_cScroll.Value(efsHorizontal) = m_cScroll.Value(efsHorizontal) + lOffset
             pbEnsureVisible = (m_cScroll.Value(efsHorizontal) <> lValue)
         
         End If
      End If
   End If
   
   ' Check y
   lYStart = m_tvRows(m_vIRow(lRow)).lStartY
   lYEnd = lYStart + m_tvRows(m_vIRow(lRow)).lHeight
   If (lYStart > m_lStartY) Then
      If (lYEnd < m_lStartY + m_lAvailheight) Then
         ' Ok
         'm_cScroll.Value(efsVertical) = 1
      Else
         ' Have to shift y downwards:
         If (m_tvRows(m_vIRow(lRow)).lHeight < m_lAvailheight) Then
            lOffset = lYEnd - (m_lStartY + m_lAvailheight) + 8
            lValue = m_cScroll.Value(efsVertical)
            m_cScroll.Value(efsVertical) = m_cScroll.Value(efsVertical) + lOffset
            pbEnsureVisible = (m_cScroll.Value(efsVertical) <> lValue)
         End If
      End If
   Else
      ' Have to shift y upwards:
      If (lYStart < m_lStartY) Then
         lOffset = lYStart - m_lStartY - 8
         lValue = m_cScroll.Value(efsVertical)
         m_cScroll.Value(efsVertical) = m_cScroll.Value(efsVertical) + lOffset
         pbEnsureVisible = (m_cScroll.Value(efsVertical) <> lValue)
      End If
   End If
   
End Function

Public Function pbEnsureVisibleY( _
      ByVal lRow As Long, _
      ByVal lCol As Long _
   ) As Boolean
Dim lYStart As Long
Dim lYEnd As Long
Dim lOffset As Long
Dim lValue As Long
   
   ' Check y
   lYStart = m_tvRows(m_vIRow(lRow)).lStartY
   lYEnd = lYStart + m_tvRows(m_vIRow(lRow)).lHeight
   If (lYStart > m_lStartY) Then
      If (lYEnd < m_lStartY + m_lAvailheight) Then
         ' Ok
         'm_cScroll.Value(efsVertical) = 1
      Else
         ' Have to shift y downwards:
         If (m_tvRows(m_vIRow(lRow)).lHeight < m_lAvailheight) Then
            lOffset = lYEnd - (m_lStartY + m_lAvailheight) + 8
            lValue = m_cScroll.Value(efsVertical)
            m_cScroll.Value(efsVertical) = m_cScroll.Value(efsVertical) + lOffset
            pbEnsureVisibleY = (m_cScroll.Value(efsVertical) <> lValue)
         End If
      End If
   Else
      ' Have to shift y upwards:
      If (lYStart < m_lStartY) Then
         lOffset = lYStart - m_lStartY - 8
         lValue = m_cScroll.Value(efsVertical)
         m_cScroll.Value(efsVertical) = m_cScroll.Value(efsVertical) + lOffset
         pbEnsureVisibleY = (m_cScroll.Value(efsVertical) <> lValue)
      End If
   End If
   
End Function

Private Sub GetStartEndCell( _
      ByRef iStartRow As Long, ByRef iStartCol As Long, _
      ByRef iStartX As Long, ByRef iStartY As Long, _
      ByRef iEndRow As Long, ByRef iEndCol As Long, _
      ByRef iEndX As Long, ByRef iEndY As Long _
   )
Dim i As Long

   iStartCol = 0: iEndCol = m_iCols
   For i = 1 To m_iCols
      If (m_tCols(i).bVisible) And (i <> m_iRowTextCol) Then
         If (iStartCol = 0) Then
            If (m_tCols(i).lStartX + m_tCols(i).lWidth > m_lStartX) Then
               iStartCol = i
               iStartX = m_tCols(i).lStartX - m_lStartX
            End If
         End If
         iEndCol = i
         iEndX = m_tCols(i).lStartX - m_lStartX + m_tCols(i).lWidth
         If (m_tCols(i).lStartX > m_lStartX + m_lAvailWidth) Then
            Exit For
         End If
      End If
   Next i
   iStartRow = 0: iEndRow = m_iRows
   For i = 1 To m_iRows
      If (m_tvRows(m_vIRow(i)).bVisible) Then
         
         If (iStartRow = 0) Or iStartRow > i Then
            
            If m_tvRows(m_vIRow(i)).lStartY + m_tvRows(m_vIRow(i)).lHeight > m_lStartY Then
               iStartRow = i
               iStartY = m_tvRows(m_vIRow(i)).lStartY - m_lStartY
               If m_tvRows(m_vIRow(i)).bGroupRow Then
                  iEndCol = m_iCols
               End If
            End If
         
         Else
         
           If m_tvRows(m_vIRow(i)).bGroupRow Then
              iEndCol = m_iCols
           End If
           iEndRow = i
           iEndY = m_tvRows(m_vIRow(i)).lStartY - m_lStartY + m_tvRows(m_vIRow(i)).lHeight
           If (m_tvRows(m_vIRow(i)).lStartY > m_lStartY + m_lAvailheight) Then
              Exit For
           End If
           
         End If
      End If
   Next i
   
End Sub

Public Sub CellFromPoint( _
    ByVal xPixels As Long, _
    ByVal yPixels As Long, _
    ByRef lRow As Long, _
    ByRef lCol As Long _
  )
Attribute CellFromPoint.VB_Description = "Gets the cell which contains the given X,Y coordinates (relative to the grid) in pixels."
Dim iCol As Long
Dim iRow As Long
Dim lOffset As Long

  lOffset = Abs(m_cHeader.Visible) * m_cHeader.Height

  xPixels = xPixels + m_lStartX
  yPixels = yPixels + m_lStartY - lOffset
  lCol = 0: lRow = 0
  For iRow = 1 To m_iRows
    If (m_tvRows(m_vIRow(iRow)).bVisible) Then
      If (yPixels > m_tvRows(m_vIRow(iRow)).lStartY) And (yPixels <= m_tvRows(m_vIRow(iRow)).lStartY + m_tvRows(m_vIRow(iRow)).lHeight) Then
        lRow = iRow
        Exit For
      End If
    End If
  Next iRow
  If (iRow = 0) Then
    iCol = 0
  End If
  
  If m_tvRows(m_vIRow(lRow)).bGroupRow Then
    lCol = m_iRowTextCol
  Else
    For iCol = 1 To m_iCols
      If (m_tCols(iCol).bVisible) And (iCol <> m_iRowTextCol) Then
        If (xPixels > m_tCols(iCol).lStartX) And (xPixels <= m_tCols(iCol).lStartX + m_tCols(iCol).lWidth) Then
          lCol = m_tCols(iCol).lCellColIndex
          Exit For
        End If
      End If
    Next iCol
  End If
End Sub

Public Sub CellBoundary( _
      ByVal lRow As Long, _
      ByVal lCol As Long, _
      ByRef lLeft As Long, _
      ByRef lTop As Long, _
      ByRef lWidth As Long, _
      ByRef lHeight As Long _
   )
Attribute CellBoundary.VB_Description = "Gets the co-ordinates of the bounding rectangle for a cell in the grid, in twips."
Dim lOffsetY As Long
Dim lOffsetX As Long
Dim iCol As Long
Dim lCellCol As Long

   For iCol = 1 To m_iCols
      If (m_tCols(iCol).lCellColIndex = lCol) Then
         lCellCol = iCol
         Exit For
      End If
   Next iCol

   lOffsetY = Abs(m_bHeader) * m_cHeader.Height
   lOffsetX = m_tvCells(lCol, m_vIRow(lRow)).lIndent + (Abs(m_tvCells(lCol, m_vIRow(lRow)).iIconIndex <> -1) * m_lIconSizeX) + (Abs(m_tvCells(lCol, m_vIRow(lRow)).lExtraIconIndex <> -1) * m_lIconSizeX) + (Abs(m_tvCells(lCol, m_vIRow(lRow)).lGroupIconIndex <> -1) * m_lIconSizeGroupX)
   lLeft = (m_tCols(lCellCol).lStartX - m_lStartX + lOffsetX) * Screen.TwipsPerPixelX + 30
   lTop = ((m_tvRows(m_vIRow(lRow)).lStartY - m_lStartY) + lOffsetY) * Screen.TwipsPerPixelY + 10
   lWidth = (m_tCols(lCellCol).lWidth - lOffsetX) * Screen.TwipsPerPixelX
   lHeight = m_tvRows(m_vIRow(lRow)).lHeight * Screen.TwipsPerPixelY
   
End Sub
Public Sub EnsureVisible( _
      ByVal lRow As Long, _
      ByVal lCol As Long _
   )
Dim iCol As Long
   If pbValid(lRow, lCol) Then
      If m_tvRows(m_vIRow(lRow)).bVisible Then
         If m_tCols(lCol).bVisible Or m_tvRows(m_vIRow(lRow)).bGroupRow Then
            ' If rowtext column, choose the start pos based on the
            ' grid's settings:
            If m_tCols(lCol).bRowTextCol Or m_tvRows(m_vIRow(lRow)).bGroupRow Then
               lCol = 0
               If m_lRowTextStartCol > 0 Then
                  lCol = m_lRowTextStartCol
               Else
                  For iCol = 1 To m_iCols
                     If m_tCols(iCol).bIncludeInSelect And m_tCols(iCol).bVisible Then
                        lCol = iCol
                        Exit For
                     End If
                  Next iCol
               End If
            End If
            ' Call inbuild ensure visible method:
            If lCol > 0 Then
               pbEnsureVisible lRow, lCol
            End If
         Else
            ' can't ensure an invisible col visible... Don't raise error
         End If
      Else
         ' can't ensure an invisible row visible...  Don't raise error
      End If
   End If
End Sub
Public Sub ClearSelection()
'  19/10/99 4)
Dim lRow As Long
Dim lCol As Long
   If m_bMultiSelect Then
      For lRow = 1 To m_iRows
         For lCol = 1 To m_iCols
            m_tvCells(lCol, m_vIRow(lRow)).bDirtyFlag = m_tvCells(lCol, m_vIRow(lRow)).bSelected
            m_tvCells(lCol, m_vIRow(lRow)).bSelected = False
         Next lCol
      Next lRow
      Draw
   Else
      If m_iSelRow > 0 And m_iSelRow <= m_iRows Then
         If m_bRowMode Then
            For lCol = 1 To m_iCols
               m_tvCells(lCol, m_vIRow(m_iSelRow)).bDirtyFlag = m_tvCells(lCol, m_vIRow(m_iSelRow)).bSelected
               m_tvCells(lCol, m_vIRow(m_iSelRow)).bSelected = False
            Next lCol
         Else
            If m_iSelCol > 0 And m_iSelCol <= m_iCols Then
               m_tvCells(m_iSelCol, m_vIRow(m_iSelRow)).bDirtyFlag = True
               m_tvCells(m_iSelCol, m_vIRow(m_iSelRow)).bSelected = False
            End If
         End If
      End If
      m_iSelRow = 0: m_iSelCol = 0
      Draw
   End If
End Sub
Public Property Get hWnd() As Long
'  19/10/99 1)
   hWnd = UserControl.hWnd
End Property
Public Function AddColumn( _
      Optional ByVal vKey As String, _
      Optional ByVal sHeader As String, _
      Optional ByVal eAlign As ECGHdrTextAlignFlags, _
      Optional ByVal iIconIndex As Long = -1, _
      Optional ByVal lColumnWidth As Long = -1, _
      Optional ByVal bVisible As Boolean = True, _
      Optional ByVal bFixed As Boolean = False, _
      Optional ByVal vKeyBefore As Variant, _
      Optional ByVal bIncludeInSelect As Boolean = True, _
      Optional ByVal sFmtString As String, _
      Optional ByVal bRowTextColumn As Boolean = False, _
      Optional ByVal eSortType As cShellSortTypeConstants = CCLSortString _
   ) As Long
Dim i As Long
Dim lColBefore As Long
Dim lCol As Long
Dim iRow As Long
   
   ' Check for valid key:
   If Not (pbIsValidColumnKey(vKey)) Then
      Exit Function
   End If
   
   If (bRowTextColumn) Then
      m_bHasRowText = True
   End If
   
   ' If key valid then check for valid key after:
   If Not IsMissing(vKeyBefore) Then
      lColBefore = ColumnIndex(vKeyBefore)
      If (lColBefore < 1) Then
         Exit Function
      End If
   End If
   
   ' Correct missing params:
   If (lColumnWidth = -1) Then
      lColumnWidth = m_lDefaultColumnWidth
   End If
   
   ' All ok, add the column:
   ReDim Preserve m_tCols(0 To m_iCols + 1) As tColPosition
   If (lColBefore <> 0) Then
      For lCol = m_iCols + 1 To lColBefore Step -1
         LSet m_tCols(lCol) = m_tCols(lCol - 1)
         m_tCols(lCol).lCellColIndex = m_tCols(lCol).lCellColIndex + 1
      Next lCol
      lCol = lColBefore
   Else
      lCol = m_iCols + 1
   End If
         
   With m_tCols(lCol)
      .lCellColIndex = lCol
      .lOriginalColIndex = lCol
      .sKey = vKey
      .bIncludeInSelect = bIncludeInSelect
      .sHeader = sHeader
      .iIconIndex = iIconIndex
      .eTextAlign = eAlign
      .sFmtString = sFmtString
      .bVisible = bVisible
      .eSortType = eSortType
   End With
   If (bRowTextColumn) Then
      m_iRowTextCol = lCol
   Else
      ' If have row text then when a column is added we have to
      ' increment Column rowtext index
      If m_bHasRowText Then
        m_iRowTextCol = m_iRowTextCol + 1
      End If
   End If
   m_iCols = m_iCols + 1
   ColumnWidth(lCol) = lColumnWidth
   '
   If m_iRows > 0 Then
      ' (12) We need to add the extra data to the grid!
      pAddColToGridArray lCol
   End If

   ' Add to header:
   If (m_tCols(lCol).bVisible) Then
      SetHeaders
   End If
   
End Function
Private Sub pAddColToGridArray(ByVal lCol As Long)
Dim iRow As Long
Dim iCol As Long
Dim iACol As Long
Dim tGridCopy() As tGridCell

   ' As with removing rows, this is quite a painful proc!
   ' you are advised to add columns first then rows...
   ReDim tGridCopy(1 To m_iCols, 1 To m_iRows) As tGridCell
   For iRow = 1 To m_iRows
      For iCol = 1 To m_iCols - 1
         If (iCol >= lCol) Then
            iACol = iCol + 1
         Else
            iACol = iCol
         End If
         LSet tGridCopy(iACol, iRow) = m_tvCells(iCol, m_vIRow(iRow))
      Next iCol
   Next iRow
   
   ReDim m_tvCells(1 To m_iCols, 1 To m_iRows) As tGridCell
   
   For iRow = 1 To m_iRows
      For iCol = 1 To m_iCols
         If iCol = lCol Then
            LSet m_tvCells(iCol, m_vIRow(iRow)) = m_tDefaultCell
         Else
            LSet m_tvCells(iCol, m_vIRow(iRow)) = tGridCopy(iCol, iRow)
         End If
      Next iCol
   Next iRow
End Sub

Public Sub RemoveColumn( _
      ByVal vKey As Variant _
   )
Attribute RemoveColumn.VB_Description = "Permanently removes a column from the grid.  If all columns are removed, the grid will be cleared.  If you want to temporarily remove a column, use the ColumnVisible property."
Dim lCol As Long
Dim iRow As Long
Dim iCol As Long
Dim iCCol As Long
Dim lGridCol As Long
Dim tGridCopy() As tGridCell

   lCol = ColumnIndex(vKey)
   If (lCol <> 0) Then
      ' 19/10/99: (7)
      If m_tCols(lCol).bRowTextCol Then
         m_iRowTextCol = 0
         m_lRowTextStartCol = 0
         m_bHasRowText = False
      End If
      
      ' Quite a lot of hacking to do here!
      If (m_iCols > 1) Then
         ' Make a copy of the grid:
         ReDim tGridCopy(1 To m_iCols, 1 To m_iRows) As tGridCell
         For iRow = 1 To m_iRows
            For iCol = 1 To m_iCols
               LSet tGridCopy(iCol, iRow) = m_tvCells(iCol, m_vIRow(iRow))
            Next iCol
         Next iRow
         
         ' Now remove the column:
         For iCol = 1 To m_iCols
            If (m_tCols(iCol).lCellColIndex = lCol) Then
               iCCol = iCol
               Exit For
            End If
         Next iCol
         For iCol = iCCol To m_iCols - 1
            LSet m_tCols(iCol) = m_tCols(iCol + 1)
         Next iCol
         
         m_iCols = m_iCols - 1
         If m_bHasRowText Then
            m_iRowTextCol = m_iRowTextCol - 1
         End If
         For iCol = 1 To m_iCols
            If (m_tCols(iCol).lCellColIndex > lCol) Then
               m_tCols(iCol).lCellColIndex = m_tCols(iCol).lCellColIndex - 1
            End If
         Next iCol
         ReDim Preserve m_tCols(0 To m_iCols) As tColPosition
         m_tCols(1).lStartX = 0
         ColumnWidth(1) = ColumnWidth(1)
         
         ' Having removed the column, rebuild the grid cells:
         ReDim m_tvCells(1 To m_iCols, 1 To m_iRows) As tGridCell
         
         For iRow = 1 To m_iRows
            For iCol = 1 To m_iCols
               If (iCol >= lCol) Then
                  lGridCol = iCol + 1
               Else
                  lGridCol = iCol
               End If
               LSet m_tvCells(iCol, m_vIRow(iRow)) = tGridCopy(lGridCol, iRow)
            Next iCol
         Next iRow
         
         ' Set the headers back up if required:
         If (m_bHeader) Then
            SetHeaders
         End If
         
         ' Now redraw:
         m_bDirty = True
         Draw
         
      Else
         ' No columns, no grid!
         m_iCols = 0
         m_iRows = 0
         ReDim m_vtRows(0 To 0) As tRowPosition
         ReDim m_tCols(0 To 0) As tColPosition
         Erase m_tvCells
         pRedimvIRow False, 0
         
         ' Set the headers back up if required:
         If (m_bHeader) Then
            SetHeaders
         End If
                  
         m_bDirty = True
         Draw
      End If
   End If
End Sub
Public Sub SetHeaders()
Attribute SetHeaders.VB_Description = "Populates the headers in the control based on the columns in the grid.  Called automatically by the control when Headers is set to True."
Dim i As Long
   For i = m_cHeader.ColumnCount To 1 Step -1
      m_cHeader.RemoveColumn i - 1
   Next i
   For i = 1 To m_iCols
      If (m_tCols(i).bVisible) And (i <> m_iRowTextCol) Then
         m_cHeader.AddColumn m_tCols(i).sHeader, m_tCols(i).lWidth, pGetAlignHeader(m_tCols(i).eTextAlign), , m_tCols(i).iIconIndex
         If (m_tCols(i).bImageOnRight) Then
            m_cHeader.ColumnImageOnRight(m_cHeader.ColumnCount - 1) = True
         End If
         m_tCols(i).lHeadercolIndex = m_cHeader.ColumnCount
      Else
         m_tCols(i).lHeadercolIndex = 0
      End If
   Next i
   pResizeHeader
End Sub
Public Property Get ColumnIndex(ByVal vKey As Variant)
Attribute ColumnIndex.VB_Description = "Gets the index of a column with the specified key."
Dim lIndex As Long
   lIndex = plColumnIndex(vKey)
   If (lIndex > 0) And (lIndex <= m_iCols) Then
      ColumnIndex = lIndex
   Else
      ColumnIndex = 0
      
      ' JAV- Por ahora la vamos a dejar mas silenciosa
      '
      
      'Err.Raise 9, App.EXEName & ".cGrid"
   End If
End Property
Private Function plColumnIndex(ByVal vKey As Variant)
Dim i As Long
Dim lIndex As Long

   If IsNumeric(vKey) Then
      ' return the index of this column in the column header array
      For i = 1 To m_iCols
         If (m_tCols(i).lCellColIndex = vKey) Then
            lIndex = i
            Exit For
         End If
      Next i
   Else
      For i = 1 To m_iCols
         If (m_tCols(i).sKey = vKey) Then
            lIndex = i
            Exit For
         End If
      Next i
   End If
   plColumnIndex = lIndex
   
End Function

Public Property Get OriginalColumnIndex(ByVal vKey As Variant)
Dim lIndex As Long
   lIndex = plOriginalColumnIndex(vKey)
   If (lIndex > 0) And (lIndex <= m_iCols) Then
      OriginalColumnIndex = m_Groups.Count + lIndex
   Else
      OriginalColumnIndex = 0
      
      ' JAV- Por ahora la vamos a dejar mas silenciosa
      '
      
      'Err.Raise 9, App.EXEName & ".cGrid"
   End If
End Property
Private Function plOriginalColumnIndex(ByVal vKey As Variant)
Dim i As Long
Dim lIndex As Long

   If IsNumeric(vKey) Then
      ' return the index of this column in the column header array
      For i = 1 To m_iCols
         If (m_tCols(i).lCellColIndex = vKey) Then
            lIndex = m_tCols(i).lOriginalColIndex
            Exit For
         End If
      Next i
   Else
      For i = 1 To m_iCols
         If (m_tCols(i).sKey = vKey) Then
            lIndex = m_tCols(i).lOriginalColIndex
            Exit For
         End If
      Next i
   End If
   plOriginalColumnIndex = lIndex
   
End Function

Public Property Get ColumnImage(ByVal vKey As Variant) As Long
Attribute ColumnImage.VB_Description = "Gets/sets the image index to show in a column's header. Image indexes are 0 based indexes of the images in an  ImageList."
Dim lCol As Long
   lCol = ColumnIndex(vKey)
   If (lCol <> 0) Then
      ColumnImage = m_tCols(lCol).iIconIndex
   End If
End Property
Public Property Let ColumnImage(ByVal vKey As Variant, ByVal lImage As Long)
Dim lCol As Long
   lCol = ColumnIndex(vKey)
   If (lCol <> 0) Then
      m_tCols(lCol).iIconIndex = lImage
      If (m_tCols(lCol).bVisible) And lCol <> m_iRowTextCol Then
         m_cHeader.ColumnImage(m_tCols(lCol).lHeadercolIndex - 1) = lImage
      End If
   End If
End Property
Public Property Get ColumnImageOnRight(ByVal vKey As Variant) As Boolean
Attribute ColumnImageOnRight.VB_Description = "Gets/sets whether images (if any) will be shown on the right or not in a column header."
Dim lCol As Long
   lCol = ColumnIndex(vKey)
   If (lCol <> 0) Then
      ColumnImageOnRight = m_tCols(lCol).bImageOnRight
   End If
End Property
Public Property Let ColumnImageOnRight(ByVal vKey As Variant, ByVal bState As Boolean)
Dim lCol As Long
   lCol = ColumnIndex(vKey)
   If (lCol <> 0) Then
      m_tCols(lCol).bImageOnRight = bState
      If (m_tCols(lCol).bVisible) And lCol <> m_iRowTextCol Then
         m_cHeader.ColumnImageOnRight(m_tCols(lCol).lHeadercolIndex - 1) = bState
      End If
   End If
End Property
Public Property Get ColumnEditOnClick(ByVal vKey As Variant) As Boolean
Dim lCol As Long
   lCol = ColumnIndex(vKey)
   If (lCol <> 0) Then
      ColumnEditOnClick = m_tCols(lCol).bEditOnClick
   End If
End Property
Public Property Let ColumnEditOnClick(ByVal vKey As Variant, ByVal bState As Boolean)
Dim lCol As Long
   lCol = ColumnIndex(vKey)
   If (lCol <> 0) Then
      m_tCols(lCol).bEditOnClick = bState
   End If
End Property
Public Property Get ColumnAlign(ByVal vKey As Variant) As ECGHdrTextAlignFlags
Attribute ColumnAlign.VB_Description = "Gets/sets the alignment used to draw the column header for a column."
Dim lCol As Long
   lCol = ColumnIndex(vKey)
   If (lCol <> 0) Then
      ColumnAlign = m_tCols(lCol).eTextAlign
   End If
End Property
Public Property Let ColumnAlign(ByVal vKey As Variant, ByVal eAlign As ECGHdrTextAlignFlags)
Dim lCol As Long
   lCol = ColumnIndex(vKey)
   If (lCol <> 0) Then
      m_tCols(lCol).eTextAlign = eAlign
      If (m_tCols(lCol).bVisible) And lCol <> m_iRowTextCol Then
         m_cHeader.ColumnTextAlign(m_tCols(lCol).lHeadercolIndex - 1) = pGetAlignHeader(eAlign)
      End If
   End If
   
End Property

Public Property Get ColumnKey(ByVal lCol As Long) As String
Attribute ColumnKey.VB_Description = "Gets/sets the key for column."
Dim iCol As Long
   If (lCol > 0) Then
      For iCol = 1 To m_iCols
         If (m_tCols(iCol).lCellColIndex = lCol) Then
            ColumnKey = m_tCols(iCol).sKey
            Exit For
         End If
      Next iCol
   Else
      'Err.Raise 9, App.EXEName & ".cGrid"
   End If
End Property
Public Property Let ColumnKey(ByVal lCol As Long, ByVal sKey As String)
   If (lCol > 0) Then
      If (m_tCols(lCol).sKey <> sKey) Then
         If (pbIsValidColumnKey(sKey)) Then
            m_tCols(lCol).sKey = sKey
         End If
      End If
   Else
      'Err.Raise 9, App.EXEName & ".cGrid"
   End If

End Property
Public Property Get ColumnTag(ByVal lCol As Long) As String
Attribute ColumnTag.VB_Description = "Gets/sets a tag string associated with a column in the grid."
   If (lCol > 0) Then
      ColumnTag = m_tCols(lCol).sTag
   Else
      'Err.Raise 9, App.EXEName & ".cGrid"
   End If
End Property
Public Property Let ColumnTag(ByVal lCol As Long, ByVal sTag As String)
   If (lCol > 0) Then
      If (m_tCols(lCol).sTag <> sTag) Then
         m_tCols(lCol).sTag = sTag
      End If
   Else
      'Err.Raise 9, App.EXEName & ".cGrid"
   End If

End Property

Private Function pbIsValidColumnKey(ByVal sKey As String) As Boolean
Dim i As Long
   If LenB(sKey) Then
      For i = 1 To m_iCols
         If (m_tCols(i).sKey = sKey) Then
            'Err.Raise 457, App.EXEName & ".cGrid"
            Exit Function
         End If
      Next i
   End If
   pbIsValidColumnKey = True
End Function

Public Sub ScrollVerticalForceShowHide()
  m_cScroll.Visible(efsVertical) = False
  pScrollVisible
End Sub

Public Sub pScrollVisible()
Dim tR As RECT
Dim bHorz As Boolean
Dim bVert As Boolean
Dim lProportion As Long
Dim iLastRow As Long
Dim iCol As Long
   
   GetWindowRect UserControl.hWnd, tR
   m_lAvailWidth = tR.Right - tR.Left - (UserControl.BorderStyle * 4)
   m_lAvailheight = tR.Bottom - tR.Top - (UserControl.BorderStyle * 4)
   If (m_bHeader) Then
      m_lAvailheight = m_lAvailheight - m_cHeader.Height
   End If
   
   For iCol = 1 To m_iCols
      If (m_tCols(iCol).bVisible) And (m_tCols(iCol).lCellColIndex <> m_iRowTextCol) Then
         m_lGridWidth = m_tCols(iCol).lStartX + m_tCols(iCol).lWidth
      End If
   Next iCol
   
   iLastRow = plGetLastVisibleRow()
   'If (m_bIsVirtual And m_bInVirtualRequest) Then
   '   ' Make the grid pretend to be bigger than it is:
   '   m_lGridHeight = m_tvRows(m_vIRow(m_iRows)).lStartY + m_tvRows(m_vIRow(m_iRows)).lHeight + m_lDefaultRowHeight
   'Else
      m_lGridHeight = m_tvRows(m_vIRow(iLastRow)).lStartY + m_tvRows(m_vIRow(iLastRow)).lHeight
   'End If
      
   ' Check horizontal:
   If (m_lGridWidth > m_lAvailWidth) Then
      bHorz = True
   End If
   If (m_lGridHeight > m_lAvailheight) Then
      bVert = True
   End If
   If Not (bVert And bHorz) Then
      If (bVert) Then
         If (m_bAllowVert) Then
            m_lAvailWidth = m_lAvailWidth - GetSystemMetrics(SM_CXVSCROLL) - 4
         End If
         If (m_lGridWidth > m_lAvailWidth) Then
            bHorz = True
         End If
      ElseIf (bHorz) Then
         If (m_bAllowHorz) Then
            m_lAvailheight = m_lAvailheight - GetSystemMetrics(SM_CYHSCROLL) - 4
         End If
         If (m_lGridHeight > m_lAvailheight) Then
            bVert = True
         End If
      End If
   Else
      If (m_bAllowHorz) Then
         m_lAvailWidth = m_lAvailWidth - GetSystemMetrics(SM_CXVSCROLL) - 4
      End If
      If (m_bAllowVert) Then
         m_lAvailheight = m_lAvailheight - GetSystemMetrics(SM_CYHSCROLL) - 4
      End If
   End If
   
   ' Set visibility:
   If m_cScroll.Visible(efsHorizontal) <> bHorz Then
      If Not (bHorz And m_bAllowHorz) Then
         m_cScroll.Value(efsHorizontal) = 0
      End If
      m_cScroll.Visible(efsHorizontal) = bHorz And m_bAllowHorz
      pResizeHeader
   End If
   If m_cScroll.Visible(efsVertical) <> bVert Then
      If Not (bVert And m_bAllowVert) Then
         m_cScroll.Value(efsHorizontal) = 0
      End If
      m_cScroll.Visible(efsVertical) = bVert And m_bAllowVert
   End If
      
   ' Check scaling:
   m_lStartX = 0: m_lStartY = 0
   If (bHorz) Then
      With m_cScroll
         If (bVert) Then
            m_lAvailWidth = m_lAvailWidth - GetSystemMetrics(SM_CXVSCROLL) + 4
         End If
         If (.Max(efsHorizontal) <> m_lGridWidth - m_lAvailWidth) Then
            .Max(efsHorizontal) = m_lGridWidth - m_lAvailWidth
            If (m_lAvailWidth > 0) Then
               lProportion = ((m_lGridWidth - m_lAvailWidth) \ m_lAvailWidth) + 1
               .LargeChange(efsHorizontal) = (m_lGridWidth - m_lAvailWidth) \ lProportion
               .SmallChange(efsHorizontal) = 20
            End If
            pResizeHeader
         End If
         m_lStartX = m_cScroll.Value(efsHorizontal)
      End With
   End If
   If (bVert) Then
      With m_cScroll
         If (bHorz) Then
            m_lAvailheight = m_lAvailheight - GetSystemMetrics(SM_CYHSCROLL) + 4
         End If
         'If (m_bIsVirtual And m_bInVirtualRequest) Then
         '   .Max(efsVertical) = m_lGridHeight + m_lDefaultRowHeight - m_lAvailheight
         'Else
            .Max(efsVertical) = m_lGridHeight - m_lAvailheight
         'End If
         If (m_lAvailheight > 0) Then
            lProportion = ((m_lGridHeight - m_lAvailheight) \ m_lAvailheight) + 1
            .LargeChange(efsVertical) = (m_lGridHeight - m_lAvailheight) \ lProportion
            .SmallChange(efsVertical) = m_lDefaultRowHeight
         End If
         m_lStartY = m_cScroll.Value(efsVertical)
      End With
   End If

End Sub

Public Property Get Header() As Boolean
Attribute Header.VB_Description = "Gets/sets whether the grid has a header or not."
Attribute Header.VB_ProcData.VB_Invoke_Property = ";Behavior"
   Header = m_bHeader
End Property
Public Property Let Header(ByVal bState As Boolean)
   m_bHeader = bState
   m_cHeader.Visible = bState
   pResizeHeader
   PropertyChanged "Header"
End Property
Public Property Get HeaderFlat() As Boolean
   HeaderFlat = m_bHeaderFlat
End Property
Public Property Let HeaderFlat(ByVal bState As Boolean)
   m_bHeaderFlat = bState
   If Not (m_cFlatHeader Is Nothing) Then
      If bState Then
         m_cFlatHeader.Attach UserControl.hWnd
      Else
         m_cFlatHeader.Detach
      End If
   End If
   PropertyChanged "Header"
End Property
Public Property Get HeaderHeight() As Long
   HeaderHeight = m_cHeader.Height
End Property
Public Property Let HeaderHeight(ByVal lHeight As Long)
   m_cHeader.Height = lHeight
   pResizeHeader
   Draw
   PropertyChanged "HeaderHeight"
End Property
Public Property Get HeaderDragReOrderColumns() As Boolean
Attribute HeaderDragReOrderColumns.VB_Description = "Gets/sets whether the grid's header columns can be dragged around to reorder them."
Attribute HeaderDragReOrderColumns.VB_ProcData.VB_Invoke_Property = ";Behavior"
   HeaderDragReOrderColumns = m_cHeader.DragReOrderColumns
End Property
Public Property Let HeaderDragReOrderColumns(ByVal bState As Boolean)
   m_cHeader.DragReOrderColumns = bState
   SetHeaders
   PropertyChanged "HeaderDragReOrderColumns"
End Property
Public Property Get HeaderButtons() As Boolean
Attribute HeaderButtons.VB_Description = "Gets/sets whether the grid's header has clickable buttons or not."
Attribute HeaderButtons.VB_ProcData.VB_Invoke_Property = ";Behavior"
   HeaderButtons = m_cHeader.HasButtons
End Property
Public Property Let HeaderButtons(ByVal bState As Boolean)
   m_cHeader.HasButtons = bState
   SetHeaders
   PropertyChanged "HeaderButtons"
End Property
Public Property Get HeaderHotTrack() As Boolean
Attribute HeaderHotTrack.VB_Description = "Gets/sets whether the grid's header tracks mouse movements and highlights the header column the mouse is over or not."
Attribute HeaderHotTrack.VB_ProcData.VB_Invoke_Property = ";Behavior"
   HeaderHotTrack = m_cHeader.HotTrack
End Property
Public Property Let HeaderHotTrack(ByVal bState As Boolean)
   m_cHeader.HotTrack = bState
   SetHeaders
   PropertyChanged "HeaderHotTrack"
End Property
Private Function pbValid(ByVal lRow As Long, ByVal lCol As Long) As Boolean
   If (lCol > 0) And (lCol <= m_iCols) Then
      If (lRow > 0) And (lRow <= m_iRows) Then
         pbValid = True
      Else
         'Err.Raise 9, App.EXEName & ".cGrid", "Invalid Row Index"
      End If
   Else
      'Err.Raise 9, App.EXEName & ".cGrid", "Invalid Column Index"
   End If
End Function
Public Sub CellDetails( _
      ByVal lRow As Long, ByVal lCol As Long, _
      Optional ByVal sText As Variant, _
      Optional ByVal eTextAlign As ECGTextAlignFlags = DT_WORD_ELLIPSIS Or DT_SINGLELINE, _
      Optional ByVal lIconIndex As Long = -1, _
      Optional ByVal OBackColor As OLE_COLOR = CLR_NONE, _
      Optional ByVal OForeColor As OLE_COLOR = CLR_NONE, _
      Optional ByVal oFont As StdFont = Nothing, _
      Optional ByVal lIndent As Long = 0, _
      Optional ByVal lExtraIconIndex As Long = -1, _
      Optional ByVal lItemData As Long = 0 _
   )
Attribute CellDetails.VB_Description = "Sets multiple format details for a cell at the same time. Quicker than calling the properties individually."
   If (lRow > m_iRows) Then
      Rows = lRow
   End If
   If pbValid(lRow, lCol) Then
      With m_tvCells(lCol, m_vIRow(lRow))
         .sText = sText
         .eTextFlags = eTextAlign Or DT_NOPREFIX
         .bDirtyFlag = True
         .OBackColor = OBackColor
         .OForeColor = OForeColor
         .iIconIndex = lIconIndex
         .lExtraIconIndex = lExtraIconIndex
         .lIndent = lIndent
         If Not (oFont Is Nothing) Then
            .IFntIndex = plAddFontIfRequired(oFont)
         End If
         .bDirtyFlag = True
         .lItemData = lItemData
      End With
      Draw
   End If
End Sub
Public Property Get Cell(ByVal lRow As Long, ByVal lCol As Long) As cGridCell
   If pbValid(lRow, lCol) Then
      Dim cS As New cGridCell
      With cS
         .BackColor = CellBackColor(lRow, lCol)
         .ForeColor = CellForeColor(lRow, lCol)
         If (m_tvCells(lCol, m_vIRow(lRow)).IFntIndex = 0) Then
            If Not .Font Is Nothing Then
               .Font = Nothing
            End If
            Set .Font = UserControl.Font
         Else
            Set .Font = CellFont(lRow, lCol)
         End If
         .IconIndex = CellIcon(lRow, lCol)
         .ExtraIconIndex = CellExtraIcon(lRow, lCol)
         .GroupIconIndex = CellExtraIcon(lRow, lCol)
         .Indent = CellIndent(lRow, lCol)
         .TextAlign = CellTextAlign(lRow, lCol)
         .Text = CellText(lRow, lCol)
         .ItemData = CellItemData(lRow, lCol)
         .Tag = CellTag(lRow, lCol)
         .Init Me, lRow, lCol
      End With
      Set Cell = ObjectFromPtr(ObjPtr(cS))
   End If
End Property
Public Property Let Cell(ByVal lRow As Long, ByVal lCol As Long, ByRef cG As cGridCell)
   CellDetails lRow, lCol, cG.Text, cG.TextAlign, cG.IconIndex, cG.BackColor, cG.ForeColor, cG.Font, cG.Indent, cG.ExtraIconIndex
End Property

Public Property Get NewCellFormatObject() As cGridCell
   Dim cS As New cGridCell
   Set NewCellFormatObject = ObjectFromPtr(ObjPtr(cS))
End Property

Private Function plAddFontIfRequired(ByVal oFont As StdFont) As Long
Dim iFnt As Long
Dim tULF As LOGFONT
   For iFnt = 1 To m_iFontCount
      If (oFont.Name = m_Fnt(iFnt).Name) And (oFont.Bold = m_Fnt(iFnt).Bold) And (oFont.Italic = m_Fnt(iFnt).Italic) And (oFont.Underline = m_Fnt(iFnt).Underline) And (oFont.Size = m_Fnt(iFnt).Size) And (oFont.Strikethrough = m_Fnt(iFnt).Strikethrough) Then
         plAddFontIfRequired = iFnt
         Exit Function
      End If
   Next iFnt
   m_iFontCount = m_iFontCount + 1
   ReDim Preserve m_Fnt(1 To m_iFontCount) As StdFont
   ReDim Preserve m_hFnt(1 To m_iFontCount) As Long
   Set m_Fnt(m_iFontCount) = New StdFont
   With m_Fnt(m_iFontCount)
      .Name = oFont.Name
      .Size = oFont.Size
      .Bold = oFont.Bold
      .Italic = oFont.Italic
      .Underline = oFont.Underline
      .Strikethrough = oFont.Strikethrough
   End With
   pOLEFontToLogFont m_Fnt(m_iFontCount), UserControl.hdc, tULF
   m_hFnt(m_iFontCount) = CreateFontIndirect(tULF)
   plAddFontIfRequired = m_iFontCount
End Function
Public Property Get RowHeight(ByVal lRow As Long) As Long
Attribute RowHeight.VB_Description = "Gets/sets the height of a row in the grid."
   If (lRow > 0) And (lRow <= m_iRows) Then
      RowHeight = m_tvRows(m_vIRow(lRow)).lHeight
   Else
      'Err.Raise 9, App.EXEName, "Invalid Row Subscript"
   End If
End Property

Public Property Let RowHeight(ByVal lRow As Long, ByVal lHeight As Long)
  pRowHeight lRow, lHeight, True
End Property

Private Sub pRowHeight(ByVal lRow As Long, ByVal lHeight As Long, ByVal bChangeOriginalHeight As Boolean)
Dim lCalcRow As Long
Dim lPreviousRowHeight As Long
Dim lPreviousStartY As Long

   If (lRow > 0) Then
      If (lRow > m_iRows) Then
         
         pRedimvIRow True, lRow
         ReDim Preserve m_tvRows(0 To lRow) As tRowPosition
         
         For lCalcRow = m_iRows + 1 To lRow
            m_tvRows(m_vIRow(lCalcRow)).bVisible = True
            m_tvRows(m_vIRow(lCalcRow)).lHeight = m_lDefaultRowHeight
            If bChangeOriginalHeight Then m_tvRows(m_vIRow(lCalcRow)).lOriginalHeigth = m_lDefaultRowHeight
            m_tvRows(m_vIRow(lCalcRow)).lStartY = m_tvRows(m_vIRow(lCalcRow - 1)).lStartY + m_tvRows(m_vIRow(lCalcRow - 1)).lHeight
         Next lCalcRow
         m_iRows = lRow
      End If
      m_tvRows(m_vIRow(lRow)).lHeight = lHeight
      If bChangeOriginalHeight Then m_tvRows(m_vIRow(lRow)).lOriginalHeigth = lHeight
      m_tvRows(m_vIRow(0)).lHeight = 0
      If bChangeOriginalHeight Then m_tvRows(m_vIRow(0)).lOriginalHeigth = 0
      For lCalcRow = lRow To m_iRows
         If (m_tvRows(m_vIRow(lCalcRow - 1)).bVisible) Then
            m_tvRows(m_vIRow(lCalcRow)).lStartY = m_tvRows(m_vIRow(lCalcRow - 1)).lStartY + m_tvRows(m_vIRow(lCalcRow - 1)).lHeight
         Else
            m_tvRows(m_vIRow(lCalcRow)).lStartY = m_tvRows(m_vIRow(lCalcRow - 1)).lStartY
         End If
      Next lCalcRow
      If (lHeight > m_lMaxRowHeight) Then
         BuildMemDC lHeight
      End If
   Else
      'Err.Raise 9, App.EXEName & ".cGrid", "Row subscript out of range"
   End If
End Sub
Private Sub BuildMemDC(ByVal lHeight As Long)
Dim tR As RECT
Dim hBr As Long
   If (m_hBmp <> 0) Then
      If (m_hBmpOld <> 0) Then
         SelectObject m_hDC, m_hBmpOld
      End If
      If (m_hBmp <> 0) Then
         DeleteObject m_hBmp
      End If
      m_hBmp = 0
      m_hBmpOld = 0
   End If
   If (m_hDC = 0) Then
      m_hDC = CreateCompatibleDC(UserControl.hdc)
   Else
      SelectObject m_hDC, m_hFntOldDC
   End If
   If (m_hDC <> 0) Then
      m_lMaxRowHeight = lHeight
      m_hBmp = CreateCompatibleBitmap(UserControl.hdc, Screen.Width \ Screen.TwipsPerPixelX, lHeight)
      If (m_hBmp <> 0) Then
         m_hBmpOld = SelectObject(m_hDC, m_hBmp)
         If (m_hBmpOld = 0) Then
            DeleteObject m_hBmp
            DeleteObject m_hDC
            m_hBmp = 0
            m_hDC = 0
         Else
            SetTextColor m_hDC, TranslateColor(UserControl.ForeColor)
            SetBkColor m_hDC, TranslateColor(UserControl.BackColor)
            SetBkMode m_hDC, TRANSPARENT
            m_hFntOldDC = SelectObject(m_hDC, m_hFntDC)
            tR.Right = Screen.Width \ Screen.TwipsPerPixelX
            tR.Bottom = lHeight
            hBr = CreateSolidBrush(TranslateColor(UserControl.BackColor))
            FillRect m_hDC, tR, hBr
            DeleteObject hBr
         End If
      Else
         DeleteObject m_hDC
         m_hDC = 0
      End If
   End If
End Sub
Public Property Get ColumnOrder(ByVal vKey As Variant) As Long
Attribute ColumnOrder.VB_Description = "Gets/sets the order of a column in the control."
Dim lCol As Long
   lCol = ColumnIndex(vKey)
   If (lCol > 0) Then
      ColumnOrder = lCol
   End If
End Property
Public Property Let ColumnOrder(ByVal vKey As Variant, ByVal lOrder As Long)
Dim lCol As Long
Dim tSwap As tColPosition
Dim lStartX As Long
Dim i As Long

   If Not lOrder > UBound(m_tCols) Or lOrder < LBound(m_tCols) Then
    
    lCol = ColumnIndex(vKey)
    If (lCol > 0) Then
       If (lCol <> lOrder) Then
          ' We want to swap item lCol in the m_tCols array with
          ' the item at position lOrder, then recreate the header
          LSet tSwap = m_tCols(lCol)
          LSet m_tCols(lCol) = m_tCols(lOrder)
          LSet m_tCols(lOrder) = tSwap
          For i = 1 To m_iCols
             m_tCols(i).lStartX = lStartX
             If (m_tCols(i).bVisible) Then
                lStartX = lStartX + m_tCols(i).lWidth
             End If
          Next i
          SetHeaders
          m_bDirty = True
          Draw
       End If
    End If
  End If
End Property
Public Property Get ColumnSortType(ByVal vKey As Variant) As cShellSortTypeConstants
Attribute ColumnSortType.VB_Description = "Gets/sets a variable which you can use to store the current column sort type."
Dim lCol As Long
   lCol = ColumnIndex(vKey)
   If (lCol > 0) Then
      ColumnSortType = m_tCols(lCol).eSortType
   End If
End Property
Public Property Let ColumnSortType(ByVal vKey As Variant, ByVal eSortType As cShellSortTypeConstants)
Dim lCol As Long
   lCol = ColumnIndex(vKey)
   If (lCol > 0) Then
      m_tCols(lCol).eSortType = eSortType
   End If
End Property
Public Property Get ColumnSortOrder(ByVal vKey As Variant) As cShellSortOrderCOnstants
Attribute ColumnSortOrder.VB_Description = "Gets/sets a variable which you can use to store the current column sort order."
Dim lCol As Long
   lCol = ColumnIndex(vKey)
   If (lCol > 0) Then
      ColumnSortOrder = m_tCols(lCol).eSortOrder
   End If
End Property
Public Property Let ColumnSortOrder(ByVal vKey As Variant, ByVal eSortOrder As cShellSortOrderCOnstants)
Dim lCol As Long
   lCol = ColumnIndex(vKey)
   If (lCol > 0) Then
      m_tCols(lCol).eSortOrder = eSortOrder
   End If
End Property

Public Property Get KeySearchColumn() As Long
Attribute KeySearchColumn.VB_Description = "Gets/sets the column in the grid to be used for automatic searching when the grid is not being edited.  Set to 0 to prevent automatic searching."
Attribute KeySearchColumn.VB_MemberFlags = "400"
   KeySearchColumn = m_iSearchCol
End Property
Public Property Let KeySearchColumn(ByVal lCol As Long)
   m_iSearchCol = lCol
End Property
Public Property Get ColumnWidth(ByVal vKey As Variant) As Long
Attribute ColumnWidth.VB_Description = "Gets/sets the width of a column in the grid."
Dim lCol As Long
   lCol = ColumnIndex(vKey)
   If (lCol > 0) Then
      ColumnWidth = m_tCols(lCol).lWidth
   End If
End Property
Public Property Let ColumnWidth(ByVal vKey As Variant, ByVal lWidth As Long)
Dim lCalcCol As Long
Dim lCellColIndex As Long
Dim lCol As Long
Dim lLastWidth As Long
Dim iVisibleCols As Long
   
   lCol = plColumnIndex(vKey)
   
   If (lCol > 0) Then
      If (lCol > m_iCols) Then
         ReDim Preserve m_tCols(0 To lCol) As tColPosition
         For lCalcCol = m_iCols + 1 To lCol
            m_tCols(lCalcCol).lWidth = m_lDefaultColumnWidth
            m_tCols(lCalcCol).bVisible = True
         Next lCalcCol
         m_iCols = lCol
      End If
      
      m_tCols(0).lWidth = 0
      m_tCols(lCol).lWidth = lWidth
      
      For lCalcCol = 1 To m_iCols
         If (m_tCols(lCalcCol).bVisible) Then
            m_tCols(lCalcCol).lStartX = m_tCols(lCalcCol - 1).lStartX + lLastWidth
            lLastWidth = m_tCols(lCalcCol).lWidth
         Else
            m_tCols(lCalcCol).lStartX = m_tCols(lCalcCol - 1).lStartX
         End If
      Next lCalcCol
               
      If (m_tCols(lCol).lHeadercolIndex) > 0 Then
         If m_cHeader.ColumnWidth(m_tCols(lCol).lHeadercolIndex - 1) <> lWidth Then
            m_cHeader.ColumnWidthEx m_tCols(lCol).lHeadercolIndex - 1, lWidth
            
            ' JAV- Veremos si funciona
            '
            m_bDirty = True
            Draw
            pResizeHeader
         End If
      End If
      
   Else
      'Err.Raise 9, App.EXEName & ".cGrid", "Column subscript out of range"
   End If

End Property
Public Property Get ColumnHeader(ByVal vKey As Variant) As String
Attribute ColumnHeader.VB_Description = "Gets/sets the text to appear in a column header."
Dim lCol As Long
   lCol = ColumnIndex(vKey)
   If (lCol > 0) Then
      ColumnHeader = m_tCols(lCol).sHeader
   End If
End Property
Public Property Let ColumnHeader(ByVal vKey As Variant, ByVal sHeader As String)
Dim lCol As Long
   lCol = ColumnIndex(vKey)
   If (lCol > 0) Then
      m_tCols(lCol).sHeader = sHeader
      If (m_tCols(lCol).bVisible) And lCol <> m_iRowTextCol Then
         m_cHeader.ColumnHeader(m_tCols(lCol).lHeadercolIndex - 1) = sHeader
      End If
   End If
End Property
Public Property Get ColumnFormatString(ByVal vKey As Variant) As String
Attribute ColumnFormatString.VB_Description = "Gets/sets a format string used to format all text in the column.  Format strings are the same as those used in the VB Format$ function."
Dim lCol As Long
   lCol = ColumnIndex(vKey)
   If (lCol > 0) Then
      ColumnFormatString = m_tCols(lCol).sFmtString
   End If
End Property
Public Property Let ColumnFormatString(ByVal vKey As Variant, ByVal sFmtString As String)
Dim lCol As Long
   lCol = ColumnIndex(vKey)
   If (lCol > 0) Then
      m_tCols(lCol).sFmtString = sFmtString
      If (m_tCols(lCol).bVisible) Then
         m_bDirty = True
         Draw
      End If
   End If
End Property

Public Property Get ColumnVisible(ByVal vKey As Variant) As Boolean
Attribute ColumnVisible.VB_Description = "Gets/sets whether a column will be visible or not in the grid."
Dim lCol As Long
   lCol = ColumnIndex(vKey)
   If (lCol > 0) Then
      ColumnVisible = m_tCols(lCol).bVisible
   End If
End Property
Public Property Let ColumnVisible(ByVal vKey As Variant, ByVal bState As Boolean)
Dim lCol As Long
   lCol = ColumnIndex(vKey)
   If (lCol > 0) Then
   
      If bState Then m_tCols(lCol).bHidden = False
   
      If (bState <> m_tCols(lCol).bVisible) Then
         m_tCols(lCol).bVisible = bState
         If Not bState Then
            m_tCols(lCol).lHeadercolIndex = 0
         End If
         If (lCol <> m_iRowTextCol) Then
            ColumnWidth(m_tCols(lCol).lCellColIndex) = m_tCols(lCol).lWidth
            SetHeaders
            m_bDirty = True
            Draw
         End If
      End If
   End If
End Property

Public Property Get ColumnHidden(ByVal vKey As Variant) As Boolean
Dim lCol As Long
   lCol = ColumnIndex(vKey)
   If (lCol > 0) Then
      ColumnHidden = m_tCols(lCol).bHidden
   End If
End Property
Public Property Let ColumnHidden(ByVal vKey As Variant, ByVal bState As Boolean)
Dim lCol As Long
   lCol = ColumnIndex(vKey)
   If (lCol > 0) Then
      If (bState <> m_tCols(lCol).bVisible) Then
         m_tCols(lCol).bHidden = bState
      End If
   End If
End Property

Public Property Get Columns() As Long
Attribute Columns.VB_Description = "Gets the number of columns in the grid, including hidden and RowText columns."
   Columns = m_iCols
End Property
Public Property Get Rows() As Long
Attribute Rows.VB_Description = "Gets/sets the number of rows in the grid."
   Rows = m_iRows
End Property
Public Property Let Rows(ByVal lRows As Long)
Dim lStartRow As Long
Dim lRow As Long
Dim iCol As Long
   If (lRows > 0) Then
      If (m_iCols = 0) Then
         'Err.Raise 9, App.EXEName & ".cGrid", "Attempt to add rows with no columns."
      Else
         
         ' TODO: OJO: OJASO:
         '
         ' Este es un cambio muy groso.
         '
         ' Si el vector de m_vIRow esta ordenado, y yo reduzco la cantidad
         ' de filas en el vector, en realidad lo que tengo que hacer es borrar
         ' filas que no estan necesariamente al final del vector de la grilla (m_tvCells)
         '
         ' Ya que hacer un delete toma demasiado tiempo, decidi que cuando achico el vector
         ' se regenere el indice de m_vIRow desde 1 hasta lRows
         '
         ' Obviamente esta desicion puede traer problemas, (espero que no)
         '
         ' Cualquier comportamiento raro hay que darle a este
         '
         ' Codigo original
         '
         '    pRedimvIRow True, lRows
         '
         ' Nuevo Codigo
         '
         If lRows < m_iRows Then
            pRedimvIRow False, lRows
         Else
            pRedimvIRow True, lRows
         End If
         '
         ' Fin nuevo codigo
         
         ReDim Preserve m_tvCells(1 To m_iCols, 1 To lRows) As tGridCell
         
         If (lRows > m_iRows) Then
            lStartRow = m_iRows + 1
            RowHeight(lRows) = m_lDefaultRowHeight
            For iCol = 1 To m_iCols
               For lRow = lStartRow To lRows
                  pInitCell lRow, iCol
               Next lRow
            Next iCol
         Else
            
            ' Codigo original
            '
            ' pRedimvIRow True, lRows
            
            ReDim Preserve m_tvRows(0 To lRows) As tRowPosition
            m_iRows = lRows
            If (m_iLastSelRow > m_iRows) Then
               m_iLastSelRow = m_iRows
            End If
         End If
         m_bDirty = True
         Draw
      End If
   Else
      'Err.Raise 9, App.EXEName & ".cGrid", "Row subscript out of range"
   End If
End Property

Public Sub AddRow( _
      Optional ByVal lRowBefore As Long = -1, _
      Optional ByVal sKey As String, _
      Optional ByVal bVisible As Boolean = True, _
      Optional ByVal lHeight As Long = -1, _
      Optional ByVal bGroupRow As Boolean = False, _
      Optional ByVal lGroupColStartIndex As Long = 0 _
   )
   
  AddRowEx lRowBefore, sKey, bVisible, lHeight, bGroupRow, lGroupColStartIndex
End Sub

Public Sub AddRowEx( _
      Optional ByVal lRowBefore As Long = -1, _
      Optional ByVal sKey As String, _
      Optional ByVal bVisible As Boolean = True, _
      Optional ByVal lHeight As Long = -1, _
      Optional ByVal bGroupRow As Boolean = False, _
      Optional ByVal lGroupColStartIndex As Long = 0, _
      Optional ByVal nIndexGroup As Long = 0 _
   )
Dim iRow As Long
Dim iCol As Long
Dim lOffset As Long
Dim lStartY As Long
Dim bSelDone As Boolean

   If (lHeight < 0) Then
      lHeight = m_lDefaultRowHeight
   End If
   
   If (lRowBefore > 0) And (m_iRows > 0) Then
   
      If lRowBefore > m_iRows Then
        lRowBefore = m_iRows
      End If
      
      If lRowBefore > UBound(m_tvRows) Then
        lRowBefore = UBound(m_tvRows)
      End If
      
      ' Inserting a row:
      m_iRows = m_iRows + 1
      If (bVisible) Then
         lOffset = lHeight
      End If
      lStartY = m_tvRows(m_vIRow(lRowBefore)).lStartY
      
      pRedimvIRow True, m_iRows
      
      ReDim Preserve m_tvRows(0 To m_iRows) As tRowPosition
      ReDim Preserve m_tvCells(1 To m_iCols, 1 To m_iRows) As tGridCell
      
      For iRow = m_iRows - 1 To lRowBefore Step -1
         LSet m_tvRows(m_vIRow(iRow + 1)) = m_tvRows(m_vIRow(iRow))
         m_tvRows(m_vIRow(iRow + 1)).lStartY = m_tvRows(m_vIRow(iRow + 1)).lStartY + lOffset
         For iCol = 1 To m_iCols
            LSet m_tvCells(iCol, m_vIRow(iRow + 1)) = m_tvCells(iCol, m_vIRow(iRow))
         Next iCol
      Next iRow
      With m_tvRows(m_vIRow(lRowBefore))
         .sKey = sKey
         .bGroupRow = bGroupRow
         .nIndexGroup = nIndexGroup
         .lGroupStartColIndex = lGroupColStartIndex
         .bVisible = bVisible
         .lHeight = lHeight
         .lOriginalHeigth = lHeight
         .lStartY = lStartY
      End With
      For iCol = 1 To m_iCols
         pInitCell lRowBefore, iCol
         If Not (bSelDone) Then
            If m_tvCells(iCol, m_vIRow(lRowBefore + 1)).bSelected Then
               If Not (m_bMultiSelect) Then
                  m_iSelRow = lRowBefore + 1
                  m_iSelCol = iCol
                  pSingleModeSelect
               End If
               bSelDone = True
            End If
         End If
      Next iCol
      
   Else
      ' Add row to end:
      m_iRows = m_iRows + 1
      
      pRedimvIRow True, m_iRows
      ReDim Preserve m_tvRows(0 To m_iRows) As tRowPosition
      ReDim Preserve m_tvCells(1 To m_iCols, 1 To m_iRows) As tGridCell
      
      With m_tvRows(m_vIRow(m_iRows))
         .sKey = sKey
         .bGroupRow = bGroupRow
         .nIndexGroup = nIndexGroup
         .lGroupStartColIndex = lGroupColStartIndex
         .bVisible = bVisible
         .lHeight = lHeight
         .lOriginalHeigth = lHeight
         If (m_iRows > 1) Then
            .lStartY = m_tvRows(m_vIRow(m_iRows - 1)).lStartY - (m_tvRows(m_vIRow(m_iRows - 1)).bVisible * m_tvRows(m_vIRow(m_iRows - 1)).lHeight)
         Else
            .lStartY = 0
         End If
      End With
      For iCol = 1 To m_iCols
         pInitCell m_iRows, iCol
      Next iCol
   End If
   If (lHeight > m_lMaxRowHeight) Then
      BuildMemDC lHeight
   End If

   m_bDirty = True
   Draw
End Sub

Private Sub pInitCell( _
      ByVal lRow As Long, _
      ByVal lCol As Long _
   )
   LSet m_tvCells(lCol, m_vIRow(lRow)) = m_tDefaultCell
End Sub
Public Sub RemoveRow( _
      ByVal lRow As Long _
   )
Attribute RemoveRow.VB_Description = "Deletes a row from the grid."
   
   pDeleteRow lRow
End Sub
Private Sub pRemoveRow( _
      ByVal lRow As Long _
   )
Dim iRow As Long
Dim iCol As Long
Dim lOffset As Long
Dim iRealRow As Long

    iRealRow = m_vIRow(lRow)

   If (m_iRows = 1) Then
      ' Clear grid:
      Clear False
   Else
      ' Remove this row:
      If (iRealRow = m_iRows) Then
         
         If (m_tvRows(iRealRow).bVisible) Then
            lOffset = m_tvRows(iRealRow).lHeight
         End If
         
         ' Have to shift rows only for index row vector:
         For iRow = lRow + 1 To m_iRows
            m_vIRow(iRow - 1) = m_vIRow(iRow)
         Next iRow
         
         ' Last row:
         m_iRows = m_iRows - 1
                  
         pRedimvIRow True, m_iRows
         ReDim Preserve m_tvRows(0 To m_iRows) As tRowPosition
         ReDim Preserve m_tvCells(1 To m_iCols, 1 To m_iRows) As tGridCell
         
         pRefreshIndexInviRow iRealRow
         For iRow = lRow To m_iRows
            m_tvRows(m_vIRow(iRow)).lStartY = m_tvRows(m_vIRow(iRow)).lStartY - lOffset
         Next
         
         ' Si la fila seleccionada es la que esta borrando
         If m_iSelRow = lRow Then
            m_iSelRow = lRow - 1
            
            If m_bMultiSelect Then
              ' Ya no hay mas fila seleccionada mantenida por
              ' estas variables. Ahora si la grilla esta en estado
              ' multiselect = true, las filas seleccionadas estan
              ' marcadas por m_tCells(x_col, y_row).bSelected
              m_iSelCol = 0
              m_iSelRow = 0
              m_iLastSelCol = 0
              m_iLastSelRow = 0
            Else
              pSingleModeSelect
            End If
         End If
         
         m_bDirty = True
         Draw
         
      Else
      
         If (m_tvRows(iRealRow).bVisible) Then
            lOffset = m_tvRows(iRealRow).lHeight
         End If
         ' Have to shift rows:
         For iRow = iRealRow + 1 To m_iRows
            LSet m_tvRows(iRow - 1) = m_tvRows(iRow)
            For iCol = 1 To m_iCols
               LSet m_tvCells(iCol, iRow - 1) = m_tvCells(iCol, iRow)
            Next iCol
         Next iRow
         
         ' Have to shift rows only for index row vector:
         For iRow = lRow + 1 To m_iRows
            m_vIRow(iRow - 1) = m_vIRow(iRow)
         Next iRow
         
         m_iRows = m_iRows - 1
         
         pRedimvIRow True, m_iRows
         ReDim Preserve m_tvRows(0 To m_iRows) As tRowPosition
         ReDim Preserve m_tvCells(1 To m_iCols, 1 To m_iRows) As tGridCell
         
         pRefreshIndexInviRow iRealRow
         For iRow = lRow To m_iRows
            m_tvRows(m_vIRow(iRow)).lStartY = m_tvRows(m_vIRow(iRow)).lStartY - lOffset
         Next
         
         ' Si la fila seleccionada es la que esta borrando
         If m_iSelRow = lRow Then
            
            If m_bMultiSelect Then
              ' Ya no hay mas fila seleccionada mantenida por
              ' estas variables. Ahora si la grilla esta en estado
              ' multiselect = true, las filas seleccionadas estan
              ' marcadas por m_tCells(x_col, y_row).bSelected
              m_iSelCol = 0
              m_iSelRow = 0
              m_iLastSelCol = 0
              m_iLastSelRow = 0
            Else
              pSingleModeSelect
            End If
         End If
         
         m_bDirty = True
         Draw
      End If
   End If
End Sub

Private Sub pRefreshIndexInviRow(ByVal nFrom As Long)
  Dim i As Long
  
  If nFrom = 1 Then
    For i = 1 To m_iRows
      m_vIRow(i) = m_vIRow(i) - 1
    Next
  Else
    For i = 1 To m_iRows
      If m_vIRow(i) > nFrom Then
        m_vIRow(i) = m_vIRow(i) - 1
      End If
    Next
  End If
End Sub

Public Property Get RowVisible(ByVal lRow As Long) As Boolean
Attribute RowVisible.VB_Description = "Gets/sets whether a row is visible in the grid or not."
   If (lRow > 0) And (lRow <= m_iRows) Then
      RowVisible = m_tvRows(m_vIRow(lRow)).bVisible
   Else
      'Err.Raise 9, App.EXEName, "Invalid Row Subscript"
   End If
End Property
Public Property Let RowVisible(ByVal lRow As Long, ByVal bState As Boolean)
Dim lStartY As Long
Dim lCalcRow As Long
   If (lRow > 0) And (lRow <= m_iRows) Then
      m_tvRows(m_vIRow(lRow)).bVisible = bState
      lStartY = m_tvRows(m_vIRow(lRow)).lStartY
      ' Re-evaluate row sizes:
      For lCalcRow = lRow + 1 To m_iRows
         If (m_tvRows(m_vIRow(lCalcRow - 1)).bVisible) Then
            lStartY = lStartY + m_tvRows(m_vIRow(lCalcRow - 1)).lHeight
         End If
         m_tvRows(m_vIRow(lCalcRow)).lStartY = lStartY
      Next lCalcRow
      m_bDirty = True
      Draw
   Else
      'Err.Raise 9, App.EXEName, "Invalid Row Subscript"
   End If
End Property

Public Property Get RowFilterHide(ByVal lRow As Long) As Boolean
   If (lRow > 0) And (lRow <= m_iRows) Then
      RowFilterHide = m_tvRows(m_vIRow(lRow)).bFilterHide
   Else
      'Err.Raise 9, App.EXEName, "Invalid Row Subscript"
   End If
End Property
Public Property Let RowFilterHide(ByVal lRow As Long, ByVal bState As Boolean)
Dim lStartY As Long
Dim lCalcRow As Long
   If (lRow > 0) And (lRow <= m_iRows) Then
      m_tvRows(m_vIRow(lRow)).bFilterHide = bState
   Else
      'Err.Raise 9, App.EXEName, "Invalid Row Subscript"
   End If
End Property

Public Property Get RowGroupHide(ByVal lRow As Long) As Boolean
   If (lRow > 0) And (lRow <= m_iRows) Then
      RowGroupHide = m_tvRows(m_vIRow(lRow)).bGroupHide
   Else
      'Err.Raise 9, App.EXEName, "Invalid Row Subscript"
   End If
End Property
Public Property Let RowGroupHide(ByVal lRow As Long, ByVal bState As Boolean)
Dim lStartY As Long
Dim lCalcRow As Long
   If (lRow > 0) And (lRow <= m_iRows) Then
      m_tvRows(m_vIRow(lRow)).bGroupHide = bState
   Else
      'Err.Raise 9, App.EXEName, "Invalid Row Subscript"
   End If
End Property

Public Sub RefreshFilters()
  Dim iCol      As Long
  
  If m_ColFilters.Count > 0 Then
    ' Si les falta el Key se los asigno
    For iCol = 1 To m_iCols
      If m_tCols(iCol).bVisible And LenB(m_tCols(iCol).sHeader) Then
        If LenB(m_tCols(iCol).sKey) = 0 Then
          m_tCols(iCol).sKey = c_AuxKey & iCol
        End If
      End If
    Next
  End If
  
  Dim oGridGroup As Object
  Set oGridGroup = CSKernelClient2.CreateObject("CSGridGroups.cGridGroups")
  
  oGridGroup.DoFilters Me
  Set oGridGroup = Nothing
End Sub
Public Sub RefreshFormats()
  Dim oGridGroup As Object
  Set oGridGroup = CSKernelClient2.CreateObject("CSGridGroups.cGridGroups")
  
  oGridGroup.DoFormats Me
  Set oGridGroup = Nothing
End Sub

Public Sub RefreshGroupsAndFormulas()
  pRefreshGroupsAndFormulas False
End Sub

Public Sub RefreshGroupsAndFormulasEx(ByVal bForceRefresh As Boolean)
  On Error Resume Next
  m_bDontRaiseEvent = True
  
  pRefreshGroupsAndFormulas bForceRefresh
  
  m_bDontRaiseEvent = False
  Err.Clear
End Sub

Public Sub FreezeCtrl(ByRef oldRedraw As Boolean, _
                      ByRef oldHeaderVisible As Boolean)
                      
  oldRedraw = Redraw
  Redraw = False
  
  oldHeaderVisible = m_cHeader.Visible
  m_cHeader.Visible = False
End Sub

Public Sub UnFreezeCtrl(ByVal oldRedraw As Boolean, _
                        ByVal oldHeaderVisible As Boolean)
                      
  m_cHeader.Visible = oldHeaderVisible
  Redraw = oldRedraw
End Sub

Private Sub pRefreshGroupsAndFormulas(ByVal bForceRefresh As Boolean)

  On Error GoTo ControlError

  Dim oldRedraw As Boolean
  oldRedraw = Redraw
  Redraw = False
  
  Dim oldHeaderVisible As Boolean
  oldHeaderVisible = m_cHeader.Visible
  m_cHeader.Visible = False

  Dim Group     As cGridGroup
  Dim sThis()   As String
  Dim eOrder()  As cShellSortOrderCOnstants
  Dim j         As Long
  Dim iCol      As Long
  Dim iNumber   As Long
  
  If m_Groups.Count > 0 Or m_ColFormulas.Count > 0 Or bForceRefresh Then
    
    ' Si les falta el Key se los asigno
    For iCol = 1 To m_iCols
      If m_tCols(iCol).bVisible And LenB(m_tCols(iCol).sHeader) Then
        If LenB(m_tCols(iCol).sKey) = 0 Then
          m_tCols(iCol).sKey = c_AuxKey & iCol
        End If
      End If
    Next
  
    If m_Groups.Count > 0 Then
      ReDim sThis(0 To m_Groups.Count - 1)
      ReDim eOrder(0 To m_Groups.Count - 1)
      
      For Each Group In m_Groups
        If Not Group.IsSortCol Then
          iNumber = iNumber + 1
        End If
        sThis(j) = Group.Key
        eOrder(j) = Group.SortType
        j = j + 1
      Next
    End If
    
    m_GroupRowHeight = pGetGroupRowHeight
    
    Dim oGridGroup As Object
    Set oGridGroup = CSKernelClient2.CreateObject("CSGridGroups.cGridGroups")
    
    oGridGroup.DoGroup Me, _
                       iNumber, _
                       sThis(), _
                       eOrder()
                       
    Set oGridGroup = Nothing
  End If

  GoTo ExitProc
ControlError:
  MngError "pRefreshGroupsAndFormulas"
ExitProc:
  m_cHeader.Visible = oldHeaderVisible
  Redraw = oldRedraw
End Sub

Public Sub Clear(Optional ByVal bRemoveCols As Boolean = False)
  ClearEx bRemoveCols, True
End Sub

'----------------------------------------------------------------
'
  Public Sub ClearEx(Optional ByVal bRemoveCols As Boolean = False, _
                     Optional ByVal bRemoveGroups As Boolean = False, _
                     Optional ByVal bRemoveFormulas As Boolean = False, _
                     Optional ByVal bRemoveFormats As Boolean = False, _
                     Optional ByVal bRemoveFilters As Boolean = False)
  
  On Error GoTo ControlError

98     m_bDontRaiseEvent = True

DoEvents
99     pRedimvIRow False, 0
100    Erase m_tvCells
DoEvents
101    ReDim m_tvRows(0 To 0) As tRowPosition
DoEvents
102    If (bRemoveCols) Then
103       ' 19/10/99: (7)
104       ReDim m_tCols(0 To 0) As tColPosition
105       m_iCols = 0
106       m_iRowTextCol = 0
107       m_lRowTextStartCol = 0
108       m_bHasRowText = False
109    End If
DoEvents
110    m_iRows = 0
111    m_iSelRow = 0
112    m_iSelCol = 0
113    m_iLastSelRow = 0
114    m_iLastSelCol = 0
115    m_bDirty = True
DoEvents
116    'm_bInVirtualRequest = m_bIsVirtual
117    m_cScroll.Value(efsVertical) = 0
DoEvents
118    m_cScroll.Value(efsHorizontal) = 0
DoEvents
119
120    If bRemoveGroups Then m_Groups.Clear
121    If bRemoveFormulas Then m_ColFormulas.Clear
122    If bRemoveFormats Then m_ColFormats.Clear
123    If bRemoveFilters Then m_ColFilters.Clear
DoEvents
124
125    Draw

DoEvents

       m_bDontRaiseEvent = False
       
       Exit Sub
       
ControlError:
        MsgError "Linea: " & Erl & vbCrLf & vbCrLf & _
                 "Descrip: " & Err.Description
                 
        m_bDontRaiseEvent = False
  End Sub
'
'----------------------------------------------------------------

Public Property Get BorderStyle() As ECGBorderStyle
Attribute BorderStyle.VB_Description = "Gets/sets the border style for the control."
Attribute BorderStyle.VB_ProcData.VB_Invoke_Property = ";Appearance"
Attribute BorderStyle.VB_UserMemId = -504
   BorderStyle = m_eBorderStyle
End Property
Public Property Let BorderStyle(ByVal eStyle As ECGBorderStyle)
Dim lStyle As Long
   m_eBorderStyle = eStyle
   If (eStyle = ecgBorderStyleNone) Then
      UserControl.BorderStyle() = 0
   Else
      UserControl.BorderStyle() = 1
      lStyle = GetWindowLong(UserControl.hWnd, GWL_EXSTYLE)
      If (eStyle = ecgBorderStyle3dThin) Then
         lStyle = lStyle And Not WS_EX_CLIENTEDGE Or WS_EX_STATICEDGE
      Else
         lStyle = lStyle Or WS_EX_CLIENTEDGE And Not WS_EX_STATICEDGE
      End If
      SetWindowLong UserControl.hWnd, GWL_EXSTYLE, lStyle
      SetWindowPos UserControl.hWnd, 0, 0, 0, 0, 0, SWP_NOACTIVATE Or SWP_NOZORDER Or SWP_FRAMECHANGED Or SWP_NOSIZE Or SWP_NOMOVE
   End If
   PropertyChanged "BorderStyle"
End Property
Private Sub pScrollSetDirty(ByVal bNoOptimise As Boolean)
Dim iStartX As Long, iEndX As Long, iStartY As Long, iEndY As Long
Dim iStartRow As Long, iEndRow As Long
Dim iStartCol As Long, iEndCol As Long
Dim iRow As Long, iCol As Long
Dim iRowCount As Long
Dim iH As Long, iV As Long
Static s_iLastStartRow As Long, s_iLastEndRow As Long
Static s_iLastStartCol As Long, s_iLastEndCol As Long
Static s_iLastH As Long, s_iLastV As Long
Dim iToDirtyX As Long, iToDirtyY As Long
Dim iXStart As Long, iXEnd As Long
Dim iYStart As Long, iYEnd As Long
Dim tSR As RECT, tR As RECT, tJunk As RECT
   
   'm_bDirty = True
   'Exit Sub
   If (m_iRows = 0) Or (m_iCols = 0) Then
      Exit Sub
   End If
      
   GetStartEndCell iStartRow, iStartCol, iStartX, iStartY, iEndRow, iEndCol, iEndX, iEndY
   iStartRow = iStartRow - 1
   If (iStartRow < 1) Then iStartRow = 1

   If (m_cScroll.Visible(efsHorizontal)) Then
      iH = m_cScroll.Value(efsHorizontal)
   End If
   If (m_cScroll.Visible(efsVertical)) Then
      iV = m_cScroll.Value(efsVertical)
   End If
   
   'debugmsg s_iLastStartRow - iStartRow, s_iLastEndRow - iEndRow, s_iLastStartCol - iStartCol, s_iLastEndCol - iEndCol, s_iLastH - iH, s_iLastV - iV
   iToDirtyY = Abs(s_iLastStartRow - iStartRow) + 1
   If (Abs(s_iLastEndRow - iEndRow) + 1) > iToDirtyY Then
      iToDirtyY = (Abs(s_iLastEndRow - iEndRow) + 1)
   End If
   iToDirtyX = Abs(s_iLastStartCol - iStartCol) + 1
   If (Abs(s_iLastEndCol - iEndCol) + 1) > iToDirtyX Then
      iToDirtyX = (Abs(s_iLastEndCol - iEndCol) + 1)
   End If
         
   bNoOptimise = bNoOptimise Or m_bNoOptimiseScroll
   If (m_bBitmap) Then
      ' Can't optimise with a background bitmap as it has to stay in place:
      bNoOptimise = True
   End If
   
   If Not (bNoOptimise) Then
      'GetClientRect UserControl.hwnd, tR
      tR.Top = 0: tR.Bottom = 0: tR.Right = UserControl.ScaleWidth \ Screen.TwipsPerPixelX: tR.Bottom = UserControl.ScaleHeight \ Screen.TwipsPerPixelY
      tR.Top = tR.Top + m_cHeader.Height * Abs(m_bHeader)
      If (Abs(s_iLastH - iH) < (tR.Right - tR.Left) \ 2) And (Abs(s_iLastV - iV) < (tR.Bottom - tR.Top) \ 2) Then
         ' We can optimise using ScrollDC:
         'debugmsg "Optimise!", iToDirtyX, iToDirtyY
         LSet tSR = tR
         If (Abs(s_iLastH - iH) > 0) Then
            ' scrolling in X:
            iYStart = iStartRow
            iYEnd = iEndRow
            If Sgn(s_iLastH - iH) = -1 Then
               iXStart = iEndCol - iToDirtyX
               iXEnd = iEndCol
               tSR.Left = tSR.Left - (s_iLastH - iH)
            Else
               iXStart = iStartCol
               iXEnd = iStartCol + iToDirtyX
               tSR.Right = tSR.Right - (s_iLastH - iH)
            End If
         Else
            ' scrolling in Y
            iXStart = iStartCol
            iXEnd = iEndCol
            If Sgn(s_iLastV - iV) = -1 Then
               iYStart = iEndRow
               iRowCount = 0
               Do While iRowCount < iToDirtyY
                  iYStart = iYStart - 1
                  If iYStart < 1 Then
                     Exit Do
                  Else
                     If m_tvRows(m_vIRow(iYStart)).bVisible Then
                        iRowCount = iRowCount + 1
                     End If
                  End If
               Loop
               If (iYStart < 1) Then iYStart = 1
               iYEnd = iEndRow
               tSR.Top = tSR.Top - (s_iLastV - iV)
            Else
               iYStart = iStartRow
               iYEnd = iStartRow
               iRowCount = 0
               Do While iRowCount < iToDirtyY
                  iYEnd = iYEnd + 1
                  If iYEnd > m_iRows Then
                     Exit Do
                  Else
                     If m_tvRows(m_vIRow(iYEnd)).bVisible Then
                        iRowCount = iRowCount + 1
                     End If
                  End If
               Loop
               tSR.Bottom = tSR.Bottom - (s_iLastV - iV)
            End If
         End If
         If (iXStart < 1) Then iXStart = 1
         If (iYStart < 1) Then iYStart = 1
         If (iXEnd > m_iCols) Then iXEnd = m_iCols
         If (iYEnd > m_iRows) Then iYEnd = m_iRows
         
         ScrollDC UserControl.hdc, s_iLastH - iH, s_iLastV - iV, tSR, tR, 0, tJunk
         
         For iRow = iYStart To iYEnd
            For iCol = iXStart To iXEnd
               m_tvCells(iCol, m_vIRow(iRow)).bDirtyFlag = True
            Next iCol
         Next iRow
      Else
         bNoOptimise = True
      End If
   End If
   
   If (bNoOptimise) Then
      For iRow = iStartRow To iEndRow
         For iCol = iStartCol To iEndCol
            m_tvCells(iCol, m_vIRow(iRow)).bDirtyFlag = True
         Next iCol
      Next iRow
   End If
   
   s_iLastStartRow = iStartRow
   s_iLastEndRow = iEndRow
   s_iLastStartCol = iStartCol
   s_iLastEndCol = iEndCol
   If (m_cScroll.Visible(efsHorizontal)) Then
      s_iLastH = m_cScroll.Value(efsHorizontal)
   Else
      s_iLastH = 0
   End If
   If (m_cScroll.Visible(efsVertical)) Then
      s_iLastV = m_cScroll.Value(efsVertical)
   Else
      s_iLastV = 0
   End If
   
End Sub
Private Sub pResizeHeader()
Dim lWidth As Long
Dim lLeft As Long

   ' JAV- Veremos si funciona
   '
   If m_bRedraw Then

      If (m_bHeader) Then
         If Not (m_cScroll Is Nothing) Then
            lWidth = UserControl.ScaleWidth \ Screen.TwipsPerPixelX + m_cScroll.Max(efsHorizontal)
            If (m_cScroll.Visible(efsHorizontal)) Then
               lLeft = -m_cScroll.Value(efsHorizontal)
            Else
               lLeft = 0
            End If
            'debugmsg lLeft, lWidth, m_cScroll.Max(efsHorizontal), m_cScroll.Value(efsHorizontal)
         Else
            lWidth = UserControl.ScaleWidth \ Screen.TwipsPerPixelX
            lLeft = 0
         End If
         m_cHeader.Move lLeft, 0, lWidth, m_cHeader.Height
      End If
   End If
End Sub
Private Sub pRequestEdit(Optional ByVal iKeyAscii As Integer = 0)
  On Error GoTo ControlError

Dim iRow As Long
Dim iCol As Long
Dim iNextROw As Long
Dim sOrigSearch As String

   If (m_bEnabled) Then
      If (m_iSelRow <> 0) And (m_iSelCol <> 0) Then
         If (m_bEditable) Then
            m_bInEdit = True
            
            If Not m_bDontRaiseEvent Then
              RaiseEvent RequestEdit(m_iSelRow, m_iSelCol, iKeyAscii, m_bInEdit)
            End If
         Else
            If (iKeyAscii <> 0) Then
               ' Search in the search col for the item:
               If (m_iSearchCol > 0) Then
                  sOrigSearch = m_sSearchString
                  If (iKeyAscii = 8) Then
                     If Len(m_sSearchString) > 0 Then
                        If (Len(m_sSearchString) = 1) Then
                           m_sSearchString = vbNullString
                        Else
                           m_sSearchString = Left$(m_sSearchString, Len(m_sSearchString) - 1)
                        End If
                     End If
                  Else
                     m_sSearchString = m_sSearchString & Chr$(iKeyAscii)
                  End If
                  m_sSearchString = UCase$(m_sSearchString)
                  If Len(m_sSearchString) > 0 Then
                     iRow = FindSearchMatchRow(m_sSearchString)
                     If (iRow = 0) Then
                        m_sSearchString = sOrigSearch
                        iNextROw = FindSearchMatchRow(m_sSearchString)
                        If (iNextROw <> iRow) Then
                           iRow = iNextROw
                        End If
                     End If
                     'debugmsg m_sSearchString, iRow
                     If (iRow <> 0) Then
                        If (m_bMultiSelect) Then
                           m_iSelRow = iRow
                           m_iSelCol = m_iSearchCol
                           For iRow = 1 To m_iRows
                              For iCol = 1 To m_iCols
                                 If (m_bRowMode) Then
                                    m_tvCells(iCol, m_vIRow(iRow)).bDirtyFlag = (m_tvCells(iCol, m_vIRow(iRow)).bSelected <> (iRow = m_iSelRow))
                                    m_tvCells(iCol, m_vIRow(iRow)).bSelected = (iRow = m_iSelRow)
                                 Else
                                    m_tvCells(iCol, m_vIRow(iRow)).bDirtyFlag = (m_tvCells(iCol, m_vIRow(iRow)).bSelected <> ((iRow = m_iSelRow) And (iCol = m_iSelCol)))
                                    m_tvCells(iCol, m_vIRow(iRow)).bSelected = ((iRow = m_iSelRow) And (iCol = m_iSelCol))
                                 End If
                              Next iCol
                           Next iRow
                           m_tvCells(m_iSearchCol, m_vIRow(m_iSelRow)).bDirtyFlag = True
                        Else
                           m_iSelRow = iRow
                           m_iSelCol = m_iSearchCol
                           pSingleModeSelect
                        End If
                        If Not (pbEnsureVisible(m_iSelRow, m_iSelCol)) Then
                           Draw
                        End If
                     Else
                        m_sSearchString = sOrigSearch
                     End If
                  End If
               End If
            End If
         End If
      End If
   End If

  GoTo ExitProc
ControlError:
  MngError "pRequestEdit", C_Module
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub
Public Function ExistsColumn(ByVal vKey As Variant) As Boolean
Dim lCol As Long
   lCol = plColumnIndex(vKey)
   ExistsColumn = (lCol > 0) And (lCol <= m_iCols)
End Function
Public Function FindSearchMatchRow( _
      ByVal sSearchString As String, _
      Optional ByVal bLoop As Boolean = True, _
      Optional ByVal bVisibleRowsOnly As Boolean = True _
   ) As Long
Attribute FindSearchMatchRow.VB_Description = "Finds the first matching row for a given search string."
Dim iRow As Long
Dim iFindRow As Long
Dim iStart As Long
Dim sText As String

   If (m_iSearchCol > 0) And (m_iSearchCol < m_iCols) Then
      If (m_iSelRow = 0) Then
         If (bLoop) Then
            iStart = m_iSelRow + 1
         Else
            iStart = m_iSelRow
         End If
      Else
         iStart = 1
      End If
      For iRow = iStart To m_iRows
         If (m_tvRows(m_vIRow(iRow)).bVisible) Or Not (bVisibleRowsOnly) Then
            If Not IsMissing(m_tvCells(m_iSearchCol, m_vIRow(iRow)).sText) Then
               sText = UCase$(m_tvCells(m_iSearchCol, m_vIRow(iRow)).sText)
               If (Len(sText) >= Len(sSearchString)) Then
                  If (InStr(sText, sSearchString) = 1) Then
                     iFindRow = iRow
                     Exit For
                  End If
               End If
            End If
         End If
      Next iRow
      If (iFindRow = 0) Then
         If (bLoop) Then
            For iRow = 1 To iStart
               If (m_tvRows(m_vIRow(iRow)).bVisible) Or Not (bVisibleRowsOnly) Then
                  If Not IsMissing(m_tvCells(m_iSearchCol, m_vIRow(iRow)).sText) Then
                     sText = UCase$(m_tvCells(m_iSearchCol, m_vIRow(iRow)).sText)
                     If (Len(sText) >= Len(sSearchString)) Then
                        If (InStr(sText, sSearchString) = 1) Then
                           iFindRow = iRow
                           Exit For
                        End If
                     End If
                  End If
               End If
            Next iRow
         End If
      End If
      
      FindSearchMatchRow = iFindRow
   End If
End Function
Public Sub CancelEdit()
Attribute CancelEdit.VB_Description = "Call to cancel an edit request when the control you are using to edit a cell looses focus."
   If (m_bInEdit) Then
      
      If Not m_bDontRaiseEvent Then
        RaiseEvent CancelEdit
      End If
      
      m_bInEdit = False
   End If
End Sub
Private Sub pSingleModeSelect()
Dim iCol As Long
   If (m_iRows = 0) Or (m_iCols = 0) Then
      Exit Sub
   End If
   If (m_iSelRow <= 0) Then
      m_iSelRow = 1
   End If
   If (m_iSelCol <= 0) Then
      m_iSelCol = 1
   End If
   If (m_bRowMode) Then
      For iCol = 1 To m_iCols
         If (m_iLastSelRow <> 0) Then
            If (m_iLastSelRow > m_iRows) Then
               m_iLastSelRow = m_iRows
            End If
            m_tvCells(iCol, m_vIRow(m_iLastSelRow)).bDirtyFlag = True
            m_tvCells(iCol, m_vIRow(m_iLastSelRow)).bSelected = False
         End If
         m_tvCells(iCol, m_vIRow(m_iSelRow)).bDirtyFlag = True
         m_tvCells(iCol, m_vIRow(m_iSelRow)).bSelected = True
      Next iCol
   Else
      If (m_iLastSelRow > 0) And (m_iLastSelCol > 0) Then
         If (m_iLastSelRow > m_iRows) Then
            m_iLastSelRow = m_iRows
         End If
         If (m_iLastSelCol > m_iCols) Then
            m_iLastSelCol = m_iCols
         End If
         m_tvCells(m_iLastSelCol, m_vIRow(m_iLastSelRow)).bDirtyFlag = True
         m_tvCells(m_iLastSelCol, m_vIRow(m_iLastSelRow)).bSelected = False
      End If
      m_tvCells(m_iSelCol, m_vIRow(m_iSelRow)).bDirtyFlag = True
      m_tvCells(m_iSelCol, m_vIRow(m_iSelRow)).bSelected = True
   End If
End Sub
Private Sub pGetNextVisibleCell( _
      ByVal cx As Long, _
      ByVal cy As Long _
   )
Dim i As Long
Dim iColIndex As Long
Dim iNew As Long
Dim iOrigRow As Long
Dim bCheckRowVisible As Boolean
Dim bFound As Boolean
Dim iIter As Long
Dim iRowTextCol As Long
   
   If (cx <> 0) Then
      For i = 1 To m_iCols
         If m_tCols(i).lCellColIndex = m_iSelCol Then
            iColIndex = i
            Exit For
         End If
      Next i
   
      iNew = iColIndex + cx
      If (iNew > 0) And (iNew <= m_iCols) Then
         If m_tvRows(m_vIRow(m_iSelRow)).bGroupRow Then
            iNew = 0
         Else
            If Not (m_bRowMode) Then
               iRowTextCol = m_iRowTextCol
            Else
               iRowTextCol = 0
            End If
            Do
               If m_tCols(iNew).bVisible Or iNew = iRowTextCol Then
                  Exit Do
               Else
                  iNew = iNew + cx
                  If iNew > m_iCols Or iNew < 0 Then
                     Exit Do
                  End If
               End If
            Loop
         End If
      End If
      
      If (iNew < 1) Then
         For i = m_iCols To 1 Step -1
            If m_tCols(i).bVisible Or i = iRowTextCol Then
               iNew = i
               iOrigRow = m_iSelRow
               Do
                  iOrigRow = iOrigRow - 1
                  If Not (m_bRowMode) Then
                     iRowTextCol = m_iRowTextCol
                  Else
                     iRowTextCol = 0
                  End If
                  If (iOrigRow < 1) Then
                     Exit Do
                  Else
                     If m_tvRows(m_vIRow(iOrigRow)).bVisible Then
                        If m_tvRows(m_vIRow(iOrigRow)).bGroupRow Then
                           m_iSelCol = m_tCols(m_iRowTextCol).lCellColIndex
                           m_iSelRow = iOrigRow
                           Exit Do
                        Else
                           m_iSelCol = m_tCols(iNew).lCellColIndex
                           m_iSelRow = iOrigRow
                           Exit Do
                        End If
                     End If
                  End If
               Loop
               Exit For
            End If
         Next i
      ElseIf (iNew > m_iCols) Then
         For i = 1 To m_iCols
            If m_tCols(i).bVisible Or i = iRowTextCol Then
               iNew = i
               iOrigRow = m_iSelRow
               Do
                  iOrigRow = iOrigRow + 1
                  If Not (m_bRowMode) Then
                     iRowTextCol = m_iRowTextCol
                  Else
                     iRowTextCol = 0
                  End If
                  If (iOrigRow > m_iRows) Then
                     Exit Do
                  Else
                     If m_tvRows(m_vIRow(iOrigRow)).bVisible Then
                        If m_tvRows(m_vIRow(iOrigRow)).bGroupRow Then
                           m_iSelCol = m_tCols(m_iRowTextCol).lCellColIndex
                           m_iSelRow = iOrigRow
                           Exit Do
                        Else
                           m_iSelCol = m_tCols(iNew).lCellColIndex
                           m_iSelRow = iOrigRow
                           Exit Do
                        End If
                     End If
                  End If
               Loop
               Exit For
            End If
         Next i
      Else
         m_iSelCol = m_tCols(iNew).lCellColIndex
      End If
            
   End If
   
   If (cy <> 0) Or (bCheckRowVisible) Then
      iOrigRow = m_iSelRow
      bFound = False
      Do
         m_iSelRow = m_iSelRow + cy
         iIter = iIter + 1
         If (iIter > m_iRows) Then
            ' No visible rows
            m_iSelCol = 0: m_iSelRow = 0
            Exit Sub
         End If
         
         If (m_iSelRow > m_iRows) Then
            m_iSelRow = iOrigRow
            Exit Sub
         ElseIf (m_iSelRow < 1) Then
            m_iSelRow = iOrigRow
            Exit Sub
         End If
         If (m_tvRows(m_vIRow(m_iSelRow)).bVisible) Then
            If (m_tvRows(m_vIRow(m_iSelRow)).bGroupRow) Then
               m_iSelCol = m_iRowTextCol
            ElseIf (m_iSelCol = m_iRowTextCol) Then
               For i = 1 To m_iCols
                  If m_tCols(i).bVisible Then
                     m_iSelCol = m_tCols(i).lCellColIndex
                     Exit For
                  End If
               Next i
            End If
            bFound = True
         End If
         
      Loop While Not bFound
   End If
   
End Sub
Private Function plGetFirstVisibleRow() As Long
Dim bFound As Boolean
Dim iRow As Long
   iRow = 1
   Do
      If (m_tvRows(m_vIRow(iRow)).bVisible) Then
         bFound = True
      Else
         iRow = iRow + 1
         If (iRow > m_iRows) Then
            iRow = 0
            bFound = True
         End If
      End If
   Loop While Not bFound
   plGetFirstVisibleRow = iRow
End Function
Private Function plGetLastVisibleRow() As Long
Dim bFound As Boolean
Dim iRow As Long
   iRow = m_iRows
   Do
      If (m_tvRows(m_vIRow(iRow)).bVisible) Then
         bFound = True
      Else
         iRow = iRow - 1
         If (iRow < 1) Then
            iRow = 0
            bFound = True
         End If
      End If
   Loop While Not bFound
   plGetLastVisibleRow = iRow
End Function
Public Sub AutoWidthColumn(ByVal vKey As Variant)
Attribute AutoWidthColumn.VB_Description = "Automatically resizes a column to accommodate the largest item."
Dim iRow As Long
Dim lWidth As Long
Dim lMaxWidth As Long
Dim lMaxTextWidth As Long
Dim iCol As Long
Dim iCCol As Long
Dim lHeaderWidth As Long

   iCol = plColumnIndex(vKey)
   If (iCol > 0) Then
      lHeaderWidth = pEvaluateHeaderWidth(m_tCols(iCol).sHeader)
      iCCol = m_tCols(iCol).lCellColIndex
      For iRow = 1 To m_iRows
         If (m_tvRows(m_vIRow(iRow)).bVisible) Then
            ' lMaxTextWidth is an optimisation for multi-line rows
            lWidth = plEvaluateTextWidth(iRow, iCCol, True, lMaxTextWidth)
            If (lWidth > lMaxTextWidth) Then
               lMaxTextWidth = lWidth
            End If
            lWidth = lWidth + m_tvCells(iCCol, m_vIRow(iRow)).lIndent
            lWidth = lWidth + ((m_tvCells(iCCol, m_vIRow(iRow)).iIconIndex > 0) * -m_lIconSizeX)
            lWidth = lWidth + ((m_tvCells(iCCol, m_vIRow(iRow)).lExtraIconIndex > 0) * -m_lIconSizeX)
            lWidth = lWidth + ((m_tvCells(iCCol, m_vIRow(iRow)).lGroupIconIndex > 0) * -m_lIconSizeGroupX)
            lWidth = lWidth + 4
            lWidth = lWidth + m_bGridLines * -4
            If (lWidth > lMaxWidth) Then
               lMaxWidth = lWidth
            End If
         End If
      Next iRow
      
      If (lMaxWidth < lHeaderWidth) Then
         lMaxWidth = lHeaderWidth
      End If
      
      If (lMaxWidth < 4) Then
         lMaxWidth = 4
      Else
        lMaxWidth = lMaxWidth + 10
      End If
      
      If lMaxWidth > Screen.Width / Screen.TwipsPerPixelX Then
        lMaxWidth = Screen.Width / Screen.TwipsPerPixelX
      End If
      ColumnWidth(iCCol) = lMaxWidth
   Else
      'Err.Raise 9, App.EXEName & ".cGrid"
   End If
   
End Sub
Public Sub AutoHeightRow(ByVal lRow As Long, Optional ByVal lMinimumHeight As Long = -1)
Attribute AutoHeightRow.VB_Description = "Automatically sets the height of a row based on the contents of the cells."
Dim lCol As Long
Dim lHeight As Long
Dim lMaxHeight As Long
   If lMinimumHeight <= 8 Then
      lMinimumHeight = m_lDefaultRowHeight
      If lMinimumHeight <= 8 Then
         lMinimumHeight = 8
      End If
   End If
   If (lRow > 0) And (lRow <= m_iRows) Then
      For lCol = 1 To m_iCols
         lHeight = EvaluateTextHeight(lRow, lCol)
         If (m_tvCells(lCol, m_vIRow(lRow)).iIconIndex >= 0) Then
            If lHeight < m_lIconSizeY Then
               lHeight = m_lIconSizeY
            End If
         End If
         If (lHeight < lMinimumHeight) Then
            lHeight = lMinimumHeight
         End If
         If (lHeight > lMaxHeight) Then
            lMaxHeight = lHeight
         End If
      Next lCol
      RowHeight(lRow) = lMaxHeight + Abs(m_bGridLines) * 2 + 2
   Else
      'Err.Raise 9, App.EXEName & ".cGrid"
   End If
End Sub

Private Sub pGetDragImageRect(ByVal lCol As Long, ByVal lWidth As Long, ByRef tR As RECT, ByVal bFirst As Boolean)
Dim iCol As Long, iGCol As Long
Dim tp As POINTAPI

   ' Find start position for header column index lCol:
   'debugmsg lCol, lWidth
   For iCol = 1 To m_iCols
      If (m_tCols(iCol).lHeadercolIndex = lCol + 1) Then
         iGCol = iCol
         Exit For
      End If
   Next iCol
   
   If (iGCol > 0) Then
      ' Add the width:
      If (bFirst) Then
         tR.Left = m_tCols(iGCol).lStartX + m_tCols(iCol).lWidth - 1
      Else
         tR.Left = m_tCols(iGCol).lStartX + lWidth - 1
      End If
      tR.Left = tR.Left - m_lStartX
      tR.Right = tR.Left + 2
      tR.Top = m_cHeader.Height
      tR.Bottom = UserControl.ScaleHeight \ Screen.TwipsPerPixelY
      
      ' Return the rectangle relative to the screen:
      tp.x = tR.Left: tp.y = tR.Top
      ClientToScreen UserControl.hWnd, tp
      tR.Left = tp.x: tR.Top = tp.y
      tp.x = tR.Right: tp.y = tR.Bottom
      ClientToScreen UserControl.hWnd, tp
      tR.Right = tp.x: tR.Bottom = tp.y
      
   End If
End Sub

Private Sub m_cHeader_ColumnBeginDrag(lColumn As Long)
   CancelEdit
End Sub

Private Sub m_cHeader_ColumnClick(lColumn As Long)
Dim iCol    As Long
Dim sHeader As String

   CancelEdit
   For iCol = 1 To m_iCols
      If (m_tCols(iCol).lHeadercolIndex = lColumn + 1) Then
         lColumn = m_tCols(iCol).lCellColIndex
         sHeader = m_tCols(iCol).sHeader
         Exit For
      End If
   Next iCol
   
   If Not m_bDontRaiseEvent Then
    RaiseEvent ColumnClick(lColumn)
   End If
   
   pSortColumn lColumn, sHeader, iCol
End Sub

Private Sub m_cHeader_ColumnEndDrag(lColumn As Long, lOrder As Long)
Dim iCol As Long
Dim lColPosition As Long
Dim lOrderPosition As Long
Dim tSwap As tColPosition
Dim lStartX As Long

   If (lOrder <> -1) Then  ' Dropped off the grid...
      lColumn = lColumn + 1
      lOrderPosition = lOrder + 1
      ' Find this column in the column array:
      For iCol = 1 To m_iCols
         If m_tCols(iCol).bVisible Then
            If (m_tCols(iCol).lHeadercolIndex = lColumn) Then
               lColPosition = iCol
            End If
         ElseIf (lOrderPosition >= iCol) Then
            lOrderPosition = lOrderPosition + 1
         End If
      Next iCol
      If (lColPosition = lOrderPosition) Then
         'debugmsg "No Change"
      Else
         ' Swap around til the array is correct:
         If (lColPosition > lOrderPosition) Then
            LSet tSwap = m_tCols(lColPosition)
            For iCol = lColPosition To lOrderPosition + 1 Step -1
               LSet m_tCols(iCol) = m_tCols(iCol - 1)
            Next iCol
            LSet m_tCols(lOrderPosition) = tSwap
         Else
            LSet tSwap = m_tCols(lColPosition)
            For iCol = lColPosition + 1 To lOrderPosition
               LSet m_tCols(iCol - 1) = m_tCols(iCol)
            Next iCol
            LSet m_tCols(lOrderPosition) = tSwap
         End If
               
         ' Ensure positions are correct:
         lStartX = 0
         For iCol = 1 To m_iCols
            m_tCols(iCol).lStartX = lStartX
            If (m_tCols(iCol).bVisible) And (iCol <> m_iRowTextCol) Then
               lStartX = lStartX + m_tCols(iCol).lWidth
            End If
         Next iCol
         
         ' Redraw grid:
         m_bDirty = True
         Draw
      End If
   End If
   
   If Not m_bDontRaiseEvent Then
    RaiseEvent ColumnOrderChanged
   End If
End Sub

Private Sub m_cHeader_ColumnWidthChanged(lColumn As Long, ByVal lWidth As Long)
Dim lCol As Long
Dim lColIndex As Long
Dim lCCol As Long
Dim tR As RECT
Dim bCancel As Boolean

   DrawDragImage tR, False, True
   
   lCCol = lColumn + 1
   For lCol = 1 To m_iCols
      If (m_tCols(lCol).bVisible) And (m_tCols(lCol).lHeadercolIndex = lCCol) Then
         lColIndex = m_tCols(lCol).lCellColIndex
         Exit For
      End If
   Next lCol
   'If (lWidth < 26) Then
   '   lWidth = 26
   'End If
   ' 19/10/1999 (13)
   
   If Not m_bDontRaiseEvent Then
    RaiseEvent ColumnWidthChanged(lColumn, lWidth, bCancel)
   End If
   
   If Not bCancel Then
      ColumnWidth(lColIndex) = lWidth
      m_bDirty = True
      Draw
      pResizeHeader
   End If
   
End Sub


Private Sub m_cHeader_ColumnWidthChanging(lColumn As Long, ByVal lWidth As Long, bCancel As Boolean)
Dim iCol As Long
Dim tR As RECT

   pGetDragImageRect lColumn, lWidth, tR, False
   For iCol = 1 To m_iCols
      If (m_tCols(iCol).lHeadercolIndex = lColumn + 1) Then
         lColumn = m_tCols(iCol).lCellColIndex
         Exit For
      End If
   Next iCol
   DrawDragImage tR, False, False
   
   If Not m_bDontRaiseEvent Then
    RaiseEvent ColumnWidthChanging(lColumn, lWidth, bCancel)
   End If
   
   If (bCancel) Then
      DrawDragImage tR, False, True
   End If
End Sub

Private Sub m_cHeader_DividerDblClick(lColumn As Long)
Dim iCCol As Long
Dim iCol As Long

   CancelEdit
   
   ' Autosize column here
   For iCol = 1 To m_iCols
      If (m_tCols(iCol).lHeadercolIndex = lColumn + 1) Then
         iCCol = m_tCols(iCol).lCellColIndex
         Exit For
      End If
   Next iCol
   
   AutoWidthColumn iCCol
   
End Sub

Private Sub m_cHeader_RecreateControl()
   SetHeaders
   m_cHeader.SetFont UserControl.hdc, UserControl.Font
   m_cHeader.SetImageList UserControl.hdc, m_hIml
End Sub

Private Sub m_cHeader_RightClick(x As Single, y As Single)
   CancelEdit
   
   If Not m_bDontRaiseEvent Then
    RaiseEvent HeaderRightClick(x, y)
   End If
End Sub

Private Sub m_cHeader_StartColumnWidthChange(lColumn As Long, ByVal lWidth As Long, bCancel As Boolean)
Dim tR As RECT
   CancelEdit
   
   If Not m_bDontRaiseEvent Then
    RaiseEvent ColumnWidthStartChange(lColumn + 1, lWidth, bCancel)
   End If
   
   If Not (bCancel) Then
      pGetDragImageRect lColumn, lWidth, tR, True
      DrawDragImage tR, True, False
   End If
End Sub
Private Sub m_cScroll_Change(eBar As EFSScrollBarConstants)
Dim bRedraw As Boolean
   CancelEdit
   If (eBar = efsHorizontal) Then
      m_lStartX = m_cScroll.Value(eBar)
   Else
      m_lStartY = m_cScroll.Value(eBar)
   End If
   If (eBar = efsHorizontal) Then
      If (m_cHeader.Visible) Then
         m_cHeader.Left = -m_cScroll.Value(efsHorizontal)
      Else
         m_cHeader.Left = 0
      End If
   End If
   
   If Not m_bDontRaiseEvent Then
    RaiseEvent ScrollChange
   End If
   
   pScrollSetDirty False
   Draw
End Sub

Private Sub m_cScroll_Scroll(eBar As EFSScrollBarConstants)
   m_cScroll_Change eBar
End Sub

Private Sub mnuAutoWidthCol_Click()
  AutoWidthColumns
End Sub

Private Sub mnuFilters_Click()
  ShowFilters
End Sub

Private Sub mnuFormats_Click()
  ShowFormats
End Sub

Private Sub mnuFormulas_Click()
  ShowFormulas
End Sub

Private Sub mnuGroup_Click()
  GroupColumns
End Sub

Private Sub mnuHideCols_Click()
  HideColumns
End Sub

Private Sub UserControl_DblClick()
On Error GoTo ErrorHandler
   If (m_bEnabled) Then
   
      If (m_iSelRow > 0) And (m_iSelCol > 0) Then
         If (m_iSelRow <= m_iRows) And (m_iSelCol <= m_iCols) Then
            pRequestEdit
         End If
      End If
   
      If Not m_bDontRaiseEvent Then
        RaiseEvent DblClick(m_iSelRow, m_iSelCol)
      End If
      
   End If
   Exit Sub
ErrorHandler:
   'Debug.Assert False
   'Exit Sub
End Sub

Private Sub UserControl_GotFocus()
On Error GoTo ErrorHandler
   m_bInFocus = True
   pScrollSetDirty True
   Draw
   Exit Sub
ErrorHandler:
   'Debug.Assert False
   'Exit Sub
End Sub

Private Sub UserControl_Initialize()
  On Error GoTo ControlError
  
   'debugmsg "cGrid:Initialize"
   With m_tDefaultCell
      .iIconIndex = -1
      .lExtraIconIndex = -1
      .lGroupIconIndex = -1
      .OBackColor = CLR_NONE
      .OForeColor = CLR_NONE
      .eTextFlags = DT_SINGLELINE Or DT_WORD_ELLIPSIS Or DT_LEFT Or DT_NOPREFIX
      .sText = Empty
      .lIndent = 0
      .bDirtyFlag = True
      .bSelected = False
      .lItemData = 0
      .sTag = vbNullString
   End With
   
   pRedimvIRow False, 0
   ReDim m_tvRows(0 To 0) As tRowPosition
   ReDim m_tCols(0 To 0) As tColPosition
   
   m_lDefaultColumnWidth = 64
   m_lDefaultRowHeight = 20
   m_oGridLineColor = vbButtonFace
   m_oHighlightBackColor = vbHighlight ' 19/10/1999 (8)
   m_oHighlightForeColor = vbHighlightText
   m_bAllowVert = True
   m_bAllowHorz = True
   m_eBorderStyle = ecgBorderStyle3d
   m_bRedraw = True
   m_bDrawFocusRectangle = True
   m_bDisableIcons = True
   m_bHighlightSelectedIcons = True
   
   Set m_Groups = New cGridGroups
   Set m_ColFormulas = New cGridColFormulas
   Set m_ColFormats = New cGridColFormats
   Set m_ColFilters = New cGridColFilters
   
   pCreateImageGroup
      
   GoTo ExitProc
ControlError:
  MngError "UserControl_Initialize"
ExitProc:
End Sub

Private Sub UserControl_InitProperties()
   pCreateHeader
   BackColor = vbWindowBackground
   ForeColor = vbWindowText
   Set Font = Ambient.Font
   BorderStyle = ecgBorderStyle3d
   Header = True
   Enabled = True
   KeyHelp = vbKeyF4
   KeyReturnEmulateTab = True
End Sub

Private Sub UserControl_KeyDown(KeyCode As Integer, Shift As Integer)
Dim iRow As Long, iCol As Long
Dim iInitSelCol As Long, iInitSelRow As Long
Dim lNextPage As Long
Dim bFound As Boolean
Dim iSelRow As Long
Dim bSingleGroupRowScroll As Boolean
Dim bDoDefault As Boolean
Dim RealKeyCode As Integer
Dim oldSelRow As Long

On Error GoTo ErrorHandler

   If KeyCode = 93 Then
      UserControl_MouseUp vbRightButton, 0, 0, 0
   End If

   iInitSelCol = m_iSelCol
   iInitSelRow = m_iSelRow

   RealKeyCode = KeyCode

   If KeyCode = vbKeyReturn And m_KeyReturnEmulateTab Then
     KeyCode = vbKeyTab
   End If

   If (KeyCode = vbKeyTab) Then
      If (Shift And vbShiftMask) = vbShiftMask Then
         If (m_bRowMode) Then
            KeyCode = vbKeyUp
         Else
            KeyCode = vbKeyLeft
         End If
      Else
         If (m_bRowMode) Then
            KeyCode = vbKeyDown
         Else
            KeyCode = vbKeyRight
         End If
      End If
   End If
   
   If Not (m_bEnabled) Then
      Select Case KeyCode
      Case vbKeyUp
         If (m_cScroll.Visible(efsVertical)) Then
            m_cScroll.Value(efsVertical) = m_cScroll.Value(efsVertical) - m_cScroll.SmallChange(efsVertical)
         End If
      Case vbKeyDown
         If (m_cScroll.Visible(efsVertical)) Then
            m_cScroll.Value(efsVertical) = m_cScroll.Value(efsVertical) + m_cScroll.SmallChange(efsVertical)
         End If
      Case vbKeyLeft
         If (m_cScroll.Visible(efsHorizontal)) Then
            m_cScroll.Value(efsHorizontal) = m_cScroll.Value(efsHorizontal) - m_cScroll.SmallChange(efsHorizontal)
         End If
      Case vbKeyRight
         If (m_cScroll.Visible(efsHorizontal)) Then
            m_cScroll.Value(efsHorizontal) = m_cScroll.Value(efsHorizontal) + m_cScroll.SmallChange(efsHorizontal)
         End If
      Case vbKeyPageUp
         If (m_cScroll.Visible(efsVertical)) Then
            m_cScroll.Value(efsVertical) = m_cScroll.Value(efsVertical) - m_cScroll.LargeChange(efsVertical)
         End If
      Case vbKeyPageDown
         If (m_cScroll.Visible(efsVertical)) Then
            m_cScroll.Value(efsVertical) = m_cScroll.Value(efsVertical) + m_cScroll.LargeChange(efsVertical)
         End If
      End Select
      pEvalSelectionChange iInitSelRow, iInitSelCol, m_iSelRow, m_iSelCol
      Exit Sub
   End If

   If m_iRows > 0 And m_iCols > 0 Then
      bDoDefault = True
   End If
   
   If Not m_bDontRaiseEvent Then
    RaiseEvent KeyDown(RealKeyCode, Shift, bDoDefault)
   End If
   
   If (bDoDefault) Then

      '
      If (m_iRows = 0) Or (m_iCols = 0) Then
         pEvalSelectionChange iInitSelRow, iInitSelCol, m_iSelRow, m_iSelCol
         Exit Sub
      End If
      
      If m_iSelRow <= 0 Or m_iSelRow <= 0 Then
         pEvalSelectionChange iInitSelRow, iInitSelCol, m_iSelRow, m_iSelCol
         Exit Sub
      End If
      
      If (KeyCode = vbKeyLeft Or KeyCode = vbKeyRight) And Shift = 0 Then
         If (m_tvRows(m_vIRow(m_iSelRow)).bGroupRow) Then
            If m_cScroll.Visible(efsHorizontal) Then
               If KeyCode = vbKeyLeft Then
                  If m_cScroll.Value(efsHorizontal) <> 0 Then
                     bSingleGroupRowScroll = True
                  End If
               Else
                  If m_cScroll.Value(efsHorizontal) <> m_cScroll.Max(efsHorizontal) Then
                     bSingleGroupRowScroll = True
                  End If
               End If
            End If
         End If
      End If
         
      Select Case KeyCode
      Case vbKeySpace
         If (Shift And vbCtrlMask) = vbCtrlMask Then
            If (m_bMultiSelect) Then
               ' Select/deselect this cell
               If (m_bRowMode) Then
                  For iCol = 1 To m_iCols
                     m_tvCells(iCol, m_vIRow(m_iSelRow)).bSelected = Not (m_tvCells(iCol, m_vIRow(m_iSelRow)).bSelected)
                     m_tvCells(iCol, m_vIRow(m_iSelRow)).bDirtyFlag = True
                  Next iCol
               Else
                  m_tvCells(m_iSelCol, m_vIRow(m_iSelRow)).bSelected = Not (m_tvCells(m_iSelCol, m_vIRow(m_iSelRow)).bSelected)
                  m_tvCells(m_iSelCol, m_vIRow(m_iSelRow)).bDirtyFlag = True
               End If
               Draw
               pRequestEdit
            End If
         End If
      
      Case vbKeyLeft
         m_sSearchString = vbNullString
         If (m_bRowMode) Or bSingleGroupRowScroll Then
            ' Equivalent to scrolling left
            m_cScroll.Value(efsHorizontal) = m_cScroll.Value(efsHorizontal) - m_cScroll.SmallChange(efsHorizontal)
         Else
            pGetNextVisibleCell -1, 0
            If (m_bMultiSelect) Then
               If (Shift And vbShiftMask) = vbShiftMask Then
                  ' Add this cell to the selection:
                  m_tvCells(m_iSelCol, m_vIRow(m_iSelRow)).bSelected = Not (m_tvCells(m_iSelCol, m_vIRow(m_iSelRow)).bSelected)
                  m_tvCells(m_iSelCol, m_vIRow(m_iSelRow)).bDirtyFlag = True
               ElseIf (Shift And vbCtrlMask) = vbCtrlMask Then
                  m_tvCells(m_iSelCol, m_vIRow(m_iSelRow)).bDirtyFlag = True
               ElseIf (Shift = 0) Then
                  ' This is the selected cell:
                  For iRow = 1 To m_iRows
                     For iCol = 1 To m_iCols
                        m_tvCells(iCol, m_vIRow(iRow)).bDirtyFlag = (((iRow = m_iSelRow) And (iCol = m_iSelCol)) <> m_tvCells(iCol, m_vIRow(iRow)).bSelected)
                        m_tvCells(iCol, m_vIRow(iRow)).bSelected = ((iRow = m_iSelRow) And (iCol = m_iSelCol))
                     Next iCol
                  Next iRow
               End If
            Else
               pSingleModeSelect
            End If
            If Not (pbEnsureVisible(m_iSelRow, m_iSelCol)) Then
               Draw
            End If
            
         End If
         
      Case vbKeyRight
         m_sSearchString = vbNullString
         If (m_bRowMode) Or bSingleGroupRowScroll Then
            ' Equivalent to scrolling right
            m_cScroll.Value(efsHorizontal) = m_cScroll.Value(efsHorizontal) + m_cScroll.SmallChange(efsHorizontal)
         Else
         
            Dim OldCol As Long
            Dim OldRow As Long
         
            OldCol = m_iSelCol
            OldRow = m_iSelRow
         
            pGetNextVisibleCell 1, 0
            If (m_bMultiSelect) Then
               If (Shift And vbShiftMask) = vbShiftMask Then
                  ' Add this cell to the selection:
                  m_tvCells(m_iSelCol, m_vIRow(m_iSelRow)).bSelected = Not (m_tvCells(m_iSelCol, m_vIRow(m_iSelRow)).bSelected)
                  m_tvCells(m_iSelCol, m_vIRow(m_iSelRow)).bDirtyFlag = True
               ElseIf (Shift And vbCtrlMask) = vbCtrlMask Then
                  m_tvCells(m_iSelCol, m_vIRow(m_iSelRow)).bDirtyFlag = True
               ElseIf (Shift = 0) Then
                  ' This is the selected cell:
                  For iRow = 1 To m_iRows
                     For iCol = 1 To m_iCols
                        m_tvCells(iCol, m_vIRow(iRow)).bDirtyFlag = (((iRow = m_iSelRow) And (iCol = m_iSelCol)) <> m_tvCells(iCol, m_vIRow(iRow)).bSelected)
                        m_tvCells(iCol, m_vIRow(iRow)).bSelected = ((iRow = m_iSelRow) And (iCol = m_iSelCol))
                     Next iCol
                  Next iRow
               End If
            Else
               pSingleModeSelect
            End If
            If Not (pbEnsureVisible(m_iSelRow, m_iSelCol)) Then
               Draw
            End If
         End If
         
         ' If is the same cell raise event RequestNewRow
         If OldCol = m_iSelCol And OldRow = m_iSelRow Then
            If Not m_bDontRaiseEvent Then
              RaiseEvent RequestNewRow
            End If
         End If
      Case vbKeyUp
         ' Move selection up if there is one, otherwise scroll:
         m_sSearchString = vbNullString
         If (m_iSelRow <> 0) Then
            If (m_iSelRow > 1) Then
               pGetNextVisibleCell 0, -1
               If (m_bMultiSelect) Then
                  If (m_bRowMode) Then
                     If (Shift And vbShiftMask) = vbShiftMask Then
                        ' Add this row to the selection:
                        For iCol = 1 To m_iCols
                           m_tvCells(iCol, m_vIRow(m_iSelRow)).bSelected = Not (m_tvCells(iCol, m_vIRow(m_iSelRow)).bSelected)
                           m_tvCells(iCol, m_vIRow(m_iSelRow)).bDirtyFlag = True
                        Next iCol
                     ElseIf (Shift And vbCtrlMask) = vbCtrlMask Then
                        m_tvCells(m_iSelCol, m_vIRow(m_iSelRow)).bDirtyFlag = True
                     ElseIf (Shift = 0) Then
                        ' Switch selected row to current:
                        For iRow = 1 To m_iRows
                           For iCol = 1 To m_iCols
                              m_tvCells(iCol, m_vIRow(iRow)).bDirtyFlag = ((iRow = m_iSelRow) <> m_tvCells(iCol, m_vIRow(iRow)).bSelected)
                              m_tvCells(iCol, m_vIRow(iRow)).bSelected = (iRow = m_iSelRow)
                           Next iCol
                        Next iRow
                     End If
                  Else
                     If (Shift And vbShiftMask) = vbShiftMask Then
                        ' Add/remove this cell from the selection:
                        m_tvCells(m_iSelCol, m_vIRow(m_iSelRow)).bSelected = Not (m_tvCells(m_iSelCol, m_vIRow(m_iSelRow)).bSelected)
                        m_tvCells(m_iSelCol, m_vIRow(m_iSelRow)).bDirtyFlag = True
                     ElseIf (Shift And vbCtrlMask) = vbCtrlMask Then
                        m_tvCells(m_iSelCol, m_vIRow(m_iSelRow)).bDirtyFlag = True
                     ElseIf (Shift = 0) Then
                        ' Switch selected cell to current:
                        For iRow = 1 To m_iRows
                           For iCol = 1 To m_iCols
                              m_tvCells(iCol, m_vIRow(iRow)).bDirtyFlag = (((iRow = m_iSelRow) And (iCol = m_iSelCol)) <> m_tvCells(iCol, m_vIRow(iRow)).bSelected)
                              m_tvCells(iCol, m_vIRow(iRow)).bSelected = ((iRow = m_iSelRow) And (iCol = m_iSelCol))
                           Next iCol
                        Next iRow
                     End If
                  End If
               Else
                  pSingleModeSelect
               End If
               If Not (pbEnsureVisible(m_iSelRow, m_iSelCol)) Then
                  Draw
               End If
            End If
         Else
            m_cScroll.Value(efsVertical) = m_cScroll.Value(efsVertical) - m_cScroll.SmallChange(efsVertical)
         End If
      
      Case vbKeyDown
         ' Move selection up if there is one, otherwise scroll:
         m_sSearchString = vbNullString
         If (m_iSelRow <> 0) Then
            If (m_iSelRow < m_iRows) Then
               pGetNextVisibleCell 0, 1
               If (m_bMultiSelect) Then
                  If (m_bRowMode) Then
                     If (Shift And vbShiftMask) = vbShiftMask Then
                        ' Add this row to the selection:
                        For iCol = 1 To m_iCols
                           m_tvCells(iCol, m_vIRow(m_iSelRow)).bSelected = Not (m_tvCells(iCol, m_vIRow(m_iSelRow)).bSelected)
                           m_tvCells(iCol, m_vIRow(m_iSelRow)).bDirtyFlag = True
                        Next iCol
                     ElseIf (Shift And vbCtrlMask) = vbCtrlMask Then
                        m_tvCells(m_iSelCol, m_vIRow(m_iSelRow)).bDirtyFlag = True
                     ElseIf (Shift = 0) Then
                        ' Switch selected row to current:
                        For iRow = 1 To m_iRows
                           For iCol = 1 To m_iCols
                              m_tvCells(iCol, m_vIRow(iRow)).bDirtyFlag = ((iRow = m_iSelRow) <> m_tvCells(iCol, m_vIRow(iRow)).bSelected)
                              m_tvCells(iCol, m_vIRow(iRow)).bSelected = (iRow = m_iSelRow)
                           Next iCol
                        Next iRow
                     End If
                  Else
                     If (Shift And vbShiftMask) = vbShiftMask Then
                        ' Add/remove this cell from the selection:
                        m_tvCells(m_iSelCol, m_vIRow(m_iSelRow)).bSelected = Not (m_tvCells(m_iSelCol, m_vIRow(m_iSelRow)).bSelected)
                        m_tvCells(m_iSelCol, m_vIRow(m_iSelRow)).bDirtyFlag = True
                     ElseIf (Shift And vbCtrlMask) = vbCtrlMask Then
                        m_tvCells(m_iSelCol, m_vIRow(m_iSelRow)).bDirtyFlag = True
                     ElseIf (Shift = 0) Then
                        ' Switch selected cell to current:
                        For iRow = 1 To m_iRows
                           For iCol = 1 To m_iCols
                              m_tvCells(iCol, m_vIRow(iRow)).bDirtyFlag = (m_tvCells(iCol, m_vIRow(iRow)).bSelected <> ((iRow = m_iSelRow) And (iCol = m_iSelCol)))
                              m_tvCells(iCol, m_vIRow(iRow)).bSelected = ((iRow = m_iSelRow) And (iCol = m_iSelCol))
                           Next iCol
                        Next iRow
                     End If
                  End If
               Else
                  pSingleModeSelect
               End If
               If Not (pbEnsureVisible(m_iSelRow, m_iSelCol)) Then
                  Draw
               End If
            Else
               
               '
               ' Vamos a ver si funca
               '
                ' If is the same cell raise event RequestNewRow
                If m_iRows = m_iSelRow Then
                   If Not m_bDontRaiseEvent Then
                     RaiseEvent RequestNewRow
                   End If
                End If
            
            End If
         Else
            m_cScroll.Value(efsVertical) = m_cScroll.Value(efsVertical) - m_cScroll.SmallChange(efsVertical)
         End If
      
      Case vbKeyPageUp
         ' Move up by the equivalent of one page:
         m_sSearchString = vbNullString
         iRow = m_iSelRow
         lNextPage = m_tvRows(m_vIRow(iRow)).lStartY - m_lAvailheight + m_tvRows(m_vIRow(iRow)).lHeight
         Do
            iRow = iRow - 1
            If (iRow < 1) Then
               iRow = plGetFirstVisibleRow()
               bFound = True
            Else
               If (m_tvRows(m_vIRow(iRow)).bVisible) Then
                  If (m_tvRows(m_vIRow(iRow)).lStartY < lNextPage) Then
                     bFound = True
                  End If
               End If
            End If
         Loop While Not bFound
         
         If (m_bMultiSelect) Then
            iSelRow = iRow
            If (Shift And vbShiftMask) = vbShiftMask Then
               ' Toggle everything between m_iSelRow and iRow to the selection
               If (m_bRowMode) Then
                  For iRow = m_iSelRow - 1 To iRow Step -1
                     For iCol = 1 To m_iCols
                        m_tvCells(m_iSelCol, m_vIRow(iRow)).bDirtyFlag = True
                        m_tvCells(iCol, m_vIRow(iRow)).bSelected = Not (m_tvCells(iCol, m_vIRow(iRow)).bSelected)
                     Next iCol
                  Next iRow
               Else
                  For iRow = m_iSelRow - 1 To iRow Step -1
                     m_tvCells(m_iSelCol, m_vIRow(iRow)).bDirtyFlag = True
                     m_tvCells(m_iSelCol, m_vIRow(iRow)).bSelected = Not (m_tvCells(m_iSelCol, m_vIRow(iRow)).bSelected)
                  Next iRow
               End If
            ElseIf (Shift And vbCtrlMask) = vbCtrlMask Then
            
            Else
               If (m_bRowMode) Then
                  For iRow = 1 To m_iRows
                     For iCol = 1 To m_iCols
                        m_tvCells(iCol, m_vIRow(iRow)).bDirtyFlag = (m_tvCells(iCol, m_vIRow(iRow)).bSelected <> (iRow = iSelRow))
                        m_tvCells(iCol, m_vIRow(iRow)).bSelected = (iRow = iSelRow)
                     Next iCol
                  Next iRow
               Else
                  For iRow = 1 To m_iRows
                     For iCol = 1 To m_iCols
                        m_tvCells(iCol, m_vIRow(iRow)).bDirtyFlag = (m_tvCells(iCol, m_vIRow(iRow)).bSelected <> ((iRow = iSelRow) And (iCol = m_iSelCol)))
                        m_tvCells(iCol, m_vIRow(iRow)).bSelected = ((iRow = iSelRow) And (iCol = m_iSelCol))
                     Next iCol
                  Next iRow
               End If
            End If
            m_iSelRow = iSelRow
         Else
            m_iSelRow = iRow
            pSingleModeSelect
         End If
         If Not (pbEnsureVisible(m_iSelRow, m_iSelCol)) Then
            Draw
         End If
      
      Case vbKeyPageDown
         m_sSearchString = vbNullString
         ' Move down by the equivalent of one page:
         iRow = m_iSelRow
         lNextPage = m_tvRows(m_vIRow(iRow)).lStartY + m_lAvailheight - m_tvRows(m_vIRow(iRow)).lHeight
         Do
            iRow = iRow + 1
            If (iRow > m_iRows) Then
               iRow = plGetLastVisibleRow()
               bFound = True
            End If
            If (m_tvRows(m_vIRow(iRow)).bVisible) Then
               If (m_tvRows(m_vIRow(iRow)).lStartY > lNextPage) Then
                  bFound = True
               End If
            End If
         Loop While Not bFound
         
         If (m_bMultiSelect) Then
            iSelRow = iRow
            If (Shift And vbShiftMask) = vbShiftMask Then
               ' Toggle everything between m_iSelRow and iRow to the selection
               If (m_bRowMode) Then
                  For iRow = m_iSelRow + 1 To iRow
                     For iCol = 1 To m_iCols
                        m_tvCells(m_iSelCol, m_vIRow(iRow)).bDirtyFlag = True
                        m_tvCells(iCol, m_vIRow(iRow)).bSelected = Not (m_tvCells(iCol, m_vIRow(iRow)).bSelected)
                     Next iCol
                  Next iRow
               Else
                  For iRow = m_iSelRow + 1 To iRow
                     m_tvCells(m_iSelCol, m_vIRow(iRow)).bDirtyFlag = True
                     m_tvCells(m_iSelCol, m_vIRow(iRow)).bSelected = Not (m_tvCells(m_iSelCol, m_vIRow(iRow)).bSelected)
                  Next iRow
               End If
            ElseIf (Shift And vbCtrlMask) = vbCtrlMask Then
            
            ElseIf (Shift = 0) Then
               If (m_bRowMode) Then
                  For iRow = 1 To m_iRows
                     For iCol = 1 To m_iCols
                        m_tvCells(iCol, m_vIRow(iRow)).bDirtyFlag = (m_tvCells(iCol, m_vIRow(iRow)).bSelected <> (iRow = iSelRow))
                        m_tvCells(iCol, m_vIRow(iRow)).bSelected = (iRow = iSelRow)
                     Next iCol
                  Next iRow
               Else
                  For iRow = 1 To m_iRows
                     For iCol = 1 To m_iCols
                        m_tvCells(iCol, m_vIRow(iRow)).bDirtyFlag = (m_tvCells(iCol, m_vIRow(iRow)).bSelected <> ((iRow = iSelRow) And (iCol = m_iSelCol)))
                        m_tvCells(iCol, m_vIRow(iRow)).bSelected = ((iRow = iSelRow) And (iCol = m_iSelCol))
                     Next iCol
                  Next iRow
               End If
               
            End If
            m_iSelRow = iSelRow
         Else
            m_iSelRow = iRow
            pSingleModeSelect
         End If
         If Not (pbEnsureVisible(m_iSelRow, m_iSelCol)) Then
            Draw
         End If
         
      
      Case vbKeyHome
         m_sSearchString = vbNullString
         oldSelRow = m_iSelRow
         m_iSelRow = plGetFirstVisibleRow()
         
         If (m_bMultiSelect) Then
            If (Shift And vbShiftMask) = vbShiftMask Then
               If oldSelRow < 0 Or oldSelRow > m_iRows Then
                oldSelRow = m_iSelRow
               End If
               For iRow = oldSelRow To 1 Step -1
                  If m_bRowMode Then
                     For iCol = 1 To m_iCols
                        m_tvCells(iCol, m_vIRow(iRow)).bDirtyFlag = True
                        m_tvCells(iCol, m_vIRow(iRow)).bSelected = True 'Not (m_tvCells(iCol, m_vIrow(iRow)).bSelected)
                     Next iCol
                  Else
                     For iCol = 1 To m_iSelCol
                        m_tvCells(iCol, m_vIRow(iRow)).bDirtyFlag = True
                        m_tvCells(iCol, m_vIRow(iRow)).bSelected = True 'Not (m_tvCells(iCol, m_vIrow(iRow)).bSelected)
                     Next iCol
                  End If
               Next iRow
            Else
               For iRow = 1 To m_iRows
                  For iCol = 1 To m_iCols
                     If (m_bRowMode) Then
                        m_tvCells(iCol, m_vIRow(iRow)).bDirtyFlag = (m_tvCells(iCol, m_vIRow(iRow)).bSelected = (iRow = m_iSelRow))
                        m_tvCells(iCol, m_vIRow(iRow)).bSelected = (iRow = m_iSelRow)
                     Else
                        m_tvCells(iCol, m_vIRow(iRow)).bDirtyFlag = (m_tvCells(iCol, m_vIRow(iRow)).bSelected = ((iRow = m_iSelRow) And (iCol = m_iSelCol)))
                        m_tvCells(iCol, m_vIRow(iRow)).bSelected = ((iRow = m_iSelRow) And (iCol = m_iSelCol))
                     End If
                  Next iCol
               Next iRow
            End If
         Else
            pSingleModeSelect
         End If
         If Not (pbEnsureVisible(m_iSelRow, m_iSelCol)) Then
            Draw
         End If
         
      Case vbKeyEnd
         m_sSearchString = vbNullString
         oldSelRow = m_iSelRow
         m_iSelRow = plGetLastVisibleRow()
         If (m_bMultiSelect) Then
            If (Shift And vbShiftMask) = vbShiftMask Then
               If oldSelRow < 0 Or oldSelRow > m_iRows Then
                oldSelRow = m_iSelRow
               End If
               For iRow = oldSelRow To m_iRows
                  If m_bRowMode Then
                     For iCol = 1 To m_iCols
                        m_tvCells(iCol, m_vIRow(iRow)).bDirtyFlag = True
                        m_tvCells(iCol, m_vIRow(iRow)).bSelected = True 'Not (m_tvCells(iCol, m_vIrow(iRow)).bSelected)
                     Next iCol
                  Else
                     For iCol = 1 To m_iSelCol
                        m_tvCells(iCol, m_vIRow(iRow)).bDirtyFlag = True
                        m_tvCells(iCol, m_vIRow(iRow)).bSelected = True 'Not (m_tvCells(iCol, m_vIrow(iRow)).bSelected)
                     Next iCol
                  End If
               Next iRow
            Else
               For iRow = 1 To m_iRows
                  For iCol = 1 To m_iCols
                     If (m_bRowMode) Then
                        m_tvCells(iCol, m_vIRow(iRow)).bDirtyFlag = (m_tvCells(iCol, m_vIRow(iRow)).bSelected = (iRow = m_iSelRow))
                        m_tvCells(iCol, m_vIRow(iRow)).bSelected = (iRow = m_iSelRow)
                     Else
                        m_tvCells(iCol, m_vIRow(iRow)).bDirtyFlag = (m_tvCells(iCol, m_vIRow(iRow)).bSelected = ((iRow = m_iSelRow) And (iCol = m_iSelCol)))
                        m_tvCells(iCol, m_vIRow(iRow)).bSelected = ((iRow = m_iSelRow) And (iCol = m_iSelCol))
                     End If
                  Next iCol
               Next iRow
            End If
         Else
            pSingleModeSelect
         End If
         If Not (pbEnsureVisible(m_iSelRow, m_iSelCol)) Then
            Draw
         End If
      
      Case vbKeyReturn, vbKeyF2
      
        ' Equivalent to double-clicking the cell:
        pRequestEdit
        
      Case m_KeyHelp
      
        If Not m_bDontRaiseEvent Then
          RaiseEvent ShowHelp(m_iSelRow, m_iSelCol)
        End If
        
      Case vbKeyEscape
         ' If in Edit then cancel editing:
         m_sSearchString = vbNullString
         CancelEdit
         
      Case vbKeyDelete
        If (Shift And vbCtrlMask) = vbCtrlMask Then
          pDeleteRow m_iSelRow
        Else
          
          If Not m_bDontRaiseEvent Then
            RaiseEvent DeleteCellValue(m_iSelRow, m_iSelCol)
          End If
          
        End If
               
      End Select
   End If
   
   pEvalSelectionChange iInitSelRow, iInitSelCol, m_iSelRow, m_iSelCol
   Exit Sub

ErrorHandler:
   'Debug.Assert False
   'Exit Sub
   'Resume 0
End Sub

Private Sub pEvalSelectionChange(ByVal lRow1 As Long, ByVal lCol1 As Long, ByVal lRow2 As Long, ByVal lCol2 As Long)
  If (lCol1 <> lCol2) Or (lRow1 <> lRow2) Then
    
    If Not m_bDontRaiseEvent Then
      RaiseEvent SelectionChange(m_iSelRow, m_iSelCol)
    End If
    
    If (lCol1 <> lCol2) Then
      
      If Not m_bDontRaiseEvent Then
        RaiseEvent SelectionColChange(m_iSelRow, m_iSelCol)
      End If
      
      'debugmsg "SelectionColChange"
    End If
    
    If (lRow1 <> lRow2) Then
    
      If Not m_bDontRaiseEvent Then
        RaiseEvent SelectionRowChange(m_iSelRow, m_iSelCol)
      End If
      
      'debugmsg "SelectionRowChange"
    End If
  End If
End Sub

Private Sub pDeleteRow(ByVal lRow As Long)
  Dim bCancel As Boolean
  
  If Not m_bDontRaiseEvent Then
    RaiseEvent DeleteRow(lRow, bCancel)
  End If
  
  If bCancel Then Exit Sub
  
  pRemoveRow lRow
  
  If Not m_bDontRaiseEvent Then
    RaiseEvent RowWasDeleted(lRow)
  End If
End Sub

Private Sub UserControl_KeyPress(KeyAscii As Integer)
  On Error GoTo ErrorHandler
  
  If Not (KeyAscii = vbKeyReturn And m_KeyReturnEmulateTab) Then
    pRequestEdit KeyAscii
  End If
   
  If Not m_bDontRaiseEvent Then
    RaiseEvent KeyPress(KeyAscii)
  End If
  
  Exit Sub
ErrorHandler:
  'Debug.Assert False
  'Exit Sub
End Sub

Private Sub UserControl_KeyUp(KeyCode As Integer, Shift As Integer)
On Error GoTo ErrorHandler
   
   If Not m_bDontRaiseEvent Then
    RaiseEvent KeyUp(KeyCode, Shift)
   End If
   
   Exit Sub
ErrorHandler:
   'Debug.Assert False
   'Exit Sub
End Sub

Private Sub UserControl_LostFocus()
On Error GoTo ErrorHandler
   m_bInFocus = False
   pScrollSetDirty True
   Draw
   Exit Sub
ErrorHandler:
   'Debug.Assert False
   'Exit Sub
End Sub

Private Sub UserControl_MouseDown(Button As Integer, Shift As Integer, x As Single, y As Single)
  Dim lSelRow As Long, lSelCol As Long
  Dim iRow As Long, iCol As Long
  Dim iStartCol As Long, iEndCol As Long, iStartRow As Long, iEndRow As Long
  Dim bS As Boolean
  Dim iInitSelCol As Long, iInitSelRow As Long
  Dim bDefault As Boolean
  Dim bOnlyOneSelected As Boolean
  
  Dim px As Long
  Dim py As Long

  On Error GoTo ErrorHandler
  
  If Not (m_bEnabled) Then
    
    ' Para que el usuario pueda seleccionar el
    ' menu poup de autosizecols
    '
    If Button = vbRightButton Then
      RaiseEvent MouseDown(Button, Shift, x, y, bDefault)
    End If
    
    Exit Sub
  End If

  iInitSelCol = m_iSelCol
  iInitSelRow = m_iSelRow

  bDefault = True
  
  If Not m_bDontRaiseEvent Then
    RaiseEvent MouseDown(Button, Shift, x, y, bDefault)
  End If
  
  If Button = vbRightButton Then
    If m_bMultiSelect Then
      bOnlyOneSelected = pIsOnlyOnSelected()
    Else
      bOnlyOneSelected = True
    End If
  End If
  
  If bDefault And (Not Button = vbRightButton Or bOnlyOneSelected) Then
  
    m_sSearchString = vbNullString
    m_bMouseDown = True
    
    px = x \ Screen.TwipsPerPixelX
    py = y \ Screen.TwipsPerPixelY
    
    CellFromPoint px, py, lSelRow, lSelCol
    
    If pClickInGroup(px, py, lSelRow, lSelCol) Then
      
      Dim oGridGroup As Object
      Set oGridGroup = CSKernelClient2.CreateObject("CSGridGroups.cGridGroups")
      
      oGridGroup.ClickInGroup Me, lSelRow, lSelCol
      Set oGridGroup = Nothing
      
    ElseIf (lSelRow > 0) And (lSelCol > 0) Then
      If (Shift And vbShiftMask) = vbShiftMask Then
        If (m_iSelRow = 0) Or (m_iSelCol = 0) Then
          m_iSelRow = lSelRow
          m_iSelCol = lSelCol
        End If
        If (m_bMultiSelect) Then
          If (lSelRow > 0) And (lSelCol > 0) Then
            If (lSelRow = m_iSelRow) And (lSelCol = m_iSelCol) Then
              pRequestEdit
              Exit Sub
            Else
              ' We have made a selection with shift held down.
              ' Select all the cells between here and the previous selected point:
              If (lSelCol > m_iSelCol) Then
                If (m_bRowMode) Then
                  iStartCol = 1
                  iEndCol = m_iCols
                Else
                  iStartCol = m_iSelCol
                  iEndCol = lSelCol
                End If
              Else
                If (m_bRowMode) Then
                  iStartCol = 1
                  iEndCol = m_iCols
                Else
                  iStartCol = lSelCol
                  iEndCol = m_iSelCol
                End If
              End If
              
              If (lSelRow > m_iSelRow) Then
                iStartRow = m_iSelRow
                iEndRow = lSelRow
              Else
                iStartRow = lSelRow
                iEndRow = m_iSelRow
              End If
              
              For iRow = 1 To m_iRows
                For iCol = 1 To m_iCols
                  If (iRow >= iStartRow) And (iRow <= iEndRow) Then
                    If (iCol >= iStartCol) And (iCol <= iEndCol) Then
                      bS = True
                    Else
                      bS = False
                    End If
                  Else
                    bS = False
                  End If
                  m_tvCells(iCol, m_vIRow(iRow)).bDirtyFlag = (bS <> m_tvCells(iCol, m_vIRow(iRow)).bSelected)
                  m_tvCells(iCol, m_vIRow(iRow)).bSelected = bS
                Next iCol
              Next iRow
              
              If Not (pbEnsureVisible(m_iSelRow, m_iSelCol)) Then
                Draw
              End If
              pEvalSelectionChange iInitSelRow, iInitSelCol, m_iSelRow, m_iSelCol
              Exit Sub
              
            End If
          End If
        End If
      Else
        m_iSelRow = lSelRow
        m_iSelCol = lSelCol
      End If
      
      ' Select according to mode:
      If ((lSelRow = m_iLastSelRow) And (lSelCol = m_iLastSelCol)) Or m_bEditOnClick Then
        
        ' Esto es por que el pRequestEdit puede afectar alguna celda y
        ' al tocar el valor de una celda se dispara la funcion Draw, que
        ' si el flag de m_bRedraw = True nos modificara la columna
        ' seleccionada
        Dim bRedrawState As Boolean
        If m_bEditOnClick Then
          bRedrawState = m_bRedraw
          m_bRedraw = False
        End If
        
        pRequestEdit
        
        If m_bEditOnClick Then
          m_bRedraw = bRedrawState
        End If
      
      ElseIf m_tCols(lSelCol).bEditOnClick Then
        
        bRedrawState = m_bRedraw
        m_bRedraw = False
        
        pRequestEdit
        
        m_bRedraw = bRedrawState
        
      End If
      
      If m_bMultiSelect Then
        
        ' we could be selecting entire grid:
        If (m_tvRows(m_vIRow(lSelRow)).bFixed) And (m_tCols(lSelCol).bFixed) Then
          ' Select entire grid:
          For iRow = 1 To m_iRows
            For iCol = 1 To m_iCols
              m_tvCells(iCol, m_vIRow(iRow)).bDirtyFlag = True
              m_tvCells(iCol, m_vIRow(iRow)).bSelected = Not (m_tvCells(iCol, m_vIRow(iRow)).bSelected)
            Next iCol
          Next iRow
          
        ElseIf (m_tvRows(m_vIRow(lSelRow)).bFixed) Then
          ' Select entire col:
          If (Shift And vbCtrlMask) = vbCtrlMask Then
            ' .. add to selection
            For iRow = 1 To m_iRows
              m_tvCells(iCol, m_vIRow(iRow)).bDirtyFlag = True
              m_tvCells(lSelCol, m_vIRow(iRow)).bSelected = Not (m_tvCells(lSelCol, m_vIRow(iRow)).bSelected)
            Next iRow
          Else
            ' .. and deselect others:
            For iRow = 1 To m_iRows
              For iCol = 1 To m_iCols
                If (iCol = lSelCol) Then
                  bS = Not (m_tvCells(iCol, m_vIRow(iRow)).bSelected)
                Else
                  bS = False
                End If
                m_tvCells(iCol, m_vIRow(iRow)).bDirtyFlag = (bS <> m_tvCells(iCol, m_vIRow(iRow)).bSelected)
                m_tvCells(iCol, m_vIRow(iRow)).bSelected = bS
              Next iCol
            Next iRow
          End If
          
        ElseIf (m_tCols(lSelCol).bFixed) Then
          ' Select entire row:
          If (Shift And vbCtrlMask) = vbCtrlMask Then
            ' ..  add to selection
            For iCol = 1 To m_iCols
              m_tvCells(iCol, m_vIRow(lSelRow)).bDirtyFlag = True
              m_tvCells(iCol, m_vIRow(lSelRow)).bSelected = Not (m_tvCells(iCol, m_vIRow(lSelRow)).bSelected)
            Next iCol
          Else
            ' ... and deselect others:
            For iRow = 1 To m_iRows
              For iCol = 1 To m_iCols
                If (iRow = lSelRow) Then
                  bS = Not (m_tvCells(iCol, m_vIRow(iRow)).bSelected)
                Else
                  bS = False
                End If
                m_tvCells(iCol, m_vIRow(iRow)).bDirtyFlag = (bS <> m_tvCells(iCol, m_vIRow(iRow)).bSelected)
                m_tvCells(iCol, m_vIRow(iRow)).bSelected = bS
              Next iCol
            Next iRow
          End If
          
        Else
          ' Select this cell or row depending on mode:
          If (Shift And vbCtrlMask) = vbCtrlMask Then
            If (m_bRowMode) Then
              ' .. add row to selection:
              For iCol = 1 To m_iCols
                m_tvCells(iCol, m_vIRow(lSelRow)).bDirtyFlag = True
                m_tvCells(iCol, m_vIRow(lSelRow)).bSelected = Not (m_tvCells(iCol, m_vIRow(lSelRow)).bSelected)
              Next iCol
            Else
              ' .. add cell to selection:
              m_tvCells(lSelCol, m_vIRow(lSelRow)).bDirtyFlag = True
              m_tvCells(lSelCol, m_vIRow(lSelRow)).bSelected = Not (m_tvCells(lSelCol, m_vIRow(lSelRow)).bSelected)
            End If
          Else
            If (m_bRowMode) Then
              ' .. add row to selection and remove others:
              For iRow = 1 To m_iRows
                For iCol = 1 To m_iCols
                  If (iRow = lSelRow) Then
                    m_tvCells(iCol, m_vIRow(iRow)).bDirtyFlag = True
                    bS = True 'Not (m_tvCells(iCol, m_vIrow(iRow)).bSelected)
                  Else
                    bS = False
                    m_tvCells(iCol, m_vIRow(iRow)).bDirtyFlag = (bS <> m_tvCells(iCol, m_vIRow(iRow)).bSelected)
                  End If
                  m_tvCells(iCol, m_vIRow(iRow)).bSelected = bS
                Next iCol
              Next iRow
            Else
              ' .. Add cell to selection and remove others:
              For iRow = 1 To m_iRows
                For iCol = 1 To m_iCols
                  If ((iRow = lSelRow) And (iCol = lSelCol)) Then
                    bS = Not (m_tvCells(iCol, m_vIRow(iRow)).bSelected)
                  Else
                    bS = False
                  End If
                  m_tvCells(iCol, m_vIRow(iRow)).bDirtyFlag = (bS <> m_tvCells(iCol, m_vIRow(iRow)).bSelected)
                  m_tvCells(iCol, m_vIRow(iRow)).bSelected = bS
                Next iCol
              Next iRow
            End If
          End If
          
        End If
        If Not (pbEnsureVisible(m_iSelRow, m_iSelCol)) Then
          Draw
        End If
      Else
        pSingleModeSelect
        If Not (pbEnsureVisible(m_iSelRow, m_iSelCol)) Then
          Draw
        End If
      End If
    End If
  End If
  
  pEvalSelectionChange iInitSelRow, iInitSelCol, m_iSelRow, m_iSelCol
  Exit Sub
  
ErrorHandler:
  'Debug.Assert False
  'Exit Sub
  ' The classic :)
  ' I thought of adding a quote mark each time I got in there but there might be more
  ' quotes than code...
  'Resume 0
End Sub

Private Function pIsOnlyOnSelected() As Boolean
  Dim iRow As Long
  Dim iCol As Long
  Dim bOneSelected As Boolean

  ' Select entire grid:
  For iRow = 1 To m_iRows
    For iCol = 1 To m_iCols
      
      If m_tvCells(iCol, m_vIRow(iRow)).bSelected Then
        If bOneSelected Then
          Exit Function
        Else
          bOneSelected = True
          Exit For
        End If
      End If
    Next iCol
  Next iRow
  
  pIsOnlyOnSelected = True

End Function

Private Function pClickInGroup(ByVal px As Long, ByVal py As Long, ByVal lSelRow As Long, ByVal lSelCol As Long) As Boolean
  Dim minpy As Long
  Dim maxpy As Long
  Dim minpx As Long
  Dim maxpx As Long
  Dim iCol  As Long
  
  If lSelCol <= 0 Or lSelRow <= 0 Then Exit Function
  
  If m_tvCells(lSelCol, m_vIRow(lSelRow)).lGroupIconIndex <> -1 Then
    
    py = m_lStartY + py
    px = m_lStartX + px
    
    minpy = m_tvRows(m_vIRow(lSelRow)).lStartY
    maxpy = minpy + m_lIconSizeGroupY + 28
    
    For iCol = 1 To m_iCols
      If m_tCols(iCol).lCellColIndex = m_tvRows(m_vIRow(lSelRow)).lGroupStartColIndex Then
        minpx = m_tCols(iCol).lStartX
        maxpx = minpx + m_lIconSizeGroupX
        Exit For
      End If
    Next iCol
    
    pClickInGroup = px >= minpx And px <= maxpx And py >= minpy And py <= maxpy
  End If
End Function

Private Sub UserControl_MouseMove(Button As Integer, Shift As Integer, x As Single, y As Single)
On Error GoTo ErrorHandler
   If Not (m_bEnabled) Then
      Exit Sub
   End If
   
   If Not m_bDontRaiseEvent Then
    RaiseEvent MouseMove(Button, Shift, x, y)
   End If
   
   If (Button <> 0) Then
      ' Drag down!
      
   End If
   Exit Sub
ErrorHandler:
   'Debug.Assert False
   'Exit Sub
End Sub

Private Sub UserControl_MouseUp(Button As Integer, Shift As Integer, x As Single, y As Single)
Dim lSelRow As Long, lSelCol As Long
Dim iRow As Long, iCol As Long
Dim bS As Boolean

On Error GoTo ErrorHandler
   If Not (m_bEnabled) Then
      Exit Sub
   End If
   
   m_bMouseDown = False
   
   If Not m_bDontRaiseEvent Then
    RaiseEvent MouseUp(Button, Shift, x, y)
   End If
   
   If Button = vbRightButton Then
    Dim Cancel As Boolean
    
    If Not m_bDontRaiseEvent Then
      RaiseEvent ShowPopMenu(Cancel)
    End If
    
    If Cancel Then Exit Sub
    
    PopupMenu mnuPopMain
   End If
   
   Exit Sub

ErrorHandler:
   'Debug.Assert False
   'Exit Sub
End Sub

Private Sub UserControl_Paint()
On Error GoTo ErrorHandler
   If m_bRedraw And m_bUserMode Then
      pScrollSetDirty True
      Draw
   End If
   Exit Sub
ErrorHandler:
   'Debug.Assert False
   'Exit Sub
End Sub

Private Sub UserControl_ReadProperties(PropBag As PropertyBag)
   pCreateHeader
   If (UserControl.Ambient.UserMode) Then
      m_bUserMode = True
      Set m_cScroll = New cScrollBars
      With m_cScroll
         .Create UserControl.hWnd
         .Orientation = efsoBoth
         .Visible(efsHorizontal) = False
         .Visible(efsVertical) = False
      End With
      Set m_cFlatHeader = New cFlatHeader
      m_cFlatHeader.Attach hWnd
   Else
      m_bUserMode = False
   End If
   MultiSelect = PropBag.ReadProperty("MultiSelect", False)
   RowMode = PropBag.ReadProperty("RowMode", False)
   GridLines = PropBag.ReadProperty("GridLines", False)
   Set BackgroundPicture = PropBag.ReadProperty("BackgroundPicture", Nothing)
   BackgroundPictureHeight = PropBag.ReadProperty("BackgroundPictureHeight", 0)
   BackgroundPictureWidth = PropBag.ReadProperty("BackgroundPictureWidth", 0)
   BackColor = PropBag.ReadProperty("BackColor", vbWindowBackground)
   ForeColor = PropBag.ReadProperty("ForeColor", vbWindowText)
   GridLineColor = PropBag.ReadProperty("GridLineColor", vbButtonFace)
   HighlightBackColor = PropBag.ReadProperty("HighlightBackColor", vbHighlight) ' 19/10/1999 (8)
   HighlightForeColor = PropBag.ReadProperty("HighlightForeColor", vbHighlightText)
   Dim sFnt As New StdFont
   sFnt.Name = "MS Sans Serif"
   sFnt.Size = 8
   Set Font = PropBag.ReadProperty("Font", sFnt)
   Header = PropBag.ReadProperty("Header", True)
   HeaderButtons = PropBag.ReadProperty("HeaderButtons", True)
   ' 19/10/1999 (9): ensure persist all header vals
   HeaderDragReOrderColumns = PropBag.ReadProperty("HeaderDragReorderColumns", True)
   HeaderHotTrack = PropBag.ReadProperty("HeaderHotTrack", True)
   ' 19/10/1999 (10): allow to change the height of the header (may not look ok with icons, watch it)
   HeaderHeight = PropBag.ReadProperty("HeaderHeight", 20)
   ' 19/10/1999 (2): flat headers:
   HeaderFlat = PropBag.ReadProperty("HeaderFlat", False)
   BorderStyle = PropBag.ReadProperty("BorderStyle", ecgBorderStyle3d)
   ScrollBarStyle = PropBag.ReadProperty("ScrollBarStyle", efsRegular)
   Editable = PropBag.ReadProperty("Editable", False)
   Enabled = PropBag.ReadProperty("Enabled", True)
   KeyHelp = PropBag.ReadProperty("KeyHelp", vbKeyF4)
   KeyReturnEmulateTab = PropBag.ReadProperty("KeyReturnEmulateTab", True)
   DisableIcons = PropBag.ReadProperty("DisableIcons", False)
   HighlightSelectedIcons = PropBag.ReadProperty("HighlightSelectedIcons", True)
   DrawFocusRectangle = PropBag.ReadProperty("DrawFocusRectangle", True)
   EditOnClick = PropBag.ReadProperty("EditOnClick", False)
   Virtual = PropBag.ReadProperty("Virtual", False)
   DefaultRowHeight = PropBag.ReadProperty("DefaultRowHeight", 20)
   AutomaticSort = PropBag.ReadProperty("AutomaticSort", False)
   RowOddColor = PropBag.ReadProperty("RowOddColor", CLR_NONE)
   UserControl_Resize

End Sub

Private Sub UserControl_Resize()
Dim lWidth As Long
On Error GoTo ErrorHandler
   If m_bRedraw And m_bUserMode Then
      m_bDirty = True
      Draw
      pResizeHeader
   ElseIf Not (UserControl.Ambient.UserMode) Then
      If (m_bHeader) Then
         lWidth = UserControl.ScaleWidth \ Screen.TwipsPerPixelX
         m_cHeader.Move 0, 0, lWidth, m_cHeader.Height
      End If
   End If
   Exit Sub
ErrorHandler:
   'Debug.Assert False
   'Exit Sub
End Sub

Private Sub UserControl_Show()
Dim lS As Long
Static s_bNotFirst As Boolean
   '
   If Not (s_bNotFirst) Then
      lS = GetWindowLong(UserControl.hWnd, GWL_STYLE)
      lS = lS And Not (WS_HSCROLL Or WS_VSCROLL)
      SetWindowLong UserControl.hWnd, GWL_STYLE, lS
      SetWindowPos UserControl.hWnd, 0, 0, 0, 0, 0, SWP_NOMOVE Or SWP_NOSIZE Or SWP_NOZORDER Or SWP_FRAMECHANGED
      s_bNotFirst = True
   End If
End Sub

Private Sub UserControl_Terminate()
  On Error GoTo ControlError
Dim iFnt As Long
   
   Set m_cFlatHeader = Nothing
   Set m_cHeader = Nothing
   Set m_cScroll = Nothing
   
   If (m_hDC <> 0) Then
      If (m_hBmpOld <> 0) Then
         SelectObject m_hDC, m_hBmpOld
      End If
      If (m_hBmp <> 0) Then
         DeleteObject m_hBmp
      End If
      If (m_hFntOldDC <> 0) Then
         SelectObject m_hDC, m_hFntOldDC
      End If
      DeleteDC m_hDC
      m_hDC = 0
   End If
   If (m_hFntDC <> 0) Then
      DeleteObject m_hFntDC
      m_hFntDC = 0
   End If
   For iFnt = 1 To m_iFontCount
      DeleteObject m_hFnt(iFnt)
   Next iFnt
  
   Set m_Groups = Nothing
   Set m_ColFormulas = Nothing
   Set m_ColFormats = Nothing
   Set m_ColFilters = Nothing
   
   'debugmsg "cGrid:Terminate"
   
   GoTo ExitProc
ControlError:
  MngError "UserControl_Terminate"
ExitProc:
End Sub

Private Sub UserControl_WriteProperties(PropBag As PropertyBag)
   PropBag.WriteProperty "AutomaticSort", AutomaticSort, False
   PropBag.WriteProperty "MultiSelect", MultiSelect, False
   PropBag.WriteProperty "RowMode", RowMode, False
   PropBag.WriteProperty "GridLines", GridLines, False
   PropBag.WriteProperty "BackgroundPicture", BackgroundPicture, Nothing
   PropBag.WriteProperty "BackgroundPictureHeight", BackgroundPictureHeight
   PropBag.WriteProperty "BackgroundPictureWidth", BackgroundPictureWidth
   PropBag.WriteProperty "BackColor", BackColor, vbWindowBackground
   PropBag.WriteProperty "ForeColor", ForeColor, vbWindowText
   PropBag.WriteProperty "GridLineColor", GridLineColor, vbButtonFace
   PropBag.WriteProperty "HighlightBackColor", HighlightBackColor, vbHighlight ' 19/10/1999 (8)
   PropBag.WriteProperty "HighlightForeColor", HighlightForeColor, vbHighlightText
   Dim sFnt As New StdFont
   sFnt.Name = "MS Sans Serif"
   sFnt.Size = 8
   PropBag.WriteProperty "Font", Font, sFnt
   PropBag.WriteProperty "Header", Header, True
   PropBag.WriteProperty "HeaderButtons", HeaderButtons, True
   ' 19/10/1999 (9): ensure persist all header vals
   PropBag.WriteProperty "HeaderDragReorderColumns", HeaderDragReOrderColumns, True
   PropBag.WriteProperty "HeaderHotTrack", HeaderHotTrack, True
   ' 19/10/1999 (10): header height:
   PropBag.WriteProperty "HeaderHeight", HeaderHeight, 20
   ' 19/10/1999 (2): flat headers:
   PropBag.WriteProperty "HeaderFlat", HeaderFlat, False
   PropBag.WriteProperty "BorderStyle", BorderStyle, ecgBorderStyle3d
   PropBag.WriteProperty "ScrollBarStyle", ScrollBarStyle, efsRegular
   PropBag.WriteProperty "Editable", Editable, False
   PropBag.WriteProperty "Enabled", Enabled, True
   PropBag.WriteProperty "DisableIcons", DisableIcons, False
   PropBag.WriteProperty "HighlightSelectedIcons", HighlightSelectedIcons, True
   PropBag.WriteProperty "DrawFocusRectangle", DrawFocusRectangle, True
   PropBag.WriteProperty "EditOnClick", EditOnClick, False
   PropBag.WriteProperty "Virtual", Virtual, False
   PropBag.WriteProperty "DefaultRowHeight", DefaultRowHeight, 20
   PropBag.WriteProperty "KeyHelp", m_KeyHelp, vbKeyF4
   PropBag.WriteProperty "KeyReturnEmulateTab", m_KeyReturnEmulateTab, True
   PropBag.WriteProperty "RowOddColor", m_RowOddColor, CLR_NONE
End Sub

Private Function pGetAlignHeader(ByVal eAlign As ECGHdrTextAlignFlags) As EHdrTextAlign
  Select Case eAlign
    Case ECGHdrTextAlignFlags.ecgHdrTextALignLeft
      pGetAlignHeader = HdrTextALignLeft
    Case ECGHdrTextAlignFlags.ecgHdrTextALignCentre
      pGetAlignHeader = HdrTextALignCentre
    Case ECGHdrTextAlignFlags.ecgHdrTextALignRight
      pGetAlignHeader = HdrTextALignRight
  End Select
End Function

Private Sub pCreateImageGroup()
  m_hImlGroup = ImgGroup.hIml
  ImageList_GetIconSize m_hImlGroup, m_lIconSizeGroupX, m_lIconSizeGroupY
End Sub

Private Function pGetGroupRowHeight() As Long
  Dim Formula As cGridColFormula
  Dim n       As Long
  Dim n2      As Long
  Dim ColName As String
  ' Obtengo el alto de los grupos basandome en la cantidad
  ' de formulas para una misma columna
  For Each Formula In m_ColFormulas
    If ColName = Formula.Column Then
      n = n + 1
    Else
      ColName = Formula.Column
      If n2 < n Then n2 = n
      n = 1
    End If
  Next
  
  If n2 < n Then n2 = n
  
  pGetGroupRowHeight = n2 * pEvaluateTextHeight(1, 1, True) + 2
End Function

Private Sub pSortColumn(ByVal lColumn As Long, _
                        ByVal sHeader As String, _
                        ByVal iCol As Long)
                        
  On Error GoTo ControlError
  
  If Not m_bAutomaticSort Then Exit Sub
  
  Dim oldRedraw As Boolean
  oldRedraw = Redraw
  Redraw = False
  
  Dim oldHeaderVisible As Boolean
  oldHeaderVisible = m_cHeader.Visible
  m_cHeader.Visible = False
  
  Dim Order As cShellSortOrderCOnstants
  
  If m_Groups.Count Then
    
    Dim sKey As String
    
    sKey = m_tCols(iCol).sKey
    
    If m_Groups.Item(m_Groups.Count).IsSortCol Then
    
      With m_Groups.Item(m_Groups.Count)
    
        If .SortType = CCLOrderAscending Then
          Order = CCLOrderDescending
        Else
          Order = CCLOrderAscending
        End If

      End With
    
      '---------------------------------------------------
      '
      ' Tremendamente desprolijo, pero no queda otra
      ' soy yo el que tiene que remover la columna,
      ' es decir deberia ser m_Groups.Remove, pero
      ' para eso habria que pasarle el paramatro grd
      ' con una referencia a esta instancia de cGrid
      ' y no tengo ganas de complicar tanto el codigo
      ' y el testeo
      '
      '
          Dim idxGroup As Long
          Dim i          As Long
          Dim c_KeyGroup As String
          
          idxGroup = m_Groups.Count
          c_KeyGroup = "##Group!!_" & idxGroup
          
          m_Groups.RemoveByIndex m_Groups.Count
        
          ' Now I have to remove group columns not used
          '
          For i = 1 To Columns
            If ColumnKey(i) = c_KeyGroup Then
              RemoveColumn i
              Exit For
            End If
          Next
      '
      '---------------------------------------------------
      
    Else
      Order = CCLOrderDescending
    End If
    
    With m_Groups.Add(Nothing)
      .Name = sHeader
      .Key = sKey
      .Index = m_Groups.Count
      .SortType = Order
    
      .IsSortCol = True
    End With
    
    pRefreshGroupsAndFormulas False
    
  Else
    
    ' Sort the grid according to the groupings:
    With m_cSort
      
      If .SortIndexCount > 0 Then
      
        If .SortColumn(1) = lColumn Then
          If .SortOrder(1) = CCLOrderAscending Then
            Order = CCLOrderDescending
          Else
            Order = CCLOrderAscending
          End If
        End If
      Else
        Order = CCLOrderDescending
      End If
      
      .Clear
      
      .SortColumn(1) = lColumn
      .SortOrder(1) = Order
      If m_tCols(iCol).eSortType = CCLSortDate Then
        .SortType(1) = CCLSortDateDayAccuracy
      Else
        .SortType(1) = m_tCols(iCol).eSortType
      End If
    End With
  
    Sort
  
  End If

  GoTo ExitProc
ControlError:
  MngError "pSortColumn"
ExitProc:
  m_cHeader.Visible = oldHeaderVisible
  Redraw = oldRedraw
End Sub

Private Function pGetRowTextStartCol() As Long
  Dim iCol    As Long
  Dim lXStart As Long
  Dim rtn     As Long
  
  Const c_KeyGroup As String = "##Group!!_"
  
  lXStart = 99999
  
  For iCol = 2 To m_iCols
    If InStr(1, ColumnKey(iCol), c_KeyGroup) = 0 Then
      If lXStart > m_tCols(iCol).lStartX _
        And m_tCols(iCol).lStartX > 0 _
        And m_tCols(iCol).eTextAlign = ecgHdrTextALignLeft Then
        
        lXStart = m_tCols(iCol).lStartX
        rtn = m_tCols(iCol).lCellColIndex
      End If
    End If
  Next iCol
  
  pGetRowTextStartCol = rtn
  
End Function

Private Sub pRedimvIRow(ByVal bPreserve As Boolean, ByVal iRows As Long)
  Dim nFrom As Long
  
  If bPreserve Then
    nFrom = UBound(m_vIRow) + 1
        
    ReDim Preserve m_vIRow(0 To iRows)
  Else
    nFrom = 0
    ReDim m_vIRow(0 To iRows)
  End If
  
  pFillvIRow nFrom
  
End Sub

Private Sub pFillvIRow(ByVal nFrom As Long)
  Dim i As Long
  
  For i = nFrom To UBound(m_vIRow)
    m_vIRow(i) = i
  Next
End Sub

'   GoTo ExitProc
'ControlError:
'  MngError "UserControl_Terminate"
'ExitProc:


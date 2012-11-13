VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cReportPaint"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
'--------------------------------------------------------------------------------
' cReportPaint
' 18-09-2001

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
' constantes
' estructuras
' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module As String = "cReportPaint"

Private Const c_grid_area_width = 3000
Private Const c_grid_area_height = 1000

Private Const C_KEY_PAINT_OBJ As String = "P"
Private Const C_KEY_PAINT_SEC As String = "S"

' estructuras
' variables privadas

Private m_PaintObjects    As cReportPaintObjects
Private m_PaintSections   As cReportPaintObjects
Private m_PaintGridAreas  As cReportPaintObjects
Private m_NextKey         As Long

Private m_hBrushGrid As Long

Private m_x1 As Integer
Private m_y1 As Integer
Private m_y2 As Integer
Private m_x2 As Integer

Private m_x1Ex As Integer
Private m_y1Ex As Integer
Private m_y2Ex As Integer
Private m_x2Ex As Integer

Private m_BeginMoveDone  As Boolean

Private m_KeyFocus As String
Private m_vGridObjs() As String
Private m_NotBorder As Boolean

Private m_Fnt() As StdFont
Private m_hFnt() As Long
Private m_iFontCount As Long

Private m_hBmpCopy  As Long
Private m_hMemDC    As Long

Private m_GridHeight As Single

Private m_vSelectedKeys() As String

Private m_Zoom  As Long

Private m_ScaleX    As Single
Private m_ScaleY    As Single
' eventos

' propiedades publicas
Public Property Let GridHeight(ByVal rhs As Single)
  m_GridHeight = rhs
End Property

Public Property Get PaintSections() As cReportPaintObjects
  Set PaintSections = m_PaintSections
End Property

Public Property Get PaintObjects() As cReportPaintObjects
  Set PaintObjects = m_PaintObjects
End Property

' propiedades friend
Friend Property Get NotBorder() As Boolean
  NotBorder = m_NotBorder
End Property

Friend Property Let NotBorder(ByVal rhs As Boolean)
  m_NotBorder = rhs
End Property

Public Property Get Zoom() As Long
   Zoom = m_Zoom
End Property

Public Property Let Zoom(ByVal rhs As Long)
   m_Zoom = rhs
End Property
' Propiedades friend
Friend Property Let ScaleY(ByVal rhs As Single)
  m_ScaleY = rhs
End Property

Friend Property Let ScaleX(ByVal rhs As Single)
  m_ScaleX = rhs
End Property

Friend Property Get ScaleY() As Single
  ScaleY = m_ScaleY
End Property

Friend Property Get ScaleX() As Single
  ScaleX = m_ScaleX
End Property

' propiedades privadas
' funciones publicas
Public Function CopyBitmap(ByVal hDCSource As Long, _
                           ByVal Width As Long, ByVal Height As Long, _
                           ByVal hCurrentBmp As Long) As Long
  Dim hDCDest   As Long
  Dim hBmpOld   As Long
  Dim hBmp      As Long
  
  Width = Width / Screen.TwipsPerPixelX
  Height = Height / Screen.TwipsPerPixelY
  
  hDCDest = CreateCompatibleDC(hDCSource)
  hBmp = CreateCompatibleBitmap(hDCSource, Width, Height)
  hBmpOld = SelectObject(hDCDest, hBmp)
  
  BitBlt hDCDest, 0, 0, Width, Height, hDCSource, 0, 0, vbSrcCopy
  
  SelectObject hDCDest, hBmpOld
  DeleteObject hDCDest
  
  If Err.LastDllError <> 0 Then
    Err.Raise vbObjectError, C_Module, "Error al copiar el bitmap. Numero: " & Err.LastDllError
  End If
  
  If hCurrentBmp <> 0 Then
    DeleteObject hCurrentBmp
  End If
  
  CopyBitmap = hBmp
End Function

Public Function GetPaintObject(ByVal sKey As String) As cReportPaintObject
  If Mid(sKey, 1, Len(C_KEY_PAINT_OBJ)) = C_KEY_PAINT_OBJ Then
    Set GetPaintObject = m_PaintObjects.Item(sKey)
  Else
    Set GetPaintObject = m_PaintSections.Item(sKey)
  End If
End Function

Public Function GetPaintObjectForTag(ByVal Tag As String) As cReportPaintObject
  Dim PaintObj As cReportPaintObject
  Dim i As Long
  For i = 1 To m_PaintObjects.Count
    Set PaintObj = m_PaintObjects.Item(i)
    If PaintObj.Tag = Tag Then
      Set GetPaintObjectForTag = PaintObj
      Exit For
    End If
  Next i
End Function

Public Function GetPaintSectoinForTag(ByVal Tag As String) As cReportPaintObject
  Dim PaintObj As cReportPaintObject
  Dim i As Long
  For i = 1 To m_PaintSections.Count
    Set PaintObj = m_PaintSections.Item(i)
    If PaintObj.Tag = Tag Then
      Set GetPaintSectoinForTag = PaintObj
      Exit For
    End If
  Next i
End Function

Public Function GetNewObject(ByVal PaintTypeObject As cRptPaintObjType) As cReportPaintObject
  Dim Key As String
  Key = GetKeyPaintObj()
  Dim PaintObj As cReportPaintObject
  Set PaintObj = m_PaintObjects.Add(PaintObj, Key)
  PaintObj.Key = Key
  PaintObj.PaintType = PaintTypeObject
  Set GetNewObject = PaintObj
End Function

Public Function GetNewSection(ByVal PaintTypeObject As cRptPaintObjType) As cReportPaintObject
  Dim Key As String
  Key = GetKeyPaintSec()
  Dim PaintObj As cReportPaintObject
  Set PaintObj = m_PaintSections.Add(PaintObj, Key)
  PaintObj.Key = Key
  PaintObj.PaintType = PaintTypeObject
  Set GetNewSection = PaintObj
End Function

Public Function PaintObjIsSection(ByVal sKey As String) As Boolean
  PaintObjIsSection = Left(sKey, Len(C_KEY_PAINT_SEC)) = C_KEY_PAINT_SEC
End Function

Public Function PointIsInObject(ByVal x As Single, ByVal y As Single, ByRef sKey As String, Optional ByRef RegionType As cRptPaintRegionType = 0) As Boolean
  PointIsInObject = True
  If PointIsInObjectAux(m_PaintSections, x, y, sKey, RegionType) Then Exit Function
  If PointIsInObjectAux(m_PaintObjects, x, y, sKey, RegionType) Then Exit Function
  PointIsInObject = False
End Function

Public Function PointIsInThisObject(ByVal x As Single, ByVal y As Single, ByVal sKey As String, Optional ByRef RegionType As cRptPaintRegionType = 0) As Boolean
  PointIsInThisObject = True
  If PointIsInThisObjectAux(m_PaintObjects(sKey), x, y, sKey, RegionType) Then Exit Function
  If PointIsInThisObjectAux(m_PaintObjects(sKey), x, y, sKey, RegionType) Then Exit Function
  PointIsInThisObject = False
End Function

Private Function PointIsInObjectAux(ByRef PaintObjs As cReportPaintObjects, ByVal x As Single, ByVal y As Single, ByRef sKey As String, Optional ByRef RegionType As cRptPaintRegionType = 0) As Boolean
  Dim i As Integer
  
  For i = PaintObjs.Count To 1 Step -1
    If PointIsInThisObjectAux(PaintObjs.GetNextPaintObjForZOrder(i), _
                              x, y, sKey, RegionType _
       ) Then
       PointIsInObjectAux = True
       Exit For
    End If
  Next
End Function

Private Function PointIsInThisObjectAux(ByRef PaintObj As cReportPaintObject, ByVal x As Single, ByVal y As Single, ByRef sKey As String, Optional ByRef RegionType As cRptPaintRegionType = 0) As Boolean
  Const C_WIDTH_REGION As Integer = 50
  
  Dim YY As Long
  Dim XX As Long
  
  Dim Top     As Single
  Dim Height  As Single
  Dim Width   As Single
  Dim Left    As Single

  If PaintObj Is Nothing Then Exit Function

  With PaintObj.Aspect
    Left = .Left
    Width = .Width
    Top = .Top - .Offset
    Height = .Height
  End With
  
  If PointIsInRegion(Left - C_WIDTH_REGION, Top - C_WIDTH_REGION, Left + Width + C_WIDTH_REGION, Top + Height + C_WIDTH_REGION, x, y) Then
    sKey = PaintObj.Key
    PointIsInThisObjectAux = True
    
    YY = Top + Height / 2
    YY = YY - C_WIDTH_REGION
    
    XX = Left + Width / 2
    XX = XX - C_WIDTH_REGION
    ' Ahora defino en que parte de la region esta

    ' Body
    If PointIsInRegion(Left + C_WIDTH_REGION, Top + C_WIDTH_REGION, Left + Width - C_WIDTH_REGION, Top + Height - C_WIDTH_REGION, x, y) Then
      RegionType = cRptPaintRegionType.cRptPntRgnTypeBody

      ' Left
    ElseIf PointIsInRegion(Left - C_WIDTH_REGION * 2, YY, Left + C_WIDTH_REGION * 2, YY + C_WIDTH_REGION * 2, x, y) Then
      RegionType = cRptPaintRegionType.cRptPntRgnTypeLeft

      ' Rigth
    ElseIf PointIsInRegion(Left + Width - C_WIDTH_REGION * 2, YY, Left + Width + C_WIDTH_REGION * 2, YY + C_WIDTH_REGION * 2, x, y) Then
      RegionType = cRptPaintRegionType.cRptPntRgnTypeRight

      ' Up
    ElseIf PointIsInRegion(XX, Top - C_WIDTH_REGION * 2, XX + C_WIDTH_REGION * 2, Top + C_WIDTH_REGION * 2, x, y) Then
      RegionType = cRptPaintRegionType.cRptPntRgnTypeUp

      ' Down
    ElseIf PointIsInRegion(XX, Top + Height - C_WIDTH_REGION * 2, XX + C_WIDTH_REGION * 2, Top + Height + C_WIDTH_REGION * 2, x, y) Then
      RegionType = cRptPaintRegionType.cRptPntRgnTypeDown

      ' LeftUp
    ElseIf PointIsInRegion(Left - C_WIDTH_REGION, Top - C_WIDTH_REGION, Left + C_WIDTH_REGION, Top + C_WIDTH_REGION, x, y) Then
      RegionType = cRptPaintRegionType.cRptPntRgnTypeLeftUp

      ' LeftDown
    ElseIf PointIsInRegion(Left - C_WIDTH_REGION, Top + Height - C_WIDTH_REGION, Left + C_WIDTH_REGION, Top + Height + C_WIDTH_REGION, x, y) Then
      RegionType = cRptPaintRegionType.cRptPntRgnTypeLeftDown

      ' RigthUp
    ElseIf PointIsInRegion(Left + Width - C_WIDTH_REGION, Top - C_WIDTH_REGION, Left + Width + C_WIDTH_REGION, Top + C_WIDTH_REGION, x, y) Then
      RegionType = cRptPaintRegionType.cRptPntRgnTypeRightUp

      ' RitgthDown
    ElseIf PointIsInRegion(Left + Width - C_WIDTH_REGION, Top + Height - C_WIDTH_REGION, Left + Width + C_WIDTH_REGION, Top + Height + C_WIDTH_REGION, x, y) Then
      RegionType = cRptPaintRegionType.cRptPntRgnTypeRightDown

    End If
  End If
End Function

' funciones privadas
Private Function GetKeyPaintObj() As String
  m_NextKey = m_NextKey + 1
  GetKeyPaintObj = C_KEY_PAINT_OBJ & m_NextKey
End Function

Private Function GetKeyPaintSec() As String
  m_NextKey = m_NextKey + 1
  GetKeyPaintSec = C_KEY_PAINT_SEC & m_NextKey
End Function

Private Function GetKey() As String
  m_NextKey = m_NextKey + 1
  GetKey = "K" & m_NextKey
End Function

Private Function PointIsInRegion(ByVal X1 As Single, ByVal Y1 As Single, ByVal X2 As Single, ByVal Y2 As Single, ByVal x As Single, ByVal y As Single) As Boolean
  PointIsInRegion = x >= X1 And x <= X2 And y >= Y1 And y <= Y2
End Function

' Tengo cuatro puntos por cada region, asi que tengo que ver si alguno puntos
' de los puntos de la region a estan dentro de la region b o si alguno de b
' esta en a
Private Function RegionIsInRegion(ByVal X1 As Single, ByVal Y1 As Single, ByVal X2 As Single, ByVal Y2 As Single, ByVal z1 As Single, ByVal w1 As Single, ByVal z2 As Single, ByVal w2 As Single) As Boolean

  RegionIsInRegion = True

  ' Primero la region B en A
  If X1 <= z1 And X2 >= z1 And w1 <= Y1 And w2 >= Y1 Then Exit Function

  If X1 <= z2 And X2 >= z2 And w1 <= Y1 And w2 >= Y1 Then Exit Function

  If X1 <= z1 And X2 >= z1 And w1 <= Y2 And w2 >= Y2 Then Exit Function

  If X1 <= z2 And X2 >= z2 And w1 <= Y2 And w2 >= Y2 Then Exit Function

  ' Ahora la region A en B
  If z1 <= X1 And z2 >= X1 And Y1 <= w1 And Y2 >= w1 Then Exit Function

  If z1 <= X2 And z2 >= X2 And Y1 <= w1 And Y2 >= w1 Then Exit Function

  If z1 <= X1 And z2 >= X1 And Y1 <= w2 And Y2 >= w2 Then Exit Function

  If z1 <= X2 And z2 >= X2 And Y1 <= w2 And Y2 >= w2 Then Exit Function

  RegionIsInRegion = False
End Function

'-----------------------------------------------------------------------------------------------
' Grid
                                      'As PictureBox) As Object
Public Sub InitGrid(ByRef PicGrid As Object, ByVal TypeGrid As csETypeGrid)
  Dim x As Integer
  Dim y As Integer
  Dim c As cReportPaintObject
  Dim Top As Single
  Dim Left As Single
  Dim i As Integer
  
  pCreateBrushGrid PicGrid, TypeGrid

  y = PicGrid.Height / c_grid_area_height
  x = PicGrid.Width / c_grid_area_width

  x = x + 1
  y = y + 1

  ReDim m_vGridObjs(x, y)

  Dim L As Integer
  Dim t As Integer

  For i = 1 To y * x
    Set c = m_PaintGridAreas.Add(c, GetKey())

    Left = c_grid_area_width * L
    Top = c_grid_area_height * t
    With c.Aspect
      .Left = Left
      .Top = Top
      .Width = c_grid_area_width
      .Height = c_grid_area_height
    End With

    m_vGridObjs(L + 1, t + 1) = c.Key

    Set c = Nothing

    L = L + 1
    If L >= x Then
      L = 0
      t = t + 1
    End If
  Next

  RefreshBackgroundPicture PicGrid
End Sub

'----------------------------------------------------------------------------------
' Align

' Recibo un objeto y lo alineo a la grilla
' para esto, tengo que determinar en que grilla
' esta cada uno de los tres puntos:
'
'          a------------------b
'          |                  |
'          |                  |
'          c-------------------

' a define el top y el left
' b define el widht
' c define el heigth
Public Sub AlingObjTopToGrid(ByVal sKey As String)
  AlingObjToGrid sKey, False, True, False, False, True
End Sub

Public Sub AlingObjLeftToGrid(ByVal sKey As String)
  AlingObjToGrid sKey, True, False, False, False, True
End Sub

Public Sub AlingObjBottomToGrid(ByVal sKey As String)
  AlingObjToGrid sKey, False, False, True, False, True
End Sub

Public Sub AlingObjRightToGrid(ByVal sKey As String)
  AlingObjToGrid sKey, False, False, False, True, True
End Sub

Public Sub AlingObjLeftTopToGrid(ByVal sKey As String)
  AlingObjToGrid sKey, True, True, False, False, True
End Sub

Public Sub AlingObjLeftBottomToGrid(ByVal sKey As String)
  AlingObjToGrid sKey, True, False, True, False, True
End Sub

Public Sub AlingObjRightTopToGrid(ByVal sKey As String)
  AlingObjToGrid sKey, False, True, False, True, True
End Sub

Public Sub AlingObjRightBottomToGrid(ByVal sKey As String)
  AlingObjToGrid sKey, False, False, True, True, True
End Sub

Public Sub AlingToGrid(ByVal sKey As String)
  AlingObjToGrid sKey, True, True, False, False, False
End Sub

Private Sub AlingObjToGrid(ByVal sKey As String, ByVal ALeft As Boolean, ByVal ATop As Boolean, ByVal ABottom As Boolean, ByVal ARight As Boolean, ByVal Resizing As Boolean)
  Dim z1 As Integer
  Dim q1 As Integer
  Dim maxY As Integer
  Dim maxX As Integer
  Dim GridObjAspect As cReportAspect

  maxY = UBound(m_vGridObjs, 2)
  maxX = UBound(m_vGridObjs, 1)

  Dim Top As Single
  Dim Left As Single
  Dim Width As Single
  Dim Height As Single
  Dim Offset As Single
  Const PointSeparation As Integer = 9
  Const OffSetPointSep As Integer = 4.5

  Dim PaintObjs As cReportPaintObjects

  If Mid(sKey, 1, 1) = C_KEY_PAINT_SEC Then
    Set PaintObjs = m_PaintSections
  Else
    Set PaintObjs = m_PaintObjects
  End If

  Dim nLeft As Long
  Dim nTop As Long

  With PaintObjs.Item(sKey)
    With .Aspect
      nLeft = .Left - OffSetPointSep
      nTop = .Top - .Offset - OffSetPointSep

      If nLeft < 0 Then nLeft = 0
      If nTop < 0 Then nTop = 0

      If ATop Or ALeft Then
        ' Obtengo la grilla en la que esta el punto A
        z1 = nLeft / c_grid_area_width
        q1 = nTop / c_grid_area_height

        If nLeft > z1 * c_grid_area_width Then z1 = z1 + 1
        If nTop > q1 * c_grid_area_height Then q1 = q1 + 1

        If z1 < 1 Then z1 = 1
        If q1 < 1 Then q1 = 1

        If z1 > maxX Then z1 = maxX
        If q1 > maxY Then q1 = maxY

        Set GridObjAspect = m_PaintGridAreas.Item(m_vGridObjs(z1, q1)).Aspect

        If ATop Then
          ' Ahora veo cual es el punto mas cercano
          Top = (.Top - .Offset) - GridObjAspect.Top
          Top = CInt(Top / PointSeparation) * PointSeparation
          Offset = GridObjAspect.Top + Top - OffSetPointSep - (.Top - .Offset)
          .Top = (GridObjAspect.Top + Top - OffSetPointSep) + .Offset

          If Resizing Then
            .Height = .Height - Offset
          End If
        End If

        If ALeft Then
          Left = .Left - GridObjAspect.Left
          Left = CInt(Left / PointSeparation) * PointSeparation
          Offset = GridObjAspect.Left + Left - OffSetPointSep - .Left
          .Left = GridObjAspect.Left + Left - OffSetPointSep

          If Resizing Then
            .Width = .Width - Offset
          End If
        End If
      End If

      If ARight Then
        ' Obtengo la grilla en la que esta el punto b
        z1 = (nLeft + .Width) / c_grid_area_width
        If nLeft + .Width > z1 * c_grid_area_width Then z1 = z1 + 1

        q1 = nTop / c_grid_area_height
        If nTop > q1 * c_grid_area_height Then q1 = q1 + 1

        If z1 < 1 Then z1 = 1
        If q1 < 1 Then q1 = 1

        If z1 > maxX Then z1 = maxX
        If q1 > maxY Then q1 = maxY

        Set GridObjAspect = m_PaintGridAreas.Item(m_vGridObjs(z1, q1)).Aspect

        ' Ahora veo cual es el punto mas cercano
        Width = .Left + .Width - GridObjAspect.Left
        Width = CInt(Width / PointSeparation) * PointSeparation - OffSetPointSep
        .Width = GridObjAspect.Left + Width - .Left

      End If

      If ABottom Then
        ' Obtengo la grilla en la que esta el punto c
        z1 = nLeft / c_grid_area_width
        q1 = (nTop + .Height) / c_grid_area_height

        If nLeft > z1 * c_grid_area_width Then z1 = z1 + 1
        If nTop + .Height > q1 * c_grid_area_height Then q1 = q1 + 1

        If z1 < 1 Then z1 = 1
        If q1 < 1 Then q1 = 1

        If z1 > maxX Then z1 = maxX
        If q1 > maxY Then q1 = maxY

        Set GridObjAspect = m_PaintGridAreas.Item(m_vGridObjs(z1, q1)).Aspect

        ' Ahora veo cual es el punto mas cercano
        Height = (.Top - .Offset) + .Height - GridObjAspect.Top
        Height = CInt(Height / PointSeparation) * PointSeparation - OffSetPointSep
        .Height = GridObjAspect.Top + Height - (.Top - .Offset)

      End If
    End With
  End With
End Sub

' End Align
'-------------------------------

' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError
  
#If PREPROC_DEBUG Then
  gdbInitInstance C_Module
#End If
  
  m_ScaleX = 1
  m_ScaleY = 1
  
  Set m_PaintObjects = New cReportPaintObjects
  Set m_PaintGridAreas = New cReportPaintObjects
  Set m_PaintSections = New cReportPaintObjects

  ReDim m_vGridObjs(0, 0)
  ReDim m_Fnt(0)
  ReDim m_hFnt(0)
  ReDim m_vSelectedKeys(0)
  
  m_Zoom = 100
  
  Exit Sub
ControlError:
  MngError Err(), "Class_Initialize", C_Module, vbNullString, "CSReportPaint", csErrorWarning, csErrorVba
End Sub

Private Sub Class_Terminate()
  On Error Resume Next

  ReDim m_vGridObjs(0, 0)
  Set m_PaintObjects = Nothing
  Set m_PaintGridAreas = Nothing
  Set m_PaintSections = Nothing
  DeleteObject m_hBrushGrid
  DeleteObject m_hBmpCopy
  DeleteObject m_hMemDC
  pDestroyFonts
  ReDim m_vSelectedKeys(0)
  
#If PREPROC_DEBUG Then
  gdbTerminateInstance C_Module
#End If
End Sub

Private Sub pDestroyFonts()
  Dim iFnt As Long
  For iFnt = 1 To m_iFontCount
    DeleteObject m_hFnt(iFnt)
  Next iFnt
  
  m_iFontCount = 0
  ReDim m_Fnt(0)
  ReDim m_hFnt(0)
End Sub

' Drawing
Public Sub ClearPage(ByRef Graph As Object)
  Dim hBr As Long
  Dim tR  As RECT
  
  pDestroyFonts
  
  'If TypeOf Graph Is CSReportDll2.cPrinter Then
  If TypeOf Graph Is cPrinter Then
    Exit Sub
  End If
  
  GetClientRect Graph.hwnd, tR
  hBr = CreateSolidBrush(TranslateColor(vbWhite))
  FillRect Graph.hDC, tR, hBr
  DeleteObject hBr
  
  RefreshBackgroundPicture Graph, vbWhite
End Sub

Public Function RefreshObject(ByVal Key As String, ByVal hDC As Long, ByRef Graph As Object) As Boolean
  pClearObject Key, hDC, Graph
  RefreshObject = DrawObject(Key, hDC, Graph)
End Function

Public Function DrawObject(ByVal Key As String, ByVal hDC As Long, ByRef Graph As Object) As Boolean
  DrawObject = Draw(m_PaintObjects, Key, hDC, Graph)
End Function

Public Function DrawSection(ByVal Key As String, ByVal hDC As Long, ByRef Graph As Object) As Boolean
  If Not Draw(m_PaintSections, Key, hDC, Graph) Then Exit Function
  DrawSection = DrawRule(Key, Graph)
End Function

Public Function DrawRule(ByVal Key As String, ByRef Graph As Object) As Boolean
  
  Dim Top       As Single
  Dim HeightSec As Single
  Dim Aspect    As cReportAspect
  
  Set Aspect = New cReportAspect
  
  With m_PaintSections.Item(Key)
    HeightSec = .HeightSecLine * 0.5
    With .Aspect
      Aspect.Top = .Top + 50 - HeightSec
      Aspect.Offset = .Offset
      Aspect.Transparent = True
    End With
  End With
  
  With Aspect
    .Left = 0
    .Height = 285
    .Align = vbRightJustify
    .Width = Graph.Width - 80
  End With
  
  With m_PaintSections.Item(Key)
              
    If LenB(.TextLine) > 0 Then
    
      Top = -.HeightSec
      With .Aspect
        Top = Top + .Top - .Offset + .Height * 2
      End With
      
      PrintLine Graph.hDC, False, 0, Top, Aspect.Width, Top, , 3, , vb3DLight
    
      ' Ultimo Section Line
      '
      PrintText Graph.hDC, _
                .TextLine, _
                Aspect, _
                .hImage
      
      HeightSec = .HeightSec * 0.5
    
      ' Imprimo el Nombre de la seccion
      '
      With m_PaintSections.Item(Key).Aspect
        Aspect.Top = .Top + 50 - HeightSec
        Aspect.Align = vbLeftJustify
      End With
      
      PrintText Graph.hDC, _
                .Text, _
                Aspect, _
                .hImage
      
    Else
      
      Top = Aspect.Top - Aspect.Offset - HeightSec + .Aspect.Height
    
      If .IsSection Then
    
        PrintLine Graph.hDC, False, 0, Top, Aspect.Width, Top, , 3, , vb3DLight
      End If
      
      
      ' Todos los Section Line menos el ultimo
      '
      PrintText Graph.hDC, _
                .Text, _
                Aspect, _
                .hImage
      
    End If
  End With
  
  DrawRule = True
End Function

Public Sub MoveObjToXY(ByVal sKey As String, ByVal x As Integer, ByVal y As Integer, ByRef Graph As Object)
  If Left(sKey, 1) = C_KEY_PAINT_OBJ Then
    With m_PaintObjects.Item(sKey).Aspect
      Move x, y, .Width, .Height, Graph
    End With
  Else
    With m_PaintSections.Item(sKey).Aspect
      Move x, y, .Width, .Height, Graph
    End With
  End If
End Sub
                                                          
Public Sub MoveObjToXYEx(ByVal sKey As String, ByVal x As Integer, ByVal y As Integer, ByRef Graph As Object, ByVal Clear As Boolean)

  If Clear Then
    m_x1 = m_x1Ex
    m_y1 = m_y1Ex
    m_x2 = m_x2Ex
    m_y2 = m_y2Ex
  Else
  
    m_x1 = 0
    m_x2 = 0
    m_y1 = 0
    m_y2 = 0
  End If
  
  MoveObjToXY sKey, x, y, Graph
  
  If m_x1Ex = 0 Then m_x1Ex = m_x1
  If m_y1Ex = 0 Then m_y1Ex = m_y1
  If m_x2Ex = 0 Then m_x2Ex = m_x2
  If m_y2Ex = 0 Then m_y2Ex = m_y2
  
  If m_x1Ex > m_x1 And m_x1 > 0 Then m_x1Ex = m_x1
  If m_y1Ex > m_y1 And m_y1 > 0 Then m_y1Ex = m_y1
  If m_x2Ex < m_x2 And m_x2 > 0 Then m_x2Ex = m_x2
  If m_y2Ex < m_y2 And m_y2 > 0 Then m_y2Ex = m_y2
End Sub
                                                          
Public Sub MoveVertical(ByVal sKey As String, ByVal y As Integer, ByRef Graph As Object)

  If Left(sKey, 1) = C_KEY_PAINT_OBJ Then
    With m_PaintObjects.Item(sKey).Aspect
      Move .Left, y, .Width, .Height, Graph
    End With
  Else
    With m_PaintSections.Item(sKey).Aspect
      Move .Left, y, .Width, .Height, Graph
    End With
  End If
End Sub

Public Sub MoveHorizontal(ByVal sKey As String, ByVal x As Integer, ByRef Graph As Object)
  If Left(sKey, 1) = C_KEY_PAINT_OBJ Then
    With m_PaintObjects.Item(sKey).Aspect
      Move x, .Top, .Width, .Height, Graph
    End With
  Else
    With m_PaintSections.Item(sKey).Aspect
      Move x, .Top, .Width, .Height, Graph
    End With
  End If
End Sub

Public Sub EndMove(ByRef Graph As Object)
  m_x1 = 0
  m_x2 = 0
  m_y1 = 0
  m_y2 = 0
  
  m_x1Ex = 0
  m_x2Ex = 0
  m_y1Ex = 0
  m_y2Ex = 0
  
  RefreshBackgroundPicture Graph
  m_BeginMoveDone = False
End Sub

' Drawing - Primitive
Private Function Draw(ByRef CollObjs As cReportPaintObjects, _
                      ByVal Key As String, _
                      ByVal hDC As Long, _
                      ByRef Graph As Object) As Boolean
                      
  On Error GoTo ControlError

  If hDC = 0 Then
    Err.Raise csRptPaintErrors.csRptPatintErrObjClient, C_Module, errGetDescript(csRptPaintErrors.csRptPatintErrObjClient)
  End If

  Dim oPaintObj As cReportPaintObject
  Dim X1 As Single
  Dim Y1 As Single
  Dim Y2 As Single
  Dim X2 As Single
  Dim ColorIn  As Long
  Dim ColorOut As Long
  Dim Filled As Boolean

  Set oPaintObj = CollObjs.Item(Key)

  If oPaintObj Is Nothing Then Exit Function

  With oPaintObj
    With .Aspect

      X1 = .Left
      X2 = X1 + .Width
      Y1 = .Top - .Offset
      Y2 = Y1 + .Height

      If Not .Transparent Then
        ColorIn = .BackColor
        Filled = True
      End If
      
      ColorOut = .BorderColor

      Select Case oPaintObj.PaintType
        Case cRptPaintObjType.csRptPaintObjBox

          pDrawObjBox hDC, oPaintObj.Aspect, X1, Y1, X2, Y2, Filled, ColorIn, ColorOut

        Case cRptPaintObjType.csRptPaintObjLine
          PrintLine hDC, Filled, X1, Y1, X2, Y2, ColorIn, , , ColorOut

        Case cRptPaintObjType.csRptPaintObjCircle
        
        Case cRptPaintObjType.csRptPaintObjImage
        
          pDrawObjBox hDC, oPaintObj.Aspect, X1 - 20, Y1 - 20, X2 + 20, Y2 + 20, Filled, ColorIn, &HC0C000
          
          Dim bmpWidth    As Long
          Dim bmpHeight   As Long
          
          GetBitmapSize oPaintObj.hImage, bmpWidth, bmpHeight, True
          
          'DrawBMP hDC, oPaintObj.hImage, X1 * m_ScaleX, Y1 * m_ScaleY, .Width, .Height, .Width * m_ScaleX, .Height * m_ScaleY
          
          If bmpWidth > .Width Then
            bmpWidth = .Width
          End If
          If bmpHeight > .Height Then
            bmpHeight = .Height
          End If
          
          DrawBMP hDC, oPaintObj.hImage, X1 * m_ScaleX, Y1 * m_ScaleY, bmpWidth, bmpHeight, bmpWidth * m_ScaleX, bmpHeight * m_ScaleY

      End Select

    End With
  End With

  With oPaintObj
    If LenB(.Text) > 0 Then
      If CollObjs Is m_PaintObjects Then
        PrintText hDC, .Text, .Aspect, .hImage
      End If
    End If
  End With
  
  Draw = True
  Exit Function
ControlError:

  MngError Err(), "Draw", C_Module, "Error al dibujar un objeto", "CSReportPaint", csErrorWarning, csErrorVba
End Function

Public Sub SetFocus(ByVal sKey As String, ByRef Graph As Object, ByVal ClearSelected As Boolean)
  If ClearSelected Then ReDim m_vSelectedKeys(0)
  
  If Not pAllreadySelected(sKey) Then
  
    ReDim Preserve m_vSelectedKeys(UBound(m_vSelectedKeys) + 1)
    m_vSelectedKeys(UBound(m_vSelectedKeys)) = sKey
  End If
  
  m_KeyFocus = sKey
  PaintPicture Graph
End Sub

Public Sub RemoveFromSelected(ByVal sKey As String, ByRef Graph As Object)
  Dim i As Long
  
  For i = 1 To UBound(m_vSelectedKeys)
    If m_vSelectedKeys(i) = sKey Then
      Exit For
    End If
  Next
  
  If i > UBound(m_vSelectedKeys) Then Exit Sub
  
  If i > UBound(m_vSelectedKeys) Then Exit Sub
  For i = i + 1 To UBound(m_vSelectedKeys)
    m_vSelectedKeys(i - 1) = m_vSelectedKeys(i)
  Next
  If UBound(m_vSelectedKeys) > 0 Then
    ReDim Preserve m_vSelectedKeys(UBound(m_vSelectedKeys) - 1)
  Else
    ReDim m_vSelectedKeys(0)
  End If
  
  If m_KeyFocus = sKey Then m_KeyFocus = vbNullString
  PaintPicture Graph
End Sub

Private Function pAllreadySelected(ByVal sKey As String) As Boolean
  Dim i As Long
  
  If sKey = vbNullString Then
    pAllreadySelected = True
    Exit Function
  End If
  
  For i = 1 To UBound(m_vSelectedKeys)
    If m_vSelectedKeys(i) = sKey Then
      pAllreadySelected = True
      Exit Function
    End If
  Next
End Function

Private Sub SetFocusAux(ByVal sKey As String, ByRef hDC As Long)
  Dim PaintObjAsp As cReportPaintObject
  Dim color       As Long
  Dim bCircle     As Boolean
  
  m_KeyFocus = sKey

  If Left(m_KeyFocus, 1) = C_KEY_PAINT_OBJ Then
    Set PaintObjAsp = m_PaintObjects.Item(m_KeyFocus)
    color = &H80C0FF
    bCircle = False
  Else
    Set PaintObjAsp = m_PaintSections.Item(m_KeyFocus)
    color = &H80C0FF
    bCircle = True
  End If

  If PaintObjAsp Is Nothing Then Exit Sub

  With PaintObjAsp.Aspect
    ShowHandles hDC, .Left, .Top - .Offset, .Left + .Width, .Top - .Offset + .Height, color, bCircle
  End With
End Sub
                                                                                                                        
Private Sub Move(ByVal Left As Integer, ByVal Top As Integer, ByVal Width As Integer, ByVal Height As Integer, ByRef Graph As Object)
  
  If m_x1 > 0 Or m_x2 > 0 Or m_y1 > 0 Or m_y2 > 0 Then
    
    PaintPictureMove Graph, NewRectangle(m_x1, m_y1, m_x2, m_y2)
  End If

  m_x1 = Left
  m_y1 = Top
  m_x2 = Left + Width
  m_y2 = Top + Height

  PrintLine Graph.hDC, False, m_x1, m_y1, m_x2, m_y2, , , True

  If m_x1 > 1 Then m_x1 = m_x1 - 2
  If m_y1 > 1 Then m_y1 = m_y1 - 2

  m_x2 = m_x2 + 2
  m_y2 = m_y2 + 2
End Sub

Public Sub Resize(ByRef Graph As Object, ByVal sKey As String, Optional ByVal Left As Integer = -32768, Optional ByVal Top As Integer = -32768, Optional ByVal X2 As Integer = -32768, Optional ByVal Y2 As Integer = -32768)

  Const C_MIN_WIDTH As Integer = 10
  Const C_MIN_HEIGHT As Integer = 10

  Dim PaintObjAsp As cReportAspect

  If Mid(sKey, 1, 1) = C_KEY_PAINT_OBJ Then
    Set PaintObjAsp = m_PaintObjects.Item(sKey).Aspect
  Else
    Set PaintObjAsp = m_PaintSections.Item(sKey).Aspect
  End If

  With PaintObjAsp
    If Left = -32768 Then
      m_x1 = .Left
    Else
      m_x1 = Left
    End If

    If Top = -32768 Then
      m_y1 = .Top - .Offset
    Else
      m_y1 = Top
    End If

    m_x2 = .Left
    If X2 = -32768 Then
      m_x2 = m_x2 + .Width
    Else
      m_x2 = X2
    End If

    m_y2 = .Top - .Offset
    If Y2 = -32768 Then
      m_y2 = m_y2 + .Height
    Else
      m_y2 = Y2
    End If

    ' Validaciones :

    ' x2 no puede ser menor a Left
    If m_x2 < .Left + C_MIN_WIDTH Then m_x2 = .Left + C_MIN_WIDTH

    ' y2 no puede ser menor a Top
    If m_y2 < .Top - .Offset + C_MIN_HEIGHT Then m_y2 = .Top - .Offset + C_MIN_HEIGHT

  End With

  PaintPicture Graph

  PrintLine Graph.hDC, False, m_x1, m_y1, m_x2, m_y2, , , True
End Sub

Public Sub CreatePicture(ByRef Graph As Object)
  RefreshBackgroundPicture Graph
End Sub

Private Sub RefreshBackgroundPicture(ByRef Graph As Object, Optional ByVal color As Long = vbButtonFace)
  Dim i       As Integer
  Dim tR      As RECT
  Dim tR2     As RECT
  
  If m_hBmpCopy <> 0 Then DeleteObject m_hBmpCopy
  If m_hMemDC <> 0 Then DeleteObject m_hMemDC
  
  GetClientRect Graph.hwnd, tR
  
  LSet tR2 = tR
  
  m_hMemDC = CreateCompatibleDC(0)
  m_hBmpCopy = CreateCompatibleBitmap(Graph.hDC, tR.Right, tR.Bottom + 56)
  
  DeleteObject SelectObject(m_hMemDC, m_hBmpCopy)
  
  Dim hBr As Long
  hBr = CreateSolidBrush(TranslateColor(color))
  tR2.Bottom = tR2.Bottom + 56
  FillRect m_hMemDC, tR2, hBr
  DeleteObject hBr
  
  tR.Bottom = m_GridHeight / Screen.TwipsPerPixelY
  FillRect m_hMemDC, tR, m_hBrushGrid
  
  For i = 1 To PaintObjects.Count
    DrawObject PaintObjects.GetNextKeyForZOrder(i), m_hMemDC, Graph
  Next

  For i = 1 To PaintSections.Count
    DrawSection PaintSections.GetNextKeyForZOrder(i), m_hMemDC, Graph
  Next

  PaintPicture Graph
End Sub

'--------------------------------------------------------------------------------------------------
' Draw - Low Level
Private Sub PrintLine(ByVal hDC As Long, Optional ByVal Filled As Boolean = True, _
                              Optional ByVal X1 As Single = 0, Optional ByVal Y1 As Single = 0, _
                              Optional ByVal X2 As Single = 0, Optional ByVal Y2 As Single = 0, _
                              Optional ByVal ColorInside As Long = vbCyan, _
                              Optional ByVal Width As Long = 1, _
                              Optional ByVal Dash As Boolean = False, _
                              Optional ByVal ColorOut As Long = vbBlack, _
                              Optional ByVal Rounded As Boolean)

  Dim tR      As RECT
  Dim lResult As Long
  Dim hRPen   As Long

  If Dash Then
    hRPen = CreatePen(PS_DOT, Width, TranslateColor(ColorOut))
  Else
    hRPen = CreatePen(PS_SOLID, Width, TranslateColor(ColorOut))
  End If
  DeleteObject SelectObject(hDC, hRPen)

  If Rounded Then
  
    X1 = X1 / Screen.TwipsPerPixelX
    X2 = X2 / Screen.TwipsPerPixelX
    
    Y1 = Y1 / Screen.TwipsPerPixelY
    Y2 = Y2 / Screen.TwipsPerPixelY
    
    
    Y1 = Y1 * m_ScaleY
    Y2 = Y2 * m_ScaleY
    X1 = X1 * m_ScaleX
    X2 = X2 * m_ScaleX
    
    RoundRect hDC, X1, Y1, X2, Y2, 20 * m_ScaleX, 20 * m_ScaleY
  Else

    tR = NewRectangle(X1, Y1, X2, Y2)
    RectTwipsToPixel tR, m_ScaleX, m_ScaleY
  
    If Y2 <> Y1 And X1 <> X2 Then
      
      Rectangle hDC, tR.Left, tR.Top, tR.Right, tR.Bottom
      
      If Filled Then
        Dim hBrush2 As Long
        InflateRect tR, -1, -1
        hBrush2 = CreateSolidBrush(TranslateColor(ColorInside))
        lResult = FillRect(hDC, tR, hBrush2)
        DeleteObject hBrush2
      End If
  
    Else
      If tR.Bottom = 0 Or tR.Bottom = tR.Top Then tR.Bottom = tR.Top + 1
      If tR.Right = 0 Or tR.Left = tR.Right Then tR.Right = tR.Left + 1
      Rectangle hDC, tR.Left, tR.Top, tR.Right, tR.Bottom
    End If
  End If
  
  DeleteObject hRPen
End Sub

Private Sub PrintText(ByVal hDC As Long, ByVal sText As String, ByRef Aspect As cReportAspect, ByVal hImage As Long)

  ' Para separarlo del borde
  Const c_Margen_Y As Integer = 20
  Const c_Margen_X As Integer = 80
  Const c_Margen_Bottom As Integer = 80

  Dim oFont As StdFont
  Set oFont = New StdFont
  Dim tR As RECT
  
  Dim oldBkColor    As Long
  Dim oldBkMode     As Long
  Dim oldFontColor  As Long
  Dim Flags         As Long
  
  With Aspect.Font
    oFont.Name = .Name
    oFont.Bold = .Bold
    oFont.Italic = .Italic
    oFont.UnderLine = .UnderLine
    oFont.Size = IIf(.Size > 0, .Size, 3)
  End With

  Dim stringWidth  As Long
  Dim stringHeight As Long
  Dim nWidth       As Long
  
  Dim hFntOld As Long
  
  hFntOld = SelectObject(hDC, m_hFnt(AddFontIfRequired(oFont, hDC, m_iFontCount, m_Fnt, m_hFnt)))
  
  With Aspect
    oldFontColor = SetTextColor(hDC, TranslateColor(.Font.ForeColor))
    oldBkColor = SetBkColor(hDC, TranslateColor(.BackColor))
    oldBkMode = SetBkMode(hDC, IIf(.Transparent, C_TRANSPARENT, C_OPAQUE))
  
    If .WordWrap Then
      Flags = DT_WORDBREAK Or DT_WORD_ELLIPSIS Or DT_LEFT Or DT_NOPREFIX Or DT_EDITCONTROL
    Else
      Flags = DT_SINGLELINE Or DT_WORD_ELLIPSIS Or DT_LEFT Or DT_NOPREFIX
    End If
  End With
  
  stringWidth = plEvaluateTextWidth(sText, hDC, m_ScaleX)
  stringHeight = plEvaluateTextHeight(sText, hDC, Aspect.Width, Flags, m_ScaleY, m_ScaleX)
  
  ' Esto es por seguridad, ya que
  ' cuando imprimo en la impresora (en pantalla esto no pasa)
  ' por pequeñas diferencias en la
  ' proceso de escalar hasta la resolucion
  ' de la impresora en algunos casos
  ' pierdo parte del texto si el
  ' rectangulo que pido es demasiado pequeño
  '
  stringHeight = stringHeight + 400
  
  Dim MargenX As Long
  Dim MargenY As Long
  Dim Width   As Long
  Dim Height  As Long
  
  MargenX = c_Margen_X
  MargenY = c_Margen_Y
  
  If hImage <> 0 Then
    GetBitmapSize hImage, Width, Height
    MargenX = MargenX + Width
    MargenY = Height - stringHeight - c_Margen_Bottom
    With Aspect
      If MargenY + stringHeight > .Height Then MargenY = .Height - stringHeight - c_Margen_Bottom
    End With
    If MargenY < c_Margen_Y Then MargenY = c_Margen_Y
  End If
  
  nWidth = Aspect.Width - MargenX * 2
  If stringWidth > nWidth Then stringWidth = nWidth

  Dim x As Long
  Dim y As Long

  Select Case Aspect.Align
    Case AlignmentConstants.vbRightJustify
      x = Aspect.Left + Aspect.Width - stringWidth - MargenX
    Case AlignmentConstants.vbCenter
      x = Aspect.Left + (Aspect.Width - stringWidth) * 0.5
    Case AlignmentConstants.vbLeftJustify
      x = Aspect.Left + MargenX
  End Select

  y = Aspect.Top - Aspect.Offset + MargenY
  
  With Aspect
    tR = NewRectangle(x, y, x + .Width - MargenX, y + stringHeight) '.Height)
    RectTwipsToPixel tR, m_ScaleX, m_ScaleY
'    If .WordWrap Then
'      Flags = DT_WORDBREAK Or DT_WORD_ELLIPSIS Or DT_LEFT Or DT_NOPREFIX Or DT_EDITCONTROL
'    Else
'      Flags = DT_SINGLELINE Or DT_WORD_ELLIPSIS Or DT_LEFT Or DT_NOPREFIX
'    End If
    DrawText hDC, sText & vbNullChar, -1, tR, Flags
  End With
  
  SetBkColor hDC, oldBkColor
  SetTextColor hDC, oldFontColor
  SetBkMode hDC, oldBkMode
  
  SelectObject hDC, hFntOld
End Sub

Private Sub ShowHandles(ByRef hDC As Long, ByVal X1 As Single, ByVal Y1 As Single, ByVal X2 As Single, ByVal Y2 As Single, ByVal color As Long, ByVal bCircle As Boolean)
  Const iSize As Integer = 100
  Dim hBrush  As Long
  Dim tR      As RECT
  Dim x       As Integer
  Dim y       As Integer
  
  Dim hOldBrush  As Long
  Dim hOldPen    As Long
  Dim hPen       As Long
  
  hBrush = CreateSolidBrush(TranslateColor(color))
  
  If bCircle Then
    hPen = CreatePen(PS_SOLID, 1, TranslateColor(color))
    hOldPen = SelectObject(hDC, hPen)
    hOldBrush = SelectObject(hDC, hBrush)
  End If
  
  If X1 - iSize < 0 Then X1 = iSize
  If Y1 - iSize < 0 Then Y1 = iSize
  
  If X1 - iSize < 0 Then X1 = iSize
  If Y1 - iSize < 0 Then Y1 = iSize
  
  tR = NewRectangle(X1 - iSize, Y1 - iSize - 10, X1, Y1)
  RectTwipsToPixel tR, m_ScaleX, m_ScaleY
  If bCircle Then
    Ellipse hDC, tR.Left, tR.Top, tR.Right, tR.Bottom
  Else
    FillRect hDC, tR, hBrush
  End If
  
  tR = NewRectangle(X1 - iSize, Y2, X1, Y2 + iSize)
  RectTwipsToPixel tR, m_ScaleX, m_ScaleY
  If bCircle Then
    Ellipse hDC, tR.Left, tR.Top, tR.Right, tR.Bottom
  Else
    FillRect hDC, tR, hBrush
  End If
  
  tR = NewRectangle(X2, Y1 - iSize - 10, X2 + iSize, Y1)
  RectTwipsToPixel tR, m_ScaleX, m_ScaleY
  If bCircle Then
    Ellipse hDC, tR.Left, tR.Top, tR.Right, tR.Bottom
  Else
    FillRect hDC, tR, hBrush
  End If
  
  tR = NewRectangle(X2, Y2, X2 + iSize, Y2 + iSize)
  RectTwipsToPixel tR, m_ScaleX, m_ScaleY
  If bCircle Then
    Ellipse hDC, tR.Left, tR.Top, tR.Right, tR.Bottom
  Else
    FillRect hDC, tR, hBrush
  End If
  
  x = X1 + (X2 - X1) / 2
  x = x - iSize / 2
  tR = NewRectangle(x, Y2, x + iSize, Y2 + iSize)
  RectTwipsToPixel tR, m_ScaleX, m_ScaleY
  If bCircle Then
    Ellipse hDC, tR.Left, tR.Top, tR.Right, tR.Bottom
  Else
    FillRect hDC, tR, hBrush
  End If
  
  tR = NewRectangle(x, Y1 - iSize - 10, x + iSize, Y1)
  RectTwipsToPixel tR, m_ScaleX, m_ScaleY
  If bCircle Then
    Ellipse hDC, tR.Left, tR.Top, tR.Right, tR.Bottom
  Else
    FillRect hDC, tR, hBrush
  End If
  
  y = Y1 + (Y2 - Y1) / 2
  y = y - iSize / 2
  tR = NewRectangle(X1 - iSize, y, X1, y + iSize)
  RectTwipsToPixel tR, m_ScaleX, m_ScaleY
  If bCircle Then
    Ellipse hDC, tR.Left, tR.Top, tR.Right, tR.Bottom
  Else
    FillRect hDC, tR, hBrush
  End If
  
  tR = NewRectangle(X2, y, X2 + iSize, y + iSize)
  RectTwipsToPixel tR, m_ScaleX, m_ScaleY
  If bCircle Then
    Ellipse hDC, tR.Left, tR.Top, tR.Right, tR.Bottom
  Else
    FillRect hDC, tR, hBrush
  End If
  
  If bCircle Then
    DeleteObject SelectObject(hDC, hOldPen)
    DeleteObject SelectObject(hDC, hOldBrush)
  Else
    DeleteObject hBrush
  End If
End Sub
                                                           
Public Sub PaintPicture(ByRef Graph As Object)
  Dim tR      As RECT
  
  GetClientRect Graph.hwnd, tR
  
  If m_Zoom = 100 Then
    BitBlt Graph.hDC, 0, 0, tR.Right, tR.Bottom, m_hMemDC, 0, 0, vbSrcCopy
  Else
    Dim Width  As Long
    Dim Height As Long
    Dim OldStrMode  As Long
    Dim LrPoint     As POINTAPI
    
    GetBitmapSize m_hBmpCopy, Width, Height, False
    
    OldStrMode = SetStretchBltMode(Graph.hDC, STRETCH_HALFTONE)
    
    StretchBlt Graph.hDC, 0, 0, tR.Right, tR.Bottom, m_hMemDC, 0, 0, Width, Height, vbSrcCopy
    SetStretchBltMode Graph.hDC, OldStrMode
  End If
  
  Dim i As Integer
  
  For i = 1 To UBound(m_vSelectedKeys)
    SetFocusAux m_vSelectedKeys(i), Graph.hDC
  Next
End Sub

Public Sub BeginMove()
  Dim i As Integer
  
  If m_BeginMoveDone Then Exit Sub
  
  m_BeginMoveDone = True
  
  For i = 1 To UBound(m_vSelectedKeys)
    SetFocusAux m_vSelectedKeys(i), m_hMemDC
  Next
End Sub

Private Sub PaintPictureMove(ByRef Graph As Object, ByRef tR As RECT)
  InflateRect tR, 3, 3

  If tR.Left < 0 Then tR.Left = 0
  If tR.Top < 0 Then tR.Top = 0

  If tR.Right > Graph.Width Then
    tR.Right = Graph.Width
  End If
  
  If tR.Bottom > Graph.Height Then
    tR.Bottom = Graph.Height - tR.Top
  End If
  
  InflateRect tR, 3, 3

  RectTwipsToPixel tR, m_ScaleX, m_ScaleY
  
  BitBlt Graph.hDC, _
         tR.Left, _
         tR.Top, _
         tR.Right - tR.Left, _
         tR.Bottom - tR.Top, _
         m_hMemDC, _
         tR.Left, _
         tR.Top, _
         vbSrcCopy
End Sub

' Creo un Brush para pintar la grilla del fondo
Private Sub pCreateBrushGrid(ByRef Graph As Object, ByVal TypeGrid As csETypeGrid)
  Dim i             As Long
  Dim hBmp          As Long
  Dim hMemDC        As Long
  Dim hBrush        As Long

  hMemDC = CreateCompatibleDC(0)
  hBmp = CreateCompatibleBitmap(Graph.hDC, 10, 10)
  SelectObject hMemDC, hBmp
  
  hBrush = CreateSolidBrush(TranslateColor(vbWhite))
  FillRect hMemDC, NewRectangle(0, 0, 10, 10), hBrush
  
  Select Case TypeGrid
    Case csEGridLines
      For i = 1 To 10
        SetPixel hMemDC, 0, i, TranslateColor(&HC0C0C0)
        SetPixel hMemDC, i, 0, TranslateColor(&HC0C0C0)
      Next
    Case csEGridPoints
      SetPixel hMemDC, 1, 1, TranslateColor(vbBlack)
    Case csEGridLinesHorizontal
      For i = 0 To 10
        SetPixel hMemDC, i, 0, TranslateColor(&HC0C0C0)
      Next
    Case csEGridLinesVertical
      For i = 0 To 10
        SetPixel hMemDC, 0, i, TranslateColor(&HC0C0C0)
      Next
  End Select
  
  
  m_hBrushGrid = CreatePatternBrush(hBmp)
  DeleteObject hMemDC
  DeleteObject hBmp
  DeleteObject hBrush
End Sub

'
Private Property Get plEvaluateTextWidth(ByVal Text As String, ByVal hDC As Long, ByVal ScaleX As Long) As Long
  Dim tR          As RECT
  
  DrawText hDC, Text & vbNullChar, -1, tR, DT_CALCRECT
  plEvaluateTextWidth = ((tR.Right - tR.Left) * Screen.TwipsPerPixelX) / ScaleX
End Property

Private Property Get plEvaluateTextHeight(ByVal Text As String, ByVal hDC As Long, _
                                          ByVal lWidth As Long, ByVal Flags As Long, _
                                          ByVal ScaleY As Long, ByVal ScaleX As Long) As Long
  Dim tR          As RECT
  
  tR.Right = (lWidth / Screen.TwipsPerPixelX) * ScaleX
  DrawText hDC, Text & vbNullChar, -1, tR, DT_CALCRECT Or Flags
  plEvaluateTextHeight = ((tR.Bottom - tR.Top) * Screen.TwipsPerPixelY) / ScaleY
End Property

Private Sub pClearObject(ByVal Key As String, ByVal hDC As Long, ByRef Graph As Object)
  Dim oPaintObj As cReportPaintObject
  
  Set oPaintObj = m_PaintObjects.Item(Key)

  If oPaintObj Is Nothing Then Exit Sub
  
  Dim tR As RECT
  
  With oPaintObj.Aspect
    tR = NewRectangle(.Left, .Top, .Left + .Width, .Top + .Height)
  End With
  
  If tR.Left < 0 Then tR.Left = 0
  If tR.Top < 0 Then tR.Top = 0

  If tR.Right > Graph.Width Then tR.Right = Graph.Width - tR.Left
  If tR.Bottom > Graph.Height Then tR.Bottom = Graph.Height - tR.Top

  RectTwipsToPixel tR, m_ScaleX, m_ScaleY
  
  Dim hBr As Long
  hBr = CreateSolidBrush(TranslateColor(vbWhite))
  FillRect hDC, tR, hBr
  DeleteObject hBr
End Sub


Private Sub pDrawObjBox(ByVal hDC As Long, ByRef Aspect As cReportAspect, _
                        ByVal X1 As Long, ByVal Y1 As Long, ByVal X2 As Long, ByVal Y2 As Long, _
                        ByVal Filled As Boolean, ByVal ColorIn As Long, ByVal ColorOut As Long)
  
  With Aspect
    ' Si no se indico sin borde o si se
    ' indico Filled
    If (m_NotBorder = False Or Filled) Or (.BorderType <> csRptBSNone) Then
        
      If .BorderType = csReportBorderType.csRptBS3d Then
        
        PrintLine hDC, Filled, X1, Y1, X2, Y2, ColorIn, , , vbWhite
          
        ' Linea de arriba
        PrintLine hDC, False, X1, Y1, X2, Y1, , 1, , .BorderColor3d
        ' Linea de abajo
        PrintLine hDC, False, X1, Y2 - 20, X2, Y2 - 20, , 1, , .BorderColor3dShadow
        ' izquierda
        PrintLine hDC, False, X1 + 10, Y1, X1 + 10, Y2, , 1, , .BorderColor3d
        ' derecha
        PrintLine hDC, False, X2 - 10, Y1, X2 - 10, Y2, , 1, , .BorderColor3dShadow

      ElseIf .BorderRounded Then
      
        PrintLine hDC, Filled, X1, Y1, X2, Y2, ColorIn, .BorderWidth, , ColorOut, True

      Else
        PrintLine hDC, Filled, X1, Y1, X2, Y2, ColorIn, , , ColorOut
      End If
    End If
  End With
End Sub

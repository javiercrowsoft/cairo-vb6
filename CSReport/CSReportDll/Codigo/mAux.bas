Attribute VB_Name = "mAux"
Option Explicit
'--------------------------------------------------------------------------------
' mAux
' 15-09-2001

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
  ' constantes
  ' estructuras
  Type BITMAP '14 bytes
    bmType As Long
    bmWidth As Long
    bmHeight As Long
    bmWidthBytes As Long
    bmPlanes As Integer
    bmBitsPixel As Integer
    bmBits As Long
  End Type
  ' funciones
  Public Declare Function GetObjectAPI Lib "gdi32" Alias "GetObjectA" (ByVal hObject As Long, ByVal nCount As Long, lpObject As Any) As Long

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module As String = "mAux"
Private Const csNoFecha As Date = #1/1/1900#

Public Const c_KeyIndexCol = "indexcol"
Public Const c_KeyIndexCol2 = "indexcol2"
Public Const c_KeyIndexGroup = "indexgroup"

Public Const csSqlDateString    As String = "\'yyyymmdd HH:nn:ss\'"

Public Enum csRptFormulaType
  csRptFPageNumber = 10001
  csRptFTotalPages = 10002
  csRptFAverage = 10003
  csRptFSum = 10004
  csRptMax = 10005
  csRptMin = 10006
  csRptCount = 10007
  csRptLength = 10008
  csRptFCalculo = 10009
  csRptFSumTime = 10010
  csRptFGetString = 10011
  csRptFNumberToString = 10012
  csRptFVal = 1010
  csRptDeclareVar = 10013
  csRptGetVar = 10014
  csRptAddToVar = 10015
  csRptSetVar = 10016
  csRptGetDataFromRsAd = 10017
  csRptGetParam = 10018
  csRptIsEqual = 10019
  csRptIsNotEqual = 10020
  csRptIsGreaterThan = 10021
  csRptIsLessThan = 10022
  csRptGetDataFromRs = 10023
  
  csRptGroupTotal = 10024
  csRptGroupMax = 10025
  csRptGroupMin = 10026
  csRptGroupAverage = 10027
  csRptGroupPercent = 10028
  csRptGroupCount = 10029
  csRptGroupLineNumber = 10030
  
  csRptIsInRs = 10031
  csRptTextReplace = 10032
End Enum

' estructuras
Public Type Rectangle
  Height As Long
  Width  As Long
End Type
' variables privadas
Private m_NextKey As Long
' eventos
' propiedades publicas
' propiedades privadas
' funciones publicas
' funciones privadas
' construccion - destruccion
Public Function IsDbNull(ByVal Val As Variant) As Boolean
  IsDbNull = IsNull(Val)
End Function

Public Function IsNothing(ByRef Obj As Object) As Boolean
  IsNothing = Obj Is Nothing
End Function

Public Function GetNextKey() As Long
  m_NextKey = m_NextKey + 1
  GetNextKey = m_NextKey
End Function

Public Function RefreshNextKey(ByVal sKey As String) As Variant
  Dim KeyNumber As Long
  If IsNumeric(sKey) Then
    KeyNumber = CLng(sKey)
  Else
    If IsNumeric(Mid$(sKey, 2)) Then
      KeyNumber = CLng(Mid$(sKey, 2))
    End If
  End If
  
  If m_NextKey < KeyNumber Then m_NextKey = KeyNumber + 1
End Function

Public Sub Main()
  m_NextKey = 1000
End Sub

Public Function DateValue(ByVal Value As Variant) As Date
  If IsNull(Value) Then
    DateValue = csNoFecha
  ElseIf IsDate(Value) Then
    DateValue = VBA.DateValue(Value)
  Else
    DateValue = csNoFecha
  End If
End Function

Public Function ValVariant(ByRef Var As Variant) As Variant
  If IsNull(Var) Then
    Select Case VarType(Var)
      Case VbVarType.vbString
        ValVariant = vbNullString
      Case VbVarType.vbBoolean
        ValVariant = 0
      Case VbVarType.vbByte, VbVarType.vbDecimal, VbVarType.vbDouble, VbVarType.vbDouble, _
           VbVarType.vbInteger, VbVarType.vbLong, VbVarType.vbByte, VbVarType.vbSingle
        ValVariant = 0
      Case VbVarType.vbDate
        ValVariant = csNoFecha
    End Select
  Else
    ValVariant = Var
  End If
End Function

Public Function Format(Expression, _
                       Optional strFormat, _
                       Optional FirstDayOfWeek As VbDayOfWeek = vbSunday, _
                       Optional FirstWeekOfYear As VbFirstWeekOfYear = vbFirstJan1) As Variant
  
  If VarType(Expression) = vbDate Then
    If Expression = #1/1/1900# Then
      Format = vbNullString
      Exit Function
    End If
  End If
  
  If IsMissing(strFormat) Then
    Format = Expression
  ElseIf IsEmpty(strFormat) Then
    Format = Expression
  ElseIf LenB(strFormat) = 0 Then
    Format = Expression
  Else
    Format = VBA.Format(Expression, strFormat, FirstDayOfWeek, FirstWeekOfYear)
  End If
End Function

Public Function GetRealName(ByVal Name As String) As String
  Dim n As Long
  n = InStr(1, Name, "}.")
  If n > 0 Then
    n = n + 2
  Else
    n = 1
  End If
  GetRealName = Mid$(Name, n)
End Function

#If Not F_CSReportPaint Then
Public Function GetControlsInZOrder(ByRef Col As cReportControls) As cReportControls
  Dim i       As Integer
  Dim Ctrl    As cReportControl
  Dim ctrls   As cReportControls

  Set ctrls = New cReportControls
  Set ctrls.CopyColl = Col.CopyColl
  ctrls.TypeSection = Col.TypeSection
  Set ctrls.SectionLine = Col.SectionLine

  'Cargo una nueva coleccion en funcion del zorder
  While Col.Count > 0

    'Busco el zorder menor de esta coleccion
    i = 32767
    For Each Ctrl In Col
      If Ctrl.Label.Aspect.nZOrder < i Then
        i = Ctrl.Label.Aspect.nZOrder
      End If
    Next Ctrl

    For Each Ctrl In Col
      If Ctrl.Label.Aspect.nZOrder = i Then
        Col.Remove (Ctrl.Key)
        ctrls.Add Ctrl, Ctrl.Key
        Exit For
      End If
    Next Ctrl
    i = i + 1
  Wend
  ' Devuelvo la coleccion ordenada
  Set GetControlsInZOrder = ctrls
End Function

Public Function Val(ByVal Value As Variant) As Double
  If IsNumeric(Value) Then
    Val = CDbl(Value)
  Else
    Val = 0
  End If
End Function

Public Sub GetBitmapSize(ByVal hBmp, ByRef Width As Long, ByRef Height As Long)
  Dim sBitmapInfo   As BITMAP

  ' get the information about this image
  GetObjectAPI hBmp, Len(sBitmapInfo), sBitmapInfo

  Width = sBitmapInfo.bmWidth
  Height = sBitmapInfo.bmHeight
End Sub

#End If

'Public Sub pSaveLog(ByVal Msg As String)
'  On Error Resume Next
'  Dim f As Integer
'  f = FreeFile
'  Open "D:\Proyectos\CSHtml\AAARBA\Inscripcion\error.log" For Append As f
'  Print #f, Msg
'  Close f
'End Sub


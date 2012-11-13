Attribute VB_Name = "mPublic"
Option Explicit

'--------------------------------------------------------------------------------
' mPublic
' 23-04-2004

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "CSWebReport.mPublic"

#If Not PREPROC_CSWEBDATABASE Then

  Public gStrError As String
  Public gLogFile  As String

  Public Enum csEInfParamType
    csInfParamDate = 1
    csInfParamHelp = 2
    csInfParamNumeric = 3
    csInfParamSqlstmt = 4
    csInfParamText = 5
    csInfParamList = 6
    csInfParamCheck = 7
  End Enum
  
#End If
  
  Public Const csNoDate = #1/1/1900#

' estructuras
' variables privadas
' eventos
' propiedades publicas
' propiedades friend
' propiedades privadas
' funciones publicas
Public Function ValField(ByRef Fields As ADODB.Fields, ByVal FieldName As String) As Variant
  On Error GoTo ControlError
  
  Dim Field As ADODB.Field
  
  If IsNumeric(FieldName) Then
    Set Field = Fields(CInt(FieldName))
  Else
    Set Field = Fields(FieldName)
  End If
  
  If Field Is Nothing Then
    Err.Raise vbObjectError + 10, "VAL function CSOAPI", "No se paso un campo. Error interno"
  End If
  
  If IsNull(Field.Value) Then
    Select Case Field.Type
      Case adLongVarChar, adLongVarWChar, adChar, adVarChar, adVarWChar, adWChar
        ValField = ""
      Case adBigInt, adBinary, adInteger, adLongVarBinary, adNumeric, adSmallInt, adTinyInt, adUnsignedBigInt, adUnsignedInt, adUnsignedSmallInt, adUnsignedTinyInt
        ValField = 0
      Case adBoolean
        ValField = False
      Case adCurrency, adSingle, adDecimal, adDouble
        ValField = 0
      Case adDBTime, adDate, adDBDate
        ValField = csNoDate
      Case adDBTimeStamp
        ValField = csNoDate
    End Select
  Else
    ValField = Field.Value
  End If
  
  ' Comprobacion especial para el field activo
  If LCase(Field.Name) = "Activo" Then
    If ValField <> 0 Then
      ValField = "Si"
    Else
      ValField = "No"
    End If
  End If

  Exit Function
ControlError:
  If Err.Number = 3265 Then Err.description = "Falto el campo " & FieldName & vbCrLf & "Descripción original:" & Err.description
  Err.Raise Err.Number, Err.source, Err.description, Err.HelpFile, Err.HelpContext
End Function

#If Not PREPROC_CSWEBDATABASE Then

  Public Sub Main()
    gLogFile = App.Path & "\CSWebReport.log"
  End Sub

  Public Function VDGetDateById_(ByVal DateIndex As csDateEnum, Optional ByVal IniDate As Date) As Date
    If IniDate = 0 Then IniDate = Date
    
    Dim rtn As Date
    Dim DayNumber As Integer
    
    Select Case DateIndex
      Case csYearLast_FirstDay
        IniDate = DateAdd("yyyy", -1, IniDate)
        DateIndex = csYear_FirstDay
      Case csYearLast_LastDay
        IniDate = DateAdd("yyyy", -1, IniDate)
        DateIndex = csYear_LastDay
      Case csYearNext_FirstDay
        IniDate = DateAdd("yyyy", 1, IniDate)
        DateIndex = csYear_FirstDay
      Case csYearNext_LastDay
        IniDate = DateAdd("yyyy", 1, IniDate)
        DateIndex = csYear_LastDay
    End Select
    
    Select Case DateIndex
      Case csWeeckLast_FirstDay
        IniDate = DateAdd("d", -7, IniDate)
        DateIndex = csWeeck_FirstDay
      Case csWeeckLast_LastDay
        IniDate = DateAdd("d", -7, IniDate)
        DateIndex = csWeeck_LastDay
      Case csWeeckNext_FirstDay
        IniDate = DateAdd("d", 7, IniDate)
        DateIndex = csWeeck_FirstDay
      Case csWeeckNext_LastDay
        IniDate = DateAdd("d", 7, IniDate)
        DateIndex = csWeeck_LastDay
    
      Case csMonthLast_FirstDay
        IniDate = DateAdd("m", -1, IniDate)
        DateIndex = csMonth_FirstDay
      Case csMonthLast_LastDay
        IniDate = DateAdd("m", -1, IniDate)
        DateIndex = csMonth_LastDay
      Case csMonthNext_FirstDay
        IniDate = DateAdd("m", 1, IniDate)
        DateIndex = csMonth_FirstDay
      Case csMonthNext_LastDay
        IniDate = DateAdd("m", 1, IniDate)
        DateIndex = csMonth_LastDay
    
      Case csYear_FirstDay
        IniDate = DateAdd("m", -Month(IniDate) + 1, IniDate)
        DateIndex = csMonth_FirstDay
      Case csYear_LastDay
        IniDate = DateAdd("yyyy", 1, IniDate)
        IniDate = DateAdd("m", -Month(IniDate), IniDate)
        DateIndex = csMonth_LastDay
    End Select
    
    Select Case DateIndex
      Case csToday
        rtn = IniDate
      
      Case csYesterday
        rtn = DateAdd("d", -1, IniDate)
      
      Case csTomorrow
        rtn = DateAdd("d", 1, IniDate)
      
      Case csWeeck_FirstDay
        DayNumber = Weekday(IniDate, vbMonday)
        rtn = DateAdd("d", 1 - DayNumber, IniDate)
      
      Case csWeeck_LastDay
        DayNumber = Weekday(IniDate, vbMonday)
        rtn = DateAdd("d", 7 - DayNumber, IniDate)
      
      Case csMonth_FirstDay
        DayNumber = Day(IniDate)
        rtn = DateAdd("d", -DayNumber + 1, IniDate)
        
      Case csMonth_LastDay
        IniDate = DateAdd("m", 1, IniDate)
        DayNumber = Day(IniDate)
        rtn = DateAdd("d", -DayNumber, IniDate)
    End Select
  
    VDGetDateById_ = rtn
  End Function
  
  Public Sub MngError_(ByRef ErrObj As Object, _
                       ByVal NameFunction As String, _
                       ByVal Module As String, _
                       ByVal InfoAdd As String, _
                       Optional ByVal Title As String = "", _
                       Optional ByVal Level, _
                       Optional ByVal VarType, _
                       Optional ByVal ConnectionObj As Object)
    
    gStrError = Err.description
    SaveLog gStrError
    
  End Sub

  Public Sub SaveLog(ByVal strLog As String)
    On Error Resume Next
    Dim iLog As Long
    iLog = FreeFile
    Open gLogFile For Append As iLog
    Print #iLog, strLog
    Close iLog
  End Sub

#End If

' funciones friend
' funciones privadas
' construccion - destruccion

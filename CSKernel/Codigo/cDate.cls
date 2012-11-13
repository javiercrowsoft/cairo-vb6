VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cDate"
Attribute VB_GlobalNameSpace = True
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cDate
' 11-05-2003

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cDate"

Public Enum csDateEnum
  csToday = 1
  csYesterday = 2
  csTomorrow = 3
  csWeeck_FirstDay = 4
  csWeeck_LastDay = 5
  csWeeckLast_FirstDay = 6
  csWeeckLast_LastDay = 7
  csWeeckNext_FirstDay = 8
  csWeeckNext_LastDay = 9
  csMonth_FirstDay = 10
  csMonth_LastDay = 11
  csMonthLast_FirstDay = 12
  csMonthLast_LastDay = 13
  csMonthNext_FirstDay = 14
  csMonthNext_LastDay = 15
  csYear_FirstDay = 16
  csYear_LastDay = 17
  csYearLast_FirstDay = 18
  csYearLast_LastDay = 19
  csYearNext_FirstDay = 20
  csYearNext_LastDay = 21
End Enum
' estructuras
' variables privadas
Private m_DateNames         As cDateNames
' eventos
' propiedadades publicas
Public Property Get DateNames() As cDateNames
  Set DateNames = m_DateNames
End Property
Public Property Set DateNames(ByVal rhs As cDateNames)
  Set m_DateNames = rhs
End Property
' propiedadades friend
' propiedades privadas
' funciones publicas
Public Function VDGetDate(ByVal DateName As String, Optional ByVal IniDate As Date) As Date
  If IsNumeric(DateName) Then
    VDGetDate = VDGetDateById(DateName, IniDate)
  Else
    VDGetDate = VDGetDateByName(DateName, IniDate)
  End If
End Function
Public Function VDGetDateByName(ByVal DateName As String, Optional ByVal IniDate As Date) As Date
  Dim dn As cDateName
  
  DateName = LCase(DateName)
  
  For Each dn In m_DateNames
    If dn.Code = DateName Or dn.Name = DateName Then
      VDGetDateByName = VDGetDateById(dn.Id, IniDate)
      Exit For
    End If
  Next
End Function

Public Function VDGetDateById(ByVal DateIndex As csDateEnum, Optional ByVal IniDate As Date) As Date
  VDGetDateById = VDGetDateById_(DateIndex, IniDate)
End Function

' funciones friend
' funciones privadas
' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError

  Dim dn As cDateName

  Set m_DateNames = New cDateNames
  
  Set dn = m_DateNames.Add(Nothing, "a")
    dn.Id = csYesterday
    dn.Name = "Ayer"
    dn.Code = "a"
    dn.Group = "Dias"
  
  Set dn = m_DateNames.Add(Nothing, "h")
    dn.Id = csToday
    dn.Name = "Hoy"
    dn.Code = "h"
    dn.Group = "Dias"

  Set dn = m_DateNames.Add(Nothing, "m")
    dn.Id = csTomorrow
    dn.Name = "Mañana"
    dn.Code = "m"
    dn.Group = "Dias"
    
  Set dn = m_DateNames.Add(Nothing, "psa")
    dn.Id = csWeeckLast_FirstDay
    dn.Name = "Primer dia de la semana anterior"
    dn.Code = "psa"
    dn.Group = "Semana"
  
  Set dn = m_DateNames.Add(Nothing, "usa")
    dn.Id = csWeeckLast_LastDay
    dn.Name = "Ultimo dia de la semana anterior"
    dn.Code = "usa"
    dn.Group = "Semana"
  
  Set dn = m_DateNames.Add(Nothing, "ps")
    dn.Id = csWeeck_FirstDay
    dn.Name = "Primer dia de la semana"
    dn.Code = "ps"
    dn.Group = "Semana"
    
  Set dn = m_DateNames.Add(Nothing, "us")
    dn.Id = csWeeck_LastDay
    dn.Name = "Ultimo dia de la semana"
    dn.Code = "us"
    dn.Group = "Semana"
    
  Set dn = m_DateNames.Add(Nothing, "psp")
    dn.Id = csWeeckNext_FirstDay
    dn.Name = "Primer dia de la semana proxima"
    dn.Code = "psp"
    dn.Group = "Semana"
    
  Set dn = m_DateNames.Add(Nothing, "usp")
    dn.Id = csWeeckNext_LastDay
    dn.Name = "Ultimo dia de la semana proxima"
    dn.Code = "usp"
    dn.Group = "Semana"
    
  Set dn = m_DateNames.Add(Nothing, "pma")
    dn.Id = csMonthLast_FirstDay
    dn.Name = "Primer dia del mes anterior"
    dn.Code = "pma"
    dn.Group = "Mes"
    
  Set dn = m_DateNames.Add(Nothing, "uma")
    dn.Id = csMonthLast_LastDay
    dn.Name = "Ultimo dia del mes anterior"
    dn.Code = "uma"
    dn.Group = "Mes"
  
  Set dn = m_DateNames.Add(Nothing, "pm")
    dn.Id = csMonth_FirstDay
    dn.Name = "Primer dia del mes"
    dn.Code = "pm"
    dn.Group = "Mes"
    
  Set dn = m_DateNames.Add(Nothing, "um")
    dn.Id = csMonth_LastDay
    dn.Name = "Ultimo dia del mes"
    dn.Code = "um"
    dn.Group = "Mes"
    
  Set dn = m_DateNames.Add(Nothing, "pmp")
    dn.Id = csMonthNext_FirstDay
    dn.Name = "Primer dia del mes proximo"
    dn.Code = "pmp"
    dn.Group = "Mes"
    
  Set dn = m_DateNames.Add(Nothing, "ump")
    dn.Id = csMonthNext_LastDay
    dn.Name = "Ultimo dia del mes proximo"
    dn.Code = "ump"
    dn.Group = "Mes"
    
  Set dn = m_DateNames.Add(Nothing, "paa")
    dn.Id = csYearLast_FirstDay
    dn.Name = "Primer dia del año anterior"
    dn.Code = "paa"
    dn.Group = "Año"
    
  Set dn = m_DateNames.Add(Nothing, "uaa")
    dn.Id = csYearLast_LastDay
    dn.Name = "Ultimo dia del año anterior"
    dn.Code = "uaa"
    dn.Group = "Año"
  
  Set dn = m_DateNames.Add(Nothing, "pa")
    dn.Id = csYear_FirstDay
    dn.Name = "Primer dia del año"
    dn.Code = "pa"
    dn.Group = "Año"
    
  Set dn = m_DateNames.Add(Nothing, "ua")
    dn.Id = csYear_LastDay
    dn.Name = "Ultimo dia del año"
    dn.Code = "ua"
    dn.Group = "Año"
    
  Set dn = m_DateNames.Add(Nothing, "pap")
    dn.Id = csYearNext_FirstDay
    dn.Name = "Primer dia del año proximo"
    dn.Code = "pap"
    dn.Group = "Año"
    
  Set dn = m_DateNames.Add(Nothing, "uap")
    dn.Id = csYearNext_LastDay
    dn.Name = "Ultimo dia del año proximo"
    dn.Code = "uap"
    dn.Group = "Año"
    
  GoTo ExitProc
ControlError:
  MngError_ Err, "Class_Initialize", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
  On Error GoTo ControlError
  
  Set m_DateNames = Nothing
  
  GoTo ExitProc
ControlError:
  MngError_ Err, "Class_Terminate", C_Module, ""
  If Err.Number Then Resume ExitProc
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
'  If Err.Number Then Resume ExitProc
'ExitProc:
'  On Error Resume Next



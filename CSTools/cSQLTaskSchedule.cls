VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cSQLTaskSchedule"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cSQLTaskSchedule
' 22-05-2002

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cSQLTaskSchedule"

' estructuras
' variables privadas
Private m_TypeRun         As csScheduleTypeTRun
Private m_TypeTime        As csScheduleTypeTime

Private m_FirtsRunStartAt As Date ' Para todas las tareas indican cuando empiezan y cuando terminan
Private m_LastRunEndAt    As Date ' Nota si m_LastRunEndAt = csSchEndUndefined  -> nunca termina

Private m_Time            As Date ' Para tereas de tipo csScheduleTypeTime.csSchTypeTimeAtThisTime
                                  ' Indica la hora de ejecucion


' Para tareas csScheduleTypeTime.csSchTypeTimeRecurring
Private m_TimeStart       As Date
Private m_TimeEnd         As Date
Private m_RunEach         As Integer
Private m_RunEachType     As csScheduleEachType

' Cada cuantos dia corre si es Daily
Private m_RunDailyInterval  As Integer

' Que dias corre si es Weekly
Private m_RunWeeklyInterval As Integer
Private m_RunSunday         As Boolean
Private m_RunMonday         As Boolean
Private m_RunTuesday        As Boolean
Private m_RunWednesday      As Boolean
Private m_RunThursday       As Boolean
Private m_RunFriday         As Boolean
Private m_RunSaturday       As Boolean

' Si es Monthly
Private m_RunMonthlyNumberDay   As Integer  ' El 1ro, 2, 5,... etc
Private m_RunMonthlyInterval    As Integer  ' Cada 1, 2, 4,... meses
  ' El primero, segundo, ... lunes, martes, ... del mes.
Private m_RunMonthlyCardinalDay As csScheduleRunMonthlyCardinal
Private m_RunMonthlyNameDay     As csScheduleRunMonthlyName

Private m_Name                          As String
Private m_Schedule                      As SQLDMO.JobSchedule
' eventos
' propiedadades publicas
Public Property Get Schedule() As SQLDMO.JobSchedule
   Set Schedule = m_Schedule
End Property

Public Property Set Schedule(ByRef rhs As SQLDMO.JobSchedule)
   Set m_Schedule = rhs
End Property

Public Property Get TypeRun() As csScheduleTypeTRun
  TypeRun = m_TypeRun
End Property
Public Property Get TypeTime() As csScheduleTypeTime
  TypeTime = m_TypeTime
End Property
Public Property Get FirtsRunStartAt() As Date
  FirtsRunStartAt = m_FirtsRunStartAt
End Property
Public Property Get LastRunEndAt() As Date
  LastRunEndAt = m_LastRunEndAt
End Property
Public Property Get Time() As Date
  Time = m_Time
End Property
Public Property Get TimeStart() As Date
  TimeStart = m_TimeStart
End Property
Public Property Get TimeEnd() As Date
  TimeEnd = m_TimeEnd
End Property
Public Property Get RunEach() As Integer
  RunEach = m_RunEach
End Property
Public Property Get RunEachType() As csScheduleEachType
  RunEachType = m_RunEachType
End Property
Public Property Get RunDailyInterval() As Integer
  RunDailyInterval = m_RunDailyInterval
End Property
Public Property Get RunWeeklyInterval() As Integer
  RunWeeklyInterval = m_RunWeeklyInterval
End Property
Public Property Get RunMonday() As Boolean
  RunMonday = m_RunMonday
End Property
Public Property Get RunSunday() As Boolean
  RunSunday = m_RunSunday
End Property
Public Property Get RunTuesday() As Boolean
  RunTuesday = m_RunTuesday
End Property
Public Property Get RunWednesday() As Boolean
  RunWednesday = m_RunWednesday
End Property
Public Property Get RunThursday() As Boolean
  RunThursday = m_RunThursday
End Property
Public Property Get RunFriday() As Boolean
  RunFriday = m_RunFriday
End Property
Public Property Get RunSaturday() As Boolean
  RunSaturday = m_RunSaturday
End Property
Public Property Get RunMonthlyNumberDay() As Integer
  RunMonthlyNumberDay = m_RunMonthlyNumberDay
End Property
Public Property Get RunMonthlyInterval() As Integer
  RunMonthlyInterval = m_RunMonthlyInterval
End Property
Public Property Get RunMonthlyCardinalDay() As csScheduleRunMonthlyCardinal
  RunMonthlyCardinalDay = m_RunMonthlyCardinalDay
End Property
Public Property Get RunMonthlyNameDay() As csScheduleRunMonthlyName
  RunMonthlyNameDay = m_RunMonthlyNameDay
End Property

Public Property Let TypeRun(ByVal rhs As csScheduleTypeTRun)
  m_TypeRun = rhs
End Property
Public Property Let TypeTime(ByVal rhs As csScheduleTypeTime)
  m_TypeTime = rhs
End Property
Public Property Let FirtsRunStartAt(ByVal rhs As Date)
  m_FirtsRunStartAt = rhs
End Property
Public Property Let LastRunEndAt(ByVal rhs As Date)
  m_LastRunEndAt = rhs
End Property
Public Property Let Time(ByVal rhs As Date)
  m_Time = rhs
End Property
Public Property Let TimeStart(ByVal rhs As Date)
  m_TimeStart = rhs
End Property
Public Property Let TimeEnd(ByVal rhs As Date)
  m_TimeEnd = rhs
End Property
Public Property Let RunEach(ByVal rhs As Integer)
  m_RunEach = rhs
End Property
Public Property Let RunEachType(ByVal rhs As csScheduleEachType)
  m_RunEachType = rhs
End Property
Public Property Let RunDailyInterval(ByVal rhs As Integer)
  m_RunDailyInterval = rhs
End Property
Public Property Let RunWeeklyInterval(ByVal rhs As Integer)
  m_RunWeeklyInterval = rhs
End Property
Public Property Let RunMonday(ByVal rhs As Boolean)
  m_RunMonday = rhs
End Property
Public Property Let RunSunday(ByVal rhs As Boolean)
  m_RunSunday = rhs
End Property
Public Property Let RunTuesday(ByVal rhs As Boolean)
  m_RunTuesday = rhs
End Property
Public Property Let RunWednesday(ByVal rhs As Boolean)
  m_RunWednesday = rhs
End Property
Public Property Let RunThursday(ByVal rhs As Boolean)
  m_RunThursday = rhs
End Property
Public Property Let RunFriday(ByVal rhs As Boolean)
  m_RunFriday = rhs
End Property
Public Property Let RunSaturday(ByVal rhs As Boolean)
  m_RunSaturday = rhs
End Property
Public Property Let RunMonthlyNumberDay(ByVal rhs As Integer)
  m_RunMonthlyNumberDay = rhs
End Property
Public Property Let RunMonthlyInterval(ByVal rhs As Integer)
  m_RunMonthlyInterval = rhs
End Property
Public Property Let RunMonthlyCardinalDay(ByVal rhs As csScheduleRunMonthlyCardinal)
  m_RunMonthlyCardinalDay = rhs
End Property
Public Property Let RunMonthlyNameDay(ByVal rhs As csScheduleRunMonthlyName)
  m_RunMonthlyNameDay = rhs
End Property

Public Property Get Name() As String
   Name = m_Name
End Property

Public Property Let Name(ByVal rhs As String)
   m_Name = rhs
End Property

' propiedadades friend
' propiedades privadas
' funciones publicas
Public Function Show() As Boolean
  On Error GoTo ControlError

  Dim f As fSchedule
  Set f = New fSchedule
  
  f.Show vbModal

  GoTo ExitProc
ControlError:
  MngError Err, "Show", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
  
  Unload f
End Function
' funciones friend
' funciones privadas
' construccion - destruccion
Private Sub Class_Initialize()
  m_FirtsRunStartAt = Now
  m_LastRunEndAt = csSchEndUndefined
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

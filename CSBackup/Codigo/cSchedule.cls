VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cSchedule"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' cSchedule
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
Private Const C_Module = "cSchedule"

' estructuras
' variables privadas
Private m_RunType         As csScheduleRunType
Private m_TimeType        As csScheduleTimeType

Private m_FirtsRunStartAt As Date ' Para todas las tareas indican cuando empiezan y cuando terminan
Private m_LastRunEndAt    As Date ' Nota si m_LastRunEndAt = csSchEndUndefined  -> nunca termina

Private m_LastRun         As Date

Private m_Time            As Date ' Para tereas de tipo csScheduleTimeType.csSchTimeTypeAtThisTime
                                  ' Indica la hora de ejecucion


' Para tareas csScheduleTimeType.csSchTimeTypeRecurring
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

Private m_Tasks  As Collection

' eventos
' propiedadades publicas
Public Property Get RunType() As csScheduleRunType
  RunType = m_RunType
End Property
Public Property Get TimeType() As csScheduleTimeType
  TimeType = m_TimeType
End Property
Public Property Get FirtsRunStartAt() As Date
  FirtsRunStartAt = m_FirtsRunStartAt
End Property
Public Property Get LastRunEndAt() As Date
  LastRunEndAt = m_LastRunEndAt
End Property
Public Property Get LastRun() As Date
  LastRun = m_LastRun
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

Public Property Let RunType(ByVal rhs As csScheduleRunType)
  m_RunType = rhs
End Property
Public Property Let TimeType(ByVal rhs As csScheduleTimeType)
  m_TimeType = rhs
End Property
Public Property Let FirtsRunStartAt(ByVal rhs As Date)
  m_FirtsRunStartAt = rhs
End Property
Public Property Let LastRunEndAt(ByVal rhs As Date)
  m_LastRunEndAt = rhs
End Property
Public Property Let LastRun(ByVal rhs As Date)
  m_LastRun = rhs
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

Public Property Get Tasks() As Collection
  Set Tasks = m_Tasks
End Property

Public Property Set Tasks(ByRef rhs As Collection)
  Set m_Tasks = rhs
End Property

' propiedadades friend
' propiedades privadas
' funciones publicas
Public Function Load(ByVal ScheduleFile As String, _
                     ByVal bSilent As Boolean, _
                     Optional ByRef strError As String) As Boolean
  Dim DocXml As cXml
  Set DocXml = New cXml
  
  DocXml.Init Nothing
  DocXml.Name = GetFileName_(ScheduleFile)
  DocXml.Path = GetPath_(ScheduleFile)
  
  If Not DocXml.OpenXml(bSilent, strError) Then Exit Function
  
  m_Name = ""
  
  Dim Root  As Object
  Dim Node  As Object
  Dim Prop  As Object
  
  Set Root = DocXml.GetRootNode()

  m_Name = pGetChildNodeProperty(Root, DocXml, "Name", "Value")
  
  m_RunType = pGetChildNodeProperty(Root, DocXml, "RunType", "Value")
  m_TimeType = pGetChildNodeProperty(Root, DocXml, "TimeType", "Value")
  m_FirtsRunStartAt = pGetChildNodeProperty(Root, DocXml, "FirtsRunStartAt", "Value", csDate)
  m_LastRunEndAt = pGetChildNodeProperty(Root, DocXml, "LastRunEndAt", "Value", csDate)
  m_LastRun = pGetChildNodeProperty(Root, DocXml, "LastRun", "Value", csDate)
  m_Time = pGetChildNodeProperty(Root, DocXml, "Time", "Value", csDate)
  m_TimeStart = pGetChildNodeProperty(Root, DocXml, "TimeStart", "Value", csDate)
  m_TimeEnd = pGetChildNodeProperty(Root, DocXml, "TimeEnd", "Value", csDate)
  m_RunEach = pGetChildNodeProperty(Root, DocXml, "RunEach", "Value")
  m_RunEachType = pGetChildNodeProperty(Root, DocXml, "RunEachType", "Value")
  m_RunDailyInterval = pGetChildNodeProperty(Root, DocXml, "RunDailyInterval", "Value")
  m_RunWeeklyInterval = pGetChildNodeProperty(Root, DocXml, "RunWeeklyInterval", "Value")
  m_RunMonthlyInterval = pGetChildNodeProperty(Root, DocXml, "RunMonthlyInterval", "Value")
  m_RunMonthlyNumberDay = pGetChildNodeProperty(Root, DocXml, "RunMonthlyNumberDay", "Value")
  m_RunMonthlyCardinalDay = pGetChildNodeProperty(Root, DocXml, "RunMonthlyCardinalDay", "Value")
  m_RunMonthlyNameDay = pGetChildNodeProperty(Root, DocXml, "RunMonthlyNameDay", "Value")
  m_RunSunday = pGetChildNodeProperty(Root, DocXml, "RunSunday", "Value")
  m_RunMonday = pGetChildNodeProperty(Root, DocXml, "RunMonday", "Value")
  m_RunTuesday = pGetChildNodeProperty(Root, DocXml, "RunTuesday", "Value")
  m_RunWednesday = pGetChildNodeProperty(Root, DocXml, "RunWednesday", "Value")
  m_RunThursday = pGetChildNodeProperty(Root, DocXml, "RunThursday", "Value")
  m_RunFriday = pGetChildNodeProperty(Root, DocXml, "RunFriday", "Value")
  m_RunSaturday = pGetChildNodeProperty(Root, DocXml, "RunSaturday", "Value")
   
  pLoadTasks DocXml, DocXml.GetNodeFromNode(Root, "Tasks")

  Load = True
End Function

Public Function Save(ByVal bSilent As Boolean, _
                     Optional ByRef strError As String) As Boolean
  Dim DocXml    As cXml
  Dim dbPath    As String
  Dim Root      As Object
  
  Set DocXml = New cXml
  
  dbPath = GetIniValue(csSecConfig, _
                       csDbPath, _
                       vbNullString, _
                       GetIniFullFile(csIniFile))
  
  DocXml.Init Nothing
  DocXml.Name = m_Name & "_sch.xml"
  DocXml.Path = dbPath

  If Not DocXml.NewXml() Then Exit Function
  
  Set Root = DocXml.GetRootNode()
  
  pAddTag DocXml, Root, "Name", m_Name
  pAddTag DocXml, Root, "RunType", m_RunType
  pAddTag DocXml, Root, "TimeType", m_TimeType
  pAddTag DocXml, Root, "FirtsRunStartAt", m_FirtsRunStartAt
  pAddTag DocXml, Root, "LastRunEndAt", m_LastRunEndAt
  pAddTag DocXml, Root, "LastRun", m_LastRun
  pAddTag DocXml, Root, "Time", m_Time
  pAddTag DocXml, Root, "TimeStart", m_TimeStart
  pAddTag DocXml, Root, "TimeEnd", m_TimeEnd
  pAddTag DocXml, Root, "RunEach", m_RunEach
  pAddTag DocXml, Root, "RunEachType", m_RunEachType
  pAddTag DocXml, Root, "RunDailyInterval", CInt(m_RunDailyInterval)
  pAddTag DocXml, Root, "RunWeeklyInterval", CInt(m_RunWeeklyInterval)
  pAddTag DocXml, Root, "RunSunday", CInt(m_RunSunday)
  pAddTag DocXml, Root, "RunMonday", CInt(m_RunMonday)
  pAddTag DocXml, Root, "RunTuesday", CInt(m_RunTuesday)
  pAddTag DocXml, Root, "RunWednesday", CInt(m_RunWednesday)
  pAddTag DocXml, Root, "RunThursday", CInt(m_RunThursday)
  pAddTag DocXml, Root, "RunFriday", CInt(m_RunFriday)
  pAddTag DocXml, Root, "RunSaturday", CInt(m_RunSaturday)
  pAddTag DocXml, Root, "RunMonthlyNumberDay", m_RunMonthlyNumberDay
  pAddTag DocXml, Root, "RunMonthlyInterval", m_RunMonthlyInterval
  pAddTag DocXml, Root, "RunMonthlyCardinalDay", m_RunMonthlyCardinalDay
  pAddTag DocXml, Root, "RunMonthlyNameDay", m_RunMonthlyNameDay
  
  pSaveTask pAddTag(DocXml, Root, "Tasks", ""), _
               DocXml
  
  Save = DocXml.Save(bSilent, strError)
End Function
' funciones friend
' funciones privadas

Private Sub pSaveTask(ByVal NodeTasks As Object, _
                      ByRef DocXml As cXml)
  Dim Task     As cTask
  Dim Node     As Object
  
  For Each Task In m_Tasks
  
    Set Node = pAddTag(DocXml, NodeTasks, "Task", Task.Name)
  
  Next
End Sub

Private Sub pLoadTasks(ByRef DocXml As cXml, _
                         ByRef NodeTasks As Object)
  Dim Node As Object
  Dim Task As cTask
  
  If NodeTasks Is Nothing Then Exit Sub
  
  Set Node = DocXml.GetNodeChild(NodeTasks)
  
  While Not Node Is Nothing
  
    Set Task = New cTask
    m_Tasks.Add Task
    Task.Name = DocXml.GetNodeProperty(Node, "Value").Value(csText)
  
    Set Node = DocXml.GetNextNode(Node)
  Wend
End Sub

' construccion - destruccion
Private Sub Class_Initialize()
  m_FirtsRunStartAt = Now
  m_LastRunEndAt = csSchEndUndefined
  Set m_Tasks = New Collection
End Sub

Private Sub Class_Terminate()
  Set m_Tasks = Nothing
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

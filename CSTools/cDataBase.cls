VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cDataBase"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cDataBase
' 15-07-2002

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cDataBase"
' estructuras
' variables privadas
Private m_Name                          As String
Private m_Tables                        As cTables
Private m_Views                         As cViews
Private m_Procedures                    As cProcedures
Private m_Loaded                        As Boolean

Private m_InfoLoaded  As Boolean
Private m_dbInfo      As Collection
Private m_Connection  As cConnection

' eventos
' propiedadades publicas
Public Property Get Name() As String
Attribute Name.VB_UserMemId = 0
   Name = m_Name
End Property

Public Property Let Name(ByVal rhs As String)
   m_Name = rhs
End Property

Public Property Get Tables() As cTables
   Set Tables = m_Tables
End Property

Public Property Set Tables(ByVal rhs As cTables)
   Set m_Tables = rhs
End Property

Public Property Get Views() As cViews
   Set Views = m_Views
End Property

Public Property Set Views(ByVal rhs As cViews)
   Set m_Views = rhs
End Property

Public Property Get Procedures() As cProcedures
   Set Procedures = m_Procedures
End Property

Public Property Set Procedures(ByVal rhs As cProcedures)
   Set m_Procedures = rhs
End Property

Public Property Get Loaded() As Boolean
   Loaded = m_Loaded
End Property

' propiedadades friend
Friend Property Let Loaded(ByVal rhs As Boolean)
   m_Loaded = rhs
End Property

Friend Property Set Conn(ByRef rhs As cConnection)
  Set m_Connection = rhs
End Property
' propiedades privadas
' funciones publicas
Public Function GetInfo() As Collection
  Dim dbinf As cDataBaseInfo
  Dim k As Integer
  
  If Not m_InfoLoaded Then
  
    With m_Connection.Server.Databases(m_Name)
      Set dbinf = New cDataBaseInfo
      dbinf.Value = .Name
      dbinf.Name = "Nombre"
      m_dbInfo.Add dbinf
      Set dbinf = New cDataBaseInfo
      dbinf.Value = .Tables.Count
      dbinf.Name = "Tablas"
      m_dbInfo.Add dbinf
      Set dbinf = New cDataBaseInfo
      dbinf.Value = .StoredProcedures.Count
      dbinf.Name = "Stored Procedures"
      m_dbInfo.Add dbinf
      Set dbinf = New cDataBaseInfo
      dbinf.Value = .CompatibilityLevel
      dbinf.Name = "Nivel de compatibilidad"
      m_dbInfo.Add dbinf
      Set dbinf = New cDataBaseInfo
      dbinf.Value = .CreateDate
      dbinf.Name = "Fecha de creación"
      m_dbInfo.Add dbinf
      Set dbinf = New cDataBaseInfo
      dbinf.Value = ConvertToMB(.DataSpaceUsage)
      dbinf.Name = "Espacio usado para datos"
      m_dbInfo.Add dbinf
      Set dbinf = New cDataBaseInfo
      dbinf.Value = ConvertToMB(.IndexSpaceUsage)
      dbinf.Name = "Espacio usado para indices"
      m_dbInfo.Add dbinf
      Set dbinf = New cDataBaseInfo
      dbinf.Value = .IsFullTextEnabled
      dbinf.Name = "Full Text habilitado"
      m_dbInfo.Add dbinf
      Set dbinf = New cDataBaseInfo
      dbinf.Value = .Owner
      dbinf.Name = "Propietario"
      m_dbInfo.Add dbinf
      Set dbinf = New cDataBaseInfo
      dbinf.Value = .PrimaryFilePath
      dbinf.Name = "Path data"
      m_dbInfo.Add dbinf
      Set dbinf = New cDataBaseInfo
      dbinf.Value = ConvertToMB2(.SpaceAvailableInMB)
      dbinf.Name = "Espacio libre"
      m_dbInfo.Add dbinf
      Set dbinf = New cDataBaseInfo
      dbinf.Value = GetStatusString(.Status)
      dbinf.Name = "Estado"
      m_dbInfo.Add dbinf
      Set dbinf = New cDataBaseInfo
      dbinf.Value = ConvertToMB2(.TransactionLog.SpaceAvailableInMB)
      dbinf.Name = "Espacio libre en log"
      m_dbInfo.Add dbinf
      Set dbinf = New cDataBaseInfo
      dbinf.Value = ConvertToMB(.TransactionLog.SpaceAllocatedOnFiles(m_Name) + .SpaceAvailable + .DataSpaceUsage + .IndexSpaceUsage)
      dbinf.Name = "Espacio Total"
      m_dbInfo.Add dbinf
      Set dbinf = New cDataBaseInfo
      dbinf.Value = ConvertToMB(.TransactionLog.SpaceAllocatedOnFiles(m_Name))
      dbinf.Name = "Espacio usuado en log"
      m_dbInfo.Add dbinf
      
      For k = 1 To .FileGroups.Count
        Set dbinf = New cDataBaseInfo
        dbinf.Value = .FileGroups(k).Name
        dbinf.Name = "File Group (" & k & ")"
        m_dbInfo.Add dbinf
      Next
      
      m_InfoLoaded = True
    End With
  End If
  Set GetInfo = m_dbInfo
End Function
' funciones friend
' funciones privadas
Private Function ConvertToMB(ByVal Size As Single) As String
  ConvertToMB = Format(Size / 1024, "#,###,##0.00") & " MB"
End Function

Private Function ConvertToMB2(ByVal Size As Single) As String
  ConvertToMB2 = Format(Size, "#,###,##0.00") & " MB"
End Function

Private Function GetStatusString(ByVal Status As SQLDMO_DBSTATUS_TYPE) As String
  If Status = SQLDMO_DBSTATUS_TYPE.SQLDMODBStat_Suspect Then
    GetStatusString = "Suspect"
  ElseIf Status = SQLDMO_DBSTATUS_TYPE.SQLDMODBStat_EmergencyMode Then
    GetStatusString = "Emergency mode"
  ElseIf Status = SQLDMO_DBSTATUS_TYPE.SQLDMODBStat_Inaccessible Then
    GetStatusString = "Inaccessible"
  ElseIf Status = SQLDMO_DBSTATUS_TYPE.SQLDMODBStat_Loading Then
    GetStatusString = "Loading"
  ElseIf Status = SQLDMO_DBSTATUS_TYPE.SQLDMODBStat_Normal Then
    GetStatusString = "Normal"
  ElseIf Status = SQLDMO_DBSTATUS_TYPE.SQLDMODBStat_Offline Then
    GetStatusString = "Offline"
  ElseIf Status = SQLDMO_DBSTATUS_TYPE.SQLDMODBStat_Recovering Then
    GetStatusString = "Recovering"
  ElseIf Status = SQLDMO_DBSTATUS_TYPE.SQLDMODBStat_Standby Then
    GetStatusString = "Standby"
  End If
End Function
' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  Set m_Tables = New cTables
  Set m_Views = New cViews
  Set m_Procedures = New cProcedures
  Set m_dbInfo = New Collection
  
  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
  On Error GoTo ControlError

  Set m_Tables = Nothing
  Set m_Views = Nothing
  Set m_Procedures = Nothing
  Set m_dbInfo = Nothing
  
  GoTo ExitProc
ControlError:
  MngError Err, "Class_Terminate", C_Module, ""
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


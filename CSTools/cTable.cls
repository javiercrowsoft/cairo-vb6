VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cTable"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cTable
' 15-09-2001

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cTable"
' estructuras
' variables privadas
Private m_Name                          As String
Private m_Columns                       As cColumns
Private m_Triggers                      As cTriggers
Private m_Indexes                       As cIndexes
Private m_TblType                       As csTblType
Private m_CreateDate                    As String
' eventos
' propiedadades publicas
Public Property Get Name() As String
   Name = m_Name
End Property

Public Property Let Name(ByVal rhs As String)
   m_Name = rhs
End Property

Public Property Get TblType() As csTblType
   TblType = m_TblType
End Property

Public Property Let TblType(ByVal rhs As csTblType)
   m_TblType = rhs
End Property

Public Property Get Columns() As cColumns
   Set Columns = m_Columns
End Property

Public Property Set Columns(ByVal rhs As cColumns)
   Set m_Columns = rhs
End Property

Public Property Get Triggers() As cTriggers
   Set Triggers = m_Triggers
End Property

Public Property Set Triggers(ByVal rhs As cTriggers)
   Set m_Triggers = rhs
End Property

Public Property Get Indexes() As cIndexes
   Set Indexes = m_Indexes
End Property

Public Property Set Indexes(ByVal rhs As cIndexes)
   Set m_Indexes = rhs
End Property

Public Property Get CreateDate() As String
   CreateDate = m_CreateDate
End Property

Public Property Let CreateDate(ByVal rhs As String)
   m_CreateDate = rhs
End Property

' propiedadades friend
' propiedades privadas
' funciones publicas
Public Sub GetColumns(ByRef Conn As cConnection, ByVal DbName As String)
  Dim Db    As SQLDMO.Database
  Dim i     As Integer
  Dim c     As cColumn
  
  m_Columns.Clear
  
  Conn.Server.DisConnect
  Conn.Server.ReConnect
  
  Set Db = Conn.Server.Databases(DbName)
  Db.Tables.Refresh
  Db.Tables(m_Name).Columns.Refresh
  
  With Db.Tables(m_Name).Columns
    For i = 1 To .Count
      With .Item(i)
        Set c = m_Columns.Add(Nothing, .Name)
        c.Name = .Name
        c.SqlType = .Datatype
        Select Case .PhysicalDatatype
          Case "decimal", "numeric"
            c.Size = .NumericPrecision & .NumericScale
          Case "char", "nchar", "ntext", "nvarchar", "text", "varchar"
            c.Size = .length
          Case Else ' "datetime", "image", "money", "smallint", "int", "bit", "timestamp", "uniqueidentifier", "varbinary", "real", "smalldatetime", "smallint", "smallmoney", "sql_variant"
            c.Size = 1
        End Select
        
        c.NumericPresicion = .NumericPrecision
        c.NumericScale = .NumericScale
        
        c.AllowNull = .AllowNulls
        c.InPrimaryKey = .InPrimaryKey
        c.Default = .DRIDefault.Text
        c.DefaultName = .DRIDefault.Name
      End With
    Next
  End With
End Sub

Public Sub GetIndexes(ByRef Conn As cConnection, ByVal DbName As String)
  Dim Db    As SQLDMO.Database
  Dim i     As Integer
  Dim c     As cIndexes
  
  m_Indexes.Clear
  
  Conn.Server.DisConnect
  Conn.Server.ReConnect
  
  Set Db = Conn.Server.Databases(DbName)
  Db.Tables.Refresh
  Db.Tables(m_Name).Columns.Refresh
  
  Dim Idx   As cIndex
  Dim j     As Long
  Dim q     As Long
  Dim List  As Object
  Dim Obj   As Object
  
  With Db.Tables(m_Name)
    For j = 1 To .Indexes.Count
      Set Idx = m_Indexes.Add(Nothing)
      With .Indexes(j)
        Idx.Name = .Name
        Idx.IndexType = .Type
        Set List = .ListIndexedColumns
        
        For q = 1 To List.Count
          Set Obj = List(q)
          Idx.IndexedColumns.Add(Nothing).Name = Obj.Name
        Next
      End With
    Next
  End With
End Sub


' funciones friend
' funciones privadas
' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  Set m_Columns = New cColumns
  Set m_Triggers = New cTriggers
  Set m_Indexes = New cIndexes

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
  On Error GoTo ControlError

  Set m_Columns = Nothing
  Set m_Triggers = Nothing
  Set m_Indexes = Nothing
  
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



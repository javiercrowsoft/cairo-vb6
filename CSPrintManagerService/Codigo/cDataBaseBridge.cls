VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cDataBaseBridge"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Public Enum csDataType
  csTDChar = adChar
  csTDVarChar = adVarChar
  csTDLongVarChar = adLongVarChar
  csTDLongVarWChar = adLongVarWChar
  csTDWChar = adWChar
  csTDVarWChar = adVarWChar
  csTDDecimal = adDecimal
  csTDNumeric = adNumeric
  csTDDouble = adDouble
  csTDSingle = adSingle
  csTDCurrency = adCurrency
  csTDInteger = adInteger
  csTDBigInt = adBigInt
  csTDSmallInt = adSmallInt
  csTDTinyInt = adTinyInt
  csTDUnsignedTinyInt = adUnsignedTinyInt
  csTDDBTime = adDBTime
  csTDDBTimeStamp = adDBTimeStamp
  csTDDBDate = adDBDate
  csTDDate = adDate
  csTDBoolean = adBoolean
  csTDBinary = adBinary
  csTDLongVarBinary = adLongVarBinary
End Enum

Public Enum csTypeCursor
  csRsDynamic = CursorTypeEnum.adOpenDynamic
  csRsFast = CursorTypeEnum.adOpenForwardOnly
  csRsKeySet = CursorTypeEnum.adOpenKeyset
  csRsStatic = CursorTypeEnum.adOpenStatic
End Enum

Public Enum csTypeLock
  csLockOptimistic = LockTypeEnum.adLockOptimistic
  csLockGrpOptimistic = LockTypeEnum.adLockBatchOptimistic
  csLockPessimistic = LockTypeEnum.adLockPessimistic
  csLockReadOnly = LockTypeEnum.adLockReadOnly
End Enum

Public Enum csCommandType
  csCmdFile = CommandTypeEnum.adCmdFile
  csCmdSp = CommandTypeEnum.adCmdStoredProc
  csCmdTable = CommandTypeEnum.adCmdTable
  csCmdTableDirect = CommandTypeEnum.adCmdTableDirect
  csCmdText = CommandTypeEnum.adCmdText
  csCmdUnknown = CommandTypeEnum.adCmdUnknown
End Enum

Public Function OpenRs(ByVal sqlstmt As String, _
                       ByRef rs As ADODB.Recordset, _
                       Optional ByVal cursorType As csTypeCursor = csRsStatic, _
                       Optional ByVal lockType As csTypeLock = csLockGrpOptimistic, _
                       Optional ByVal nOptiones As csCommandType = csCmdUnknown, _
                       Optional ByVal FunctionName As String = "", _
                       Optional ByVal Module As String = "", _
                       Optional ByVal Title As String = "Error", _
                       Optional ByVal Level As Integer) As Boolean
  OpenRs = fMain.Db.OpenRs(rs, sqlstmt)
End Function

Public Function ValField(ByVal fields As ADODB.fields, ByVal field As String) As Variant
  ValField = fMain.Db.ValField(fields.Item(field))
End Function

Public Function sqlString(ByVal value As String) As String
  sqlString = fMain.Db.sqlString(value)
End Function

Public Function sqlDate(ByVal value As String) As String
    sqlDate = fMain.Db.sqlDate(value)
End Function

Public Function Execute(ByVal sqlstmt As String) As Boolean
  Execute = fMain.Db.Execute(sqlstmt, "")
End Function

Public Property Get StrConnect() As String
  StrConnect = fMain.Db.ConnectString
End Property

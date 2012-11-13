VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cWebReportParams"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cWebReportParams
' 23-04-04

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "CSWebReport.cWebReportParams"
Private Const KEY_NODO = "N"
' estructuras
' variables privadas
Private m_Coll      As Collection
' eventos
' propiedades publicas
' propiedades privadas
' funciones publicas
Public Function Load(ByVal RptId As Long) As Boolean
  Dim db            As cDBHelper
  Dim rs            As ADODB.Recordset
  Dim Value         As String
  Dim Visible       As Boolean
  Dim oDate         As CSWebReport.cDate
  Dim spHelp        As String
  Dim Param         As cWebReportParam

  Set oDate = New CSWebReport.cDate
  
  Set db = CreateObject("CSWebDataBase.cDBHelper")
  
  Set rs = db.RunSPReturnRS("sp_Web_ReportsGetParams", _
                            mp("@@rpt_id", adInteger, 4, RptId))
  CollClear m_Coll

  While Not rs.EOF
    
    If IsNull(rs.Fields(cscRptpValor)) Then
      Value = ValField(rs.Fields, cscInfpDefault)
    Else
      Value = ValField(rs.Fields, cscRptpValor)
    End If
    
    If IsNull(rs.Fields(cscRptpVisible)) Then
      Visible = ValField(rs.Fields, cscRptpVisible)
    Else
      Visible = ValField(rs.Fields, cscInfpVisible)
    End If
    
    Set Param = Add(Nothing)
    With Param
      .Name = ValField(rs.Fields, cscInfpNombre)
      .Caption = ValField(rs.Fields, cscInfpNombre)
      .ValueType = pGetValueType(ValField(rs.Fields, cscInfpTipo))
      .DefaultValue = Value
      .Table = ValField(rs.Fields, cscTblId)
      .DataFillFunction = ""
      .DataSourceFunction = ValField(rs.Fields, cscInfpSqlstmt)
      .AllowEdit = IIf(Visible, "True", "False")
      .AllowAll = True
      
      If ValField(rs.Fields, cscInfpTipo) = csInfParamHelp Then
        pGetHelpValue Param
      End If
      
      If ValField(rs.Fields, cscInfpTipo) = csInfParamDate And Not IsDate(.DefaultValue) Then
        If oDate.DateNames(Value) Is Nothing Then
          .DefaultValue = oDate.VDGetDateById(csToday)
        Else
          .DefaultValue = oDate.DateNames(Value).Value
        End If
      End If
      
      spHelp = ValField(rs.Fields, cscTblId)
      If Val(spHelp) <> 0 Then
        spHelp = "sp_Web_GetHelp " & spHelp
      Else
        spHelp = ""
      End If
      .nOption = spHelp
    End With
    
    rs.MoveNext
  Wend

  GetObjectContext.SetComplete
  Load = True
  Exit Function
      
ControlError:
  CtxRaiseError C_Module, "Load"
End Function

Public Function Add(ByVal o As cWebReportParam, Optional Key As Variant) As cWebReportParam
  On Error GoTo ControlError

  If o Is Nothing Then Set o = New cWebReportParam

  If IsMissing(Key) Then
    m_Coll.Add o
  Else
    m_Coll.Add o, GetKey(Key)
  End If
  
  Dim Col As cWebReportParam
  Set Col = o
  Col.Index = m_Coll.Count

  Set Add = o
  Exit Function
ControlError:
  Set Add = Nothing

End Function

Public Sub Clear()
  CollClear m_Coll
End Sub

Public Function Count() As Long
  Count = m_Coll.Count
End Function

Public Function Item(ByVal kItem As Variant) As cWebReportParam
Attribute Item.VB_UserMemId = 0
  On Error GoTo ControlError
  If Not IsNumeric(kItem) Then kItem = GetKey(kItem)
  Set Item = m_Coll(kItem)
  Exit Function
ControlError:
End Function

Public Function NewEnum() As stdole.IUnknown
Attribute NewEnum.VB_UserMemId = -4
  Set NewEnum = m_Coll.[_NewEnum]
End Function

Public Sub Remove(ByVal kItem As Variant)
  m_Coll.Remove kItem
End Sub

' funciones privadas
Private Function pGetNombreRama(ByVal Tbl_id As Long, ByVal Ram_ID As Long, ByRef bExists As Boolean) As String
  Dim Sqlstmt As String
  Dim rs      As Recordset
  Dim db      As cDBHelper
  
  Set db = CreateObject("CSWebDataBase.cDBHelper")
  
  Set rs = db.RunSPReturnRS("sp_Web_ReportsGetRama", _
                            mp("@@ram_id", adInteger, 4, Ram_ID), _
                            mp("@@tbl_id", adInteger, 4, Tbl_id))
 
  If rs.EOF Then Exit Function
  
  bExists = True
  
  pGetNombreRama = ValField(rs.Fields, cscRamNombre)
End Function

Private Function pGetHelpValue(ByRef Param As cWebReportParam) As String
  Dim Value       As String
  Dim bExists     As Boolean
  Dim tblName     As String
  Dim tblCampo    As String
  Dim tblCampoId  As String
  Dim db          As cDBHelper
  
  Set db = CreateObject("CSWebDataBase.cDBHelper")
  
  Param.DefaultValueID = Param.DefaultValue
  
  Value = ""
  If UCase(Left$(Param.DefaultValueID, 1)) = KEY_NODO Then
    Value = pGetNombreRama(Param.Table, Val(Mid(Param.DefaultValueID, 2)), bExists)
    If Not bExists Then Param.DefaultValueID = "0"
  Else
    If Val(Param.DefaultValueID) <> 0 Then
      pGetTblData Param.Table, tblName, tblCampo, tblCampoId
      db.GetDataWithCondition tblName, tblCampo, tblCampoId & "=" & Param.DefaultValueID, Value, bExists
      If Not bExists Then Param.DefaultValueID = "0"
    End If
  End If
  Param.DefaultValue = Value
End Function

Private Sub pGetTblData(ByVal Tbl_id As Long, ByRef tblName As String, ByRef tblCampo As String, ByRef tblCampoId As String)
  Dim rs      As Recordset
  Dim db      As cDBHelper
  
  tblName = ""
  tblCampo = ""
  tblCampoId = ""
  
  Set db = CreateObject("CSWebDataBase.cDBHelper")
  
  Set rs = db.RunSPReturnRS("sp_Web_ReportsGetTblData", _
                            mp("@@tbl_id", adInteger, 4, Tbl_id))
  
  If Not rs.EOF Then
    tblName = ValField(rs.Fields, "tbl_nombrefisico")
    tblCampo = ValField(rs.Fields, "tbl_camponombre")
    tblCampoId = ValField(rs.Fields, "tbl_campoid")
  End If
End Sub

Private Function pGetValueType(ByVal InfTipo As csEInfParamType) As String
  Select Case InfTipo
    Case csInfParamDate
      pGetValueType = "date"
    Case csInfParamHelp
      pGetValueType = "help"
    Case csInfParamNumeric
      pGetValueType = "text"
    Case csInfParamSqlstmt
      pGetValueType = "listbox"
    Case csInfParamText
      pGetValueType = "text"
    Case csInfParamList
      pGetValueType = "listbox"
    Case csInfParamCheck
      pGetValueType = "boolean"
  End Select
End Function

' construccion - destruccion
Private Sub Class_Initialize()
  Set m_Coll = New Collection
End Sub

Private Sub Class_Terminate()
  CollClear m_Coll
  Set m_Coll = Nothing
End Sub

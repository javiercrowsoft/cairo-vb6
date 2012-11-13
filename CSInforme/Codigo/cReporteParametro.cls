VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cReporteParametro"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGeneric
Implements CSInterfacesABM.cIABMClient
'--------------------------------------------------------------------------------
' cReporteParametro
' 04-10-03

'--------------------------------------------------------------------------------
' notas:

' rptp          reemplazar por el prefijo de la tabla (ej pro)
' ReporteParametro           reemplazar por el nombre de la tabla (ej Provincia)
' cReporteParametro           reemplazar por el nombre de la clase (ej cProvincia)
' Parametros         reemplazar por el nombre logico del abm (ej Provincias)
' PreI     reemplazar por el prefijo de las prestaciones (ej PreG)
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cReporteParametro"

Private Const K_VALOR                          As Integer = 1
Private Const K_VISIBLE                        As Integer = 2
Private Const K_RPT_ID                         As Integer = 3
Private Const K_INFP_ID                        As Integer = 4
' estructuras
' variables privadas
Private m_Id                           As Long
Private m_Valor                        As String
Private m_Rpt_id                       As Long
Private m_Reporte                      As String
Private m_Visible                      As Boolean

Private m_Infp_id                      As Long
Private m_InformeParametro             As String
Private m_Creado                       As Date
Private m_Modificado                   As Date
Private m_Modifico                     As Long

'OJO HASTA ACA

Private m_Editing           As Boolean

Private m_ObjAbm            As cIABMGeneric
Private m_ObjTree           As Object

Private m_IsNew             As Boolean

Private m_BranchId          As Long
Private m_TreeId            As Long

' Properties publicas
Public Property Get Id() As Long
  Id = m_Id
End Property

Public Property Let Id(ByVal rhs As Long)
  m_Id = rhs
End Property

Public Property Get Valor() As String
  Valor = m_Valor
End Property

Public Property Let Valor(ByVal rhs As String)
  m_Valor = rhs
End Property

Public Property Get Rpt_id() As Long
  Rpt_id = m_Rpt_id
End Property

Public Property Let Rpt_id(ByVal rhs As Long)
  m_Rpt_id = rhs
End Property

Public Property Get Reporte() As String
  Reporte = m_Reporte
End Property

Public Property Let Reporte(ByVal rhs As String)
  m_Reporte = rhs
End Property

Public Property Get Infp_id() As Long
  Infp_id = m_Infp_id
End Property

Public Property Let Infp_id(ByVal rhs As Long)
  m_Infp_id = rhs
End Property

Public Property Get InformeParametro() As String
  InformeParametro = m_InformeParametro
End Property

Public Property Let InformeParametro(ByVal rhs As String)
  m_InformeParametro = rhs
End Property

Public Property Get Visible() As Boolean
  Visible = m_Visible
End Property

Public Property Let Visible(ByVal rhs As Boolean)
  m_Visible = rhs
End Property

Public Property Get Creado() As Date
  Creado = m_Creado
End Property

Public Property Let Creado(ByVal rhs As Date)
  m_Creado = rhs
End Property

Public Property Get Modificado() As Date
  Modificado = m_Modificado
End Property

Public Property Let Modificado(ByVal rhs As Date)
  m_Modificado = rhs
End Property

Public Property Get Modifico() As Long
  Modifico = m_Modifico
End Property

Public Property Let Modifico(ByVal rhs As Long)
  m_Modifico = rhs
End Property

' Properties privadas
' funciones publicas


' Implementacion de cIABMClient
Private Property Get cIABMClient_Aplication() As String
    cIABMClient_Aplication = gAppName
End Property

Private Property Get cIABMClient_CanAddDocDigital() As Boolean
  cIABMClient_CanAddDocDigital = False
End Property

Private Property Get cIABMClient_CanCopy() As Boolean
  cIABMClient_CanCopy = False
End Property

Private Property Get cIABMClient_CanNew() As Boolean
  cIABMClient_CanNew = False
End Property

Private Function cIABMClient_ShowDocDigital() As Boolean
  cIABMClient_ShowDocDigital = False
End Function

Private Function cIABMClient_MessageEx(ByVal MessageID As Long, ByVal Info As Variant) As Variant
  cIABMClient_MessageEx = True
End Function

Private Function cIABMClient_Copy() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True
  m_Copy = True
End Function

Private Sub cIABMClient_DiscardChanges()
    LoadCollection
End Sub

Private Function cIABMClient_EditNew() As Boolean

  cIABMClient_Terminate
  m_IsNew = True
  
  cIEditGeneric_Edit csNO_ID
End Function

Private Function cIABMClient_ListAdHock(List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClient_Load()

End Sub

Private Function cIABMClient_PropertyChange(ByVal Key As Integer) As Boolean

End Function

Private Function cIABMClient_Save() As Boolean
  Dim register As cRegister
  Set register = New cRegister
  register.fieldId = cscRptpId
  register.Table = csTReporteParametro
  register.Id = m_Id
  Dim IProperty As cIABMProperty
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_VALOR
          register.Fields.Add2 cscRptpValor, .Value, csText
        Case K_RPT_ID
          register.Fields.Add2 cscRptId, .HelpId, csId
        Case K_VISIBLE
          register.Fields.Add2 cscRptpVisible, .Value, csBoolean
        Case K_INFP_ID
          register.Fields.Add2 cscInfpId, .HelpId, csId

      End Select
    End With
  Next
  register.Fields.HaveLastUpdate = True
  register.Fields.HaveWhoModify = True
  If Not gDB.Save(register, , "cIABMClient_Save", "cReporteParametro", "Error al grabar ReporteParametro") Then Exit Function
  cIABMClient_Save = Load(register.Id)
End Function

Private Function cIABMClient_Terminate() As Boolean
    m_Editing = False
    
    cIABMClient_Terminate = True
    ' Este objeto puede no cumplir con la interfaz esperada, asi que si hay un error no
    ' le doy bola
    On Error GoTo ControlError
    If m_Id = csNO_ID Then Exit Function
    If m_ObjTree Is Nothing Then Exit Function
    
    If m_IsNew Then
        m_ObjTree.AddLeave m_Id, m_BranchId, m_TreeId
    Else
        m_ObjTree.AddEditedId m_Id
        m_ObjTree.RefreshActiveBranch
    End If
ControlError:
End Function

Private Property Get cIABMClient_Title() As String
    cIABMClient_Title = "Parametros"
End Property

Private Function cIABMClient_Validate() As Boolean

  Dim IProperty As cIABMProperty

  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_VALOR
          If ValEmpty(.Value, csText) Then
            MsgInfo "Debe indicar un valor"
            Exit Function
          End If
        Case K_RPT_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo "Debe indicar un rpt_id"
            Exit Function
          End If
        Case K_INFP_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo "Debe indicar un infp_id"
            Exit Function
          End If

      End Select
    End With
  Next

  cIABMClient_Validate = True
End Function

Private Function cIEditGeneric_Edit(Id As Long, Optional ByVal InModalWindow As Boolean) As Boolean
    On Error GoTo ControlError
    
    If Id = csNO_ID Then
        m_IsNew = True
        If Not SecurityCanAccess(csPreINewReporteParametro) Then Exit Function
    Else
        m_IsNew = False
        If Not SecurityCanAccess(csPreIEditReporteParametro) Then Exit Function
    End If

    If Not Load(Id) Then Exit Function
    
    If Not LoadCollection() Then Exit Function
    
    m_Editing = True
    cIEditGeneric_Edit = True
    Exit Function
ControlError:
    MngError Err, "cIEditGeneric_Edit", "cReporteParametro", ""
End Function

' Implementacion de cIEditGeneric

Private Function cIEditGeneric_TabClick(ByVal Index As Integer) As Boolean

End Function

Private Property Let cIEditGeneric_TreeId(ByVal rhs As Long)
    m_TreeId = rhs
End Property

Private Property Get cIEditGeneric_TreeId() As Long
    cIEditGeneric_TreeId = m_TreeId
End Property

Private Function cIEditGeneric_GridAdd(ByVal KeyProperty As Integer) As Boolean

End Function

Private Function cIEditGeneric_GridEdit(ByVal KeyProperty As Integer) As Boolean

End Function

Private Function cIEditGeneric_GridRemove(ByVal KeyProperty As Integer) As Boolean

End Function

Private Function cIEditGeneric_ShowList() As Boolean
    cIEditGeneric_ShowList = SecurityCanAccess(csPreIListReporteParametro)
End Function

Private Property Get cIEditGeneric_ObjAbm() As CSInterfacesABM.cIABMGeneric
  Set cIEditGeneric_ObjAbm = m_ObjAbm
End Property

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
    Set m_ObjAbm = rhs
End Property

Private Property Get cIEditGeneric_Editing() As Boolean
    cIEditGeneric_Editing = m_Editing
End Property

Private Function cIEditGeneric_Delete(Id As Long) As Boolean
    If Not SecurityCanAccess(csPreIDeleteReporteParametro) Then Exit Function

    Dim sqlstmt As String
    
    sqlstmt = "Delete " & csTReporteParametro & " where " & cscRptpId & " = " & Id
    
    cIEditGeneric_Delete = gDB.Execute(sqlstmt, "cIEditGeneric_Delete", "cReporteParametro")
End Function

Private Function cIEditGeneric_Search(Id As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_PrintObj(ByVal Id As Long) As Boolean

End Function

Private Property Set cIEditGeneric_ObjTree(rhs As Object)
    Set m_ObjTree = rhs
End Property

Private Property Let cIEditGeneric_BranchId(ByVal rhs As Long)
    m_BranchId = rhs
End Property

Private Property Get cIEditGeneric_BranchId() As Long
    cIEditGeneric_BranchId = m_BranchId
End Property

Private Function cIEditGeneric_Preview(ByVal Id As Long) As Boolean

End Function

Private Function cIEditGeneric_PropertyChange(ByVal Key As Integer) As Boolean

End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  m_ObjAbm.Properties.Clear
  
  Dim c As cIABMProperty
  

  Set c = m_ObjAbm.Properties.Add(Nothing, cscRptpValor)
  c.PropertyType = cspText
  c.Name = "Valor"
  c.Size = 255
  c.Key = K_VALOR
  c.Value = Valor
  
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscRptpVisible)
  c.PropertyType = cspCheck
  c.Name = "Visible"
  c.Key = K_VISIBLE
  c.Value = CInt(m_Visible)
  
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

Private Function Load(ByVal Id As Long) As Boolean

  Dim sqlstmt As String

  sqlstmt = "select reporteparametro.*,infp_nombre, rpt_nombre"
  sqlstmt = sqlstmt & " from ReporteParametro, InformeParametro, Reporte"
  sqlstmt = sqlstmt & " where ReporteParametro.rpt_id = Reporte.rpt_id"
  sqlstmt = sqlstmt & " and ReporteParametro.infp_id = InformeParametro.infp_id"
  sqlstmt = sqlstmt & " and rptp_id = " & Id

  Dim rs As Recordset

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "Load", "cReporteParametro") Then Exit Function

  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.Fields, cscRptpId)
    m_Valor = gDB.ValField(rs.Fields, cscRptpValor)
    m_Rpt_id = gDB.ValField(rs.Fields, cscRptId)
    m_Infp_id = gDB.ValField(rs.Fields, cscInfpId)
    m_InformeParametro = gDB.ValField(rs.Fields, cscInfpNombre)
    m_Reporte = gDB.ValField(rs.Fields, cscRptNombre)
    m_Visible = gDB.ValField(rs.Fields, cscRptpVisible)
    m_Creado = gDB.ValField(rs.Fields, cscCreado)
    m_Modificado = gDB.ValField(rs.Fields, cscModificado)
    m_Modifico = gDB.ValField(rs.Fields, cscModifico)

  Else
    m_Id = csNO_ID
    m_Valor = ""
    m_Rpt_id = csNO_ID
    m_Infp_id = csNO_ID
    m_Visible = False
    m_InformeParametro = ""
    m_Reporte = ""
    m_Creado = csNoDate
    m_Modificado = csNoDate
    m_Modifico = 0

  End If

  Load = True
End Function
' construccion - destruccion


Private Sub Class_Terminate()
    Set m_ObjAbm = Nothing
    Set m_ObjTree = Nothing
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




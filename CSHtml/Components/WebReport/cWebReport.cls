VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 3  'UsesTransaction
END
Attribute VB_Name = "cWebReport"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cWebReport
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
Private Const C_Module = "CSWebReport.cWebReport"
' estructuras
' variables privadas
Private m_Name                          As String
Private m_Title                         As String
Private m_ShowGrandTotal                As String
Private m_Connstr                       As String
Private m_StoredProcedure               As String
Private m_ColsToHide                    As String
Private m_CheckBoxFieldName             As String
Private m_HyperlinkedFields             As cWebReportHiperLinks
Private m_Params                        As cWebReportParams
Private m_Groups                        As cWebReportGroups
Private m_Orders                        As cWebReportOrders
Private m_Sumaries                      As cWebReportSumaries
' eventos
' propiedades publicas
Public Property Get Name() As String
   Name = m_Name
End Property

Public Property Let Name(ByVal rhs As String)
   m_Name = rhs
End Property

Public Property Get Title() As String
   Title = m_Title
End Property

Public Property Let Title(ByVal rhs As String)
   m_Title = rhs
End Property

Public Property Get ShowGrandTotal() As String
   ShowGrandTotal = m_ShowGrandTotal
End Property

Public Property Let ShowGrandTotal(ByVal rhs As String)
   m_ShowGrandTotal = rhs
End Property

Public Property Get Connstr() As String
   Connstr = m_Connstr
End Property

Public Property Let Connstr(ByVal rhs As String)
   m_Connstr = rhs
End Property

Public Property Get StoredProcedure() As String
   StoredProcedure = m_StoredProcedure
End Property

Public Property Let StoredProcedure(ByVal rhs As String)
   m_StoredProcedure = rhs
End Property

Public Property Get ColsToHide() As String
   ColsToHide = m_ColsToHide
End Property

Public Property Let ColsToHide(ByVal rhs As String)
   m_ColsToHide = rhs
End Property

Public Property Get CheckBoxFieldName() As String
   CheckBoxFieldName = m_CheckBoxFieldName
End Property

Public Property Let CheckBoxFieldName(ByVal rhs As String)
   m_CheckBoxFieldName = rhs
End Property

Public Property Get HyperlinkedFields() As cWebReportHiperLinks
   Set HyperlinkedFields = m_HyperlinkedFields
End Property

Public Property Let HyperlinkedFields(ByVal rhs As cWebReportHiperLinks)
   Set m_HyperlinkedFields = rhs
End Property

Public Property Get Params() As cWebReportParams
   Set Params = m_Params
End Property

Public Property Set Params(ByRef rhs As cWebReportParams)
   Set m_Params = rhs
End Property

Public Property Get Groups() As cWebReportGroups
   Set Groups = m_Groups
End Property

Public Property Set Groups(ByRef rhs As cWebReportGroups)
   Set m_Groups = rhs
End Property

Public Property Get Orders() As cWebReportOrders
   Set Orders = m_Orders
End Property

Public Property Set Orders(ByRef rhs As cWebReportOrders)
   Set m_Orders = rhs
End Property

Public Property Get Sumaries() As cWebReportSumaries
   Set Sumaries = m_Sumaries
End Property

Public Property Set Sumaries(ByRef rhs As cWebReportSumaries)
   Set m_Sumaries = rhs
End Property
' propiedades friend
' propiedades privadas
' funciones publicas
Public Function Load(ByVal RptId As Long, ByVal us_id As Long) As Boolean
  If Not pLoad(RptId, us_id) Then Exit Function
  If Not m_Params.Load(RptId) Then Exit Function
  If Not m_Groups.Load(RptId) Then Exit Function
  If Not m_Orders.Load(RptId) Then Exit Function
  If Not m_Sumaries.Load(RptId) Then Exit Function
  If Not m_HyperlinkedFields.Load(RptId) Then Exit Function
  GetObjectContext.SetComplete
  Load = True
End Function
' funciones friend
' funciones privadas
Private Function pLoad(ByVal RptId As Long, ByVal us_id As Long) As Boolean
  Dim db            As cDBHelper
  Dim rs            As ADODB.Recordset
  
  Set db = CreateObject("CSWebDataBase.cDBHelper")
  
  Set rs = db.RunSPReturnRS("sp_Web_ReportGet", _
                            mp("@@us_id", adInteger, 4, us_id), _
                            mp("@@rpt_id", adInteger, 4, RptId))

  m_Name = ValField(rs.Fields, cscInfCodigo)
  m_Title = ValField(rs.Fields, cscInfNombre)
  m_ShowGrandTotal = ValField(rs.Fields, cscInfTotalesGrales)
  m_Connstr = ValField(rs.Fields, cscInfConnstr)
  m_StoredProcedure = ValField(rs.Fields, cscInfStoredProcedure)
  m_ColsToHide = ValField(rs.Fields, cscInfColOcultas)
  m_CheckBoxFieldName = ValField(rs.Fields, cscInfCheckBox)
  
  pLoad = True
End Function
' construccion - destruccion
Private Sub Class_Initialize()
  Set m_Params = New cWebReportParams
  Set m_Groups = New cWebReportGroups
  Set m_Orders = New cWebReportOrders
  Set m_Sumaries = New cWebReportSumaries
  Set m_HyperlinkedFields = New cWebReportHiperLinks
End Sub

VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cReportLaunchInfo"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cReportLaunchInfo
' 05-07-01

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const c_LaunchInfo = "RptLaunchInfo"
' estructuras
' variables privadas
Private m_File                          As String
Private m_DataSource                    As Object
Private m_Sqlstmt                       As String
Private m_StrConnect                    As String
Private m_PrinterObj                    As Printer
Private m_ShowPrintersDialog            As Boolean
Private m_InternalPreview               As Boolean
Private m_Accion                        As csRptLaunchAccion
Private m_Copies                        As Integer
Private m_Silent                        As Boolean
Private m_FileFormat                    As csRptFileFormat
#If Not NET Then
  Private m_ObjPaint                      As cIReportPrint
#Else
  Private m_ObjPaint                      As Object
#End If
' eventos
' propiedades publicas
Public Property Get File() As String
   File = m_File
End Property

Public Property Let File(ByVal rhs As String)
   m_File = rhs
End Property

Public Property Get DataSource() As Object
   Set DataSource = m_DataSource
End Property

Public Property Set DataSource(ByRef rhs As Object)
   Set m_DataSource = rhs
End Property

Public Property Get Sqlstmt() As String
   Sqlstmt = m_Sqlstmt
End Property

Public Property Let Sqlstmt(ByVal rhs As String)
   m_Sqlstmt = rhs
End Property

Public Property Get StrConnect() As String
   StrConnect = m_StrConnect
End Property

Public Property Let StrConnect(ByVal rhs As String)
   m_StrConnect = rhs
End Property

Public Property Get PrinterObj() As Object
   Set PrinterObj = m_PrinterObj
End Property

Public Property Set PrinterObj(ByRef rhs As Object)
   Set m_PrinterObj = rhs
End Property

Public Property Get ShowPrintersDialog() As Boolean
   ShowPrintersDialog = m_ShowPrintersDialog
End Property

Public Property Let ShowPrintersDialog(ByVal rhs As Boolean)
   m_ShowPrintersDialog = rhs
End Property

Public Property Get InternalPreview() As Boolean
   InternalPreview = m_InternalPreview
End Property

Public Property Let InternalPreview(ByVal rhs As Boolean)
   m_InternalPreview = rhs
End Property

Public Property Get Accion() As csRptLaunchAccion
   Accion = m_Accion
End Property

Public Property Let Accion(ByVal rhs As csRptLaunchAccion)
   m_Accion = rhs
End Property

Public Property Get Copies() As Integer
   Copies = m_Copies
End Property

Public Property Let Copies(ByVal rhs As Integer)
   m_Copies = rhs
End Property

Public Property Get Silent() As Boolean
   Silent = m_Silent
End Property

Public Property Let Silent(ByVal rhs As Boolean)
   m_Silent = rhs
End Property

Public Property Get FileFormat() As csRptFileFormat
   FileFormat = m_FileFormat
End Property

Public Property Let FileFormat(ByVal rhs As csRptFileFormat)
   m_FileFormat = rhs
End Property

#If Not NET Then
  Public Property Get ObjPaint() As cIReportPrint
#Else
  Public Property Get ObjPaint() As Object
#End If
   Set ObjPaint = m_ObjPaint
End Property

#If Not NET Then
  Public Property Set ObjPaint(ByRef rhs As cIReportPrint)
#Else
  Public Property Set ObjPaint(ByRef rhs As Object)
#End If

   Set m_ObjPaint = rhs
End Property
' propiedades privadas
' funciones publicas
' funciones privadas
' funciones friends
' funciones friend
Friend Function Load(ByRef xDoc As cXml, ByRef NodObj As Object) As Boolean
    
  m_StrConnect = xDoc.GetNodeProperty(NodObj, "StrConnect").Value
  m_Accion = xDoc.GetNodeProperty(NodObj, "Accion").Value
  m_Copies = xDoc.GetNodeProperty(NodObj, "Copies").Value
  m_File = xDoc.GetNodeProperty(NodObj, "File").Value
  m_FileFormat = xDoc.GetNodeProperty(NodObj, "FileFormat").Value
  m_InternalPreview = xDoc.GetNodeProperty(NodObj, "InternalPreview").Value
  m_ShowPrintersDialog = xDoc.GetNodeProperty(NodObj, "ShowPrintersDialog").Value
  m_Silent = xDoc.GetNodeProperty(NodObj, "Silent").Value
  m_Sqlstmt = xDoc.GetNodeProperty(NodObj, "Sqlstmt").Value
   
  Load = True
End Function

Friend Function Save(ByRef xDoc As cXml, ByRef NodeFather As Object) As Boolean
  Dim xProperty As cXmlProperty
  Dim NodObj    As Object
  
  Set xProperty = New cXmlProperty
  
  xProperty.Name = c_LaunchInfo
  
  If Not NodeFather Is Nothing Then
    Set NodObj = xDoc.AddNodeToNode(NodeFather, xProperty)
  Else
    Set NodObj = xDoc.AddNode(xProperty)
  End If
  
  xProperty.Name = "Accion"
  xProperty.Value = m_Accion
  xDoc.AddPropertyToNode NodObj, xProperty
  
  xProperty.Name = "Copies"
  xProperty.Value = m_Copies
  xDoc.AddPropertyToNode NodObj, xProperty
  
  xProperty.Name = "File"
  xProperty.Value = m_File
  xDoc.AddPropertyToNode NodObj, xProperty
  
  xProperty.Name = "FileFormat"
  xProperty.Value = m_FileFormat
  xDoc.AddPropertyToNode NodObj, xProperty
  
  xProperty.Name = "InternalPreview"
  xProperty.Value = m_InternalPreview
  xDoc.AddPropertyToNode NodObj, xProperty
  
  xProperty.Name = "ShowPrintersDialog"
  xProperty.Value = m_ShowPrintersDialog
  xDoc.AddPropertyToNode NodObj, xProperty
  
  xProperty.Name = "Silent"
  xProperty.Value = m_Silent
  xDoc.AddPropertyToNode NodObj, xProperty
  
  xProperty.Name = "Sqlstmt"
  xProperty.Value = m_Sqlstmt
  xDoc.AddPropertyToNode NodObj, xProperty
  
  xProperty.Name = "StrConnect"
  xProperty.Value = m_StrConnect
  xDoc.AddPropertyToNode NodObj, xProperty
  
  Save = True
End Function

' construccion - destruccion



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
Private Const c_LaunchInfo As String = "RptLaunchInfo"
' estructuras
' variables privadas
Private m_File                  As String
Private m_DataSource            As Object
Private m_Sqlstmt               As String
Private m_StrConnect            As String
Private m_Printer               As cPrinter
Private m_ShowPrintersDialog    As Boolean
Private m_InternalPreview       As Boolean
Private m_Action                As csRptLaunchAction
Private m_Copies                As Integer
Private m_Silent                As Boolean
Private m_FileFormat            As csRptFileFormat
Private m_hWnd                  As Long

Private m_ObjPaint As CSIReportPrint.cIReportPrint

' eventos
' propiedades publicas

Public Property Get hwnd() As Long
   hwnd = m_hWnd
End Property

Public Property Let hwnd(ByVal rhs As Long)
   m_hWnd = rhs
End Property

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

Public Property Get Printer() As cPrinter  'System.Drawing.Printing.PrinterSettings
  Set Printer = m_Printer
End Property

Public Property Set Printer(ByRef rhs As cPrinter)  'System.Drawing.Printing.PrinterSettings
  Set m_Printer = rhs
End Property

Public Property Get FileFormat() As csRptFileFormat
  FileFormat = m_FileFormat
End Property

Public Property Let FileFormat(ByVal rhs As csRptFileFormat)
  m_FileFormat = rhs
End Property

Public Property Get ObjPaint() As CSIReportPrint.cIReportPrint
  Set ObjPaint = m_ObjPaint
End Property

Public Property Set ObjPaint(ByRef rhs As CSIReportPrint.cIReportPrint)
  Set m_ObjPaint = rhs
End Property

Public Property Get Action() As csRptLaunchAction
  Action = m_Action
End Property

Public Property Let Action(ByVal rhs As csRptLaunchAction)
  m_Action = rhs
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

' propiedades privadas
' funciones publicas
Public Sub InitPrinter(ByVal DeviceName As String, ByVal DriverName As String, ByVal Port As String)
  Set m_Printer = GetcPrint(DeviceName, DriverName, Port)
End Sub

'--------------------------------------------------------------------
'
' Finalmente este funcion no sirvio para conocer el tamaño del
' papel que esta en una bandeja
' (Talvez en el futuro le encuentre la vuelta)

    'Public Function GetPaperSizeForPaperBin(ByVal PaperBin As String, ByVal PaperSize As Long) As Long
    '
    '  Dim OldPaperBin As Long
    '  Dim IdPaperBin  As Long
    '
    '  If LenB(PaperBin) Then
    '
    '    IdPaperBin = PrinterPaperBinNameToId(m_Printer.DeviceName, _
    '                                         m_Printer.Port, _
    '                                         PaperBin)
    '
    '    ' Pongo la bandeja como bandeja por defecto
    '
    '    OldPaperBin = PrinterSetPaperBin(m_Printer.DeviceName, IdPaperBin)
    '
    '    ' Averiguo el papel
    '    GetPaperSizeForPaperBin = GetPaperType(0&, m_Printer.DeviceName)
    '
    '    ' Reestablezco la bandeja
    '
    '    PrinterSetPaperBin m_Printer.DeviceName, OldPaperBin
    '
    '  Else
    '
    '    GetPaperSizeForPaperBin = PaperSize
    '
    '  End If
    'End Function

'
'--------------------------------------------------------------------

Public Sub SetPaperBin(ByVal PaperBin As String)
  If m_Printer Is Nothing Then Exit Sub
  
  If LenB(PaperBin) Then
    
    Dim IdPaperBin As Long
    IdPaperBin = PrinterPaperBinNameToId(m_Printer.DeviceName, m_Printer.Port, PaperBin)
    
    m_Printer.PaperInfo.PaperBin = IdPaperBin
  End If
End Sub
' funciones privadas
' funciones friends
' funciones friend
Friend Function Load(ByRef xDoc As CSXml2.cXml, ByRef NodObj As Object) As Boolean

  m_StrConnect = xDoc.GetNodeProperty(NodObj, "StrConnect").Value(csText)
  m_Action = xDoc.GetNodeProperty(NodObj, "Action").Value(csInteger)
  m_Copies = xDoc.GetNodeProperty(NodObj, "Copies").Value(csInteger)
  m_File = xDoc.GetNodeProperty(NodObj, "File").Value(csText)
  m_FileFormat = xDoc.GetNodeProperty(NodObj, "FileFormat").Value(csInteger)
  m_InternalPreview = xDoc.GetNodeProperty(NodObj, "InternalPreview").Value(csBoolean)
  m_ShowPrintersDialog = xDoc.GetNodeProperty(NodObj, "ShowPrintersDialog").Value(csBoolean)
  m_Silent = xDoc.GetNodeProperty(NodObj, "Silent").Value(csBoolean)
  m_Sqlstmt = xDoc.GetNodeProperty(NodObj, "Sqlstmt").Value(csText)

  Load = True
End Function

#If Not PREPROC_SFS Then
  Friend Function Save(ByRef xDoc As CSXml2.cXml, ByRef NodeFather As Object) As Boolean
    Dim xProperty As CSXml2.cXmlProperty
    Dim NodObj As Object
  
    Set xProperty = New CSXml2.cXmlProperty
  
    xProperty.Name = c_LaunchInfo
  
    If Not NodeFather Is Nothing Then
      Set NodObj = xDoc.AddNodeToNode(NodeFather, xProperty)
    Else
      Set NodObj = xDoc.AddNode(xProperty)
    End If
  
    xProperty.Name = "Action"
    xProperty.Value(csInteger) = m_Action
    xDoc.AddPropertyToNode NodObj, xProperty
  
    xProperty.Name = "Copies"
    xProperty.Value(csInteger) = m_Copies
    xDoc.AddPropertyToNode NodObj, xProperty
  
    xProperty.Name = "File"
    xProperty.Value(csText) = m_File
    xDoc.AddPropertyToNode NodObj, xProperty
  
    xProperty.Name = "FileFormat"
    xProperty.Value(csInteger) = m_FileFormat
    xDoc.AddPropertyToNode NodObj, xProperty
  
    xProperty.Name = "InternalPreview"
    xProperty.Value(csBoolean) = m_InternalPreview
    xDoc.AddPropertyToNode NodObj, xProperty
  
    xProperty.Name = "ShowPrintersDialog"
    xProperty.Value(csBoolean) = m_ShowPrintersDialog
    xDoc.AddPropertyToNode NodObj, xProperty
  
    xProperty.Name = "Silent"
    xProperty.Value(csBoolean) = m_Silent
    xDoc.AddPropertyToNode NodObj, xProperty
  
    xProperty.Name = "Sqlstmt"
    xProperty.Value(csText) = m_Sqlstmt
    xDoc.AddPropertyToNode NodObj, xProperty
  
    xProperty.Name = "StrConnect"
    xProperty.Value(csText) = m_StrConnect
    xDoc.AddPropertyToNode NodObj, xProperty
  
    Save = True
  End Function
#End If

' construccion - destruccion


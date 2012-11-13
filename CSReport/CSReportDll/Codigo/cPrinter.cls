VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cPrinter"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cWindow
' 25-08-2003

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cPrinter"
' estructuras
' variables privadas
Private m_DeviceName                    As String
Private m_DriverName                    As String
Private m_Port                          As String
Private m_PaperInfo                     As cReportPaperInfo
Private m_hDC                           As Long
Private m_hPrinter                      As Long
Private m_Copies                        As Long

Private m_bRestorePaperBin              As Boolean
Private m_OldPaperBin                   As Long

' eventos
' propiedades publicas
Public Property Get Copies() As Long
  Copies = m_Copies
End Property
Public Property Let Copies(ByVal rhs As Long)
  m_Copies = rhs
End Property
Public Property Get hDC() As Long
   hDC = m_hDC
End Property

Public Property Let hDC(ByVal rhs As Long)
   m_hDC = rhs
End Property

Public Property Get DeviceName() As String
   DeviceName = m_DeviceName
End Property

Public Property Let DeviceName(ByVal rhs As String)
   m_DeviceName = rhs
End Property

Public Property Get DriverName() As String
   DriverName = m_DriverName
End Property

Public Property Let DriverName(ByVal rhs As String)
   m_DriverName = rhs
End Property

Public Property Get Port() As String
   Port = m_Port
End Property

Public Property Let Port(ByVal rhs As String)
   m_Port = rhs
End Property

Public Property Get PaperInfo() As cReportPaperInfo
   Set PaperInfo = m_PaperInfo
End Property

Public Property Set PaperInfo(ByVal rhs As cReportPaperInfo)
   Set m_PaperInfo = rhs
End Property

' propiedades friend
' propiedades privadas
' funciones publicas
Public Function ShowDialog(ByVal hwnd As Long, ByVal Pages As Long) As Boolean
  Dim PaperSize       As Long
  Dim Orientation     As Long
  Dim FromPage        As Long
  Dim ToPage          As Long
  Dim PaperBin        As Long
  
  PaperSize = m_PaperInfo.PaperSize
  Orientation = m_PaperInfo.Orientation
  
  FromPage = 1
  ToPage = Pages
  
  ShowDialog = ShowPrintDialog(hwnd, m_DeviceName, m_DriverName, m_Port, _
                               PaperSize, Orientation, FromPage, ToPage, _
                               m_Copies, PaperBin)
  
  m_PaperInfo.PaperSize = PaperSize
  m_PaperInfo.Orientation = Orientation
  m_PaperInfo.PagesToPrint = FromPage & "-" & ToPage
  m_PaperInfo.PaperBin = PaperBin
End Function

Public Function StarDoc(ByVal Title As String, ByVal PaperSize As Long, ByVal PaperOrient As Long) As Boolean
  
  m_hDC = CreateDC(m_DriverName, m_DeviceName, 0&, 0&)
  
  If Not m_PaperInfo Is Nothing Then
    If m_PaperInfo.PaperBin Then
      
      m_OldPaperBin = PrinterSetPaperBin(m_DeviceName, m_PaperInfo.PaperBin)
      m_bRestorePaperBin = True
    
    End If
  End If
  
  PrinterSetSizeAndOrient m_DeviceName, PaperSize, PaperOrient, m_hDC

  Dim di As DOCINFO
  di.cbSize = Len(di)
  di.lpszDocName = Title
  
  If mPrintAPI.StartDoc(m_hDC, di) = 0 Then Exit Function

  StarDoc = True
End Function

Public Function EndDoc() As Boolean
  
  If m_hDC <> 0 Then
    EndDoc = mPrintAPI.EndDoc(m_hDC) <> 0
    DeleteDC m_hDC
    m_hDC = 0
  Else
    EndDoc = True
  End If

  If m_bRestorePaperBin Then
    m_bRestorePaperBin = False
    PrinterSetPaperBin m_DeviceName, m_OldPaperBin
  End If

End Function

Public Function StarPage() As Boolean
  StarPage = mPrintAPI.StartPage(m_hDC) <> 0
End Function

Public Function EndPage() As Boolean
  EndPage = mPrintAPI.EndPage(m_hDC) <> 0
End Function

' funciones friend
' funciones privadas
' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError

  Set m_PaperInfo = New cReportPaperInfo

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
  On Error GoTo ControlError
  
  Set m_PaperInfo = Nothing
  If m_hDC <> 0 Then DeleteDC m_hDC

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Terminate", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
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
'  If Err.Number Then Resume ExitProc
'ExitProc:
'  On Error Resume Next


Attribute VB_Name = "mPrintAPI"
Option Explicit

'--------------------------------------------------------------------------------
' mPrintAPI
' 25-09-2003

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
  ' constantes

    ' Constants for DEVMODE.
    Private Const CCHDEVICENAME = 32
    Private Const CCHFORMNAME = 32
    Private Const DC_PAPERS = 2
    
    ' Constants for DocumentProperties() call.
    Private Const DM_MODIFY = 8
    Private Const DM_IN_BUFFER = DM_MODIFY
    Private Const DM_COPY = 2
    Private Const DM_OUT_BUFFER = DM_COPY
    
    ' Constants for Orientation.
    Private Const DMORIENT_PORTRAIT = 1
    Private Const DMORIENT_LANDSCAPE = 2
    
    ' Constants for printer bin.
    Private Const DMBIN_UPPER = 1
    Private Const DMBIN_LOWER = 2
    
    ' Constants for DMFIELDS (which fields did you change?).
    Private Const DM_ORIENTATION = &H1
    Private Const DM_DEFAULTSOURCE = &H200
    Private Const DM_PAPERSIZE = &H2
    
    Private Const DC_BINS = 6
    Private Const DC_BINNAMES = 12
    
    ' Estructuras
    Public Type DOCINFO
        cbSize As Long
        lpszDocName As String
        lpszOutput As String
    End Type
    
    Private Type DEVMODE
        dmDeviceName(1 To CCHDEVICENAME) As Byte
        dmSpecVersion As Integer
        dmDriverVersion As Integer
        dmSize As Integer
        dmDriverExtra As Integer
        dmFields As Long
        dmOrientation As Integer
        dmPaperSize As Integer
        dmPaperLength As Integer
        dmPaperWidth As Integer
        dmScale As Integer
        dmCopies As Integer
        dmDefaultSource As Integer
        dmPrintQuality As Integer
        dmColor As Integer
        dmDuplex As Integer
        dmYResolution As Integer
        dmTTOption As Integer
        dmCollate As Integer
        dmFormName(1 To CCHFORMNAME) As Byte
        dmUnusedPadding As Integer
        dmBitsPerPel As Integer
        dmPelsWidth As Long
        dmPelsHeight As Long
        dmDisplayFlags As Long
        dmDisplayFrequency As Long
    End Type

    Private Type OSVERSIONINFO
      dwOSVersionInfoSize As Long
      dwMajorVersion As Long
      dwMinorVersion As Long
      dwBuildNumber As Long
      dwPlatformId As Long
      szCSDVersion As String * 128      '  Maintenance string for PSS usage
    End Type

    Private Type PRINTER_INFO_9
      pDevmode As Long ' Pointer to DEVMODE
    End Type

  ' funciones
  Private Declare Function GetLastError Lib "KERNEL32" () As Long
  Private Declare Sub CopyMemory Lib "KERNEL32" Alias "RtlMoveMemory" (hpvDest As Any, hpvSource As Any, ByVal cbCopy As Long)
  Private Declare Function PrinterProperties Lib "winspool.drv" (ByVal hwnd As Long, ByVal hPrinter As Long) As Long
  Private Declare Function DeviceCapabilities Lib "winspool.drv" Alias "DeviceCapabilitiesA" (ByVal lpDeviceName As String, ByVal lpPort As String, ByVal iIndex As Long, lpOutput As Any, lpDevMode As Any) As Long
  Private Declare Function GetProfileString Lib "kernel32.dll" Alias "GetProfileStringA" (ByVal lpAppName As String, ByVal lpKeyName As String, ByVal lpDefault As String, ByVal lpReturnedString As String, ByVal nSize As Long) As Long
  Private Declare Function DocumentProperties Lib "winspool.drv" Alias "DocumentPropertiesA" (ByVal hwnd As Long, ByVal hPrinter As Long, ByVal pDeviceName As String, pDevModeOutput As Any, pDevModeInput As Any, ByVal fMode As Long) As Long
  Private Declare Function ResetDC Lib "gdi32" Alias "ResetDCA" (ByVal hDC As Long, lpInitData As Any) As Long
  Private Declare Function TextOut Lib "gdi32" Alias "TextOutA" (ByVal hDC As Long, ByVal X As Long, ByVal Y As Long, ByVal lpString As String, ByVal nCount As Long) As Boolean
  Public Declare Function OpenPrinter Lib "winspool.drv" Alias "OpenPrinterA" (ByVal pPrinterName As String, phPrinter As Long, ByVal pDefault As Long) As Long
  Public Declare Function ClosePrinter Lib "winspool.drv" (ByVal hPrinter As Long) As Long
  Public Declare Function CreateDC Lib "gdi32" Alias "CreateDCA" (ByVal lpDriverName As String, ByVal lpDeviceName As String, ByVal lpOutput As Long, ByVal lpInitData As Long) As Long
  Public Declare Function DeleteDC Lib "gdi32" (ByVal hDC As Long) As Long
  Public Declare Function StartDoc Lib "gdi32" Alias "StartDocA" (ByVal hDC As Long, lpdi As DOCINFO) As Long
  Public Declare Function StartPage Lib "gdi32" (ByVal hDC As Long) As Long
  Public Declare Function EndDoc Lib "gdi32" (ByVal hDC As Long) As Long
  Public Declare Function EndPage Lib "gdi32" (ByVal hDC As Long) As Long
  Private Declare Function GetVersionEx Lib "KERNEL32" Alias "GetVersionExA" (lpVersionInformation As OSVERSIONINFO) As Long
  Private Declare Function SetPrinter Lib "winspool.drv" Alias "SetPrinterA" (ByVal hPrinter As Long, ByVal Level As Long, pPrinter As Any, ByVal Command As Long) As Long
  
'  Private Declare Function ImageList_DrawEx Lib "COMCTL32.DLL" (ByVal hIml As Long, ByVal i As Long, ByVal hdcDst As Long, ByVal x As Long, ByVal y As Long, ByVal dx As Long, ByVal dy As Long, ByVal rgbBk As Long, ByVal rgbFg As Long, ByVal fStyle As Long) As Long
'  Private Declare Function ImageList_GetIcon Lib "COMCTL32.DLL" (ByVal hIml As Long, ByVal i As Long, ByVal diIgnore As Long) As Long
'  Private Declare Function ImageList_Draw Lib "COMCTL32.DLL" (ByVal hIml As Long, ByVal i As Long, ByVal hdcDst As Long, ByVal x As Long, ByVal y As Long, ByVal fStyle As Long) As Long
'  Private Declare Function DrawState Lib "user32" Alias "DrawStateA" (ByVal hdc As Long, ByVal hBrush As Long, ByVal lpDrawStateProc As Long, ByVal lParam As Long, ByVal wParam As Long, ByVal x As Long, ByVal y As Long, ByVal cx As Long, ByVal cy As Long, ByVal fuFlags As Long) As Long
'  Private Declare Function DestroyIcon Lib "user32" (ByVal hIcon As Long) As Long
' constantes

' Built in ImageList drawing methods:
Private Const ILD_NORMAL = 0
Private Const ILD_TRANSPARENT = 1
Private Const ILD_BLEND25 = 2
Private Const ILD_SELECTED = 4
Private Const ILD_FOCUS = 4
Private Const ILD_OVERLAYMASK = 3840

Public Const CLR_NONE = -1
Private Const FW_NORMAL = 400
Private Const LF_FACESIZE = 32

Private Const DST_COMPLEX = &H0
Private Const DST_TEXT = &H1
Private Const DST_PREFIXTEXT = &H2
Private Const DST_ICON = &H3
Private Const DST_BITMAP = &H4

Private Const DSS_NORMAL = &H0
Private Const DSS_UNION = &H10
Private Const DSS_DISABLED = &H20
Private Const DSS_MONO = &H80
Private Const DSS_RIGHT = &H8000

Private Const CLR_INVALID = -1
' estructuras
' variables privadas
' variables publicas
' eventos
' propiedades publicas
' propiedades privadas
' funciones publicas
Public Function ShowPrintDialog(ByVal hwnd As Long, ByRef DeviceName As String, _
                                ByRef DriverName As String, ByRef Port As String, _
                                ByRef PaperSize As Long, ByRef Orientation As Long, _
                                ByRef FromPage As Long, ByRef ToPage As Long, _
                                ByRef Copies As Long, _
                                ByRef PaperBin As Long) As Boolean
  Dim printDlg As PrinterDlg
  Set printDlg = New PrinterDlg
  
  If Copies < 0 Then Copies = 1
  ' Set the starting information for the dialog box based on the current
  ' printer settings.
  
  If DeviceName = vbNullString Then
    GetDefaultPrinter DeviceName, DriverName, Port, PaperSize, Orientation
  End If
  
  printDlg.PrinterName = DeviceName
  printDlg.DriverName = DriverName
  printDlg.Port = Port
  printDlg.Orientation = Orientation
  printDlg.PaperSize = PaperSize
  printDlg.FromPage = FromPage
  printDlg.ToPage = ToPage
  printDlg.Min = FromPage
  printDlg.Max = ToPage
  printDlg.Copies = Copies
  
  ' Set the default PaperBin so that a valid value is returned even
  ' in the Cancel case.
  printDlg.PaperBin = GetPaperBin(hwnd, DeviceName)
  
  ' Set the flags for the PrinterDlg object using the same flags as in the
  ' common dialog control. The structure starts with VBPrinterConstants.
  printDlg.Flags = VBPrinterConstants.cdlPDNoSelection _
                   Or VBPrinterConstants.cdlPDReturnDC _
                   Or VBPrinterConstants.cdlPDPageNums
  
  ' When CancelError is set to True the ShowPrinterDlg will return error
  ' 32755. You can handle the error to know when the Cancel button was
  ' clicked. Enable this by uncommenting the lines prefixed with "'**".
  '**printDlg.CancelError = True
  
  ' Add error handling for Cancel.
  '**On Error GoTo Cancel
  
  'MsgWarning "Invocando a ShowPrinter"
  
  If printDlg.ShowPrinter(hwnd) Then
  
    'MsgWarning "ShowPrinter devolvio True"
    
    DeviceName = printDlg.PrinterName
    DriverName = printDlg.DriverName
    
    If PaperSize <> 256 Then
      PaperSize = printDlg.PaperSize
    End If
    
    Orientation = printDlg.Orientation
    Port = printDlg.Port
    ToPage = printDlg.ToPage
    FromPage = printDlg.FromPage
    PaperBin = printDlg.PaperBin
    
    'MsgWarning "GetSysVersion devolvio " & GetSysVersion
    
    If GetSysVersion <> 5 Then
      Copies = printDlg.Copies
    Else
      If Copies = 0 Then Copies = 1
    End If
    
    'MsgWarning Copies
    
    ShowPrintDialog = True
    
  ' For debug
  'Else
  '  MsgWarning "La llamada a printDlg.ShowPrinter fallo !!!"
  End If
End Function

Public Sub PrinterSetSizeAndOrient(PrinterName As String, _
                                   PaperSize As Long, _
                                   PaperOrient As Long, _
                                   Optional hDC As Long)
                                   
  Dim nSize             As Long       ' Size of DEVMODE
  Dim pDevmode          As DEVMODE
  Dim LastError         As Long     ' return value for GetLastError
  Dim aDevMode()        As Byte    ' working DEVMODE
  Dim hPrn              As Long
  
  If OpenPrinter(PrinterName, hPrn, 0&) Then
    nSize = DocumentProperties(0&, hPrn, PrinterName, 0&, 0&, 0)
    
    ' Reserve memory for the actual size of the DEVMODE
    ReDim aDevMode(1 To nSize)

    ' Fill the DEVMODE from the printer.
    nSize = DocumentProperties(0&, hPrn, PrinterName, aDevMode(1), 0&, DM_OUT_BUFFER)
    
    ' Copy the predefined portion of the DEVMODE.
    CopyMemory pDevmode, aDevMode(1), Len(pDevmode)

    ' Change the appropriate member in the DevMode.
    ' In this case, you want to change the paper bin and
    ' orientation.
    pDevmode.dmPaperSize = PaperSize
    pDevmode.dmOrientation = PaperOrient
    ' Set the dmFields bit flag to indicate what you're changing.
    pDevmode.dmFields = DM_PAPERSIZE Or DM_ORIENTATION

    ' Copy your changes back, then update DEVMODE.
    CopyMemory aDevMode(1), pDevmode, Len(pDevmode)
    nSize = DocumentProperties(0&, hPrn, PrinterName, aDevMode(1), aDevMode(1), DM_IN_BUFFER Or DM_OUT_BUFFER)
    
    ' Close the handle when you're done with it.
    ClosePrinter hPrn
    
    LastError = GetLastError()
    
    If LastError <> 0 Then
      Err.Raise vbObjectError + 15, "Ha ocurrido un error al setear la página en la impresora. Número de error: " & LastError, vbExclamation, App.EXEName
    End If
    
    '/////////////////////////////////////////////////////////////////////////////////
    ' @#¡¡¡¡¡ y la reputa que lo pario
    ' LO QUE SIGUE ES POR QUE ME TIENE LAS PELOTAS RELLENAS CON FALLAS A ESTA FUNCION
    '
    If hDC <> 0 Then nSize = ResetDC(hDC, aDevMode(1))      ' Reset the DEVMODE
    '
    If LastError <> 0 Then
      If hDC <> 0 Then nSize = ResetDC(hDC, aDevMode(1))      ' Reset the DEVMODE
    End If
    '
    If LastError <> 0 Then
      Err.Raise vbObjectError + 15, "Ha ocurrido un error al setear la página en la impresora. Número de error: " & LastError, vbExclamation, App.EXEName
    End If
    '
    '/////////////////////////////////////////////////////////////////////////////////
    
  Else
    LastError = GetLastError()
    Err.Raise vbObjectError + 15, "Ha ocurrido un error al setear la página en la impresora. Número de error: " & LastError, vbExclamation, App.EXEName
  End If
End Sub

Public Function PrinterSetPaperBin(PrinterName As String, _
                                   PaperBin As Long, _
                                   Optional hDC As Long) As Long
                                   
  Dim nSize             As Long       ' Size of DEVMODE
  Dim pDevmode          As DEVMODE
  Dim LastError         As Long     ' return value for GetLastError
  Dim aDevMode()        As Byte    ' working DEVMODE
  Dim hPrn              As Long
  
  If OpenPrinter(PrinterName, hPrn, 0&) Then
    nSize = DocumentProperties(0&, hPrn, PrinterName, 0&, 0&, 0)
    
    ' Reserve memory for the actual size of the DEVMODE
    ReDim aDevMode(1 To nSize)

    ' Fill the DEVMODE from the printer.
    nSize = DocumentProperties(0&, hPrn, PrinterName, aDevMode(1), 0&, DM_OUT_BUFFER)
    
    ' Copy the predefined portion of the DEVMODE.
    CopyMemory pDevmode, aDevMode(1), Len(pDevmode)

    ' We return the previous paper bin
    ' to let the code restore it when finish printing
    '
    PrinterSetPaperBin = pDevmode.dmDefaultSource
    
    ' Change the appropriate member in the DevMode.
    ' In this case, you want to change the paper bin.
    pDevmode.dmDefaultSource = PaperBin
    
    ' Set the dmFields bit flag to indicate what you're changing.
    pDevmode.dmFields = DM_DEFAULTSOURCE

    ' Copy your changes back, then update DEVMODE.
    CopyMemory aDevMode(1), pDevmode, Len(pDevmode)
    nSize = DocumentProperties(0&, hPrn, PrinterName, aDevMode(1), aDevMode(1), DM_IN_BUFFER Or DM_OUT_BUFFER)
    
    Dim Pinfo9 As PRINTER_INFO_9
    Pinfo9.pDevmode = VarPtr(aDevMode(1))
    
    'Set DEVMODE Stucture with any changes made
    Dim nRet As Long
    nRet = SetPrinter(hPrn, 9, Pinfo9, 0)
    If (nRet <= 0) Then
       Err.Raise vbObjectError + 15, "Cannot set the DEVMODE structure.", vbExclamation, App.EXEName
    End If
    
    ' Close the handle when you're done with it.
    ClosePrinter hPrn
    
    LastError = GetLastError()
    
    If LastError <> 0 Then
      Err.Raise vbObjectError + 15, "Ha ocurrido un error al setear la bandeja en la impresora. Número de error: " & LastError, vbExclamation, App.EXEName
    End If
    
    '/////////////////////////////////////////////////////////////////////////////////
    ' @#¡¡¡¡¡ y la reputa que lo pario
    ' LO QUE SIGUE ES POR QUE ME TIENE LAS PELOTAS RELLENAS CON FALLAS A ESTA FUNCION
    '
    If hDC <> 0 Then nSize = ResetDC(hDC, aDevMode(1))      ' Reset the DEVMODE
    '
    If LastError <> 0 Then
      If hDC <> 0 Then nSize = ResetDC(hDC, aDevMode(1))      ' Reset the DEVMODE
    End If
    '
    If LastError <> 0 Then
      Err.Raise vbObjectError + 15, "Ha ocurrido un error al setear la bandeja en la impresora. Número de error: " & LastError, vbExclamation, App.EXEName
    End If
    '
    '/////////////////////////////////////////////////////////////////////////////////
    
  Else
    LastError = GetLastError()
    Err.Raise vbObjectError + 15, "Ha ocurrido un error al setear la bandeja en la impresora. Número de error: " & LastError, vbExclamation, App.EXEName
  End If
End Function

Public Function PrinterPaperBinNameToId(ByVal DeviceName As String, _
                                        ByVal Port As String, _
                                        ByVal PaperBin As String) As Long
  Dim dwbins As Long
  Dim ct As Long
  Dim nameslist As String
  Dim nextString As String
  Dim numBin() As Integer
   
  dwbins = DeviceCapabilities(DeviceName, Port, _
                              DC_BINS, ByVal vbNullString, 0)
  ReDim numBin(1 To dwbins)
  nameslist = String(24 * dwbins, 0)
  dwbins = DeviceCapabilities(DeviceName, Port, _
                              DC_BINS, numBin(1), 0)
                              
  dwbins = DeviceCapabilities(DeviceName, Port, _
                              DC_BINNAMES, ByVal nameslist, 0)
  
  For ct = 1 To dwbins
    nextString = Mid(nameslist, 24 * (ct - 1) + 1, 24)
    nextString = Left(nextString, InStr(1, nextString, _
                      Chr(0)) - 1)
    'nextString = String(6 - Len(CStr(numBin(ct))), " ") & _
                        numBin(ct) & "  " & nextString
    If nextString = PaperBin Then
      PrinterPaperBinNameToId = numBin(ct)
      Exit Function
    End If
  Next ct

End Function

'Private Function ResetPrinterDC(PrinterName As String, _
'                                hPrtDc As Long, _
'                                PaperSource As Long, _
'                                PaperOrient As Long) As Boolean
'
'  Dim nSize As Long           ' Size of DEVMODE
'  Dim pDevMode As DEVMODE
'  Dim PrinterHandle As Long   ' handle to printer
'  Dim LastError As Long       ' return value for GetLastError
'  Dim aDevMode() As Byte      ' working DEVMODE
'
'
'  ' Get a handle to the printer.
'  If OpenPrinter(PrinterName, PrinterHandle, 0&) Then
'    nSize = DocumentProperties(0&, PrinterHandle, PrinterName, 0&, 0&, 0)
'    ' Reserve memory for the actual size of the DEVMODE
'    ReDim aDevMode(1 To nSize)
'
'    ' Fill the DEVMODE from the printer.
'    nSize = DocumentProperties(0&, PrinterHandle, PrinterName, aDevMode(1), 0&, DM_OUT_BUFFER)
'    ' Copy the predefined portion of the DEVMODE.
'    Call CopyMemory(pDevMode, aDevMode(1), Len(pDevMode))
'
'    ' Change the appropriate member in the DevMode.
'    ' In this case, you want to change the paper bin and
'    ' orientation.
'    pDevMode.dmDefaultSource = PaperSource
'    pDevMode.dmOrientation = PaperOrient
'    ' Set the dmFields bit flag to indicate what you're changing.
'    pDevMode.dmFields = DM_DEFAULTSOURCE Or DM_ORIENTATION
'
'    ' Copy your changes back, then update DEVMODE.
'    Call CopyMemory(aDevMode(1), pDevMode, Len(pDevMode))
'    nSize = DocumentProperties(0&, PrinterHandle, PrinterName, aDevMode(1), aDevMode(1), DM_IN_BUFFER Or DM_OUT_BUFFER)
'
'    nSize = ResetDC(hPrtDc, aDevMode(1))   ' Reset the DEVMODE
'
'    ' Close the handle when you're done with it.
'    ClosePrinter (PrinterHandle)
'    ResetPrinterDC = True   ' Reset succeeded!
'  Else
'    ResetPrinterDC = False  ' Reset failed!
'    LastError = GetLastError()
'    MsgWarning "Error changing Page settings. Error Code: " & LastError, "Print Error"
'  End If
'
'End Function

Private Function GetPaperSuported(ByVal PrinterName As String, ByVal PaperSize As PrinterObjectConstants) As Boolean
  Dim Ret           As Long
  Dim PaperSizes()  As Long
  
  Ret = DeviceCapabilities(PrinterName, "LPT1", DC_PAPERS, ByVal 0&, ByVal 0&)
  ReDim PaperSizes(1 To Ret) As Long
  
  DeviceCapabilities PrinterName, "LPT1", DC_PAPERS, PaperSizes(1), ByVal 0&
  
  Dim i As Long
  For i = 1 To Ret
    If PaperSizes(i) = PaperSize Then
      GetPaperSuported = True
      Exit Function
    End If
  Next
End Function

' PURPOSE:  Displays the property sheet for the printer
' Specified by Device Name
'
' PARAMETER: DeviceName: DeviceName of Printer to
' Display Properties of
'
' EXAMPLE USAGE: DisplayPrinterProperties Printer.DeviceName
'
' NOTES: As Written, you must put this function into a form
' module. To put into a .bas or .cls module, add a parameter for
' the form or the form's hwnd.
'
Public Function DisplayPrinterProperties(ByVal hwnd As Long, ByVal DeviceName As String) As Boolean
  On Error GoTo ErrorHandler
  Dim lAns As Long, hPrinter As Long
  
  lAns = OpenPrinter(DeviceName, hPrinter, 0&)
  If lAns <> 0 Then
      lAns = PrinterProperties(hwnd, hPrinter)
      DisplayPrinterProperties = lAns <> 0
  End If
  
ErrorHandler:
  If hPrinter <> 0 Then ClosePrinter hPrinter
End Function

Public Function GetPaperType(ByVal hwnd As Long, ByVal PrinterName As String) As Long
  Dim nSize             As Long       ' Size of DEVMODE
  Dim pDevmode          As DEVMODE
  Dim PrinterHandle     As Long   ' handle to printer
  Dim LastError         As Long     ' return value for GetLastError
  Dim aDevMode()        As Byte    ' working DEVMODE
  
  ' Get a handle to the printer.
  If OpenPrinter(PrinterName, PrinterHandle, 0&) Then
    nSize = DocumentProperties(hwnd, PrinterHandle, PrinterName, 0&, 0&, 0)
    
    ' Reserve memory for the actual size of the DEVMODE
    ReDim aDevMode(1 To nSize)

    ' Fill the DEVMODE from the printer.
    nSize = DocumentProperties(hwnd, PrinterHandle, PrinterName, aDevMode(1), 0&, DM_OUT_BUFFER)
    
    ' Copy the predefined portion of the DEVMODE.
    CopyMemory pDevmode, aDevMode(1), Len(pDevmode)

    ' Change the appropriate member in the DevMode.
    ' In this case, you want to change the paper bin and
    ' orientation.
    
    GetPaperType = pDevmode.dmPaperSize
    
    ' Close the handle when you're done with it.
    ClosePrinter PrinterHandle
  Else
    LastError = GetLastError()
    Err.Raise vbObjectError + 15, "Ha ocurrido un error al obtener el tamaño del papel. Número de error: " & LastError, vbExclamation, App.EXEName
  End If
End Function

Public Function GetPrinterOrientation(ByVal hwnd As Long, ByVal PrinterName As String) As Long
  Dim nSize             As Long       ' Size of DEVMODE
  Dim pDevmode          As DEVMODE
  Dim PrinterHandle     As Long   ' handle to printer
  Dim LastError         As Long     ' return value for GetLastError
  Dim aDevMode()        As Byte    ' working DEVMODE
  
  ' Get a handle to the printer.
  If OpenPrinter(PrinterName, PrinterHandle, 0&) Then
    nSize = DocumentProperties(hwnd, PrinterHandle, PrinterName, 0&, 0&, 0)
    
    ' Reserve memory for the actual size of the DEVMODE
    ReDim aDevMode(1 To nSize)

    ' Fill the DEVMODE from the printer.
    nSize = DocumentProperties(hwnd, PrinterHandle, PrinterName, aDevMode(1), 0&, DM_OUT_BUFFER)
    
    ' Copy the predefined portion of the DEVMODE.
    CopyMemory pDevmode, aDevMode(1), Len(pDevmode)

    ' Change the appropriate member in the DevMode.
    ' In this case, you want to change the paper bin and
    ' orientation.
    
    GetPrinterOrientation = pDevmode.dmOrientation
    
    ' Close the handle when you're done with it.
    ClosePrinter PrinterHandle
  Else
    LastError = GetLastError()
    Err.Raise vbObjectError + 15, "Ha ocurrido un error al obtener el tamaño del papel. Número de error: " & LastError, vbExclamation, App.EXEName
  End If
End Function

Public Function GetPaperBin(ByVal hwnd As Long, ByVal PrinterName As String) As Long
  Dim nSize             As Long       ' Size of DEVMODE
  Dim pDevmode          As DEVMODE
  Dim PrinterHandle     As Long   ' handle to printer
  Dim LastError         As Long     ' return value for GetLastError
  Dim aDevMode()        As Byte    ' working DEVMODE
  
  ' Get a handle to the printer.
  If OpenPrinter(PrinterName, PrinterHandle, 0&) Then
    nSize = DocumentProperties(hwnd, PrinterHandle, PrinterName, 0&, 0&, 0)
    
    ' Reserve memory for the actual size of the DEVMODE
    ReDim aDevMode(1 To nSize)

    ' Fill the DEVMODE from the printer.
    nSize = DocumentProperties(hwnd, PrinterHandle, PrinterName, aDevMode(1), 0&, DM_OUT_BUFFER)
    
    ' Copy the predefined portion of the DEVMODE.
    CopyMemory pDevmode, aDevMode(1), Len(pDevmode)

    ' Change the appropriate member in the DevMode.
    ' In this case, you want to change the paper bin and
    ' orientation.
    
    GetPaperBin = pDevmode.dmDefaultSource
    
    ' Close the handle when you're done with it.
    ClosePrinter PrinterHandle
  Else
    LastError = GetLastError()
    Err.Raise vbObjectError + 15, "Ha ocurrido un error al obtener el tamaño del papel. Número de error: " & LastError, vbExclamation, App.EXEName
  End If
End Function

Public Function GetPaperSize(ByVal hwnd As Long, ByVal PrinterName As String) As Rectangle
  Dim nSize             As Long       ' Size of DEVMODE
  Dim pDevmode          As DEVMODE
  Dim PrinterHandle     As Long   ' handle to printer
  Dim LastError         As Long     ' return value for GetLastError
  Dim aDevMode()        As Byte    ' working DEVMODE
  Dim rtn               As Rectangle
  
  ' Get a handle to the printer.
  If OpenPrinter(PrinterName, PrinterHandle, 0&) Then
    nSize = DocumentProperties(hwnd, PrinterHandle, PrinterName, 0&, 0&, 0)
    
    ' Reserve memory for the actual size of the DEVMODE
    ReDim aDevMode(1 To nSize)

    ' Fill the DEVMODE from the printer.
    nSize = DocumentProperties(hwnd, PrinterHandle, PrinterName, aDevMode(1), 0&, DM_OUT_BUFFER)
    
    ' Copy the predefined portion of the DEVMODE.
    CopyMemory pDevmode, aDevMode(1), Len(pDevmode)

    ' Change the appropriate member in the DevMode.
    ' In this case, you want to change the paper bin and
    ' orientation.
    
    rtn = GetRectFromPaperSize(Nothing, pDevmode.dmPaperSize, pDevmode.dmOrientation)
    
    ' Close the handle when you're done with it.
    ClosePrinter PrinterHandle
    
    GetPaperSize = rtn
  Else
    LastError = GetLastError()
    Err.Raise vbObjectError + 15, "Ha ocurrido un error al obtener el tamaño del papel. Número de error: " & LastError, vbExclamation, App.EXEName
  End If
End Function

Public Sub GetDefaultPrinter(ByRef DeviceName As String, ByRef DriverName As String, ByRef Port As String, _
                             ByRef PaperSize As Long, ByRef Orientation As Long)
    Dim strBuffer As String * 254
    Dim iRetValue As Long
    Dim strDefaultPrinterInfo As String
    Dim tblDefaultPrinterInfo() As String
    Dim objPrinter As Printer

    ' Retreive current default printer information
    iRetValue = GetProfileString("windows", "device", ",,,", strBuffer, 254)
    
    strDefaultPrinterInfo = Left$(strBuffer, InStr(strBuffer, Chr(0)) - 1)
    
    tblDefaultPrinterInfo = Split(strDefaultPrinterInfo, ",")
    
    If UBound(tblDefaultPrinterInfo) >= 0 Then
    
      DeviceName = tblDefaultPrinterInfo(0)
      DriverName = tblDefaultPrinterInfo(1)
      Port = tblDefaultPrinterInfo(2)
    End If
    
    PaperSize = 1
    Orientation = 1
End Sub

Public Function GetRectFromPaperSize(ByRef ObjInfo As Object, ByVal PaperSize As Long, ByVal Orientation As Long) As Rectangle
  Dim rtn As Rectangle
  
  Select Case PaperSize
    Case vbPRPSLetter
      rtn.Height = 15840
      rtn.Width = 12240
    Case vbPRPSLegal
      rtn.Height = 20160
      rtn.Width = 12060
    Case vbPRPSA4
      rtn.Height = 16832
      rtn.Width = 11908
    Case vbPRPSA3
      rtn.Height = 23816
      rtn.Width = 16832
    Case vbPRPSUser
      If ObjInfo Is Nothing Then
        Err.Raise vbObjectError + 20, "mPrintAPI.GetRectFromPaperSize", "No hay informacion de las medidas de la hoja para el formato personalizado"
      Else
        rtn.Width = ObjInfo.CustomWidth
        rtn.Height = ObjInfo.CustomHeight
      End If
  End Select
  
  If Orientation = vbPRORLandscape Then
    Dim tmp As Long
    tmp = rtn.Height
    rtn.Height = rtn.Width
    rtn.Width = tmp
  End If
  
  GetRectFromPaperSize = rtn
End Function

Public Function GetcPrinterFromDefaultPrinter() As cPrinter 'CSReportDll2.cPrinter
  Dim DeviceName    As String
  Dim DriverName    As String
  Dim Port          As String
  Dim PaperSize     As Long
  Dim Orientation   As Long
  
  GetDefaultPrinter DeviceName, DriverName, Port, Orientation, PaperSize
  
  If DeviceName <> vbNullString Then
  
    Set GetcPrinterFromDefaultPrinter = GetcPrint(DeviceName, DriverName, Port)
  End If
End Function

Public Function GetcPrint(ByVal DeviceName As String, ByVal DriverName As String, ByVal Port As String) As cPrinter 'CSReportDll2.cPrinter

100  Dim o As cPrinter 'CSReportDll2.cPrinter
105
106  Set o = New cPrinter 'CSReportDll2.cPrinter
107
108  With o
109    .DeviceName = DeviceName
110    .DriverName = DriverName
111    .Port = Port
113    With .PaperInfo
    
114      .Orientation = GetPrinterOrientation(0&, DeviceName)
115      .PaperSize = GetPaperType(0&, DeviceName)
      
116      Dim tR As Rectangle
117      tR = GetPaperSize(0&, DeviceName)
118      .Width = tR.Width
119      .Height = tR.Height
120    End With
121  End With
122  Set GetcPrint = o

End Function

Public Function GetSysVersion() As Long
  Dim tVer As OSVERSIONINFO
  tVer.dwOSVersionInfoSize = Len(tVer)
  
  GetVersionEx tVer

  Select Case tVer.dwPlatformId
    Case 0
      GetSysVersion = 31
    Case 1
      'get minor version info
      If tVer.dwMinorVersion = 0 Then
          GetSysVersion = 95 ' sOS = "Microsoft Windows 95"
      ElseIf tVer.dwMinorVersion = 10 Then
          GetSysVersion = 98 ' sOS = "Microsoft Windows 98"
      ElseIf tVer.dwMinorVersion = 90 Then
          GetSysVersion = 1000 ' sOS = "Microsoft Windows Millenium"
      Else
          GetSysVersion = 1000
      End If
    Case 2
      If tVer.dwMajorVersion >= 6 Then ' Vista
        GetSysVersion = 5
      Else ' XP / 2000
        GetSysVersion = 4
      End If
  End Select
End Function

' funciones privadas
' construccion - destruccion

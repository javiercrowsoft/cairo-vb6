Attribute VB_Name = "mBarcode"
Option Explicit

Private Type DOCINFO
  pDocName As String
  pOutputFile As String
  pDatatype As String
End Type

Private Declare Function ClosePrinter Lib "winspool.drv" (ByVal hPrinter As Long) As Long
Private Declare Function EndDocPrinter Lib "winspool.drv" (ByVal hPrinter As Long) As Long
Private Declare Function EndPagePrinter Lib "winspool.drv" (ByVal hPrinter As Long) As Long
Private Declare Function OpenPrinter Lib "winspool.drv" Alias "OpenPrinterA" (ByVal pPrinterName As String, phPrinter As Long, ByVal pDefault As Long) As Long
Private Declare Function StartDocPrinter Lib "winspool.drv" Alias "StartDocPrinterA" (ByVal hPrinter As Long, ByVal Level As Long, pDocInfo As DOCINFO) As Long
Private Declare Function StartPagePrinter Lib "winspool.drv" (ByVal hPrinter As Long) As Long
Private Declare Function WritePrinter Lib "winspool.drv" (ByVal hPrinter As Long, pBuf As Any, ByVal cdBuf As Long, pcWritten As Long) As Long

Private Const c_sep = "|"
Private Const c_macro_name = "@@nombre"
Private Const c_macro_mark = "@@marca"
Private Const c_macro_serie = "@@serie"
Private Const c_macro_mask = "@@mask"


Public Function BCPrintBarcode(ByVal file_barcode As String, _
                               ByVal names As String, _
                               ByVal marks As String, _
                               ByVal serials As String, _
                               ByVal printer_name As String, _
                               ByRef error As String, _
                               Optional ByVal mask0 As String, _
                               Optional ByVal mask1 As String, _
                               Optional ByVal mask2 As String, _
                               Optional ByVal mask3 As String, _
                               Optional ByVal mask4 As String, _
                               Optional ByVal mask5 As String, _
                               Optional ByVal mask6 As String, _
                               Optional ByVal mask7 As String, _
                               Optional ByVal mask8 As String, _
                               Optional ByVal mask9 As String) As Boolean
  Dim lhPrinter     As Long
  Dim lReturn       As Long
  Dim lpcWritten    As Long
  Dim lDoc          As Long
  Dim sWrittenData  As String
  Dim t_DocInfo     As DOCINFO
  
  Dim iFile   As Long
  Dim iLen    As Long
  Dim buffer  As String
  Dim sLine   As String
  
  Dim vNames      As Variant
  Dim vMarks      As Variant
  Dim vSerials    As Variant
  Dim vMask       As Variant
  Dim i           As Long
  
  vNames = Split(names, c_sep)
  vMarks = Split(marks, c_sep)
  vSerials = Split(serials, c_sep)
  
  iFile = FreeFile
  
  Open file_barcode For Input As #iFile
  
  While Not EOF(iFile)
  
    Line Input #iFile, sLine
    
    If Left$(sLine, 1) <> "'" Then
      buffer = buffer & sLine & vbCrLf
    End If
  
  Wend
  
  Close iFile
  
  For i = 0 To UBound(vNames)
    buffer = Replace(buffer, c_macro_name & Format(i + 1, "000"), vNames(i))
  Next
  For i = 0 To UBound(vMarks)
    buffer = Replace(buffer, c_macro_mark & i + 1, vMarks(i))
  Next
  For i = 0 To UBound(vSerials)
    buffer = Replace(buffer, c_macro_serie & i + 1, vSerials(i))
  Next
  
  '---------------------------------------------------------
  ' Mascaras adicionales
  '
  vMask = Split(mask0, c_sep)
  For i = 0 To UBound(vMask)
    buffer = Replace(buffer, c_macro_mask & "01" & i + 1, vMask(i))
  Next
  vMask = Split(mask1, c_sep)
  For i = 0 To UBound(vMask)
    buffer = Replace(buffer, c_macro_mask & "02" & i + 1, vMask(i))
  Next
  vMask = Split(mask2, c_sep)
  For i = 0 To UBound(vMask)
    buffer = Replace(buffer, c_macro_mask & "03" & i + 1, vMask(i))
  Next
  vMask = Split(mask3, c_sep)
  For i = 0 To UBound(vMask)
    buffer = Replace(buffer, c_macro_mask & "04" & i + 1, vMask(i))
  Next
  vMask = Split(mask4, c_sep)
  For i = 0 To UBound(vMask)
    buffer = Replace(buffer, c_macro_mask & "05" & i + 1, vMask(i))
  Next
  vMask = Split(mask5, c_sep)
  For i = 0 To UBound(vMask)
    buffer = Replace(buffer, c_macro_mask & "06" & i + 1, vMask(i))
  Next
  vMask = Split(mask6, c_sep)
  For i = 0 To UBound(vMask)
    buffer = Replace(buffer, c_macro_mask & "07" & i + 1, vMask(i))
  Next
  vMask = Split(mask7, c_sep)
  For i = 0 To UBound(vMask)
    buffer = Replace(buffer, c_macro_mask & "08" & i + 1, vMask(i))
  Next
  vMask = Split(mask8, c_sep)
  For i = 0 To UBound(vMask)
    buffer = Replace(buffer, c_macro_mask & "09" & i + 1, vMask(i))
  Next
  vMask = Split(mask9, c_sep)
  For i = 0 To UBound(vMask)
    buffer = Replace(buffer, c_macro_mask & "10" & i + 1, vMask(i))
  Next
  
  '-----------------------------------------
  '
  ' ahora a imprimir
  '
  '
  ' Si se trata de una impresora intermec
  ' le enviamos la etiqueta usando esim y
  ' usamos un puerto com, que debe estar indicado
  ' en el mismo nombre del archivo de etiqueta
  ' No jodan por ahora es asi :P
  '
  ' El archivo se tiene que llamar esim_{numero puerto com}_xxxxx.prn
  '
  ' Por ejemplo:
  '
  '     esim_5_etiqueta_gng_tubos.prn
  '
  ' Lo unico que se exige realmente es esim_{numero puerto com}_
  ' todo lo demas no importa
  '
  Const c_esim_prefix = "esim_"
  
  If InStr(1, file_barcode, c_esim_prefix) Then
  
    BCPrintBarcode = pPrintToComm(file_barcode, buffer)
    
  Else
  
    sWrittenData = buffer & vbFormFeed
  
    lReturn = OpenPrinter(printer_name, lhPrinter, 0)
    If lReturn = 0 Then
      error = "No se pudo abrir la impresora"
      Exit Function
    End If
    
    With t_DocInfo
      .pDocName = file_barcode
      .pOutputFile = vbNullString
      .pDatatype = vbNullString
    End With
    
    lDoc = StartDocPrinter(lhPrinter, 1, t_DocInfo)
    
    Call StartPagePrinter(lhPrinter)
    
    lReturn = WritePrinter(lhPrinter, _
                           ByVal sWrittenData, _
                           Len(sWrittenData), _
                           lpcWritten)
                           
    lReturn = EndPagePrinter(lhPrinter)
    lReturn = EndDocPrinter(lhPrinter)
    lReturn = ClosePrinter(lhPrinter)
    
    BCPrintBarcode = True
  End If
  
End Function

Private Function pPrintToComm(ByVal file_barcode As String, _
                              ByVal buffer As String) As Boolean

  On Error GoTo ControlError

  Dim port As Long
  port = pGetPortFromFileName(file_barcode)

  If port = 0 Then Exit Function
  
  Dim fComm As fComm
  Set fComm = New fComm

  fComm.comm.CommPort = port
  fComm.comm.PortOpen = True
  fComm.comm.Output = buffer
  fComm.comm.PortOpen = False

  pPrintToComm = True

  GoTo ExitProc
ControlError:
  MsgBox "Error al Imprimir por el puerto Comm [" & port & "]" _
          & vbCrLf & vbCrLf _
          & Err.Description, vbExclamation
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
  Unload fComm
  Set fComm = Nothing
End Function

Private Function pGetPortFromFileName(ByVal file_barcode As String) As Long
  Dim n As Long
  Dim k As Long
  
  n = InStr(1, file_barcode, "_")
  k = InStr(n + 1, file_barcode, "_")
  
  If n = 0 Or k = 0 Then Exit Function
  
  pGetPortFromFileName = Val(Mid$(file_barcode, n + 1, k - n))
End Function

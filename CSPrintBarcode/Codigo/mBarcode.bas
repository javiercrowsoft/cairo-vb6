Attribute VB_Name = "mBarcode"
Option Explicit

Public Function DoPrint(ByVal rptFile As String, _
                        ByVal Copies As Long, _
                        ByVal printer_name As String, _
                        ByRef rs As Recordset, _
                        ByVal numbers As String) As Boolean
                        
  
  Dim Barcode As cBarcode
  Set Barcode = New cBarcode
  
  Dim mouse As cMouseWait
  Set mouse = New cMouseWait
  
  Dim bPrint        As Boolean
  Dim bFilter       As Boolean
  Dim names         As String
  Dim marks         As String
  Dim serials       As String
  Dim error         As String
  Dim codigos       As String
  Dim serials2      As String
  Dim codigo        As String
  Dim serial        As String
  Dim i             As Long
  Dim strq          As String
  Dim q             As Long
  Dim k             As Long
  Dim msg           As String
  
  bFilter = LenB(numbers)
  
  ' Esta rutina imprime por ahora
  ' en una etiqueta de 3 bandas de
  ' 4x2
  '
  '
  While Not rs.EOF
  
    If LenB(Trim$(gDB.ValField(rs.fields, cscPrnsCodigo))) = 0 Then
      msg = "Ingrese la cantidad de copias que desea imprimir para el lote " & _
            vbCrLf & gDB.ValField(rs.fields, cscPrCodigoBarraNombre) & " " & _
            vbCrLf & gDB.ValField(rs.fields, cscStlCodigo)
      If Not GetInput(strq, msg) Then Exit Function
      q = Val(strq)
    Else
      q = 1
    End If
  
    For k = 1 To q
  
      If i = 3 Then
    
        names = Left$(names, Len(names) - 1)
        marks = Left$(marks, Len(marks) - 1)
        serials = Left$(serials, Len(serials) - 1)
        codigos = Left$(codigos, Len(codigos) - 1)
        serials2 = Left$(serials2, Len(serials2) - 1)
    
        If Not Barcode.BCPrintBarcode(rptFile, _
                                      names, _
                                      marks, _
                                      serials, _
                                      printer_name, _
                                      error, _
                                      codigos, _
                                      serials2) Then
          MsgError error
          Exit Function
        End If
        
        i = 0
        names = vbNullString
        marks = vbNullString
        serials = vbNullString
        codigos = vbNullString
        serials2 = vbNullString
      End If
      
      serial = gDB.ValField(rs.fields, cscPrnsCodigo)
      
      If LenB(serial) = 0 Then
        serial = gDB.ValField(rs.fields, cscStlCodigo)
      End If
      
      If bFilter Then
        bPrint = InStr(1, numbers, serial, vbTextCompare)
      Else
        bPrint = True
      End If
      
      If bPrint Then
      
        i = i + 1
      
        codigo = gDB.ValField(rs.fields, cscPrCodigoBarra)
        
        names = names & gDB.ValField(rs.fields, cscPrCodigoBarraNombre) & c_sep
        marks = marks & gDB.ValField(rs.fields, cscMarca) & c_sep
        
        serials = serials & codigo & serial & c_sep
        codigos = codigos & codigo & c_sep
        serials2 = serials2 & serial & c_sep
      End If
    Next k
    
    rs.MoveNext
  Wend
  
  If names <> vbNullString Then
    Barcode.BCPrintBarcode rptFile, _
                           names, _
                           marks, _
                           serials, _
                           printer_name, _
                           error, _
                           codigos, _
                           serials2
  End If
  
  DoPrint = True
End Function



VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cAfipImport"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

'/////////////////////////////////////////////////////////////////////////////
' Diseño de registro de salida
'    Nombre         Posición  Longitud  Comentarios (*)
'    CUIT           1-11      11
'    DENOMINACION   12-41     30
'    IMP GANANCIAS  42/43     2         'NI' , 'AC','EX','ET'
'    IMP IVA        44/45     2         'NI' , 'AC','EX','NA','XN','AN'
'    MONOTRIBUTO    46 / 47   2         'NI' , "Codigo categoria tributaria"
'    INTEGRANTE SOC 48        1         'N' , 'S'
'    EMPLEADOR      49        1         'N', 'S'
'/////////////////////////////////////////////////////////////////////////////

Private Sub ReadRecord(ByVal f As Integer, ByRef str As String)
  Dim bBuffer(0) As Byte
  
  str = ""
  Do While Not EOF(f)
  
    Get #f, , bBuffer()
  
    ' End record
    If bBuffer(0) = 10 Then
      Exit Do
    End If
    str = str & Chr(bBuffer(0))
  Loop
  
  If Len(str) < 49 Then
    str = Left$(str & c_filler, 49)
  End If
End Sub

Public Function RepairFile(ByVal File As String)
  On Error GoTo ControlError
  
  Dim f     As Integer
  Dim fo    As Integer
  Dim str   As String

 
  f = FreeFile
 
  Dim lLen      As Long
  Dim lLoc      As Long
  Dim nRecords  As Long
 
  Dim nProgress       As Long
  Dim nLastProgress   As Long
 
  lLen = FileLen(File)
 
  Open File For Binary As #f
 
  fo = FreeFile
  Open File & "-r.txt" For Output As #fo
 
  While Not EOF(f)

    DoEvents
    
    If gCancel Then GoTo ExitProc

    lLoc = Loc(f)

    nProgress = CInt((lLoc / lLen) * 100)

    If nProgress <> nLastProgress Then

      nLastProgress = nProgress
      
      fMain.lbProgreso.Caption = nProgress
    End If

    ReadRecord f, str
    
    Print #fo, str;
    
    nRecords = nRecords + 1
    
    If nRecords Mod 1000 = 0 Then
      fMain.lbRecords = nRecords
    End If

  Wend
  
  fMain.lbRecords = nRecords
    
  GoTo ExitProc
ControlError:
  MngError "RepairFile", Err
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
  Close f
End Function


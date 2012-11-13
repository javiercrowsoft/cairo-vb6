Attribute VB_Name = "mMain"
Option Explicit

Public gFileNames        As Variant

Public Const gstrSEP_URLDIR$ = "/"                      ' Separator for dividing directories in URL addresses.
Private Const gstrSEP_DIR$ = "\"                         ' Directory separator character

' funciones publicas

Public Sub Main()
  On Error Resume Next
  ReDim gFileNames(2)
  gFileNames(1) = "CSSqlAdmin"
  gFileNames(2) = "CSAdmin"
  fMain.Show
End Sub

Public Sub MngError(ByVal FunctionName As String, Optional ByVal Severity As Integer)
  MsgBox "Error en funcion: " & FunctionName & vbCrLf & vbCrLf & Err.Description, vbExclamation, "Error"
End Sub

Public Function DirExists(ByVal strDirName As String) As Integer
    Const strWILDCARD$ = "*.*"

    Dim strDummy As String

    On Error Resume Next

    If Trim(strDirName) = "" Then Exit Function

    AddDirSep strDirName
    strDummy = Dir$(strDirName & strWILDCARD, vbDirectory)
    DirExists = Not (strDummy = vbNullString)

    Err = 0
End Function

Public Sub AddDirSep(strPathName As String)
    If Right(Trim(strPathName), Len(gstrSEP_URLDIR)) <> gstrSEP_URLDIR And _
       Right(Trim(strPathName), Len(gstrSEP_DIR)) <> gstrSEP_DIR Then
        strPathName = RTrim$(strPathName) & gstrSEP_DIR
    End If
End Sub

' funciones privadas

Private Function pGetCommandLine(Optional MaxArgs)
   'Declare variables.
   Dim c, CmdLine, CmdLnLen, InArg, i, NumArgs
   
   'See if MaxArgs was provided.
   If IsMissing(MaxArgs) Then MaxArgs = 10
   
   'Make array of the correct size.
   ReDim ArgArray(MaxArgs)
   
   NumArgs = 0: InArg = False
   
   'Get command line arguments.
   CmdLine = Command()
   CmdLnLen = Len(CmdLine)
   
   'Go thru command line one character
   'at a time.
   For i = 1 To CmdLnLen
      c = Mid(CmdLine, i, 1)
      'Test for space or tab.
      If (c <> " " And c <> vbTab) Then
         'Neither space nor tab.
         'Test if already in argument.
         If Not InArg Then
         'New argument begins.
         'Test for too many arguments.
            If NumArgs = MaxArgs Then Exit For
            NumArgs = NumArgs + 1
            InArg = True
         End If
         'Concatenate character to current argument.
         ArgArray(NumArgs) = ArgArray(NumArgs) & c
      Else
         'Found a space or tab.
         'Set InArg flag to False.
         InArg = False
      End If
   Next i
   
   'Resize array just enough to hold arguments.
   ReDim Preserve ArgArray(NumArgs)
   'Return Array in Function name.
   pGetCommandLine = ArgArray()
End Function

Private Function pStrToArray(ByVal Lista As String) As Variant
  Dim Pos As Integer
  Dim v() As String
  Dim i   As Integer
  
  ReDim v(0)
  
  Do
    i = i + 1
    Pos = InStr(1, Lista, ",")
    If Pos = 0 Then Pos = Len(Lista) + 1
    If Mid(Lista, 1, Pos - 1) <> "" Then
      ReDim Preserve v(i)
      v(i) = Mid(Lista, 1, Pos - 1)
      Lista = Mid(Lista, Pos + 1)
    End If
    
  Loop Until Lista = ""
  
  
  pStrToArray = v
End Function

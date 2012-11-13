Attribute VB_Name = "modGsApi"
' Copyright (c) 2002 Dan Mount and Ghostgum Software Pty Ltd
'
' Permission is hereby granted, free of charge, to any person obtaining
' a copy of this software and associated documentation files (the
' "Software"), to deal in the Software without restriction, including
' without limitation the rights to use, copy, modify, merge, publish,
' distribute, sublicense, and/or sell copies of the Software, and to
' permit persons to whom the Software is furnished to do so, subject to
' the following conditions:
'
' The above copyright notice and this permission notice shall be
' included in all copies or substantial portions of the Software.
'
' THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
' EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
' MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
' NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
' BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
' ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
' CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
' SOFTWARE.


' This is an example of how to call the Ghostscript DLL from
' Visual Basic 6.  This example converts colorcir.ps to PDF.
' The display device is not supported.
'
' This code is not compatible with VB.NET.  There is another
' example which does work with VB.NET.  Differences include:
' 1. VB.NET uses GCHandle to get pointer
'    VB6 uses StrPtr/VarPtr
' 2. VB.NET Integer is 32bits, Long is 64bits
'    VB6 Integer is 16bits, Long is 32bits
' 3. VB.NET uses IntPtr for pointers
'    VB6 uses Long for pointers
' 4. VB.NET strings are always Unicode
'    VB6 can create an ANSI string
' See the following URL for some VB6 / VB.NET details
'  http://msdn.microsoft.com/library/default.asp?url=/library/en-us/dnvb600/html/vb6tovbdotnet.asp

' Last modification:
'   09/13/2005 Frank Heindörfer: Added error consants


Option Explicit

'Return codes from gsapi_*()
'0              No errors
'e_Quit         "quit" has been executed. This is not an error. gsapi_exit() must be called next.
'e_NeedInput    More input is needed by gsapi_run_string_continue(). This is not an error.
'e_Info         "gs -h" has been executed. This is not an error. gsapi_exit() must be called next.
'< 0            Error
'<= -100        Fatal error. gsapi_exit() must be called next.
Private Const e_configurationerror  As Long = -26
Private Const e_invalidcontext  As Long = -27
Private Const e_undefinedresource  As Long = -28
Private Const e_unregistered  As Long = -29
Private Const e_invalidid  As Long = -30 ' invalidid is for the NeXT DPS extension.
Private Const e_Fatal  As Long = -100
Private Const e_Quit  As Long = -101 ' Internal code for the .quit operator. The real quit code is an integer on the operand stack. gs_interpret returns this only for a .quit with a zero exit code. "quit" has been executed. This is not an error. gsapi_exit() must be called next.
Private Const e_InterpreterExit  As Long = -102 ' Internal code for a normal exit from the interpreter.
Private Const e_RemapColor  As Long = -103 ' Internal code that indicates that a procedure has been stored in the remap_proc of the graphics state, and should be called before retrying the current token.  This is used for color remapping involving a call back into the interpreter -- inelegant, but effective.
Private Const e_ExecStackUnderflow  As Long = -104 ' Internal code to indicate we have underflowed the top block of the e-stack.
Private Const e_VMreclaim  As Long = -105 ' Internal code for the vmreclaim operator with a positive operand. We need to handle this as an error because otherwise the interpreter won't reload enough of its state when the operator returns.
Private Const e_NeedInput  As Long = -106 ' Internal code for requesting more input from run_string.
Private Const e_NeedStdin  As Long = -107 ' Internal code for stdin callout.
Private Const e_NeedStdout  As Long = -108 ' Internal code for stdout callout.
Private Const e_NeedStderr  As Long = -109 ' Internal code for stderr callout.
Private Const e_Info  As Long = -110 ' Internal code for a normal exit when usage info is displayed. This allows Window versions of Ghostscript to pause until the message can be read.

'------------------------------------------------
'API Calls Start
'------------------------------------------------
'Win32 API
'GhostScript API
Public Const GsDll = "gsdll32.dll"

Private Declare Function gsapi_revision Lib "gsdll32.dll" (ByVal pGSRevisionInfo As Long, ByVal intLen As Long) As Long
Private Declare Function gsapi_new_instance Lib "gsdll32.dll" (ByRef lngGSInstance As Long, ByVal lngCallerHandle As Long) As Long
Private Declare Function gsapi_set_stdio Lib "gsdll32.dll" (ByVal lngGSInstance As Long, ByVal gsdll_stdin As Long, ByVal gsdll_stdout As Long, ByVal gsdll_stderr As Long) As Long
Private Declare Sub gsapi_delete_instance Lib "gsdll32.dll" (ByVal lngGSInstance As Long)
Private Declare Function gsapi_init_with_args Lib "gsdll32.dll" (ByVal lngGSInstance As Long, ByVal lngArgumentCount As Long, ByVal lngArguments As Long) As Long
Private Declare Function gsapi_run_file Lib "gsdll32.dll" (ByVal lngGSInstance As Long, ByVal strFileName As String, ByVal intErrors As Long, ByVal intExitCode As Long) As Long
Private Declare Function gsapi_exit Lib "gsdll32.dll" (ByVal lngGSInstance As Long) As Long
'------------------------------------------------
'API Calls End
'------------------------------------------------


'------------------------------------------------
'UDTs Start
'------------------------------------------------
Private Type GS_Revision
    strProduct As Long
    strCopyright As Long
    intRevision As Long
    intRevisionDate As Long
End Type

Public Type tGhostscriptRevision
 strProduct As String
 strCopyright As String
 intRevision As Long
 intRevisionDate As Long
End Type
'------------------------------------------------
'UDTs End
'------------------------------------------------

Public GSRevision As tGhostscriptRevision

'------------------------------------------------
'Callback Functions Start
'------------------------------------------------
'These are only required if you use gsapi_set_stdio

Public Function gsdll_stdin(ByVal intGSInstanceHandle As Long, ByVal strz As Long, ByVal intBytes As Long) As Long
'---ErrPtnr-OnError-START--- DO NOT MODIFY ! ---
On Error GoTo ErrPtnr_OnError
'---ErrPtnr-OnError-END--- DO NOT MODIFY ! ---
50010  gsdll_stdin = 0
'---ErrPtnr-OnError-START--- DO NOT MODIFY ! ---
Exit Function
ErrPtnr_OnError:
  Call ErrPtnr.OnError("modGsApi", "gsdll_stdin")
'Case 0: Resume
'Case 1: Resume Next
'Case 2: Exit Function
'Case 3: End
'End Select
'---ErrPtnr-OnError-END--- DO NOT MODIFY ! ---
End Function

Public Function gsdll_stdout(ByVal intGSInstanceHandle As Long, ByVal strz As Long, ByVal intBytes As Long) As Long
'---ErrPtnr-OnError-START--- DO NOT MODIFY ! ---
On Error GoTo ErrPtnr_OnError
'---ErrPtnr-OnError-END--- DO NOT MODIFY ! ---
50010  Dim aByte() As Byte, ptrByte As Long
50020  ReDim aByte(intBytes)
50030  ptrByte = VarPtr(aByte(0))
50040  MoveMemoryLong ptrByte, strz, intBytes
50050  GS_OutStr = GS_OutStr & Replace(StrConv(aByte, vbUnicode), vbLf, vbCrLf)
50060  gsdll_stdout = intBytes
'---ErrPtnr-OnError-START--- DO NOT MODIFY ! ---
Exit Function
ErrPtnr_OnError:
  Call ErrPtnr.OnError("modGsApi", "gsdll_stdout")
'Case 0: Resume
'Case 1: Resume Next
'Case 2: Exit Function
'Case 3: End
'End Select
'---ErrPtnr-OnError-END--- DO NOT MODIFY ! ---
End Function

Public Function gsdll_stderr(ByVal intGSInstanceHandle As Long, ByVal strz As Long, ByVal intBytes As Long) As Long
'---ErrPtnr-OnError-START--- DO NOT MODIFY ! ---
On Error GoTo ErrPtnr_OnError
'---ErrPtnr-OnError-END--- DO NOT MODIFY ! ---
50010   gsdll_stderr = gsdll_stdout(intGSInstanceHandle, strz, intBytes)
'---ErrPtnr-OnError-START--- DO NOT MODIFY ! ---
Exit Function
ErrPtnr_OnError:
  Call ErrPtnr.OnError("modGsApi", "gsdll_stderr")
'Case 0: Resume
'Case 1: Resume Next
'Case 2: Exit Function
'Case 3: End
'End Select
'---ErrPtnr-OnError-END--- DO NOT MODIFY ! ---
End Function
'------------------------------------------------
'Callback Functions End
'------------------------------------------------


'------------------------------------------------
'User Defined Functions Start
'------------------------------------------------
Public Function AnsiZtoString(ByVal strz As Long) As String
'---ErrPtnr-OnError-START--- DO NOT MODIFY ! ---
On Error GoTo ErrPtnr_OnError
'---ErrPtnr-OnError-END--- DO NOT MODIFY ! ---
50010     Rem We need to convert from a byte buffer to a string
50020     Dim byteCh(1) As Byte
50030     Dim bOK As Boolean
50040     bOK = True
50050     Dim ptrByte As Long
50060     ptrByte = VarPtr(byteCh(0))
50070     Dim j As Long
50080     j = 0
50090     Dim str As String
50100     While bOK
50110         ' This is how to do pointer arithmetic!
50120         MoveMemoryLong ptrByte, strz + j, 1
50130         If byteCh(0) = 0 Then
50140             bOK = False
50150         Else
50160             str = str + Chr(byteCh(0))
50170         End If
50180         j = j + 1
50190     Wend
50200     AnsiZtoString = str
'---ErrPtnr-OnError-START--- DO NOT MODIFY ! ---
Exit Function
ErrPtnr_OnError:
  Call ErrPtnr.OnError("modGsApi", "AnsiZtoString")
'Case 0: Resume
'Case 1: Resume Next
'Case 2: Exit Function
'Case 3: End
'End Select
'---ErrPtnr-OnError-END--- DO NOT MODIFY ! ---
End Function

Public Function CheckRevision(ByVal intRevision As Long) As Boolean
'---ErrPtnr-OnError-START--- DO NOT MODIFY ! ---
On Error GoTo ErrPtnr_OnError
'---ErrPtnr-OnError-END--- DO NOT MODIFY ! ---
50010     ' Check revision number of Ghostscript
50020     Dim intReturn As Long
50030     Dim udtGSRevInfo As GS_Revision
50040     intReturn = gsapi_revision(VarPtr(udtGSRevInfo), 16)
50050     Dim str As String
50060     str = "Revision=" & udtGSRevInfo.intRevision
50070     str = str & "  RevisionDate=" & udtGSRevInfo.intRevisionDate
50080     str = str & "  Product=" & AnsiZtoString(udtGSRevInfo.strProduct)
50090     str = str & "  Copyright = " & AnsiZtoString(udtGSRevInfo.strCopyright)
50100     IfLoggingWriteLogfile str
50110     'MsgBox (str)
50120
50130     If udtGSRevInfo.intRevision = intRevision Then
50140         CheckRevision = True
50150     Else
50160         CheckRevision = False
50170     End If
'---ErrPtnr-OnError-START--- DO NOT MODIFY ! ---
Exit Function
ErrPtnr_OnError:
  Call ErrPtnr.OnError("modGsApi", "CheckRevision")
'Case 0: Resume
'Case 1: Resume Next
'Case 2: Exit Function
'Case 3: End
'End Select
'---ErrPtnr-OnError-END--- DO NOT MODIFY ! ---
End Function

Public Function CallGS(ByRef astrGSArgs() As String) As Boolean
'---ErrPtnr-OnError-START--- DO NOT MODIFY ! ---
On Error GoTo ErrPtnr_OnError
'---ErrPtnr-OnError-END--- DO NOT MODIFY ! ---
50010  Dim intReturn As Long
50020  Dim intGSInstanceHandle As Long
50030  Dim aAnsiArgs() As String
50040  Dim aPtrArgs() As Long
50050  Dim intCounter As Long
50060  Dim intElementCount As Long
50070  Dim ITemp As Long
50080  Dim callerHandle As Long
50090  Dim ptrArgs As Long
50100  Dim sFile As String
50110
50120     ' Print out the revision details.
50130     ' If we want to insist on a particular version of Ghostscript
50140     ' we should check the return value of CheckRevision().
50150     'CheckRevision (705)
50160
50170     ' Load Ghostscript and get the instance handle
50180     GS_OutStr = ""
50190     intReturn = gsapi_new_instance(intGSInstanceHandle, callerHandle)
50200     If (intReturn < 0) Then
50210      CallGS = False
50220      IfLoggingWriteLogfile "Error: " & GS_OutStr
50230      Exit Function
50240     End If
50250
50260     ' Capture stdio
50270     intReturn = gsapi_set_stdio(intGSInstanceHandle, AddressOf gsdll_stdin, AddressOf gsdll_stdout, AddressOf gsdll_stderr)
50280
50290     If (intReturn >= 0) Then
50300         ' Convert the Unicode strings to null terminated ANSI byte arrays
50310         ' then get pointers to the byte arrays.
50320         intElementCount = UBound(astrGSArgs)
50330         ReDim aAnsiArgs(intElementCount)
50340         ReDim aPtrArgs(intElementCount)
50350
50360         For intCounter = 0 To intElementCount
50370             aAnsiArgs(intCounter) = StrConv(astrGSArgs(intCounter), vbFromUnicode)
50380             aPtrArgs(intCounter) = StrPtr(aAnsiArgs(intCounter))
50390         Next
50400         ptrArgs = VarPtr(aPtrArgs(0))
50410
50420         intReturn = gsapi_init_with_args(intGSInstanceHandle, intElementCount + 1, ptrArgs)
50430
50440         ' Stop the Ghostscript interpreter
50450         gsapi_exit (intGSInstanceHandle)
50460     End If
50470
50480     ' release the Ghostscript instance handle
50490     gsapi_delete_instance (intGSInstanceHandle)
50500 '    Debug.Print intReturn
50510     If (intReturn >= 0) Then
50520       CallGS = True
50530      Else
50540       If intReturn <> e_Quit And intReturn <> e_Info Then
50550        GhostscriptError = intReturn
50560        IfLoggingWriteLogfile "Error: " & Replace$(GS_OutStr, vbCrLf, "; ")
50570       End If
50580       CallGS = False
50590     End If
50600
'---ErrPtnr-OnError-START--- DO NOT MODIFY ! ---
Exit Function
ErrPtnr_OnError:
  Call ErrPtnr.OnError("modGsApi", "CallGS")
'Case 0: Resume
'Case 1: Resume Next
'Case 2: Exit Function
'Case 3: End
'End Select
'---ErrPtnr-OnError-END--- DO NOT MODIFY ! ---
End Function

Public Function GetGhostscriptRevision() As tGhostscriptRevision
'---ErrPtnr-OnError-START--- DO NOT MODIFY ! ---
On Error GoTo ErrPtnr_OnError
'---ErrPtnr-OnError-END--- DO NOT MODIFY ! ---
50010  Dim intReturn As Long, udtGSRevInfo As GS_Revision
50020  intReturn = gsapi_revision(VarPtr(udtGSRevInfo), 16)
50030  With GetGhostscriptRevision
50040   .intRevision = udtGSRevInfo.intRevision
50050   .intRevisionDate = udtGSRevInfo.intRevisionDate
50060   .strCopyright = AnsiZtoString(udtGSRevInfo.strCopyright)
50070   .strProduct = AnsiZtoString(udtGSRevInfo.strProduct)
50080  End With
'---ErrPtnr-OnError-START--- DO NOT MODIFY ! ---
Exit Function
ErrPtnr_OnError:
  Call ErrPtnr.OnError("modGsApi", "GetGhostscriptRevision")
'Case 0: Resume
'Case 1: Resume Next
'Case 2: Exit Function
'Case 3: End
'End Select
'---ErrPtnr-OnError-END--- DO NOT MODIFY ! ---
End Function


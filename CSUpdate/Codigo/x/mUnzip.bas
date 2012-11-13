Attribute VB_Name = "mUnzip"
Option Explicit

' ======================================================================================
' Name:     mUnzip
' Author:   Steve McMahon (steve@vbaccelerator.com)
' Date:     1 January 2000
'
' Requires: Info-ZIP's Unzip32.DLL v5.40, renamed to vbuzip10.dll
'           cUnzip.cls
'
' Copyright © 2000 Steve McMahon for vbAccelerator
' --------------------------------------------------------------------------------------
' Visit vbAccelerator - advanced free source code for VB programmers
' http://vbaccelerator.com
' --------------------------------------------------------------------------------------
'
' Part of the implementation of cUnzip.cls, a class which gives a
' simple interface to Info-ZIP's excellent, free unzipping library
' (Unzip32.DLL).
'
' This sample uses decompression code by the Info-ZIP group.  The
' original Info-Zip sources are freely available from their website
' at
'     http://www.cdrcom.com/pubs/infozip/
'
' Please ensure you visit the site and read their free source licensing
' information and requirements before using their code in your own
' application.
'
' ======================================================================================

Private Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" ( _
    lpvDest As Any, lpvSource As Any, ByVal cbCopy As Long)

' argv
Private Type UNZIPnames
    s(0 To 1023) As String
End Type

' Callback large "string" (sic)
Private Type CBChar
    ch(0 To 32800) As Byte
End Type

' Callback small "string" (sic)
Private Type CBCh
    ch(0 To 255) As Byte
End Type

' DCL structure
Public Type DCLIST
   ExtractOnlyNewer As Long      ' 1 to extract only newer
   SpaceToUnderScore As Long     ' 1 to convert spaces to underscore
   PromptToOverwrite As Long     ' 1 if overwriting prompts required
   fQuiet As Long                ' 0 = all messages, 1 = few messages, 2 = no messages
   ncflag As Long                ' write to stdout if 1
   ntflag As Long                ' test zip file
   nvflag As Long                ' verbose listing
   nUflag As Long                ' "update" (extract only newer/new files)
   nzflag As Long                ' display zip file comment
   ndflag As Long                ' all args are files/dir to be extracted
   noflag As Long                ' 1 if always overwrite files
   naflag As Long                ' 1 to do end-of-line translation
   nZIflag As Long               ' 1 to get zip info
   C_flag As Long                ' 1 to be case insensitive
   fPrivilege As Long            ' zip file name
   lpszZipFN As String           ' directory to extract to.
   lpszExtractDir As String
End Type

Private Type USERFUNCTION
   ' Callbacks:
   lptrPrnt As Long           ' Pointer to application's print routine
   lptrSound As Long          ' Pointer to application's sound routine.  NULL if app doesn't use sound
   lptrReplace As Long        ' Pointer to application's replace routine.
   lptrPassword As Long       ' Pointer to application's password routine.
   lptrMessage As Long        ' Pointer to application's routine for
                              ' displaying information about specific files in the archive
                              ' used for listing the contents of the archive.
   lptrService As Long        ' callback function designed to be used for allowing the
                              ' app to process Windows messages, or cancelling the operation
                              ' as well as giving option of progress.  If this function returns
                              ' non-zero, it will terminate what it is doing.  It provides the app
                              ' with the name of the archive member it has just processed, as well
                              ' as the original size.
                              
   ' Values filled in after processing:
   lTotalSizeComp As Long     ' Value to be filled in for the compressed total size, excluding
                              ' the archive header and central directory list.
   lTotalSize As Long         ' Total size of all files in the archive
   lCompFactor As Long        ' Overall archive compression factor
   lNumMembers As Long        ' Total number of files in the archive
   cchComment As Integer      ' Flag indicating whether comment in archive.
End Type

Public Type ZIPVERSIONTYPE
   major As Byte
   minor As Byte
   patchlevel As Byte
   not_used As Byte
End Type

Public Type UZPVER
    structlen As Long         ' Length of structure
    flag As Long              ' 0 is beta, 1 uses zlib
    betalevel As String * 10  ' e.g "g BETA"
    date As String * 20       ' e.g. "4 Sep 95" (beta) or "4 September 1995"
    zlib As String * 10       ' e.g. "1.0.5 or NULL"
    Unzip As ZIPVERSIONTYPE
    zipinfo As ZIPVERSIONTYPE
    os2dll As ZIPVERSIONTYPE
    windll As ZIPVERSIONTYPE
End Type

Private Declare Function Wiz_SingleEntryUnzip Lib "vbuzip10.dll" _
  (ByVal ifnc As Long, ByRef ifnv As UNZIPnames, _
   ByVal xfnc As Long, ByRef xfnv As UNZIPnames, _
   dcll As DCLIST, Userf As USERFUNCTION) As Long
Public Declare Sub UzpVersion2 Lib "vbuzip10.dll" (uzpv As UZPVER)

' Object for callbacks:
Private m_cUnzip As cUnzip
Private m_bCancel As Boolean

Private Function plAddressOf(ByVal lPtr As Long) As Long
   ' VB Bug workaround fn
   plAddressOf = lPtr
End Function

Private Sub UnzipMessageCallBack( _
      ByVal ucsize As Long, _
      ByVal csiz As Long, _
      ByVal cfactor As Integer, _
      ByVal mo As Integer, _
      ByVal dy As Integer, _
      ByVal yr As Integer, _
      ByVal hh As Integer, _
      ByVal mm As Integer, _
      ByVal c As Byte, _
      ByRef fname As CBCh, _
      ByRef meth As CBCh, _
      ByVal crc As Long, _
      ByVal fCrypt As Byte _
   )
Dim sFileName As String
Dim sFolder As String
Dim dDate As Date
Dim sMethod As String
Dim iPos As Long

   On Error Resume Next
    
   ' Add to unzip class:
   With m_cUnzip
      ' Parse:
      sFileName = StrConv(fname.ch, vbUnicode)
      ParseFileFolder sFileName, sFolder
      dDate = DateSerial(yr, mo, hh)
      dDate = dDate + TimeSerial(hh, mm, 0)
      sMethod = StrConv(meth.ch, vbUnicode)
      iPos = InStr(sMethod, vbNullChar)
      If (iPos > 1) Then
         sMethod = Left$(sMethod, iPos - 1)
      End If
    
      Debug.Print fCrypt
      .DirectoryListAddFile sFileName, sFolder, dDate, csiz, crc, ((fCrypt And 64) = 64), cfactor, sMethod
   End With
   
End Sub

Private Function UnzipPrintCallback( _
      ByRef fname As CBChar, _
      ByVal x As Long _
   ) As Long
Dim iPos As Long
Dim sFIle As String
   On Error Resume Next
   
   ' Check we've got a message:
   If x > 1 And x < 1024 Then
      ' If so, then get the readable portion of it:
      ReDim b(0 To x) As Byte
      CopyMemory b(0), fname, x
      ' Convert to VB string:
      sFIle = StrConv(b, vbUnicode)
      
      ' Fix up backslashes:
      ReplaceSection sFIle, "/", "\"
      
      ' Tell the caller about it
      m_cUnzip.ProgressReport sFIle
   End If
   UnzipPrintCallback = 0
End Function

Private Function UnzipPasswordCallBack( _
      ByRef pwd As CBCh, _
      ByVal x As Long, _
      ByRef s2 As CBCh, _
      ByRef Name As CBCh _
   ) As Long

Dim bCancel As Boolean
Dim sPassword As String
Dim b() As Byte
Dim lSize As Long

On Error Resume Next

   ' The default:
   UnzipPasswordCallBack = 1
    
   If m_bCancel Then
      Exit Function
   End If
   
   ' Ask for password:
   m_cUnzip.PasswordRequest sPassword, bCancel
      
   sPassword = Trim$(sPassword)
   
   ' Cancel out if no useful password:
   If bCancel Or Len(sPassword) = 0 Then
      m_bCancel = True
      Exit Function
   End If
   
   ' Put password into return parameter:
   lSize = Len(sPassword)
   If lSize > 254 Then
      lSize = 254
   End If
   b = StrConv(sPassword, vbFromUnicode)
   CopyMemory pwd.ch(0), b(0), lSize
   
   ' Ask UnZip to process it:
   UnzipPasswordCallBack = 0
       
End Function

Private Function UnzipReplaceCallback(ByRef fname As CBChar) As Long
Dim eResponse As EUZOverWriteResponse
Dim iPos As Long
Dim sFIle As String

   On Error Resume Next
   eResponse = euzDoNotOverwrite
   
   ' Extract the filename:
   sFIle = StrConv(fname.ch, vbUnicode)
   iPos = InStr(sFIle, vbNullChar)
   If (iPos > 1) Then
      sFIle = Left$(sFIle, iPos - 1)
   End If
   
   ' No backslashes:
   ReplaceSection sFIle, "/", "\"
   
   ' Request the overwrite request:
   m_cUnzip.OverwriteRequest sFIle, eResponse
   
   ' Return it to the zipping lib
   UnzipReplaceCallback = eResponse
   
End Function
Private Function UnZipServiceCallback(ByRef mname As CBChar, ByVal x As Long) As Long
Dim iPos As Long
Dim sInfo As String
Dim bCancel As Boolean
    
'-- Always Put This In Callback Routines!
On Error Resume Next
    
   ' Check we've got a message:
   If x > 1 And x < 1024 Then
      ' If so, then get the readable portion of it:
      ReDim b(0 To x) As Byte
      CopyMemory b(0), mname, x
      ' Convert to VB string:
      sInfo = StrConv(b, vbUnicode)
      iPos = InStr(sInfo, vbNullChar)
      If iPos > 0 Then
         sInfo = Left$(sInfo, iPos - 1)
      End If
      ReplaceSection sInfo, "\", "/"
      m_cUnzip.Service sInfo, bCancel
      If bCancel Then
         UnZipServiceCallback = 1
      Else
         UnZipServiceCallback = 0
      End If
   End If
   
End Function



Private Sub ParseFileFolder( _
      ByRef sFileName As String, _
      ByRef sFolder As String _
   )
Dim iPos As Long
Dim iLastPos As Long

   iPos = InStr(sFileName, vbNullChar)
   If (iPos <> 0) Then
      sFileName = Left$(sFileName, iPos - 1)
   End If
   
   iLastPos = ReplaceSection(sFileName, "/", "\")
   
   If (iLastPos > 1) Then
      sFolder = Left$(sFileName, iLastPos - 2)
      sFileName = Mid$(sFileName, iLastPos)
   End If
   
End Sub
Private Function ReplaceSection(ByRef sString As String, ByVal sToReplace As String, ByVal sReplaceWith As String) As Long
Dim iPos As Long
Dim iLastPos As Long
   iLastPos = 1
   Do
      iPos = InStr(iLastPos, sString, "/")
      If (iPos > 1) Then
         Mid$(sString, iPos, 1) = "\"
         iLastPos = iPos + 1
      End If
   Loop While Not (iPos = 0)
   ReplaceSection = iLastPos

End Function

' Main subroutine
Public Function VBUnzip( _
      cUnzipObject As cUnzip, _
      tDCL As DCLIST, _
      iIncCount As Long, _
      sInc() As String, _
      iExCount As Long, _
      sExc() As String _
   ) As Long
Dim tUser As USERFUNCTION
Dim lR As Long
Dim tInc As UNZIPnames
Dim tExc As UNZIPnames
Dim i As Long

On Error GoTo ErrorHandler

   Set m_cUnzip = cUnzipObject
   ' Set Callback addresses
   tUser.lptrPrnt = plAddressOf(AddressOf UnzipPrintCallback)
   tUser.lptrSound = 0& ' not supported
   tUser.lptrReplace = plAddressOf(AddressOf UnzipReplaceCallback)
   tUser.lptrPassword = plAddressOf(AddressOf UnzipPasswordCallBack)
   tUser.lptrMessage = plAddressOf(AddressOf UnzipMessageCallBack)
   tUser.lptrService = plAddressOf(AddressOf UnZipServiceCallback)
        
   ' Set files to include/exclude:
   If (iIncCount > 0) Then
      For i = 1 To iIncCount
         tInc.s(i - 1) = sInc(i)
      Next i
      tInc.s(iIncCount) = vbNullChar
   Else
      tInc.s(0) = vbNullChar
   End If
   If (iExCount > 0) Then
      For i = 1 To iExCount
         tExc.s(i - 1) = sExc(i)
      Next i
      tExc.s(iExCount) = vbNullChar
   Else
      tExc.s(0) = vbNullChar
   End If
   m_bCancel = False
   VBUnzip = Wiz_SingleEntryUnzip(iIncCount, tInc, iExCount, tExc, tDCL, tUser)
    
    'Debug.Print "--------------"
    'Debug.Print MYUSER.cchComment
    'Debug.Print MYUSER.TotalSizeComp
    'Debug.Print MYUSER.TotalSize
    'Debug.Print MYUSER.CompFactor
    'Debug.Print MYUSER.NumMembers
    'Debug.Print "--------------"

   Exit Function
   
ErrorHandler:
Dim lErr As Long, sErr As Long
   lErr = Err.Number: sErr = Err.Description
   VBUnzip = -1
   Set m_cUnzip = Nothing
   Err.Raise lErr, App.EXEName & ".VBUnzip", sErr
   Exit Function

End Function

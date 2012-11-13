VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cZip"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

' ======================================================================================
' Name:     vbAccelerator cUnzip class
' Author:   Steve McMahon (steve@vbaccelerator.com)
' Date:     1 January 2000
'
' Requires: Info-ZIP's Zip32.DLL v2.32, renamed to vbzip10.dll
'           mZip.bas
'
' Copyright © 2000 Steve McMahon for vbAccelerator
' --------------------------------------------------------------------------------------
' Visit vbAccelerator - advanced free source code for VB programmers
' http://vbaccelerator.com
' --------------------------------------------------------------------------------------
'
' Part of the implementation of cUnzip.cls, a class which gives a
' simple interface to Info-ZIP's excellent, free zipping library
' (Zip32.DLL).
'
' ======================================================================================


Public Enum EZPMsgLevel
   ezpAllMessages = 0
   ezpPartialMessages = 1
   ezpNoMessages = 2
End Enum

Public Event Cancel(ByVal sMsg As String, ByRef bCancel As Boolean)
Public Event PasswordRequest(ByRef sPassword As String, ByVal lMaxPasswordLength As Long, ByVal bConfirm As Boolean, ByRef bCancel As Boolean)
Public Event CommentRequest(ByRef sComment As String, ByRef bCancel As Boolean)
Public Event Progress(ByVal lCount As Long, ByVal sMsg As String)


Private m_tZPOPT As ZPOPT
Private m_sFileName As String
Private m_sFileSpecs() As String
Private m_iCount As Long
Private m_lR As Long

' Set zip options
' m_tZPOPT.fSuffix = 0        ' include suffixes (not yet implemented)
' m_tZPOPT.fExtra = 0         ' 1 if including extra attributes
' m_tZPOPT.date = vbNullString ' "12/31/79"? US Date?
' m_tZPOPT.fExcludeDate = 0   ' 1 if excluding files earlier than a specified date
' m_tZPOPT.fIncludeDate = 0   ' 1 if including files earlier than a specified date
' m_tZPOPT.fJunkSFX = 0       ' 1 if junking sfx prefix
' m_tZPOPT.fOffsets = 0       ' 1 if updating archive offsets for sfx Files

' m_tZPOPT.fComment = 0       ' 1 if putting comment in zip file

' m_tZPOPT.fGrow = 0          ' 1 if allow appending to zip file
' m_tZPOPT.fForce = 0         ' 1 if making entries using DOS names
' m_tZPOPT.fMove = 0          ' 1 if deleting files added or updated
' m_tZPOPT.fDeleteEntries = 0 ' 1 if files passed have to be deleted
' m_tZPOPT.fLatestTime = 0    ' 1 if setting zip file time to time of latest file in archive
' m_tZPOPT.fPrivilege = 0     ' 1 if not saving privileges
' m_tZPOPT.fEncryption = 0    'Read only property!
' m_tZPOPT.fRepair = 0        ' 1=> fix archive, 2=> try harder to fix
' m_tZPOPT.flevel = 0         ' compression level - should be 0!!!



Public Property Get ZipFile() As String
   ZipFile = m_sFileName
End Property
Public Property Let ZipFile(ByVal sFileName As String)
   m_sFileName = sFileName
End Property
Public Property Get BasePath() As String
   BasePath = m_tZPOPT.szRootDir
End Property
Public Property Let BasePath(ByVal sBasePath As String)
   m_tZPOPT.szRootDir = sBasePath
End Property
Public Property Get Encrypt() As Boolean
   Encrypt = Not (m_tZPOPT.fEncrypt = 0)
End Property
Public Property Let Encrypt(ByVal bState As Boolean)
   m_tZPOPT.fEncrypt = Abs(bState)
End Property
Public Property Get AddComment() As Boolean
   Encrypt = Not (m_tZPOPT.fComment = 0)
End Property
Public Property Let AddComment(ByVal bState As Boolean)
   m_tZPOPT.fComment = Abs(bState)
End Property
Public Property Get IncludeSystemAndHiddenFiles() As Boolean
    IncludeSystemAndHiddenFiles = Not (m_tZPOPT.fSystem = 0)       ' 1 to include system/hidden files
End Property
Public Property Let IncludeSystemAndHiddenFiles(ByVal bState As Boolean)
   m_tZPOPT.fSystem = Abs(bState)       ' 1 to include system/hidden files
End Property
Public Property Get StoreVolumeLabel() As Boolean
    StoreVolumeLabel = Not (m_tZPOPT.fVolume = 0)       ' 1 if storing volume label
End Property
Public Property Let StoreVolumeLabel(ByVal bState As Boolean)
   m_tZPOPT.fVolume = Abs(bState)
End Property
Public Property Get StoreDirectories() As Boolean
   StoreDirectories = Not (m_tZPOPT.fNoDirEntries = 0) ' 1 if ignoring directory entries
End Property
Public Property Let StoreDirectories(ByVal bState As Boolean)
   m_tZPOPT.fNoDirEntries = Abs(Not (bState))
End Property
Public Property Get StoreFolderNames() As Boolean
   StoreFolderNames = (m_tZPOPT.fJunkDir = 0)
End Property
Public Property Let StoreFolderNames(ByVal bState As Boolean)
   m_tZPOPT.fJunkDir = Abs(Not (bState))
End Property
Public Property Get RecurseSubDirs() As Boolean
   RecurseSubDirs = Not (m_tZPOPT.fRecurse = 0) ' 1 if recursing into subdirectories
End Property
Public Property Let RecurseSubDirs(ByVal bState As Boolean)
   If bState Then
      m_tZPOPT.fRecurse = 2
   Else
      m_tZPOPT.fRecurse = 0
   End If
End Property

Public Property Get UpdateOnlyIfNewer() As Boolean
    UpdateOnlyIfNewer = Not (m_tZPOPT.fUpdate = 0)   ' 1 if updating zip file--overwrite only if newer
End Property
Public Property Let UpdateOnlyIfNewer(ByVal bState As Boolean)
    m_tZPOPT.fUpdate = Abs(bState)   ' 1 if updating zip file--overwrite only if newer
End Property
Public Property Get FreshenFiles() As Boolean
    FreshenFiles = Not (m_tZPOPT.fFreshen = 0) ' 1 if freshening zip file--overwrite only
End Property
Public Property Let FreshenFiles(ByVal bState As Boolean)
    m_tZPOPT.fUpdate = Abs(bState)   ' 1 if updating zip file--overwrite only if newer
End Property
Public Property Get MessageLevel() As EZPMsgLevel
   If Not (m_tZPOPT.fVerbose = 0) Then
      MessageLevel = ezpAllMessages
   ElseIf Not (m_tZPOPT.fQuiet = 0) Then
      MessageLevel = ezpPartialMessages
   Else
      MessageLevel = ezpNoMessages
   End If
End Property
Public Property Let MessageLevel(ByVal eLevel As EZPMsgLevel)
   Select Case eLevel
   Case ezpPartialMessages
      m_tZPOPT.fQuiet = 1
      m_tZPOPT.fVerbose = 0
   Case ezpNoMessages
      m_tZPOPT.fQuiet = 0
      m_tZPOPT.fVerbose = 0
   Case ezpAllMessages
      m_tZPOPT.fQuiet = 0
      m_tZPOPT.fVerbose = 1
   End Select
End Property
Public Property Get ConvertCRLFToLF() As Boolean
   ConvertCRLFToLF = (m_tZPOPT.fCRLF_LF <> 0)
End Property
Public Property Let ConvertCRLFToLF(ByVal bState As Boolean)
   m_tZPOPT.fCRLF_LF = Abs(bState)
End Property
Public Property Get ConvertLFToCRLF() As Boolean
   ConvertLFToCRLF = (m_tZPOPT.fLF_CRLF <> 0)
End Property
Public Property Let ConvertLFToCRLF(ByVal bState As Boolean)
   m_tZPOPT.fLF_CRLF = Abs(bState)
End Property

Friend Sub ProgressReport( _
      ByVal sMsg As String _
   )
   RaiseEvent Progress(1, sMsg)
End Sub
Friend Sub PasswordRequest( _
      ByRef sPassword As String, _
      ByVal lMaxPasswordLength As Long, _
      ByVal bPasswordConfirm As Boolean, _
      ByRef bCancel As Boolean _
   )
   RaiseEvent PasswordRequest(sPassword, lMaxPasswordLength, bPasswordConfirm, bCancel)
End Sub
Friend Sub CommentRequest( _
      ByRef sComment As String, _
      ByRef bCancel As Boolean _
   )
   RaiseEvent CommentRequest(sComment, bCancel)
End Sub
Friend Sub Service( _
      ByVal sMsg As String, _
      ByRef bCancel As Boolean _
   )
   RaiseEvent Cancel(sMsg, bCancel)
End Sub
Public Sub ClearFileSpecs()
   m_iCount = 0
   Erase m_sFileSpecs()
End Sub
Public Function AddFileSpec(ByVal sSpec As String) As Long
   m_iCount = m_iCount + 1
   ReDim Preserve m_sFileSpecs(1 To m_iCount) As String
   m_sFileSpecs(m_iCount) = sSpec
End Function
Public Property Get FileSpecCount() As Long
   FileSpecCount = m_iCount
End Property
Public Property Get FileSpec(ByVal nIndex As Long)
   FileSpec = m_sFileSpecs(nIndex)
End Property
Public Property Get AllowAppend() As Boolean
   AllowAppend = (m_tZPOPT.fGrow = 1)
End Property
Public Property Let AllowAppend(ByVal bState As Boolean)
   m_tZPOPT.fGrow = Abs(bState)
End Property
Public Sub Zip()
   m_lR = 0
   m_lR = mZip.VBZip(Me, m_tZPOPT, m_sFileSpecs(), m_iCount)
End Sub
Public Property Get Success() As Boolean
   Success = (m_lR = 0)
End Property
Public Sub Delete()
   ' Deletes the entries specified by the file specs:
   m_tZPOPT.fDeleteEntries = 1
   mZip.VBZip Me, m_tZPOPT, m_sFileSpecs(), m_iCount
   m_tZPOPT.fDeleteEntries = 0
End Sub

Private Sub Class_Initialize()
   StoreDirectories = False
   StoreFolderNames = False
   RecurseSubDirs = False
End Sub

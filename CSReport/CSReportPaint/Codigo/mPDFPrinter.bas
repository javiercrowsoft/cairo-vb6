Attribute VB_Name = "mPDFPrinter"
Option Explicit


' profile info
Public Const NOVAPDF_CURRENT_PROFILE                As String = "ActiveProfile"

Public Const NOVAPDF_ASK_SAVE_PROFILE               As String = "AskSaveProfile" ' bool
Public Const NOVAPDF_PAPER_OVERRIDE                 As String = "OverridePaper" ' bool
Public Const NOVAPDF_SILENT_PRINT                   As String = "SilentPrint" ' bool
Public Const NOVAPDF_PROFILE_ALLOWCHANGE            As String = "AllowChangeProfile" ' bool
Public Const NOVAPDF_PUBLIC_PROFILE                 As String = "PublicProfile" ' bool
Public Const NOVAPDF_PDF_VERSION                    As String = "PDFVersion" ' int
Public Const NOVAPDF_PROPAGATE_DEFAULT              As String = "PropagateDefaultProfile" 'bool
Public Const NOVAPDF_SHOW_PRIVATE                   As String = "ShowPrivateProfiles" ' bool

' compression settings
Public Const NOVAPDF_USE_TEXT_COMPRESSION           As String = "Use Text Compression" ' bool
Public Const NOVAPDF_USE_IMAGE_COMPRESSION          As String = "Use Image Compression" ' bool
Public Const NOVAPDF_USE_MONOCHROME_COMPRESSION     As String = "Use Monochrome Image Compression" ' bool
Public Const NOVAPDF_TEXT_COMPRESSION_METHOD        As String = "Text Compression Method" ' string
Public Const NOVAPDF_TEXT_COMPRESSION_LEVEL         As String = "Text Compression Level" ' int
Public Const NOVAPDF_IMAGE_COMPRESSION_METHOD       As String = "Image Compression Method" ' string
Public Const NOVAPDF_IMAGE_COMPRESSION_LEVEL        As String = "Image Compression Level" ' int
Public Const NOVAPDF_MONOCHROME_COMPRESSION_METHOD  As String = "Monochrome Compression Method" ' string
Public Const NOVAPDF_MONOCHROME_COMPRESSION_LEVEL   As String = "Monochrome Compression Level" ' int
Public Const NOVAPDF_IMAGE_OPTIMIZATION             As String = "Image Optimization" ' bool
Public Const NOVAPDF_USE_INDEXED_COMPRESSION        As String = "Use Indexed Image Compression" ' bool
Public Const NOVAPDF_INDEXED_COMPRESSION_METHOD     As String = "Indexed Compression Method" ' string
Public Const NOVAPDF_INDEXED_COMPRESSION_LEVEL      As String = "Indexed Compression Level" ' int
Public Const NOVAPDF_CORRECT_LINE_WIDTHS            As String = "Correct Line Widths" ' bool
Public Const NOVAPDF_CORRECT_FILL_COLORS            As String = "Correct Fill Colors" ' bool

' Graphics
Public Const NOVAPDF_GR_DOWNSMPL_HIGH               As String = "Downsample High Color Img" ' bool
Public Const NOVAPDF_GR_DOSMPL_H_DPI                As String = "Downsample High Color Img DPI" ' int
Public Const NOVAPDF_GR_DOSMPL_H_TYPE               As String = "Downsample High Color Img Type" ' int
Public Const NOVAPDF_GR_DOWNSMPL_IND                As String = "Downsample Indexed Img" ' bool
Public Const NOVAPDF_GR_DOSMPL_I_DPI                As String = "Downsample Indexed Img DPI" ' int
Public Const NOVAPDF_GR_DOSMPL_I_TYPE               As String = "Downsample Indexed Img Type" ' int
Public Const NOVAPDF_GR_DOWNSMPL_MONO               As String = "Downsample Monochrome Img" ' bool
Public Const NOVAPDF_GR_DOSMPL_M_DPI                As String = "Downsample Monochrome Img DPI" ' int
Public Const NOVAPDF_GR_DOSMPL_M_TYPE               As String = "Downsample Monochrome Img Type" ' int
Public Const NOVAPDF_GR_CONVERT_HIGH                As String = "Convert High Color Img" ' bool
Public Const NOVAPDF_GR_CONVERT_IND                 As String = "Convert Indexed Img" ' bool
Public Const NOVAPDF_GR_CONVTYPE_HIGH               As String = "Convert High Color Img Type" ' int
Public Const NOVAPDF_GR_DITHERMONO_HIGH             As String = "Dither High Color Img" ' bool
Public Const NOVAPDF_GR_DITMONO_H_TYPE              As String = "Dither High Color Img Method" ' int
Public Const NOVAPDF_GR_CONVTYPE_IND                As String = "Convert Indexed Img Type" ' int
Public Const NOVAPDF_GR_DITHERMONO_IND              As String = "Dither Indexed Img" ' bool
Public Const NOVAPDF_GR_DITMONO_I_TYPE              As String = "Dither Indexed Img Method" ' int
Public Const NOVAPDF_GR_CONVERT_TEXT                As String = "Convert Text and Graphics" ' bool
Public Const NOVAPDF_GR_CONVTYPE_TEXT               As String = "Convert Text and Graphics Type" ' int
Public Const NOVAPDF_GR_MONOTEXT_TRASH              As String = "Convert Monochrome Text Trashold" ' int
Public Const NOVAPDF_GR_MONOHIGH_TRASH              As String = "Convert High Color Img Trashold" ' int
Public Const NOVAPDF_GR_MONOIND_TRASH               As String = "Convert Indexed Img Trashold" ' int
Public Const NOVAPDF_GR_CONFIGURATION               As String = "Graphics Configuration" ' int

' document info settings
Public Const NOVAPDF_INFO_AUTHOR                    As String = "Document Author" ' string
Public Const NOVAPDF_INFO_CREATOR                   As String = "Document Creator" ' string
Public Const NOVAPDF_INFO_KEYWORDS                  As String = "Document Keywords" ' string
Public Const NOVAPDF_INFO_SUBJECT                   As String = "Document Subject" ' string
Public Const NOVAPDF_INFO_TITLE                     As String = "Document Title" ' string
Public Const NOVAPDF_INFO_PAGE_LAYOUT               As String = "Document Page Layout" ' int
Public Const NOVAPDF_INFO_PAGE_MODE                 As String = "Document Page Mode" ' int
Public Const NOVAPDF_INFO_PAGE_NUMBER               As String = "Document Page Number" ' int
Public Const NOVAPDF_INFO_PAGE_MAGNIFICATION        As String = "Document Page Magnification" ' int
Public Const NOVAPDF_INFO_PAGE_MAGNIF_PERCENT       As String = "Document Magnification Percent" ' int
Public Const NOVAPDF_INFO_CREATION_DAY              As String = "Document Creation Day" ' int
Public Const NOVAPDF_INFO_CREATION_YEAR             As String = "Document Creation Year" ' int
Public Const NOVAPDF_INFO_CREATION_MONTH            As String = "Document Creation Month" ' int
Public Const NOVAPDF_INFO_CREATION_HOUR             As String = "Document Creation Hour" ' int
Public Const NOVAPDF_INFO_CREATION_MINUTE           As String = "Document Creation Minute" ' int
Public Const NOVAPDF_INFO_CREATION_SECOND           As String = "Document Creation Second" ' int
Public Const NOVAPDF_INFO_MODIFY_DAY                As String = "Document Modify Day" ' int
Public Const NOVAPDF_INFO_MODIFY_YEAR               As String = "Document Modify Year" ' int
Public Const NOVAPDF_INFO_MODIFY_MONTH              As String = "Document Modify Month" ' int
Public Const NOVAPDF_INFO_MODIFY_HOUR               As String = "Document Modify Hour" ' int
Public Const NOVAPDF_INFO_MODIFY_MINUTE             As String = "Document Modify Minute" ' int
Public Const NOVAPDF_INFO_MODIFY_SECOND             As String = "Document Modify Second" ' int

' security settings
Public Const NOVAPDF_SEC_PRINT                      As String = "AllowPrint" ' int
Public Const NOVAPDF_SEC_MODIFY                     As String = "AllowModify" ' int
Public Const NOVAPDF_SEC_COPYEX                     As String = "AllowCopyExtract" ' int
Public Const NOVAPDF_SEC_ANNOTF                     As String = "AllowAnnotForms" ' int
Public Const NOVAPDF_SEC_FILLF3                     As String = "AllowFillFormsRev3" ' int
Public Const NOVAPDF_SEC_EXTR3                      As String = "AllowExtractRev3" ' int
Public Const NOVAPDF_SEC_MODIFY3                    As String = "AllowModPagesRev3" ' int
Public Const NOVAPDF_SEC_PRINT3                     As String = "AllowPrintRev3" ' int
Public Const NOVAPDF_SEC_USER                       As String = "User Password" ' string
Public Const NOVAPDF_SEC_OWNER                      As String = "Owner Password" ' string
Public Const NOVAPDF_SEC_LEVEL                      As String = "Level" ' int

' font settings
Public Const NOVAPDF_EMBED_ALL_FONTS                As String = "Embed All Fonts" ' bool
Public Const NOVAPDF_EMBED_FONT_SUBSET              As String = "Embed Font Subset" ' bool
Public Const NOVAPDF_USE_ALWAYS_EMBED_FONTS_LIST    As String = "Use Embed Fonts List" ' bool
Public Const NOVAPDF_USE_NEVER_EMBED_FONTS_LIST     As String = "Use Never Embed Fonts List" ' bool
Public Const NOVAPDF_ALWAYS_EMBED_FONTS_LIST        As String = "Always Embed Fonts List" ' string, font names separated by ';'
Public Const NOVAPDF_NEVER_EMBED_FONTS_LIST         As String = "Never Embed Fonts List" ' string, font names separated by ';'

' save settings
Public Const NOVAPDF_SAVE_PROMPT                    As String = "Prompt Save Dialog" ' bool
Public Const NOVAPDF_SAVE_FOLDER                    As String = "Save Folder" ' string
Public Const NOVAPDF_SAVE_FILE                      As String = "Save File" ' string
Public Const NOVAPDF_SAVE_CONFLICT_STRATEGY         As String = "File Conflict Strategy" ' int
Public Const NOVAPDF_SAVE_DESTINATION               As String = "Save Local" ' bool
Public Const NOVAPDF_SAVE_FOLDER_ASK                As String = "Save Folder Ask" ' string
Public Const NOVAPDF_SAVE_FILE_ASK                  As String = "Save File Ask" ' string

' action settings
Public Const NOVAPDF_ACTION_OPEN_DOCUMENT           As String = "Post Save Open" ' bool
Public Const NOVAPDF_ACTION_USE_DEFAULT_VIEWER      As String = "Use Default Viewer" ' bool
Public Const NOVAPDF_ACTION_APPLICATION             As String = "Action Application" ' string
Public Const NOVAPDF_ACTION_ARGUMENTS               As String = "Action Arguments" ' string

' page options
Public Const NOVAPDF_PAGE_FORM                      As String = "Page Form" ' string
Public Const NOVAPDF_PAGE_MARGIN_LEFT               As String = "Margin Left" ' int (1/1000 mm)
Public Const NOVAPDF_PAGE_MARGIN_RIGHT              As String = "Margin Right" ' int (1/1000 mm)
Public Const NOVAPDF_PAGE_MARGIN_TOP                As String = "Margin Top" ' int (1/1000 mm)
Public Const NOVAPDF_PAGE_MARGIN_BOTTOM             As String = "Margin Bottom" ' int (1/1000 mm)
Public Const NOVAPDF_PAGE_ORIGIN_TOP                As String = "Origin Top" ' int (1/1000 mm)
Public Const NOVAPDF_PAGE_ORIGIN_LEFT               As String = "Origin Left" ' int (1/1000 mm)
Public Const NOVAPDF_PAGE_ALIGN_RIGHT               As String = "Align Right Margin" ' bool
Public Const NOVAPDF_PAGE_ALIGN_BOTTOM              As String = "Align Bottom Margin" ' bool
Public Const NOVAPDF_PAGE_CENTER_HORZ               As String = "Center Horizontally" ' bool
Public Const NOVAPDF_PAGE_CENTER_VERT               As String = "Center Vertically" ' bool
Public Const NOVAPDF_PAGE_FIT_MARGINS               As String = "Fit Zoom to Margins" ' bool
Public Const NOVAPDF_PAGE_WIDTH                     As String = "Page Width" ' int (1/1000 mm)
Public Const NOVAPDF_PAGE_HEIGHT                    As String = "Page Height" ' int (1/1000 mm)
Public Const NOVAPDF_PAGE_ORIENTATION               As String = "Page Orientation" ' int (1 or 2)
Public Const NOVAPDF_PAGE_RESOLUTION                As String = "Page Resolution" ' int
Public Const NOVAPDF_PAGE_SCALE                     As String = "Page Scale" ' int (1 - 400) %
Public Const NOVAPDF_PAGE_ZOOM                      As String = "Page Zoom" ' int (1 - 400) % (* 1000)
Public Const NOVAPDF_PAGE_UNITS                     As String = "Page Units" ' int (0,1,2)
Public Const NOVAPDF_PAGE_SIZE                      As String = "Page Size" 'int
Public Const NOVAPDF_PAGE_CUSTOM_FORMS              As String = "Custom Forms" ' string, list of custom forms
Public Const NOVAPDF_PAGE_FORMS_VISIBILITY          As String = "Standard Forms Visibility Flags"
Public Const NOVAPDF_PAGE_CROPBOX                   As String = "Calculate CropBox"

' link / URL options
Public Const NOVAPDF_URL_ANALIZE                    As String = "AnalyzeUrAs String = " ' bool
Public Const NOVAPDF_URL_DETECT_FILES               As String = "DetectFiles" ' bool
Public Const NOVAPDF_URL_BORDER_TYPE                As String = "BorderType" ' int
Public Const NOVAPDF_URL_BORDER_STYLE               As String = "BorderStyle" ' int
Public Const NOVAPDF_URL_BORDER_WIDTH               As String = "BorderWidth" ' int
Public Const NOVAPDF_URL_BORDER_COLOR               As String = "BorderColor" ' dword
Public Const NOVAPDF_URL_COLOR_LINK                 As String = "UseLinkColor" ' bool
Public Const NOVAPDF_URL_CHECK_FILE_EXISTS          As String = "CheckFileExists" ' bool

'Email settings
Public Const NOVAPDF_EMAIL_SEND                     As String = "Send Email" 'int
Public Const NOVAPDF_EMAIL_TYPE                     As String = "Email Type" 'int
Public Const NOVAPDF_EMAIL_COMPRESS                 As String = "Email Compress PDF" 'int
Public Const NOVAPDF_EMAIL_TOADDRESS                As String = "Email To Address" 'string
Public Const NOVAPDF_EMAIL_CCADDRESS                As String = "Email CC Address" 'string
Public Const NOVAPDF_EMAIL_BCCADDRESS               As String = "Email BCC Address" 'string
Public Const NOVAPDF_EMAIL_SUBJECT                  As String = "Email Subject" 'string
Public Const NOVAPDF_EMAIL_BODY                     As String = "Email Body" 'string
Public Const NOVAPDF_EMAIL_FROMADDRESS              As String = "Email From Address" 'string
Public Const NOVAPDF_EMAIL_SMTP_SERVER              As String = "Email SMTP Server" 'string
Public Const NOVAPDF_EMAIL_SMTP_PORT                As String = "Email SMTP Port" 'int
Public Const NOVAPDF_EMAIL_SMTP_USER                As String = "Email SMTP User" 'string
Public Const NOVAPDF_EMAIL_SMTP_PASSWORD            As String = "Email SMTP Password" 'string
Public Const NOVAPDF_EMAIL_SMTP_AUTH                As String = "Email SMTP Authentification" 'int
Public Const NOVAPDF_EMAIL_SMTP_SSL                 As String = "Email SMTP SSL" 'int

' bookmarks settings
Public Const NOVAPDF_BMARK_EN_AUTO_DET_BMARKS       As String = "Bookmarks Detection Enabled" 'bool
Public Const NOVAPDF_BMARK_ALLOW_MULTILINE_BMARKS   As String = "Bookmarks Allow Multi-Line" 'bool
Public Const NOVAPDF_BMARK_MATCH_NODE_BMARKS        As String = "Bookmarks Match Nodes Regardless of Level" 'bool
Public Const NOVAPDF_BMARK_NOFLEVELS_BMARKS         As String = "Bookmarks Number of Levels to Consider" 'int
Public Const NOVAPDF_BMARK_TOLEVEL_BMARKS           As String = "Bookmarks Open up to Level" 'int

' Watermarks settings
Public Const NOVAPDF_WM_ENABLE                      As String = "Enable Watermarks"  'bool

'register Events Window handle
Public Const NOVAPDF_HWND_EVENTS                    As String = "EventsWindow" ' int

Public Const PDF_DEFAULT_PROFILE_NAME               As String = "Default Profile"

' compression related constants
Public Const COMPRESS_METHOD_ZIP                    As Integer = 0
Public Const COMPRESS_METHOD_JPEG                   As Integer = 1

' save options related constants
Public Const FILE_CONFLICT_STRATEGY_PROMPT          As Integer = 0
Public Const FILE_CONFLICT_STRATEGY_AUTONUMBER_NEW  As Integer = 1
Public Const FILE_CONFLICT_STRATEGY_APPEND_DATE     As Integer = 2
Public Const FILE_CONFLICT_STRATEGY_OVERWRITE       As Integer = 3
Public Const FILE_CONFLICT_STRATEGY_AUTONUMBER_EXIST As Integer = 4

' page layout related constants
Public Const PAGE_LAY_SINGLE                        As Integer = 0
Public Const PAGE_LAY_CONTINOUS                     As Integer = 1
Public Const PAGE_LAY_FACING                        As Integer = 2
Public Const PAGE_LAY_CONT_FACING                   As Integer = 3

' page mode related constants
Public Const PAGE_MODE_NONE                         As Integer = 0
Public Const PAGE_MODE_OUTLINES                     As Integer = 1
Public Const PAGE_MODE_PAGES                        As Integer = 2
Public Const PAGE_MODE_LAYERS                       As Integer = 3
Public Const PAGE_MODE_ATTACHMENTS                  As Integer = 4
Public Const PAGE_MODE_FULLSCREEN                   As Integer = 5

' page magnification
Public Const PAGE_MAGN_DEFAULT                      As Integer = 0
Public Const PAGE_MAGN_FITWIDTH                     As Integer = 1
Public Const PAGE_MAGN_FITHEIGHT                    As Integer = 2
Public Const PAGE_MAGN_FITPAGE                      As Integer = 3
Public Const PAGE_MAGN_PERCENT                      As Integer = 4

Public Const MEASURE_UNITS_INCHES                   As Integer = 0
Public Const MEASURE_UNITS_MM                       As Integer = 1
Public Const MEASURE_UNITS_POINTS                   As Integer = 2

' PDF security options related constants
Public Const SECURITY_NONE                          As Integer = 0
Public Const SECURITY_40BITS                        As Integer = 1
Public Const SECURITY_128BITS                       As Integer = 2

' link detection and highlighting related constants
Public Const BORDER_STYLE_SOLID                     As Integer = 0
Public Const BORDER_STYLE_DASHED                    As Integer = 1

Public Const BORDER_TYPE_NONE                       As Integer = 0
Public Const BORDER_TYPE_UNDERLINE                  As Integer = 1
Public Const BORDER_TYPE_RECTANGLE                  As Integer = 2

' email delivery method
Public Const EMAIL_TYPE_MAPI_NO_DLG                 As Integer = 0
Public Const EMAIL_TYPE_MAPI_DLG                    As Integer = 1
Public Const EMAIL_TYPE_SMTP                        As Integer = 2


'Errors

' Error codes
Public Const FACILITY_NOVA As Integer = &H55DA


' general error codes
' MessageId: NV_NOT_INITIALIZED
' MessageText: Initialize was not called.
Public Const NV_NOT_INITIALIZED As Long = &HD5DA0001

' get/set options error codes
' MessageId: NV_INVALID_OPTION
' MessageText: invalid option name
Public Const NV_INVALID_OPTION As Long = &HD5DA0004

' get/set options error codes
' MessageId: NV_WRONG_OPTION_TYPE
' MessageText: invalid option type
Public Const NV_WRONG_OPTION_TYPE As Long = &HD5DA0005

' manage profiles error codes
' MessageId: NV_PROFILE_EXISTS
' MessageText: profile already exists
Public Const NV_PROFILE_EXISTS As Long = &HD5DA0006

' MessageId: NV_ENOUGH_PROFILES
' MessageText: too many profiles
Public Const NV_ENOUGH_PROFILES As Long = &HD5DA0007

' MessageId: NV_UNKNOWN_PROFILE
' MessageText: profile does not exist
Public Const NV_UNKNOWN_PROFILE As Long = &HD5DA0008

' MessageId: NV_NO_MORE_PROFILES
' MessageText: enumeration of profiles is finished
Public Const NV_NO_MORE_PROFILES As Long = &HD5DA000A

' MessageId: NV_ENUM_NOT_INIT
' MessageText: GetFirstProfile or GetFirstForm not called
Public Const NV_ENUM_NOT_INIT As Long = &HD5DA000B

' MessageId: NV_ACTIVE_PROFILE
' MessageText: profile is active
Public Const NV_ACTIVE_PROFILE As Long = &HD5DA000C

' manage predefined forms error codes
' MessageId: NV_FORM_EXISTS
' MessageText: form already exists
Public Const NV_FORM_EXISTS As Long = &HD5DA000D

' MessageId: NV_ENOUGH_FORMS
' MessageText: too many forms
Public Const NV_ENOUGH_FORMS As Long = &HD5DA000E

' MessageId: NV_UNKNOWN_FORM
' MessageText: form does not exist
Public Const NV_UNKNOWN_FORM As Long = &HD5DA000F

' MessageId: NV_READONLY_FORM
' MessageText: form can not be edited or deleted
Public Const NV_READONLY_FORM As Long = &HD5DA0010

' MessageId: NV_NO_MORE_FORMS
' MessageText: enumeration of forms is finished
Public Const NV_NO_MORE_FORMS As Long = &HD5DA0011

' MessageId: NV_INVALID_WIDTH
' MessageText: invalid paper width
Public Const NV_INVALID_WIDTH As Long = &HD5DA0012

' MessageId: NV_INVALID_HEIGHT
' MessageText: invalid paper height
Public Const NV_INVALID_HEIGHT As Long = &HD5DA0013

' MessageId: NV_NODEFAULT_PRINTER
' MessageText: SetDefaultPrinter was not called
Public Const NV_NODEFAULT_PRINTER As Long = &HD5DA0014

' MessageId: NV_NOT_REGISTERED
' MessageText: novapi2.dll (this module) is not registered
Public Const NV_NOT_REGISTERED As Long = &HD5DA0015

' MessageId: NV_INVALID_BOOKMARK_DEF
' MessageText: invalif bookmark definition index
Public Const NV_INVALID_BOOKMARK_DEF As Long = &HD5DA0016

' MessageId: NV_INVALID_BOOKMARK_HEAD
' MessageText: invalif bookmark heading index
Public Const NV_INVALID_BOOKMARK_HEAD As Long = &HD5DA0017

' MessageId: NV_INVALID_PRINTER_NAME
' MessageText: cannot find printer with given printer name
Public Const NV_INVALID_PRINTER_NAME As Long = &HD5DA0018

' MessageId: NV_NOT_A_NOVAPDF_PRINTER
' MessageText: printer is not a novaPDF printer
Public Const NV_NOT_A_NOVAPDF_PRINTER As Long = &HD5DA0019

' MessageId: NV_PUBLIC_PROFILE
' MessageText: you are not allowed to modify public profiles on client PCs
Public Const NV_PUBLIC_PROFILE As Long = &HD5DA0020

' MessageId: NV_INVALID_WATERMARK_IMG
' MessageText: invalid watermark image index
Public Const NV_INVALID_WATERMARK_IMG As Long = &HD5DA0021

Public Const MSG_NOVAPDF2_STARTDOC = "NOVAPDF2_STARTDOC"
Public Const MSG_NOVAPDF2_ENDDOC = "NOVAPDF2_ENDDOC"
Public Const MSG_NOVAPDF2_STARTPAGE = "NOVAPDF2_STARTPAGE"
Public Const MSG_NOVAPDF2_ENDPAGE = "NOVAPDF2_ENDPAGE"
Public Const MSG_NOVAPDF2_FILESENT = "NOVAPDF2_FILESENT"
Public Const MSG_NOVAPDF2_PRINTERROR = "NOVAPDF2_PRINTERROR"
Public Const MSG_NOVAPDF2_FILESAVED = "NOVAPDF2_FILESAVED"
Public Const MSG_NOVAPDF2_EMAILSENT = "NOVAPDF2_EMAILSENT"
Public Const MSG_NOVAPDF2_EMAILERROR = "NOVAPDF2_EMAILERROR"

'ERROR CODES FOR NOVAPDF2_PRINTERROR MESSAGE
Public Const ERROR_MSG_TEMP_FILE As Integer = 1
Public Const ERROR_MSG_LIC_INFO As Integer = 2
Public Const ERROR_MSG_SAVE_PDF As Integer = 3
Public Const ERROR_MSG_JOB_CANCELED As Integer = 4
Public Const ERROR_MSG_LIC_COPIES As Integer = 5
Public Const ERROR_MSG_LIC_CLIENT As Integer = 6
Public Const ERROR_MSG_SEND_EMAIL As Integer = 7


' the novapiLib and novapiLibDemo packages must be added as a COM reference
'Const OPT_PROFILE As String = "Full Options Profile"
'Const OPT_PROFILE As String = "Small Size Profile"
'Const PROFILE_NAME As String = "Test VB"

Const OPT_PROFILE As String = "Options Profile"

Const PRINTER_NAME As String = "novaPDF Pro v5"
Const PROFILE_IS_PUBLIC As Long = 0

Public Function IsPDFPrinter(ByVal PrinterName As String) As Boolean
  IsPDFPrinter = PrinterName = PRINTER_NAME
End Function

' The main entry point for the application.
Public Sub InitPDFPrinter(ByRef pNova As Object, _
                          ByRef activeProfile As String, _
                          ByRef nActiveProfilePublic As Long, _
                          ByVal FullFileName As String, _
                          ByVal nQuality As csPDFQuality)
                          
    On Error GoTo ErrorHandler:
    
    ' create the NovaPdfOptions object
    'Dim pNova As Object 'As New NovaPdfOptions
    
    Set pNova = CSKernelClient2.CreateObject("novapi.NovaPdfOptions")
    
    ' initialize the NovaPdfOptions object
    ' if you have an application license for novaPDF SDK,
    ' pass both the registration name and the license key to the Initialize() function
    ' pNova.Initialize2 PRINTER_NAME, "<registration name>", "<license key>", "<application name>"
    pNova.Initialize2 PRINTER_NAME, "", "", ""
    ' get the active profile ...
    'Dim activeProfile As String
    'Dim nActiveProfilePublic As Long
    pNova.GetActiveProfile2 activeProfile, nActiveProfilePublic
   ' and make a copy of it
'    On Error Resume Next
'    pNova.CopyProfile2 activeProfile, PROFILE_NAME, PROFILE_IS_PUBLIC
'    If Err.Number <> 0 Then
'        ' ignore profile exists error
'        If NV_PROFILE_EXISTS = Err.Number Then
'            Debug.Print "Profile Test VB already exists"
'        Else
'            Return
'        End If
'    End If
    
    On Error GoTo ErrorHandler:
    ' set the copy profile as active profile ...
    AddProfile pNova
    SetProfileOptions pNova, FullFileName, nQuality
    
    pNova.SetActiveProfile2 OPT_PROFILE, PROFILE_IS_PUBLIC
    
    ' and set some options
    pNova.SetOptionString2 NOVAPDF_INFO_SUBJECT, "CSReport document", OPT_PROFILE, PROFILE_IS_PUBLIC
        
    Exit Sub
ErrorHandler:
    Debug.Print Err.Number & ":" & Err.Description
End Sub
    
Public Sub ClosePDFPrinter(ByRef pNova As Object, _
                           ByVal activeProfile As String, _
                           ByVal nActiveProfilePublic As Long)
    On Error Resume Next

    ' Return to previous settings
    pNova.SetActiveProfile2 activeProfile, nActiveProfilePublic
    pNova.DeleteProfile2 OPT_PROFILE, PROFILE_IS_PUBLIC
    
    Exit Sub
ErrorHandler:
    Debug.Print Err.Number & ":" & Err.Description
End Sub

Private Sub AddProfile(ByRef pNova As Object)
  On Error Resume Next
  
  ' Add the profile "Full options", and edit its options
  pNova.AddProfile2 OPT_PROFILE, PROFILE_IS_PUBLIC
  
  Err.Clear
End Sub

Private Sub SetProfileOptions(ByRef pNova As Object, _
                              ByVal FullFileName As String, _
                              ByVal nQuality As csPDFQuality)
                           
    On Error GoTo ErrHandler:
        
    ' disable the "Save PDF file as" prompt
    pNova.SetOptionLong2 NOVAPDF_SAVE_PROMPT, False, OPT_PROFILE, PROFILE_IS_PUBLIC
    ' set generated Pdf files destination folder  "c:\"
    pNova.SetOptionString2 NOVAPDF_SAVE_FOLDER, pGetFilePath(FullFileName), OPT_PROFILE, PROFILE_IS_PUBLIC
    ' set output file name "[N] full", the [N] macro means document name
    pNova.SetOptionString2 NOVAPDF_SAVE_FILE, pGetFileName(FullFileName), OPT_PROFILE, PROFILE_IS_PUBLIC
    
    If nQuality = PDFQualityFull Then
    
      ' if file exists in the destination folder, append a counter to the end of the file name
      pNova.SetOptionLong2 NOVAPDF_SAVE_CONFLICT_STRATEGY, FILE_CONFLICT_STRATEGY_OVERWRITE, OPT_PROFILE, PROFILE_IS_PUBLIC
      ' enable URL detection
      pNova.SetOptionLong2 NOVAPDF_URL_ANALIZE, True, OPT_PROFILE, PROFILE_IS_PUBLIC
  
      ' set image JPEG quality to 100  maximum
      pNova.SetOptionLong2 NOVAPDF_USE_IMAGE_COMPRESSION, True, OPT_PROFILE, PROFILE_IS_PUBLIC
      pNova.SetOptionLong2 NOVAPDF_IMAGE_COMPRESSION_METHOD, COMPRESS_METHOD_JPEG, OPT_PROFILE, PROFILE_IS_PUBLIC
      pNova.SetOptionLong2 NOVAPDF_IMAGE_COMPRESSION_LEVEL, 100, OPT_PROFILE, PROFILE_IS_PUBLIC
  
      ' set text compression to 6  on the "zip" scale from 0 to 9
      pNova.SetOptionLong2 NOVAPDF_USE_TEXT_COMPRESSION, True, OPT_PROFILE, PROFILE_IS_PUBLIC
      pNova.SetOptionLong2 NOVAPDF_TEXT_COMPRESSION_LEVEL, 6, OPT_PROFILE, PROFILE_IS_PUBLIC
      
      ' enable font files embedding
      pNova.SetOptionLong2 NOVAPDF_EMBED_ALL_FONTS, True, OPT_PROFILE, PROFILE_IS_PUBLIC
       
    ElseIf nQuality = PDFQualitySmall Then
    
      ' if file exists in the destination folder, append a counter to the end of the file name
      pNova.SetOptionLong2 NOVAPDF_SAVE_CONFLICT_STRATEGY, FILE_CONFLICT_STRATEGY_OVERWRITE, OPT_PROFILE, PROFILE_IS_PUBLIC
      ' don't detect URLs
      pNova.SetOptionLong2 NOVAPDF_URL_ANALIZE, False, OPT_PROFILE, PROFILE_IS_PUBLIC
  
      ' Set image compresion method to JPEG and quality to 75, possible values are from 10 to 100
      pNova.SetOptionLong2 NOVAPDF_USE_IMAGE_COMPRESSION, True, OPT_PROFILE, PROFILE_IS_PUBLIC
      pNova.SetOptionLong2 NOVAPDF_IMAGE_COMPRESSION_METHOD, COMPRESS_METHOD_JPEG, OPT_PROFILE, PROFILE_IS_PUBLIC
      pNova.SetOptionLong2 NOVAPDF_IMAGE_COMPRESSION_LEVEL, 75, OPT_PROFILE, PROFILE_IS_PUBLIC
  
      ' make sure text compression is enabled, and set compression level to 9  maximum   posible values are 1-9
      pNova.SetOptionLong2 NOVAPDF_USE_TEXT_COMPRESSION, True, OPT_PROFILE, PROFILE_IS_PUBLIC
      pNova.SetOptionLong2 NOVAPDF_TEXT_COMPRESSION_LEVEL, 9, OPT_PROFILE, PROFILE_IS_PUBLIC
  
      ' disable unused font embeding
      pNova.SetOptionLong2 NOVAPDF_EMBED_ALL_FONTS, False, OPT_PROFILE, PROFILE_IS_PUBLIC
    
    Else
       
      ' if file exists in the destination folder, append a counter to the end of the file name
      pNova.SetOptionLong2 NOVAPDF_SAVE_CONFLICT_STRATEGY, FILE_CONFLICT_STRATEGY_OVERWRITE, OPT_PROFILE, PROFILE_IS_PUBLIC
      ' don't detect URLs
      pNova.SetOptionLong2 NOVAPDF_URL_ANALIZE, False, OPT_PROFILE, PROFILE_IS_PUBLIC
  
      ' Set image compresion method to JPEG and quality to 75, possible values are from 10 to 100
      pNova.SetOptionLong2 NOVAPDF_USE_IMAGE_COMPRESSION, True, OPT_PROFILE, PROFILE_IS_PUBLIC
      pNova.SetOptionLong2 NOVAPDF_IMAGE_COMPRESSION_METHOD, COMPRESS_METHOD_JPEG, OPT_PROFILE, PROFILE_IS_PUBLIC
      pNova.SetOptionLong2 NOVAPDF_IMAGE_COMPRESSION_LEVEL, 85, OPT_PROFILE, PROFILE_IS_PUBLIC
  
      ' make sure text compression is enabled, and set compression level to 9  maximum   posible values are 1-9
      pNova.SetOptionLong2 NOVAPDF_USE_TEXT_COMPRESSION, True, OPT_PROFILE, PROFILE_IS_PUBLIC
      pNova.SetOptionLong2 NOVAPDF_TEXT_COMPRESSION_LEVEL, 6, OPT_PROFILE, PROFILE_IS_PUBLIC
  
      ' disable unused font embeding
      pNova.SetOptionLong2 NOVAPDF_EMBED_ALL_FONTS, False, OPT_PROFILE, PROFILE_IS_PUBLIC
       
    End If
    
    pNova.SetOptionLong2 NOVAPDF_ACTION_OPEN_DOCUMENT, False, OPT_PROFILE, PROFILE_IS_PUBLIC
    
    Exit Sub
ErrHandler:
    If Err.Number <> NV_PROFILE_EXISTS Then Debug.Print Err.Number & ":" & Err.Description
End Sub

Private Function pGetFileName(ByVal FullFilePath As String) As String
  Dim file As CSKernelFile.cFile
  Set file = New CSKernelFile.cFile
  
  pGetFileName = file.GetFileName(FullFilePath)
End Function

Private Function pGetFilePath(ByVal FullFilePath As String) As String
  Dim file As CSKernelFile.cFile
  Set file = New CSKernelFile.cFile
  
  pGetFilePath = file.GetPath(FullFilePath)
End Function

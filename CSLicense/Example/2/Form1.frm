VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   3195
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4680
   LinkTopic       =   "Form1"
   ScaleHeight     =   3195
   ScaleWidth      =   4680
   StartUpPosition =   3  'Windows Default
   Begin VB.ListBox List1 
      Height          =   2595
      Left            =   1500
      TabIndex        =   1
      Top             =   300
      Width           =   3075
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Command1"
      Height          =   315
      Left            =   60
      TabIndex        =   0
      Top             =   240
      Width           =   1215
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Copyright ©1996-2004 VBnet, Randy Birch, All Rights Reserved.
' Some pages may also contain other copyrights by the author.
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Distribution: You can freely use this code in your own
'               applications, but you may not reproduce
'               or publish this code on any web site,
'               online service, or distribute as source
'               on any media without express permission.
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

Private Const NCBASTAT As Long = &H33
Private Const NCBRESET As Long = &H32
Private Const NCBENUM As Long = &H37
Private Const NRC_GOODRET As Long = &H0
Private Const MAX_LANA As Long = 254
Private Const NCBNAMSZ As Long = 16
Private Const HEAP_ZERO_MEMORY As Long = &H8
Private Const HEAP_GENERATE_EXCEPTIONS As Long = &H4

Private Type LANA_ENUM
   length As Byte
   adapter_numbers(0 To MAX_LANA) As Byte 'lanas in range 0 to MAX_LANA inclusive
End Type

Private Type NET_CONTROL_BLOCK  'NCB
   ncb_command As Byte
   ncb_retcode As Byte
   ncb_lsn As Byte
   ncb_num As Byte
   ncb_buffer As Long
   ncb_length As Integer
   ncb_callname As String * NCBNAMSZ
   ncb_name As String * NCBNAMSZ
   ncb_rto As Byte
   ncb_sto As Byte
   ncb_post As Long
   ncb_lana_num As Byte
   ncb_cmd_cplt As Byte
   ncb_reserve(0 To 9) As Byte 'if Win64, make (0 to 17)
   ncb_event As Long
End Type

Private Type ADAPTER_STATUS
   adapter_address(0 To 5) As Byte '6 elements
   rev_major As Byte
   reserved0 As Byte
   adapter_type As Byte
   rev_minor As Byte
   duration As Integer
   frmr_recv As Integer
   frmr_xmit As Integer
   iframe_recv_err As Integer
   xmit_aborts As Integer
   xmit_success As Long
   recv_success As Long
   iframe_xmit_err As Integer
   recv_buff_unavail As Integer
   t1_timeouts As Integer
   ti_timeouts As Integer
   Reserved1 As Long
   free_ncbs As Integer
   max_cfg_ncbs As Integer
   max_ncbs As Integer
   xmit_buf_unavail As Integer
   max_dgram_size As Integer
   pending_sess As Integer
   max_cfg_sess As Integer
   max_sess As Integer
   max_sess_pkt_size As Integer
   name_count As Integer
End Type
   
Private Type NAME_BUFFER
   name As String * NCBNAMSZ
   name_num As Integer
   name_flags As Integer
End Type

'when NCBASTAT is specified, the
'ncb_buffer member of NET_CONTROL_BLOCK
'points to a buffer to be filled with
'an ADAPTER_STATUS structure, followed
'by an array of NAME_BUFFER structures
Private Type ASTAT
   adapt As ADAPTER_STATUS
   NameBuff(0 To 30) As NAME_BUFFER
End Type

Private Declare Function Netbios Lib "netapi32.dll" _
  (pncb As NET_CONTROL_BLOCK) As Byte
     
Private Declare Sub CopyMemory Lib "kernel32" _
   Alias "RtlMoveMemory" _
  (hpvDest As Any, ByVal _
   hpvSource As Long, ByVal _
   cbCopy As Long)
     
Private Declare Function GetProcessHeap Lib "kernel32" () As Long

Private Declare Function HeapAlloc Lib "kernel32" _
  (ByVal hHeap As Long, _
   ByVal dwFlags As Long, _
   ByVal dwBytes As Long) As Long
     
Private Declare Function HeapFree Lib "kernel32" _
  (ByVal hHeap As Long, _
   ByVal dwFlags As Long, _
   lpMem As Any) As Long



Private Sub Form_Load()

   Command1.Caption = "Enum Lanas and Addresses"
   
End Sub


Private Sub Command1_Click()

   Dim cnt As Long
   Dim numLanas As Long
   Dim sMACAddresses() As String
   
  'get an array of strings containing the
  'MAC addresses of each NetBIOS-enabled
  'adapter, returning the number of adapters
  'in the array.
   numLanas = GetNBMacAddresses(sMACAddresses())
   
   If numLanas > 0 Then
      
      List1.AddItem "Number of adapters: " & numLanas
      
      For cnt = 0 To numLanas - 1
         List1.AddItem ""
         List1.AddItem "MAC address of lana " & cnt & ":"
         List1.AddItem vbTab & sMACAddresses(cnt)
      Next
      
   Else
      List1.AddItem "No adapters using NetBIOS found"
   End If

End Sub

Private Function GetNBMacAddresses(sMACAddresses() As String) As Long

  'retrieve the MAC addresses for all
  'installed and enabled network controllers
  'bound to the NetBIOS protocol.
   
   Dim cnt As Long
   Dim pASTAT As Long
   Dim buff As String
   Dim lana As LANA_ENUM  'enum values
   Dim ncb As NET_CONTROL_BLOCK
   Dim ast As ASTAT
  
  'Enumerate LAN adapter (LANA) numbers.
  'When NCBENUM is specified the ncb_buffer
  'member points to a buffer to be filled
  'with a LANA_ENUM structure. NCBENUM is
  'not a standard NetBIOS 3.0 command.
   With ncb
      .ncb_command = NCBENUM
      .ncb_length = LenB(lana)
      .ncb_buffer = VarPtr(lana)
   End With
   
   Call Netbios(ncb)
   
  'instead of testing the return value of
  'the NetBIOS call as with other APIs, we
  'instead check the retcode member of the
  'NCB structure
   If ncb.ncb_retcode = NRC_GOODRET Then

     'prepare the array to receive
     'all MAC addresses, 0-based
      ReDim sMACAddresses(0 To lana.length - 1)
      
      For cnt = 0 To lana.length - 1
      
        'Reset the adapter - required
        'before it can accept any other
        'NCB command. The ncb_lana_num
        'member is assigned the next
        'lana number returned from the
        'NCBENUM call.
         With ncb
            .ncb_command = NCBRESET
            .ncb_lana_num = lana.adapter_numbers(cnt)
         End With
         
         Call Netbios(ncb)
         
         If ncb.ncb_retcode = NRC_GOODRET Then
           
           'To get the MAC address for an
           'ethernet adapter use send the
           'NCBASTAT command and provide
           '"*" as ncb_CallName (must be
           'formatted as a 16-chr string).
           'The same lana number is used.
            With ncb
               .ncb_command = NCBASTAT
               .ncb_lana_num = lana.adapter_numbers(cnt)
               .ncb_length = Len(ast)
               .ncb_callname = Space$(16)
               Mid$(.ncb_callname, 1, 1) = "*"
            End With
      
           'allocate memory for the ASTAT struct
            pASTAT = HeapAlloc(GetProcessHeap(), _
                               HEAP_GENERATE_EXCEPTIONS Or _
                               HEAP_ZERO_MEMORY, _
                               ncb.ncb_length)
                     
            If pASTAT <> 0 Then
   
              'assign the memory buffer to
              'the NCB buffer, call, and
              'copy the result to an AST type
               ncb.ncb_buffer = pASTAT
               Call Netbios(ncb)
            
               If ncb.ncb_retcode = NRC_GOODRET Then
            
                 'copy the info from the
                 'buffer into the UDT
                  CopyMemory ast, ncb.ncb_buffer, Len(ast)
              
                 'and add to array; the last param
                 'in MakeMacAddress is the display
                 'delimiter desired
                  sMACAddresses(cnt) = MakeMacAddress(ast.adapt.adapter_address(), " ")
                  HeapFree GetProcessHeap(), 0, pASTAT
               
               End If  'ncb.ncb_retcode = NRC_GOODRET (NCBASTAT call)
         
            Else
               Debug.Print "HeapAlloc memory allcoation failed!"
            End If  'pastat <> 0
   
         End If  'ncb.ncb_retcode = NRC_GOODRET (NCBRESET call)
   
      Next  'cnt = 0 To lana.length - 1
      
     'return number of adapters enumerated
      GetNBMacAddresses = lana.length
      
   End If  'ncb.ncb_retcode = NRC_GOODRET (NCBENUM call)

End Function


Private Function MakeMacAddress(b() As Byte, sDelim As String) As String

   Dim cnt As Long
   Dim buff As String
   
   On Local Error GoTo MakeMac_error
 
  'so far, MAC addresses are
  'exactly 6 segments in size (0-5)
  'so we'll hard-code the size
   If UBound(b) = 5 Then
   
      For cnt = 0 To 5
         
         Select Case True
            Case b(cnt) = 0
              'the value is 0 so ensure it's
              'formatted properly
               buff = buff & "00" & sDelim
            
            Case cnt = 5
              'the last item, so no delimiter
               buff = buff & Hex$(b(cnt))
               
            Case Else
              'normal value
               buff = buff & Hex$(b(cnt)) & sDelim
         End Select
         
      Next
   
   End If  'UBound(b)
   
   MakeMacAddress = buff
   
MakeMac_exit:
   Exit Function
   
MakeMac_error:
   MakeMacAddress = "(error building MAC address)"
   Resume MakeMac_exit
   
End Function

'--end block--'




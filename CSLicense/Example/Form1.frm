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
   Begin VB.CommandButton Command1 
      Caption         =   "Command1"
      Height          =   315
      Left            =   120
      TabIndex        =   2
      Top             =   1500
      Width           =   1215
   End
   Begin VB.TextBox Text2 
      Height          =   285
      Left            =   1740
      TabIndex        =   1
      Text            =   "Text2"
      Top             =   2100
      Width           =   2355
   End
   Begin VB.TextBox Text1 
      Height          =   285
      Left            =   1740
      TabIndex        =   0
      Text            =   "Text1"
      Top             =   1380
      Width           =   2355
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

Private Const NO_ERROR = 0

Private Declare Function inet_addr Lib "wsock32.dll" _
  (ByVal s As String) As Long

Private Declare Function SendARP Lib "iphlpapi.dll" _
  (ByVal DestIP As Long, _
   ByVal SrcIP As Long, _
   pMacAddr As Long, _
   PhyAddrLen As Long) As Long

Private Declare Sub CopyMemory Lib "kernel32" _
   Alias "RtlMoveMemory" _
  (dst As Any, _
   src As Any, _
   ByVal bcount As Long)
   


Private Sub Form_Load()

   Text1.Text = "192.168.1.101"
   Text2.Text = ""
   Command1.Caption = "Get Remote Mac Address"
   
End Sub


Private Sub Command1_Click()

   Dim sRemoteMacAddress As String
   
   If Len(Text1.Text) > 0 Then
   
      If GetRemoteMACAddress(Text1.Text, sRemoteMacAddress) Then
         Text2.Text = sRemoteMacAddress
      Else
         Text2.Text = "(SendARP call failed)"
      End If
      
   End If

End Sub


Private Function GetRemoteMACAddress(ByVal sRemoteIP As String, _
                                     sRemoteMacAddress As String) As Boolean

   Dim dwRemoteIP As Long
   Dim pMacAddr As Long
   Dim bpMacAddr() As Byte
   Dim PhyAddrLen As Long
   Dim cnt As Long
   Dim tmp As String
    
  'convert the string IP into
  'an unsigned long value containing
  'a suitable binary representation
  'of the Internet address given
   dwRemoteIP = inet_addr(sRemoteIP)
   
   If dwRemoteIP <> 0 Then
   
     'set PhyAddrLen to 6
      PhyAddrLen = 6
   
     'retrieve the remote MAC address
      If SendARP(dwRemoteIP, 0&, pMacAddr, PhyAddrLen) = NO_ERROR Then
      
         If pMacAddr <> 0 And PhyAddrLen <> 0 Then
      
           'returned value is a long pointer
           'to the mac address, so copy data
           'to a byte array
            ReDim bpMacAddr(0 To PhyAddrLen - 1)
            CopyMemory bpMacAddr(0), pMacAddr, ByVal PhyAddrLen
          
           'loop through array to build string
            For cnt = 0 To PhyAddrLen - 1
               
               If bpMacAddr(cnt) = 0 Then
                  tmp = tmp & "00-"
               Else
                  tmp = tmp & Hex$(bpMacAddr(cnt)) & "-"
               End If
         
            Next
           
           'remove the trailing dash
           'added above and return True
            If Len(tmp) > 0 Then
               sRemoteMacAddress = Left$(tmp, Len(tmp) - 1)
               GetRemoteMACAddress = True
            End If

            Exit Function
         
         Else
            GetRemoteMACAddress = False
         End If
            
      Else
         GetRemoteMACAddress = False
      End If  'SendARP
      
   Else
      GetRemoteMACAddress = False
   End If  'dwRemoteIP
      
End Function

VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "pcMnemonics"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

' ===========================================================================
' Name:     pcMnemonics
' Author:   Steve McMahon (steve@vbaccelerator.com)
' Date:     7 June 2003
' Requires: None
'
' ---------------------------------------------------------------------------
' Copyright ® 2003 Steve McMahon (steve@vbaccelerator.com)
' Visit vbAccelerator - free, advanced source code for VB programmers.
'     http://vbaccelerator.com
' ---------------------------------------------------------------------------
'
' Description:
' Manages Mnemonics for application through the IOleControl interfaces
'
' FREE SOURCE CODE! - ENJOY.
' - Please report bugs to the author for incorporation into future releases
' - See licence below
' ===========================================================================


' ---------------------------------------------------------------------
' vbAccelerator Software License
' Version 1.0
' Copyright (c) 2002 vbAccelerator.com
'
' Redistribution and use in source and binary forms, with or
' without modification, are permitted provided that the following
' conditions are met:
'
' 1. Redistributions of source code must retain the above copyright
'    notice, this list of conditions and the following disclaimer.
'
' 2. Redistributions in binary form must reproduce the above copyright
'    notice, this list of conditions and the following disclaimer in
'    the documentation and/or other materials provided with the distribution.
'
' 3. The end-user documentation included with the redistribution, if any,
'    must include the following acknowledgment:
'
'  "This product includes software developed by vbAccelerator (http://vbaccelerator.com/)."
'
' Alternately, this acknowledgment may appear in the software itself, if
' and wherever such third-party acknowledgments normally appear.
'
' 4. The name "vbAccelerator" must not be used to endorse or promote products
'    derived from this software without prior written permission. For written
'    permission, please contact vbAccelerator through steve@vbaccelerator.com.
'
' 5. Products derived from this software may not be called "vbAccelerator",
'    nor may "vbAccelerator" appear in their name, without prior written
'    permission of vbAccelerator.
'
' THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESSED OR IMPLIED WARRANTIES,
' INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
' AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
' VBACCELERATOR OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
' INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
' BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
' USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
' THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
' (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
' THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
'
' ---------------------------------------------------------------------


Private Type ACCEL
   fVirt As Byte
   Key As Integer
   cmd As Integer
End Type

' API to support String-Virtual Key Code Mapping:
Private Declare Function VkKeyScan Lib "user32" Alias "VkKeyScanA" (ByVal cChar As Byte) As Integer
Private Declare Function VkKeyScanW Lib "user32" (ByVal cChar As Integer) As Integer
Private Declare Function GetVersion Lib "kernel32" () As Long
Private Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (lpDest As Any, lpSource As Any, ByVal nCount As Long)

Private Declare Function CreateAcceleratorTable Lib "user32" Alias "CreateAcceleratorTableA" ( _
      lpaccl As ACCEL, _
      ByVal cEntries As Long _
   ) As Long
Private Declare Function DestroyAcceleratorTable Lib "user32" ( _
      ByVal hAccel As Long _
   ) As Long

Public Enum EAcceleratorFlagConstants
    eafVirtKey = &H1&
    eafNoInvert = &H2&
    eafShift = &H4&
    eafControl = &H8&
    eafAlt = &H10&
End Enum

Private m_hAccel As Long
Private m_tAcc() As ACCEL
Private m_sKey() As String
Private m_iCount As Long
Private m_lID As Long

Public Property Get Count() As Long
   Count = m_iCount
End Property
Public Property Get Key(ByVal nIndex As Long) As String
   Key = m_sKey(nIndex)
End Property
Public Property Get VirtKey(ByVal nIndex As Long) As Long
   VirtKey = m_tAcc(nIndex).Key
End Property
Public Property Get AccelFlags(ByVal nIndex As Long) As EAcceleratorFlagConstants
   AccelFlags = m_tAcc(nIndex).fVirt
End Property
Public Property Get CommandID(ByVal nIndex As Long) As Long
   CommandID = m_tAcc(nIndex).cmd
End Property

Public Property Get hAccel() As Long
   hAccel = m_hAccel
End Property

Public Sub AddByKey( _
      ByVal sKey As String, _
      Optional ByVal eAccelFlag As EAcceleratorFlagConstants = eafAlt Or eafVirtKey, _
      Optional ByVal cmdId As Long = 0 _
   )
Dim vKey As Long
   
   vKey = KeyStringToKeyCode(sKey)
   AddByKeyCode vKey, eAccelFlag, cmdId
   m_sKey(m_iCount) = sKey

End Sub
Public Sub AddByKeyCode( _
      ByVal vKey As Long, _
      Optional ByVal eAccelFlag As EAcceleratorFlagConstants = eafAlt Or eafVirtKey, _
      Optional ByVal cmdId As Long = 0 _
   )
Dim i As Long

   For i = 1 To m_iCount
      If (m_tAcc(i).Key = vKey And m_tAcc(i).fVirt = eAccelFlag) Then
         ' already have it
         Exit Sub
      End If
   Next i
     
   ClearUp
   If (cmdId = 0) Then
      cmdId = newCommandId
   End If
   m_iCount = m_iCount + 1
   ReDim Preserve m_tAcc(1 To m_iCount) As ACCEL
   ReDim Preserve m_sKey(1 To m_iCount) As String
   With m_tAcc(m_iCount)
      .cmd = cmdId
      .fVirt = eAccelFlag
      .Key = vKey
   End With
   
   m_hAccel = CreateAcceleratorTable(m_tAcc(1), m_iCount)
   

End Sub
Public Sub RemoveByKey( _
      ByVal sKey As String _
   )
Dim i As Long

   For i = 1 To m_iCount
      If (m_sKey(i) = sKey) Then
         ' have it
         pRemove i
         Exit For
      End If
   Next i
         
End Sub
Public Sub RemoveByKeyCode( _
      ByVal vKey As Long, _
      Optional ByVal eAccelFlag As EAcceleratorFlagConstants = eafAlt Or eafVirtKey _
   )
Dim i As Long

   For i = 1 To m_iCount
      If (m_tAcc(i).Key = vKey And m_tAcc(i).fVirt = eAccelFlag) Then
         ' have it
         pRemove i
         Exit For
      End If
   Next i
         
End Sub
Private Sub pRemove(ByVal lIndex As Long)
Dim i As Long
   
   If (lIndex = 0) Then
      ' nothing to do
      Exit Sub
   End If
   
   ClearUp
   If (m_iCount <= 1) Then
      Erase m_tAcc
      Erase m_sKey
      m_iCount = 0
   Else
      For i = lIndex + 1 To m_iCount
         LSet m_tAcc(i) = m_tAcc(i + 1)
         m_sKey(i) = m_sKey(i + 1)
      Next i
      m_iCount = m_iCount - 1
      ReDim Preserve m_tAcc(1 To m_iCount) As ACCEL
      ReDim Preserve m_sKey(1 To m_iCount) As String
   
      m_hAccel = CreateAcceleratorTable(m_tAcc(0), m_iCount)
      
   End If
End Sub
Private Sub ClearUp()
   If Not (m_hAccel = 0) Then
      DestroyAcceleratorTable m_hAccel
      m_hAccel = 0
   End If
End Sub
Private Function KeyStringToKeyCode(ByVal sKey As String) As Integer
Dim b() As Byte
Dim vKey As Integer
   
   If (GetVersion() And &H80000000) = 0 Then
      ' NT
      b = sKey
      CopyMemory vKey, b(0), 2
      vKey = VkKeyScanW(vKey)
   Else
      ' 9x
      b = StrConv(sKey, vbFromUnicode)
      vKey = VkKeyScan(b(0))
   End If
   KeyStringToKeyCode = vKey And &HFF&
   
End Function

Private Property Get newCommandId() As Integer
   m_lID = m_lID + 100
   newCommandId = m_lID
End Property

Private Sub Class_Initialize()
   m_lID = 1000
End Sub

Private Sub Class_Terminate()
   ClearUp
End Sub


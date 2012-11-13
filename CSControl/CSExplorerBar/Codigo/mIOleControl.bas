Attribute VB_Name = "mIOleControl"
Option Explicit
' ===========================================================================
' Filename:    mIOleControl.cls
' Author:      Steve McMahon, Eduardo Morcillo, Bruce McKinney, Paul Wilde
' Date:        09 January 1999
'
' Requires:    vbaCom.tlb (in IDE only)
'
' Description:
' Allows you to replace the standard IOLEInPlaceActiveObject interface for a
' UserControl with a customisable one.  This allows you to take control
' of focus in VB controls.

' The code could be adapted to replace other UserControl OLE interfaces.
'
' ---------------------------------------------------------------------------
' Visit vbAccelerator, advanced, free source for VB programmers
'     http://vbaccelerator.com
' ===========================================================================


Private Declare Function VirtualProtect Lib "kernel32" (ByVal lpAddress As Long, ByVal dwSize As Long, ByVal flNewProtect As Long, lpflOldProtect As Long) As Long
Private Const PAGE_EXECUTE_READWRITE& = &H40&
Private Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (Dest As Any, Src As Any, ByVal l As Long)

Public Enum IOleControl_vtable_Indexes
   IDX_GetControlInfo = 4
   IDX_OnMnemonic
   IDX_OnAmbientPropertyChange
   IDX_FreezeEvents
End Enum

Private Type ControlPtrLookup
   ptrIOLEControl As Long
   ptrControl As Long
End Type
Private m_tControlPtrLookup() As ControlPtrLookup
Private m_iControlPtrLookupCount As Long

Private Sub AddControlPtrLookup(ByVal ptrIOLEControl As Long, ByVal ptrControl)
Dim i As Long
   
   For i = 1 To m_iControlPtrLookupCount
      If (m_tControlPtrLookup(i).ptrIOLEControl = ptrIOLEControl) Then
         ' we already have it
         Exit Sub
      End If
   Next i
   
   m_iControlPtrLookupCount = m_iControlPtrLookupCount + 1
   ReDim Preserve m_tControlPtrLookup(1 To m_iControlPtrLookupCount) As ControlPtrLookup
   With m_tControlPtrLookup(m_iControlPtrLookupCount)
      .ptrControl = ptrControl
      .ptrIOLEControl = ptrIOLEControl
   End With
   
End Sub
Private Sub RemoveControlPtrLookup(ByVal ptrIOLEControl As Long)
Dim i As Long
Dim lIndex As Long
   
   For i = 1 To m_iControlPtrLookupCount
      If (m_tControlPtrLookup(i).ptrIOLEControl = ptrIOLEControl) Then
         lIndex = i
         Exit For
      End If
   Next i
   
   If (lIndex > 0) Then
      m_iControlPtrLookupCount = m_iControlPtrLookupCount - 1
      If (m_iControlPtrLookupCount <= 0) Then
         Erase m_tControlPtrLookup
         m_iControlPtrLookupCount = 0
      Else
         For i = lIndex + 1 To m_iControlPtrLookupCount
            LSet m_tControlPtrLookup(i - 1) = m_tControlPtrLookup(i)
         Next i
         ReDim Preserve m_tControlPtrLookup(1 To m_iControlPtrLookupCount) As ControlPtrLookup
      End If
   End If

End Sub

Private Function ControlPtrFor(ByVal ptrIOLEControl) As Long
Dim i As Long
   For i = 1 To m_iControlPtrLookupCount
      If (ptrIOLEControl = m_tControlPtrLookup(i).ptrIOLEControl) Then
         ControlPtrFor = m_tControlPtrLookup(i).ptrControl
         Exit For
      End If
   Next i
End Function

'*********************************************************************************************
'
' Author: Eduardo Morcillo
' E-Mail: edanmo@geocities.com
' Web Page: http://www.domaindlx.com/e_morcillo
'
' Created: 02/09/2000
'
'*********************************************************************************************
' Replaces an entry in a object v-table
'
Public Function ReplaceVTableEntry( _
      ByVal oObject As Long, _
      ByVal nEntry As Integer, _
      ByVal pFunc As Long, _
      Optional ByVal lPtrObject As Long = 0 _
   ) As Long
Dim pFuncOld As Long, pVTableHead As Long
Dim pFuncTmp As Long, lOldProtect As Long
     
    ' Object pointer contains a pointer to v-table--copy it to temporary
    ' pVTableHead = *oObject;
    CopyMemory pVTableHead, ByVal oObject, 4
    
    ' Calculate pointer to specified entry
    pFuncTmp = pVTableHead + (nEntry - 1) * 4
    
    ' Save address of previous method for return
    ' pFuncOld = *pFuncTmp;
    CopyMemory pFuncOld, ByVal pFuncTmp, 4
    
    ' Ignore if they're already the same
    If Not (pFuncOld = pFunc) Then
        ' Need to change page protection to write to code
        VirtualProtect pFuncTmp, 4, PAGE_EXECUTE_READWRITE, lOldProtect
        
        ' Write the new function address into the v-table
        CopyMemory ByVal pFuncTmp, pFunc, 4     ' *pFuncTmp = pfunc;
        
        ' Restore the previous page protection
        VirtualProtect pFuncTmp, 4, lOldProtect, lOldProtect 'Optional
        
    End If
    
    'return address of original proc
    ReplaceVTableEntry = pFuncOld
    
   If Not (lPtrObject = 0) Then
      AddControlPtrLookup oObject, lPtrObject
   Else
      RemoveControlPtrLookup oObject
   End If
    
End Function
'*********************************************************************************************
' (End Eduardo Morcillo code)


Public Function IOleControl_GetControlInfo(ByVal This As IOleControl, pCI As CONTROLINFO) As Long
Dim ctl As ExplorerBar
   
   Set ctl = ObjectFromPtr(ControlPtrFor(ObjPtr(This)))
   If Not (ctl Is Nothing) Then
      IOleControl_GetControlInfo = ctl.GetControlInfo(pCI)
   End If
   
End Function

Public Function IOleControl_OnMnemonic(ByVal This As IOleControl, pMsg As MSG) As Long
Dim ctl As ExplorerBar
   
   Set ctl = ObjectFromPtr(ControlPtrFor(ObjPtr(This)))
   If Not (ctl Is Nothing) Then
      IOleControl_OnMnemonic = ctl.OnMnemonic(pMsg)
   End If
      
End Function

Public Function IOleControl_FreezeEvents(ByVal This As IOleControl, ByVal bFreeze As Long) As Long
Dim ctl As ExplorerBar
   
   Set ctl = ObjectFromPtr(ControlPtrFor(ObjPtr(This)))
   If Not (ctl Is Nothing) Then
      'IOleControl_FreezeEvents = ctl.FreezeEvents(bFreeze)
   End If
   
End Function


Private Property Get ObjectFromPtr(ByVal lPtr As Long) As Object
Dim objT As Object
   If Not (lPtr = 0) Then
      
      ' Author: Bruce McKinney
      ' Turn the pointer into an illegal, uncounted interface
      CopyMemory objT, lPtr, 4
      ' Do NOT hit the End button here! You will crash!
      ' Assign to legal reference
      Set ObjectFromPtr = objT
      ' Still do NOT hit the End button here! You will still crash!
      ' Destroy the illegal reference
      CopyMemory objT, 0&, 4
      ' End Author Bruce McKinney
      
   End If
End Property



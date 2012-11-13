Attribute VB_Name = "mIOleInPlaceActiveObject"
Option Explicit

' ===========================================================================
' Filename:    mIOleInPlaceActiveObject.bas
' Author:      Mike Gainer, Matt Curland and Bill Storage
' Date:        09 January 1999
'
' Requires:    OleGuids.tlb (in IDE only)
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
Private Type GUID
    Data1 As Long
    Data2 As Integer
    Data3 As Integer
    Data4(0 To 7) As Byte
End Type
Private Declare Function CLSIDFromString Lib "ole32.dll" (ByVal lpsz As Long, rguid As GUID) As Long
Public Const S_FALSE = 1
Public Const S_OK = 0
Public Type IPAOHookStruct 'IOleInPlaceActiveObjectHook
    lpVTable As Long 'VTable pointer
    IPAOReal As VBOleGuids.IOleInPlaceActiveObject 'Un-AddRefed pointer for forwarding calls
    TBEx As ExplorerBar   'Un-AddRefed native class pointer for making Friend calls
    ThisPointer As Long
End Type
Public Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (pDest As Any, pSrc As Any, ByVal ByteLen As Long)
Private Const strIID_IOleInPlaceActiveObject As String = "{00000117-0000-0000-C000-000000000046}"
Private IID_IOleInPlaceActiveObject As GUID
Private m_IPAOVTable(9) As Long
Private m_lpIPAOVTable As Long

Public Property Get IPAOVTable() As Long
   ' Set up the vTable for the interface and return a pointer to it:
   If m_lpIPAOVTable = 0 Then
       m_IPAOVTable(0) = AddressOfFunction(AddressOf QueryInterface)
       m_IPAOVTable(1) = AddressOfFunction(AddressOf AddRef)
       m_IPAOVTable(2) = AddressOfFunction(AddressOf Release)
       m_IPAOVTable(3) = AddressOfFunction(AddressOf GetWindow)
       m_IPAOVTable(4) = AddressOfFunction(AddressOf ContextSensitiveHelp)
       m_IPAOVTable(5) = AddressOfFunction(AddressOf TranslateAccelerator)
       m_IPAOVTable(6) = AddressOfFunction(AddressOf OnFrameWindowActivate)
       m_IPAOVTable(7) = AddressOfFunction(AddressOf OnDocWindowActivate)
       m_IPAOVTable(8) = AddressOfFunction(AddressOf ResizeBorder)
       m_IPAOVTable(9) = AddressOfFunction(AddressOf EnableModeless)
       m_lpIPAOVTable = VarPtr(m_IPAOVTable(0))
       CLSIDFromString StrPtr(strIID_IOleInPlaceActiveObject), IID_IOleInPlaceActiveObject
   End If
   IPAOVTable = m_lpIPAOVTable
End Property

Private Function AddressOfFunction(lpfn As Long) As Long
   ' Work around, VB thinks lPtr = AddressOf Method is an error
   AddressOfFunction = lpfn
End Function
   
Private Function AddRef(This As IPAOHookStruct) As Long
   ' Call the UserControl's standard AddRef method:
   AddRef = This.IPAOReal.AddRef
End Function

Private Function Release(This As IPAOHookStruct) As Long
   ' Call the UserControl's standard Release method:
   Release = This.IPAOReal.Release
End Function

Private Function QueryInterface(This As IPAOHookStruct, riid As GUID, pvObj As Long) As Long
   ' Install the interface if required:
   If IsEqualGUID(riid, IID_IOleInPlaceActiveObject) Then
      ' Install alternative IOleInPlaceActiveObject interface implemented here
      pvObj = This.ThisPointer
      AddRef This
      QueryInterface = 0
   Else
      ' Use the default support for the interface:
      QueryInterface = This.IPAOReal.QueryInterface(ByVal VarPtr(riid), pvObj)
   End If
End Function

Private Function GetWindow(This As IPAOHookStruct, phwnd As Long) As Long
   ' Call user controls' GetWindow method:
   GetWindow = This.IPAOReal.GetWindow(phwnd)
End Function

Private Function ContextSensitiveHelp(This As IPAOHookStruct, ByVal fEnterMode As Long) As Long
   ' Call the user control's ContextSensitiveHelp method:
   ContextSensitiveHelp = This.IPAOReal.ContextSensitiveHelp(fEnterMode)
End Function

Private Function TranslateAccelerator(This As IPAOHookStruct, lpMsg As VBOleGuids.MSG) As Long
Dim hRes As Long
   ' Check if we want to override the handling of this key code:
   hRes = S_FALSE
   hRes = This.TBEx.TranslateAccelerator(lpMsg)
   If hRes Then
      ' If not pass it on to the standard UserControl TranslateAccelerator method:
      hRes = This.IPAOReal.TranslateAccelerator(ByVal VarPtr(lpMsg))
   End If
   TranslateAccelerator = hRes

End Function

Private Function OnFrameWindowActivate(This As IPAOHookStruct, ByVal fActivate As Long) As Long
   ' Call the user control's OnFrameWindow activate interface:
   OnFrameWindowActivate = This.IPAOReal.OnFrameWindowActivate(fActivate)
End Function

Private Function OnDocWindowActivate(This As IPAOHookStruct, ByVal fActivate As Long) As Long
   ' Call the user control's OnDocWindow activate interface:
   OnDocWindowActivate = This.IPAOReal.OnDocWindowActivate(fActivate)
End Function

Private Function ResizeBorder(This As IPAOHookStruct, prcBorder As RECT, ByVal puiWindow As IOleInPlaceUIWindow, ByVal fFrameWindow As Long) As Long
   ' Call the user control's ResizeBorder interface
   ResizeBorder = This.IPAOReal.ResizeBorder(VarPtr(prcBorder), puiWindow, fFrameWindow)
End Function

Private Function EnableModeless(This As IPAOHookStruct, ByVal fEnable As Long) As Long
   ' Call the user control's EnableModeless interface
   EnableModeless = This.IPAOReal.EnableModeless(fEnable)
End Function

Private Function IsEqualGUID(iid1 As GUID, iid2 As GUID) As Boolean
Dim Tmp1 As Currency
Dim Tmp2 As Currency

   ' Check for match in GUIDs.
   If iid1.Data1 = iid2.Data1 Then
      If iid1.Data2 = iid2.Data2 Then
         If iid1.Data3 = iid2.Data3 Then
            ' compare last 8 bytes of GUID in one chunk:
            CopyMemory Tmp1, iid1.Data4(0), 8
            CopyMemory Tmp2, iid2.Data4(0), 8
            If Tmp1 = Tmp2 Then
               IsEqualGUID = True
            End If
         End If
      End If
   End If
   
   ' This could alternatively be done by matching the result
   ' of StringFromCLSID called on both GUIDs.

End Function




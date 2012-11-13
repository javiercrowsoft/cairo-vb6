Attribute VB_Name = "mDebug"
#If PREPROC_DEBUG Then

Option Explicit

Private Type t_dbg
  classname As String
  refcount  As Long
End Type

Private m_vdbg()        As t_dbg
Private m_bInitialized  As Boolean

Public Sub gdbInitInstance(ByVal classname As String)
  On Error Resume Next
  Dim n As Integer
  n = pGet(classname)
  With m_vdbg(n)
    .refcount = .refcount + 1
    pSaveLog .classname, "Init " & .classname & " " & .refcount
  End With
End Sub

Public Sub gdbTerminateInstance(ByVal classname As String)
  On Error Resume Next
  Dim n As Integer
  n = pGet(classname)
  With m_vdbg(n)
    .refcount = .refcount - 1
    pSaveLog .classname, "Terminate " & .classname & " " & .refcount
  End With
End Sub

Private Sub pCreateColl()
  On Error Resume Next
  
  If Not m_bInitialized Then
    ReDim m_vdbg(0)
    m_bInitialized = True
  End If
End Sub

Private Function pGet(ByVal classname As String) As Integer
  
  Dim rtn As Integer
  
  pCreateColl
  
  Dim n As Integer
  Dim i As Integer
  
  n = UBound(m_vdbg)
  
  Dim bFound As Boolean
  
  classname = App.EXEName & "." & classname
  
  For i = 0 To n
    If m_vdbg(i).classname = classname Then
      rtn = i
      bFound = True
      Exit For
    End If
  Next
    
  If Not bFound Then
    rtn = n + 1
    ReDim Preserve m_vdbg(rtn)
    m_vdbg(rtn).classname = classname
  End If
  
  pGet = rtn
End Function

Private Sub pSaveLog(ByVal classname As String, _
                     ByVal msg As String)
  On Error Resume Next
  Dim f As Integer
  f = FreeFile
  Open "D:\Proyectos\DLL - OCX - EXE-2\debug\debug_" & classname & ".log" For Append As f
  Print #f, msg
  Close f
  
  f = FreeFile
  Open "D:\Proyectos\DLL - OCX - EXE-2\debug\debug.log" For Append As f
  Print #f, msg
  Close f
End Sub

#End If

'#If PREPROC_DEBUG Then
'  gdbInitInstance C_Module
'#End If

'#If PREPROC_DEBUG Then
'  gdbTerminateInstance C_Module
'#End If

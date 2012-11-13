Attribute VB_Name = "mUtil"
Option Explicit

'--------------------------------------------------------------------------------
' mUtil
' 05-01-2004

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    Private Type POINTAPI
      x As Long
      y As Long
    End Type
    ' estructuras
    ' funciones
    Private Declare Function GetCursorPos Lib "user32" (lpPoint As _
       POINTAPI) As Long

'--------------------------------------------------------------------------------

' constantes

Private Const gAppName = "ABMGeneric"
Public Const csNumberID = "NUMBER_ID"
Public Const csStateID = "ESTADO_ID"

Public Const c_MainIniFile = "Cairo.ini"
Public Const c_K_MainIniConfig = "CONFIG"

Public gAppPath As String
Public gUnloadCancel As Boolean

#If PREPROC_ABMGENERIC Then
Public gBackgroundColor As Long
#End If

Public Const c_Items = "Items"
Public Const c_Footer = "Footer"
Public Const c_Header = "Header"

Public Const c_keyRowItem = "#RI#"

Public Const c_InerTab = "_INNERTAB_"

Public Const c_KeyTbPrint = "PRINTOBJ"
Public Const c_KeyTbNext = "NEXT"
Public Const c_KeyTbFirst = "FIRST"
Public Const c_KeyTbPrevious = "PREVIOUS"
Public Const c_KeyTbLast = "LAST"
Public Const c_KeyTbSearch = "SEARCH"
Public Const c_KeyTbSave = "SAVE"
Public Const c_KeyTbSaveAs = "SAVE_AS"
Public Const c_KeyTbNew = "NEW"
Public Const c_KeyTbApply = "APPLY"
Public Const c_KeyTbCopy = "COPY"
Public Const c_KeyTbReload = "RELOAD"
Public Const c_KeyTbClose = "EXIT"
Public Const c_KeyTbHelp = "HELP"
Public Const c_KeyTbHistory = "HISTORY"
Public Const c_KeyTbSignature = "SIGNATURE"
Public Const c_KeyTbAttach = "ATTACH"
Public Const c_KeyTbDelete = "DELETE"
Public Const c_KeyTbAnular = "ANULAR"
Public Const c_KeyTbEditState = "EDIT_STATE"
Public Const c_KeyTbDocAux = "DOC_AUX"
Public Const c_KeyTbDocEdit = "DOC_EDIT"
Public Const c_KeyTbDocMerge = "DOC_MERGE"
Public Const c_KeyTbDocTip = "DOC_TIP"
Public Const c_KeyTbDocAlert = "DOC_ALERT"
Public Const c_KeyTbDocAction = "DOC_ACTION"
Public Const c_KeyTbDocMail = "SENDEMAIL"

Public Const c_MinHeight As Long = 7000
Public Const c_MinWidth  As Long = 10000

Private Const c_NoDate       As Date = 0

Public Const c_tab_move_previous = -1
Public Const c_tab_move_next = -2


Private m_CtrlKeySave       As String
Private m_CtrlKeyPrint      As String
Private m_CtrlKeyNew        As String
Private m_CtrlKeyCopy       As String
Private m_CtrlKeyClose      As String
Private m_CtrlKeySearch     As String
Private m_CtrlKeyRefresh    As String
Private m_CtrlKeyApply      As String
Private m_CtrlKeyHistory    As String

Private m_CtrlKeysLoaded    As Boolean

Private m_SendKey           As cSendKey

Public gEmpId         As Long
Public gEmpNombre     As String

' funciones publicas

Public Sub Main()
  Set m_SendKey = New cSendKey
End Sub

Public Sub GetMousePosition(ByRef Left As Long, _
                            ByRef Top As Long)
  Dim a As POINTAPI
  
  GetCursorPos a
  
  Left = a.x
  Top = a.y
  
End Sub

Public Function GetDateValueForGrid(ByVal Value As Variant) As String
  If Not IsDate(Value) Then
    GetDateValueForGrid = ""
  Else
    If Value = c_NoDate Then
      GetDateValueForGrid = ""
    Else
      GetDateValueForGrid = Value
    End If
  End If
End Function

Public Function GetDateValueForGridClient(ByVal Value As String) As Variant
  If Not IsDate(Value) Then
    GetDateValueForGridClient = c_NoDate
  Else
    GetDateValueForGridClient = Value
  End If
End Function

Public Function ImplementsInterface(ByVal objOne As Object, ByVal Interfaz As Object) As Boolean
  On Error Resume Next
  Err.Clear

  Set Interfaz = objOne

  ImplementsInterface = Err.Number = 0
End Function

Public Sub ProcessVirtualKey(KeyCode As Integer, Shift As Integer, ByVal Frm As Object)
  On Error Resume Next
  
  Dim bSendKeyTab As Boolean
  Dim bSendKeyShifTab As Boolean
  Dim ActiveControl As Control
  
  If KeyCode = vbKeyF10 Then
    KeyCode = vbKeyN
    Shift = vbCtrlMask
  
  ElseIf KeyCode = vbKeyF11 Then
    KeyCode = vbKeyG
    Shift = vbCtrlMask
  
  ElseIf KeyCode = vbKeyF12 Then
    CSKernelClient2.EditFile CSKernelClient2.GetValidPath(App.Path) & "keyshortcuts.htm", 0
    Exit Sub
  End If
  
  If TypeOf Frm Is Form Then
    Set ActiveControl = Frm.ActiveControl
  Else
    Set ActiveControl = Frm
  End If
  
  If Shift = 0 Then

    If ActiveControl Is Nothing Then Exit Sub
    If TypeOf ActiveControl Is cGrid Then Exit Sub
    If TypeOf ActiveControl Is cGridAdvanced Then Exit Sub
    
    Select Case KeyCode
      Case vbKeyReturn
        If TypeOf ActiveControl Is cButton Or _
           TypeOf ActiveControl Is cButtonLigth Then Exit Sub

        If TypeOf ActiveControl Is cMultiLine Then Exit Sub

        pDoPropertyChange Frm
        bSendKeyTab = True
        
      Case vbKeyDown
#If PREPROC_ABMGENERIC Then
        If TypeOf ActiveControl Is ComboBox Then Exit Sub
        If TypeOf ActiveControl Is cMultiLine Then Exit Sub
#Else
        If TypeOf ActiveControl Is cComboBox Then Exit Sub
        If TypeOf ActiveControl Is cMultiLine Then Exit Sub
#End If
        bSendKeyTab = True
        
      Case vbKeyUp
      
#If PREPROC_ABMGENERIC Then
        If TypeOf ActiveControl Is ComboBox Then Exit Sub
        If TypeOf ActiveControl Is cMultiLine Then Exit Sub
#Else
        If TypeOf ActiveControl Is cComboBox Then Exit Sub
        If TypeOf ActiveControl Is cMultiLine Then Exit Sub
#End If
        bSendKeyShifTab = True
      
      Case vbKeyF1
        If Frm.CtrlKeyHelp Then KeyCode = 0
        
    End Select
  
    If bSendKeyTab Then
      SendKeys "{TAB}"
    ElseIf bSendKeyShifTab Then
      SendKeys "+{TAB}"
    End If
    
  ElseIf (Shift And vbCtrlMask) And vbCtrlMask Then
  
    If Not TypeOf Frm Is Form Then
      Set Frm = Frm.Parent
    End If
    
    If Not m_CtrlKeysLoaded Then pLoadCtrlKeys
  
    Select Case UCase(Chr(KeyCode))
      Case m_CtrlKeySave
        If Frm.CtrlKeySave Then KeyCode = 0
      Case m_CtrlKeyPrint
        If Frm.CtrlKeyPrint Then KeyCode = 0
      Case m_CtrlKeyCopy
        If Frm.CtrlKeyCopy Then KeyCode = 0
      Case m_CtrlKeySearch
        If Frm.CtrlKeySearch Then KeyCode = 0
      Case m_CtrlKeyClose
        If Frm.CtrlKeyClose Then KeyCode = 0
      Case m_CtrlKeyNew
        If Frm.CtrlKeyNew Then KeyCode = 0
      Case m_CtrlKeyRefresh
        If Frm.CtrlKeyRefresh Then KeyCode = 0
      Case m_CtrlKeyApply
        If Frm.CtrlKeyApply Then KeyCode = 0
      Case m_CtrlKeyHistory
        If Frm.CtrlKeyHistory Then KeyCode = 0
    End Select
  End If
End Sub

Public Function GetItemFromList(ByRef List As cIABMList, ByVal Id As Long) As String
  Dim o As cIABMListItem
  
  For Each o In List
    If o.Id = Id Then
      GetItemFromList = o.Value
      Exit Function
    End If
  Next
End Function

Public Function Val(ByVal Value As String) As Double
  Dim SepDecimal As String
  SepDecimal = GetSepDecimal()
  
  Value = Replace(Value, SepDecimal, ".")
  Val = VBA.Val(Value)
End Function

Public Sub DestroyGrids(ByRef Frm As Object)
  Dim i As Long
  Dim GR As cGridAdvanced
  
  With Frm
    .GR(0).Visible = False
    .GR(0).Redraw = False
    .GR(0).Columns.Clear
    .GR(0).Redraw = True
    For i = 1 To .GR.UBound
      Set GR = .GR(i)
      GR.Redraw = False
      GR.Columns.Clear
      Unload .GR(i)
    Next
  End With
End Sub

Public Function GetTagFatherIndex(ByVal Tag As String) As Long
  Dim i As Long
  i = InStr(1, Tag, c_InerTab)
  If i > 0 Then
    GetTagFatherIndex = Abs(Fix(Val(Mid(Tag, i + Len(c_InerTab))) / 100))
  End If
End Function

Public Function GetTagChildIndex(ByVal Tag As String) As Long
  Dim i As Long
  Dim n As Long
  Dim q As Long
  
  i = InStr(1, Tag, c_InerTab)
  If i > 0 Then
    n = Val(Mid(Tag, i + Len(c_InerTab)))
    q = Abs(Fix(n / 100))
    GetTagChildIndex = (n - q * 100) * -1
  End If
End Function

' propiedades friend
' propiedades privadas
Private Sub pDoPropertyChange(ByRef Frm As Form)
  On Error Resume Next
  Frm.doPropertyChange
End Sub

Private Sub pLoadCtrlKeys()
  m_CtrlKeysLoaded = True
  
  ' Por ahora fijo, luego tendra que salir de la base o de
  ' algun otro lugar
  m_CtrlKeySave = "G"
  m_CtrlKeyPrint = "P"
  m_CtrlKeyCopy = "D"
  m_CtrlKeySearch = "B"
  m_CtrlKeyClose = "S"
  m_CtrlKeyNew = "N"
  m_CtrlKeyRefresh = "R"
  m_CtrlKeyApply = "A"
  m_CtrlKeyHistory = "H"
End Sub

Public Sub SendKeys(key As String)
  On Error Resume Next
  Interaction.SendKeys key
  Err.Clear
End Sub


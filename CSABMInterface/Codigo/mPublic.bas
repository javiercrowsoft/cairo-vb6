Attribute VB_Name = "mPublicAux"
Option Explicit

'--------------------------------------------------------------------------------
' mPublicAux
' 08-11-2003

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "mPublicAux"

#If PREPROC_ABMGENERIC Then
  Public Const c_MainIniFile = "Cairo.ini"
  Public Const c_K_MainIniConfig = "CONFIG"
  
  Public gAppPath As String
  Public gUnloadCancel As Boolean

  Public Const c_Items = "Items"
  Public Const c_Footer = "Footer"
  Public Const c_Header = "Header"

  Public Const c_InerTab = "_INNERTAB_"

  Public Const c_KeyTbPrint = "PRINT"
  Public Const c_KeyTbNext = "NEXT"
  Public Const c_KeyTbFirst = "FIRST"
  Public Const c_KeyTbPrevious = "PREVIOUS"
  Public Const c_KeyTbLast = "LAST"
  Public Const c_KeyTbSearch = "SEARCH"
  Public Const c_KeyTbSave = "SAVE"
  Public Const c_KeyTbNew = "NEW"
  Public Const c_KeyTbApply = "APPLY"
  Public Const c_KeyTbCopy = "COPY"
  Public Const c_KeyTbReload = "RELOAD"
  Public Const c_KeyTbClose = "CLOSE"
  Public Const c_KeyTbHelp = "HELP"
  Public Const c_KeyTbHistory = "HISTORY"
  Public Const c_KeyTbSignature = "SIGNATURE"
  Public Const c_KeyTbAttach = "ATTACH"
  Public Const c_KeyTbDelete = "DELETE"
  Public Const c_KeyTbAnular = "ANULAR"
  Public Const c_KeyTbEditState = "EDIT_STATE"
  Public Const c_MinHeight As Long = 7000
  Public Const c_MinWidth  As Long = 10000
  
  Private Const c_NoDate       As Date = 0

#End If

' estructuras
' variables privadas
Private m_CtrlKeySave       As String
Private m_CtrlKeyPrint      As String
Private m_CtrlKeyNew        As String
Private m_CtrlKeyCopy       As String
Private m_CtrlKeyClose      As String
Private m_CtrlKeySearch     As String
Private m_CtrlKeyRefresh    As String
Private m_CtrlKeysLoaded    As Boolean

Private m_SendKey           As cSendKey

' eventos
' propiedades publicas

#If PREPROC_CAIRO Then
  Public Sub CreateSendKey()
    Set m_SendKey = New cSendKey
  End Sub
#Else
  Public Sub Main()
    Set m_SendKey = New cSendKey
  End Sub
#End If

Public Sub SendKeys(ByVal str As String, Optional ByVal Wait As Boolean)
  DoEvents
  Sleep 10
  m_SendKey.PushKeys str
  DoEvents
  Sleep 10
End Sub

Public Sub ProcessVirtualKey(KeyCode As Integer, Shift As Integer, ByVal Frm As Object)
  On Error Resume Next
  
  Dim bSendKeyTab As Boolean
  Dim bSendKeyShifTab As Boolean
  Dim ActiveControl As Control
  
  If TypeOf Frm Is Form Then
    Set ActiveControl = Frm.ActiveControl
  Else
    Set ActiveControl = Frm
  End If
  
  If Shift = 0 Then

#If Not PREPROC_CAIRO Then ' Cairo no hace nada con el enter
    If ActiveControl Is Nothing Then Exit Sub
    If TypeOf ActiveControl Is cGrid Then Exit Sub

#If Not PREPROC_CSCONTROLS Then
    If TypeOf ActiveControl Is cGridAdvanced Then Exit Sub
#End If

    Select Case KeyCode
      Case vbKeyReturn
        If TypeOf ActiveControl Is cButton Or _
           TypeOf ActiveControl Is cButtonLigth Then Exit Sub
           

        If TypeOf ActiveControl Is cMaskEdit Then
          If ActiveControl.MultiLine Then Exit Sub
        End If

        pDoPropertyChange Frm
        bSendKeyTab = True
        
      Case vbKeyDown
      
#If PREPROC_CSCONTROLS Then
        If TypeOf ActiveControl Is ComboBox Then Exit Sub
#Else
        If TypeOf ActiveControl Is cComboBox Then Exit Sub
#End If
        If TypeOf ActiveControl Is cMaskEdit Then
          If ActiveControl.MultiLine Then Exit Sub
        End If

        bSendKeyTab = True
        
      Case vbKeyUp
      
#If PREPROC_CSCONTROLS Then
        If TypeOf ActiveControl Is ComboBox Then Exit Sub
#Else
        If TypeOf ActiveControl Is cComboBox Then Exit Sub
#End If
        If TypeOf ActiveControl Is cMaskEdit Then
          If ActiveControl.MultiLine Then Exit Sub
        End If
        bSendKeyShifTab = True

    End Select
  
    If bSendKeyTab Then
      SendKeys "{TAB}"
    ElseIf bSendKeyShifTab Then
      SendKeys "+{TAB}"
    End If
    
#End If
    
#If PREPROC_CAIRO Then
    Select Case KeyCode
      Case vbKeyDelete
        If Frm.CtrlKeyDelete Then KeyCode = 0
    End Select
#End If
    
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
    End Select
  End If
End Sub
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
End Sub
' funciones publicas
#If PREPROC_ABMGENERIC Then

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

  Public Sub SetToolbarIcons(ByVal tbMain As Toolbar)
    Set tbMain.ImageList = fResource.imgMain
    With tbMain.Buttons
      .Item(2).Image = 2
      .Item(3).Image = 1
      .Item(5).Image = 17
      .Item(7).Image = 18
      .Item(9).Image = 3
      .Item(10).Image = 11
      .Item(12).Image = 12
      .Item(13).Image = 13
      .Item(14).Image = 14
      .Item(15).Image = 15
      .Item(17).Image = 4
      .Item(19).Image = 5
      .Item(21).Image = 7
      .Item(22).Image = 10
      .Item(23).Image = 9
      .Item(25).Image = 16
      .Item(27).Image = 19
      .Item(29).Image = 8
      .Item(31).Image = 6
    End With
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
#End If

#If Not PREPROC_CAIRO Then
  Public Function Val(ByVal Value As String) As Double
    Dim SepDecimal As String
    SepDecimal = GetSepDecimal()
    
    Value = Replace(Value, SepDecimal, ".")
    Val = VBA.Val(Value)
  End Function
#End If

' funciones friend
' funciones privadas
' construccion - destruccion
'//////////////////////////////
'  Codigo estandar de errores
'  On Error GoTo ControlError
'
'  GoTo ExitProc
'ControlError:
'  MngError err,"", C_Module, ""
'  If Err.Number Then Resume ExitProc
'ExitProc:
'  On Error Resume Next

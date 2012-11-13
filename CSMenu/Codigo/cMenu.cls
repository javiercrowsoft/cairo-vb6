VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cMenu"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
'--------------------------------------------------------------------------------
' cMenu
' 29-04-2002

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cMenu"
' estructuras
' variables privadas
Private m_hwnd As Long
Private m_Coll As Collection
Private WithEvents m_oMngMenu As cPopupMenu
Attribute m_oMngMenu.VB_VarHelpID = -1
' eventos
' propiedades publicas
Public Property Set MngMenu(ByRef rhs As cPopupMenu)
  Set m_oMngMenu = rhs
End Property
' propiedades privadas
' funciones publicas
Public Function AddMenu(ByVal Caption As String, _
                        ByVal Key As Long, _
                        ByVal Father As String, _
                        ByVal Position As Long, _
                        ByVal Last As Boolean, _
                        ByVal IsSeparator As Boolean, _
                        ByVal HaveSeparator As Boolean, _
                        ByVal IsMainMenu As Boolean, _
                        ByVal IsPopUpMenu As Boolean, _
                        ByRef ObjMenu As Object, _
                        Optional ByVal lIconIndex As Long = -1)
                        
  If Key <> 0 Then
    If ExistsObjectInColl(m_Coll, GetKey(Key)) Then GoTo Done
  End If
  
  Dim Menu As cMenuInfo
  
  Set Menu = New cMenuInfo
  
  Menu.id = Key
  Menu.Caption = Caption
  Menu.Father = Father
  Menu.Position = Position
  Menu.Last = Last
  Menu.IsMainMenu = IsMainMenu
  Menu.IsPopUpMenu = IsPopUpMenu
  Menu.IsSeparator = IsSeparator
  Menu.HaveSeparator = HaveSeparator
  Menu.lIconIndex = lIconIndex
  Set Menu.ObjMenu = ObjMenu
  
  If HaveSeparator Then
    If Not AddSeparador(Father) Then Exit Function
  End If
  
  If Not AddMenu_(Menu, m_oMngMenu) Then Exit Function
  
  ' Agrego el menu a la colleccion
  If Key <> 0 Then
    m_Coll.Add Menu, GetKey(Menu.id)
  Else
    m_Coll.Add Menu
  End If
  
Done:
  AddMenu = True
End Function

Public Function AddSeparador(ByVal Father As String) As Boolean
  Dim Menu As cMenuInfo
  
  Set Menu = New cMenuInfo
  
  Menu.id = 0
  Menu.Caption = ""
  Menu.Father = Father
  Menu.Position = 0
  Menu.Last = True
  Menu.IsMainMenu = False
  Menu.IsPopUpMenu = False
  Menu.IsSeparator = True
  Set Menu.ObjMenu = Nothing
  
  If Not AddMenu_(Menu, m_oMngMenu) Then Exit Function
  
  ' Agrego el menu a la colleccion
  m_Coll.Add Menu
  
  AddSeparador = True
End Function

Public Sub ClickMenuByItemData(ByVal ItemData As Long)
  Dim i As Long
  For i = 1 To m_oMngMenu.Count
    If m_oMngMenu.ItemData(i) = ItemData Then
      m_oMngMenu_Click i
      Exit Sub
    End If
  Next
End Sub

' construccion - destruccion
Public Function Initialize(ByVal hwnd As Long, ByRef oMngMenu As cPopupMenu) As Boolean
  
  Set m_oMngMenu = oMngMenu
  
  CollClear m_Coll
  
  ClearMenu
  
  LoadMenusHost hwnd, oMngMenu
  m_hwnd = hwnd
End Function

Public Function Terminate() As Boolean
End Function

' funciones friend
' funciones privadas
Private Sub m_oMngMenu_Click(ItemNumber As Long)
  ProcessMenu m_oMngMenu.ItemData(ItemNumber)
End Sub

' construccino - destruccion
Private Sub Class_Initialize()
  Set m_Coll = New Collection
End Sub

Private Sub Class_Terminate()
  While m_Coll.Count > 0
    RemoveMenu GetKey(m_Coll(1).id), Nothing
    m_Coll.Remove 1
  Wend
  
  Set m_Coll = Nothing
  Terminate
  Set m_oMngMenu = Nothing
End Sub


'//////////////////////////////
'  Codigo estandar de errores
'  On Error GoTo ControlError
'
'  GoTo ExitProc
'ControlError:
'  MngError err,"", C_Module, ""
'  If Err.Number <> 0 Then Resume ExitProc
'ExitProc:
'  On Error Resume Next

Attribute VB_Name = "mMenus"
Option Explicit

'--------------------------------------------
' Menu
'Private Type MENUITEMINFO
'    cbSize As Long
'    fMask As Long
'    fType As Long
'    fState As Long
'    wID As Long
'    hSubMenu As Long
'    hbmpChecked As Long
'    hbmpUnchecked As Long
'    dwItemData As Long
'    dwTypeData As Long
'    cch As Long
'End Type

'Private Declare Function InsertMenu Lib "user32" Alias "InsertMenuA" (ByVal hmenu As Long, ByVal nPosition As Long, ByVal wFlags As Long, ByVal wIDNewItem As Long, ByVal lpNewItem As Any) As Long
'Private Declare Function CreateMenu Lib "user32" () As Long
'Private Declare Function GetMenu Lib "user32" (ByVal hwnd As Long) As Long
'Private Declare Function GetMenuItemInfo Lib "user32" Alias "GetMenuItemInfoA" (ByVal hmenu As Long, ByVal un As Long, ByVal B As Boolean, lpMenuItemInfo As MENUITEMINFO) As Long
'Private Declare Function GetMenuItemCount Lib "user32" (ByVal hmenu As Long) As Long
'Private Declare Function GetMenuString Lib "user32" Alias "GetMenuStringA" (ByVal hmenu As Long, ByVal wIDItem As Long, ByVal lpString As String, ByVal nMaxCount As Long, ByVal wFlag As Long) As Long

'Private Const MF_STRING = &H0&
'Private Const MF_BYPOSITION = &H400&
'Private Const MF_POPUP = &H10&
'Private Const MF_SEPARATOR = &H800&
'Private Const MF_BYCOMMAND = &H0&
'Private Const MIIM_TYPE = &H10&
'Private Const MIIM_SUBMENU = &H4&

Private Const KEY_HMENU = "MENU DE LA VENTANA"

Private m_Coll          As Collection
Private m_MenuLoaded    As Boolean

Public Sub ProcessMenu(ByVal id As Long)
  On Error Resume Next
  If ExisteInColl(id) Then
    m_Coll(GetKey(id)).ObjMenu.ProcessMenu id
  End If
End Sub

Public Function AddMenu_(ByRef Menu As cMenuInfo, ByRef oMngMenu As cPopupMenu) As Boolean
  Dim HMenuFather As Long
  Dim nPosition   As Long
  
  If m_Coll Is Nothing Then Set m_Coll = New Collection
  
  If Menu.IsSeparator Then Menu.Caption = "-"
  
  If Menu.Last Then
    nPosition = &HFFFFFFFF
  Else
    nPosition = Menu.Position
  End If
  
  If Menu.IsMainMenu Then
    HMenuFather = 0
  Else
    If Not ExistsObjectInColl(m_Coll, GetKeyForFather(Menu.Father)) Then
      HMenuFather = 1
      Menu.Caption = "H-" & Menu.Father & "-" & Menu.Caption
    Else
      HMenuFather = m_Coll(GetKeyForFather(Menu.Father)).Handle
    End If
  End If
  
  Menu.Handle = oMngMenu.AddItem(Menu.Caption, , Menu.id, HMenuFather, Menu.lIconIndex, , , GetKey(Menu.id))
  
  If Menu.id <> 0 Then
    m_Coll.Add Menu, GetKey(Menu.id)
  Else
    m_Coll.Add Menu
  End If
  
  AddMenu_ = True
  
  Exit Function
ControlError:
  MngError "SetPrestacion"
End Function

Public Sub RemoveMenu(ByVal Key As Variant, ByRef oMngMenu As cPopupMenu)
  On Error GoTo ControlError
  
  m_Coll.Remove Key
  
  If Not oMngMenu Is Nothing Then
    oMngMenu.RemoveItem Key
  End If
  
  Exit Sub
ControlError:
End Sub

Public Sub ClearMenu()
  On Error GoTo ControlError
  
  m_MenuLoaded = False
  
  While m_Coll.Count > 0
    m_Coll.Remove 1
  Wend
ControlError:
End Sub

Public Sub LoadMenusHost(ByVal hwnd As Long, ByRef oMngMenu As cPopupMenu)
  If m_MenuLoaded Then Exit Sub
  
  m_MenuLoaded = True
  
  If m_Coll Is Nothing Then Set m_Coll = New Collection
  
  Dim Menu As cMenuInfo
  Set Menu = New cMenuInfo
  Menu.Handle = 0
  
  m_Coll.Add Menu, KEY_HMENU
  
  LoadSubMenus oMngMenu
End Sub

Private Sub LoadSubMenus(ByRef oMngMenu As cPopupMenu)
  Dim i           As Integer
  Dim Count       As Integer
  Dim Menu        As cMenuInfo
  Dim hSubMenu    As Long
  Dim sCaption    As String
  Dim LenCaption  As Long
  
  Count = oMngMenu.Count
  
  ' si logre obtener la cantidad
  For i = 1 To Count
  
    ' si tiene submenu
    If oMngMenu.ItemHaveSubMenu(i) Then
    
      hSubMenu = i
      
      Set Menu = New cMenuInfo
      
      ' Obtengo el caption del menu
      Menu.Caption = oMngMenu.Caption(i)
      Menu.Handle = hSubMenu
      Menu.id = hSubMenu
      
      If Not ExisteInColl(Menu.id) Then
        m_Coll.Add Menu, GetKey(Menu.id)
      End If
    End If
  Next i
End Sub

'--------------------------------------------------------------------------------------
Private Function GetKeyForFather(ByVal sFather As String) As String
  Dim idFather As Long
  Dim o As Object
  
  
  ' Obtengo el id del padre
  For Each o In m_Coll
  
  If o.Caption = sFather Then
    idFather = o.id
    Exit For
  End If
  
  Next
  
  
  ' Devuelvo el key del padre
  GetKeyForFather = GetKey(idFather)
End Function

Private Function ExisteInColl(ByVal id As Long) As Boolean
  Dim s As Variant
  On Error GoTo ControlError
  s = m_Coll(GetKey(id)).id
  ExisteInColl = True
ControlError:
End Function

'--------------------------------------------------------------------------------------
Public Sub MngError(ByVal x As String)
  MsgBox x + vbCrLf + Err.Description
End Sub




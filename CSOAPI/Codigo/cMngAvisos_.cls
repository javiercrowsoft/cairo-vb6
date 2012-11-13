VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cMngAvisos_"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' cMngAvisos_
' 06-01-2004

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cMngAvisos_"
' estructuras
' variables privadas
Private WithEvents m_Menu     As cPopupMenu
Attribute m_Menu.VB_VarHelpID = -1
Private WithEvents m_exbrMain As ExplorerBar
Attribute m_exbrMain.VB_VarHelpID = -1
Private m_ilsIcons            As Object
Private m_ilsTitleIcons       As Object
Private m_CollAvisoTipo       As Collection
Private m_KeyItemSelected     As String
' eventos
' propiedades publicas
Public Property Get exbrMain() As ExplorerBar
  Set exbrMain = m_exbrMain
End Property

Public Property Set exbrMain(ByRef rhs As ExplorerBar)
  Set m_exbrMain = rhs

  On Error GoTo ControlError
  
  If m_exbrMain Is Nothing Then Exit Property
  
  pCreateMenu
  
  With m_exbrMain
    .Redraw = False
    .UseExplorerStyle = False
    
    .ImageList = m_ilsIcons.hIml
    .BarTitleImageList = m_ilsTitleIcons.hIml
    .Redraw = True
  End With

  GoTo ExitProc
ControlError:
  If Err.Number <> 11 Then ' Division by zero
    MngError Err, "exbrMain", C_Module, ""
  End If
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Property

Public Property Get ilsIcons() As Object
  Set ilsIcons = m_ilsIcons
End Property

Public Property Set ilsIcons(ByRef rhs As Object)
  Set m_ilsIcons = rhs
End Property

Public Property Get ilsTitleIcons() As Object
  Set ilsTitleIcons = m_ilsTitleIcons
End Property

Public Property Set ilsTitleIcons(ByRef rhs As Object)
  Set m_ilsTitleIcons = rhs
End Property

Public Property Get collAvisoTipo() As Collection
  Set collAvisoTipo = m_CollAvisoTipo
End Property
' propiedades friend
' propiedades privadas
' funciones publicas
Public Function Clear() As Boolean
  On Error GoTo ControlError
  
  m_exbrMain.Bars.Clear
  
  Clear = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "Clear", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Public Function AddSmallImage(ByRef ilsImage As Object, ByVal Index As Long) As Boolean
  On Error GoTo ControlError

  AddSmallImage = pAddImage(ilsImage, m_ilsIcons, Index)
  
  GoTo ExitProc
ControlError:
  MngError Err, "AddSmallImage", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Public Function AddSmallImage2(ByVal Index As Long, ByVal sKey As String, ByVal Handle As Long) As Boolean
  On Error GoTo ControlError

  AddSmallImage2 = pAddImage2(m_ilsIcons, Index, sKey, Handle)
  
  GoTo ExitProc
ControlError:
  MngError Err, "AddSmallImage2", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Public Function AddSmallListImages(ByRef ilsImage As Object) As Boolean
  On Error GoTo ControlError

  AddSmallListImages = pAddListImages(ilsImage, m_ilsIcons)
  
  GoTo ExitProc
ControlError:
  MngError Err, "AddSmallListImages", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Public Function AddImage(ByRef ilsImage As Object, ByVal Index As Long) As Boolean
  On Error GoTo ControlError

  AddImage = pAddImage(ilsImage, m_ilsTitleIcons, Index)
  
  GoTo ExitProc
ControlError:
  MngError Err, "AddImage", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Public Function AddListImages(ByRef ilsImage As Object) As Boolean
  On Error GoTo ControlError

  AddListImages = pAddListImages(ilsImage, m_ilsTitleIcons)
  
  GoTo ExitProc
ControlError:
  MngError Err, "AddListImages", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Public Function AddBar(ByVal Key As String, _
                       ByVal Title As String, _
                       ByVal IconKey As String, _
                       ByVal IsSpecial As Boolean, _
                       ByVal ToolTipText As String, _
                       ByRef WatermarkPicture As StdPicture) As Boolean
                       
  On Error GoTo ControlError
  
  Dim IconIndex  As Long
  
  If IconKey <> "" Then
    IconIndex = m_ilsTitleIcons.ItemIndex(IconKey)
  End If
  
  With m_exbrMain.Bars.Add(, Key, Title)
    If IconIndex <> 0 Then
      .IconIndex = IconIndex
    End If
    .IsSpecial = IsSpecial
    .ToolTipText = ToolTipText
    .WatermarkPicture = WatermarkPicture
  End With

  AddBar = True

  GoTo ExitProc
ControlError:
  MngError Err, "AddBar", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Public Function AddItem(ByVal BarKey As String, _
                        ByVal ItemKey As String, _
                        ByVal Text As String, _
                        ByVal IconKey As String, _
                        ByVal ItemType As csExplorerBarItemTypes, _
                        ByVal ToolTipText As String, _
                        ByVal ClientId As Long) As Boolean
  On Error GoTo ControlError
  
  Dim IconIndex  As Long
  Dim Item       As cExplorerBarItem
  
  If IconKey <> "" Then
    IconIndex = m_ilsIcons.ItemIndex(IconKey) + 1
  End If
  
  If IconIndex > 0 Then
    Set Item = m_exbrMain.Bars(BarKey).Items.Add(, ItemKey, Text, IconIndex - 1, ItemType)
  Else
    Set Item = m_exbrMain.Bars(BarKey).Items.Add(, ItemKey, Text, , ItemType)
  End If
  
  Item.ToolTipText = ToolTipText
  Item.Tag = ClientId
  
  AddItem = True

  GoTo ExitProc
ControlError:
  MngError Err, "AddItem", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

' funciones friend
' funciones privadas
' Menu
Private Sub m_Menu_Click(ItemNumber As Long)
  Select Case m_Menu.ItemKey(ItemNumber)
    Case "popAvisoDelete"
      pDeleteItem
  End Select
End Sub

Private Sub pDeleteItem()
  Dim Aviso As cAviso
  Set Aviso = New cAviso
  
  Aviso.Delete Val(Mid(m_KeyItemSelected, 2))
End Sub

Private Sub pCreateMenu()
  Dim iPTop   As Long
  Dim iP      As Long
  Dim iP2     As Long
  Dim iP3     As Long
  
  If m_Menu Is Nothing Then
    Set m_Menu = New cPopupMenu
  End If
  
  m_Menu.Clear

  ' Creating a Menu:
  With m_Menu
    ' Initial set up:
    .hWndOwner = m_exbrMain.Parent.hWnd
    .OfficeXpStyle = True
    
    ' File menu:
    iP = .AddItem("&Borrar", , , iPTop, , , , "popAvisoDelete")
  End With
End Sub

Private Sub m_exbrMain_ItemRightClickEx(itm As CSExplorerBar.cExplorerBarItem, ByVal x As Long, ByVal y As Long)
  On Error GoTo ControlError
  
  m_KeyItemSelected = itm.Key
  
  x = m_exbrMain.Left + x
  y = m_exbrMain.Top + y
  
  m_Menu.ShowPopupMenu x, y
  
  GoTo ExitProc
ControlError:
  MngError Err, "m_exbrMain_ItemRightClickEx", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub m_exbrMain_ItemClick(itm As CSExplorerBar.cExplorerBarItem)
  On Error GoTo ControlError
  
  Dim AvisoTipo As cAvisoTipo
  Dim sKey      As String
  
  sKey = pGetBarKeyFromItem(itm)
  
  Set AvisoTipo = m_CollAvisoTipo.Item(sKey)
  
  Dim o As cIEditGeneric
  Dim Editor As cIABMGeneric

  Set o = CSKernelClient2.CreateObject(AvisoTipo.ObjetoEdicion)
  Set Editor = CSKernelClient2.CreateObject("CSABMInterface2.cABMGeneric")
  Set o.ObjABM = Editor

  o.Edit Val(itm.Tag)

  GoTo ExitProc
ControlError:
  MngError Err, "m_exbrMain_ItemClick", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub m_exbrMain_ItemRightClick(itm As CSExplorerBar.cExplorerBarItem)
'
End Sub

Private Function pGetBarKeyFromItem(itm As CSExplorerBar.cExplorerBarItem) As String
  Dim i As Long
  Dim j As Long
  
  For i = 1 To m_exbrMain.Bars.Count
    For j = 1 To m_exbrMain.Bars(i).Items.Count
      If m_exbrMain.Bars(i).Items.Item(j).Key = itm.Key Then
        pGetBarKeyFromItem = m_exbrMain.Bars(i).Key
        Exit Function
      End If
    Next
  Next
End Function

Private Function pAddListImages(ByRef FromilsImage As Object, ByRef ToilsImage As Object) As Boolean
  On Error GoTo ControlError
  Dim sKey As String
  Dim i As Long
  
  For i = 1 To FromilsImage.ImageCount
    With ToilsImage
      sKey = FromilsImage.ItemKey(i)
      If Not pExistsIcon(ToilsImage, sKey) Then
        .AddFromHandle FromilsImage.ItemPicture(i).Handle, IMAGE_CURSOR
        .ItemKey(.ImageCount) = sKey
      End If
    End With
  Next

  pAddListImages = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "pAddListImages", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pAddImage(ByRef FromilsImage As Object, ByRef ToilsImage As Object, ByVal Index As Long) As Boolean
  On Error GoTo ControlError
  Dim sKey As String
  
  With ToilsImage
    sKey = FromilsImage.ItemKey(Index)
    If Not pExistsIcon(ToilsImage, sKey) Then
      .AddFromHandle FromilsImage.ItemPicture(Index).Handle, IMAGE_CURSOR
      .ItemKey(.ImageCount) = sKey
    End If
  End With

  pAddImage = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "pAddImage", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pAddImage2(ByRef ToilsImage As Object, _
                            ByVal Index As Long, _
                            ByVal sKey As String, _
                            ByVal Handle As Long) As Boolean
  On Error GoTo ControlError
  
  With ToilsImage
    If Not pExistsIcon(ToilsImage, sKey) Then
      .AddFromHandle Handle, IMAGE_CURSOR
      .ItemKey(.ImageCount) = sKey
    End If
  End With

  pAddImage2 = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "pAddImage2", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pExistsIcon(ByRef ilsImage As Object, ByVal sKey As String) As Boolean
  On Error Resume Next
  Dim n As Long
  Err.Clear
  n = ilsImage.ItemIndex(sKey)
  pExistsIcon = Err.Number = 0
End Function
' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError

  Set m_CollAvisoTipo = New Collection
  
  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
  On Error GoTo ControlError

  Set m_exbrMain = Nothing
  Set m_ilsIcons = Nothing
  Set m_ilsTitleIcons = Nothing
  
  CollClear m_CollAvisoTipo
  Set m_CollAvisoTipo = Nothing
  
  GoTo ExitProc
ControlError:
  MngError Err, "Class_Terminate", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

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



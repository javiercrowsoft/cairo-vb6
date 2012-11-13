VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Object = "{353A8433-36B8-422E-ABBD-36CEE8BE628E}#1.0#0"; "CSButton.ocx"
Begin VB.Form fHelp 
   Appearance      =   0  'Flat
   ClientHeight    =   6885
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   11310
   Icon            =   "fHelp.frx":0000
   KeyPreview      =   -1  'True
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   6885
   ScaleWidth      =   11310
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox txDescrip 
      BorderStyle     =   0  'None
      Height          =   1365
      Left            =   80
      MultiLine       =   -1  'True
      ScrollBars      =   3  'Both
      TabIndex        =   12
      Top             =   2900
      Width           =   8320
   End
   Begin VB.ComboBox cbKeyFilter 
      Height          =   315
      Left            =   5880
      Style           =   2  'Dropdown List
      TabIndex        =   11
      Top             =   300
      Width           =   2415
   End
   Begin VB.ComboBox cbFilter 
      Height          =   315
      Left            =   2880
      Style           =   2  'Dropdown List
      TabIndex        =   10
      Top             =   300
      Width           =   1755
   End
   Begin CSButton.cButtonLigth cmdNew 
      Height          =   330
      Left            =   150
      TabIndex        =   2
      Top             =   6345
      Width           =   1185
      _ExtentX        =   2090
      _ExtentY        =   582
      Caption         =   "&Nuevo   "
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      FontName        =   "MS Sans Serif"
      FontSize        =   8.25
      Picture         =   "fHelp.frx":058A
   End
   Begin VB.TextBox txSearch 
      BorderStyle     =   0  'None
      Height          =   270
      Left            =   810
      TabIndex        =   1
      Top             =   310
      Width           =   2040
   End
   Begin CSButton.cButtonLigth cmdEdit 
      Height          =   330
      Left            =   1410
      TabIndex        =   3
      Top             =   6345
      Width           =   1185
      _ExtentX        =   2090
      _ExtentY        =   582
      Caption         =   "&Editar   "
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      FontName        =   "MS Sans Serif"
      FontSize        =   8.25
      Picture         =   "fHelp.frx":0B24
   End
   Begin CSButton.cButtonLigth cmdDocs 
      Height          =   315
      Left            =   4680
      TabIndex        =   4
      Top             =   300
      Width           =   315
      _ExtentX        =   556
      _ExtentY        =   556
      Caption         =   ""
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      FontName        =   "MS Sans Serif"
      FontSize        =   8.25
      BackColor       =   -2147483643
      Picture         =   "fHelp.frx":10BE
      BackColorPressed=   -2147483643
      BackColorUnpressed=   -2147483643
   End
   Begin MSComctlLib.ListView grData 
      Height          =   2010
      Left            =   150
      TabIndex        =   5
      Top             =   735
      Width           =   8145
      _ExtentX        =   14367
      _ExtentY        =   3545
      LabelEdit       =   1
      MultiSelect     =   -1  'True
      LabelWrap       =   -1  'True
      HideSelection   =   0   'False
      _Version        =   393217
      Icons           =   "ImgTree"
      SmallIcons      =   "ImgTree"
      ForeColor       =   -2147483640
      BackColor       =   -2147483643
      Appearance      =   0
      NumItems        =   0
   End
   Begin CSButton.cButtonLigth cmdOk 
      Height          =   330
      Left            =   5940
      TabIndex        =   6
      Top             =   6360
      Width           =   1185
      _ExtentX        =   2090
      _ExtentY        =   582
      Caption         =   "&Aceptar"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      FontName        =   "MS Sans Serif"
      FontSize        =   8.25
   End
   Begin CSButton.cButtonLigth cmdCancel 
      Height          =   330
      Left            =   7200
      TabIndex        =   7
      Top             =   6360
      Width           =   1185
      _ExtentX        =   2090
      _ExtentY        =   582
      Caption         =   "&Cancelar"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      FontName        =   "MS Sans Serif"
      FontSize        =   8.25
   End
   Begin MSComctlLib.ImageList ImgTree 
      Left            =   5760
      Top             =   2760
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483643
      ImageWidth      =   16
      ImageHeight     =   16
      MaskColor       =   12632256
      _Version        =   393216
      BeginProperty Images {2C247F25-8591-11D1-B16A-00C0F0283628} 
         NumListImages   =   2
         BeginProperty ListImage1 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fHelp.frx":1218
            Key             =   ""
         EndProperty
         BeginProperty ListImage2 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fHelp.frx":17B2
            Key             =   ""
         EndProperty
      EndProperty
   End
   Begin VB.Timer tmSearch 
      Enabled         =   0   'False
      Interval        =   1000
      Left            =   5100
      Top             =   900
   End
   Begin CSButton.cButtonLigth cmdAdd 
      Height          =   330
      Left            =   5040
      TabIndex        =   8
      Top             =   300
      Width           =   825
      _ExtentX        =   1455
      _ExtentY        =   582
      Caption         =   "&Agregar"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      FontName        =   "MS Sans Serif"
      FontSize        =   8.25
   End
   Begin MSComctlLib.ListView grSelected 
      Height          =   1710
      Left            =   150
      TabIndex        =   9
      Top             =   4395
      Width           =   8145
      _ExtentX        =   14367
      _ExtentY        =   3016
      LabelEdit       =   1
      MultiSelect     =   -1  'True
      LabelWrap       =   -1  'True
      HideSelection   =   0   'False
      _Version        =   393217
      Icons           =   "ImgTree"
      SmallIcons      =   "ImgTree"
      ForeColor       =   -2147483640
      BackColor       =   -2147483643
      Appearance      =   0
      NumItems        =   0
   End
   Begin VB.Shape shDescrip 
      BackStyle       =   1  'Opaque
      BorderColor     =   &H80000010&
      Height          =   1395
      Left            =   60
      Top             =   2880
      Width           =   8355
   End
   Begin VB.Shape shSelectedGrid 
      BorderColor     =   &H00FFC0C0&
      Height          =   1755
      Left            =   135
      Top             =   4380
      Width           =   8190
   End
   Begin VB.Line Line2 
      BorderColor     =   &H80000014&
      X1              =   0
      X2              =   8780
      Y1              =   6255
      Y2              =   6255
   End
   Begin VB.Line Line1 
      BorderColor     =   &H80000010&
      X1              =   0
      X2              =   8780
      Y1              =   6240
      Y2              =   6240
   End
   Begin VB.Shape Shape3 
      BorderColor     =   &H00FFC0C0&
      BorderWidth     =   2
      Height          =   285
      Left            =   810
      Top             =   315
      Width           =   2055
   End
   Begin VB.Shape shGrid 
      BorderColor     =   &H00FFC0C0&
      Height          =   2055
      Left            =   135
      Top             =   720
      Width           =   8190
   End
   Begin VB.Label Label1 
      BackStyle       =   0  'Transparent
      Caption         =   "&Buscar:"
      ForeColor       =   &H80000008&
      Height          =   255
      Left            =   180
      TabIndex        =   0
      Top             =   360
      Width           =   690
   End
   Begin VB.Shape shMain 
      BackStyle       =   1  'Opaque
      BorderColor     =   &H80000010&
      Height          =   2715
      Left            =   60
      Top             =   120
      Width           =   8355
   End
   Begin VB.Shape shSelected 
      BackStyle       =   1  'Opaque
      BorderColor     =   &H80000010&
      Height          =   1875
      Left            =   60
      Top             =   4320
      Width           =   8355
   End
End
Attribute VB_Name = "fHelp"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' FrmHelp
' 23-01-00

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
  ' constantes
  ' estructuras
  ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "fHelp"

Private Const IMG_Active_TRUE = 3
Private Const IMG_Active_FALSE = 4

' eventos
Public Event ReloadRs()

' estructuras
' variables privadas
Private m_Id                As String
Private m_Name              As String
Private m_Code              As String
Private m_OK                As Boolean
Private m_rs                As ADODB.Recordset
Private m_Searched          As String
Private m_last_prhc_id      As Long
Private m_Grid              As cListView
Private m_LastChange        As Single
Private m_HaveTop           As Boolean
Private m_ObjEditName       As String
Private m_ObjABMName        As String
Private m_ClientTable       As String
Private m_FilterType        As Long
Private m_bDontClick        As Boolean
Private m_bDontClickFilter  As Boolean

Private m_bSecondKeyPress     As Boolean
Private m_Done                As Boolean
Private m_bSelectedVisible    As Boolean
Private m_bDescripVisible     As Boolean

Private m_bIsKeyFilterHelp    As Boolean
 
Private Type t_KeyFilter
  
  Id      As Long
  Key     As String
  Name    As String
  
End Type

Private m_vKeyFilters() As t_KeyFilter

' Properties publicas
Public Property Let ClientTable(ByVal rhs As String)
   m_ClientTable = rhs
End Property

Public Property Get Id() As String
  Id = m_Id
End Property
Public Property Get Code() As String
  Code = m_Code
End Property
Public Property Get FormName() As String
  FormName = m_Name
End Property
Public Property Get Ok() As Boolean
  Ok = m_OK
End Property
Public Property Set rs(ByVal rhs As Recordset)
  Set m_rs = rhs
End Property

Public Property Let HaveTop(ByRef rhs As Boolean)
  m_HaveTop = rhs
End Property

Public Property Get ObjEditName() As String
  ObjEditName = m_ObjEditName
End Property
Public Property Let ObjEditName(ByVal rhs As String)
  m_ObjEditName = rhs
End Property

Public Property Get ObjABMName() As String
  ObjABMName = m_ObjABMName
End Property
Public Property Let ObjABMName(ByVal rhs As String)
  m_ObjABMName = rhs
End Property

Public Property Get FilterType() As Integer
  FilterType = m_FilterType
End Property

Public Property Get IsKeyFilterHelp() As Boolean
  IsKeyFilterHelp = m_bIsKeyFilterHelp
End Property

Public Property Get prch_id() As Long
  prch_id = ListID(cbKeyFilter)
End Property

' Properties privadas
Private Property Get ObjEdit() As Object
  On Error GoTo ControlError
  
  Set ObjEdit = GetObjectEdit
  Exit Property
ControlError:
  MngError Err, "ObjEdit", "fTree", ""
End Property
' funciones publicas
Public Sub InitKeyFilter()
  cbKeyFilter.Clear
  ReDim m_vKeyFilters(0)
End Sub

Public Sub ShowKeyFilter(ByVal prhc_id_default As Long)
  m_bIsKeyFilterHelp = True
  cbKeyFilter.Visible = True
  
  ListSetListIndexForId cbKeyFilter, prhc_id_default
End Sub

Public Sub AddKeyFilter(ByVal prhc_id As Long, _
                        ByVal prhc_tecla As String, _
                        ByVal prhc_nombre As String)
  
  ReDim Preserve m_vKeyFilters(UBound(m_vKeyFilters) + 1)
  
  With m_vKeyFilters(UBound(m_vKeyFilters))
  
    .Id = prhc_id
    .Key = prhc_tecla
    .Name = prhc_nombre
    
  End With
  
  ListAdd cbKeyFilter, prhc_nombre, _
                       prhc_id

End Sub

Public Function LoadItems() As Boolean
  On Error GoTo ControlError
  
  Set m_Grid = New cListView
  m_Grid.SetPropertys grData
  grData.MultiSelect = False
  m_Grid.IMG_Active_FALSE = IMG_Active_FALSE
  m_Grid.IMG_Active_TRUE = IMG_Active_TRUE
  m_Grid.LoadFromRecordSet grData, m_rs
  m_Grid.GetColumnWidth grData, Caption
  pHideAuxCols
  If Not m_bDescripVisible Then
    m_bDescripVisible = pHaveDescrip()
    If m_bDescripVisible Then
      SizeControls
    End If
  End If
  LoadItems = True

  GoTo ExitProc
ControlError:
  MngError Err, "LoadItems", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pHaveDescrip() As Boolean
  If m_rs Is Nothing Then Exit Function
  If m_rs.State <> adStateOpen Then Exit Function
  
  Dim fld As ADODB.Field
  For Each fld In m_rs.Fields
    If fld.Name = "_col_descrip_" Then
      pHaveDescrip = True
      Exit Function
    End If
  Next
End Function

Private Sub cbFilter_Click()
  On Error Resume Next
  If m_bDontClick Then
    m_bDontClick = False
  Else
    Search
  End If
End Sub

Private Sub cbKeyFilter_Click()
  On Error Resume Next
  If m_bDontClickFilter Then
    m_bDontClickFilter = False
  Else
    m_Searched = vbNullString
    Search
  End If
End Sub

Private Sub cmdAdd_Click()
  
  On Error Resume Next
  
  Dim ItemData  As MSComctlLib.ListItem
  Dim Item      As MSComctlLib.ListItem
  Dim SubItem   As MSComctlLib.ListSubItem
  
  If Not m_bSelectedVisible Then
    
    m_Grid.SetPropertys grSelected
    grSelected.MultiSelect = False
    
    Dim k As Long
    For k = 1 To grData.ColumnHeaders.Count
      grSelected.ColumnHeaders.Add , , grData.ColumnHeaders.Item(k).Text, grData.ColumnHeaders.Item(k).Width
    Next
    
    m_bSelectedVisible = True
    shSelected.Visible = True
    shSelectedGrid.Visible = True
    grSelected.Visible = True
    SizeControls
    
  End If
  
  Dim i       As Long
  Dim j       As Long
  Dim bFound  As Boolean
  Dim Id      As Long
  
  For i = 1 To grData.ColumnHeaders.Count
    grSelected.ColumnHeaders.Item(i).Width = grData.ColumnHeaders.Item(i).Width
  Next
  
  For i = 1 To grData.ListItems.Count

    If grData.ListItems(i).Selected Then

      Set ItemData = grData.ListItems(i)
      Id = GetIdFromKey(grData.ListItems(i).Key)
      bFound = False
      
      For j = 1 To grSelected.ListItems.Count
        
        If Id = GetIdFromKey(grSelected.ListItems.Item(j).Key) Then
          bFound = True
          Exit For
        End If
      Next
  
      If Not bFound Then
        
        Set Item = grSelected.ListItems.Add(, GetKey(Id))
        With Item
          .Text = grData.ListItems(i).Text
        End With
        
        For j = 1 To grData.ColumnHeaders.Count
          
          Item.ListSubItems.Add , , ItemData.SubItems(j)
          
        Next
      End If
    End If
  Next
  
End Sub

Private Sub cmdCancel_Click()
  Form_KeyPress vbKeyEscape
End Sub

Private Sub cmdDocs_Click()
  On Error GoTo ControlError
  
  Dim Id As Long
  Id = m_Grid.GetSelectedId(grData)
  If Id = 0 Then Exit Sub
  
  Dim Doc As cDocDigital
  Set Doc = New cDocDigital

  Doc.ClientTable = m_ClientTable
  Doc.ClientTableID = Id

  Doc.ShowDocs gDB

  GoTo ExitProc
ControlError:
  MngError Err, "cmdDocs_Click", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub cmdEdit_Click()
  On Error GoTo ControlError
  
  Dim mouse As cMouseWait
  Set mouse = New cMouseWait
  
  Dim o As cIEditGeneric
  Set o = ObjEdit
  
  If o Is Nothing Then Exit Sub
  
  If m_Grid.GetSelectedId(grData) = 0 Then
    
    MsgInfo "Seleccione un item de la lista para editar"
  
  Else
    
    If Not o.Edit(m_Grid.GetSelectedId(grData), True) Then
      Exit Sub
    End If
    m_LastChange = 0
    m_Searched = "sdkfh&#/543" ' Pa forza el refresh pues
    Search

  End If

  GoTo ExitProc
ControlError:
  MngError Err, "cmdEdit_Click", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub cmdNew_Click()
  On Error GoTo ControlError
  
  Dim mouse As cMouseWait
  Set mouse = New cMouseWait
  
  Dim Obj As Object
  Dim o   As cIEditGeneric
  
  Set Obj = ObjEdit
  
  If Obj Is Nothing Then Exit Sub
  
  Set o = Obj
  
  If Not o.Edit(csNO_ID, True) Then
    Exit Sub
  End If
    
  m_Id = Obj.Id
  m_Name = Obj.Nombre
  m_Code = Obj.Codigo
  m_OK = True
  
  Sleep 250
  
  Me.Hide
  
  GoTo ExitProc
ControlError:
  MngError Err, "cmdNew_Click", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Function GetObjectEdit() As Object
  On Error GoTo ControlError
  
  Dim Obj As Object
  Dim o As cIEditGeneric
  
  Dim Editor As cIABMGeneric
  Set Obj = CSKernelClient2.CreateObject(m_ObjEditName)
  Set o = Obj
  
  Set Editor = CSKernelClient2.CreateObject(m_ObjABMName)
  Set o.ObjABM = Editor
  Set GetObjectEdit = Obj

  GoTo ExitProc
ControlError:
  MngError Err, "GetObjectEdit", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Sub cmdOk_Click()
  grData_DblClick
End Sub

Private Sub Form_Activate()
  On Error Resume Next
  If m_Done Then Exit Sub
  m_Done = True
  grData.Refresh
End Sub

Private Sub Form_KeyUp(KeyCode As Integer, Shift As Integer)
  pProcessKeyFilter KeyCode, Shift
End Sub

' funciones privadas
Private Sub Form_Load()
  On Error GoTo ControlError
  
  Me.KeyPreview = True
  
  m_bIsKeyFilterHelp = False
  m_Done = False
  G_FormResult = True
  m_OK = False
  
  cmdAdd.Visible = False
  grSelected.Visible = False
  shSelected.Visible = False
  shSelectedGrid.Visible = False
  m_bSelectedVisible = False
  m_bDescripVisible = False
  
  Set grData.SmallIcons = ImgTree
  Set grData.ColumnHeaderIcons = ImgTree
  
  Set grSelected.SmallIcons = ImgTree
  Set grSelected.ColumnHeaderIcons = ImgTree
  
  cbFilter.Clear
  ListAdd cbFilter, "Contiene a ...", c_HelpFilterHaveTo
  ListAdd cbFilter, "Comienza con ...", c_HelpFilterBeginLike
  ListAdd cbFilter, "Termina con ...", c_HelpFilterEndLike
  ListAdd cbFilter, "Usar comodines (*)", c_HelpFilterWildcard
  ListAdd cbFilter, "Igual a ...", c_HelpFilterIsLike
  
  cbKeyFilter.Visible = False
  cbKeyFilter.Clear
  
  txDescrip.Visible = False
  shDescrip.Visible = False
  
  m_bDontClick = True
  m_bDontClickFilter = True

  ListSetListIndexForId cbFilter, c_HelpFilterHaveTo
  
  Dim bVisible As Boolean
  bVisible = m_ObjABMName <> "" And m_ObjEditName <> ""
  cmdEdit.Visible = bVisible
  cmdNew.Visible = bVisible

  GoTo ExitProc
ControlError:
  MngError Err, "Form_Load", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
  If UnloadMode <> vbFormCode Then
    G_FormResult = False
    m_OK = False
  End If
  tmSearch.Enabled = False
End Sub

Private Sub Form_KeyPress(KeyAscii As Integer)
  On Error GoTo ControlError
  
  If KeyAscii = vbKeyEscape Then
    G_FormResult = False
    m_OK = False
    Me.Hide
  ElseIf KeyAscii = vbKeyReturn Then
  
    If tmSearch.Enabled Then
      m_LastChange = 0
      Search
    End If
  
    If grData.ListItems.Count = 1 Then
      grData.ListItems(1).Selected = True
    End If
    If Not (grData.SelectedItem Is Nothing) Then
      KeyAscii = 0
      grData_DblClick
    End If
  End If

  GoTo ExitProc
ControlError:
  MngError Err, "Form_KeyPress", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Form_Unload(Cancel As Integer)
  On Error Resume Next
  
  m_Grid.SaveColumnWidth grData, Caption
  Set m_Grid = Nothing
  CSKernelClient2.UnloadForm Me, Me.Caption
End Sub

Private Sub Form_Resize()
  SizeControls
End Sub

Private Sub SizeControls()
  
  'SetPosControls
  If WindowState = vbMinimized Then Exit Sub

  On Error Resume Next
  
  If grData.MultiSelect Then
  
    If Me.Width < 9000 Then
      Me.Width = 9000
    End If
  
  Else
    
    If Me.Width < 6800 Then
      Me.Width = 6800
    End If
    
  End If
  
  Dim iHeightDescrip   As Single

  If m_bDescripVisible Then
    iHeightDescrip = shDescrip.Height + 200
  End If
  
  '----------------------------------------------------
    
  If m_bSelectedVisible Then
  
    If Me.Height < 5000 Then
      Me.Height = 5000
    End If
  
    Dim iHeightShMain    As Single
    Dim iHeightData      As Single
    Dim iHeightSelected  As Single
  
    ' Obtengo el Ancho disponible para un frame que ocupa toda la pantalla
    ' menos un top y un bottom de 500 donde estan los botones (nuevo, editar, aceptar y cancelar)
    '
    iHeightShMain = ScaleHeight - shMain.Top - 600
    
    ' Ahora obtengo el alto de la grilla principal que ocupa todo el frame
    ' menos lo que ocupa la etiqueta de descripciones (solo si esta visible)
    '
    iHeightData = (iHeightShMain - grData.Top - iHeightDescrip) * 0.5 - 80
    
    ' Ahora obtengo el alto de la grilla de seleccionados
    '
    iHeightSelected = iHeightData
    
    ' Ahora le quito al shape principal lo que ocupa la grilla de seleccionados
    ' y la etiqueta de descripciones
    '
    iHeightShMain = iHeightShMain - iHeightSelected - iHeightDescrip - 100
        
  '---------------------------------------------------
  
    With grData
      .Height = iHeightData
      .Width = ScaleWidth - .Left * 2
      shGrid.Move .Left - 10, .Top - 10, .Width + 40, .Height + 40
    End With
    With shMain
      .Height = iHeightShMain
      .Width = ScaleWidth - .Left * 2
    End With
    
  '---------------------------------------------------
    
    With grSelected
      .Height = iHeightSelected - 300
      .Width = ScaleWidth - .Left * 2
      .Top = shMain.Top + iHeightDescrip + shMain.Height + 200
      shSelectedGrid.Move .Left - 10, .Top - 20, .Width + 40, .Height + 40
    End With
    With shSelected
      .Top = grSelected.Top - 150
      .Height = iHeightSelected
      .Width = ScaleWidth - .Left * 2
    End With
  
  Else
  
    If Me.Height < 3000 Then
      Me.Height = 3000
    End If
    
    With grData
      .Height = ScaleHeight - .Top - 680 - iHeightDescrip
      .Width = ScaleWidth - .Left * 2
      shGrid.Move .Left - 10, .Top - 10, .Width + 40, .Height + 40
    End With
    With shMain
      .Height = ScaleHeight - .Top - 600 - iHeightDescrip
      .Width = ScaleWidth - .Left * 2
    End With
  
  End If
  
  If m_bDescripVisible Then
  
    shDescrip.Visible = True
    txDescrip.Visible = True
    
    With txDescrip
      .Width = ScaleWidth - .Left * 2
      .Top = shMain.Top + shMain.Height + 200
    End With
    With shDescrip
      .Top = txDescrip.Top - 20
      .Width = ScaleWidth - .Left * 2
      .Height = txDescrip.Height + 50
    End With
    
  End If
  
  Line1.Y1 = ScaleHeight - 550
  Line1.X2 = ScaleWidth
  Line1.Y2 = Line1.Y1

  Line2.Y1 = ScaleHeight - 540
  Line2.X2 = ScaleWidth
  Line2.Y2 = Line2.Y1
  
  cmdNew.Top = ScaleHeight - 420
  cmdEdit.Top = cmdNew.Top
  cmdOk.Top = cmdNew.Top
  cmdCancel.Top = cmdNew.Top
  cmdOk.Left = ScaleWidth - cmdOk.Width - cmdCancel.Width - 80
  cmdCancel.Left = ScaleWidth - cmdCancel.Width - 40
End Sub

Private Sub grData_ColumnClick(ByVal ColumnHeader As MSComctlLib.ColumnHeader)
  ListViewSortColumns grData, ColumnHeader
End Sub

Private Sub grData_DblClick()
  On Error GoTo ControlError
  
  m_Id = vbNullString
  
  If grData.MultiSelect Then
    If grSelected.ListItems.Count Then
      grSelected.MultiSelect = True
      Dim i As Long
      For i = 1 To grSelected.ListItems.Count
        grSelected.ListItems.Item(i).Selected = True
      Next
      
      m_Id = m_Grid.GetSelectedIds(grSelected)
    
    End If
    
    If LenB(m_Id) Then
      m_Id = m_Id & "," & m_Grid.GetSelectedIds(grData)
    Else
      m_Id = m_Grid.GetSelectedIds(grData)
    End If
  Else
    m_Id = m_Grid.GetSelectedId(grData)
  End If
  m_Name = m_Grid.GetSelectedName(grData)
  m_Code = m_Grid.GetSelectedCode(grData)
  m_OK = True
  Sleep 250
  Me.Hide

  GoTo ExitProc
ControlError:
  MngError Err, "grData_DblClick", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub grData_ItemClick(ByVal Item As MSComctlLib.ListItem)
  If m_bDescripVisible Then
    txDescrip = pGetTextDescrip()
  End If
End Sub

Private Sub grData_KeyUp(KeyCode As Integer, Shift As Integer)
  On Error Resume Next
  If KeyCode = vbKeyUp Then
    If grData.SelectedItem Is Nothing Then
      If grData.ListItems.Count = 0 Then
        txSearch.SetFocus
      End If
    Else
      If grData.SelectedItem.Index = 1 Then
        If m_bSecondKeyPress Then
          m_bSecondKeyPress = False
          txSearch.SetFocus
        Else
          m_bSecondKeyPress = True
        End If
      End If
    End If
  Else
    m_bSecondKeyPress = False
  End If
End Sub

Private Sub grData_LostFocus()
  m_bSecondKeyPress = False
End Sub

Private Sub grSelected_KeyUp(KeyCode As Integer, Shift As Integer)
  On Error Resume Next
  If KeyCode = vbKeyDelete Then
    If Not grSelected.SelectedItem Is Nothing Then
      grSelected.ListItems.Remove grSelected.SelectedItem.Index
    End If
  End If
End Sub

Private Sub tmSearch_Timer()
  Search
End Sub

Private Sub Search()
  On Error GoTo ControlError
  
  Dim iTimer As Single
  
  iTimer = Timer
  
  tmSearch.Enabled = False

  If m_FilterType <> ListID(cbFilter) Then
    
    m_FilterType = ListID(cbFilter)
  
  Else
    
    If iTimer - m_LastChange < 1 And m_Searched = txSearch.Text Then
      GoTo ExitProc
    End If
    
    If m_Searched = txSearch.Text Then GoTo ExitProc
    
  End If
  
  Dim toSearch As String
  
  toSearch = txSearch.Text
  
  If m_HaveTop Then
    RaiseEvent ReloadRs
  End If
  
  Dim Filter As String
  
  If m_HaveTop Then
    Filter = vbNullString
  Else
    Filter = txSearch.Text
  End If
  
  If m_Grid.LoadFromRecordSetEx( _
                grData, _
                m_rs, _
                m_FilterType = c_HelpFilterHaveTo, _
                Filter) Then
                
    m_Grid.GetColumnWidth grData, Caption
    m_Searched = toSearch
  End If
  
  If Not m_bDescripVisible Then
    m_bDescripVisible = pHaveDescrip()
    If m_bDescripVisible Then
      SizeControls
    End If
  End If
  
  txDescrip.Text = ""
    
  GoTo ExitProc
ControlError:
  MngError Err, "Search", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
  
End Sub

Private Sub txSearch_Change()
  On Error GoTo ControlError
  
  tmSearch.Enabled = False
  
  If Timer - m_LastChange > 0.2 And Timer - m_LastChange < 0.3 Then
    tmSearch.Interval = 500
  ElseIf Timer - m_LastChange > 0.3 Then
    tmSearch.Interval = 1500
  End If
  
  GoTo ExitProc
ControlError:
  MngError Err, "txSearch_Change", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next

  m_LastChange = Timer
  
  tmSearch.Enabled = True

End Sub

Private Sub txSearch_KeyUp(KeyCode As Integer, Shift As Integer)
  On Error Resume Next
  If KeyCode = vbKeyDown Then
    grData.SetFocus
  End If
End Sub

Private Sub pProcessKeyFilter(ByRef KeyCode As Integer, _
                              ByRef Shift As Integer)
  Dim prhc_id As Long
  
  If Not m_bIsKeyFilterHelp Then Exit Sub
  
  prhc_id = pGetPrchIdFromKeyCode(KeyCode, Shift)
  
  If prhc_id Then
  
    If prhc_id <> m_last_prhc_id Then
  
      m_last_prhc_id = prhc_id
      
      KeyCode = 0
    
      ' Si es -1 es F1 y es para indicar que va sin filtro
      '
      If prhc_id = -1 Then prhc_id = 0
    
      m_bDontClickFilter = True
      ListSetListIndexForId cbKeyFilter, prhc_id
      
      m_Searched = vbNullString
      
      Search
    
    End If
    
  End If
  
End Sub

Private Function pGetPrchIdFromKeyCode(ByVal KeyCode As Integer, _
                                       ByVal Shift As Integer) As Long
  
  Dim i       As Integer
  Dim iShift  As Integer
  Dim prhc_id As Long
  Dim iKey    As Long
  Dim strKey  As String
  
  If KeyCode = vbKeyF1 Then
  
    prhc_id = -1
    
  Else
  
    For i = 1 To UBound(m_vKeyFilters)
      
      iShift = 0
      strKey = m_vKeyFilters(i).Key
      
      If InStr(1, LCase$(m_vKeyFilters(i).Key), "{shift}") Then
        iShift = vbKeyShift
        strKey = Replace(strKey, "{shift}", vbNullString)
      End If
      If InStr(1, LCase$(m_vKeyFilters(i).Key), "{ctrl}") Then
        iShift = iShift + vbKeyControl
        strKey = Replace(strKey, "{ctrl}", vbNullString)
      End If
      If InStr(1, LCase$(m_vKeyFilters(i).Key), "{ctl}") Then
        iShift = iShift + vbKeyControl
        strKey = Replace(strKey, "{ctl}", vbNullString)
      End If
      If InStr(1, LCase$(m_vKeyFilters(i).Key), "{control}") Then
        iShift = iShift + vbKeyControl
        strKey = Replace(strKey, "{control}", vbNullString)
      End If
      
      iKey = pGetKeyFromFilter(strKey)
      
      If iShift = Shift Then
      
        If KeyCode = iKey Then
        
          prhc_id = m_vKeyFilters(i).Id
          
          Exit For
        End If
      
      End If
    Next
  End If
  
  pGetPrchIdFromKeyCode = prhc_id
End Function

Private Function pGetKeyFromFilter(ByVal strKey As String) As Long
  Dim iKey As Long
  
  Select Case LCase$(strKey)
    Case "{f1}"
      iKey = vbKeyF1
    Case "{f2}"
      iKey = vbKeyF2
    Case "{f3}"
      iKey = vbKeyF3
    Case "{f4}"
      iKey = vbKeyF4
    Case "{f5}"
      iKey = vbKeyF5
    Case "{f6}"
      iKey = vbKeyF6
    Case "{f7}"
      iKey = vbKeyF7
    Case "{f8}"
      iKey = vbKeyF8
    Case "{f9}"
      iKey = vbKeyF9
    Case "{f10}"
      iKey = vbKeyF10
    Case "{f11}"
      iKey = vbKeyF11
    Case "{f12}"
      iKey = vbKeyF12
    Case "{a}"
      iKey = vbKeyA
    Case "{b}"
      iKey = vbKeyB
    Case "{c}"
      iKey = vbKeyC
    Case "{d}"
      iKey = vbKeyD
    Case "{e}"
      iKey = vbKeyE
    Case "{f}"
      iKey = vbKeyF
    Case "{g}"
      iKey = vbKeyG
    Case "{h}"
      iKey = vbKeyH
    Case "{i}"
      iKey = vbKeyI
    Case "{j}"
      iKey = vbKeyJ
    Case "{k}"
      iKey = vbKeyK
    Case "{l}"
      iKey = vbKeyL
    Case "{m}"
      iKey = vbKeyM
    Case "{n}"
      iKey = vbKeyN
    Case "{o}"
      iKey = vbKeyO
    Case "{p}"
      iKey = vbKeyP
    Case "{q}"
      iKey = vbKeyQ
    Case "{r}"
      iKey = vbKeyR
    Case "{s}"
      iKey = vbKeyS
    Case "{t}"
      iKey = vbKeyT
    Case "{u}"
      iKey = vbKeyU
    Case "{v}"
      iKey = vbKeyV
    Case "{w}"
      iKey = vbKeyW
    Case "{x}"
      iKey = vbKeyX
    Case "{y}"
      iKey = vbKeyY
    Case "{z}"
      iKey = vbKeyZ
    Case Else
      iKey = 0
  End Select
  
  pGetKeyFromFilter = iKey
  
End Function

Private Function pGetTextDescrip() As String
  If grData.SelectedItem Is Nothing Then Exit Function
  
  Dim i As Long
  For i = 1 To grData.ColumnHeaders.Count
    If grData.ColumnHeaders(i).Text = "_col_descrip_" Then
      pGetTextDescrip = grData.SelectedItem.SubItems(i - 1)
    End If
  Next
End Function

Private Sub pHideAuxCols()
  Dim i As Long
  
  For i = 1 To grData.ColumnHeaders.Count
    If grData.ColumnHeaders(i).Text = "_col_fore_color_" Then
      grData.ColumnHeaders(i).Width = 0
    End If
    If grData.ColumnHeaders(i).Text = "_col_back_color_" Then
      grData.ColumnHeaders(i).Width = 0
    End If
    If grData.ColumnHeaders(i).Text = "_col_descrip_" Then
      grData.ColumnHeaders(i).Width = 0
    End If
  Next
End Sub

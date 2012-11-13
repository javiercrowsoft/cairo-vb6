VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cABMGenericListDoc"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIABMGenericListDoc

'--------------------------------------------------------------------------------
' cABMGenericDoc
' 07-01-01

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cABMGenericListDoc"

Private Const C_offsetV         As Single = 20000
' estructuras
' variables privadas

Private C_offsetH         As Long '= 1350
Private C_offsetH2        As Long '= 3870

Private m_Client                As cIABMListDocClient
Private m_Properties            As cABMProperties
Private WithEvents m_FormListDoc       As cListDoc
Attribute m_FormListDoc.VB_VarHelpID = -1
Private WithEvents m_FormListParam     As cReportParam
Attribute m_FormListParam.VB_VarHelpID = -1

Private m_Tabs                  As cABMTabs

Private m_NextTop()               As Single
Private m_NextTopOp()             As Single
Private m_Left()                  As Single
Private m_LeftOp()                As Single

Private m_MngGrid              As cABMListView
Private m_bIsParam             As Boolean
Private m_ShowingForm          As Boolean

Private m_LastTop              As Integer
Private m_LastLeft             As Integer
Private m_LastLeftOp           As Integer
Private m_LastTopOp            As Integer
Private m_LabelLeft            As Integer

Private m_MaxHeightParam       As Long

' eventos
' propiedades publicas
' propiedades privadas
Private Property Get Frm() As Object
  If m_bIsParam Then
    Set Frm = m_FormListParam
  Else
    Set Frm = m_FormListDoc
  End If
End Property

Private Property Get MngGrid() As cABMListView
    If m_MngGrid Is Nothing Then Set m_MngGrid = New cABMListView
    Set MngGrid = m_MngGrid
End Property
' funciones publicas
Public Function Init(ByRef ListDoc As Object)
  On Error GoTo ControlError
  
  If TypeOf ListDoc Is cListDoc Then
    Set m_FormListDoc = ListDoc
    m_bIsParam = False
  Else
    Set m_FormListParam = ListDoc
    m_bIsParam = True
  End If
  
  m_Left(0) = Frm.LB(0).Left
  m_LeftOp(0) = Frm.OP(0).Left
  m_NextTop(0) = Frm.HL(0).Top
  m_NextTopOp(0) = Frm.OP(0).Top

  GoTo ExitProc
ControlError:
  MngError Err, "Init", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function
' funciones privadas

Private Property Let cIABMGenericListDoc_Left(ByVal rhs As Single)
    Frm.Left = rhs
End Property

Private Property Get cIABMGenericListDoc_Left() As Single
    cIABMGenericListDoc_Left = Frm.Left
End Property

' Implementacion de Interface
Private Property Get cIABMGenericListDoc_Properties() As CSInterfacesABM.cIABMProperties
    Set cIABMGenericListDoc_Properties = m_Properties
End Property

Private Function cIABMGenericListDoc_Refresh() As String
  pRefreshAux
  cIABMGenericListDoc_Refresh = m_Client.Refresh()
End Function

Private Sub cIABMGenericListDoc_RefreshControls()

End Sub

Private Function cIABMGenericListDoc_Show(Obj As CSInterfacesABM.cIABMListDocClient, ByRef ObjAbm As Object) As Boolean
    If Obj Is Nothing Then Exit Function
    
    Set m_Client = Obj
    
    Init ObjAbm
    
    If Frm.Name = "rptParams" Then
      
      C_offsetH = 2150
      C_offsetH2 = 5720
      
    End If
    
    If Not ShowForm() Then Exit Function
    
    Frm.lbTitle = m_Client.Title
    Frm.Caption = m_Client.Title
    
    If Frm.Visible Then
        Frm.ZOrder
    End If
    
    Set Frm.ClientProperties = m_Client.Properties
    
    cIABMGenericListDoc_Show = True
End Function

Private Property Get cIABMGenericListDoc_Tabs() As CSInterfacesABM.cIABMTabs
    If m_Tabs Is Nothing Then Set m_Tabs = New cABMTabs
    Set cIABMGenericListDoc_Tabs = m_Tabs
End Property

Private Function cIABMGenericListDoc_Terminate() As Boolean

End Function

Private Property Let cIABMGenericListDoc_Top(ByVal rhs As Single)
    Frm.Top = rhs
End Property

Private Property Get cIABMGenericListDoc_Top() As Single
    cIABMGenericListDoc_Top = Frm.Top
End Property

' Eventos de la interfaz
Private Sub m_FormListDoc_CBChange(ByVal Index As Integer)
    ChangeProperty cspList, Index, Frm.CB.Item(Index)
    ReLoadListAdHock
End Sub

Private Sub m_FormListDoc_CBhockChange(ByVal Index As Integer)
    ChangeProperty cspAdHock, Index, Frm.CBhock.Item(Index)
    ReLoadListAdHock
End Sub

Private Sub m_FormListDoc_cbTabClick(ByVal Index As Integer)
    TabClick Index
End Sub

Private Sub m_FormListDoc_CHKClick(ByVal Index As Integer)
    ChangeProperty cspCheck, Index, Frm.CHK.Item(Index)
    ReLoadListAdHock
End Sub

Private Sub m_FormListDoc_cmdDescartar()
  On Error GoTo ControlError
  UnloadControls
  m_Client.DiscardChanges
ControlError:
End Sub

Private Sub m_FormListDoc_cmdRefresh(ByRef Sqlstmt As String)
  On Error GoTo ControlError
  pRefreshAux
  Sqlstmt = m_Client.Refresh()
  Exit Sub
ControlError:
  MngError Err, "m_FormListDoc_cmdRefresh", C_Module, ""
End Sub

Private Sub m_FormListDoc_cmdSave()
    On Error GoTo ControlError
    If Not Validate() Then Exit Sub
    If Not m_Client.Save() Then Exit Sub
    m_FormListDoc_cmdDescartar
ControlError:
End Sub

Private Sub m_FormListDoc_GRClick(ByVal Index As Integer)
' Ya veremos que hacemos
End Sub

Private Sub m_FormListDoc_GRDblClick(ByVal Index As Integer)
' Ya veremos que hacemos
End Sub

Private Sub m_FormListDoc_HLChange(ByVal Index As Integer)
    ChangeProperty cspHelp, Index, Frm.HL.Item(Index)
    ReLoadListAdHock
End Sub

Private Sub m_FormListDoc_MKEChange(ByVal Index As Integer)
    ChangeProperty cspNumeric, Index, Frm.MKE.Item(Index)
    ReLoadListAdHock
End Sub

Private Sub m_FormListDoc_MEFEChange(ByVal Index As Integer)
    ChangeProperty cspDate, Index, Frm.MEFE.Item(Index)
    ReLoadListAdHock
End Sub

Private Sub m_FormListDoc_OPClick(ByVal Index As Integer)
    ChangeProperty cspOption, Index, Frm.OP.Item(Index)
    ReLoadListAdHock
End Sub

Private Sub m_FormListDoc_TXButtonClick(Index As Integer, Cancel As Boolean)
  pTXButtonClick Index, Cancel, m_FormListDoc
End Sub

Private Sub m_FormListDoc_TXChange(ByVal Index As Integer)
    ChangeProperty cspText, Index, Frm.TX.Item(Index)
    ReLoadListAdHock
End Sub
Private Sub m_FormListDoc_TXPasswordChange(ByVal Index As Integer)
    ChangeProperty cspPassword, Index, Frm.txPassword.Item(Index)
    ReLoadListAdHock
End Sub

' ReportParam
Private Sub m_FormListParam_CBChange(ByVal Index As Integer)
    ChangeProperty cspList, Index, Frm.CB.Item(Index)
    ReLoadListAdHock
End Sub

Private Sub m_FormListParam_CBhockChange(ByVal Index As Integer)
    ChangeProperty cspAdHock, Index, Frm.CBhock.Item(Index)
    ReLoadListAdHock
End Sub

Private Sub m_FormListParam_cbTabClick(ByVal Index As Integer)
    TabClick Index
End Sub

Private Sub m_FormListParam_CHKClick(ByVal Index As Integer)
    ChangeProperty cspCheck, Index, Frm.CHK.Item(Index)
    ReLoadListAdHock
End Sub

Private Sub m_FormListParam_cmdDescartar()
  On Error GoTo ControlError
  UnloadControls
  m_Client.DiscardChanges
ControlError:
End Sub

Private Sub m_FormListParam_cmdRefresh(ByRef Sqlstmt As String)
  On Error GoTo ControlError
  pRefreshAux
  Sqlstmt = m_Client.Refresh()
  Exit Sub
ControlError:
  MngError Err, "m_FormListParam_cmdRefresh", C_Module, ""
End Sub

Private Sub m_FormListParam_cmdSave()
    On Error GoTo ControlError
    If Not Validate() Then Exit Sub
    If Not m_Client.Save() Then Exit Sub
    m_FormListParam_cmdDescartar
ControlError:
End Sub

Private Sub m_FormListParam_HLChange(ByVal Index As Integer)
    ChangeProperty cspHelp, Index, Frm.HL.Item(Index)
    ReLoadListAdHock
End Sub

Private Sub m_FormListParam_MKEChange(ByVal Index As Integer)
    ChangeProperty cspNumeric, Index, Frm.MKE.Item(Index)
    ReLoadListAdHock
End Sub

Private Sub m_FormListParam_MEFEChange(ByVal Index As Integer)
    ChangeProperty cspDate, Index, Frm.MEFE.Item(Index)
    ReLoadListAdHock
End Sub

Private Sub m_FormListParam_OPClick(ByVal Index As Integer)
    ChangeProperty cspOption, Index, Frm.OP.Item(Index)
    ReLoadListAdHock
End Sub

Private Sub m_FormListParam_TXButtonClick(Index As Integer, Cancel As Boolean)
  pTXButtonClick Index, Cancel, m_FormListParam
End Sub

Private Sub m_FormListParam_TXChange(ByVal Index As Integer)
    ChangeProperty cspText, Index, Frm.TX.Item(Index)
    ReLoadListAdHock
End Sub
Private Sub m_FormListParam_TXPasswordChange(ByVal Index As Integer)
    ChangeProperty cspPassword, Index, Frm.txPassword.Item(Index)
    ReLoadListAdHock
End Sub


' funciones del objeto
Private Function ShowForm() As Boolean
    
    Dim oLock As cLockUpdateWindow
    Set oLock = New cLockUpdateWindow
    
    If Frm.Visible Then
      oLock.LockW Frm.hWnd
    End If
    
    Dim oProperty       As cABMProperty
    Dim iProperties    As cIABMProperties
    
    Set iProperties = m_Properties
    
    Dim iProperty  As cIABMProperty
    Dim Tabs        As Integer
    
    For Each iProperty In iProperties
        If iProperty.TabIndex > Tabs Then Tabs = iProperty.TabIndex
    Next
    
    ShowTabs Tabs
    
    m_ShowingForm = True
    m_MaxHeightParam = 0

    For Each oProperty In iProperties
        If Not oProperty.ControlLoaded Then
            If Not LoadControl(oProperty) Then Exit Function
            oProperty.ControlLoaded = True
        End If
        
        ShowValue oProperty
    Next
    
    Frm.MaxHeightParam = m_MaxHeightParam
    Frm.SetFocusFirstControl
    Frm.SetForAbm
    
    m_ShowingForm = False
    
    TabClick 0
    ShowForm = True
End Function
Private Function LoadControl(ByRef oProperty As cABMProperty) As Boolean
  Dim c As Control
  Dim f As Control
  
  Dim iProperty As cIABMProperty
  
  Dim iProperties    As cIABMProperties
  Dim oProp          As cABMProperty
  
  Set iProperty = oProperty
  
  Select Case iProperty.PropertyType
    Case csTypeABMProperty.cspAdHock
      Load Frm.CBhock.Item(Frm.CBhock.Count)
      oProperty.Index = Frm.CBhock.Count - 1
      Set c = Frm.CBhock.Item(Frm.CBhock.Count - 1)
    Case csTypeABMProperty.cspList
      Load Frm.CB.Item(Frm.CB.Count)
      oProperty.Index = Frm.CB.Count - 1
      Set c = Frm.CB.Item(Frm.CB.Count - 1)
    Case csTypeABMProperty.cspHelp
      Load Frm.HL.Item(Frm.HL.Count)
      oProperty.Index = Frm.HL.Count - 1
      Set c = Frm.HL.Item(Frm.HL.Count - 1)
      c.HelpType = Frm.HelpType
      c.Table = iProperty.Table
      c.ButtonStyle = cHelpButtonSingle
      
    Case csTypeABMProperty.cspNumeric
      Load Frm.MKE.Item(Frm.MKE.Count)
      oProperty.Index = Frm.MKE.Count - 1
      Set c = Frm.MKE.Item(Frm.MKE.Count - 1)
      c.csType = iProperty.SubType
      c.ButtonStyle = CSMaskEdit2.cButtonSingle
      If iProperty.SubType = 0 Then
        Err.Raise csErrorABMLoadControlSubTypeNotDefined, "CSABMInterface.LoadControl", "Error al cargar controles en ABM Generico. No se ha indicado un subnType para la propiedad numerica: " & iProperty.Name
      End If
    Case csTypeABMProperty.cspDate
      Load Frm.MEFE.Item(Frm.MEFE.Count)
      oProperty.Index = Frm.MEFE.Count - 1
      Set c = Frm.MEFE.Item(Frm.MEFE.Count - 1)
      c.csType = csMkDate
      c.ButtonStyle = CSMaskEdit2.cButtonSingle
    Case csTypeABMProperty.cspOption
      Set f = Frm.FR.Item(iProperty.OptionGroup)
      If Not f.Tag = "Loaded" Then
        f.Top = m_NextTop(iProperty.TabIndex)
        f.Left = m_Left(iProperty.TabIndex)
        f.Visible = True
        f.Tag = "Loaded"
      End If
      Load Frm.OP.Item(Frm.OP.Count)
      oProperty.Index = Frm.OP.Count - 1
      Set c = Frm.OP.Item(Frm.OP.Count - 1)
    Case csTypeABMProperty.cspText
      Load Frm.TX.Item(Frm.TX.Count)
      oProperty.Index = Frm.TX.Count - 1
      Frm.TX.Item(Frm.TX.Count - 1).MaxLength = iProperty.Size
      Set c = Frm.TX.Item(Frm.TX.Count - 1)
      c.ButtonStyle = IIf(iProperty.SubType = cspTextButton _
                       Or iProperty.SubType = cspTextButtonEx, _
                          cButtonSingle, cButtonNone)
    
    Case csTypeABMProperty.cspFile
      Load Frm.TX(Frm.TX.UBound + 1)
      oProperty.Index = Frm.TX.UBound
      Set c = Frm.TX(Frm.TX.UBound)
      c.MaxLength = iProperty.Size
      c.csType = CSMaskEdit2.csMkFile
      
    Case csTypeABMProperty.cspFolder
      Load Frm.TX(Frm.TX.UBound + 1)
      oProperty.Index = Frm.TX.UBound
      Set c = Frm.TX(Frm.TX.UBound)
      c.MaxLength = iProperty.Size
      c.csType = CSMaskEdit2.csMkFolder
    
    Case csTypeABMProperty.cspPassword
      Load Frm.txPassword.Item(Frm.txPassword.Count)
      oProperty.Index = Frm.txPassword.Count - 1
      Set c = Frm.txPassword.Item(Frm.txPassword.Count - 1)
    Case csTypeABMProperty.cspCheck
      Load Frm.CHK.Item(Frm.CHK.Count)
      oProperty.Index = Frm.CHK.Count - 1
      Set c = Frm.CHK.Item(Frm.CHK.Count - 1)
    Case csTypeABMProperty.cspGrid
      Load Frm.GR.Item(Frm.GR.Count)
      oProperty.Index = Frm.GR.Count - 1
      Set c = Frm.GR.Item(Frm.GR.Count - 1)
      Set MngGrid.Grid = c
      MngGrid.SetPropertys
  End Select
  
  Select Case iProperty.PropertyType
    Case csTypeABMProperty.cspDate
      c.Width = 1400
    Case csTypeABMProperty.cspTime
      c.Width = 1000
  End Select
  
  ' Aplico formateos personalizados
  If iProperty.Height > 0 Then
    c.Height = iProperty.Height
  End If
  
  If iProperty.Width > 0 Then
    c.Width = iProperty.Width
  End If
  
  ' Si se indica un top en funcion de una propiedad
  If iProperty.TopFromProperty <> "" Then
    Set iProperties = m_Properties
    Set oProp = iProperties(iProperty.TopFromProperty)
    iProperty.Top = oProp.Top
    
    ' Modificamos m_LastTop para poder indicar un top en funcion
    ' de una propiedad. Es decir combinar TopFromProperty y TopToPrevious
    m_LastTop = oProp.Top
  End If
  
  ' Si se indico un top en funcion del control anterior
  If iProperty.TopToPrevious <> 0 Then
  
    If iProperty.PropertyType = cspOption Then
      m_LastTop = m_LastTopOp
    End If
  
    ' Si se indica -1 significa el mismo top que el control anterior
    If iProperty.TopToPrevious = -1 Then
      iProperty.Top = m_LastTop
    Else
      iProperty.Top = m_LastTop + iProperty.TopToPrevious
    End If
  End If
  
  If iProperty.Top <> -1 Then
    c.Top = iProperty.Top
  End If
  
  ' Si se indica un left en funcion de una propiedad
  If iProperty.LeftFromProperty <> "" Then
    Set iProperties = m_Properties
    Set oProp = iProperties(iProperty.LeftFromProperty)
    iProperty.Left = oProp.Left
  
    
    ' Modificamos m_LastLeft para poder indicar un left en funcion
    ' de una propiedad. Es decir combinar LeftFromProperty y LeftToPrevious
    m_LastLeft = oProp.Left
    
    ' Si hay left personalizado, pero no se indico un left para el label
    ' le ponemos el default
    If iProperty.LeftLabel = 0 Then iProperty.LeftLabel = -C_offsetH
  End If
  
  ' Si se indico un left en funcion del control anterior
  If iProperty.LeftToPrevious <> 0 Then
    
    If iProperty.PropertyType = cspOption Then
      m_LastLeft = m_LastLeftOp
    End If
  
    ' Si se indica -1 significa el mismo left que el control anterior
    If iProperty.LeftToPrevious = -1 Then
      iProperty.Left = m_LastLeft
    Else
      iProperty.Left = m_LastLeft + iProperty.LeftToPrevious
    End If
  End If
  
  If iProperty.Left <> -1 Then
    ' Si hay left personalizado, pero no se indico un left para el label
    ' le ponemos el default
    If iProperty.LeftLabel = 0 Then iProperty.LeftLabel = -C_offsetH
  
    c.Left = iProperty.Left
  End If
  
  '
  ' Si el control va a quedar sobre la linea lo corro a la derecha y empiezo desde arriba otra vez
  '
  'If m_NextTop(IProperty.TabIndex) + 440 > Frm.Height Then
  If m_NextTop(iProperty.TabIndex) + 440 > C_offsetV Then
    SetNewTopAndLeft iProperty
  End If
  
  c.Visible = True
  c.Tag = iProperty.TabIndex
  c.Enabled = iProperty.Enabled
  
  pSetButton c
  
  If iProperty.PropertyType = cspOption Then
    Dim r As Integer
    Dim q As Integer
    If iProperty.OptionGroup - 1 > UBound(m_LeftOp) Then
      r = UBound(m_LeftOp)
      ReDim Preserve m_LeftOp(iProperty.OptionGroup)
      For q = r To UBound(m_LeftOp)
        m_LeftOp(q) = Frm.OP(0).Left
      Next
    End If
    If iProperty.OptionGroup - 1 > UBound(m_NextTopOp) Then
      r = UBound(m_NextTopOp)
      ReDim Preserve m_NextTopOp(iProperty.OptionGroup)
      For q = r To UBound(m_NextTopOp)
        m_NextTopOp(q) = Frm.OP(0).Top
      Next
    End If
    c.Left = m_LeftOp(iProperty.OptionGroup)
    c.Top = m_NextTopOp(iProperty.OptionGroup)
    c.Caption = iProperty.Name
    c.Width = 1500
    
    ' Agrando el Frame
    If c.Top > f.Height Then f.Height = c.Top + c.Height + 50
    
    If f.Height + f.Top > C_offsetV Then
      f.Top = m_NextTop(iProperty.TabIndex) - 100
      f.Left = m_Left(iProperty.TabIndex)
    End If
    m_NextTopOp(iProperty.OptionGroup) = m_NextTopOp(iProperty.OptionGroup) + 440
  Else
    Load Frm.LB(Frm.LB.Count)
    With Frm.LB(Frm.LB.Count - 1)
      .Caption = iProperty.Name
      .Left = m_Left(iProperty.TabIndex)
      .Visible = True
      .Tag = iProperty.TabIndex
      .ZOrder
      .BackStyle = 0
  
      ' Formateo especial para Grids
      If iProperty.PropertyType = cspGrid Then
        c.Left = m_Left(iProperty.TabIndex)
        c.Top = m_NextTop(iProperty.TabIndex) + 300
        .Top = m_NextTop(iProperty.TabIndex)
        .Width = c.Width
      
      Else
                                ' OptionGroup la uso para indicar un offset cuando la
                                ' oProperty no es de nType Option sirve para permitir un
                                ' posicionamiento mas fino de los controles. Solo se usa en
                                ' cuenta.
        .Top = m_NextTop(iProperty.TabIndex) + iProperty.OptionGroup
    
        c.Left = m_Left(iProperty.TabIndex) + C_offsetH
                                ' OptionGroup la uso para indicar un offset cuando la
                                ' oProperty no es de nType Option sirve para permitir un
                                ' posicionamiento mas fino de los controles. Solo se usa en
                                ' cuenta.
        c.Top = m_NextTop(iProperty.TabIndex) + iProperty.OptionGroup
      End If
    End With
  End If
  
  'Debug.Print m_Left(0)
  
  '
  ' Siempre incremento el NextTop general incluso si es una oProperty de nType option o Grid
  ' ya que por cada option que exista se agrega un renglo de 440 y eso es correcto. en el caso de las
  ' Grids no trabaja bien, pero como por ahora solo hay una Grid por tab, no trae ningun problema.
  '
  m_NextTop(iProperty.TabIndex) = m_NextTop(iProperty.TabIndex) + 440
  
  Dim TopParam As Long
  TopParam = m_NextTop(iProperty.TabIndex) - 140
  
  If m_MaxHeightParam < TopParam Then
    m_MaxHeightParam = TopParam
  End If
  
  LoadControl = True
End Function

Private Sub pSetButton(ByRef Control As Control)
  If TypeOf Control Is cMaskEdit Then
    If Control.csType <> csMkText And Control.csType <> csMkTime Then
      If Control.Enabled Then
        Control.ButtonStyle = cButtonSingle
      Else
        Control.ButtonStyle = cButtonNone
      End If
    End If
  End If
End Sub

Private Sub SetNewTopAndLeft(ByRef iProperty As cIABMProperty)
    m_NextTop(iProperty.TabIndex) = Frm.HL(0).Top
    m_Left(iProperty.TabIndex) = m_Left(iProperty.TabIndex) + C_offsetH2
    If m_Left(iProperty.TabIndex) + C_offsetH + Frm.HL(0).Width > Frm.Width Then
        If m_Left(iProperty.TabIndex) + C_offsetH + Frm.HL(0).Width + Frm.LB(0).Left / 2 > Screen.Width Then
            Err.Raise csErrorABMLoadControl, "CSABMInterface.LoadControl", "Error al cargar controles en ABM Generico. La cantidad de controles excede el tamaño maximo de la pantalla."
        End If
        Frm.Width = m_Left(iProperty.TabIndex) + C_offsetH + Frm.HL(0).Width + Frm.LB(0).Left
    End If
End Sub

Private Function ReLoadListAdHock() As Boolean
    Dim iProperty      As cIABMProperty
    Dim iProperties    As cIABMProperties
    
    Set iProperties = m_Properties
    
    For Each iProperty In iProperties
        If iProperty.PropertyType = cspAdHock Then
            If m_Client.ListAdHock(iProperty.List) Then ShowValue iProperty
        End If
    Next
    ReLoadListAdHock = True
End Function

Private Function ChangeProperty(ByVal nType As csTypeABMProperty, ByVal Index As Integer, ByRef c As Control) As Boolean
    Dim iProperty   As cIABMProperty
    Dim iProperty2  As cIABMProperty
    Dim oProperty   As cABMProperty
    Dim Found       As Boolean
    
    Static Refreshing As Boolean
    
    Dim iProperties    As cIABMProperties
    
    If Refreshing Or m_ShowingForm Then
        Refreshing = False
        ChangeProperty = True
        Exit Function
    End If
    
    Set iProperties = m_Properties
    
    For Each iProperty In iProperties
        
        Found = False
        
        ' Tratamiento especial para textos que
        ' tambien pueden ser carpetas o archivos
        If nType = cspText Then
          If iProperty.PropertyType = cspText Or iProperty.PropertyType = cspFile Or iProperty.PropertyType = cspFolder Then
            Found = True
          End If
        
        Else
          If iProperty.PropertyType = nType Then
            Found = True
          End If
        End If
        
        If Found Then
            Set oProperty = iProperty
            If oProperty.Index = Index Then
                
                Select Case nType
                    Case csTypeABMProperty.cspAdHock, csTypeABMProperty.cspList
                        iProperty.ListListIndex = c.ListIndex
                        iProperty.ListText = c.Text
                        If c.ListIndex >= 0 Then
                          iProperty.ListItemData = c.ItemData(c.ListIndex)
                        Else
                          iProperty.ListItemData = 0
                        End If
                    Case csTypeABMProperty.cspText, csTypeABMProperty.cspPassword, csTypeABMProperty.cspFile, csTypeABMProperty.cspFolder
                        iProperty.Value = c.Text
                    Case csTypeABMProperty.cspNumeric
                        iProperty.Value = c.csValue
                    Case csTypeABMProperty.cspDate
                        If c.csDateName <> "" Then
                          iProperty.Value = c.Text
                        Else
                          iProperty.Value = c.csValue
                        End If
                        iProperty.HelpValueProcess = c.csDateName
                    Case csTypeABMProperty.cspOption
                        
                        ' Aca hay que cambiar al resto de las Properties de este Group de
                        ' option buttons
                        For Each iProperty2 In iProperties
                            If Not iProperty2 Is iProperty Then
                                If iProperty2.PropertyType = cspOption And iProperty2.OptionGroup = iProperty.OptionGroup Then
                                    iProperty2.Value = 0
                                End If
                            End If
                        Next
                        
                        iProperty.Value = c.Value
                    Case csTypeABMProperty.cspHelp
                        c.Validate
                        iProperty.Value = c.ValueUser
                        iProperty.HelpId = Val(c.Id)
                        iProperty.HelpValueProcess = c.Id
                    Case csTypeABMProperty.cspCheck
                        iProperty.Value = c.Value
                End Select
                    
                m_Client.PropertyChange iProperty.Key
                c.Enabled = iProperty.Enabled
                
                Exit For
            End If
        End If
    Next
    
    For Each iProperty In iProperties
        If oProperty Is iProperty Then
            Refreshing = True
            ShowValue iProperty
        End If
    Next
    
    Refreshing = False
    ChangeProperty = True
End Function

Public Function ShowValue(ByRef oProperty As cABMProperty) As Boolean
    Dim iProperty      As cIABMProperty
    Dim Item            As cIABMListItem
    
    Set iProperty = oProperty
    
    Select Case iProperty.PropertyType
        Case csTypeABMProperty.cspAdHock
            Frm.CBhock.Item(oProperty.Index).Clear
            For Each Item In iProperty.List
                With Frm.CBhock.Item(oProperty.Index)
                    .AddItem Item.Value
                End With
                ListSetListIndexForId Frm.CBhock.Item(oProperty.Index), Item.Id
            Next
            Frm.CBhock.Item(oProperty.Index).ListIndex = iProperty.Value
            Frm.CBhock.Item(oProperty.Index).Enabled = iProperty.Enabled
        Case csTypeABMProperty.cspList
            Frm.CB.Item(oProperty.Index).Clear
            For Each Item In iProperty.List
                With Frm.CB.Item(oProperty.Index)
                    .AddItem Item.Value
                    .ItemData(.NewIndex) = Item.Id
                End With
            Next
            Select Case iProperty.ListWhoSetItem
              Case csListWhoSetItem.csListItemData
                ListSetListIndexForId Frm.CB(oProperty.Index), iProperty.ListItemData
              Case csListWhoSetItem.csListListIndex
                ListSetListIndex Frm.CB(oProperty.Index), iProperty.ListListIndex
              Case csListWhoSetItem.csListText
                ListSetListIndexForText Frm.CB(oProperty.Index), iProperty.ListText
            End Select

            If Frm.CB.Item(oProperty.Index).ListIndex = -1 _
               And Frm.CB.Item(oProperty.Index).ListCount > 0 Then
              Frm.CB.Item(oProperty.Index).ListIndex = 0
            End If
            Frm.CB.Item(oProperty.Index).Enabled = iProperty.Enabled
        Case csTypeABMProperty.cspHelp
            With Frm.HL.Item(oProperty.Index)
              .ValueHelp = IIf(iProperty.HelpValueProcess <> "", _
                               iProperty.HelpValueProcess, _
                               iProperty.HelpId)
              .ValueUser = iProperty.Value
              .ValueProcess = iProperty.HelpValueProcess
              .ColumnValueProcess = iProperty.HelpFieldValueProcess
              .Filter = iProperty.HelpFilter
              .Enabled = iProperty.Enabled
            End With
        Case csTypeABMProperty.cspNumeric
            With Frm.MKE.Item(oProperty.Index)
              .csValue = iProperty.Value
              .Enabled = iProperty.Enabled
            End With
        Case csTypeABMProperty.cspDate
            With Frm.MEFE.Item(oProperty.Index)
              .csValue = iProperty.Value
              .Enabled = iProperty.Enabled
            End With
        Case csTypeABMProperty.cspOption
            With Frm.OP.Item(oProperty.Index)
              .Value = iProperty.Value
              .Enabled = iProperty.Enabled
            End With
        Case csTypeABMProperty.cspText, _
             csTypeABMProperty.cspFile, _
             csTypeABMProperty.cspFolder
            With Frm.TX.Item(oProperty.Index)
              .Text = iProperty.Value
              .Enabled = iProperty.Enabled
              .BackColor = IIf(iProperty.Enabled, vbWindowBackground, Frm.BackColor)
            End With
        Case csTypeABMProperty.cspPassword
            With Frm.txPassword.Item(oProperty.Index)
              .Text = iProperty.Value
              .Enabled = iProperty.Enabled
            End With
        Case csTypeABMProperty.cspCheck
            With Frm.CHK.Item(oProperty.Index)
              .Value = IIf(Val(iProperty.Value) <> 0, vbChecked, vbUnchecked)
              .Enabled = iProperty.Enabled
            End With
        Case csTypeABMProperty.cspGrid
            If Not MngGrid.LoadFromRows(iProperty.Grid) Then Exit Function
    End Select

    ShowValue = True
End Function
Private Function Save() As Boolean
    On Error GoTo ControlError
    If Not Validate() Then Exit Function
    If Not m_Client.Save() Then Exit Function
    Save = True
    Exit Function
ControlError:
End Function

Private Function Validate() As Boolean
    Validate = m_Client.Validate()
End Function

Private Function TabClick(ByVal Index As Integer)
    Dim c As Control
    For Each c In Frm.Controls
      If Not TypeOf c Is Menu Then
        If Trim(c.Tag) <> "" Then
            c.Visible = Val(c.Tag) = Index
            If TypeOf c Is Label Then
              c.BackColor = vb3DHighlight
              c.ZOrder
            ElseIf TypeOf c Is CheckBox Then
              c.BackColor = vb3DHighlight
            End If
        End If
      End If
    Next
End Function

Private Sub ShowTabs(ByVal Tabs As Integer)
    Dim i       As Integer
    
    Dim Left    As Single
    Dim Top     As Single
    
    Left = 90
    Top = 640
    
    For i = 1 To Frm.cbTab.Count - 1
        Unload Frm.cbTab.Item(i)
    Next
    
    Dim iTabs   As cIABMTabs
    
    If Not m_Tabs Is Nothing Then
    
        Set iTabs = m_Tabs
    
        Tabs = IIf(iTabs.Count - 1 > Tabs, iTabs.Count - 1, Tabs)
    
    End If
    
    If Tabs = 0 Then Exit Sub

    For i = 0 To Tabs
        If i > 0 Then Load Frm.cbTab.Item(i)
        Frm.cbTab.Item(i).Caption = "Tab" & i
        Frm.cbTab.Item(i).TabStop = False
        Frm.cbTab.Item(i).Visible = True
        If Left + Frm.cbTab.Item(i).Width > Frm.Width Then
            Left = 100
            Top = Top + Frm.cbTab.Item(i).Height - 20
        End If
        Frm.cbTab.Item(i).Top = Top
        Frm.cbTab.Item(i).Left = Left
        Frm.cbTab.Item(i).ZOrder
        Frm.cbTab.Item(i).BackColorPressed = vb3DHighlight
        Left = Left + Frm.cbTab.Item(i).Width - 20
    Next
        
    Dim q As Integer
    
    Frm.HL(0).Top = Top + 500
    
    ReDim m_Left(Tabs)
    ReDim m_NextTop(Tabs)
    
    For q = 0 To UBound(m_NextTop)
        m_NextTop(q) = Frm.HL(0).Top
        m_Left(q) = Frm.LB(0).Left
    Next q
    
    If m_Tabs Is Nothing Then Exit Sub
    
    Dim iTab    As cIABMTabItem
    
    For Each iTab In iTabs
        Frm.cbTab.Item(iTab.Index).Caption = iTab.Name
    Next
    
    Frm.ShTab.ZOrder 1
End Sub

Private Sub UnloadControls()
    
    Dim oLock As cLockUpdateWindow
    Set oLock = New cLockUpdateWindow
    oLock.LockW Frm.hWnd
    
    Dim q As Integer
    
    For q = 0 To UBound(m_Left)
        m_Left(q) = Frm.LB.Item(0).Left
        m_NextTop(q) = Frm.HL.Item(0).Top
    Next q
    
    For q = 0 To UBound(m_LeftOp)
        m_LeftOp(q) = Frm.OP.Item(0).Left
        m_NextTopOp(q) = Frm.OP.Item(0).Top
    Next q
    
    On Error Resume Next
    Dim i As Integer
    
    For i = 1 To Frm.MKE.Count - 1
        Unload Frm.MKE.Item(i)
    Next
    
    For i = 1 To Frm.MEFE.Count - 1
        Unload Frm.MEFE.Item(i)
    Next
    
    For i = 1 To Frm.HL.Count - 1
        Unload Frm.HL.Item(i)
    Next
    
    For i = 1 To Frm.OP.Count - 1
        Unload Frm.OP.Item(i)
    Next
    
    For i = 1 To Frm.FR.Count - 1
        Unload Frm.FR.Item(i)
    Next
    
    For i = 1 To Frm.CHK.Count - 1
        Unload Frm.CHK.Item(i)
    Next
    
    For i = 1 To Frm.CB.Count - 1
        Unload Frm.CB.Item(i)
    Next
    
    For i = 1 To Frm.CBhock.Count - 1
        Unload Frm.CBhock.Item(i)
    Next
    
    For i = 1 To Frm.TX.Count - 1
        Unload Frm.TX.Item(i)
    Next
    
    For i = 1 To Frm.txPassword.Count - 1
        Unload Frm.txPassword.Item(i)
    Next

    For i = 1 To Frm.LB.Count - 1
        Unload Frm.LB.Item(i)
    Next

seguir:
    On Error GoTo 0
End Sub

Private Sub pRefreshAux()
  Dim Index       As Integer
  Dim oProperty   As cABMProperty
  Dim iProperties As cIABMProperties
  Dim i           As Integer
  
  Set iProperties = m_Properties
  
  For i = 1 To iProperties.Count
    
    Set oProperty = iProperties(i)
    Index = oProperty.Index
    
    Select Case iProperties(i).PropertyType
      Case csTypeABMProperty.cspAdHock
        ChangeProperty cspAdHock, Index, Frm.CBhock.Item(Index)
        
      Case csTypeABMProperty.cspCheck
        ChangeProperty cspCheck, Index, Frm.CHK.Item(Index)
        
      Case csTypeABMProperty.cspDate
        ChangeProperty cspDate, Index, Frm.MEFE.Item(Index)
        
      Case csTypeABMProperty.cspGrid
      
      Case csTypeABMProperty.cspHelp
        ChangeProperty cspHelp, Index, Frm.HL.Item(Index)
      
      Case csTypeABMProperty.cspList
        ChangeProperty cspList, Index, Frm.CB.Item(Index)
        
      Case csTypeABMProperty.cspNumeric
        ChangeProperty cspNumeric, Index, Frm.MKE.Item(Index)
        
      Case csTypeABMProperty.cspOption
        ChangeProperty cspOption, Index, Frm.OP.Item(Index)
        
      Case csTypeABMProperty.cspPassword
        ChangeProperty cspPassword, Index, Frm.txPassword.Item(Index)
        
      Case csTypeABMProperty.cspText
        ChangeProperty cspText, Index, Frm.TX.Item(Index)
        
    End Select
  Next
End Sub

Private Sub pTXButtonClick(Index As Integer, Cancel As Boolean, ByRef Frm As Object)
  Dim rtn As String
  With Frm.TX(Index)
    rtn = .Text
    If GetInputEx(rtn) Then
      .Text = rtn
    End If
  End With
End Sub

' construccion - destruccion
Private Sub Class_Initialize()
  
  C_offsetH = 1350
  C_offsetH2 = 3870
  
  Set m_Properties = New cABMProperties
  ReDim m_NextTop(0)
  ReDim m_NextTopOp(0)
  ReDim m_Left(0)
  ReDim m_LeftOp(0)
End Sub

Private Sub Class_Terminate()
  On Error Resume Next

  ReDim m_NextTop(0)
  ReDim m_NextTopOp(0)
  ReDim m_Left(0)
  ReDim m_LeftOp(0)
  Set m_Properties = Nothing
  Set m_Client = Nothing
  Set m_Tabs = Nothing
  Set m_MngGrid = Nothing
  Set m_FormListDoc = Nothing
  Set m_FormListDoc = Nothing
End Sub



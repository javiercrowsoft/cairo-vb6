VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cABMGenericoDoc"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIABMGenerico

'--------------------------------------------------------------------------------
' cABMGenericoDoc
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
Private Const C_offsetV         As Single = 540
Private Const C_offsetH         As Single = 1350
Private Const C_offsetH2        As Single = 3870
' estructuras
' variables privadas
Private m_Client                As cIABMClient
Private m_Propiedades           As cABMPropiedades
Private WithEvents m_Form       As cListDoc
Attribute m_Form.VB_VarHelpID = -1

Private m_Tabs                  As cABMTabs

Private m_NextTop()               As Single
Private m_NextTopOp()             As Single
Private m_Left()                  As Single
Private m_LeftOp()                As Single

Private m_MngGrilla            As cABMListView

Private m_ShowingForm          As Boolean

' eventos
' propiedades publicas
' propiedades privadas
Private Property Get Frm() As cListDoc
    If m_Form Is Nothing Then
        Set m_Form = New cListDoc
        Load m_Form
        m_Left(0) = m_Form.LB(0).Left
        m_LeftOp(0) = m_Form.OP(0).Left
        m_NextTop(0) = m_Form.HL(0).Top
        m_NextTopOp(0) = m_Form.OP(0).Top
    End If
    Set Frm = m_Form
End Property
Private Property Get MngGrilla() As cABMListView
    If m_MngGrilla Is Nothing Then Set m_MngGrilla = New cABMListView
    Set MngGrilla = m_MngGrilla
End Property
' funciones publicas
' funciones privadas

Private Property Let cIABMGenerico_Left(ByVal RHS As Single)
    Frm.Left = RHS
End Property

Private Property Get cIABMGenerico_Left() As Single
    cIABMGenerico_Left = Frm.Left
End Property

' Implementacion de Interface
Private Property Get cIABMGenerico_Propiedades() As CSInterfacesABM.cIABMPropiedades
    Set cIABMGenerico_Propiedades = m_Propiedades
End Property

Private Sub cIABMGenerico_RefreshControls()

End Sub

Private Function cIABMGenerico_Show(Obj As CSInterfacesABM.cIABMClient) As Boolean
    If Obj Is Nothing Then Exit Function
    
    Set m_Client = Obj
    
    If Not ShowForm() Then Exit Function
    
    Frm.lbTitulo = m_Client.Titulo
    Frm.Caption = m_Client.Titulo
    
    If Frm.Visible Then
        Frm.ZOrder
    Else
        Frm.Show 'vbModal
    End If
    
    cIABMGenerico_Show = True
End Function

Private Property Get cIABMGenerico_Tabs() As CSInterfacesABM.cIABMTabs
    If m_Tabs Is Nothing Then Set m_Tabs = New cABMTabs
    Set cIABMGenerico_Tabs = m_Tabs
End Property

Private Function cIABMGenerico_Terminar() As Boolean

End Function

Private Property Let cIABMGenerico_Top(ByVal RHS As Single)
    Frm.Top = RHS
End Property

Private Property Get cIABMGenerico_Top() As Single
    cIABMGenerico_Top = Frm.Top
End Property

' Eventos de la interfaz
Private Sub m_Form_CBChange(ByVal Index As Integer)
    CambiarPropiedad cspLista, Index, Frm.CB(Index)
    ReLoadListaAdHock
End Sub

Private Sub m_Form_CBhockChange(ByVal Index As Integer)
    CambiarPropiedad cspAdHock, Index, Frm.CBhock(Index)
    ReLoadListaAdHock
End Sub

Private Sub m_Form_cbTabClick(ByVal Index As Integer)
    TabClick Index
End Sub

Private Sub m_Form_CHKClick(ByVal Index As Integer)
    CambiarPropiedad cspCheck, Index, Frm.CHK(Index)
    ReLoadListaAdHock
End Sub

Private Sub m_Form_cmdCancelarClick()
    Cancelar
End Sub

Private Sub m_Form_cmdCerrarClick()
  Unload m_Form
End Sub

Private Sub m_Form_cmdGuardarClick()
    If Not Guardar Then Exit Sub
    Unload m_Form
End Sub

Private Sub m_Form_GRClick(ByVal Index As Integer)
' Ya veremos que hacemos
End Sub

Private Sub m_Form_GRDblClick(ByVal Index As Integer)
' Ya veremos que hacemos
End Sub

Private Sub m_Form_HLChange(ByVal Index As Integer)
    CambiarPropiedad cspHelp, Index, Frm.HL(Index)
    ReLoadListaAdHock
End Sub

Private Sub m_Form_MEChange(ByVal Index As Integer)
    CambiarPropiedad cspNumero, Index, Frm.ME(Index)
    ReLoadListaAdHock
End Sub

Private Sub m_Form_MEFEChange(ByVal Index As Integer)
    CambiarPropiedad cspFecha, Index, Frm.MEFE(Index)
    ReLoadListaAdHock
End Sub

Private Sub m_Form_OPClick(ByVal Index As Integer)
    CambiarPropiedad cspOpcion, Index, Frm.OP(Index)
    ReLoadListaAdHock
End Sub

Private Sub m_Form_TXChange(ByVal Index As Integer)
    CambiarPropiedad cspTexto, Index, Frm.TX(Index)
    ReLoadListaAdHock
End Sub
Private Sub m_Form_TXClaveChange(ByVal Index As Integer)
    CambiarPropiedad cspClave, Index, Frm.TXClave(Index)
    ReLoadListaAdHock
End Sub

' funciones del objeto
Private Function ShowForm() As Boolean
    Dim propiedad       As cABMPropiedad
    Dim IPropiedades    As cIABMPropiedades
    
    Set IPropiedades = m_Propiedades
    
    Dim IPropiedad  As cIABMPropiedad
    Dim Tabs        As Integer
    
    For Each IPropiedad In IPropiedades
        If IPropiedad.TabIndex > Tabs Then Tabs = IPropiedad.TabIndex
    Next
    
    ShowTabs Tabs
    
    m_ShowingForm = True
    
    For Each propiedad In IPropiedades
        If Not propiedad.ControlCargado Then
            If Not CargarControl(propiedad) Then Exit Function
            propiedad.ControlCargado = True
        End If
        
        ShowValor propiedad
    Next
    
    Frm.SetFocusFirstControl
    
    m_ShowingForm = False
    
    Frm.cmdGuardar.TabIndex = Frm.Controls.Count
    Frm.cmdCancelar.TabIndex = Frm.Controls.Count
    Frm.cmdCerrar.TabIndex = Frm.Controls.Count
    
    TabClick 0
    ShowForm = True
End Function
Private Function CargarControl(ByRef propiedad As cABMPropiedad) As Boolean
    Dim c As Control
    Dim f As Control
    Dim IPropiedad As cIABMPropiedad
    
    Set IPropiedad = propiedad
    
    Select Case IPropiedad.Tipo
        Case csTipoABMPropiedad.cspAdHock
            Load Frm.CBhock(Frm.CBhock.Count)
            propiedad.Indice = Frm.CBhock.Count - 1
            Set c = Frm.CBhock(Frm.CBhock.Count - 1)
        Case csTipoABMPropiedad.cspLista
            Load Frm.CB(Frm.CB.Count)
            propiedad.Indice = Frm.CB.Count - 1
            Set c = Frm.CB(Frm.CB.Count - 1)
        Case csTipoABMPropiedad.cspHelp
            Load Frm.HL(Frm.HL.Count)
            propiedad.Indice = Frm.HL.Count - 1
            Frm.HL(Frm.HL.Count - 1).Tabla = IPropiedad.Tabla
            Set c = Frm.HL(Frm.HL.Count - 1)
        Case csTipoABMPropiedad.cspNumero
            Load Frm.ME(Frm.ME.Count)
            propiedad.Indice = Frm.ME.Count - 1
            Set c = Frm.ME(Frm.ME.Count - 1)
            Frm.ME(Frm.ME.Count - 1).csType = IPropiedad.SubTipo
            If IPropiedad.SubTipo = 0 Then
              Err.Raise csErrorABMCargarControlSubTypoNotDefined, "CSABMInterface.CargarControl", "Error al cargar controles en ABM generico. No se ha indicado un subtipo para la propiedad numerica: " & IPropiedad.Nombre
            End If
        Case csTipoABMPropiedad.cspFecha
            Load Frm.MEFE(Frm.MEFE.Count)
            propiedad.Indice = Frm.MEFE.Count - 1
            Set c = Frm.MEFE(Frm.MEFE.Count - 1)
            Frm.MEFE(Frm.MEFE.Count - 1).csType = csMkFecha
        Case csTipoABMPropiedad.cspOpcion
            Set f = Frm.FR(IPropiedad.OpcionGrupo)
            If Not f.Tag = "CARGADO" Then
                f.Top = m_NextTop(IPropiedad.TabIndex)
                f.Left = m_Left(IPropiedad.TabIndex)
                f.Visible = True
                f.Tag = "CARGADO"
            End If
            Load Frm.OP(Frm.OP.Count)
            propiedad.Indice = Frm.OP.Count - 1
            Set c = Frm.OP(Frm.OP.Count - 1)
        Case csTipoABMPropiedad.cspTexto
            Load Frm.TX(Frm.TX.Count)
            propiedad.Indice = Frm.TX.Count - 1
            Set c = Frm.TX(Frm.TX.Count - 1)
        Case csTipoABMPropiedad.cspClave
            Load Frm.TXClave(Frm.TXClave.Count)
            propiedad.Indice = Frm.TXClave.Count - 1
            Set c = Frm.TXClave(Frm.TXClave.Count - 1)
        Case csTipoABMPropiedad.cspCheck
            Load Frm.CHK(Frm.CHK.Count)
            propiedad.Indice = Frm.CHK.Count - 1
            Set c = Frm.CHK(Frm.CHK.Count - 1)
        Case csTipoABMPropiedad.cspGrilla
            Load Frm.GR(Frm.GR.Count)
            propiedad.Indice = Frm.GR.Count - 1
            Set c = Frm.GR(Frm.GR.Count - 1)
            Set MngGrilla.Grilla = c
            MngGrilla.SetPropertys
    End Select
    
    '
    ' Si el control va a quedar sobre la linea lo corro a la derecha y empiezo desde arriba otra vez
    '
    If m_NextTop(IPropiedad.TabIndex) + 440 > Frm.Line1.Y1 Then
        SetNewTopAndLeft IPropiedad
    End If
    
    c.Visible = True
    c.Tag = IPropiedad.TabIndex
    c.Enabled = IPropiedad.Enabled
    
    If IPropiedad.Tipo = cspOpcion Then
        Dim r As Integer
        Dim q As Integer
        If IPropiedad.OpcionGrupo - 1 > UBound(m_LeftOp) Then
            r = UBound(m_LeftOp)
            ReDim Preserve m_LeftOp(IPropiedad.OpcionGrupo)
            For q = r To UBound(m_LeftOp)
                m_LeftOp(q) = Frm.OP(0).Left
            Next
        End If
        If IPropiedad.OpcionGrupo - 1 > UBound(m_NextTopOp) Then
            r = UBound(m_NextTopOp)
            ReDim Preserve m_NextTopOp(IPropiedad.OpcionGrupo)
            For q = r To UBound(m_NextTopOp)
                m_NextTopOp(q) = Frm.OP(0).Top
            Next
        End If
        c.Left = m_LeftOp(IPropiedad.OpcionGrupo)
        c.Top = m_NextTopOp(IPropiedad.OpcionGrupo)
        c.Caption = IPropiedad.Nombre
        c.Width = 1500
        
        ' Agrando el Frame
        If c.Top > f.Height Then f.Height = c.Top + c.Height + 50
        
        If f.Height + f.Top > Frm.Line1.Y1 Then
            'SetNewTopAndLeft IPropiedad
            f.Top = m_NextTop(IPropiedad.TabIndex) - 100
            f.Left = m_Left(IPropiedad.TabIndex)
        End If
        m_NextTopOp(IPropiedad.OpcionGrupo) = m_NextTopOp(IPropiedad.OpcionGrupo) + 440
    Else
        Load Frm.LB(Frm.LB.Count)
        Frm.LB(Frm.LB.Count - 1).Caption = IPropiedad.Nombre
        Frm.LB(Frm.LB.Count - 1).Left = m_Left(IPropiedad.TabIndex)
        Frm.LB(Frm.LB.Count - 1).Visible = True
        Frm.LB(Frm.LB.Count - 1).Tag = IPropiedad.TabIndex
        Frm.LB(Frm.LB.Count - 1).ZOrder
    
        ' Formateo especial para grillas
        If IPropiedad.Tipo = cspGrilla Then
            c.Left = m_Left(IPropiedad.TabIndex)
            c.Top = m_NextTop(IPropiedad.TabIndex) + 300
            Frm.LB(Frm.LB.Count - 1).Top = m_NextTop(IPropiedad.TabIndex)
            Frm.LB(Frm.LB.Count - 1).Width = c.Width
        
        Else
                                                            ' OpcionGrupo la uso para indicar un offset cuando la
                                                            ' propiedad no es de tipo opcion sirve para permitir un
                                                            ' posicionamiento mas fino de los controles. Solo se usa en
                                                            ' cuenta.
            Frm.LB(Frm.LB.Count - 1).Top = m_NextTop(IPropiedad.TabIndex) + IPropiedad.OpcionGrupo
    
            c.Left = m_Left(IPropiedad.TabIndex) + C_offsetH
                                                            ' OpcionGrupo la uso para indicar un offset cuando la
                                                            ' propiedad no es de tipo opcion sirve para permitir un
                                                            ' posicionamiento mas fino de los controles. Solo se usa en
                                                            ' cuenta.
            c.Top = m_NextTop(IPropiedad.TabIndex) + IPropiedad.OpcionGrupo
        End If
    End If
    
    '
    ' Siempre incremento el NextTop general incluso si es una propiedad de tipo option o grilla
    ' ya que por cada option que exista se agrega un renglo de 440 y eso es correcto. en el caso de las
    ' grillas no trabaja bien, pero como por ahora solo hay una grilla por tab, no trae ningun problema.
    '
    m_NextTop(IPropiedad.TabIndex) = m_NextTop(IPropiedad.TabIndex) + 440
    
    CargarControl = True
End Function

Private Sub SetNewTopAndLeft(ByRef IPropiedad As cIABMPropiedad)
    m_NextTop(IPropiedad.TabIndex) = Frm.HL(0).Top
    m_Left(IPropiedad.TabIndex) = m_Left(IPropiedad.TabIndex) + C_offsetH2
    If m_Left(IPropiedad.TabIndex) + C_offsetH + Frm.HL(0).Width > Frm.ScaleWidth Then
        If m_Left(IPropiedad.TabIndex) + C_offsetH + Frm.HL(0).Width + Frm.LB(0).Left / 2 > Screen.Width Then
            Err.Raise csErrorABMCargarControl, "CSABMInterface.CargarControl", "Error al cargar controles en ABM generico. La cantidad de controles excede el tamaño maximo de la pantalla."
        End If
        'Frm.Width = Frm.Width + m_Left(IPropiedad.TabIndex) + C_offsetH + Frm.HL(0).Width + Frm.LB(0).Left / 2
        Frm.Width = m_Left(IPropiedad.TabIndex) + C_offsetH + Frm.HL(0).Width + Frm.LB(0).Left
    End If
End Sub

Private Function ReLoadListaAdHock() As Boolean
    Dim IPropiedad  As cIABMPropiedad
    Dim IPropiedades    As cIABMPropiedades
    
    Set IPropiedades = m_Propiedades
    
    For Each IPropiedad In IPropiedades
        If IPropiedad.Tipo = cspAdHock Then
            If m_Client.ListaAdHock(IPropiedad.lista) Then ShowValor IPropiedad
        End If
    Next
    ReLoadListaAdHock = True
End Function
Private Function CambiarPropiedad(ByVal Tipo As csTipoABMPropiedad, ByVal Indice As Integer, ByRef c As Control) As Boolean
    Dim IPropiedad  As cIABMPropiedad
    Dim IPropiedad2  As cIABMPropiedad
    Dim propiedad   As cABMPropiedad
    
    Static Refrescando As Boolean
    
    Dim IPropiedades    As cIABMPropiedades
    
    If Refrescando Or m_ShowingForm Then
        Refrescando = False
        CambiarPropiedad = True
        Exit Function
    End If
    
    Set IPropiedades = m_Propiedades
    
    For Each IPropiedad In IPropiedades
        If IPropiedad.Tipo = Tipo Then
            Set propiedad = IPropiedad
            If propiedad.Indice = Indice Then
                
                Select Case Tipo
                    Case csTipoABMPropiedad.cspAdHock, csTipoABMPropiedad.cspLista
                        IPropiedad.Valor = c.ListIndex
                    Case csTipoABMPropiedad.cspTexto, csTipoABMPropiedad.cspClave
                        IPropiedad.Valor = c.Text
                    Case csTipoABMPropiedad.cspNumero
                        IPropiedad.Valor = c.csValue
                    Case csTipoABMPropiedad.cspFecha
                        IPropiedad.Valor = c.csValue
                    Case csTipoABMPropiedad.cspOpcion
                        
                        ' Aca hay que cambiar al resto de las propiedades de este grupo de
                        ' option buttons
                        For Each IPropiedad2 In IPropiedades
                            If Not IPropiedad2 Is IPropiedad Then
                                If IPropiedad2.Tipo = cspOpcion And IPropiedad2.OpcionGrupo = IPropiedad.OpcionGrupo Then
                                    IPropiedad2.Valor = 0
                                End If
                            End If
                        Next
                        
                        IPropiedad.Valor = c.Value
                    Case csTipoABMPropiedad.cspHelp
                        IPropiedad.Valor = c.ValorUsuario
                        IPropiedad.HelpId = Val(c.Id)
                    Case csTipoABMPropiedad.cspCheck
                        IPropiedad.Valor = c.Value
                End Select
                    
                m_Client.PropertyChange IPropiedad.Clave
                c.Enabled = IPropiedad.Enabled
                
                Exit For
            End If
        End If
    Next
    
    For Each IPropiedad In IPropiedades
        If Not propiedad Is IPropiedad Then
            Refrescando = True
            ShowValor IPropiedad
        End If
    Next
    
    Refrescando = False
    CambiarPropiedad = True
End Function

Private Function ShowValor(ByRef propiedad As cABMPropiedad) As Boolean
    Dim IPropiedad      As cIABMPropiedad
    Dim item            As cIABMListaItem
    
    Set IPropiedad = propiedad
    
    Select Case IPropiedad.Tipo
        Case csTipoABMPropiedad.cspAdHock
            Frm.CBhock(propiedad.Indice).Clear
            For Each item In IPropiedad.lista
                With Frm.CBhock(propiedad.Indice)
                    .AddItem item.Valor
                End With
                ListaSetListIndexForId_ Frm.CBhock(propiedad.Indice), item.Id
            Next
            Frm.CBhock(propiedad.Indice).ListIndex = IPropiedad.Valor
            Frm.CBhock(propiedad.Indice).Enabled = IPropiedad.Enabled
        Case csTipoABMPropiedad.cspLista
            Frm.CB(propiedad.Indice).Clear
            For Each item In IPropiedad.lista
                With Frm.CB(propiedad.Indice)
                    .AddItem item.Valor
                    .ItemData(.NewIndex) = item.Id
                End With
            Next
            ListaSetListIndexForId_ Frm.CB(propiedad.Indice), IPropiedad.Valor
            If Frm.CB(propiedad.Indice).ListIndex = -1 And Frm.CB(propiedad.Indice).ListCount > 0 Then Frm.CB(propiedad.Indice).ListIndex = 0
            Frm.CB(propiedad.Indice).Enabled = IPropiedad.Enabled
        Case csTipoABMPropiedad.cspHelp
            Frm.HL(propiedad.Indice).Id = IPropiedad.HelpId
            Frm.HL(propiedad.Indice).ValorUsuario = IPropiedad.Valor
            Frm.HL(propiedad.Indice).ValorProceso = IPropiedad.HelpValorProceso
            Frm.HL(propiedad.Indice).ColumnaValorProceso = IPropiedad.HelpCampoValorProceso
            Frm.HL(propiedad.Indice).Filtro = IPropiedad.HelpFiltro
            Frm.HL(propiedad.Indice).Enabled = IPropiedad.Enabled
        Case csTipoABMPropiedad.cspNumero
            Frm.ME(propiedad.Indice).csValue = IPropiedad.Valor
            Frm.ME(propiedad.Indice).Enabled = IPropiedad.Enabled
        Case csTipoABMPropiedad.cspFecha
            Frm.MEFE(propiedad.Indice).csValue = IPropiedad.Valor
            Frm.MEFE(propiedad.Indice).Enabled = IPropiedad.Enabled
        Case csTipoABMPropiedad.cspOpcion
            Frm.OP(propiedad.Indice) = IPropiedad.Valor
            Frm.OP(propiedad.Indice).Enabled = IPropiedad.Enabled
        Case csTipoABMPropiedad.cspTexto
            Frm.TX(propiedad.Indice).Text = IPropiedad.Valor
            Frm.TX(propiedad.Indice).Enabled = IPropiedad.Enabled
            Frm.TX(propiedad.Indice).BackColor = IIf(IPropiedad.Enabled, vbWindowBackground, Frm.BackColor)
        Case csTipoABMPropiedad.cspClave
            Frm.TXClave(propiedad.Indice).Text = IPropiedad.Valor
            Frm.TXClave(propiedad.Indice).Enabled = IPropiedad.Enabled
        Case csTipoABMPropiedad.cspCheck
            Frm.CHK(propiedad.Indice).Value = IIf(Val(IPropiedad.Valor) <> 0, vbChecked, vbUnchecked)
            Frm.CHK(propiedad.Indice).Enabled = IPropiedad.Enabled
        Case csTipoABMPropiedad.cspGrilla
            If Not MngGrilla.LoadFromFilas(IPropiedad.Grilla) Then Exit Function
    End Select

    ShowValor = True
End Function
Private Function Guardar() As Boolean
    On Error GoTo ControlError
    If Not Validar() Then Exit Function
    If Not m_Client.Save() Then Exit Function
    Guardar = True
    Exit Function
ControlError:
End Function

Private Function Validar() As Boolean
    Validar = m_Client.Validate()
End Function

Private Function TabClick(ByVal Index As Integer)
    Dim c As Control
    For Each c In Frm.Controls
        If Trim(c.Tag) <> "" Then
            c.Visible = Val(c.Tag) = Index
            If TypeOf c Is Label Then
              c.BackColor = vb3DHighlight
              c.ZOrder
            ElseIf TypeOf c Is CheckBox Then
              c.BackColor = vb3DHighlight
            End If
        End If
    Next
    
    'Frm.ShTab.Visible = Frm.cbTab.Count > 1
 End Function

Private Sub ShowTabs(ByVal Tabs As Integer)
    Dim i       As Integer
    
    Dim Left    As Single
    Dim Top     As Single
    
    Left = 90
    Top = 640
    
    For i = 1 To Frm.cbTab.Count - 1
        Unload Frm.cbTab(i)
    Next
    
    Dim ITabs   As cIABMTabs
    
    If Not m_Tabs Is Nothing Then
    
        Set ITabs = m_Tabs
    
        Tabs = IIf(ITabs.Count - 1 > Tabs, ITabs.Count - 1, Tabs)
    
    End If
    
    If Tabs = 0 Then Exit Sub

    For i = 0 To Tabs
        If i > 0 Then Load Frm.cbTab(i)
        Frm.cbTab(i).Caption = "Tab" & i
        Frm.cbTab(i).TabStop = False
        Frm.cbTab(i).Visible = True
        If Left + Frm.cbTab(i).Width > Frm.Width Then
            Left = 100
            Top = Top + Frm.cbTab(i).Height - 20
        End If
        Frm.cbTab(i).Top = Top
        Frm.cbTab(i).Left = Left
        Frm.cbTab(i).ZOrder
        Frm.cbTab(i).BackColorPressed = vb3DHighlight
        Left = Left + Frm.cbTab(i).Width - 20
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
    
    Dim ITab    As cIABMTabItem
    
    For Each ITab In ITabs
        Frm.cbTab(ITab.Index).Caption = ITab.Nombre
    Next
    
    Frm.ShTab.ZOrder 1
End Sub

' construccion - destruccion
Private Sub Class_Initialize()
    Set m_Propiedades = New cABMPropiedades
    ReDim m_NextTop(0)
    ReDim m_NextTopOp(0)
    ReDim m_Left(0)
    ReDim m_LeftOp(0)
End Sub

Private Sub Class_Terminate()
    ReDim m_NextTop(0)
    ReDim m_NextTopOp(0)
    ReDim m_Left(0)
    ReDim m_LeftOp(0)
    Set m_Propiedades = Nothing
    Set m_Client = Nothing
    Set m_Tabs = Nothing
    Set m_MngGrilla = Nothing
End Sub



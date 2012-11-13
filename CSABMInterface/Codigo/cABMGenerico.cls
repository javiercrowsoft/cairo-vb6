VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cABMGeneric"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIABMGeneric

'--------------------------------------------------------------------------------
' cABMGeneric
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
Private Const C_Module = "cABMGeneric"

Private Const C_offsetV         As Single = 540
Private Const C_offsetV1        As Single = 280
Private Const C_offsetV3        As Single = 225
Private Const C_offsetH         As Single = 1190
Private Const C_offsetH2        As Single = 3780
Private Const C_offsetH3        As Single = 1300
Private Const C_offsetH4        As Single = 1000

Private Const c_LineHeight      As Integer = 440
Private Const c_LineLight       As Integer = 155

Private Const csDocumento = 4001

Private Const K_W_CANCEL = -10

Private Const c_RPT_KEY = "RPT-CONFIG"
Private Const c_RPT_PathReportes = "RPT_PATH_REPORTES"
Private Const c_RPT_CommandTimeOut = "RPT_COMMAND_TIMEOUT"
Private Const c_RPT_ConnectionTimeOut = "RPT_CONNECTION_TIMEOUT"

Private m_vEnabledState() As Boolean

Private m_bInProcess As Boolean

' Permite que los controles esten visibles en diferentes tabs
'
Public Enum csETabIndexType
  csETabIdxT_All = -1000     ' Se puede inhibir usando m_tabHideCtrlsInAllTab
  csETabIdxT_All2 = -1001    ' no se puede inhibir
End Enum

Private Enum csEGridSelectChangeType
  csEGridSelectionChange = 1
  csEGridColChange
  csEGridRowChange
End Enum

' estructuras
' variables privadas
Private m_Client                As cIABMClient
Private m_Properties            As cABMProperties

Private m_PopMenuClient         As String

'/////////////////////////////////////////////////
' Objetos de Interfaz
'

' Menu popup para el boton doc_aux de documentos
'
Private WithEvents m_Menu           As cPopupMenu
Attribute m_Menu.VB_VarHelpID = -1

' ABM de maestros y formularios de configuracion
'
Private WithEvents m_FormABM    As fABM
Attribute m_FormABM.VB_VarHelpID = -1

' ABM de documentos
'
Private WithEvents m_FormDoc    As fABMDoc
Attribute m_FormDoc.VB_VarHelpID = -1

' Asistentes
'
Private WithEvents m_FormWizard As fWizard
Attribute m_FormWizard.VB_VarHelpID = -1

' Tabs
'
Private m_Tabs                  As cABMTabs
Private m_currtab               As Long
Private m_currInnerTab          As Long

' Posicion de los controles
'
Private m_NextTop()           As Single
Private m_NextTopOp()         As Single
Private m_Left()              As Single
Private m_LeftOp()            As Single
Private m_LastTop             As Single
Private m_LastLeft            As Single
Private m_LastLeftOp          As Single
Private m_LastTopOp           As Single
Private m_LabelLeft           As Single

' Manejador para la grilla avanzada
'
Private m_MngGrid              As cABMCSGrid

' Tamaño minimos de la ventana
'
Private m_MinHeight            As Single
Private m_MinWidth             As Single

' Contiene el ancho de los textbox
'
Private m_TextOrigWidth        As Single

' Flag para evitar un refresh recursivo
'
Private m_ShowingForm          As Boolean

' Indica si el cliente implementa la interfaz
' cIABMClientGrid
'
Private m_ImplementsClientGrid As Boolean

' Indica que esta instancia edita un documento
'
Private m_IsDocument           As Boolean

' Flag que indican si esta instancia se
' encarga de implementar los items del
' documento
'
Private m_IsItems              As Boolean

' Flag que indican si esta instancia se
' encarga de implementar el footer del
' documento
'
Private m_IsFooter             As Boolean

' Flag que indica si se trata de un wizard
'
Private m_IsWizard             As Boolean

' Usada para ocultar el titulo en el
' ABM de maestros
'
Private m_HideTitle            As Boolean
Private m_Title2               As String
Private m_FormCaption          As String

' Flag que indica que estoy descargando
' la ventana de edicion
'
Private m_Unloading            As Boolean

' Flag que indica que se deben ocultar los
' botones de los tabs. Usado para asistentes
'
Private m_HideTabButtons       As Boolean

' Flag que indica que se trata de una edicion
' modal
'
Private m_InModalWindow        As Boolean

' Flag que le indica a pShow que debe invocar
' el load del form
'
Private m_LoadForm             As Boolean

' Flag para evitar la pregunta "¿desea guardar los
' cambios?" aun cuando hay hubo cambios en la
' edicion
'
Private m_bDontAskForSave      As Boolean

' Flag que indica si hubo cambios
'
Private m_WasChanged2          As Boolean

' Flag que indica que el form se ha
' mostrado. Solo se usa para ".Show vbModal"
'
Private m_FormShowed           As Boolean

' Contiene el indice del primer tab
'
Private m_FirstTab             As Long

' Indica que en lugar de mostrar "guardar cancelar"
' hay que mostrar "aceptar cancelar"
'
Private m_bOkCancelDialog         As Boolean

' Flag que contiene la respuesta del usuario
'
' True:  si el usuario acepto
' False: si cancelo
'
Private m_bOkCancelDialogRslt     As Boolean

' Flags que indican que se ha cargado el control
'
'Private m_bLoadAdHock           As Boolean
Private m_bLoadList             As Boolean
Private m_bLoadHelp             As Boolean
Private m_bLoadNumeric          As Boolean
Private m_bLoadDate             As Boolean
Private m_bLoadOption           As Boolean
Private m_bLoadLabel            As Boolean
Private m_bLoadTitle            As Boolean
Private m_bLoadProgressBar      As Boolean
Private m_bLoadDescription      As Boolean
Private m_bLoadImage            As Boolean
Private m_bLoadText             As Boolean
Private m_bLoadTextM            As Boolean
Private m_bLoadFile             As Boolean
Private m_bLoadFolder           As Boolean
Private m_bLoadPassword         As Boolean
Private m_bLoadCheck            As Boolean
Private m_bLoadGrid             As Boolean
Private m_bLoadButton           As Boolean

' Indice del Tab
'
Private m_TabIndex              As Long

' Posicion de los controles
'
Private m_constLeft       As Single
Private m_constLeftOp     As Single
Private m_constTop        As Single
Private m_constTopOp      As Single

' Permite evitar el form fABM modifique
' la posicion de los botones "save y cancel"
' en el resize
'
Private m_DontMoveGenericButton As Boolean

Private m_CancelCaption   As String
Private m_SaveCaption     As String
Private m_SaveWidth       As Long
Private m_SaveTop         As Long
Private m_SaveLeft        As Long
Private m_CancelTop       As Long
Private m_CancelLeft      As Long

' Identifica la clave de la propiedad que
' debe recibir el foco cuando se hace nuevo
'
Private m_NewKeyPropFocus       As String

Private m_bNotLockWnd           As Boolean

Private m_bUseHelpValueProcess  As Boolean

' Para evitar re-cargar los controles
' despues de grabar en algunos maestros
' muy pesados como Cliente, Proveedor
' y Articulo
'
Private m_bSendRefresh          As Boolean


' Permite contemplar un caso especial
' de edicion en grilla que se utiliza para
' la produccio de Kit
'
Private m_bCreateRowInBeforeEdit    As Boolean


' Permite indicar que no se deben modificar
' las columnas de la grilla cuando ser refrezcan
' las propiedades del form por que cambio alguna
' propiedad (evento propertychange)
'
Private m_bNoChangeColsInRefresh      As Boolean

' Permite indicar que luego de terminar de procesar
' un property change, se envie el comando save
'
Private m_bSendSave   As Boolean
Private m_bSendClose  As Boolean
Private m_SendNewDoc  As Boolean
Private m_SendNewABM  As Boolean

' Auto save para dialogos modales
'
Private m_bSendAutoSave   As Boolean

Private m_SetFocusFirstCtrlInNew  As Boolean
Private m_bSavingAs               As Boolean
Private m_InSave                  As Boolean

Private m_NoButtons1  As Long
Private m_NoButtons2  As Long
Private m_NoButtons3  As Long

Private m_ButtonsEx2  As Long
Private m_ButtonsEx3  As Long

Private m_bNoChangeBackColorCell  As Boolean

Private m_owner As Object

Private m_AutoPrint As Boolean

Private m_tabTopHeight As Long

Private m_tabHideCtrlsInAllTab As Long

' eventos
' propiedades publicas
Public Property Let tabHideCtrlsInAllTab(ByVal rhs As Long)
  m_tabHideCtrlsInAllTab = rhs
End Property

Public Property Set owner(ByVal rhs As Object)
  Set m_owner = rhs
End Property

Public Property Let bNoChangeBackColorCell(ByVal rhs As Boolean)
  m_bNoChangeBackColorCell = rhs
End Property

Public Property Let FormCaption(ByVal rhs As String)
  m_FormCaption = rhs
End Property

Public Property Let PopMenuClient(ByVal rhs As String)
  m_PopMenuClient = rhs
End Property

Public Property Get SetFocusFirstCtrlInNew() As Boolean
  SetFocusFirstCtrlInNew = m_SetFocusFirstCtrlInNew
End Property

Public Property Let SetFocusFirstCtrlInNew(ByVal rhs As Boolean)
  m_SetFocusFirstCtrlInNew = rhs
End Property

Public Property Let NoButtons1(ByVal rhs As Long)
  m_NoButtons1 = rhs
End Property

Public Property Let NoButtons2(ByVal rhs As Long)
  m_NoButtons2 = rhs
End Property

Public Property Let NoButtons3(ByVal rhs As Long)
  m_NoButtons3 = rhs
End Property

Public Property Let ButtonsEx2(ByVal rhs As Long)
  m_ButtonsEx2 = rhs
End Property

Public Property Let ButtonsEx3(ByVal rhs As Long)
  m_ButtonsEx3 = rhs
End Property

Public Property Let bSendSave(ByVal rhs As Boolean)
  m_bSendSave = rhs
End Property

Public Property Let bSendClose(ByVal rhs As Boolean)
  m_bSendClose = rhs
End Property

Public Property Let bSendAutoSave(ByVal rhs As Boolean)
  m_bSendAutoSave = rhs
End Property

Public Property Let SendNewDoc(ByVal rhs As Boolean)
  m_SendNewDoc = rhs
End Property

Public Property Let SendNewABM(ByVal rhs As Boolean)
  m_SendNewABM = rhs
End Property

Public Property Get InSave() As Boolean
  InSave = m_InSave
End Property

Public Property Get bSavingAs() As Boolean
  bSavingAs = m_bSavingAs
End Property

' Indica si se trata de un wizard
'
Public Property Let IsWizard(ByVal rhs As Boolean)
  m_IsWizard = rhs
End Property

Public Property Let bDontAskForSave(ByVal rhs As Boolean)
  m_bDontAskForSave = rhs
End Property

' Permite evitar el form fABM modifique
' la posicion de los botones "save y cancel"
' en el resize
'
Public Property Let DontMoveGenericButton(ByVal rhs As Boolean)
  m_DontMoveGenericButton = rhs
End Property

Public Property Let SaveCaption(ByVal rhs As String)
  m_SaveCaption = rhs
End Property

Public Property Let SaveWidth(ByVal rhs As Long)
  m_SaveWidth = rhs
End Property

Public Property Let CancelCaption(ByVal rhs As String)
  m_CancelCaption = rhs
End Property

Public Property Let SaveTop(ByVal rhs As Long)
  m_SaveTop = rhs
End Property

Public Property Let SaveLeft(ByVal rhs As Long)
  m_SaveLeft = rhs
End Property

Public Property Let CancelTop(ByVal rhs As Long)
  m_CancelTop = rhs
End Property

Public Property Let CancelLeft(ByVal rhs As Long)
  m_CancelLeft = rhs
End Property


' Devuelve un formulario de tipo
'
'  - fABM
'  - fABMDoc
'  - fWizad
'
Public Property Get Frm() As Object
  Dim bInit As Boolean
  
  ' Documentos
  '
  If m_IsDocument Then
    If m_FormDoc Is Nothing Then
      Set m_FormDoc = New fABMDoc
      Load m_FormDoc
      m_LoadForm = True
      bInit = True
    End If
    Set Frm = m_FormDoc
  
  ' Asistentes
  '
  ElseIf m_IsWizard Then
    If m_FormWizard Is Nothing Then
      Set m_FormWizard = New fWizard
      Load m_FormWizard
      m_LoadForm = True
      bInit = True
    End If
    Set Frm = m_FormWizard
  
  ' ABM
  '
  Else
    If m_FormABM Is Nothing Then
      Set m_FormABM = New fABM
      Load m_FormABM
      m_LoadForm = True
      bInit = True
      pSetABMCanPrint
      pSetABMShowPermisos
      
      ' Solo los ABM pueden ser
      ' de tipo CancelDialog
      '
      If m_bOkCancelDialog Then
        With m_FormABM
          With .cmdCancel
            .Caption = "&Cancelar"
            .Cancel = True
          End With
          With .cmdSave
            .Caption = "&Aceptar"
            m_FormABM.cmdCancel.Width = .Width
          End With
          .cmdClose.Visible = False
        End With
      End If
      
      With m_FormABM.cmdSave
        If LenB(m_SaveCaption) Then .Caption = m_SaveCaption
        If m_SaveWidth Then .Width = m_SaveWidth
        If m_SaveTop Then .Top = m_SaveTop
        If m_SaveLeft Then .Left = m_SaveLeft
      End With
      
      With m_FormABM.cmdCancel
        If LenB(m_CancelCaption) Then .Caption = m_CancelCaption
        If m_CancelTop Then .Top = m_CancelTop
        If m_CancelLeft Then .Left = m_CancelLeft
      End With
    End If
    
    Set Frm = m_FormABM
    
  End If
    
  ' Si invoque a Load inicializo el form
  '
  If bInit Then
    InitCtrlPosition
    InitVectorsPosition
  End If
End Property

' Flag que indica que se deben ocultar los
' botones de los tabs. Usado para asistentes
'
Public Property Let HideTabButtons(ByVal rhs As Boolean)
  m_HideTabButtons = rhs
End Property

' Tamaño minimos de la ventana
'
Public Property Let MinHeight(ByVal rhs As Long)
  m_MinHeight = rhs
End Property

Public Property Let MinWidth(ByVal rhs As Long)
  m_MinWidth = rhs
End Property

' Indica que en lugar de mostrar "guardar cancelar"
' hay que mostrar "aceptar cancelar"
'
Public Property Let OkCancelDialog(ByVal rhs As Boolean)
   m_bOkCancelDialog = rhs
End Property

Public Property Get OkCancelDialogRslt() As Boolean
   OkCancelDialogRslt = m_bOkCancelDialogRslt
End Property

Public Property Set Tabs(ByRef rhs As cIABMTabs)
  Set m_Tabs = rhs
End Property

Public Property Let NewKeyPropFocus(ByVal rhs As String)
  m_NewKeyPropFocus = rhs
End Property

Public Property Get NewKeyPropFocus() As String
  NewKeyPropFocus = m_NewKeyPropFocus
End Property

Public Property Let NotLockWnd(ByVal rhs As Boolean)
  m_bNotLockWnd = rhs
End Property

Public Property Get bNotLockWnd() As Boolean
  NotLockWnd = m_bNotLockWnd
End Property

Public Property Get hWnd() As Long
  If Frm Is Nothing Then
    hWnd = 0
  Else
    hWnd = Frm.hWnd
  End If
End Property

Public Property Let UseHelpValueProcess(ByVal rhs As Boolean)
  m_bUseHelpValueProcess = rhs
End Property

Public Sub SetRowSelected(ByRef iProperty As cIABMProperty, ByVal lRow As Long)
  On Error GoTo ControlError

  Dim oProp As cABMProperty
  Set oProp = iProperty
  If oProp.ctl Is Nothing Then Exit Sub
  
  Dim Grid As cGridAdvanced
  Set Grid = oProp.ctl
  
  Grid.SelectRow lRow
  iProperty.SelectedIndex = lRow
ControlError:
End Sub

' propiedades friend

' propiedades privadas

' Manejador para la grilla avanzada
'
Private Property Get MngGrid() As cABMCSGrid
  If m_MngGrid Is Nothing Then Set m_MngGrid = New cABMCSGrid
  Set MngGrid = m_MngGrid
End Property

Public Property Get bWasChanged() As Boolean
  bWasChanged = WasChanged()
End Property

Public Property Let tabTopHeight(ByVal rhs As Long)
  m_tabTopHeight = rhs
End Property

' Flag que indica si hubo cambios
'
Private Property Get WasChanged() As Boolean
  
  ' Para documentos es el form el que indica
  ' si hubo cambios
  '
  If m_IsDocument Then
    If Frm Is Nothing Then Exit Property
    WasChanged = Frm.WasChanged
  Else
    WasChanged = m_WasChanged2
  End If
End Property

Private Property Let WasChanged(ByVal rhs As Boolean)
  
  ' Para documentos es el form el que indica
  ' si hubo cambios
  '
  If m_IsDocument Then
    If Frm Is Nothing Then Exit Property
    DoEvents: DoEvents: DoEvents
    Frm.WasChanged = rhs
  Else
    m_WasChanged2 = rhs
  End If
  
End Property

' Esta funcion es necesaria para aquellos casos
' en los que necesito conocer el valor de una
' celda de la fila para responder al evento
' BeforeEdit. Puntualmente esto se dio en la
' edicion de Kits con alternativas y numeros de serie
' con cantidad variable. En este caso fue necesario
' conocer el pr_id de la alternativa antes de permitir
' la edicion de la celda numero de serie, para poder
' preparar el filtro SQL.
'
Public Property Let CreateRowInBeforeEdit(ByVal rhs As Boolean)
  m_bCreateRowInBeforeEdit = rhs
End Property

' Se explica en la declaracion de m_bNoChangeColsInRefresh
'
Public Property Let NoChangeColsInRefresh(ByVal rhs As Boolean)
  m_bNoChangeColsInRefresh = rhs
End Property

' Para evitar re-carga de controles en maestros
'
Public Property Let bSendRefresh(ByVal rhs As Boolean)
  m_bSendRefresh = rhs
End Property

Public Property Get AutoPrint() As String
  AutoPrint = m_AutoPrint
End Property

Public Property Let AutoPrint(ByVal rhs As String)
  m_AutoPrint = rhs
End Property

' funciones publicas
Public Sub SetBakcColorTagMain(ByVal Color As Long)
  If m_FormDoc Is Nothing Then Exit Sub
  m_FormDoc.ShTab.BackColor = Color
  m_FormDoc.shTabFooter.BackColor = Color
  m_FormDoc.shTabItems.BackColor = Color
End Sub

Public Sub SetHeightToDocWithDescrip()
  If m_FormDoc Is Nothing Then Exit Sub
  If m_IsDocument And Not m_IsItems Then
    m_FormDoc.SetHeightToDocWithDescrip
  End If
  
  If m_IsItems Then
    
    m_constTop = m_FormDoc.shTabItems.Top + 100
  
    Dim q As Long
    For q = 0 To UBound(m_NextTop)
      m_NextTop(q) = m_constTop
      m_Left(q) = m_constLeft
    Next q
  End If
End Sub

Public Sub RefreshTitle()
  pRefreshTitle
End Sub

Public Sub RefreshSelStartToEnd(ByRef iProperty As cIABMProperty)
  On Error Resume Next
  Dim oProp As cABMProperty
  Set oProp = iProperty
  With oProp.ctl
    .SelStart = Len(.Text)
  End With
End Sub

Public Sub ResetChanged()
  pResetChanged
End Sub

Public Sub ShowMessage(ByVal msg As String)
  pShowMsg msg, True
End Sub

Public Sub HideMessage()
  pHideMsg
End Sub

Public Sub SetFocusCtrl(ByRef iProperty As cIABMProperty)
  On Error Resume Next
  Dim oProp As cABMProperty
  Set oProp = iProperty
  oProp.ctl.SetFocus
  Err.Clear
End Sub

Public Sub SetFocusInGridItems()
  On Error Resume Next
  SetFocusControl m_FormDoc.GR(0)
  SendKeys "{ENTER}"
  Err.Clear
End Sub

Public Sub PrintABM(ByVal Id As Long, ByVal TblId As Long)

  Dim PrintManager As Object 'CSPrintManager.cPrintManager
  
  Set PrintManager = CSKernelClient2.CreateObject("CSPrintManager2.cPrintManager")
  
  With PrintManager
    .Path = GetValidPath(IniGetEx(c_RPT_KEY, c_RPT_PathReportes, gAppPath))
    .CommandTimeout = Val(IniGetEx(c_RPT_KEY, c_RPT_CommandTimeOut, 0))
    .ConnectionTimeout = Val(IniGetEx(c_RPT_KEY, c_RPT_ConnectionTimeOut, 0))

    .ShowPrint Id, TblId, csNO_ID
  End With
End Sub


' Por cada columna llama a la rutina
' encargada de calcular el ancho
'
Public Sub AutoWidthColumn(ByRef iProperty As cIABMProperty, _
                           Optional ByVal KeyCol As String)
                           
  Dim oProperty   As cABMProperty
  Dim Columns     As cIABMGridColumns
  Dim i           As Long
  
  Set oProperty = iProperty
  Set Columns = iProperty.Grid.Columns
  
  Dim oGrid   As cGridAdvanced
  Dim Column  As cABMGridColumn
  
  ' Obtengo un puntero a la interfaz cGridAdvanced
  '
  Set oGrid = oProperty.ctl
  
  ' Si pasan una columna especifica
  ' solo se aplica a dicha columna
  '
  If Len(KeyCol) Then
    
    ' Obtengo un puntero a la interfaz cABMGridColumn
    '
    Set Column = Columns.Item(KeyCol)
    
    oGrid.AutoWidthColumn Column.Index
  Else
    oGrid.AutoWidthColumns
  End If
End Sub

' Permite agrupar una grilla de edicion
'
' NOTA: Este codigo es una version preliminar y
'       muy limitada que solo permite agrupar por
'       una columna y ordenar por otra, ademas tiene
'       muchas limitaciones en cuanto a la posicion de las
'       columnas por las que se agrupa y ordena.
'       La columna a agrupar debe ser la 3 y la columna a
'       ordenar debe ser la 5 y aun no se porque :), pero sino
'       cumplen con esta regla, va a fallar la edicion.
'
'       Calculo que pa el 2015 lo tendremos mejorado :P
'
  Public Sub GroupGrid(ByRef iProperty As cIABMProperty, _
                       ByVal KeyCol As String, _
                       ByVal KeyColSort As String)
    
    GroupGridEx iProperty, KeyCol, KeyColSort
    
  End Sub
  
'
' Importante: offSetColSort permite insertar columnas
'             entre la primer columna y la columna de ordenamiento
'             pero hay que tener en cuenta que se debe sumar
'             3 mas el numero de columnas insertadas
'
'   Por defecto la grilla debe tener 5 columnas:
'
'                 col 1 cualquier cosa
'                 col 2 cualquier cosa
'                 col 3 la columna de agrupamiento si o si
'                 col 4 cualquier cosa
'                 col 5 la columna de ordenamiento
'
'   si col 5 no contiene la columna de ordenamiento hay que modifcar
'   el valor de offSetColSort
'
'   Por ejemplo: en las grillas de hoja de ruta y picking list
'                tenemos la siguiente configuracion
'
'                 col 1 KI_PKLPV_ID
'                 col 2 KI_PV_ID
'                 col 3 KI_CLIENTE - la columna de agrupamiento si o si
'                 col 4 KI_TIPO
'                 col 5 KI_SELECT
'                 col 6 KI_FECHA / KI_NRODOC la columna de ordenamiento
'
'                 y por ende offSetColSort es 4
'
  
  Public Sub GroupGridEx(ByRef iProperty As cIABMProperty, _
                         ByVal KeyCol As String, _
                         ByVal KeyColSort As String, _
                         Optional ByVal offSetColSort As Integer = 3)
    
100   On Error GoTo ControlError
101

      Dim mouse As cMouseWait
      Set mouse = New cMouseWait

      Dim oProp As cABMProperty
103   Set oProp = iProperty
104
105   If oProp.ctl Is Nothing Then Exit Sub
106
107   ' Ocultamos la grilla para evitar el refresh
108   '
109   Dim bVisible   As Boolean
110   Dim bCanRemove As Boolean
111
112   bCanRemove = iProperty.GridRemove
113   bVisible = oProp.ctl.Visible
114
115   iProperty.GridRemove = False
116   oProp.ctl.Visible = False
117   oProp.ctl.GridCtrl.Redraw = False

      Dim Col As cIABMGridColumn
119   Set Col = iProperty.Grid.Columns(KeyCol)
120
121   Dim Grid As cGridAdvanced
122   Set Grid = oProp.ctl
123
129   ' Eliminamos los grupos
130   '
131   Grid.ClearGroups
132   Grid.RefreshGroupsAndFormulasEx True
133
134   ' Eliminamos por completo toda la info de agrupamiento
135   ' del control, sino hacemos esto falla al reagrupar
136   '
137   Grid.ClearEx True, True, True, True, True
138
139   ' Cargamos la grilla regenerando columnas
140   '
141   MngGrid.LoadFromRows oProp.ctl, iProperty.Grid, False, iProperty.Name
142
143   ' Agregamos el agrupamiento
144   '
145   With Grid.AddGroup()
146     .Name = Col.Name
147     .Index = 1
148     .key = Val(Col.key) + 2
149     .SortType = CCLOrderAscending
150   End With
151
152   ' Agregamos el ordenamiento
153   '
154   Set Col = iProperty.Grid.Columns(KeyColSort)
155
156   With Grid.AddGroup()
157     .Name = Col.Name
158     .Index = 2
159     .key = Val(Col.key) + offSetColSort
160     .SortType = CCLOrderAscending
161     .IsSortCol = True
162   End With
163
164   ' Agrupamos y ordenamos
165   '
166   Grid.RefreshGroupsAndFormulasEx True
167   Grid.ExpandAllGroups
168   Grid.AutoWidthColumns
169   Grid.GridLines = True
170
171   Dim Row As cABMGridRow
172   Dim j   As Long
173   Dim i   As Long
174   Dim k   As Long
175
176   ' Elimino filas auxiliares que agregue
177   ' para que la grilla tenga tantas filas
178   ' como la coleccion Rows del objeto cIABMGrid
179   ' (Son filas de grupos)
180   '
181   Dim Rows As cIABMGridRows
182   Set Rows = iProperty.Grid.Rows
183
184   i = 1
185   While i < Rows.Count
186     Set Row = Rows.Item(i)
187     If Row.IsGroup Then
188       Rows.Remove i
189     Else
190       i = i + 1
191     End If
192   Wend
193
194   ' Ahora voy a agregar tantas filas
195   ' auxiliares como grupos existan en
196   ' el control Grid a la coleccion Rows
197   ' del objeto cIABMGrid para que conincidan
198   '
199   For j = 1 To Grid.Rows
200
201     If Grid.RowIsGroup(j) Then
202       Set Row = New cABMGridRow
203       Row.IsGroup = True
204       Row.Index = j
205       Rows.Add Row
206     End If
207   Next
208
209   ' Re-ordeno la coleccion Rows para que
210   ' coincida con el orden en la grilla
211   '
212   Dim Index      As Long
213   Dim SortedRows As cABMGridRows
214   Set SortedRows = New cABMGridRows
215
216   For j = 1 To Grid.Rows
217
218     Index = VBA.Val(Grid.CellText(j, 3))
219
220     If Grid.RowIsGroup(j) Then
221       SortedRows.Add Rows(j)
222     Else
223
224       For i = 1 To Rows.Count
225         Set Row = Rows.Item(i)
226         If Not Row.IsGroup Then
227           If Index = Row.Index Then
228
229             ' El indice debe estar en 0 para
230             ' que lo inserte al final
231             '
232             Row.Index = 0
233             If LenB(Row.key) Then
234               SortedRows.Add Row, Row.key
235             Else
236               SortedRows.Add Row
237             End If
238             Row.Index = -1
239             Exit For
240           End If
241         End If
242       Next
243     End If
244   Next
245
246   ' Refrezco en la grilla
247   '
248   k = 0
249   For j = 1 To Grid.Rows
250     If Not Grid.RowIsGroup(j) Then
251       k = k + 1
252       Grid.CellText(j, 3) = k
253     End If
254   Next
255
256   ' Selecciono la primer columna
257   '
258   If Grid.Rows Then
259     Grid.SelectedRow = 2
260     Grid.SelectedCol = 5
261   End If
262
263   Grid.ColumnWidth(1) = 10
264   Grid.ColumnWidth(2) = 10
265
      Grid.RowMode = False
      
266   Dim AbmGrid As cABMGrid
267   Set AbmGrid = iProperty.Grid
268
269   AbmGrid.SetRows SortedRows
270
271   ' Ahora actualizo los indices
272   '
273   Set Rows = SortedRows
274   k = 0
275
276   For j = 1 To Rows.Count
277     Set Row = Rows.Item(j)
278     If Not Row.IsGroup Then
279       k = k + 1
280       Row.Index = k
281       Row.Item(1).Value = k
282     End If
283   Next
284
285   pAddAuxCol iProperty
    
    GoTo ExitProc
ControlError:

    MngError Err, "GroupGrid", C_Module, _
             "Linea: " & Erl & vbCrLf & vbCrLf & _
             "Descrip: " & Err.Description
    If Err.Number Then Resume ExitProc
    
ExitProc:
    If oProp Is Nothing Then Exit Sub
    If oProp.ctl Is Nothing Then Exit Sub
    
    oProp.ctl.GridCtrl.Redraw = True
    oProp.ctl.Visible = bVisible
    
    iProperty.GridRemove = bCanRemove
    
    Err.Clear
  End Sub

Public Sub refreshButtonsStyle(ByVal iProp As cIABMProperty)
  On Error Resume Next
  
  Dim oProp As cABMProperty
  Set oProp = iProp
  
  If oProp.ctl Is Nothing Then Exit Sub
  
  If iProp.ForeColor <> -1 Then
    oProp.ctl.ForeColor = iProp.ForeColor
  End If
  
  If iProp.BackColor <> -1 Then
    oProp.ctl.BackColor = iProp.BackColor
    oProp.ctl.BackColorUnpressed = iProp.BackColor
    Dim buttonEnabled As Boolean
    buttonEnabled = oProp.ctl.Enabled
    oProp.ctl.Enabled = Not buttonEnabled
    oProp.ctl.Enabled = buttonEnabled
  End If
  
End Sub


' Agrego columnas auxiliares para que la cantidad
' de columnas en el control coincida con la cantidad
' en la coleccion de columnas y tambien en la cantidad
' de celdas de cada fila
'
Private Sub pAddAuxCol(ByRef iProperty As cIABMProperty)
  Const c_col_aux_group1 As String = "#aux_group_1"
  Const c_col_aux_group2 As String = "#aux_group_2"
  
  Dim Cols As cABMGridColumns
  Set Cols = iProperty.Grid.Columns
  
  ' Columnas
  '
  If iProperty.Grid.Columns.Item(c_col_aux_group1) Is Nothing Then
    With Cols.Add(Nothing, c_col_aux_group1, 1)
      .Visible = False
    End With
  End If
  
  If iProperty.Grid.Columns.Item(c_col_aux_group2) Is Nothing Then
    With Cols.Add(Nothing, c_col_aux_group2, 1)
      .Visible = False
    End With
  End If
  
  ' Celdas
  '
  Dim Row As cABMGridRow

  For Each Row In iProperty.Grid.Rows
    If Row.Item(c_col_aux_group1) Is Nothing Then
      Row.Add Nothing, c_col_aux_group1, 1
    End If
    If Row.Item(c_col_aux_group2) Is Nothing Then
      Row.Add Nothing, c_col_aux_group2, 1
    End If
  Next
  
  Dim oProp As cABMProperty
  Set oProp = iProperty
  
  Dim GridAd As cGridAdvanced
  Set GridAd = oProp.ctl
  
  If GridAd.Columns(c_col_aux_group1) Is Nothing Then
    GridAd.Columns.Add Nothing, c_col_aux_group1
  End If
  
  If GridAd.Columns(c_col_aux_group2) Is Nothing Then
    GridAd.Columns.Add Nothing, c_col_aux_group2
  End If
  
  Err.Clear
  
End Sub

Public Sub DrawGrid(ByRef iProperty As cIABMProperty, _
                    ByVal bRedraw As Boolean)
  
  Dim oProperty   As cABMProperty
  Dim oGrid       As cGridAdvanced
  
  ' Obtengo punteros a las interfaces
  ' especificas
  '
  Set oProperty = iProperty
  Set oGrid = Frm.GR(oProperty.Index)
  
  If oGrid Is Nothing Then Exit Sub
  
  oGrid.Redraw = bRedraw
  
End Sub


' Actualiza las propiedades de una columna
'
Public Function RefreshColumnPropertiesByIndex(ByRef iProperty As cIABMProperty, _
                                               ByVal KeyCol As Long)
  RefreshColumnPropertiesByIndex = pRefreshColumnProperties(iProperty, KeyCol)
End Function

Public Function RefreshColumnProperties(ByRef iProperty As cIABMProperty, _
                                        ByVal KeyCol As String)
  RefreshColumnProperties = pRefreshColumnProperties(iProperty, KeyCol)
End Function

Private Function pRefreshColumnProperties(ByRef iProperty As cIABMProperty, _
                                          ByVal KeyCol As Variant)
  Dim Column      As cABMGridColumn
  Dim oProperty   As cABMProperty
  Dim oGrid       As cGridAdvanced
  
  ' Obtengo punteros a las interfaces
  ' especificas
  '
  Set oProperty = iProperty
  Set Column = iProperty.Grid.Columns.Item(KeyCol)
  Set oGrid = Frm.GR(oProperty.Index)
  
  ' Todo esto es para no perder el
  ' ancho de la columna al refrescar
  ' las propiedades
  '
  Dim iColumn As cIABMGridColumn
  Dim ColGrid As cGridColumn
  Set iColumn = Column
  Set ColGrid = oGrid.Columns.Item(Column.Index)
  iColumn.Width = ColGrid.Width
  
  MngGrid.SetColumnPropertys oGrid, Column, ColGrid
End Function

' Modifica el estado de edicion de todas las propiedades
'
Public Sub RefreshEnabledState(ByRef iProperties As cIABMProperties)
  Dim iProperty  As cIABMProperty
  
  For Each iProperty In iProperties
    SetEnabled iProperty
  Next
  
  pSetTabIndexDescrip
End Sub

' Modifica los valores de todas las propiedades
'
Public Sub ShowValues(ByRef iProperties As cIABMProperties)
  Dim iProperty  As cIABMProperty
  
  ' Tratamiento especial para documentos
  '
  If m_IsDocument Then
    
    ' Los documentos se dividen en tres objetos
    ' cABMGeneric
    '
    For Each iProperty In iProperties
      
      If m_IsFooter Then
        ShowValue iProperty, True, c_Footer
      
      ElseIf m_IsItems Then
        ShowValue iProperty, True, c_Items
      
      Else ' Header
        ShowValue iProperty, True, c_Header
      End If
    Next
  
  Else ' ABM de maestros y asistentes
  
    For Each iProperty In iProperties
      ShowValue iProperty, True
    Next
  End If
End Sub

' Permite refrezcar de la forma mas eficiente posible
' las filas de la grilla, se utiliza en el cashflow
'
' cols_to_refresh permite indicar hasta que columnas
' se deben refrezcar, es util para grillas con muchas
' columnas que no se editan, es decir no cambian
' el truco esta en poner todas estas columnas hacia
' la derecha, y las editables hacia la izquierda
'
' si cols_to_refresh = 0 se refrezcan todas las columnas
'
Public Sub RefreshGridRows(ByVal iProperty As cIABMProperty, _
                           ByVal cols_to_refresh As Long)
  
  If iProperty.PropertyType <> cspGrid Then Exit Sub
  
  Dim oProp As cABMProperty
  Set oProp = iProperty
  
  If oProp.ctl Is Nothing Then Exit Sub
  
  Dim grCtrl     As cGridAdvanced
  Dim RowIndex   As Integer
  Dim Index      As Long
  Dim Rows       As cIABMGridRows
  Dim Columns    As cIABMGridColumns
  
  Set grCtrl = oProp.ctl
  Set Rows = iProperty.Grid.Rows
  Set Columns = iProperty.Grid.Columns
  
  Dim Col       As cIABMGridColumn
  Dim Cell      As cIABMGridCellValue
  Dim ColIndex  As Long
  Dim oRow      As cABMGridRow
  Dim Row       As cIABMGridRow
  Dim oFormat   As cABMGridCellFormat
  Dim iFormat   As cIABMGridCellFormat
  Dim oFont     As StdFont
  
  If cols_to_refresh > Columns.Count Then
    cols_to_refresh = Columns.Count
  End If
  
  If cols_to_refresh <= 0 Then
    cols_to_refresh = Columns.Count
  End If
  
  With grCtrl
    .Redraw = False
    
    For RowIndex = 1 To .Rows

      Set Row = Rows.Item(RowIndex)
      
      For ColIndex = 1 To cols_to_refresh
      
        Set Col = Columns.Item(ColIndex)
        Set Cell = Row.Item(ColIndex)
        
        With .Cell(RowIndex, ColIndex)
          .ItemData = Cell.Id
          
          If Col.PropertyType = cspDate Then
            .Text = GetDateValueForGrid(Cell.Value)
          
          ElseIf Col.SubType = cspPercent Then
            .Text = Val(Cell.Value) / 100
          
          Else
            .Text = Cell.Value
          End If
          
          ' Formato de cada celda
          '
          Set iFormat = Cell.Format
          If Not iFormat Is Nothing Then
          
            Set oFormat = Cell.Format
            .ForeColor = iFormat.Color
            .BackColor = iFormat.BackColor
            
            .TextAlign = oFormat.Align
            Set oFont = New StdFont
            With oFont
              .Name = oFormat.FontName
              .Italic = oFormat.Italic
              .Bold = oFormat.Bold
              .Size = oFormat.FontSize
              .Strikethrough = oFormat.Strike
              .Underline = oFormat.Underline
            End With
            Set .Font = oFont
          End If

        End With
      Next
    
      Set oRow = Row
      .RowBackColor(RowIndex) = oRow.BackColor
      .RowForeColor(RowIndex) = oRow.ForeColor
    
    Next
    .Redraw = True
  End With
  
End Sub

Public Sub RefreshRowColor(ByVal iProperty As cIABMProperty, _
                           ByVal RowIndex As Long, _
                           ByRef Row As cIABMGridRow)
  
  Dim oProp As cABMProperty
  Dim oGrid As cGridAdvanced
  Dim oRow  As cABMGridRow
  
  Set oProp = iProperty
  Set oGrid = oProp.ctl
  
  If oGrid Is Nothing Then Exit Sub
  
  Set oRow = Row
  oGrid.RowBackColor(RowIndex) = oRow.BackColor
  oGrid.RowForeColor(RowIndex) = oRow.ForeColor
End Sub
' Inicializa las variables auxiliares
'
Public Sub ResetLayoutMembers()
  ReDim m_NextTop(0)
  ReDim m_NextTopOp(0)
  ReDim m_Left(0)
  ReDim m_LeftOp(0)
  
  InitVectorsPosition
  
  m_LastTop = 0
  m_LastLeft = 0
  m_LastLeftOp = 0
  m_LastTopOp = 0
  m_LabelLeft = 0
End Sub

' Inicializa el left y el top de un
' Tab
'
Public Sub ResetTabLeftTop(ByVal TabIndex As Integer)
  m_NextTop(TabIndex) = m_constTop
  m_Left(TabIndex) = 2500
  m_LabelLeft = C_offsetH
End Sub

' Modifica el contenido de una celda
'
Public Function ShowCellValue(ByRef iProperty As cIABMProperty, _
                              ByVal lRow As Long, _
                              ByVal lCol As Long) As Boolean
  
  Dim oProperty As cABMProperty
  
  Set oProperty = iProperty
  
  MngGrid.ShowCellValue Frm.GR(oProperty.Index), _
                        iProperty.Grid, _
                        lRow, _
                        lCol
End Function

' Modifica el valor de una propiedad
'
Public Function ShowValue(ByRef oProperty As cABMProperty, _
                          Optional ByVal NoChangeColumns As Boolean, _
                          Optional ByVal strTag As String) As Boolean
                          
  Dim iProperty       As cIABMProperty
  Dim Item            As cIABMListItem
  Dim c               As Control
  Dim lbl             As Label
  
  Set iProperty = oProperty
  
  With Frm
  
    Select Case iProperty.PropertyType
        
'        Case csTypeABMProperty.cspAdHock
'
'            Set c = .CBhock(oProperty.Index)
'            c.Clear
'
'            For Each Item In iProperty.List
'              c.AddItem Item.Value
'              ListSetListIndexForId c, Item.Id
'            Next
'
'            c.ListIndex = iProperty.Value
'            c.Enabled = iProperty.Enabled
'
'            ' Esto es por que necesito una propiedad para el ItemData
'            ' y uso el HelpId para ello. Cuando el usuario no
'            ' modifica este control se devuelve el mismo ItemData que
'            ' se mostro.
'            '
'            iProperty.HelpId = iProperty.Value
            
        Case csTypeABMProperty.cspList
            
            Set c = .CB(oProperty.Index)
            c.Clear
            
            For Each Item In iProperty.List
              With c
                .AddItem Item.Value
                .ItemData(.NewIndex) = Item.Id
              End With
            Next
            
            Select Case iProperty.ListWhoSetItem
              
              Case csListWhoSetItem.csListItemData
                ListSetListIndexForId c, iProperty.ListItemData
              
              Case csListWhoSetItem.csListListIndex
                ListSetListIndex c, iProperty.ListListIndex
              
              Case csListWhoSetItem.csListText
                ListSetListIndexForText c, iProperty.ListText
            
            End Select
            
            If c.ListIndex = -1 And c.ListCount > 0 Then c.ListIndex = 0
            c.Enabled = iProperty.Enabled
            
        Case csTypeABMProperty.cspHelp
            Set c = .HL(oProperty.Index)
            
            With c
              .Id = iProperty.HelpId
              
              If m_bUseHelpValueProcess Then
                .ValueHelp = IIf(iProperty.HelpValueProcess <> vbNullString, _
                                 iProperty.HelpValueProcess, _
                                 iProperty.HelpId)
              Else
                .ValueHelp = iProperty.HelpId
              End If
              
              .ValueUser = iProperty.Value
              .ValueProcess = iProperty.HelpValueProcess
              .ColumnValueProcess = iProperty.HelpFieldValueProcess
              .Filter = iProperty.HelpFilter
              .SPFilter = iProperty.HelpSPFilter
              .SPInfoFilter = iProperty.HelpSPInfoFilter
              .Enabled = iProperty.Enabled
              .Table = iProperty.Table
            End With
            
        Case csTypeABMProperty.cspNumeric
            
            Set c = .ME(oProperty.Index)
            
            With c
              .csValue = iProperty.Value
              .Enabled = iProperty.Enabled
            End With
            
        Case csTypeABMProperty.cspDate, csTypeABMProperty.cspTime
            
            Set c = .MEFE(oProperty.Index)
            
            With c
              .csValue = iProperty.Value
              .Enabled = iProperty.Enabled
            End With
            
        Case csTypeABMProperty.cspOption
            
            Set c = .OP(oProperty.Index)
            
            With c
              .Value = iProperty.Value
              .Enabled = iProperty.Enabled
            End With
            
        Case csTypeABMProperty.cspText, csTypeABMProperty.cspFile, csTypeABMProperty.cspFolder
            
            If iProperty.SubType = cspMemo Then
              
              Set c = .TXM(oProperty.Index)
            Else
            
              Set c = .TX(oProperty.Index)
              If TypeOf c Is cMaskEdit Then
                c.Mask = iProperty.TextMask
              End If
            End If
            
            With c
              .Text = iProperty.Value
              .Enabled = iProperty.Enabled
            End With
            
            ' Si el control tiene mascara
            ' actualizo en iProperty.value
            ' con el texto formateado
            '
            If TypeOf c Is cMaskEdit Then
              If c.Mask <> vbNullString Then
                iProperty.Value = c.Text
              End If
            End If
            
        Case csTypeABMProperty.cspPassword
            
            Set c = .txPassword(oProperty.Index)
            
            With c
              .Text = iProperty.Value
              .Enabled = iProperty.Enabled
            End With
            
        Case csTypeABMProperty.cspCheck
            
            Set c = .CHK(oProperty.Index)
            
            With c
              .Value = IIf(Val(iProperty.Value) <> 0, vbChecked, vbUnchecked)
              .Enabled = iProperty.Enabled
            End With
            
        Case csTypeABMProperty.cspButton
            
            Set c = .CMD(oProperty.Index)
            
            With c
              .Caption = iProperty.Name
              .Enabled = iProperty.Enabled
            End With
            
        Case csTypeABMProperty.cspLabel
            
            Set c = .LB2(oProperty.Index)
            c.Caption = iProperty.Value
            If iProperty.BackColor >= 0 Then
              c.BackColor = iProperty.BackColor
            End If
            
        Case csTypeABMProperty.cspImage
            
            Set c = .Img(oProperty.Index)
            
            With c
              If TypeOf Frm Is fWizard Then
                Select Case Val(iProperty.Value)
                  Case 1
                    .Picture = m_FormWizard.ImgWiz1.Picture
                  Case 3
                    .Picture = m_FormWizard.ImgWiz3.Picture
                  Case 5
                    .Picture = m_FormWizard.ImgWiz5.Picture
                  Case Else
                    .Picture = iProperty.Picture
                End Select
              Else
                .Picture = iProperty.Picture
              End If
              .ZOrder
            End With
            
        Case csTypeABMProperty.cspTitle
            Set c = .lbTitle2(oProperty.Index)
            c.Caption = iProperty.Value
            
        Case csTypeABMProperty.cspDescription
            Set c = .LBDescrip(oProperty.Index)
            c.Caption = iProperty.Value
            
        Case csTypeABMProperty.cspGrid
            
            Dim Grid As Object
            
            Set Grid = .GR(oProperty.Index)
            Set c = Grid
            Grid.Enabled = iProperty.Enabled
            
            Dim oGrid As cABMGrid
            Set oGrid = iProperty.Grid
            Grid.MultiSelect = oGrid.MultiSelect
            
            With MngGrid
              
              .AllowAddNew(Grid) = iProperty.GridAdd
              .AllowEdit(Grid) = iProperty.GridEdit
              .AllowDelete(Grid) = iProperty.GridRemove
              
              If Not .LoadFromRows(Grid, _
                                   iProperty.Grid, _
                                   NoChangeColumns, _
                                   pGetNameGrid(iProperty)) Then
                Exit Function
              End If
              
              If iProperty.GridAdd Then
                pSetDefaults iProperty, Grid.Rows
              End If
            End With
            
        Case csTypeABMProperty.cspProgressBar
            Set c = Frm.prgBar(oProperty.Index)
            Dim iVal As Double
            iVal = Val(iProperty.Value)
            c.Value = IIf(iVal <= 100, iVal, 100)
    End Select
    
    ' Obtengo la etiqueta asociada al control
    '
    If oProperty.LabelIndex <> 0 Then
      Set lbl = .LB(oProperty.LabelIndex)
    End If
  
  End With
  
  If Not c Is Nothing Then
    
    Dim bInCurrenTag As Boolean
    Dim lenStrTag    As Long
    
    lenStrTag = Len(strTag)
    
    With c
    
      ' Si es un documento
      '
      If m_IsDocument Then
        
        If m_currtab < m_FirstTab Then
          m_currtab = m_FirstTab
        End If
        
        ' strTag permite saber si el tab pertenece
        ' al objeto de documento que esta realizando
        ' la llamada. (header, items, footer)
        '
        bInCurrenTag = Left$(.Tag, lenStrTag) = strTag _
                       And .Tag <> vbNullString _
                       And .Name <> "cbTab" _
                       And (Val(Mid(.Tag, lenStrTag + 1)) + m_FirstTab) = m_currtab
      Else
        Dim valTag As Long
        valTag = Val(.Tag)
        If valTag < 0 And valTag > csETabIdxT_All Then
          bInCurrenTag = (valTag = m_currInnerTab) Or (valTag = csETabIdxT_All And m_currInnerTab <> m_tabHideCtrlsInAllTab) Or (valTag = csETabIdxT_All2)
        Else
          bInCurrenTag = (valTag = m_currtab) Or (valTag = csETabIdxT_All And m_currtab <> m_tabHideCtrlsInAllTab) Or (valTag = csETabIdxT_All2)
        End If
      End If
      
      If bInCurrenTag Then
        
        .Visible = iProperty.Visible
        If Not lbl Is Nothing Then
          If Val(lbl.Tag) <> -1 Then
            lbl.Visible = iProperty.Visible
          End If
        End If
        
      Else
        If Not (oProperty.KeyCol = csNumberID _
                Or oProperty.KeyCol = csStateID _
                Or (iProperty.Table = csDocumento And m_IsDocument)) Then
          .Visible = False
          If Not lbl Is Nothing Then
            lbl.Visible = False
          End If
        Else
          .Visible = True
        End If
      End If
    End With
  End If
  
  DoEvents

  ShowValue = True
End Function

' Modifica el estado de edicion de los controles
'
Public Sub SetEnabled(ByRef oProperty As cABMProperty)
  Dim iProperty      As cIABMProperty
  Dim Item           As cIABMListItem
  Dim nIndex         As Long
  Dim bEnabled       As Boolean
  
  Set iProperty = oProperty
  
  nIndex = oProperty.Index
  bEnabled = iProperty.Enabled
  
  With Frm
  
    Select Case iProperty.PropertyType
      
'      Case csTypeABMProperty.cspAdHock
'        .CBhock(nIndex).Enabled = bEnabled
      
      Case csTypeABMProperty.cspList
        .CB(nIndex).Enabled = bEnabled
      
      Case csTypeABMProperty.cspHelp
        .HL(nIndex).Enabled = bEnabled
      
      Case csTypeABMProperty.cspNumeric
        .ME(nIndex).Enabled = bEnabled
      
      Case csTypeABMProperty.cspDate, _
           csTypeABMProperty.cspTime
        .MEFE(nIndex).Enabled = bEnabled
      
      Case csTypeABMProperty.cspOption
        .OP(nIndex).Enabled = bEnabled
      
      Case csTypeABMProperty.cspText, _
           csTypeABMProperty.cspFile, _
           csTypeABMProperty.cspFolder
        If iProperty.SubType = cspMemo Then
          .TXM(nIndex).Enabled = bEnabled
        Else
          .TX(nIndex).Enabled = bEnabled
        End If
      
      Case csTypeABMProperty.cspPassword
        .txPassword(nIndex).Enabled = bEnabled
      
      Case csTypeABMProperty.cspCheck
        .CHK(nIndex).Enabled = bEnabled
      
      Case csTypeABMProperty.cspButton
        .CMD(nIndex).Enabled = bEnabled
      
      Case csTypeABMProperty.cspGrid
        Dim Grid As Object
        Set Grid = .GR(nIndex)
        Grid.Enabled = bEnabled
    End Select
  End With
  
  DoEvents
End Sub

' Carga los controles asociados a las propiedades
'
Public Function LoadControlEx(ByRef oProperty As cABMProperty, _
                              Optional ByVal NoGrids As Boolean) As Boolean
                              
  Dim iProperty  As cIABMProperty
  
  If Not oProperty.ControlLoaded Then
    
    If Not LoadControl(oProperty) Then
      Exit Function
    End If
    
    oProperty.ControlLoaded = True
  End If
  
  Set iProperty = oProperty
  
  If iProperty.PropertyType <> cspGrid _
     Or Not NoGrids Then
     
    ShowValue oProperty
  End If
  
  pSetTabIndexDescrip
  
  pSetBackgroundColor
  
  LoadControlEx = True
End Function

' Descarga los controles
'
Public Sub UnloadControl(ByRef oProperty As cABMProperty)

  Dim iProperty As cIABMProperty
  
  If oProperty.ControlLoaded Then
  
    Set oProperty.ctl = Nothing
    
    Set iProperty = oProperty
    
    Dim nIndex As Long
    nIndex = oProperty.Index
    
    With Frm
      Select Case iProperty.PropertyType
        
'        Case csTypeABMProperty.cspAdHock
'
'          If nIndex = 0 Then
'            .CBhock(0).Visible = 0
'          Else
'            Unload .CBhock(nIndex)
'          End If
        
        Case csTypeABMProperty.cspList
          
          If nIndex = 0 Then
            .CB(0).Visible = 0
          Else
            Unload .CB(nIndex)
          End If
        
        Case csTypeABMProperty.cspHelp
          
          If nIndex = 0 Then
            .HL(0).Visible = 0
          Else
            Unload .HL(nIndex)
          End If
        
        Case csTypeABMProperty.cspNumeric
          
          If nIndex = 0 Then
            .ME(0).Visible = 0
          Else
            Unload .ME(nIndex)
          End If
        
        Case csTypeABMProperty.cspDate, _
             csTypeABMProperty.cspTime
          
          If nIndex = 0 Then
            .MEFE(0).Visible = 0
          Else
            Unload .MEFE(nIndex)
          End If
        
        Case csTypeABMProperty.cspLabel
          
          If nIndex = 0 Then
            .LB2(0).Visible = 0
          Else
            Unload .LB2(nIndex)
          End If
        
        Case csTypeABMProperty.cspTitle
          
          If nIndex = 0 Then
            .lbTitle2(0).Visible = 0
          Else
            Unload .lbTitle2(nIndex)
          End If
        
        Case csTypeABMProperty.cspProgressBar
          
          If nIndex = 0 Then
            .prgBar(0).Visible = 0
          Else
            Unload .prgBar(nIndex)
          End If
        
        Case csTypeABMProperty.cspDescription
          
          If nIndex = 0 Then
            .LBDescrip(0).Visible = 0
          Else
            Unload .LBDescrip(nIndex)
          End If
        
        Case csTypeABMProperty.cspImage
          
          If nIndex = 0 Then
            .Img(0).Visible = 0
          Else
            Unload .Img(nIndex)
          End If
        
        Case csTypeABMProperty.cspText, _
             csTypeABMProperty.cspFile, _
             csTypeABMProperty.cspFolder
          
          If iProperty.SubType = cspMemo Then
            If nIndex = 0 Then
              .TXM(0).Visible = 0
            Else
              Unload .TXM(nIndex)
            End If
          Else
            If nIndex = 0 Then
              .TX(0).Visible = 0
            Else
              Unload .TX(nIndex)
            End If
          End If
          
        Case csTypeABMProperty.cspPassword
          
          If nIndex = 0 Then
            .txPassword(0).Visible = 0
          Else
            Unload .txPassword(nIndex)
          End If
        
        Case csTypeABMProperty.cspCheck
          
          If nIndex = 0 Then
            .CHK(0).Visible = 0
          Else
            Unload .CHK(nIndex)
          End If
          
        Case csTypeABMProperty.cspGrid
          
          If nIndex = 0 Then
            .GR(0).Visible = 0
          Else
            Unload .GR(nIndex)
          End If
        
        Case csTypeABMProperty.cspButton
          
          If nIndex = 0 Then
            .CMD(0).Visible = 0
          Else
            Unload .CMD(nIndex)
          End If
      End Select
    End With
    
    nIndex = oProperty.LabelIndex
    If nIndex > 0 Then
      Unload Frm.LB(nIndex)
    End If
  End If
End Sub

Public Sub CloseWizard()
  WasChanged = False
  Unload m_FormWizard
End Sub

Public Function TabGetFirstCtrl(ByVal Index As Integer) As Object
  Dim c           As Control
  Dim ChildIndex  As Long
  Dim FatherIndex As Long
  Dim bVisible    As Boolean
  Dim TabIndex    As Long
  
  TabIndex = 999
  
  With Frm
  
    If InStr(1, .cbTab(Index).Tag, c_InerTab) Then
      
      ChildIndex = GetTagChildIndex(.cbTab(Index).Tag)
      FatherIndex = GetTagFatherIndex(.cbTab(Index).Tag)
          
      For Each c In .Controls
        If Not CBool(TypeOf c Is cButton And InStr(1, c.Name, "cbTab")) Then
          If LenB(Trim$(c.Tag)) Then
            If Val(c.Tag) <> FatherIndex Then
              
              bVisible = pGetControlVisible(c, pGetCtrlVisibleInTab(c, ChildIndex))
                      'Val(c.Tag) = ChildIndex Or Val(c.Tag) = csETabIdxT_All)
              
              If bVisible Then
              
                If TypeOf c Is Label Then
                  ' Nada que hacer este no sirve ya que no puede tomar el foco
                ElseIf TypeOf c Is Toolbar Then
                  ' Nada que hacer este no sirve ya que no puede tomar el foco
                Else
                  If c.TabIndex < TabIndex Then
                    TabIndex = c.TabIndex
                    Set TabGetFirstCtrl = c
                  End If
                End If
              End If
            End If
          End If
        End If
      Next
      
    Else
      
      For Each c In .Controls
        If TypeOf c Is cButton And InStr(1, c.Name, "cbTab") Then
          
          ' Es un inner tab, no tengo que hacer nada con esto
          
        ElseIf LenB(Trim$(c.Tag)) Then

          bVisible = pGetControlVisible(c, pGetCtrlVisibleInTab(c, Index))
                          'Val(c.Tag) = Index Or Val(c.Tag) = csETabIdxT_All)
          
          If bVisible Then
          
            If TypeOf c Is Label Then
              ' Nada que hacer este no sirve ya que no puede tomar el foco
            ElseIf TypeOf c Is Toolbar Then
              ' Nada que hacer este no sirve ya que no puede tomar el foco
            ElseIf TypeOf c Is Image Then
              ' Nada que hacer este no sirve ya que no puede tomar el foco
            Else
              If c.TabIndex < TabIndex Then
                TabIndex = c.TabIndex
                Set TabGetFirstCtrl = c
              End If
            End If
          End If

        End If
      Next
    End If
  End With
End Function

Public Function DocTabGetFirstCtrl(ByVal Index As Integer, ByVal Tag As String) As Object
  
  Select Case Tag
    
    ' Para documentos los tag de los controles tienen
    ' la palabra Items o Footers o "" (null string)
    ' para identificar a que grupo pertenecen
    Case c_Items
      If m_IsItems Then
        Set DocTabGetFirstCtrl = pDocTabGetFirstCtrl(c_Items, Index)
      End If
    Case c_Footer
      If m_IsFooter Then
        Set DocTabGetFirstCtrl = pDocTabGetFirstCtrl(c_Footer, Index)
      End If
    Case Else
      If m_IsItems Or m_IsFooter Then Exit Function
      Set DocTabGetFirstCtrl = pDocTabGetFirstCtrl(c_Header, Index)
  End Select

End Function

Public Function DocTabClick(ByVal Index As Integer, ByVal Tag As String)
  Dim oLock As cLockUpdateWindow
  Set oLock = New cLockUpdateWindow
  oLock.LockW Frm.hWnd
  
  Select Case Tag
    
    ' Para documentos los tag de los controles tienen
    ' la palabra Items o Footers o "" (null string)
    ' para identificar a que grupo pertenecen
    Case c_Items
      If m_IsItems Then
        pDocTabClickEx c_Items, Index
      End If
    Case c_Footer
      If m_IsFooter Then
        pDocTabClickEx c_Footer, Index
      End If
    Case Else
      If m_IsItems Or m_IsFooter Then Exit Function
      pDocTabClickEx c_Header, Index
  End Select
  
  oLock.UnLockW
End Function

Private Function pDocTabGetFirstCtrl(ByVal strTag As String, ByVal Index As Integer) As Control
  Dim c         As Control
  Dim bVisible  As Boolean
  Dim TabIndex  As Long
  
  TabIndex = 999
  
  With Frm
    For Each c In .Controls
      If Left$(c.Tag, Len(strTag)) = strTag And c.Tag <> vbNullString And c.Name <> "cbTab" Then
        
        bVisible = pGetControlVisible(c, Val(Mid(c.Tag, Len(strTag) + 1)) + m_FirstTab = Index)
        
        If bVisible Then
        
          If TypeOf c Is Label Then
            ' Nada que hacer este no sirve ya que no puede tomar el foco
          ElseIf TypeOf c Is Toolbar Then
            ' Nada que hacer este no sirve ya que no puede tomar el foco
          ElseIf TypeOf c Is Image Then
            ' Nada que hacer este no sirve ya que no puede tomar el foco
          Else
            If c.TabIndex < TabIndex Then
              TabIndex = c.TabIndex
              Set pDocTabGetFirstCtrl = c
            End If
          End If
        End If
      End If
    Next
  End With
End Function

Private Sub pDocTabClickEx(ByVal strTag As String, ByVal Index As Integer)
  Dim c As Control
  
  m_currtab = Index
  
  With Frm
    For Each c In .Controls
      If Left$(c.Tag, Len(strTag)) = strTag And c.Tag <> vbNullString And c.Name <> "cbTab" Then
        
        c.Visible = pGetControlVisible(c, Val(Mid(c.Tag, Len(strTag) + 1)) + m_FirstTab = Index)
        
        If TypeOf c Is Label Then
          If c.BackColor = vbButtonFace Then
            c.BackColor = .ShTab.BackColor
          End If
          c.ZOrder
          If LCase(c.Name) = "lb" Then
            If LenB(Trim$(c.Caption)) = 0 Then
              c.Visible = False
            End If
          End If
        ElseIf TypeOf c Is CheckBox Then
          c.BackColor = .ShTab.BackColor
        End If
        If TypeOf c Is Toolbar And c.Visible Then
          .SetToolbar c
        End If
      End If
    Next
  End With
End Sub

Private Function pGetControlVisible(ByRef ctl As Object, ByVal bVisible As Boolean) As Boolean
  Dim oProperty As cABMProperty
  Dim iProp     As cIABMProperty
  Dim iProperties As cIABMProperties
  
  pGetControlVisible = bVisible
  
  Set iProperties = m_Properties
  
  For Each oProperty In iProperties
    If oProperty.ctl Is ctl Then
      Set iProp = oProperty
      If Not iProp.Visible Then
        pGetControlVisible = False
      End If
      Exit Function
    
    ElseIf TypeOf ctl Is Label Then

      If Left$(ctl.Name, 3) <> "LB2" Then
        If oProperty.LabelIndex = ctl.Index Then
          Set iProp = oProperty
          If Not iProp.Visible Then
            pGetControlVisible = False
          End If
          Exit Function
        End If
      End If
    End If
  Next
End Function

Public Function TabClick(ByVal Index As Integer)
  Dim c           As Control
  Dim ChildIndex  As Long
  Dim FatherIndex As Long
  Dim oLock       As cLockUpdateWindow
  Dim FirstTab    As Object
  Dim bVisible    As Boolean
  
  m_currInnerTab = 0
  
  With Frm
  
    Set oLock = New cLockUpdateWindow
    oLock.LockW .hWnd
    
    If InStr(1, .cbTab(Index).Tag, c_InerTab) Then
      
      ChildIndex = GetTagChildIndex(.cbTab(Index).Tag)
      FatherIndex = GetTagFatherIndex(.cbTab(Index).Tag)
          
      For Each c In .Controls
        If Not CBool(TypeOf c Is cButton And InStr(1, c.Name, "cbTab")) Then
          If LenB(Trim$(c.Tag)) Then
            If Val(c.Tag) <> FatherIndex Then
              pSetVisible c, ChildIndex
            End If
          End If
        End If
      Next
      
      Dim cmdTab As CSButton.cButton
      Set cmdTab = .cbTab(Index)
      cmdTab.VirtualPush
      
      m_currInnerTab = ChildIndex
      
    Else
      m_currtab = Index
      
      For Each c In .Controls
        If TypeOf c Is cButton And InStr(1, c.Name, "cbTab") Then
          If InStr(1, c.Tag, c_InerTab) Then
            bVisible = GetTagFatherIndex(c.Tag) = Index
            c.Visible = bVisible
            If bVisible Then
              If FirstTab Is Nothing Then Set FirstTab = c
            End If
          End If
        ElseIf LenB(Trim$(c.Tag)) Then
          pSetVisible c, Index
        End If
      Next
    
    End If
    
    If Not FirstTab Is Nothing Then
      TabClick FirstTab.Index
      m_currInnerTab = GetTagChildIndex(FirstTab.Tag)
    End If
    
    oLock.UnLockW
  End With
End Function

Private Sub pSetVisible(ByRef c As Object, ByVal Index As Long)
    
  With Frm
  
    c.Visible = pGetControlVisible(c, pGetCtrlVisibleInTab(c, Index))
    If TypeOf c Is Label Then
      If c.BackColor = vbButtonFace Then
        c.BackColor = .ShTab.BackColor
      End If
      c.ZOrder
      If LCase(c.Name) = "lb" Then
        If LenB(Trim$(c.Caption)) = 0 Then
          c.Visible = False
        End If
      End If
    ElseIf TypeOf c Is CheckBox Then
      c.BackColor = .ShTab.BackColor
    End If
    If TypeOf c Is Toolbar And c.Visible Then
      .SetToolbar c
    End If
  End With
End Sub

Public Function ShowEx(Obj As CSInterfacesABM.cIABMClient, _
                       ByVal IndexTag As Integer, _
                       ByVal bAddProp As Boolean) As Boolean
  ShowEx = pShow(Obj, IndexTag, Not bAddProp)
End Function

Public Function Show(Obj As CSInterfacesABM.cIABMClient, ByVal IndexTag As Integer) As Boolean
  On Error GoTo ControlError
  
  Dim mouse As cMouseWait
  Set mouse = New cMouseWait
  
  Show = pShow(Obj, IndexTag, True)
  
  GoTo ExitProc
ControlError:
  MngError Err, "Show", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Public Sub SetIconFormDoc(ByVal IconIndex As Long)
  If m_FormDoc Is Nothing Then Exit Sub
  If m_FormDoc.imIcon.ListImages.Count < IconIndex Then Exit Sub
  Set m_FormDoc.Icon = m_FormDoc.imIcon.ListImages.Item(IconIndex).Picture
End Sub

Public Sub SetIconFormABM(ByVal IconIndex As Long)
  If m_FormABM Is Nothing Then Exit Sub
  If m_FormABM.imIcon.ListImages.Count < IconIndex Then Exit Sub
  Set m_FormABM.Icon = m_FormABM.imIcon.ListImages.Item(IconIndex).Picture
End Sub

' Presenta el menu popup del boton doc_aux de documentos
'
Public Function ShowPopMenu(ByVal strMenuDef As String)
  Dim vMenus As Variant
  Dim vMenu  As Variant
  
  Const c_menu_sep = "|"
  Const c_menu_sep2 = "~"
  
  vMenus = Split(strMenuDef, c_menu_sep)
  
  Dim iPTop   As Long
  Dim iP      As Long
  Dim iP2     As Long
  Dim iP3     As Long
  Dim i       As Integer
  
  If m_Menu Is Nothing Then
    Set m_Menu = New cPopupMenu
  End If
  
  m_Menu.Clear

  ' Creating a Menu:
  With m_Menu
    ' Initial set up:
    .hWndOwner = Frm.hWnd
    .OfficeXpStyle = True
  End With

  For i = 0 To UBound(vMenus)
    vMenu = Split(vMenus(i), c_menu_sep2)
    iP = m_Menu.AddItem(vMenu(0), , vMenu(1), _
                        iPTop _
                        )
  Next
  
  Dim Left As Long
  Dim Top  As Long
  
  GetMousePosition Left, Top
  
  Left = (Left * Screen.TwipsPerPixelX) - Frm.Left
  Top = (Top * Screen.TwipsPerPixelY) - Frm.Top - 200
  
  m_Menu.ShowPopupMenu Left, _
                       Top
  
End Function

Private Function pShow(Obj As CSInterfacesABM.cIABMClient, _
                       ByVal IndexTag As Integer, _
                       ByVal bInitMemebers As Boolean) As Boolean
  Dim mouse  As cMouse
  Dim tmpObj As cIABMClientGrid
  
  If Obj Is Nothing Then Exit Function
  
  Set m_Client = Obj
  
  If bInitMemebers Then InitLoadMembers
  
  If m_IsDocument Or m_IsWizard Then
    m_bLoadHelp = True
    m_bLoadNumeric = True
    m_bLoadText = True
  End If
  
  With Frm
  
    m_ImplementsClientGrid = ImplementsInterface(m_Client, tmpObj)
    .ShTab.BackColor = vb3DHighlight
    
    If m_LoadForm Then
      m_LoadForm = False
      
      If m_owner Is Nothing Then
        If m_MinHeight < .Height Then m_MinHeight = .Height
        If m_MinWidth < .Width Then m_MinWidth = .Width
      End If
      
      If TypeOf Frm Is fABM Then
        Frm.DontMoveGenericButton = m_DontMoveGenericButton
        Frm.PopMenuClient = m_PopMenuClient
      End If
      
      If TypeOf Frm Is fWizard Then
        CSKernelClient2.LoadForm Frm, "wiz" ' Aproposito para que no cambie el tamaño inicial del form
      Else
        CSKernelClient2.LoadForm Frm, "ABM_" & m_Client.Title
      End If
      
      If TypeOf Frm Is fABM Or TypeOf Frm Is fWizard Then
        If .Height < m_MinHeight Then .Height = m_MinHeight
        If .Width < m_MinWidth Then .Width = m_MinWidth
      End If
    End If
    
    If Not ShowForm(IndexTag) Then Exit Function
    
    .Caption = pGetFormCaption()
    
    If m_HideTitle Then
      .lbTitle.Visible = False
    Else
      .lbTitle.Caption = m_Client.Title
    End If
    
    If TypeOf Frm Is fABM Then
      .cmdDocs.Visible = m_Client.CanAddDocDigital
      .cmdNew.Visible = m_Client.CanNew
      .cmdCopy.Visible = m_Client.CanCopy
    End If
    
    pRefreshTitle
    
    If .Visible Then
      .ZOrder
    Else
      If m_IsDocument Then
        If m_IsFooter Then
          .Loading = False
          If m_InModalWindow Then
            If Not m_FormShowed Then
              m_FormShowed = True
              Set mouse = New cMouse
              mouse.MouseDefault
              .Show vbModal
            End If
          Else
            .Show
          End If
        End If
      Else
        .Loading = False
        If m_InModalWindow Then
          If Not m_FormShowed Then
            m_FormShowed = True
            Set mouse = New cMouse
            mouse.MouseDefault
            If TypeOf Frm Is fABM Or TypeOf Frm Is fWizard Then
              .ShowForm
              pSetDontResize
              .FirstResize
              
              If TypeOf Frm Is fWizard Then
                CSKernelClient2.GetConfigForm Frm, "ABM_" & gEmpNombre & " - " & m_Client.Title
              End If
            End If
            If m_bSendAutoSave Then
              If TypeOf Frm Is fABM Then
                Frm.SendAutoSave
              End If
            End If
            If Frm Is m_FormABM Then
              m_FormABM.raiseAfterLoadEvent
            End If
            .Show vbModal, m_owner
          End If
        Else
          If TypeOf Frm Is fABM Or TypeOf Frm Is fWizard Then
            .ShowForm
            pSetDontResize
            .FirstResize
          
            If TypeOf Frm Is fWizard Then
              CSKernelClient2.GetConfigForm Frm, "ABM_" & gEmpNombre & " - " & m_Client.Title
            End If
          End If
          .Show , m_owner
        End If
      End If
    End If
    
    pShow = True
  End With
End Function
' funciones privadas

Private Property Let cIABMGeneric_HideTitle(ByVal rhs As Boolean)
  m_HideTitle = rhs
End Property

Private Property Let cIABMGeneric_InModalWindow(ByVal rhs As Boolean)
  m_InModalWindow = rhs
End Property

Private Property Get cIABMGeneric_InModalWindow() As Boolean
  cIABMGeneric_InModalWindow = m_InModalWindow
End Property

Private Property Let cIABMGeneric_IsDocument(ByVal rhs As Boolean)
  m_IsDocument = rhs
End Property

Private Property Let cIABMGeneric_IsFooter(ByVal rhs As Boolean)
  m_IsFooter = rhs
End Property

Private Property Let cIABMGeneric_IsItems(ByVal rhs As Boolean)
  m_IsItems = rhs
End Property

Private Property Let cIABMGeneric_Left(ByVal rhs As Single)
  Frm.Left = rhs
End Property

Private Property Get cIABMGeneric_Left() As Single
  cIABMGeneric_Left = Frm.Left
End Property

Private Property Set cIABMGeneric_ObjForm(ByVal rhs As Object)
  Set m_FormDoc = rhs

  InitCtrlPosition
  InitVectorsPosition
End Property

Private Property Get cIABMGeneric_ObjForm() As Object
  Set cIABMGeneric_ObjForm = Frm
End Property

Private Property Get cIABMGeneric_PicMain() As Object
  Set cIABMGeneric_PicMain = Frm.Image1
End Property

' Implementacion de Interface
Private Property Get cIABMGeneric_Properties() As CSInterfacesABM.cIABMProperties
  Set cIABMGeneric_Properties = m_Properties
End Property

Private Sub cIABMGeneric_RefreshControls(Optional ByVal NoGrids = True)
  
  If m_Unloading Then Exit Sub
  
  Dim lockwnd As cLockUpdateWindow
  Set lockwnd = New cLockUpdateWindow
  lockwnd.LockW Frm.hWnd
  
  ShowForm -1, NoGrids, False

  On Error Resume Next
  
  Dim cmdTab As CSButton.cButton
  Set cmdTab = Frm.cbTab(m_currtab)
  cmdTab.VirtualPush

End Sub

Private Property Get cIABMGeneric_ShapeMain() As Object
  Set cIABMGeneric_ShapeMain = Frm.ShTab
End Property

Private Function cIABMGeneric_Show(Obj As CSInterfacesABM.cIABMClient) As Boolean
  Dim mouse As cMouseWait
  Set mouse = New cMouseWait
  
  cIABMGeneric_Show = Show(Obj, 0)
End Function

Private Sub cIABMGeneric_ShowValue(iProp As CSInterfacesABM.cIABMProperty)
  Dim strTag As String
  If m_IsDocument Then
    strTag = pGetStrTag(iProp)
  End If
  ShowValue iProp, , strTag
End Sub

Private Function pGetStrTag(ByRef oProp As cABMProperty) As String
  On Error Resume Next
  If oProp.ctl Is Nothing Then Exit Function
  With oProp.ctl
    pGetStrTag = Mid(.Tag, 1, Len(.Tag) - 1)
  End With
End Function

Private Property Get cIABMGeneric_Tabs() As CSInterfacesABM.cIABMTabs
  If m_Tabs Is Nothing Then Set m_Tabs = New cABMTabs
  Set cIABMGeneric_Tabs = m_Tabs
End Property

Private Function cIABMGeneric_Terminate() As Boolean

End Function

Private Property Let cIABMGeneric_Title2(ByVal rhs As String)
  m_Title2 = rhs
End Property

Private Property Let cIABMGeneric_Top(ByVal rhs As Single)
  Frm.Top = rhs
End Property

Private Property Get cIABMGeneric_Top() As Single
  cIABMGeneric_Top = Frm.Top
End Property

Private Sub m_FormABM_AbmKeyDown(KeyCode As Integer, Shift As Integer)
  On Error Resume Next
  m_Client.MessageEx MSG_KEY_DOWN, KeyCode
End Sub

Private Sub m_FormABM_AfterShowModal()
  On Error Resume Next
  m_Client.MessageEx MSG_FORM_AFTER_SHOW_MODAL, Nothing
End Sub

Private Sub m_FormABM_PopItemClick(ByVal Index As Integer)
  On Error Resume Next
  m_Client.MessageEx MSG_POP_MENU_ITEM, Index
End Sub

Private Sub m_FormABM_SetResizeGrid()
  pSetDontResize
End Sub

Private Sub m_FormABM_TabGetFirstCtrl(ByVal Index As Integer, ctrl As Control)
  Set ctrl = TabGetFirstCtrl(Index)
End Sub

Private Sub m_FormDoc_CMDClick(ByVal Index As Integer)
  ChangeProperty cspButton, Index, Frm.CMD(Index)
End Sub

Private Sub m_FormDoc_GRDblClick(ByVal Index As Integer, ByVal RowIndex As Long, ByVal ColIndex As Long)
  
  If Not m_IsItems Then Exit Sub
  
  If m_ImplementsClientGrid Then
    Dim ClientGrid As cIABMClientGrid
    Dim iProperty  As cIABMProperty

    Set ClientGrid = m_Client
    Set iProperty = GetProperty(cspGrid, Index, 0)
    ClientGrid.DblClick iProperty.key, RowIndex, ColIndex
  End If
End Sub

Private Sub m_FormDoc_HLKeyDown(Index As Integer, KeyCode As Integer, Shift As Integer)
  Dim iProperty  As cIABMProperty
  Set iProperty = GetProperty(cspHelp, Index, 0)
  If iProperty Is Nothing Then Exit Sub
  
  If KeyCode = vbKeyF2 Then
    m_Client.MessageEx MSG_ABM_KEY_F2, iProperty
  ElseIf KeyCode = vbKeyF3 Then
    m_Client.MessageEx MSG_ABM_KEY_F3, iProperty
  End If
  
End Sub

Private Sub m_FormWizard_GRDblClick(ByVal Index As Integer, ByVal RowIndex As Long, ByVal ColIndex As Long)
  If m_ImplementsClientGrid Then
    Dim ClientGrid As cIABMClientGrid
    Dim iProperty  As cIABMProperty

    Set ClientGrid = m_Client
    Set iProperty = GetProperty(cspGrid, Index, 0)
    ClientGrid.DblClick iProperty.key, RowIndex, ColIndex
  End If
End Sub

Private Sub m_FormWizard_TabGetFirstCtrl(ByVal Index As Integer, ctrl As Control)
  Set ctrl = TabGetFirstCtrl(Index)
End Sub

'/////////////////////////////////////////////////////////////////////////////////////////
' Eventos de la interfaz

'-----------
' Menu
'
Private Sub m_Menu_Click(ByRef ItemNumber As Long)
  On Error GoTo ControlError
  
  Dim ItemData  As Long
  
  ItemData = m_Menu.ItemData(ItemNumber)
  
  m_Client.MessageEx MSG_MENU_AUX, ItemData

  GoTo ExitProc
ControlError:
  MngError Err, "m_Menu_Click", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

'------------
' Abms
'
Private Sub m_FormABM_CBChange(ByVal Index As Integer)
  pCBChange Index
End Sub

'Private Sub m_FormABM_CBhockChange(ByVal Index As Integer)
'  pCBHockChange Index
'End Sub

Private Sub m_FormABM_cbTabClick(ByVal Index As Integer)
  TabClick Index
End Sub

Private Sub m_FormABM_CHKClick(ByVal Index As Integer)
  pCHKClick Index
End Sub

Private Sub m_FormABM_cmdCancelClick()
  On Error GoTo ControlError
  
  If m_bOkCancelDialog Then
    m_FormABM_cmdCloseClick
    m_bOkCancelDialogRslt = False
  Else
    
    If m_bSendRefresh Then
      m_Client.MessageEx MSG_DOC_REFRESH, Nothing
      pRefreshTitle
      WasChanged = False
    Else
      pDiscardChanges
    End If
  End If

  GoTo ExitProc
ControlError:
  MngError Err, "m_FormABM_cmdCancelClick", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub m_FormABM_CMDClick(ByVal Index As Integer)
  ChangeProperty cspButton, Index, Frm.CMD(Index)
End Sub

Private Sub m_FormABM_cmdCloseClick()
  If m_FormABM Is Nothing Then Exit Sub
  Unload m_FormABM
End Sub

Private Sub m_FormABM_cmdCopyClick()
  m_Client.Copy
  On Error Resume Next
  m_FormABM.ZOrder
  Err.Clear
End Sub

Private Sub m_FormABM_cmdDocsClick()
  m_Client.ShowDocDigital
End Sub

Private Sub m_FormABM_cmdNewClick()
  On Error GoTo ControlError
  If m_Client.CanNew Then
    
    doNew m_FormABM
  
    On Error Resume Next
    m_FormABM.ZOrder
    Err.Clear
  End If
  
  GoTo ExitProc
ControlError:
  MngError Err, "m_FormABM_cmdNewClick", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub doNew(ByVal Frm As Form)
  Dim mouse As cMouseWait
  Set mouse = New cMouseWait
  
  Dim lockwnd As cLockUpdateWindow
  
  ' Solo en headers y en abm's
  If m_IsDocument Then
    If m_IsItems Then Exit Sub
    If m_IsFooter Then Exit Sub
  End If
  
  If Not pSaveChanges(False, False) Then Exit Sub
  
  With Frm
  
    m_Title2 = vbNullString
  
    If Not m_IsDocument And Not m_bSendRefresh Then
      pDiscardChanges True
    End If
    
    Set lockwnd = New cLockUpdateWindow
    lockwnd.LockW .hWnd
    
    m_Client.EditNew
     
    If m_bSendRefresh Then
      pRefreshTitle
    End If
    
    If m_IsDocument Then
      If Not pNewWithWizard() Then
        pMoveFocus
      End If
    End If
    
    WasChanged = False
     
    If m_NewKeyPropFocus <> vbNullString Then
      pSetFocusFromKeyProp m_NewKeyPropFocus
    Else
      
      If m_IsDocument Then
        If Not pNewWithWizard() Then
          .SetFocusFirstControl
        End If
      End If
    End If
  End With
End Sub

Private Sub pMoveFocus()
  Dim c As Object
  
  If Not m_FormDoc Is Nothing Then
    On Error Resume Next
    Set c = m_FormDoc.ActiveControl
    m_FormDoc.MEFE.Item(0).SetFocus
    Err.Clear
    DoEvents: DoEvents: DoEvents
    c.SetFocus
    DoEvents: DoEvents: DoEvents
    Err.Clear
  End If
End Sub

Private Sub pSetFocusFromKeyProp(ByVal KeyProp As String)
  On Error Resume Next
  
  Dim iPropeties As cIABMProperties
  Dim oProp      As cABMProperty
  
  Set iPropeties = m_Properties
  
  Set oProp = iPropeties.Item(KeyProp)
  oProp.ctl.SetFocus
  
End Sub

Private Sub m_FormABM_cmdPrintClick()
  On Error Resume Next
  Dim rtnVar As Variant
  
  rtnVar = m_Client.MessageEx(MSG_ABM_PRINT, Nothing)
  If VarType(rtnVar) <> vbBoolean Then
    MsgInfo "Esta interfaz no posee impresión"
  End If
End Sub

Private Sub pSetABMCanPrint()
  On Error Resume Next
  Dim rtnVar As Variant
  
  rtnVar = m_Client.MessageEx(MSG_ABM_CAN_PRINT, Nothing)
  If Val(rtnVar) <> MSG_ABM_CAN_PRINT Then
    Frm.cmdPrint.Visible = False
  Else
    Frm.cmdPrint.Visible = True
  End If
End Sub

Private Sub m_FormABM_cmdPermisosClick()
  On Error Resume Next
  Dim rtnVar As Variant
  
  rtnVar = m_Client.MessageEx(MSG_EDIT_PERMISOS, Nothing)
  If VarType(rtnVar) <> vbBoolean Then
    MsgInfo "Esta interfaz no permite editar permisos"
  End If
End Sub

Private Sub pSetABMShowPermisos()
  On Error Resume Next
  Dim rtnVar As Variant
  
  rtnVar = m_Client.MessageEx(MSG_SHOW_EDIT_PERMISOS, Nothing)
  If Val(rtnVar) <> MSG_SHOW_EDIT_PERMISOS Then
    Frm.cmdPermisos.Visible = False
  Else
    Frm.cmdPermisos.Visible = True
  End If
End Sub

Private Sub pShowHelp()
  On Error Resume Next
  Dim rtnVar As Variant
  
  rtnVar = m_Client.MessageEx(MSG_DOC_INFO, Nothing)
  
  If VarType(rtnVar) <> vbBoolean Then
    If IsNumeric(rtnVar) Then
      If Val(rtnVar) <> MSG_DOC_INFO_HANDLED Then
        pShowHelpAux
      End If
    Else
      pShowHelpAux
    End If
  Else
    pShowHelpAux
  End If
End Sub

Private Sub pShowHelpAux()
  On Error Resume Next
  CSKernelClient2.EditFile CSKernelClient2.GetValidPath(gAppPath) & "cairo.chm", hWnd
End Sub

Private Sub m_FormABM_cmdSaveClick()
  If Not pSave(False, False) Then Exit Sub
  
  If m_bOkCancelDialog Then
    m_bOkCancelDialogRslt = True
    
    If Not m_FormABM Is Nothing Then
      m_FormABM.SetSaved
      m_FormABM_cmdCloseClick
    End If
  
  Else
  
    If m_SendNewABM Then
      m_FormABM_cmdNewClick
    End If
  End If
End Sub

Private Sub m_FormABM_FormLoad()
  pResetChanged
End Sub

Private Sub m_FormABM_FormQueryUnload(Cancel As Integer, ByVal UnloadMode As Integer)
  If Not m_Client Is Nothing Then
    pSaveChanges Cancel, True
  End If
End Sub

Private Sub m_FormABM_FormUnload(Cancel As Integer)
  If Not m_Client Is Nothing Then
      
    SaveColumnsGrids
    
    DestroyGrids Frm
    
    m_Unloading = True
      
    m_Client.Terminate
    Set m_Client = Nothing
  End If
  Set m_FormABM = Nothing
End Sub

Private Function pSaveChanges(ByRef Cancel As Integer, ByVal bUnloading As Boolean) As Boolean
  If m_IsDocument Then
    If m_IsFooter Or m_IsItems Then
      pSaveChanges = True
      Exit Function
    End If
  End If
  
  If WasChanged And Not m_bDontAskForSave Then
    Dim rslt As VbMsgBoxResult
    
    Frm.ZOrder
    rslt = MsgBox("Ud. ha realizado cambios que no ha guardado." & vbCrLf & vbCrLf & "¿Desea guardarlos?", vbQuestion + vbYesNoCancel, "Guardar")
    
    If rslt = vbYes Then
    
      If Not pSave(bUnloading, False) Then
        Cancel = True
        Exit Function
      End If
      WasChanged = False
    
    ElseIf rslt = vbNo Then
      WasChanged = False
    
    ElseIf rslt = vbCancel Then
      Cancel = True
      Exit Function
    End If
  End If
  
  pSaveChanges = True
End Function

'Private Sub m_FormABM_GRClick(ByVal Index As Integer)
' Ya veremos que hacemos
'End Sub

Private Sub m_FormABM_GRColumnAfterEdit(ByVal Index As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long, bCancel As Boolean)
  pGRColumnEdit True, Index, lRow, lCol, 0, NewValue, NewValueID, bCancel
End Sub

Private Sub m_FormABM_GRColumnAfterUpdate(ByVal Index As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long)
  pGRColumnAfterUpdate Index, lRow, lCol, 0, NewValue, NewValueID
End Sub

Private Sub m_FormABM_GRColumnBeforeEdit(ByVal Index As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer, bCancel As Boolean)
  pGRColumnEdit False, Index, lRow, lCol, iKeyAscii, 0, 0, bCancel
End Sub

Private Sub m_FormABM_GRColumnButtonClick(ByVal Index As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer, bCancel As Boolean)
  pGRColumnButtonClick Index, lRow, lCol, iKeyAscii, bCancel
End Sub

Private Sub m_FormABM_GRDblClick(ByVal Index As Integer, ByVal RowIndex As Long, ByVal ColIndex As Long)
  If m_ImplementsClientGrid Then
    Dim ClientGrid As cIABMClientGrid
    Dim iProperty  As cIABMProperty

    Set ClientGrid = m_Client
    Set iProperty = GetProperty(cspGrid, Index, 0)
    ClientGrid.DblClick iProperty.key, RowIndex, ColIndex
  End If
End Sub

Private Sub m_FormABM_GRDeleteRow(Index As Integer, ByVal lRow As Long, bCancel As Boolean)
  pGRDeleteRow Index, lRow, bCancel
End Sub

Private Sub m_FormABM_GRNewRow(ByVal Index As Integer, ByVal RowIndex As Long)
  pGRNewRow Index, RowIndex
End Sub

Private Sub m_FormABM_GRRowWasDeleted(ByVal Index As Integer, ByVal RowIndex As Long)
  pGRRowWasDeleted Index, RowIndex
End Sub

Private Sub m_FormABM_GRSelectionChange(ByVal Index As Integer, ByVal lRow As Long, ByVal lCol As Long)
  pGRSelectionChange Index, lRow, lCol, csEGridSelectionChange
End Sub

' Por ahora no se necesita
'
'Private Sub m_FormABM_GRSelectionColChange(Index As Integer, ByVal lRow As Long, ByVal lCol As Long)
'  pGRSelectionChange Index, lRow, lCol, csEGridColChange
'End Sub

Private Sub m_FormABM_GRSelectionRowChange(ByVal Index As Integer, ByVal lRow As Long, ByVal lCol As Long)
  pGRSelectionChange Index, lRow, lCol, csEGridRowChange
End Sub

Private Sub m_FormABM_GRValidateRow(ByVal Index As Integer, ByVal RowIndex As Long, bCancel As Boolean)
  pGRValidateRow Index, RowIndex, bCancel, True, False
End Sub

Private Sub m_FormABM_HLChange(ByVal Index As Integer)
  pHLChange Index
End Sub

Private Sub m_FormABM_MEChange(ByVal Index As Integer)
  pMEChange Index
End Sub

Private Sub m_FormABM_MEDateChange(ByVal Index As Integer)
  pMEDateChange Index
End Sub

Private Sub m_FormABM_OPClick(ByVal Index As Integer)
  pOPClick Index
End Sub

Private Sub m_FormABM_ShowHelp()
  pShowHelp
End Sub

Private Sub m_FormABM_ToolBarButtonClick(ByVal Button As MSComctlLib.Button)
  pToolBarButtonClik Button
End Sub

Private Sub m_FormABM_TXButtonClick(Index As Integer, Cancel As Boolean)
  pTXButtonClick Index, Cancel
End Sub

Private Sub m_FormABM_TXChange(ByVal Index As Integer)
  pTXChange Index
End Sub

Private Sub m_FormABM_TXMChange(ByVal Index As Integer)
  pTXMChange Index
End Sub

Private Sub m_FormABM_TXPasswordChange(ByVal Index As Integer)
  pTXPasswordChange Index
End Sub

Private Sub m_FormDoc_cbTabClick(ByVal Index As Integer, ByVal Tag As String)
  DocTabClick Index, Tag
End Sub

' Esta funcion tiene este codigo tan raro
' por que el evento se dispara tres veces
' una por hedaer, una por items y una por
' footers, y por lo tanto no debemos modificar
' la variable de retorno ctrl si no tenemos
' un control ya que la recibimos en nothing
' en la primera llamada y en las siguientes
' llamadas puede o no estar en nothing dependiendo
' de donde se activo el tab (Header, Items, Footers)
'
Private Sub m_FormDoc_TabGetFirstCtrl(ByVal Index As Integer, ByVal Tag As String, ByRef ctrl As Control)
  Dim ctrlAux As Control
  Set ctrlAux = DocTabGetFirstCtrl(Index, Tag)
  If Not ctrlAux Is Nothing Then
    Set ctrl = ctrlAux
  End If
End Sub

Private Sub m_FormDoc_FormLoad()
  pResetChanged
End Sub

Private Sub m_FormDoc_GRRowWasDeleted(ByVal Index As Integer, ByVal RowIndex As Long)
  pGRRowWasDeleted Index, RowIndex
End Sub

Private Sub m_FormDoc_ToolBarClick(ByVal Button As MSComctlLib.Button)
  On Error GoTo ControlError

  If m_IsItems Then Exit Sub
  If m_IsFooter Then Exit Sub

  If Button Is Nothing Then Exit Sub

  Select Case Button.key
    Case c_KeyTbNew

      pToolBarClickNew

      If m_SendNewDoc Then

          ' El comportamiento generico es poner el foco
          ' en segunda columna de la grilla
          '
          If m_SetFocusFirstCtrlInNew Then

            ' Nada que hacer

          Else

            SetFocusControl m_FormDoc.GR(0)
            SendKeys "{ENTER}"
          End If

      End If

      m_Client.MessageEx MSG_DOC_NEW_EVENT_COMPLETE, Nothing

    Case c_KeyTbSave

      pShowMsg "Guardando el comprobante ..."

      If pSave(False, False) Then

        If m_SendNewDoc Then

          pToolBarClickNew

          ' El comportamiento generico es poner el foco
          ' en segunda columna de la grilla
          '
          If m_SetFocusFirstCtrlInNew Then

            ' Nada que hacer

          Else

            SetFocusControl m_FormDoc.GR(0)
            SendKeys "{ENTER}"
          End If

        End If

      End If

      pHideMsg

    Case c_KeyTbSaveAs

      pShowMsg "Guardando el comprobante ..."

      m_bSavingAs = True

      If pSave(False, True) Then

        If m_SendNewDoc Then

          pToolBarClickNew

          ' El comportamiento generico es poner el foco
          ' en segunda columna de la grilla
          '
          If m_SetFocusFirstCtrlInNew Then

            ' Nada que hacer

          Else

            SetFocusControl m_FormDoc.GR(0)
            SendKeys "{ENTER}"
          End If

        End If

      End If

      m_bSavingAs = False

      pHideMsg

    Case c_KeyTbAnular

      pShowMsg "Anulando el comprobante ..."
      m_Client.MessageEx MSG_DOC_ANULAR, Nothing
      pHideMsg

    Case c_KeyTbReload

      pReloadDocument

    Case c_KeyTbCopy

      m_FormABM_cmdCopyClick

    Case c_KeyTbEditState
      m_Client.MessageEx MSG_DOC_EDIT_STATE, Nothing

    Case c_KeyTbDocAux
      m_Client.MessageEx MSG_DOC_DOC_AUX, Nothing

    Case c_KeyTbDocAction
      m_Client.MessageEx MSG_DOC_DOC_ACTION, Nothing

    Case c_KeyTbDocEdit
      m_Client.MessageEx MSG_DOC_DOC_EDIT, Nothing

    Case c_KeyTbDelete

      pShowMsg "Borrando el comprobante ..."
      If pAskDelete("Confirma que desea borrar el comprobante") Then
        If VarToBool(m_Client.MessageEx(MSG_DOC_DELETE, Nothing)) Then
          pResetChanged
        End If
      End If
      pHideMsg

    Case c_KeyTbSearch

      m_Client.MessageEx MSG_DOC_SEARCH, WasChanged

    Case c_KeyTbPrint
      pPrint False

    Case c_KeyTbDocMail
      pPrint True

    Case c_KeyTbSignature
      m_Client.MessageEx MSG_DOC_SIGNATURE, Nothing

    Case c_KeyTbApply

      pShowMsg "Cargando las aplicaciones del comprobante ..."
      m_Client.MessageEx MSG_DOC_APPLY, Nothing
      pHideMsg

    Case c_KeyTbAttach
      m_FormABM_cmdDocsClick

    Case c_KeyTbHistory
      m_Client.MessageEx MSG_DOC_HISTORY, Nothing

    Case c_KeyTbFirst

      pShowMsg "Cargando el primer comprobante ..."
      pMove MSG_DOC_FIRST
      pHideMsg

    Case c_KeyTbPrevious

      pShowMsg "Cargando el comprobante anterior ..."
      pMove MSG_DOC_PREVIOUS
      pHideMsg

    Case c_KeyTbNext

      pShowMsg "Cargando el siguiente comprobante ..."
      pMove MSG_DOC_NEXT
      pHideMsg

    Case c_KeyTbLast

      pShowMsg "Cargando el último comprobante ..."
      pMove MSG_DOC_LAST
      pHideMsg

    Case c_KeyTbHelp
      pShowHelp

    Case c_KeyTbDocMerge
      pShowMsg "Ejecutando el proceso de compensación ..."
      m_Client.MessageEx MSG_DOC_MERGE, Nothing
      pHideMsg

    Case c_KeyTbDocAlert
      pShowMsg "Cargando alertas para este comprobante..."
      m_Client.MessageEx MSG_DOC_ALERT, Nothing
      pHideMsg

    Case c_KeyTbDocTip
      CSKernelClient2.SendEmailToCrowSoft "Sugerencia para CrowSoft Cairo", _
                                          "Documento: " & m_Title2

    Case c_KeyTbClose
      pFormDocClose
  
    Case Else
      m_Client.MessageEx MSG_TOOLBAR_BUTTON_CLICK, Button.key
  
  End Select

  GoTo ExitProc
ControlError:
  MngError Err, "m_FormDoc_ToolBarClick", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
  pHideMsg
  m_bSavingAs = False

End Sub

Public Sub RaiseNewDocEven()

  pToolBarClickNew
  
  If m_SendNewDoc Then
  
    ' El comportamiento generico es poner el foco
    ' en segunda columna de la grilla
    '
    If m_SetFocusFirstCtrlInNew Then
      
      ' Nada que hacer
      
    Else
    
      SetFocusControl m_FormDoc.GR(0)
      SendKeys "{ENTER}"
    End If
  
  End If

End Sub

Public Sub SetFocusInGridForDocs()

  SetFocusControl m_FormDoc.GR(0)
  SendKeys "{ENTER}"

End Sub

' Actualiza la coleccion rows del objeto grid de iProp
' con los valores select del objeto row de la coleccion
' rows del control cGrid.
'
' Siempre hay al menos una fila seleccionada ya que la
' que tiene el foco esta siempre seleccionada
'
Public Sub RefreshSelectedInGrid(ByRef iProp As cIABMProperty)
  m_MngGrid.RefreshSelectedInGrid iProp
End Sub

' Solo acepta filas seleccionadas si el foco esta en la primera
' columna
'
' Esto es para diferenciar entre una fila seleccionada explicitamente
' de una fila seleccionada por que el foco esta en ella
'
Public Sub RefreshSelectedInGrid2(ByRef iProp As cIABMProperty)
  m_MngGrid.RefreshSelectedInGrid2 iProp
End Sub

Private Sub pToolBarClickNew()
  pShowMsg "Cargando nuevo comprobante ..."
  doNew m_FormDoc
  pHideMsg
End Sub

Private Sub pShowMsg(ByVal msg As String, _
                     Optional ByVal changeTop As Boolean = False)
  On Error Resume Next
  With Frm
    .picMsg.Left = (.ScaleWidth - .picMsg.Width) * 0.5
    If changeTop Then
      .picMsg.Top = (.ScaleHeight - .picMsg.Height) * 0.25
    End If
    .lbMsg.Caption = msg
    .picMsg.ZOrder
    .picMsg.Visible = True
    DoEvents
  End With
End Sub

Private Sub pHideMsg()
  On Error Resume Next
  Frm.picMsg.Visible = False
End Sub

Private Sub pMove(ByVal MoveTo As ABM_MSG)
  If Not m_Client Is Nothing Then
    
    If Not pSaveChanges(False, False) Then Exit Sub
    
    m_Client.MessageEx MoveTo, Nothing
    
    If m_IsDocument Then
    
      pMoveFocus
    End If
    
    WasChanged = False
  
  End If
End Sub

'------------
' Wizard
Private Sub m_FormWizard_CBChange(ByVal Index As Integer)
  pCBChange Index
End Sub

'Private Sub m_FormWizard_CBhockChange(ByVal Index As Integer)
'  pCBHockChange Index
'End Sub

Private Sub m_FormWizard_cbTabClick(ByVal Index As Integer)
  TabClick Index
End Sub

Private Sub m_FormWizard_CHKClick(ByVal Index As Integer)
  pCHKClick Index
End Sub

Private Sub m_FormWizard_cmdCancelClick()
  On Error Resume Next
  If m_bInProcess Then Exit Sub
  pWizDisableButtons
  If Not m_Client.PropertyChange(K_W_CANCEL) Then
    pWizEnableButtons
    Exit Sub
  End If
  
  pWizEnableButtons
  WasChanged = False
  Unload m_FormWizard
  Err.Clear
End Sub

Private Sub m_FormWizard_cmdBackClick()
  On Error Resume Next
  If m_bInProcess Then Exit Sub
  pWizDisableButtons
  MoveBack
  pWizEnableButtons
  Err.Clear
End Sub

Private Sub m_FormWizard_CMDClick(ByVal Index As Integer)
  ChangeProperty cspButton, Index, Frm.CMD(Index)
End Sub

Private Sub m_FormWizard_cmdNextClick()
  On Error Resume Next
  If m_bInProcess Then Exit Sub
  pWizDisableButtons
  MoveNext
  pWizEnableButtons
  Err.Clear
End Sub

Private Sub m_FormWizard_FormLoad()
  pResetChanged
End Sub

Private Sub m_FormWizard_FormQueryUnload(Cancel As Integer, ByVal UnloadMode As Integer)
  If Not m_Client Is Nothing Then
    pSaveChanges Cancel, True
  End If
End Sub

Private Sub m_FormWizard_FormUnload(Cancel As Integer)
  If Not m_Client Is Nothing Then
    
    SaveColumnsGrids
    
    DestroyGrids Frm
    
    m_Unloading = True
    
    m_Client.Terminate
    Set m_Client = Nothing
  End If
  Set m_FormWizard = Nothing
End Sub

Private Sub m_FormWizard_GRColumnAfterEdit(ByVal Index As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long, bCancel As Boolean)
  pGRColumnEdit True, Index, lRow, lCol, 0, NewValue, NewValueID, bCancel
End Sub

Private Sub m_FormWizard_GRColumnAfterUpdate(ByVal Index As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long)
  pGRColumnAfterUpdate Index, lRow, lCol, 0, NewValue, NewValueID
End Sub

Private Sub m_FormWizard_GRColumnBeforeEdit(ByVal Index As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer, bCancel As Boolean)
  pGRColumnEdit False, Index, lRow, lCol, iKeyAscii, 0, 0, bCancel
End Sub

Private Sub m_FormWizard_GRColumnButtonClick(Index As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer, bCancel As Boolean)
  pGRColumnButtonClick Index, lRow, lCol, iKeyAscii, bCancel
End Sub

'Private Sub m_FormWizard_GRDblClick(ByVal Index As Integer, ByVal RowIndex As Long, ByVal ColIndex As Long)
' Ya veremos que hacemos
'End Sub

Private Sub m_FormWizard_GRDeleteRow(Index As Integer, ByVal lRow As Long, bCancel As Boolean)
  pGRDeleteRow Index, lRow, bCancel
End Sub

Private Sub m_FormWizard_GRNewRow(ByVal Index As Integer, ByVal RowIndex As Long)
  pGRNewRow Index, RowIndex
End Sub

Private Sub m_FormWizard_GRRowWasDeleted(ByVal Index As Integer, ByVal RowIndex As Long)
  pGRRowWasDeleted Index, RowIndex
End Sub

Private Sub m_FormWizard_GRSelectionChange(Index As Integer, ByVal lRow As Long, ByVal lCol As Long)
  pGRSelectionChange Index, lRow, lCol, csEGridSelectionChange
End Sub

' Por ahora no se necesita
'
'Private Sub m_FormWizard_GRSelectionColChange(Index As Integer, ByVal lRow As Long, ByVal lCol As Long)
'  pGRSelectionChange Index, lRow, lCol, csEGridColChange
'End Sub

Private Sub m_FormWizard_GRSelectionRowChange(Index As Integer, ByVal lRow As Long, ByVal lCol As Long)
  pGRSelectionChange Index, lRow, lCol, csEGridRowChange
End Sub

Private Sub m_FormWizard_GRValidateRow(ByVal Index As Integer, ByVal RowIndex As Long, bCancel As Boolean)
  pGRValidateRow Index, RowIndex, bCancel, True, False
End Sub

Private Sub m_FormWizard_HLChange(ByVal Index As Integer)
  pHLChange Index
End Sub

Private Sub m_FormWizard_MEChange(ByVal Index As Integer)
  pMEChange Index
End Sub

Private Sub m_FormWizard_MEDateChange(ByVal Index As Integer)
  pMEDateChange Index
End Sub

Private Sub m_FormWizard_OPClick(ByVal Index As Integer)
  pOPClick Index
End Sub

Private Sub m_FormWizard_ToolBarButtonClick(ByVal Button As MSComctlLib.Button)
  pToolBarButtonClik Button
End Sub

Private Sub m_FormWizard_TXChange(ByVal Index As Integer)
  On Error GoTo ControlError
  
  pTXChange Index
  
  Exit Sub
ControlError:
  MngError Err, "m_FormWizard_TXChange", C_Module, vbNullString
End Sub

Private Sub m_FormWizard_TXMChange(ByVal Index As Integer)
  On Error GoTo ControlError
  
  pTXMChange Index
  
  Exit Sub
ControlError:
  MngError Err, "m_FormWizard_TXMChange", C_Module, vbNullString
End Sub

Private Sub m_FormWizard_TXPasswordChange(ByVal Index As Integer)
  pTXPasswordChange Index
End Sub

'------------
' Documentos
Private Sub m_FormDoc_CBChange(ByVal Index As Integer)
  pCBChange Index
End Sub

Private Sub m_FormDoc_CHKClick(ByVal Index As Integer)
  pCHKClick Index
End Sub

Private Sub pFormDocClose()
  If m_FormDoc Is Nothing Then Exit Sub
  Unload m_FormDoc
End Sub

Private Sub m_FormDoc_FormQueryUnload(Cancel As Integer, ByVal UnloadMode As Integer)
  If m_IsFooter Or m_IsItems Then Exit Sub
  
  If Not m_Client Is Nothing Then
    
    With Frm
    
      .CancelUnload = False
      If Not pSaveChanges(Cancel, True) Then
        .CancelUnload = True
      End If
    End With
  End If
End Sub

Private Sub m_FormDoc_FormUnload(Cancel As Integer)
    
  Frm.UnloadCount = Frm.UnloadCount + 1
  
  With Frm
  
    If m_IsFooter Or m_IsItems Then
      
      ' Solo si el usuario no desidio cancelar el cierre del form
      If .CancelUnload Then Exit Sub
      
      SaveColumnsGrids
      m_Unloading = True
      
      Set m_Client = Nothing
      
    Else
    
      If Not m_Client Is Nothing Then
        
        .CancelUnload = False
        
        SaveColumnsGrids
        m_Unloading = True
        
        m_Client.Terminate
        Set m_Client = Nothing
      End If
      
    End If
    
    ' Solo destruyo las grillas en el footer que
    ' es el ultimo en recibir el evento unload
    '
    If Frm.UnloadCount = 3 Then DestroyGrids Frm
    
    Set m_FormDoc = Nothing
  End With
End Sub

Private Sub m_FormDoc_GRColumnButtonClick(Index As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer, bCancel As Boolean)
  pGRColumnButtonClick Index, lRow, lCol, iKeyAscii, bCancel
End Sub

Private Sub m_FormDoc_GRColumnAfterEdit(ByVal Index As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long, bCancel As Boolean)
  pGRColumnEdit True, Index, lRow, lCol, 0, NewValue, NewValueID, bCancel
End Sub

Private Sub m_FormDoc_GRColumnAfterUpdate(ByVal Index As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long)
  pGRColumnAfterUpdate Index, lRow, lCol, 0, NewValue, NewValueID
End Sub

Private Sub m_FormDoc_GRColumnBeforeEdit(ByVal Index As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer, bCancel As Boolean)
  pGRColumnBeforeEdit Index, lRow, lCol, iKeyAscii, bCancel
  If bCancel Then Exit Sub
  pGRColumnEdit False, Index, lRow, lCol, iKeyAscii, 0, 0, bCancel
End Sub

Private Sub m_FormDoc_GRDeleteRow(Index As Integer, ByVal lRow As Long, bCancel As Boolean)
  pGRDeleteRow Index, lRow, bCancel
End Sub

Private Sub m_FormDoc_GRNewRow(ByVal Index As Integer, ByVal RowIndex As Long)
  pGRNewRow Index, RowIndex
End Sub

Private Sub m_FormDoc_GRValidateRow(ByVal Index As Integer, ByVal RowIndex As Long, bCancel As Boolean)
  pGRValidateRow Index, RowIndex, bCancel, True, False
End Sub

Private Sub m_FormDoc_GRSelectionChange(Index As Integer, ByVal lRow As Long, ByVal lCol As Long)
  pGRSelectionChange Index, lRow, lCol, csEGridSelectionChange
End Sub

' Por ahora no se necesita
'
'Private Sub m_FormDoc_GRSelectionColChange(Index As Integer, ByVal lRow As Long, ByVal lCol As Long)
'  pGRSelectionChange Index, lRow, lCol, csEGridColChange
'End Sub

Private Sub m_FormDoc_GRSelectionRowChange(Index As Integer, ByVal lRow As Long, ByVal lCol As Long)
  pGRSelectionChange Index, lRow, lCol, csEGridRowChange
End Sub

Private Sub m_FormDoc_HLChange(ByVal Index As Integer)
  pHLChange Index
End Sub

Private Sub m_FormDoc_MEChange(ByVal Index As Integer)
  pMEChange Index
End Sub

Private Sub m_FormDoc_MEDateChange(ByVal Index As Integer)
  pMEDateChange Index
End Sub

Private Sub m_FormDoc_OPClick(ByVal Index As Integer)
  pOPClick Index
End Sub

Private Sub m_FormDoc_TXChange(ByVal Index As Integer)
  pTXChange Index
End Sub

Private Sub m_FormDoc_TXMChange(ByVal Index As Integer)
  pTXMChange Index
End Sub

Private Sub m_FormDoc_TXPasswordChange(ByVal Index As Integer)
  pTXPasswordChange Index
End Sub

' funciones del objeto
Private Sub pCBChange(ByVal Index As Integer)
  ChangeProperty cspList, Index, Frm.CB(Index)
  'ReLoadListAdHock
End Sub

Private Sub pCHKClick(ByVal Index As Integer)
  ChangeProperty cspCheck, Index, Frm.CHK(Index)
  'ReLoadListAdHock
End Sub

Private Sub pGRDeleteRow(Index As Integer, ByVal lRow As Long, bCancel As Boolean)
  If Not m_ImplementsClientGrid Then Exit Sub
  
  Dim oProperty   As cABMProperty
  Set oProperty = GetProperty(cspGrid, Index, 0)
  
  If oProperty Is Nothing Then Exit Sub
  
  Dim ClientGrid As cIABMClientGrid
  Set ClientGrid = m_Client
  
  If ClientGrid.DeleteRow(pGetPropertyKey(oProperty), pCreateRow(Index, oProperty, lRow), lRow) Then
    Dim iProperty As cIABMProperty
    Set iProperty = oProperty
    iProperty.Grid.Rows.Remove lRow
    bCancel = False
    m_Client.MessageEx MSG_GRID_ROW_DELETED, iProperty.key
  
    On Error Resume Next
    Dim Grid As Object
    Set Grid = Frm.GR(oProperty.Index)
    If Grid.Rows <= 1 Then
      Grid.Rows = 2
    End If
  Else
    bCancel = True
  End If
End Sub

Private Sub pGRRowWasDeleted(Index As Integer, ByVal lRow As Long)
  Dim iProperty   As cIABMProperty
  Set iProperty = GetProperty(cspGrid, Index, 0)
  
  pRefreshRowsIndex iProperty, lRow

  On Error Resume Next
  Dim Grid As Object
  Set Grid = Frm.GR(Index)
  If Grid.Rows < 1 Then
    Grid.Rows = 1
  End If
End Sub

Private Sub pRefreshRowsIndex(ByRef iProperty As cIABMProperty, ByVal lRow As Long)
  On Error GoTo ControlError
  
  For lRow = lRow To iProperty.Grid.Rows.Count
    ShowCellValue iProperty, lRow, 1
  Next
  
  Dim Grid      As cGridAdvanced
  Dim oProperty As cABMProperty
  
  Set oProperty = iProperty
  Set Grid = oProperty.ctl
  If lRow <= Grid.Rows Then
    Grid.Cell(lRow, 1).Text = lRow
  End If
  
ControlError:
End Sub

Private Sub pSetRowBackground(ByVal Index As Long, ByRef iProperty As cIABMProperty, ByVal lRow As Long, ByVal lCol As Long)
  On Error GoTo ControlError

  Dim Grid As cGridAdvanced
  Set Grid = Frm.GR(Index)
  
  If iProperty.Grid.Columns(lCol).PropertyType = cspGrid Then
    Grid.SelectRow lRow
  Else
    Grid.UnSelectRow
  End If
ControlError:
End Sub

Private Sub pGRSelectionChange(ByVal Index As Integer, _
                               ByVal lRow As Long, _
                               ByVal lCol As Long, _
                               ByVal What As csEGridSelectChangeType)
                               
  Dim iProperty   As cIABMProperty
  Set iProperty = GetProperty(cspGrid, Index, 0)
  
  If Not iProperty Is Nothing Then
    iProperty.SelectedIndex = lRow
    
    If What = csEGridSelectionChange Then
      
      pSetRowBackground Index, iProperty, lRow, lCol
    
    ' Aun no implementado por que no se necesita
    '
    ' ElseIf What = csEGridColChange Then
      'If m_Client Is Nothing Then Exit Sub
      'm_Client.MessageEx MSG_GRID_COL_CHANGE, iProperty
    
    ElseIf What = csEGridRowChange Then
  
      If m_Client Is Nothing Then Exit Sub
      m_Client.MessageEx MSG_GRID_ROW_CHANGE, iProperty
    End If
  End If
End Sub

Private Sub pGRNewRow(ByVal Index As Integer, ByVal RowIndex As Long)
  If m_ImplementsClientGrid Then
    
    Dim oProperty   As cABMProperty
    Set oProperty = GetProperty(cspGrid, Index, 0)
    
    If Not oProperty Is Nothing Then
    
      Dim ClientGrid As cIABMClientGrid
      Set ClientGrid = m_Client
      
      ClientGrid.NewRow pGetPropertyKey(oProperty), RowIndex
      
      pSetDefaults oProperty, RowIndex
    End If
  End If
End Sub

Private Sub pSetDefaults(ByRef oProperty As cABMProperty, ByVal RowIndex As Long)
  Dim Grid      As Object
  Dim iProp     As cIABMProperty
  Dim iRow      As cIABMGridRow
  Dim Col       As cIABMGridColumn
  Dim ColIndex  As Long
  
  Set iProp = oProperty
  Set iRow = pCreateRow(oProperty.Index, oProperty, RowIndex)
  
  Set iProp = oProperty
  iRow.Item(1).Value = iProp.Grid.Rows.Count + 1

  For Each Col In iProp.Grid.Columns
    ColIndex = ColIndex + 1
    If Not Col.DefaultValue Is Nothing Then
      With iRow.Item(ColIndex)
        .Id = Col.DefaultValue.Id
        .Value = Col.DefaultValue.Value
      End With
    End If
  Next
  
  If iRow Is Nothing Then Exit Sub
  
  Set Grid = Frm.GR(oProperty.Index)
  MngGrid.LoadFromRow Grid, iRow, RowIndex, iProp.Grid.Columns
End Sub

Private Sub pGRColumnAfterUpdate(ByVal Index As Integer, _
                                 ByVal lRow As Long, _
                                 ByVal lCol As Long, _
                                 ByVal iKeyAscii As Integer, _
                                 ByVal NewValue As Variant, _
                                 ByVal NewValueID As Long)
  On Error GoTo ControlError
  
  If m_ImplementsClientGrid Then
    
    Dim oProperty   As cABMProperty
    Dim iProperty   As cIABMProperty
    
    Set oProperty = GetProperty(cspGrid, Index, 0)
    
    If Not oProperty Is Nothing Then
    
      Dim ClientGrid As cIABMClientGrid
      Dim KeyProp    As String
      
      KeyProp = pGetPropertyKey(oProperty)
      
      Set ClientGrid = m_Client
    
      ' If the row not exists we have to create it because the client need it to hold
      ' calculated data
      pCreateRowIfNotExists oProperty, Index, lRow
    
      pSetColumnValueInProperty oProperty, Index, lRow, lCol, NewValue, NewValueID
      
      ' Multi
      ' Si no se generaron filas virtuales con esta llamada
      ' actualiso los valores en la grilla
      '
      If Not pProcessVirtualRow(oProperty, Index, lRow, lCol, _
                                KeyProp, ClientGrid) Then
      
        ' Let client one chance to calculate columns
        ClientGrid.ColumnAfterUpdate KeyProp, lRow, lCol
        
        Set iProperty = oProperty
        pSetRowValueInGrid Index, oProperty, lRow, iProperty.Grid.Rows(lRow)
      
      End If
      
      If pIsEditColumn(oProperty, lCol) Then
      
        WasChanged = True
        
      End If
    End If
  End If
  
  Exit Sub
ControlError:
  MngError Err, "pGRColumnAfterUpdate", C_Module, vbNullString
End Sub

Private Function pIsEditColumn(ByVal iProperty As cIABMProperty, _
                               ByVal lCol As Long) As Boolean
  Dim oCol As cABMGridColumn
  Set oCol = iProperty.Grid.Columns(lCol)
  pIsEditColumn = oCol.IsEditColumn
End Function

Private Function pProcessVirtualRow(ByRef oProperty As cABMProperty, _
                                    ByVal Index As Integer, _
                                    ByVal lRow As Long, _
                                    ByVal lCol As Long, _
                                    ByVal KeyProp As String, _
                                    ByRef ClientGrid As cIABMClientGrid) As Boolean

  ' Manejo de Filas Virtuales
  '
  Dim iAddRows As Long
  Dim i        As Long
  Dim q        As Long
  Dim vrInfo   As cVirtualRowInfo
  Set vrInfo = New cVirtualRowInfo
  
  If pAddVirtualRows(pGetPropertyKey(oProperty), _
                     lRow, _
                     lCol, _
                     iAddRows, _
                     vrInfo) Then
  
    pProcessVirtualRow = True
  
    Dim iProperty As cIABMProperty
    Set iProperty = oProperty
  
    Dim n As Long
    n = iProperty.Grid.Rows.Count
    
    oProperty.ctl.Rows = n + iAddRows
  
    iAddRows = n + iAddRows
    
    For i = n To iAddRows
      q = q + 1
      pGRNewRow Index, i
      pCreateRowIfNotExists oProperty, Index, i
      
      If i < iAddRows Then
        pSetColumnValueInProperty oProperty, _
                                  Index, i, lCol, _
                                  vrInfo.NewValue(q), _
                                  Val(vrInfo.NewId(q))
      
        ClientGrid.ColumnAfterEdit KeyProp, i, lCol, _
                                   vrInfo.NewValue(q), _
                                   Val(vrInfo.NewId(q))
      End If
      
      ' Let client one chance to calculate columns
      ClientGrid.ColumnAfterUpdate KeyProp, i, lCol
      
      pSetRowValueInGrid Index, oProperty, i, iProperty.Grid.Rows(i)
    Next
        
  End If
  
End Function

' Multi
Private Function pAddVirtualRows(ByVal key As String, _
                                 ByVal lRow As Long, _
                                 ByVal lCol As Long, _
                                 ByRef iAddRows As Long, _
                                 ByRef vrInfo As cVirtualRowInfo) As Boolean
  If m_Client Is Nothing Then Exit Function
  
  vrInfo.key = key
  vrInfo.lRow = lRow
  vrInfo.lCol = lCol
  
  If m_Client.MessageEx(MSG_GRID_VIRTUAL_ROW, vrInfo) Then
  
    If vrInfo.bAddRows Then
  
      iAddRows = vrInfo.iAddRows
      pAddVirtualRows = True
      
    End If
  End If
  
End Function

Private Sub pGRColumnBeforeEdit(ByVal Index As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer, ByRef bCancel As Boolean)
  On Error GoTo ControlError
  
  If Not m_ImplementsClientGrid Then Exit Sub
  
  bCancel = False
    
  Dim oProperty   As cABMProperty
  Dim iProperty   As cIABMProperty
  Dim oGrid       As cGridAdvanced
  Dim Column      As cIABMGridColumn
  Dim c           As cGridColumn
  
  Set iProperty = GetProperty(cspGrid, Index, 0)
  
  If iProperty Is Nothing Then Exit Sub
  If lRow > iProperty.Grid.Rows.Count Then Exit Sub

  Set oProperty = iProperty
      
  Set oGrid = Frm.GR(oProperty.Index)
  Set Column = iProperty.Grid.Columns(lCol)
  Set c = oGrid.Columns(lCol)
  
  With iProperty.Grid.Rows.Item(lRow).Item(lCol)
    If .Format Is Nothing Then
      
      With c
      
        .EditType = Column.PropertyType
        .EditSubType = Column.SubType
        .Table = Column.Table
        .AllowEdit = Column.Enabled
        .Enabled = Column.Enabled
        bCancel = Not Column.Enabled
        .HelpFilter = Column.HelpFilter
        .HelpSPFilter = Column.HelpSPFilter
        .HelpSPInfoFilter = Column.HelpSPInfoFilter
        
        .Size = Column.Size
        .Format = Column.Format
        
        If Column.PropertyType = cspList Then
          .List = Column.List
        Else
          .List = Nothing
        End If
        
        If Column.SubType = cspPercent Then
          If Column.Format = vbNullString Then
            .Format = "0.00 %"
          End If
        End If
      End With
      
    Else
      
      c.EditType = .Format.PropertyType
      c.EditSubType = .Format.SubType
      c.Table = .Format.Table
      c.AllowEdit = .Format.Enabled
      c.Enabled = .Format.Enabled
      bCancel = Not .Format.Enabled
      c.HelpFilter = .Format.HelpFilter
      c.Size = .Format.Size
      c.Format = .Format.Format
      
      If .Format.PropertyType = cspList Then
        c.List = .Format.List
      Else
        c.List = Nothing
      End If
      
      If .Format.SubType = cspPercent Then
        If .Format.Format = vbNullString Then
          c.Format = "0.00 %"
        End If
      End If
    End If
  End With

  Exit Sub
ControlError:
  MngError Err, "pGRColumnBeforeEdit", C_Module, vbNullString
End Sub

Private Sub pGRColumnEdit(ByVal After As Boolean, ByVal Index As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer, ByVal NewValue As Variant, ByVal NewValueID As Long, bCancel As Boolean)
  On Error GoTo ControlError
  
  If m_ImplementsClientGrid Then
    
    Dim oProperty   As cABMProperty
    Dim iProperty   As cIABMProperty
    Dim KeyProp     As Integer
    Dim ClientGrid  As cIABMClientGrid

    Set oProperty = GetProperty(cspGrid, Index, 0)
    bCancel = False
    
    If Not oProperty Is Nothing Then
    
      KeyProp = pGetPropertyKey(oProperty)
      Set ClientGrid = m_Client
      
      If After Then
      
        ' If the row not exists we have to create it because the client need it to hold
        ' calculated data
        pCreateRowIfNotExists oProperty, Index, lRow
      
        If Not ClientGrid.ColumnAfterEdit(KeyProp, lRow, lCol, NewValue, NewValueID) Then
          bCancel = True
        End If
      
      Else
      
        If m_bCreateRowInBeforeEdit Then
          ' If the row not exists we have to create it because the client need it to hold
          ' calculated data
          pCreateRowIfNotExists oProperty, Index, lRow
        End If
      
        If Not ClientGrid.ColumnBeforeEdit(KeyProp, lRow, lCol, iKeyAscii) Then
          bCancel = True
        End If
      End If
      
    Else
      bCancel = True
    End If
  Else
    bCancel = True
  End If
  
  Exit Sub
ControlError:
  MngError Err, "pGRColumnEdit", C_Module, vbNullString
End Sub

Private Sub pGRColumnButtonClick(Index As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer, bCancel As Boolean)
  On Error GoTo ControlError
  
  If m_ImplementsClientGrid Then
    
    Dim oProperty   As cABMProperty
    Dim iProperty   As cIABMProperty
    Dim KeyProp     As Integer
    Dim ClientGrid  As cIABMClientGrid

    Set oProperty = GetProperty(cspGrid, Index, 0)
    bCancel = False
    
    If Not oProperty Is Nothing Then
    
      KeyProp = pGetPropertyKey(oProperty)
      Set ClientGrid = m_Client
      
      
      ' If the row not exists we have to create it because the client need it to hold
      ' calculated data
      pCreateRowIfNotExists oProperty, Index, lRow
    
      If Not ClientGrid.ColumnButtonClick(KeyProp, lRow, lCol, iKeyAscii) Then
        bCancel = True
      End If
      
      Set iProperty = oProperty
      
      ' Si se trata de una columna de tipo TextButtonEx
      '
      With iProperty.Grid
        If .Columns(lCol).SubType = cspTextButtonEx Then
          Dim rtn As String
          With .Rows.Item(lRow).Item(lCol)
            rtn = .Value
            If GetInputEx(rtn) Then
              .Value = rtn
            End If
          End With
        End If
      End With
      
      '
      ' bCancel es para informarle a la grilla que el button click se manejo por la clase
      ' ya sea true o false el codigo que sigue siempre se ejecuta
      '
      pSetRowValueInGrid Index, oProperty, lRow, iProperty.Grid.Rows(lRow)
      
      WasChanged = True
    
    Else
      bCancel = True
    End If
  Else
    bCancel = True
  End If
  
  Exit Sub
ControlError:
  MngError Err, "pGRColumnEdit", C_Module, vbNullString
End Sub

Private Sub pCreateRowIfNotExists(ByRef iProperty As cIABMProperty, _
                                  ByVal Index As Integer, _
                                  ByVal lRow As Long)
  Dim Row        As cIABMGridRow

  With iProperty.Grid.Rows
    Set Row = .Item(lRow)
    If Row Is Nothing Then
      Set Row = pCreateRow(Index, iProperty, lRow)
      .Add Row
    End If
  End With
End Sub

Private Sub pSetColumnValueInProperty(ByRef iProperty As cIABMProperty, _
                                      ByVal Index As Integer, _
                                      ByVal lRow As Long, _
                                      ByVal lCol As Long, _
                                      ByVal NewValue As Variant, _
                                      ByVal NewValueID As Long)
  Dim Row     As cIABMGridRow
  Dim iCell   As cIABMGridCellValue
  Dim oCell   As cABMGridRowValue
  Dim oProp   As cABMProperty
  Dim grd     As cGridAdvanced
  
  With iProperty.Grid.Rows

    Set Row = .Item(lRow)
    If Row Is Nothing Then
      Set Row = pCreateRow(Index, iProperty, lRow)
      .Add Row
    End If
    
    Set iCell = Row.Item(lCol)
    Set oCell = iCell
    
    With iCell
      .Id = NewValueID
      .Value = NewValue
    End With
    
    ' Si esto no funca mala leche :P
    '
    On Error Resume Next
    
    Set oProp = iProperty
    Set grd = oProp.ctl
    oCell.HelpValueProcess = grd.Cell(lRow, lCol).Tag
  End With
End Sub

Private Function pGRValidateRow(ByVal Index As Integer, ByVal RowIndex As Long, ByRef bCancel As Boolean, ByVal bAddRow As Boolean, ByRef bIsEmpty As Boolean) As Boolean
  Dim rtn As Boolean
  
  If m_ImplementsClientGrid Then
    
    Dim iProperty   As cIABMProperty
    Dim oProperty   As cABMProperty
    
    Set oProperty = GetProperty(cspGrid, Index, 0)
    bCancel = False
    
    If Not oProperty Is Nothing Then
    
      Dim ClientGrid  As cIABMClientGrid
      Dim iRow        As cIABMGridRow
      Dim oRow        As cABMGridRow
      Dim KeyProp     As String
      
      Set ClientGrid = m_Client
      KeyProp = pGetPropertyKey(oProperty)
      
      Set iRow = pCreateRow(Index, oProperty, RowIndex)
      
      If ClientGrid.IsEmptyRow(KeyProp, iRow, RowIndex) Then
        SendKeys "{TAB}"
        bCancel = True
        bIsEmpty = True
        
        ' La fila esta vacia asi que es valida
        rtn = True
        
      ' Let Client one chance to validate and modify row values
      ElseIf Not ClientGrid.ValidateRow(KeyProp, iRow, RowIndex) Then
        bCancel = True
        
        ' El cliente no valido la fila
        rtn = False
      Else
      
        ' La fila es valida
        rtn = True
        
        ' Put Client's values to Grid
        pSetRowValueInGrid Index, oProperty, RowIndex, iRow
        
        If bAddRow Then
          
          ' Keep updated the rows collection
          Set iProperty = oProperty
          
          Dim oRows As cABMGridRows
          
          Set oRows = iProperty.Grid.Rows
          
          With oRows
            
            .Remove RowIndex, False
            
            Set oRow = iRow
            oRow.Index = RowIndex
      
            .Add iRow
          
            If Not iRow.Item(c_keyRowItem) Is Nothing Then
              iRow.Item(c_keyRowItem).Value = RowIndex
            End If
          
          End With
          
          bCancel = Not iProperty.GridAdd
        Else
          bCancel = True
        End If
      End If
    
    Else
      bCancel = True
    End If
  Else
    bCancel = True
  End If
  
  pGRValidateRow = rtn
End Function

Private Sub pHLChange(ByVal Index As Integer)
  ChangeProperty cspHelp, Index, Frm.HL(Index)
  'ReLoadListAdHock
End Sub

Private Sub pMEChange(ByVal Index As Integer)
  ChangeProperty cspNumeric, Index, Frm.ME(Index)
  'ReLoadListAdHock
End Sub

Private Sub pMEDateChange(ByVal Index As Integer)
  Dim c As cMaskEdit
  
  Set c = Frm.MEFE(Index)

  If c.csType = csMkTime Then
    ChangeProperty cspTime, Index, c
  Else
    ChangeProperty cspDate, Index, c
  End If
  
  'ReLoadListAdHock
End Sub

Private Sub pOPClick(ByVal Index As Integer)
  ChangeProperty cspOption, Index, Frm.OP(Index)
  'ReLoadListAdHock
End Sub

Private Sub pTXButtonClick(Index As Integer, Cancel As Boolean)
  Dim iProp As cIABMProperty
  
  Set iProp = GetProperty(cspText, Index, 0)
  
  If iProp Is Nothing Then Exit Sub
  
  m_Client.MessageEx MSG_BUTTON_TEXT_CLICK, iProp
  
  If iProp.SubType = cspTextButtonEx Then
    Dim rtn As String
    With Frm.TX(Index)
      rtn = .Text
      If GetInputEx(rtn) Then
        .Text = rtn
      End If
    End With
  End If
  
End Sub

Private Sub pToolBarButtonClik(ByVal Button As MSComctlLib.Button)
  ChangeProperty cspToolBar, 0, Button
End Sub

Private Sub pTXChange(ByVal Index As Integer)
  ChangeProperty cspText, Index, Frm.TX(Index)
  'ReLoadListAdHock
End Sub

Private Sub pTXMChange(ByVal Index As Integer)
  ChangeProperty cspText, Index, Frm.TXM(Index), False, cspMemo
  'ReLoadListAdHock
End Sub

Private Sub pTXPasswordChange(ByVal Index As Integer)
  ChangeProperty cspPassword, Index, Frm.txPassword(Index)
  'ReLoadListAdHock
End Sub

Private Function pGetPropertyKey(ByVal oProperty As cABMProperty) As Integer
  Dim iProperty As cIABMProperty
  Set iProperty = oProperty
  pGetPropertyKey = iProperty.key
End Function

Private Function pGetKeyFromRowValue(ByVal Rows As cIABMGridRows, ByVal RowIndex As Long, ByVal iCol As Long) As String
  
  If Rows.Count < RowIndex Then Exit Function
  If Rows.Item(RowIndex).Count < iCol Then Exit Function
  
  Dim RowValue As cABMGridRowValue
  Set RowValue = Rows.Item(RowIndex).Item(iCol)
  If RowValue Is Nothing Then Exit Function
  pGetKeyFromRowValue = RowValue.strKey
End Function

Private Function pCreateRow(ByVal Index As Integer, ByVal iProperty As cIABMProperty, ByVal RowIndex As Long) As cIABMGridRow
  Dim Row       As cIABMGridRow
  Dim Col       As cIABMGridColumn
  Dim Cell      As cIABMGridCellValue
  Dim oCell     As cABMGridRowValue
  Dim ColIndex  As Long
  Dim sKey      As String
  
  Set Row = New cABMGridRow
  
  For Each Col In iProperty.Grid.Columns
    ColIndex = ColIndex + 1
    If ColIndex = 1 Then
      Set Cell = Row.Add(Nothing, c_keyRowItem)
    Else
      sKey = pGetKeyFromRowValue(iProperty.Grid.Rows, _
                                 RowIndex, _
                                 ColIndex)
      If LenB(sKey) Then
        Set Cell = Row.Add(Nothing, sKey)
      Else
        Set Cell = Row.Add(Nothing)
      End If
    End If
    
    With Frm.GR(Index).Cell(RowIndex, ColIndex)
      Cell.Id = .ItemData
      Set oCell = Cell
      oCell.HelpValueProcess = .Tag
      
      If Col.PropertyType = cspDate Then
        Cell.Value = GetDateValueForGridClient(.Text)
      
      ElseIf Col.SubType = cspPercent Then
        Cell.Value = Val(.Text) * 100
      
      Else
        Cell.Value = .Text
      End If
      
      Cell.key = Col.key
    End With
  Next
  
  Set pCreateRow = Row
End Function

Private Sub pSetRowValueInGrid(ByVal Index As Integer, _
                               ByVal iProperty As cIABMProperty, _
                               ByVal RowIndex As Long, _
                               ByRef Row As cIABMGridRow)
                               
  Dim Col       As cIABMGridColumn
  Dim Cell      As cIABMGridCellValue
  Dim ColIndex  As Long
  Dim oGrid     As cGridAdvanced
  Dim oRow      As cABMGridRow
  
  Dim oFormat   As cABMGridCellFormat
  Dim iFormat   As cIABMGridCellFormat
  Dim oFont     As StdFont
  
  Set oGrid = Frm.GR(Index)
  
  Set oRow = Row
  oGrid.RowBackColor(RowIndex) = oRow.BackColor
  oGrid.RowForeColor(RowIndex) = oRow.ForeColor
  
  For Each Col In iProperty.Grid.Columns
    ColIndex = ColIndex + 1
    Set Cell = Row.Item(ColIndex)
    
    With oGrid.Cell(RowIndex, ColIndex)
      oGrid.CellItemdata(RowIndex, ColIndex) = Cell.Id
      
      If Col.PropertyType = cspDate Then
        .Text = GetDateValueForGrid(Cell.Value)
      
      ElseIf Col.SubType = cspPercent Then
        .Text = Val(Cell.Value) / 100
      
      Else
        .Text = Cell.Value
      End If
    
      ' Formato de cada celda
      '
      Set iFormat = Cell.Format
      If Not iFormat Is Nothing Then
      
        Set oFormat = Cell.Format
       
        If Not iFormat.Enabled Or Not Col.Enabled Then
          .BackColor = vbButtonFace
          oFormat.Bold = True
        Else
          .BackColor = iFormat.BackColor
        End If
        
        .ForeColor = iFormat.Color
        
        .TextAlign = oFormat.Align
        Set oFont = New StdFont
        With oFont
          .Name = oFormat.FontName
          .Italic = oFormat.Italic
          .Bold = oFormat.Bold
          .Size = oFormat.FontSize
          .Strikethrough = oFormat.Strike
          .Underline = oFormat.Underline
        End With
        Set .Font = oFont
      
      Else
      
        If Not Col.Enabled And Not m_bNoChangeBackColorCell Then
          .BackColor = vbButtonFace
        End If
      
      End If
    
    End With
  Next
  
End Sub

Private Function ShowForm(ByVal TabIndex As Integer, Optional ByVal NoGrids As Boolean, Optional ByVal bSetFocus As Boolean = True) As Boolean
  Dim oProperty      As cABMProperty
  Dim iProperties    As cIABMProperties
  Dim iProperty      As cIABMProperty
  Dim Tabs           As Integer
  Dim Count          As Integer
  
  Set iProperties = m_Properties
  m_LabelLeft = C_offsetH
  
  For Each iProperty In iProperties
    If pGetTabIndex(iProperty) > Tabs Then Tabs = pGetTabIndex(iProperty)
  Next
  
  ShowTabs Tabs
  
  m_ShowingForm = True
  m_TabIndex = 0
  
  For Each oProperty In iProperties
    LoadControlEx oProperty, NoGrids
  Next
  
  m_ShowingForm = False
  
  With Frm
  
    Count = .Controls.Count
  
    If Not m_IsDocument Then
      If m_IsWizard Then
        .cmdNext.TabIndex = Count
        .cmdCancel.TabIndex = Count
        .cmdBack.TabIndex = Count
      Else
        .cmdSave.TabIndex = Count
        .cmdCancel.TabIndex = Count
        .cmdClose.TabIndex = Count
      End If
    End If
    
    If TabIndex <> -1 Then
      If m_IsDocument Then
        pDocTabClickEx c_Items, TabIndex
        pDocTabClickEx c_Footer, TabIndex
        pDocTabClickEx c_Header, TabIndex
        .cbTab(TabIndex + m_FirstTab).TabSelected = True
      Else
        TabClick TabIndex
        .cbTab(TabIndex).TabSelected = True
      End If
    End If
    
    If bSetFocus Then .SetFocusFirstControl
  End With
  
  ShowForm = True
End Function

Private Function LoadControl(ByRef oProperty As cABMProperty) As Boolean
  Dim c As Control
  Dim f As Control
  Dim iProperty As cIABMProperty
  
  Dim iProperties    As cIABMProperties
  Dim oProp          As cABMProperty
  Dim oGrid          As cABMGrid
  
  Set iProperty = oProperty
  
  Dim nTabIndex As Long
  nTabIndex = pGetTabIndex(iProperty)
  
  With Frm
    Select Case iProperty.PropertyType
'      Case csTypeABMProperty.cspAdHock
'        If m_bLoadAdHock Then
'          Load .CBhock(.CBhock.UBound + 1)
'        Else
'          m_bLoadAdHock = True
'        End If
'
'        Set c = .CBhock(.CBhock.UBound)
'        pSetFont c, iProperty
        
      Case csTypeABMProperty.cspList
        If m_bLoadList Then
          Load .CB(.CB.UBound + 1)
        Else
          m_bLoadList = True
        End If
        
        Set c = .CB(.CB.UBound)
        pSetFont c, iProperty
        
      Case csTypeABMProperty.cspHelp
        If m_bLoadHelp Then
          Load .HL(.HL.UBound + 1)
        Else
          m_bLoadHelp = True
        End If
        
        Set c = .HL(.HL.UBound)
        c.HelpType = oProperty.HelpType
        c.ForAbm = oProperty.IsForAbm
        c.Table = iProperty.Table
        c.ButtonStyle = cHelpButtonSingle
        c.SPFilter = iProperty.HelpSPFilter
        c.SPInfoFilter = iProperty.HelpSPInfoFilter
        c.Reset
        pSetFont c, iProperty
        
      Case csTypeABMProperty.cspNumeric
        If m_bLoadNumeric Then
          Load .ME(.ME.UBound + 1)
        Else
          m_bLoadNumeric = True
        End If
        
        Set c = .ME(.ME.UBound)
        c.csType = iProperty.SubType
        If iProperty.SubType = 0 Then
          Err.Raise csErrorABMLoadControlSubTypeNotDefined, "CSABMInterface.LoadControl", "Error al cargar controles en ABM Generico. No se ha indicado un subnType para la propiedad numerica: " & iProperty.Name
        End If
        
        If m_IsFooter Then
          c.Width = 1100
          c.BackColor = .shTabFooter.BackColor
          c.EnabledNoChngBkColor = True
        End If
        pSetFont c, iProperty
        c.FormatNumber = iProperty.Format
        
      Case csTypeABMProperty.cspDate, csTypeABMProperty.cspTime
        If m_bLoadDate Then
          Load .MEFE(.MEFE.UBound + 1)
        Else
          m_bLoadDate = True
        End If
        
        Set c = .MEFE(.MEFE.UBound)
        If iProperty.PropertyType = csTypeABMProperty.cspDate Then
          c.csType = csMkDate
        Else 'csTypeABMProperty.cspTime
          c.csType = csMkTime
        End If
        pSetFont c, iProperty
        
      Case csTypeABMProperty.cspOption
        Set f = .FR(iProperty.OptionGroup)
        
        With f
          If Not .Tag <> vbNullString Then
            .Top = m_NextTop(nTabIndex)
            .Left = m_Left(nTabIndex)
            .Visible = True
            .Tag = iProperty.TabIndex
          End If
        End With
        
        Load .OP(.OP.UBound + 1)
        Set c = .OP(.OP.UBound)
        
      
      Case csTypeABMProperty.cspLabel
        If m_bLoadLabel Then
          Load .LB2(.LB2.UBound + 1)
        Else
          m_bLoadLabel = True
        End If
        
        Set c = .LB2(.LB2.UBound)
        pSetFont c, iProperty
        If iProperty.BackColor <> -1 Then
          c.BackStyle = 1
        Else
          c.BackStyle = 0
        End If
        c.Alignment = iProperty.TextAlign
        
      Case csTypeABMProperty.cspTitle
        If m_bLoadTitle Then
          Load .lbTitle2(.lbTitle2.UBound + 1)
        Else
          m_bLoadTitle = True
        End If
        
        Set c = .lbTitle2(.lbTitle2.UBound)
        pSetFont c, iProperty
        
      Case csTypeABMProperty.cspProgressBar
        If m_bLoadProgressBar Then
          Load .prgBar(.prgBar.UBound + 1)
        Else
          m_bLoadProgressBar = True
        End If
        
        Set c = .prgBar(.prgBar.UBound)
      
      Case csTypeABMProperty.cspDescription
        If m_bLoadDescription Then
          Load .LBDescrip(.LBDescrip.UBound + 1)
        Else
          m_bLoadDescription = True
        End If
        
        Set c = .LBDescrip(.LBDescrip.UBound)
        pSetFont c, iProperty
        
      Case csTypeABMProperty.cspImage
        If m_bLoadImage Then
          Load .Img(.Img.UBound + 1)
        Else
          m_bLoadImage = True
        End If
        
        Set c = .Img(.Img.UBound)
      
      Case csTypeABMProperty.cspText
        
        If iProperty.SubType = CSConstantes.cspMemo Then
          If m_bLoadTextM Then
            Load .TXM(.TXM.UBound + 1)
          Else
            m_bLoadTextM = True
          End If
          
          Set c = .TXM(.TXM.UBound)
        
        Else
          If m_bLoadText Then
            Load .TX(.TX.UBound + 1)
            .TX(.TX.UBound).Width = m_TextOrigWidth
          Else
            m_bLoadText = True
          End If
          
          Set c = .TX(.TX.UBound)
          If TypeOf c Is cMaskEdit Then
            c.ButtonStyle = IIf(iProperty.SubType = cspTextButton _
                             Or iProperty.SubType = cspTextButtonEx, _
                                cButtonSingle, cButtonNone)
            c.Mask = iProperty.TextMask
            c.csType = csMkText
          End If
          c.PasswordChar = vbNullString
        End If
        
        c.MaxLength = iProperty.Size
        c.Alignment = iProperty.TextAlign
        
        ' Para soportar cajas multinline
        ' que permiten desplazarce con las flechas
        ' entre renglones, pero no aceptan edicion
        '
        c.InputDisabled = oProperty.InputDisabled
        
        pSetFont c, iProperty
        
      Case csTypeABMProperty.cspFile
        If m_bLoadText Then
          Load .TX(.TX.UBound + 1)
        Else
          m_bLoadText = True
        End If
        
        Set c = .TX(.TX.UBound)
        With c
          .MaxLength = iProperty.Size
          .csType = CSMaskEdit2.csMkFile
          .FileFilter = iProperty.HelpFilter
          .PasswordChar = vbNullString
        End With
        pSetFont c, iProperty
        
      Case csTypeABMProperty.cspFolder
        If m_bLoadText Then
          Load .TX(.TX.UBound + 1)
        Else
          m_bLoadText = True
        End If
        
        Set c = .TX(.TX.UBound)
        With c
          .MaxLength = iProperty.Size
          .csType = CSMaskEdit2.csMkFolder
          .PasswordChar = vbNullString
        End With
        pSetFont c, iProperty
        
      Case csTypeABMProperty.cspPassword
        If m_bLoadPassword Then
          Load .txPassword(.txPassword.UBound + 1)
        Else
          m_bLoadPassword = True
        End If
        
        Set c = .txPassword(.txPassword.UBound)
        c.ButtonStyle = cButtonNone
        c.PasswordChar = "*"
        pSetFont c, iProperty
        
      Case csTypeABMProperty.cspCheck
        If m_bLoadCheck Then
          Load .CHK(.CHK.UBound + 1)
        Else
          m_bLoadCheck = True
        End If
        
        Set c = .CHK(.CHK.UBound)
        c.Caption = "  "
        c.Width = 400
        
      Case csTypeABMProperty.cspGrid
        If m_bLoadGrid Then
          Load .GR(.GR.UBound + 1)
        Else
          m_bLoadGrid = True
        End If
        
        Set c = .GR(.GR.UBound)
        c.Editable = iProperty.GridEdit
        MngGrid.SetPropertys c
        
        Set oGrid = iProperty.Grid
        c.DontSelectInGotFocus = oGrid.DontSelectInGotFocus
        
        ' Formatos adicionales a la interfaz cIABMGrid
        c.RowMode = oGrid.RowSelect
        
      Case csTypeABMProperty.cspButton
        If m_bLoadButton Then
          Load .CMD(.CMD.UBound + 1)
        Else
          m_bLoadButton = True
        End If
        
        Set c = .CMD(.CMD.UBound)
        pSetFont c, iProperty
        
      Case csTypeABMProperty.cspToolBar
        Dim FrameToolBar As Frame
        Set c = pLoadToolBar(oProperty, FrameToolBar)
        
        With FrameToolBar
          .BorderStyle = 0
        End With
      
        With c
          .Top = 0
          .Left = 0
          .Appearance = ccFlat
        End With
        
        Set oProperty.Toolbar = c
    End Select
    
    If iProperty.PropertyType <> csTypeABMProperty.cspToolBar Then
      oProperty.Index = c.Index
    End If
  End With
  
  pSetTabIndex c
  m_TabIndex = m_TabIndex + 1
  
  Set oProperty.ctl = c
  
  ' Aplico formateos personalizados
  If iProperty.Height > 0 Then
    c.Height = iProperty.Height
  End If
  
  If iProperty.Width > 0 Then
    c.Width = iProperty.Width
  End If
  
  ' Si se indica un top en funcion de una propiedad
  If iProperty.TopFromProperty <> vbNullString Then
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
  If iProperty.LeftFromProperty <> vbNullString Then
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
  
  With Frm
  
    If m_IsItems Then
    
      With .shTabItems
        If m_NextTop(nTabIndex) + c.Height > .Top + .Height - 50 Then
          SetNewTopAndLeft iProperty
        End If
      End With
      
    ElseIf m_IsFooter Then
    
      With .shTabFooter
        If m_NextTop(nTabIndex) + c.Height > .Top + .Height Then
          SetNewTopAndLeft iProperty
        End If
      End With
    
    Else
      If m_NextTop(nTabIndex) + c.Height + c_LineLight + 50 > .Line1.Y1 Then
        SetNewTopAndLeft iProperty
      End If
    End If
  End With
  
  With c
    If m_IsDocument Then
      If m_IsItems Then
        .Tag = c_Items & iProperty.TabIndex
      ElseIf m_IsFooter Then
        .Tag = c_Footer & iProperty.TabIndex
      Else
        .Tag = c_Header & iProperty.TabIndex
      End If
    Else
      If oProperty.TabIndex Then
        .Tag = oProperty.TabIndex
      Else
        .Tag = iProperty.TabIndex
      End If
    End If
    
    .Enabled = iProperty.Enabled
    pSetBackColor c, iProperty
    pSetButton c, oProperty
  End With
  
  With iProperty
    If .PropertyType = cspOption Then
      Dim r As Integer
      Dim q As Integer
      If .OptionGroup - 1 > UBound(m_LeftOp) Then
        r = UBound(m_LeftOp)
        ReDim Preserve m_LeftOp(.OptionGroup)
        With Frm
          For q = r To UBound(m_LeftOp)
            m_LeftOp(q) = .OP(0).Left
          Next
        End With
      End If
      If .OptionGroup - 1 > UBound(m_NextTopOp) Then
        r = UBound(m_NextTopOp)
        ReDim Preserve m_NextTopOp(.OptionGroup)
        With Frm
          For q = r To UBound(m_NextTopOp)
            m_NextTopOp(q) = .OP(0).Top
          Next
        End With
      End If
      
      If .Left = -1 Then
        c.Left = m_LeftOp(.OptionGroup)
      End If
      If .Top = -1 Then
        c.Top = m_NextTopOp(.OptionGroup)
      End If
      If .Width = 0 Then
        c.Width = 1500
      End If
      c.Caption = .Name
      
      ' Agrando el Frame
      If c.Top + c.Height > f.Height Then f.Height = c.Top + c.Height + 50
      
      If f.Height + f.Top > Frm.Line1.Y1 Then
        f.Top = m_NextTop(nTabIndex) - 100
        f.Left = m_Left(nTabIndex)
      End If
      
      If c.Left + c.Width > f.Width Then f.Width = c.Left + c.Width + 20
      
      If .TopFrame <> 0 Then f.Top = .TopFrame
      If .LeftFrame <> 0 Then f.Left = .LeftFrame
      
      m_NextTopOp(.OptionGroup) = m_NextTopOp(.OptionGroup) + c_LineHeight
    
    ElseIf .PropertyType = cspToolBar Then
        
      With FrameToolBar
        .Width = iProperty.Width
        .Top = iProperty.TopFrame
        .Left = iProperty.LeftFrame
        If iProperty.Height > 0 Then
          .Height = iProperty.Height
        Else
          .Height = c.Height
        End If
        .Tag = iProperty.TabIndex
        .BackColor = Frm.ShTab.BackColor
      End With
      
      Dim Tbl As Toolbar
      
      Set Tbl = c
      With Tbl
        .Appearance = cc3D
        .BorderStyle = ccFixedSingle
      End With
      
      CSKernelClient2.SetToolbar Tbl, .Buttons
      
      .LeftNotChange = True
      .TopNotChange = True
    
    ElseIf .PropertyType = cspLabel Or .PropertyType = cspTitle Or .PropertyType = cspDescription Then
      
      If .Top = -1 Then
        c.Top = m_NextTop(nTabIndex)
      End If
      
      If .Left = -1 Then
        c.Left = m_Left(nTabIndex) + m_LabelLeft
      End If
    
    Else
        
        Dim LB As Label
        
        With Frm
          Load .LB(.LB.UBound + 1)
          Set LB = .LB(.LB.UBound)
        End With
        
        With LB
          oProperty.LabelIndex = .Index
          .Caption = iProperty.Name
          .Left = m_Left(nTabIndex)
          .BackStyle = 0
          .Tag = c.Tag
          .ZOrder
          If iProperty.PropertyType = cspButton Then
            .Visible = False
          End If
        End With
        
        ' Etiquetas invisibles
        ' para Grillas, Botones e Imagenes
        '
        If .LeftLabel = -1 Then
          With LB
            .Visible = False
            .Tag = "-1" ' Si una etiqueta tiene tag=-1
                        ' no se modifica su propiedad
                        ' visible en el ShowValue
          End With
        End If
    
        ' Formateo especial para Grids
        If .PropertyType = cspGrid Then
          If .Left = -1 Then
            c.Left = m_Left(nTabIndex)
          End If
          
          If m_IsItems Then
            c.Top = m_NextTop(nTabIndex)
            With LB
              .Visible = False
              .Tag = "-1" ' Si una etiqueta tiene tag=-1
                          ' no se modifica su propiedad
                          ' visible en el ShowValue
            End With
          Else
            If .Top = 0 Then
              c.Top = m_NextTop(nTabIndex) + 300
              With LB
                .Top = m_NextTop(nTabIndex)
                .Width = c.Width
              End With
            End If
          End If
          If .Width = -1 Or .Width = 0 Then
            c.Width = Frm.ScaleWidth - c.Left - 300
          End If
        
        ElseIf m_IsDocument And .Table = csDocumento Then
          
          With c
            .Left = 3600
            .Top = 80
            .Width = 3500
            .FontSize = 11
            .FontBold = True
            .Height = 330
            .Tag = vbNullString
            .BorderColor = vbButtonFace
          End With
          
          With LB
            .Visible = False
            .Tag = -1
          End With
          
        ElseIf m_IsDocument _
               And (oProperty.KeyCol = csNumberID _
                    Or oProperty.KeyCol = csStateID) Then
          
          If oProperty.KeyCol = csNumberID Then
            c.Left = 7300
            c.Width = 1200
          Else
            c.Left = 8700
            c.Width = 3000
          End If
          c.Top = 80
          c.FontSize = 11
          c.FontBold = True
          c.Height = 330
          c.EnabledNoChngBkColor = True
          c.ForeColor = vbWhite
          c.BackColor = vbButtonShadow
          c.BorderColor = vbButtonFace
          LB.Visible = False
          LB.Tag = -1
          c.Tag = vbNullString
          
        Else
        
          If .Top <> -1 Then
          
            LB.Top = .Top
          Else
                                                            ' OptionGroup la uso para indicar un offset cuando la
                                                            ' oProperty no es de nType Option sirve para permitir un
                                                            ' posicionamiento mas fino de los controles. Solo se usa en
                                                            ' cuenta.
            LB.Top = m_NextTop(nTabIndex) + .OptionGroup
    
                                                            ' OptionGroup la uso para indicar un offset cuando la
                                                            ' oProperty no es de nType Option sirve para permitir un
                                                            ' posicionamiento mas fino de los controles. Solo se usa en
                                                            ' cuenta.
            c.Top = m_NextTop(nTabIndex) + .OptionGroup
          End If
        
          Select Case .PropertyType
            Case csTypeABMProperty.cspDate
              c.Width = 1400
            Case csTypeABMProperty.cspTime
              c.Width = 800
          End Select
  
          If m_IsFooter Then
            If .Left = -1 Then
              c.Left = m_Left(nTabIndex)
            End If
            With LB
              .Left = c.Left
              .Top = c.Top - C_offsetV3
              .Height = 225
              .Alignment = vbRightJustify
              .Width = 1000
            End With
          Else
            If .Left <> -1 Then
              LB.Left = c.Left + .LeftLabel
              LB.Width = Abs(.LeftLabel)
            Else
              c.Left = m_Left(nTabIndex) + m_LabelLeft
              If .LeftLabel <> 0 Then
                LB.Left = c.Left + .LeftLabel
                LB.Width = Abs(.LeftLabel)
              End If
            End If
          End If
        
        End If
    End If
    
    ' Me guardo el Top y el Left de esta propiedad
    With oProperty
      .Top = c.Top
      .Left = c.Left
      .Width = c.Width
      .Height = c.Height
    End With
    
    ' Si el control modifica el Left de los que vienen detras
    If Not .LeftNotChange Then
    
      ' Si fue un option button hay que fijarce en el contenedor
      If .PropertyType = cspOption Then
        If .LeftFrame <> 0 And Not .LeftNotChange Then
          m_Left(nTabIndex) = f.Left
        End If
      Else
        ' Si el control indico un left fijo, los demas se alinean con el
        If .Left <> -1 And .LeftToPrevious = 0 Then
          m_Left(nTabIndex) = .Left + .LeftLabel
          m_LabelLeft = Abs(.LeftLabel)
        End If
      End If
    End If
    
    ' Me guardo el ultimo Left
    m_LastLeft = m_Left(nTabIndex)
    m_LastLeftOp = c.Left
    
    ' Me guardo el ultimo Top
    m_LastTop = m_NextTop(nTabIndex)
    m_LastTopOp = c.Top
    
    ' Ahora hay que calcular donde empieza el renglo para el proximo control
    
    ' Si el control modifica el Top para los que vienen detras
    If Not .TopNotChange Then
      ' Si el control tiene un top personalizado entonces
      ' parto de dicho top para el calculo. Siempre y cuando no sea un OptionButton
      If .Top <> -1 And .PropertyType <> cspOption And Not .TopNotChange Then
        
        m_LastTop = .Top
        
        ' Si el control inidica un alto personalizado
        If .Height > 0 Then
          m_NextTop(nTabIndex) = .Top + c.Height + c_LineLight
        Else
          m_NextTop(nTabIndex) = .Top + c_LineHeight
        End If
      Else
        ' Si el control inidica un alto personalizado. Siempre y cuando no sea un OptionButton
        If .Height > 0 And .PropertyType <> cspOption Then
          m_NextTop(nTabIndex) = m_NextTop(nTabIndex) + c.Height + c_LineLight
          
        ' Si se uso el alto standar (c_LineHeight)
        Else
          '
          ' Siempre incremento el NextTop general incluso si es una oProperty de nType option o Grid
          ' ya que por cada option que exista se agrega un renglo de c_LineHeight y eso es correcto.
          ' En el caso de las Grids no trabaja bien, pero como por ahora solo hay una Grid por tab,
          ' no trae ningun problema.
          '
          ' Aunque hay una excepcion: Cuando se trata de documentos el help de documento va en la barra de titulo
          If Not (m_IsDocument And _
                              (.Table = csDocumento _
                              Or oProperty.KeyCol = csNumberID _
                              Or oProperty.KeyCol = csStateID)) Then
            m_NextTop(nTabIndex) = m_NextTop(nTabIndex) + c_LineHeight
          End If
        End If
      End If
    End If
    
    ' Finalmente valido el ancho del form
    If .PropertyType = cspOption Then
      SetNewWidthForm iProperty, f.Width + f.Left
    Else
      SetNewWidthForm iProperty, 0
    End If
  End With
  
  LoadControl = True
End Function

Private Sub SetNewTopAndLeft(ByRef iProperty As cIABMProperty)
  Dim nTabIndex   As Long
  
  nTabIndex = pGetTabIndex(iProperty)
  
  With Frm
    If m_IsItems Then
      m_NextTop(nTabIndex) = .shTabItems.Top + 100
      m_Left(nTabIndex) = m_Left(nTabIndex) + C_offsetH2
      
    ElseIf m_IsFooter Then
      m_NextTop(nTabIndex) = .shTabFooter.Top + C_offsetV1
      m_Left(nTabIndex) = m_Left(nTabIndex) + C_offsetH3
      
    Else
      m_NextTop(nTabIndex) = m_constTop
      m_Left(nTabIndex) = m_Left(nTabIndex) + C_offsetH2
    End If
  End With
  
End Sub

Private Sub pSetTabIndex(ByRef c As Object)
  On Error Resume Next
  c.TabIndex = m_TabIndex
End Sub

Private Sub SetNewWidthForm(ByRef oProp As cABMProperty, ByVal FrameSize As Integer)
  
  On Error Resume Next
  
  Dim offsetH As Integer
  Dim iProp   As cIABMProperty
  
  Set iProp = oProp
  
  With Frm
    If .ShTab.Left = 0 Then
      offsetH = 120
    Else
      offsetH = 400
    End If
    
    If FrameSize > 0 Then
      If .Width < FrameSize + offsetH Then
        .Width = FrameSize + offsetH
        .ShTab.Width = .ScaleWidth - .ShTab.Left * 2
      End If
    Else
      If .Width < oProp.Width + oProp.Left + offsetH Then
        .Width = oProp.Width + oProp.Left + offsetH
      End If
      .ShTab.Width = .ScaleWidth - .ShTab.Left * 2
    End If
  End With
End Sub

Private Function GetProperty(ByVal nType As csTypeABMProperty, ByVal Index As Integer, ByVal SubType As csSubTypeABMProperty) As cABMProperty
  Dim iProperty   As cIABMProperty
  Dim oProperty   As cABMProperty
  Dim iProperties As cIABMProperties
  Dim Found       As Boolean
  
  If m_Properties Is Nothing Then Exit Function
  
  Set iProperties = m_Properties
  
  ' Para Toolbars no hay indice
  If nType = cspToolBar Then
    Dim Tbl As Toolbar
    
    Set Tbl = Frm.GetToolBar
    For Each iProperty In iProperties
      Set oProperty = iProperty
      If iProperty.PropertyType = nType Then
        If oProperty.Toolbar Is Tbl Then
          Set GetProperty = oProperty
          Exit For
        End If
      End If
    Next
  
  Else
    For Each iProperty In iProperties
    
      With iProperty
    
        Found = False
        
        ' Tratamiento especial para textos que
        ' tambien pueden ser carpetas o archivos
        If nType = cspText Then
        
          If .PropertyType = cspText And SubType = cspMemo Then
            If .SubType = SubType Then
              Found = True
            End If
          Else
          
            ' Los textbox y los cspFile y cspFolder estan dentro
            ' del mismo arreglo de controles ( TX )
            '
            If (.PropertyType = cspText _
                Or .PropertyType = cspFile _
                Or .PropertyType = cspFolder _
               ) And .SubType <> cspMemo And .SubType = SubType Then
               
              Found = True
              
            ' Finalmente puede tratarse de una caja de texto
            ' con boton asi que SubType es cspTextButton o cspTextButtonEx
            ' pero cuando me llaman desde TxButtonClick me pasan 0 en
            ' SubType ya que puede ser un cspFile, cspFolder o cspText
            ' asi que este ultimo if captura los textbox que tienen boton
            ' normalmente descripciones en controles de una linea
            ' o cajas de texto con boton que se resuelve por la clase
            ' cliente que maneja las reglas de negocio de esta edicion.
            '
            ElseIf (.PropertyType = cspText _
                     And (.SubType = cspTextButton _
                          Or .SubType = cspTextButtonEx)) Then
            
              Found = True
              
            End If
          End If
        Else
          If .PropertyType = nType Then
            Found = True
          End If
        End If
        
        ' Ok, encontre una propiedad del mismo
        ' tipo, pero ahora tengo que ver que se
        ' trata del control que estoy buscando
        ' ya que puede haber mas de un control
        ' de este tipo en el form.
        '
        ' Para identificar la propiedad usamos
        ' el indice del control.
        '
        If Found Then
          Set oProperty = iProperty
        
          If oProperty.Index = Index Then
            Set GetProperty = oProperty
            Exit For
          End If
        End If
      End With
    Next
  End If
End Function

Private Function ChangeProperty(ByVal nType As csTypeABMProperty, _
                                ByVal Index As Integer, _
                                ByRef c As Object, _
                                Optional ByVal bNoRefresh As Boolean, _
                                Optional ByVal SubType As csSubTypeABMProperty = 0) As Boolean
  On Error GoTo ControlError
  
  Dim iProperty   As cIABMProperty
  Dim iProperty2  As cIABMProperty
  Dim oProperty   As cABMProperty
  Dim iProperties As cIABMProperties
  
  Static Refreshing As Boolean
  
  If Refreshing Or m_ShowingForm Then
    Refreshing = False
    ChangeProperty = True
    Exit Function
  End If
                
  Set oProperty = GetProperty(nType, Index, SubType)
  
  Set iProperties = m_Properties
                
  If Not oProperty Is Nothing Then
    
    Set iProperty = oProperty
    
    With iProperty
      Select Case nType
        'Case csTypeABMProperty.cspAdHock, csTypeABMProperty.cspList
        Case csTypeABMProperty.cspList
          .ListListIndex = c.ListIndex
          .ListText = c.Text
          If c.ListIndex >= 0 Then
            .ListItemData = c.ItemData(c.ListIndex)
          Else
            .ListItemData = 0
          End If
        Case csTypeABMProperty.cspText, csTypeABMProperty.cspPassword, csTypeABMProperty.cspFile, csTypeABMProperty.cspFolder
          .Value = c.Text
        Case csTypeABMProperty.cspNumeric
          .Value = c.csValue
        Case csTypeABMProperty.cspDate, csTypeABMProperty.cspTime
          .Value = c.csValue
        Case csTypeABMProperty.cspOption
          
          If c.Value Then
            ' Aca hay que cambiar al resto de las Properties de este Group de
            ' option buttons
            For Each iProperty2 In iProperties
              If Not iProperty2 Is iProperty Then
                If iProperty2.PropertyType = cspOption And iProperty2.OptionGroup = .OptionGroup Then
                  iProperty2.Value = 0
                End If
              End If
            Next
          End If
          
          .Value = c.Value
        Case csTypeABMProperty.cspHelp
          .Value = c.ValueUser
          .HelpId = Val(c.Id)
          .HelpValueProcess = c.Id
        Case csTypeABMProperty.cspCheck
          .Value = c.Value
        Case csTypeABMProperty.cspToolBar
          .Value = c.key
      End Select
      
      If m_Client.PropertyChange(.key) And Not bNoRefresh Then
        Refreshing = True
        For Each iProperty In iProperties
          ShowValue iProperty, m_bNoChangeColsInRefresh
        Next
      End If
    End With
  End If
  
  If Not pIsButton(iProperty) And pIsEditProperty(iProperty) Then
  
    If m_IsDocument Then
      If Not iProperty Is Nothing Then
        If iProperty.Table <> csDocumento Then
          WasChanged = True
        End If
      End If
    Else
      WasChanged = True
    End If
  End If
  
  Refreshing = False
  ChangeProperty = True
  
  ' Si es un ABM de maestros
  ' permitimos al objeto de negocios
  ' que indique se debe cerrar el form
  '
  If Not m_FormABM Is Nothing Then
    If m_bSendSave Then
      m_FormABM.CtrlKeySave
    ElseIf m_bSendClose Then
      m_FormABM.CtrlKeyClose
    End If
  End If
  
  Exit Function
ControlError:
  MngError Err, "ChangeProperty", C_Module, vbNullString
End Function

Private Function pIsButton(ByRef iProp As cIABMProperty) As Boolean
  If iProp Is Nothing Then Exit Function
  pIsButton = iProp.PropertyType = cspButton
End Function

Private Function pIsEditProperty(ByRef iProp As cABMProperty) As Boolean
  If iProp Is Nothing Then Exit Function
  pIsEditProperty = iProp.IsEditProperty
End Function

Public Function ValidateEx() As Boolean
  If Not pFillGrids() Then Exit Function
  If Not pValidate() Then Exit Function
  ValidateEx = True
End Function

Public Sub ValidateProp(ByRef iProp As cIABMProperty, _
                        ByVal strKey As String)
  Dim oProp  As cABMProperty
  Dim iProps As cIABMProperties
  
  If iProp Is Nothing Then
    Set iProps = m_Properties
    Set oProp = iProps.Item(strKey)
  Else
    Set oProp = iProp
  End If
  
  If Not TypeOf oProp.ctl Is cshelp2.cHelp Then Exit Sub
  
  Dim HL As cshelp2.cHelp
  Set HL = oProp.ctl
  HL.Validate
End Sub

Private Function pValidateItemsAndFooter() As Boolean
  Dim GenDocEx As cABMGeneric
  
  If m_IsDocument Then
  
    Set GenDocEx = m_Client.MessageEx(MSG_DOC_EX_GET_ITEMS, Nothing)
    If Not GenDocEx.ValidateEx() Then Exit Function
    
    Set GenDocEx = m_Client.MessageEx(MSG_DOC_EX_GET_FOOTERS, Nothing)
    pValidateItemsAndFooter = GenDocEx.ValidateEx()
    
  Else
    pValidateItemsAndFooter = True
  End If
End Function

' Solo guarda si hubo cambios y el usuario los quiere guardar
'
Public Function SaveChanges() As Boolean
  SaveChanges = pSaveChanges(False, False)
End Function

Public Function Save() As Boolean
  Save = pSave(False, False)
  If m_bOkCancelDialog Then
    m_bOkCancelDialogRslt = True
    If TypeOf Frm Is fABM Then
      m_FormABM_cmdCloseClick
    ElseIf TypeOf Frm Is fABMDoc Then
      pFormDocClose
    ElseIf TypeOf Frm Is fWizard Then
      m_FormWizard_cmdCancelClick
    End If
  End If
End Function

Private Function pSave(ByVal bUnloading As Boolean, ByVal bSaveAs As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Not m_IsDocument Then

    Dim lockwnd As cLockUpdateWindow

    If Not m_bNotLockWnd Then
      Set lockwnd = New cLockUpdateWindow
      lockwnd.LockW Frm.hWnd
    End If
  End If
  
  If m_IsItems Then Exit Function
  If m_IsFooter Then Exit Function
  
  m_InSave = True
  
  Dim mouse As cMouseWait
  Set mouse = New cMouseWait
  
  pRefreshAux
  pFillList
  
  If Not pFillGrids() Then GoTo ExitProc
  
  ' OJO: Esto se cambio de lugar y se puso antes
  '      de los validate para que no se de el bug
  '      de click en los checkbox de las grillas
  '      que afectaba los abm de cliente y proveedor
  '
  '      Si notamos que hay algun bug nuevo este es
  '      nuestro sospechoso de siempre!!!
  '
  If Not m_IsDocument Then
    pSetEnabled False
  End If
  
  ' Only for debug
  '
    'Dim iProperties As cIABMProperties
    'Set iProperties = m_Properties
    'Dim row As cABMGridRow
    
    'Set row = iProperties.Item("Items").grid.Rows.Item(1)
  '
  ' Comentar despues de depurar
  
  ' Para informarle al documento que comienza
  ' la serie de llamadas de validacion
  ' Esto es necesario en OrdenDeServicio para no
  ' preguntar tres veces por cada Validate, si
  ' se el usuario acepta el reingreso o no
  '
  If m_IsDocument Then
    m_Client.MessageEx MSG_DOC_EX_PRE_VALIDATE, Nothing
  End If
  
  If Not pValidate() Then
    If Not m_IsDocument Then
      pSetEnabled True
    End If
    GoTo ExitProc
  End If
    
  If Not pValidateItemsAndFooter() Then
    If Not m_IsDocument Then
      pSetEnabled True
    End If
    GoTo ExitProc
  End If
  
  ' Grabacion normal de un documento
  '
  If Not bSaveAs Then
    
    If Not m_Client.Save() Then
      If Not m_IsDocument Then
        pSetEnabled True
      End If
      GoTo ExitProc
    End If
  
  Else
  
    ' Grabacion Como que permite que un documento
    ' se guarde como otra cosa, util para convertir
    ' una factura en un presupuesto
    '
    If Not m_Client.MessageEx(MSG_SAVE_AS, Nothing) Then
      If Not m_IsDocument Then
        pSetEnabled True
      End If
      GoTo ExitProc
    End If
  
  End If
  
  If Not m_IsDocument Then
    pSetEnabled True
  End If
  
  If Not bUnloading Then
  
    If Not m_IsDocument _
       And Not m_bSendRefresh _
       And Not m_bOkCancelDialog Then
       
      pDiscardChanges False
    Else
      m_Client.MessageEx MSG_DOC_REFRESH, Nothing
      If Not m_IsDocument Then
        pRefreshTitle
      End If
      Frm.SetFocusFirstControl
    End If
  End If
  
  WasChanged = False
  pSave = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "pSave", C_Module, vbNullString
  
ExitProc:
  m_InSave = False
End Function

Private Sub pFillList()
  Dim iProperty   As cIABMProperty
  Dim oProperty   As cABMProperty
  Dim iProperties As cIABMProperties
  Dim Index       As Integer
  
  Set iProperties = m_Properties
  
  For Index = 1 To Frm.CB.UBound
    For Each iProperty In iProperties
      If iProperty.PropertyType = cspList Then
        Set oProperty = iProperty
        If oProperty.Index = Index Then
          
          With Frm
            iProperty.ListItemData = ListID(.CB(Index))
            iProperty.ListListIndex = .CB(Index).ListIndex
            iProperty.ListText = .CB(Index).Text
          End With
        End If
      End If
    Next
  Next

'  For Index = 1 To Frm.CBhock.UBound
'    For Each iProperty In iProperties
'      If iProperty.PropertyType = cspList Then
'        Set oProperty = iProperty
'        If oProperty.Index = Index Then
'
'          With Frm
'            iProperty.ListItemData = ListID(.CBhock(Index))
'            iProperty.ListListIndex = .CBhock(Index).ListIndex
'            iProperty.ListText = .CBhock(Index).Text
'          End With
'        End If
'      End If
'    Next
'  Next
End Sub

Private Function pFillGrids() As Boolean
  Dim iProperty   As cIABMProperty
  Dim oProperty   As cABMProperty
  Dim iProperties As cIABMProperties
  Dim Index       As Integer
  
  Set iProperties = m_Properties
  
  With Frm
  
    For Index = 0 To .GR.UBound
      For Each iProperty In iProperties
        If iProperty.PropertyType = cspGrid Then
          Set oProperty = iProperty
          If oProperty.Index = Index Then
            
            If Not pFillRows(iProperty.Grid, .GR(Index)) Then Exit Function
            
          End If
        End If
      Next
    Next
  End With
  
  pFillGrids = True
End Function

Private Function pFillRows(ByRef Grid As cIABMGrid, ByRef grCtrl As cGridAdvanced) As Boolean
  Dim Col        As cIABMGridColumn
  Dim ColIndex   As Integer
  Dim RowIndex   As Integer
  Dim Cell       As cIABMGridCellValue
  Dim Row        As cIABMGridRow
  Dim bIsEmpty   As Boolean
  
  Dim bHaveKey As Boolean
  Dim vKeys()  As String
  Dim oRows    As cABMGridRows
  Dim oCell    As cABMGridRowValue
  
  Set oRows = Grid.Rows
  
  If oRows.HaveKey Then
  
    bHaveKey = True
    ReDim vKeys(Grid.Rows.Count, Grid.Columns.Count)
    
    Dim oRow  As cABMGridRow
    
    For RowIndex = 1 To Grid.Rows.Count
      Set oRow = Grid.Rows(RowIndex)
      vKeys(RowIndex, 1) = oRow.key
      
      For ColIndex = 2 To Grid.Columns.Count
        Set Row = oRow
        If ColIndex <= Row.Count Then
          Set oCell = Row.Item(ColIndex)
          vKeys(RowIndex, ColIndex) = oCell.strKey
        End If
      Next
    Next
  End If
  
  Grid.Rows.Clear
  
  ' Clear borra m_HaveKey
  '
  If bHaveKey Then
    oRows.HaveKey = bHaveKey
  End If
  
  With grCtrl
    For RowIndex = 1 To .Rows
    
      ' The last row can be empty because it is for new items
      ' so if no columns with values exists don't add to grid.rows
      If RowIndex = .Rows Then
        
        ' Only for grid that allow add new rows
        Dim iProperty   As cIABMProperty
        Set iProperty = GetProperty(cspGrid, .Index, 0)
        If iProperty.GridAdd Then
          If Not pGRValidateRow(.Index, RowIndex, False, False, bIsEmpty) Then
            Exit Function
          End If
        End If
      End If
      
      If Not bIsEmpty Then
      
        If bHaveKey Then
          If RowIndex <= UBound(vKeys, 1) Then
            If vKeys(RowIndex, 1) <> vbNullString Then
              Set Row = Grid.Rows.Add(Nothing, vKeys(RowIndex, 1))
            Else
              Set Row = Grid.Rows.Add(Nothing)
            End If
          Else
            Set Row = Grid.Rows.Add(Nothing)
          End If
        Else
          Set Row = Grid.Rows.Add(Nothing)
        End If
      
        For ColIndex = 2 To Grid.Columns.Count
          
          Set Col = Grid.Columns(ColIndex)
          
          With .Cell(RowIndex, ColIndex)
            
            If bHaveKey Then
              If RowIndex <= UBound(vKeys, 1) And _
                 ColIndex <= UBound(vKeys, 2) Then
                If vKeys(RowIndex, ColIndex) <> vbNullString Then
                  If vKeys(RowIndex, ColIndex) = c_keyRowItem Then
                    If Row.Item(c_keyRowItem) Is Nothing Then
                      Set Cell = Row.Add(Nothing, vKeys(RowIndex, ColIndex))
                    Else
                      Set Cell = Row.Add(Nothing)
                    End If
                  Else
                    Set Cell = Row.Add(Nothing, vKeys(RowIndex, ColIndex))
                  End If
                Else
                  Set Cell = Row.Add(Nothing)
                End If
              Else
                Set Cell = Row.Add(Nothing)
              End If
            Else
              Set Cell = Row.Add(Nothing)
            End If
            
            Cell.Id = .ItemData
            Set oCell = Cell
            oCell.HelpValueProcess = .Tag
            
            If Col.PropertyType = cspCheck Then
              Cell.Id = .ItemData
            
            ElseIf Col.PropertyType = cspDate Then
              Cell.Value = GetDateValueForGridClient(.Text)
            
            ElseIf Col.SubType = cspPercent Then
              Cell.Value = Val(.Text) * 100
            
            Else
              Cell.Value = .Text
            End If
          End With
          
          Cell.key = Col.key
        Next
      End If
    Next
  End With
  
  pFillRows = True
End Function

Private Sub SaveColumnsGrids()
  Dim i           As Integer
  Dim iProperty   As cIABMProperty

  With Frm

    For i = 0 To .GR.UBound
      
      Set iProperty = GetProperty(cspGrid, i, 0)
      
      If Not iProperty Is Nothing Then
        MngGrid.SaveColumnWidth .GR(i), pGetNameGrid(iProperty)
        MngGrid.SaveColumnOrder .GR(i), pGetNameGrid(iProperty)
      End If
    Next
  End With
End Sub

Private Sub pDiscardChanges(Optional ByVal DontCallClient As Boolean)
  On Error GoTo ControlError
  
  Dim oLock As cLockUpdateWindow

  Dim mouse As cMouseWait
  Set mouse = New cMouseWait
  
  Dim oProperty   As cABMProperty
  Dim iProperties As cIABMProperties
  
  Set iProperties = m_Properties
  
  For Each oProperty In iProperties
    Set oProperty.ctl = Nothing
  Next
  
  With Frm
  
    Set oLock = New cLockUpdateWindow
    oLock.LockW .hWnd
    
    Dim q As Integer
    
    SaveColumnsGrids
  
    InitVectorsPosition
    
    On Error Resume Next
    Dim i As Integer
    
    .ME(0).Visible = False
    For i = 1 To .ME.UBound
      Unload .ME(i)
    Next
    
    .MEFE(0).Visible = False
    For i = 1 To .MEFE.UBound
      Unload .MEFE(i)
    Next
    
    .HL(0).Visible = False
    For i = 1 To .HL.UBound
      Unload .HL(i)
    Next
    
    For i = 1 To .OP.UBound
      Unload .OP(i)
    Next
    
    For i = 1 To .FR.UBound
      Unload .FR(i)
    Next
    
    .CHK(0).Visible = False
    For i = 1 To .CHK.UBound
      Unload .CHK(i)
    Next
    
    .CMD(0).Visible = False
    For i = 1 To .CMD.UBound
      Unload .CMD(i)
    Next
    
    .CB(0).Visible = False
    For i = 1 To .CB.UBound
      Unload .CB(i)
    Next
    
'    .CBhock(0).Visible = False
'    For i = 1 To .CBhock.UBound
'      Unload .CBhock(i)
'    Next
    
    .TX(0).Visible = False
    For i = 1 To .TX.UBound
      Unload .TX(i)
    Next
    
    .TXM(0).Visible = False
    For i = 1 To .TXM.UBound
      Unload .TXM(i)
    Next
    
    .txPassword(0).Visible = False
    For i = 1 To .txPassword.UBound
      Unload .txPassword(i)
    Next
    
    .LB(0).Visible = False
    For i = 1 To .LB.UBound
      Unload .LB(i)
    Next
    
    DestroyGrids Frm
    
    If TypeOf Frm Is fWizard Or TypeOf Frm Is fABM Then
      For i = 1 To .LB2.UBound
        Unload .LB2(i)
      Next
    End If
    
    If TypeOf Frm Is fWizard Then
      For i = 1 To .prgBar.UBound
        Unload .prgBar(i)
      Next
      For i = 1 To .LBDescrip.UBound
        Unload .LBDescrip(i)
      Next
    End If
    
    If TypeOf Frm Is fWizard Or TypeOf Frm Is fABM Then
    
      For i = 1 To .lbTitle2.UBound
        Unload .lbTitle2(i)
      Next
      
      For i = 1 To .Img.UBound
        Unload .Img(i)
      Next
    End If
    
    .UnLoadToolbar
  
    InitLoadMembers
  
  End With
  
seguir:
  On Error GoTo ControlError
  
  If Not DontCallClient Then m_Client.DiscardChanges

  Exit Sub
ControlError:
  MngError Err, "DiscardChanges", C_Module, vbNullString
End Sub

Private Function pValidate() As Boolean
  If Not m_Client.Validate() Then Exit Function
  
  If m_ImplementsClientGrid Then
    
    Dim oProp         As cABMProperty
    Dim RowIndex      As Long
    Dim iProp         As cIABMProperty
    Dim iProperties   As cIABMProperties
    Dim oldRedraw     As Boolean
    
    Set iProperties = m_Properties
    
    For Each iProp In iProperties
      Set oProp = iProp
      
      If iProp.PropertyType = cspGrid Then
      
        oldRedraw = True ' oProp.ctl.Redraw cuando recompile cGridAdvanced voy
                         ' a agregar el get a Redraw
        oProp.ctl.Redraw = False
        
        For RowIndex = 1 To iProp.Grid.Rows.Count
          If Not pGRValidateRow(oProp.Index, RowIndex, False, True, False) Then
            oProp.ctl.Redraw = oldRedraw
            Exit Function
          End If
        Next
        
        oProp.ctl.Redraw = oldRedraw
      End If
    Next
  End If
  
  pValidate = True
ExitProc:
End Function

Public Sub SetTabCtlIndex()
  
  Dim iTabs       As cIABMTabs
  Dim iTab        As cIABMTabItem
  Dim oTab        As cABMTabItem
  Dim Index       As Integer
  
  Set iTabs = m_Tabs
  For Each iTab In iTabs
    Set oTab = iTab
    oTab.CtlIndex = Index
    Index = Index + 1
  Next

  Dim iProperties As cIABMProperties
  Set iProperties = m_Properties

  Dim iProp       As cIABMProperty
  Dim oProp       As cABMProperty

  For Each iProp In iProperties
  
    If iProp.TabIndex < 0 Then
  
      Set iTab = pGetTabFather(iProp.TabIndex)
  
      Set oProp = iProp
      With oProp
        .TabIndex = iProp.TabIndex
        iProp.TabIndex = iTab.Index
      End With
    
    End If
  Next

End Sub

Private Function pGetTabFather(ByVal Index As Long) As cIABMTabItem
  Dim iTabs       As cIABMTabs
  Dim iTab        As cIABMTabItem
  Dim oTab        As cABMTabItem
  
  Set iTabs = m_Tabs
  For Each iTab In iTabs
    If iTab.Index = Index Then
      Set oTab = iTab
      If oTab.FatherTab <> vbNullString Then
        Set pGetTabFather = iTabs(oTab.FatherTab)
        Exit Function
      End If
    End If
  Next
  
End Function

Private Sub ShowTabs(ByVal Tabs As Integer)
  Dim i             As Integer
  Dim Left          As Single
  Dim Top           As Single
  Dim TopItems      As Long
  Dim iTab          As cIABMTabItem
  Dim iTab2         As cIABMTabItem
  Dim bDontResize   As Boolean
  Dim tabTopHeight  As Long
  
  Left = 90
  
  If m_tabTopHeight = 0 Then
    tabTopHeight = 540
  Else
    tabTopHeight = m_tabTopHeight
    Frm.ShTab.Top = m_tabTopHeight + Frm.cbTab.Item(0).Height - 10
    m_constTop = Frm.ShTab.Top + 200
  End If
  
  With Frm
  
    If m_IsItems Then
      Top = .shTabItems.Top - .cbTab(0).Height
      TopItems = 10
    ElseIf m_IsFooter Then
      Top = .shTabFooter.Top - .cbTab(0).Height
    Else
      If m_IsDocument Then
        Top = 1080
      Else
        Top = tabTopHeight ' 540
      End If
    End If
    
    For i = 1 To .cbTab.UBound
      If m_IsItems Then
        If .cbTab(i).Tag = c_Footer Or .cbTab(i).Tag = c_Items Then
          Unload .cbTab(i)
        End If
      ElseIf m_IsFooter Then
        If .cbTab(i).Tag = c_Footer Then
          Unload .cbTab(i)
        End If
      Else
        Unload .cbTab(i)
      End If
    Next
    
    Dim iTabs   As cIABMTabs
    Dim oTab    As cABMTabItem
    Dim k       As Long
    
    If Not m_Tabs Is Nothing Then
  
      Set iTabs = m_Tabs
      Tabs = IIf(iTabs.Count - 1 > Tabs, iTabs.Count - 1, Tabs)
    End If
    
    If Tabs = 0 Then Exit Sub
    
    With .cbTab
      If .Count = 1 Then
        m_FirstTab = 0
      Else
        m_FirstTab = .Count
      End If
    End With
    
    For i = m_FirstTab To Tabs + m_FirstTab
      If i > 0 Then Load .cbTab(i)
      
      With .cbTab(i)
        If m_IsDocument Then
          If m_IsItems Then
            .Tag = c_Items
            .TabGroup = 1
          ElseIf m_IsFooter Then
            .Tag = c_Footer
            .TabGroup = 2
          Else
            .Tag = c_Header
            .TabGroup = 3
          End If
        End If
        
        k = k + 1
        
        Set oTab = iTabs(k)
        If oTab.FatherTab <> vbNullString Then
          Set iTab = iTabs(oTab.FatherTab)
          Set iTab2 = oTab
          .Tag = .Tag & c_InerTab & ((iTab.Index * 100) + Abs(iTab2.Index))
          
          If oTab.Left <> 0 Then
            bDontResize = True
            Left = oTab.Left
          End If
          If oTab.Top <> 0 Then
            bDontResize = True
            Top = oTab.Top
          End If
        End If
        
        .Caption = "Tab" & i
        .TabStop = False
        .Visible = Not m_HideTabButtons
        If Left + .Width > Frm.Width Then
          Left = 90
          Top = Top + .Height - 20
        End If
        .Top = Top + TopItems
        .Left = Left
        .ZOrder
        .BackColorPressed = vb3DHighlight
        Left = Left + .Width - 20
      End With
    Next
        
    Dim q As Integer
    
    ReDim m_Left(Tabs)
    ReDim m_NextTop(Tabs)
    
    For q = 0 To UBound(m_NextTop)
      m_NextTop(q) = m_constTop
      m_Left(q) = m_constLeft
    Next q
    
    If m_Tabs Is Nothing Then Exit Sub
    
    '/////////////////////////////////////////////////////////////
    ' Textos y anchos
    '
    Dim f As Form
    Set f = Me.Frm
    Dim cbTab As CSButton.cButton
    
    Left = 90
    If m_IsItems Then
      Top = .shTabItems.Top - .cbTab(0).Height
      TopItems = 10
    ElseIf m_IsFooter Then
      Top = .shTabFooter.Top - .cbTab(0).Height
    Else
      If m_IsDocument Then
        Top = 1080
      Else
        Top = tabTopHeight ' 540
      End If
    End If
    
    For Each iTab In iTabs
      If iTab.Index < 0 Then
        Set oTab = iTab
        Set cbTab = .cbTab(oTab.CtlIndex + m_FirstTab)
        cbTab.Caption = "&" & Abs(iTab.Index) + m_FirstTab + 1 & "-" & iTab.Name
      Else
        Set cbTab = .cbTab(iTab.Index + m_FirstTab)
        cbTab.Caption = "&" & iTab.Index + m_FirstTab + 1 & "-" & iTab.Name
      End If
      
      If Not bDontResize Then
        cbTab.Width = f.TextWidth(cbTab.Caption) + 300
        If Left + cbTab.Width > f.Width Then
          Left = 100
          Top = Top + cbTab.Height - 20
        End If
        cbTab.Left = Left
        cbTab.Top = Top + TopItems
        Left = Left + cbTab.Width - 20
      End If
    Next
    
    .ShTab.ZOrder 1
  End With
End Sub

Private Sub pSetButton(ByRef Control As Control, _
                       ByRef oProperty As cABMProperty)
                       
  If TypeOf Control Is cMaskEdit Then
    With Control
      If .csType <> csMkText And .csType <> csMkTime Then
        If .Enabled Then
        
          If oProperty.NoShowButton Then
            .ButtonStyle = cButtonNone
          Else
            .ButtonStyle = cButtonSingle
          End If
        Else
          .ButtonStyle = cButtonNone
        End If
      End If
    End With
  End If
End Sub

Private Function pLoadToolBar(ByVal Prop As cABMProperty, ByRef f As Frame) As Toolbar
  Set pLoadToolBar = m_FormABM.LoadToolbar(f)
End Function

Private Sub MoveNext()
  On Error GoTo ControlError
  
  Dim WizardClient As cWizardGeneric
  Set WizardClient = m_Client
  WizardClient.MoveNext
  
  Exit Sub
ControlError:
  MngError Err, "MoveNext", C_Module, vbNullString
End Sub

Private Sub MoveBack()
  Dim WizardClient As cWizardGeneric
  Set WizardClient = m_Client
  WizardClient.MoveBack
End Sub

Public Sub RefreshFont(ByRef iProperty As cIABMProperty)
  Dim oProp As cABMProperty
  Set oProp = iProperty
  
  If oProp.ctl Is Nothing Then Exit Sub
  pSetFont oProp.ctl, iProperty
End Sub

Public Sub RefreshPosition(ByRef iProperty As cIABMProperty)
  Dim oProp As cABMProperty
  Set oProp = iProperty
  
  If oProp.ctl Is Nothing Then Exit Sub
  
  On Error Resume Next
  oProp.ctl.Left = iProperty.Left
  oProp.ctl.Top = iProperty.Top
  oProp.ctl.Width = iProperty.Width
  oProp.ctl.Height = iProperty.Height
End Sub

Private Sub pSetFont(ByRef c As Control, ByRef iProperty As cIABMProperty)
  On Error Resume Next
  
  With iProperty
    If .FontName <> vbNullString Then
      c.FontName = .FontName
    End If
    If .FontSize > 0 Then
      c.FontSize = .FontSize
    End If
    c.FontUnderline = .FontUnderline
    c.FontBold = .FontBold
    c.FontItalic = .FontItalic
    If .ForeColor <> -1 Then
      c.ForeColor = .ForeColor
    End If
  End With
End Sub

Private Sub pSetBackColor(ByRef c As Control, ByRef iProperty As cIABMProperty)
  On Error Resume Next
  With iProperty
    If .BackColor <> -1 Then
      c.BackColor = .BackColor
    End If
  End With
End Sub

Private Sub pSetTabIndexDescrip()
  Dim iProperty   As cIABMProperty
  Dim oProperty   As cABMProperty
  Dim iProperties As cIABMProperties
  
  If m_IsDocument Then
  
    Set iProperties = m_Properties
  
    With Frm
  
      For Each iProperty In iProperties
        If iProperty.SubType = cspMemo Then
          Set oProperty = iProperty
          .TXM(oProperty.Index).TabIndex = .Controls.Count
        End If
      Next
    End With
  End If
End Sub

Private Sub pRefreshAux()
  Dim Index       As Integer
  Dim oProperty   As cABMProperty
  Dim iProperties As cIABMProperties
  Dim i           As Integer
  
  Set iProperties = m_Properties
  
  With Frm
  
    For i = 1 To iProperties.Count
      
      Set oProperty = iProperties(i)
      Index = oProperty.Index
      
      Select Case iProperties(i).PropertyType
'        Case csTypeABMProperty.cspAdHock
'          ChangeProperty cspAdHock, Index, .CBhock.Item(Index), True
          
        Case csTypeABMProperty.cspCheck
          ChangeProperty cspCheck, Index, .CHK.Item(Index), True
          
        Case csTypeABMProperty.cspDate, csTypeABMProperty.cspTime
          ChangeProperty cspDate, Index, .MEFE.Item(Index), True
        
        Case csTypeABMProperty.cspHelp
          ChangeProperty cspHelp, Index, .HL.Item(Index), True
        
        Case csTypeABMProperty.cspList
          ChangeProperty cspList, Index, .CB.Item(Index), True
          
        Case csTypeABMProperty.cspNumeric
          ChangeProperty cspNumeric, Index, .ME.Item(Index), True
          
        Case csTypeABMProperty.cspOption
          ChangeProperty cspOption, Index, .OP.Item(Index), True
          
        Case csTypeABMProperty.cspPassword
          ChangeProperty cspPassword, Index, .txPassword.Item(Index), True
          
        Case csTypeABMProperty.cspText, csTypeABMProperty.cspFile, csTypeABMProperty.cspFolder
          If iProperties(i).SubType = cspMemo Then
            ChangeProperty cspText, Index, .TXM.Item(Index), True, cspMemo
          Else
            ChangeProperty cspText, Index, .TX.Item(Index), True
          End If
          
      End Select
    Next
  End With
End Sub

Private Sub pResetChanged()
  WasChanged = False
  m_Unloading = False
End Sub

Private Function pAskDelete(ByVal msg As String) As Boolean
  pAskDelete = Ask(msg, vbYes, "Borrar")
End Function

Private Sub pReloadDocument()
  On Error Resume Next
    
  If m_Unloading Then Exit Sub
  
  pShowMsg "Descartando los cambios hechos al documento ..."
  m_Client.MessageEx MSG_DOC_REFRESH, Nothing
  WasChanged = False
  pHideMsg
End Sub

Public Sub PrintDocumento()
  pPrint False
End Sub

Public Sub PrintDocEx(ByVal Id As Long)
  pPrint False, Id
End Sub

Public Sub PrintDocumentoCobranzaCdo(ByRef Obj As CSInterfacesABM.cIABMClient)
  On Error Resume Next
  Dim OldClient As CSInterfacesABM.cIABMClient
  Set OldClient = m_Client
  Set m_Client = Obj
  pPrint False
  Set m_Client = OldClient
End Sub

Public Function PrintDocWithResult(ByRef Obj As CSInterfacesABM.cIABMClient, ByVal Id As Long, ByVal DocId As Long) As Boolean
  On Error Resume Next
  
  Dim OldClient As CSInterfacesABM.cIABMClient
  Set OldClient = m_Client
  Set m_Client = Obj

  PrintDocWithResult = pPrintDocWithResult(Id, DocId)

  Set m_Client = OldClient

End Function

Public Function pPrintDocWithResult(ByVal Id As Long, ByVal DocId As Long) As Boolean

  If Id = csNO_ID Then
    Exit Function
  End If

  Dim PrintManager As Object 'CSPrintManager.cPrintManager
    
  Set PrintManager = CSKernelClient2.CreateObject("CSPrintManager2.cPrintManager")
    
  With PrintManager
    
    .IsForEmail = False
    .EmailAddress = pGetEmailAddress()
    .Path = GetValidPath(IniGetEx(c_RPT_KEY, c_RPT_PathReportes, gAppPath))
    .CommandTimeout = Val(IniGetEx(c_RPT_KEY, c_RPT_CommandTimeOut, 0))
    .ConnectionTimeout = Val(IniGetEx(c_RPT_KEY, c_RPT_ConnectionTimeOut, 0))

    .DescripUser = pGetDescripUser()
    .Title = pGetPrintTitle()

    .ShowPrint Id, csNO_ID, DocId
    
    pPrintDocWithResult = .DocImpreso
  
  End With

End Function

Private Sub pPrint(ByVal byEmail As Boolean, Optional ByVal Id As Long)

  On Error GoTo ControlError

  Dim PrintManager As Object 'CSPrintManager.cPrintManager
  Dim iDoc         As CSIDocumento.cIDocumento
  
  If Not TypeOf m_Client Is CSIDocumento.cIDocumento Then GoTo ExitProc
  Set iDoc = m_Client
  
  If Id = csNO_ID Then
    Id = iDoc.Id
  End If
  
  If Id = csNO_ID Then
    MsgInfo "Debe grabar el documento para poder imprimirlo", "Imprimir"
    GoTo ExitProc
  End If
  
  Set PrintManager = CSKernelClient2.CreateObject("CSPrintManager2.cPrintManager")
  
  ' OJO: Esto es nuevo y puede traer problemas
  '      es para que no se impriman formularios
  '      con cambios sin guardar
  '
  If Not m_InSave Then
  
    If Not pSaveChanges(False, False) Then GoTo ExitProc
  
  End If
  
  With PrintManager
    
    .IsForEmail = byEmail
    .EmailAddress = pGetEmailAddress()
    .Path = GetValidPath(IniGetEx(c_RPT_KEY, c_RPT_PathReportes, gAppPath))
    .CommandTimeout = Val(IniGetEx(c_RPT_KEY, c_RPT_CommandTimeOut, 0))
    .ConnectionTimeout = Val(IniGetEx(c_RPT_KEY, c_RPT_ConnectionTimeOut, 0))

    .DescripUser = pGetDescripUser()
    .AutoPrint = m_AutoPrint

    .ShowPrint Id, csNO_ID, iDoc.DocId
    
    If .DocImpreso Then
      pReloadDocument
    End If
  End With

  GoTo ExitProc
ControlError:
  MngError Err, "pPrint", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Function pGetDescripUser() As String
  Dim rtn As String
  
  rtn = m_Client.MessageEx(MSG_EXPORT_GET_FILE_NAME_POSTFIX, Nothing)
  
  pGetDescripUser = rtn
End Function

Private Function pGetPrintTitle() As String
  Dim rtn As String
  
  rtn = m_Client.MessageEx(MSG_PRINT_GET_TITLE, Nothing)
  
  pGetPrintTitle = rtn
End Function

Private Function pGetEmailAddress() As String
  On Error Resume Next
  
  Dim EmailAddress As String
  
  EmailAddress = Trim$(m_Client.MessageEx(MSG_EXPORT_GET_EMAIL, Nothing))
  
  pGetEmailAddress = EmailAddress
End Function

Private Function pNewWithWizard() As Boolean
  On Error Resume Next
  pNewWithWizard = VarToBool(m_Client.MessageEx(MSG_DOC_NEW_WITH_WIZARD, Nothing))
End Function

Private Function pGetTabIndex(ByRef iProperty As cIABMProperty) As Long
  With iProperty
    If .TabIndex = csETabIdxT_All Or .TabIndex = csETabIdxT_All2 Then
      pGetTabIndex = 0
    Else
      pGetTabIndex = .TabIndex
    End If
  End With
End Function

Private Sub InitVectorsPosition()
  m_Left(0) = m_constLeft
  m_LeftOp(0) = m_constLeftOp
  m_NextTop(0) = m_constTop
  m_NextTopOp(0) = m_constTopOp
End Sub

Private Sub InitCtrlPosition()
  m_constLeft = Frm.LB(0).Left
  m_constLeftOp = Frm.OP(0).Left
  m_TextOrigWidth = Frm.TX(0).Width
  
  If m_IsItems Then
    m_constTop = Frm.shTabItems.Top + 100
  
  ElseIf m_IsFooter Then
    m_constTop = Frm.shTabFooter.Top + C_offsetV1
    m_constLeft = Frm.shTabFooter.Left + 200
  Else
    m_constTop = Frm.HL(0).Top
  End If
  
  m_constTopOp = Frm.OP(0).Top
End Sub

Private Function InitLoadMembers()
  'm_bLoadAdHock = False
  m_bLoadList = False
  m_bLoadHelp = False
  m_bLoadNumeric = False
  m_bLoadDate = False
  m_bLoadOption = False
  m_bLoadLabel = False
  m_bLoadTitle = False
  m_bLoadProgressBar = False
  m_bLoadDescription = False
  m_bLoadImage = False
  m_bLoadText = False
  m_bLoadTextM = False
  m_bLoadFile = False
  m_bLoadFolder = False
  m_bLoadPassword = False
  m_bLoadCheck = False
  m_bLoadGrid = False
  m_bLoadButton = False
End Function

Public Sub InitButtons()
  If TypeOf Frm Is fABMDoc Then
    m_FormDoc.NoButtons1 = m_NoButtons1
    m_FormDoc.NoButtons2 = m_NoButtons2
    m_FormDoc.NoButtons3 = m_NoButtons3
    m_FormDoc.ButtonsEx2 = m_ButtonsEx2
    m_FormDoc.ButtonsEx3 = m_ButtonsEx3
    m_FormDoc.SetToolbarButtons
  End If
End Sub

' construccion - destruccion
Private Sub Class_Initialize()
#If PREPROC_DEBUG Then
  gdbInitInstance C_Module
#End If

  On Error Resume Next
  
  m_IsDocument = False
  m_IsFooter = False
  m_IsItems = False
  m_FormShowed = False
  m_MinHeight = 5310
  m_MinWidth = 8640
  m_tabHideCtrlsInAllTab = -1
  
  Set m_Properties = New cABMProperties
  
  ReDim m_NextTop(0)
  ReDim m_NextTopOp(0)
  ReDim m_Left(0)
  ReDim m_LeftOp(0)
End Sub

Private Sub Class_Terminate()
  On Error Resume Next
  
  Set m_Menu = Nothing

  ReDim m_NextTop(0)
  ReDim m_NextTopOp(0)
  ReDim m_Left(0)
  ReDim m_LeftOp(0)
  
  Set m_Properties = Nothing
  Set m_Client = Nothing
  Set m_Tabs = Nothing
  Set m_MngGrid = Nothing
  
  If Not m_FormABM Is Nothing Then
    Unload m_FormABM
  End If
  If Not m_FormDoc Is Nothing Then
    Unload m_FormDoc
  End If
  If Not m_FormWizard Is Nothing Then
    Unload m_FormWizard
  End If
  
  Set m_FormABM = Nothing
  Set m_FormDoc = Nothing
  Set m_FormWizard = Nothing
  
  Set m_owner = Nothing

#If PREPROC_DEBUG Then
  gdbTerminateInstance C_Module
#End If
End Sub

Private Function pGetNameGrid(ByRef iProp As cIABMProperty) As String
  If iProp.Name <> vbNullString Then
    pGetNameGrid = m_Client.Title & "_" & iProp.Name
  Else
    pGetNameGrid = m_Client.Title & "_" & iProp.key
  End If
End Function

Private Sub pSetDontResize()
  Dim iProp       As cIABMProperty
  Dim oProp       As cABMProperty
  Dim Grid        As cABMGrid
  Dim i           As Long
  Dim indexGrid   As Long
  Dim iProperties As cIABMProperties
  
  Set iProperties = m_Properties
  
  For Each iProp In iProperties
    
    If iProp.PropertyType = cspGrid Then
      i = i + 1
      Set Grid = iProp.Grid
      
      Set oProp = iProp
      
      If Not oProp.ctl Is Nothing And Frm Is m_FormABM Then
        indexGrid = Frm.GetIndexGrid(oProp.ctl)
        If indexGrid = 0 Then indexGrid = i
      Else
        indexGrid = i
      End If
      
      Frm.SetDontResize(indexGrid) = Grid.DontResize
      
      ' Solo aplicamos un valor a esta propiedad
      ' cuando explicitamente se indico que no se
      ' debe redimencionar la grilla. Esto es asi
      ' por que el comportamiento original no estaba
      ' previsto que el programador indicara que se
      ' podia modificar el alto de las grillas, sino
      ' que el framework lo definia por si solo.
      '
      ' Ahora el programador puede indicar que no se
      ' debe redimencionar el alto de una grilla, pero
      ' no puede indicar que si se puede.
      '
      ' Esto en algun momento se puede reprogramar para
      ' que quede mas coherente.
      '
      If Grid.DontResizeHeight Then
        Frm.SetDontResizeHeight(indexGrid) = True
        
        If Not oProp.ctl Is Nothing Then
          pSetGridHeight oProp.ctl, iProp.Height
        End If
      End If
    End If
  Next
End Sub

Private Sub pSetGridHeight(ByVal ctl As Object, ByVal Height As Long)
  On Error Resume Next
  If Height > 0 Then
    ctl.Height = Height
  End If
End Sub

Private Sub pSetEnabled(ByVal bEnabled As Boolean)
  On Error Resume Next

  Dim ctl As Object
  Dim i   As Long

  If bEnabled Then
    For Each ctl In Frm.Controls
      If TypeOf ctl Is cGridAdvanced Then
        i = i + 1
        If m_vEnabledState(i) Then
          ctl.Enabled = True
        End If
      End If
    Next

    ReDim m_vEnabledState(0)
  Else

    ReDim m_vEnabledState(0)

    For Each ctl In Frm.Controls
      If TypeOf ctl Is cGridAdvanced Then
        i = i + 1
        ReDim Preserve m_vEnabledState(i)
        m_vEnabledState(i) = ctl.Enabled
        ctl.Enabled = False
      End If
    Next
  End If
End Sub

Private Sub pRefreshTitle()
  With Frm
    If Not ValEmpty(m_Title2, csText) Then
      .lbTitleEx2.Caption = " - " & m_Title2
      .lbTitleEx2.Left = .lbTitle.Left + .lbTitle.Width + 50
    Else
      .lbTitleEx2.Caption = vbNullString
    End If
  End With
End Sub

Public Sub RefreshFormCaption()
  On Error Resume Next
  Frm.Caption = pGetFormCaption
End Sub

Private Function pGetFormCaption() As String
  pGetFormCaption = m_FormCaption & gEmpNombre & " - " & m_Client.Title & " || Presione F12 para ver las teclas de acceso rapido"
End Function

Private Sub pSetBackgroundColor()
  If gBackgroundColor <> 0 Then
  
    SetBakcColorTagMainEx gBackgroundColor
  
  End If
End Sub

Public Sub SetBakcColorTagMainEx(ByVal Color As Long)
  gBackgroundColor = Color
  If Not m_FormABM Is Nothing Then
    m_FormABM.ShTab.BackColor = Color
  ElseIf Not m_FormDoc Is Nothing Then
    m_FormDoc.ShTab.BackColor = Color
    m_FormDoc.shTabFooter.BackColor = Color
    m_FormDoc.shTabItems.BackColor = Color
  ElseIf Not m_FormWizard Is Nothing Then
    m_FormWizard.ShTab.BackColor = Color
    m_FormWizard.shBack.BackColor = Color
    m_FormWizard.shTitle.BackColor = vbWhite
  End If
End Sub

Private Function pGetCtrlVisibleInTab(ByRef c As Object, ByVal Index As Long) As Boolean
  pGetCtrlVisibleInTab = Val(c.Tag) = Index _
                        Or (Val(c.Tag) = csETabIdxT_All _
                              And Index <> m_tabHideCtrlsInAllTab) _
                        Or Val(c.Tag) = csETabIdxT_All2
End Function

Private Sub pWizDisableButtons()
  On Error Resume Next
  If m_FormWizard Is Nothing Then Exit Sub
  'm_FormWizard.Enabled = False
  'm_FormWizard.cmdNext.Enabled = False
  m_bInProcess = True
  Err.Clear
End Sub

Private Sub pWizEnableButtons()
  On Error Resume Next
  If m_FormWizard Is Nothing Then Exit Sub
  'm_FormWizard.Enabled = True
  'm_FormWizard.cmdNext.Enabled = True
  m_bInProcess = False
  Err.Clear
End Sub

'//////////////////////////////
'  Codigo estandar de errores
'  On Error GoTo ControlError
'
'  GoTo ExitProc
'ControlError:
'  MngError err,"", C_Module, vbnullstring
'  If Err.Number Then Resume ExitProc
'ExitProc:
'  On Error Resume Next

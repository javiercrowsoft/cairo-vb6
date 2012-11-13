VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cReport"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
'--------------------------------------------------------------------------------
' cReport
' 30-06-01

'--------------------------------------------------------------------------------
' notas:

      ' Cuando un cambio puede traer problemas
      ' ponemos la fecha y la palabra WARNING
      ' ejemplo:
      '
      ' 2008-02-18 WARNING

      ' Manejo de Recordset adicionales:
      '
      ' Hay dos tipos de RS adicionales:
      '
      '     - Todos los recordset que sigan al primer RS del DataSource principal
      '     - Todos los recordset que devuelva un DataSource Adicional
      '
      ' Para que sirven:
      '
      ' Permiten indicar fuentes de datos que estan relacionados o no con el RS
      ' principal (El primer RS devuelto por el DataSource principal)
      '
      ' Un uso comun es para los logos
      '
      ' Otro uso comun es para asociar a un conjunto de filas la misma informacion
      ' sin repetirla en cada fila del primer recordset. Esto es fundamental cuando se
      ' trata de imagenes.
      '
      ' Para acceder a un valor en cualquier registro de un RS adicional se debe usar
      ' la formula GetDataFromRsAd.
      '
      ' Esta funcion pide:
      '                    - El nombre del DataSource
      '                    - El numero de recordset dentro del DataSource
      '                    - El nombre del campo en dicho recordset para obtener el valor
      '                    - y una lista con duplas de nombres de campo que indica el criterio
      '                      que debe cumplir el registro desde el que se toma el valor.
      '
      ' Ejemplo:    GetDataFromRsAd (lsListaPrecioMurescoExpo,2,dd_file,pr_MUR_Familia=murfm_codigo)
      '
      ' Nota: En este ejemplo se indico una sola dupla (pr_MUR_Familia=murfm_codigo), para indicar
      '       mas de una se debe usar un pipe como separador ej:(col1=col2|col3=col4).
      '       La primera columna es del primer recordset del DataSource principal, y la segunda
      '       es del recordset indicado en los dos primeros parametros.

'--------------------------------------------------------------------------------
' api win32
  ' constantes
  ' estructuras
  ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cReport"
Private Const c_Headers = 1
Private Const c_Footers = 2
Private Const c_NodeRptHeaders = "RptHeaders"
Private Const c_NodeRptDetails = "RptDetails"
Private Const c_NodeGroups = "RptGroups"
Private Const c_NodeRptFooters = "RptFooters"
Private Const c_RptConnect = "RptConnect"
Private Const c_RptConnectsAux = "RptConnectsAux"
Private Const c_LaunchInfo = "RptLaunchInfo"
Private Const c_NodeRptFormulas = "RptFormulas"
Private Const c_NodeRptPagesSetting = "RptPagesSetting"
Private Const c_NodeRptPages = "RptPages"
Private Const c_NodePaperInfo = "PaperInfo"
Private Const c_FileEx = "CrowSoft Report|*.csr| Archivos Xml|*.xml"
Private Const c_FileDataEx = "CrowSoft Report data|*.csd| Archivos Xml|*.xml"

' Grupos para formulas especiales
'
Private Const c_IdxGroupReportHeader = -2000
Private Const c_IdxGroupHeader = -1000     ' Todas las formulas en header
Private Const c_IdxGroupDetail = 0         ' Todas las formulas en Detail
Private Const c_IdxGroupFooter = -1001     ' Todas las formulas en footer
Private Const c_IdxGroupReportFooter = -2001

Private Const c_IdxHLastRowEvalued = 0
Private Const c_IdxDLastRowEvalued = 1
Private Const c_IdxFLastRowEvalued = 2
Private Const c_IdxGLastRowEvalued = -1    ' Me dice que debo fijarme en el grupo
                                           ' (m_vGroups) y no en m_LastRow..Evalued
                                           ' cual fue la ultima fila evaluada

' estructuras
' variables privadas

' Este objecto permite la comunicacion entre la CSReport y sus clientes
' no se olviden que CSReport es un Exe Activex que corre en su propia
' memoria out of process del cliente.
' Ademas refleja la interfaz server del objecto cReportLink
' que vincula al cliente con esta dll.
Private m_Link                          As CSReportLink.cIReportLinkServer

Private m_LaunchInfo                    As cReportLaunchInfo

Private m_Groups                        As cReportGroups
Private m_Details                       As cReportSections
Private m_Headers                       As cReportSections
Private m_Footers                       As cReportSections
Private m_GroupsHeaders                 As cReportSections
Private m_GroupsFooters                 As cReportSections
Private m_PaperInfo                     As cReportPaperInfo
Private m_OriginalHeight                As Long
Private m_Controls                      As cReportControls2
Private m_Formulas                      As cReportFormulas
Private m_FormulaTypes                  As cReportFormulaTypes
Private m_Name                          As String
Private m_Path                          As String
Private m_PathDefault                   As String

Private m_DescripUser                   As String

Private m_Connect                       As cReportConnect
Private m_ConnectsAux                   As cReportConnectsAux

Private m_PageSetting                   As cReportPageSetting
Private m_Pages                         As cReportPages

Private m_Compiler                      As cReportCompiler
Private m_CurrenPage                    As Long
Private m_TotalPages                    As Long

Private m_ReportDisconnected            As Boolean

' Para ordenar los grupos
Private m_vCollRows()                     As Variant     ' Este vector contiene una tabla con los datos del
                                                         ' primer recordset devuelto por el datasource de cada
                                                         ' conexion. Los recordset adicionales que cada
                                                         ' datasource puede devolver no se manejan con este
                                                         ' vector, pero se reserva una posicion para que los indices
                                                         ' no fallen. La reserva de la posicion se hace en pGetData
                                                         
Private m_CollhImages                     As Collection
Private m_vRows                           As Variant
Private m_RecordCount                     As Long
Private m_vRowsIndex()                    As Long
Private m_vRowsIndexAux()                 As Long
Private m_iRow                            As Long
Private m_iRow2                           As Long
Private m_iRowFormula                     As Long
Private m_LineIndex                       As Long

Private m_LastRowPreEvalued()             As Long
Private m_LastRowPostEvalued()            As Long

Private m_idxGroupToPrintNP               As Long     ' Permite imprimir un grupo en una nueva pagina
                                                      ' cuando el grupo cambia

Private m_bExistsGrpToRePrintInNP         As Boolean ' Permite saber si hay grupos que reimprimir ya
                                                     ' que si no hay se permite imprimir footer en el primer
                                                     ' renglon de una pagina nueva
Private m_bHaveToRePrintGroup             As Boolean

Private m_idxGroupHeader                  As Long ' Me indica en que grupo estoy
Private m_idxGroupFooter                  As Long ' Idem

Private m_bPrintFooter             As Boolean
Private m_bLastFootersWasPrinted   As Boolean
Private m_GroupIndexChange         As Long

Private m_bEvalPreGroups           As Boolean
Private m_bCloseFooter             As Boolean
Private m_bOpenHeader              As Boolean

' Grupos
Private Type T_Group
  First As Long
  Last  As Long
End Type

Private Type T_Groups
  Value                 As Variant
  IndiceField           As Long
  Changed               As Boolean
  ReprintHeader         As Boolean
  FooterMustBeClose     As Boolean
  ComparisonType        As csRptGrpComparisonType
  OderType              As csRptGrpOrderType
  GrandTotalGroup       As Boolean
  Groups()              As T_Group
  
  LastHPreRowEvalued     As Long
  LastHPostRowEvalued    As Long
  
  LastFPreRowEvalued     As Long
  LastFPostRowEvalued    As Long
  
  LineNumber             As Long  ' Me permite saber en que renglon estoy dentro de un grupo
                                  ' solo cuenta cuando se imprime una linea de detalle
                                  ' y no cuenta renglones del detalle sino impresiones
                                  ' completas del detalle
End Type

Private m_LineNumber  As Long ' Me permite saber en que renglon estoy
                              ' solo cuenta cuando se imprime una linea de detalle
                              ' y no cuenta renglones del detalle sino impresiones
                              ' completas del detalle

Private m_vGroups()   As T_Groups
Private m_FirstGroup  As Boolean
Private m_GroupCount  As Long

Private m_IsForWeb    As Boolean

Private m_ExportEmailAddress As String

' eventos
Public Event Progress(ByVal Task As String, ByVal Page As Long, ByVal CurrRecord As Long, ByVal RecordCount As Long, ByRef Cancel As Boolean)
Public Event Done()
Public Event FindFileAccess(ByRef Answer As Boolean, ByRef CommDialog As Object, ByVal File As String)

' propiedades publicas

Public Property Get ExportEmailAddress() As String
  ExportEmailAddress = m_ExportEmailAddress
End Property

Public Property Let ExportEmailAddress(ByRef rhs As String)
  m_ExportEmailAddress = rhs
End Property

Public Property Get IsForWeb() As Boolean
  IsForWeb = m_IsForWeb
End Property

Public Property Let IsForWeb(ByVal rhs As Boolean)
  m_IsForWeb = rhs
End Property

Public Property Get ConnectsAux() As cReportConnectsAux
   Set ConnectsAux = m_ConnectsAux
End Property

Public Property Set ConnectsAux(ByRef rhs As cReportConnectsAux)
   Set m_ConnectsAux = rhs
End Property

Public Property Get Groups() As cReportGroups
  Set Groups = m_Groups
End Property

Public Property Let Groups(ByVal rhs As cReportGroups)
  Set m_Groups = rhs
End Property

Public Property Get Details() As cReportSections
  Set Details = m_Details
End Property

Public Property Let Details(ByVal rhs As cReportSections)
  Set m_Details = rhs
End Property

Public Property Get Headers() As cReportSections
  Set Headers = m_Headers
End Property

Public Property Let Headers(ByVal rhs As cReportSections)
  Set m_Headers = rhs
End Property

Public Property Get Footers() As cReportSections
  Set Footers = m_Footers
End Property

Public Property Let Footers(ByVal rhs As cReportSections)
  Set m_Footers = rhs
End Property

Public Property Get GroupsHeaders() As cIReportGroupSections 'CSReportDll2.cIReportGroupSections
  Set GroupsHeaders = m_GroupsHeaders
End Property

Public Property Get GroupsFooters() As cIReportGroupSections 'CSReportDll2.cIReportGroupSections
  Set GroupsFooters = m_GroupsFooters
End Property

Public Property Get Link() As CSReportLink.cIReportLinkServer
  Set Link = m_Link
End Property

Public Property Let Link(ByVal rhs As CSReportLink.cIReportLinkServer)
  Set m_Link = rhs
End Property

Public Property Get PaperInfo() As cReportPaperInfo
  Set PaperInfo = m_PaperInfo
End Property

Public Property Set PaperInfo(ByVal rhs As cReportPaperInfo)
  Set m_PaperInfo = rhs
End Property

Public Property Get Controls() As cReportControls2
  Set Controls = m_Controls
End Property

Public Property Get Formulas() As cReportFormulas
  Set Formulas = m_Formulas
End Property

Public Property Get FormulaTypes() As cReportFormulaTypes
  Set FormulaTypes = m_FormulaTypes
End Property

Public Property Get Name() As String
  Name = m_Name
End Property

Public Property Let Name(ByVal rhs As String)
  m_Name = rhs
End Property

Public Property Get Path() As String
  Path = m_Path
End Property

Public Property Let PathDefault(ByVal rhs As String)
  m_PathDefault = rhs
End Property

Public Property Get Connect() As cReportConnect
  Set Connect = m_Connect
End Property

Public Property Get Pages() As cReportPages
  Set Pages = m_Pages
End Property

Public Property Get PageSetting() As cReportPageSetting
  Set PageSetting = m_PageSetting
End Property

Public Property Let PageSetting(ByVal rhs As cReportPageSetting)
  Set m_PageSetting = rhs
End Property

Public Property Get LaunchInfo() As cReportLaunchInfo
 Set LaunchInfo = m_LaunchInfo
End Property

Public Property Get Compiler() As cReportCompiler
  Set Compiler = m_Compiler
End Property

Public Property Get ReportDisconnected() As Boolean
  ReportDisconnected = m_ReportDisconnected
End Property

Public Property Let ReportDisconnected(ByVal rhs As Boolean)
  m_ReportDisconnected = rhs
End Property

Public Property Get DescripUser() As String
   DescripUser = m_DescripUser
End Property

Public Property Let DescripUser(ByVal rhs As String)
   m_DescripUser = rhs
End Property

' propiedades friend
Friend Property Get CurrenPage() As Integer
  CurrenPage = m_Pages.Count
End Property

Friend Property Get TotalPages() As Integer
  TotalPages = m_Pages.Count
End Property
' propiedades privadas
' funciones publicas

Public Function MoveGroup(ByVal iFrom As Long, ByVal iTo As Long) As Boolean
  If iFrom < 1 Or iFrom > m_Groups.Count Then Exit Function
  If iTo < 1 Or iTo > m_Groups.Count Then Exit Function
  
  If iFrom <> iTo Then
    
    Dim Group As cReportGroup
    Dim CollGroups As Collection
    
    Set CollGroups = New Collection
    
    For Each Group In m_Groups
      CollGroups.Add Group
    Next
    
    m_Groups.Clear
    
    Dim nIndex      As Long
    
    For Each Group In CollGroups
      nIndex = nIndex + 1
      If nIndex <> iFrom Then
        If nIndex = iTo Then
          m_Groups.Add2 CollGroups(iFrom), CollGroups(iFrom).Key
        End If
        m_Groups.Add2 Group, Group.Key
      End If
    Next
    
  End If
  MoveGroup = True
End Function

' Llamada por el componente de Impresion cada vez que se termina una pagina.
' Crea un nuevo objeto cReportPage y lo agrega a la coleccion Pages. Carga
' en el nuevo objeto todos los valores correpondientes a los Headers.
Public Function NewPage() As csRptNewPageResult
  Dim Page As cReportPage
  
  NewPage = csRptNewPageResult.csRptNPError
  
  Set Page = m_Pages.Add()
  Page.PageNumber = m_Pages.Count

  ' Si el usuario cancela devuelvo error
  If Not ShowProgress(vbNullString, m_Pages.Count, 0, 0) Then Exit Function

  ' Si es la primera pagina evaluo report header
  '
  If m_Pages.Count = 1 Then
    EvalFunctions c_IdxGroupReportHeader, csRptEvalPre
  End If

  ' Solo las formulas que esten en las secciones de tipo header
  '
  EvalFunctions c_IdxGroupHeader, csRptEvalPre

  ' Por cada Header
  AddFieldToNewPage m_Headers, Page, c_Headers

  ' Solo las formulas que esten en las secciones de tipo header
  '
  EvalFunctions c_IdxGroupHeader, csRptEvalPost

  ' Si es la primera pagina evaluo report header
  '
  If m_Pages.Count = 1 Then
    EvalFunctions c_IdxGroupReportHeader, csRptEvalPost
  End If

  ' Ahora indico el alto del Header y del Footer
  Page.HeaderBottom = GetHeightHeader()
  Page.FooterTop = GetTopFooter()
  
  If IsEmpty(m_vRows) Then
    NewPage = csRptNewPageResult.csRptNPEnd
    Exit Function
  ElseIf m_iRow > UBound(m_vRowsIndex) Then
    NewPage = csRptNewPageResult.csRptNPEnd
    Exit Function
  End If
  
  ' Si hay groups headers que se deben re-imprimir en
  ' la nueva pagina
  '
  If m_bExistsGrpToRePrintInNP Then
    m_bHaveToRePrintGroup = True
    
    ' Este flag me permite saber que hay grupos que re-imprimir
    '
    pMarkGroupHeadersToReprint
  End If
  
  NewPage = csRptNewPageResult.csRptNPSuccess
End Function

Private Sub pMarkGroupHeadersToReprint()
  Dim i As Integer
  
  ' Si estoy en la primera pagina no hago nada
  '
  If m_FirstGroup Then Exit Sub
  
  For i = 1 To m_GroupCount
    If m_Groups.Item(i).RePrintInNewPage Then
      m_vGroups(i).ReprintHeader = True
    End If
  Next
End Sub

Private Function pExistsGroupHeadersToReprint() As Boolean
  Dim i As Integer
  For i = 1 To m_GroupCount
    If m_vGroups(i).ReprintHeader Then
      m_idxGroupHeader = i
      m_bOpenHeader = True
      pExistsGroupHeadersToReprint = True
      Exit Function
    End If
  Next
  
  ' Ya no hay mas grupos que re-imprimir
  '
  m_bHaveToRePrintGroup = False
End Function

Private Sub pCheckExistsGroupHToReprint()
  Dim i As Integer
  For i = 1 To m_GroupCount
    If m_vGroups(i).ReprintHeader Then
      Exit Sub
    End If
  Next
  
  ' Ya no hay mas grupos que re-imprimir
  '
  m_bHaveToRePrintGroup = False
End Sub

' Llamada por el componente de Impresion cada vez que se termina una pagina.
' Carga en el ultimo objeto cReportPage de la coleccion m_Pages todos los
' valores correpondientes a los Footers.
Public Function EndPage() As csRptEndPageResult
  Dim Page As cReportPage
  
  EndPage = csRptEndPageResult.csRptEPError
  
' Ultima pagina
  Set Page = m_Pages.Item(m_Pages.Count)

  ' Solo las formulas que esten en las secciones de tipo footer
  '
  EvalFunctions c_IdxGroupFooter, csRptEvalPre

' Por cada Footer
  AddFieldToNewPage m_Footers, Page, c_Footers
  
  ' Solo las formulas que esten en las secciones de tipo footer
  '
  EvalFunctions c_IdxGroupFooter, csRptEvalPost
  
  EndPage = csRptEndPageResult.csRptEPSuccess
End Function

Public Sub MarkGroupHeaderPrinted()
  ' Si era una re-impresion
  '
  If m_vGroups(m_idxGroupHeader).ReprintHeader Then
    
    m_vGroups(m_idxGroupHeader).ReprintHeader = False
    
'///////////////////////////////////////////////////
'
' OJO: ANTE CUALQUIER REPORTE QUE NO ANDE
'      ASUMIR QUE ESTE ES EL SOSPECHOSO
'      DE SIEMPRE
'
    ' Cada vez que imprimo un grupo
    ' que debe reimprimirse chequeo
    ' si debo apagar el flag
    '
    pCheckExistsGroupHToReprint

'
'///////////////////////////////////////////////////
    
    If pNotPendingFooters() Then
      pMarkGroupHeaderPrintedAux
    End If
  
  ' Si el grupo cambio lo inicializo
  ' y lo marco como impreso
  '
  ElseIf m_vGroups(m_idxGroupHeader).Changed Then
    pMarkGroupHeaderPrintedAux
  End If
End Sub

Private Sub pMarkGroupHeaderPrintedAux()
  Dim HeaderSec As cReportSection
  Dim SecLn     As cReportSectionLine
  Dim ctrl      As cReportControl
  
  ' Si ya imprimi el grupo le quito la marca que
  ' uso para saber que cambio
  '
  m_vGroups(m_idxGroupHeader).Changed = False

  ' Si era un grupo que se imprime en una nueva pagina apago el flag
  ' por que ya esta impreso
  '
  If m_idxGroupToPrintNP = m_idxGroupHeader Then
    m_idxGroupToPrintNP = 0
  End If

  Set HeaderSec = m_Groups.Item(m_idxGroupHeader).Header

  ' Inicializo las variables de las formulas de los
  ' controles de los section line del Header del grupo
  '
  For Each SecLn In HeaderSec.SectionLines
    For Each ctrl In SecLn.Controls
      If ctrl.HasFormulaHide Then m_Compiler.InitVariable ctrl.FormulaHide
      If ctrl.HasFormulaValue Then m_Compiler.InitVariable ctrl.FormulaValue
    Next
  Next
End Sub

Public Sub MarkGroupFooterPrinted()
  Dim FooterSec           As cReportSection
  Dim ctrl                As cReportControl
  Dim SecLn               As cReportSectionLine
  
  ' Si ya imprimi el grupo le quito la marca que
  ' uso para saber que debia cerrarlo
  '
  m_vGroups(m_idxGroupFooter).FooterMustBeClose = False

  Set FooterSec = m_Groups.Item(m_idxGroupFooter).Footer

  ' Inicializo las variables de las formulas de los
  ' controles de los section line del Footer del grupo
  '
  For Each SecLn In FooterSec.SectionLines
    For Each ctrl In SecLn.Controls
      If ctrl.HasFormulaHide Then m_Compiler.InitVariable ctrl.FormulaHide
      If ctrl.HasFormulaValue Then m_Compiler.InitVariable ctrl.FormulaValue
    Next
  Next

  If pNotPendingFooters Then
    m_iRowFormula = m_iRow
    m_iRow2 = m_iRow
  End If
End Sub

Public Sub EvalPost()
  EvalFunctions c_IdxGroupDetail, csRptEvalPost
End Sub

Public Sub EvalPreGroupHeader()
  If m_idxGroupHeader = 0 Then Exit Sub
  EvalFunctions m_idxGroupHeader, csRptEvalPre
End Sub

Public Sub EvalPreGroupFooter()
  If m_idxGroupHeader = 0 Then Exit Sub
  
  Dim idxChildGroupFooter As Long
  
  idxChildGroupFooter = pGetChildGroupFooterToClose(m_idxGroupHeader)
  
  ' Si cerre un grupo superior
  ' tengo que evaluar todos los
  ' subgrupos
  '
  While idxChildGroupFooter > m_idxGroupHeader
    EvalFunctions idxChildGroupFooter * -1, csRptEvalPre
    idxChildGroupFooter = idxChildGroupFooter - 1
  Wend
  
  ' Por ultimo evaluo el grupo que cambio
  '
  EvalFunctions m_idxGroupHeader * -1, csRptEvalPre
End Sub

Public Sub EvalPostGroupHeader()
  If m_idxGroupHeader = 0 Then Exit Sub
  EvalFunctions m_idxGroupHeader, csRptEvalPost
End Sub

Public Sub EvalPostGroupFooter()
  If m_idxGroupHeader = 0 Then Exit Sub
  
  Dim idxChildGroupFooter As Long
  
  idxChildGroupFooter = pGetChildGroupFooterToClose(m_idxGroupHeader)
  
  ' Si cerre un grupo superior
  ' tengo que evaluar todos los
  ' subgrupos
  '
  While idxChildGroupFooter > m_idxGroupHeader
    EvalFunctions idxChildGroupFooter * -1, csRptEvalPost
    idxChildGroupFooter = idxChildGroupFooter - 1
  Wend
  
  ' Por ultimo evaluo el grupo que cambio
  '
  EvalFunctions m_idxGroupHeader * -1, csRptEvalPost
End Sub

Private Function pGetChildGroupFooterToClose(ByVal idxGroupFather As Long) As Long
  Dim j As Long
  For j = idxGroupFather To m_GroupCount
    If m_vGroups(j).FooterMustBeClose Then
      pGetChildGroupFooterToClose = j
    End If
  Next
End Function

Public Sub EvalPre()
  EvalFunctions c_IdxGroupDetail, csRptEvalPre
End Sub

Public Sub MoveToNext()
  ' Paso al siguiente
  m_iRow = m_iRow + 1
  m_iRow2 = m_iRow
  m_iRowFormula = m_iRow

  ' Por ahora tambien pasan al siguiente los
  ' DataSource Adicionales
  Dim IndexRow   As Long
  Dim IndexRows  As Long
  
  For IndexRows = 1 To UBound(m_vCollRows)
    IndexRow = m_vRowsIndexAux(IndexRows) + 1
    If Not IsEmpty(m_vCollRows(IndexRows)) Then
      If IndexRow <= UBound(m_vCollRows(IndexRows), 2) Then
        m_vRowsIndexAux(IndexRows) = IndexRow
      End If
    End If
  Next
End Sub

Private Sub pExistsGroupToReprintInNP()
  Dim i As Long
  
  m_bExistsGrpToRePrintInNP = False
  For i = 1 To m_GroupCount
    If m_Groups.Item(i).RePrintInNewPage Then
      m_bExistsGrpToRePrintInNP = True
      Exit Sub
    End If
  Next
End Sub

Private Function pNotPendingFooters() As Boolean
  Dim i As Long
  
  For i = 1 To m_GroupCount
    If m_vGroups(i).FooterMustBeClose Then Exit Function
  Next
  pNotPendingFooters = True
End Function

' Puede devolver:
' GroupH
' Detail
' GroupF
' End
Public Function GetLineType() As csRptGetLineResult
  Dim rslt As csRptGetLineResult
  
  ' Si hay group footers pendientes de impresion
  '
  If m_idxGroupFooter Then
    If m_vGroups(m_idxGroupFooter).FooterMustBeClose Then
      GetLineType = csRptGetLineResult.csRptGLGroupFooter
      Exit Function
    End If
  End If
  
  ' Si hay group headers pendientes de impresion
  '
  If m_idxGroupHeader Then
    If m_vGroups(m_idxGroupHeader).Changed Then
      GetLineType = csRptGetLineResult.csRptGLGroupHeader
      Exit Function
    End If
  End If
  
  ' Si ya llegue al final del reporte y no hay grupos pendientes
  ' TERMINE
  '
  rslt = pGetLineAuxReportEnd2()
  If rslt = csRptGetLineResult.csRptGLEnd Then
    GetLineType = rslt
    Exit Function
  End If
  
  ' Si hay Group Header:
  '
  ' - que se deben imprimir en una nueva pagina
  ' o
  ' - que se re-impriman por que ESTOY en una nueva pagina
  '
  If m_idxGroupToPrintNP Or m_bHaveToRePrintGroup Then
    GetLineType = csRptGetLineResult.csRptGLVirtualH
    Exit Function
  End If
  
  ' Si hay Group Footers pendientes
  '
  If pEvalFooterToClose2() Then
    GetLineType = csRptGetLineResult.csRptGLVirtualF
    Exit Function
  End If
  
  ' Si ya termine me voy
  '
  If m_iRow > UBound(m_vRowsIndex) And pNotPendingFooters() Then
    GetLineType = csRptGetLineResult.csRptGLEnd
    Exit Function
  End If
  
  ' Si hay Group Header
  '
  If pGetLineAuxPrintHeader() Then
    GetLineType = csRptGetLineResult.csRptGLVirtualH
    Exit Function
  End If
  
  ' Estoy en una linea del detalle
  '
  GetLineType = csRptGetLineResult.csRptGLDetail
End Function

' Devuelve todos los controles de cada linea.
' Para esto recorre el recordset y va devolviendo
' cada linea del detalle
Public Function GetLine(ByRef Fields As cReportPageFields) As csRptGetLineResult
  Dim rslt                As csRptGetLineResult
  Dim bGetNewPage         As Boolean  ' Para imprimir en una nueva pagina
                                      ' el grupo cuando cambia de valor
  
  If Not Fields Is Nothing Then Fields.Clear
  
  ' Si no hay llamadas pendientes a cerrar o abrir grupos
  '
  If Not (m_bCloseFooter Or m_bOpenHeader) Then
  
    ' Si no hay group headers que re-imprimir
    ' en esta pagina
    '
    If Not pExistsGroupHeadersToReprint() Then
      
      ' Evaluo la linea
      '
      rslt = pGetLineWork(Fields, bGetNewPage)
      If bGetNewPage Then
        GetLine = csRptGetLineResult.csRptGLNewPage
        Exit Function
      Else
        If rslt = csRptGetLineResult.csRptGLEnd Or rslt = csRptGetLineResult.csRptGLVirtualF Then
          GetLine = rslt
          Exit Function
        End If
      End If
    End If
  End If
    
  ' Si debo cerrar footers
  '
  If m_bCloseFooter Then
  
    rslt = pGetLineAuxGroupFooter(Fields)
  
  ' Si cambio el grupo
  '
  ElseIf m_bOpenHeader Then
  
    rslt = pGetLineAuxGroupHeader(bGetNewPage, Fields)
    
  ' Linea de datalle
  '
  Else
  
    rslt = pGetLineAuxDetail(Fields)
    
  End If
  
  GetLine = rslt
End Function

Private Function pGetLineWork(ByRef Fields As cReportPageFields, ByRef bGetNewPage As Boolean) As csRptGetLineResult
  Dim rslt                As csRptGetLineResult
  
  ' Si el usuario cancela
  ' TERMINE
  '
  If pGetLineAuxReportCancel() = csRptGetLineResult.csRptGLEnd Then
    pGetLineWork = csRptGetLineResult.csRptGLEnd
    Exit Function
  End If
  
  ' Si ya llegue al final del reporte y no hay grupos pendientes
  ' TERMINE
  '
  rslt = pGetLineAuxReportEnd()
  If rslt = csRptGetLineResult.csRptGLEnd Or rslt = csRptGetLineResult.csRptGLVirtualF Then
    pGetLineWork = rslt
    Exit Function
  End If
  
  ' Creo la bolsa de Fields
  Set Fields = New cReportPageFields
  
  ' Si debo imprimir el grupo en una nueva pagina
  '
  If m_idxGroupToPrintNP Then
    
    pGetLineAuxPrintGroupInNP
  
  ' Sino, evaluo los grupos
  '
  Else
    
    ' Si hay grupos
    If m_GroupCount > 0 Then
      
      ' Si no tengo que reimprimir group headers
      '
      If Not m_bHaveToRePrintGroup Then
        
        pEvalFooterToClose
        
      End If
      
      ' Si no hay Footers pendientes de impresion
      '
      If Not m_bCloseFooter Then
      
        ' Si ya termine me voy
        '
        If pGetLineAuxReportIsDone() = csRptGetLineResult.csRptGLEnd Then
          pGetLineWork = csRptGetLineResult.csRptGLEnd
          Exit Function
        End If
        
        ' Sigo evaluando grupos
        '
        pGetLineAuxDoGroups bGetNewPage
        
      End If ' Si no hay Footers pendientes de impresion
    End If ' Si hay grupos
  End If ' Evaluo los grupos
End Function
            
Private Sub pGetLineAuxPrintGroupInNP()
  m_idxGroupHeader = m_idxGroupToPrintNP
  m_idxGroupToPrintNP = 0
  m_bOpenHeader = True
End Sub

Private Function pGetLineAuxReportEnd2() As csRptGetLineResult
  ' Si termine solo devuelvo csRptGLEnd
  ' y me voy
  '
  If IsEmpty(m_vRows) Or m_iRow > m_RecordCount Then
  
    ' Si no quedan footers pendientes
    ' termine
    If Not m_bPrintFooter Then
      pGetLineAuxReportEnd2 = csRptGetLineResult.csRptGLEnd
    End If
  End If
End Function

Private Function pGetLineAuxReportEnd() As csRptGetLineResult
  ' Si termine solo devuelvo csRptGLEnd
  ' y me voy
  '
  If IsEmpty(m_vRows) Or m_iRow > m_RecordCount Then
  
    If m_iRow > m_RecordCount Then m_iRow2 = m_RecordCount
  
    ' Si quedan footers pendientes los imprimo
    '
    If m_bPrintFooter Then
    
      ' Si tengo que evaluar las funciones que se compilan
      ' antes de imprimir
      '
      If m_bEvalPreGroups Then
        
        pGetLineAuxReportEnd = csRptGetLineResult.csRptGLVirtualF
        
        ' Para que la proxima llamada imprima el footer
        '
        m_bEvalPreGroups = False
      
      Else
        
        If Not m_bLastFootersWasPrinted Then
          ' Prendo un flag para saber que
          ' he comenzado a cerrar los groups footers
          ' que quedan pendientes
          m_bLastFootersWasPrinted = True
    
          ' Como ya termine voy a cerrar todos los groups footers
          m_GroupIndexChange = 1
    
          ' Prendo el flag del ultimo grupo para que se imprima en
          ' esta vuelta, y en las siguientes llamadas se imprimiran
          ' los demas grupos
          m_vGroups(UBound(m_vGroups)).FooterMustBeClose = True
        
        End If
      End If
  
    ' Si no quedan footers pendientes
    ' termine
    Else
      pGetLineAuxReportEnd = csRptGetLineResult.csRptGLEnd
      ReportDone
      Exit Function
    End If
  End If
End Function

Private Function pGetLineAuxReportCancel() As csRptGetLineResult
  ' Si el usuario cancela termino
  If Not ShowProgress(vbNullString, 0, m_iRow, m_RecordCount) Then
    pGetLineAuxReportCancel = csRptGetLineResult.csRptGLEnd
    ReportDone
    Exit Function
  End If
End Function

Private Function pGetLineAuxReportIsDone() As csRptGetLineResult
  ' Si estaba imprimiendo el ultimo Footer
  '
  ' TERMINE
  '
  If m_iRow > UBound(m_vRowsIndex) And pNotPendingFooters() Then
    pGetLineAuxReportIsDone = csRptGetLineResult.csRptGLEnd
    ReportDone
    m_bPrintFooter = False
    
    ' SE TERMINO LA IMPRESION
    '
    Exit Function
  End If
End Function

Private Function pEvalFooterToClose2() As Boolean
  Dim i As Integer
  For i = m_GroupCount To 1 Step -1
    If m_vGroups(i).FooterMustBeClose Then
      pEvalFooterToClose2 = True
      Exit For
    End If
  Next
End Function

Private Function pEvalFooterToClose() As Boolean
  Dim i As Integer
  For i = m_GroupCount To 1 Step -1
    If m_vGroups(i).FooterMustBeClose Then
      m_idxGroupFooter = i

      ' Solo hasta el footer correspondiente al grupo que cambio
      '
      If m_idxGroupFooter > m_GroupIndexChange Then

        ' Tengo que cerrar el siguiente
        '
        m_vGroups(m_idxGroupFooter - 1).FooterMustBeClose = True
      End If

      m_bCloseFooter = True
      Exit For
    End If
  Next
  
  pEvalFooterToClose = m_bCloseFooter
End Function

Private Function pGetLineAuxPrintHeader() As Boolean
  Dim i As Integer
  
  pGetLineAuxPrintHeader = True
  
  ' continuo evaluando los grupos
  '
  For i = 1 To m_GroupCount
  
    With m_vGroups(i)

      If Not .GrandTotalGroup Then
      
        If IsEmpty(.Value) Then Exit Function
        
        Select Case .ComparisonType
          Case csRptGrpComparisonType.csRptGrpText
            If .Value <> LCase$(ValVariant(m_vRows(.IndiceField, m_vRowsIndex(m_iRow2)))) Then
              Exit Function
            End If
          Case csRptGrpComparisonType.csRptGrpNumber
            If .Value <> Val(ValVariant(m_vRows(.IndiceField, m_vRowsIndex(m_iRow2)))) Then
              Exit Function
            End If
  
          Case csRptGrpComparisonType.csRptGrpDate
            If .Value <> DateValue(ValVariant(m_vRows(.IndiceField, m_vRowsIndex(m_iRow2)))) Then
              Exit Function
            End If
        End Select
      
      End If
    End With
  Next
  
  pGetLineAuxPrintHeader = False
End Function

Private Function OrderDateAsc(ByVal First As Long, ByVal Last As Long, ByVal OrderBy As Long) As Boolean
  Dim i As Long
  Dim j As Long
  Dim t As Long
  Dim q As Long
  Dim bChanged As Boolean
  
  t = pEstimateLoops(Last - First)
  For i = First + 1 To Last
    bChanged = False
    For j = Last To i Step -1
      q = q + 1
      If DateValue(ValVariant(m_vRows(OrderBy, m_vRowsIndex(j)))) _
       < DateValue(ValVariant(m_vRows(OrderBy, m_vRowsIndex(j - 1)))) Then
        If Not ShowProgress(vbNullString, 0, q, t) Then Exit Function
        ChangeRow j, j - 1
        bChanged = True
      End If
    Next
    If Not ShowProgress(vbNullString, 0, q, t) Then Exit Function
    If Not bChanged Then Exit For
  Next
  
  OrderDateAsc = True
End Function
  
Private Function OrderDateDesc(ByVal First As Long, ByVal Last As Long, ByVal OrderBy As Long) As Boolean
  Dim i As Long
  Dim j As Long
  Dim t As Long
  Dim q As Long
  Dim bChanged As Boolean
  
  t = pEstimateLoops(Last - First)
  For i = First + 1 To Last
    bChanged = False
    For j = Last To i Step -1
      q = q + 1
      If DateValue(ValVariant(m_vRows(OrderBy, m_vRowsIndex(j)))) _
       > DateValue(ValVariant(m_vRows(OrderBy, m_vRowsIndex(j - 1)))) Then
        If Not ShowProgress(vbNullString, 0, q, t) Then Exit Function
        ChangeRow j, j - 1
        bChanged = True
      End If
    Next
    If Not ShowProgress(vbNullString, 0, q, t) Then Exit Function
    If Not bChanged Then Exit For
  Next
  
  OrderDateDesc = True
End Function

Private Sub pGetLineAuxDoGroups(ByRef bGetNewPage As Boolean)
  Dim i As Integer
  
  
  ' continuo evaluando los grupos
  '
  For i = 1 To m_GroupCount
  
    With m_vGroups(i)

      ' Si cambio el grupo
      '
      ' Aca solo entro cuando:
      '
      '  - cambio un grupo en una llamada anterior
      '    a GetLine, y ya cerre todos los GroupsFooter
      '    en llamadas anteriores a GetLine o
      '
      '  - estoy en una nueva pagina y tengo que
      '    reimprimir group headers
      '
      If .Changed Then
        
        pGroupChanged i, bGetNewPage
        Exit For
      
      Else
      
        pEvalGroupChange i
      
        If .Changed Then
          
          m_idxGroupHeader = i

          ' Primara vez que imprimo grupos
          '
          If m_FirstGroup Then

            pOpenGroupHeader i
            
          Else
            
            ' Lo primero que hay que hacer es
            ' cerrar los footers
            pCloseGroupFooters i
          End If
          
          Exit For
          
        End If
      End If
    End With
  Next
End Sub

Private Sub pCloseGroupFooters(ByVal i As Integer)
  ' Guardo hasta que footer tengo que cerrar
  '
  m_GroupIndexChange = i

  m_bCloseFooter = True
  m_idxGroupFooter = m_GroupCount

  ' Cuando cambia un grupo se cierra desde el mas
  ' pequeño hasta el grupo que cambio (m_GroupIndexChange)
  '
  Dim j As Long
  
  For j = m_GroupIndexChange To m_idxGroupFooter
    m_vGroups(j).FooterMustBeClose = True
  Next
  
End Sub

Private Sub pOpenGroupHeader(ByVal i As Integer)
  
  ' Para imprimir los ultimos footers
  m_bLastFootersWasPrinted = False

  m_vGroups(i).Changed = False

  m_idxGroupHeader = i
  
  ' Para cerrar el proximo grupo en una llamada
  ' posterior a GetLine. Solo si hay mas grupos
  If i < m_GroupCount Then m_vGroups(i + 1).Changed = True

  m_bOpenHeader = True
End Sub

Private Sub pEvalGroupChange(ByVal i As Integer)
  With m_vGroups(i)
  
    If .GrandTotalGroup Then
    
      If IsEmpty(.Value) Then
        .Changed = True
        .Value = "1"
        If Not m_FirstGroup Then .FooterMustBeClose = True
        pEvalGroupChangedAux i + 1
      End If
    Else
  
      Select Case .ComparisonType
        Case csRptGrpComparisonType.csRptGrpText
          If IsEmpty(.Value) Then
            GoTo ChangeText
          ElseIf .Value <> LCase$(ValVariant(m_vRows(.IndiceField, m_vRowsIndex(m_iRow2)))) Then
ChangeText:
            .Value = LCase$(ValVariant(m_vRows(.IndiceField, m_vRowsIndex(m_iRow2))))
            .Changed = True
            If Not m_FirstGroup Then .FooterMustBeClose = True
            pEvalGroupChangedAux i + 1
          End If
  
        Case csRptGrpComparisonType.csRptGrpNumber
          If IsEmpty(.Value) Then
            GoTo ChangeNumber
          ElseIf .Value <> Val(ValVariant(m_vRows(.IndiceField, m_vRowsIndex(m_iRow2)))) Then
ChangeNumber:
            .Value = Val(ValVariant(m_vRows(.IndiceField, m_vRowsIndex(m_iRow2))))
            .Changed = True
            If Not m_FirstGroup Then .FooterMustBeClose = True
            pEvalGroupChangedAux i + 1
          End If
  
        Case csRptGrpComparisonType.csRptGrpDate
          If IsEmpty(.Value) Then
            GoTo ChangeDate
          ElseIf .Value <> DateValue(ValVariant(m_vRows(.IndiceField, m_vRowsIndex(m_iRow2)))) Then
ChangeDate:
            .Value = DateValue(ValVariant(m_vRows(.IndiceField, m_vRowsIndex(m_iRow2))))
            .Changed = True
            If Not m_FirstGroup Then .FooterMustBeClose = True
            pEvalGroupChangedAux i + 1
          End If
      End Select
    End If
  End With
End Sub

Private Sub pEvalGroupChangedAux(ByVal i As Integer)
  For i = i To m_GroupCount
    pGroupChangedAux i
  Next
End Sub

Private Sub pGroupChangedAux(ByVal i As Integer)
  With m_vGroups(i)
    Select Case .ComparisonType
      Case csRptGrpComparisonType.csRptGrpText
        .Value = LCase$(ValVariant(m_vRows(.IndiceField, m_vRowsIndex(m_iRow2))))
  
      Case csRptGrpComparisonType.csRptGrpNumber
        .Value = Val(ValVariant(m_vRows(.IndiceField, m_vRowsIndex(m_iRow2))))
  
      Case csRptGrpComparisonType.csRptGrpDate
        .Value = DateValue(ValVariant(m_vRows(.IndiceField, m_vRowsIndex(m_iRow2))))
    End Select
  End With
End Sub

Private Sub pGroupChanged(ByVal i As Integer, _
                          ByRef bGetNewPage As Boolean)
  m_idxGroupHeader = i
  
  pGroupChangedAux i
  
  With m_vGroups(i)
    
    bGetNewPage = m_Groups.Item(i).PrintInNewPage And Not m_FirstGroup
    m_idxGroupHeader = i
  End With
  
  If bGetNewPage Then
    m_idxGroupToPrintNP = i  ' Al darle un valor <> 0 estoy indicando que este grupo
                             ' debe ser impreso en una nueva pagina
  Else
    m_idxGroupToPrintNP = 0
  End If

  ' Para abrir el proximo grupo en una llamada
  ' posterior a GetLine. Solo si hay mas grupos
  '
  If i < m_GroupCount Then m_vGroups(i + 1).Changed = True
  
  m_bOpenHeader = True
End Sub

Private Function pGetLineAuxGroupFooter(ByRef Fields As cReportPageFields) As csRptGetLineResult
  
  Dim FooterSec           As cReportSection
  Dim ctrl                As cReportControl
  Dim SecLn               As cReportSectionLine

  ' Si tengo que evaluar las funciones que se compilan
  ' antes de imprimir
  '
  If m_bEvalPreGroups Then
    
    ' Al evaluar las formulas debo usar la fila anterior
    ' ya que estoy cerrando los grupos por que detecte que
    ' la fila actual ya no pertenece al grupo que estoy cerrando
    ' esta logica tambien es valida para cuando m_iRow > ubound(m_vRows)
    '
    ' Nota cuando termino de imprimir los footers devuelvo
    ' m_iRowFormula y m_iRow2 a sus valores originales
    '
    m_iRowFormula = m_iRow - 1
    m_iRow2 = m_iRow - 1
    
    pGetLineAuxGroupFooter = csRptGetLineResult.csRptGLVirtualF
    
    ' Para que la proxima llamada imprima el footer
    '
    m_bEvalPreGroups = False
  
  Else
    
    ' Si hay mas footers en la proxima vuelta se vuelve
    ' a prender el flag
    '
    m_bCloseFooter = False
    
    ' Para que la proxima llamada devuelva csRptGLVirtualF
    '
    m_bEvalPreGroups = True

    Set FooterSec = m_Groups.Item(m_idxGroupFooter).Footer
  
    pGetLineAuxGroupFooter = csRptGetLineResult.csRptGLGroupFooter
  
    GetLineAux FooterSec, Fields
  End If
End Function

Private Function pGetLineAuxGroupHeader(ByVal bGetNewPage As Boolean, _
                                        ByRef Fields As cReportPageFields) As csRptGetLineResult
  Dim HeaderSec As cReportSection
  Dim SecLn     As cReportSectionLine
  Dim ctrl      As cReportControl
  
  If bGetNewPage And Not m_FirstGroup Then
    
    ' En group headers y details la linea de formulas es
    ' la linea actual
    '
    m_iRowFormula = m_iRow
    
    pGetLineAuxGroupHeader = csRptGetLineResult.csRptGLNewPage
  
  Else

    ' Si tengo que evaluar las funciones que se compilan
    ' antes de imprimir
    '
    If m_bEvalPreGroups Then
      
      ' Si no estoy re-imprimiendo groups headers
      '
      If Not m_bHaveToRePrintGroup Then
      
        ' En group headers y details la linea de formulas es
        ' la linea actual
        '
        m_iRowFormula = m_iRow
      End If
      
      pGetLineAuxGroupHeader = csRptGetLineResult.csRptGLVirtualH
      
      ' Para que la proxima llamada imprima el footer
      '
      m_bEvalPreGroups = False
    
    Else
      
      m_bOpenHeader = False
      
      ' Para que la proxima llamada devuelva csRptGLVirtualF
      '
      m_bEvalPreGroups = True
      
      ' Devuelvo una linea con el grupo
      '
      pGetLineAuxGroupHeader = csRptGetLineResult.csRptGLGroupHeader
    
      Set HeaderSec = m_Groups.Item(m_idxGroupHeader).Header
      
      GetLineAux HeaderSec, Fields
    
      ' Prendo un flag para saber que hay footers pendientes
      '
      m_bPrintFooter = True
    
    End If
  End If
End Function
                                                                    
Private Function pGetLineAuxDetail(ByRef Fields As cReportPageFields) As csRptGetLineResult
  m_FirstGroup = False

  GetLineAux m_Details.Item(1), Fields

  ' devuelvo una linea de datos
  '
  pGetLineAuxDetail = csRptGetLineResult.csRptGLDetail
End Function

Private Function GetLineAux(ByRef Sec As cReportSection, ByRef Fields As cReportPageFields)
  ' Por cada control de cada sectionline de la
  ' seccion que recibi genero un PageField
  Dim Field       As cReportPageField
  Dim SecLn       As cReportSectionLine
  Dim ctrl        As cReportControl
  Dim IsVisible   As Boolean
  Dim indexCtrl   As Long
  
  ' Estos indices son:
  Dim IndexRows  As Long  ' En que DataSource estas
  Dim IndexRow   As Long  ' En que fila de ese DataSource estas
  Dim IndexField As Long
  
  If Sec.HasFormulaHide Then
    IsVisible = Val(m_Compiler.ResultFunction(Sec.FormulaHide))
  Else
    IsVisible = True
  End If
  
  If IsVisible Then
    ' Por cada section line de la seccion que recibi
    For Each SecLn In Sec.SectionLines
      m_LineIndex = m_LineIndex + 1
      
      If SecLn.HasFormulaHide Then
      
        m_Compiler.EvalFunction SecLn.FormulaHide
      
        IsVisible = Val(m_Compiler.ResultFunction(SecLn.FormulaHide))
      Else
        IsVisible = True
      End If
    
      If IsVisible Then
        
        ' Por cada control en el section line
        '
        For indexCtrl = 1 To UBound(SecLn.Controls.CollByLeft)
        
          Set ctrl = SecLn.Controls.Item(SecLn.Controls.CollByLeft(indexCtrl))
      
          ' Agrego un nuevo Field en la bolsa
          Set Field = Fields.Add()
          
          Field.IndexLine = m_LineIndex
          
          With ctrl
            
            If .HasFormulaValue Then
      
              Field.Value = Format(m_Compiler.ResultFunction(.FormulaValue), .Label.Aspect.Format)
      
            Else
              Select Case .ControlType
                Case csRptControlType.csRptCtField
                  
                  pGetIndexRows IndexRows, IndexRow, IndexField, ctrl
                  
                  If Not IsEmpty(m_vCollRows(IndexRows)) Then
                    
                                                   ' Que feo que se ve esto no????
                                                   ' Esto se lee asi:
                                                   '    m_vCollRows(IndexRows)    Matriz con los datos del DataSource
                                                   '                              mencionado por el control
                                                   '
                                                   '    (IndexField, IndexRow)  Elemento dentro de dicha matriz
                                                   '
                                                   'm_vCollRows(IndexRows)(IndexField, IndexRow)'
                                                   '                                            '
                                                   ' Ahora si?                                  '
                                                   '                                            '
                    Field.Value = Format(ValVariant(m_vCollRows(IndexRows)(IndexField, IndexRow)), .Label.Aspect.Format)
                  End If
                
                Case csRptControlType.csRptCtLabel
                  With .Label
                    Field.Value = Format(.text, .Aspect.Format)
                  End With
                Case csRptControlType.csRptCtImage
                  With .Label
                    Field.Value = Format(.text, .Aspect.Format)
                  End With
                  Field.hImage = .Image.hImage
                  
                Case csRptControlType.csRptCtDbImage
                
                  pGetIndexRows IndexRows, IndexRow, IndexField, ctrl
                  
                  If Not IsEmpty(m_vCollRows(IndexRows)) Then
                    
                    Field.hImage = pGetImage(IndexRows, IndexField, IndexRow)
                  End If
                
                Case csRptControlType.csRptCtChart
                  
                  pGetIndexRows IndexRows, IndexRow, IndexField, ctrl
                  
                  Field.hImage = pGetChartImage(IndexRows, IndexField, IndexRow, ctrl)
                  
              End Select
            End If
      
            If .HasFormulaHide Then
      
              Field.Visible = Val(m_Compiler.ResultFunction(.FormulaHide))
      
            Else
              Field.Visible = True
            End If
      
            ' Le doy la direccion del info
            Set Field.Info = m_PageSetting.Item(.Key)
          End With
        Next
      End If
    Next
  End If
End Function

' IndexRows     En que DataSource estas
' IndexRow      En que fila de ese DataSource estas
'
Private Sub pGetIndexRows(ByRef IndexRows As Long, _
                          ByRef IndexRow As Long, _
                          ByRef IndexField As Long, _
                          ByRef ctrl As cReportControl)
  
  With ctrl
  
    IndexRows = Fix(.Field.Index / 1000) ' Recuerden que separe los indices de cada
                                         ' DataSource de 1000 en 1000
    
    IndexField = .Field.Index - (IndexRows * 1000)
    
    If IndexRows = 0 Then
      IndexRow = m_vRowsIndex(m_iRow2)
    Else
      IndexRow = m_vRowsIndexAux(IndexRows)
    End If
  End With
End Sub

Public Function Init(ByRef oLaunchInfo As cReportLaunchInfo) As Boolean
'  On Error GoTo ControlError
  
  SetLaunchInfo oLaunchInfo
  Init = True
  
  GoTo ExitProc
ControlError:
  MngError Err(), "Init", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

' Dispara el reporte
Public Function Launch(Optional ByRef oLaunchInfo As cReportLaunchInfo = Nothing) As Boolean
  On Error GoTo ControlError
  
  Dim errNumber As Long
  Dim errSource As String
  Dim errDescription As String
  Dim errHelpfile As String
  Dim errHelpcontext As Long
  
  Dim Recordsets  As Collection
  Dim rs          As ADODB.Recordset
  
  Set m_Compiler.Report = Me
  m_Compiler.InitGlobalObject
  
  If oLaunchInfo Is Nothing Then
    If m_LaunchInfo Is Nothing Then
      Err.Raise csRptErrors.csRptErrLaunchInfoIndefined, C_Module, errGetDescript(csRptErrors.csRptErrLaunchInfoIndefined)
    End If
  Else
    SetLaunchInfo oLaunchInfo
  End If
  
  If m_LaunchInfo.Printer Is Nothing Then
    Err.Raise csRptErrors.csRptErrLaunchInfoIndefined, C_Module, errGetDescript(csRptErrors.csRptErrPrinterNotDefined)
  End If
  
  If Not ShowProgress("Preparando el reporte") Then Exit Function
  
  ' Ordeno en funcion del zorder
  SortCollection
  
  If Not ShowProgress("Compilando el reporte") Then Exit Function
  
  ' Compilo el reporte
  If Not CompileReport() Then Exit Function
  
  pSortControlsByLeft
  
  If Not ShowProgress("Consultando la base de datos") Then Exit Function
  
  Set Recordsets = New Collection
  
  ReDim m_vCollRows(0)
  
  ' Abro el recordset
  If Not pGetData(m_vRows, rs, m_Connect, True, Recordsets) Then Exit Function
  
  ' En la primear posicion va el recordset principal
  m_vCollRows(0) = m_vRows
  
  pInitImages
  
  ' Abro Conexiones auxiliares
  If Not pGetDataAux(Recordsets) Then Exit Function
  
  If Not InitGroups(rs, pGetMainDataSource(Recordsets)) Then Exit Function
  
  If Not ShowProgress("Inicializando el reporte") Then Exit Function
  
  If Not InitControls(Recordsets) Then Exit Function
  
  ' Creo la definicion de este objeto
  If Not CreatePageSetting() Then Exit Function
  
  m_Pages.Clear
  
  m_LineIndex = 0
  
  ' Inicializacion de globales
  '
  m_bPrintFooter = False
  m_bLastFootersWasPrinted = False
  m_GroupIndexChange = 0
  m_iRow2 = 0
  m_iRowFormula = 0
  pSetGroupFormulaHeaders
  
  '//////////////////////////////////////////
  ' 2008-02-18 WARNING esto puede traer problemas
  pSetGroupsInCtrlFormulaHide
  '//////////////////////////////////////////
                            
  pSetIndexColInGroupFormulas Recordsets
                            
  pInitRowFormulas
  pExistsGroupToReprintInNP ' Averiguo si hay grupos que se reimprimen
  m_bEvalPreGroups = True   ' Para que se evaluen los grupos de la primera pagina
  m_bCloseFooter = False
  m_bOpenHeader = False
  
  Dim Formula As cReportFormula
  For Each Formula In m_Formulas
    Formula.HaveToEval = True
  Next
  
  ' Ahora lanzo (todo lo que comi hoy jeje)
  Set m_LaunchInfo.ObjPaint.Report = Me
  If Not m_LaunchInfo.ObjPaint.MakeReport() Then Exit Function
  
  Select Case m_LaunchInfo.Action
    Case csRptLaunchAction.csRptLaunchPrinter
      If Not m_LaunchInfo.ObjPaint.PrintReport() Then Exit Function
    Case csRptLaunchAction.csRptLaunchFile
      If Not m_LaunchInfo.ObjPaint.MakeXml() Then Exit Function
    Case csRptLaunchAction.csRptLaunchPreview
      If Not m_LaunchInfo.ObjPaint.PreviewReport() Then Exit Function
  End Select
  
  Launch = True
  GoTo ExitProc
ControlError:
  
  If Err.Number Then
    
    errNumber = Err.Number
    errSource = Err.Source
    errDescription = Err.Description
    errHelpfile = Err.HelpFile
    errHelpcontext = Err.HelpContext
    
    Resume ExitProc
    
  End If
  
ExitProc:
  On Error Resume Next
  
  Set m_Compiler.Report = Nothing
  
  ' Si imprimi a un destino distinto a preview
  ' elimino las referencias cruzadas entre
  ' cReport y cReportLaunchInfo
  '
  If m_LaunchInfo.Action <> csRptLaunchAction.csRptLaunchPreview Then
    Set m_LaunchInfo.ObjPaint.Report = Nothing
    Set m_LaunchInfo.ObjPaint = Nothing
  End If
  
  On Error GoTo 0

  If errNumber Then
    Err.Raise errNumber, errSource, errDescription, errHelpfile, errHelpcontext
  End If
End Function

Public Function LoadSilent(ByVal FileName As String) As Boolean
  On Error GoTo ControlError
  
  Dim DocXml As CSXml2.cXml
  Set DocXml = New CSXml2.cXml
  
  Dim f As CSKernelFile.cFile
  Set f = New CSKernelFile.cFile
  
  m_Path = f.GetPath(FileName)
  m_Name = f.GetFileName(FileName)
  
  DocXml.Init Nothing
  DocXml.Filter = c_FileEx
  DocXml.Name = m_Name
  DocXml.Path = m_Path
  
  If Not DocXml.OpenXml() Then Exit Function
  
  m_Path = DocXml.Path
  m_Name = DocXml.Name
  m_ReportDisconnected = DocXml.GetNodeProperty(DocXml.GetRootNode(), "ReportDisconnected").Value(csBoolean)
  
  LoadSilent = nLoad(DocXml)
  
  Exit Function
ControlError:
  MngError Err, "LoadSilent", C_Module, vbNullString
End Function

Public Function Load(ByRef CommDialog As Object) As Boolean
  On Error GoTo ControlError
  
  Dim DocXml As CSXml2.cXml
  Set DocXml = New CSXml2.cXml
  
  DocXml.Init CommDialog
  DocXml.Filter = c_FileEx
  
  If LenB(m_Name) > 0 Then
    DocXml.Name = m_Name
  Else
    DocXml.Path = m_PathDefault & "\*." & c_FileEx
  End If
  
  DocXml.Path = m_Path
  
  If Not DocXml.OpenXmlWithDialog() Then Exit Function
  
  m_Path = DocXml.Path
  m_Name = DocXml.Name
  m_ReportDisconnected = DocXml.GetNodeProperty(DocXml.GetRootNode(), "ReportDisconnected").Value(csBoolean)
  
  Load = nLoad(DocXml)
  
  Exit Function
ControlError:
  MngError Err, "Load", C_Module, vbNullString
End Function

Public Function Save(ByRef CommDialog As Object, Optional ByVal WithDialog As Boolean = True) As Boolean
#If Not PREPROC_SFS Then
  Dim DocXml As CSXml2.cXml
  Set DocXml = New CSXml2.cXml
  
  DocXml.Init CommDialog
  DocXml.Filter = c_FileEx
  DocXml.Name = m_Name
  DocXml.Path = m_Path
  
  If WithDialog Then
    If Not DocXml.NewXmlWithDialog() Then Exit Function
  Else
    If Not DocXml.NewXml() Then Exit Function
  End If
  
  m_Name = DocXml.Name
  m_Path = DocXml.Path
  
  Dim xProperty As CSXml2.cXmlProperty
  Set xProperty = New CSXml2.cXmlProperty
  
  xProperty.Name = "RptName"
  xProperty.Value(csText) = m_Name
  DocXml.AddProperty xProperty
  
  xProperty.Name = "ReportDisconnected"
  xProperty.Value(csBoolean) = m_ReportDisconnected
  DocXml.AddProperty xProperty
  
  ' Secciones
  Dim Sec As cReportSection
  Dim NodObj As Object
  
  If Not m_Connect.Save(DocXml, Nothing) Then Exit Function
  If Not m_ConnectsAux.Save(DocXml, Nothing) Then Exit Function
  If Not m_LaunchInfo.Save(DocXml, Nothing) Then Exit Function
  
  xProperty.Name = c_NodeRptHeaders
  xProperty.Value(csText) = vbNullString
  Set NodObj = DocXml.AddNode(xProperty)
  
  For Each Sec In m_Headers
    Sec.Save DocXml, NodObj
  Next
  
  xProperty.Name = c_NodeRptDetails
  xProperty.Value(csText) = vbNullString
  Set NodObj = DocXml.AddNode(xProperty)
  
  For Each Sec In m_Details
    Sec.Save DocXml, NodObj
  Next
  
  xProperty.Name = c_NodeRptFooters
  xProperty.Value(csText) = vbNullString
  Set NodObj = DocXml.AddNode(xProperty)
  
  For Each Sec In m_Footers
    Sec.Save DocXml, NodObj
  Next
  
  xProperty.Name = c_NodeGroups
  xProperty.Value(csText) = vbNullString
  Set NodObj = DocXml.AddNode(xProperty)
  
  Dim Group As cReportGroup
  
  For Each Group In m_Groups
    Group.Save DocXml, NodObj
  Next
  
  xProperty.Name = c_NodeRptFormulas
  xProperty.Value(csText) = vbNullString
  Set NodObj = DocXml.AddNode(xProperty)
  
  Dim Formula As cReportFormula
  For Each Formula In m_Formulas
    If Not Formula.NotSave Then
      Formula.Save DocXml, NodObj
    End If
  Next
  
  xProperty.Name = c_NodePaperInfo
  xProperty.Value(csText) = vbNullString
  Set NodObj = DocXml.AddNode(xProperty)
  m_PaperInfo.Save DocXml, NodObj
  
  If Not DocXml.Save() Then Exit Function
  
  If Not DocXml.OpenXml() Then Exit Function
  
  If Not nLoad(DocXml) Then Exit Function
  
#End If
  Save = True
End Function

Public Function LoadSilentData(ByVal FileName As String) As Boolean
  Dim DocXml As CSXml2.cXml
  Set DocXml = New CSXml2.cXml
  
  Dim f As CSKernelFile.cFile
  Set f = New CSKernelFile.cFile
  
  m_Path = f.GetPath(FileName)
  m_Name = f.GetFileName(FileName)
  
  DocXml.Init Nothing
  DocXml.Filter = c_FileDataEx
  DocXml.Name = m_Name
  DocXml.Path = m_Path
  
  If Not DocXml.OpenXml() Then Exit Function
  
  m_Path = DocXml.Path
  m_Name = DocXml.Name
  m_ReportDisconnected = DocXml.GetNodeProperty(DocXml.GetRootNode(), "ReportDisconnected").Value(csBoolean)
    
  LoadSilentData = nLoadData(DocXml)
End Function

Public Function LoadData(ByRef CommDialog As Object) As Boolean
  Dim DocXml As CSXml2.cXml
  Set DocXml = New CSXml2.cXml
  
  DocXml.Init CommDialog
  DocXml.Filter = c_FileDataEx
  DocXml.Name = m_Name
  DocXml.Path = m_Path
  
  If Not DocXml.OpenXmlWithDialog() Then Exit Function
  
  m_Path = DocXml.Path
  m_Name = DocXml.Name
  m_ReportDisconnected = DocXml.GetNodeProperty(DocXml.GetRootNode(), "ReportDisconnected").Value(csBoolean)
    
  LoadData = nLoadData(DocXml)
End Function

Public Function SaveData(ByRef CommDialog As Object, Optional ByVal WithDialog As Boolean = True) As Boolean
#If Not PREPROC_SFS Then
  Dim DocXml As CSXml2.cXml
  Set DocXml = New CSXml2.cXml
  
  DocXml.Init CommDialog
  DocXml.Filter = c_FileDataEx
  DocXml.Name = GetFileName(m_Name) & "-data.csd"
  DocXml.Path = m_Path
  
  If WithDialog Then
    If Not DocXml.NewXmlWithDialog() Then Exit Function
  Else
    If Not DocXml.NewXml() Then Exit Function
  End If
  
  DoEvents
  
  Dim Mouse As CSKernelClient2.cMouse
  Dim DataName As String
  Dim DataPath As String
  
  Set Mouse = New CSKernelClient2.cMouse
  Mouse.MouseWait
  
  DataName = DocXml.Name
  DataPath = DocXml.Path
  
  Dim xProperty As CSXml2.cXmlProperty
  Set xProperty = New CSXml2.cXmlProperty
  
  xProperty.Name = "RptName"
  xProperty.Value(csText) = DataName
  DocXml.AddProperty (xProperty)
  
  ' Configuracion de paginas
  Dim NodObj As Object
  Dim NodObjAux As Object
  
  ' Paginas
  Dim Page As cReportPage
  
  xProperty.Name = c_NodeRptPages
  xProperty.Value(csText) = vbNullString
  Set NodObj = DocXml.AddNode(xProperty)
  
  For Each Page In m_Pages
    Page.Save DocXml, NodObj
    If Not SaveDataForWeb(Page, DataName, DataPath) Then Exit Function
  Next
  
  If Not DocXml.Save() Then Exit Function
  
  If Not DocXml.OpenXml() Then Exit Function
  
  If Not nLoadData(DocXml) Then Exit Function
  
  Mouse.MouseDefault
  
#End If

  SaveData = True

End Function

Private Function SaveDataForWeb(ByRef Page As cReportPage, ByVal DataName As String, ByVal DataPath As String) As Boolean
#If Not PREPROC_SFS Then
  Dim DocXml As CSXml2.cXml
  Set DocXml = New CSXml2.cXml
  
  DocXml.Init Nothing
  DocXml.Filter = "xml"
  DocXml.Name = GetFileName(DataName) & "-1.xml"
  DocXml.Path = DataPath
  
  If Not DocXml.NewXml() Then Exit Function
  
  DataName = DocXml.Name
  
  Dim xProperty As CSXml2.cXmlProperty
  Set xProperty = New CSXml2.cXmlProperty
  
  xProperty.Name = "Page_" & Page.PageNumber
  xProperty.Value(csText) = DataName
  DocXml.AddProperty (xProperty)
  
  Dim NodObj As Object
  
  xProperty.Name = "Page"
  xProperty.Value(csText) = vbNullString
  Set NodObj = DocXml.AddNode(xProperty)
  
  Page.SaveForWeb DocXml, NodObj
  
  SaveDataForWeb = DocXml.Save()
  
#Else
  
  SaveDataForWeb = True

#End If
End Function

' funciones friend
Friend Function GetValueFromRs(ByVal ColIndex As Long) As Variant
  GetValueFromRs = m_vRows(ColIndex, m_vRowsIndex(m_iRow2))
End Function

Friend Function GetValue(ByVal ControlName As String, Optional ByVal NotFormat As Boolean = False) As Variant
  Dim ctrl  As cReportControl
  Dim Found As Boolean
  Dim iRow  As Long
  
  If m_iRowFormula > UBound(m_vRowsIndex) Then
    iRow = UBound(m_vRowsIndex)
  Else
    iRow = m_iRowFormula
  End If
  
  For Each ctrl In m_Controls
    If UCase(ctrl.Name) = UCase(ControlName) Then
      Found = True
      Exit For
    End If
  Next
  
  If Not Found Then
    Err.Raise csRptErrors.csRptErrControlNotFound, C_Module, errGetDescript(csRptErrors.csRptErrControlNotFound, ControlName)
  End If
  
  With ctrl
    Select Case .ControlType
      
      Case csRptControlType.csRptCtField
      
        ' Estos indices son:
        Dim IndexRows   As Long  ' En que DataSource estas
        Dim IndexRow    As Long  ' En que fila de ese DataSource estas
        Dim IndexField  As Long
        
        IndexRows = Fix(.Field.Index / 1000) ' Recuerden que separe los indices de cada
                                             ' DataSource de 1000 en 1000
        
        IndexField = .Field.Index - (IndexRows * 1000)
        
        If IndexRows = 0 Then
          IndexRow = m_vRowsIndex(iRow)
        Else
          IndexRow = m_vRowsIndexAux(IndexRows)
        End If
        
        If Not IsEmpty(m_vCollRows(IndexRows)) Then
          If LenB(.Label.Aspect.Format) > 0 And NotFormat = False Then
                                        ' Que feo que se ve esto no????
                                        ' Esto se lee asi:
                                        '    m_vCollRows(IndexRows)    Matriz con los datos del DataSource
                                        '                              mencionado por el control
                                        '
                                        '    (IndexField, IndexRow)  Elemento dentro de dicha matriz
                                        '
                                        'm_vCollRows(IndexRows)(IndexField, IndexRow)'
                                        '                                              '
                                        ' Ahora si?                                    '
                                        '                                              '
            GetValue = Format(ValVariant(m_vCollRows(IndexRows)(IndexField, IndexRow)), .Label.Aspect.Format)
          
          Else                   ' Aca es igual                                 '
            GetValue = ValVariant(m_vCollRows(IndexRows)(IndexField, IndexRow))
          End If
        End If
        
      Case csRptControlType.csRptCtLabel, csRptControlType.csRptCtImage
        If .HasFormulaValue Then
          If .FormulaValue.HaveToEval Then
            If LenB(.Label.Aspect.Format) > 0 And NotFormat = False Then
              GetValue = Format(m_Compiler.ResultFunction(.FormulaValue), .Label.Aspect.Format)
            Else
              GetValue = m_Compiler.ResultFunction(.FormulaValue)
            End If
          Else
            If LenB(.Label.Aspect.Format) > 0 And NotFormat = False Then
              GetValue = Format(.FormulaValue.LastResult, .Label.Aspect.Format)
            Else
              GetValue = .FormulaValue.LastResult
            End If
          End If
        Else
          GetValue = .Label.text
        End If
    End Select
  End With
End Function

Private Function InitControls(ByRef Recordsets As Collection) As Boolean
  Dim ctrl      As cReportControl
  Dim Serie     As cReportChartSerie
  Dim Idx       As Long
  
  For Each ctrl In m_Controls
    If ctrl.ControlType = csRptControlType.csRptCtField Or _
       ctrl.ControlType = csRptControlType.csRptCtDbImage Then
      
      Idx = ctrl.Field.Index
      If Not pInitCtrls(ctrl, Idx, Recordsets, ctrl.Field.Name) Then Exit Function
      ctrl.Field.Index = Idx
      
    ElseIf ctrl.ControlType = csRptControlType.csRptCtChart Then
      
      If LenB(ctrl.Chart.GroupFieldName) > 0 Then
        Idx = -1
        pInitCtrls ctrl, Idx, Recordsets, ctrl.Chart.GroupFieldName
        ctrl.Chart.GroupFieldIndex = Idx
      Else
        ctrl.Chart.GroupFieldIndex = -1
      End If
      
      For Each Serie In ctrl.Chart.Series
        
        Idx = Serie.ValueIndex
        If Not pInitCtrls(ctrl, Idx, Recordsets, Serie.ValueFieldName) Then Exit Function
        Serie.ValueIndex = Idx
        
        Idx = Serie.LabelIndex
        If Not pInitCtrls(ctrl, Idx, Recordsets, Serie.LabelFieldName) Then Exit Function
        Serie.LabelIndex = Idx
      Next
      
      ctrl.Chart.ChartCreated = False
    End If
  Next
  
  InitControls = True
End Function

Private Function pInitCtrls(ByRef ctrl As cReportControl, _
                            ByRef Idx As Long, _
                            ByRef Recordsets As Collection, _
                            ByVal FieldName As String) As Boolean
  
  Dim Found         As Boolean
  Dim j             As Long
  Dim k             As Long  ' En que grupo esta
  Dim bIsDBImage    As Boolean
  Dim varRs         As Variant
  Dim rs            As Recordset
  Dim DataSource    As String
  
  bIsDBImage = False
  
  Found = False
  k = 0
  For Each varRs In Recordsets
    
    DataSource = pGetDataSource(FieldName)
    
    If UCase(varRs(1)) = UCase(DataSource) Or DataSource = vbNullString Then
      
      Set rs = varRs(0)
      
      For j = 0 To rs.Fields.Count - 1
        If UCase(rs.Fields(j).Name) = UCase(GetRealName(FieldName)) Then
          bIsDBImage = rs.Fields(j).Type = adLongVarBinary
          Found = True
          Exit For
        End If
      Next
    End If
    
    If Found Then Exit For
    k = k + 1000
  Next
  
  If Found Then
    Idx = j + k
    If bIsDBImage Then
      ctrl.ControlType = csRptCtDbImage
    End If
  Else
    Err.Raise csRptErrors.csRptErrFieldNotFound, C_Module, errGetDescript(csRptErrors.csRptErrFieldNotFound, ctrl.Name, FieldName)
  End If


  pInitCtrls = True
End Function

Private Function pGetDataSource(ByVal Name As String) As String
  Dim n As Long
  n = InStr(1, Name, "}.")
  If n = 0 Then Exit Function
    
  n = n - 2
  
  pGetDataSource = Mid$(Name, 2, n)
End Function

Private Sub pInitImages()
  pDestroyImages
  
  Set m_CollhImages = New Collection
End Sub

Private Sub pDestroyImages()
  If m_CollhImages Is Nothing Then Exit Sub
    
  Dim hImage As Variant
  
  For Each hImage In m_CollhImages
    DeleteObject CLng(hImage)
  Next
  
  CollClear m_CollhImages
End Sub

Private Function pGetChartImage(ByVal IndexRows As Long, _
                                ByVal IndexField As Long, _
                                ByVal IndexRow As Long, _
                                ByRef ctrl As cReportControl) As Long
  
  If ctrl.Chart.ChartCreated Then
    pGetChartImage = ctrl.Chart.hImage
  
  Else

    If Not ctrl.Chart.Make(m_vCollRows(IndexRows), ctrl.Label.Aspect.Format, False, vbNullString) Then Exit Function
    pGetChartImage = ctrl.Chart.hImage
  End If
End Function

' Con estos tres arma una clave unica para identificar el handle al BMP
' en la coleccion m_CollhImages
Private Function pGetImage(ByVal IndexRows As Long, ByVal IndexField As Long, ByVal IndexRow As Long) As Long
  Dim sKey        As String
  Dim hImage      As Long
  Dim FileInTMP   As String
  
  sKey = "k" & Trim$(IndexRows) & Trim$(IndexField) & Trim$(IndexRow)
  
  On Error Resume Next
  Err.Clear
  
  hImage = m_CollhImages(sKey)
  
  If Err.Number <> 0 Then
    ' En esto somos optimistas, si no me dan un picture sigo
    ' igual, mas vale chisporrotear que estallar
    Dim vBytes() As Byte
    
            ' Que feo que se ve esto no????
            ' Esto se lee asi:
            '    m_vCollRows(IndexRows)    Matriz con los datos del DataSource
            '                              mencionado por el control
            '
            '    (IndexField, IndexRow)  Elemento dentro de dicha matriz
            '
            'm_vCollRows(IndexRows)(IndexField, IndexRow)'
            '                                            '
            ' Ahora si?                                  '
            '                                            '
    vBytes = m_vCollRows(IndexRows)(IndexField, IndexRow)
    
    FileInTMP = pGetFileImageInTMP(vBytes)
    
    If LenB(FileInTMP) > 0 Then
      Dim iPic As IPictureDisp
      Set iPic = LoadPicture(FileInTMP)
      
      If Not iPic Is Nothing Then
        With iPic
          Dim Width  As Long
          Dim Height As Long
          
          GetBitmapSize .Handle, Width, Height
          hImage = CopyBitmap(.Handle, Width, Height, 0)
        End With
      End If
      
    End If
    
    m_CollhImages.Add hImage, sKey
  End If
  
  pGetImage = hImage
End Function

Private Function pGetFileImageInTMP(ByRef vBytes() As Byte) As String
  Dim FileName        As String
  Dim File            As cFile

  FileName = "~csrptImage"
  FileName = GetValidPath(Environ$("TEMP")) & FileName
  
  Dim FileEx As CSKernelFile.cFileEx
  Set FileEx = New CSKernelFile.cFileEx
  If Not FileEx.FileDelete(FileName) Then Exit Function
  
  Set File = New cFile
  If Not File.FOpen(FileName, csBinaryWrite, True, True, csLockWrite, False, False) Then Exit Function

  If Not File.FBinaryWrite(vBytes) Then Exit Function
  
  File.FClose

  pGetFileImageInTMP = FileName
End Function

Public Sub SetLaunchInfo(ByRef oLaunchInfo As cReportLaunchInfo)
  
  Set m_LaunchInfo = New cReportLaunchInfo
  
  ' Paso de oLaunchInfo a m_LaunchInfo
  '
  With oLaunchInfo
    m_LaunchInfo.Action = .Action
    m_LaunchInfo.StrConnect = .StrConnect
    m_LaunchInfo.Copies = .Copies
    
    Set m_LaunchInfo.ObjPaint = .ObjPaint
    Set m_LaunchInfo.DataSource = .DataSource
    
    m_LaunchInfo.File = .File
    m_LaunchInfo.FileFormat = .FileFormat
    m_LaunchInfo.InternalPreview = .InternalPreview
    m_LaunchInfo.ShowPrintersDialog = .ShowPrintersDialog
    m_LaunchInfo.Silent = .Silent
    m_LaunchInfo.Sqlstmt = .Sqlstmt
    Set m_LaunchInfo.Printer = .Printer
  End With
  
  ' Si aun no tengo impresora
  '
  If m_LaunchInfo.Printer Is Nothing Then
  
    ' Obtengo la impresora por defecto
    '
    Set m_LaunchInfo.Printer = GetcPrinterFromDefaultPrinter()
  
  End If
  
  ' Si tengo una impresora
  '
  If Not m_LaunchInfo.Printer Is Nothing Then
  
    ' Traduzco Printer.PaperInfo.PaperSize a las
    ' constantes definidas por CSReport
    '
    ' Nota: esto es por que A4 en csreport es 9 y en vb es 7
    '
    '
    Select Case m_LaunchInfo.Printer.PaperInfo.PaperSize
      Case PrinterObjectConstants.vbPRPSLetter
        m_PaperInfo.PaperSize = csReportPaperType.csRptPaperTypeLetter
      Case PrinterObjectConstants.vbPRPSLegal
        m_PaperInfo.PaperSize = csReportPaperType.csRptPaperLegal
      Case PrinterObjectConstants.vbPRPSExecutive
        m_PaperInfo.PaperSize = csReportPaperType.csRptPaperTypeA4
      Case PrinterObjectConstants.vbPRPSA3
        m_PaperInfo.PaperSize = PrinterObjectConstants.vbPRPSA3
      Case Else
        m_PaperInfo.PaperSize = csReportPaperType.csRptPaperNotSuported
    End Select
    
    ' Finalmente pongo en m_PaperInfo la definicion
    ' que recibi en LaunchInfo.
    '
    ' Si leyeron el codigo habran visto que puede darce
    ' el caso en que m_PaperInfo es m_LaunchInfo.Printer.PaperInfo
    ' ya que cuando no me pasan una impresora yo le pongo
    ' a la impresora por defecto el PaperInfo que cargue del csr
    '
    m_PaperInfo.Height = m_LaunchInfo.Printer.PaperInfo.Height
    m_PaperInfo.Width = m_LaunchInfo.Printer.PaperInfo.Width
  
  End If
  
End Sub

Public Function GetGroupTotal(ByVal ColIndex As Long, _
                              ByVal IndexGroup As Long) As Double
  Dim iRow As Long
  Dim rtn  As Double
  Dim i    As Long
  
  If IndexGroup = -1 Then

    For iRow = 0 To m_RecordCount
      rtn = rtn + ValVariant(m_vRows(ColIndex, m_vRowsIndex(iRow)))
    Next

  Else
  
    If m_vGroups(IndexGroup).GrandTotalGroup Then
    
      For iRow = 0 To m_RecordCount
        rtn = rtn + ValVariant(m_vRows(ColIndex, m_vRowsIndex(iRow)))
      Next
      
    Else
    
      For iRow = m_iRow To m_RecordCount
  
        For i = 1 To IndexGroup
        
          With m_vGroups(i)
        
            Select Case .ComparisonType
              
              Case csRptGrpComparisonType.csRptGrpText
                
                  If IsEmpty(.Value) Then
                    GoTo ExitProc
                  ElseIf .Value <> LCase$(ValVariant(m_vRows(.IndiceField, m_vRowsIndex(iRow)))) Then
                    GoTo ExitProc
                  End If
                  
                  If i = IndexGroup Then
                    rtn = rtn + ValVariant(m_vRows(ColIndex, m_vRowsIndex(iRow)))
                  End If
                
              Case csRptGrpComparisonType.csRptGrpNumber
                
                  If IsEmpty(.Value) Then
                    GoTo ExitProc
                  ElseIf .Value <> Val(ValVariant(m_vRows(.IndiceField, m_vRowsIndex(iRow)))) Then
                    GoTo ExitProc
                  End If
                  
                  If i = IndexGroup Then
                    rtn = rtn + ValVariant(m_vRows(ColIndex, m_vRowsIndex(iRow)))
                  End If
        
              Case csRptGrpComparisonType.csRptGrpDate
                
                  If IsEmpty(.Value) Then
                    GoTo ExitProc
                  ElseIf .Value <> DateValue(ValVariant(m_vRows(.IndiceField, m_vRowsIndex(iRow)))) Then
                    GoTo ExitProc
                  End If
                  
                  If i = IndexGroup Then
                    rtn = rtn + ValVariant(m_vRows(ColIndex, m_vRowsIndex(iRow)))
                  End If
            
            End Select
          End With
        Next
      Next
    End If
  
  End If
  
ExitProc:

  GetGroupTotal = rtn

End Function

Public Function GetGroupMax(ByVal ColIndex As Long, _
                            ByVal IndexGroup As Long) As Double
  Dim iRow As Long
  Dim rtn  As Double
  Dim i    As Long
  
  rtn = ValVariant(m_vRows(ColIndex, m_vRowsIndex(iRow)))
  
  If IndexGroup = -1 Then

    For iRow = 0 To m_RecordCount
      If rtn < ValVariant(m_vRows(ColIndex, m_vRowsIndex(iRow))) Then
        rtn = ValVariant(m_vRows(ColIndex, m_vRowsIndex(iRow)))
      End If
    Next

  Else
  
    If m_vGroups(IndexGroup).GrandTotalGroup Then
    
      For iRow = 0 To m_RecordCount
        If rtn < ValVariant(m_vRows(ColIndex, m_vRowsIndex(iRow))) Then
          rtn = ValVariant(m_vRows(ColIndex, m_vRowsIndex(iRow)))
        End If
      Next
      
    Else
    
      For iRow = m_iRow To m_RecordCount
  
        For i = 1 To IndexGroup
        
          With m_vGroups(i)
        
            Select Case .ComparisonType
              
              Case csRptGrpComparisonType.csRptGrpText
                
                  If IsEmpty(.Value) Then
                    GoTo ExitProc
                  ElseIf .Value <> LCase$(ValVariant(m_vRows(.IndiceField, m_vRowsIndex(iRow)))) Then
                    GoTo ExitProc
                  End If
                  
                  If i = IndexGroup Then
                  
                    If rtn < ValVariant(m_vRows(ColIndex, m_vRowsIndex(iRow))) Then
                      rtn = ValVariant(m_vRows(ColIndex, m_vRowsIndex(iRow)))
                    End If
                  
                  End If
                
              Case csRptGrpComparisonType.csRptGrpNumber
                
                  If IsEmpty(.Value) Then
                    GoTo ExitProc
                  ElseIf .Value <> Val(ValVariant(m_vRows(.IndiceField, m_vRowsIndex(iRow)))) Then
                    GoTo ExitProc
                  End If
                  
                  If i = IndexGroup Then
                  
                    If rtn < ValVariant(m_vRows(ColIndex, m_vRowsIndex(iRow))) Then
                      rtn = ValVariant(m_vRows(ColIndex, m_vRowsIndex(iRow)))
                    End If
                  
                  End If
        
              Case csRptGrpComparisonType.csRptGrpDate
                
                  If IsEmpty(.Value) Then
                    GoTo ExitProc
                  ElseIf .Value <> DateValue(ValVariant(m_vRows(.IndiceField, m_vRowsIndex(iRow)))) Then
                    GoTo ExitProc
                  End If
                  
                  If i = IndexGroup Then
                  
                    If rtn < ValVariant(m_vRows(ColIndex, m_vRowsIndex(iRow))) Then
                      rtn = ValVariant(m_vRows(ColIndex, m_vRowsIndex(iRow)))
                    End If
                    
                  End If
            
            End Select
          End With
        Next
      Next
    End If
  
  End If
  
ExitProc:

  GetGroupMax = rtn

End Function

Public Function GetGroupMin(ByVal ColIndex As Long, _
                            ByVal IndexGroup As Long) As Double
  Dim iRow As Long
  Dim rtn  As Double
  Dim i    As Long
  
  rtn = ValVariant(m_vRows(ColIndex, m_vRowsIndex(iRow)))
  
  If IndexGroup = -1 Then

    For iRow = 0 To m_RecordCount
      If rtn > ValVariant(m_vRows(ColIndex, m_vRowsIndex(iRow))) Then
        rtn = ValVariant(m_vRows(ColIndex, m_vRowsIndex(iRow)))
      End If
    Next

  Else
  
    If m_vGroups(IndexGroup).GrandTotalGroup Then
    
      For iRow = 0 To m_RecordCount
        If rtn > ValVariant(m_vRows(ColIndex, m_vRowsIndex(iRow))) Then
          rtn = ValVariant(m_vRows(ColIndex, m_vRowsIndex(iRow)))
        End If
      Next
      
    Else
    
      For iRow = m_iRow To m_RecordCount
  
        For i = 1 To IndexGroup
        
          With m_vGroups(i)
        
            Select Case .ComparisonType
              
              Case csRptGrpComparisonType.csRptGrpText
                
                  If IsEmpty(.Value) Then
                    GoTo ExitProc
                  ElseIf .Value <> LCase$(ValVariant(m_vRows(.IndiceField, m_vRowsIndex(iRow)))) Then
                    GoTo ExitProc
                  End If
                  
                  If i = IndexGroup Then
                  
                    If rtn > ValVariant(m_vRows(ColIndex, m_vRowsIndex(iRow))) Then
                      rtn = ValVariant(m_vRows(ColIndex, m_vRowsIndex(iRow)))
                    End If
                  
                  End If
                
              Case csRptGrpComparisonType.csRptGrpNumber
                
                  If IsEmpty(.Value) Then
                    GoTo ExitProc
                  ElseIf .Value <> Val(ValVariant(m_vRows(.IndiceField, m_vRowsIndex(iRow)))) Then
                    GoTo ExitProc
                  End If
                  
                  If i = IndexGroup Then
                  
                    If rtn > ValVariant(m_vRows(ColIndex, m_vRowsIndex(iRow))) Then
                      rtn = ValVariant(m_vRows(ColIndex, m_vRowsIndex(iRow)))
                    End If
                  
                  End If
        
              Case csRptGrpComparisonType.csRptGrpDate
                
                  If IsEmpty(.Value) Then
                    GoTo ExitProc
                  ElseIf .Value <> DateValue(ValVariant(m_vRows(.IndiceField, m_vRowsIndex(iRow)))) Then
                    GoTo ExitProc
                  End If
                  
                  If i = IndexGroup Then
                  
                    If rtn > ValVariant(m_vRows(ColIndex, m_vRowsIndex(iRow))) Then
                      rtn = ValVariant(m_vRows(ColIndex, m_vRowsIndex(iRow)))
                    End If
                    
                  End If
            
            End Select
          End With
        Next
      Next
    End If
  
  End If
  
ExitProc:

  GetGroupMin = rtn

End Function

Public Function GetGroupAverage(ByVal ColIndex As Long, _
                                ByVal IndexGroup As Long) As Double
  Dim iRow  As Long
  Dim rtn   As Double
  Dim i     As Long
  Dim Count As Long
  
  If IndexGroup = -1 Then

    For iRow = 0 To m_RecordCount
      rtn = rtn + ValVariant(m_vRows(ColIndex, m_vRowsIndex(iRow)))
      Count = Count + 1
    Next

  Else
  
    If m_vGroups(IndexGroup).GrandTotalGroup Then
    
      For iRow = 0 To m_RecordCount
        rtn = rtn + ValVariant(m_vRows(ColIndex, m_vRowsIndex(iRow)))
        Count = Count + 1
      Next
      
    Else
    
      For iRow = m_iRow To m_RecordCount
  
        For i = 1 To IndexGroup
        
          With m_vGroups(i)
        
            Select Case .ComparisonType
              
              Case csRptGrpComparisonType.csRptGrpText
                
                  If IsEmpty(.Value) Then
                    GoTo ExitProc
                  ElseIf .Value <> LCase$(ValVariant(m_vRows(.IndiceField, m_vRowsIndex(iRow)))) Then
                    GoTo ExitProc
                  End If
                  
                  If i = IndexGroup Then
                    rtn = rtn + ValVariant(m_vRows(ColIndex, m_vRowsIndex(iRow)))
                    Count = Count + 1
                  End If
                
              Case csRptGrpComparisonType.csRptGrpNumber
                
                  If IsEmpty(.Value) Then
                    GoTo ExitProc
                  ElseIf .Value <> Val(ValVariant(m_vRows(.IndiceField, m_vRowsIndex(iRow)))) Then
                    GoTo ExitProc
                  End If
                  
                  If i = IndexGroup Then
                    rtn = rtn + ValVariant(m_vRows(ColIndex, m_vRowsIndex(iRow)))
                    Count = Count + 1
                  End If
        
              Case csRptGrpComparisonType.csRptGrpDate
                
                  If IsEmpty(.Value) Then
                    GoTo ExitProc
                  ElseIf .Value <> DateValue(ValVariant(m_vRows(.IndiceField, m_vRowsIndex(iRow)))) Then
                    GoTo ExitProc
                  End If
                  
                  If i = IndexGroup Then
                    rtn = rtn + ValVariant(m_vRows(ColIndex, m_vRowsIndex(iRow)))
                    Count = Count + 1
                  End If
            
            End Select
          End With
        Next
      Next
    End If
  
  End If
  
ExitProc:

  GetGroupAverage = DivideByCero(rtn, Count)

End Function

Public Function GetGroupLineNumber(ByVal IndexGroup As Long)

  If IndexGroup = -1 Then

    GetGroupLineNumber = m_LineNumber

  Else
    
    GetGroupLineNumber = m_vGroups(IndexGroup).LineNumber
  
  End If
End Function

Public Function GetGroupCount(ByVal ColIndex As Long, _
                              ByVal IndexGroup As Long) As Double
  Dim iRow As Long
  Dim rtn  As Double
  Dim i    As Long
  
  If IndexGroup = -1 Then

    rtn = m_RecordCount

  Else
  
    If m_vGroups(IndexGroup).GrandTotalGroup Then
    
      rtn = m_RecordCount
      
    Else
    
      For iRow = m_iRow To m_RecordCount
  
        For i = 1 To IndexGroup
        
          With m_vGroups(i)
        
            Select Case .ComparisonType
              
              Case csRptGrpComparisonType.csRptGrpText
                
                  If IsEmpty(.Value) Then
                    GoTo ExitProc
                  ElseIf .Value <> LCase$(ValVariant(m_vRows(.IndiceField, m_vRowsIndex(iRow)))) Then
                    GoTo ExitProc
                  End If
                  
                  If i = IndexGroup Then
                    rtn = rtn + 1
                  End If
                
              Case csRptGrpComparisonType.csRptGrpNumber
                
                  If IsEmpty(.Value) Then
                    GoTo ExitProc
                  ElseIf .Value <> Val(ValVariant(m_vRows(.IndiceField, m_vRowsIndex(iRow)))) Then
                    GoTo ExitProc
                  End If
                  
                  If i = IndexGroup Then
                    rtn = rtn + 1
                  End If
        
              Case csRptGrpComparisonType.csRptGrpDate
                
                  If IsEmpty(.Value) Then
                    GoTo ExitProc
                  ElseIf .Value <> DateValue(ValVariant(m_vRows(.IndiceField, m_vRowsIndex(iRow)))) Then
                    GoTo ExitProc
                  End If
                  
                  If i = IndexGroup Then
                    rtn = rtn + 1
                  End If
            
            End Select
          End With
        Next
      Next
    End If
  
  End If
  
ExitProc:

  GetGroupCount = rtn

End Function

' funciones privadas
Private Function InitGroups(ByRef rs As ADODB.Recordset, _
                            ByVal MainDataSource As String) As Boolean
  
  m_GroupCount = m_Groups.Count
  ReDim m_vGroups(m_GroupCount)
  
  m_FirstGroup = True
  
  If m_GroupCount = 0 Or IsEmpty(m_vRows) Then
    InitGroups = True
    Exit Function
  End If
  
  If Not ShowProgress("Ordenando el reporte", 0, 0, 0) Then Exit Function
  
  Dim k           As Long
  Dim i           As Long
  Dim j           As Long
  Dim Found       As Boolean
  Dim FieldName   As String
  Dim DataSource  As String
  
  ' Chequeo que todos los grupos esten
  ' en el Recordset Principal
  '
  For i = 1 To m_GroupCount
    With m_vGroups(i)
      .Value = Empty
  
      Found = False
      
      FieldName = m_Groups.Item(i).FieldName
      DataSource = UCase(pGetDataSource(FieldName))
      FieldName = UCase(GetRealName(FieldName))
      
      ' El campo debe pertenecer al recordset principal
      '
      If UCase(MainDataSource) <> DataSource And _
         LenB(DataSource) > 0 Then
         
        With m_Groups.Item(i)
          Err.Raise csRptErrors.csRptErrGroupNotInMainRS, _
                    C_Module, _
                    errGetDescript(csRptErrors.csRptErrGroupNotFound, _
                                   .Name, _
                                   .FieldName)
        End With
      End If
      
      .GrandTotalGroup = m_Groups.Item(i).GrandTotalGroup
      
      If Not .GrandTotalGroup Then
      
      For j = 0 To rs.Fields.Count - 1
        If UCase(rs.Fields(j).Name) = FieldName Then
          Found = True
          Exit For
        End If
      Next
      
      If Found Then
        .IndiceField = j
      Else
        With m_Groups.Item(i)
          Err.Raise csRptErrors.csRptErrGroupNotFound, _
                    C_Module, _
                    errGetDescript(csRptErrors.csRptErrGroupNotFound, _
                                   .Name, _
                                   .FieldName)
        End With
      End If
      
      End If
      
      .ComparisonType = m_Groups.Item(i).ComparisonType
      .OderType = m_Groups.Item(i).OderType
  
      ReDim .Groups(0)
    End With
  Next
  
  ReDim m_vGroups(1).Groups(1)
  Dim RecordCount As Long
  Dim Percent As Double
  Dim q As Long
  RecordCount = UBound(m_vRowsIndex)
  m_vGroups(1).Groups(1).First = 0
  m_vGroups(1).Groups(1).Last = RecordCount
  
  RecordCount = m_GroupCount * RecordCount
  
  ' Ahora tengo que ordenar los datos
  For i = 1 To m_GroupCount
    For j = 1 To UBound(m_vGroups(i).Groups)
    
      If Not m_vGroups(i).GrandTotalGroup Then
  
        If m_vGroups(i).OderType = csRptGrpOrderType.csRptGrpAsc Then
          With m_vGroups(i)
            Select Case .ComparisonType
              Case csRptGrpComparisonType.csRptGrpText
                If Not OrderTextAsc(.Groups(j).First, .Groups(j).Last, .IndiceField) Then Exit Function
              Case csRptGrpComparisonType.csRptGrpNumber
                If Not OrderNumberAsc(.Groups(j).First, .Groups(j).Last, .IndiceField) Then Exit Function
              Case csRptGrpComparisonType.csRptGrpDate
                If Not OrderDateAsc(.Groups(j).First, .Groups(j).Last, .IndiceField) Then Exit Function
            End Select
          End With
        Else
          With m_vGroups(i)
            Select Case .ComparisonType
              Case csRptGrpComparisonType.csRptGrpText
                If Not OrderTextDesc(.Groups(j).First, .Groups(j).Last, .IndiceField) Then Exit Function
              Case csRptGrpComparisonType.csRptGrpNumber
                If Not OrderNumberDesc(.Groups(j).First, .Groups(j).Last, .IndiceField) Then Exit Function
              Case csRptGrpComparisonType.csRptGrpDate
                If Not OrderDateDesc(.Groups(j).First, .Groups(j).Last, .IndiceField) Then Exit Function
            End Select
          End With
        End If
      End If
    Next
  
    ' Ahora que ya ordene tengo que
    ' preparar al proximo grupo
    If i < m_GroupCount Then
      With m_vGroups(i + 1)
      
        For k = 1 To UBound(m_vGroups(i).Groups)
        
          ' Si es un grupo de totales el proximo grupo
          ' va desde el primer registro (posicion 0)
          ' hasta el ultimo registro (posicion m_vGroups(1).Groups(1).Last)
          '
          If m_vGroups(i).GrandTotalGroup Then
          
            .Groups(UBound(.Groups)).Last = 0
            ReDim Preserve .Groups(UBound(.Groups) + 1)
            .Groups(UBound(.Groups)).First = 0
            .Groups(UBound(.Groups)).Last = m_vGroups(1).Groups(1).Last
            .Value = Empty
          
          Else
          
            For j = m_vGroups(i).Groups(k).First To m_vGroups(i).Groups(k).Last
              q = q + 1
              If Not ShowProgress(vbNullString, 0, q, RecordCount) Then Exit Function
      
              Select Case m_vGroups(i).ComparisonType
      
                Case csRptGrpComparisonType.csRptGrpText
                  If IsEmpty(.Value) Then
                    GoTo ChangeText
                  ElseIf LCase$(.Value) <> LCase$(ValVariant(m_vRows(m_vGroups(i).IndiceField, m_vRowsIndex(j)))) Then
ChangeText:
                    .Groups(UBound(.Groups)).Last = j - 1
                    ReDim Preserve .Groups(UBound(.Groups) + 1)
                    .Groups(UBound(.Groups)).First = j
                    .Value = ValVariant(m_vRows(m_vGroups(i).IndiceField, m_vRowsIndex(j)))
                  End If
      
                Case csRptGrpComparisonType.csRptGrpNumber
                  If IsEmpty(.Value) Then
                    GoTo ChangeNumber
                  ElseIf Val(.Value) <> Val(m_vRows(m_vGroups(i).IndiceField, m_vRowsIndex(j))) Then
ChangeNumber:
                    .Groups(UBound(.Groups)).Last = j - 1
                    ReDim Preserve .Groups(UBound(.Groups) + 1)
                    .Groups(UBound(.Groups)).First = j
                    .Value = ValVariant(m_vRows(m_vGroups(i).IndiceField, m_vRowsIndex(j)))
                  End If
      
                Case csRptGrpComparisonType.csRptGrpDate
                  If IsEmpty(.Value) Then
                    GoTo ChangeDate
                  ElseIf .Value <> m_vRows(m_vGroups(i).IndiceField, m_vRowsIndex(j)) Then
ChangeDate:
                    .Groups(UBound(.Groups)).Last = j - 1
                    ReDim Preserve .Groups(UBound(.Groups) + 1)
                    .Groups(UBound(.Groups)).First = j
                    .Value = ValVariant(m_vRows(m_vGroups(i).IndiceField, m_vRowsIndex(j)))
                  End If
              End Select
            Next
            .Groups(UBound(.Groups)).Last = j - 1
            .Value = Empty
            
          End If
          
        Next
      End With
    End If
  Next
  
  InitGroups = True
End Function
  
Private Function pEstimateLoops(ByVal n As Long) As Long
  Dim q As Long
  For q = n - 1 To 1 Step -1
    n = n + q
  Next
  pEstimateLoops = n
End Function
  
Private Function OrderNumberAsc(ByVal First As Long, ByVal Last As Long, ByVal OrderBy As Long) As Boolean
  Dim i As Long
  Dim j As Long
  Dim t As Long
  Dim q As Long
  Dim bChanged As Boolean
  
  t = pEstimateLoops(Last - First)
  For i = First + 1 To Last
    bChanged = False
    For j = Last To i Step -1
      q = q + 1
      If Val(m_vRows(OrderBy, m_vRowsIndex(j))) < Val(m_vRows(OrderBy, m_vRowsIndex(j - 1))) Then
        If Not ShowProgress(vbNullString, 0, q, t) Then Exit Function
        ChangeRow j, j - 1
        bChanged = True
      End If
    Next
    If Not ShowProgress(vbNullString, 0, q, t) Then Exit Function
    If Not bChanged Then Exit For
  Next
  
  OrderNumberAsc = True
End Function
  
Private Function OrderNumberDesc(ByVal First As Long, ByVal Last As Long, ByVal OrderBy As Long) As Boolean
  Dim i As Long
  Dim j As Long
  Dim t As Long
  Dim q As Long
  Dim bChanged As Boolean
  
  t = pEstimateLoops(Last - First)
  For i = First + 1 To Last
    bChanged = False
    For j = Last To i Step -1
      q = q + 1
      If Val(m_vRows(OrderBy, m_vRowsIndex(j))) > Val(m_vRows(OrderBy, m_vRowsIndex(j - 1))) Then
        If Not ShowProgress(vbNullString, 0, q, t) Then Exit Function
        ChangeRow j, j - 1
        bChanged = True
      End If
    Next
    If Not ShowProgress(vbNullString, 0, q, t) Then Exit Function
    If Not bChanged Then Exit For
  Next
  
  OrderNumberDesc = True
End Function
  
Private Function OrderTextAsc(ByVal First As Long, ByVal Last As Long, ByVal OrderBy As Long) As Boolean
  Dim i As Long
  Dim j As Long
  Dim t As Long
  Dim q As Long
  Dim bChanged As Boolean
  
  t = pEstimateLoops(Last - First)
  For i = First + 1 To Last
    bChanged = False
    For j = Last To i Step -1
      q = q + 1
      If LCase$(ValVariant(m_vRows(OrderBy, m_vRowsIndex(j)))) < LCase$(ValVariant(m_vRows(OrderBy, m_vRowsIndex(j - 1)))) Then
        If Not ShowProgress(vbNullString, 0, q, t) Then Exit Function
        ChangeRow j, j - 1
        bChanged = True
      End If
    Next
    If Not ShowProgress(vbNullString, 0, q, t) Then Exit Function
    If Not bChanged Then Exit For
  Next
  
  OrderTextAsc = True
End Function

Private Function OrderTextDesc(ByVal First As Long, ByVal Last As Long, ByVal OrderBy As Long) As Boolean
  Dim i As Long
  Dim j As Long
  Dim t As Long
  Dim q As Long
  Dim bChanged As Boolean
  
  t = pEstimateLoops(Last - First)
  For i = First + 1 To Last
    bChanged = False
    For j = Last To i Step -1
      q = q + 1
      If LCase$(ValVariant(m_vRows(OrderBy, m_vRowsIndex(j)))) > LCase$(ValVariant(m_vRows(OrderBy, m_vRowsIndex(j - 1)))) Then
        If Not ShowProgress(vbNullString, 0, q, t) Then Exit Function
        ChangeRow j, j - 1
        bChanged = True
      End If
    Next
    If Not ShowProgress(vbNullString, 0, q, t) Then Exit Function
    If Not bChanged Then Exit For
  Next
  
  OrderTextDesc = True
End Function

Private Sub ChangeRow(ByVal i As Long, ByVal j As Long)
  Dim q As Long
  
  q = m_vRowsIndex(j)
  m_vRowsIndex(j) = m_vRowsIndex(i)
  m_vRowsIndex(i) = q
End Sub

Private Function EvalFunctions(ByVal idxGroup As Long, ByVal WhenEval As csRptWhenEval) As Boolean
  Dim Formula         As cReportFormula
  Dim bHaveToEvalRow  As Boolean
  Dim IdxRowEvalued   As Long
  Dim RecordCount     As Long
  
  If Not IsEmpty(m_vRows) Then
    RecordCount = UBound(m_vRowsIndex)
  End If
  
  ' Si la fila a evaluar es valida
  '
  If m_iRowFormula <= RecordCount Then
  
    ' Determino que estoy evaluando
    ' (Headers, Group Headers, Details, Group Footers o Footers)
    '
    Select Case idxGroup
      Case c_IdxGroupHeader, c_IdxGroupReportHeader
        IdxRowEvalued = c_IdxHLastRowEvalued
      Case c_IdxGroupDetail
        IdxRowEvalued = c_IdxDLastRowEvalued
      Case c_IdxGroupFooter, c_IdxGroupReportFooter
        IdxRowEvalued = c_IdxFLastRowEvalued
        
      ' Groups Headers o Footers
      Case Else
        IdxRowEvalued = c_IdxGLastRowEvalued
    End Select
    
    ' Evaluo antes de imprimir
    '
    If WhenEval = csRptEvalPre Then
      If IdxRowEvalued = c_IdxGLastRowEvalued Then
        
        ' Si es un footer
        '
        If idxGroup < 0 Then
          bHaveToEvalRow = m_vGroups(idxGroup * -1).LastFPreRowEvalued < m_iRowFormula
        Else
          bHaveToEvalRow = m_vGroups(idxGroup).LastHPreRowEvalued < m_iRowFormula
        End If
      Else
        bHaveToEvalRow = m_LastRowPreEvalued(IdxRowEvalued) < m_iRowFormula
      End If
    
    ' Evaluo despues de imprimir
    '
    Else
      If IdxRowEvalued = c_IdxGLastRowEvalued Then
        
        ' Si es un footer
        '
        If idxGroup < 0 Then
          bHaveToEvalRow = m_vGroups(idxGroup * -1).LastFPostRowEvalued < m_iRowFormula
        Else
          bHaveToEvalRow = m_vGroups(idxGroup).LastHPostRowEvalued < m_iRowFormula
        End If
      Else
        bHaveToEvalRow = m_LastRowPostEvalued(IdxRowEvalued) < m_iRowFormula
      End If
    End If
    
    ' Si hay que evaluar
    '
    If bHaveToEvalRow Then
      
      For Each Formula In m_Formulas
        If Formula.WhenEval = WhenEval _
           And (idxGroup = Formula.idxGroup _
               Or Formula.idxGroup2 = idxGroup) Then
           'And idxGroup = Formula.idxGroup Then
          
          Formula.HaveToEval = True
        End If
      Next
      
      For Each Formula In m_Formulas
        If Formula.WhenEval = WhenEval _
           And (idxGroup = Formula.idxGroup _
               Or Formula.idxGroup2 = idxGroup) Then
           'And idxGroup = Formula.idxGroup Then
          
          If Formula.idxGroup2 = idxGroup Then
            m_Compiler.EvalFunctionGroup Formula
          Else
            m_Compiler.EvalFunction Formula
          End If
        End If
      Next
      
      ' Actualizo cual es la ultima fila evaluada
      
      ' Evaluo antes de imprimir
      '
      If WhenEval = csRptEvalPre Then
        If IdxRowEvalued = c_IdxGLastRowEvalued Then
          
          ' Si es un footer
          '
          If idxGroup < 0 Then
            m_vGroups(idxGroup * -1).LastFPreRowEvalued = m_iRowFormula
          Else
            m_vGroups(idxGroup).LastHPreRowEvalued = m_iRowFormula
          End If
        Else
          m_LastRowPreEvalued(IdxRowEvalued) = m_iRowFormula
        End If
      
      ' Evaluo despues de imprimir
      '
      Else
        If IdxRowEvalued = c_IdxGLastRowEvalued Then
          
          ' Si es un footer
          '
          If idxGroup < 0 Then
            m_vGroups(idxGroup * -1).LastFPostRowEvalued = m_iRowFormula
          Else
            m_vGroups(idxGroup).LastHPostRowEvalued = m_iRowFormula
          End If
        Else
          m_LastRowPostEvalued(IdxRowEvalued) = m_iRowFormula
        End If
      End If
    End If
  End If
  
  EvalFunctions = True
End Function

' Pongo todas las formulas que estan en los headers
' un grupo virtual para que solo compile dichas
' formulas en NewPage y no formulas que estan en otras
' secciones
'
Private Sub pSetGroupFormulaHeaders()
  pSetGroupFormulaHF m_Headers, c_IdxGroupHeader
  
  ' Main Header va en -2000
  '
  If m_Headers.Item(1).HasFormulaHide Then
    m_Headers.Item(1).FormulaHide.idxGroup = c_IdxGroupReportHeader
  End If
  
  Dim SecLn As cReportSectionLine
  Dim ctrl  As cReportControl
  
  For Each SecLn In m_Headers.Item(1).SectionLines
    For Each ctrl In SecLn.Controls
      If ctrl.HasFormulaHide Then
        ctrl.FormulaHide.idxGroup = c_IdxGroupReportHeader
      End If
      If ctrl.HasFormulaValue Then
        ctrl.FormulaValue.idxGroup = c_IdxGroupReportHeader
      End If
    Next
  Next

End Sub

Private Sub pSetGroupsInCtrlFormulaHide()
  Dim Group As cReportGroup
  
  For Each Group In m_Groups
    pSetGroupsInCtrlFormulaHideAux Group.Header.SectionLines, Group.Indice
    pSetGroupsInCtrlFormulaHideAux Group.Footer.SectionLines, Group.Indice
  Next
End Sub

Private Sub pSetGroupsInCtrlFormulaHideAux(ByRef Scls As cReportSectionLines, _
                                           ByVal IdxGrop As Integer)
  Dim scl   As cReportSectionLine
  Dim ctrl  As cReportControl
  
  For Each scl In Scls
    For Each ctrl In scl.Controls
      If ctrl.HasFormulaHide Then
        If ctrl.FormulaHide.idxGroup = 0 Then
          ctrl.FormulaHide.idxGroup = IdxGrop
        End If
      End If
    Next
  Next
End Sub

Private Sub pSetGroupFormulaHF(ByRef Sections As cReportSections, ByVal IdxGrop As Integer)
  Dim Sec   As cReportSection
  Dim SecLn As cReportSectionLine
  Dim ctrl  As cReportControl
  
  For Each Sec In Sections
    For Each SecLn In Sec.SectionLines
      For Each ctrl In SecLn.Controls
        If ctrl.HasFormulaHide Then
          If ctrl.FormulaHide.idxGroup = 0 Then
            ctrl.FormulaHide.idxGroup = IdxGrop
          End If
        End If
        If ctrl.HasFormulaValue Then
          If ctrl.FormulaValue.idxGroup = 0 Then
            ctrl.FormulaValue.idxGroup = IdxGrop
          End If
        End If
      Next
    Next
  Next
End Sub

Private Function CompileReport() As Boolean
  Dim ctrl As cReportControl
  
  For Each ctrl In m_Controls
    If ctrl.HasFormulaHide Then
      If Not m_Compiler.CheckSintax(ctrl.FormulaHide) Then Exit Function
  
      ' Para tener informacion de debug
      ctrl.FormulaHide.SectionName = ctrl.SectionLine.SectionName
      ctrl.FormulaHide.SectionLineIndex = ctrl.SectionLine.Indice
      ctrl.FormulaHide.ControlName = ctrl.Name
      
      ' Agrego las formulas a la coleccion de formulas
      AddFormula ctrl.FormulaHide, ctrl.Name & "_" & "H"
    End If
  
    If ctrl.HasFormulaValue Then
      If Not m_Compiler.CheckSintax(ctrl.FormulaValue) Then Exit Function
  
      ' Para tener informacion de debug
      ctrl.FormulaValue.SectionName = ctrl.SectionLine.SectionName
      ctrl.FormulaValue.SectionLineIndex = ctrl.SectionLine.Indice
      ctrl.FormulaValue.ControlName = ctrl.Name
  
      ' Agrego las formulas a la coleccion de formulas
      AddFormula ctrl.FormulaValue, ctrl.Name & "_" & "V"
    End If
  Next
  
  If Not pAddFormulasInSection(m_Headers) Then Exit Function
  If Not pAddFormulasInSection(m_GroupsHeaders) Then Exit Function
  If Not pAddFormulasInSection(m_GroupsFooters) Then Exit Function
  If Not pAddFormulasInSection(m_Details) Then Exit Function
  If Not pAddFormulasInSection(m_Footers) Then Exit Function
  
  Dim Formula As cReportFormula
  
  For Each Formula In m_Formulas
    m_Compiler.InitVariable Formula
  Next
  
  pSetIndexGroupInFormulaGroups m_Headers
  pSetIndexGroupInFormulaGroups m_GroupsHeaders
  pSetIndexGroupInFormulaGroups m_GroupsFooters
  pSetIndexGroupInFormulaGroups m_Details
  pSetIndexGroupInFormulaGroups m_Footers
  
  m_Compiler.ClearVariables
  
  CompileReport = True
End Function

Private Function pSetIndexGroupInFormulaGroups(ByRef Sections As cReportSections) As Boolean
  Dim Sec    As cReportSection
  Dim SecLn  As cReportSectionLine
  Dim ctrl   As cReportControl
  
  For Each Sec In Sections
    If Sec.HasFormulaHide Then
      pSetFormulaIndexGroup Sec.FormulaHide, Sec
    End If
    For Each SecLn In Sec.SectionLines
      If SecLn.HasFormulaHide Then
        pSetFormulaIndexGroup SecLn.FormulaHide, Sec
      End If
      For Each ctrl In SecLn.Controls
        If ctrl.HasFormulaHide Then
          pSetFormulaIndexGroup ctrl.FormulaHide, Sec
        End If
        If ctrl.HasFormulaValue Then
          pSetFormulaIndexGroup ctrl.FormulaValue, Sec
        End If
      Next
    Next
  Next

End Function

Private Function pSetFormulaIndexGroup(ByRef Formula As cReportFormula, _
                                       ByRef Sec As cReportSection) As Boolean
  Dim Fint As cReportFormulaInt
  Dim IndexGroup As Long
  
  For Each Fint In Formula.FormulasInt
  
    If pIsGroupFormula(Fint.FormulaType) Then
      
      If Fint.FormulaType = mAux.csRptFormulaType.csRptGroupPercent Then
        Formula.idxGroup2 = 0
        IndexGroup = Val(Fint.Parameters(3).Value)
      Else
        IndexGroup = Val(Fint.Parameters(2).Value)
      End If
      
      If Fint.Parameters.Item(c_KeyIndexGroup) Is Nothing Then
        Fint.Parameters.Add2 vbNullString, c_KeyIndexGroup
      End If
      
      If IndexGroup = -1 Then
        If Sec.TypeSection = csRptTpGroupHeader _
           Or Sec.TypeSection = csRptTpGroupFooter Then
          
          ' Indice del grupo
          Fint.Parameters(c_KeyIndexGroup).Value = Sec.Indice
          Formula.idxGroup = Sec.Indice
        
        ElseIf Sec.TypeSection = csRptTpMainSectionDetail Then
          
          ' Indice del grupo mas interno
          Fint.Parameters(c_KeyIndexGroup).Value = m_Groups.Count
          Formula.idxGroup = m_Groups.Count
          
        Else
          Fint.Parameters(c_KeyIndexGroup).Value = 0
          Formula.idxGroup = 0
        End If
      Else
          
        Fint.Parameters(c_KeyIndexGroup).Value = IndexGroup
        Formula.idxGroup = IndexGroup
      
      End If
    End If
    
  Next

End Function

Private Function pIsGroupFormula(ByVal fType As Integer) As Boolean
  Select Case fType
  
    Case mAux.csRptFormulaType.csRptGroupTotal, mAux.csRptFormulaType.csRptGroupMax, _
         mAux.csRptFormulaType.csRptGroupMin, mAux.csRptFormulaType.csRptGroupAverage, _
         mAux.csRptFormulaType.csRptGroupPercent, mAux.csRptFormulaType.csRptGroupCount, _
         mAux.csRptFormulaType.csRptGroupLineNumber
         
      pIsGroupFormula = True
      
    Case Else
    
      pIsGroupFormula = False
        
  End Select
End Function

Private Function pAddFormulasInSection(ByRef Sections As cReportSections) As Boolean
  Dim Sec    As cReportSection
  Dim SecLn  As cReportSectionLine
  
  For Each Sec In Sections
    If Sec.HasFormulaHide Then
      If Not m_Compiler.CheckSintax(Sec.FormulaHide) Then Exit Function
    
      ' Para tener informacion de debug
      Sec.FormulaHide.SectionName = Sec.Name
    
      ' Agrego las formulas a la coleccion de formulas
      AddFormula Sec.FormulaHide, Sec.Name & "_" & "H"
    End If
    For Each SecLn In Sec.SectionLines
      If SecLn.HasFormulaHide Then
        If Not m_Compiler.CheckSintax(SecLn.FormulaHide) Then Exit Function
      
        ' Para tener informacion de debug
        SecLn.FormulaHide.SectionName = SecLn.SectionName
        SecLn.FormulaHide.SectionLineIndex = SecLn.Indice
      
        ' Agrego las formulas a la coleccion de formulas
        AddFormula SecLn.FormulaHide, Sec.Name & "_R_" & SecLn.Indice & "_" & "H"
      End If
    Next
  Next
  
  pAddFormulasInSection = True
End Function

Private Sub AddFormula(ByRef Formula As cReportFormula, ByVal Name As String)
  If m_Formulas.Item(Name) Is Nothing Then
    m_Formulas.Add2 Formula, Name
  End If
End Sub

Private Function GetHeightHeader() As Single
  Dim Sec       As cReportSection
  Dim Height    As Long
  Dim IsVisible As Boolean
  
  For Each Sec In m_Headers
    If Sec.HasFormulaHide Then
      IsVisible = Val(m_Compiler.ResultFunction(Sec.FormulaHide))
    Else
      IsVisible = True
    End If
    
    If IsVisible Then Height = Height + Sec.Aspect.Height
  Next
  
  GetHeightHeader = Height
End Function

Private Function GetTopFooter() As Single
  Dim Offset As Long
  
  With m_LaunchInfo.Printer.PaperInfo
    If .PaperSize = vbPRPSUser Then
      Offset = m_PaperInfo.CustomHeight - .CustomHeight
    End If
  End With
  
  With m_Footers.Item(1).Aspect
    GetTopFooter = .Top - Offset
  End With
End Function
  
Private Sub AddFieldToNewPage(ByRef Sections As cReportSections, ByRef Page As cReportPage, ByVal Where As Long)
  Dim Field           As cReportPageField
  Dim Sec             As cReportSection
  Dim Secline         As cReportSectionLine
  Dim ctrl            As cReportControl
  Dim IsVisible       As Boolean
  Dim indexCtrl       As Long
  Dim Offset          As Long
  Dim RecordCount     As Long
  
  If Not IsEmpty(m_vRows) Then
    RecordCount = UBound(m_vRowsIndex)
  End If
  
  ' Estos indices son:
  Dim IndexRows   As Long  ' En que DataSource estas
  Dim IndexRow    As Long  ' En que fila de ese DataSource estas
  Dim IndexField  As Long
 
  For Each Sec In Sections
    
    m_LineIndex = m_LineIndex + 1
    
    If Sec.HasFormulaHide Then
      IsVisible = Val(m_Compiler.ResultFunction(Sec.FormulaHide))
    Else
      IsVisible = True
    End If
    
    If IsVisible Then
      For Each Secline In Sec.SectionLines
        If Secline.HasFormulaHide Then
          IsVisible = Val(m_Compiler.ResultFunction(Secline.FormulaHide))
        Else
          IsVisible = True
        End If
      
        If IsVisible Then
          'For Each Ctrl In Secline.Controls
          
          For indexCtrl = 1 To UBound(Secline.Controls.CollByLeft)
          
            Set ctrl = Secline.Controls.Item(Secline.Controls.CollByLeft(indexCtrl))
          
            If Where = c_Headers Then
              Set Field = Page.Header.Add()
            ElseIf Where = c_Footers Then
              Set Field = Page.Footer.Add()
            End If
            
            Field.IndexLine = m_LineIndex
            
            If ctrl.HasFormulaValue Then
            
              Field.Value = Format(m_Compiler.ResultFunction(ctrl.FormulaValue), ctrl.Label.Aspect.Format)
            Else
              Select Case ctrl.ControlType
                Case csRptControlType.csRptCtField
                
                  pGetIndexRows IndexRows, IndexRow, IndexField, ctrl
                  
                  If Not IsEmpty(m_vCollRows(IndexRows)) Then
                                                    ' Que feo que se ve esto no????
                                                    ' Esto se lee asi:
                                                    '    m_vCollRows(IndexRows)    Matriz con los datos del DataSource
                                                    '                              mencionado por el control
                                                    '
                                                    '    (IndexField , IndexRow)  Elemento dentro de dicha matriz
                                                    '
                                                    'm_vCollRows(IndexRows)(IndexField , IndexRow)'
                                                    '                                              '
                                                    ' Ahora si?                                    '
                                                    '                                              '
                    Field.Value = Format(ValVariant(m_vCollRows(IndexRows)(IndexField, IndexRow)), ctrl.Label.Aspect.Format)
                  End If
                  
                Case csRptControlType.csRptCtLabel
                  Field.Value = Format(ctrl.Label.text, ctrl.Label.Aspect.Format)
                Case csRptControlType.csRptCtImage
                  Field.Value = Format(ctrl.Label.text, ctrl.Label.Aspect.Format)
                  Field.hImage = ctrl.Image.hImage
              
                Case csRptControlType.csRptCtDbImage
                
                  pGetIndexRows IndexRows, IndexRow, IndexField, ctrl
                  
                  If Not IsEmpty(m_vCollRows(IndexRows)) Then
                    
                                                   ' Que feo que se ve esto no????
                                                   ' Esto se lee asi:
                                                   '    m_vCollRows(IndexRows)    Matriz con los datos del DataSource
                                                   '                              mencionado por el control
                                                   '
                                                   '    (IndexField, IndexRow)  Elemento dentro de dicha matriz
                                                   '
                                                   'm_vCollRows(IndexRows)(IndexField, IndexRow)'
                                                   '                                            '
                                                   ' Ahora si?                                  '
                                                   '                                            '
                    Field.hImage = pGetImage(IndexRows, IndexField, IndexRow)
                  End If
                
                Case csRptControlType.csRptCtChart
                  
                  pGetIndexRows IndexRows, IndexRow, IndexField, ctrl
                  
                  Field.hImage = pGetChartImage(IndexRows, IndexField, IndexRow, ctrl)
              End Select
            End If
      
            Set Field.Info = m_PageSetting.Item(ctrl.Key)
            Field.Top = Field.Info.Aspect.Top + Offset
      
            If ctrl.HasFormulaHide Then
              Field.Visible = Val(m_Compiler.ResultFunction(ctrl.FormulaHide))
            Else
              Field.Visible = True
            End If
          Next
        End If
      Next
    Else
      If Where = c_Headers Then
        Offset = Offset - Sec.Aspect.Height
      ElseIf Where = c_Footers Then
        Offset = Offset + Sec.Aspect.Height
      End If
    End If
  Next
End Sub

Private Function CreatePageSetting() As Boolean
' Limpio la coleccion
  m_PageSetting.Clear
  
  m_PageSetting.Height = m_LaunchInfo.Printer.PaperInfo.Height
  
  Dim Sec     As cReportSection
  Dim Secline As cReportSectionLine
  Dim ctrl    As cReportControl
  
' Por cada Header
  For Each Sec In m_Headers
    For Each Secline In Sec.SectionLines
      For Each ctrl In Secline.Controls
        With m_PageSetting.Add(Secline, , ctrl.Key)
          Set .Aspect = ctrl.Label.Aspect
          .Name = ctrl.Name
          .FieldType = ctrl.Field.FieldType
          .Tag = ctrl.Tag
        End With
      Next
    Next
  Next

' Por cada Detail
  For Each Sec In m_Details
    For Each Secline In Sec.SectionLines
      For Each ctrl In Secline.Controls
        With m_PageSetting.Add(Secline, , ctrl.Key)
          Set .Aspect = ctrl.Label.Aspect
          .Name = ctrl.Name
          .FieldType = ctrl.Field.FieldType
          .Tag = ctrl.Tag
        End With
      Next
    Next
  Next

' Por cada Footer
  Dim Offset As Long
  
  With m_LaunchInfo.Printer.PaperInfo
    If .PaperSize = vbPRPSUser Then
      Offset = m_OriginalHeight - .CustomHeight
    End If
  End With
  
  For Each Sec In m_Footers
    For Each Secline In Sec.SectionLines
      For Each ctrl In Secline.Controls
        With m_PageSetting.Add(Secline, , ctrl.Key)
          Set .Aspect = ctrl.Label.Aspect
          With .Aspect
            .Top = .Top - Offset
          End With
          .Name = ctrl.Name
          .FieldType = ctrl.Field.FieldType
          .Tag = ctrl.Tag
        End With
      Next
    Next
  Next

' Por cada grupo
  Dim Grp As cReportGroup

  For Each Grp In m_Groups
    ' Header
    For Each Secline In Grp.Header.SectionLines
      For Each ctrl In Secline.Controls
        With m_PageSetting.Add(Secline, , ctrl.Key)
          Set .Aspect = ctrl.Label.Aspect
          .Name = ctrl.Name
          .FieldType = ctrl.Field.FieldType
          .Tag = ctrl.Tag
        End With
      Next
    Next
  
    ' Footer
    For Each Secline In Grp.Footer.SectionLines
      For Each ctrl In Secline.Controls
        With m_PageSetting.Add(Secline, , ctrl.Key)
          Set .Aspect = ctrl.Label.Aspect
          .Name = ctrl.Name
          .FieldType = ctrl.Field.FieldType
          .Tag = ctrl.Tag
        End With
      Next
    Next
  Next

  CreatePageSetting = True
End Function

Private Function pGetDataAux(ByRef Recordsets As Collection) As Boolean
  Dim Connect As cReportConnect
  
  For Each Connect In m_ConnectsAux
    ReDim Preserve m_vCollRows(UBound(m_vCollRows) + 1)
    If Not pGetData(m_vCollRows(UBound(m_vCollRows)), Nothing, Connect, False, Recordsets) Then Exit Function
  Next
  
  ReDim m_vRowsIndexAux(UBound(m_vCollRows))
  
  pGetDataAux = True
End Function

Private Sub pGetNextRs(ByRef rs As Recordset)
  On Error Resume Next
  Err.Clear
  Set rs = rs.NextRecordset
  If Err.Number Then Set rs = Nothing
End Sub

Private Function pGetData(ByRef vRows As Variant, _
                          ByRef rs As ADODB.Recordset, _
                          ByRef Connect As cReportConnect, _
                          ByVal CreateIndexVector As Boolean, _
                          ByRef Recordsets As Collection) As Boolean
                          
  Dim StrConnect    As String
  Dim SaveInReport  As Boolean
  Dim cn            As cDataBase
  Dim varRs         As Variant
  Dim rsAux         As Recordset

  ' Si expecifican un string
  ' de conexion
  If LenB(Trim$(m_LaunchInfo.StrConnect)) > 0 Then
    StrConnect = m_LaunchInfo.StrConnect
  ' Si no expecifican un string
  ' de conexion uso el que esta en
  ' Connect
  Else
    StrConnect = Connect.StrConnect
    SaveInReport = True
  End If
  
  If Not ReportDisconnected Then
  
    If Trim$(StrConnect) = vbNullString Then
      MsgWarning "No se ha especificado la información de conexión. " & _
                 "Tanto el objeto LaunchInfo como el objeto Connect del " & _
                 "reporte tiene su propiedad StrConnect vacia. Sin este " & _
                 "'string de conexión' es imposible abrir la conexión con " & _
                 "la fuente de datos", "CSReportEditor"
      Exit Function
    End If
    
    Set cn = New CSDataBaseClient2.cDataBase
    
    If m_IsForWeb Then
      cn.Silent = True
    End If
    
    With Connect
      If .CommandTimeout > 0 Then cn.CommandTimeout = .CommandTimeout
      If .ConnectionTimeout > 0 Then cn.ConnectionTimeout = .ConnectionTimeout
    End With
    
    ' Abro una conexion
    If Not cn.InitDB(, , , , StrConnect) Then
      
      If Not ResumeDBAccessMissing(StrConnect, SaveInReport, cn) Then Exit Function
    End If
    
    ' Preparo la sentencia
    Dim Sqlstmt As String
    Dim CommandType As CSDataBaseClient2.csCommandType
    
    ' Si especifico una sentencia
    If LenB(Trim$(m_LaunchInfo.Sqlstmt)) > 0 Then
      Sqlstmt = m_LaunchInfo.Sqlstmt
      CommandType = CSDataBaseClient2.csCommandType.csCmdUnknown
    Else
      If Connect.DataSourceType = csDataSourceType.cdDTProcedure Then
        Sqlstmt = "exec [" & Connect.DataSource & "] " & Connect.sqlParameters
        CommandType = CSDataBaseClient2.csCommandType.csCmdSp
      ElseIf Connect.DataSourceType = csDataSourceType.csDTTable Then
        Sqlstmt = "select * from [" & Connect.DataSource & "]"
        CommandType = CSDataBaseClient2.csCommandType.csCmdTable
      Else
        Sqlstmt = Connect.DataSource
        CommandType = CSDataBaseClient2.csCommandType.csCmdTable
      End If
    End If
  
    ' Abro el recordset
    cn.OpenRSExDescrip = m_DescripUser
    If Not cn.OpenRsEX(True, False, False, Sqlstmt, rs, CSDataBaseClient2.csTypeCursor.csRsStatic, _
                       CSDataBaseClient2.csTypeLock.csLockReadOnly, _
                       , "GetData", C_Module, vbNullString, 1) Then Exit Function
    
    If rs.EOF And rs.BOF Then
      vRows = Empty
      
      If CreateIndexVector Then ReDim m_vRowsIndex(0)
    Else
      vRows = rs.GetRows()
    
      If CreateIndexVector Then
        ' Creo el vector de indices
        ReDim m_vRowsIndex(UBound(vRows, 2))
        Dim k As Long
        For k = 0 To UBound(m_vRowsIndex)
          m_vRowsIndex(k) = k
        Next
      End If
    End If
    
    Set rsAux = rs
    
    ' Voy a cargar en la coleccion de RecordSets todos los rs de todos los
    ' datasource (Esto soporta multiples recordset en un mismo DataSource)
    Do
    
      varRs = Empty
      ReDim varRs(1)
      Set varRs(0) = rsAux
      varRs(1) = Connect.DataSource
      Recordsets.Add varRs
      
      pGetNextRs rsAux
      
      ' Si hay mas recordset redimensiono el vector para que no fallen los indices
      '
      If Not rsAux Is Nothing Then
        ' Reservo una posicion en el vector que no se usa
        '
        ReDim Preserve m_vCollRows(UBound(m_vCollRows) + 1)
      Else
        Exit Do
      End If
    Loop
    
    ' Desconecto el recordset
    Set rs.ActiveConnection = Nothing
    
    ' Cierro la conexion por que ya no la necesito
    cn.CloseDb
  Else
    vRows = Empty
    If CreateIndexVector Then ReDim m_vRowsIndex(0)
  End If
  
  If Not IsEmpty(m_vRows) Then
    m_RecordCount = UBound(m_vRowsIndex)
  Else
    m_RecordCount = 0
  End If
  m_iRow = 0
  m_idxGroupHeader = 0
  m_idxGroupFooter = 0
  
  pGetData = True
End Function

Private Sub pInitRowFormulas()
  Dim i As Integer
  
  ReDim m_LastRowPreEvalued(2)
  ReDim m_LastRowPostEvalued(2)
  
  For i = 0 To 2
    m_LastRowPreEvalued(i) = -1
    m_LastRowPostEvalued(i) = -1
  Next
  
  For i = 0 To m_GroupCount
    m_vGroups(i).LastHPreRowEvalued = -1
    m_vGroups(i).LastHPostRowEvalued = -1
  
    m_vGroups(i).LastFPreRowEvalued = -1
    m_vGroups(i).LastFPostRowEvalued = -1
  Next
End Sub

Private Function nLoad(ByRef DocXml As CSXml2.cXml) As Boolean
  
  pDestroyCrossRef m_Headers
  pDestroyCrossRef m_Details
  pDestroyCrossRef m_Footers
  pDestroyCrossRef m_Groups.GroupsHeaders
  pDestroyCrossRef m_Groups.GroupsFooters
  
  m_Headers.Clear
  m_Groups.Clear
  m_Details.Clear
  m_Footers.Clear
  m_Controls.Clear
  m_Formulas.Clear
  m_Connect.Columns.Clear
  m_Connect.Parameters.Clear
  
  Set m_Details.CopyColl = m_Controls
  Set m_Headers.CopyColl = m_Controls
  Set m_Footers.CopyColl = m_Controls
  Set m_GroupsHeaders.CopyColl = m_Controls
  Set m_GroupsFooters.CopyColl = m_Controls
  
  If Not LoadAux(DocXml, m_Headers, c_NodeRptHeaders) Then Exit Function
  If Not LoadAux(DocXml, m_Details, c_NodeRptDetails) Then Exit Function
  If Not LoadAux(DocXml, m_Footers, c_NodeRptFooters) Then Exit Function
  
  If Not LoadGroups(DocXml) Then Exit Function
  
  pFixGroupIndex
  
  If Not LoadConnect(DocXml) Then Exit Function
  If Not LoadConnectsAux(DocXml) Then Exit Function
  If Not LoadLaunchInfo(DocXml) Then Exit Function
  
  LoadPaperInfo DocXml
  
  SortCollection
  
  m_OriginalHeight = m_PaperInfo.CustomHeight
  
  nLoad = True
End Function

Private Sub pFixGroupIndex()
  Dim Group As cReportGroup
  Dim Idx   As Long
  
  For Each Group In m_Groups
    Idx = Idx + 1
    Group.Indice = Idx
  Next
End Sub

Private Sub LoadPaperInfo(ByRef DocXml As CSXml2.cXml)
  Dim NodObj As Object
  
  Set NodObj = DocXml.GetRootNode()
  Set NodObj = DocXml.GetNodeFromNode(NodObj, c_NodePaperInfo)
  If Not m_PaperInfo.Load(DocXml, NodObj) Then Exit Sub
End Sub

Private Sub SortCollection()
  SortCollectionAux m_Headers
  SortCollectionAux m_Details
  SortCollectionAux m_Footers
  SortCollectionAux m_GroupsFooters
  SortCollectionAux m_GroupsHeaders
End Sub
  
Private Sub SortCollectionAux(ByRef Col As cReportSections)
  Dim Sec As cReportSection
  Dim SecLn As cReportSectionLine
  
  For Each Sec In Col
    For Each SecLn In Sec.SectionLines
      Set SecLn.Controls = GetControlsInZOrder(SecLn.Controls)
    Next
  Next
End Sub

Private Function LoadAux(ByRef DocXml As CSXml2.cXml, ByRef Sections As cReportSections, ByVal KeySection As String) As Boolean
  Dim NodObj As Object
  Dim NodObjAux As Object
  Dim NodObjSec As Object
  
  Set NodObj = DocXml.GetRootNode()
  
  Set NodObj = DocXml.GetNodeFromNode(NodObj, KeySection)
  
  If DocXml.NodeHasChild(NodObj) Then
    Set NodObjSec = DocXml.GetNodeChild(NodObj)
    
    While Not NodObjSec Is Nothing
      Set NodObjAux = NodObjSec
        If Not Sections.Add(, DocXml.GetNodeProperty(NodObjAux, "Key").Value(csText)).Load(DocXml, NodObjAux) Then Exit Function
      Set NodObjSec = DocXml.GetNextNode(NodObjSec)
    Wend
  End If
  
  LoadAux = True
End Function

Private Function LoadFormulas(ByRef DocXml As CSXml2.cXml) As Boolean
  Dim NodObj As Object
  Dim NodObjAux As Object
  Dim NodObjSec As Object
  
  Set NodObj = DocXml.GetRootNode()
  
  Set NodObj = DocXml.GetNodeFromNode(NodObj, c_NodeRptFormulas)
  If DocXml.NodeHasChild(NodObj) Then
    Set NodObjSec = DocXml.GetNodeChild(NodObj)
    While Not NodObjSec Is Nothing
      Set NodObjAux = NodObjSec
      If Not m_Formulas.Add(DocXml.GetNodeProperty(NodObjAux, "Name").Value(csText)).Load(DocXml, NodObjAux) Then Exit Function
      Set NodObjSec = DocXml.GetNextNode(NodObjSec)
    Wend
  End If

  LoadFormulas = True
End Function

Private Function LoadConnect(ByRef DocXml As CSXml2.cXml) As Boolean
  Dim NodObj As Object
  Dim NodObjSec As Object
  
  Set NodObj = DocXml.GetRootNode()
  
  Set NodObj = DocXml.GetNodeFromNode(NodObj, c_RptConnect)
  
  LoadConnect = m_Connect.Load(DocXml, NodObj)
End Function

Private Function LoadConnectsAux(ByRef DocXml As CSXml2.cXml) As Boolean
  Dim NodObj As Object
  Dim NodObjSec As Object
  
  Set NodObj = DocXml.GetRootNode()
  
  Set NodObj = DocXml.GetNodeFromNode(NodObj, c_RptConnectsAux)
  
  LoadConnectsAux = m_ConnectsAux.Load(DocXml, NodObj)
End Function

Private Function LoadGroups(ByRef DocXml As CSXml2.cXml) As Boolean
  Dim NodObj As Object
  Dim NodObjAux As Object
  Dim NodObjGroup As Object
  
  Set NodObj = DocXml.GetRootNode()
  
  Set NodObj = DocXml.GetNodeFromNode(NodObj, c_NodeGroups)
  If DocXml.NodeHasChild(NodObj) Then
    Set NodObjGroup = DocXml.GetNodeChild(NodObj)
    While Not NodObjGroup Is Nothing
      Set NodObjAux = NodObjGroup
      If Not Groups.Add(, DocXml.GetNodeProperty(NodObjAux, "Key").Value(csText)).Load(DocXml, NodObjAux) Then Exit Function
      Set NodObjGroup = DocXml.GetNextNode(NodObjGroup)
    Wend
  End If
  
  LoadGroups = True
End Function

Private Function LoadLaunchInfo(ByRef DocXml As CSXml2.cXml) As Boolean
  Dim NodObj As Object
  Dim NodObjSec As Object
  
  Set NodObj = DocXml.GetRootNode()
  
  Set NodObj = DocXml.GetNodeFromNode(NodObj, c_LaunchInfo)
  
  LoadLaunchInfo = m_LaunchInfo.Load(DocXml, NodObj)
End Function

Private Function GetFileName(ByVal FileNameWithExt As String) As String
  Dim fAux As New CSKernelFile.cFile
  GetFileName = fAux.GetFileNameSinExt(FileNameWithExt)
End Function

Private Function nLoadData(ByRef DocXml As CSXml2.cXml) As Boolean
  Dim NodObj As Object
  Dim NodObjAux As Object
  Dim NodObjSec As Object
  
  m_Pages.Clear

  Set NodObj = DocXml.GetRootNode()
  
  Set NodObj = DocXml.GetNodeFromNode(NodObj, c_NodeRptPages)
  If DocXml.NodeHasChild(NodObj) Then
    Set NodObjSec = DocXml.GetNodeChild(NodObj)
    While Not NodObjSec Is Nothing
      Set NodObjAux = NodObjSec
      If Not m_Pages.Add().Load(DocXml, NodObjAux) Then Exit Function
      Set NodObjSec = DocXml.GetNextNode(NodObjSec)
    Wend
  End If
  nLoadData = True
End Function

Private Sub ReportDone()
  RaiseEvent Done
End Sub

Private Function ShowProgress(ByVal Task As String, Optional ByVal Page As Long = 0, _
                            Optional ByVal CurrRecord As Long = 0, Optional ByVal RecordCount As Long = 0) As Boolean
  Dim Cancel As Boolean
  RaiseEvent Progress(Task, Page, CurrRecord, RecordCount, Cancel)
  ShowProgress = Not Cancel
End Function

Private Function ResumeDBAccessMissing(ByVal StrConnect As String, ByVal SaveInReport As Boolean, ByRef cn As cDataBase) As Boolean
  On Error GoTo ControlError
  
  Dim Answer As Boolean
  Dim CommDialog As CommonDialog
  
  ' Si no es una base access no hago nada
  If InStr(StrConnect, "PROVIDER=Microsoft.Jet.OLEDB.4.0;", vbTextCompare) = 0 Then Exit Function
  
  
  ' Obtengo el nombre
  Dim sFile As String
  sFile = GetToken(StrConnect, "Data Source")
  
  ' Le pregunto al usuario si quiere buscarla
  RaiseEvent FindFileAccess(Answer, CommDialog, sFile)
  
  If Not Answer Then Exit Function
  
  Dim File As New CSKernelFile.cFile
  
  File.Filter = "Archivos Access|*.mdb"
  File.Init "ResumeDBAccessMissing", C_Module, CommDialog
  
  
  If Not File.FOpen(m_PathDefault & "\" & sFile, CSKernelClient2.csFile.csRead, False, False, , True, True) Then Exit Function
  
  sFile = File.FullName
  
  File.FClose
  
  StrConnect = "PROVIDER=Microsoft.Jet.OLEDB.4.0;Data Source=" + sFile
  
  If Not cn.InitDB(, , , , StrConnect) Then Exit Function
  
  ' Lo guardo en el reporte
  If SaveInReport Then m_Connect.StrConnect = StrConnect
  
  ResumeDBAccessMissing = True
  
  GoTo ExitProc
ControlError:
  MngError Err(), "ResumeDBAccessMissing", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function GetToken(ByVal Source As String, ByVal Token As String) As String
  Dim p As Long
  Token = Trim$(Token)
  If Right$(Token, 1) <> "=" Then Token = Token + "="
  p = InStr(Source, Token)
  If p = 0 Then Exit Function
  Dim p2 As Long
  p2 = p + 1
  p = InStr(p2, Source, ";")
  
  If p = 0 Then p = Len(Source) + 1
  p2 = p2 + Len(Token) - 1
  p = p - p2
  GetToken = Mid$(Source, p2, p)
End Function

Private Sub pSortControlsByLeft()
  pSortControlsByLeftAux1 m_Headers
  pSortControlsByLeftAux1 m_GroupsHeaders
  pSortControlsByLeftAux1 m_Details
  pSortControlsByLeftAux1 m_GroupsFooters
  pSortControlsByLeftAux1 m_Footers
End Sub

Private Sub pSortControlsByLeftAux1(ByRef Sections As cReportSections)
  Dim Sec As cReportSection
  Dim SecLn As cReportSectionLine
  
  For Each Sec In Sections
    For Each SecLn In Sec.SectionLines
      SecLn.Controls.OrderCollByLeft
    Next
  Next
End Sub

' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError
  
#If PREPROC_DEBUG Then
  gdbInitInstance C_Module
#End If
  
  Set m_Headers = New cReportSections
  Set m_Details = New cReportSections
  Set m_Footers = New cReportSections
  Set m_Groups = New cReportGroups
  Set m_GroupsHeaders = Groups.GroupsHeaders
  Set m_GroupsFooters = Groups.GroupsFooters
  Set m_PaperInfo = New cReportPaperInfo
  Set m_Controls = New cReportControls2
  Set m_Formulas = New cReportFormulas
  Set m_FormulaTypes = New cReportFormulaTypes
  Set m_Connect = New cReportConnect
  Set m_PageSetting = New cReportPageSetting
  Set m_Pages = New cReportPages
  
  Set m_Compiler = New cReportCompiler
  
  Set ConnectsAux = New cReportConnectsAux
  
  Set m_Details.CopyColl = m_Controls
  Set m_Headers.CopyColl = m_Controls
  Set m_Footers.CopyColl = m_Controls
  Set m_GroupsHeaders.CopyColl = m_Controls
  Set m_GroupsFooters.CopyColl = m_Controls
  
  m_Details.TypeSection = csRptTypeSection.csRptTpScDetail
  m_Headers.TypeSection = csRptTypeSection.csRptTpScHeader
  m_Footers.TypeSection = csRptTypeSection.csRptTpScFooter
  m_GroupsHeaders.TypeSection = csRptTypeSection.csRptTpGroupHeader
  m_GroupsFooters.TypeSection = csRptTypeSection.csRptTpGroupFooter
  
  m_Details.MainTypeSection = csRptTypeSection.csRptTpMainSectionDetail
  m_Headers.MainTypeSection = csRptTypeSection.csRptTpMainSectionHeader
  m_Footers.MainTypeSection = csRptTypeSection.csRptTpMainSectionFooter

  GoTo ExitProc
ControlError:
  MngError Err(), "Class_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
  
  ReDim m_vRows(0)
  ReDim m_vCollRows(0)
  ReDim m_vRowsIndexAux(0)
  ReDim m_vGroups(0)
  ReDim m_vRowsIndex(0)
  ReDim m_LastRowPreEvalued(0)
  ReDim m_LastRowPostEvalued(0)
  
  m_Controls.Clear
  Set m_Controls = Nothing
  
  pDestroyCrossRef m_Headers
  pDestroyCrossRef m_Details
  pDestroyCrossRef m_Footers
  pDestroyCrossRef m_Groups.GroupsHeaders
  pDestroyCrossRef m_Groups.GroupsFooters
  
  m_Headers.Clear
  m_Details.Clear
  m_Footers.Clear
  m_GroupsHeaders.Clear
  m_GroupsFooters.Clear
  
  Set m_Details.CopyColl = Nothing
  Set m_Headers.CopyColl = Nothing
  Set m_Footers.CopyColl = Nothing
  Set m_GroupsHeaders.CopyColl = Nothing
  Set m_GroupsFooters.CopyColl = Nothing
  
  Set m_Headers = Nothing
  Set m_Details = Nothing
  Set m_Footers = Nothing
  Set m_GroupsHeaders = Nothing
  Set m_GroupsFooters = Nothing
  
  Set m_PaperInfo = Nothing
  
  m_Formulas.Clear
  Set m_Formulas = Nothing
  
  m_FormulaTypes.Clear
  Set m_FormulaTypes = Nothing
  
  Set m_Connect = Nothing
  
  m_Pages.Clear
  Set m_Pages = Nothing
  
  m_PageSetting.Clear
  Set m_PageSetting = Nothing
  
  Set m_Compiler = Nothing
  Set m_Link = Nothing
  Set m_LaunchInfo = Nothing
  
  m_ConnectsAux.Clear
  Set m_ConnectsAux = Nothing
  
  pDestroyImages
  Set m_CollhImages = Nothing

#If PREPROC_DEBUG Then
  gdbTerminateInstance C_Module
#End If
End Sub

Private Sub pDestroyCrossRef(ByRef Secs As cReportSections)
  Dim Sec     As cReportSection
  Dim secl    As cReportSectionLine
  
  For Each Sec In Secs
    For Each secl In Sec.SectionLines
      Set secl.Controls.SectionLine = Nothing
      
      If Not secl.Controls.CopyColl Is Nothing Then
        secl.Controls.CopyColl.Clear
      End If
      Set secl.Controls.CopyColl = Nothing
      
      secl.Controls.Clear
      Set secl.Controls = Nothing
    Next
    Set Sec.CopyColl = Nothing
  Next
  
  Set Secs.CopyColl = Nothing
End Sub

Private Function pGetMainDataSource(ByRef Recordsets As Collection) As String
  If Recordsets.Count Then
    pGetMainDataSource = Recordsets.Item(1)(1)
  End If
End Function

'////////////////////////////////////////////////////////////////////////////
' Util para detectar Bugs cuando corro desde IIS
'

  'Private Sub pSaveLog(ByVal Msg As String)
  '  On Error Resume Next
  '  Dim f As Integer
  '  f = FreeFile
  '  Open "D:\Proyectos\CSHtml\CrowSoft\Reports\webreport.log" For Append As f
  '  Print #f, Now & " " & Msg
  '  Close f
  'End Sub

'////////////////////////////////////////////////////////

Private Sub pSetIndexColInGroupFormulas(ByRef Recordsets As Collection)

  pSetIndexColInGroupFormulasAux m_Headers, Recordsets
  pSetIndexColInGroupFormulasAux m_GroupsHeaders, Recordsets
  pSetIndexColInGroupFormulasAux m_GroupsFooters, Recordsets
  pSetIndexColInGroupFormulasAux m_Details, Recordsets
  pSetIndexColInGroupFormulasAux m_Footers, Recordsets
  
End Sub

Private Function pSetIndexColInGroupFormulasAux(ByRef Sections As cReportSections, _
                                                ByRef Recordsets As Collection) As Boolean
  Dim Sec    As cReportSection
  Dim SecLn  As cReportSectionLine
  Dim ctrl   As cReportControl
  
  For Each Sec In Sections
    If Sec.HasFormulaHide Then
      pSetIndexColInGroupFormula Sec.FormulaHide, Recordsets
    End If
    For Each SecLn In Sec.SectionLines
      If SecLn.HasFormulaHide Then
        pSetIndexColInGroupFormula SecLn.FormulaHide, Recordsets
      End If
      For Each ctrl In SecLn.Controls
        If ctrl.HasFormulaHide Then
          pSetIndexColInGroupFormula ctrl.FormulaHide, Recordsets
        End If
        If ctrl.HasFormulaValue Then
          pSetIndexColInGroupFormula ctrl.FormulaValue, Recordsets
        End If
      Next
    Next
  Next

End Function

Private Function pSetIndexColInGroupFormula(ByRef Formula As cReportFormula, _
                                            ByRef Recordsets As Collection) As Boolean
  Dim Fint As cReportFormulaInt
  Dim colName As String
  Dim rs As ADODB.Recordset
  
  If Not m_ReportDisconnected Then
  
    Set rs = Recordsets.Item(1)(0)
    
    For Each Fint In Formula.FormulasInt
    
      If pIsGroupFormula(Fint.FormulaType) Then
        
        colName = Fint.Parameters(1).Value
        
        pSetColIndexInGroupFormulaAux rs, Fint, colName, c_KeyIndexCol
        
        If Fint.FormulaType = mAux.csRptFormulaType.csRptGroupPercent Then
        
          colName = Fint.Parameters(2).Value
          pSetColIndexInGroupFormulaAux rs, Fint, colName, c_KeyIndexCol2
        
        End If
        
      End If
      
    Next
    
  End If

End Function

Private Sub pSetColIndexInGroupFormulaAux(ByRef rs As ADODB.Recordset, _
                                          ByRef Fint As cReportFormulaInt, _
                                          ByVal colName As String, _
                                          ByVal KeyParam As String)
  Dim i As Long
  
  For i = 0 To rs.Fields.Count - 1
  
    If LCase$(colName) = LCase$(rs.Fields.Item(i).Name) Then
      
      If Fint.Parameters.Item(KeyParam) Is Nothing Then
        Fint.Parameters.Add2 vbNullString, KeyParam
      End If
      
      Fint.Parameters.Item(KeyParam).Value = i
      Exit For
    End If
  Next

End Sub

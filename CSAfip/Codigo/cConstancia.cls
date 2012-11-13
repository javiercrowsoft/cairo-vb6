VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cConstancia"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIABMClient
Implements CSMenu.cIMenuClient
'--------------------------------------------------------------------------------
' cSaldoInicial
' 04-12-2004

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cSaldoInicial"

Private Const c_logFile = "logFile"
Private Const c_folder = "folder"
Private Const c_Progress = "prg"
Private Const c_Cuit = "cuit"
Private Const c_cli_chk = "clichk"
Private Const c_prov_chk = "provchk"
Private Const c_showWnd = "shownd"

Private Const K_LOGFILE = 1
Private Const K_CLI_ID = 2
Private Const K_FOLDER = 3
Private Const K_PROGRESS = 4
Private Const K_CUIT = 5
Private Const K_CANCEL = 6
Private Const K_PROV_ID = 7
Private Const K_CLI_CHECK = 8
Private Const K_PROV_CHECK = 9
Private Const K_SHOW_WND = 10

Private Const cscCliId                               As String = "cli_id"
Private Const cscProvId                              As String = "prov_id"

Private Const cscNombre                              As String = "nombre"
Private Const cscCodigo                              As String = "codigo"
Private Const cscCuit                                As String = "cuit"
Private Const cscQueEs                               As String = "QueEs"

' estructuras
' variables privadas
Private m_Editing           As Boolean
Private m_Host              As CSMenu.cIMenuHost
Private m_ObjAbm            As cIABMGeneric

Private m_bCancel           As Boolean

Private m_logFile           As String
' eventos
' propiedades publicas
' propiedades friend
' propiedades privadas
' funciones publicas
Private Function cIABMClient_Copy() As Boolean
End Function

Private Function cIABMClient_EditNew() As Boolean
End Function

Private Property Get cIABMClient_Aplication() As String
  cIABMClient_Aplication = gAppName
End Property

Private Property Get cIABMClient_CanAddDocDigital() As Boolean
  cIABMClient_CanAddDocDigital = False
End Property

Private Property Get cIABMClient_CanCopy() As Boolean
  cIABMClient_CanCopy = False
End Property

Private Property Get cIABMClient_CanNew() As Boolean
  cIABMClient_CanNew = False
End Property

Private Function cIABMClient_ShowDocDigital() As Boolean
  cIABMClient_ShowDocDigital = False
End Function

Private Function cIABMClient_MessageEx(ByVal MessageID As Long, ByVal Info As Variant) As Variant
  cIABMClient_MessageEx = True
End Function

Private Sub cIABMClient_DiscardChanges()
  LoadCollection
End Sub

Private Function cIABMClient_ListAdHock(List As CSInterfacesABM.cIABMList) As Boolean
End Function

Private Sub cIABMClient_Load()
End Sub

Private Function cIABMClient_PropertyChange(ByVal Key As Integer) As Boolean
  Select Case Key
    Case K_CANCEL
      If Ask(LNGGetText(2973, vbNullString), vbNo) Then
              'Confirma que desea cancelar
        m_bCancel = True
      End If
    Case K_PROV_CHECK
      With m_ObjAbm.Properties
        .Item(cscProvId).Enabled = Val(.Item(c_prov_chk).Value)
        m_ObjAbm.ShowValue .Item(cscProvId)
      End With
    Case K_CLI_CHECK
      With m_ObjAbm.Properties
        .Item(cscCliId).Enabled = Val(.Item(c_cli_chk).Value)
        m_ObjAbm.ShowValue .Item(cscCliId)
      End With
  End Select
End Function

Private Function cIABMClient_Save() As Boolean
  cIABMClient_Save = pProcess()
End Function

Private Function cIABMClient_Terminate() As Boolean
  m_Editing = False
  cIABMClient_Terminate = True
End Function

Private Property Get cIABMClient_Title() As String
  cIABMClient_Title = LNGGetText(2974, vbNullString) 'Obtener Constancia de Inscripción AFIP
End Property

Private Function cIABMClient_Validate() As Boolean

  Dim IProperty     As cIABMProperty
  Dim bAtLeastOne   As Boolean

  CSKernelClient2.Title = LNGGetText(2974, vbNullString) 'Obtener Constancia de Inscripción AFIP

  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_LOGFILE
          If LenB(.Value) = 0 Then
            MsgWarning LNGGetText(2975, vbNullString) 'Debe indicar un archivo para el log de las operaciones.
            Exit Function
          End If
        Case K_FOLDER
          If LenB(.Value) = 0 Then
            MsgWarning LNGGetText(2976, vbNullString) 'Debe indicar un carpeta para guardar las Constancias.
            Exit Function
          End If
        Case K_CLI_CHECK, K_PROV_CHECK
          If Val(.Value) Then bAtLeastOne = True
      End Select
    End With
  Next

  If Not bAtLeastOne Then
    MsgWarning LNGGetText(2977, vbNullString) 'Debe seleccionar, al menos, Proveedores o Clientes.
    Exit Function
  End If

  cIABMClient_Validate = True
End Function

' ////////////////////////////////
' ////////////////////////////////
' ////////////////////////////////
' ////////////////////////////////
' ////////////////////////////////
' ////////////////////////////////

' Menu
Private Function cIMenuClient_Initialize(F As Object, Host As CSMenu.cIMenuHost) As Boolean
  On Error GoTo ControlError
  Dim str_2978 As String
  
  str_2978 = LNGGetText(2978, vbNullString)   'A&fip
  Set m_Host = Host
  m_Host.Server.AddMenu str_2978, csMenuConfig, C_MenuConfig, 0, True, False, False, False, True, Nothing
  m_Host.Server.AddMenu LNGGetText(2978, vbNullString), csPreAfipGetConstancia, str_2978, 0, True, False, False, False, False, Me
                        '&Obtener Constancia AFIP
                        
  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, C_MenuClientInit, C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal ID As Long) As Variant
  pEdit
End Function

Private Sub pEdit()
  On Error GoTo ControlError
  
  Set m_ObjAbm = New cABMGeneric
  
  If Not SecurityCanAccess(csPreAfipGetConstancia) Then Exit Sub

  If Not LoadCollection() Then Exit Sub
  
  m_Editing = True
  
  Exit Sub
ControlError:
  MngError Err, "pEdit", C_Module, vbNullString
End Sub

Private Function LoadCollection() As Boolean

  m_ObjAbm.Properties.Clear
  
  With m_ObjAbm.Properties.Add(Nothing, c_cli_chk)
    .PropertyType = cspCheck
    .Name = LNGGetText(2980, vbNullString)   'Incluir Clientes
    .Key = K_CLI_CHECK
  End With
  
  With m_ObjAbm.Properties.Add(Nothing, cscCliId)
    .PropertyType = cspHelp
    .Table = csCliente
    .Width = 4000
    .Name = LNGGetText(1150, vbNullString)   'Cliente
    .Key = K_CLI_ID
    .Value = ""
    .Enabled = False
    .HelpId = csNO_ID
  End With
  
  With m_ObjAbm.Properties.Add(Nothing, c_prov_chk)
    .PropertyType = cspCheck
    .Name = LNGGetText(2981, vbNullString)   'Incluir Proveedores
    .Key = K_PROV_CHECK
  End With
  
  With m_ObjAbm.Properties.Add(Nothing, cscProvId)
    .PropertyType = cspHelp
    .Table = csProveedor
    .Width = 4000
    .Name = LNGGetText(1151, vbNullString)    'Proveedor
    .Key = K_PROV_ID
    .Value = ""
    .Enabled = False
    .HelpId = csNO_ID
  End With
  
  Dim oProperty As cABMProperty
  Set oProperty = m_ObjAbm.Properties.Item(cscCliId)
  oProperty.HelpType = csTree
  
  With m_ObjAbm.Properties.Add(Nothing, c_logFile)
    .PropertyType = cspFile
    .Width = 5000
    .Name = LNGGetText(2982, vbNullString)    'Archivo de Log
    .Key = K_LOGFILE
    .Value = GetValidPath(App.Path) & "CSAFIP.log"
    .HelpFilter = LNGGetText(2989, vbNullString)    'Archivo de Log|*.log
  End With
  
  With m_ObjAbm.Properties.Add(Nothing, c_folder)
    .PropertyType = cspFolder
    .Width = 5000
    .Name = LNGGetText(2353, vbNullString)    'Carpeta
    .Key = K_FOLDER
    .Value = LNGGetText(3061, vbNullString, GetValidPath(App.Path)) 'GetValidPath(App.Path) & "Constancias_Afip"
  End With
  
  With m_ObjAbm.Properties.Add(Nothing, c_showWnd)
    .PropertyType = cspCheck
    .Name = LNGGetText(2983, vbNullString)    'Mostrar ventana del Navegador
    .Width = 4000
    .Key = K_SHOW_WND
  End With
  
  With m_ObjAbm.Properties.Add(Nothing, c_Progress)
    .PropertyType = cspProgressBar
    .TopToPrevious = 560
    .Name = LNGGetText(2984, vbNullString)    'Progreso
    .Width = 7000
    .Key = K_PROGRESS
  End With
  
  With m_ObjAbm.Properties.Add(Nothing, c_Cuit)
    .PropertyType = cspLabel
    .Value = ""
    .Width = 5000
    .Key = K_CUIT
  End With
  
  With m_ObjAbm.Properties.Add(Nothing, "cancel")
    .PropertyType = cspButton
    .Name = LNGGetText(2985, vbNullString)    'Cancelar Importación
    .LeftLabel = -1
    .Key = K_CANCEL
  End With
  
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  AbmObj.bDontAskForSave = True
  AbmObj.OkCancelDialog = True
  AbmObj.MinHeight = 6800
  AbmObj.NotLockWnd = True
  m_ObjAbm.InModalWindow = True

  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function
' funciones friend
' funciones privadas
Private Sub pSaveLog(ByVal msg As String)
  On Error Resume Next
  Dim F As Integer
  F = FreeFile
  Open m_logFile For Append As F
  Print #F, Now & " " & msg
  Close F
End Sub

Private Sub MsgWarning(ByVal msg As String)
  pSaveLog LNGGetText(2990, vbNullString)    'Advertencia: & msg
  CSKernelClient2.MsgWarning msg
End Sub

Private Function pProcess() As Boolean
  Dim sqlstmt   As String
  Dim rs        As ADODB.Recordset
  Dim Folder    As String
  Dim errormsg  As String
  
  Dim MouseWait As cMouseWait
  Set MouseWait = New cMouseWait
  
  m_bCancel = False
  
  Dim iProg As cIABMProperty
  Dim iProl As cIABMProperty
  
  Set iProg = m_ObjAbm.Properties.Item(c_Progress)
  Set iProl = m_ObjAbm.Properties.Item(c_Cuit)
  
  iProg.Value = 0
  m_ObjAbm.ShowValue iProg
  
  iProl.Value = vbNullString
  m_ObjAbm.ShowValue iProl
  
  Folder = m_ObjAbm.Properties.Item(c_folder).Value
  m_logFile = m_ObjAbm.Properties.Item(c_logFile).Value
  
  pSaveLog "************************************************"
  pSaveLog LNGGetText(2986, vbNullString)    'Iniciando el Proceso de Obtención de Constancias
  
  If Not pCreateFolder(Folder) Then Exit Function

  With m_ObjAbm.Properties
  sqlstmt = "sp_AfipGetCuitForConstancia " _
                                & gDB.sqlString(.Item(cscCliId).HelpValueProcess) & "," _
                                & Val(.Item(c_prov_chk).Value) & "," _
                                & gDB.sqlString(.Item(cscProvId).HelpValueProcess) & "," _
                                & Val(.Item(c_cli_chk).Value)
  End With
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  If Not rs.EOF Then
    rs.MoveLast
    rs.MoveFirst
    
    Dim i     As Long
    Dim Count As Long
    
    Count = rs.RecordCount
    pSaveLog LNGGetText(2987, vbNullString, Count)   'Cantidad de filas: (1)
    
    While Not rs.EOF
    
      Sleep 5000
      
      If m_bCancel Then
        pSaveLog LNGGetText(2988, vbNullString, Count)   'Proceso cancelado
        Exit Function
      End If
    
      iProl.Value = LNGGetText(2991, vbNullString, i, Count, gDB.ValField(rs.Fields, cscCuit))
                    'Van " & i & " de " & Count & ". Buscando constancia para " & gDB.ValField(rs.Fields, cscCuit) & ...
      m_ObjAbm.ShowValue iProl
      
      DoEvents
    
      If pGetConstancia(Replace(gDB.ValField(rs.Fields, cscCuit), "-", ""), Folder, errormsg) Then
        pSaveLog LNGGetText(2992, vbNullString, gDB.ValField(rs.Fields, cscCuit))
                 'Constancia obtenida para el CUIT  & gDB.ValField(rs.Fields, cscCuit)
      Else
        pSaveLog LNGGetText(2993, vbNullString, gDB.ValField(rs.Fields, cscCuit), gDB.ValField(rs.Fields, cscCodigo), gDB.ValField(rs.Fields, cscNombre), gDB.ValField(rs.Fields, cscQueEs))
                 'No se pudo obtener la constancia para el cuit " & gDB.ValField(rs.Fields, cscCuit) _
                 & " (" & gDB.ValField(rs.Fields, cscCodigo) & ") " _
                 & gDB.ValField(rs.Fields, cscNombre) & " (" & gDB.ValField(rs.Fields, cscQueEs) & ")"
      End If
      
      i = i + 1
      
      iProg.Value = DivideByCero(i, Count) * 100
      m_ObjAbm.ShowValue iProg
      
      iProl.Value = LNGGetText(2994, vbNullString, i, Count) 'Van  & i &  de  & Count
      m_ObjAbm.ShowValue iProl
      
      DoEvents
      
      rs.MoveNext
    Wend
  Else
    pSaveLog LNGGetText(2995, vbNullString)  'No se indicaron CUITs a procesar
  End If
  
  pSaveLog LNGGetText(2996, vbNullString)  'Proceso Terminaado
  pSaveLog "************************************************"
  
  pProcess = True
End Function

Private Function pCreateFolder(ByVal Folder As String) As Boolean
  On Error GoTo ControlError
  
  If Not pExistsFolder(Folder) Then
    pCreateFolder = pCreateFolderAux(Folder, "")
  Else
    pCreateFolder = True
  End If
  
  GoTo ExitProc
ControlError:
  MngError Err, "Class_Terminate", C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pExistsFolder(ByVal Folder As String) As Boolean
  On Error Resume Next
  Dim rslt As String
  rslt = Dir(Folder, vbDirectory)
  If LenB(rslt) Then
    If Not GetAttr(Folder) And vbDirectory Then
      rslt = ""
    End If
  End If
  pExistsFolder = rslt <> ""
End Function

Private Function pCreateFolderAux2(ByVal Folder As String, Optional ByRef strError As String) As Boolean
  On Error Resume Next
  
  Err.Clear
  
  MkDir Folder
  
  strError = Err.Description
  
  pCreateFolderAux2 = Err.Number = 0
End Function

Private Function pCreateFolderAux(ByVal Folder As String, Optional ByRef strError As String) As Boolean
  On Error Resume Next
  
  Err.Clear
  
  If Not pExistsFolder(Folder) Then
    If Not pCreateFolderAux(pGetPath(Folder)) Then Exit Function
    If Not pCreateFolderAux2(Folder, strError) Then Exit Function
  End If
  
  strError = Err.Description
  pCreateFolderAux = Err.Number = 0
End Function

Private Function pGetPath(ByVal Folder As String) As String
  Dim i As Long
  
  For i = Len(Folder) To 1 Step -1
    If Mid(Folder, i, 1) = "\" Then
      If i > 1 Then pGetPath = Mid(Folder, 1, i - 1)
      Exit Function
    End If
  Next
End Function
Private Function pGetConstancia(ByVal cuit As String, ByVal Folder As String, ByRef errormsg As String) As Boolean
  On Error GoTo ControlError
  
  errormsg = ""
  
  Dim o
  Set o = CreateObject("CSGetConstanciaAFIP.cAfipPage")

  If Val(m_ObjAbm.Properties.Item(c_showWnd).Value) Then

    pGetConstancia = o.GetAFIPConstaciaEx(cuit, Folder)
  Else
    pGetConstancia = o.GetAFIPConstacia(cuit, Folder)
  End If

  GoTo ExitProc
ControlError:
  errormsg = Err.Description
  pSaveLog "Error: " & errormsg
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

' construccion - destruccion
Private Sub Class_Terminate()
  On Error Resume Next
  Set m_ObjAbm = Nothing
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

VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cImportPadEmbargo"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIABMClient
Implements CSMenu.cIMenuClient
'--------------------------------------------------------------------------------
' cImportPadronEmbargo
' 03-06-2009

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cImportPadronEmbargo"


Private Const c_filterProv = "filterprov"
Private Const c_file = "file"
Private Const c_Progress = "prg"
Private Const c_log = "log"
Private Const c_logFile = "logFile"
Private Const c_van = "van"

Private Const K_RETT_ID = 1
Private Const K_PERCT_ID = 2
Private Const K_FILE = 5
Private Const K_LABEL = 6
Private Const K_PROGRESS = 7
Private Const K_CANCEL = 8
Private Const K_LOGFILE = 12
Private Const K_LOG = 13
Private Const K_VAN = 14

Private Const c_ErrorSavePerRet = "Error al grabar padron de embargos"

' estructuras
Private Type t_Registro
  fecha         As String
  cuit          As String
  Saldo         As String
  RazonSocial   As String
  
  dSaldo        As Double
  dFecha        As Date
End Type

' variables privadas
Private m_Editing           As Boolean
Private m_Host              As CSMenu.cIMenuHost
Private m_ObjAbm            As cIABMGeneric

Private m_bCancel           As Boolean
Private m_logFile           As String

Private m_file              As String

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
      If Ask(LNGGetText(3730, vbNullString), vbNo) Then
              'Confirma que desea cancelar la importación de retenciones y percepciones
        m_bCancel = True
      End If
  End Select
End Function

Private Function cIABMClient_Save() As Boolean
  On Error GoTo ControlError
  
  Dim Mouse As cMouseWait
  
  Set Mouse = New cMouseWait
  
  m_bCancel = False
  
  Dim file        As String
  
  m_ObjAbm.Properties.Item(c_log).Value = ""
  m_ObjAbm.ShowValue m_ObjAbm.Properties.Item(c_log)

  m_logFile = m_ObjAbm.Properties.Item(c_logFile).Value
  
  pInitFile m_logFile
  
  pAddToLog "*****************************************", True
  pAddToLog LNGGetText(3731, vbNullString), True
            'Iniciando importación de retenciones y percepciones
            
  pAddToLog "", True
  
  file = m_ObjAbm.Properties.Item(c_file).Value
  
  ' Para grabar en ImportacionID.impid_descrip
  '
  m_file = file
  
  pAddToLog LNGGetText(3150, vbNullString, file), True
            'Archivo:  & file
  
  pAddToLog LNGGetText(3732, vbNullString, file), True
            'Abriendo Archivo: & file
    
  Dim iFile As Long
  iFile = FreeFile
  
  If Not pOpenFile(iFile) Then GoTo ExitProc
    
  Dim i           As Long
  Dim count       As Long
  Dim iProg       As cIABMProperty
  Dim iProgVan    As cIABMProperty
  
  pAddToLog LNGGetText(3156, vbNullString), True
            'Obteniendo la cantidad de filas
            
  count = pGetLines(iFile)
  
  Close iFile
  
  If Not pOpenFile(iFile) Then GoTo ExitProc
  
  pAddToLog LNGGetText(2987, vbNullString, count), False
            'Cantidad de filas:  & count
  
  Set iProg = m_ObjAbm.Properties.Item(c_Progress)
  Set iProgVan = m_ObjAbm.Properties.Item(c_van)
  
  Set Mouse = Nothing
  
  Screen.MousePointer = vbArrowHourglass
  
  Dim s       As String
  Dim cuit    As String
  
  While Not EOF(iFile)
    
    If m_bCancel Then GoTo ExitProc
    
    Line Input #iFile, s
  
    i = i + 1
    
    pSave s
    
    If i Mod 100 = 0 Then
    
      iProg.Value = i / count * 100
      iProgVan.Value = i
      
      m_ObjAbm.ShowValue iProg
      m_ObjAbm.ShowValue iProgVan
    
    End If
    
    DoEvents
  
  Wend
  
  MsgWarning "El sistema ha terminado de procesar el archivo.;;" & _
             "Consulte el archivo de log para confirmar que no ocurrieron errores.;;" & _
             "Tambien verifique el archivo de clientes y proveedores no encontrados o " & _
             "con CUIT invalido."
    
  CSKernelClient2.EditFile m_logFile, 0
  
  cIABMClient_Save = True

  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClient_Save", C_Module, vbNullString
  pAddToLog CSKernelClient2.LastErrorDescription, False
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
  Close iFile
  Screen.MousePointer = vbDefault
End Function

Private Sub pAddToLog(ByVal msg As String, _
                      ByVal bOnlyToFile As Boolean, _
                      Optional ByVal ID As String, _
                      Optional ByVal cliente As String, _
                      Optional ByVal filas As String)
  On Error Resume Next
  
  If LenB(ID) Then
    msg = msg & " - [" & ID & " " & cliente & " (" & filas & ")]"
  End If
  
  pSaveLog msg
  
  If Not bOnlyToFile Then
    Dim iProp As cIABMProperty
    Set iProp = m_ObjAbm.Properties.Item(c_log)
    With iProp
      .Value = .Value & msg & vbCrLf
    End With
    m_ObjAbm.ShowValue iProp
  End If
End Sub

Private Function cIABMClient_Terminate() As Boolean
  m_Editing = False
  cIABMClient_Terminate = True
End Function

Private Property Get cIABMClient_Title() As String
  cIABMClient_Title = LNGGetText(3733, vbNullString)  'Importar Perc./Ret. IIBB BS AS
End Property

Private Function cIABMClient_Validate() As Boolean

  Dim IProperty As cIABMProperty

  CSKernelClient2.Title = LNGGetText(3733, vbNullString)  'Importar Perc./Ret. IIBB BS AS

  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_FILE
          If LenB(.Value) = 0 Then
            MsgWarning LNGGetText(3766, vbNullString)
                       'Debe indicar un archivo de texto con el padron
            Exit Function
          End If
        Case K_LOGFILE
          If LenB(.Value) = 0 Then
            MsgWarning LNGGetText(2975, vbNullString)
                       'Debe indicar un archivo para el log de las operaciones
            Exit Function
          End If
      End Select
    End With
  Next

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
  Dim str_1032    As String

  str_1032 = LNGGetText(1032, vbNullString) '&Contabilidad
  
  Set m_Host = Host
  m_Host.Server.AddMenu str_1032, csMenuConfigContabilidad, C_MenuConfig, 0, True, False, False, False, True, Nothing
  m_Host.Server.AddMenu LNGGetText(4916, vbNullString), csPreGContImportPadronEmbargo, str_1032, 0, True, False, False, False, False, Me
                        '&Importar Tabla de Padron Embargo
  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, C_MenuClientInit, C_Module, vbNullString
  If Err.Number Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal ID As Long) As Variant
  pEdit
End Function

Private Sub pEdit()
  On Error GoTo ControlError
  
  Set m_ObjAbm = New cABMGeneric
  
  If Not SecurityCanAccess(csPreGContImportPadronEmbargo) Then Exit Sub

  If Not LoadCollection() Then Exit Sub
  
  m_Editing = True
  
  Exit Sub
ControlError:
  MngError Err, "pEdit", C_Module, vbNullString
End Sub

Private Function LoadCollection() As Boolean

  m_ObjAbm.Properties.Clear
  
  With m_ObjAbm.Properties.Add(Nothing, c_log)
    .PropertyType = cspText
    .SubType = cspMemo
    .Height = 1320
    .Width = 7000
    .Key = K_LOG
  End With
  
  With m_ObjAbm.Properties.Add(Nothing, c_logFile)
    .PropertyType = cspFile
    .Width = 5000
    .Name = LNGGetText(2982, vbNullString)  'Archivo de Log
    .Key = K_LOGFILE
    .Value = GetValidPath(App.Path) & "importar_padron_embargo.log"
    .HelpFilter = LNGGetText(2989, vbNullString)  'Archivo de Log|*.log
  End With
    
  With m_ObjAbm.Properties.Add(Nothing, c_file)
    .PropertyType = cspFile
    .Name = LNGGetText(2966, vbNullString)  'Archivo
    .Key = K_FILE
    .HelpFilter = LNGGetText(3734, vbNullString) 'TXT|*.txt
    .HelpId = csNO_ID
  End With
  
  With m_ObjAbm.Properties.Add(Nothing, c_Progress)
    .PropertyType = cspProgressBar
    .TopToPrevious = 560
    .Name = LNGGetText(2984, vbNullString) 'Progreso
    .Width = 7000
    .Key = K_PROGRESS
  End With
  
  With m_ObjAbm.Properties.Add(Nothing, c_van)
    .PropertyType = cspLabel
    .Name = LNGGetText(2984, vbNullString) 'Van
    .Key = K_VAN
  End With
  
  With m_ObjAbm.Properties.Add(Nothing, "cancel")
    .PropertyType = cspButton
    .Name = "Cancelar Importacion"
    .LeftLabel = -1
    .Key = K_CANCEL
  End With
  
  Dim AbmObj As cABMGeneric
  Set AbmObj = m_ObjAbm
  AbmObj.bDontAskForSave = True
  AbmObj.OkCancelDialog = True
  AbmObj.MinHeight = 8500
  AbmObj.NotLockWnd = True
  m_ObjAbm.InModalWindow = True

  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function
' funciones friend
' funciones privadas
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
'  If Err.Number Then Resume ExitProc
'ExitProc:
'  On Error Resume Next

Private Function pSave(ByVal s As String) As Boolean
  Dim Registro As t_Registro
  Dim sqlstmt  As String
  
  pLoadRegistro Registro, s
  
  sqlstmt = "sp_ImportPadronEmbargoUpdate " & _
                          gDB.sqlString(Registro.cuit) & _
                    "," & gDB.sqlString(Registro.fecha) & _
                    "," & gDB.sqlNumber(Registro.Saldo) & _
                    "," & gDB.sqlString(Registro.RazonSocial)

  If Not gDB.Execute(sqlstmt) Then
  
    pAddToLog LNGGetText(4917, vbNullString, s), False
              ' No se pudo insertar el registro & s
  End If
  
  pSave = True
End Function

Private Sub pSaveLog(ByVal msg As String)
  On Error Resume Next
  Dim F As Integer
  F = FreeFile
  Open m_logFile For Append As F
  Print #F, Now & " " & msg
  Close F
End Sub

Private Sub MsgWarning(ByVal msg As String)
  pAddToLog LNGGetText(2990, vbNullString, msg), True
            'Advertencia: & msg
  CSKernelClient2.MsgWarning msg
End Sub

Private Function pAsk(ByVal msg As String, ByVal default As VbMsgBoxStyle) As Boolean
  Dim rtn As VbMsgBoxResult
  rtn = MsgBox(Replace(msg, ";", vbCrLf), vbQuestion + vbYesNoCancel + vbDefaultButton2)
  pAsk = rtn = vbYes
  If rtn = vbCancel Then
    cIABMClient_PropertyChange K_CANCEL
  End If
End Function

Private Function pOpenFile(ByRef iFile As Long) As Boolean
  On Error GoTo ControlError
  
  Open m_file For Input As #iFile
  
  pOpenFile = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "pOpenFile", C_Module, vbNullString
  pAddToLog CSKernelClient2.LastErrorDescription, False
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pGetLines(ByVal iFile As Long) As Long
  Dim s As String
  Dim i As Long
  While Not EOF(iFile)
    Line Input #iFile, s
    i = i + 1
  Wend
  
  pGetLines = i
End Function

Private Sub pLoadRegistro(ByRef Registro As t_Registro, ByVal s As String)
  With Registro
    .fecha = Mid$(s, 1, 8)
    .cuit = Mid$(s, 9, 11)
    .Saldo = Mid$(s, 20, 13)
    .RazonSocial = Mid$(s, 33, 120)
    
    .dSaldo = VBA.Val(Replace(.Saldo, ",", "")) / 100
    
    .dFecha = DateSerial(VBA.Val(Mid$(.fecha, 5, 4)), _
                         VBA.Val(Mid$(.fecha, 3, 2)), _
                         VBA.Val(Mid$(.fecha, 1, 2)))
    
  End With
End Sub

Private Sub pInitFile(ByVal FileLog As String)
  On Error Resume Next
  Name FileLog As Mid$(FileLog, 1, Len(FileLog) - 4) & Format(Now, "yyy-mm-dd hh.nn.ss") & ".log"
  Kill FileLog
End Sub


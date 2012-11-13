VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cInformeConfig"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIABMClient
Implements CSMenu.cIMenuClient
'--------------------------------------------------------------------------------
' cInformeConfig
' 16-10-2003

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cInformeConfig"

Private Const c_RptPath = "path"
Private Const c_ConnectTimeOut = "ConnectTimeOut"
Private Const c_CommandTimeOut = "CommandTimeOut"
Private Const c_LogoChico = "LogoChico"
Private Const c_LogoGrande = "LogoGrande"
Private Const c_LogoChicoImg = "LogoChicoImg"
Private Const c_LogoGrandeImg = "LogoGrandeImg"

Private Const c_ImageFilter = "Archivos de imagenes|*.bmp;*.jpg;*.gif;*.ico"

Private Const K_RPT_PATH = 1
Private Const K_CONNECT_TIMEOUT = 2
Private Const K_COMMAND_TIMEOUT = 3
Private Const K_LOGO_CHICO = 4
Private Const K_LOGO_GRANDE = 5
Private Const K_LOGO_CHICO_IMG = 6
Private Const K_LOGO_GRANDE_IMG = 7
Private Const K_EMP_ID = 8
' estructuras
' variables privadas
Private m_Host              As CSMenu.cIMenuHost
Private m_ObjAbm            As cIABMGeneric
Private m_Editing           As Boolean
Private m_PictureChanged    As Boolean
Private m_LogoGrandeChange  As Boolean
Private m_LogoChicoChange  As Boolean
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

Private Function cIABMClient_PropertyChange(ByVal key As Integer) As Boolean
  On Error GoTo ControlError

  Dim bChangeImage As Boolean
  Dim Logo         As String
  Dim LogoImg      As String
  
  Select Case key
    Case K_LOGO_CHICO
      bChangeImage = True
      Logo = c_LogoChico
      LogoImg = c_LogoChicoImg
    Case K_LOGO_GRANDE
      bChangeImage = True
      Logo = c_LogoGrande
      LogoImg = c_LogoGrandeImg
      
    Case K_EMP_ID
      Dim iProp As cIABMProperty
      
      Set iProp = m_ObjAbm.Properties.Item(c_LogoChicoImg)
      Set iProp.Picture = pGetLogo(K_LOGO_CHICO)
      m_ObjAbm.ShowValue iProp
      Set iProp = m_ObjAbm.Properties.Item(c_LogoGrandeImg)
      Set iProp.Picture = pGetLogo(K_LOGO_GRANDE)
      m_ObjAbm.ShowValue iProp
  End Select
  
  If bChangeImage Then
      With m_ObjAbm.Properties(Logo)
        
        If LenB(.Value) Then
          If pLoadImage(.Value, fResource.picImage) Then
            If Logo = c_LogoGrande Then
              m_LogoGrandeChange = True
            Else
              m_LogoChicoChange = True
            End If
          End If
        Else
          Set m_ObjAbm.Properties(LogoImg).Picture = LoadPicture()
        End If
        
        Set m_ObjAbm.Properties(LogoImg).Picture = fResource.picImage.Picture
        
        m_ObjAbm.ShowValue m_ObjAbm.Properties(LogoImg)
      End With
  End If
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClient_PropertyChange", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
  Unload fResource
End Function

Private Function cIABMClient_Save() As Boolean
  Dim IProperty As cIABMProperty
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .key
        Case K_RPT_PATH
          IniSaveEx c_RPT_KEY, c_RPT_PathReportes, .Value
        Case K_LOGO_CHICO_IMG
          If m_LogoChicoChange Then
            If Not pSaveLogo("chico", c_LogoChicoNombre, c_LogoChicoCodigo, c_LogoChicoTableID, .Picture, K_LOGO_CHICO) Then Exit Function
            m_LogoChicoChange = False
          End If
        Case K_LOGO_GRANDE_IMG
          If m_LogoGrandeChange Then
            If Not pSaveLogo("grande", c_LogoGrandeNombre, c_LogoGrandeCodigo, c_LogoGrandeTableID, .Picture, K_LOGO_GRANDE) Then Exit Function
            m_LogoGrandeChange = False
          End If
        Case K_CONNECT_TIMEOUT
          IniSaveEx c_RPT_KEY, c_RPT_ConnectionTimeOut, .Value
        Case K_COMMAND_TIMEOUT
          IniSaveEx c_RPT_KEY, c_RPT_CommandTimeOut, .Value
      End Select
    End With
  Next
  
  cIABMClient_Save = True
End Function

Private Function cIABMClient_Terminate() As Boolean
  m_Editing = False
  cIABMClient_Terminate = True
End Function

Private Property Get cIABMClient_Title() As String
  cIABMClient_Title = LNGGetText(2730, vbNullString)  'Configuración de Informes
End Property

Private Function cIABMClient_Validate() As Boolean

  Dim IProperty As cIABMProperty

  CSKernelClient2.Title = LNGGetText(2730, vbNullString)  'Configuración de Informes

  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .key
        Case K_EMP_ID
          If .HelpId = csNO_ID Then
            MsgWarning LNGGetText(2731, vbNullString)  'Debe indicar una Empresa para asociar los logos
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
  Dim str_2732  As String
  
  str_2732 = LNGGetText(2732, vbNullString) 'Confi&guración
  Set m_Host = Host
                                                        'S&istema
  m_Host.Server.AddMenu str_2732, csMenuConfigInformes, LNGGetText(2703, vbNullString), 0, True, False, True, False, True, Me
  m_Host.Server.AddMenu LNGGetText(2733, vbNullString), csPreIModifyConfig, str_2732, 0, True, False, False, False, False, Me
                        'Configuración de In&formes
  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, "cIMenuClient_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal Id As Long) As Variant
  pEdit
End Function

Private Sub pEdit()
  On Error GoTo ControlError
  
  Set m_ObjAbm = New cABMGeneric
  
  If Not SecurityCanAccess(csPreIModifyConfig) Then Exit Sub

  If Not LoadCollection() Then Exit Sub
  
  m_Editing = True
  
  Exit Sub
ControlError:
  MngError Err, "pEdit", "cInformeConfig", vbNullString
End Sub

Private Function LoadCollection() As Boolean
  
  With m_ObjAbm.Tabs
  
    .Clear
  
    With .Add(Nothing)
      .Name = C_strGeneral
    End With
      
    With .Add(Nothing)
      .Index = 1
      .Name = LNGGetText(2734, vbNullString)  'Logos
    End With
  
  End With
  
  With m_ObjAbm.Properties
  
    .Clear
  
    With .Add(Nothing, c_RptPath)
      .PropertyType = cspFolder
      .Name = LNGGetText(2735, vbNullString)  'Carpeta de Reportes
      .Width = 6800
      .key = K_RPT_PATH
      .Value = IniGetEx(c_RPT_KEY, c_RPT_PathReportes, "")
    End With
      
    With .Add(Nothing, c_ConnectTimeOut)
      .PropertyType = cspNumeric
      .SubType = cspInteger
      .Name = LNGGetText(2736, vbNullString)  'Time Out Conexión
      .key = K_CONNECT_TIMEOUT
      .Value = Val(IniGetEx(c_RPT_KEY, c_RPT_ConnectionTimeOut, "0"))
      .Width = 800
    End With
      
    With .Add(Nothing, c_CommandTimeOut)
      .PropertyType = cspNumeric
      .SubType = cspInteger
      .Name = LNGGetText(2737, vbNullString)  'Time Out Comandos
      .key = K_COMMAND_TIMEOUT
      .Value = Val(IniGetEx(c_RPT_KEY, c_RPT_CommandTimeOut, "0"))
      .Width = 800
    End With
    
    With .Add(Nothing, cscEmpId)
      .PropertyType = cspHelp
      .Table = csEmpresa
      .Name = LNGGetText(1114, vbNullString)  'Empresa
      .key = K_EMP_ID
      .Value = EmpNombre
      .HelpId = EmpId
      .TabIndex = 1
    End With
    
    With .Add(Nothing, c_LogoChico)
      .PropertyType = cspFile
      .HelpFilter = c_ImageFilter
      .Name = LNGGetText(2738, vbNullString)  'Logo Chico
      .key = K_LOGO_CHICO
      .Value = vbNullString
      .Width = 5500
      .TabIndex = 1
    End With
      
    With .Add(Nothing, c_LogoChicoImg)
      .PropertyType = cspImage
      Set .Picture = pGetLogo(K_LOGO_CHICO)
      .Name = vbNullString
      .key = K_LOGO_CHICO_IMG
      .TabIndex = 1
    End With
      
    With .Add(Nothing, c_LogoGrande)
      .PropertyType = cspFile
      .HelpFilter = c_ImageFilter
      .Name = LNGGetText(2739, vbNullString)  'Logo Grande
      .key = K_LOGO_GRANDE
      .Top = 2500
      .Value = vbNullString
      .Width = 5500
      .TabIndex = 1
    End With
  
    With .Add(Nothing, c_LogoGrandeImg)
      .PropertyType = cspImage
      Set .Picture = pGetLogo(K_LOGO_GRANDE)
      .Name = vbNullString
      .key = K_LOGO_GRANDE_IMG
      .TabIndex = 1
    End With
  
  End With
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

Private Function pLoadImage(ByVal FullFileName As String, ByRef picImage As Object) As Boolean
  On Error GoTo ControlError
  
  Dim Image As cImage
  Set Image = New cImage
  
  pLoadImage = Image.LoadImageFromFile(FullFileName, picImage)

  GoTo ExitProc
ControlError:
  MngError Err, "pLoadImage", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pGetLogo(ByVal Logo As Long) As IPictureDisp
  Dim dd_id As Long
  dd_id = pGetIDLogo(Logo)
  If dd_id <> csNO_ID Then
    
    Dim FullFileName As String
    Dim Doc As cDocDigital
    
    Set Doc = New cDocDigital
    Doc.Id = dd_id
    If Doc.ExtractDoc(gDB, FullFileName) Then
      Set pGetLogo = LoadPicture(FullFileName)
    Else
      Set pGetLogo = LoadPicture()
    End If
  Else
    Set pGetLogo = LoadPicture()
  End If
End Function

Private Function pSaveLogo(ByVal LogoDescrip As String, ByVal LogoNombre As String, _
                           ByVal LogoCodigo As String, ByVal ClientTableID As Long, _
                           ByRef Picture As IPictureDisp, ByVal Logo As Long) As Boolean
  Dim Doc As cDocDigital
  Dim FullFileName As String
  Dim EmpId As Long
  
  EmpId = m_ObjAbm.Properties.Item(cscEmpId).HelpId
  
  Set Doc = New cDocDigital
  
  Dim FileEx As CSKernelFile.cFileEx
  Set FileEx = New CSKernelFile.cFileEx
  
  FullFileName = GetValidPath(Environ$("TEMP")) & "~cairoLogo"
  FileEx.FileDelete FullFileName
  SavePicture Picture, FullFileName
  Doc.Nombre = LogoNombre
  Doc.ClientTable = c_LogoTable
  Doc.ClientTableID = ClientTableID + EmpId * 1000
  Doc.fileName = FullFileName
  Doc.ClientDescrip = LNGGetText(2944, vbNullString, LogoDescrip)
                      'Logo " & LogoDescrip & " de la empresa que aparece en todos los reportes al pie de página
  Doc.Codigo = LogoCodigo & "_" & EmpId
  Doc.Id = pGetIDLogo(Logo)
  
  Doc.Path = FileEx.FileGetPath(FullFileName)
  Doc.fileName = FileEx.FileGetName(FullFileName)
  
  If Not Doc.Save(gDB) Then Exit Function
  If Not Doc.AddFile(gDB) Then Exit Function
  
  pSaveLogo = True
End Function

Private Function pGetIDLogo(ByVal Logo As Long) As Long
  Dim sqlstmt  As String
  Dim rs       As ADODB.Recordset
  Dim IdEmp    As Long
  
  IdEmp = m_ObjAbm.Properties.Item(cscEmpId).HelpId * 1000
  
  sqlstmt = "select dd_id from documentodigital where dd_clienttable = '" & c_LogoTable & _
            "' and dd_clientTableID = "
            
  If Logo = K_LOGO_CHICO Then
    sqlstmt = sqlstmt & c_LogoChicoTableID + IdEmp
  Else
    sqlstmt = sqlstmt & c_LogoGrandeTableID + IdEmp
  End If
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  If Not rs.EOF Then
    pGetIDLogo = ValField(rs.Fields, 0)
  End If
End Function
' funciones friend
' funciones privadas
' construccion - destruccion

Private Sub Class_Terminate()
  On Error GoTo ControlError

  Set m_ObjAbm = Nothing

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Terminate", C_Module, vbNullString
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

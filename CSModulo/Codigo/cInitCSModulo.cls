VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cInitCSModulo"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cInitCSModulo
' 29-04-02

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cInitCSModulo"
' estructuras
' variables privadas
Private m_InitObjs As Collection
' propiedades publicas
Public Property Let AppName(ByVal rhs As String)
  gAppName = rhs
End Property
' propiedades privadas
' funciones publicas
Public Function Init(ByRef db As cDataBase, ByRef F As Object, ByRef MenuHost As cIMenuHost) As Boolean
  Set gDB = db
  
  Init = InitModules(F, MenuHost)
End Function
Public Sub Terminate()
  CollClear m_InitObjs
End Sub
' funciones privadas

' Se conecta a la base y obtiene los Modulos instalados
' agrega los objetos a la bolsa de inicializacion
' Inicializa los Modulos instalados
Private Function InitModules(ByRef F As Object, ByRef MenuHost As cIMenuHost) As Boolean
  On Error GoTo ControlError

  Dim rs          As ADODB.Recordset
  Dim sqlstmt     As String
  Dim o           As Object
  Dim ObjName     As String
  Dim MenuClient  As cIMenuClient
  
  sqlstmt = "sp_SysModuloGet " & gDB.UserId
  
  If Not gDB.OpenRs(sqlstmt, rs, , , , "InitModules", C_Module) Then Exit Function
  
  Set m_InitObjs = New Collection
  
  ObjName = "CSGeneralEx2.cInitCSGeneralEx"
  Set o = CreateObject(ObjName)
  If Not o.Init(gDB) Then Exit Function
  m_InitObjs.Add o, ObjName
  
  ObjName = "CSInforme2.cInitCSInforme"
  Set o = CreateObject(ObjName)
  If Not o.Init(gDB) Then Exit Function
  m_InitObjs.Add o, ObjName
  
  ' Por ahora es asi, despues lo mejoramos
  ' Creo el menu de configuracion para que siempre este
  '
  MenuHost.Server.AddMenu "Co&nfiguración", -100, "", 1, False, False, False, True, False, Nothing
  
  Dim nIndex As Long
  Dim nCount As Long
  
  If Not (rs.EOF And rs.BOF) Then
    rs.MoveLast
    rs.MoveFirst
    nCount = rs.RecordCount
  End If
  
  While Not rs.EOF
  
    nIndex = nIndex + 1
    
    ' Cargo los objetos en la bolsa de inicialización
    ObjName = gDB.ValField(rs.Fields, "sysm_ObjetoInicializacion")
    
    pNotifyProgress F, "Init Object [" & ObjName & "] ...", nIndex, nCount
    
    If Not ExistsObjectInColl(m_InitObjs, ObjName) Then
      Set o = CreateObject(ObjName)
      If UCase(ObjName) <> "CSOAPI2.CINITCSOAPI" Then
        If Not o.Init(gDB) Then Exit Function
      End If
      m_InitObjs.Add o, ObjName
    End If
    
    ' Ahora voy por los objetos de edición
    ObjName = gDB.ValField(rs.Fields, "sysm_ObjetoEdicion")
    Set o = CreateObject(ObjName)
    Set MenuClient = o
    If Not MenuClient.Initialize(F, MenuHost) Then Exit Function
    
    pNotifyProgress F, "Init Object [" & ObjName & "] Success", nIndex, nCount
    
NextModule:

    rs.MoveNext
  Wend
  
  InitModules = True
  
  GoTo ExitProc
ControlError:

  If Err.Number = 13 Then
    MsgWarning "La DLL " & ObjName & " no es compatible con la interfaz MenuClient"
    Resume NextModule
  ElseIf Err.Number = 430 Then
    MsgWarning "La DLL " & ObjName & " o alguna de sus referencias no es compatible con la version compilada"
    Resume NextModule
  ElseIf Err.Number = 429 Then
    MsgWarning Err.Description
    Resume NextModule
  Else
    MngError Err, "InitModules", C_Module, ""
    If Err.Number <> 0 Then Resume ExitProc
  End If
ExitProc:
  On Error Resume Next
End Function

Private Sub pNotifyProgress(ByRef F As Object, ByVal msg As String, ByVal nIndex As Long, ByVal nCount As Long)
  On Error Resume Next
  F.ShowInitProgress msg, nIndex, nCount
End Sub

' construccion - destruccion
Private Sub Class_Terminate()
  On Error Resume Next
        
  Set m_InitObjs = Nothing
  Set gDB = Nothing
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



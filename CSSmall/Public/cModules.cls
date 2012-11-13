VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cModules"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' cModules
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
Private m_DB       As cDataBase
Private m_InitObjs As Collection
' propiedades publicas
' propiedades privadas
' funciones publicas
Public Function Init(ByRef db As cDataBase, ByRef vModules() As String) As Boolean
  Set m_DB = db
  
  Init = InitModules(vModules)
End Function
Public Sub Terminate()
  CollClear m_InitObjs
End Sub
' funciones privadas

' Se conecta a la base y obtiene los Modulos instalados
' agrega los objetos a la bolsa de inicializacion
' Inicializa los Modulos instalados
Private Function InitModules(ByRef vModules() As String) As Boolean
  On Error GoTo ControlError
  
  Dim i           As Long
  Dim o           As Object
  Dim ObjName     As String
  
  Set m_InitObjs = New Collection
  
  ObjName = "CSGeneralEx2.cInitCSGeneralEx"
  Set o = CSKernelClient2.CreateObject(ObjName)
  If Not o.Init(m_DB) Then Exit Function
  m_InitObjs.Add o, ObjName
  
  ObjName = "CSInforme2.cInitCSInforme"
  Set o = CSKernelClient2.CreateObject(ObjName)
  If Not o.Init(m_DB) Then Exit Function
  m_InitObjs.Add o, ObjName
  
  For i = 0 To UBound(vModules)
    
    ' Cargo los objetos en la bolsa de inicialización
    ObjName = vModules(i) 'm_DB.ValField(rs.Fields, "sysm_ObjetoInicializacion")
    If Not ExistsObjectInColl(m_InitObjs, ObjName) Then
      Set o = CSKernelClient2.CreateObject(ObjName)
      If UCase(ObjName) <> "CSOAPI2.cInitCSOAPI" Then
        If Not o.Init(m_DB) Then Exit Function
      End If
      m_InitObjs.Add o, ObjName
    End If
    
NextModule:
  
  Next
  
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
' construccion - destruccion
Private Sub Class_Terminate()
  On Error Resume Next
        
  Set m_InitObjs = Nothing
  Set m_DB = Nothing
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




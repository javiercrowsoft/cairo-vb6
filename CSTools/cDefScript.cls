VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cDefScript"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cToolsDeclaration
' 17-06-2002

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cDefScript"
' estructuras
' variables privadas
Private m_File                          As String
Private m_Descrip                       As String
Private m_ScrType                       As csScrType
Private m_FileValid                     As String
' eventos
' propiedadades publicas
Public Property Get File() As String
   File = m_File
End Property

Public Property Let File(ByVal rhs As String)
   m_File = rhs
End Property

Public Property Get Descrip() As String
   Descrip = m_Descrip
End Property

Public Property Let Descrip(ByVal rhs As String)
   m_Descrip = rhs
End Property

Public Property Get ScrType() As csScrType
   ScrType = m_ScrType
End Property

Public Property Let ScrType(ByVal rhs As csScrType)
   m_ScrType = rhs
End Property
' propiedadades friend
Friend Property Get FileValid() As String
  FileValid = m_FileValid
End Property
Friend Property Let FileValid(ByVal rhs As String)
  m_FileValid = rhs
End Property
' propiedades privadas
' funciones publicas
' funciones friend
' funciones privadas
' construccion - destruccion

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


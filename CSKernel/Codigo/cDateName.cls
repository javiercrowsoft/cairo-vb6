VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cDateName"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cDateName
' 11-05-2003

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cDateName"
' estructuras
' variables privadas
Private m_ID                            As csDateEnum
Private m_Name                          As String
Private m_Code                          As String
Private m_Group                         As String
' eventos
' propiedadades publicas
Public Property Get Id() As csDateEnum
   Id = m_ID
End Property

Public Property Let Id(ByVal rhs As csDateEnum)
   m_ID = rhs
End Property

Public Property Get Name() As String
   Name = m_Name
End Property

Public Property Let Name(ByVal rhs As String)
   m_Name = rhs
End Property

Public Property Get Code() As String
   Code = m_Code
End Property

Public Property Let Code(ByVal rhs As String)
   m_Code = rhs
End Property

Public Property Get Group() As String
   Group = m_Group
End Property

Public Property Let Group(ByVal rhs As String)
   m_Group = rhs
End Property
' propiedadades friend
' propiedades privadas
' funciones publicas
Public Function Value(Optional ByVal IniDate As Date) As Date
  Value = VDGetDateById_(m_ID, IniDate)
End Function
' funciones friend
' funciones privadas
' construccion - destruccion
'//////////////////////////////
'  Code estandar de errores
'  On Error GoTo ControlError
'
'  GoTo ExitProc
'ControlError:
'  MngError err,"", C_Module, ""
'  If Err.Number Then Resume ExitProc
'ExitProc:
'  On Error Resume Next



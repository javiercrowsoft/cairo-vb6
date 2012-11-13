VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cHelpResult"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cHelpResult
' 27-12-99

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
' estructuras
' variables privadas
Private m_Id        As String
Private m_Value     As String
Private m_Value2    As String
Private m_Cancel    As Boolean
' Properties publicas
Public Property Get Id() As String
    Id = m_Id
End Property
Public Property Get Value() As String
    Value = m_Value
End Property
Public Property Get Value2() As String
    Value2 = m_Value2
End Property
Public Property Get Cancel() As Boolean
Attribute Cancel.VB_Description = "Inicializa las variables."
    Cancel = m_Cancel
End Property
' Properties privadas
' funciones publicas

Friend Function Create(ByVal Id As String, ByVal Value As String, ByVal Value2 As String, ByVal Cancel As Boolean)
    m_Id = Id
    m_Value = Value
    m_Value2 = Value2
    m_Cancel = Cancel
End Function
' funciones privadas
' construccion - destruccion


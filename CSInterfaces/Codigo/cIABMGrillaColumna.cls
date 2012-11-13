VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cIABMGridColumn"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cABMGridColumn
' 01-02-01

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
' eventos
' Properties publicas
Public Property Let Name(ByRef rhs As String)
End Property
Public Property Get Name() As String
End Property
Public Property Let Key(ByVal rhs As Integer)
End Property
Public Property Get Key() As Integer
End Property
Public Property Let Visible(ByVal rhs As Boolean)
End Property
Public Property Get Visible() As Boolean
End Property

Public Property Get PropertyType() As csTypeABMProperty
End Property
Public Property Let PropertyType(ByVal rhs As csTypeABMProperty)
End Property
Public Property Get SubType() As csSubTypeABMProperty
End Property
Public Property Let SubType(ByVal rhs As csSubTypeABMProperty)
End Property
Public Property Get Table() As csTables
End Property
Public Property Let Table(ByVal rhs As csTables)
End Property
Public Property Let Size(ByVal rhs As Integer)
End Property
Public Property Get Size() As Integer
End Property
Public Property Let List(ByVal rhs As cIABMList)
End Property
Public Property Get List() As cIABMList
End Property
Public Property Let HelpFilter(ByVal rhs As String)
End Property
Public Property Get HelpFilter() As String
End Property

Public Property Let HelpSPFilter(ByVal rhs As String)
End Property
Public Property Get HelpSPFilter() As String
End Property

Public Property Let HelpSPInfoFilter(ByVal rhs As String)
End Property
Public Property Get HelpSPInfoFilter() As String
End Property

Public Property Get Enabled() As Boolean
End Property
Public Property Let Enabled(ByVal rhs As Boolean)
End Property
Public Property Get Width() As Integer
End Property
Public Property Let Width(ByVal rhs As Integer)
End Property
Public Property Get Format() As String
End Property
Public Property Let Format(ByVal rhs As String)
End Property
Public Property Get DefaultValue() As cIABMGridCellValue
End Property
Public Property Set DefaultValue(ByRef rhs As cIABMGridCellValue)
End Property
' Properties privadas
' funciones publicas
' funciones privadas
' construccion - destruccion


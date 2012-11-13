VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cWebReportParam"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
'--------------------------------------------------------------------------------
' cWebReportParam
' 23-04-2004

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "CSWebReport.cWebReportParam"
' estructuras
' variables privadas
Private m_Name                          As String
Private m_Caption                       As String
Private m_ValueType                     As String
Private m_DefaultValue                  As String
Private m_DefaultValueID                As String
Private m_AllowEdit                     As String
Private m_nOption                       As String
Private m_AllowAll                      As String
Private m_DataSourceFunction            As String
Private m_DataFillFunction              As String
Private m_Index                         As Long
Private m_Table                         As Long
' eventos
' propiedades publicas
Public Property Get Name() As String
   Name = m_Name
End Property

Public Property Let Name(ByVal rhs As String)
   m_Name = rhs
End Property

Public Property Get Caption() As String
   Caption = m_Caption
End Property

Public Property Let Caption(ByVal rhs As String)
   m_Caption = rhs
End Property

Public Property Get ValueType() As String
   ValueType = m_ValueType
End Property

Public Property Let ValueType(ByVal rhs As String)
   m_ValueType = rhs
End Property

Public Property Get DefaultValue() As String
   DefaultValue = m_DefaultValue
End Property

Public Property Let DefaultValue(ByVal rhs As String)
   m_DefaultValue = rhs
End Property

Public Property Get DefaultValueID() As String
   DefaultValueID = m_DefaultValueID
End Property

Public Property Let DefaultValueID(ByVal rhs As String)
   m_DefaultValueID = rhs
End Property

Public Property Get AllowEdit() As String
   AllowEdit = m_AllowEdit
End Property

Public Property Let AllowEdit(ByVal rhs As String)
   m_AllowEdit = rhs
End Property

Public Property Get nOption() As String
   nOption = m_nOption
End Property

Public Property Let nOption(ByVal rhs As String)
   m_nOption = rhs
End Property

Public Property Get AllowAll() As String
   AllowAll = m_AllowAll
End Property

Public Property Let AllowAll(ByVal rhs As String)
   m_AllowAll = rhs
End Property

Public Property Get DataSourceFunction() As String
   DataSourceFunction = m_DataSourceFunction
End Property

Public Property Let DataSourceFunction(ByVal rhs As String)
   m_DataSourceFunction = rhs
End Property

Public Property Get DataFillFunction() As String
   DataFillFunction = m_DataFillFunction
End Property

Public Property Let DataFillFunction(ByVal rhs As String)
   m_DataFillFunction = rhs
End Property

Public Property Get Table() As Long
   Table = m_Table
End Property

Public Property Let Table(ByVal rhs As Long)
   m_Table = rhs
End Property

Public Property Get Index() As Long
   Index = m_Index
End Property

Public Property Let Index(ByVal rhs As Long)
   m_Index = rhs
End Property
' propiedades friend
' propiedades privadas
' funciones publicas
' funciones friend
' funciones privadas
' construccion - destruccion

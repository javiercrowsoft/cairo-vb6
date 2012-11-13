VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cReportPaintObject"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
'--------------------------------------------------------------------------------
' cReportPaintObject
' 18-09-2001

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
' constantes
' estructuras
' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module As String = "cReportPaintObject"
' estructuras
' variables privadas
Private m_Aspect                        As cReportAspect
Private m_Key                           As String
Private m_Text                          As String
Private m_PaintType                     As cRptPaintObjType
Private m_Tag                           As String
Private m_RptType                       As csRptPaintRptType
Private m_RptKeySec                     As String
Private m_hImage                        As Long
Private m_IndexField                    As Long

Private m_IsSection                     As Boolean

' Solo para secciones
'
Private m_HeightSec                     As Single
Private m_HeightSecLine                 As Single
Private m_TextLine                      As String

' eventos
' propiedades publicas
Public Property Get hImage() As Long
   hImage = m_hImage
End Property

Public Property Let hImage(ByVal rhs As Long)
   m_hImage = rhs
End Property

Public Property Get Aspect() As cReportAspect
  Set Aspect = m_Aspect
End Property

Public Property Let Aspect(ByVal rhs As cReportAspect)
  Set m_Aspect = rhs
End Property

Public Property Get Key() As String
  Key = m_Key
End Property

Public Property Let Key(ByVal rhs As String)
  m_Key = rhs
End Property

Public Property Get Text() As String
  Text = m_Text
End Property

Public Property Let Text(ByVal rhs As String)
  m_Text = rhs
End Property

Public Property Get PaintType() As cRptPaintObjType
  PaintType = m_PaintType
End Property

Public Property Let PaintType(ByVal rhs As cRptPaintObjType)
  m_PaintType = rhs
End Property

Public Property Get RptType() As csRptPaintRptType
  RptType = m_RptType
End Property

Public Property Let RptType(ByVal rhs As csRptPaintRptType)
  m_RptType = rhs
End Property

Public Property Get Tag() As String
  Tag = m_Tag
End Property

Public Property Let Tag(ByVal rhs As String)
  m_Tag = rhs
End Property

Public Property Get RptKeySec() As String
   RptKeySec = m_RptKeySec
End Property

Public Property Let RptKeySec(ByVal rhs As String)
   m_RptKeySec = rhs
End Property

Public Property Get IndexField() As Long
   IndexField = m_IndexField
End Property

Public Property Let IndexField(ByVal rhs As Long)
   m_IndexField = rhs
End Property

'------------------------------------
' Solo para secciones
'
Public Property Get HeightSec() As Single
   HeightSec = m_HeightSec
End Property

Public Property Let HeightSec(ByVal rhs As Single)
   m_HeightSec = rhs
End Property

Public Property Get HeightSecLine() As Single
   HeightSecLine = m_HeightSecLine
End Property

Public Property Let HeightSecLine(ByVal rhs As Single)
   m_HeightSecLine = rhs
End Property

Public Property Get TextLine() As String
  TextLine = m_TextLine
End Property

Public Property Let TextLine(ByVal rhs As String)
  m_TextLine = rhs
End Property

Public Property Get IsSection() As Boolean
  IsSection = m_IsSection
End Property

Public Property Let IsSection(ByVal rhs As Boolean)
  m_IsSection = rhs
End Property

' propiedades privadas
' funciones publicas
' funciones privadas
' construccion - destruccion
Private Sub Class_Initialize()
  Set m_Aspect = New cReportAspect
End Sub

Private Sub Class_Terminate()
  Set m_Aspect = Nothing
End Sub


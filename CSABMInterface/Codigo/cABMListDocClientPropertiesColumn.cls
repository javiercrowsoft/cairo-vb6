VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cABMDocPropertiesCol"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cABMDocPropertiesCol
' 25-08-2002

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cABMDocPropertiesCol"
' estructuras
' variables privadas
Private m_Name                          As String
Private m_Caption                       As String
Private m_Icons                         As cColumnIcons
Private m_SortType                      As csSortType
Private m_SortOrder                     As csSortOrderType
Private m_EditType                      As csEditType
Private m_Width                         As Integer
Private m_Visible                       As Boolean
Private m_ObjGetIcon                    As Object
Private m_ForeColor                     As ColorConstants
Private m_FontName                      As String
Private m_FontSize                      As Integer
Private m_Font                          As Object
Private m_FontBold                      As Boolean
Private m_FontUnderline                 As Boolean
Private m_BackColor                     As ColorConstants

' eventos
' propiedades publicas
Public Property Get ObjGetIcon() As Object
   Set ObjGetIcon = m_ObjGetIcon
End Property

Public Property Set ObjGetIcon(ByRef RHS As Object)
   Set m_ObjGetIcon = RHS
End Property

Public Property Get Name() As String
   Name = m_Name
End Property

Public Property Let Name(ByVal RHS As String)
   m_Name = RHS
End Property

Public Property Get Caption() As String
   Caption = m_Caption
End Property

Public Property Let Caption(ByVal RHS As String)
   m_Caption = RHS
End Property

Public Property Get Icons() As cColumnIcons
   Set Icons = m_Icons
End Property

Public Property Set Icons(ByRef RHS As cColumnIcons)
   Set m_Icons = RHS
End Property

Public Property Get SortType() As csSortType
   SortType = m_SortType
End Property

Public Property Let SortType(ByVal RHS As csSortType)
   m_SortType = RHS
End Property

Public Property Get SortOrder() As csSortOrderType
   SortOrder = m_SortOrder
End Property

Public Property Let SortOrder(ByVal RHS As csSortOrderType)
   m_SortOrder = RHS
End Property

Public Property Get EditType() As csEditType
   EditType = m_EditType
End Property

Public Property Let EditType(ByVal RHS As csEditType)
   m_EditType = RHS
End Property

Public Property Get Width() As Integer
   Width = m_Width
End Property

Public Property Let Width(ByVal RHS As Integer)
   m_Width = RHS
End Property

Public Property Get Visible() As Boolean
   Visible = m_Visible
End Property

Public Property Let Visible(ByVal RHS As Boolean)
   m_Visible = RHS
End Property

Public Property Get ForeColor() As ColorConstants
   ForeColor = m_ForeColor
End Property

Public Property Let ForeColor(ByVal RHS As ColorConstants)
   m_ForeColor = RHS
End Property

Public Property Get BackColor() As ColorConstants
   BackColor = m_BackColor
End Property

Public Property Let BackColor(ByVal RHS As ColorConstants)
   m_BackColor = RHS
End Property

Public Property Get FontName() As String
   FontName = m_FontName
End Property

Public Property Let FontName(ByVal RHS As String)
   m_FontName = RHS
End Property

Public Property Get FontSize() As Integer
   FontSize = m_FontSize
End Property

Public Property Let FontSize(ByVal RHS As Integer)
   m_FontSize = RHS
End Property

Public Property Get Font() As Object
   Set Font = m_Font
End Property

Public Property Set Font(ByRef RHS As Object)
   Set m_Font = RHS
End Property

Public Property Get FontBold() As Boolean
   FontBold = m_FontBold
End Property

Public Property Let FontBold(ByVal RHS As Boolean)
   m_FontBold = RHS
End Property

Public Property Get FontUnderline() As Boolean
   FontUnderline = m_FontUnderline
End Property

Public Property Let FontUnderline(ByVal RHS As Boolean)
   m_FontUnderline = RHS
End Property

' propiedades friend
' propiedades privadas
' funciones publicas
' funciones friend
' funciones privadas
' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError

  Set m_Icons = New cColumnIcons
  m_Visible = True
  m_SortOrder = csSrtOrTAscending
  m_SortType = csSrtTStringNoCase
  m_ForeColor = vbWindowText
  m_BackColor = vbWindowBackground
  m_Width = -1
  
  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
  On Error GoTo ControlError

  Set m_Icons = Nothing
  Set m_ObjGetIcon = Nothing

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Terminate", C_Module, ""
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

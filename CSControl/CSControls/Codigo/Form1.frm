VERSION 5.00
Object = "{EB085854-3FFC-11D4-9DB2-A39AC4721A49}#8.0#0"; "csControls.ocx"
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   5625
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   7485
   Icon            =   "Form1.frx":0000
   LinkTopic       =   "Form1"
   MDIChild        =   -1  'True
   ScaleHeight     =   5625
   ScaleWidth      =   7485
   Begin VB.Timer TmrCompatCollObjEdit 
      Interval        =   60000
      Left            =   2520
      Top             =   4590
   End
   Begin csControls.csArbol csArbol1 
      Height          =   3030
      Left            =   960
      TabIndex        =   0
      Top             =   1080
      Width           =   4695
      _ExtentX        =   5106
      _ExtentY        =   5345
      ToolBarVisible  =   0   'False
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
'--------------------------------------------------------------------------------
' cWindow
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
Private m_Nombre
Private m_botones1  As Long
Private m_botones2  As Long
Private m_botones3  As Long
Private m_IconText  As Integer
Private m_Tabla     As csTablas

Private m_ObjEditNombre As String
Private m_ObjABMNombre  As String

Private m_CollObjEdit As Collection

' propiedades privadas
Private Property Get ObjEdit() As cIEditGenerico
    On Error GoTo ControlError
    
    Set ObjEdit = GetObjectEdit
    Exit Property
ControlError:
    MngError "ObjEdit", "fArbol", ""
End Property
Private Property Set ObjEdit(ByRef rhs As cIEditGenerico)
    Set m_ObjEdit = rhs
End Property

' propiedades publicas
Public Property Get ObjEditNombre() As String
    ObjEditNombre = m_ObjEditNombre
End Property
Public Property Let ObjEditNombre(ByVal rhs As String)
    ObjEditNombre = rhs
End Property

Public Property Get ObjABMNombre() As String
    ObjABMNombre = m_ObjABMNombre
End Property
Public Property Let ObjABMNombre(ByVal rhs As String)
    ObjABMNombre = rhs
End Property

Public Property Get Nombre() As String
    Nombre = m_Nombre
End Property
Public Property Let Nombre(ByVal rhs As String)
    m_Nombre = rhs
End Property
Public Property Get Botones1() As Long
    Botones1 = m_botones1
End Property
Public Property Let Botones1(ByVal rhs As Long)
    m_botones1 = rhs
End Property
Public Property Get Botones2() As Long
    Botones2 = m_botones2
End Property
Public Property Let Botones2(ByVal rhs As Long)
    m_botones2 = rhs
End Property
Public Property Get Botones3() As Long
    Botones3 = m_botones3
End Property
Public Property Let Botones3(ByVal rhs As Long)
    m_botones3 = rhs
End Property
Public Property Get IconPersona() As Integer
    IconPersona = csIMG_PERSONA
End Property
Public Property Get IconRoles() As Integer
    IconRoles = csIMG_ROLES
End Property
Public Property Get IconCubo() As Integer
    IconCubo = csIMG_CUBOROJO
End Property
Public Property Get IconText() As Integer
    IconText = m_IconText
End Property
Public Property Let IconText(ByVal rhs As Integer)
    m_IconText = rhs
End Property
Public Property Let Tabla(ByVal rhs As csTablas)
    m_Tabla = rhs
End Property
' propiedades privadas
' funciones publicas
Public Function Init() As Boolean
    Caption = m_Nombre
    csArbol1.Nombre = m_Nombre
    csArbol1.Botones1 = m_botones1
    csArbol1.Botones2 = m_botones2
    csArbol1.Botones3 = m_botones3
    csArbol1.SetToolBar
    csArbol1.IconText = m_IconText
    Init = csArbol1.Load(m_Tabla)
    Set m_CollObjEdit = New Collection
End Function

' funciones privadas
Private Function GetObjectEdit() As cIEditGenerico
    Dim o As cIEditGenerico
    Dim YaEncontreUno As Boolean
    Dim i As Integer
    
    i = 1
    For Each o In m_CollObjEdit
        If Not o.Editando Then
            If YaEncontreUno Then
                m_CollObjEdit.Remove i
            Else
                YaEncontreUno = True
                i = i + 1
                Set GetObjectEdit = o
            End If
        Else
            i = i + 1
        End If
    Next
    
    If Not YaEncontreUno Then
        Dim Editor As cIABMGenerico
        Set o = CreateObject(m_ObjEditNombre)
        Set Editor = CreateObject(m_ObjABMNombre)
        Set o.ObjAbm = Editor
        Set GetObjectEdit = o
        m_CollObjEdit.Add o
    End If
End Function

Private Function CompactCollObjectEdit() As Boolean
    On Error GoTo ControlError
    
    Dim o As cIEditGenerico
    Dim i As Integer
    
    i = 1
    For Each o In m_CollObjEdit
        If Not o.Editando Then
           m_CollObjEdit.Remove i
        Else
            i = i + 1
        End If
    Next
    
    CompactCollObjectEdit = True
    
    Exit Function
ControlError:
    MngError "CompactCollObjectEdit", "fArbol", ""
End Function

Private Sub csArbol1_ToolBarClick(ByVal Button As Object)
    MsgBox Button.Key

    Select Case Button.Key
        Case "SALIR"
            Unload Me
        Case "EDITAR"
            m_ObjEdit.Editar csArbol1.ID
    End Select
End Sub

Private Sub TmrCompatCollObjEdit_Timer()
    CompactCollObjectEdit
End Sub

Private Sub Form_Resize()
    csArbol1.Move 0, 0, ScaleWidth, ScaleHeight
End Sub
' construccion - destruccion
Private Sub Form_Unload(Cancel As Integer)
    Set m_ObjEdit = Nothing
    Set m_CollObjEdit = Nothing
    csArbol1.SavePreference WindowState
    CSKernelClient.UnloadForm Me, m_Nombre
End Sub


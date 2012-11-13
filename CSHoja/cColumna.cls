VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cColumna"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Attribute VB_Ext_KEY = "SavedWithClassBuilder6" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"No"
Option Explicit

' Propiedades privadas
Private m_Font        As String
Private m_FontSize    As Single
Private m_Tipo        As cRepoColumnaTipo
Private m_Texto       As String
Private m_Imagen      As Integer
Private m_Ancho       As Integer
Private m_Alto        As Integer
Private m_Negrita     As Boolean
Private m_SubRayado   As Boolean
Private m_Ident       As String
Private m_Color       As Long
Private m_IndiceGrupo As Integer  ' Este indice sirve para unir columnas
                                  ' Todos las columnas que estan continuas en
                                  ' la coleccion y tienen m_IndiceGrupo <> de cero
                                  ' e igual entre si, son columnas que deben imprimirce
                                  ' juntas. Por lo tanto al calcular si hay suficiente espacio
                                  ' la rutina toma en cuenta el alto resultante de la suma
                                  ' de los anchos de las columnas.

Public Property Let Imagen(ByVal rhs As Integer)
  m_Imagen = rhs
End Property

Public Property Get Imagen() As Integer
  Imagen = m_Imagen
End Property

Public Property Let Texto(ByVal rhs As String)
  m_Texto = rhs
End Property

Public Property Get Texto() As String
  Texto = m_Texto
End Property

Public Property Let Ident(ByVal rhs As String)
  m_Ident = rhs
End Property

Public Property Get Ident() As String
  Ident = m_Ident
End Property

Public Property Let Tipo(ByVal rhs As cRepoColumnaTipo)
  m_Tipo = rhs
End Property

Public Property Get Tipo() As cRepoColumnaTipo
  Tipo = m_Tipo
End Property

Public Property Let Font(ByVal rhs As String)
  m_Font = rhs
End Property

Public Property Get Font() As String
  Font = m_Font
End Property

Public Property Let FontSize(ByVal rhs As String)
  m_FontSize = rhs
End Property

Public Property Get FontSize() As String
  FontSize = m_FontSize
End Property

Public Property Let Ancho(ByVal rhs As Integer)
  m_Ancho = rhs
End Property

Public Property Get Ancho() As Integer
  If m_Ancho = 0 Then
    If m_Tipo = cRepoTexto Then
      F_FontSize.Font = m_Font
      F_FontSize.FontSize = m_FontSize
      F_FontSize.FontBold = m_Negrita
      Ancho = Fix(F_FontSize.TextWidth(m_Texto)) + 10
    End If
  Else
    Ancho = m_Ancho
  End If
End Property

Public Property Let Alto(ByVal rhs As Integer)
  m_Alto = rhs
End Property

Public Property Get Alto() As Integer
  If m_Alto = 0 Then
    If m_Tipo = cRepoTexto Then
      F_FontSize.Font = m_Font
      F_FontSize.FontSize = m_FontSize
      F_FontSize.FontBold = m_Negrita
      Alto = Fix(F_FontSize.TextHeight(m_Texto)) + 10
    End If
  Else
    Alto = m_Alto
  End If
End Property

Public Property Let Negrita(ByVal rhs As Boolean)
  m_Negrita = rhs
End Property

Public Property Get Negrita() As Boolean
  Negrita = m_Negrita
End Property

Public Property Let SubRayado(ByVal rhs As Boolean)
  m_SubRayado = rhs
End Property

Public Property Get SubRayado() As Boolean
  SubRayado = m_SubRayado
End Property

Public Property Let Color(ByVal rhs As Long)
  m_Color = rhs
End Property

Public Property Get Color() As Long
  Color = m_Color
End Property

Private Sub Class_Initialize()
  m_Font = "Arial"
  m_FontSize = 10
End Sub

Public Property Get IndiceGrupo() As Integer
  IndiceGrupo = m_IndiceGrupo
End Property

Public Property Let IndiceGrupo(rhs As Integer)
  m_IndiceGrupo = rhs
End Property

VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cRenglon"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Attribute VB_Ext_KEY = "SavedWithClassBuilder6" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"No"
Attribute VB_Ext_KEY = "Member0" ,"cColumnas"
Option Explicit

Private m_Columnas          As cColumnas
Private m_Left              As Integer
Private m_IndiceGrupo       As Integer  ' Este indice sirve para unir renglones
                                        ' Todos los renglones que estan continuos en
                                        ' la coleccion y tienen m_IndiceGrupo <> de cero
                                        ' e igual entre si, son renglones que deben imprimirce
                                        ' juntos. Por lo tanto al calcular si hay suficiente espacio
                                        ' la rutina toma en cuenta el alto resultante de la suma
                                        ' de los altos de los renglones.

Public Property Get Columnas() As cColumnas
  Set Columnas = m_Columnas
End Property

Public Property Set Columnas(rhs As cColumnas)
  Set m_Columnas = rhs
End Property

Public Property Get Left() As Integer
  Left = m_Left
End Property

Public Property Let Left(rhs As Integer)
  m_Left = rhs
End Property

Public Property Get IndiceGrupo() As Integer
  IndiceGrupo = m_IndiceGrupo
End Property

Public Property Let IndiceGrupo(rhs As Integer)
  m_IndiceGrupo = rhs
End Property

Private Sub Class_Initialize()
  Set m_Columnas = New cColumnas
End Sub

Private Sub Class_Terminate()
  Set m_Columnas = Nothing
End Sub


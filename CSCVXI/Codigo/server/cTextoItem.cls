VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cTextoItem"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Private m_codigo                        As String
Private m_codigoMacro                   As String
Private m_delimitador                   As String
Private m_id                            As Long
Private m_id_padre                      As Long
Private m_nombre                        As String
Private m_texto                         As String
Private m_tieneValor                    As Boolean
Private m_valor                         As String
Private m_valorHtml                     As String
Private m_esBooleano                    As Boolean

Public Property Get id() As Long
   id = m_id
End Property

Public Property Let id(ByVal rhs As Long)
   m_id = rhs
End Property

Public Property Get codigo() As String
   codigo = m_codigo
End Property

Public Property Let codigo(ByVal rhs As String)
   m_codigo = rhs
End Property

Public Property Get codigoMacro() As String
   codigoMacro = m_codigoMacro
End Property

Public Property Let codigoMacro(ByVal rhs As String)
   m_codigoMacro = rhs
End Property

Public Property Get valorHtml() As String
   valorHtml = m_valorHtml
End Property

Public Property Let valorHtml(ByVal rhs As String)
   m_valorHtml = rhs
End Property

Public Property Get valor() As String
   valor = m_valor
End Property

Public Property Let valor(ByVal rhs As String)
   m_valor = rhs
End Property

Public Property Get delimitador() As String
   delimitador = m_delimitador
End Property

Public Property Let delimitador(ByVal rhs As String)
   m_delimitador = rhs
End Property

Public Property Get id_padre() As Long
   id_padre = m_id_padre
End Property

Public Property Let id_padre(ByVal rhs As Long)
   m_id_padre = rhs
End Property

Public Property Get nombre() As String
   nombre = m_nombre
End Property

Public Property Let nombre(ByVal rhs As String)
   m_nombre = rhs
End Property

Public Property Get texto() As String
   texto = m_texto
End Property

Public Property Let texto(ByVal rhs As String)
   m_texto = rhs
End Property

Public Property Get tieneValor() As Boolean
   tieneValor = m_tieneValor
End Property

Public Property Let tieneValor(ByVal rhs As Boolean)
   m_tieneValor = rhs
End Property

Public Property Get esBooleano() As Boolean
  esBooleano = m_esBooleano
End Property

Public Property Let esBooleano(ByVal rhs As Boolean)
  m_esBooleano = True
End Property


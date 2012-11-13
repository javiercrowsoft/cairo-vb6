VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cKit"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cKit
' 15-08-2006

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cKit"
' estructuras
' variables privadas
Private m_prsk_id           As Long
Private m_pr_id             As Long

Private m_prns_id           As Long
Private m_prns_codigo       As String

Private m_stl_id            As Long
Private m_stl_codigo        As String

Private m_Nombre            As String

Private m_Series            As cKitSeries   ' (pueden ser de cantidad variable)

Private m_Lotes             As cKitLotes    ' Items con lotes que no
                                            ' llevan numero de serie
                                            ' (pueden ser de cantidad variable)

Private m_Items             As cKitItems    ' Items con alternativas que no
                                            ' llevan numero de serie ni lote
                                            ' (pueden ser de cantidad variable)
                                            
Private m_Vars              As cKitVars     ' Items con cantidad variable que no
                                            ' llevan numero de serie ni lote

Private m_cantidad          As Long     ' Es la cantidad del item en el
                                        ' parte de produccion

Private m_prfk_id           As Long     ' Es la formula que uso para cargar
                                        ' la definicion del Kit

Private m_ta_id_serie         As Long
Private m_ta_id_Lote          As Long
Private m_pr_id_serie         As Long
Private m_pr_id_lote          As Long
Private m_bIdentidad          As Boolean
Private m_bIdentidadXItem     As Boolean
Private m_bLote               As Boolean
Private m_bLoteXItem          As Boolean

Private m_bTalEditSerie         As Boolean
Private m_bTalEditLote          As Boolean

' eventos
' propiedades publicas
Public Property Get prns_id() As Long
  prns_id = m_prns_id
End Property
Public Property Let prns_id(ByVal rhs As Long)
  m_prns_id = rhs
End Property

Public Property Get prns_codigo() As String
  prns_codigo = m_prns_codigo
End Property
Public Property Let prns_codigo(ByVal rhs As String)
  m_prns_codigo = rhs
End Property

Public Property Get stl_codigo() As String
  stl_codigo = m_stl_codigo
End Property
Public Property Let stl_codigo(ByVal rhs As String)
  m_stl_codigo = rhs
End Property

Public Property Get stl_id() As Long
  stl_id = m_stl_id
End Property
Public Property Let stl_id(ByVal rhs As Long)
  m_stl_id = rhs
End Property

Public Property Get prsk_id() As Long
  prsk_id = m_prsk_id
End Property
Public Property Let prsk_id(ByVal rhs As Long)
  m_prsk_id = rhs
End Property

Public Property Get pr_id() As Long
  pr_id = m_pr_id
End Property
Public Property Let pr_id(ByVal rhs As Long)
  m_pr_id = rhs
End Property

Public Property Get Nombre() As String
  Nombre = m_Nombre
End Property
Public Property Let Nombre(ByVal rhs As String)
  m_Nombre = rhs
End Property

Public Property Get Series() As cKitSeries
  Set Series = m_Series
End Property

Public Property Get Lotes() As cKitLotes
  Set Lotes = m_Lotes
End Property

Public Property Get Alts() As cKitItems
  Set Alts = m_Items
End Property

Public Property Get Vars() As cKitVars
  Set Vars = m_Vars
End Property

Public Property Get Cantidad() As Long
  Cantidad = m_cantidad
End Property
Public Property Let Cantidad(ByVal rhs As Long)
  m_cantidad = rhs
End Property

Public Property Get prfk_id() As Long
  prfk_id = m_prfk_id
End Property
Public Property Let prfk_id(ByVal rhs As Long)
  m_prfk_id = rhs
End Property

Public Property Get ta_id_lote() As Long
  ta_id_lote = m_ta_id_Lote
End Property
Public Property Let ta_id_lote(ByVal rhs As Long)
  m_ta_id_Lote = rhs
End Property

Public Property Get ta_id_serie() As Long
  ta_id_serie = m_ta_id_serie
End Property
Public Property Let ta_id_serie(ByVal rhs As Long)
  m_ta_id_serie = rhs
End Property

Public Property Get pr_id_lote() As Long
  pr_id_lote = m_pr_id_lote
End Property
Public Property Let pr_id_lote(ByVal rhs As Long)
  m_pr_id_lote = rhs
End Property

Public Property Get pr_id_serie() As Long
  pr_id_serie = m_pr_id_serie
End Property
Public Property Let pr_id_serie(ByVal rhs As Long)
  m_pr_id_serie = rhs
End Property

Public Property Get bIdentidad() As Boolean
  bIdentidad = m_bIdentidad
End Property
Public Property Let bIdentidad(ByVal rhs As Boolean)
  m_bIdentidad = rhs
End Property

Public Property Get bIdentidadXItem() As Boolean
  bIdentidadXItem = m_bIdentidadXItem
End Property
Public Property Let bIdentidadXItem(ByVal rhs As Boolean)
  m_bIdentidadXItem = rhs
End Property

Public Property Get bLote() As Boolean
  bLote = m_bLote
End Property
Public Property Let bLote(ByVal rhs As Boolean)
  m_bLote = rhs
End Property

Public Property Get bLoteXItem() As Boolean
  bLoteXItem = m_bLoteXItem
End Property
Public Property Let bLoteXItem(ByVal rhs As Boolean)
  m_bLoteXItem = rhs
End Property

Public Property Get bTalEditSerie() As Boolean
  bTalEditSerie = m_bTalEditSerie
End Property
Public Property Let bTalEditSerie(ByVal rhs As Boolean)
  m_bTalEditSerie = rhs
End Property

Public Property Get bTalEditLote() As Boolean
  bTalEditLote = m_bTalEditLote
End Property
Public Property Let bTalEditLote(ByVal rhs As Boolean)
  m_bTalEditLote = rhs
End Property

' propiedades friend
' propiedades privadas
' funciones publicas
' funciones friend
' funciones privadas
' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError

  Set m_Series = New cKitSeries
  Set m_Lotes = New cKitLotes
  Set m_Items = New cKitItems
  Set m_Vars = New cKitVars

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
  On Error GoTo ControlError

  Set m_Series = Nothing
  Set m_Lotes = Nothing
  Set m_Items = Nothing
  Set m_Vars = Nothing

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Terminate", C_Module, vbNullString
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

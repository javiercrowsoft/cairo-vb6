VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cStockConfig"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cStockConfig
' 16-10-2003

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cStockConfig"

Private Const K_NO_CONTROLA_STOCK = 1
Private Const K_STOCK_X_LOGICO = 2
Private Const K_STOCK_X_FISICO = 3
Private Const K_PERMITE_STOCK_NEGATIVO = 4
Private Const K_SP_STOCK = 5
Private Const K_STOCK_PEDIDO_VTA = 6

Public Enum csE_ControlStock
  csENoControlaStock = 2
  csEStockLogico = 3
  csEStockFisico = 4
  csEStockNegativo = 5
End Enum

Public Enum csE_StockCodigoBarraTipo
  csESCB_Fijo
  csESCB_Caracter
End Enum

' estructuras
' variables privadas
Private m_NoControlaStock           As Boolean
Private m_StockXLogico              As Boolean
Private m_StockXFisico              As Boolean
Private m_PermiteStockNegativo      As Boolean
Private m_SPStock                   As String
Private m_StockPedidoVta            As Boolean

Private m_StockCodigoBarraSubir     As String
Private m_StockCodigoBarraBajar     As String
Private m_StockCodigoBarraTipo      As Long
Private m_StockCodigoBarraLongitud  As Long
Private m_StockCodigoBarraCaracter  As String

' eventos
' propiedades publicas
Public Property Get NoControlaStock() As Boolean
  NoControlaStock = m_NoControlaStock
End Property

Public Property Get StockXLogico() As Boolean
  StockXLogico = m_StockXLogico
End Property

Public Property Get StockXFisico() As Boolean
  StockXFisico = m_StockXFisico
End Property

Public Property Get StockPedidoVta() As Boolean
  StockPedidoVta = m_StockPedidoVta
End Property

Public Property Get StockCodigoBarraSubir() As String
   StockCodigoBarraSubir = m_StockCodigoBarraSubir
End Property

Public Property Get StockCodigoBarraBajar() As String
   StockCodigoBarraBajar = m_StockCodigoBarraBajar
End Property

Public Property Get StockCodigoBarraTipo() As Long
   StockCodigoBarraTipo = m_StockCodigoBarraTipo
End Property

Public Property Get StockCodigoBarraLongitud() As csE_StockCodigoBarraTipo
   StockCodigoBarraLongitud = m_StockCodigoBarraLongitud
End Property

Public Property Get StockCodigoBarraCaracter() As String
   StockCodigoBarraCaracter = m_StockCodigoBarraCaracter
End Property

' propiedades friend
' propiedades privadas
' funciones publicas
Public Function Load() As Boolean
  Dim sqlstmt As String

  sqlstmt = "select * from configuracion where cfg_grupo = " & gDB.sqlString(c_GrupoGeneral)

  Dim rs As Recordset

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  m_StockXLogico = False
  m_NoControlaStock = False
  m_StockXFisico = False
  m_PermiteStockNegativo = False
  m_SPStock = vbNullString
  m_StockPedidoVta = False
  
  m_StockCodigoBarraSubir = "**SUBIRRENGLON"
  m_StockCodigoBarraBajar = "**BAJARRENGLON"
  m_StockCodigoBarraTipo = csE_StockCodigoBarraTipo.csESCB_Fijo
  m_StockCodigoBarraLongitud = 5
  m_StockCodigoBarraCaracter = vbNullString
  
  While Not rs.EOF
    Select Case gDB.ValField(rs.Fields, cscCfgAspecto)
      Case c_TipoControlStock
        Select Case Val(gDB.ValField(rs.Fields, cscCfgValor))
          Case csE_ControlStock.csENoControlaStock
            m_NoControlaStock = True
          Case csE_ControlStock.csEStockFisico
            m_StockXFisico = True
          Case csE_ControlStock.csEStockLogico
            m_StockXLogico = True
          Case csE_ControlStock.csEStockNegativo
            m_PermiteStockNegativo = True
        End Select
      Case c_SpStock
        m_SPStock = gDB.ValField(rs.Fields, cscCfgValor)
      Case c_StockPedidoVta
        m_StockPedidoVta = Val(gDB.ValField(rs.Fields, cscCfgValor))
    
      Case c_StockCodBarraSubir
        m_StockCodigoBarraSubir = gDB.ValField(rs.Fields, cscCfgValor)
      
      Case c_StockCodBarraBajar
        m_StockCodigoBarraBajar = gDB.ValField(rs.Fields, cscCfgValor)
      
      Case c_StockCodBarraTipo
        m_StockCodigoBarraTipo = Val(gDB.ValField(rs.Fields, cscCfgValor))
      
      Case c_StockCodBarraLongitud
        m_StockCodigoBarraLongitud = Val(gDB.ValField(rs.Fields, cscCfgValor))
      
      Case c_StockCodBarraCaracter
        m_StockCodigoBarraCaracter = gDB.ValField(rs.Fields, cscCfgValor)
    End Select
    rs.MoveNext
  Wend

  Load = True
End Function

' funciones friend
' funciones privadas
' construccion - destruccion

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

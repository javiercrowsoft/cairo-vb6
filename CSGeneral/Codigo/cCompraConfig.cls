VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cCompraConfig"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cCompraConfig
' 09-04-2004

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cCompraConfig"

Private Const c_GrupoGeneral = "Compras-General"
Private Const c_CueIdDescGlobal = "Cuenta Descuento Global"
Private Const c_GrabarAsiento = "Grabar Asiento"
Private Const c_ExigirCentroCosto = "Exigir Centro Costo"

' estructuras
' variables privadas
Private m_cue_id_descGlobal           As Long
Private m_CuentaDescGlobal            As String
Private m_GrabarAsiento               As Boolean
Private m_ExigirCentroCosto           As Boolean

' eventos
' propiedades publicas
Public Property Get CueIdDescGlobal() As Long
  CueIdDescGlobal = m_cue_id_descGlobal
End Property

Public Property Get CuentaDescGlobal() As Long
  CuentaDescGlobal = m_CuentaDescGlobal
End Property

Public Property Get GrabarAsiento() As Long
  GrabarAsiento = m_GrabarAsiento
End Property

Public Property Get ExigirCentroCosto() As Boolean
  ExigirCentroCosto = m_ExigirCentroCosto
End Property
' propiedades friend
' propiedades privadas
' funciones publicas
Public Function Load() As Boolean
  Dim sqlstmt As String

  sqlstmt = "select * from configuracion where cfg_grupo = " & gDB.sqlString(c_GrupoGeneral)

  Dim rs As Recordset

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  m_cue_id_descGlobal = csNO_ID
  m_CuentaDescGlobal = vbNullString
  m_GrabarAsiento = False
  m_ExigirCentroCosto = False
  
  While Not rs.EOF
    Select Case gDB.ValField(rs.fields, cscCfgAspecto)
      Case c_CueIdDescGlobal
        m_cue_id_descGlobal = Val(gDB.ValField(rs.fields, cscCfgValor))
        If Not gDB.GetData(csTCuenta, cscCueId, m_cue_id_descGlobal, cscCueNombre, m_CuentaDescGlobal) Then Exit Function
      Case c_GrabarAsiento
        m_GrabarAsiento = Val(gDB.ValField(rs.fields, cscCfgValor))
      Case c_ExigirCentroCosto
        m_ExigirCentroCosto = Val(gDB.ValField(rs.fields, cscCfgValor))
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

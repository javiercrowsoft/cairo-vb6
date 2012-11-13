VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cContabilidadConfig"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cContabilidadConfig
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
Private Const C_Module = "cContabilidadConfig"

Private Const c_GrupoGeneral = "Contabilidad-General"
Private Const c_ClaveFiscal = "Clave Fiscal"
' estructuras
' variables privadas
Private m_ClaveFiscal       As Long
' eventos
' propiedades publicas
Public Property Get ClaveFiscal() As csClaveFiscalType
  ClaveFiscal = m_ClaveFiscal
End Property

' propiedades friend
' propiedades privadas
' funciones publicas
Public Function Load() As Boolean
  Dim sqlstmt As String

  sqlstmt = "select * from configuracion where cfg_grupo = " & gDB.sqlString(c_GrupoGeneral)

  Dim rs As Recordset

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  m_ClaveFiscal = csEClaveFiscalCuit
  
  While Not rs.EOF
    Select Case gDB.ValField(rs.Fields, cscCfgAspecto)
      Case c_ClaveFiscal
        m_ClaveFiscal = Val(gDB.ValField(rs.Fields, cscCfgValor))
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

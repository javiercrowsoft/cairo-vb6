VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cRemitoCompraPrint"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cRemitoCompraPrint
' 23-11-2006

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cRemitoCompraPrint"

' estructuras
' variables privadas
Private m_rc_id                        As Long
Private m_rcNroDoc                     As String

'OJO HASTA ACA

Private m_rptName           As String
Private m_rptFile           As String
Private m_Action            As csRptLaunchAction
Private m_Copies            As Long
Private m_Path              As String

Private m_ConnectionTimeout             As Long
Private m_CommandTimeout                As Long

' eventos
' Properties publicas
' propiedades friend
' propiedades privadas
' funciones publicas
Public Function DoPrint(ByVal rptName As String, _
                        ByVal rptFile As String, _
                        ByVal Action As csRptLaunchAction, _
                        ByVal Copies As Long, _
                        ByVal strId As String, _
                        ByVal Path As String, _
                        ByVal CommandTimeout As Long, _
                        ByVal ConnectionTimeout As Long) As Boolean
                        
  Dim id As Long
  
  id = Val(strId)
  m_rptName = rptName
  m_rptFile = rptFile
  m_Action = Action
  m_Copies = Copies
  m_Path = Path
  m_ConnectionTimeout = ConnectionTimeout
  m_CommandTimeout = CommandTimeout
  
  If m_Action <> csRptLaunchPrinter Then
    MsgWarning LNGGetText(3462, vbNullString)
                'Los códigos de barra no permiten vista previa
    Exit Function
  End If
  
  Dim printer_name As String
  Dim numbers      As String
  
  If Not pGetPrinter(printer_name, numbers) Then Exit Function
  
  Dim rs      As Recordset
  
  If Not pGetNumeros(id, rs) Then Exit Function
  
  rptFile = GetValidPath(Path) & rptFile
  
  DoPrint = mBarcode.DoPrint(rptFile, Copies, printer_name, rs, numbers)
End Function

' funciones friend
' Implementacion de cIEditGeneric
' funciones privadas
Private Function pGetPrinter(ByRef printer_name As String, _
                             ByRef numbers As String) As Boolean

  Dim fPrinters As fPrinters
  
  Set fPrinters = New fPrinters
  
  fPrinters.Show vbModal
  printer_name = fPrinters.PrinterName
  numbers = fPrinters.numbers
  pGetPrinter = fPrinters.Ok

  On Error Resume Next
  Unload fPrinters
End Function

Private Function pGetNumeros(ByVal RcId As Long, _
                             ByRef rc As Recordset) As Boolean

  Dim sqlstmt As String

  sqlstmt = "sp_DocRemitoCompraGetPrns " & RcId

  If Not gDB.OpenRs(sqlstmt, rc) Then Exit Function

  pGetNumeros = True
End Function

' construccion - destruccion

'//////////////////////////////
'  Codigo estandar de errores
'  On Error GoTo ControlError
'
'  GoTo ExitProc
'ControlError:
'  MngError err,"", C_Module, ""
'  If Err.Number <> 0 Then Resume ExitProc
'ExitProc:
'  On Error Resume Next





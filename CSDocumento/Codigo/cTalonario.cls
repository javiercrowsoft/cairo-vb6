VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cTalonario"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cTalonario
' 00-06-03

'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cTalonario"

' estructuras
' Seudo - Variables
Private c_ErrorSave                    As String

' variables privadas
Private m_Id                           As Long
Private m_Nombre                       As String
Private m_Codigo                       As String
Private m_Descrip                      As String
Private m_Ultimonro                    As Long
Private m_Tipo                         As Integer
Private m_Mascara                      As String
Private m_Creado                       As Date
Private m_Modificado                   As Date
Private m_Modifico                     As Long
Private m_Activo                       As Boolean
Private m_Cai                          As String
Private m_emp_id                       As Long
Private m_Empresa                      As String

' Properties publicas
Public Property Get id() As Long
  id = m_Id
End Property

Public Property Let id(ByVal rhs As Long)
  m_Id = rhs
End Property

Public Property Get Nombre() As String
  Nombre = m_Nombre
End Property

Public Property Let Nombre(ByVal rhs As String)
  m_Nombre = rhs
End Property

Public Property Get Codigo() As String
  Codigo = m_Codigo
End Property

Public Property Let Codigo(ByVal rhs As String)
  m_Codigo = rhs
End Property

Public Property Get Descrip() As String
  Descrip = m_Descrip
End Property

Public Property Let Descrip(ByVal rhs As String)
  m_Descrip = rhs
End Property

Public Property Get UltimoNro() As Long
  UltimoNro = m_Ultimonro
End Property

Public Property Let UltimoNro(ByVal rhs As Long)
  m_Ultimonro = rhs
End Property

Public Property Get Tipo() As Integer
  Tipo = m_Tipo
End Property

Public Property Let Tipo(ByVal rhs As Integer)
  m_Tipo = rhs
End Property

Public Property Get Mascara() As String
  Mascara = m_Mascara
End Property

Public Property Let Mascara(ByVal rhs As String)
  m_Mascara = rhs
End Property

Public Property Get Cai() As String
  Cai = m_Cai
End Property

Public Property Let Cai(ByVal rhs As String)
  m_Cai = rhs
End Property

Public Property Get Creado() As Date
  Creado = m_Creado
End Property

Public Property Let Creado(ByVal rhs As Date)
  m_Creado = rhs
End Property

Public Property Get Modificado() As Date
  Modificado = m_Modificado
End Property

Public Property Let Modificado(ByVal rhs As Date)
  m_Modificado = rhs
End Property

Public Property Get Modifico() As Long
  Modifico = m_Modifico
End Property

Public Property Let Modifico(ByVal rhs As Long)
  m_Modifico = rhs
End Property

Public Property Get Activo() As Boolean
  Activo = m_Activo
End Property

Public Property Let Activo(ByVal rhs As Boolean)
  m_Activo = rhs
End Property
' Properties privadas
' funciones publicas
' Implementacion de cIABMClient
Public Function GetNextNumber(ByVal TA_ID As Long, _
                              ByRef Mask As String, _
                              ByRef bEditable As Boolean, _
                              Optional ByRef Cai As String) As Long
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  sqlstmt = "select ta_ultimonro, ta_mascara, ta_tipo, ta_cai" & _
            " from talonario where ta_id = " & TA_ID
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  If rs.EOF Then
    Mask = ""
    bEditable = False
    Cai = ""
  Else
    Mask = gDB.ValField(rs.Fields, cscTaMascara)
    GetNextNumber = gDB.ValField(rs.Fields, cscTaUltimoNro) + 1
    bEditable = gDB.ValField(rs.Fields, cscTaTipo) = csETTPropuesto
    Cai = gDB.ValField(rs.Fields, cscTaCai)
  End If
End Function

Public Function UpdateLastUsedNumber(ByVal TA_ID As Long, ByVal LastNumber As Long) As Boolean
  Dim register As cRegister
  Set register = New cRegister
  
  If TA_ID = csNO_ID Then Exit Function
  
  register.fieldId = cscTaId
  register.Table = csTTalonario
  register.id = TA_ID
  
  register.Fields.Add2 cscTaUltimoNro, LastNumber, csLong
  
  register.Fields.HaveLastUpdate = True
  register.Fields.HaveWhoModify = True
  
  UpdateLastUsedNumber = gDB.Save(register, , "UpdateLastUsedNumber", C_Module, c_ErrorSave)
End Function
' funciones privadas
' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError

  c_ErrorSave = LNGGetText(3234, vbNullString) 'Error al grabar el último número usado

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, vbNullString
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

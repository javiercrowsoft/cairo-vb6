VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cAFIPCampo"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesInfoAFIP.cIAFIPCampo
'--------------------------------------------------------------------------------
' cAFIPCampo
' 16-07-2003

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cAFIPCampo"
' estructuras
' variables privadas
Private m_Id                           As Long
Private m_Nombre                       As String
Private m_Descrip                      As String
Private m_FormatoFecha                 As String
Private m_Tipo                         As Integer
Private m_Posicion                     As Integer
Private m_Relleno                      As String
Private m_SeparadorDecimal             As String
Private m_CantDigitosEnteros           As Integer
Private m_CantDigitosDecimales         As Integer
Private m_Largo                        As Integer
Private m_Alineacion                   As Integer
Private m_Columna                      As String
Private m_Afreg_id                     As Long
Private m_Registro                     As String
Private m_Creado                       As Date
Private m_Modificado                   As Date
Private m_Modifico                     As Long
Private m_Activo                       As Boolean
Private m_Valor                        As String

Private m_Copy        As Boolean
' eventos

Public Property Get Nombre() As String
  Nombre = m_Nombre
End Property

Public Property Get Descrip() As String
  Descrip = m_Descrip
End Property

Public Property Get FormatoFecha() As String
  FormatoFecha = m_FormatoFecha
End Property

Public Property Get Tipo() As Integer
  Tipo = m_Tipo
End Property

Public Property Get Posicion() As Integer
  Posicion = m_Posicion
End Property

Public Property Get Relleno() As String
  Relleno = m_Relleno
End Property

Public Property Let Relleno(ByVal RHS As String)
  m_Relleno = RHS
End Property

Public Property Get SeparadorDecimal() As String
  SeparadorDecimal = m_SeparadorDecimal
End Property

Public Property Get CantDigitosEnteros() As Integer
  CantDigitosEnteros = m_CantDigitosEnteros
End Property

Public Property Get CantDigitosDecimales() As Integer
  CantDigitosDecimales = m_CantDigitosDecimales
End Property

Public Property Get Largo() As Integer
  Largo = m_Largo
End Property

Public Property Get Alineacion() As Integer
  Alineacion = m_Alineacion
End Property

Public Property Get Columna() As String
  Columna = m_Columna
End Property

Public Property Get Valor() As String
  Valor = m_Valor
End Property

Public Property Let Valor(ByVal RHS As String)
  m_Valor = RHS
End Property

Public Property Get Activo() As Boolean
  Activo = m_Activo
End Property

' Interfaz
Private Property Get cIAFIPCampo_ID() As Long
  cIAFIPCampo_ID = m_Id
End Property

Private Property Let cIAFIPCampo_ID(ByVal RHS As Long)
  m_Id = RHS
End Property

Private Property Get cIAFIPCampo_Nombre() As String
  cIAFIPCampo_Nombre = m_Nombre
End Property

Private Property Let cIAFIPCampo_Nombre(ByVal RHS As String)
  m_Nombre = RHS
End Property

Private Property Get cIAFIPCampo_Descrip() As String
  cIAFIPCampo_Descrip = m_Descrip
End Property

Private Property Let cIAFIPCampo_Descrip(ByVal RHS As String)
  m_Descrip = RHS
End Property

Private Property Get cIAFIPCampo_FormatoFecha() As String
  cIAFIPCampo_FormatoFecha = m_FormatoFecha
End Property

Private Property Let cIAFIPCampo_FormatoFecha(ByVal RHS As String)
  m_FormatoFecha = RHS
End Property

Private Property Get cIAFIPCampo_Tipo() As Integer
  cIAFIPCampo_Tipo = m_Tipo
End Property

Private Property Let cIAFIPCampo_Tipo(ByVal RHS As Integer)
  m_Tipo = RHS
End Property

Private Property Get cIAFIPCampo_Posicion() As Integer
  cIAFIPCampo_Posicion = m_Posicion
End Property

Private Property Let cIAFIPCampo_Posicion(ByVal RHS As Integer)
  m_Posicion = RHS
End Property

Private Property Get cIAFIPCampo_Relleno() As String
  cIAFIPCampo_Relleno = m_Relleno
End Property

Private Property Let cIAFIPCampo_Relleno(ByVal RHS As String)
  m_Relleno = RHS
End Property

Private Property Get cIAFIPCampo_SeparadorDecimal() As String
  cIAFIPCampo_SeparadorDecimal = m_SeparadorDecimal
End Property

Private Property Let cIAFIPCampo_SeparadorDecimal(ByVal RHS As String)
  m_SeparadorDecimal = RHS
End Property

Private Property Get cIAFIPCampo_CantDigitosEnteros() As Integer
  cIAFIPCampo_CantDigitosEnteros = m_CantDigitosEnteros
End Property

Private Property Let cIAFIPCampo_CantDigitosEnteros(ByVal RHS As Integer)
  m_CantDigitosEnteros = RHS
End Property

Private Property Get cIAFIPCampo_CantDigitosDecimales() As Integer
  cIAFIPCampo_CantDigitosDecimales = m_CantDigitosDecimales
End Property

Private Property Let cIAFIPCampo_CantDigitosDecimales(ByVal RHS As Integer)
  m_CantDigitosDecimales = RHS
End Property

Private Property Get cIAFIPCampo_Largo() As Integer
  cIAFIPCampo_Largo = m_Largo
End Property

Private Property Let cIAFIPCampo_Largo(ByVal RHS As Integer)
  m_Largo = RHS
End Property

Private Property Get cIAFIPCampo_Alineacion() As Integer
  cIAFIPCampo_Alineacion = m_Alineacion
End Property

Private Property Let cIAFIPCampo_Alineacion(ByVal RHS As Integer)
  m_Alineacion = RHS
End Property

Private Property Get cIAFIPCampo_Columna() As String
  cIAFIPCampo_Columna = m_Columna
End Property

Private Property Let cIAFIPCampo_Columna(ByVal RHS As String)
  m_Columna = RHS
End Property

Private Property Get cIAFIPCampo_Registro() As String
  cIAFIPCampo_Registro = m_Registro
End Property

Private Property Let cIAFIPCampo_Registro(ByVal RHS As String)
  m_Registro = RHS
End Property

Private Property Get cIAFIPCampo_Valor() As String
  cIAFIPCampo_Valor = m_Valor
End Property

Private Property Let cIAFIPCampo_Valor(ByVal RHS As String)
  m_Valor = RHS
End Property

Private Property Get cIAFIPCampo_Creado() As Date
  cIAFIPCampo_Creado = m_Creado
End Property

Private Property Let cIAFIPCampo_Creado(ByVal RHS As Date)
  m_Creado = RHS
End Property

Private Property Get cIAFIPCampo_Modificado() As Date
  cIAFIPCampo_Modificado = m_Modificado
End Property

Private Property Let cIAFIPCampo_Modificado(ByVal RHS As Date)
  m_Modificado = RHS
End Property

Private Property Get cIAFIPCampo_Modifico() As Long
  cIAFIPCampo_Modifico = m_Modifico
End Property

Private Property Let cIAFIPCampo_Modifico(ByVal RHS As Long)
  m_Modifico = RHS
End Property

Private Property Get cIAFIPCampo_Activo() As Boolean
  cIAFIPCampo_Activo = m_Activo
End Property

Private Property Let cIAFIPCampo_Activo(ByVal RHS As Boolean)
  m_Activo = RHS
End Property

' propiedades friend
' propiedades privadas
' funciones publicas
Public Function Load(ByVal ID As Long) As Boolean

  Dim sqlstmt As String
  Dim rs      As Recordset
  
  sqlstmt = "select AFIPCampo.*, afreg_nombre " & _
            " from AFIPCampo, AFIPRegistro " & _
              " where afcampo_id = " & ID & _
                " and AFIPCampo.afreg_id = AFIPRegistro.afreg_id"

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "Load", C_Module) Then Exit Function

  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.Fields, cscAfCampoId)
    m_Nombre = gDB.ValField(rs.Fields, cscAfCampoNombre)
    m_Descrip = gDB.ValField(rs.Fields, cscAfCampoDescrip)
    m_FormatoFecha = gDB.ValField(rs.Fields, cscAfCampoFormatoFecha)
    m_Tipo = gDB.ValField(rs.Fields, cscAfCampoTipo)
    m_Posicion = gDB.ValField(rs.Fields, cscAfCampoPosicion)
    m_Relleno = gDB.ValField(rs.Fields, cscAfCampoRelleno)
    m_SeparadorDecimal = gDB.ValField(rs.Fields, cscAfCampoSeparadorDecimal)
    m_CantDigitosEnteros = gDB.ValField(rs.Fields, cscAfCampoCantDigitosEnteros)
    m_CantDigitosDecimales = gDB.ValField(rs.Fields, cscAfCampoCantDigitosDecimales)
    m_Largo = gDB.ValField(rs.Fields, cscAfCampoLargo)
    m_Alineacion = gDB.ValField(rs.Fields, cscAfCampoAlineacion)
    m_Columna = gDB.ValField(rs.Fields, cscAfCampoColumna)
    m_Afreg_id = gDB.ValField(rs.Fields, cscAfRegId)
    m_Registro = gDB.ValField(rs.Fields, cscAfRegNombre)
    m_Creado = gDB.ValField(rs.Fields, cscCreado)
    m_Modificado = gDB.ValField(rs.Fields, cscModificado)
    m_Modifico = gDB.ValField(rs.Fields, cscModifico)
    m_Activo = gDB.ValField(rs.Fields, cscActivo)

  Else
    m_Id = csNO_ID
    m_Nombre = vbNullString
    m_Descrip = vbNullString
    m_FormatoFecha = vbNullString
    m_Tipo = 0
    m_Posicion = 0
    m_Relleno = vbNullString
    m_SeparadorDecimal = vbNullString
    m_CantDigitosEnteros = 0
    m_CantDigitosDecimales = 0
    m_Largo = 0
    m_Alineacion = 0
    m_Columna = vbNullString
    m_Afreg_id = csNO_ID
    m_Registro = vbNullString
    m_Creado = csNoDate
    m_Modificado = csNoDate
    m_Modifico = 0
    m_Activo = False

  End If

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
'  If Err.Number <> 0 Then Resume ExitProc
'ExitProc:
'  On Error Resume Next



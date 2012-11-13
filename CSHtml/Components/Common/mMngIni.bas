Attribute VB_Name = "mMngIni"
Option Explicit

'--------------------------------------------------------------------------------
' cMngIni
' 25-10-2002

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones
    Private Declare Function GetPrivateProfileString Lib "kernel32" Alias "GetPrivateProfileStringA" (ByVal lpApplicationName As String, ByVal lpKeyName As Any, ByVal lpDefault As String, ByVal lpReturnedString As String, ByVal nSize As Long, ByVal lpFileName As String) As Long
    Private Declare Function WritePrivateProfileString Lib "kernel32" Alias "WritePrivateProfileStringA" (ByVal lpApplicationName As String, ByVal lpKeyName As Any, ByVal lpString As Any, ByVal lpFileName As String) As Long
'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cMngIni"

Public Const csSepDecimalConfig = 1
Private Const c_K_MainIniConfig = "CONFIG"
Private Const c_MainIniFile = "CSWebBusiness.ini"
' estructuras
' variables privadas
Private m_SepDecimal As String
' eventos
' propiedadades publicas
' propiedadades friend
' propiedades privadas
' funciones publicas
Public Function IniGet(ByVal Item As String, ByVal default As String) As String
  IniGet = GetIniValue(c_K_MainIniConfig, Item, default, pGetFullIniFile())
End Function

Public Sub IniSave(ByVal Item As String, ByVal Value As String)
  SaveIniValue c_K_MainIniConfig, Item, Value, pGetFullIniFile()
End Sub

Public Function IniGetEx(ByVal Section As String, ByVal Item As String, ByVal default As String) As String
  IniGetEx = GetIniValue(Section, Item, default, pGetFullIniFile())
End Function

Public Sub IniSaveEx(ByVal Section As String, ByVal Item As String, ByVal Value As String)
  SaveIniValue Section, Item, Value, pGetFullIniFile()
End Sub

Public Function GetIniValue(ByVal Section As String, ByVal Item As String, ByVal default As String, ByVal File As String) As String
  On Error GoTo ControlError

  Dim Buffer As String
  Dim length As Integer
  Dim rtn    As String
 
  Buffer = String$(256, " ")
  length = GetPrivateProfileString(Section, Item, default, Buffer, Len(Buffer), File)
  rtn = Mid(Buffer, 1, length)
  
  If pIniValueIsDate(rtn) Then
    rtn = pGetIniValueDate(rtn)
  ElseIf pIniValueIsDecimal(rtn) Then
    rtn = pGetIniValueDecimal(rtn)
  Else
    If LCase(rtn) = "true" Or LCase(rtn) = "verdadero" Then
      rtn = "-1"
    ElseIf LCase(rtn) = "false" Or LCase(rtn) = "falso" Then
      rtn = "0"
    End If
  End If
  
  GetIniValue = rtn
  
  GoTo ExitProc
ControlError:
  MngError Err, "GetIniValue", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Public Sub SaveIniValue(ByVal Section, ByVal Item As String, ByVal Value As Variant, ByVal File As String)
  On Error GoTo ControlError
  Dim sValue As String
  
  If VarType(Value) = vbBoolean Then Value = CInt(Value)
  If VarType(Value) = vbDate Then Value = pSetIniValueDate(Value)
  If VarType(Value) = vbDecimal Or VarType(Value) = vbDouble Or VarType(Value) = vbSingle Then Value = pSetIniValueDecimal(Value)
  sValue = Value
  
  WritePrivateProfileString Section, Item, sValue, File

  GoTo ExitProc
ControlError:
  MngError Err, "SaveIniValue", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub
' funciones friend
' funciones privadas
'//////////////////////////////////////////////////////////////////////////////
' Cuando guardo en el ini fechas tengo que tener
' mucho cuidado con el formato internacional
' asi que utilizo mi propio formato para guardarlas
Private Function pGetIniValueDate(ByVal Value As String) As Date
  Dim rtn As Date
  Dim d As Integer
  Dim m As Integer
  Dim y As Integer
  Dim h As Integer
  Dim n As Integer
  Dim s As Integer
  
  d = Mid(Value, 8, 2)
  m = Mid(Value, 11, 2)
  y = Mid(Value, 14, 4)
  h = Mid(Value, 19, 2)
  n = Mid(Value, 22, 2)
  s = Mid(Value, 25, 2)
  
  rtn = DateSerial(y, m, d)
  rtn = DateAdd("h", h, rtn)
  rtn = DateAdd("n", n, rtn)
  rtn = DateAdd("s", s, rtn)
  
  pGetIniValueDate = rtn
End Function

Private Function pSetIniValueDate(ByVal Value As Date) As String
  pSetIniValueDate = "##date:" + Format(Value, "dd-mm-yyyy hh:nn:ss")
End Function

Private Function pIniValueIsDate(ByVal Value As String) As Boolean
  pIniValueIsDate = Left(Value, 7) = "##date:"
End Function

' Lo mismo pasa con los numeros con decimales, hay que tener cuidado con
' los simbolos decimales, por eso paso todo a punto, y cuando leo me encargo
' de pasarlo a coma
Private Function pGetIniValueDecimal(ByVal Value As String) As Double
  If GetSepDecimal = "." Then
    pGetIniValueDecimal = Mid(Trim(Value), 11)
  Else
    pGetIniValueDecimal = Replace(Mid(Trim(Value), 11), ".", GetSepDecimal)
  End If
End Function

Private Function pSetIniValueDecimal(ByVal Value As Double) As String
  pSetIniValueDecimal = "##Decimal:" & Replace(Trim(Value), ",", ".")
End Function

Private Function pIniValueIsDecimal(ByVal Value As String) As Boolean
  pIniValueIsDecimal = Left(Value, 10) = "##Decimal:"
End Function

Private Function pGetFullIniFile() As String
  Dim FullFileName As String
  FullFileName = App.Path & "\" & c_MainIniFile
  pGetFullIniFile = FullFileName
End Function

Public Sub SetSepDecimal()
  If CInt("1.000") = 1 Then
    m_SepDecimal = "."
  ElseIf CInt("1,000") = 1 Then
    m_SepDecimal = ","
  End If
  If m_SepDecimal = "" Then _
    Err.Raise csSepDecimalConfig, "Configuración", "No se puede determinar cual es el separador decimal. Confirme en el 'panel de control/configuración regional' que los valores de la ficha número coincidan con los valores de la ficha moneda en los campos 'simbolo decimal' y 'simbolo de separación de miles'. "
End Sub

Public Function GetSepDecimal() As String
  GetSepDecimal = m_SepDecimal
End Function

Public Sub MngError(ByRef Err As Object, ByVal FunctionName As String, ByVal Module As String, ByVal InfoAdd As String)
  CtxRaiseError Module, FunctionName
End Sub
'//////////////////////////////////////////////////////////////////////////////
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






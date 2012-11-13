Attribute VB_Name = "mPublic"
Option Explicit

'--------------------------------------------------------------------------------
' mPublic
' 30-07-2003

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "mPublic"
' estructuras
' variables privadas
' eventos
' propiedades publicas
' propiedades friend
' propiedades privadas
' funciones publicas
Public Function ReplaceMacros(ByVal stmt As String, ByRef Parametros As cIAFIPParametros, Optional ByVal FolderDBF As String) As String
    
  stmt = Replace(stmt, C_Macro_FechaDesde, GetDate(C_Param_FechaDesde, Parametros))
  stmt = Replace(stmt, C_Macro_FechaHasta, GetDate(C_Param_FechaHasta, Parametros))
  
  ReplaceMacros = stmt
End Function

Public Sub CopyCampos(ByRef FromCampos As cIAFIPCampos, ByRef ToCampos As cIAFIPCampos)
  Dim Campo     As cIAFIPCampo
  
  ToCampos.Clear
  
  For Each Campo In FromCampos
    With ToCampos.Add(Nothing)
      .Activo = Campo.Activo
      .Alineacion = Campo.Alineacion
      .CantDigitosDecimales = Campo.CantDigitosDecimales
      .CantDigitosEnteros = Campo.CantDigitosEnteros
      .Columna = Campo.Columna
      .Creado = Campo.Creado
      .Descrip = Campo.Descrip
      .FormatoFecha = Campo.FormatoFecha
      .Id = Campo.Id
      .Largo = Campo.Largo
      .Modificado = Campo.Modificado
      .Modifico = Campo.Modifico
      .Nombre = Campo.Nombre
      .Posicion = Campo.Posicion
      .Registro = Campo.Registro
      .Relleno = Campo.Relleno
      .SeparadorDecimal = Campo.SeparadorDecimal
      .Tipo = Campo.Tipo
      .Valor = Campo.Valor
    End With
  Next
End Sub

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

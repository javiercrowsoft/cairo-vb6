Attribute VB_Name = "mHelpers"
Option Explicit

'ArticuloTipo enum
Public Enum csEArticuloTipo
  Alerta = 1
  Apertura_de_Mercado = 2
  Cierre_de_Mercado = 3
  Analisis = 4
  Noticia = 5
  Editorial = 6
  Opinion = 7
End Enum

Public Enum csEArticuloEstado
  En_edicion = 1
  Publicada = 2
  Caducada = 3
  Anulada = 4
End Enum

Public Enum csESeccionAccion
  Minimizar = 1
  Maximizar = 2
  Editar = 3
  Cerrar = 4
End Enum

Public Enum csESeccionState
  Minimizado = 1
  Maximizado = 2
  Cerrado = 3
End Enum

Public Enum csEPedidoEstado
  En_edicion = 1
  Confirmado = 2
  Anulado = 3
  Cumplido = 4
End Enum


Public Enum csEOperacionEstado
  Realizada = 1
  Arbitrada = 2
  Anulada = 3
  Finalizada = 4
End Enum

Public Const csETipoCall = "C"
Public Const csETipoPut = "P"
Public Const csETipoFuturo = "F"
  
Public Enum csETipoValor
  Agricola = 1
  Ganadera = 2
  Financiera = 3
  Fruticola = 4
End Enum
  
Public Enum csEClasificadorTipo
  Producccion = 1
  Mercado = 2
  Planificacion = 3
  ComprarYVender = 4
End Enum

Private Declare Function GetComputerNameAPI Lib "kernel32" Alias "GetComputerNameA" _
  (ByVal lpBuffer As String, nSize As Long) As Long

' mp is short for MakeParameter - does typesafe array creation for use with Run* functions
Public Function mp(ByVal PName As String, ByVal PType As ADODB.DataTypeEnum, Optional ByVal PSize As Integer = 0, Optional ByVal PValue As Variant)
  mp = Array(PName, PType, PSize, PValue)
End Function

'Converts a variant into a string. If the varaint is null, it is converted to the empty string.
Public Function ConvertToString(v As Variant) As String
  If IsNull(v) Then
    ConvertToString = ""
  Else
    ConvertToString = CStr(v)
  End If
End Function

'Converts any Null variant to null, otherwise it returns the existing value.
Public Function NullsToZero(v As Variant) As Variant
  If IsNull(v) Then
    NullsToZero = 0
  Else
    NullsToZero = v
  End If
End Function

'Converts an id with 0 value to Null .
Public Function ZeroToNull(v As Variant) As Variant
  If v = 0 Then
    ZeroToNull = Null
  Else
    ZeroToNull = v
  End If
End Function

'Change the transaction state, and raise an error.
Public Sub CtxRaiseError(Module As String, FunctionName As String)
  
  'Set the default to disable transaction. Now unless someone does a SetComplete the transaction will abort.
  'This is just like calling setabort, but has it doesn't destroy the Err object if we are in a transaction.
  GetObjectContext.DisableCommit
  
  'log the error to the event for later use.
  'logError Err.Number, GetErrSourceDescription(module, functionName), Err.description, "from CtxRaiseError"
  
  'Raise an error to indate there was a problem.
  'This will indicate that no one should do a SetComplete unless they can handle this error.
  Err.Raise Err.Number, GetErrSourceDescription(Module, FunctionName), Err.description
End Sub

'Raise an error without changing the transaction state.
Public Sub RaiseError(Module As String, FunctionName As String)
  
  'log the error to the event for later use.
  'logError Err.Number, GetErrSourceDescription(module, functionName), Err.description, "From RaiseError"
  
  Err.Raise Err.Number, GetErrSourceDescription(Module, FunctionName), Err.description
End Sub

Function GetComputerName() As String
  ' Set or retrieve the name of the computer.
  Dim strBuffer As String
  Dim lngLen As Long
    
  strBuffer = Space(255 + 1)
  lngLen = Len(strBuffer)
  If CBool(GetComputerNameAPI(strBuffer, lngLen)) Then
    GetComputerName = Left$(strBuffer, lngLen)
  Else
    GetComputerName = ""
  End If
End Function

Private Function GetErrSourceDescription(modName As String, procName As String) As String
  ' Returns an error message like:  "[CSWebDataBase.Account] VerifyUser [on AHI version 5.21.176]"
  
  GetErrSourceDescription = Err.source & vbNewLine & "<br>" & "[" & modName & "]  " & procName & _
      " [on " & GetComputerName() & " version " & GetVersionNumber() & "]"
End Function

'resturns the current DLL version number
Function GetVersionNumber() As String
  GetVersionNumber = App.Major & "." & App.Minor & "." & App.Revision
End Function

'function takes a string with an '=' in it and returns the left part
'GetKey("test=1") return test
Public Function GetKey(ByVal strItem As String) As String
  Dim i As Integer
  
  i = InStr(1, strItem, "=", vbTextCompare)
  If i > 0 Then
    GetKey = Left(strItem, i - 1)
  Else
    GetKey = ""
  End If
End Function

'function takes a string with an '=' in it and returns the right part
'GetValue("test=1") return 1
Public Function GetValue(ByVal strItem As String) As String
  Dim i As Integer
  
  i = InStr(1, strItem, "=", vbTextCompare)
  If i > 0 Then
    GetValue = Mid(strItem, 1 + i)
  Else
    GetValue = ""
  End If
End Function

'this procedure logs an error to the system application log
Private Sub logError(errnum As Long, source As String, description As String, Optional notes As String = "")
  App.LogEvent vbNewLine & "Ha ocurrido un error en CrowSoft." & vbNewLine & _
                           "Numero:" & errnum & vbNewLine & vbNewLine & _
                           "Descripción:" & vbNewLine & description & vbNewLine & vbNewLine & _
                           "wart_origen: " & vbNewLine & source & vbNewLine & vbNewLine & _
                           "Notas: " & vbNewLine & notes
End Sub

Function OptionIncluded(ByVal TargetOptions As Integer, ByVal OptionAsked As Integer) As Integer
  OptionIncluded = (TargetOptions And OptionAsked) = OptionAsked
End Function

'//////////////////////////////////////////////////////////////////////////////
Public Function GetSelect(ByVal sqlstmt As String) As String
  If InStr(UCase(sqlstmt), "FROM") > 0 Then
    GetSelect = Mid(sqlstmt, 1, InStr(UCase(sqlstmt), "FROM") - 1)
  Else
    GetSelect = sqlstmt
  End If
End Function
Public Function GetFrom(ByVal sqlstmt As String) As String
  sqlstmt = UCase(sqlstmt)
  If InStr(sqlstmt, "FROM") > 0 Then
    sqlstmt = Mid(sqlstmt, InStr(sqlstmt, "FROM"))
  End If
  If InStr(sqlstmt, "WHERE") > 0 Then
    GetFrom = Mid(sqlstmt, 1, InStr(sqlstmt, "WHERE") - 1)
  ElseIf InStr(sqlstmt, "ORDER BY") > 0 Then
    GetFrom = Mid(sqlstmt, 1, InStr(sqlstmt, "ORDER BY") - 1)
  ElseIf InStr(sqlstmt, "GROUP BY") > 0 Then
    GetFrom = Mid(sqlstmt, 1, InStr(sqlstmt, "GROUP BY") - 1)
  Else
    GetFrom = sqlstmt
  End If
End Function
Public Function GetWhere(ByVal sqlstmt As String) As String
  sqlstmt = UCase(sqlstmt)
  If InStr(sqlstmt, "WHERE") > 0 Then
    sqlstmt = Mid(sqlstmt, InStr(sqlstmt, "WHERE"))
    If InStr(sqlstmt, "GROUP BY") > 0 Then
      sqlstmt = Mid(sqlstmt, 1, InStr(sqlstmt, "GROUP BY") - 1)
    End If
    If InStr(sqlstmt, "ORDER BY") > 0 Then
      sqlstmt = Mid(sqlstmt, 1, InStr(sqlstmt, "ORDER BY") - 1)
    End If
  Else
    sqlstmt = ""
  End If
  GetWhere = sqlstmt
End Function
Public Function GetGroup(ByVal sqlstmt As String) As String
  sqlstmt = UCase(sqlstmt)
  If InStr(sqlstmt, "GROUP BY") > 0 Then
    sqlstmt = Mid(sqlstmt, InStr(sqlstmt, "GROUP BY"))
    If InStr(sqlstmt, "ORDER BY") > 0 Then
      GetGroup = Mid(sqlstmt, 1, InStr(sqlstmt, "ORDER BY") - 1)
    Else
      GetGroup = sqlstmt
    End If
  Else
    GetGroup = ""
  End If
End Function
Public Function GetOrder(ByVal sqlstmt As String) As String
  sqlstmt = UCase(sqlstmt)
  If InStr(sqlstmt, "ORDER BY") > 0 Then
    GetOrder = Mid(sqlstmt, InStr(sqlstmt, "ORDER BY"))
  Else
    GetOrder = ""
  End If
End Function

Public Function sqlString(ByVal sValue As String) As String
  sqlString = "'" & Replace(sValue, "'", "''") & "'"
End Function

Public Function sqlNumber(ByVal sValue As Variant) As String
  Dim i As Integer

  If Not IsNumeric(sValue) Then
    sValue = 0
  End If

  If CDbl(sValue) = 0 Then
    sqlNumber = "0"
  Else
    sValue = Format(sValue, "0.0")
    i = InStr(1, sValue, GetSepDecimal)

    ' Reemplazo el separador decimal por punto
    If i > 0 Then
      sqlNumber = Left(sValue, i - 1) + "." + Mid(sValue, i + 1)
    End If
  End If
End Function

Public Function GetSepDecimal() As String
  Dim SepDecimal As String
  
  If CInt("1.000") = 1 Then
    SepDecimal = "."
  ElseIf CInt("1,000") = 1 Then
    SepDecimal = ","
  End If
  If SepDecimal = "" Then _
    Err.Raise vbObjectError + 1, "Configuración", "No se puede determinar cual es el separador decimal. Confirme en el 'panel de control/configuración regional' que los valores de la ficha número coincidan con los valores de la ficha moneda en los campos 'simbolo decimal' y 'simbolo de separación de miles'. "
  GetSepDecimal = SepDecimal
End Function







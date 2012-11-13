Attribute VB_Name = "mHelpers"
Option Explicit

Public Enum csEArticuloTipo
  Alerta = 1
  RecursosHumanos = 2
  Generales = 3
  Publicas = 4
End Enum

Public Enum csEArticuloEstado
  EnEdicion = 1
  Publicada = 2
  Caducada = 3
  Anulada = 4
End Enum
  
Private Declare Function GetComputerNameAPI Lib "kernel32" Alias "GetComputerNameA" (ByVal lpBuffer As String, nSize As Long) As Long

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
Public Sub CtxRaiseError(Module As String, functionName As String)
  
  'Set the default to disable transaction. Now unless someone does a SetComplete the transaction will abort.
  'This is just like calling setabort, but has it doesn't destroy the Err object if we are in a transaction.
  GetObjectContext.DisableCommit
  
  'log the error to the event for later use.
  'logError Err.Number, GetErrSourceDescription(module, functionName), Err.description, "from CtxRaiseError"
  
  'Raise an error to indate there was a problem.
  'This will indicate that no one should do a SetComplete unless they can handle this error.
  Err.Raise Err.Number, GetErrSourceDescription(Module, functionName), Err.description
End Sub

'Raise an error without changing the transaction state.
Public Sub RaiseError(Module As String, functionName As String)
  
  'log the error to the event for later use.
  'logError Err.Number, GetErrSourceDescription(module, functionName), Err.description, "From RaiseError"
  
  Err.Raise Err.Number, GetErrSourceDescription(Module, functionName), Err.description
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
Public Function GetVersionNumber() As String
  GetVersionNumber = App.Major & "." & App.Minor & "." & App.Revision
End Function

#If Not PREPROC_WEBREPORT Then

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

#End If

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
  App.LogEvent vbNewLine & "Ha ocurrido un error." & vbNewLine & _
                           "Numero: " & errnum & vbNewLine & vbNewLine & _
                           "Descripción: " & vbNewLine & description & vbNewLine & vbNewLine & _
                           "Origen: " & vbNewLine & source & vbNewLine & vbNewLine & _
                           "Notas: " & vbNewLine & notes
End Sub

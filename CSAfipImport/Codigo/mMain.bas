Attribute VB_Name = "mMain"
Option Explicit

Public Sub Main()
  Dim Import As cAfipImport
  Set Import = New cAfipImport
  
  If Not Import.Connect() Then Exit Sub
  
  ' Version Final
  ' Import.Import App.Path & "\cuits.tmp"
  
  ' Version Beta
  '
  Import.Import "D:\CrowSoft\Clientes\A.A.A.R.B.A\Elementos tecnicos\Datos\afip\cuits.tmp"
  
  
  ' Reparar el archivo
  '
  'Import.RepairFile "D:\CrowSoft\Clientes\A.A.A.R.B.A\Elementos tecnicos\Datos\afip\cuits.tmp"
End Sub

Public Function RunSPParam(ByVal strSPName As String, _
                           ByRef ParArray As Variant, _
                           ByVal cnConnection As ADODB.Connection) As Integer
   
Dim objCmd As New ADODB.Command

objCmd.ActiveConnection = cnConnection
objCmd.CommandText = strSPName
objCmd.CommandType = adCmdStoredProc
objCmd.CommandTimeout = 0

collectParams objCmd, ParArray

On Error Resume Next
objCmd.Execute , , ADODB.adExecuteNoRecords

If err.Number <> 0 Then
    RunSPParam = 0
    Set objCmd = Nothing
    err.Clear
Else
    RunSPParam = 1
    Set objCmd.ActiveConnection = Nothing
    Set objCmd = Nothing
End If

End Function

Public Sub collectParams(ByRef objCmd As ADODB.Command, ByRef argparams As Variant)
'Arma la coleccion de parametros necesaria para poder ejecutar un SP con parametros

    Dim i As Integer, v As Variant
    
    For i = LBound(argparams) To UBound(argparams) Step 4
        
        If (UBound(argparams) + 1) / 4 = Int((UBound(argparams) + 1) / 4) Then
            ' Check for nulls.
            If TypeName(argparams(i + 3)) = "String" Then
                v = IIf(argparams(i + 3) = "", Null, argparams(i + 3))
            ElseIf IsNumeric(argparams(i + 3)) Then
                v = IIf(argparams(i + 3) < 0, Null, argparams(i + 3))
            Else
                v = argparams(i + 3)
            End If

            objCmd.Parameters.Append objCmd.CreateParameter(argparams(i), argparams(i + 1), adParamInput, argparams(i + 2), v)
        Else
            objCmd.Parameters.Append objCmd.CreateParameter(argparams(i), argparams(i + 1), adParamInput, argparams(i + 2), argparams(i + 3))
        End If
    Next i
End Sub

Public Function Ask(ByVal msg As String) As Boolean
  Ask = MsgBox(msg, vbYesNo) = vbYes
End Function

Public Sub MsgInfo(ByVal msg As String)
  MsgBox msg, vbInformation
End Sub

Public Sub MngError(ByVal fname As String, ByRef err As Object)
  MsgBox fname & ":" & vbCrLf & err.Description, vbCritical
End Sub

'  GoTo ExitProc
'ControlError:
'  MngError "", err
'  If err.Number <> 0 Then Resume ExitProc
'ExitProc:
'  On Error Resume Next




Attribute VB_Name = "mAux"
Option Explicit

'--------------------------------------------------------------------------------
' mAux
' 27-04-2003

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "mAux"
' estructuras
' variables privadas
' eventos
' propiedadades publicas
' propiedadades friend
' propiedades privadas
' funciones publicas
Public Function LoadFromRecordSet(ByRef rs As ADODB.Recordset, ByRef Grid As cGrid, Optional ByVal Add As Boolean) As Boolean
  On Error GoTo ControlError
  
  Dim i As Integer
  Dim iRow As Long
  Dim HaveDetail As Boolean
  Dim Value As String
  
  If Not (rs.EOF And rs.BOF) Then rs.MoveFirst
  
  With Grid
  
    .Redraw = False
    
    If Not Add Then
      .Clear True
    
      For i = 0 To rs.Fields.Count - 1
        Grid.AddColumn , rs.Fields(i).name, , , -1, True
      Next i
      
      .SetHeaders

      If rs.RecordCount > 0 Then .Rows = rs.RecordCount
      iRow = 1

    Else
      If rs.RecordCount > 0 Then .Rows = .Rows + rs.RecordCount
      iRow = Grid.Rows
    End If
  
    While Not rs.EOF
      UpdateRowFromRecordset rs, Grid, iRow
      iRow = iRow + 1
      rs.MoveNext
    Wend

    
    .Redraw = True
  
  End With
  
  LoadFromRecordSet = True
  GoTo ExitProc
ControlError:
  MngError Err, "LoadFromRecordSet", "cGridManager", "", "Error al cargar la grilla", csErrorWarning, csErrorVba
ExitProc:
End Function

Public Function UpdateRowFromRecordset(ByRef rs As Recordset, ByRef Grid As cGrid, _
                                      ByVal iRow As Integer)
  Dim iCol As Long
  Dim i As Integer
  
  If iRow < 1 Then Exit Function
  If iRow > Grid.Rows Then Exit Function
  
  With Grid
    If Not rs.EOF Then
      iCol = 0
      For i = 0 To rs.Fields.Count - 1
        iCol = iCol + 1
        .CellDetails iRow, iCol, rs.Fields(i).Value
      Next
    End If
  End With
  
  UpdateRowFromRecordset = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "UpdateRowFromRecordset", "cGridManager", "", "Error al actualizar la grilla", csErrorWarning, csErrorVba
ExitProc:
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



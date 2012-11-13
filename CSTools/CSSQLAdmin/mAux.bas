Attribute VB_Name = "mAux"
Option Explicit

' constantes
Private Const C_Module = "mAux"

Public Const c_TCPSep1 = ""
Public Const c_TCPSep2 = ""

Public Const csNoDate = #1/1/1900#

Public Const APP_NAME = "CSSQLAdmin"

#If PREPROC_CROWSOFT Then
  Public Const c_LoginSignature   As String = "Virginia Said-Neron-Catalina-la belleza"
#End If

Public Enum csErrores
    csErrorUsuarioInvalido = vbObjectError + 1
    csErrorSepDecimal = vbObjectError + 2
    csErrorSepDecimalConfig = vbObjectError + 3
    csErrorCampoTipoInvalido = vbObjectError + 4
    csErrorVal = vbObjectError + 5
    csErrorSetInfoString = vbObjectError + 6
    csErrorABMCargarControl = vbObjectError + 7
    csErrorUsoPropIdEnPermiso = vbObjectError + 8
    csErrorUsoSubClearEnPermisos = vbObjectError + 9
    csErrorUsoSubRemoveEnPermisos = vbObjectError + 10
    csErrorUsoPropIdEnRol = vbObjectError + 11
    csErrorUsoSubClearEnUsuarioRol = vbObjectError + 12
    csErrorUsoSubRemoveEnUsuarioRol = vbObjectError + 13
    csErrorABMCargarControlSubTypoNotDefined = vbObjectError + 14
End Enum

Public Const c_str_defCommand = "Definición de comandos|*.spr"
Public Const c_str_defDb = "Definicion de base de datos|*.srp"
Public Const csStrDefScriptBatchExt = "spr"
Public Const csStrDefDataBaseExt = "srp"

Public Const C_PSqlFechaHora = "'/'yyyymmdd hh:nn:ss/'"

Public Function AddItemToList(ByRef cbList As Object, ByVal Text As String, Optional ByVal ItemData As Variant) As Integer
  cbList.AddItem Text
  If Not IsMissing(ItemData) Then cbList.ItemData(cbList.NewIndex) = ItemData
  AddItemToList = cbList.NewIndex
End Function

Public Function SelectItemByText(ByRef cbList As Object, ByVal Text As String) As Integer
  Dim i As Integer
  
  SelectItemByText = -1
  
  For i = 0 To cbList.ListCount - 1
    If cbList.List(i) = Text Then
      cbList.ListIndex = i
      SelectItemByText = i
      Exit For
    End If
  Next
End Function

Public Function ExistsItemByText(ByRef cbList As Object, ByVal Text As String) As Boolean
  Dim i As Integer
  
  ExistsItemByText = False
  
  For i = 0 To cbList.ListCount - 1
    If cbList.List(i) = Text Then
      ExistsItemByText = True
      Exit For
    End If
  Next
End Function

Public Function SelectItemByItemData(ByRef cbList As Object, ByVal ItemData As Integer) As Integer
  Dim i As Integer
  
  SelectItemByItemData = -1
  
  For i = 0 To cbList.ListCount - 1
    If cbList.ItemData(i) = ItemData Then
      cbList.ListIndex = i
      SelectItemByItemData = i
      Exit For
    End If
  Next
End Function

Public Sub RemoveFromListByItemData(ByRef cbList As Object, ByVal ItemData As Integer)
  Dim i As Integer
  
  For i = 0 To cbList.ListCount - 1
    If cbList.ItemData(i) = ItemData Then
      cbList.RemoveItem i
      Exit For
    End If
  Next
End Sub

Public Function GetItemData(ByRef cbList As Object) As Long
  If cbList.ListIndex = -1 Then Exit Function
  GetItemData = cbList.ItemData(cbList.ListIndex)
End Function

Public Sub FormCenter(ByRef f As Form)
  f.Move (Screen.Width - f.Width) * 0.5, (Screen.Height - f.Height) * 0.5
End Sub

Public Function AddChildNode(ByRef tv As TreeView, ByVal Father As String, _
                        ByVal Text As String, ByVal key As String, _
                        Optional ByVal Image As Integer, _
                        Optional ByVal SelectedImage As Integer) As Node
  Dim Node As Node
  With tv
    If IsNumeric(Father) Then
      Set Node = .Nodes.Add(Val(Father), tvwChild, , Text)
    Else
      Set Node = .Nodes.Add(Father, tvwChild, , Text)
    End If
    If key <> "" Then Node.key = key
    If Image <> 0 Then Node.Image = Image
    If SelectedImage <> 0 Then Node.SelectedImage = SelectedImage
  End With

  Set AddChildNode = Node

End Function

Public Sub AddHeaderToListView(ByRef lv As ListView, ByVal Text As String, ByVal Width As Integer)
  lv.ColumnHeaders.Add , , Text, Width
End Sub

Public Function AddToListView(ByRef lv As ListView, ByVal Text As String, ByVal key As String, ByRef vSubItems() As String, ByVal SmallIcon As Integer) As ListItem
  Dim lvi As ListItem
  
  Set lvi = lv.ListItems.Add(, , Text)
  If key <> "" Then lvi.key = key
  If SmallIcon <> 0 Then lvi.SmallIcon = SmallIcon
  
  Dim i As Integer
  
  For i = 1 To UBound(vSubItems)
    lvi.ListSubItems.Add , , vSubItems(i)
  Next
  
  i = lv.ColumnHeaders.Count
  
  For i = i + 1 To UBound(vSubItems) + 1
    lv.ColumnHeaders.Add
  Next
  
  Set AddToListView = lvi
  
End Function

Public Function ExistsObjInCollection(ByRef Coll As Collection, ByVal key As String) As Boolean
  On Error Resume Next
  Err.Clear
  Dim v As Variant
  v = Coll(key)
  ExistsObjInCollection = Err.Number = 0
End Function

Public Sub UpdateStatus(ByRef Pic As PictureBox, ByVal sngPercent As Single, Optional ByVal fBorderCase As Boolean = False)
  Dim strPercent  As String
  Dim intX        As Integer
  Dim intY        As Integer
  Dim intWidth    As Integer
  Dim intHeight   As Integer
  
  'For this to work well, we need a white background and any color foreground (blue)
  Const colBackground = vbButtonFace ' white
  Const colForeground = &HC00000    ' dark blue
  
  Pic.ForeColor = colForeground
  Pic.BackColor = colBackground
  
  '
  'Format percentage and get attributes of text
  '
  Dim intPercent
  intPercent = Int(100 * sngPercent + 0.5)
  
  'Never allow the percentage to be 0 or 100 unless it is exactly that value.  This
  'prevents, for instance, the status bar from reaching 100% until we are entirely done.
  If intPercent = 0 Then
    If Not fBorderCase Then
        intPercent = 1
    End If
  ElseIf intPercent >= 100 Then
    intPercent = 100
    If Not fBorderCase Then
        intPercent = 99
    End If
  End If
  
  strPercent = Format$(intPercent) & "%"
  intWidth = Pic.TextWidth(strPercent)
  intHeight = Pic.TextHeight(strPercent)
  
  '
  'Now set intX and intY to the starting location for printing the percentage
  '
  intX = Pic.Width / 2 - intWidth / 2
  intY = Pic.Height / 2 - intHeight / 2
  
  '
  'Need to draw a filled box with the pics background color to wipe out previous
  'percentage display (if any)
  '
  Pic.DrawMode = 13 ' Copy Pen
  Pic.Line (intX, intY)-Step(intWidth, intHeight), Pic.BackColor, BF
  
  '
  'Back to the center print position and print the text
  '
  Pic.CurrentX = intX
  Pic.CurrentY = intY
  Pic.Print strPercent
  
  '
  'Now fill in the box with the ribbon color to the desired percentage
  'If percentage is 0, fill the whole box with the background color to clear it
  'Use the "Not XOR" pen so that we change the color of the text to white
  'wherever we touch it, and change the color of the background to blue
  'wherever we touch it.
  '
  Pic.DrawMode = 10 ' Not XOR Pen
  If sngPercent > 0 Then
    Pic.Line (0, 0)-(Pic.Width * sngPercent, Pic.Height), Pic.ForeColor, BF
  Else
    Pic.Line (0, 0)-(Pic.Width, Pic.Height), Pic.BackColor, BF
  End If
  
  Pic.Refresh
End Sub

Public Function SetInfoString_(ByVal Fuente As String, ByVal Clave As String, ByVal Valor As String) As String
  Dim i As Integer
  Dim j As Integer
  Dim k As Integer
  
  Clave = "#" & Clave
  i = InStr(1, Fuente, Clave, vbTextCompare)
  ' la clave no puede estar repetida
  If InStr(i + 1, Fuente, Clave, vbTextCompare) <> 0 Then Err.Raise csErrorSetInfoString, "CSOAPI", "SetInfoString_: Se intento guardar un valor de clave en una cadena invalida, la clave esta repetida."
  
  ' si aun no existe la agrego al final
  If i = 0 Then
      SetInfoString_ = Fuente + Clave + "=" + Valor + ";"
  Else
      
      j = InStr(i, Fuente, ";", vbTextCompare)
      If j = 0 Then Err.Raise csErrorSetInfoString, "CSOAPI", "SetInfoString_: Se intento guardar un valor de clave en una cadena invalida, la cadena esta corrupta, falta el signo ;."
      
      k = InStr(1, Mid(Fuente, i, j), "=", vbTextCompare)
      If k = 0 Then Err.Raise csErrorSetInfoString, "CSOAPI", "SetInfoString_: Se intento guardar un valor de clave en una cadena invalida, la cadena esta corrupta, falta el signo =."
      k = k + i - 1
      SetInfoString_ = Mid(Fuente, 1, k) + Valor + Mid(Fuente, j)
  End If
End Function

Public Function GetInfoString_(ByVal Fuente As String, ByVal Clave As String, Optional ByVal Default As String = "") As String
  Dim i As Integer
  Dim j As Integer
  Dim k As Integer
  
  Clave = "#" & Clave
  
  i = InStr(1, Fuente, Clave, vbTextCompare)
  ' la clave no puede estar repetida
  If InStr(i + 1, Fuente, Clave, vbTextCompare) <> 0 Then Err.Raise csErrorSetInfoString, "CSOAPI", "GetInfoString_: Se intento obtener un valor de una cadena invalida, la clave esta repetida."
  
  ' si la clave no existe devuelvo el default
  If i = 0 Then
      GetInfoString_ = Default
  Else
      
      j = InStr(i, Fuente, ";", vbTextCompare)
      If j = 0 Then Err.Raise csErrorSetInfoString, "CSOAPI", "GetInfoString_: Se intento obtener un valor de una cadena invalida, la cadena esta corrupta, falta el signo ;."
      
      k = InStr(1, Mid(Fuente, i, j), "=", vbTextCompare)
      If k = 0 Then Err.Raise csErrorSetInfoString, "CSOAPI", "GetInfoString_: Se intento obtener un valor de una cadena invalida, la cadena esta corrupta, falta el signo =."
      k = k + i - 1
      GetInfoString_ = Mid(Fuente, k + 1, j - k - 1)
  End If
End Function

Public Sub info(ByVal Message As String)
  MsgBox Message, vbInformation
End Sub

Public Function Ask(ByVal Message As String) As Boolean

  On Error GoTo ControlError

  Message = Replace(Message, ";", Chr(13) + Chr(10))
  Message = Replace(Message, "/n", Chr(13) + Chr(10))

  If InStr(1, Message, "?") = 0 Then
    Message = "¿ " + Message + " ?"
  End If

  Ask = MsgBox(Message, vbQuestion + vbYesNo) = vbYes

  Exit Function
ControlError:
  MngError Err, "Ask", "", ""
End Function

Public Function SqlReplaceComments(ByVal msg As String) As String
  SqlReplaceComments = Replace(msg, "[Microsoft][ODBC SQL Server Driver][SQL Server]", "")
End Function

Public Function GetFile(ByRef cd As CommonDialog, ByRef File As String, ByVal Filter) As Boolean
  On Error GoTo ControlError
  
  Dim Cancel As Boolean
  
  FindFile cd, File, Cancel, Filter
  
  If Cancel Then Exit Function
  
  GetFile = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "GetFile", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Public Sub FindFile(ByRef cd As CommonDialog, File As String, Cancel As Boolean, ByVal Filter As String)
  On Error GoTo ControlError
  
  Cancel = Not ShowOpenFileDLG(cd, File, Filter)
  
  GoTo ExitProc
ControlError:
  MngError Err, "FindFile", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Public Function RemoveLastColon(ByVal str As String) As String
  On Error Resume Next
  If Right$(str, 1) = "," Then str = Left$(str, Len(str) - 1)
  RemoveLastColon = str
End Function

Public Sub SaveLog(ByVal Message As String)
End Sub


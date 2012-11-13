Attribute VB_Name = "mPublic"
Option Explicit

'--------------------------------------------------------------------------------
' mPublic
' 23-03-02

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Public Const c_AlignRigth = 1
Public Const c_AlignLeft = 2

Public Const LOG_NAME = "\CSInfoAFIP.log"
Public Const LOG_NAME2 = "\CSInfoAFIP"

' estructuras
' variables privadas
' variables publicas

' Base de datos
Public gDB          As cDataBase

' nombre de la Aplication
Public gAppName     As String

' funciones publicas
Public Sub FillSubTipoParametro(ByVal c As cIABMProperty)
  With c.List.Add(Nothing)
    .ID = 0
    .Value = "(Ninguno)"
  End With
  With c.List.Add(Nothing)
    .ID = csSubTypeABMProperty.cspCuit
    .Value = "CUIT"
  End With
  With c.List.Add(Nothing)
    .ID = csSubTypeABMProperty.cspDouble
    .Value = "Decimal"
  End With
  With c.List.Add(Nothing)
    .ID = csSubTypeABMProperty.cspInteger
    .Value = "Entero"
  End With
  With c.List.Add(Nothing)
    .ID = csSubTypeABMProperty.cspMask
    .Value = "Mascara"
  End With
  With c.List.Add(Nothing)
    .ID = csSubTypeABMProperty.cspMemo
    .Value = "Memo"
  End With
  With c.List.Add(Nothing)
    .ID = csSubTypeABMProperty.cspMoney
    .Value = "Moneda"
  End With
  With c.List.Add(Nothing)
    .ID = csSubTypeABMProperty.cspPercent
    .Value = "Porcentaje"
  End With
End Sub

Public Sub FillTipoParametro(ByVal c As cIABMProperty)
  
  With c.List.Add(Nothing)
    .ID = csTypeABMProperty.cspAdHock
    .Value = "Lista AdHoc"
  End With
  With c.List.Add(Nothing)
    .ID = csTypeABMProperty.cspButton
    .Value = "Boton"
  End With
  With c.List.Add(Nothing)
    .ID = csTypeABMProperty.cspCheck
    .Value = "CheckBox"
  End With
  With c.List.Add(Nothing)
    .ID = csTypeABMProperty.cspDate
    .Value = "Fecha"
  End With
  With c.List.Add(Nothing)
    .ID = csTypeABMProperty.cspGrid
    .Value = "Grilla"
  End With
  With c.List.Add(Nothing)
    .ID = csTypeABMProperty.cspHelp
    .Value = "Help"
  End With
  With c.List.Add(Nothing)
    .ID = csTypeABMProperty.cspImage
    .Value = "Imagen"
  End With
  With c.List.Add(Nothing)
    .ID = csTypeABMProperty.cspList
    .Value = "Lista"
  End With
  With c.List.Add(Nothing)
    .ID = csTypeABMProperty.cspNumeric
    .Value = "Numerico"
  End With
  With c.List.Add(Nothing)
    .ID = csTypeABMProperty.cspOption
    .Value = "OptionButton"
  End With
  With c.List.Add(Nothing)
    .ID = csTypeABMProperty.cspPassword
    .Value = "Password"
  End With
  With c.List.Add(Nothing)
    .ID = csTypeABMProperty.cspText
    .Value = "Texto"
  End With
  With c.List.Add(Nothing)
    .ID = csTypeABMProperty.cspTime
    .Value = "Hora"
  End With
  With c.List.Add(Nothing)
    .ID = csTypeABMProperty.cspToolBar
    .Value = "ToolBar"
  End With
  With c.List.Add(Nothing)
    .ID = csTypeABMProperty.cspFile
    .Value = "Archivo"
  End With
  With c.List.Add(Nothing)
    .ID = csTypeABMProperty.cspFolder
    .Value = "Carpeta"
  End With
End Sub

Public Function GetCell(ByRef Row As cIABMGridRow, ByVal Key As Long) As cIABMGridCellValue
  Dim Cell As cIABMGridCellValue
  
  For Each Cell In Row
    If Cell.Key = Key Then
      Set GetCell = Cell
      Exit Function
    End If
  Next
End Function

' funciones privadas

' construccion - destruccion





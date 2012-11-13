Attribute VB_Name = "mError"
Option Explicit
'--------------------------------------------------------------------------------
' mError
' 15-09-2001

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
' constantes
' estructuras
' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module As String = "mError"

Public gDebug_ControlName As String
Public gDebug_SectionLine As String
Public gDebug_Section     As String

' estructuras
' variables privadas
' eventos
' propiedades publicas
' propiedades privadas
' funciones publicas
' funciones privadas
' construccion - destruccion
Public Function errGetDescript(ByVal RptErrCode As csRptErrors, ParamArray X() As Variant) As String
  Dim s As String
  Select Case RptErrCode
    Case csRptErrors.csRptErrLaunchInfoIndefined
      s = "Debe pasar a la función Launch del objeto cReport la estructura oLaunchInfo, o antes de llamar al metodo Launch debe llamar al metodo Init."
    
    Case csRptErrors.csRptErrSintaxErrorMissingBrakets
      s = "Error de sintaxis en formulas. Se indicó una función Interna pero no se encontro el parentesis '('"
    
    Case csRptErrors.csRptErrIndefinedFunction
      s = "La funcion $1 no esta definida"
    
    Case csRptErrors.csRptErrMissingParam
      s = "No se indico el parametro $1 en la llamada a la funcion $2"
    
    Case csRptErrors.csRptErrControlNotFound
      s = "No se encontro el control $1"
    
    Case csRptErrors.csRptErrGroupNotFound
      s = "El grupo '$1' debe agrupar por el campo '$2' pero este no se encuentra entre las columnas que componen el recordset."
    
    Case csRptErrGroupNotInMainRS
      s = "El grupo '$1' debe agrupar por el campo '$2' pero este no pertenece al recordset principal."
      
    Case csRptErrors.csRptErrFieldNotFound
      s = "El control '$1' representa el campo '$2' pero este no se encuentra entre las columnas que componen el recordset."
    
    Case csRptErrVarNotDefined
      s = "No se ha encontrado la variable $1 en la colección de variables. Las variables deben ser declaradas con DeclareVar antes de poder usar SetVar y GetVar."
    
    Case csRptErrParamNotDefined
      s = "No se ha encontrado el parametro $1 en la colección de parametros. Los parametros deben estar presentes en la conexión prnicipal."
      
    Case csRptErrPrinterNotDefined
      s = "La impresora no esta definida. Esto puede ocurrir por que su sistema aun no tiene configurada una impresora, o no existe ninguna impresora definida como 'impresora por defecto'."
      
    Case Else
      s = "No hay información para este error"
  End Select

  Dim i As Integer

  For i = 0 To UBound(X)
    s = Replace(s, "$" & i + 1, X(i))
  Next
  
  s = s & vbCrLf & vbCrLf & _
      "Section: " & gDebug_Section & vbCrLf & _
      "Sec. Line: " & gDebug_SectionLine & vbCrLf & _
      "Control: " & gDebug_ControlName & vbCrLf

  errGetDescript = s
End Function


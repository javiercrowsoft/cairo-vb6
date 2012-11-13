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

' estructuras
' variables privadas
' eventos
' propiedades publicas
' propiedades privadas
' funciones publicas
' funciones privadas
' construccion - destruccion

Public Function errGetDescript(ByVal RptErrCode As csRptPaintErrors) As String
  Select Case RptErrCode
    Case RptErrCode = csRptPaintErrors.csRptPatintErrObjClient
      errGetDescript = "La propiedad ObjectClient del objeto cReportPaint no esta definido, y se ha llamado al metodo DrawObject."
    Case RptErrCode = csRptPaintErrors.csRptPatintErrObjClientInvalid
      errGetDescript = "La propiedad ObjectClient del objeto cReportPaint no es valida (apunta a un objeto que no es ni un Printer ni un PictureBox), y se ha llamado al metodo DrawObject."
    Case Else
      errGetDescript = "No hay información para este error"
  End Select
End Function


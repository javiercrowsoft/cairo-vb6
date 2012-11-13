Attribute VB_Name = "mAux"
Option Explicit

'--------------------------------------------------------------------------------
' mAux
' 30-10-2001

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
' constantes
' estructuras
' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module As String = "mAux"
' estructuras
' variables privadas
Private m_NextKey As Integer
' eventos
' propiedades publicas
' propiedades privadas
' funciones publicas
Public Function IsNothing(ByRef Obj As Object) As Boolean
  IsNothing = Obj Is Nothing
End Function
Public Function GetNextKey() As Integer
  m_NextKey = m_NextKey + 1
  GetNextKey = m_NextKey
End Function

Public Function IsDbNull(ByVal Val As Variant) As Boolean
  IsDbNull = IsNull(Val)
End Function

Public Function ValField(ByRef Field As ADODB.Field) As Variant
  If Field Is Nothing Then
    Err.Raise CSKernelClient2.csErrores.csErrorVal, "VAL function CSOAPI", "No se paso un campo. Error interno"
  End If

  If IsDbNull(Field.Value) Then
    Select Case Field.Type
      Case ADODB.DataTypeEnum.adLongVarChar, ADODB.DataTypeEnum.adLongVarWChar, ADODB.DataTypeEnum.adChar, ADODB.DataTypeEnum.adVarChar, ADODB.DataTypeEnum.adVarWChar, ADODB.DataTypeEnum.adWChar
        ValField = ""
      Case ADODB.DataTypeEnum.adBigInt, ADODB.DataTypeEnum.adBinary, ADODB.DataTypeEnum.adInteger, ADODB.DataTypeEnum.adLongVarBinary, ADODB.DataTypeEnum.adNumeric, ADODB.DataTypeEnum.adSmallInt, ADODB.DataTypeEnum.adTinyInt, ADODB.DataTypeEnum.adUnsignedBigInt, ADODB.DataTypeEnum.adUnsignedInt, ADODB.DataTypeEnum.adUnsignedSmallInt, ADODB.DataTypeEnum.adUnsignedTinyInt
        ValField = 0
      Case ADODB.DataTypeEnum.adBoolean
        ValField = False
      Case ADODB.DataTypeEnum.adCurrency, ADODB.DataTypeEnum.adSingle, ADODB.DataTypeEnum.adDecimal, ADODB.DataTypeEnum.adDouble
        ValField = 0
      Case ADODB.DataTypeEnum.adDBTime, ADODB.DataTypeEnum.adDate, ADODB.DataTypeEnum.adDBDate
        ValField = #1/1/1900#
      Case ADODB.DataTypeEnum.adDBTimeStamp
        ValField = #1/1/1900#
    End Select
  Else
    ValField = Field.Value
  End If
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
'ExitProc:


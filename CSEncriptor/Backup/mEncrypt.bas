Attribute VB_Name = "mEncrypt"
Option Explicit

'///////////////////////////////////////////
'///////////////////////////////////////////
'///////////////////////////////////////////
'
' ESTE MODULO ES OBSOLETO !!!
'
' EL NUEVO MODULO SE ENCUENTRA EN
'
' ..\Proyectos\CSEncryptor
'
' AUN USO ESTE POR QUE POR UN ERROR AL
' PREPARAR LA VERSION ME HA QUEDADO UNA
' REFERENCIA A LA DLL CSEncrypt.dll EN
' VARIOS PROYECTOS, INCLUYENDO CSSERVER
' ESTO SIGNIFICA QUE LA CAIRO_DOMINIO
' DE CROWSOFT, GNGAS, NORTUR, Y AAARBA
' ESTAN EncryptADAS CON ESTE CODIGO
'
' ANTES DE SALIR AL RUEDO VAMOS A CORREGIR
' ESTE DETALLE
'
'///////////////////////////////////////////
'///////////////////////////////////////////
'///////////////////////////////////////////

' Encrypt

' Proposito: Crear una interfaz de Encryptacion con dos funciones
' publicas Encrypt y Decrypt encargadas de todo el proceso.

' Encrypt: Encrypta una cadena basandose en una firma
' Parametros:
'             - ToEncrypt   Cadena a Encryptar
'             - Signature   Firma
' Retorno: Cadena Encryptada

' Como trabaja: Suma el valor ascii de cada caracter de la firma, y
'               luego hace un xor a cada caracter ascii de la cadena
'               a Encryptar, luego vuelve a hacer lo mismo pero con los
'               bits de la firma invertidos.
Public Function Encrypt(ByVal ToEncrypt As String, ByVal Signature As String) As String
  Dim c As String
  Dim i As Long
  Dim j As Long
  Dim mask As Integer
  Dim rtn  As String
  
  i = Len(Signature)
  For j = 1 To i
    c = Mid(Signature, j, 1)
    mask = mask + Asc(c)
  Next
  
  While mask > 255
    mask = mask / 2
  Wend
  
  i = Len(ToEncrypt)
  For j = 1 To i
    c = Mid(ToEncrypt, j, 1)
    rtn = rtn + Chr((Asc(c) Xor mask))
  Next
  
  Encrypt = rtn
End Function

' Decrypt: Decrypta una cadena basandose en una firma
' Parametros:
'             - ToDecrypt   Cadena a Decryptar
'             - Signature   Firma
' Retorno: Cadena Decryptada

' Como trabaja: Suma el valor ascii de cada caracter de la firma, y
'               luego hace un xor de la firma con &Hff y realiza un xor
'               a cada caracter ascii de la cadena a Encryptar, luego
'               vuelve a hacer lo mismo pero con los bits de la
'               firma invertidos.
Public Function Decrypt(ByVal ToDecrypt As String, ByVal Signature As String) As String
  Dim c As String
  Dim i As Long
  Dim j As Long
  Dim mask As Integer
  Dim rtn  As String
  
  i = Len(Signature)
  For j = 1 To i
    c = Mid(Signature, j, 1)
    mask = mask + Asc(c)
  Next
  
  While mask > 255
    mask = mask / 2
  Wend
  
  i = Len(ToDecrypt)
  For j = 1 To i
    c = Mid(ToDecrypt, j, 1)
    rtn = rtn + Chr((Asc(c) Xor mask))
  Next
  
  Decrypt = rtn
End Function


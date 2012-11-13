Attribute VB_Name = "mEncrypt"
Option Explicit

' Encrypt

Private Const c_Mask = "± ¡º¬¡ «±¬£¬ ·Åª«Åèï¢ªèï¶ ±Å¤«¶¬º«°©©¶Åª«Åèï¢ªèïèïŒƒÅ€Œ–‘–ÅÍ–€‰€†‘ÅÏÅƒ—ŠˆÅ‡ŠË–œ–Š‡€†‘–Å’€—€ÅŒÅØÅŠ‡€†‘ºŒÍ«Â¾‡Š¸Ë¾¡¦º¦¶¦º "

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
  Dim c           As String
  Dim i           As Long
  Dim j           As Long
  Dim x           As Integer
  Dim mask        As Integer
  Dim rtn         As String
  Dim vIndex(128) As Integer
  
  x = pGetValMask(Signature)
  
  pGetvIndex vIndex, x
  
  i = 0
  For j = 1 To Len(ToEncrypt)
    
    c = Mid(ToEncrypt, j, 1)
    
    i = i + 1
    If i > 128 Then i = 1
    mask = Asc(Mid(c_Mask, vIndex(i), 1))
    
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
  Decrypt = Encrypt(ToDecrypt, Signature)
End Function

Private Function pGetValMask(ByVal Signature As String) As Integer
  Dim mask As Integer
  Dim i    As Integer
  Dim c    As String
  
  For i = 1 To Len(Signature)
    c = Mid(Signature, i, 1)
    mask = mask + Asc(c)
  Next
  
  While mask > 255
    mask = mask / 2
  Wend
  
  pGetValMask = mask
End Function

Private Function pGetvIndex(ByRef vIndex() As Integer, ByVal x As Integer)
  Dim i As Long
  Dim z As Integer
  Dim j As Long
  
  For i = 1 To 128
    If x > i Then
      z = x - i
    ElseIf x < i Then
      z = i - x
    Else ' x=i
      z = x + i
    End If
    
    While z > 128
      z = z / 2
    Wend
    
    For j = 1 To i
      If vIndex(j) = z Then z = z / 2
    Next
    If z = 0 Then
      z = 125
    End If
    vIndex(i) = z
  Next
End Function

Attribute VB_Name = "mGetActivacion"
Option Explicit

Public Function GetCodigo(ByVal strCode As String, ByVal Empresas As Long, ByVal Usuarios As Long, ByVal Vto As Date) As String
  Dim j As Long
  Dim i As Long
  Dim k As Long
  
  Dim vCodes(6)    As Long
  Dim vCodes2(13)  As Long
  Dim vCodes3(7)   As Long

  k = GetSumCode(strCode, vCodes)
  
  ' Empresas
  vCodes3(1) = Fix(Empresas / 10)
  Empresas = Empresas Mod 10
  vCodes3(2) = Empresas
  
  ' Usuarios
  vCodes3(3) = Fix(Usuarios / 100)
  Usuarios = Usuarios Mod 100
  vCodes3(4) = Fix(Usuarios / 10)
  Usuarios = Usuarios Mod 10
  vCodes3(5) = Usuarios
  
  ' Vencimientos
  vCodes3(6) = Month(Vto) + k
  vCodes3(7) = Right$(Year(Vto), 2) + k
  
  '------------------------
  ' 1 ' 2 ' 3 ' 4 ' 5 ' 6 '
  '------------------------
  Select Case k
    Case 1  '------------------------
            ' 2 ' 1 ' 5 ' 6 ' 4 ' 3 '
            '------------------------
            vCodes2(2) = vCodes(1)
            vCodes2(1) = vCodes(2)
            vCodes2(5) = vCodes(3)
            vCodes2(6) = vCodes(4)
            vCodes2(4) = vCodes(5)
            vCodes2(3) = vCodes(6)
            
    Case 2  '------------------------
            ' 6 ' 2 ' 4 ' 1 ' 3 ' 5 '
            '------------------------
            vCodes2(6) = vCodes(1)
            vCodes2(2) = vCodes(2)
            vCodes2(4) = vCodes(3)
            vCodes2(1) = vCodes(4)
            vCodes2(3) = vCodes(5)
            vCodes2(5) = vCodes(6)
            
    Case 3  '------------------------
            ' 5 ' 6 ' 1 ' 4 ' 2 ' 3 '
            '------------------------
            vCodes2(5) = vCodes(1)
            vCodes2(6) = vCodes(2)
            vCodes2(1) = vCodes(3)
            vCodes2(4) = vCodes(4)
            vCodes2(2) = vCodes(5)
            vCodes2(3) = vCodes(6)
            
    Case 4  '------------------------
            ' 3 ' 5 ' 6 ' 2 ' 4 ' 1 '
            '------------------------
            vCodes2(3) = vCodes(1)
            vCodes2(5) = vCodes(2)
            vCodes2(6) = vCodes(3)
            vCodes2(2) = vCodes(4)
            vCodes2(4) = vCodes(5)
            vCodes2(1) = vCodes(6)
            
    Case 5  '------------------------
            ' 4 ' 3 ' 5 ' 6 ' 1 ' 2 '
            '------------------------
            vCodes2(4) = vCodes(1)
            vCodes2(3) = vCodes(2)
            vCodes2(5) = vCodes(3)
            vCodes2(6) = vCodes(4)
            vCodes2(1) = vCodes(5)
            vCodes2(2) = vCodes(6)
            
    Case 6  '------------------------
            ' 1 ' 4 ' 3 ' 5 ' 6 ' 2 '
            '------------------------
            vCodes2(1) = vCodes(1)
            vCodes2(4) = vCodes(2)
            vCodes2(3) = vCodes(3)
            vCodes2(5) = vCodes(4)
            vCodes2(6) = vCodes(5)
            vCodes2(2) = vCodes(6)
  End Select
  
  For i = 1 To 6
    vCodes(i) = vCodes2(i)
  Next
  
  Select Case k
    Case 1  '------------------------
            ' 13 ' 2 ' 6 ' 8 ' 9 ' 3 '
            '------------------------
            vCodes2(1) = vCodes3(1)
            vCodes2(2) = vCodes(2)
            vCodes2(3) = vCodes(6)
            vCodes2(4) = vCodes3(2)
            vCodes2(5) = vCodes3(3)
            vCodes2(6) = vCodes(3)
            vCodes2(7) = vCodes3(4)
            vCodes2(8) = vCodes(4)
            vCodes2(9) = vCodes(5)
            vCodes2(10) = vCodes3(5)
            vCodes2(11) = vCodes3(6)
            vCodes2(12) = vCodes3(7)
            vCodes2(13) = vCodes(1)
            
    Case 2  '------------------------
            ' 6 ' 11 ' 5 ' 1 ' 8 ' 2 '
            '------------------------
            vCodes2(1) = vCodes(4)
            vCodes2(2) = vCodes(6)
            vCodes2(3) = vCodes3(1)
            vCodes2(4) = vCodes3(2)
            vCodes2(5) = vCodes(3)
            vCodes2(6) = vCodes(1)
            vCodes2(7) = vCodes3(3)
            vCodes2(8) = vCodes(5)
            vCodes2(9) = vCodes3(4)
            vCodes2(10) = vCodes3(5)
            vCodes2(11) = vCodes(2)
            vCodes2(12) = vCodes3(6)
            vCodes2(13) = vCodes3(7)
                        
    Case 3  '------------------------
            ' 12 ' 7 ' 1 ' 3 ' 9 ' 5 '
            '------------------------
            vCodes2(1) = vCodes(3)
            vCodes2(2) = vCodes3(1)
            vCodes2(3) = vCodes(4)
            vCodes2(4) = vCodes3(2)
            vCodes2(5) = vCodes(6)
            vCodes2(6) = vCodes3(3)
            vCodes2(7) = vCodes(2)
            vCodes2(8) = vCodes3(4)
            vCodes2(9) = vCodes(5)
            vCodes2(10) = vCodes3(5)
            vCodes2(11) = vCodes3(6)
            vCodes2(12) = vCodes(1)
            vCodes2(13) = vCodes3(7)
            
    Case 4  '------------------------
            ' 7 ' 1 ' 2 ' 10 ' 3 ' 12 '
            '------------------------
            vCodes2(1) = vCodes(2)
            vCodes2(2) = vCodes(3)
            vCodes2(3) = vCodes(5)
            vCodes2(4) = vCodes3(1)
            vCodes2(5) = vCodes3(2)
            vCodes2(6) = vCodes3(3)
            vCodes2(7) = vCodes(1)
            vCodes2(8) = vCodes3(6)
            vCodes2(9) = vCodes3(4)
            vCodes2(10) = vCodes(4)
            vCodes2(11) = vCodes3(5)
            vCodes2(12) = vCodes(6)
            vCodes2(13) = vCodes3(7)
    
    Case 5  '------------------------
            ' 5 ' 10 ' 13 ' 3 ' 8 ' 6 '
            '------------------------
            vCodes2(1) = vCodes3(1)
            vCodes2(2) = vCodes3(2)
            vCodes2(3) = vCodes(4)
            vCodes2(4) = vCodes3(3)
            vCodes2(5) = vCodes(1)
            vCodes2(6) = vCodes(6)
            vCodes2(7) = vCodes3(4)
            vCodes2(8) = vCodes(5)
            vCodes2(9) = vCodes3(5)
            vCodes2(10) = vCodes(2)
            vCodes2(11) = vCodes3(6)
            vCodes2(12) = vCodes3(7)
            vCodes2(13) = vCodes(3)
    
    Case 6  '------------------------
            ' 11 ' 1 ' 3 ' 7 ' 4 ' 13 '
            '------------------------
            vCodes2(1) = vCodes(2)
            vCodes2(2) = vCodes3(1)
            vCodes2(3) = vCodes(3)
            vCodes2(4) = vCodes(5)
            vCodes2(5) = vCodes3(2)
            vCodes2(6) = vCodes3(3)
            vCodes2(7) = vCodes(4)
            vCodes2(8) = vCodes3(4)
            vCodes2(9) = vCodes3(5)
            vCodes2(10) = vCodes3(6)
            vCodes2(11) = vCodes(1)
            vCodes2(12) = vCodes3(7)
            vCodes2(13) = vCodes(6)
  End Select
  
  Dim z As Long
  Dim v(3) As String
  
  v(1) = "*"
  v(2) = "-"
  v(3) = "+"
  
  strCode = ""
  
  z = 1
  For i = 1 To 13
    If vCodes2(i) = 0 Then
      If z > 3 Then z = 1
      strCode = strCode & v(z)
      z = z + 1
    Else
      strCode = strCode & m_vChars(vCodes2(i))
    End If
  Next
  
  GetCodigo = strCode
End Function

Attribute VB_Name = "mResolveActivacion"
Option Explicit

Public Function GetEmpresas(ByVal strCode As String) As Long
  Dim rtn As Long
  If pIsValidateCode(strCode) <> c_ACTIVE_CODE_OK Then Exit Function
  pGetEmpresasUsuariosYVto strCode, rtn, 0, 0
  GetEmpresas = rtn
End Function

Public Function GetUsuarios(ByVal strCode As String) As Long
  Dim rtn As Long
  If pIsValidateCode(strCode) <> c_ACTIVE_CODE_OK Then Exit Function
  pGetEmpresasUsuariosYVto strCode, 0, rtn, 0
  GetUsuarios = rtn
End Function

Public Function GetVto(ByVal strCode As String) As Date
  Dim rtn As Date
  pGetEmpresasUsuariosYVto strCode, 0, 0, rtn
  GetVto = rtn
End Function

Public Function IsValidCode(ByVal strCode As String) As Long
  IsValidCode = pIsValidateCode(strCode)
End Function

Private Function pIsValidateCode(ByVal strCode As String) As Long
  Dim k             As Long
  Dim vDummy(6)     As Long
  Dim strCode2      As String
  Dim strRealCode   As String
  Dim Vto           As Date
  
  Dim idx As Long
  Dim rtn As Long
  
  For idx = 0 To 10
  
    strCode2 = GetMACAddressInText(GetMACAddress(idx))
    
    ' Si no hay Mac Address salgo con 100 empresas y con
    ' 100 usuarios por que si no hay Mac Address no
    ' hay red y lo mas probable es que se trate de
    ' mi Notebook desconectada en alguna demo
    ' como ya me paso antes jijijiji!!!!!
    '
    If LenB(strCode2) = 0 And idx = 0 Then
      
      pIsValidateCode = c_ACTIVE_CODE_OK
    
    Else
    
      k = GetSumCode(strCode2, vDummy)
      
      strRealCode = pGetCode(strCode, k)
      
      strCode2 = Replace(strCode2, "*", " ")
      strCode2 = Replace(strCode2, "-", " ")
      strCode2 = Replace(strCode2, "+", " ")
      
      If Not strRealCode = strCode2 Then
        rtn = c_ACTIVE_CODE_INVALID_CODE
      Else
        Vto = GetVto(strCode)
        If Vto < Date Then
          rtn = c_ACTIVE_CODE_INVALID_DATE
        Else
          rtn = c_ACTIVE_CODE_OK
          Exit For
        End If
      End If
    End If
  Next
  
  pIsValidateCode = rtn
End Function

Private Function pGetCode(ByVal strCode As String, ByVal k As Long) As String
  Dim vCodes3(13)   As Long
  Dim vCodes2(6)    As Long
  Dim vCodes(6)     As Long
  Dim i             As Long
  
  GetSumCode strCode, vCodes3, 13

  Select Case k
    Case 1  '------------------------
            ' 13 ' 2 ' 6 ' 8 ' 9 ' 3 '
            '------------------------
            vCodes2(1) = vCodes3(13)
            vCodes2(2) = vCodes3(2)
            vCodes2(3) = vCodes3(6)
            vCodes2(4) = vCodes3(8)
            vCodes2(5) = vCodes3(9)
            vCodes2(6) = vCodes3(3)
            
    Case 2  '------------------------
            ' 6 ' 11 ' 5 ' 1 ' 8 ' 2 '
            '------------------------
            vCodes2(1) = vCodes3(6)
            vCodes2(2) = vCodes3(11)
            vCodes2(3) = vCodes3(5)
            vCodes2(4) = vCodes3(1)
            vCodes2(5) = vCodes3(8)
            vCodes2(6) = vCodes3(2)
                        
    Case 3  '------------------------
            ' 12 ' 7 ' 1 ' 3 ' 9 ' 5 '
            '------------------------
            vCodes2(1) = vCodes3(12)
            vCodes2(2) = vCodes3(7)
            vCodes2(3) = vCodes3(1)
            vCodes2(4) = vCodes3(3)
            vCodes2(5) = vCodes3(9)
            vCodes2(6) = vCodes3(5)
            
    Case 4  '------------------------
            ' 7 ' 1 ' 2 ' 10 ' 3 ' 12 '
            '------------------------
            vCodes2(1) = vCodes3(7)
            vCodes2(2) = vCodes3(1)
            vCodes2(3) = vCodes3(2)
            vCodes2(4) = vCodes3(10)
            vCodes2(5) = vCodes3(3)
            vCodes2(6) = vCodes3(12)
    
    Case 5  '------------------------
            ' 5 ' 10 ' 13 ' 3 ' 8 ' 6 '
            '------------------------
            vCodes2(1) = vCodes3(5)
            vCodes2(2) = vCodes3(10)
            vCodes2(3) = vCodes3(13)
            vCodes2(4) = vCodes3(3)
            vCodes2(5) = vCodes3(8)
            vCodes2(6) = vCodes3(6)
    
    Case 6  '------------------------
            ' 11 ' 1 ' 3 ' 7 ' 4 ' 13 '
            '------------------------
            vCodes2(1) = vCodes3(11)
            vCodes2(2) = vCodes3(1)
            vCodes2(3) = vCodes3(3)
            vCodes2(4) = vCodes3(7)
            vCodes2(5) = vCodes3(4)
            vCodes2(6) = vCodes3(13)
  End Select
  
  Select Case k
    Case 1  '------------------------
            ' 2 ' 1 ' 5 ' 6 ' 4 ' 3 '
            '------------------------
            vCodes(1) = vCodes2(2)
            vCodes(2) = vCodes2(1)
            vCodes(3) = vCodes2(5)
            vCodes(4) = vCodes2(6)
            vCodes(5) = vCodes2(4)
            vCodes(6) = vCodes2(3)
            
    Case 2  '------------------------
            ' 6 ' 2 ' 4 ' 1 ' 3 ' 5 '
            '------------------------
            vCodes(1) = vCodes2(6)
            vCodes(2) = vCodes2(2)
            vCodes(3) = vCodes2(4)
            vCodes(4) = vCodes2(1)
            vCodes(5) = vCodes2(3)
            vCodes(6) = vCodes2(5)
            
    Case 3  '------------------------
            ' 5 ' 6 ' 1 ' 4 ' 2 ' 3 '
            '------------------------
            vCodes(1) = vCodes2(5)
            vCodes(2) = vCodes2(6)
            vCodes(3) = vCodes2(1)
            vCodes(4) = vCodes2(4)
            vCodes(5) = vCodes2(2)
            vCodes(6) = vCodes2(3)
            
    Case 4  '------------------------
            ' 3 ' 5 ' 6 ' 2 ' 4 ' 1 '
            '------------------------
            vCodes(1) = vCodes2(3)
            vCodes(2) = vCodes2(5)
            vCodes(3) = vCodes2(6)
            vCodes(4) = vCodes2(2)
            vCodes(5) = vCodes2(4)
            vCodes(6) = vCodes2(1)
            
    Case 5  '------------------------
            ' 4 ' 3 ' 5 ' 6 ' 1 ' 2 '
            '------------------------
            vCodes(1) = vCodes2(4)
            vCodes(2) = vCodes2(3)
            vCodes(3) = vCodes2(5)
            vCodes(4) = vCodes2(6)
            vCodes(5) = vCodes2(1)
            vCodes(6) = vCodes2(2)
            
    Case 6  '------------------------
            ' 1 ' 4 ' 3 ' 5 ' 6 ' 2 '
            '------------------------
            vCodes(1) = vCodes2(1)
            vCodes(2) = vCodes2(4)
            vCodes(3) = vCodes2(3)
            vCodes(4) = vCodes2(5)
            vCodes(5) = vCodes2(6)
            vCodes(6) = vCodes2(2)
  End Select
  
  strCode = ""
  For i = 1 To UBound(vCodes)
    strCode = strCode & m_vChars(vCodes(i))
  Next

  pGetCode = strCode
End Function

Private Sub pGetEmpresasUsuariosYVto(ByVal strCode As String, ByRef Empresas As Long, ByRef Usuarios As Long, ByRef Vto As Date)
  Dim vCodes2(13)  As Long
  Dim vCodes(7)    As Long
  Dim i            As Long
  
  ' Para obtener k
  Dim k            As Long
  Dim strCode2     As String
  Dim vDummy(6)    As Long
  
  strCode2 = GetMACAddressInText(GetMACAddress(0))
  
  ' Si no hay Mac Address salgo con 100 empresas y con
  ' 100 usuarios por que si no hay Mac Address no
  ' hay red y lo mas probable es que se trate de
  ' mi Notebook desconectada en alguna demo
  ' como ya me paso antes jijijiji!!!!!
  If strCode2 = "" Then
    Empresas = 100
    Usuarios = 100
    Vto = #1/1/3000#
    Exit Sub
  End If
  
  k = GetSumCode(strCode2, vDummy)
  
  ' Ahora obtengo el vector con el codigo recibido y lo
  ' luego lo transformo
  GetSumCode strCode, vCodes2, 13
  
  ' Transformo el vector
  Select Case k
    Case 1  '------------------------
            ' 13 ' 2 ' 6 ' 8 ' 9 ' 3 '
            '------------------------
            vCodes(1) = vCodes2(1)
            vCodes(2) = vCodes2(4)
            vCodes(3) = vCodes2(5)
            vCodes(4) = vCodes2(7)
            vCodes(5) = vCodes2(10)
            vCodes(6) = vCodes2(11)
            vCodes(7) = vCodes2(12)
            
    Case 2  '------------------------
            ' 6 ' 11 ' 5 ' 1 ' 8 ' 2 '
            '------------------------
            vCodes(1) = vCodes2(3)
            vCodes(2) = vCodes2(4)
            vCodes(3) = vCodes2(7)
            vCodes(4) = vCodes2(9)
            vCodes(5) = vCodes2(10)
            vCodes(6) = vCodes2(12)
            vCodes(7) = vCodes2(13)
                        
    Case 3  '------------------------
            ' 12 ' 7 ' 1 ' 3 ' 9 ' 5 '
            '------------------------
            vCodes(1) = vCodes2(2)
            vCodes(2) = vCodes2(4)
            vCodes(3) = vCodes2(6)
            vCodes(4) = vCodes2(8)
            vCodes(5) = vCodes2(10)
            vCodes(6) = vCodes2(11)
            vCodes(7) = vCodes2(13)
            
    Case 4  '------------------------
            ' 7 ' 1 ' 2 ' 10 ' 3 ' 12 '
            '------------------------
            vCodes(1) = vCodes2(4)
            vCodes(2) = vCodes2(5)
            vCodes(3) = vCodes2(6)
            vCodes(4) = vCodes2(8)
            vCodes(5) = vCodes2(9)
            vCodes(6) = vCodes2(11)
            vCodes(7) = vCodes2(13)
    
    Case 5  '------------------------
            ' 5 ' 10 ' 13 ' 3 ' 8 ' 6 '
            '------------------------
            vCodes(1) = vCodes2(1)
            vCodes(2) = vCodes2(2)
            vCodes(3) = vCodes2(4)
            vCodes(4) = vCodes2(7)
            vCodes(5) = vCodes2(9)
            vCodes(6) = vCodes2(11)
            vCodes(7) = vCodes2(12)
    
    Case 6  '------------------------
            ' 11 ' 1 ' 3 ' 7 ' 4 ' 13 '
            '------------------------
            vCodes(1) = vCodes2(2)
            vCodes(2) = vCodes2(5)
            vCodes(3) = vCodes2(6)
            vCodes(4) = vCodes2(8)
            vCodes(5) = vCodes2(9)
            vCodes(6) = vCodes2(10)
            vCodes(7) = vCodes2(12)
  End Select
  
  Empresas = vCodes(1) * 10 + vCodes(2)
  Usuarios = vCodes(3) * 100 + vCodes(4) * 10 + vCodes(5)
  
  Vto = DateAdd("m", 1, DateSerial(2000 + vCodes(7) - k, vCodes(6) - k, 1))
End Sub

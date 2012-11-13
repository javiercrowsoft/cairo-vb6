Attribute VB_Name = "mGetCodigo"
Option Explicit

Public Const c_strChar = " ,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,1,2,3,4,5,6,7,8,9,0"
Public m_vChars() As String

Public Function GetMACAddressInText(ByVal strMacAdress As String) As String
  
  If strMacAdress = "" Then Exit Function
  
  m_vChars = Split(c_strChar, ",")
  
  GetMACAddressInText = pGetCode(pGetChar(strMacAdress, 0), _
                                 pGetChar(strMacAdress, 1), _
                                 pGetChar(strMacAdress, 2), _
                                 pGetChar(strMacAdress, 3), _
                                 pGetChar(strMacAdress, 4), _
                                 pGetChar(strMacAdress, 5))
End Function

Private Function pGetCode(ByVal Code1 As Long, _
                          ByVal Code2 As Long, _
                          ByVal Code3 As Long, _
                          ByVal Code4 As Long, _
                          ByVal Code5 As Long, _
                          ByVal Code6 As Long) As String
  Dim vCodeRslt(6)  As Long
  Dim vCode(6)      As Long
  Dim Code       As Long
  Dim Resto      As Long
  Dim i          As Long
  Dim q          As Long
  Dim rtn        As String
  
  vCode(1) = Code1
  vCode(2) = Code2
  vCode(3) = Code3
  vCode(4) = Code4
  vCode(5) = Code5
  vCode(6) = Code6
  
  i = 1
  For q = 1 To 6
    If vCode(i) < 62 Then
      vCodeRslt(q) = vCode(i)
    Else
      vCodeRslt(q) = vCode(i) Mod 62
    End If
    i = i + 1
  Next
  
  pSort vCodeRslt
  
  Dim z As Long
  Dim v(3) As String
  
  v(1) = "*"
  v(2) = "-"
  v(3) = "+"
  
  z = 1
  
  For q = 1 To 6
    If vCodeRslt(q) = 0 Then
      If z > 3 Then z = 1
      rtn = rtn & v(z)
      z = z + 1
    Else
      rtn = rtn & Trim(m_vChars(vCodeRslt(q)))
    End If
  Next
  
  pGetCode = rtn
End Function

Private Sub pSort(ByRef vCodeRslt() As Long)
  Dim k As Long
  Dim i As Long
  Dim n As Long
  
  For i = 1 To UBound(vCodeRslt)
    k = k + Val(vCodeRslt(i))
  Next
  
  k = Val(Right$(Trim(k), 1))
  If k > 6 Then k = k Mod 6
  
  For i = 1 To UBound(vCodeRslt)
    n = vCodeRslt(i)
    If i + k < 6 Then
      vCodeRslt(i) = vCodeRslt(i + k)
      vCodeRslt(i + k) = n
    Else
      vCodeRslt(i) = vCodeRslt(i + k - 6)
      vCodeRslt(i + k - 6) = n
    End If
  Next
End Sub

Private Function pGetChar(ByVal strMacAdress As String, ByVal idx As Long) As Long
  Dim vChars As Variant
  vChars = Split(strMacAdress, " ")
  pGetChar = pHexaToDec(vChars(idx))
End Function

Private Function pHexaToDec(ByVal strHex As String) As Long
  Dim rtn As Long
  Dim i   As Long
  Dim q   As Long
  
  For i = Len(strHex) To 1 Step -1
    rtn = rtn + (pGetHexaToDecAux(Mid(strHex, i, 1)) * 16 ^ q)
    q = q + 1
  Next
  
  pHexaToDec = rtn
End Function

Private Function pGetHexaToDecAux(ByVal strDigitHex As String) As Long
  Select Case LCase(strDigitHex)
    Case "1", "2", "3", "4", "5", "6", "7", "8", "9", "0"
      pGetHexaToDecAux = Val(strDigitHex)
    Case "a"
      pGetHexaToDecAux = 10
    Case "b"
      pGetHexaToDecAux = 11
    Case "c"
      pGetHexaToDecAux = 12
    Case "d"
      pGetHexaToDecAux = 13
    Case "e"
      pGetHexaToDecAux = 14
    Case "f"
      pGetHexaToDecAux = 15
  End Select
End Function


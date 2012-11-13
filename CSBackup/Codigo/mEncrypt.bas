Attribute VB_Name = "mEncrypt"
Option Explicit

Public Function EncryptData(ByVal data As String, _
                            ByVal Password As String) As String
  
  If LenB(data) = 0 Then
    EncryptData = vbNullString
    Exit Function
  End If
  
  Dim sPlain As String

  sPlain = data

  Dim lLength     As Long
  Dim bytIn()     As Byte
  Dim lCount      As Long
  
  lLength = Len(sPlain)
  ReDim bytIn(lLength - 1)
  For lCount = 1 To lLength
      bytIn(lCount - 1) = CByte(AscB(Mid(sPlain, lCount, 1)))
  Next

  If Len(Password) Then

    Dim bytPassword() As Byte
    
    lLength = Len(Password)
    ReDim bytPassword(lLength - 1)
    For lCount = 1 To lLength
        bytPassword(lCount - 1) = CByte(AscB(Mid(Password, lCount, 1)))
    Next
    
    Dim bytOut()      As Byte
    Dim oRijndael     As cRijndael
    Set oRijndael = New cRijndael
    
    bytOut = oRijndael.EncryptData(bytIn, bytPassword)
  
    Dim sTemp As String
      
    sTemp = ""
    For lCount = 0 To UBound(bytOut)
        sTemp = sTemp & Right("0" & Hex(bytOut(lCount)), 2)
    Next
    
    EncryptData = sTemp
  
  Else
    EncryptData = data
  End If
  
End Function

Public Function DecryptData(ByVal data As String, _
                            ByVal Password As String) As String

  If LenB(data) Then
  
    Dim sPlain

    sPlain = data

    Dim lLength       As Long
    Dim bytIn()       As Byte
    Dim lCount        As Long
  
    lLength = Len(sPlain)
    ReDim bytIn(lLength / 2 - 1)
    For lCount = 1 To lLength / 2
        bytIn(lCount - 1) = Val("&H" & Mid(sPlain, lCount * 2 - 1, 2))
    Next

    If Len(Password) Then

      Dim bytPassword() As Byte
    
      lLength = Len(Password)
      ReDim bytPassword(lLength - 1)
      For lCount = 1 To lLength
          bytPassword(lCount - 1) = CByte(AscB(Mid(Password, lCount, 1)))
      Next
  
      Dim bytClear()    As Byte
      Dim oRijndael     As cRijndael
      Set oRijndael = New cRijndael
  
      bytClear = oRijndael.DecryptData(bytIn, bytPassword)
      
      lLength = UBound(bytClear) + 1
  
      Dim sTemp         As String
  
      sTemp = ""
      For lCount = 0 To lLength - 1
          sTemp = sTemp & Chr(bytClear(lCount))
      Next
    
      DecryptData = sTemp
    
    Else
      
      DecryptData = data
    
    End If

  Else

    DecryptData = ""
  End If
  
End Function

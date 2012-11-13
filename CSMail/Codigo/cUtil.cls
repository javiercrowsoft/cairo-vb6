VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cUtil"
Attribute VB_GlobalNameSpace = True
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Public Function GeneratePassword(ByVal allowNumbers As Boolean) As String
  
  Const NUMLOWER = 48     ' 48 = 0
  Const NUMUPPER = 57     ' 57 = 9
  Const LOWERBOUND = 65   ' 65 = A
  Const UPPERBOUND = 90   ' 90 = Z
  Const LOWERBOUND1 = 97  ' 97 = a
  Const UPPERBOUND1 = 122 ' 122 = z
  Const PASSWORD_LENGTH = 6
  
  Dim newPassword As String
  Dim Count       As Long
  Dim pwd         As Long
  
  ' initialize the random number generator
  Randomize
  
  newPassword = ""
  Count = 0
  Do Until Count = PASSWORD_LENGTH
    If allowNumbers Then
      pwd = Int((NUMUPPER - NUMLOWER) * Rnd + NUMLOWER)
    Else
      ' generate a num between 2 and 10 ;
      ' if num > 4 create an uppercase else create lowercase
      If Int((10 - 2 + 1) * Rnd + 2) > 4 Then
        pwd = Int((UPPERBOUND - LOWERBOUND + 1) * Rnd + LOWERBOUND)
      Else
        pwd = Int((UPPERBOUND1 - LOWERBOUND1 + 1) * Rnd + LOWERBOUND1)
      End If
    End If
    
    newPassword = newPassword + Chr(pwd)
    
    Count = Count + 1
  Loop
  
  GeneratePassword = newPassword
End Function

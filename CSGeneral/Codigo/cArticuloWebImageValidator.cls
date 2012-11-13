VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cImageValidator"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Public Function ValidateImage(ByVal full_path_image As String) As Boolean
  On Error Resume Next
  
  Dim Image As String
  
  Image = Dir(full_path_image)
  
  If Image <> "" Then
    ValidateImage = True
  Else
    ValidateImage = False
  End If

End Function


VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "TextLine"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Attribute VB_Ext_KEY = "SavedWithClassBuilder6" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
'local variable(s) to hold property value(s)
Option Explicit
Private mvarText As String 'local copy
Private Content As Collection
Public Event Word(Word As TextWord, NewLine As Boolean)
Public Property Let Text(ByVal vData As String)

   mvarText = vData
   Dim Strings() As String
   Dim Commands() As String
   Dim Words() As String
   Dim Tabs() As String
   Dim tmp As TextWord
   Dim i As Long
   Dim j As Long
   Dim k As Long
   Dim l As Long
   Dim key As Boolean
   Dim newContent As New Collection
   Dim oldColor As Long
   Dim oldString As String
   Dim oldWord As TextWord
   RaiseEvent Word(Nothing, True)
   Strings = Split(Text, Chr(34)) 'odd is string
   Set Content = New Collection
   For i = 0 To UBound(Strings)
      If i And 1 Then   '-------------------parse strings
         Set tmp = New TextWord
         tmp.Color = vbWhite
         tmp.Word = Chr(34) + Strings(i)
         Content.Add tmp
      Else
      If i > 0 Then tmp.Word = tmp.Word + Chr(34)
         Commands = Split(Strings(i), ":")  '------------------parse commands
         For j = 0 To UBound(Commands)
            If j > 0 Then
            Set tmp = New TextWord
            tmp.Word = ":"
            tmp.Color = vbBlack
            Content.Add tmp
            End If
            Tabs = Split(Commands(j), vbTab)

            For k = 0 To UBound(Tabs)
               If k > 0 Then tmp.Word = tmp.Word + vbTab
               Words = Split(Tabs(k), " ")
               For l = 0 To UBound(Words)
                  If l > 0 Then tmp.Word = tmp.Word + " "
                  Set tmp = New TextWord
                  tmp.Color = vbBlack
                  tmp.Word = Words(l)
                  tmp.KeyWord = False
                  RaiseEvent Word(tmp, False)
                  Content.Add tmp
               Next
               If UBound(Words) = -1 Then
                  Set tmp = New TextWord
                  Content.Add tmp
               End If


            Next

         Next
      End If
   Next

   For i = 1 To Content.Count
      Set tmp = Content.Item(i)
      If (tmp.Color <> oldColor Or i = 1) And tmp.Word <> "" Then
         Set oldWord = New TextWord
         oldString = tmp.Word
         oldColor = tmp.Color
         oldWord.Color = oldColor
         oldWord.Word = oldString
         newContent.Add oldWord
      Else
         oldString = oldString + tmp.Word
         oldWord.Word = oldString
         If tmp.KeyWord = True Then oldWord.KeyWord = True
      End If
   Next
   Set Content = newContent
   mvarText = ""
   For i = 1 To Content.Count
      Set tmp = Content(i)
      mvarText = mvarText + tmp.Word
   Next
End Property


Public Property Get Text() As String
Attribute Text.VB_UserMemId = 0
    Text = mvarText
End Property

Public Property Get Count() As Long

   Count = Content.Count
End Property

Public Property Get Word(index As Long) As TextWord
   Set Word = Content(index)
End Property

Private Sub Class_Initialize()
Set Content = New Collection
End Sub

Public Sub Parse()

End Sub

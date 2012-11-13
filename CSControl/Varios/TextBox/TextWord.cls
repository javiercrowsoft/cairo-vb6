VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "TextWord"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Attribute VB_Ext_KEY = "SavedWithClassBuilder6" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Option Explicit

'local variable(s) to hold property value(s)
Private mvarWord As String 'local copy
Private mvarColor As Long 'local copy
'local variable(s) to hold property value(s)
Private mvarKeyWord As Boolean 'local copy
Public Property Let KeyWord(ByVal vData As Boolean)
'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.KeyWord = 5
    mvarKeyWord = vData
End Property


Public Property Get KeyWord() As Boolean
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.KeyWord
    KeyWord = mvarKeyWord
End Property



Public Property Let Color(ByVal vData As Long)
'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.Color = 5
    mvarColor = vData
End Property


Public Property Get Color() As Long
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.Color
    Color = mvarColor
End Property



Public Property Let Word(ByVal vData As String)
'used when assigning a value to the property, on the left side of an assignment.
'Syntax: X.Word = 5
    mvarWord = vData
End Property


Public Property Get Word() As String
'used when retrieving value of a property, on the right side of an assignment.
'Syntax: Debug.Print X.Word
    Word = mvarWord
End Property




VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cCharacterRange"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

' ==================================================================================
' cCharacterRange.cls
' Copyright © 2003 Genghis Khan(GuangJian Guo)
' Website: http://www.itkhan.com
'
' from GdiplusTypes.h:Microsoft Platform SDK February 2003
'
' A CharacterRange object specifies a range of character positions within a string.
' ==================================================================================

Private m_lngFirst As Long
Private m_lngLength As Long

Public Sub Create(ByVal lFirst As Long, ByVal lLength As Long)
    m_lngFirst = lFirst: m_lngLength = lLength
End Sub

Public Function CreateFromType(ByRef uRange As CharacterRange)
    With uRange
         m_lngFirst = .First: m_lngLength = .Length
    End With
End Function

' sets this CharacterRange object equal to the specified CharacterRange object.
Public Function Equal(ByVal rhs As cCharacterRange) As cCharacterRange
    m_lngFirst = rhs.First
    m_lngLength = rhs.Length
    Set Equal = Me
End Function

Public Property Get First() As Long
    First = m_lngFirst
End Property

Public Property Let First(ByVal NewValue As Long)
    m_lngFirst = NewValue
End Property

Public Property Get Length() As Long
    Length = m_lngLength
End Property

Public Property Let Length(ByVal NewValue As Long)
    m_lngLength = NewValue
End Property

Public Function ToType() As CharacterRange
    With ToType
         .First = m_lngFirst
         .Length = m_lngLength
    End With
End Function

Private Sub Class_Initialize()
    m_lngFirst = 0: m_lngLength = 0
End Sub

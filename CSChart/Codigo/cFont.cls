VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cFont"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'/////////////////////////////////////////////////////////////////////////////////////////
' CopyRight © 2003-2005 Javier Alvarez (javier@crowsoft.com.ar)

' This library is free software; you can redistribute it and/or modify
' it under the terms of the GNU Lesser Gereral Public Licence as published
' by the Free Software Foundation; either version 2 of the Licence,
' or (at your opinion) any later version.

' This library is distributed in the hope that it will be usefull,
' but WITHOUT ANY WARRANTY; without even the implied warranty of merchantability
' or fitness for a particular purpose. See the GNU Lesser General Public Licence
' for more details.

' You should have received a copy of the GNU Lesser General Public Licence
' along with this library; if not, write to the Free Software Foundation, Inc.,
' 59 Temple Place, Suite 330, Boston, Ma 02111-1307 USA.

' Visit CrowSoft.
'    http://www.crowsoft.com.ar
'/////////////////////////////////////////////////////////////////////////////////////////

Public Enum eFontStyle
        Regular = 0
        Bold = 1
        Italic = 2
        BoldItalic = 3
        Strikeout = 4
        Underline = 8
End Enum

Private m_Name                          As String
Private m_Size                          As Single
Private m_FontStyle                     As eFontStyle
Private m_Font                          As GpGDIPlus.cFont

Public Property Get Name() As String
   Name = m_Name
End Property

Public Property Let Name(ByVal rhs As String)
   m_Name = rhs
End Property

Public Property Get Size() As Single
   Size = m_Size
End Property

Public Property Let Size(ByVal rhs As Single)
   m_Size = rhs
End Property

Public Property Get FontStyle() As eFontStyle
   FontStyle = m_FontStyle
End Property

Public Property Let FontStyle(ByVal rhs As eFontStyle)
   m_FontStyle = rhs
End Property

Public Property Get Font() As GpGDIPlus.cFont
  Set Font = m_Font
End Property

Public Sub Dispose()
  m_Font.DisposeFont
End Sub

Public Sub NewFont(ByVal Name As String, _
                   ByVal Size As Single, _
                   Optional ByVal FontStyle As eFontStyle = eFontStyle.Regular)
    m_Name = "Tahoma"
    m_Size = Size
    m_FontStyle = FontStyle
    
    m_Font.Create m_Name, Size, FontStyle
End Sub

Private Sub Class_Initialize()
  Set m_Font = New GpGDIPlus.cFont
End Sub

Private Sub Class_Terminate()
  Dispose
  Set m_Font = Nothing
End Sub

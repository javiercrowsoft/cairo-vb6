VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cExcel"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cExcel
' 29-02-2008

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cExcel"

' estructuras
' variables privadas
Private m_xlApp   As Object
Private m_xlBook  As Object
Private m_xlSheet As Object

Private m_bOpen   As Boolean
Private m_File    As String

Private m_CurrentSheet  As Long
Private m_Row           As Long

' eventos
' propiedades publicas
' propiedades friend
' propiedades privadas
' funciones publicas

Public Function CreateDocument() As Boolean
  
  On Error GoTo ControlError
  
  If m_bOpen Then
    
    CreateDocument = True
    
  Else
  
    ' Creo un objeto aplicación excel
    Set m_xlApp = CreateObject("Excel.Application")
    
    ' Agrego un libro
    Set m_xlBook = m_xlApp.Workbooks.Add
    
    ' Obtengo una hoja
    m_CurrentSheet = 1
    Set m_xlSheet = m_xlBook.Worksheets(m_CurrentSheet)
    
    m_Row = 1
    
    m_bOpen = True
    
    CreateDocument = True
  
  End If
  
  GoTo ExitProc
ControlError:
  
  MngError_ Err, "CreateDocument", C_Module, vbNullString
  
  If Err.Number Then
  
    Set m_xlApp = Nothing
    Set m_xlBook = Nothing
    Set m_xlSheet = Nothing
  
    Resume ExitProc
  End If
  
ExitProc:
  On Error Resume Next
End Function

Public Function WriteRow(ByVal s As String, _
                         Optional ByVal delimiter As String = ",") As Boolean

  On Error GoTo ControlError
  
  If Not m_bOpen Then Exit Function
  
  Dim vData As Variant
  Dim i     As Integer
  
  vData = Split(s, delimiter)
  
  For i = 0 To UBound(vData)
  
    If IsDate(vData(i)) And Not IsNumeric(vData(i)) Then
      If Len(vData(i)) > 10 Then
        m_xlSheet.Cells(m_Row, i + 1) = Format(vData(i), "mm/dd/yyyy hh:nn:ss")
      Else
        m_xlSheet.Cells(m_Row, i + 1) = Format(DateValue(vData(i)), "mm/dd/yyyy")
      End If
    Else
      m_xlSheet.Cells(m_Row, i + 1) = Replace(vData(i), vbCrLf, vbLf)
    End If
  
  Next
  
  m_Row = m_Row + 1
  
  WriteRow = True

  GoTo ExitProc
ControlError:
  MngError_ Err, "WriteRow", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Public Function ShowDoc() As Boolean

  On Error GoTo ControlError

  If Not m_bOpen Then Exit Function
  
  m_xlApp.Visible = True

  ShowDoc = True
  
  GoTo ExitProc
ControlError:
  MngError_ Err, "ShowDoc", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

' funciones friend
' funciones privadas

' construccion - destruccion
Private Sub Class_Terminate()
  On Error GoTo ControlError
  
  Set m_xlSheet = Nothing
  Set m_xlBook = Nothing
  Set m_xlApp = Nothing
  
  m_bOpen = False
  
  GoTo ExitProc
ControlError:
  MngError_ Err, "pCreateDocument", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

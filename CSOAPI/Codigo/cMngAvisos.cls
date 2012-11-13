VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cMngAvisos"
Attribute VB_GlobalNameSpace = True
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cMngAvisos
' 06-01-2004

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cMngAvisos"

Public Enum csExplorerBarItemTypes
   cseItemLink
   cseItemText
   cseItemControlPlaceHolder
End Enum
' estructuras
' variables privadas
' eventos
' propiedades publicas
Public Function AvisoClearBars() As Boolean
  AvisoClearBars = gMngAvisos.Clear
End Function

Public Function AvisoAddBar(ByVal Key As String, _
                       ByVal Title As String, _
                       ByVal IconKey As String, _
                       ByVal IsSpecial As Boolean, _
                       ByVal ToolTipText As String, _
                       ByRef WatermarkPicture As StdPicture) As Boolean
                       
  AvisoAddBar = gMngAvisos.AddBar(Key, Title, IconKey, IsSpecial, ToolTipText, WatermarkPicture)
End Function

Public Function AvisoAddItem(ByVal BarKey As String, _
                   ByVal ItemKey As String, _
                   ByVal Text As String, _
                   ByVal IconKey As String, _
                   ByVal ItemType As csExplorerBarItemTypes, _
                   ByVal ToolTipText As String, _
                   ByVal ClientId As Long) As Boolean
  AvisoAddItem = gMngAvisos.AddItem(BarKey, ItemKey, Text, IconKey, ItemType, ToolTipText, ClientId)
End Function

Public Function AvisoInit(ByRef exbrMain As Object, _
                          ByRef ilsIcons As Object, _
                          ByRef ilsTitleIcons As Object) As Boolean
  On Error GoTo ControlError

  If gMngAvisos Is Nothing Then Set gMngAvisos = New cMngAvisos_
  
  With gMngAvisos
    Set .ilsIcons = ilsIcons
    Set .ilsTitleIcons = ilsTitleIcons
    Set .exbrMain = exbrMain
  End With
  
  AvisoInit = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "AvisoInit", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Public Function AvisoTerminate() As Boolean
  On Error GoTo ControlError

  If Not gMngAvisos Is Nothing Then

    gMngAvisos.Clear
    Set gMngAvisos.ilsIcons = Nothing
    Set gMngAvisos.ilsTitleIcons = Nothing
    Set gMngAvisos.exbrMain = Nothing
    Set gMngAvisos = Nothing
    
    On Error Resume Next
    Dim fCtrls      As cfControls
    Unload fCtrls.Controls
  End If
  
  AvisoTerminate = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "AvisoTerminate", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Public Function AvisoAddSmallImage(ByRef ilsImage As Object, ByVal Index As Long) As Boolean
  AvisoAddSmallImage = gMngAvisos.AddSmallImage(ilsImage, Index)
End Function

Public Function AvisoAddImage(ByRef ilsImage As Object, ByVal Index As Long) As Boolean
  AvisoAddImage = gMngAvisos.AddImage(ilsImage, Index)
End Function

Public Function AvisoAddSmallListImages(ByRef ilsImage As Object) As Boolean
  On Error GoTo ControlError

  AvisoAddSmallListImages = gMngAvisos.AddSmallListImages(ilsImage)
  
  GoTo ExitProc
ControlError:
  MngError Err, "AvisoAddSmallListImages", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Public Function AvisoAddListImages(ByRef ilsImage As Object) As Boolean
  On Error GoTo ControlError

  AvisoAddListImages = gMngAvisos.AddListImages(ilsImage)
  
  GoTo ExitProc
ControlError:
  MngError Err, "AvisoAddListImages", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function
' propiedades friend
' propiedades privadas
' funciones publicas
' funciones friend
' funciones privadas
' construccion - destruccion

'//////////////////////////////
'  Codigo estandar de errores
'  On Error GoTo ControlError
'
'  GoTo ExitProc
'ControlError:
'  MngError err,"", C_Module, ""
'  If Err.Number Then Resume ExitProc
'ExitProc:
'  On Error Resume Next



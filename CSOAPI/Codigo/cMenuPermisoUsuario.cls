VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cMenuPermisoUsuario"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSMenu.cIMenuClient

Private Function cIMenuClient_Initialize(F As Object, Host As CSMenu.cIMenuHost) As Boolean
  On Error GoTo ControlError
  Dim str_2758  As String
  
  str_2758 = LNGGetText(2758, vbNullString)   '&Usuarios
  
  Host.Server.AddMenu C_MenuCfgEmpresa, csMenuCfgEmpresa, C_MenuConfig, 0, True, False, False, False, True, Nothing
  Host.Server.AddMenu str_2758, csMenuCfgUsuario, C_MenuCfgEmpresa, 0, True, False, False, False, True, Nothing
  Host.Server.AddMenu LNGGetText(2757, vbNullString), csPreOAltaPermiso, str_2758, 0, True, False, False, False, False, Nothing, 2
                      '&Permisos
  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, "cIMenuClient_Initialize", "cMenuPermisoUsuario", vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal Id As Long) As Variant
End Function


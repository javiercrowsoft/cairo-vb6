VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 3  'UsesTransaction
END
Attribute VB_Name = "cArticulo"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cArticulo
' 21-04-2004

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "CSWebDataBase.Articulo"

Private m_dbh As cDBHelper
' estructuras
' variables privadas
' eventos
' propiedades publicas
' propiedades friend
' propiedades privadas
' funciones publicas
Public Function Update(ByVal wart_id As Long, _
                       ByVal wart_titulo As String, _
                       ByVal wart_copete As String, _
                       ByVal wart_texto As String, _
                       ByVal wart_origen As String, _
                       ByVal wart_origenURL As String, _
                       ByVal wart_fecha As Date, _
                       ByVal wart_fechavto As Date, _
                       ByVal wart_imagen As String, _
                       ByVal wartt_id As Long, _
                       ByVal us_id As Long) As Long
          
  On Error GoTo ControlError
  
  Const c_len_param  As Long = 8000
  
  Dim ParamTexto(10) As String
  Dim i              As Long
  
  For i = 0 To 9
    If LenB(wart_texto) < (1 + (c_len_param * i)) Then
      Exit For
    End If
    ParamTexto(i) = Mid$(wart_texto, 1 + (c_len_param * i), c_len_param)
  Next
  
  Update = m_dbh.RunSPReturnInteger("sp_web_ArticuloUpdate", _
                                    mp("@@wart_id", adInteger, 4, wart_id), _
                                    mp("@@wart_titulo", adVarChar, 100, wart_titulo), _
                                    mp("@@wart_copete", adVarChar, 1000, wart_copete), _
                                    mp("@@wart_texto0", adVarChar, 8000, ParamTexto(0)), _
                                    mp("@@wart_texto1", adVarChar, 8000, ParamTexto(1)), _
                                    mp("@@wart_texto2", adVarChar, 8000, ParamTexto(2)), _
                                    mp("@@wart_texto3", adVarChar, 8000, ParamTexto(3)), _
                                    mp("@@wart_texto4", adVarChar, 8000, ParamTexto(4)), _
                                    mp("@@wart_texto5", adVarChar, 8000, ParamTexto(5)), _
                                    mp("@@wart_texto6", adVarChar, 8000, ParamTexto(6)), _
                                    mp("@@wart_texto7", adVarChar, 8000, ParamTexto(7)), _
                                    mp("@@wart_texto8", adVarChar, 8000, ParamTexto(8)), _
                                    mp("@@wart_texto9", adVarChar, 8000, ParamTexto(9)), _
                                    mp("@@wart_fecha", adDBTimeStamp, 4, wart_fecha), _
                                    mp("@@wart_fechavto", adDBTimeStamp, 4, wart_fechavto), _
                                    mp("@@wart_origen", adVarChar, 255, wart_origen), _
                                    mp("@@wart_origenurl", adVarChar, 255, wart_origenURL), _
                                    mp("@@wart_imagen", adVarChar, 255, wart_imagen), _
                                    mp("@@wartt_id", adInteger, 4, wartt_id), _
                                    mp("@@us_id", adInteger, 4, us_id))
  
  GetObjectContext.SetComplete
  Exit Function
  
ControlError:
  CtxRaiseError C_Module, "Update"
End Function

Public Function GetByID(ByVal wart_id As Long) As ADODB.Recordset
  On Error GoTo ControlError
  
  Set GetByID = m_dbh.RunSPReturnRS("sp_web_ArticuloGetByID", _
                                    mp("@@wart_id", adInteger, 4, wart_id))
     
  GetObjectContext.SetComplete
  Exit Function
      
ControlError:
  CtxRaiseError C_Module, "GetByID"
End Function

Public Function GetArticulos(ByVal us_id As Long) As ADODB.Recordset
  On Error GoTo ControlError
  
  Set GetArticulos = m_dbh.RunSPReturnRS("sp_web_ArticuloGet", _
                                         mp("@@us_id", adInteger, 4, us_id))
     
  GetObjectContext.SetComplete
  Exit Function
      
ControlError:
  CtxRaiseError C_Module, "GetArticulos"
End Function

Public Function GetArticulosByUser(ByVal us_id As Long) As ADODB.Recordset
  On Error GoTo ControlError
  
  Set GetArticulosByUser = m_dbh.RunSPReturnRS("sp_web_ArticuloGetByUser", _
                                              mp("@@us_id", adInteger, , us_id))
      
  GetObjectContext.SetComplete
  Exit Function
      
ControlError:
  CtxRaiseError C_Module, "GetArticulosByUser"
End Function

Public Function GetArticulosEx(ByVal wartt_id As Long, _
                             ByVal warte_id As Long, _
                             ByVal wart_fechaDesde As Date, _
                             ByVal wart_fechaHasta As Date, _
                             ByVal us_id As Long) As ADODB.Recordset
  On Error GoTo ControlError
  
  Set GetArticulosEx = m_dbh.RunSPReturnRS("sp_web_ArticuloGetEx", _
                                           mp("@@wartt_id", adInteger, , wartt_id), _
                                           mp("@@warte_id", adInteger, , warte_id), _
                                           mp("@@wart_fechaDesde", adDBTimeStamp, , wart_fechaDesde), _
                                           mp("@@wart_fechaHasta", adDBTimeStamp, , wart_fechaHasta), _
                                           mp("@@us_id", adInteger, , us_id))
      
  GetObjectContext.SetComplete
  Exit Function
      
ControlError:
  CtxRaiseError C_Module, "GetArticulosEx"
End Function

Public Function GetArticulosForEdit(ByVal wartt_id As Long, _
                                    ByVal warte_id As Long, _
                                    ByVal wart_fechaDesde As Date, _
                                    ByVal wart_fechaHasta As Date, _
                                    ByVal wart_titulo As String, _
                                    ByVal wart_copete As String, _
                                    ByVal wart_texto As String, _
                                    ByVal us_id As Long) As ADODB.Recordset
  On Error GoTo ControlError
  
  Set GetArticulosForEdit = m_dbh.RunSPReturnRS("sp_web_ArticuloGetForEdit", _
                                           mp("@@wartt_id", adInteger, , wartt_id), _
                                           mp("@@warte_id", adInteger, , warte_id), _
                                           mp("@@wart_fechaDesde", adDBTimeStamp, , wart_fechaDesde), _
                                           mp("@@wart_fechaHasta", adDBTimeStamp, , wart_fechaHasta), _
                                           mp("@@wart_titulo", adVarChar, 100, wart_titulo), _
                                           mp("@@wart_copete", adVarChar, 255, wart_copete), _
                                           mp("@@wart_texto", adVarChar, 255, wart_texto), _
                                           mp("@@us_id", adInteger, , us_id))
  GetObjectContext.SetComplete
  Exit Function
      
ControlError:
  CtxRaiseError C_Module, "GetArticulosForEdit"
End Function
Public Function ChangeEstado(ByVal wart_id As Long, ByVal warte_id As Long) As Long
  On Error GoTo ControlError
      
  ChangeEstado = m_dbh.RunSPReturnInteger("sp_web_ArticuloChangeEstado", _
                                          mp("@@wart_id", adInteger, 4, wart_id), _
                                          mp("@@warte_id", adInteger, 4, warte_id))
      
  GetObjectContext.SetComplete
  Exit Function
  
ControlError:
  CtxRaiseError C_Module, "ChangeEstado"
End Function

Public Function Delete(ByVal wart_id As Long, ByVal us_id As Long) As Long
  On Error GoTo ControlError
      
  Delete = m_dbh.RunSPReturnInteger("sp_web_ArticuloDelete", _
                                    mp("@@us_id", adInteger, 4, us_id), _
                                    mp("@@wart_id", adInteger, 4, wart_id))
      
  GetObjectContext.SetComplete
  Exit Function
  
ControlError:
  CtxRaiseError C_Module, "Delete"
End Function
' funciones friend
' funciones privadas
' construccion - destruccion
Private Sub Class_Initialize()
  Set m_dbh = CreateObject("CSWebDataBase.cDBHelper")
End Sub

Private Sub Class_Terminate()
  Set m_dbh = Nothing
End Sub

'//////////////////////////////
'  Codigo estandar de errores
'  On Error GoTo ControlError
'
'  GoTo ExitProc
'ControlError:
'  MngError err,"", C_Module, ""
'  If Err.Number <> 0 Then Resume ExitProc
'ExitProc:
'  On Error Resume Next

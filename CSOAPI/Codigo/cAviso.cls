VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cAviso"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSITCPModule.cITCPModule
'--------------------------------------------------------------------------------
' cAviso
' 05-01-2004

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cAviso"

Private Const c_IconAvisoGenerico = "AvisoGenerico"
' estructuras
' variables privadas
Private m_IDInstance      As Long
' eventos
' propiedades publicas
' propiedades friend
' propiedades privadas
' funciones publicas
Private Property Let cITCPModule_IDInstance(ByVal rhs As Long)
  m_IDInstance = rhs
End Property

Private Property Get cITCPModule_IDInstance() As Long
  cITCPModule_IDInstance = m_IDInstance
End Property

Private Function cITCPModule_ProcessMessage(ByVal Message As String) As Boolean
  Select Case Message
    Case c_REFRESH_AVISO
      Refresh
  End Select
End Function

Private Property Get cITCPModule_ProgID() As Long
  cITCPModule_ProgID = csSecAviso
End Property

Public Function DeleteFromClientID(ByVal AVT_ID As Long, _
                                   ByVal Id As String, _
                                   ByVal UsId As Long) As Boolean
  Dim sqlstmt As String
  
  sqlstmt = "delete aviso where" & vbCrLf
  sqlstmt = sqlstmt & "avt_id = " & AVT_ID & vbCrLf
  sqlstmt = sqlstmt & "and id = " & gDB.sqlString(Id) & vbCrLf
  
  If UsId <> csAll Then
    sqlstmt = sqlstmt & "and us_id = " & UsId & vbCrLf
  End If
  
  DeleteFromClientID = gDB.Execute(sqlstmt)
  
  If UsId <> csAll Then
    pNotifySecurity gTCPClient, gClientProcessId, UsId
  End If
End Function

Public Function Delete(ByVal AV_ID As Long) As Boolean
  Dim sqlstmt As String
  Dim rs      As Recordset
  Dim UsId    As Long
  
  sqlstmt = "select us_id from aviso where av_id = " & AV_ID
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  If rs.EOF Then Exit Function
  
  UsId = gDB.ValField(rs.Fields, 0)
  
  sqlstmt = "delete aviso where av_id = " & AV_ID
  Delete = gDB.Execute(sqlstmt)
  
  pNotifySecurity gTCPClient, gClientProcessId, UsId
End Function

Public Function Save(ByVal AV_ID As Long, _
                     ByVal AVT_ID As Long, _
                     ByVal Id As String, _
                     ByVal UsId As Long, _
                     ByVal Descrip As String, _
                     Optional ByVal Leido As Long = -2) As Boolean


  If AV_ID = csNO_ID Then
    AV_ID = pFindID(AVT_ID, Id, UsId)
  End If
  
  Dim register As cRegister
  Set register = New cRegister
  
  register.fieldId = cscAvId
  register.Table = csTAviso
  
  register.Id = AV_ID
  
  register.Fields.Add2 cscAvClientId, Id, csText
  register.Fields.Add2 cscUsId, UsId, csId
  register.Fields.Add2 cscAvDescrip, Descrip, csText
  If Leido <> -2 Then
    register.Fields.Add2 cscAvLeido, Leido, csBoolean
  End If
  register.Fields.Add2 cscAvtId, AVT_ID, csId

  register.Fields.HaveLastUpdate = True
  register.Fields.HaveWhoModify = True
  
  If Not gDB.Save(register, , "Save", C_Module, "Error al grabar el aviso") Then Exit Function

  pNotifySecurity gTCPClient, gClientProcessId, UsId

  Save = True
End Function

Public Function Refresh() As Boolean
  On Error GoTo ControlError
  
  Dim sqlstmt     As String
  Dim rs          As Recordset
  Dim rsInfo      As Recordset
  Dim sKey        As String
  Dim sKeyItem    As String
  Dim AvisoTipo   As cAvisoTipo
  Dim fCtrls      As cfControls
  Dim ctrl        As Object
  
  sqlstmt = "select distinct avisotipo.* from aviso,avisotipo "
  sqlstmt = sqlstmt & " where aviso.avt_id = avisotipo.avt_id"
  sqlstmt = sqlstmt & " and aviso.av_leido = 0"
  sqlstmt = sqlstmt & " order by avt_nombre"
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  Set fCtrls = New cfControls
  Set ctrl = fCtrls.ImgList
  ctrl.ItemKey(1) = c_IconAvisoGenerico
  
  gMngAvisos.AddSmallImage2 1, c_IconAvisoGenerico, fCtrls.ImgHandle(1)
  
  While Not rs.EOF
    sKey = GetKey(ValField(rs.Fields, cscAvtId))
    If pGetBar(sKey) Is Nothing Then
      gMngAvisos.AddBar sKey, _
                        ValField(rs.Fields, cscAvtNombre), _
                        "", True, "", fCtrls.Controls.picRes.Picture
      
      Set AvisoTipo = New cAvisoTipo
      
      With AvisoTipo
        .Id = ValField(rs.Fields, cscAvtId)
        .Nombre = ValField(rs.Fields, cscAvtNombre)
        .ObjetoEdicion = ValField(rs.Fields, cscAvtObjetoEdicion)
        .ObjetoInit = ValField(rs.Fields, cscAvtObjetoInit)
        .SpInfo = ValField(rs.Fields, cscAvtspInfo)
      End With
      
      gMngAvisos.collAvisoTipo.Add AvisoTipo, sKey
    End If
    rs.MoveNext
  Wend
  
  sqlstmt = "select *"
  sqlstmt = sqlstmt & " from aviso where us_id = " & gDB.UserId
  sqlstmt = sqlstmt & " and av_leido = 0"
  sqlstmt = sqlstmt & " order by aviso.avt_id"
  
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  Dim Title     As String
  Dim Descrip   As String
  
  While Not rs.EOF
  
    sKey = GetKey(ValField(rs.Fields, cscAvtId))
    sKeyItem = GetKey(ValField(rs.Fields, cscAvId))
    
    If pGetItem(sKey, sKeyItem) Is Nothing Then
  
      Title = ValField(rs.Fields, cscAvDescrip)
      Descrip = ""
      
      If Title = "" Then
    
        Set AvisoTipo = gMngAvisos.collAvisoTipo(sKey)
      
        With AvisoTipo
          sqlstmt = .SpInfo
          If sqlstmt <> "" Then
            sqlstmt = sqlstmt & " " & ValField(rs.Fields, cscAvClientId)
            If Not gDB.OpenRs(sqlstmt, rsInfo) Then Exit Function
            If Not rsInfo.EOF Then
              Title = gDB.ValField(rsInfo.Fields, 0)
              Descrip = gDB.ValField(rsInfo.Fields, 1)
            End If
          End If
          If Title = "" Then
            Title = .Nombre
          End If
        End With
      End If
      
      gMngAvisos.AddItem sKey, _
                         sKeyItem, _
                         Title, _
                         c_IconAvisoGenerico, cseItemLink, Descrip, _
                         gDB.ValField(rs.Fields, cscAvClientId)
    End If
    rs.MoveNext
  Wend
  
  Dim iBar    As Long
  Dim iItem   As Long
  
  For iBar = 1 To gMngAvisos.exbrMain.Bars.Count
    iItem = 1
    With gMngAvisos.exbrMain.Bars(iBar).Items
      While iItem <= .Count
        
        sKeyItem = .Item(iItem).Key
        rs.Filter = cscAvId & " = " & Val(Mid(sKeyItem, 2))
        
        If rs.EOF Then
          .Remove sKeyItem
        Else
          iItem = iItem + 1
        End If
      Wend
    End With
  Next
  
  Refresh = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "Refresh", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function
' funciones friend
' funciones privadas
Private Function pFindID(ByVal AVT_ID As Long, _
                         ByVal Id As String, _
                         ByVal UsId As Long _
                         ) As Long
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  sqlstmt = "select av_id from aviso "
  sqlstmt = sqlstmt & " where Id = " & gDB.sqlString(Id)
  sqlstmt = sqlstmt & " and avt_id = " & AVT_ID
  sqlstmt = sqlstmt & " and us_id = " & UsId

  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function

  If rs.EOF Then Exit Function
  
  pFindID = gDB.ValField(rs.Fields, 0)
End Function

Private Sub pNotifySecurity(ByRef Client As cTCPIPClient, ByVal ClientProcessId As Long, ByVal UsId As Long)
  Dim Buffer As String
  
  ' Si no hay conexion me voy
  If Client Is Nothing Then Exit Sub
  
  Buffer = UsId
  Buffer = TCPSecurityGetMessage(cTCPSecCommandAviso, ClientProcessId, Buffer)
  Client.SendText Buffer, SRV_ID_SERVER
End Sub

Private Function pGetBar(ByVal Key As String) As cExplorerBar
  On Error Resume Next
  Set pGetBar = gMngAvisos.exbrMain.Bars(Key)
End Function

Private Function pGetItem(ByVal BarKey As String, ByVal ItemKey As String) As cExplorerBarItem
  On Error Resume Next
  Dim Bar As cExplorerBar
  Set Bar = pGetBar(BarKey)
  If Bar Is Nothing Then Exit Function
  Set pGetItem = Bar.Items(ItemKey)
End Function

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



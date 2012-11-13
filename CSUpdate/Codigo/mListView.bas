Attribute VB_Name = "mListView"
Option Explicit

'--------------------------------------------------------------------------------
' fDataBases
' 00-11-2002

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "fDataBases"

Public Const c_key_id         As String = "i"
Public Const c_key_user       As String = "u"
Public Const c_key_pwd        As String = "p"
Public Const c_key_nt         As String = "n"
Public Const c_key_olderpkg   As String = "o"
Public Const c_key_bk         As String = "b"
' estructuras
' variables privadas
' eventos
' propiedadades publicas
' propiedadades friend
' propiedades privadas
' funciones publicas
' funciones friend
Public Function SetGrDataBases(ByRef grDataBase As ListView) As Boolean
  With grDataBase
    .View = lvwReport
    .LabelEdit = lvwManual
    .FullRowSelect = True
    .HideSelection = False
    .Checkboxes = True
    .ListItems.Clear
    .Sorted = False
    
    With .ColumnHeaders
      .Clear
      .Add , , "Empresa", 2500
      .Add , , "Base", 2000
      .Add , , "Server", 2000
      .Add , , "Versión", 1000
    End With
  End With
  
  SetGrDataBases = True
End Function

Public Function ShowDataBases(ByRef grDataBase As ListView, _
                              ByRef vDataBases() As t_Database) As Boolean
  Dim sqlstmt As String
  Dim db      As cDataBase
  Dim rs      As ADODB.Recordset
  Dim iRow    As Long
  Dim Encrypt As cEncrypt
  
  Set Encrypt = New cEncrypt
  
  Set db = GetDataBase
  sqlstmt = "select * from BaseDatos"
  If Not db.OpenRs(sqlstmt, rs) Then Exit Function
  
  grDataBase.ListItems.Clear
  grDataBase.Sorted = False
  
  If Not rs.EOF Then
  
    rs.MoveLast
    rs.MoveFirst
    
    While Not rs.EOF
    
      grDataBase.ListItems.Add
    
      iRow = iRow + 1
      
      pSetId iRow, db.ValField(rs.fields, cscBdId), grDataBase
      pSetEmpresa iRow, Encrypt.Decrypt(db.ValField(rs.fields, cscBdEmpresa), c_LoginSignature), grDataBase
      pSetBase iRow, Encrypt.Decrypt(db.ValField(rs.fields, cscBdNombre), c_LoginSignature), grDataBase
      pSetLogin iRow, Encrypt.Decrypt(db.ValField(rs.fields, cscBdLogin), c_LoginSignature), grDataBase
      pSetServer iRow, Encrypt.Decrypt(db.ValField(rs.fields, cscBdServer), c_LoginSignature), grDataBase
      pSetPassword iRow, Encrypt.Decrypt(db.ValField(rs.fields, cscBdPwd), c_LoginSignature), grDataBase
      pSetSecurityType iRow, db.ValField(rs.fields, cscBdSecuritytype), grDataBase
      
      ' Obtengo la version
      '
      If Not pSetVersion(iRow, grDataBase) Then
        grDataBase.ListItems.Item(iRow).ForeColor = vbRed
      End If
      
      rs.MoveNext
    Wend
    
    If grDataBase.ListItems.Count Then
      grDataBase.ListItems(1).selected = True
    End If
    
    Dim i As Long
    Dim n As Long
    
    For i = 1 To UBound(vDataBases)
      With grDataBase.ListItems
        For n = 1 To .Count
          With .Item(n)
            If vDataBases(i).DataBase = pGetBase(n, grDataBase) _
               And vDataBases(i).server = pGetServer(n, grDataBase) _
               And Val(GetInfoString(.Tag, c_key_olderpkg)) = 0 Then
              .Checked = True
              pSetBackup n, vDataBases(i).bBackup, grDataBase
              Exit For
            End If
          End With
        Next
      End With
    Next
    
    LVSetDataBases grDataBase, vDataBases
  End If
 
  ShowDataBases = True
End Function

Public Function ShowDataBases2(ByRef grDataBase As ListView, _
                               ByRef vDataBases() As t_Database) As Boolean
  Dim i As Long
  Dim n As Long
  
  grDataBase.ListItems.Clear
  grDataBase.Sorted = False
  
  For i = 1 To UBound(vDataBases)
    With vDataBases(i)
            
      grDataBase.ListItems.Add().Checked = .bBackup
      
      pSetId i, .db_id, grDataBase
      pSetEmpresa i, .Empresa, grDataBase
      pSetBase i, .DataBase, grDataBase
      pSetLogin i, .User, grDataBase
      pSetServer i, .server, grDataBase
      pSetPassword i, .Pwd, grDataBase
      pSetSecurityType i, .UseNT, grDataBase
      pSetCol i, 4, .Version, grDataBase

    End With
  Next
  
  If grDataBase.ListItems.Count Then
    grDataBase.ListItems(1).selected = True
  End If
 
  ShowDataBases2 = True
End Function

Public Sub LVSetDataBases(ByRef grDataBase As ListView, _
                          ByRef vDataBases() As t_Database)
  Dim i As Long
  
  ReDim vDataBases(0)
  
  For i = 1 To grDataBase.ListItems.Count
    If grDataBase.ListItems.Item(i).Checked Then
      ReDim Preserve vDataBases(UBound(vDataBases) + 1)
      
      LVGetDatabase grDataBase, _
                    vDataBases(UBound(vDataBases)), _
                    i
    End If
  Next

End Sub

' funciones privadas

Private Function pGetId(ByVal iRow As Long, _
                        ByRef grDataBase As ListView) As Long
  With grDataBase.ListItems.Item(iRow)
    pGetId = Val(GetInfoString(.Tag, c_key_id))
  End With
End Function

Private Function pGetEmpresa(ByVal iRow As Long, _
                             ByRef grDataBase As ListView) As String
  pGetEmpresa = pGetCol(iRow, 1, grDataBase)
End Function

Private Function pGetBase(ByVal iRow As Long, _
                          ByRef grDataBase As ListView) As String
  pGetBase = pGetCol(iRow, 2, grDataBase)
End Function

Private Function pGetServer(ByVal iRow As Long, _
                            ByRef grDataBase As ListView) As String
  pGetServer = pGetCol(iRow, 3, grDataBase)
End Function

Private Function pGetLogin(ByVal iRow As Long, _
                           ByRef grDataBase As ListView) As String
  With grDataBase.ListItems.Item(iRow)
    pGetLogin = GetInfoString(.Tag, c_key_user)
  End With
End Function

Private Function pGetPassword(ByVal iRow As Long, _
                              ByRef grDataBase As ListView) As String
  With grDataBase.ListItems.Item(iRow)
    pGetPassword = GetInfoString(.Tag, c_key_pwd)
  End With
End Function

Private Function pGetSecurityType(ByVal iRow As Long, _
                                  ByRef grDataBase As ListView) As Long
  With grDataBase.ListItems.Item(iRow)
    pGetSecurityType = Val(GetInfoString(.Tag, c_key_nt))
  End With
End Function

Private Function pGetBackup(ByVal iRow As Long, _
                            ByRef grDataBase As ListView) As Boolean
  With grDataBase.ListItems.Item(iRow)
    pGetBackup = Val(GetInfoString(.Tag, c_key_bk))
  End With
End Function

Private Sub pSetId(ByVal iRow As Long, _
                   ByVal rhs As Long, _
                   ByRef grDataBase As ListView)
  With grDataBase.ListItems.Item(iRow)
    .Tag = SetInfoString(.Tag, c_key_id, rhs)
  End With
End Sub

Private Sub pSetEmpresa(ByVal iRow As Long, _
                        ByVal rhs As String, _
                        ByRef grDataBase As ListView)
  pSetCol iRow, 1, rhs, grDataBase
End Sub

Private Sub pSetBase(ByVal iRow As Long, _
                     ByVal rhs As String, _
                     ByRef grDataBase As ListView)
  pSetCol iRow, 2, rhs, grDataBase
End Sub

Private Sub pSetServer(ByVal iRow As Long, _
                       ByVal rhs As String, _
                       ByRef grDataBase As ListView)
  pSetCol iRow, 3, rhs, grDataBase
End Sub

Private Sub pSetLogin(ByVal iRow As Long, _
                      ByVal rhs As String, _
                      ByRef grDataBase As ListView)
  With grDataBase.ListItems.Item(iRow)
    .Tag = SetInfoString(.Tag, c_key_user, rhs)
  End With
End Sub

Private Sub pSetPassword(ByVal iRow As Long, _
                         ByVal rhs As String, _
                         ByRef grDataBase As ListView)
  With grDataBase.ListItems.Item(iRow)
    .Tag = SetInfoString(.Tag, c_key_pwd, rhs)
  End With
End Sub

Private Sub pSetSecurityType(ByVal iRow As Long, _
                             ByVal rhs As String, _
                             ByRef grDataBase As ListView)
  With grDataBase.ListItems.Item(iRow)
    .Tag = SetInfoString(.Tag, c_key_nt, rhs)
  End With
End Sub

Private Sub pSetBackup(ByVal iRow As Long, _
                       ByVal rhs As Boolean, _
                       ByRef grDataBase As ListView)
  With grDataBase.ListItems.Item(iRow)
    .Tag = SetInfoString(.Tag, c_key_bk, CInt(rhs))
  End With
End Sub

Private Function pGetCol(ByVal iRow As Long, _
                         ByVal iCol As Long, _
                         ByRef grDataBase As ListView) As String
  If iCol > 1 Then
    pGetCol = grDataBase.ListItems.Item(iRow).SubItems(iCol - 1)
  Else
    pGetCol = grDataBase.ListItems.Item(iRow).Text
  End If
End Function

Private Sub pSetCol(ByVal iRow As Long, _
                    ByVal iCol As Long, _
                    ByVal rhs As String, _
                    ByRef grDataBase As ListView)
  If iCol > 1 Then
    grDataBase.ListItems.Item(iRow).SubItems(iCol - 1) = rhs
  Else
    grDataBase.ListItems.Item(iRow).Text = rhs
  End If
End Sub

Public Sub LVGetDatabase(ByRef grDataBase As ListView, _
                         ByRef db As t_Database, _
                         Optional ByVal lRow As Long)
 
  If lRow = 0 Then
    lRow = grDataBase.SelectedItem.Index
  End If
  
  If lRow Then
    db.db_id = pGetId(lRow, grDataBase)
    db.server = pGetServer(lRow, grDataBase)
    db.DataBase = pGetBase(lRow, grDataBase)
    db.User = pGetLogin(lRow, grDataBase)
    db.Pwd = pGetPassword(lRow, grDataBase)
    db.UseNT = pGetSecurityType(lRow, grDataBase)
    db.Empresa = pGetEmpresa(lRow, grDataBase)
    db.Version = pGetCol(lRow, 4, grDataBase)
    db.bBackup = pGetBackup(lRow, grDataBase)
  End If
End Sub

Private Function pSetVersion(ByVal iRow As Long, _
                             ByRef grDataBase As ListView) As Boolean
  Dim rs        As ADODB.Recordset
  Dim sqlstmt   As String
  Dim db        As cDataBase
  
  Set db = New cDataBase
  
  If Not db.OpenConnection(pGetServer(iRow, grDataBase), _
                           pGetBase(iRow, grDataBase), _
                           pGetLogin(iRow, grDataBase), _
                           pGetPassword(iRow, grDataBase), _
                           pGetSecurityType(iRow, grDataBase)) Then
                           
    MsgWarning "No fue posible conectarse con : " & vbCrLf & vbCrLf & _
                           "Server " & pGetServer(iRow, grDataBase) & vbCrLf & _
                           "Base " & pGetBase(iRow, grDataBase) & vbCrLf & _
                           "Usuario " & pGetLogin(iRow, grDataBase) & vbCrLf & _
                           "Clave " & pGetPassword(iRow, grDataBase) & vbCrLf & _
                           "Seguridad Integrada: " & pGetSecurityType(iRow, grDataBase)
    Exit Function
  End If


  sqlstmt = "sp_cfg_getvalor 'Base Datos','Version',0,1"

  db.OpenRs sqlstmt, rs
  
  Dim dbVersion  As String
  Dim dbVerMax   As Long
  Dim dbVerMin   As Long
  Dim dbVerRev   As Long
  Dim dbVerRev2  As Long
  
  Dim pkgVersion  As String
  Dim pkgVerMax   As Long
  Dim pkgVerMin   As Long
  Dim pkgVerRev   As Long
  Dim pkgVerRev2  As Long
  
  Dim pkgDBVersion  As String
  Dim pkgDBVerMax   As Long
  Dim pkgDBVerMin   As Long
  Dim pkgDBVerRev   As Long
  Dim pkgDBVerRev2  As Long
  
  Dim bOldVersion As Boolean
  
  dbVersion = db.ValField(rs.fields, 0)
  
  pSetCol iRow, 4, dbVersion, grDataBase
  
  dbVerMax = pGetVersion(dbVersion, 0)
  dbVerMin = pGetVersion(dbVersion, 1)
  dbVerRev = pGetVersion(dbVersion, 2)
  dbVerRev2 = pGetVersion(dbVersion, 3)
  
  pkgVersion = g_SetupCfg.Version
  pkgVerMax = pGetVersion(pkgVersion, 0)
  pkgVerMin = pGetVersion(pkgVersion, 1)
  pkgVerRev = pGetVersion(pkgVersion, 2)
  pkgVerRev2 = pGetVersion(pkgVersion, 3)
  
  pkgDBVersion = g_SetupCfg.DB_MIN_Version
  pkgDBVerMax = pGetVersion(pkgDBVersion, 0)
  pkgDBVerMin = pGetVersion(pkgDBVersion, 1)
  pkgDBVerRev = pGetVersion(pkgDBVersion, 2)
  pkgDBVerRev2 = pGetVersion(pkgDBVersion, 3)
  
  dbVersion = Format(dbVerMax, "00000") & "." & _
              Format(dbVerMin, "00000") & "." & _
              Format(dbVerRev, "00000") & "." & _
              Format(dbVerRev2, "00000")

  pkgVersion = Format(pkgVerMax, "00000") & "." & _
               Format(pkgVerMin, "00000") & "." & _
               Format(pkgVerRev, "00000") & "." & _
               Format(pkgVerRev2, "00000")

  pkgDBVersion = Format(pkgDBVerMax, "00000") & "." & _
                 Format(pkgDBVerMin, "00000") & "." & _
                 Format(pkgDBVerRev, "00000") & "." & _
                 Format(pkgDBVerRev2, "00000")


  bOldVersion = dbVersion > pkgVersion _
             Or dbVersion < pkgDBVersion
  
  If bOldVersion Then
  
    fMain.ShowMsgTop "Existen bases que estan " & _
                     "en una version superior al " & _
                     "paquete de actualización", True
  
    With grDataBase.ListItems.Item(iRow)
      .ForeColor = vbRed
      .Tag = SetInfoString(.Tag, c_key_olderpkg, 1)
    End With
  End If
  
  pSetVersion = True
End Function

Private Function pGetVersion(ByVal Value As String, _
                             ByVal idx As Integer) As Long
                             
  Dim i   As Integer
  Dim q   As Integer
  Dim rtn As String
  Dim c   As String
  
  Do
    i = i + 1
    If i > Len(Value) Then Exit Do
    
    c = Mid$(Value, i, 1)
    If c = "." Then
      q = q + 1
      
      If q > idx Then Exit Do
      rtn = ""
      
    Else
      rtn = rtn & c
    End If
    
  Loop
  
  If q < idx Then rtn = ""
  
  pGetVersion = Val(rtn)
End Function

'////////////////////////////////////////////////////

'Private Sub grDataBase_DblClick()
'  On Error GoTo ControlError
'
'  cmdOk_Click
'
'  GoTo ExitProc
'ControlError:
'  MngError Err, "grDataBase_DblClick", C_Module, ""
'  If Err.Number <> 0 Then Resume ExitProc
'ExitProc:
'  On Error Resume Next
'End Sub

'Private Sub Form_Load()
'  On Error GoTo ControlError
'
'  pSetGrDataBases
'  pShowDataBases
'
'  GoTo ExitProc
'ControlError:
'  MngError Err, "Form_Load", C_Module, ""
'  If Err.Number <> 0 Then Resume ExitProc
'ExitProc:
'  On Error Resume Next
'End Sub


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

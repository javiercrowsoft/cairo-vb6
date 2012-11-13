VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cInformes"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Implements cICheckedList
'--------------------------------------------------------------------------------
' cInformes
' 11-07-00

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module      As String = "cInformes"

' estructuras
' variables privadas
Private m_Coll          As Collection
Private m_IsLoaded      As Boolean

Private m_TempFolder    As String

Private m_InfCount      As Long
Private m_IdxFile       As Long

Private WithEvents m_cZ As cszip.cZip
Attribute m_cZ.VB_VarHelpID = -1

' Properties publicas
Public Property Get IsLoaded() As Boolean
  IsLoaded = m_IsLoaded
End Property
Public Property Let IsLoaded(ByVal rhs As Boolean)
  m_IsLoaded = rhs
End Property

Private Property Get cICheckedList_HaveToShowTag() As Boolean
  cICheckedList_HaveToShowTag = True
End Property

' Properties privadas
' funciones publicas
Public Sub Clear()
  CollClear m_Coll
  m_IsLoaded = False
End Sub

' el remove de esta colección es especial ya que tiene que borrar todos los hijos del nodo dentro de la coleccion
Public Sub Remove(ByVal kItem As Variant)
  On Error GoTo ControlError
    
  If IsNumeric(kItem) Then kItem = GetKey(kItem)
   
  m_Coll.Remove kItem
  Exit Sub
ControlError:
End Sub
Public Function Count() As Long
  On Error GoTo ControlError
  Count = m_Coll.Count
  Exit Function
ControlError:
  Count = 0
End Function

Public Function Item(ByVal kItem As Variant) As cInforme
  On Error GoTo ControlError
  If VarType(kItem) = vbInteger Then
    ' Nada que hacer, me ha pasado un indice
  ElseIf IsNumeric(kItem) Then
    kItem = GetKey(kItem)
  End If
  Set Item = m_Coll(kItem)
  Exit Function
ControlError:
End Function

Public Function NewEnum() As IUnknown
  Set NewEnum = m_Coll.[_NewEnum]
End Function

Public Function Load() As Boolean
  m_IsLoaded = True
  Load = True
End Function

Public Function Save(ByVal csrPath As String) As Boolean
  On Error GoTo ControlError

  Dim p           As cInforme
  Dim csrFile     As String
  Dim sp          As String
  Dim infCodigo   As String
  Dim pkgFolder   As String
  Dim pkgFile     As String
  Dim strError    As String
  
  m_InfCount = 0
  m_IdxFile = 0
  
  UpdateStatus fTree.picStatus, 0
  
  fTree.picProgress.Visible = True
  fTree.lbClose.Visible = False
  fTree.lsFiles.Clear
  DoEvents

  pSetFileCount
  
  m_TempFolder = Environ$("TEMP") & "\CSAI"

  pkgFolder = fTree.txPackagePath.Text
  pkgFile = fTree.txPackageName.Text

  If Not CreateFolder(pkgFolder) Then Exit Function
  
  If Not DeleteFile(GetValidPath(pkgFolder) & _
                                  pkgFile, _
                     strError) Then
    MsgWarning LNGGetText(3463, vbNullString, pkgFile, pkgFile, strError)
                'No se pudo eliminar el archivo  & pkgFile & _
                 en la carpeta  & pkgFile & ;; & strError
    Exit Function
  End If
  
  If Not CreateFolder(m_TempFolder) Then Exit Function

  If Not DeleteFile(GetValidPath(m_TempFolder) & _
                                  "informe.lst", _
                     strError) Then
    MsgWarning LNGGetText(3470, vbNullString, m_TempFolder, strError)
                'No se pudo eliminar el archivo informe.lst & _
                en la carpeta  & m_TempFolder & ;; & strError
    Exit Function
  End If

  If Not ClearFolder(m_TempFolder) Then Exit Function

  pSaveToInfFile

  For Each p In m_Coll
  
    If p.Granted Then
      
      gDb.GetData "Informe", "inf_id", p.InfId, "inf_codigo", infCodigo
      
      m_IdxFile = m_IdxFile + 1
      fTree.lbProcess.Caption = infCodigo
      UpdateStatus fTree.picStatus, m_IdxFile / m_InfCount
      
      If Not pGetInforme(p.InfId, csrFile, sp) Then Exit Function
      If Not pGetCSR(csrPath, csrFile) Then Exit Function
      If Not pGetSP(sp) Then Exit Function
      
    End If
  Next
  
  m_IdxFile = 0
  UpdateStatus fTree.picStatus, 0
  
  Dim zip As cszip.cZip
  Set zip = New cszip.cZip
  
  Set m_cZ = zip
  
  With zip
  
     .Encrypt = False
     .AddComment = False
     .ZipFile = GetValidPath(pkgFolder) & _
                   pkgFile
     .StoreFolderNames = False
     .RecurseSubDirs = False
     .ClearFileSpecs
     
     m_InfCount = ZipFilesInFolder(zip, m_TempFolder) * 3
     
     .zip
  
     If (.Success) Then
        
        UpdateStatus fTree.picStatus, 1, True
        
        MsgInfo LNGGetText(3468, vbNullString, .ZipFile)  'Archivo generado: _
                                                           vbCrLf & vbCrLf & _
                                                            -  & .ZipFile
     Else
        MsgWarning LNGGetText(3469, vbNullString)   'Falló la creación del zip.
        fTree.lbClose.Visible = True
        GoTo ExitProc
     End If
  
  End With
  
  fTree.picProgress.Visible = False
  
  Save = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "Save", "", "", vbCritical
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  Set m_cZ = Nothing
End Function

' funciones privadas
Private Function Add(ByVal c As cInforme, Optional Key As Variant) As cInforme
  On Error GoTo ControlError

  If c Is Nothing Then Set c = New cInforme

  If IsMissing(Key) Then
    m_Coll.Add c
  Else
    m_Coll.Add c, GetKey(Key)
  End If

  Set Add = c
  Exit Function
ControlError:
  Set Add = Nothing
End Function

' Implementacion de interfaz
Private Function cICheckedList_Add(ByVal o As CSInterfacesChkList.cICheckedListItem, _
                                   Optional Key As Variant) As CSInterfacesChkList.cICheckedListItem
  Dim c As cInforme
  Set c = Add(c)
  c.Granted = True
  c.InfId = Val(Key)
  Set cICheckedList_Add = c
End Function

Private Sub cICheckedList_Clear()
End Sub

Private Function cICheckedList_Count() As Long
  cICheckedList_Count = m_Coll.Count
End Function

Private Function cICheckedList_Item(ByVal kItem As Variant) As CSInterfacesChkList.cICheckedListItem
  cICheckedList_Item = Item(kItem)
End Function

Private Function cICheckedList_NewEnum() As stdole.IUnknown
  Set cICheckedList_NewEnum = m_Coll.[_NewEnum]
End Function

Private Sub cICheckedList_Remove(ByVal kItem As Variant)
End Sub

Private Function pGetInforme(ByVal InfId As Long, _
                             ByRef strFile As String, _
                             ByRef sp As String) As Boolean
  Dim infCodigo As String
  
' Informe
'
  If Not pGetInformeAux(InfId, True, _
                        "Informe", vbNullString, _
                        True, _
                        infCodigo, _
                        strFile, _
                        sp) Then Exit Function

' InformeParametro
'
  If Not pGetInformeAux(InfId, False, _
                        "InformeParametro", "_P", , infCodigo) Then Exit Function

' InformeGroups
'
  If Not pGetInformeAux(InfId, False, _
                        "InformeGroups", "_G", , infCodigo) Then Exit Function

' InformeHiperlinks
'
  If Not pGetInformeAux(InfId, False, _
                        "InformeHiperlinks", "_H", , infCodigo) Then Exit Function

' InformeOrders
'
  If Not pGetInformeAux(InfId, False, _
                        "InformeOrders", "_O", , infCodigo) Then Exit Function

' InformeSumaries
'
  If Not pGetInformeAux(InfId, False, _
                        "InformeSumaries", "_S", , infCodigo) Then Exit Function
  
  pGetInforme = True
End Function

Private Function pGetInformeAux(ByVal InfId As Long, _
                                ByVal bRequired As Boolean, _
                                ByVal table As String, _
                                ByVal prefix As String, _
                                Optional ByVal bIsInforme As Boolean, _
                                Optional ByRef infCodigo As String, _
                                Optional ByRef strFile As String, _
                                Optional ByRef sp As String) As Boolean
  Dim rs        As ADODB.Recordset
  Dim sqlstmt   As String
  
  sqlstmt = "select * from " & table & " where inf_id = " & InfId
  
  If Not gDb.OpenRs(sqlstmt, rs) Then Exit Function
  
  If rs.EOF And bRequired Then
    MsgWarning LNGGetText(3471, vbNullString, table, InfId)
              'No se obtuvo ningún registro de la tabla " & table & " para el ID: " & InfId
    Exit Function
  End If
  
  If bIsInforme Then
  
    strFile = gDb.ValField(rs.Fields, "inf_reporte")
    sp = gDb.ValField(rs.Fields, "inf_storedprocedure")
    infCodigo = rs.Fields("inf_codigo")
    
    pAddToInfoList gDb.ValField(rs.Fields, "inf_codigo"), _
                   gDb.ValField(rs.Fields, "inf_nombre")
    
  End If
  
  If Not rs.EOF Then
    rs.Save pGetFullFile(infCodigo & prefix), adPersistADTG
  End If

  pGetInformeAux = True
End Function

Private Sub pAddToInfoList(ByVal infCodigo As String, _
                           ByVal infNombre As String)
  Dim iFile As Integer
  
  iFile = FreeFile
  
  Open GetValidPath(m_TempFolder) & "informe.lst" For Append As #iFile
  
  Print #iFile, infCodigo & "|" & infNombre
  
  Close #iFile
End Sub

Private Sub pSaveToInfFile()
  Dim iFile As Integer
  
  iFile = FreeFile
  
  Open GetValidPath(m_TempFolder) & "informe.inf" For Append As #iFile
  
  Print #iFile, fTree.txDescrip.Text
  Print #iFile, String$(255, "*")
  Print #iFile, LNGGetText(3472, vbNullString) & Format(Now, "yyyy/mm/dd hh:nn:ss")
                'Creado el :
  Print #iFile, LNGGetText(3473, vbNullString, g_db.server)
                'Server :
  Print #iFile, LNGGetText(3474, vbNullString, g_db.DataBase)
                'DataBase :
  Close #iFile
End Sub

Private Function pGetCSR(ByVal csrPath As String, _
                         ByVal csrFile As String) As Boolean
  
  Dim source        As String
  Dim Answer        As VbMsgBoxResult
  
  If LenB(csrFile) Then
  
    Do
      source = GetValidPath(csrPath) & csrFile
      Do
        If FileExists(source) Then
          Exit Do
        End If
        
        Answer = Ask2(LNGGetText(3475, vbNullString, csrFile, GetPath(source)), vbYes)
                  'No se ha encontrado el archivo & csrFile &  en: & GetPath(source) & _
                      ;;¿Desea indicar la ubicación de este archivo?
        
        If Answer = vbNo Then
          
          Exit Function
        
        ElseIf Answer = vbIgnore Then
        
          pGetCSR = True
          Exit Function
        End If
        
        Dim File As cFile
        Set File = New cFile
        File.Init "pGetCSR", C_Module, fMain.cdFile
        File.FOpen source, csRead, False, False, csShared, True, False
      Loop
      
      If Not CopyFile(source, GetValidPath(m_TempFolder) & csrFile) Then
        
        If Not Ask(LNGGetText(3476, vbNullString, csrFile, GetPath(source)), vbYes) Then
                'No se pudo copiar el archivo & csrFile & en _
                   & GetPath(source) ;¿Desea intentar nuevamente?
          Exit Function
        End If
        
      Else
        Exit Do
      End If
    Loop
    
  End If
  
  pGetCSR = True
End Function

Private Function pGetSP(ByVal sp As String) As Boolean
  Dim spCode As String
  Dim server As CSSPScriptor.cSQLServer
  Set server = New CSSPScriptor.cSQLServer

  If Not server.OpenConnectionEx(g_db.server, _
                                 g_db.User, _
                                 g_db.Pwd, _
                                 g_db.UseNT, _
                                 g_db.DataBase) Then
    Exit Function
  End If
  
  spCode = server.GetSpCode(g_db.DataBase, _
                            sp, _
                            False)
    
  Dim iFile As Integer
  
  iFile = FreeFile
  
  Open GetValidPath(m_TempFolder) & sp & ".sql" For Output As iFile

  Print #iFile, spCode
  
  Close iFile
  
  pGetSP = True
End Function

Private Function pGetFullFile(ByVal Filename As String)
  pGetFullFile = GetValidPath(m_TempFolder) & Filename & ".ado"
End Function

Private Sub pSetFileCount()
  Dim p As cInforme

  For Each p In m_Coll
  
    If p.Granted Then
      m_InfCount = m_InfCount + 1
    End If
  Next
End Sub

Private Sub m_cZ_Progress(ByVal lCount As Long, ByVal sMsg As String)
  
  sMsg = Trim(sMsg)
  
  With fTree
    
    .lbProcess.Caption = sMsg
    With .lsFiles
      .AddItem sMsg
      .ListIndex = .NewIndex
    End With
  
    m_IdxFile = m_IdxFile + 1
    UpdateStatus .picStatus, m_IdxFile / m_InfCount
  
  End With
  
End Sub

' construccion - destruccion
Private Sub Class_Initialize()
  Set m_Coll = New Collection
End Sub

Private Sub Class_Terminate()
  CollClear m_Coll
  Set m_Coll = Nothing
  Set m_cZ = Nothing
End Sub

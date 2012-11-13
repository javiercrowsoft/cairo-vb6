VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cCDRomListDoc"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGeneric
Implements CSInterfacesABM.cIEditGenericListDoc
Implements CSInterfacesABM.cIABMListDocClient
Implements CSMenu.cIMenuClient


'--------------------------------------------------------------------------------
' cCDRomListDoc
' 00-06-03

'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cCDRomListDoc"

Private Const cscCarpeta = "Carpeta"
Private Const cscArchivo = "Archivo"
Private Const cscTipo = "Tipo"

Private Const c_img_file = 1

Private Const K_CARPETA                        As Integer = 1
Private Const K_ARCHIVO                        As Integer = 2
Private Const K_TIPO                           As Integer = 3
' estructuras
' Seudo - Variable
Private c_ErrorSave         As String

' variables privadas
Private m_Carpeta           As String
Private m_Archivo           As String
Private m_Tipo              As String

'OJO HASTA ACA
Private m_Properties        As cABMDocProperties

Private m_Editing           As Boolean

Private m_ObjAbm            As cIABMGenericListDoc
Private m_ObjList           As Object

Private m_IsNew             As Boolean

Private m_BranchId          As Long
Private m_TreeId            As Long

Private m_Us_id       As Long

Private m_Host As CSMenu.cIMenuHost

' Properties publicas
' Properties privadas
' funciones publicas
Private Property Get cIABMListDocClient_Properties() As Object
  Set cIABMListDocClient_Properties = m_Properties
End Property

Private Function cIABMListDocClient_PropertyChange(ByVal Key As Integer) As Boolean

   Select Case Key

    Case K_CARPETA
      m_Carpeta = m_ObjAbm.Properties(cscCarpeta).Value

    Case K_ARCHIVO
      m_Archivo = m_ObjAbm.Properties(cscArchivo).Value

    Case K_TIPO
      m_Tipo = m_ObjAbm.Properties(cscTipo).Value

   End Select

   cIABMListDocClient_PropertyChange = True
End Function


' Implementacion de cIABMListDocClient
Private Property Get cIABMListDocClient_Aplication() As String
    cIABMListDocClient_Aplication = gAppName
End Property

Private Sub cIABMListDocClient_DiscardChanges()
    LoadCollection
End Sub

Private Function cIABMListDocClient_ListAdHock(List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMListDocClient_Load()

End Sub

Private Function cIABMListDocClient_Refresh() As String
  Dim sqlstmt As String

  sqlstmt = "'" & m_Carpeta & "',"
  sqlstmt = sqlstmt & "'" & m_Archivo & "',"
  sqlstmt = sqlstmt & "'" & m_Tipo & "'"
  
  sqlstmt = Replace(sqlstmt, "*", "%")

  If InStr(1, sqlstmt, "%") Then
    sqlstmt = "sp_lsdoc_cdromLike " & sqlstmt
  Else
    sqlstmt = "sp_lsdoc_cdromEqual " & sqlstmt
  End If

  cIABMListDocClient_Refresh = sqlstmt
End Function

Private Function cIABMListDocClient_Save() As Boolean
    Dim register As cRegister
    Dim fields   As cFields
    
    Set register = New cRegister

    Dim sqlstmt As String
    sqlstmt = "delete ListaDocumentoParametro " & _
              " where pre_id = " & csPreCDListCDRom & _
                " and us_id = " & m_Us_id

    If Not gDB.Execute(sqlstmt, "cIABMCLidtDoclient_Save", "c", c_ErrorSave) Then Exit Function

    With register
      Set fields = .fields
      .Table = csTListaDocumentoParametro
      .UtilizaIdentity = True
    End With
    
    Dim IPropiedad As cIABMProperty
    For Each IPropiedad In m_ObjAbm.Properties

        fields.Clear

        With IPropiedad
            Select Case .Key

                Case K_CARPETA
                    fields.Add2 cscLdpValor, .Value, csText
                    fields.Add2 cscLdpOrden, 10, csInteger
                    fields.Add2 cscLdpId, K_CARPETA, csInteger
                Case K_ARCHIVO
                    fields.Add2 cscLdpValor, .Value, csText
                    fields.Add2 cscLdpOrden, 20, csInteger
                    fields.Add2 cscLdpId, K_ARCHIVO, csInteger
                Case K_TIPO
                    fields.Add2 cscLdpValor, .Value, csText
                    fields.Add2 cscLdpOrden, 30, csInteger
                    fields.Add2 cscLdpId, K_TIPO, csInteger
            End Select
            
            fields.Add2 cscUsId, m_Us_id, csId
            fields.Add2 cscPreID, csPreCDListCDRom, csId

            fields.HaveLastUpdate = False
            fields.HaveWhoModify = False
            
            If Not gDB.Save(register, , "cIABMClient_Save", "c", c_ErrorSave) Then Exit Function
        End With
    Next
    
    If Not Load(m_Us_id) Then Exit Function

    cIABMListDocClient_Save = True
End Function

Private Function cIABMListDocClient_Terminate() As Boolean
  cIABMListDocClient_Terminate = True
End Function

Private Property Get cIABMListDocClient_Title() As String
    cIABMListDocClient_Title = LNGGetText(2965, vbNullString)   'CDRom's
End Property

Private Function cIABMListDocClient_Validate() As Boolean
    cIABMListDocClient_Validate = True
End Function

' Implementacion de cIEditGeneric
Private Property Let cIEditGeneric_BranchId(ByVal RHS As Long)

End Property

Private Property Get cIEditGeneric_BranchId() As Long

End Property

Private Function cIEditGeneric_Delete(ID As Long) As Boolean

End Function

Private Function cIEditGeneric_Edit(ID As Long, Optional ByVal InModalWindow As Boolean) As Boolean

End Function

Private Property Get cIEditGeneric_Editing() As Boolean

End Property

Private Function cIEditGeneric_GridAdd(ByVal KeyProperty As Integer) As Boolean

End Function

Private Function cIEditGeneric_GridEdit(ByVal KeyProperty As Integer) As Boolean

End Function

Private Function cIEditGeneric_GridRemove(ByVal KeyProperty As Integer) As Boolean

End Function

Private Property Get cIEditGeneric_ObjABM() As CSInterfacesABM.cIABMGeneric

End Property

Private Property Set cIEditGeneric_ObjABM(RHS As CSInterfacesABM.cIABMGeneric)

End Property

Private Property Set cIEditGeneric_ObjTree(RHS As Object)

End Property

Private Function cIEditGeneric_Preview(ByVal ID As Long) As Boolean

End Function

Private Function cIEditGeneric_PrintObj(ByVal ID As Long) As Boolean

End Function

Private Function cIEditGeneric_PropertyChange(ByVal Key As Integer) As Boolean

End Function

Private Function cIEditGeneric_Search(ID As Long, Cancel As Boolean) As Boolean

End Function

Private Function cIEditGeneric_ShowList() As Boolean
  cIEditGeneric_ShowList = SecurityCanAccess(csPreCDSearchCDRom)
End Function

Private Function cIEditGeneric_TabClick(ByVal Index As Integer) As Boolean

End Function

Private Property Let cIEditGeneric_TreeId(ByVal RHS As Long)

End Property

Private Property Get cIEditGeneric_TreeId() As Long

End Property

' Implementacion de cIEditGenericListDoc
Private Function cIEditGenericListDoc_ShowParams(ByVal us_id As Long) As Boolean
  On Error GoTo ControlError

  If us_id = csNO_ID Then Exit Function

  m_Us_id = us_id

  If Not Load(us_id) Then Exit Function

  If Not LoadCollection() Then Exit Function

  cIEditGenericListDoc_ShowParams = True
  Exit Function
ControlError:
  MngError Err, "cIEditGenericListDoc_ShowParams", "cCDRomListDoc", vbNullString
End Function

Private Function cIEditGenericListDoc_TabClick(ByVal Index As Integer) As Boolean

End Function

Private Function cIEditGenericListDoc_ShowList() As Boolean
    cIEditGenericListDoc_ShowList = SecurityCanAccess(csPreCDListCDRom)
End Function

Private Function cIEditGenericListDoc_GridAdd(ByVal KeyProperty As Integer) As Boolean

End Function

Private Function cIEditGenericListDoc_GridEdit(ByVal KeyProperty As Integer) As Boolean

End Function

Private Function cIEditGenericListDoc_GridRemove(ByVal KeyProperty As Integer) As Boolean

End Function

Private Property Set cIEditGenericListDoc_ObjABM(RHS As CSInterfacesABM.cIABMGenericListDoc)
  Set m_ObjAbm = RHS
End Property

Private Property Set cIEditGenericListDoc_ObjList(RHS As Object)
  Set m_ObjList = RHS
End Property

Private Function cIEditGenericListDoc_PropertyChange(ByVal Key As Integer) As Boolean

End Function


' funciones privadas
Private Function LoadCollection() As Boolean
  With m_ObjAbm.Properties
  
    .Clear

    With .Add(Nothing, cscCarpeta)
      .PropertyType = cspText
      .Name = LNGGetText(2353, vbNullString)   'Carpeta
      .Size = 255
      .Key = K_CARPETA
      .Value = m_Carpeta
    End With
    
    With .Add(Nothing, cscArchivo)
      .PropertyType = cspText
      .Name = LNGGetText(2966, vbNullString)   'Archivo
      .Size = 255
      .Key = K_ARCHIVO
      .Value = m_Archivo
    End With
    
    With .Add(Nothing, cscTipo)
      .PropertyType = cspText
      .Name = LNGGetText(1223, vbNullString)   'Tipo
      .Size = 10
      .Key = K_TIPO
      .Value = m_Tipo
    End With
  
  End With
  
  If Not m_ObjAbm.Show(Me, m_ObjList) Then Exit Function

  LoadCollection = True
End Function

Private Function Load(ByVal us_id) As Boolean
  Dim sqlstmt As String

  sqlstmt = "select * from ListaDocumentoParametro " & _
            " where us_id =" & us_id & _
               " And pre_id = " & csPreCDListCDRom & _
            " order by " & cscLdpOrden

  Dim rs As Recordset

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "Load", "cCDRomListDoc") Then Exit Function

  If rs.EOF Then

    m_Carpeta = ""
    m_Archivo = ""
    m_Tipo = ""
  Else

    rs.MoveLast
    rs.MoveFirst

    Dim i As Integer
    While Not rs.EOF

      Select Case gDB.ValField(rs.fields, cscLdpId)

        Case K_CARPETA
          m_Carpeta = Val(gDB.ValField(rs.fields, cscLdpValor))
        Case K_ARCHIVO
          m_Archivo = Val(gDB.ValField(rs.fields, cscLdpValor))
        Case K_TIPO
          m_Tipo = Val(gDB.ValField(rs.fields, cscLdpValor))
      End Select

      rs.MoveNext
    Wend

  End If

  Load = True

End Function
' construccion - destruccion

Private Function cIMenuClient_Initialize(F As Object, Host As CSMenu.cIMenuHost) As Boolean
  On Error GoTo ControlError
  Dim str_2955  As String
  
  str_2955 = LNGGetText(2955, vbNullString) 'CD&Teka
  Set m_Host = Host
  m_Host.Server.AddMenu str_2955, csCDMenuList, vbNullString, 1, False, False, False, True, False, Nothing
  m_Host.Server.AddMenu LNGGetText(2967, vbNullString), csPreCDSearchCDRom, str_2955, 0, True, False, False, False, False, Me
                        '&Buscar
  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, "cIMenuClient_Initialize", C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal ID As Long) As Variant
  m_Host.MenuListDocClick "CSABMInterface2.CABMGeneric", "CSCDTeka2.cCDRom", "CSABMInterface2.CABMGenericListDoc", "CSCDTeka2.cCDRomListDoc", Me, "Buscar CD's", 0
End Function

Private Sub Class_Initialize()
  Set m_Properties = New cABMDocProperties
  
  c_ErrorSave = LNGGetText(2968, vbNullString)
                'Error al grabar los parámetros de navegación de CDRoms
  
  With m_Properties
  Set .ImageList = fIcons.ilList
  .HaveDetail = True
  .StartRowText = 3
  
  With .Columns.Add(Nothing, "TypeCD")
    .Name = "TypeCD"
    .Caption = " "
    With .Icons.Add(Nothing)
    .FormulaType = csCondTNone
    .IconIndex = c_img_file
    End With
    .Width = 500
    .SortType = csSrtTIcon
  End With
  
  With .Columns.Add(Nothing, "Path")
    .Name = "Path"
    .FontName = "Tahoma"
    .FontSize = 8
    .ForeColor = vbBlue
  End With
  End With
End Sub

Private Sub Class_Terminate()
    Set m_ObjAbm = Nothing
    Set m_ObjList = Nothing
    Set m_Properties = Nothing
End Sub


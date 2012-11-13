VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cCAISListDoc"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGenericListDoc
Implements CSInterfacesABM.cIABMListDocClient
'--------------------------------------------------------------------------------
' cCAISListDoc
' 02-07-03

'--------------------------------------------------------------------------------
' notas:

' CAIS          reemplazar por el prefijo de la tabla (ej pro)
' CAIS           reemplazar por el nombre de la tabla (ej Provincia)
' cCAISListDoc           reemplazar por el nombre de la clase (ej cProvincia)
' CAISs         reemplazar por el nombre logico del abm (ej Provincias)
' csPreTarea     reemplazar por el prefijo de las prestaciones (ej PreG)
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cCAISListDoc"

Private Const K_FECHADESDE                       As Integer = 1
Private Const K_FECHAHASTA                       As Integer = 2
Private Const K_PATH                             As Integer = 3
Private Const K_FORMS                            As Integer = 4

Private Const cscCAISDesde = "desde"
Private Const cscCAISHasta = "hasta"
Private Const cscPath = "path"
Private Const cscForms = "formularios"

Private Const c_FileForms As String = "Formularios.txt"
' estructuras
' variables privadas
Private m_FechaDesde                      As Date
Private m_FechaHasta                      As Date
Private m_Path                            As String
Private m_PathForms                       As String

'OJO HASTA ACA

Private m_ObjAbm        As cIABMGenericListDoc
Private m_ObjList       As Object

Private m_Us_id         As Long

Private m_Properties    As cABMDocProperties
' Properties publicas
' Properties privadas
' funciones publicas

' Implementacion de cIABMClient

'-------------------------------------------------------------------------------------
' Interfaz cliente de List de documentos

Private Property Get cIABMListDocClient_Aplication() As String
  cIABMListDocClient_Aplication = gAppName
End Property

Private Sub cIABMListDocClient_DiscardChanges()
  Load m_Us_id
  LoadCollection
End Sub

Private Function cIABMListDocClient_ListAdHock(List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMListDocClient_Load()

End Sub

Private Property Get cIABMListDocClient_Properties() As Object
  Set cIABMListDocClient_Properties = m_Properties
End Property

Private Function cIABMListDocClient_PropertyChange(ByVal Key As Integer) As Boolean

   Select Case Key

    Case K_FECHADESDE
      If IsDate(m_ObjAbm.Properties(cscCAISDesde).Value) Then
        m_FechaDesde = m_ObjAbm.Properties(cscCAISDesde).Value
      Else
        m_ObjAbm.Properties(cscCAISDesde).Value = m_FechaDesde
      End If

    Case K_FECHAHASTA
      If IsDate(m_ObjAbm.Properties(cscCAISHasta).Value) Then
        m_FechaHasta = m_ObjAbm.Properties(cscCAISHasta).Value
      Else
        m_ObjAbm.Properties(cscCAISHasta).Value = m_FechaHasta
      End If
      
    Case K_PATH
      m_Path = m_ObjAbm.Properties(cscPath).Value
    
    Case K_FORMS
      m_PathForms = m_ObjAbm.Properties(cscForms).Value
   End Select

   cIABMListDocClient_PropertyChange = True
End Function

Private Function cIABMListDocClient_Refresh() As String
  Dim sqlstmt As String
  Dim db As cDataBase
  Dim rs As Recordset
  Set db = New cDataBase
  
  If Not db.InitDB(GetValidPath(m_Path) & "strad.mdb") Then Exit Function

  sqlstmt = pGetSqlstmt

  If Not db.OpenRsEX(True, False, True, sqlstmt, rs) Then Exit Function

  sqlstmt = "sp_lsdoc_CAISs " & pGetSqlstmtCais(rs)
  
  cIABMListDocClient_Refresh = sqlstmt
End Function

Private Function cIABMListDocClient_Save() As Boolean
    Dim register As cRegister
    Set register = New cRegister

    Dim sqlstmt As String
    sqlstmt = "delete " & csTListaDocumentoParametro
    sqlstmt = sqlstmt & " where "
    sqlstmt = sqlstmt & " pre_id = " & csPreR1361ListCais
    sqlstmt = sqlstmt & " And us_id = " & m_Us_id

    If Not gDB.Execute(sqlstmt, "cIABMClient_Save", "cCAISListDoc", "Error al grabar CAIS") Then Exit Function

    register.Table = csTListaDocumentoParametro
    register.UtilizaIdentity = True

    Dim IProperty As cIABMProperty
    For Each IProperty In m_ObjAbm.Properties

        register.Fields.Clear

        With IProperty
            Select Case .Key

                Case K_FECHADESDE
                    register.Fields.Add2 cscLdpValor, .Value, csText
                    register.Fields.Add2 cscLdpOrden, 10, csInteger
                    register.Fields.Add2 cscLdpId, K_FECHADESDE, csInteger
                Case K_FECHAHASTA
                    register.Fields.Add2 cscLdpValor, .Value, csText
                    register.Fields.Add2 cscLdpOrden, 20, csInteger
                    register.Fields.Add2 cscLdpId, K_FECHAHASTA, csInteger
                Case K_PATH
                    register.Fields.Add2 cscLdpValor, .Value, csText
                    register.Fields.Add2 cscLdpOrden, 20, csInteger
                    register.Fields.Add2 cscLdpId, K_PATH, csInteger
                Case K_FORMS
                    register.Fields.Add2 cscLdpValor, .Value, csText
                    register.Fields.Add2 cscLdpOrden, 20, csInteger
                    register.Fields.Add2 cscLdpId, K_FORMS, csInteger
            End Select
            register.Fields.Add2 cscUsId, m_Us_id, csId
            register.Fields.Add2 cscPreID, csPreR1361ListCais, csId

            register.Fields.HaveLastUpdate = False
            register.Fields.HaveLastUpdate = False
            If Not gDB.Save(register, , "cIABMClient_Save", "cCAISListDoc", "Error al grabar CAIS") Then Exit Function
        End With
    Next
    If Not Load(m_Us_id) Then Exit Function

    cIABMListDocClient_Save = True
End Function

Private Function cIABMListDocClient_Terminate() As Boolean
  cIABMListDocClient_Terminate = True
End Function

Private Property Get cIABMListDocClient_Title() As String
  cIABMListDocClient_Title = "Tareas"
End Property

Private Function cIABMListDocClient_Validate() As Boolean
  cIABMListDocClient_Validate = True
End Function

' funciones privadas
Private Function LoadCollection() As Boolean
    m_ObjAbm.Properties.Clear

    Dim c As cIABMProperty
    Dim o As cIABMListItem

    Set c = m_ObjAbm.Properties.Add(c, cscCAISDesde)
    c.PropertyType = cspDate
    c.Name = "Fecha Desde"
    c.Key = K_FECHADESDE
    c.Value = m_FechaDesde
    Set c = Nothing

    Set c = m_ObjAbm.Properties.Add(c, cscCAISHasta)
    c.PropertyType = cspDate
    c.Name = "Fecha Hasta"
    c.Key = K_FECHAHASTA
    c.Value = m_FechaHasta
    Set c = Nothing

    Set c = m_ObjAbm.Properties.Add(c, cscPath)
    c.PropertyType = cspFolder
    c.Name = "Path MDB Aux"
    c.Key = K_PATH
    c.Value = m_Path
    Set c = Nothing

    Set c = m_ObjAbm.Properties.Add(c, cscForms)
    c.PropertyType = cspFolder
    c.Name = "Path Sqlstmt Forms"
    c.Key = K_FORMS
    c.Value = m_PathForms
    Set c = Nothing
    
    If Not m_ObjAbm.Show(Me, m_ObjList) Then Exit Function

    LoadCollection = True
End Function

Private Function Load(ByVal Us_id As Long) As Boolean
    Dim sqlstmt As String

    sqlstmt = "select * from " & csTListaDocumentoParametro
    sqlstmt = sqlstmt & " where "
    sqlstmt = sqlstmt & cscUsId & " = " & Us_id & " And "
    sqlstmt = sqlstmt & cscPreID & " = " & csPreR1361ListCais
    sqlstmt = sqlstmt & " order by " & cscLdpOrden

    Dim rs As ADODB.Recordset

    If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "Load", "cCAISListDoc") Then Exit Function

    If rs.EOF Then

      m_FechaDesde = Date
      m_FechaHasta = Date
      m_Path = ""
      m_PathForms = ""
    Else

      rs.MoveLast
      rs.MoveFirst

      Dim i As Integer
      While Not rs.EOF

        Select Case gDB.ValField(rs.Fields, cscLdpId)

          Case K_FECHADESDE
            m_FechaDesde = IIf(IsDate(gDB.ValField(rs.Fields, cscLdpValor)), gDB.ValField(rs.Fields, cscLdpValor), Date)
          Case K_FECHAHASTA
            m_FechaHasta = IIf(IsDate(gDB.ValField(rs.Fields, cscLdpValor)), gDB.ValField(rs.Fields, cscLdpValor), Date)
          Case K_PATH
            m_Path = gDB.ValField(rs.Fields, cscLdpValor)
          Case K_FORMS
            m_PathForms = gDB.ValField(rs.Fields, cscLdpValor)
        End Select

        rs.MoveNext
      Wend

      Dim Data As String

      m_FechaDesde = IIf(m_FechaDesde <> csNoDate, m_FechaDesde, Date)
      m_FechaHasta = IIf(m_FechaHasta <> csNoDate, m_FechaHasta, Date)
    End If

    Load = True

End Function

'-------------------------------------------------------------------------------------
' Implementacion de cIEditGeneric
Private Function cIEditGenericListDoc_GridAdd(ByVal ClavePropiedad As Integer) As Boolean

End Function

Private Function cIEditGenericListDoc_GridEdit(ByVal ClavePropiedad As Integer) As Boolean

End Function

Private Function cIEditGenericListDoc_GridRemove(ByVal ClavePropiedad As Integer) As Boolean

End Function

Private Property Set cIEditGenericListDoc_ObjAbm(rhs As CSInterfacesABM.cIABMGenericListDoc)
  Set m_ObjAbm = rhs
End Property

Private Function cIEditGenericListDoc_ShowParams(ByVal Us_id As Long) As Boolean
  On Error GoTo ControlError
  
  If Us_id = csNO_ID Then Exit Function

  m_Us_id = Us_id
  
  If Not Load(Us_id) Then Exit Function
  
  If Not LoadCollection() Then Exit Function
  
  cIEditGenericListDoc_ShowParams = True
  Exit Function
ControlError:
  MngError Err, "cIEditGenericListDoc_Edit", "cCAISListDoc", ""
End Function

Private Property Set cIEditGenericListDoc_ObjList(rhs As Object)
  Set m_ObjList = rhs
End Property

Private Function cIEditGenericListDoc_PropertyChange(ByVal Clave As Integer) As Boolean

End Function

Private Function cIEditGenericListDoc_TabClick(ByVal Index As Integer) As Boolean

End Function

Private Function pGetSqlstmtCais(ByRef rs As Recordset) As String
  Dim rtn As String
  While Not rs.EOF
    If IsNull(rs.Fields("CNTNRCUIT")) Then
      rtn = rtn & "@" & ValField(rs.Fields, "FECHA") & "," & ValField(rs.Fields, "NRCUIT") & "," & ValField(rs.Fields, "COMPR") & "#"
    Else
      rtn = rtn & "@" & ValField(rs.Fields, "FECHA") & "," & ValField(rs.Fields, "CNTNRCUIT") & "," & ValField(rs.Fields, "COMPR") & "#"
    End If
    
    rs.MoveNext
  Wend
  pGetSqlstmtCais = "'" & rtn & "'"
End Function

Private Function pGetSqlstmt() As String
  Dim sqlstmt As String
  
  sqlstmt = sqlstmt & "SELECT " & vbCrLf
  sqlstmt = sqlstmt & "    max(PVMV00.FCHMOV) AS FECHA, " & vbCrLf
  sqlstmt = sqlstmt & "    max(PVMV00.NROMOV) AS COMPR, " & vbCrLf
  sqlstmt = sqlstmt & "    PVCL00.NRCUIT," & vbCrLf
  sqlstmt = sqlstmt & "    PVIC00.NRCUIT AS CNTNRCUIT" & vbCrLf
  sqlstmt = sqlstmt & "" & vbCrLf
  sqlstmt = sqlstmt & "FROM " & vbCrLf
  sqlstmt = sqlstmt & "    (" & vbCrLf
  sqlstmt = sqlstmt & "    (" & vbCrLf
  sqlstmt = sqlstmt & "    (" & vbCrLf
  sqlstmt = sqlstmt & "    (" & vbCrLf
  sqlstmt = sqlstmt & "    (" & vbCrLf
  sqlstmt = sqlstmt & "    PVMV00 " & vbCrLf
  sqlstmt = sqlstmt & "    LEFT JOIN PVCL00 " & vbCrLf
  sqlstmt = sqlstmt & "        ON PVMV00.NROCTA = PVCL00.NROCTA" & vbCrLf
  sqlstmt = sqlstmt & "    )" & vbCrLf
  sqlstmt = sqlstmt & "    LEFT JOIN PVCC00 " & vbCrLf
  sqlstmt = sqlstmt & "        ON (PVMV00.CODMOV = PVCC00.CODMOV) " & vbCrLf
  sqlstmt = sqlstmt & "        AND (PVMV00.NROMOV = PVCC00.NROMOV)" & vbCrLf
  sqlstmt = sqlstmt & "    )" & vbCrLf
  sqlstmt = sqlstmt & "    INNER JOIN PVIV00 " & vbCrLf
  sqlstmt = sqlstmt & "        ON (PVMV00.NROMOV = PVIV00.NROMOV) " & vbCrLf
  sqlstmt = sqlstmt & "        AND (PVMV00.CODMOV = PVIV00.CODMOV)" & vbCrLf
  sqlstmt = sqlstmt & "    )" & vbCrLf
  sqlstmt = sqlstmt & "    LEFT JOIN STPD00" & vbCrLf
  sqlstmt = sqlstmt & "        ON (PVIV00.TEXTOS = STPD00.ARTCOD)" & vbCrLf
  sqlstmt = sqlstmt & "    )" & vbCrLf
  sqlstmt = sqlstmt & "    INNER JOIN PVFR00" & vbCrLf
  sqlstmt = sqlstmt & "        ON (PVMV00.CODMOV = PVFR00.CODIGO)" & vbCrLf
  sqlstmt = sqlstmt & "    )" & vbCrLf
  sqlstmt = sqlstmt & "    LEFT JOIN PVIC00 " & vbCrLf
  sqlstmt = sqlstmt & "        ON (PVMV00.NROMOV = PVIC00.NROMOV) " & vbCrLf
  sqlstmt = sqlstmt & "        AND (PVMV00.CODMOV = PVIC00.CODMOV)" & vbCrLf
  sqlstmt = sqlstmt & "" & vbCrLf
  sqlstmt = sqlstmt & "" & vbCrLf
  sqlstmt = sqlstmt & "WHERE " & vbCrLf
  sqlstmt = sqlstmt & "        [PVMV00].[FCHMOV]>=" & Format(m_FechaDesde, "YYYYMMDD") & vbCrLf
  sqlstmt = sqlstmt & "    AND [PVMV00].[FCHMOV]<=" & Format(m_FechaHasta, "YYYYMMDD") & vbCrLf
  sqlstmt = sqlstmt & "" & vbCrLf
  sqlstmt = sqlstmt & "    AND" & vbCrLf
  sqlstmt = sqlstmt & "    (" & vbCrLf
  sqlstmt = sqlstmt & pGetFormularios
'  sqlstmt = sqlstmt & "        PVMV00.CODMOV = ""FC"" OR" & vbCrLf
'  sqlstmt = sqlstmt & "        PVMV00.CODMOV = ""FW"" OR" & vbCrLf
'  sqlstmt = sqlstmt & "        PVMV00.CODMOV = ""F1"" OR" & vbCrLf
'  sqlstmt = sqlstmt & "        PVMV00.CODMOV = ""FA"" OR" & vbCrLf
'  sqlstmt = sqlstmt & "        PVMV00.CODMOV = ""FX"" OR" & vbCrLf
'  sqlstmt = sqlstmt & "        PVMV00.CODMOV = ""CA"" OR" & vbCrLf
'  sqlstmt = sqlstmt & "        PVMV00.CODMOV = ""C1"" OR" & vbCrLf
'  sqlstmt = sqlstmt & "        PVMV00.CODMOV = ""CC"" OR" & vbCrLf
'  sqlstmt = sqlstmt & "        PVMV00.CODMOV = ""C2"" OR" & vbCrLf
'  sqlstmt = sqlstmt & "        PVMV00.CODMOV = ""CE"" OR" & vbCrLf
'  sqlstmt = sqlstmt & "        PVMV00.CODMOV = ""C3"" OR" & vbCrLf
'  sqlstmt = sqlstmt & "        PVMV00.CODMOV = ""DA"" OR" & vbCrLf
'  sqlstmt = sqlstmt & "        PVMV00.CODMOV = ""D1"" OR" & vbCrLf
'  sqlstmt = sqlstmt & "        PVMV00.CODMOV = ""DC"" OR" & vbCrLf
'  sqlstmt = sqlstmt & "        PVMV00.CODMOV = ""D2"" OR" & vbCrLf
'  sqlstmt = sqlstmt & "        PVMV00.CODMOV = ""DE"" OR" & vbCrLf
'  sqlstmt = sqlstmt & "        PVMV00.CODMOV = ""D3"" OR" & vbCrLf
'  sqlstmt = sqlstmt & "        PVMV00.CODMOV = ""FE""" & vbCrLf
  sqlstmt = sqlstmt & "    )" & vbCrLf
  sqlstmt = sqlstmt & "" & vbCrLf
  sqlstmt = sqlstmt & "GROUP BY " & vbCrLf
  sqlstmt = sqlstmt & "" & vbCrLf
  sqlstmt = sqlstmt & "    PVCL00.NRCUIT," & vbCrLf
  sqlstmt = sqlstmt & "    PVIC00.NRCUIT " & vbCrLf
  sqlstmt = sqlstmt & ";" & vbCrLf
  
  pGetSqlstmt = sqlstmt
End Function

Private Function pGetFormularios() As String
  Dim rtn As String
  Dim Text As String
  Dim F As cFile
  Dim bEof As Boolean
  Set F = New cFile
  
  If Not F.FOpen(GetValidPath(m_PathForms) & c_FileForms, csRead, False, True, csShared, False, False) Then
    Err.Raise vbObjectError + 20, "CSAFIPRes1361", "No se puede continuar sin el archivo " & c_FileForms
  End If
  
  While Not F.IsEOF
    F.FRead Text, bEof
    rtn = rtn & Text & vbCrLf
  Wend
  
  pGetFormularios = rtn
End Function
' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  Set m_Properties = New cABMDocProperties
  With m_Properties
    Set .ImageList = fResource.ilList
    .HaveDetail = True
    .StartRowText = 4
    
    With .Columns.Add(Nothing, "TypeTask")
      .Name = "TypeTask"
      .Caption = " "
      With .Icons.Add(Nothing)
        .FormulaType = csCondTNone
        .IconIndex = c_img_task
      End With
      .Width = 500
      .SortType = csSrtTIcon
    End With
  End With
  
  GoTo ExitProc
ControlError:
  MngError Err, "Class_Terminate", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
  On Error GoTo ControlError
  
  Set m_ObjAbm = Nothing
  Set m_ObjList = Nothing
  Set m_Properties = Nothing

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Terminate", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub





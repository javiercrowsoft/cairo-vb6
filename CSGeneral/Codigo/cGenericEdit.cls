VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cGenericEdit"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cGenericEdit
' 01-12-2008

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cGenericEdit"
' estructuras
' variables privadas
Private m_tbl_id As Long
Private m_tbl_name As String
Private m_field_id As String

Private m_properties As cGenericEditProperties
' eventos
' propiedades publicas
' propiedades friend
' propiedades privadas
' funciones publicas
Public Function Init(ByVal tbl_id As Long) As Boolean

  Dim Table As String

  If Not gDB.GetData(csTTabla, _
                     cscTblId, _
                     tbl_id, _
                     cscTblNombreFisico, _
                     Table, _
                     "Init", _
                     C_Module) Then Exit Function

  If Not pGetFieldId(tbl_id, m_field_id) Then Exit Function

  m_tbl_id = tbl_id
  m_tbl_name = Table
  
  Dim sqlstmt As String
  Dim rs As Recordset

  sqlstmt = "select tbli.*, tbl_nombrefisico "
  sqlstmt = sqlstmt & " from TablaItem tbli left join Tabla tbl on tbli.tbl_id_help = tbl.tbl_id"
  sqlstmt = sqlstmt & " where tbli.tbl_id = " & m_tbl_id
  sqlstmt = sqlstmt & " order by tbli_orden"

  If Not gDB.OpenRs(sqlstmt, rs, , , , "Load", C_Module) Then Exit Function

  Dim prop As cGenericEditProperty

  m_properties.Clear

  While Not rs.EOF
  
    Set prop = m_properties.Add(Nothing, rs.fields(cscTbliId))
    
    prop.Id = rs(cscTbliId).Value
    prop.Nombre = gDB.ValField(rs.fields, cscTbliNombre)
    prop.NombreFisico = gDB.ValField(rs.fields, cscTbliNombreFisico)
    prop.Tipo = gDB.ValField(rs.fields, cscTbliTipo)
    prop.SubTipo = gDB.ValField(rs.fields, cscTbliSubTipo)
    prop.Orden = gDB.ValField(rs.fields, cscTbliOrden)
    prop.Tabla = gDB.ValField(rs.fields, cscTblNombreFisico)
    prop.tbl_id = gDB.ValField(rs.fields, cscTblIdHelp)
    prop.HelpType = gDB.ValField(rs.fields, cscTbliHelpType)
    prop.Filtro = gDB.ValField(rs.fields, cscTbliFiltro)
    prop.DefaultValue = gDB.ValField(rs.fields, cscTbliDefaultValue)
    prop.MinValue = gDB.ValField(rs.fields, cscTbliMinValue)
    prop.MaxValue = gDB.ValField(rs.fields, cscTbliMaxValue)
    prop.TextAlign = gDB.ValField(rs.fields, cscTbliTextAlign)
    prop.TextMask = gDB.ValField(rs.fields, cscTbliTextMask)
    prop.Format = gDB.ValField(rs.fields, cscTbliFormat)
    prop.Width = gDB.ValField(rs.fields, cscTbliWidth)
    prop.Height = gDB.ValField(rs.fields, cscTbliHeight)
    prop.Top = gDB.ValField(rs.fields, cscTbliTop)
    prop.Left = gDB.ValField(rs.fields, cscTbliLeft)
    prop.NoShowButton = gDB.ValField(rs.fields, cscTbliNoShowButton)
    prop.sqlstmt = gDB.ValField(rs.fields, cscTbliSqlstmt)
    
    rs.MoveNext
  Wend

  Init = True
  
End Function

Public Function Load(ByVal Id As Long) As Boolean

  If m_properties.Count = 0 Then
    Load = True
    Exit Function
  End If
  
  If Id = csNO_ID Then
    Load = True
    Exit Function
  End If
  
  Dim prop As cGenericEditProperty
  Dim sqlstmt As String
  Dim sqlselect As String
  Dim sqlfrom As String
  Dim sqlwhere As String
  
  Dim rs As Recordset
  Dim field_name As String
  Dim field_id As String
  Dim tbl_alias As Long

  sqlselect = "select "
  
  sqlfrom = " from " & m_tbl_name & " as t"
  
  For Each prop In m_properties
  
    sqlselect = sqlselect & "t." & prop.NombreFisico & ","
  
    If prop.Tipo = cspHelp Then
      
      If Not pGetFieldName(prop.tbl_id, field_name) Then
        Exit Function
      End If
      If Not pGetFieldId(prop.tbl_id, field_id) Then
        Exit Function
      End If
      
      tbl_alias = tbl_alias + 1
      sqlselect = sqlselect & "t" & tbl_alias & "." & field_name & " as t_name" & tbl_alias & ","
      
      sqlfrom = sqlfrom & " left join " & prop.Tabla & " as t" & tbl_alias _
                        & " on t." & prop.NombreFisico & "=t" & tbl_alias & "." & field_id
    End If
  
  Next
  
  sqlstmt = RemoveLastColon(sqlselect) & sqlfrom & " where " & m_field_id & "=" & Id
  
  If Not gDB.OpenRs(sqlstmt, rs, , , , "Load", C_Module) Then Exit Function
  
  If rs.EOF Then Exit Function
  
  Dim i As Long
  
  For Each prop In m_properties
    
    If prop.Tipo = cspHelp Then
      
      prop.HelpValue = gDB.ValField(rs.fields, i)
      i = i + 1
      
      prop.Value = gDB.ValField(rs.fields, i)
      i = i + 1
    Else
      prop.Value = gDB.ValField(rs.fields, i)
      i = i + 1
    End If
  
  Next
  
  Load = True
End Function

Public Function LoadCollection(ByRef ObjAbm As cIABMGeneric) As Boolean

  If m_properties.Count = 0 Then
    LoadCollection = True
    Exit Function
  End If

  Dim prop As cGenericEditProperty
  Dim iProp As cIABMProperty
  Dim i As Long
  Dim k As Long
  Dim vList As Variant
  Dim rs As ADODB.Recordset
  Dim TabIndex As Long
  
  With ObjAbm.Tabs.Add(Nothing)
    TabIndex = ObjAbm.Tabs.Count - 1
    .name = LNGGetText(4786, vbNullString) ' Campos Adicionales
    .Index = TabIndex
  End With
  
  For Each prop In m_properties
    
    i = i + 1
    
    Set iProp = ObjAbm.Properties.Add(Nothing, pGetKey(i))
    iProp.PropertyType = prop.Tipo
    iProp.SubType = prop.SubTipo
    iProp.TabIndex = TabIndex
    iProp.name = pGetName(prop.Nombre)
    
    Select Case prop.Tipo
    
      Case cspCheck
        iProp.Value = Val(prop.Value)
      
      Case cspDate
        If IsDate(prop.Value) Then
          iProp.Value = DateValue(prop.Value)
        Else
          iProp.Value = csNoDate
        End If
      
      Case cspHelp
        
        iProp.Value = prop.Value
        iProp.HelpId = Val(prop.HelpValue)
        iProp.HelpValueProcess = prop.HelpValue
        iProp.HelpFilter = prop.Filtro
        iProp.Table = prop.tbl_id
        
      Case cspList
        iProp.ListWhoSetItem = csListItemData
        iProp.ListItemData = Val(prop.Value)
        vList = Split(prop.sqlstmt, "|")
        
        For k = 0 To UBound(vList) Step 2
          
          With iProp.List.Add(Nothing)
            .Id = Val(vList(k + 1))
            .Value = vList(k)
          End With
          
        Next
        
      Case cspNumeric
        iProp.Value = Val(prop.Value)
        
      Case cspText
        iProp.Value = prop.Value
        
      Case cspSqlstmt
        iProp.ListWhoSetItem = csListItemData
        iProp.ListItemData = Val(prop.Value)
        
        If Not gDB.OpenRs(prop.sqlstmt, _
                          rs, , , , _
                          "LoadCollection", _
                          C_Module) Then Exit Function
                          
        While Not rs.EOF
        
          With iProp.List.Add(Nothing)
            .Id = gDB.ValField(rs.fields, 0)
            .Value = gDB.ValField(rs.fields, 1)
          End With
          
          rs.MoveNext
        
        Wend
        
      Case cspFile
        iProp.HelpFilter = prop.Filtro
        iProp.Value = prop.Value
        
      Case cspFolder
        iProp.HelpFilter = prop.Filtro
        iProp.Value = prop.Value
        
      Case cspImage
      Case cspLabel
        iProp.Value = prop.Value
        
    End Select
  
  Next

  LoadCollection = True
  
End Function

Public Function Validate(ByRef ObjAbm As cIABMGeneric) As Boolean

  Validate = True
  
End Function

Public Function Save(ByRef ObjAbm As cIABMGeneric, _
                     ByRef register As cRegister) As Boolean
                     
  Dim prop As cGenericEditProperty
  Dim iProp As cIABMProperty
  Dim i As Long
  
  For Each prop In m_properties
    i = i + 1
    Set iProp = pGetiProp(ObjAbm, i)
  
    Select Case prop.Tipo
      
      Case cspCheck
        register.fields.Add2 prop.NombreFisico, iProp.Value, csBoolean
      Case cspDate
        register.fields.Add2 prop.NombreFisico, iProp.Value, csDate
      Case cspHelp
        register.fields.Add2 prop.NombreFisico, iProp.HelpId, csId
      Case cspList
        register.fields.Add2 prop.NombreFisico, iProp.ListItemData, csInteger
      Case cspNumeric
        register.fields.Add2 prop.NombreFisico, iProp.Value, csDouble
      Case cspText
        register.fields.Add2 prop.NombreFisico, iProp.Value, csText
      Case cspSqlstmt
        register.fields.Add2 prop.NombreFisico, iProp.ListItemData, csInteger
      Case cspFile
        register.fields.Add2 prop.NombreFisico, iProp.Value, csText
      Case cspFolder
        register.fields.Add2 prop.NombreFisico, iProp.Value, csText
    End Select
  
  Next

  Save = True

End Function

Public Sub RefreshProperties(ByRef ObjAbm As cIABMGeneric)
                     
  Dim prop As cGenericEditProperty
  Dim iProp As cIABMProperty
  Dim i As Long
  
  For Each prop In m_properties
    i = i + 1
    Set iProp = pGetiProp(ObjAbm, i)
  
    Select Case prop.Tipo
      
      Case cspCheck
        iProp.Value = Val(prop.Value)
      Case cspDate
        iProp.Value = prop.Value
      Case cspHelp
        iProp.HelpId = Val(prop.HelpValue)
        iProp.HelpValueProcess = prop.HelpValue
      Case cspList
        iProp.ListItemData = Val(prop.Value)
      Case cspNumeric
        iProp.Value = Val(prop.Value)
      Case cspText
        iProp.Value = prop.Value
      Case cspSqlstmt
        iProp.ListItemData = Val(prop.Value)
      Case cspFile
        iProp.Value = prop.Value
      Case cspFolder
        iProp.Value = prop.Value
    End Select
  
  Next

End Sub

Public Function PropertyChange(ByVal Key As Integer) As Boolean

  PropertyChange = True
  
End Function

' funciones friend
' funciones privadas
Private Function pGetiProp(ByRef ObjAbm As cIABMGeneric, _
                           ByVal idx As Long) As cIABMProperty
  Set pGetiProp = ObjAbm.Properties.Item(pGetKey(idx))
End Function

Private Function pGetFieldName(ByVal tbl_id As Long, _
                               ByRef field_name As String) As Boolean
  If Not gDB.GetData(csTTabla, _
                     cscTblId, _
                     tbl_id, _
                     cscTblCampoNombre, _
                     field_name, _
                     "pGetFieldName", _
                     C_Module) Then
    Exit Function
  End If
  
  pGetFieldName = True
End Function

Private Function pGetFieldId(ByVal tbl_id As Long, _
                             ByRef field_id As String) As Boolean
  If Not gDB.GetData(csTTabla, _
                     cscTblId, _
                     tbl_id, _
                     cscTblCampoId, _
                     field_id, _
                     "pGetFieldName", _
                     C_Module) Then
    Exit Function
  End If
  
  pGetFieldId = True
End Function

Private Function pGetKey(ByVal idx As Long) As String
  pGetKey = "add_field_" & idx
End Function

Private Function pGetName(ByVal name As String) As String
  If Left$(name, 6) = "@@lng:" Then
    Dim lngi_codigo As String
    lngi_codigo = Mid$(name, 7)
    pGetName = LNGGetText(lngi_codigo, name)
  Else
    pGetName = name
  End If
End Function

' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError

  Set m_properties = New cGenericEditProperties

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
  On Error GoTo ControlError

  m_properties.Clear
  Set m_properties = Nothing

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Terminate", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
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

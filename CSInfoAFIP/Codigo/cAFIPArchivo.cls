VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cAFIPArchivo"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGeneric
Implements CSInterfacesABM.cIABMClient
Implements CSInterfacesABM.cIABMClientGrid

'--------------------------------------------------------------------------------
' cAFIPArchivo
' 11-07-03

'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cAFIPArchivo"

Private Const K_NOMBRE                         As Integer = 1
Private Const K_DESCRIP                        As Integer = 2
Private Const K_SEPARADORREGISTRO              As Integer = 3
Private Const K_OBJETOENTRADA                  As Integer = 4
Private Const K_AFESQ_ID                       As Integer = 5
Private Const K_ACTIVO                         As Integer = 6
Private Const K_REGISTROS                      As Integer = 7
Private Const K_TOOLBAR_REGISTROS              As Integer = 8

Private Const KI_AFREG_ID                       As Integer = 1
Private Const KI_NOMBRE                         As Integer = 2
Private Const KI_DESCRIP                        As Integer = 3
Private Const KI_OBJETOPROCESO                  As Integer = 4
Private Const KI_ACTIVO                         As Integer = 6

Private Const c_GridRegistros    As String = "REGISTROS"
Private Const c_ToolBarRegistros As String = "ToolBarRegistros"

' estructuras
' Seudo - Variables
Private c_ErrorSave                    As String

' variables privadas
Private m_Id                           As Long
Private m_Nombre                       As String
Private m_Descrip                      As String
Private m_SeparadorRegistro            As String
Private m_Objetoentrada                As String
Private m_Afesq_id                     As Long
Private m_Esquema                      As String
Private m_Creado                       As Date
Private m_Modificado                   As Date
Private m_Modifico                     As Long
Private m_Activo                       As Boolean

'OJO HASTA ACA
Private m_Title2            As String
Private m_Editing           As Boolean

Private m_ObjectIn          As cIAFIPEntrada


Private m_ObjAbm            As cIABMGeneric
Private m_ObjTree           As Object

Private m_IsNew             As Boolean

Private m_BranchId          As Long
Private m_TreeId            As Long

Private m_ItemsDeletedRegistros       As String

Private m_RegistrosToCopy   As cAFIPRegistros
Private m_Copy              As Boolean

' propiedades publicas
Public Property Get ObjectIn() As cIAFIPEntrada
   Set ObjectIn = m_ObjectIn
End Property

Public Property Set ObjectIn(ByRef RHS As cIAFIPEntrada)
   Set m_ObjectIn = RHS
End Property

Public Property Let Title2(ByVal RHS As String)
  m_Title2 = RHS
End Property
'
Public Property Get ID() As Long
  ID = m_Id
End Property
'
'Public Property Let ID(ByVal RHS As Long)
'  m_Id = RHS
'End Property
'
Public Property Get Nombre() As String
  Nombre = m_Nombre
End Property
'
'Public Property Let Nombre(ByVal RHS As String)
'  m_Nombre = RHS
'End Property
'
'Public Property Get Descrip() As String
'  Descrip = m_Descrip
'End Property
'
'Public Property Let Descrip(ByVal RHS As String)
'  m_Descrip = RHS
'End Property
'
Public Property Get SeparadorRegistro() As String
  SeparadorRegistro = m_SeparadorRegistro
End Property
'
'Public Property Let SeparadorRegistro(ByVal RHS As String)
'  m_SeparadorRegistro = RHS
'End Property
'
Public Property Get ObjetoEntrada() As String
  ObjetoEntrada = m_Objetoentrada
End Property
'
'Public Property Let ObjetoEntrada(ByVal RHS As String)
'  m_Objetoentrada = RHS
'End Property
'
'Public Property Get afEsq_id() As Long
'  afEsq_id = m_Afesq_id
'End Property
'
Public Property Let Afesq_id(ByVal RHS As Long)
  m_Afesq_id = RHS
End Property
'
'Public Property Get Esquema() As String
'  Esquema = m_Esquema
'End Property
'
'Public Property Let Esquema(ByVal RHS As String)
'  m_Esquema = RHS
'End Property
'
'Public Property Get Creado() As Date
'  Creado = m_Creado
'End Property
'
'Public Property Let Creado(ByVal RHS As Date)
'  m_Creado = RHS
'End Property
'
'Public Property Get Modificado() As Date
'  Modificado = m_Modificado
'End Property
'
'Public Property Let Modificado(ByVal RHS As Date)
'  m_Modificado = RHS
'End Property
'
'Public Property Get Modifico() As Long
'  Modifico = m_Modifico
'End Property
'
'Public Property Let Modifico(ByVal RHS As Long)
'  m_Modifico = RHS
'End Property
'
'Public Property Get Activo() As Boolean
'  Activo = m_Activo
'End Property
'
'Public Property Let Activo(ByVal RHS As Boolean)
'  m_Activo = RHS
'End Property
' propiedades privadas
' funciones publicas


' Implementacion de cIABMClient
Private Function cIABMClient_Copy() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True
  
  m_Copy = True
  m_Id = -1
End Function

Private Function cIABMClient_EditNew() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True
  
  cIEditGeneric_Edit csNO_ID
End Function

Private Property Get cIABMClient_Aplication() As String
    cIABMClient_Aplication = gAppName
End Property

Private Property Get cIABMClient_CanAddDocDigital() As Boolean
  cIABMClient_CanAddDocDigital = m_Id <> csNO_ID
End Property

Private Property Get cIABMClient_CanCopy() As Boolean
  cIABMClient_CanCopy = True
End Property

Private Property Get cIABMClient_CanNew() As Boolean
  cIABMClient_CanNew = True
End Property

Private Function cIABMClient_ShowDocDigital() As Boolean
  On Error GoTo ControlError
  
  If m_Id = csNO_ID Then Exit Function
  
  Dim Doc As cDocDigital
  Set Doc = New cDocDigital

  Doc.ClientTable = csTAFIPArchivo
  Doc.ClientTableID = m_Id

  cIABMClient_ShowDocDigital = Doc.ShowDocs(gDB)

  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClient_ShowDocDigital", C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIABMClient_MessageEx(ByVal MessageID As Long, ByVal Info As Variant) As Variant
  cIABMClient_MessageEx = True
End Function

Private Sub cIABMClient_DiscardChanges()
    LoadCollection
End Sub

Private Function cIABMClient_ListAdHock(List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClient_Load()

End Sub

Private Function cIABMClient_PropertyChange(ByVal Key As Integer) As Boolean
  Select Case Key
    Case K_TOOLBAR_REGISTROS
      pToolBarRegistrosClick m_ObjAbm.Properties(c_ToolBarRegistros).Value
  End Select
End Function

Private Function cIABMClient_Save() As Boolean
  Dim realId      As Long
  Dim EsqPresent  As Boolean
  Dim register    As cRegister
  
  Set register = New cRegister
  register.fieldId = cscAfArchId
  register.Table = csTAFIPArchivo
  
  If m_Copy Then
    If m_RegistrosToCopy Is Nothing Then
      If Not BeginCopy() Then Exit Function
    End If
    register.ID = csNew
  Else
    register.ID = m_Id
  End If
  
  Dim IProperty As cIABMProperty
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_NOMBRE
          register.Fields.Add2 cscAfArchNombre, .Value, csText
        Case K_DESCRIP
          register.Fields.Add2 cscAfArchDescrip, .Value, csText
        Case K_SEPARADORREGISTRO
          register.Fields.Add2 cscAfArchSeparadorregistro, .Value, csText
        Case K_OBJETOENTRADA
          register.Fields.Add2 cscAfArchObjetoentrada, .Value, csText
        Case K_AFESQ_ID
          EsqPresent = True
          register.Fields.Add2 cscAfEsqId, .HelpId, csId
        Case K_ACTIVO
          register.Fields.Add2 cscActivo, .Value, csBoolean
      End Select
    End With
  Next
  
  If Not EsqPresent Then
    register.Fields.Add2 cscAfEsqId, m_Afesq_id, csId
  End If
  
  register.Fields.HaveLastUpdate = True
  register.Fields.HaveWhoModify = True
  
  If Not register.BeginTrans(gDB) Then Exit Function
  
  If Not gDB.Save(register, , "cIABMClient_Save", C_Module, c_ErrorSave) Then Exit Function
  
  realId = m_Id
  m_Id = register.ID
  
  If Not pSaveItemsRegistros() Then GoTo ExitProc
  
  If m_Copy Then
    If Not m_RegistrosToCopy.EndCopy(m_Id) Then GoTo ExitProc
  End If
  
  If Not register.CommitTrans() Then GoTo ExitProc
  realId = m_Id
  
  m_Copy = False
  cIABMClient_Save = Load(register.ID)
  
ExitProc:
  m_Id = realId
End Function

Private Function cIABMClient_Terminate() As Boolean
    m_Editing = False
    
    cIABMClient_Terminate = True
    ' Este objeto puede no cumplir con la interfaz esperada, asi que si hay un error no
    ' le doy bola
    On Error GoTo ControlError
    If m_Id = csNO_ID Then Exit Function
    If m_ObjTree Is Nothing Then Exit Function
    
    If TypeOf m_ObjTree Is cAFIPEsquema Then
      Dim Esq As cAFIPEsquema
      Set Esq = m_ObjTree
      If m_IsNew Then
          Esq.AddArchivo m_Id
      Else
          Esq.RefreshArchivo m_Id
      End If
    Else
      If m_IsNew Then
          m_ObjTree.AddLeave m_Id, m_BranchId, m_TreeId
      Else
          m_ObjTree.AddEditedId m_Id
          m_ObjTree.RefreshActiveBranch
      End If
    End If
ControlError:
End Function

Private Property Get cIABMClient_Title() As String
    cIABMClient_Title = LNGGetText(3351, vbNullString) 'AFIP Archivos
End Property

Private Function cIABMClient_Validate() As Boolean

  Dim IProperty As cIABMProperty

  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_NOMBRE
          If ValEmpty(.Value, csText) Then
            MsgInfo LNGGetText(1007, vbNullString) 'Debe indicar un nombre
            Exit Function
          End If
        Case K_OBJETOENTRADA
          If ValEmpty(.Value, csText) Then
            MsgInfo LNGGetText(3352, vbNullString) 'Debe indicar un Objeto de entrada
            Exit Function
          End If
      
      End Select
    End With
  Next

  cIABMClient_Validate = True
End Function

Private Function cIABMClientGrid_ColumnAfterUpdate(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long) As Boolean

End Function

' Implementacion de cIEditGeneric

Private Function cIEditGeneric_TabClick(ByVal Index As Integer) As Boolean

End Function

Private Property Get cIEditGeneric_ObjAbm() As CSInterfacesABM.cIABMGeneric
  Set cIEditGeneric_ObjAbm = m_ObjAbm
End Property

Private Property Let cIEditGeneric_TreeId(ByVal RHS As Long)
    m_TreeId = RHS
End Property

Private Property Get cIEditGeneric_TreeId() As Long
    cIEditGeneric_TreeId = m_TreeId
End Property

Private Function cIEditGeneric_GridAdd(ByVal ClavePropiedad As Integer) As Boolean

End Function

Private Function cIEditGeneric_GridEdit(ByVal ClavePropiedad As Integer) As Boolean

End Function

Private Function cIEditGeneric_GridRemove(ByVal ClavePropiedad As Integer) As Boolean

End Function

Private Function cIEditGeneric_ShowList() As Boolean
    cIEditGeneric_ShowList = SecurityCanAccess(csInfoAFIPListAFIPArchivo)
End Function

Private Property Set cIEditGeneric_ObjAbm(RHS As CSInterfacesABM.cIABMGeneric)
    Set m_ObjAbm = RHS
End Property

Private Property Get cIEditGeneric_Editing() As Boolean
    cIEditGeneric_Editing = m_Editing
End Property

Private Function cIEditGeneric_Delete(ID As Long) As Boolean
    If Not SecurityCanAccess(csInfoAFIPDeleteAFIPArchivo) Then Exit Function

    Dim sqlstmt           As String
    Dim sqlstmtRegistro   As String
    
    sqlstmtRegistro = "afreg_id in (select afreg_id from afipregistro where afarch_id = " & ID & ")" & vbCrLf
        
    sqlstmt = "Delete " & csTAFIPCampo & " where " & sqlstmtRegistro & vbCrLf
    sqlstmt = sqlstmt & "Delete " & csTAFIPRegistro & " where " & cscAfArchId & " = " & ID & vbCrLf
    sqlstmt = sqlstmt & "Delete " & csTAFIPArchivo & " where " & cscAfArchId & " = " & ID
    
    cIEditGeneric_Delete = gDB.Execute(sqlstmt, "cIEditGeneric_Delete", "cAFIPArchivo")
End Function

Private Function cIEditGeneric_Search(ID As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(ID As Long, Optional ByVal InModalWindow As Boolean) As Boolean
    On Error GoTo ControlError
    
    If ID = csNO_ID Then
        m_IsNew = True
        If Not SecurityCanAccess(csInfoAFIPNewAFIPArchivo) Then Exit Function
    Else
        m_IsNew = False
        If Not SecurityCanAccess(csInfoAFIPEditAFIPArchivo) Then Exit Function
    End If

    If Not Load(ID) Then Exit Function
    
    If Not LoadCollection() Then Exit Function
    
    m_Editing = True
    m_Copy = False
    
    cIEditGeneric_Edit = True
    Exit Function
ControlError:
    MngError Err, "cIEditGeneric_Edit", C_Module, vbNullString
End Function

Private Function cIEditGeneric_PrintObj(ByVal ID As Long) As Boolean

End Function

Private Property Set cIEditGeneric_ObjTree(RHS As Object)
    Set m_ObjTree = RHS
End Property

Private Property Let cIEditGeneric_BranchId(ByVal RHS As Long)
    m_BranchId = RHS
End Property

Private Property Get cIEditGeneric_BranchId() As Long
    cIEditGeneric_BranchId = m_BranchId
End Property

Private Function cIEditGeneric_Preview(ByVal ID As Long) As Boolean

End Function

Private Function cIEditGeneric_PropertyChange(ByVal Key As Integer) As Boolean

End Function

Private Function cIABMClientGrid_ColumnAfterEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long) As Boolean
  cIABMClientGrid_ColumnAfterEdit = True
End Function

Private Function cIABMClientGrid_IsEmptyRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_REGISTROS
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowRegistros(Row, RowIndex)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ValidateRow", C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIABMClientGrid_ColumnBeforeEdit(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean
  cIABMClientGrid_ColumnBeforeEdit = True
End Function

Private Function cIABMClientGrid_ColumnButtonClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean

End Function

Private Sub cIABMClientGrid_ColumnCancelEdit(ByVal Key As Integer)

End Sub

Private Sub cIABMClientGrid_ColumnClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)

End Sub

Private Sub cIABMClientGrid_DblClick(ByVal Key As Integer, ByVal lRow As Long, ByVal lCol As Long)
  pToolBarRegistrosClick "EDIT"
End Sub

Private Function cIABMClientGrid_DeleteRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal lRow As Long) As Boolean
  Dim ID As Long
  
  ID = Val(pCell(Row, KI_AFREG_ID).Value)
  
  If ID <> csNO_ID Then m_ItemsDeletedRegistros = m_ItemsDeletedRegistros & ID & ","
  
  cIABMClientGrid_DeleteRow = True
End Function

Private Function cIABMClientGrid_ListAdHock(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal ColIndex As Long, List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClientGrid_NewRow(ByVal Key As Integer, ByVal Rows As Integer)

End Sub

Private Function cIABMClientGrid_ValidateRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_REGISTROS
      cIABMClientGrid_ValidateRow = pValidateRowRegistros(Row, RowIndex)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ValidateRow", C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pIsEmptyRowRegistros(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim bRowIsEmpty           As Boolean
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_OBJETOPROCESO
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KI_NOMBRE
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  pIsEmptyRowRegistros = bRowIsEmpty
End Function

Private Function pValidateRowRegistros(Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.Key
        Case KI_NOMBRE
          If ValEmpty(Cell.Value, csText) Then
            MsgInfo LNGGetText(1811, vbNullString, strRow) 'Debe indicar un nombre (1)
            Exit Function
          End If
        Case KI_OBJETOPROCESO
          If ValEmpty(Cell.Value, csText) Then
            MsgInfo LNGGetText(3353, vbNullString) 'Debe indicar un Objeto de proceso (1)
            Exit Function
          End If
    End Select
  Next
  
  pValidateRowRegistros = True
End Function

Public Function Load(ByVal ID As Long) As Boolean
  Dim sqlstmt As String

  sqlstmt = sqlstmt & "select AFIPArchivo.*,afesq_nombre from AFIPArchivo,AFIPEsquema where afarch_id = " & ID
  sqlstmt = sqlstmt & " and AFIPArchivo.afesq_id = AFIPEsquema.afesq_id "

  Dim rs As Recordset

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "Load", C_Module) Then Exit Function

  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.Fields, cscAfArchId)
    m_Nombre = gDB.ValField(rs.Fields, cscAfArchNombre)
    m_Descrip = gDB.ValField(rs.Fields, cscAfArchDescrip)
    m_SeparadorRegistro = gDB.ValField(rs.Fields, cscAfArchSeparadorregistro)
    m_Objetoentrada = gDB.ValField(rs.Fields, cscAfArchObjetoentrada)
    m_Afesq_id = gDB.ValField(rs.Fields, cscAfEsqId)
    m_Esquema = gDB.ValField(rs.Fields, cscAfEsqNombre)
    m_Creado = gDB.ValField(rs.Fields, cscCreado)
    m_Modificado = gDB.ValField(rs.Fields, cscModificado)
    m_Modifico = gDB.ValField(rs.Fields, cscModifico)
    m_Activo = gDB.ValField(rs.Fields, cscActivo)

  Else
    m_Id = csNO_ID
    m_Nombre = vbNullString
    m_Descrip = vbNullString
    m_SeparadorRegistro = vbNullString
    m_Objetoentrada = vbNullString
    m_Afesq_id = csNO_ID
    m_Esquema = vbNullString
    m_Creado = csNoDate
    m_Modificado = csNoDate
    m_Modifico = 0
    m_Activo = False

  End If

  Load = True
End Function

Friend Function AddRegistro(ByVal ID As Long) As Boolean
  RefreshRegistro ID
End Function

Friend Function RefreshRegistro(ByVal ID As Long) As Boolean
  Dim c As cIABMProperty
  Set c = m_ObjAbm.Properties(c_GridRegistros)
  If Not pLoadRegistros(c) Then Exit Function
  m_ObjAbm.RefreshControls False
End Function

Friend Function EndCopy(ByVal Afesq_id As Long) As Boolean
  m_Afesq_id = Afesq_id
  If Not pSaveCopy() Then Exit Function
  
  m_Copy = False
  EndCopy = True
End Function

Friend Function BeginCopy() As Boolean
  Set m_RegistrosToCopy = New cAFIPRegistros
  
  If Not m_RegistrosToCopy.Load(m_Id) Then Exit Function
  If Not m_RegistrosToCopy.BeginCopy() Then Exit Function
  
  m_Copy = True
  BeginCopy = True
End Function

' funciones privadas
Private Function pSaveCopy() As Boolean
  Dim EsqPresent  As Boolean
  Dim register    As cRegister
  
  Set register = New cRegister
  register.fieldId = cscAfArchId
  register.Table = csTAFIPArchivo
  
  register.ID = csNew
  
  register.Fields.Add2 cscAfArchNombre, m_Nombre, csText
  register.Fields.Add2 cscAfArchDescrip, m_Descrip, csText
  register.Fields.Add2 cscAfArchSeparadorregistro, m_SeparadorRegistro, csText
  register.Fields.Add2 cscAfArchObjetoentrada, m_Objetoentrada, csText
  register.Fields.Add2 cscAfEsqId, m_Afesq_id, csId
  register.Fields.Add2 cscActivo, m_Activo, csBoolean
  
  register.Fields.HaveLastUpdate = True
  register.Fields.HaveWhoModify = True
  
  If Not register.BeginTrans(gDB) Then Exit Function
  
  If Not gDB.Save(register, , "pSaveCopy", C_Module, c_ErrorSave) Then Exit Function
  m_Id = register.ID
  
  If Not m_RegistrosToCopy.EndCopy(m_Id) Then Exit Function
  
  If Not register.CommitTrans() Then Exit Function
  
  pSaveCopy = Load(register.ID)
End Function

Private Sub pToolBarRegistrosClick(ByVal ButtonKey As String)
  Dim Index  As Integer
  Dim Obj    As cIEditGeneric
  Dim Row    As cIABMGridRow
  Dim o      As cAFIPRegistro
  
  Set Obj = New cAFIPRegistro
  Set o = Obj
  Set Obj.ObjTree = Me
  
  Select Case ButtonKey
    Case "NEW"
      Set Obj.ObjABM = CreateObject("CSABMInterface2.CABMGeneric")
      o.Title2 = "(Archivo: " & m_ObjAbm.Properties(cscAfArchNombre).Value & ")"
      Obj.ObjABM.Top = m_ObjAbm.Top + 500
      Obj.ObjABM.Left = m_ObjAbm.Left + 500
      Obj.Edit csNO_ID
    Case "EDIT", "DELETE"
      With m_ObjAbm.Properties(c_GridRegistros)
        If .SelectedIndex > 0 Then
          Set Obj.ObjABM = CreateObject("CSABMInterface2.CABMGeneric")
          o.Title2 = "(Archivo: " & m_ObjAbm.Properties(cscAfArchNombre).Value & ")"
          Obj.ObjABM.Top = m_ObjAbm.Top + 500
          Obj.ObjABM.Left = m_ObjAbm.Left + 500
          Set Row = .Grid.Rows(.SelectedIndex)
          If ButtonKey = "EDIT" Then
            Obj.Edit GetCell(Row, KI_AFREG_ID).Value
          Else
            Obj.Delete GetCell(Row, KI_AFREG_ID).Value
          End If
        End If
      End With
  End Select
  
  Dim AFIPRegistro As cAFIPRegistro
  Set AFIPRegistro = Obj
  AFIPRegistro.Afarch_id = Me.ID
End Sub

Private Function LoadCollection() As Boolean
  m_ObjAbm.Properties.Clear
  
  m_ObjAbm.Title2 = m_Title2
  
  Dim c As cIABMProperty

  m_ObjAbm.Tabs.Clear
  
  Dim iTab As cIABMTabItem
  
  Set iTab = m_ObjAbm.Tabs.Add(Nothing)
  iTab.Index = 0
  iTab.Name = C_strGeneral
  

  Set iTab = m_ObjAbm.Tabs.Add(Nothing)
  iTab.Index = 1
  iTab.Name = LNGGetText(3354, vbNullString) 'Registros
  

  Set c = m_ObjAbm.Properties.Add(Nothing, cscAfArchNombre)
  c.PropertyType = cspText
  c.Name = C_strNombre
  c.Size = 50
  c.Key = K_NOMBRE
  c.Value = Nombre
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscActivo)
  c.PropertyType = cspCheck
  c.Name = C_strActivo
  c.Key = K_ACTIVO
  c.Value = CInt(m_Activo)
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscAfArchSeparadorregistro)
  c.PropertyType = cspText
  c.Name = LNGGetText(3355, vbNullString) 'Separador de Registro
  c.Size = 5
  c.Width = 600
  c.Key = K_SEPARADORREGISTRO
  c.Value = SeparadorRegistro
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscAfArchObjetoentrada)
  c.PropertyType = cspText
  c.Name = LNGGetText(3356, vbNullString) 'Objeto de Entrada
  c.Width = 4000
  c.Size = 255
  c.Key = K_OBJETOENTRADA
  c.Value = ObjetoEntrada
  
  Set c = m_ObjAbm.Properties.Add(Nothing, cscAfArchDescrip)
  c.PropertyType = cspText
  c.Name = C_strDescrip
  c.SubType = cspMemo
  c.Width = 5000
  c.Height = 880
  c.Size = 255
  c.Key = K_DESCRIP
  c.Value = m_Descrip
  
  Set c = m_ObjAbm.Properties.Add(Nothing, c_ToolBarRegistros)
  c.PropertyType = cspToolBar
  c.Name = LNGGetText(3357, vbNullString) 'ToolBar
  c.TabIndex = 1
  c.Width = 1350
  c.LeftFrame = 6850
  c.TopFrame = 870
  c.Enabled = m_Id <> csNO_ID
  c.Key = K_TOOLBAR_REGISTROS
  c.Buttons = BUTTON_DELETE + BUTTON_EDIT + BUTTON_NEW
  
  Set c = m_ObjAbm.Properties.Add(Nothing, c_GridRegistros)
  c.PropertyType = cspGrid
  c.LeftLabel = -1
  If Not pLoadRegistros(c) Then Exit Function
  c.Name = LNGGetText(3354, vbNullString) 'Registros
  c.Key = K_REGISTROS
  c.Top = 1400
  c.TabIndex = 1
  c.GridAdd = False
  c.GridEdit = False
  c.GridRemove = True
  
  m_ItemsDeletedRegistros = vbNullString
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

Private Function pSaveItemsRegistros() As Boolean
  Dim register As cRegister
  Dim IProperty As cIABMProperty
  
  pSaveItemsRegistros = True
  Exit Function
  
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_REGISTROS
        
          Dim Row  As cIABMGridRow
          Dim Cell As cIABMGridCellValue
          
          For Each Row In IProperty.Grid.Rows
          
            Set register = New cRegister
            register.fieldId = cscAfRegId
            register.Table = csTAFIPRegistro
            register.ID = csNew
            
            For Each Cell In Row
              Select Case Cell.Key
                
                Case KI_AFREG_ID
                  If Not m_Copy Then
                    register.ID = Val(Cell.Value)
                  End If
                Case KI_NOMBRE
                  register.Fields.Add2 cscAfRegNombre, Cell.Value, csText
                Case KI_DESCRIP
                  register.Fields.Add2 cscAfRegDescrip, Cell.Value, csText
                Case KI_OBJETOPROCESO
                  register.Fields.Add2 cscAfRegObjetoproceso, Cell.Value, csText
                Case KI_ACTIVO
                  register.Fields.Add2 cscActivo, Cell.ID, csBoolean

              End Select
            Next
            
            register.Fields.Add2 cscAfArchId, m_Id, csId
            
            register.Fields.HaveLastUpdate = True
            register.Fields.HaveWhoModify = True
            
            If Not gDB.Save(register, , "pSaveItemsRegistros", vbNullString, c_ErrorSave) Then Exit Function
          Next
      End Select
    End With
  Next
  
  Dim sqlstmt As String
  
  If LenB(m_ItemsDeletedRegistros) And Not m_Copy Then
    m_ItemsDeletedRegistros = RemoveLastColon(m_ItemsDeletedRegistros)
    sqlstmt = "delete " & csTAFIPRegistro & " where afreg_id in (" & m_ItemsDeletedRegistros & ")"
  
    If Not gDB.Execute(sqlstmt, "pSaveItemsRegistros", C_Module) Then Exit Function
  End If
  
  pSaveItemsRegistros = True
End Function

Private Function pLoadRegistros(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  
  Dim rs As ADODB.Recordset
  
  sqlstmt = "select AFIPRegistro.*" & _
            " from AFIPRegistro" & _
              " where afarch_id = " & m_Id
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadRegistros", C_Module) Then Exit Function
  
  Dim o As cIABMGridColumn
  
  Propiedad.Grid.Columns.Clear
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = "afreg_id"
  o.Visible = False
  o.Key = KI_AFREG_ID
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = C_strNombre
  o.PropertyType = cspText
  o.Width = 1200
  o.Key = KI_NOMBRE
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = C_strDescrip
  o.PropertyType = cspText
  o.Width = 1200
  o.Key = KI_DESCRIP
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = LNGGetText(3358, vbNullString) 'Objeto Proceso
  o.PropertyType = cspText
  o.Width = 1200
  o.Key = KI_OBJETOPROCESO
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = C_strActivo
  o.PropertyType = cspCheck
  o.Width = 1200
  o.Key = KI_ACTIVO
  
  Dim f  As cIABMGridRow
  Dim fv As cIABMGridCellValue
  
  Propiedad.Grid.Rows.Clear
  
  While Not rs.EOF
  
    Set f = Propiedad.Grid.Rows.Add(Nothing, rs(cscAfRegId).Value)
    
    Set fv = f.Add(Nothing)
    fv.Value = rs(cscAfRegId).Value
    fv.Key = KI_AFREG_ID
    
    Set fv = f.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscAfRegNombre)
    fv.Key = KI_NOMBRE
    
    Set fv = f.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscAfRegDescrip)
    fv.Key = KI_DESCRIP
    
    Set fv = f.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscAfRegObjetoproceso)
    fv.Key = KI_OBJETOPROCESO
    
    Set fv = f.Add(Nothing)
    fv.ID = gDB.ValField(rs.Fields, cscActivo)
    fv.Key = KI_ACTIVO
    
    rs.MoveNext
  Wend
  
  pLoadRegistros = True
End Function

' construccion - destruccion

Private Sub Class_Initialize()
  On Error GoTo ControlError

  c_ErrorSave = LNGGetText(3359, vbNullString) 'Error al grabar AFIPArchivo

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
    Set m_ObjAbm = Nothing
    Set m_ObjTree = Nothing
    Set m_ObjectIn = Nothing
    Set m_RegistrosToCopy = Nothing
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


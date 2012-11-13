VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cAFIPRegistro"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGeneric
Implements CSInterfacesABM.cIABMClient
Implements CSInterfacesABM.cIABMClientGrid
'--------------------------------------------------------------------------------
' cAFIPRegistro
' 12-07-03

'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cAFIPRegistro"

Private Const K_NOMBRE                         As Integer = 1
Private Const K_DESCRIP                        As Integer = 2
Private Const K_OBJETOPROCESO                  As Integer = 3
Private Const K_AFARCH_ID                      As Integer = 4
Private Const K_ACTIVO                         As Integer = 5
Private Const K_CAMPOS                         As Integer = 6

Private Const KI_AFCAMPO_ID                     As Integer = 1
Private Const KI_NOMBRE                         As Integer = 2
Private Const KI_DESCRIP                        As Integer = 3
Private Const KI_FORMATOFECHA                   As Integer = 4
Private Const KI_TIPO                           As Integer = 5
Private Const KI_POSICION                       As Integer = 6
Private Const KI_RELLENO                        As Integer = 7
Private Const KI_SEPARADORDECIMAL               As Integer = 8
Private Const KI_CANTDIGITOSENTEROS             As Integer = 9
Private Const KI_CANTDIGITOSDECIMALES           As Integer = 10
Private Const KI_ALINEACION                     As Integer = 11
Private Const KI_COLUMNA                        As Integer = 12
Private Const KI_LARGO                          As Integer = 15
Private Const KI_AFREG_ID                       As Integer = 13
Private Const KI_ACTIVO                         As Integer = 14

' estructuras
' seudo - variables
Private c_ErrorSave                    As String

' variables privadas
Private m_Id                           As Long
Private m_Nombre                       As String
Private m_Descrip                      As String
Private m_Objetoproceso                As String
Private m_Afarch_id                    As Long
Private m_Archivo                      As String
Private m_Creado                       As Date
Private m_Modificado                   As Date
Private m_Modifico                     As Long
Private m_Activo                       As Boolean

Private m_Campos                        As cAFIPCampos

'OJO HASTA ACA
Private m_Title2            As String
Private m_Editing           As Boolean

Private m_ObjectProc        As cIAFIPProceso

Private m_ObjAbm            As cIABMGeneric
Private m_ObjTree           As Object

Private m_IsNew             As Boolean

Private m_BranchId          As Long
Private m_TreeId            As Long

Private m_ItemsDeletedCampos            As String

Private m_Copy              As Boolean
' propiedades publicas
Public Property Get Campos() As cAFIPCampos
   Set Campos = m_Campos
End Property

Public Property Get ObjectProc() As cIAFIPProceso
   Set ObjectProc = m_ObjectProc
End Property

Public Property Set ObjectProc(ByRef rhs As cIAFIPProceso)
   Set m_ObjectProc = rhs
End Property

Public Property Let Title2(ByVal rhs As String)
  m_Title2 = rhs
End Property

Public Property Get ID() As Long
  ID = m_Id
End Property

Public Property Get Nombre() As String
  Nombre = m_Nombre
End Property

Public Property Get ObjetoProceso() As String
  ObjetoProceso = m_Objetoproceso
End Property

Public Property Let Afarch_id(ByVal rhs As Long)
  m_Afarch_id = rhs
End Property

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

  Doc.ClientTable = csTAFIPRegistro
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

Private Function cIABMClient_PropertyChange(ByVal Clave As Integer) As Boolean

End Function

Private Function cIABMClient_Save() As Boolean
  Dim realId      As Long
  Dim ArchPresent As Boolean
  Dim register    As cRegister
  Set register = New cRegister
  register.fieldId = cscAfRegId
  register.Table = csTAFIPRegistro
  
  If m_Copy Then
    If m_Campos.Count = 0 Then
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
          register.Fields.Add2 cscAfRegNombre, .Value, csText
        Case K_DESCRIP
          register.Fields.Add2 cscAfRegDescrip, .Value, csText
        Case K_OBJETOPROCESO
          register.Fields.Add2 cscAfRegObjetoproceso, .Value, csText
        Case K_AFARCH_ID
          ArchPresent = True
          register.Fields.Add2 cscAfArchId, .HelpID, csId
        Case K_ACTIVO
          register.Fields.Add2 cscActivo, .Value, csBoolean

      End Select
    End With
  Next
  
  If Not ArchPresent Then
    register.Fields.Add2 cscAfArchId, m_Afarch_id, csId
  End If
  
  register.Fields.HaveLastUpdate = True
  register.Fields.HaveWhoModify = True
  
  If Not register.BeginTrans(gDB) Then Exit Function
  
  If Not gDB.Save(register, , "cIABMClient_Save", C_Module, c_ErrorSave) Then Exit Function
  
  realId = m_Id
  m_Id = register.ID
  
  If Not pSaveItemsCampos() Then GoTo ExitProc
  
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
    
    If TypeOf m_ObjTree Is cAFIPArchivo Then
      Dim Arch As cAFIPArchivo
      Set Arch = m_ObjTree
      If m_IsNew Then
          Arch.AddRegistro m_Id
      Else
          Arch.RefreshRegistro m_Id
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
    cIABMClient_Title = LNGGetText(3420, vbNullString) 'AFIP Registros
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
        Case K_OBJETOPROCESO
          If ValEmpty(.Value, csText) Then
            MsgInfo LNGGetText(3421, vbNullString) 'Debe indicar un objeto de proceso
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

Private Property Let cIEditGeneric_TreeId(ByVal rhs As Long)
    m_TreeId = rhs
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
    cIEditGeneric_ShowList = SecurityCanAccess(csInfoAFIPListAFIPRegistro)
End Function

Private Property Get cIEditGeneric_ObjAbm() As CSInterfacesABM.cIABMGeneric
  Set cIEditGeneric_ObjAbm = m_ObjAbm
End Property

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)
    Set m_ObjAbm = rhs
End Property

Private Property Get cIEditGeneric_Editing() As Boolean
    cIEditGeneric_Editing = m_Editing
End Property

Private Function cIEditGeneric_Delete(ID As Long) As Boolean
    If Not SecurityCanAccess(csInfoAFIPDeleteAFIPRegistro) Then Exit Function

    Dim sqlstmt As String
    
    sqlstmt = "Delete AFIPRegistro where AfReg_id = " & ID
    
    cIEditGeneric_Delete = gDB.Execute(sqlstmt, "cIEditGeneric_Delete", C_Module)
End Function

Private Function cIEditGeneric_Search(ID As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(ID As Long, Optional ByVal InModalWindow As Boolean) As Boolean
    On Error GoTo ControlError
    
    If ID = csNO_ID Then
        m_IsNew = True
        If Not SecurityCanAccess(csInfoAFIPNewAFIPRegistro) Then Exit Function
    Else
        m_IsNew = False
        If Not SecurityCanAccess(csInfoAFIPEditAFIPRegistro) Then Exit Function
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

Private Property Set cIEditGeneric_ObjTree(rhs As Object)
    Set m_ObjTree = rhs
End Property

Private Property Let cIEditGeneric_BranchId(ByVal rhs As Long)
    m_BranchId = rhs
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
    Case K_CAMPOS
      cIABMClientGrid_IsEmptyRow = pIsEmptyRowCampos(Row, RowIndex)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_IsEmptyRow", C_Module, vbNullString
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

End Sub

Private Function cIABMClientGrid_DeleteRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal lRow As Long) As Boolean
  Dim ID As Long
  
  ID = Val(pCell(Row, KI_AFCAMPO_ID).Value)
  
  If ID <> csNO_ID Then m_ItemsDeletedCampos = m_ItemsDeletedCampos & ID & ","
  
  cIABMClientGrid_DeleteRow = True
End Function

Private Function cIABMClientGrid_ListAdHock(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal ColIndex As Long, List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClientGrid_NewRow(ByVal Key As Integer, ByVal Rows As Integer)

End Sub

Private Function cIABMClientGrid_ValidateRow(ByVal Key As Integer, Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  On Error GoTo ControlError

  Select Case Key
    Case K_CAMPOS
      cIABMClientGrid_ValidateRow = pValidateRowCampos(Row, RowIndex)
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClientGrid_ValidateRow", C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Public Function Load(ByVal ID As Long) As Boolean
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  sqlstmt = "select AFIPRegistro.*,afarch_nombre " & _
            " from AFIPRegistro, AFIPArchivo" & _
              " where afreg_id = " & ID & _
                " and AFIPRegistro.afarch_id = AFIPArchivo.afarch_id" & vbCrLf

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "Load", C_Module) Then Exit Function

  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.Fields, cscAfRegId)
    m_Nombre = gDB.ValField(rs.Fields, cscAfRegNombre)
    m_Descrip = gDB.ValField(rs.Fields, cscAfRegDescrip)
    m_Objetoproceso = gDB.ValField(rs.Fields, cscAfRegObjetoproceso)
    m_Afarch_id = gDB.ValField(rs.Fields, cscAfArchId)
    m_Archivo = gDB.ValField(rs.Fields, cscAfArchNombre)
    m_Creado = gDB.ValField(rs.Fields, cscCreado)
    m_Modificado = gDB.ValField(rs.Fields, cscModificado)
    m_Modifico = gDB.ValField(rs.Fields, cscModifico)
    m_Activo = gDB.ValField(rs.Fields, cscActivo)

  Else
    m_Id = csNO_ID
    m_Nombre = vbNullString
    m_Descrip = vbNullString
    m_Objetoproceso = vbNullString
    m_Afarch_id = csNO_ID
    m_Archivo = vbNullString
    m_Creado = csNoDate
    m_Modificado = csNoDate
    m_Modifico = 0
    m_Activo = False

  End If

  Load = True
End Function

Private Function pIsEmptyRowCampos(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim bRowIsEmpty           As Boolean
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KI_NOMBRE
        If Not ValEmpty(Cell.Value, csText) Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KI_TIPO
        If Not ValEmpty(Cell.Value, csInteger) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
    pIsEmptyRowCampos = bRowIsEmpty
End Function

Private Function pValidateRowCampos(Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.Key
        Case KI_NOMBRE
          If ValEmpty(Cell.Value, csText) Then
            MsgInfo LNGGetText(1811, vbNullString, strRow) 'Debe indicar un nombre(1)
            Exit Function
          End If
'        Case KI_TIPO
'          If ValEmpty(Cell.Value, csInteger) Then
'            MsgInfo LNGGetText(1813, vbNullString, strRow)
'                      'Debe indicar un tipo (1)
'            Exit Function
'          End If
        Case KI_POSICION
          If ValEmpty(Cell.Value, csInteger) Then
            MsgInfo LNGGetText(3422, vbNullString, strRow)
                                'Debe indicar una Posición (1)
            Exit Function
          End If
        Case KI_ALINEACION
          If ValEmpty(Cell.ID, csInteger) Then
            MsgInfo LNGGetText(3423, vbNullString, strRow)
                        'Debe indicar una alineación (1)
            Exit Function
          End If
        Case KI_LARGO
          If ValEmpty(Cell.Value, csInteger) Then
            MsgInfo LNGGetText(3424, vbNullString, strRow)
                        'Debe indicar un tamaño de campo (1)
            Exit Function
          End If
        Case KI_COLUMNA
          If ValEmpty(Cell.Value, csText) Then
            MsgInfo LNGGetText(2724, vbNullString, strRow)
                        'Debe indicar una columna (1)
            Exit Function
          End If
    End Select
  Next
  
  pValidateRowCampos = True
End Function

' funcions friend
Friend Function EndCopy(ByVal Afarch_id As Long) As Boolean
  m_Afarch_id = Afarch_id
  If Not pSaveCopy() Then Exit Function
  
  m_Copy = False
  EndCopy = True
End Function

Friend Function BeginCopy() As Boolean
  
  If Not m_Campos.Load(m_Id) Then Exit Function
  
  m_Copy = True
  BeginCopy = True
End Function

' funciones privadas
Private Function pSaveCopy() As Boolean
  Dim ArchPresent As Boolean
  Dim register As cRegister
  Set register = New cRegister
  register.fieldId = cscAfRegId
  register.Table = csTAFIPRegistro
  
  register.ID = csNew

  register.Fields.Add2 cscAfRegNombre, m_Nombre, csText
  register.Fields.Add2 cscAfRegDescrip, m_Descrip, csText
  register.Fields.Add2 cscAfRegObjetoproceso, m_Objetoproceso, csText
  register.Fields.Add2 cscAfArchId, m_Afarch_id, csId
  register.Fields.Add2 cscActivo, m_Activo, csBoolean
  
  register.Fields.HaveLastUpdate = True
  register.Fields.HaveWhoModify = True
  
  If Not register.BeginTrans(gDB) Then Exit Function
  
  If Not gDB.Save(register, , "pSaveCopy", C_Module, c_ErrorSave) Then Exit Function
  m_Id = register.ID
  
  If Not pSaveCopyCampos() Then Exit Function
  
  If Not register.CommitTrans() Then Exit Function
  
  pSaveCopy = Load(register.ID)
End Function

Private Function pSaveCopyCampos() As Boolean
  Dim register  As cRegister
  Dim Campo     As cAFIPCampo
  
  For Each Campo In m_Campos
  
    Set register = New cRegister
    register.fieldId = cscAfCampoId
    register.Table = csTAFIPCampo
    register.ID = csNew
    
    With Campo
      register.Fields.Add2 cscAfCampoNombre, .Nombre, csText
      register.Fields.Add2 cscAfCampoDescrip, .Descrip, csText
      register.Fields.Add2 cscAfCampoFormatoFecha, .FormatoFecha, csText
      register.Fields.Add2 cscAfCampoTipo, .Tipo, csInteger
      register.Fields.Add2 cscAfCampoPosicion, .Posicion, csInteger
      register.Fields.Add2 cscAfCampoRelleno, .Relleno, csText
      register.Fields.Add2 cscAfCampoSeparadorDecimal, .SeparadorDecimal, csText
      register.Fields.Add2 cscAfCampoCantDigitosEnteros, .CantDigitosEnteros, csInteger
      register.Fields.Add2 cscAfCampoCantDigitosDecimales, .CantDigitosDecimales, csInteger
      register.Fields.Add2 cscAfCampoAlineacion, .Alineacion, csInteger
      register.Fields.Add2 cscAfCampoColumna, .Columna, csText
      register.Fields.Add2 cscAfCampoLargo, .Largo, csInteger
      register.Fields.Add2 cscActivo, .Activo, csBoolean
    End With
    
    register.Fields.Add2 cscAfRegId, m_Id, csId
    
    register.Fields.HaveLastUpdate = True
    register.Fields.HaveWhoModify = True
    
    If Not gDB.Save(register, , "pSaveItemsCampos", C_Module, c_ErrorSave) Then Exit Function
  Next
  
  pSaveCopyCampos = True
End Function

Private Function pSaveItemsCampos() As Boolean
  Dim register As cRegister
  Dim IProperty As cIABMProperty
  
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_CAMPOS
        
          Dim Row  As cIABMGridRow
          Dim Cell As cIABMGridCellValue
          
          For Each Row In IProperty.Grid.Rows
          
            Set register = New cRegister
            register.fieldId = cscAfCampoId
            register.Table = csTAFIPCampo
            register.ID = csNew
            
            For Each Cell In Row
              Select Case Cell.Key
                
                Case KI_AFCAMPO_ID
                  If Not m_Copy Then
                    register.ID = Val(Cell.Value)
                  End If
                Case KI_NOMBRE
                  register.Fields.Add2 cscAfCampoNombre, Cell.Value, csText
                Case KI_DESCRIP
                  register.Fields.Add2 cscAfCampoDescrip, Cell.Value, csText
                Case KI_FORMATOFECHA
                  register.Fields.Add2 cscAfCampoFormatoFecha, Cell.Value, csText
                Case KI_TIPO
                  register.Fields.Add2 cscAfCampoTipo, Val(Cell.Value), csInteger
                Case KI_POSICION
                  register.Fields.Add2 cscAfCampoPosicion, Val(Cell.Value), csInteger
                Case KI_RELLENO
                  register.Fields.Add2 cscAfCampoRelleno, Cell.Value, csText
                Case KI_SEPARADORDECIMAL
                  register.Fields.Add2 cscAfCampoSeparadorDecimal, Cell.Value, csText
                Case KI_CANTDIGITOSENTEROS
                  register.Fields.Add2 cscAfCampoCantDigitosEnteros, Val(Cell.Value), csInteger
                Case KI_CANTDIGITOSDECIMALES
                  register.Fields.Add2 cscAfCampoCantDigitosDecimales, Val(Cell.Value), csInteger
                Case KI_ALINEACION
                  register.Fields.Add2 cscAfCampoAlineacion, Cell.ID, csInteger
                Case KI_COLUMNA
                  register.Fields.Add2 cscAfCampoColumna, Cell.Value, csText
                Case KI_LARGO
                  register.Fields.Add2 cscAfCampoLargo, Val(Cell.Value), csInteger
                Case KI_ACTIVO
                  register.Fields.Add2 cscActivo, Cell.ID, csBoolean
              End Select
            Next
            
            ' Por ahora fijo
            register.Fields.Add2 cscActivo, 1, csBoolean
            
            register.Fields.Add2 cscAfRegId, m_Id, csId
            
            register.Fields.HaveLastUpdate = True
            register.Fields.HaveWhoModify = True
            
            If Not gDB.Save(register, , "pSaveItemsCampos", C_Module, c_ErrorSave) Then Exit Function
          Next
      End Select
    End With
  Next
  
  Dim sqlstmt As String
  
  If LenB(m_ItemsDeletedCampos) And Not m_Copy Then
    m_ItemsDeletedCampos = RemoveLastColon(m_ItemsDeletedCampos)
    sqlstmt = "delete AFIPCampo where afcampo_id in (" & m_ItemsDeletedCampos & ")"
  
    If Not gDB.Execute(sqlstmt, "pSaveItemsCampos", C_Module) Then Exit Function
  End If
  
  pSaveItemsCampos = True
End Function

Private Function pLoadCampos(ByRef Propiedad As cIABMProperty) As Boolean
  Dim sqlstmt As String
  
  Dim rs As ADODB.Recordset
  
  sqlstmt = "select AFIPCampo.* from AFIPCampo" & _
             " where afreg_id = " & m_Id & _
            " order by " & cscAfCampoPosicion
  
  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, "pLoadCampos", C_Module) Then Exit Function
  
  Dim o As cIABMGridColumn
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = "afcampo_id"
  o.Visible = False
  o.Key = KI_AFCAMPO_ID
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = C_strNombre
  o.PropertyType = cspText
  o.Width = 1800
  o.Key = KI_NOMBRE
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = LNGGetText(1569, vbNullString) 'Fecha
  o.PropertyType = cspText
  o.Width = 1000
  o.Key = KI_FORMATOFECHA
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = LNGGetText(1223, vbNullString) 'Tipo
  o.PropertyType = cspNumeric
  o.SubType = cspInteger
  o.Width = 550
  o.Key = KI_TIPO
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = LNGGetText(3425, vbNullString) 'Indice
  o.PropertyType = cspNumeric
  o.SubType = cspInteger
  o.Width = 700
  o.Key = KI_POSICION
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = LNGGetText(3426, vbNullString) 'Relleno
  o.PropertyType = cspText
  o.Width = 800
  o.Key = KI_RELLENO
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = LNGGetText(3427, vbNullString) 'Sep. Decimal
  o.PropertyType = cspText
  o.Width = 1150
  o.Key = KI_SEPARADORDECIMAL
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = LNGGetText(3428, vbNullString) 'Enteros
  o.PropertyType = cspNumeric
  o.SubType = cspInteger
  o.Width = 800
  o.Key = KI_CANTDIGITOSENTEROS
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = LNGGetText(2867, vbNullString) 'Decimales
  o.PropertyType = cspNumeric
  o.SubType = cspInteger
  o.Width = 1000
  o.Key = KI_CANTDIGITOSDECIMALES
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = LNGGetText(1169, vbNullString) 'Largo
  o.PropertyType = cspNumeric
  o.SubType = cspInteger
  o.Width = 600
  o.Key = KI_LARGO
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = LNGGetText(3429, vbNullString) 'Alineación
  o.PropertyType = cspList
  With o.List
    With .Add(Nothing)
      .ID = c_AlignLeft
      .Value = LNGGetText(3485, vbNullString) 'Izquierda
    End With
    With .Add(Nothing)
      .ID = c_AlignRigth
      .Value = LNGGetText(3486, vbNullString) 'Derecha
    End With
  End With
  o.Width = 1000
  o.Key = KI_ALINEACION
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = LNGGetText(2726, vbNullString) 'Columna
  o.PropertyType = cspText
  o.Width = 800
  o.Key = KI_COLUMNA
  
  Set o = Propiedad.Grid.Columns.Add(Nothing)
  o.Name = C_strDescrip
  o.PropertyType = cspText
  o.Width = 1100
  o.Key = KI_DESCRIP
  
  Dim f  As cIABMGridRow
  Dim fv As cIABMGridCellValue
  
  While Not rs.EOF
  
    Set f = Propiedad.Grid.Rows.Add(Nothing, rs(cscAfCampoId).Value)
    
    Set fv = f.Add(Nothing)
    fv.Value = rs(cscAfCampoId).Value
    fv.Key = KI_AFCAMPO_ID
    
    Set fv = f.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscAfCampoNombre)
    fv.Key = KI_NOMBRE
    
    Set fv = f.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscAfCampoFormatoFecha)
    fv.Key = KI_FORMATOFECHA
    
    Set fv = f.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscAfCampoTipo)
    fv.Key = KI_TIPO
    
    Set fv = f.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscAfCampoPosicion)
    fv.Key = KI_POSICION
    
    Set fv = f.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscAfCampoRelleno)
    fv.Key = KI_RELLENO
    
    Set fv = f.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscAfCampoSeparadorDecimal)
    fv.Key = KI_SEPARADORDECIMAL
    
    Set fv = f.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscAfCampoCantDigitosEnteros)
    fv.Key = KI_CANTDIGITOSENTEROS
    
    Set fv = f.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscAfCampoCantDigitosDecimales)
    fv.Key = KI_CANTDIGITOSDECIMALES
    
    Set fv = f.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscAfCampoLargo)
    fv.Key = KI_LARGO
    
    Set fv = f.Add(Nothing)
    fv.ID = gDB.ValField(rs.Fields, cscAfCampoAlineacion)
    fv.Key = KI_ALINEACION
    
    Set fv = f.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscAfCampoColumna)
    fv.Key = KI_COLUMNA
        
    Set fv = f.Add(Nothing)
    fv.Value = gDB.ValField(rs.Fields, cscAfCampoDescrip)
    fv.Key = KI_DESCRIP
    
    rs.MoveNext
  Wend
  
  pLoadCampos = True
End Function

Private Function LoadCollection() As Boolean
  m_ObjAbm.Title2 = m_Title2
  Dim c As cIABMProperty

  With m_ObjAbm.Tabs
  
    .Clear
      
    With .Add(Nothing)
      .Name = C_strGeneral
    End With
    
    With .Add(Nothing)
      .Index = 1
      .Name = LNGGetText(2825, vbNullString) 'Campos
    End With
  
  End With

  With m_ObjAbm.Properties
  
    .Clear
  
    With .Add(Nothing, cscAfRegNombre)
      .PropertyType = cspText
      .Name = C_strNombre
      .Size = 50
      .Width = 4000
      .Key = K_NOMBRE
      .Value = Nombre
    End With
    
    With .Add(Nothing, cscActivo)
      .PropertyType = cspCheck
      .Name = C_strActivo
      .Key = K_ACTIVO
      .Value = CInt(m_Activo)
    End With
    
    With .Add(Nothing, cscAfRegObjetoproceso)
      .PropertyType = cspText
      .Name = LNGGetText(3430, vbNullString) 'Objeto de Proceso
      .Width = 4000
      .Size = 255
      .Key = K_OBJETOPROCESO
      .Value = ObjetoProceso
    End With
    
    With .Add(Nothing, cscAfRegDescrip)
      .PropertyType = cspText
      .SubType = cspMemo
      .Width = 10000
      .Height = 880
      .Name = C_strDescrip
      .Size = 255
      .Key = K_DESCRIP
      .Value = m_Descrip
    End With
      
    Set c = .Add(Nothing, "Campos")
    With c
      .PropertyType = cspGrid
      .LeftLabel = -1
      If Not pLoadCampos(c) Then Exit Function
      .Name = "Campos"
      .Key = K_CAMPOS
      .TabIndex = 1
      .GridAdd = True
      .GridEdit = True
      .GridRemove = True
    End With
  End With
  
  m_ItemsDeletedCampos = vbNullString
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

' construccion - destruccion
Private Sub Class_Initialize()
On Error GoTo ControlError
  Set m_Campos = New cAFIPCampos
  
  c_ErrorSave = LNGGetText(3431, vbNullString)
                'Error al grabar AFIPRegistro
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
  Set m_ObjectProc = Nothing
  Set m_Campos = Nothing
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


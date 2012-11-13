VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cGarantia"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIEditGeneric
Implements CSInterfacesABM.cIABMClient
Implements CSMenu.cIMenuClient
'--------------------------------------------------------------------------------
' cGarantia
' 28-06-04

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cGarantia"

Private Const K_CODIGO                         As Integer = 1
Private Const K_NROPOLIZA                      As Integer = 2
Private Const K_CODIGOADUANA                   As Integer = 3
Private Const K_FECHA                          As Integer = 4
Private Const K_FECHAINICIO                    As Integer = 5
Private Const K_FECHAVTO                       As Integer = 6
Private Const K_DESCRIP                        As Integer = 7
Private Const K_MONTO                          As Integer = 8
Private Const K_CUOTA                          As Integer = 9
Private Const K_DIAVTOCUOTA                    As Integer = 10
Private Const K_PROV_ID                        As Integer = 11
Private Const K_MON_ID                         As Integer = 12

' Seudo - Variables
Private c_ErrorSave         As String

' estructuras
' variables privadas
Private m_Id                           As Long
Private m_Codigo                       As String
Private m_Nropoliza                    As String
Private m_Codigoaduana                 As String
Private m_Fecha                        As Date
Private m_Fechainicio                  As Date
Private m_Fechavto                     As Date
Private m_Descrip                      As String
Private m_Monto                        As Double
Private m_Cuota                        As Double
Private m_Diavtocuota                  As Integer
Private m_prov_id                      As Long
Private m_Proveedor                    As String
Private m_Mon_id                       As Long
Private m_Moneda                       As String
Private m_Creado                       As Date
Private m_Modificado                   As Date
Private m_Modifico                     As Long

'OJO HASTA ACA

Private m_Editing           As Boolean

Private m_ObjAbm            As cIABMGeneric
Private m_ObjTree           As Object

Private m_IsNew             As Boolean

Private m_BranchId          As Long
Private m_TreeId            As Long

Private m_Host              As CSMenu.cIMenuHost
Private m_Copy              As Boolean

' Properties publicas
Public Property Get ID() As Long
  ID = m_Id
End Property

Public Property Get Codigo() As String
  Codigo = m_Codigo
End Property

Public Property Get Nombre() As String
  Nombre = m_Codigo
End Property
' Properties privadas
' funciones publicas

' Implementacion de cIABMClient
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

  Doc.ClientTable = csTGarantia
  Doc.ClientTableID = m_Id

  cIABMClient_ShowDocDigital = Doc.ShowDocs(gDB)

  GoTo ExitProc
ControlError:
  MngError Err, "cIABMClient_ShowDocDigital", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function cIABMClient_EditNew() As Boolean

  cIABMClient_Terminate
  m_IsNew = True

  cIEditGeneric_Edit csNO_ID
End Function

Private Function cIABMClient_MessageEx(ByVal MessageID As Long, ByVal Info As Variant) As Variant
  cIABMClient_MessageEx = True
End Function

Private Sub cIABMClient_DiscardChanges()
    LoadCollection
End Sub

Private Function cIABMClient_Copy() As Boolean
  
  cIABMClient_Terminate
  m_IsNew = True

  With m_ObjAbm.Properties(cscEmbCodigo)
    .Value = C_C & .Value
  End With
  
  With m_ObjAbm.Properties(cscEmbNombre)
    .Value = C_CopiaDe & .Value
  End With
  
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscEmbCodigo)
  m_ObjAbm.ShowValue m_ObjAbm.Properties(cscEmbNombre)
  
  m_Copy = True
End Function

Private Function cIABMClient_ListAdHock(List As CSInterfacesABM.cIABMList) As Boolean

End Function

Private Sub cIABMClient_Load()

End Sub

Private Function cIABMClient_PropertyChange(ByVal Key As Integer) As Boolean

End Function

Private Function cIABMClient_Save() As Boolean
  Dim register As cRegister
  Set register = New cRegister
  
  register.fieldId = cscGarId
  register.Table = csTGarantia
  
  If m_Copy Then
    register.ID = csNew
  Else
    register.ID = m_Id
  End If
  
  Dim IProperty As cIABMProperty
  
  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_CODIGO
          register.Fields.Add2 cscGarCodigo, .Value, csText
        Case K_NROPOLIZA
          register.Fields.Add2 cscGarNropoliza, .Value, csText
        Case K_CODIGOADUANA
          register.Fields.Add2 cscGarCodigoaduana, .Value, csText
        Case K_FECHA
          register.Fields.Add2 cscGarFecha, .Value, csDate
        Case K_FECHAINICIO
          register.Fields.Add2 cscGarFechainicio, .Value, csDate
        Case K_FECHAVTO
          register.Fields.Add2 cscGarFechavto, .Value, csDate
        Case K_DESCRIP
          register.Fields.Add2 cscGarDescrip, .Value, csText
        Case K_MONTO
          register.Fields.Add2 cscGarMonto, .Value, csCurrency
        Case K_CUOTA
          register.Fields.Add2 cscGarCuota, .Value, csCurrency
        Case K_DIAVTOCUOTA
          register.Fields.Add2 cscGarDiavtocuota, .Value, csBoolean
        Case K_PROV_ID
          register.Fields.Add2 cscProvId, .HelpId, csId
        Case K_MON_ID
          register.Fields.Add2 cscMonId, .HelpId, csId

      End Select
    End With
  Next
  
  register.Fields.HaveLastUpdate = True
  register.Fields.HaveWhoModify = True
  
  If Not gDB.Save(register, , "cIABMClient_Save", C_Module, c_ErrorSave) Then Exit Function
  
  m_Copy = False
  cIABMClient_Save = Load(register.ID)
End Function

Private Function cIABMClient_Terminate() As Boolean
  m_Editing = False
  
  cIABMClient_Terminate = True
  ' Este objeto puede no cumplir con la interfaz esperada, asi que si hay un error no
  ' le doy bola
  On Error GoTo ControlError
  If m_Id = csNO_ID Then Exit Function
  If m_ObjTree Is Nothing Then Exit Function
  
  m_ObjTree.sqlstmt = "sp_lsdoc_garantia"
  
  If m_IsNew Then
    m_ObjTree.AddLine m_Id
  Else
    m_ObjTree.RefreshLine m_Id
  End If
ControlError:
End Function

Private Property Get cIABMClient_Title() As String
    cIABMClient_Title = LNGGetText(2438, vbNullString) 'Garantías
End Property

Private Function cIABMClient_Validate() As Boolean
  Dim IProperty As cIABMProperty

  For Each IProperty In m_ObjAbm.Properties
    With IProperty
      Select Case .Key
        Case K_CODIGO
          If ValEmpty(.Value, csText) Then
            MsgInfo LNGGetText(1008, vbNullString) 'Debe indicar un código
            Exit Function
          End If
        Case K_NROPOLIZA
          If ValEmpty(.Value, csText) Then
            MsgInfo LNGGetText(2439, vbNullString) 'Debe indicar un número de Póliza"
            Exit Function
          End If
        Case K_CODIGOADUANA
          If ValEmpty(.Value, csText) Then
            MsgInfo LNGGetText(2440, vbNullString) 'Debe indicar un código de Aduana
            Exit Function
          End If
        Case K_FECHA
          If ValEmpty(.Value, csDate) Then
            MsgInfo LNGGetText(1558, vbNullString) 'Debe indicar una fecha
            Exit Function
          End If
        Case K_FECHAINICIO
          If ValEmpty(.Value, csDate) Then
            MsgInfo LNGGetText(2441, vbNullString) 'Debe indicar una Fecha de Inicio
            Exit Function
          End If
        Case K_FECHAVTO
          If ValEmpty(.Value, csDate) Then
            MsgInfo LNGGetText(1625, vbNullString) 'Debe indicar una fecha de vencimiento
            Exit Function
          End If
        Case K_MONTO
          If ValEmpty(.Value, csCurrency) Then
            MsgInfo LNGGetText(2442, vbNullString) 'Debe indicar un Monto
            Exit Function
          End If
        Case K_CUOTA
          If ValEmpty(.Value, csCurrency) Then
            MsgInfo LNGGetText(2443, vbNullString) 'Debe indicar un valor de Cuota
            Exit Function
          End If
        Case K_DIAVTOCUOTA
          If ValEmpty(.Value, csBoolean) Then
            MsgInfo LNGGetText(2444, vbNullString) 'Debe indicar en que día del mes vence la cuota
            Exit Function
          Else
            If Val(.Value) < 1 Or Val(.Value) > 28 Then
              MsgInfo LNGGetText(2445, vbNullString)
                  'Debe indicar un valor entre 1 y 28 para el día del mes en que vence la cuota
            End If
          End If
        Case K_PROV_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(2446, vbNullString)  'Debe indicar una Compañía de Seguros
            Exit Function
          End If
        Case K_MON_ID
          If ValEmpty(.HelpId, csId) Then
            MsgInfo LNGGetText(1108, vbNullString)  'Debe indicar una moneda
            Exit Function
          End If

      End Select
    End With
  Next

  cIABMClient_Validate = True
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

Private Function cIEditGeneric_GridAdd(ByVal KeyProperty As Integer) As Boolean

End Function

Private Function cIEditGeneric_GridEdit(ByVal KeyProperty As Integer) As Boolean

End Function

Private Function cIEditGeneric_GridRemove(ByVal KeyProperty As Integer) As Boolean

End Function

Private Function cIEditGeneric_ShowList() As Boolean
    cIEditGeneric_ShowList = SecurityCanAccess(csPreExpListGarantia)
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
    If Not SecurityCanAccess(csPreExpDeleteGarantia) Then Exit Function

    Dim sqlstmt As String
    
    sqlstmt = "Delete Garantia where Emb_id = " & ID
    
    cIEditGeneric_Delete = gDB.Execute(sqlstmt, "cIEditGeneric_Delete", C_Module)
End Function

Private Function cIEditGeneric_Search(ID As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_Edit(ID As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If ID = csNO_ID Then
    m_IsNew = True
    If Not SecurityCanAccess(csPreExpNewGarantia) Then Exit Function
  Else
    m_IsNew = False
    If Not SecurityCanAccess(csPreExpEditGarantia) Then Exit Function
  End If
  
  m_ObjAbm.InModalWindow = InModalWindow
  
  If Not Load(ID) Then Exit Function
  
  If Not LoadCollection() Then Exit Function
  
  m_Editing = True
  m_Copy = False
  
  If InModalWindow Then
    cIEditGeneric_Edit = m_Id <> csNO_ID
  Else
    cIEditGeneric_Edit = True
  End If

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

' Menu Client
Private Function cIMenuClient_Initialize(F As Object, Host As CSMenu.cIMenuHost) As Boolean
  On Error GoTo ControlError
  
  Set m_Host = Host
  
  m_Host.Server.AddMenu c_MenuMain, csMenuExportacion, vbNullString, 1, False, False, False, True, False, Nothing
  m_Host.Server.AddMenu LNGGetText(2447, vbNullString), csPreExpListGarantia, c_MenuMain, 0, True, False, False, False, False, Me
                          '&Garantía
  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, "cIMenuClient_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal ID As Long) As Variant
  m_Host.MenuListDocClick "CSABMInterface2.CABMGeneric", "CSExport2.cGarantia", "CSABMInterface2.CABMGenericListDoc", "CSExport2.cGarantiaListDoc", Me, LNGGetText(2448, vbNullString), 0
                                                                                                                                                        'Garantía
End Function

' funciones privadas
Private Function LoadCollection() As Boolean
  m_ObjAbm.Properties.Clear
  
  Dim c As cIABMProperty

  Set c = m_ObjAbm.Properties.Add(Nothing, cscGarCodigo)
  c.PropertyType = cspText
  c.Name = C_strCodigo
  c.Size = 15
  c.Key = K_CODIGO
  c.Value = m_Codigo
  

  Set c = m_ObjAbm.Properties.Add(Nothing, cscGarNropoliza)
  c.PropertyType = cspText
  c.Name = LNGGetText(2449, vbNullString)   'Nro. de Póliza
  c.Size = 50
  c.Key = K_NROPOLIZA
  c.Value = m_Nropoliza
  

  Set c = m_ObjAbm.Properties.Add(Nothing, cscGarCodigoaduana)
  c.PropertyType = cspText
  c.Name = LNGGetText(2455, vbNullString)   'Código Aduana
  c.Size = 50
  c.Key = K_CODIGOADUANA
  c.Value = m_Codigoaduana
  

  Set c = m_ObjAbm.Properties.Add(Nothing, cscGarFecha)
  c.PropertyType = cspDate
  c.Name = LNGGetText(1569, vbNullString)   'Fecha
  c.Key = K_FECHA
  c.Value = m_Fecha
  

  Set c = m_ObjAbm.Properties.Add(Nothing, cscGarFechainicio)
  c.PropertyType = cspDate
  c.Name = LNGGetText(2361, vbNullString)   'Fecha inicio
  c.Key = K_FECHAINICIO
  c.Value = m_Fechainicio
  

  Set c = m_ObjAbm.Properties.Add(Nothing, cscGarFechavto)
  c.PropertyType = cspDate
  c.Name = LNGGetText(1405, vbNullString)   'Vencimiento
  c.TopFromProperty = cscGarCodigo
  c.Left = 5500
  c.Key = K_FECHAVTO
  c.Value = m_Fechavto
  

  Set c = m_ObjAbm.Properties.Add(Nothing, cscGarMonto)
  c.PropertyType = cspNumeric
  c.SubType = cspMoney
  c.Name = LNGGetText(2456, vbNullString)   'Monto
  c.Key = K_MONTO
  c.Value = m_Monto
  

  Set c = m_ObjAbm.Properties.Add(Nothing, cscGarCuota)
  c.PropertyType = cspNumeric
  c.Name = LNGGetText(1463, vbNullString)   'Cuota
  c.SubType = cspMoney
  c.Key = K_CUOTA
  c.Value = m_Cuota
  

  Set c = m_ObjAbm.Properties.Add(Nothing, cscGarDiavtocuota)
  c.PropertyType = cspNumeric
  c.SubType = cspInteger
  c.Name = LNGGetText(2457, vbNullString)   'Día de vto. de la Cuota
  c.Key = K_DIAVTOCUOTA
  c.Value = m_Diavtocuota
  

  Set c = m_ObjAbm.Properties.Add(Nothing, cscProvId)
  c.PropertyType = cspHelp
  c.Table = csProveedor
  c.Name = LNGGetText(1151, vbNullString)   'Proveedor
  c.Key = K_PROV_ID
  c.Value = m_Proveedor
  c.HelpId = m_prov_id
  

  Set c = m_ObjAbm.Properties.Add(Nothing, cscMonId)
  c.PropertyType = cspHelp
  c.Table = csMoneda
  c.Name = LNGGetText(1113, vbNullString)   'Moneda
  c.TopFromProperty = cscGarCodigo
  c.Left = 9000
  c.Key = K_MON_ID
  c.Value = m_Moneda
  c.HelpId = m_Mon_id
  

  Set c = m_ObjAbm.Properties.Add(Nothing, cscGarDescrip)
  c.PropertyType = cspText
  c.SubType = cspMemo
  c.Name = C_strDescrip
  c.LeftFromProperty = cscGarCodigo
  c.TopFromProperty = cscGarFechainicio
  c.TopToPrevious = 440
  c.Size = 255
  c.Width = 9700
  c.Height = 880
  c.Key = K_DESCRIP
  c.Value = m_Descrip
  
  
  If Not m_ObjAbm.Show(Me) Then Exit Function
  
  LoadCollection = True
End Function

Private Function Load(ByVal ID As Long) As Boolean

  Dim sqlstmt As String

  sqlstmt = "sp_garantiaGet " & ID

  Dim rs As Recordset

  If Not gDB.OpenRs(sqlstmt, rs, csRsStatic, csLockReadOnly, csCmdText, C_LoadFunction, C_Module) Then Exit Function

  If Not rs.EOF Then

    m_Id = gDB.ValField(rs.Fields, cscGarId)
    m_Codigo = gDB.ValField(rs.Fields, cscGarCodigo)
    m_Nropoliza = gDB.ValField(rs.Fields, cscGarNropoliza)
    m_Codigoaduana = gDB.ValField(rs.Fields, cscGarCodigoaduana)
    m_Fecha = gDB.ValField(rs.Fields, cscGarFecha)
    m_Fechainicio = gDB.ValField(rs.Fields, cscGarFechainicio)
    m_Fechavto = gDB.ValField(rs.Fields, cscGarFechavto)
    m_Descrip = gDB.ValField(rs.Fields, cscGarDescrip)
    m_Monto = gDB.ValField(rs.Fields, cscGarMonto)
    m_Cuota = gDB.ValField(rs.Fields, cscGarCuota)
    m_Diavtocuota = gDB.ValField(rs.Fields, cscGarDiavtocuota)
    m_prov_id = gDB.ValField(rs.Fields, cscProvId)
    m_Proveedor = gDB.ValField(rs.Fields, cscProvNombre)
    m_Mon_id = gDB.ValField(rs.Fields, cscMonId)
    m_Moneda = gDB.ValField(rs.Fields, cscMonNombre)
    m_Creado = gDB.ValField(rs.Fields, cscCreado)
    m_Modificado = gDB.ValField(rs.Fields, cscModificado)
    m_Modifico = gDB.ValField(rs.Fields, cscModifico)

  Else
    m_Id = csNO_ID
    m_Codigo = vbNullString
    m_Nropoliza = vbNullString
    m_Codigoaduana = vbNullString
    m_Fecha = Date
    m_Fechainicio = Date
    m_Fechavto = DateAdd("m", 3, Date)
    m_Descrip = vbNullString
    m_Monto = 0
    m_Cuota = 0
    m_Diavtocuota = 0
    m_prov_id = csNO_ID
    m_Proveedor = vbNullString
    m_Mon_id = csNO_ID
    m_Moneda = vbNullString
    m_Creado = csNoDate
    m_Modificado = csNoDate
    m_Modifico = 0

  End If

  Load = True
End Function
' construccion - destruccion

Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  c_ErrorSave = LNGGetText(2437, vbNullString) 'Error al grabar Garantía
  
  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
    Set m_ObjAbm = Nothing
    Set m_ObjTree = Nothing
End Sub

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

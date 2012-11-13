VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cDocumento"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cDocumento
' 29-05-03

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cDocumento"

'Private Const c_FacturaDesdePackingList = "facpacklst"
'Private Const c_FacturaDesdeRemito = "facremito"
'Private Const c_FacturaDesdePedido = "facpedido"
'Private Const c_FacturaDirecta = "facdirecta"
'
'Private Const c_PackingListDesdePedido = "packlstpedido"
'Private Const c_PackingListDesdeRemito = "packlstremito"
'Private Const c_PackingListDesdeManifiesto = "packlstmanif"
'Private Const c_PackingListDirecto = "packlstdirecto"

' estructuras
' variables privadas
'Private m_Id                           As Long
'Private m_Nombre                       As String
'Private m_Codigo                       As String
'Private m_Descrip                      As String
'Private m_Doct_id                      As Long
'Private m_DocumentoTipo                As String
'
'Private m_Cico_id                      As Long
'Private m_CircuitoContable             As String
'
'Private m_emp_id                       As Long
'Private m_Empresa                      As String
'
'Private m_Doc_id_Asiento               As Long
'Private m_DocumentoAsiento             As String
'
'Private m_Doc_id_Remito                As Long
'Private m_DocumentoRemito              As String
'Private m_Doc_id_Stock                 As Long
'Private m_DocumentoStock               As String
'
'
'Private m_Fca_id                       As Long
'Private m_FechaControlAcceso           As String
'Private m_Creado                       As Date
'Private m_Modificado                   As Date
'Private m_Modifico                     As Long
'Private m_Activo                       As Boolean
'Private m_LlevaFirma                   As Boolean
'Private m_RvDesdePv                    As Boolean
'Private m_RcDesdePc                    As Boolean
'Private m_LlevaRendicion               As Boolean
'Private m_TipoFactura                  As csETipoFactura
'Private m_TipoPackingList              As csETipoPackingList
'
'Private m_GeneraRemito                 As Boolean
'Private m_MueveStock                   As Boolean
'
'Private m_Talonario                     As String
'Private m_ta_id                         As Long
'
'Private m_TalonarioFinal                As String
'Private m_ta_id_Final                   As Long
'
'Private m_TalonarioInscripto            As String
'Private m_ta_id_Inscripto               As Long
'
'Private m_TalonarioExterno              As String
'Private m_ta_id_Externo                 As Long
'
'Private m_Moneda                       As String
'Private m_mon_id                       As Long
'
'Private m_CuentaGrupo                  As String
'Private m_cueg_id                      As Long

' Properties publicas
'Public Property Get Fca_id() As Long
'  Fca_id = m_Fca_id
'End Property
'
'Public Property Get LlevaFirma() As Boolean
'  LlevaFirma = m_LlevaFirma
'End Property
'
'Public Property Get RvDesdePv() As Boolean
'  RvDesdePv = m_RvDesdePv
'End Property
'
'Public Property Get RcDesdePc() As Boolean
'  RcDesdePc = m_RcDesdePc
'End Property
'
'Public Property Get LlevaRendicion() As Boolean
'  LlevaRendicion = m_LlevaRendicion
'End Property
'
'Public Property Get TipoFactura() As csETTipoTalonario
'  TipoFactura = m_TipoFactura
'End Property
'
'Public Property Get TipoPackingList() As csETipoPackingList
'  TipoPackingList = m_TipoPackingList
'End Property
'
'Public Property Get Talonario() As String
'   Talonario = m_Talonario
'End Property
'
'Public Property Get TA_ID() As Long
'   TA_ID = m_ta_id
'End Property
'
'Public Property Get TalonarioFinal() As String
'   TalonarioFinal = m_TalonarioFinal
'End Property
'
'Public Property Get TA_ID_Final() As Long
'   TA_ID_Final = m_ta_id_Final
'End Property
'
'Public Property Get TalonarioExterno() As String
'   TalonarioExterno = m_TalonarioExterno
'End Property
'
'Public Property Get TA_ID_Externo() As Long
'   TA_ID_Externo = m_ta_id_Externo
'End Property
'
'Public Property Get TalonarioInscripto() As String
'   TalonarioInscripto = m_TalonarioInscripto
'End Property
'
'Public Property Get TA_ID_Inscripto() As Long
'   TA_ID_Inscripto = m_ta_id_Inscripto
'End Property
'
'Public Property Get Mon_id() As Long
'   Mon_id = m_mon_id
'End Property

' Properties privadas
' funciones publicas
Public Function Firmar(ByVal doc_id, ByRef Us_id As Long) As Boolean
  On Error GoTo ControlError

  Dim Users     As String
  Dim F         As fFirma
  Dim rs        As ADODB.Recordset
  Dim sqlstmt   As String
  
  If Not GetData(doc_id, cscDocLlevaFirma, csBoolean) Then
    
    If Not GetData(doc_id, cscDocLlevaFirmaCredito, csBoolean) Then
    
      If Not GetData(doc_id, cscDocLlevaFirmaPrint0, csBoolean) Then
    
        MsgWarning LNGGetText(3232, vbNullString) 'Este Documento no requiere firma
        Exit Function
      End If
    End If
  End If
  
  sqlstmt = "select us_id from documentofirma where doc_id = " & doc_id
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  If rs.EOF Then
    MsgWarning LNGGetText(3233, vbNullString)
               'Este documento no tiene asociado ningún usuario con derecho de _
               firma. Comuníquese con el Administrador de Cairo
    Exit Function
  End If
  
  While Not rs.EOF
    Users = Users & gDB.ValField(rs.Fields, cscUsId) & ","
    rs.MoveNext
  Wend
  
  Users = RemoveLastColon(Users)
  
  Set F = New fFirma
  VB.Load F
  F.SetFilter Users
  
  Dim Mouse As cMouse
  Set Mouse = New cMouse
  
  Mouse.MouseDefault
  
  F.hlUsuario.Text = User.Name
  F.hlUsuario.ValueHelp = User.id
  F.hlUsuario.id = User.id
  
  F.Show vbModal
  
  If F.Us_id = csNO_ID Then GoTo ExitProc
  
  Us_id = F.Us_id
  Firmar = True

  GoTo ExitProc
ControlError:
  MngError Err, "Firmar", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
  Unload F
End Function

Public Function GetData(ByVal id As Long, ByVal strField As String, ByVal TypeValue As csTypes) As Variant
  Dim Data As Variant
  
  Select Case TypeValue
    Case csTypes.csBoolean
      Data = False
    Case csTypes.csCuit, csTypes.csText
      Data = ""
    Case csTypes.csDate, csTypes.csDateOrNull
      Data = csNoDate
    Case csTypes.csCurrency, csTypes.csDouble, _
         csTypes.csInteger, csTypes.csLong, _
         csTypes.csSingle, csTypes.csId
      Data = 0
    Case csTypes.csVariant
      Data = Empty
  End Select
  
  If Not gDB.GetData(csTDocumento, cscDocId, id, strField, Data, "GetData", C_Module) Then
    Select Case TypeValue
      Case csTypes.csBoolean
        Data = False
      Case csTypes.csCuit, csTypes.csText
        Data = ""
      Case csTypes.csDate, csTypes.csDateOrNull
        Data = csNoDate
      Case csTypes.csCurrency, csTypes.csDouble, _
           csTypes.csInteger, csTypes.csLong, _
           csTypes.csSingle, csTypes.csId
        Data = 0
      Case csTypes.csVariant
        Data = Empty
    End Select
  End If
  
  If TypeValue = csTypes.csBoolean Then Data = CBool(Data)
  
  GetData = Data
End Function

' construccion - destruccion

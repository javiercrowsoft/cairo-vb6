VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 3  'UsesTransaction
END
Attribute VB_Name = "cDiccTabla"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cDiccTabla
' 18-01-00

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cDiccTabla"
' estructuras
' variables privadas
Private m_dbh As cDBHelper

Private m_SqlHelp     As String
Private m_SqlHelpWeb  As String
Private m_FieldName   As String
Private m_FieldCode   As String
Private m_FieldId     As String
Private m_HaveTree    As Boolean
Private m_HaveActive  As Boolean
Private m_Exists      As Boolean
Private m_Name        As String
Private m_NameLogic   As String
Private m_NameFisic   As String
Private m_ID          As String
Private m_Where       As String
Private m_HaveInfo    As Boolean
Private m_SpInfo      As String
Private m_OriginalSqlHelp As String

Private m_ObjectEdit                    As String
Private m_ObjectABM                     As String

' Properties publicas
Public Property Get SqlHelp() As String
  SqlHelp = m_SqlHelp
End Property
Public Property Get OriginalSqlHelp() As String
  OriginalSqlHelp = m_OriginalSqlHelp
End Property
Public Property Get FieldName() As String
  FieldName = m_FieldName
End Property
Public Property Get SqlHelpWeb() As String
  SqlHelpWeb = m_SqlHelpWeb
End Property
Public Property Get FieldCode() As String
  FieldCode = m_FieldCode
End Property
Public Property Get fieldId() As String
  fieldId = m_FieldId
End Property
Public Property Get HaveTree() As Boolean
  HaveTree = m_HaveTree
End Property
Public Property Get HaveActive() As Boolean
  HaveActive = m_HaveActive
End Property
Public Property Get Exists() As Boolean
  Exists = False
End Property
Public Property Get Name() As String
  Name = m_Name
End Property
Public Property Get ID() As String
  ID = m_ID
End Property
Public Property Get NameLogic() As String
  NameLogic = m_NameLogic
End Property
Public Property Get NameFisic() As String
  NameFisic = m_NameFisic
End Property
Public Property Get Where() As String
  Where = m_Where
End Property
Public Property Get ObjectEdit() As String
  ObjectEdit = m_ObjectEdit
End Property
Public Property Get HaveInfo() As Boolean
  HaveInfo = m_HaveInfo
End Property
Public Property Let ObjectEdit(ByVal rhs As String)
  m_ObjectEdit = rhs
End Property
Public Property Get ObjectABM() As String
  ObjectABM = m_ObjectABM
End Property
Public Property Let ObjectABM(ByVal rhs As String)
  m_ObjectABM = rhs
End Property
' Properties privadas
' funciones publicas
Public Function Load(ByVal Table As Long) As Boolean
  On Error GoTo ControlError
  
  Dim sqlstmt As String
  Dim Rs As ADODB.Recordset
  
  sqlstmt = "select * from tabla where tbl_id = " & Table
  
  Set Rs = m_dbh.RunSQLReturnRS(sqlstmt)
  If Rs.EOF Then
    m_Exists = False
  Else
    m_Exists = True
    m_Name = ConvertToString(Rs.Fields("tbl_Nombre"))
    m_FieldName = ConvertToString(Rs.Fields("tbl_CampoNombre"))
    m_FieldCode = ConvertToString(Rs.Fields("tbl_CampoCodigo"))
    m_FieldId = ConvertToString(Rs.Fields("tbl_CampoId"))
    m_SqlHelp = ConvertToString(Rs.Fields("tbl_SqlHelp"))
    m_SqlHelpWeb = ConvertToString(Rs.Fields("tbl_SqlHelpWeb"))
    m_ID = NullsToZero(Rs.Fields("tbl_Id"))
    m_NameLogic = ConvertToString(Rs.Fields("tbl_Nombre"))
    m_HaveTree = NullsToZero(Rs.Fields("tbl_TieneArbol"))
    m_HaveActive = NullsToZero(Rs.Fields("tbl_TieneActivo"))
    m_NameFisic = ConvertToString(Rs.Fields("tbl_NombreFisico"))
    m_Where = ConvertToString(Rs.Fields("tbl_Where"))
    m_ObjectABM = ConvertToString(Rs.Fields("tbl_objectABM"))
    m_ObjectEdit = ConvertToString(Rs.Fields("tbl_objectEdit"))
    m_SpInfo = ConvertToString(Rs.Fields("tbl_SPInfo"))
    m_HaveInfo = m_SpInfo <> ""
    m_OriginalSqlHelp = m_SqlHelp
    
    If Trim(m_SqlHelp) = "" Then
      m_SqlHelp = "select top 50 " & m_FieldId & ",Nombre=" & m_FieldName
    
      If InStr(1, m_SqlHelp, "select", vbTextCompare) > 0 Then
        If m_FieldName <> m_FieldCode And m_FieldCode <> "" Then m_SqlHelp = m_SqlHelp & ",Codigo= " & m_FieldCode
        m_SqlHelp = m_SqlHelp & " from " & m_NameFisic & IIf(Trim(m_Where) = "", "", " where " & m_Where)
      End If
    End If
  End If
  
  Load = True
  
  GetObjectContext.SetComplete
  Exit Function
      
ControlError:
  CtxRaiseError C_Module, "ValidateEx"
End Function
' funciones privadas
' construccion - destruccion
Private Sub Class_Initialize()
  Set m_dbh = CreateObject("CSWebDataBase.cDBHelper")
End Sub

Private Sub Class_Terminate()
  Set m_dbh = Nothing
End Sub

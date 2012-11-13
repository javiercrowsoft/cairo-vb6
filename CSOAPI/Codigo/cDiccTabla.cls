VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cDiccTabla"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
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
' Seudo - Variables
Private c_ErrorSave       As String

' variables privadas
Private m_SqlHelp         As String
Private m_SqlSearch       As String
Private m_FieldName       As String
Private m_FieldCode       As String
Private m_FieldId         As String
Private m_HaveTree        As Boolean
Private m_HaveActive      As Boolean
Private m_Exists          As Boolean
Private m_Name            As String
Private m_NameLogic       As String
Private m_NameFisic       As String
Private m_Id              As String
Private m_Where           As String
Private m_HelpTop         As Integer
Private m_HaveInfo        As Boolean
Private m_SpInfo          As String
Private m_OriginalSqlHelp As String

Private m_ObjectEdit                    As String
Private m_ObjectABM                     As String

' Properties publicas
Public Property Get HelpTop() As Integer
  HelpTop = m_HelpTop
End Property

Public Property Get SqlHelp() As String
  Dim sqlstmt As String
  sqlstmt = Replace(m_SqlHelp, "@@emp_id", gEmpId, , , vbTextCompare)
  sqlstmt = Replace(sqlstmt, "@@us_id", gUser.Id, , , vbTextCompare)
  SqlHelp = sqlstmt
End Property

Public Property Get SqlSearch() As String
  Dim sqlstmt As String
  sqlstmt = Replace(m_SqlSearch, "@@emp_id", gEmpId, , , vbTextCompare)
  sqlstmt = Replace(sqlstmt, "@@us_id", gUser.Id, , , vbTextCompare)
  SqlSearch = sqlstmt
End Property

Public Property Get OriginalSqlHelp() As String
  OriginalSqlHelp = m_OriginalSqlHelp
End Property
Public Property Get FieldName() As String
  FieldName = m_FieldName
End Property
Public Property Get FieldCode() As String
  FieldCode = m_FieldCode
End Property
Public Property Get FieldId() As String
  FieldId = m_FieldId
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
Public Property Get Id() As String
  Id = m_Id
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
Public Function Load(ByVal Table As csTables) As Boolean
  On Error GoTo ControlError
  
  Dim sqlstmt As String
  Dim rs As ADODB.Recordset
  
  If Table = csNO_ID Then
    m_Exists = False
  Else
    If gDB Is Nothing Then Exit Function
    
    sqlstmt = "select * from tabla where tbl_id = " & gDB.sqlNumber(Table)
    
    If Not gDB.OpenRs(sqlstmt, rs, csRsFast, csLockReadOnly, csCmdText, "DiccTabla.Create", C_Module, c_ErrorSave, csErrorInformation) Then Exit Function
    If rs.EOF Then
      m_Exists = False
    Else
      m_Exists = True
      Set gDB.rs = rs
      m_Name = gDB.Val(cscTblNombre)
      m_FieldName = gDB.Val(cscTblCampoNombre)
      m_FieldCode = gDB.Val(cscTblCampoCodigo)
      m_FieldId = gDB.Val(cscTblCampoId)
      
      m_SqlHelp = gDB.Val(cscTblSqlHelpCliente)
      If LenB(m_SqlHelp) = 0 Then
        m_SqlHelp = gDB.Val(cscTblSqlHelp)
      End If
      
      m_SqlSearch = gDB.Val(cscTblSqlSearch)
      m_Id = gDB.Val(cscTblId)
      m_NameLogic = gDB.Val(cscTblNombre)
      m_HaveTree = gDB.Val(cscTblTieneArbol)
      m_HaveActive = gDB.Val(cscTblTieneActivo)
      m_NameFisic = gDB.Val(cscTblNombreFisico)
      m_Where = gDB.Val(cscTblWhere)
      m_ObjectABM = gDB.Val(cscTblobjectABM)
      m_ObjectEdit = gDB.Val(cscTblobjectEdit)
      m_SpInfo = gDB.Val(cscTblSPInfo)
      m_HaveInfo = LenB(m_SpInfo)
      m_OriginalSqlHelp = m_SqlHelp
      m_HelpTop = gDB.Val(cscTblHelpTop)
      
      If m_HelpTop <= 0 Then m_HelpTop = 50
      
      If ValEmpty(m_SqlHelp, csText) Then
        m_SqlHelp = "select top " & m_HelpTop & " " & m_FieldId
        
        If InStr(1, m_FieldName, "codigo") Then
          m_SqlHelp = m_SqlHelp & ",Codigo=" & m_FieldName
        Else
          m_SqlHelp = m_SqlHelp & ",Nombre=" & m_FieldName
        End If
        
        If InStr(1, m_SqlHelp, "select", vbTextCompare) > 0 Then
        If m_FieldName <> m_FieldCode And LenB(m_FieldCode) Then m_SqlHelp = m_SqlHelp & ",Codigo= " & m_FieldCode
        m_SqlHelp = m_SqlHelp & " from " & m_NameFisic & IIf(ValEmpty(m_Where, csText), "", " where " & m_Where)
        End If
      End If
    End If
  End If
  
  Load = True
  Exit Function
ControlError:
  MngError Err, "Load", C_Module, vbNullString, c_ErrorSave, csErrorWarning
End Function
' funciones privadas
' construccion - destruccion

Private Sub Class_Initialize()
  On Error GoTo ControlError

  c_ErrorSave = LNGGetText(3435, vbNullString)  'Error al cargar la Tabla

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, vbNullString
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


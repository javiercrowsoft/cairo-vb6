Attribute VB_Name = "mPublic"
Option Explicit

'--------------------------------------------------------------------------------
' mPublic
' 23-03-02

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
' estructuras
' variables privadas
' variables publicas

' Base de datos
Public gDB          As cDataBase

' nombre de la Aplication
Public gAppName     As String

' funciones publicas
Public Sub WizSetShowStockData(ByRef ObjWiz As cIWizardGeneric, _
                               ByVal KeyStep As String, _
                               ByRef ShowStockData As Boolean)
  Dim DocId     As Long
  Dim DocIdRto  As Long
  Dim Doc       As cDocumento
  
  Set Doc = New cDocumento
  
  ShowStockData = False
  
  With ObjWiz.Steps.Item(GetKey(KeyStep)).Properties.Item(c_Wiz_Key_Doc)
    DocId = .HelpId
  End With
  
  ' Si el remito mueve stock
  '
  If CBool(Doc.GetData(DocId, cscDocMueveStock, csBoolean)) Then
    ShowStockData = True
  End If
End Sub

Public Function WizGetDeposito(ByRef ObjWiz As cIWizardGeneric, _
                               ByVal KeyStep As String, _
                               ByVal KeyDeposito As String) As Long
                               
  With ObjWiz.Steps.Item(GetKey(KeyStep)).Properties.Item(KeyDeposito)
    WizGetDeposito = .HelpId
  End With
End Function

Public Function WizGetDepositoProp(ByRef ObjWiz As cIWizardGeneric, _
                                   ByVal KeyStep As String, _
                                   ByVal KeyDeposito As String) As cIABMProperty
                               
  Set WizGetDepositoProp = ObjWiz.Steps.Item(GetKey(KeyStep)).Properties.Item(KeyDeposito)
End Function

Public Sub ShowDataAddProveedor(ByVal bShowData As Boolean, _
                                ByRef AbmObj As cABMGeneric)

  If bShowData Then
    Dim ProvId   As Long
    Dim ObjAbm  As cIABMGeneric
    Dim iProp   As cIABMProperty
    Dim dataAdd As String
    
    Set ObjAbm = AbmObj
    ProvId = ObjAbm.Properties.Item(cscProvId).HelpId
    
    If ProvId Then
    
      Dim sqlstmt As String
      Dim rs      As ADODB.Recordset
      
      sqlstmt = "sp_ProveedorGetDataAdd " & ProvId
      If gDB.OpenRs(sqlstmt, rs) Then
        If Not rs.EOF Then
          dataAdd = gDB.ValField(rs.fields, 0)
        End If
      End If
    End If
    
    Set iProp = ObjAbm.Properties.Item(c_ProveedorDataAdd)
    iProp.Value = dataAdd
    AbmObj.ShowValue iProp
  End If
End Sub

' funciones privadas
' construccion - destruccion

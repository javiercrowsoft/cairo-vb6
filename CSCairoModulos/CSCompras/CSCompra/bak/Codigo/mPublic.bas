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

' funciones privadas
' construccion - destruccion

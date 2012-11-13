Attribute VB_Name = "mWizVenta"
Option Explicit

Public Sub WizVtaShowCotizacion(ByRef ObjWiz As cIWizardGeneric, _
                                ByVal StepId As Integer, _
                                ByVal DocId As Long, _
                                ByVal bShow As Boolean)
  Dim MonId   As Long
  Dim iProp   As cIABMProperty
  
  If DocId = csNO_ID Then Exit Sub
  If Not gDB.GetData(csTDocumento, cscDocId, DocId, cscMonId, MonId) Then Exit Sub
  
  Set iProp = GetWizProperty(ObjWiz, StepId, c_Wiz_Key_Cotizacion)
  iProp.Visible = MonId <> GetMonedaDefault
  
  Dim Moneda As cMoneda
  Set Moneda = New cMoneda
  
  iProp.Value = Moneda.GetCotizacion(MonId, Date)
  
  If bShow Then
    ObjWiz.ShowValue iProp
  End If
End Sub

Public Sub RvGetDocNumberForCliente(ByVal doc_id As Long, _
                                    ByRef ObjAbm As cIABMGeneric, _
                                    ByRef bTaPropuesto As Boolean, _
                                    ByVal PropertyKey As String)
  Dim Tl          As Object
  Dim TAL_ID      As Long
  Dim iProp       As cIABMProperty
  Dim Mask        As String
  Dim Doc         As Object
  Dim NroDoc      As String
  
  If Not gDB.GetData(csTDocumento, _
                     cscDocId, _
                     doc_id, _
                     cscDocIdRemito, _
                     doc_id) Then
    Exit Sub
  End If
  
  If doc_id <> csNO_ID Then
  
    Set Doc = CreateObject("CSDocumento2.cDocumento")
    
    TAL_ID = Doc.GetData(doc_id, cscTaId, csId)
    
    Set Tl = CreateObject("CSDocumento2.cTalonario")
    
    NroDoc = Tl.GetNextNumber(TAL_ID, Mask, bTaPropuesto)
  Else
    NroDoc = vbNullString
    Mask = vbNullString
    bTaPropuesto = False
  End If
  
  Set iProp = ObjAbm.Properties.Item(PropertyKey)
  iProp.Value = NroDoc
  iProp.TextMask = Mask
  iProp.Enabled = bTaPropuesto
  ObjAbm.ShowValue iProp
End Sub

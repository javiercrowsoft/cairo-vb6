Attribute VB_Name = "mKit"
Option Explicit

Private Const KI_PR_ID  As Integer = 2

Public Const c_Items = "Items"

Public Enum csE_ColType
  csECT_Serie
  csECT_SerieA = 1000
  csECT_Lote = 2000
  csECT_Alt = 4000
  csECT_Var = 5000
End Enum

Public Function KitGetFilterLote(ByRef Lote As cKitLote, _
                                 ByVal pr_id As Long, _
                                 ByVal ctrlStock As csE_ControlStock, _
                                 ByVal depl_id As Long, _
                                 ByVal depf_id As Long, _
                                 Optional ByVal lRow As Long) As String
                                
  Dim filter      As String
  Dim FilterDepl  As String
  
  filter = cscPrId & " = " & pr_id
                                
  If depl_id <> csNO_ID Then
                                    ' Este 'OR' es momentaneo hasta
                                    ' que el control de stock este estable
                                    '
    If ctrlStock = csEStockFisico Or ctrlStock = csENoControlaStock Then
      ' Si me indico un deposito y el stock es por deposito fisico
      ' exijo que el numero de serie este en algun deposito logico
      ' del deposito fisico al que pertenece el deposito logico
      ' que me pasaron.
      '
      FilterDepl = " and " & cscDeplId & " in (select depl_id from depositoLogico where depf_id = " & depf_id & ")"
      
      ' Sino es por deposito fisico exijo que este
      ' en el deposito logico que me pasaron
      '
    ElseIf ctrlStock = csEStockLogico Then
      FilterDepl = " and " & cscDeplId & " = " & depl_id
    End If
    
    If FilterDepl <> vbNullString Then
      FilterDepl = " and exists (select stl_id from StockCache where pr_id = " & pr_id _
                                & FilterDepl & _
                                "group by stl_id having sum (stc_cantidad)>0.01)"
                               
      filter = filter & FilterDepl
    End If
  
  End If

  If lRow > 0 Then

    Dim stl_id  As Long
    Dim KitLote As cKitLoteNumber
    Set KitLote = Lote.Items(GetKey(lRow))
    If Not KitLote Is Nothing Then
      If KitLote.pr_id = pr_id Then
        stl_id = KitLote.stl_id
        filter = "(" & filter & ") or ( stl_id = " & stl_id & ")"
      End If
    End If
  
  End If
  
  KitGetFilterLote = filter
End Function

Public Function KitGetFilterSerie(ByRef Serie As cKitSerie, _
                                  ByRef Row As cIABMGridRow, _
                                  ByVal idx As Long, _
                                  ByVal lRow As Long, _
                                  ByVal lCol As Long, _
                                  ByVal lRowKey As Long, _
                                  ByVal lColKey As Long, _
                                  ByVal depl_id As Long, _
                                  ByVal ctrlStock As csE_ControlStock, _
                                  ByVal depf_id As Long, _
                                  ByRef KitLns As cKitLines, _
                                  ByRef KitLn As cKitLine, _
                                  ByRef ObjAbm As cIABMGeneric, _
                                  ByVal bEditAux As Boolean) As String
  Dim filter      As String
  Dim pr_id       As Long
  Dim Cell        As cIABMGridCellValue
  
  If bEditAux Then
  
    pr_id = pCell(Row, KI_PR_ID).Id
  
  Else
  
    If Serie.Alts.Count Then
      Set Cell = pCell(Row, KitGetPropKey(idx, csECT_SerieA))
      If Not Cell Is Nothing Then
        pr_id = Cell.Id
      End If
    End If
    If pr_id = csNO_ID Then
      pr_id = Serie.pr_id
    End If
    
  End If
  
  filter = cscPrId & " = " & pr_id
  
  ' Los contra-documentos (devoluciones y notas de credito) envian
  ' el deposito del tercero y el cliente o proveedor segun corresponda
  '
  If depl_id = csE_DepositosInternos.csEDeplIdTercero Then
  
    filter = filter & " and depl_id = " & csE_DepositosInternos.csEDeplIdTercero
  
  Else
    ' No puede estar en depositos internos del sistema
    '
    filter = filter & " and depl_id not in (-2,-3)"
  End If
  
  If depl_id <> csNO_ID Then
                                    ' Este 'OR' es momentaneo hasta
                                    ' que el control de stock este estable
                                    '
    If ctrlStock = csEStockFisico Or ctrlStock = csENoControlaStock Then
      ' Si me indico un deposito y el stock es por deposito fisico
      ' exijo que el numero de serie este en algun deposito logico
      ' del deposito fisico al que pertenece el deposito logico
      ' que me pasaron.
      '
      filter = filter & " and " & cscDeplId & " in (select depl_id from depositoLogico where depf_id = " & depf_id & ")"
      
      ' Sino es por deposito fisico exijo que este
      ' en el deposito logico que me pasaron
      '
    ElseIf ctrlStock = csEStockLogico Then
      filter = filter & " and " & cscDeplId & " = " & depl_id
    End If
  End If
  
  Dim prns_id  As Long
  Dim KitSerie As cKitSerieNumber
  Set KitSerie = Serie.Items(KitGetKeyItem(lRowKey, lColKey))
  If Not KitSerie Is Nothing Then
    If KitSerie.pr_id = pr_id Then
      prns_id = KitSerie.prns_id
      filter = "(" & filter & ") or ( prns_id = " & prns_id & ")"
    End If
  End If
  
  Dim FilterAux As String
  FilterAux = KitGetPrnsIdUsed(pr_id, _
                               prns_id, _
                               lRow, _
                               lCol, _
                               KitLns, _
                               KitLn, _
                               ObjAbm, _
                               bEditAux)
  
  If FilterAux <> vbNullString Then
    filter = "(" & filter & ") and ( prns_id not in (" & _
             FilterAux & "))"
  End If
  
  KitGetFilterSerie = filter
End Function

Public Function KitGetPropKey(ByVal idx As Long, ByVal What As csE_ColType) As String
  ' El +1 es por que agregue a la grilla
  ' una columna para indicar que kit estoy
  ' borrando cuando reduzco la cantidad
  '
  ' Aclaro que esto de borrar el kit se refiere
  ' a partes nuevos donde por error indique mas
  ' kits que los que hiba a producir y para no
  ' tirar todo el parte, le permito indicar que
  ' kit es el que esta demas
  '
  KitGetPropKey = idx + 1 + What
End Function

Public Function KitGetKeyItem(ByVal lRow As Long, _
                              ByVal lCol As Long) As String
  KitGetKeyItem = lRow & "-" & lCol
End Function

Public Function KitGetPrnsIdUsed(ByVal pr_id As Long, _
                                 ByVal prns_id As Long, _
                                 ByVal lRow As Long, _
                                 ByVal lCol As Long, _
                                 ByRef oKitLns As cKitLines, _
                                 ByRef oKitLn As cKitLine, _
                                 ByRef ObjAbm As cIABMGeneric, _
                                 ByVal bEditAux As Boolean) As String
  Dim rtn         As String
  Dim KitLn       As cKitLine
  Dim Kit         As cKit
  Dim Serie       As cKitSerie
  Dim ItemSerie   As cKitSerieNumber
  Dim prns_id2    As Long
  Dim vSeries()   As String
  Dim idx         As Long
  Dim ubSeries    As Long
  
  ubSeries = 400
  ReDim vSeries(ubSeries)
  
  ' Por cada renglon del parte de produccion de Kit
  '
  For Each KitLn In oKitLns
  
    ' Excepto el renglon que estoy editando
    ' que lo voy a sacar de la grilla,
    ' excepto cuando tiene alternativas
    '
    If (Not KitLn Is oKitLn) Or bEditAux Then
      
      ' Por cada kit en el renglon
      '
      For Each Kit In KitLn.Items
      
        ' Por cada producto con serie en el Kit
        '
        For Each Serie In Kit.Series
          For Each ItemSerie In Serie.Items
          
            ' Si el pr_id del serie que voy a mostrar
            ' conincide con el de este item_serie
            '
            If pr_id = ItemSerie.pr_id Then
              
              prns_id2 = ItemSerie.prns_id
              
              If prns_id <> prns_id2 Then

                If idx > ubSeries Then
                  ubSeries = ubSeries + 400
                  ReDim Preserve vSeries(ubSeries)
                End If
                
                vSeries(idx) = prns_id2
                
                idx = idx + 1

              End If
            End If
          Next
        Next
      Next
    End If
  Next
  
  Dim iKey As Long
  Dim Row  As cIABMGridRow
  Dim Rows As cIABMGridRows
  Dim q    As Long
  
  With ObjAbm.Properties.Item(c_Items).Grid
    iKey = .Columns(lCol).Key
    Set Rows = .Rows
  End With
  
  For q = 1 To Rows.Count
    If lRow <> q Then
      Set Row = Rows.Item(q)
      prns_id2 = pCell(Row, iKey).Id
      
      If prns_id2 And prns_id2 <> prns_id Then
        
        If idx > ubSeries Then
          ubSeries = ubSeries + 400
          ReDim Preserve vSeries(ubSeries)
        End If
        
        vSeries(idx) = prns_id2
        
        idx = idx + 1

      End If
    End If
  Next
  
  idx = idx - 1
  If idx >= 0 Then
    ReDim Preserve vSeries(idx)
    KitGetPrnsIdUsed = Join(vSeries, ",")
  Else
    KitGetPrnsIdUsed = vbNullString
  End If
  
End Function

Public Function KitGetKit(ByRef KitLn As cKitLine, _
                          ByVal lRow As Long) As cKit
  Dim rtn     As cKit
  Dim Serie   As cKitSerie
  Dim Lote    As cKitLote
  Dim Alt     As cKitItem
  Dim Var     As cKitVar
  
  Set rtn = KitLn.Items.Item(GetKey(lRow))
  If rtn Is Nothing Then
    Set rtn = KitLn.Items.Add(GetKey(lRow), Nothing)
    With KitLn.KitType
      rtn.Cantidad = .Cantidad
      rtn.prsk_id = .prsk_id
      rtn.Nombre = .Nombre
      rtn.pr_id = .pr_id
      rtn.prfk_id = .prfk_id
      
      rtn.bIdentidad = .bIdentidad
      rtn.bIdentidadXItem = .bIdentidadXItem
      rtn.bLote = .bLote
      rtn.bLoteXItem = .bLoteXItem
      rtn.ta_id_lote = .ta_id_lote
      rtn.ta_id_serie = .ta_id_serie
      rtn.pr_id_lote = .pr_id_lote
      rtn.pr_id_serie = .pr_id_serie
      
      For Each Serie In .Series
        KitCopySerie Serie, _
                     rtn.Series.Add(Serie.prk_id)
        '
        ' A borrar cuando baje el IC
        '
        '
          'With rtn.Series.Add(Serie.prk_id)
          '  .Cantidad = Serie.Cantidad
          '  .Nombre = Serie.Nombre
          '  .pr_id = Serie.pr_id
          '  .prk_id = Serie.prk_id
          '  .Variable = Serie.Variable
          '  .ta_id = Serie.ta_id
          '  .bTalEdit = Serie.bTalEdit
          '  pFillAlts Serie.Alts, .Alts
          'End With
      Next
    
      For Each Lote In .Lotes
        KitCopyLote Lote, _
                    rtn.Lotes.Add(Lote.prk_id)
                    
        '
        ' A borrar cuando baje el IC
        '
        '
          'With rtn.Lotes.Add(Lote.prk_id)
          '  .Cantidad = Lote.Cantidad
          '  .Nombre = Lote.Nombre
          '  .pr_id = Lote.pr_id
          '  .prk_id = Lote.prk_id
          '  .Variable = Lote.Variable
          '  .ta_id = Lote.ta_id
          '  .bTalEdit = Lote.bTalEdit
          '  pFillAlts Lote.Alts, .Alts
          'End With
      Next
    
      For Each Alt In .Alts
        KitCopyAlt Alt, _
                   rtn.Alts.Add(Alt.prk_id)
        
        '
        ' A borrar cuando baje el IC
        '
        '
          'With rtn.Alts.Add(Alt.prk_id)
          '  .Cantidad = Alt.Cantidad
          '  .Nombre = Alt.Nombre
          '  .pr_id = Alt.pr_id
          '  .prk_id = Alt.prk_id
          '  .Variable = Alt.Variable
          '  pFillAlts Alt.Alts, .Alts
          'End With
      Next
    
      For Each Var In .Vars
        KitCopyVar Var, _
                   rtn.Vars.Add(Var.prk_id)
                   
        '
        ' A borrar cuando baje el IC
        '
        '
          'With rtn.Vars.Add(Var.prk_id)
          '  .Cantidad = Var.Cantidad
          '  .Nombre = Var.Nombre
          '  .pr_id = Var.pr_id
          '  .prk_id = Var.prk_id
          'End With
      Next
    End With
  End If
  
  Set KitGetKit = rtn
End Function

Public Sub KitCopySerie(ByRef SerieFrom As cKitSerie, _
                        ByRef SerieTo As cKitSerie)

  With SerieTo
    .Cantidad = SerieFrom.Cantidad
    .Nombre = SerieFrom.Nombre
    .pr_id = SerieFrom.pr_id
    .prk_id = SerieFrom.prk_id
    .Variable = SerieFrom.Variable
    .ta_id = SerieFrom.ta_id
    .bTalEdit = SerieFrom.bTalEdit
    pFillAlts SerieFrom.Alts, .Alts
  End With

End Sub

Public Sub KitCopyLote(ByRef LoteFrom As cKitLote, _
                       ByRef LoteTo As cKitLote)
                       
  With LoteTo
    .Cantidad = LoteFrom.Cantidad
    .Nombre = LoteFrom.Nombre
    .pr_id = LoteFrom.pr_id
    .prk_id = LoteFrom.prk_id
    .Variable = LoteFrom.Variable
    .ta_id = LoteFrom.ta_id
    .bTalEdit = LoteFrom.bTalEdit
    pFillAlts LoteFrom.Alts, .Alts
  End With
End Sub

Public Sub KitCopyAlt(ByRef AltFrom As cKitItem, _
                      ByRef AltTo As cKitItem)
  
  With AltTo
    .Cantidad = AltFrom.Cantidad
    .Nombre = AltFrom.Nombre
    .pr_id = AltFrom.pr_id
    .prk_id = AltFrom.prk_id
    .Variable = AltFrom.Variable
    pFillAlts AltFrom.Alts, .Alts
  End With
End Sub

Public Sub KitCopyVar(ByRef VarFrom As cKitVar, _
                      ByRef VarTo As cKitVar)
  
  With VarTo
    .Cantidad = VarFrom.Cantidad
    .Nombre = VarFrom.Nombre
    .pr_id = VarFrom.pr_id
    .prk_id = VarFrom.prk_id
  End With
End Sub

Private Sub pFillAlts(ByRef SourceAlts As cKitAlts, _
                      ByRef DestAlts As cKitAlts)
  Dim Alt As cKitAlt
  For Each Alt In SourceAlts
    With DestAlts.Add()
      .Nombre = Alt.Nombre
      .pr_id = Alt.pr_id
    End With
  Next
End Sub

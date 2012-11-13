Attribute VB_Name = "mPercepciones"
Option Explicit

Public Const KI_CCOS_ID                        As Integer = 22
Public Const KIP_IMPORTE                       As Integer = 1
Public Const KIP_PERC_ID                       As Integer = 2
Public Const KIP_PORCENTAJE                    As Integer = 3
Public Const KIP_BASE                          As Integer = 4
Public Const KIP_DESCRIP                       As Integer = 5
Public Const KIP_FCPERC_ID                     As Integer = 7


Public Const c_Wiz_Key_percepciones = "PERCEP"
Public Const c_Wiz_Key_TotalPercepciones = "TotalPercep"

Public Sub LoadPercepciones(ByRef Grid As cIABMGrid, ByRef grlCfg As cGeneralConfig)
  ' La primera simpre esta invisible
  With Grid.Columns
    With .Add(Nothing)
      .Visible = False
      .Key = KIP_FCPERC_ID
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1252, vbNullString)  'Percepcion
      .PropertyType = cspHelp
      .Table = csPercepcion
      .Width = 1800
      .Key = KIP_PERC_ID
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(2546, vbNullString) 'Base Imponible
      .PropertyType = cspNumeric
      .SubType = cspMoney
      .Format = grlCfg.FormatDecImporte
      .Width = 1200
      .Key = KIP_BASE
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1105, vbNullString) 'Porcentaje
      .PropertyType = cspNumeric
      .SubType = cspPercent
      .Width = 1200
      .Key = KIP_PORCENTAJE
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1228, vbNullString)  'Importe
      .PropertyType = cspNumeric
      .Format = grlCfg.FormatDecImporte
      .SubType = cspMoney
      .Width = 1200
      .Key = KIP_IMPORTE
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1861, vbNullString) 'Observaciones
      .PropertyType = cspText
      .Width = 1800
      .Key = KIP_DESCRIP
    End With
    
    With .Add(Nothing)
      .Name = LNGGetText(1057, vbNullString) 'Centro de Costo
      .PropertyType = cspHelp
      .Table = csCentroCosto
      .Width = 1800
      .Key = KI_CCOS_ID
    End With
  End With
End Sub

Public Function ValidateRowPercepciones(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  strRow = " (Fila " & RowIndex & ")"
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KIP_PERC_ID
        If ValEmpty(Cell.Id, csId) Then
          MsgInfo LNGGetText(1535, vbNullString, strRow) 'Debe indicar una percepcion
          Exit Function
        End If
      Case KIP_BASE
        If ValEmpty(Cell.Value, csCurrency) Then
          MsgInfo LNGGetText(2547, vbNullString, strRow) 'Debe indicar una base imponible
          Exit Function
        End If
      Case KIP_PORCENTAJE
        If ValEmpty(Cell.Value, csCurrency) Then
          MsgInfo LNGGetText(1098, vbNullString, strRow) 'Debe indicar un porcentaje
          Exit Function
        End If
      Case KIP_IMPORTE
        If ValEmpty(Cell.Value, csCurrency) Then
          MsgInfo LNGGetText(1897, vbNullString, strRow) 'Debe indicar un importe
          Exit Function
        End If
    End Select
  Next
  
  ValidateRowPercepciones = True
End Function

Public Function IsEmptyRowPercepciones(ByRef Row As CSInterfacesABM.cIABMGridRow, ByVal RowIndex As Long) As Boolean
  Dim Cell                  As cIABMGridCellValue
  Dim strRow                As String
  Dim bRowIsEmpty           As Boolean
  
  strRow = " (Fila " & RowIndex & ")"
  
  bRowIsEmpty = True
  
  For Each Cell In Row
    Select Case Cell.Key
      Case KIP_IMPORTE
        If Not ValEmpty(Cell.Value, csCurrency) Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KIP_PERC_ID
        If Not ValEmpty(Cell.Id, csId) Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KIP_PORCENTAJE
        If Not ValEmpty(Cell.Value, csDouble) Then
          bRowIsEmpty = False
          Exit For
        End If
      Case KIP_BASE
        If Not ValEmpty(Cell.Value, csCurrency) Then
          bRowIsEmpty = False
          Exit For
        End If
    End Select
  Next
  
  IsEmptyRowPercepciones = bRowIsEmpty
End Function

Public Sub PercepcionShowTotales(ByRef RowsPercep As cIABMGridRows, ByRef iPropPercep As cIABMProperty)
  Dim Percep    As Double
  Dim Row       As CSInterfacesABM.cIABMGridRow
  
  For Each Row In RowsPercep
    Percep = Percep + Val(pCell(Row, KIP_IMPORTE).Value)
  Next
  
  iPropPercep.Value = Percep
End Sub

Public Function ColumnAfterEditPercepciones(ByRef IProperty As cIABMProperty, ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long)
  Dim Row     As cIABMGridRow
  
  With IProperty.Grid.Columns(lCol)
    Select Case .Key
      Case KIP_BASE
        Set Row = IProperty.Grid.Rows(lRow)
        With pCell(Row, KIP_BASE)
          If Val(NewValue) < 0 Then
            .Value = 0
          ElseIf Val(NewValue) > 0 Then
            pCell(Row, KIP_IMPORTE).Value = (NewValue * Val(pCell(Row, KIP_PORCENTAJE).Value)) / 100
          End If
        End With
      Case KIP_IMPORTE
        Set Row = IProperty.Grid.Rows(lRow)
        With pCell(Row, KIP_IMPORTE)
          If Val(NewValue) < 0 Then
            .Value = 0
          ElseIf Val(NewValue) > 0 Then
            Dim Percent As Double
            Percent = Val(pCell(Row, KIP_PORCENTAJE).Value)
            If Percent = 0 Then
              Percent = 1
              pCell(Row, KIP_PORCENTAJE).Value = 1
            End If
            pCell(Row, KIP_BASE).Value = DivideByCero(NewValue, Percent) * 100
          End If
        End With
      Case KIP_PORCENTAJE
        Set Row = IProperty.Grid.Rows(lRow)
        With pCell(Row, KIP_PORCENTAJE)
          If Val(NewValue) < 0 Then
            .Value = 0
          ElseIf Val(NewValue) > 0 Then
            pCell(Row, KIP_IMPORTE).Value = (Val(pCell(Row, KIP_BASE).Value) * NewValue) / 100
          End If
        End With
    End Select
  End With
  
  ColumnAfterEditPercepciones = True
End Function

Public Function SavePercepciones(ByRef iProp As cIABMProperty, _
                                 ByVal Id As Long, _
                                 ByVal Cotizacion As Double, _
                                 ByVal bMonedaLegal As Boolean, _
                                 ByVal Copy As Boolean, _
                                 ByVal deleted As String, _
                                 ByVal FcId As Long, _
                                 ByVal Module As String) As Boolean
  
  Dim c_ErrorSave As String
  
  c_ErrorSave = LNGGetText(1907, vbNullString) 'Error al grabar la factura de compra
  
  Dim register  As cRegister
  Dim iOrden    As Long
  Dim Origen    As Double
  
  With iProp
    Dim Row  As cIABMGridRow
    Dim Cell As cIABMGridCellValue
    
    For Each Row In .Grid.Rows
    
      Set register = New cRegister
      register.fieldId = cscFcPercTMPId
      register.Table = csTFacturaCompraPercepcionTMP
      register.Id = csNew
      
      For Each Cell In Row
        Select Case Cell.Key
          
          Case KIP_FCPERC_ID
            If Copy Then
              register.fields.Add2 cscFcPercId, csNew, csInteger
            Else
              register.fields.Add2 cscFcPercId, Val(Cell.Value), csInteger
            End If
          Case KIP_PERC_ID
            register.fields.Add2 cscPercId, Cell.Id, csId
          Case KIP_BASE
            register.fields.Add2 cscFcPercBase, Val(Cell.Value), csCurrency
          Case KIP_PORCENTAJE
            register.fields.Add2 cscFcPercPorcentaje, Val(Cell.Value), csCurrency
          Case KIP_IMPORTE
            Origen = Val(Cell.Value)
            register.fields.Add2 cscFcPercImporte, Origen * Cotizacion, csCurrency
          Case KI_CCOS_ID
            register.fields.Add2 cscCcosId, Cell.Id, csId
          Case KIP_DESCRIP
            register.fields.Add2 cscFcPercDescrip, Cell.Value, csText
        End Select
      Next
      
      If bMonedaLegal Then
        register.fields.Add2 cscFcPercOrigen, 0, csCurrency
      Else
        register.fields.Add2 cscFcPercOrigen, Origen, csCurrency
      End If
      
      iOrden = iOrden + 1
      register.fields.Add2 cscFcPercOrden, iOrden, csInteger
      register.fields.Add2 cscFcTMPId, Id, csId
      
      register.fields.HaveLastUpdate = False
      register.fields.HaveWhoModify = False
      
      If Not gDB.Save(register, , "pSavePercepciones", Module, c_ErrorSave) Then Exit Function
    Next
  End With
  
  Dim sqlstmt As String
  
  If deleted <> vbNullString And FcId <> csNO_ID Then
  
    Dim vDeletes As Variant
    Dim i As Long
    
    deleted = RemoveLastColon(deleted)
    vDeletes = Split(deleted, ",")
    
    For i = 0 To UBound(vDeletes)
    
      Set register = New cRegister
      register.fieldId = cscFcPercbTMPId
      register.Table = csTFacturaCompraPercepcionBorradoTMP
      register.Id = csNew
      
      register.fields.Add2 cscFcPercId, Val(vDeletes(i)), csInteger
      register.fields.Add2 cscFcId, FcId, csId
      register.fields.Add2 cscFcTMPId, Id, csId
      
      register.fields.HaveLastUpdate = False
      register.fields.HaveWhoModify = False
      
      If Not gDB.Save(register, , "pSavePercepciones", Module, c_ErrorSave) Then Exit Function
    Next
    
  End If
  
  SavePercepciones = True
End Function


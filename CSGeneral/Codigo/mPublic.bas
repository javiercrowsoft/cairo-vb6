Attribute VB_Name = "mPublic"
Option Explicit

'--------------------------------------------------------------------------------
' mPublic
' 20-01-01

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

Public gFormatDecCantidad As String

' funciones publicas
Public Function GetCtaGrupoFilter(ByVal Tipo As csE_CuentaGrupoTipo) As String
  Dim filter    As String
                             
  Select Case Tipo
    Case csECuecTipoAcreedor
      filter = "cuec_id in (2,8)" ' Bancos y Acreedores
    Case csECuecTipoDeudor
      filter = "cuec_id = 4" ' Deudores
    Case csECuecTipoProductoCompra
      filter = "cuec_id in (5,6,9,10) or cue_producto <> 0" ' Bienes de cambio y de uso, y Egresos e Ingresos (para descuentos obtenidos)
    Case csECuecTipoProductoVenta
      filter = "cuec_id in (9,10) or cue_producto <> 0" ' Ingresos y Egresos (para descuentos cedidos)
    Case csECuecTipoDebitoAutomatico
      filter = "cuec_id = 2" ' Bancos
    Case csECuecTipoFondoFijo
      filter = "cuec_id =  14" ' Caja
    Case Else
      filter = "1=2"
  End Select
  
  GetCtaGrupoFilter = filter

End Function

Public Function ColAUpdateCtaGrupo(ByRef IProperty As cIABMProperty, _
                                   ByVal lRow As Long, _
                                   ByVal lCol As Long, _
                                   ByRef AbmObj As cABMGeneric, _
                                   ByVal KI_CUEG_ID As Long, _
                                   ByVal KI_CUE_ID As Long) As Boolean
  With IProperty.Grid
    Select Case .Columns(lCol).Key
  
      Case KI_CUE_ID
        
        Dim cueg_id   As Long
        Dim filter    As String
        Dim Row       As cIABMGridRow
        
        Set Row = .Rows(lRow)
        
        cueg_id = pCell(Row, KI_CUEG_ID).Id
        
        filter = GetCtaGrupoFilter(pGetTipoFromCuentaGrupo(cueg_id))
        
        pCol(IProperty.Grid.Columns, KI_CUE_ID).HelpFilter = filter
        
        AbmObj.RefreshColumnProperties IProperty, cscCueId
      End Select
      
  End With
  ColAUpdateCtaGrupo = True
End Function

' funciones privadas
Private Function pGetTipoFromCuentaGrupo(ByVal cueg_id As Long) As Long
  
  If cueg_id <> csNO_ID Then
    Dim Tipo As Long
    If Not gDB.GetData(csTCuentaGrupo, _
                       cscCuegId, _
                       cueg_id, _
                       cscCuegTipo, _
                       Tipo) Then Exit Function
    pGetTipoFromCuentaGrupo = Tipo
  Else
    pGetTipoFromCuentaGrupo = 0
  End If
  
End Function

'Private Function pGetCueIdFromCuentaGrupo(ByVal cueg_id As Long) As Long
'
'  If cueg_id <> csNO_ID Then
'    Dim Cue_id As Long
'    If Not gDB.GetData(csTCuentaGrupo, _
'                       cscCuegId, _
'                       cueg_id, _
'                       cscCueId, _
'                       Cue_id) Then Exit Function
'    pGetCueIdFromCuentaGrupo = Cue_id
'  Else
'    pGetCueIdFromCuentaGrupo = csNO_ID
'  End If
'
'End Function

Public Function GetCuecIdFromCueId(ByVal Cue_id As Long) As Long
  
  If Cue_id <> csNO_ID Then
    Dim cuec_id As Long
    If Not gDB.GetData(csTCuenta, _
                       cscCueId, _
                       Cue_id, _
                       cscCuecId, _
                       cuec_id) Then Exit Function
    GetCuecIdFromCueId = cuec_id
  Else
    GetCuecIdFromCueId = csNO_ID
  End If

End Function
' construccion - destruccion


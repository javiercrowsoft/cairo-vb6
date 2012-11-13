VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cEditPrecio"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Private Const C_Module = "Edit"
Private Const csProducto = 30

Private Const c_SetPrecio = 1

Private WithEvents m_fEditPrecio As fEditPrecio
Attribute m_fEditPrecio.VB_VarHelpID = -1
Private m_db                     As cDataBase
Private m_lp_id                  As Long

Public Function Edit(ByVal lp_id As Long, ByRef db As cDataBase) As Boolean
  On Error GoTo ControlError
  
  Dim f As fEditPrecio
  Set f = New fEditPrecio
  
  Set m_fEditPrecio = f
  
  m_lp_id = lp_id
  
  With f.treePrecios
    .SpGetHojas = "Sp_ArbGetHojasListaPrecio " & lp_id & ","
    .AddMenu LNGGetText(3100, vbNullString), c_SetPrecio
              'Indicar precio
    If Not .Load(csProducto) Then GoTo ExitProc
  End With
  
  Set m_db = db
  
  f.Show vbModal

  Edit = True

  GoTo ExitProc
ControlError:
  MngError Err, "Edit", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
  Set m_fEditPrecio = Nothing
  Unload f
  Set f = Nothing
  Set m_db = Nothing
End Function

Private Sub m_fEditPrecio_MenuClick(ByVal MenuId As Long)
  On Error GoTo ControlError
  
  Select Case MenuId
    Case c_SetPrecio
      pSetPrecio
  End Select

  GoTo ExitProc
ControlError:
  MngError Err, "m_fEditPrecio_MenuClick", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub pSetPrecio()
  On Error GoTo ControlError
  Dim sqlstmt   As String
  Dim rs        As Recordset
  Dim Price     As Double
  Dim strPrice  As String
  
  If Not CSKernelClient2.GetInput(strPrice, LNGGetText(3101, vbNullString)) Then Exit Sub
                                            'Indique un precio
  Price = Val(strPrice)
  
  If Price <= 0 Then
    MsgWarning LNGGetText(3102, vbNullString) 'El precio debe ser mayor a cero
    Exit Sub
  End If
  
  sqlstmt = "select id from hoja where ram_id = " & m_fEditPrecio.treePrecios.BranchId
  
  If Not m_db.OpenRs(sqlstmt, rs) Then Exit Sub
  
  While Not rs.EOF
    If Not pSetPrecioAux(m_db.ValField(rs.Fields, "id"), Price) Then Exit Sub
    rs.MoveNext
  Wend

  MsgInfo LNGGetText(3103, vbNullString) 'Los precios se asignaron con éxito

  GoTo ExitProc
ControlError:
  MngError Err, "pSetPrecio", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Function pSetPrecioAux(ByVal pr_id As Long, ByVal Price As Double) As Boolean
  On Error GoTo ControlError
  
  Dim sqlstmt As String
  Dim rs      As Recordset
  Dim lpi_id  As Long
  Dim bIsNew  As Boolean
  
  sqlstmt = "select lpi_id from ListaPrecioItem where lp_id = " & m_lp_id & " and pr_id = " & pr_id
  
  If Not m_db.OpenRs(sqlstmt, rs) Then Exit Function
  
  If Not rs.EOF Then
    lpi_id = m_db.ValField(rs.Fields, "lpi_id")
    
  Else
    bIsNew = True
    If Not m_db.GetNewId("ListaPrecioItem", "lpi_id", lpi_id) Then Exit Function
  End If

  If bIsNew Then
    sqlstmt = "insert into ListaPrecioItem (lp_id,lpi_id,lpi_precio,lpi_porcentaje,pr_id,activo,modifico)" & vbCrLf
    sqlstmt = sqlstmt & "values(" & m_lp_id & "," & lpi_id & "," & m_db.sqlNumber(Price) & ",0," & pr_id & ",1,1)"
  Else
    sqlstmt = "update ListaPrecioItem set lpi_precio = " & m_db.sqlNumber(Price) & vbCrLf
    sqlstmt = sqlstmt & "where lpi_id = " & lpi_id
  End If
  
  If Not m_db.Execute(sqlstmt) Then Exit Function

  pSetPrecioAux = True

  GoTo ExitProc
ControlError:
  MngError Err, "pSetPrecioAux", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function Val(ByVal Value As String) As Double
  Dim SepDecimal As String
  SepDecimal = GetSepDecimal()
  
  Value = Replace(Value, SepDecimal, ".")
  Val = VBA.Val(Value)
End Function


Attribute VB_Name = "mPublicTransporte"
Option Explicit

Public Function GetTransporteData(ByVal trans_id As Long, _
                                  ByRef chof_id As Long, _
                                  ByRef chofer As String, _
                                  ByRef cam_id As Long, _
                                  ByRef camion As String) As Boolean

  ' TODO: Agregar camion y chofer por defecto a transporte
  chof_id = csNO_ID
  cam_id = csNO_ID
  chofer = vbNullString
  camion = vbNullString
  
  GetTransporteData = True
End Function

Public Function GetChoferData(ByVal chof_id As Long, _
                              ByRef cam_id As Long, _
                              ByRef camion As String, _
                              ByRef cam_id_semi As Long, _
                              ByRef semi As String) As Boolean

  ' TODO: Agregar camion y chofer por defecto a transporte
  cam_id = csNO_ID
  cam_id_semi = csNO_ID
  camion = vbNullString
  semi = vbNullString
  
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "select cam_patente, cam_patentesemi, chof.cam_id " & _
            "from chofer chof inner join camion cam on chof.cam_id = cam.cam_id " & _
            "where chof.chof_id = " & chof_id
            
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  If Not rs.EOF Then
    cam_id = gDB.ValField(rs.Fields, cscCamId)
    camion = gDB.ValField(rs.Fields, cscCamPatente)
    semi = gDB.ValField(rs.Fields, cscCamPatenteSemi)
    If LenB(semi) Then
      cam_id_semi = cam_id
    End If
  End If
  
  GetChoferData = True
End Function

Public Function GetHelpTransporte(ByVal trans_id As Long) As String
  GetHelpTransporte = "(trans_id = " & trans_id & " or trans_id is null)"
End Function



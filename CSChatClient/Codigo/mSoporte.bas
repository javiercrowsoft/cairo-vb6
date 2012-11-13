Attribute VB_Name = "mSoporte"
Option Explicit

' Esta variable define si la aplicacion
' es para conectarse al server crowsoft.dyndns.org
' y recibir soporte via chat, o para uso de chat
' interno de los clientes
'

Public gIsSoporte As Boolean

Public Sub SetIsSoporte()
  ' Para compilar un chat de soporte
  ' solo hay que descomentar esta linea
  '
#If PREPROC_SOPORTE Then
  gIsSoporte = True
#End If
End Sub

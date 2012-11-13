VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cTCPIPManager"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cTCPIPManager
' 03-11-2002

'--------------------------------------------------------------------------------
' notas: Formato de un mensaje:
'
'         [BOP][id cliente][id paquete][id de paquete TCP-IP][id de servicio]mensaje[EOP]
'
'   si el paquete esta dividido entre varios paquetes TCP-IP
'
'         [BOP][id cliente][id paquete][id de paquete TCP-IP][id de servicio]mensaje[   ]
'         [BOP][id cliente][id paquete][id de paquete TCP-IP]mensaje[   ]
'         [BOP][id cliente][id paquete][id de paquete TCP-IP]mensaje[   ]
'         [BOP][id cliente][id paquete][id de paquete TCP-IP]mensaje[EOP]


'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cTCPIPManager"

Private Const c_BOP = "[BOP]"
Private Const c_EOP = "[EOP]"
Private Const c_EOP2 = "[   ]"

Private Const c_MaxLenMessageTCPIP = 1024

Private Enum csEBloq
  csEBloqClientId = 1
  csEBloqMessageId
  csEBloqTCPIPId
  csEBloqServiceId
  csEBloqMessage
End Enum

' estructuras
' variables privadas
Private c_LenBOP  As Integer
Private c_LenEOP  As Integer

Private m_ClientId      As Long
Private m_MessageId     As Long
Private m_TCPIPId       As Long
Private m_ServiceId     As Long
' eventos
' propiedadades publicas
Public Property Get ClientId() As Long
   ClientId = m_ClientId
End Property

Public Property Get MessageId() As Long
   MessageId = m_MessageId
End Property

Public Property Get TCPIPId() As Long
   TCPIPId = m_TCPIPId
End Property

Public Property Get ServiceId() As Long
   ServiceId = m_ServiceId
End Property
' propiedadades friend
' propiedades privadas
' funciones publicas
Public Function CreateMessageToSend(ByRef StrMessage As String, _
                                    ByRef From As Long, _
                                    ByVal ClientId As Long, _
                                    ByVal MessageId As Long, _
                                    ByVal ServiceId As Long, _
                                    ByRef TCPIPId As Long) As String
    Dim BeginBlock    As String
    Dim EndBlock      As String
    Dim MaxLenMessage As Integer
    Dim LenMessage    As Long
    Dim nFrom         As Long
    
    BeginBlock = c_BOP & "[" & ClientId & "][" & MessageId & "]["
    
    If From < 1 Then From = 1
    
    nFrom = From
    
    If nFrom = 1 Then
      TCPIPId = 1
      BeginBlock = BeginBlock & "1][" & ServiceId & "]"
    Else
      TCPIPId = TCPIPId + 1
      BeginBlock = BeginBlock & TCPIPId & "]"
    End If
    
    MaxLenMessage = c_MaxLenMessageTCPIP - Len(BeginBlock) - c_LenEOP
    
    LenMessage = Len(StrMessage) - nFrom + 1
    
    If LenMessage > MaxLenMessage Then
      LenMessage = MaxLenMessage
      From = From + LenMessage
      EndBlock = c_EOP2
    Else
      From = 0
      EndBlock = c_EOP
    End If

    CreateMessageToSend = BeginBlock & Mid$(StrMessage, nFrom, LenMessage) & EndBlock
End Function

Public Function IsValid(ByRef ByteArray() As Byte) As Boolean
  Dim IDAux As Long
  
  If Not pHaveBOPMark(ByteArray()) Then Exit Function
  
  IDAux = pGetClientID(ByteArray())
  If IDAux = 0 Then Exit Function
  
  m_ClientId = IDAux

  IDAux = pGetMessageID(ByteArray())
  If IDAux = 0 Then Exit Function
  
  m_MessageId = IDAux
  
  IDAux = pGetTCPIPBlockID(ByteArray())
  If IDAux = 0 Then Exit Function
  
  m_TCPIPId = IDAux
  
  If IDAux = 1 Then
    IDAux = pGetServiceID(ByteArray())
    If IDAux = 0 Then Exit Function
    
    m_ServiceId = IDAux
  End If
  
  IsValid = True
  
End Function

Public Function GetTCPIPBlockID(ByRef ByteArray() As Byte) As Long
  GetTCPIPBlockID = pGetTCPIPBlockID(ByteArray())
End Function

Public Function GetClientID(ByRef ByteArray() As Byte) As Long
  GetClientID = pGetClientID(ByteArray())
End Function

Public Function GetMessageID(ByRef ByteArray() As Byte) As Long
  GetMessageID = pGetMessageID(ByteArray())
End Function

Public Function GetServiceID(ByRef ByteArray() As Byte) As Long
  GetServiceID = pGetServiceID(ByteArray())
End Function

Public Function GetMessage(ByRef ByteArray() As Byte) As Long
  GetMessage = pGetMessage(ByteArray())
End Function

Public Function IsEOP(ByRef ByteArray() As Byte) As Boolean
  IsEOP = pHaveEOPMark(ByteArray())
End Function
' funciones friend
' funciones privadas
Public Function pGetTCPIPBlockID(ByRef ByteArray() As Byte) As Long
  pGetTCPIPBlockID = pGetBlockValue(ByteArray(), csEBloqTCPIPId)
End Function

Public Function pGetClientID(ByRef ByteArray() As Byte) As Long
  pGetClientID = pGetBlockValue(ByteArray(), csEBloqClientId)
End Function

Public Function pGetMessageID(ByRef ByteArray() As Byte) As Long
  pGetMessageID = pGetBlockValue(ByteArray(), csEBloqMessageId)
End Function

Public Function pGetServiceID(ByRef ByteArray() As Byte) As Long
  pGetServiceID = pGetBlockValue(ByteArray(), csEBloqServiceId)
End Function

Public Function pGetMessage(ByRef ByteArray() As Byte) As Long
  pGetMessage = pGetBlockValue(ByteArray(), csEBloqMessage)
End Function

Private Function pHaveBOPMark(ByRef ByteArray() As Byte) As Boolean
  Dim i As Integer
  Dim s As String
  If UBound(ByteArray) < c_LenBOP - 1 Then Exit Function
  For i = 0 To c_LenBOP - 1
    s = s & Chr$(ByteArray(i))
  Next
  pHaveBOPMark = c_BOP = s
End Function

Private Function pHaveEOPMark(ByRef ByteArray() As Byte) As Boolean
  Dim i As Integer
  Dim s As String
  Dim UboundByteArray As Integer
  
  UboundByteArray = UBound(ByteArray)
  
  If UboundByteArray < c_LenEOP - 1 Then Exit Function
  For i = UboundByteArray To UboundByteArray - c_LenBOP + 1 Step -1
    s = Chr$(ByteArray(i)) & s
  Next
  pHaveEOPMark = c_EOP = s
End Function

Private Function pGetBlockValue(ByRef ByteArray() As Byte, ByRef Block As csEBloq) As Long
' [BOP][id cliente][id mensaje][id de secuencia TCP-IP][id de servicio]mensaje[   ]
' [BOP][id cliente][id mensaje][id de secuencia TCP-IP]mensaje[   ]
' [BOP][id cliente][id mensaje][id de secuencia TCP-IP]mensaje[EOP]
' 1    2           3           4                        5
'     1           2           3                     4               5

  Dim n As Integer
  Dim i As Integer
  Dim ascBrackets       As Integer
  Dim UboundByteArray   As Integer
  Dim q   As Integer
  Dim c   As String
  Dim Id  As String
  
  ' El final del vector no incluye [EOP]
  UboundByteArray = UBound(ByteArray) - c_LenEOP
  
  If Block = csEBloqMessage Then
  
    ascBrackets = Asc("]")
    n = 4
    
    pGoToBracket ByteArray, i, UboundByteArray, n, ascBrackets
    
    If i <= UboundByteArray Then
      ' Estoy en -------------------------------------------
      '                                                    |
      '                                                    |
      ' [BOP][id cliente][id paquete][id de paquete TCP-IP][id de servicio]mensaje[EOP]
      ' 1    2           3           4                     5
      '     1           2           3                     4               5
      If ByteArray(i) = Asc("[") And m_TCPIPId = 1 Then
        pGoToBracket ByteArray, i, UboundByteArray, 1, ascBrackets
      End If
      
      If i <= UboundByteArray Then
        q = 0
        For i = i To UboundByteArray
          ByteArray(q) = ByteArray(i)
          q = q + 1
        Next
        If q > 0 Then q = q - 1
        ReDim Preserve ByteArray(q)
      End If
    End If
  
  Else
    
    ascBrackets = Asc("[")
    
    Select Case Block
      Case csEBloq.csEBloqClientId
        n = 2
      Case csEBloq.csEBloqMessageId
        n = 3
      Case csEBloq.csEBloqTCPIPId
        n = 4
      Case csEBloq.csEBloqServiceId
        n = 5
    End Select
    
    pGoToBracket ByteArray, i, UboundByteArray, n, ascBrackets
    
    ascBrackets = Asc("]")
    
    If i < UboundByteArray Then
      Do
        If ByteArray(i) = ascBrackets Then Exit Do
        c = Chr(ByteArray(i))
        Id = Id & c
        i = i + 1
      Loop Until i > UboundByteArray
    End If
    
    If Not IsNumeric(Id) Then
      pGetBlockValue = 0
    Else
      pGetBlockValue = Id
    End If
  End If
End Function

Private Sub pGoToBracket(ByRef ByteArray() As Byte, ByRef i As Integer, ByVal UboundByteArray As Integer, ByVal n As Integer, ByVal ascBrackets As Integer)
  Do
    If ByteArray(i) = ascBrackets Then n = n - 1
    Debug.Print Chr(ByteArray(i))
    i = i + 1
  Loop Until n = 0 Or i > UboundByteArray
End Sub

' construccion - destruccion
Private Sub Class_Initialize()
  c_LenBOP = Len(c_BOP)
  c_LenEOP = Len(c_EOP)
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

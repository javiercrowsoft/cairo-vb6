VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cUtil"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Public Function ValidateNroCuit(ByVal Cuit As String, _
                                ByRef msg As Variant) As Boolean

  Dim iSum    As Long
  Dim iRest   As Long
  Dim iDigit  As Long
  
  If Trim(Cuit) = "" Then Exit Function

  If Len(Trim(Cuit)) < 11 Then
    msg = "Debe completar el número de CUIT"
    Exit Function
  Else
    Cuit = Replace(Cuit, "-", "")
    iSum = Val(Mid(Cuit, 1, 1)) * 5
    iSum = iSum + Val(Mid(Cuit, 2, 1)) * 4
    iSum = iSum + Val(Mid(Cuit, 3, 1)) * 3
    iSum = iSum + Val(Mid(Cuit, 4, 1)) * 2
    iSum = iSum + Val(Mid(Cuit, 5, 1)) * 7
    iSum = iSum + Val(Mid(Cuit, 6, 1)) * 6
    iSum = iSum + Val(Mid(Cuit, 7, 1)) * 5
    iSum = iSum + Val(Mid(Cuit, 8, 1)) * 4
    iSum = iSum + Val(Mid(Cuit, 9, 1)) * 3
    iSum = iSum + Val(Mid(Cuit, 10, 1)) * 2
    iRest = iSum Mod 11
    
    iDigit = 11 - iRest
    iDigit = IIf(iDigit = 11, 0, iDigit)
    iDigit = IIf(iDigit = 10, 1, iDigit)

    If iDigit <> Val(Mid(Cuit, 11, 1)) Then
      msg = "El número de CUIT no es valido"
      Exit Function
    End If
  End If
  
  ValidateNroCuit = True

End Function

Public Function ValidateCBU(ByVal tipoCuenta As Long, _
                            ByVal nroCuenta As String, _
                            ByVal tipoMoneda As Long, _
                            ByVal nroCBU As String, _
                            ByVal bcoCodigo As String, _
                            ByRef msg As Variant) As Boolean

  If Not pIsParamsValid(nroCuenta, tipoMoneda, msg) Then Exit Function
  
  nroCBU = Trim(nroCBU)
  
  If Len(nroCBU) <> 22 Then
    msg = "El número de CBU debe tener 22 digitos"
    Exit Function
  End If
    
  'Valido los 3 Primeros del Nro
  If Left(nroCBU, 3) <> bcoCodigo Then
    msg = "Los 3 primeros digitos deben ser igual al código del banco."
    Exit Function
  End If
    
  ValidateCBU = pValidarCBU(Trim(nroCBU), tipoCuenta, nroCuenta, tipoMoneda, msg)
End Function

Private Function pValidarCBU(ByVal cadena As String, _
                             ByVal tipoCuenta As Long, _
                             ByVal nroCuenta As String, _
                             ByVal tipoMoneda As Long, _
                             ByRef msg As Variant) As Boolean
                             
  Dim strBanco        As String
  Dim strSucRadicBCRA As String
  Dim strDigVerif1    As String
  Dim strTipoCta      As String
  Dim strMoneda       As String
  Dim strCuenta       As String
  Dim strDigVerif2    As String
  
  If Len(cadena) <> 22 Then
    msg = "Error longuitud errónea para un CBU"
    Exit Function
  End If
  
  strBanco = Mid(cadena, 1, 3)
  strSucRadicBCRA = Mid(cadena, 4, 4)
  strDigVerif1 = Mid(cadena, 8, 1)
  strTipoCta = Mid(cadena, 9, 1)
  strMoneda = Mid(cadena, 10, 1)
  strCuenta = Mid(cadena, 11, 11)
  strDigVerif2 = Mid(cadena, 22, 1)
  
  If strDigVerif1 <> pDigVerif(Mid(cadena, 1, 7)) Then
    msg = "Error Digito Verificador 1"
    Exit Function
  End If
  
  If strDigVerif2 <> pDigVerif(Mid(cadena, 9, 13)) Then
    msg = "Error Digito Verificador 2"
    Exit Function
  End If
  
  If (Not pEsBancoValido(strBanco)) Then
    msg = "Error Codigo de Banco Erroneo"
    Exit Function
  End If
  
  '--- chequeo de sucursal
  If Not EsSucursalValida(strSucRadicBCRA) Then
    msg = "Error Codigo de Sucursal"
    Exit Function
  End If
  
  '-- Chequeo el valor de tipo de cuenta
  If Not EsTipoDeCuentaValido(strTipoCta) Then
    msg = "Error Tipo de Cuenta Inválido"
    Exit Function
  End If
  
  '-- Chequeo el valor de la moneda
  If Not EsTipoDeMonedaValida(strMoneda) Then
    msg = "Error Tipo de Moneda Invalido"
    Exit Function
  End If
  
  If Val(strMoneda) <> tipoMoneda Then
    msg = "El tipo de moneda del CBU no coincide con la moneda indicada"
    Exit Function
  End If
  
  If strCuenta <> nroCuenta Then
    msg = "La cuenta del CBU no coincide con la cuenta indicada"
    Exit Function
  End If
  
  If Val(strTipoCta) <> tipoCuenta Then
    msg = "El tipo de cuenta del CBU no coincide con el tipo de cuenta indicada"
    Exit Function
  End If
  
  pValidarCBU = True
End Function

Private Function pDigVerif(ByVal cadena As String) As Integer
  Dim Ponderador  As String
  Dim Resultado   As Integer
  Dim Sumatoria   As Integer
  Dim Digito      As Integer
  Dim w_bloque    As String
  Dim i           As Integer
  
  Ponderador = "3971397139713"
  Resultado = 0
  Sumatoria = 0
  Digito = 0
  
  w_bloque = Right(String(13, "0") & cadena, 13)
  ' Calculo la sumatoria en base al valor que entra al ponderador
  For i = 1 To 13
    Resultado = Val(Mid(Ponderador, i, 1)) * Val(Mid(w_bloque, i, 1))
    Sumatoria = Sumatoria + Resultado
  Next i
  
  ' Calculo el digito verificador
  Digito = 10 - Val(Mid(Format(Sumatoria, "0000"), 4, 1))
  pDigVerif = Mid(Format(Digito, "00"), 2, 1)
End Function

Private Function pEsBancoValido(ByVal cadena As String) As Boolean
  If Val(cadena) = 0 Then
    pEsBancoValido = False 'Error Codigo de Banco Erroneo
  Else
    pEsBancoValido = True
  End If
End Function

Private Function EsSucursalValida(cadena As String) As Boolean
  If Not IsNumeric(cadena) And Val(cadena) >= 0 Then
    EsSucursalValida = False
  Else
    EsSucursalValida = True
  End If
End Function

Private Function EsTipoDeCuentaValido(cadena As String) As Boolean
  If IsEmpty(cadena) Or (cadena < "0" Or cadena > "9") Then
    EsTipoDeCuentaValido = False 'Error Codigo de Banco Erroneo
  Else
    EsTipoDeCuentaValido = True
  End If
End Function

Private Function EsTipoDeMonedaValida(cadena As String) As Boolean
  If cadena < "0" Or cadena > "9" Then
    EsTipoDeMonedaValida = False
  Else
    EsTipoDeMonedaValida = True
  End If
End Function

Private Function pIsParamsValid(ByVal nroCuenta As String, _
                                ByVal tipoMoneda As Long, _
                                ByRef msg As Variant) As Boolean

  If nroCuenta = "" Then
    msg = "No se ha Ingresado un número de cuenta"
    Exit Function
  End If
  
  pIsParamsValid = True

End Function



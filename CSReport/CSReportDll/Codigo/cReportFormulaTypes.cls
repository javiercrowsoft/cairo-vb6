VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cReportFormulaTypes"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cReportFormulaTypeTypes
' 12-11-01

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
' constantes
' estructuras
' funciones

'--------------------------------------------------------------------------------

' Clase base
' constantes
' estructuras
' variables privadas
Private m_Coll As Collection

' propiedades publicas
' propiedades friend
' propiedades privadas
' funciones publicas
Public Function Count() As Long
  On Error GoTo ControlError
  Count = m_Coll.Count()
  Exit Function
ControlError:
  Count = 0
End Function

Public Function Item(ByVal kItem As Variant) As cReportFormulaType
Attribute Item.VB_UserMemId = 0
  On Error GoTo ControlError
  Set Item = m_Coll.Item(kItem)
  Exit Function
ControlError:
End Function

' funciones friend
Friend Function Add(Optional ByVal c As cReportFormulaType = Nothing, Optional ByRef Key As Variant) As cReportFormulaType
  On Error GoTo ControlError

  If c Is Nothing Then Set c = New cReportFormulaType

  If IsMissing(Key) Then
     Key = GetNextKey()
  Else
    RefreshNextKey (Key)
  End If

  Key = GetKey(Key)

  m_Coll.Add c, Key

  Set Add = c
  Exit Function
ControlError:
  Set Add = Nothing
End Function

Friend Sub Clear()
  CollClear m_Coll
End Sub

Friend Sub Remove(ByVal kItem As Variant)
  On Error GoTo ControlError
  m_Coll.Remove kItem
  Exit Sub
ControlError:
End Sub

' funciones privadas
Private Sub Class_Initialize()
  Set m_Coll = New Collection
  
  Const C_DescripLenguage As String = "nLenguaje: 1 Español, 2 Ingles y 3 Frances"
  Const C_DescripNombreControl As String = "NombreControl: string con el nombre del control que representa al campo"

  ' Cargo la coleccion con todas las formulas predefinidas
  
'----------------
' A

  With Add(, csRptFormulaType.csRptSetVar)
    .Name = "_setvar"
    .NameUser = "Asignar a una variable"
    .Decrip = "Asignar el valor de una variable " & vbCrLf & "Sintaxis: _SetVar(NombreVariable,Valor)"
    .Id = csRptFormulaType.csRptSetVar
    .HelpContextId = csRptFormulaType.csRptSetVar
  End With
  
'----------------
' C
  
  With Add(, mAux.csRptFormulaType.csRptFCalculo)
    .Name = "_calculo"
    .NameUser = "Cálculo"
    .Decrip = "Devuelve un doble con el resultado de calcular las operaciones que recibe en sus argumentos" & vbCrLf & "Sintaxis: _Calculo(Control1,Control2,Valor,Operador)" & vbCrLf & "1 Suma, 2 Resta, 3 Multiplicar, 4 Dividir, 5 Exponente"
    .Id = mAux.csRptFormulaType.csRptFCalculo
    .HelpContextId = mAux.csRptFormulaType.csRptFCalculo
  End With
  With Add(, mAux.csRptFormulaType.csRptFTotalPages)
    .Name = "_totalpages"
    .NameUser = "Cantidad de páginas"
    .Decrip = "Devuelve un entero con la cantidad de paginas" & vbCrLf & "Sintaxis: _TotalPages()"
    .Id = mAux.csRptFormulaType.csRptFTotalPages
    .HelpContextId = mAux.csRptFormulaType.csRptFTotalPages
  End With
  With Add(, mAux.csRptFormulaType.csRptCount)
    .Name = "_count"
    .NameUser = "Cantidad de registros"
    .Decrip = "Devuelve un doble con la cantidad de registos" & vbCrLf & "Sintaxis: _Count()"
    .Id = mAux.csRptFormulaType.csRptCount
    .HelpContextId = mAux.csRptFormulaType.csRptCount
  End With
  
'----------------
' D

  With Add(, csRptFormulaType.csRptDeclareVar)
    .Name = "_declarevar"
    .NameUser = "Declarar una variable"
    .Decrip = "Declara una variable " & vbCrLf & "Sintaxis: _DeclareVar(NombreVariable)"
    .Id = csRptFormulaType.csRptDeclareVar
    .HelpContextId = csRptFormulaType.csRptDeclareVar
  End With
  
'----------------
' E
  
  With Add(, mAux.csRptFormulaType.csRptIsEqual)
    .Name = "_isequal"
    .NameUser = "Es Igual a"
    .Decrip = "Devuelve verdadero o falso al comparar el valor de un control contra un valor constante " & vbCrLf & "Sintaxis: _IsEqual(NombreControl,valor)" & vbCrLf & C_DescripNombreControl & vbCrLf & "Valor: normalmente un número, aunque tambien acepta textos."
    .Id = mAux.csRptFormulaType.csRptIsEqual
    .HelpContextId = mAux.csRptFormulaType.csRptIsEqual
  End With
  
  With Add(, mAux.csRptFormulaType.csRptIsNotEqual)
    .Name = "_isnotequal"
    .NameUser = "No Es Igual a"
    .Decrip = "Devuelve verdadero o falso al comparar el valor de un control contra un valor constante " & vbCrLf & "Sintaxis: _IsEqual(NombreControl,valor)" & vbCrLf & C_DescripNombreControl & vbCrLf & "Valor: normalmente un número, aunque tambien acepta textos."
    .Id = mAux.csRptFormulaType.csRptIsNotEqual
    .HelpContextId = mAux.csRptFormulaType.csRptIsNotEqual
  End With
  
  With Add(, mAux.csRptFormulaType.csRptIsGreaterThan)
    .Name = "_isgreaterthan"
    .NameUser = "Es Mayor a"
    .Decrip = "Devuelve verdadero o falso al comparar el valor de un control contra un valor constante " & vbCrLf & "Sintaxis: _IsEqual(NombreControl,valor)" & vbCrLf & C_DescripNombreControl & vbCrLf & "Valor: normalmente un número, aunque tambien acepta textos."
    .Id = mAux.csRptFormulaType.csRptIsGreaterThan
    .HelpContextId = mAux.csRptFormulaType.csRptIsGreaterThan
  End With
  
  With Add(, mAux.csRptFormulaType.csRptIsLessThan)
    .Name = "_iselessthan"
    .NameUser = "Es Menor a"
    .Decrip = "Devuelve verdadero o falso al comparar el valor de un control contra un valor constante " & vbCrLf & "Sintaxis: _IsEqual(NombreControl,valor)" & vbCrLf & C_DescripNombreControl & vbCrLf & "Valor: normalmente un número, aunque tambien acepta textos."
    .Id = mAux.csRptFormulaType.csRptIsLessThan
    .HelpContextId = mAux.csRptFormulaType.csRptIsLessThan
  End With
  
  With Add(, mAux.csRptFormulaType.csRptIsInRs)
    .Name = "_isinrs"
    .NameUser = "Esta en Data Source Principal"
    .Decrip = "Devuelve verdadero o falso buscar en el data source principal un valor constante para la columna indicada " & vbCrLf & "Sintaxis: _IsInRs(NombreColumna,""Valor"")" & vbCrLf & "NombreColumna: Una columna en el data source principal" & vbCrLf & "Valor: un texto a buscar (se deben indicar el texto entre comillas dobles)."
    .Id = mAux.csRptFormulaType.csRptIsInRs
    .HelpContextId = mAux.csRptFormulaType.csRptIsInRs
  End With
  
'----------------
' G
  
  With Add(, mAux.csRptFormulaType.csRptGroupTotal)
    .Name = "_grouptotal"
    .NameUser = "Grupo) Total en un Grupo"
    .Decrip = "Esta función obtiene el valor antes de procesar las filas." & vbCrLf & _
              "Cuando CSReport encuentra esta función recorre el recordset " & _
              "hasta la ultima fila que pertenece al grupo y obtiene " & _
              "la suma de la columna." & vbCrLf & vbCrLf & _
              "Devuelve el total de una columna en un grupo, " & _
              "si se indica el grupo 0 devuelve el total de " & _
              "la columna en el reporte" & vbCrLf & _
              "Sintaxis: _GroupTotal(NombreColumna, IndiceGrupo)" & vbCrLf & _
              "NombreColumna: Nombre de la columna a sumar en el recordset principal" & vbCrLf & _
              "IndiceGrupo: indice del grupo" & vbCrLf & _
              "  Si IndiceGrupo es -1 la formula " & _
              "  toma el indice del grupo de la seccion en la que " & _
              "  esta el control. " & vbCrLf & _
              "  Si IndiceGrupo es 0 la formula devuelve el total de " & _
              "  la columna en el reporte" & vbCrLf & _
              "  Si IndiceGrupo es > 0 la formula devuelve el total de " & _
              "  la columna en el grupo indicado"
              
    .Id = mAux.csRptFormulaType.csRptGroupTotal
    .HelpContextId = mAux.csRptFormulaType.csRptGroupTotal
  End With
  
  With Add(, mAux.csRptFormulaType.csRptGroupMax)
    .Name = "_groupmax"
    .NameUser = "Grupo) Maximo en un Grupo"
    .Decrip = "Esta función obtiene el valor antes de procesar las filas." & vbCrLf & _
              "Cuando CSReport encuentra esta función recorre el recordset " & _
              "hasta la ultima fila que pertenece al grupo y obtiene " & _
              "el maximo valor de la columna." & vbCrLf & vbCrLf & _
              "Devuelve el maximo de una columna en un grupo, " & _
              "si se indica el grupo 0 devuelve el maximo de " & _
              "la columna en el reporte" & vbCrLf & _
              "Sintaxis: _GroupMax(NombreColumna, IndiceGrupo)" & vbCrLf & _
              "NombreColumna: Nombre de la columna en el recordset principal" & vbCrLf & _
              "IndiceGrupo: indice del grupo" & vbCrLf & _
              "  Si IndiceGrupo es -1 la formula " & _
              "  toma el indice del grupo de la seccion en la que " & _
              "  esta el control. " & vbCrLf & _
              "  Si IndiceGrupo es 0 la formula devuelve el maximo de " & _
              "  la columna en el reporte" & vbCrLf & _
              "  Si IndiceGrupo es > 0 la formula devuelve el maximo de " & _
              "  la columna en el grupo indicado"
    
    .Id = mAux.csRptFormulaType.csRptGroupMax
    .HelpContextId = mAux.csRptFormulaType.csRptGroupMax
  End With
  
  With Add(, mAux.csRptFormulaType.csRptGroupMin)
    .Name = "_groupmin"
    .NameUser = "Grupo) Minimo en un Grupo"
    .Decrip = "Esta función obtiene el valor antes de procesar las filas." & vbCrLf & _
              "Cuando CSReport encuentra esta función recorre el recordset " & _
              "hasta la ultima fila que pertenece al grupo y obtiene " & _
              "el valor minimo de la columna." & vbCrLf & vbCrLf & _
              "Devuelve el minimo de una columna en un grupo, " & _
              "si se indica el grupo 0 devuelve el minimo de " & _
              "la columna en el reporte" & vbCrLf & _
              "Sintaxis: _GroupMin(NombreColumna, IndiceGrupo)" & vbCrLf & _
              "NombreColumna: Nombre de la columna en el recordset principal" & vbCrLf & _
              "IndiceGrupo: indice del grupo" & vbCrLf & _
              "  Si IndiceGrupo es -1 la formula " & _
              "  toma el indice del grupo de la seccion en la que " & _
              "  esta el control. " & vbCrLf & _
              "  Si IndiceGrupo es 0 la formula devuelve el minimo de " & _
              "  la columna en el reporte" & vbCrLf & _
              "  Si IndiceGrupo es > 0 la formula devuelve el minimo de " & _
              "  la columna en el grupo indicado"
    
    .Id = mAux.csRptFormulaType.csRptGroupMin
    .HelpContextId = mAux.csRptFormulaType.csRptGroupMin
  End With
  
  With Add(, mAux.csRptFormulaType.csRptGroupAverage)
    .Name = "_groupaverage"
    .NameUser = "Grupo) Promedio en un Grupo"
    .Decrip = "Esta función obtiene el valor antes de procesar las filas." & vbCrLf & _
              "Cuando CSReport encuentra esta función recorre el recordset " & _
              "hasta la ultima fila que pertenece al grupo y obtiene " & _
              "el promedio de la columna." & vbCrLf & vbCrLf & _
              "Devuelve el promedio de una columna en un grupo, " & _
              "si se indica el grupo 0 devuelve el promedio de " & _
              "la columna en el reporte" & vbCrLf & _
              "Sintaxis: _GroupAverage(NombreColumna, IndiceGrupo)" & vbCrLf & _
              "NombreColumna: Nombre de la columna en el recordset principal" & vbCrLf & _
              "IndiceGrupo: indice del grupo" & vbCrLf & _
              "  Si IndiceGrupo es -1 la formula " & _
              "  toma el indice del grupo de la seccion en la que " & _
              "  esta el control. " & vbCrLf & _
              "  Si IndiceGrupo es 0 la formula devuelve el promedio de " & _
              "  la columna en el reporte" & vbCrLf & _
              "  Si IndiceGrupo es > 0 la formula devuelve el promedio de " & _
              "  la columna en el grupo indicado"
    
    .Id = mAux.csRptFormulaType.csRptGroupAverage
    .HelpContextId = mAux.csRptFormulaType.csRptGroupAverage
  End With
  
  With Add(, mAux.csRptFormulaType.csRptGroupPercent)
    .Name = "_grouppercent"
    .NameUser = "Grupo) Porcentaje en un Grupo"
    .Decrip = "Esta función obtiene el valor antes de procesar las filas." & vbCrLf & _
              "Cuando CSReport encuentra esta función recorre el recordset " & _
              "hasta la ultima fila que pertenece al grupo y obtiene " & _
              "el porcentaje que el valor de la segunda columna " & _
              "representa en el total de la primera columna." & vbCrLf & vbCrLf & _
              "Devuelve el porcentaje de un registro en un grupo, " & _
              "si se indica el grupo 0 devuelve el porcentaje de " & _
              "de un registro en el reporte" & vbCrLf & _
              "Sintaxis: _GroupPercent(NombreColumna1, NombreColumna2, IndiceGrupo)" & vbCrLf & _
              "NombreColumna1: Nombre de la columna en el recordset principal que se debe sumarizar" & vbCrLf & _
              "NombreColumna2: Nombre de la columna en el recordset principal que contiene el valor a evaluar" & vbCrLf & _
              "IndiceGrupo: indice del grupo" & vbCrLf & _
              "  Si IndiceGrupo es -1 la formula " & _
              "  toma el indice del grupo de la seccion en la que " & _
              "  esta el control. " & vbCrLf & _
              "  Si IndiceGrupo es 0 la formula devuelve el promedio de " & _
              "  la columna en el reporte" & vbCrLf & _
              "  Si IndiceGrupo es > 0 la formula devuelve el promedio de " & _
              "  la columna en el grupo indicado" & vbCrLf & _
              "NOTA: NombreColumna1 y NombreColumna2 normalmente tienen el mismo valor"
    
    .Id = mAux.csRptFormulaType.csRptGroupPercent
    .HelpContextId = mAux.csRptFormulaType.csRptGroupPercent
  End With
  
  With Add(, mAux.csRptFormulaType.csRptGroupCount)
    .Name = "_groupcount"
    .NameUser = "Grupo) Cantidad de lineas en un Grupo"
    .Decrip = "Esta función obtiene el valor antes de procesar las filas." & vbCrLf & _
              "Cuando CSReport encuentra esta función recorre el recordset " & _
              "hasta la ultima fila que pertenece al grupo y obtiene " & _
              "la cantidad de registros en el grupo." & vbCrLf & vbCrLf & _
              "Devuelve la cantidad de registros en un grupo, " & _
              "si se indica el grupo 0 devuelve la cantidad de " & _
              "registros en el reporte" & vbCrLf & _
              "Sintaxis: _GroupCount(NombreColumna, ContarVacios, IndiceGrupo)" & vbCrLf & _
              "NombreColumna: Nombre de la columna en el recordset principal" & vbCrLf & _
              "ContarVacios: Si es = 0 no cuenta nulls, ni string nulls ni 1-1-1900 ni 0" & vbCrLf & _
              "IndiceGrupo: indice del grupo" & vbCrLf & _
              "  Si IndiceGrupo es -1 la formula " & _
              "  toma el indice del grupo de la seccion en la que " & _
              "  esta el control. " & vbCrLf & _
              "  Si IndiceGrupo es 0 la formula devuelve la cantidad de " & _
              "  registros en el reporte" & vbCrLf & _
              "  Si IndiceGrupo es > 0 la formula devuelve la cantidad de " & _
              "  registros en el grupo indicado"
    
    .Id = mAux.csRptFormulaType.csRptGroupCount
    .HelpContextId = mAux.csRptFormulaType.csRptGroupCount
  End With
  
  With Add(, mAux.csRptFormulaType.csRptGroupLineNumber)
    .Name = "_grouplinenumber"
    .NameUser = "Grupo) Numero de renglon en un Grupo"
    .Decrip = "Devuelve el número de rénglon en un grupo, " & _
              "si se indica el grupo 0 devuelve el número de " & _
              "rénglon en el reporte" & vbCrLf & _
              "Sintaxis: _GroupLineNumber(IndiceGrupo)" & vbCrLf & _
              "IndiceGrupo: indice del grupo" & vbCrLf & _
              "  Si IndiceGrupo es -1 la formula " & _
              "  toma el indice del grupo de la seccion en la que " & _
              "  esta el control. " & vbCrLf & _
              "  Si IndiceGrupo es 0 la formula devuelve el número de " & _
              "  rénglon en el reporte" & vbCrLf & _
              "  Si IndiceGrupo es > 0 la formula devuelve el número de " & _
              "  rénglon en el grupo indicado"
    
    .Id = mAux.csRptFormulaType.csRptGroupLineNumber
    .HelpContextId = mAux.csRptFormulaType.csRptGroupLineNumber
  End With
    
'----------------
' M
  
  With Add(, mAux.csRptFormulaType.csRptMax)
    .Name = "_max"
    .NameUser = "Máximo de una columna"
    .Decrip = "Devuelve un doble con el maximo de una columna" & vbCrLf & "Sintaxis: _Max(NombreControl)" & vbCrLf & C_DescripNombreControl
    .Id = mAux.csRptFormulaType.csRptMax
    .HelpContextId = mAux.csRptFormulaType.csRptMax
  End With
  With Add(, mAux.csRptFormulaType.csRptMin)
    .Name = "_min"
    .NameUser = "Mínimo de una columna"
    .Decrip = "Devuelve un doble con el minimo de una columna" & vbCrLf & "Sintaxis: _Min(NombreControl)" & vbCrLf & C_DescripNombreControl
    .Id = mAux.csRptFormulaType.csRptMin
    .HelpContextId = mAux.csRptFormulaType.csRptMin
  End With
  
'----------------
' N
  
  With Add(, mAux.csRptFormulaType.csRptFNumberToString)
    .Name = "_numbertostring"
    .NameUser = "Número a texto"
    .Decrip = "Devuelve un texto con el numero " & vbCrLf & "Sintaxis: _NumberToString(NombreControl,nLenguaje)" & vbCrLf & C_DescripNombreControl & vbCrLf & C_DescripLenguage
    .Id = mAux.csRptFormulaType.csRptFNumberToString
    .HelpContextId = mAux.csRptFormulaType.csRptFNumberToString
  End With
  
  With Add(, mAux.csRptFormulaType.csRptFPageNumber)
    .Name = "_currentpage"
    .NameUser = "Número de página"
    .Decrip = "Devuelve un entero con el número de la página" & vbCrLf & "Sintaxis: _CurrentPage()"
    .Id = mAux.csRptFormulaType.csRptFPageNumber
    .HelpContextId = mAux.csRptFormulaType.csRptFPageNumber
  End With
  
'----------------
' O
  
  With Add(, csRptFormulaType.csRptGetParam)
    .Name = "_getparam"
    .NameUser = "Obtener un parametro"
    .Decrip = "Devuelve el valor de un parametro de la canexión principal " & vbCrLf & "Sintaxis: _GetVar(NombreVariable)"
    .Id = csRptFormulaType.csRptGetParam
    .HelpContextId = csRptFormulaType.csRptGetParam
  End With
  With Add(, csRptFormulaType.csRptGetDataFromRsAd)
    .Name = "_getdatafromrsad"
    .NameUser = "Obtener un dato (Adicional)"
    .Decrip = "Obtiene un dato desde un recordset adicional " & vbCrLf & "Sintaxis (DS es Data Source): GetDataFromRsAd (NombreDS,IndiceDS,colValDSAdic,colFilterDSPrincipal=colFilterDSAdic)"
    .Id = csRptFormulaType.csRptGetDataFromRsAd
    .HelpContextId = csRptFormulaType.csRptGetDataFromRsAd
  End With
  With Add(, csRptFormulaType.csRptGetDataFromRs)
    .Name = "_getdatafromrs"
    .NameUser = "Obtener un dato (Principal)"
    .Decrip = "Obtiene un dato desde el recordset principal " & vbCrLf & "Sintaxis: GetDataFromRs (IndiceDS,colValDSAdic,colFilterDSPrincipal=colFilterDSAdic)"
    .Id = csRptFormulaType.csRptGetDataFromRs
    .HelpContextId = csRptFormulaType.csRptGetDataFromRs
  End With
  
  With Add(, mAux.csRptFormulaType.csRptFGetString)
    .Name = "_getstring"
    .NameUser = "Obtener un string"
    .Decrip = "Devuelve el valor del control que recibe con una comilla al principio y otra al final" & vbCrLf & "Sintaxis: _GetString(NombreControl)" & vbCrLf & C_DescripNombreControl
    .Id = mAux.csRptFormulaType.csRptFGetString
    .HelpContextId = mAux.csRptFormulaType.csRptFGetString
  End With
  
  With Add(, csRptFormulaType.csRptGetVar)
    .Name = "_getvar"
    .NameUser = "Obtener una variable"
    .Decrip = "Devuelve el valor de una variable " & vbCrLf & "Sintaxis: _GetVar(NombreVariable)"
    .Id = csRptFormulaType.csRptGetVar
    .HelpContextId = csRptFormulaType.csRptGetVar
  End With
  
'----------------
' P
  
  With Add(, mAux.csRptFormulaType.csRptFAverage)
    .Name = "_average"
    .NameUser = "Promedio de una columna"
    .Decrip = "Devuelve un doble con el promedio de una columna" & vbCrLf & "Sintaxis: _Average(NombreControl)" & vbCrLf & C_DescripNombreControl
    .Id = mAux.csRptFormulaType.csRptFAverage
    .HelpContextId = mAux.csRptFormulaType.csRptFAverage
  End With
  
'----------------
' S
  
  With Add(, csRptFormulaType.csRptAddToVar)
    .Name = "_addtovar"
    .NameUser = "Sumar a una variable"
    .Decrip = "Suma el valor indicado a una variable " & vbCrLf & "Sintaxis: _AddToVar(NombreVariable,Valor)"
    .Id = csRptFormulaType.csRptAddToVar
    .HelpContextId = csRptFormulaType.csRptAddToVar
  End With
  
  With Add(, mAux.csRptFormulaType.csRptFSum)
    .Name = "_sum"
    .NameUser = "Sumatoria de una columna"
    .Decrip = "Devuelve un doble con la sumatoria de una columna" & vbCrLf & "Sintaxis: _Sum(NombreControl)" & vbCrLf & C_DescripNombreControl
    .Id = mAux.csRptFormulaType.csRptFSum
    .HelpContextId = mAux.csRptFormulaType.csRptFSum
  End With
  
  With Add(, mAux.csRptFormulaType.csRptFSumTime)
    .Name = "_sumtime"
    .NameUser = "Sumatoria de tiempos de una columna"
    .Decrip = "Devuelve las horas, minutos y segundos resultantes de la sumatoria de una columna de tipo tiempo" & vbCrLf & "Sintaxis: _SumTime(NombreControl,MostrarSegundos)" & vbCrLf & C_DescripNombreControl
    .Id = mAux.csRptFormulaType.csRptFSumTime
    .HelpContextId = mAux.csRptFormulaType.csRptFSumTime
  End With
  
'----------------
' T
  
  With Add(, mAux.csRptFormulaType.csRptLength)
    .Name = "_length"
    .NameUser = "Tamaño de un dato"
    .Decrip = "Devuelve un entero con el tamaño de un dato en un registro" & vbCrLf & "Sintaxis: _Length(NombreControl)" & vbCrLf & C_DescripNombreControl
    .Id = mAux.csRptFormulaType.csRptLength
    .HelpContextId = mAux.csRptFormulaType.csRptLength
  End With
  
  With Add(, mAux.csRptFormulaType.csRptTextReplace)
    .Name = "_textreplace"
    .NameUser = "Reemplazar textos"
    .Decrip = "Reemplaza en el texto del control todas las ocurrencias de nombres de controles con sus respectivos valores." & vbCrLf & "Sintaxis: _Length(NombreControl)" & vbCrLf & C_DescripNombreControl
    .Id = mAux.csRptFormulaType.csRptTextReplace
    .HelpContextId = mAux.csRptFormulaType.csRptTextReplace
  End With
  
'----------------
' V
  
  With Add(, mAux.csRptFormulaType.csRptFVal)
    .Name = "_value"
    .NameUser = "Valor"
    .Decrip = "Devuelve un string con el contenido de un campo" & vbCrLf & "Sintaxis: _Value(NombreControl)" & vbCrLf & C_DescripNombreControl
    .Id = mAux.csRptFormulaType.csRptFVal
    .HelpContextId = mAux.csRptFormulaType.csRptFVal
  End With
  
End Sub

Public Function NewEnum() As IUnknown
Attribute NewEnum.VB_UserMemId = -4
  Set NewEnum = m_Coll.[_NewEnum]
End Function

' construccion - destruccion
Private Sub Class_Terminate()
  CollClear m_Coll
   Set m_Coll = Nothing
End Sub



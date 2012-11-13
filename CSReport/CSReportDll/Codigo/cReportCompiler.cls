VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cReportCompiler"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
'--------------------------------------------------------------------------------
' cReportCompiler
' 13-11-2001

' Las funciones ya sean por codigo vb o internas tiene comas para
' separar los parametros, pero la configuracion española utiliza
' la coma como separador decimal.
'
' Por este motivo tengo que reemplazar las comas por pipes
' una vez que termino de compilar todos los parametros y funciones
' internas, vuelvo a reemplazar los pipes por comas y se lo paso al
' vbscript engine.

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
' constantes
' estructuras
' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module            As String = "cReportCompiler"

Private Const c_TempFunctionB     As String = "Option explicit" & vbCrLf & "function TmpFun447744" & vbCrLf & " TmpFun447744 = "
Private Const c_TempFunctionE     As String = vbCrLf & "end function" & vbCrLf

Private Const c_MACRO_CTRL        As String = "@@"

Private Const c_AverageSum        As String = "AverageSum"
Private Const c_AverageCant       As String = "AverageCant"
Private Const c_Sum               As String = "Sum"
Private Const c_SumTime           As String = "SumTime"
Private Const c_Max               As String = "Max"
Private Const c_Min               As String = "Min"
Private Const c_Count             As String = "Count"
Private Const c_NumberToString    As String = "NumberToString"
Private Const c_GetDataFromRsAd   As String = "GetDataFromRsAd"

Private Const c_IsEqual           As String = "IsEqual"
Private Const c_IsNotEqual        As String = "IsNotEqual"
Private Const c_IsGreaterThan     As String = "IsGreaterThan"
Private Const c_IsLessThan        As String = "IsLessThan"

Private Const c_GetDataFromRs     As String = "GetDataFromRs"

Private Const c_GroupTotal        As String = "GroupTotal"
Private Const c_GroupMin          As String = "GroupMin"
Private Const c_GroupMax          As String = "GroupMax"
Private Const c_GroupAverage      As String = "GroupAverage"
Private Const c_GroupPercent      As String = "GroupPercent"
Private Const c_GroupPercentT     As String = "GroupPercentT"
Private Const c_GroupCount        As String = "GroupCount"
Private Const c_GroupLineNumber   As String = "GroupLineNumber"

Private Const c_IsInRs            As String = "IsInRs"

Private Const c_Spanish = 1
Private Const c_English = 2
Private Const c_French = 3

Private Const c_KeyFuncInt        As String = "$$$"
' estructuras
' variables privadas
Private m_FormulaTypes As cReportFormulaTypes
Private m_Report As cReport
Private m_Variables As cReportVariables

Private m_Formula As cReportFormula ' Formula que se esta compilando
Private m_Fint As cReportFormulaInt ' Formula Interna que se esta compilando
Private m_ObjScript As MSScriptControl.ScriptControl ' Objeto para evaluar scripting

Private m_ObjGlobals As cReportCompilerGlobals

Private m_collTextReplace As Collection
Private m_ctrlName        As String

Private m_bCompile        As Boolean
Private m_IdxFormula      As Long
' eventos
' propiedades publicas
' propiedades friend

Friend Property Get Report() As cReport
  Set Report = m_Report
End Property

Friend Property Set Report(ByRef rhs As cReport)
  Set m_Report = rhs
End Property

' propiedades privadas
' funciones publicas
Public Sub ClearVariables()
  m_Variables.Clear
End Sub

Public Sub InitGlobalObject()
  m_ObjGlobals.Clear
  CollClear m_collTextReplace
End Sub

' Compila el codigo usando Microsoft.ScriptControl
' Primero reemplaza todas las funciones internas
' por valores de respuesta y luego
' si hay codigo por resolver llama al metodo
' execute del ScriptControl, si no se producen errores
' devuelve True
Public Function CheckSintax(ByRef Formula As cReportFormula) As Boolean
  On Error GoTo ControlError
  
  Dim Code As String
  
  Set m_Formula = Formula
  
  ' Vacio la informacion de formulas internas
  m_Formula.FormulasInt.Clear
  
  ' Ahora voy a chekear la sintaxis
  Code = Formula.text
  m_Formula.TextC = Code
  
  pCheckSintax Code
  
  CheckSintax = True
  
  GoTo ExitProc
ControlError:
  
  ' Si son errores mios los muestro en un info
  If Err.Number < 0 Or Err.Number = 1024 Then ' 1024 compilation error por ScriptControl
    MsgInfo Err.Description, "Error de sintaxis"
  Else
    MngError Err(), "CheckSintax", C_Module, "Error de sintaxis"
  End If

  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
  Set m_Formula = Nothing
  Set m_Fint = Nothing
End Function

Public Sub InitVariable(ByRef Formula As cReportFormula)
  Dim Var  As cReportVariable
  Dim Fint As cReportFormulaInt
  Dim st   As cStructTime
  
  For Each Fint In Formula.FormulasInt
    For Each Var In Fint.Variables
      Select Case VarType(Var.Value)

        Case VbVarType.vbEmpty, VbVarType.vbNull
          ' Nada que hacer
        Case VbVarType.vbLong, VbVarType.vbByte, VbVarType.vbDecimal, VbVarType.vbInteger, VbVarType.vbSingle, VbVarType.vbDouble, VbVarType.vbDecimal, VbVarType.vbDate, VbVarType.vbBoolean '3 Long integer
          Var.Value = 0
        Case VbVarType.vbString
          Var.Value = vbNullString
        Case VbVarType.vbObject
          If TypeOf Var.Value Is cStructTime Then
            Set st = Var.Value
            st.Hour = 0
            st.Minute = 0
            st.Second = 0
          End If
        Case VbVarType.vbError, VbVarType.vbObject, VbVarType.vbDataObject
          ' Nada que hacer
        Case VbVarType.vbUserDefinedType
          ' Nada que hacer
        Case VbVarType.vbArray
          ' Nada que hacer
      End Select
    Next Var
  Next Fint

End Sub

Private Sub pEvalGroupsFunction(ByRef Formula As cReportFormula)
  Dim Fint As cReportFormulaInt
  
  For Each Fint In Formula.FormulasInt
  
    Select Case Fint.FormulaType
    
      Case mAux.csRptFormulaType.csRptGroupTotal
        EvalGroupTotal Fint
        
      Case mAux.csRptFormulaType.csRptGroupMax
        EvalGroupMax Fint
        
      Case mAux.csRptFormulaType.csRptGroupMin
        EvalGroupMin Fint
        
      Case mAux.csRptFormulaType.csRptGroupAverage
        EvalGroupAverage Fint
        
      Case mAux.csRptFormulaType.csRptGroupPercent
        EvalGroupPercent Fint
              
      Case mAux.csRptFormulaType.csRptGroupCount
        EvalGroupCount Fint
              
      Case mAux.csRptFormulaType.csRptGroupLineNumber
        EvalGroupLineNumber Fint
    
    End Select
  Next Fint
  
End Sub

Public Function ResultFunction(ByRef Formula As cReportFormula) As Variant
  Dim Code As String
  Dim vResult() As Variant
  
  m_ObjGlobals.Mode = 1 ' Result
  m_ctrlName = Formula.ControlName
  
  ReDim vResult(Formula.FormulasInt.Count)
  
  Dim Fint As cReportFormulaInt
  Dim i As Integer
  
  For Each Fint In Formula.FormulasInt
    i = i + 1
    vResult(i) = pResultFunctionInt(Fint)
  Next Fint
  
  ' Determino si hay Scripting o solo hay funciones internas
  Code = Replace(Formula.TextC, c_KeyFuncInt, vbNullString)
  Code = Replace(Code, " ", vbNullString)
  
  ' Si despues de sacar la clave para funciones internas
  ' y los espacios, me quede con un numero entonces no
  ' hay Scripting y solo hay una funcion interna
  If IsNumeric(Code) Then
    If UBound(vResult) > 0 Then

      Formula.LastResult = vResult(1)
      Formula.HaveToEval = False
      ResultFunction = Formula.LastResult
    
    ' Si la funcion es solo una constante (usada por ejemplo para
    ' la navegacion por links en Cairo
    '
    Else
      ResultFunction = Code
    End If
  Else
    
    Code = Formula.TextC
    
    For i = 1 To UBound(vResult)
      
      ' Si un argumento es empty significa que no hay filas para
      ' esta formula, en cuyo caso no compilo el codigo
      If IsEmpty(vResult(i)) Then Exit Function
      
      Code = Replace(Code, c_KeyFuncInt & Format(i, "000"), GetNumericVal(vResult(i)))
    Next
    
    Formula.LastResult = pExecScriptCode(Code)
    Formula.HaveToEval = False
    ResultFunction = Formula.LastResult
  End If
End Function

Private Sub pEvalFunctionGroup(ByRef Fint As cReportFormulaInt)
  Dim Value As Double
  Dim Total As Double

  If Fint.Variables.Count Then
    
    If Fint.Parameters.Item(c_KeyIndexCol2) Is Nothing Then
      Value = 0
    Else
      Value = Val(m_Report.GetValueFromRs(Fint.Parameters.Item(c_KeyIndexCol2).Value))
    End If
    
    Total = Val(Fint.Variables.Item(c_GroupPercentT).Value)
    Value = DivideByCero(Value, Total)
    Fint.Variables.Item(c_GroupPercent).Value = Value
  
  End If

End Sub

Public Sub EvalFunctionGroup(ByRef Formula As cReportFormula)
  Dim Fint  As cReportFormulaInt

  For Each Fint In Formula.FormulasInt

    pEvalFunctionGroup Fint
    
  Next
End Sub

Public Sub EvalFunction(ByRef Formula As cReportFormula)
  Dim CodeC As String
  
  m_ObjGlobals.Mode = 0 ' Eval

  pEvalGroupsFunction Formula
  
  gDebug_Section = Formula.SectionName
  gDebug_SectionLine = Formula.SectionLineIndex
  gDebug_ControlName = Formula.ControlName
  
  Set m_Formula = Formula
  
  pCompile Formula.text, False, CodeC
  
  If Formula.FormulasInt.Count Then
    If IsNumeric(CodeC) Then
      pEvalSintax vbNullString, CodeC, False
    Else
      If LCase$(Left$(Trim$(CodeC), 8)) = "function" Then
        pEvalSintax vbNullString, CodeC, False
      End If
    End If
  Else
    pEvalSintax vbNullString, CodeC, False
  End If
  
  Set m_Formula = Nothing

End Sub

Private Function pCompile(ByVal Code As String, ByVal bCompile As Boolean, ByRef CodeC As String) As Boolean
  m_bCompile = bCompile
  m_IdxFormula = 0
  
  Code = pColonToPipe(Code)
  
  pCompile = pCompileAux(Code, CodeC)
End Function

Private Function pColonToPipe(ByVal Code As String) As String
  pColonToPipe = Replace(Code, ",", "|")
End Function

Private Function pPipeToColon(ByVal Code As String) As String
  pPipeToColon = Replace(Code, "|", ",")
End Function

' funciones friend
' funciones privadas
Private Function pIsFunction(ByVal Word As String) As Boolean
  Dim f As cReportFormulaType

  For Each f In m_FormulaTypes
    If LCase(Word) = LCase(f.Name) Then
      pIsFunction = True
      Exit Function
    End If
  Next f
End Function

Private Function pAddFormulaInt(ByVal FunctionName As String, ByVal Code As String) As Variant
  ' Antes que nada la agrego a la coleccion de formulas internas
  ' de esta formula
  Set m_Fint = m_Formula.FormulasInt.Add()
  pAddFormulaInt = pEvalSintax(FunctionName, Code, True)
End Function

Private Sub pEvalFunctionInt(ByRef Fint As cReportFormulaInt)
  Select Case Fint.FormulaType

    Case mAux.csRptFormulaType.csRptFAverage
      EvalAverage Fint

    Case mAux.csRptFormulaType.csRptFSum
      EvalSum Fint

    Case mAux.csRptFormulaType.csRptFSumTime
      EvalSumTime Fint

    Case mAux.csRptFormulaType.csRptMax
      EvalMax Fint

    Case mAux.csRptFormulaType.csRptMin
      EvalMin Fint

    Case mAux.csRptFormulaType.csRptCount
      EvalCount Fint
    
    Case mAux.csRptFormulaType.csRptFNumberToString
      EvalNumberToString Fint
    
    Case mAux.csRptFormulaType.csRptIsEqual
      EvalIsEqual Fint
    
    Case mAux.csRptFormulaType.csRptIsNotEqual
      EvalIsNotEqual Fint
    
    Case mAux.csRptFormulaType.csRptIsGreaterThan
      EvalIsGreaterThan Fint
    
    Case mAux.csRptFormulaType.csRptIsLessThan
      EvalIsLessThan Fint
    
    Case mAux.csRptFormulaType.csRptFCalculo
      ' no se hace nada
      
    Case mAux.csRptFormulaType.csRptDeclareVar
      EvalDeclareVar Fint
    
    Case mAux.csRptFormulaType.csRptGetVar
      ' no se hace nada
    
    Case mAux.csRptFormulaType.csRptGetParam
      ' no se hace nada
      
    Case mAux.csRptFormulaType.csRptSetVar
      EvalSetVar Fint
      
    Case mAux.csRptFormulaType.csRptAddToVar
      EvalAddToVar Fint
      
    Case mAux.csRptFormulaType.csRptGetDataFromRsAd
      EvalGetDataFromRsAd Fint
      
    Case mAux.csRptFormulaType.csRptGetDataFromRs
      EvalGetDataFromRs Fint
            
    Case mAux.csRptFormulaType.csRptIsInRs
      EvalIsInRs Fint
            
  End Select
End Sub

Private Function pResultFunctionInt(ByRef Fint As cReportFormulaInt) As Variant
  Select Case Fint.FormulaType

    Case mAux.csRptFormulaType.csRptFAverage
      pResultFunctionInt = ResultAverage(Fint)

    Case mAux.csRptFormulaType.csRptFSum
      pResultFunctionInt = ResultSum(Fint)

    Case mAux.csRptFormulaType.csRptFGetString
      pResultFunctionInt = ResultGetString(Fint)

    Case mAux.csRptFormulaType.csRptFSumTime
      pResultFunctionInt = ResultSumTime(Fint)

    Case mAux.csRptFormulaType.csRptMax
      pResultFunctionInt = ResultMax(Fint)

    Case mAux.csRptFormulaType.csRptMin
      pResultFunctionInt = ResultMin(Fint)

    Case mAux.csRptFormulaType.csRptCount
      pResultFunctionInt = ResultCount(Fint)
    
    Case mAux.csRptFormulaType.csRptFNumberToString
      pResultFunctionInt = ResultNumberToString(Fint)

    Case mAux.csRptFormulaType.csRptIsEqual
      pResultFunctionInt = ResultIsEqual(Fint)
      
    Case mAux.csRptFormulaType.csRptIsNotEqual
      pResultFunctionInt = ResultIsNotEqual(Fint)
      
    Case mAux.csRptFormulaType.csRptIsGreaterThan
      pResultFunctionInt = ResultIsGreaterThan(Fint)
      
    Case mAux.csRptFormulaType.csRptIsLessThan
      pResultFunctionInt = ResultIsLessThan(Fint)
      
    Case mAux.csRptFormulaType.csRptFPageNumber
      pResultFunctionInt = ResultPageNumber()

    Case mAux.csRptFormulaType.csRptFTotalPages
      pResultFunctionInt = ResultTotalPages()

    Case mAux.csRptFormulaType.csRptFVal
      pResultFunctionInt = ResultValue(Fint)

    Case mAux.csRptFormulaType.csRptLength
      pResultFunctionInt = ResultLength(Fint)
      
    Case mAux.csRptFormulaType.csRptTextReplace
      pResultFunctionInt = ResultTextReplace(Fint)

    Case mAux.csRptFormulaType.csRptFCalculo
      pResultFunctionInt = ResultCalculo(Fint)
      
    Case mAux.csRptFormulaType.csRptDeclareVar
      ' no se hace nada
    
    Case mAux.csRptFormulaType.csRptGetVar
      pResultFunctionInt = ResultGetVar(Fint)
    
    Case mAux.csRptFormulaType.csRptGetParam
      pResultFunctionInt = ResultGetParam(Fint)
      
    Case mAux.csRptFormulaType.csRptSetVar
      ' no se hace nada
      
    Case mAux.csRptFormulaType.csRptAddToVar
      ' no se hace nada
  
    Case mAux.csRptFormulaType.csRptGetDataFromRsAd
      pResultFunctionInt = ResultGetDataFromRsAd(Fint)
  
    Case mAux.csRptFormulaType.csRptGetDataFromRs
      pResultFunctionInt = ResultGetDataFromRs(Fint)
  
    Case mAux.csRptFormulaType.csRptGroupTotal
      pResultFunctionInt = ResultGroupTotal(Fint)
  
    Case mAux.csRptFormulaType.csRptGroupMax
      pResultFunctionInt = ResultGroupMax(Fint)
  
    Case mAux.csRptFormulaType.csRptGroupMin
      pResultFunctionInt = ResultGroupMin(Fint)
  
    Case mAux.csRptFormulaType.csRptGroupAverage
      pResultFunctionInt = ResultGroupAverage(Fint)
  
    Case mAux.csRptFormulaType.csRptGroupPercent
      pResultFunctionInt = ResultGroupPercent(Fint)
  
    Case mAux.csRptFormulaType.csRptGroupCount
      pResultFunctionInt = ResultGroupCount(Fint)
  
    Case mAux.csRptFormulaType.csRptGroupLineNumber
      pResultFunctionInt = ResultGroupLineNumber(Fint)
    
    Case mAux.csRptFormulaType.csRptIsInRs
      pResultFunctionInt = ResultIsInRs(Fint)
    
  End Select
End Function

Private Function pEvalSintax(ByVal FunctionName As String, ByVal Code As String, ByVal bParam As Boolean) As Variant
  Dim i As Integer
  Dim s As String
  
  Code = RemoveReturns(Code)
  
  If LenB(FunctionName) > 0 Then
    pEvalSintax = pCheckInternalFunction(FunctionName, Code)
  ElseIf LenB(Code) = 0 Then
    pEvalSintax = vbNullString
  ElseIf Code = """""" Then
    pEvalSintax = vbNullString
  ElseIf IsNumeric(Code) Then
    pEvalSintax = Code
  ElseIf IsDate(Code) Then
    pEvalSintax = Code
  ElseIf pIsTime(Code) Then
    pEvalSintax = Code
  ElseIf Not bParam Then
    pExecScriptCode Code
    pEvalSintax = Code
  Else
    
    Dim vParams As Variant
    Dim Params  As String
    
    Params = Trim$(Code)
    If Len(Params) > 2 Then
      Params = Mid$(Params, 2, Len(Params) - 2)
      Params = Trim$(Params)
      vParams = Split(Params, "|")
    End If
    
    On Error Resume Next
    
    For i = 0 To UBound(vParams)
      ' Si es un numero no lo evaluo
      If Not IsNumeric(vParams(i)) Then

        If Not pIsControl(vParams(i)) Then
          ' Si se produce un error es por que se trata
          ' de un parametro a la funcion, la asignacion
          ' no se llevara a cabo, y no perdere el valor
          ' del parametro
          s = c_TempFunctionB & vParams(i) & c_TempFunctionE
          vParams(i) = pExecScriptCode(s)
        End If
      End If
      Code = vParams(i) & "|"
    Next
    
    Code = RemoveLastColon(Code)
    pEvalSintax = Code
  End If
End Function

Private Function pIsTime(ByVal Code As String) As Boolean
  Dim vTime As Variant
  
  Code = Trim$(Code)
  If InStr(1, Code, ":") = 0 Then Exit Function
  
  vTime = Split(Code, ":")
  If UBound(vTime) <> 1 Then Exit Function
  
  If Not IsNumeric(vTime(0)) And IsNumeric(vTime(1)) Then Exit Function
  pIsTime = True
End Function

Private Sub pCheckSintax(ByVal Code As String)
  pCompile Code, True, vbNullString
End Sub

Private Function pExecScriptCode(ByVal Code As String)
  On Error GoTo ControlError
  
  Code = pPipeToColon(Code)
  
  m_ObjScript.Language = "VBScript"
  m_ObjScript.AllowUI = True
  m_ObjScript.UseSafeSubset = False
  m_ObjScript.Reset
  m_ObjScript.AddCode Code
  m_ObjScript.AddObject "Report", m_ObjGlobals
  pExecScriptCode = m_ObjScript.Eval(pGetSubName(Code))
  Exit Function
ControlError:

  Dim errNumber As Long
  Dim errSource As String
  Dim errDescription As String
  Dim errHelpfile As String
  Dim errHelpcontext As Long

  If Err.Number Then
    errNumber = Err.Number
    errSource = Err.Source
    errHelpcontext = Err.HelpContext
    errHelpfile = Err.HelpFile
    errDescription = Err.Description & vbCrLf & vbCrLf & Code
    Resume RaiseError
  End If
RaiseError:
  On Error GoTo 0
  
  ' Si el error no es que se espera una sentencia
  '
  If errNumber <> 1024 Then
    Err.Raise errNumber, errSource, errDescription, errHelpfile, errHelpcontext
  End If
End Function

Private Function pIsControl(ByVal Param As String) As Boolean
  Dim ctrl As cReportControl
  For Each ctrl In m_Report.Controls
    If UCase(ctrl.Name) = UCase(Param) Then
      pIsControl = True
      Exit Function
    End If
  Next
End Function

Private Function pGetControl(ByVal Param As String) As cReportControl
  Dim ctrl As cReportControl
  For Each ctrl In m_Report.Controls
    If UCase(ctrl.Name) = UCase(Param) Then
      Set pGetControl = ctrl
      Exit Function
    End If
  Next
End Function

Private Function pGetSubName(ByVal Code As String) As String
  Dim pos As Integer
  Dim i As Integer
  Dim c As String

  pos = InStr(1, Code, "function ", vbTextCompare)
  pos = pos + 9 ' len de "function "

  Code = Mid$(Code, 1, pos) & Trim$(Mid$(Code, pos + 1))

  i = pos + 1
  Do

    c = Mid$(Code, i, 1)

    If pIsSeparator(c) Then Exit Do

    i = i + 1
  Loop Until i > Len(Code)

  pGetSubName = Trim$(Mid$(Code, pos, i - pos))
End Function

Private Function pGetParameter(ByVal Params As String, ByVal ParamIndex As Integer, ByVal Funcion As String) As String
  Dim Param As String
  Dim vParam As Variant
  
  vParam = Split(Params, "|")

  If ParamIndex > UBound(vParam) + 1 Then
    Err.Raise csRptErrors.csRptErrMissingParam, C_Module, errGetDescript(csRptErrors.csRptErrMissingParam, ParamIndex, Funcion)
  Else
    Param = vParam(ParamIndex - 1)
  End If

  pGetParameter = Trim$(Replace(Param, ")", vbNullString))
End Function

Private Function pCheckInternalFunction(ByVal FunctionName As String, ByVal Code As String) As Variant
  Dim pos         As Integer
  Dim Name        As String
  Dim Params      As String
  Dim IdFunction As Integer

  Dim r As Long
  Dim q As Long
  Dim Tc As String
  
  Name = FunctionName
  Params = Trim$(Code)
  If Len(Params) > 2 Then Params = Mid$(Params, 2, Len(Params) - 2)
  
  ' Aca reemplazo en m_Formula.TextC el nombre de la funcion
  ' por la clave
  Tc = m_Formula.TextC
  q = Len(Name)
  r = InStr(1, Tc, Name, vbTextCompare)
  q = InStr(r, Tc, ")", vbTextCompare) + 1

  m_Formula.TextC = Mid$(Tc, 1, r - 1) & c_KeyFuncInt & Format(m_Formula.FormulasInt.Count, "000") & Mid$(Tc, q)

  IdFunction = pGetIdFunction(Name)

  ' defino el tipo de funcion interna
  m_Fint.FormulaType = IdFunction

  Select Case IdFunction

    Case mAux.csRptFormulaType.csRptFPageNumber
      
      ' Para que evalue cuando esta compilando
      '
      If m_Report Is Nothing Then
        pCheckInternalFunction = 0
      Else
        pCheckInternalFunction = m_Report.CurrenPage
      End If
      
    Case mAux.csRptFormulaType.csRptTextReplace
      pCheckInternalFunction = ""
    
    Case mAux.csRptFormulaType.csRptFTotalPages
      
      pCheckInternalFunction = m_Report.TotalPages

      ' Todas estas reciben la misma cantidad de parametros
    Case mAux.csRptFormulaType.csRptFAverage, mAux.csRptFormulaType.csRptFSum, _
         mAux.csRptFormulaType.csRptMax, mAux.csRptFormulaType.csRptMin, _
         mAux.csRptFormulaType.csRptLength, mAux.csRptFormulaType.csRptFVal

      ' En esta evaluacion se cargan los parametros
      pCheckParams 1, Params, Name

      ' devuelvo un valor razonable para que pueda seguir compilando
      pCheckInternalFunction = 0

      ' Todas estas reciben la misma cantidad de parametros
    Case mAux.csRptFormulaType.csRptGroupTotal, mAux.csRptFormulaType.csRptGroupMax, _
         mAux.csRptFormulaType.csRptGroupMin, mAux.csRptFormulaType.csRptGroupAverage

      ' En esta evaluacion se cargan los parametros
      pCheckParams 2, Params, Name

      ' devuelvo un valor razonable para que pueda seguir compilando
      pCheckInternalFunction = 0
      
      ' Todas estas reciben la misma cantidad de parametros
    Case mAux.csRptFormulaType.csRptGroupCount, _
         mAux.csRptFormulaType.csRptGroupPercent
      
      ' En esta evaluacion se cargan los parametros
      pCheckParams 3, Params, Name

      ' devuelvo un valor razonable para que pueda seguir compilando
      pCheckInternalFunction = 0

    Case mAux.csRptFormulaType.csRptFGetString

      ' En esta evaluacion se cargan los parametros
      pCheckParams 1, Params, Name

      ' devuelvo un valor razonable para que pueda seguir compilando
      pCheckInternalFunction = """"""

    Case mAux.csRptFormulaType.csRptFSumTime

      ' En esta evaluacion se cargan los parametros
      pCheckParams 2, Params, Name

      ' devuelvo un valor razonable para que pueda seguir compilando
      pCheckInternalFunction = 0

    Case mAux.csRptFormulaType.csRptCount
      
      ' devuelvo un valor razonable para que pueda seguir compilando
      pCheckInternalFunction = 0

    Case mAux.csRptFormulaType.csRptFNumberToString
      
      ' En esta evaluacion se cargan los parametros
      pCheckParams 2, Params, Name

      ' devuelvo un valor razonable para que pueda seguir compilando
      pCheckInternalFunction = """"""

    Case mAux.csRptFormulaType.csRptIsEqual, mAux.csRptFormulaType.csRptIsNotEqual, _
         mAux.csRptFormulaType.csRptIsGreaterThan, mAux.csRptFormulaType.csRptIsLessThan, _
         mAux.csRptFormulaType.csRptIsInRs
         
      ' En esta evaluacion se cargan los parametros
      pCheckParams 2, Params, Name

      ' devuelvo un valor razonable para que pueda seguir compilando
      pCheckInternalFunction = 0

    Case mAux.csRptFormulaType.csRptFCalculo, _
         mAux.csRptFormulaType.csRptGetDataFromRsAd, _
         mAux.csRptFormulaType.csRptGetDataFromRs
      
      ' En esta evaluacion se cargan los parametros
      pCheckParams 4, Params, Name
      
      ' devuelvo un valor razonable para que pueda seguir compilando
      pCheckInternalFunction = 0
      
    Case csRptFormulaType.csRptDeclareVar, csRptFormulaType.csRptGetVar
    
      ' En esta evaluacion se cargan los parametros
      pCheckParams 1, Params, Name

      ' devuelvo un valor razonable para que pueda seguir compilando
      pCheckInternalFunction = 0
      
    Case csRptFormulaType.csRptGetParam

      ' En esta evaluacion se cargan los parametros
      pCheckParams 1, Params, Name

      ' devuelvo un valor razonable para que pueda seguir compilando
      pCheckInternalFunction = 0
    
    Case csRptFormulaType.csRptAddToVar, csRptFormulaType.csRptSetVar

      ' En esta evaluacion se cargan los parametros
      pCheckParams 2, Params, Name

      ' devuelvo un valor razonable para que pueda seguir compilando
      pCheckInternalFunction = 0

    Case Else
      Err.Raise csRptErrors.csRptErrIndefinedFunction, C_Module, errGetDescript(csRptErrors.csRptErrIndefinedFunction, Name)
  End Select
End Function

Private Function ResultGetString(ByRef Fint As cReportFormulaInt) As String
  Dim Param As String
  
  Param = Fint.Parameters.Item(1).Value
  
  If Param = """""" Then
    ResultGetString = """"""
  Else
    If pIsControl(Param) Then
      ResultGetString = """" & Replace(m_Report.GetValue(Param), """", """""") & """"
    Else
      ResultGetString = """" & Replace(Param, """", """""") & """"
    End If
  End If
End Function

Private Function ResultSumTime(ByRef Fint As cReportFormulaInt) As String
  If Fint.Variables.Count = 0 Then Exit Function
  Dim st As cStructTime
  Set st = Fint.Variables.Item(c_SumTime).Value
  If Val(Fint.Parameters.Item(2).Value) <> 0 Then
    ResultSumTime = Format(st.Hour, "00") & ":" & Format(st.Minute, "00") & ":" & Format(st.Second, "00")
  Else
    ResultSumTime = Format(st.Hour, "00") & ":" & Format(st.Minute, "00")
  End If
End Function

Private Function ResultSum(ByRef Fint As cReportFormulaInt) As Double
  If Fint.Variables.Count = 0 Then Exit Function
  ResultSum = Fint.Variables.Item(c_Sum).Value
End Function

Private Function ResultGetDataFromRsAd(ByRef Fint As cReportFormulaInt) As Variant

End Function

Private Function ResultGetDataFromRs(ByRef Fint As cReportFormulaInt) As Variant

End Function

Private Function ResultGetVar(ByRef Fint As cReportFormulaInt) As Variant
  Dim varName As String
  varName = Fint.Parameters.Item(1).Value
  
  If m_Variables.Item(varName) Is Nothing Then
    Err.Raise csRptErrors.csRptErrMissingParam, _
              C_Module, _
              errGetDescript(csRptErrors.csRptErrVarNotDefined, _
                             varName)
  End If

  ResultGetVar = m_Variables.Item(varName).Value
End Function

Private Function ResultGetParam(ByRef Fint As cReportFormulaInt) As Variant
  Dim Param       As cParameter
  Dim ParamName   As String
  
  ParamName = Fint.Parameters.Item(1).Value
  
  For Each Param In m_Report.Connect.Parameters
    If LCase$(Param.Name) = LCase$(ParamName) Then
      Exit For
    End If
  Next
    
  If Param Is Nothing Then
    Err.Raise csRptErrors.csRptErrMissingParam, _
              C_Module, _
              errGetDescript(csRptErrors.csRptErrParamNotDefined, _
                             ParamName)
  End If
    
  ResultGetParam = Param.Value
End Function

Private Function ResultMax(ByRef Fint As cReportFormulaInt) As Double
  If Fint.Variables.Count = 0 Then Exit Function
  ResultMax = Fint.Variables.Item(c_Max).Value
End Function

Private Function ResultMin(ByRef Fint As cReportFormulaInt) As Double
  If Fint.Variables.Count = 0 Then Exit Function
  ResultMin = Fint.Variables.Item(c_Min).Value
End Function

Private Function ResultCount(ByRef Fint As cReportFormulaInt) As Variant
  If Fint.Variables.Count = 0 Then Exit Function
  ResultCount = Fint.Variables.Item(c_Count).Value
End Function

Private Function ResultNumberToString(ByRef Fint As cReportFormulaInt) As Variant
  If Fint.Variables.Count Then
    ResultNumberToString = Fint.Variables.Item(c_NumberToString).Value
  Else
    ResultNumberToString = vbNullString
  End If
End Function

Private Function ResultIsEqual(ByRef Fint As cReportFormulaInt) As Variant
  If Fint.Variables.Count Then
    ResultIsEqual = Fint.Variables.Item(c_IsEqual).Value
  Else
    ResultIsEqual = 0
  End If
End Function

Private Function ResultIsNotEqual(ByRef Fint As cReportFormulaInt) As Variant
  If Fint.Variables.Count Then
    ResultIsNotEqual = Fint.Variables.Item(c_IsNotEqual).Value
  Else
    ResultIsNotEqual = 0
  End If
End Function

Private Function ResultIsGreaterThan(ByRef Fint As cReportFormulaInt) As Variant
  If Fint.Variables.Count Then
    ResultIsGreaterThan = Fint.Variables.Item(c_IsGreaterThan).Value
  Else
    ResultIsGreaterThan = 0
  End If
End Function

Private Function ResultIsLessThan(ByRef Fint As cReportFormulaInt) As Variant
  If Fint.Variables.Count Then
    ResultIsLessThan = Fint.Variables.Item(c_IsLessThan).Value
  Else
    ResultIsLessThan = 0
  End If
End Function

Private Function ResultAverage(ByRef Fint As cReportFormulaInt) As Double
  If Fint.Variables.Count = 0 Then Exit Function
  ResultAverage = Fint.Variables.Item(c_AverageSum).Value / Fint.Variables.Item(c_AverageCant).Value
End Function

Private Function ResultCalculo(ByRef Fint As cReportFormulaInt) As Double
  Dim Control     As String
  Dim Value1      As Variant
  Dim Value2      As Variant
  Dim Operator    As Long
  
  Control = Fint.Parameters.Item(2).Value
  
  Value1 = m_Report.GetValue(Fint.Parameters.Item(1).Value, True)
  
  If Control <> """""" Then
    Value2 = m_Report.GetValue(Control, True)
  Else
    Value2 = Fint.Parameters.Item(3).Value
  End If
  
  Operator = Fint.Parameters.Item(4).Value
  
  Select Case Operator
    Case 1 ' Suma
      ResultCalculo = Value1 + Value2
    Case 2 ' Resta
      ResultCalculo = Value1 - Value2
    Case 3 ' Multiplicacion
      ResultCalculo = Value1 * Value2
    Case 4 ' Division
      ResultCalculo = DivideByCero(Value1, Value2)
    Case 5 ' Exponente
      ResultCalculo = Value1 ^ Value2
    Case Else
      ResultCalculo = 0
  End Select
End Function

Private Function ResultLength(ByRef Fint As cReportFormulaInt) As Long
  ResultLength = Len(m_Report.GetValue(Fint.Parameters.Item(1).Value))
End Function

Private Function ResultTextReplace(ByRef Fint As cReportFormulaInt) As String
  Dim i         As Integer
  Dim ctrl      As cReportControl
  Dim text      As String
  Dim collCtrlsToReplace As Collection
        
  Set ctrl = pGetControl(m_ctrlName)
  If ctrl Is Nothing Then Exit Function
  text = ctrl.Label.text
  
  On Error Resume Next
  
  Err.Clear
  Set collCtrlsToReplace = m_collTextReplace.Item(m_ctrlName)
  
  If Err.Number Then
    
    Dim lastIndex As Integer
    Dim lenText As Integer
    Dim pos As Integer
    Dim endpos As Integer
    
    Set collCtrlsToReplace = New Collection
    
    lenText = Len(text)
    ReDim vCtrlsToReplace(200)
    While i < lenText
      pos = InStr(i + 1, text, c_MACRO_CTRL)
      If pos > 0 Then
        endpos = InStr(pos + 1, text, c_MACRO_CTRL)
        
        If endpos > 0 Then
          collCtrlsToReplace.Add Mid$(text, pos + 2, endpos - pos - 2)
        End If
        i = endpos + 1
      Else
        i = lenText + 1
      End If
    Wend
    
    m_collTextReplace.Add collCtrlsToReplace
    
  End If
  
  Dim ctrlValue As cReportControl
  For i = 1 To collCtrlsToReplace.Count
    Set ctrlValue = pGetControl(collCtrlsToReplace.Item(i))
    If Not ctrlValue Is Nothing Then
      text = Replace$(text, c_MACRO_CTRL & collCtrlsToReplace.Item(i) & c_MACRO_CTRL, m_Report.GetValue(ctrlValue.Name, False))
    End If
  Next
    
  ResultTextReplace = text
End Function

Private Function ResultValue(ByRef Fint As cReportFormulaInt) As Variant
  ResultValue = m_Report.GetValue(Fint.Parameters.Item(1).Value, True)
End Function

Private Function ResultPageNumber() As Integer
  ResultPageNumber = m_Report.CurrenPage
End Function

Private Function ResultTotalPages() As Variant
  ResultTotalPages = m_Report.TotalPages
End Function

Private Function ResultGroupTotal(ByRef Fint As cReportFormulaInt) As Variant
  If Fint.Variables.Count Then
    ResultGroupTotal = Fint.Variables.Item(c_GroupTotal).Value
  Else
    ResultGroupTotal = 0
  End If
End Function

Private Function ResultGroupMax(ByRef Fint As cReportFormulaInt) As Variant
  If Fint.Variables.Count Then
    ResultGroupMax = Fint.Variables.Item(c_GroupMax).Value
  Else
    ResultGroupMax = 0
  End If
End Function

Private Function ResultGroupMin(ByRef Fint As cReportFormulaInt) As Variant
  If Fint.Variables.Count Then
    ResultGroupMin = Fint.Variables.Item(c_GroupMin).Value
  Else
    ResultGroupMin = 0
  End If
End Function

Private Function ResultGroupAverage(ByRef Fint As cReportFormulaInt) As Variant
  If Fint.Variables.Count Then
    ResultGroupAverage = Fint.Variables.Item(c_GroupAverage).Value
  Else
    ResultGroupAverage = 0
  End If
End Function

Private Function ResultGroupPercent(ByRef Fint As cReportFormulaInt) As Variant
  Dim Value As Double
  Dim Total As Double
  
  If Fint.Variables.Count Then
    ResultGroupPercent = Fint.Variables.Item(c_GroupPercent).Value
  Else
    ResultGroupPercent = 0
  End If
End Function

Private Function ResultGroupCount(ByRef Fint As cReportFormulaInt) As Variant
  If Fint.Variables.Count Then
    ResultGroupCount = Fint.Variables.Item(c_GroupCount).Value
  Else
    ResultGroupCount = 0
  End If
End Function

Private Function ResultGroupLineNumber(ByRef Fint As cReportFormulaInt) As Variant
  If Fint.Variables.Count Then
    ResultGroupLineNumber = Fint.Variables.Item(c_GroupLineNumber).Value
  Else
    ResultGroupLineNumber = 0
  End If
End Function

Private Function ResultIsInRs(ByRef Fint As cReportFormulaInt) As Variant
  If Fint.Variables.Count Then
    ResultIsInRs = Fint.Variables.Item(c_IsInRs).Value
  Else
    ResultIsInRs = 0
  End If
End Function

'//////////////////////////////////////////////////////////////////////////////////////////////////

Private Sub EvalAverage(ByRef Fint As cReportFormulaInt)
  With Fint
    If .Variables.Item(c_AverageSum) Is Nothing Then
      .Variables.Add , c_AverageSum
      .Variables.Add , c_AverageCant
    End If

    With .Variables.Item(c_AverageSum)
      ' El Average es para numeros
      .Value = .Value + pGetNumber(m_Report.GetValue(Fint.Parameters.Item(1).Value, True))
    End With
    
    With .Variables.Item(c_AverageCant)
      ' El Average es para numeros
      .Value = .Value + 1
    End With
  End With
End Sub

Private Function pGetNumber(ByVal strNumber As String) As Double
  Dim rtn As Double
  Dim sepDecimal As String
  
  If IsNumeric(strNumber) Then
  
    sepDecimal = GetSepDecimal
    If sepDecimal <> "." Then
      strNumber = Replace(strNumber, ".", sepDecimal)
    End If
    rtn = Val(strNumber)
  
  End If
  
  pGetNumber = rtn
End Function

Private Sub EvalSum(ByRef Fint As cReportFormulaInt)
  With Fint
    If .Variables.Item(c_Sum) Is Nothing Then
      .Variables.Add(, c_Sum).Value = 0
    End If

    With .Variables.Item(c_Sum)
      ' El Sum es para numeros
      .Value = .Value + pGetNumber(m_Report.GetValue(Fint.Parameters.Item(1).Value, True))
    End With
  End With
End Sub

Private Sub EvalDeclareVar(ByRef Fint As cReportFormulaInt)
  Dim varName As String
   
  varName = Fint.Parameters.Item(1).Value
  
  If m_Variables(varName) Is Nothing Then
    m_Variables.Add , varName
  End If
End Sub

Private Sub EvalSetVar(ByRef Fint As cReportFormulaInt)
  Dim varName As String
   
  varName = Fint.Parameters.Item(1).Value
  
  If m_Variables.Item(varName) Is Nothing Then
    Err.Raise csRptErrors.csRptErrMissingParam, _
              C_Module, _
              errGetDescript(csRptErrors.csRptErrVarNotDefined, _
                             varName)
  End If

  With m_Variables.Item(varName)
    .Value = Fint.Parameters.Item(2).Value
  End With
End Sub

Private Sub EvalGetDataFromRsAd(ByRef Fint As cReportFormulaInt)

End Sub

Private Sub EvalGetDataFromRs(ByRef Fint As cReportFormulaInt)

End Sub

Private Sub EvalAddToVar(ByRef Fint As cReportFormulaInt)
  Dim varName As String
   
  varName = Fint.Parameters.Item(1).Value
  
  If m_Variables.Item(varName) Is Nothing Then
    Err.Raise csRptErrors.csRptErrMissingParam, C_Module, errGetDescript(csRptErrors.csRptErrMissingParam, varName)
  End If

  With m_Variables.Item(varName)
    ' El EvalAddToVar es para numeros
    Debug.Print Fint.Parameters.Item(2).Value
    .Value = .Value + pGetNumber(Fint.Parameters.Item(2).Value)
  End With
End Sub

Private Sub EvalSumTime(ByRef Fint As cReportFormulaInt)
  With Fint
    If .Variables.Item(c_SumTime) Is Nothing Then
      .Variables.Add(, c_SumTime).Value = New cStructTime
    End If

    With .Variables.Item(c_SumTime)
      ' El SumTime es para fechas
      pSumTimes .Value, m_Report.GetValue(Fint.Parameters.Item(1).Value, True)
    End With
  End With
End Sub

Private Sub EvalMax(ByRef Fint As cReportFormulaInt)
  Dim Value As Variant
  With Fint
    If .Variables.Item(c_Max) Is Nothing Then
      .Variables.Add , c_Max
    End If

    With .Variables.Item(c_Max)
      ' El Max es para numeros y para textos

      Value = m_Report.GetValue(Fint.Parameters.Item(1).Value)

      If .Value < Value Then

        .Value = Value
      End If

    End With
  End With
End Sub

Private Sub EvalMin(ByRef Fint As cReportFormulaInt)
  Dim Value As Variant
  With Fint
    If .Variables.Item(c_Min) Is Nothing Then
      .Variables.Add , c_Min
    End If

    With .Variables.Item(c_Min)
      ' El Max es para numeros y para textos

      Value = m_Report.GetValue(Fint.Parameters.Item(1).Value)

      If .Value > Value Then

        .Value = Value
      End If

    End With
  End With
End Sub

Private Sub EvalCount(ByRef Fint As cReportFormulaInt)
  With Fint
    If .Variables.Item(c_Count) Is Nothing Then
      .Variables.Add , c_Count
    End If

    With .Variables.Item(c_Count)
      ' El Count es para numeros
      .Value = .Value + 1
    End With
  End With
End Sub

Private Sub EvalNumberToString(ByRef Fint As cReportFormulaInt)
  With Fint
    If .Variables.Item(c_NumberToString) Is Nothing Then
      .Variables.Add , c_NumberToString
    End If

    With .Variables.Item(c_NumberToString)
      ' El NumberToString es para numeros
      Dim iNumber As Double
      Dim iLenguage As Long
      
      iNumber = pGetNumber(m_Report.GetValue(Fint.Parameters.Item(1).Value, True))
      iLenguage = Val(Fint.Parameters.Item(2).Value)
      
      Dim ntos As CSKernelNumberToString.cNumberToString
      Set ntos = New CSKernelNumberToString.cNumberToString
      
      Select Case iLenguage
        Case c_Spanish
          .Value = ntos.SpanishNumberToString(iNumber)
        Case c_English
          .Value = ntos.EnglishNumberToString(iNumber)
        Case c_French
          .Value = ntos.FrenchNumberToString(iNumber)
      End Select
    End With
  End With
End Sub

Private Sub EvalIsEqual(ByRef Fint As cReportFormulaInt)
  With Fint
    If .Variables.Item(c_IsEqual) Is Nothing Then
      .Variables.Add , c_IsEqual
    End If

    With .Variables.Item(c_IsEqual)
      ' El IsEqual es para numeros
      Dim strValue        As String
      Dim strConstValue   As String
      
      strValue = m_Report.GetValue(Fint.Parameters.Item(1).Value, True)
      strConstValue = Fint.Parameters.Item(2).Value
      
      .Value = strValue = strConstValue
      
    End With
  End With
End Sub

Private Sub EvalIsNotEqual(ByRef Fint As cReportFormulaInt)
  With Fint
    If .Variables.Item(c_IsNotEqual) Is Nothing Then
      .Variables.Add , c_IsNotEqual
    End If

    With .Variables.Item(c_IsNotEqual)
      ' El IsEqual es para numeros
      Dim strValue        As String
      Dim strConstValue   As String
      
      strValue = m_Report.GetValue(Fint.Parameters.Item(1).Value, True)
      strConstValue = Fint.Parameters.Item(2).Value
      
      .Value = strValue <> strConstValue
      
    End With
  End With
End Sub

Private Sub EvalIsGreaterThan(ByRef Fint As cReportFormulaInt)
  With Fint
    If .Variables.Item(c_IsGreaterThan) Is Nothing Then
      .Variables.Add , c_IsGreaterThan
    End If

    With .Variables.Item(c_IsGreaterThan)
      ' El IsEqual es para numeros
      Dim strValue        As String
      Dim strConstValue   As String
      
      strValue = m_Report.GetValue(Fint.Parameters.Item(1).Value, True)
      strConstValue = Fint.Parameters.Item(2).Value
      
      .Value = strValue > strConstValue
      
    End With
  End With
End Sub

Private Sub EvalIsLessThan(ByRef Fint As cReportFormulaInt)
  With Fint
    If .Variables.Item(c_IsLessThan) Is Nothing Then
      .Variables.Add , c_IsLessThan
    End If

    With .Variables.Item(c_IsLessThan)
      ' El IsEqual es para numeros
      Dim strValue        As String
      Dim strConstValue   As String
      
      strValue = m_Report.GetValue(Fint.Parameters.Item(1).Value, True)
      strConstValue = Fint.Parameters.Item(2).Value
      
      .Value = strValue < strConstValue
      
    End With
  End With
End Sub

Private Sub EvalGroupTotal(ByRef Fint As cReportFormulaInt)
  With Fint
    If .Variables.Item(c_GroupTotal) Is Nothing Then
      .Variables.Add , c_GroupTotal
    End If

    With .Variables.Item(c_GroupTotal)
      ' El Total es para numeros
      
      ' Si en param1 no tengo un indice de columna es por que
      ' aun no procese las formulas. Esto sucede por que compilereport
      ' se llama antes de InitColIndex en la funcion Launch de cReport
      ' y no se puede cambiar el orden, ya que GetData se ejecuta despues
      ' de CompileReport, y no queremos cambiar este orden de ejecucion
      ' por temor a los efectos que pueda generar.
      '
      ' En el futuro con mas tiempo se puede ver que significaria este
      ' cambio y si no trae problemas, se podria evitar este IF.
      '
      If Fint.Parameters.Item(c_KeyIndexCol) Is Nothing Then
        
        .Value = 0
      
      Else
        ' TODO: Sumarizar el grupo
        .Value = m_Report.GetGroupTotal(Fint.Parameters.Item(c_KeyIndexCol).Value, _
                                        Fint.Parameters.Item(c_KeyIndexGroup).Value)
      End If
    End With
  End With
End Sub

Private Sub EvalGroupMax(ByRef Fint As cReportFormulaInt)
  Dim Value As Variant
  With Fint
    If .Variables.Item(c_GroupMax) Is Nothing Then
      .Variables.Add , c_GroupMax
    End If

    With .Variables.Item(c_GroupMax)
      ' El Max es para numeros y para textos

      ' Si en param1 no tengo un indice de columna es por que
      ' aun no procese las formulas. Esto sucede por que compilereport
      ' se llama antes de InitColIndex en la funcion Launch de cReport
      ' y no se puede cambiar el orden, ya que GetData se ejecuta despues
      ' de CompileReport, y no queremos cambiar este orden de ejecucion
      ' por temor a los efectos que pueda generar.
      '
      ' En el futuro con mas tiempo se puede ver que significaria este
      ' cambio y si no trae problemas, se podria evitar este IF.
      '
      If Fint.Parameters.Item(c_KeyIndexCol) Is Nothing Then
        
        .Value = 0
      
      Else
        ' TODO: Sumarizar el grupo
        .Value = m_Report.GetGroupMax(Fint.Parameters.Item(c_KeyIndexCol).Value, _
                                      Fint.Parameters.Item(c_KeyIndexGroup).Value)
      End If

    End With
  End With
End Sub

Private Sub EvalGroupMin(ByRef Fint As cReportFormulaInt)
  Dim Value As Variant
  With Fint
    If .Variables.Item(c_GroupMin) Is Nothing Then
      .Variables.Add , c_GroupMin
    End If

    With .Variables.Item(c_GroupMin)
      ' El Min es para numeros y para textos

      ' Si en param1 no tengo un indice de columna es por que
      ' aun no procese las formulas. Esto sucede por que compilereport
      ' se llama antes de InitColIndex en la funcion Launch de cReport
      ' y no se puede cambiar el orden, ya que GetData se ejecuta despues
      ' de CompileReport, y no queremos cambiar este orden de ejecucion
      ' por temor a los efectos que pueda generar.
      '
      ' En el futuro con mas tiempo se puede ver que significaria este
      ' cambio y si no trae problemas, se podria evitar este IF.
      '
      If Fint.Parameters.Item(c_KeyIndexCol) Is Nothing Then
        
        .Value = 0
      
      Else
        ' TODO: Sumarizar el grupo
        .Value = m_Report.GetGroupMin(Fint.Parameters.Item(c_KeyIndexCol).Value, _
                                      Fint.Parameters.Item(c_KeyIndexGroup).Value)
      End If

    End With
  End With
End Sub

Private Sub EvalGroupAverage(ByRef Fint As cReportFormulaInt)
  With Fint
    If .Variables.Item(c_GroupAverage) Is Nothing Then
      .Variables.Add , c_GroupAverage
    End If

    With .Variables.Item(c_GroupAverage)
      
      ' El Average es para numeros
      
      ' Si en param1 no tengo un indice de columna es por que
      ' aun no procese las formulas. Esto sucede por que compilereport
      ' se llama antes de InitColIndex en la funcion Launch de cReport
      ' y no se puede cambiar el orden, ya que GetData se ejecuta despues
      ' de CompileReport, y no queremos cambiar este orden de ejecucion
      ' por temor a los efectos que pueda generar.
      '
      ' En el futuro con mas tiempo se puede ver que significaria este
      ' cambio y si no trae problemas, se podria evitar este IF.
      '
      If Fint.Parameters.Item(c_KeyIndexCol) Is Nothing Then
        
        .Value = 0
      
      Else
        ' TODO: Sumarizar el grupo
        .Value = m_Report.GetGroupAverage(Fint.Parameters.Item(c_KeyIndexCol).Value, _
                                          Fint.Parameters.Item(c_KeyIndexGroup).Value)
      End If
    
    End With
  End With
End Sub

' Esta funcio solo obtiene el total del grupo.
' El porcentaje se obtiene en ResultGroupPercent
'
Private Sub EvalGroupPercent(ByRef Fint As cReportFormulaInt)
  With Fint
    If .Variables.Item(c_GroupPercentT) Is Nothing Then
      .Variables.Add , c_GroupPercentT
    End If
    
    If .Variables.Item(c_GroupPercent) Is Nothing Then
      .Variables.Add , c_GroupPercent
    End If

    With .Variables.Item(c_GroupPercentT)
      ' El Percent es para numeros
      
      ' Si en param1 no tengo un indice de columna es por que
      ' aun no procese las formulas. Esto sucede por que compilereport
      ' se llama antes de InitColIndex en la funcion Launch de cReport
      ' y no se puede cambiar el orden, ya que GetData se ejecuta despues
      ' de CompileReport, y no queremos cambiar este orden de ejecucion
      ' por temor a los efectos que pueda generar.
      '
      ' En el futuro con mas tiempo se puede ver que significaria este
      ' cambio y si no trae problemas, se podria evitar este IF.
      '
      If Fint.Parameters.Item(c_KeyIndexCol) Is Nothing Then
        
        .Value = 0
      
      Else
        ' TODO: Sumarizar el grupo
        .Value = m_Report.GetGroupTotal(Fint.Parameters.Item(c_KeyIndexCol).Value, _
                                        Fint.Parameters.Item(c_KeyIndexGroup).Value)
      End If
    End With
  End With

  pEvalFunctionGroup Fint

End Sub

Private Sub EvalGroupCount(ByRef Fint As cReportFormulaInt)
  With Fint
    If .Variables.Item(c_GroupCount) Is Nothing Then
      .Variables.Add , c_GroupCount
    End If

    With .Variables.Item(c_GroupCount)
      ' El Count es para numeros
      
      ' Si en param1 no tengo un indice de columna es por que
      ' aun no procese las formulas. Esto sucede por que compilereport
      ' se llama antes de InitColIndex en la funcion Launch de cReport
      ' y no se puede cambiar el orden, ya que GetData se ejecuta despues
      ' de CompileReport, y no queremos cambiar este orden de ejecucion
      ' por temor a los efectos que pueda generar.
      '
      ' En el futuro con mas tiempo se puede ver que significaria este
      ' cambio y si no trae problemas, se podria evitar este IF.
      '
      If Fint.Parameters.Item(c_KeyIndexCol) Is Nothing Then
        
        .Value = 0
      
      Else
        ' TODO: Sumarizar el grupo
        .Value = m_Report.GetGroupCount(Fint.Parameters.Item(c_KeyIndexCol).Value, _
                                        Fint.Parameters.Item(c_KeyIndexGroup).Value)
      End If
    End With
  End With
End Sub

Private Sub EvalGroupLineNumber(ByRef Fint As cReportFormulaInt)
  With Fint
    If .Variables.Item(c_GroupLineNumber) Is Nothing Then
      .Variables.Add , c_GroupLineNumber
    End If

    With .Variables.Item(c_GroupLineNumber)
      ' El LineNumber es para numeros
      
      ' TODO: Obtener el numero de rénglon
      .Value = m_Report.GetGroupLineNumber(Fint.Parameters.Item(c_KeyIndexGroup).Value)
    End With
  End With
End Sub

Private Sub EvalIsInRs(ByRef Fint As cReportFormulaInt)
  With Fint
    If .Variables.Item(c_IsInRs) Is Nothing Then
      .Variables.Add , c_IsInRs
    End If

    With .Variables.Item(c_IsInRs)
      ' El LineNumber es para numeros
      
      ' TODO: Obtener el numero de rénglon
      .Value = True
    End With
  End With
End Sub

'//////////////////////////////////////////////////////////////////////////////////////////////////

Private Sub pCheckParams(ByVal CantParams As Integer, ByVal Params As String, ByVal Name As String)
  Dim Param As String
  Dim i As Integer

  For i = 1 To CantParams
    ' Debe recibir el nombre del control
    Param = pGetParameter(Params, i, Name)

    If LenB(Param) = 0 Then
      Err.Raise csRptErrors.csRptErrMissingParam, C_Module, errGetDescript(csRptErrors.csRptErrMissingParam, i, Name)
    End If

    ' Agrego el parametro
    m_Fint.Parameters.Add Param
  Next
End Sub

Private Function pGetIdFunction(ByVal Name As String) As Integer
  Dim f As cReportFormulaType

  Name = LCase(Name)
  For Each f In m_FormulaTypes
    If Name = f.Name Then
      pGetIdFunction = f.Id
      Exit Function
    End If
  Next f
End Function

Private Function pIsSeparator(ByVal c As String) As Boolean
  pIsSeparator = InStr(1, " |:+()/-*=" & vbCrLf, c) > 0
End Function

Private Function RemoveReturns(ByVal Code As String) As String
  Dim i As Integer
  Dim c As String
  For i = 1 To Len(Code)
    c = Mid$(Code, i, 1)
    If c <> " " And c <> Chr(10) And c <> Chr(13) Then Exit For
  Next

  RemoveReturns = Mid$(Code, i)
End Function

' La fecha comienza el 1-1-1900 00:00:00
Private Sub pSumTimes(ByRef st As cStructTime, ByVal Date2 As Variant)
  Dim n2 As Long
  Dim h2 As Long
  Dim s2 As Long
  
  Dim n As Long
  Dim h As Long
  Dim s As Long
  Dim d As Long
  
  s2 = Second(Date2)
  n2 = Minute(Date2)
  h2 = Hour(Date2)
  
  ' Calculo segundos
  s = (st.Second + s2) Mod 60
  
  ' Calculo minutos
  n = Int((st.Second + s2) / 60)
  n = n + (st.Minute + n2) Mod 60
  
  ' Calculo horas
  h = Int((st.Minute + n2) / 60)
  h = h + st.Hour + h2
  
  st.Second = s
  st.Minute = n
  st.Hour = h
End Sub

'///////////////////////////////////////////////////////////////
Private Function pCompileAux(ByVal Code As String, ByRef CodeC As String) As Boolean
  Dim nStart            As Long
  Dim CodeCallFunction  As String
  Dim CodeCallFunctionC As String
  Dim nLenCode          As Long
  Dim FunctionName      As String
  Dim Word              As String
  
  CodeC = vbNullString
  
  nLenCode = Len(Code)
  nStart = 1
  Do
    Word = pGetWord(Code, nStart)
    If pIsFunctionAux(Word, FunctionName) Then
      
      CodeCallFunction = pGetCallFunction(Code, nStart)
      
      If Not pCompileAux(CodeCallFunction, CodeCallFunctionC) Then
        Exit Function
      End If
    
      CodeC = CodeC & pExecFunction(FunctionName, CodeCallFunctionC)
    Else
      CodeC = CodeC & Word
    End If
  Loop Until nStart > nLenCode
  
  pCompileAux = True
End Function

Private Function pGetWord(ByVal Code As String, ByRef nStart As Long) As String
  Dim c         As String
  Dim nLenCode  As Long
  Dim Word      As String
  
  nLenCode = Len(Code)
  
  c = Mid$(Code, nStart, 1)
  Do
    Word = Word & c
    nStart = nStart + 1
    If pIsSeparator(c) Then Exit Do
    c = Mid$(Code, nStart, 1)
  Loop Until pIsSeparator(c) Or nStart > nLenCode
  
  pGetWord = Word
End Function

Private Function pIsFunctionAux(ByVal Word As String, ByRef FunctionName As String) As Boolean
  If Not pIsFunction(Word) Then Exit Function
  FunctionName = Word
  pIsFunctionAux = True
End Function

Private Function pGetCallFunction(ByVal Code As String, ByRef nStart As Long) As String
  Dim c         As String
  Dim nLenCode  As Long
  Dim Word      As String
  Dim nInner    As Long
  
  nLenCode = Len(Code)
  nInner = -1
  
  Do
    c = Mid$(Code, nStart, 1)
    Word = Word & c
    nStart = nStart + 1
  Loop Until pIsEndCallFunction(c, nInner) Or nStart > nLenCode
  
  pGetCallFunction = Word
End Function

Private Function pIsEndCallFunction(ByVal c As String, ByRef nInner As Long) As Boolean
  If c = ")" Then
    If nInner = 0 Then
      pIsEndCallFunction = True
    Else
      nInner = nInner - 1
    End If
  ElseIf c = "(" Then
    nInner = nInner + 1
  End If
End Function

Private Function pExecFunction(ByVal FunctionName As String, ByVal Params As String) As String
  If m_bCompile Then
    pExecFunction = pAddFormulaInt(FunctionName, Params)
  Else
    Dim Fint As cReportFormulaInt
    m_IdxFormula = m_IdxFormula + 1
    Set Fint = m_Formula.FormulasInt.Item(m_IdxFormula)
    pSetParams Fint, Params
    pEvalFunctionInt Fint
    pExecFunction = GetNumericVal(pResultFunctionInt(Fint))
  End If
End Function

Private Sub pSetParams(ByRef Fint As cReportFormulaInt, ByVal Params As String)
  Dim vParams As Variant
  Dim rtn     As String
  Dim i       As Long

  Params = Trim$(Params)
  If Len(Params) > 2 Then
    Params = Mid$(Params, 2, Len(Params) - 2)
    Params = Trim$(Params)
    vParams = Split(Params, "|")
  
    For i = 0 To UBound(vParams)
      Fint.Parameters.Item(i + 1).Value = Trim$(vParams(i))
    Next
  End If
End Sub

Private Function GetNumericVal(ByVal Value As Variant) As Variant
  Select Case VarType(Value)
    Case VbVarType.vbByte, VbVarType.vbDecimal, VbVarType.vbDouble, VbVarType.vbDouble, _
         VbVarType.vbInteger, VbVarType.vbLong, VbVarType.vbSingle

      Dim DecimalDigit As Integer
      DecimalDigit = InStr(1, Value, ",", vbBinaryCompare)
      If DecimalDigit > 0 Then
        Value = Replace(Value, ",", ".")
      End If
  End Select
  
  GetNumericVal = Value
End Function

' construccion - destruccion
Private Sub Class_Initialize()
  Set m_FormulaTypes = New cReportFormulaTypes
  Set m_Variables = New cReportVariables
  Set m_ObjScript = New MSScriptControl.ScriptControl
  Set m_ObjGlobals = New cReportCompilerGlobals
  Set m_collTextReplace = New Collection
End Sub

Private Sub Class_Terminate()
  Set m_FormulaTypes = Nothing
  Set m_Report = Nothing
  Set m_Variables = Nothing
  Set m_ObjScript = Nothing
  Set m_ObjGlobals = Nothing
  Set m_collTextReplace = Nothing
End Sub
'//////////////////////////////
'  Codigo estandar de errores
'  On Error GoTo ControlError
'
'  GoTo ExitProc
'ControlError:
'  MngError err,"", C_Module, ""
'  If Err.Number Then Resume ExitProc
'ExitProc:
'  On Error Resume Next



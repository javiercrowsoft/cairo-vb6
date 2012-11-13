VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cCode"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' cCode
' 03-03-04

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
Private m_Compiler        As cReportCompiler
Private m_bCompile        As Boolean
Private m_Formula         As cReportFormula
Private m_IdxFormula      As Long
' eventos
' propiedades publicas
' propiedades privadas
' propiedades Friend
' funciones publicas
Public Function Compile(ByVal Code As String, ByRef MsgError As String, ByRef Compiler As cReportCompiler, ByVal bCompile As Boolean, ByRef Formula As cReportFormula) As Boolean
  Set m_Compiler = Compiler
  m_bCompile = bCompile
  Set m_Formula = Formula
  m_IdxFormula = 0
  Compile = pCompile(Code, MsgError, "")
End Function

' funciones privadas
Private Function pCompile(ByVal Code As String, ByRef MsgError As String, ByRef CodeC As String) As Boolean
  Dim nStart            As Long
  Dim CodeCallFunction  As String
  Dim CodeCallFunctionC As String
  Dim nLenCode          As Long
  Dim FunctionName      As String
  Dim Word              As String
  
  CodeC = ""
  
  nLenCode = Len(Code)
  nStart = 1
  Do
    Word = pGetWord(Code, nStart)
    If pIsFunction(Word, FunctionName) Then
      
      CodeCallFunction = pGetCallFunction(Code, nStart)
      
      If Not pCompile(CodeCallFunction, MsgError, CodeCallFunctionC) Then
        Exit Function
      End If
    
      CodeC = CodeC & pExecFunction(FunctionName, CodeCallFunctionC)
    Else
      CodeC = CodeC & Word
    End If
  Loop Until nStart > nLenCode
  
  pCompile = True
End Function

Private Function pGetWord(ByVal Code As String, ByRef nStart As Long) As String
  Dim c         As String
  Dim nLenCode  As Long
  Dim Word      As String
  
  nLenCode = Len(Code)
  
  c = Mid(Code, nStart, 1)
  Do
    Word = Word & c
    nStart = nStart + 1
    If pIsSeparator(c) Then Exit Do
    c = Mid(Code, nStart, 1)
  Loop Until pIsSeparator(c) Or nStart > nLenCode
  
  pGetWord = Word
End Function

Private Function pIsFunction(ByVal Word As String, ByRef FunctionName As String) As Boolean
  If Not m_Compiler.IsFunction(Word) Then Exit Function
  FunctionName = Word
  pIsFunction = True
End Function

Private Function pGetCallFunction(ByVal Code As String, ByRef nStart As Long) As String
  Dim c         As String
  Dim nLenCode  As Long
  Dim Word      As String
  Dim nInner    As Long
  
  nLenCode = Len(Code)
  nInner = -1
  
  Do
    c = Mid(Code, nStart, 1)
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

Private Function pIsSeparator(ByVal c As String) As Boolean
  pIsSeparator = InStr(1, " ,:+()/-*=" & vbCrLf, c) > 0
End Function

Private Function pExecFunction(ByVal FunctionName As String, ByVal Params As String) As String
  If m_bCompile Then
    pExecFunction = m_Compiler.AddFormulaInt(FunctionName, Params)
  Else
    Dim Fint As cReportFormulaInt
    m_IdxFormula = m_IdxFormula + 1
    Set Fint = m_Formula.FormulasInt.Item(m_IdxFormula)
    pSetParams Fint, Params
    m_Compiler.EvalFunctionInt Fint
    pExecFunction = m_Compiler.ResultFunctionInt(Fint)
  End If
End Function

Private Sub pSetParams(ByRef Fint As cReportFormulaInt, ByVal Params As String)
  Dim vParams As Variant
  Dim rtn     As String
  Dim i       As Long

  Params = Trim(Params)
  If Len(Params) > 2 Then
    Params = Mid(Params, 2, Len(Params) - 2)
    Params = Trim(Params)
    vParams = Split(Params, ",")
  End If
  
  For i = 0 To UBound(vParams)
    Fint.Parameters.Item(i + 1).Value = Trim(vParams(i))
  Next
End Sub

' funciones friend
' construccion - destruccion

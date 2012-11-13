VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Begin VB.Form F_Main 
   Appearance      =   0  'Flat
   BackColor       =   &H80000005&
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Ident"
   ClientHeight    =   4965
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   9420
   Icon            =   "Form1.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   Picture         =   "Form1.frx":08CA
   ScaleHeight     =   4965
   ScaleWidth      =   9420
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton CmdAbrir 
      Caption         =   "..."
      Height          =   330
      Left            =   8700
      Style           =   1  'Graphical
      TabIndex        =   4
      Top             =   3900
      Width           =   420
   End
   Begin MSComDlg.CommonDialog Dialog 
      Left            =   8340
      Top             =   660
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.CommandButton CmdCancelar 
      Caption         =   "Cancelar"
      Height          =   345
      Left            =   7740
      Style           =   1  'Graphical
      TabIndex        =   3
      Top             =   4440
      Width           =   1470
   End
   Begin VB.CommandButton CmdProcesar 
      Caption         =   "Procesar"
      Height          =   345
      Left            =   6180
      Style           =   1  'Graphical
      TabIndex        =   2
      Top             =   4440
      Width           =   1470
   End
   Begin VB.TextBox TxArchivo 
      Height          =   330
      Left            =   180
      TabIndex        =   0
      Top             =   3900
      Width           =   8490
   End
   Begin VB.Label Label1 
      BackStyle       =   0  'Transparent
      Caption         =   "Seleccione el archivo Archivo:"
      ForeColor       =   &H00000000&
      Height          =   240
      Left            =   180
      TabIndex        =   1
      Top             =   3600
      Width           =   4470
   End
   Begin VB.Label Label2 
      BackColor       =   &H00FFFFFF&
      Height          =   675
      Left            =   120
      TabIndex        =   5
      Top             =   3180
      Width           =   9075
   End
End
Attribute VB_Name = "F_Main"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'------------------------------------------------------------------------------------------------------------------------

Private Const SW_SHOWNORMAL = 1
Private Const ERROR_PATH_NOT_FOUND = 3&
Private Const ERROR_BAD_FORMAT = 11&
Private Const SE_ERR_ACCESSDENIED = 5            '  access denied
Private Const SE_ERR_ASSOCINCOMPLETE = 27
Private Const SE_ERR_DDEBUSY = 30
Private Const SE_ERR_DDEFAIL = 29
Private Const SE_ERR_DDETIMEOUT = 28
Private Const SE_ERR_DLLNOTFOUND = 32
Private Const SE_ERR_FNF = 2                     '  file not found
Private Const SE_ERR_NOASSOC = 31
Private Const SE_ERR_OOM = 8                     '  out of memory
Private Const SE_ERR_PNF = 3                     '  path not found
Private Const SE_ERR_SHARE = 26


Private Declare Function ShellExecute Lib "shell32.dll" Alias "ShellExecuteA" (ByVal hwnd As Long, ByVal lpOperation As String, ByVal lpFile As String, ByVal lpParameters As String, ByVal lpDirectory As String, ByVal nShowCmd As Long) As Long

'------------------------------------------------------------------------------------------------------------------------

Private m_Cancel As Boolean

Private Enum TipoSentencia
  TIniBloque = 1
  TElseBloque
  TFinBloque
  TAsignacionCall
  TLineaVacia
  TDimBloque
  TOnError
  TFailSafe
  TIniSub
End Enum

Private Sub CmdAbrir_Click()
  Dim f As clsFile
  
  Set f = New clsFile
  
  If Not f.OpenArchivoRead("", False, True, "Visual Basic Files|*.frm;*.bas;*.cls") Then Exit Sub
  
  TxArchivo.Text = f.FullFileName
End Sub

Private Sub CmdCancelar_Click()
  m_Cancel = True
End Sub

Private Sub CmdProcesar_Click()
  procesar
End Sub

Private Sub procesar()
  m_Cancel = False
  
  Dim f As clsFile
  Dim o As clsFile
  
  Dim s As String
  Dim iLeft As Integer
  
  Dim DimBloque  As Boolean
  Dim NuevaLinea As Boolean  ' La uso para saber si tengo que poner una linea en blanco
  
  Set f = New clsFile
  Set o = New clsFile
  
  If Not f.OpenArchivoRead(TxArchivo, True, False, "*.bas;*.cls;*.frm") Then Exit Sub
  If Not o.OpenArchivoWrite(Left(TxArchivo, Len(TxArchivo) - 4) + "I" + "." + Right(TxArchivo, 3) + ".TXT", True, True, True, True) Then Exit Sub
  
  If Not PrincipioArchivo(f, o) Then Exit Sub
  If Not o.WriteFileLine("") Then Exit Sub
    
  Dim Tipo As TipoSentencia
    
  While Not f.IsEof
    DoEvents
    If m_Cancel Then Exit Sub
    If Not f.ReadFileLine(s) Then Exit Sub
    
    Tipo = GetTipoSentencia(s)
    If Tipo <> TDimBloque Then
      If DimBloque Then
        If NuevaLinea Then
          If Not o.WriteFileLine("") Then Exit Sub
          NuevaLinea = False
        End If
      End If
      DimBloque = False
      
    End If
    
    Select Case Tipo
      Case TIniBloque, TIniSub
        If NuevaLinea Then If Not o.WriteFileLine("") Then Exit Sub
        If Not o.WriteFileLine(String(iLeft, " ") + Trim(s)) Then Exit Sub
        NuevaLinea = True
        iLeft = iLeft + 2
      
      Case TElseBloque
        iLeft = iLeft - 2
        If NuevaLinea Then If Not o.WriteFileLine("") Then Exit Sub
        If Not o.WriteFileLine(String(iLeft, " ") + Trim(s)) Then Exit Sub
        NuevaLinea = True
        iLeft = iLeft + 2
      
      Case TFinBloque
        iLeft = iLeft - 2
        If Not o.WriteFileLine(String(iLeft, " ") + Trim(s)) Then Exit Sub
        If Not o.WriteFileLine("") Then Exit Sub
        NuevaLinea = False
        
      Case TAsignacionCall
        If Not o.WriteFileLine(String(iLeft, " ") + Trim(s)) Then Exit Sub
        NuevaLinea = True
      Case TOnError
        If Not o.WriteFileLine(String(iLeft, " ") + Trim(s)) Then Exit Sub
        If Not o.WriteFileLine("") Then Exit Sub
        NuevaLinea = False
      Case TDimBloque
        
        If (Not DimBloque) And NuevaLinea Then If Not o.WriteFileLine("") Then Exit Sub
        DimBloque = True
        If Not o.WriteFileLine(String(iLeft, " ") + Trim(s)) Then Exit Sub
        NuevaLinea = True
        
      Case TLineaVacia
        
        If NuevaLinea Then If Not o.WriteFileLine("") Then Exit Sub
        NuevaLinea = False
      
      Case TFailSafe
        ' No hago nada
    End Select
    
  Wend
  
  EditarArchivo o.FullFileName, Me.hwnd
End Sub

Private Function GetTipoSentencia(ByVal s As String) As TipoSentencia
  
  s = UCase(Trim(s))
  If s = "" Then
    GetTipoSentencia = TLineaVacia
    Exit Function
  ElseIf Mid(s, 1, 3) = "IF " Then
    If Right(s, 5) = " THEN" Then
      GetTipoSentencia = TIniBloque
    Else
      Dim h As Integer
      Dim q As Integer
      
      h = InStr(1, s, " THEN ")
      
      If Right(s, 2) = " _" Then
        If Mid(s, Len(s) - 6, 5) <> " THEN" Then
          GetTipoSentencia = TIniBloque
          Exit Function
        End If
      End If
      
      If h > 0 Then
        h = h + 6
        q = Len(s)
        Do
          If Mid(s, h, 1) = "'" Then
            GetTipoSentencia = TIniBloque
            Exit Function
          End If
          
          If Mid(s, h, 1) <> " " Then Exit Do
          
          h = h + 1
        Loop Until h > q
      End If
      
      GetTipoSentencia = TAsignacionCall
    End If
    Exit Function
  ElseIf s = "ELSE" Then
    GetTipoSentencia = TElseBloque
    Exit Function
  ElseIf Mid(s, 1, 7) = "ELSEIF " Then
    GetTipoSentencia = TElseBloque
    Exit Function
  ElseIf Mid(s, 1, 4) = "FOR " Then
    GetTipoSentencia = TIniBloque
    Exit Function
  ElseIf Mid(s, 1, 5) = "NEXT " Then
    GetTipoSentencia = TFinBloque
    Exit Function
  ElseIf s = "NEXT" Then
    GetTipoSentencia = TFinBloque
    Exit Function
  ElseIf Mid(s, 1, 3) = "DO " Then
    GetTipoSentencia = TIniBloque
    Exit Function
  ElseIf s = "DO " Then
    GetTipoSentencia = TIniBloque
    Exit Function
  ElseIf Mid(s, 1, 5) = "LOOP " Then
    GetTipoSentencia = TFinBloque
    Exit Function
  ElseIf s = "LOOP" Then
    GetTipoSentencia = TFinBloque
    Exit Function
  ElseIf Mid(s, 1, 6) = "WHILE " Then
    GetTipoSentencia = TIniBloque
    Exit Function
  ElseIf s = "WEND" Then
    GetTipoSentencia = TFinBloque
    Exit Function
  ElseIf Mid(s, 1, 8) = "ON ERROR" Then
    GetTipoSentencia = TOnError
    Exit Function
  ElseIf Mid(s, 1, 4) = "DIM " Then
    GetTipoSentencia = TDimBloque
    Exit Function
  ElseIf Mid(s, 1, 8) = "PRIVATE " Then
    If Mid(s, 9, 9) = "FUNCTION " Then
      GetTipoSentencia = TIniSub
    ElseIf Mid(s, 9, 4) = "SUB " Then
      GetTipoSentencia = TIniSub
    ElseIf Mid(s, 9, 5) = "TYPE " Then
      GetTipoSentencia = TIniBloque
    Else
      GetTipoSentencia = TDimBloque
    End If
    Exit Function
  ElseIf Mid(s, 1, 4) = "SUB " Then
    GetTipoSentencia = TIniBloque
    Exit Function
  ElseIf Mid(s, 1, 9) = "FUNCTION " Then
    GetTipoSentencia = TIniBloque
    Exit Function
  ElseIf Mid(s, 1, 7) = "PUBLIC " Then
    If Mid(s, 8, 9) = "FUNCTION " Then
      GetTipoSentencia = TIniSub
    ElseIf Mid(s, 8, 4) = "SUB " Then
      GetTipoSentencia = TIniSub
    ElseIf Mid(s, 8, 5) = "TYPE " Then
      GetTipoSentencia = TIniBloque
    Else
      GetTipoSentencia = TDimBloque
    End If
    Exit Function
  ElseIf Mid(s, 1, 7) = "END SUB" Then
    GetTipoSentencia = TFinBloque
    Exit Function
  ElseIf Mid(s, 1, 8) = "END TYPE" Then
    GetTipoSentencia = TFinBloque
    Exit Function
  ElseIf Mid(s, 1, 12) = "END FUNCTION" Then
    GetTipoSentencia = TFinBloque
    Exit Function
  ElseIf Mid(s, 1, 6) = "END IF" Then
    GetTipoSentencia = TFinBloque
    Exit Function
  ElseIf Mid(s, 1, 11) = "SELECT CASE" Then
    GetTipoSentencia = TIniBloque
    Exit Function
  ElseIf Mid(s, 1, 5) = "CASE " Then
    GetTipoSentencia = TElseBloque
    Exit Function
  ElseIf Mid(s, 1, 10) = "END SELECT" Then
    GetTipoSentencia = TFinBloque
    Exit Function
  ElseIf s = "'*** START FAILSAFE ***" Then
    GetTipoSentencia = TFailSafe
    Exit Function
  ElseIf s = "'*** STOP FAILSAFE ********************************************************************************************************************************" Then
    GetTipoSentencia = TFailSafe
    Exit Function
  ElseIf s = "'*** START FAILSAFE ********************************************************************************************************************************" Then
    GetTipoSentencia = TFailSafe
    Exit Function
  ElseIf s = "'*** STOP FAILSAFE ***" Then
    GetTipoSentencia = TFailSafe
    Exit Function
  ElseIf Mid(s, 1, 5) = "TYPE " Then
    GetTipoSentencia = TIniBloque
  Else
    GetTipoSentencia = TAsignacionCall
    Exit Function
  End If
End Function

Private Function PrincipioArchivo(ByRef f As clsFile, ByRef o As clsFile) As Boolean
  Dim s As String
  Dim sFile As String
  
  sFile = f.FileName
  sFile = UCase(sFile)
  Select Case Right(sFile, 3)
    Case "FRM", "CLS"
      While Not f.IsEof
        DoEvents
        If m_Cancel Then Exit Function
        If Not f.ReadFileLine(s) Then Exit Function
        If Not o.WriteFileLine(s) Then Exit Function
        s = UCase(s)
        If Left(s, 3) = "END" Then
          While Not f.IsEof
            DoEvents
            If m_Cancel Then Exit Function
            If Not f.ReadFileLine(s) Then Exit Function
            If Not o.WriteFileLine(s) Then Exit Function
            s = UCase(s)
            If Left(s, 9) <> "ATTRIBUTE" Then
              GoTo Listo
            End If
          Wend
        End If
      Wend
    Case "BAS"
      While Not f.IsEof
        DoEvents
        If m_Cancel Then Exit Function
        If Not f.ReadFileLine(s) Then Exit Function
        If Not o.WriteFileLine(s) Then Exit Function
        s = UCase(s)
        If Left(s, 9) <> "ATTRIBUTE" Then
          GoTo Listo
        End If
      Wend
  End Select
  
  Exit Function
  
Listo:
  PrincipioArchivo = True
End Function

Private Sub EditarArchivo(ByVal sArchivo As String, ByVal hwnd As Long)
  Dim Hresult As Long
  
  
  Hresult = ShellExecute(hwnd, "open", sArchivo + Chr(0), 0, sArchivo + Chr(0), SW_SHOWNORMAL)
  
  Select Case Hresult
    Case ERROR_PATH_NOT_FOUND '= 3&
        MsgBox "La ruta de acceso no se encuentra"
    Case ERROR_BAD_FORMAT '= 11&
        MsgBox "Formato no reconocido"
    Case SE_ERR_ACCESSDENIED '= 5 '  access denied
        MsgBox "Error a intentar acceder al archivo. Acceso Denegado."
    Case SE_ERR_ASSOCINCOMPLETE '= 27
        MsgBox "Acceso Incompleto"
    Case SE_ERR_DDEBUSY '= 30
        
    Case SE_ERR_DDEFAIL '= 29
        MsgBox "Falla al intentar editar el archivo"
    Case SE_ERR_DDETIMEOUT '= 28
        
    Case SE_ERR_DLLNOTFOUND '= 32
        MsgBox "El archivo no se encuentra"
    Case SE_ERR_FNF '= 2                     '  file not found
        MsgBox "Archivo no encontrado"
    Case SE_ERR_NOASSOC '= 31
    Case SE_ERR_OOM '= 8                     '  out of memory
        MsgBox "Error de Memoria "
    Case SE_ERR_PNF '= 3                     '  path not found
        MsgBox "La ruta de acceso no se encuentra"
    Case SE_ERR_SHARE '= 26
        
  End Select
End Sub


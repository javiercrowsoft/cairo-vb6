VERSION 5.00
Begin VB.Form fTaskCommandScript 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Tarea"
   ClientHeight    =   5730
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   7275
   Icon            =   "fTaskCommandScript.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   5730
   ScaleWidth      =   7275
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox txName 
      Height          =   300
      Left            =   1125
      TabIndex        =   1
      Top             =   90
      Width           =   4335
   End
   Begin VB.ComboBox cbType 
      Height          =   315
      Left            =   1530
      Style           =   2  'Dropdown List
      TabIndex        =   7
      Top             =   1080
      Width           =   2370
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "&Aceptar"
      Height          =   330
      Left            =   4455
      TabIndex        =   6
      Top             =   5310
      Width           =   1275
   End
   Begin VB.CommandButton cmdCancel 
      Caption         =   "&Cancelar"
      Height          =   330
      Left            =   5940
      TabIndex        =   5
      Top             =   5310
      Width           =   1275
   End
   Begin VB.TextBox txScript 
      Height          =   3660
      Left            =   90
      MultiLine       =   -1  'True
      ScrollBars      =   3  'Both
      TabIndex        =   4
      Top             =   1530
      Width           =   7080
   End
   Begin VB.ComboBox cbDataBases 
      Height          =   315
      Left            =   1515
      Style           =   2  'Dropdown List
      TabIndex        =   2
      Top             =   675
      Width           =   4035
   End
   Begin VB.Line Line2 
      BorderColor     =   &H80000014&
      X1              =   0
      X2              =   8000
      Y1              =   555
      Y2              =   555
   End
   Begin VB.Line Line1 
      BorderColor     =   &H80000010&
      X1              =   0
      X2              =   8000
      Y1              =   540
      Y2              =   540
   End
   Begin VB.Label Label6 
      Caption         =   "Nombre :"
      Height          =   330
      Left            =   135
      TabIndex        =   0
      Top             =   90
      Width           =   825
   End
   Begin VB.Label Label2 
      Caption         =   "Tipo de comando :"
      Height          =   255
      Left            =   135
      TabIndex        =   8
      Top             =   1095
      Width           =   1365
   End
   Begin VB.Label Label1 
      Caption         =   "Base de datos :"
      Height          =   255
      Left            =   135
      TabIndex        =   3
      Top             =   690
      Width           =   1140
   End
End
Attribute VB_Name = "fTaskCommandScript"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' fTaskCommandScript
' 25-05-2002

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "fTaskCommandScript"

' estructuras
' variables privadas
Private m_CmdScript         As cSQLTaskCommandScript
Private m_SQLServer         As cSQLServer
Private m_Ok                As Boolean
' eventos
' propiedadades publicas
Public Property Get Ok() As Boolean
  Ok = m_Ok
End Property

Public Property Set SQLServer(ByRef rhs As cSQLServer)
  Set m_SQLServer = rhs
End Property

Public Property Set CmdScript(ByRef rhs As cSQLTaskCommandScript)
  Set m_CmdScript = rhs
End Property

Public Property Get CmdScript() As cSQLTaskCommandScript
  Set CmdScript = m_CmdScript
End Property
' propiedadades friend
' propiedades privadas
' funciones publicas
' funciones friend
' funciones privadas
Private Sub LoadDataBases()
  On Error GoTo ControlError
  
  Dim o As cListDataBaseInfo
  Dim coll As Collection
  
  Set coll = m_SQLServer.ListDataBases()
  
  cbDataBases.Clear
  
  For Each o In coll
    cbDataBases.AddItem o.Name
  Next
  
  cbDataBases.ListIndex = 0
  
  GoTo ExitProc
ControlError:
  MngError Err, "LoadDataBases", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub cmdOk_Click()
  On Error GoTo ControlError

  Dim DataBase    As String
  Dim Script      As String
  Dim CmdType     As csSchCommandScriptType
  
  DataBase = cbDataBases.Text
  Script = txScript.Text
  
  CmdType = GetItemData(cbType)
  
  If Script = "" Then
    info "Debe indicar una sentencia sql o un comando del sistema operativo"
    SetFocusControl txScript
    Exit Sub
  End If
  

  m_CmdScript.DataBase = DataBase
  m_CmdScript.CmdType = CmdType
  m_CmdScript.Command = Script
  
  m_Ok = True
  
  Me.Hide

  GoTo ExitProc
ControlError:
  MngError Err, "cmdOk_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub cmdCancel_Click()
  On Error Resume Next
  Me.Hide
End Sub

Private Sub ShowData()
  SelectItemByText cbDataBases, m_CmdScript.DataBase
  txName.Text = m_CmdScript.Name
  txScript.Text = m_CmdScript.Command
End Sub
' construccion - destruccion
Private Sub Form_Load()
  On Error GoTo ControlError
  
  LoadDataBases
  
  AddItemToList cbType, "Sentencia SQL", csSchCommandScriptType.csSchCmdScrpTypeSqlCommand
  AddItemToList cbType, "Comando del sistema operativo", csSchCommandScriptType.csSchCmdScrpTypeOSCommand
  SelectItemByItemData cbType, csSchCommandScriptType.csSchCmdScrpTypeSqlCommand
  
  ShowData
  
  FormCenter Me

  GoTo ExitProc
ControlError:
  MngError Err, "Form_Load", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
  If UnloadMode <> vbFormCode Then
    Cancel = True
    m_Ok = False
    Me.Hide
  End If
End Sub

Private Sub Form_Unload(Cancel As Integer)
  On Error GoTo ControlError
  
  Set m_SQLServer = Nothing
  Set m_CmdScript = Nothing
  
  GoTo ExitProc
ControlError:
  MngError Err, "Form_Unload", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
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




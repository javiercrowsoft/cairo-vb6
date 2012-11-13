VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   8985
   ClientLeft      =   60
   ClientTop       =   375
   ClientWidth     =   8805
   LinkTopic       =   "Form1"
   ScaleHeight     =   8985
   ScaleWidth      =   8805
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton Command15 
      Caption         =   "Ventana sql"
      Height          =   330
      Left            =   3690
      TabIndex        =   24
      Top             =   1530
      Width           =   2535
   End
   Begin VB.CommandButton Command14 
      Caption         =   "Borrar"
      Height          =   330
      Left            =   8010
      TabIndex        =   23
      Top             =   3465
      Width           =   735
   End
   Begin VB.CommandButton Command13 
      Caption         =   "Editar script batch"
      Height          =   330
      Left            =   6660
      TabIndex        =   22
      Top             =   675
      Width           =   2040
   End
   Begin VB.CommandButton Command12 
      Caption         =   "Crear DB"
      Height          =   330
      Left            =   6660
      TabIndex        =   21
      Top             =   135
      Width           =   2040
   End
   Begin VB.CommandButton Command11 
      Caption         =   "Guardar"
      Height          =   330
      Left            =   90
      TabIndex        =   20
      Top             =   7740
      Width           =   735
   End
   Begin VB.TextBox Text5 
      Height          =   330
      Left            =   900
      TabIndex        =   19
      Text            =   "D:\Proyectos\CSTools\Test\bkplog.task"
      Top             =   7335
      Width           =   7080
   End
   Begin VB.CommandButton Command10 
      Caption         =   "Agregar"
      Height          =   330
      Left            =   90
      TabIndex        =   18
      Top             =   7335
      Width           =   735
   End
   Begin VB.CommandButton Command9 
      Caption         =   "Ini"
      Height          =   330
      Left            =   8010
      TabIndex        =   17
      Top             =   3960
      Width           =   735
   End
   Begin VB.TextBox Text4 
      Height          =   1365
      Left            =   90
      MultiLine       =   -1  'True
      ScrollBars      =   3  'Both
      TabIndex        =   16
      Text            =   "Form1.frx":0000
      Top             =   5850
      Width           =   7845
   End
   Begin VB.CommandButton Command8 
      Caption         =   "Agregar"
      Height          =   330
      Left            =   8010
      TabIndex        =   15
      Top             =   2655
      Width           =   735
   End
   Begin VB.CommandButton Command7 
      Caption         =   "Edit"
      Height          =   330
      Left            =   8010
      TabIndex        =   14
      Top             =   3060
      Width           =   735
   End
   Begin VB.CommandButton Command6 
      Caption         =   "List Task"
      Height          =   330
      Left            =   4590
      TabIndex        =   13
      Top             =   2250
      Width           =   2535
   End
   Begin VB.ListBox List2 
      Height          =   2985
      Left            =   4140
      TabIndex        =   12
      Top             =   2655
      Width           =   3795
   End
   Begin VB.CommandButton Command5 
      Caption         =   "Tareas"
      Height          =   330
      Left            =   3690
      TabIndex        =   11
      Top             =   1080
      Width           =   2535
   End
   Begin VB.CommandButton Command4 
      Caption         =   "Restore"
      Height          =   330
      Left            =   3690
      TabIndex        =   10
      Top             =   585
      Width           =   2535
   End
   Begin VB.CommandButton Command3 
      Caption         =   "Backup"
      Height          =   330
      Left            =   3690
      TabIndex        =   9
      Top             =   135
      Width           =   2535
   End
   Begin VB.CommandButton Command2 
      Caption         =   "List DataBases"
      Height          =   330
      Left            =   1035
      TabIndex        =   8
      Top             =   2250
      Width           =   2535
   End
   Begin VB.ListBox List1 
      Height          =   2985
      Left            =   90
      TabIndex        =   7
      Top             =   2655
      Width           =   3795
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Connect"
      Height          =   330
      Left            =   1035
      TabIndex        =   6
      Top             =   1620
      Width           =   2535
   End
   Begin VB.TextBox Text3 
      Height          =   330
      Left            =   1035
      TabIndex        =   4
      Top             =   1035
      Width           =   2490
   End
   Begin VB.TextBox Text2 
      Height          =   330
      Left            =   1035
      TabIndex        =   2
      Text            =   "sa"
      Top             =   600
      Width           =   2490
   End
   Begin VB.TextBox Text1 
      Height          =   330
      Left            =   1035
      TabIndex        =   0
      Text            =   "Mesalina"
      Top             =   135
      Width           =   2490
   End
   Begin VB.Label Label3 
      Caption         =   "Password:"
      Height          =   375
      Left            =   45
      TabIndex        =   5
      Top             =   1035
      Width           =   825
   End
   Begin VB.Label Label2 
      Caption         =   "User:"
      Height          =   375
      Left            =   45
      TabIndex        =   3
      Top             =   585
      Width           =   825
   End
   Begin VB.Label Label1 
      Caption         =   "Server:"
      Height          =   375
      Left            =   45
      TabIndex        =   1
      Top             =   135
      Width           =   825
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private m_SQLServer As cSQLServer

Private Sub Command1_Click()
  m_SQLServer.OpenConnection Text1.Text, Text2.Text, Text3.Text
End Sub

Private Sub Command10_Click()
  Dim Task As cSQLTask
  Set Task = m_SQLServer.LoadTaskFromIni(Text5.Text)
  m_SQLServer.EditTaskOjb Task
  
End Sub

Private Sub Command11_Click()
  Dim Task As cSQLTask
  Set Task = m_SQLServer.GetTask(List2.Text)
  Task.SaveScript Text5.Text
End Sub

Private Sub Command12_Click()
  m_SQLServer.CreateDataBaseWithWizard "", "D:\Proyectos\CSTools\Test\script1.srp", , "D:\Proyectos\CSTools\Test\def_script.spr", True
End Sub

Private Sub Command13_Click()
  m_SQLServer.EditDefScriptIni "D:\Proyectos\CSTools\Test\def_script.spr"
End Sub

Private Sub Command14_Click()
  m_SQLServer.DeleteTask List2.Text
  Command6_Click
End Sub

Private Sub Command15_Click()
  m_SQLServer.EditScript
End Sub

Private Sub Command2_Click()
  Dim o As cListDataBaseInfo
  Dim Coll As Collection
  
  Set Coll = m_SQLServer.ListDataBases()
  
  List1.Clear
  
  For Each o In Coll
    List1.AddItem o.Name
  Next
End Sub

Private Sub Command3_Click()
  m_SQLServer.ShowBackup "", False
End Sub

Private Sub Command4_Click()
  m_SQLServer.ShowRestore "", False, False
End Sub

Private Sub Command5_Click()
  m_SQLServer.CreateTask
End Sub

Private Sub Command6_Click()
  Dim o As cListTaskInfo
  Dim Coll As Collection
  
  Set Coll = m_SQLServer.ListTasks()
  
  List2.Clear
  
  For Each o In Coll
    List2.AddItem o.Name
  Next
End Sub

Private Sub Command7_Click()
  m_SQLServer.EditTask List2.Text
  Command6_Click
End Sub

Private Sub Command8_Click()
  If Not m_SQLServer.CreateTask() Then Exit Sub
  Command6_Click
End Sub

Private Sub Command9_Click()
  Text4.Text = m_SQLServer.GetTaskScript(List2.Text)
End Sub

Private Sub Form_Load()
  Set m_SQLServer = New cSQLServer
  m_SQLServer.Init App.Path
End Sub

Private Sub Form_Unload(Cancel As Integer)
  Set m_SQLServer = Nothing
End Sub

VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Begin VB.Form fMainMdi 
   Caption         =   "CSBackup"
   ClientHeight    =   3795
   ClientLeft      =   165
   ClientTop       =   855
   ClientWidth     =   7065
   Icon            =   "fMain.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   3795
   ScaleWidth      =   7065
   StartUpPosition =   3  'Windows Default
   Begin MSComctlLib.StatusBar stbMain 
      Align           =   2  'Align Bottom
      Height          =   255
      Left            =   0
      TabIndex        =   0
      Top             =   3540
      Width           =   7065
      _ExtentX        =   12462
      _ExtentY        =   450
      _Version        =   393216
      BeginProperty Panels {8E3867A5-8586-11D1-B16A-00C0F0283628} 
         NumPanels       =   1
         BeginProperty Panel1 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
         EndProperty
      EndProperty
   End
   Begin VB.Menu mnuFile 
      Caption         =   "&Archivo"
      Begin VB.Menu mnuExit 
         Caption         =   "&Salir"
      End
   End
   Begin VB.Menu mnuTask 
      Caption         =   "&Tareas"
      Begin VB.Menu mnuTaskNew 
         Caption         =   "&Nueva ..."
      End
      Begin VB.Menu mnuTaskEdit 
         Caption         =   "&Editar ..."
      End
      Begin VB.Menu mnuTaskDelete 
         Caption         =   "&Borrar"
      End
   End
   Begin VB.Menu mnuSchedule 
      Caption         =   "&Programaciones"
      Begin VB.Menu mnuScheduleNew 
         Caption         =   "&Nueva ..."
      End
      Begin VB.Menu mnuScheduleEdit 
         Caption         =   "&Editar ..."
      End
      Begin VB.Menu mnuScheduleDelete 
         Caption         =   "&Borrar"
      End
   End
   Begin VB.Menu mnuSQLServer 
      Caption         =   "&SQL Server"
      Begin VB.Menu mnuSQLServerNewTask 
         Caption         =   "&Nueva Tarea de Backup ..."
      End
      Begin VB.Menu mnuSQLServerEditTask 
         Caption         =   "&Editar Tarea de Backup ..."
      End
   End
   Begin VB.Menu mnuTools 
      Caption         =   "&Herramientas"
      Begin VB.Menu mnuBackup 
         Caption         =   "&Tareas en Ejecución..."
      End
      Begin VB.Menu mnuToolsSep 
         Caption         =   "-"
      End
      Begin VB.Menu mnuPreferences 
         Caption         =   "&Opciones ..."
      End
   End
   Begin VB.Menu mnuHelp 
      Caption         =   "A&yuda"
      Begin VB.Menu mnuHelpIndex 
         Caption         =   "&Indice"
         Shortcut        =   {F1}
      End
      Begin VB.Menu mnuAbout 
         Caption         =   "&Acerca de..."
      End
   End
End
Attribute VB_Name = "fMainMdi"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

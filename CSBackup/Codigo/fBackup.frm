VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Object = "{48E59290-9880-11CF-9754-00AA00C00908}#1.0#0"; "MSINET.OCX"
Begin VB.Form fBackup 
   Caption         =   "fBackup"
   ClientHeight    =   7470
   ClientLeft      =   60
   ClientTop       =   750
   ClientWidth     =   9270
   Icon            =   "fBackup.frx":0000
   LinkTopic       =   "Form1"
   MDIChild        =   -1  'True
   ScaleHeight     =   7470
   ScaleWidth      =   9270
   Begin InetCtlsObjects.Inet Inet1 
      Left            =   7380
      Top             =   4440
      _ExtentX        =   1005
      _ExtentY        =   1005
      _Version        =   393216
   End
   Begin VB.PictureBox picStatus 
      AutoRedraw      =   -1  'True
      BackColor       =   &H00FFFFFF&
      BorderStyle     =   0  'None
      ClipControls    =   0   'False
      FillColor       =   &H0080C0FF&
      Height          =   280
      Left            =   80
      ScaleHeight     =   285
      ScaleWidth      =   7260
      TabIndex        =   5
      TabStop         =   0   'False
      Top             =   7040
      Width           =   7260
   End
   Begin MSComctlLib.ImageList ImageList1 
      Left            =   5820
      Top             =   4380
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483643
      ImageWidth      =   16
      ImageHeight     =   16
      MaskColor       =   12632256
      UseMaskColor    =   0   'False
      _Version        =   393216
      BeginProperty Images {2C247F25-8591-11D1-B16A-00C0F0283628} 
         NumListImages   =   2
         BeginProperty ListImage1 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fBackup.frx":1042
            Key             =   ""
         EndProperty
         BeginProperty ListImage2 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fBackup.frx":13DC
            Key             =   ""
         EndProperty
      EndProperty
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "&Cancelar"
      Height          =   315
      Left            =   7500
      TabIndex        =   2
      Top             =   7020
      Width           =   1575
   End
   Begin VB.Timer tmBackup 
      Left            =   4380
      Top             =   4500
   End
   Begin MSComctlLib.ListView lvTask 
      Height          =   1335
      Left            =   0
      TabIndex        =   0
      Top             =   2340
      Width           =   9255
      _ExtentX        =   16325
      _ExtentY        =   2355
      LabelWrap       =   -1  'True
      HideSelection   =   0   'False
      _Version        =   393217
      ForeColor       =   -2147483640
      BackColor       =   -2147483643
      BorderStyle     =   1
      Appearance      =   1
      NumItems        =   0
   End
   Begin MSComctlLib.ListView lvProgress 
      Height          =   3195
      Left            =   0
      TabIndex        =   1
      Top             =   3660
      Width           =   9255
      _ExtentX        =   16325
      _ExtentY        =   5636
      LabelWrap       =   -1  'True
      HideSelection   =   -1  'True
      _Version        =   393217
      ForeColor       =   -2147483640
      BackColor       =   -2147483643
      BorderStyle     =   1
      Appearance      =   1
      NumItems        =   0
   End
   Begin MSComctlLib.ListView lvSchedule 
      Height          =   1395
      Left            =   0
      TabIndex        =   4
      Top             =   960
      Width           =   9255
      _ExtentX        =   16325
      _ExtentY        =   2461
      LabelWrap       =   -1  'True
      HideSelection   =   0   'False
      _Version        =   393217
      ForeColor       =   -2147483640
      BackColor       =   -2147483643
      BorderStyle     =   1
      Appearance      =   1
      NumItems        =   0
   End
   Begin VB.Shape Shape5 
      BorderColor     =   &H0080C0FF&
      Height          =   315
      Left            =   60
      Top             =   7020
      Width           =   7290
   End
   Begin VB.Image Image1 
      Height          =   780
      Left            =   0
      Picture         =   "fBackup.frx":1976
      Top             =   60
      Width           =   750
   End
   Begin VB.Label Label1 
      BackStyle       =   0  'Transparent
      Caption         =   "Proceso de Tareas de Backup"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   13.5
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   615
      Left            =   900
      TabIndex        =   3
      Top             =   300
      UseMnemonic     =   0   'False
      Width           =   4935
   End
   Begin VB.Line Line2 
      BorderColor     =   &H80000014&
      X1              =   0
      X2              =   11000
      Y1              =   6915
      Y2              =   6915
   End
   Begin VB.Line Line1 
      BorderColor     =   &H80000010&
      X1              =   0
      X2              =   11000
      Y1              =   6900
      Y2              =   6900
   End
   Begin VB.Shape Shape1 
      BackColor       =   &H00FFFFFF&
      BackStyle       =   1  'Opaque
      BorderStyle     =   0  'Transparent
      Height          =   975
      Left            =   0
      Top             =   0
      Width           =   9285
   End
   Begin VB.Menu mnuFile 
      Caption         =   "&Archivo"
      Begin VB.Menu mnuExit 
         Caption         =   "&Salir"
      End
   End
   Begin VB.Menu mnuView 
      Caption         =   "&Ver"
      Begin VB.Menu mnuConfig 
         Caption         =   "&Configuración"
      End
      Begin VB.Menu mnuMonitor 
         Caption         =   "&Tareas en Ejecución"
         Checked         =   -1  'True
      End
   End
   Begin VB.Menu popTask 
      Caption         =   "popTask"
      Visible         =   0   'False
      Begin VB.Menu popExecute 
         Caption         =   "Execute"
      End
   End
   Begin VB.Menu popSchedule 
      Caption         =   "popSchedule"
      Visible         =   0   'False
      Begin VB.Menu popExecuteSchedule 
         Caption         =   "Execute"
      End
   End
   Begin VB.Menu mnuHelp 
      Caption         =   "&Ayuda"
      Begin VB.Menu mnuHelpIndex 
         Caption         =   "&Indice"
         Shortcut        =   {F1}
      End
      Begin VB.Menu mnuHelpAbout 
         Caption         =   "&Acerca de CSBackup ..."
      End
   End
End
Attribute VB_Name = "fBackup"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private WithEvents m_cZ As cZip
Attribute m_cZ.VB_VarHelpID = -1

Private m_FileCount     As Long
Private m_IdxFile       As Long
Private m_Multizip      As Long
Private m_cancel        As Boolean
Private m_IndexMsg      As Long
Private m_zipFileName   As String
Private m_vMultiZips()  As String

Public Sub ReLoad()
  LoadSchedule lvSchedule
  LoadTask lvTask
  pUnSelectTask
End Sub

Private Sub cmdCancel_Click()
  If Ask("¿Confirma que desea cancelar el proceso?", vbNo) Then
    m_cancel = True
  End If
End Sub

Private Sub Form_Load()
  cmdCancel.Enabled = False

  With lvSchedule
    .View = lvwReport
    .GridLines = True
    .LabelEdit = lvwManual
    .FullRowSelect = True
    .BorderStyle = ccNone
    .SmallIcons = ImageList1
  End With
  
  LoadSchedule lvSchedule

  With lvTask
    .View = lvwReport
    .GridLines = True
    .LabelEdit = lvwManual
    .FullRowSelect = True
    .BorderStyle = ccNone
    .SmallIcons = ImageList1
    .MultiSelect = False
  End With
  
  LoadTask lvTask
  pUnSelectTask
  
  With lvProgress
    .View = lvwReport
    .GridLines = True
    .LabelEdit = lvwManual
    .FullRowSelect = True
    .BorderStyle = ccNone
    .SmallIcons = ImageList1
  End With
  
  With lvProgress.ColumnHeaders
    .Clear
    .Add , , "Info", 9000
  End With
  
  ReDim m_vMultiZips(0)
  
  ' 30 segundos
  tmBackup.Interval = 30000
End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
  If NotUnloadFromAppOrWindows(UnloadMode) Then
    Cancel = True
  End If
End Sub

Private Sub Form_Unload(Cancel As Integer)
  On Error GoTo ControlError
  
  Set m_cZ = Nothing
  ReDim m_vMultiZips(0)

  GoTo ExitProc
ControlError:
  pLogError Err.Description
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub lvSchedule_MouseUp(Button As Integer, Shift As Integer, x As Single, y As Single)
  On Error GoTo ControlError
  
  If lvSchedule.SelectedItem Is Nothing Then Exit Sub
  
  PopupMenu popSchedule

  GoTo ExitProc
ControlError:
  pLogError Err.Description
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub lvTask_MouseUp(Button As Integer, Shift As Integer, x As Single, y As Single)
  On Error GoTo ControlError
  
  If lvTask.SelectedItem Is Nothing Then Exit Sub
  
  PopupMenu popTask

  GoTo ExitProc
ControlError:
  pLogError Err.Description
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub mnuExit_Click()
  fMainMDI.CloseProgram
End Sub

Private Sub mnuHelpAbout_Click()
  fMainMDI.ShowAbout
End Sub

Private Sub mnuHelpIndex_Click()
  fMainMDI.ShowHelp
End Sub

Private Sub popExecute_Click()
  On Error GoTo ControlError
  
  m_cancel = False
  cmdCancel.Enabled = True
  tmBackup.Enabled = False
  
  pProcessTask lvTask.SelectedItem.SubItems(1)

  GoTo ExitProc
ControlError:
  pLogError Err.Description
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next

  tmBackup.Enabled = True
  cmdCancel.Enabled = False
End Sub

Private Sub popExecuteSchedule_Click()
  On Error GoTo ControlError
  
  Dim ScheduleFile As String
  
  m_cancel = False
  cmdCancel.Enabled = True
  tmBackup.Enabled = False
  
  ScheduleFile = lvSchedule.SelectedItem.SubItems(1)
    
  pProcessSechedule ScheduleFile

  GoTo ExitProc
ControlError:
  pLogError Err.Description
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next

  tmBackup.Enabled = True
  cmdCancel.Enabled = False
End Sub

Private Sub tmBackup_Timer()
  On Error GoTo ControlError
  
  m_cancel = False
  cmdCancel.Enabled = True
  tmBackup.Enabled = False
  
  pProcessTimer
  
  GoTo ExitProc
ControlError:
  pLogError Err.Description
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
  tmBackup.Enabled = True
  cmdCancel.Enabled = False
End Sub

Private Sub pLogError(ByVal msg As String)
  Dim f As Integer
  f = FreeFile
  Open FileGetValidPath(App.Path) & LOG_NAME For Append Access Write Shared As #f
  Print #f, Format(Now, "dd/mm/yy hh:nn:ss   ") & msg
  Close f
End Sub

Private Sub pProcessTimer()
  Dim i As Long
  Dim ScheduleFile As String
  
  For i = 1 To lvSchedule.ListItems.Count
  
    ScheduleFile = lvSchedule.ListItems.Item(i).SubItems(1)
    
    If pIsTimeToExecute(ScheduleFile) Then
    
      pProcessSechedule ScheduleFile
    
    End If
  Next
End Sub

Private Function pIsTimeToExecute(ByVal ScheduleFile As String) As Boolean
  
  Dim Schedule As cSchedule
  Set Schedule = New cSchedule
  
  Dim strError As String
  Dim NextRun  As Date
  
  If Not Schedule.Load(ScheduleFile, True, strError) Then
  
    pAddToLog "No se pudo cargar la programación [" & ScheduleFile & "]"
    pAddToLog "Error: " & strError
    Exit Function
  End If
  
  Dim bIsTime As Boolean
  Dim bIsDay  As Boolean
  
  With Schedule
    
    If .RunType = csSchRunTypeOnce Then
      
      Dim EmptyDate As Date
      
      If .LastRun = EmptyDate Then
        bIsTime = .Time <= Now
        bIsDay = bIsTime
      End If
      
    Else
        
'                           (RPrg_TimeType = @csSchTypeTimeRecurring
      If .TimeType = csSchTimeTypeRecurring Then
      
'                             and (     (RPrg_RunEachType = @csSchEachTypeHour
        If .RunEachType = csSchEachTypeHour Then
'                                         and   datepart(hh,dateadd(hh,RPrg_RunEach,RPrg_lastRun))*100
'                                             + datepart(n,dateadd(hh,RPrg_RunEach,RPrg_lastRun))
'                                             <=
'                                               datepart(hh,@hora)*100
'                                             + datepart(n,@hora)
'                                       )
          If .FirtsRunStartAt <= Now Then

            If .LastRunEndAt >= Now Then
            
              If Hour(.TimeStart) * 100 + Minute(.TimeStart) _
                 <= Hour(Now) * 100 + Minute(Now) Then
                              
                If Hour(.TimeEnd) * 100 + Minute(.TimeEnd) _
                   >= Hour(Now) * 100 + Minute(Now) Then
                  
                  NextRun = DateAdd("h", .RunEach, .LastRun)
                  
                  If Hour(NextRun) * 100 + Minute(NextRun) _
                     <= Hour(Now) * 100 + Minute(Now) Then
                                  
                    bIsTime = True
                  
                  End If
                End If
              End If
            End If
          End If
'                                   or  (RPrg_RunEachType = @csSchEachTypeMinute
        ElseIf .RunEachType = csSchEachTypeMinute Then
        
'                                         and   datepart(hh,dateadd(n,RPrg_RunEach,RPrg_lastRun))*100
'                                             + datepart(n,dateadd(n,RPrg_RunEach,RPrg_lastRun))
'                                             <=
'                                               datepart(hh,@hora)*100
'                                             + datepart(n,@hora)
'                                       )
'                                 )
'                           )
          
          If .FirtsRunStartAt <= Now Then

            If .LastRunEndAt >= Now Then
            
              If Hour(.TimeStart) * 100 + Minute(.TimeStart) _
                 <= Hour(Now) * 100 + Minute(Now) Then
                              
                If Hour(.TimeEnd) * 100 + Minute(.TimeEnd) _
                   >= Hour(Now) * 100 + Minute(Now) Then
                  
                  NextRun = DateAdd("n", .RunEach, .LastRun)
                  
                  If Hour(NextRun) * 100 + Minute(NextRun) _
                     <= Hour(Now) * 100 + Minute(Now) Then
                                  
                    bIsTime = True
                  
                  End If
                End If
              End If
            End If
          End If
          
        End If
      
      ElseIf .TimeType = csSchTimeTypeAtThisTime Then
      
'                       or  (RPrg_TimeType = @csSchTypeTimeAtThisTime
'
'                             and     datepart(hh,RPrg_Time)*100+datepart(n,RPrg_Time)
'                                 <=  datepart(hh,@hora)*100+datepart(n,@hora)
'                           )
'                     )
        If Hour(.Time) * 100 + Minute(.Time) _
           <= Hour(Now) * 100 + Minute(Now) Then
           
          If DateSerial(Year(.LastRun), Month(.LastRun), Day(.LastRun)) _
             < DateSerial(Year(Now), Month(Now), Day(Now)) Then
           
            bIsTime = True
          End If
        End If
      
      End If
      
      If bIsTime Then
        If .FirtsRunStartAt > Now Then
  
          bIsTime = False
          
        ElseIf .LastRunEndAt < Now Then
          
          bIsTime = False
          
        End If
      End If
      
      If .RunType = csSchRunTypeDaily Then

'                 and (     (RPrg_RunType = @csSchTypeRunDaily
'                             and     datepart(hh,dateadd(d,RPrg_RunDailyInterval,RPrg_lastRun))*100
'                                   + datepart(n,dateadd(d,RPrg_RunDailyInterval,RPrg_lastRun))
'                                  <=
'                                     datepart(hh,@hora)*100
'                                   + datepart(n,@hora)
'                           )

        NextRun = DateAdd("d", .RunDailyInterval, .LastRun)
        If NextRun <= Now Then
           
           bIsDay = True
           
        Else
          
          If .TimeType = csSchTimeTypeRecurring Then
          
            If .LastRun <= Now And bIsTime Then
              
              bIsDay = True
            End If
          End If
        End If
    
      ElseIf .RunType = csSchRunTypeWeekly Then

'                       or  (RPrg_RunType = @csSchTypeRunWeekly
'                             and datepart(wk,
'                                   dateadd(d,
'                                           7*(RPrg_RunWeeklyInterval-1),
'                                           RPrg_lastRun)
'                                 ) <= datepart(wk,@ahora)
'                             and (     (datepart(dw,@ahora) = 1 and RPrg_RunSunday <> 0)
'                                   or  (datepart(dw,@ahora) = 2 and RPrg_RunMonday <> 0)
'                                   or  (datepart(dw,@ahora) = 3 and RPrg_RunTuesday <> 0)
'                                   or  (datepart(dw,@ahora) = 4 and RPrg_RunWednesday <> 0)
'                                   or  (datepart(dw,@ahora) = 5 and RPrg_RunThursday <> 0)
'                                   or  (datepart(dw,@ahora) = 6 and RPrg_RunFriday <> 0)
'                                   or  (datepart(dw,@ahora) = 7 and RPrg_RunSaturday <> 0)
'                                 )
'                           )

        NextRun = DateAdd("d", 7 * (.RunWeeklyInterval - 1), .LastRun)
        If DatePart("ww", NextRun, vbSunday) _
           <= DatePart("ww", Now, vbSunday) Then
           
          If DatePart("w", NextRun, vbSunday) = 1 And .RunSunday Or _
             DatePart("w", NextRun, vbSunday) = 2 And .RunMonday Or _
             DatePart("w", NextRun, vbSunday) = 3 And .RunTuesday Or _
             DatePart("w", NextRun, vbSunday) = 4 And .RunWednesday Or _
             DatePart("w", NextRun, vbSunday) = 5 And .RunThursday Or _
             DatePart("w", NextRun, vbSunday) = 6 And .RunFriday Or _
             DatePart("w", NextRun, vbSunday) = 7 And .RunSaturday Then
              
            bIsDay = True
          
          End If
        End If
      ElseIf .RunType = csSchRunTypeMonthly Then
'                       or  (RPrg_RunType = @csSchTypeRunMonthly
'                             and RPrg_RunMonthlyNumberDay = datepart(d,@ahora)
'                             and datepart(m,dateadd(m,RPrg_RunMonthlyInterval,RPrg_lastRun)) <= datepart(m,@ahora)
'                           )

        If .RunMonthlyNumberDay = Day(Now) Then
        
          NextRun = DateAdd("m", .RunMonthlyInterval, .LastRun)
          If Month(NextRun) <= Month(Now) Then
            bIsDay = True
          End If
        End If
        
      ElseIf .RunType = csSchRunTypeMonthlyRelative Then
'                       or  (RPrg_RunType = @csSchTypeRunMonthlyRelative
'                             and RPrg_RunMonthlyCardinalDay = datepart(d,@ahora) / 7 +1
'                             and RPrg_RunMonthlyNameDay = datepart(dw,@ahora)
'                             and datepart(m,dateadd(m,RPrg_RunMonthlyInterval,RPrg_lastRun)) <= datepart(m,@ahora)
'                           )
'                     )
        
        If .RunMonthlyCardinalDay = DatePart("d", Now) / 7 + 1 Then
        
          If .RunMonthlyNameDay = DatePart("w", Now, vbSunday) Then
          
            NextRun = DateAdd("m", .RunMonthlyInterval, .LastRun)
            If Month(NextRun) = Month(Now) Then
              bIsDay = True
            End If
          End If
        End If
        
      End If
'
'                 and RPrg_TimeStart        <= @hora
'                 and RPrg_TimeEnd          >= @hora
'                 and RPrg_FirtsRunStartAt  <= @ahora
'                 and RPrg_LastRunEndAt     >= @ahora
'               )
    
    End If
  End With
  
  pAddToLog "La programación " & Schedule.Name
  pAddToLog "se ejecuto por ultima vez el " & Schedule.LastRun
  pAddToLog "La proxima ejecucion sera el " & NextRun
  
  If bIsDay And bIsTime Then
  
    Schedule.LastRun = Now
  
    If Not Schedule.Save(True, strError) Then
      pAddToLog "No se pudo actualizar la tarea"
      pAddToLog "Error: " & strError
      Exit Function
    End If
    
    pIsTimeToExecute = True
  End If
  
End Function

Private Function pProcessSechedule(ByVal ScheduleFile As String) As Boolean
  
  pAddToLog "Cargando programación"
  pAddToLog ScheduleFile
  
  Dim strError As String
  Dim Schedule As cSchedule
  Set Schedule = New cSchedule
  
  If Schedule.Load(ScheduleFile, True, strError) Then
  
    pAddToLog "Procesando Programación"
    pAddToLog Schedule.Name
    
    Dim i As Long
    
    For i = 1 To Schedule.Tasks.Count
    
      If pSelectTask(Schedule.Tasks.Item(i).Name) Then
    
        pProcessTask lvTask.SelectedItem.SubItems(1)
      Else
      
        pAddToLog "No se encontro la tarea " & Schedule.Tasks.Item(i).Name & " en la lista de tareas"
      End If
    
    Next
  
    pProcessSechedule = True
  
  Else
    pAddToLog "No se pudo cargar la programación"
    pAddToLog ScheduleFile
    pAddToLog "Error: " & strError & " - " & Err.Description
    
    pProcessSechedule = False
    
  End If

End Function

Private Sub pAddToLog(ByVal msg As String)
  If lvProgress.ListItems.Count > 100 Then
    lvProgress.ListItems.Remove 1
  End If
  With lvProgress.ListItems.Add(, , msg)
    DoEvents
    .Selected = True
    .EnsureVisible
  End With
End Sub

Private Sub pUpdateLog(ByVal msg As String, ByVal Index As Long)
  If Index < 1 Then Exit Sub
  If Index > lvProgress.ListItems.Count Then Exit Sub
  lvProgress.ListItems.Item(Index) = msg
End Sub

Private Function pProcessTask(ByVal TaskFile As String) As Boolean

  Dim strError As String
  
  pAddToLog "Cargando Tarea"
  pAddToLog TaskFile
  
  m_Multizip = 0
  
  If TaskType(TaskFile, True, strError) = c_TaskTypeBackupDB Then
    pProcessTask = pProcessTaskDB(TaskFile)
  Else
    pProcessTask = pProcessTaskFile(TaskFile)
  End If
  
  If LenB(strError) Then
    pAddToLog "Error: " & strError
  End If
  
End Function

Private Function pProcessTaskDB(ByVal TaskFile As String) As Boolean

  Dim Task As cSQLTaskCommandBackup
  Set Task = New cSQLTaskCommandBackup
  
  Dim strError As String
  
  If Task.Load(TaskFile, True, strError) Then
  
    pAddToLog "Procesando Tarea de Backup de Base de Datos SQL"
    pAddToLog Task.Name
        
    If Task.Connect(Task.Server, _
                    Task.User, _
                    Task.Pwd, _
                    Task.SecurityType, _
                    True, strError) Then
    
      pAddToLog "Generando el backup"
      If Task.Conn.Execute(Task.Command, True, strError) Then
              
        pAddToLog "Generando el zip"
      
        Dim Zip As cZip
        
        pCreateZip Zip, Task.File
    
        If Task.IsLog Then
          pAddToZip Zip, pGetFilInServer(Task.FileLog, Task.ServerFolder)
        Else
          pAddToZip Zip, pGetFilInServer(Task.FileDataBase, Task.ServerFolder)
        End If
    
        If Task.ZipFiles Then
          pRenameZipFiles Zip.ZipFile, Task.ZipFiles
        End If
        
        pZip Zip
        
        If LenB(Task.FtpAddress) Then
        
          pAddToLog "Subiendo el archivo al FTP [" & Task.FtpAddress & "]"
        
          If pWriteFile(Task.File, _
                        Task.FtpAddress, _
                        Task.FtpUser, _
                        Task.FtpPwd, _
                        Task.FtpPort, _
                        strError) Then
            
            pAddToLog "El archivo se subio con éxito"
            
            pProcessTaskDB = True
          
          Else
          
            pAddToLog "No se pudo subir el archivo al FTP"
            pAddToLog "Error " & strError
            pProcessTaskDB = False
          End If
        Else
          
          pProcessTaskDB = True
        
        End If
      
      Else
          
        pAddToLog "No se pudo el backup de la base [" & Task.Server & "." & Task.DataBase & "]"
        pAddToLog "Error: " & strError
        
        pProcessTaskDB = False

      End If
    
    Else
      
      pAddToLog "No se pudo abrir la conexion con el servidor [" & Task.Server & "]"
      pAddToLog "Usando [" & Task.User & "]"
      pAddToLog "Y seguridad por [" & IIf(Task.SecurityType = csTSNT, "NT", "SQL") & "]"
      pAddToLog "Error: " & strError
      
      pProcessTaskDB = False
      
    End If
  
  Else
    pAddToLog "No se pudo cargar la tarea"
    pAddToLog TaskFile
    pAddToLog "Error: " & strError & " - " & Err.Description
    
    pProcessTaskDB = False
    
  End If

End Function

Private Function pProcessTaskFile(ByVal TaskFile As String) As Boolean

  Dim Task As cTask
  Set Task = New cTask
  
  Dim strError As String
  
  If Task.Load(TaskFile, True, strError) Then
  
    pAddToLog "Procesando Tarea de Backup de Carpetas y Archivos"
    pAddToLog Task.Name
    
    Dim Zip As cZip
    
    ' Por si hay mas de 1023 archivos
    '
    m_zipFileName = Task.File
    ReDim m_vMultiZips(0)
    
    If Task.ZipFiles Then
      pRenameZipFiles Task.File, Task.ZipFiles
    End If
    
    pCreateZip Zip, Task.File
    
    Dim i As Long
    
    For i = 1 To Task.Folders.Count
    
      pProcessTaskFolder Task.Folders.Item(i), Zip
    
      If m_cancel Then Exit Function
    
    Next
    
    pZip Zip
    
    If m_Multizip Then
    
      pCreateZip Zip, Task.File
    
      For i = 1 To UBound(m_vMultiZips)
        pAddToZip Zip, m_vMultiZips(i)
      Next
    
      pZip Zip
    
      For i = 1 To UBound(m_vMultiZips) - 1
        pKill m_vMultiZips(i)
      Next
    
    End If
  
    If LenB(Task.FtpAddress) Then
    
      pAddToLog "Subiendo el archivo al FTP [" & Task.FtpAddress & "]"
    
      If pWriteFile(Task.File, _
                    Task.FtpAddress, _
                    Task.FtpUser, _
                    Task.FtpPwd, _
                    Task.FtpPort, _
                    strError) Then
        
        pAddToLog "El archivo se subio con éxito"
        
        pProcessTaskFile = True
      
      Else
      
        pAddToLog "No se pudo subir el archivo al FTP"
        pAddToLog "Error " & strError
        pProcessTaskFile = False
      End If
    Else
      
      pProcessTaskFile = True
    
    End If
  
  Else
    pAddToLog "No se pudo cargar la programación"
    pAddToLog TaskFile
    pAddToLog "Error: " & strError & " - " & Err.Description
    
    pProcessTaskFile = False
    
  End If
End Function

Private Function pProcessTaskFolder(ByVal TaskItem As cTaskItem, _
                                    ByRef Zip As cZip) As Boolean
  
  pAddToLog "Procesando Carpeta/Archivo"
  pAddToLog TaskItem.Name
  
  If TaskItem.Checked Then
  
    If TaskItem.ItemType = csEIT_File Then
    
      pAddToZip Zip, TaskItem.FullPath
    Else
    
      pAddFolderToZip Zip, TaskItem.FullPath
    
    End If
  
  End If
  
  If TaskItem.Children.Count Then
  
    Dim Item As cTaskItem
  
    For Each Item In TaskItem.Children
      pProcessTaskFolder Item, Zip
    Next
  End If
  
End Function

Private Function pSelectTask(ByVal TaskName As String) As Boolean
  Dim i As Long
  
  pUnSelectTask
  
  For i = 1 To lvTask.ListItems.Count
    If lvTask.ListItems.Item(i) = TaskName Then
    
      lvTask.ListItems.Item(i).Selected = True
      pSelectTask = True
      Exit Function
    End If
  Next
End Function

Private Sub pUnSelectTask()
  Dim i As Long
  
  For i = 1 To lvTask.ListItems.Count
    lvTask.ListItems.Item(i).Selected = False
  Next

End Sub

Private Sub pCreateZip(ByRef Zip As cZip, _
                       ByVal ZipFile As String)
  
  m_FileCount = 0
  m_IdxFile = 0
  
  ' Creo el zip
  '
  Set Zip = New cZip
  
  Set m_cZ = Zip
  
  With Zip
  
     .Encrypt = LenB(GetPasswordFiles())
     .AddComment = False
     .ZipFile = ZipFile
     .StoreFolderNames = True
     .RecurseSubDirs = False
     .ClearFileSpecs
  
  End With

  pKill ZipFile

End Sub

Private Function pZip(ByRef Zip As cZip) As Boolean
  
  With Zip
    
    ' Si estamos en un zip multipart y no hay
    ' archivos que comprimir, no generamos un
    ' archivo zip vacio. Esto se da por que el
    ' limite es de 1023 archivos por zip, y
    ' la funcion pAddToZip cuando se alcanza este
    ' limite llama a esta funcion pZip y se genera
    ' el zip, y cuando justo era el ultimo archivo
    ' que se agregaba al zip, el ultimo multipart
    ' no es necesario.
    '
    If m_Multizip > 0 And .FileSpecCount = 0 Then
      pZip = True
    Else
    
      ' Agrego tres renglones al
      ' log par ir mostrando los
      ' progresos
      '
      pAddToLog vbNullString
      pAddToLog vbNullString
      pAddToLog vbNullString
      m_IndexMsg = 0
      
      .Zip
      
      If (.Success) Then
         
         UpdateStatus picStatus, 1, True
         
         pAddToLog "Archivo generado: " & .ZipFile
         pZip = True
      Else
         pAddToLog "Falló la creación del zip."
         pZip = False
      End If
    End If
    
    ReDim Preserve m_vMultiZips(UBound(m_vMultiZips) + 1)
    m_vMultiZips(UBound(m_vMultiZips)) = Zip.ZipFile
    
  End With

End Function

Private Sub pAddToZip(ByRef Zip As cZip, _
                      ByVal FullFileName As String)
  If Zip.FileSpecCount = 1022 Then
    
    Zip.ZipFile = pGetMultiZipName(m_zipFileName, m_Multizip)
    
    pZip Zip
    
    m_Multizip = m_Multizip + 1
    pCreateZip Zip, pGetMultiZipName(m_zipFileName, m_Multizip)
    
  Else
    Zip.AddFileSpec FullFileName
    m_FileCount = m_FileCount + 3
    DoEvents
  End If
End Sub

Private Sub pAddFolderToZip(ByRef Zip As cZip, _
                            ByVal FullFolderName As String)
  Dim s       As String
  
  FullFolderName = FileGetValidPath(FullFolderName)
  
  s = Dir(FullFolderName & "*.*")
  
  While s <> vbNullString
    pAddToZip Zip, FullFolderName & s
    s = Dir()
    If m_cancel Then Exit Sub
  Wend
  
  Dim vDirs() As String
  ReDim vDirs(0)
  
  s = Dir(FullFolderName, vbDirectory)
  
  Do
    If s = "" Then Exit Do
    If (GetAttr(FullFolderName & s) And vbDirectory) = vbDirectory And s <> ".." And s <> "." Then
      ReDim Preserve vDirs(UBound(vDirs) + 1)
      vDirs(UBound(vDirs)) = FullFolderName & s
    End If
    s = Dir
    If m_cancel Then Exit Sub
  Loop
  
  Dim i As Integer
  
  For i = 1 To UBound(vDirs)
    pAddFolderToZip Zip, vDirs(i)
    If m_cancel Then Exit Sub
  Next
  
End Sub

Private Function pGetMultiZipName(ByVal FullFileName As String, _
                                  ByVal nIndex As String) As String
  Dim rtn As String
  
  rtn = GetFileNameWithoutExt_(FullFileName) _
        & "_" & Format(nIndex, "000") & "." & _
        GetFileExt_(FullFileName)
        
  pGetMultiZipName = FileGetValidPath(GetPath_(FullFileName)) & rtn
End Function

Private Sub m_cZ_Progress(ByVal lCount As Long, ByVal sMsg As String)
  
  If m_IndexMsg = 0 Then
    pUpdateLog sMsg, lvProgress.ListItems.Count - 2
    m_IndexMsg = 1
  ElseIf m_IndexMsg = 1 Then
    pUpdateLog sMsg, lvProgress.ListItems.Count - 1
    m_IndexMsg = 2
  Else
    pUpdateLog sMsg, lvProgress.ListItems.Count
    m_IndexMsg = 0
  End If
  
  m_IdxFile = m_IdxFile + 1
  UpdateStatus picStatus, DivideByZero(m_IdxFile, m_FileCount)
  DoEvents
End Sub

Private Sub m_cZ_Cancel(ByVal sMsg As String, bCancel As Boolean)
  bCancel = m_cancel
End Sub

Private Sub m_cZ_PasswordRequest(sPassword As String, ByVal lMaxPasswordLength As Long, ByVal bConfirm As Boolean, bCancel As Boolean)
  sPassword = GetPasswordFiles()
End Sub

Private Sub pKill(ByVal FullFileName As String)
  On Error Resume Next
  Kill FullFileName
  Err.Clear
End Sub

Private Function pWriteFile(ByVal FullFileName As String, _
                            ByVal IPaddress As String, _
                            ByVal User As String, _
                            ByVal Password As String, _
                            ByVal Port As Long, _
                            ByRef strError As String) As Boolean
  On Error GoTo ControlError

  With Inet1
    .url = IPaddress
    .UserName = User
    .Password = Password
    .RemotePort = Port
  End With

  Inet1.Cancel

  Do While Inet1.StillExecuting
    DoEvents
    If m_cancel Then Exit Function
  Loop
  
  Dim nStartFolderFtp As Long
  If LCase$(Left$(IPaddress, 6)) = "ftp://" Then
    IPaddress = Mid(IPaddress, 7)
  End If
  nStartFolderFtp = InStr(1, IPaddress, "/")
  If nStartFolderFtp Then
    Dim ftpFolder As String
    ftpFolder = Trim$(Mid$(IPaddress, nStartFolderFtp + 1))
    If LenB(ftpFolder) Then
      ftpFolder = ftpFolder & "/"
    End If
  End If
  
  Dim ftpCommand As String
  
  ftpCommand = "PUT """ & FullFileName & """ /" & ftpFolder & GetFileName_(FullFileName)
  
  Inet1.Execute , ftpCommand
    
  Do While Inet1.StillExecuting
    DoEvents
  Loop

  pWriteFile = True

  GoTo ExitProc
ControlError:
  strError = Err.Description
  pLogError Err.Description
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pGetFilInServer(ByVal File As String, ByVal Folder As String) As String
  If LenB(Folder) Then
    File = GetFileName_(File)
    File = FileGetValidPath(Folder) & File
  End If
  pGetFilInServer = File
End Function

Private Sub pRenameZipFiles(ByVal ZipFile As String, ByVal ZipFiles As Long)
  Dim zf  As String
  Dim fzf As String
  Dim zfe As String
  
  If ZipFiles = 0 Then Exit Sub
  
  zf = GetFileNameWithoutExt_(ZipFile)
  zfe = GetFileExt_(ZipFile)
  
  ' Borro el ultimo
  '
  fzf = FileGetValidPath(GetPath_(ZipFile)) & zf & Format(ZipFiles, "0000") & "." & zfe
  pKill fzf
  
  Dim i As Long
  
  For i = ZipFiles - 1 To 1 Step -1
    fzf = FileGetValidPath(GetPath_(ZipFile)) & zf & Format(i, "0000") & "." & zfe
    If FileExists_(fzf) Then
      Name fzf As FileGetValidPath(GetPath_(ZipFile)) & zf & Format(i + 1, "0000") & "." & zfe
    End If
  Next

  If FileExists_(ZipFile) Then
    Name ZipFile As FileGetValidPath(GetPath_(ZipFile)) & zf & "0001." & zfe
  End If

End Sub

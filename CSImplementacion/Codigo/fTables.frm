VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Begin VB.Form fTables 
   Caption         =   "Tablas"
   ClientHeight    =   3195
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4680
   Icon            =   "fTables.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   3195
   ScaleWidth      =   4680
   StartUpPosition =   3  'Windows Default
   Begin MSComctlLib.ListView lvTables 
      Height          =   2625
      Left            =   225
      TabIndex        =   0
      Top             =   315
      Width           =   4290
      _ExtentX        =   7567
      _ExtentY        =   4630
      LabelWrap       =   -1  'True
      HideSelection   =   -1  'True
      _Version        =   393217
      ForeColor       =   -2147483640
      BackColor       =   -2147483643
      BorderStyle     =   1
      Appearance      =   1
      NumItems        =   0
   End
End
Attribute VB_Name = "fTables"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' fTables
' 23-10-2006

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "fTables"
' estructuras
' enumeraciones

' variables privadas
' propiedades publicas
' propiedades privadas
' funciones publicas
' funciones privadas
' construccion - destruccion
Private Sub Form_Load()
  On Error GoTo ControlError

  Dim Mouse As cMouseWait
  Set Mouse = New cMouseWait

  CSKernelClient2.LoadForm Me, Me.Name

  LoadTables

  GoTo ExitProc
ControlError:
  MngError Err, "Form_Load", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Form_Resize()
  On Error Resume Next
  
  If Me.WindowState = vbMinimized Then Exit Sub
  
  lvTables.Move 0, 0, Me.ScaleWidth, Me.ScaleHeight
  
End Sub

Private Sub Form_Unload(Cancel As Integer)
  On Error GoTo ControlError

  CSKernelClient2.UnloadForm Me, Me.Name

  GoTo ExitProc
ControlError:
  MngError Err, "Form_Unload", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub LoadTables()
  Dim rs As ADODB.Recordset
  
  Set rs = gDB.OpenSchema(adSchemaTables)

  With lvTables
    .ListItems.Clear
    .View = lvwReport
    .GridLines = True
    
    .ColumnHeaders.Clear
    .ColumnHeaders.Add , , "Tabla", 5000
    .LabelEdit = lvwManual
    .FullRowSelect = True
  End With

  While Not rs.EOF
  
    Select Case LCase(rs.Fields(3))
    'dans le fields(3) se trouve le type d'élément(table, requete,etc...)
    'in fields(3) we find the kind of object : column, query...

    Case "table"
        lvTables.ListItems.Add , , rs.Fields(2)
'    Case Is = "view"
'        ReDim Preserve m_vVistas(UBound(m_vVistas) + 1)
'        m_vVistas(UBound(m_vVistas)) = rs.Fields(2)
'        Num = 5
'    Case "system table"
'        ReDim Preserve m_vTablasS(UBound(m_vTablasS) + 1)
'        m_vTablasS(UBound(m_vTablasS)) = rs.Fields(2)
'        Num = 6
'     Case Else
'        ReDim Preserve m_vOtros(UBound(m_vOtros) + 1)
'        m_vOtros(UBound(m_vOtros)) = rs.Fields(2)
'        Num = 4
    End Select
  
    rs.MoveNext
  Wend

End Sub

Private Sub lvTables_ColumnClick(ByVal ColumnHeader As MSComctlLib.ColumnHeader)
  On Error GoTo ControlError

  Dim i As Integer
  
  For i = 1 To lvTables.ColumnHeaders.Count
    lvTables.ColumnHeaders(i).Icon = 0
  Next
  
  lvTables.SortKey = ColumnHeader.Index - 1
  If lvTables.SortOrder = lvwAscending Then
    lvTables.SortOrder = lvwDescending
  Else
    lvTables.SortOrder = lvwAscending
    ColumnHeader.Alignment = lvwColumnLeft
  End If
  lvTables.Sorted = True

  GoTo ExitProc
ControlError:
  MngError Err, "lvTables_ColumnClick", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub lvTables_DblClick()
  On Error GoTo ControlError
  
  Dim db As String
  Dim Mouse As cMouseWait
  Set Mouse = New cMouseWait
  
  If lvTables.SelectedItem Is Nothing Then Exit Sub
  
  Dim f As New fEditTbl
  
  f.Table = lvTables.SelectedItem.Text
  
  With gDB
    f.Server = .ServerName
    f.User = .UserName
    f.UseNTSecurity = False
    f.Password = .Password
    f.Database = .dbName
  End With
  
  f.Show
  
  GoTo ExitProc
ControlError:
  MngError Err, "lvTables_DblClick", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

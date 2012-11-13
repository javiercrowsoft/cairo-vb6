VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cDBCompare"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cDBCompare
' 31-03-2004

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cDBCompare"

Private Const C_PrefixA = "##A##_"
Private Const C_PrefixB = "##B##_"

Private Enum csE_ServerAB
  ServerA = 1
  ServerB = 2
End Enum

' estructuras
Private Type T_Column
  Name          As String
  PhysicalName  As String
  ColType       As String
  Size          As String
  bMissing      As Boolean
  AllowNull     As Boolean
  InPrimaryKey  As Boolean
  Default       As String
  DefaultName   As String
  Node          As Node

  NumericPresicion As Long
  NumericScale     As Long
End Type

Private Type T_Index
  Name          As String
  PhysicalName  As String
  bMissing      As Boolean
  bMissingChild As Boolean
  Columns()     As T_Column
  Node          As Node
End Type

Private Type T_Table
  Name          As String
  PhysicalName  As String
  Columns()     As T_Column
  Indexes()     As T_Index
  bMissing      As Boolean
  bMissingChild As Boolean
  Node          As Node
End Type
' variables privadas
Private m_ServerA As cSQLServer
Private m_ServerB As cSQLServer
Private WithEvents m_fDBCompare As fDBCompare
Attribute m_fDBCompare.VB_VarHelpID = -1
Private WithEvents m_Login      As fLogin
Attribute m_Login.VB_VarHelpID = -1
Private m_AorB As csE_ServerAB

Private m_vTablesA() As T_Table
Private m_vTablesB() As T_Table

Private m_bCancel    As Boolean
' eventos
' propiedades publicas
' propiedades friend
' propiedades privadas
' funciones publicas
Public Function Show() As Boolean
  Set m_fDBCompare = New fDBCompare
  m_fDBCompare.Show
  Set m_fDBCompare.ObjCompare = Me
End Function

' funciones friend
' funciones privadas
Private Sub m_fDBCompare_Cancel(bCancel As Boolean)
  bCancel = Not pCancel()
End Sub

Private Sub m_fDBCompare_Compare()
  pCompare
End Sub

Private Sub m_fDBCompare_Generate()
  On Error GoTo ControlError
  
  Dim f       As fDBCompare
  Dim lFile   As Integer
  
  lFile = FreeFile

  Set f = m_fDBCompare
  
  If Dir(f.txFile.Text) <> "" And f.ChkCrearFile.Value = vbChecked Then Kill f.txFile.Text

  Open f.txFile.Text For Append Access Write Lock Write As lFile

  pGenerate lFile

  Close lFile

  GoTo ExitProc
ControlError:
  MngError Err, "m_fDBCompare_Generate", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub m_fDBCompare_LoadApply()
  On Error GoTo ControlError
  
  Dim f       As fDBCompare
  Dim lFile   As Integer
  
  lFile = FreeFile

  Set f = m_fDBCompare
  
  Open f.txFileCompare.Text For Input As lFile
  
  pLoadCompare m_fDBCompare.tvA, ServerA, lFile
  
  Close lFile
  
  Open f.txFileCompare.Text For Input As lFile
  
  pLoadCompare m_fDBCompare.tvB, ServerB, lFile
  
  Close lFile

  
  GoTo ExitProc
ControlError:
  MngError Err, "m_fDBCompare_LoadApply", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub m_fDBCompare_Save()
  On Error GoTo ControlError
  
  Dim f       As fDBCompare
  Dim lFile   As Integer
  
  lFile = FreeFile

  Set f = m_fDBCompare
  
  If Dir(f.txFileCompare.Text) <> "" Then Kill f.txFileCompare.Text

  Open f.txFileCompare.Text For Append Access Write Lock Write As lFile
  
  pSaveCompare m_fDBCompare.tvA, ServerA, lFile
  pSaveCompare m_fDBCompare.tvB, ServerB, lFile
  
  Close lFile
  
  GoTo ExitProc
ControlError:
  MngError Err, "m_fDBCompare_Save", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub pLoadCompare(ByRef Tree As TreeView, ByVal AorB As csE_ServerAB, ByVal lFile As Integer)
  Dim Prefix As String
  Dim Node As Node
  Dim Key  As String
  
  If AorB = ServerA Then
    Prefix = C_PrefixA
  Else
    Prefix = C_PrefixB
  End If
  
  While Not EOF(lFile)
  
    Line Input #lFile, Key

    If InStr(1, Key, Prefix) > 0 Then

      Key = Mid(Key, Len(Prefix) + 1)
  
      For Each Node In Tree.Nodes
        If Node.Key = Key Then
          Node.Checked = True
          Exit For
        End If
      Next
    End If
  Wend
End Sub

Private Sub pSaveCompare(ByRef Tree As TreeView, ByVal AorB As csE_ServerAB, ByVal lFile As Integer)
  Dim Prefix As String
  Dim Node As Node
  
  If AorB = ServerA Then
    Prefix = C_PrefixA
  Else
    Prefix = C_PrefixB
  End If
  
  For Each Node In Tree.Nodes
    If Node.Checked Then
      Print #lFile, Prefix & Node.Key
    End If
  Next
End Sub

Private Sub m_fDBCompare_ShowNodes(ByVal bOnlyMismatch As Boolean, ByVal bIndex As Boolean)
  On Error GoTo ControlError
  
  pLoadTree m_fDBCompare.tvA, m_vTablesA, bOnlyMismatch, bIndex
  pLoadTree m_fDBCompare.tvB, m_vTablesB, bOnlyMismatch, bIndex
  
  GoTo ExitProc
ControlError:
  MngError Err, "m_fDBCompare_ShowNodes", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub m_Login_Connect(Cancel As Boolean)
  If m_AorB = ServerA Then
    Cancel = Not m_ServerA.OpenConnection(m_Login.cbServer.Text, m_Login.txUser.Text, m_Login.txPassword.Text, m_Login.opNt.Value)
  Else
    Cancel = Not m_ServerB.OpenConnection(m_Login.cbServer.Text, m_Login.txUser.Text, m_Login.txPassword.Text, m_Login.opNt.Value)
  End If
End Sub

Private Sub m_fDBCompare_ConnectA()
  pConnect ServerA
End Sub

Private Sub m_fDBCompare_ConnectB()
  pConnect ServerB
End Sub

Private Sub pConnect(ByVal AorB As csE_ServerAB)
  On Error GoTo ControlError

  Dim f As fLogin
#If PREPROC_UPDATE Then
  Dim Mouse As cMouseWait
  Set Mouse = New cMouseWait
#Else
  Dim Mouse As CSTools.cMouseWait
  Set Mouse = New CSTools.cMouseWait
#End If

  m_AorB = AorB
  
  Set f = New fLogin
  
  Set m_Login = f
  
  f.Show vbModal
  
  If f.Ok Then
    If AorB = ServerA Then
      m_fDBCompare.lbServerA.Caption = m_ServerA.Conn.ServerName
      pLoadDB m_fDBCompare.cbDBA, ServerA, m_ServerA
    Else
      m_fDBCompare.lbServerB.Caption = m_ServerB.Conn.ServerName
      pLoadDB m_fDBCompare.cbDBB, ServerB, m_ServerB
    End If
  End If

  GoTo ExitProc
ControlError:
  MngError Err, "pConnect", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
  
  Unload f
  Set m_Login = Nothing
End Sub

Private Sub pLoadDB(ByRef cb As ComboBox, ByVal AorB As csE_ServerAB, ByRef Server As cSQLServer)
  On Error GoTo ControlError
  
  Dim dbInfo As cListDataBaseInfo
  Dim colDbs As Collection
  
  cb.Clear
  
  Set colDbs = Server.ListDataBases()
  
  For Each dbInfo In colDbs
    cb.AddItem dbInfo.Name
  Next
  
  GoTo ExitProc
ControlError:
  MngError Err, "pLoadDB", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Function pLoadTree(ByRef Tree As TreeView, ByRef vTables() As T_Table, _
                           ByVal bOnlyMismatch As Boolean, _
                           ByVal bIndex As Boolean) As Boolean
  On Error GoTo ControlError
  
  Dim i         As Long
  Dim j         As Long
  Dim q         As Long
  Dim Node      As Node
  Dim NodeCol   As Node
  Dim NodeIndex As Node
  Dim Root      As Node
  Dim Columns   As Node
  Dim Indexes   As Node
  Dim IndexName As String
  Dim ColName   As String
  Dim bAddNode  As Boolean
  
  Tree.Visible = False
  
  Tree.Nodes.Clear
  
  Set Root = Tree.Nodes.Add(, , "&&11", "Tablas")
  
  Root.Tag = "1"
  
  For i = 1 To UBound(vTables)
    
    If m_bCancel Then Exit Function
    
    bAddNode = False
    
    With vTables(i)
    
      If (Not bOnlyMismatch) Or .bMissing Then
        bAddNode = True
      End If
      
      If .bMissingChild Then
        Dim n As Long
        If Not bIndex Then
          For n = 1 To UBound(.Columns)
            If .Columns(n).bMissing Then
              bAddNode = True
              Exit For
            End If
          Next
        Else
          bAddNode = True
        End If
      End If
    End With
    
    If bAddNode Then
    
      With vTables(i)
        
        Set Node = Tree.Nodes.Add(Root, tvwChild, GetLcaseKey(.PhysicalName), .Name)
        
        Node.Tag = "t"
        
        Set .Node = Node
        
        If .bMissing Then
          Node.ForeColor = vbRed
        ElseIf .bMissingChild Then
          Node.ForeColor = vbBlue
        End If
      End With
      
      Set Columns = Tree.Nodes.Add(Node, _
                                   tvwChild, _
                                   GetLcaseKey(vTables(i).PhysicalName & ".<Columns>"), _
                                   "Columnas")
      Columns.Tag = "1"
      
      For j = 1 To UBound(vTables(i).Columns)
      
        bAddNode = False

        With vTables(i).Columns(j)
        
          If Not bOnlyMismatch Or .bMissing Then
            bAddNode = True
          End If
        End With
        
        If bAddNode Then
          
          With vTables(i).Columns(j)
            ColName = vTables(i).PhysicalName & "." & .PhysicalName
            Set NodeCol = Tree.Nodes.Add(Columns, _
                                         tvwChild, _
                                         GetLcaseKey(ColName), _
                                         .Name)
            
            Set .Node = NodeCol
            
            If .Default <> "" Then
            
              If .Name = "..." Then
                With Tree.Nodes.Add(NodeCol, _
                                    tvwChild, _
                                    GetLcaseKey(ColName & ".default"), _
                                    "Default = ...")
                  .ForeColor = vbRed
                End With
              Else
                With Tree.Nodes.Add(NodeCol, _
                                    tvwChild, _
                                    GetLcaseKey(ColName & ".default"), _
                                    "Default = " & .Default)
                  .ForeColor = vbRed
                End With
              End If
            End If
            
            If .bMissing Then
              NodeCol.ForeColor = vbRed
              
              If .Name = "..." Then
                
                With Tree.Nodes.Add(NodeCol, _
                                    tvwChild, _
                                    GetLcaseKey(ColName & ".allownull"), _
                                    "AllowNull = ...")
                  .ForeColor = vbRed
                End With
                With Tree.Nodes.Add(NodeCol, _
                                    tvwChild, _
                                    GetLcaseKey(ColName & ".coltype"), _
                                    "ColType = ...")
                  .ForeColor = vbRed
                End With
                
                If pExistsNode(ColName & ".default", Tree) Then
                  With Tree.Nodes.Item(GetLcaseKey(ColName & ".default"))
                    .ForeColor = vbRed
                  End With
                Else
                  With Tree.Nodes.Add(NodeCol, _
                                      tvwChild, _
                                      GetLcaseKey(ColName & ".default"), _
                                      "Default = ...")
                    .ForeColor = vbRed
                  End With
                End If
                
                With Tree.Nodes.Add(NodeCol, _
                                    tvwChild, _
                                    GetLcaseKey(ColName & ".size"), _
                                    "Size = ...")
                  .ForeColor = vbRed
                End With
              
              Else
              
                With Tree.Nodes.Add(NodeCol, _
                                    tvwChild, _
                                    GetLcaseKey(ColName & ".allownull"), _
                                    "AllowNull = " & vTables(i).Columns(j).AllowNull)
                  .ForeColor = vbRed
                End With
                With Tree.Nodes.Add(NodeCol, _
                                    tvwChild, _
                                    GetLcaseKey(ColName & ".coltype"), _
                                    "ColType = " & vTables(i).Columns(j).ColType)
                  .ForeColor = vbRed
                End With
                
                If pExistsNode(ColName & ".default", Tree) Then
                  With Tree.Nodes.Item(GetLcaseKey(ColName & ".default"))
                    .ForeColor = vbRed
                  End With
                Else
                  With Tree.Nodes.Add(NodeCol, _
                                      tvwChild, _
                                      GetLcaseKey(ColName & ".default"), _
                                      "Default = " & vTables(i).Columns(j).Default)
                    .ForeColor = vbRed
                  End With
                End If
                
                With Tree.Nodes.Add(NodeCol, _
                                    tvwChild, _
                                    GetLcaseKey(ColName & ".size"), _
                                    "Size = " & vTables(i).Columns(j).Size)
                  .ForeColor = vbRed
                End With
              End If
            End If
          End With
        End If
      Next
    
      If bIndex Then
    
        Set Indexes = Tree.Nodes.Add(Node, _
                                     tvwChild, _
                                     GetLcaseKey(vTables(i).PhysicalName & ".<Indexes>"), _
                                     "Indices")
        Indexes.Tag = "1"
      
        For j = 1 To UBound(vTables(i).Indexes)
          
          bAddNode = False
  
          With vTables(i).Indexes(j)
          
            If Not bOnlyMismatch Or (.bMissing Or .bMissingChild) Then
              bAddNode = True
            End If
          End With
          
          If bAddNode Then
            With vTables(i).Indexes(j)
            
              IndexName = vTables(i).PhysicalName & ".idx." & .PhysicalName
            
              Set NodeIndex = Tree.Nodes.Add(Indexes, _
                                             tvwChild, _
                                             GetLcaseKey(IndexName), _
                                             .Name)
              
              Set .Node = NodeIndex
              
              If .bMissing Then
                NodeIndex.ForeColor = vbRed
              ElseIf .bMissingChild Then
                Node.ForeColor = vbGreen
              End If
              
              For q = 1 To UBound(.Columns)
                With .Columns(q)
                  
                  Set NodeCol = Tree.Nodes.Add(NodeIndex, _
                                               tvwChild, _
                                               GetLcaseKey(IndexName & "." & .PhysicalName), _
                                               .Name)
                  
                  Set .Node = NodeCol
                  
                  If .bMissing Then
                    NodeCol.ForeColor = vbRed
                  End If
                End With
              Next
            End With
          End If
        Next
      End If
    End If
  Next
  
  Tree.Visible = True
  
  pLoadTree = True

  GoTo ExitProc
ControlError:
  MngError Err, "pLoadTree", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pExistsNode(ByVal Key As String, ByRef Tree As TreeView) As Boolean
  On Error Resume Next
  Dim Node As Node
  
  Err.Clear
  
  Set Node = Tree.Nodes.Item(GetLcaseKey(Key))
  
  pExistsNode = Err.Number = 0
End Function

Private Function pLoadVectorAux(ByRef vTables() As T_Table, ByRef Server As cSQLServer, ByVal DbName As String) As Boolean
  Dim Tbl As cTable
  Dim Db  As cDataBase
  Dim i   As Long
  
  Set Db = Server.GetDataBaseInfo(DbName, True, False, Db)
  
  ReDim vTables(Db.Tables.Count)
  
  Dim pnl1  As Panel
  Dim pnl2  As Panel
  
  With m_fDBCompare.sbMessages
    .Panels(2).Text = Db.Tables.Count
    
    Set pnl1 = .Panels(1)
    Set pnl2 = .Panels(3)
  End With
  
  For Each Tbl In Db.Tables
  
    If m_bCancel Then Exit Function
  
    If Tbl.TblType = csTblUser Then
      i = i + 1
      pnl1.Text = Tbl.Name
      pnl2.Text = i
      DoEvents
      
      With vTables(i)
        .Name = Tbl.Name
        .PhysicalName = .Name
      End With
      
      If Not pLoadColumns(vTables(i), Tbl, Server.Conn, DbName) Then Exit Function
      If Not pLoadIndex(vTables(i), Tbl, Server.Conn, DbName) Then Exit Function
    End If
  Next
  
  ReDim Preserve vTables(i)
  
  pLoadVectorAux = True
End Function

Private Function pLoadIndex(ByRef Table As T_Table, ByRef Tbl As cTable, ByRef Conn As cConnection, ByVal DbName As String) As Boolean
  Dim Idx As cIndex
  Dim col As cColumn
  Dim i   As Long
  Dim q   As Long
  
  Tbl.GetIndexes Conn, DbName
  ReDim Table.Indexes(0)
  
  For Each Idx In Tbl.Indexes
  
    If m_bCancel Then Exit Function
  
    If LCase(Mid(Idx.Name, 1, 8)) <> "_wa_sys_" Then
  
      i = i + 1
      ReDim Preserve Table.Indexes(i)
      With Table.Indexes(i)
        .Name = Idx.Name
        .PhysicalName = .Name
        
        ReDim .Columns(Idx.IndexedColumns.Count)
        q = 0
        For Each col In Idx.IndexedColumns
        
          If m_bCancel Then Exit Function
          
          q = q + 1
          .Columns(q).Name = col.Name
          .Columns(q).PhysicalName = col.Name
        Next
      End With
    End If
  Next
  
  pSortIndexes Table.Columns
  
  pLoadIndex = True
End Function

Private Function pLoadColumns(ByRef Table As T_Table, ByRef Tbl As cTable, ByRef Conn As cConnection, ByVal DbName As String) As Boolean
  Dim col As cColumn
  Dim i   As Long
  
  Tbl.GetColumns Conn, DbName
  
  ReDim Table.Columns(Tbl.Columns.Count)
  
  For Each col In Tbl.Columns
    
    If m_bCancel Then Exit Function
    
    i = i + 1
    With Table.Columns(i)
      .Name = col.Name
      .PhysicalName = .Name
      .ColType = col.SqlType
      .Size = col.Size
      .AllowNull = col.AllowNull
      .Default = col.Default
      .DefaultName = col.DefaultName
      .InPrimaryKey = col.InPrimaryKey
      .NumericPresicion = col.NumericPresicion
      .NumericScale = col.NumericScale
    End With
  Next
  
  pSortColumns Table.Columns
  
  pLoadColumns = True
End Function

Private Function pLoadVector(ByVal AorB As csE_ServerAB) As Boolean
  On Error GoTo ControlError
  
  Const c_SelectDB = "Seleccione una base de datos"
  
  If AorB = ServerA Then
    If m_fDBCompare.cbDBA.Text = "" Then
      MsgBox c_SelectDB, vbExclamation
    Else
      If Not pLoadVectorAux(m_vTablesA, m_ServerA, m_fDBCompare.cbDBA.Text) Then Exit Function
    End If
  Else
    If m_fDBCompare.cbDBB.Text = "" Then
      MsgBox c_SelectDB, vbExclamation
    Else
      If Not pLoadVectorAux(m_vTablesB, m_ServerB, m_fDBCompare.cbDBB.Text) Then Exit Function
    End If
  End If

  pLoadVector = True

  GoTo ExitProc
ControlError:
  MngError Err, "pLoad", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pCompare() As Boolean
  
  Dim bOnlyMismatch As Boolean
  Dim bIndex        As Boolean
  
  m_bCancel = False
  
  If Not pLoadVector(ServerA) Then Exit Function
  If Not pLoadVector(ServerB) Then Exit Function
  
  If Not pCompareAux(m_vTablesA, m_vTablesB) Then Exit Function
  If Not pCompareAux(m_vTablesB, m_vTablesA) Then Exit Function
  
  bOnlyMismatch = m_fDBCompare.chkOnlyMismatch.Value = vbChecked
  bIndex = m_fDBCompare.chkIndex.Value = vbChecked
  
  pSetMissingChild m_vTablesA, bIndex
  pSetMissingChild m_vTablesB, bIndex
  
  If Not pLoadTree(m_fDBCompare.tvA, m_vTablesA, bOnlyMismatch, bIndex) Then Exit Function
  If Not pLoadTree(m_fDBCompare.tvB, m_vTablesB, bOnlyMismatch, bIndex) Then Exit Function
  
  pCompare = True
End Function

Private Sub pSetMissingChild(ByRef vTables() As T_Table, ByVal bIndex As Boolean)
  Dim j         As Long
  Dim i         As Long
  Dim q         As Long
  Dim bMissging As Boolean
  
  For i = 1 To UBound(vTables)
    
    If Not vTables(i).bMissing Then
    
      bMissging = False
      For j = 1 To UBound(vTables(i).Columns)
        If vTables(i).Columns(j).bMissing Then
          bMissging = True
          Exit For
        End If
      Next
      
      If Not bMissging And bIndex Then
      
        For j = 1 To UBound(vTables(i).Indexes)
          If vTables(i).Indexes(j).bMissing Then
            bMissging = True
            Exit For
            
            For q = 1 To UBound(vTables(i).Indexes(j).Columns)
              If vTables(i).Indexes(j).Columns(q).bMissing Then
                bMissging = True
                Exit For
              End If
            Next
            
            If bMissging Then
              vTables(i).Indexes(j).bMissingChild = True
              Exit For
            End If
          End If
        Next
      End If
      
      If bMissging Then
        vTables(i).bMissingChild = True
      End If
    End If
  Next
End Sub

Private Function pCompareAux(ByRef vTablesA() As T_Table, ByRef vTablesB() As T_Table) As Boolean
  On Error GoTo ControlError
  
  Dim bFound      As Boolean
  Dim i           As Long
  Dim j           As Long
  Dim q           As Long
  
  For i = 1 To UBound(vTablesA)
    
    If m_bCancel Then Exit Function
    
    If vTablesA(i).Name <> "..." Then
    
      bFound = False
      For j = 1 To UBound(vTablesB)
      
        If m_bCancel Then Exit Function
      
        If vTablesA(i).Name = vTablesB(j).Name Then
          bFound = True
          Exit For
        End If
      
      Next
      
      If Not bFound Then
         
        vTablesA(i).bMissing = True
        For q = 1 To UBound(vTablesA(i).Columns)
          vTablesA(i).Columns(q).bMissing = True
        Next
        For q = 1 To UBound(vTablesA(i).Indexes)
          vTablesA(i).Indexes(q).bMissing = True
          For j = 1 To UBound(vTablesA(i).Indexes(q).Columns)
            vTablesA(i).Indexes(q).Columns(j).bMissing = True
          Next
        Next
        With vTablesA(i)
          If Not pAddNullTable(vTablesB, i, .Name, .Columns, .Indexes) Then Exit Function
        End With
      
      Else
        If Not pCompareColumns(vTablesA(i).Columns, vTablesB(j).Columns) Then Exit Function
        If Not pCompareIndexes(vTablesA(i).Indexes, vTablesB(j).Indexes) Then Exit Function
      End If
    End If
  Next

  pCompareAux = True

  GoTo ExitProc
ControlError:
  MngError Err, "pCompareAux", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pCompareIndexes(ByRef vIndexesA() As T_Index, ByRef vIndexesB() As T_Index) As Boolean
  On Error GoTo ControlError
  
  Dim bFound      As Boolean
  Dim i           As Long
  Dim j           As Long
  
  For i = 1 To UBound(vIndexesA)
    
    If m_bCancel Then Exit Function
    
    If vIndexesA(i).Name <> "..." Then
    
      bFound = False
      For j = 1 To UBound(vIndexesB)
      
        If m_bCancel Then Exit Function
        
        If LCase(vIndexesA(i).Name) = LCase(vIndexesB(j).Name) Then
          bFound = True
          Exit For
        End If
      
      Next
      
      If Not bFound Then
         
        With vIndexesA(i)
          .bMissing = True
          For j = 1 To UBound(.Columns)
            .Columns(j).bMissing = True
          Next
          If Not pAddNullIndex(vIndexesB, i, .Name, .Columns) Then Exit Function
        End With
      
      Else
        
        If Not pCompareColumns(vIndexesA(i).Columns, vIndexesB(j).Columns) Then Exit Function
      End If
    End If
  Next
  
  pCompareIndexes = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "pCompareIndexes", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pCompareColumns(ByRef vColumnsA() As T_Column, ByRef vColumnsB() As T_Column) As Boolean
  On Error GoTo ControlError
  
  Dim bFound      As Boolean
  Dim i           As Long
  Dim j           As Long
  
  For i = 1 To UBound(vColumnsA)
    
    If m_bCancel Then Exit Function
    
    If vColumnsA(i).Name <> "..." Then
    
      bFound = False
      For j = 1 To UBound(vColumnsB)
      
        If m_bCancel Then Exit Function
        
        If LCase(vColumnsA(i).Name) = LCase(vColumnsB(j).Name) Then
          bFound = True
          Exit For
        End If
      
      Next
      
      If Not bFound Then
         
        vColumnsA(i).bMissing = True
        If Not pAddNullColumn(vColumnsB, i, vColumnsA(i).Name) Then Exit Function
      
      Else
        With vColumnsA(i)
          If Not (.ColType = vColumnsB(j).ColType And _
                  .Size = vColumnsB(j).Size And _
                  .InPrimaryKey = vColumnsB(j).InPrimaryKey And _
                  .AllowNull = vColumnsB(j).AllowNull And _
                  .Default = vColumnsB(j).Default) Then
                  
            .bMissing = True
          End If
        End With
      End If
    End If
  Next

  pCompareColumns = True

  GoTo ExitProc
ControlError:
  MngError Err, "pCompareColumns", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pAddNullTable(ByRef vTables() As T_Table, ByVal Idx As Long, _
                               ByVal PhysicalName As String, _
                               ByRef vColumns() As T_Column, _
                               ByRef vIndexes() As T_Index) As Boolean
  Dim i As Long
  Dim q As Long
  Dim j As Long
  
  ReDim Preserve vTables(UBound(vTables) + 1)
  
  For i = UBound(vTables) To Idx + 1 Step -1
    LSet vTables(i) = vTables(i - 1)
  Next
  With vTables(Idx)
    .Name = "..."
    .PhysicalName = PhysicalName
    .bMissing = True
    
    ReDim .Columns(UBound(vColumns))
    For q = 1 To UBound(vColumns)
      LSet .Columns(q) = vColumns(q)
      With .Columns(q)
        .Name = "..."
        .bMissing = True
      End With
    Next
    
    ReDim .Indexes(UBound(vIndexes))
    For q = 1 To UBound(vIndexes)
      LSet .Indexes(q) = vIndexes(q)
      With .Indexes(q)
        .Name = "..."
        .bMissing = True
      End With
      For j = 1 To UBound(.Indexes(q).Columns)
        With .Indexes(q).Columns(j)
          .Name = "..."
          .bMissing = True
        End With
      Next
    Next
  End With
  
  pAddNullTable = True
End Function

Private Function pAddNullIndex(ByRef vIndexes() As T_Index, ByVal Idx As Long, ByVal PhysicalName As String, ByRef vColumns() As T_Column) As Boolean
  Dim i As Long
  
  ReDim Preserve vIndexes(UBound(vIndexes) + 1)
  
  For i = UBound(vIndexes) To Idx + 1 Step -1
    LSet vIndexes(i) = vIndexes(i - 1)
  Next
  
  With vIndexes(Idx)
    .Name = "..."
    .PhysicalName = PhysicalName
    .bMissing = True
    
    ReDim .Columns(UBound(vColumns))
    For i = 1 To UBound(vColumns)
      LSet .Columns(i) = vColumns(i)
      .Columns(i).Name = "..."
    Next
  End With
  
  pAddNullIndex = True
End Function

Private Function pAddNullColumn(ByRef vColumns() As T_Column, ByVal Idx As Long, ByVal PhysicalName As String) As Boolean
  Dim i As Long
  
  ReDim Preserve vColumns(UBound(vColumns) + 1)
  
  For i = UBound(vColumns) To Idx + 1 Step -1
    LSet vColumns(i) = vColumns(i - 1)
  Next
  
  With vColumns(Idx)
    .Name = "..."
    .PhysicalName = PhysicalName
    .bMissing = True
  End With
  
  pAddNullColumn = True
End Function

Private Sub pSortColumns(ByRef vColumns() As T_Column)
  Dim i       As Long
  Dim j       As Long
  Dim col     As T_Column
  
  For i = 1 To UBound(vColumns) - 1
    For j = UBound(vColumns) - 1 To i Step -1
      If vColumns(j).Name > vColumns(j + 1).Name Then
        LSet col = vColumns(j)
        LSet vColumns(j) = vColumns(j + 1)
        LSet vColumns(j + 1) = col
      End If
    Next
  Next
End Sub

Private Sub pSortIndexes(ByRef vColumns() As T_Column)
  Dim i       As Long
  Dim j       As Long
  Dim col     As T_Column
  
  For i = 1 To UBound(vColumns) - 1
    For j = UBound(vColumns) - 1 To i Step -1
      If vColumns(j).Name > vColumns(j + 1).Name Then
        LSet col = vColumns(j)
        LSet vColumns(j) = vColumns(j + 1)
        LSet vColumns(j + 1) = col
      End If
    Next
  Next
End Sub

Private Function pCancel() As Boolean
  
  DoEvents

  If Ask("Confirma que desea cancelar el proceso") Then
    pCancel = True
    m_bCancel = True
  End If
End Function

' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  Set m_ServerA = New cSQLServer
  Set m_ServerB = New cSQLServer

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
  On Error GoTo ControlError
  
  Set m_Login = Nothing
  Set m_fDBCompare = Nothing
  
  GoTo ExitProc
ControlError:
  MngError Err, "Class_Terminate", C_Module, ""
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

Private Sub pGenerate(ByVal lFile As Integer)
  On Error GoTo ControlError
  
  Dim NodeA       As Node
  Dim NodeB       As Node
  Dim NodeChildA  As Node
  Dim NodeChildB  As Node
  Dim NodeColumns As Node
  Dim NodeIndexes As Node
  Dim tvA         As TreeView
  Dim tvB         As TreeView
  Dim TblA        As T_Table
  Dim TblB        As T_Table
  Dim ColumnA     As T_Column
  Dim ColumnB     As T_Column
  Dim IdxTbl      As Long
  Dim IdxCol      As Long
  Dim bCreateTbl  As Boolean
  Dim bDropTbl    As Boolean
  Dim bCreateCol  As Boolean
  Dim bDropCol    As Boolean
  Dim Server      As cSQLServer
  Dim DbName      As String
  Dim strAux      As String
  Dim strAux2     As String
  Dim i           As Long
  Dim bProcess    As Boolean
  Dim pnl1        As Panel
  
  Set pnl1 = m_fDBCompare.sbMessages.Panels(1)
  
  Set tvA = m_fDBCompare.tvA
  Set tvB = m_fDBCompare.tvB
  
  For Each NodeA In tvA.Nodes
  
    If NodeA.Tag = "t" Then
  
      bProcess = False
      bDropTbl = False
      bCreateTbl = False
  
      If NodeA.Checked Then
        TblA = pGetTable(NodeA, m_vTablesA)
        TblB = pGetTable(tvB.Nodes.Item(GetLcaseKey(NodeA.Key)), m_vTablesB)
        If TblA.Name = "..." Then
          bDropTbl = True
        Else
          bCreateTbl = TblB.Name = "..."
        End If
        Set Server = m_ServerA
        DbName = m_fDBCompare.cbDBA.Text
        bProcess = True
      Else
        Set NodeB = tvB.Nodes.Item(GetLcaseKey(NodeA.Key))
        If NodeB.Checked Then
          TblA = pGetTable(NodeB, m_vTablesB)
          TblB = pGetTable(tvA.Nodes.Item(GetLcaseKey(NodeB.Key)), m_vTablesA)
          If TblA.Name = "..." Then
            bDropTbl = True
          Else
            bCreateTbl = TblB.Name = "..."
          End If
          bProcess = True
          Set Server = m_ServerB
          DbName = m_fDBCompare.cbDBB.Text
        End If
      End If
    
      If bProcess Then
    
        If bDropTbl Then
          Print #lFile, pDropTable(DbName, TblA.PhysicalName, Server)
        ElseIf bCreateTbl Then
          Print #lFile, pAddTable(DbName, TblA.PhysicalName, Server)
        Else
          strAux = pAlterTable(TblA.PhysicalName)
          
          Set NodeColumns = TblA.Node.Child
          Set NodeIndexes = NodeColumns.LastSibling
          
          Set NodeChildA = NodeColumns.Child
          Do While Not NodeChildA Is Nothing
          
            bProcess = False
            bDropCol = False
            bCreateCol = False
          
            If NodeChildA.Checked Then
              ColumnA = pGetColumn(NodeChildA, TblA.Columns)
              ColumnB = pGetColumn(tvB.Nodes.Item(GetLcaseKey(NodeChildA.Key)), _
                                   TblB.Columns)
              If ColumnA.Name = "..." Then
                bDropCol = True
              Else
                bCreateCol = ColumnB.Name = "..."
              End If
              bProcess = True
            
            Else
            
              Set NodeChildB = tvB.Nodes.Item(GetLcaseKey(NodeChildA.Key))
              If NodeChildB.Checked Then
                ColumnB = pGetColumn(NodeChildB, TblB.Columns)
                ColumnA = pGetColumn(tvA.Nodes.Item(GetLcaseKey(NodeChildB.Key)), TblA.Columns)
                If ColumnB.Name = "..." Then
                  bDropCol = True
                Else
                  bCreateCol = ColumnA.Name = "..."
                End If
                bProcess = True
              End If
            End If
            
            If bProcess Then
            
              If bDropCol Then
                strAux2 = strAux & pDropColumn(ColumnA, ColumnB, TblA.PhysicalName)
              ElseIf bCreateCol Then
                strAux2 = strAux & pAddColumn(ColumnA, ColumnB, TblA.PhysicalName)
              Else
                strAux2 = strAux & pAlterColumn(ColumnA, ColumnB, TblA.PhysicalName)
              End If

              Print #lFile, strAux2
              pnl1.Text = Mid$(strAux2, 1, 50)
              
            End If
            
            If NodeChildA Is NodeChildA.LastSibling Then Exit Do
            
            Set NodeChildA = NodeChildA.Next
          Loop
          
        End If
      End If
    End If
  Next

  MsgBox "Proceso terminado con exito !!!"

  GoTo ExitProc
ControlError:
  MngError Err, "pGenerate", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
  pnl1.Text = ""
End Sub

Private Function pGetTable(ByRef Node As Node, ByRef vTables() As T_Table) As T_Table
  Dim i As Long
  For i = 1 To UBound(vTables)
    If vTables(i).Node Is Node Then
      pGetTable = vTables(i)
      Exit Function
    End If
  Next
End Function

Private Function pGetColumn(ByRef Node As Node, ByRef vColumns() As T_Column) As T_Column
  Dim i As Long
  For i = 1 To UBound(vColumns)
    If vColumns(i).Node Is Node Then
      pGetColumn = vColumns(i)
      Exit Function
    End If
  Next
End Function

' Borrar
Private Function pDropTable(ByVal DbName As String, ByVal tblName As String, ByRef Server As cSQLServer) As String
  Dim Tbl As Table
  Dim Db  As Database
  Dim rtn As String
  
  Set Db = Server.Conn.Server.Databases(DbName)
  Set Tbl = Db.Tables(tblName)
  
  rtn = "if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[" & tblName & "]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)" & vbCrLf
  rtn = rtn & "drop table [dbo].[" & tblName & "]"
  
  pDropTable = rtn
End Function

Private Function pDropColumn(ByRef ColA As T_Column, _
                             ByRef ColB As T_Column, _
                             ByVal tblName As String) As String
  Dim rtn           As String
  Dim strDefault    As String
  
  strDefault = pGetDefaultSqlstmt(ColA, ColB, tblName)
  
  rtn = strDefault & vbCrLf & "DROP COLUMN [" & ColB.Name & "]" & vbCrLf & "GO"
  
  pDropColumn = rtn
End Function

' Nuevos - Agregagar
Private Function pAddTable(ByVal DbName As String, ByVal tblName As String, ByRef Server As cSQLServer) As String
  Dim Tbl As Table
  Dim Db  As Database
  
  Set Db = Server.Conn.Server.Databases(DbName)
  Set Tbl = Db.Tables(tblName)
  
  pAddTable = Tbl.Script(SQLDMOScript_Drops + SQLDMOScript_IncludeIfNotExists + SQLDMOScript_PrimaryObject)
End Function

Private Function pGetDefaultSqlstmt(ByRef ColA As T_Column, _
                                    ByRef ColB As T_Column, _
                                    ByVal tblName As String) As String
  
  Dim strDefault As String
  
  If ColA.Default <> "" Then
    If ColB.DefaultName <> "" Then
      strDefault = vbCrLf & "if exists (select * from dbo.sysobjects where id = object_id(N'[" & ColB.DefaultName & "]') and OBJECTPROPERTY(id, N'IsConstraint') = 1)"
      strDefault = strDefault & vbCrLf & "begin"
      strDefault = strDefault & vbCrLf & vbTab & "ALTER TABLE " & tblName & " DROP CONSTRAINT [" & ColB.DefaultName & "]"
      strDefault = strDefault & vbCrLf & "end"
      strDefault = strDefault & vbCrLf & "GO"
    End If
    strDefault = strDefault & vbCrLf & vbTab & "ALTER TABLE " & tblName & " ADD CONSTRAINT [" & ColA.DefaultName & "] DEFAULT " & ColA.Default & " FOR " & pAddBreaks(ColA.Name)
    strDefault = strDefault & vbCrLf & "GO"
    
  ElseIf ColB.Default <> "" Then
  
    strDefault = vbCrLf & "if exists (select * from dbo.sysobjects where id = object_id(N'[" & ColB.DefaultName & "]') and OBJECTPROPERTY(id, N'IsConstraint') = 1)"
    strDefault = strDefault & vbCrLf & "begin"
    strDefault = strDefault & vbCrLf & vbTab & "ALTER TABLE " & tblName & " DROP CONSTRAINT [" & ColB.DefaultName & "]"
    strDefault = strDefault & vbCrLf & "end"
    strDefault = strDefault & vbCrLf & "GO"
    
  Else
    strDefault = ""
  End If
                                    
  pGetDefaultSqlstmt = strDefault
End Function

Private Function pGetNullSqlstmt(ByRef ColA As T_Column, _
                                 ByVal tblName As String) As String
  Dim strNull As String
  
  If ColA.AllowNull Then
    strNull = ""
  Else
    If ColA.Default <> "" Then
      
      strNull = vbCrLf & "UPDATE [" & tblName & "]" _
                       & " SET [" & ColA.Name & "] = " & ColA.Default _
                       & " WHERE [" & ColA.Name & "] IS NULL " & vbCrLf & "GO" & _
                       vbCrLf & pAlterTable(tblName) & " ALTER COLUMN " & pAddColAux(ColA) & " NOT NULL" & vbCrLf & "GO"
    Else
    
      strNull = vbCrLf & "if not exists(select * from [" & tblName & "])" & _
                vbCrLf & "begin" & _
                vbCrLf & vbTab & pAlterTable(tblName) & " ALTER COLUMN " & pAddColAux(ColA) _
                                 & " NOT NULL" & _
                vbCrLf & "end else begin" & _
                       vbCrLf & vbTab & "print 'NO SE PUEDE APLICAR NOT NULL A LA COLUMNA [" _
                                & ColA.Name & "] DE LA TABLA [" & tblName & "] POR QUE EXISTEN REGISTROS EN NULL PARA ESTA COLUMNA'" & _
                vbCrLf & "end" & vbCrLf & "GO"
    End If
  End If

  pGetNullSqlstmt = strNull
End Function

Private Function pAddColAux(ByRef ColA As T_Column) As String
  
  Dim rtn              As String

  Dim ColType As String
  ColType = LCase(ColA.ColType)
  
  Select Case ColType
    Case "decimal", "numeric"
      rtn = pAddBreaks(ColA.Name) & " " & pAddBreaks(ColType) & " (" & ColA.NumericPresicion & "," & ColA.NumericScale & ")"

    Case "varchar", "nchar", "nvarchar", "char"
      rtn = pAddBreaks(ColA.Name) & " " & pAddBreaks(ColType) & " (" & ColA.Size & ") COLLATE SQL_Latin1_General_CP1_CI_AI "
      
    Case "ntext", "text"
      rtn = pAddBreaks(ColA.Name) & " " & pAddBreaks(ColType) & " COLLATE SQL_Latin1_General_CP1_CI_AI "
      
    Case "money", "smallint", "tinyint", "int", "real", "smallmoney"
      rtn = pAddBreaks(ColA.Name) & " " & pAddBreaks(ColType) & " "
   
    Case "datetime", "smalldatetime"
      rtn = pAddBreaks(ColA.Name) & " " & pAddBreaks(ColType) & " "

    Case "image"
      rtn = pAddBreaks(ColA.Name) & " [image] "
    
    Case "bit"
      rtn = pAddBreaks(ColA.Name) & " [bit] "
      
    Case Else '"timestamp", "uniqueidentifier", "varbinary", "sql_variant"
      rtn = "<< Tipo no soportado = " & ColType & " - " & ColA.Name
  End Select

  pAddColAux = rtn
End Function

Private Function pAddColumn(ByRef ColA As T_Column, _
                            ByRef ColB As T_Column, _
                            ByVal tblName As String) As String
                            
  Dim strNull          As String
  Dim strDefault       As String
  
  strDefault = pGetDefaultSqlstmt(ColA, ColB, tblName)
  strNull = pGetNullSqlstmt(ColA, tblName)
  
  pAddColumn = " ADD " & pAddColAux(ColA) & vbCrLf & "GO" & strDefault & strNull
End Function

Private Function pAddIndex(ByVal IdxName As String, ByRef vColumns() As T_Column, ByVal tblName As String, _
                           ByVal IsUnique As Boolean, ByVal IsPrimaryKey As Boolean) As String
  Dim rtn   As String
  Dim cols  As String
  Dim i     As Long
  
  For i = 1 To UBound(vColumns)
    cols = cols & "[" & vColumns(i).Name & "]" & ","
  Next
  
  cols = RemoveLastColon(cols)
  
  rtn = "CREATE  UNIQUE  INDEX [IX_" & IdxName & "] ON [dbo].[" & tblName & "](" & cols & ") ON [PRIMARY]"
  
  pAddIndex = rtn
End Function

' Modificar
Private Function pAlterTable(ByVal tblName As String) As String
  Dim rtn As String
  
  rtn = "ALTER TABLE [" & tblName & "] "
  
  pAlterTable = rtn
End Function

Private Function pAlterColumn(ByRef ColA As T_Column, _
                              ByRef ColB As T_Column, _
                              ByVal tblName As String) As String
  
  Dim strNull          As String
  Dim strDefault       As String
  
  strDefault = pGetDefaultSqlstmt(ColA, ColB, tblName)
  strNull = pGetNullSqlstmt(ColA, tblName)
  
  pAlterColumn = " ALTER COLUMN " & pAddColAux(ColA) & vbCrLf & "GO" & strDefault & strNull
End Function

Private Function pAlterIndex(ByVal IdxName As String, ByRef vColumns() As T_Column, ByVal tblName As String, _
                             ByVal IsUnique As Boolean, ByVal IsPrimaryKey As Boolean) As String

  Dim rtn As String
  
  rtn = "DROP INDEX " & pAddBreaks(tblName) & "." & pAddBreaks(IdxName) & vbCrLf
  rtn = rtn & pAddIndex(IdxName, vColumns, tblName, IsUnique, IsPrimaryKey)

  pAlterIndex = rtn
End Function

Private Function pAddBreaks(ByVal strValue As String) As String
  pAddBreaks = "[" & strValue & "]"
End Function

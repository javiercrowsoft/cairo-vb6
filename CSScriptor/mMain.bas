Attribute VB_Name = "mMain"
Option Explicit

Public gDb As CSDataBaseClient.cDataBase

Public Sub main()
    
    Set gDb = New cDataBase
    
    FrmLogin.Show vbModal
    
    If FrmLogin.ok Then
    
      If Not gDb.InitDB(FrmLogin.TxBase, FrmLogin.TxServer, FrmLogin.TxUser, FrmLogin.TxPassword) Then
        Unload FrmLogin
        Exit Sub
      End If
    End If
    
    Unload FrmLogin
    
    
    FrmMain.Show
    
End Sub

Public Sub CloseApp()
    Set gDb = Nothing
End Sub

VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   6075
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   8670
   LinkTopic       =   "Form1"
   ScaleHeight     =   6075
   ScaleWidth      =   8670
   StartUpPosition =   3  'Windows Default
   Begin VB.ListBox List1 
      Height          =   5910
      Left            =   0
      TabIndex        =   0
      Top             =   60
      Width           =   8655
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Form_Click()
'Open connection For DBF files In F:\ folder
Dim DBConn
'Set DBConn = OpenDBFConn("D:\Proyectos\z-Clientes\Elva Santacruz\Inplex-Venado\Datos\Inplex\VT\")
Set DBConn = OpenDBFConn("\\mesalina\e\Proyectos\z-Clientes\Elva Santacruz\Inplex-Venado\Datos\Inplex\VT")

'Create a new DBF file named Persons.DBF
'DBConn.Execute "Create Table Persons (Name char(50), City char(50), Phone char(20), Zip decimal(5))"

'Insert some row To the table
'DBConn.Execute "Insert into Persons Values('Alex P. Nor', 'Mexico','458962146','14589')"

'Open recordset from Persons table
Dim Persons
Dim sqlstmt As String

sqlstmt = "SELECT [VTMV00].[NROMOV], [VTCL00].[NROCTA]" & vbCrLf & _
          "FROM VTCL00 INNER JOIN VTMV00 ON [VTCL00].[NROCTA]=[VTMV00].[NROCTA]" & vbCrLf & _
          "WHERE ((([VTCL00].[NROCTA]) Like ""  1003""));" & vbCrLf
          
'sqlstmt = "SELECT [VTMV00].*" & vbCrLf & _
          "FROM VTMV00" & vbCrLf

Set Persons = DBConn.Execute(sqlstmt)

'Output the recordset In csv format
Dim i As Integer
Dim s As String

While Not Persons.EOF
  s = ""
  For i = 0 To Persons.fields.Count - 1
    s = s & Persons.fields(i)
  Next
  List1.AddItem s
  Persons.movenext
  Me.Caption = List1.ListCount
Wend

End Sub

Function OpenDBFConn(Path)
  Dim Conn: Set Conn = CreateObject("ADODB.Connection")
  Conn.Open "Provider=Microsoft.Jet.OLEDB.4.0;" & _
                   "Data Source=" & Path & ";" & _
                   "Extended Properties=""DBASE IV;"";"
  Set OpenDBFConn = Conn
End Function




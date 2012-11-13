VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   3195
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4680
   LinkTopic       =   "Form1"
   ScaleHeight     =   3195
   ScaleWidth      =   4680
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox Text1 
      Height          =   2295
      Left            =   150
      MultiLine       =   -1  'True
      ScrollBars      =   3  'Both
      TabIndex        =   0
      Top             =   450
      Width           =   4335
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Form_Load()
    Dim o As cAssocFile
    Set o = New cAssocFile
    
    o.DontAsk = "No volver a preguntar"
    o.YesButton = "&Si"
    o.noButton = "&No"
    o.Question = "Proyecto1 no es la aplicacion por defecto encargada de editar los archivos %1." & vbCrLf & vbCrLf & "¿Desea que Proyecto1 sea el editor por defecto?."
    
    o.ValidateAssociation "csr", App.Path & "\Proyecto1.exe", "CSReport"
    
    Dim fnum As Integer, s As String, Ret
    Text1.Text = "Do not click checkbox below when running in IDE." & vbCrLf _
    & "Save it as an exe and run the exe." & vbCrLf _
    & "After the checkbox is checked," & vbCrLf _
    & "look in the application folder and" & vbCrLf _
    & "double click the Test Document.test"
    
    'see if .test file opened by double clicking
    If Command$ <> "" Then
        fnum = FreeFile
        Open Command$ For Input As fnum
        Text1.Text = Input$(LOF(fnum), #fnum)
        Close fnum
    End If
End Sub

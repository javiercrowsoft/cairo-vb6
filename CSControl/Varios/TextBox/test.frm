VERSION 5.00
Object = "*\Atextbox.vbp"
Begin VB.Form frmTest 
   Caption         =   "Form1"
   ClientHeight    =   5760
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   9480
   LinkTopic       =   "Form1"
   ScaleHeight     =   5760
   ScaleWidth      =   9480
   StartUpPosition =   3  'Windows Default
   Begin csTextBox.cTextBox cTextBox1 
      Height          =   5100
      Left            =   315
      TabIndex        =   0
      Top             =   315
      Width           =   8970
      _ExtentX        =   15822
      _ExtentY        =   8996
   End
End
Attribute VB_Name = "frmTest"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Dim words(2)                              As String
Dim colors(2)                             As String

Private Sub Form_Click()
  cTextBox1.InserText "Virginia es una capa"
End Sub

Private Sub Form_Load()
    words(0) = " sub function private public friend global property dim static as long integer boolean string do while not end loop open close "
    words(1) = " test flerp gnu cow shit jam "
    words(2) = " ranger rang3r vb harcore editor "
    colors(0) = vbWhite
    colors(1) = vbRed
    colors(2) = vbMagenta
    cTextBox1.AddLines "-------------------------------------"
    cTextBox1.AddLines "this is a small demo of my text editor"
    cTextBox1.AddLines "created by rang3r "
    cTextBox1.AddLines "-------------------------------------"
    cTextBox1.AddLines "dim a as long:dim q as string"
    cTextBox1.AddLines "do while a<10"
    cTextBox1.AddLines " a=a+1"
    cTextBox1.AddLines " print "" hello everybody .... test editor dim gnu as long "" "
    cTextBox1.AddLines " lets test this editor now..."
    cTextBox1.SelText = "hello..."
End Sub


Private Sub cTextBox1_Word(Word As csTextBox.TextWord, NewLine As Boolean)
    On Error Resume Next
    For i = 0 To UBound(words)
        If InStr(words(i), " " + LCase(Word.Word) + " ") > 0 Then
            Word.Color = colors(i)
            Word.Word = UCase(Word.Word)
            Exit Sub
        End If
    Next
End Sub


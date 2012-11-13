VERSION 5.00
Begin VB.Form fMain 
   Caption         =   "Reemplazar nombres de archivos"
   ClientHeight    =   2460
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   9075
   LinkTopic       =   "Form1"
   ScaleHeight     =   2460
   ScaleWidth      =   9075
   StartUpPosition =   3  'Windows Default
   Begin VB.CheckBox chkNameByNumber 
      Caption         =   "Generar el nombre a partir del numero"
      Height          =   315
      Left            =   2040
      TabIndex        =   7
      Top             =   1680
      Width           =   3195
   End
   Begin VB.CommandButton cmdReplace 
      Caption         =   "Reemplazar"
      Height          =   315
      Left            =   7140
      TabIndex        =   3
      Top             =   1740
      Width           =   1635
   End
   Begin VB.TextBox txtDirectory 
      Height          =   315
      Left            =   2040
      TabIndex        =   2
      Top             =   420
      Width           =   6735
   End
   Begin VB.TextBox txtToString 
      Height          =   315
      Left            =   2040
      TabIndex        =   1
      Top             =   1260
      Width           =   6735
   End
   Begin VB.TextBox txtFromString 
      Height          =   315
      Left            =   2040
      TabIndex        =   0
      Top             =   840
      Width           =   6735
   End
   Begin VB.Label Label3 
      Caption         =   "Reemplazar con"
      Height          =   255
      Left            =   660
      TabIndex        =   6
      Top             =   1320
      Width           =   1155
   End
   Begin VB.Label Label2 
      Caption         =   "Texto a Buscar"
      Height          =   255
      Left            =   660
      TabIndex        =   5
      Top             =   900
      Width           =   1155
   End
   Begin VB.Label Label1 
      Caption         =   "Carpeta"
      Height          =   255
      Left            =   660
      TabIndex        =   4
      Top             =   480
      Width           =   975
   End
End
Attribute VB_Name = "fMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'Private Sub Form_Load()
'  Dim s As String
'
'  s = Dir("Z:\Fotos01\Autopista\*.*")
'  While s <> ""
'    name s to replace(s,"auagen ","au-")
'  Wend
'End Sub

Private Sub cmdReplace_Click()
Dim i As Integer
Dim from_str As String
Dim to_str As String
Dim dir_path As String
Dim old_name As String
Dim new_name As String
Dim j        As Long

    On Error GoTo RenameError

    from_str = LCase$(txtFromString.Text)
    to_str = txtToString.Text
    j = Val(txtToString.Text)

    dir_path = txtDirectory.Text
    If Right$(dir_path, 1) <> "\" Then dir_path = dir_path _
        & "\"

    old_name = Dir$(dir_path & "*.*", vbNormal)
    Do While Len(old_name) > 0
        ' Rename this file.
        
        If chkNameByNumber.Value = vbChecked Then
        
          new_name = Format(j, "000000000") & Right(old_name, 4)
          j = j + 1
        Else
        
          new_name = Replace$(LCase$(old_name), from_str, to_str)
        
        End If
        
        If new_name <> old_name Then
            Name dir_path & old_name _
                As dir_path & new_name
            i = i + 1
        End If

        ' Get the next file.
        old_name = Dir$()
    Loop

    MsgBox "Renamed " & Format$(i) & " files."
    Exit Sub

RenameError:
    MsgBox Err.Description
End Sub

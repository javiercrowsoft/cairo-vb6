VERSION 5.00
Object = "{4229EED8-03F6-4D02-A380-811F63059FE6}#1.1#0"; "CSGrid2.ocx"
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   8985
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   10620
   LinkTopic       =   "Form1"
   ScaleHeight     =   8985
   ScaleWidth      =   10620
   StartUpPosition =   3  'Windows Default
   Begin CSGrid2.cGrid cGrid1 
      Height          =   7515
      Left            =   180
      TabIndex        =   1
      Top             =   1080
      Width           =   6735
      _ExtentX        =   11880
      _ExtentY        =   13256
      BackgroundPictureHeight=   0
      BackgroundPictureWidth=   0
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      DisableIcons    =   -1  'True
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Refrescar"
      Height          =   330
      Left            =   180
      TabIndex        =   0
      Top             =   90
      Width           =   1545
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit


Private Sub Command1_Click()
  x
End Sub

Private Sub x()
  Dim i As Integer
  Dim txt As String
  
  txt = "Un poco de texto para despabilarnos"
  txt = txt & " Si ud quiere ser millonario, el consejo es que se"
  txt = txt & " gane el quini6 o el loto, tambien puede intentar entrar"
  txt = txt & " en la politica asumiendo algun cargo publico. Al principio"
  txt = txt & " sera un cargo de poca monta, pero finalmente podra llegar"
  txt = txt & " a algo mejor."
  
  With cGrid1
  
    .Redraw = False
  
    '.RowMode = True
    ' Allow more than one row to be selected:
    .MultiSelect = True
    ' Set the default row height:
    .DefaultRowHeight = 18
    ' Outlook style for the header control:
    .HeaderFlat = True
    
    .ClearEx True, False
    .Editable = True
    
    .AddColumn "s1", "nombre"
    .ColumnEditOnClick(1) = True
    .AddColumn "s2", "codigo"
    .AddColumn "s3", "email"
    .AddColumn "s4", "edad", ecgHdrTextALignRight
    .AddColumn "s5", "nacionalidad"
    .AddColumn "s6", "sueldo", ecgHdrTextALignRight, , , , , , , "0.00"
    
    .ColumnSortType("s6") = CCLSortNumeric
    
    .AddColumn "body", "ddd", , , 96 + 256 + 96 + 96, , , , , , True
    
    .SetHeaders
    
    For i = 1 To 1
    
    .AddRow
    
    .Cell(.Rows, 1).Text = "Virginia"
    .Cell(.Rows, 2).Text = "A"
    .Cell(.Rows, 3).Text = "V@crowsoft.com"
    With .Cell(.Rows, 4)
      .Text = "24"
      .TextAlign = DT_RIGHT
    End With
    
    .Cell(.Rows, 5).Text = "Bolivia"
    
    With .Cell(.Rows, 6)
      .Text = 1200
      .TextAlign = DT_RIGHT
    End With
    
    .CellDetails .Rows, .Columns, txt, DT_WORDBREAK, , , vbBlue
    .RowHeight(.Rows) = .EvaluateTextHeight(.Rows, .Columns) + .DefaultRowHeight + 2
    
    Next
    For i = 1 To 4

    .AddRow

    .Cell(.Rows, 1).Text = "Gaston"
    .Cell(.Rows, 2).Text = "A"
    .Cell(.Rows, 3).Text = "V@crowsoft.com"
    With .Cell(.Rows, 4)
      .Text = "12"
      .TextAlign = DT_RIGHT
    End With
    .Cell(.Rows, 5).Text = "Argentina"

    With .Cell(.Rows, 6)
      .Text = 2400
      .TextAlign = DT_RIGHT
    End With

    .CellDetails .Rows, .Columns, txt, DT_WORDBREAK, , , vbBlue
    .RowHeight(.Rows) = .EvaluateTextHeight(.Rows, .Columns) + .DefaultRowHeight + 2

    Next
    For i = 1 To 4

    .AddRow

    .Cell(.Rows, 1).Text = "Maria"
    .Cell(.Rows, 2).Text = "A"
    .Cell(.Rows, 3).Text = "Virginia@crowsoft.com"
    With .Cell(.Rows, 4)
      .Text = "12"
      .TextAlign = DT_RIGHT
    End With
    .Cell(.Rows, 5).Text = "Brazil"

    With .Cell(.Rows, 6)
      .Text = 3500
      .TextAlign = DT_RIGHT
    End With

    .CellDetails .Rows, .Columns, txt, DT_WORDBREAK, , , vbBlue
    .RowHeight(.Rows) = .EvaluateTextHeight(.Rows, .Columns) + .DefaultRowHeight + 2

    Next



    For i = 1 To 4

    .AddRow

    .Cell(.Rows, 1).Text = "Jorge"
    .Cell(.Rows, 2).Text = "S"
    .Cell(.Rows, 3).Text = "Virg@crowsoft.com"
    With .Cell(.Rows, 4)
      .Text = "36"
      .TextAlign = DT_RIGHT
    End With
    .Cell(.Rows, 5).Text = "Peru"
    With .Cell(.Rows, 6)
      .Text = 900
      .TextAlign = DT_RIGHT
    End With

    .CellDetails .Rows, .Columns, txt, DT_WORDBREAK, , , vbBlue
    .RowHeight(.Rows) = .EvaluateTextHeight(.Rows, .Columns) + .DefaultRowHeight + 2

    Next


    For i = 1 To 4

    .AddRow

    .Cell(.Rows, 1).Text = "Ignacio"
    .Cell(.Rows, 2).Text = "I"
    .Cell(.Rows, 3).Text = "Ignacio@crowsoft.com"
    With .Cell(.Rows, 4)
      .Text = "41"
      .TextAlign = DT_RIGHT
    End With
    .Cell(.Rows, 5).Text = "Chile"

    With .Cell(.Rows, 6)
      .Text = 1100
      .TextAlign = DT_RIGHT
    End With

    .CellDetails .Rows, .Columns, txt, DT_WORDBREAK, , , vbBlue
    .RowHeight(.Rows) = .EvaluateTextHeight(.Rows, .Columns) + .DefaultRowHeight + 2

    Next
    For i = 1 To 4

    .AddRow

    .Cell(.Rows, 1).Text = "Ignacio"
    .Cell(.Rows, 2).Text = "I"
    .Cell(.Rows, 3).Text = "Ign@crowsoft.com"
    With .Cell(.Rows, 4)
      .Text = "41"
      .TextAlign = DT_RIGHT
    End With
    .Cell(.Rows, 5).Text = "Chipre"

    With .Cell(.Rows, 6)
      .Text = 800
      .TextAlign = DT_RIGHT
    End With

    .CellDetails .Rows, .Columns, txt, DT_WORDBREAK, , , vbBlue
    .RowHeight(.Rows) = .EvaluateTextHeight(.Rows, .Columns) + .DefaultRowHeight + 2

    Next
    For i = 1 To 4

    .AddRow

    .Cell(.Rows, 1).Text = "Ignacio"
    .Cell(.Rows, 2).Text = "G"
    .Cell(.Rows, 3).Text = "Ign@crowsoft.com"
    With .Cell(.Rows, 4)
      .Text = "4"
      .TextAlign = DT_RIGHT
    End With
    .Cell(.Rows, 5).Text = "Cuba"

    With .Cell(.Rows, 6)
      .Text = 3500
      .TextAlign = DT_RIGHT
    End With

    .CellDetails .Rows, .Columns, txt, DT_WORDBREAK, , , vbBlue
    .RowHeight(.Rows) = .EvaluateTextHeight(.Rows, .Columns) + .DefaultRowHeight + 2

    Next
    For i = 1 To 4

    .AddRow

    .Cell(.Rows, 1).Text = "Raul"
    .Cell(.Rows, 2).Text = "R"
    .Cell(.Rows, 3).Text = "Raul@crowsoft.com"
    With .Cell(.Rows, 4)
      .Text = "41"
      .TextAlign = DT_RIGHT
    End With
    .Cell(.Rows, 5).Text = "Chile"
    With .Cell(.Rows, 6)
      .Text = 3000
      .TextAlign = DT_RIGHT
    End With

    .CellDetails .Rows, .Columns, txt, DT_WORDBREAK, , , vbBlue
    .RowHeight(.Rows) = .EvaluateTextHeight(.Rows, .Columns) + .DefaultRowHeight + 2

    Next
    
    .RefreshFilters
    .RefreshGroupsAndFormulas
    .RefreshFormats
    .Redraw = True
  End With
End Sub


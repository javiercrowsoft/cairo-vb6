VERSION 5.00
Begin VB.Form fMain 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Make Index Web"
   ClientHeight    =   5805
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   8955
   Icon            =   "fMain.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   Picture         =   "fMain.frx":000C
   ScaleHeight     =   5805
   ScaleWidth      =   8955
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox txHelpName 
      Height          =   315
      Left            =   1440
      TabIndex        =   9
      Text            =   "Ayuda del Programador"
      Top             =   5340
      Width           =   7515
   End
   Begin VB.TextBox txFileTigraMenu 
      Height          =   315
      Left            =   1440
      TabIndex        =   6
      Text            =   "D:\proyectos\CSHelp\htm\Usuario\Cairo\tree_items.js"
      Top             =   4860
      Width           =   7455
   End
   Begin VB.CommandButton cmdMakeTigraMenu 
      Caption         =   "Generar Tigra Menu"
      Height          =   315
      Left            =   6780
      TabIndex        =   5
      Top             =   4440
      Width           =   2055
   End
   Begin VB.TextBox txFileHTM 
      Height          =   315
      Left            =   1440
      TabIndex        =   3
      Text            =   "D:\proyectos\CSHelp\htm\Usuario\Cairo\cairo_principal.htm"
      Top             =   3960
      Width           =   7455
   End
   Begin VB.CommandButton cmdMake 
      Caption         =   "Generar HTML"
      Height          =   315
      Left            =   6780
      TabIndex        =   2
      Top             =   3540
      Width           =   2055
   End
   Begin VB.TextBox txFileHHC 
      Height          =   315
      Left            =   1440
      TabIndex        =   1
      Text            =   "D:\proyectos\CSHelp\htm\Usuario\Cairo\cairo_principal.hhc"
      Top             =   3120
      Width           =   7455
   End
   Begin VB.Label Label4 
      Caption         =   "Nombre :"
      Height          =   255
      Left            =   120
      TabIndex        =   10
      Top             =   5400
      Width           =   1215
   End
   Begin VB.Image imgLink 
      Height          =   480
      Left            =   120
      Picture         =   "fMain.frx":3F79
      Top             =   4260
      Visible         =   0   'False
      Width           =   480
   End
   Begin VB.Label lbLink 
      BackStyle       =   0  'Transparent
      Height          =   2835
      Left            =   60
      TabIndex        =   8
      Top             =   60
      Width           =   7275
   End
   Begin VB.Label Label3 
      Caption         =   "Archivo HHC :"
      Height          =   255
      Left            =   120
      TabIndex        =   7
      Top             =   4860
      Width           =   1215
   End
   Begin VB.Label Label2 
      Caption         =   "Archivo HHC :"
      Height          =   255
      Left            =   120
      TabIndex        =   4
      Top             =   3960
      Width           =   1215
   End
   Begin VB.Label Label1 
      Caption         =   "Archivo HHC :"
      Height          =   255
      Left            =   120
      TabIndex        =   0
      Top             =   3120
      Width           =   1215
   End
End
Attribute VB_Name = "fMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub cmdMake_Click()
  On Error GoTo ControlError
  
  Dim iFileHHC As Integer
  Dim iFileHTM As Integer
  
  iFileHHC = FreeFile()
  Open txFileHHC.Text For Input As #iFileHHC
  
  iFileHTM = FreeFile()
  Open txFileHTM.Text For Output As #iFileHTM
  
  Dim strLine As String
  Dim i       As Integer
  
  Const href_begin    As String = "<a href="""
  Const href_target   As String = " target=""fraRightFrame"" >"
  Const href_end      As String = "</a>"
  Const param_name    As String = "<param name=""name"" value="""
  Const param_ref     As String = "<param name=""local"" value="""
  Const param_chm     As String = "<param name="""
  Dim len_param_name  As Integer
  Dim len_param_ref   As Integer
  
  len_param_name = Len(param_name)
  len_param_ref = Len(param_ref)
  
  Dim hrefName As String
  
  Do While Not EOF(iFileHHC)
    Line Input #iFileHHC, strLine
    Print #iFileHTM, strLine
    
    If LCase(Trim$(strLine)) = "<head>" Then
      Print #iFileHTM, "<LINK REL=""stylesheet"" MEDIA=""screen"" TYPE=""text/css"" HREF=""css/screen.css"">"
      Print #iFileHTM, "<LINK REL=""stylesheet"" MEDIA=""print"" TYPE=""text/css"" HREF=""css/print.css.css"">"
      Exit Do
    End If
  Loop
  
  While Not EOF(iFileHHC)
    
    Line Input #iFileHHC, strLine
    
    strLine = Replace$(strLine, "<OBJECT type=""text/sitemap"">", "")
    strLine = Replace$(strLine, "</OBJECT>", "")
    
    ' Busco si estoy en un nombre de Nodo
    '
    ' (un nodo puede ser un librito o una hojita [link])
    '
    i = InStr(1, LCase(strLine), param_name)
    If i Then
      hrefName = Left$(strLine, i - 1) & _
                 Mid$(strLine, _
                      i + len_param_name, _
                      Len(strLine) - 1 - (i + len_param_name))
    
      ' Vean que cuando una linea tiene un nodo
      ' no grabo en el archivo de salida (htm)
      ' hasta haber leido la siguiente linea
      '
    Else
    
      ' Determino si estoy leyendo un param_ref
      '
      ' (es el caso de las hojitas [links])
      '
      i = InStr(1, LCase(strLine), param_ref)
      If i Then
        
        ' Armo la hojita
        '
        strLine = Left$(strLine, i - 1) & _
                  href_begin & _
                  Mid$(strLine, _
                       i + len_param_ref, _
                       Len(strLine) - 1 - (i + len_param_name)) & _
                  href_target & _
                  Replace$(hrefName, vbTab, "") & href_end
                       
        Print #iFileHTM, strLine
        
        ' Vacio para no volver a guardarla
        '
        hrefName = ""
        
      ' Si no es un param_ref, es un librito
      '
      Else
      
        ' Verifico que no sea un parametro de indice
        ' para el compilador chm
        '
        i = InStr(1, LCase(strLine), param_chm)
        If i = 0 Then
          
          If Trim$(Replace$(strLine, vbTab, "")) <> "" Then
        
            ' Si tengo una etiqueta de libro pendiente
            '
            If hrefName <> "" Then
              Print #iFileHTM, hrefName
              
              ' Vacio para no volver a guardarla
              '
              hrefName = ""
            End If
            
            Print #iFileHTM, strLine
          End If
        End If
      End If
    End If
  Wend
  
  MsgBox "Listo"
  
  GoTo ExitProc
ControlError:
  MsgBox Err.Description

ExitProc:
  On Error Resume Next
  
  Close iFileHHC
  Close iFileHTM
End Sub

' Convierte una lista HTM en una
' matriz javascript para ser usada
' con el control Tree de Tigra
'
Private Sub cmdMakeTigraMenu_Click()
  On Error GoTo ControlError
  
  Dim iFileHTM As Integer
  Dim iFileJS  As Integer
  
  iFileHTM = FreeFile()
  Open txFileHTM.Text For Input As #iFileHTM
  
  iFileJS = FreeFile()
  Open txFileTigraMenu.Text For Output As #iFileJS

  Dim strRefLine  As String
  Dim strLine     As String
  Dim i           As Integer

  ' Avanzo hasta encontrar el comienzo de la lista <UL>
  '
  Do While Not EOF(iFileHTM)
    Line Input #iFileHTM, strLine
    
    If LCase(Trim$(strLine)) = "<ul>" Then
      Print #iFileJS, "var TREE_ITEMS = "
      Print #iFileJS, "["
      Print #iFileJS, vbTab & "['" & txHelpName.Text & "',null,"
      Exit Do
    End If
  Loop
  
  Const href_begin    As String = "<a href="""
  Dim len_href_begin  As Integer
  len_href_begin = Len(href_begin)
  
  Dim n As Integer
  Dim k As Integer
  Dim c  As String
  Dim c2 As String
  Dim link   As String
  Dim title  As String
  Dim bFlush As Boolean
  Dim bNode  As Boolean
  
  ' Leo toda la lista
  '
  Do While Not EOF(iFileHTM)
    
    ' Cargo una a una las lineas
    '
    Line Input #iFileHTM, strLine
    
    ' Si llegue al final salgo del bucle
    '
    If InStr(1, strLine, "</BODY>", vbTextCompare) Then Exit Do
    
    ' Los nodos pueden tener paginas asociadas
    ' en cuyo caso no hay que confundirlos con
    ' paginas
    '
    bNode = InStr(1, strLine, "<ul>", vbTextCompare)
    
    ' Elimino los tags html
    '
    strLine = Replace$(strLine, "<ul>", vbNullString, 1, , vbTextCompare)
    strLine = Replace$(strLine, "<li>", vbNullString, 1, , vbTextCompare)
    
    ' Si se termina un bloque cambio el separador
    ' html por el de javascript
    '
    strLine = Replace$(strLine, "</ul>", vbTab & "],", 1, , vbTextCompare)
    
    ' Cambio la barra windows por la barra de internet
    '
    strLine = Replace$(strLine, "\", "/")
    
    ' Elimino espacios y tabs
    '
    c = Trim$(Replace$(strLine, vbTab, vbNullString))
    
    If c <> "[" And c <> "]," Then
      
      ' Si es un href puede ser una pagina
      '
      n = InStr(1, strLine, href_begin, vbTextCompare)
      
      If n Then
      
        c = vbNullString
        k = n + len_href_begin
        c2 = Mid$(strLine, 1, n - 1)
        For n = k To Len(strLine)
          c = Mid$(strLine, n, 1)
          If c = """" Then
            link = Mid$(strLine, k, n - k)
            Exit For
          End If
        Next
        
        c = vbNullString
        k = n

        For n = k To Len(strLine)
          c = Mid$(strLine, n, 1)
          If c = ">" Then
            k = n + 1
          Else
            If c = "<" Then
              title = Trim$(Mid$(strLine, k, n - k))
              Exit For
            End If
          End If
        Next
        
        ' Vacio el buffer que contiene la linea anterior
        '
        pFlushToFile strRefLine, bNode, bFlush, iFileJS
        
        ' Guardo el buffer la linea actual para
        '
        strRefLine = c2 & "['" & title & "','" & link
        strLine = vbNullString
        
      ' Si no es una pagina, es un nodo
      '
      Else
        
        c = vbNullString
        
        ' Busco el comienzo del texto
        '
        For n = 1 To Len(strLine)
          c = Mid$(strLine, n, 1)
          If c <> vbTab And c <> " " Then
            Exit For
          End If
        Next
        
        ' Si tengo un texto agrego un
        ' inicio de bloque y el null
        '
        c = Trim$(Mid$(strLine, n))
        If c <> vbNullString Then
          strLine = Mid$(strLine, 1, n - 1) & "['" & c & "',null,"
        End If
      End If
    End If
    
    ' Si la linea actual no esta vacia
    ' prendo un flag para indicar que
    ' debo bajar al archivo la linea
    ' anterior si es que hay alguna
    '
    If strLine <> vbNullString Then
      bFlush = True
    End If
    
    If bFlush Or bNode Then
      pFlushToFile strRefLine, bNode, bFlush, iFileJS
      bNode = False
    End If

    ' Si hay una linea
    '
    If strLine <> vbNullString Then
      Print #iFileJS, strLine
    End If
  Loop
  
  Print #iFileJS, "];"
  
  MsgBox "Listo"
  
  GoTo ExitProc
ControlError:
  MsgBox Err.Description

ExitProc:
  On Error Resume Next
  
  Close iFileHTM
  Close iFileJS
End Sub

Private Sub pFlushToFile(ByRef strRefLine As String, _
                         ByVal bNode As Boolean, _
                         ByRef bFlush As Boolean, _
                         ByVal iFileJS As Integer)
                       
  ' Solo si hay algo en el buffer
  '
  If strRefLine <> vbNullString Then
    
    ' Si no era un nodo
    '
    If Not bNode Then
      strRefLine = strRefLine & "'],"
    Else
    
      ' los nodos quedan abiertos
      '
      strRefLine = strRefLine & "',"
    End If
    
    Print #iFileJS, strRefLine
  End If
  
  strRefLine = vbNullString
  bFlush = False
End Sub

Private Sub Form_Load()
  lbLink.MousePointer = vbCustom
  lbLink.MouseIcon = imgLink.Picture
End Sub

Private Sub lbLink_Click()
  MsgBox "Hola"
End Sub

Private Sub txFileHHC_Change()
  On Error Resume Next
  With txFileHHC
    txFileHTM.Text = Mid$(.Text, 1, Len(.Text) - 3) & "htm"
  End With
End Sub

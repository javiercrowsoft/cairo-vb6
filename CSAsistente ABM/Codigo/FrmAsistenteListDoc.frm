VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   5820
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   11460
   LinkTopic       =   "Form1"
   ScaleHeight     =   5820
   ScaleWidth      =   11460
   StartUpPosition =   3  'Windows Default
   Begin VB.ComboBox Combo2 
      Height          =   315
      Left            =   8640
      Style           =   2  'Dropdown List
      TabIndex        =   13
      Top             =   0
      Width           =   2760
   End
   Begin VB.ListBox List4 
      Height          =   1815
      Left            =   8640
      TabIndex        =   12
      Top             =   405
      Width           =   2760
   End
   Begin VB.TextBox Text4 
      Height          =   330
      Left            =   5805
      TabIndex        =   11
      Top             =   0
      Width           =   2760
   End
   Begin VB.ListBox List3 
      Height          =   1815
      Left            =   5805
      TabIndex        =   10
      Top             =   405
      Width           =   2760
   End
   Begin VB.TextBox Text3 
      Height          =   285
      Left            =   2970
      TabIndex        =   8
      Top             =   2655
      Width           =   2760
   End
   Begin VB.TextBox Text2 
      Height          =   285
      Left            =   2970
      TabIndex        =   6
      Top             =   2295
      Width           =   2760
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Generar"
      Height          =   285
      Left            =   45
      TabIndex        =   5
      Top             =   2295
      Width           =   1455
   End
   Begin VB.TextBox Text1 
      Height          =   330
      Left            =   90
      TabIndex        =   4
      Top             =   0
      Width           =   2805
   End
   Begin VB.ListBox List2 
      Height          =   1815
      Left            =   2970
      TabIndex        =   3
      Top             =   405
      Width           =   2760
   End
   Begin VB.ComboBox Combo1 
      Height          =   315
      Left            =   2970
      Style           =   2  'Dropdown List
      TabIndex        =   2
      Top             =   0
      Width           =   2760
   End
   Begin VB.ListBox List1 
      Height          =   1815
      Left            =   90
      TabIndex        =   1
      Top             =   405
      Width           =   2805
   End
   Begin VB.TextBox txtResultado 
      BeginProperty Font 
         Name            =   "Courier New"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   2355
      Left            =   45
      MultiLine       =   -1  'True
      ScrollBars      =   3  'Both
      TabIndex        =   0
      Top             =   3240
      Width           =   5652
   End
   Begin VB.Label Label2 
      Caption         =   "Nombre Tabla"
      Height          =   240
      Left            =   1710
      TabIndex        =   9
      Top             =   2700
      Width           =   1230
   End
   Begin VB.Label Label1 
      Caption         =   "Prefijo Tabla"
      Height          =   240
      Left            =   1980
      TabIndex        =   7
      Top             =   2340
      Width           =   960
   End
   Begin VB.Line Line1 
      X1              =   45
      X2              =   5805
      Y1              =   3060
      Y2              =   3060
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Const adhock = 1
Private Const check = 2
Private Const Clave = 3
Private Const fecha = 4
Private Const help = 6
Private Const lista = 7
Private Const numero = 8
Private Const opcion = 9
Private Const texto = 10

Private m_NextClave       As Integer
Private m_K As String
Private m_Miembro         As String
Private m_PropertyChange  As String
Private m_Refresh         As String
Private m_Save            As String
Private m_LoadCollection As String
Private m_LoadTrue      As String
Private m_LoadFalse     As String
Private m_LoadHelp      As String
Private m_LoadDate      As String

Private Sub Combo1_KeyPress(KeyAscii As Integer)
  Text1_KeyPress KeyAscii
End Sub

Private Sub Command1_Click()
  Dim i As Integer
  
  m_NextClave = 1
  m_K = ""
  m_Miembro = ""
  m_PropertyChange = ""
  m_Refresh = ""
  m_Save = ""
  m_LoadCollection = ""
  m_LoadTrue = ""
  m_LoadFalse = ""
  m_LoadHelp = ""
  m_LoadDate = ""
  
  For i = 0 To List1.ListCount - 1
    GenerarK List1.List(i)
    GenerarMiembros List1.List(i), List2.ItemData(i)
    GenerarPropertyChange List1.List(i), List2.ItemData(i)
    GenerarRefresh List1.List(i), List2.ItemData(i)
    GenerarSave List1.List(i), List2.ItemData(i), i
    GenerarLoadCollection List1.List(i), List2.ItemData(i), List3.List(i), List4.ItemData(i)
    GenerarLoad List1.List(i), List2.ItemData(i), List3.List(i), List4.ItemData(i)
  Next
  
  txtResultado.Text = m_K & vbCrLf & m_Miembro & vbCrLf & GetPropertyChange & vbCrLf & GetRefresh & vbCrLf & GetSave & vbCrLf & GetLoadCollection & vbCrLf & GetLoad
  
End Sub

Private Sub Form_Load()
  With Combo1
    .AddItem "adhock"
    .ItemData(.NewIndex) = adhock
    .AddItem "check"
    .ItemData(.NewIndex) = check
    .AddItem "clave"
    .ItemData(.NewIndex) = Clave
    .AddItem "fecha"
    .ItemData(.NewIndex) = fecha
    .AddItem "help"
    .ItemData(.NewIndex) = help
    .AddItem "lista"
    .ItemData(.NewIndex) = lista
    .AddItem "numero"
    .ItemData(.NewIndex) = numero
    .AddItem "opcion"
    .ItemData(.NewIndex) = opcion
    .AddItem "texto"
    .ItemData(.NewIndex) = texto
  End With
  
  With Combo2
    .AddItem "M"
    .ItemData(.NewIndex) = 0
    .AddItem "F"
    .ItemData(.NewIndex) = 1
  End With
  
  Text1.Text = "FechaIni"
  Text4.Text = "Fecha desde"
  Combo1.ListIndex = 3
  Text1_KeyPress vbKeyReturn

  Text1.Text = "FechaFin"
  Text4.Text = "Fecha hasta"
  Combo1.ListIndex = 3
  Text1_KeyPress vbKeyReturn
  
  Text1.Text = "Activo"
  Text4.Text = "Activo"
  Combo1.ListIndex = 5
  Combo2.ListIndex = 0
  Text1_KeyPress vbKeyReturn
  
End Sub

Private Sub Form_Resize()
  On Error Resume Next
  txtResultado.Move 120, txtResultado.Top, Me.ScaleWidth - txtResultado.Left * 2, Me.ScaleHeight - txtResultado.Top - 60
End Sub

Private Sub List1_DblClick()
  On Error Resume Next
  List2.RemoveItem List1.ListIndex
  List3.RemoveItem List1.ListIndex
  List4.RemoveItem List1.ListIndex
  List1.RemoveItem List1.ListIndex
End Sub

Private Sub Text1_KeyPress(KeyAscii As Integer)
  If vbKeyReturn = KeyAscii Then
  
    If Combo1.ListIndex = -1 Then MsgBox "Debe seleccionar un tipo de dato": Exit Sub
  
    If List1.ListIndex <> -1 Then
      List1.AddItem Text1.Text, List1.ListIndex
      List2.AddItem Combo1.Text, List1.ListIndex
      List3.AddItem Text4.Text, List1.ListIndex
      If Combo2.ListIndex > -1 Then
        List4.AddItem Combo2.Text, List1.ListIndex
        List2.ItemData(List2.NewIndex) = Combo2.ItemData(Combo2.ListIndex)
      Else
        List4.AddItem "M", List1.ListIndex
        List2.ItemData(List2.NewIndex) = 0
      End If
    Else
      List1.AddItem Text1.Text
      List2.AddItem Combo1.Text
      List3.AddItem Text4.Text
      If Combo2.ListIndex > -1 Then
        List4.AddItem Combo2.Text
        List2.ItemData(List2.NewIndex) = Combo2.ItemData(Combo2.ListIndex)
      Else
        List4.AddItem "M"
        List2.ItemData(List2.NewIndex) = 0
      End If
    End If
    List2.ItemData(List2.NewIndex) = Combo1.ItemData(Combo1.ListIndex)
    
  End If
End Sub

Private Sub GenerarK(ByVal Nombre As String)
  m_K = m_K & "Private Const K_" & UCase(Nombre) & String(30 - Len(Nombre), " ") & " As Integer =" & m_NextClave & vbCrLf
  m_NextClave = m_NextClave + 1
End Sub

Private Sub GenerarMiembros(ByVal Nombre As String, ByVal Tipo As Integer)
  m_Miembro = m_Miembro & "Private m_" & Nombre & String(30 - Len(Nombre), " ") & " As " & GetDataType(Tipo) & vbCrLf
End Sub

Private Function GetDataType(ByVal Tipo As Integer)
  Select Case Tipo
    Case adhock
      GetDataType = "long"
    Case check
      GetDataType = "boolean"
    Case Clave
      GetDataType = "string"
    Case fecha
      GetDataType = "date"
    Case help
      GetDataType = "long"
    Case lista
      GetDataType = "long"
    Case numero
      GetDataType = "double"
    Case opcion
      GetDataType = "integer"
    Case texto
      GetDataType = "string"
  End Select
End Function

Private Sub GenerarPropertyChange(ByVal Nombre As String, ByVal Tipo As Integer)
  Dim s As String
  
  s = s & "    Case K_" & Nombre & vbCrLf
  
  Select Case Tipo
    Case adhock
      s = s & "      m_" & Nombre & " = m_ObjAbm.Properties(" & GetFieldName(Nombre) & ").Value" & vbCrLf
    Case check
      s = s & "      m_" & Nombre & " = m_ObjAbm.Properties(" & GetFieldName(Nombre) & ").Value" & vbCrLf
    Case Clave
      s = s & "      m_" & Nombre & " = m_ObjAbm.Properties(" & GetFieldName(Nombre) & ").Value" & vbCrLf
    Case fecha
      s = s & "      If IsDate(m_ObjAbm.Properties(" & GetFieldName(Nombre) & ").Value) Then" & vbCrLf
      s = s & "        m_" & Nombre & " = m_ObjAbm.Properties(" & GetFieldName(Nombre) & ").Value" & vbCrLf
      s = s & "      Else" & vbCrLf
      s = s & "        m_ObjAbm.Properties(" & GetFieldName(Nombre) & ").Value = m_" & Nombre & vbCrLf
      s = s & "      End If" & vbCrLf
    Case help
      s = s & "      m_" & Nombre & " = m_ObjAbm.Properties(?? " & Nombre & ").Value" & vbCrLf
    Case lista
      s = s & "      m_" & Nombre & " = m_ObjAbm.Properties(" & GetFieldName(Nombre) & ").Value" & vbCrLf
    Case numero
      s = s & "      m_" & Nombre & " = m_ObjAbm.Properties(" & GetFieldName(Nombre) & ").Value" & vbCrLf
    Case opcion
      s = s & "      m_" & Nombre & " = m_ObjAbm.Properties(" & GetFieldName(Nombre) & ").Value" & vbCrLf
    Case texto
      s = s & "      m_" & Nombre & " = m_ObjAbm.Properties(" & GetFieldName(Nombre) & ").Value" & vbCrLf
  End Select
  
  
  m_PropertyChange = m_PropertyChange & s & vbCrLf
End Sub

Private Function GetPropertyChange() As String
  Dim s As String
  
  s = "Private Function cIABMListDocClient_PropertyChange(ByVal Key As Integer) As Boolean" & vbCrLf & vbCrLf
  s = s & "   Select Case Key" & vbCrLf & vbCrLf
  
  s = s & m_PropertyChange
  
  s = s & "   End Select" & vbCrLf & vbCrLf
  s = s & "   cIABMListDocClient_PropertyChange = True" & vbCrLf
  s = s & "End Sub" & vbCrLf

  GetPropertyChange = s
End Function

Private Function GetFieldName(ByVal Nombre As String) As String
  If LCase(Nombre) = "activo" Then
    GetFieldName = Text2.Text & Nombre
  Else
    GetFieldName = "csc" & Nombre
  End If
End Function

Private Sub GenerarRefresh(ByVal Nombre As String, ByVal Tipo As Integer)
  Dim s As String
  
  m_Refresh = m_Refresh & vbCrLf
  
  Select Case Tipo
    Case fecha
      s = s & "  sqlstmt = sqlstmt & gDB.sqlDate(m_" & Nombre & ") & "","""
    Case numero, help, check, lista, opcion, adhock
      s = s & "  sqlstmt = sqlstmt & m_" & Nombre & " & "","""
    Case texto, Clave
      s = s & "  sqlstmt = sqlstmt & ""'"" & m_" & Nombre & " & ""',"""
  End Select
      
  m_Refresh = m_Refresh & s
End Sub

Private Function GetRefresh() As String
  Dim s As String
  
  s = s & "Private Function cIABMListDocClient_Refresh() As String" & vbCrLf
  s = s & "  Dim sqlstmt As String" & vbCrLf & vbCrLf
  s = s & "  sqlstmt = ""sp_lsdoc_" & Text3.Text & " """ & vbCrLf
  
  s = s & RemoveLastComa(m_Refresh) & vbCrLf & vbCrLf
      
  s = s & "  cIABMListDocClient_Refresh = sqlstmt" & vbCrLf
  s = s & "End Function" & vbCrLf
  
  GetRefresh = s
End Function

Private Function RemoveLastComa(ByVal s As String) As String
  If Right(s, 5) = "& "",""" Then s = Left(s, Len(s) - 5)
  RemoveLastComa = s
End Function

Private Sub GenerarSave(ByVal Nombre As String, ByVal Tipo As Integer, ByVal Orden As Integer)
  Dim s As String
  
  s = s & "                Case K_" & Nombre & vbCrLf
  s = s & "                    register.Fields.Add2 cscldpValor, .Value, csText" & vbCrLf
  s = s & "                    register.Fields.Add2 cscldpOrden, " & (Orden + 1) * 10 & ", csInteger" & vbCrLf
  s = s & "                    register.Fields.Add2 cscldpId, K_" & Nombre & ", csInteger" & vbCrLf

  m_Save = m_Save & s
End Sub

Private Function GetSave() As String
  Dim s As String
  
  s = s & "Private Function cIABMListDocClient_Save() As Boolean" & vbCrLf
  s = s & "    Dim register As cRegister" & vbCrLf
  s = s & "    Set register = New cRegister" & vbCrLf & vbCrLf
      
  s = s & "    Dim sqlstmt As String" & vbCrLf
  s = s & "    sqlstmt = ""delete "" & csTListaDocumentoParametro" & vbCrLf
  s = s & "    sqlstmt = sqlstmt & "" where """ & vbCrLf
  s = s & "    sqlstmt = sqlstmt & "" pre_id = "" & csPre" & Text3.Text & "Lista" & Text3.Text & vbCrLf
  s = s & "    sqlstmt = sqlstmt & "" And us_id = "" & m_us_id" & vbCrLf & vbCrLf
  
  s = s & "    If Not gDB.Execute(sqlstmt, ""cIABMClient_Save"", ""c" & Text3.Text & """, ""Error al grabar " & Text3.Text & """) Then Exit Function" & vbCrLf & vbCrLf
      
  s = s & "    register.Tabla = csTListaDocumentoParametro" & vbCrLf
  s = s & "    register.UtilizaIdentity = True" & vbCrLf & vbCrLf
      
  s = s & "    Dim IPropiedad As cIABMProperty" & vbCrLf
  s = s & "    For Each IPropiedad In m_ObjAbm.Properties" & vbCrLf & vbCrLf
          
  s = s & "        register.Fields.Clear" & vbCrLf & vbCrLf
          
  s = s & "        With IPropiedad" & vbCrLf
  s = s & "            Select Case .Key" & vbCrLf & vbCrLf
  
  s = s & m_Save & vbCrLf
  
  s = s & "            End Select" & vbCrLf
              
  s = s & "            register.Fields.Add2 cscUsId, m_us_id, csId" & vbCrLf
  s = s & "            register.Fields.Add2 cscPreID, & csPre" & Text3.Text & "Lista" & Text3.Text & ", csId" & vbCrLf & vbCrLf
    
  s = s & "            register.Fields.HaveLastUpdate = False" & vbCrLf
  s = s & "            register.Fields.HaveWhoModify = False" & vbCrLf
  s = s & "            If Not gDB.Save(register, , ""cIABMClient_Save"", ""c" & Text3.Text & """, ""Error al grabar " & Text3.Text & """) Then Exit Function" & vbCrLf
  s = s & "        End With" & vbCrLf
  s = s & "    Next" & vbCrLf
  s = s & "    If Not Load(m_us_id) Then Exit Function" & vbCrLf & vbCrLf
      
  s = s & "    cIABMListDocClient_Save = True" & vbCrLf
  s = s & "End Function" & vbCrLf
  
  GetSave = s
End Function

Private Sub GenerarLoadCollection(ByVal Nombre As String, ByVal Tipo As Integer, ByVal Nombre2 As String, ByVal Genero As Integer)
  Dim s As String

  Select Case Tipo
    Case fecha
      s = s & "    Set c = m_ObjAbm.Properties.Add(c, csc" & Text2.Text & Nombre & ")" & vbCrLf
      s = s & "    c.PropertyType = cspDate" & vbCrLf
      s = s & "    c.Name = """ & Nombre2 & """" & vbCrLf
      s = s & "    c.Key = K_" & Nombre & vbCrLf
      s = s & "    c.Value = m_Fechaini" & vbCrLf
      s = s & "    Set c = Nothing" & vbCrLf & vbCrLf
    
    Case texto
      s = s & "    Set c = m_ObjAbm.Properties.Add(c, csc" & Text2.Text & Nombre & ")" & vbCrLf
      s = s & "    c.PropertyType = cspText" & vbCrLf
      s = s & "    c.Name = """ & Nombre2 & """" & vbCrLf
      s = s & "    c.Size = " & vbCrLf
      s = s & "    c.Key = K_" & Nombre & vbCrLf
      s = s & "    c.Value = m_" & Nombre & vbCrLf
      s = s & "    Set c = Nothing" & vbCrLf & vbCrLf
    
    Case check
      s = s & "  Set c = m_ObjAbm.Properties.Add(c, csc" & Text2.Text & Nombre & ")" & vbCrLf
      s = s & "  c.PropertyType = cspCheck" & vbCrLf
      s = s & "  c.Name = """ & Nombre2 & """" & vbCrLf
      s = s & "  c.Key = K_" & Nombre & vbCrLf
      s = s & "  c.Value = CInt(m_" & Nombre2 & ")" & vbCrLf
      s = s & "  Set c = Nothing" & vbCrLf & vbCrLf
    
    Case numero
      s = s & "  Set c = m_ObjAbm.Properties.Add(c, csc" & Text2.Text & Nombre & ")" & vbCrLf
      s = s & "  c.PropertyType = cspNumeric" & vbCrLf
      s = s & "  c.Name = """ & Nombre2 & """" & vbCrLf
      s = s & "  c.SubType = " & vbCrLf
      s = s & "  c.Key = K_" & Nombre & vbCrLf
      s = s & "  c.Value = m_" & Nombre & vbCrLf
      s = s & "  Set c = Nothing" & vbCrLf & vbCrLf
    
    Case lista
      s = s & "    Set c = m_ObjAbm.Properties.Add(c, csc" & Text2.Text & Nombre & ")" & vbCrLf
      s = s & "    c.PropertyType = cspList" & vbCrLf
      s = s & "    c.Name = """ & Nombre2 & """" & vbCrLf
      s = s & "    c.Key = K_" & Nombre & vbCrLf
      s = s & "    c.Value = m_" & Nombre & vbCrLf & vbCrLf
          
      s = s & "      Set o = New CSABMInterface.cABMListaItem" & vbCrLf
      s = s & "      o.Id = csTriLogicState.csTLBoth" & vbCrLf
      s = s & "      o.Value = ""Amb" & IIf(Genero = 0, "o", "a") & "s""" & vbCrLf
      s = s & "      c.List.Add o, csTriLogicState.csTLBoth" & vbCrLf & vbCrLf
          
      s = s & "      Set o = New CSABMInterface.cABMListaItem" & vbCrLf
      s = s & "      o.Id = csTriLogicState.csTLNo" & vbCrLf
      s = s & "      o.Value = ""Pendientes""" & vbCrLf
      s = s & "      c.List.Add o, csTriLogicState.csTLNo" & vbCrLf & vbCrLf
          
      s = s & "      Set o = New CSABMInterface.cABMListaItem" & vbCrLf
      s = s & "      o.Id = csTriLogicState.csTLYes" & vbCrLf
      s = s & "      o.Value = ""Finalizad" & IIf(Genero = 0, "o", "a") & "s""" & vbCrLf
      s = s & "      c.List.Add o, csTriLogicState.csTLYes" & vbCrLf
      s = s & "    Set c = Nothing" & vbCrLf & vbCrLf
        
    Case help
      s = s & "    Set c = m_ObjAbm.Properties.Add(c, csc" & Text2.Text & Nombre & ")" & vbCrLf
      s = s & "    c.PropertyType = cspHelp" & vbCrLf
      s = s & "    c.Table = " & vbCrLf
      s = s & "    c.Name = """ & Nombre2 & """" & vbCrLf
      s = s & "    c.Key = K_" & Nombre & vbCrLf
      s = s & "    c.Value = m_" & Nombre & vbCrLf
      s = s & "    c.HelpId = m_" & Nombre & vbCrLf
      s = s & "    Set c = Nothing" & vbCrLf & vbCrLf
  End Select
  
  m_LoadCollection = m_LoadCollection & s
End Sub

Private Function GetLoadCollection() As String
  Dim s As String
  
  s = s & "Private Function LoadCollection() As Boolean" & vbCrLf
  s = s & "    m_ObjAbm.Properties.Clear" & vbCrLf & vbCrLf
    
  s = s & "    Dim c As cIABMProperty" & vbCrLf
  s = s & "    Dim o As cIABMListItem" & vbCrLf & vbCrLf
  
  s = s & m_LoadCollection & vbCrLf
  
  s = s & "    If Not m_ObjAbm.Show(Me, m_ObjList) Then Exit Function" & vbCrLf & vbCrLf
    
  s = s & "    LoadCollection = True" & vbCrLf
  s = s & "End Function" & vbCrLf
  
  GetLoadCollection = s
End Function

Private Sub GenerarLoad(ByVal Nombre As String, ByVal Tipo As Integer, ByVal Nombre2 As String, ByVal Genero As Integer)
  Dim s As String
  
  Select Case Tipo
    Case fecha
      s = s & "      m_" & Nombre & " = Date"
      
      m_LoadDate = m_LoadDate & "      m_" & Nombre & " = IIf(m_" & Nombre & " <> csNoFecha, m_" & Nombre & ", Date)" & vbCrLf
      
    Case texto
      s = s & "      m_" & Nombre & " = """""
      
    Case check
      s = s & "      m_" & Nombre & " = False"
      
    Case numero
      s = s & "      m_" & Nombre & " = 0"
    
    Case lista
      s = s & "      m_" & Nombre & " = csTriLogicState.csTLBoth"
      
    Case help
      s = s & "      m_" & Nombre & " = csNO_ID" & vbCrLf
      s = s & "      m_" & Nombre2 & " = """""
  
      m_LoadHelp = m_LoadHelp & "      If Not gDB.GetDato(csT, csc Id, m_" & Nombre & "_id, csc Nombre, Dato, ""cIABMClient_Save"", ""c" & Text3.Text & """, ""Error al Load " & Text3.Text & """) Then Exit Function" & vbCrLf
      m_LoadHelp = m_LoadHelp & "      m_Nombre2 = Dato" & vbCrLf
  End Select
  
  m_LoadTrue = m_LoadTrue & vbCrLf & s
  
  If Tipo = fecha Then
    s = "          Case K_" & Nombre & vbCrLf
    s = s & "            m_" & Nombre & " = IIf(IsDate(gDB.ValField(rs.fields,cscldpValor)), gDB.ValField(rs.fields,cscldpValor), Date)"
  Else
    s = "          Case K_" & Nombre & vbCrLf
    s = s & "            m_" & Nombre & " = Val(gDB.ValField(rs.fields,cscldpValor))"
  End If
  
  m_LoadFalse = m_LoadFalse & vbCrLf & s
  
End Sub

Private Function GetLoad() As String
  Dim s As String

  s = s & "Private Function Load(ByVal us_id) As Boolean" & vbCrLf
  s = s & "    Dim sqlstmt As String" & vbCrLf & vbCrLf
    
  s = s & "    sqlstmt = ""select * from "" & csTListaDocumentoParametro" & vbCrLf
  s = s & "    sqlstmt = sqlstmt & "" where """ & vbCrLf
  s = s & "    sqlstmt = sqlstmt & cscUsId & "" = "" & us_id & "" And """ & vbCrLf
  s = s & "    sqlstmt = sqlstmt & cscPreID & "" = "" & & csPre" & Text3.Text & "Lista" & Text3.Text & vbCrLf
  s = s & "    sqlstmt = sqlstmt & "" order by "" & cscldpOrden" & vbCrLf & vbCrLf
    
  s = s & "    Dim rs As Recordset" & vbCrLf & vbCrLf
    
  s = s & "    If Not gDB.OpenRs(sqlstmt, rs, csRsstatic, csLockReadOnly, csCmdText, ""Load"", ""c" & Text3.Text & "ListDoc"") Then Exit Function" & vbCrLf & vbCrLf
    
  s = s & "    If rs.EOF Then" & vbCrLf

  s = s & m_LoadTrue & vbCrLf
  
  s = s & "    Else" & vbCrLf & vbCrLf
    
  s = s & "      rs.MoveLast" & vbCrLf
  s = s & "      rs.MoveFirst" & vbCrLf & vbCrLf
      
      
  s = s & "      Dim i As Integer" & vbCrLf
  s = s & "      While Not rs.EOF" & vbCrLf & vbCrLf

  s = s & "        Select Case gDB.ValField(rs.fields,cscldpId)" & vbCrLf
  
  s = s & m_LoadFalse & vbCrLf
  
  s = s & "        End Select" & vbCrLf & vbCrLf
        
  s = s & "        rs.MoveNext" & vbCrLf
  s = s & "      Wend" & vbCrLf & vbCrLf

  s = s & "      Dim Dato As String" & vbCrLf & vbCrLf
  
  s = s & m_LoadDate & vbCrLf
      
  s = s & m_LoadHelp & vbCrLf

  s = s & "    End If" & vbCrLf & vbCrLf

  s = s & "    Load = True" & vbCrLf & vbCrLf

  s = s & "End Function" & vbCrLf

  GetLoad = s
End Function

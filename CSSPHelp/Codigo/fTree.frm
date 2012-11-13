VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Begin VB.Form fTree 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Dependencias"
   ClientHeight    =   6285
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   4680
   Icon            =   "fTree.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   6285
   ScaleWidth      =   4680
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton cmdMakeHtml 
      Caption         =   "Generar HTML"
      Height          =   315
      Left            =   600
      TabIndex        =   2
      Top             =   5880
      Width           =   1890
   End
   Begin MSComctlLib.ImageList imgTree 
      Left            =   2040
      Top             =   1800
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483643
      ImageWidth      =   16
      ImageHeight     =   16
      MaskColor       =   12632256
      _Version        =   393216
      BeginProperty Images {2C247F25-8591-11D1-B16A-00C0F0283628} 
         NumListImages   =   7
         BeginProperty ListImage1 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fTree.frx":000C
            Key             =   ""
         EndProperty
         BeginProperty ListImage2 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fTree.frx":05A6
            Key             =   ""
         EndProperty
         BeginProperty ListImage3 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fTree.frx":0B40
            Key             =   ""
         EndProperty
         BeginProperty ListImage4 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fTree.frx":10DA
            Key             =   ""
         EndProperty
         BeginProperty ListImage5 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fTree.frx":1674
            Key             =   ""
         EndProperty
         BeginProperty ListImage6 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fTree.frx":1C0E
            Key             =   ""
         EndProperty
         BeginProperty ListImage7 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fTree.frx":1FA8
            Key             =   ""
         EndProperty
      EndProperty
   End
   Begin VB.CommandButton cmdMakeXml 
      Caption         =   "Generar XML"
      Height          =   315
      Left            =   2625
      TabIndex        =   1
      Top             =   5880
      Width           =   1890
   End
   Begin MSComctlLib.TreeView tvSp 
      Height          =   5640
      Left            =   75
      TabIndex        =   0
      Top             =   75
      Width           =   4515
      _ExtentX        =   7964
      _ExtentY        =   9948
      _Version        =   393217
      Style           =   7
      Appearance      =   1
   End
End
Attribute VB_Name = "fTree"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Const c_offset = 20

Private m_blnBreak As Boolean

Private Sub cmdMakeHtml_Click()
  Dim iFile       As Integer
  Dim pathDesktop As String
  Dim Node        As Node
      
  m_blnBreak = False
  
  pCreateHtmlBody

  pathDesktop = GetSpecialFolder(CSIDL_DESKTOPFOLDER, Me.hwnd)
  
  iFile = FreeFile
  Open pathDesktop & "\dependencies.htm" For Append As #iFile
  
  Set Node = tvSp.Nodes(1).Child
  
  pAddSp Node, iFile, 0
  
  Close #iFile
  
  pCloseHtmlBody
  
  EditFile pathDesktop & "\dependencies.htm", Me.hwnd
End Sub

Private Sub cmdMakeXml_Click()
    
    Dim element     As MSXML2.IXMLDOMNode
    Dim xml         As MSXML2.DOMDocument
    Dim pathDesktop As String
    Dim Node        As Node
    
    Set xml = New MSXML2.DOMDocument
        
    pathDesktop = GetSpecialFolder(CSIDL_DESKTOPFOLDER, Me.hwnd)
    
    Set element = xml.createNode(NODE_ELEMENT, "Root", "")
    
    Set Node = tvSp.Nodes(1)
    
    pAddNode xml, element, Node
    
    xml.appendChild element
    
    xml.save pathDesktop & "\dependencies.xml"
    
    Set xml = Nothing
    
    EditFile pathDesktop & "\dependencies.xml", Me.hwnd
End Sub

Private Sub pAddNode(ByRef xml As MSXML2.DOMDocument, _
                     ByRef elementFather As MSXML2.IXMLDOMNode, _
                     ByRef nodeFather As Node)
    
    Dim spElement     As MSXML2.IXMLDOMNode
    Dim objAttrib     As MSXML2.IXMLDOMAttribute
    Dim Node          As Node
    Dim element       As MSXML2.IXMLDOMNode
    
    Set element = elementFather
    Set Node = nodeFather
    
    While Not Node Is Nothing
        
        Set spElement = xml.createNode(NODE_ELEMENT, "SP", "")
        element.appendChild spElement
        
        Set objAttrib = xml.createAttribute("Name")
        objAttrib.Text = Node.Text
        
        spElement.Attributes.setNamedItem objAttrib
        
        If Node.children Then
          pAddNode xml, spElement, Node.Child
        End If
        
        Set Node = Node.Next
    Wend

End Sub

Private Sub Form_Load()
  Center Me
  
  With tvSp
    .Style = tvwTreelinesPlusMinusPictureText
    .LabelEdit = tvwManual
    .Indentation = 200
    .LineStyle = tvwRootLines
    Set .ImageList = imgTree
  End With
End Sub

Private Sub pCreateHtmlBody()
  Dim iFile As Integer
  Dim pathDesktop As String
      
  pathDesktop = GetSpecialFolder(CSIDL_DESKTOPFOLDER, Me.hwnd)
  
  iFile = FreeFile
  Open pathDesktop & "\dependencies.htm" For Output As #iFile
  
  Print #iFile, "<html><head><link href=""./images/screen.css"" rel=""stylesheet"" type=""text/css""></head><body><table boder=0 cellspacing=0 cellpadding=0>"
  
  Close #iFile
End Sub

Private Sub pCloseHtmlBody()
  Dim iFile As Integer
  Dim pathDesktop As String
      
  pathDesktop = GetSpecialFolder(CSIDL_DESKTOPFOLDER, Me.hwnd)
  
  iFile = FreeFile
  Open pathDesktop & "\dependencies.htm" For Append As #iFile
  
  Print #iFile, "</table></body></html>"
  
  Close #iFile
End Sub

Private Sub pAddSp(ByRef Node As Node, _
                   ByVal iFile As Integer, _
                   ByVal iLeft As Integer)
  
  Dim strColsB As String
  Dim strColsE As String
  Dim i        As Integer
  Dim vTdsB()  As String
  Dim vTdsE()  As String
  Dim strImage As String
  
  iLeft = iLeft + 1
  
  ReDim vTdsB(iLeft)
  ReDim vTdsE(iLeft)
  
  For i = 1 To iLeft - 1
    vTdsB(i) = "<td>&nbsp;"
    vTdsE(i) = "</td>"
  Next
  
  vTdsB(iLeft) = "<td colspan=" & c_offset - iLeft & ">"
  vTdsE(iLeft) = "</td>"
  
  strColsB = Join(vTdsB)
  strColsE = Join(vTdsE)
  
  While Not Node Is Nothing
      
    Select Case Node.Image
      Case 5
        strImage = "<img src=""./images/folder.gif"">&nbsp;&nbsp;"
      Case 6
        strImage = "<img src=""./images/table.gif"">&nbsp;&nbsp;"
      Case 7
        strImage = "<img src=""./images/sp.gif"">&nbsp;&nbsp;"
      Case Else
        If m_blnBreak Then
          Print #iFile, "<tr>" & strColsB & "<font color=""grey"">" & String$(50, "_") & "<br><br>" & strColsE & "</tr>"
        Else
          m_blnBreak = True
        End If
        strImage = "<img src=""./images/cubito.gif"">&nbsp;&nbsp;"
    End Select
    
    Print #iFile, "<tr>" & strColsB & strImage & Node.Text & strColsE & "</tr>"
      
    If Node.children Then
      pAddSp Node.Child, iFile, iLeft
    End If
    
    Set Node = Node.Next
  Wend
  
  iLeft = iLeft - 1

End Sub

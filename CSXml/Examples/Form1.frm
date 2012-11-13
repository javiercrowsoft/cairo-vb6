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
   Begin VB.CommandButton cmdGetBinary 
      Caption         =   "cmdGetBinary"
      Height          =   495
      Left            =   120
      TabIndex        =   1
      Top             =   660
      Width           =   1215
   End
   Begin VB.CommandButton cmdCreateXML 
      Caption         =   "cmdCreateXML "
      Height          =   495
      Left            =   120
      TabIndex        =   0
      Top             =   60
      Width           =   1215
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' How to create XML with binary data
'
' General program flows:
'
' Build  builds a small XML file from a MS Doc file
' Write  saves XML tree to a file
' Write the MS Doc file as another file
'
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'Use the version dependent progid DOMDocument40 to create an MSXML 4.0 DOMDocument
'object if your are referencing MSXML 4.0 in your project.

Option Explicit
Dim oDoc As DOMDocument
Dim DOCINPATH As String
Dim XMLOUTPATH As String
Dim DOCOUTPATH As String

Private Sub cmdCreateXML_Click()
    
    Dim oEle As IXMLDOMElement
    Dim oRoot As IXMLDOMElement
    Dim oNode As IXMLDOMNode
        
    DOCINPATH = App.Path & "\DocInput.doc"
    XMLOUTPATH = App.Path & "\XmlOuput.xml"
          
    Call ReleaseObjects
    
    Set oDoc = New DOMDocument
    oDoc.resolveExternals = True
    
' Create processing instruction and document root
    Set oNode = oDoc.createProcessingInstruction("xml", "version='1.0'")
    Set oNode = oDoc.insertBefore(oNode, oDoc.childNodes.Item(0))
    
' Create document root
    Set oRoot = oDoc.createElement("Root")
    Set oDoc.documentElement = oRoot
    oRoot.setAttribute "xmlns:dt", "urn:schemas-microsoft-com:datatypes"

' Add a few simple nodes with different datatypes
    Set oNode = oDoc.createElement("Document")
    oNode.Text = "Demo"
    oRoot.appendChild oNode
    
    Set oNode = oDoc.createElement("CreateDate")
    oRoot.appendChild oNode
    Set oEle = oNode
    
' Use DataType so MSXML will validate the data type
    oEle.dataType = "date"
         
    oEle.nodeTypedValue = Now
    
    Set oNode = oDoc.createElement("bgColor")
    oRoot.appendChild oNode
    Set oEle = oNode
    
' Use DataType so MSXML will validate the data type
    oEle.dataType = "bin.hex"
         
    oEle.Text = &HFFCCCC
    
    Set oNode = oDoc.createElement("Data")
    oRoot.appendChild oNode
    Set oEle = oNode
    
' Use DataType so MSXML will validate the data type
    oEle.dataType = "bin.base64"
     
' Read in the data
    oEle.nodeTypedValue = ReadBinData(DOCINPATH)
    
' Save xml file
    oDoc.save XMLOUTPATH
    
    MsgBox XMLOUTPATH & " is created for you."
   
End Sub

Function ReadBinData(ByVal strFileName As String) As Variant
    Dim lLen As Long
    Dim iFile As Integer
    Dim arrBytes() As Byte
    Dim lCount As Long
    Dim strOut As String
    
'Read from disk
    iFile = FreeFile()
    Open strFileName For Binary Access Read As iFile
    lLen = FileLen(strFileName)
    ReDim arrBytes(lLen - 1)
    Get iFile, , arrBytes
    Close iFile
    
    ReadBinData = arrBytes
End Function

Private Sub WriteBinData(ByVal strFileName As String)
    Dim iFile As Integer
    Dim arrBuffer() As Byte
    Dim oNode As IXMLDOMNode
      
    If Not (oDoc Is Nothing) Then
        
' Get the data
        Set oNode = oDoc.documentElement.selectSingleNode("/Root/Data")

' Make sure you use a byte array instead of variant
        arrBuffer = oNode.nodeTypedValue
            
' Write to disk
        
        iFile = FreeFile()
        Open strFileName For Binary Access Write As iFile
        Put iFile, , arrBuffer
        Close iFile
    
    End If
    
End Sub

Private Sub cmdGetBinary_Click()
        
    DOCOUTPATH = App.Path & "\DocOutput.doc"
    
    Set oDoc = New DOMDocument
    
    If oDoc.Load(XMLOUTPATH) = True Then
       ' Save the Doc as another file
       WriteBinData DOCOUTPATH
       
       MsgBox DOCOUTPATH & " is created for you."
    Else
        MsgBox oDoc.parseError.reason
    End If
End Sub

Private Sub Form_Unload(Cancel As Integer)
    ReleaseObjects
End Sub

Private Sub ReleaseObjects()
    Set oDoc = Nothing
End Sub


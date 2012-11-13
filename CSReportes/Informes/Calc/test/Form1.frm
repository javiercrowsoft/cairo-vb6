VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   3090
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   4680
   LinkTopic       =   "Form1"
   ScaleHeight     =   3090
   ScaleWidth      =   4680
   StartUpPosition =   3  'Windows Default
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mFileProperties(2) As Variant

Private Sub Form_Load()
  test
End Sub

Sub test()

  Dim objServiceManager As Object
  Dim objDesktop As Object
  
  'Convertto URL
  Set objServiceManager = CreateObject("com.sun.star.ServiceManager")
  'Create the Desktop
  Set objDesktop = objServiceManager.createInstance("com.sun.star.frame.Desktop")
  
  Set mFileProperties(2) = objServiceManager.Bridge_GetStruct("com.sun.star.beans.PropertyValue")
  mFileProperties(2).Name = "Hidden"
  mFileProperties(2).Value = "True"
  
  Set mFileProperties(0) = objServiceManager.Bridge_GetStruct("com.sun.star.beans.PropertyValue")
  mFileProperties(0).Name = "FilterName"
  mFileProperties(0).Value = "scalc: Text - txt - csv (StarCalc)"
  
  
  'Open a new empty calc document
  Dim FileName As String
  Dim objDocument As Object
  Dim oSheet As Object
  
  FileName = "file:///C:/Documents and Settings/Javier/Desktop/Ventas por Articulo x Mes.xls"
  
  Set objDocument = objDesktop.loadComponentFromURL(FileName, "_blank", 0, mFileProperties())
  
  Set oSheet = objDocument.getSheets().getByIndex(0)
  'till here the code works fine
  '#########################
  
  Dim oRange As Object
  
  
  Set oRange = oSheet.getCellRangeByPosition(0, 0, 10, 24)
  ' i'm getting error in the above statement. basically it is not accepting the range
  ' the range object is not getting assigned
  
  '#########################

End Sub

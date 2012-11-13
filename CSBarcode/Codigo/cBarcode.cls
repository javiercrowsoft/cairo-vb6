VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cBarcode"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Public Function BCPrintBarcode(ByVal file_barcode As String, _
                               ByVal names As String, _
                               ByVal marks As String, _
                               ByVal serials As String, _
                               ByVal printer_name As String, _
                               ByRef error As String, _
                               Optional ByVal mask0 As String, _
                               Optional ByVal mask1 As String, _
                               Optional ByVal mask2 As String, _
                               Optional ByVal mask3 As String, _
                               Optional ByVal mask4 As String, _
                               Optional ByVal mask5 As String, _
                               Optional ByVal mask6 As String, _
                               Optional ByVal mask7 As String, _
                               Optional ByVal mask8 As String, _
                               Optional ByVal mask9 As String) As Boolean
                               
  BCPrintBarcode = mBarcode.BCPrintBarcode(file_barcode, _
                                           names, _
                                           marks, _
                                           serials, _
                                           printer_name, _
                                           error, _
                                           mask0, _
                                           mask1, _
                                           mask2, _
                                           mask3, _
                                           mask4, _
                                           mask5, _
                                           mask6, _
                                           mask7, _
                                           mask8, _
                                           mask9)
End Function

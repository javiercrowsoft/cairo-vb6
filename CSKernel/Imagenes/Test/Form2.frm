VERSION 5.00
Object = "{E82A759A-7510-4F56-B239-9C0B78CF437B}#1.0#0"; "CSImageList.ocx"
Object = "{E3029087-6983-4DF6-A07F-E770EFB12BC0}#1.1#0"; "CSToolBar.ocx"
Begin VB.Form Form2 
   Caption         =   "Form2"
   ClientHeight    =   4815
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   10395
   LinkTopic       =   "Form2"
   ScaleHeight     =   4815
   ScaleWidth      =   10395
   StartUpPosition =   3  'Windows Default
   Begin CSToolBar.cReBar cReBar1 
      Left            =   1560
      Top             =   0
      _ExtentX        =   12091
      _ExtentY        =   979
   End
   Begin CSImageList.cImageList cImageList1 
      Left            =   3300
      Top             =   2580
      _ExtentX        =   953
      _ExtentY        =   953
      IconSizeX       =   24
      IconSizeY       =   24
      ColourDepth     =   32
      Size            =   33252
      Images          =   "Form2.frx":0000
      KeyCount        =   17
      Keys            =   "ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ"
   End
   Begin CSToolBar.cToolbar cToolbar1 
      Height          =   435
      Left            =   1260
      Top             =   900
      Width           =   3495
      _ExtentX        =   6165
      _ExtentY        =   767
   End
End
Attribute VB_Name = "Form2"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Form_Load()
    
  With cToolbar1
    .ImageSource = CTBExternalImageList
    .DrawStyle = CTBDrawOfficeXPStyle
  
    .CreateToolbar 24, , True, True
  End With
  
  cToolbar1.ImageSource = CTBExternalImageList
  cToolbar1.SetImageList cImageList1.hIml
  
  Dim i As Integer
  
  cToolbar1.AddButton , 0, , , " Borrar"
  cToolbar1.AddButton , 1, , , " Buscar"
  cToolbar1.AddButton , 2, , , " Nuevo"
  cToolbar1.AddButton , 3, , , " Refrescar"
  
  cToolbar1.ButtonToolTip(0) = "Borrar comprobante " & vbCrLf & vbCrLf & "- Presione este boton para borrar un comprobante" & vbCrLf & vbCrLf & "Importante: Los comprobantes borrados no pueden restablecerse, cuando se borran se eliminan por completo de la base de datos."
  cToolbar1.ButtonToolTip(1) = "Buscar comprobante " & vbCrLf & vbCrLf & "- Presione este boton para acceder a la ventana de busqueda de comprobantes donde podra buscar por numero, importe, cliente u observaciones"
  cToolbar1.ButtonToolTip(2) = "Nuevo comprobante " & vbCrLf & vbCrLf & "- Presione este boton para crear un nuevo comprobante"
  
  For i = 4 To cImageList1.ImageCount - 1
    cToolbar1.AddButton , i, , , "         "
    
  Next
  

  With cReBar1
    .DestroyRebar
    .CreateRebar Me.hWnd
    .AddBandByHwnd cToolbar1.hWnd, , , , "MainToolBar"
    .BandChildMinWidth(.BandCount - 1) = 24
    
  End With

End Sub

Private Sub Form_Resize()
  cReBar1.RebarSize
End Sub

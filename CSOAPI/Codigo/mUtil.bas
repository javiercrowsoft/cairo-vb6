Attribute VB_Name = "mUtil"
Option Explicit

'--------------------------------------------------------------------------------
' mUtil
' 31-01-00

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' Funciones

#If PREPROC_KERNEL_CLIENT Then

    Public Const HWND_TOPMOST = -1
    Public Const HWND_NOTOPMOST = -2
    Public Const SWP_NOACTIVATE = &H10
    Public Const SWP_SHOWWINDOW = &H40

    Private Const CTBExternalImageList = 2
    Private Const CTBDrawOfficeXPStyle = 2
    Private Const CTBSeparator = 1

    Private Const HH_DISPLAY_TOPIC = &H0
    Private Const HH_CLOSE_ALL = &H12
    Private Const HH_HELP_CONTEXT = &HF

    ' estructuras
    Public Type RECT
            Left As Long
            Top As Long
            Right As Long
            Bottom As Long
    End Type

    Private Type OSVERSIONINFO
      dwOSVersionInfoSize As Long
      dwMajorVersion As Long
      dwMinorVersion As Long
      dwBuildNumber As Long
      dwPlatformId As Long
      szCSDVersion As String * 128      '  Maintenance string for PSS usage
    End Type

    ' Funciones
    Private Declare Function GetComputerName2 Lib "kernel32" Alias "GetComputerNameA" (ByVal lpBuffer As String, nSize As Long) As Long
    Public Declare Function GetClientRect Lib "user32" (ByVal hwnd As Long, lpRect As RECT) As Long
    Public Declare Function GetParent Lib "user32" (ByVal hwnd As Long) As Long
    Public Declare Function GetWindowRect Lib "user32" (ByVal hwnd As Long, lpRect As RECT) As Long
    Private Declare Function GetVersionEx Lib "kernel32" Alias "GetVersionExA" (lpVersionInformation As OSVERSIONINFO) As Long

    Private Declare Function HTMLHelp Lib "hhctrl.ocx" Alias "HtmlHelpA" _
            (ByVal hwndCaller As Long, ByVal pszFile As String, _
            ByVal uCommand As Long, ByVal dwData As Long) As Long

'--------------------------------------------------------------------------------

  Private Const c_CRLF = "@;"
  Private Const c_CRLF2 = ";"

#End If

#If PREPROC_KERNEL_CLIENT Or PREPROC_ABMGENERIC Then

' constantes
' estructuras

    ' privados
    Private Enum cIMAGENES
        IMAGEN_NEW = 0
        IMAGEN_SAVE = 1
        IMAGEN_PRINTOBJ = 2
        IMAGEN_COPY = 3
        IMAGEN_CUT = 4
        IMAGEN_PASTE = 5
        IMAGEN_DELETE = 6
        IMAGEN_EDIT = 7
        IMAGEN_PREVIEW = 8
        IMAGEN_EXIT = 9
        IMAGEN_WITHOUT_PARAMS = 10
        IMAGEN_WITH_PARAMS = 11
        IMAGEN_SEARCH = 12
        IMAGEN_REFRESH = 13
        IMAGEN_GRID = 14

        IMAGEN_ANULAR = 15
        IMAGEN_EDIT_STATE = 16
        IMAGEN_RELOAD = 17
        IMAGEN_ATTACH = 18
        IMAGEN_DOC_APLIC = 19
        IMAGEN_DOC_FIRST = 20
        IMAGEN_DOC_PREVIOUS = 21
        IMAGEN_DOC_NEXT = 22
        IMAGEN_DOC_LAST = 23
        IMAGEN_DOC_SIGNATURE = 24
        IMAGEN_DOC_HELP = 25
        IMAGEN_DOC_MODIFY = 26
        IMAGEN_DOC_AUX = 27
        IMAGEN_DOC_EDIT = 28
        IMAGEN_DOC_TIP = 29
        IMAGEN_DOC_ALERT = 30
        IMAGEN_DOC_MERGE = 31
        IMAGEN_DOC_ACTION = 33
        IMAGEN_DOC_MAIL = 34
        
        IMAGEN_ROLS = 30
        IMAGEN_PERMISSIONS = 32
        IMAGEN_REVOKE = 28
        IMAGEN_DEACTIVE = 28
        
        IMAGEN_SAVE_PARAMS = 35
        IMAGEN_RELOAD_PARAMS = 36
        
        IMAGEN_BUTTON_SAVE_AS = 35
    End Enum
' variables privadas
' propiedades publicas
' propiedades privadas
' Funciones publicas

'
'-- Lists
'
    Public Sub ListAdd_(ByRef List As Object, ByVal Value As String, Optional ByVal Id As Variant)
        List.AddItem Value
        If Not IsMissing(Id) Then List.ItemData(List.NewIndex) = Id
    End Sub
    Public Function ListID_(ByVal List As Object) As Long
        If List.ListIndex = -1 Then Exit Function
        ListID_ = List.ItemData(List.ListIndex)
    End Function
    Public Function ListItemData_(ByVal List As Object, Optional ByVal Index As Integer = -1) As Long
        If List.ListCount - 1 < Index Then Exit Function
        If Index = -1 Then
            ListItemData_ = ListID_(List)
        Else
            ListItemData_ = List.ItemData(Index)
        End If
    End Function
    Public Sub ListSetListIndex_(ByRef List As Object, Optional ByVal idx As Integer = 0)
        If List.ListCount < 1 Then Exit Sub
        If List.ListCount > idx Then List.ListIndex = idx
    End Sub
    Public Sub ListSetListIndexForId_(ByRef List As Object, ByVal Id As Long)
        Dim i As Integer
        For i = 0 To List.ListCount - 1
            If List.ItemData(i) = Id Then
                List.ListIndex = i
                Exit For
            End If
        Next i
    End Sub
    Public Sub ListSetListIndexForText_(ByRef List As Object, ByVal Text As String)
        Dim i As Integer
        For i = 0 To List.ListCount - 1
            If List.List(i) = Text Then
                List.ListIndex = i
                Exit For
            End If
        Next i
    End Sub
    Public Sub ListChangeTextForSelected_(ByRef List As Object, ByVal Value As String)
        ListChangeText_ List, List.ListIndex, Value
    End Sub
    Public Sub ListChangeText_(ByRef List As Object, ByVal idx As Long, ByVal Value As String)
        Dim ItemD As Long
        If idx > List.ListCount Or idx < 0 Then Exit Sub
        ItemD = List.ItemData(idx)
        List.RemoveItem idx
        ListAdd_ List, Value, ItemD
    End Sub
    Public Function ListGetIndexFromItemData_(ByVal List As Object, ByVal ValueItemData As Long) As Integer
        Dim i As Integer

        For i = 0 To List.ListCount - 1

            If List.ItemData(i) = ValueItemData Then
                ListGetIndexFromItemData_ = i
                Exit Function
            End If
        Next i

        ListGetIndexFromItemData_ = -1
    End Function
'
'-- InfoString
'
    Public Function SetInfoString_(ByVal Fuente As String, ByVal Key As String, ByVal Value As String) As String
        Dim i As Integer
        Dim j As Integer
        Dim k As Integer

        Key = "#" & Key
        i = InStr(1, Fuente, Key, vbTextCompare)
        ' la Key no puede estar repetida
        If InStr(i + 1, Fuente, Key, vbTextCompare) <> 0 Then Err.Raise csErrorSetInfoString, "CSOAPI", "SetInfoString_: Se intento Save un Value de Password en una cadena invalida, la Password esta repetida."

        ' si aun no existe la agrego al final
        If i = 0 Then
            SetInfoString_ = Fuente + Key + "=" + Value + ";"
        Else

            j = InStr(i, Fuente, ";", vbTextCompare)
            If j = 0 Then Err.Raise csErrorSetInfoString, "CSOAPI", "SetInfoString_: Se intento Save un Value de Password en una cadena invalida, la cadena esta corrupta, falta el signo ;."

            k = InStr(1, Mid(Fuente, i, j), "=", vbTextCompare)
            If k = 0 Then Err.Raise csErrorSetInfoString, "CSOAPI", "SetInfoString_: Se intento Save un Value de Password en una cadena invalida, la cadena esta corrupta, falta el signo =."
            k = k + i - 1
            SetInfoString_ = Mid(Fuente, 1, k) + Value + Mid(Fuente, j)
        End If
    End Function

    Public Function GetInfoString_(ByVal Fuente As String, ByVal Key As String, Optional ByVal default As String = vbNullString) As String
        Dim i As Integer
        Dim j As Integer
        Dim k As Integer

        Key = "#" & Key

        i = InStr(1, Fuente, Key, vbTextCompare)
        ' la Key no puede estar repetida
        If InStr(i + 1, Fuente, Key, vbTextCompare) <> 0 Then Err.Raise csErrorSetInfoString, "CSOAPI", "GetInfoString_: Se intento obtener un Value de una cadena invalida, la Password esta repetida."

        ' si la Key no existe devuelvo el default
        If i = 0 Then
            GetInfoString_ = default
        Else

            Const c_errorstr = "GetInfoString_: Se intento obtener un valor de una cadena invalida, la cadena esta corrupta, falta el signo "

            j = InStr(i, Fuente, ";", vbTextCompare)
            If j = 0 Then Err.Raise csErrorSetInfoString, "CSOAPI", c_errorstr & ";."

            k = InStr(1, Mid(Fuente, i, j), "=", vbTextCompare)
            If k = 0 Then Err.Raise csErrorSetInfoString, "CSOAPI", c_errorstr & "=."
            k = k + i - 1
            GetInfoString_ = Mid(Fuente, k + 1, j - k - 1)
        End If
    End Function

'
'-- Trees
'
    Public Sub SetNodeForId_(ByRef Tree As Object, ByVal Id As Long)
        Dim Node As Object
        For Each Node In Tree.Nodes
            If GetIdFromKey(Node.Key) = Id Then
                Node.Selected = True
                Exit For
            End If
        Next
    End Sub

'-- configuraciones en el registry
    Public Function GetRegistry_(ByVal Seccion As csSeccionSetting, ByVal Key As String, ByVal default As String) As String
        Dim sSeccion As String
        Select Case Seccion
            Case CSConfig
                sSeccion = "CONFIG"
            Case csInterface
                sSeccion = "INTERFACE"
            Case csLogin
                sSeccion = "LOGIN"
        End Select
        GetRegistry_ = GetSetting(gAppName, sSeccion, Key, default)
    End Function

    Public Sub SetRegistry_(ByVal Seccion As csSeccionSetting, ByVal Key As String, ByVal Value As String)
        Dim sSeccion As String
        Select Case Seccion
            Case CSConfig
                sSeccion = "CONFIG"
            Case csInterface
                sSeccion = "INTERFACE"
            Case csLogin
                sSeccion = "LOGIN"
        End Select
        On Error Resume Next
        SaveSetting gAppName, sSeccion, Key, Value
    End Sub
#End If

#If PREPROC_KERNEL_CLIENT Then
'-- barra de herramientas
  Public Sub ShowToolBarButton_(ByVal Button As csButtons, ByRef TBBar As Object, ByVal Show As Boolean)
    Dim Key           As String
    Key = pShowToolBarButtonAux(Button)
    TBBar.Buttons(Key).Visible = Show
  End Sub

  Public Sub ShowToolBarButtonEx_(ByVal Button As csButtons, ByRef TBBar As Object, ByVal Show As Boolean)
    Dim Key           As String
    Key = pShowToolBarButtonAux(Button)
    TBBar.ButtonVisible(Key) = Show
  End Sub
  
  Private Function pShowToolBarButtonAux(ByVal Button As csButtons) As String
    Dim Key           As String
    
    Select Case Button
      Case BUTTON_NEW
        Key = "NEW"
      Case BUTTON_EDIT
        Key = "EDIT"
      Case BUTTON_REVOKE
        Key = "REVOKE"
      Case BUTTON_DELETE
        Key = "DELETE"
      Case BUTTON_CUT
        Key = "CUT"
      Case BUTTON_COPY
        Key = "COPY"
      Case BUTTON_PASTE
        Key = "PASTE"
      Case BUTTON_SEARCH
        Key = "SEARCH"
      Case BUTTON_PRINTOBJ
        Key = "PRINTOBJ"
      Case BUTTON_PREVIEW
        Key = "PREVIEW"
      Case BUTTON_GRID
        Key = "GRID"
      Case BUTTON_DEACTIVE
        Key = "DEACTIVE"
      Case BUTTON_EXIT
        Key = "EXIT"
      Case BUTTON_ROLS
        Key = "ROLS"
      Case BUTTON_PERMISSIONS
        Key = "PERMISSIONS"
      Case BUTTON_SAVE
        Key = "SAVE"
      Case BUTTON_WITH_PARAMS
        Key = "WITH_PARAMS"
      Case BUTTON_WITHOUT_PARAMS
        Key = "WITHOUT_PARAMS"
      Case BUTTON_UPDATE
        Key = "UPDATE"
    End Select
    
    pShowToolBarButtonAux = Key
  End Function

  Private Sub pAddButton(ByVal IsEx As Boolean, _
                         ByRef TBBar As Object, _
                         ByVal Buttons As Long, _
                         ByVal IdxButton As Long, _
                         ByVal Key As String, _
                         ByVal ToolTip As String, _
                         ByVal IdxImage As Integer, _
                         ByRef bHaveSeparator As Boolean, _
                         ByVal bSize24 As Boolean, _
                         ByVal Name As String, _
                         Optional ByVal bShowNames As Boolean, _
                         Optional ByVal bIsSearchLD As Boolean)

    If Buttons And IdxButton Then
      
      bHaveSeparator = pPutSeparetor(IsEx, TBBar, bHaveSeparator)
      With TBBar
        If IsEx Then
          
          If bIsSearchLD Then
            .AddButton , , , , , , Key
          Else
          
            With fControls
              If IdxImage + 1 > fControls.ImgTbBarEx.ImageCount Then
                If IdxImage <= .ImgTbBar.ListImages.Count Then
                  .ImgTbBarEx.AddFromHandle .ImgTbBar.ListImages(IdxImage + 1).Picture.Handle, _
                    IMAGE_ICON
                  IdxImage = .ImgTbBarEx.ImageCount - 1
                End If
              End If
            End With
          
            .AddButton , IdxImage, , , , , Key
          End If
          
          .ButtonToolTip(Key) = ToolTip
        Else
          If bIsSearchLD Then
            .Buttons.Add(, Key, vbNullString, 4).Width = 6000
          Else
            If bSize24 Then
              If bShowNames Then
                .Buttons.Add , Key, Name, , IdxImage + 1
              Else
                .Buttons.Add , Key, vbNullString, , IdxImage + 1
              End If
              .Buttons(Key).ToolTipText = ToolTip
            Else
              If bShowNames Then
                .Buttons.Add , Key, Name, , IdxImage + 1
              Else
                .Buttons.Add , Key, vbNullString, , IdxImage + 1
              End If
              .Buttons(Key).ToolTipText = ToolTip
            End If
          End If
        End If
      End With
    End If
    
  End Sub

  Public Sub SetToolBar_(ByRef TBBar As Object, _
                         ByVal Buttons1 As Long, _
                         Optional ByVal Buttons2 As Long = 0, _
                         Optional ByVal Buttons3 As Long = 0)
                         
    pSetToolBarAux_ False, False, TBBar, Buttons1, Buttons2, Buttons3
  End Sub

  Public Sub SetToolBar24_(ByRef TBBar As Object, _
                         ByVal Buttons1 As Long, _
                         Optional ByVal Buttons2 As Long = 0, _
                         Optional ByVal Buttons3 As Long = 0, _
                         Optional ByVal bShowNames As Boolean, _
                         Optional ByVal bIsDoc As Boolean)
                         
    pSetToolBarAux_ False, True, TBBar, Buttons1, Buttons2, Buttons3, , , bShowNames, bIsDoc
  End Sub

  Public Sub SetToolBar16_(ByRef TBBar As Object, _
                         ByVal Buttons1 As Long, _
                         Optional ByVal Buttons2 As Long = 0, _
                         Optional ByVal Buttons3 As Long = 0, _
                         Optional ByVal bShowNames As Boolean, _
                         Optional ByVal bIsDoc As Boolean)
                         
    pSetToolBarAux_ False, False, TBBar, Buttons1, Buttons2, Buttons3, , , bShowNames, bIsDoc
  End Sub

  Public Sub SetToolBarEx_(ByRef TBBar As Object, _
                           ByVal Buttons1 As Long, _
                           Optional ByVal Buttons2 As Long = 0, _
                           Optional ByVal Buttons3 As Long = 0)
    
    pSetToolBarAux_ True, False, TBBar, Buttons1, Buttons2, Buttons3
  End Sub

  Private Sub pSetToolBarAux_(ByVal IsEx As Boolean, _
                              ByVal bSize24 As Boolean, _
                              ByRef TBBar As Object, _
                              ByVal Buttons1 As Long, _
                              Optional ByVal Buttons2 As Long = 0, _
                              Optional ByVal Buttons3 As Long = 0, _
                              Optional ByVal Accion As String = "Acción", _
                              Optional ByVal AccionToolTip As String = "Clic para ejecutar el asistente asociado a este documento", _
                              Optional ByVal bShowNames As Boolean, _
                              Optional ByVal bIsDoc As Boolean)
                         
      Dim bHaveSeparator As Boolean
      
      With TBBar
        If IsEx Then
          .ImageSource = CTBExternalImageList
          
          If GetSysVersion = 4 Then
            .DrawStyle = CTBDrawOfficeXPStyle
          End If
  
          .CreateToolbar 16, , , True
          .SetImageList fControls.ImgTbBarEx
        Else
          If bSize24 Then
            .Buttons.Clear
            .ImageList = fControls.ImgTbBar24
            .Style = tbrFlat
            .BorderStyle = ccFixedSingle
          Else
            .Buttons.Clear
            .ImageList = fControls.ImgTbBar
            .Style = tbrFlat
            .BorderStyle = ccFixedSingle
          End If
        End If
      End With
      
      bHaveSeparator = True
      
      Dim Elemento As String
      If bIsDoc Then
        Elemento = "comprobante"
      Else
        Elemento = "registro"
      End If
      
      pPutSeparetorEx IsEx, TBBar

      pAddButton IsEx, TBBar, Buttons1, BUTTON_WITH_PARAMS, "WITH_PARAMS", "Clic para mostrar los parámetros", IMAGEN_WITH_PARAMS, bHaveSeparator, bSize24, "Ver", bShowNames
      pAddButton IsEx, TBBar, Buttons1, BUTTON_WITHOUT_PARAMS, "WITHOUT_PARAMS", "Clic para ocultar los parámetros", IMAGEN_WITHOUT_PARAMS, bHaveSeparator, bSize24, "Ocultar", bShowNames
      
  '-------
      bHaveSeparator = False
      
      pAddButton IsEx, TBBar, Buttons1, BUTTON_UPDATE, "UPDATE", "Clic para refrescar la grilla", IMAGEN_REFRESH, bHaveSeparator, bSize24, "Refrescar", bShowNames
      
  '-------
      bHaveSeparator = False
      
      pAddButton IsEx, TBBar, Buttons1, BUTTON_NEW, "NEW", "Clic para crear un " & Elemento & " nuevo", IMAGEN_NEW, bHaveSeparator, bSize24, "Nuevo", bShowNames
      pAddButton IsEx, TBBar, Buttons1, BUTTON_EDIT, "EDIT", "Clic para editar un " & Elemento, IMAGEN_EDIT, bHaveSeparator, bSize24, "Editar", bShowNames
      pAddButton IsEx, TBBar, Buttons1, BUTTON_SAVE, "SAVE", "Clic para guardar el " & Elemento, IMAGEN_SAVE, bHaveSeparator, bSize24, "Guardar", bShowNames
      pAddButton IsEx, TBBar, Buttons2, BUTTON_SAVE_AS, "SAVE_AS", "Guardar como presupuesto el " & Elemento, IMAGEN_BUTTON_SAVE_AS, bHaveSeparator, bSize24, "Guardar Como", bShowNames
      
  '-------
      bHaveSeparator = False
      
      pAddButton IsEx, TBBar, Buttons2, BUTTON_DOC_EDIT, "DOC_EDIT", "Clic editar el " & Elemento, IMAGEN_DOC_EDIT, bHaveSeparator, bSize24, "Editar", bShowNames

  '-------
      bHaveSeparator = False
      
      pAddButton IsEx, TBBar, Buttons2, BUTTON_DOC_ACTION, "DOC_ACTION", AccionToolTip, IMAGEN_DOC_ACTION, bHaveSeparator, bSize24, Accion, bShowNames

  '-------
      bHaveSeparator = False
      
      pAddButton IsEx, TBBar, Buttons1, BUTTON_RELOAD, "RELOAD", "Clic para descartar todos los cambios realizados al " & Elemento, IMAGEN_RELOAD, bHaveSeparator, bSize24, "Descartar", bShowNames
  
  '-------
      bHaveSeparator = False
      
      pAddButton IsEx, TBBar, Buttons1, BUTTON_ANULAR, "ANULAR", "Clic para anular o des-anular el " & Elemento, IMAGEN_ANULAR, bHaveSeparator, bSize24, "Anular", bShowNames
  
  '-------
      bHaveSeparator = False
      
      pAddButton IsEx, TBBar, Buttons1, BUTTON_CUT, "CUT", "Cortar", IMAGEN_CUT, bHaveSeparator, bSize24, "Cortar", bShowNames
      pAddButton IsEx, TBBar, Buttons1, BUTTON_COPY, "COPY", "Copiar", IMAGEN_COPY, bHaveSeparator, bSize24, "Copiar", bShowNames
      pAddButton IsEx, TBBar, Buttons1, BUTTON_PASTE, "PASTE", "Pegar", IMAGEN_PASTE, bHaveSeparator, bSize24, "Pegar", bShowNames
      pAddButton IsEx, TBBar, Buttons1, BUTTON_SEARCH, "SEARCH", "Clic para acceder a la ventana de busqueda", IMAGEN_SEARCH, bHaveSeparator, bSize24, "Buscar", bShowNames
  
  '-------
      bHaveSeparator = False

      pAddButton IsEx, TBBar, Buttons1, BUTTON_DOC_FIRST, "FIRST", "Clic para ver el primer " & Elemento, IMAGEN_DOC_FIRST, bHaveSeparator, bSize24, "Primero", bShowNames
      pAddButton IsEx, TBBar, Buttons1, BUTTON_DOC_PREVIOUS, "PREVIOUS", "Clic para ver el " & Elemento & " anterior", IMAGEN_DOC_PREVIOUS, bHaveSeparator, bSize24, "Anterior", bShowNames
      pAddButton IsEx, TBBar, Buttons1, BUTTON_DOC_NEXT, "NEXT", "Clic para ver el siguiente " & Elemento, IMAGEN_DOC_NEXT, bHaveSeparator, bSize24, "Siguiente", bShowNames
      pAddButton IsEx, TBBar, Buttons1, BUTTON_DOC_LAST, "LAST", "Clic para ver el ultimo " & Elemento, IMAGEN_DOC_LAST, bHaveSeparator, bSize24, "Ultimo", bShowNames
  
  '-------
      bHaveSeparator = False

      pAddButton IsEx, TBBar, Buttons1, BUTTON_DEACTIVE, "DEACTIVE", "Clic para desactivar", IMAGEN_DEACTIVE, bHaveSeparator, bSize24, "Desactivar", bShowNames
      pAddButton IsEx, TBBar, Buttons1, BUTTON_REVOKE, "REVOKE", "Clic para anular", IMAGEN_REVOKE, bHaveSeparator, bSize24, "Anular", bShowNames
      pAddButton IsEx, TBBar, Buttons1, BUTTON_DELETE, "DELETE", "Clic para borrar", IMAGEN_DELETE, bHaveSeparator, bSize24, "Borrar", bShowNames
  
  '-------
      bHaveSeparator = False

      pAddButton IsEx, TBBar, Buttons1, BUTTON_PRINTOBJ, "PRINTOBJ", "Clic para enviar el listado o el " & Elemento & " a la impresora", IMAGEN_PRINTOBJ, bHaveSeparator, bSize24, "Imprimir", bShowNames
      pAddButton IsEx, TBBar, Buttons1, BUTTON_PREVIEW, "PREVIEW", "Clic para ver la vista previa del informe", IMAGEN_PREVIEW, bHaveSeparator, bSize24, "Vista Previa", bShowNames
      pAddButton IsEx, TBBar, Buttons1, BUTTON_GRID, "GRID", "Clic para ver el informe en grilla", IMAGEN_GRID, bHaveSeparator, bSize24, "Vista en Grilla", bShowNames
      
  '-------
      bHaveSeparator = False
      
      pAddButton IsEx, TBBar, Buttons2, BUTTON_DOC_MAIL, "SENDEMAIL", "Clic para enviar el listado o el " & Elemento & " por e-mail", IMAGEN_DOC_MAIL, bHaveSeparator, bSize24, "E-mail", bShowNames
  
  '-----------
      bHaveSeparator = False
      
      pAddButton IsEx, TBBar, Buttons1, BUTTON_ROLS, "ROLS", "Roles", IMAGEN_ROLS, bHaveSeparator, bSize24, "Roles", bShowNames
      pAddButton IsEx, TBBar, Buttons1, BUTTON_PERMISSIONS, "PERMISSIONS", "Permisos", IMAGEN_PERMISSIONS, bHaveSeparator, bSize24, "Permisos", bShowNames

  '-------
      bHaveSeparator = False

      pAddButton IsEx, TBBar, Buttons1, BUTTON_DOC_SIGNATURE, "SIGNATURE", "Clic para firmar el " & Elemento, IMAGEN_DOC_SIGNATURE, bHaveSeparator, bSize24, "Firmar", bShowNames
      pAddButton IsEx, TBBar, Buttons1, BUTTON_DOC_MODIFY, "HISTORY", "Clic para ver quienes modificaron el " & Elemento, IMAGEN_DOC_MODIFY, bHaveSeparator, bSize24, "Historial", bShowNames
      pAddButton IsEx, TBBar, Buttons1, BUTTON_DOC_APLIC, "APPLY", "Clic para ver/modificar las aplicaciones del " & Elemento, IMAGEN_DOC_APLIC, bHaveSeparator, bSize24, "Aplicación", bShowNames
      pAddButton IsEx, TBBar, Buttons2, BUTTON_DOC_AUX, "DOC_AUX", "Clic para ver los documentos asociados a este " & Elemento & " (Asiento contable y Transferencia de Stock)", IMAGEN_DOC_AUX, bHaveSeparator, bSize24, "Doc. Asoc.", bShowNames
      pAddButton IsEx, TBBar, Buttons2, BUTTON_DOC_MERGE, "DOC_MERGE", "Clic para compenzar stock entre depositos", IMAGEN_DOC_MERGE, bHaveSeparator, bSize24, "Compenzar", bShowNames
  
  '-------
      bHaveSeparator = False
      pAddButton IsEx, TBBar, Buttons1, BUTTON_ATTACH, "ATTACH", "Clic para asociar archivos al " & Elemento, IMAGEN_ATTACH, bHaveSeparator, bSize24, "Asociar", bShowNames
  
  '-------
      bHaveSeparator = False
      pAddButton IsEx, TBBar, Buttons1, BUTTON_EDIT_STATE, "EDIT_STATE", "Clic para ver el estado de edición del " & Elemento, IMAGEN_EDIT_STATE, bHaveSeparator, bSize24, "Estado", bShowNames
  
  '-------
      bHaveSeparator = False
      pAddButton IsEx, TBBar, Buttons1, BUTTON_DOC_HELP, "HELP", "Clic para ver la ayuda del usuario", IMAGEN_DOC_HELP, bHaveSeparator, bSize24, "Ayuda", bShowNames
  
  '-------
      bHaveSeparator = False

      pAddButton IsEx, TBBar, Buttons2, BUTTON_DOC_TIP, "DOC_TIP", "Clic para enviar una sugerencia a CrowSoft", IMAGEN_DOC_TIP, bHaveSeparator, bSize24, "Sugerencias", bShowNames
      pAddButton IsEx, TBBar, Buttons2, BUTTON_DOC_ALERT, "DOC_ALERT", "Clic para ver alertas para este " & Elemento, IMAGEN_DOC_ALERT, bHaveSeparator, bSize24, "Alertas", bShowNames
  
  '-------
      bHaveSeparator = False

      pAddButton IsEx, TBBar, Buttons2, BUTTON_SAVE_PARAMS, "SAVE_PARAMS", "Clic para guardar los parámetros", IMAGEN_SAVE_PARAMS, bHaveSeparator, bSize24, "Guardar", bShowNames
      pAddButton IsEx, TBBar, Buttons2, BUTTON_RELOAD_PARAMS, "RELOAD_PARAMS", "Clic para recargar los párametros guardados", IMAGEN_RELOAD_PARAMS, bHaveSeparator, bSize24, "Recargar", bShowNames
  
  '-------
      bHaveSeparator = False
      pAddButton IsEx, TBBar, Buttons3, BUTTON_GRID, "GRID", "Clic para vel el buscador de zonas", IMAGEN_GRID, bHaveSeparator, bSize24, "Buscador de Zonas", bShowNames
   
  '-----------
      ' Salir siempre va al final
      bHaveSeparator = False
      pAddButton IsEx, TBBar, Buttons1, BUTTON_EXIT, "EXIT", "Clic para cerrar la ventana", IMAGEN_EXIT, bHaveSeparator, bSize24, "Salir", bShowNames

  '-------
      bHaveSeparator = False
      pAddButton IsEx, TBBar, Buttons2, BUTTON_SEARCH_LISTDOC, "SEARCH_LD", vbNullString, 0, bHaveSeparator, bSize24, "", bShowNames, True

  End Sub

  Public Function GetSysVersion() As Long
    Dim tVer As OSVERSIONINFO
    tVer.dwOSVersionInfoSize = Len(tVer)
    
    GetVersionEx tVer

    Select Case tVer.dwPlatformId
      Case 0
        GetSysVersion = 31
      Case 1
        'get minor version info
        If tVer.dwMinorVersion = 0 Then
            GetSysVersion = 95 ' sOS = "Microsoft Windows 95"
        ElseIf tVer.dwMinorVersion = 10 Then
            GetSysVersion = 98 ' sOS = "Microsoft Windows 98"
        ElseIf tVer.dwMinorVersion = 90 Then
            GetSysVersion = 1000 ' sOS = "Microsoft Windows Millenium"
        Else
            GetSysVersion = 1000
        End If
      Case 2
        GetSysVersion = 4
    End Select
  End Function

  Public Function PresButtonToolbarEx_(ByVal sKeyButton As String, ByRef f As Object, Optional NameFunction As String = "TBBar_ButtonClick") As Boolean
    PresButtonToolbarEx_ = pPresButtonToolbarAux_(True, sKeyButton, f, NameFunction)
  End Function

  Public Function PresButtonToolbar_(ByVal sKeyButton As String, ByRef f As Object, Optional NameFunction As String = "TBBar_ButtonClick") As Boolean
    PresButtonToolbar_ = pPresButtonToolbarAux_(False, sKeyButton, f, NameFunction)
  End Function

  Private Function pPresButtonToolbarAux_(ByVal IsEx As Boolean, _
                                          ByVal sKeyButton As String, _
                                          ByRef f As Object, _
                                          Optional NameFunction As String = "TBBar_ButtonClick") As Boolean
      On Error GoTo ControlError
      Select Case sKeyButton
          Case "NEW"
              f.NewObj
          Case "EDIT"
              f.Edit
          Case "REVOKE"
              f.Revoke
          Case "DELETE"
              f.Delete
          Case "PRINTOBJ"
              f.PrintObj
          Case "PREVIEW"
              f.Preview
          Case "CUT"
              f.Cut
          Case "COPY"
              f.Copy
          Case "PASTE"
              f.Paste
          Case "SEARCH"
              f.Search
          Case "DOC_AUX"
              f.ShowDocAux
          Case "DOC_MERGE"
              f.DocMerge
          Case "DOC_TIP"
              f.SendTip
          Case "DOC_ALERT"
              f.ShowAlert
          Case "DEACTIVE"
              f.Deactive
          Case "EXIT"
              f.CloseForm
          Case "ROLS"
              f.Rols
          Case "SAVE"
              f.Save
          Case "WITHOUT_PARAMS"
              f.HideParameters
          Case "WITH_PARAMS"
              f.ShowParameters
          Case "UPDATE"
              f.Update
          Case "RELOAD_PARAMS"
              f.ReloadParams
          Case "SAVE_PARAMS"
              f.SaveParams
      End Select
      pPresButtonToolbarAux_ = True
      Exit Function
ControlError:
      ' 438 = objeto no soporta esta porpiedad o metodo
      If Err.Number = 438 Then
        gWindow.MsgWarning "Esta Funcionalidad no esta implementada", "Barra de Herramientas"
      Else
        MngError_ Err, NameFunction, f.Name, vbNullString, "Error en click barra de herramientas, boton " + sKeyButton, csErrorWarning, csErrorVba
      End If
  End Function

'-------------
' Obtener Properties de un Parent
  Public Function GetPropertyFromParent_(ByRef retValue As Variant, ByVal o As Object, ByVal oProperty As String) As Boolean
    On Error GoTo ControlError

    Do
      If TypeOf o Is Form Then

        Select Case oProperty
          Case "WindowState"
            retValue = o.WindowState
          Case "Height"
            retValue = o.Height
          Case "Width"
            retValue = o.Width
        End Select
        Exit Do
      End If
      Set o = o.Parent
    Loop

    GetPropertyFromParent_ = True
ControlError:
    ' no se informa al User
  End Function
  Public Function GetWindowState_(ByRef retValue As Variant, ByVal o As Object) As Boolean
    GetWindowState_ = GetPropertyFromParent_(retValue, o, "WindowState")
  End Function
'-------------
  Public Function GetInput_(ByRef Value As Variant, Optional ByVal Descrip As String = vbNullString) As Boolean
    Dim oldformResult As Boolean
    Dim Inputvalue  As String

    oldformResult = G_FormResult

    G_FormResult = False
    
    With fEdit
      
      If Not ValEmpty_(Descrip, csText) Then
        .LbDescrip = Descrip
      End If
      
      .Height = 2900
      
      With .Line1
        .Y1 = 1780
        .Y2 = 1780
      End With
      With .Line2
        .Y1 = 1800
        .Y2 = 1800
      End With
      
      .Width = 7700
      .cmdOk.Left = 4600
      .cmdCancel.Left = 6000
      
      .cmdOk.Top = 1900
      .cmdCancel.Top = 1900
      
      .TxValue.Text = Value
      
      .Show vbModal
      
    End With
    
    If G_FormResult Then
      Value = G_InputValue
    End If

    GetInput_ = G_FormResult

    G_FormResult = oldformResult
  End Function

  Public Function GetInputEx_(ByRef Value As String, Optional ByVal Descrip As String = vbNullString) As Boolean
    Dim oldformResult As Boolean
    Dim Inputvalue  As String

    oldformResult = G_FormResult

    G_FormResult = False
    fEdit.TxValue.Visible = False
    fEdit.Shape1.Visible = False
    fEdit.txValueMemo.Visible = True
    fEdit.txValueMemo.Text = Value
    fEdit.cmdOk.default = False
    fEdit.Shape2.Visible = True
    fEdit.bMemo = True
    If Not ValEmpty_(Descrip, csText) Then
      fEdit.LbDescrip = Descrip
    End If
    fEdit.Show vbModal
    If G_FormResult Then
      Value = G_InputValue
    End If

    GetInputEx_ = G_FormResult

    G_FormResult = oldformResult
  End Function
  
  Private Function pPutSeparetor(ByVal IsEx As Boolean, ByRef TBBar As Object, ByVal HaveSeparator As Boolean)
    pPutSeparetor = HaveSeparator
    If HaveSeparator Then Exit Function
    
    If IsEx Then
      If TBBar.ButtonCount > 0 Then
        TBBar.AddButton , , , , , CTBSeparator
        pPutSeparetor = True
      End If
    Else
      If TBBar.Buttons.Count Then
        If TBBar.Buttons.Item(TBBar.Buttons.Count).Style <> tbrSeparator Then
          TBBar.Buttons.Add , , , tbrSeparator
        End If
        pPutSeparetor = True
      End If
    End If
  End Function
  
  Private Sub pPutSeparetorEx(ByVal IsEx As Boolean, ByRef TBBar As Object)
    If IsEx Then
      TBBar.AddButton , , , , , CTBSeparator
    Else
      TBBar.Buttons.Add , , , tbrSeparator
    End If
  End Sub
  
  Private Sub pMsgAux(ByVal msg As String, _
                      ByVal Style As VbMsgBoxStyle, _
                      ByVal Title As String, _
                      ByVal Details As String)
    If Not gbSilent Then
      msg = pGetMessage(msg)
      Title = pGetTitle(Title)
      'MsgBox msg, Style, Title
      fMsg.ShowDialog msg, Style, Title, Details
      Unload fMsg
    Else
      gLastErrDescription = pGetMessage(msg)
    End If
  End Sub
  
  Private Function pGetTitle(ByVal Title As String) As String
    If Title = vbNullString Then Title = "CrowSoft"
    If Title = "@@@@@" Then Title = "CrowSoft"
    pGetTitle = Title
  End Function
  
  Public Sub MsgError_(ByVal msg As String, Optional ByVal Title As String = "@@@@@")
    pMsgAux msg, vbCritical, Title, vbNullString
  End Sub
  
  Public Sub MsgWarning_(ByVal msg As String, _
                         Optional ByVal Title As String = "@@@@@", _
                         Optional ByVal Details As String)
    pMsgAux msg, vbExclamation, Title, Details
  End Sub
  
  Public Function MsgInfo_(ByVal msg As String, Optional ByVal Title As String = "@@@@@")
    pMsgAux msg, vbInformation, Title, vbNullString
  End Function
  
  Public Function Ask_(ByVal msg As String, _
                       ByVal default As VbMsgBoxResult, _
                       Optional ByVal Title As String) As Boolean
    If Not gbSilent Then
      Dim n As Integer
      msg = pGetMessage(msg)
      Title = pGetTitle(Title)
      If InStr(1, msg, "?") = 0 Then msg = "¿" & msg & "?"
      If default = vbNo Then n = vbDefaultButton2
      pGetTitle Title
      'Ask_ = vbYes = MsgBox(msg, vbYesNo + n + vbQuestion, Title)
      fMsg.ShowDialog msg, vbYesNo + n + vbQuestion, Title, vbNullString
      Ask_ = fMsg.rslt = vbYes
      Unload fMsg
    End If
  End Function

  Public Sub CenterForm_(ByRef frm As Object, Optional ByVal fMain As Object)
    Dim bIsMDI As Boolean
    
    ' MDIChild no es una propiedad de MDIForm
    On Error Resume Next
    
    bIsMDI = frm.MDIChild
    
    If bIsMDI Then
      CenterMdiChild_ frm
    Else
      CenterNoMdiChild_ frm, fMain
    End If
    
    frm.Top = IIf(frm.Top > 0, frm.Top, 0)
    frm.Left = IIf(frm.Left > 0, frm.Left, 0)
  End Sub

  Private Sub CenterMdiChild_(ByRef frm As Form)
    Dim frm2 As Form
    Dim offLeft As Long
    Dim offTop As Long
    Dim offLeft2 As Long
    Dim offTop2 As Long

    ' Datos del parent
    Dim ParWidth  As Integer
    Dim ParHeight   As Integer
    Dim Rct     As RECT

    ' si no tengo una referencia no hago nada
    If Forms Is Nothing Then Exit Sub

    ' recorro la coleccion de forms para generar una cascada
    For Each frm2 In Forms
      If Not (TypeOf frm2 Is MDIForm) Then
        If frm2.MDIChild Then
          If frm2.Visible Then
            offLeft = IIf(offLeft > frm2.Left, offLeft, frm2.Left)
            offTop = IIf(offTop > frm2.Top, offTop, frm2.Top)
          End If
        End If
      End If
    Next

    ' Obtengo las coordenadas del MDI
    GetClientRect GetParent(frm.hwnd), Rct

    ParWidth = (Rct.Right - Rct.Left) * Screen.TwipsPerPixelY
    ParHeight = (Rct.Bottom - Rct.Top) * Screen.TwipsPerPixelX

    frm.Top = (ParHeight - frm.Height) / 2.5
    frm.Left = (ParWidth - frm.Width) / 2.5

    ' Para formularios ya mostrados no los muevo
    If frm.Visible Then Exit Sub

    offLeft2 = 200
    offTop2 = 200

    ' si con el movimiento los dezplace fuera de main, lo reubico
    offLeft2 = IIf(offLeft + frm.Width + offLeft2 > ParWidth, offLeft2 * -1, offLeft2)
    offTop2 = IIf(offTop + frm.Height + offTop2 > ParHeight, offTop2 * -1, offTop2)


    frm.Left = IIf(offLeft >= frm.Left, offLeft + offLeft2, frm.Left)
    frm.Top = IIf(offTop >= frm.Top, offTop + offTop2, frm.Top)
  End Sub

  Private Sub CenterNoMdiChild_(ByRef frm As Form, Optional ByVal fMain As Form)
    With frm
      ' Si no hay info de main me centro en NameFunction de la pantalla
      If fMain Is Nothing Then
        .Top = (Screen.Height - .Height) * 0.4
        .Left = (Screen.Width - .Width) * 0.5
  
      ' Main esta minimizado asi que centro en NameFunction de screen
      ElseIf fMain.WindowState = vbMinimized Then
        .Top = (Screen.Height - .Height) / 2.5
        .Left = (Screen.Width - .Width) / 2.5
  
      ' Main esta en la pantalla asi que me centro en NameFunction de el
      Else
        ' main produce un desplazamiento
        .Top = (Screen.Height - .Height) / 2.5 + fMain.Top
        .Left = (Screen.Width - .Width) / 2.5 + fMain.Left
      End If
    End With
  End Sub

  Private Function pGetMessage(ByVal msg As String) As String
    msg = Replace(msg, c_CRLF, vbCrLf)
    msg = Replace(msg, c_CRLF2, vbCrLf)

    pGetMessage = msg
  End Function

  Public Function GetComputerName() As String
    Dim s As String
    s = String(255, " ")
    Dim l As Long
    l = Len(s)
  
    If GetComputerName2(s, l) <> 0 Then
      GetComputerName = Mid(s, 1, l)
    Else
      GetComputerName = vbNullString
    End If
  End Function

#End If

'-------------
' Varias
Public Function ValEmpty_(ByVal Value As Variant, ByVal VarType As csTypes) As Boolean
  On Error Resume Next
  
  Select Case VarType
    Case csText
      ValEmpty_ = Trim(Value) = vbNullString
    Case csInteger, csCurrency, csDouble, csLong, csSingle
      If Not IsNumeric(Value) Then
        ValEmpty_ = True
      Else
        ValEmpty_ = Value = 0
      End If
    Case csId
      If Not IsNumeric(Value) Then
        ValEmpty_ = True
      Else
        ValEmpty_ = Value = csNO_ID
      End If
    Case csDate
      If Not IsDate(Value) Then
        ValEmpty_ = True
      Else
        Dim NoDate As Date
        ValEmpty_ = Value = #1/1/1900# Or Value = NoDate
      End If
  End Select
End Function

Public Function RemoveLastColon_(ByVal List As String) As String
  List = Trim(List)
  If Right(List, 1) = "," Then
    RemoveLastColon_ = Mid(List, 1, Len(List) - 1)
  Else
    RemoveLastColon_ = List
  End If
End Function

'--------------
Public Function ExistsFile_(ByVal PathYName As String) As Boolean
  ExistsFile_ = Dir(PathYName) <> vbNullString
End Function
'--------------
Public Function ArrayToString_(ByVal v As Variant) As String
  Dim i As Integer
  Dim s As String
  For i = 0 To UBound(v)
    s = s & v(i) & ","
  Next i
  ArrayToString_ = RemoveLastColon_(s)
End Function

Public Property Get GetToken(ByVal Token As String, ByVal Source As String) As String
  Dim i As Integer
  Dim s As String
  Dim c As String
  Dim l As Integer

  If Right(Token, 1) <> "=" Then Token = Token & "="

  l = Len(Source)
  i = InStr(1, Source, Token, vbTextCompare)
  If i = 0 Then Exit Property
  i = i + Len(Token) - 1
  Do
    i = i + 1
    If i > l Then Exit Do
    c = Mid(Source, i, 1)
    If c <> ";" Then
      s = s & c
    Else
      Exit Do
    End If
  Loop

  GetToken = s
End Property

Public Function VDGetDateById_(ByVal DateIndex As csDateEnum, Optional ByVal IniDate As Date) As Date
  If IniDate = 0 Then IniDate = Date

  Dim rtn As Date
  Dim DayNumber As Integer

  Select Case DateIndex
    Case csYearLast_FirstDay
      IniDate = DateAdd("yyyy", -1, IniDate)
      DateIndex = csYear_FirstDay
    Case csYearLast_LastDay
      IniDate = DateAdd("yyyy", -1, IniDate)
      DateIndex = csYear_LastDay
    Case csYearNext_FirstDay
      IniDate = DateAdd("yyyy", 1, IniDate)
      DateIndex = csYear_FirstDay
    Case csYearNext_LastDay
      IniDate = DateAdd("yyyy", 1, IniDate)
      DateIndex = csYear_LastDay
  End Select

  Select Case DateIndex
    Case csWeeckLast_FirstDay
      IniDate = DateAdd("d", -7, IniDate)
      DateIndex = csWeeck_FirstDay
    Case csWeeckLast_LastDay
      IniDate = DateAdd("d", -7, IniDate)
      DateIndex = csWeeck_LastDay
    Case csWeeckNext_FirstDay
      IniDate = DateAdd("d", 7, IniDate)
      DateIndex = csWeeck_FirstDay
    Case csWeeckNext_LastDay
      IniDate = DateAdd("d", 7, IniDate)
      DateIndex = csWeeck_LastDay

    Case csMonthLast_FirstDay
      IniDate = DateAdd("m", -1, IniDate)
      DateIndex = csMonth_FirstDay
    Case csMonthLast_LastDay
      IniDate = DateAdd("m", -1, IniDate)
      DateIndex = csMonth_LastDay
    Case csMonthNext_FirstDay
      IniDate = DateAdd("m", 1, IniDate)
      DateIndex = csMonth_FirstDay
    Case csMonthNext_LastDay
      IniDate = DateAdd("m", 1, IniDate)
      DateIndex = csMonth_LastDay

    Case csYear_FirstDay
      IniDate = DateAdd("m", -Month(IniDate) + 1, IniDate)
      DateIndex = csMonth_FirstDay
    Case csYear_LastDay
      IniDate = DateAdd("yyyy", 1, IniDate)
      IniDate = DateAdd("m", -Month(IniDate), IniDate)
      DateIndex = csMonth_LastDay
  End Select

  Select Case DateIndex
    Case csToday
      rtn = IniDate

    Case csYesterday
      rtn = DateAdd("d", -1, IniDate)

    Case csTomorrow
      rtn = DateAdd("d", 1, IniDate)

    Case csWeeck_FirstDay
      DayNumber = Weekday(IniDate, vbMonday)
      rtn = DateAdd("d", 1 - DayNumber, IniDate)

    Case csWeeck_LastDay
    
      ' Ponemos como primer dia de la semana el sabado para
      ' que el ultimo dia sea el viernes, esto es util ya
      ' que de esta forma al usar "USA" el dia lunes
      ' nos devuelve la fecha del dia viernes anterior
      '
      DayNumber = Weekday(IniDate, vbSaturday)
      rtn = DateAdd("d", 7 - DayNumber, IniDate)

    Case csMonth_FirstDay
      DayNumber = Day(IniDate)
      rtn = DateAdd("d", -DayNumber + 1, IniDate)

    Case csMonth_LastDay
      IniDate = DateAdd("m", 1, IniDate)
      DayNumber = Day(IniDate)
      rtn = DateAdd("d", -DayNumber, IniDate)
  End Select

  VDGetDateById_ = rtn
End Function

Public Function ImplementsInterface(ByVal objOne As Object, ByVal Interfaz As Object) As Boolean
  On Error Resume Next
  Err.Clear

  Set Interfaz = objOne

  ImplementsInterface = Err.Number = 0
End Function

#If PREPROC_KERNEL_CLIENT Then
  Public Function ShowHelp_(ByVal hwnd As Long, _
                            ByVal HelpFileFullName As String, _
                            ByVal HelpFile As String, _
                            ByVal ContextId As Long)
  
    If HelpFile = vbNullString Then
      HelpFile = HelpFileFullName
    Else
      HelpFile = pGetValidPath(gAppPath) & HelpFile
    End If
    
    If HelpFile <> vbNullString Then
    
      If Not ExistsFile_(HelpFile) Then
        HelpFile = gDefaultHelpFile
      End If
    Else
      HelpFile = pGetValidPath(gAppPath) & gDefaultHelpFile
    End If
  
    If HelpFile <> vbNullString Then
    
      If Not ExistsFile_(HelpFile) Then
        MsgWarning_ "El archivo de ayuda " & HelpFile & " no se encuentra"
      Else
        If ContextId Then
          HTMLHelp hwnd, HelpFile, HH_HELP_CONTEXT, ContextId
        Else
          HTMLHelp hwnd, HelpFile, HH_DISPLAY_TOPIC, 0
        End If
      End If
    Else
      MsgWarning_ "El sistema no tiene definido un archivo de ayuda"
    End If
  End Function
  
  Private Function pGetValidPath(ByVal Path As String) As String
    If Right$(Path, 1) <> "\" Then Path = Path & "\"
    pGetValidPath = Path
  End Function

  Public Sub SendEmailToCrowSoft_(ByVal Subject As String, _
                                  ByVal Body As String)
    On Error GoTo ControlError
    
    Dim Mail As Object
    Set Mail = CreateObject("CSMail.cMail")
    
    If Mail.SendEmail("soporte@crowsoft.com.ar", _
                      gEmailAddress, _
                      gEmailAddress, _
                      gEmailServer, _
                      gEmailPort, _
                      gEmailUser, _
                      gEmailPwd, Subject, Body) Then
      MsgInfo_ "El mail se envio con éxito"
    Else
      MsgWarning_ "El mail fallo " & Mail.errNumber & " - " & Mail.ErrDescrip
    End If
  
    Exit Sub
ControlError:
    MsgError_ Err.Description
  
  End Sub

#End If
' construccion - destruccion


VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cMngHoja"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Attribute VB_Ext_KEY = "SavedWithClassBuilder6" ,"Yes"
Attribute VB_Ext_KEY = "Member0" ,"cRenglones"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Option Explicit

'///////////////////////////////////////////////////////////////
' Soporte de hoja
' Una hoja es una representacion grafica de informacion basada
' en renglones uno debajo del otro. Cada renglon tiene n columnas
' (la cantidad de columnas por renglon puede ser distinta), cada
' columna tiene:
'                  - Ancho
'                  - Font
'                  - Negrita
'                  - Subrayado
'                  - Tipo
'                  - Texto
'                  - Imagen

' Lo primero que debe hacerse es llamar a la funcion Init
' Luego se cargan los renglones llamando a la funcion AddRenglon
' Luego se cargan las columnas de cada renglon
' Luego se llama a la funcion Actualizar

' Las hojas Disparan dos eventos click y doble click cuando se realiza alguna
' de las dos acciones sobre cualquier columna.

' Funciones:
'   Init(Label,ListImage,Image,Contenedor)
'        Label: Referencia al vector de labels
'        ListImage: Referencia al ListImage
'        Image: Referencia al vector de Images
'        Contenedor: Refrencia al Frame, VideoSoft o Form
'                    que contiene a los controles recibidos
'                    en Label, ListImage e Image.

' Renglones
'   Add() Agrega un renglon
' Columnas
'   Add() Agrega una columna


' Elementos necesarios en el cliente:
'   Un Label con indice 0
'   Un ListImage con las imagenes a mostrar
'   Un Image con indice 0

'///////////////////////////////////////////////////////////////

Private Const C_EspacioEntreRenglones As Integer = 20 '20 es una separación entre renglones razonable
Private Const C_EspacioEntreGruposRng As Integer = 60

Private Const C_ANCHO_DESCRIP = 4500

Private m_VTopRngl()        As Integer

Private m_Renglones         As cRenglones
Private m_Columnas          As cColumnas
Private m_Etiquetas         As Object
Private m_ListaDeImagenes   As Object
Private m_Imagenes          As Object
Private m_Contenedor        As Object
Private m_Left              As Integer  ' Margen izquierdo
Private m_Top               As Integer  ' Margen superior
Private m_Bottom            As Integer  ' Margen inferior
Private m_Right             As Integer  ' Margen derecho
Private m_OldIndex          As Integer
Private m_OldColor          As Long
Private m_OldSubrayado      As Boolean

Private m_UsaVerMas         As Boolean

Public Event Ejecutar(ByVal Ident As String)
Public Event Editar(ByVal Ident As String)

Public Property Set Imagenes(ByVal rhs As Object)
  Set m_Imagenes = rhs
End Property

Public Property Get Imagenes() As Object
  Set Imagenes = m_Imagenes
End Property

Public Property Set ListaDeImagenes(ByVal rhs As Object)
  Set m_ListaDeImagenes = rhs
End Property

Public Property Get ListaDeImagenes() As Object
  Set ListaDeImagenes = m_ListaDeImagenes
End Property

Public Property Set Etiquetas(ByVal rhs As Object)
  Set m_Etiquetas = rhs
End Property

Public Property Get Etiquetas() As Object
  Set Etiquetas = m_Etiquetas
End Property

Public Property Get Renglones() As cRenglones
  Set Renglones = m_Renglones
End Property

Public Property Set Renglones(rhs As cRenglones)
  Set m_Renglones = rhs
End Property

Public Property Get Columnas() As cColumnas
  Set Columnas = m_Columnas
End Property

Public Property Set Columnas(rhs As cColumnas)
  Set m_Columnas = rhs
End Property

Public Property Set Contenedor(ByVal rhs As Object)
  Set m_Contenedor = rhs
End Property

Public Property Get Contenedor() As Object
  Set Contenedor = m_Contenedor
End Property

Public Property Let Left(ByVal rhs As Integer)
  m_Left = rhs
End Property

Public Property Get Left() As Integer
  Left = m_Left
End Property

Public Property Let Right(ByVal rhs As Integer)
  m_Right = rhs
End Property

Public Property Get Right() As Integer
  Right = m_Right
End Property

Public Property Let Bottom(ByVal rhs As Integer)
  m_Bottom = rhs
End Property

Public Property Get Bottom() As Integer
  Bottom = m_Bottom
End Property

Public Property Let Top(ByVal rhs As Integer)
  m_Top = rhs
End Property

Public Property Get Top() As Integer
  Top = m_Top
End Property

Public Property Let UsaVerMas(ByVal rhs As Boolean)
  m_UsaVerMas = rhs
End Property

Public Property Get UsaVerMas() As Boolean
  UsaVerMas = m_UsaVerMas
End Property

'------------------------------------------------------------------------
Public Function Init(ByRef Etiquetas As Object, _
                     ByRef Imagenes As Object, _
                     ByRef ListaDeImagenes As Object, _
                     ByRef Contenedor As Object) As Boolean
                     
  On Error GoTo ControlError
  
  Set m_Etiquetas = Etiquetas
  Set m_Imagenes = Imagenes
  Set m_ListaDeImagenes = ListaDeImagenes
  Set m_Contenedor = Contenedor
  
  m_OldIndex = -1
  m_OldColor = 0
  m_OldSubrayado = False
  
  m_Columnas.Clear
  m_Renglones.Clear
  ReDim m_VTopRngl(0)
  
  Init = True
  
  Exit Function
ControlError:
  ScShowError "cHoja.Init", 1
End Function

Public Function Actualizar() As Boolean
  On Error GoTo ControlError
  
  ' Ahi vamos
  Actualizar = Dibujar
  
  Exit Function
ControlError:
  ScShowError "cHoja.Actualizar", 1
End Function

Public Sub LabelClick(ByVal Index As Integer)
  On Error GoTo ControlError

  If m_Etiquetas(Index).Tag = "VerMas" Then
    Dibujar m_VTopRngl(UBound(m_VTopRngl))
  ElseIf m_Etiquetas(Index).Tag = "VerMasArriba" Then
    ReDim Preserve m_VTopRngl(UBound(m_VTopRngl) - 2)
    Dibujar m_VTopRngl(UBound(m_VTopRngl))
  Else
    RaiseEvent Editar(m_Etiquetas(Index).Tag)
  End If

  Exit Sub
ControlError:
  ScShowError "cHoja.LabelClick", 1
End Sub

Public Sub LabelBotonDerecho(ByVal Index As Integer)
  On Error GoTo ControlError

  Exit Sub
ControlError:
  ScShowError "cHoja.LabelBotonDerecho", 1
End Sub

Public Sub ImageClick(ByVal Index As Integer)
  On Error GoTo ControlError

  RaiseEvent Ejecutar(m_Imagenes(Index).Tag)

  Exit Sub
ControlError:
  ScShowError "cHoja.ImageClick", 1
End Sub

Public Sub LabelMouseMove(ByVal Index As Integer)
  On Error GoTo ControlError

  If m_OldIndex = Index Then Exit Sub
  
  On Error Resume Next
  
  If Vacio(m_Etiquetas(Index).Tag) Then Exit Sub
  
  If m_OldIndex <> 0 Then
    m_Etiquetas(m_OldIndex).ForeColor = m_OldColor
    m_Etiquetas(m_OldIndex).FontUnderline = m_OldSubrayado
  End If
  
  m_OldIndex = Index
  
  m_OldColor = m_Etiquetas(m_OldIndex).ForeColor
  m_OldSubrayado = m_Etiquetas(m_OldIndex).FontUnderline
  
  m_Etiquetas(m_OldIndex).ForeColor = vbRed
  m_Etiquetas(m_OldIndex).FontUnderline = True

  Exit Sub
ControlError:
  ScShowError "cHoja.LabelMouseMove", 1
End Sub

Public Function ShowAccesoDirecto(ByVal Imagen As Integer, ByVal Texto As String, ByVal Ident As String, ByVal iLeft As Integer, ByVal EspacioAdicional As Boolean, Optional ByVal IndiceGrupo As Integer) As Boolean
  On Error GoTo ControlError
  
  With m_Renglones
    .Add

    .Item(.Count).Left = iLeft
    .Item(.Count).IndiceGrupo = IndiceGrupo
    
    With .Item(.Count).Columnas
      If Imagen <> 0 Then
        .Add
        With .Item(.Count)
          .Imagen = Imagen
          .Tipo = cRepoImagen
          .Ident = Ident
          .IndiceGrupo = IndiceGrupo
        End With
      End If
      If Not Vacio(Texto) Then
        .Add
        With .Item(.Count)
          .Texto = Texto
          .FontSize = 9
          .Tipo = cRepoTexto
          .Ident = Ident
          .Color = vbBlue
          .SubRayado = True
          .IndiceGrupo = IndiceGrupo
        End With
      End If
    End With
  End With

  If EspacioAdicional Then
    With m_Renglones
      .Add
      With .Item(.Count).Columnas
        .Add
        With .Item(.Count)
          .Alto = 20
          .Tipo = cRepoTexto
        End With
      End With
    End With
  End If

  ShowAccesoDirecto = True
  Exit Function
ControlError:
  ScShowError "cHoja.ShowAccesoDirecto", 1
End Function

' Como los nodos se van agregando de atras para adelante
' revierto su posicion en la coleccion para que quede bien
' el path
Public Function RevertirOrdenPath(ByVal Renglon As Integer) As Boolean
  On Error GoTo ControlError

  Dim c As Collection
  Set c = New Collection
  
  Dim i As Integer
  
  With m_Renglones(Renglon).Columnas
  
    For i = .Count To 2 Step -1
      c.Add .Item(i)
      .Remove i
    Next
    
    For i = 1 To c.Count
      .Add , c.Item(i)
    Next
  End With
  
  RevertirOrdenPath = True
  Exit Function
ControlError:
  ScShowError "cHoja.RevertirOrdenPath", 1
End Function

Public Function InitPath(ByVal Imagen As Integer) As Boolean
  On Error GoTo ControlError

  With m_Renglones
    .Add
    
    If Imagen > 0 Then
      With .Item(.Count).Columnas
        .Add
        With .Item(.Count)
          .Tipo = cRepoImagen
          .Imagen = Imagen
        End With
      End With
    End If
  End With

  InitPath = True
  Exit Function
ControlError:
  ScShowError "cHoja.InitPath", 1
End Function

Public Function AddPath(ByVal sPath As String, ByVal Ident As String) As Boolean
  On Error GoTo ControlError
  
  With m_Renglones
    
    With .Item(.Count).Columnas
      .Add
      With .Item(.Count)
        .Tipo = cRepoTexto
        .Texto = ">"
        .Color = vbBlack
        .SubRayado = False
        .FontSize = 10
      End With
      .Add
      With .Item(.Count)
        .Tipo = cRepoTexto
        .Texto = sPath
        .Color = vbBlue
        .SubRayado = True
        .FontSize = 10
        .Ident = Ident
      End With
    End With
  End With

  AddPath = True
  Exit Function
ControlError:
  ScShowError "cHoja.AddPath", 1
End Function

Public Function ShowAccesoDescrip(ByVal Texto As String, Optional ByVal IndiceGrupo As Integer) As Boolean
  On Error GoTo ControlError
  
  Dim AltoTexto As Single
  
  With m_Renglones
    .Add
    .Item(.Count).Left = 1000
    .Item(.Count).IndiceGrupo = IndiceGrupo
    With .Item(.Count).Columnas
      If Not Vacio(Texto) Then
        .Add
        With .Item(.Count)
          ' Matias sugirio que le saque los enter
          .Texto = Replace(Replace(Texto, Chr(13), "", 1), Chr(10), " ", 1)
          .Tipo = cRepoTexto
          .Color = vbBlack
          .SubRayado = False
          .FontSize = 8
          If .Ancho > C_ANCHO_DESCRIP Then
            AltoTexto = GetAltoTexto("abcdefghijklmnopqrstuvwxyz12345", .Font, .FontSize, .Negrita)
            .Alto = (Fix((.Ancho / C_ANCHO_DESCRIP) + 1)) * AltoTexto
            ' Por cada enter le sumo una linea
            .Alto = .Alto + (LineasPorEnter(.Texto) * AltoTexto)
            .Ancho = C_ANCHO_DESCRIP
            .Alto = .Alto + 100
          End If
        End With
      End If
    End With
  End With
  
  With m_Renglones
    .Add
    With .Item(.Count).Columnas
      .Add
      With .Item(.Count)
        .Alto = C_EspacioEntreGruposRng
        .Tipo = cRepoTexto
      End With
    End With
  End With

  ShowAccesoDescrip = True
  Exit Function
ControlError:
  ScShowError "cHoja.ShowAccesoDescrip", 1
End Function

'------------------------------------------------------------------------
Private Function Dibujar(Optional ByVal DesdeRng As Integer = 1) As Boolean
  On Error GoTo ControlError
  
  Dim AnchoColumnas   As Integer
  Dim Ancho           As Integer
  Dim Alto            As Integer
  
  Dim IndexEtiqueta   As Integer
  Dim IndexImagen     As Integer
  
  Dim PonerVacio      As Boolean
  
  ' Nota: Existen dos tipos de columnas: Las de pagina que indican en cuantas columnas divido al contenedor
  '                                      y las de renglon que indican en cuantas columnas divido al renglon
  
  ' Ejemplo:     El contenedor es:
  '
  ' __________________________________________________
  ' |                                                |
  ' |                                                |
  ' |                                                |
  ' |                                                |
  ' |                                                |
  ' |                                                |
  ' __________________________________________________
  '
  '
  ' La cantidad de columnas de pagina (representada por el miembro m_Columnas de esta clas) divide al contenedor
  ' en secciones verticales
  ' __________________________________________________
  ' |                |                 |       |     |
  ' |                |                 |       |     |
  ' |                |                 |       |     |
  ' |                |                 |       |     |
  ' |                |                 |       |     |
  ' |                |                 |       |     |
  ' __________________________________________________
  
  ' Los renglones ocupan como maximo el ancho de una seccion
  ' __________________________________________________
  ' | un renglon     |                 |       |     |
  ' | otro renglon   |                 | un ren|     |
  ' |                |                 |       |     |
  ' |                |                 | otro r|     |
  ' |                |                 |       |     |
  ' |                |                 |       |     |
  ' __________________________________________________
  
  ' Finalmente cada renglon esta dividido en 1 o mas columnas
  
  ' Los renglones ocupan como maximo el ancho de una seccion
  ' __________________________________________________
  ' |      /    /  / |                 |       |     |
  ' |  ____________  |                 |       |     |
  '       |
  '   estas son columnas del renglon
  
  
  Dim iActualTop      As Integer
  Dim iActualLeft     As Integer
  
  If m_Contenedor Is Nothing Then
    ScWarning "No se ha pasado un control contenedor para mostrar la página. Funcion cHoja.Dibujar."
    Exit Function
  End If
  If m_Etiquetas Is Nothing Then
    ScWarning "No se ha pasado un control etiquetas para mostrar la página. Funcion cHoja.Dibujar."
    Exit Function
  End If
  If m_Imagenes Is Nothing Then
    ScWarning "No se ha pasado un control de imagenes para mostrar la página. Funcion cHoja.Dibujar."
    Exit Function
  End If
  
  If Not TypeOf m_Contenedor Is Control Then
    ScWarning "La referencia al contenedor no es un control. Funcion cHoja.Dibujar."
    Exit Function
  End If
  
  ' Le saco los margenes al ancho y al alto
  Ancho = Contenedor.Width - m_Left - m_Right
  Alto = Contenedor.Height - m_Bottom


  '--------------------------------------------------------------
  ' Columnas de pagina

  Dim c As cColumna

  If m_Columnas.Count = 0 Then
    m_Columnas.Add
    m_Columnas(1).Ancho = Ancho
  End If
  
  For Each c In m_Columnas
    AnchoColumnas = AnchoColumnas + c.Ancho
  Next
  
  ' Si la suma de las columnas es mayor al ancho
  ' voy a comprimirlas proporcionalmente
  If AnchoColumnas > Ancho Then
    For Each c In m_Columnas
      c.Ancho = Ancho * (c.Ancho / AnchoColumnas)
    Next
  End If
  
  Dim iColumnaPagina As Integer
  
  ' Hasta aqui estoy hablando de ancho de columnas de pagina
  '------------------------------------------------------------------
  
  Dim R As cRenglon
  
  ' Por cada renglon voy a ver su alto y voy a posicionar los controles
  
  iActualLeft = m_Left
  iActualTop = m_Top
  
  Dim AltoRenglon       As Integer
  Dim AltoRenglonGrupo  As Integer  ' Este es el alto del grupo en el que esta el renglon
  Dim AnchoColGrupo     As Integer  ' Este es el ancho del grupo en el que esta la columna
  Dim BottomRenglon     As Integer
  Dim ColumnaLeft       As Integer
  
  ' Este se usa para evitar pasarme de los margenes
  Dim AnchoMaximo    As Integer
  Dim AnchoMaximo2    As Integer
  Dim iAnchoColumnas As Integer  ' Aca esta el ancho de las columnas de pagina que ya use
  
  ' Cuando el usuario no seteo columnas de pagina, pero
  ' hay mas renglones de los que puedo poner, y hay espacion
  ' a la izquierda, esta rutina agrega una columna automaticamente
  ' y usa el espacio disponible
  Dim AnchoUsado            As Integer
  Dim AnchoUsadoRenglon     As Integer
  
  IndexEtiqueta = 1
  IndexImagen = 1
  
  ' Saco todas las etiquetas
  UnLoadImagenesYEtiquetas
  
  iColumnaPagina = 1
  
  ' Estas son usadas para calcular el alto del grupo de renglones
  Dim w     As Integer
  Dim t     As Integer
  Dim R2    As cRenglon
  Dim c2    As cColumna
  Dim AltoR As Integer
  
  Dim x       As Integer
  Dim y       As Integer
  Dim c3      As cColumna
  Dim m       As Integer
  
  t = 1
  
  Dim AltoLinkMas As Integer ' El alto que ocupa un link Mas datos
  
  AltoLinkMas = GetAltoTexto("SiguienteAnteriror", "Arial", 10, False)
  
  ' Esto me dice que tengo que poner un elemento nuevo
  ' en el vector para que ande el atras / adelante.
  PonerVacio = True
  
  ' Si estoy mostrando 'desde' tengo que poner un link
  ' a ver mas arriba para que pueda ver los que estan arriba
  If DesdeRng > 1 Then
    
    ' Cargo el control
    Load m_Etiquetas(IndexEtiqueta)
    
    ' Le doy forma a la etiqueta
    With m_Etiquetas(IndexEtiqueta)
      .Height = AltoLinkMas
      .Width = GetAnchoTexto("Anterior ...", "Arial", 10, False)
      .Tag = "VerMasArriba"
      .MousePointer = vbCustom
      .MouseIcon = F_FontSize.MouseIcon
      .Top = iActualTop
      .Left = iActualLeft
      .Font = "Arial"
      .FontSize = 10
      .Caption = "Anterior ..."
      .FontBold = False
      .FontUnderline = True
      .Visible = True
      .ToolTipText = ""
      .BackStyle = 0 ' Transparente
      .ZOrder
      .ForeColor = vbBlue
    End With
    IndexEtiqueta = IndexEtiqueta + 1
    iActualTop = iActualTop + AltoLinkMas + C_EspacioEntreGruposRng
  End If
  
  For Each R In m_Renglones
    
    ' Contador de renlgones
    t = t + 1
    
    If DesdeRng <= t Then
    
      AnchoMaximo2 = m_Columnas(iColumnaPagina).Ancho
      AnchoMaximo = AnchoMaximo2
      
      AltoRenglon = 0
      For Each c In R.Columnas
        If AltoRenglon < c.Alto Then
          AltoRenglon = c.Alto
        End If
      Next
      
      ' Ahora voy a obtener el alto de los renglones que pertenecen al mismo grupo
      ' que este
      AltoRenglonGrupo = AltoRenglon
      
      ' Si el renglon pertenece a un grupo
      If R.IndiceGrupo <> 0 Then
      
        ' Desde el proximo renglon hasta el ultimo
        ' voy a ver si son del mismo grupo
        For w = t To m_Renglones.Count
          Set R2 = m_Renglones(w)
          
          ' Si son del mismo grupo
          If R.IndiceGrupo = R2.IndiceGrupo Then
          
            ' Obtengo el alto
            AltoR = 0
            For Each c2 In R2.Columnas
              If AltoR < c2.Alto Then
                AltoR = c2.Alto
              End If
            Next
            ' Agrego el alto de este renglon
            AltoRenglonGrupo = AltoRenglonGrupo + AltoR + C_EspacioEntreRenglones
          Else
            Exit For
          End If
        Next
      End If
      
      ' Si no estoy en el ultimo renglon
      ' le agrego la altura del renglon 'Ver mas ...'
      If w < m_Renglones.Count And m_UsaVerMas Then
        AltoRenglonGrupo = AltoRenglonGrupo + AltoLinkMas + C_EspacioEntreGruposRng
      End If
      '
      
      ' Obtengo el Bottom de este renglon
      
      ' Si el renglon esta debajo del margen inferior
      ' voy a intentar agregar una columna
      If iActualTop + AltoRenglonGrupo > Alto Then
      
        ' Si no hay varias columnas pero hay espacio
        ' Automaticamente meto una columna
        If iColumnaPagina >= m_Columnas.Count Then
          If (Ancho / m_Columnas.Count + 1) - AnchoUsado > AnchoUsado * 0.75 Then
            
            ' Agrego lo que use en las columnas que fui agregando
            ' Ojo esto tiene que estar antes de agregar la nueva
            ' columna
            Dim AnchoUsadoAux As Integer
            
            AnchoUsadoAux = AnchoUsado
            
            For m = 1 To m_Columnas.Count - 1
              AnchoUsado = AnchoUsado + m_Columnas(m).Ancho
            Next
            
            ' Agrego la nueva columna
            m_Columnas.Add
            
            ' Actualizo el ancho de la columna anterior
            
            ' Esto es seguro por que no puede haber menos de una columna
            m_Columnas(m_Columnas.Count - 1).Ancho = AnchoUsadoAux
            
            m_Columnas(m_Columnas.Count).Ancho = Ancho - AnchoUsado
            AnchoUsado = 0
          End If
        End If
        
        ' NOTA: Esta pregunta parece estar dos veces pero no es asi
        ' sucede que la rutina agrega automaticamente columnas si
        ' ve que hay espacio. No es un error y no hay que sacarla.
        If iColumnaPagina < m_Columnas.Count Then
          iColumnaPagina = iColumnaPagina + 1
          
          ' Vuelvo a arriba
          iActualTop = m_Top
          
          ' Me corro hacia la izquierda
          iActualLeft = iActualLeft + m_Columnas(iColumnaPagina - 1).Ancho + 60 ' Separacion razonable para columnas
          
          ' Guardo el ancho usado por las columnas para efectuar el calculo
          ' de AnchoMaximo
          iAnchoColumnas = iAnchoColumnas + m_Columnas(iColumnaPagina - 1).Ancho
          
          ' Actualizo el ancho maximo
          AnchoMaximo2 = m_Columnas(iColumnaPagina).Ancho
          AnchoMaximo = AnchoMaximo2
        
        ' Si no hay espacio para una columna mas
        Else
          ' No tiene sentido imprimir por que no entra
          ' solo voy a imprimir el renglon Ver Mas...
          Load m_Etiquetas(IndexEtiqueta)
          
          ' Le doy forma a la etiqueta
          With m_Etiquetas(IndexEtiqueta)
            .Height = AltoLinkMas
            .Width = GetAnchoTexto("Siguiente ...", "Arial", 10, False)
            .Tag = "VerMas"
            .MousePointer = vbCustom
            .MouseIcon = F_FontSize.MouseIcon
            .Top = iActualTop
            .Left = iActualLeft '+ R.Left
            .Font = "Arial"
            .FontSize = 10
            .Caption = "Siguiente ..."
            .FontBold = False
            .FontUnderline = True
            .Visible = True
            .ToolTipText = ""
            .BackStyle = 0 ' Transparente
            .ZOrder
            .ForeColor = vbBlue
            
            ' Guardo cual fuel el ultimo renglon que pude poner
            ReDim Preserve m_VTopRngl(UBound(m_VTopRngl) + 1)
            m_VTopRngl(UBound(m_VTopRngl)) = t
            PonerVacio = False
          End With
          IndexEtiqueta = IndexEtiqueta + 1
          Exit For
        End If
      End If
      
      ' Todos los labels tienen que estar a la misma altura para que los distintos font
      ' no queden desalineados por ende el top de un label es igual al BottomRenglon + LabelHeight
      BottomRenglon = iActualTop + AltoRenglon
      
      ColumnaLeft = iActualLeft + R.Left
      
      AnchoUsadoRenglon = R.Left
      
      x = 1
      
      ' Creo el control y lo posiciono
      For Each c In R.Columnas
      
        ' Tengo que calcular el ancho de las columnas que tengo que imprimir
        x = x + 1
        AnchoColGrupo = c.Ancho
        
        ' Si el renglon pertenece a un grupo
        If c.IndiceGrupo <> 0 Then
        
          ' Desde la proxima columna hasta la ultima
          ' voy a ver si son del mismo grupo
          For y = x To R.Columnas.Count
            Set c3 = R.Columnas(y)
            
            ' Si son del mismo grupo
            If c.IndiceGrupo = c3.IndiceGrupo Then
            
              ' Agrego el ancho de esta columna
              AnchoColGrupo = AnchoColGrupo + c3.Ancho
            Else
              Exit For
            End If
          Next
        End If
      
        ' Si lo que hay para imprimir no alcanza ni para la mitad
        ' de lo que tengo que imprimir no tiene sentido seguir
        If AnchoColGrupo - AnchoMaximo > AnchoColGrupo / 2 Then
          Exit For
        End If
      
        Select Case c.Tipo
          Case cRepoImagen
            Load m_Imagenes(IndexImagen)
            
            ' Le doy forma a la imagen
            With m_Imagenes(IndexImagen)
              .ZOrder
              .Left = ColumnaLeft
              .Tag = c.Ident
              .ToolTipText = "Ver la página"
              .MousePointer = vbCustom
              .MouseIcon = F_FontSize.MouseIcon
              
              Set .Picture = m_ListaDeImagenes.ListImages(c.Imagen).Picture
              
              ' Esto va despues por que tengo que tener la imagen cargada en el control
              
              ' Si el alto es cero entonces vale el alto de la imagen
              If c.Alto = 0 Then
                .Height = .Picture.Height
              Else
                .Height = c.Alto
              End If
              
              ' Si el ancho es cero entonces vale el ancho de la imagen
              If c.Ancho = 0 Then
                .Width = .Picture.Width
              Else
                .Width = c.Ancho
              End If
              
              .Top = BottomRenglon - .Height * 0.59 ' Los iconos de 16 bits son el doble de altos que el texto de Arial 10
              Debug.Print .Height
              
              If .Width > AnchoMaximo Then .Width = AnchoMaximo
              
              AnchoUsadoRenglon = AnchoUsadoRenglon + .Width
              
              .Visible = True
              
              ColumnaLeft = ColumnaLeft + .Width * 0.75
            End With
            IndexImagen = IndexImagen + 1
            
          Case cRepoTexto
            Load m_Etiquetas(IndexEtiqueta)
            
            ' Le doy forma a la etiqueta
            With m_Etiquetas(IndexEtiqueta)
              .Height = c.Alto
              .Width = c.Ancho
              .Tag = c.Ident
              .MousePointer = vbCustom
              .MouseIcon = F_FontSize.MouseIcon
              .Top = BottomRenglon - c.Alto
              .Left = ColumnaLeft
              .Font = c.Font
              .FontSize = c.FontSize
              .Caption = c.Texto
              .FontBold = c.Negrita
              .FontUnderline = c.SubRayado
              .Visible = True
              .ToolTipText = "Editar la definición"
              .BackStyle = 0 ' Transparente
              .ZOrder
              If c.Color <> 0 Then .ForeColor = c.Color
              
              If .Width > AnchoMaximo Then .Width = AnchoMaximo
              
              AnchoUsadoRenglon = AnchoUsadoRenglon + .Width
              
              ColumnaLeft = ColumnaLeft + .Width
            End With
            IndexEtiqueta = IndexEtiqueta + 1
            
        End Select
        ColumnaLeft = ColumnaLeft + 20 ' Una separacion razonable entre columnas
        
        ' Por cada columna que imprimo me quedo con menos ancho en la Columna de Pagina
        AnchoMaximo = AnchoMaximo2 - (ColumnaLeft - iAnchoColumnas)
        
        If AnchoUsado < AnchoUsadoRenglon Then AnchoUsado = AnchoUsadoRenglon
      Next
      
      ' Me preparo para el próximo rénlgon
      iActualTop = iActualTop + AltoRenglon + C_EspacioEntreRenglones
    End If
  Next
  
  If PonerVacio Then
    ' Guardo un elemnto vacio para que el algoritmo funcione
    ReDim Preserve m_VTopRngl(UBound(m_VTopRngl) + 1)
    m_VTopRngl(UBound(m_VTopRngl)) = 0
  End If
  
  Dibujar = True
  
  Exit Function
ControlError:
  ScShowError "cHoja.Dibujar", 1
End Function

Private Sub UnLoadImagenesYEtiquetas()
  On Error Resume Next
  Dim i As Integer

  For i = 1 To m_Etiquetas.Count - 1
    Unload m_Etiquetas(i)
  Next

  For i = 1 To m_Imagenes.Count - 1
    Unload m_Imagenes(i)
  Next
End Sub

Private Function LineasPorEnter(ByVal s As String) As Integer
  Dim i As Integer
  Dim j As Integer
  Dim h As Integer
  
  j = 1
  h = -1
  i = 0
  Do
    
    j = InStr(j, s, Chr(13))
    
    If j = 0 Then Exit Do
    
    If j > h + 2 Then
      i = i + 1
    End If
    
    h = j
    
    j = j + 1
  Loop
  
  LineasPorEnter = i
End Function

Private Function GetAltoTexto(ByVal Texto As String, ByVal sFont As String, ByVal sglFontSize As Single, ByVal Negrita As Boolean)
  F_FontSize.Font = sFont
  F_FontSize.FontSize = sglFontSize
  F_FontSize.FontBold = Negrita
  GetAltoTexto = Fix(F_FontSize.TextHeight(Texto)) + 10
End Function

Private Function GetAnchoTexto(ByVal Texto As String, ByVal sFont As String, ByVal sglFontSize As Single, ByVal Negrita As Boolean)
  F_FontSize.Font = sFont
  F_FontSize.FontSize = sglFontSize
  F_FontSize.FontBold = Negrita
  GetAnchoTexto = Fix(F_FontSize.TextWidth(Texto)) + 10
End Function

'------------------------------------------------------------------------
Private Sub Class_Initialize()
  m_Left = 500
  m_Top = 100
  m_Bottom = 100
  m_Right = 100
  Set m_Renglones = New cRenglones
  Set m_Columnas = New cColumnas
  ReDim m_VTopRngl(0)
End Sub

Private Sub Class_Terminate()
  Set m_Renglones = Nothing
  Set m_Columnas = Nothing
  Set m_Etiquetas = Nothing
  Set m_Imagenes = Nothing
  Set m_ListaDeImagenes = Nothing
  Set m_Contenedor = Nothing
  ReDim m_VTopRngl(0)
End Sub


Attribute VB_Name = "mArbol"
Option Explicit

Private Const IMAGEN_COMPONENTE = 2
Private Const IMAGEN_SECTOR = 1


Private Type TComponente
    Nombre As String
    Clave  As Long
End Type

Private m_Componentes() As TComponente

Public Sub ArbolCargar(ByRef ControlArbol As MSComctlLib.TreeView, ByRef Sectores As Recordset, ByRef Componentes As Recordset)
    ReDim m_Componentes(0)
    
    If Not Componentes.EOF Then
        Componentes.MoveLast
        Componentes.MoveFirst
        
        While Not Componentes.EOF
        
            ReDim Preserve m_Componentes(UBound(m_Componentes) + 1)
            m_Componentes(UBound(m_Componentes)).Nombre = gDb.ValField(Componentes(1))
            m_Componentes(UBound(m_Componentes)).Clave = gDb.ValField(Componentes(0))
            
            Componentes.MoveNext
        Wend
    End If
    
    ArbolCargarSectores ControlArbol, Sectores
End Sub

Private Sub ArbolCargarSectores(ByRef ControlArbol As MSComctlLib.TreeView, ByRef rs As Recordset)
    Dim Nodo As MSComctlLib.Node
    
    While Not rs.EOF
        
        Set Nodo = ArbolAgregarNodo(ControlArbol, Nothing, rs(0).Value)
        
        Nodo.Image = IMAGEN_SECTOR
        
        ArbolCargarComponentes ControlArbol, Nodo
        
        Nodo.Expanded = False
        
        rs.MoveNext
    Wend
End Sub

Private Sub ArbolCargarComponentes(ByRef ControlArbol As MSComctlLib.TreeView, ByRef Padre As MSComctlLib.Node)
    Dim i       As Integer
    Dim Nodo    As MSComctlLib.Node
    
    For i = 1 To UBound(m_Componentes)
        Set Nodo = ArbolAgregarNodo(ControlArbol, Padre, m_Componentes(i).Nombre, m_Componentes(i).Clave)
        Nodo.Image = IMAGEN_COMPONENTE
    Next i
End Sub

Private Function ArbolAgregarNodo(ByRef ControlArbol As MSComctlLib.TreeView, ByRef Padre As MSComctlLib.Node, ByVal Nombre As String, Optional ByVal Clave As String) As MSComctlLib.Node
    Dim Nodo As MSComctlLib.Node
    
    If Trim(Clave) = "" Then
        Set Nodo = ControlArbol.Nodes.Add(, , , Nombre)
    Else
        Set Nodo = ControlArbol.Nodes.Add(, , GetKey(Clave), Nombre)
    End If
    
    If Not Padre Is Nothing Then
        Set Nodo.Parent = Padre
    End If
    
    Set ArbolAgregarNodo = Nodo
End Function

Public Function GetKey(ByVal Clave As String) As String
    If IsNumeric(Clave) Then Clave = "k" & Clave
End Function

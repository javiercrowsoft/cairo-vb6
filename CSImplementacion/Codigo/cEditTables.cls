VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cEditTables"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements cIEditGeneric
Implements CSMenu.cIMenuClient
'--------------------------------------------------------------------------------
' cEditTables
' 23-10-2006

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cEditTables"
' estructuras
' enumeraciones

' variables privadas

Private m_Editing           As Boolean

Private m_Host              As CSMenu.cIMenuHost

' propiedades publicas
' propiedades privadas
' funciones publicas

' funciones privadas
' construccion - destruccion
Private Function cIEditGeneric_Edit(ID As Long, Optional ByVal InModalWindow As Boolean) As Boolean
  On Error GoTo ControlError
  
  If Not SecurityCanAccess(csPreImpSQLEditTables) Then Exit Function
  
  MsgWarning LNGGetText(3331, vbNullString)
            'Esta herramienta le permite modificar directamente las tablas del sistema.; _
             Utilícela con extremada precaución ya que los cambios que Ud. haga sobre estas tablas _
             no podrán deshacerse. Ademas el sistema no será capaz de validar dichos cambios _
             antes de que tomen efecto.;;Recuerde que un uso incorrecto de esta herramienta puede corromper el sistema."
  
  Dim fTables As fTables
  Set fTables = New fTables
  
  fTables.Show

  cIEditGeneric_Edit = True

  Exit Function
ControlError:
  MngError Err, C_EditGenericEdit, C_Module, vbNullString
End Function

Private Function cIEditGeneric_TabClick(ByVal Index As Integer) As Boolean

End Function

Private Property Let cIEditGeneric_TreeId(ByVal rhs As Long)

End Property

Private Property Get cIEditGeneric_TreeId() As Long

End Property

Private Function cIEditGeneric_GridAdd(ByVal KeyProperty As Integer) As Boolean

End Function

Private Function cIEditGeneric_GridEdit(ByVal KeyProperty As Integer) As Boolean

End Function

Private Function cIEditGeneric_GridRemove(ByVal KeyProperty As Integer) As Boolean

End Function

Private Function cIEditGeneric_ShowList() As Boolean
    cIEditGeneric_ShowList = False
End Function

Private Property Get cIEditGeneric_ObjAbm() As CSInterfacesABM.cIABMGeneric

End Property

Private Property Set cIEditGeneric_ObjAbm(rhs As CSInterfacesABM.cIABMGeneric)

End Property

Private Property Get cIEditGeneric_Editing() As Boolean
    cIEditGeneric_Editing = m_Editing
End Property

Private Function cIEditGeneric_Delete(ID As Long) As Boolean
    cIEditGeneric_Delete = False
End Function

Private Function cIEditGeneric_Search(ID As Long, Cancela As Boolean) As Boolean

End Function

Private Function cIEditGeneric_PrintObj(ByVal ID As Long) As Boolean

End Function

Private Property Set cIEditGeneric_ObjTree(rhs As Object)

End Property

Private Property Let cIEditGeneric_BranchId(ByVal rhs As Long)

End Property

Private Property Get cIEditGeneric_BranchId() As Long

End Property

Private Function cIEditGeneric_Preview(ByVal ID As Long) As Boolean

End Function

Private Function cIEditGeneric_PropertyChange(ByVal Key As Integer) As Boolean

End Function

Private Function cIMenuClient_Initialize(f As Object, Host As CSMenu.cIMenuHost) As Boolean
  On Error GoTo ControlError
  Dim str_3287    As String
  
  str_3287 = LNGGetText(3287, vbNullString) 'I&mplementación
  Set m_Host = Host
  
  m_Host.Server.AddMenu str_3287, csMenuEnum.csMenuMainImpSQL, vbNullString, 1, False, False, False, True, False, Nothing
  m_Host.Server.AddMenu LNGGetText(3332, vbNullString), csPreImpSQLEditTables, str_3287, 0, True, False, False, False, False, Me
                        '&Editar Tablas del Sistema
  cIMenuClient_Initialize = True

  GoTo ExitProc
ControlError:
  MngError Err, C_MenuClientInit, C_Module, vbNullString
  If Err.Number Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Function cIMenuClient_ProcessMenu(ByVal ID As Long) As Variant
  cIEditGeneric_Edit csNO_ID
End Function


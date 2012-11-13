Attribute VB_Name = "mMsgConstantes"
Option Explicit

'--------------------------------------------------------------------------------
' mMsgConstantes
' 05-01-2004

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "mMsgConstantes"

Public Enum ABM_MSG

  ' Abm Generico
  MSG_BUTTON_TEXT_CLICK = 1
  
  ' Documentos
  MSG_DOC_FIRST = 101
  MSG_DOC_PREVIOUS = 102
  MSG_DOC_NEXT = 103
  MSG_DOC_LAST = 104
  
  MSG_DOC_SIGNATURE = 105
  MSG_DOC_DELETE = 106
  
  MSG_DOC_ANULAR = 107
  MSG_DOC_REFRESH = 108

  MSG_DOC_EDIT_STATE = 109
  MSG_DOC_NEW_WITH_WIZARD = 110
  
  MSG_DOC_APPLY = 111
  
  MSG_DOC_EX_GET_ITEMS = 112
  MSG_DOC_EX_GET_FOOTERS = 113
  
  MSG_DOC_INFO = 114
  MSG_DOC_SEARCH = 115
  MSG_DOC_HISTORY = 116
  
  MSG_DOC_DOC_AUX = 117
  MSG_DOC_DOC_EDIT = 119
  MSG_DOC_DOC_ACTION = 122
  
  MSG_MENU_AUX = 118
  MSG_DOC_MERGE = 120
  MSG_DOC_ALERT = 121
  
  MSG_DOC_INFO_HANDLED = -100
  
  ' Client Grid
  MSG_GRID_ROW_DELETED = 201
  MSG_GRID_ROW_CHANGE = 202
  MSG_GRID_VIRTUAL_ROW = 203
  
  ' ABM
  MSG_ABM_PRINT = 300
  MSG_ABM_CAN_PRINT = 310
  MSG_ABM_KEY_F2 = 320
  MSG_ABM_KEY_F3 = 330

  MSG_DOC_EX_PRE_VALIDATE = 400
  
  MSG_EDIT_PERMISOS = 500
  MSG_SHOW_EDIT_PERMISOS = 501
  
  MSG_EXPORT_GET_EMAIL = 800
  
  MSG_EXPORT_GET_FILE_NAME_POSTFIX = 801
  
  MSG_SAVE_AS = 900
  
  MSG_DOC_NEW_EVENT_COMPLETE = 901
  
  MSG_POP_MENU_ITEM = 700
  
  MSG_PRINT_GET_TITLE = 902
  
  MSG_TOOLBAR_BUTTON_CLICK = 903
  
  MSG_FORM_AFTER_SHOW_MODAL = 600
  
  MSG_KEY_DOWN = 850
  
End Enum

#If PREPROC_ABMGENERIC Then
  Public Function VarToBool(ByVal Value As Variant) As Boolean
    On Error Resume Next
    VarToBool = CBool(Value)
  End Function
#End If

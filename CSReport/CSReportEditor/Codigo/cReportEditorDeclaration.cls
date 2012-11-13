VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cReportEditorDeclaration"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
'--------------------------------------------------------------------------------
' cReportEditorDeclaration
' 02-02-2002

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
  Private Const C_Module = "cReportEditorDeclaration"

  Public Enum csNewWizardChoiceDb
    csChoiceAccess = 1
    csChoiceSQL = 2
    csChoiceOLEDB = 3
  End Enum

  Public Enum csWizarTypeFill
    FillWithFields = 1
    FillWithFormulas = 2
  End Enum

  Public Enum csNewWizardChoice
    csChoiceBlankReport = 1
    csChoiceUseWizard = 2
  End Enum

  Public Enum csStepsWizardNew
   step_welcom = 0
   step_choice_db = 1
   step_open_db = 2
   step_choice_source = 3
   step_set_parameters = 4
   step_add_fields = 5
   step_add_formulas = 6
   step_finish = 7
  End Enum

' estructuras
' variables privadas
' eventos
' propiedades publicas
' propiedades privadas
' funciones publicas
' funciones friend
' funciones privadas
' construccion - destruccion


'//////////////////////////////
'  Codigo estandar de errores
'  On Error GoTo ControlError
'
'  GoTo ExitProc
'ControlError:
'  MngError err,"", C_Module, ""
'  If Err.Number Then Resume ExitProc
'ExitProc:
'  On Error Resume Next


Attribute VB_Name = "mError"
Option Explicit

'--------------------------------------------------------------------------------
' mError
' 27-12-99

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' Funciones

'--------------------------------------------------------------------------------

' constantes
Private Const c_ErrorSqlInfoAdd = "@@ErrorSqlInfoAdd@@"

' estructuras
' variables privadas
' Properties publicas
Public gLastErrDescription As String
Public gLastErrorNumber    As Long
Public gbSilent            As Boolean
Public gLastErrFunction    As String
Public gLastErrModule      As String
Public gLastErrInfoAdd     As String
Public gLastErrLine        As Long
' Properties privadas
' Funciones publicas

Public Sub MngError_(ByRef ErrObj As Object, _
                     ByVal NameFunction As String, _
                     ByVal Module As String, _
                     ByVal InfoAdd As String, _
                     Optional ByVal Title As String = "", _
                     Optional ByVal Level As csErrorLevel = csErrorWarning, _
                     Optional ByVal VarType As csErrorType = csErrorType.csErrorVba, _
                     Optional ByVal ConnectionObj As Object)

  gLastErrFunction = NameFunction
  gLastErrModule = Module
  gLastErrInfoAdd = InfoAdd
  gLastErrLine = Erl
  gLastErrorNumber = ErrObj.Number
  
#If PREPROC_KERNEL_CLIENT Then

  Dim f As fErrores
  Dim errorAdo As Object
  Dim strErr As String
  
  If pProcessError(ErrObj.Description, strErr, ConnectionObj) Then
    
    gLastErrDescription = strErr
    
    Dim errorDetails As String
    Dim n As Long
    n = InStr(1, strErr, c_ErrorSqlInfoAdd)
    If n Then
      errorDetails = Mid$(strErr, n + 19)
      n = n - 1
      If n Then
        strErr = Mid$(strErr, 1, n)
      Else
        strErr = "No hay información de error."
      End If
    End If
    
    MsgWarning_ strErr, , errorDetails
  
  Else
  
    gLastErrorNumber = ErrObj.Number
    
    Dim errNumber As Long
    errNumber = IIf(ErrObj.Number < 0, ErrObj.Number - vbObjectError, ErrObj.Number)
    
    Dim errSource As String
    errSource = ErrObj.Source
    
    If Not gbSilent Then
    
      ' CREO UN FORMULARIO DE ERRORES
      Set f = New fErrores
      
      Load f
      
      ' AGREGO INFORMACION DEL ERROR A LA List
      f.AddDetail "Función: " & Replace(NameFunction, "\n", vbCrLf)
      f.AddDetail "Modulo: " & Module
      f.AddDetail "Descripción: " & Replace(strErr, "\n", vbCrLf)
      f.AddDetail "Número de error: " & errNumber
      f.AddDetail "Info Adicional: " & Replace(InfoAdd, "\n", vbCrLf)
      f.AddDetail ""
      f.AddDetail "Source: " & errSource
      f.AddDetail ""
      
      If Title = "" Then Title = App.Title
      
      f.SetCaption Title
      
      ' ESTABLEZCO EL DIBUJITO DEL FORMULARIO
      Select Case Level
          Case csErrorWarning
              f.SetWarning
          Case csErrorFatal
              f.SetFatal
          Case Else 'csErrorInformation
              f.SetInformation
      End Select
      
      ' ESTABLEZCO EL CONTENIDO DE LA ETIQUETA DETALLE
      f.SetDescrip "Ha ocurrido un error en la aplicación"
      
'      ' AGREGO CADA ERROR ADO A LA LISTA DE DETALLE
'      If VarType = csErrorAdo Then
'          f.AddDetail "Errores ADO"
'          If IsEmpty(ConnectionObj) Then
'              f.AddDetail "Error interno de sintaxis"
'              f.AddDetail "No se ha pasado un objeto conexión"
'          Else
'              For Each errorAdo In ConnectionObj.Errors
'                  f.AddDetail "Número: " & IIf(errorAdo.Number < 0, errorAdo.Number - vbObjectError, errorAdo.Number)
'                  f.AddDetail "Descripción: " & errorAdo.Description
'                  f.AddDetail "Source: " & errorAdo.Source
'                  f.AddDetail "Estado Sql: " & errorAdo.SQLState
'                  f.AddDetail "Archivo de ayuda: " & errorAdo.HelpFile
'                  f.AddDetail "Contexto de ayuda: " & errorAdo.HelpContext
'                  f.AddDetail "Error nativo: " & errorAdo.NativeError
'                  f.AddDetail ""
'              Next
'          End If
'      End If
      
      gLastErrDescription = f.GetDetail
      
      f.Show vbModal
      
    Else
      
      Dim errDescription As String
      
      errDescription = ErrObj.Description & vbCrLf
      
'      If VarType = csErrorAdo Then
'
'        If Not IsEmpty(ConnectionObj) Then
'          For Each errorAdo In ConnectionObj.Errors
'            errDescription = errDescription & "Número: " & IIf(errorAdo.Number < 0, errorAdo.Number - vbObjectError, errorAdo.Number) & vbCrLf _
'                                            & "Descripción: " & errorAdo.Description & vbCrLf _
'                                            & "Source: " & errorAdo.Source & vbCrLf _
'                                            & "Estado Sql: " & errorAdo.SQLState & vbCrLf _
'                                            & "Archivo de ayuda: " & errorAdo.HelpFile & vbCrLf _
'                                            & "Contexto de ayuda: " & errorAdo.HelpContext & vbCrLf _
'                                            & "Error nativo: " & errorAdo.NativeError & vbCrLf & vbCrLf
'          Next
'        End If
'      End If
      
      gLastErrDescription = strErr & vbCrLf & errDescription
    End If
    
  End If
      
#Else

  gLastErrDescription = Err.Source & vbCrLf & Err.Number & vbCrLf & Err.Description

#End If
End Sub
' Funciones privadas
Private Function pReplaceAux(ByVal Source As String, ByVal Table As String, ByVal Column As String) As String
  Dim n       As Integer
  Dim strErr  As String
  
  n = InStr(1, Source, "table")
  Source = Replace(Source, "dbo.", vbNullString)
  strErr = Mid(Source, n, InStr(n, Source, ".") - n + 1)
  
  strErr = Replace(strErr, "table", Table)
  strErr = Replace(strErr, "column", Column)
  pReplaceAux = strErr
End Function

Private Function pReplaceAuxES(ByVal Source As String, ByVal Table As String, ByVal Column As String) As String
  Dim n       As Integer
  Dim strErr  As String
  
  n = InStr(1, Source, "tabla")
  Source = Replace(Source, "dbo.", vbNullString)
  strErr = Mid(Source, n, InStr(n, Source, ".") - n + 1)
  
  strErr = Replace(strErr, "tabla", Table)
  strErr = Replace(strErr, "column", Column)
  pReplaceAuxES = strErr
End Function

Private Function pProcessError(ByVal strOriginalErr As String, ByRef rtnMsg As String, ByRef ConnectionObj As Object) As Boolean
  Dim p           As Integer
  Dim strErr      As String
  Dim q           As Integer

  p = InStr(1, strOriginalErr, "@@ERROR_SP:")
  
  If p > 0 Then
    strErr = Mid(strOriginalErr, p + 11)
  Else
    p = InStr(1, strOriginalErr, "@@ERROR_SP_RS:")
    If p > 0 Then
      strErr = Mid(strOriginalErr, p + 14)
    End If
  End If
  
  If p > 0 Then
    
    pProcessError = True
  Else
    
    Dim errorAdo As Object
    Dim strOriginalErr2 As String
    
    If Not ConnectionObj Is Nothing Then
      For Each errorAdo In ConnectionObj.Errors
        strOriginalErr2 = strOriginalErr2 & errorAdo
      Next
    End If
    
    strOriginalErr2 = strOriginalErr2 & gErrorDB
  
    p = InStr(1, strOriginalErr2, "@@ERROR_SP:")
    If p > 0 Then
      strOriginalErr = strOriginalErr2
      strErr = Mid(strOriginalErr, p + 11)
      pProcessError = True
    End If
  End If
  
  If strOriginalErr = vbNullString Then
    strOriginalErr = strOriginalErr2
  End If
  
  gErrorDB = ""
  
  '-------------------
  If InStr(1, strOriginalErr, "DELETE statement conflicted with COLUMN REFERENCE constraint ") > 0 Or _
     InStr(1, strOriginalErr, "DELETE statement conflicted with COLUMN SAME TABLE REFERENCE constraint ") > 0 Then
    strErr = pReplaceAux(strOriginalErr, _
                         "Este registro esta relacionado con otros registros en la tabla: ", _
                         "Por medio de la columna:") & _
             ";;No es posible borrarlo."
  End If

  If InStr(1, strOriginalErr, "Instrucción DELETE en conflicto con la restricción COLUMN REFERENCE ") > 0 Then
    strErr = pReplaceAuxES(strOriginalErr, _
                           "Este registro esta relacionado con otros registros en la tabla: ", _
                           "Por medio de la columna:") & _
             ";;No es posible borrarlo."
  End If
  
  If InStr(1, strOriginalErr, "DELETE statement conflicted with the REFERENCE constraint ") > 0 Then
    strErr = pReplaceAux(strOriginalErr, _
                           "Este registro esta relacionado con otros registros en la tabla: ", _
                           "Por medio de la columna:") & _
             ";;No es posible borrarlo."
  End If

  If InStr(1, strOriginalErr, "Instrucción DELETE en conflicto con la restricción REFERENCE ") > 0 Then
    strErr = pReplaceAuxES(strOriginalErr, _
                           "Este registro esta relacionado con otros registros en la tabla: ", _
                           "Por medio de la columna:") & _
             ";;No es posible borrarlo."
  End If

  '-------------------
  If InStr(1, strOriginalErr, "UPDATE statement conflicted with COLUMN FOREIGN KEY constraint ") > 0 Then
    strErr = pReplaceAux(strOriginalErr, _
                         "Este registro depende de otro registro en la tabla: ", _
                         "Por medio de la columna:") & _
             ";;No es posible modificar esta columna."
  End If

  If InStr(1, strOriginalErr, "Instrucción UPDATE en conflicto con la restricción COLUMN FOREIGN KEY ") > 0 Then
    strErr = pReplaceAuxES(strOriginalErr, _
                           "Este registro depende de otro registro en la tabla: ", _
                           "Por medio de la columna:") & _
             ";;No es posible modificar esta columna."
  End If

  '-------------------
  If InStr(1, strOriginalErr, "INSERT statement conflicted with COLUMN FOREIGN KEY constraint ") > 0 Then
    strErr = pReplaceAux(strOriginalErr, _
                         "Este registro hace referencia a otro registro en la tabla: ", _
                         "Por medio de la columna:") & _
             " que no existe.;;No es posible insertar el registro."
  End If

  If InStr(1, strOriginalErr, "Instrucción INSERT en conflicto con la restricción COLUMN FOREIGN KEY ") > 0 Then
    strErr = pReplaceAuxES(strOriginalErr, _
                           "Este registro hace referencia a otro registro en la tabla: ", _
                           "Por medio de la columna:") & _
             " que no existe.;;No es posible insertar el registro."
  End If
  
  '-------------------
  If InStr(1, strOriginalErr, "UPDATE statement conflicted with COLUMN REFERENCE constraint ") > 0 Then
    strErr = pReplaceAux(strOriginalErr, _
                         "Este registro esta relacionado con otros registros en la tabla: ", _
                         "Por medio de la columna:") & _
             ";;No es posible modificar esta columna."
  End If

  If InStr(1, strOriginalErr, "Instrucción UPDATE en conflicto con la restricción COLUMN REFERENCE ") > 0 Then
    strErr = pReplaceAuxES(strOriginalErr, _
                           "Este registro esta relacionado con otros registros en la tabla: ", _
                           "Por medio de la columna:") & _
             ";;No es posible modificar esta columna."
  End If
  
  '-------------------
  If InStr(1, strOriginalErr, "Cannot insert the value NULL into column ") > 0 Then
    strErr = strOriginalErr
    strErr = "El campo: " & Mid(strErr, _
                                InStr(1, strErr, "column") + 7, _
                                InStr(1, strErr, ";") - InStr(1, strErr, "column") - 7)
                                
    strErr = Mid(strErr, 1, InStr(1, strErr, "table") + 4) & _
             Mid(strErr, InStr(1, strErr, ".") + 1)
             
    strErr = Mid(strErr, 1, InStr(1, strErr, "table") + 4) & _
             "'" & Mid(strErr, InStr(1, strErr, ".") + 1)
    
    strErr = Replace(strErr, "table", "de la tabla: ") & _
             " no permite valores vacios.;;No es posible insertar el registro."
  End If

  If InStr(1, strOriginalErr, "No se puede insertar el valor NULL en la columna ") > 0 Then
    strErr = strOriginalErr
    strErr = "El campo: " & Mid(strErr, _
                                InStr(1, strErr, "columna") + 7, _
                                InStr(1, strErr, ";") - InStr(1, strErr, "columna") - 7)
                                
    strErr = Mid(strErr, 1, InStr(1, strErr, "tabla") + 4) & _
             Mid(strErr, InStr(1, strErr, ".") + 1)
             
    strErr = Mid(strErr, 1, InStr(1, strErr, "tabla") + 4) & _
             "'" & Mid(strErr, InStr(1, strErr, ".") + 1)
             
    strErr = Replace(strErr, "tabla", "de la tabla: ") & _
             " no permite valores vacios.;;No es posible insertar el registro."
  End If

  '-------------------
  If InStr(1, strOriginalErr, "Violation of PRIMARY KEY constraint ") > 0 Then
    
    p = Len("Violation of PRIMARY KEY constraint ")
    q = InStr(1, strOriginalErr, "Violation of PRIMARY KEY constraint ")
    
    strErr = "No se puede insertar un valor duplicado en el campo: " & _
             Mid(strOriginalErr, _
                 q + p, _
                 InStr(q, strOriginalErr, ".") - q - p)
                           
    p = InStr(1, strOriginalErr, "in object ") + Len("in object")
    q = InStr(p, strOriginalErr, ".")
    strErr = strErr & " de la tabla " & Mid(strOriginalErr, p, q - p)
    
  End If

  If InStr(1, strOriginalErr, "Infracción de la restricción PRIMARY KEY ") > 0 Then
    
    p = Len("Infracción de la restricción PRIMARY KEY ")
    q = InStr(1, strOriginalErr, "Infracción de la restricción PRIMARY KEY ")
    
    strErr = "No se puede insertar un valor duplicado en el campo: " & _
             Mid(strOriginalErr, _
                 q + p, _
                 InStr(1, strOriginalErr, ".") - q - p)
                         
    p = InStr(1, strOriginalErr, "en el objeto ") + Len("en el objeto")
    q = InStr(p, strOriginalErr, ".")
    strErr = strErr & " de la tabla " & Mid(strOriginalErr, p, q - p)
  End If

  '-------------------
  If InStr(1, strOriginalErr, "Cannot insert duplicate key row in object ") > 0 Then
    strErr = "No se puede insertar un valor duplicado para el"
    
    If InStr(1, strOriginalErr, "codigo", vbTextCompare) Then
      strErr = strErr & " campo código de la tabla"
    Else
      strErr = strErr & " indice "
      p = InStr(1, strOriginalErr, "with unique index ") + Len("with unique index ")
      q = InStr(p, strOriginalErr, ".")
      strErr = strErr & Mid(strOriginalErr, p, q - p) & " de la tabla"
    End If
    p = InStr(1, strOriginalErr, "in object ") + Len("in object")
    q = InStr(p, strOriginalErr, "with")
    strErr = strErr & Mid(strOriginalErr, p, q - p)
  End If

  If InStr(1, strOriginalErr, "No se puede insertar una fila de claves duplicadas en el objeto ") > 0 Then
    strErr = "No se puede insertar un valor duplicado para el"
    
    If InStr(1, strOriginalErr, "codigo", vbTextCompare) Then
      strErr = strErr & " campo código de la tabla"
    Else
      strErr = strErr & " indice "
      p = InStr(1, strOriginalErr, "con índice único ") + Len("con índice único ")
      q = InStr(p, strOriginalErr, ".")
      strErr = strErr & Mid(strOriginalErr, p, q - p) & " de la tabla"
    End If
    p = InStr(1, strOriginalErr, "en el objeto ") + Len("en el objeto")
    q = InStr(p, strOriginalErr, "con")
    strErr = strErr & Mid(strOriginalErr, p, q - p)
  End If
  
  '-------------------
  If InStr(1, strOriginalErr, "Violation of UNIQUE KEY constraint") > 0 Then
    strErr = "No se puede insertar un valor duplicado para la"
    
    strErr = strErr & " regla de validación "
    p = InStr(1, strOriginalErr, "UNIQUE KEY constraint ") + Len("UNIQUE KEY constraint ")
    q = InStr(p, strOriginalErr, ".")
    strErr = strErr & Mid(strOriginalErr, p, q - p) & " de la tabla"
    
    p = InStr(1, strOriginalErr, "in object ") + Len("in object")
    q = InStr(p, strOriginalErr, ".")
    strErr = strErr & Mid(strOriginalErr, p, q - p)
  End If
  
  If InStr(1, strOriginalErr, "Violacion de restricción UNIQUE KEY") > 0 Then
    strErr = "No se puede insertar un valor duplicado para la"
    
    strErr = strErr & " regla de validación "
    p = InStr(1, strOriginalErr, "restricción UNIQUE KEY ") + Len("restricción UNIQUE KEY ")
    q = InStr(p, strOriginalErr, ".")
    strErr = strErr & Mid(strOriginalErr, p, q - p) & " de la tabla"
    
    p = InStr(1, strOriginalErr, "en el objeto ") + Len("en el objeto")
    q = InStr(p, strOriginalErr, ".")
    strErr = strErr & Mid(strOriginalErr, p, q - p)
  End If
  
  ' Para sacar el texto 'changed database...' que aparece
  ' cuando hacemos que gDB se reconecte
  '
  If InStr(1, strOriginalErr, _
           "[Microsoft][ODBC SQL Server Driver][SQL Server]Changed database context to ") Then
    strOriginalErr = Replace(strOriginalErr, _
                             "[Microsoft][ODBC SQL Server Driver][SQL Server]Changed database context to ", _
                             vbNullString)
  End If
  If InStr(1, strOriginalErr, _
           "[Microsoft][ODBC SQL Server Driver][SQL Server]Changed language setting to us_english.") Then
    strOriginalErr = Replace(strOriginalErr, _
                             "[Microsoft][ODBC SQL Server Driver][SQL Server]Changed language setting to us_english.", _
                             vbNullString)
  End If
  If InStr(1, strOriginalErr, "[Microsoft][ODBC SQL Server Driver][SQL Server]") Then
    strOriginalErr = Replace(strOriginalErr, "[Microsoft][ODBC SQL Server Driver][SQL Server]", vbNullString)
  End If
  
  If strErr <> vbNullString Then
    rtnMsg = strErr
  Else
    rtnMsg = strOriginalErr
  End If
  
  pProcessError = strErr <> vbNullString
End Function
' construccion - destruccion


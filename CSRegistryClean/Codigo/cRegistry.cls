VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cRegistry"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Public Enum eHKEY
    HKEY_CLASSES_ROOT = &H80000000
    HKEY_CURRENT_USER = &H80000001
    HKEY_LOCAL_MACHINE = &H80000002
    HKEY_USERS = &H80000003
    
    HKEY_PERFORMANCE_DATA = &H80000004
    HKEY_CURRENT_CONFIG = &H80000005
    HKEY_DYN_DATA = &H80000006
    
    HKEY_FIRST = HKEY_CLASSES_ROOT
    HKEY_LAST = HKEY_DYN_DATA
End Enum

Public Enum eHKEYError
    ERROR_SUCCESS = 0
    ERROR_NONE = 0
    ERROR_FILE_NOT_FOUND = 2&
    ERROR_ACCESS_DENIED = 5&

    ERROR_OUTOFMEMORY = 6&
    ERROR_INVALID_PARAMETER = 7&
    ERROR_INVALID_PARAMETERS = 87&
    
    ERROR_MORE_DATA = 234&          'More data is available
    ERROR_NO_MORE_ITEMS = 259&      'No more data is available

    ERROR_BADKEY = 1010&
End Enum

Public Enum eHKEYDataType
    REG_NONE = 0&               'No value type
    REG_SZ = 1&                 'Unicode null terminated string
    REG_EXPAND_SZ = 2           'Unicode null terminated string
                                '(with environment variable references)
    REG_BINARY = 3              'Free form binary
    REG_DWORD = 4               '32-bit number
    REG_DWORD_LITTLE_ENDIAN = 4 '32-bit number (same as REG_DWORD)
    REG_DWORD_BIG_ENDIAN = 5    '32-bit number
    REG_LINK = 6                'Symbolic Link (unicode)
    REG_MULTI_SZ = 7            'Multiple Unicode strings
    REG_RESOURCE_LIST = 8       'Resource list in the resource map
    REG_FULL_RESOURCE_DESCRIPTOR = 9    'Resource list in the hardware description
    REG_RESOURCE_REQUIREMENTS_LIST = 10
End Enum

' Standard rights, used later below
Const SYNCHRONIZE = &H100000
Const READ_CONTROL = &H20000
Const STANDARD_RIGHTS_ALL = &H1F0000
Const STANDARD_RIGHTS_REQUIRED = &HF0000
Const STANDARD_RIGHTS_EXECUTE = (READ_CONTROL)
Const STANDARD_RIGHTS_READ = (READ_CONTROL)
Const STANDARD_RIGHTS_WRITE = (READ_CONTROL)

' Security Access Mask
Public Enum eREGSAM
                                    'Permission to:
    KEY_QUERY_VALUE = &H1           '   query subkey data
    KEY_SET_VALUE = &H2             '   set subkey data
    KEY_CREATE_SUB_KEY = &H4        '   create subkeys
    KEY_ENUMERATE_SUB_KEYS = &H8    '   enumerate subkeys
    KEY_NOTIFY = &H10               '   for change notification
    KEY_CREATE_LINK = &H20          '   create a symbolic link

    KEY_READ = ((STANDARD_RIGHTS_READ Or KEY_QUERY_VALUE Or KEY_ENUMERATE_SUB_KEYS Or KEY_NOTIFY) And (Not SYNCHRONIZE))
    KEY_WRITE = ((STANDARD_RIGHTS_WRITE Or KEY_SET_VALUE Or KEY_CREATE_SUB_KEY) And (Not SYNCHRONIZE))

    KEY_EXECUTE = ((KEY_READ) And (Not SYNCHRONIZE))

    KEY_ALL_ACCESS = ((STANDARD_RIGHTS_ALL Or KEY_QUERY_VALUE Or KEY_SET_VALUE Or KEY_CREATE_SUB_KEY Or KEY_ENUMERATE_SUB_KEYS Or KEY_NOTIFY Or KEY_CREATE_LINK) And (Not SYNCHRONIZE))
End Enum

Private Declare Function RegOpenKeyEx Lib "advapi32.dll" Alias "RegOpenKeyExA" _
    (ByVal hKey As Long, ByVal lpSubKey As String, _
    ByVal ulOptions As Long, ByVal samDesired As Long, _
    phkResult As Long) As Long

Private Declare Function RegCloseKey Lib "advapi32.dll" _
    (ByVal hKey As Long) As Long

Private Declare Function RegCreateKey Lib "advapi32.dll" Alias "RegCreateKeyA" _
    (ByVal hKey As Long, ByVal lpszSubKey As String, _
    phkResult As Long) As Long

Private Declare Function RegDeleteValue Lib "advapi32.dll" Alias "RegDeleteValueA" _
    (ByVal hKey As Long, ByVal szValueName As String) As Long

Private Declare Function RegQueryValueEx Lib "advapi32.dll" Alias "RegQueryValueExA" _
    (ByVal hKey As Long, ByVal lpszValueName As String, _
    ByVal dwReserved As Long, lpdwType As Long, _
    lpbData As Any, cbData As Long) As Long

Private Declare Function RegSetValueEx Lib "advapi32.dll" Alias "RegSetValueExA" _
    (ByVal hKey As Long, ByVal lpszValueName As String, _
    ByVal dwReserved As Long, ByVal fdwType As Long, _
    lpbData As Any, ByVal cbData As Long) As Long

Private Declare Function RegEnumKey Lib "advapi32.dll" Alias "RegEnumKeyA" (ByVal hKey As Long, ByVal dwIndex As Long, ByVal lpName As String, ByVal cbName As Long) As Long


Private Declare Function RegDeleteKey Lib "advapi32.dll" Alias "RegDeleteKeyA" (ByVal hKey As Long, ByVal lpSubKey As String) As Long


Public Function GetRegString(ByVal skey As String, Optional ByVal sValue As String = "", Optional ByVal hKey As eHKEY = HKEY_CURRENT_USER) As String
    ' Obtener un valor cadena de una entrada del registro
    '
    ' Parámetros de entrada:
    '   sKey    Clave del registro
    '   sValue  Nombre de la entrada que queremos obtener
    '   hKey    Clave principal del registro
    ' Devuelve:
    '   el contenido de esa clave o una cadena vacía
    '
    Dim ret As Long
    Dim hKey2 As Long
    Dim rDT As eHKEYDataType
    Dim sData As String
    Dim lSize As Long

    hKey = ParseKey(skey, hKey)

    ' Abrir la clave indicada
    'ret = RegOpenKeyEx(hKey, sKey, 0&, KEY_QUERY_VALUE, hKey2)
    ret = RegOpenKeyEx(hKey, skey, 0&, KEY_READ, hKey2)

    ' Si todo va bien (se ha podido abrir la clave)
    If ret = ERROR_SUCCESS Then
        ' Leer esa entrada y obtener el tipo de dato, longitud, etc.
        ret = RegQueryValueEx(hKey2, sValue, 0&, rDT, 0&, lSize)
        ' Si es una cadena o REG_EXPAND_SZ                          (28/Dic/01)
        Select Case rDT
        Case REG_SZ, REG_EXPAND_SZ
        'If rDT = REG_SZ Then
            If lSize Then
                sData = String$(lSize - 1, Chr$(0))
                ' Leer la cadena
                ' (el ByVal es porque está declarada como Any)---v
                ret = RegQueryValueEx(hKey2, sValue, 0&, rDT, ByVal sData, lSize)
            End If
        End Select
        ' Cerrar la clave abierta
        RegCloseKey hKey2
    End If
    ' Devolver el valor leído
    GetRegString = sData
End Function

Private Function ParseKey(skey As String, _
                          Optional ByVal hKey As eHKEY = HKEY_CURRENT_USER _
                          ) As eHKEY
    '--------------------------------------------------------------------------
    ' Esta función se usa internamente (privada) para convertir una cadena
    ' en la correspondiente clave raiz.
    ' El segundo parámetro es para poder usarlo en caso que se pase como
    ' parámetro, pero normalmente será totalmente opcional.
    '
    ' En sKey se devolverá el valor de la clave una vez quitada la clave
    ' principal.
    '
    '--------------------------------------------------------------------------
    ' NOTA del 14/Oct/98
    '       En sKey se debe especificar el nombre de la clave raiz.
    '       La utilidad de esta función es que devuelve el valor de esa
    '       clave raiz y se usará en caso de que no sepamos que clave es.
    '       Si ya sabes el valor de la clave raiz, no es necesario que
    '       uses esta función.
    '----------------------------------------------------------------------
    Dim i As Long
    Dim sRootKey As String
    '
    ' Si tiene el separador del final, quitárselo                   (23/Nov/00)
    skey = Trim$(skey)
    If Right$(skey, 1) = "\" Then
        skey = Left$(skey, Len(skey) - 1)
    End If
    ' Comprobar si se indica la clave principal en sKey
    i = InStr(skey, "HKEY_")
    If i Then
        i = InStr(skey, "\")
        If i Then
            sRootKey = Left$(skey, i - 1)
            skey = Mid$(skey, i + 1)
        Else
            sRootKey = skey
            skey = ""
        End If
    ' Por si se usan abreviaturas de las claves
    ElseIf Left$(skey, 5) = "HKCR\" Then
        sRootKey = "HKEY_CLASSES_ROOT"
        skey = Mid$(skey, 6)
    ElseIf Left$(skey, 5) = "HKCU\" Then
        sRootKey = "HKEY_CURRENT_USER"
        skey = Mid$(skey, 6)
    ElseIf Left$(skey, 5) = "HKLM\" Then
        sRootKey = "HKEY_LOCAL_MACHINE"
        skey = Mid$(skey, 6)
    ElseIf Left$(skey, 4) = "HKU\" Then
        sRootKey = "HKEY_USERS"
        skey = Mid$(skey, 5)
    ElseIf Left$(skey, 5) = "HKCC\" Then
        sRootKey = "HKEY_CURRENT_CONFIG"
        skey = Mid$(skey, 6)
    ElseIf Left$(skey, 5) = "HKDD\" Then
        sRootKey = "HKEY_DYN_DATA"
        skey = Mid$(skey, 6)
    ElseIf Left$(skey, 5) = "HKPD\" Then
        sRootKey = "HKEY_PERFORMANCE_DATA"
        skey = Mid$(skey, 6)
    Else
        ' Nos aseguramos que kKey tenga el valor correcto
        Select Case hKey
        'Case HKEY_CLASSES_ROOT, HKEY_CURRENT_USER, HKEY_LOCAL_MACHINE, HKEY_USERS, HKEY_CURRENT_CONFIG, HKEY_DYN_DATA
        Case HKEY_FIRST To HKEY_LAST
            'nada que hacer, todo correcto
        Case Else
            ' Asignamos el valor por defecto
            hKey = HKEY_CLASSES_ROOT
        End Select
    End If
    ' Si se ha indicado el nombre de la clave raiz
    If Len(sRootKey) Then
        Select Case sRootKey
        Case "HKEY_CLASSES_ROOT"
            hKey = HKEY_CLASSES_ROOT
        Case "HKEY_CURRENT_USER"
            hKey = HKEY_CURRENT_USER
        Case "HKEY_LOCAL_MACHINE"
            hKey = HKEY_LOCAL_MACHINE
        Case "HKEY_USERS"
            hKey = HKEY_USERS
        Case "HKEY_CURRENT_CONFIG"
            hKey = HKEY_CURRENT_CONFIG
        Case "HKEY_DYN_DATA"
            hKey = HKEY_DYN_DATA
        Case "HKEY_PERFORMANCE_DATA"
            hKey = HKEY_PERFORMANCE_DATA
        Case Else
            hKey = HKEY_CLASSES_ROOT
        End Select
    End If

    ParseKey = hKey
End Function

Public Function SetReg(ByVal skey As String, ByVal sName As String, _
                       Optional ByVal vValue As Variant, _
                       Optional ByVal hKey As eHKEY = HKEY_CURRENT_USER, _
                       Optional ByVal RegDataType As eHKEYDataType = REG_SZ, _
                       Optional ByVal bCreateKey As Boolean = True) As eHKEYError
    ' Asignar un valor en el registro
    '
    ' Parámetros:
    '   sKey        Clave a la que se asignará el valor
    '   sName       Nombre de la entrada a asignar el valor
    '   vValue      Valor a asignar, el tipo se debe corresponder con el
    '               tipo indicado en el parámetro RegDataType
    '   hKey        Clave principal del registro.
    '               Si en sKey se incluye, no es necesario especificarla
    '   RegDataType Tipo de dato a asignar
    '   bCreateKey  Si no existe la clave, crearla
    '
    ' Devolverá un valor del tipo: eHKEYError
    '

    Dim lRet As Long
    Dim hKey2 As Long
    Dim cbData As Long
    Dim aData() As Byte
    Dim sData As String
    Dim lData As Long

    ' Convertimos la clave indicada en un valor correcto,
    ' para el caso que se indique la clave raiz en sKey
    hKey = ParseKey(skey, hKey)

    ' Abrir la clave indicada
    lRet = RegOpenKeyEx(hKey, skey, 0&, KEY_WRITE, hKey2)

    ' Si da error, comprobar si se crea la clave
    If lRet <> ERROR_SUCCESS Then
        If bCreateKey Then
            lRet = RegCreateKey(hKey, skey, hKey2)
        End If
    End If
    ' Si se produce error, salir
    If lRet <> ERROR_SUCCESS Then
        SetReg = lRet
        Exit Function
    End If

    ' Asignar el valor
    '
    Select Case RegDataType
    Case REG_BINARY
        aData = vValue
        cbData = UBound(aData)
        lRet = RegSetValueEx(hKey2, sName, 0&, RegDataType, aData(0), cbData)
    Case REG_DWORD
        cbData = 4
        lData = CLng(vValue)
        lRet = RegSetValueEx(hKey2, sName, 0&, RegDataType, lData, cbData)
    Case REG_SZ, REG_EXPAND_SZ
        sData = CStr(vValue)
        If Len(sData) = 0 Then
            sData = ""
        End If
        cbData = Len(sData) + 1
        ' Hay que usar ByVal porque está declarado como Any---v
        lRet = RegSetValueEx(hKey2, sName, 0&, RegDataType, ByVal sData, cbData)
    Case Else
        ' No implementado...
    End Select
    lRet = RegCloseKey(hKey2)

    SetReg = lRet
End Function

Public Function DeleteValue(ByVal skey As String, _
                            ByVal sValue As String, _
                            Optional ByVal hKey As eHKEY = HKEY_CURRENT_USER _
                            ) As eHKEYError
    '--------------------------------------------------------------------------
    ' Borrar el valor indicado                                      (28/Dic/01)
    ' DeleteKey también lo puede hacer,
    ' pero lo pongo por separado para evitar confusiones
    '
    ' Parámetros de entrada:
    '   sKey        SubClave del registro
    '               Se puede especificar el nombre de la clave raiz
    '               que se convertirá al valor adecuado
    '   sValue      Nombre de la entrada que queremos borrar.
    '               No se admiten cadenas vacías
    '   hKey        Clave principal del registro.
    '               Si en sKey se incluye, no es necesario especificarla
    ' Devuelve:
    '   el código devuelto por la operación realizada
    '--------------------------------------------------------------------------
    Dim lRet As eHKEYError
    Dim hKey2 As Long

    ' Nos aseguramos que hKey tenga el valor correcto
    Select Case hKey
    'Case HKEY_CLASSES_ROOT, HKEY_CURRENT_USER, HKEY_LOCAL_MACHINE, HKEY_USERS
    Case HKEY_FIRST To HKEY_LAST
        ' nada que hacer, todo correcto
    Case Else
        ' Asignamos el valor por defecto
        hKey = HKEY_CLASSES_ROOT
    End Select

    hKey = ParseKey(skey)
    lRet = ERROR_NONE
    '
    If Len(sValue) Then
        ' Borrar el valor indicado
        lRet = RegOpenKeyEx(hKey, skey, 0&, KEY_WRITE, hKey2)
        If lRet = ERROR_SUCCESS Then
            lRet = RegDeleteValue(hKey2, sValue)
            Call RegCloseKey(hKey2)
        End If
    End If
    '
    DeleteValue = lRet
End Function

Public Function SearchInTypeLib(ByVal Key, ByVal toSearch As String, ByRef f As Form) As Collection

  Dim oKey As cKey
  Dim Caption As String
  Caption = f.Caption

  Dim rtnc As Collection
  Set rtnc = New Collection

  If Key <> "CLSID" And Key <> "TypeLib" Then
    MsgBox "La clave a buscar debe ser CLSID o TypeLib"
    Exit Function
  End If

  '
  ' Author: tlviewer@yahoo.com
  ' script: EnumTypeLibs.vbs
  ' Description: enum the TypeLibs from the HKCR
  ' keywords: typelib dump enum clsid hive wbem
  '
  ' Date :      06/21/03
  '
  
  
  Dim machine, HKCR, hKey, Reg
  machine = "."
  HKCR = &H80000000
  hKey = HKCR
  
  'on error resume next
  
  Set Reg = GetObject( _
      "winmgmts:{impersonationLevel=impersonate}!\\" _
      & machine & "\root\default:StdRegProv")
  
  ' returns an array containing names of subkeys
  ' under key
  Dim subkeys, rtn, EnumKey
  Dim subkeys1, subkeys2
  
  rtn = Reg.EnumKey(hKey, Key, subkeys)
  If rtn = 0 Then
      EnumKey = subkeys
  Else
      Err.Raise vbObjectError + rtn, "RegistryProvider: ", _
          "Error returned attempting to enumerate keys under " _
          & Key & ": " & rtn
      'WScript.quit 1
  End If
  
  'List1.AddItem "key count=" & UBound(EnumKey)
  ' HKEY_CLASSES_ROOT\TypeLib\{0A055C02-BABE-4480-BB7B-A8EC723CE9C0}\1.0\0\win32
  
  Dim i, j, pos, vallib, valpath
  ' loop over the GUID values for all registered TypeLibs
  For i = 0 To UBound(EnumKey)
    'wscript.echo EnumKey(i)
    
    'If EnumKey(i) = "{23BB8627-0FD5-425F-B76B-E1602DE16120}" Then Stop
    
    rtn = Reg.EnumKey(hKey, Key & "\" & EnumKey(i), subkeys1)
    
    f.Caption = rtn
    DoEvents
    
    'wscript.echo typename(subkeys1), " count=", ubound(subkeys1)
     
     ' a few typelibs are empty GUID's with no subkey collections, skip them
    If Not TypeName(subkeys1) = "Null" Then
    
    ' loop over the versions
    For j = 0 To UBound(subkeys1)
       
      f.Caption = Key & "\" & EnumKey(i) & "\" & subkeys1(j)
      DoEvents
       
      If Key = "TypeLib" Then
       
        ' sanity check: version must be a decimal value containing a decimal point!
        pos = InStr(subkeys1(j), ".")
        If pos < 1 Then Exit For
        '  /* end sanity check  */
        
        ' subkeys2(0) is the language code
        rtn = Reg.EnumKey(hKey, Key & "\" & EnumKey(i) & "\" & subkeys1(j), subkeys2)
        If TypeName(subkeys2) = "Null" Then
           'List1.AddItem "corrupt: no language code at " & EnumKey(i)
           Exit For
        End If
      
        Reg.GetStringValue hKey, _
             Key & "\" & EnumKey(i) & "\" & subkeys1(j), Null, vallib
      
        Reg.GetStringValue hKey, _
             Key & "\" & EnumKey(i) & "\" & subkeys1(j) & "\" & subkeys2(0) & "\" & "win32", Null, valpath
      
      ElseIf Key = "CLSID" Then
      
        ' sanity check: debe ser InprocServer32
        pos = InStr(subkeys1(j), "InprocServer32")
        If pos < 1 Then
        
          pos = InStr(subkeys1(j), "Implemented Categories")
          If pos < 1 Then Exit For
          
          If j = UBound(subkeys1) Then Exit For
          
          pos = InStr(subkeys1(j + 1), "InprocServer32")
          If pos < 1 Then
             'List1.AddItem "corrupt: no language code at " & EnumKey(i)
             Exit For
          End If
          
          Reg.GetStringValue hKey, _
               Key & "\" & EnumKey(i) & "\" & subkeys1(j + 1), Null, valpath
          
        Else
        
        Reg.GetStringValue hKey, _
             Key & "\" & EnumKey(i) & "\" & subkeys1(j), Null, valpath
            
        End If
            
      End If
              
      If Not TypeName(valpath) = "Null" Then
        If InStr(1, LCase$(valpath), LCase$(toSearch)) Then
           Set oKey = New cKey
           
           oKey.Key = EnumKey(i)
           oKey.Description = vallib
           oKey.Path = valpath
           
           rtnc.Add oKey
        End If
      End If
    Next
    Else
       'List1.AddItem "null " & EnumKey(i)
    End If
  Next

  f.Caption = Caption

  Set SearchInTypeLib = rtnc

End Function

Public Function DeleteRegistryKey(ByVal MainKey As String, ByVal Key As String)
  
  Const HKCR = &H80000000
  Dim strKeyPath As String
  
  strKeyPath = MainKey & "\" & Key
  
  DeleteKey HKCR, strKeyPath

End Function


' Delete this key.
Private Sub DeleteKey(ByVal section As Long, ByVal key_name _
    As String)
Dim pos As Integer
Dim parent_key_name As String
Dim parent_hKey As Long

    If Right$(key_name, 1) = "\" Then key_name = _
        Left$(key_name, Len(key_name) - 1)

    ' Delete the key's subkeys.
    DeleteSubkeys section, key_name

    ' Get the parent's name.
    pos = InStrRev(key_name, "\")
    If pos = 0 Then
        ' This is a top-level key.
        ' Delete it from the section.
        RegDeleteKey section, key_name
    Else
        ' This is not a top-level key.
        ' Find the parent key.
        parent_key_name = Left$(key_name, pos - 1)
        key_name = Mid$(key_name, pos + 1)

        ' Open the parent key.
        If RegOpenKeyEx(section, _
            parent_key_name, _
            0&, KEY_ALL_ACCESS, parent_hKey) <> _
                ERROR_SUCCESS _
        Then
            'MsgBox "Error opening parent key"
        Else
            ' Delete the key from its parent.
            RegDeleteKey parent_hKey, key_name

            ' Close the parent key.
            RegCloseKey parent_hKey
        End If
    End If
End Sub

' Delete all the key's subkeys.
Private Sub DeleteSubkeys(ByVal section As Long, ByVal _
    key_name As String)
Dim hKey As Long
Dim subkeys As Collection
Dim subkey_num As Long
Dim length As Long
Dim subkey_name As String

    ' Open the key.
    If RegOpenKeyEx(section, key_name, _
        0&, KEY_ALL_ACCESS, hKey) <> ERROR_SUCCESS _
    Then
        'MsgBox "Error opening key '" & key_name & "'"
        Exit Sub
    End If

    ' Enumerate the subkeys.
    Set subkeys = New Collection
    subkey_num = 0
    Do
        ' Enumerate subkeys until we get an error.
        length = 256
        subkey_name = Space$(length)
        If RegEnumKey(hKey, subkey_num, _
            subkey_name, length) _
                <> ERROR_SUCCESS Then Exit Do
        subkey_num = subkey_num + 1

        subkey_name = Left$(subkey_name, InStr(subkey_name, _
            Chr$(0)) - 1)
        subkeys.Add subkey_name
    Loop
    
    ' Recursively delete the subkeys and their subkeys.
    For subkey_num = 1 To subkeys.Count
        ' Delete the subkey's subkeys.
        DeleteSubkeys section, key_name & "\" & _
            subkeys(subkey_num)

        ' Delete the subkey.
        RegDeleteKey hKey, subkeys(subkey_num)
    Next subkey_num

    ' Close the key.
    RegCloseKey hKey
End Sub


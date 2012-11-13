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

Public Function GetRegString(ByVal sKey As String, Optional ByVal sValue As String = "", Optional ByVal hKey As eHKEY = HKEY_CURRENT_USER) As String
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

    hKey = ParseKey(sKey, hKey)

    ' Abrir la clave indicada
    'ret = RegOpenKeyEx(hKey, sKey, 0&, KEY_QUERY_VALUE, hKey2)
    ret = RegOpenKeyEx(hKey, sKey, 0&, KEY_READ, hKey2)

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

Private Function ParseKey(sKey As String, _
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
    sKey = Trim$(sKey)
    If Right$(sKey, 1) = "\" Then
        sKey = Left$(sKey, Len(sKey) - 1)
    End If
    ' Comprobar si se indica la clave principal en sKey
    i = InStr(sKey, "HKEY_")
    If i Then
        i = InStr(sKey, "\")
        If i Then
            sRootKey = Left$(sKey, i - 1)
            sKey = Mid$(sKey, i + 1)
        Else
            sRootKey = sKey
            sKey = ""
        End If
    ' Por si se usan abreviaturas de las claves
    ElseIf Left$(sKey, 5) = "HKCR\" Then
        sRootKey = "HKEY_CLASSES_ROOT"
        sKey = Mid$(sKey, 6)
    ElseIf Left$(sKey, 5) = "HKCU\" Then
        sRootKey = "HKEY_CURRENT_USER"
        sKey = Mid$(sKey, 6)
    ElseIf Left$(sKey, 5) = "HKLM\" Then
        sRootKey = "HKEY_LOCAL_MACHINE"
        sKey = Mid$(sKey, 6)
    ElseIf Left$(sKey, 4) = "HKU\" Then
        sRootKey = "HKEY_USERS"
        sKey = Mid$(sKey, 5)
    ElseIf Left$(sKey, 5) = "HKCC\" Then
        sRootKey = "HKEY_CURRENT_CONFIG"
        sKey = Mid$(sKey, 6)
    ElseIf Left$(sKey, 5) = "HKDD\" Then
        sRootKey = "HKEY_DYN_DATA"
        sKey = Mid$(sKey, 6)
    ElseIf Left$(sKey, 5) = "HKPD\" Then
        sRootKey = "HKEY_PERFORMANCE_DATA"
        sKey = Mid$(sKey, 6)
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

Public Function SetReg(ByVal sKey As String, ByVal sName As String, _
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
    hKey = ParseKey(sKey, hKey)

    ' Abrir la clave indicada
    lRet = RegOpenKeyEx(hKey, sKey, 0&, KEY_WRITE, hKey2)

    ' Si da error, comprobar si se crea la clave
    If lRet <> ERROR_SUCCESS Then
        If bCreateKey Then
            lRet = RegCreateKey(hKey, sKey, hKey2)
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

Public Function DeleteValue(ByVal sKey As String, _
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

    hKey = ParseKey(sKey)
    lRet = ERROR_NONE
    '
    If Len(sValue) Then
        ' Borrar el valor indicado
        lRet = RegOpenKeyEx(hKey, sKey, 0&, KEY_WRITE, hKey2)
        If lRet = ERROR_SUCCESS Then
            lRet = RegDeleteValue(hKey2, sValue)
            Call RegCloseKey(hKey2)
        End If
    End If
    '
    DeleteValue = lRet
End Function

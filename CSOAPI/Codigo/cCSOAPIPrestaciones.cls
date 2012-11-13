VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cCSOAPIPrestaciones"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cCSOAPIPrestaciones
' 12-07-00

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
' estructuras
' enumeraciones
Public Enum csOAPIPrestacion
    ' Trees:
    csPreOAltaTree = 1
    csPreOBorrarTree = 2
    csPreORenombrarTree = 3
    csPreOAltaBranch = 4
    csPreOBorrarBranch = 5
    csPreORenombrarBranch = 6
    csPreOEditarBranch = 7
    
    ' Permisos:
    csPreOAltaPermiso = 8
    csPreOBorrarPermiso = 9
    csPreOListPermiso = 18
    
    ' Usuarios
    csPreOListUser = 10
    csPreOAltaUser = 11
    csPreOEditarUser = 12
    csPreOBorrarUser = 13
    
    ' Roles
    csPreOListaRol = 14
    csPreOAltaRol = 15
    csPreOEditarRol = 16
    csPreOBorrarRol = 17
   
    csPreONewSysmodulo = 26
    csPreOEditSysmodulo = 19
    csPreODeleteSysmodulo = 20
    csPreOListSysmodulo = 21

    csPreONewTabla = 22
    csPreOEditTabla = 23
    csPreODeleteTabla = 24
    csPreOListTabla = 25
    
    csPreONewSysModuloTCP = 30
    csPreOEditSysModuloTCP = 27
    csPreODeleteSysModuloTCP = 28
    csPreOListSysModuloTCP = 29
End Enum

Public Enum csMenuEnum
  csMenuConfigSys = 1
End Enum
' variables privadas
' Properties publicas
' Properties privadas
' funciones publicas
Public Sub Init()
    
    ' Trees
    gSecurity.Add2 csPreOAltaTree, "Agregar Arboles", "Arboles"
    gSecurity.Add2 csPreOBorrarTree, "Borrar Arboles", "Arboles"
    gSecurity.Add2 csPreORenombrarTree, "Renombrar Arboles", "Arboles"
    
    gSecurity.Add2 csPreOAltaBranch, "Agrega Ramas", "Arboles"
    gSecurity.Add2 csPreOBorrarBranch, "Borrar Ramas", "Arboles"
    gSecurity.Add2 csPreORenombrarBranch, "Renombrar Ramas", "Arboles"
    gSecurity.Add2 csPreOEditarBranch, "Editar Ramas", "Arboles"
    
    ' Permisos
    gSecurity.Add2 csPreOAltaPermiso, "Conceder Permisos", "Permisos"
    gSecurity.Add2 csPreOBorrarPermiso, "Quitar Permisos", "Permisos"
    gSecurity.Add2 csPreOListPermiso, "Listar Permisos", "Permisos"
    
    ' Usuarios
    gSecurity.Add2 csPreOListUser, "Listar Usuarios", "Usuarios"
    gSecurity.Add2 csPreOAltaUser, "Agregar Usuarios", "Usuarios"
    gSecurity.Add2 csPreOEditarUser, "Modificar Usuarios", "Usuarios"
    gSecurity.Add2 csPreOBorrarUser, "Eliminar Usuarios", "Usuarios"
         
    ' Rol
    gSecurity.Add2 csPreOListaRol, "Listar Roles", "Roles"
    gSecurity.Add2 csPreOAltaRol, "Agregar Roles", "Roles"
    gSecurity.Add2 csPreOEditarRol, "Modificar Roles", "Roles"
    gSecurity.Add2 csPreOBorrarRol, "Eliminar Roles", "Roles"

    ' SysModulo
    gSecurity.Add2 csPreONewSysmodulo, "Agregar Sysmodulo", "Sysmodulo"
    gSecurity.Add2 csPreODeleteSysmodulo, "Borrar Sysmodulo", "Sysmodulo"
    gSecurity.Add2 csPreOEditSysmodulo, "Editar Sysmodulo", "Sysmodulo"
    gSecurity.Add2 csPreOListSysmodulo, "Listar Sysmodulo", "Sysmodulo"

    ' Tabla
    gSecurity.Add2 csPreONewTabla, "Agregar Tabla", "Sysmodulo"
    gSecurity.Add2 csPreODeleteTabla, "Borrar Tabla", "Sysmodulo"
    gSecurity.Add2 csPreOEditTabla, "Editar Tabla", "Sysmodulo"
    gSecurity.Add2 csPreOListTabla, "Listar Tabla", "Sysmodulo"
    
    gSecurity.Add2 csPreONewSysModuloTCP, "Agregar SysModuloTCP", "Sysmodulo"
    gSecurity.Add2 csPreODeleteSysModuloTCP, "Borrar SysModuloTCP", "Sysmodulo"
    gSecurity.Add2 csPreOEditSysModuloTCP, "Editar SysModuloTCP", "Sysmodulo"
    gSecurity.Add2 csPreOListSysModuloTCP, "Listar SysModuloTCP", "Sysmodulo"
  
End Sub

' funciones privadas
' construccion - destruccion


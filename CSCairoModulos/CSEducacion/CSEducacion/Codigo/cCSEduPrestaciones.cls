VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cCSEduPrestaciones"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' ccsPreEduPrestaciones
' 18-08-2008

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
Public Enum csPreEduPrestacion

  csPreENewMateria = 37001
  csPreEEditMateria = 37002
  csPreEDeleteMateria = 37003
  csPreEListMateria = 37004
    
  csPreENewAula = 37005
  csPreEEditAula = 37006
  csPreEDeleteAula = 37007
  csPreEListAula = 37008
    
  csPreENewProfesor = 37009
  csPreEEditProfesor = 37010
  csPreEDeleteProfesor = 37011
  csPreEListProfesor = 37012
    
  csPreENewAlumno = 37013
  csPreEEditAlumno = 37014
  csPreEDeleteAlumno = 37015
  csPreEListAlumno = 37016
    
  csPreENewCurso = 37017
  csPreEEditCurso = 37018
  csPreEDeleteCurso = 37019
  csPreEListCurso = 37020
    
End Enum

' variables privadas
' propiedades publicas
' propiedades privadas
' funciones publicas
Public Sub Init()
  
  SecurityAdd csPreENewMateria, "Agregar Materia", "Institutos Educativos"
  SecurityAdd csPreEDeleteMateria, "Borrar Materia", "Institutos Educativos"
  SecurityAdd csPreEEditMateria, "Editar Materia", "Institutos Educativos"
  SecurityAdd csPreEListMateria, "Listar Materia", "Institutos Educativos"

  SecurityAdd csPreENewAula, "Agregar Aula", "Institutos Educativos"
  SecurityAdd csPreEDeleteAula, "Borrar Aula", "Institutos Educativos"
  SecurityAdd csPreEEditAula, "Editar Aula", "Institutos Educativos"
  SecurityAdd csPreEListAula, "Listar Aula", "Institutos Educativos"

  SecurityAdd csPreENewProfesor, "Agregar Profesor", "Institutos Educativos"
  SecurityAdd csPreEDeleteProfesor, "Borrar Profesor", "Institutos Educativos"
  SecurityAdd csPreEEditProfesor, "Editar Profesor", "Institutos Educativos"
  SecurityAdd csPreEListProfesor, "Listar Profesor", "Institutos Educativos"

  SecurityAdd csPreENewAlumno, "Agregar Alumno", "Institutos Educativos"
  SecurityAdd csPreEDeleteAlumno, "Borrar Alumno", "Institutos Educativos"
  SecurityAdd csPreEEditAlumno, "Editar Alumno", "Institutos Educativos"
  SecurityAdd csPreEListAlumno, "Listar Alumno", "Institutos Educativos"

  SecurityAdd csPreENewCurso, "Agregar Curso", "Institutos Educativos"
  SecurityAdd csPreEDeleteCurso, "Borrar Curso", "Institutos Educativos"
  SecurityAdd csPreEEditCurso, "Editar Curso", "Institutos Educativos"
  SecurityAdd csPreEListCurso, "Listar Curso", "Institutos Educativos"

End Sub

' funciones privadas
' construccion - destruccion

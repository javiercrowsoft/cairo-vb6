Attribute VB_Name = "mEduConstantes"
Option Explicit

'--------------------------------------------------------------------------------
' mEduConstantes
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
Private Const C_Module = "mEduConstantes"

Public Enum csMenuEnum
  csMenuConfig = 2999
  csMenuEduMain = 37999
End Enum

Public Const c_Items = "Items"

' Estado
Public Const csTEstado                                As String = "Estado"
Public Const cscEstId                                 As String = "est_id"
Public Const cscEstNombre                             As String = "est_nombre"

' Sucursal
Public Const csTSucursal                              As String = "Sucursal"
Public Const cscSucId                                 As String = "suc_id"
Public Const cscSucNombre                             As String = "suc_nombre"

' Documentos
Public Const csTDocumento                             As String = "Documento"
Public Const cscDocId                                 As String = "doc_id"
Public Const cscDocNombre                             As String = "doc_nombre"

' Tipos de Documento
Public Const csTDocumentoTipo                          As String = "DocumentoTipo"
Public Const cscDoctId                                 As String = "doct_id"
Public Const cscDoctNombre                             As String = "doct_nombre"

' Circuito Contable
Public Const cscCicoId                                As String = "cico_id"
Public Const cscCicoNombre                            As String = "cico_nombre"

' Materia
Public Const csTMateria                               As String = "Materia"
Public Const cscMatId                                 As String = "mat_id"
Public Const cscMatNombre                             As String = "mat_nombre"
Public Const cscMatCodigo                             As String = "mat_codigo"
Public Const cscMatDescrip                            As String = "mat_descrip"

' Aula
Public Const csTAula                                   As String = "Aula"
Public Const cscAulaId                                 As String = "aula_id"
Public Const cscAulaNombre                             As String = "aula_nombre"
Public Const cscAulaCodigo                             As String = "aula_codigo"
Public Const cscAulaDescrip                            As String = "aula_descrip"

' Profesor
Public Const csTProfesor                              As String = "Profesor"
Public Const cscProfId                                As String = "prof_id"
Public Const cscProfCodigo                            As String = "prof_codigo"
Public Const cscProfNombre                            As String = "prof_nombre"
Public Const cscProfLegajo                            As String = "prof_legajo"
Public Const cscProfFechaingreso                      As String = "prof_fechaingreso"
Public Const cscProfDescrip                           As String = "prof_descrip"

' Alumno
Public Const csTAlumno                                As String = "Alumno"
Public Const cscAlumId                                As String = "alum_id"
Public Const cscAlumCodigo                            As String = "alum_codigo"
Public Const cscAlumNombre                            As String = "alum_nombre"
Public Const cscAlumLegajo                            As String = "alum_legajo"
Public Const cscAlumFechaingreso                      As String = "alum_fechaingreso"
Public Const cscAlumDescrip                           As String = "alum_descrip"
Public Const cscAlumEsProspecto                       As String = "alum_esprospecto"
Public Const cscAlumIdReferido                        As String = "alum_id_referido"

' Persona
Public Const csTPersona                               As String = "Persona"
Public Const cscPrsId                                 As String = "prs_id"
Public Const cscPrsNombre                             As String = "prs_nombre"
Public Const cscPrsApellido                           As String = "prs_apellido"
Public Const cscPrsCodigo                             As String = "prs_codigo"
Public Const cscPrsDescrip                            As String = "prs_descrip"
Public Const cscPrsInterno                            As String = "prs_interno"
Public Const cscPrsTelTrab                            As String = "prs_telTrab"
Public Const cscPrsTelCasa                            As String = "prs_telCasa"
Public Const cscPrsCelular                            As String = "prs_celular"
Public Const cscPrsEmail                              As String = "prs_email"
Public Const cscPrsCargo                              As String = "prs_cargo"
Public Const cscPrsFechaNac                           As String = "prs_fechaNac"
Public Const cscPrsDocumento                          As String = "prs_documento"
Public Const cscPrsWeb                                As String = "prs_web"
Public Const cscPrsCodpostal                          As String = "prs_codpostal"
Public Const cscPrsLocalidad                          As String = "prs_localidad"
Public Const cscPrsCalle                              As String = "prs_calle"
Public Const cscPrsCallenumero                        As String = "prs_callenumero"
Public Const cscPrsPiso                               As String = "prs_piso"
Public Const cscPrsDepto                              As String = "prs_depto"

Public Const cscPrsApellidoCasado                     As String = "prs_ApellidoCasado"
Public Const cscPrsTitulo                             As String = "prs_titulo"
Public Const cscPrsIcq                                As String = "prs_icq"
Public Const cscPrsIdNextel                           As String = "prs_idnextel"
Public Const cscPrsMessenger                          As String = "prs_messenger"
Public Const cscPrsAniversario                        As String = "prs_aniversario"
Public Const cscPrsSexo                               As String = "prs_sexo"

'Proveedor
Public Const csTProveedor                              As String = "Proveedor"
Public Const cscProvId                                 As String = "prov_id"
Public Const cscProvNombre                             As String = "prov_nombre"

' Departamento
Public Const csTDepartamento                           As String = "Departamento"
Public Const cscDptoId                                 As String = "dpto_id"
Public Const cscDptoNombre                             As String = "dpto_nombre"

' PersonaDocumentoTipo
Public Const csTPersonaDocumentoTipo                    As String = "PersonaDocumentoTipo"
Public Const cscPrsdtId                                 As String = "prsdt_id"
Public Const cscPrsdtNombre                             As String = "prsdt_nombre"

' Provincia
Public Const csTProvincia                       As String = "Provincia"
Public Const cscProId                           As String = "pro_id"
Public Const cscProNombre                       As String = "pro_nombre"

'Cliente
Public Const csTCliente                                As String = "Cliente"
Public Const cscCliId                                  As String = "cli_id"
Public Const cscCliNombre                              As String = "cli_nombre"

' Proyecto
Public Const cscProyId                                 As String = "proy_id"
Public Const cscProyNombre                             As String = "proy_nombre"

' ClienteContactoTipo
Public Const cscClictId                                 As String = "clict_id"
Public Const cscClictNombre                             As String = "clict_nombre"

' Curso
Public Const csTCurso                                 As String = "Curso"
Public Const cscCurId                                 As String = "cur_id"
Public Const cscCurNombre                             As String = "cur_nombre"
Public Const cscCurCodigo                             As String = "cur_codigo"
Public Const cscCurDescrip                            As String = "cur_descrip"
Public Const cscCurDesde                              As String = "cur_desde"
Public Const cscCurHasta                              As String = "cur_hasta"
Public Const cscProfIdAyudante1                       As String = "prof_id_ayudante1"
Public Const cscProfIdAyudante2                       As String = "prof_id_ayudante2"
Public Const cscProfIdAyudante3                       As String = "prof_id_ayudante3"
Public Const cscProfIdAyudante4                       As String = "prof_id_ayudante4"
Public Const cscProfIdAyudante5                       As String = "prof_id_ayudante5"
Public Const cscProfNombre1                           As String = "prof_nombre1"
Public Const cscProfNombre2                           As String = "prof_nombre2"
Public Const cscProfNombre3                           As String = "prof_nombre3"
Public Const cscProfNombre4                           As String = "prof_nombre4"
Public Const cscProfNombre5                           As String = "prof_nombre5"

' Curso Clase
Public Const csTCursoClase                             As String = "CursoClase"
Public Const cscCurcId                                 As String = "curc_id"
Public Const cscCurcFecha                              As String = "curc_fecha"
Public Const cscCurcDesde                              As String = "curc_desde"
Public Const cscCurcHasta                              As String = "curc_hasta"
Public Const cscCurcHoras                              As String = "curc_horas"

' Curso Item Asistencia
Public Const csTCursoItemAsistencia                     As String = "CursoItemAsistencia"
Public Const cscCuriaId                                 As String = "curia_id"

' Curso Examen
Public Const csTCursoExamen                            As String = "CursoExamen"
Public Const cscCureId                                 As String = "cure_id"
Public Const cscCureFecha                              As String = "cure_fecha"
Public Const cscCureDesde                              As String = "cure_desde"
Public Const cscCureHasta                              As String = "cure_hasta"
Public Const cscCureHoras                              As String = "cure_horas"

' Curso Item
Public Const csTCursoItem                              As String = "CursoItem"
Public Const cscCuriId                                 As String = "curi_id"
Public Const cscCuriCalificacion                       As String = "curi_calificacion"

' Curso Item Calificacion
Public Const csTCursoItemCalificacion                   As String = "CursoItemCalificacion"
Public Const cscCuricId                                 As String = "curic_id"
Public Const cscCuricCalificacion                       As String = "curic_calificacion"

' Estado Civil
Public Const csTEstadoCivil                           As String = "EstadoCivil"
Public Const cscEstcId                                As String = "estc_id"
Public Const cscEstcNombre                            As String = "estc_nombre"

' Nivel de Estudio
Public Const csTNivelEstudio                          As String = "NivelEstudio"
Public Const cscNiveId                                As String = "nive_id"
Public Const cscNiveNombre                            As String = "nive_nombre"

' Profesion
Public Const csTProfesion                             As String = "Profesion"
Public Const cscProfeId                               As String = "profe_id"
Public Const cscProfeNombre                           As String = "profe_nombre"

' Pais
Public Const csTPais                                  As String = "Pais"
Public Const cscPaId                                  As String = "pa_id"
Public Const cscPaNombre                              As String = "pa_nombre"


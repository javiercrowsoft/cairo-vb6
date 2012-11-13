Attribute VB_Name = "mTareaConstantes"
Option Explicit

'--------------------------------------------------------------------------------
' mTareaConstantes
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
Private Const C_Module = "mTareaConstantes"

Public Const csTalonario = 4004

Public Const csTNewTarea = 1
Public Const csTEditTarea = 2

Public Const csTNewHora = 3
Public Const csTEditHora = 4


' Tareas
Public Const csTTarea                                 As String = "Tarea"
Public Const cscTarId                                 As String = "tar_id"
Public Const cscTarIdPadre                            As String = "tar_id_padre"
Public Const cscTarNumero                             As String = "tar_numero"
Public Const cscTarNombre                             As String = "tar_nombre"
Public Const cscTarDescrip                            As String = "tar_descrip"
Public Const cscTarfechaini                           As String = "tar_fechaini"
Public Const cscTarhoraini                            As String = "tar_horaini"
Public Const cscTarfechafin                           As String = "tar_fechafin"
Public Const cscTarFechahorafin                       As String = "tar_fechahorafin"
Public Const cscTarAlarma                             As String = "tar_alarma"
Public Const cscTarFinalizada                         As String = "tar_finalizada"
Public Const cscTarCumplida                           As String = "tar_cumplida"
Public Const cscTarRechazada                          As String = "tar_rechazada"
Public Const cscTarAprobada                           As String = "tar_aprobada"
Public Const cscTarPlantilla                          As String = "tar_plantilla"
Public Const cscUsIdResponsable                       As String = "us_id_responsable"
Public Const cscUsIdAsignador                         As String = "us_id_asignador"
Public Const cscUsIdalta                              As String = "us_id_alta"

' Tarea Estados
Public Const csTTareaEstado                             As String = "TareaEstado"
Public Const cscTarestId                                As String = "tarest_id"
Public Const cscTarestNombre                            As String = "tarest_nombre"
Public Const cscTarestCodigo                            As String = "tarest_codigo"

' Contacto
Public Const csTContacto                               As String = "Contacto"
Public Const cscContId                                 As String = "cont_id"
Public Const cscContApellido                           As String = "cont_apellido"
Public Const cscContNombre                             As String = "cont_nombre"
Public Const cscContCodigo                             As String = "cont_codigo"
Public Const cscContDocumento                          As String = "cont_documento"
Public Const cscContDescrip                            As String = "cont_descrip"
Public Const cscContTel                                As String = "cont_tel"
Public Const cscContCelular                            As String = "cont_celular"
Public Const cscContEmail                              As String = "cont_email"
Public Const cscContCargo                              As String = "cont_cargo"
Public Const cscContDireccion                          As String = "cont_direccion"
Public Const cscContTratamiento                        As String = "cont_tratamiento"
Public Const cscContFax                                As String = "cont_fax"
Public Const cscContTipo                               As String = "cont_tipo"
Public Const cscContFechanac                           As String = "cont_fechanac"
Public Const cscContCategoria                          As String = "cont_categoria"
Public Const cscContCliente                            As String = "cont_cliente"
Public Const cscContProveedor                          As String = "cont_proveedor"
Public Const cscContCodpostal                          As String = "cont_codpostal"
Public Const cscContCiudad                             As String = "cont_ciudad"
Public Const cscContProvincia                          As String = "cont_provincia"

' Ciudad
Public Const cscCiuId                                  As String = "ciu_id"
Public Const cscCiuNombre                              As String = "ciu_nombre"

' Provincia
Public Const cscProId                                  As String = "pro_id"
Public Const cscProNombre                              As String = "pro_nombre"

' Pais
Public Const cscPaId                                   As String = "pa_id"
Public Const cscPaNombre                               As String = "pa_nombre"




' Prioridad
Public Const csTPrioridad                              As String = "Prioridad"
Public Const cscPrioId                                 As String = "prio_id"
Public Const cscPrioNombre                             As String = "prio_nombre"
Public Const cscPrioCodigo                             As String = "prio_codigo"

' ProyectoTareaEstado
Public Const csTProyectoTareaEstado                    As String = "ProyectoTareaEstado"
Public Const cscProyEstId                              As String = "proyest_id"

' Proyecto
Public Const csTProyecto                               As String = "Proyecto"
Public Const cscProyId                                 As String = "proy_id"
Public Const cscProyNombre                             As String = "proy_nombre"
Public Const cscProyCodigo                             As String = "proy_codigo"
Public Const cscProyDescrip                            As String = "proy_descrip"
Public Const cscProyDesde                              As String = "proy_desde"
Public Const cscProyHasta                              As String = "proy_hasta"
Public Const cscProyIdPadre                            As String = "proy_id_padre"
Public Const cscProyLlevaAprobacion                    As String = "proy_llevaAprobacion"
Public Const cscProyFileSize                           As String = "proy_fileSize"
Public Const cscProyPublico                            As String = "proy_publico"

' ProyectoItem
Public Const csTProyectoItem                            As String = "ProyectoItem"
Public Const cscProyIId                                 As String = "proyi_id"
Public Const cscProyINombre                             As String = "proyi_nombre"
Public Const cscProyICodigo                             As String = "proyi_codigo"
Public Const cscProyIDescrip                            As String = "proyi_descrip"

' Objetivo
Public Const csTObjetivo                               As String = "Objetivo"
Public Const cscObjeId                                 As String = "obje_id"
Public Const cscObjeNombre                             As String = "obje_nombre"
Public Const cscObjeCodigo                             As String = "obje_codigo"
Public Const cscObjeDescrip                            As String = "obje_descrip"

' ProyctoPrecio
Public Const csTProyectoPrecio                         As String = "ProyectoPrecio"
Public Const cscProypId                                As String = "proyp_id"
Public Const cscProypPrecio                            As String = "proyp_precio"

' Horas
Public Const csTHora                                   As String = "Hora"
Public Const cscHoraId                                 As String = "hora_id"
Public Const cscHoraTitulo                             As String = "hora_titulo"
Public Const cscHoraDescrip                            As String = "hora_descrip"
Public Const cscHoraFecha                              As String = "hora_fecha"
Public Const cscHoraDesde                              As String = "hora_desde"
Public Const cscHoraHasta                              As String = "hora_hasta"
Public Const cscHoraHoras                              As String = "hora_horas"
Public Const cscHoraMinutos                            As String = "hora_minutos"
Public Const cscHoraPendiente                          As String = "hora_pendiente"
Public Const cscHoraFacturable                         As String = "hora_facturable"

' Producto
Public Const cscPrId                                   As String = "pr_id"
Public Const cscPrNombreVenta                          As String = "pr_nombreventa"

' Cliente
Public Const csTCliente                                As String = "Cliente"
Public Const cscCliId                                  As String = "cli_id"
Public Const cscCliNombre                              As String = "cli_nombre"

' Cliente Sucursal
Public Const cscClisId                                 As String = "clis_id"
Public Const cscClisNombre                             As String = "clis_nombre"

' Proveedor
Public Const csTProveedor                              As String = "Proveedor"
Public Const cscProvId                                 As String = "prov_id"
Public Const cscProvNombre                             As String = "prov_nombre"

' Agenda
Public Const csTAgenda                                 As String = "Agenda"
Public Const cscAgnId                                  As String = "Agn_id"
Public Const cscAgnNombre                              As String = "Agn_nombre"
Public Const cscAgnCodigo                              As String = "Agn_codigo"
Public Const cscAgnDescrip                             As String = "Agn_descrip"

' Departamento
Public Const csTDepartamento                           As String = "Departamento"
Public Const cscDptoId                                 As String = "dpto_id"
Public Const cscDptoNombre                             As String = "dpto_nombre"

' Talonario
Public Const cscTaId                                 As String = "ta_id"
Public Const cscTaNombre                             As String = "ta_nombre"

' Rubro
Public Const cscRubId                                 As String = "rub_id"
Public Const cscRubNombre                             As String = "rub_nombre"
Public Const cscOsNrodoc                              As String = "os_nrodoc"
Public Const cscPrnsCodigo                            As String = "prns_codigo"


-- TODO:EMPRESA
/*---------------------------------------------------------------------
Nombre: Partes diarios agrupados por responsable y fecha
---------------------------------------------------------------------*/

if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_ENV_0010]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_ENV_0010]

go
create procedure DC_CSC_ENV_0010 (
  @@us_id    int,
  @@Fini      datetime,
  @@Ffin      datetime,

  @@Cumplida     smallint,

  @@us_id_responsable    varchar(255),
  @@us_id_asignador     varchar(255),
  @@cont_id             varchar(255),
  @@lgj_id              varchar(255),
  @@cli_id               varchar(255),
  @@prio_id              varchar(255),
  @@tarest_id           varchar(255),

  @@titulo   varchar(1000)

)as 

begin 

set nocount on

/*- ///////////////////////////////////////////////////////////////////////

SEGURIDAD SOBRE USUARIOS EXTERNOS

/////////////////////////////////////////////////////////////////////// */

declare @us_empresaEx tinyint
select @us_empresaEx = us_empresaEx from usuario where us_id = @@us_id

declare @ambas tinyint
set @ambas = 0

/* -///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare  @us_id_responsable    int
declare  @us_id_asignador       int
declare  @cont_id               int
declare  @lgj_id                int
declare  @cli_id               int
declare  @prio_id              int
declare  @tarest_id             int

declare @ram_id_responsable int
declare @ram_id_asignador int
declare @ram_id_contacto int
declare @ram_id_legajo int
declare @ram_id_cliente int
declare @ram_id_prioridad int
declare @ram_id_tareaestado int

declare @tbl_usuarioAsignador int
set @tbl_usuarioAsignador = -3

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@us_id_responsable, @us_id_responsable out, @ram_id_responsable out
exec sp_ArbConvertId @@us_id_asignador, @us_id_asignador out, @ram_id_asignador out
exec sp_ArbConvertId @@cont_id, @cont_id out, @ram_id_contacto out
exec sp_ArbConvertId @@lgj_id, @lgj_id out, @ram_id_legajo out
exec sp_ArbConvertId @@cli_id, @cli_id out, @ram_id_cliente out
exec sp_ArbConvertId @@prio_id, @prio_id out, @ram_id_prioridad out
exec sp_ArbConvertId @@tarest_id, @tarest_id out, @ram_id_tareaestado out

exec sp_GetRptId @clienteID out

if @ram_id_responsable <> 0 begin

  -- exec sp_ArbGetGroups @ram_id_responsable, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_responsable, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_responsable, @clienteID 
  end else 
    set @ram_id_responsable = 0
end

if @ram_id_asignador <> 0 begin

  -- exec sp_ArbGetGroups @ram_id_asignador, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_asignador, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_asignador, @clienteID, @tbl_usuarioAsignador
  end else 
    set @ram_id_asignador = 0
end

if @ram_id_contacto <> 0 begin

  -- exec sp_ArbGetGroups @ram_id_contacto, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_contacto, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_contacto, @clienteID 
  end else 
    set @ram_id_contacto = 0
end

if @ram_id_legajo <> 0 begin

  -- exec sp_ArbGetGroups @ram_id_legajo, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_legajo, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_legajo, @clienteID 
  end else 
    set @ram_id_legajo = 0
end

if @ram_id_cliente <> 0 begin

  -- exec sp_ArbGetGroups @ram_id_cliente, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_cliente, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_cliente, @clienteID 
  end else 
    set @ram_id_cliente = 0
end

if @ram_id_prioridad <> 0 begin

  -- exec sp_ArbGetGroups @ram_id_prioridad, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_prioridad, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_prioridad, @clienteID 
  end else 
    set @ram_id_prioridad = 0
end

if @ram_id_tareaestado <> 0 begin

  -- exec sp_ArbGetGroups @ram_id_tareaestado, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_tareaestado, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_tareaestado, @clienteID 
  end else 
    set @ram_id_tareaestado = 0
end

/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */


select 

  ptd_id,
  'TypeTask'      = '',
  'Fecha inicio'  = ptd_fechaini,
  'Fecha fin'      = ptd_fechafin,
  'Alarma'        = ptd_alarma,
  'Carpeta'       =  case when lgj_titulo <> '' then lgj_titulo else lgj_codigo end,
  'Estado'        = tareaestado.tarest_nombre,
  'Tercero'       = isnull(cliente.cli_nombre, proveedor.prov_nombre),
  'Título'        = ptd_titulo,
  'Asigno'        =  ua.us_nombre,
  'Responsable'   =  ur.us_nombre,
  'Contacto'      =  contacto.cont_nombre,
  'Prioridad'     =  prioridad.prio_nombre,

  'Cumplido'      = case 
                        when ptd_cumplida = 1 then   'Pendiente'
                        when ptd_cumplida = 2 then   'Rechazado'
                        when ptd_cumplida = 3 then   'Cumplido'
                        else         'Sin definir'
                    end,

  'Telefono'  =  case
                  when ptd.cli_id is not null then
                    cli_tel
                  when ptd.prov_id is not null then
                    prov_tel
                 end,

  'Dirección' = case
                  when ptd.cli_id is not null then 
                      ' Calle: '+
                      cli_calle + ' Nro: '+
                      cli_callenumero + ' Piso: '+
                      cli_piso + ' Dpto: '+
                      cli_depto + ' Localidad: '+
                      cli_localidad

                  when ptd.prov_id is not null then 
                      ' Calle: '+
                      prov_calle + ' Nro: '+
                      prov_callenumero + ' Piso: '+
                      prov_piso + ' Dpto: '+
                      prov_depto + ' Localidad: '+
                      prov_localidad
                end,

  'Descripción' = ptd_descrip

from 

    partediario as ptd left join usuario as ua on ptd.us_id_asignador   = ua.us_id
                       left join usuario as ur on ptd.us_id_responsable = ur.us_id
                       left join contacto      on ptd.cont_id           = contacto.cont_id
                       left join prioridad     on ptd.prio_id           = prioridad.prio_id  
                       left join cliente       on ptd.cli_id            = cliente.cli_id
                       left join proveedor     on ptd.prov_id           = proveedor.prov_id
                       left join legajo        on ptd.lgj_id            = legajo.lgj_id
                       left join tareaestado   on ptd.tarest_id         = tareaestado.tarest_id

where 

    -- Filtros
    (
        
          @@Fini <= ptd_fechafin
      and  @@Ffin >= ptd_fechaini

      and  (@@Cumplida    = ptd_cumplida   or @@Cumplida   = @ambas)  

      and (@@titulo           like ptd_titulo  or @@titulo   = '')
    ) 

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (ur.us_id             = @us_id_responsable  or @us_id_responsable=0)
and   (ua.us_id             = @us_id_asignador    or @us_id_asignador=0)

and   (contacto.cont_id     = @cont_id            or @cont_id=0)
and   (legajo.lgj_id        = @lgj_id             or @lgj_id=0)

and   (cliente.cli_id       = @cli_id             or @cli_id=0)

and   (prioridad.prio_id    = @prio_id            or @prio_id=0)
and   (tareaestado.tarest_id = @tarest_id         or @tarest_id=0)

-- Arboles
and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 3 -- usuario
                  and  rptarb_hojaid = ua.us_id
                 ) 
           )
        or 
           (@ram_id_asignador = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = @tbl_usuarioAsignador -- usuario
                  and  rptarb_hojaid = ur.us_id
                 ) 
           )
        or 
           (@ram_id_responsable = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 15001 -- legajo
                  and  rptarb_hojaid = legajo.lgj_id
                 ) 
           )
        or 
           (@ram_id_legajo = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 28 -- cliente
                  and  rptarb_hojaid = cliente.cli_id
                 ) 
           )
        or 
           (@ram_id_cliente = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
     and  tbl_id = 2003 -- prioridad
                  and  rptarb_hojaid = prioridad.prio_id
                 ) 
           )
        or 
           (@ram_id_prioridad = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 2004 -- tareaEstado
                  and  rptarb_hojaid = tareaestado.tarest_id
                 ) 
           )
        or 
           (@ram_id_tareaestado = 0)
       )

  order by ptd_fechaini
end

GO
-- TODO:EMPRESA
/*---------------------------------------------------------------------
Nombre: Resumen de horas para graficos
---------------------------------------------------------------------*/
/*

DC_CSC_PRY_0030
                  1,
                  '20010101',
                  '20100101',
                  '0',
                  '0',
                  '0',
                  '0',
                  '0',
                  '0',
                  0,
                  '',
                  ''
*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_PRY_0030]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_PRY_0030]

go
create procedure DC_CSC_PRY_0030 (

  @@us_id    int,
  @@Fini      datetime,
  @@Ffin      datetime,

  @@cli_id               varchar(255),
  @@proy_id             varchar(255),
  @@proyi_id            varchar(255),
  @@obje_id              varchar(255),
  @@tar_id              varchar(255),
  @@us_id_responsable    varchar(255),

  @@bSoloFacturable     smallint,

  @@descrip  varchar(1000),
  @@titulo   varchar(1000)

)as 

begin

set nocount on

/*- ///////////////////////////////////////////////////////////////////////

SEGURIDAD SOBRE USUARIOS EXTERNOS

/////////////////////////////////////////////////////////////////////// */

declare @us_empresaEx tinyint
select @us_empresaEx = us_empresaEx from usuario where us_id = @@us_id

/* -///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @cli_id int
declare @proy_id int
declare @proyi_id int
declare @obje_id int
declare @tar_id int
declare @us_id_responsable int

declare @ram_id_cliente int
declare @ram_id_proyecto int
declare @ram_id_proyectoitem int
declare @ram_id_objetivo int
declare @ram_id_tarea int
declare @ram_id_responsable int

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@cli_id, @cli_id out, @ram_id_cliente out
exec sp_ArbConvertId @@proy_id, @proy_id out, @ram_id_proyecto out
exec sp_ArbConvertId @@proyi_id, @proyi_id out, @ram_id_proyectoitem out
exec sp_ArbConvertId @@obje_id, @obje_id out, @ram_id_objetivo out
exec sp_ArbConvertId @@tar_id, @tar_id out, @ram_id_tarea out
exec sp_ArbConvertId @@us_id_responsable, @us_id_responsable out, @ram_id_responsable out

exec sp_GetRptId @clienteID out

if @ram_id_cliente <> 0 begin

  -- exec sp_ArbGetGroups @ram_id_cliente, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_cliente, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_cliente, @clienteID 
  end else 
    set @ram_id_cliente = 0
end

if @ram_id_proyecto <> 0 begin

  -- exec sp_ArbGetGroups @ram_id_proyecto, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_proyecto, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_proyecto, @clienteID 
  end else 
    set @ram_id_proyecto = 0
end

if @ram_id_proyectoitem <> 0 begin

  -- exec sp_ArbGetGroups @ram_id_proyectoitem, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_proyectoitem, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_proyectoitem, @clienteID 
  end else 
    set @ram_id_proyectoitem = 0
end

if @ram_id_objetivo <> 0 begin

  -- exec sp_ArbGetGroups @ram_id_objetivo, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_objetivo, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_objetivo, @clienteID 
  end else 
    set @ram_id_objetivo = 0
end

if @ram_id_tarea <> 0 begin

  -- exec sp_ArbGetGroups @ram_id_tarea, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_tarea, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_tarea, @clienteID 
  end else 
    set @ram_id_tarea = 0
end

if @ram_id_responsable <> 0 begin

  -- exec sp_ArbGetGroups @ram_id_responsable, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_responsable, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_responsable, @clienteID 
  end else 
    set @ram_id_responsable = 0
end

/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */


create table #t_horas(Cliente varchar(255), 
                      Proyecto varchar(255), 
                      [Sub Proyecto] varchar(255),
                      Usuario varchar(255),
                      [Tarea Principal] varchar(255),
                      Tarea varchar(255),
                      Objetivo varchar(255),
                      Facturable varchar(10),
                      horas decimal(18,6),
                      importe decimal(18,6)
                      )

insert into #t_horas

select 

      cli_nombre,
      proy_nombre,
      proyi_nombre,
      us_nombre,
      t2.tar_nombre,
      t1.tar_nombre,
      obje_nombre,
      case hora_facturable
        when 0 then 'No'
        else         'Si'
      end,
      Sum(IsNull(convert(decimal(18,2),round(hora_horas + (hora_minutos / 60.0),2)),0)),      
      Sum(IsNull(convert(decimal(18,2),round((hora_horas * proyp_precio) + ((hora_minutos / 60.0) * proyp_precio),2)),0))

from 

    hora h inner join usuario us             on h.us_id    = us.us_id
           inner join cliente cli           on h.cli_id   = cli.cli_id
           inner join proyecto proy         on h.proy_id  = proy.proy_id
           inner join proyectoitem proyi     on h.proyi_id = proyi.proyi_id

           left  join ProyectoPrecio proyp  on     h.us_id    = proyp.us_id
                                              and h.proy_id  = proyp.proy_id

           left  join tarea t1              on h.tar_id         = t1.tar_id
           left  join tarea t2              on t1.tar_id_padre  = t2.tar_id
           left  join objetivo o            on h.obje_id        = o.obje_id
where 

    -- Filtros
    (
        
          @@Fini <= hora_fecha
      and  @@Ffin >= hora_fecha     

      and (h.hora_descrip      like  @@descrip     or @@descrip  = '')
      and (h.hora_titulo      like  @@titulo      or @@titulo   = '')

      and (h.hora_facturable <> 0 or @@bSoloFacturable = 0)
    ) 

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (h.cli_id            = @cli_id             or @cli_id=0)
and   (h.proy_id           = @proy_id            or @proy_id=0)
and   (h.proyi_id          = @proyi_id           or @proyi_id=0)
and   (h.obje_id           = @obje_id            or @obje_id=0)
and   (
       (   h.tar_id = @tar_id 
        or t1.tar_id_padre = @tar_id
        )                                        or @tar_id=0)
and   (h.us_id             = @us_id_responsable  or @us_id_responsable=0)

-- Arboles
and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 28 
                  and  rptarb_hojaid = h.cli_id
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
                  and  tbl_id = 2005 
                  and  rptarb_hojaid = h.proy_id
                 ) 
           )
        or 
           (@ram_id_proyecto = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 2008 
                  and  rptarb_hojaid = h.proyi_id
                 ) 
           )
        or 
           (@ram_id_proyectoitem = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 2009 
                  and  rptarb_hojaid = h.obje_id
                 ) 
           )
        or 
           (@ram_id_objetivo = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 2007 
                  and  (rptarb_hojaid = h.tar_id or rptarb_hojaid = t1.tar_id_padre)
                 ) 
           )
        or 
           (@ram_id_tarea = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 3 
                  and  rptarb_hojaid = h.us_id
                 ) 
           )
        or 
           (@ram_id_responsable = 0)
       )

group by  cli_nombre,
          proy_nombre,
          proyi_nombre,
          us_nombre,
          t2.tar_nombre,
          t1.tar_nombre,
          obje_nombre,
          case hora_facturable
            when 0 then 'No'
            else         'Si'
          end

--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  select 
          8                as Orden,
          Cliente          as Item,
          Sum(horas)      as Horas,
          Sum(importe)    as Importe

  from #t_horas

  group by
            Cliente

  union

  select 
          1                as Orden,
          Proyecto        as Item,
          Sum(horas)      as Horas,
          Sum(importe)    as Importe

  from #t_horas

  group by
            Proyecto

  union

  select 
          2                as Orden,
          [Sub Proyecto]  as Item,
          Sum(horas)      as Horas,
          Sum(importe)    as Importe

  from #t_horas

  group by
            [Sub Proyecto]
  union

  select 
          3                as Orden,
          Usuario          as Item,
          Sum(horas)      as Horas,
          Sum(importe)    as Importe

  from #t_horas

  group by
            Usuario
  union

  select 
          4                    as Orden,
          [Tarea Principal]    as Item,
          Sum(horas)          as Horas,
          Sum(importe)        as Importe

  from #t_horas

  group by
            [Tarea Principal]
  union

  select 
          5                as Orden,
          Tarea            as Item,
          Sum(horas)      as Horas,
          Sum(importe)    as Importe

  from #t_horas

  group by
            Tarea
  union

  select 
          6                as Orden,
          Objetivo        as Item,
          Sum(horas)      as Horas,
          Sum(importe)    as Importe

  from #t_horas

  group by
            Objetivo
  union

  select 
          7                as Orden,
          Facturable      as Item,
          Sum(horas)      as Horas,
          Sum(importe)    as Importe

  from #t_horas

  group by
            Facturable

  order by Orden
end
go
/*

sp_lsdoc_horas 

                0,
                '20000101',
                '20100101',
                '0',
                '0',
                '0',
                '0',
                '0',
                '0',
                '',
                ''

select * from rama where ram_nombre like '%elva%'

select 25.0*(40.0/60.0)

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_horas]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_horas]

go
create procedure sp_lsdoc_horas (
  @@us_id    int,
	@@Fini 		 datetime,
	@@Ffin 		 datetime,

	@@cli_id 							varchar(255),
	@@proy_id 						varchar(255),
	@@proyi_id						varchar(255),
	@@obje_id							varchar(255),
	@@tar_id							varchar(255),
	@@us_id_responsable		varchar(255),

  @@descrip  varchar(1000),
  @@titulo   varchar(1000)

)as 

begin

set nocount on

set @@descrip = replace(@@descrip,'*','%')
set @@titulo = replace(@@titulo,'*','%')


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


select 

	hora_id,
	''                as TypeTask,
  cli_nombre				as Cliente,
	proy_nombre				as Proyecto,
  proyi_nombre			as [Sub Proyecto],
	hora_titulo				as [Título],
	hora_fecha				as Fecha,
	convert(varchar(5),hora_desde,14)	as [Hora Desde],
	convert(varchar(5),hora_hasta,14) as [Hora Hasta],
  convert(varchar(5),convert(datetime,convert(varchar(2),hora_horas) +':'+convert(varchar(2),hora_minutos)),14)
										as Tiempo,
	us_nombre					as Usuario,
	tar_nombre				as Tarea,
  obje_nombre				as Objetivo,
  case hora_facturable
		when 0 then 'No'
    else 'Si'
  end								as Facturable,
	-- Tiene que ser la ultima columna para que funcione bien el ABM de documentos
  convert(decimal(18,2),round((hora_horas * isnull(proyp_precio,0)) + ((hora_minutos / 60.0) * isnull(proyp_precio,0)),2))
										as Importe,
	hora_descrip			as [Descripción]

from 

		hora h			inner join usuario u 						on h.us_id 			= u.us_id
								inner join proyecto proy     		on h.proy_id 		= proy.proy_id
								inner join proyectoitem pri			on h.proyi_id 	= pri.proyi_id
								inner join cliente c            on h.cli_id 		= c.cli_id
					
								left  join tarea t							on h.tar_id 		= t.tar_id
								left  join objetivo o           on h.obje_id 		= o.obje_id
								left  join proyectoprecio proyp on 		proy.proy_id = proyp.proy_id
																									and	u.us_id      = proyp.us_id
where 

		-- Filtros
		(
				
				  @@Fini <= hora_fecha
			and	@@Ffin >= hora_fecha 		

      and (h.hora_descrip			like  @@descrip 	  or @@descrip  = '')
      and (h.hora_titulo			like  @@titulo      or @@titulo   = '')
		) 

	 -- Permisos
	 and (exists (select * from Permiso 
              where pre_id = pre_id_listHora
								and (		 us_id  = @@us_id 
											or exists(select * from usuariorol where rol_id = Permiso.rol_id and us_id = @@us_id)
										)
             )
			)

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (c.cli_id            = @cli_id             or @cli_id=0)
and   (proy.proy_id          = @proy_id            or @proy_id=0)
and   (pri.proyi_id        = @proyi_id           or @proyi_id=0)
and   (o.obje_id           = @obje_id            or @obje_id=0)
and   (t.tar_id            = @tar_id             or @tar_id=0)
and   (u.us_id             = @us_id_responsable  or @us_id_responsable=0)

-- Arboles
and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 28 
                  and  rptarb_hojaid = c.cli_id
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
                  and  rptarb_hojaid = proy.proy_id
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
                  and  rptarb_hojaid = pri.proyi_id
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
                  and  rptarb_hojaid = o.obje_id
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
                  and  rptarb_hojaid = t.tar_id
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
                  and  rptarb_hojaid = u.us_id
							   ) 
           )
        or 
					 (@ram_id_responsable = 0)
			 )

	order by hora_fecha, hora_desde
end
go
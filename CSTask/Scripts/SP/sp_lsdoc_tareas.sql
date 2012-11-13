if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_tareas]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_tareas]
--sp_lsdoc_tareas '19980101','20050901',2,2,2,0,0,0,0,0,0,2
go
create procedure sp_lsdoc_tareas (
  @@us_id   					int,
	@@Fini 							datetime,
	@@Ffin 							datetime,
	@@Finalizada 				tinyint,
	@@Cumplida 					tinyint,
	@@Rechazada					tinyint,
	@@us_id_responsable varchar(255),
	@@us_id_asignador   varchar(255),
	@@cont_id	    			varchar(255),
	@@tarest_id	    		varchar(255),
	@@prio_id	    			varchar(255),
	@@proy_id	    			varchar(255),
	@@activa	    			tinyint,
	@@bPlantillas       tinyint = 0
)
as

set nocount on

begin

declare @proy_id 							int
declare @us_id_responsable 		int
declare @us_id_asignador 			int
declare @cont_id              int
declare @tarest_id            int
declare @prio_id              int

declare @ram_id_proyecto 			int
declare @ram_id_responsable 	int
declare @ram_id_asignador 		int
declare @ram_id_contacto      int
declare @ram_id_estado        int
declare @ram_id_prioridad     int

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@proy_id, 					@proy_id out, 					@ram_id_proyecto out
exec sp_ArbConvertId @@us_id_responsable, @us_id_responsable out, @ram_id_responsable out
exec sp_ArbConvertId @@us_id_asignador, 	@us_id_asignador out, 	@ram_id_asignador out

exec sp_ArbConvertId @@cont_id, 		@cont_id out, 		@ram_id_contacto out
exec sp_ArbConvertId @@tarest_id, 	@tarest_id out, 	@ram_id_estado out
exec sp_ArbConvertId @@prio_id, 		@prio_id out, 		@ram_id_prioridad out

exec sp_GetRptId @clienteID out

if @ram_id_proyecto <> 0 begin

	-- exec sp_ArbGetGroups @ram_id_proyecto, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_proyecto, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_proyecto, @clienteID 
	end else 
		set @ram_id_proyecto = 0
end

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
		exec sp_ArbGetAllHojas @ram_id_asignador, @clienteID 
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

if @ram_id_prioridad <> 0 begin

	-- exec sp_ArbGetGroups @ram_id_prioridad, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_prioridad, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_prioridad, @clienteID 
	end else 
		set @ram_id_prioridad = 0
end

if @ram_id_estado <> 0 begin

	-- exec sp_ArbGetGroups @ram_id_estado, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_estado, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_estado, @clienteID 
	end else 
		set @ram_id_estado = 0
end

declare @ambas tinyint
set @ambas = 2

declare @ahora datetime
set @ahora = getdate()

select 
	t.tar_id,
	''								  as TypeTask,
	t.tar_nombre        as [Título],
	isnull(tp.tar_nombre,
				 t.tar_nombre)
											as [Tarea Principal],
	t.tar_numero        as [Número],
  cli_nombre				  as Cliente,
	t.tar_estado1				as [Primera Alarma],
	t.tar_estado2       as [Segunda Alarma],
	t.tar_fechahorafin  as [Fin de la tarea],
	proy_nombre         as Proyecto,
  proyi_nombre        as [Sub Proyecto],
	obje_nombre         as Objetivo,
	t.tar_fechaini      as [Fecha inicio],
	t.tar_fechafin      as [Fecha fin],
  case 
				when t.tar_finalizada <> 0 then 	'Si'
				else 				'No'
	end								as Finalizada,
	case 
				when t.tar_cumplida <> 0 then 	'Si'
				else 				'No'
	end								as Cumplida,
	case 
				when t.tar_rechazada <> 0 then 	'Si'
				else 				'No'
	end								as Rechazada,
	case 
				when t.activo <> 0 then 	'Si'
				else 				'No'
	end								as Activa,
	cont_nombre				as Contacto,
	prio_nombre				as Prioridad,
	tarest_nombre			as Estado,
	r.us_nombre				as Responsable,
	a.us_nombre				as [Asignada por],
	t.modificado      as [Modificado],

	case t.tar_opcional		
				when 0 then 'No'
				else				'Si'
	end								as Opcional,

	case t.tar_facturable  
				when 1 then 'Facturable'
				when 2 then 'Bonificada'
				when 3 then 'Sin cargo'
	end								as Facturable,

	case t.tar_finalizada
				when 0 then ''
				else				convert(varchar,t.tar_terminada,120)
	end								as Terminada,

	rub_nombre      as Rubro,
	pr_nombreventa	as Equipo,
	prns_codigo 		as Serie,
	alit_nombre     as Tipo,
	dpto_nombre     as Departamento,

	case

		when t.tar_estado1 >  @ahora 																  then 0
		when t.tar_estado1 <= @ahora and t.tar_estado2 > @ahora 			then 1
		when t.tar_estado2 <= @ahora and t.tar_fechahorafin > @ahora	then 2
		when t.tar_fechahorafin <= @ahora and t.tar_finalizada = 0		then 3
		when t.tar_fechahorafin <= @ahora and t.tar_finalizada <> 0		then 4
		else 5

	end	as [Nivel Alarma],
	
	-- Tiene que ser la ultima columna para que funcione bien el ABM de documentos
	t.tar_descrip				as [Descripción]

	from 
		tarea t	inner join proyecto pr				on t.proy_id	 					= pr.proy_id
						left  join usuario r					on t.us_id_responsable  = r.us_id
						left  join usuario a					on t.us_id_asignador    = a.us_id
						left  join prioridad p				on t.prio_id	 					= p.prio_id
						left  join contacto c					on t.cont_id	 					= c.cont_id
						left  join tareaestado te			on t.tarest_id 					= te.tarest_id
						left  join cliente cl					on t.cli_id    					= cl.cli_id
						left  join proyectoitem py		on t.proyi_id  					= py.proyi_id
						left  join objetivo ob				on t.obje_id	 					= ob.obje_id
						left  join tarea tp           on t.tar_id_padre    		= tp.tar_id

						left  join productonumeroserie prns on t.prns_id  = prns.prns_id
						left  join producto pr2             on prns.pr_id = pr2.pr_id

						left  join alarmaitemtipo alit 	on t.alit_id = alit.alit_id
						left  join alarmaitem ali     	on t.ali_id  = ali.ali_id
						left  join rubro rub            on t.rub_id  = rub.rub_id
						left  join departamento dpto    on t.dpto_id = dpto.dpto_id 

	where 

		-- Filtros
		(
				
				  t.tar_fechaini >= @@Fini
			and	t.tar_fechaini <= @@Ffin 		

			and	(@@Finalizada  = t.tar_finalizada or @@Finalizada = @ambas)	
			and	(@@Cumplida    = t.tar_cumplida   or @@Cumplida   = @ambas)	
			and	(@@Rechazada   = t.tar_rechazada  or @@Rechazada  = @ambas)	
			and (@@activa 		 = t.activo 		  or @@activa 	  = @ambas)	

			and ((t.tar_plantilla = 0 and @@bPlantillas = 0) or (t.tar_plantilla <> 0 and @@bPlantillas <> 0))
		) 

		-- Permisos
		and (exists (select * from Permiso 
		          where pre_id = pre_id_listTarea
								and (		 us_id  = @@us_id 
											or exists(select * from usuariorol where rol_id = Permiso.rol_id and us_id = @@us_id)
										)
		         )
			)

and   (t.proy_id           = @proy_id            or @proy_id=0)
and   (t.us_id_responsable = @us_id_responsable  or @us_id_responsable=0)
and   (t.us_id_asignador   = @us_id_asignador    or @us_id_asignador=0)

and   (t.tarest_id  = @tarest_id    or @tarest_id=0)
and   (t.prio_id    = @prio_id      or @prio_id=0)
and   (t.cont_id    = @cont_id      or @cont_id=0)

-- Arboles
and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 2005 
                  and  rptarb_hojaid = pr.proy_id
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
                  and  tbl_id = 3 
                  and  rptarb_hojaid = t.us_id_responsable
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
                  and  tbl_id = 3 
                  and  rptarb_hojaid = t.us_id_asignador
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
                  and  tbl_id = 2004
                  and  rptarb_hojaid = t.tarest_id
							   ) 
           )
        or 
					 (@ram_id_estado = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 2003
                  and  rptarb_hojaid = t.prio_id
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
                  and  tbl_id = 2001 
                  and  rptarb_hojaid = t.cont_id
							   ) 
           )
        or 
					 (@ram_id_contacto = 0)
			 )

  order by t.tar_fechaini, t.os_id, isnull(t.tar_id_padre,0), isnull(ali.ali_secuencia,0)
end



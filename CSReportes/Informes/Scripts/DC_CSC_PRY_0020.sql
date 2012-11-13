-- TODO:EMPRESA
/*---------------------------------------------------------------------
Nombre: Detalle de horas trabajadas
---------------------------------------------------------------------*/
/*

DC_CSC_PRY_0020
                  1,
                  '20010101',
                  '20100101',
                  '0',
                  '0',
                  '0',
                  '0',
                  '0',
                  '0',
                  '0',
                  '',
                  '',
									2
*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_PRY_0020]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_PRY_0020]

go
create procedure DC_CSC_PRY_0020 (
  @@us_id   					int,
	@@Fini 							datetime,
	@@Ffin 							datetime,
	@@Finalizada 				smallint,
	@@Cumplida 					smallint,
	@@Rechazada					smallint,
	@@us_id_responsable varchar(255),
	@@us_id_asignador   varchar(255),
	@@cont_id	    			varchar(255),
	@@tarest_id	    		varchar(255),
	@@prio_id	    			varchar(255),
	@@proy_id	    			varchar(255),
	@@activa	    			smallint
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

declare @ambas tinyint
set @ambas = 2

select 
	t.tar_id,
	''									as TypeTask,
	tp.tar_nombre     	as [Tarea Principal],
	t.tar_numero      	as [Número],
  cli_nombre					as Cliente,
	proy_nombre       	as Proyecto,
  proyi_nombre      	as [Sub Proyecto],
	obje_nombre       	as Objetivo,
	t.tar_nombre        as [Título],
	t.tar_fechaini      as [Fecha inicio],
	t.tar_fechafin      as [Fecha fin],
  case 
				when t.tar_finalizada <> 0 then	(
																				case 
																							when t.tar_cumplida <> 0 then 	'Cumplida'
																							else 				'Rechazada'
																				end
																				)
				else 				'Pendiente'
	end								as [Estado 2],
	case 
				when t.activo <> 0 then 	'Si'
				else 											'No'
	end								as Activa,
	cont_nombre				as Contacto,
	prio_nombre				as Prioridad,
	tarest_nombre			as Estado,
	r.us_nombre				as Responsable,
	a.us_nombre				as [Asignada por],
	
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
	where 

		-- Filtros
		(
				
				  t.tar_fechaini >= @@Fini
			and	t.tar_fechaini <= @@Ffin 		

			and	(@@Finalizada  = t.tar_finalizada or @@Finalizada = @ambas)	
			and	(@@Cumplida    = t.tar_cumplida   or @@Cumplida   = @ambas)	
			and	(@@Rechazada   = t.tar_rechazada  or @@Rechazada  = @ambas)	
			and (@@activa 		 = t.activo 		  or @@activa 	  = @ambas)	
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

  order by t.tar_fechaini

end

go
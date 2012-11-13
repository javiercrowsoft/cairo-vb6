/*---------------------------------------------------------------------
Nombre: Listado de Informes y Reportes asociados por usuario
---------------------------------------------------------------------*/

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DC_CSC_SYS_0040]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_SYS_0040]
GO

/*

DC_CSC_SYS_0040 0,0,0,1

*/


create procedure DC_CSC_SYS_0040 (

  @@us_id    				int,

  @@inf_id   				varchar(255),
  @@us_id2   				varchar(255),
	@@soloinforme     smallint
)as 

begin

	set nocount on
	
	/*- ///////////////////////////////////////////////////////////////////////
	
	INICIO PRIMERA PARTE DE ARBOLES
	
	/////////////////////////////////////////////////////////////////////// */
	
	declare @inf_id   		int
	declare @us_id2   		int
	
	declare @ram_id_informe        int
	declare @ram_id_usuario        int
	
	declare @clienteID int
	declare @IsRaiz    tinyint
	
	exec sp_ArbConvertId @@inf_id,  		 @inf_id out,  			@ram_id_informe out
	exec sp_ArbConvertId @@us_id2,  		 @us_id2 out,  			@ram_id_usuario out
	
	exec sp_GetRptId @clienteID out
	
	if @ram_id_informe <> 0 begin
	
	--	exec sp_ArbGetGroups @ram_id_informe, @clienteID, @@us_id
	
		exec sp_ArbIsRaiz @ram_id_informe, @IsRaiz out
	  if @IsRaiz = 0 begin
			exec sp_ArbGetAllHojas @ram_id_informe, @clienteID 
		end else 
			set @ram_id_informe = 0
	end
	
	if @ram_id_usuario <> 0 begin
	
	--	exec sp_ArbGetGroups @ram_id_usuario, @clienteID, @@us_id
	
		exec sp_ArbIsRaiz @ram_id_usuario, @IsRaiz out
	  if @IsRaiz = 0 begin
			exec sp_ArbGetAllHojas @ram_id_usuario, @clienteID 
		end else 
			set @ram_id_usuario = 0
	end
	
	create table #t_dc_csc_sys_0040 (inf_id int not null)
	
	insert into #t_dc_csc_sys_0040 (inf_id)
	
	select distinct
	
				inf.inf_id 
	
	from Informe inf left join Reporte rpt on inf.inf_id = rpt.inf_id
	
	where 
	
	      (inf.inf_id = @inf_id or @inf_id =0)
	and   (rpt.us_id  = @us_id2 or @us_id2 =0)
	
	-- Arboles
	and   (
						(exists(select rptarb_hojaid 
	                  from rptArbolRamaHoja 
	                  where
	                       rptarb_cliente = @clienteID
	                  and  tbl_id = 7001 
	                  and  rptarb_hojaid = inf.inf_id
								   ) 
	           )
	        or 
						 (@ram_id_informe = 0)
				 )
	
	and   (
						(exists(select rptarb_hojaid 
	                  from rptArbolRamaHoja 
	                  where
	                       rptarb_cliente = @clienteID
	                  and  tbl_id = 3
	                  and  rptarb_hojaid = rpt.us_id
								   ) 
	           )
	        or 
						 (@ram_id_usuario = 0)
				 )
	
	
	select
	
			1         							as 	tipo,
			inf_id									as	inf_id	,
			null								    as	rpt_id	,
			null										as	id	,
			null										as	infp_id	,
			inf_nombre							as	nombre	,
			inf_codigo							as	inf_codigo	,
			inf_storedprocedure			as	inf_storedprocedure	,
			inf_reporte							as	inf_reporte	,
			inf_presentaciondefault	as	inf_presentaciondefault	,
			inf_modulo							as	inf_modulo	,
			case inf_tipo						
				when 1 then 'Reporte'
				when 2 then 'Proceso'		
				else        'Sin definir'
			end											as	inf_tipo	,
			inf_propietario					as	inf_propietario	,
			inf_colocultas					as	inf_colocultas	,
			inf_checkbox						as	inf_checkbox	,
			inf_totalesgrales				as	inf_totalesgrales	,
			inf_connstr							as	inf_connstr	,
			pre_id									as	pre_id	,
			creado									as	creado	,
			modificado							as	modificado	,
			modifico								as	modifico	,
			activo									as	activo	,
			null										as	infp_orden	,
			null										as	infp_tipo	,
			null										as	infp_default	,
			null										as	visible	,
			null										as	infp_sqlstmt	,
			null										as	tbl_id	,
			null										as	rptp_valor	,
			null										as	winfs_operacion	,
			null										as	winfg_pordefecto	,
			null										as	winfh_columna	,
			null										as	winfh_url	,
			null										as	usuario,
			inf_descrip							as	descrip
	
	from Informe inf
	
	where exists (select * from #t_dc_csc_sys_0040 where inf_id = inf.inf_id)
	
	union
	
	select
	
			2         			as tipo,
			inf.inf_id			as	inf_id	,
			null						as	rpt_id	,
			null						as	id	,
			infp_id					as	infp_id	,
			infp_nombre			as	nombre	,
			null						as	inf_codigo	,
			null						as	inf_storedprocedure	,
			null						as	inf_reporte	,
			null						as	inf_presentaciondefault	,
			inf.inf_modulo	as	inf_modulo	,
			null						as	inf_tipo	,
			null						as	inf_propietario	,
			null						as	inf_colocultas	,
			null						as	inf_checkbox	,
			null						as	inf_totalesgrales	,
			null						as	inf_connstr	,
			null						as	pre_id	,
			infp.creado			as	creado	,
			infp.modificado	as	modificado	,
			infp.modifico		as	modifico	,
			null						as	activo	,
			infp_orden			as	infp_orden	,
			case infp_tipo	
				when 1 then 'Fecha'			
				when 2 then 'Help'
				when 3 then 'Numero'
				when 4 then 'SQL'
				when 5 then 'Texto'
				when 6 then 'Lista'
				when 7 then 'Logico'
				else        'Sin definir'
			end								as	infp_tipo	,
			infp_default			as	infp_default	,
			case infp_visible
				when 0 then 'No'
				else        'Si'
			end								as	visible	,
			infp_sqlstmt			as	infp_sqlstmt	,
			tbl_nombre      	as	tbl_id	,
			null							as	rptp_valor	,
			null							as	winfs_operacion	,
			null							as	winfg_pordefecto	,
			null							as	winfh_columna	,
			null							as	winfh_url	,
			null							as	usuario,
			null							as	descrip
	
	from InformeParametro infp inner join Informe inf on infp.inf_id = inf.inf_id
														 left  join Tabla tbl   on infp.tbl_id = tbl.tbl_id
	
	where @@soloInforme = 0
		and exists (select * from #t_dc_csc_sys_0040 where inf_id = inf.inf_id)
	
	union
	
	select
			3         			as tipo,
			inf.inf_id			as	inf_id	,
			null						as	rpt_id	,
			winfs_id				as	id	,
			null						as	infp_id	,
			winfs_nombre 		as	nombre	,
			null						as	inf_codigo	,
			null						as	inf_storedprocedure	,
			null						as	inf_reporte	,
			null						as	inf_presentaciondefault	,
			inf.inf_modulo	as	inf_modulo	,
			null						as	inf_tipo	,
			null						as	inf_propietario	,
			null						as	inf_colocultas	,
			null						as	inf_checkbox	,
			null						as	inf_totalesgrales	,
			null						as	inf_connstr	,
			null						as	pre_id	,
			Infs.creado			as	creado	,
			Infs.modificado	as	modificado	,
			Infs.modifico		as	modifico	,
			null						as	activo	,
			null						as	infp_orden	,
			null						as	infp_tipo	,
			null						as	infp_default	,
			null						as	visible	,
			null						as	infp_sqlstmt	,
			null						as	tbl_id	,
			null						as	rptp_valor	,
			winfs_operacion	as	winfs_operacion	,
			null						as	winfg_pordefecto	,
			null						as	winfh_columna	,
			null						as	winfh_url	,
			null						as	usuario,
			null						as	descrip
	
	from InformeSumaries Infs inner join Informe inf on Infs.inf_id = inf.inf_id
	
	where @@soloInforme = 0
		and exists (select * from #t_dc_csc_sys_0040 where inf_id = inf.inf_id)
	
	union 
	
	select 
			4      					 as tipo,
			inf.inf_id			 as	inf_id	,
			null						 as	rpt_id	,
			winfg_id				 as	id	,
			null						 as	infp_id	,
			winfg_nombre		 as	nombre	,
			null						 as	inf_codigo	,
			null						 as	inf_storedprocedure	,
			null						 as	inf_reporte	,
			null						 as	inf_presentaciondefault	,
			inf.inf_modulo	 as	inf_modulo	,
			null						 as	inf_tipo	,
			null						 as	inf_propietario	,
			null						 as	inf_colocultas	,
			null						 as	inf_checkbox	,
			null						 as	inf_totalesgrales	,
			null					   as	inf_connstr	,
			null						 as	pre_id	,
			Infg.creado			 as	creado	,
			Infg.modificado	 as	modificado	,
			Infg.modifico		 as	modifico	,
			null						 as	activo	,
			null						 as	infp_orden	,
			null						 as	infp_tipo	,
			null						 as	infp_default	,
			null						 as	visible	,
			null						 as	infp_sqlstmt	,
			null						 as	tbl_id	,
			null						 as	rptp_valor	,
			null						 as	winfs_operacion	,
			winfg_pordefecto as	winfg_pordefecto	,
			null						 as	winfh_columna	,
			null						 as	winfh_url	,
			null						 as	usuario,
			null						 as	descrip
	
	from InformeGroups Infg inner join Informe inf on Infg.inf_id = inf.inf_id
	
	where @@soloInforme = 0
		and exists (select * from #t_dc_csc_sys_0040 where inf_id = inf.inf_id)
	
	union
	
	select
	
			5         				as tipo,
			inf.inf_id				as	inf_id	,
			null							as	rpt_id	,
			winfh_id					as	id	,
			null							as	infp_id	,
			winfh_nombre			as	nombre	,
			null							as	inf_codigo	,
			null							as	inf_storedprocedure	,
			null							as	inf_reporte	,
			null							as	inf_presentaciondefault	,
			inf.inf_modulo 		as	inf_modulo	,
			null							as	inf_tipo	,
			null							as	inf_propietario	,
			null							as	inf_colocultas	,
			null							as	inf_checkbox	,
			null							as	inf_totalesgrales	,
			null							as	inf_connstr	,
			null							as	pre_id	,
			Infh.creado				as	creado	,
			Infh.modificado		as	modificado	,
			Infh.modifico			as	modifico	,
			null							as	activo	,
			null							as	infp_orden	,
			null							as	infp_tipo	,
			null							as	infp_default	,
			null							as	visible	,
			null							as	infp_sqlstmt	,
			null							as	tbl_id	,
			null							as	rptp_valor	,
			null							as	winfs_operacion	,
			null							as	winfg_pordefecto	,
			winfh_columna			as	winfh_columna	,
			winfh_url					as	winfh_url	,
			null							as	usuario,
			null							as	descrip
	
	from InformeHiperlinks Infh inner join Informe inf on Infh.inf_id = inf.inf_id
	
	where @@soloInforme = 0
		and exists (select * from #t_dc_csc_sys_0040 where inf_id = inf.inf_id)
	
	union
	
	select
			6         			as tipo,
			inf.inf_id			as	inf_id	,
			null						as	rpt_id	,
			winfo_id				as	id	,
			null						as	infp_id	,
			winfo_nombre		as	nombre	,
			null						as	inf_codigo	,
			null						as	inf_storedprocedure	,
			null						as	inf_reporte	,
			null						as	inf_presentaciondefault	,
			inf.inf_modulo	as	inf_modulo	,
			null						as	inf_tipo	,
			null						as	inf_propietario	,
			null						as	inf_colocultas	,
			null						as	inf_checkbox	,
			null						as	inf_totalesgrales	,
			null						as	inf_connstr	,
			null						as	pre_id	,
			Info.creado			as	creado	,
			Info.modificado	as	modificado	,
			Info.modifico		as	modifico	,
			null						as	activo	,
			null						as	infp_orden	,
			null						as	infp_tipo	,
			null						as	infp_default	,
			null						as	visible	,
			null						as	infp_sqlstmt	,
			null						as	tbl_id	,
			null						as	rptp_valor	,
			null						as	winfs_operacion	,
			null						as	winfg_pordefecto	,
			null						as	winfh_columna	,
			null						as	winfh_url	,
			null						as	usuario,
			null						as	descrip
	
	from InformeOrders InfO inner join Informe inf on Info.inf_id = inf.inf_id
	
	where @@soloInforme = 0
		and exists (select * from #t_dc_csc_sys_0040 where inf_id = inf.inf_id)
	
	union
	
	select
			7         			as tipo,
			inf.inf_id			as	inf_id	,
			rpt_id					as	rpt_id	,
			null						as	id	,
			null						as	infp_id	,
			rpt_nombre			as	nombre	,
			inf.inf_codigo	as	inf_codigo	,
			null						as	inf_storedprocedure	,
			null						as	inf_reporte	,
			null						as	inf_presentaciondefault	,
			inf.inf_modulo	as	inf_modulo	,
			null						as	inf_tipo	,
			null						as	inf_propietario	,
			null						as	inf_colocultas	,
			null						as	inf_checkbox	,
			null						as	inf_totalesgrales	,
			null						as	inf_connstr	,
			null						as	pre_id	,
			rpt.creado			as	creado	,
			rpt.modifico		as	modificado	,
			rpt.modificado	as	modifico	,
			rpt.activo			as	activo	,
			null						as	infp_orden	,
			null						as	infp_tipo	,
			null						as	infp_default	,
			null						as	visible	,
			null						as	infp_sqlstmt	,
			null						as  tbl_id	,
			null						as	rptp_valor	,
			null						as	winfs_operacion	,
			null						as	winfg_pordefecto	,
			null						as	winfh_columna	,
			null						as	winfh_url	,
			us_nombre  			as	usuario,
			rpt_descrip			as	descrip
	
	from Reporte rpt 	inner join Informe inf on rpt.inf_id = inf.inf_id
										inner join Usuario us  on us.us_id = rpt.us_id
	
	where @@soloInforme = 0
		and exists (select * from #t_dc_csc_sys_0040 where inf_id = inf.inf_id)

		and   (rpt.us_id  = @us_id2 or @us_id2 =0)
		and   (
							(exists(select rptarb_hojaid 
		                  from rptArbolRamaHoja 
		                  where
		                       rptarb_cliente = @clienteID
		                  and  tbl_id = 3
		                  and  rptarb_hojaid = rpt.us_id
									   ) 
		           )
		        or 
							 (@ram_id_usuario = 0)
					 )
	
	union
	
	select
			8         			as tipo,
			inf.inf_id 			as	inf_id	,
			rpt.rpt_id			as	rpt_id	,
			rptp_id					as	id	,
			rptp.infp_id		as	infp_id	,
			infp_nombre			as	nombre	,
			null						as	inf_codigo	,
			null						as	inf_storedprocedure	,
			null						as	inf_reporte	,
			null						as	inf_presentaciondefault	,
			inf.inf_modulo	as	inf_modulo	,
			null						as	inf_tipo	,
			null						as	inf_propietario	,
			null						as	inf_colocultas	,
			null						as	inf_checkbox	,
			null						as	inf_totalesgrales	,
			null						as	inf_connstr	,
			null						as	pre_id	,
			rptp.creado			as	creado	,
			rptp.modificado	as	modificado	,
			rptp.modifico		as	modifico	,
			null						as	activo	,
			null						as	infp_orden	,
			null						as	infp_tipo	,
			null						as	infp_default	,
			case rptp_visible
				when 0 then 'No'
				else        'Si'
			end							as	visible	,
			null						as	infp_sqlstmt	,
			null						as	tbl_id	,
			rptp_valor			as	rptp_valor	,
			null						as	winfs_operacion	,
			null						as	winfg_pordefecto	,
			null						as	winfh_columna	,
			null						as	winfh_url	,
			null						as	usuario,
			null						as	descrip
	
	from ReporteParametro rptp  inner join Reporte rpt on rptp.rpt_id = rpt.rpt_id
															inner join Informe inf on rpt.inf_id = inf.inf_id
															inner join InformeParametro infp on rptp.infp_id = infp.infp_id
	where @@soloInforme = 0
		and exists (select * from #t_dc_csc_sys_0040 where inf_id = inf.inf_id)

		and   (rpt.us_id  = @us_id2 or @us_id2 =0)
		and   (
							(exists(select rptarb_hojaid 
		                  from rptArbolRamaHoja 
		                  where
		                       rptarb_cliente = @clienteID
		                  and  tbl_id = 3
		                  and  rptarb_hojaid = rpt.us_id
									   ) 
		           )
		        or 
							 (@ram_id_usuario = 0)
					 )
	
	union
	
	select
			9         			as tipo,
			inf.inf_id 			as	inf_id	,
			null						as	rpt_id	,
			null						as	id	,
			null						as	infp_id	,
			us_nombre				as	nombre	,
			rol_nombre			as	inf_codigo	,
			null						as	inf_storedprocedure	,
			null						as	inf_reporte	,
			null						as	inf_presentaciondefault	,
			inf.inf_modulo	as	inf_modulo	,
			null						as	inf_tipo	,
			null						as	inf_propietario	,
			null						as	inf_colocultas	,
			null						as	inf_checkbox	,
			null						as	inf_totalesgrales	,
			null						as	inf_connstr	,
			null						as	pre_id	,
			per.creado			as	creado	,
			per.modificado	as	modificado	,
			per.modifico		as	modifico	,
			null						as	activo	,
			null						as	infp_orden	,
			null						as	infp_tipo	,
			null						as	infp_default	,
			null						as	visible	,
			null						as	infp_sqlstmt	,
			null						as	tbl_id	,
			null						as	rptp_valor	,
			null						as	winfs_operacion	,
			null						as	winfg_pordefecto	,
			null						as	winfh_columna	,
			null						as	winfh_url	,
			null						as	usuario,
			null						as	descrip
	
	from Informe Inf inner join Permiso per on inf.pre_id = per.pre_id
	
									 left  join Usuario us  on per.us_id = us.us_id
									 left  join Rol 			  on per.rol_id = rol.rol_id
	
	where @@soloInforme = 0
		and exists (select * from #t_dc_csc_sys_0040 where inf_id = inf.inf_id)
	
	order by inf_modulo, inf_id, rpt_id, tipo, inf_nombre

end
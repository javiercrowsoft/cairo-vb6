if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ParteDiarioGetTitleForDoc]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ParteDiarioGetTitleForDoc]

go

create procedure sp_ParteDiarioGetTitleForDoc (
	@@doct_id int,
	@@doc_id  int
)
as

begin


--///////////////////////////////
--
-- FACTURAS DE VENTA
--
--///////////////////////////////

  if @@doct_id in (1,7,9) begin
    
		select 	fv.doct_id, 
						doct_codigo
						+ ' ' + convert(varchar(12),fv_fecha,101) 
						+ ' ' + fv_nrodoc 
						+ ' ' + cli_nombre as info_doc

		from facturaventa fv inner join documentotipo doct on fv.doct_id = doct.doct_id 
												 inner join cliente cli        on fv.cli_id  = cli.cli_id
		where fv_id = @@doc_id

		return

	end 

--///////////////////////////////
--
-- FACTURAS DE COMPRA
--
--///////////////////////////////

  if @@doct_id in (2,8,10) begin
    
    select 	fc.doct_id, 
						doct_codigo
						+ ' ' + convert(varchar(12),fc_fecha,101) 
						+ ' ' + fc_nrodoc 
						+ ' ' + prov_nombre as info_doc

		from facturacompra fc inner join documentotipo doct on fc.doct_id = doct.doct_id 
													inner join proveedor prov     on fc.prov_id = prov.prov_id
		where fc_id = @@doc_id

		return

	end

--///////////////////////////////
--
-- REMITOS DE COMPRA
--
--///////////////////////////////

  if @@doct_id in (4,25) begin
    
    select 	rc.doct_id, 
						doct_codigo
						+ ' ' + convert(varchar(12),rc_fecha,101) 
						+ ' ' + rc_nrodoc 
						+ ' ' + prov_nombre as info_doc

		from remitocompra rc  inner join documentotipo doct on rc.doct_id = doct.doct_id 
													inner join proveedor prov     on rc.prov_id = prov.prov_id
                          inner join condicionpago cpg  on rc.cpg_id  = cpg.cpg_id
		where rc_id = @@doc_id

		return

	end 

--///////////////////////////////
--
-- ORDENES DE COMPRA
--
--///////////////////////////////

  if @@doct_id in (35,36) begin
    
    select 	oc.doct_id, 
						doct_codigo
						+ ' ' + convert(varchar(12),oc_fecha,101) 
						+ ' ' + oc_nrodoc 
						+ ' ' + prov_nombre as info_doc

		from ordencompra oc 	inner join documentotipo doct on oc.doct_id = doct.doct_id 
													inner join proveedor prov     on oc.prov_id = prov.prov_id
                          inner join condicionpago cpg  on oc.cpg_id  = cpg.cpg_id
		where oc_id = @@doc_id

		return

	end 

--///////////////////////////////
--
-- PEDIDOS DE COMPRA
--
--///////////////////////////////

  if @@doct_id in (6,23) begin
    
    select 	pc.doct_id, 
						doct_codigo
						+ ' ' + convert(varchar(12),pc_fecha,101) 
						+ ' ' + pc_nrodoc 
						+ ' ' + us_nombre as info_doc

		from pedidocompra pc 	inner join documentotipo doct on pc.doct_id = doct.doct_id 
													inner join usuario us     		on pc.us_id = us.us_id
		where pc_id = @@doc_id

		return

	end 

--///////////////////////////////
--
-- REMITOS DE VENTA
--
--///////////////////////////////

  if @@doct_id in (3,24) begin
    
		select 	rv.doct_id, 
						doct_codigo
						+ ' ' + convert(varchar(12),rv_fecha,101) 
						+ ' ' + rv_nrodoc 
						+ ' ' + cli_nombre as info_doc

		from remitoventa rv 	inner join documentotipo doct on rv.doct_id = doct.doct_id 
												  inner join cliente cli        on rv.cli_id  = cli.cli_id
                          inner join condicionpago cpg  on rv.cpg_id  = cpg.cpg_id
		where rv_id = @@doc_id

		return

	end

--///////////////////////////////
--
-- PEDIDOS DE VENTA
--
--///////////////////////////////

  if @@doct_id in (5,22) begin
    
		select 	pv.doct_id, 
						doct_codigo
						+ ' ' + convert(varchar(12),pv_fecha,101) 
						+ ' ' + pv_nrodoc 
						+ ' ' + cli_nombre as info_doc

		from pedidoventa pv 	inner join documentotipo doct on pv.doct_id = doct.doct_id 
												  inner join cliente cli        on pv.cli_id  = cli.cli_id
                          inner join condicionpago cpg  on pv.cpg_id  = cpg.cpg_id
		where pv_id = @@doc_id

		return

	end

--///////////////////////////////
--
-- ORDEN DE SERVICIO
--
--///////////////////////////////

  if @@doct_id = 42 begin
    
		select 	os.doct_id, 
						doct_codigo
						+ ' ' + convert(varchar(12),os_fecha,101) 
						+ ' ' + os_nrodoc 
						+ ' ' + cli_nombre as info_doc

		from ordenservicio os inner join documentotipo doct on os.doct_id = doct.doct_id 
												  inner join cliente cli        on os.cli_id  = cli.cli_id
                          inner join condicionpago cpg  on os.cpg_id  = cpg.cpg_id
		where os_id = @@doc_id

		return

	end 

--///////////////////////////////
--
-- PARTE DE REPARACION
--
--///////////////////////////////

  if @@doct_id = 43 begin
    
		select 	prp.doct_id, 
						doct_codigo
						+ ' ' + convert(varchar(12),prp_fecha,101) 
						+ ' ' + prp_nrodoc 
						+ ' ' + cli_nombre as info_doc

		from partereparacion prp inner join documentotipo doct on prp.doct_id = doct.doct_id 
												 		 inner join cliente cli        on prp.cli_id  = cli.cli_id
                         		 inner join condicionpago cpg  on prp.cpg_id  = cpg.cpg_id
		where prp_id = @@doc_id

		return

	end 

--///////////////////////////////
--
-- PRESUPUESTOS DE VENTA
--
--///////////////////////////////

  if @@doct_id in (11,39) begin
    
		select 	prv.doct_id, 
						doct_codigo
						+ ' ' + convert(varchar(12),prv_fecha,101) 
						+ ' ' + prv_nrodoc 
						+ ' ' + cli_nombre as info_doc

		from presupuestoventa prv 	inner join documentotipo doct on prv.doct_id = doct.doct_id 
												  			inner join cliente cli        on prv.cli_id  = cli.cli_id
                          			inner join condicionpago cpg  on prv.cpg_id  = cpg.cpg_id
		where prv_id = @@doc_id

		return

	end

--///////////////////////////////
--
-- COBRANZAS
--
--///////////////////////////////

  if @@doct_id = 13 begin
    
		select 	cobz.doct_id, 
						doct_codigo
						+ ' ' + convert(varchar(12),cobz_fecha,101) 
						+ ' ' + cobz_nrodoc 
						+ ' ' + cli_nombre as info_doc

		from cobranza cobz 	inner join documentotipo doct on cobz.doct_id = doct.doct_id 
								  			inner join cliente cli        on cobz.cli_id  = cli.cli_id
		where cobz_id = @@doc_id

		return

	end

--///////////////////////////////
--
-- ORDENES DE PAGO
--
--///////////////////////////////

  if @@doct_id = 16 begin
    
    select 	opg.doct_id, 
						doct_codigo
						+ ' ' + convert(varchar(12),opg_fecha,101) 
						+ ' ' + opg_nrodoc 
						+ ' ' + prov_nombre as info_doc

		from ordenpago opg inner join documentotipo doct on opg.doct_id = doct.doct_id 
											 inner join proveedor prov     on opg.prov_id = prov.prov_id
		where opg_id = @@doc_id

		return

	end 

--///////////////////////////////
--
-- MOVIMIENTO DE FONDOS
--
--///////////////////////////////

  if @@doct_id = 26 begin
    
		select 	mf.doct_id, 
						doct_codigo
						+ ' ' + convert(varchar(12),mf_fecha,101) 
						+ ' ' + mf_nrodoc 
						+ ' ' + cli_nombre as info_doc

		from movimientofondo mf inner join documentotipo doct on mf.doct_id = doct.doct_id 
								  					inner join cliente cli        on mf.cli_id  = cli.cli_id
		where mf_id = @@doc_id

		return

	end

--///////////////////////////////
--
-- DEPOSITO BANCO
--
--///////////////////////////////

  if @@doct_id = 17 begin
    
		select 	dbco.doct_id, 
						doct_codigo
						+ ' ' + convert(varchar(12),dbco_fecha,101) 
						+ ' ' + dbco_nrodoc 
						+ ' ' + bco_nombre as info_doc

		from depositobanco dbco inner join documentotipo doct on dbco.doct_id = doct.doct_id 
								  					inner join banco bco        	on dbco.bco_id  = bco.bco_id
		where dbco_id = @@doc_id

		return

	end

--///////////////////////////////
--
-- STOCK
--
--///////////////////////////////

  if @@doct_id = 14 begin
    
		select 	st.doct_id, 
						doct_codigo
						+ ' ' + convert(varchar(12),st_fecha,101) 
						+ ' ' + st_nrodoc 
						+ ' ' + d2.depl_nombre
						+ ' ' + d1.depl_nombre as info_doc

		from stock st inner join documentotipo doct on st.doct_id = doct.doct_id 
			  					inner join depositologico d1 	on st.depl_id_origen  = d1.depl_id
			  					inner join depositologico d2 	on st.depl_id_destino = d2.depl_id
		where st_id = @@doc_id

		return

	end

--///////////////////////////////
--
-- PARTE DE PRODUCCION
--
--///////////////////////////////

  if @@doct_id in (30,34) begin
    
		select 	ppk.doct_id, 
						doct_codigo
						+ ' ' + convert(varchar(12),ppk_fecha,101) 
						+ ' ' + ppk_nrodoc 
						+ ' ' + depl_nombre as info_doc

		from parteprodkit ppk inner join documentotipo doct  on ppk.doct_id = doct.doct_id 
			  									inner join depositologico depl on ppk.depl_id = depl.depl_id
		where ppk_id = @@doc_id

		return

	end

--///////////////////////////////
--
-- RECUENTO DE STOCK
--
--///////////////////////////////

  if @@doct_id = 38 begin
    
		select 	rs.doct_id, 
						doct_codigo
						+ ' ' + convert(varchar(12),rs_fecha,101) 
						+ ' ' + rs_nrodoc 
						+ ' ' + depl_nombre as info_doc


		from recuentostock rs inner join documentotipo doct  on rs.doct_id = doct.doct_id 
			  									inner join depositologico depl on rs.depl_id = depl.depl_id
		where rs_id = @@doc_id

		return

	end

--///////////////////////////////
--
-- STOCK A PROVEEDOR
--
--///////////////////////////////

  if @@doct_id = 44 begin
    
		select 	stprov.doct_id, 
						doct_codigo
						+ ' ' + convert(varchar(12),stprov_fecha,101) 
						+ ' ' + stprov_nrodoc 
						+ ' ' + prov_nombre
						+ ' - ' + d1.depl_nombre
						+ ' - ' + d2.depl_nombre as info_doc

		from stockproveedor stprov 	inner join documentotipo doct on stprov.doct_id = doct.doct_id 
										  					inner join depositologico d1 	on stprov.depl_id_origen  = d1.depl_id
										  					inner join depositologico d2 	on stprov.depl_id_destino = d2.depl_id
																inner join proveedor prov     on stprov.prov_id = prov.prov_id
		where stprov_id = @@doc_id

		return

	end

--///////////////////////////////
--
-- STOCK A CLIENTE
--
--///////////////////////////////

  if @@doct_id = 45 begin
    
		select 	stcli.doct_id, 
						doct_codigo
						+ ' ' + convert(varchar(12),stcli_fecha,101) 
						+ ' ' + stcli_nrodoc 
						+ ' ' + cli_nombre
						+ ' - ' + d1.depl_nombre
						+ ' - ' + d2.depl_nombre as info_doc


		from stockcliente stcli 	  inner join documentotipo doct on stcli.doct_id = doct.doct_id 
										  					inner join depositologico d1 	on stcli.depl_id_origen  = d1.depl_id
										  					inner join depositologico d2 	on stcli.depl_id_destino = d2.depl_id
															 	inner join cliente cli        on stcli.cli_id  = cli.cli_id
		where stcli_id = @@doc_id

		return

	end

--///////////////////////////////
--
-- TAREA
--
--///////////////////////////////

  if @@doct_id = 2007 begin
    
		select 	2007 		as doct_id, 
						'Tarea' 
						+ ' ' + convert(varchar(12),tar_fechaini,101) 
						+ ' ' + tar_numero
						+ ' ' + isnull(cli_nombre,'') as info_doc

		from tarea tar 	inner join proyecto proy 			on tar.proy_id  = proy.proy_id
				  					left  join proyectoitem proyi on tar.proyi_id = proyi.proyi_id
									 	left  join cliente cli    		on tar.cli_id   = cli.cli_id
		where tar_id = @@doc_id

		return

	end


--///////////////////////////////
--
-- HORA
--
--///////////////////////////////

  if @@doct_id = 2006 begin
    
		select 	2006 		as doct_id, 
						'Hora'  
						+ ' ' + convert(varchar(12),hora_fecha,101) 
						+ ' ' + hora_titulo
						+ ' ' + isnull(cli_nombre,'') as info_doc

		from hora hr 	inner join proyecto proy 			on hr.proy_id  = proy.proy_id
									left  join tarea tar          on hr.tar_id   = tar.tar_id
			  					left  join proyectoitem proyi on hr.proyi_id = proyi.proyi_id
								 	left  join cliente cli    		on hr.cli_id   = cli.cli_id
		where hora_id = @@doc_id

		return

	end

--///////////////////////////////
--
-- PRODUCTO NUMERO SERIE
--
--///////////////////////////////

  if @@doct_id = 1017 begin
    
		select 	1017 		 as doct_id, 
						'Equipo' 
						+ ' ' + convert(varchar(12),prns_fechavto,101) 
						+ ' ' + prns_codigo
						+ ' - ' + prns_codigo2
						+ ' - ' + prns_codigo3
						+ ' - ' + pr_nombrecompra as info_doc

		from productonumeroserie prns inner join producto pr 		on prns.pr_id  = pr.pr_id 
								  								left  join stocklote stl  on prns.stl_id = stl.stl_id
		where prns_id = @@doc_id

		return

	end

--///////////////////////////////
--
-- CALCULO DE DESPACHOS DE IMPORTACION
--
--///////////////////////////////

  if @@doct_id = 1702 begin
    
		select 	1702 as doct_id, 
						'Calculo de Despacho de Importación' 
						+ ' ' + convert(varchar(12),dic_fecha,101) 
						+ ' ' + dic_nrodoc 
						+ ' ' + prov_nombre as info_doc

		from DespachoImpCalculo dic inner join proveedor prov     on dic.prov_id  = prov.prov_id
		where dic_id = @@doc_id

		return

	end

--///////////////////////////////
--
-- LEGAJO
--
--///////////////////////////////

  if @@doct_id = 15001 begin
    
		select 	15001 as doct_id, 
						'Legajo' 
						+ ' ' + convert(varchar(12),lgj_fecha,101) 
						+ ' ' + lgj_codigo
						+ ' ' + isnull(cli_nombre,'') as info_doc

		from legajo lgj left join cliente cli on lgj.cli_id  = cli.cli_id
		where lgj_id = @@doc_id

		return

	end

--///////////////////////////////
--
-- PADRON (UTHGRA)
--
--///////////////////////////////

  if @@doct_id = 32005 begin
    
		select 	32005 as doct_id, 
						'Establecimiento' 
						+ ' [' + pad_codigo
						+ '] ' + pad_nombre as info_doc

		from Padron pad
		where pad_id = @@doc_id

		return

	end

--///////////////////////////////
--
-- CUOTA (UTHGRA)
--
--///////////////////////////////

  if @@doct_id = 32007 begin
    
		select 	32007 as doct_id, 
						'Establecimiento' 
						+ ' [' + pad_codigo
						+ '] ' + pad_nombre as info_doc

		from Cuota cuo inner join Padron pad on cuo.pad_id = pad.pad_id
		where cuo_id = @@doc_id

		return

	end

--///////////////////////////////
--
-- CURSO
--
--///////////////////////////////

  if @@doct_id = 37005 begin
    
		select 	37005 as doct_id, 
						'Curso' 
						+ ' [' + cur_codigo
						+ '] ' + cur_nombre as info_doc

		from Curso cur 
		where cur_id = @@doc_id

		return

	end

--///////////////////////////////
--
-- ALUMNO
--
--///////////////////////////////

  if @@doct_id = 37004 begin
    
		select 	37004 as doct_id, 
						'Alumno' 
						+ ' [' + alum_codigo
						+ '] ' + prs_apellido +', '+prs_nombre as info_doc

		from Alumno alum inner join Persona prs on alum.prs_id = alum.prs_id
		where alum.alum_id = @@doc_id

		return

	end

--///////////////////////////////
--
-- PICKING LIST
--
--///////////////////////////////

  if @@doct_id = 16007 begin
    
		select 	16007 as doct_id, 
						'Lista de Despacho' 
						+ ' ' + pkl_nrodoc
						+ ' - ' + convert(varchar,pkl_fecha,105) as info_doc

		from PickingList
		where pkl_id = @@doc_id

		return

	end

--///////////////////////////////
--
-- HOJA DE RUTA
--
--///////////////////////////////

  if @@doct_id = 16005 begin
    
		select 	16007 as doct_id, 
						'Hoja de Ruta' 
						+ ' ' + hr_nrodoc
						+ ' - ' + convert(varchar,hr_fecha,105) as info_doc

		from HojaRuta
		where hr_id = @@doc_id

		return

	end

end

go
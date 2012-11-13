if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ParteDiarioGetDocInfo]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ParteDiarioGetDocInfo]

go

/*

select * from documentotipo

*/

create procedure sp_ParteDiarioGetDocInfo (
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
    
		select 	doct_nombre, 
						fv_nrodoc as doc_nro,

						fv.cli_id,
						cli_nombre,

						'Condicion de Pago ' + cpg_nombre + char(13) +
						'Fecha             ' + convert(varchar(12),fv_fecha,101) + char(13) +
						'Total             ' + convert(varchar,convert(decimal(18,2),fv_total)) + char(13) +
						'Pendiente         ' + convert(varchar,convert(decimal(18,2),fv_pendiente)) + char(13) +
						'Observaciones     ' + char(13) + fv_descrip

									as doc_descrip


		from facturaventa fv inner join documentotipo doct on fv.doct_id = doct.doct_id 
												 inner join cliente cli        on fv.cli_id  = cli.cli_id
                         inner join condicionpago cpg  on fv.cpg_id  = cpg.cpg_id
		where fv_id = @@doc_id

		return

	end 

--///////////////////////////////
--
-- FACTURAS DE COMPRA
--
--///////////////////////////////

  if @@doct_id in (2,8,10) begin
    
    select 	doct_nombre, 
						fc_nrodoc as doc_nro,

						fc.prov_id,
						prov_nombre,

						'Condicion de Pago ' + cpg_nombre + char(13) +
						'Fecha             ' + convert(varchar(12),fc_fecha,101) + char(13) +
						'Total             ' + convert(varchar,convert(decimal(18,2),fc_total)) + char(13) +
						'Pendiente         ' + convert(varchar,convert(decimal(18,2),fc_pendiente)) + char(13) +
						'Observaciones     ' + char(13) + fc_descrip

									as doc_descrip

		from facturacompra fc inner join documentotipo doct on fc.doct_id = doct.doct_id 
													inner join proveedor prov     on fc.prov_id = prov.prov_id
                          inner join condicionpago cpg  on fc.cpg_id  = cpg.cpg_id
		where fc_id = @@doc_id

		return

	end 

--///////////////////////////////
--
-- REMITOS DE COMPRA
--
--///////////////////////////////

  if @@doct_id in (4,25) begin
    
    select 	doct_nombre, 
						rc_nrodoc as doc_nro,

						rc.prov_id,
						prov_nombre,

						'Condicion de Pago ' + cpg_nombre + char(13) +
						'Fecha             ' + convert(varchar(12),rc_fecha,101) + char(13) +
						'Total             ' + convert(varchar,convert(decimal(18,2),rc_total)) + char(13) +
						'Pendiente         ' + convert(varchar,convert(decimal(18,2),rc_pendiente)) + char(13) +
						'Observaciones     ' + char(13) + rc_descrip

									as doc_descrip

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
    
    select 	doct_nombre, 
						oc_nrodoc as doc_nro,

						oc.prov_id,
						prov_nombre,

						'Condicion de Pago ' + cpg_nombre + char(13) +
						'Fecha             ' + convert(varchar(12),oc_fecha,101) + char(13) +
						'Total             ' + convert(varchar,convert(decimal(18,2),oc_total)) + char(13) +
						'Pendiente         ' + convert(varchar,convert(decimal(18,2),oc_pendiente)) + char(13) +
						'Observaciones     ' + char(13) + oc_descrip

									as doc_descrip

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
    
    select 	doct_nombre, 
						pc_nrodoc as doc_nro,

						pc.us_id,
						us_nombre,

						'Fecha             ' + convert(varchar(12),pc_fecha,101) + char(13) +
						'Total             ' + convert(varchar,convert(decimal(18,2),pc_total)) + char(13) +
						'Pendiente         ' + convert(varchar,convert(decimal(18,2),pc_pendiente)) + char(13) +
						'Observaciones     ' + char(13) + pc_descrip

									as doc_descrip

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
    
		select 	doct_nombre, 
						rv_nrodoc as doc_nro,

						rv.cli_id,
						cli_nombre,

						'Condicion de Pago ' + cpg_nombre + char(13) +
						'Fecha             ' + convert(varchar(12),rv_fecha,101) + char(13) +
						'Total             ' + convert(varchar,convert(decimal(18,2),rv_total)) + char(13) +
						'Pendiente         ' + convert(varchar,convert(decimal(18,2),rv_pendiente)) + char(13) +
						'Observaciones     ' + char(13) + rv_descrip

									as doc_descrip


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
    
		select 	doct_nombre, 
						pv_nrodoc as doc_nro,

						pv.cli_id,
						cli_nombre,

						'Condicion de Pago ' + cpg_nombre + char(13) +
						'Fecha             ' + convert(varchar(12),pv_fecha,101) + char(13) +
						'Total             ' + convert(varchar,convert(decimal(18,2),pv_total)) + char(13) +
						'Pendiente         ' + convert(varchar,convert(decimal(18,2),pv_pendiente)) + char(13) +
						'Observaciones     ' + char(13) + pv_descrip

									as doc_descrip


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
    
		select 	doct_nombre, 
						os_nrodoc as doc_nro,

						os.cli_id,
						cli_nombre,

						'Condicion de Pago ' + cpg_nombre + char(13) +
						'Fecha             ' + convert(varchar(12),os_fecha,101) + char(13) +
						'Total             ' + convert(varchar,convert(decimal(18,2),os_total)) + char(13) +
						'Pendiente         ' + convert(varchar,convert(decimal(18,2),os_pendiente)) + char(13) +
						'Observaciones     ' + char(13) + os_descrip

									as doc_descrip


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
    
		select 	doct_nombre, 
						prp_nrodoc as doc_nro,

						prp.cli_id,
						cli_nombre,

						'Condicion de Pago ' + cpg_nombre + char(13) +
						'Fecha             ' + convert(varchar(12),prp_fecha,101) + char(13) +
						'Total             ' + convert(varchar,convert(decimal(18,2),prp_total)) + char(13) +
						'Observaciones     ' + char(13) + prp_descrip

									as doc_descrip


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
    
		select 	doct_nombre, 
						prv_nrodoc as doc_nro,

						prv.cli_id,
						cli_nombre,

						'Condicion de Pago ' + cpg_nombre + char(13) +
						'Fecha             ' + convert(varchar(12),prv_fecha,101) + char(13) +
						'Total             ' + convert(varchar,convert(decimal(18,2),prv_total)) + char(13) +
						'Pendiente         ' + convert(varchar,convert(decimal(18,2),prv_pendiente)) + char(13) +
						'Observaciones     ' + char(13) + prv_descrip

									as doc_descrip


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
    
		select 	doct_nombre, 
						cobz_nrodoc as doc_nro,

						cobz.cli_id,
						cli_nombre,

						'Fecha             ' + convert(varchar(12),cobz_fecha,101) + char(13) +
						'Total             ' + convert(varchar,convert(decimal(18,2),cobz_total)) + char(13) +
						'Pendiente         ' + convert(varchar,convert(decimal(18,2),cobz_pendiente)) + char(13) +
						'Observaciones     ' + char(13) + cobz_descrip

									as doc_descrip


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
    
    select 	doct_nombre, 
						opg_nrodoc as doc_nro,

						opg.prov_id,
						prov_nombre,

						'Fecha             ' + convert(varchar(12),opg_fecha,101) + char(13) +
						'Total             ' + convert(varchar,convert(decimal(18,2),opg_total)) + char(13) +
						'Pendiente         ' + convert(varchar,convert(decimal(18,2),opg_pendiente)) + char(13) +
						'Observaciones     ' + char(13) + opg_descrip

									as doc_descrip

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
    
		select 	doct_nombre, 
						mf_nrodoc as doc_nro,

						mf.cli_id,
						cli_nombre,

						'Fecha             ' + convert(varchar(12),mf_fecha,101) + char(13) +
						'Total             ' + convert(varchar,convert(decimal(18,2),mf_total)) + char(13) +
						'Pendiente         ' + convert(varchar,convert(decimal(18,2),mf_pendiente)) + char(13) +
						'Observaciones     ' + char(13) + mf_descrip

									as doc_descrip


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
    
		select 	doct_nombre, 
						dbco_nrodoc as doc_nro,

						dbco.bco_id,
						bco_nombre,

						'Fecha             ' + convert(varchar(12),dbco_fecha,101) + char(13) +
						'Total             ' + convert(varchar,convert(decimal(18,2),dbco_total)) + char(13) +
						'Observaciones     ' + char(13) + dbco_descrip

									as doc_descrip


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
    
		select 	doct_nombre, 
						st_nrodoc as doc_nro,

						st.depl_id_origen,
						d1.depl_nombre	as Origen,

						st.depl_id_destino,
						d2.depl_nombre	as Destino,

						'Fecha             ' + convert(varchar(12),st_fecha,101) + char(13) +
						'Observaciones     ' + char(13) + st_descrip

									as doc_descrip


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
    
		select 	doct_nombre, 
						ppk_nrodoc as doc_nro,

						ppk.depl_id,
						depl.depl_nombre	as Origen,

						'Fecha             ' + convert(varchar(12),ppk_fecha,101) + char(13) +
						'Observaciones     ' + char(13) + ppk_descrip

									as doc_descrip


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
    
		select 	doct_nombre, 
						rs_nrodoc as doc_nro,

						rs.depl_id,
						depl.depl_nombre	as Origen,

						'Fecha             ' + convert(varchar(12),rs_fecha,101) + char(13) +
						'Observaciones     ' + char(13) + rs_descrip

									as doc_descrip


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
    
		select 	doct_nombre, 
						stprov_nrodoc as doc_nro,

						stprov.prov_id,
						prov_nombre,

						stprov.depl_id_origen,
						d1.depl_nombre	as Origen,

						stprov.depl_id_destino,
						d2.depl_nombre	as Destino,

						'Fecha             ' + convert(varchar(12),stprov_fecha,101) + char(13) +
						'Observaciones     ' + char(13) + stprov_descrip

									as doc_descrip


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
    
		select 	doct_nombre, 
						stcli_nrodoc as doc_nro,

						stcli.cli_id,
						cli_nombre,

						stcli.depl_id_origen,
						d1.depl_nombre	as Origen,

						stcli.depl_id_destino,
						d2.depl_nombre	as Destino,

						'Fecha             ' + convert(varchar(12),stcli_fecha,101) + char(13) +
						'Observaciones     ' + char(13) + stcli_descrip

									as doc_descrip


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
    
		select 	'Tarea' 	 as doct_nombre, 
						tar_numero as doc_nro,

						tar.cli_id,
						cli_nombre,

						tar.proy_id,
						proy_nombre,

						tar.proyi_id,
						proyi_nombre,

						'Fecha Inicio      ' + convert(varchar(12),tar_fechaini,101) + char(13) +
						'Fecha Fin         ' + convert(varchar(12),tar_fechafin,101) + char(13) +
						'Observaciones     ' + char(13) + tar_descrip

									as doc_descrip


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
    
		select 	'hora' 	 		as doct_nombre, 
						hora_titulo as doc_nro,

						hr.cli_id,
						cli_nombre,

						hr.proy_id,
						proy_nombre,

						hr.proyi_id,
						proyi_nombre,

						hr.tar_id,
						tar_numero,
						tar_nombre,

						'Fecha             ' + convert(varchar(12),hora_fecha,101) + char(13) +
						'Hora Desde        ' + convert(varchar(12),hora_desde,101) + char(13) +
						'Hora Hasta        ' + convert(varchar(12),hora_hasta,101) + char(13) +
						'Observaciones     ' + char(13) + hora_descrip

									as doc_descrip


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
    
		select 	pr_nombrecompra as doct_nombre, 
						prns_codigo as doc_nro,

						prns_codigo2,
						prns_codigo3,

						prns.stl_id,
						stl_codigo,
						stl_nrolote,

						'Fecha Vto         ' + convert(varchar(12),prns_fechavto,101) + char(13) +
						'Observaciones     ' + char(13) + prns_descrip

									as doc_descrip


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
    
		select 	'Calculo de Despacho de Importación' as doct_nombre, 
						dic_nrodoc as doc_nro,
						dic_titulo,

						dic.prov_id,
						prov_nombre,

						'Fecha             ' + convert(varchar(12),dic_fecha,101) + char(13) +
						'Total             ' + convert(varchar,convert(decimal(18,2),dic_total)) + char(13) +
						'Observaciones     ' + char(13) + dic_descrip

									as doc_descrip


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
    
		select 	lgj_titulo as doct_nombre, 
						lgj_codigo as doc_nro,

						lgj.cli_id,
						cli_nombre,

						'Fecha             ' + convert(varchar(12),lgj_fecha,101) + char(13) +
						'Observaciones     ' + char(13) + lgj_descrip

									as doc_descrip


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
    
		select 	'' 	 as doct_nombre, 
						'' 	 as doc_nro,

						0 	 as cli_id,
						''   as cli_nombre,

						''   as doc_descrip

		return

	end

--///////////////////////////////
--
-- CUOTA (UTHGRA)
--
--///////////////////////////////

  if @@doct_id = 32007 begin
    
		select 	'' 	 as doct_nombre, 
						'' 	 as doc_nro,

						0 	 as cli_id,
						''   as cli_nombre,

						''   as doc_descrip

		return

	end

--///////////////////////////////
--
-- CURSO
--
--///////////////////////////////

  if @@doct_id = 37005 begin
    
		select 	'' 	 as doct_nombre, 
						'' 	 as doc_nro,

						0 	 as cli_id,
						''   as cli_nombre,

						''   as doc_descrip

		return

	end

--///////////////////////////////
--
-- ALUMNO
--
--///////////////////////////////

  if @@doct_id = 37004 begin
    
		select 	'' 	 as doct_nombre, 
						'' 	 as doc_nro,

						0 	 as cli_id,
						''   as cli_nombre,

						alum_id,
						prs_apellido + ', ' + prs_nombre as alum_nombre,

						''   as doc_descrip

		from Alumno alum left join Persona prs on alum.prs_id = prs.prs_id
		where alum_id = @@doc_id

		return

	end

end

go